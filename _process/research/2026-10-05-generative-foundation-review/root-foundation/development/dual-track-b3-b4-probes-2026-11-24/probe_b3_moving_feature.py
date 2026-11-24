#!/usr/bin/env python3
"""First-strike local CPU probe for Track B3: moving rank-1 covariance eigenspace conjecture.

AI-written local CPU empirical probe (24 November 2026 — pure Python 3 stdlib, deterministic
fixed seed, zero network/API calls, zero market-vocabulary tokens). No human has reviewed yet.

Tests Astra-3's moving rank-1 covariance eigenspace conjecture:
  lambda = 3, gamma = 1/16, kappa = 1,
  latch: v^T P_t v >= 3 u^T P_t u,
  reserve horizon: B_n = floor(n/2 + b * sqrt(n)),
  sweep b in [-1.0, -0.5, 0.0, 0.5, 1.0] at n in [128, 256, 512].

Because (lambda, gamma, kappa) admits two standard high-dimensional vs low-noise readings,
this probe evaluates BOTH cleanly:
  - Regime A (high-dim RMT reading): aspect ratio d/n = gamma = 1/16 (d = 8, 16, 32),
    isotropic noise variance sigma^2 = kappa = 1, spike lambda = 3.
  - Regime B (low-noise 2D reading): isotropic noise variance sigma^2 = gamma = 1/16,
    spike lambda = 3, unit stride kappa = 1 (d = 2 exact 2x2 eigenspace).

For each (n, b), reports on the finite test grid (n in {128, 256, 512}, b in [-1, 1]):
  (a) rolling-window first-passage P(tau_n <= B_n)
  (b) rolling-window endpoint P(v^T P_{B_n} v >= 3 u^T P_{B_n} u)
  (c1) independent-window first-passage control P(tau_n^ind <= B_n)
  (c2) independent-window endpoint sanity control
  (d1) 1D naive frozen-fluctuation Gaussian formula Phi(mu / sig_Delta)
  (d2) 2D cone formula P(Z_Delta + mu >= (2/sqrt(3)) |Z_c|)
       (exact for the 2x2 eigensystem in Regime B; finite-grid heuristic in Regime A)

Solver in Regime A uses a spike-aligned local 2D Rayleigh-Ritz solver seeded on
span(e_0, e_1) (closed-form 2x2 projected solve with adaptive residual tolerance
down to 1e-10 near latch/eigenvalue crossings and O(d) Rayleigh lower-bound guard
lam_1 >= max_i S_{ii}) with fallback to full symmetric Jacobi eigensolver
`jacobi_top_eigvec`. Note: small subspace residual + diag guard does not give
a general-purpose global leading-eigenvector guarantee for arbitrary non-spiked
matrices whose leading eigenpair lies purely in an orthogonal off-diagonal block
with diagonal <= lam_1; on spiked Regime A, latch correctness is directly
cross-verified by 1,350 full Jacobi checks (`0` mismatches).
"""
from __future__ import annotations

import argparse
import json
import math
import operator
import random
import time
from pathlib import Path

LAM = 3.0
GAMMA = 1.0 / 16.0
KAPPA = 1.0
B_GRID = [-1.0, -0.5, 0.0, 0.5, 1.0]
N_GRID = [128, 256, 512]
DEFAULT_SEED = 20261124


def norm_cdf(x: float) -> float:
    return 0.5 * (1.0 + math.erf(x / math.sqrt(2.0)))


def cone_2d_prob(mu: float, sig_delta: float, sig_c: float, thresh: float = 2.0 / math.sqrt(3.0)) -> float:
    """Exact integral P(Z_Delta + mu >= thresh * |Z_c|) for independent Z_Delta, Z_c."""
    if sig_c == 0.0:
        return norm_cdf(mu / sig_delta)
    steps = 600
    dz = 9.0 / steps
    acc = 0.0
    inv_rt2pi = 1.0 / math.sqrt(2.0 * math.pi)
    for k in range(steps):
        z = (k + 0.5) * dz
        phi_z = math.exp(-0.5 * z * z) * inv_rt2pi
        acc += 2.0 * phi_z * norm_cdf((mu - thresh * sig_c * z) / sig_delta) * dz
    return acc


def chi_rv(rng: random.Random, df: int) -> float:
    """Sample sqrt(chi^2_df) via exact gamma variate in stdlib."""
    return math.sqrt(2.0 * rng.gammavariate(0.5 * df, 1.0))


