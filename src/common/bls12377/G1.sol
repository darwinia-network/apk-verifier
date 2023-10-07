// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.17;

import "./Fp.sol";

/// @dev BLS12-377 G1 of affine coordinates in short Weierstrass.
/// @param x X over the base field.
/// @param y Y over the base field.
struct Bls12G1 {
    Bls12Fp x;
    Bls12Fp y;
}

/// @title BLS12G1Affine
library BLS12G1Affine {
    using BLS12FP for Bls12Fp;

    /// @dev BLS12_377_G1ADD precompile address.
    // uint256 private constant G1_ADD = 0x15;
    uint256 private constant G1_ADD = 0x0801;

    /// @dev INFINITY_FLAG
    bytes1 private constant INFINITY_FLAG = bytes1(0x40);
    /// @dev Y_IS_NEGATIVE
    bytes1 private constant Y_IS_NEGATIVE = bytes1(0x80);

    /// @dev G1 generator
    /// @return G1 generator
    function generator() internal pure returns (Bls12G1 memory) {
        return Bls12G1({
            x: Bls12Fp(0x8848defe740a67c8fc6225bf87ff54, 0x85951e2caa9d41bb188282c8bd37cb5cd5481512ffcd394eeab9b16eb21be9ef),
            y: Bls12Fp(
                0x1914a69c5102eff1f674f5d30afeec4, 0xbd7fb348ca3e52d96d182ad44fb82305c2fe3d3634a9591afd82de55559c8ea6
                )
        });
    }

    /// @dev Negative G1 generator
    /// @return Negative G1 generator
    function neg_generator() internal pure returns (Bls12G1 memory) {
        return Bls12G1({
            x: Bls12Fp(0x8848defe740a67c8fc6225bf87ff54, 0x85951e2caa9d41bb188282c8bd37cb5cd5481512ffcd394eeab9b16eb21be9ef),
            y: Bls12Fp(0x1cefdc52b4e1eba6d3b6633bf15a76, 0x5ca326aa36b6c0b5b1db375b6a5124fa540d200dfb56a6e58785e1aaaa63715b)
        });
    }

    /// @dev Returns the additive identity element of Bls12G1.
    /// @return Bls12G1(BLS12FP.zero(), BLS12FP.zero())
    function zero() internal pure returns (Bls12G1 memory) {
        return Bls12G1(BLS12FP.zero(), BLS12FP.zero());
    }

    /// @dev Returns `true` if `self` is equal to the additive identity.
    /// @param self Bls12G1.
    /// @return Result of zero check.
    function is_zero(Bls12G1 memory self) internal pure returns (bool) {
        return self.x.is_zero() && self.y.is_zero();
    }

    /// @dev Returns `true` if `self` is infinity point.
    /// @param self Bls12G1.
    /// @return Result of infinity check.
    function is_infinity(Bls12G1 memory self) internal pure returns (bool) {
        return is_zero(self);
    }

    /// @dev Returns complement in G1 for `apk-proofs`.
    /// @return Complement in G1.
    function complement() internal pure returns (Bls12G1 memory) {
        return Bls12G1({x: Bls12Fp(0, 0), y: Bls12Fp(0, 1)});
    }

    /// @dev Returns the result of `p + q`.
    /// @param p Bls12G1.
    /// @param q Bls12G1.
    /// @return z `x + y`.
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

    /// @dev Derive Bls12G1 from uint256[4].
    /// @param x uint256[4].
    /// @return Bls12G1.
    function from(uint256[4] memory x) internal pure returns (Bls12G1 memory) {
        return Bls12G1(Bls12Fp(x[0], x[1]), Bls12Fp(x[2], x[3]));
    }

    /// @dev Serialize Bls12G1.
    /// @param g1 Bls12G1.
    /// @return r Compressed serialized bytes of Bls12G1.
    function serialize(Bls12G1 memory g1) internal pure returns (bytes memory r) {
        if (is_infinity(g1)) {
            r = new bytes(56);
            r[55] = INFINITY_FLAG;
        } else {
            Bls12Fp memory neg_y = g1.y.neg();
            bool y_flag = g1.y.gt(neg_y);
            r = g1.x.serialize();
            if (y_flag) {
                r[55] |= Y_IS_NEGATIVE;
            }
        }
    }
}
