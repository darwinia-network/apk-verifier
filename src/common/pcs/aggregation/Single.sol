pragma solidity ^0.8.17;

import "../../bw6761/Fr.sol";
import "../../bw6761/G1.sol";

library Single {
    using BW6FR for Bw6Fr;
    using BW6FR for Bw6Fr[];
    using BW6G1Affine for Bw6G1Affine[];

    function aggregate_claims_multiexp(
        Bw6G1Affine[] memory cs,
        Bw6Fr[] memory ys,
        Bw6Fr[] memory rs
    ) internal view returns (
        Bw6G1Affine memory,
        Bw6Fr memory
    ) {
        require(cs.length == rs.length, "!len");
        require(ys.length == rs.length, "!len");
        uint k = cs.length;
        Bw6G1Affine memory agg_c = cs.msm(rs);
        Bw6Fr memory agg_y = ys.mul(rs);
        return (agg_c, agg_y);
    }
}
