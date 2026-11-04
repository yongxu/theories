"""TR7's Stage A: tabular learners trained on sampled outcomes of TR7's game, frozen before any training
run (FREEZE-9.md).

    python3 -B tr7a_stage.py plan     # the runs, their episodes and the CPU bound; no training
    python3 -B tools/research/gate.py hold -- python3 -B experiments/formations-that-read/told-tr7a/tr7a_stage.py run
                                      # the training Ren's yes releases: local CPU, no download, no model call

Each learner chooses on one of TR7's stated prospects and is trained only on the points the game pays,
by the rule of FREEZE-4's generator (told-tr7/tr7_run.py's `played`, imported at its hash):
- a told learner, a softmax over the four plans (A1 to A7), each episode played by `played` itself;
- a chance learner, one chance of complying drawn afresh at each stage (B1 to B3, and the witness);
- a mixture learner, one draw before the read stage, complying at both stages or acting by its own law at
  both (B4).
`played` plays a plan or a declared offer; a learned chance is neither, so the chance and mixture learners
draw their acts themselves and their outcomes by `outcome`, the last lines of `played` unchanged, from one
generator a run (the dry run checks `outcome` against `played`, draw for draw, on every plan of every told
condition). Each step averages a batch of episodes with a leave-one-out baseline, an unbiased estimate of
the expected gradient that tr7.py's reference flows ascend exactly (flow_told, flow_tied, and this freeze's
flow_mixture in tr7a_stage0.py), at their step size and number of steps, so a learner's mean path is its
reference curve. `run` refuses unless FREEZE-4's frozen check (with freeze 1's) and this freeze's pass; it
writes results/stage-a.jsonl, one line a run and seed, and goes on from the lines already written; the
lines are read by tr7a_reading.py. Standard library only.
"""

import argparse
import json
import math
import random
import sys
import time
from fractions import Fraction
from pathlib import Path

HERE = Path(__file__).resolve().parent
TR7_DIR = HERE.parent / "told-tr7"
sys.path.insert(0, str(TR7_DIR))
import tr7_conditions as C     # noqa: E402  first: puts freeze 1's harness and tr7.py on the path, checks their files
import tr7_run as TR           # noqa: E402  FREEZE-4's run: the game it plays (played) and its frozen check
import run as R                # noqa: E402  freeze 1's (told/run.py): frozen_check
import tr7                     # noqa: E402  Stage 0's script: the prospects, the plans, the reference flows

C.own_files()
for _name in ("tr7_conditions", "tr7_run"):
    assert Path(sys.modules[_name].__file__).resolve() == TR7_DIR / f"{_name}.py", f"{_name} is not FREEZE-4's"

FOLDER = HERE.relative_to(R.REPO)          # told-tr7a/, repository-relative
SEED = "TR7A-freeze-9-2026-11-05"
LR = 0.5                    # the reference flows' step size (tr7.flow_told, tr7.flow_tied)
STEPS = {"told": 4000, "chance": 20000, "mixture": 4000}   # flow_told's and flow_tied's steps; the mixture's as told's
BATCH = 100                 # episodes a step averages
SEEDS = 20                  # seeds a run
CHECKPOINTS = 10            # the policy recorded at each tenth of a run's steps
CLIP = 50.0                 # a logit kept within plus or minus 50, as tr7.flow_tied keeps it
NAMES = [tr7.NAME[p] for p in tr7.PLANS]   # complyAtBoth, complyThenOwn, ownThenComply, ownAtBoth
# What an addendum may change: the dry run and its record, as in FREEZE-4; every other file is fixed.
MAY_CHANGE = frozenset({str(FOLDER / "tr7a_dry_run.py"), str(FOLDER / "results" / "dry-run.json")})
OUT = HERE / "results" / "stage-a.jsonl"


def lean(plan):
    """A start leaning to one plan: its logit 1, the others 0, as tr7.py's reference leans."""
    return tuple(1.0 if n == plan else 0.0 for n in NAMES)


UNIFORM = (0.0, 0.0, 0.0, 0.0)
WITNESS = tr7.CONDITIONS["B1w"]["s"]       # Example.prospects, the witness of FreshDrawAbove at 1/8

