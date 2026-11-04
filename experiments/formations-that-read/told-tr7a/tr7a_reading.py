"""The frozen reading of TR7's Stage A (FREEZE-9.md, section 4): an exact sign test over the seeds of each
verdict run, and the reports no verdict reads.

    python3 -B tr7a_reading.py        # reads results/stage-a.jsonl, writes results/reading.json

It refuses unless the frozen check passes, and refuses records it was not frozen for: a run or seed not in
the frozen runs, a learner twice, fields that differ from the run's, a final policy of the wrong shape, or a
record not stamped with a link of this freeze's chain.

The law's direction at each run: a told learner gains on the condition's maximal plans (tr7.maximal_set),
a chance learner comes nearer the derived best chance (tr7.best_chance: 0 on B1's prospects, 7/20 on B2's
and B3's, 1/8 on the witness's), a mixture learner's weight on complying at both stages falls (no mixture
stands above ownAtBoth, tr7.py's D6). Per seed, d is that gain, the distance's fall or the weight's fall,
from the start to the final policy; d > 0 is the law's direction, d < 0 against it, d = 0 neither. A
verdict run is supported where at least SUPPORT_AT seeds give d > 0 (an exact one-sided sign test at
0.05), contradicted where at least CONTRA_AT give d < 0 (0.05 split over the eleven verdict runs), and
unresolved otherwise; it cannot be both. The reading is incomplete while any verdict run lacks a seed, and
otherwise contradicted where any verdict run is, supported where every one is, unresolved otherwise.
Reported beside it, ruling on nothing: the final policies, their distance from the reference curve's end at
the same step size and steps (results/stage0.json), how each tie settles by its start, and at a best chance
inside (0, 1) the seeds ending within the improving chances (0 < p below tr7.improving_bound), since d alone
counts a chance learner falling to 0 as nearer 7/20 than 9/10. Standard library only.
"""

import json
import math
import sys
from fractions import Fraction
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import tr7a_stage as S      # noqa: E402  the runs and the learners' constants
import tr7                  # noqa: E402  (on the path through tr7a_stage)

ALPHA_SUPPORT = Fraction(5, 100)
ALPHA_CONTRA = Fraction(5, 100)        # split over the verdict runs
VERDICT_RUNS = [r for r in S.RUNS if r[4] == "verdict"]


def tail_half(n, k):
    """The exact chance that a fair coin gives at least k heads in n tosses."""
    return Fraction(sum(math.comb(n, j) for j in range(k, n + 1)), 2 ** n)


def critical(n, alpha):
    """The least k with tail_half(n, k) <= alpha, or None where none is."""
    return next((k for k in range(n + 1) if tail_half(n, k) <= alpha), None)


SUPPORT_AT = critical(S.SEEDS, ALPHA_SUPPORT)
CONTRA_AT = critical(S.SEEDS, ALPHA_CONTRA / len(VERDICT_RUNS))
assert (S.SEEDS, len(VERDICT_RUNS), SUPPORT_AT, CONTRA_AT) == (20, 11, 15, 17)
assert SUPPORT_AT + CONTRA_AT > S.SEEDS, "a run cannot be both supported and contradicted"


def target(run):
    """The law's end for a chance or mixture run; the maximal plans' names for a told one."""
    name, cid, learner, start, role = run
    s = S.prospects(cid)
    if learner == "told":
        return sorted(tr7.NAME[p] for p in tr7.maximal_set(s))
    if learner == "mixture":
        assert all(not tr7.mixture_above(s, a, b) for a in range(1, 6) for b in range(1, 6)), "no mixture above"
        return Fraction(0)
    return tr7.best_chance(s)


def start_policy(run):
    name, cid, learner, start, role = run
    return S.softmax(list(start)) if learner == "told" else float(start)


def d_of(run, final):
    """The seed's movement in the law's direction (positive), against it (negative), or neither (zero)."""
    name, cid, learner, start, role = run
    t = target(run)
    if learner == "told":
        idx = [S.NAMES.index(n) for n in t]
        return round(sum(final[k] for k in idx) - sum(start_policy(run)[k] for k in idx), 6)
    return round(abs(float(start) - float(t)) - abs(final - float(t)), 6)


def verdict(pos, neg):
    if pos >= SUPPORT_AT:
        return "supported"
    if neg >= CONTRA_AT:
        return "contradicted"
    return "unresolved"


