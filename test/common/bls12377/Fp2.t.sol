// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../../../src/common/bls12377/Fp2.sol";

contract BLS12FP2Test is Test {
    using BLS12FP2 for bytes;

    function test_expand_message_xmd() public {
        bytes memory m =
            hex"a1f80482fcc0bebe31ecdac01f571644c85d2623a5db8878ea4609274a49cf77ff221e0cacde36b8230677ba75a2e74ebbed22434d7673c1a1235c15c3ca342195dc79f09fb2e88c60411849ebf821581eeda074f130576a80c99aa24f21170078dc755346c371efac85aec926ff78ddb70d261bbd867d647b54cf9f55a9221fee32a62bd06a23b30c1d6be94b4cf8506fcdb0056835d9569878001f69e828135d2003acf08d360b682293770c3d493e1f67ac590328e10752675b804c6db20008000000";
        bytes memory uniform_bytes = m.expand_message_xmd();
        bytes memory e =
            hex"7b1c83fc62eeb4ab4eb453d41b37e0dcce76a9af515b9b2449402df27eecca691576b24611e36431eeb182fdf2d33ea96dd07580be9ee37c782a23ec5e7a9ab158beaad8e514d2718a5fb8554212f1be51b0238e8c1bfee9ef50429a548c2df0f87ae64d6c7d6ecfd24a56391a2c1fbeb32c878e7ee2bb84d7534b7cd537fd82318289c43c55840143aee5e730259c5bbe77b3181f7323af32b577e08c14fe065cfa58272d1c970d02af1df1a4967f8bf7fb671e460a0e730fd563160f9292d11431d8f6ec15d0e67313518001423ee5fcaf634b2997d465b67b940e418082079950c937651f7c8dc5f5a351725ce7d7797ddcdf1b195440a6db38abb0a55d3e";
        assertEq(e, uniform_bytes);
    }
}
