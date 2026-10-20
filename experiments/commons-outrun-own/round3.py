"""Round 3 of CG3 (board item CG3b, PREDICTIONS-ROUND3-2026-10-20.md): the boundary where a
stepwise learner keeps the gated patch, from one exact index with one fitted constant.

The mechanism rounds 1-2 found: a tabular learner holds a trained act only at the (level, step)
states its training has visited enough, and elsewhere its greedy act is the full draw (whose
apples it learns first).  The index:

  visits(x, t) = E / (m + 1) * sum over start steps t0 <= t of P(start at t0)
                 * P(level x at step t | started at t0, requests uniform over 0..m)

the expected training updates of each action at level x, step t (E episodes, exploring starts
as trained: a random step, apples standing independently with a uniform random density; the
behaviour of early training, uniform requests).  Given a constant n*, the index policy takes
the exact optimal act (over configurations) where visits(level, t) >= n* and the full draw
elsewhere, and the index A is the exact probability that it leaves a full patch standing at
step H - 20.  n* is fitted once on the finished conditions of rounds 1 and 2 (least squares
against the measured share alive at H - 20) and frozen; A then predicts every new condition.

    python3 round3.py fit       # the index's fit (failed before any run; results/round3-fit.json)

The index fitted badly on the 14 finished conditions (SSE 3.6 at the best n*, against 0.65 for a
three-feature logistic): it is recorded as a failed calibration and predicts nothing.  Round 3
instead maps the boundary statistically (PREDICTIONS-ROUND3-2026-10-20.md):

    python3 round3.py grid      # exact features of the grid: results/round3-grid.json
    python3 round3.py runA      # half A (fit half), 12 seeds: results/round3-runsA.json
    python3 round3.py predict   # fit on rounds 1-2 + half A, predictions for half B (frozen)
    python3 round3.py runB      # half B: results/round3-runsB.json
    python3 round3.py analyze   # verdicts: results/round3-VERDICTS.json
    python3 round3.py smoke     # every code path, a few episodes, nothing kept
"""

import json
import math
import os
import random
import sys
import time
from multiprocessing import Pool

import exact
import own
import round2
from run import CONFIG

HERE = os.path.dirname(os.path.abspath(__file__))
RESULTS = os.path.join(HERE, "results")
H, POP, FULL = exact.H, exact.POP, exact.FULL
WINDOW = 10        # early starts: a step uniform in [0, WINDOW)


def start_dist(early):
    """P(start at t0), t0 = 0..H-1: with probability `early` uniform in [0, WINDOW), else uniform."""
    return [early / WINDOW * (t0 < WINDOW) + (1.0 - early) / H for t0 in range(H)]


def start_configs():
    """Apples standing independently with density u ~ U(0, 1): P(c) = 1 / (10 * C(9, k))."""
    return {c: 1.0 / (10 * math.comb(9, POP[c])) for c in range(512)}


def level_after(pr, m, steps):
    """L[j][x] = P(level x, j steps after a start), requests uniform over 0..m."""
    dist, out = start_configs(), []
    probs = [1.0 / (m + 1)] * (m + 1)
    for _j in range(steps):
        lv = [0.0] * 10
        for c, p in dist.items():
            lv[POP[c]] += p
        out.append(lv)
        nd = {}
        for c, p in dist.items():
            for a, pa in enumerate(probs):
                _, ys = pr.out[c][a]
                q = p * pa / len(ys)
                for y in ys:
                    for z, pz in pr.D[y]:
                        nd[z] = nd.get(z, 0.0) + q * pz
        dist = nd
    return out


def visits(pr, m, early, episodes):
    L = level_after(pr, m, H)
    P = start_dist(early)
    V = [[0.0] * H for _ in range(10)]
    for t in range(H):
        for t0 in range(t + 1):
            w = P[t0] * episodes / (m + 1)
            if w:
                lv = L[t - t0]
                for x in range(10):
                    V[x][t] += w * lv[x]
    return V


