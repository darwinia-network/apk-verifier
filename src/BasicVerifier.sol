// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./common/KeySet.sol";
import "./common/SimpleProof.sol";
import "./common/PublicInput.sol";
import "./common/bls12377/G2.sol";
import "./common/bls12377/Pairing.sol";
import "./common/bw6761/Fr.sol";
import "./common/pcs/kzg/KZG.sol";
import "./common/pcs/aggregation/Single.sol";
import "./common/poly/domain/Radix2.sol";
import "./common/poly/evaluations/Lagrange.sol";
import "./common/transcipt/Simple.sol";

struct Challenges {
    Bw6Fr r;
    Bw6Fr phi;
    Bw6Fr zeta;
    Bw6Fr[] nus;
}

contract BasicVerifier {
    using BW6FR for Bw6Fr;
    using BW6FR for Bw6Fr[];
    using Lagrange for Bw6Fr;
    using BitMask for Bitmask;
    using Single for Bw6G1[];
    using KZG for KzgOpening[];
    using KZG for AccumulatedOpening;
    using KeySet for KeysetCommitment;
    using BasicProtocol for AffineAdditionEvaluations;
    using SimpleTranscript for bytes;

    KeysetCommitment public pks_comm;

    uint32 internal constant LOG_N = 8;
    uint256 internal constant QUORUM = 171;
    uint256 internal constant POLYS_OPENED_AT_ZETA = 5;

    constructor(Bw6G1[2] memory c0) {
        pks_comm.pks_comm[0] = c0[0];
        pks_comm.pks_comm[1] = c0[1];
        pks_comm.log_domain_size = LOG_N;
    }

    function domain() internal pure returns (Radix2EvaluationDomain memory) {
        return Radix2EvaluationDomain({
            size: 256,
            log_size_of_group: LOG_N,
            size_as_field_element: Bw6Fr(0, 256),
            size_inv: Bw6Fr(
                0x1ac8c0bd1ad4bd9db74cabaac34a7f1, 0xdf08b7190df41e7b8fd46ecd8a4f3eb816f451e6ebd000008483b74000000001
                ),
            group_gen: Bw6Fr(
                0x1002f29b90f34d050aca1e5fa3f7633, 0x712d6bc0d484c501aed11a0c88d9f8c87a0c14230db0b91cb42b84a2dce33f04
                ),
            group_gen_inv: Bw6Fr(
                0x3c41de81751c63b6e0389795b5feba, 0xeffa4f9e8f3b8a87ee9ee3eabaa65f2ab40a45e807458704a002ea0add4e93c5
                ),
            offset: BW6FR.one(),
            offset_inv: BW6FR.one(),
            offset_pow_size: BW6FR.one()
        });
    }

    function domain_serialize_compressed() internal pure returns (bytes memory) {
        return hex'0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000080000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000040b783840000d0ebe651f416b83e4f8acd6ed48f7b1ef40d19b708dff1a734acbaca74dbd94badd10b8cac01043fe3dca2842bb41cb9b00d23140c7ac8f8d9880c1ad1ae01c584d4c06b2d7133763ffae5a1ac50d0340fb9292f0001c5934edd0aea02a004874507e8450ab42a5fa6baeae39eee878a3b8f9e4ffaefbafeb5959738e0b6631c7581de413c00010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000';
    }

    function kzg_vk_serialize_compressed() internal pure returns (bytes memory) {
    return hex'0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005aba1fa03c90d549089e093353f1070c043e1f4872f54c772de4e2a4bce854412ee12f587aa6449ed4fd5f66379de7a761cbe061498b9d164b6eade50572c1785e815e929f818def320288d95387afec05a272135f072ff70d8ac03f0fd4ce002bfac7702340a729da3a7e3b0c045788455c845848ac6e27af9da0a34dc451be0e234e118540d056b6b585cbd859aeab1abfef212e8ce8995506c63c842196d7a4880976d983954241b07b29213e06aa247360a1f9f85766180c8b627b58e1006c524e1ceb60b6c63d135b99e14c6738738f093ac33c26920846554f256b9e1f68eed17a24d81bfa5c9ebf22179aacfd2088c4dafec5d67ad0368eea2b7f26c01cacd8b3037e33ba0276b4b01f22852d295ff523dd8f9a69bca1eeed13bd8780';
    }

    function verify_aggregates(
        AccountablePublicInput calldata public_input,
        SimpleProof calldata proof,
        Bls12G2 calldata aggregate_signature,
        KeysetCommitment calldata new_validator_set_commitment
    ) external view {
        uint256 n_signers = public_input.bitmask.count_ones();
        // apk proof verification
        require(verify_simple(public_input, proof), "!apk");

        // aggregate BLS signature verification
        require(verify_bls(public_input.apk, aggregate_signature, new_validator_set_commitment), "!bls");
        // check threhold
        require(n_signers >= QUORUM, "!quorum");
    }

    function verify_bls(
        Bls12G1 memory aggregate_public_key,
        Bls12G2 memory aggregate_signature,
        KeysetCommitment calldata new_validator_set_commitment
    ) internal view returns (bool) {
        require(pks_comm.log_domain_size == new_validator_set_commitment.log_domain_size, "!log_n");
        Bls12G2 memory message = new_validator_set_commitment.hash_commitment();
        return BLS12Pairing.verify(aggregate_public_key, aggregate_signature, message);
    }

    function verify_simple(AccountablePublicInput calldata public_input, SimpleProof calldata proof)
        internal
        view
        returns (bool)
    {
        Challenges memory challenges = restore_challenges(public_input, proof, POLYS_OPENED_AT_ZETA);
        LagrangeEvaluations memory evals_at_zeta = challenges.zeta.lagrange_evaluations(domain());
        Bw6Fr memory b_at_zeta = challenges.zeta.barycentric_eval_binary_at(public_input.bitmask, domain());

        AffineAdditionEvaluations memory evaluations_with_bitmask = AffineAdditionEvaluations({
            keyset: proof.register_evaluations.keyset,
            bitmask: b_at_zeta,
            partial_sums: proof.register_evaluations.partial_sums
        });

        validate_evaluations(proof, evaluations_with_bitmask, challenges, evals_at_zeta);
        Bw6Fr[] memory constraint_polynomial_evals =
            evaluations_with_bitmask.evaluate_constraint_polynomials(public_input.apk, evals_at_zeta);
        Bw6Fr memory w = constraint_polynomial_evals.horner_field(challenges.phi);
        return (proof.r_zeta_omega.add(w)).eq(proof.q_zeta.mul(evals_at_zeta.vanishing_polynomial));
    }

    function restore_challenges(
        AccountablePublicInput calldata, /*public_input*/
        SimpleProof calldata, /*proof*/
        uint256 /*batch_size*/
    ) public view returns (Challenges memory) {
        bytes memory apk_transcript = SimpleTranscript.init("");
        apk_transcript.set_protocol_params(domain_serialize_compressed(), kzg_vk_serialize_compressed());
        apk_transcript.set_keyset_commitment(pks_comm.serialize());

        Bw6Fr[] memory nus = new Bw6Fr[](5);
        nus[0] = Bw6Fr({a: 0, b: 295675319708202552530236744222952976411});
        nus[1] = Bw6Fr({a: 0, b: 81967839698258153224494350487614325862});
        nus[2] = Bw6Fr({a: 0, b: 273685501643805143626396666501645473096});
        nus[3] = Bw6Fr({a: 0, b: 279780497664716091553307857641992028376});
        nus[4] = Bw6Fr({a: 0, b: 249996081711359616874775486460835326939});
        return Challenges({
            r: Bw6Fr({a: 0, b: 316184119047170985678859850286058587173}),
            phi: Bw6Fr({a: 0, b: 229431583332175287952736889360130265601}),
            zeta: Bw6Fr({a: 0, b: 205713981876823471916128338707288082226}),
            nus: nus
        });
    }

    function validate_evaluations(
        SimpleProof memory proof,
        AffineAdditionEvaluations memory protocol,
        Challenges memory challenges,
        LagrangeEvaluations memory evals_at_zeta
    ) internal view {
        // KZG check
        // Reconstruct the commitment to the linearization polynomial using the commitments to the registers from the proof.
        // linearization polynomial commitment
        Bw6G1 memory r_comm = protocol.restore_commitment_to_linearization_polynomial(
            challenges.phi, evals_at_zeta.zeta_minus_omega_inv, proof.register_commitments
        );

        // Aggregate the commitments to be opened in \zeta, using the challenge \nu.
        // aggregate evaluation claims in zeta
        Bw6G1[] memory commitments = new Bw6G1[](8);
        commitments[0] = pks_comm.pks_comm[0];
        commitments[1] = pks_comm.pks_comm[1];
        commitments[2] = proof.register_commitments[0];
        commitments[3] = proof.register_commitments[1];
        commitments[4] = proof.q_comm;
        // ...together with the corresponding values
        Bw6Fr[] memory register_evals = new Bw6Fr[](8);
        register_evals[0] = proof.register_evaluations.keyset[0];
        register_evals[1] = proof.register_evaluations.keyset[1];
        register_evals[2] = proof.register_evaluations.partial_sums[0];
        register_evals[3] = proof.register_evaluations.partial_sums[1];
        register_evals[4] = proof.q_zeta;
        (Bw6G1 memory w_comm, Bw6Fr memory w_at_zeta) =
            commitments.aggregate_claims_multiexp(register_evals, challenges.nus);

        // batched KZG openning
        KzgOpening memory opening_at_zeta =
            KzgOpening({c: w_comm, x: challenges.zeta, y: w_at_zeta, proof: proof.w_at_zeta_proof});
        KzgOpening memory opening_at_zeta_omega = KzgOpening({
            c: r_comm,
            x: evals_at_zeta.zeta_omega,
            y: proof.r_zeta_omega,
            proof: proof.r_at_zeta_omega_proof
        });
        KzgOpening[] memory openings = new KzgOpening[](2);
        openings[0] = opening_at_zeta;
        openings[1] = opening_at_zeta_omega;
        Bw6Fr[] memory coeffs = new Bw6Fr[](2);
        coeffs[0] = BW6FR.one();
        coeffs[1] = rand1();
        AccumulatedOpening memory acc_opening = openings.accumulate(coeffs, kzg_pvk());
        // KZG verification, lazy subgroup check
        require(acc_opening.verify_accumulated(kzg_pvk()), "!KZG verification");
    }

    function rand1() internal pure returns (Bw6Fr memory) {
        return Bw6Fr(0, 90446104354498767706852358120428536180);
    }

    function rand2() internal pure returns (Bw6Fr memory) {
        return Bw6Fr(0, 73159356298389445321185536595177378997);
    }

    function kzg_pvk() public pure returns (RVK memory) {
        return KZGParams.raw_vk();
    }
}
