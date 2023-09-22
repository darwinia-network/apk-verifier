// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "../src/Basic.sol";
import "../src/common/bw6761/G1.sol";
import "./common/SimpleInput.t.sol";

contract BasicTest is SimpleInputTest {
    using SimpleTranscript for Transcript;
    using BW6FR for Bw6Fr;

    Basic verifier;

    function setUp() public {
        Bw6G1[2] memory pks_comm = [pks_comm_x, pks_comm_y];
        verifier = new Basic(pks_comm);
    }

    function test_verify_aggregates() public {
        AccountablePublicInput memory public_input = build_public_input();
        SimpleProof memory proof = build_proof();
        Bls12G2 memory aggregate_signature = build_aggregate_signature();
        KeysetCommitment memory new_validator_set_commitment = build_new_validator_set_commitment();

        verifier.verify_aggregates(public_input, proof, aggregate_signature, new_validator_set_commitment);
    }
}
