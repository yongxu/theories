"""MQ2: the margin's equation of state on Dai, Vorselen, Korolev and Gore (2012)'s yeast, against
held-out regimes. Frozen rules: PREDICTIONS-2026-10-20-MQ2.md.

    python3 -I mq2.py fit  <bifurcation dir>                  # reads the fit-set DFs only
    python3 -I mq2.py test <bifurcation dir> <saltshock dir> <indicator dir>

The daily growth map G takes the density at the start of a day's growth (x = n_t / DF, after the
dilution) to the density at the end of it (n_{t+1}); the draw is the dilution, n_{t+1} = G(n_t / DF).
Units: the bifurcation files' (1e5 cells/ul). Floor f = 0.01 (1000 cells/ul): a reading <= f is
"extinct", one > f "alive"; residuals are censored at f.

Model classes:
  two-phase (Dai et al.'s class): exponential growth at rate gl below a density nc, logistic growth
    at rate gh towards k above it, for T = 23.5 h; parameters (a = gl T, b = gh / gl, nc, k). It has
    a need at DF between e^a and DF* = max_x G(x)/x when b > 1, and none when b <= 1.
  logistic (the no-need null): G(x) = k x e^R / (k + x (e^R - 1)); parameters (R, k). Per-capita
    growth G(x)/x falls with x, so under any dilution there is no unstable positive point.
Fit: least squares of the censored log residual log max(G(x), f) - log max(y, f) over every pair of
consecutive days (t = 1..6) of every population at the fit-set DFs whose n_t > f; Nelder-Mead from
fixed starts.

Standard library only. The data are untrusted: read with python -I, from outside their directory.
"""

import json
import math
import os
import random
import sys

T = 23.5
FLOOR = 0.01
FIT_DFS = [250, 500, 1000, 1266]
HELD_DFS = [750, 1133, 1400, 1600]
ALL_DFS = sorted(FIT_DFS + HELD_DFS)
SALT_DFS = [250, 500, 750, 825]          # columns of saltshock_day{d}.txt, in this order (assumed)
HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, "results", "mq2")


# ---------------------------------------------------------------- reading

def read_bifurcation(directory, dfs):
    """population -> [n_1..n_7] for each DF in dfs; files of other DFs are not opened."""
    data = {}
    for df in dfs:
        days = []
        for d in range(1, 8):
            path = os.path.join(directory, f"dilution{df}_day{d}.txt")
            days.append([float(v) for line in open(path) if line.strip() for v in line.split()])
        data[df] = [[days[d][i] for d in range(7)] for i in range(len(days[0]))]
    return data


def read_matrix(path):
    return [[float(v) for v in line.split()] for line in open(path) if line.strip()]


# ---------------------------------------------------------------- models

def two_phase(theta):
    a, logb, lognc, logk = theta
    gl = a / T
    gh = gl * math.exp(logb)
    nc, k = math.exp(lognc), math.exp(logk)

    def G(x):
        if x <= 0.0:
            return 0.0
        t = T
        if x < nc:
            tau = math.log(nc / x) / gl if gl > 0 else float("inf")
            if tau >= t:
                return x * math.exp(gl * t)
            x, t = nc, t - tau
        if x >= k:
            return k + (x - k) * math.exp(-gh * t)
        return k / (1.0 + (k / x - 1.0) * math.exp(-gh * t))
    return G


def logistic(theta):
    R, logk = theta
    k = math.exp(logk)
    eR = math.exp(min(R, 50.0))

    def G(x):
        if x <= 0.0:
            return 0.0
        return k * x * eR / (k + x * (eR - 1.0))
    return G


MODELS = {
    "two_phase": (two_phase, [[math.log(350), math.log(1.4), math.log(1e-3), math.log(2.0)],
                              [math.log(200), math.log(2.0), math.log(1e-2), math.log(3.0)],
                              [math.log(500), math.log(1.2), math.log(1e-4), math.log(1.5)],
                              [math.log(300), math.log(1.0), math.log(3e-3), math.log(2.5)]]),
    "logistic": (logistic, [[math.log(400), math.log(2.0)], [math.log(1000), math.log(3.0)],
                            [math.log(2000), math.log(1.5)]]),
}


def pairs_of(data, dfs):
    return [(p[t] / df, p[t + 1]) for df in dfs for p in data[df] for t in range(6) if p[t] > FLOOR]


