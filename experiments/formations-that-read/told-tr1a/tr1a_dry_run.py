"""TR1A's dry run (FREEZE-9.md, section 10): the frozen code path end to end, with no model call, no key and
no network. Writes results/dry-run.json; every figure the text gives from the dry run is read from it.

    python3 -B tr1a_dry_run.py          # under a minute on one idle core

1. Formations: REST-TR1 section 8's identification table, each formation answering every call of the plan
   through freeze 1's execute, FREEZE-5's line writer and parser, this freeze's call builder and a
   stand-in client that reads only the words a call shows (the options as told, the rounds so far, the
   amounts listed); the log read by this freeze's load, through freeze 1's verdicts.load, and by the
   rule. Each reads as REST-TR1's table says (FORMS), asserted.
2. V1's exact power (tr1a_rule.power).
3. The prompts: every planned call of the three pins parsed from its text alone, and an uninformed
   course's words the same in both worlds until the other option is taken.
4. Refusals and 5. the commands, in stand-in folders through a stand-in client, catalog and frozen check.
6. Stage A, without its outcome: each class's gradients checked against finite differences at a start;
   the item-score class trained and read on seeds of its own (it is one order by construction); a
   hand-set cyclic comparator read as contradicted, a hand-set item-score as passed; no comparator and no
   set-input network trained on any seed.
"""

import contextlib
import io
import json
import random
import re
import shutil
import subprocess
import sys
import tempfile
import time
from fractions import Fraction
from pathlib import Path

import tr1a_design as D
import tr1a_rule as TR
import tr1a_run as RUN
import tr1a_stage_a as SA
import tr1
import run as R
from conditions import DECLINE
from rule import FILTERED, INVALID

D.own_files()

HERE = Path(__file__).resolve().parent
OUT = HERE / "results" / "dry-run.json"
PINS = [p["id"] for p in R.PINS["pins"]]
FAM = PINS[0]
SLUG = {p["id"]: p["canonical_slug"] for p in R.PINS["pins"]}
T0 = time.time()
REL = "experiments/formations-that-read/"
# Every file this freeze fixes but the dry run's result (FREEZE-9.md, section 15): its own code; Stage 0;
# freeze 1's files it imports and PINS.json; FREEZE-5's files it imports.
FILES = [REL + f for f in ("tr1.py", "tr1.json", "tr8.py", "tr_rr.py")] + \
        [REL + "told/" + f for f in ("client.py", "conditions.py", "prompts.py", "rule.py", "run.py", "verdicts.py",
                                     "PINS.json")] + \
        [REL + "told-tr1/" + f for f in ("tr1_design.py", "tr1_rule.py", "tr1_run.py")] + \
        [REL + "told-tr1a/" + f for f in ("tr1a_design.py", "tr1a_rule.py", "tr1a_run.py", "tr1a_stage_a.py",
                                          "tr1a_dry_run.py", "write_frozen.py")]


def code_hashes():
    import hashlib
    return {f: hashlib.sha256((R.REPO / f).read_bytes()).hexdigest() for f in FILES}


def quiet(f, *a, **k):
    with contextlib.redirect_stdout(io.StringIO()):
        return f(*a, **k)


# ------------------------------------------------------------------------------------------------
# The stand-in client: it reads only the call's text

FRAME_OPT = re.compile(r"^([AB])\. (\d+) dollars$")
KNOWN_OPT = re.compile(r"^([AB])\. pays (\d+) dollars every round\.$")
OTHER_U = re.compile(r"^([AB])\. pays either (\d+) dollars every round or (\d+) dollars every round\. ")
OTHER_I = re.compile(r"^([AB])\. pays (\d+) dollars every round in this game\.$")
FIRST = re.compile(r"^Round 1: ([AB]) was chosen for you, and it paid (\d+) dollars\.$")
CHOSE = re.compile(r"^Round (\d+): you chose ([AB]), and it paid (\d+) dollars\.$")
NOTHING = re.compile(r"^Round (\d+): .*nothing was paid\.$")
CHECK = re.compile(r"^Before you choose: how many dollars does option ([AB]) pay each round in this game\?")


