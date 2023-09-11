// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../../src/common/bw6761/G1.sol";
import "../../src/common/PublicInput.sol";

contract SimpleInputTest is Test {
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

}