def resid(G, x, y):
    return math.log(max(G(x), FLOOR)) - math.log(max(y, FLOOR))


def sse(G, pairs):
    return sum(resid(G, x, y) ** 2 for x, y in pairs)


def nelder_mead(f, x0, step=0.3, iters=3000, tol=1e-10):
    n = len(x0)
    pts = [list(x0)] + [[x0[j] + (step if j == i else 0.0) for j in range(n)] for i in range(n)]
    vals = [f(p) for p in pts]
    for _ in range(iters):
        order = sorted(range(n + 1), key=lambda i: vals[i])
        pts, vals = [pts[i] for i in order], [vals[i] for i in order]
        if abs(vals[-1] - vals[0]) < tol * (1 + abs(vals[0])):
            break
        c = [sum(p[j] for p in pts[:-1]) / n for j in range(n)]
        xr = [c[j] + (c[j] - pts[-1][j]) for j in range(n)]
        fr = f(xr)
        if fr < vals[0]:
            xe = [c[j] + 2 * (c[j] - pts[-1][j]) for j in range(n)]
            fe = f(xe)
            pts[-1], vals[-1] = (xe, fe) if fe < fr else (xr, fr)
        elif fr < vals[-2]:
            pts[-1], vals[-1] = xr, fr
        else:
            xc = [c[j] + 0.5 * (pts[-1][j] - c[j]) for j in range(n)]
            fc = f(xc)
            if fc < vals[-1]:
                pts[-1], vals[-1] = xc, fc
            else:
                pts = [pts[0]] + [[pts[0][j] + 0.5 * (p[j] - pts[0][j]) for j in range(n)]
                                  for p in pts[1:]]
                vals = [vals[0]] + [f(p) for p in pts[1:]]
    i = min(range(n + 1), key=lambda i: vals[i])
    return pts[i], vals[i]


def fit(name, pairs):
    make, starts = MODELS[name]

    def f(th):
        try:
            v = sse(make(th), pairs)
        except (OverflowError, ValueError, ZeroDivisionError):
            return 1e18
        return v if math.isfinite(v) else 1e18
    best = None
    for s in starts:
        th, v = nelder_mead(f, s)
        th, v = nelder_mead(f, th, step=0.05)       # restart from the optimum
        if best is None or v < best[1]:
            best = (th, v)
    return best


# ---------------------------------------------------------------- equation of state

def fixed_points(G, df, lo=1e-5, hi=20.0, steps=6000):
    """Unstable (upward) and stable (downward) crossings of G(n/df) - n on a log grid."""
    up, down = [], []
    a, b = math.log(lo), math.log(hi)
    prev_n, prev = lo, G(lo / df) - lo
    for i in range(1, steps + 1):
        n = math.exp(a + (b - a) * i / steps)
        cur = G(n / df) - n
        if prev < 0 <= cur or prev >= 0 > cur:
            l, r = prev_n, n
            for _ in range(60):
                m = math.sqrt(l * r)
                if (G(l / df) - l) * (G(m / df) - m) <= 0:
                    r = m
                else:
                    l = m
            (up if prev < 0 else down).append(math.sqrt(l * r))
        prev_n, prev = n, cur
    return up, down


def fold(G, lo=1e-9, hi=20.0, steps=8000):
    a, b = math.log(lo), math.log(hi)
    best = max((G(math.exp(a + (b - a) * i / steps)) / math.exp(a + (b - a) * i / steps), i)
               for i in range(steps + 1))
    return best[0]


def state(G, df):
    """Need u (lowest unstable point; 0 if renewal never fails at small n), stable level s, margin."""
    up, down = fixed_points(G, df)
    low_growth = G(1e-9) / 1e-9
    u = up[0] if up else (0.0 if low_growth > df else None)
    s = max(down) if down else None
    return dict(need=u, stable=s, margin=(s - u) if (s is not None and u is not None) else None)


# ---------------------------------------------------------------- fit step (frozen predictions)

