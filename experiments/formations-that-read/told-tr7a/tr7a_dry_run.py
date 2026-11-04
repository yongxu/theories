"""The dry run of TR7's Stage A (FREEZE-9.md, section 6): every code path, and no learner trained.

    python3 -B tools/research/gate.py hold -- python3 -B experiments/formations-that-read/told-tr7a/tr7a_dry_run.py
                                      # writes results/dry-run.json; about a minute of CPU

1. The game. `outcome` against FREEZE-4's `played`, draw for draw, on every plan of every told condition,
   GAME_IDS ids each; and each plan's, chance's and mixture's expected points, enumerated exactly, against
   tr7.py's ev, ev_fresh and ev_mixture.
2. The estimator. At each run's start, BATCHES batches are drawn and none is applied: the batches' mean
   gradient against the exact expected gradient, within four standard errors in each coordinate (unbiased),
   and the policy unchanged.
3. The runs' plumbing. `one` with its steps cut and step size 0: the policy stays at its start, and the
   record has every field the reading reads.
4. The reading on scripted seeds: each verdict, the reading's four outcomes, a seed with d = 0 counted
   neither way, and an incomplete run.
5. Timing. The CPU seconds an episode takes for each learner, measured on step 2's batches, and the CPU
   bound on the run, 1.5 times the measure, since the machine is shared.
6. The frozen check's state: it passes only once this freeze's FROZEN.sha256 is committed.
Standard library only.
"""

import json
import math
import random
import sys
import time
from fractions import Fraction
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import tr7a_stage as S        # noqa: E402
import tr7a_reading as RD     # noqa: E402
import tr7a_stage0 as S0      # noqa: E402
import tr7_run as TR          # noqa: E402  FREEZE-4's
import tr7                    # noqa: E402

GAME_IDS = 500                # ids a plan, in the game's check
BATCHES = 200                 # batches drawn at each run's start, none applied
MARGIN = 1.5                  # the CPU bound's margin over the measure


class Checks:
    def __init__(self):
        self.n, self.failed = 0, []

    def __call__(self, name, ok, detail=None):
        self.n += 1
        if not ok:
            self.failed.append({"check": name, "detail": detail})


def check_game(chk):
    """`outcome` is `played`, draw for draw, on every plan of every told condition; the expected points,
    enumerated exactly, are tr7.py's."""
    conds = [c for c in TR.C.conditions() if c["kind"] == "told"]
    for cond in conds:
        s = cond["prospects"]
        for name in S.NAMES:
            acts = TR.C.ACTS[name]
            same = True
            for i in range(GAME_IDS):
                rid = f"tr7a-dry|{cond['id']}|{name}|{i}"
                got = TR.played({"kind": "choice", "answer": name, "id": rid}, cond)
                mine = S.outcome(s, acts, random.Random("|".join((TR.SEED, "play", rid))))
                same = same and got == mine
            chk(f"outcome is played, draw for draw: {cond['id']} {name}", same)
            pk = S0.kept_chance(s, acts[0])
            ev = pk * S0.points(s, acts, True) + (1 - pk) * S0.points(s, acts, False)
            chk(f"expected points are tr7.ev: {cond['id']} {name}", ev == tr7.ev(s, acts), (str(ev), str(tr7.ev(s, acts))))
    for cid in ("B1", "B2", "B3", "B4", "witness"):
        s = S.prospects(cid)
        for p in (Fraction(1, 20), Fraction(1, 2), Fraction(9, 10), Fraction(7, 20), Fraction(1, 8)):
            fresh = Fraction(0)
            for c1 in (True, False):
                for c2 in (True, False):
                    acts = (tr7.COMPLY if c1 else tr7.OWN, tr7.COMPLY if c2 else tr7.OWN)
                    pa = (p if c1 else 1 - p) * (p if c2 else 1 - p)
                    pk = S0.kept_chance(s, acts[0])
                    fresh += pa * (pk * S0.points(s, acts, True) + (1 - pk) * S0.points(s, acts, False))
            chk(f"a chance's expected points are tr7.ev_fresh: {cid} at {p}", fresh == tr7.ev_fresh(s, p))
            mixed = p * tr7.ev(s, tr7.CAB) + (1 - p) * tr7.ev(s, tr7.OAB)
            chk(f"a mixture's expected points are tr7.ev_mixture: {cid} at {p}",
                mixed == tr7.ev_mixture(s, p, 1 - p))


