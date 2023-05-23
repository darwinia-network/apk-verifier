pragma solidity ^0.8.17;

import "../bw6761/Fr.sol";

struct Bls12Fp {
    uint a;
    uint b;
}

library BLS12FP {
    function into(Bls12Fp memory x) internal pure returns (Bw6Fr memory) {
        return Bw6Fr(x.a, x.b);
    }
}
