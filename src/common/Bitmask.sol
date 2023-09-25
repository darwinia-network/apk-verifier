// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./bytes/Bits.sol";
import "./bytes/ByteOrder.sol";


/// @dev Bitmask bitvector of signers.
/// @notice The highest limb of bitmask is left padded with 0s.
/// @param limbs Internal representation for bitmask.
/// @param padding_size The size of left padded 0s.
struct Bitmask {
    uint256[] limbs;
    uint64 padding_size;
}

/// @title Bitmask
/// @custom:inspired From https://github.com/Snowfork/snowbridge/blob/main/core/packages/contracts/contracts/utils/Bitfield.sol
library BitMask {
    using Bits for uint256;

    /// @dev Constants used to efficiently calculate the hamming weight of a bitfield. See
    /// https://en.wikipedia.org/wiki/Hamming_weight#Efficient_implementation for an explanation of those constants.

    uint256 internal constant M1 = 0x5555555555555555555555555555555555555555555555555555555555555555;
    uint256 internal constant M2 = 0x3333333333333333333333333333333333333333333333333333333333333333;
    uint256 internal constant M4 = 0x0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f;
    uint256 internal constant M8 = 0x00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff;
    uint256 internal constant M16 = 0x0000ffff0000ffff0000ffff0000ffff0000ffff0000ffff0000ffff0000ffff;
    uint256 internal constant M32 = 0x00000000ffffffff00000000ffffffff00000000ffffffff00000000ffffffff;
    uint256 internal constant M64 = 0x0000000000000000ffffffffffffffff0000000000000000ffffffffffffffff;
    uint256 internal constant M128 = 0x00000000000000000000000000000000ffffffffffffffffffffffffffffffff;

    uint256 internal constant BITS_IN_LIMB = 256;

    uint256 internal constant NNNN = 4;

    /// @dev Calculates the number of set bits by using the hamming weight of the bitfield.
    /// The algorithm below is implemented after https://en.wikipedia.org/wiki/Hamming_weight#Efficient_implementation.
    /// Further improvements are possible, see the article above.
    /// @param self Bitmask.
    /// @return Ones count of bitmask.
    function count_ones(Bitmask memory self) internal pure returns (uint256) {
        unchecked {
            uint256 count = 0;
            for (uint256 i = 0; i < self.limbs.length; i++) {
                uint256 x = self.limbs[i];
                count += count_ones(x);
            }
            return count;
        }
    }

    // TODO: padding
    function count_ones(uint256 x) internal pure returns (uint256) {
        unchecked {
            x = (x & M1) + ((x >> 1) & M1); //put count of each  2 bits into those  2 bits
            x = (x & M2) + ((x >> 2) & M2); //put count of each  4 bits into those  4 bits
            x = (x & M4) + ((x >> 4) & M4); //put count of each  8 bits into those  8 bits
            x = (x & M8) + ((x >> 8) & M8); //put count of each 16 bits into those 16 bits
            x = (x & M16) + ((x >> 16) & M16); //put count of each 32 bits into those 32 bits
            x = (x & M32) + ((x >> 32) & M32); //put count of each 64 bits into those 64 bits
            x = (x & M64) + ((x >> 64) & M64); //put count of each 128 bits into those 128 bits
            x = (x & M128) + ((x >> 128) & M128); //put count of each 256 bits into those 256 bits
        }
        return x;
    }

    /// @dev Actual size of bitmask, not including the padding.
    /// @param self Bitmask.
    /// @return Size of bitmask.
    function size(Bitmask memory self) internal pure returns (uint256) {
        return BITS_IN_LIMB * self.limbs.length - self.padding_size;
    }

    /// @dev Bit at index of bitmask.
    /// @param self Bitmask.
    /// @param index The index of bitmask.
    /// @return Bit at index of bitmask.
    function at(Bitmask memory self, uint256 index) internal pure returns (bool) {
        uint256 part = index >> 8;
        uint8 b = uint8(index & 0xFF);
        return self.limbs[part].bit(b) == 1;
    }

    // TODO: only support limbs len == 1
    function serialize(Bitmask memory self) internal pure returns (bytes memory) {
        return abi.encodePacked(
            ByteOrder.reverse64(uint64(self.limbs.length * NNNN)),
            ByteOrder.reverse256(self.limbs[0]),
            ByteOrder.reverse64(self.padding_size)
        );
    }
}
