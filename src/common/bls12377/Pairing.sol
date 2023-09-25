// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./G1.sol";
import "./G2.sol";

/// @title BLS12Pairing
library BLS12Pairing {
    /// @dev BLS12_377_PAIRING precompile address.
    // uint256 private constant BLS12_PAIRING = 0x1b;
    uint256 private constant BLS12_PAIRING = 0x0807;

    /// @dev Checks that a signature is valid for the octet string message under the public key PK
    /// See <https://tools.ietf.org/html/draft-irtf-cfrg-bls-signature-04#section-2.8>
    /// @param public_key Public key in BLS12-377 G1.
    /// @param signature Signature in BLS12-377 G2.
    /// @param message An octet string.
    /// @return Result, either VALID or INVALID.
    function verify(Bls12G1 memory public_key, Bls12G2 memory signature, Bls12G2 memory message)
        internal
        view
        returns (bool)
    {
        Bls12G1[] memory a = new Bls12G1[](2);
        a[0] = BLS12G1Affine.neg_generator();
        a[1] = public_key;
        Bls12G2[] memory b = new Bls12G2[](2);
        b[0] = signature;
        b[1] = message;
        return pairing(a, b);
    }

    /// @dev Computes a "product" of pairings.
    /// @param a List of Bls12G1.
    /// @param b List of Bls12G2.
    /// @return True if pairing output is 1.
    function pairing(Bls12G1[] memory a, Bls12G2[] memory b) internal view returns (bool) {
        require(a.length == b.length, "!len");
        uint256 K = a.length;
        uint256 N = 12 * K;
        uint256[] memory input = new uint[](N);
        for (uint256 i = 0; i < K; i++) {
            Bls12G1 memory g1 = a[i];
            Bls12G2 memory g2 = b[i];
            input[i * 12] = g1.x.a;
            input[i * 12 + 1] = g1.x.b;
            input[i * 12 + 2] = g1.y.a;
            input[i * 12 + 3] = g1.y.b;
            input[i * 12 + 4] = g2.x.c0.a;
            input[i * 12 + 5] = g2.x.c0.b;
            input[i * 12 + 6] = g2.x.c1.a;
            input[i * 12 + 7] = g2.x.c1.b;
            input[i * 12 + 8] = g2.y.c0.a;
            input[i * 12 + 9] = g2.y.c0.b;
            input[i * 12 + 10] = g2.y.c1.a;
            input[i * 12 + 11] = g2.y.c1.b;
        }
        uint256[1] memory output;

        assembly ("memory-safe") {
            if iszero(staticcall(gas(), BLS12_PAIRING, add(input, 32), mul(N, 32), output, 32)) {
                let pt := mload(0x40)
                returndatacopy(pt, 0, returndatasize())
                revert(pt, returndatasize())
            }
        }

        return output[0] == 1;
    }
}
