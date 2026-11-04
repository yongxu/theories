"""TR9's frozen verdict rule on classified answers (FREEZE-8.md, section 5): freeze 1's rule for TR8
(rule.unit_verdict with test "tr8": a probe's numbers are each option's expected total result, the
higher the better), on TR9's eleven strict conditions, with TR9's two premises (REST-TR8-TR9.md,
R:320). Pure functions: tr9_run.py applies them to a run's logs and tr9_dry_run.py to simulated
answers, so the two read alike.

A choice call's answer is freeze 1's: an option's label, DECLINE, FILTERED or INVALID, a decline
counted among the valid answers and against the counts-first options. A probe call's answer is
tr9_design.classify's: None where nothing is read, else {"worths": {label: number} or None, "answers":
{label: {situation: "stop" or "go on"}} or None}. Freeze 1's rule reads the worths alone (its guard
and its label, at least VALID_AT readable of PROBE_CALLS); the reader premise reads the answers.

The premises. TR8's: TR8's bridge supported for the same pin in its abstract framing and the same
presentation (FREEZE-8.md, section 5, on why the abstract unit); a unit whose TR8 unit was not run,
or not read whole, has no premise. The reader's, where the system computes: in every strict
condition at least READER_PROBE_AT of the PROBE_CALLS probe calls state the reader's answer rightly,
for every option that waits and every situation (an unread call, or one with an answer missing or
not read, is not right). A failed premise voids the unit; so does a condition with fewer than
VALID_AT valid answers, as in freeze 1, which is checked first. The bridge's reading without the
premises is kept beside a void it would otherwise give, reported only.
"""

from math import comb

import tr9_design as D          # puts freeze 1's told/ on the path
import rule                     # noqa: E402  freeze 1's
import conditions as C1         # noqa: E402
from conditions import N_CALLS, PROBE_CALLS, VALID_AT   # noqa: E402

READER_PROBE_AT = D.READER_PROBE_AT
SUPPORTED = "supported"
# The conditions whose counts-first options all give the reader values: a contradiction there and
# nowhere else is read "giving values avoided where the counts favour it" (DESIGN.md, TR9's outcomes),
# by choosing or by declining.
GIVE_FIRST = tuple(c["id"] for c in D.CONDS
                   if all(o["kind"] in ("give", "give+show") for o in c["options"] if o["label"] in c["counts_first"]))
assert GIVE_FIRST == ("REF6", "REV4"), GIVE_FIRST
READ_BY_THE_BRIDGE = ("by", "why", "guard_hits", "guard_unmeasured", "guard_hits_reported")
STOPS = {c["id"]: D.stops_named(c) for c in D.CONDS + [D.SMOKE]}     # the reader's answers the words fix


def worths(probe):
    """The numbers freeze 1's rule reads from a probe call: each option's expected total result, or None."""
    return (probe or {}).get("worths")


def reader_right(cond, probe):
    """The call states the reader's answer, as the condition's words fix it, for every option that
    waits and every situation."""
    got = (probe or {}).get("answers") or {}
    return all((got.get(lab) or {}).get(s) == a for lab, sits in STOPS[cond["id"]].items() for s, a in sits.items())


