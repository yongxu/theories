#!/usr/bin/env python3
"""Paired rolling-PCA + supervised linear head intervention arm (Wave 2 B3).

AI-written (Wave 2, 24 November 2026). Uses `d=2, n=64, λ=3.0, σ²=1/16`, `64`
paired streams (`seed = 5_000_000 + i`), ring-buffer second moments, linear
online head `θ ← θ + (1 - θ^T z) z / 32`, and initial headroom `24` with one
pending aggressive action.
"""
from __future__ import annotations

import math
import random
import sys
from collections import deque
from typing import Any, Deque, Dict, List, Tuple

sys.dont_write_bytecode = True


def _sample_obs(rng: random.Random, sigma: float, lam: float, spike_axis: int) -> Tuple[float, float]:
    """Sample independent 2D zero-mean Gaussian with covariance `sigma^2 I + lam e_k e_k^T`."""
    std_spike = math.sqrt(sigma * sigma + lam)
    std_noise = sigma
    if spike_axis == 0:
        return rng.gauss(0.0, std_spike), rng.gauss(0.0, std_noise)
    return rng.gauss(0.0, std_noise), rng.gauss(0.0, std_spike)


def _top_feature(sum_u2: float, sum_v2: float, sum_uv: float, n: int) -> Tuple[float, float, bool]:
    """Compute sign-invariant `z = (w_u^2, w_v^2)` and cone membership `w_v^2 >= 3 w_u^2`."""
    a = sum_u2 / n
    d0 = sum_v2 / n
    c = sum_uv / n
    delta = d0 - a
    disc = math.hypot(delta, 2.0 * c)
    if disc == 0.0:
        # Tie-break selects v-axis when delta == c == 0
        return 0.0, 1.0, True
    wv2 = 0.5 * (1.0 + delta / disc)
    wu2 = 0.5 * (1.0 - delta / disc)
    in_cone = (delta >= 0.0) and (3.0 * delta * delta >= 4.0 * c * c)
    return wu2, wv2, in_cone


def predict_b3() -> Dict[str, Any]:
    return {
        "d": 2,
        "n": 64,
        "lam": 3.0,
        "sigma2": 1.0 / 16.0,
        "n_streams": 64,
        "horizon_post_change": 64,
        "initial_headroom": 24,
        "initial_pending_aggressive": True,
        "theta_init": [-1.0, -0.125],
        "theta_lr": 1.0 / 32.0,
        "clamped_z": [0.0, 1.0],
        "expected_causal_pattern": (
            "Clamping z=(0,1) eliminates covariance-window estimator delay; residual head-update lag "
            "and 1-step pending-action latency remain empirical tests."
        ),
    }


