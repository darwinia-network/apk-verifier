// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../../src/common/KeySet.sol";
import "../../src/common/bw6761/G1.sol";
import "../../src/common/bls12377/G2.sol";
import "../../src/common/PublicInput.sol";

contract CommonInputTest is Test {
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

    function build_pks_comm() public view returns (Bw6G1[2] memory) {
        return [pks_comm_x, pks_comm_y];
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

    function build_aggregate_signature() public pure returns (Bls12G2 memory) {
        return Bls12G2(
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
    }

    function build_new_validator_set_commitment() public pure returns (KeysetCommitment memory) {
        return KeysetCommitment({
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
    }
}
