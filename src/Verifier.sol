// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "./libraries/bls12377/G1.sol";
import "./libraries/Bitmask.sol";

contract Verifier {

    struct AccountablePublicInput {
        G1Affine apk;
        Bitmask bitmask;
    }

    // function verify_aggregates(
    //     AccountablePublicInput calldata public_input,
    //     PackedProof calldata proof,
    //     Signature calldata aggregate_signature,
    //     KeysetCommitment calldata new_validator_set_commitment
    // ) external {
    //     // 1. verify_packed
    //     // 2. verify_bls
    //     // 3. check threhold
    // }

    // function verify_packed(
    //     AccountablePublicInput calldata public_input,
    //     PackedProof calldata proof
    // ) internal pure returns (bool) {
    //     // 1. restore_challenges
    //     // 2. lagrange_evaluations
    //     // 3. validate_evaluations
    //     // 4. evaluate_constraint_polynomials
    //     // 5. w = horner_field
    //     // 6. proof.r_zeta_omega + w == proof.q_zeta * evals_at_zeta.vanishing_polynomial
    // }

    // function restore_challenges(
    //     AccountablePublicInput calldata public_input,
    //     PackedProof calldata proof,
    //     uint ZETA
    // ) internal pure returns(
    //     Challenges memory challenges,
    //     TranscriptRng memory fsrng
    // ) {}

    // function lagrange_evaluations(
    //     uint challenges_zeta,
    //     Radix2EvaluationDomain memory domain
    // ) internal pure returns(
    //     LagrangeEvaluations memory evals_at_zeta
    // ) {
    // }

    // function validate_evaluations(
    //     PackedProof calldata proof,
    //     Challenges memory challenges,
    //     TranscriptRng memory fsrng,
    //     LagrangeEvaluations memory evals_at_zeta
    // ) internal pure {}

    // funciont evaluate_constraint_polynomials(
    //     G1Affine memory apk,
    //     LagrangeEvaluations memory evals_at_zeta,
    //     uint challenges_r,
    //     Bitmask memory bitmask,
    //     uint domain_size
    // ) internal pure returns (
    //     Fr[] memory constraint_polynomial_evals
    // ) {}
}