def unit_verdict(conds, answers, probes, compute, framing, tr8_premise):
    """The bridge for one unit (pin, framing, presentation). answers[cid]: N_CALLS choice answers;
    probes[cid]: PROBE_CALLS probe answers where compute; tr8_premise: TR8's abstract unit's bridge for
    the same pin and presentation, or None where it has none (not run, or not read whole)."""
    if compute:
        assert all(len(probes[c["id"]]) == PROBE_CALLS for c in conds), "a probe answer for every probe call"
    res = rule.unit_verdict("tr8", conds, answers,
                            {cid: [worths(p) for p in ps] for cid, ps in probes.items()} if compute else None,
                            compute, framing)
    res["tr8_premise"] = tr8_premise if tr8_premise is not None else "not measured"
    if compute:
        res["reader_right"] = {c["id"]: sum(1 for p in probes[c["id"]] if reader_right(c, p))
                               for c in conds if c["role"] == "strict"}
    if res["bridge"] != "void":
        failed = []
        if tr8_premise != SUPPORTED:
            failed.append("TR8's abstract unit for this pin and presentation "
                          + ("not run, or not read whole" if tr8_premise is None else f"{tr8_premise}, not supported"))
        low = sorted(cid for cid, n in (res.get("reader_right") or {}).items() if n < READER_PROBE_AT)
        if low:
            failed.append(f"the reader probe right in fewer than {READER_PROBE_AT} of {PROBE_CALLS} at {low}")
        if failed:
            res["read_without_the_premises"] = {"bridge": res["bridge"],
                                                **{k: res.pop(k) for k in READ_BY_THE_BRIDGE if k in res}}
            res["bridge"] = "void"
            res["why"] = "; ".join(failed)
    if res["bridge"] == "contradicted" and set(res["contradicted_at"]) <= set(GIVE_FIRST):
        res["reading"] = "giving values avoided where the counts favour it"
    return res


# ----------------------------------------------------------------------------------------------
# The readability rule (FREEZE-8.md, section 8): a scored run starts only where reading alone is
# projected to leave at most a fifth of its units void or unresolved. It reads nothing of what a
# system chooses or computes, only whether its answers can be read: freeze 1's validity (at least
# VALID_AT valid choices of N_CALLS in every condition) and its guard (at least VALID_AT readable
# probes of PROBE_CALLS in every condition the guard reads, the strict ones where the system computes).
# ----------------------------------------------------------------------------------------------

READABLE_AT = 0.8


def within(rate, n, at=VALID_AT):
    """The chance that n calls, each unreadable with probability rate, leave at least `at` readable."""
    return sum(comb(n, k) * rate ** k * (1 - rate) ** (n - k) for k in range(n - at + 1))


def shape(test, framing):
    """A unit's conditions and those the guard reads (strict), by freeze 1's roles for its tests."""
    conds = D.CONDS if test == D.TEST else C1.conditions(test)
    role_of = rule.roles("tr8" if test == D.TEST else test, framing)
    return len(conds), sum(1 for c in conds if role_of(c) == "strict")


def unreadable(test, rec):
    """A logged call no reading can use: a choice invalid or filtered; a probe whose numbers rank no
    option first (freeze 1's probe_first, on TR9's numbers for TR9)."""
    if rec["kind"] == "choice":
        return rec["answer"] in (rule.INVALID, rule.FILTERED)
    nums = worths(rec.get("probe")) if test == D.TEST else rec.get("probe")
    return not rule.probe_first("tr8" if test == D.TEST else test, nums)


def readability(test, contexts, recs):
    """The pin's rates of unreadable choices and probes over the logged calls given (each read as its
    own test's), and per context of the test asked the projected share of its unit not lost to
    reading, calls unreadable independently at those rates."""
    n = {k: [r for r in recs if r["kind"] == k] for k in ("choice", "probe")}
    rate = {k: (sum(1 for r in v if unreadable(r["test"], r)) / len(v)) if v else None for k, v in n.items()}
    out = {"choices": len(n["choice"]), "probes": len(n["probe"]), "choice_unreadable": rate["choice"],
           "probe_unreadable": rate["probe"], "bound": READABLE_AT, "contexts": {}}
    for ctx in contexts:
        framing, presentation = ctx.split("/")
        compute = presentation == "compute"
        nc, ng = shape(test, framing)
        if rate["choice"] is None or (compute and rate["probe"] is None):
            out["contexts"][ctx] = {"projected": None, "start": False, "why": "not measured"}
            continue
        p = within(rate["choice"], N_CALLS) ** nc * (within(rate["probe"], PROBE_CALLS) ** ng if compute else 1.0)
        out["contexts"][ctx] = {"conditions": nc, "guarded": ng if compute else 0, "projected": round(p, 4),
                                "start": p >= READABLE_AT}
    return out
