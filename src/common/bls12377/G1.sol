pragma solidity ^0.8.17;

import "./Fp.sol";

struct Bls12G1Affine {
    Bls12Fp x;
    Bls12Fp y;
}

library BLS12G1 {}