class Index:
    """Everything n*-independent for one condition, so that A(n*) is cheap to evaluate."""

    def __init__(self, m, s, w, early, episodes):
        self.m = m
        self.pr = exact.Problem(m, s, w, 0.0)
        self.opt, _ = self.pr.optimal()
        self.V = visits(self.pr, m, early, episodes)

    def A(self, nstar):
        """P(standing at H - 20) from a full patch under the index policy: the optimal act where
        visits >= n*; the full draw where 1 <= visits < n* (immediate apples learned first);
        uniform over 0..m where visits < 1 (all values still 0, ties broken at random, as
        learners.Q.act does)."""
        m, pr = self.m, self.pr
        uni = [1.0 / (m + 1)] * (m + 1)
        dist = {FULL: 1.0}
        for t in range(H - 20):
            tau = H - t
            nd = {}
            for c, p in dist.items():
                v = self.V[POP[c]][t]
                if v >= nstar:
                    acts = [(self.opt[tau][c], 1.0)]
                elif v >= 1.0:
                    acts = [(m, 1.0)]
                else:
                    acts = list(enumerate(uni))
                for a, pa in acts:
                    _, ys = pr.out[c][a]
                    q = p * pa / len(ys)
                    for y in ys:
                        for z, pz in pr.D[y]:
                            nd[z] = nd.get(z, 0.0) + q * pz
            dist = nd
        return sum(p for c, p in dist.items() if POP[c] >= 1)


NSTARS = [round(10 ** (k / 10), 2) for k in range(0, 41)]     # 1 .. 10,000, 10 per decade


def curve(args):
    name, m, s, w, early, episodes = args
    ix = Index(m, s, w, early, episodes)
    return name, [ix.A(n) for n in NSTARS]


# the finished conditions of rounds 1 and 2 (J3opt left out: optimistic values change the behaviour)
def fit_set():
    r1 = json.load(open(os.path.join(RESULTS, "VERDICTS.json")))["conditions"]
    r2 = json.load(open(os.path.join(RESULTS, "round2-VERDICTS.json")))["conditions"]
    from conditions import CONDITIONS as C1
    rows = []
    for n, c in C1.items():
        if c["q0"]:
            continue
        rows.append((n, c["m"], c["s"], c["w"], 0.0, CONFIG["episodes"], r1[n]["alive_probe_mean"]))
    for n, c in round2.CONDITIONS.items():
        rows.append((n, c["m"], c["s"], c["w"], 0.5 if c["early"] else 0.0, CONFIG["episodes"],
                     r2[n]["alive_probe_mean"]))
    return rows


def features(m, s, early):
    pr = exact.Problem(m, s, 6.0, 0.0)
    cov = sum(pr.alive_curve([1.0 / (m + 1)] * (m + 1)))
    full = sum(pr.alive_curve([0.0] * m + [1.0]))
    return cov, full


def logistic_fit(X, y, iters=20000, lr=0.05, l2=1e-3):
    """Least squares of sigmoid(b . x) against y (shares), by gradient descent; x includes 1."""
    b = [0.0] * len(X[0])
    for _ in range(iters):
        g = [0.0] * len(b)
        for xi, yi in zip(X, y):
            z = sum(bj * xj for bj, xj in zip(b, xi))
            p = 1.0 / (1.0 + math.exp(-max(-30, min(30, z))))
            d = (p - yi) * p * (1 - p)
            for j, xj in enumerate(xi):
                g[j] += d * xj
        b = [bj - lr * (gj / len(X) + l2 * bj) for bj, gj in zip(b, g)]
    return b


def logistic_x(cov, full, early, episodes):
    return [1.0, math.log(cov), math.log(full), early, math.log(episodes / CONFIG["episodes"])]


