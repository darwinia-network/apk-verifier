pragma solidity ^0.8.17;

import "./Fp.sol";
import "./Fr.sol";

struct Bw6G1Affine {
    Bw6Fp x;
    Bw6Fp y;
}

library BW6G1Affine {
    using BW6FP for Bw6Fp;

    // BW6_G1_ADD
    uint private constant G1_ADD = 0x13;
    // BW6_G1_MUL
    uint8 private constant G1_MUL = 0x14;
    // BW6_G1_MULTIEXP
    uint8 private constant G1_MULTIEXP = 0x15;

    bytes1 private constant INFINITY_FLAG = bytes1(0x40);
    bytes1 private constant Y_IS_NEGATIVE = bytes1(0x80);

    function zero() internal pure returns (Bw6G1Affine memory) {
        return Bw6G1Affine(
            BW6FP.zero(),
            BW6FP.zero()
        );
    }

    function is_zero(Bw6G1Affine memory p) internal pure returns (bool) {
        return p.x.is_zero() && p.y.is_zero();
    }

    function is_infinity(Bw6G1Affine memory p) internal pure returns (bool) {
        return is_zero(p);
    }

    /// If `self.is_zero()`, returns `self` (`== Self::zero()`).
    /// Else, returns `(x, -y)`, where `self = (x, y)`.
    function neg(Bw6G1Affine memory self) internal pure {
        self.y.neg();
    }

    function add(Bw6G1Affine memory p, Bw6G1Affine memory q) internal view returns (Bw6G1Affine memory) {
        uint[12] memory input;
        input[0]  = p.x.a;
        input[1]  = p.x.b;
        input[2]  = p.x.c;
        input[3]  = p.y.a;
        input[4]  = p.y.b;
        input[5]  = p.y.c;
        input[6]  = q.x.a;
        input[7]  = q.x.b;
        input[8]  = q.x.c;
        input[9]  = q.y.a;
        input[10] = q.y.b;
        input[11] = q.y.c;
        uint[6] memory output;

        assembly ("memory-safe") {
            if iszero(staticcall(gas(), G1_ADD, input, 384, output, 192)) {
                let pt := mload(0x40)
                returndatacopy(pt, 0, returndatasize())
                revert(pt, returndatasize())
            }
        }

        return from(output);
    }

    function sub(Bw6G1Affine memory p, Bw6G1Affine memory q) internal view returns (Bw6G1Affine memory z) {
        neg(q);
        z = add(p, q);
    }

    function mul(Bw6G1Affine memory p, Bw6Fr memory scalar) internal view returns (Bw6G1Affine memory) {
        uint[8] memory input;
        input[0] = p.x.a;
        input[1] = p.x.b;
        input[2] = p.x.c;
        input[3] = p.y.a;
        input[4] = p.y.b;
        input[5] = p.y.c;
        input[6] = scalar.a;
        input[7] = scalar.b;
        uint[6] memory output;

        assembly ("memory-safe") {
            if iszero(staticcall(gas(), G1_MUL, input, 256, output, 192)) {
                let pt := mload(0x40)
                returndatacopy(pt, 0, returndatasize())
                revert(pt, returndatasize())
            }
        }

        return from(output);
    }

    function msm(Bw6G1Affine[] memory bases, Bw6Fr[] memory scalars) internal view returns (Bw6G1Affine memory) {
        require(bases.length == scalars.length, "!len");
        uint k = bases.length;
        uint N = 8 * k;
        uint[] memory input = new uint[](N);
        for (uint i = 0; i < k; i++) {
            Bw6G1Affine memory base = bases[i];
            Bw6Fr memory scalar = scalars[i];
            input[i*k] = base.x.a;
            input[i*k+1] = base.x.b;
            input[i*k+2] = base.x.c;
            input[i*k+3] = base.y.a;
            input[i*k+4] = base.y.b;
            input[i*k+5] = base.y.c;
            input[i*k+6] = scalar.a;
            input[i*k+7] = scalar.b;
        }
        uint[6] memory output;

        assembly ("memory-safe") {
            if iszero(staticcall(gas(), G1_MULTIEXP, add(input, 32), mul(N, 32), output, 192)) {
                let pt := mload(0x40)
                returndatacopy(pt, 0, returndatasize())
                revert(pt, returndatasize())
            }
        }

        return from(output);
    }

    function from(uint[6] memory x) internal pure returns (Bw6G1Affine memory) {
        return Bw6G1Affine(
            Bw6Fp(x[0], x[1], x[2]),
            Bw6Fp(x[3], x[4], x[5])
        );
    }

    function serialize(Bw6G1Affine memory g1) internal pure returns (bytes memory r) {
        if (is_infinity(g1)) {
            r = new bytes(96);
            r[95] = INFINITY_FLAG;
        } else {
            Bw6Fp memory neg_y = g1.y;
            neg_y.neg();
            bool y_flag = g1.y.gt(neg_y);
            r = g1.x.serialize();
            if (y_flag) {
                r[95] |= Y_IS_NEGATIVE;
            }
        }
    }
}
