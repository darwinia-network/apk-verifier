// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.17;

import "./bw6761/G1.sol";
import "./piop/AffineAddition.sol";

/// @dev SimpleProof
struct SimpleProof {
    // PartialSumsCommitments
    Bw6G1[2] register_commitments;
    // Prover receives \phi, the constraint polynomials batching challenge, here
    Bw6G1 q_comm;
    // Prover receives \zeta, the evaluation point challenge, here
    AffineAdditionEvaluationsWithoutBitmask register_evaluations;
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
