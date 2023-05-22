pragma solidity ^0.8.17;

import "../bw6761/G1.sol";
import "../bw6761/Fr.sol";

struct PartialSumsAndBitmaskCommitments {
    Bw6G1Affine[2] partial_sums;
    Bw6G1Affine bitmask;
}

struct AffineAdditionEvaluations {
    Bw6Fr[2] keyset;
    Bw6Fr bitmask;
    Bw6Fr[2] partial_sums;
}

library BasicProtocol {
    function restore_commitment_to_linearization_polynomial(
        AffineAdditionEvaluations memory self,
        Bw6Fr memory phi,
        Bw6Fr memory zeta_minus_omega,
        Bw6G1Affine[2] memory commitments
    ) internal view {
        Bw6Fr memory b = self.bitmask;
        Bw6Fr memory x1 = self.partial_sums[0];
        Bw6Fr memory y1 = self.partial_sums[1];
        Bw6Fr memory x2 = self.keyset[0];
        Bw6Fr memory y2 = self.keyset[1];

        Bw6G1Affine memory r_comm = BW6G1Affine.zero();
        // X3 := acc_x polynomial
        // Y3 := acc_y polynomial
        // a1_lin = b(x1-x2)^2.X3 + (1-b)Y3
        // a2_lin = b(x1-x2)Y3 + b(y1-y2)X3 + (1-b)X3 // *= phi
        // X3 term = b(x1-x2)^2 + b(y1-y2)phi + (1-b)phi
        // Y3 term = (1-b) + b(x1-x2)phi
        // ...and both multiplied by (\zeta - \omega^{n-1}) // = zeta_minus_omega_inv
        
    }
}