def sample_wishart_diag(rng: random.Random, m: int, variances: list[float]) -> list[list[float]]:
    """Exact Wishart_d(m, diag(variances)) via Bartlett decomposition (m >= d) or sum (m < d)."""
    d = len(variances)
    scales = [math.sqrt(v) for v in variances]
    if m < d:
        mat = [[0.0] * d for _ in range(d)]
        for _ in range(m):
            vec = [rng.gauss(0.0, sc) for sc in scales]
            for i in range(d):
                vi = vec[i]
                row = mat[i]
                for j in range(d):
                    row[j] += vi * vec[j]
        return mat
    # Lower triangular Bartlett factor L (L[i][j] for j <= i)
    L = [[0.0] * d for _ in range(d)]
    for i in range(d):
        L[i][i] = chi_rv(rng, m - i)
        for j in range(i):
            L[i][j] = rng.gauss(0.0, 1.0)
    # C = diag(scales) @ L => S = C @ C^T
    S = [[0.0] * d for _ in range(d)]
    for i in range(d):
        si = scales[i]
        li = L[i]
        for j in range(i + 1):
            lj = L[j]
            val = si * scales[j] * sum(li[k] * lj[k] for k in range(j + 1))
            S[i][j] = val
            S[j][i] = val
    return S


def jacobi_top_eigvec(S: list[list[float]], tol: float = 1e-11, max_sweeps: int = 60) -> list[float]:
    """Full symmetric Jacobi eigensolver returning the leading unit eigenvector."""
    d = len(S)
    A = [row[:] for row in S]
    V = [[1.0 if i == j else 0.0 for j in range(d)] for i in range(d)]
    for _ in range(max_sweeps):
        off = 0.0
        for p in range(d - 1):
            Ap = A[p]
            for q in range(p + 1, d):
                v = abs(Ap[q])
                if v > off:
                    off = v
        if off <= tol:
            break
        thresh = 0.01 * off if off > 1e-6 else 0.0
        for p in range(d - 1):
            for q in range(p + 1, d):
                apq = A[p][q]
                if abs(apq) <= thresh or abs(apq) <= 1e-14:
                    continue
                app, aqq = A[p][p], A[q][q]
                tau = (aqq - app) / (2.0 * apq)
                t = (
                    (1.0 / (tau + math.hypot(1.0, tau)))
                    if tau >= 0.0
                    else (-1.0 / (-tau + math.hypot(1.0, tau)))
                )
                c = 1.0 / math.hypot(1.0, t)
                s = t * c
                A[p][p] = app - t * apq
                A[q][q] = aqq + t * apq
                A[p][q] = A[q][p] = 0.0
                for k in range(d):
                    if k != p and k != q:
                        akp, akq = A[k][p], A[k][q]
                        A[k][p] = A[p][k] = c * akp - s * akq
                        A[k][q] = A[q][k] = s * akp + c * akq
                    vkp, vkq = V[k][p], V[k][q]
                    V[k][p] = c * vkp - s * vkq
                    V[k][q] = s * vkp + c * vkq
    best = max(range(d), key=lambda i: A[i][i])
    return [V[k][best] for k in range(d)]


def eig2x2(h00: float, h01: float, h11: float) -> tuple[float, float, float, float]:
    """Closed-form symmetric 2x2 eigensolve returning (lam1, lam2, c, s)."""
    tr = h00 + h11
    diff = h00 - h11
    disc = math.hypot(diff, 2.0 * h01)
    lam1 = 0.5 * (tr + disc)
    lam2 = 0.5 * (tr - disc)
    if abs(h01) <= 1e-15:
        return (lam1, lam2, 1.0, 0.0) if h00 >= h11 else (lam1, lam2, 0.0, 1.0)
    if diff >= 0.0:
        vx, vy = lam1 - h11, h01
    else:
        vx, vy = h01, lam1 - h00
    nrm = math.hypot(vx, vy)
    return lam1, lam2, vx / nrm, vy / nrm