# The runs: (name, condition, learner, start, role). A verdict run is one of TR7's eleven planned
# conditions as Stage A meets it; a reported run is read by no verdict (how ties settle by the start;
# B2's prospects from below the best chance; the witness).
RUNS = [
    ("A1", "A1", "told", UNIFORM, "verdict"),
    ("A2", "A2", "told", UNIFORM, "verdict"),
    ("A3", "A3", "told", UNIFORM, "verdict"),
    ("A4", "A4", "told", UNIFORM, "verdict"),
    ("A5", "A5", "told", UNIFORM, "verdict"),
    ("A6", "A6", "told", UNIFORM, "verdict"),
    ("A7", "A7", "told", UNIFORM, "verdict"),
    ("B1", "B1", "chance", Fraction(1, 2), "verdict"),
    ("B2", "B2", "chance", Fraction(1, 2), "verdict"),
    ("B3", "B3", "chance", Fraction(9, 10), "verdict"),
    ("B4", "B4", "mixture", Fraction(1, 2), "verdict"),
    ("A3 leaning to ownThenComply", "A3", "told", lean("ownThenComply"), "reported"),
    ("A3 leaning to ownAtBoth", "A3", "told", lean("ownAtBoth"), "reported"),
    ("A5 leaning to complyThenOwn", "A5", "told", lean("complyThenOwn"), "reported"),
    ("A5 leaning to ownAtBoth", "A5", "told", lean("ownAtBoth"), "reported"),
    ("B2's prospects from 1/20", "B2", "chance", Fraction(1, 20), "reported"),
    ("the witness from 1/2", "witness", "chance", Fraction(1, 2), "reported"),
]
assert sorted(r[1] for r in RUNS if r[4] == "verdict") == sorted(tr7.PLANNED), "one verdict run a planned condition"


def prospects(cid):
    return WITNESS if cid == "witness" else tr7.CONDITIONS[cid]["s"]


def episodes(learner):
    return STEPS[learner] * BATCH


def softmax(th):
    mx = max(th)
    w = [math.exp(t - mx) for t in th]
    z = sum(w)
    return [x / z for x in w]


def sigmoid(t):
    return 1 / (1 + math.exp(-t))


def logit(p):
    return math.log(p / (1 - p))


def outcome(s, acts, rng):
    """The game's points for two acts: the last lines of `played` (told-tr7/tr7_run.py), unchanged. One's
    own way is kept with chance k_C / T after complying at the checked stage and k_O / T after acting by
    one's own law there; complying there costs c; one's own act at the unchecked stage earns V if kept."""
    kept = rng.randrange(s.total) < (s.keptComplying if acts[0] == C.COMPLY else s.keptOwn)
    points = (-s.cost if acts[0] == C.COMPLY else 0) + (s.value if acts[1] == C.OWN and kept else 0)
    return {"acts": list(acts), "kept": kept, "points": points}


def told_step(cid, cond, start, seed, step, th):
    """One step's batch at the policy softmax(th): each episode a plan drawn from the policy and played by
    FREEZE-4's generator. Returns the batch's gradient estimate, its sum over the episodes with a
    leave-one-out baseline (unbiased), divided by the batch."""
    pr = softmax(th)
    cum = [sum(pr[:k + 1]) for k in range(4)]
    rng = random.Random("|".join((SEED, "learner", cid, json.dumps(start), str(seed), str(step))))
    acts, pts = [], []
    for i in range(BATCH):
        u = rng.random()
        a = next((k for k in range(4) if u < cum[k]), 3)
        rec = {"kind": "choice", "answer": NAMES[a],
               "id": "|".join(("tr7a", cid, json.dumps(start), str(seed), str(step), str(i)))}
        acts.append(a)
        pts.append(TR.played(rec, cond)["points"])
    total = sum(pts)
    grad = [0.0, 0.0, 0.0, 0.0]
    for a, r in zip(acts, pts):
        adv = r - (total - r) / (BATCH - 1)       # a leave-one-out baseline: unbiased
        for k in range(4):
            grad[k] += adv * ((1.0 if k == a else 0.0) - pr[k])
    return [g / BATCH for g in grad]


