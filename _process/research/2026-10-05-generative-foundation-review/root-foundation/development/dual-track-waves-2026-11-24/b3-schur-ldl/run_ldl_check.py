#!/usr/bin/env python3
"""Sub-15-second exact Dumitriu-Edelman + Haar + tridiagonal LDL endpoint check for Track B3.

AI-written (Wave 4 Track B3, 25 November 2026). Pure Python 3 stdlib, deterministic seed, -O-safe
(raises RuntimeError/ValueError instead of bare assert), checked <= 12.0s CPU cutoff (verified
per-endpoint, per-cell, and at completion). Runs:
1. Dense symmetric Jacobi cross-check on exact n x n matrix M = T' + Y'^T Y' (n = 32, all 5 gamma,
   2 replicates each = 10 checks at exact d = round(gamma * n) >= 2) asserting
   |z_ldl - z_jacobi| < 1e-10 and |mass_ldl - mass_jacobi| < 1e-10.
2. Exact 32-endpoint-per-cell Regime A sweep over n in {64, 128} and gamma in {1/16, 1/4, 1, 9/4, 4}
   at b = 0 (320 endpoints total), reporting top eigenvalue, signal-plane mass, cone hit rate +
   Wilson 95% CI, max secular residual, max final bracket width, numerical failures, and CPU seconds.
"""
from __future__ import annotations

import json
import math
import random
import sys
import time
from fractions import Fraction
from pathlib import Path

sys.dont_write_bytecode = True

HERE = Path(__file__).resolve().parent
LAM = 3.0
KAPPA = 1.0
BETA = LAM / (2.0 * KAPPA)  # 1.5
BETA2 = BETA * BETA         # 2.25
TAU = KAPPA + LAM / 2.0     # 2.5
V_DELTA = 2.0 * (LAM + KAPPA) ** 2 + 2.0 * KAPPA ** 2  # 34.0
V_C = KAPPA * (LAM + KAPPA)                            # 4.0

GAMMAS: list[tuple[str, Fraction]] = [
    ("1/16", Fraction(1, 16)),
    ("1/4", Fraction(1, 4)),
    ("1", Fraction(1, 1)),
    ("9/4", Fraction(9, 4)),
    ("4", Fraction(4, 1)),
]
N_GRID = [64, 128]
TRIALS_PER_CELL = 32
BISECT_STEPS = 52
CPU_CAP_SECONDS = 12.0
SEED = 20261125


def require(cond: bool, msg: str) -> None:
    if not cond:
        raise RuntimeError(msg)


def chi_rv(rng: random.Random, df: int) -> float:
    return math.sqrt(2.0 * rng.gammavariate(0.5 * df, 1.0))


def sample_wishart_2x2_diag(rng: random.Random, m: int, v0: float, v1: float) -> tuple[float, float, float]:
    """Return symmetric (g00, g01, g11) for Wishart_2(m, diag(v0, v1))."""
    if m < 2:
        g00 = g01 = g11 = 0.0
        s0, s1 = math.sqrt(v0), math.sqrt(v1)
        for _ in range(m):
            x0, x1 = rng.gauss(0.0, s0), rng.gauss(0.0, s1)
            g00 += x0 * x0
            g01 += x0 * x1
            g11 += x1 * x1
        return g00, g01, g11
    l00 = chi_rv(rng, m)
    l10 = rng.gauss(0.0, 1.0)
    l11 = chi_rv(rng, m - 1)
    s0, s1 = math.sqrt(v0), math.sqrt(v1)
    a00 = s0 * l00
    a10 = s1 * l10
    a11 = s1 * l11
    return a00 * a00, a00 * a10, a10 * a10 + a11 * a11


def sample_signal_gram(rng: random.Random, n: int) -> tuple[float, float, float]:
    m_pre = n // 2
    m_pos = n - m_pre
    p00, p01, p11 = sample_wishart_2x2_diag(rng, m_pre, (LAM + KAPPA) / n, KAPPA / n)
    q00, q01, q11 = sample_wishart_2x2_diag(rng, m_pos, KAPPA / n, (LAM + KAPPA) / n)
    return p00 + q00, p01 + q01, p11 + q11