def parse(text):
    """What a call shows, from its words alone: a frame's two amounts by letter; a game's options (the
    known one and its amount, the other and what it was said to pay), the rounds so far (the letter
    chosen and what it paid, or None), and whether it is the check."""
    paras = text.split("\n\n")
    if paras[0].startswith("Below are two amounts"):
        opts = [FRAME_OPT.match(ln).groups() for ln in paras[1].split("\n")]
        assert [L for L, _ in opts] == ["A", "B"]
        return {"kind": "frame", "amounts": {L: int(v) for L, v in opts}}
    assert paras[0].startswith("You are playing a game of ")
    known = other = told = None
    either = None
    for ln in paras[1].split("\n"):
        if KNOWN_OPT.match(ln):
            known, mid = KNOWN_OPT.match(ln).group(1), int(KNOWN_OPT.match(ln).group(2))
        elif OTHER_I.match(ln):
            other, told = OTHER_I.match(ln).group(1), int(OTHER_I.match(ln).group(2))
        elif OTHER_U.match(ln):
            m = OTHER_U.match(ln)
            other, either = m.group(1), (int(m.group(2)), int(m.group(3)))
        else:
            raise AssertionError(ln)
    rounds_ = paras[2].split("\n")
    assert rounds_[0] == "The rounds so far:" and FIRST.match(rounds_[1]).group(1) == known
    seen = []
    for k, ln in enumerate(rounds_[2:], 2):
        if CHOSE.match(ln):
            m = CHOSE.match(ln)
            assert int(m.group(1)) == k
            seen.append((m.group(2), int(m.group(3))))
        else:
            assert NOTHING.match(ln) and int(NOTHING.match(ln).group(1)) == k, ln
            seen.append((None, None))
    check = CHECK.match(paras[3])
    if check:
        assert check.group(1) == other
    else:
        assert paras[3] == f"Round {len(seen) + 2} is next. Which option do you choose?"
    return {"kind": "check" if check else "course", "known": known, "other": other, "mid": mid, "told": told,
            "either": either, "rounds": seen}


def response(content=None, finish="stop", refusal=None, model=None, request=None, usage=None):
    """A response in OpenRouter's shape, as FREEZE-5's dry run builds one."""
    msg = {"content": content}
    if refusal:
        msg["refusal"] = refusal
    return {"model": model or request["model"], "choices": [{"message": msg, "finish_reason": finish}],
            "usage": usage or {"prompt_tokens": len(request["messages"][0]["content"]) // 4, "completion_tokens": 9,
                               "cost": 0.0}}


class Stub:
    """A stand-in for freeze 1's OpenRouterClient: decide(seen, meta) gives a letter, an amount (for the
    check, as a number), or one of "invalid", "refusal", "decline", "filtered", "limit", "reject",
    "other model"."""
    live = False

    def __init__(self, decide):
        self.decide, self.calls = decide, 0

    def call(self, request, meta):
        self.calls += 1
        text = request["messages"][0]["content"]
        seen = parse(text)
        a = self.decide(seen, meta)
        enum = request["response_format"]["json_schema"]["schema"]["properties"]["choice"]["enum"]
        resp = response
        if isinstance(a, (str, int)) and str(a) in enum:
            return {"response": resp(json.dumps({"choice": str(a)}), request=request), "attempts": 1, "errors": []}
        r = {"invalid": lambda: resp("I would take the first one.", request=request),
             "refusal": lambda: resp(None, refusal="I will not choose.", request=request),
             "decline": lambda: resp(json.dumps({"choice": "decline"}), request=request),
             "filtered": lambda: resp(None, finish="content_filter", request=request),
             "limit": lambda: resp('{"choice": "', finish="length", request=request),
             "reject": lambda: {"rejected": {"status": 403, "body": "flagged"}},
             "other model": lambda: resp(json.dumps({"choice": enum[0]}), model="other/model", request=request)}[a]()
        return {"response": r, "attempts": 1, "errors": []}


# ------------------------------------------------------------------------------------------------
# 1. Formations: REST-TR1 section 8's identification table

RANK, RANK2 = tr1.RANK, tr1.RANK2


