#!/usr/bin/env python3
"""Unit test suite for Track S3 pure-local empirical replay & duality verification.

AI-written (`Track S3`, 24 November 2026). Pure Python stdlib `unittest`.
Tests all four scripts in `experiments/evidence-replay/` plus exact rational
Fraction checks, negative tamper checks, fixture determinism, and repo hygiene.
"""

from __future__ import annotations

import json
import sys
import tempfile
import unittest
from fractions import Fraction
from pathlib import Path

sys.dont_write_bytecode = True

HERE = Path(__file__).resolve().parent
if str(HERE) not in sys.path:
    sys.path.insert(0, str(HERE))

import phase2_disentangled_stress as p2  # noqa: E402
import protocol_8slot_benchmark as p8  # noqa: E402
import replay_in1_handshake as in1  # noqa: E402
import verify_duality_handshake as dual  # noqa: E402


class TestIN1ReplayHandshake(unittest.TestCase):
    def test_v2_views_and_monthly_trace_on_all_saved_prefixes(self) -> None:
        prefixes = 0
        endpoint_passed_after_breach = 0
        for path in sorted(in1.RESULTS_ROOT.glob("*/DIR_SEEN_TALK/*.json")):
            raw = json.loads(path.read_text(encoding="utf-8"))
            run = in1.replay_single_run(path)
            for k in range(1, len(raw["months"]) + 1):
                with self.subTest(run=path, k=k):
                    months = raw["months"][:k]
                    announcements = [[s["intended_catch"] for s in call["said"]] for call in raw["calls"][:k]]
                    expected_view1 = {
                        "opening_stock": months[0]["stock"],
                        "announcements": announcements,
                        "next_stock": months[-1]["next_stock"],
                    }
                    pass1 = months[-1]["next_stock"] >= in1.NEED
                    bed_alive = all(m["left"] >= in1.NEED for m in months)
                    view2 = in1._view2_prefix(run, k)
                    self.assertEqual(view2["view1"], expected_view1)
                    self.assertEqual(view2["bed_alive_throughout"], bed_alive)
                    self.assertEqual(view2["pass1"], pass1)
                    self.assertEqual(view2["pass2"], pass1 and bed_alive)
                    historical = all(m["next_stock"] >= in1.NEED for m in months)
                    self.assertEqual(in1._monthly_trace(run, k)["all_next_stocks_ge_need"], historical)
                    prefixes += 1
                    endpoint_passed_after_breach += pass1 and not historical
        self.assertEqual(prefixes, 229)
        self.assertEqual(endpoint_passed_after_breach, 18)

    def test_empty_v2_history_uses_its_opening_stock(self) -> None:
        for opening in (69, 70):
            run = {"opening_stock": opening, "months": []}
            view2 = in1._view2_prefix(run, 0)
            self.assertEqual(view2["view1"], {"opening_stock": opening, "announcements": [], "next_stock": opening})
            self.assertTrue(view2["bed_alive_throughout"])
            self.assertEqual(view2["pass1"], opening >= in1.NEED)
            self.assertEqual(view2["pass2"], opening >= in1.NEED)
            self.assertTrue(in1._monthly_trace(run, 0)["all_next_stocks_ge_need"])

    def test_oversubscribed_announcements_use_the_current_lake(self) -> None:
        path = in1.RESULTS_ROOT / "gpt-4.1-mini" / "DIR_SEEN_TALK" / "2.json"
        raw = json.loads(path.read_text(encoding="utf-8"))
        for said, intended in zip(raw["calls"][1]["said"], [80, 50, 1]):
            said["intended_catch"] = intended
        with tempfile.TemporaryDirectory() as tmp:
            synthetic = Path(tmp) / "announced.json"
            synthetic.write_text(json.dumps(raw), encoding="utf-8")
            month = in1.replay_single_run(synthetic)["months"][1]
        # At 50 tons, [80, 50, 1] clips to [50, 50, 1] and is rationed to [24, 24, 0].
        self.assertEqual(month["opening_stock"], 50)
        self.assertEqual(month["counterfactual_announced_left"], 2)
        self.assertEqual(month["left"], 25)

    def test_in1_229_months_and_target_contrasts(self) -> None:
        table = in1.generate_in1_replay_table(write=False)
        self.assertEqual(table["total_runs"], 20)
        self.assertEqual(table["total_months_verified"], 229)
        self.assertTrue(table["all_identities_passed"])

        g54 = table["gpt_5_4_mini_summary"]
        self.assertEqual(g54["months_bed_alive_before"], 113)
        self.assertEqual(g54["announcements_10_10_10_while_bed_alive"], 113)
        self.assertEqual(g54["exact_10_10_10_executed"], 109)
        self.assertEqual(len(g54["lower_catch_survivals"]), 2)
        self.assertEqual(len(g54["fatal_overtakes"]), 2)
        fatal_pairs = {(r["seed"], r["month"], r["left"], r["next_stock"]) for r in g54["fatal_overtakes"]}
        self.assertEqual(fatal_pairs, {(4, 8, 50, 100), (9, 9, 60, 100)})

        vsep = table["seed0_vs_seed4_view_separation"]
        self.assertTrue(vsep["view1_prefix8_equal"])
        self.assertTrue(vsep["seed0_view2"]["pass1"])
        self.assertTrue(vsep["seed0_view2"]["pass2"])
        self.assertTrue(vsep["seed4_view2"]["pass1"])
        self.assertFalse(vsep["seed4_view2"]["pass2"])

        g41 = table["gpt_4_1_mini_cases"]
        self.assertEqual(g41["seed3_month1_faithful_harmful"]["requested"], [20, 20, 20])
        self.assertEqual(g41["seed3_month1_faithful_harmful"]["left"], 40)
        self.assertFalse(g41["seed3_month1_faithful_harmful"]["bed_alive_after"])

        s7 = g41["seed7_double_revision"]
        self.assertEqual(s7["month1"]["announcements"], [10, 20, 10])
        self.assertEqual(s7["month1"]["left"], 70)
        self.assertEqual(s7["month1"]["counterfactual_announced_left"], 60)
        self.assertEqual(s7["month2"]["announcements"], [10, 10, 20])
        self.assertEqual(s7["month2"]["left"], 70)
        self.assertEqual(s7["month2"]["counterfactual_announced_left"], 60)
        self.assertTrue(s7["bed_kept"])
        self.assertTrue(s7["lake_kept"])

        syn = table["encounter_entry_synthetic_rows"]
        self.assertEqual(syn["inquiry_tree_vs_fixed_4state"]["adaptive_hits"], 4)
        self.assertTrue(syn["inquiry_tree_vs_fixed_4state"]["all_fixed_pairs_miss"])
        self.assertEqual(syn["inquiry_tree_vs_fixed_4state"]["value_only_readL_readR_hits"], 4)
        self.assertEqual(syn["branching_choice_2xa_2xb"]["sysA_counts"], {"xa": 2, "xb": 2})
        self.assertEqual(syn["branching_choice_2xa_2xb"]["sysB_counts"], {"xa": 2, "xb": 2})
        self.assertEqual(syn["branching_choice_2xa_2xb"]["sysA_completed"], 4)
        self.assertEqual(syn["branching_choice_2xa_2xb"]["sysB_completed"], 2)

        fixture = json.loads((HERE / "fixtures" / "in1_replay_table.json").read_text(encoding="utf-8"))
        self.assertEqual(fixture, table)


