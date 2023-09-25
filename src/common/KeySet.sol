// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./bw6761/G1.sol";
import "./bls12377/G2.sol";
import "./bytes/ByteOrder.sol";

/// @dev Polynomial commitment to the vector of public keys.
///  Let 'pks' be such a vector that commit(pks) == KeysetCommitment::pks_comm, also let
///  domain_size := KeysetCommitment::domain.size and
///  keyset_size := KeysetCommitment::keyset_size
///  Then the verifier needs to trust that:
///  1. a. pks.len() == KeysetCommitment::domain.size
///     b. pks[i] lie in BLS12-377 G1 for i=0,...,domain_size-2
///     c. for the 'real' keys pks[i], i=0,...,keyset_size-1, there exist proofs of possession
///        for the padding, pks[i], i=keyset_size,...,domain_size-2, dlog is not known,
///        e.g. pks[i] = hash_to_g1("something").
///     pks[domain_size-1] is not a part of the relation (not constrained) and can be anything,
///     we set pks[domain_size-1] = (0,0), not even a curve point.
///  2. KeysetCommitment::domain is the domain used to interpolate pks
/// @notice In light client protocols the commitment is to the upcoming validator set, signed by the current validator set.
///  Honest validator checks the proofs of possession, interpolates with the right padding over the right domain,
///  computes the commitment using the right parameters, and then sign it.
///  Verifier checks the signatures and can trust that the properties hold under some "2/3 honest validators" assumption.
///  As every honest validator generates the same commitment, verifier needs to check only the aggregate signature.
/// @param pks_comm Per-coordinate KZG commitments to a vector of BLS public keys on BLS12-377 represented in affine.
/// @param log_domain_size Determines domain used to interpolate the vectors above.
struct KeysetCommitment {
    Bw6G1[2] pks_comm;
    uint32 log_domain_size;
}

/// @title KeySet
library KeySet {
    using BW6G1Affine for Bw6G1;
    using BLS12G2Affine for bytes;

    /// @dev Serialize KeysetCommitment.
    /// @param self KeysetCommitment.
    /// @return Compressed serialized bytes of KeysetCommitment.
    function serialize(KeysetCommitment memory self) internal pure returns (bytes memory) {
        return abi.encodePacked(
            self.pks_comm[0].serialize(), self.pks_comm[1].serialize(), ByteOrder.reverse32(self.log_domain_size)
        );
    }

    /// @dev Hash commitment to BLS12-377 G2 element.
    /// @param self KeysetCommitment.
    /// @return Bls12G2 point.
    function hash_commitment(KeysetCommitment memory self) internal view returns (Bls12G2 memory) {
        bytes memory buf = serialize(self);
        return buf.hash_to_curve();
    }
}
