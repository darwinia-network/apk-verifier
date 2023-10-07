// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.17;

import "./bw6761/G1.sol";
import "./piop/AffineAddition.sol";
import "./piop/BitmaskPacking.sol";

/// @dev PackedProof
struct PackedProof {
    PartialSumsAndBitmaskCommitments register_commitments;
    // 2nd round commitments, used in "packed" scheme after get the bitmask aggregation challenge is received
    BitmaskPackingCommitments additional_commitments;
    // Prover receives \phi, the constraint polynomials batching challenge, here
    Bw6G1 q_comm;
    // Prover receives \zeta, the evaluation point challenge, here
    SuccinctAccountableRegisterEvaluations register_evaluations;
    Bw6Fr q_zeta;
    Bw6Fr r_zeta_omega;
    // Prover receives \nu, the KZG opening batching challenge, here
    Bw6G1 w_at_zeta_proof;
    Bw6G1 r_at_zeta_omega_proof;
}

struct Challenges {
    Bw6Fr r;
    Bw6Fr phi;
    Bw6Fr zeta;
    Bw6Fr[] nus;
}
