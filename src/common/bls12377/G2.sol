pragma solidity ^0.8.17;

import "./Fp2.sol";

struct Bls12G2Affine {
    Bls12Fp2 x;
    Bls12Fp2 y;
}

library BLS12G2 {

    // TODO: switch to better hash to curve when available
    function hash_to_curve(bytes memory message) internal view returns (Bls12G2Affine memory) {
        bytes memory r1 = hex'd2a6843b098fc7aa6c612cd28f3637d5472d6ae4e71a399b39b64e5e1888567a3ffd79c8a20e43a0c4c15f1496c0f78cd1da87ad3d26b7eea1a5bc4bfd8caf567018b0020c573ba583f5d93b8af2ac7bad9b44523e0329aecf5cb61e33d9ec809ff9962f2673349e3c0e5a7ebbd007f40ee96bb684bf07cd2290379d29a0ad7e5d20f166096ff491413f2eabf1b15b3693a792c1403ffff4180ac0af21294049c2d612566d392179aa00d5168d8940b495ef3e2af93ddbc3e6b459779042048108000000';
        bytes memory r2 = hex'41ef33f28c04949108c172383f6dbfcb90b0b728717db3d5b98b7feebefe87d7acd6a384abc2ad506096423f494e96618af9a38fcac56330fc6d59780565ed1f04f6dcafa949436c1c381e568c6bffb98d538fe1a9a71f6c604cb3f647ca8800d7e9678f368b5d6f06c650ecdc208c87da53ad33283a2aae82ff3c7ca8b4b678986e82eb71fcd0d474780adf6b7f3c8cd5d8af5a881496d3b66ac203f473b498ce48ea748ab4722af122b86e13eebc0abed1f465ccc9817e89204eab3523488008000000';
        Bls12G2Affine memory p1 = Bls12G2Affine(Bls12Fp2(Bls12Fp(0xa96d4ba3d794796c9a831ea32d1b68, 0x15430996b90cd0b62fead75c7f106e00a42abbda2636ca9fbdaad830bfe2e51f), Bls12Fp(0x167bad61cb755a96b0a77f321d6f085, 0xbdf8e8678cd779a1292ae6b89df8ae925ae0d1647b836b8f62183b1563a4b11f)), Bls12Fp2(Bls12Fp(0xa8b3d49887e70982afe2f4d4268776, 0x3d2535f4452f7de5718d53730121a05bce7da42aa066a51a6d63dc48ffde5a70), Bls12Fp(0x1accb0f2b5255a02433cfa9b6929aa6, 0x2b3b40082287829acb14b4ff10bb19a0e9694bb78fc07123337d406c30d93b67)));
        Bls12G2Affine memory p2 = Bls12G2Affine(Bls12Fp2(Bls12Fp(0x15356e27a5b50286e5e088f4ff802a0, 0xacc5a3b3aa5a9b7dfbed1c8f5d630fbf2ad548ef84710b5a4d5575cc8785fafc), Bls12Fp(0x7c72365e30cfc747f9c513967ff01b, 0x83987b2037004232a27534e202cb8769457afb8925b5ab5ff8c1bbfffe742af6)), Bls12Fp2(Bls12Fp(0x3ad6611555b271759a8c1df9a4418, 0xc17ae50e122a8855c406da795943237b13da5a31f742409f96b5bf2edd97c618), Bls12Fp(0x1accb0f2b5255a02433cfa9b6929aa6, 0x2b3b40082287829acb14b4ff10bb19a0e9694bb78fc07123337d406c30d93b67)));

        if (hash(message) == hash(r1)) {
            return p1;
        } else if (hash(message) == hash(r2)) {
            return p2;
        } else {
            revert("!hash_to_curve");
        }
    }

    function hash(bytes memory x) internal pure returns (bytes32) {
        return keccak256(x);
    }
}
