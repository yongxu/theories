#!/usr/bin/env python3
"""Independent exact `fractions.Fraction` primal-vs-dual certificate verifier.

AI-written (`Track S3`, 24 November 2026). Pure Python stdlib (`fractions.Fraction`);
Rule 7 compliant. Cross-checks Track S2 (`ConsequenceDuality.lean`) and B2
(`experiments/neural-alignment-stress-lab/substrates.py` read-only) via an independent
exact-rational Two-Phase Simplex LP solver + certificate checker across:
1. Section 7.1 public-port vs recipient contact (`1/4 -> min(1/4, 2*eps)`).
2. B2 1,000-seed paired simulation at aliasing 0.0, 0.8, 1.0 producing exact
   `[108, 188, 547, 157]` macro counts and `50/347` rational minimax certificate.
3. Track B `diag(1, 1 - delta)` survival amplification
   `(1 - (1 - delta)^n) * min(1/2, eps / delta)`.
4. Explicit negative tamper tests confirming `L > U`, `eps` violation, and
   invalid distribution weights are caught and rejected.

Writes `experiments/evidence-replay/fixtures/duality_handshake.json`.
"""

from __future__ import annotations

import json
import random
import sys
from fractions import Fraction
from pathlib import Path
from typing import Any, Dict, List, Sequence, Tuple

sys.dont_write_bytecode = True

HERE = Path(__file__).resolve().parent
REPO = HERE.parents[1]
LAB_DIR = REPO / "experiments" / "neural-alignment-stress-lab"
FIXTURE_PATH = HERE / "fixtures" / "duality_handshake.json"

if str(LAB_DIR) not in sys.path:
    sys.path.insert(0, str(LAB_DIR))

from substrates import CoupledPhaseGoodhartEnv, GoodhartConfig  # noqa: E402


class CertificateTamperError(ValueError):
    """Raised when a primal-dual consequence certificate is invalid or tampered."""


def frac(x: Any) -> Fraction:
    if isinstance(x, Fraction):
        return x
    if isinstance(x, int):
        return Fraction(x, 1)
    return Fraction(str(x))


def _pivot(tableau: List[List[Fraction]], basis: List[int], leave_row: int, enter_col: int) -> None:
    piv = tableau[leave_row][enter_col]
    assert piv != 0
    n_cols = len(tableau[0])
    tableau[leave_row] = [val / piv for val in tableau[leave_row]]
    for r, row in enumerate(tableau):
        if r == leave_row:
            continue
        factor = row[enter_col]
        if factor != 0:
            tableau[r] = [row[j] - factor * tableau[leave_row][j] for j in range(n_cols)]
    basis[leave_row] = enter_col


def _run_simplex(tableau: List[List[Fraction]], basis: List[int], allowed_cols: Sequence[int]) -> None:
    """Bland's rule exact rational simplex minimization on `tableau` (last row = objective)."""
    obj_row = len(tableau) - 1
    rhs_col = len(tableau[0]) - 1
    m = obj_row
    allowed_set = set(allowed_cols)

    while True:
        # Bland's rule: smallest index column with negative reduced cost
        enter_col = None
        for col in sorted(allowed_set):
            if tableau[obj_row][col] < 0:
                enter_col = col
                break
        if enter_col is None:
            return

        leave_row = None
        best_ratio = None
        for r in range(m):
            a_re = tableau[r][enter_col]
            if a_re > 0:
                ratio = tableau[r][rhs_col] / a_re
                if best_ratio is None or ratio < best_ratio or (
                    ratio == best_ratio and basis[r] < basis[leave_row]
                ):
                    best_ratio = ratio
                    leave_row = r
        if leave_row is None:
            raise ValueError("Unbounded LP in exact simplex solver")
        _pivot(tableau, basis, leave_row, enter_col)


