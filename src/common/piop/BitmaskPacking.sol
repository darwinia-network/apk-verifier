pragma solidity ^0.8.17;

import "../bw6761/G1.sol";
import "../bw6761/Fr.sol";
import "./AffineAddition.sol";

struct BitmaskPackingCommitments {
    Bw6G1Affine c_comm;
    Bw6G1Affine acc_comm;
}

struct SuccinctAccountableRegisterEvaluations {
    Bw6Fr c;
    Bw6Fr acc;
    AffineAdditionEvaluations basic_evaluations;
}

library PackedProtocol {
    using BW6FR for Bw6Fr;

    function restore_commitment_to_linearization_polynomial(
        SuccinctAccountableRegisterEvaluations memory self,
        Bw6Fr memory phi,
        Bw6Fr memory zeta_minus_omega_inv,
        PartialSumsAndBitmaskCommitments memory commitments,
        BitmaskPackingCommitments memory extra_commitments
    ) internal view {
        Bw6Fr[] memory powers_of_phi = phi.powers(6);
    }
}
