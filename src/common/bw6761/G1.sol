pragma solidity ^0.8.17;

import "./Fp.sol";
import "./Fr.sol";

struct Bw6G1Affine {
    Bw6Fp x;
    Bw6Fp y;
}

library BW6G1Affine {
    // BW6_G1_MUL
    uint8 private constant G1_MUL = 0x14;

    function zero() internal pure returns (Bw6G1Affine memory) {
        return Bw6G1Affine(
            BW6FP.zero(),
            BW6FP.zero()
        );
    }

    function mul(Bw6G1Affine memory self, Bw6Fr memory scalar) internal pure {
        uint[8] memory input;
        input[0] = self.x.a;
        input[1] = self.x.b;
        input[2] = self.x.c;
        input[3] = self.y.a;
        input[4] = self.y.b;
        input[5] = self.y.c;
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

        self.x.a = output[0];
        self.x.b = output[1];
        self.x.c = output[2];
        self.y.a = output[3];
        self.y.b = output[4];
        self.y.c = output[5];
    }
}