def do_fit(bif_dir):
    data = read_bifurcation(bif_dir, FIT_DFS)
    pairs = pairs_of(data, FIT_DFS)
    res = dict(fit_dfs=FIT_DFS, held_dfs=HELD_DFS, floor=FLOOR, fit_pairs=len(pairs), models={})
    for name in MODELS:
        th, v = fit(name, pairs)
        G = MODELS[name][0](th)
        res["models"][name] = dict(
            theta=th, sse=v, rmse=math.sqrt(v / len(pairs)), fold_df=fold(G),
            low_density_daily_growth=G(1e-9) / 1e-9,
            states={df: state(G, df) for df in sorted(set(ALL_DFS + SALT_DFS))})
    # bootstrap over populations of the fit set (reported, not a rule)
    rng = random.Random(20261020)
    boot = []
    th0 = res["models"]["two_phase"]["theta"]
    for _ in range(int(os.environ.get("MQ2_BOOT", "60"))):
        sample = {df: [rng.choice(data[df]) for _ in data[df]] for df in FIT_DFS}
        pb = pairs_of(sample, FIT_DFS)
        th, _ = nelder_mead(lambda t: sse(two_phase(t), pb), th0, step=0.1)
        G = two_phase(th)
        boot.append(dict(fold_df=fold(G), states={df: state(G, df) for df in HELD_DFS + SALT_DFS}))
    def q(vals, p):
        vals = sorted(v for v in vals if v is not None)
        return vals[int(p * (len(vals) - 1))] if vals else None
    res["bootstrap_two_phase"] = dict(
        n=len(boot),
        fold_df=[q([b["fold_df"] for b in boot], 0.05), q([b["fold_df"] for b in boot], 0.95)],
        need={df: [q([b["states"][df]["need"] for b in boot], 0.05),
                   q([b["states"][df]["need"] for b in boot], 0.95)] for df in HELD_DFS + SALT_DFS},
        stable={df: [q([b["states"][df]["stable"] for b in boot], 0.05),
                     q([b["states"][df]["stable"] for b in boot], 0.95)]
                for df in HELD_DFS + SALT_DFS})
    os.makedirs(OUT, exist_ok=True)
    with open(os.path.join(OUT, "fit.json"), "w") as fh:
        json.dump(res, fh, indent=1)
    print(json.dumps(res, indent=1))


# ---------------------------------------------------------------- test step

def accuracy(preds, outs):
    return sum(1 for p, o in zip(preds, outs) if p == o) / len(outs) if outs else None