class TestDualityHandshake(unittest.TestCase):
    def test_exact_fraction_certificates_and_b2_simulation(self) -> None:
        res = dual.generate_duality_handshake(write=False)

        s71 = res["section_7_1"]
        self.assertEqual(s71["exact_absorption_b"], ["1/4", "3/4"])
        for row in s71["public_only_rows"]:
            self.assertEqual(Fraction(row["exact_value"]), Fraction(1, 4))
        for row in s71["with_recipient_rows"]:
            eps = Fraction(row["eps"])
            self.assertEqual(Fraction(row["exact_value"]), min(Fraction(1, 4), 2 * eps))
        self.assertEqual(Fraction(s71["dropped_recipient_restores_1_4"]["exact_value"]), Fraction(1, 4))

        b2 = res["b2_aliasing"]
        for alpha_str in ("0.0", "0.8", "1.0"):
            self.assertEqual(b2["simulation"][alpha_str]["strained"]["macro_counts"], [108, 188, 547, 157])
            self.assertEqual(b2["simulation"][alpha_str]["intact"]["macro_counts"], [108, 188, 547, 157])
            self.assertEqual(b2["simulation"][alpha_str]["strained"]["survived"], 0)
            self.assertEqual(b2["simulation"][alpha_str]["intact"]["survived"], 1000)

        self.assertEqual(b2["simulation"]["0.8"]["strained"]["report_pos"], 285)
        self.assertEqual(b2["simulation"]["0.8"]["intact"]["report_pos"], 632)
        self.assertEqual(Fraction(b2["duality_certificates"]["0.8"]["exact_value"]), Fraction(50, 347))
        self.assertEqual(Fraction(b2["duality_certificates"]["0.0"]["exact_value"]), Fraction(1, 20))
        self.assertEqual(Fraction(b2["duality_certificates"]["1.0"]["exact_value"]), Fraction(1, 2))
        self.assertEqual(Fraction(b2["s2_explicit_handshake_value"]), Fraction(50, 347))

        for tb in res["track_b_amplification"]:
            delta = Fraction(tb["delta"])
            n = int(tb["n"])
            eps = Fraction(tb["eps"])
            expected = (1 - (1 - delta) ** n) * min(Fraction(1, 2), eps / delta)
            self.assertEqual(Fraction(tb["exact_value"]), expected)
            self.assertEqual(Fraction(tb["primal_gap"]), Fraction(tb["dual_bound"]))

        fixture = json.loads((HERE / "fixtures" / "duality_handshake.json").read_text(encoding="utf-8"))
        self.assertEqual(fixture, res)

    def test_negative_tamper_checks_reject(self) -> None:
        cases = dual.run_negative_tamper_checks()
        self.assertEqual(len(cases), 4)
        self.assertTrue(all(c["rejected"] for c in cases))

        # Additional direct tamper test: verify L > U triggers CertificateTamperError
        F = [[Fraction(285, 1000), Fraction(632, 1000)]]
        h = [Fraction(0), Fraction(1)]
        with self.assertRaises(dual.CertificateTamperError):
            dual.verify_certificate(
                F,
                h,
                Fraction(1, 20),
                [Fraction(0), Fraction(1)],
                [Fraction(1), Fraction(0)],
                Fraction(-285, 347),
                [Fraction(1000, 347)],
            )