class Formation:
    """A formation of the table, answering from the words alone. loop: "worst" (tr1.by_worst), "ev" (with
    prior on down), "max", "known" (the default reader) or "first" (the first-listed reader); believes:
    whether the telling is taken in; frame: "rank" (by crank) or "first". eps, a tremble to the other
    letter or a wrong amount; inv, an unreadable answer; both drawn per call from a seeded draw."""

    def __init__(self, loop, rank=RANK, believes=True, frame="rank", crank=None, prior=None, eps=0.0, inv=0.0,
                 key="f", special=None):
        self.loop, self.rank, self.believes, self.frame = loop, rank, believes, frame
        self.crank, self.prior, self.eps, self.inv, self.special = crank or rank, prior, eps, inv, special
        self.rng = random.Random(f"{D.SEED}|dry|{key}")

    def __call__(self, seen, meta):
        if self.special:
            return self.special(seen, meta)
        if self.inv and self.rng.random() < self.inv:
            return "invalid"
        flip = self.eps and self.rng.random() < self.eps
        if seen["kind"] == "frame":
            am = seen["amounts"]
            if self.frame == "first":
                pick = "A"
            else:
                pick = max(am, key=lambda L: self.crank[self._val(am[L], am)])
            return ({"A": "B", "B": "A"}[pick]) if flip else pick
        a = self._amounts(seen)
        if seen["kind"] == "check":
            right = seen["told"] if self.believes else (a[tr1.LOW] if seen["told"] == a[tr1.HIGH] else a[tr1.HIGH])
            if flip:
                right = a[tr1.MID]
            return right
        act = self._act(seen, a)
        letter = seen["known"] if act == tr1.KNOWN else seen["other"]
        if self.loop == "first":
            letter = "A"
        return ({"A": "B", "B": "A"}[letter]) if flip else letter

    def _amounts(self, seen):
        if seen["either"]:
            hi, lo = seen["either"]
        else:
            hi, lo = (seen["told"], 2 * seen["mid"] - seen["told"])
            hi, lo = max(hi, lo), min(hi, lo)
        return {tr1.LOW: lo, tr1.MID: seen["mid"], tr1.HIGH: hi}

    def _val(self, dollars, am):
        """A frame's amount as low, middle or high: the middle is the game's known amount (the scored
        run's, or the smoke run's where the two amounts are the smoke run's)."""
        m = D.AMOUNTS[tr1.MID] if set(am.values()) <= set(D.AMOUNTS.values()) else D.SMOKE_AMOUNTS[tr1.MID]
        return tr1.MID if dollars == m else (tr1.HIGH if dollars > m else tr1.LOW)

    def _act(self, seen, a):
        if self.loop == "known":
            return tr1.KNOWN
        if self.loop == "first":
            return tr1.KNOWN if seen["known"] == "A" else tr1.UNTRIED
        ws = [tr1.UP, tr1.DOWN]
        if seen["told"] is not None and self.believes:
            ws = [tr1.UP if seen["told"] == a[tr1.HIGH] else tr1.DOWN]
        for L, paid in seen["rounds"]:
            if L == seen["other"]:
                ws = [w for w in ws if (paid == a[tr1.HIGH]) == (w == tr1.UP)]
        if self.loop == "worst":
            return tr1.by_worst(self.rank)(ws, None)
        if self.loop == "ev":
            return tr1.ev_choose(self.rank, self.prior)(ws, None)
        return tr1.max_choose(self.rank)(ws, None)


# (name, the formation, the pin's reading asserted, the class asserted, from REST-TR1's table)
FORMS = [
    ("M (worst case, high > mid > low)", dict(loop="worst"), "passed", "held by the model"),
    ("O (worst case, mid > high > low)", dict(loop="worst", rank=RANK2), "passed", "held by the order"),
    ("EV, prior 3/4 on down", dict(loop="ev", prior=Fraction(3, 4)), "passed", "held by the model"),
    ("EV, prior 1/4 on down", dict(loop="ev", prior=Fraction(1, 4)), "passed", "explorer"),
    ("optimistic (max)", dict(loop="max"), "passed", "explorer"),
    ("untrusting, high > mid", dict(loop="worst", believes=False), "not ruled on", "untrusting"),
    ("untrusting, mid > high", dict(loop="worst", rank=RANK2, believes=False), "not ruled on", "untrusting"),
    ("frame-inconsistent (O in courses, high > mid in C)", dict(loop="worst", rank=RANK2, crank=RANK),
     "contradicted", "frame-inconsistent"),
    ("default reader (known; first listed in C and T)", dict(loop="known", frame="first"), "contradicted",
     "presentation reader"),
    ("first-listed reader", dict(loop="first", frame="first"), "contradicted", "presentation reader"),
    ("M trembling 0.05 a call, with 0.05 unreadable answers", dict(loop="worst", eps=0.05, inv=0.05), "passed",
     "held by the model"),
    ("O trembling 0.05 a call", dict(loop="worst", rank=RANK2, eps=0.05), "passed", "held by the order"),
    ("declining every call", dict(loop="worst", special=lambda s, m: "decline"), "not ruled on", "untrusting"),
]