def solve_lp_exact(
    c: Sequence[Fraction], A: Sequence[Sequence[Fraction]], b: Sequence[Fraction]
) -> Tuple[Fraction, List[Fraction]]:
    """Exact Fraction Two-Phase Simplex solving `min c^T x s.t. A x = b, x >= 0`."""
    m = len(A)
    n = len(c)
    c_f = [frac(v) for v in c]
    A_norm: List[List[Fraction]] = []
    b_norm: List[Fraction] = []
    for row, rhs in zip(A, b):
        r_f = [frac(v) for v in row]
        rhs_f = frac(rhs)
        if rhs_f < 0:
            r_f = [-v for v in r_f]
            rhs_f = -rhs_f
        A_norm.append(r_f)
        b_norm.append(rhs_f)

    # Phase 1: add artificial variables a_0..a_{m-1}
    total_cols = n + m
    tableau: List[List[Fraction]] = []
    for i in range(m):
        art = [Fraction(1) if j == i else Fraction(0) for j in range(m)]
        tableau.append(A_norm[i] + art + [b_norm[i]])
    # Phase-1 objective: min sum(a_i) => reduced row = -sum(rows) on real vars, 0 on artificials
    p1_obj = [Fraction(0)] * (total_cols + 1)
    for i in range(m):
        for j in range(n):
            p1_obj[j] -= A_norm[i][j]
        p1_obj[total_cols] -= b_norm[i]
    tableau.append(p1_obj)
    basis = [n + i for i in range(m)]

    _run_simplex(tableau, basis, list(range(total_cols)))
    phase1_val = -tableau[m][total_cols]
    if phase1_val != 0:
        raise ValueError(f"Infeasible LP in Phase 1: residual={phase1_val}")

    # Remove artificial variables from basis (pivot out or drop redundant row)
    active_rows = list(range(m))
    for r in range(m):
        if basis[r] >= n:
            piv_col = next((j for j in range(n) if tableau[r][j] != 0), None)
            if piv_col is not None:
                _pivot(tableau, basis, r, piv_col)
            else:
                active_rows.remove(r)

    # Build Phase 2 tableau on active rows and original n columns
    p2_tab: List[List[Fraction]] = []
    p2_basis: List[int] = []
    for r in active_rows:
        p2_tab.append(tableau[r][:n] + [tableau[r][total_cols]])
        p2_basis.append(basis[r])
    m2 = len(p2_tab)
    p2_obj = list(c_f) + [Fraction(0)]
    for r in range(m2):
        b_col = p2_basis[r]
        coef = p2_obj[b_col]
        if coef != 0:
            for j in range(n + 1):
                p2_obj[j] -= coef * p2_tab[r][j]
    p2_tab.append(p2_obj)

    _run_simplex(p2_tab, p2_basis, list(range(n)))
    opt_val = -p2_tab[m2][n]
    sol = [Fraction(0)] * n
    for r in range(m2):
        if p2_basis[r] < n:
            sol[p2_basis[r]] = p2_tab[r][n]
    return opt_val, sol


def solve_consequence_primal(
    F: Sequence[Sequence[Fraction]], h: Sequence[Fraction], eps: Fraction
) -> Tuple[Fraction, List[Fraction], List[Fraction]]:
    """Exact rational primal solution `(gap, mu, nu)` maximizing `|h^T (mu - nu)| / 2`."""
    S = len(h)
    J = len(F)
    eps_f = frac(eps)
    h_f = [frac(v) for v in h]
    F_f = [[frac(v) for v in row] for row in F]

    # Variables: p[0..S-1], q[0..S-1], s_mass, s_pos[0..J-1], s_neg[0..J-1]
    n_vars = 2 * S + 1 + 2 * J
    c = [-h_f[s] for s in range(S)] + [h_f[s] for s in range(S)] + [Fraction(0)] * (1 + 2 * J)

    A: List[List[Fraction]] = []
    b: List[Fraction] = []

    # sum(p) - sum(q) = 0
    row_bal = [Fraction(1)] * S + [Fraction(-1)] * S + [Fraction(0)] * (1 + 2 * J)
    A.append(row_bal)
    b.append(Fraction(0))

    # sum(p) + sum(q) + s_mass = 1
    row_mass = [Fraction(1)] * (2 * S) + [Fraction(1)] + [Fraction(0)] * (2 * J)
    A.append(row_mass)
    b.append(Fraction(1))

    # For each j: F_j (p - q) + s_pos_j = eps, -F_j (p - q) + s_neg_j = eps
    for j in range(J):
        r_pos = [Fraction(0)] * n_vars
        r_neg = [Fraction(0)] * n_vars
        for s in range(S):
            r_pos[s] = F_f[j][s]
            r_pos[S + s] = -F_f[j][s]
            r_neg[s] = -F_f[j][s]
            r_neg[S + s] = F_f[j][s]
        r_pos[2 * S + 1 + 2 * j] = Fraction(1)
        r_neg[2 * S + 1 + 2 * j + 1] = Fraction(1)
        A.extend([r_pos, r_neg])
        b.extend([eps_f, eps_f])

    min_neg_val, x = solve_lp_exact(c, A, b)
    gap = -min_neg_val
    p = x[:S]
    q = x[S : 2 * S]
    t = sum(p)
    assert t == sum(q) and Fraction(0) <= t <= Fraction(1, 2)
    pad = (Fraction(1) - 2 * t) / S
    mu = [2 * p[s] + pad for s in range(S)]
    nu = [2 * q[s] + pad for s in range(S)]
    return gap, mu, nu


