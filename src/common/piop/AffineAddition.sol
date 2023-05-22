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
        Bw6Fr[2] memory commitments
    ) internal view {
        Bw6Fr memory b = self.bitmask;
        Bw6Fr memory x1 = self.partial_sums[0];
        Bw6Fr memory y1 = self.partial_sums[1];
        Bw6Fr memory x2 = self.keyset[0];
        Bw6Fr memory y2 = self.keyset[1];

        Bw6G1Projective memory r_comm = BW6G1Projective.zero();
    }
}