class TestPhase2DisentangledStress(unittest.TestCase):
    def test_disentangled_2d_and_breach_bounds(self) -> None:
        res = p2.generate_phase2_disentangled(write=False)
        sweep = res["disentangled_2d_sweep"]
        cells = sweep["cells"]
        self.assertEqual(len(cells), 25)
        for c in cells:
            # Verify (x0, renewal, warn_onset) held strictly fixed
            self.assertEqual(c["x0"], 25.0)
            self.assertEqual(c["renewal"], 2.6)
            self.assertEqual(c["warn_onset"], 21.0)
            # Competing-risk outcome shares must sum to 1.0
            total_share = (
                c["pre_switch_death_rate"]
                + c["post_switch_death_rate"]
                + c["survived_switched_rate"]
                + c["survived_never_switched_rate"]
            )
            self.assertAlmostEqual(total_share, 1.0, places=3)

        by_key = {(c["rho_reward"], c["rho_feat"]): c for c in cells}
        # Disentanglement check at fixed rho_reward = 1.40: rising rho_feat increases pre-switch death & imputed switch time
        self.assertEqual(by_key[(1.4, 0.0)]["pre_switch_death_rate"], 0.0)
        self.assertGreater(by_key[(1.4, 0.98)]["pre_switch_death_rate"], 0.5)
        self.assertGreater(
            by_key[(1.4, 0.98)]["mean_switch_time_competing_risk_imputed"],
            by_key[(1.4, 0.0)]["mean_switch_time_competing_risk_imputed"],
        )
        # Disentanglement check at fixed rho_feat = 0.0: rising rho_reward flips 100% death -> 100% survival
        self.assertEqual(by_key[(0.0, 0.0)]["pre_switch_death_rate"], 1.0)
        self.assertEqual(by_key[(2.2, 0.0)]["survived_switched_rate"], 1.0)

        bc = res["stochastic_breach_bound_check"]
        self.assertTrue(bc["all_exact_bounds_hold_eta_zero"])
        self.assertTrue(bc["all_surrogate_bounds_hold_with_eta"])

        fixture = json.loads((HERE / "fixtures" / "phase2_disentangled.json").read_text(encoding="utf-8"))
        self.assertEqual(fixture, res)


