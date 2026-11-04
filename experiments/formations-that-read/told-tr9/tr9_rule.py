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

import tr9_design as D          # puts freeze 1's told/ on the path
import rule                     # noqa: E402  freeze 1's
from conditions import PROBE_CALLS   # noqa: E402

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
