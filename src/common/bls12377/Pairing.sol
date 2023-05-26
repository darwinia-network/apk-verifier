pragma solidity ^0.8.17;

import "./G1.sol";
import "./G2.sol";

library BLS12Pairing {
    // BLS12_377_PAIRING
    uint8 private constant BLS12_PAIRING = 0x19;

    function pairing(Bls12G1Affine[] memory a, Bls12G2Affine[] memory b) internal view returns (bool) {
        require(a.length == b.length, "!len");
        uint k = a.length;
        uint N = 12 * k;
        uint[] memory input = new uint[](N);
        for (uint i = 0; i < k; i++) {
            Bls12G1Affine memory g1 = a[i];
            Bls12G2Affine memory g2 = b[i];
            input[i*k]    = g1.x.a;
            input[i*k+1]  = g1.x.b;
            input[i*k+2]  = g1.y.a;
            input[i*k+3]  = g1.y.b;
            input[i*k+4]  = g2.x.c0.a;
            input[i*k+5]  = g2.x.c0.b;
            input[i*k+6]  = g2.x.c1.a;
            input[i*k+7]  = g2.x.c1.b;
            input[i*k+8]  = g2.y.c0.a;
            input[i*k+9]  = g2.y.c0.b;
            input[i*k+10] = g2.y.c1.a;
            input[i*k+11] = g2.y.c1.b;
        }
        bool output;

        assembly ("memory-safe") {
            if iszero(staticcall(gas(), BLS12_PAIRING, input, mul(N, 32), output, 32)) {
                let pt := mload(0x40)
                returndatacopy(pt, 0, returndatasize())
                revert(pt, returndatasize())
            }
        }

        return output;
    }
}
