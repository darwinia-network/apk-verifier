pragma solidity ^0.8.17;

import "./Fp.sol";

struct Bw6G1Affine {
    Bw6Fp x;
    Bw6Fp y;
}

struct Bw6G1Projective {
    Bw6Fp x;
    Bw6Fp y;
    Bw6Fp z;
}

library BW6G1Affine {}

library BW6G1Projective {
    function zero() internal pure returns (Bw6G1Projective memory) {
        return Bw6G1Projective(
            BW6FP.one(),
            BW6FP.one(),
            BW6FP.zero()
        );
    }
}
