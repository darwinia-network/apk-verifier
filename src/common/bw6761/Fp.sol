// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.17;

import "../math/Math.sol";
import "../bytes/ByteOrder.sol";

/// @dev BW6-761 prime field.
/// @param a High-order part 256 bits.
/// @param b Middle-order part 256 bits.
/// @param c Low-order part 256 bits.
struct Bw6Fp {
    uint256 a;
    uint256 b;
    uint256 c;
}

library BW6FP {
    using Math for uint256;

    /// @dev Returns base field: q = 0x122e824fb83ce0ad187c94004faff3eb926186a81d14688528275ef8087be41707ba638e584e91903cebaff25b423048689c8ed12f9fd9071dcd3dc73ebff2e98a116c25667a8f8160cf8aeeaf0a437e6913e6870000082f49d00000000008b
    /// @return Base field.
    function q() internal pure returns (Bw6Fp memory) {
        return Bw6Fp(
            0x122e824fb83ce0ad187c94004faff3eb926186a81d14688528275ef8087be41,
            0x707ba638e584e91903cebaff25b423048689c8ed12f9fd9071dcd3dc73ebff2e,
            0x98a116c25667a8f8160cf8aeeaf0a437e6913e6870000082f49d00000000008b
        );
    }

    /// @dev Returns the additive identity element of Bw6Fp.
    /// @return Bw6Fp(0, 0, 0)
    function zero() internal pure returns (Bw6Fp memory) {
        return Bw6Fp(0, 0, 0);
    }

    /// @dev Returns the multiplicative identity element of Bw6Fp.
    /// @return Bw6Fp(0, 0, 1)
    function one() internal pure returns (Bw6Fp memory) {
        return Bw6Fp(0, 0, 1);
    }

    /// @dev Returns `true` if `self` is equal to the additive identity.
    /// @param self Bw6Fp.
    /// @return Result of zero check.
    function is_zero(Bw6Fp memory self) internal pure returns (bool) {
        return eq(self, zero());
    }

    /// @dev Returns `true` if `self` is equal or larger than q.
    /// @param self Bw6Fp.
    /// @return Result of check.
    function is_geq_modulus(Bw6Fp memory self) internal pure returns (bool) {
        return (eq(self, q()) || gt(self, q()));
    }

    /// @dev Returns `true` if `x` is equal to `y`.
    /// @param x Bw6Fp.
    /// @param y Bw6Fp.
    /// @return Result of equal check.
    function eq(Bw6Fp memory x, Bw6Fp memory y) internal pure returns (bool) {
        return (x.a == y.a && x.b == y.b && x.c == y.c);
    }

    /// @dev Returns `true` if `x` is larger than `y`.
    /// @param x Bw6Fp.
    /// @param y Bw6Fp.
    /// @return Result of gt check.
    function gt(Bw6Fp memory x, Bw6Fp memory y) internal pure returns (bool) {
        return (x.a > y.a || (x.a == y.a && x.b > y.b) || (x.a == y.a && x.b == y.b && x.c > x.c));
    }

    /// @dev Returns the result negative of `self`.
    /// @param self Bw6Fp.
    /// @return z `- self`.
    function neg(Bw6Fp memory self) internal pure returns (Bw6Fp memory z) {
        z = self;
        if (!is_zero(self)) {
            z = sub(q(), self);
        }
    }

    /// @dev Returns the result of `x + y`.
    /// @param x Bw6Fp.
    /// @param y Bw6Fp.
    /// @return z `x + y`.
    function add_nomod(Bw6Fp memory x, Bw6Fp memory y) internal pure returns (Bw6Fp memory z) {
        unchecked {
            uint8 carry = 0;
            (carry, z.c) = x.b.adc(y.c, carry);
            (carry, z.b) = x.b.adc(y.b, carry);
            (, z.a) = x.a.adc(y.a, carry);
        }
    }

    /// @dev Returns the result of `(x + y) % p`.
    /// @param x Bw6Fp.
    /// @param y Bw6Fp.
    /// @return z `(x + y) % p`.
    function add(Bw6Fp memory x, Bw6Fp memory y) internal pure returns (Bw6Fp memory z) {
        z = add_nomod(x, y);
        subtract_modulus_to_norm(z);
    }

    function subtract_modulus_to_norm(Bw6Fp memory self) internal pure {
        if (is_geq_modulus(self)) {
            self = sub(self, q());
        }
    }

    /// @dev Returns the result of `(x - y) % p`.
    /// @param x Bw6Fp.
    /// @param y Bw6Fp.
    /// @return z `(x - y) % p`.
    function sub(Bw6Fp memory x, Bw6Fp memory y) internal pure returns (Bw6Fp memory z) {
        Bw6Fp memory m = x;
        if (gt(y, x)) {
            m = add_nomod(m, q());
        }
        unchecked {
            uint8 borrow = 0;
            (borrow, z.c) = m.c.sbb(y.c, borrow);
            (borrow, z.b) = m.b.sbb(y.b, borrow);
            (, z.a) = m.a.sbb(y.a, borrow);
        }
    }

    /// @dev Serialize Bw6Fp.
    /// @param self Bw6Fp.
    /// @return Compressed serialized bytes of Bw6Fp.
    function serialize(Bw6Fp memory self) internal pure returns (bytes memory) {
        uint256 a = ByteOrder.reverse256(self.a);
        uint256 b = ByteOrder.reverse256(self.b);
        uint256 c = ByteOrder.reverse256(self.c);
        return abi.encodePacked(c, b, a);
    }

    /// @dev Debug Bw6Fp in bytes.
    /// @param self Bw6Fp.
    /// @return Uncompressed serialized bytes of Bw6Fp.
    function debug(Bw6Fp memory self) internal pure returns (bytes memory) {
        return abi.encodePacked(self.a, self.b, self.c);
    }
}
