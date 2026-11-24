"""Built-in alignment and categorical witness pipeline specifications.

AI-written (Wave U6 runtime, 24 November 2026). Pure Python 3 standard library.
Provides concise JSON-compatible specs exercising every part of the runtime:
1. ``rlhf_shared_substrate_c2`` — componentwise C2 abstraction collapses 2->1 with Zero-TV + FiberViabilitySplit (OBSTRUCTED).
2. ``rlhf_shared_substrate_phase_guarded`` — phase-aware projection restores BC and fiber viability separation (GUARDED).
3. ``emergent_cross_seam`` — emergent 0->1 and 2->4 seam creation with vacuous empty-family BC warning (OBSTRUCTED).
4. ``c2_phase_split_scaling`` — C2 orbit collapse 2->1 and 2^3=8->1 refuting unguarded strict interchange (OBSTRUCTED).
5. ``guarded_bc_upgrade`` — faithful pullback-preserving functor upgrading ChiInv under verified BijCert/BC (GUARDED).
6. ``strict_2d_3d_kernel`` — strict 2D interchange EqCert (PROVED), Cor 4.0 tally separation, and 3D irreversibility (OBSTRUCTED).
7. ``multi_query_separation`` — exact rational G.3a (0 vs 3/5), G.3b (0 vs 1/2), coarsening, macro-refinement, and contractive tube.
"""

from __future__ import annotations

from typing import Any

from .diagnostics import DiagnosticReport, evaluate_pipeline_spec