def summary(xs):
    xs = sorted(xs)
    n = len(xs)
    med = xs[n // 2] if n % 2 else (xs[n // 2 - 1] + xs[n // 2]) / 2
    return {"mean": round(sum(xs) / n, 6), "median": round(med, 6), "min": xs[0], "max": xs[-1]}


def fields(run):
    name, cid, learner, start, role = run
    return {"condition": cid, "learner": learner, "start": list(start) if learner == "told" else str(start),
            "role": role}


def shaped(learner, fin):
    """A final policy of the learner's shape: four shares summing to one, or one chance or weight in [0, 1]."""
    def num(x):
        return isinstance(x, (int, float)) and not isinstance(x, bool) and 0 <= x <= 1
    if learner == "told":
        return isinstance(fin, list) and len(fin) == 4 and all(map(num, fin)) and abs(sum(fin) - 1) < 1e-5
    return num(fin)


def check_records(records, links=None):
    """Refuse records the reading was not frozen for: a run or seed not in the frozen runs, a learner twice,
    fields that differ from its run's, a final policy of the wrong shape (four shares summing to one for a
    told learner, one chance or weight in [0, 1] otherwise), or, where links are given, a record not stamped
    with one of them."""
    runs = {r[0]: r for r in S.RUNS}
    seen = set()
    for rec in records:
        run = runs.get(rec.get("run"))
        if run is None or rec.get("seed") not in range(S.SEEDS):
            raise SystemExit(f"a record for no frozen run or seed: {rec.get('run')!r} seed {rec.get('seed')!r}")
        key = (rec["run"], rec["seed"])
        if key in seen:
            raise SystemExit(f"a learner recorded twice: {key}")
        seen.add(key)
        want = fields(run)
        got = {k: rec.get(k) for k in want}
        if got != want:
            raise SystemExit(f"a record's fields differ from its run's: {key}: {got} against {want}")
        if not shaped(run[2], rec.get("final")):
            raise SystemExit(f"a record's final policy is not of its learner's shape: {key}: {rec.get('final')!r}")
        if links is not None and (rec.get("frozen") or {}).get("link commit") not in links:
            raise SystemExit(f"a record not made under this freeze's chain: {key}: {rec.get('frozen')}")


def read(records, stage0=None, links=None):
    check_records(records, links)
    by = {}
    for rec in records:
        by.setdefault(rec["run"], []).append(rec)
    out = {"support at": SUPPORT_AT, "contradiction at": CONTRA_AT, "seeds": S.SEEDS, "runs": {}}
    verdicts = []
    for run in S.RUNS:
        name, cid, learner, start, role = run
        recs = sorted(by.get(name, []), key=lambda r: r["seed"])
        row = {"condition": cid, "learner": learner, "role": role, "seeds": len(recs), "target": str(target(run))}
        if len(recs) != S.SEEDS:
            row["status"] = f"incomplete: {len(recs)} of {S.SEEDS} seeds"
            if role == "verdict":
                verdicts.append("incomplete")
            out["runs"][name] = row
            continue
        ds = [d_of(run, r["final"]) for r in recs]
        pos, neg = sum(d > 0 for d in ds), sum(d < 0 for d in ds)
        row.update({"d by seed": ds, "toward the law": pos, "against it": neg, "neither": len(ds) - pos - neg})
        if learner == "told":
            row["final shares"] = {n: summary([r["final"][k] for r in recs]) for k, n in enumerate(S.NAMES)}
        else:
            row["final chance" if learner == "chance" else "final weight"] = summary([r["final"] for r in recs])
        if stage0 is not None and name in stage0.get("reference ends", {}):
            ref = stage0["reference ends"][name]
            if learner == "told":
                row["mean distance from the reference end (total variation)"] = round(
                    sum(0.5 * sum(abs(r["final"][k] - ref[k]) for k in range(4)) for r in recs) / len(recs), 6)
            else:
                row["mean distance from the reference end"] = round(sum(abs(r["final"] - ref) for r in recs) / len(recs), 6)
        if learner == "chance" and 0 < target(run) < 1:  # within the improving chances: reported, no verdict
            ib = float(tr7.improving_bound(S.prospects(cid)))
            row["seeds ending within the improving chances (0, %s)" % tr7.improving_bound(S.prospects(cid))] = \
                sum(0 < r["final"] < ib for r in recs)
        if cid in ("A3", "A5"):                      # how the tie settles by the start: reported, no verdict
            tied = target(run)
            row["how the tie settles"] = {n: sum(r["final"][S.NAMES.index(n)] > r["final"][S.NAMES.index(m)]
                                                 for r in recs) for n in tied for m in tied if m != n}
        if role == "verdict":
            row["verdict"] = verdict(pos, neg)
            verdicts.append(row["verdict"])
        out["runs"][name] = row
    if "incomplete" in verdicts:
        out["reading"] = "incomplete"
    elif "contradicted" in verdicts:
        out["reading"] = "contradicted"
    elif all(v == "supported" for v in verdicts):
        out["reading"] = "supported"
    else:
        out["reading"] = "unresolved"
    return out


def main():
    f = S.frozen()
    links = set(f["commits"].values())
    records = S.records(S.OUT)
    s0 = HERE / "results" / "stage0.json"
    res = read(records, json.loads(s0.read_text()) if s0.exists() else None, links)
    res["frozen"] = {"link": f["link"], "link commit": f["link_commit"], "head": f["head"]}
    path = HERE / "results" / "reading.json"
    path.write_text(json.dumps(res, indent=1) + "\n")
    print(json.dumps({k: v for k, v in res.items() if k != "runs"}, indent=1))
    print({k: v.get("verdict", "reported") for k, v in res["runs"].items()})


if __name__ == "__main__":
    main()
