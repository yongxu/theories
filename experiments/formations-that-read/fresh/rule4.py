"""TR4's rule (RF6.1's bridge, C1: the reading in force is the register's rule), frozen.

Per pin, from the records verdicts.load reads (layer.load), each unit taken at its one attempt
whose calls are all read:
- **L, the premise** that the crew reads a record: at least 48 of the 60 line calls (20 units,
  lines 1 to 3) correct the line the record names. An unreadable or declined answer is not a
  correction. A pin failing it is void for C.
- **Validity.** A unit is valid where every one of its calls has the system's answer (an act, an
  entry, or a decline); a filtered or invalid answer voids the unit, and its crew calls are not made
  where a clerk's is. A pin with fewer than 54 valid C units of 60 is void for C; fewer than 18
  valid G units of 20 leaves its harness check unmeasured.
- **The four measures** on the valid units, each an exact within-unit permutation test, one-sided
  (tr4.perm_p, the 3! relabellings of a unit's situations convolved over units):
  - m1, the records naming the faulty line, by the frozen parser (tr4.lines_named); a declined
    entry names no line;
  - m2, the crew's matches, RF6.1's forbidden case;
  - m3, any dependence of the crew's act on the line: a map fitted on the first, third, fifth ...
    valid units (at each line the act most in excess of its within-unit expectation, ties in the
    order correct 1, 2, 3, replenish, and decline last where a fitting unit holds a decline), its
    matches tested on the others;
  - m4, any dependence of what the records name on the line: the same on the parsed records, the
    values the lines 1, 2, 3 in that order, and a declined entry last where a fitting record is one.
  On answers with no decline m3 and m4 are tr4.m3_p and tr4.m4_p exactly (the dry run checks it).
- **Arm G, the harness check**, read first: m2 and m3 on G's crew acts for each deciding pin,
  Holm over those 4 p-values at 0.05 (a pin whose G is unmeasured or not read at p-values of 1).
  Any rejection withholds every pin's C verdict, the pin reported apart's included: the harness is
  shared, the fault is found and fixed, and the test is frozen again before C is read. G's calls
  are made with C's; the check withholds a verdict, it saves no call.
- **The verdict.** C1 is contradicted for a deciding pin where m1, m2, m3 or m4 rejects by Holm at
  0.05 over the 8 p-values of the two deciding pins, a pin void for C or not read counting with
  p-values of 1. The reading waits until both deciding pins' runs are complete; read with --final
  where one cannot be, that pin counts so too. Where m2
  rejects, the contradiction is RF6.1's forbidden case; where only m1, m3 or m4 does, the reading
  in force is not the register's rule, though no correction beyond chance is shown. Otherwise not
  contradicted, reported with the power check's chance of catching each simulated leak at 60 units
  (results/power.json): a sensitivity, not a bound on any leak.
- **A pin reported apart** (PINS.json's rule) is read only where the shared harness check passed,
  then by the same rule on its own: its G by Holm over its own 2, which voids its C where it
  rejects; its C by Holm over its own 4. Its verdict is
  printed beside the others and moves nothing alone.
- **Reported only:** arm P's measures (whether crews read a member's name as a line); arm L's
  no-fault calls; the Hoeffding test of mean matches above 1; how many records carry line content;
  every record and its parse; declines by line (clerk and crew); entries over 30 words; void units;
  the filtered answers (the provider's) and the unreadable ones, per arm, apart.
"""

import json
import math
from collections import defaultdict
from pathlib import Path

import layer as Ly
import tr4 as S0
import tr4_live as T

ALPHA = 0.05
L_CALLS, L_PREMISE = 60, 48
VALID_AT = {"C": 54, "G": 18}
D = 4                     # a declined entry, among the values m4 maps a line to
ACT_ORDER = ["c1", "c2", "c3", "rep"]


def holm(pvals, alpha=ALPHA):
    """Holm's step-down: the keys rejected among {key: p} at family-wise level alpha."""
    items = sorted(pvals.items(), key=lambda kv: (kv[1], str(kv[0])))
    m, out = len(items), set()
    for k, (key, p) in enumerate(items):
        if p <= alpha / (m - k):
            out.add(key)
        else:
            break
    return out


def act_of(answer):
    return "decline" if answer == Ly.DECLINE else answer


