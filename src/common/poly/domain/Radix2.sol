// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "../../bw6761/Fr.sol";
import "../../bytes/ByteOrder.sol";

struct Radix2EvaluationDomain {
    /// The size of the domain.
    uint64 size;
    /// `log_2(self.size)`.
    uint32 log_size_of_group;
    /// Size of the domain as a field element.
    Bw6Fr size_as_field_element;
    /// Inverse of the size in the field.
    Bw6Fr size_inv;
    /// A generator of the subgroup.
    Bw6Fr group_gen;
    /// Inverse of the generator of the subgroup.
    Bw6Fr group_gen_inv;
    /// Offset that specifies the coset.
    Bw6Fr offset;
    /// Inverse of the offset that specifies the coset.
    Bw6Fr offset_inv;
    /// Constant coefficient for the vanishing polynomial.
    /// Equals `self.offset^self.size`.
    Bw6Fr offset_pow_size;
}

library Radix2 {
    using BW6FR for Bw6Fr;

    function serialize(Radix2EvaluationDomain memory self) internal pure returns (bytes memory) {
        return abi.encodePacked(
            ByteOrder.reverse64(self.size),
            ByteOrder.reverse32(self.log_size_of_group),
            self.size_as_field_element.serialize(),
            self.size_inv.serialize(),
            self.group_gen.serialize(),
            self.group_gen_inv.serialize(),
            self.offset.serialize(),
            self.offset_inv.serialize(),
            self.offset_pow_size.serialize()
        );
    }
}
