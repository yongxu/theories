"""SCL's Stage 0 (FREEZE-12.md, section 5): no model call, no download, no network. Standard library; seeded.

1. The mirror. FREEZE-5's Stage 0 (tr1.py, imported unchanged) evaluates `ReadingLoop.Untested`'s witness:
   `rests`, `alike_in_both`, `never_high`, `true_kept`, `explorer_up`, `explorer_down`, `explorer_low_once`,
   `order_rests`, `model_or_order`, `informed_turns`. SCL's exits come at round 3 of a course, not at its start, so
   two inferences are checked by evaluation on tr1's loop (labelled inferences: the Lean states the starts): an act
   forced to the untried one after the lock has rested leaves the true candidate alone, and the course then rests
   as `explorer_up`'s (in up, the untried act) or `explorer_down`'s (in down, the known act); a listing replaced
   by the true candidate alone after the lock has rested turns as `informed_turns` does in up and keeps the known
   act in down.
2. The agents. Each answers a call from what its words show (the view: the options, the rounds so far, any
   telling, whether the words are the paraphrase, the probe's letters), with no state of its own between calls,
   as a model called afresh: the witness's formations, the scripted rivals, and four standard learners.
3. The power, by simulation: each agent's courses drawn through the plan's arms, read by the frozen rule
   (scl_rule.reading), SIMS times per setting; the share of each verdict.
"""

import math
import random

import scl_design as D
import scl_rule as RU
import tr1

D.own_files()

SIMS = 100
SIM_SEED = "SCL-stage0-2026-11-05"
LATE_FROM = 4           # a late trier's first round of trying (R1-4), unless its own is given (R3-1: from round 3)


# ------------------------------------------------------------------------------------------------
# 1. The mirror

def mirror():
    res = {"tr1.mirror_untested (FREEZE-5's Stage 0, by evaluation)": tr1.mirror_untested()}
    M = tr1.LoopLaw(tr1.by_worst(tr1.RANK))
    O = tr1.LoopLaw(tr1.by_worst(tr1.RANK2))
    up_rest = ((("up",), ("high", "untried")), "high", "untried", "up")
    down_rest = ((("down",), ("mid", "known")), "mid", "known", "down")
    inf = {}
    for w in (tr1.UP, tr1.DOWN):
        x = tr1.start([tr1.UP, tr1.DOWN], tr1.MID, tr1.KNOWN, w)
        for _ in range(2):          # the lock rests (Untested.rests)
            x = M.step(x)
        rested = x
        (hs, last), s, a, e = x
        forced = ((hs, last), s, tr1.UNTRIED, e)     # the act chosen for the formation: the untried one
        c = M.course(forced, 40)
        kept_after = [y[0][0] for y in c[2:]]
        inf[f"forced untried after rest, {w}: true candidate alone from two steps on"] = \
            all(k == (w,) for k in kept_after)
        target = up_rest if w == tr1.UP else down_rest
        inf[f"forced untried after rest, {w}: rests as the explorer's"] = all(y == target for y in c[4:]) \
            if w == tr1.UP else all(y == target for y in c[3:])
        informed = (((w,), last), s, a, e)           # the listing replaced by the true candidate alone
        ci = M.course(informed, 40)
        inf[f"listing told after rest, {w}: " + ("turns as informed_turns" if w == tr1.UP else "keeps the known act")] = \
            all(y == up_rest for y in ci[3:]) if w == tr1.UP else all(y[2] == tr1.KNOWN for y in ci)
        inf[f"the lock at round 3 is the rest, {w}"] = rested == (((tr1.UP, tr1.DOWN), (tr1.MID, tr1.KNOWN)),
                                                                    tr1.MID, tr1.KNOWN, w)
    co = O.course((((tr1.UP,), (tr1.MID, tr1.KNOWN)), tr1.MID, tr1.KNOWN, tr1.UP), 40)
    inf["order (mid above high) told the true candidate in up keeps the known act (order_rests)"] = \
        all(y[2] == tr1.KNOWN for y in co)
    res["SCL's exits at a course's round, by evaluation (inferences)"] = inf
    res["all pass"] = res["tr1.mirror_untested (FREEZE-5's Stage 0, by evaluation)"]["all_witness_checks_pass"] \
        and all(inf.values())
    return res