def sample_haar_two_frame(rng: random.Random, n: int) -> tuple[list[float], list[float]]:
    """Sample independent Haar-uniform orthonormal 2 x n frame (u0, u1) via Gram-Schmidt."""
    while True:
        u0 = [rng.gauss(0.0, 1.0) for _ in range(n)]
        n0 = math.sqrt(sum(x * x for x in u0))
        if n0 > 1e-12:
            inv0 = 1.0 / n0
            u0 = [x * inv0 for x in u0]
            u1 = [rng.gauss(0.0, 1.0) for _ in range(n)]
            dot = sum(a * b for a, b in zip(u0, u1))
            u1 = [b - dot * a for a, b in zip(u0, u1)]
            n1 = math.sqrt(sum(x * x for x in u1))
            if n1 > 1e-12:
                inv1 = 1.0 / n1
                u1 = [x * inv1 for x in u1]
                return u0, u1


def sample_bidiagonal_tridiag(rng: random.Random, n: int, d: int) -> tuple[list[float], list[float]]:
    """Sample T'_top = (KAPPA/n) * B B^T (k0 x k0 symmetric tridiagonal) via Dumitriu-Edelman."""
    k0 = min(d - 2, n)
    l = max(d - 2, n)
    scale = KAPPA / n
    if k0 <= 0:
        return [], []
    diag_b = [chi_rv(rng, l - i) for i in range(k0)]
    sub_b = [chi_rv(rng, k0 - 1 - i) for i in range(k0 - 1)]
    t_diag = [scale * diag_b[0] * diag_b[0]]
    t_off = []
    for i in range(1, k0):
        sb = sub_b[i - 1]
        t_diag.append(scale * (sb * sb + diag_b[i] * diag_b[i]))
        t_off.append(scale * sb * diag_b[i - 1])
    return t_diag, t_off


def eig2x2_max(a: float, c: float, d: float) -> tuple[float, float, float]:
    """Return (lam_max, wx, wy) of 2x2 symmetric [[a, c], [c, d]] with wx^2 + wy^2 = 1."""
    tr_half = 0.5 * (a + d)
    diff_half = 0.5 * (a - d)
    rad = math.hypot(diff_half, c)
    lam_max = tr_half + rad
    if rad == 0.0:
        return lam_max, 0.0, 1.0
    if diff_half >= 0.0:
        vx = diff_half + rad
        vy = c
    else:
        vx = c
        vy = -diff_half + rad
    norm = math.hypot(vx, vy)
    return lam_max, vx / norm, vy / norm


def ldl_eval(
    z: float,
    t_diag: list[float],
    t_off: list[float],
    y0: list[float],
    y1: list[float],
    g_null: tuple[float, float, float],
) -> tuple[bool, float, float, float, list[float], list[float], list[float], list[float]]:
    """Evaluate PD(zI - T') and K(z) = F^T D^-1 F + G_null/z in one O(k0) pass."""
    k0 = len(t_diag)
    if z <= 0.0:
        return False, 0.0, 0.0, 0.0, [], [], [], []
    piv: list[float] = []
    mult: list[float] = []
    f0: list[float] = []
    f1: list[float] = []
    k00 = g_null[0] / z
    k01 = g_null[1] / z
    k11 = g_null[2] / z
    if k0 > 0:
        p = z - t_diag[0]
        if p <= 0.0:
            return False, 0.0, 0.0, 0.0, [], [], [], []
        a0, a1 = y0[0], y1[0]
        piv.append(p)
        f0.append(a0)
        f1.append(a1)
        inv_p = 1.0 / p
        k00 += a0 * a0 * inv_p
        k01 += a0 * a1 * inv_p
        k11 += a1 * a1 * inv_p
        for i in range(1, k0):
            e = -t_off[i - 1]
            m = e / piv[i - 1]
            p = (z - t_diag[i]) - m * e
            if p <= 0.0:
                return False, 0.0, 0.0, 0.0, [], [], [], []
            a0 = y0[i] - m * f0[i - 1]
            a1 = y1[i] - m * f1[i - 1]
            piv.append(p)
            mult.append(m)
            f0.append(a0)
            f1.append(a1)
            inv_p = 1.0 / p
            k00 += a0 * a0 * inv_p
            k01 += a0 * a1 * inv_p
            k11 += a1 * a1 * inv_p
    return True, k00, k01, k11, piv, mult, f0, f1


