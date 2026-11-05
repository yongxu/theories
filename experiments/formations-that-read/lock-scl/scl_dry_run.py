"""SCL's dry run (FREEZE-12.md, section 10): the frozen code path end to end, with no model call, no key and no
network. Writes results/dry-run.json, the same bytes on every run (no time, no temporary path, seeded draws); every
figure the text gives from the dry run is read from it.

    python3 -B scl_dry_run.py          # about a minute or two on one core of this machine

1. Stage 0: the mirror; the agents whose outcome is fixed, on the fast path; the power by simulation; the calls each
   arm and control adds; the readability rule's chance of stopping a pin.
2. The words: every planned call of the three pins built and parsed back from its words alone, the parse equal to
   the view the agents answer from; the paraphrase's facts equal to the base words' and no sentence shared; the
   world shown exactly from the round chosen for the player or the telling, never before (FREEZE-10's edge); SCL's
   base words equal to FREEZE-10's, letter for letter, at FREEZE-10's game length.
3. Agents through the harness: each answering every call of the plan from its words through freeze 1's execute,
   FREEZE-5's line writer, SCL's builder and a stand-in client; the log read by SCL's verdicts; the fixed agents'
   readings asserted, and equal to the fast path's.
4. Refusals, and 5. the commands, in stand-in folders through a stand-in client, catalog and frozen check.
"""

import contextlib
import hashlib
import io
import itertools
import json
import math
import random
import re
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

import scl_design as D
import scl_rule as RU
import scl_stage0 as S0
import scl_run as RUN
import run as R

D.own_files()

HERE = Path(__file__).resolve().parent
OUT = HERE / "results" / "dry-run.json"
PINS = [p["id"] for p in R.PINS["pins"]]
SLUG = {p["id"]: p["canonical_slug"] for p in R.PINS["pins"]}
CODE = [p for p in D.REQUIRED if not p.endswith("results/dry-run.json")]
TMP = {"root": None}


def code_hashes():
    return {f: hashlib.sha256((R.REPO / f).read_bytes()).hexdigest() for f in CODE}


def clean(msg):
    """A message as the result keeps it: no temporary path, no smoke folder's time, at most 240 characters."""
    msg = str(msg)
    if TMP["root"]:
        msg = msg.replace(str(TMP["root"]), "<tmp>")
    return re.sub(r"\d{8}T\d{6}Z", "<time>", msg)[:240]


def quiet(f, *a, **k):
    with contextlib.redirect_stdout(io.StringIO()):
        return f(*a, **k)


# ------------------------------------------------------------------------------------------------
# The words, parsed back (the stand-in client reads only these)

def tmpl(t):
    """A sentence template as a regular expression: each field a named group, letters [AB], numbers digits."""
    out, pos = "^", 0
    for m in re.finditer(r"\{(\w+)\}", t):
        out += re.escape(t[pos:m.start()])
        out += f"(?P<{m.group(1)}>[AB])" if m.group(1) == "L" else f"(?P<{m.group(1)}>\\d+)"
        pos = m.end()
    return re.compile(out + re.escape(t[pos:]) + "$")


RX = {w: {k: tmpl(v) for k, v in W.items() if isinstance(v, str)} for w, W in D.WORDS.items()}
NOTREAD = {w: [tmpl(v) for v in W["not_read"].values()] for w, W in D.WORDS.items()}
PROBE_RX = {w: {lab: tmpl(t) for lab, t in W["probe_opts"].items()} for w, W in D.WORDS.items()}
FRAME_OPT = re.compile(r"^([AB])\. (\d+) dollars$")


def parse(text):
    """What a call shows, from its words alone, in view_of's form."""
    paras = text.split("\n\n")
    if paras[0] == D.D10.FRAME_INTRO:
        opts = [FRAME_OPT.match(ln).groups() for ln in paras[1].split("\n")]
        assert [L for L, _ in opts] == ["A", "B"] and paras[2:] == [D.D10.FRAME_ASK, D.D10.FRAME_ANSWER]
        return {"what": "frame", "amounts": {L: int(v) for L, v in opts}}
    w = next(k for k in RX if RX[k]["game"].match(paras[0]))
    X = RX[w]
    n = int(X["game"].match(paras[0]).group("n"))
    known = other = None
    for ln in paras[1].split("\n"):
        if X["known"].match(ln):
            m = X["known"].match(ln)
            known, mid = m.group("L"), int(m.group("mid"))
        else:
            m = X["other"].match(ln) or X["other_told"].match(ln)
            assert m, ln
            other, either = m.group("L"), (int(m.group("high")), int(m.group("low")))
    assert {known, other} == {"A", "B"}
    lines = paras[2].split("\n")
    assert lines[0] == D.WORDS[w]["rounds"]
    m = X["first"].match(lines[1])
    assert m and m.group("L") == known and int(m.group("mid")) == mid
    hist, told = [(1, known, mid, True)], []
    for ln in lines[2:]:
        k = len(hist) + 1
        if X["assigned"].match(ln):
            m = X["assigned"].match(ln)
            hist.append((int(m.group("k")), m.group("L"), int(m.group("pay")), True))
        elif X["chose"].match(ln):
            m = X["chose"].match(ln)
            hist.append((int(m.group("k")), m.group("L"), int(m.group("pay")), False))
        elif X["told"].match(ln):
            m = X["told"].match(ln)
            assert int(m.group("k")) == hist[-1][0]
            told.append((m.group("L"), int(m.group("pay"))))
            continue
        else:
            m = next(r.match(ln) for r in NOTREAD[w] if r.match(ln))
            hist.append((int(m.group("k")), None, None, False))
        assert hist[-1][0] == k, ln
    v = {"round": len(hist) + 1, "known": known, "other": other, "mid": mid, "either": either, "history": hist,
         "told": told, "paraphrase": w == "paraphrase", "n": n}
    m = X["probe_ask"].match(paras[3])
    if m:
        assert int(m.group("k")) == v["round"] and m.group("L") == other and paras[5] == D.WORDS[w]["probe_answer"]
        probe = {}
        for ln in paras[4].split("\n"):
            L, rest = ln[0], ln[3:]
            assert ln[1:3] == ". " and L in D.PROBE_LETTERS
            g = PROBE_RX[w][D.BOTH].match(rest)
            if g:
                assert (int(g.group("high")), int(g.group("low"))) == either
                probe["either"] = L
                continue
            g = PROBE_RX[w][D.HIGH].match(rest)       # one amount: the high one's sentence and the low one's alike
            assert g and PROBE_RX[w][D.LOW].match(rest) and int(g.group("high")) in either, rest
            probe[int(g.group("high"))] = L
        return dict(v, what="probe", probe=probe)
    m = X["next"].match(paras[3])
    assert m and int(m.group("k")) == v["round"] and paras[4] == D.WORDS[w]["ask"], paras[3:]
    return dict(v, what="act")


