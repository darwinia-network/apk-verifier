// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./bw6761/G1.sol";
import "./bls12377/G2.sol";
import "./bytes/ByteOrder.sol";

struct KeysetCommitment {
    Bw6G1[2] pks_comm;
    uint32 log_domain_size;
}

library KeySet {
    using BW6G1Affine for Bw6G1;
    using BLS12G2Affine for bytes;

    function serialize(KeysetCommitment memory self) internal pure returns (bytes memory) {
        return abi.encodePacked(
            self.pks_comm[0].serialize(), self.pks_comm[1].serialize(), ByteOrder.reverse32(self.log_domain_size)
        );
    }

    function hash_commitment(KeysetCommitment memory self) internal view returns (Bls12G2 memory) {
        bytes memory buf = serialize(self);
        return buf.hash_to_curve();
    }
}
