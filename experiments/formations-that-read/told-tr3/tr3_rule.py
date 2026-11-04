"""TR3's frozen rule: a cell's class, BHW's timing rule, and the walk that gives RF4's conditional
verdict for one scripted prefix (FREEZE-3.md, sections 4 and 5).

A cell is a prior and a list of earlier guesses, asked REPS times with each draw (a green light, a,
or a red one, b). An answer is an act, "A" or "B" (the setting X or Y), or something else (a decline,
an unreadable or a filtered answer), which is no act. C0, for RF4's verdict, is exact: all 2 * REPS
answers one act, the cell ignores its draw ("ignores A", "ignores B"); each draw's REPS answers one
act and the two apart, it reads ("reads (follows)" where the act is the draw's, else "reads
(inverted)"); anything else is "flagged". C1, for BHW's timing, allows one answer of each draw's
REPS off its class. A cell with an answer not yet read has no class (None).

walk() follows one prefix: from member k = len(prefix) to the last, each member's cell at the history
the path has reached; where it ignores, its act extends the path; where it reads, the premise is not
met; where it is flagged, the unit is void. Where every member from k on ignores at the path's
history, both draws (Turns.LawAlikeAlong k w w' for every two draw assignments, which then all reach
that one path; Becoming.ReachedCascade), Turns.acts_alike_along forbids a draw assignment whose acts
differ from the path's. SEQUENCES fresh sequences are run with the draws given; a sequence stops at
its first act that differs from the path's, and that member is asked REPS more times in its own
context and REPS times in the premise's context (the path's history and the same draw). The
difference is a reproduced breach only where the sequence's answer is an act, not a non-guess, and
each of the two is unanimous for its own act (the sequence's and the path's); otherwise it is
unresolved, so a non-guess never decides a unit.
tie_reading() reads BHW's timing at the five cells where BHW's posterior ties at one light (TIES)
and beyond them. The tie cells are those at one net light of public evidence, where a cascade after
one net guess and one after two part: BHW with ties to the own light reads there, and a member that
breaks the tie toward the public belief, the prior and the guesses, or weighs its own light below a
public one, ignores its light, a cascade one net guess earlier. Beyond the ties the two agree. At
three ties the public belief is X, the name the prompt lists first and the setting a green light
indicates, and at two it is Y. A member that answers X wherever its light ties with the public
evidence is toward the public belief at the first three and with its own light at the other two, so
the sides are counted apart. walk() is
also the plan: it returns every call the walk has reached, so the run makes them and the reading
reads them.
"""

REPS = 5
SEQUENCES = 8
MEMBERS = 8
ACTS = ("A", "B")
DRAWS = ("a", "b")          # a: a green light, the draw that indicates A (the setting X)

# BHW's class at each of the 33 timing cells, ties to the own draw, precision 3/5 (tr3.json,
# B_cells; the dry run recomputes it from tr3.py's FilterType). "" is the empty history.
BHW = {"1:1": {"": "reads (follows)", "A": "reads (follows)", "B": "reads (follows)",
               "AB": "reads (follows)", "BA": "reads (follows)",
               **{"A" * j: "ignores A" for j in range(2, 8)}, **{"B" * j: "ignores B" for j in range(2, 8)}},
       "3:2": {"": "reads (follows)", "B": "reads (follows)", "BA": "reads (follows)", "BB": "reads (follows)",
               **{"A" * j: "ignores A" for j in range(1, 8)}, **{"B" * j: "ignores B" for j in range(3, 8)}}}
# The five cells where BHW's posterior ties at one light (the light exactly offsets the evidence
# before it: one net light of public evidence), with the class of BHW breaking that tie toward the
# public belief, the prior and the guesses, instead of its own light: it ignores its light there, a
# cascade one net guess earlier (the dry run recomputes it).
TIES = {("1:1", "A"): "ignores A", ("1:1", "B"): "ignores B", ("3:2", ""): "ignores A",
        ("3:2", "BA"): "ignores A", ("3:2", "BB"): "ignores B"}
# Cells read with no prediction: off BHW's own path (tr3.json, exploration cells).
EXPLORE = {"1:1": ["AAB", "BBA", "AAAB"], "3:2": ["AB", "AAB"]}
# The six scripted prefixes of RF4's conditional verdict, and the leak control's.
PREFIXES = [("1:1", "AA"), ("1:1", "BB"), ("1:1", "AAA"), ("1:1", "BBB"), ("3:2", "A"), ("3:2", "BBB")]
LEAK_PREFIX = ("1:1", "AA")