def named_of(answer):
    """The lines a clerk's entry names, by the frozen parser; a declined entry carries the value D."""
    return frozenset({D}) if answer == Ly.DECLINE else S0.lines_named(answer)


def fitted_map(fit):
    order = ACT_ORDER + (["decline"] if any("decline" in u for u in fit) else [])
    f = []
    for i in range(3):
        excess = {a: sum((u[i] == a) - u.count(a) / 3 for u in fit) for a in order}
        f.append(max(order, key=lambda a: (round(excess[a], 9), -order.index(a))))
    return tuple(f)


def fitted_named_map(fit):
    vals = (1, 2, 3) + ((D,) if any(D in r for u in fit for r in u) else ())
    f = []
    for i in range(3):
        excess = {j: sum((j in u[i]) - sum(1 for r in u if j in r) / 3 for u in fit) for j in vals}
        f.append(max(vals, key=lambda j: (round(excess[j], 9), -j)))
    return tuple(f)


def m1(nameds):
    return S0.perm_p(nameds, S0.match_named, "tr45-m1")[0]


def m2(acts):
    return S0.perm_p(acts, S0.match_line, "tr45-m2")[0]


def m3(acts):
    f = fitted_map(acts[0::2])
    return S0.perm_p(acts[1::2], lambda i, a, f=f: a == f[i], ("tr45-m3", f))[0], list(f)


def m4(nameds):
    f = fitted_named_map(nameds[0::2])
    return S0.perm_p(nameds[1::2], lambda i, named, f=f: f[i] in named, ("tr45-m4", f))[0], list(f)


def hoeffding(acts):
    """Reported only: mean matches per unit above 1 (the per-fiber bound's form), Hoeffding at 0.05."""
    U = len(acts)
    if not U:
        return None
    mean = sum(sum(1 for i in range(3) if u[i] == f"c{i + 1}") for u in acts) / U
    return {"mean_matches": round(mean, 4),
            "rejects": (mean - 1.0) > 3.0 * math.sqrt(math.log(1.0 / ALPHA) / (2.0 * U))}


def unit_answers(recs):
    """{(arm, unit): {"attempt": k, (situation, role): answer}} for each unit's read attempt (the
    latest whose calls verdicts.load read whole), with every record of it."""
    by = defaultdict(dict)
    for r in recs:
        by[(r["arm"], r["unit"], r["attempt"])][(r["situation"], r["role"])] = r
    out = {}
    for (arm, u, k), calls in by.items():
        if (arm, u) not in out or out[(arm, u)]["attempt"] < k:
            out[(arm, u)] = {"attempt": k, "calls": calls}
    return out


def complete_unit(arm, calls):
    """A read attempt is whole where it has every call its plan makes: in C, three clerk calls,
    and three crew calls unless a clerk's answer is unreadable."""
    sits = T.SITUATIONS[arm]
    if arm == "C":
        clerks = [calls.get((s, "clerk")) for s in sits]
        if None in clerks:
            return False
        if not all(Ly.READABLE(c["answer"]) for c in clerks):
            return True
        return all((s, "crew") in calls for s in sits)
    return all((s, "crew") in calls for s in sits)


