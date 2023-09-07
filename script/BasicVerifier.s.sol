// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Script.sol";
import "../test/BasicVerifier.t.sol";

contract BasicVerifierScript is Script {
    function setUp() public {}

    function run() public {
        vm.broadcast();
        new BasicVerifierTest();
    }
}
