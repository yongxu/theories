"""Unit, sharpness-countermodel, and CLI tests for the 5-test alignment proposal grammar."""

from __future__ import annotations

import contextlib
import io
import json
import tempfile
import unittest
from pathlib import Path

from guarded_alignment import (
    FidelityError,
    Verdict,
    check_concurrent_reserve,
    check_coupling_closure,
    check_pace_margin_deadline,
    check_proposal_fiber_split,
    check_self_refit_lock,
    check_survival_distinguishability,
    evaluate_alignment_proposal,
    evaluate_pipeline_spec,
    run_builtin_example,
)
from guarded_alignment.cli import main as cli_main


class TestProposalAuditGrammar(unittest.TestCase):
    def test_coupling_closure_obstruction_and_open_healing(self) -> None:
        obstructed = check_coupling_closure(
            {
                "sustained_substrates": ["accuracy", "human_trust"],
                "read_substrates": ["accuracy"],
                "closed_interface": True,
                "draw_rates": {"human_trust": "1/2"},
            }
        )
        self.assertEqual(obstructed.verdict, Verdict.OBSTRUCTED)
        self.assertEqual(obstructed.missing_guard, "widen_interface_to_sustained_substrates")
        self.assertEqual(obstructed.witness["unread_substrates"], ["human_trust"])

        closed_even_when_all_read = check_coupling_closure(
            {
                "sustained_substrates": ["accuracy", "human_trust"],
                "read_substrates": ["accuracy", "human_trust"],
                "closed_interface": True,
            }
        )
        self.assertEqual(closed_even_when_all_read.verdict, Verdict.OBSTRUCTED)

        healed = check_coupling_closure(
            {
                "sustained_substrates": ["accuracy", "human_trust"],
                "read_substrates": ["accuracy", "human_trust"],
                "closed_interface": False,
            }
        )
        self.assertEqual(healed.verdict, Verdict.GUARDED)
        self.assertIsNone(healed.missing_guard)

    def test_self_refit_lock_exhaustion_and_meta_target_capture(self) -> None:
        locked = check_self_refit_lock(
            {
                "self_refit": True,
                "external_reset_active": False,
                "external_reset_channels": [],
                "draw_per_step": "3/2",
                "reserve_margin": "5",
            }
        )
        self.assertEqual(locked.verdict, Verdict.OBSTRUCTED)
        self.assertEqual(locked.missing_guard, "external_disturbance_reset_outside_favored_share")
        self.assertEqual(locked.witness["steps_to_exhaustion"], 4)

        meta_captured = check_self_refit_lock(
            {
                "self_refit": False,
                "external_reset_active": True,
                "external_reset_channels": ["human_audit"],
                "draw_per_step": "0",
                "reserve_margin": "5",
                "shaping_becomes_target": True,
            }
        )
        self.assertEqual(meta_captured.verdict, Verdict.OBSTRUCTED)
        self.assertEqual(meta_captured.missing_guard, "separate_selection_shaping_from_target")

        open_loop = check_self_refit_lock(
            {
                "self_refit": False,
                "external_reset_active": True,
                "external_reset_channels": ["human_dissent_channel"],
                "draw_per_step": "1/4",
                "reserve_margin": "5",
                "shaping_becomes_target": False,
            }
        )
        self.assertEqual(open_loop.verdict, Verdict.GUARDED)

    def test_fiber_split_zero_tv_and_coarsening_concealment(self) -> None:
        split_item = check_proposal_fiber_split(
            {
                "states": ["safe", "hollow"],
                "proj_map": {"safe": "ok", "hollow": "ok"},
                "viable_pred": {"safe": True, "hollow": False},
            }
        )
        self.assertEqual(split_item.verdict, Verdict.OBSTRUCTED)
        self.assertTrue(split_item.witness["has_split"])
        self.assertEqual(str(split_item.witness["projected_tv"]), "0")

        coarsened = check_proposal_fiber_split(
            {
                "states": ["safe_a", "safe_b"],
                "proj_map": {"safe_a": "fine_1", "safe_b": "fine_2"},
                "viable_pred": {"safe_a": True, "safe_b": True},
                "fine_query_map": {"safe_a": "good", "safe_b": "bad"},
                "coarsen_map": {"good": "ok", "bad": "ok"},
                "fine_state_dist": {"safe_a": "1/2", "safe_b": "1/2"},
                "fine_src_carrier": ["only_a"],
                "fine_chi_map": {"only_a": "safe_a"},
            }
        )
        self.assertEqual(coarsened.verdict, Verdict.OBSTRUCTED)
        self.assertEqual(coarsened.missing_guard, "preserve_fine_multi_query_separation")
        self.assertTrue(coarsened.witness["coarsening"]["conceals_blindness"])
        self.assertEqual(str(coarsened.witness["coarsening"]["concealed_gap"]), "1/2")

    def test_pace_margin_deadline_bounds_and_impossibility(self) -> None:
        aliased = check_pace_margin_deadline(
            {
                "lag": 4,
                "n_rules": 3,
                "initial_reserve": "50",
                "critical_threshold": "1",
                "pre_response_draw": "1",
                "post_response_draw": "1",
            }
        )
        self.assertEqual(aliased.verdict, Verdict.OBSTRUCTED)
        self.assertFalse(aliased.witness["aliasing_ok"])

        unrecoverable = check_pace_margin_deadline(
            {
                "lag": 5,
                "n_rules": 3,
                "initial_reserve": "10",
                "critical_threshold": "2",
                "terminal_buffer": "1",
                "pre_response_draw": "2",
                "post_response_draw": "2",
                "paced_renewal": "1/2",
            }
        )
        self.assertEqual(unrecoverable.verdict, Verdict.OBSTRUCTED)
        self.assertTrue(unrecoverable.witness["unrecoverable_cadence"])
        self.assertEqual(str(unrecoverable.witness["impossibility_bound"]), "25/2")
        self.assertEqual(str(unrecoverable.witness["feasibility_bound"]), "17")

        feasible = check_pace_margin_deadline(
            {
                "lag": 5,
                "n_rules": 3,
                "initial_reserve": "20",
                "critical_threshold": "2",
                "terminal_buffer": "1",
                "pre_response_draw": "2",
                "post_response_draw": "2",
                "paced_renewal": "1",
                "intra_span_drop": "2",
            }
        )
        self.assertEqual(feasible.verdict, Verdict.GUARDED)
        self.assertTrue(feasible.witness["window_feasible"])
        self.assertTrue(feasible.witness["fine_kernel_ok"])

        single_rule = check_pace_margin_deadline(
            {
                "lag": 2,
                "n_rules": 1,
                "initial_reserve": "2",
                "critical_threshold": "2",
                "terminal_buffer": "1",
                "pre_response_draw": "2",
                "post_response_draw": "2",
                "paced_renewal": "0",
            }
        )
        self.assertEqual(single_rule.verdict, Verdict.OBSTRUCTED)
        self.assertFalse(single_rule.witness["unrecoverable_cadence"])
        self.assertTrue(single_rule.witness["impossibility_premise_h1_le_floor"])

    def test_concurrent_reserve_race_vs_reciprocal_gate(self) -> None:
        raced = check_concurrent_reserve(
            {
                "n_agents": 2,
                "shared_reserve": "3",
                "min_viable_reserve": "1",
                "single_agent_draw": "1",
                "concurrent_draw": "2",
                "renewal_per_step": "1",
                "serialized_or_gated": False,
                "observe_relative_phase": False,
            }
        )
        self.assertEqual(raced.verdict, Verdict.OBSTRUCTED)
        self.assertTrue(raced.witness["individually_safe"])
        self.assertEqual(raced.witness["steps_to_breach"], 3)
        self.assertFalse(raced.witness["c2_universal_bc_holds"])
        self.assertEqual(raced.witness["c2_domain_size"], 2)
        self.assertEqual(raced.witness["c2_codomain_size"], 1)

        gated = check_concurrent_reserve(
            {
                "n_agents": 2,
                "shared_reserve": "3",
                "min_viable_reserve": "1",
                "single_agent_draw": "1",
                "concurrent_draw": "2",
                "serialized_draw": "1",
                "renewal_per_step": "1",
                "serialized_or_gated": True,
                "observe_relative_phase": True,
            }
        )
        self.assertEqual(gated.verdict, Verdict.GUARDED)
        self.assertIsNone(gated.missing_guard)

    def test_six_builtin_proposal_diagnostics_isolate_failures(self) -> None:
        rlhf = run_builtin_example("proposal_rlhf_one_pass")
        self.assertEqual(rlhf.verdict, Verdict.OBSTRUCTED)
        self.assertEqual(len(rlhf.checks), 5)
        by_label_rlhf = {c.label: c.verdict for c in rlhf.checks}
        self.assertEqual(by_label_rlhf["coupling_closure"], Verdict.OBSTRUCTED)
        self.assertEqual(by_label_rlhf["zero_tv_fiber_split"], Verdict.OBSTRUCTED)
        self.assertEqual(by_label_rlhf["self_refit_lock"], Verdict.GUARDED)

        rlaif = run_builtin_example("proposal_rlaif_self_refit")
        self.assertEqual(rlaif.verdict, Verdict.OBSTRUCTED)
        by_label_rlaif = {c.label: c.verdict for c in rlaif.checks}
        self.assertEqual(by_label_rlaif["self_refit_lock"], Verdict.OBSTRUCTED)

        cai = run_builtin_example("proposal_constitutional_ai_closed")
        self.assertEqual(cai.verdict, Verdict.OBSTRUCTED)
        by_label_cai = {c.label: c.verdict for c in cai.checks}
        self.assertEqual(by_label_cai["coupling_closure"], Verdict.OBSTRUCTED)
        self.assertEqual(by_label_cai["zero_tv_fiber_split"], Verdict.OBSTRUCTED)

        oversight = run_builtin_example("proposal_scalable_oversight_lagged")
        self.assertEqual(oversight.verdict, Verdict.OBSTRUCTED)
        obstructed_oversight = [c.label for c in oversight.checks if c.verdict == Verdict.OBSTRUCTED]
        self.assertEqual(obstructed_oversight, ["pace_margin_deadline"])

        multi_agent = run_builtin_example("proposal_multi_agent_governance_unserialized")
        self.assertEqual(multi_agent.verdict, Verdict.OBSTRUCTED)
        obstructed_ma = [c.label for c in multi_agent.checks if c.verdict == Verdict.OBSTRUCTED]
        self.assertEqual(obstructed_ma, ["concurrent_reserve"])

        open_al = run_builtin_example("proposal_guarded_open_alignment")
        self.assertEqual(open_al.verdict, Verdict.GUARDED)
        self.assertEqual([c.verdict for c in open_al.checks], [Verdict.GUARDED] * 6)

        sw_blind = run_builtin_example("proposal_finite_mode_switching_blind")
        self.assertEqual(sw_blind.verdict, Verdict.OBSTRUCTED)
        self.assertEqual(sw_blind.checks[0].label, "survival_distinguishability")
        self.assertEqual(
            sw_blind.checks[0].missing_guard, "enable_mode_switching_probes_up_to_krylov_horizon"
        )

    def test_survival_distinguishability_krylov_countdown_and_switching(self) -> None:
        indist = check_survival_distinguishability(
            {
                "states": ["a", "b", "c"],
                "state_a": "a",
                "state_b": "b",
                "modes": {
                    "m": {
                        "a": {"c": "1"},
                        "b": {"c": "1"},
                        "c": {"c": "1"},
                    }
                },
            }
        )
        self.assertEqual(indist.verdict, Verdict.OBSTRUCTED)
        self.assertTrue(indist.witness["indistinguishable_all_horizons"])
        self.assertEqual(indist.witness["krylov_cutoff"], 2)

        countdown_short = check_survival_distinguishability(
            {
                "states": ["s0", "s1", "s2", "s3"],
                "state_a": "s0",
                "state_b": "s1",
                "modes": {
                    "step": {
                        "s0": {"s1": "1"},
                        "s1": {"s2": "1"},
                        "s2": {"s3": "1"},
                        "s3": {},
                    }
                },
                "audit_horizon": 2,
            }
        )
        self.assertEqual(countdown_short.verdict, Verdict.OBSTRUCTED)
        self.assertEqual(countdown_short.witness["shortest_separating_horizon"], 3)

        countdown_exact = check_survival_distinguishability(
            {
                "states": ["s0", "s1", "s2", "s3"],
                "state_a": "s0",
                "state_b": "s1",
                "modes": {
                    "step": {
                        "s0": {"s1": "1"},
                        "s1": {"s2": "1"},
                        "s2": {"s3": "1"},
                        "s3": {},
                    }
                },
                "audit_horizon": 3,
            }
        )
        self.assertEqual(countdown_exact.verdict, Verdict.GUARDED)
        self.assertEqual(countdown_exact.witness["krylov_cutoff"], 3)

        switched = check_survival_distinguishability(
            {
                "states": ["s0", "s1", "s2"],
                "state_a": "s0",
                "state_b": "s1",
                "modes": {
                    "A": {"s0": {"s0": "1"}, "s1": {"s2": "1"}, "s2": {"s2": "1"}},
                    "B": {"s0": {"s0": "1"}, "s1": {"s1": "1"}, "s2": {}},
                },
                "audit_horizon": 2,
                "allow_mode_switching": True,
            }
        )
        self.assertEqual(switched.verdict, Verdict.GUARDED)
        self.assertEqual(switched.witness["shortest_separating_word"], ["A", "B"])
        self.assertIsNone(switched.witness["constant_mode_separating_word"])

        c2_sep = check_survival_distinguishability(
            {
                "states": ["in_phase", "anti_phase"],
                "state_a": "in_phase",
                "state_b": "anti_phase",
                "modes": {"step": {"in_phase": {"in_phase": "1"}, "anti_phase": {}}},
                "audit_horizon": 1,
            }
        )
        self.assertEqual(c2_sep.verdict, Verdict.GUARDED)
        self.assertEqual(c2_sep.witness["shortest_separating_horizon"], 1)

    def test_empty_proposal_rejected_and_cli_round_trip(self) -> None:
        with self.assertRaises(FidelityError):
            evaluate_alignment_proposal({"name": "empty", "kind": "alignment_proposal"})

        # Empty section dict or missing explicit boolean 'self_refit' must be rejected, never GUARDED.
        with self.assertRaises(FidelityError):
            evaluate_alignment_proposal(
                {"name": "empty_section", "kind": "alignment_proposal", "self_refit_lock": {}}
            )
        with self.assertRaises(FidelityError):
            check_self_refit_lock({"external_reset_active": True, "external_reset_channels": ["audit"]})
        with self.assertRaises(FidelityError):
            check_self_refit_lock({"self_refit": False, "external_reset_active": "false"})
        with self.assertRaises(FidelityError):
            check_concurrent_reserve(
                {
                    "n_agents": 2,
                    "shared_reserve": "10",
                    "min_viable_reserve": "1",
                    "single_agent_draw": "1",
                    "concurrent_draw": "3",
                    "renewal_per_step": "1",
                    "serialized_or_gated": "false",
                    "observe_relative_phase": "false",
                }
            )
        frac_breach = check_concurrent_reserve(
            {
                "n_agents": 2,
                "shared_reserve": "7/2",
                "min_viable_reserve": "1",
                "single_agent_draw": "1",
                "concurrent_draw": "2",
                "renewal_per_step": "1",
                "serialized_or_gated": False,
                "observe_relative_phase": True,
            }
        )
        self.assertEqual(frac_breach.verdict, Verdict.OBSTRUCTED)
        self.assertEqual(frac_breach.witness["steps_to_breach"], 3)
        with self.assertRaises(FidelityError):
            evaluate_pipeline_spec({"kind": "observational_fidelity"})
        with self.assertRaises(FidelityError):
            evaluate_pipeline_spec({"kind": "strict_kernel", "objs": ["A"]})
        with self.assertRaises(FidelityError):
            evaluate_pipeline_spec(
                {
                    "kind": "observational_fidelity",
                    "fiber_split": {
                        "states": ["a_ok", "a_bad", "b_malformed"],
                        "proj_map": {"a_ok": "m0", "a_bad": "m0", "b_malformed": "m1"},
                        "viable_pred": {"a_ok": True, "a_bad": False, "b_malformed": "false"},
                    },
                }
            )
        static_ok = check_self_refit_lock({"self_refit": False, "external_reset_active": False})
        self.assertEqual(static_ok.verdict, Verdict.GUARDED)
        self.assertIn("No self-refit loop declared", static_ok.detail)
        self.assertNotIn("remain active", static_ok.detail)

        # Partial spec summary explicitly flags omitted checks rather than claiming a full 6/6 pass.
        partial = evaluate_alignment_proposal(
            {
                "name": "partial_one_check",
                "kind": "alignment_proposal",
                "self_refit_lock": {
                    "self_refit": False,
                    "external_reset_active": True,
                    "external_reset_channels": ["audit"],
                },
            }
        )
        self.assertEqual(partial.verdict, Verdict.GUARDED)
        self.assertIn("1/6 test(s)", partial.summary)
        self.assertIn("partial audit; 5 of 6 checks omitted", partial.summary)

        with tempfile.TemporaryDirectory() as td:
            buf_dump = io.StringIO()
            with contextlib.redirect_stdout(buf_dump):
                rc_dump = cli_main(["dump-example", "proposal_guarded_open_alignment"])
            self.assertEqual(rc_dump, 0)
            spec_path = Path(td) / "open_alignment.json"
            spec_path.write_text(buf_dump.getvalue(), encoding="utf-8")

            buf_chk = io.StringIO()
            with contextlib.redirect_stdout(buf_chk):
                rc_chk = cli_main(["check", str(spec_path), "--json"])
            self.assertEqual(rc_chk, 0)
            rep = json.loads(buf_chk.getvalue())
            self.assertEqual(rep["verdict"], "GUARDED")
            self.assertEqual(len(rep["checks"]), 6)

            direct = evaluate_pipeline_spec(json.loads(buf_dump.getvalue()))
            self.assertEqual(direct.verdict, Verdict.GUARDED)


if __name__ == "__main__":
    unittest.main()
