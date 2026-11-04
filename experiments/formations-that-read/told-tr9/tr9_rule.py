"""TR9's frozen verdict rule on classified answers (FREEZE-8.md, section 4): freeze 1's rule for TR8
(rule.unit_verdict with test "tr8": a probe's numbers are each option's expected total result, the
higher the better), on TR9's eleven strict conditions, with TR9's two premises (REST-TR8-TR9.md,
R7). Pure functions: tr9_run.py applies them to a run's logs and tr9_dry_run.py to simulated
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

from math import exp, lgamma, log, log1p

import tr9_design as D          # puts freeze 1's told/ on the path
import rule                     # noqa: E402  freeze 1's
import conditions as C1         # noqa: E402
from conditions import N_CALLS, PROBE_CALLS, VALID_AT   # noqa: E402

READER_PROBE_AT = D.READER_PROBE_AT
SUPPORTED = "supported"
# Two readings, reported with no verdict of their own (FREEZE-8.md, section 4). GIVE_FIRST: the
# conditions whose counts-first options all give the reader values; a contradiction there and nowhere
# else, at each mostly by declining or by options that give nothing, is read "giving values avoided
# where the counts favour it". OFFERS_GIVING: the conditions with an option that gives values; a
# contradiction by declining at each condition contradicted, all of them among these, is read
# "declined where giving values is offered".
GIVES = ("give", "give+show")
GIVE_FIRST = tuple(c["id"] for c in D.CONDS
                   if all(o["kind"] in GIVES for o in c["options"] if o["label"] in c["counts_first"]))
assert GIVE_FIRST == ("REF6", "REV4"), GIVE_FIRST
OFFERS_GIVING = tuple(c["id"] for c in D.CONDS if any(o["kind"] in GIVES for o in c["options"]))
assert OFFERS_GIVING == ("CV6", "REF6", "CVT", "REV4", "REV16", "REVCV", "REV0"), OFFERS_GIVING
AVOIDED = "giving values avoided where the counts favour it"
DECLINED_GIVING = "declined where giving values is offered"
READ_BY_THE_BRIDGE = ("by", "why", "guard_hits", "guard_unmeasured", "guard_hits_reported", "contradicted_at",
                      "declined_at")
STOPS = {c["id"]: D.stops_named(c) for c in D.CONDS + [D.SMOKE]}     # the reader's answers the words fix


def worths(probe):
    """The numbers freeze 1's rule reads from a probe call: each option's expected total result, or None."""
    return (probe or {}).get("worths")


def reader_right(cond, probe):
    """The call states the reader's answer, as the condition's words fix it, for every option that
    waits and every situation."""
    got = (probe or {}).get("answers") or {}
    return all((got.get(lab) or {}).get(s) == a for lab, sits in STOPS[cond["id"]].items() for s, a in sits.items())


def avoided(v):
    """At least half of a contradicted condition's answers against are declines or options that give
    no values (freeze 1's per-condition output v)."""
    gives = {o["label"] for o in D.BY_ID[v["id"]]["options"] if o["kind"] in GIVES}
    n = v["n_declined"] + sum(k for lab, k in v["shares"].items()
                              if lab not in gives and lab not in v["counts_first"]
                              and lab not in (rule.INVALID, rule.FILTERED, rule.DECLINE))
    return 2 * n >= v["n_against"]


def reading(res):
    """The reading a contradicted bridge carries, or None."""
    if res["bridge"] != "contradicted":
        return None
    at = {v["id"]: v for v in res["conditions"] if v["status"] == "contradicted"}
    if set(at) <= set(GIVE_FIRST) and all(avoided(v) for v in at.values()):
        return AVOIDED
    if set(at) <= set(OFFERS_GIVING) and all(v.get("by") == "declining" for v in at.values()):
        return DECLINED_GIVING
    return None


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
            if reading({"bridge": res["bridge"], "conditions": res["conditions"]}):
                res["read_without_the_premises"]["reading"] = reading(res)
            res["bridge"] = "void"
            res["why"] = "; ".join(failed)
    if res["bridge"] == "void":         # a void unit names no condition contradicted or declined at its top
        res["contradicted_at"], res["declined_at"] = [], []
    if reading(res):
        res["reading"] = reading(res)
    return res


# ----------------------------------------------------------------------------------------------
# The readability rule (FREEZE-8.md, section 8). A scored run of a test starts on a pin unless the
# test's own calls already made there, under the frozen files in force, show its answers unreadable at
# a rate which alone would leave fewer than READABLE_AT of its units free of a void that reading makes.
# It reads nothing of what a system chooses or computes, only whether its answers can be read, and it
# stops only on that evidence: each rate is taken at its one-sided lower confidence bound (Clopper and
# Pearson, at 1 - CONFIDENT), the least rate the calls leave plausible, so calls that fit a rate at or
# below the bound's never stop a test. A void that reading makes: freeze 1's validity (VALID_AT valid
# choices of N_CALLS in every condition, its premise conditions included) and, where TR9's system
# computes, the reader premise, which needs READER_PROBE_AT probes of PROBE_CALLS in every condition
# whose reader's answers can be read (answers_read), since only such a call can state them rightly. A support needs the guard measured too (VALID_AT readable probes of PROBE_CALLS in every
# supported condition): that chance is reported, never a stop, since a contradiction by a condition is
# read without it (freeze 1's unit_verdict reads the guard only where every strict condition is
# supported).
# ----------------------------------------------------------------------------------------------

READABLE_AT = 0.8
CONFIDENT = 0.05


def _pmf(n, k, p):
    if p <= 0.0:
        return 1.0 if k == 0 else 0.0
    if p >= 1.0:
        return 1.0 if k == n else 0.0
    return exp(lgamma(n + 1) - lgamma(k + 1) - lgamma(n - k + 1) + k * log(p) + (n - k) * log1p(-p))


def within(rate, n, at=VALID_AT):
    """The chance that n calls, each unreadable with probability rate, leave at least `at` readable."""
    return sum(_pmf(n, k, rate) for k in range(n - at + 1))


def at_least(k, n, p):
    """The chance that k or more of n calls are unreadable, each with probability p."""
    return 1.0 - sum(_pmf(n, j, p) for j in range(k))


def lower(k, n):
    """The one-sided lower confidence bound at 1 - CONFIDENT on a rate seen k times in n (Clopper and
    Pearson): below it, k or more of n would come with a chance under CONFIDENT. 0 where k is 0; taken
    from below, so a bound never exceeds the exact one."""
    if k == 0:
        return 0.0
    lo, hi = 0.0, k / n
    for _ in range(60):
        mid = (lo + hi) / 2
        if at_least(k, n, mid) < CONFIDENT:
            lo = mid
        else:
            hi = mid
    return lo


def shape(test, framing):
    """A unit's conditions and those the guard reads (strict), by freeze 1's roles for its tests."""
    conds = D.CONDS if test == D.TEST else C1.conditions(test)
    role_of = rule.roles("tr8" if test == D.TEST else test, framing)
    return len(conds), sum(1 for c in conds if role_of(c) == "strict")


def unreadable(test, rec):
    """A logged call the rule's minimums cannot count: a choice invalid or filtered; a probe whose
    numbers rank no option first, for the guard (freeze 1's probe_first, on TR9's numbers for TR9)."""
    if rec["kind"] == "choice":
        return rec["answer"] in (rule.INVALID, rule.FILTERED)
    nums = worths(rec.get("probe")) if test == D.TEST else rec.get("probe")
    return not rule.probe_first("tr8" if test == D.TEST else test, nums)


def answers_read(rec):
    """A TR9 probe call whose reader's answers are all read, right or not: an answer for every option
    that waits and every situation. Only such a call can state them rightly (reader_right)."""
    got = (rec.get("probe") or {}).get("answers") or {}
    return all((got.get(lab) or {}).get(s) is not None for lab, sits in STOPS[rec["condition"]].items() for s in sits)


def readability(test, contexts, recs):
    """The readability rule on the test's own logged calls on one pin (recs), per context of the test:
    the counts and rates of unreadable choices, of probes the guard cannot read and, for TR9, of probes
    whose reader's answers cannot be read; each rate's lower bound; and per context the share of units free of a void by
    reading at the bounds (its start, at least READABLE_AT), with, at the rates seen, the share read
    whole and the chance a support's guard is measured, reported only."""
    ch = [r for r in recs if r["kind"] == "choice"]
    pr = [r for r in recs if r["kind"] == "probe"]
    k = {"choice": sum(1 for r in ch if unreadable(test, r)), "guard": sum(1 for r in pr if unreadable(test, r)),
         "reader": sum(1 for r in pr if not answers_read(r)) if test == D.TEST else 0}
    n = {"choice": len(ch), "guard": len(pr), "reader": len(pr)}
    rate = {x: k[x] / n[x] if n[x] else None for x in k}
    lo = {x: lower(k[x], n[x]) if n[x] else 0.0 for x in k}
    out = {"choices": n["choice"], "probes": n["guard"], "unreadable": k, "rate": rate,
           "at_least": {x: round(v, 4) for x, v in lo.items()}, "confidence": 1 - CONFIDENT, "bound": READABLE_AT,
           "contexts": {}}
    for ctx in contexts:
        framing, presentation = ctx.split("/")
        compute = presentation == "compute"
        reader = compute and test == D.TEST
        nc, ng = shape(test, framing)
        free = within(lo["choice"], N_CALLS) ** nc * (within(lo["reader"], PROBE_CALLS, READER_PROBE_AT) ** nc
                                                      if reader else 1.0)
        v = {"conditions": nc, "guarded": ng if compute else 0, "void_free_at_the_bounds": round(free, 4),
             "start": free >= READABLE_AT}
        if rate["choice"] is not None and (not compute or rate["guard"] is not None):
            guard = within(rate["guard"], PROBE_CALLS) ** ng if compute else 1.0
            v["guard_measured"] = round(guard, 4)
            v["read_whole"] = round(within(rate["choice"], N_CALLS) ** nc * guard, 4)
        else:
            v["why"] = "no call of this kind made yet under the frozen files in force: nothing to stop on"
        out["contexts"][ctx] = v
    return out