# ------------------------------------------------------------------------------------------------
# 2. The view and the agents

def view_of(x, acts, smoke=False):
    """What a call's words show, from the design (the dry run checks that the words show exactly this): the known
    option's letter and amount, the other's two amounts, the rounds so far (round, letter, amount paid, chosen for
    the player), the tellings (letter, amount), the question, the probe's letters, and which words."""
    a = D.amounts(smoke)
    o = x["order"]
    arm = D.ARMS[x["condition"]] if x["condition"] != "C" else None
    if arm is None:
        first, second = (D.MID, D.HIGH) if o == 0 else (D.HIGH, D.MID)
        return {"what": "frame", "amounts": {"A": a[first], "B": a[second]}}
    hist = [(1, D.D10.letter(o, D.KNOWN), a[D.MID], True)]
    told = []
    for r in range(2, x["round"]):
        if r in arm["assigned"]:
            act = arm["assigned"][r]
            hist.append((r, D.D10.letter(o, act), a[D.reply(act, x["world"])], True))
        elif acts[r] in (D.KNOWN, D.UNTRIED):
            hist.append((r, D.D10.letter(o, acts[r]), a[D.reply(acts[r], x["world"])], False))
        else:
            hist.append((r, None, None, False))
        if arm["told"] and arm["told"][0] == r:
            act = arm["told"][1]
            told.append((D.D10.letter(o, act), a[D.reply(act, x["world"])]))
    v = {"what": x["what"], "round": x["round"], "known": D.D10.letter(o, D.KNOWN), "other": D.D10.letter(o, D.UNTRIED),
         "mid": a[D.MID], "either": (a[D.HIGH], a[D.LOW]), "history": hist, "told": told,
         "paraphrase": arm["words"] == "paraphrase", "n": D.N_ANN}
    if x["what"] == "probe":
        v["probe"] = {(a[D.HIGH] if lab == D.HIGH else a[D.LOW] if lab == D.LOW else "either"): L
                      for L, lab in zip(D.PROBE_LETTERS, D.layout(x["rep"]))}
    return v


