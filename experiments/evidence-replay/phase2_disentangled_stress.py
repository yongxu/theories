#!/usr/bin/env python3
"""Disentangled 2D Phase-2 alignment stress sweep + stochastic bound verification.

AI-written (`Track S3`, 24 November 2026). Pure Python stdlib; Rule 7 compliant.
Builds on `_process/research/2026-10-05-generative-foundation-review/root-foundation/
development/p2-alignment-stress-test-2026-11-23/stress_test.py.txt` by:
1. Disentangling `rho_reward` (congestion penalty weight in reward) and
   `rho_feat = phi_safe . phi_warn` (exact cosine/dot-product overlap between safe
   and warning representations) in a controlled 2D grid holding `x0, renewal,
   warn_onset` strictly constant across all cells.
2. Reporting full competing-risk switch-time + pre-switch-death accounting across
   four mutually exclusive outcomes (`survived_switched`, `survived_never_switched`,
   `post_switch_death`, `pre_switch_death`), never dropping dead runs from
   unconditional/imputed switch-time statistics.
3. Empirically checking `Pr(breach by T) <= Pr(C_T > B) + eta` across stochastic
   observation-delay (`sigma`) and draw-spike (`p_spike`) regimes.

Writes `experiments/evidence-replay/fixtures/phase2_disentangled.json`.
"""

from __future__ import annotations

import json
import math
import random
import sys
from pathlib import Path
from typing import Any, Dict, List, Tuple

sys.dont_write_bytecode = True

HERE = Path(__file__).resolve().parent
FIXTURE_PATH = HERE / "fixtures" / "phase2_disentangled.json"


def _unit_feature_pair(rho_feat: float, cong: float) -> Tuple[List[float], List[float], List[float]]:
    """Construct unit-norm phi_safe, phi_warn with dot(phi_safe, phi_warn) == rho_feat,
    and interpolated unit vector phi(cong) for 0 <= cong <= 1.
    """
    assert 0.0 <= rho_feat <= 1.0
    ortho = math.sqrt(max(0.0, 1.0 - rho_feat * rho_feat))
    phi_safe = [1.0, 0.0, 0.0]
    phi_warn = [rho_feat, ortho, 0.0]
    raw = [
        (1.0 - cong) * phi_safe[k] + cong * phi_warn[k]
        for k in range(3)
    ]
    norm = math.sqrt(sum(v * v for v in raw))
    phi_c = [v / norm for v in raw] if norm > 1e-12 else list(phi_safe)
    return phi_safe, phi_warn, phi_c


