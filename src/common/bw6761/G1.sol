// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.17;

import "./Fp.sol";
import "./Fr.sol";

/// @dev BW6-761 G1 of affine coordinates in short Weierstrass.
/// @param x X over the base field.
/// @param y Y over the base field.
struct Bw6G1 {
    Bw6Fp x;
    Bw6Fp y;
}

/// @title BW6G1Affine
library BW6G1Affine {
    using BW6FP for Bw6Fp;

    /// @dev BW6_G1_ADD precompile address.
    // uint256 private constant G1_ADD = 0x1e;
    uint256 private constant G1_ADD = 0x080a;
    /// @dev BW6_G1_MUL precompile address.
    // uint256 private constant G1_MUL = 0x1f;
    uint256 private constant G1_MUL = 0x080b;
    /// @dev BW6_G1_MULTIEXP precompile address.
    // uint256 private constant G1_MULTIEXP = 0x20;
    uint256 private constant G1_MULTIEXP = 0x080c;

    /// @dev INFINITY_FLAG
    bytes1 private constant INFINITY_FLAG = bytes1(0x40);
    /// @dev Y_IS_NEGATIVE
    bytes1 private constant Y_IS_NEGATIVE = bytes1(0x80);

    /// @dev Returns the additive identity element of Bw6G1.
    /// @return Bw6G1(BW6FP.zero(), BW6FP.zero())
    function zero() internal pure returns (Bw6G1 memory) {
        return Bw6G1(BW6FP.zero(), BW6FP.zero());
    }

    /// @dev Returns `true` if `self` is equal to the additive identity.
    /// @param self Bw6G1.
    /// @return Result of zero check.
    function is_zero(Bw6G1 memory self) internal pure returns (bool) {
        return self.x.is_zero() && self.y.is_zero();
    }

    /// @dev Returns `true` if `self` is infinity point.
    /// @param self Bw6G1.
    /// @return Result of infinity check.
    function is_infinity(Bw6G1 memory self) internal pure returns (bool) {
        return is_zero(self);
    }

    /// @dev Returns `true` if `a` is equal to `a`.
    /// @param a Bw6G1.
    /// @param b Bw6G1.
    /// @return Result of equal check.
    function eq(Bw6G1 memory a, Bw6G1 memory b) internal pure returns (bool) {
        return a.x.eq(b.x) && a.y.eq(b.y);
    }

    /// @dev If `self.is_zero()`, returns `self` (`== Self::zero()`).
    /// Else, returns `(x, -y)`, where `self = (x, y)`.
    /// @param self Bw6Fr.
    function neg(Bw6G1 memory self) internal pure {
        self.y = self.y.neg();
    }

    /// @dev Returns the result of `p + q`.
    /// @param p Bw6G1.
    /// @param q Bw6G1.
    function add(Bw6G1 memory p, Bw6G1 memory q) internal view returns (Bw6G1 memory) {
        uint256[12] memory input;
        input[0] = p.x.a;
        input[1] = p.x.b;
        input[2] = p.x.c;
        input[3] = p.y.a;
        input[4] = p.y.b;
        input[5] = p.y.c;
        input[6] = q.x.a;
        input[7] = q.x.b;
        input[8] = q.x.c;
        input[9] = q.y.a;
        input[10] = q.y.b;
        input[11] = q.y.c;
        uint256[6] memory output;

        assembly ("memory-safe") {
            if iszero(staticcall(gas(), G1_ADD, input, 384, output, 192)) {
                let pt := mload(0x40)
                returndatacopy(pt, 0, returndatasize())
                revert(pt, returndatasize())
            }
        }

        return from(output);
    }

    /// @dev Returns the result of `p - q`.
    /// @param p Bw6G1.
    /// @param q Bw6G1.
    /// @return z `p - q`.
    function sub(Bw6G1 memory p, Bw6G1 memory q) internal view returns (Bw6G1 memory z) {
        neg(q);
        z = add(p, q);
    }

    /// @dev Returns the result of `p * scalar`.
    /// @param p Bw6G1.
    /// @param scalar Bw6Fr.
    /// @return z `p * scalar`.
    function mul(Bw6G1 memory p, Bw6Fr memory scalar) internal view returns (Bw6G1 memory) {
        uint256[8] memory input;
        input[0] = p.x.a;
        input[1] = p.x.b;
        input[2] = p.x.c;
        input[3] = p.y.a;
        input[4] = p.y.b;
        input[5] = p.y.c;
        input[6] = scalar.a;
        input[7] = scalar.b;
        uint256[6] memory output;

        assembly ("memory-safe") {
            if iszero(staticcall(gas(), G1_MUL, input, 256, output, 192)) {
                let pt := mload(0x40)
                returndatacopy(pt, 0, returndatasize())
                revert(pt, returndatasize())
            }
        }

        return from(output);
    }

    /// @dev Multi-scalar multiplication
    /// @param bases Bw6G1[].
    /// @param scalars Bw6Fr[].
    /// @return Result of msm.
    function msm(Bw6G1[] memory bases, Bw6Fr[] memory scalars) internal view returns (Bw6G1 memory) {
        require(bases.length == scalars.length, "!len");
        uint256 k = bases.length;
        uint256 N = 8 * k;
        uint256[] memory input = new uint[](N);
        for (uint256 i = 0; i < k; i++) {
            Bw6G1 memory base = bases[i];
            Bw6Fr memory scalar = scalars[i];
            input[i * 8] = base.x.a;
            input[i * 8 + 1] = base.x.b;
            input[i * 8 + 2] = base.x.c;
            input[i * 8 + 3] = base.y.a;
            input[i * 8 + 4] = base.y.b;
            input[i * 8 + 5] = base.y.c;
            input[i * 8 + 6] = scalar.a;
            input[i * 8 + 7] = scalar.b;
        }
        uint256[6] memory output;

        assembly ("memory-safe") {
            if iszero(staticcall(gas(), G1_MULTIEXP, add(input, 32), mul(N, 32), output, 192)) {
                let pt := mload(0x40)
                returndatacopy(pt, 0, returndatasize())
                revert(pt, returndatasize())
            }
        }

        return from(output);
    }

    /// @dev Derive Bw6G1 from uint256[6].
    /// @param x uint256[6].
    /// @return Bw6G1.
    function from(uint256[6] memory x) internal pure returns (Bw6G1 memory) {
        return Bw6G1(Bw6Fp(x[0], x[1], x[2]), Bw6Fp(x[3], x[4], x[5]));
    }

    /// @dev Serialize Bw6G1.
    /// @param g1 Bw6G1.
    /// @return r Compressed serialized bytes of Bw6G1.
    function serialize(Bw6G1 memory g1) internal pure returns (bytes memory r) {
        if (is_infinity(g1)) {
            r = new bytes(96);
            r[95] = INFINITY_FLAG;
        } else {
            Bw6Fp memory neg_y = g1.y.neg();
            bool y_flag = g1.y.gt(neg_y);
            r = g1.x.serialize();
            if (y_flag) {
                r[95] |= Y_IS_NEGATIVE;
            }
        }
    }

    /// @dev Debug Bw6G1 in bytes.
    /// @param self Bw6G1.
    /// @return Uncompressed serialized bytes of Bw6G1.
    function debug(Bw6G1 memory self) internal pure returns (bytes memory) {
        return abi.encodePacked(self.x.debug(), self.y.debug());
    }
}