def facts(v):
    """A view's facts, the words aside."""
    return {k: x for k, x in v.items() if k != "paraphrase"}


def histories(arm, k):
    """Histories for the words' checks: every answer of {known, other, declined} at each free round before k for a
    short arm; for B, the known throughout, one try at each round, and one decline at each round."""
    free = [r for r in D.free_rounds(arm) if r < k]
    if arm != "B":
        for combo in itertools.product((D.KNOWN, D.UNTRIED, D.DECLINE), repeat=len(free)):
            yield dict(zip(free, combo))
        return
    yield {r: D.KNOWN for r in free}
    for j in free:
        yield {r: (D.UNTRIED if r == j else D.KNOWN) for r in free}
        yield {r: (D.DECLINE if r == j else D.KNOWN) for r in free}


def shows_world(arm, acts, k):
    """Whether the rounds shown before k show the world: an untried act taken or chosen for the player, or a telling
    of the other option."""
    a = D.ARMS[arm]
    if any(acts.get(r) == D.UNTRIED for r in range(2, k)):
        return True
    if any(r < k and act == D.UNTRIED for r, act in a["assigned"].items()):
        return True
    return bool(a["told"] and a["told"][0] < k and a["told"][1] == D.UNTRIED)


def words():
    out = {"calls parsed per pin": {}}
    after_told = {True: 0, False: 0}
    for fam in PINS:
        recs, n = [], 0
        for x in D.plan(fam):
            p = D.build(x, recs)
            v = parse(p["user"])
            if x["condition"] == "C":
                assert v["what"] == "frame" and set(p["letters"].values()) == {D.MID, D.HIGH}
            else:
                assert v == S0.view_of(x, D.rounds(x, recs)), x["id"]
                told = D.ARMS[x["condition"]]["told"]
                after = bool(told and told[0] < x["round"])
                base = D.ARMS[x["condition"]]["words"] == "base"
                assert ("not told which at the start" in p["user"]) == after, x["id"]   # R1-2
                assert ("you have not been told which" in p["user"]) == (base and not after), x["id"]
                after_told[after] += 1
                if x["what"] == "act":
                    recs.append({"id": x["id"], "answer": random.Random(x["id"]).choice((D.KNOWN, D.UNTRIED, D.DECLINE))})
            n += 1
        out["calls parsed per pin"][fam] = n
    out["course calls whose options line says 'not told which at the start' (E2's and N2b's after the telling), "
        "and the rest 'you have not been told which', on the three pins"] = [after_told[True], after_told[False]]
    random.seed(0)
    S0.simulate(S0.Agent(rule="worst", h0=0.2, eps=0.1), random.Random("dry|views"), check=True)
    out["the fast path's views equal view_of's, every call of one run"] = True
    # the world shown exactly from the round chosen for the player or the telling, never before
    checked = 0
    for arm in D.COURSE_ARMS:
        for k in sorted(set(D.free_rounds(arm)) | set(D.ARMS[arm]["probes"])):
            for acts in histories(arm, k):
                for what in ("act", "probe"):
                    if what == "probe" and k not in D.ARMS[arm]["probes"] or what == "act" and k not in D.free_rounds(arm):
                        continue
                    for o in D.ORDERS:
                        t = {w: D.text_of({"condition": arm, "world": w, "order": o, "rep": 0, "what": what, "round": k},
                                          acts) for w in D.WORLDS}
                        assert (t[D.UP] == t[D.DOWN]) == (not shows_world(arm, acts, k)), (arm, k, acts)
                        checked += 1
    out["texts checked: the same in both worlds exactly where no untried act or telling of it is shown"] = checked
    # the paraphrase keeps every fact and shares no sentence with the base words
    base_sentences = set()
    for x in D.plan(PINS[0], ("N2a",)):
        base_sentences |= set(D.text_of(x, {r: D.KNOWN for r in D.free_rounds("N2a")}).replace("\n\n", "\n").split("\n"))
    pairs = 0
    for k in sorted(set(D.free_rounds("N3")) | set(D.ARMS["N3"]["probes"])):
        for acts in histories("N3", k):
            for what in ("act", "probe"):
                if what == "probe" and k not in D.ARMS["N3"]["probes"] or what == "act" and k not in D.free_rounds("N3"):
                    continue
                for w, o, rep in itertools.product(D.WORLDS, D.ORDERS, range(len(D.LAYOUTS))):
                    x3 = {"condition": "N3", "world": w, "order": o, "rep": rep, "what": what, "round": k}
                    t3 = D.text_of(x3, acts)
                    t2 = D.text_of(dict(x3, condition="N2a"), acts)
                    assert facts(parse(t3)) == facts(parse(t2)) and parse(t3)["paraphrase"]
                    shared = [s for s in t3.replace("\n\n", "\n").split("\n") if s in base_sentences]
                    assert not shared, shared
                    pairs += 1
    out["paraphrase pairs with every fact equal and no base sentence"] = pairs
    # SCL's base words are FREEZE-10's at FREEZE-10's length: B's course at 11 rounds announced is FREEZE-10's U
    saved = D.N_ANN
    D.N_ANN = 1 + D.D10.STEPS
    try:
        same = 0
        for w, o in itertools.product(D.WORLDS, D.ORDERS):
            for k in range(2, D.N_ANN + 1):
                for acts in histories("B", k):
                    if any(r > 11 for r in acts):
                        continue
                    ans = [acts[r] for r in range(2, k)]
                    mine = D.text_of({"condition": "B", "world": w, "order": o, "rep": 0, "what": "act", "round": k}, acts)
                    theirs = D.D10.text_of({"condition": "U", "world": w, "order": o}, ans)
                    assert mine == theirs, (w, o, k)
                    same += 1
    finally:
        D.N_ANN = saved
    out["B's words at FREEZE-10's 11 rounds equal FREEZE-10's U words, letter for letter"] = same
    assert D.build({"condition": "C", "order": 1, "family": PINS[0]})["user"] == D.D10.build({"condition": "C", "order": 1})["user"]
    out["C's words are FREEZE-10's"] = True
    return out


