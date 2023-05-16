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