def solve_ldl_endpoint(
    t_diag: list[float],
    t_off: list[float],
    y0: list[float],
    y1: list[float],
    tr_g: float,
    n: int,
) -> tuple[float, float, bool, float, float, int]:
    """Bisect top eigenvalue via O(k0) tridiagonal LDL and recover eigenvector + mass."""
    k0 = len(t_diag)
    g_null00 = sum(y0[i] * y0[i] for i in range(k0, n))
    g_null01 = sum(y0[i] * y1[i] for i in range(k0, n))
    g_null11 = sum(y1[i] * y1[i] for i in range(k0, n))
    g_null = (g_null00, g_null01, g_null11)

    lo = 0.0
    hi = max(1e-6, sum(t_diag) + tr_g)
    failures = 0

    for _ in range(BISECT_STEPS):
        mid = 0.5 * (lo + hi)
        pd_t, k00, k01, k11, _, _, _, _ = ldl_eval(mid, t_diag, t_off, y0, y1, g_null)
        if not pd_t:
            lo = mid
            continue
        # I_2 - K(mid) is PD iff (1 - k00) > 0 and det(I_2 - K(mid)) > 0
        m00 = 1.0 - k00
        m11 = 1.0 - k11
        det = m00 * m11 - k01 * k01
        if m00 > 0.0 and det > 0.0:
            hi = mid
        else:
            lo = mid

    pd_t, k00, k01, k11, piv, mult, f0, f1 = ldl_eval(hi, t_diag, t_off, y0, y1, g_null)
    if not pd_t:
        return hi, 0.0, False, float("nan"), hi - lo, 1

    lam_k, wx, wy = eig2x2_max(k00, k01, k11)
    secular_res = abs(lam_k - 1.0)
    if not (math.isfinite(secular_res) and secular_res < 1e-6):
        failures += 1

    # Back-solve L^T u_top = D^-1 (wx * f0 + wy * f1)
    u_norm2 = 0.0
    if k0 > 0:
        u_top = [0.0] * k0
        rhs_last = (wx * f0[k0 - 1] + wy * f1[k0 - 1]) / piv[k0 - 1]
        u_top[k0 - 1] = rhs_last
        u_norm2 += rhs_last * rhs_last
        for i in range(k0 - 2, -1, -1):
            val = (wx * f0[i] + wy * f1[i]) / piv[i] - mult[i] * u_top[i + 1]
            u_top[i] = val
            u_norm2 += val * val
    for i in range(k0, n):
        val = (wx * y0[i] + wy * y1[i]) / hi
        u_norm2 += val * val

    if u_norm2 <= 0.0 or not math.isfinite(u_norm2):
        return hi, 0.0, False, secular_res, hi - lo, failures + 1

    mass = 1.0 / (hi * u_norm2)
    in_cone = (3.0 * wx * wx <= wy * wy)
    return hi, mass, in_cone, secular_res, hi - lo, failures


def jacobi_top_pair(M: list[list[float]], tol: float = 1e-13, max_sweeps: int = 80) -> tuple[float, list[float]]:
    n = len(M)
    A = [row[:] for row in M]
    V = [[1.0 if i == j else 0.0 for j in range(n)] for i in range(n)]
    for _ in range(max_sweeps):
        off = 0.0
        for p in range(n - 1):
            Ap = A[p]
            for q in range(p + 1, n):
                v = abs(Ap[q])
                if v > off:
                    off = v
        if off <= tol:
            break
        thresh = 0.01 * off if off > 1e-8 else 0.0
        for p in range(n - 1):
            for q in range(p + 1, n):
                apq = A[p][q]
                if abs(apq) <= thresh or abs(apq) <= 1e-15:
                    continue
                app, aqq = A[p][p], A[q][q]
                tau = (aqq - app) / (2.0 * apq)
                t = (1.0 / (tau + math.hypot(1.0, tau))) if tau >= 0.0 else (-1.0 / (-tau + math.hypot(1.0, tau)))
                c = 1.0 / math.hypot(1.0, t)
                s = t * c
                A[p][p] = app - t * apq
                A[q][q] = aqq + t * apq
                A[p][q] = A[q][p] = 0.0
                for k in range(n):
                    if k != p and k != q:
                        akp, akq = A[k][p], A[k][q]
                        A[k][p] = A[p][k] = c * akp - s * akq
                        A[k][q] = A[q][k] = s * akp + c * akq
                    vkp, vkq = V[k][p], V[k][q]
                    V[k][p] = c * vkp - s * vkq
                    V[k][q] = s * vkp + c * vkq
    best = max(range(n), key=lambda i: A[i][i])
    return A[best][best], [V[k][best] for k in range(n)]