def logistic_p(b, x):
    z = sum(bj * xj for bj, xj in zip(b, x))
    return 1.0 / (1.0 + math.exp(-max(-30, min(30, z))))


def do_fit():
    rows = fit_set()
    with Pool(min(len(rows), int(os.environ.get("CG3_JOBS", 8)))) as p:
        curves = dict(p.map(curve, [r[:6] for r in rows]))
        feats = dict(zip([r[0] for r in rows], p.starmap(features, [(r[1], r[2], r[4]) for r in rows])))
    obs = {r[0]: r[6] for r in rows}
    sse = [sum((curves[n][k] - obs[n]) ** 2 for n in obs) for k in range(len(NSTARS))]
    k = min(range(len(NSTARS)), key=lambda i: (sse[i], i))
    X = [logistic_x(*feats[r[0]], r[4], r[5]) for r in rows]
    b = logistic_fit(X, [obs[r[0]] for r in rows])
    out = dict(nstar=NSTARS[k], sse=sse[k], sse_by_nstar=dict(zip(map(str, NSTARS), sse)),
               fit={n: dict(observed=obs[n], index=curves[n][k], cov=feats[n][0], full=feats[n][1],
                            logistic=logistic_p(b, logistic_x(*feats[n], dict((r[0], r[4]) for r in rows)[n],
                                                              CONFIG["episodes"])))
                    for n in obs},
               logistic_coefficients=b)
    out["logistic_sse"] = sum((v["logistic"] - v["observed"]) ** 2 for v in out["fit"].values())
    json.dump(out, open(os.path.join(RESULTS, "round3-fit.json"), "w"), indent=1)
    print("n* =", out["nstar"], "SSE", round(out["sse"], 3), "logistic SSE", round(out["logistic_sse"], 3))
    for n, v in out["fit"].items():
        print(f"{n:10} obs {v['observed']:.2f}  index {v['index']:.2f}  logistic {v['logistic']:.2f}  "
              f"cov {v['cov']:.1f} full {v['full']:.1f}")


# ---------------------------------------------------------------- round 3: the mapped boundary

SEEDS = 12
# (m, s): alternate within each draw cap, sorted by regrowth, starting with A
GRID = {3: [5, 6, 7, 9, 11, 12, 13], 2: [2, 3, 5, 6, 7, 9, 10], 1: [0.5, 0.75]}
HALF = {f"G{m}s{s}": ("A" if i % 2 == 0 else "B", m, s) for m, ss in GRID.items() for i, s in enumerate(ss)}


def grid_features():
    names = list(HALF)
    with Pool(min(len(names), int(os.environ.get("CG3_JOBS", 8)))) as p:
        fs = p.starmap(features, [(HALF[n][1], HALF[n][2], 0.0) for n in names])
    out = {n: dict(half=HALF[n][0], m=HALF[n][1], s=HALF[n][2], cov=c, full=f) for n, (c, f) in zip(names, fs)}
    json.dump(out, open(os.path.join(RESULTS, "round3-grid.json"), "w"), indent=1)
    for n, v in out.items():
        print(n, v["half"], round(v["cov"], 1), round(v["full"], 1))


def run_half(half, cfg_over=None, tag=None):
    grid = json.load(open(os.path.join(RESULTS, "round3-grid.json")))
    cfg = dict(CONFIG, seeds=SEEDS)
    if cfg_over:
        cfg.update(cfg_over)
    js = [((n, k), dict(cond=round2.cond(v["m"], v["s"]), seed=f"cg3r3/{n}/{k}", H=cfg["H"], alpha=cfg["alpha"],
                        eps_end=cfg["eps_end"], eps_frac=cfg["eps_frac"], episodes=cfg["episodes"],
                        eval_episodes=cfg["eval_episodes"], probe=cfg["probe"]))
          for n, v in grid.items() if v["half"] in half for k in range(cfg["seeds"])]
    t = time.time()
    with Pool(int(os.environ.get("CG3_JOBS", 8))) as pool:
        res = pool.map(round2.work, js, chunksize=1)
    print(f"{len(res)} runs in {time.time() - t:.0f} s, "
          f"{sum(r['seconds'] for _, r in res) / 60:.1f} CPU-minutes", flush=True)
    runs = [dict(cond=n, seed=k, **r) for (n, k), r in res]
    if tag:
        json.dump(dict(config=cfg, runs=runs), open(os.path.join(RESULTS, f"round3-runs{tag}.json"), "w"))
    return runs