def solve_consequence_dual(
    F: Sequence[Sequence[Fraction]], h: Sequence[Fraction], eps: Fraction
) -> Tuple[Fraction, Fraction, List[Fraction]]:
    """Exact rational dual solution `(bound, b, c)` minimizing `||h - b*1 - F^T c||_inf + eps ||c||_1`."""
    S = len(h)
    J = len(F)
    eps_f = frac(eps)
    h_f = [frac(v) for v in h]
    F_f = [[frac(v) for v in row] for row in F]

    # Variables: M, b_pos, b_neg, c_pos[0..J-1], c_neg[0..J-1], slack_hi[0..S-1], slack_lo[0..S-1]
    n_vars = 3 + 2 * J + 2 * S
    obj = [Fraction(1), Fraction(0), Fraction(0)]
    for _ in range(J):
        obj.extend([eps_f, eps_f])
    obj.extend([Fraction(0)] * (2 * S))

    A: List[List[Fraction]] = []
    b_rhs: List[Fraction] = []
    for s in range(S):
        # M + (b_pos - b_neg) + sum_j F[j][s]*(c_pos_j - c_neg_j) - slack_hi_s = h_s
        r_hi = [Fraction(0)] * n_vars
        r_hi[0] = Fraction(1)
        r_hi[1] = Fraction(1)
        r_hi[2] = Fraction(-1)
        for j in range(J):
            r_hi[3 + 2 * j] = F_f[j][s]
            r_hi[3 + 2 * j + 1] = -F_f[j][s]
        r_hi[3 + 2 * J + 2 * s] = Fraction(-1)
        A.append(r_hi)
        b_rhs.append(h_f[s])

        # M - (b_pos - b_neg) - sum_j F[j][s]*(c_pos_j - c_neg_j) - slack_lo_s = -h_s
        r_lo = [Fraction(0)] * n_vars
        r_lo[0] = Fraction(1)
        r_lo[1] = Fraction(-1)
        r_lo[2] = Fraction(1)
        for j in range(J):
            r_lo[3 + 2 * j] = -F_f[j][s]
            r_lo[3 + 2 * j + 1] = F_f[j][s]
        r_lo[3 + 2 * J + 2 * s + 1] = Fraction(-1)
        A.append(r_lo)
        b_rhs.append(-h_f[s])

    opt_val, x = solve_lp_exact(obj, A, b_rhs)
    b_opt = x[1] - x[2]
    c_opt = [x[3 + 2 * j] - x[3 + 2 * j + 1] for j in range(J)]
    return opt_val, b_opt, c_opt


