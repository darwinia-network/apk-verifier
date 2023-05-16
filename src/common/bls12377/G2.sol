pragma solidity ^0.8.17;

import "./Fp2.sol";

struct Signature {
    Bls12Fp2 x;
    Bls12Fp2 y;
    Bls12Fp2 z;
}

library BLS12G2 {}