def shares(runs):
    by = {}
    for r in runs:
        by.setdefault(r["cond"], []).append(sum(1 for x in r["eval"]["alive_probe"] if x >= 1)
                                            / len(r["eval"]["alive_probe"]))
    return {n: dict(mean=sum(a) / len(a), by_seed=a) for n, a in by.items()}


def fit_rows():
    """Every finished condition with round 1's start distribution and zero initial values:
    rounds 1 and 2 (20 seeds) and round 3's half A (12 seeds); features and measured share."""
    r1 = json.load(open(os.path.join(RESULTS, "VERDICTS.json")))["conditions"]
    r2 = json.load(open(os.path.join(RESULTS, "round2-VERDICTS.json")))["conditions"]
    ex1 = json.load(open(os.path.join(RESULTS, "exact.json")))["conditions"]
    ex2 = json.load(open(os.path.join(RESULTS, "round2-exact.json")))
    from conditions import CONDITIONS as C1
    rows = []
    for n, c in C1.items():
        if not c["q0"]:
            rows.append((n, ex1[n]["alive_steps_uniform"], ex1[n]["alive_steps_full"], r1[n]["alive_probe_mean"]))
    for n, c in round2.CONDITIONS.items():
        if not c["early"]:
            rows.append((n, ex2[n]["cov"], ex2[n]["full"], r2[n]["alive_probe_mean"]))
    grid = json.load(open(os.path.join(RESULTS, "round3-grid.json")))
    A = shares(json.load(open(os.path.join(RESULTS, "round3-runsA.json")))["runs"])
    for n, v in grid.items():
        if v["half"] == "A":
            rows.append((n, v["cov"], v["full"], A[n]["mean"]))
    return rows


def bx(cov, full):
    return [1.0, math.log(cov), math.log(full)]


def rule1(cov, full):      # round 1's frozen rule (coverage alone)
    return 1.0 if cov >= 20 else (0.0 if cov <= 7 else 0.5)


def rule2(cov, full):      # round 2's frozen rule (round 1's start distribution)
    if cov <= 10:
        return 0.0
    if cov >= 20 and full >= 9:
        return 1.0
    if full <= 5.5:
        return 0.0
    return 0.5


def predict():
    rows = fit_rows()
    b = logistic_fit([bx(c, f) for _, c, f, _ in rows], [y for *_, y in rows], iters=40000)
    grid = json.load(open(os.path.join(RESULTS, "round3-grid.json")))
    out = dict(coefficients=b, fit_rows=[dict(name=n, cov=c, full=f, observed=y, fitted=logistic_p(b, bx(c, f)))
                                         for n, c, f, y in rows], predictions={})
    out["fit_sse"] = sum((r["fitted"] - r["observed"]) ** 2 for r in out["fit_rows"])
    for n, v in grid.items():
        if v["half"] == "B":
            p = logistic_p(b, bx(v["cov"], v["full"]))
            out["predictions"][n] = dict(cov=v["cov"], full=v["full"], p=p,
                                         cls="kept" if p >= 0.8 else ("depleted" if p <= 0.2 else "between"),
                                         rule1=rule1(v["cov"], v["full"]), rule2=rule2(v["cov"], v["full"]))
    json.dump(out, open(os.path.join(RESULTS, "round3-predictions.json"), "w"), indent=1)
    print("coefficients", [round(x, 3) for x in b], "fit SSE", round(out["fit_sse"], 3))
    for r in out["fit_rows"]:
        print(f"  fit {r['name']:10} cov {r['cov']:5.1f} full {r['full']:5.1f} obs {r['observed']:.2f} fitted {r['fitted']:.2f}")
    for n, v in out["predictions"].items():
        print(f"  B   {n:10} cov {v['cov']:5.1f} full {v['full']:5.1f} p {v['p']:.2f} {v['cls']}  rule1 {v['rule1']} rule2 {v['rule2']}")