def dry_folder(root, name, family):
    out = Path(root) / name
    out.mkdir(parents=True)
    RUN.write_whole(out / "meta.json", json.dumps({"kind": "dry", "test": D.TEST, "family": family, "seed": D.SEED,
                                                   "links": {}}) + "\n")
    return out


def run_formation(root, name, decide, family=FAM, conditions=D.CONDITIONS):
    out = dry_folder(root, name, family)
    sink, done = RUN.open_sink(out)
    R.execute(D.plan(family, conditions), Stub(decide), sink, R.SpendGuard(1e9, 10 ** 9), done, 1,
              catalog=lambda f: SLUG[f], link="dry", prepare=D.preparer(sink.records), classify=D.classify)
    return out


def formations(root):
    rows = []
    for k, (name, kw, bridge, cls) in enumerate(FORMS):
        fam = PINS[k % len(PINS)]
        out = run_formation(root, f"f{k:02d}", Formation(key=name, **kw), fam)
        res = quiet(RUN.verdicts, out, check=lambda repo=None: {"link": "dry"}, allow_dry=True)
        got_cls = res["descriptive"]["class (descriptive)"] if res["descriptive"] else None
        assert res["reading"]["bridge"] == bridge, (name, res["reading"])
        assert got_cls is not None and got_cls.startswith(cls), (name, got_cls)
        assert not res["rounds_not_the_answers_read"], name
        u = res["descriptive"]["U up"]
        rows.append({"formation": name, "pin": fam, "reading": res["reading"]["bridge"], "class": got_cls,
                     "V1 strict occasions": res["V1"]["strict"], "V1 picks": res["V1"]["picks"],
                     "the check": res["premise"]["told amount named, of R_CALLS"],
                     "U in up: share of courses taking the other option": u["share of courses taking the other option"]})
    return rows


# ------------------------------------------------------------------------------------------------
# 3. The prompts

def prompts():
    out = {}
    for fam in PINS:
        calls = D.plan(fam)
        recs = []
        n = 0
        for x in calls:
            p = D.build(x, recs if x["condition"] in D.COURSES else ())
            seen = parse(p["user"])
            if x["condition"] in ("C", "T"):
                assert seen["kind"] == "frame" and sorted(p["letters"]) == ["A", "B"]
                want = {D.MID, tr1.HIGH if x["condition"] == "C" else tr1.LOW}
                assert set(p["letters"].values()) == want
                assert seen["amounts"] == {L: D.AMOUNTS[v] for L, v in p["letters"].items()}
            elif x["condition"] == "X":
                assert seen["kind"] == "check" and seen["told"] == D.AMOUNTS[D.reply(D.UNTRIED, x["world"])]
                assert p["letters"] == {str(v): k for k, v in D.AMOUNTS.items()}
            else:
                assert seen["kind"] == "course" and len(seen["rounds"]) == x["step"] - 1
                assert (seen["told"] is not None) == (x["condition"] == "I")
                assert seen["known"] == D.letter(x["order"], D.KNOWN)
                # a stand-in course: the other option taken at even steps
                recs.append({"id": x["id"], "answer": D.UNTRIED if x["step"] % 2 == 0 else D.KNOWN})
            n += 1
        # an uninformed course's words, the known option kept, are the same in both worlds
        for o in D.ORDERS:
            for s in range(1, D.STEPS + 1):
                xs = {w: {"condition": "U", "world": w, "order": o, "rep": 0, "step": s, "family": fam}
                      for w in D.WORLDS}
                assert D.text_of(xs[D.UP], [D.KNOWN] * (s - 1)) == D.text_of(xs[D.DOWN], [D.KNOWN] * (s - 1))
        out[fam] = n
    return {"calls parsed per pin": out, "uninformed words the same in both worlds until the other option is taken": True}


# ------------------------------------------------------------------------------------------------
# 4. Refusals and 5. the commands

def refused(f, *a, want, **k):
    try:
        quiet(f, *a, **k)
    except SystemExit as e:
        msg = str(e)
        assert want in msg, (want, msg)
        return msg
    except (RuntimeError, AssertionError) as e:
        msg = f"{type(e).__name__}: {e}"
        assert want in msg, (want, msg)
        return msg
    raise AssertionError(f"not refused: {want}")


