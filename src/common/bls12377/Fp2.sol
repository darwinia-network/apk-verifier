// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./Fp.sol";

import "forge-std/console2.sol";

struct Bls12Fp2 {
    Bls12Fp c0;
    Bls12Fp c1;
}

library BLS12FP2 {
    using BLS12FP for Bls12Fp;

    bytes private constant DST_PRIME = "APK-PROOF-with-BLS12377G2_XMD:SHA-256_SSWU_RO_.";
    bytes private constant Z_PAD =
        hex"00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";

    function eq(Bls12Fp2 memory x, Bls12Fp2 memory y) internal pure returns (bool) {
        return x.c0.eq(y.c0) && x.c1.eq(y.c1);
    }

    function hash_to_field(bytes memory message) internal view returns (Bls12Fp2[2] memory) {
        bytes memory uniform_bytes = expand_message_xmd(message);
        Bls12Fp2[2] memory output = abi.decode(uniform_bytes, (Bls12Fp2[2]));
        output[0] = norm(output[0]);
        output[1] = norm(output[1]);
        return output;
    }

    function expand_message_xmd(bytes memory message) internal pure returns (bytes memory) {
        bytes memory msg_prime = abi.encodePacked(Z_PAD, message, hex"010000", DST_PRIME);

        bytes32 b0 = sha256(msg_prime);
        bytes memory output = new bytes(256);
        bytes32 bi = sha256(abi.encodePacked(b0, bytes1(0x01), bytes(DST_PRIME)));
        assembly ("memory-safe") {
            mstore(add(output, 0x20), bi)
        }
        for (uint256 i = 2; i < 9; i++) {
            bytes32 mix_b;
            assembly ("memory-safe") {
                mix_b := xor(b0, mload(add(output, add(0x20, mul(0x20, sub(i, 2))))))
            }

            bi = sha256(abi.encodePacked(mix_b, bytes1(uint8(i)), bytes(DST_PRIME)));
            assembly ("memory-safe") {
                mstore(add(output, add(0x20, mul(0x20, sub(i, 1)))), bi)
            }
        }

        return output;
    }

    function norm(Bls12Fp2 memory fp2) internal view returns (Bls12Fp2 memory) {
        return Bls12Fp2(fp2.c0.norm(), fp2.c1.norm());
    }

    function debug(Bls12Fp2 memory fp2) internal view returns (bytes memory) {
        return abi.encodePacked(fp2.c0.debug(), fp2.c1.debug());
    }
}
