// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./bls12377/G1.sol";
import "./Bitmask.sol";

/// @dev Accountable public input.
/// @param apk Aggregate public key in BLS12-377.
/// @param bitmask Identify subset in the whole set of the validators of the previous era.
struct AccountablePublicInput {
    Bls12G1 apk;
    Bitmask bitmask;
}

/// @title PublicInput
library PublicInput {
    using BLS12G1Affine for Bls12G1;
    using BitMask for Bitmask;

    /// @dev Serialize AccountablePublicInput.
    /// @param self AccountablePublicInput.
    /// @return Compressed serialized bytes of AccountablePublicInput.
    function serialize(AccountablePublicInput memory self) internal pure returns (bytes memory) {
        return abi.encodePacked(self.apk.serialize(), self.bitmask.serialize());
    }
}
