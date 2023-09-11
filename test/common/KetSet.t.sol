// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./SimpleInput.t.sol";
import "../../src/common/KeySet.sol";
import "../../src/common/poly/domain/Radix2.sol";

contract KetSetTest is SimpleInputTest {
    using KeySet for KeysetCommitment;

    KeysetCommitment public pks_comm;

    function setUp() public {
        pks_comm.pks_comm[0] = pks_comm_x;
        pks_comm.pks_comm[1] = pks_comm_y;
        pks_comm.log_domain_size = Radix2.LOG_N;
    }

    function test_serialize() public {
        bytes memory s = pks_comm.serialize();
        bytes memory e = pks_comm_compressed();
        assertEq(e, s);
    }

    function pks_comm_compressed() internal pure returns (bytes memory) {
        return hex'dbfa5f860754066725848619f95fd9e7f120443edcc4ea0a0071829566f19f00185c7b574551cf2684da7fea7f099566d4435066b513e69d2cf7e2aa094330b2e3484f06af49c300b451f754b1bc4b1b7f7c481aba82489d90904ffc275a7a00f593e8dfff43254d1a29b881218cfa2baaa1548a71b5a586959a8414007ff869a5893b3059b230073d3d0b1ed117d9089fb8b3981317197e99817bc434f37a27cbbe9bbf3b3fe16fb040b38ee6ed773e694bff7aea970ed3d71df03e8662a28008000000';
    }
}