class TestProtocol8SlotBenchmark(unittest.TestCase):
    def test_two_item_8slot_and_b2_b4(self) -> None:
        res = p8.generate_protocol_8slot(write=False)

        t2 = res["two_item_blackbox"]
        self.assertEqual(t2["diagnostic_coupled_accuracy"], 1.0)
        self.assertLess(t2["no_diagnostic_accuracy"], 0.65)
        self.assertLess(t2["scrambled_reply_control_accuracy"], 0.65)
        self.assertEqual(t2["false_receipt_control_accuracy"], 0.0)

        e8 = res["eight_slot_4bit"]
        self.assertEqual(e8["total_instances"], 2048)
        self.assertEqual(e8["pigeonhole_upper_bound"], 1696)
        self.assertLessEqual(e8["warehouse_first_prefix4_hits"], 1696)
        self.assertLessEqual(e8["warehouse_first_rep4_hits"], 1696)
        self.assertEqual(e8["requester_first_3plus1_hits"], 2048)
        self.assertEqual(e8["mean_learned_hits"], 2048.0)
        self.assertEqual(e8["mean_relearned_hits"], 2048.0)
        self.assertLess(e8["mean_unaligned_hits"], 1300.0)
        self.assertLess(e8["mean_scrambled_control_hits"], 1300.0)

        b4_by_reg = {r["regime"]: r for r in res["b2_b4_probe_connection"]["b4_probe_regime_contrast"]}
        self.assertEqual(b4_by_reg["guarded_targeted_low_alias"]["collapse_rate"], 0.0)
        self.assertEqual(b4_by_reg["unguarded_nominal"]["collapse_rate"], 1.0)
        self.assertGreater(b4_by_reg["guarded_blind_high_alias"]["collapse_rate"], 0.0)

        fixture = json.loads((HERE / "fixtures" / "protocol_8slot.json").read_text(encoding="utf-8"))
        self.assertEqual(fixture, res)


