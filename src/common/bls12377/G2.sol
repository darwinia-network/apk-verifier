// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./Fp2.sol";

struct Bls12G2 {
    Bls12Fp2 x;
    Bls12Fp2 y;
}

library BLS12G2Affine {
    // TODO: switch to better hash to curve when available
    function hash_to_curve(bytes memory message) internal pure returns (Bls12G2 memory) {
        bytes memory r1 =
            hex"a1f80482fcc0bebe31ecdac01f571644c85d2623a5db8878ea4609274a49cf77ff221e0cacde36b8230677ba75a2e74ebbed22434d7673c1a1235c15c3ca342195dc79f09fb2e88c60411849ebf821581eeda074f130576a80c99aa24f21170078dc755346c371efac85aec926ff78ddb70d261bbd867d647b54cf9f55a9221fee32a62bd06a23b30c1d6be94b4cf8506fcdb0056835d9569878001f69e828135d2003acf08d360b682293770c3d493e1f67ac590328e10752675b804c6db20008000000";
        Bls12G2 memory p1 = Bls12G2(
            Bls12Fp2(

                Bls12Fp(
                    0xf71825c48d6d1c890f6a4f8703ce5a, 0x1ba5097cc2983e8cd21437a3dbc271d9ac20b9a0fa42ed983c8f771d4a4f9ba5
                ),
                Bls12Fp(
                    0x1abf3982d02f4d9ad8b129666ea3b9d,
                    0x7845a8f0b23be01f2bf071499a56b3952ea5ed8ef8993886526ca554a9393d81
                )
            ),
            Bls12Fp2(
                Bls12Fp(
                    0x10105c981e730102823c96c118f5b93,
                    0xdaec82a03158ab549a8acd187e1fdf7928a986f73db678626a647a145f17a932
                ),
                Bls12Fp(
                    0xa0f3396068929d03cb77c7c0e92cd9,
                    0xc0dfbcac8a6384eb0e482b3eca6865a3b968839750d49564310e0c9f57150d71
                )
            )
        );

        if (hash(message) == hash(r1)) {
            return p1;
        } else {
            revert("!hash_to_curve");
        }
    }

    function hash(bytes memory x) internal pure returns (bytes32) {
        return keccak256(x);
    }
}
