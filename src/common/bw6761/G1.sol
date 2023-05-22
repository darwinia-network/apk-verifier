pragma solidity ^0.8.17;

import "./Fp.sol";
import "./Fr.sol";

struct Bw6G1Affine {
    Bw6Fp x;
    Bw6Fp y;
}

library BW6G1Affine {
    // BW6_G1_ADD
    uint private constant G1_ADD = 0x13;
    // BW6_G1_MUL
    uint8 private constant G1_MUL = 0x14;

    function zero() internal pure returns (Bw6G1Affine memory) {
        return Bw6G1Affine(
            BW6FP.zero(),
            BW6FP.zero()
        );
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

    function from(uint[6] memory x) internal pure returns (Bw6G1Affine memory) {
        return Bw6G1Affine(
            Bw6Fp(x[0], x[1], x[2]),
            Bw6Fp(x[3], x[4], x[5])
        );
    }
}
