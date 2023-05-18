pragma solidity ^0.8.17;

struct Bw6Fr {
    uint a;
    uint b;
}

library BW6FR {
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
            z.b = x.b + y.b;
            z.a = x.a + y.a + (z.b >= x.b && x.b >= y.b ? 0 : 1);
        }
    }

    function add(Bw6Fr memory x, Bw6Fr memory y) internal pure returns (Bw6Fr memory z) {
        z = add_nomod(x, y);
        if (is_geq_modulus(z)) {
            z = subtract_modulus(z);
        }
    }

    function subtract_modulus(Bw6Fr memory self) internal pure returns (Bw6Fr memory) {
        return sub(self, r());
    }

    function sub(Bw6Fr memory x, Bw6Fr memory y) internal pure returns (Bw6Fr memory z) {
        Bw6Fr memory m = x;
        if (gt(y, x)) {
            m = add_nomod(m, r());
        }
        unchecked {
            z.b = m.b - y.b;
            z.a = m.a - y.a - (z.b <= m.b ? 0 : 1);
        }
    }

    function mul(Bw6Fr memory x, Bw6Fr memory y) internal pure returns (Bw6Fr memory z) {

    }

    function square(Bw6Fr memory self) internal view returns (Bw6Fr memory) {
        uint[8] memory input;
        input[0] = 0x40;
        input[1] = 0x20;
        input[2] = 0x40;
        input[3] = self.a;
        input[4] = self.b;
        input[5] = 1;
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
}