def verify_certificate(
    F: Sequence[Sequence[Fraction]],
    h: Sequence[Fraction],
    eps: Fraction,
    mu: Sequence[Fraction],
    nu: Sequence[Fraction],
    b: Fraction,
    c: Sequence[Fraction],
    require_exact: bool = True,
) -> Tuple[Fraction, Fraction]:
    """Independent primal-vs-dual checker raising CertificateTamperError on any flaw."""
    S = len(h)
    J = len(F)
    if eps < 0:
        raise CertificateTamperError("Negative tolerance eps")
    if len(mu) != S or len(nu) != S:
        raise CertificateTamperError("Distribution dimension mismatch")
    if len(c) != J:
        raise CertificateTamperError("Dual coefficient dimension mismatch")
    if any(x < 0 for x in mu) or sum(mu) != 1:
        raise CertificateTamperError(f"Invalid distribution mu: sum={sum(mu)}")
    if any(x < 0 for x in nu) or sum(nu) != 1:
        raise CertificateTamperError(f"Invalid distribution nu: sum={sum(nu)}")

    L = abs(sum(h[s] * (mu[s] - nu[s]) for s in range(S))) / 2
    max_resid = max(
        abs(h[s] - b - sum(F[j][s] * c[j] for j in range(J))) for s in range(S)
    )
    U = max_resid + eps * sum(abs(cj) for cj in c)
    if L > U:
        raise CertificateTamperError(f"Weak duality violated: L={L} > U={U}")

    for j in range(J):
        diff_j = abs(sum(F[j][s] * (mu[s] - nu[s]) for s in range(S)))
        if diff_j > 2 * eps:
            raise CertificateTamperError(
                f"PrimalFeasible violated on row {j}: |F_j(mu-nu)|={diff_j} > 2*eps={2*eps}"
            )
    if require_exact and L != U:
        raise CertificateTamperError(f"Optimality gap nonzero: L={L} != U={U}")
    return L, U


def solve_and_verify(
    name: str, F: Sequence[Sequence[Fraction]], h: Sequence[Fraction], eps: Fraction
) -> Dict[str, Any]:
    p_gap, mu, nu = solve_consequence_primal(F, h, eps)
    d_bound, b, c = solve_consequence_dual(F, h, eps)
    L, U = verify_certificate(F, h, eps, mu, nu, b, c, require_exact=True)
    assert L == p_gap == d_bound == U
    return {
        "name": name,
        "eps": str(eps),
        "exact_value": str(L),
        "primal_gap": str(L),
        "dual_bound": str(U),
        "mu": [str(x) for x in mu],
        "nu": [str(x) for x in nu],
        "b": str(b),
        "c": [str(x) for x in c],
    }


def verify_section_7_1() -> Dict[str, Any]:
    """Verify §7.1 Markov resolvent + public-only (1/4) vs recipient contact min(1/4, 2*eps)."""
    # Markov matrix on public states {p, q}: Q = [[1/4, 1/4], [1/4, 1/4]]
    Q = [[Fraction(1, 4), Fraction(1, 4)], [Fraction(1, 4), Fraction(1, 4)]]
    r_b_A = [Fraction(1, 8), Fraction(1, 8)]
    r_b_B = [Fraction(3, 8), Fraction(3, 8)]

    def step_probs(r_b: List[Fraction], horizon: int) -> Tuple[List[Fraction], Fraction]:
        # n-th step first entry to b from state p: (Q^(n-1) r_b)[0]
        vec = list(r_b)
        terms: List[Fraction] = []
        for _ in range(horizon):
            terms.append(vec[0])
            vec = [sum(Q[i][k] * vec[k] for k in range(2)) for i in range(2)]
        return terms, sum(terms)

    terms_A, sum10_A = step_probs(r_b_A, 10)
    terms_B, sum10_B = step_probs(r_b_B, 10)
    for n, (ta, tb) in enumerate(zip(terms_A, terms_B), start=1):
        assert ta == Fraction(1, 4) * (Fraction(1, 2) ** n)
        assert tb == Fraction(3, 4) * (Fraction(1, 2) ** n)
    # Exact geometric sum (I - Q)^(-1) r_b:
    # Since Q * [1, 1] = (1/2) * [1, 1], (I - Q)^(-1) r_b = 2 * r_b
    exact_absorp = [2 * r_b_A[0], 2 * r_b_B[0]]
    assert exact_absorp == [Fraction(1, 4), Fraction(3, 4)]

    h = [Fraction(1, 4), Fraction(3, 4)]
    F_public_only = [[Fraction(1, 2), Fraction(1, 2)]]
    F_with_recipient = [[Fraction(1, 2), Fraction(1, 2)], [Fraction(1, 8), Fraction(3, 8)]]

    eps_grid = [Fraction(0), Fraction(1, 16), Fraction(1, 8), Fraction(1, 4)]
    public_rows = []
    recipient_rows = []
    for eps in eps_grid:
        pub_cert = solve_and_verify(f"sec7_1_public_eps_{eps}", F_public_only, h, eps)
        assert Fraction(pub_cert["exact_value"]) == Fraction(1, 4)
        public_rows.append(pub_cert)

        rec_cert = solve_and_verify(f"sec7_1_recipient_eps_{eps}", F_with_recipient, h, eps)
        expected = min(Fraction(1, 4), 2 * eps)
        assert Fraction(rec_cert["exact_value"]) == expected
        recipient_rows.append(rec_cert)

    # Dropping recipient contact row restores 1/4 even at eps = 0
    dropped = solve_and_verify("sec7_1_dropped_recipient_eps_0", F_public_only, h, Fraction(0))
    assert Fraction(dropped["exact_value"]) == Fraction(1, 4)

    return {
        "exact_absorption_b": [str(x) for x in exact_absorp],
        "first_3_resolvent_terms_A": [str(x) for x in terms_A[:3]],
        "first_3_resolvent_terms_B": [str(x) for x in terms_B[:3]],
        "public_only_rows": public_rows,
        "with_recipient_rows": recipient_rows,
        "dropped_recipient_restores_1_4": dropped,
    }


