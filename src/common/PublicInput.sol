// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./bls12377/G1.sol";
import "./Bitmask.sol";

struct AccountablePublicInput {
    Bls12G1 apk;
    Bitmask bitmask;
}

library PublicInput {
    using BLS12G1Affine for Bls12G1;

    function serialize(AccountablePublicInput memory self) internal pure returns (bytes memory) {
        return abi.encodePacked(self.apk.serialize(), self.bitmask.serialize());
    }
}