def told_run(cid, start, seed, lr=LR, steps=None):
    """A softmax over the four plans, each episode played by FREEZE-4's generator. Returns the final policy
    and the policy at each tenth of the steps."""
    steps = STEPS["told"] if steps is None else steps
    cond = C.by_id()[cid]
    th = list(start)
    curve, every = [], max(1, steps // CHECKPOINTS)
    for step in range(steps):
        grad = told_step(cid, cond, start, seed, step, th)
        th = [min(max(t + lr * g, -CLIP), CLIP) for t, g in zip(th, grad)]
        if (step + 1) % every == 0:
            curve.append([round(x, 6) for x in softmax(th)])
    return {"final": [round(x, 6) for x in softmax(th)], "curve": curve}


def chance_step(s, th, rng, game, mixture=False):
    """One step's batch at the chance sigmoid(th): a chance learner's acts drawn afresh at each stage, or a
    mixture learner's one draw before the read stage, and the game's outcome by `outcome`. Returns the
    batch's gradient estimate in th (leave-one-out baseline), divided by the batch."""
    p = sigmoid(th)
    scores, pts = [], []
    for _ in range(BATCH):
        if mixture:
            c = rng.random() < p
            acts = (C.COMPLY, C.COMPLY) if c else (C.OWN, C.OWN)
            score = (1.0 if c else 0.0) - p
        else:
            c1, c2 = rng.random() < p, rng.random() < p
            acts = (C.COMPLY if c1 else C.OWN, C.COMPLY if c2 else C.OWN)
            score = (1.0 if c1 else 0.0) + (1.0 if c2 else 0.0) - 2 * p
        scores.append(score)
        pts.append(outcome(s, acts, game)["points"])
    total = sum(pts)
    return sum((r - (total - r) / (BATCH - 1)) * sc for r, sc in zip(pts, scores)) / BATCH


def generators(cid, p0, seed, mixture=False):
    """A chance or mixture run's two generators: its learner's acts, and the game's draws."""
    kind = "mixture" if mixture else "chance"
    return (random.Random("|".join((SEED, kind, cid, str(p0), str(seed)))),
            random.Random("|".join((TR.SEED, "play", "tr7a", kind, cid, str(p0), str(seed)))))


def chance_run(cid, p0, seed, lr=LR, steps=None, mixture=False):
    """A chance learner (one chance of complying, drawn afresh at each stage) or, with mixture, a mixture
    learner (one draw before the read stage: comply at both stages, or act by one's own law at both). Its
    acts and the game's draws come from one generator each a run. Returns the final chance and the chance at
    each tenth of the steps."""
    steps = STEPS["mixture" if mixture else "chance"] if steps is None else steps
    s = prospects(cid)
    th = logit(float(p0))
    rng, game = generators(cid, p0, seed, mixture)
    curve, every = [], max(1, steps // CHECKPOINTS)
    for step in range(steps):
        th = min(max(th + lr * chance_step(s, th, rng, game, mixture), -CLIP), CLIP)
        if (step + 1) % every == 0:
            curve.append(round(sigmoid(th), 6))
    return {"final": round(sigmoid(th), 6), "curve": curve}


def one(run, seed, **kw):
    name, cid, learner, start, role = run
    t = time.process_time()
    if learner == "told":
        res = told_run(cid, start, seed, **kw)
    else:
        res = chance_run(cid, start, seed, mixture=(learner == "mixture"), **kw)
    return {"run": name, "condition": cid, "learner": learner,
            "start": list(start) if learner == "told" else str(start), "role": role, "seed": seed,
            **res, "cpu seconds": round(time.process_time() - t, 2)}


def frozen(repo=None):
    """FREEZE-4's frozen check (freeze 1's first, then FREEZE-4's chain), then this freeze's chain."""
    repo = repo or R.REPO
    TR.frozen(repo)
    return R.frozen_check(repo, FOLDER, MAY_CHANGE)


def done():
    if not OUT.exists():
        return set()
    return {(r["run"], r["seed"]) for r in (json.loads(l) for l in OUT.read_text().splitlines() if l.strip())}


def total_episodes():
    return sum(episodes(r[2]) for r in RUNS) * SEEDS


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("command", choices=["plan", "run"])
    a = ap.parse_args()
    if a.command == "plan":
        for r in RUNS:
            print(f"{r[0]:32s} {r[2]:8s} {r[4]:9s} {SEEDS} seeds x {episodes(r[2]):,} episodes")
        print(f"episodes in all: {total_episodes():,}")
        dry = HERE / "results" / "dry-run.json"
        if dry.exists():
            print("CPU bound:", json.loads(dry.read_text()).get("CPU bound"))
        return
    frozen()
    OUT.parent.mkdir(exist_ok=True)
    have = done()
    with OUT.open("a") as f:
        for r in RUNS:
            for seed in range(SEEDS):
                if (r[0], seed) in have:
                    continue
                rec = one(r, seed)
                f.write(json.dumps(rec) + "\n")
                f.flush()
                print(rec["run"], seed, rec["final"], rec["cpu seconds"], flush=True)


if __name__ == "__main__":
    main()