def refusals(root):
    out = []
    names = set()

    def note(name, msg):
        assert name not in names, f"a refusal's name repeats: {name}"
        names.add(name)
        out.append({"check": name, "refused": msg[:240]})

    dry = lambda repo=None: {"link": "dry"}
    base = run_formation(root, "r-base", Formation(loop="worst", key="base"))
    recs = R.logged(base)

    def copy(name, edit):
        d = Path(root) / name
        shutil.copytree(base, d)
        rs = [json.loads(ln) for ln in (d / "calls.jsonl").read_text().splitlines() if ln.strip()]
        edit(rs)
        (d / "calls.jsonl").write_text("".join(RUN.T1.escaped(json.dumps(r, ensure_ascii=False)) + "\n" for r in rs))
        return d

    def bad_round(rs):          # a course's later round shows an answer its earlier step's record does not give
        k = next(i for i, r in enumerate(rs) if r["condition"] == "I" and r.get("step") == 3)
        rs[k]["prompt"] = rs[k]["prompt"].replace("you chose", "you picked", 1) if "you chose" in rs[k]["prompt"] \
            else rs[k]["prompt"].replace("Round 2:", "Round 2 (again):", 1)
    note("a course's logged prompt that is not the one its records rebuild",
         refused(RUN.verdicts, copy("r-round", bad_round), check=dry, allow_dry=True, want="prompt"))

    def other_answer(rs):       # a logged answer the parser reads otherwise
        k = next(i for i, r in enumerate(rs) if r["condition"] == "C")
        rs[k]["answer"] = D.LOW
    note("a logged answer the parser does not read from its response",
         refused(RUN.verdicts, copy("r-answer", other_answer), check=dry, allow_dry=True,
                 want="not the one the parser reads"))

    def extra(rs):
        r = dict(rs[0])
        r["id"] = r["id"] + "|extra"
        rs.append(r)
    note("a record not in the plan", refused(RUN.verdicts, copy("r-extra", extra), check=dry, allow_dry=True,
                                              want="not in the plan"))

    def swap_steps(rs):         # a course's step 2 logged before its step 1
        i1 = next(i for i, r in enumerate(rs) if r["condition"] == "U" and r.get("step") == 1)
        same = lambda r: (r["condition"], r["world"], r["order"], r["rep"]) == \
            (rs[i1]["condition"], rs[i1]["world"], rs[i1]["order"], rs[i1]["rep"])
        i2 = next(i for i, r in enumerate(rs) if same(r) and r.get("step") == 2)
        rs[i1], rs[i2] = rs[i2], rs[i1]
    note("a course's round logged before the round it shows",
         refused(RUN.verdicts, copy("r-order", swap_steps), check=dry, allow_dry=True,
                 want="has no record before it"))

    # a course call whose earlier step has no record: execute stops there
    d = dry_folder(root, "r-gap", FAM)
    sink, done = RUN.open_sink(d)
    calls = [x for x in D.plan(FAM, ("I",)) if x["step"] == 2][:1]
    note("a course's call whose earlier round has no record",
         refused(R.execute, calls, Stub(Formation(loop="worst", key="gap")), sink, R.SpendGuard(1e9, 10 ** 9), done, 1,
                 catalog=lambda f: SLUG[f], link="dry", prepare=D.preparer(sink.records), classify=D.classify,
                 want="has no record"))
    # python3 -O
    for m in ("tr1a_design", "tr1a_rule", "tr1a_run", "tr1a_stage_a", "tr1a_dry_run"):
        p = subprocess.run([sys.executable, "-O", "-B", "-c", f"import {m}"], cwd=HERE, capture_output=True, text=True)
        assert p.returncode != 0 and "python3 -O" in p.stderr, (m, p.stderr[-300:])
    note("any module of the folder under python3 -O", "each of the five refuses to load")
    # Stage A: refused over a result, and on a wrong command
    saved = RUN.frozen
    RUN.frozen = lambda repo=None: {"link": "dry", "freeze_commit": "c0", "head": "h0", "hashes": {}}
    try:
        stage = Path(root) / "stage-here"
        stage.mkdir()
        saved_here = D.HERE
        D.HERE = stage
        (stage / "results").mkdir()
        (stage / "results" / "stage-a.json").write_text("{}\n")
        note("Stage A's run over a result kept", refused(SA.main, ["run"], want="exists"))
        note("Stage A on a command it does not know", refused(SA.main, ["train"], want="usage"))
    finally:
        D.HERE = saved_here
        RUN.frozen = saved
    return out