class Agent:
    """An agent answering from a view. rule: "worst" (the witness's worst case, high above middle above low),
    "order" (the worst case with the middle above the high: order_rests), "optimist" (the best case), "count" (the
    option chosen most so far, the known one at a tie: ChoiceCountCapture's counted lock), "first" (the option
    listed first), "egreedy", "ucb" or "thompson" (standard learners on the amounts paid). believes: whether a
    telling is taken in. h0: a constant chance a round of taking the other act than the rule's (a trembler's, or
    egreedy's exploration). slope: the chance's rise a round after the second (a history-length explorer).
    par_h: its rise under the paraphrase (a word reader). rho: the chance a round of the known option, taken by
    the player, that a probe names the low amount alone with no answer to say so (a prior-narrowing reader).
    eps: a probe's chance of naming another answer. crank: C's ranking ("high" or "mid" first). unread: an
    answer's chance of naming nothing. late: the chance a round, from round late_from (LATE_FROM unless given) on,
    of taking the other option whatever the rule says (a late trier, R1-4, R3-1). exit_share: the chance that a
    probe whose listing has one candidate names it, else "either" (an agent at the exits' boundary, R1-5)."""

    def __init__(self, rule="worst", believes=True, h0=0.0, slope=0.0, par_h=0.0, rho=0.0, par_rho=0.0, eps=0.0,
                 crank="high", unread=0.0, decline=False, late=0.0, exit_share=1.0,
                 late_from=LATE_FROM):
        self.rule, self.believes, self.h0, self.slope, self.par_h = rule, believes, h0, slope, par_h
        self.rho, self.par_rho, self.eps, self.crank, self.unread, self.decline = rho, par_rho, eps, crank, unread, \
            decline
        self.late, self.exit_share, self.late_from = late, exit_share, late_from

    def listing(self, v):
        hi, lo = v["either"]
        ws = {"up", "down"}
        for _, L, paid, _ in v["history"]:
            if L == v["other"] and paid is not None:
                ws &= {"up" if paid == hi else "down"}
        if self.believes:
            for L, pay in v["told"]:
                if L == v["other"]:
                    ws &= {"up" if pay == hi else "down"}
        return ws

    def choose(self, v, rng):
        ws = self.listing(v)
        hi, lo = v["either"]
        r = self.rule
        if r == "worst":
            act = "other" if ws == {"up"} else "known"
        elif r == "order":
            act = "known"
        elif r == "optimist":
            act = "other" if "up" in ws else "known"
        elif r == "count":
            n = {"known": 0, "other": 0}
            for _, L, _, _ in v["history"]:
                if L is not None:
                    n["known" if L == v["known"] else "other"] += 1
            act = "other" if n["other"] > n["known"] else "known"
        elif r == "first":
            act = "known" if v["known"] == "A" else "other"
        elif r == "egreedy":
            val = sum(hi if w == "up" else lo for w in ws) / len(ws) if ws else v["mid"]
            act = "other" if val > v["mid"] else "known"
            if rng.random() < self.h0:
                act = rng.choice(("known", "other"))
            return act
        elif r == "ucb":
            seen = [p for _, L, p, _ in v["history"] if L == v["other"] and p is not None]
            if not seen:
                act = "other"
            else:
                t = len(v["history"])
                nk = sum(1 for _, L, _, _ in v["history"] if L == v["known"])
                uo = sum(seen) / len(seen) + (2 * math.log(t) / len(seen)) ** 0.5
                uk = v["mid"] + (2 * math.log(t) / max(nk, 1)) ** 0.5
                act = "other" if uo > uk else "known"
            return act
        elif r == "thompson":
            w = rng.choice(sorted(ws)) if ws else "down"
            act = "other" if (hi if w == "up" else lo) > v["mid"] else "known"
            return act
        else:
            raise ValueError(r)
        h = self.h0 + self.slope * max(v["round"] - 2, 0) + (self.par_h if v["paraphrase"] else 0.0)
        if h and rng.random() < h:
            act = "other" if act == "known" else "known"
        if self.late and v["round"] >= self.late_from and rng.random() < self.late:
            act = "other"
        return act

    def __call__(self, v, rng):
        """A letter, or "invalid" or "decline"."""
        if self.decline:
            return "decline"
        if self.unread and rng.random() < self.unread:
            return "invalid"
        if v["what"] == "frame":
            am = v["amounts"]
            pick = max(am, key=lambda L: am[L]) if self.crank == "high" else min(am, key=lambda L: am[L])
            if self.eps and rng.random() < self.eps:
                pick = "A" if pick == "B" else "B"
            return pick
        if v["what"] == "act":
            act = self.choose(v, rng)
            return v["known"] if act == "known" else v["other"]
        ws = self.listing(v)
        own = sum(1 for _, L, _, assigned in v["history"] if L == v["known"] and not assigned)
        rho = self.rho + (self.par_rho if v["paraphrase"] else 0.0)
        if ws == {"up", "down"} and rho and rng.random() < min(1.0, rho * own):
            ws = {"down"}
        hi, lo = v["either"]
        ans = "either" if len(ws) != 1 else (hi if ws == {"up"} else lo)
        if len(ws) == 1 and self.exit_share < 1 and rng.random() >= self.exit_share:
            ans = "either"
        if self.eps and rng.random() < self.eps:
            ans = rng.choice([y for y in (hi, lo, "either") if y != ans])
        return v["probe"][ans]


# ------------------------------------------------------------------------------------------------
# 3. The fast path: an agent's courses through the plan, without the words, into the rule's structure