def evaluate_b3_heldout() -> Dict[str, Any]:
    n_win = 64
    sigma = math.sqrt(1.0 / 16.0)
    lam = 3.0
    n_streams = 64
    horizon = 64
    lr = 1.0 / 32.0

    streams: List[Dict[str, Any]] = []
    early_before_cone_natural = 0
    clamped_advanced_request = 0
    clamped_advanced_exec = 0

    for i in range(n_streams):
        rng = random.Random(5_000_000 + i)
        buf: Deque[Tuple[float, float]] = deque(maxlen=n_win)
        sum_u2 = 0.0
        sum_v2 = 0.0
        sum_uv = 0.0
        for _ in range(n_win):
            u, v = _sample_obs(rng, sigma, lam, spike_axis=0)
            buf.append((u, v))
            sum_u2 += u * u
            sum_v2 += v * v
            sum_uv += u * v

        # Draw exact shared post-change observation stream
        post_obs = [_sample_obs(rng, sigma, lam, spike_axis=1) for _ in range(horizon)]

        # Run Natural vs Clamped twins side by side on identical post_obs
        theta_nat = [-1.0, -0.125]
        theta_clm = [-1.0, -0.125]
        x_nat, x_clm = 24, 24
        pend_agg_nat, pend_agg_clm = True, True
        col_nat, col_clm = False, False

        t_cone_hit: int | None = None
        t_req_nat: int | None = None
        t_req_nat_pre_collapse: int | None = None
        t_exec_nat: int | None = None
        t_nr_nat: int | None = None
        prot_exec_count_nat = 0
        relapsed_after_prot_nat = False
        theta1_at_relapse_nat: float | None = None
        t_req_clm: int | None = None
        t_exec_clm: int | None = None
        t_nr_clm: int | None = None
        head_updates_clm = 0
        updates_before_req_clm: int | None = None
        x_at_first_exec_clm: int | None = None

        for idx, (u_new, v_new) in enumerate(post_obs):
            t_post = idx + 1  # number of post-change observations incorporated
            u_old, v_old = buf[0]
            sum_u2 += u_new * u_new - u_old * u_old
            sum_v2 += v_new * v_new - v_old * v_old
            sum_uv += u_new * v_new - u_old * v_old
            buf.append((u_new, v_new))

            wu2, wv2, in_cone = _top_feature(sum_u2, sum_v2, sum_uv, n_win)
            z_nat = (wu2, wv2)
            z_clm = (0.0, 1.0)

            if in_cone and t_cone_hit is None:
                t_cone_hit = t_post

            # Pre-execution no-return check: x <= 1_{pending=aggressive}
            if not col_nat and t_nr_nat is None and x_nat <= (1 if pend_agg_nat else 0):
                t_nr_nat = t_post
            if not col_clm and t_nr_clm is None and x_clm <= (1 if pend_agg_clm else 0):
                t_nr_clm = t_post

            # 1) Execute pending action
            if not col_nat:
                if pend_agg_nat:
                    x_nat = max(0, x_nat - 1)
                else:
                    prot_exec_count_nat += 1
                    if t_exec_nat is None:
                        t_exec_nat = t_post
                if x_nat <= 0:
                    col_nat = True
            if not col_clm:
                if pend_agg_clm:
                    x_clm = max(0, x_clm - 1)
                elif t_exec_clm is None:
                    t_exec_clm = t_post
                    x_at_first_exec_clm = x_clm
                if x_clm <= 0:
                    col_clm = True

            # 2) Decision + head update (continue shadow policy head even if collapsed!)
            score_nat = theta_nat[0] * z_nat[0] + theta_nat[1] * z_nat[1]
            req_prot_nat = score_nat >= 0.0
            if req_prot_nat:
                if t_req_nat is None:
                    t_req_nat = t_post
                if not col_nat and t_req_nat_pre_collapse is None:
                    t_req_nat_pre_collapse = t_post
            elif (not col_nat) and (t_exec_nat is not None) and (not relapsed_after_prot_nat):
                relapsed_after_prot_nat = True
                theta1_at_relapse_nat = theta_nat[1]
            err_nat = 1.0 - score_nat
            theta_nat[0] += lr * err_nat * z_nat[0]
            theta_nat[1] += lr * err_nat * z_nat[1]
            pend_agg_nat = not req_prot_nat

            score_clm = theta_clm[0] * z_clm[0] + theta_clm[1] * z_clm[1]
            req_prot_clm = score_clm >= 0.0
            if req_prot_clm and t_req_clm is None:
                t_req_clm = t_post
                updates_before_req_clm = head_updates_clm
            err_clm = 1.0 - score_clm
            theta_clm[0] += lr * err_clm * z_clm[0]
            theta_clm[1] += lr * err_clm * z_clm[1]
            head_updates_clm += 1
            pend_agg_clm = not req_prot_clm

        if t_exec_nat is not None and (t_cone_hit is None or t_exec_nat < t_cone_hit):
            early_before_cone_natural += 1
        if t_req_clm is not None and (t_req_nat is None or t_req_clm < t_req_nat):
            clamped_advanced_request += 1
        if t_exec_clm is not None and (t_exec_nat is None or t_exec_clm < t_exec_nat):
            clamped_advanced_exec += 1

        streams.append({
            "stream": i,
            "t_cone_hit": t_cone_hit,
            "t_req_nat": t_req_nat,
            "t_req_nat_pre_collapse": t_req_nat_pre_collapse,
            "t_exec_nat": t_exec_nat,
            "t_nr_nat": t_nr_nat,
            "prot_exec_count_nat": prot_exec_count_nat,
            "relapsed_after_prot_nat": relapsed_after_prot_nat,
            "theta1_at_relapse_nat": theta1_at_relapse_nat,
            "col_nat": col_nat,
            "x_end_nat": x_nat,
            "t_req_clm": t_req_clm,
            "t_exec_clm": t_exec_clm,
            "t_nr_clm": t_nr_clm,
            "updates_before_req_clm": updates_before_req_clm,
            "x_at_first_exec_clm": x_at_first_exec_clm,
            "col_clm": col_clm,
            "x_end_clm": x_clm,
        })

    def stats(key: str) -> Dict[str, Any]:
        vals = [s[key] for s in streams if s[key] is not None]
        censored = sum(1 for s in streams if s[key] is None)
        return {
            "count": len(vals),
            "censored": censored,
            "mean": (sum(vals) / len(vals)) if vals else None,
            "min": min(vals) if vals else None,
            "max": max(vals) if vals else None,
        }

    req_shifts = [
        (s["t_req_nat"] if s["t_req_nat"] is not None else 65) - (s["t_req_clm"] if s["t_req_clm"] is not None else 65)
        for s in streams
    ]
    prot_before_nr_nat = sum(1 for s in streams if s["t_exec_nat"] is not None and (s["t_nr_nat"] is None or s["t_exec_nat"] < s["t_nr_nat"]))
    prot_before_nr_clm = sum(1 for s in streams if s["t_exec_clm"] is not None and (s["t_nr_clm"] is None or s["t_exec_clm"] < s["t_nr_clm"]))
    uncensored_nat = [s for s in streams if s["t_exec_nat"] is not None]
    relapsed_nat = [s for s in streams if s["t_exec_nat"] is not None and s["col_nat"]]
    relapsed_prot_counts = [s["prot_exec_count_nat"] for s in relapsed_nat]
    relapse_thetas = [s["theta1_at_relapse_nat"] for s in relapsed_nat if s["theta1_at_relapse_nat"] is not None]
    clamped_adv_exec_uncensored = sum(
        1 for s in uncensored_nat if s["t_exec_clm"] is not None and s["t_exec_clm"] < s["t_exec_nat"]
    )
    post_collapse_shadow_reqs = sum(1 for s in streams if s["t_req_nat"] is not None and s["t_req_nat_pre_collapse"] is None)

    return {
        "n_streams": n_streams,
        "collapse_count_natural": sum(1 for s in streams if s["col_nat"]),
        "collapse_count_clamped": sum(1 for s in streams if s["col_clm"]),
        "protected_before_noreturn_natural": prot_before_nr_nat,
        "protected_before_noreturn_clamped": prot_before_nr_clm,
        "post_collapse_shadow_request_only_natural": post_collapse_shadow_reqs,
        "relapsed_after_prot_exec_natural": len(relapsed_nat),
        "relapsed_prot_exec_count_range": [min(relapsed_prot_counts), max(relapsed_prot_counts)] if relapsed_prot_counts else None,
        "relapsed_theta1_range": [min(relapse_thetas), max(relapse_thetas)] if relapse_thetas else None,
        "early_prot_exec_before_cone_natural": early_before_cone_natural,
        "clamped_advanced_request_streams": clamped_advanced_request,
        "clamped_advanced_exec_streams": clamped_advanced_exec,
        "clamped_advanced_exec_uncensored_streams": clamped_adv_exec_uncensored,
        "paired_request_time_shift_mean": sum(req_shifts) / len(req_shifts),
        "t_cone_hit": stats("t_cone_hit"),
        "t_req_nat": stats("t_req_nat"),
        "t_req_nat_pre_collapse": stats("t_req_nat_pre_collapse"),
        "t_exec_nat": stats("t_exec_nat"),
        "t_req_clm": stats("t_req_clm"),
        "t_exec_clm": stats("t_exec_clm"),
        "x_at_first_exec_clm": stats("x_at_first_exec_clm"),
        "mean_head_updates_clamped_before_req": stats("updates_before_req_clm")["mean"],
    }