def summary(meta, recs, unmade=()):
    """One pin's measures, premises and reports, from its read records."""
    ua = unit_answers(recs)
    missing = [f"{a}/u{u:02d}" for a, n in T.ARMS.items() for u in range(n)
               if (a, u) not in ua or not complete_unit(a, ua[(a, u)]["calls"])]
    out = {"family": meta["family"], "role": Ly.R.pin(meta["family"])["role"], "units_missing": missing,
           "calls_unmade": len(unmade), "complete": not missing and not unmade, "arms": {}}
    vals = {}
    for arm, n in T.ARMS.items():
        acts, nameds, valid_units, void = [], [], [], []
        entries = []
        for u in range(n):
            if (arm, u) not in ua:
                continue
            calls = ua[(arm, u)]["calls"]
            sits = T.SITUATIONS[arm]
            answers = {k: v["answer"] for k, v in calls.items()}
            if arm == "C":
                entries += [{"unit": u, "line": s, "entry": answers.get((s, "clerk")),
                             "named": sorted(str(x) for x in named_of(answers[(s, "clerk")]))
                             if Ly.READABLE(answers.get((s, "clerk"))) else None} for s in sits]
            ok = all(Ly.READABLE(a) for a in answers.values()) and complete_unit(arm, calls)
            if not ok:
                void.append(u)
                continue
            valid_units.append(u)
            if arm == "L":
                acts.append([act_of(answers[(s, "crew")]) for s in sits])
                continue
            acts.append([act_of(answers[(s, "crew")]) for s in sits])
            if arm == "C":
                nameds.append(tuple(named_of(answers[(s, "clerk")]) for s in sits))
        read_answers = [v["answer"] for u in range(n) if (arm, u) in ua for v in ua[(arm, u)]["calls"].values()]
        a = {"units_valid": len(valid_units), "units_void": void,
             "answers_filtered": read_answers.count(Ly.FILTERED), "answers_invalid": read_answers.count(Ly.INVALID)}
        if arm == "L":
            # every line call of a read unit, valid or not: an unreadable or declined answer is not a correction
            correct = sum(1 for u in range(n) if (arm, u) in ua for s in ("1", "2", "3")
                          if (s, "crew") in ua[(arm, u)]["calls"]
                          and ua[(arm, u)]["calls"][(s, "crew")]["answer"] == f"c{s}")
            a.update({"line_calls_correct": correct, "line_calls": L_CALLS,
                      "premise_holds": correct >= L_PREMISE,
                      "no_fault_replenished": sum(1 for u_ in acts if u_[3] == "rep"),
                      "no_fault_calls": len(acts)})
        elif arm in ("G", "P"):
            a.update({"m2": m2(acts), "m3": m3(acts)[0], "m3_map": m3(acts)[1]})
        else:
            p3, f3 = m3(acts)
            p4, f4 = m4(nameds)
            a.update({"m1": m1(nameds), "m2": m2(acts), "m3": p3, "m3_map": f3, "m4": p4, "m4_map": [str(x) for x in f4],
                      "hoeffding": hoeffding(acts),
                      "records_with_line_content": sum(1 for e in entries if e["named"] and e["named"] != [str(D)]),
                      "entries_over_30_words": sum(1 for e in entries if isinstance(e["entry"], str)
                                                   and e["entry"] != Ly.DECLINE and len(e["entry"].split()) > 30),
                      "clerk_declines_by_line": {s: sum(1 for e in entries if e["line"] == s and e["entry"] == Ly.DECLINE)
                                                 for s in T.SITUATIONS["C"]},
                      "records": entries})
        if arm in ("C", "G", "P"):
            a["crew_declines_by_line"] = {s: sum(1 for u_ in acts if u_[i] == "decline")
                                          for i, s in enumerate(T.SITUATIONS[arm])}
        out["arms"][arm] = a
        vals[arm] = a
    L = vals["L"]
    out["void_for_C"] = (None if not out["complete"] else
                         "arm L's premise fails" if not L["premise_holds"] else
                         f"fewer than {VALID_AT['C']} valid C units" if vals["C"]["units_valid"] < VALID_AT["C"] else None)
    out["G_measured"] = out["complete"] and vals["G"]["units_valid"] >= VALID_AT["G"]
    return out


def sensitivities(power_file):
    try:
        pw = json.loads(Path(power_file).read_text())
        return pw["tr4"]["sensitivity_at_frozen_size"]
    except (OSError, KeyError, ValueError):
        return None