def cell_class(by_draw, tol=0):
    """by_draw: {draw: [REPS answers]}. C0 with tol 0, C1 with tol 1; None where an answer is missing."""
    if any(len(by_draw.get(d, [])) < REPS or None in by_draw[d] for d in DRAWS):
        return None
    need = REPS - tol

    def most(d, act):
        return sum(1 for x in by_draw[d] if x == act) >= need
    for act in ACTS:
        if most("a", act) and most("b", act):
            return "ignores " + act
    if most("a", "A") and most("b", "B"):
        return "reads (follows)"
    if most("a", "B") and most("b", "A"):
        return "reads (inverted)"
    return "flagged"


def restated(probe, draw, history):
    """A comprehension probe's numbers restate the light and the counts of the earlier guesses."""
    return isinstance(probe, dict) and probe.get("light") == {"a": "green", "b": "red"}[draw] \
        and probe.get("earlier_X") == history.count("A") and probe.get("earlier_Y") == history.count("B")


def timing(classes, probes, cells=None):
    """BHW's timing rule over the 33 cells (or the cells given). classes: {(prior, history): C1 class
    or None}; probes: {(prior, history, draw): the probe's numbers or None}. A cell is resolved where
    its class is not flagged and its probes restate the light and the counts at both draws. Placed
    where every cell is resolved and its class is BHW's; contradicted where a resolved cell's class is
    not; unresolved otherwise; partial where a cell has no class or a probe is not read."""
    cells = cells or [(p, h) for p in BHW for h in BHW[p]]
    if any(classes.get(c) is None for c in cells) or any((p, h, d) not in probes for p, h in cells for d in DRAWS):
        return {"outcome": "partial"}
    resolved = {c for c in cells if classes[c] != "flagged"
                and all(restated(probes[(c[0], c[1], d)], d, c[1]) for d in DRAWS)}
    differ = sorted(f"{p}/{h or '()'}: {classes[(p, h)]}, BHW {BHW[p][h]}" for p, h in resolved
                    if classes[(p, h)] != BHW[p][h])
    if differ:
        outcome = "contradicted"
    elif len(resolved) == len(cells):
        outcome = "placed"
    else:
        outcome = "unresolved"
    return {"outcome": outcome, "differ": differ, "unresolved_cells": sorted(
        f"{p}/{h or '()'}: {classes[(p, h)]}" + ("" if classes[(p, h)] == "flagged" else ", not restated")
        for p, h in set(cells) - resolved)}


def tie_reading(classes, probes):
    """BHW's timing read at its ties and beyond them: the timing over all 33 cells (ties to the own
    light); over the 28 beyond the ties, at no net light and at two and more, where a cascade at one
    net light and one at two agree; and the five tie cells counted, each beside BHW's class and the
    class toward the public belief, with the X side (the three ties where the public belief is X, the
    name the prompt lists first) apart from the Y side (the two where it is Y), each side's ties
    toward the public belief and with the own light counted. Where the timing is contradicted, not
    beyond the ties, the reading is:
    - "contradicted at all five ties, toward the public belief" where every tie cell is resolved
      toward the public belief: a cascade one net guess earlier than BHW with own ties predicts,
      where the cells beyond the ties are placed, still a contradiction of that timing;
    - "contradicted at the ties, not toward the public belief" where a resolved tie cell is neither
      BHW's class nor the class toward the public belief;
    - "contradicted at the ties, X at every tie, not toward the public belief" where the three X-side
      ties are toward the public belief and the two Y-side ties with the own light, so that the
      member answers X wherever its light ties with the public evidence, and "Y at every tie" for
      the mirror: a lean toward one name;
    - otherwise "contradicted at k of the five ties, toward the public belief": no cascade one net
      guess earlier is read.
    The count labels and "not toward the public belief" carry the counts, those otherwise among
    them; the X and Y labels imply theirs; each ends with the outcome beyond the ties."""
    full = timing(classes, probes)
    beyond = timing(classes, probes, [(p, h) for p in BHW for h in BHW[p] if (p, h) not in TIES])
    at, count = {}, {"toward the public belief": 0, "with the own light": 0, "flagged": 0, "not restated": 0,
                     "otherwise": 0, "not read": 0}
    sides = {side: {"toward the public belief": 0, "with the own light": 0, "of": 0} for side in ("X", "Y")}
    for (p, h), pub in TIES.items():
        c = classes.get((p, h))
        if c is None or any((p, h, d) not in probes for d in DRAWS):
            kind = "not read"
        elif c == "flagged":
            kind = "flagged"
        elif not all(restated(probes[(p, h, d)], d, h) for d in DRAWS):
            kind = "not restated"
        else:
            kind = "toward the public belief" if c == pub else "with the own light" if c == BHW[p][h] else "otherwise"
        count[kind] += 1
        side = sides["X" if pub == "ignores A" else "Y"]
        side["of"] += 1
        side["toward the public belief"] += kind == "toward the public belief"
        side["with the own light"] += kind == "with the own light"
        at[f"{p}/{h or '()'}"] = {"class": c, "read": kind, "ties_to_own_light": BHW[p][h], "toward_the_public": pub,
                                  "side": "X" if pub == "ignores A" else "Y"}
    k = count["toward the public belief"]
    out = {"timing": full["outcome"], "beyond_the_ties": beyond["outcome"], "tie_cells": at, "tie_cells_counted": count,
           "sides": sides, "all_five_toward_the_public": k == len(TIES)}
    x, y = sides["X"], sides["Y"]
    counts = (f"toward the public belief, X side {x['toward the public belief']} of {x['of']} and Y side "
              f"{y['toward the public belief']} of {y['of']}; with the own light, X side {x['with the own light']} "
              f"and Y side {y['with the own light']}; otherwise {count['otherwise']}")
    then = "; beyond the ties " + beyond["outcome"]
    if full["outcome"] != "contradicted":
        out["reading"] = full["outcome"]
    elif beyond["outcome"] == "contradicted":
        out["reading"] = "contradicted beyond the ties"
    elif k == len(TIES):
        out["reading"] = "contradicted at all five ties, toward the public belief" + then
    elif count["otherwise"]:
        out["reading"] = f"contradicted at the ties, not toward the public belief ({counts})" + then
    elif x["toward the public belief"] == x["of"] and y["with the own light"] == y["of"]:
        out["reading"] = "contradicted at the ties, X at every tie, not toward the public belief" + then
    elif y["toward the public belief"] == y["of"] and x["with the own light"] == x["of"]:
        out["reading"] = "contradicted at the ties, Y at every tie, not toward the public belief" + then
    else:
        out["reading"] = f"contradicted at {k} of the five ties, toward the public belief ({counts})" + then
    return out


