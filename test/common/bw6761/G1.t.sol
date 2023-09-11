// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "../SimpleInput.t.sol";

contract BW6G1AffineTest is SimpleInputTest {
    using BW6G1Affine for Bw6G1;

    function test_serialize0() public {
        SimpleProof memory proof = build_proof();
        bytes memory s = proof.register_commitments[0].serialize();
        bytes memory e = hex'61e5205416536795a19b12678652297eace2f232bc78e60de8f13bcdf5e968d9527037a02e94a459379c3906beaadbf3735abf44feac4c14da3e0b61977b3e06ce96e83da394b0a36b578bb33d0971f011c528c09608293ad7704bc533f16f00';
        assertEq(e, s);
    }

    function test_serialize1() public {
        SimpleProof memory proof = build_proof();
        bytes memory s = proof.register_commitments[1].serialize();
        bytes memory e = hex'f7175e2e76d9dd4890c288e0b0379a93528e0d2ee893907d312c6d3eb3093588df5d804ea496dfbcec987981dcdecb1724630559755ca05cc7ede9812b6f690d99c2b12fba70b83b70c85eac813263fd65f0e64f886bdc33c69a0896a70bd180';
        assertEq(e, s);
    }
}
