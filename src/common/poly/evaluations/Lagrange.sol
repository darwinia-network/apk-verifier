// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "../domain/Radix2.sol";
import "../../bw6761/Fr.sol";
import "../../Bitmask.sol";

/// @dev Values of the polynomials at a point z
/// @param vanishing_polynomial z^n - 1
/// @param l_first L_0(z)
/// @param l_last L_{n-1}(z)
/// @param zeta_minus_omega_inv z - \omega^{-1}
/// @param zeta_omega z * ω
struct LagrangeEvaluations {
    Bw6Fr vanishing_polynomial;
    Bw6Fr l_first;
    Bw6Fr l_last;
    Bw6Fr zeta_minus_omega_inv;
    Bw6Fr zeta_omega;
}

/// @title Lagrange
library Lagrange {
    using BW6FR for Bw6Fr;
    using BW6FR for Bw6Fr[];
    using BitMask for Bitmask;

    /// @dev Lagrange evaluations.
    function lagrange_evaluations(Bw6Fr memory z, Radix2EvaluationDomain memory dm)
        internal
        view
        returns (LagrangeEvaluations memory)
    {
        Bw6Fr memory z_n = z;
        for (uint256 i = 0; i < dm.log_size_of_group; i++) {
            z_n = z_n.square();
        }

        Bw6Fr memory z_n_minus_one = z_n.sub(BW6FR.one());
        Bw6Fr memory z_n_minus_one_div_n = z_n_minus_one.mul(dm.size_inv);

        Bw6Fr memory inv_first = z.sub(BW6FR.one());
        Bw6Fr memory inv_last = dm.group_gen.mul(z).sub(BW6FR.one());
        inv_first.inverse();
        inv_last.inverse();

        return LagrangeEvaluations({
            vanishing_polynomial: z_n_minus_one,
            l_first: z_n_minus_one_div_n.mul(inv_first),
            l_last: z_n_minus_one_div_n.mul(inv_last),
            zeta_minus_omega_inv: z.sub(dm.group_gen_inv),
            zeta_omega: z.mul(dm.group_gen)
        });
    }

    function barycentric_eval_binary_at(Bw6Fr memory z, Bitmask memory evals, Radix2EvaluationDomain memory dm)
        internal
        view
        returns (Bw6Fr memory)
    {
        Bw6Fr memory z_n = z;
        for (uint256 i = 0; i < dm.log_size_of_group; i++) {
            z_n = z_n.square();
        }
        Bw6Fr memory z_n_minus_one = z_n.sub(BW6FR.one());
        Bw6Fr memory z_n_minus_one_div_n = z_n_minus_one.mul(dm.size_inv);

        uint256 N = evals.count_ones();
        Bw6Fr[] memory li_inv = new Bw6Fr[](N);
        Bw6Fr memory acc = z;

        Bw6Fr memory one = BW6FR.one();
        uint256 size = evals.size();
        uint256 c = 0;
        for (uint256 i = 0; i < size; i++) {
            bool b = evals.at(i);
            if (b) {
                li_inv[c] = acc.sub(one);
                li_inv[c].inverse();
                c++;
            }
            acc = acc.mul(dm.group_gen_inv);
        }

        Bw6Fr memory s = li_inv.sum();

        return z_n_minus_one_div_n.mul(s);
    }
}
