"""TR6's frozen rule: the offline table, its shape, the loops and the verdicts (FREEZE-6.md, sections 4 to 6).

Pure functions of the answers; no call and no file. An answer is TAKE (the option of taking part, or
of going), STAY (staying out, or at home), DECLINE (the model's refusal: the system's answer), or
FILTERED or INVALID (a content filter's or anything else: not the system's, unreadable), as freeze
1's client reads a choice. A decline is read as not taking part: the forecast is of the number who
take part, and a member that does not choose to does not.

The offline table: each member at each forecast 0..N, once in each of the VARIANTS presentations. Its
decision there is TAKE where at least AGREE of the five answers are TAKE, STAY where at least AGREE
are STAY or DECLINE, and otherwise flagged; an unreadable answer counts toward neither. The table is
the count of TAKE decisions at each forecast: Becoming.ReflexivePrediction's response r, which maps
0..N into itself by construction (`within`). V1 reads it: no flagged decision; not constant; not the
identity; then its shape (keeps the order, reverses it, neither). The readings predict that the join
framing (taking part pays the more take part) keeps the order and the lake framing (going pays the
fewer go) reverses it; a framing's reading is read only where every comprehension probe of it
restates the forecast and the payoff.

A loop republishes the last count: round t publishes f_t (f_0 the start), and its count is the number
of TAKE answers where all ten are readable; that count is f_{t+1}. A round with an unreadable answer
has no count and ends its seed. In arm B each member is shown its own course; in arm A the same frame,
what happened withheld, so that both arms' requests are new each round and only arm B's can be read
for a course. V2 (the Lean's r is the count, not the members): a round mismatches where its count
differs from the table's at the forecast it published; each arm A seed is paired with the arm B seed
of the same start and presentation, and both are read up to the rounds both reached; V2 is
contradicted where arm B's mismatching rounds exceed arm A's by a one-sided Fisher exact test at
ALPHA, and not contradicted otherwise (no support is claimed: the course then adds no mismatch the
test resolves beyond the withheld frame's, whose own mismatches nothing bounds; the share of rounds
whose count is the table's, along which a loop is the table's orbit, is reported). A verdict is
partial where a call it reads was not read: V1's reading where a probe was not, V2 and the loops'
reports where a loop is not whole. Members' departures from their own table decisions are a
diagnostic with no verdict, and so is the share of loop answers that are the same presentation's
offline answer, which says whether arm A's frame redraws a dissenting answer or replays it. The Lean's forbidden cases are reported for the loops from
0; one in a seed whose every count is the table's would be the table's own orbit breaking a theorem,
which only a fault in this code can give: a self-check of the rule against the Lean. From a second
start they are reported against the candidate lemma, not judged.
"""

import math

from conditions import DECLINE
from rule import FILTERED, INVALID

N = 10
ROUNDS = N + 1              # rounds per seed: publications 0 to N, the count after the last the orbit at N + 1
VARIANTS = 5
AGREE = 4                   # of VARIANTS answers, for a decision
ALPHA = 0.05
FEW_MOVES = 4               # an orbit from 0 moving in fewer rounds than this gets a second start
RIGHT_ROUNDS = 3            # rounds of the loops from a right value
COSTS = (5, 15, 25, 35, 35, 55, 65, 65, 85, 95)
FRAMINGS = ("join", "lake")
PREDICTED = {"join": "keeps the order", "lake": "reverses the order"}
TAKE, STAY = "take", "stay"
READABLE = (TAKE, STAY, DECLINE)
UNREADABLE = (FILTERED, INVALID)
ARMS = ("A", "B")


def points(framing, cost, takes, count):
    """The member's points, as its prompt states them: count is the number who take part (or go), the
    member included where it does."""
    if not takes:
        return 0
    return 10 * count - cost if framing == "join" else 110 - 10 * count - cost


def best_reply(framing, reading):
    """The table of best replies, reported only (no verdict reads it): each member takes part where its
    points are positive, the count read as the forecast plus itself ("the forecast as the others") or
    as the forecast ("the forecast as the count")."""
    add = 1 if reading == "the forecast as the others" else 0
    return [sum(points(framing, c, True, p + add) > 0 for c in COSTS) for p in range(N + 1)]


def decision(answers):
    """TAKE, STAY or None (flagged) from one member's answers at one forecast, one in each presentation."""
    if sum(a == TAKE for a in answers) >= AGREE:
        return TAKE
    if sum(a in (STAY, DECLINE) for a in answers) >= AGREE:
        return STAY
    return None


