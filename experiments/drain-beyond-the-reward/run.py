"""LA4 Stage A's run (design §4, §5): every family, arm and seed, resumable. It runs only on Ren's yes.

Before the first update it checks that every frozen file is byte for byte as in the commit named in
results/FROZEN-AT, and runs checks.py; it refuses to start if either fails. Each (family, arm, seed) is one
job writing results/runs/<family>-<arm>-<seed>.json when it ends; a job whose file exists is skipped, so an
interrupted run resumes. analyze.py reads the files.

Pairing: a seed's initial parameters and its training stream depend on the seed alone, so the arms of one
seed start from the same parameters and draw the same uniforms until their policies differ.

Usage: python3 -B run.py [--jobs N] [--families a,b] [--arms a,b] [--seeds 0-19] [--dry]
--dry prints the jobs and the budget and runs nothing. --power runs the separable baseline on the power
check's seeds (power.py's input) instead of the test's. --smoke DIR runs every code path for 12 updates on
the season with no bay, outside the test conditions.
"""

import argparse
import hashlib
import json
import multiprocessing as mp
import os
import subprocess
import sys
import time

os.environ.setdefault("VECLIB_MAXIMUM_THREADS", "1")
os.environ.setdefault("OMP_NUM_THREADS", "1")
os.environ.setdefault("OPENBLAS_NUM_THREADS", "1")

import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)

import learners as L
import evaluate as E

ARMS = {
    "A1": dict(reward="rising", start="uniform"),
    "A2": dict(reward="rising", start="prudent"),
    "A3": dict(reward="rising", start="prudent", kl=True),
    "A5": dict(reward="after", start="prudent"),
    "A6": dict(reward="unshared", start="prudent"),
    "A4": dict(reward="plateau", start="uniform"),
    "C1": dict(reward="rising", start="prudent", control=True),
    "C1u": dict(reward="rising", start="uniform", control=True),
}
SEEDS = tuple(range(20))
POWER_SEEDS = tuple(range(1000, 1020))
FROZEN = ("DESIGN.md", "PREDICTIONS-2026-11-03.md", "season.py", "exact_flow.py", "exact_flow.json", "learners.py",
          "evaluate.py", "checks.py", "results/checks.json", "calibrate.py", "results/calibration.json", "run.py",
          "analyze.py", "verdicts.py", "power.py", "results/power.json")
FROZEN_DIRS = ("results/power-runs",)
CHECKPOINTS = 25


def checkpoints(n):
    """Log-spaced, as in exact_flow.py: 0, the final update and round(n^(i/24))."""
    return sorted({0, n} | {int(round(n ** (i / (CHECKPOINTS - 1)))) for i in range(CHECKPOINTS)})


def settings():
    return json.load(open(os.path.join(HERE, "results", "calibration.json")))["chosen"]


def welch(a1, a0):
    """Mean difference of the advantages a1 (the ending choice taken) and a0 (not taken), its 95% interval."""
    (n1, s1, q1), (n0, s0, q0) = a1, a0
    if n1 < 2 or n0 < 2:
        return dict(n_taken=int(n1), n_not=int(n0), diff=None, lo=None, hi=None, resolved=False)
    m1, m0 = s1 / n1, s0 / n0
    v1, v0 = max(q1 / n1 - m1 * m1, 0) * n1 / (n1 - 1), max(q0 / n0 - m0 * m0, 0) * n0 / (n0 - 1)
    se = (v1 / n1 + v0 / n0) ** 0.5
    d = m1 - m0
    return dict(n_taken=int(n1), n_not=int(n0), diff=d, lo=d - 1.96 * se, hi=d + 1.96 * se,
                resolved=bool(se > 0 and abs(d) > 1.96 * se))


