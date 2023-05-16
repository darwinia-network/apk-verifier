pragma solidity ^0.8.17;

import "./bls12377/G1.sol";
import "./Bitmask.sol";

struct AccountablePublicInput {
    Bls12G1Affine apk;
    Bitmask bitmask;
}
