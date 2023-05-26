pragma solidity ^0.8.17;

import "./bw6761/G1.sol";
import "./bls12377/G2.sol";

struct KeysetCommitment {
    Bw6G1Affine[2] pks_comm;
    uint32 log_domain_size;
}

library KeySet {
    using BLS12G2 for bytes;
    using BW6G1Affine for Bw6G1Affine;

    function serialize(KeysetCommitment memory self) internal pure returns (bytes memory) {
        bytes memory x = self.pks_comm[0].serialize();
        bytes memory y = self.pks_comm[1].serialize();
        bytes memory s = to_little_endian_32(self.log_domain_size);
    }

    function hash_commitment(KeysetCommitment  memory self) internal view returns (Bls12G2Affine memory) {
        bytes memory buf = serialize(self);
        return buf.hash_to_curve();
    }

    function to_little_endian_32(uint32 value) internal pure returns (bytes memory ret) {
        ret = new bytes(4);
        bytes4 bytesValue = bytes4(value);
        ret[0] = bytesValue[3];
        ret[1] = bytesValue[2];
        ret[2] = bytesValue[1];
        ret[3] = bytesValue[0];
    }
}