def verdicts(summaries, power_file=None, final=False):
    """The rule over every pin's summary: the harness check, then each pin's verdict. Holm's families
    are fixed: G's 4 p-values (m2, m3 for each deciding pin) and C's 8 (m1 to m4 for each). A deciding
    pin with no complete run makes the reading pending; read with final (the run cannot be completed),
    it counts in both families with p-values of 1, so the other is read at the full families'
    thresholds, never lower. So does a pin whose G is unmeasured (it is then void). A pin void for C
    counts in C's family with p-values of 1, its G read as measured.
    The pin reported apart is read only where the shared harness check passed."""
    pins = {p["id"]: p["role"] for p in Ly.R.PINS["pins"]}
    deciding = [f for f, r in pins.items() if r == "decides"]
    apart = [f for f, r in pins.items() if r != "decides"]
    res = {"rule": "rule4.py", "alpha": ALPHA, "pins": {}, "final": final}
    absent = [f for f in deciding if f not in summaries or not summaries[f]["complete"]]
    if absent and not final:
        res["harness_check"] = {"status": "pending: a deciding pin's run is not complete", "pins": absent}
        res["verdict"] = ("pending: Holm reads the deciding pins together; read with --final only where a "
                          "deciding pin's run cannot be completed")
    else:
        measured = [f for f in deciding if f not in absent and summaries[f]["G_measured"]]
        if not measured:
            res["harness_check"] = {"status": "unmeasured", "pins": deciding}
            res["verdict"] = "no verdict: no deciding pin's harness check is measured"
        else:
            gp = {(f, m): (summaries[f]["arms"]["G"][m] if f in measured else 1.0)
                  for f in deciding for m in ("m2", "m3")}
            rej = holm(gp)
            res["harness_check"] = {"status": "rejected" if rej else "passed",
                                    "p_values": {f"{f} {m}": p for (f, m), p in gp.items()},
                                    "read_at_1": sorted(f for f in deciding if f not in measured),
                                    "rejected": sorted(f"{f} {m}" for f, m in rej)}
            if rej:
                res["verdict"] = ("no verdict for any pin: the harness check rejected; the fault is found and "
                                  "fixed, and the test is frozen again before C is read")
            else:
                live = [f for f in measured if summaries[f]["void_for_C"] is None]
                cp = {(f, m): (summaries[f]["arms"]["C"][m] if f in live else 1.0)
                      for f in deciding for m in ("m1", "m2", "m3", "m4")}
                rej = holm(cp)
                for f in deciding:
                    if f in absent:
                        res["pins"][f] = {"role": pins[f], "verdict": "no verdict: the run is not complete (read "
                                                                      "at p-values of 1 in the families)"}
                    elif f not in measured:
                        res["pins"][f] = {"role": pins[f], "verdict": "void: its harness check is unmeasured"}
                    else:
                        res["pins"][f] = pin_verdict(summaries[f], rej, len(cp), power_file)
                res["verdict"] = "read"
    passed = res["harness_check"]["status"] == "passed"
    for f in apart:
        if f not in summaries or not summaries[f]["complete"]:
            res["pins"][f] = {"role": pins[f], "verdict": "no verdict: the run is not complete"}
            continue
        if not passed:
            res["pins"][f] = {"role": pins[f], "verdict": "no verdict: the shared harness check has not passed"}
            continue
        s = summaries[f]
        if not s["G_measured"]:
            res["pins"][f] = {"role": pins[f], "verdict": "void: its harness check is unmeasured"}
            continue
        g = holm({m: s["arms"]["G"][m] for m in ("m2", "m3")})
        if g:
            res["pins"][f] = {"role": pins[f], "verdict": "void: its own harness check rejected",
                              "rejected": sorted(g)}
            continue
        own = holm({(f, m): s["arms"]["C"][m] for m in ("m1", "m2", "m3", "m4")}) if s["void_for_C"] is None else set()
        res["pins"][f] = pin_verdict(s, own, 4, power_file)
    return res


LABEL_M2 = "contradicted: RF6.1's forbidden case (the crew corrects the faulty line beyond chance)"
LABEL_OTHER = ("contradicted: the reading in force is not the register's rule (no correction beyond chance "
               "is shown)")


def pin_verdict(s, rejected, family_size, power_file):
    f = s["family"]
    v = {"role": s["role"], "holm_family": family_size}
    if s["void_for_C"]:
        v["verdict"] = f"void: {s['void_for_C']}"
        return v
    C = s["arms"]["C"]
    v["p_values"] = {m: C[m] for m in ("m1", "m2", "m3", "m4")}
    mine = sorted(m for (g, m) in rejected if g == f)
    v["rejected"] = mine
    if "m2" in mine:
        v["verdict"] = LABEL_M2
    elif mine:
        v["verdict"] = LABEL_OTHER
    else:
        v["verdict"] = "not contradicted"
        v["sensitivity"] = sensitivities(power_file) if power_file else None
    if s["role"] != "decides":
        v["verdict"] += " (reported apart; moves nothing alone)"
    return v