def exact_gradient(run):
    """The expected gradient at the run's start, in the learner's parameters."""
    name, cid, learner, start, role = run
    s = S.prospects(cid)
    if learner == "told":
        pr = S.softmax(list(start))
        evs = [float(tr7.ev(s, p)) for p in tr7.PLANS]
        mean = sum(a * b for a, b in zip(pr, evs))
        return [pr[k] * (evs[k] - mean) for k in range(4)]
    p = float(start)
    if learner == "mixture":
        return [float(tr7.ev(s, tr7.CAB) - tr7.ev(s, tr7.OAB)) * p * (1 - p)]
    T = s.total
    A, B, C = s.keptOwn * s.value / T, s.cost, s.keptComplying * s.value / T
    return [((C - B - 2 * A) + 2 * p * (A - C)) * p * (1 - p)]     # tr7.flow_tied's gradient


def check_estimator(chk, timing):
    """At each run's start, BATCHES batches, none applied: the mean against the exact gradient."""
    out = {}
    for run in S.RUNS:
        name, cid, learner, start, role = run
        t0, n_ep = time.process_time(), BATCHES * S.BATCH
        if learner == "told":
            cond = S.C.by_id()[cid]
            th = list(start)
            grads = [S.told_step(cid, cond, start, "dry", step, th) for step in range(BATCHES)]
            chk(f"the policy unchanged by the draws: {name}", th == list(start))
        else:
            mix = learner == "mixture"
            rng, game = S.generators(cid, f"dry-{start}", "dry", mix)
            th = S.logit(float(start))
            grads = [[S.chance_step(S.prospects(cid), th, rng, game, mix)] for _ in range(BATCHES)]
        dt = time.process_time() - t0
        timing.setdefault(learner, [0.0, 0])
        timing[learner][0] += dt
        timing[learner][1] += n_ep
        g = exact_gradient(run)
        ok, rows = True, []
        for k in range(len(g)):
            xs = [x[k] for x in grads]
            m = sum(xs) / len(xs)
            sd = math.sqrt(sum((x - m) ** 2 for x in xs) / (len(xs) - 1))
            se = sd / math.sqrt(len(xs))
            within = abs(m - g[k]) <= 4 * se + 1e-9
            ok = ok and within
            rows.append({"mean": round(m, 6), "exact": round(g[k], 6), "standard error": round(se, 6)})
        chk(f"the batches' mean is the exact gradient within four standard errors: {name}", ok, rows)
        out[name] = rows
    return out


def check_plumbing(chk):
    for run in S.RUNS:
        rec = S.one(run, 0, lr=0.0, steps=3)
        fields = {"run", "condition", "learner", "start", "role", "seed", "final", "curve", "cpu seconds"}
        chk(f"a record has the fields the reading reads: {run[0]}", set(rec) == fields, sorted(rec))
        if run[2] == "told":
            same = all(abs(a - b) < 1e-6 for a, b in zip(rec["final"], S.softmax(list(run[3]))))
        else:
            same = abs(rec["final"] - float(run[3])) < 1e-6
        chk(f"step size 0 leaves the policy at its start: {run[0]}", same, rec["final"])


def scripted(run, toward):
    """A final policy moving the law's way (toward True), against it (False), or not at all (None)."""
    name, cid, learner, start, role = run
    t = RD.target(run)
    if learner == "told":
        if toward is None:
            return S.softmax(list(start))
        idx = [S.NAMES.index(n) for n in t]
        k = idx[0] if toward else next(j for j in range(4) if j not in idx)
        return [1.0 if j == k else 0.0 for j in range(4)]
    p0, tt = float(start), float(t)
    if toward is None:
        return p0
    if toward:
        return tt
    away = p0 + (0.05 if p0 >= tt else -0.05)
    return min(max(away, 0.0), 1.0)


