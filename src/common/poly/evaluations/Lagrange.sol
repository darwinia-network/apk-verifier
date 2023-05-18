pragma solidity ^0.8.17;

import "../domain/Radix2.sol";
import "../../bw6761/Fr.sol";

/// Values of the polynomials at a point z
struct LagrangeEvaluations {
    Bw6Fr vanishing_polynomial; // z^n - 1
    Bw6Fr l_first;              // L_0(z)
    Bw6Fr l_last;               // L_{n-1}(z)
    Bw6Fr zeta_minus_omega_inv; // z - \omega^{-1}
    Bw6Fr zeta_omega;           // z * \omega
}

library Lagrange {
    using BW6FR for Bw6Fr;

    function lagrange_evaluations(
        Bw6Fr memory z,
        Radix2EvaluationDomain memory dm
    ) internal pure returns (
        LagrangeEvaluations memory evals_at_zeta
    ) {
        Bw6Fr memory z_n = z;
        for (uint i = 0; i < dm.log_size_of_group; i++) {
            z_n = z_n.square();
        }

        Bw6Fr memory z_n_minus_one = z_n.sub(BW6FR.one());
        Bw6Fr memory z_n_minus_one_dev_n = z_n_minus_one.mul(dm.size_inv);

    }
}