def dense_cross_check(rng: random.Random, t0: float) -> dict:
    """Compare tridiagonal LDL solver against full dense Jacobi on n = 32 across all 5 gammas."""
    n = 32
    max_z_diff = 0.0
    max_mass_diff = 0.0
    angle_mismatches = 0
    checks = 0
    dims: list[int] = []
    for g_label, g_frac in GAMMAS:
        d = max(2, int(round(float(g_frac) * n)))
        for _ in range(2):
            dims.append(d)
            g00, g01, g11 = sample_signal_gram(rng, n)
            l00 = math.sqrt(g00)
            l10 = g01 / l00
            l11 = math.sqrt(max(0.0, g11 - l10 * l10))
            u0, u1 = sample_haar_two_frame(rng, n)
            y0 = [l00 * a for a in u0]
            y1 = [l10 * a + l11 * b for a, b in zip(u0, u1)]
            t_diag, t_off = sample_bidiagonal_tridiag(rng, n, d)
            z_ldl, mass_ldl, cone_ldl, _, _, fails = solve_ldl_endpoint(t_diag, t_off, y0, y1, g00 + g11, n)
            require(fails == 0, f"LDL failure in dense cross-check at gamma={g_label}")

            M = [[y0[i] * y0[j] + y1[i] * y1[j] for j in range(n)] for i in range(n)]
            for i in range(len(t_diag)):
                M[i][i] += t_diag[i]
                if i < len(t_off):
                    M[i][i + 1] += t_off[i]
                    M[i + 1][i] += t_off[i]
            z_jac, vec_jac = jacobi_top_pair(M)
            yv0 = sum(a * b for a, b in zip(y0, vec_jac))
            yv1 = sum(a * b for a, b in zip(y1, vec_jac))
            mass_jac = (yv0 * yv0 + yv1 * yv1) / z_jac
            cone_jac = (3.0 * yv0 * yv0 <= yv1 * yv1)

            max_z_diff = max(max_z_diff, abs(z_ldl - z_jac))
            max_mass_diff = max(max_mass_diff, abs(mass_ldl - mass_jac))
            if cone_ldl != cone_jac:
                angle_mismatches += 1
            checks += 1
            elapsed = time.process_time() - t0
            require(elapsed <= CPU_CAP_SECONDS, f"CPU cap exceeded in dense check: {elapsed:.3f}s")
    require(max_z_diff < 1e-10, f"Dense z_max mismatch too large: {max_z_diff}")
    require(max_mass_diff < 1e-10, f"Dense mass mismatch too large: {max_mass_diff}")
    require(angle_mismatches == 0, f"Dense cone angle mismatches: {angle_mismatches}")
    return {
        "n": n,
        "checks": checks,
        "dimensions": dims,
        "max_z_diff": max_z_diff,
        "max_mass_diff": max_mass_diff,
        "angle_mismatches": angle_mismatches,
    }


def wilson_ci(k: int, n: int, z: float = 1.959963984540054) -> list[float]:
    p = k / n
    z2 = z * z
    denom = 1.0 + z2 / n
    center = (p + z2 / (2.0 * n)) / denom
    half = z * math.sqrt((p * (1.0 - p) + z2 / (4.0 * n)) / n) / denom
    return [max(0.0, center - half), min(1.0, center + half)]


def theory_row(g_frac: Fraction) -> dict:
    gamma = float(g_frac)
    if g_frac < Fraction(9, 4):
        z_star = KAPPA * (1.0 + BETA) * (1.0 + gamma / BETA)
        mass = (1.0 - gamma / BETA2) / (1.0 + gamma / BETA)
        h_extra = TAU * TAU * (gamma / BETA2) / (1.0 - gamma / BETA2)
        p0 = math.atan(math.sqrt(3.0 * (V_DELTA + 4.0 * h_extra) / (4.0 * (V_C + h_extra)))) / math.pi
        regime = "supercritical"
    elif g_frac == Fraction(9, 4):
        z_star = KAPPA * (1.0 + math.sqrt(gamma)) ** 2
        mass = 0.0
        p0 = None
        regime = "critical_edge"
    else:
        z_star = KAPPA * (1.0 + math.sqrt(gamma)) ** 2
        mass = 0.0
        p0 = None
        regime = "subcritical_bulk_edge"
    return {"regime": regime, "z_star": z_star, "mass": mass, "p0": p0}


