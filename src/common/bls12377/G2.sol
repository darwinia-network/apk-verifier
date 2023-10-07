// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.17;

import "./Fp2.sol";

/// @dev BLS12-377 G2 of affine coordinates in short Weierstrass.
/// @param x X over the quadratic extension field.
/// @param y Y over the quadratic extension field.
struct Bls12G2 {
    Bls12Fp2 x;
    Bls12Fp2 y;
}

/// @title BLS12G2Affine
library BLS12G2Affine {
    using BLS12FP2 for bytes;
    using BLS12FP2 for Bls12Fp2;

    /// @dev BLS12_377_G2ADD precompile address.
    // uint256 private constant G2_ADD = 0x18;
    uint256 private constant G2_ADD = 0x0804;
    /// @dev BLS12_377_MAP_FP2_TO_G2 precompile address.
    // uint256 private constant MAP_FP2_TO_G2 = 0x1c;
    uint256 private constant MAP_FP2_TO_G2 = 0x0809;

    /// @dev Returns `true` if `x` is equal to `y`.
    /// @param a Bls12G2.
    /// @param b Bls12G2.
    /// @return Result of equal check.
    function eq(Bls12G2 memory a, Bls12G2 memory b) internal pure returns (bool) {
        return a.x.eq(b.x) && a.y.eq(b.y);
    }

    /// @dev Produce a hash of the message. This uses the IETF hash to curve's specification
    /// for Random oracle encoding (hash_to_curve) defined by combining these components.
    /// See <https://tools.ietf.org/html/draft-irtf-cfrg-hash-to-curve-09#section-3>
    /// @param message An arbitrary-length byte string..
    /// @return A point in Bls12G2.
    function hash_to_curve(bytes memory message) internal view returns (Bls12G2 memory) {
        Bls12Fp2[2] memory u = message.hash_to_field();
        Bls12G2 memory q0 = map_to_curve(u[0]);
        Bls12G2 memory q1 = map_to_curve(u[1]);
        return add(q0, q1);
    }

    /// @dev Returns the result of `p + q`.
    /// @param p Bls12G2.
    /// @param q Bls12G2.
    /// @return `x + y`.
    function add(Bls12G2 memory p, Bls12G2 memory q) internal view returns (Bls12G2 memory) {
        uint256[16] memory input;
        input[0] = p.x.c0.a;
        input[1] = p.x.c0.b;
        input[2] = p.x.c1.a;
        input[3] = p.x.c1.b;
        input[4] = p.y.c0.a;
        input[5] = p.y.c0.b;
        input[6] = p.y.c1.a;
        input[7] = p.y.c1.b;
        input[8] = q.x.c0.a;
        input[9] = q.x.c0.b;
        input[10] = q.x.c1.a;
        input[11] = q.x.c1.b;
        input[12] = q.y.c0.a;
        input[13] = q.y.c0.b;
        input[14] = q.y.c1.a;
        input[15] = q.y.c1.b;
        uint256[8] memory output;

        assembly ("memory-safe") {
            if iszero(staticcall(gas(), G2_ADD, input, 512, output, 256)) {
                let pt := mload(0x40)
                returndatacopy(pt, 0, returndatasize())
                revert(pt, returndatasize())
            }
        }

        return from(output);
    }

    /// @dev Map an arbitary field element to a corresponding curve point.
    /// @param fp2 Bls12Fp2.
    /// @return A point in G2.
    function map_to_curve(Bls12Fp2 memory fp2) internal view returns (Bls12G2 memory) {
        uint256[4] memory input;
        input[0] = fp2.c0.a;
        input[1] = fp2.c0.b;
        input[2] = fp2.c1.a;
        input[3] = fp2.c1.b;
        uint256[8] memory output;

        assembly ("memory-safe") {
            if iszero(staticcall(gas(), MAP_FP2_TO_G2, input, 128, output, 256)) {
                let p := mload(0x40)
                returndatacopy(p, 0, returndatasize())
                revert(p, returndatasize())
            }
        }

        return from(output);
    }

    /// @dev Derive Bls12G1 from uint256[8].
    /// @param x uint256[4].
    /// @return Bls12G2.
    function from(uint256[8] memory x) internal pure returns (Bls12G2 memory) {
        return Bls12G2(
            Bls12Fp2(Bls12Fp(x[0], x[1]), Bls12Fp(x[2], x[3])), Bls12Fp2(Bls12Fp(x[4], x[5]), Bls12Fp(x[6], x[7]))
        );
    }

    /// @dev Debug Bls12G2 in bytes.
    /// @param p Bls12G2.
    /// @return Uncompressed serialized bytes of Bls12G2.
    function debug(Bls12G2 memory p) internal pure returns (bytes memory) {
        return abi.encodePacked(p.x.debug(), p.y.debug());
    }
}