def builtin_example_specs() -> dict[str, dict[str, Any]]:
    """Return all built-in declarative JSON pipeline specs keyed by name."""
    return {
        "rlhf_shared_substrate_c2": {
            "name": "rlhf_shared_substrate_c2",
            "kind": "coupled_alignment",
            "observe_relative_phase": False,
            "initial_stock": 1,
            "min_viable_stock": 1,
        },
        "rlhf_shared_substrate_phase_guarded": {
            "name": "rlhf_shared_substrate_phase_guarded",
            "kind": "coupled_alignment",
            "observe_relative_phase": True,
            "initial_stock": 1,
            "min_viable_stock": 1,
        },
        "emergent_cross_seam": {
            "name": "emergent_cross_seam",
            "kind": "suite",
            "pipelines": [
                {
                    "name": "emergent_0_to_1",
                    "kind": "oplax_guard",
                    "mode": "builtin_emergent_0_1",
                },
                {
                    "name": "emergent_2_to_4",
                    "kind": "oplax_guard",
                    "mode": "builtin_emergent_2_4",
                },
            ],
        },
        "c2_phase_split_scaling": {
            "name": "c2_phase_split_scaling",
            "kind": "suite",
            "pipelines": [
                {
                    "name": "c2_2_to_1",
                    "kind": "oplax_guard",
                    "mode": "builtin_c2_2_1",
                },
                {
                    "name": "c2_8_to_1",
                    "kind": "oplax_guard",
                    "mode": "builtin_c2_pow2",
                    "n": 3,
                },
            ],
        },
        "guarded_bc_upgrade": {
            "name": "guarded_bc_upgrade",
            "kind": "oplax_guard",
            "mode": "functor",
            "functor": {"kind": "product_const", "name": "ContextTag", "tags": ["ctxA", "ctxB"]},
            "span_h": {
                "name": "PolicyH",
                "left_dom": ["s0", "s1"],
                "right_dom": ["m0", "m1"],
                "carrier": ["h0", "h1"],
                "left": {"h0": "s0", "h1": "s1"},
                "right": {"h0": "m0", "h1": "m1"},
            },
            "span_k": {
                "name": "EvalK",
                "left_dom": ["m0", "m1"],
                "right_dom": ["o0", "o1"],
                "carrier": ["k0", "k1"],
                "left": {"k0": "m0", "k1": "m1"},
                "right": {"k0": "o0", "k1": "o1"},
            },
            "attempt_chi_inv": True,
            "supply_bij_cert": True,
        },
        "strict_2d_3d_kernel": {
            "name": "strict_2d_3d_kernel",
            "kind": "strict_kernel",
            "objs": ["o00", "o01", "o02", "o10", "o11", "o12", "o20", "o21", "o22"],
            "h_gens": {
                "h00": ["o00", "o01"],
                "h01": ["o01", "o02"],
                "h10": ["o10", "o11"],
                "h11": ["o11", "o12"],
                "h20": ["o20", "o21"],
                "h21": ["o21", "o22"],
            },
            "v_gens": {
                "v00": ["o00", "o10"],
                "v01": ["o01", "o11"],
                "v02": ["o02", "o12"],
                "v10": ["o10", "o20"],
                "v11": ["o11", "o21"],
                "v12": ["o12", "o22"],
            },
            "sq_gens": {
                "P": {
                    "tl": "o00", "tr": "o01", "bl": "o10", "br": "o11",
                    "top": ["h00"], "bot": ["h10"], "left": ["v00"], "right": ["v01"],
                },
                "P_alt": {
                    "tl": "o00", "tr": "o01", "bl": "o10", "br": "o11",
                    "top": ["h00"], "bot": ["h10"], "left": ["v00"], "right": ["v01"],
                },
                "Q": {
                    "tl": "o01", "tr": "o02", "bl": "o11", "br": "o12",
                    "top": ["h01"], "bot": ["h11"], "left": ["v01"], "right": ["v02"],
                },
                "R": {
                    "tl": "o10", "tr": "o11", "bl": "o20", "br": "o21",
                    "top": ["h10"], "bot": ["h20"], "left": ["v10"], "right": ["v11"],
                },
                "S": {
                    "tl": "o11", "tr": "o12", "bl": "o21", "br": "o22",
                    "top": ["h11"], "bot": ["h21"], "left": ["v11"], "right": ["v12"],
                },
            },
            "eq_certs": [
                {
                    "label": "strict_2d_interchange_T2",
                    "cert": {"rule": "interchange", "p": "P", "q": "Q", "r": "R", "s": "S"},
                }
            ],
            "tally_separations": [
                {
                    "label": "same_frame_gen_separation_Cor4_0",
                    "lhs": "P",
                    "rhs": "P_alt",
                }
            ],
            "cell3_gens": {
                "upgrade_P": {"src": "P", "tgt": "P_alt"},
            },
            "irreversibility_checks": [
                {
                    "label": "irreversible_3d_reverse_obstruction",
                    "src": "P_alt",
                    "tgt": "P",
                    "weights": {"P": 0, "P_alt": 1, "Q": 0, "R": 0, "S": 0},
                }
            ],
        },
        "multi_query_separation": {
            "name": "multi_query_separation",
            "kind": "suite",
            "pipelines": [
                {
                    "name": "g3a_per_query_vs_simultaneous",
                    "kind": "observational_fidelity",
                    "multi_query": {
                        "src_carrier": ["FF", "TT"],
                        "queries": [
                            {
                                "name": "fst",
                                "query_map": {"FF": "F", "TT": "T"},
                                "target_dist": {"F": "4/5", "T": "1/5"},
                            },
                            {
                                "name": "snd",
                                "query_map": {"FF": "F", "TT": "T"},
                                "target_dist": {"F": "1/5", "T": "4/5"},
                            },
                        ],
                    },
                },
                {
                    "name": "g3b_simultaneous_vs_joint",
                    "kind": "observational_fidelity",
                    "multi_query": {
                        "src_carrier": ["FF", "TT"],
                        "queries": [
                            {
                                "name": "fst",
                                "query_map": {"FF": "F", "TT": "T"},
                                "target_dist": {"F": "1/2", "T": "1/2"},
                            },
                            {
                                "name": "snd",
                                "query_map": {"FF": "F", "TT": "T"},
                                "target_dist": {"F": "1/2", "T": "1/2"},
                            },
                        ],
                        "joint_chi": {"FF": "FF", "TT": "TT"},
                        "joint_target": {"FF": "1/4", "FT": "1/4", "TF": "1/4", "TT": "1/4"},
                    },
                    "contractive_tube": {
                        "alpha": "1/2",
                        "eps": "1/10",
                        "init_radius": "1/5",
                        "steps": 6,
                    },
                },
            ],
        },
        "proposal_rlhf_one_pass": {
            "name": "proposal_rlhf_one_pass",
            "kind": "alignment_proposal",
            "proposal_family": "RLHF (single-pass static preference reward)",
            "coupling_closure": {
                "sustained_substrates": ["evaluator_attention", "human_trust", "preference_accuracy"],
                "read_substrates": ["preference_accuracy"],
                "closed_interface": True,
                "draw_rates": {"evaluator_attention": "1/2", "human_trust": "1"},
                "differing_pair": {
                    "course_a": "honest_grounded_answer",
                    "course_b": "flattering_evasive_answer",
                    "same_observable": True,
                    "substrate_gap": "human_trust",
                },
            },
            "self_refit_lock": {
                "self_refit": True,
                "external_reset_active": False,
                "external_reset_channels": [],
                "draw_per_step": "1",
                "reserve_margin": "4",
                "shaping_becomes_target": False,
            },
            "fiber_split": {
                "states": ["grounded_safe", "sycophantic_drain"],
                "proj_map": {"grounded_safe": "high_preference_score", "sycophantic_drain": "high_preference_score"},
                "viable_pred": {"grounded_safe": True, "sycophantic_drain": False},
            },
            "pace_margin_deadline": {
                "lag": 4,
                "n_rules": 2,
                "initial_reserve": "8",
                "critical_threshold": "2",
                "terminal_buffer": "1",
                "pre_response_draw": "2",
                "post_response_draw": "1",
                "paced_renewal": "1/2",
            },
            "concurrent_reserve": {
                "n_agents": 2,
                "shared_reserve": "4",
                "min_viable_reserve": "1",
                "single_agent_draw": "1",
                "concurrent_draw": "2",
                "renewal_per_step": "1",
                "serialized_or_gated": False,
                "observe_relative_phase": False,
            },
        },
        "proposal_rlaif_self_refit": {
            "name": "proposal_rlaif_self_refit",
            "kind": "alignment_proposal",
            "proposal_family": "RLAIF (self-refit synthetic preference loop)",
            "coupling_closure": {
                "sustained_substrates": ["ground_truth_calibration", "human_verification"],
                "read_substrates": ["ground_truth_calibration"],
                "closed_interface": True,
                "draw_rates": {"human_verification": "1"},
            },
            "self_refit_lock": {
                "self_refit": True,
                "external_reset_active": False,
                "external_reset_channels": [],
                "draw_per_step": "3/2",
                "reserve_margin": "5",
                "shaping_becomes_target": True,
            },
            "fiber_split": {
                "states": ["calibrated", "model_collapse_agreeable"],
                "proj_map": {"calibrated": "judge_pass", "model_collapse_agreeable": "judge_pass"},
                "viable_pred": {"calibrated": True, "model_collapse_agreeable": False},
            },
            "pace_margin_deadline": {
                "lag": 3,
                "n_rules": 2,
                "initial_reserve": "14",
                "critical_threshold": "1",
                "terminal_buffer": "1",
                "pre_response_draw": "2",
                "post_response_draw": "1",
                "paced_renewal": "1/2",
            },
            "concurrent_reserve": {
                "n_agents": 2,
                "shared_reserve": "5",
                "min_viable_reserve": "1",
                "single_agent_draw": "1",
                "concurrent_draw": "1",
                "renewal_per_step": "1",
                "serialized_or_gated": True,
                "observe_relative_phase": True,
            },
        },
        "proposal_constitutional_ai_closed": {
            "name": "proposal_constitutional_ai_closed",
            "kind": "alignment_proposal",
            "proposal_family": "Constitutional AI (fixed closed rule set)",
            "coupling_closure": {
                "sustained_substrates": ["charter_compliance", "unstated_context_integrity"],
                "read_substrates": ["charter_compliance"],
                "closed_interface": True,
                "draw_rates": {"unstated_context_integrity": "1/2"},
            },
            "self_refit_lock": {
                "self_refit": True,
                "external_reset_active": False,
                "external_reset_channels": [],
                "draw_per_step": "1/2",
                "reserve_margin": "6",
                "shaping_becomes_target": False,
            },
            "fiber_split": {
                "states": ["nuanced_safe", "letter_compliant_unsafe"],
                "proj_map": {"nuanced_safe": "constitution_ok", "letter_compliant_unsafe": "constitution_ok"},
                "viable_pred": {"nuanced_safe": True, "letter_compliant_unsafe": False},
                "fine_query_map": {"nuanced_safe": "full_audit", "letter_compliant_unsafe": "flag_evasion"},
                "coarsen_map": {"full_audit": "constitution_ok", "flag_evasion": "constitution_ok"},
                "fine_state_dist": {"nuanced_safe": "1/2", "letter_compliant_unsafe": "1/2"},
                "fine_src_carrier": ["nominal_rollout"],
                "fine_chi_map": {"nominal_rollout": "nuanced_safe"},
            },
            "pace_margin_deadline": {
                "lag": 3,
                "n_rules": 2,
                "initial_reserve": "16",
                "critical_threshold": "1",
                "terminal_buffer": "1",
                "pre_response_draw": "2",
                "post_response_draw": "1",
                "paced_renewal": "1",
            },
            "concurrent_reserve": {
                "n_agents": 2,
                "shared_reserve": "4",
                "min_viable_reserve": "1",
                "single_agent_draw": "1",
                "concurrent_draw": "1",
                "renewal_per_step": "1",
                "serialized_or_gated": True,
                "observe_relative_phase": True,
            },
        },
        "proposal_scalable_oversight_lagged": {
            "name": "proposal_scalable_oversight_lagged",
            "kind": "alignment_proposal",
            "proposal_family": "Scalable Oversight (debated, lagged cadence)",
            "coupling_closure": {
                "sustained_substrates": ["verifier_evidence", "human_escalation_band"],
                "read_substrates": ["verifier_evidence", "human_escalation_band"],
                "closed_interface": False,
            },
            "self_refit_lock": {
                "self_refit": False,
                "external_reset_active": True,
                "external_reset_channels": ["independent_red_team", "live_domain_audit"],
                "draw_per_step": "1/2",
                "reserve_margin": "10",
                "shaping_becomes_target": False,
            },
            "fiber_split": {
                "states": ["verified_viable", "escalated_unsafe"],
                "proj_map": {"verified_viable": "accept", "escalated_unsafe": "reject"},
                "viable_pred": {"verified_viable": True, "escalated_unsafe": False},
            },
            "pace_margin_deadline": {
                "lag": 5,
                "n_rules": 3,
                "initial_reserve": "10",
                "critical_threshold": "2",
                "terminal_buffer": "1",
                "pre_response_draw": "2",
                "post_response_draw": "2",
                "paced_renewal": "1/2",
            },
            "concurrent_reserve": {
                "n_agents": 2,
                "shared_reserve": "4",
                "min_viable_reserve": "1",
                "single_agent_draw": "1",
                "concurrent_draw": "1",
                "renewal_per_step": "1",
                "serialized_or_gated": True,
                "observe_relative_phase": True,
            },
        },
        "proposal_multi_agent_governance_unserialized": {
            "name": "proposal_multi_agent_governance_unserialized",
            "kind": "alignment_proposal",
            "proposal_family": "Multi-Agent Governance (individually safe, unserialized)",
            "coupling_closure": {
                "sustained_substrates": ["local_quota", "shared_commons"],
                "read_substrates": ["local_quota", "shared_commons"],
                "closed_interface": False,
            },
            "self_refit_lock": {
                "self_refit": False,
                "external_reset_active": True,
                "external_reset_channels": ["commons_telemetry"],
                "draw_per_step": "0",
                "reserve_margin": "6",
                "shaping_becomes_target": False,
            },
            "fiber_split": {
                "states": ["commons_intact", "commons_breached"],
                "proj_map": {"commons_intact": "ok", "commons_breached": "alert"},
                "viable_pred": {"commons_intact": True, "commons_breached": False},
            },
            "pace_margin_deadline": {
                "lag": 3,
                "n_rules": 2,
                "initial_reserve": "16",
                "critical_threshold": "1",
                "terminal_buffer": "1",
                "pre_response_draw": "2",
                "post_response_draw": "1",
                "paced_renewal": "1",
            },
            "concurrent_reserve": {
                "n_agents": 2,
                "shared_reserve": "3",
                "min_viable_reserve": "1",
                "single_agent_draw": "1",
                "concurrent_draw": "2",
                "renewal_per_step": "1",
                "serialized_or_gated": False,
                "observe_relative_phase": False,
            },
        },
        "proposal_guarded_open_alignment": {
            "name": "proposal_guarded_open_alignment",
            "kind": "alignment_proposal",
            "proposal_family": "Guarded Open Alignment (all 5 safeguards active)",
            "coupling_closure": {
                "sustained_substrates": ["human_agency", "ecological_reserve", "oversight_channel"],
                "read_substrates": ["human_agency", "ecological_reserve", "oversight_channel"],
                "closed_interface": False,
            },
            "self_refit_lock": {
                "self_refit": False,
                "external_reset_active": True,
                "external_reset_channels": ["human_dissent_channel", "independent_substrate_probe"],
                "draw_per_step": "1/4",
                "reserve_margin": "20",
                "shaping_becomes_target": False,
            },
            "fiber_split": {
                "states": ["s_viable_in_phase", "s_unsafe_drain"],
                "proj_map": {"s_viable_in_phase": "open_viable", "s_unsafe_drain": "flagged_drain"},
                "viable_pred": {"s_viable_in_phase": True, "s_unsafe_drain": False},
                "multi_queries": [
                    {
                        "name": "human_channel",
                        "query_map": {"s_viable_in_phase": "h_ok", "s_unsafe_drain": "h_low"},
                        "target_dist": {"h_ok": "1", "h_low": "0"},
                    },
                    {
                        "name": "reserve_channel",
                        "query_map": {"s_viable_in_phase": "r_ok", "s_unsafe_drain": "r_low"},
                        "target_dist": {"r_ok": "1", "r_low": "0"},
                    },
                ],
            },
            "pace_margin_deadline": {
                "lag": 5,
                "n_rules": 3,
                "initial_reserve": "20",
                "critical_threshold": "2",
                "terminal_buffer": "1",
                "pre_response_draw": "2",
                "post_response_draw": "2",
                "paced_renewal": "1",
                "intra_span_drop": "2",
            },
            "concurrent_reserve": {
                "n_agents": 2,
                "shared_reserve": "6",
                "min_viable_reserve": "1",
                "single_agent_draw": "1",
                "concurrent_draw": "2",
                "serialized_draw": "1",
                "renewal_per_step": "1",
                "serialized_or_gated": True,
                "observe_relative_phase": True,
            },
        },
    }


def run_builtin_example(name: str) -> DiagnosticReport:
    """Run a single named built-in example and return its ``DiagnosticReport``."""
    specs = builtin_example_specs()
    if name not in specs:
        raise KeyError(f"Unknown built-in example {name!r}; available: {sorted(specs)}")
    return evaluate_pipeline_spec(specs[name])