# ------------------------------------------------------------------------------------------------
# The rule at its edges (round 1's findings R1-1, R1-6, R1-14)

def rule_checks():
    out = {}
    # R1-1: an unread probe counts in no share of the exits: E1's round-4 probe of a locked course made unread
    # gives the same counts as that probe missing, one fewer read than the probe named
    courses, c_ans = S0.simulate(S0.Agent(rule="worst"), random.Random("dry|unread"))
    key = next(k for k, c in sorted(courses.items()) if k[0] == "E1" and k[1] == D.UP
               and RU.in_lock("E1", c["acts"], D.K0) and c["probes"].get(D.K0 + 1) == D.HIGH)
    before = RU.exit_counts(courses, "E1", D.UP)
    twin_before = RU.twin_counts(courses, "N2a", D.UP)
    courses[key]["probes"][D.K0 + 1] = D.UNREAD
    unread = RU.exit_counts(courses, "E1", D.UP)
    del courses[key]["probes"][D.K0 + 1]
    assert unread == RU.exit_counts(courses, "E1", D.UP) == (before[0] - 1, before[1] - 1), (before, unread)
    tkey = next(k for k, c in sorted(courses.items()) if k[0] == "N2a" and 4 in c["probes"]
                and RU.in_lock("N2a", c["acts"], 4))
    courses[tkey]["probes"][4] = D.UNREAD
    assert RU.twin_counts(courses, "N2a", D.UP)[1] == twin_before[1] - 1
    out["an unread probe of E1's (and of its twin's) counts in no share, as one missing"] = [list(before), list(unread)]
    # R1-6: exact ties contradict, where floating point reads them below the threshold
    t, b = (12, 15), (240, 240)
    fall, p, hit = RU.k_hit(t, b)
    assert b[0] / b[1] - t[0] / t[1] < 0.2 and fall == RU.DELTA_K and p <= RU.ALPHA / len(RU.KTESTS) and hit
    t2, b2 = (104, 624), (20, 300)
    rise, p2, hit2 = RU.s_hit(t2, b2)
    assert t2[0] / t2[1] - b2[0] / b2[1] < 0.1 and rise == RU.DELTA_S and p2 <= RU.ALPHA / len(RU.STESTS) and hit2
    out["a K fall of exactly 0.2 (12/15 against 240/240) and an S rise of exactly 0.1 (104/624 against 20/300), "
        "each below its p, contradict"] = [RU.num(p), RU.num(p2)]
    # the exact bound tests agree with the bisected bounds wherever these are not within 1e-6 of the share
    agree = 0
    for n in range(1, 61):
        for x in range(n + 1):
            for conf, up in ((RU.CONF, False), (RU.CONF_EXIT_CONTRA, True), (RU.CONF_TURN_CONTRA, True)):
                bd = RU.bound(x, n, up, conf)
                if abs(bd - 0.5) <= 1e-6:
                    continue
                exact = RU.upper_below(x, n, RU.SHARE, conf) if up else RU.lower_at_least(x, n, RU.SHARE, conf)
                assert exact == ((bd < 0.5) if up else (bd >= 0.5)), (x, n, conf, up, bd)
                agree += 1
    out["exact bound tests agreeing with the bisected bounds (n 1 to 60, every x, three confidences)"] = agree
    # R1-14: the lock is read from the rounds a record showed, not from a round made again after it
    recs = [{"id": D.call_id("dry", "N2a", D.UP, 0, 0, "act", k), "condition": "N2a", "world": D.UP, "order": 0,
             "rep": 0, "what": "act", "round": k, "family": "dry", "answer": D.KNOWN} for k in (2, 4)]
    again = dict(recs[0], answer=D.UNTRIED)
    log = recs + [again]
    shown = RU.courses_of([again, recs[1]], log)[0]
    latest = RU.courses_of([again, recs[1]])[0]
    assert RU.hazard(shown, "N2a", (4,)) == (0, 1) and RU.hazard(latest, "N2a", (4,)) == (0, 0)
    out["a round-4 record showing round 2 known, round 2 made again untried after it: at risk at round 4 by the "
        "rounds it showed, not by the latest records"] = True
    # R2-2: an S contradiction is laid on bridge (ii) only where the listing shows no shift between its two sides.
    # M's courses, with half of N2a's courses trying at round 4 (S N2a contradicts, nothing else in S does); then a
    # shift K does not see: N2a's probes before 4 and 7 name 8 in one course in twelve, B's name 2 in one in six,
    # every matching K comparison read with a fall under 0.2
    def planted(shifted):
        cs, ca = S0.simulate(S0.Agent(rule="worst"), random.Random("dry|laid"))
        for (arm, w, o, rep), c in cs.items():
            if arm == "N2a" and rep < 6:
                c["acts"][4] = D.UNTRIED
            if shifted and arm == "N2a" and rep == 11:
                c["probes"][4] = c["probes"][7] = D.HIGH
            if shifted and arm == "B" and rep in (10, 11):
                c["probes"][4] = c["probes"][7] = D.LOW
        return RU.reading(cs, ca)
    laid = {}
    for shifted in (False, True):
        res = planted(shifted)
        assert res["S"]["contradicting"] == ["S N2a an assigned known round"], res["S"]["contradicting"]
        row = next(r for r in res["S"]["comparisons"] if r["comparison"] == "S N2a an assigned known round")
        km = row["the stated listing beside it"]["matching K comparisons"]
        assert all(v == "read, no fall" for v in km.values()) and len(km) == 4, km
        sh = row["the stated listing beside it"]["a shift of the listing between the sides (Fisher-Freeman-Halton)"]
        assert sh["read"] and sh["seen"] == shifted, sh
        laid[shifted] = res["S"]["laid on"]["S N2a an assigned known round"]
        if shifted:
            assert row["the stated listing beside it"]["test"][D.HIGH] == 8 and \
                row["the stated listing beside it"]["base"][D.LOW] == 16
    assert laid == {False: RU.LAID_II, True: RU.LAID_I_OR_II}, laid
    out["an S contradiction with every matching K comparison read and none contradicting: laid on bridge (ii) "
        "with the listing unshifted, on (i) or (ii) where it shifts from naming 2 toward naming 8"] = \
        {"unshifted": laid[False], "shifted": laid[True]}
    # the exact Fisher-Freeman-Halton p against a direct sum of hypergeometric chances in floating point
    for t, b in (((5, 3, 2), (2, 6, 4)), ((64, 8, 0), (80, 0, 16)), ((10, 0, 0), (9, 1, 0)), ((3, 3, 3), (3, 3, 3))):
        p = RU.ffh_two_sided(list(t), list(b))
        cols = [x + y for x, y in zip(t, b)]
        nt, N = sum(t), sum(cols)
        pr = lambda r: math.prod(math.comb(c, a) for a, c in zip(r, cols)) / math.comb(N, nt)
        tabs = [(a, c2, nt - a - c2) for a in range(cols[0] + 1) for c2 in range(cols[1] + 1)
                if 0 <= nt - a - c2 <= cols[2]]
        assert abs(sum(pr(r) for r in tabs) - 1) < 1e-9
        direct = sum(pr(r) for r in tabs if pr(r) <= pr(t) * (1 + 1e-9))
        assert abs(float(p) - direct) < 1e-9, (t, b, float(p), direct)
    out["the exact Fisher-Freeman-Halton p equal to a direct sum on four tables"] = True
    return out


