pragma solidity ^0.8.17;

import "../bw6761/G1.sol";
import "../bw6761/Fr.sol";
import "../bls12377/G1.sol";
import "../poly/evaluations/Lagrange.sol";

struct PartialSumsCommitments {
    Bw6G1[2] partial_sums;
}

struct PartialSumsAndBitmaskCommitments {
    Bw6G1[2] partial_sums;
    Bw6G1 bitmask;
}

struct AffineAdditionEvaluations {
    Bw6Fr[2] keyset;
    Bw6Fr bitmask;
    Bw6Fr[2] partial_sums;
}

library BasicProtocol {
    using BW6FR for Bw6Fr;
    using BLS12FP for Bls12Fp;
    using BW6G1Affine for Bw6G1;
    using BLS12G1 for Bls12G1;

    function restore_commitment_to_linearization_polynomial(
        AffineAdditionEvaluations memory self,
        Bw6Fr memory phi,
        Bw6Fr memory zeta_minus_omega_inv,
        Bw6G1[2] memory commitments
    ) internal view returns (
        Bw6G1 memory
    ) {
        Bw6Fr memory b = self.bitmask;
        Bw6Fr memory x1 = self.partial_sums[0];
        Bw6Fr memory y1 = self.partial_sums[1];
        Bw6Fr memory x2 = self.keyset[0];
        Bw6Fr memory y2 = self.keyset[1];

        Bw6G1 memory r_comm = BW6G1Affine.zero();
        // X3 := acc_x polynomial
        // Y3 := acc_y polynomial
        // a1_lin = b(x1-x2)^2.X3 + (1-b)Y3
        // a2_lin = b(x1-x2)Y3 + b(y1-y2)X3 + (1-b)X3 // *= phi
        // X3 term = b(x1-x2)^2 + b(y1-y2)phi + (1-b)phi
        // Y3 term = (1-b) + b(x1-x2)phi
        // ...and both multiplied by (\zeta - \omega^{n-1}) // = zeta_minus_omega_inv
        r_comm = r_comm.add(
            commitments[0].mul(
                zeta_minus_omega_inv.mul(
                    (
                        b.mul(x1.sub(x2)).mul(x1.sub(x2))
                    ).add(
                        b.mul(y1.sub(y2)).mul(phi)
                    ).add(
                        (BW6FR.one().sub(b)).mul(phi)
                    )
                )
            )
        );
        r_comm = r_comm.add(
            commitments[1].mul(
                zeta_minus_omega_inv.mul(
                    (
                        BW6FR.one().sub(b)
                    ).add(
                        b.mul(x1.sub(x2)).mul(phi)
                    )
                )
            )
        );
        return r_comm;
    }

    function evaluate_constraint_polynomials(
        AffineAdditionEvaluations memory self,
        Bls12G1 memory apk,
        LagrangeEvaluations memory evals_at_zeta
    ) internal view returns (
        Bw6Fr[] memory
    ) {
        Bw6Fr memory b = self.bitmask;
        Bw6Fr memory x1 = self.partial_sums[0];
        Bw6Fr memory y1 = self.partial_sums[1];
        Bw6Fr memory x2 = self.keyset[0];
        Bw6Fr memory y2 = self.keyset[1];

        (Bw6Fr memory a1, Bw6Fr memory a2) = evaluate_conditional_affine_addition_constraints_linearized(
            evals_at_zeta.zeta_minus_omega_inv,
            b,
            x1,
            y1,
            x2,
            y2
        );
        Bw6Fr memory a3 = evaluate_bitmask_booleanity_constraint(b);
        (Bw6Fr memory a4, Bw6Fr memory a5) = evaluate_public_inputs_constraints(
            apk,
            evals_at_zeta,
            x1,
            y1
        );
        Bw6Fr[] memory res = new Bw6Fr[](5);
        res[0] = a1;
        res[1] = a2;
        res[2] = a3;
        res[3] = a4;
        res[4] = a5;
        return res;
    }

    function evaluate_conditional_affine_addition_constraints_linearized(
        Bw6Fr memory zeta_minus_omega_inv,
        Bw6Fr memory b,
        Bw6Fr memory x1,
        Bw6Fr memory y1,
        Bw6Fr memory x2,
        Bw6Fr memory y2
    ) internal view returns (
        Bw6Fr memory,
        Bw6Fr memory
    ) {
        Bw6Fr memory x3 = BW6FR.zero();
        Bw6Fr memory y3 = BW6FR.zero();
        Bw6Fr memory one = BW6FR.one();

        Bw6Fr memory c1 = (b.mul(
            ((x1.sub(x2)).mul(x1.sub(x2)).mul(x1.add(x2).add(x3))).sub((y2.sub(y1)).mul(y2.sub(y1)))
        )).add((one.sub(b)).mul(y3.sub(y1)));

        Bw6Fr memory c2 = (b.mul(
            ((x1.sub(x2)).mul(y3.add(y1)).sub((y2.sub(y1)).mul(x3.sub(x1))))
        )).add((one.sub(b)).mul(x3.sub(x1)));

        return (c1.mul(zeta_minus_omega_inv), c2.mul(zeta_minus_omega_inv));
    }

    function evaluate_bitmask_booleanity_constraint(
        Bw6Fr memory bitmask_at_zeta
    ) internal view returns (
        Bw6Fr memory
    ) {
        return bitmask_at_zeta.mul(BW6FR.one().sub(bitmask_at_zeta));
    }

    function evaluate_public_inputs_constraints(
        Bls12G1 memory apk,
        LagrangeEvaluations memory evals_at_zeta,
        Bw6Fr memory x1,
        Bw6Fr memory y1
    ) internal view returns (
        Bw6Fr memory,
        Bw6Fr memory
    ) {
        Bls12G1 memory h = BLS12G1.point_in_g1_complement();
        Bls12G1 memory apk_plus_h = h.add(apk);
        Bw6Fr memory hx = h.x.into();
        Bw6Fr memory hy = h.y.into();
        Bw6Fr memory px = apk_plus_h.x.into();
        Bw6Fr memory py = apk_plus_h.y.into();

        Bw6Fr memory c1 = ((x1.sub(hx)).mul(evals_at_zeta.l_first)).add(
            (x1.sub(px)).mul(evals_at_zeta.l_last)
        );
        Bw6Fr memory c2 = ((y1.sub(hy)).mul(evals_at_zeta.l_first)).add(
            (y1.sub(py)).mul(evals_at_zeta.l_last)
        );
        return (c1, c2);
    }
}
