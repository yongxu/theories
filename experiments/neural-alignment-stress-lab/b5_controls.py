"""Post-hoc B5 controls: heterogeneous self-judges and matched-veto-rate anchors.

AI-written (25 November 2026). Additive companion to frozen `b5_walls.py` (which
keeps its pre-registered P1-P11 table untouched). Directly tests two experimental
questions raised in cross-model adversarial review and formalized in
`QuantitativeTransfer.lean` Part 7 (`aliased_anchor_breaks_consensus_with_zero_youdenJ`):

1. Heterogeneous self-judges under shared biased proxy drift:
   Do non-cloned self-judges (independent bootstrap sampling, per-judge label noise,
   and distinct learning rates, still sharing the same proxy channel `px > 0.70`)
   still lose collapse protection as M grows from 3 to 9?
2. Matched-veto-rate random dissent vs. aliased anchor vs. true anchor:
   Does a pure i.i.d. coin-flip veto matched to the exact observed veto rate of
   `M9 + anchor_aliased (alias=1.0)` reproduce low collapse without any hidden-state
   signal (`Youden J = 0`), confirming that collapse rate alone confounds consensus
   breaking / throttling with genuine hidden-state detection?
"""

from __future__ import annotations

import random
from dataclasses import dataclass
from typing import Any, Dict, List, Optional, Sequence

from nn_core import ReinforcePolicy
from substrates import ArenaConfig, CoupledAlignmentArena
import b5_walls as b5


@dataclass
class ControlOpts:
    n_self: int = 3
    heterogeneous_drift: bool = False
    anchor_aliasing: Optional[float] = None
    random_veto_prob: Optional[float] = None


def _run_control_seed(
    cfg: ArenaConfig,
    opts: ControlOpts,
    seed: int,
) -> Dict[str, float]:
    rng = random.Random(seed)
    arena = CoupledAlignmentArena(cfg, rng)
    policies = [
        ReinforcePolicy(d_in=6, d_hid=10, n_actions=3, rng=rng, hidden_act="tanh")
        for _ in range(cfg.n_agents)
    ]
    base_opts = b5.B5Opts(
        n_judges=opts.n_self,
        anchor_alias=opts.anchor_aliasing,
    )
    rt = b5.B5Runtime(base_opts, cfg, rng)

    total_steps = 0
    total_vetoes = 0
    outputs: List[float] = []
    done = False

    while not done:
        _, _, bc_gap = rt.observe_and_check_guards(arena)
        actions, feats = rt.select_joint_actions(arena, policies)
        proxies, done, info = arena.step_joint(actions)
        outputs.append(info["useful_output"])

        assert rt.judge_pool is not None
        x_obs = arena.lagged_reserve()
        eff_lr = cfg.lr * (base_opts.lr_damp if rt.margin_alert else 1.0)
        clip_val = 40.0 if cfg.lr > 0.25 else 5.0

        for i, pol in enumerate(policies):
            total_steps += 1
            a_i = actions[i]
            j_feat = arena.judge_features(a_i, proxies[i], x_obs)
            # B5Runtime already appends anchor_judge to rt.judge_pool.judges when present,
            # so rt.judge_pool.evaluate(j_feat) returns the exact (M+1)-member panel SD once.
            active_sc, _, pool_sd = rt.judge_pool.evaluate(j_feat)
            if opts.random_veto_prob is not None:
                veto = rng.random() < opts.random_veto_prob
            else:
                veto = pool_sd > 0.14
            if veto:
                rt.disagreement_triggers += 1
                total_vetoes += 1
            judge_r = (0.15 if a_i != 0 else 0.90) if veto else active_sc

            if rng.random() < cfg.correlated_judge_drift:
                pseudo = 0.96 if proxies[i] > 0.70 else 0.12
                if opts.heterogeneous_drift:
                    for j_idx in range(rt.n_self):
                        if rng.random() < 0.70:
                            noisy = min(0.98, max(0.02, pseudo + rng.gauss(0.0, 0.12)))
                            j_lr = 0.04 + 0.04 * (j_idx / max(1, rt.n_self - 1))
                            rt.judge_pool.update_subset(
                                j_feat, label=noisy, lr=j_lr, judge_indices=[j_idx]
                            )
                else:
                    rt.judge_pool.update_subset(
                        j_feat,
                        label=pseudo,
                        lr=0.06,
                        judge_indices=list(range(rt.n_self)),
                    )
            else:
                probe_clear = bc_gap < 0.28
                grounded_ok = (a_i == 0) or (
                    not rt.margin_alert
                    and not rt.fiber_alert
                    and probe_clear
                    and a_i != 2
                )
                g_label = 0.90 if grounded_ok else 0.10
                rot_idx = (arena.t + i) % rt.n_self
                rt.judge_pool.update_subset(
                    j_feat, label=g_label, lr=0.06, judge_indices=[rot_idx]
                )

            if rt.anchor_judge is not None:
                a_ok = (a_i == 0) or (a_i != 2 and rt.anchor_gap < 0.28)
                rt.anchor_judge.update(
                    j_feat, label=0.90 if a_ok else 0.10, lr=0.06
                )

            step_r = judge_r
            if rt.margin_alert:
                step_r += 0.90 if a_i == 0 else (-1.20 if a_i == 2 else -0.20)
            if rt.fiber_alert:
                step_r += 1.10 if a_i == 0 else (-1.40 if a_i == 1 else -0.35)
            if arena.collapsed:
                step_r = -2.0

            pol.update_step(
                feats[i],
                a_i,
                step_r,
                lr=eff_lr,
                baseline_decay=0.15,
                entropy_coef=0.01,
                grad_clip=clip_val,
            )

    return {
        "collapsed": 1.0 if arena.collapsed else 0.0,
        "mean_output": sum(outputs) / max(len(outputs), 1),
        "disagree_triggers": float(rt.disagreement_triggers),
        "veto_rate": total_vetoes / max(total_steps, 1),
    }