def top_eigvec_subspace2(
    S: list[list[float]],
    q0_init: list[float],
    q1_init: list[float],
    max_iters: int = 60,
) -> tuple[list[float], list[float], list[float], bool]:
    """Spike-aligned local 2D Rayleigh-Ritz solver with diag guard + Jacobi fallback.

    Not a universal global leading-eigenvector guarantee for arbitrary symmetric
    matrices whose true top eigenpair lies orthogonal to span(q0_init, q1_init)
    with max diagonal <= lam1; checks lam1 >= max_i S[i][i] and residual before
    accepting local convergence, falling back to full symmetric Jacobi otherwise.
    """
    d = len(S)
    mul = operator.mul
    max_diag = max(S[i][i] for i in range(d))
    q0, q1 = q0_init, q1_init
    for _ in range(max_iters):
        z0 = [sum(map(mul, S[i], q0)) for i in range(d)]
        z1 = [sum(map(mul, S[i], q1)) for i in range(d)]
        h00 = sum(map(mul, q0, z0))
        h01 = sum(map(mul, q0, z1))
        h11 = sum(map(mul, q1, z1))
        lam1, lam2, c, s = eig2x2(h00, h01, h11)
        w = [c * a + s * b for a, b in zip(q0, q1)]
        Sw = [c * a + s * b for a, b in zip(z0, z1)]
        res2 = sum((Sw[i] - lam1 * w[i]) ** 2 for i in range(d))
        margin = abs(w[1] * w[1] - 3.0 * w[0] * w[0])
        gap_rel = (lam1 - lam2) / lam1 if lam1 > 0.0 else 0.0
        if margin > 0.25 and gap_rel > 0.05:
            tol = 1e-3
        elif margin > 0.03 and gap_rel > 0.01:
            tol = 1e-6
        else:
            tol = 1e-10
        if lam1 > 0.0 and res2 <= (tol * lam1) ** 2:
            if lam1 < max_diag - 1e-12:
                break
            return w, q0, q1, True
        n0 = math.sqrt(sum(map(mul, z0, z0)))
        if n0 <= 1e-15:
            break
        inv0 = 1.0 / n0
        q0 = [x * inv0 for x in z0]
        dot = sum(map(mul, z1, q0))
        v1 = [b - dot * a for a, b in zip(q0, z1)]
        n1 = math.sqrt(sum(map(mul, v1, v1)))
        if n1 <= 1e-15:
            break
        inv1 = 1.0 / n1
        q1 = [x * inv1 for x in v1]
    return jacobi_top_eigvec(S), q0, q1, False


