// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./SimpleInput.t.sol";
import "../../src/common/PublicInput.sol";

contract PublicInputTest is SimpleInputTest {
    using PublicInput for AccountablePublicInput;

    function test_serialize() public {
        AccountablePublicInput memory public_input = build_public_input();
        bytes memory s = public_input.serialize();
        bytes memory e = public_input_compressed();
        assertEq(e, s);
    }

    function public_input_compressed() internal pure returns (bytes memory) {
        return hex'9ea33636de773b3fab28129e5611cd57aed9d413e84df03cb30a42b56714fffa5377efe2a13a61dc8acc39696812df000400000000000000dfffffbfeffbff7ffeffb5dffff7fffffffffffdfbfefffeeffbbfffff7bdf7f0100000000000000';
    }
}
