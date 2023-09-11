// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./Fp.sol";

struct Bls12G1 {
    Bls12Fp x;
    Bls12Fp y;
}

library BLS12G1Affine {
    using BLS12FP for Bls12Fp;

    // BLS12_377_G1ADD
    uint256 private constant G1_ADD = 0x15;

    bytes1 private constant INFINITY_FLAG = bytes1(0x40);
    bytes1 private constant Y_IS_NEGATIVE = bytes1(0x80);

    function generator() internal pure returns (Bls12G1 memory) {
        return Bls12G1({
            x: Bls12Fp(0x8848defe740a67c8fc6225bf87ff54, 0x85951e2caa9d41bb188282c8bd37cb5cd5481512ffcd394eeab9b16eb21be9ef),
            y: Bls12Fp(
                0x1914a69c5102eff1f674f5d30afeec4, 0xbd7fb348ca3e52d96d182ad44fb82305c2fe3d3634a9591afd82de55559c8ea6
                )
        });
    }

    function neg_generator() internal pure returns (Bls12G1 memory) {
        return Bls12G1({
            x: Bls12Fp(0x8848defe740a67c8fc6225bf87ff54, 0x85951e2caa9d41bb188282c8bd37cb5cd5481512ffcd394eeab9b16eb21be9ef),
            y: Bls12Fp(0x1cefdc52b4e1eba6d3b6633bf15a76, 0x5ca326aa36b6c0b5b1db375b6a5124fa540d200dfb56a6e58785e1aaaa63715b)
        });
    }

    function zero() internal pure returns (Bls12G1 memory) {
        return Bls12G1(BLS12FP.zero(), BLS12FP.zero());
    }

    function is_zero(Bls12G1 memory p) internal pure returns (bool) {
        return p.x.is_zero() && p.y.is_zero();
    }

    function is_infinity(Bls12G1 memory p) internal pure returns (bool) {
        return is_zero(p);
    }

    function complement() internal pure returns (Bls12G1 memory) {
        return Bls12G1({x: Bls12Fp(0, 0), y: Bls12Fp(0, 1)});
    }

    function add(Bls12G1 memory p, Bls12G1 memory q) internal view returns (Bls12G1 memory) {
        uint256[8] memory input;
        input[0] = p.x.a;
        input[1] = p.x.b;
        input[2] = p.y.a;
        input[3] = p.y.b;
        input[4] = q.x.a;
        input[5] = q.x.b;
        input[6] = q.y.a;
        input[7] = q.y.b;
        uint256[4] memory output;

        assembly ("memory-safe") {
            if iszero(staticcall(gas(), G1_ADD, input, 256, output, 128)) {
                let pt := mload(0x40)
                returndatacopy(pt, 0, returndatasize())
                revert(pt, returndatasize())
            }
        }

        return from(output);
    }

    function from(uint256[4] memory x) internal pure returns (Bls12G1 memory) {
        return Bls12G1(Bls12Fp(x[0], x[1]), Bls12Fp(x[2], x[3]));
    }

    function serialize(Bls12G1 memory g1) internal pure returns (bytes memory r) {
        if (is_infinity(g1)) {
            r = new bytes(64);
            r[63] = INFINITY_FLAG;
        } else {
            Bls12Fp memory neg_y = g1.y.neg();
            bool y_flag = g1.y.gt(neg_y);
            r = g1.x.serialize();
            if (y_flag) {
                r[63] |= Y_IS_NEGATIVE;
            }
        }
    }
}
