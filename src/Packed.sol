// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.17;

import "./common/KeySet.sol";
import "./common/PackedProof.sol";
import "./common/PublicInput.sol";
import "./common/bls12377/G2.sol";
import "./common/bls12377/Pairing.sol";
import "./common/bw6761/Fr.sol";
import "./common/pcs/kzg/KZG.sol";
import "./common/pcs/aggregation/Single.sol";
import "./common/poly/domain/Radix2.sol";
import "./common/poly/evaluations/Lagrange.sol";
import "./common/transcript/Simple.sol";

/// @title Packed
/// @dev Light client's state is initialized with a commitment 'C0' to the ('genesis') validator set of the era #0
/// (and some technical stuff, like public parameters).
///
/// When an era (tautologically, a validator set) changes, a helper provides:
/// 1. the commitment 'C1' to the new validator set,
/// 2. an aggregate signature 'asig0' of a subset of validators of the previous era on the new commitment 'C1',
/// 3. an aggregate public key 'apk0' of this subset of validators,
/// 4. a bitmask 'b0' identifying this subset in the whole set of the validators of the previous era, and
/// 5. a proof 'p0', that attests that the key 'apk0' is indeed the aggregate public key of a subset identified by 'b0'
///                  of the set of the validators, identified by the commitment 'C0', of the previous era.
/// All together this is ('C1', 'asig0', 'apk0', 'b0', 'p0').
///
/// The light client:
/// 1. makes sure that the key 'apk0' is correct by verifying the proof 'p0':
///    apk_verify('apk0', 'b0', 'C0'; 'p0') == true
/// 2. verifies the aggregate signature 'asig0' agains the key 'apk0':
///    bls_verify('asig0', 'apk0', 'C1') == true
/// 3. If both checks passed and the bitmask contains enough (say, >2/3 of) signers,
///    updates its state to the new commitment 'C1'.
/// @notice APK verifier based 'packed' scheme.
contract Packed {
    using BW6FR for Bw6Fr;
    using BW6FR for Bw6Fr[];
    using Lagrange for Bw6Fr;
    using BitMask for Bitmask;
    using Single for Bw6G1[];
    using KZG for KzgOpening[];
    using KZG for AccumulatedOpening;
    using KeySet for KeysetCommitment;
    using PackedProtocol for SuccinctAccountableRegisterEvaluations;
    using PackedProtocol for PartialSumsAndBitmaskCommitments;
    using PackedProtocol for BitmaskPackingCommitments;
    using SimpleTranscript for Transcript;
    using Radix2 for Radix2EvaluationDomain;
    using KZGParams for RVK;
    using PublicInput for AccountablePublicInput;
    using BW6G1Affine for Bw6G1;

    /// @dev Genesis validator set of the era #0.
    KeysetCommitment public pks_comm;

    /// @dev The majority amount of signers.
    uint256 internal constant QUORUM = 171;

    /// @dev Init.
    /// @param c0 The commitment 'C0' the genesis validator set.
    constructor(Bw6G1[2] memory c0) {
        pks_comm.pks_comm[0] = c0[0];
        pks_comm.pks_comm[1] = c0[1];
        pks_comm.log_domain_size = Radix2.LOG_N;
    }

    /// @dev Domain used to interpolate pks.
    /// @notice Only for fields that have a large multiplicative subgroup
    ///         of size that is a power-of-2.
    function domain() internal pure returns (Radix2EvaluationDomain memory) {
        return Radix2.init();
    }

    /// @dev Core function aggregate all verify.
    ///      1. apk_verify.
    ///      2. bls_verify.
    ///      3. threhold check.
    /// @param public_input Accountable public input.
    /// @param proof Packed proof of packed scheme.
    /// @param new_validator_set_commitment The commitment is to the upcoming validator set.
    /// @return Result of the verify.
    function verify_aggregates(
        AccountablePublicInput calldata public_input,
        PackedProof calldata proof,
        Bls12G2 calldata aggregate_signature,
        KeysetCommitment calldata new_validator_set_commitment
    ) external view returns (bool) {
        uint256 n_signers = public_input.bitmask.count_ones();
        // apk proof verification
        require(verify_packed(public_input, proof), "!apk");

        // aggregate BLS signature verification
        require(verify_bls(public_input.apk, aggregate_signature, new_validator_set_commitment), "!bls");

        // check threhold
        require(n_signers >= QUORUM, "!quorum");

        return true;
    }

    /// @dev Verify BLS aggregate signature.
    /// @param aggregate_public_key Aggregate public key.
    /// @param aggregate_signature Aggregate signature.
    /// @param new_validator_set_commitment The commitment is to the upcoming validator set.
    /// @return Result of the verify.
    function verify_bls(
        Bls12G1 memory aggregate_public_key,
        Bls12G2 memory aggregate_signature,
        KeysetCommitment calldata new_validator_set_commitment
    ) internal view returns (bool) {
        require(pks_comm.log_domain_size == new_validator_set_commitment.log_domain_size, "!log_n");
        Bls12G2 memory message = new_validator_set_commitment.hash_commitment();
        return BLS12Pairing.verify(aggregate_public_key, aggregate_signature, message);
    }

    /// @dev APK verify for packed scheme.
    /// @param public_input Accountable public input.
    /// @param proof Packed proof of packed scheme.
    /// @return Result of the verify.
    function verify_packed(AccountablePublicInput calldata public_input, PackedProof calldata proof)
        internal
        view
        returns (bool)
    {
        (Challenges memory challenges, Transcript memory fsrng) =
            restore_challenges(public_input, proof, PackedProtocol.POLYS_OPENED_AT_ZETA);
        LagrangeEvaluations memory evals_at_zeta = challenges.zeta.lagrange_evaluations(domain());
        validate_evaluations(proof, challenges, fsrng, evals_at_zeta);
        Bw6Fr[] memory constraint_polynomial_evals = proof.register_evaluations.evaluate_constraint_polynomials(
            public_input.apk, evals_at_zeta, challenges.r, public_input.bitmask, domain().size
        );
        Bw6Fr memory w = constraint_polynomial_evals.horner_field(challenges.phi);

        return (proof.r_zeta_omega.add(w)).eq(proof.q_zeta.mul(evals_at_zeta.vanishing_polynomial));
    }

    /// @dev Restore challenges.
    /// @param public_input Accountable public input.
    /// @param proof Packed proof of packed scheme.
    /// @return Tuple of challenges and transcipt.
    function restore_challenges(
        AccountablePublicInput calldata public_input,
        PackedProof calldata proof,
        uint256 batch_size
    ) internal view returns (Challenges memory, Transcript memory) {
        Transcript memory transcript = SimpleTranscript.init("apk_proof");
        transcript.set_protocol_params(Radix2.init().serialize(), kzg_pvk().serialize());
        transcript.set_keyset_commitment(pks_comm.serialize());

        transcript.append_public_input(public_input.serialize());
        transcript.append_register_commitments(proof.register_commitments.serialize());
        Bw6Fr memory r = transcript.get_bitmask_aggregation_challenge();

        transcript.append_2nd_round_register_commitments(proof.additional_commitments.serialize());
        Bw6Fr memory phi = transcript.get_constraints_aggregation_challenge();
        transcript.append_quotient_commitment(proof.q_comm.serialize());
        Bw6Fr memory zeta = transcript.get_evaluation_point();
        transcript.append_evaluations(
            proof.register_evaluations.serialize(), proof.q_zeta.serialize(), proof.r_zeta_omega.serialize()
        );
        Bw6Fr[] memory nus = transcript.get_kzg_aggregation_challenges(batch_size);

        return (Challenges({r: r, phi: phi, zeta: zeta, nus: nus}), SimpleTranscript.simple_fiat_shamir_rng(transcript));
    }

    /// @dev Validate evaluations.
    /// @param proof Packed proof of packed scheme.
    /// @param challenges Restored challenges.
    /// @param fsrng Fiat shamir rng.
    /// @param evals_at_zeta Lagrange evaluations at zeta.
    function validate_evaluations(
        PackedProof calldata proof,
        Challenges memory challenges,
        Transcript memory fsrng,
        LagrangeEvaluations memory evals_at_zeta
    ) internal view {
        // Reconstruct the commitment to the linearization polynomial using the commitments to the registers from the proof.
        // linearization polynomial commitment
        Bw6G1 memory r_comm = proof.register_evaluations.restore_commitment_to_linearization_polynomial(
            challenges.phi, evals_at_zeta.zeta_minus_omega_inv, proof.register_commitments, proof.additional_commitments
        );

        // Aggregate the commitments to be opened in \zeta, using the challenge \nu.
        // aggregate evaluation claims in zeta
        Bw6G1[] memory commitments = new Bw6G1[](8);
        commitments[0] = pks_comm.pks_comm[0];
        commitments[1] = pks_comm.pks_comm[1];
        commitments[2] = proof.register_commitments.bitmask;
        commitments[3] = proof.register_commitments.partial_sums[0];
        commitments[4] = proof.register_commitments.partial_sums[1];
        commitments[5] = proof.additional_commitments.c_comm;
        commitments[6] = proof.additional_commitments.acc_comm;
        commitments[7] = proof.q_comm;
        // ...together with the corresponding values
        Bw6Fr[] memory register_evals = new Bw6Fr[](8);
        register_evals[0] = proof.register_evaluations.basic_evaluations.keyset[0];
        register_evals[1] = proof.register_evaluations.basic_evaluations.keyset[1];
        register_evals[2] = proof.register_evaluations.basic_evaluations.bitmask;
        register_evals[3] = proof.register_evaluations.basic_evaluations.partial_sums[0];
        register_evals[4] = proof.register_evaluations.basic_evaluations.partial_sums[1];
        register_evals[5] = proof.register_evaluations.c;
        register_evals[6] = proof.register_evaluations.acc;
        register_evals[7] = proof.q_zeta;
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

    /// @dev KZG verifier key.
    /// @return KZG raw verifier key.
    function kzg_pvk() internal pure returns (RVK memory) {
        return KZGParams.raw_vk();
    }
}
