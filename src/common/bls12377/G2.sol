// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./Fp2.sol";

struct Bls12G2 {
    Bls12Fp2 x;
    Bls12Fp2 y;
}

library BLS12G2Affine {
    using BLS12FP2 for bytes;
    using BLS12FP2 for Bls12Fp2;

    function eq(Bls12G2 memory a, Bls12G2 memory b) internal pure returns (bool) {
        return a.x.eq(b.x) && a.y.eq(b.y);
    }

    function hash_to_curve(bytes memory message) internal pure returns (Bls12G2 memory) {
        // Bls12Fp2[2] memory u = message.hash_to_field();
        // Bls12G2 memory q0 = map_to_curve(u[0]);
        // Bls12G2 memory q1 = map_to_curve(u[1]);
        // return add(q0, q1);
    }
}
