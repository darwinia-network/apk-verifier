pragma solidity ^0.8.17;

import "./bw6761/G1.sol";
import "./bls12377/G2.sol";

struct KeysetCommitment {
    Bw6G1Affine[2] pks_comm;
    uint32 log_domain_size;
}

library KeySet {
// 196
// d2a6843b098fc7aa6c612cd28f3637d5472d6ae4e71a399b39b64e5e1888567a3ffd79c8a20e43a0c4c15f1496c0f78cd1da87ad3d26b7eea1a5bc4bfd8caf567018b0020c573ba583f5d93b8af2ac7bad9b44523e0329aecf5cb61e33d9ec809ff9962f2673349e3c0e5a7ebbd007f40ee96bb684bf07cd2290379d29a0ad7e5d20f166096ff491413f2eabf1b15b3693a792c1403ffff4180ac0af21294049c2d612566d392179aa00d5168d8940b495ef3e2af93ddbc3e6b459779042048108000000
// 41ef33f28c04949108c172383f6dbfcb90b0b728717db3d5b98b7feebefe87d7acd6a384abc2ad506096423f494e96618af9a38fcac56330fc6d59780565ed1f04f6dcafa949436c1c381e568c6bffb98d538fe1a9a71f6c604cb3f647ca8800d7e9678f368b5d6f06c650ecdc208c87da53ad33283a2aae82ff3c7ca8b4b678986e82eb71fcd0d474780adf6b7f3c8cd5d8af5a881496d3b66ac203f473b498ce48ea748ab4722af122b86e13eebc0abed1f465ccc9817e89204eab3523488008000000
    function serialize(KeysetCommitment memory self) internal pure returns (bytes memory) {
        bytes memory x = pks_comm[0].serialize();
        bytes memory y = pks_comm[1].serialize();
        // bytes memory s = log_domain_size.serialize();
    }

    function hash_commitment(KeysetCommitment  memory self) internal pure returns () {
    }
}
