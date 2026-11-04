"""TR1's rule (FREEZE-5.md, section 4): each condition's verdict from its answers, and the pin's reading.

The rule is Stage 0's (REST-TR1, sections 3 and 6; tr1.py): a presentation's pick is strict where one
content is named in at least Q of its R_CALLS calls and is the unique top (tr1.strict_rule; "no
preference", a decline, a filtered and an unreadable answer count against it). A condition is void
where its strict presentations are fewer than half, or where its strict menus admit no cycle at all
(the occasion-content incidence graph is a forest); otherwise contradicted by a cycle of any length
among its strict occasions on the content carrier, and passed otherwise (tr1.verdict). P1, the
predictive part, is not read where the condition is void, where the met strict picks show a cycle, or
where fewer than P1_MIN strict after-presentations are P1-testable. measures() computes what
tr1.simulate computes from the same answers, and the dry run checks the two agree.

The guard (REST-TR1, section 6): T's verdict is read only where K passes. A contradicted or void K
marks the pipeline or the task as failed for that pin, and T is reported, not ruled on. A pass is
reported as "no cycle among N strict occasions" with the first-listed share, the content-with-position
family, the forced condition and the history condition beside it, never as which order the pin
carries; a contradiction with its shortest cycle. A pin of the theory's own family decides nothing
alone (freeze 1's PINS.json).
"""

from collections import deque
from fractions import Fraction

import tr1_design as D
import tr1

DESIGN, R_CALLS, Q = D.DESIGN, D.R_CALLS, D.Q
VOID_STRICT_SHARE, P1_MIN = tr1.VOID_STRICT_SHARE, tr1.P1_MIN
assert (VOID_STRICT_SHARE, P1_MIN) == (Fraction(1, 2), 10), "Stage 0's void floor and P1's minimum"


def stage0_answer(a):
    """An answer as tr1.strict_rule reads it: a content index, None for "no preference", -1 for any
    other answer that names no open content (a decline, a filtered or an unreadable one)."""
    if isinstance(a, int) and not isinstance(a, bool):
        return a
    return None if a == D.NONE else -1


def strict_picks(answers):
    """{presentation: its strict pick} from {presentation: its answers}, by tr1.strict_rule at Q."""
    out = {}
    for p, xs in answers.items():
        s = tr1.strict_rule([stage0_answer(a) for a in xs], Q)
        if s is not None:
            out[p] = s
    return out


def shortest_cycle(strict):
    """A shortest cycle among the strict occasions on the content carrier, as the steps (x, y, p): the
    presentation p picked x while y was open. None where there is none."""
    n = DESIGN.n
    edge = {}
    for p, s in sorted(strict.items()):
        for c in DESIGN.pres[p]:
            if c != s:
                edge.setdefault((s, c), p)
    best = None
    for start in range(n):
        prev, seen, q = {}, {start}, deque([start])
        while q:
            u = q.popleft()
            for v in range(n):
                if (u, v) not in edge:
                    continue
                if v == start:
                    path, w = [(u, v)], u
                    while w != start:
                        path.append((prev[w], w))
                        w = prev[w]
                    path.reverse()
                    if best is None or len(path) < len(best):
                        best = path
                    q.clear()
                    break
                if v not in seen:
                    seen.add(v)
                    prev[v] = u
                    q.append(v)
    return None if best is None else [[x, y, edge[(x, y)]] for x, y in best]


def measures(answers):
    """What tr1.simulate computes from a condition's answers ({presentation: answers}): the strict
    count, a cycle on contents (C), on contents with position, P1 and its testable count, whether the
    strict menus admit a cycle, and the first-listed share of strict pair picks; with the shortest
    cycle and the first-listed share of all strict picks."""
    n, P = DESIGN.n, len(DESIGN.pres)
    strict = strict_picks(answers)
    rows = [0] * n
    for p, s in strict.items():
        rows[s] |= DESIGN.menus[p] & ~(1 << s)
    res = {"strict": len(strict), "presentations": P, "C": not tr1.no_cycle(rows)}
    K = max(DESIGN.size)
    prow = [0] * (n * K)
    for p, s in strict.items():
        alt = {c: c * K + j for j, c in enumerate(DESIGN.pres[p])}
        prow[alt[s]] |= sum(1 << alt[c] for c in DESIGN.pres[p] if c != s)
    res["C_content_with_position"] = not tr1.no_cycle(prow)
    mrows = [0] * n
    for p, s in strict.items():
        if DESIGN.met[p]:
            mrows[s] |= DESIGN.menus[p] & ~(1 << s)
    mreach = tr1.closure(mrows)
    if any(mreach[x] >> x & 1 for x in range(n)):
        res["P1"], res["P1_testable"] = None, 0
    else:
        col = [sum(1 << x for x in range(n) if mreach[x] >> y & 1) for y in range(n)]
        viol, testable = False, 0
        for p, s in strict.items():
            if DESIGN.met[p]:
                continue
            M = DESIGN.menus[p]
            testable += any(mreach[x] & M & ~(1 << x) for x in DESIGN.pres[p])
            viol = viol or bool((M & ~(1 << s)) & col[s])
        res["P1"], res["P1_testable"] = viol, testable
    parent = list(range(n + P))

    def find(a):
        while parent[a] != a:
            parent[a] = parent[parent[a]]
            a = parent[a]
        return a
    possible = False
    for p in sorted(strict):
        for c in DESIGN.pres[p]:
            a, b = find(n + p), find(c)
            if a == b:
                possible = True
            else:
                parent[a] = b
    res["cycle_possible"] = possible
    fp = [DESIGN.pres[p][0] == s for p, s in strict.items() if DESIGN.size[p] == 2]
    res["first_share_pairs"] = sum(fp) / len(fp) if fp else None
    fa = [DESIGN.pres[p][0] == s for p, s in strict.items()]
    res["first_share_all"] = round(sum(fa) / len(fa), 4) if fa else None
    res["shortest_cycle"] = shortest_cycle(strict) if res["C"] else None
    return res