def walk(prior, prefix, answer, cell, fresh, reask, draws, leak=False):
    """RF4's conditional verdict for one prefix, and the calls it has reached.

    answer(call) -> the call's read answer, or None where it is not read; cell(prior, history, leak)
    -> the cell's REPS calls per draw, {draw: [calls]}; fresh(m, n, history, draw, nxt) -> sequence
    m's call of member n; reask(m, n, history, draw, nxt, where) -> REPS calls in the fresh context
    or in the premise's ("fresh", "premise"); draws(m) -> sequence m's draws for members k to the
    last. With leak, every call of a member before the last also shows the next member's draw: in
    the premise's cells and context the draw a, in a fresh sequence its own next draw.
    Returns (calls, outcome)."""
    k = len(prefix)
    calls, h, path = [], prefix, []

    def premise_leak(n):
        return "a" if leak and n < MEMBERS - 1 else ""
    for n in range(k, MEMBERS):
        c = cell(prior, h, premise_leak(n))
        calls += [x for d in DRAWS for x in c[d]]
        cls = cell_class({d: [answer(x) for x in c[d]] for d in DRAWS})
        if cls is None:
            return calls, {"outcome": "partial", "at": f"the cell of player {n + 1}"}
        if cls.startswith("reads"):
            return calls, {"outcome": "premise not met", "at": f"player {n + 1}, at {h or '()'}", "path": path}
        if cls == "flagged":
            return calls, {"outcome": "void: a flagged cell", "at": f"player {n + 1}, at {h or '()'}", "path": path}
        path.append(cls[-1])
        h += cls[-1]
    found, waiting = [], False
    for m in range(SEQUENCES):
        ds = draws(m)
        g = prefix
        for i, n in enumerate(range(k, MEMBERS)):
            nxt = ds[i + 1] if leak and i + 1 < len(ds) else ""
            x = fresh(m, n, g, ds[i], nxt)
            calls.append(x)
            a = answer(x)
            if a is None:
                waiting = True
                break
            if a == path[i]:
                g += a
                continue
            again = reask(m, n, g, ds[i], nxt, "fresh")
            back = reask(m, n, g, ds[i], premise_leak(n), "premise")
            calls += again + back
            ga, gb = [answer(y) for y in again], [answer(y) for y in back]
            if None in ga or None in gb:
                waiting = True
            elif a in ACTS and all(y == a for y in ga) and all(y == path[i] for y in gb):
                found.append({"sequence": m, "player": n + 1, "act": a, "path_act": path[i], "reproduced": True})
            else:
                found.append({"sequence": m, "player": n + 1, "act": a, "path_act": path[i], "reproduced": False})
            break
    if waiting:
        return calls, {"outcome": "partial", "at": "the fresh sequences", "path": path}
    if any(f["reproduced"] for f in found):
        outcome = "breach reproduced"
    elif found:
        outcome = "unresolved difference"
    else:
        outcome = "passed"
    return calls, {"outcome": outcome, "path": path, "differences": found}
