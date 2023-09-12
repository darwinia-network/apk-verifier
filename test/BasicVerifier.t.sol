// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "../src/BasicVerifier.sol";
import "../src/common/bw6761/G1.sol";
import "./common/SimpleInput.t.sol";

contract BasicVerifierTest is SimpleInputTest {
    using SimpleTranscript for Transcript;
    using BW6FR for Bw6Fr;

    BasicVerifier verifier;
    function setUp() public {
        Bw6G1[2] memory pks_comm = [pks_comm_x, pks_comm_y];
        verifier = new BasicVerifier(pks_comm);
    }

    function test_verify_aggregates() public {
        AccountablePublicInput memory public_input = build_public_input();
        SimpleProof memory proof = build_proof();
        Bls12G2 memory aggregate_signature = Bls12G2(
            Bls12Fp2(
                Bls12Fp(
                    0xe3f01ca6ff6209cfc4b5f76939854d, 0x983a2e2e7300a4c19ba84edbce27a4279be484b2a7a1943c30a72ba6f8265e22
                ),
                Bls12Fp(
                    0x79cc7b2a270ac9befcb0b47f6654af, 0xa3f9b97216acd16739ae6762473c7362f10cf8b906832bd22fe51decbed578eb
                )
            ),
            Bls12Fp2(
                Bls12Fp(
                    0x3b9231248eb5337b3e9f028c073efe, 0x7e015f17545cde1d30bbdc0f231d16fad24cd6716b28b3329112a9306d05c1d1
                ),
                Bls12Fp(
                    0x60fafb9c430873a186e529aae8adc7, 0x07326665a45b3b656104c4eecaea70fe7f8ed13c897baadea4ade0955d6e4e39
                )
            )
        );

        KeysetCommitment memory new_validator_set_commitment = KeysetCommitment({
            pks_comm: [
                Bw6G1({
                    x: Bw6Fp({
                        a: 0x17214fa29ac9806a5730f174a0ed1e5821f8eb491841608ce8b29ff079dc95,
                        b: 0x2134cac3155c23a1c173764d4322edbb4ee7a275ba770623b836deac0c1e22ff,
                        c: 0x77cf494a270946ea7888dba523265dc84416571fc0daec31bebec0fc8204f8a1
                    }),
                    y: Bw6Fp({
                        a: 0x528af0c701b93d94bc0620b0c61432a04cb0f4ed13aa479932cc9690aa34d6,
                        b: 0x10d9b2df89e7a972aac8b6b9e939983fd937ccbbedab777aeb7c8520617db097,
                        c: 0x41a1b8dfd3bdc2ff742c0ef4094468b4e479533918057a00e4128859fb2498e5
                    })
                }),
                Bw6G1({
                    x: Bw6Fp({
                        a: 0xb26d4c805b675207e1280359ac671f3e493d0c779322680b368df0ac03205d,
                        b: 0x1328e8691f00789856d9356805b0cd6f50f84c4be96b1d0cb3236ad02ba632ee,
                        c: 0x1f22a9559fcf547b647d86bd1b260db7dd78ff26c9ae85acef71c3465375dc78
                    }),
                    y: Bw6Fp({
                        a: 0x3d16f8ed12a5a40226a4d9e2a1a054f1f21ed2c498a00f7523ea8fc33790f6,
                        b: 0xe661d44f017e4a6f85adcf77d2eca96c60fdc9de9d665eb87d8b731ca7700711,
                        c: 0xf465a60b2bd0dc8404004ef5575d20952ba2e187cc8330ae86f0366b45be7a34
                    })
                })
            ],
            log_domain_size: 8
        });

        verifier.verify_aggregates(public_input, proof, aggregate_signature, new_validator_set_commitment);
    }

    function test_restore_challenges() public {
        AccountablePublicInput memory public_input = build_public_input();
        SimpleProof memory proof = build_proof();
        (Challenges memory challenges, Transcript memory fsrng) = verifier.restore_challenges(public_input, proof, 5);
        Challenges memory expect_challenges = build_expect_challenges();
        assertEqChallenges(expect_challenges, challenges);
        // Bw6Fr memory expect_r = rand();
        // Bw6Fr memory ddd = fsrng.rand_u128();
        // console.log(ddd.a);
        // console.log(ddd.b);
        // assertTrue(expect_r.eq(fsrng.rand_u128()));
    }

    function assertEqChallenges(Challenges memory x, Challenges memory y) internal returns (bool) {
        console.log(x.r.a);
        console.log(x.r.b);
        console.log(y.r.a);
        console.log(y.r.b);
        assertTrue(x.r.eq(y.r));
    }
}
