"""The dry run of TR7's Stage A (FREEZE-9.md, section 6): the run's and the reading's code paths, and no
learner trained.

    python3 -B tools/research/gate.py hold -- python3 -B experiments/formations-that-read/told-tr7a/tr7a_dry_run.py
                                      # writes results/dry-run.json; a few CPU seconds

1. The game. `outcome` against FREEZE-4's `played`, draw for draw, GAME_IDS ids each: on every plan of every
   told condition, and on both answers of every tied condition (B1 to B4, so on B2's prospects too), its
   acts drawn from the call's generator as `played` draws them. Each plan's, chance's and mixture's
   expected points, enumerated over every act and draw, against tr7.py's ev, ev_fresh and ev_mixture.
2. The estimator. At each run's start, BATCHES batches are drawn and none is applied: the batches' mean
   gradient against the exact expected gradient, within four standard errors in each coordinate (unbiased);
   and at A3 and B4, where the points are fixed by the act at the checked stage, no batch's estimate moving
   the statistic against the law.
3. The run's plumbing, at seed PLUMBING, none of the frozen seeds: `run_all` on a temporary file, every run
   once, with step size 0 and STEPS_DRY steps. Each policy stays at its start, and each record has the
   fields the reading reads, its run's values and the stamp it was given. Then the file's last line is cut,
   as a kill would leave it, and `run_all` runs again: the cut line set aside, its learner trained again and
   nothing else; a whole file trains nothing; a record that lost only its newline gets one; a bad line
   before the last refuses.
4. Stage 0's reference ends against tr7.json's, at the ten runs both compute.
5. The reading on scripted records: each verdict at its thresholds, the reading's four outcomes and their
   order, a seed with d = 0 counted neither way, a reported run changing no verdict, a chance learner
   falling to 0 at B3, the reports read with stage0.json, and the refusals: a learner twice, a seed or run
   not frozen, fields not the run's, a final policy of the wrong shape, a record not stamped with a link.
6. Timing. The CPU seconds an episode takes for each learner, measured on step 2's batches, and the run's
   CPU estimate with a margin of 1.5 times, since the machine is shared: an estimate, not a bound, since
   nothing stops the run at it.
7. The frozen check's state: it passes only once this freeze's FROZEN.sha256 is committed.
8. The code it ran: the sha-256 of each file this folder's link lists but this record, taken as the dry run
   starts, and whether they are the same at its end; write_frozen.py writes FROZEN.sha256 only where they
   are the files' hashes then.
Standard library only.
"""

import contextlib
import hashlib
import io
import json
import math
import random
import sys
import tempfile
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

GAME_IDS = 500                # ids a plan or answer, in the game's check
BATCHES = 200                 # batches drawn at each run's start, none applied
PLUMBING = "dry-plumbing"     # the plumbing's seed, none of the frozen seeds 0 to 19
STEPS_DRY = 2                 # steps a learner, in the plumbing
MARGIN = 1.5                  # the CPU estimate's margin over the measure
LINKS = {"dry"}               # the scripted records' link commit
FROZEN_FILES = ("tr7a_stage.py", "tr7a_reading.py", "tr7a_stage0.py", "tr7a_dry_run.py", "results/stage0.json")
TR7_CURVES = {                # tr7.json's Stage A reference curves, by this freeze's run
    "A1": "A1 from uniform", "A3": "A3 from uniform", "A3 leaning to ownThenComply": "A3 from a lean to ownThenComply",
    "A5": "A5 (tie) from uniform", "A5 leaning to complyThenOwn": "A5 (tie) from a lean to complyThenOwn",
    "B1": "B1's prospects, shared chance from p = 0.5", "B2": "B2's prospects, shared chance from p = 0.5",
    "B3": "B2's prospects, shared chance from p = 0.9",
    "B2's prospects from 1/20": "B2's prospects, shared chance from p = 0.05",
    "the witness from 1/2": "the witness, shared chance from p = 0.5"}


class Checks:
    def __init__(self):
        self.by_kind, self.failed = {}, []

    def __call__(self, kind, name, ok, detail=None):
        self.by_kind[kind] = self.by_kind.get(kind, 0) + 1
        if not ok:
            self.failed.append({"kind": kind, "check": name, "detail": detail})

    @property
    def n(self):
        return sum(self.by_kind.values())