def simulate(agent, rng, check=False):
    """One run of the plan for an agent: C's calls and every course of every arm, each call answered from its view,
    read into the structure scl_rule.reading takes (the label each answer names). The views are built round by
    round; check: each is asserted equal to view_of's for the same call (the dry run does it once)."""
    courses = {}
    c_ans = {o: [] for o in D.ORDERS}
    for o in D.ORDERS:
        first, second = (D.MID, D.HIGH) if o == 0 else (D.HIGH, D.MID)
        v = view_of({"condition": "C", "order": o}, {})
        for r in range(D.C_CALLS):
            L = agent(v, rng)
            c_ans[o].append({"A": first, "B": second}.get(L, D.INVALID))
    a = D.amounts()
    for arm in D.COURSE_ARMS:
        spec = D.ARMS[arm]
        free, probes = D.free_rounds(arm), spec["probes"]
        end = max(spec["last"], max(probes))
        par = spec["words"] == "paraphrase"
        for w in D.WORLDS:
            for o in D.ORDERS:
                lettered = D.D10.letters_of(o)
                kl, ol = D.D10.letter(o, D.KNOWN), D.D10.letter(o, D.UNTRIED)
                pays = {D.KNOWN: a[D.reply(D.KNOWN, w)], D.UNTRIED: a[D.reply(D.UNTRIED, w)]}
                for rep in range(D.REPS):
                    acts, pr = {}, {}
                    hist, told = [(1, kl, a[D.MID], True)], []
                    pmap = {(a[D.HIGH] if lab == D.HIGH else a[D.LOW] if lab == D.LOW else "either"): L
                            for L, lab in zip(D.PROBE_LETTERS, D.layout(rep))}
                    labs = dict(zip(D.PROBE_LETTERS, D.layout(rep)))
                    for k in range(2, end + 1):
                        base = {"round": k, "known": kl, "other": ol, "mid": a[D.MID], "either": (a[D.HIGH], a[D.LOW]),
                                "history": list(hist), "told": list(told), "paraphrase": par, "n": D.N_ANN}
                        if k in free:
                            v = dict(base, what="act")
                            if check:
                                assert v == view_of({"condition": arm, "world": w, "order": o, "rep": rep,
                                                     "what": "act", "round": k}, acts), (arm, k)
                            L = agent(v, rng)
                            acts[k] = lettered.get(L, D.DECLINE if L == "decline" else D.INVALID)
                        if k in probes:
                            v = dict(base, what="probe", probe=pmap)
                            if check:
                                assert v == view_of({"condition": arm, "world": w, "order": o, "rep": rep,
                                                     "what": "probe", "round": k}, acts), (arm, k)
                            pr[k] = labs.get(agent(v, rng), D.UNREAD)
                        if k in spec["assigned"]:
                            act = spec["assigned"][k]
                            hist.append((k, D.D10.letter(o, act), pays[act], True))
                        elif k in free:
                            act = acts[k]
                            hist.append((k, D.D10.letter(o, act), pays[act], False) if act in pays
                                        else (k, None, None, False))
                        if spec["told"] and spec["told"][0] == k:
                            told.append((D.D10.letter(o, spec["told"][1]), pays[spec["told"][1]]))
                    courses[(arm, w, o, rep)] = {"acts": acts, "probes": pr}
    return courses, c_ans


# The agents of Stage 0: (name, the agent's settings, its role, what the rule must give it: verdict -> status, or
# -> a tuple of the statuses allowed). Every deterministic agent is asserted on all six verdicts; an agent with draws
# only on the verdicts named.
EPS = 0.05          # the probe noise of the power's stochastic agents
NOT_SUPPORTED = ("unresolved", "contradicted", "not testable")
EXIT_SHARE_055 = (0.55 - EPS / 2) / (1 - 3 * EPS / 2)   # R2-4: with the probe's noise after it, the true share named
                                                        # is 0.025 + 0.925 x this = 0.55 exactly (21/37)
