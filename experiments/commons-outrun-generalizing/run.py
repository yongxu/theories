"""Run the frozen configuration of EM1 (PREDICTIONS-2026-10-22.md) and write results/runs.json.

    python3 run.py all        # every condition of CG2, 20 seeds (about 25 minutes over 12 cores)
    python3 run.py smoke      # every code path with a few episodes; results not kept
"""

import json
import os
import sys
import time
from multiprocessing import Pool

import learners_pg as L

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.append(os.path.join(HERE, "..", "commons-outrun"))
from conditions import CONDITIONS  # noqa: E402

RESULTS = os.path.join(HERE, "results")

# alpha, beta chosen by tune.py on one learner alone (k = 1), outside the test, before the freeze
CONFIG = dict(H=100, alpha=1e-3, beta=1e-3, episodes=30000, seeds=20, eval_episodes=200,
              probe=20, keep_paths=5)


def jobs(cfg):
    out = []
    for name, cond in CONDITIONS.items():
        for s in range(cfg["seeds"]):
            spec = dict(cond=cond, seed=f"em1/{name}/{s}", H=cfg["H"], alpha=cfg["alpha"],
                        beta=cfg["beta"], episodes=cfg["episodes"],
                        eval_episodes=cfg["eval_episodes"], probe=cfg["probe"],
                        keep_paths=cfg["keep_paths"])
            out.append(((name, s), spec))
    return out


def work(job):
    key, spec = job
    t = time.time()
    r = L.train_eval(spec)
    r["seconds"] = time.time() - t
    return key, r


def main(argv):
    mode = argv[1] if len(argv) > 1 else "all"
    cfg = dict(CONFIG)
    if mode == "smoke":
        cfg.update(episodes=30, seeds=1, eval_episodes=3)
    js = jobs(cfg)
    t = time.time()
    with Pool(int(os.environ.get("EM1_JOBS", os.cpu_count() or 4))) as pool:
        res = pool.map(work, js, chunksize=1)
    print(f"{len(res)} runs in {time.time() - t:.0f} s", flush=True)
    if mode == "smoke":
        for (name, s), r in res:
            print(name, r["checks"]["je_viol"], r["outrun"], r["eval"]["final"])
        return
    os.makedirs(RESULTS, exist_ok=True)
    out = dict(config=cfg, runs=[dict(cond=name, seed=s, **r) for (name, s), r in res])
    with open(os.path.join(RESULTS, "runs.json"), "w") as f:
        json.dump(out, f)


if __name__ == "__main__":
    main(sys.argv)
