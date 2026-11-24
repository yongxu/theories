#!/usr/bin/env python3
"""Unit test suite for Track S3 pure-local empirical replay & duality verification.

AI-written (`Track S3`, 24 November 2026). Pure Python stdlib `unittest`.
Tests all four scripts in `experiments/evidence-replay/` plus exact rational
Fraction checks, negative tamper checks, fixture determinism, and repo hygiene.
"""

from __future__ import annotations

import json
import sys
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


if __name__ == "__main__":
    unittest.main()