def verify_b2_1000_seed() -> Dict[str, Any]:
    """Replays B2 1,000-seed paired simulation and verifies exact 50/347 rational certificate."""
    sim_rows: Dict[str, Any] = {}
    for alpha_str, alpha in (("0.0", 0.0), ("0.8", 0.8), ("1.0", 1.0)):
        per_state: Dict[str, Any] = {}
        for state_idx, state_name in ((0, "strained"), (1, "intact")):
            report_pos = 0
            survived = 0
            macro_counts = [0, 0, 0, 0]
            for i in range(1000):
                e = CoupledPhaseGoodhartEnv(GoodhartConfig(horizon=25), random.Random(30000 + i))
                e.m = 1
                e.r, e.phi = ((0.28, -0.75), (0.85, 0.6))[state_idx]
                rep = e.interventional_probe(alpha) > 0
                macro_first = 0
                for t in range(10):
                    e.step(1)
                    if t == 0:
                        macro_first = e.m
                report_pos += int(rep)
                survived += int(not e.collapsed)
                macro_counts[macro_first] += 1
            assert macro_counts == [108, 188, 547, 157], (alpha_str, state_name, macro_counts)
            per_state[state_name] = {
                "report_pos": report_pos,
                "report_rate": str(Fraction(report_pos, 1000)),
                "survived": survived,
                "survival_rate": str(Fraction(survived, 1000)),
                "macro_counts": macro_counts,
            }
        sim_rows[alpha_str] = per_state

    assert sim_rows["0.0"]["strained"]["report_pos"] == 0
    assert sim_rows["0.0"]["intact"]["report_pos"] == 1000
    assert sim_rows["0.8"]["strained"]["report_pos"] == 285
    assert sim_rows["0.8"]["intact"]["report_pos"] == 632
    assert sim_rows["1.0"]["strained"]["report_pos"] == 434
    assert sim_rows["1.0"]["intact"]["report_pos"] == 434

    h_b2 = [Fraction(0), Fraction(1)]
    eps_b2 = Fraction(1, 20)
    certs: Dict[str, Any] = {}
    for alpha_str in ("0.0", "0.8", "1.0"):
        p0 = Fraction(sim_rows[alpha_str]["strained"]["report_pos"], 1000)
        p1 = Fraction(sim_rows[alpha_str]["intact"]["report_pos"], 1000)
        certs[alpha_str] = solve_and_verify(f"b2_alpha_{alpha_str}", [[p0, p1]], h_b2, eps_b2)

    assert Fraction(certs["0.8"]["exact_value"]) == Fraction(50, 347)
    assert Fraction(certs["0.0"]["exact_value"]) == Fraction(1, 20)
    assert Fraction(certs["1.0"]["exact_value"]) == Fraction(1, 2)

    # Also cross-check the explicit certificate from Track S2:
    # primal: mu=(0, 1), nu=(100/347, 247/347); dual: b=-285/347, c=[1000/347]
    F_08 = [[Fraction(285, 1000), Fraction(632, 1000)]]
    L_s2, U_s2 = verify_certificate(
        F_08,
        h_b2,
        eps_b2,
        [Fraction(0), Fraction(1)],
        [Fraction(100, 347), Fraction(247, 347)],
        Fraction(-285, 347),
        [Fraction(1000, 347)],
        require_exact=True,
    )
    assert L_s2 == Fraction(50, 347) and U_s2 == Fraction(50, 347)

    return {
        "simulation": sim_rows,
        "duality_certificates": certs,
        "s2_explicit_handshake_value": str(L_s2),
    }


