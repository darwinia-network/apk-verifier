// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./bw6761/G1.sol";
import "./piop/AffineAddition.sol";
import "./piop/Basic.sol";

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
