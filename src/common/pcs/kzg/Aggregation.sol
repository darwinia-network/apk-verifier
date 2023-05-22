pragma solidity ^0.8.17;

import "../../bw6761/Fr.sol";
import "../../bw6761/G1.sol";

library Single {
    function aggregate_claims_multiexp(
        Bw6G1Affine[] memory cs,
        Bw6Fr[] memory ys,
        Bw6Fr[] memory rs
    ) internal view {
        require(cs.length == rs.length, "!len");
        require(ys.length == rs.length, "!len");
    }
}