def verify_track_b_amplification() -> List[Dict[str, Any]]:
    """Verify Track B diag(1, 1 - delta) survival error (1 - (1 - delta)^n) * min(1/2, eps / delta)."""
    cases = [
        (Fraction(1, 4), 1, Fraction(1, 16)),
        (Fraction(1, 4), 2, Fraction(1, 16)),
        (Fraction(1, 4), 3, Fraction(1, 16)),
        (Fraction(1, 4), 3, Fraction(1, 4)),
        (Fraction(1, 5), 4, Fraction(1, 20)),
        (Fraction(1, 2), 3, Fraction(1, 8)),
    ]
    rows = []
    for delta, n, eps in cases:
        surv_1 = (Fraction(1) - delta) ** n
        F = [[Fraction(1), Fraction(1) - delta]]
        h = [Fraction(1), surv_1]
        expected = (Fraction(1) - surv_1) * min(Fraction(1, 2), eps / delta)
        cert = solve_and_verify(f"trackB_d{delta}_n{n}_e{eps}", F, h, eps)
        assert Fraction(cert["exact_value"]) == expected, (cert["exact_value"], expected)
        cert["delta"] = str(delta)
        cert["n"] = n
        cert["expected_formula"] = str(expected)
        rows.append(cert)
    return rows


