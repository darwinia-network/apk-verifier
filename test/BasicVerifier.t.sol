// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../src/BasicVerifier.sol";
import "../src/common/bw6761/G1.sol";
import "../src/common/PublicInput.sol";
import "../src/common/SimpleProof.sol";

contract BasicVerifierTest is Test {
    BasicVerifier verifier;
    Bw6G1 pks_comm_x = Bw6G1({
        x: Bw6Fp({
            a: 0x7a5a27fc4f90909d4882ba1a487c7f1b4bbcb154f751b400c349af064f48e3,
            b: 0xb2304309aae2f72c9de613b5665043d46695097fea7fda8426cf5145577b5c18,
            c: 0x009ff166958271000aeac4dc3e4420f1e7d95ff91986842567065407865ffadb
        }),
        y: Bw6Fp({
            a: 0x5d722b276110b5da04c3ded5fc23c8b97177d9d554831ca896e4c5d91455b7,
            b: 0xe1ff4364c119f45d1c5c0eaf2ec22874afeeba9afe72a748a1acf7d97096f84a,
            c: 0x9c8fddccaa28d0be629401f0c2d2e1bb4c2d68ed69d8637d05d3e5655bfd5179
        })
    });

    Bw6G1 pks_comm_y = Bw6G1({
        x: Bw6Fp({
            a: 0xa262863ef01dd7d30e97ea7aff4b693e77ede68eb340b06fe13f3bbf9bbecb,
            b: 0x277af334c47b81997e19171398b3b89f08d917d11e0b3d3d0730b259303b89a5,
            c: 0x69f87f0014849a9586a5b5718a54a1aa2bfa8c2181b8291a4d2543ffdfe893f5
        }),
        y: Bw6Fp({
            a: 0xd72c2aea8f326006e69b0196d4eced4ab15f90689feab5a9015324c41f43d1,
            b: 0xce2d1f66f3bed1c62f66ab32d0100e54979151a5b761a6e263fd7419a0d70747,
            c: 0xc49a648c76ce1f4a24a344ad032a405b9fc8b3337e5505d1621fde54bd9394fa
        })
    });

    function setUp() public {
        Bw6G1[2] memory pks_comm = [pks_comm_x, pks_comm_y];
        verifier = new BasicVerifier(pks_comm);
    }

    function build_public_input() public pure returns (AccountablePublicInput memory) {
        uint256[] memory limbs = new uint[](1);
        limbs[0] = 0x7fdf7bffffbffbeffefffefbfdfffffffffff7ffdfb5fffe7ffffbefbfffffdf;
        AccountablePublicInput memory public_input = AccountablePublicInput({
            apk: Bls12G1({
                x: Bls12Fp({
                    a: 0xdf12686939cc8adc613aa1e2ef7753,
                    b: 0xfaff1467b5420ab33cf04de813d4d9ae57cd11569e1228ab3f3b77de3636a39e
                }),
                y: Bls12Fp({
                    a: 0xc7b39a036437b74c03aacbb1ed26fc,
                    b: 0xab84a985e21baca9e1d873c8d7a9a8eca08ce79d32ac6edbefb8c43e7b62b6b6
                })
            }),
            bitmask: Bitmask({limbs: limbs, padding_size: 1})
        });
        return public_input;
    }

    function build_proof() public pure returns (SimpleProof memory) {
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
                    a: 0xc344d1bf3342194f741e048e53530eeea6e77e66171dfa6941a753e83a3005,
                    b: 0x6b444199ec22475c59b2a3da20d8ccda60f32e664a06f06935a5ce4e4e27e9af,
                    c: 0x1090b8075361a3f94c023dbe5c6cd34f3b7e0d3be935edc7a3ae12be36041831
                }),
                y: Bw6Fp({
                    a: 0x1738e10e0e8c242395c297c2f1527e11f5b919a3af5513b7966ab49755ad2d,
                    b: 0x60e2829c8b3ceee815b1339bf0d14deaf47bbc1f9df9c76fc799509ba838b49f,
                    c: 0xe7bcd52ff4aec6a2b2b916a8094ca5194e9f5dbc8865d5ed513edb49f085d068
                })
            }),
            register_evaluations: AffineAdditionEvaluationsWithoutBitmask({
                keyset: [
                    Bw6Fr({
                        a: 0x1aab27451fa488f6bd859ea437c4404,
                        b: 0x7dafc07339e923e17e1623441d3e44b083e31105119b7cafaa6466c09da0dbe5
                    }),
                    Bw6Fr({
                        a: 0xf7c51d58d6ea4c6320f8bc5efba96a,
                        b: 0x803aabe3237f1853af01e2d3a836c730e7360dc07086b2dd6946173bc4c4dc97
                    })
                ],
                partial_sums: [
                    Bw6Fr({
                        a: 0xbadb019511078f65aaea2d4d5507ae,
                        b: 0x6140f38addc64768f5d4a20c7fa51f8ef6321c948e32e6cab3bb7acaaa40cf4e
                    }),
                    Bw6Fr({
                        a: 0x7872dba3cd2e1094e6f8207b3a2e85,
                        b: 0x42af6e080c1eedb9dc82e6f6d62ca9a7a89a1035c676235f86bc33cd9e02fe5d
                    })
                ]
            }),
            q_zeta: Bw6Fr({
                a: 0xe9d5ae89f321d945043e5b3fb54abb,
                b: 0x3c477b56bd48d0e6ade2edacc610780621a462b38d589bdc9188e9b79b01ee15
            }),
            r_zeta_omega: Bw6Fr({
                a: 0x894256285a8d3f89e16134fe889571,
                b: 0x29293cc6fbec9a45a5c935d81a88bdfb405cbdd4c1e81c20aca4d33b236130a9
            }),
            w_at_zeta_proof: Bw6G1({
                x: Bw6Fp({
                    a: 0x5517af9359e4a1886d929c2a9d58715dbae9b917ff807dacecf99cd8283943,
                    b: 0xd88c1f1bb009c7239ccd63ce2e823559a77d142809f1f74764844542424ec4b9,
                    c: 0x6b120d822ed7d57327107f114dfebda54702dc84bb57b3871f660e93bd7744d3
                }),
                y: Bw6Fp({
                    a: 0xd248953ebb6ea5ba42d2e0133254b7bdffe191b0d82a91edfeae059a291dea,
                    b: 0x940ccc84a168eec369279db1a574fc36aa4e73bc9b61bc16a0753d97153674a7,
                    c: 0x604ae0b1aac1cfee8dd7611c9bf8808a04f94d68aab2f577827cc35f55f99e08
                })
            }),
            r_at_zeta_omega_proof: Bw6G1({
                x: Bw6Fp({
                    a: 0x101d282c9ab5d38b9133a910c502a51594600247d9561799f25e995db9f93f4,
                    b: 0xc5d71fa60f3952cdcd7c4b301697f1c1221fa3d40adda0b49b02539a9640bbb6,
                    c: 0x31f5f6bdad910244e5779c3f3bc67a6c7c5945e7bfbc311c89f42c5e1fb0e647
                }),
                y: Bw6Fp({
                    a: 0x7b7766063408a7c1dbcfcb427d3646910dd16b56f7d36558a178ccea9a0a34,
                    b: 0x13afc1e91b36630d899c46fb46dbdaa8ca4f46a45e685f9431f512412a038b34,
                    c: 0x78248634b57cb636ff32fb62cef1ad10416907da29e07391dfff349873792dd3
                })
            })
        });
        return proof;
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
        Challenges memory challenges = verifier.restore_challenges(public_input, proof, 5);
    }

    function build_expect_challenges() public pure returns (Challenges memory) {
        Bw6Fr[] memory nus = new Bw6Fr[](5);
        nus[0] = Bw6Fr({a: 0, b: 187327990167567867229177518620072426364});
        nus[1] = Bw6Fr({a: 0, b: 254476786610760096525343445161959831212});
        nus[2] = Bw6Fr({a: 0, b: 205283876661423223107334421792536336365});
        nus[3] = Bw6Fr({a: 0, b: 61294691211413790555474494242447281232});
        nus[4] = Bw6Fr({a: 0, b: 173112105445287944153414230471618529485});
        return Challenges({
            r: Bw6Fr({a: 0, b: 225088521125632115816158335205155224812}),
            phi: Bw6Fr({a: 0, b: 124971442025886606170786713254051627568}),
            zeta: Bw6Fr({a: 0, b: 151549136533082271949031659198628422881}),
            nus: nus
        });
    }
}
