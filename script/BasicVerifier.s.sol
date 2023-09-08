// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Script.sol";
import "../test/BasicVerifier.t.sol";

contract BasicVerifierScript is Script {
    function setUp() public {}

    function run() public {
        vm.startBroadcast();
        BasicVerifierTest t = new BasicVerifierTest();
        t.setUp();
        vm.stopBroadcast();
    }
}
