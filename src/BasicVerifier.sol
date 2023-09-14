// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./common/KeySet.sol";
import "./common/SimpleProof.sol";
import "./common/PublicInput.sol";
import "./common/bls12377/G2.sol";
import "./common/bls12377/Pairing.sol";
import "./common/bw6761/Fr.sol";
import "./common/bw6761/G1.sol";
import "./common/pcs/kzg/KZG.sol";
import "./common/pcs/aggregation/Single.sol";
import "./common/poly/domain/Radix2.sol";
import "./common/poly/evaluations/Lagrange.sol";
import "./common/transcipt/Simple.sol";

import {console2} from "forge-std/console2.sol";

contract BasicVerifier {
    using BW6FR for Bw6Fr;
    using BW6FR for Bw6Fr[];
    using Lagrange for Bw6Fr;
    using BitMask for Bitmask;
    using Single for Bw6G1[];
    using KZG for KzgOpening[];
    using KZG for AccumulatedOpening;
    using KeySet for KeysetCommitment;
    using BasicProtocol for AffineAdditionEvaluations;
    using SimpleTranscript for Transcript;
    using Radix2 for Radix2EvaluationDomain;
    using KZGParams for RVK;
    using PublicInput for AccountablePublicInput;
    using BW6G1Affine for Bw6G1;

    // debug
    using BW6FP for Bw6Fp;

    KeysetCommitment public pks_comm;

    uint256 internal constant QUORUM = 171;
    uint256 internal constant POLYS_OPENED_AT_ZETA = 5;

    constructor(Bw6G1[2] memory c0) {
        pks_comm.pks_comm[0] = c0[0];
        pks_comm.pks_comm[1] = c0[1];
        pks_comm.log_domain_size = Radix2.LOG_N;
    }

    function domain() internal pure returns (Radix2EvaluationDomain memory) {
        return Radix2.init();
    }

    function verify_aggregates(
        AccountablePublicInput calldata public_input,
        SimpleProof calldata proof,
        Bls12G2 calldata aggregate_signature,
        KeysetCommitment calldata new_validator_set_commitment
    ) external view {
        uint256 n_signers = public_input.bitmask.count_ones();
        // apk proof verification
        require(verify_simple(public_input, proof), "!apk");

        // aggregate BLS signature verification
        require(verify_bls(public_input.apk, aggregate_signature, new_validator_set_commitment), "!bls");
        // check threhold
        require(n_signers >= QUORUM, "!quorum");
    }

    function verify_bls(
        Bls12G1 memory aggregate_public_key,
        Bls12G2 memory aggregate_signature,
        KeysetCommitment calldata new_validator_set_commitment
    ) internal view returns (bool) {
        require(pks_comm.log_domain_size == new_validator_set_commitment.log_domain_size, "!log_n");
        Bls12G2 memory message = new_validator_set_commitment.hash_commitment();
        return BLS12Pairing.verify(aggregate_public_key, aggregate_signature, message);
    }

    function verify_simple(AccountablePublicInput calldata public_input, SimpleProof calldata proof)
        internal
        view
        returns (bool)
    {
        (Challenges memory challenges, Transcript memory fsrng) =
            restore_challenges(public_input, proof, POLYS_OPENED_AT_ZETA);
        LagrangeEvaluations memory evals_at_zeta = challenges.zeta.lagrange_evaluations(domain());
        Bw6Fr memory b_at_zeta = challenges.zeta.barycentric_eval_binary_at(public_input.bitmask, domain());

        AffineAdditionEvaluations memory evaluations_with_bitmask = AffineAdditionEvaluations({
            keyset: proof.register_evaluations.keyset,
            bitmask: b_at_zeta,
            partial_sums: proof.register_evaluations.partial_sums
        });

        validate_evaluations(proof, evaluations_with_bitmask, challenges, fsrng, evals_at_zeta);
        Bw6Fr[] memory constraint_polynomial_evals =
            evaluations_with_bitmask.evaluate_constraint_polynomials(public_input.apk, evals_at_zeta);
        Bw6Fr memory w = constraint_polynomial_evals.horner_field(challenges.phi);
        return (proof.r_zeta_omega.add(w)).eq(proof.q_zeta.mul(evals_at_zeta.vanishing_polynomial));
    }

    function restore_challenges(
        AccountablePublicInput calldata public_input,
        SimpleProof calldata proof,
        uint256 batch_size
    ) public view returns (Challenges memory, Transcript memory) {
        Transcript memory transcript = SimpleTranscript.init("apk_proof");
        transcript.set_protocol_params(Radix2.init().serialize(), kzg_pvk().serialize());
        transcript.set_keyset_commitment(pks_comm.serialize());

        transcript.append_public_input(public_input.serialize());
        transcript.append_register_commitments(
            abi.encodePacked(proof.register_commitments[0].serialize(), proof.register_commitments[1].serialize())
        );
        Bw6Fr memory r = transcript.get_bitmask_aggregation_challenge();
        // Packed:
        // transcript.append_2nd_round_register_commitments(proof.additional_commitments.serialize());
        transcript.append_2nd_round_register_commitments("");
        Bw6Fr memory phi = transcript.get_constraints_aggregation_challenge();
        transcript.append_quotient_commitment(proof.q_comm.serialize());
        Bw6Fr memory zeta = transcript.get_evaluation_point();
        transcript.append_evaluations(
            abi.encodePacked(
                proof.register_evaluations.keyset[0].serialize(),
                proof.register_evaluations.keyset[1].serialize(),
                proof.register_evaluations.partial_sums[0].serialize(),
                proof.register_evaluations.partial_sums[1].serialize()
            ),
            proof.q_zeta.serialize(),
            proof.r_zeta_omega.serialize()
        );
        Bw6Fr[] memory nus = transcript.get_kzg_aggregation_challenges(batch_size);

        return (Challenges({r: r, phi: phi, zeta: zeta, nus: nus}), SimpleTranscript.simple_fiat_shamir_rng(transcript));
    }

    function validate_evaluations(
        SimpleProof memory proof,
        AffineAdditionEvaluations memory protocol,
        Challenges memory challenges,
        Transcript memory fsrng,
        LagrangeEvaluations memory evals_at_zeta
    ) internal view {
        // KZG check
        // Reconstruct the commitment to the linearization polynomial using the commitments to the registers from the proof.
        // linearization polynomial commitment
        Bw6G1 memory r_comm = protocol.restore_commitment_to_linearization_polynomial(
            challenges.phi, evals_at_zeta.zeta_minus_omega_inv, proof.register_commitments
        );

        // Aggregate the commitments to be opened in \zeta, using the challenge \nu.
        // aggregate evaluation claims in zeta
        Bw6G1[] memory commitments = new Bw6G1[](5);
        commitments[0] = pks_comm.pks_comm[0];
        commitments[1] = pks_comm.pks_comm[1];
        commitments[2] = proof.register_commitments[0];
        commitments[3] = proof.register_commitments[1];
        commitments[4] = proof.q_comm;
        // ...together with the corresponding values
        Bw6Fr[] memory register_evals = new Bw6Fr[](5);
        register_evals[0] = proof.register_evaluations.keyset[0];
        register_evals[1] = proof.register_evaluations.keyset[1];
        register_evals[2] = proof.register_evaluations.partial_sums[0];
        register_evals[3] = proof.register_evaluations.partial_sums[1];
        register_evals[4] = proof.q_zeta;
        (Bw6G1 memory w_comm, Bw6Fr memory w_at_zeta) =
            commitments.aggregate_claims_multiexp(register_evals, challenges.nus);

        // batched KZG openning
        KzgOpening memory opening_at_zeta =
            KzgOpening({c: w_comm, x: challenges.zeta, y: w_at_zeta, proof: proof.w_at_zeta_proof});
        KzgOpening memory opening_at_zeta_omega = KzgOpening({
            c: r_comm,
            x: evals_at_zeta.zeta_omega,
            y: proof.r_zeta_omega,
            proof: proof.r_at_zeta_omega_proof
        });
        KzgOpening[] memory openings = new KzgOpening[](2);
        openings[0] = opening_at_zeta;
        openings[1] = opening_at_zeta_omega;
        Bw6Fr[] memory coeffs = new Bw6Fr[](2);
        coeffs[0] = BW6FR.one();
        coeffs[1] = fsrng.rand_u128();
        AccumulatedOpening memory acc_opening = openings.accumulate(coeffs, kzg_pvk());
        // KZG verification, lazy subgroup check
        require(acc_opening.verify_accumulated(kzg_pvk()), "!KZG verification");
    }

    function kzg_pvk() public pure returns (RVK memory) {
        return KZGParams.raw_vk();
    }
}