def flag_cause(answers):
    """Why a decision is flagged: "unreadable answers" where fewer than AGREE of its answers are
    readable, so that no side could reach AGREE; else "dissent" among the presentations."""
    return "unreadable answers" if sum(a in READABLE for a in answers) < AGREE else "dissent"


def table(offline):
    """offline: {(member, forecast): [answers]} with every answer read. The decisions, the flagged
    (member, forecast) pairs, how many by each cause, and the count of TAKE decisions at each forecast."""
    dec = {k: decision(v) for k, v in offline.items()}
    flagged = sorted(k for k, d in dec.items() if d is None)
    causes = {c: sum(flag_cause(offline[k]) == c for k in flagged) for c in ("dissent", "unreadable answers")}
    return {"decisions": dec, "flagged": flagged, "flagged_by_cause": causes,
            "count": [sum(dec[(i, p)] == TAKE for i in range(N)) for p in range(N + 1)]}


def keeps(t):
    return all(t[v] <= t[w] for v in range(len(t)) for w in range(v, len(t)))


def reverses(t):
    return all(t[w] <= t[v] for v in range(len(t)) for w in range(v, len(t)))


def shape(t):
    """V1's reading of a table: constancy and the identity before the order."""
    if len(set(t)) == 1:
        return "constant"
    if all(t[p] == p for p in range(len(t))):
        return "the identity"
    if keeps(t):
        return "keeps the order"
    if reverses(t):
        return "reverses the order"
    return "neither"


def rights(t):
    return [p for p in range(len(t)) if t[p] == p]


def orbit(t, s, steps):
    out = [s]
    for _ in range(steps):
        out.append(t[out[-1]])
    return out


def moving(seq):
    """How many of a sequence's rounds publish a value other than the one before."""
    return sum(1 for k in range(len(seq) - 1) if seq[k + 1] != seq[k])


def second_start(t):
    """Where the table's orbit from 0 moves in fewer than FEW_MOVES of ROUNDS rounds: the least start
    whose orbit moves in the most rounds, if it moves in more than the orbit from 0; else None."""
    m0 = moving(orbit(t, 0, ROUNDS))
    if m0 >= FEW_MOVES:
        return None
    best = max(range(N + 1), key=lambda s: (moving(orbit(t, s, ROUNDS)), -s))
    return best if moving(orbit(t, best, ROUNDS)) > m0 else None


def loop(start, rounds_answers):
    """One seed's publications, counts and end, from its rounds' answers (each a list of the members'
    answers, None where not yet read). Stops at the first round not yet whole ("open"), or with an
    unreadable answer ("unreadable", that round having no count), or after ROUNDS rounds ("done")."""
    pubs, counts = [start], []
    for ans in rounds_answers:
        if len(ans) < N or any(a is None for a in ans):
            return pubs, counts, "open"
        if any(a not in READABLE for a in ans):
            return pubs, counts, "unreadable"
        c = sum(a == TAKE for a in ans)
        counts.append(c)
        pubs.append(c)
    return pubs, counts, "done" if len(counts) == ROUNDS else "open"


def fisher_one_sided(a, n1, b, n2):
    """P(X >= a), X hypergeometric: a events of n1 in arm B, b of n2 in arm A (tr6.py's)."""
    k = a + b
    if n1 == 0 or k == 0:
        return 1.0
    tot = math.comb(n1 + n2, k)
    return sum(math.comb(n1, x) * math.comb(n2, k - x) for x in range(a, min(k, n1) + 1)) / tot


def mismatches(seed, t, upto=None):
    """The rounds of a seed (its first `upto`, or all) whose count differs from the table's at the
    forecast published."""
    pubs, counts = seed["pubs"], seed["counts"][:upto]
    return sum(1 for k, c in enumerate(counts) if c != t[pubs[k]])


