// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../src/BasicVerifier.sol";
import "../src/common/bw6761/G1.sol";
import "../src/common/PublicInput.sol";
import "../src/common/SimpleProof.sol";

contract VerifierTest is Test {
    BasicVerifier verifier;
    Bw6G1 pks_comm_x = Bw6G1({
        x: Bw6Fp({
            a: 0x35f151e7d4830a06e747e46efea114280231fbe9dfa1ca9d262ca99e1c2de9,
            b: 0xf0f186df429e77ebd245b4b2d79385b78261c7b68a21123ba3def5279a5de9c2,
            c: 0xb0a459a122d81dc7f76ebcffea6bc7ed5f5860c4896994b03ce35a7c93a4c188
        }),
        y: Bw6Fp({
            a: 0x91e674485bdbab175066a78423bc5047a632833f04ea3a2ab24772a7217495,
            b: 0x085edac30fddf0e9a5bc58df3d4c235f577d1ccf97b1e197cdddb6e5a04e1120,
            c: 0xe30f89fae11210026182c71e809cfc3cbe7aaf6ab391b2d6088fa8f7da8c9081
        })
    });

    Bw6G1 pks_comm_y = Bw6G1({
        x: Bw6Fp({
            a: 0x7b46f5a6095fcd2fe565576119935063a1ac236ebee2cdd25c8f108e2707f5,
            b: 0xfa2797d877295212ae2bd7ec332d6caa04b1d560cba17d7366b6b2da77c3c89c,
            c: 0x6f1c9c8a35249790c5884aab9d5524a7ebb1bc39d159d3f99a464e57ab3c6913
        }),
        y: Bw6Fp({
            a: 0x60f7c26e845db0bf712bb50cb7da345dceee1d277cffc8a48bb2eb7d768483,
            b: 0xc64de2c0eee65542ac524069ab865b449f1551c5718b28edb5d3c7151c4d8718,
            c: 0xcdb01241eb1ab9057e151353b1f6f05a90433565327e399c0148b886043bcaee
        })
    });

    function setUp() public {
        Bw6G1[2] memory pks_comm = [pks_comm_x, pks_comm_y];
        verifier = new BasicVerifier(pks_comm);
    }

    function test_verify_aggregates() public {
        uint256[] memory limbs = new uint[](1);
        limbs[0] = 0x7fdf7bffffbffbeffefffefbfdfffffffffff7ffdfb5fffe7ffffbefbfffffdf;
        AccountablePublicInput memory public_input = AccountablePublicInput({
            apk: Bls12G1({
                x: Bls12Fp({
                    a: 0x16779df0fbff1b648ba16179a7c59e6,
                    b: 0xaa726f55286662f66f4dd91d24773d6193425b66b2c19162d3192a35b35c5423
                }),
                y: Bls12Fp({
                    a: 0xd4c896382bfd98e489a6989a5c2328,
                    b: 0x63854f63cff01ac3072e3f19814edb7621062fbb1709980d3cd5880e0882da3a
                })
            }),
            bitmask: Bitmask({limbs: limbs, padding_size: 1})
        });

        SimpleProof memory proof = SimpleProof({
            register_commitments: [
                Bw6G1({
                    x: Bw6Fp({
                        a: 0x6ff133c54b70d73a290896c028c511f071093db38b576ba3b094a33de896ce,
                        b: 0x063e7b97610b3eda144cacfe44bf5a73f3dbaabe06399c3759a4942ea0377052,
                        c: 0xd968e9f5cd3bf1e80de678bc32f2e2ac7e29528667129ba1956753165420e561
                    }),
                    y: Bw6Fp({
                        a: 0x4982772a26252e29d42b88940198394085cb34fc32b7c64ab2b6426da8fb67,
                        b: 0xa4ee72ac3286bc1ef300af56312233f5f03085abcac859dfd5aca0cf6ead212b,
                        c: 0x69131f49bf7fc36a67263489a5ce79f27710c5e81d5099a02910d54b0bbf236f
                    })
                }),
                Bw6G1({
                    x: Bw6Fp({
                        a: 0xd10ba796089ac633dc6b884fe6f065fd633281ac5ec8703bb870ba2fb1c299,
                        b: 0x0d696f2b81e9edc75ca05c755905632417cbdedc817998ecbcdf96a44e805ddf,
                        c: 0x883509b33e6d2c317d9093e82e0d8e52939a37b0e088c29048ddd9762e5e17f7
                    }),
                    y: Bw6Fp({
                        a: 0xef9b9632f0eb98c6274788b1c7082020bba26223a512c631a4e02d30f00595,
                        b: 0x4ae54f9aa01a90d9742b33b8ef43f4b2092e8c9e008c43695373691b4f77a4a3,
                        c: 0x04a98431231ea88af3e0a32fedc2dadd63d0b08adc12fe4ae14521d7e42358f3
                    })
                })
            ],
            q_comm: Bw6G1({
                x: Bw6Fp({
                    a: 0xa458f9c887541c421664da173c64bc08ff130ba860292ef5a42a2f0fee4d44,
                    b: 0x0d0c36db4024576e888c201645fb8c7e50a51b7c28c59dca155e4e7770ce1b8f,
                    c: 0x7dc50406eb98a25402e5b1b7f10d2af9385f6ef8787f7bd924f65b11c483e4f7
                }),
                y: Bw6Fp({
                    a: 0x54344def595cde4965e61d2384c9ba76f4dc275f31261174188368f779752a,
                    b: 0x53a63ba3d7614387528d2e2da8a577cb229b60c90203822f4a236c94d892c636,
                    c: 0x02c22664d6af0e1e923741db87d54c1ee9b6e1ec0d422fd91dc31091484472d5
                })
            }),
            register_evaluations: AffineAdditionEvaluationsWithoutBitmask({
                keyset: [
                    Bw6Fr({
                        a: 0xfea4389bb7c3bdf527f84bca06193e,
                        b: 0x2c0ec67ac5f6b363cb433b74c67271250901345f47850e89ba377304db134e91
                    }),
                    Bw6Fr({
                        a: 0x10550f32462294ec9dcbcafbbd315df,
                        b: 0x9ced0fe8344c4890d96c9e4d8ff16573ea6ff419e2737e10ee96e1020782bd6a
                    })
                ],
                partial_sums: [
                    Bw6Fr({
                        a: 0x42e149f2786019f00befe5a3dc90ba,
                        b: 0x36c6161595bdf5c5472c84f6a5d3330ba1a40579533f320948d5407af99486ed
                    }),
                    Bw6Fr({
                        a: 0x19e55f7ad6fea1ce3d147b37ea3eb02,
                        b: 0x3b4336dc5924a08123a9f2e0cacc20a8bc52188fc4505462ac272968a9dcf5fe
                    })
                ]
            }),
            q_zeta: Bw6Fr({
                a: 0x189af7297b59055240ae05ec3c025ee,
                b: 0xca4201cddb6c67d46f05305504be885979421a5a226117dfc1502c332aa7b51b
            }),
            r_zeta_omega: Bw6Fr({
                a: 0x57d6c47fcdc704b9337c5322c19517,
                b: 0x8cbaed7639081a6654a91cfb0de835ab3c32032c26d270c1d5f31f20aadcb275
            }),
            w_at_zeta_proof: Bw6G1({
                x: Bw6Fp({
                    a: 0xf58d1f5e2fb839ee09feaefc8c3673eac9c2070d5bda413d861a57c65a0cc8,
                    b: 0x11a7c069dee249de02720444f3fc86f0ff2cb245fcf29e65cb84fe04647653b8,
                    c: 0xc1709f8fbcdf6d2b39a796e38532905b68d569e1f18e539447e98957d96da6bb
                }),
                y: Bw6Fp({
                    a: 0xc00fb77db8aead2a2f5d31b4f5064b6c478d1fd1515e811f27605b3d922ff1,
                    b: 0x199599497487891aaf5289002d35f09f05adcc0cae2013e571c1595f20705d1a,
                    c: 0x4f96ab1e99d9f55cd55686dd5f2792479392c119ca8585fd44c6026763cd52e0
                })
            }),
            r_at_zeta_omega_proof: Bw6G1({
                x: Bw6Fp({
                    a: 0x99b9999ec9b91ca59dbf3c4f55df6a57e0414c418733de254075df37de6f7e,
                    b: 0x33f6e7f1211688dbb89e561f434cb5095a9ed9205c655de894c636a04dbf9a93,
                    c: 0x13d461a5ee299290296c8cab8b4e39f02a2a2360bd4ac7589f16a52b87bf913f
                }),
                y: Bw6Fp({
                    a: 0x7c0f2d54ddd27a87ec64bb9a38611ac306d9c4aa285d83f539a85546fe61e8,
                    b: 0x9182e458c1974e54253e26cd5808d3ec83a30bd0ba1706f64a2781d0b29ef332,
                    c: 0xb2d253ed7284e136ec613ec64254eb2ddfe9d152ae28f862a0c597b33eae51f2
                })
            })
        });
    }
}
