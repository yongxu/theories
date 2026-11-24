#!/usr/bin/env python3
"""Finite-horizon specialization, real REINFORCE training, exact 53-bit extraction,
and exact/statistical B1 & B2 verification on `PacedReserveEnv`.

AI-written (Wave 2, 24 November 2026). Imports `neural-alignment-stress-lab` and
`guarded-alignment-runtime` strictly read-only.
"""
from __future__ import annotations

import copy
import hashlib
import json
import math
import random
import sys
from collections import deque
from fractions import Fraction
from pathlib import Path
from typing import Any, Callable, Dict, Iterable, List, Mapping, Sequence, Tuple

sys.dont_write_bytecode = True

REPO_ROOT = next(p for p in Path(__file__).resolve().parents if (p / "tools" / "research" / "style.py").is_file())
STRESS_LAB_DIR = REPO_ROOT / "experiments" / "neural-alignment-stress-lab"
RUNTIME_DIR = REPO_ROOT / "experiments" / "guarded-alignment-runtime"

for extra in (STRESS_LAB_DIR, RUNTIME_DIR):
    s = str(extra)
    if s not in sys.path:
        sys.path.insert(0, s)

from nn_core import ReinforcePolicy, sample_categorical  # noqa: E402
from substrates import PacedConfig, PacedReserveEnv  # noqa: E402
from guarded_alignment.observational_fidelity import (  # noqa: E402
    FinDist,
    FinKernel,
    metric_slack,
    pushforward,
    tv_dist,
)
from guarded_alignment.proposal_audit import check_survival_distinguishability  # noqa: E402

MICRO_STATES: Tuple[int, ...] = (0, 1, 2, 3, 4)
LIVE_STATES: Tuple[int, ...] = (1, 2, 3, 4)
MACRO_STATES: Tuple[str, ...] = ("D", "1", "2", "H")
F_MAP: Dict[int, str] = {0: "D", 1: "1", 2: "2", 3: "H", 4: "H"}
D0: int = 1 << 53
SCALE_54: int = 1 << 54


def macro_of(x: int) -> str:
    return F_MAP[x]


def make_paced_env(mode: int, start_x: int, seed: int = 0) -> PacedReserveEnv:
    """Construct the already-paced branch of `PacedReserveEnv`."""
    if mode not in (1, 2):
        raise ValueError(f"mode must be 1 or 2, got {mode}")
    if start_x not in MICRO_STATES:
        raise ValueError(f"start_x must be in 0..4, got {start_x}")
    cfg = PacedConfig(
        x0=4.0,
        x_floor=0.0,
        h1_draw=float(1 + mode),
        h2_draw=1.0,
        renewal_abundant=4.0,
        renewal_paced=1.0,
        renewal_recover=1.0,
        lag=1,
        abundant_steps=0,
        paced_steps=64,
        rho=0.0,
    )
    env = PacedReserveEnv(cfg, random.Random(seed))
    env.t = 0
    env.reserve = float(start_x)
    env.collapsed = start_x == 0
    env.min_reserve = float(start_x)
    env.warning_queue = deque([True])
    env.reserve_queue = deque([float(start_x)])
    return env


def set_env_mode(env: PacedReserveEnv, mode: int) -> None:
    if mode not in (1, 2):
        raise ValueError(f"mode must be 1 or 2, got {mode}")
    env.cfg.h1_draw = float(1 + mode)


def serialize_policy(policy: ReinforcePolicy) -> Dict[str, Any]:
    return {
        "w1": [[float(x).hex() for x in row] for row in policy.net.w1],
        "b1": [float(x).hex() for x in policy.net.b1],
        "w2": [[float(x).hex() for x in row] for row in policy.net.w2],
        "b2": [float(x).hex() for x in policy.net.b2],
        "baseline": float(policy.baseline).hex(),
    }


def load_policy(blob: Mapping[str, Any]) -> ReinforcePolicy:
    pol = ReinforcePolicy(6, 4, 2, random.Random(0))
    pol.net.w1 = [[float.fromhex(x) for x in row] for row in blob["w1"]]
    pol.net.b1 = [float.fromhex(x) for x in blob["b1"]]
    pol.net.w2 = [[float.fromhex(x) for x in row] for row in blob["w2"]]
    pol.net.b2 = [float.fromhex(x) for x in blob["b2"]]
    pol.baseline = float.fromhex(blob["baseline"])
    return pol


def policy_digest(blob: Mapping[str, Any]) -> str:
    return hashlib.sha256(json.dumps(blob, sort_keys=True).encode("utf-8")).hexdigest()


def exact_action0_prob(policy: ReinforcePolicy, x: int) -> Tuple[float, Fraction]:
    """Exact binary64 action-0 probability on CPython 53-bit `Random.random()`."""
    if x not in LIVE_STATES:
        raise ValueError(f"expected live state 1..4, got {x}")
    env = make_paced_env(1, x)
    feat = env.make_features(True, float(x), noise_std=0.0)
    p = policy.action_probs(feat)[0]
    num, den = p.as_integer_ratio()
    floor_d0p = (num * D0) // den
    q_exact = Fraction(min(D0, floor_d0p + 1), D0)
    return p, q_exact


def action_prob_snapshot(policy: ReinforcePolicy) -> Dict[str, Dict[str, Any]]:
    out: Dict[str, Dict[str, Any]] = {}
    for x in LIVE_STATES:
        p, q = exact_action0_prob(policy, x)
        out[str(x)] = {"p_float": p, "q_exact_num": q.numerator, "q_exact_den": q.denominator}
    return out


def train_real_learner() -> Dict[str, Any]:
    """Train `ReinforcePolicy(6, 4, 2)` on `PacedReserveEnv`; emit ckpt_0 (ep 4) & ckpt_1 (ep 16)."""
    policy = ReinforcePolicy(6, 4, 2, random.Random(41001))
    init_blob = serialize_policy(policy)
    init_probs = action_prob_snapshot(policy)
    ckpt_0: Dict[str, Any] | None = None
    ckpt_1: Dict[str, Any] | None = None
    total_updates = 0

    for ep in range(16):
        rng = random.Random(41100 + ep)
        x0 = rng.choice(LIVE_STATES)
        env = make_paced_env(1, x0, seed=41100 + ep)
        for _ in range(8):
            if env.collapsed:
                break
            mode = rng.choice((1, 2))
            set_env_mode(env, mode)
            cur_x = int(round(env.reserve))
            feat = env.make_features(True, float(cur_x), noise_std=0.0)
            action, _ = policy.act(feat, rng)
            reward, _done, _info = env.step(action)
            policy.update_step(
                feat,
                action,
                reward,
                lr=0.015,
                baseline_decay=0.10,
                entropy_coef=0.01,
            )
            total_updates += 1
        if ep == 3:
            ckpt_0 = serialize_policy(policy)
        elif ep == 15:
            ckpt_1 = serialize_policy(policy)

    if ckpt_0 is None or ckpt_1 is None:
        raise RuntimeError("Missing expected checkpoints during training")
    p_init = {k: v["p_float"] for k, v in init_probs.items()}
    p_0_snap = action_prob_snapshot(load_policy(ckpt_0))
    p_1_snap = action_prob_snapshot(load_policy(ckpt_1))
    max_shift_0 = max(abs(p_0_snap[k]["p_float"] - p_init[k]) for k in p_init)
    max_shift_1 = max(abs(p_1_snap[k]["p_float"] - p_init[k]) for k in p_init)
    if max_shift_0 <= 1e-6 or max_shift_1 <= 1e-6:
        raise RuntimeError("Learner weights failed to shift meaningfully from initialization")

    return {
        "init": init_blob,
        "ckpt_0": ckpt_0,
        "ckpt_1": ckpt_1,
        "total_updates": total_updates,
        "probs": {
            "init": init_probs,
            "ckpt_0": p_0_snap,
            "ckpt_1": p_1_snap,
            "max_abs_shift_ckpt0": max_shift_0,
            "max_abs_shift_ckpt1": max_shift_1,
        },
        "digests": {
            "init": policy_digest(init_blob),
            "ckpt_0": policy_digest(ckpt_0),
            "ckpt_1": policy_digest(ckpt_1),
        },
    }


