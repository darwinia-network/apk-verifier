// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

library Math {
    function adc(uint256 a, uint256 b, uint8 carry) internal pure returns (uint8, uint256) {
        unchecked {
            uint256 c = a + b;
            uint256 d = c + uint256(carry);
            if (c < a || d < c) return (1, d);
            return (0, d);
        }
    }

    function sbb(uint256 a, uint256 b, uint8 borrow) internal pure returns (uint8, uint256) {
        unchecked {
            uint256 c = a - uint256(borrow);
            if (b > c) return (1, (c - b));
            return (0, (c - b));
        }
    }
}