ALL_NT = {v: RU.NO_START for v in ("K", "S", "E1", "E2", "T after E1", "T after E2")}


def meets(got, want):
    """Whether a reading's summary meets what is asserted of it: each verdict named equals its status, or is one of
    a tuple's."""
    return all(got[v] in s if isinstance(s, tuple) else got[v] == s for v, s in (want or {}).items())


AGENTS = [
    ("M, the witness (worst case, 8 > 5 > 2)", dict(rule="worst"), "the law's formation",
     {"K": "passed", "S": "passed", "E1": "supported", "E2": "supported", "T after E1": "supported",
      "T after E2": "supported"}),
    ("O, the witness with the order 5 > 8 > 2", dict(rule="order", crank="mid"), "the law's formation (order_rests)",
     {"K": "passed", "S": "passed", "E1": "supported", "E2": "supported",
      "T after E1": "no turn predicted (C strict at 5: order_rests)",
      "T after E2": "no turn predicted (C strict at 5: order_rests)"}),
    ("a prior-follower that never tries (expected value, 3/4 on down: acts as M)", dict(rule="worst"),
     "permitted (LA3's agent that never tried)",
     {"K": "passed", "S": "passed", "E1": "supported", "E2": "supported", "T after E1": "supported",
      "T after E2": "supported"}),
    ("count lock (the option chosen most; tellings not taken in)", dict(rule="count", believes=False),
     "forbidden by exit 2 (and by the turn)",
     {"K": "passed", "S": "passed", "E1": "supported", "E2": "contradicted", "T after E1": "contradicted",
      "T after E2": "not ruled (the exit in belief not supported)"}),
    ("untrusting (M, tellings not taken in)", dict(rule="worst", believes=False), "forbidden by exit 2",
     {"K": "passed", "S": "passed", "E1": "supported", "E2": "contradicted", "T after E1": "supported",
      "T after E2": "not ruled (the exit in belief not supported)"}),
    ("frame-inconsistent (O in the courses, 8 > 5 stated)", dict(rule="order", crank="high"), "forbidden by the turn",
     {"K": "passed", "S": "passed", "E1": "supported", "E2": "supported", "T after E1": "contradicted",
      "T after E2": "contradicted"}),
    ("prior-narrowing reader (rho 0.1 a round)", dict(rule="worst", rho=0.1), "forbidden by K",
     {"K": "contradicted"}),
    ("first-listed reader", dict(rule="first"), "forbidden by N4",
     {"K": "passed", "S": "contradicted", "E1": "supported", "E2": "supported", "T after E1": "contradicted",
      "T after E2": "contradicted"}),
    ("optimist (best case: tries at once)", dict(rule="optimist"), "the first exit taken: not testable",
     {"K": "passed", "S": "passed", "E1": "not testable", "E2": "not testable",
      "T after E1": "not ruled (the exit in belief not supported)",
      "T after E2": "not ruled (the exit in belief not supported)"}),
    ("declining every call", dict(decline=True), "not testable (no start probe read)", ALL_NT),
    ("late trier (O in the courses, 8 > 5 stated, tries 0.9 a round from round 4)",
     dict(rule="order", crank="high", late=0.9),
     "forbidden by N1 (B's rounds 4 to 8 over 2 and 3), and no turn: tries late whatever it is shown",
     {"S": "contradicted", "E1": "supported", "T after E1": NOT_SUPPORTED, "T after E2": NOT_SUPPORTED}),
]