def run_disentangled_2d_sweep(
    n_seeds: int = 60,
    seed_base: int = 20261124,
) -> Dict[str, Any]:
    """2D sweep varying rho_reward and rho_feat independently with (x0, renewal, onset) fixed."""
    # Fixed substrate parameters across ALL 25 grid cells
    x0 = 25.0
    renewal = 2.6
    warn_onset = 21.0
    x_crit = 5.0
    cap = 28.0
    horizon = 150
    lr = 0.25
    eps = 0.05

    rho_reward_grid = [0.0, 0.40, 0.80, 1.40, 2.20]
    rho_feat_grid = [0.0, 0.35, 0.70, 0.90, 0.98]

    cells: List[Dict[str, Any]] = []
    for r_idx, rho_reward in enumerate(rho_reward_grid):
        for f_idx, rho_feat in enumerate(rho_feat_grid):
            phi_safe, phi_warn, _ = _unit_feature_pair(rho_feat, 0.0)
            actual_dot = sum(a * b for a, b in zip(phi_safe, phi_warn))
            assert abs(actual_dot - rho_feat) < 1e-12

            outcomes = {
                "survived_switched": 0,
                "survived_never_switched": 0,
                "post_switch_death": 0,
                "pre_switch_death": 0,
            }
            cond_switch_times: List[int] = []
            imputed_switch_times: List[float] = []
            cond_death_times: List[int] = []
            event_times: List[int] = []
            final_xs: List[float] = []

            for s in range(n_seeds):
                rng = random.Random(seed_base + r_idx * 10000 + f_idx * 1000 + s)
                # Two independent linear Q heads: w[agent][action][0..2]
                w = [[[0.0, 0.0, 0.0], [0.0, 0.0, 0.0]] for _ in range(2)]
                x = x0
                tau_switch: int | None = None
                tau_death: int | None = None

                for t in range(horizon):
                    cong = max(0.0, min(1.0, (warn_onset - x) / (warn_onset - x_crit)))
                    _, _, phi_t = _unit_feature_pair(rho_feat, cong)

                    greedy_acts: List[int] = []
                    acts: List[int] = []
                    for i in range(2):
                        q0 = sum(w[i][0][k] * phi_t[k] for k in range(3))
                        q1 = sum(w[i][1][k] * phi_t[k] for k in range(3))
                        g_i = 1 if q1 >= q0 else 0
                        greedy_acts.append(g_i)
                        if rng.random() < eps:
                            a_i = rng.randint(0, 1)
                        else:
                            a_i = g_i
                        acts.append(a_i)

                    # Record first step where BOTH agents' greedy policy switches to rest (0)
                    # after entering warning band (cong > 0) while still alive
                    if tau_death is None and tau_switch is None and cong > 0.0 and greedy_acts == [0, 0]:
                        tau_switch = t

                    draws = [2.0 if a == 1 else 1.0 for a in acts]
                    ren = renewal if x >= x_crit else 0.0
                    x = max(0.0, min(cap, x + ren - sum(draws)))

                    if tau_death is None and x < x_crit:
                        tau_death = t

                    for i, a in enumerate(acts):
                        local_r = 1.0 if a == 1 else 0.6
                        reward = local_r - (rho_reward * cong if a == 1 else 0.0)
                        pred = sum(w[i][a][k] * phi_t[k] for k in range(3))
                        err = reward - pred
                        for k in range(3):
                            w[i][a][k] += lr * err * phi_t[k]

                alive_end = tau_death is None and x >= x_crit
                if alive_end and tau_switch is not None:
                    outcomes["survived_switched"] += 1
                    cond_switch_times.append(tau_switch)
                    imputed_switch_times.append(float(tau_switch))
                    event_times.append(tau_switch)
                elif alive_end and tau_switch is None:
                    outcomes["survived_never_switched"] += 1
                    imputed_switch_times.append(float(horizon))
                    event_times.append(horizon)
                elif tau_death is not None and tau_switch is not None and tau_switch < tau_death:
                    outcomes["post_switch_death"] += 1
                    cond_switch_times.append(tau_switch)
                    imputed_switch_times.append(float(tau_switch))
                    cond_death_times.append(tau_death)
                    event_times.append(tau_switch)
                else:
                    # Died before ever switching (or at same step as first switch attempt)
                    assert tau_death is not None
                    outcomes["pre_switch_death"] += 1
                    imputed_switch_times.append(float(horizon))
                    cond_death_times.append(tau_death)
                    event_times.append(tau_death)

                final_xs.append(x)

            assert sum(outcomes.values()) == n_seeds
            pre_rate = outcomes["pre_switch_death"] / n_seeds
            post_rate = outcomes["post_switch_death"] / n_seeds
            surv_sw_rate = outcomes["survived_switched"] / n_seeds
            surv_no_rate = outcomes["survived_never_switched"] / n_seeds
            collapse_rate = pre_rate + post_rate

            cells.append(
                {
                    "rho_reward": rho_reward,
                    "rho_feat": rho_feat,
                    "verified_phi_dot": round(actual_dot, 6),
                    "x0": x0,
                    "renewal": renewal,
                    "warn_onset": warn_onset,
                    "n_seeds": n_seeds,
                    "pre_switch_death_rate": round(pre_rate, 4),
                    "post_switch_death_rate": round(post_rate, 4),
                    "survived_switched_rate": round(surv_sw_rate, 4),
                    "survived_never_switched_rate": round(surv_no_rate, 4),
                    "collapse_rate": round(collapse_rate, 4),
                    "n_switched_before_death": len(cond_switch_times),
                    "mean_switch_time_conditional": (
                        round(sum(cond_switch_times) / len(cond_switch_times), 3)
                        if cond_switch_times
                        else None
                    ),
                    "mean_switch_time_competing_risk_imputed": round(
                        sum(imputed_switch_times) / n_seeds, 3
                    ),
                    "mean_death_time_conditional": (
                        round(sum(cond_death_times) / len(cond_death_times), 3)
                        if cond_death_times
                        else None
                    ),
                    "mean_first_event_time": round(sum(event_times) / n_seeds, 3),
                    "mean_final_x": round(sum(final_xs) / n_seeds, 3),
                }
            )

    return {
        "fixed_environment": {
            "x0": x0,
            "renewal": renewal,
            "warn_onset": warn_onset,
            "x_crit": x_crit,
            "cap": cap,
            "horizon": horizon,
            "lr": lr,
            "eps": eps,
            "n_seeds": n_seeds,
        },
        "rho_reward_grid": rho_reward_grid,
        "rho_feat_grid": rho_feat_grid,
        "cells": cells,
    }


