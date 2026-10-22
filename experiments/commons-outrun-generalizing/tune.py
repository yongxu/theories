"""Choose the learning rates on a setting outside the test, before the freeze.

    python3 tune.py            # writes results/tuning.json

The setting is one learner alone on the patch (k = 1, s = 1), rewarded its own apples plus twice
the level after the last step: no rest, so the law makes no prediction to protect, and the exact
optimum is known to keep the patch (CG1's single coupled learner).  Each pair of rates runs 3
seeds of 30,000 episodes; the pair with the highest mean greedy return is frozen in run.py.
No condition of the test is run here.
"""

import json
import os
import sys
import time
from multiprocessing import Pool

import learners_pg as L

HERE = os.path.dirname(os.path.abspath(__file__))
SETTING = dict(k=1, s=1, lam=2.0, v=0.0, share=False, joint=False)
RATES = [(a, b) for a in (1e-4, 3e-4, 1e-3, 3e-3) for b in (1e-3,)]


def work(job):
    (a, b), s, episodes = job
    spec = dict(cond=SETTING, seed=f"em1/tune/{a}/{b}/{s}", H=100, alpha=a, beta=b,
                episodes=episodes, eval_episodes=100, probe=20)
    t = time.time()
    r = L.train_eval(spec)
    ret = [sum(h) + 2.0 * f for h, f in zip(r["eval"]["harvest"], r["eval"]["final"])]
    alive = sum(1 for x in r["eval"]["alive_probe"] if x >= 1) / len(r["eval"]["alive_probe"])
    return dict(alpha=a, beta=b, seed=s, mean_return=sum(ret) / len(ret), alive_probe=alive,
                seconds=time.time() - t)


def main(argv):
    episodes = int(argv[1]) if len(argv) > 1 else 30000
    jobs = [(r, s, episodes) for r in RATES for s in range(3)]
    with Pool(int(os.environ.get("EM1_JOBS", os.cpu_count() or 4))) as pool:
        res = pool.map(work, jobs, chunksize=1)
    os.makedirs(os.path.join(HERE, "results"), exist_ok=True)
    summary = {}
    for r in res:
        key = f"{r['alpha']}/{r['beta']}"
        summary.setdefault(key, []).append(r)
    for key, rs in summary.items():
        print(key, round(sum(r["mean_return"] for r in rs) / len(rs), 2),
              round(sum(r["alive_probe"] for r in rs) / len(rs), 2), round(rs[0]["seconds"]))
    if episodes == 30000:
        json.dump(dict(setting=SETTING, runs=res), open(os.path.join(HERE, "results", "tuning.json"), "w"),
                  indent=1)


if __name__ == "__main__":
    main(sys.argv)