def v2(seeds, t):
    """seeds: {arm: [seed]}, the two arms' lists in the same order (start, then presentation); each seed
    {"pubs", "counts", ...}. Each pair of seeds is read up to the rounds both reached, so that an arm
    whose seeds end sooner, at an unreadable answer, is not read from fewer resting rounds. Mismatching
    rounds of the rounds read, per arm, the share of rounds whose count is the table's, and Fisher's
    one-sided p for arm B over arm A."""
    both = [min(len(sa["counts"]), len(sb["counts"])) for sa, sb in zip(seeds["A"], seeds["B"])]
    m = {a: sum(mismatches(s, t, k) for s, k in zip(seeds[a], both)) for a in ARMS}
    n = {a: sum(both) for a in ARMS}
    p = fisher_one_sided(m["B"], n["B"], m["A"], n["A"])
    return {"mismatching_rounds": m, "rounds_read": n,
            "share_of_rounds_whose_count_is_the_tables": {a: round(1 - m[a] / n[a], 4) if n[a] else None for a in ARMS},
            "p": round(p, 6), "outcome": "contradicted" if p < ALPHA else "not contradicted"}


def individual(seeds, dec):
    """The diagnostic: live answers departing from the member's own table decision (TAKE or not)."""
    m, n = {}, {}
    for a in ARMS:
        m[a] = n[a] = 0
        for s in seeds[a]:
            for k, ans in enumerate(s["answers"][:len(s["counts"])]):
                for i, x in enumerate(ans):
                    n[a] += 1
                    m[a] += (x == TAKE) != (dec[(i, s["pubs"][k])] == TAKE)
    return {"departures": m, "decisions": n, "p": round(fisher_one_sided(m["B"], n["B"], m["A"], n["A"]), 6),
            "verdict": "none (a diagnostic of a stronger premise than the Lean's)"}


def replays(seeds, offline):
    """Reported only: per arm, the share of loop answers from round 1 on, in the rounds read, that are the
    member's own offline answer in the same presentation at the forecast published, over all of them and
    over those where the five offline answers there are not all alike. At temperature 0 a prompt whose
    difference from the table's request moves no answer gets that answer again, so arm A's share there
    says whether its frame redraws a dissenting answer or replays it (FREEZE-6.md, section 5)."""
    out = {}
    for a in ARMS:
        n = m = nd = md = 0
        for s in seeds[a]:
            for k in range(1, len(s["counts"])):
                for i, x in enumerate(s["answers"][k]):
                    o = offline[(i, s["pubs"][k])]
                    same, differ = x == o[s["variant"]], len(set(o)) > 1
                    n, m, nd, md = n + 1, m + same, nd + differ, md + (same and differ)
        out[a] = {"share": round(m / n, 4) if n else None, "answers": n,
                  "share_where_the_presentations_differ": round(md / nd, 4) if nd else None, "answers_there": nd}
    return out


def forbidden(seed, t):
    """The Lean's forbidden cases in one seed from 0 (the chain laws where the table keeps the order,
    right_rests always, none_right_of_moves where it moves every value)."""
    seq, out = seed["pubs"], []
    least = min(rights(t)) if rights(t) else None
    if keeps(t):
        if any(seq[k + 1] < seq[k] for k in range(len(seq) - 1)):
            out.append("a fall (rises)")
        if least is not None and any(x > least for x in seq):
            out.append("a pass above the least right value (below_right)")
        if len(seed["counts"]) == ROUNDS and seq[N + 1] != seq[N]:
            out.append("no rest by round N (bottom_rests)")
    rr = next((k for k in range(len(seq) - 1) if seq[k + 1] == seq[k]), None)
    if rr is not None and any(x != seq[rr] for x in seq[rr:]):
        out.append("a right value followed by another (right_rests)")
    if not rights(t) and rr is not None:
        out.append("a right value where none can be (none_right_of_moves)")
    return out


def against_lemma(seed, t):
    """From a second start s, against the candidate lemma (the orbit from any start under an
    order-keeping map), reported with no verdict: a move against the direction of the first step,
    and not at the nearest right value in that direction by step N - s or s."""
    seq, s = seed["pubs"], seed["pubs"][0]
    if not keeps(t):
        return ["the table does not keep the order: the lemma says nothing"]
    up = t[s] >= s
    out = []
    if any((seq[k + 1] < seq[k]) if up else (seq[k + 1] > seq[k]) for k in range(len(seq) - 1)):
        out.append("a move against the first step's direction")
    target = min(f for f in rights(t) if f >= s) if up else max(f for f in rights(t) if f <= s)
    by = N - s if up else s
    if len(seq) > by and seq[by] != target:
        out.append(f"not at {target} by step {by}")
    return out


def restated(probe, framing, member, forecast):
    """A probe restates where it gives the forecast and the points of taking part at the probe's count."""
    k = max(forecast, 1)
    return probe == {"forecast": forecast, "points": points(framing, COSTS[member], True, k)}