def run_negative_tamper_checks() -> List[Dict[str, Any]]:
    """Verify certificate verifier strictly catches L > U, eps violation, and bad weights."""
    F = [[Fraction(285, 1000), Fraction(632, 1000)]]
    h = [Fraction(0), Fraction(1)]
    eps = Fraction(1, 20)
    mu_ok = [Fraction(0), Fraction(1)]
    nu_ok = [Fraction(100, 347), Fraction(247, 347)]
    b_ok = Fraction(-285, 347)
    c_ok = [Fraction(1000, 347)]

    tamper_cases = []

    # Case 1: L > U via infeasible primal difference making L = 1/2 > U = 50/347
    # Wait: test BOTH direct L > U (tampering h mismatch or invalid certificate check) AND eps bypass:
    # Here we construct an explicit L > U tuple by passing valid primal mu_bad=(0,1), nu_bad=(1,0)
    # on a tampered dual / or checking weak duality rejection directly when F_eff allows L=1/2 vs U=50/347:
    # Wait: with eps=1/4, mu=(0,1), nu=(1,0) is feasible if delta <= 1/2: here delta=347/1000 <= 1/2!
    # So at eps=1/4, L = 1/2, while using stale dual (b=-285/347, c=1000/347) gives U = 0 + (1/4)*(1000/347) > 1/2.
    # Conversely, if someone tampers a certificate by plugging eps=1/20's primal into a tampered U < L
    # or bypassing F feasibility:
    # Let's test ALL three:
    # (a) L > U: primal=(0,1) vs (1,0) on F=[[0,0]]? No, on F=[[0, 1/10]], eps=1/20 (feasible! |1/10| <= 2*(1/20)=1/10)
    #     with tampered dual b=0, c=0 gives L = 1/2 > U = ? No, U=1/2 with b=1/2! With b=0, c=0: U=1!
    #     Wait: weak duality holds mathematically whenever PrimalFeasible holds!
    #     The ONLY way L > U occurs is if a tampered certificate lies about PrimalFeasible OR lies about L or U!
    #     Wait: what if c is scaled down by 1/2 and b=1/2 while F is ignored? Let's test:
    #     Pass mu_bad=(0,1), nu_bad=(1,0) at eps=1/20 (violates PrimalFeasible) AND pass bogus (b=1/2, c=[0]) -> caught!
    #     AND explicitly test the L > U guard by verifying a sub-routine / direct tampered-L-gt-U scenario:
    #     Suppose F=[[1/10, 1/10]]? Even cleaner: evaluate L on F=[[285/1000, 632/1000]] with tampered h_dual or
    #     tampered U < L inside an explicit check:
    # Case 1: Explicit L > U rejection via verify_certificate (tampered primal (0,1) vs (1,0) gives L=1/2 > U=50/347)
    caught_l_gt_u = False
    msg1 = ""
    try:
        verify_certificate(
            F, h, eps, [Fraction(0), Fraction(1)], [Fraction(1), Fraction(0)], b_ok, c_ok
        )
    except CertificateTamperError as exc:
        caught_l_gt_u = True
        msg1 = str(exc)
    assert caught_l_gt_u and "L=1/2 > U=50/347" in msg1
    tamper_cases.append({"case": "tampered_L_gt_U", "rejected": True, "reason": msg1})

    # Case 2: PrimalFeasible violation where L <= U still holds (nu=(1/2, 1/2), dual=(b=1/2, c=0) => L=1/4 <= U=1/2, yet |F(mu-nu)| = 347/2000 > 1/10)
    caught_eps = False
    msg2 = ""
    try:
        verify_certificate(
            F, h, eps, [Fraction(0), Fraction(1)], [Fraction(1, 2), Fraction(1, 2)], Fraction(1, 2), [Fraction(0)]
        )
    except CertificateTamperError as exc:
        caught_eps = True
        msg2 = str(exc)
    assert caught_eps and "PrimalFeasible violated" in msg2
    tamper_cases.append({"case": "primal_eps_violation", "rejected": True, "reason": msg2})

    # Case 3: Non-exact suboptimal dual (L < U when require_exact=True)
    caught_gap = False
    msg3 = ""
    try:
        verify_certificate(F, h, eps, mu_ok, nu_ok, Fraction(1, 2), [Fraction(0)], require_exact=True)
    except CertificateTamperError as exc:
        caught_gap = True
        msg3 = str(exc)
    assert caught_gap
    tamper_cases.append({"case": "nonzero_duality_gap", "rejected": True, "reason": msg3})

    # Case 4: Invalid distribution (negative weight / sum != 1)
    caught_dist = False
    msg4 = ""
    try:
        verify_certificate(
            F, h, eps, [Fraction(-1, 2), Fraction(3, 2)], nu_ok, b_ok, c_ok
        )
    except CertificateTamperError as exc:
        caught_dist = True
        msg4 = str(exc)
    assert caught_dist
    tamper_cases.append({"case": "invalid_distribution", "rejected": True, "reason": msg4})

    return tamper_cases


def generate_duality_handshake(write: bool = True) -> Dict[str, Any]:
    out = {
        "ai_written": "Track S3 (24 November 2026), exact fractions.Fraction primal-vs-dual verifier",
        "section_7_1": verify_section_7_1(),
        "b2_aliasing": verify_b2_1000_seed(),
        "track_b_amplification": verify_track_b_amplification(),
        "negative_tamper_checks": run_negative_tamper_checks(),
    }
    if write:
        FIXTURE_PATH.parent.mkdir(parents=True, exist_ok=True)
        FIXTURE_PATH.write_text(json.dumps(out, indent=2) + "\n", encoding="utf-8")
    return out


def main() -> int:
    res = generate_duality_handshake(write=True)
    print(
        json.dumps(
            {
                "sec7_1_absorp": res["section_7_1"]["exact_absorption_b"],
                "sec7_1_recipient_values": [
                    (r["eps"], r["exact_value"]) for r in res["section_7_1"]["with_recipient_rows"]
                ],
                "b2_alpha08_macro": res["b2_aliasing"]["simulation"]["0.8"]["intact"]["macro_counts"],
                "b2_alpha08_exact": res["b2_aliasing"]["duality_certificates"]["0.8"]["exact_value"],
                "track_b_cases": len(res["track_b_amplification"]),
                "tamper_checks_passed": len(res["negative_tamper_checks"]),
            }
        )
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
