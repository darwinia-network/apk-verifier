// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Script.sol";
import "../test/BasicVerifier.t.sol";
import "../test/common/SimpleInput.t.sol";

contract BasicVerifierScript is Script {
    function setUp() public {}

    function run() public {
        vm.startBroadcast();
        SimpleInputTest s = new SimpleInputTest();
        WrapperBasicVerifierTest t = new WrapperBasicVerifierTest();
        t.setUp(address(s));
        vm.stopBroadcast();
    }
}


contract WrapperBasicVerifierTest {
    using SimpleTranscript for Transcript;
    using BW6FR for Bw6Fr;

    BasicVerifier verifier;
    SimpleInputTest s;
    function setUp(address simple) public {
        s = SimpleInputTest(simple);
        Bw6G1[2] memory pks_comm = s.build_pks_comm();
        verifier = new BasicVerifier(pks_comm);
    }

    function test_verify_aggregates() public {
        AccountablePublicInput memory public_input = s.build_public_input();
        SimpleProof memory proof = s.build_proof();
        Bls12G2 memory aggregate_signature = s.build_aggregate_signature();
        KeysetCommitment memory new_validator_set_commitment = s.build_new_validator_set_commitment();

        verifier.verify_aggregates(public_input, proof, aggregate_signature, new_validator_set_commitment);
    }
}
