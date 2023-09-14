// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "../SimpleInput.t.sol";

contract BW6G1AffineTest is SimpleInputTest {
    using BW6FR for Bw6Fr;
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

    function test_serialize2() public {
        SimpleProof memory proof = build_proof();
        bytes memory s = proof.q_comm.serialize();
        bytes memory e = hex'9e791379add5b72006375eeb0d49da7dec1048198ab2b3a33af7c458ffdcec5222579dc96175ebb5d2ca2042309eefabb6eaece828f7b53c0e72ceaface840b55633ef0b8a9cb9f4745a9f907df422259ea366c8df76d9221012e02549445c80';
        assertEq(e, s);
    }

    function test_serialize3() public {
        SimpleProof memory proof = build_proof();
        bytes memory s = abi.encodePacked(
                proof.register_evaluations.keyset[0].serialize(),
                proof.register_evaluations.keyset[1].serialize(),
                proof.register_evaluations.partial_sums[0].serialize(),
                proof.register_evaluations.partial_sums[1].serialize()
            );
        bytes memory e = hex'3ae932dd35aa2d4b11caa1f7f99a0fc2f499d4ab19229f1cf3e96e490289ebb3eb6890c977a3c699200b644044ec3300e3578dc4d7ac21f207c0a09347ae427aaf4c221d4311f14392ce5b0fb6f28d6d6c3380b66eb435876a371bcb36f43d0065515f320bd1890b28910ad2625404766061d6f2e32e43644a7965fdc20c8cf9996150020b78a949579dbc6f3fe45700682525794d20112042300ab7dcb7abb2c016f2bb2e2878959b925a070773fd1b12e2e7ca7b10f3396c4a14862cf20a00';
        assertEq(e, s);
    }

    function test_serialize4() public {
        SimpleProof memory proof = build_proof();
        bytes memory s = proof.q_zeta.serialize();
        bytes memory e = hex'0e23e56f168944a90a5f64246f208bba71c672ffd46cefd6d9fa4b7b85cc00469dc597afd8ddaa4a1e06f02d34cd5e00';
        assertEq(e, s);
    }

    function test_serialize5() public {
        SimpleProof memory proof = build_proof();
        bytes memory s = proof.r_zeta_omega.serialize();
        bytes memory e = hex'4fcd0bf38015f1691c81412d167e6ae60b54218a79ed8820002b32452c04a237d9d1e5c5377190c86359cabe1a8bf400';
        assertEq(e, s);
    }

    function test_sub() public {
        Bw6G1 memory a = Bw6G1({
            x: Bw6Fp(0x3742166ce08926765ae502ee0f62518a68bc593b728dca491e081157393efb,0x2588e69e6ccf7feddd72325fc4c0218be833a65f456fffe3fb83610310920755,0x23dbb5da1b96812fa1758d77500d6956fbf01dec90484a5a247709de35a74081),
            y: Bw6Fp(0x302d12a0447e52d5f18e563c122665d266ca64f664acfe66296b72a6f3fad3,0x8a2dcc2b8543b5e630a0b657baa625490d3a1d107afcfeed765bc6381f00e996,0xb55ceba4c9dda959bbc0c926892bf7e211201e279633a88ac01d3e66496247f1)
        });
        a.neg();
        Bw6G1 memory e = Bw6G1({
            x: Bw6Fp(0x3742166ce08926765ae502ee0f62518a68bc593b728dca491e081157393efb,0x2588e69e6ccf7feddd72325fc4c0218be833a65f456fffe3fb83610310920755,0x23dbb5da1b96812fa1758d77500d6956fbf01dec90484a5a247709de35a74081),
            y: Bw6Fp(0xf2bb125b3f4fb7fb963ae9c8e8d8d8e6bf4e058b6c9989ec590a7cd993c36d,0xe64dda0d60413332d32e04a76b0dfdbb794fabdc97fcfea2fb810da454eb1597,0xe3442b1d8c89ff9e5a4c2f8861c4ac55d5712040d9cc57f8347fc199b69db89a)
        });
        assertTrue(e.eq(a));
    }
}
