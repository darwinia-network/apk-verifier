pragma solidity ^0.8.17;

import "./bw6761/G1.sol";

struct KeysetCommitment {
    Bw6G1Affine[2] pks_comm;
    uint32 log_domain_size;
}