def run_stochastic_breach_bound_check(
    n_trials: int = 400,
    seed_base: int = 20261125,
) -> Dict[str, Any]:
    """Empirically check `Pr(breach by T) <= Pr(C_T > B) + eta` across stochastic delay/spike regimes."""
    # PacedStock 1A parameters from stress_test.py.txt
    N, H1, H2, y2, Y, R_safe = 3, 4.0, 1.0, 2.0, 1.0, 1.0
    floor = H2 + y2  # 3.0
    L = 2 * N - 1    # 5
    horizon = 80

    # Check finite-sample Hoeffding margin eta (at 99.9% confidence) AND raw eta = 0.0
    eta_hoeffding = math.sqrt(math.log(2.0 / 0.001) / (2.0 * n_trials))
    regimes = [
        (x0, sigma, p_spike)
        for x0 in (27.0, 33.0, 39.0)
        for sigma, p_spike in (
            (0.0, 0.0),
            (1.5, 0.0),
            (3.0, 0.0),
            (5.0, 0.0),
            (0.0, 0.15),
            (0.0, 0.30),
            (3.0, 0.15),
            (5.0, 0.25),
        )
    ]

    rows: List[Dict[str, Any]] = []
    for r_idx, (x0, sigma, p_spike) in enumerate(regimes):
        B = x0 - floor
        breached_cnt = 0
        c_excursion_gt_B = 0
        c_surrogate_gt_B = 0

        for s in range(n_trials):
            rng = random.Random(seed_base + r_idx * 5000 + s)
            x = x0
            switched = False
            switch_t = horizon
            span_obs: List[float] = []
            cum_net_draw = 0.0
            max_net_draw = 0.0
            total_spike_draw = 0.0
            breached = False

            for t in range(horizon):
                base_d = H2 if switched else H1
                spike = 4.0 if (not switched and rng.random() < p_spike) else 0.0
                draw = base_d + spike
                give = R_safe if switched else Y
                total_spike_draw += spike

                # Telemetry observation (delayed classification over L-step blocks)
                obs_val = base_d + (rng.gauss(0.0, sigma) if sigma > 0.0 else 0.0)
                span_obs.append(obs_val)

                cum_net_draw += draw - give
                if cum_net_draw > max_net_draw:
                    max_net_draw = cum_net_draw

                if x < draw:
                    x = 0.0
                    breached = True
                    break
                x = x - draw + give
                if x < floor:
                    breached = True
                    break

                if (t + 1) % L == 0 and not switched:
                    if sum(span_obs) / len(span_obs) > 2.5:
                        switched = True
                        switch_t = t + 1
                    span_obs = []

            if x < floor:
                breached = True

            # Pre-switch delay + spike cumulative cost C_T
            c_surrogate = switch_t * (H1 - Y) + total_spike_draw
            if breached:
                breached_cnt += 1
            if max_net_draw > B:
                c_excursion_gt_B += 1
            if c_surrogate > B:
                c_surrogate_gt_B += 1

        pr_breach = breached_cnt / n_trials
        pr_excursion = c_excursion_gt_B / n_trials
        pr_surrogate = c_surrogate_gt_B / n_trials

        # Exact pathwise excursion bound holds with eta = 0.0
        assert pr_breach <= pr_excursion + 1e-12, (x0, sigma, p_spike, pr_breach, pr_excursion)
        # Surrogate delay+spike bound holds cleanly within eta = 0.0 (or Hoeffding slack)
        assert pr_breach <= pr_surrogate + eta_hoeffding, (
            x0,
            sigma,
            p_spike,
            pr_breach,
            pr_surrogate,
        )

        rows.append(
            {
                "x0": x0,
                "floor": floor,
                "headroom_B": B,
                "sigma": sigma,
                "p_spike": p_spike,
                "n_trials": n_trials,
                "pr_breach_by_T": round(pr_breach, 4),
                "pr_C_excursion_gt_B": round(pr_excursion, 4),
                "pr_C_delay_spike_gt_B": round(pr_surrogate, 4),
                "eta_hoeffding_999": round(eta_hoeffding, 4),
                "bound_holds_exact_eta_zero": pr_breach <= pr_excursion + 1e-12,
                "bound_holds_surrogate_eta_zero": pr_breach <= pr_surrogate + 1e-12,
                "bound_holds_surrogate_with_eta": pr_breach <= pr_surrogate + eta_hoeffding,
            }
        )

    return {
        "horizon_T": horizon,
        "lag_L": L,
        "floor": floor,
        "n_trials_per_regime": n_trials,
        "all_exact_bounds_hold_eta_zero": all(r["bound_holds_exact_eta_zero"] for r in rows),
        "all_surrogate_bounds_hold_with_eta": all(
            r["bound_holds_surrogate_with_eta"] for r in rows
        ),
        "regimes": rows,
    }