def tied_acts(cond, answer, rng):
    """The acts `played` draws for a tied condition's answer, from the call's generator, as it draws them."""
    if answer == TR.C.OWN_BOTH:
        return (S.C.OWN, S.C.OWN)
    x, y = cond["offer"]["x"], cond["offer"]["y"]
    if cond["offer"]["kind"] == "fresh":
        return tuple(S.C.COMPLY if rng.randrange(x + y) < x else S.C.OWN for _ in range(2))
    return (S.C.COMPLY, S.C.COMPLY) if rng.randrange(x + y) < x else (S.C.OWN, S.C.OWN)


def expected(s, weighted):
    """The expected points of acts drawn with the given weights, enumerated over the kept draw."""
    total = Fraction(0)
    for acts, w in weighted:
        pk = S0.kept_chance(s, acts[0])
        total += w * (pk * S0.points(s, acts, True) + (1 - pk) * S0.points(s, acts, False))
    return total


def check_game(chk):
    """`outcome` is `played`, draw for draw, on every answer of every condition; the expected points,
    enumerated exactly, are tr7.py's."""
    for cond in TR.C.conditions():
        s = cond["prospects"]
        for answer in cond["options"]:
            same = True
            for i in range(GAME_IDS):
                rid = f"tr7a-dry|{cond['id']}|{answer}|{i}"
                got = TR.played({"kind": "choice", "answer": answer, "id": rid}, cond)
                rng = random.Random("|".join((TR.SEED, "play", rid)))
                acts = TR.C.ACTS[answer] if cond["kind"] == "told" else tied_acts(cond, answer, rng)
                same = same and got == S.outcome(s, acts, rng)
            chk("the game: outcome is played, draw for draw", f"{cond['id']} {answer}", same)
            if cond["kind"] == "told":
                acts = TR.C.ACTS[answer]
                ev = expected(s, [(acts, 1)])
                chk("the game: expected points enumerated", f"tr7.ev: {cond['id']} {answer}", ev == tr7.ev(s, acts),
                    (str(ev), str(tr7.ev(s, acts))))
    for cid in ("B1", "B2", "B3", "B4", "witness"):
        s = S.prospects(cid)
        for p in (Fraction(1, 20), Fraction(1, 2), Fraction(9, 10), Fraction(7, 20), Fraction(1, 8)):
            fresh = expected(s, [((tr7.COMPLY if c1 else tr7.OWN, tr7.COMPLY if c2 else tr7.OWN),
                                  (p if c1 else 1 - p) * (p if c2 else 1 - p))
                                 for c1 in (True, False) for c2 in (True, False)])
            chk("the game: expected points enumerated", f"tr7.ev_fresh: {cid} at {p}", fresh == tr7.ev_fresh(s, p))
            mixed = expected(s, [((tr7.COMPLY, tr7.COMPLY), p), ((tr7.OWN, tr7.OWN), 1 - p)])
            chk("the game: expected points enumerated", f"tr7.ev_mixture: {cid} at {p}",
                mixed == tr7.ev_mixture(s, p, 1 - p), (str(mixed), str(tr7.ev_mixture(s, p, 1 - p))))


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


def never_against(run, g):
    """At A3 (V = 0) and B4 (k_O = 0) the points are fixed by the act at the checked stage, and the
    leave-one-out advantages sum to zero in every batch: no estimate raises a logit the law lowers, or
    lowers one it raises. The sum is zero up to rounding, hence the tolerance."""
    name, cid, learner, start, role = run
    if learner == "told":
        idx = [S.NAMES.index(n) for n in RD.target(run)]
        return all(g[k] >= -1e-12 if k in idx else g[k] <= 1e-12 for k in range(4))
    return g[0] <= 1e-12


