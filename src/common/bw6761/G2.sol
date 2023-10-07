// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.17;

import "./Fp.sol";

/// @dev BW6-761 G2 of affine coordinates in short Weierstrass.
/// @param x X over the base field.
/// @param y Y over the base field.
struct Bw6G2 {
    Bw6Fp x;
    Bw6Fp y;
}

/// @title BW6G2Affine
library BW6G2Affine {
    using BW6FP for Bw6Fp;

    /// @dev INFINITY_FLAG
    bytes1 private constant INFINITY_FLAG = bytes1(0x40);
    /// @dev Y_IS_NEGATIVE
    bytes1 private constant Y_IS_NEGATIVE = bytes1(0x80);

    /// @dev Returns the additive identity element of Bw6G2.
    /// @return Bw6G2(BW6FP.zero(), BW6FP.zero())
    function zero() internal pure returns (Bw6G2 memory) {
        return Bw6G2(BW6FP.zero(), BW6FP.zero());
    }

    /// @dev Returns `true` if `self` is equal to the additive identity.
    /// @param self Bw6G2.
    /// @return Result of zero check.
    function is_zero(Bw6G2 memory self) internal pure returns (bool) {
        return self.x.is_zero() && self.y.is_zero();
    }

    /// @dev Returns `true` if `self` is infinity point.
    /// @param self Bw6G2.
    /// @return Result of infinity check.
    function is_infinity(Bw6G2 memory self) internal pure returns (bool) {
        return is_zero(self);
    }

    /// @dev Serialize Bw6G2.
    /// @param g2 Bw6G2.
    /// @return r Compressed serialized bytes of Bw6G2.
    function serialize(Bw6G2 memory g2) internal pure returns (bytes memory r) {
        if (is_infinity(g2)) {
            r = new bytes(96);
            r[95] = INFINITY_FLAG;
        } else {
            Bw6Fp memory neg_y = g2.y.neg();
            bool y_flag = g2.y.gt(neg_y);
            r = g2.x.serialize();
            if (y_flag) {
                r[95] |= Y_IS_NEGATIVE;
            }
        }
    }
}
