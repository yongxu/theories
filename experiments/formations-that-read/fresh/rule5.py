"""TR5's rule: V1 to V5 and the four outcomes per pin, read from the log through tr5_live.build.

The scoring is tr5.stage_b's, line for line, on the answers the log holds (the dry run checks that
the two agree on deterministic stand-ins). What the log adds, and stage_b has not:
- a decline is the system's answer, an act with no successor: it can be a history's modal act (a
  failing pair, not enabled), and an episode that declines sticks;
- an answer unreadable after its one reask, or filtered, agrees with no act; at an audited or
  listing history it counts against resolution, and an episode holding one is void: left out of
  V1 to V3 and listed, and the outcome cannot then be a pass;
- a run whose planned calls are not all made and read gives no outcome (partial), and says what
  is missing.
Outcomes per pin: void, where fewer than half the audited histories are resolved; contradicted,
where a rule is met; unresolved, where none is met and some history the modal acts reach, in the
audit or the listing arm, is unresolved, or an episode is void, or a listing resolved to a decline
(V4 and V5 read nothing there, so a pass would rest on a listing that states no reading); pass
otherwise. Where the whole audit is void, no episode is made: the outcome is void whatever they
show (stage_b's void stand-ins make none either). A pin reported
apart is ruled on the same way and labelled so; no pin's outcome bears on another's, and none
bears on RF3 (the bridges' verdicts, REST-TR4-TR5).
"""

import layer as Ly
import tr5 as S0
import tr5_live as T5

ALPHA = 0.05


def score(b):
    """Everything the rule reads, from one pin's build."""
    rows, order = b["rows"], b["order"]
    out = {"histories": len(rows), "resolved": sum(r["resolved"] for r in rows.values()),
           "audit_whole": b["audit_whole"], "listing_whole": b["listing_whole"], "oor_whole": b["oor_whole"],
           "episodes_whole": b["episodes_whole"]}
    out["complete"] = bool(rows) and all(r["resolved"] for r in rows.values())
    out["void"] = out["resolved"] < len(rows) / 2
    out["menu_order_read"] = [T5.hkey(h) for h in order if rows[h]["menu_order_read"]]
    out["unanimous"] = sum(r["unanimous"] for r in rows.values())
    out["any_failing_modal"] = any(r["why"] for r in rows.values())
    out["failing_pairs_tested"] = [T5.hkey(h) for h in b["failing"]]
    out["audit_prediction"] = {"failing_pairs": [[T5.hkey(h), rows[h]["modal"], rows[h]["why"]] for h in order
                                                 if rows[h]["why"]],
                               "keeps": not any(r["why"] == "unsafe" for r in rows.values()),
                               "goes_on": not any(r["why"] == "not enabled" for r in rows.values())}
    # V1 to V3 on the episodes
    v1_q, v1_departed, v1_eps, v1_realized, v1_first_form = [], 0, 0, 0, 0
    v2_contra = v2_any = 0
    n_plus = n_minus = 0
    void_eps = []
    for ci, c in enumerate(b["courses"]):
        fresh = [b["episodes"].get((ci, "fresh", e)) for e in range(T5.E_EP)]
        carried = [b["episodes"].get((ci, "carried", e)) for e in range(T5.E_EP)]
        void_eps += [f"{ci}/{m}/e{e}" for m, es in (("fresh", fresh), ("carried", carried))
                     for e, r in enumerate(es) if r is None or r["void"]]
        f_ok = [r for r in fresh if r is not None and not r["void"]]
        if c["kind"] == "V1":
            ok = [(not r["deviated"]) and (r["broke"] or r["stuck"]) for r in f_ok]
            v1_realized += sum(ok)
            v1_eps += len(f_ok)
            v1_departed += sum(r["deviated"] for r in f_ok)
            v1_first_form += len(f_ok) == T5.E_EP and sum(ok) <= 1
            v1_q += [1 - (1 - S0.P0) ** len(c["acts"])] * len(f_ok)
        else:
            if len(f_ok) == T5.E_EP:
                v2_contra += sum(r["broke"] or r["stuck"] for r in f_ok) == T5.E_EP
            v2_any += sum(r["broke"] or r["stuck"] for r in f_ok) > 0
        for f, k in zip(fresh, carried):
            if f is None or k is None or f["void"] or k["void"]:
                continue
            n_plus += k["deviated"] and not f["deviated"]
            n_minus += f["deviated"] and not k["deviated"]
    v1_p = S0.pb_tail(v1_q, v1_departed) if v1_q else 1.0
    v3_p = S0.sign_p(n_plus, n_minus)
    out.update({"courses": [{"kind": c["kind"], "acts": c["acts"]} for c in b["courses"]],
                "v1_p": v1_p, "v1_departed": v1_departed, "v1_episodes": v1_eps, "v1_realized": v1_realized,
                "v1_first_form": v1_first_form, "v2_courses": sum(c["kind"] == "V2" for c in b["courses"]),
                "v2_contradicted": v2_contra, "v2_courses_with_a_break": v2_any,
                "v3_carried_only": n_plus, "v3_fresh_only": n_minus, "v3_p": v3_p, "void_episodes": void_eps})
    # V4 and V5 on the listing arm's own tree
    lrows, lorder = b["lrows"], b["lorder"]
    rel = {"equal": 0, "wider": 0, "narrower": 0, "incomparable": 0, "empty": 0, "declined, no sides": 0}
    v4 = v5 = listed = changes = l_fail = 0
    for h in lorder:
        r = lrows[h]
        if not r["resolved"]:
            continue
        listed += 1
        sd, a = r["listing"], r["act"]
        Ps = S0.sides(S0.possible(h))
        l_fail += S0.unsafe_or_stuck(S0.possible(h), a) is not None
        if h in rows and rows[h]["resolved"] and rows[h]["modal"] != a:
            changes += 1
        if sd is None:            # a decline that lists no side states no reading: V4 and V5 read none
            rel["declined, no sides"] += 1
            continue
        if not sd:
            rel["empty"] += 1
        elif sd == Ps:
            rel["equal"] += 1
        elif sd > Ps:
            rel["wider"] += 1
        elif sd < Ps:
            rel["narrower"] += 1
        else:
            rel["incomparable"] += 1
        v5 += not (Ps <= sd)
        Lw = S0.listing_worlds(h, sd)
        if Lw and any(S0.good_enabled_set(Lw, x) for x in S0.ACTS) and not S0.good_enabled_set(Lw, a):
            v4 += 1
    out.update({"listing_histories": len(lrows), "v4_listed": listed, "v4_relation": rel,
                "v4_contradicted_histories": v4, "v5_contradicted_histories": v5,
                "listing_changes_act": changes, "listing_arm_failing_pairs": l_fail,
                "listing_complete": bool(lrows) and all(r["resolved"] for r in lrows.values()),
                "outside_the_relation": {k: {a: v.count(a) for a in sorted(set(map(str, v)))}
                                         for k, v in b["oor"].items()}})
    return out