def records(plan):
    """Scripted records: plan maps a run's name to its seeds' directions (True, False or None)."""
    out = []
    for run in S.RUNS:
        for seed, way in enumerate(plan.get(run[0], [True] * S.SEEDS)):
            out.append({"run": run[0], "seed": seed, "final": scripted(run, way)})
    return out


def check_reading(chk):
    r = RD.read(records({}))
    chk("every seed the law's way: every verdict run supported, the reading supported",
        r["reading"] == "supported" and all(v.get("verdict", "supported") == "supported" for v in r["runs"].values()))
    k = RD.SUPPORT_AT
    for run in RD.VERDICT_RUNS:
        name = run[0]
        r = RD.read(records({name: [True] * (k - 1) + [False] * (S.SEEDS - k + 1)}))
        chk(f"{k - 1} of {S.SEEDS} the law's way: {name} unresolved, the reading unresolved",
            r["runs"][name]["verdict"] == "unresolved" and r["reading"] == "unresolved")
        r = RD.read(records({name: [True] * k + [False] * (S.SEEDS - k)}))
        chk(f"{k} of {S.SEEDS}: {name} supported", r["runs"][name]["verdict"] == "supported" and r["reading"] == "supported")
        c = RD.CONTRA_AT
        r = RD.read(records({name: [False] * c + [True] * (S.SEEDS - c)}))
        chk(f"{c} against: {name} contradicted, the reading contradicted",
            r["runs"][name]["verdict"] == "contradicted" and r["reading"] == "contradicted")
        r = RD.read(records({name: [False] * (c - 1) + [None] * (S.SEEDS - c + 1)}))
        chk(f"{c - 1} against, the rest unmoved: {name} unresolved, d = 0 counted neither way",
            r["runs"][name]["verdict"] == "unresolved" and r["runs"][name]["neither"] == S.SEEDS - c + 1)
    one_short = [x for x in records({}) if not (x["run"] == RD.VERDICT_RUNS[0][0] and x["seed"] == 0)]
    chk("a verdict run short of a seed: the reading incomplete", RD.read(one_short)["reading"] == "incomplete")
    reported = [r for r in S.RUNS if r[4] == "reported"][0][0]
    r = RD.read(records({reported: [False] * S.SEEDS}))
    chk("a reported run against the law changes no verdict", r["reading"] == "supported" and "verdict" not in r["runs"][reported])


def main():
    chk, timing = Checks(), {}
    check_game(chk)
    est = check_estimator(chk, timing)
    check_plumbing(chk)
    check_reading(chk)
    per_episode = {k: v[0] / v[1] for k, v in timing.items()}
    seconds = sum(S.SEEDS * S.episodes(r[2]) * per_episode[r[2]] for r in S.RUNS)
    try:
        S.frozen()
        frozen = "passes"
    except SystemExit as e:
        frozen = f"does not pass yet: {e}"
    out = {"checks": chk.n, "failed": chk.failed, "estimator at each start": est,
           "CPU seconds an episode": {k: round(v * 1e6, 2) for k, v in per_episode.items()},
           "CPU seconds an episode (unit)": "microseconds",
           "episodes in all": S.total_episodes(),
           "CPU bound": {"measured, minutes": round(seconds / 60, 1),
                         "bound at 1.5 times, minutes": round(MARGIN * seconds / 60, 1)},
           "frozen check": frozen}
    path = HERE / "results" / "dry-run.json"
    path.parent.mkdir(exist_ok=True)
    path.write_text(json.dumps(out, indent=1) + "\n")
    print("checks:", chk.n, "failed:", len(chk.failed))
    for f in chk.failed[:8]:
        print("  FAILED", f["check"], str(f["detail"])[:200])
    print("CPU an episode (us):", out["CPU seconds an episode"], "| bound:", out["CPU bound"])
    print("frozen check:", frozen[:160])


if __name__ == "__main__":
    main()
