pragma solidity ^0.8.17;

import "./AffineAddition.sol";
import "../Bitmask.sol";
import "../bw6761/G1.sol";
import "../bw6761/Fr.sol";
import "../bls12377/G1.sol";
import "../poly/evaluations/Lagrange.sol";

struct BitmaskPackingCommitments {
    Bw6G1 c_comm;
    Bw6G1 acc_comm;
}

struct SuccinctAccountableRegisterEvaluations {
    Bw6Fr c;
    Bw6Fr acc;
    AffineAdditionEvaluations basic_evaluations;
}

library PackedProtocol {
    using BW6FR for Bw6Fr;
    using BW6FR for Bw6Fr[];
    using BW6G1Affine for Bw6G1;
    using BasicProtocol for AffineAdditionEvaluations;

    function restore_commitment_to_linearization_polynomial(
        SuccinctAccountableRegisterEvaluations memory self,
        Bw6Fr memory phi,
        Bw6Fr memory zeta_minus_omega_inv,
        PartialSumsAndBitmaskCommitments memory commitments,
        BitmaskPackingCommitments memory extra_commitments
    ) internal view returns (
        Bw6G1 memory
    ) {
        Bw6Fr[] memory powers_of_phi = phi.powers(6);
        Bw6G1 memory r_comm = self.basic_evaluations.restore_commitment_to_linearization_polynomial(phi, zeta_minus_omega_inv, commitments.partial_sums);
        r_comm = r_comm.add(
            extra_commitments.acc_comm.mul(powers_of_phi[5])
        );
        r_comm = r_comm.add(
            extra_commitments.c_comm.mul(powers_of_phi[6])
        );
        return r_comm;
    }

    function evaluate_constraint_polynomials(
        SuccinctAccountableRegisterEvaluations memory self,
        Bls12G1 memory apk,
        LagrangeEvaluations memory evals_at_zeta,
        Bw6Fr memory r,
        Bitmask memory bitmask,
        uint64 domain_size
    ) internal view returns (
        Bw6Fr[] memory constraint_polynomial_evals
    ) {
        uint bits_in_bitmask_chunk = 256;
        require(domain_size % bits_in_bitmask_chunk == 0, "!domain_size");
        uint chunks_in_bitmask = domain_size / bits_in_bitmask_chunk;
        require(bitmask.limbs.length == chunks_in_bitmask);
        Bw6Fr memory bits_in_bitmask_chunk_inv = Bw6Fr(0, 256);
        bits_in_bitmask_chunk_inv.inverse();

        Bw6Fr[] memory powers_of_r = r.powers(chunks_in_bitmask - 1);
        Bw6Fr memory r_pow_m = r.mul(powers_of_r[powers_of_r.length - 1]);
        Bw6Fr[] memory bitmask_chunks = new Bw6Fr[](chunks_in_bitmask);
        for (uint i = 0; i < chunks_in_bitmask; i++) {
            bitmask_chunks[i] = Bw6Fr(0, bitmask.limbs[i]);
        }
        require(powers_of_r.length == bitmask_chunks.length, "!len");
        Bw6Fr memory aggregated_bitmask = bitmask_chunks.mul_sum(powers_of_r);

        // A(zw) as fraction
        Bw6Fr memory zeta_omega_pow_m = evals_at_zeta.zeta_omega.pow(chunks_in_bitmask);
        Bw6Fr memory zeta_omega_pow_n = zeta_omega_pow_m.pow(bits_in_bitmask_chunk);
        Bw6Fr memory a_zeta_omega1 = bits_in_bitmask_chunk_inv.mul(zeta_omega_pow_n.sub(BW6FR.one())).mul((zeta_omega_pow_m.sub(BW6FR.one())).inverse());

        // A(zw) as polynomial
        Bw6Fr memory a_zeta_omega2 = bits_in_bitmask_chunk_inv.mul(
            zeta_omega_pow_m.powers(bits_in_bitmask_chunk - 1).sum()
        );

        require(a_zeta_omega1.eq(a_zeta_omega2), "!zeta_omega");
        Bw6Fr memory two = BW6FR.two();
        Bw6Fr memory a = two.add(
            r.mul(
                (two.pow(255).sub(two)).mul(a_zeta_omega1)
            )
        );
        Bw6Fr memory b = self.basic_evaluations.bitmask;
        Bw6Fr memory acc = self.acc;
        Bw6Fr memory c = self.c;

        Bw6Fr memory a6 = evaluate_inner_product_constraint_linearized(
            aggregated_bitmask,
            evals_at_zeta,
            b,
            c,
            acc
        );
        Bw6Fr memory a7 = evaluate_multipacking_mask_constraint_linearized(
            a,
            r_pow_m,
            evals_at_zeta,
            c
        );

        (
            Bw6Fr memory a1,
            Bw6Fr memory a2,
            Bw6Fr memory a3,
            Bw6Fr memory a4,
            Bw6Fr memory a5
        ) = self.basic_evaluations.evaluate_constraint_polynomials(apk, evals_at_zeta);

        Bw6Fr[] memory res = new Bw6Fr[](7);
        res[0] = a1;
        res[1] = a2;
        res[2] = a3;
        res[3] = a4;
        res[4] = a5;
        res[5] = a6;
        res[6] = a7;
        return res;
    }

    function evaluate_inner_product_constraint_linearized(
        Bw6Fr memory bitmask_chunks_aggregated,
        LagrangeEvaluations memory evals_at_zeta,
        Bw6Fr memory b_zeta,
        Bw6Fr memory c_zeta,
        Bw6Fr memory acc_zeta
    ) internal view returns (
        Bw6Fr memory
    ) {
        Bw6Fr memory acc_zeta_omega = BW6FR.zero();
        return acc_zeta_omega.sub(
            acc_zeta
        ).sub(
            b_zeta.mul(c_zeta)
        ).add(
            bitmask_chunks_aggregated.mul(evals_at_zeta.l_last)
        );
    }

    function evaluate_multipacking_mask_constraint_linearized(
        Bw6Fr memory a,
        Bw6Fr memory r_pow_m,
        LagrangeEvaluations memory evals_at_zeta,
        Bw6Fr memory c_zeta
    ) internal view returns (
        Bw6Fr memory
    ) {
        Bw6Fr memory c_zeta_omega = BW6FR.zero();
        return c_zeta_omega.sub(
            c_zeta.mul(a)
        ).sub(
            (BW6FR.one().sub(r_pow_m)).mul(evals_at_zeta.l_last)
        );
    }
}
