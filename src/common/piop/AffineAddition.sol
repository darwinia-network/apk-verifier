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
