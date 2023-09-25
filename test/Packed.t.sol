// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "../src/Packed.sol";
import "../src/common/bw6761/G1.sol";
import "./common/PackedInput.t.sol";

contract PackedTest is PackedInputTest {
    Packed verifier;

    function setUp() public {
        Bw6G1[2] memory pks_comm = [pks_comm_x, pks_comm_y];
        verifier = new Packed(pks_comm);
    }

    function test_verify_aggregates() public {
        AccountablePublicInput memory public_input = build_public_input();
        PackedProof memory proof = build_proof();
        Bls12G2 memory aggregate_signature = build_aggregate_signature();
        KeysetCommitment memory new_validator_set_commitment = build_new_validator_set_commitment();

        assertTrue(verifier.verify_aggregates(public_input, proof, aggregate_signature, new_validator_set_commitment));
    }
}
