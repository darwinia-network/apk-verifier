// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../../../src/common/transcipt/Simple.sol";

contract SimpleTranscriptTest is Test {
    using SimpleTranscript for Transcript;

    Transcript t;

    function setUp() public {
        t = SimpleTranscript.init("apk_proof");
    }

    function test_init() public {
        assertEq(hex'61706b5f70726f6f66', t.buffer);
    }

    function test_set_protocol_params() public {

    }
}