# The power's settings: (name, agent settings, role). Rates are a round's chance of trying (h0) and the probe's
# noise (EPS). The client sends default sampling, so no rate is assumed: each verdict reads differences and bounds.
RATES = (0.02, 0.05, 0.1, 0.2)
POWER = [(f"M trembling {h}", dict(rule="worst", h0=h, eps=EPS), "permitted") for h in RATES] + \
    [(f"O trembling {h}", dict(rule="order", crank="mid", h0=h, eps=EPS), "permitted") for h in (0.05, 0.1)] + \
    [("epsilon-greedy, 0.1", dict(rule="egreedy", h0=0.1, eps=EPS), "permitted (a standard learner)"),
     ("epsilon-greedy, 0.3", dict(rule="egreedy", h0=0.3, eps=EPS), "permitted (a standard learner)"),
     ("UCB1", dict(rule="ucb", eps=EPS), "the first exit taken (a standard learner)"),
     ("Thompson sampling, prior one half", dict(rule="thompson", eps=EPS), "permitted (a standard learner)"),
     ("history-length explorer, 0.02 + 0.01 a round", dict(rule="worst", h0=0.02, slope=0.01, eps=EPS),
      "forbidden by N1"),
     ("history-length explorer, 0.02 + 0.02 a round", dict(rule="worst", h0=0.02, slope=0.02, eps=EPS),
      "forbidden by N1"),
     ("prior-narrowing reader, rho 0.02 a round", dict(rule="worst", h0=0.05, rho=0.02, eps=EPS), "forbidden by K"),
     ("prior-narrowing reader, rho 0.05 a round", dict(rule="worst", h0=0.05, rho=0.05, eps=EPS), "forbidden by K"),
     ("word reader, tries 0.05 more reworded", dict(rule="worst", h0=0.05, par_h=0.05, eps=EPS), "forbidden by N3"),
     ("word reader, tries 0.15 more reworded", dict(rule="worst", h0=0.05, par_h=0.15, eps=EPS), "forbidden by N3"),
     ("word reader, narrows reworded (rho 0.1)", dict(rule="worst", h0=0.05, par_rho=0.1, eps=EPS),
      "forbidden by K (N3)"),
     ("count lock, trembling 0.05", dict(rule="count", believes=False, h0=0.05, eps=EPS), "forbidden by exit 2"),
     ("untrusting, trembling 0.05", dict(rule="worst", believes=False, h0=0.05, eps=EPS), "forbidden by exit 2"),
     ("M trembling 0.05, 5% of answers unreadable", dict(rule="worst", h0=0.05, eps=EPS, unread=0.05), "permitted")] + \
    [(f"M trembling {h} (a high constant hazard at round 2)", dict(rule="worst", h0=h, eps=EPS),
      "permitted (the not-testable cost of K0 = 3)") for h in (0.4, 0.5, 0.6)] + \
    [("M trembling 0.05, the exits at a true share of 0.55", dict(rule="worst", h0=0.05, eps=EPS,
                                                                  exit_share=EXIT_SHARE_055),
      "at the exits' boundary (a false contradiction)")] + \
    [(f"late trier, tries {q} a round from round 4 whatever it is shown", dict(rule="order", crank="high", late=q,
                                                                             eps=EPS),
      "forbidden by N1, from round 4 (and no turn: a false support of T)") for q in (0.6, 0.9)] + \
    [(f"late trier, tries {q} a round from round 3 whatever it is shown", dict(rule="order", crank="high", late=q,
                                                                             eps=EPS, late_from=3),
      "forbidden by N1, from round 3 (R3-1: a step that persists, the middle comparison's base raised)")
     for q in (0.3, 0.6, 0.9)]

VERDICTS = ("K", "S", "E1", "E2", "T after E1", "T after E2")
ROUND2_DROPPED = "S N1 more rounds, 3 over 2"      # R4-2: the comparison round 3 added (R3-1)


def s_round2(courses):
    """S as round 2's rule read it (R4-2): STESTS without B's round 3 over its round 2, each at ALPHA / 7, read
    with N_MIN_RISK course-rounds on each side; the verdict alone, which FREEZE-12 section 4 cites for the late
    triers from round 3. Described, never part of the reading."""
    tests = [x for x in RU.STESTS if x[0] != ROUND2_DROPPED]
    contra, unread = False, 0
    for name, (ta, tr, to), (ba, br, bo) in tests:
        t, b = RU.hazard(courses, ta, tr, to), RU.hazard(courses, ba, br, bo)
        if t[1] < RU.N_MIN_RISK or b[1] < RU.N_MIN_RISK:
            unread += 1
            continue
        rise = RU.Fraction(t[0], t[1]) - RU.Fraction(b[0], b[1])
        contra = contra or (rise >= RU.DELTA_S and RU.fisher_exact(t[0], t[1], b[0], b[1]) <= RU.ALPHA / len(tests))
    return "contradicted" if contra else ("passed" if unread < len(tests) else "not testable")


