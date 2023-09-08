// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../../../../src/common/pcs/kzg/Params.sol";

contract KZGParamsTest is Test {
    using KZGParams for RVK;

    function test_serialize() public {
        RVK memory vk = KZGParams.raw_vk();
        bytes memory v = vk.serialize();
        bytes memory e = kzg_vk_serialize_compressed();
        assertEq(v, e);
    }

    function kzg_vk_serialize_compressed() internal pure returns (bytes memory) {
        return
        hex"5aba1fa03c90d549089e093353f1070c043e1f4872f54c772de4e2a4bce854412ee12f587aa6449ed4fd5f66379de7a761cbe061498b9d164b6eade50572c1785e815e929f818def320288d95387afec05a272135f072ff70d8ac03f0fd4ce002bfac7702340a729da3a7e3b0c045788455c845848ac6e27af9da0a34dc451be0e234e118540d056b6b585cbd859aeab1abfef212e8ce8995506c63c842196d7a4880976d983954241b07b29213e06aa247360a1f9f85766180c8b627b58e1006c524e1ceb60b6c63d135b99e14c6738738f093ac33c26920846554f256b9e1f68eed17a24d81bfa5c9ebf22179aacfd2088c4dafec5d67ad0368eea2b7f26c01cacd8b3037e33ba0276b4b01f22852d295ff523dd8f9a69bca1eeed13bd8780";
    }

}
