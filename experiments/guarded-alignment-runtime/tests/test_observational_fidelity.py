"""Unit tests for guarded_alignment.observational_fidelity (exact Fraction O1, G.2, G.3a/b, split)."""

from __future__ import annotations

import unittest
from fractions import Fraction

from guarded_alignment.observational_fidelity import (
    FidelityError,
    FinDist,
    FinKernel,
    QuerySpec,
    check_coarsening,
    check_fiber_viability_split,
    check_macro_refinement,
    check_multi_query_feasibility,
    contractive_tube_bound,
    iter_kernel,
    mass_outside,
    metric_slack,
    pushforward,
    query_tv_floor,
    tensor_kernel,
    tv_dist,
)


class TestObservationalFidelity(unittest.TestCase):
    def test_findist_exact_validation_and_data_processing(self) -> None:
        with self.assertRaises(FidelityError):
            FinDist.from_mapping({"a": 0.5, "b": 0.5})  # type: ignore[arg-type]
        with self.assertRaises(FidelityError):
            FinDist.from_mapping({"a": "2/3", "b": "2/3"})

        mu = FinDist.from_mapping({"a": "1/2", "b": "1/4", "c": "1/4"})
        nu = FinDist.from_mapping({"a": "1/4", "b": "1/2", "c": "1/4"})
        g = {"a": "x", "b": "x", "c": "y"}
        self.assertLessEqual(tv_dist(pushforward(g, mu), pushforward(g, nu)), tv_dist(mu, nu))
        self.assertEqual(tv_dist(mu, nu), Fraction(1, 4))

    def test_o1_g1_query_tv_floor_and_empty_carrier(self) -> None:
        mu = FinDist.from_mapping({"v0": "1/2", "v1": "1/3", "v2": "1/6"})
        chi = {"u0": "v0", "u1": "v1"}
        q = {"v0": "o0", "v1": "o1", "v2": "o2"}
        rep = query_tv_floor(chi, q, mu, src_carrier=("u0", "u1"))
        self.assertTrue(rep.feasible)
        self.assertEqual(rep.floor, Fraction(1, 6))
        self.assertEqual(rep.attained_tv, Fraction(1, 6))
        self.assertEqual(rep.outside_observations, ("o2",))
        self.assertEqual(mass_outside({"u0": "o0", "u1": "o1"}, pushforward(q, mu), ("u0", "u1")),
                         Fraction(1, 6))

        # Empty local carrier is infeasible (empty_source_infeasible)
        rep_empty = query_tv_floor({}, q, mu, src_carrier=())
        self.assertFalse(rep_empty.feasible)
        self.assertIsNone(rep_empty.attaining_nu)

    def test_coarsening_and_macro_refinement_monotonicity(self) -> None:
        mu = FinDist.from_mapping({"v0": "1/2", "v1": "1/2"})
        chi = {"u0": "v0"}
        q_fine = {"v0": "o0", "v1": "o1"}
        coarsen = {"o0": "all", "o1": "all"}
        crep = check_coarsening(chi, q_fine, coarsen, mu, src_carrier=("u0",))
        self.assertTrue(crep.monotone_holds)
        self.assertTrue(crep.conceals_blindness)
        self.assertEqual(crep.fine_floor, Fraction(1, 2))
        self.assertEqual(crep.coarse_floor, Fraction(0))
        self.assertEqual(crep.concealed_gap, Fraction(1, 2))

        mrep = check_macro_refinement(
            refine_map={"c0": "f0"},
            chi_fine={"f0": "v0", "f1": "v1"},
            q=q_fine,
            mu=mu,
            coarse_carrier=("c0",),
            fine_carrier=("f0", "f1"),
        )
        self.assertTrue(mrep.monotone_holds)
        self.assertEqual(mrep.coarse_floor, Fraction(1, 2))
        self.assertEqual(mrep.fine_floor, Fraction(0))

    def test_g3a_and_g3b_exact_rational_multi_query_separation(self) -> None:
        diag = ((False, False), (True, True))
        q_fst = {(False, False): False, (True, True): True}
        q_snd = {(False, False): False, (True, True): True}

        # G.3a: per-query TV=0, simultaneous min TV sum = 3/5
        r_g3a = check_multi_query_feasibility(
            src_carrier=diag,
            queries=[
                QuerySpec("fst", q_fst, FinDist.from_mapping({False: "4/5", True: "1/5"})),
                QuerySpec("snd", q_snd, FinDist.from_mapping({False: "1/5", True: "4/5"})),
            ],
        )
        self.assertTrue(r_g3a.per_query_realizable)
        self.assertFalse(r_g3a.simultaneous_realizable)
        self.assertEqual(r_g3a.simultaneous_min_tv_sum, Fraction(3, 5))
        self.assertEqual(r_g3a.regime, "G3A_PER_QUERY_VS_SIMULTANEOUS_SEPARATION")

        # G.3b: simultaneous marginal TV=0, joint TV floor = 1/2
        unif_pair = FinDist.uniform([(a, b) for a in (False, True) for b in (False, True)])
        fair = FinDist.uniform([False, True])
        r_g3b = check_multi_query_feasibility(
            src_carrier=diag,
            queries=[QuerySpec("fst", q_fst, fair), QuerySpec("snd", q_snd, fair)],
            joint_chi={x: x for x in diag},
            joint_target=unif_pair,
        )
        self.assertTrue(r_g3b.per_query_realizable)
        self.assertTrue(r_g3b.simultaneous_realizable)
        self.assertEqual(r_g3b.simultaneous_min_tv_sum, Fraction(0))
        self.assertFalse(r_g3b.joint_realizable)
        self.assertEqual(r_g3b.joint_min_tv, Fraction(1, 2))
        self.assertEqual(r_g3b.regime, "G3B_SIMULTANEOUS_MARGINAL_VS_JOINT_SEPARATION")

    def test_zero_tv_coexists_with_fiber_viability_split(self) -> None:
        states = [((True, True), 1), ((True, False), 1)]
        proj = {s: s[1] for s in states}
        viable = {((True, True), 1): True, ((True, False), 1): False}
        frep = check_fiber_viability_split(proj, viable, states)
        self.assertTrue(frep.has_split)
        self.assertEqual(frep.projected_tv, Fraction(0))
        self.assertIn("ZERO_TV_FIBER_VIABILITY_SPLIT", frep.warning)

    def test_markov_kernels_and_contractive_tube_bounds(self) -> None:
        car = (0, 1)
        k = FinKernel(
            car,
            car,
            {
                0: FinDist.from_mapping({0: "9/10", 1: "1/10"}),
                1: FinDist.from_mapping({0: "1/10", 1: "9/10"}),
            },
        )
        l = FinKernel(
            car,
            car,
            {
                0: FinDist.from_mapping({0: "4/5", 1: "1/5"}),
                1: FinDist.from_mapping({0: "1/5", 1: "4/5"}),
            },
        )
        eps = k.max_tv_diff(l)
        self.assertEqual(eps, Fraction(1, 10))
        p0 = FinDist.dirac(car, 0)
        for n in range(1, 6):
            self.assertLessEqual(tv_dist(iter_kernel(k, n, p0), iter_kernel(l, n, p0)), n * eps)

        tk = tensor_kernel(k, k)
        tl = tensor_kernel(l, l)
        self.assertLessEqual(tk.max_tv_diff(tl), eps + eps)

        alpha, r0 = Fraction(1, 2), Fraction(1, 5)
        bound = contractive_tube_bound(alpha, eps, r0)
        self.assertEqual(bound, Fraction(1, 5))
        for m in range(10):
            self.assertLessEqual(metric_slack(alpha, eps, m, r0), bound)


if __name__ == "__main__":
    unittest.main()
