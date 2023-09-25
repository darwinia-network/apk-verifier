// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../SimpleInput.t.sol";
import "../../../src/common/KeySet.sol";
import "../../../src/common/pcs/kzg/KZG.sol";
import "../../../src/common/poly/domain/Radix2.sol";
import "../../../src/common/transcipt/Simple.sol";

contract BasicSimpleTranscriptTest is SimpleInputTest {
    using SimpleTranscript for Transcript;
    using Radix2 for Radix2EvaluationDomain;
    using KZGParams for RVK;
    using KeySet for KeysetCommitment;
    using PublicInput for AccountablePublicInput;
    using BW6G1Affine for Bw6G1;
    using BW6FR for Bw6Fr;

    KeysetCommitment public pks_comm;

    function setUp() public {
        pks_comm.pks_comm[0] = pks_comm_x;
        pks_comm.pks_comm[1] = pks_comm_y;
        pks_comm.log_domain_size = Radix2.LOG_N;
    }

    function test_basic_simple_transcript() public {
        AccountablePublicInput memory public_input = build_public_input();
        SimpleProof memory proof = build_proof();
        Challenges memory e = build_expect_challenges();
        Transcript memory t = SimpleTranscript.init("apk_proof");
        t.set_protocol_params(Radix2.init().serialize(), KZGParams.raw_vk().serialize());
        t.set_keyset_commitment(pks_comm.serialize());
        t.append_public_input(public_input.serialize());
        t.append_register_commitments(
            abi.encodePacked(proof.register_commitments[0].serialize(), proof.register_commitments[1].serialize())
        );

        Bw6Fr memory r = t.get_bitmask_aggregation_challenge();
        assertTrue(r.eq(e.r));

        t.append_2nd_round_register_commitments("");
        Bw6Fr memory phi = t.get_constraints_aggregation_challenge();
        assertTrue(phi.eq(e.phi));

        t.append_quotient_commitment(proof.q_comm.serialize());
        Bw6Fr memory zeta = t.get_evaluation_point();
        assertTrue(zeta.eq(e.zeta));

        t.append_evaluations(
            abi.encodePacked(
                proof.register_evaluations.keyset[0].serialize(),
                proof.register_evaluations.keyset[1].serialize(),
                proof.register_evaluations.partial_sums[0].serialize(),
                proof.register_evaluations.partial_sums[1].serialize()
            ),
            proof.q_zeta.serialize(),
            proof.r_zeta_omega.serialize()
        );

        uint256 batch_size = BasicProtocol.POLYS_OPENED_AT_ZETA;
        Bw6Fr[] memory nus = t.get_kzg_aggregation_challenges(batch_size);
        for (uint256 i = 0; i < batch_size; i++) {
            assertTrue(nus[i].eq(e.nus[i]));
        }

        Transcript memory fsrng = SimpleTranscript.simple_fiat_shamir_rng(t);
        Bw6Fr memory rr = fsrng.rand_u128();
        Bw6Fr memory er = rand();
        assertTrue(er.eq(rr));

        assertEq(
            fsrng.buffer,
            hex"61706b5f70726f6f66646f6d61696e0001000000000000080000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000040b783840000d0ebe651f416b83e4f8acd6ed48f7b1ef40d19b708dff1a734acbaca74dbd94badd10b8cac01043fe3dca2842bb41cb9b00d23140c7ac8f8d9880c1ad1ae01c584d4c06b2d7133763ffae5a1ac50d0340fb9292f0001c5934edd0aea02a004874507e8450ab42a5fa6baeae39eee878a3b8f9e4ffaefbafeb5959738e0b6631c7581de413c00010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000766b5aba1fa03c90d549089e093353f1070c043e1f4872f54c772de4e2a4bce854412ee12f587aa6449ed4fd5f66379de7a761cbe061498b9d164b6eade50572c1785e815e929f818def320288d95387afec05a272135f072ff70d8ac03f0fd4ce002bfac7702340a729da3a7e3b0c045788455c845848ac6e27af9da0a34dc451be0e234e118540d056b6b585cbd859aeab1abfef212e8ce8995506c63c842196d7a4880976d983954241b07b29213e06aa247360a1f9f85766180c8b627b58e1006c524e1ceb60b6c63d135b99e14c6738738f093ac33c26920846554f256b9e1f68eed17a24d81bfa5c9ebf22179aacfd2088c4dafec5d67ad0368eea2b7f26c01cacd8b3037e33ba0276b4b01f22852d295ff523dd8f9a69bca1eeed13bd87806b65797365745f636f6d6d69746d656e74dbfa5f860754066725848619f95fd9e7f120443edcc4ea0a0071829566f19f00185c7b574551cf2684da7fea7f099566d4435066b513e69d2cf7e2aa094330b2e3484f06af49c300b451f754b1bc4b1b7f7c481aba82489d90904ffc275a7a00f593e8dfff43254d1a29b881218cfa2baaa1548a71b5a586959a8414007ff869a5893b3059b230073d3d0b1ed117d9089fb8b3981317197e99817bc434f37a27cbbe9bbf3b3fe16fb040b38ee6ed773e694bff7aea970ed3d71df03e8662a280080000007075626c69635f696e7075749ea33636de773b3fab28129e5611cd57aed9d413e84df03cb30a42b56714fffa5377efe2a13a61dc8acc39696812df000400000000000000dfffffbfeffbff7ffeffb5dffff7fffffffffffdfbfefffeeffbbfffff7bdf7f010000000000000072656769737465725f636f6d6d69746d656e747361e5205416536795a19b12678652297eace2f232bc78e60de8f13bcdf5e968d9527037a02e94a459379c3906beaadbf3735abf44feac4c14da3e0b61977b3e06ce96e83da394b0a36b578bb33d0971f011c528c09608293ad7704bc533f16f00f7175e2e76d9dd4890c288e0b0379a93528e0d2ee893907d312c6d3eb3093588df5d804ea496dfbcec987981dcdecb1724630559755ca05cc7ede9812b6f690d99c2b12fba70b83b70c85eac813263fd65f0e64f886bdc33c69a0896a70bd1806269746d61736b5f6167677265676174696f6e326e645f726f756e645f72656769737465725f636f6d6d69746d656e7473636f6e73747261696e74735f6167677265676174696f6e71756f7469656e749e791379add5b72006375eeb0d49da7dec1048198ab2b3a33af7c458ffdcec5222579dc96175ebb5d2ca2042309eefabb6eaece828f7b53c0e72ceaface840b55633ef0b8a9cb9f4745a9f907df422259ea366c8df76d9221012e02549445c806576616c756174696f6e5f706f696e7472656769737465725f6576616c756174696f6e733ae932dd35aa2d4b11caa1f7f99a0fc2f499d4ab19229f1cf3e96e490289ebb3eb6890c977a3c699200b644044ec3300e3578dc4d7ac21f207c0a09347ae427aaf4c221d4311f14392ce5b0fb6f28d6d6c3380b66eb435876a371bcb36f43d0065515f320bd1890b28910ad2625404766061d6f2e32e43644a7965fdc20c8cf9996150020b78a949579dbc6f3fe45700682525794d20112042300ab7dcb7abb2c016f2bb2e2878959b925a070773fd1b12e2e7ca7b10f3396c4a14862cf20a0071756f7469656e745f6576616c756174696f6e0e23e56f168944a90a5f64246f208bba71c672ffd46cefd6d9fa4b7b85cc00469dc597afd8ddaa4a1e06f02d34cd5e00736869667465645f6c696e656172697a6174696f6e5f6576616c756174696f6e4fcd0bf38015f1691c81412d167e6ae60b54218a79ed8820002b32452c04a237d9d1e5c5377190c86359cabe1a8bf4006b7a675f6167677265676174696f6e6b7a675f6167677265676174696f6e6b7a675f6167677265676174696f6e6b7a675f6167677265676174696f6e6b7a675f6167677265676174696f6e76657269666965725f7365637265742a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
        );
    }
}