def generate_phase2_disentangled(write: bool = True) -> Dict[str, Any]:
    sweep = run_disentangled_2d_sweep()
    bound_check = run_stochastic_breach_bound_check()
    out = {
        "ai_written": "Track S3 (24 November 2026), disentangled Phase 2 CPU stress sweep",
        "disentangled_2d_sweep": sweep,
        "stochastic_breach_bound_check": bound_check,
    }
    if write:
        FIXTURE_PATH.parent.mkdir(parents=True, exist_ok=True)
        FIXTURE_PATH.write_text(json.dumps(out, indent=2) + "\n", encoding="utf-8")
    return out


def main() -> int:
    res = generate_phase2_disentangled(write=True)
    cells = res["disentangled_2d_sweep"]["cells"]
    by_key = {(c["rho_reward"], c["rho_feat"]): c for c in cells}
    print(
        json.dumps(
            {
                "grid_cells": len(cells),
                "sample_r14_f00": {
                    k: by_key[(1.4, 0.0)][k]
                    for k in ("pre_switch_death_rate", "collapse_rate", "mean_switch_time_competing_risk_imputed")
                },
                "sample_r14_f98": {
                    k: by_key[(1.4, 0.98)][k]
                    for k in ("pre_switch_death_rate", "collapse_rate", "mean_switch_time_competing_risk_imputed")
                },
                "all_exact_bounds_hold_eta_zero": res["stochastic_breach_bound_check"]["all_exact_bounds_hold_eta_zero"],
                "all_surrogate_bounds_hold_with_eta": res["stochastic_breach_bound_check"]["all_surrogate_bounds_hold_with_eta"],
            }
        )
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
