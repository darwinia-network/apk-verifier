pragma solidity ^0.8.17;

struct Bw6Fp {
    uint a;
    uint b;
    uint c;
}

library BW6FP {
    function zero() internal pure returns (Bw6Fp memory) {
        return Bw6Fp(0, 0, 0);
    }

    function one() internal pure returns (Bw6Fp memory) {
        return Bw6Fp(0, 0, 1);
    }
}