def check_estimator(chk, timing):
    """At each run's start, BATCHES batches, none applied: the mean against the exact gradient."""
    out = {}
    for run in S.RUNS:
        name, cid, learner, start, role = run
        t0, n_ep = time.process_time(), BATCHES * S.BATCH
        if learner == "told":
            cond = S.C.by_id()[cid]
            grads = [S.told_step(cid, cond, start, "dry", step, list(start)) for step in range(BATCHES)]
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
        chk("the estimator: unbiased", f"the batches' mean is the exact gradient within four standard errors: {name}",
            ok, rows)
        if cid in ("A3", "B4"):
            chk("the estimator: no step against the law at A3 and B4", f"no batch's estimate against the law: {name}",
                all(never_against(run, x) for x in grads))
        out[name] = rows
    return out


def at_start(run, final):
    if run[2] == "told":
        return all(abs(a - b) < 1e-6 for a, b in zip(final, S.softmax(list(run[3]))))
    return abs(final - float(run[3])) < 1e-6


def refuses(f, *a, **kw):
    try:
        f(*a, **kw)
    except SystemExit:
        return True
    return False


def check_plumbing(chk):
    """`run_all` on a temporary file at step size 0, then a cut line and the resume."""
    stamp = {"link": "dry", "link commit": "dry", "head": "dry"}
    fields = {"run", "condition", "learner", "start", "role", "seed", "final", "curve", "cpu seconds", "frozen"}
    names = [r[0] for r in S.RUNS]
    with tempfile.TemporaryDirectory() as tmp, contextlib.redirect_stdout(io.StringIO()):
        out = Path(tmp) / "stage-a.jsonl"
        go = lambda: S.run_all(out, stamp, seeds=[PLUMBING], lr=0.0, steps=STEPS_DRY)   # noqa: E731
        made, recs = go(), S.records(out)
        chk("the plumbing: run_all", "every run trained once, in order", made == len(S.RUNS)
            and [r["run"] for r in recs] == names, made)
        for run, rec in zip(S.RUNS, recs):
            chk("the plumbing: run_all", f"the record's fields, its run's values and its stamp: {run[0]}",
                set(rec) == fields and {k: rec[k] for k in RD.fields(run)} == RD.fields(run)
                and rec["seed"] == PLUMBING and rec["frozen"] == stamp and len(rec["curve"]) == STEPS_DRY,
                sorted(rec))
            chk("the plumbing: run_all", f"step size 0 leaves the policy at its start: {run[0]}",
                at_start(run, rec["final"]), rec["final"])
        lines = out.read_text().split("\n")[:-1]
        cut = lines[-1][: len(lines[-1]) // 2]
        out.write_text("".join(x + "\n" for x in lines[:-1]) + cut)
        made, again = go(), S.records(out)
        side = Path(str(out) + ".cut")
        chk("the plumbing: resume", "a cut last line set aside byte for byte, its learner trained again, nothing else",
            made == 1 and [r["run"] for r in again] == names and again[:-1] == recs[:-1]
            and side.exists() and side.read_text().startswith(cut + "\n# cut "), made)
        chk("the plumbing: resume", "a whole file: nothing trained again", go() == 0)
        text = out.read_text()
        out.write_text(text[:-1])
        chk("the plumbing: resume", "a last record that lost only its newline: kept, the newline given back",
            len(S.records(out, mend=True)) == len(S.RUNS) and out.read_text() == text and go() == 0)
        lines = out.read_text().split("\n")[:-1]
        out.write_text("".join(x + "\n" for x in [lines[0], "{not a record", *lines[1:]]))
        chk("the plumbing: resume", "a bad line before the last refuses, and is not set aside",
            refuses(S.records, out, mend=True) and refuses(go) and not Path(str(out) + ".cut").read_text().count("{not"))


def check_stage0(chk, stage0):
    """Stage 0's reference ends are tr7.json's wherever both compute one."""
    curves = json.loads((HERE.parent / "tr7.json").read_text())["stage A reference: expected policy-gradient flows"]
    for run in S.RUNS:
        if run[0] not in TR7_CURVES:
            continue
        theirs = curves[TR7_CURVES[run[0]]]
        theirs = [theirs[n] for n in S.NAMES] if run[2] == "told" else theirs
        chk("Stage 0: the reference ends are tr7.json's", f"{run[0]}: {TR7_CURVES[run[0]]}",
            stage0["reference ends"][run[0]] == theirs, (stage0["reference ends"][run[0]], theirs))


def scripted(run, way):
    """A final policy moving the law's way (True), against it (False) or not at all (None); any other value
    is the final policy itself."""
    name, cid, learner, start, role = run
    if way is not True and way is not False and way is not None:     # 0.0 == False, so by identity
        return way
    t = RD.target(run)
    if learner == "told":
        if way is None:
            return S.softmax(list(start))
        idx = [S.NAMES.index(n) for n in t]
        k = idx[0] if way else next(j for j in range(4) if j not in idx)
        return [1.0 if j == k else 0.0 for j in range(4)]
    p0, tt = float(start), float(t)
    if way is None:
        return p0
    if way:
        return tt
    away = p0 + (0.05 if p0 >= tt else -0.05)
    return min(max(away, 0.0), 1.0)


def records(plan):
    """Scripted records, stamped with LINKS: plan maps a run's name to its seeds' ways or final policies."""
    out = []
    for run in S.RUNS:
        for seed, way in enumerate(plan.get(run[0], [True] * S.SEEDS)):
            out.append({"run": run[0], **RD.fields(run), "seed": seed, "final": scripted(run, way),
                        "frozen": {"link commit": "dry"}})
    return out


def check_reading(chk, stage0):
    read = lambda recs, s0=None: RD.read(recs, s0, LINKS)   # noqa: E731
    r = read(records({}))
    chk("the reading: verdicts", "every seed the law's way: every verdict run supported, the reading supported",
        r["reading"] == "supported" and all(v.get("verdict", "supported") == "supported" for v in r["runs"].values()))
    k, c = RD.SUPPORT_AT, RD.CONTRA_AT
    for run in RD.VERDICT_RUNS:
        name = run[0]
        r = read(records({name: [True] * (k - 1) + [False] * (S.SEEDS - k + 1)}))
        chk("the reading: verdicts", f"{k - 1} of {S.SEEDS} the law's way: {name} unresolved, the reading unresolved",
            r["runs"][name]["verdict"] == "unresolved" and r["reading"] == "unresolved")
        r = read(records({name: [True] * k + [False] * (S.SEEDS - k)}))
        chk("the reading: verdicts", f"{k} of {S.SEEDS}: {name} supported",
            r["runs"][name]["verdict"] == "supported" and r["reading"] == "supported")
        r = read(records({name: [False] * c + [True] * (S.SEEDS - c)}))
        chk("the reading: verdicts", f"{c} against: {name} contradicted, the reading contradicted",
            r["runs"][name]["verdict"] == "contradicted" and r["reading"] == "contradicted")
        r = read(records({name: [False] * (c - 1) + [None] * (S.SEEDS - c + 1)}))
        chk("the reading: verdicts", f"{c - 1} against, the rest unmoved: {name} unresolved, d = 0 counted neither way",
            r["runs"][name]["verdict"] == "unresolved" and r["runs"][name]["neither"] == S.SEEDS - c + 1)
    first, second = RD.VERDICT_RUNS[0][0], RD.VERDICT_RUNS[1][0]
    short = [x for x in records({}) if not (x["run"] == first and x["seed"] == 0)]
    chk("the reading: verdicts", "a verdict run short of a seed: the reading incomplete", read(short)["reading"] == "incomplete")
    both = [x for x in records({second: [False] * S.SEEDS}) if not (x["run"] == first and x["seed"] == 0)]
    chk("the reading: verdicts", "a seed lacking and another run contradicted: incomplete comes first",
        read(both)["reading"] == "incomplete")
    reported = [r for r in S.RUNS if r[4] == "reported"][0][0]
    r = read(records({reported: [False] * S.SEEDS}))
    chk("the reading: verdicts", "a reported run against the law changes no verdict",
        r["reading"] == "supported" and "verdict" not in r["runs"][reported])
    r = read(records({"B3": [0.0] * S.SEEDS}))
    key = [x for x in r["runs"]["B3"] if x.startswith("seeds ending within the improving chances")]
    chk("the reading: reports", "B3 falling to 0: the law's way by d, none within the improving chances",
        r["runs"]["B3"]["verdict"] == "supported" and len(key) == 1 and r["runs"]["B3"][key[0]] == 0, r["runs"]["B3"])
    r = read(records({}), stage0)
    for run in S.RUNS:
        row = r["runs"][run[0]]
        dist = [x for x in row if x.startswith("mean distance from the reference end")]
        chk("the reading: reports", f"the distance from stage0.json's reference end: {run[0]}", len(dist) == 1, sorted(row))
        inner = run[2] == "chance" and 0 < RD.target(run) < 1
        imp = [x for x in row if x.startswith("seeds ending within the improving chances")]
        chk("the reading: reports", f"the improving chances counted where the best chance is inside (0, 1): {run[0]}",
            len(imp) == (1 if inner else 0) and (not inner or row[imp[0]] == S.SEEDS), sorted(row))
        chk("the reading: reports", f"how the tie settles, at A3 and A5 only: {run[0]}",
            ("how the tie settles" in row) == (run[1] in ("A3", "A5")))
    good = records({})
    bad = {
        "a learner twice": good + [dict(good[0])],
        "a seed not frozen": [dict(good[0], seed=S.SEEDS)] + good[1:],
        "a run not frozen": [dict(good[0], run="A8")] + good[1:],
        "a condition not the run's": [dict(good[0], condition="A2")] + good[1:],
        "a start not the run's": [dict(good[0], start=list(S.lean("ownAtBoth")))] + good[1:],
        "a role not the run's": [dict(good[0], role="reported")] + good[1:],
        "a final policy of the wrong shape": [dict(good[0], final=[0.5, 0.5])] + good[1:],
        "a chance outside [0, 1]": [dict(x, final=1.5) if x["run"] == "B1" and x["seed"] == 0 else x for x in good],
        "a record stamped with another link": [dict(good[0], frozen={"link commit": "elsewhere"})] + good[1:],
        "a record with no stamp": [{k: v for k, v in good[0].items() if k != "frozen"}] + good[1:],
    }
    for what, recs in bad.items():
        chk("the reading: refusals", f"{what}: refused", refuses(read, recs))


def code_hashes():
    """The sha-256 of each file this folder's link lists but the dry run's record, repository-relative."""
    return {str(S.FOLDER / f): hashlib.sha256((HERE / f).read_bytes()).hexdigest() for f in FROZEN_FILES}


def main():
    t0 = time.process_time()
    code = code_hashes()
    chk, timing = Checks(), {}
    stage0 = json.loads((HERE / "results" / "stage0.json").read_text())
    check_game(chk)
    est = check_estimator(chk, timing)
    check_plumbing(chk)
    check_stage0(chk, stage0)
    check_reading(chk, stage0)
    per_episode = {k: v[0] / v[1] for k, v in timing.items()}
    seconds = sum(S.SEEDS * S.episodes(r[2]) * per_episode[r[2]] for r in S.RUNS)
    try:
        S.frozen()
        frozen = "passes"
    except SystemExit as e:
        frozen = f"does not pass yet: {e}"
    out = {"checks": chk.n, "checks by kind": chk.by_kind, "failed": chk.failed, "estimator at each start": est,
           "CPU an episode, microseconds": {k: round(v * 1e6, 2) for k, v in per_episode.items()},
           "episodes in all": S.total_episodes(),
           "CPU estimate": {"measured, minutes": round(seconds / 60, 1),
                            "with a margin of 1.5 times, minutes": round(MARGIN * seconds / 60, 1)},
           "the dry run's own CPU seconds": round(time.process_time() - t0, 1),
           "frozen check": frozen,
           "code hashes": code, "code unchanged during the run": code_hashes() == code}
    path = HERE / "results" / "dry-run.json"
    path.parent.mkdir(exist_ok=True)
    path.write_text(json.dumps(out, indent=1) + "\n")
    print("checks:", chk.n, "failed:", len(chk.failed))
    for kind, n in chk.by_kind.items():
        print(f"  {n:4d}  {kind}")
    for f in chk.failed[:8]:
        print("  FAILED", f["kind"], "|", f["check"], str(f["detail"])[:200])
    print("CPU an episode (us):", out["CPU an episode, microseconds"], "| estimate:", out["CPU estimate"],
          "| the dry run:", out["the dry run's own CPU seconds"], "s")
    print("frozen check:", frozen[:160])
    print("code unchanged during the run:", out["code unchanged during the run"])


if __name__ == "__main__":
    main()
