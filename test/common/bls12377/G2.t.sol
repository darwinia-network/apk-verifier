// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../../../src/common/bls12377/G2.sol";

contract BLS12G2AffineTest is Test {
    using BLS12G2Affine for bytes;
    using BLS12G2Affine for Bls12G2;
    using BLS12G2Affine for Bls12Fp2;

    function test_map_to_curve() public {
        Bls12Fp2 memory u0 = Bls12Fp2(
            Bls12Fp(
                0xc2471314bdab70cff1124e4828405a, 0x0847fee471e10c210bdde1f4d04b5636bad67debba2a8c871fa0ef1dc67cf295
            ),
            Bls12Fp(
                0xdf10f31739560f1df3e1aa677c0050, 0xcd7bd81a2cdd42a39c760829d635ea688a38ec1af60b4638f297f33a81300813
            )
        );
        Bls12Fp2 memory u1 = Bls12Fp2(
            Bls12Fp(
                0x9abfbbb83f6959e6746c018b7e0ccb, 0xbb37a13465997d07aa7912a38d88b9074581f84a25668cc46732b2bea7cbb165
            ),
            Bls12Fp(
                0x178a64087c014cec9a650a0da435424, 0xbfa7931ba99c81fcf16511b8bf1915adc1fd02c28c07312d3afc3a70508f6bb8
            )
        );
        Bls12G2 memory q0 = u0.map_to_curve();
        Bls12G2 memory q1 = u1.map_to_curve();
        assertEq(
            hex"000000000000000000000000000000000041c23fcf07fa7338b31319cb0e530bd5981b95a8651d6a9fbb2104112e01b530cde64ee6e1d06ad8475d098b3598d300000000000000000000000000000000014564274c5508e60add6ae25db96d719d1c49f48c167f874d34c09fc713f79947e34e9da077f22d668308ca457ed8ad00000000000000000000000000000000000412c8e80bc2a1f3fc02019038113b4f273f2f881479a072dd31400c3c0f16f3277000e316dfdaa10ab4d54de2c08b0000000000000000000000000000000000d3979f04f01c7762d0f3df503d3ce1e0fe9be50b65590fe1cc909f9365c76f309fc4f033d5ca6ca809393c6e23eb61",
            q0.debug()
        );
        assertEq(
            hex"0000000000000000000000000000000000e45e283e13f762a40b079975c0709a75a8f7bef00657fd4a13d5b115bd261ae562b3737f8afed40cf8de605d0c74f3000000000000000000000000000000000017e46384bac53c477f1ed1a10ecfcd7418c577aff67c18c13f9f804c0db193c7cc318afbb8348d9ab49a82d16228b40000000000000000000000000000000000cb9c7cdfe32cedde1c15134b263d223996dcb4a86eea71577f93dc7af498b55726d4075d812e963d59aafc092cb34d00000000000000000000000000000000012f4575c3bd7f4133811b06e01609e62881dce50a599bcac76fc0d0032b846fff6861af692c6ede349106d1bca4df2d",
            q1.debug()
        );
    }

    function test_add() public {
        Bls12Fp2 memory u0 = Bls12Fp2(
            Bls12Fp(
                0xc2471314bdab70cff1124e4828405a, 0x0847fee471e10c210bdde1f4d04b5636bad67debba2a8c871fa0ef1dc67cf295
            ),
            Bls12Fp(
                0xdf10f31739560f1df3e1aa677c0050, 0xcd7bd81a2cdd42a39c760829d635ea688a38ec1af60b4638f297f33a81300813
            )
        );
        Bls12Fp2 memory u1 = Bls12Fp2(
            Bls12Fp(
                0x9abfbbb83f6959e6746c018b7e0ccb, 0xbb37a13465997d07aa7912a38d88b9074581f84a25668cc46732b2bea7cbb165
            ),
            Bls12Fp(
                0x178a64087c014cec9a650a0da435424, 0xbfa7931ba99c81fcf16511b8bf1915adc1fd02c28c07312d3afc3a70508f6bb8
            )
        );
        Bls12G2 memory q0 = u0.map_to_curve();
        Bls12G2 memory q1 = u1.map_to_curve();
        Bls12G2 memory r = q0.add(q1);
        assertEq(
            hex"0000000000000000000000000000000000f71825c48d6d1c890f6a4f8703ce5a1ba5097cc2983e8cd21437a3dbc271d9ac20b9a0fa42ed983c8f771d4a4f9ba50000000000000000000000000000000001abf3982d02f4d9ad8b129666ea3b9d7845a8f0b23be01f2bf071499a56b3952ea5ed8ef8993886526ca554a9393d8100000000000000000000000000000000010105c981e730102823c96c118f5b93daec82a03158ab549a8acd187e1fdf7928a986f73db678626a647a145f17a9320000000000000000000000000000000000a0f3396068929d03cb77c7c0e92cd9c0dfbcac8a6384eb0e482b3eca6865a3b968839750d49564310e0c9f57150d71",
            r.debug()
        );
    }

    function test_hash_to_curve() public {
        bytes memory m =
            hex"a1f80482fcc0bebe31ecdac01f571644c85d2623a5db8878ea4609274a49cf77ff221e0cacde36b8230677ba75a2e74ebbed22434d7673c1a1235c15c3ca342195dc79f09fb2e88c60411849ebf821581eeda074f130576a80c99aa24f21170078dc755346c371efac85aec926ff78ddb70d261bbd867d647b54cf9f55a9221fee32a62bd06a23b30c1d6be94b4cf8506fcdb0056835d9569878001f69e828135d2003acf08d360b682293770c3d493e1f67ac590328e10752675b804c6db20008000000";
        Bls12G2 memory p = m.hash_to_curve();
        bytes memory e =
            hex"0000000000000000000000000000000000f71825c48d6d1c890f6a4f8703ce5a1ba5097cc2983e8cd21437a3dbc271d9ac20b9a0fa42ed983c8f771d4a4f9ba50000000000000000000000000000000001abf3982d02f4d9ad8b129666ea3b9d7845a8f0b23be01f2bf071499a56b3952ea5ed8ef8993886526ca554a9393d8100000000000000000000000000000000010105c981e730102823c96c118f5b93daec82a03158ab549a8acd187e1fdf7928a986f73db678626a647a145f17a9320000000000000000000000000000000000a0f3396068929d03cb77c7c0e92cd9c0dfbcac8a6384eb0e482b3eca6865a3b968839750d49564310e0c9f57150d71";
        assertEq(e, p.debug());
    }
}