def condition_verdict(cond, answers):
    """One condition's verdict ({presentation: its R_CALLS answers}, every presentation read whole),
    by tr1.verdict on measures(); with the counts of each kind of answer."""
    assert set(answers) == set(range(len(DESIGN.pres))) and all(len(v) == R_CALLS for v in answers.values())
    m = measures(answers)
    outcome, p1 = tr1.verdict(m)
    kinds = {}
    for xs in answers.values():
        for a in xs:
            k = "a content" if isinstance(a, int) and not isinstance(a, bool) else str(a)
            kinds[k] = kinds.get(k, 0) + 1
    why = None
    if outcome == "void":
        why = ("fewer strict presentations than half" if Fraction(m["strict"], m["presentations"]) < VOID_STRICT_SHARE
               else "the strict menus admit no cycle")
    out = {"outcome": outcome, "why": why, "P1": p1, "strict": m["strict"], "presentations": m["presentations"],
           "strict_share": round(m["strict"] / m["presentations"], 4), "P1_testable": m["P1_testable"],
           "first_listed_share_of_strict_pair_picks": None if m["first_share_pairs"] is None
           else round(m["first_share_pairs"], 4),
           "first_listed_share_of_strict_picks": m["first_share_all"],
           "content_with_position_family": "a cycle" if m["C_content_with_position"] else "no cycle",
           "shortest_cycle": m["shortest_cycle"], "answers": dict(sorted(kinds.items()))}
    if cond == "F":
        out["none_where_not_offered"] = kinds.get(D.NONE, 0)
    return out


def pin_reading(family, verdicts, role):
    """The pin's reading from its conditions' verdicts ({condition: verdict, or None where the condition
    is not read whole}): T ruled on only where K passed, with the others beside it."""
    T, K = verdicts.get("T"), verdicts.get("K")
    if T is None:
        bridge, why = "no verdict", "T is not read whole"
    elif K is None:
        bridge, why = "not ruled on", "K, the guard, is not read whole"
    elif K["outcome"] != "passed":
        bridge, why = "not ruled on", f"K, the guard, is {K['outcome']}: the pipeline or the task failed for this pin"
    else:
        bridge, why = T["outcome"], None
    said = None
    if bridge == "passed":
        said = f"no cycle among {T['strict']} strict occasions, at the power of REST-TR1 section 4"
    elif bridge == "contradicted":
        said = f"a cycle among T's strict occasions: {T['shortest_cycle']}"
    elif bridge == "void":
        said = f"T is void: {T['why']}"
    beside = {c: (None if verdicts.get(c) is None else
                  {k: verdicts[c][k] for k in ("outcome", "why", "P1", "strict_share", "shortest_cycle",
                                               "first_listed_share_of_strict_pair_picks")})
              for c in ("F", "H")}
    if T is not None:
        beside["T"] = {k: T[k] for k in ("first_listed_share_of_strict_pair_picks", "first_listed_share_of_strict_picks",
                                         "content_with_position_family", "P1")}
    return {"family": family, "pin_role": role, "decides": role == "decides", "bridge": bridge, "why": why,
            "said": said, "beside": beside}


def expectations(readings):
    """The expectation FREEZE-5.md section 13 states before any call, as code: K passes on every pin
    whose K is read whole. None where no pin's K is read."""
    ks = {r["family"]: r["K"]["outcome"] for r in readings if r.get("K") is not None}
    return {"K passes on every pin read": (all(v == "passed" for v in ks.values()) if ks else None),
            "K's outcome by pin": ks}
