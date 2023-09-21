// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../PackedInput.t.sol";
import "../../../src/common/piop/AffineAddition.sol";

contract BasicProtocolTest is PackedInputTest {
    using BW6FR for Bw6Fr;
    using Lagrange for Bw6Fr;
    using BasicProtocol for AffineAdditionEvaluations;

    function test_evaluate_constraint_polynomials() public {
        AccountablePublicInput memory public_input = build_public_input();
        PackedProof memory proof = build_proof();
        Challenges memory challenges = build_expect_challenges();
        AffineAdditionEvaluations memory a = proof.register_evaluations.basic_evaluations;
        LagrangeEvaluations memory evals_at_zeta = challenges.zeta.lagrange_evaluations(domain());
        Bw6Fr[] memory evals = a.evaluate_constraint_polynomials(public_input.apk, evals_at_zeta);

        Bw6Fr memory e1 =
            Bw6Fr(0x41213fbc22021313b07840b4138ea0, 0xbf75af24ba8b329d4f8eba554faacf31d91229656e4481b09b18d49aafa41801);
        Bw6Fr memory e2 =
            Bw6Fr(0xa799ddd8485601c9d3c38e24109c9e, 0x19bfaa13a9891308706ca86aed99d92a7fe1f46319449d804e45b72c89ba7981);
        Bw6Fr memory e3 =
            Bw6Fr(0xce4262e137fffa7fb2a17193baf929, 0x35848b2dda097f5a579714e3088e568218625cdde0f388c8e73dc964ff4ffdca);
        Bw6Fr memory e4 =
            Bw6Fr(0x36e5a62826be2a86d75c937ee92031, 0x93abbd0ba900eb1edbd5060e27f689785ad2801696d7ec9bedc06c9b424dc308);
        Bw6Fr memory e5 =
            Bw6Fr(0xcad9cda487cf9586b2caa449ae9ddf, 0x576ff03516d1b10f1e251eceb4846007934b8e3b2d362ef94494a8810f6cfe18);

        assertEq(e1.debug(), evals[0].debug());
        assertEq(e2.debug(), evals[1].debug());
        assertEq(e3.debug(), evals[2].debug());
        assertEq(e4.debug(), evals[3].debug());
        assertEq(e5.debug(), evals[4].debug());
    }

    function domain() internal pure returns (Radix2EvaluationDomain memory) {
        return Radix2.init();
    }
}
