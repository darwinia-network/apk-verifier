// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./G1.sol";
import "./G2.sol";

/// @title BW6Pairing
library BW6Pairing {
    /// @dev BW6_PAIRING precompile address.
    // uint256 private constant BW6_PAIRING = 0x24;
    uint256 private constant BW6_PAIRING = 0x0810;

    /// @dev Computes a "product" of pairings.
    /// @param a List of Bw6G1.
    /// @param b List of Bw6G2.
    /// @return True if pairing output is 1.
    function pairing(Bw6G1[] memory a, Bw6G2[] memory b) internal view returns (bool) {
        require(a.length == b.length, "!len");
        uint256 K = a.length;
        uint256 N = 12 * K;
        uint256[] memory input = new uint[](N);
        for (uint256 i = 0; i < K; i++) {
            Bw6G1 memory g1 = a[i];
            Bw6G2 memory g2 = b[i];
            input[i * 12] = g1.x.a;
            input[i * 12 + 1] = g1.x.b;
            input[i * 12 + 2] = g1.x.c;
            input[i * 12 + 3] = g1.y.a;
            input[i * 12 + 4] = g1.y.b;
            input[i * 12 + 5] = g1.y.c;
            input[i * 12 + 6] = g2.x.a;
            input[i * 12 + 7] = g2.x.b;
            input[i * 12 + 8] = g2.x.c;
            input[i * 12 + 9] = g2.y.a;
            input[i * 12 + 10] = g2.y.b;
            input[i * 12 + 11] = g2.y.c;
        }
        uint256[1] memory output;

        assembly ("memory-safe") {
            if iszero(staticcall(gas(), BW6_PAIRING, add(input, 32), mul(N, 32), output, 32)) {
                let pt := mload(0x40)
                returndatacopy(pt, 0, returndatasize())
                revert(pt, returndatasize())
            }
        }

        return output[0] == 1;
    }
}