def best_threshold(starts, alive):
    """Empirical need: the threshold that classifies most fates (alive iff start > u); the
    geometric midpoint of the best interval of candidate thresholds."""
    cands = sorted(set([FLOOR] + [s for s in starts if s > FLOOR]))
    best, arg = -1.0, []
    for i, c in enumerate(cands):
        acc = accuracy([s > c for s in starts], alive)
        if acc > best + 1e-12:
            best, arg = acc, [i]
        elif abs(acc - best) <= 1e-12:
            arg.append(i)
    i = arg[len(arg) // 2]
    lo = cands[i]
    hi = cands[i + 1] if i + 1 < len(cands) else cands[i]
    return math.sqrt(lo * hi), best


def unit_scale(values, expected):
    """Units rule (frozen): readings whose median is more than 1000x the expected level (in 1e5
    cells/ul) are in cells/ul and are divided by 1e5; otherwise they are in 1e5 cells/ul."""
    vals = sorted(values)
    med = vals[len(vals) // 2]
    return 1e-5 if med > 1000.0 * expected else 1.0


def do_test(bif_dir, salt_dir, ind_dir):
    fitres = json.load(open(os.path.join(OUT, "fit.json")))
    G2 = two_phase(fitres["models"]["two_phase"]["theta"])
    GL = logistic(fitres["models"]["logistic"]["theta"])
    st2 = {int(k): v for k, v in fitres["models"]["two_phase"]["states"].items()}
    stL = {int(k): v for k, v in fitres["models"]["logistic"]["states"].items()}
    out = dict(floor=FLOOR)

    # M: held-out one-day prediction, two-phase against the null
    held = read_bifurcation(bif_dir, HELD_DFS)
    hp = pairs_of(held, HELD_DFS)
    r2 = math.sqrt(sse(G2, hp) / len(hp))
    rL = math.sqrt(sse(GL, hp) / len(hp))
    by = {df: dict(two_phase=math.sqrt(sse(G2, pairs_of(held, [df])) / len(pairs_of(held, [df]))),
                   logistic=math.sqrt(sse(GL, pairs_of(held, [df])) / len(pairs_of(held, [df]))))
          for df in HELD_DFS}
    out["M"] = dict(pairs=len(hp), rmse_two_phase=r2, rmse_logistic=rL, by_df=by,
                    verdict="passed" if r2 < rL else "failed")

    # A: the need against fates at each held-out DF
    a_rows, a1_ok, a2_ok, a_null = {}, True, True, {}
    for df in HELD_DFS:
        u = st2[df]["need"]
        starts = [p[0] for p in held[df]]
        alive = [p[6] > FLOOR for p in held[df]]
        row = dict(need=u, populations=len(starts), alive=sum(alive))
        if u is None:
            row["note"] = "no positive state predicted (past the fold)"
            a1_ok = a2_ok = False
            a_rows[df] = row
            continue
        # a start read <= f is placed only when the threshold compared with it is >= f
        hi = [a for s, a in zip(starts, alive) if s > 1.5 * u and s > FLOOR]
        lo = [a for s, a in zip(starts, alive) if s < u / 1.5 and (s > FLOOR or u / 1.5 >= FLOOR)]
        res_ = [(s, a) for s, a in zip(starts, alive) if s > FLOOR or u >= FLOOR]
        row.update(high_n=len(hi), low_n=len(lo),
                   high_alive=(sum(hi) / len(hi)) if hi else None,
                   low_extinct=(sum(1 for a in lo if not a) / len(lo)) if lo else None,
                   resolvable=len(res_),
                   accuracy_all=accuracy([s > u for s, _ in res_], [a for _, a in res_]))
        row["testable"] = len(hi) >= 5 and len(lo) >= 5
        if row["testable"]:
            row["A1"] = row["high_alive"] >= 0.9 and row["low_extinct"] >= 0.9
            a1_ok = a1_ok and row["A1"]
        if u >= 1.5 * FLOOR and 0 < sum(alive) < len(alive):
            ustar, acc = best_threshold(starts, alive)
            row.update(empirical_need=ustar, empirical_accuracy=acc,
                       A2=(abs(math.log(u / ustar)) <= math.log(1.5)) if u > 0 else False)
            a2_ok = a2_ok and row["A2"]
        else:
            row["A2"] = None
        uL = stL[df]["need"]
        a_null[df] = accuracy([(s > uL) if uL else True for s in starts], alive) if uL is not None \
            else accuracy([False] * len(starts), alive)
        a_rows[df] = row
    tested1 = [r for r in a_rows.values() if r.get("testable")]
    tested2 = [r for r in a_rows.values() if r.get("A2") is not None]
    out["A"] = dict(by_df=a_rows, null_accuracy_all=a_null,
                    A1="not testable" if not tested1 else ("passed" if a1_ok else "failed"),
                    A2="not testable" if not tested2 else ("passed" if a2_ok else "failed"))

    # B: the fold and the rise of the measured need
    fdf = fitres["models"]["two_phase"]["fold_df"]
    emp = [(df, a_rows[df].get("empirical_need")) for df in HELD_DFS]
    emp_ok = [e for _, e in emp if e is not None]
    out["B"] = dict(fold_df=fdf, B1="reported only (no data past DF 1600)",
                    empirical_needs=dict(emp),
                    B2=("not testable" if len(emp_ok) < 3 else
                        ("passed" if all(b > a for a, b in zip(emp_ok, emp_ok[1:])) else "failed")))

    # S: stable levels of the indicator experiment (a separate experiment), all eight DFs
    s_rows, s_ok, e2, eL = {}, True, 0.0, 0.0
    scale = None
    for df in ALL_DFS:
        mat = read_matrix(os.path.join(ind_dir, f"all_dilution{df}.txt"))
        vals = [v for row in mat for v in row]
        if scale is None:   # decided on DF 250's file
            scale = unit_scale(vals, st2[250]["stable"])
        vals = [v * scale for v in vals]
        live = sorted(v for v in vals if v > FLOOR)
        med = live[len(live) // 2] if live else None
        s2, sL = st2[df]["stable"], stL[df]["stable"]
        row = dict(rows=len(mat), readings=len(vals), alive_readings=len(live), median=med,
                   predicted_two_phase=s2, predicted_logistic=sL)
        if med and s2:
            row["ratio_two_phase"] = s2 / med
            row["within_1_5"] = abs(math.log(s2 / med)) <= math.log(1.5)
            s_ok = s_ok and row["within_1_5"]
            e2 += abs(math.log(s2 / med))
            eL += abs(math.log(sL / med)) if sL else float("inf")
        else:
            s_ok = False
        s_rows[df] = row
    out["S"] = dict(unit_scale=scale, by_df=s_rows, sum_abs_log_error_two_phase=e2,
                    sum_abs_log_error_logistic=eL,
                    S="passed" if (s_ok and e2 <= eL) else "failed")

    # S2: day-7 levels of the held-out bifurcation populations
    s2_rows, s2_ok = {}, True
    for df in HELD_DFS:
        live = sorted(p[6] for p in held[df] if p[6] > FLOOR)
        med = live[len(live) // 2] if live else None
        s2 = st2[df]["stable"]
        ok = bool(med and s2 and abs(math.log(s2 / med)) <= math.log(1.5))
        s2_rows[df] = dict(median_day7_alive=med, alive=len(live), predicted=s2,
                           ratio=(s2 / med) if (med and s2) else None, within_1_5=ok)
        s2_ok = s2_ok and ok
    out["S2"] = dict(by_df=s2_rows, S2="passed" if s2_ok else "failed")

    # C: salt shock, the pulse margin
    days = {d: read_matrix(os.path.join(salt_dir, f"saltshock_day{d}.txt")) for d in range(1, 10)}
    ncol = len(days[1][0])
    col = lambda d, j: [r[j] for r in days[d]]
    sc = unit_scale(col(2, 0) + col(3, 0) + col(4, 0), st2[250]["stable"])
    pre = [sorted(v * sc for d in (2, 3, 4) for v in col(d, j)) for j in range(ncol)]
    pre_med = [p[len(p) // 2] for p in pre]
    mapping_ok = ncol == len(SALT_DFS) and pre_med[0] > pre_med[-1]
    c = dict(unit_scale=sc, pre_shock_median=dict(zip(SALT_DFS, pre_med)), mapping_check=mapping_ok)
    if not mapping_ok:
        c.update(C1="not testable", C2="not testable")
    else:
        for tag, day in (("C1", 5), ("C2", 6)):
            preds, outs, nulls, rows, unres = [], [], [], {}, 0
            for j, df in enumerate(SALT_DFS):
                u = st2[df]["need"]
                post = [v * sc for v in col(day, j)]
                fate = [v * sc > FLOOR for v in col(9, j)]
                pr = [(p > u) if u is not None else False for p in post]
                ok_ = [p > FLOOR or u is None or u >= FLOOR for p in post]   # resolvable
                unres += ok_.count(False)
                preds += [x for x, k in zip(pr, ok_) if k]
                outs += [x for x, k in zip(fate, ok_) if k]
                uL = stL[df]["need"]
                nulls += [((p > uL) if uL is not None else False) for p, k in zip(post, ok_) if k]
                rows[df] = dict(need=u, post_shock=post, alive_day9=fate, predicted=pr,
                                pulse_margin=[pm - u for pm in pre[j]] if u is not None else None)
            acc = accuracy(preds, outs)
            if len(outs) < 16:
                verdict = "not testable"
            else:
                verdict = "passed" if acc >= 0.9 and acc > accuracy(nulls, outs) else "failed"
            c[tag] = dict(day=day, resolvable=len(outs), unresolvable=unres, accuracy=acc,
                          null_accuracy=accuracy(nulls, outs), by_df=rows, verdict=verdict)
    out["C"] = c
    out["D"] = ("not testable: the indicator files hold fixed DFs at equilibrium (rows = populations, "
                "5 columns = days); no DF passes the fold, so there is no time to break")
    with open(os.path.join(OUT, "VERDICTS-mq2.json"), "w") as fh:
        json.dump(out, fh, indent=1)
    print(json.dumps({k: (v if not isinstance(v, dict) else
                          {kk: vv for kk, vv in v.items() if not isinstance(vv, dict)})
                      for k, v in out.items()}, indent=1))


if __name__ == "__main__":
    if sys.argv[1] == "fit":
        do_fit(sys.argv[2])
    elif sys.argv[1] == "test":
        do_test(sys.argv[2], sys.argv[3], sys.argv[4])
