// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "../bw6761/Fr.sol";
import "../bytes/ByteOrder.sol";

struct Transcript {
    bytes buffer;
}

library SimpleTranscript {
    function simple_fiat_shamir_rng(Transcript memory self) internal pure returns (Transcript memory) {
        Transcript memory t = init(self.buffer);
        update(t, "verifier_secret");
        update(t, abi.encodePacked(uint8(42)));
        update(t, abi.encodePacked(bytes32(0)));
        return t;
    }

    function set_protocol_params(Transcript memory self, bytes memory domain, bytes memory kzg_vk) internal pure {
        _append_serializable(self, "domain", domain);
        _append_serializable(self, "vk", kzg_vk);
    }

    function set_keyset_commitment(Transcript memory self, bytes memory keyset_commitment) internal pure {
        _append_serializable(self, "keyset_commitment", keyset_commitment);
    }

    function append_public_input(Transcript memory self, bytes memory public_input) internal pure {
        _append_serializable(self, "public_input", public_input);
    }

    function append_register_commitments(Transcript memory self, bytes memory register_commitments) internal pure {
        _append_serializable(self, "register_commitments", register_commitments);
    }

    function get_bitmask_aggregation_challenge(Transcript memory self) internal pure returns (Bw6Fr memory) {
        return _get_128_bit_challenge(self, "bitmask_aggregation");
    }

    function append_2nd_round_register_commitments(Transcript memory self, bytes memory register_commitments)
        internal
        pure
    {
        _append_serializable(self, "2nd_round_register_commitments", register_commitments);
    }

    function get_constraints_aggregation_challenge(Transcript memory self) internal pure returns (Bw6Fr memory) {
        return _get_128_bit_challenge(self, "constraints_aggregation");
    }

    function append_quotient_commitment(Transcript memory self, bytes memory point) internal pure {
        _append_serializable(self, "quotient", point);
    }

    function get_evaluation_point(Transcript memory self) internal pure returns (Bw6Fr memory) {
        return _get_128_bit_challenge(self, "evaluation_point");
    }

    function append_evaluations(
        Transcript memory self,
        bytes memory evals,
        bytes memory q_at_zeta,
        bytes memory r_at_zeta_omega
    ) internal pure {
        _append_serializable(self, "register_evaluations", evals);
        _append_serializable(self, "quotient_evaluation", q_at_zeta);
        _append_serializable(self, "shifted_linearization_evaluation", r_at_zeta_omega);
    }

    function get_kzg_aggregation_challenges(Transcript memory self, uint256 n) internal pure returns (Bw6Fr[] memory) {
        return _get_128_bit_challenges(self, "kzg_aggregation", n);
    }

    function init(bytes memory message) internal pure returns (Transcript memory) {
        return Transcript(message);
    }

    function update(Transcript memory self, bytes memory message) internal pure {
        self.buffer = abi.encodePacked(self.buffer, message);
    }

    function reset(Transcript memory self) internal pure {
        self.buffer = "";
    }

    function finalize(Transcript memory self) internal pure returns (bytes16) {
        bytes32 dest = keccak256(self.buffer);
        return bytes16(dest);
    }

    function _get_128_bit_challenge(Transcript memory self, bytes memory label) internal pure returns (Bw6Fr memory) {
        update(self, label);
        bytes16 out = finalize(self);
        return BW6FR.from_random_bytes(out);
    }

    function _get_128_bit_challenges(Transcript memory self, bytes memory label, uint256 n)
        internal
        pure
        returns (Bw6Fr[] memory)
    {
        Bw6Fr[] memory r = new Bw6Fr[](n);
        for (uint256 i = 0; i < n; i++) {
            r[i] = _get_128_bit_challenge(self, label);
        }
        return r;
    }

    function _append_serializable(Transcript memory self, bytes memory label, bytes memory message) internal pure {
        update(self, label);
        update(self, message);
    }

    function rand_u128(Transcript memory self) internal pure returns (Bw6Fr memory) {
        update(self, hex"0000000000000000");
        bytes16 x = finalize(self);
        uint64 a = ByteOrder.reverse64(uint64(bytes8(x)));
        update(self, hex"0000000000000000");
        bytes16 y = finalize(self);
        uint64 b = ByteOrder.reverse64(uint64((bytes8(y))));
        uint256 r = (uint256(b) << 64) | uint256(a);
        return Bw6Fr(0, r);
    }
}
