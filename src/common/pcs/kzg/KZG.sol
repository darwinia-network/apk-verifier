pragma solidity ^0.8.17;

import "./Params.sol";
import "../../bw6761/Fr.sol";
import "../../bw6761/G1.sol";
import "../../bw6761/Pairing.sol";

/// e(acc, g2) = e(proof, tau.g2)
struct AccumulatedOpening {
    Bw6G1 acc;
    Bw6G1 proof;
}

struct KzgOpening {
    Bw6G1 c;
    Bw6Fr x;
    Bw6Fr y;
    Bw6G1 proof;
}

library KZG {
    using BW6FR for Bw6Fr[];
    using BW6G1Affine for Bw6G1;
    using BW6G1Affine for Bw6G1[];

    function accumulate(KzgOpening[] memory openings, Bw6Fr[] memory rs, RVK memory vk)
        internal
        view
        returns (AccumulatedOpening memory)
    {
        require(openings.length == rs.length, "!len");
        uint256 k = openings.length;
        Bw6G1[] memory accs = new Bw6G1[](k);
        Bw6G1[] memory proofs = new Bw6G1[](k);
        Bw6Fr[] memory ys = new Bw6Fr[](k);
        for (uint256 i = 0; i < k; i++) {
            KzgOpening memory opening = openings[i];
            accs[i] = (opening.proof.mul(opening.x)).add(opening.c);
            proofs[i] = opening.proof;
            ys[i] = opening.y;
        }
        Bw6Fr memory sum_ry = rs.mul_sum(ys);
        Bw6G1 memory acc = (vk.g1.mul(sum_ry)).sub(accs.msm(rs));
        Bw6G1 memory proof = proofs.msm(rs);
        return AccumulatedOpening(acc, proof);
    }

    function verify_accumulated(AccumulatedOpening memory opening, RVK memory vk) internal view returns (bool) {
        Bw6G1[] memory a = new Bw6G1[](2);
        a[0] = opening.acc;
        a[1] = opening.proof;
        Bw6G2[] memory b = new Bw6G2[](2);
        b[0] = vk.g2;
        b[1] = vk.tau_in_g2;
        return BW6Pairing.pairing(a, b);
    }
}
