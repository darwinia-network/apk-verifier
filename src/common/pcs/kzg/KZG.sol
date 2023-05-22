pragma solidity ^0.8.17;

import "./Params.sol";
import "../../bw6761/Fr.sol";
import "../../bw6761/G1.sol";

/// e(acc, g2) = e(proof, tau.g2)
struct AccumulatedOpening {
    Bw6G1Affine acc;
    Bw6G1Affine proof;
}

struct KzgOpening {
    Bw6G1Affine c;
    Bw6Fr x;
    Bw6Fr y;
    Bw6G1Affine proof;
}

library KZG {
    using BW6FR for Bw6Fr[];
    using BW6G1Affine for Bw6G1Affine;
    using BW6G1Affine for Bw6G1Affine[];

    function accumulate(
        KzgOpening[] memory openings,
        Bw6Fr[] memory rs,
        RVK memory vk
    ) internal view returns (AccumulatedOpening memory) {
        require(openings.length == rs.length, "!len");
        uint k = openings.length;
        Bw6G1Affine[] memory accs = new Bw6G1Affine[](k);
        Bw6G1Affine[] memory proofs = new Bw6G1Affine[](k);
        Bw6Fr[] memory ys = new Bw6Fr[](k);
        for (uint i = 0; i < k ; i++) {
            KzgOpening memory opening = openings[i];
            accs[i] = (opening.proof.mul(opening.x)).add(opening.c);
            proofs[i] = opening.proof;
            ys[i] = opening.y;
        }
        Bw6Fr memory sum_ry = rs.mul(ys);
        Bw6G1Affine memory acc = (vk.g1.mul(sum_ry)).sub(accs.msm(rs));
    }
}
