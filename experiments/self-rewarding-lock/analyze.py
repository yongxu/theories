"""Verdicts of LA2 by the rules frozen in PREDICTIONS-2026-10-25.md.

    python3 analyze.py      # writes results/VERDICTS.json and prints a table

Per seed: kept where the share of list answers at the end (step 8) is not below its share at the step
after the reading at which the theorems are applied (step 4; for in_time, step 2: the step after the
reading at step 1, where the others are still the more numerous); turned where the share at the end is
strictly below it.  An invalid seed (a judge's reading with fewer than five valid picks after one re-ask)
counts against the prediction, and in the control it is neither kept nor turned.  A condition passes
where at least 4 of its 5 seeds go as predicted; a contrast passes where all its conditions pass.
`in_time_unread`, the control, has no verdict.

The unit of every test is a call, not a pick: the ten picks of one call need not be independent of one
another, while calls are.  Reported with the verdicts, not counted:
* each condition's first reading (its calls at steps 0 and 1 for in_time and in_time_unread, at step 3
  otherwise): for each call its share of list picks less one half, and an exact sign-flip test, one-sided
  at 0.05 each way, of whether the calls lean to lists or to prose.  It labels a failed condition: failed at
  the first reading (resolved against the prediction), failed later in the course (resolved for it), or
  not resolved by the readings;
* two measures, each an exact one-sided paired sign-flip test at 0.05 over calls alike in seed and step
  (the same counts, questions and orders): whether the others' notes lower the share of list picks where
  they are most of the readers (in_time against in_time_unread at steps 0 and 1: ten pairs), and whether
  one note in nine does (late against unread at step 3: five pairs);
* what the verdicts and measures support, by the frozen rules.
"""

import json
import os

from loop import CONDITIONS, T, le, lt

HERE = os.path.dirname(os.path.abspath(__file__))

PREDICTED = {"in_time": "turned", "in_time_unread": None, "late": "kept", "unread": "kept", "read_all": "turned"}
FROM_STEP = {"in_time": 2, "in_time_unread": 2, "late": 4, "unread": 4, "read_all": 4}
FIRST_READINGS = {"in_time": (0, 1), "in_time_unread": (0, 1), "late": (3,), "unread": (3,), "read_all": (3,)}
CONTRASTS = {
    "L1_an_unread_loss_leaves_the_lock": ["unread"],
    "L2_a_loss_read_by_every_reader_turns_the_course": ["read_all"],
    "L3_who_reads_decides": ["late", "read_all"],
    "L4_when_it_is_read_decides": ["in_time", "late"],
}
MEASURES = {"notes_where_most_readers": ("in_time", "in_time_unread"), "one_note_in_nine": ("late", "unread")}
LEVEL = 0.05


def as_pair(x):
    return tuple(x)


def kept(r):
    xs = [as_pair(x) for x in r["shares"]]
    return r["valid"] and le(xs[FROM_STEP[r["cond"]]], xs[T])


def turned(r):
    xs = [as_pair(x) for x in r["shares"]]
    return r["valid"] and lt(xs[T], xs[FROM_STEP[r["cond"]]])


def seed_hit(r):
    want = PREDICTED[r["cond"]]
    if want is None:
        return None
    return kept(r) if want == "kept" else turned(r)


SCALE = 2520   # every share k/n with n <= 10, and every difference of two, is a whole multiple of 1/2520


def sign_flip_upper(xs):
    """Exact one-sided sign-flip p-value: the share of the 2^k sign choices whose sum is at least sum(xs),
    counted exactly on the scale SCALE (zeros, whose sign changes nothing, left out)."""
    vs = [round(x * SCALE) for x in xs]
    vs = [v for v in vs if v != 0]
    if not vs:
        return 1.0
    obs, dist = sum(vs), {0: 1}
    for v in vs:
        nxt = {}
        for s, c in dist.items():
            nxt[s + abs(v)] = nxt.get(s + abs(v), 0) + c
            nxt[s - abs(v)] = nxt.get(s - abs(v), 0) + c
        dist = nxt
    return sum(c for s, c in dist.items() if s >= obs) / 2 ** len(vs)


def call_readings(rs, steps):
    """{(seed, step): share of list picks} of the valid calls at the given steps."""
    out = {}
    for r in rs:
        for rd in r["readings"]:
            p = rd["picks"]
            if rd["spec"]["step"] in steps and p["valid"] and p["list"] + p["prose"] > 0:
                out[(r["seed"], rd["spec"]["step"])] = p["list"] / (p["list"] + p["prose"])
    return out


def first_reading(rs, name):
    shares = call_readings(rs, FIRST_READINGS[name])
    lean = [s - 0.5 for s in shares.values()]
    p_lists, p_prose = sign_flip_upper(lean), sign_flip_upper([-x for x in lean])
    side = "lists" if p_lists < LEVEL else ("prose" if p_prose < LEVEL else "unresolved")
    return dict(calls=len(shares), mean_list_share=sum(shares.values()) / len(shares) if shares else None,
                p_lists=p_lists, p_prose=p_prose, side=side)


def measure(by, with_loss, without):
    a = call_readings(by[with_loss], FIRST_READINGS[with_loss])
    b = call_readings(by[without], FIRST_READINGS[without])
    keys = sorted(set(a) & set(b))
    diffs = [b[k] - a[k] for k in keys]          # positive where the loss read lowers the share of list picks
    pv = sign_flip_upper(diffs)
    return dict(pairs=len(keys), mean_difference=sum(diffs) / len(diffs) if diffs else None, p_value=pv,
                resolved=pv < LEVEL)