def job(spec):
    """spec: (family, arm, seed, out[, pin]) for the run, (family, arm, seed, out, "smoke") for the smoke run."""
    family, arm, seed, out = spec[:4]
    smoke = len(spec) > 4 and spec[4] == "smoke"
    s = dict(settings()[family])
    if smoke:                       # the smoke run: 12 updates on the season with no bay
        s["length"] = 12
    a = ARMS[arm]
    beta = (s["beta"] or 0.0) if a.get("kl") else 0.0
    lr = L.Learner(family, a["start"], seed, s["rate"], s["value_rate"], s["batch"], reward=a["reward"],
                   kl_beta=beta, control=a.get("control", False), b0=0 if smoke else L.B0)
    marks = set(checkpoints(s["length"]))
    eval_rng = np.random.default_rng([seed, 4])
    rows, explore = [], []
    stats = {1: [0, 0.0, 0.0], 0: [0, 0.0, 0.0]}
    norms = {k: 0.0 for k in L.SL}
    capped, seasons, since = 0, 0, 0
    t0 = time.process_time()
    for n in range(s["length"] + 1):
        if n in marks:
            v = E.values(family, lr.p, eval_rng)
            v.update(update=n, movement=lr.movement(),
                     head_norms={k: (x / since if since else None) for k, x in norms.items()},
                     plateau_capped=(capped / seasons if seasons else None))
            rows.append(v)
            explore.append(dict(update=n, **welch(stats[1], stats[0])))
            norms = {k: 0.0 for k in L.SL}
            capped, seasons, since = 0, 0, 0
        if n == s["length"]:
            break
        lr.update()
        g = lr.last["game"]
        at3 = g["b"] == L.NEED
        for u in (0, 1):
            sel = at3 & (g["acts"]["u"] == u)
            x = lr.last["bay_adv"][sel]
            stats[u][0] += x.size
            stats[u][1] += float(x.sum())
            stats[u][2] += float((x * x).sum())
        for k, val in lr.head_norms(lr.last["dz"]).items():
            norms[k] += val
        since += 1
        capped += int(((g["ge"] + g["ue"]).sum(1) >= L.A).sum())
        seasons += g["ge"].shape[0]
    res = dict(family=family, arm=arm, seed=seed, settings=s, beta=beta, cpu_seconds=time.process_time() - t0,
               smoke=smoke, pin=None if smoke or len(spec) < 5 else spec[4],
               numpy=np.__version__, python=sys.version.split()[0], checkpoints=rows, exploration=explore)
    tmp = out + ".tmp"
    with open(tmp, "w") as f:
        json.dump(res, f, default=float)
    os.replace(tmp, out)
    return out, res["cpu_seconds"]


def frozen_ok():
    """(pin, problems): the pin is read from HEAD's committed results/FROZEN-AT, which the working copy must
    equal; it must be an ancestor of HEAD, FROZEN-AT must have been
    committed once and never changed, and every frozen file (and every file of the frozen folders, no more and
    no fewer) must be byte for byte as in the pinned commit."""
    git = lambda *a: subprocess.run(["git", "-C", HERE, *a], capture_output=True)
    top = git("rev-parse", "--show-toplevel").stdout.decode().strip()
    rel = os.path.relpath(HERE, top)
    committed = git("show", f"HEAD:{rel}/results/FROZEN-AT").stdout
    local = open(os.path.join(HERE, "results", "FROZEN-AT"), "rb").read()
    pin = committed.decode().split()[0] if committed.strip() else "(none committed)"
    bad = []
    if committed != local:
        bad.append("results/FROZEN-AT differs from its committed copy")
    if git("merge-base", "--is-ancestor", pin, "HEAD").returncode:
        bad.append(f"the pin {pin} is not an ancestor of HEAD")
    hist = git("log", "--format=%H", "--", "results/FROZEN-AT").stdout.decode().split()
    if len(hist) != 1:
        bad.append(f"results/FROZEN-AT has {len(hist)} commits, not one")
    files = list(FROZEN)
    for d in FROZEN_DIRS:
        listed = git("ls-tree", "-r", "--full-tree", "--name-only", f"{pin}:{rel}/{d}").stdout.decode().split()
        local = sorted(os.listdir(os.path.join(HERE, d))) if os.path.isdir(os.path.join(HERE, d)) else []
        if sorted(listed) != local:
            bad.append(f"{d} differs in its files from the pinned commit")
        files += [f"{d}/{x}" for x in listed]
    for f in files:
        want = git("show", f"{pin}:{rel}/{f}").stdout
        path = os.path.join(HERE, f)
        have = open(path, "rb").read() if os.path.exists(path) else b""
        if hashlib.sha256(want).digest() != hashlib.sha256(have).digest():
            bad.append(f)
    return pin, bad