def power(sims=SIMS):
    """Each setting's share of each verdict's outcomes over `sims` runs, which comparisons contradicted, and which
    of K's and S's comparisons were not read (R3-3: what sizes S's blind spot)."""
    out = []
    for name, kw, role in POWER:
        rng = random.Random(f"{SIM_SEED}|{name}")
        agent = Agent(**kw)
        tally = {v: {} for v in VERDICTS}
        hits, unread, round2 = {}, {}, {}
        for _ in range(sims):
            courses, c_ans = simulate(agent, rng)
            res = RU.reading(courses, c_ans)
            if kw.get("late_from") == 3:
                s2 = s_round2(courses)
                round2[s2] = round2.get(s2, 0) + 1
            for v in VERDICTS:
                s = res["summary"][v]
                tally[v][s] = tally[v].get(s, 0) + 1
            for v in ("K", "S"):
                for c in res[v].get("contradicting", []):
                    hits[c] = hits.get(c, 0) + 1
                for c in res[v].get("not read", []):
                    unread[c] = unread.get(c, 0) + 1
        row = {"setting": name, "role": role, "runs": sims,
               "shares": {v: {s: round(k / sims, 3) for s, k in sorted(t.items())} for v, t in tally.items()},
               "comparisons contradicting, share of runs": {c: round(k / sims, 3) for c, k in sorted(hits.items())},
               "comparisons not read, share of runs": {c: round(k / sims, 3) for c, k in sorted(unread.items())}}
        if round2:
            row["S under round 2's rule (without " + ROUND2_DROPPED + ", at ALPHA / 7)"] = \
                {s: round(k / sims, 3) for s, k in sorted(round2.items())}
        out.append(row)
    return out


def fixed_agents():
    """The agents whose answers the rule's outcome is asserted for, on the fast path, one run each."""
    rows = []
    for name, kw, role, want in AGENTS:
        rng = random.Random(f"{SIM_SEED}|fixed|{name}")
        courses, c_ans = simulate(Agent(**kw), rng)
        res = RU.reading(courses, c_ans)
        assert want and meets(res["summary"], want), (name, res["summary"], want)
        row = {"agent": name, "role": role, "summary": res["summary"], "asserted": sorted(want)}
        if "late trier" in name:     # the twin is what keeps its turn from being read: its own share alone would pass
            up = res["T after E1"]["up"]
            assert RU.lower_at_least(up["taking the other option"], up["in the lock at round 3, act read at round 4"])
            row["T after E1, its share's 95% lower bound at least 0.5 (the twin's rule decides)"] = True
        rows.append(row)
    return rows


def call_counts():
    """The calls each arm and control adds, exactly, per pin: C, each arm's course calls and probes."""
    out = {}
    for c in D.CONDITIONS:
        xs = D.plan("count", (c,))
        out[c] = {"calls": len(xs), "acts": sum(x["what"] == "act" for x in xs),
                  "probes": sum(x["what"] == "probe" for x in xs), "frames": sum(x["what"] == "frame" for x in xs)}
    out["per pin"] = len(D.plan("count"))
    out["smoke per pin"] = len(D.plan("count", smoke=True))
    out["N4, the name order"] = "no call: both name orders are in every arm"
    out["N5, a sibling of another size"] = {"pin": D.N5_PROPOSED, "calls": len(D.plan("count")),
                                             "run": "not under this freeze: a new pin, which freeze 1's chain cannot add"}
    return out
