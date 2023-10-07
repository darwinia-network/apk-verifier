// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.17;

import "../SimpleInput.t.sol";

contract BLS12G1AffineTest is SimpleInputTest {
    using BLS12G1Affine for Bls12G1;

    function test_serialize() public {
        AccountablePublicInput memory public_input = build_public_input();
        bytes memory s = public_input.apk.serialize();
        bytes memory e =
            hex"9ea33636de773b3fab28129e5611cd57aed9d413e84df03cb30a42b56714fffa5377efe2a13a61dc8acc39696812df00";
        assertEq(e, s);
    }
}
