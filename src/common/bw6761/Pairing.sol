pragma solidity ^0.8.17;

import "./G1.sol";
import "./G2.sol";

library BW6Pairing {
    // BW6_PAIRING
    uint8 private constant BW6_PAIRING = 0x24;

    function pairing(Bw6G1[] memory a, Bw6G2[] memory b) internal view returns (bool) {
        require(a.length == b.length, "!len");
        uint256 k = a.length;
        uint256 N = 12 * k;
        uint256[] memory input = new uint[](N);
        for (uint256 i = 0; i < k; i++) {
            Bw6G1 memory g1 = a[i];
            Bw6G2 memory g2 = b[i];
            input[i * k] = g1.x.a;
            input[i * k + 1] = g1.x.b;
            input[i * k + 2] = g1.x.c;
            input[i * k + 3] = g1.y.a;
            input[i * k + 4] = g1.y.b;
            input[i * k + 5] = g1.y.c;
            input[i * k + 6] = g2.x.a;
            input[i * k + 7] = g2.x.b;
            input[i * k + 8] = g2.x.c;
            input[i * k + 9] = g2.y.a;
            input[i * k + 10] = g2.y.b;
            input[i * k + 11] = g2.y.c;
        }
        bool output;

        assembly ("memory-safe") {
            if iszero(staticcall(gas(), BW6_PAIRING, input, mul(N, 32), output, 32)) {
                let pt := mload(0x40)
                returndatacopy(pt, 0, returndatasize())
                revert(pt, returndatasize())
            }
        }

        return output;
    }
}