def run_regime_a(n: int, trials: int, ind_trials: int, seed: int) -> list[dict]:
    """Regime A: d/n = gamma = 1/16, noise var = kappa = 1, spike = lambda = 3."""
    rng = random.Random(seed)
    d = int(round(GAMMA * n))
    assert d * 16 == n
    B_list = [int(math.floor(n / 2.0 + b * math.sqrt(n))) for b in B_GRID]
    B_max = max(B_list)
    B_set = set(B_list)
    B_mid = B_list[len(B_GRID) // 2]
    sig_d = math.sqrt(2.0 * (LAM + KAPPA) ** 2 + 2.0 * KAPPA ** 2)
    sig_c = math.sqrt(KAPPA * (LAM + KAPPA))

    var_pre = [LAM + KAPPA] + [KAPPA] * (d - 1)
    var_pos = [KAPPA, LAM + KAPPA] + [KAPPA] * (d - 2)
    sd_pre = [math.sqrt(v) for v in var_pre]
    sd_pos = [math.sqrt(v) for v in var_pos]

    e0_base = [1.0] + [0.0] * (d - 1)
    e1_base = [0.0, 1.0] + [0.0] * (d - 2)

    # Rolling-window simulation
    fp_hits = {B: 0 for B in B_list}
    ep_hits = {B: 0 for B in B_list}
    jacobi_fallbacks = 0
    jacobi_checks = 0
    jacobi_mismatches = 0
    for tr_idx in range(trials):
        X = []
        for s in range(n + B_max):
            sds = sd_pre if s < n else sd_pos
            X.append([rng.gauss(0.0, sd) for sd in sds])
        S = [[0.0] * d for _ in range(d)]
        for s in range(n):
            xr = X[s]
            for i in range(d):
                xi = xr[i]
                si = S[i]
                for j in range(d):
                    si[j] += xi * xr[j]
        q0, q1 = e0_base[:], e1_base[:]
        latched = False
        for t in range(1, B_max + 1):
            xo = X[t - 1]
            xi = X[n + t - 1]
            for i in range(d):
                xoi, xii = xo[i], xi[i]
                si = S[i]
                for j in range(d):
                    si[j] += xii * xi[j] - xoi * xo[j]
            if latched and t not in B_set:
                continue
            w, q0, q1, converged = top_eigvec_subspace2(S, q0, q1)
            if not converged:
                jacobi_fallbacks += 1
            ok = (w[1] * w[1]) >= 3.0 * (w[0] * w[0])
            if (t == B_mid) or (t in B_set and tr_idx < 30):
                w_ref = jacobi_top_eigvec(S)
                ok_ref = (w_ref[1] * w_ref[1]) >= 3.0 * (w_ref[0] * w_ref[0])
                jacobi_checks += 1
                if ok != ok_ref:
                    jacobi_mismatches += 1
            if ok:
                latched = True
            if t in B_set:
                if latched:
                    fp_hits[t] += 1
                if ok:
                    ep_hits[t] += 1

    # Independent-window control via exact Bartlett Wishart at each step t
    ind_fp_hits = {B: 0 for B in B_list}
    ind_ep_hits = {B: 0 for B in B_list}
    for ind_idx in range(ind_trials):
        latched = False
        for t in range(1, B_max + 1):
            if latched and t not in B_set:
                continue
            S1 = sample_wishart_diag(rng, n - t, var_pre)
            S2 = sample_wishart_diag(rng, t, var_pos)
            S = [[S1[i][j] + S2[i][j] for j in range(d)] for i in range(d)]
            w, _, _, converged = top_eigvec_subspace2(S, e0_base[:], e1_base[:])
            if not converged:
                jacobi_fallbacks += 1
            ok = (w[1] * w[1]) >= 3.0 * (w[0] * w[0])
            if t == B_mid and ind_idx < 30:
                w_ref = jacobi_top_eigvec(S)
                ok_ref = (w_ref[1] * w_ref[1]) >= 3.0 * (w_ref[0] * w_ref[0])
                jacobi_checks += 1
                if ok != ok_ref:
                    jacobi_mismatches += 1
            if ok:
                latched = True
            if t in B_set:
                if latched:
                    ind_fp_hits[t] += 1
                if ok:
                    ind_ep_hits[t] += 1

    if jacobi_mismatches != 0:
        raise RuntimeError(f"Jacobi cross-check mismatch count={jacobi_mismatches}")
    rows = []
    for b, B in zip(B_GRID, B_list):
        mu_asym = 2.0 * LAM * b
        mu_exact = LAM * (2.0 * B / n - 1.0) * math.sqrt(n)
        rows.append({
            "regime": "A_highdim_d_over_n_1_16",
            "n": n,
            "d": d,
            "b": b,
            "B_n": B,
            "trials": trials,
            "ind_trials": ind_trials,
            "rolling_first_passage": fp_hits[B] / trials,
            "rolling_endpoint": ep_hits[B] / trials,
            "ind_first_passage": ind_fp_hits[B] / ind_trials,
            "ind_endpoint": ind_ep_hits[B] / ind_trials,
            "gauss_1d_asym": norm_cdf(mu_asym / sig_d),
            "gauss_1d_exact_Bn": norm_cdf(mu_exact / sig_d),
            "cone_2d_exact_Bn": cone_2d_prob(mu_exact, sig_d, sig_c),
            "jacobi_checks": jacobi_checks,
            "jacobi_mismatches": jacobi_mismatches,
            "jacobi_fallbacks": jacobi_fallbacks,
        })
    return rows


def run_regime_b(n: int, trials: int, ind_trials: int, seed: int) -> list[dict]:
    """Regime B: d = 2 exact eigenspace, noise var = gamma = 1/16, spike = lambda = 3, kappa = 1."""
    rng = random.Random(seed)
    B_list = [int(math.floor(n / 2.0 + b * math.sqrt(n))) for b in B_GRID]
    B_max = max(B_list)
    B_set = set(B_list)
    thresh = 2.0 / math.sqrt(3.0)

    su_pre, sv_pre = math.sqrt(LAM + GAMMA), math.sqrt(GAMMA)
    su_pos, sv_pos = math.sqrt(GAMMA), math.sqrt(LAM + GAMMA)
    sig_d = math.sqrt(2.0 * (LAM + GAMMA) ** 2 + 2.0 * GAMMA ** 2)
    sig_c = math.sqrt(GAMMA * (LAM + GAMMA))

    fp_hits = {B: 0 for B in B_list}
    ep_hits = {B: 0 for B in B_list}
    for _ in range(trials):
        xs_u = [rng.gauss(0.0, su_pre) for _ in range(n)] + [rng.gauss(0.0, su_pos) for _ in range(B_max)]
        xs_v = [rng.gauss(0.0, sv_pre) for _ in range(n)] + [rng.gauss(0.0, sv_pos) for _ in range(B_max)]
        pu2, pv2, puv = [0.0], [0.0], [0.0]
        for u, v in zip(xs_u, xs_v):
            pu2.append(pu2[-1] + u * u)
            pv2.append(pv2[-1] + v * v)
            puv.append(puv[-1] + u * v)
        latched = False
        for t in range(1, B_max + 1):
            a = (pu2[t + n] - pu2[t]) / n
            b_val = (pv2[t + n] - pv2[t]) / n
            c = (puv[t + n] - puv[t]) / n
            ok = (b_val - a) >= thresh * abs(c)
            if ok:
                latched = True
            if t in B_set:
                if latched:
                    fp_hits[t] += 1
                if ok:
                    ep_hits[t] += 1

    ind_fp_hits = {B: 0 for B in B_list}
    ind_ep_hits = {B: 0 for B in B_list}
    var_pre = [LAM + GAMMA, GAMMA]
    var_pos = [GAMMA, LAM + GAMMA]
    for _ in range(ind_trials):
        latched = False
        for t in range(1, B_max + 1):
            if latched and t not in B_set:
                continue
            S1 = sample_wishart_diag(rng, n - t, var_pre)
            S2 = sample_wishart_diag(rng, t, var_pos)
            a = (S1[0][0] + S2[0][0]) / n
            b_val = (S1[1][1] + S2[1][1]) / n
            c = (S1[0][1] + S2[0][1]) / n
            ok = (b_val - a) >= thresh * abs(c)
            if ok:
                latched = True
            if t in B_set:
                if latched:
                    ind_fp_hits[t] += 1
                if ok:
                    ind_ep_hits[t] += 1

    rows = []
    for b, B in zip(B_GRID, B_list):
        mu_asym = 2.0 * LAM * b
        mu_exact = LAM * (2.0 * B / n - 1.0) * math.sqrt(n)
        rows.append({
            "regime": "B_lownoise_gamma_1_16_d2",
            "n": n,
            "d": 2,
            "b": b,
            "B_n": B,
            "trials": trials,
            "ind_trials": ind_trials,
            "rolling_first_passage": fp_hits[B] / trials,
            "rolling_endpoint": ep_hits[B] / trials,
            "ind_first_passage": ind_fp_hits[B] / ind_trials,
            "ind_endpoint": ind_ep_hits[B] / ind_trials,
            "gauss_1d_asym": norm_cdf(mu_asym / sig_d),
            "gauss_1d_exact_Bn": norm_cdf(mu_exact / sig_d),
            "cone_2d_exact_Bn": cone_2d_prob(mu_exact, sig_d, sig_c),
        })
    return rows


def main() -> None:
    parser = argparse.ArgumentParser(description="Probe B3 moving rank-1 covariance eigenspace")
    parser.add_argument("--seed", type=int, default=DEFAULT_SEED)
    parser.add_argument("--trials-a", type=int, default=300)
    parser.add_argument("--ind-trials-a", type=int, default=150)
    parser.add_argument("--trials-b", type=int, default=2000)
    parser.add_argument("--ind-trials-b", type=int, default=500)
    parser.add_argument("--json-out", type=Path, default=None)
    args = parser.parse_args()

    t0 = time.time()
    all_rows = []
    for idx, n in enumerate(N_GRID):
        all_rows.extend(run_regime_a(n, args.trials_a, args.ind_trials_a, args.seed + 100 * idx))
    for idx, n in enumerate(N_GRID):
        all_rows.extend(run_regime_b(n, args.trials_b, args.ind_trials_b, args.seed + 1000 + 100 * idx))
    elapsed = time.time() - t0

    for row in all_rows:
        print(
            f"{row['regime']:24s} n={row['n']:3d} d={row['d']:2d} b={row['b']:+4.1f} B={row['B_n']:3d} | "
            f"FP={row['rolling_first_passage']:.3f} EP={row['rolling_endpoint']:.3f} "
            f"IndFP={row['ind_first_passage']:.3f} IndEP={row['ind_endpoint']:.3f} "
            f"G1D={row['gauss_1d_exact_Bn']:.3f} G2D={row['cone_2d_exact_Bn']:.3f}"
        )
    print(f"elapsed_sec={elapsed:.2f}")

    if args.json_out is not None:
        args.json_out.write_text(json.dumps({"seed": args.seed, "elapsed_sec": elapsed, "rows": all_rows}, indent=2) + "\n")


if __name__ == "__main__":
    main()
