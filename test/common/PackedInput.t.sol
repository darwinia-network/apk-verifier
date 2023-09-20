// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./CommonInput.t.sol";
import "../../src/common/PackedProof.sol";

contract PackedInputTest is CommonInputTest {
    function build_proof() public pure returns (PackedProof memory) {
        PackedProof memory proof = PackedProof({
            register_commitments: PartialSumsAndBitmaskCommitments({
                partial_sums: [
                    Bw6G1(
                        Bw6Fp(
                            0x6ff133c54b70d73a290896c028c511f071093db38b576ba3b094a33de896ce,
                            0x063e7b97610b3eda144cacfe44bf5a73f3dbaabe06399c3759a4942ea0377052,
                            0xd968e9f5cd3bf1e80de678bc32f2e2ac7e29528667129ba1956753165420e561
                        ),
                        Bw6Fp(
                            0x4982772a26252e29d42b88940198394085cb34fc32b7c64ab2b6426da8fb67,
                            0xa4ee72ac3286bc1ef300af56312233f5f03085abcac859dfd5aca0cf6ead212b,
                            0x69131f49bf7fc36a67263489a5ce79f27710c5e81d5099a02910d54b0bbf236f
                        )
                    ),
                    Bw6G1(
                        Bw6Fp(
                            0xd10ba796089ac633dc6b884fe6f065fd633281ac5ec8703bb870ba2fb1c299,
                            0x0d696f2b81e9edc75ca05c755905632417cbdedc817998ecbcdf96a44e805ddf,
                            0x883509b33e6d2c317d9093e82e0d8e52939a37b0e088c29048ddd9762e5e17f7
                        ),
                        Bw6Fp(
                            0xef9b9632f0eb98c6274788b1c7082020bba26223a512c631a4e02d30f00595,
                            0x4ae54f9aa01a90d9742b33b8ef43f4b2092e8c9e008c43695373691b4f77a4a3,
                            0x04a98431231ea88af3e0a32fedc2dadd63d0b08adc12fe4ae14521d7e42358f3
                        )
                    )
                ],
                bitmask: Bw6G1(
                    Bw6Fp(
                        0xd7225a283604bc06b9d7051015fb7c8efbf29a404290946c9bf5bbc7a6fa67,
                        0x223bfb16f73c7b366370318f7e7572b5e6b83cae669f753282b000a3fa92b8ea,
                        0x7f43285fd3f43d4b2a7600d80966c45f6929a1b5bc5b2a85631b000e3a6e7310
                    ),
                    Bw6Fp(
                        0x8f7c0a3be452bd8badf2bc98d8f530aa1b933219b20037461476cacf25c4ee,
                        0xd04bbc6dde82f43d2f3ca41207815455025d626c23d19c160e06d7fa7570e4be,
                        0x2b498590684ff4cb7c4026f153685bf18ed80ab295b159c34930b64e14ae0cce
                    )
                    )
            }),
            additional_commitments: BitmaskPackingCommitments({
                c_comm: Bw6G1(
                    Bw6Fp(
                        0x586266ad04839b3d8a20e32efa761e3d2d76a356da2d3d312638e1b4728933,
                        0x3209916d024075f994e0a61bab7e49ab874f1aaf3cd5a2aa3bba743520d5cde4,
                        0x9ab77d2d9245e50d58e9c213b67e39e61a633dc47e97bbc902221c6264a3fa5e
                    ),
                    Bw6Fp(
                        0xdab76fb60fff8b168649e061b3da2b8fedf09058d7616cfc953c9d03f3acd2,
                        0x9a1e56d993e87e39f5ca095d8a6f0b827e8d4cc151ac1d215b04c642ac1a4faa,
                        0xf9e8636f2d4361fb487bdd3001abc66e78c316b27c72a16581db971f3ab72791
                    )
                    ),
                acc_comm: Bw6G1(
                    Bw6Fp(
                        0xccf78a8c21c1d1c2578608ab8e87958e52692a369b5286c38b9d5595f22652,
                        0xb2961b9ef4bcf1ae5b9ca266ade1e59978e3b429614c554a95dc0dae2e62cf3e,
                        0x5061872adf0a7cae0ffa81b5b0ce5c4ef6d6f45d4411f8243628feacb3528a0f
                    ),
                    Bw6Fp(
                        0x7666bbfb2c76a43b8d9ecd876c6b7aad80c2bc099af88c77423e1b8ff79105,
                        0xe6476d6c322c42f21b54471135682c3560e02131fea55e05f49c6d6ce147c1b3,
                        0x3ebc5034414706996814924e467ee9959341b8494c99e4bc8e179565b91669e9
                    )
                    )
            }),
            q_comm: Bw6G1({
                x: Bw6Fp({
                    a: 0xc062e7124594105229e1e2fbc071de6c3776b78bc4c6c7901e6c81be5914b,
                    b: 0xebf37552e44d4eb021a50d5a4bc37d5e001303663cec0edf34117614d7eb256d,
                    c: 0x6837740adada2434b6dfd74196ee72430ef0657f8069467a374864b7ae33c453
                }),
                y: Bw6Fp({
                    a: 0x437529406cca44d7ea90561c2a0ad8e153f93781060c8482d5ddb211f4e531,
                    b: 0x97939e56f304d0cde2cfa05af195a8fb56de7e7fb2d38715c5192d7b2e98a7a5,
                    c: 0xf8bfaef6daa7e129813385107a092d7ca77fcfc97b4a41a283c3611e3ebffae0
                })
            }),
            register_evaluations: SuccinctAccountableRegisterEvaluations({
                c: Bw6Fr(0x74f76dfbb15bc2711496a2e6f8db1e, 0x53df4bed768f1e85ce819952ddcd3790748e17b52d19a43d68d9a17df882efb3),
                acc: Bw6Fr(0x8b7faae203220857bc99a92612295d, 0x1f04628098789bc4a18e48f5e5e5405047ea1513d63b86992918759d69702d73),
                basic_evaluations: AffineAdditionEvaluations({
                    keyset: [
                        Bw6Fr({
                            a: 0x451ff28beec13b8fc0911d8eee5065,
                            b: 0x859712a1e38c6f3a3d3d82399205613a44d70eecc4f7415a351fe5481658026f
                        }),
                        Bw6Fr({
                            a: 0xc9a6b13bba9c18c2718e8bc5c7e162,
                            b: 0x56af8f3978499d6994dfb71f654c1ffe965cb52d28cb5f99c95ae45a684d0a06
                        })
                    ],
                    bitmask: Bw6Fr(
                        0x17539471030fca84b49ebeab36974ad, 0x8e99484f0ccfdb70662179e2f6c6516f15d59c41cc22e0da573c6ba9506df719
                        ),
                    partial_sums: [
                        Bw6Fr({
                            a: 0x17819b5fbeeb030889a57224564d0f5,
                            b: 0x24d53e06b4f88186d4ee9ce958dbccd8d7b571b4da50595488a014bc8c35e53b
                        }),
                        Bw6Fr({
                            a: 0x84ca71739dc2611ccb26040c8c09e0,
                            b: 0xde6ddb5d84f7ac198e54d999bc2496d51000308988b025fcdb1cf554d1f9a937
                        })
                    ]
                })
            }),
            q_zeta: Bw6Fr({
                a: 0x13390c347521f545e7f3ed7f45cc0c4,
                b: 0x15c70cea16e3337a600c9bc62a2e00da64ccb9f64c5754c9112e1274cdb52245
            }),
            r_zeta_omega: Bw6Fr({
                a: 0x51ec84dc646300c424413a51598200,
                b: 0xf97d9781fd83132b74c7bb7b8893e18acb6ed9452108906900761de1be51826c
            }),
            w_at_zeta_proof: Bw6G1({
                x: Bw6Fp({
                    a: 0x95734f487b83d9b7ce78a0fa3eccdf10da8c06790210baffdf49be7b70fdcf,
                    b: 0xd7e13bf02d472fab4aeae1b188e1cb93bf123796bc90512e1d1786b250dd529c,
                    c: 0x3869986866b87f65b69101d1620d81aa8348dec3fe32a53b153cdc6cf4c41625
                }),
                y: Bw6Fp({
                    a: 0x66d28fc600f3d83535c5a124098ed340e342794dc20f6b2829716f7426ee47,
                    b: 0x35cf1a0b2c151ddedb9298d8c77951c987d58063a53a968830ce9976ccfe716d,
                    c: 0xf61c1df0799c0e1a3aba8f0df8cce31562d639b6135cbed5a9d450ff4d112e8d
                })
            }),
            r_at_zeta_omega_proof: Bw6G1({
                x: Bw6Fp({
                    a: 0x1b4ce9c111cef0161348842b70f18c32380e87e957751365ac4c1646a57e72,
                    b: 0xe4e7c85add8bc7d97d331643a81851f9588facfec8108127bdd9e2e94f774a1d,
                    c: 0x1b4065d08dc26b68fcb68e7564442043102abd92f01471fb7f0ad1603240da0e
                }),
                y: Bw6Fp({
                    a: 0x82a7c17fee184cb236c53d49d0afe3f9db931479f27616c8453abcf7a42f35,
                    b: 0xfe23b8a2275516e069ad99aa800b0c86869192b1d74cf5202c3baf9d867b482e,
                    c: 0xc4346ee735aa71c4c4505298ba88f12ec50d65c7fe3fc328e1499834368c754b
                })
            })
        });
        return proof;
    }

    function build_expect_challenges() public pure returns (Challenges memory) {
        Bw6Fr[] memory nus = new Bw6Fr[](8);
        nus[0] = Bw6Fr({a: 0, b: 264057477310771344499297428833163444891});
        nus[1] = Bw6Fr({a: 0, b: 112914410792786595150956585293274179229});
        nus[2] = Bw6Fr({a: 0, b: 31707078612709378626966411100993817997});
        nus[3] = Bw6Fr({a: 0, b: 213047333099780712481936226457736336460});
        nus[4] = Bw6Fr({a: 0, b: 30122028770577175562412803362787363561});
        nus[5] = Bw6Fr({a: 0, b: 120877703956323329393782245786742082453});
        nus[6] = Bw6Fr({a: 0, b: 110509649440250476185141339954687079712});
        nus[7] = Bw6Fr({a: 0, b: 127345548684180549815386479200443684328});
        return Challenges({
            r: Bw6Fr({a: 0, b: 133321539823602459806599945304366977715}),
            phi: Bw6Fr({a: 0, b: 196602331167091494550688763976312036205}),
            zeta: Bw6Fr({a: 0, b: 321664692036814262463468138668871535249}),
            nus: nus
        });
    }

    function rand() internal pure returns (Bw6Fr memory) {
        return Bw6Fr(0, 285170983650546859880342951361927496933);
    }
}
