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
    }


def run_builtin_example(name: str) -> DiagnosticReport:
    """Run a single named built-in example and return its ``DiagnosticReport``."""
    specs = builtin_example_specs()
    if name not in specs:
        raise KeyError(f"Unknown built-in example {name!r}; available: {sorted(specs)}")
    return evaluate_pipeline_spec(specs[name])
