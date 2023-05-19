// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "./common/KeySet.sol";
import "./common/PackedProof.sol";
import "./common/PublicInput.sol";
import "./common/bls12377/G2.sol";
import "./common/bw6761/Fr.sol";
import "./common/poly/domain/Radix2.sol";
import "./common/poly/evaluations/Lagrange.sol";

contract Verifier {
    using BitMask for Bitmask;
    using Lagrange for Bw6Fr;

    KeysetCommitment public pks_comm;

    uint256 internal constant LOG_N = 8;
    uint256 internal constant POLYS_OPENED_AT_ZETA = 8;

    struct Challenges {
        Bw6Fr r;
        Bw6Fr phi;
        Bw6Fr zeta;
        Bw6Fr[] nus;
    }

    constructor(KeysetCommitment memory c0) {
        pks_comm.pks_comm[0] = c0.pks_comm[0];
        pks_comm.pks_comm[1] = c0.pks_comm[1];
    }

    // size: 256
    // log_size_of_group: 8
    // size_as_field_element: 256
    // size_inv: 257654018098855933487173621453897855671016975595715775147150339765678591518855116436004165920278151686454226452481
    // group_gen: 154024850971602403716343999335441368721120525754417003009036162778518935047698676752264790802570774154019420192516
    // group_gen_inv: 36228310605284181749511895050030902175643863782072248343426179647675890968621805560723075433239103594150130258885
    // offset: 1
    // offset_inv: 1
    // offset_pow_size: 1
    function domain() internal pure returns (Radix2EvaluationDomain memory) {
        return Radix2EvaluationDomain({
           size: 256,
           log_size_of_group: 8,
           size_as_field_element: Bw6Fr(0, 256),
           size_inv: Bw6Fr(0x1ac8c0bd1ad4bd9db74cabaac34a7f1, 0xdf08b7190df41e7b8fd46ecd8a4f3eb816f451e6ebd000008483b74000000001),
           group_gen: Bw6Fr(0x1002f29b90f34d050aca1e5fa3f7633, 0x712d6bc0d484c501aed11a0c88d9f8c87a0c14230db0b91cb42b84a2dce33f04),
           group_gen_inv: Bw6Fr(0x3c41de81751c63b6e0389795b5feba, 0xeffa4f9e8f3b8a87ee9ee3eabaa65f2ab40a45e807458704a002ea0add4e93c5),
           offset: BW6FR.one(),
           offset_inv: BW6FR.one(),
           offset_pow_size: BW6FR.one()
        });
    }

    function verify_aggregates(
        AccountablePublicInput calldata public_input,
        PackedProof calldata proof,
        Signature calldata aggregate_signature,
        KeysetCommitment calldata new_validator_set_commitment
    ) external {
        uint n_signers = public_input.bitmask.count_ones();
        verify_packed(public_input, proof);
        // 2. verify_bls
        // 3. check threhold
    }

    function verify_packed(
        AccountablePublicInput calldata public_input,
        PackedProof calldata proof
    ) internal view returns (bool) {
        Challenges memory challenges = restore_challenges(public_input, proof, POLYS_OPENED_AT_ZETA);
        challenges.zeta.lagrange_evaluations(domain());
        // 3. validate_evaluations
        // 4. evaluate_constraint_polynomials
        // 5. w = horner_field
        // 6. proof.r_zeta_omega + w == proof.q_zeta * evals_at_zeta.vanishing_polynomial
    }

    function restore_challenges(
        AccountablePublicInput calldata public_input,
        PackedProof calldata proof,
        uint batch_size
    ) internal pure returns (Challenges memory challenges) {
        // round 1
        // r: 148463445298089904513087484940164626325
        // phi: 243748979811998529482591231053547914852
        // zeta: 58577177620710384020790074836476479695
        // nus: 294226658051913336540121282516254233209
        // nus: 229410270415995212517116040564899870968
        // nus: 270750939643154050657857728703505368456
        // nus: 128439446578377229427899470686821262556
        // nus: 87988987011424240712390231091508683762
        // nus: 199905441038655779674490672174270276191
        // nus: 270839794691390195040902573679323356436
        // nus: 10867984333282547221687828916972081361
        // round 2
        // r: 253453553334492236314136518247811366407
        // phi: 5764060185484733714944649537193910790
        // zeta: 264032886822723680866809969862799286716
        // nus: 248706878528030314442584180890783668863
        // nus: 280770477547727441267737976516388075851
        // nus: 66398653458974599588365071027440219540
        // nus: 86591554995251836073465301941886672047
        // nus: 324722053290355541151556099019120340334
        // nus: 224847281907241683364320560038619621321
        // nus: 64748762694498982892334791840564383988
        // nus: 325921140606714040130243320654852173932
    }

    // function validate_evaluations(
    //     PackedProof calldata proof,
    //     Challenges memory challenges,
    //     TranscriptRng memory fsrng,
    //     LagrangeEvaluations memory evals_at_zeta
    // ) internal pure {}

    // funciont evaluate_constraint_polynomials(
    //     G1Affine memory apk,
    //     LagrangeEvaluations memory evals_at_zeta,
    //     uint challenges_r,
    //     Bitmask memory bitmask,
    //     uint domain_size
    // ) internal pure returns (
    //     Fr[] memory constraint_polynomial_evals
    // ) {}
}