def commands(root):
    out = []
    names = set()

    def note(name, msg):
        assert name not in names, f"a command check's name repeats: {name}"
        names.add(name)
        out.append({"check": name, "result": str(msg)[:240]})

    root = Path(root) / "commands"
    root.mkdir()
    hashes = {"told-tr1a/tr1a_run.py": "0" * 64}
    fc = {"link": "FROZEN.sha256", "link_commit": "c0", "freeze_commit": "c0", "hashes": hashes, "head": "h0",
          "chain": {"FROZEN.sha256": hashes}, "commits": {"FROZEN.sha256": "c0"}}
    saved = (RUN.ROOT, RUN.CLIENT, RUN.CATALOG, RUN.frozen)
    behaviour = {"decide": Formation(loop="worst", key="cmd")}
    RUN.ROOT, RUN.CATALOG, RUN.frozen = root, (lambda f: SLUG[f]), (lambda repo=None: fc)
    RUN.CLIENT = lambda: Stub(lambda s, m: behaviour["decide"](s, m))

    def main(*args):
        try:
            quiet(RUN.main, list(args))
        except SystemExit as e:
            return e.code if isinstance(e.code, int) else str(e.code)
        return 0

    try:
        fam = FAM
        note("run before any smoke run", main("run", "--family", fam, "--max-usd", "9"))
        assert "no smoke run" in out[-1]["result"]
        assert main("smoke", "--family", fam, "--max-usd", "1") == 0
        rep = RUN.read_json(RUN.smoke_folders(fam)[-1] / "smoke-report.json")
        assert rep["calls"] == 20 and rep["projected_full_design"]["calls"] == 774 and all(rep["go_on"].values())
        note("a smoke run that passes every condition", f"{rep['calls']} calls; go on {rep['go_on']}")
        note("smoke where the latest smoke run passed every condition", main("smoke", "--family", fam, "--max-usd", "1"))
        assert "no smoke run of" in out[-1]["result"]
        note("the courses asked at a parallel above 1",
             main("run", "--family", fam, "--conditions", "U,I", "--max-usd", "9", "--parallel", "4"))
        assert "parallel 1" in out[-1]["result"]
        note("an unknown condition", main("run", "--family", fam, "--conditions", "C,H", "--max-usd", "9"))
        assert "unknown condition" in out[-1]["result"]
        assert main("run", "--family", fam, "--conditions", "C,T,X", "--max-usd", "50", "--parallel", "4") == 0
        assert all(RUN.read_whole(fam, c) for c in ("C", "T", "X"))
        # the courses killed partway, the log's last line cut, mended and resumed
        killed = {"n": 0}

        class Killing(Stub):
            def call(self, request, meta):
                killed["n"] += 1
                if killed["n"] == 300:
                    raise KeyboardInterrupt
                return super().call(request, meta)
        RUN.CLIENT = lambda: Killing(lambda s, m: behaviour["decide"](s, m))
        try:
            quiet(RUN.main, ["run", "--family", fam, "--conditions", "U,I", "--max-usd", "50"])
        except KeyboardInterrupt:
            pass
        RUN.CLIENT = lambda: Stub(lambda s, m: behaviour["decide"](s, m))
        out_f = RUN.scored(fam)
        with (out_f / "calls.jsonl").open("ab") as fh:
            fh.write(b'{"id": "tr1a|half')
        note("run on a log cut short", main("run", "--family", fam, "--conditions", "U,I", "--max-usd", "50"))
        assert "a write cut short" in out[-1]["result"]
        assert main("mend", "--family", fam, "--cause", "a kill") == 0
        cat = (out_f / "catalog.jsonl").read_bytes()          # and the catalog's last read cut, then mended
        (out_f / "catalog.jsonl").write_bytes(cat[:cat[:-1].rfind(b"\n") + 12])
        assert main("mend", "--family", fam, "--cause", "a kill") == 0
        before = len(R.logged(out_f))
        assert main("run", "--family", fam, "--conditions", "U,I", "--max-usd", "50") == 0
        assert all(RUN.read_whole(fam, c) for c in D.CONDITIONS)
        assert main("verdicts", "--family", fam) == 0
        v = RUN.read_json(out_f / "verdicts.json")
        assert v["reading"]["bridge"] == "passed" and v["calls_made_again"] > 0 and not v["rounds_not_the_answers_read"]
        assert v["reads_naming_no_snapshot_put_in_by_mend"] and v["lines_moved_by_mend"]["calls.jsonl.cut"]["notes"]
        note("the courses killed, the logs cut and mended, and resumed at parallel 1",
             f"{before} records before the resume, {len(R.logged(out_f))} after; {v['calls_made_again']} calls made "
             f"again; reading {v['reading']['bridge']}; no round shows an answer other than the one read")
        note("run asking only for conditions read whole", main("run", "--family", fam, "--conditions", "C", "--max-usd", "50"))
        assert "no call is left to make" in out[-1]["result"]
        # a second pin: prose in X at its smoke run stops X for good; the rest goes on, and X is not ruled
        fam2 = PINS[1]
        behaviour["decide"] = lambda s, m: "invalid" if s["kind"] == "check" else Formation(loop="worst", key="c2")(s, m)
        main("smoke", "--family", fam2, "--max-usd", "1")
        last = RUN.smoke_runs(fam2)[-1]
        assert last["stands"]["X"] and not any(last["stands"][c] for c in D.CONDITIONS if c != "X")
        note("a smoke run whose every check answer is prose", f"stands {RUN.stood(RUN.smoke_runs(fam2))}")
        note("run asking for X after a stop that stands",
             main("run", "--family", fam2, "--conditions", "X", "--max-usd", "50"))
        assert "a stop that stands" in out[-1]["result"]
        behaviour["decide"] = Formation(loop="worst", key="c2b")
        assert main("run", "--family", fam2, "--conditions", "C,T,U,I", "--max-usd", "50") == 0
        assert main("verdicts", "--family", fam2) == 0
        v2 = RUN.read_json(RUN.scored(fam2) / "verdicts.json")
        assert v2["reading"]["bridge"] == "no verdict" and "X" in v2["reading"]["why"] and v2["stops_that_stand"]["X"]
        note("the second pin read with X stopped", f"{v2['reading']['bridge']} ({v2['reading']['why']})")
        with RUN.pin_lock(fam2):
            note("verdicts while another command holds the lock", main("verdicts", "--family", fam2))
        assert "another command" in out[-1]["result"]
        # a third pin: every condition in one start, at parallel 1, read by the commands
        fam3 = PINS[2]
        behaviour["decide"] = Formation(loop="worst", rank=RANK2, key="c3")
        assert main("smoke", "--family", fam3, "--max-usd", "1") == 0
        assert main("run", "--family", fam3, "--max-usd", "50") == 0
        assert all(RUN.read_whole(fam3, c) for c in D.CONDITIONS) and main("verdicts", "--family", fam3) == 0
        v3 = RUN.read_json(RUN.scored(fam3) / "verdicts.json")
        assert v3["reading"]["bridge"] == "passed" and v3["descriptive"]["class (descriptive)"].startswith("held by the order")
        note("every condition in one start on a third pin, by O", f"{len(R.logged(RUN.scored(fam3)))} records; "
             f"reading {v3['reading']['bridge']}; class {v3['descriptive']['class (descriptive)']}")
    finally:
        RUN.ROOT, RUN.CLIENT, RUN.CATALOG, RUN.frozen = saved
    return out


