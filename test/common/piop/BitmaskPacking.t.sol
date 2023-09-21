// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../PackedInput.t.sol";
import "../../../src/common/piop/BitmaskPacking.sol";

contract PackedProtocolTest is PackedInputTest {
    using BW6FR for Bw6Fr;
    using Lagrange for Bw6Fr;
    using PackedProtocol for SuccinctAccountableRegisterEvaluations;

    function test_evaluate_constraint_polynomials() public {
        AccountablePublicInput memory public_input = build_public_input();
        PackedProof memory proof = build_proof();
        Challenges memory challenges = build_expect_challenges();
        SuccinctAccountableRegisterEvaluations memory a = proof.register_evaluations;
        LagrangeEvaluations memory evals_at_zeta = challenges.zeta.lagrange_evaluations(domain());
        Bw6Fr[] memory evals = a.evaluate_constraint_polynomials(
            public_input.apk, evals_at_zeta, challenges.r, public_input.bitmask, domain().size
        );
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
        Bw6Fr memory e6 =
            Bw6Fr(0x8f636c6e6b68d06fe4ee20c8659167, 0x70e71ba257ba86f3255fd4bd05a0ea5319cc002dec2174ec662759d7df736ed7);
        Bw6Fr memory e7 =
            Bw6Fr(0x107a2d31e8cd62d82a070ccca410001, 0x476b94d2ae3bf1982b18e7357c49335ee5b4ed0dd16f272ce69067c86d07e6c6);

        assertEq(e1.debug(), evals[0].debug());
        assertEq(e2.debug(), evals[1].debug());
        assertEq(e3.debug(), evals[2].debug());
        assertEq(e4.debug(), evals[3].debug());
        assertEq(e5.debug(), evals[4].debug());
        assertEq(e6.debug(), evals[5].debug());
        assertEq(e7.debug(), evals[6].debug());
    }

    function domain() internal pure returns (Radix2EvaluationDomain memory) {
        return Radix2.init();
    }
}