def outcome(s):
    """The pin's outcome from its score (stage_b's four, with the log's partial)."""
    whole = s["audit_whole"] and s["listing_whole"] and s["oor_whole"] and s["episodes_whole"]
    if not whole:
        return "partial"
    if s["void"]:
        return "void"
    met = {"V1": s["v1_p"] <= ALPHA, "V2": s["v2_contradicted"] > 0, "V3": s["v3_p"] <= ALPHA,
           "V4": s["v4_contradicted_histories"] > 0, "V5": s["v5_contradicted_histories"] > 0}
    s["rules_met"] = [k for k, v in met.items() if v]
    if s["rules_met"]:
        return "contradicted"
    if (s["complete"] and s["listing_complete"] and not s["void_episodes"]
            and not s["v4_relation"]["declined, no sides"]):
        return "pass"
    return "unresolved"


LABEL = ("TR5 tests bridges, not RF3: V1 to V3 that the system is a policy from its visible history, V4 and V5 "
         "two bridges about a reading it states. A contradiction is a bridge's failure on this pin; a pass is "
         "V1 to V5, the void rule and the audit's completeness read together, on this pin.")


def answer_counts(recs):
    """The filtered answers (the provider's) and the unreadable ones among the read records, per arm
    (an episode's by its mode), apart: reported, never ruled on."""
    out = {}
    for r in recs:
        k = r["arm"] if r["arm"] != "episode" else f"episode {r['mode']}"
        c = out.setdefault(k, {"calls": 0, "filtered": 0, "invalid": 0, "declined": 0})
        c["calls"] += 1
        c["filtered"] += r["answer"] == Ly.FILTERED
        c["invalid"] += r["answer"] == Ly.INVALID
        c["declined"] += r["answer"] == Ly.DECLINE
    return out


def verdicts(view_of, pins, recs_of=None):
    """Per pin: its score and outcome. view_of(family) gives the pin's log view, recs_of(family) the
    records layer.load read."""
    out = {}
    for family, role in pins:
        s = score(T5.build(view_of(family), family))
        s["outcome"] = outcome(s)
        s["role"] = role
        if recs_of:
            s["answers"] = answer_counts(recs_of(family))
        out[family] = s
    return {"label": LABEL, "pins": out}
