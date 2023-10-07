// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.17;

import "../../bw6761/Fr.sol";
import "../../bytes/ByteOrder.sol";

/// @dev Defines a domain over which finite field (I)FFTs can be performed. Works
/// only for fields that have a large multiplicative subgroup of size that is
/// a power-of-2.
/// @param size The size of the domain.
/// @param log_size_of_group `log_2(self.size)`.
/// @param size_as_field_element Size of the domain as a field element.
/// @param size_inv Inverse of the size in the field.
/// @param group_gen A generator of the subgroup.
/// @param group_gen_inv Inverse of the generator of the subgroup.
/// @param offset Offset that specifies the coset.
/// @param offset_inv Inverse of the offset that specifies the coset.
/// @param offset_pow_size Constant coefficient for the vanishing polynomial, Equals `self.offset^self.size`.
struct Radix2EvaluationDomain {
    uint64 size;
    uint32 log_size_of_group;
    Bw6Fr size_as_field_element;
    Bw6Fr size_inv;
    Bw6Fr group_gen;
    Bw6Fr group_gen_inv;
    Bw6Fr offset;
    Bw6Fr offset_inv;
    Bw6Fr offset_pow_size;
}

/// @title Radix2
library Radix2 {
    using BW6FR for Bw6Fr;

    /// @dev log_n
    uint32 internal constant LOG_N = 8;

    /// @dev Domain used to interpolate pks.
    function init() public pure returns (Radix2EvaluationDomain memory) {
        return Radix2EvaluationDomain({
            size: 256,
            log_size_of_group: LOG_N,
            size_as_field_element: Bw6Fr(0, 256),
            size_inv: Bw6Fr(
                0x1ac8c0bd1ad4bd9db74cabaac34a7f1, 0xdf08b7190df41e7b8fd46ecd8a4f3eb816f451e6ebd000008483b74000000001
                ),
            group_gen: Bw6Fr(
                0x1002f29b90f34d050aca1e5fa3f7633, 0x712d6bc0d484c501aed11a0c88d9f8c87a0c14230db0b91cb42b84a2dce33f04
                ),
            group_gen_inv: Bw6Fr(
                0x3c41de81751c63b6e0389795b5feba, 0xeffa4f9e8f3b8a87ee9ee3eabaa65f2ab40a45e807458704a002ea0add4e93c5
                ),
            offset: BW6FR.one(),
            offset_inv: BW6FR.one(),
            offset_pow_size: BW6FR.one()
        });
    }

    /// @dev Serialize Radix2EvaluationDomain.
    /// @param self Radix2EvaluationDomain.
    /// @return Compressed serialized bytes of Radix2EvaluationDomain.
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