def main() -> int:
    t0 = time.process_time()
    rng = random.Random(SEED)
    jacobi_summary = dense_cross_check(rng, t0)

    cells = []
    total_failures = 0
    global_max_res = 0.0
    global_max_bracket = 0.0

    for n in N_GRID:
        for g_label, g_frac in GAMMAS:
            num_d = g_frac * n
            require(num_d.denominator == 1, f"Non-integer d at n={n}, gamma={g_label}")
            d = int(num_d)
            require(d >= 4, f"Unexpected small d={d}")

            z_vals: list[float] = []
            masses: list[float] = []
            cones = 0
            cell_fails = 0
            cell_max_res = 0.0
            cell_max_bracket = 0.0

            for _ in range(TRIALS_PER_CELL):
                g00, g01, g11 = sample_signal_gram(rng, n)
                l00 = math.sqrt(g00)
                l10 = g01 / l00
                l11 = math.sqrt(max(0.0, g11 - l10 * l10))
                u0, u1 = sample_haar_two_frame(rng, n)
                y0 = [l00 * a for a in u0]
                y1 = [l10 * a + l11 * b for a, b in zip(u0, u1)]
                t_diag, t_off = sample_bidiagonal_tridiag(rng, n, d)
                z_top, mass, in_cone, res, bracket, fails = solve_ldl_endpoint(
                    t_diag, t_off, y0, y1, g00 + g11, n
                )
                elapsed_step = time.process_time() - t0
                require(elapsed_step <= CPU_CAP_SECONDS, f"CPU cap exceeded: {elapsed_step:.3f}s")
                z_vals.append(z_top)
                masses.append(mass)
                if in_cone:
                    cones += 1
                cell_fails += fails
                cell_max_res = max(cell_max_res, res)
                cell_max_bracket = max(cell_max_bracket, bracket)

            total_failures += cell_fails
            global_max_res = max(global_max_res, cell_max_res)
            global_max_bracket = max(global_max_bracket, cell_max_bracket)

            elapsed_so_far = time.process_time() - t0
            require(elapsed_so_far <= CPU_CAP_SECONDS, f"CPU cap exceeded: {elapsed_so_far:.3f}s")

            cells.append({
                "n": n,
                "d": d,
                "gamma": g_label,
                "gamma_float": float(g_frac),
                "trials": TRIALS_PER_CELL,
                "theory": theory_row(g_frac),
                "emp_z_top_mean": sum(z_vals) / TRIALS_PER_CELL,
                "emp_mass_mean": sum(masses) / TRIALS_PER_CELL,
                "cone_hits": cones,
                "cone_rate": cones / TRIALS_PER_CELL,
                "cone_wilson_95ci": wilson_ci(cones, TRIALS_PER_CELL),
                "max_secular_residual": cell_max_res,
                "max_bracket": cell_max_bracket,
                "numerical_failures": cell_fails,
            })

    cpu_seconds = time.process_time() - t0
    require(cpu_seconds <= CPU_CAP_SECONDS, f"CPU cap exceeded at finish: {cpu_seconds:.3f}s")
    require(total_failures == 0, f"Numerical failures detected: {total_failures}")

    payload = {
        "ai_written": True,
        "seed": SEED,
        "b": 0,
        "bisect_steps": BISECT_STEPS,
        "trials_per_cell": TRIALS_PER_CELL,
        "total_endpoints": len(cells) * TRIALS_PER_CELL,
        "cpu_seconds": round(cpu_seconds, 6),
        "cpu_cap_seconds": CPU_CAP_SECONDS,
        "total_numerical_failures": total_failures,
        "global_max_secular_residual": global_max_res,
        "global_max_bracket": global_max_bracket,
        "dense_jacobi_cross_check": jacobi_summary,
        "cells": cells,
    }
    (HERE / "results.json").write_text(json.dumps(payload, indent=2) + "\n", encoding="utf-8")
    print(json.dumps({
        "cpu_seconds": payload["cpu_seconds"],
        "total_endpoints": payload["total_endpoints"],
        "total_numerical_failures": total_failures,
        "global_max_secular_residual": global_max_res,
        "global_max_bracket": global_max_bracket,
        "dense_max_z_diff": jacobi_summary["max_z_diff"],
        "dense_max_mass_diff": jacobi_summary["max_mass_diff"],
    }))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
