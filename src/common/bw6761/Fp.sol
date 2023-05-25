pragma solidity ^0.8.17;

import "../math/Math.sol";

struct Bw6Fp {
    uint a;
    uint b;
    uint c;
}

library BW6FP {
    using Math for uint256;

    // Base field: q = 0x122e824fb83ce0ad187c94004faff3eb926186a81d14688528275ef8087be41707ba638e584e91903cebaff25b423048689c8ed12f9fd9071dcd3dc73ebff2e98a116c25667a8f8160cf8aeeaf0a437e6913e6870000082f49d00000000008b
    function q() internal pure returns (Bw6Fp memory) {
        return Bw6Fp(
            0x122e824fb83ce0ad187c94004faff3eb926186a81d14688528275ef8087be41,
            0x707ba638e584e91903cebaff25b423048689c8ed12f9fd9071dcd3dc73ebff2e,
            0x98a116c25667a8f8160cf8aeeaf0a437e6913e6870000082f49d00000000008b);
    }

    function zero() internal pure returns (Bw6Fp memory) {
        return Bw6Fp(0, 0, 0);
    }

    function one() internal pure returns (Bw6Fp memory) {
        return Bw6Fp(0, 0, 1);
    }

    function is_zero(Bw6Fp memory self) internal pure returns (bool) {
        return eq(self, zero());
    }

    function is_geq_modulus(Bw6Fp memory self) internal pure returns (bool) {
        return (eq(self, q()) || gt(self, q()));
    }

    function eq(Bw6Fp memory x, Bw6Fp memory y) internal pure returns (bool) {
        return (x.a == y.a && x.b == y.b && x.c == y.c);
    }

    function gt(Bw6Fp memory x, Bw6Fp memory y) internal pure returns (bool) {
        return (
            x.a > y.a ||
            (x.a == y.a && x.b > y.b) ||
            (x.a == y.a && x.b == y.b && x.c > x.c)
       );
    }

    function neg(Bw6Fp memory self) internal pure {
        if (!is_zero(self)) {
            self = sub(q(), self);
        }
    }

    function add_nomod(Bw6Fp memory x, Bw6Fp memory y) internal pure returns (Bw6Fp memory z) {
        unchecked {
            uint8 carry = 0;
            (carry, z.c) = x.b.adc(y.c, carry);
            (carry, z.b) = x.b.adc(y.b, carry);
            (     , z.a) = x.a.adc(y.a, carry);
        }
    }

    function add(Bw6Fp memory x, Bw6Fp memory y) internal pure returns (Bw6Fp memory z) {
        z = add_nomod(x, y);
        subtract_modulus(z);
    }

    function subtract_modulus(Bw6Fp memory self) internal pure {
        if (is_geq_modulus(self)) {
            self = sub(self, q());
        }
    }

    function sub(Bw6Fp memory x, Bw6Fp memory y) internal pure returns (Bw6Fp memory z) {
        Bw6Fp memory m = x;
        if (gt(y, x)) {
            m = add_nomod(m, q());
        }
        unchecked {
            uint8 borrow = 0;
            (borrow, z.c) = m.b.sbb(y.c, borrow);
            (borrow, z.b) = m.b.sbb(y.b, borrow);
            (      , z.a) = m.a.sbb(y.a, borrow);
        }
    }

    function serialize(Bw6Fp memory x) internal pure returns (bytes memory) {
        bytes memory r = new bytes(96);
        bytes32 a = bytes32(x.a);
        bytes32 b = bytes32(x.b);
        bytes32 c = bytes32(x.c);
        for (uint i = 0; i < 32; i++) {
            r[i] = c[31-i];
        }
        for (uint j = 0; j < 32; j++) {
            r[32+j] = b[31-j];
        }
        for (uint k = 0; k < 32; k++) {
            r[64+k] = a[31-k];
        }
        return r;
    }
}