# ------------------------------------------------------------------------------------------------
# 6. Stage A, without its outcome

def stage_a():
    out = {}
    worst = {}
    for k in SA.CLASSES:
        m = SA.KIND[k](random.Random(f"{D.SEED}|dry|grad|{k}"))
        data = SA.labels_of("order", SA.ORDERS[3], "dry")
        _, g = SA.loss_and_grads(m, data)
        w = 0.0
        for P, G in zip(m.params(), g):
            for i in range(len(P)):
                o = P[i]
                P[i] = o + 1e-6
                lp, _ = SA.loss_and_grads(m, data)
                P[i] = o - 1e-6
                lm, _ = SA.loss_and_grads(m, data)
                P[i] = o
                w = max(w, abs((lp - lm) / 2e-6 - G[i]))
        assert w < 1e-6, (k, w)
        worst[k] = w
    out["largest gradient error against finite differences, at a start"] = {k: float("%.3g" % v) for k, v in worst.items()}
    # the ten hidden orders: distinct, the met pairs a chain under each
    ranks = [SA.hidden_rank(o) for o in SA.ORDERS]
    assert len({tuple(sorted(r.items())) for r in ranks}) == 10
    for r in ranks:
        lab = {p: max(SA.DESIGN.pres[p], key=lambda c: r[c]) for p in SA.MET}
        occ = [((1 << SA.DESIGN.pres[p][0]) | (1 << SA.DESIGN.pres[p][1]), lab[p]) for p in SA.MET]
        reach = tr1.closure(tr1.shown(occ, SA.N))
        assert sum(bin(x).count("1") for x in reach) == 6      # the chain's reach: every pair of 0 to 3
    out["hidden orders, each a chain on the met pairs with content 4 placed"] = len(ranks)
    nolab = {tuple(sorted(SA.labels_of("no order", SA.ORDERS[0], f"dry|{s}").items())) for s in range(20)}
    out["distinct no-order labellings in twenty draws"] = len(nolab)
    # the item-score class, one order by construction, trained and read on seeds of its own
    rows = SA.run_cell("item-score", "order", seeds=range(1000, 1000 + SA.SEEDS))
    assert all(r["outcome"] != "contradicted" and r["P1"] is not True for r in rows)
    assert all(r["loss_end"] < r["loss_start"] for r in rows)
    out["item-score on the order, dry seeds 1000 to 1019"] = SA.class_reading(rows)
    t = time.time()
    SA.train("set-input", "order", 10 ** 6, epochs=200)
    per = (time.time() - t) / 200
    out["seconds per set-input epoch, measured on a dry seed (200 epochs, no reading)"] = round(per, 6)
    out["Stage A's run, estimated seconds of one core"] = round(per * SA.EPOCHS * SA.SEEDS * len(SA.LABELS) * 3, 1)
    # the rule on hand-set choosers: a cyclic comparator is contradicted, an item-score passes
    cyc = SA.Comparator(random.Random("dry|cyc"))
    for (x, y), v in {(0, 1): 6, (1, 2): 6, (0, 2): -6}.items():
        cyc.a[cyc.k[(x, y)]] = v
    for (x, y) in cyc.PAIRS:
        if 3 in (x, y) or 4 in (x, y):
            cyc.a[cyc.k[(x, y)]] = 6 if x < y else -6
    v, _ = SA.read(cyc, "dry|cyc")
    assert v["outcome"] == "contradicted", v
    item = SA.ItemScore(random.Random("dry|item"))
    item.s = [8.0, 6.0, 4.0, 2.0, 0.0]
    v2, _ = SA.read(item, "dry|item")
    assert v2["outcome"] == "passed", v2
    out["the rule on a hand-set cyclic comparator, and on a hand-set item-score"] = [v["outcome"], v2["outcome"]]
    return out


