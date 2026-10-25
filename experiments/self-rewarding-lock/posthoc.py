"""Post hoc readings of LA2's run, written after its verdicts (README, "Post hoc").  Not frozen, not verdicts.

    python3 posthoc.py      # writes results/POSTHOC.json and prints a table

1. The judge's readings by what it read: every distinct call (a call shared by two conditions counted
   once), grouped by the reference set's counts and by what in it reads the loss (the notes on its prose
   answers, the delivery report, or nothing).
2. H1-LA2's assertions about the readings (PREDICTIONS-2026-10-25.md), checked on those groups.  The
   first (each list answer reads for lists at least as much as each prose answer) is about the readers
   one by one and cannot be read off a pooled reading, so it is not checked.
3. The courses read step by step from the step the verdicts start from (FROM_STEP): for a kept prediction,
   whether the share is never below its value there and the rule in force favours lists at every step (the
   theorems' "locked ... never below"); for a turned one, whether the share is never above it and the rule in
   force never favours lists.  The frozen verdict reads only the end.
4. The share above which the reference set of nine holds no prose answer, and so, in `late`, no note.
"""

import json
import os
from fractions import Fraction

from analyze import FROM_STEP, PREDICTED
from loop import REF, T, favours, le

HERE = os.path.dirname(os.path.abspath(__file__))


def reads_loss(s):
    if s["report"]:
        return "report"
    if s["notes"] and s["n_prose"] > 0:
        return "notes"
    return "nothing"


def readings_by_input(runs):
    calls = {}
    for r in runs:
        for rd in r["readings"]:
            s, p = rd["spec"], rd["picks"]
            calls[p["key"]] = (s["n_lists"], s["n_prose"], reads_loss(s), p)
    groups = {}
    for n_lists, n_prose, how, p in calls.values():
        g = groups.setdefault((n_lists, n_prose, how), dict(calls=0, list=0, picks=0))
        g["calls"] += 1
        g["list"] += p["list"]
        g["picks"] += p["list"] + p["prose"]
    return {f"{k[0]} lists : {k[1]} prose, loss read by {k[2]}": v for k, v in sorted(groups.items())}, len(calls)


def course_by_step(r):
    want = PREDICTED[r["cond"]]
    if want is None:
        return None
    xs, gs = [tuple(x) for x in r["shares"]], [tuple(g) for g in r["rules"]]
    f = FROM_STEP[r["cond"]]
    if want == "kept":
        share_ok = [t for t in range(f, T + 1) if le(xs[f], xs[t])]
        rule_ok = [t for t in range(f, T + 1) if favours(gs[t])]
    else:
        share_ok = [t for t in range(f, T + 1) if le(xs[t], xs[f])]
        rule_ok = [t for t in range(f, T + 1) if not favours(gs[t])]
    steps = list(range(f, T + 1))
    return dict(steps=steps, share_held_at=share_ok, rule_held_at=rule_ok,
                held_throughout=share_ok == steps and rule_ok == steps,
                shares=[str(Fraction(x[0], x[0] + x[1])) for x in xs[f:]])


def main():
    runs = json.load(open(os.path.join(HERE, "results", "runs.json")))["runs"]
    groups, n_calls = readings_by_input(runs)

    def share(key):
        g = groups.get(key)
        return None if g is None or g["picks"] == 0 else g["list"] / g["picks"]

    h1 = {
        "8 of 9 list answers, no note: favours lists": share("8 lists : 1 prose, loss read by nothing"),
        "8 of 9 list answers, one note: favours lists": share("8 lists : 1 prose, loss read by notes"),
        "8 of 9 prose answers with notes: favours prose": share("1 lists : 8 prose, loss read by notes"),
        "6 of 9 prose answers with notes: favours prose": share("3 lists : 6 prose, loss read by notes"),
        "every reader reads the loss (the report): favours prose": [
            (k, v["list"] / v["picks"]) for k, v in groups.items() if k.endswith("report")],
    }
    courses = {}
    for r in runs:
        c = course_by_step(r)
        if c is not None:
            courses.setdefault(r["cond"], []).append(c)
    # the least share at which the reference set holds REF list answers: nearest, halves up
    threshold = Fraction(2 * REF - 1, 2 * REF)
    out = dict(calls=n_calls, readings_by_input=groups, h1_la2_share_of_list_picks=h1,
               courses_step_by_step={k: dict(held_throughout=sum(c["held_throughout"] for c in v), seeds=len(v),
                                             seed_0=v[0]) for k, v in courses.items()},
               no_prose_answer_in_the_reference_set_from_share=str(threshold))
    json.dump(out, open(os.path.join(HERE, "results", "POSTHOC.json"), "w"), indent=1)

    print(f"{n_calls} distinct judge calls")
    for k, v in groups.items():
        print(f"  {k:45} {v['calls']:3} calls, list picks {v['list']:3} of {v['picks']}")
    print("H1-LA2's assertions (share of list picks):")
    for k, v in h1.items():
        print(f"  {k}: {v}")
    for k, v in out["courses_step_by_step"].items():
        print(f"{k:9} held at every step from {FROM_STEP[k]} in {v['held_throughout']} of {v['seeds']} seeds; "
              f"seed 0 shares {v['seed_0']['shares']}")
    print("the reference set holds no prose answer from share", threshold)


if __name__ == "__main__":
    main()