def framing_verdict(framing, offline, probes, seeds, second, right_seeds, probes_not_read=0):
    """One framing's verdicts. offline: {(member, forecast): [answers]} or None where not whole; probes:
    {(member, forecast): probe or None}, None for an unreadable probe or one not read, of which
    probes_not_read were not read (not logged, logged outside good reads, or in a context the reading
    drops); seeds: {arm: [seed]} from 0; second: {arm: [seed]} from the
    second start, or None; right_seeds: {arm: [seed]} from the least right value, or None. A seed is
    {"pubs", "counts", "answers", "end"}."""
    if offline is None:
        return {"outcome": "partial: the offline table is not whole"}
    tb = table(offline)
    t = tb["count"]
    out = {"table": t, "flagged": [list(k) for k in tb["flagged"]], "flagged_by_cause": tb["flagged_by_cause"],
           "best_reply_tables_reported_only": {r: best_reply(framing, r) for r in
                                               ("the forecast as the others", "the forecast as the count")}}
    restate = sum(1 for (i, p), v in probes.items() if v is not None and restated(v, framing, i, p))
    out["probes_restated"] = {"restated": restate, "planned": len(probes)}
    if tb["flagged"]:
        c = tb["flagged_by_cause"]
        out["outcome"] = (f"void: {len(tb['flagged'])} decisions flagged, {c['dissent']} by dissent among the "
                          f"presentations, {c['unreadable answers']} by unreadable answers (no table, so no V2)")
        return out
    sh = shape(t)
    out.update({"shape": sh, "right_values": rights(t), "orbit_from_0": orbit(t, 0, ROUNDS),
                "moving_rounds_from_0": moving(orbit(t, 0, ROUNDS)), "second_start": second_start(t)})
    if sh in ("constant", "the identity"):
        out["reading"] = f"not read: the table is {sh}"
    elif probes_not_read:
        out["reading"] = f"partial: {probes_not_read} of {len(probes)} probes not read"
    elif restate < len(probes):
        out["reading"] = f"not read: {restate} of {len(probes)} probes restated"
    elif sh == PREDICTED[framing]:
        out["reading"] = f"holds here: the table {sh}, as the reading predicts"
    else:
        out["reading"] = f"contradicted: the table {'is ' if sh == 'neither' else ''}{sh}, not as the reading predicts"
    every = {a: seeds[a] + (second[a] if second else []) for a in ARMS}
    out["v2"] = v2(every, t)
    out["v2_from_0_alone_reported"] = v2(seeds, t)
    out["individual_diagnostic"] = individual(every, tb["decisions"])
    out["replays_reported_only"] = replays(every, offline)
    out["seed_ends"] = {a: [s["end"] for s in every[a]] for a in ARMS}
    out["moving_rounds"] = {a: [moving(s["pubs"]) for s in every[a]] for a in ARMS}
    fb = {a: [forbidden(s, t) for s in seeds[a]] for a in ARMS}
    out["forbidden_from_0"] = fb
    fault = [f"{a} seed {k}" for a in ARMS for k, s in enumerate(seeds[a]) if fb[a][k] and mismatches(s, t) == 0]
    # mismatches(s, t) == 0: every count read is the table's, so the publications are its orbit
    if second:
        out["second_start_against_the_lemma_reported_only"] = {a: [against_lemma(s, t) for s in second[a]] for a in ARMS}
    if right_seeds:
        out["from_the_least_right_value"] = {a: [s["counts"] for s in right_seeds[a]] for a in ARMS}
        r = min(rights(t))
        fault += [f"right-{a} seed {k}" for a in ARMS for k, s in enumerate(right_seeds[a])
                  if a == "A" and mismatches(s, t) == 0 and any(c != r for c in s["counts"])]
    out["self_check_failed"] = fault
    loops = [s for d in (seeds, second or {}, right_seeds or {}) for a in ARMS for s in d.get(a, [])]
    open_ = sum(s["end"] == "open" for s in loops)
    if open_:           # a loop not whole: V2 and the loops' reports carry no verdict
        out["v2"]["outcome"] = "partial"
        out["outcome"] = f"partial: {open_} of {len(loops)} loops not whole"
    elif fault:
        out["outcome"] = ("self-check failed: a forbidden case in a seed whose every count is the table's "
                          "(a fault in this code, not a reading of the members)")
    else:
        out["outcome"] = "read"
    return out
