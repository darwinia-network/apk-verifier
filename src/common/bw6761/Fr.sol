pragma solidity ^0.8.17;

import "../math/Math.sol";

struct Bw6Fr {
    uint a;
    uint b;
}

library BW6FR {
    using Math for uint256;

    uint8 private constant MOD_EXP = 0x05;


    //! * Scalar field: r = 258664426012969094010652733694893533536393512754914660539884262666720468348340822774968888139573360124440321458177
    function r() internal pure returns (Bw6Fr memory) {
        return Bw6Fr(0x1ae3a4617c510eac63b05c06ca1493b, 0x1a22d9f300f5138f1ef3622fba094800170b5d44300000008508c00000000001);
    }

    function one() internal pure returns (Bw6Fr memory) {
        return Bw6Fr(0, 1);
    }

    function is_geq_modulus(Bw6Fr memory self) internal pure returns (bool) {
        return (eq(self, r()) || gt(self, r()));
    }

    function eq(Bw6Fr memory x, Bw6Fr memory y) internal pure returns (bool) {
        return (x.a == y.a && x.b == y.b);
    }

    function gt(Bw6Fr memory x, Bw6Fr memory y) internal pure returns (bool) {
        return (x.a > y.a || (x.a == y.a && x.b > y.b));
    }

    function add_nomod(Bw6Fr memory x, Bw6Fr memory y) internal pure returns (Bw6Fr memory z) {
        unchecked {
            uint8 carry = 0;
            (carry, z.b) = x.b.adc(y.b, carry);
            (     , z.a) = x.a.adc(y.a, carry);
        }
    }

    function add(Bw6Fr memory x, Bw6Fr memory y) internal pure returns (Bw6Fr memory z) {
        z = add_nomod(x, y);
        subtract_modulus(z);
    }

    function subtract_modulus(Bw6Fr memory self) internal pure {
        if (is_geq_modulus(self)) {
            self = sub(self, r());
        }
    }

    function sub(Bw6Fr memory x, Bw6Fr memory y) internal pure returns (Bw6Fr memory z) {
        Bw6Fr memory m = x;
        if (gt(y, x)) {
            m = add_nomod(m, r());
        }
        unchecked {
            uint8 borrow = 0;
            (borrow, z.b) = m.b.sbb(y.b, borrow);
            (      , z.a) = m.a.sbb(y.a, borrow);
        }
    }

    function sub(Bw6Fr[2] memory x, Bw6Fr[2] memory y) internal pure returns (Bw6Fr[2] memory z) {
        unchecked {
            uint8 borrow = 0;
            (borrow, z[1].b) = x[1].b.sbb(y[1].b, borrow);
            (borrow, z[1].a) = x[1].a.sbb(y[1].a, borrow);
            (borrow, z[0].b) = x[0].b.sbb(y[0].b, borrow);
            (      , z[0].a) = x[0].a.sbb(y[0].a, borrow);
        }
    }

    /// (a * b) = ((a + b)^2 - (a - b)^2) / 4
    function mul(Bw6Fr memory x, Bw6Fr memory y) internal view returns (Bw6Fr memory z) {
        Bw6Fr memory lhs = add(x, y);
        Bw6Fr[2] memory fst = square_nomod(lhs);
        // a==b ? (((a + b)**2 / 4
        if (eq(x, y)) {
            div2(fst);
            div2(fst);
            z = norm(fst);
        } else {
            Bw6Fr memory rhs = sub(x, y);
            Bw6Fr[2] memory snd = square_nomod(rhs);
            Bw6Fr[2] memory r = sub(fst, snd);
            div2(r);
            div2(r);
            z = norm(r);
        }
    }

    function div2(Bw6Fr[2] memory self) internal pure {
        self[1].b = self[1].b >> 1 + self[1].a << 255;
        self[1].a = self[1].a >> 1 + self[0].b << 255;
        self[0].b = self[0].b >> 1 + self[0].a << 255;
        self[0].a = self[0].a >> 1;
    }

    function square_nomod(Bw6Fr memory self) internal view returns (Bw6Fr[2] memory) {
        uint[7] memory input;
        input[0] = 0x40;
        input[1] = 0x20;
        input[2] = 0x20;
        input[3] = self.a;
        input[4] = self.b;
        input[5] = 2;
        input[6] = 1;
        uint[4] memory output;

        assembly ("memory-safe") {
            if iszero(staticcall(gas(), MOD_EXP, input, 224, output, 128)) {
                let p := mload(0x40)
                returndatacopy(p, 0, returndatasize())
                revert(p, returndatasize())
            }
        }
        return [Bw6Fr(output[0], output[1]), Bw6Fr(output[2], output[3])];
    }

    function square(Bw6Fr memory self) internal view returns (Bw6Fr memory) {
        uint[8] memory input;
        input[0] = 0x40;
        input[1] = 0x20;
        input[2] = 0x40;
        input[3] = self.a;
        input[4] = self.b;
        input[5] = 2;
        input[6] = r().a;
        input[7] = r().b;
        uint[2] memory output;

        assembly ("memory-safe") {
            if iszero(staticcall(gas(), MOD_EXP, input, 256, output, 64)) {
                let p := mload(0x40)
                returndatacopy(p, 0, returndatasize())
                revert(p, returndatasize())
            }
        }
        return Bw6Fr(output[0], output[1]);
    }

    function norm(Bw6Fr[2] memory self) internal view returns (Bw6Fr memory) {
        uint[10] memory input;
        input[0] = 0x80;
        input[1] = 0x20;
        input[2] = 0x40;
        input[3] = self[0].a;
        input[4] = self[0].b;
        input[5] = self[1].a;
        input[6] = self[1].b;
        input[7] = 1;
        input[8] = r().a;
        input[9] = r().b;
        uint[2] memory output;

        assembly ("memory-safe") {
            if iszero(staticcall(gas(), MOD_EXP, input, 320, output, 64)) {
                let p := mload(0x40)
                returndatacopy(p, 0, returndatasize())
                revert(p, returndatasize())
            }
        }
        return Bw6Fr(output[0], output[1]);
    }
}
