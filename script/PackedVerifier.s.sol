// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Script.sol";
import "../src/PackedVerifier.sol";
import "../test/PackedVerifier.t.sol";
import "../test/common/PackedInput.t.sol";

contract PackedVerifierScript is Script {
    function setUp() public {}

    function run() public {
        PackedInputTest s = new PackedInputTest();
        vm.startBroadcast();
        new PackedVerifierTest;
        // Bw6G1[2] memory pks_comm = s.build_pks_comm();
        // PackedVerifier v = new PackedVerifier(pks_comm);
        vm.stopBroadcast();
    }
}
