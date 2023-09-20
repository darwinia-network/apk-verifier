// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./Fp.sol";

struct Bw6G2 {
    Bw6Fp x;
    Bw6Fp y;
}

library BW6G2Affine {
    using BW6FP for Bw6Fp;

    bytes1 private constant INFINITY_FLAG = bytes1(0x40);
    bytes1 private constant Y_IS_NEGATIVE = bytes1(0x80);

    function zero() internal pure returns (Bw6G2 memory) {
        return Bw6G2(BW6FP.zero(), BW6FP.zero());
    }

    function is_zero(Bw6G2 memory p) internal pure returns (bool) {
        return p.x.is_zero() && p.y.is_zero();
    }

    function is_infinity(Bw6G2 memory p) internal pure returns (bool) {
        return is_zero(p);
    }

    function serialize(Bw6G2 memory g2) internal pure returns (bytes memory r) {
        if (is_infinity(g2)) {
            r = new bytes(96);
            r[95] = INFINITY_FLAG;
        } else {
            Bw6Fp memory neg_y = g2.y.neg();
            bool y_flag = g2.y.gt(neg_y);
            r = g2.x.serialize();
            if (y_flag) {
                r[95] |= Y_IS_NEGATIVE;
            }
        }
    }
}