def stepwise(r):
    """Steps from FROM_STEP to T whose rule in force goes the predicted way (reported only)."""
    if PREDICTED[r["cond"]] is None:
        return None
    gs = r["rules"][FROM_STEP[r["cond"]]:T + 1]
    way = (lambda g: g[1] <= g[0]) if PREDICTED[r["cond"]] == "kept" else (lambda g: g[0] < g[1])
    return sum(1 for g in gs if way(g)), len(gs)


def supports(v):
    """The frozen rules: what the verdicts and measures support, and the readings of a failure."""
    c, k, m = v["conditions"], v["contrasts"], v["measures"]
    notes = m["notes_where_most_readers"]["resolved"]
    control = c["in_time_unread"]
    return {
        "the others' readers read the loss": notes,
        "the counts decide, one note in nine outweighed": k["L3_who_reads_decides"] and notes,
        "the loss read in time turned a course that would otherwise be kept":
            k["L4_when_it_is_read_decides"] and control["kept_seeds"] >= 4 and notes,
        "in_time turned by the readers' counts alone, the loss not needed":
            k["L4_when_it_is_read_decides"] and control["turned_seeds"] >= 4,
        "a single reading turned the lock (the third forbidden case of T7)":
            c["late"]["verdict"] == "failed" and c["unread"]["verdict"] == "passed"
            and c["late"]["first_reading"]["side"] == "prose" and m["one_note_in_nine"]["resolved"],
        "a loss read by every reader did not turn the course, a taste for lists ruled out":
            c["read_all"]["verdict"] == "failed" and c["read_all"]["first_reading"]["side"] == "lists"
            and c["in_time"]["verdict"] == "passed",
        "no lock formed from the loop's own selections":
            c["unread"]["verdict"] == "failed" and c["unread"]["first_reading"]["side"] == "prose",
        "the readers that carry the loss, the more numerous, did not turn the course":
            c["in_time"]["verdict"] == "failed" and c["in_time"]["first_reading"]["side"] == "lists",
    }


def verdicts(runs):
    out = dict(conditions={}, contrasts={}, measures={})
    by = {name: [r for r in runs if r["cond"] == name] for name in CONDITIONS}
    for name, rs in by.items():
        fr = first_reading(rs, name)
        d = dict(predicted=PREDICTED[name], seeds=len(rs), invalid_seeds=sum(1 for r in rs if not r["valid"]),
                 first_reading=fr, kept_seeds=sum(1 for r in rs if kept(r)),
                 turned_seeds=sum(1 for r in rs if turned(r)), stepwise=[stepwise(r) for r in rs],
                 share_from=[as_pair(r["shares"][FROM_STEP[name]]) for r in rs],
                 share_end=[as_pair(r["shares"][T]) for r in rs])
        if PREDICTED[name] is not None:
            hits = sum(1 for r in rs if seed_hit(r))
            d.update(hits=hits, verdict="passed" if hits >= 4 else "failed", label=None)
            if d["verdict"] == "failed":
                want = "lists" if PREDICTED[name] == "kept" else "prose"
                d["label"] = ("not resolved by the readings" if fr["side"] == "unresolved" else
                              "failed later in the course" if fr["side"] == want else "failed at the first reading")
        out["conditions"][name] = d
    for k, names in CONTRASTS.items():
        out["contrasts"][k] = all(out["conditions"][n]["verdict"] == "passed" for n in names)
    for k, (with_loss, without) in MEASURES.items():
        out["measures"][k] = measure(by, with_loss, without)
    out["supports"] = supports(out)
    return out


def main():
    runs = json.load(open(os.path.join(HERE, "results", "runs.json")))["runs"]
    out = verdicts(runs)
    json.dump(out, open(os.path.join(HERE, "results", "VERDICTS.json"), "w"), indent=1)
    for n, d in out["conditions"].items():
        fr = d["first_reading"]
        head = (f"predicted {d['predicted']:6} {d['hits']}/{d['seeds']} -> {d['verdict']}"
                f"{' (' + d['label'] + ')' if d['label'] else ''}" if d["predicted"] else
                f"control: kept in {d['kept_seeds']}, turned in {d['turned_seeds']} of {d['seeds']}")
        share = "none" if fr["mean_list_share"] is None else f"{fr['mean_list_share']:.2f}"
        print(f"{n:14} {head}; first reading: {fr['calls']} calls, mean list share {share}, "
              f"leaning to {fr['side']} (p lists {fr['p_lists']:.3g}, p prose {fr['p_prose']:.3g})")
    for k, v in out["contrasts"].items():
        print(k, "passed" if v else "failed")
    for k, m in out["measures"].items():
        diff = "none" if m["mean_difference"] is None else f"{m['mean_difference']:.2f}"
        print(f"{k}: {m['pairs']} paired calls, mean fall in the share of list picks {diff}, "
              f"one-sided p = {m['p_value']:.3g} ({'resolved' if m['resolved'] else 'not resolved'})")
    for k, v in out["supports"].items():
        print(("supported:     " if v else "not supported: ") + k)


if __name__ == "__main__":
    main()