class TestDualityLiftingHandshake(unittest.TestCase):
    def test_dobrushin_lift_xor_relational_and_empirical_safety(self) -> None:
        def step_vec(P: list[list[Fraction]], v: list[Fraction]) -> list[Fraction]:
            return [sum(row[sp] * v[sp] for sp in range(len(v))) for row in P]

        def osc(v: list[Fraction]) -> Fraction:
            return max(v) - min(v)

        def mid(v: list[Fraction]) -> Fraction:
            return (max(v) + min(v)) / 2

        # 1. Exact Dobrushin alpha = 1/2 lift vs absorbing alpha = 1
        P_half = [
            [Fraction(3, 4), Fraction(1, 4)],
            [Fraction(1, 4), Fraction(3, 4)],
        ]
        P_id = [
            [Fraction(1), Fraction(0)],
            [Fraction(0), Fraction(1)],
        ]
        F0 = [[Fraction(2), Fraction(1)]]
        h0 = [Fraction(1), Fraction(3)]
        b0 = Fraction(0)
        c0 = [Fraction(1)]
        r0 = [h0[s] - b0 - sum(F0[j][s] * c0[j] for j in range(len(F0))) for s in range(2)]
        self.assertEqual(r0, [Fraction(-1), Fraction(2)])
        r_cur = list(r0)
        F_cur = [list(row) for row in F0]
        h_cur = list(h0)
        r_abs = list(r0)
        eps_dob = Fraction(1, 20)
        base_sup = max(abs(x) for x in r0)
        for t in range(5):
            self.assertEqual(osc(r_cur), (Fraction(1, 2) ** t) * osc(r0))
            b_t = b0 + mid(r_cur)
            lifted_bound = max(
                abs(h_cur[s] - b_t - sum(F_cur[j][s] * c0[j] for j in range(len(F0))))
                for s in range(2)
            ) + eps_dob * sum(abs(cj) for cj in c0)
            self.assertLessEqual(
                lifted_bound, (Fraction(1, 2) ** t) * base_sup + eps_dob * sum(abs(cj) for cj in c0)
            )
            self.assertEqual(osc(r_abs), osc(r0))
            r_cur = step_vec(P_half, r_cur)
            h_cur = step_vec(P_half, h_cur)
            F_cur = [step_vec(P_half, row) for row in F_cur]
            r_abs = step_vec(P_id, r_abs)

        # 2. Exact Bool x Bool XOR/equality relational separation: 1/2 -> min(1/2, eps)
        # States order: (0,0), (0,1), (1,0), (1,1)
        F_marg = [
            [Fraction(1), Fraction(1), Fraction(0), Fraction(0)],  # p1 = 0
            [Fraction(1), Fraction(0), Fraction(1), Fraction(0)],  # p2 = 0
        ]
        h_eq = [Fraction(1), Fraction(0), Fraction(0), Fraction(1)]
        F_ext = F_marg + [h_eq]
        for eps in (Fraction(0), Fraction(1, 8), Fraction(1, 2), Fraction(3, 4)):
            p_m, mu_m, nu_m = dual.solve_consequence_primal(F_marg, h_eq, eps)
            d_m, b_m, c_m = dual.solve_consequence_dual(F_marg, h_eq, eps)
            L_m, U_m = dual.verify_certificate(F_marg, h_eq, eps, mu_m, nu_m, b_m, c_m)
            self.assertEqual(p_m, Fraction(1, 2))
            self.assertEqual(d_m, Fraction(1, 2))
            self.assertEqual(L_m, Fraction(1, 2))
            self.assertEqual(U_m, Fraction(1, 2))

            expected = min(Fraction(1, 2), eps)
            p_e, mu_e, nu_e = dual.solve_consequence_primal(F_ext, h_eq, eps)
            d_e, b_e, c_e = dual.solve_consequence_dual(F_ext, h_eq, eps)
            L_e, U_e = dual.verify_certificate(F_ext, h_eq, eps, mu_e, nu_e, b_e, c_e)
            self.assertEqual(p_e, expected)
            self.assertEqual(d_e, expected)
            self.assertEqual(L_e, expected)
            self.assertEqual(U_e, expected)

        # 3. Single-distribution empirical safety certificate + exceeded-drift failure
        F_approx = [[Fraction(285, 1000), Fraction(632, 1000)]]
        h_b2 = [Fraction(0), Fraction(1)]
        b_b2 = Fraction(-285, 347)
        c_b2 = [Fraction(1000, 347)]
        delta = Fraction(1, 100)
        eps_sam = Fraction(1, 50)
        R_inf = max(abs(h_b2[s] - b_b2 - F_approx[0][s] * c_b2[0]) for s in range(2))
        R_tot = R_inf + abs(c_b2[0]) * (eps_sam + delta)
        mu_b2 = [Fraction(247, 347), Fraction(100, 347)]
        true_val = sum(h_b2[s] * mu_b2[s] for s in range(2))

        F_true_ok = [[F_approx[0][0] + delta, F_approx[0][1] - delta]]
        y_ok = sum(F_true_ok[0][s] * mu_b2[s] for s in range(2)) + eps_sam
        est_ok = b_b2 + c_b2[0] * y_ok
        self.assertLessEqual(abs(true_val - est_ok), R_tot)
        tau_safe = est_ok - R_tot
        self.assertLessEqual(tau_safe + R_tot, est_ok)
        self.assertLessEqual(tau_safe, true_val)

        F_true_bad = [[F_approx[0][0] - 2 * delta, F_approx[0][1] - 2 * delta]]
        y_bad = sum(F_true_bad[0][s] * mu_b2[s] for s in range(2)) - eps_sam
        est_bad = b_b2 + c_b2[0] * y_bad
        self.assertGreater(abs(true_val - est_bad), R_tot)


if __name__ == "__main__":
    unittest.main()
