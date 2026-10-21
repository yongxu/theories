"""Round 4 of CG3 (board item CG3c, PREDICTIONS-ROUND4-2026-10-21.md): the band form of the
boundary, read post hoc from rounds 1-3, frozen and tested on new conditions.

The band rule, in the two exact quantities (round3.features): `full`, the steps a full patch
stands under the full draw (whether a course from the start, where the learner's values are
least trained and its greedy act is the full draw, can reach the steps where restraint is
learned), and `cov`, the steps it stands under uniform requests (how far the early behaviour's
courses carry training into the start region):

    full <= 4.4                  depleted
    full >= 8.4                  kept
    between, cov >= 60           kept
    between, cov <= 16           depleted
    between, otherwise           between: the share kept lies in (0.05, 0.80), and rises with cov

    python3 round4.py exact     # features and every account's prediction: results/round4-exact.json
    python3 round4.py smoke | all | analyze
"""

import json
import os
import sys
import time
from multiprocessing import Pool

import round2
import round3
from run import CONFIG

HERE = os.path.dirname(os.path.abspath(__file__))
RESULTS = os.path.join(HERE, "results")
SEEDS = 12
FULL_ENDS, FULL_REACHES = 4.4, 8.4
COV_HIGH, COV_LOW = 60.0, 16.0

CONDITIONS = {"G4s12": (4, 12), "G4s14": (4, 14), "G4s16": (4, 16), "G4s18": (4, 18), "G4s20": (4, 20),
              "G3s10.5": (3, 10.5), "G2s4.5": (2, 4.5), "G1s0.1": (1, 0.1)}


def band(cov, full):
    if full <= FULL_ENDS:
        return "depleted"
    if full >= FULL_REACHES or cov >= COV_HIGH:
        return "kept"
    if cov <= COV_LOW:
        return "depleted"
    return "between"


def band_p(cov, full):
    """The band rule as a number, for the mean absolute error (W2): kept 1, depleted 0, between
    linear in cov from COV_LOW to COV_HIGH."""
    c = band(cov, full)
    return 1.0 if c == "kept" else 0.0 if c == "depleted" else (cov - COV_LOW) / (COV_HIGH - COV_LOW)


def exact():
    b = json.load(open(os.path.join(RESULTS, "round3-predictions.json")))["coefficients"]
    with Pool(len(CONDITIONS)) as p:
        fs = p.starmap(round3.features, [(m, s, 0.0) for m, s in CONDITIONS.values()])
    out = {}
    for (n, (m, s)), (cov, full) in zip(CONDITIONS.items(), fs):
        out[n] = dict(m=m, s=s, cov=cov, full=full, band=band(cov, full), band_p=band_p(cov, full),
                      sigmoid=round3.logistic_p(b, round3.bx(cov, full)), rule2=round3.rule2(cov, full),
                      draw_cap="depleted" if m >= 3 and full < 8.4 else "-")
        print(n, {k: (round(v, 2) if isinstance(v, float) else v) for k, v in out[n].items()})
    json.dump(out, open(os.path.join(RESULTS, "round4-exact.json"), "w"), indent=1)


def run(mode):
    cfg = dict(CONFIG, seeds=SEEDS)
    if mode == "smoke":
        cfg.update(episodes=30, seeds=1, eval_episodes=3)
    js = [((n, k), dict(cond=round2.cond(m, s), seed=f"cg3r4/{n}/{k}", H=cfg["H"], alpha=cfg["alpha"],
                        eps_end=cfg["eps_end"], eps_frac=cfg["eps_frac"], episodes=cfg["episodes"],
                        eval_episodes=cfg["eval_episodes"], probe=cfg["probe"]))
          for n, (m, s) in CONDITIONS.items() for k in range(cfg["seeds"])]
    t = time.time()
    with Pool(int(os.environ.get("CG3_JOBS", 8))) as pool:
        res = pool.map(round2.work, js, chunksize=1)
    print(f"{len(res)} runs in {time.time() - t:.0f} s, "
          f"{sum(r['seconds'] for _, r in res) / 60:.1f} CPU-minutes", flush=True)
    runs = [dict(cond=n, seed=k, **r) for (n, k), r in res]
    if mode == "smoke":
        for r in runs:
            print(r["cond"], r["checks"]["je_viol"], r["emptied"], r["eval"]["final"])
        return
    json.dump(dict(config=cfg, runs=runs), open(os.path.join(RESULTS, "round4-runs.json"), "w"))


def analyze(rdir=RESULTS):
    ex = json.load(open(os.path.join(rdir, "round4-exact.json")))
    runs = json.load(open(os.path.join(rdir, "round4-runs.json")))["runs"]
    sh = round3.shares(runs)
    out = dict(conditions={})
    for n, e in ex.items():
        o = sh[n]["mean"]
        ok = (o >= 0.8 if e["band"] == "kept" else o <= 0.2 if e["band"] == "depleted" else 0.05 < o < 0.8)
        out["conditions"][n] = dict(e, observed=o, by_seed=sh[n]["by_seed"], verdict="passed" if ok else "failed")
    rs = out["conditions"]
    btw = sorted((r["cov"], r["observed"]) for r in rs.values() if r["band"] == "between")
    order = all(a[1] <= b[1] for a, b in zip(btw, btw[1:]))
    mae = lambda k: sum(abs(r[k] - r["observed"]) for r in rs.values()) / len(rs)
    out["mae"] = dict(band=mae("band_p"), sigmoid=mae("sigmoid"), rule2=mae("rule2"))
    npass = sum(r["verdict"] == "passed" for r in rs.values())
    out["contrasts"] = dict(
        V1_at_least_6_of_8=npass >= 6,
        V2_band_beats_sigmoid_and_rule2=out["mae"]["band"] < min(out["mae"]["sigmoid"], out["mae"]["rule2"]),
        V3_draw_cap_4_follows_the_band=all(rs[n]["verdict"] == "passed" for n in rs if rs[n]["m"] == 4),
        V4_between_rises_with_cov=order)
    tot = {}
    for r in runs:
        for key, val in list(r["checks"].items()) + [("emptied_" + k, v) for k, v in r["emptied"].items()]:
            tot[key] = tot.get(key, 0) + val
    out["identity"] = dict(steps=tot["steps"], violations=tot["balance_viol"] + tot["gate_given_below"]
                           + tot["margin_viol"] + tot["je_viol"], own_excess_windows=tot["je_windows"],
                           emptied=tot["emptied_episodes"], emptied_violations=tot["emptied_violations"])
    out["identity"]["verdict"] = "passed" if (out["identity"]["violations"] == 0 == out["identity"]["emptied_violations"]
                                             and out["identity"]["own_excess_windows"] > 0) else "failed"
    json.dump(out, open(os.path.join(rdir, "round4-VERDICTS.json"), "w"), indent=1)
    for n, r in rs.items():
        print(f"{n:8} cov {r['cov']:5.1f} full {r['full']:5.1f} band {r['band']:8} obs {r['observed']:.2f}  {r['verdict']}")
    print("MAE", {k: round(v, 3) for k, v in out["mae"].items()}, out["contrasts"], out["identity"])


if __name__ == "__main__":
    mode = sys.argv[1] if len(sys.argv) > 1 else "exact"
    if mode == "exact":
        exact()
    elif mode in ("smoke", "all"):
        run(mode)
    elif mode == "analyze":
        analyze()