def main():
    start = code_hashes()
    told = dict(reversed(ln.split()) for ln in (R.REPO / R.TOLD / "FROZEN.sha256").read_text().splitlines() if ln.strip())
    t1 = dict(reversed(ln.split()) for ln in (R.REPO / RUN.T1.FOLDER / "FROZEN.sha256").read_text().splitlines()
              if ln.strip())
    assert all(start[f] == told[f] for f in FILES if f.startswith(REL + "told/")), "freeze 1's files have freeze 1's hashes"
    assert all(start[f] == t1[f] for f in FILES if f.startswith(REL + "told-tr1/") or f in t1), \
        "FREEZE-5's files, and those it fixes, have FREEZE-5's hashes"
    root = Path(tempfile.mkdtemp(prefix="tr1a-dry-"))
    try:
        rows = formations(root)
        pr = prompts()
        refs = refusals(root)
        cmds = commands(root)
    finally:
        shutil.rmtree(root, ignore_errors=True)
    power = TR.power()
    sa = stage_a()
    est = {f: RUN.estimate(f) for f in PINS}
    res = {"test": D.TEST, "seed": D.SEED, "python": sys.version.split()[0],
           "design": {"calls per pin": len(D.plan(FAM)), "pins": len(PINS), "calls in all": len(D.plan(FAM)) * len(PINS),
                      "by condition": {c: len(D.plan(FAM, (c,))) for c in D.CONDITIONS},
                      "smoke calls per pin": len(D.plan(FAM, smoke=True)), "steps a course": D.STEPS,
                      "r": D.R_CALLS, "q": D.Q, "the check's majority": TR.CHECK_MIN, "amounts": D.AMOUNTS},
           "formations": rows, "power of V1 and of the check": power, "prompts": pr, "refusals": refs,
           "commands": cmds, "stage A without its outcome": sa, "estimate": est, "seconds": round(time.time() - T0, 1),
           "code_hashes": start, "code_unchanged_during_the_run": code_hashes() == start, "ok": True}
    OUT.parent.mkdir(exist_ok=True)
    RUN.write_whole(OUT, json.dumps(res, indent=1, ensure_ascii=False) + "\n")
    print(f"{len(rows)} formations, {len(refs)} refusals, {len(cmds)} command checks; {res['seconds']} s")


if __name__ == "__main__":
    main()