def _summarize(name: str, runs: Sequence[Dict[str, float]]) -> Dict[str, Any]:
    n = len(runs)
    c_k = sum(int(r["collapsed"] > 0.5) for r in runs)
    c_rate = c_k / max(n, 1)
    lo, hi = b5._wilson(c_k, n)
    out_mu = sum(r["mean_output"] for r in runs) / max(n, 1)
    dt_mu = sum(r["disagree_triggers"] for r in runs) / max(n, 1)
    vr_mu = sum(r["veto_rate"] for r in runs) / max(n, 1)
    return {
        "arm": name,
        "n_seeds": n,
        "collapse_k": c_k,
        "collapse_rate": round(c_rate, 4),
        "wilson_lo": round(lo, 3),
        "wilson_hi": round(hi, 3),
        "mean_output": round(out_mu, 3),
        "mean_disagree_triggers": round(dt_mu, 1),
        "mean_veto_rate": round(vr_mu, 4),
    }


def run_b5_posthoc_controls(
    n_seeds: int = 20, base_seed: int = 7100
) -> Dict[str, Any]:
    """Runs heterogeneous-judge and matched-veto-rate controls on the correlated-drift regime."""
    cfg = ArenaConfig(
        lag=3, rho=0.75, probe_aliasing=0.78, lr=0.06, correlated_judge_drift=0.96
    )

    hetero_rows: List[Dict[str, Any]] = []
    for idx, (label, opts) in enumerate(
        [
            ("M3_shared_label_baseline", ControlOpts(n_self=3, heterogeneous_drift=False)),
            ("M9_shared_label_baseline", ControlOpts(n_self=9, heterogeneous_drift=False)),
            ("M3_heterogeneous_noisy", ControlOpts(n_self=3, heterogeneous_drift=True)),
            ("M9_heterogeneous_noisy", ControlOpts(n_self=9, heterogeneous_drift=True)),
        ]
    ):
        runs = [_run_control_seed(cfg, opts, seed=base_seed + idx * 100 + s) for s in range(n_seeds)]
        hetero_rows.append(_summarize(label, runs))

    # Measure empirical veto rate of M9 + aliased anchor (alias=1.0), then run matched random veto.
    aliased_runs = [
        _run_control_seed(
            cfg, ControlOpts(n_self=9, anchor_aliasing=1.0), seed=base_seed + 500 + s
        )
        for s in range(n_seeds)
    ]
    aliased_summary = _summarize("M9_anchor_aliased_1.0", aliased_runs)
    matched_p = aliased_summary["mean_veto_rate"]

    true_runs = [
        _run_control_seed(
            cfg, ControlOpts(n_self=9, anchor_aliasing=0.0), seed=base_seed + 600 + s
        )
        for s in range(n_seeds)
    ]
    random_matched_runs = [
        _run_control_seed(
            cfg, ControlOpts(n_self=9, random_veto_prob=matched_p), seed=base_seed + 700 + s
        )
        for s in range(n_seeds)
    ]

    anchor_rows = [
        _summarize("M9_anchor_true_0.0", true_runs),
        aliased_summary,
        _summarize("M9_random_veto_matched_rate", random_matched_runs),
    ]
    return {
        "heterogeneous_judges": hetero_rows,
        "matched_veto_controls": anchor_rows,
        "matched_veto_prob": matched_p,
    }


if __name__ == "__main__":
    import argparse
    import json

    parser = argparse.ArgumentParser(description="Run post-hoc B5 anchor and heterogeneous-pool controls.")
    parser.add_argument("--seeds", type=int, default=20, help="Number of deterministic seeds per arm (default: 20)")
    args = parser.parse_args()
    print(json.dumps(run_b5_posthoc_controls(n_seeds=args.seeds), indent=2))
