// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./CommonInput.t.sol";
import "../../src/common/SimpleProof.sol";

contract SimpleInputTest is CommonInputTest {
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
                    a: 0x5c444925e0121022d976dfc866a39e2522f47d909f5a74f4b99c8a0bef3356,
                    b: 0xb540e8acafce720e3cb5f728e8eceab6abef9e304220cad2b5eb7561c99d5722,
                    c: 0x52ecdcff58c4f73aa3b3b28a194810ec7dda490deb5e370620b7d5ad7913799e
                }),
                y: Bw6Fp({
                    a: 0xf562cfc59c39e930ee57e447c231d24207324a4e874b88df0dbb4ce76d4635,
                    b: 0xefe7bc153a9bb63a07e81b0f2be61b5f7c537d72edaa44abdbd7af811a34049e,
                    c: 0x4a14dfb608f6f910c2cd1f538cbe43d4385298b544c363651ab46c1335daa5f0
                })
            }),
            register_evaluations: AffineAdditionEvaluationsWithoutBitmask({
                keyset: [
                    Bw6Fr({
                        a: 0x33ec4440640b2099c6a377c99068eb,
                        b: 0xb3eb8902496ee9f31c9f2219abd499f4c20f9af9f7a1ca114b2daa35dd32e93a
                    }),
                    Bw6Fr({
                        a: 0x3df436cb1b376a8735b46eb680336c,
                        b: 0x6d8df2b60f5bce9243f111431d224caf7a42ae4793a0c007f221acd7c48d57e3
                    })
                ],
                partial_sums: [
                    Bw6Fr({
                        a: 0x57e43f6fbc9d5749a9780b02506199,
                        b: 0xf98c0cc2fd65794a64432ee3f2d6616076045462d20a91280b89d10b325f5165
                    }),
                    Bw6Fr({
                        a: 0xaf22c86144a6c39f3107bcae7e212,
                        b: 0x1bfd7307075a929b9578282ebbf216c0b2abb7dcb70a30422011204d79252568
                    })
                ]
            }),
            q_zeta: Bw6Fr({
                a: 0x5ecd342df0061e4aaaddd8af97c59d,
                b: 0x4600cc857b4bfad9d6ef6cd4ff72c671ba8b206f24645f0aa94489166fe5230e
            }),
            r_zeta_omega: Bw6Fr({
                a: 0xf48b1abeca5963c8907137c5e5d1d9,
                b: 0x37a2042c45322b002088ed798a21540be66a7e162d41811c69f11580f30bcd4f
            }),
            w_at_zeta_proof: Bw6G1({
                x: Bw6Fp({
                    a: 0x8743380ea7b987543b0706379a06a73c43a9307dbda7abd154dd4ea107a77d,
                    b: 0xb7260e3aee6badbd4a0f870ff8e502b28fdad5805693f341066e217410a67e71,
                    c: 0xeaf4cecf3773a30f7e7916b899a4269dab7220ad18865d95fd1dd8d898277100
                }),
                y: Bw6Fp({
                    a: 0x76976e0225f40237144b8ab6052b3af5638f249d07422197296e2c73d574b6,
                    b: 0x801a15837bc91baf154a3d528c3bd458b894955b40381f2f73aadc9b5fa28a53,
                    c: 0xc766295b2deafa223b4916b9523d435e68d54b4d9b40b422d03ff7d21d04f2ee
                })
            }),
            r_at_zeta_omega_proof: Bw6G1({
                x: Bw6Fp({
                    a: 0xb85aca42e6e4c7d2515fefd2f45996f068c0e9827cc97d674d97d1271789cc,
                    b: 0xab75672a7018ac54f0400a54e8f3adcbf1cf82c034f2a0ab44e0183075ce8079,
                    c: 0x02206d63f9c29997b74a26a11c14331fe33ba3fc8100c4b7212d53f1a5c9b911
                }),
                y: Bw6Fp({
                    a: 0xbf881fbcf359197cd337fa1228cd1792e6f7b50d78dda2a117d647b0740b01,
                    b: 0x5f54ca1c008eed25dcd1d0185454c852010a960b736e1ed5507ad9d10efcd8a5,
                    c: 0x7143320b0a18938fdfcf0440727b6da8d55587b942e68e6fae8e7122ca588d54
                })
            })
        });
        return proof;
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

    function rand() internal pure returns (Bw6Fr memory) {
        return Bw6Fr(0, 264185912457056518285248903647488235283);
    }
}
