pragma solidity ^0.8.17;

import "./Fp.sol";

struct Bls12G1Affine {
    Bls12Fp x;
    Bls12Fp y;
}

library BLS12G1 {
    // BLS12_377_G1ADD
    uint private constant G1_ADD = 0x13;

    function point_in_g1_complement() internal pure returns (Bls12G1Affine memory) {
        return Bls12G1Affine({
            x: Bls12Fp(0, 0),
            y: Bls12Fp(0, 1)
        });
    }

    function add(Bls12G1Affine memory p, Bls12G1Affine memory q) internal view returns (Bls12G1Affine memory) {
        uint[8] memory input;
        input[0] = p.x.a;
        input[1] = p.x.b;
        input[2] = p.y.a;
        input[3] = p.y.b;
        input[4] = q.x.a;
        input[5] = q.x.b;
        input[6] = q.y.a;
        input[7] = q.y.b;
        uint[4] memory output;

        assembly ("memory-safe") {
            if iszero(staticcall(gas(), G1_ADD, input, 256, output, 128)) {
                let pt := mload(0x40)
                returndatacopy(pt, 0, returndatasize())
                revert(pt, returndatasize())
            }
        }

        return from(output);
    }

    function from(uint[4] memory x) internal pure returns (Bls12G1Affine memory) {
        return Bls12G1Affine(Bls12Fp(x[0], x[1]), Bls12Fp(x[2], x[3]));
    }
}