BETWEEN_TOL = 0.25


def analyze3():
    pred = json.load(open(os.path.join(RESULTS, "round3-predictions.json")))["predictions"]
    runsB = json.load(open(os.path.join(RESULTS, "round3-runsB.json")))["runs"]
    runsA = json.load(open(os.path.join(RESULTS, "round3-runsA.json")))["runs"]
    B = shares(runsB)
    out = dict(conditions={}, identity={})
    for n, v in pred.items():
        o = B[n]["mean"]
        if v["cls"] == "kept":
            ok = o >= 0.8
        elif v["cls"] == "depleted":
            ok = o <= 0.2
        else:
            ok = abs(o - v["p"]) <= BETWEEN_TOL
        out["conditions"][n] = dict(v, observed=o, by_seed=B[n]["by_seed"], verdict="passed" if ok else "failed")
    rs = list(out["conditions"].values())
    mae = lambda key: sum(abs(r[key] - r["observed"]) for r in rs) / len(rs)
    out["mae"] = dict(logistic=mae("p"), rule1=mae("rule1"), rule2=mae("rule2"))
    npass = sum(r["verdict"] == "passed" for r in rs)
    out["contrasts"] = dict(W1_at_least_5_of_7=npass >= 5,
                            W2_beats_both_rules=out["mae"]["logistic"] < min(out["mae"]["rule1"], out["mae"]["rule2"]))
    tot = {}
    for r in runsA + runsB:
        for key, val in list(r["checks"].items()) + [("emptied_" + k, v) for k, v in r["emptied"].items()]:
            tot[key] = tot.get(key, 0) + val
    out["identity"] = dict(steps=tot["steps"], violations=tot["balance_viol"] + tot["gate_given_below"]
                           + tot["margin_viol"] + tot["je_viol"], own_excess_windows=tot["je_windows"],
                           emptied=tot["emptied_episodes"], emptied_violations=tot["emptied_violations"])
    out["identity"]["verdict"] = "passed" if (out["identity"]["violations"] == 0 == out["identity"]["emptied_violations"]
                                             and out["identity"]["own_excess_windows"] > 0) else "failed"
    out["halfA"] = {n: v for n, v in shares(runsA).items()}
    json.dump(out, open(os.path.join(RESULTS, "round3-VERDICTS.json"), "w"), indent=1)
    for n, r in out["conditions"].items():
        print(f"{n:9} cov {r['cov']:5.1f} full {r['full']:5.1f} p {r['p']:.2f} ({r['cls']}) obs {r['observed']:.2f}  {r['verdict']}")
    print("MAE", {k: round(v, 3) for k, v in out["mae"].items()}, out["contrasts"], out["identity"])


if __name__ == "__main__":
    mode = sys.argv[1] if len(sys.argv) > 1 else "grid"
    if mode == "fit":
        do_fit()
    elif mode == "grid":
        grid_features()
    elif mode == "runA":
        run_half("A", tag="A")
    elif mode == "predict":
        predict()
    elif mode == "runB":
        run_half("B", tag="B")
    elif mode == "analyze":
        analyze3()
    elif mode == "smoke":
        for r in run_half("AB", dict(episodes=30, seeds=1, eval_episodes=3)):
            print(r["cond"], r["checks"]["je_viol"], r["emptied"], r["eval"]["final"])