# ------------------------------------------------------------------------------------------------
# The stand-in client

def response(content=None, finish="stop", refusal=None, model=None, request=None):
    msg = {"content": content}
    if refusal:
        msg["refusal"] = refusal
    return {"model": model or request["model"], "choices": [{"message": msg, "finish_reason": finish}],
            "usage": {"prompt_tokens": len(request["messages"][0]["content"]) // 4, "completion_tokens": 9, "cost": 0.0}}


class Stub:
    """A stand-in for freeze 1's OpenRouterClient: the agent answers from the parsed words, its draws seeded by the
    call's id; "invalid", "decline", "filtered", "limit", "reject" and "other model" give those responses."""
    live = False

    def __init__(self, agent, key="stub", force=None):
        self.agent, self.key, self.force, self.calls = agent, key, force, 0

    def call(self, request, meta):
        self.calls += 1
        v = parse(request["messages"][0]["content"])
        a = (self.force(meta) if self.force else None) or self.agent(v, random.Random(f"{self.key}|{meta['id']}"))
        enum = request["response_format"]["json_schema"]["schema"]["properties"]["choice"]["enum"]
        if a in enum:
            return {"response": response(json.dumps({"choice": a}), request=request), "attempts": 1, "errors": []}
        r = {"invalid": lambda: response("I would take the first one.", request=request),
             "decline": lambda: response(json.dumps({"choice": "decline"}), request=request),
             "filtered": lambda: response(None, finish="content_filter", request=request),
             "limit": lambda: response('{"choice": "', finish="length", request=request),
             "reject": lambda: {"rejected": {"status": 403, "body": "flagged"}},
             "other model": lambda: response(json.dumps({"choice": enum[0]}), model="other/model", request=request)}[a]()
        return {"response": r, "attempts": 1, "errors": []}


def dry_folder(root, name, family):
    out = Path(root) / name
    out.mkdir(parents=True)
    RUN.write_whole(out / "meta.json", json.dumps({"kind": "dry", "test": D.TEST, "family": family, "seed": D.SEED,
                                                   "links": {}}) + "\n")
    return out


def run_agent(root, name, agent, family, conditions=D.CONDITIONS, key=None, force=None):
    out = dry_folder(root, name, family)
    sink, done = RUN.open_sink(out)
    R.execute(D.plan(family, conditions), Stub(agent, key or name, force), sink, R.SpendGuard(1e9, 10 ** 9), done, 1,
              catalog=lambda f: SLUG[f], link="dry", prepare=D.preparer(sink.records), classify=D.classify)
    return out


# Agents through the harness: (name, settings, what must be read: verdict -> status). Those of Stage 0's AGENTS are
# read as Stage 0 fixes them; a deterministic one's reading is asserted equal to the fast path's.
FIXED = {n: (kw, want) for n, kw, _, want in S0.AGENTS}
HARNESS = [(n, FIXED[n][0], FIXED[n][1]) for n in (
    "M, the witness (worst case, 8 > 5 > 2)", "O, the witness with the order 5 > 8 > 2",
    "count lock (the option chosen most; tellings not taken in)", "prior-narrowing reader (rho 0.1 a round)",
    "first-listed reader", "declining every call")] + [
    ("history-length explorer, 0.02 + 0.04 a round", dict(rule="worst", h0=0.02, slope=0.04, eps=S0.EPS),
     {"S": "contradicted"}),
    ("word reader, tries 0.3 more reworded", dict(rule="worst", h0=0.05, par_h=0.3, eps=S0.EPS), {"S": "contradicted"}),
    ("M trembling 0.05", dict(rule="worst", h0=0.05, eps=S0.EPS),
     {"K": "passed", "S": "passed", "E1": "supported", "E2": "supported"})]


def deterministic(kw):
    return not any(kw.get(k) for k in ("h0", "slope", "par_h", "rho", "par_rho", "eps", "unread")) \
        and kw.get("rule") not in ("egreedy", "thompson")


def harness(root):
    rows = []
    for j, (name, kw, want) in enumerate(HARNESS):
        fam = PINS[j % len(PINS)]
        agent = S0.Agent(**kw)
        out = run_agent(root, f"h{j:02d}", agent, fam, key=f"dry|{name}")
        res = quiet(RUN.verdicts, out, check=lambda repo=None: {"link": "dry"}, allow_dry=True)
        summ = res["reading"]["summary"]
        assert not res["rounds_not_the_answers_read"], name
        assert S0.meets(summ, want), (name, summ, want)
        same = deterministic(kw)
        if same:
            fast = RU.reading(*S0.simulate(agent, random.Random("dry|fast")))["summary"]
            assert fast == summ, (name, fast, summ)
        rows.append({"agent": name, "pin": fam, "records": len(R.logged(out)), "summary": summ,
                     "asserted": sorted(want), "asserted equal to the fast path (no draw)": same})
    return rows


# ------------------------------------------------------------------------------------------------
# 4. Refusals

def refused(f, *a, want, **k):
    try:
        quiet(f, *a, **k)
    except SystemExit as e:
        msg = str(e)
    except (RuntimeError, AssertionError) as e:
        msg = f"{type(e).__name__}: {e}"
    else:
        raise AssertionError(f"not refused: {want}")
    assert want in msg, (want, msg)
    return clean(msg)


def refusals(root):
    out = []
    names = set()

    def note(name, msg):
        assert name not in names, name
        names.add(name)
        out.append({"check": name, "refused": clean(msg)})

    dry = lambda repo=None: {"link": "dry"}
    fam = PINS[0]
    base = run_agent(root, "r-base", S0.Agent(rule="worst", h0=0.1, eps=0.05), fam, key="dry|base")
    recs = R.logged(base)

    def copy(name, edit):
        d = Path(root) / name
        shutil.copytree(base, d)
        rs = [json.loads(ln) for ln in (d / "calls.jsonl").read_text().splitlines() if ln.strip()]
        edit(rs)
        (d / "calls.jsonl").write_text("".join(RUN.T1.escaped(json.dumps(r, ensure_ascii=False)) + "\n" for r in rs))
        return d

    # the freeze's own check: FROZEN.sha256 missing (the real folder, not yet frozen), wrong, or short of a file
    note("FROZEN.sha256 missing (this folder before its freeze)", refused(D.frozen, want="no FROZEN.sha256"))
    fake = Path(root) / "fake-repo"
    for p in D.REQUIRED:
        (fake / p).parent.mkdir(parents=True, exist_ok=True)
        if (R.REPO / p).exists():
            shutil.copyfile(R.REPO / p, fake / p)
        else:
            (fake / p).write_text("{}\n")
    good = {p: hashlib.sha256((fake / p).read_bytes()).hexdigest() for p in D.REQUIRED}
    hf = fake / D.FOLDER / "FROZEN.sha256"
    hf.write_text("".join(f"{good[p]}  {p}\n" for p in D.REQUIRED))
    assert D.own_check(fake) == good
    wrong = dict(good, **{D.REQUIRED[0]: "0" * 64})
    hf.write_text("".join(f"{wrong[p]}  {p}\n" for p in D.REQUIRED))
    note("FROZEN.sha256 naming a file's wrong hash", refused(D.own_check, fake, want="differ from FROZEN.sha256"))
    hf.write_text("".join(f"{good[p]}  {p}\n" for p in D.REQUIRED[1:]))
    note("FROZEN.sha256 not listing a file the freeze requires", refused(D.own_check, fake, want="does not list"))
    # python3 -O
    for m in D.MODULES:
        p = subprocess.run([sys.executable, "-O", "-B", "-c", f"import {m}"], cwd=HERE, capture_output=True, text=True)
        assert p.returncode != 0 and "python3 -O" in p.stderr, (m, p.stderr[-300:])
    note("any module of the folder under python3 -O", f"each of the {len(D.MODULES)} refuses to load")
    # the reading's refusals
    def bad_round(rs):
        k = next(i for i, r in enumerate(rs) if r["condition"] == "E1" and r.get("round") == 5)
        rs[k]["prompt"] = rs[k]["prompt"].replace("Round 2: you chose", "Round 2: you picked", 1)
    note("a course's logged prompt not the one its records rebuild",
         refused(RUN.verdicts, copy("r-round", bad_round), check=dry, allow_dry=True, want="prompt"))

    def other_answer(rs):
        k = next(i for i, r in enumerate(rs) if r["what"] == "probe")
        rs[k]["answer"] = D.HIGH if rs[k]["answer"] != D.HIGH else D.LOW
    note("a logged answer the parser does not read from its response",
         refused(RUN.verdicts, copy("r-answer", other_answer), check=dry, allow_dry=True, want="not the one the parser reads"))

    def extra(rs):
        r = dict(rs[-1])
        r["id"] = r["id"] + "|extra"
        rs.append(r)
    note("an enlarged log: a record not in the plan",
         refused(RUN.verdicts, copy("r-extra", extra), check=dry, allow_dry=True, want="not in the plan"))

    def drop(rs):
        del rs[-1]
    note("a run not read whole", refused(RUN.verdicts, copy("r-short", drop), check=dry, allow_dry=True, want="not read whole"))

    def swap(rs):
        i1 = next(i for i, r in enumerate(rs) if r["condition"] == "B" and r.get("round") == 2 and r["what"] == "act")
        same = lambda r: D.course_key(r) == D.course_key(rs[i1]) and r["what"] == "act"
        i2 = next(i for i, r in enumerate(rs) if same(r) and r.get("round") == 3)
        rs[i1], rs[i2] = rs[i2], rs[i1]
    note("a course's round logged before the round it shows",
         refused(RUN.verdicts, copy("r-order", swap), check=dry, allow_dry=True, want="logged before an earlier round"))

    def pin_moved(rs):
        for r in rs:
            r["family"] = D.N5_PROPOSED["family"]
    d = copy("r-pin", pin_moved)
    meta = json.loads((d / "meta.json").read_text())
    meta["family"] = D.N5_PROPOSED["family"]
    (d / "meta.json").write_text(json.dumps(meta) + "\n")
    note("a log of a family off the frozen pins (N5's sibling)",
         refused(RUN.verdicts, d, check=dry, allow_dry=True, want="is not a frozen pin"))
    note("a command for a family off the frozen pins", refused(RUN.main, ["status", "--family", D.N5_PROPOSED["family"]],
                                                                 want="is not a frozen pin"))
    # the rounds check reports a course record whose rounds show an answer other than the one read; never refuses
    s1 = next(r for r in recs if r["condition"] == "N2a" and r.get("round") == 2 and r["what"] == "act")
    s2 = next(r for r in recs if D.course_key(r) == D.course_key(s1) and r.get("round") == 4 and r["what"] == "act")
    again = dict(s1, answer=D.UNTRIED if s1["answer"] != D.UNTRIED else D.KNOWN)
    flagged = RUN.rounds_apart(fam, [again, s2], [s1, s2, again])
    assert flagged == [s2["id"]] and RUN.rounds_apart(fam, [s1, s2], [s1, s2]) == []
    note("a course record whose rounds show an answer other than the one read (reported, not refused)",
         f"flagged {len(flagged)}; a course whose rounds match is not")
    # a course's call whose earlier round has no record: execute stops there
    g = dry_folder(root, "r-gap", fam)
    sink, done = RUN.open_sink(g)
    calls = [x for x in D.plan(fam, ("E2",)) if x.get("round") == 4][:1]
    note("a course's call whose earlier round has no record",
         refused(R.execute, calls, Stub(S0.Agent()), sink, R.SpendGuard(1e9, 10 ** 9), done, 1, catalog=lambda f: SLUG[f],
                 link="dry", prepare=D.preparer(sink.records), classify=D.classify, want="has no record"))
    # a readout written once
    d = copy("r-once", lambda rs: None)
    quiet(RUN.verdicts, d, check=dry, allow_dry=True)
    note("a second readout of a folder", refused(RUN.verdicts, d, check=dry, allow_dry=True, want="is written, once"))
    return out


# ------------------------------------------------------------------------------------------------
# 5. The commands

def commands(root):
    out = []
    names = set()

    def note(name, msg):
        assert name not in names, name
        names.add(name)
        out.append({"check": name, "result": clean(msg)})

    root = Path(root) / "commands"
    root.mkdir()
    hashes = {RUN.CLIENT_FILE: "0" * 64, "lock-scl/scl_run.py": "1" * 64}
    fc = {"link": "FROZEN.sha256", "link_commit": "c0", "freeze_commit": "c0", "hashes": hashes, "head": "h0",
          "chain": {"FROZEN.sha256": hashes}, "commits": {"FROZEN.sha256": "c0"}}
    saved = (RUN.ROOT, RUN.CLIENT, RUN.CATALOG, RUN.frozen)
    beh = {"agent": S0.Agent(rule="worst", h0=0.05, eps=0.05), "force": None}
    RUN.ROOT, RUN.CATALOG, RUN.frozen = root, (lambda f: SLUG[f]), (lambda repo=None: fc)
    RUN.CLIENT = lambda: Stub(lambda v, r: beh["agent"](v, r), "cmd", lambda m: beh["force"] and beh["force"](m))

    def main(*args):
        try:
            quiet(RUN.main, list(args))
        except SystemExit as e:
            return e.code if isinstance(e.code, int) else str(e.code)
        return 0

    try:
        fam = PINS[0]
        note("run before any smoke run", main("run", "--family", fam, "--max-usd", "9"))
        assert "no smoke run" in out[-1]["result"]
        assert main("smoke", "--family", fam, "--max-usd", "1") == 0
        rep = RUN.read_json(RUN.smoke_folders(fam)[-1] / "smoke-report.json")
        assert rep["calls"] == len(D.plan(fam, smoke=True)) and rep["projected_full_design"]["calls"] == len(D.plan(fam)) \
            and rep["go_on"]
        note("a smoke run that passes", f"{rep['calls']} calls, projecting {rep['projected_full_design']['calls']}; "
                                        f"readability {rep['readability']['starts']}")
        note("smoke where the latest smoke run passed", main("smoke", "--family", fam, "--max-usd", "1"))
        assert "no smoke run of" in out[-1]["result"]
        note("the arms asked at a parallel above 1",
             main("run", "--family", fam, "--conditions", "B,E1", "--max-usd", "9", "--parallel", "4"))
        assert "parallel 1" in out[-1]["result"]
        note("an unknown condition", main("run", "--family", fam, "--conditions", "C,N5", "--max-usd", "9"))
        assert "unknown condition" in out[-1]["result"]
        assert main("run", "--family", fam, "--conditions", "C", "--max-usd", "50", "--parallel", "4") == 0
        assert RUN.read_whole(fam, "C")
        killed = {"n": 0}

        class Killing(Stub):
            def call(self, request, meta):
                killed["n"] += 1
                if killed["n"] == 750:
                    raise KeyboardInterrupt
                return super().call(request, meta)
        RUN.CLIENT = lambda: Killing(lambda v, r: beh["agent"](v, r), "cmd")
        try:
            quiet(RUN.main, ["run", "--family", fam, "--max-usd", "50"])
        except KeyboardInterrupt:
            pass
        RUN.CLIENT = lambda: Stub(lambda v, r: beh["agent"](v, r), "cmd", lambda m: beh["force"] and beh["force"](m))
        out_f = RUN.scored(fam)
        note("verdicts on a run not read whole", main("verdicts", "--family", fam))
        assert "not read whole" in out[-1]["result"]
        with (out_f / "calls.jsonl").open("ab") as fh:
            fh.write(b'{"id": "scl|half')
        note("run on a log cut short", main("run", "--family", fam, "--max-usd", "50"))
        assert "a write cut short" in out[-1]["result"]
        assert main("mend", "--family", fam, "--cause", "a kill") == 0
        cat = (out_f / "catalog.jsonl").read_bytes()          # and the catalog's last read cut, then mended
        (out_f / "catalog.jsonl").write_bytes(cat[:cat[:-1].rfind(b"\n") + 12])
        assert main("mend", "--family", fam, "--cause", "a kill") == 0
        before = len(R.logged(out_f))
        assert main("run", "--family", fam, "--max-usd", "50") == 0
        assert all(RUN.read_whole(fam, c) for c in D.CONDITIONS)
        st = quiet(RUN.status, fam)
        assert st["logged"] >= st["planned"] and not st["readout"]
        assert main("verdicts", "--family", fam) == 0
        v = RUN.read_json(out_f / RUN.READOUT)
        assert v["calls_made_again"] > 0 and not v["rounds_not_the_answers_read"]
        note("the arms killed, the logs cut and mended, and resumed at parallel 1",
             f"{before} records before the resume, {len(R.logged(out_f))} after; {v['calls_made_again']} calls made again; "
             f"no round shows an answer other than the one read; {v['reading']['summary']}")
        note("a second readout", main("verdicts", "--family", fam))
        assert "is written, once" in out[-1]["result"]
        note("run after the readout", main("run", "--family", fam, "--conditions", "C", "--max-usd", "50"))
        assert "no further call" in out[-1]["result"]
        note("smoke after the readout", main("smoke", "--family", fam, "--max-usd", "1"))
        assert "no further call" in out[-1]["result"]
        # a second pin whose answers cannot be read often enough: its smoke run passes, the readability rule stops it
        fam2 = PINS[1]
        cnt = {"n": 0}

        def some_prose(meta):
            cnt["n"] += 1
            return "invalid" if cnt["n"] % 6 == 0 else None
        beh["force"] = some_prose
        code = main("smoke", "--family", fam2, "--max-usd", "1")
        rep2 = RUN.read_json(RUN.smoke_folders(fam2)[-1] / "smoke-report.json")
        assert code == 2 and rep2["stops"]["passed"] and not rep2["readability"]["starts"]
        note("a smoke run with one answer in six unreadable", f"stops {rep2['stops']['passed']}; readability {rep2['readability']}")
        note("run where the readability rule stops the pin", main("run", "--family", fam2, "--max-usd", "50"))
        assert "cannot be read often enough" in out[-1]["result"]
        # a third pin: a smoke run a provider's filter stops, a stop of the run
        fam3 = PINS[2]
        beh["force"] = lambda m: "filtered" if m["id"].endswith("|p02") and m["condition"] == "B" else None
        code = main("smoke", "--family", fam3, "--max-usd", "1")
        assert code == 2
        note("run after a smoke run a filter stopped", main("run", "--family", fam3, "--max-usd", "50"))
        assert "a stop of the run" in out[-1]["result"]
        beh["force"] = None
        with RUN.pin_lock(fam3):
            note("a command while another holds the pin's lock", main("verdicts", "--family", fam3))
        assert "another command" in out[-1]["result"]
    finally:
        RUN.ROOT, RUN.CLIENT, RUN.CATALOG, RUN.frozen = saved
    return out


# ------------------------------------------------------------------------------------------------

def newest(folder):
    """The newest link of a freeze's chain in folder, by the files there (base, then addenda/FROZEN-k.sha256 while
    each exists): {path: sha256}. The chain itself is checked by freeze 1's frozen_check at run time."""
    f = R.REPO / D.REL / folder
    link = f / "FROZEN.sha256"
    k = 1
    while (f / "addenda" / f"FROZEN-{k}.sha256").exists():
        link, k = f / "addenda" / f"FROZEN-{k}.sha256", k + 1
    return dict(reversed(ln.split()) for ln in link.read_text().splitlines() if ln.strip())


def owner(path):
    """The freeze that owns an imported file: freeze 1 (told/, tr8.py, tr_rr.py), FREEZE-5 (told-tr1/, tr1.py,
    tr1.json) or FREEZE-10 (told-tr1a/)."""
    rel = path[len(D.REL):]
    if rel.startswith("told/") or rel in ("tr8.py", "tr_rr.py"):
        return "told"
    if rel.startswith("told-tr1/") or rel in ("tr1.py", "tr1.json"):
        return "told-tr1"
    assert rel.startswith("told-tr1a/"), path
    return "told-tr1a"


def main():
    start = code_hashes()
    t10 = newest("told-tr1a")
    own = {f: newest(f) for f in ("told", "told-tr1", "told-tr1a")}
    assert all(start[f] == t10[f] for f in D.IMPORTED), "the imported files have FREEZE-10's hashes"
    assert all(start[f] == own[owner(f)][f] for f in D.IMPORTED), "the imported files have their own freezes' hashes"
    root = Path(tempfile.mkdtemp(prefix="scl-dry-"))
    TMP["root"] = root
    try:
        mirror = S0.mirror()
        assert mirror["all pass"]
        fixed = S0.fixed_agents()
        rc = rule_checks()
        w = words()
        rows = harness(root)
        refs = refusals(root)
        cmds = commands(root)
    finally:
        shutil.rmtree(root, ignore_errors=True)
        TMP["root"] = None
    power = S0.power()
    for row in power:          # the permitted settings are contradicted rarely; asserted at the frozen size
        if row["role"].startswith("permitted"):
            for v in S0.VERDICTS:
                assert row["shares"][v].get("contradicted", 0) <= 0.05, (row["setting"], v)
        if row["role"].startswith("at the exits' boundary"):     # R1-5: at most ALPHA, at the power's resolution
            for v in ("E1", "E2"):
                assert row["shares"][v].get("contradicted", 0) <= 0.02, (row["setting"], v)
        if row["setting"].startswith("late trier"):              # R1-4: a late trier's turn is not read as one
            for v in ("T after E1", "T after E2"):
                assert row["shares"][v].get("supported", 0) <= 0.05, (row["setting"], v)
            # R2-1: and its rise from round 4 is caught by N1's middle comparison, the later left unread; R3-1: a
            # step from round 3, which sits in the middle comparison's base, by B's round 3 over its round 2
            assert row["shares"]["S"].get("contradicted", 0) >= 0.95, row["setting"]
            by, least = ("S N1 more rounds, 4 to 8 over 2 and 3", 0.95) if "from round 4" in row["setting"] \
                else ("S N1 more rounds, 3 over 2", 0.9)
            assert row["comparisons contradicting, share of runs"].get(by, 0) >= least, row["setting"]
    res = {"test": D.TEST, "seed": D.SEED, "python": "%d.%d" % sys.version_info[:2],
           "design": {"calls per pin": len(D.plan(PINS[0])), "pins": len(PINS),
                      "calls on the three pins": len(D.plan(PINS[0])) * len(PINS),
                      "calls by condition": S0.call_counts(), "announced rounds": D.N_ANN, "exit round": D.K0,
                      "courses per arm, world and name order": D.REPS,
                      "rule": {"alpha per verdict": float(RU.ALPHA), "delta K": float(RU.DELTA_K),
                               "delta S": float(RU.DELTA_S), "share": float(RU.SHARE),
                               "start min": float(RU.START_MIN), "n min": RU.N_MIN, "n min at risk": RU.N_MIN_RISK,
                               "support bounds": float(RU.CONF), "an exit's world contradicts at":
                               float(RU.CONF_EXIT_CONTRA), "the turn contradicts at": float(RU.CONF_TURN_CONTRA),
                               "probe layouts": [list(l) for l in D.LAYOUTS]}},
           "stage 0": {"mirror": mirror, "agents with fixed answers": fixed},
           "the rule at its edges": rc,
           "power (runs per setting: %d)" % S0.SIMS: power,
           "readability rule: chance of stopping a pin": {
               f"{u}": {"at the smoke run (%d calls)" % len(D.plan(PINS[0], smoke=True)):
                        RU.readability_stop_chance(u, len(D.plan(PINS[0], smoke=True))),
                        "after B's and the short arms' first 400 calls": RU.readability_stop_chance(u, 400)}
               for u in (0.005, 0.01, 0.02, 0.03, 0.05)},
           "words": w, "agents through the harness": rows, "refusals": refs, "commands": cmds,
           "estimate": {f: RUN.estimate(f) for f in PINS},
           "code_hashes": start, "code_unchanged_during_the_run": code_hashes() == start, "ok": True}
    OUT.parent.mkdir(exist_ok=True)
    RUN.write_whole(OUT, json.dumps(res, indent=1, ensure_ascii=False, sort_keys=False) + "\n")
    print(f"{len(fixed)} fixed agents, {len(rows)} through the harness, {len(refs)} refusals, {len(cmds)} command checks, "
          f"{len(power)} power settings")


if __name__ == "__main__":
    main()