def extract_micro_kernel_rows(policy: ReinforcePolicy, mode: int) -> List[List[int]]:
    """5×5 dyadic micro transition matrix scaled by 2^54 (exact integers)."""
    rows = [[0] * 5 for _ in range(5)]
    # Scale D0 = 2^53 by 2 -> SCALE_54 = 2^54 so uniform 1/2 fiber mean at H is exact integer!
    rows[0][0] = SCALE_54
    for x in LIVE_STATES:
        _, q0 = exact_action0_prob(policy, x)
        scaled_q0 = q0 * SCALE_54
        if scaled_q0.denominator != 1:
            raise RuntimeError(f"Expected dyadic q0 under SCALE_54, got {q0}")
        num_q = scaled_q0.numerator
        num_1mq = SCALE_54 - num_q
        rows[x][x] += num_q
        nx_agg = max(0, x - mode)
        rows[x][nx_agg] += num_1mq
    return rows


def extract_macro_kernel_rows(micro_rows: List[List[int]]) -> List[List[int]]:
    """4×4 macro transition matrix L_j(o) = (1/|f^{-1}(o)|) ∑_{f(x)=o} f_* K_j(x) scaled by 2^54."""
    macro_idx = {"D": 0, "1": 1, "2": 2, "H": 3}

    def push_row(r: List[int]) -> List[int]:
        out = [0, 0, 0, 0]
        for y, val in enumerate(r):
            out[macro_idx[F_MAP[y]]] += val
        return out

    p0 = push_row(micro_rows[0])
    p1 = push_row(micro_rows[1])
    p2 = push_row(micro_rows[2])
    p3 = push_row(micro_rows[3])
    p4 = push_row(micro_rows[4])
    ph = [(a + b) // 2 for a, b in zip(p3, p4)]
    for x in range(4):
        if (p3[x] + p4[x]) % 2 != 0:
            raise RuntimeError("Unexpected odd numerator under 2^54 scaling")
    return [p0, p1, p2, ph]


def cross_check_runtime_observational_fidelity(policy: ReinforcePolicy) -> Dict[str, Any]:
    """Cross-check exact micro/macro rows via `guarded_alignment.observational_fidelity`."""
    checks: Dict[str, Any] = {}
    for mode in (1, 2):
        k_scaled = extract_micro_kernel_rows(policy, mode)
        l_scaled = extract_macro_kernel_rows(k_scaled)
        k_fk = FinKernel(
            src_carrier=MICRO_STATES,
            tgt_carrier=MICRO_STATES,
            rows={
                x: FinDist(MICRO_STATES, {y: Fraction(k_scaled[x][y], SCALE_54) for y in MICRO_STATES})
                for x in MICRO_STATES
            },
        )
        l_fk = FinKernel(
            src_carrier=MACRO_STATES,
            tgt_carrier=MACRO_STATES,
            rows={
                o: FinDist(
                    MACRO_STATES,
                    {o2: Fraction(l_scaled[MACRO_STATES.index(o)][MACRO_STATES.index(o2)], SCALE_54) for o2 in MACRO_STATES},
                )
                for o in MACRO_STATES
            },
        )
        row_defects_frac = {
            x: tv_dist(pushforward(macro_of, k_fk.rows[x], MACRO_STATES), l_fk.rows[macro_of(x)])
            for x in MICRO_STATES
        }
        row_defects = {str(x): float(v) for x, v in row_defects_frac.items()}
        dob = float(l_fk.max_tv_diff(l_fk))
        dob_l = max(tv_dist(l_fk.rows[o1], l_fk.rows[o2]) for o1 in MACRO_STATES for o2 in MACRO_STATES)
        checks[f"mode_{mode}"] = {
            "row_defects": row_defects,
            "max_row_defect_frac": str(max(row_defects_frac.values())),
            "dobrushin_L_frac": str(dob_l),
            "k_diff_self_zero": dob == 0.0,
        }
    return checks


def mat_mul_frac_exact(A: List[List[Fraction]], B: List[List[Fraction]]) -> List[List[Fraction]]:
    n = len(A)
    m = len(B[0])
    k_len = len(B)
    out = [[Fraction(0)] * m for _ in range(n)]
    for i in range(n):
        for j in range(m):
            s = Fraction(0)
            for k in range(k_len):
                s += A[i][k] * B[k][j]
            out[i][j] = s
    return out


def mat_mul_float_rows(A: List[List[float]], B: List[List[float]]) -> List[List[float]]:
    n = len(A)
    m = len(B[0])
    k_len = len(B)
    return [[sum(A[i][k] * B[k][j] for k in range(k_len)) for j in range(m)] for i in range(n)]


def build_exact_frac_matrices(policy: ReinforcePolicy) -> Tuple[Dict[int, List[List[Fraction]]], Dict[int, List[List[Fraction]]]]:
    k_frac: Dict[int, List[List[Fraction]]] = {}
    l_frac: Dict[int, List[List[Fraction]]] = {}
    for mode in (1, 2):
        kr = extract_micro_kernel_rows(policy, mode)
        lr = extract_macro_kernel_rows(kr)
        k_frac[mode] = [[Fraction(v, SCALE_54) for v in row] for row in kr]
        l_frac[mode] = [[Fraction(v, SCALE_54) for v in row] for row in lr]
    return k_frac, l_frac


def project_micro_row(row: Sequence[Any]) -> List[Any]:
    return [row[0], row[1], row[2], row[3] + row[4]]


def tv_rows(r1: Sequence[float], r2: Sequence[float]) -> float:
    return 0.5 * sum(abs(a - b) for a, b in zip(r1, r2))


def tv_rows_frac(r1: Sequence[Fraction], r2: Sequence[Fraction]) -> Fraction:
    return sum(abs(a - b) for a, b in zip(r1, r2)) / 2


def compute_b1_word_metrics(policy: ReinforcePolicy) -> Dict[str, Any]:
    """Compute exact dyadic & float block-word e(w), a(w), and conditional e+(w), a+(w) for m in {1,2,4,8}."""
    k_frac, l_frac = build_exact_frac_matrices(policy)
    # Build prefix tree up to depth 8 using integer-numerator scaling only for m <= 4 exact Fraction,
    # and fast exact/float with exact Fraction verification on the argmax words for m = 8!
    # Wait: how fast is exact Fraction matrix multiply across 510 5x5 matrices?
    # Note Fraction denominators grow linearly in bitlength (~54*8 = 432 bits per word!) -> Python arbitrary-int Fraction multiply for 510 matrices x 125 ops takes ~0.12s! Let's check exact Fractions cleanly!
    macro_idx_of_x = [0, 1, 2, 3, 3]
    word_blocks: Dict[int, Dict[str, Any]] = {}
    depth_max_e: Dict[int, Fraction] = {}
    depth_max_a: Dict[int, Fraction] = {}
    prefix_K: Dict[Tuple[int, ...], List[List[Fraction]]] = {(): [[Fraction(1 if i == j else 0) for j in range(5)] for i in range(5)]}
    prefix_L: Dict[Tuple[int, ...], List[List[Fraction]]] = {(): [[Fraction(1 if i == j else 0) for j in range(4)] for i in range(4)]}

    for depth in range(1, 9):
        next_words = [w + (m,) for w in prefix_K if len(w) == depth - 1 for m in (1, 2)]
        for w in next_words:
            pref = w[:-1]
            m = w[-1]
            prefix_K[w] = mat_mul_frac_exact(prefix_K[pref], k_frac[m])
            prefix_L[w] = mat_mul_frac_exact(prefix_L[pref], l_frac[m])

        best_e = Fraction(-1)
        best_e_info: Dict[str, Any] = {}
        best_a = Fraction(-1)
        best_a_info: Dict[str, Any] = {}
        for w in next_words:
            Kw = prefix_K[w]
            Lw = prefix_L[w]
            for x in MICRO_STATES:
                val = tv_rows_frac(project_micro_row(Kw[x]), Lw[macro_idx_of_x[x]])
                if val > best_e:
                    best_e = val
                    best_e_info = {"word": list(w), "state": x, "macro": MACRO_STATES[macro_idx_of_x[x]]}
            for i in range(4):
                for j in range(i + 1, 4):
                    val = tv_rows_frac(Lw[i], Lw[j])
                    if val > best_a:
                        best_a = val
                        best_a_info = {"word": list(w), "o1": MACRO_STATES[i], "o2": MACRO_STATES[j]}
        depth_max_e[depth] = best_e
        depth_max_a[depth] = best_a

        if depth in (1, 2, 4, 8):
            best_e_plus = Fraction(-1)
            best_a_plus = Fraction(-1)
            min_surv_denom = Fraction(2)

            for w in next_words:
                Kw = prefix_K[w]
                Lw = prefix_L[w]
                # Conditional live-normalized diagnostics e+(w), a+(w)
                pk_live_norm: List[List[Fraction]] = []
                for x in LIVE_STATES:
                    live_row = [Kw[x][1], Kw[x][2], Kw[x][3] + Kw[x][4]]
                    s_mass = sum(live_row)
                    if s_mass < min_surv_denom:
                        min_surv_denom = s_mass
                    pk_live_norm.append([v / s_mass for v in live_row] if s_mass > 0 else [Fraction(0)] * 3)
                pl_live_norm: List[List[Fraction]] = []
                for o_idx in (1, 2, 3):  # "1", "2", "H"
                    live_row = [Lw[o_idx][1], Lw[o_idx][2], Lw[o_idx][3]]
                    s_mass = sum(live_row)
                    if s_mass < min_surv_denom:
                        min_surv_denom = s_mass
                    pl_live_norm.append([v / s_mass for v in live_row] if s_mass > 0 else [Fraction(0)] * 3)
                for idx_x, x in enumerate(LIVE_STATES):
                    o_map_idx = (0, 1, 2, 2)[idx_x]
                    if sum(Kw[x][1:]) > 0 and sum(Lw[o_map_idx + 1][1:]) > 0:
                        val_p = tv_rows_frac(pk_live_norm[idx_x], pl_live_norm[o_map_idx])
                        if val_p > best_e_plus:
                            best_e_plus = val_p
                for i in range(3):
                    for j in range(i + 1, 3):
                        if sum(Lw[i + 1][1:]) > 0 and sum(Lw[j + 1][1:]) > 0:
                            val_a = tv_rows_frac(pl_live_norm[i], pl_live_norm[j])
                            if val_a > best_a_plus:
                                best_a_plus = val_a

            # Live mass in [0.1, 0.9] at start 3 and start 4 for all-1 and all-2 words
            w_all1 = (1,) * depth
            w_all2 = (2,) * depth
            first_ep_live = {
                "w_all1_s3": float(1 - prefix_K[w_all1][3][0]),
                "w_all1_s4": float(1 - prefix_K[w_all1][4][0]),
                "w_all2_s3": float(1 - prefix_K[w_all2][3][0]),
                "w_all2_s4": float(1 - prefix_K[w_all2][4][0]),
            }
            in_informative_band = any(0.1 <= v <= 0.9 for v in first_ep_live.values())

            eps_f = float(best_e)
            alp_f = float(best_a)
            non_vacuous = (best_e + best_a) < 1
            r_inf = float(best_e / (1 - best_a)) if best_a < 1 else None
            word_blocks[depth] = {
                "m": depth,
                "eps": eps_f,
                "eps_exact": f"{best_e.numerator}/{best_e.denominator}" if best_e.denominator <= 10**18 else None,
                "eps_argmax": best_e_info,
                "alpha": alp_f,
                "alpha_exact": f"{best_a.numerator}/{best_a.denominator}" if best_a.denominator <= 10**18 else None,
                "alpha_argmax": best_a_info,
                "eps_plus_alpha": float(best_e + best_a),
                "non_vacuous": non_vacuous,
                "r_inf": r_inf,
                "cond_e_plus": float(best_e_plus),
                "cond_a_plus": float(best_a_plus),
                "min_live_survival_denom": float(min_surv_denom),
                "first_endpoint_live_mass": first_ep_live,
                "informative_survival_band_01_09": in_informative_band,
            }
    if word_blocks[1]["alpha"] != 1.0:
        raise RuntimeError(f"Exact sanity check failed: expected alpha_1 == 1.0, got {word_blocks[1]['alpha']}")

    # Select smallest pre-registered m with eps_m + alpha_m < 1
    nonvac_ms = [m for m in (1, 2, 4, 8) if word_blocks[m]["non_vacuous"]]
    chosen_m = nonvac_ms[0] if nonvac_ms else None

    # Exact tube curves for m in {1, 2, 4, 8} across horizons t = 0..16 using exact Fraction metric_slack
    schedules: Dict[str, Tuple[int, ...]] = {
        "1^16": (1,) * 16,
        "2^16": (2,) * 16,
        "(12)^8": (1, 2) * 8,
        "(21)^8": (2, 1) * 8,
    }
    block_tubes: Dict[str, Any] = {}
    block_tubes_frac: Dict[str, List[Fraction]] = {}
    for m in (1, 2, 4, 8):
        eps_m = depth_max_e[m]
        alp_m = depth_max_a[m]
        r_steps_frac = [Fraction(0)]
        for t in range(1, 17):
            k = (t - 1) // m
            rem = t - k * m
            r_block_k = metric_slack(alp_m, eps_m, k, Fraction(0)) if alp_m < 1 else k * eps_m
            if rem == m:
                r_cur = metric_slack(alp_m, eps_m, k + 1, Fraction(0)) if alp_m < 1 else (k + 1) * eps_m
            else:
                r_cur = depth_max_e[rem] + depth_max_a[rem] * r_block_k
            r_steps_frac.append(r_cur)
        block_tubes_frac[str(m)] = r_steps_frac
        block_tubes[str(m)] = [float(v) for v in r_steps_frac]

    return {
        "k_frac": k_frac,
        "l_frac": l_frac,
        "tubes_frac": block_tubes_frac,
        "blocks": {str(k): v for k, v in word_blocks.items()},
        "chosen_m": chosen_m,
        "tubes": block_tubes,
        "two_step_path_bound_from_e1": min(1.0, 2.0 * word_blocks[1]["eps"]),
        "schedules": {k: list(v) for k, v in schedules.items()},
    }


def evaluate_b1_heldout(policy: ReinforcePolicy, b1_pred: Mapping[str, Any]) -> Dict[str, Any]:
    """Run 1,024 held-out PacedReserveEnv rollouts per (start, schedule) and check marginals, risks, and 2-step path."""
    b1_exact = compute_b1_word_metrics(policy)
    k_frac: Dict[int, List[List[Fraction]]] = b1_exact["k_frac"]
    l_frac: Dict[int, List[List[Fraction]]] = b1_exact["l_frac"]
    # Cache float action probs for fast exact sample_categorical fidelity on held-out streams
    cached_probs: Dict[int, List[float]] = {}
    for x in LIVE_STATES:
        env = make_paced_env(1, x)
        feat = env.make_features(True, float(x), noise_std=0.0)
        cached_probs[x] = policy.action_probs(feat)

    schedules: Dict[str, List[int]] = b1_pred["schedules"]
    n_rollouts = 1024
    # Family budget: 0.025 across J_tv=128 marginal checks (q=4 categories) + 0.025 across J_risk=256 Hoeffding bounds
    q_cats = 4
    j_tv = 128
    j_risk = 256
    tv_allow = math.sqrt(math.log((2 ** (q_cats + 1)) * j_tv / 0.025) / (2.0 * n_rollouts))
    risk_allow = math.sqrt(math.log(2.0 * j_risk / 0.025) / (2.0 * n_rollouts))

    # Reserve readout values h(x) = 1 - x/4 and macro fiber means
    h_cem = [1.0, 0.0, 0.0, 0.0, 0.0]
    b_cem = [1.0, 0.0, 0.0, 0.0]  # gamma = 0
    h_res = [1.0 - x / 4.0 for x in MICRO_STATES]  # [1.0, 0.75, 0.5, 0.25, 0.0]
    b_res = [1.0, 0.75, 0.5, 0.125]  # gamma = 1/8 = 0.125

    chosen_m = b1_pred["chosen_m"]
    tube_key = str(chosen_m) if chosen_m is not None else "8"
    chosen_tube = b1_pred["tubes"][tube_key]
    chosen_tube_frac: List[Fraction] = b1_exact["tubes_frac"][tube_key]

    max_emp_vs_exact_micro_tv = 0.0
    max_exact_tv_vs_macro = 0.0
    max_emp_tv_vs_macro = 0.0
    exact_tube_violations = 0
    emp_tube_violations = 0
    exact_risk_violations = 0
    emp_risk_violations = 0
    cell_summaries: Dict[str, Any] = {}

    # Track 2-step projected path laws for starts {3, 4} x schedules (all 4 prefixes of length 2 are {11, 22, 12, 21})
    path2_results: Dict[str, Any] = {}

    cell_idx = 0
    for start_x in (3, 4):
        for sched_name, sched in schedules.items():
            # Exact marginals t=0..16
            micro_dist = [Fraction(1 if x == start_x else 0) for x in MICRO_STATES]
            macro_dist = [Fraction(1 if o == F_MAP[start_x] else 0) for o in MACRO_STATES]
            exact_micro_unproj_frac: List[List[Fraction]] = []
            exact_micro_marginals_frac: List[List[Fraction]] = []
            exact_macro_marginals_frac: List[List[Fraction]] = []
            for m in sched:
                next_micro = [Fraction(0)] * 5
                for x in range(5):
                    for y in range(5):
                        next_micro[y] += micro_dist[x] * k_frac[m][x][y]
                next_macro = [Fraction(0)] * 4
                for o1 in range(4):
                    for o2 in range(4):
                        next_macro[o2] += macro_dist[o1] * l_frac[m][o1][o2]
                micro_dist = next_micro
                macro_dist = next_macro
                exact_micro_unproj_frac.append(micro_dist)
                exact_micro_marginals_frac.append(project_micro_row(micro_dist))
                exact_macro_marginals_frac.append(macro_dist)

            # Held-out empirical paths via PacedReserveEnv.step
            emp_counts = [[0, 0, 0, 0] for _ in range(16)]
            emp_h_cem_sums = [0.0] * 16
            emp_h_res_sums = [0.0] * 16
            path2_emp_counts: Dict[Tuple[str, str], int] = {}

            for rep in range(n_rollouts):
                seed = 1_000_000 + 10000 * cell_idx + rep
                rng = random.Random(seed)
                env = make_paced_env(sched[0], start_x, seed=seed)
                pair_obs: List[str] = []
                for t in range(16):
                    set_env_mode(env, sched[t])
                    cur_x = int(round(env.reserve))
                    if env.collapsed or cur_x == 0:
                        action = 0
                    else:
                        action = sample_categorical(cached_probs[cur_x], rng)
                    env.step(action)
                    nx = 0 if env.collapsed else int(round(env.reserve))
                    mo = F_MAP[nx]
                    m_idx = MACRO_STATES.index(mo)
                    emp_counts[t][m_idx] += 1
                    emp_h_cem_sums[t] += h_cem[nx]
                    emp_h_res_sums[t] += h_res[nx]
                    if t < 2:
                        pair_obs.append(mo)
                key2 = (pair_obs[0], pair_obs[1])
                path2_emp_counts[key2] = path2_emp_counts.get(key2, 0) + 1

            # Score marginals and risks at t = 1..16 using exact Fraction values for theoretical checks
            h_cem_frac = [Fraction(1), Fraction(0), Fraction(0), Fraction(0), Fraction(0)]
            b_cem_frac = [Fraction(1), Fraction(0), Fraction(0), Fraction(0)]
            h_res_frac = [Fraction(4 - x, 4) for x in MICRO_STATES]
            b_res_frac = [Fraction(1), Fraction(3, 4), Fraction(1, 2), Fraction(1, 8)]

            cell_max_tv_exact = 0.0
            cell_max_tv_emp = 0.0
            cell_max_impl_tv = 0.0
            for t in range(16):
                emp_m = [c / n_rollouts for c in emp_counts[t]]
                ex_u_frac = exact_micro_unproj_frac[t]
                ex_m_frac = exact_micro_marginals_frac[t]
                ex_L_frac = exact_macro_marginals_frac[t]
                ex_m = [float(v) for v in ex_m_frac]
                ex_L = [float(v) for v in ex_L_frac]

                impl_tv = tv_rows(emp_m, ex_m)
                tv_ex_frac = tv_rows_frac(ex_m_frac, ex_L_frac)
                tv_ex = float(tv_ex_frac)
                tv_em = tv_rows(emp_m, ex_L)
                tube_r = chosen_tube[t + 1]
                tube_r_frac = chosen_tube_frac[t + 1]
                cell_max_impl_tv = max(cell_max_impl_tv, impl_tv)
                cell_max_tv_exact = max(cell_max_tv_exact, tv_ex)
                cell_max_tv_emp = max(cell_max_tv_emp, tv_em)
                max_emp_vs_exact_micro_tv = max(max_emp_vs_exact_micro_tv, impl_tv)
                max_exact_tv_vs_macro = max(max_exact_tv_vs_macro, tv_ex)
                max_emp_tv_vs_macro = max(max_emp_tv_vs_macro, tv_em)
                if tv_ex_frac > tube_r_frac:
                    exact_tube_violations += 1
                if tv_em > tube_r + tv_allow:
                    emp_tube_violations += 1

                l_cem_exp_frac = sum(ex_L_frac[o] * b_cem_frac[o] for o in range(4))
                l_res_exp_frac = sum(ex_L_frac[o] * b_res_frac[o] for o in range(4))
                ex_c_diff_frac = abs(sum(ex_u_frac[x] * h_cem_frac[x] for x in range(5)) - l_cem_exp_frac)
                ex_r_diff_frac = abs(sum(ex_u_frac[x] * h_res_frac[x] for x in range(5)) - l_res_exp_frac)
                if ex_c_diff_frac > tv_ex_frac or ex_c_diff_frac > tube_r_frac:
                    exact_risk_violations += 1
                if ex_r_diff_frac > Fraction(1, 8) + tv_ex_frac or ex_r_diff_frac > Fraction(1, 8) + tube_r_frac:
                    exact_risk_violations += 1

                l_cem_exp = float(l_cem_exp_frac)
                l_res_exp = float(l_res_exp_frac)
                em_c_diff = abs(emp_h_cem_sums[t] / n_rollouts - l_cem_exp)
                em_r_diff = abs(emp_h_res_sums[t] / n_rollouts - l_res_exp)
                if em_c_diff > tube_r + risk_allow:
                    emp_risk_violations += 1
                if em_r_diff > 0.125 + tube_r + risk_allow:
                    emp_risk_violations += 1

            # 2-step exact Fraction projected path law vs L path law over fixed ordered macro pairs
            m0, m1 = sched[0], sched[1]
            o0 = MACRO_STATES.index(F_MAP[start_x])
            ordered_p2_keys = [(a1, a2) for a1 in MACRO_STATES for a2 in MACRO_STATES]
            p2_micro_frac: Dict[Tuple[str, str], Fraction] = {k: Fraction(0) for k in ordered_p2_keys}
            p2_macro_frac: Dict[Tuple[str, str], Fraction] = {k: Fraction(0) for k in ordered_p2_keys}
            for y1 in MICRO_STATES:
                w1 = k_frac[m0][start_x][y1]
                if w1 == 0:
                    continue
                for y2 in MICRO_STATES:
                    w2 = w1 * k_frac[m1][y1][y2]
                    if w2 > 0:
                        p2_micro_frac[(F_MAP[y1], F_MAP[y2])] += w2
            for a1_i, a1 in enumerate(MACRO_STATES):
                w1 = l_frac[m0][o0][a1_i]
                if w1 == 0:
                    continue
                for a2_i, a2 in enumerate(MACRO_STATES):
                    w2 = w1 * l_frac[m1][a1_i][a2_i]
                    if w2 > 0:
                        p2_macro_frac[(a1, a2)] += w2
            tv_p2_ex_frac = sum(abs(p2_micro_frac[k] - p2_macro_frac[k]) for k in ordered_p2_keys) / 2
            eps1_frac = Fraction(b1_pred["blocks"]["1"]["eps_exact"])
            bound_2e1_frac = min(Fraction(1), 2 * eps1_frac)
            p2_emp = {k: path2_emp_counts.get(k, 0) / n_rollouts for k in ordered_p2_keys}
            tv_p2_impl = 0.5 * sum(abs(p2_emp[k] - float(p2_micro_frac[k])) for k in ordered_p2_keys)
            path2_results[f"s{start_x}_{sched_name}"] = {
                "exact_path2_tv_micro_macro": float(tv_p2_ex_frac),
                "emp_vs_exact_micro_path2_tv": tv_p2_impl,
                "two_step_coupling_bound": float(bound_2e1_frac),
                "within_2e1_bound": tv_p2_ex_frac <= bound_2e1_frac,
            }

            cell_summaries[f"s{start_x}_{sched_name}"] = {
                "max_impl_tv": cell_max_impl_tv,
                "max_exact_tv_vs_macro": cell_max_tv_exact,
                "max_emp_tv_vs_macro": cell_max_tv_emp,
            }
            cell_idx += 1

    # Implementation sanity allowance uses conservative TV bound on q=4 across J_tv=128 (or per-cell):
    return {
        "chosen_m": chosen_m,
        "n_rollouts_per_cell": n_rollouts,
        "tv_allowance_0025": tv_allow,
        "risk_allowance_0025": risk_allow,
        "max_emp_vs_exact_micro_tv": max_emp_vs_exact_micro_tv,
        "impl_sanity_passed": max_emp_vs_exact_micro_tv <= tv_allow,
        "max_exact_tv_vs_macro": max_exact_tv_vs_macro,
        "max_emp_tv_vs_macro": max_emp_tv_vs_macro,
        "exact_tube_violations": exact_tube_violations,
        "emp_tube_violations_beyond_allow": emp_tube_violations,
        "exact_risk_violations": exact_risk_violations,
        "emp_risk_violations_beyond_allow": emp_risk_violations,
        "path2_summary": path2_results,
        "cells": cell_summaries,
    }


def wilson_ci_95(k: int, n: int) -> Tuple[float, float]:
    z = 1.959963984540054
    p = k / n
    denom = 1.0 + z * z / n
    center = (p + z * z / (2.0 * n)) / denom
    half = z * math.sqrt((p * (1.0 - p) + z * z / (4.0 * n)) / n) / denom
    return max(0.0, center - half), min(1.0, center + half)


def live_4x4_dict(policy: ReinforcePolicy, mode: int) -> Dict[str, Dict[str, str]]:
    """String-keyed rational 4×4 live survival rows for `check_survival_distinguishability`."""
    kr = extract_micro_kernel_rows(policy, mode)
    out: Dict[str, Dict[str, str]] = {}
    for x in LIVE_STATES:
        row: Dict[str, str] = {}
        for y in LIVE_STATES:
            val = Fraction(kr[x][y], SCALE_54)
            if val > 0:
                row[str(y)] = f"{val.numerator}/{val.denominator}"
        out[str(x)] = row
    return out


def compute_survival_from_mats(mats: Mapping[str, Mapping[str, Mapping[str, Fraction]]], word: Sequence[str], state: str, states: Sequence[str]) -> Fraction:
    vec = {s: Fraction(1) for s in states}
    for m in reversed(word):
        mat = mats[m]
        next_vec = {}
        for s in states:
            row = mat.get(s, {})
            next_vec[s] = sum(w * vec[t] for t, w in row.items())
        vec = next_vec
    return vec[state]


def parse_frac_mats(raw_modes: Mapping[str, Mapping[str, Mapping[str, str]]]) -> Dict[str, Dict[str, Dict[str, Fraction]]]:
    return {
        m: {src: {tgt: Fraction(val) for tgt, val in row.items()} for src, row in mat.items()}
        for m, mat in raw_modes.items()
    }


def predict_b2(ckpt_0_blob: Mapping[str, Any], ckpt_1_blob: Mapping[str, Any]) -> Dict[str, Any]:
    pol0 = load_policy(ckpt_0_blob)
    pol1 = load_policy(ckpt_1_blob)

    # Arm A: Frozen ckpt_1
    modes_A = {"1": live_4x4_dict(pol1, 1), "2": live_4x4_dict(pol1, 2)}
    audit_A = check_survival_distinguishability({
        "states": ["1", "2", "3", "4"],
        "state_a": "3",
        "state_b": "4",
        "modes": modes_A,
        "audit_horizon": 3,
        "allow_mode_switching": True,
    })
    mats_A = parse_frac_mats(modes_A)
    _, q1_3 = exact_action0_prob(pol1, 3)
    _, q1_2 = exact_action0_prob(pol1, 2)
    exact_12_s3 = compute_survival_from_mats(mats_A, ["1", "2"], "3", ["1", "2", "3", "4"])
    exact_12_s4 = compute_survival_from_mats(mats_A, ["1", "2"], "4", ["1", "2", "3", "4"])
    formula_s3 = Fraction(1) - (Fraction(1) - q1_3) * (Fraction(1) - q1_2)
    if exact_12_s3 != formula_s3 or exact_12_s4 != Fraction(1):
        raise RuntimeError(f"Arm A sanity check mismatch: {exact_12_s3} vs {formula_s3}, s4={exact_12_s4}")

    # Arm B: Exogenous alternating ckpt_0, ckpt_1, ...
    modes_B = {
        "1_c0": live_4x4_dict(pol0, 1),
        "1_c1": live_4x4_dict(pol1, 1),
        "2_c0": live_4x4_dict(pol0, 2),
        "2_c1": live_4x4_dict(pol1, 2),
    }
    audit_B_4state = check_survival_distinguishability({
        "states": ["1", "2", "3", "4"],
        "state_a": "3",
        "state_b": "4",
        "modes": modes_B,
        "audit_horizon": 3,
        "allow_mode_switching": True,
    })
    # Phase-augmented S_alive x Fin 2 for strictly alternating schedules (cutoff 8 - 1 = 7)
    modes_B_phase: Dict[str, Dict[str, Dict[str, str]]] = {"1": {}, "2": {}}
    for m_str in ("1", "2"):
        for src in ("1", "2", "3", "4"):
            modes_B_phase[m_str][f"{src}_p0"] = {f"{tgt}_p1": w for tgt, w in modes_B[f"{m_str}_c0"].get(src, {}).items()}
            modes_B_phase[m_str][f"{src}_p1"] = {f"{tgt}_p0": w for tgt, w in modes_B[f"{m_str}_c1"].get(src, {}).items()}
    audit_B_phase = check_survival_distinguishability({
        "states": [f"{s}_p{p}" for p in (0, 1) for s in ("1", "2", "3", "4")],
        "state_a": "3_p0",
        "state_b": "4_p0",
        "modes": modes_B_phase,
        "audit_horizon": 7,
        "allow_mode_switching": True,
    })
    mats_B = parse_frac_mats(modes_B)
    _, q0_3 = exact_action0_prob(pol0, 3)
    exact_B_12_s3 = compute_survival_from_mats(mats_B, ["1_c0", "2_c1"], "3", ["1", "2", "3", "4"])
    formula_B_s3 = Fraction(1) - (Fraction(1) - q0_3) * (Fraction(1) - q1_2)
    if exact_B_12_s3 != formula_B_s3:
        raise RuntimeError(f"Arm B formula mismatch: {exact_B_12_s3} vs {formula_B_s3}")

    sched_B_alt12 = ["1_c0", "2_c1", "1_c0", "2_c1", "1_c0", "2_c1", "1_c0", "2_c1"]
    sched_B_alt21 = ["2_c0", "1_c1", "2_c0", "1_c1", "2_c0", "1_c1", "2_c0", "1_c1"]

    # Arm C: Online non-stationary updates from ckpt_1 at x=1, j=1
    def run_online_prefix(n_restrain: int, learning: bool) -> Dict[str, Any]:
        pol = load_policy(ckpt_1_blob)
        log_prob_sum = 0.0
        for _ in range(n_restrain):
            env = make_paced_env(1, 1)
            feat = env.make_features(True, 1.0, noise_std=0.0)
            p0, _ = exact_action0_prob(pol, 1)
            log_prob_sum += math.log(max(p0, 1e-12))
            reward, _, _ = env.step(0)
            if learning:
                pol.update_step(feat, 0, reward, lr=0.25, baseline_decay=0.10, entropy_coef=0.0, weight_decay=0.0)
        p_term, q_term = exact_action0_prob(pol, 1)
        blob = serialize_policy(pol)
        return {
            "n_steps": n_restrain,
            "learning": learning,
            "prefix_prob": math.exp(log_prob_sum),
            "baseline": pol.baseline,
            "weight_digest": policy_digest(blob),
            "terminal_p0_float": p_term,
            "terminal_q0_exact": float(q_term),
            "terminal_q0_num": q_term.numerator,
            "terminal_q0_den": q_term.denominator,
            "policy_blob": blob,
        }

    c_1 = run_online_prefix(1, True)
    c_24 = run_online_prefix(24, True)
    c_1_frozen = run_online_prefix(1, False)
    c_24_frozen = run_online_prefix(24, False)

    # Equal-clock negative control: start x=2, mode 1, [aggressive, restrain x 23] vs [restrain x 23, aggressive]
    def run_equal_clock(agg_first: bool, learning: bool) -> Dict[str, Any]:
        pol = load_policy(ckpt_1_blob)
        env = make_paced_env(1, 2)
        seq = [1] + [0] * 23 if agg_first else [0] * 23 + [1]
        log_prob_sum = 0.0
        for act in seq:
            cur_x = int(round(env.reserve))
            feat = env.make_features(True, float(cur_x), noise_std=0.0)
            probs = pol.action_probs(feat)
            log_prob_sum += math.log(max(probs[act], 1e-12))
            reward, _, _ = env.step(act)
            if learning:
                pol.update_step(feat, act, reward, lr=0.25, baseline_decay=0.10, entropy_coef=0.0, weight_decay=0.0)
        if env.collapsed or int(round(env.reserve)) != 1:
            raise RuntimeError("Equal-clock control failed to end alive at x=1")
        p_term, q_term = exact_action0_prob(pol, 1)
        return {
            "terminal_x": int(round(env.reserve)),
            "prefix_prob": math.exp(log_prob_sum),
            "terminal_q0_exact": float(q_term),
            "weight_digest": policy_digest(serialize_policy(pol)),
            "policy_blob": serialize_policy(pol),
        }

    eq_clock_agg_first = run_equal_clock(True, True)
    eq_clock_agg_last = run_equal_clock(False, True)

    def safe_witness(w: Any) -> Any:
        if isinstance(w, Fraction):
            return str(w)
        if isinstance(w, dict):
            return {k: safe_witness(v) for k, v in w.items()}
        if isinstance(w, (list, tuple)):
            return [safe_witness(v) for v in w]
        return w

    return {
        "arm_a": {
            "audit": {"verdict": audit_A.verdict.value, "detail": audit_A.detail, "witness": safe_witness(audit_A.witness)},
            "pred_survival": {
                "[1]_s3": 1.0, "[1]_s4": 1.0,
                "[2]_s3": 1.0, "[2]_s4": 1.0,
                "[1,1]_s3": float(compute_survival_from_mats(mats_A, ["1", "1"], "3", ["1", "2", "3", "4"])),
                "[1,1]_s4": float(compute_survival_from_mats(mats_A, ["1", "1"], "4", ["1", "2", "3", "4"])),
                "[2,2]_s3": float(compute_survival_from_mats(mats_A, ["2", "2"], "3", ["1", "2", "3", "4"])),
                "[2,2]_s4": float(compute_survival_from_mats(mats_A, ["2", "2"], "4", ["1", "2", "3", "4"])),
                "[1,2]_s3": float(exact_12_s3),
                "[1,2]_s4": float(exact_12_s4),
            },
        },
        "arm_b": {
            "audit_4state": {"verdict": audit_B_4state.verdict.value, "detail": audit_B_4state.detail, "witness": safe_witness(audit_B_4state.witness)},
            "audit_phase": {"verdict": audit_B_phase.verdict.value, "detail": audit_B_phase.detail, "witness": safe_witness(audit_B_phase.witness)},
            "pred_survival": {
                "[1,2]_s3": float(exact_B_12_s3),
                "[1,2]_s4": float(compute_survival_from_mats(mats_B, ["1_c0", "2_c1"], "4", ["1", "2", "3", "4"])),
                "alt12_len8_s3": float(compute_survival_from_mats(mats_B, sched_B_alt12, "3", ["1", "2", "3", "4"])),
                "alt12_len8_s4": float(compute_survival_from_mats(mats_B, sched_B_alt12, "4", ["1", "2", "3", "4"])),
                "alt21_len8_s3": float(compute_survival_from_mats(mats_B, sched_B_alt21, "3", ["1", "2", "3", "4"])),
                "alt21_len8_s4": float(compute_survival_from_mats(mats_B, sched_B_alt21, "4", ["1", "2", "3", "4"])),
            },
            "ckpt0_digest": policy_digest(ckpt_0_blob),
            "ckpt1_digest": policy_digest(ckpt_1_blob),
        },
        "arm_c": {
            "online_1": c_1,
            "online_24": c_24,
            "exact_gap_online": abs(c_24["terminal_q0_exact"] - c_1["terminal_q0_exact"]),
            "frozen_neg_1": c_1_frozen,
            "frozen_neg_24": c_24_frozen,
            "exact_gap_frozen_neg": abs(c_24_frozen["terminal_q0_exact"] - c_1_frozen["terminal_q0_exact"]),
            "equal_clock_agg_first": eq_clock_agg_first,
            "equal_clock_agg_last": eq_clock_agg_last,
            "equal_clock_exact_gap": abs(eq_clock_agg_first["terminal_q0_exact"] - eq_clock_agg_last["terminal_q0_exact"]),
        },
    }


def evaluate_b2_heldout(
    ckpt_0_blob: Mapping[str, Any],
    ckpt_1_blob: Mapping[str, Any],
    b2_pred: Mapping[str, Any],
) -> Dict[str, Any]:
    pol0 = load_policy(ckpt_0_blob)
    pol1 = load_policy(ckpt_1_blob)
    probs0 = {x: pol0.action_probs(make_paced_env(1, x).make_features(True, float(x), noise_std=0.0)) for x in LIVE_STATES}
    probs1 = {x: pol1.action_probs(make_paced_env(1, x).make_features(True, float(x), noise_std=0.0)) for x in LIVE_STATES}

    def run_rollouts(base_seed: int, cell_i: int, start_x: int, mode_seq: Sequence[int], probs_seq: Sequence[Dict[int, List[float]]], n_roll: int) -> Tuple[int, float]:
        surv = 0
        for rep in range(n_roll):
            rng = random.Random(base_seed + 10000 * cell_i + rep)
            env = make_paced_env(mode_seq[0], start_x, seed=base_seed + 10000 * cell_i + rep)
            for step_t, mode in enumerate(mode_seq):
                if env.collapsed or int(round(env.reserve)) == 0:
                    break
                set_env_mode(env, mode)
                cur_x = int(round(env.reserve))
                act = sample_categorical(probs_seq[step_t][cur_x], rng)
                env.step(act)
            if not env.collapsed:
                surv += 1
        return surv, surv / n_roll

    # Arm A: 2,048 per cell, simultaneous conservative binomial half-width over 10 cells
    n_ab = 2048
    allow_a = math.sqrt(math.log(2.0 * 10 / 0.05) / (2.0 * n_ab))
    arm_a_cells = [
        ("[1]_s3", 3, [1], [probs1]), ("[1]_s4", 4, [1], [probs1]),
        ("[2]_s3", 3, [2], [probs1]), ("[2]_s4", 4, [2], [probs1]),
        ("[1,1]_s3", 3, [1, 1], [probs1, probs1]), ("[1,1]_s4", 4, [1, 1], [probs1, probs1]),
        ("[2,2]_s3", 3, [2, 2], [probs1, probs1]), ("[2,2]_s4", 4, [2, 2], [probs1, probs1]),
        ("[1,2]_s3", 3, [1, 2], [probs1, probs1]), ("[1,2]_s4", 4, [1, 2], [probs1, probs1]),
    ]
    res_A: Dict[str, Any] = {}
    max_err_A = 0.0
    for idx, (label, sx, ms, ps) in enumerate(arm_a_cells):
        k_cnt, rate = run_rollouts(2_000_000, idx, sx, ms, ps, n_ab)
        pred = b2_pred["arm_a"]["pred_survival"][label]
        max_err_A = max(max_err_A, abs(rate - pred))
        res_A[label] = {"k": k_cnt, "n": n_ab, "emp": rate, "pred": pred, "wilson_95": list(wilson_ci_95(k_cnt, n_ab))}

    # Arm B: 2,048 per cell, assert checkpoint hashes unchanged after
    allow_b = math.sqrt(math.log(2.0 * 6 / 0.05) / (2.0 * n_ab))
    arm_b_cells = [
        ("[1,2]_s3", 3, [1, 2], [probs0, probs1]),
        ("[1,2]_s4", 4, [1, 2], [probs0, probs1]),
        ("alt12_len8_s3", 3, [1, 2, 1, 2, 1, 2, 1, 2], [probs0, probs1] * 4),
        ("alt12_len8_s4", 4, [1, 2, 1, 2, 1, 2, 1, 2], [probs0, probs1] * 4),
        ("alt21_len8_s3", 3, [2, 1, 2, 1, 2, 1, 2, 1], [probs0, probs1] * 4),
        ("alt21_len8_s4", 4, [2, 1, 2, 1, 2, 1, 2, 1], [probs0, probs1] * 4),
    ]
    res_B: Dict[str, Any] = {}
    max_err_B = 0.0
    for idx, (label, sx, ms, ps) in enumerate(arm_b_cells):
        k_cnt, rate = run_rollouts(3_000_000, idx, sx, ms, ps, n_ab)
        pred = b2_pred["arm_b"]["pred_survival"][label]
        max_err_B = max(max_err_B, abs(rate - pred))
        res_B[label] = {"k": k_cnt, "n": n_ab, "emp": rate, "pred": pred, "wilson_95": list(wilson_ci_95(k_cnt, n_ab))}
    if (
        policy_digest(serialize_policy(pol0)) != b2_pred["arm_b"]["ckpt0_digest"]
        or policy_digest(serialize_policy(pol1)) != b2_pred["arm_b"]["ckpt1_digest"]
    ):
        raise RuntimeError("Arm B checkpoint hash mutated during evaluation!")

    # Arm C: 4,096 1-step forks per terminal snapshot at x=1, mode=1
    n_c = 4096
    sim_hoeff_diff = 2.0 * math.sqrt(math.log(4.0 / 0.05) / (2.0 * n_c))

    def run_forks(blob: Mapping[str, Any], cell_i: int) -> Tuple[int, float]:
        pol = load_policy(blob)
        pr = {1: pol.action_probs(make_paced_env(1, 1).make_features(True, 1.0, noise_std=0.0))}
        return run_rollouts(4_000_000, cell_i, 1, [1], [pr], n_c)

    k_o1, r_o1 = run_forks(b2_pred["arm_c"]["online_1"]["policy_blob"], 0)
    k_o24, r_o24 = run_forks(b2_pred["arm_c"]["online_24"]["policy_blob"], 1)
    k_f1, r_f1 = run_forks(b2_pred["arm_c"]["frozen_neg_1"]["policy_blob"], 2)
    k_f24, r_f24 = run_forks(b2_pred["arm_c"]["frozen_neg_24"]["policy_blob"], 3)
    k_ec1, r_ec1 = run_forks(b2_pred["arm_c"]["equal_clock_agg_first"]["policy_blob"], 4)
    k_ec2, r_ec2 = run_forks(b2_pred["arm_c"]["equal_clock_agg_last"]["policy_blob"], 5)

    emp_gap_online = r_o24 - r_o1
    online_diff_ci = (emp_gap_online - sim_hoeff_diff, emp_gap_online + sim_hoeff_diff)
    online_excludes_zero = online_diff_ci[0] > 0.0 or online_diff_ci[1] < 0.0

    emp_gap_ec = r_ec1 - r_ec2
    ec_diff_ci = (emp_gap_ec - sim_hoeff_diff, emp_gap_ec + sim_hoeff_diff)
    ec_excludes_zero = ec_diff_ci[0] > 0.0 or ec_diff_ci[1] < 0.0

    return {
        "arm_a": {
            "n_per_cell": n_ab,
            "allow_005": allow_a,
            "max_emp_pred_diff": max_err_A,
            "all_within_allow": max_err_A <= allow_a,
            "sep_12_emp_gap_s4_minus_s3": res_A["[1,2]_s4"]["emp"] - res_A["[1,2]_s3"]["emp"],
            "sep_12_exact_gap_s4_minus_s3": b2_pred["arm_a"]["pred_survival"]["[1,2]_s4"] - b2_pred["arm_a"]["pred_survival"]["[1,2]_s3"],
            "cells": res_A,
        },
        "arm_b": {
            "n_per_cell": n_ab,
            "allow_005": allow_b,
            "max_emp_pred_diff": max_err_B,
            "all_within_allow": max_err_B <= allow_b,
            "hashes_verified_unchanged": True,
            "cells": res_B,
        },
        "arm_c": {
            "n_forks": n_c,
            "sim_hoeff_diff_halfwidth": sim_hoeff_diff,
            "online_1": {"k": k_o1, "emp": r_o1, "pred": b2_pred["arm_c"]["online_1"]["terminal_q0_exact"], "wilson_95": list(wilson_ci_95(k_o1, n_c))},
            "online_24": {"k": k_o24, "emp": r_o24, "pred": b2_pred["arm_c"]["online_24"]["terminal_q0_exact"], "wilson_95": list(wilson_ci_95(k_o24, n_c))},
            "exact_gap_online": b2_pred["arm_c"]["exact_gap_online"],
            "emp_gap_online": emp_gap_online,
            "online_diff_ci": list(online_diff_ci),
            "online_passed": b2_pred["arm_c"]["exact_gap_online"] >= 0.05 and online_excludes_zero,
            "frozen_neg_exact_gap": b2_pred["arm_c"]["exact_gap_frozen_neg"],
            "frozen_neg_emp_gap": r_f24 - r_f1,
            "equal_clock": {
                "agg_first": {"k": k_ec1, "emp": r_ec1, "pred": b2_pred["arm_c"]["equal_clock_agg_first"]["terminal_q0_exact"], "wilson_95": list(wilson_ci_95(k_ec1, n_c))},
                "agg_last": {"k": k_ec2, "emp": r_ec2, "pred": b2_pred["arm_c"]["equal_clock_agg_last"]["terminal_q0_exact"], "wilson_95": list(wilson_ci_95(k_ec2, n_c))},
                "exact_gap": b2_pred["arm_c"]["equal_clock_exact_gap"],
                "emp_gap": emp_gap_ec,
                "diff_ci": list(ec_diff_ci),
                "excludes_zero": ec_excludes_zero,
            },
        },
    }
