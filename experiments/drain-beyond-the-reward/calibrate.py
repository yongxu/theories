"""LA4 Stage A's calibration (design §10, step 1), outside the test conditions: the season with no bay
(it starts empty, so the bay's choice does nothing) and with the site read by nothing, as everywhere.
Only the ground is learned. Seeds 900 to 902, disjoint from the run's (0 to 19) and the power check's.

It fixes, by the rules below, for each family: the learning rate, the value network's rate, the batch,
the training length, and the KL arm's beta. It also measures each family's time per update and per
evaluation on this machine, for the budget.

Rules (frozen with the results in calibration.json):
- rate: from the grid, the one with the highest mean ground nearness over the seeds at the end, from the
  prudent start; a tie within 0.005 goes to the smaller rate;
- length: the grid's longest, 8,000, for every family: calibration sees the ground alone, and the
  separable baseline on the test season was still draining at 8,000 (before the freeze the rule was twice the
  length after which the gain fell below 0.005, which gave the recurrent family 2,000; the freeze's reader
  found that likely to leave its drain unfinished);
- beta: the largest of the grid whose mean ground nearness at the end, from the prudent start with the KL
  term, is at least 0.85 (so the KL arm can reach the nearness levels the comparison reads); none if none.

Usage: python3 -B calibrate.py [--jobs N] > calibration.json
       python3 -B calibrate.py --rechoose calibration.json > new.json   (the rules again, on the same rows)
"""

import argparse
import json
import multiprocessing as mp
import os
import sys
import time

os.environ.setdefault("VECLIB_MAXIMUM_THREADS", "1")
os.environ.setdefault("OMP_NUM_THREADS", "1")
os.environ.setdefault("OPENBLAS_NUM_THREADS", "1")

import numpy as np

import evaluate as E
import learners as L

SEEDS = (900, 901, 902)
RATES = (1e-3, 3e-3, 1e-2, 3e-2)
BATCH = 32
LENGTHS = (1000, 2000, 4000, 8000)
BETAS = (0.01, 0.03, 0.1, 0.3, 1.0)
VALUE_RATE = 3e-3


def ground_nearness(family, learner, rng):
    """Exact for the Markov families; for the recurrent family 4,000 sampled seasons."""
    if L.FAMILIES[family].markov:
        v, _ = E.exact(E.table(family, learner.p), b0=0)
        return float(v["ground_nearness"])
    g = L.play(learner.fam, learner.p, 4000, rng, b0=0)
    return float(g["ge"].sum(1).mean() / 34)


def one(job):
    family, start, rate, beta, seed = job
    lr = L.Learner(family, start, seed, rate, VALUE_RATE, BATCH, kl_beta=beta, b0=0)
    rng = np.random.default_rng([seed, 9])
    curve = {0: ground_nearness(family, lr, rng)}
    t0 = time.process_time()
    for n in range(1, LENGTHS[-1] + 1):
        lr.update()
        if n in LENGTHS:
            curve[n] = ground_nearness(family, lr, rng)
    per_update = (time.process_time() - t0) / LENGTHS[-1]
    t1 = time.process_time()
    E.values(family, lr.p, rng)                 # the test season's evaluation, timed only
    return dict(family=family, start=start, rate=rate, beta=beta, seed=seed, curve=curve,
                ms_per_update=1000 * per_update, ms_per_eval=1000 * (time.process_time() - t1))


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--jobs", type=int, default=10)
    ap.add_argument("--rechoose", help="apply the rules to the rows of an earlier output, training nothing")
    args = ap.parse_args()
    old = json.load(open(args.rechoose)) if args.rechoose else None
    if old is not None:
        rows = old["rows"]
        for x in rows + old["kl_rows"]:
            x["curve"] = {int(k): v for k, v in x["curve"].items()}
    else:
        jobs = [(f, s, r, 0.0, seed) for f in L.FAMILIES for s in ("prudent", "uniform") for r in RATES
                for seed in SEEDS]
        with mp.Pool(args.jobs) as pool:
            rows = pool.map(one, jobs)
    mean = lambda rs, n: float(np.mean([r["curve"][n] for r in rs]))
    chosen = {}
    for f in L.FAMILIES:
        pr = {r: [x for x in rows if x["family"] == f and x["start"] == "prudent" and x["rate"] == r] for r in RATES}
        best = max(mean(pr[r], LENGTHS[-1]) for r in RATES)
        rate = min(r for r in RATES if mean(pr[r], LENGTHS[-1]) >= best - 0.005)
        chosen[f] = dict(rate=rate, length=LENGTHS[-1], batch=BATCH, value_rate=VALUE_RATE)
    if old is not None:
        krows = old["kl_rows"]
    else:
        jobs = [(f, "prudent", chosen[f]["rate"], beta, seed) for f in L.FAMILIES for beta in BETAS for seed in SEEDS]
        with mp.Pool(args.jobs) as pool:
            krows = pool.map(one, jobs)
    for f in L.FAMILIES:
        n = chosen[f]["length"]
        ok = [b for b in BETAS if mean([x for x in krows if x["family"] == f and x["beta"] == b], n) >= 0.85]
        chosen[f]["beta"] = max(ok) if ok else None
        same = [x for x in rows + krows if x["family"] == f and x["rate"] == chosen[f]["rate"]]
        chosen[f]["ms_per_update"] = float(np.median([x["ms_per_update"] for x in same]))
        chosen[f]["ms_per_eval"] = float(np.median([x["ms_per_eval"] for x in same]))
    json.dump(dict(chosen=chosen, rows=rows, kl_rows=krows,
                   load=old["load"] if old else os.getloadavg(), rechosen=bool(old), rules=__doc__.split("Rules")[1].split("Usage")[0].strip()),
              sys.stdout, indent=1)
    print()


if __name__ == "__main__":
    main()
