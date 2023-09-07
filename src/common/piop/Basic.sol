// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "../bw6761/Fr.sol";

struct AffineAdditionEvaluationsWithoutBitmask {
    Bw6Fr[2] keyset;
    Bw6Fr[2] partial_sums;
}
