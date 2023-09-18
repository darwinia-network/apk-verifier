// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "../math/Math.sol";
import "../bw6761/Fr.sol";
import "../bytes/ByteOrder.sol";

struct Bls12Fp {
    uint256 a;
    uint256 b;
}

library BLS12FP {
    using Math for uint256;

    uint8 private constant MOD_EXP = 0x05;

    //! * Base field: q = 258664426012969094010652733694893533536393512754914660539884262666720468348340822774968888139573360124440321458177
    function q() internal pure returns (Bls12Fp memory) {
        return Bls12Fp(
            0x1ae3a4617c510eac63b05c06ca1493b, 0x1a22d9f300f5138f1ef3622fba094800170b5d44300000008508c00000000001
        );
    }

    function zero() internal pure returns (Bls12Fp memory) {
        return Bls12Fp(0, 0);
    }

    function is_zero(Bls12Fp memory self) internal pure returns (bool) {
        return eq(self, zero());
    }

    function eq(Bls12Fp memory x, Bls12Fp memory y) internal pure returns (bool) {
        return (x.a == y.a && x.b == y.b);
    }

    function gt(Bls12Fp memory x, Bls12Fp memory y) internal pure returns (bool) {
        return (x.a > y.a || (x.a == y.a && x.b > y.b));
    }

    function neg(Bls12Fp memory self) internal pure returns (Bls12Fp memory z) {
        z = self;
        if (!is_zero(self)) {
            z = sub(q(), self);
        }
    }

    function add_nomod(Bls12Fp memory x, Bls12Fp memory y) internal pure returns (Bls12Fp memory z) {
        unchecked {
            uint8 carry = 0;
            (carry, z.b) = x.b.adc(y.b, carry);
            (, z.a) = x.a.adc(y.a, carry);
        }
    }

    function sub(Bls12Fp memory x, Bls12Fp memory y) internal pure returns (Bls12Fp memory z) {
        Bls12Fp memory m = x;
        if (gt(y, x)) {
            m = add_nomod(m, q());
        }
        unchecked {
            uint8 borrow = 0;
            (borrow, z.b) = m.b.sbb(y.b, borrow);
            (, z.a) = m.a.sbb(y.a, borrow);
        }
    }

    function into(Bls12Fp memory x) internal pure returns (Bw6Fr memory) {
        return Bw6Fr(x.a, x.b);
    }

    function serialize(Bls12Fp memory self) internal pure returns (bytes memory) {
        uint128 a = ByteOrder.reverse128(uint128(self.a));
        uint256 b = ByteOrder.reverse256(self.b);
        return abi.encodePacked(b, a);
    }

    function debug(Bls12Fp memory self) internal pure returns (bytes memory) {
        return abi.encodePacked(self.a, self.b);
    }

    function norm(Bls12Fp memory fp) internal view returns (Bls12Fp memory) {
        uint256[8] memory input;
        input[0] = 0x40;
        input[1] = 0x20;
        input[2] = 0x40;
        input[3] = fp.a;
        input[4] = fp.b;
        input[5] = 1;
        input[6] = q().a;
        input[7] = q().b;
        uint256[2] memory output;

        assembly ("memory-safe") {
            if iszero(staticcall(gas(), MOD_EXP, input, 256, output, 64)) {
                let p := mload(0x40)
                returndatacopy(p, 0, returndatasize())
                revert(p, returndatasize())
            }
        }
        return Bls12Fp(output[0], output[1]);
    }
}