def budget(jobs):
    s = settings()
    cpu = 0.0
    for family, arm, seed, _ in jobs:
        f = s[family]
        per_eval = f.get("ms_per_eval", 0.0) / 1000
        cpu += f["length"] * f["ms_per_update"] / 1000 * (1.5 if ARMS[arm].get("control") else 1)
        cpu += len(checkpoints(f["length"])) * per_eval
    return cpu


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--jobs", type=int, default=10)
    ap.add_argument("--families", default=",".join(L.FAMILIES))
    ap.add_argument("--arms", default=",".join(ARMS))
    ap.add_argument("--seeds")
    ap.add_argument("--dry", action="store_true")
    ap.add_argument("--power", action="store_true", help="the separable baseline on the power check's seeds")
    ap.add_argument("--smoke", help="every family and arm, 12 updates on the season with no bay, into this folder")
    args = ap.parse_args()
    if args.smoke:
        if os.path.abspath(args.smoke).startswith(os.path.join(HERE, "results")):
            sys.exit("refusing: the smoke run writes outside results/")
        os.makedirs(args.smoke, exist_ok=True)
        jobs = [(f, a, 0, os.path.join(args.smoke, f"{f}-{a}-0.json"), "smoke") for f in L.FAMILIES for a in ARMS]
        with mp.Pool(args.jobs) as pool:
            for out, cpu in pool.imap_unordered(job, jobs):
                print(f"{os.path.basename(out)} {cpu:.1f}s", file=sys.stderr, flush=True)
        return
    if args.power:
        families, seeds, sub = ["separable"], POWER_SEEDS, "power-runs"
    else:
        families, sub = args.families.split(","), "runs"
        seeds = SEEDS
        if args.seeds:
            a, b = (int(x) for x in args.seeds.split("-"))
            seeds = tuple(range(a, b + 1))
            if not set(seeds) <= set(SEEDS):
                sys.exit(f"refusing: the run's seeds are {SEEDS[0]} to {SEEDS[-1]}")
    outdir = os.path.join(HERE, "results", sub)
    jobs = [(f, a, s, os.path.join(outdir, f"{f}-{a}-{s}.json")) for f in families for a in args.arms.split(",")
            for s in seeds]
    todo = [j for j in jobs if not os.path.exists(j[3])]
    print(f"{len(jobs)} jobs, {len(todo)} to run; budget {budget(todo) / 3600:.2f} CPU hours", file=sys.stderr)
    if args.dry:
        return
    if not args.power:
        pin, bad = frozen_ok()
        if bad:
            sys.exit(f"refusing, against the frozen commit {pin}: {'; '.join(bad)}")
        if subprocess.run([sys.executable, "-B", os.path.join(HERE, "checks.py")], capture_output=True).returncode:
            sys.exit("refusing: checks.py failed")
        todo = [j + (pin,) for j in todo]
    os.makedirs(outdir, exist_ok=True)
    with mp.Pool(args.jobs) as pool:
        for out, cpu in pool.imap_unordered(job, todo):
            print(f"{os.path.basename(out)} {cpu:.0f}s", file=sys.stderr, flush=True)


if __name__ == "__main__":
    main()
