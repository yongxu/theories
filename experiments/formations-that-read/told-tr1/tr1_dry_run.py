"""TR1's dry run (FREEZE-5.md, section 9): the frozen code path end to end, with no model call, no key and
no network. Writes results/dry-run.json; every figure the text gives from the dry run is read from it.

    python3 -B tr1_dry_run.py          # about a minute or two on one idle core

1. Formations: Stage 0's choosers (tr1.py's classes, with their parameters) answer every call of the
   plan through freeze 1's execute, this freeze's call builder, line writer and parser, and a stand-in
   client that reads only the text a call shows (the listed contents, their codes, whether "none" is
   offered, and H's history, parsed from the words); the log is read by this freeze's load, through
   freeze 1's verdicts.load, and by the rule. Each reads as its type implies (FORMS: the outcome each
   is asserted to give, or "reported").
2. The rule against Stage 0: tr1_rule.measures equals tr1.simulate on the same answers, for every
   formation's answers and for random answer sets.
3. The prompts: every planned call of the three pins parsed from its text alone.
4. Refusals: each by its own reason, a log, a lock or a command made to fail.
5. The commands: `smoke`, `run`, `mend` and `verdicts` run in a stand-in folder, through a stand-in
   client, catalog and frozen check, with a run cut short by a kill and resumed.
"""

import contextlib
import io
import json
import os
import random
import re
import shutil
import subprocess
import sys
import tempfile
import time
from collections import Counter
from pathlib import Path

import tr1_design as D
import tr1_rule as TR
import tr1_run as RUN
import tr1
import client as cl
import run as R
from conditions import DECLINE
from rule import FILTERED, INVALID

D.own_files()

HERE = Path(__file__).resolve().parent
OUT = HERE / "results" / "dry-run.json"
PINS = [p["id"] for p in R.PINS["pins"]]
FAM = PINS[0]
SLUG = {p["id"]: p["canonical_slug"] for p in R.PINS["pins"]}
STAGE0 = {k: (cls, kw) for k, _l, cls, kw, _r in tr1.CHOOSERS}
T0 = time.time()
REL = "experiments/formations-that-read/"
# Every file this freeze fixes but the dry run's result (FREEZE-5.md, section 15): its own code; Stage 0;
# freeze 1's files it imports (run imports prompts; conditions imports tr8.py and tr_rr.py) and PINS.json.
FILES = [REL + f for f in ("tr1.py", "tr1.json", "tr8.py", "tr_rr.py")] + \
        [REL + "told/" + f for f in ("client.py", "conditions.py", "prompts.py", "rule.py", "run.py", "verdicts.py",
                                     "PINS.json")] + \
        [REL + "told-tr1/" + f for f in ("tr1_design.py", "tr1_rule.py", "tr1_run.py", "tr1_dry_run.py",
                                         "write_frozen.py")]


def code_hashes():
    import hashlib
    return {f: hashlib.sha256((R.REPO / f).read_bytes()).hexdigest() for f in FILES}


# ------------------------------------------------------------------------------------------------
# The stand-in client: it reads only the call's text

OPTION = re.compile(r"^([A-E])\. (.+)$")
ENTRY = re.compile(r"^(\d+)\. Of: (.+)\. Your answer: (.+)\.$")


def parse(text, family):
    """What a call shows, read from its words: the listed (code, text) pairs in order, whether "none" is
    offered, the domain, and H's earlier entries as (listed texts, answer text)."""
    paras = text.split("\n\n")
    intro = next(i for i, p in enumerate(paras) if p.startswith("Below are "))
    options = [OPTION.match(ln).groups() for ln in paras[intro + 1].split("\n")]
    assert all(options) and len(options) == int(paras[intro].split()[2])
    domain = "K" if "amounts of money" in paras[intro] else "T"
    entries = []
    for p in paras[:intro]:
        for ln in p.split("\n")[1:]:
            m = ENTRY.match(ln)
            assert m, ln
            entries.append((m.group(2).split("; "), m.group(3)))
    return {"options": options, "none": '"none"' in paras[-1], "domain": domain, "entries": entries,
            "series": paras[0].startswith("You are answering a series")}


def index_of(domain, family):
    """Each text a call may show, to its content index: the pin's contents, and the smoke run's."""
    m = {t: i for i, t in enumerate(D.contents_of(domain, family))}
    m.update({t: i for i, t in enumerate(D.contents_of(domain, family, smoke=True))})
    return m


def response(content=None, finish="stop", refusal=None, model=None, request=None, usage=None):
    msg = {"content": content}
    if refusal:
        msg["refusal"] = refusal
    return {"model": model or request["model"], "choices": [{"message": msg, "finish_reason": finish}],
            "usage": usage or {"prompt_tokens": len(request["messages"][0]["content"]) // 4, "completion_tokens": 9,
                               "cost": 0.0}}


class Stub:
    """A stand-in for freeze 1's OpenRouterClient: decide(seen, meta) gives a content index, None ("no
    preference"), or one of "invalid", "refusal", "decline", "filtered", "limit", "reject", "other model";
    seen is the call's text as parse() reads it, with each listed text's content index."""
    live = False

    def __init__(self, decide):
        self.decide, self.calls = decide, 0

    def call(self, request, meta):
        self.calls += 1
        text = request["messages"][0]["content"]
        seen = parse(text, meta["family"])
        idx = index_of(seen["domain"], meta["family"])
        seen["listed"] = [idx[t] for _c, t in seen["options"]]
        seen["codes"] = [c for c, _t in seen["options"]]
        seen["history"] = [([idx[t] for t in ts], (idx[a] if a in idx else a)) for ts, a in seen["entries"]]
        a = self.decide(seen, meta)
        enum = request["response_format"]["json_schema"]["schema"]["properties"]["choice"]["enum"]
        assert enum == seen["codes"] + (["none"] if seen["none"] else []), "the schema is what the words offer"
        if isinstance(a, int) and not isinstance(a, bool):
            return {"response": response(json.dumps({"choice": seen["codes"][seen["listed"].index(a)]}),
                                         request=request), "attempts": 1, "errors": []}
        if a is None:
            return {"response": response(json.dumps({"choice": "none"}), request=request), "attempts": 1, "errors": []}
        r = {"invalid": lambda: response("I would pick the first one.", request=request),
             "refusal": lambda: response(None, refusal="I will not choose.", request=request),
             "decline": lambda: response(json.dumps({"choice": "decline"}), request=request),
             "filtered": lambda: response(None, finish="content_filter", request=request),
             "limit": lambda: response('{"choice": "', finish="length", request=request),
             "reject": lambda: {"rejected": {"status": 403, "body": "flagged"}},
             "other model": lambda: response(json.dumps({"choice": seen["codes"][0]}), model="other/model",
                                             request=request)}[a]()
        return {"response": r, "attempts": 1, "errors": []}


# ------------------------------------------------------------------------------------------------
# 1. Formations

def amount_rank(family):
    """K's canonical order for a pin: the larger amount first."""
    texts = D.contents_of("K", family)
    order = sorted(range(5), key=lambda i: -int(texts[i].split()[0]))
    return {c: k for k, c in enumerate(order)}


class Formation:
    """A Stage 0 chooser answering T, F and H (one instance, one hidden order), and K by amount (one strict
    order trembling 0.02) unless k is another Stage 0 key; "none" offered or not as the words say. A
    history reader rebuilds its course from H's words at each call, and has none in a fresh call."""

    def __init__(self, key, family=FAM, k="amount", special=None):
        rng = random.Random(f"{D.SEED}|dry|{key}|{family}|{k}")
        self.special = special
        if key in STAGE0:
            cls, kw = STAGE0[key]
            self.ch = cls(rng, 5, **dict(kw))
        if k == "amount":
            self.k = tr1.Order(rng, 5, eps=0.02)
            self.k.rank = amount_rank(family)
        else:
            cls, kw = STAGE0[k]
            self.k = cls(rng, 5, **dict(kw))
        self.key = key

    def __call__(self, seen, meta):
        if self.special:
            return self.special(seen, meta)
        listed = tuple(seen["listed"])
        pidx = D.DESIGN.pres.index(listed) if listed in D.DESIGN.pres else -1
        ch = self.k if seen["domain"] == "K" else self.ch
        if isinstance(ch, tr1.Ties) and "no_pref" in STAGE0[self.key][1]:
            ch.kw["no_pref"] = seen["none"]
        if ch.history:
            if seen["series"]:
                ch.new_course()
                for ls, a in seen["history"]:
                    ch.record(None, ls, a if isinstance(a, int) else None)
            else:
                ch.__dict__.pop("mem", None)
                ch.__dict__.pop("rows", None)
        a = ch.call(pidx, listed)
        if a is None and not seen["none"]:
            return "invalid"
        return "invalid" if isinstance(a, int) and a < 0 else a


# The formations, and what each is asserted to read as: (key, K's chooser, special, {condition: outcome},
# the pin's bridge). Every outcome is asserted but TieN's T, F and H and its reading, to which Stage 0 gives
# chances of 0.89, 0.76 and 0.89 (REST-TR1, section 4): reported.
FORMS = [
    ("L0", "amount", None, {"T": "passed", "F": "passed", "K": "passed", "H": "passed"}, "passed"),
    ("L.05", "amount", None, {"T": "passed", "F": "passed", "K": "passed", "H": "passed"}, "passed"),
    ("L.10", "amount", None, {"T": "passed", "F": "passed", "K": "passed", "H": "passed"}, "passed"),
    ("Linv", "amount", None, {"T": "passed", "F": "passed", "K": "passed", "H": "passed"}, "passed"),
    ("RU.90", "amount", None, {"T": "passed", "F": "passed", "K": "passed", "H": "passed"}, "passed"),
    ("TieN", "amount", None, {"K": "passed"}, "reported"),
    ("Alpha", "amount", None, {"T": "passed", "F": "passed", "K": "passed", "H": "passed"}, "passed"),
    ("LabF", "amount", None, {"T": "passed", "F": "passed", "K": "passed", "H": "passed"}, "passed"),
] + [(k, "amount", None, {"T": "contradicted", "F": "contradicted", "K": "passed", "H": "contradicted"}, "contradicted")
     for k in ("Pos1", "PosL", "Cue", "Comp", "Att2", "Att3", "HCopy")] + \
    [(k, "amount", None, {"T": "void", "F": "void", "K": "passed", "H": "void"}, "void") for k in ("MixC", "Unif", "Lab")] + [
    ("HOrd", "amount", None, {"T": "contradicted", "F": "contradicted", "K": "passed", "H": "passed"}, "contradicted"),
    ("L.05", "Pos1", None, {"T": "passed", "F": "passed", "K": "contradicted", "H": "passed"}, "not ruled on"),
    ("L.05", "Unif", None, {"T": "passed", "F": "passed", "K": "void", "H": "passed"}, "not ruled on"),
    ("Decliner", "amount", lambda s, m: "refusal", {"T": "void", "F": "void", "K": "void", "H": "void"},
     "not ruled on"),
    ("NoneSayer", "amount", lambda s, m: None if s["none"] else s["listed"][0],
     {"T": "void", "F": "contradicted", "K": "void", "H": "void"}, "not ruled on"),
]


def label_reader(family):
    """Stage 0's label reader under the protocol, read from the codes the words show: a fixed preference
    over the pool of codes, the favoured one picked."""
    pref = list(D.CODES)
    random.Random(f"{D.SEED}|dry|label|{family}").shuffle(pref)
    return lambda s, m: s["listed"][min(range(len(s["codes"])), key=lambda i: pref.index(s["codes"][i]))] \
        if s["domain"] == "T" else max(s["listed"], key=lambda c: -amount_rank(family)[c])


def dry_folder(root, name, family):
    out = Path(root) / name
    out.mkdir(parents=True)
    RUN.write_whole(out / "meta.json", json.dumps({"kind": "dry", "test": D.TEST, "family": family, "seed": D.SEED,
                                                   "links": {}}) + "\n")
    return out


def run_formation(root, name, decide, family=FAM, conditions=D.CONDITIONS, parallel=1, prepare=None):
    """Every call of the plan through freeze 1's execute, this freeze's sink, call builder and parser."""
    out = dry_folder(root, name, family)
    sink, done = RUN.open_sink(out)
    calls = D.plan(family, conditions)
    R.execute(calls, Stub(decide), sink, R.SpendGuard(1e9, 10 ** 9), done, parallel, catalog=lambda f: SLUG[f],
              link="dry", prepare=prepare or D.preparer(sink.records), classify=D.classify)
    return out


def quiet(f, *a, **k):
    with contextlib.redirect_stdout(io.StringIO()):
        return f(*a, **k)


def formations(root):
    rows, answers = [], {}
    names = set()
    for key, k, special, want, bridge in FORMS:
        name = f"{key}-K{k}"
        assert name not in names, f"a formation's name repeats: {name}"
        names.add(name)
        dec = (label_reader(FAM) if key == "Lab" else Formation(key, FAM, k, special))
        out = run_formation(root, name, dec)
        res = quiet(RUN.verdicts, out, allow_dry=True)
        got = {c: (v["outcome"] if v else None) for c, v in res["conditions"].items()}
        ok = all(got[c] == w for c, w in want.items()) and (bridge == "reported" or res["reading"]["bridge"] == bridge)
        assert ok, (name, got, res["reading"])
        assert not res["histories_not_the_answers_read"], name
        rows.append({"formation": name, "stage0": key, "K by": k, "outcomes": got, "asserted": want,
                     "bridge": res["reading"]["bridge"], "bridge asserted": bridge,
                     "strict_share": {c: v["strict_share"] for c, v in res["conditions"].items()},
                     "P1": {c: v["P1"] for c, v in res["conditions"].items()},
                     "first_listed_share_T": res["conditions"]["T"]["first_listed_share_of_strict_picks"],
                     "content_with_position_T": res["conditions"]["T"]["content_with_position_family"],
                     "shortest_cycle_T": res["conditions"]["T"]["shortest_cycle"],
                     "answers_T": res["conditions"]["T"]["answers"]})
        meta, good, _ = RUN.load(out, allow_dry=True)
        answers[name] = good
    return rows, answers


# ------------------------------------------------------------------------------------------------
# 2. The rule against Stage 0

class Replay(tr1.Chooser):
    def setup(self):
        self.left = {p: list(xs) for p, xs in self.kw["answers"].items()}

    def call(self, pidx, listed):
        return self.left[pidx].pop(0)


def against_stage0(answers):
    """measures() against tr1.simulate on the same answers, by condition."""
    keys = ("strict", "presentations", "C", "P1", "P1_testable", "cycle_possible", "first_share_pairs")
    n = 0
    for name, good in answers.items():
        for c in D.CONDITIONS:
            by = {}
            for r in good:
                if r["condition"] == c:
                    by.setdefault(r["p"], []).append(r["answer"])
            if len(by) != 70:
                continue
            mine = TR.measures(by)
            s0 = tr1.simulate(D.DESIGN, Replay, {"answers": {p: [TR.stage0_answer(a) for a in xs] for p, xs in by.items()}},
                              D.R_CALLS, D.Q, random.Random(0))
            assert all(mine[k] == s0[k] for k in keys), (name, c, {k: (mine[k], s0[k]) for k in keys})
            pos = tr1.simulate(D.DESIGN, Replay, {"answers": {p: [TR.stage0_answer(a) for a in xs] for p, xs in by.items()}},
                               D.R_CALLS, D.Q, random.Random(0), carrier="content_position")
            assert mine["C_content_with_position"] == pos["C"]
            assert tr1.verdict(mine) == tr1.verdict(s0)
            n += 1
    rng = random.Random(f"{D.SEED}|dry|random answers")
    for k in range(400):
        stab = rng.random()
        by = {}
        for p, listed in enumerate(D.DESIGN.pres):
            top = rng.choice(listed)
            by[p] = [top if rng.random() < stab else rng.choice(list(listed) + [D.NONE, INVALID, DECLINE])
                     for _ in range(D.R_CALLS)]
        mine = TR.measures(by)
        s0 = tr1.simulate(D.DESIGN, Replay, {"answers": {p: [TR.stage0_answer(a) for a in xs] for p, xs in by.items()}},
                          D.R_CALLS, D.Q, random.Random(0))
        assert all(mine[kk] == s0[kk] for kk in keys)
        if mine["C"]:
            cyc = mine["shortest_cycle"]
            assert cyc and cyc[0][0] == cyc[-1][1] and all(cyc[i][1] == cyc[i + 1][0] for i in range(len(cyc) - 1))
            strict = TR.strict_picks(by)
            assert all(strict.get(p) == x and y in D.DESIGN.pres[p] for x, y, p in cyc)
        n += 1
    return n


# ------------------------------------------------------------------------------------------------
# 3. The prompts, parsed from their text alone

def prompts():
    counts = {}
    for family in PINS:
        calls = D.plan(family)
        assert len({x["id"] for x in calls}) == len(calls) == 4 * 70 * D.R_CALLS
        n = Counter(x["condition"] for x in calls)
        assert all(n[c] == 630 for c in D.CONDITIONS)
        assert sorted(D.contents_of("T", family)) == sorted(D.CONTENTS["T"])
        recs, steps = [], {}
        for x in calls:
            pr = D.build(x, recs if x["condition"] == "H" else ())
            seen = parse(pr["user"], family)
            idx = index_of(seen["domain"], family)
            listed = [idx[t] for _c, t in seen["options"]]
            assert tuple(listed) == D.DESIGN.pres[x["p"]], "the listed contents are the presentation's, in its order"
            assert {c: i for (c, _t), i in zip(seen["options"], listed)} == pr["letters"]
            assert len(set(pr["letters"])) == len(listed) and set(pr["letters"]) <= set(D.CODES)
            assert seen["none"] == D.OFFERS_NONE[x["condition"]] and seen["domain"] == D.DOMAIN[x["condition"]]
            assert seen["series"] == (x["condition"] == "H")
            if x["condition"] == "H":
                assert x["step"] == steps.get(x["rep"], 0) and D.DESIGN.course_order[x["step"]] == x["p"]
                hist = [tuple(idx[t] for t in ts) for ts, _a in seen["entries"]]
                assert hist == [D.DESIGN.pres[p] for p in D.DESIGN.course_order[:x["step"]]]
                assert [idx[a] for _ts, a in seen["entries"]] == [D.DESIGN.pres[p][0] for p in D.DESIGN.course_order[:x["step"]]]
                steps[x["rep"]] = x["step"] + 1
                recs.append({"id": x["id"], "answer": D.DESIGN.pres[x["p"]][0]})
        counts[family] = dict(n)
    # codes differ between calls of a presentation: the protocol (REST-TR1, section 5)
    same = sum(1 for p in range(70) if len({tuple(D.build({**x, "family": FAM})["letters"]) for x in D.plan(FAM, ("T",))
                                             if x["p"] == p}) == 1)
    return {"calls per condition and pin": counts, "presentations whose nine T calls all show one code order": same,
            "contents per pin (index 0 to 4)": {f: {d: D.contents_of(d, f) for d in ("T", "K")} for f in PINS}}


# ------------------------------------------------------------------------------------------------
# 4. Refusals, each by its own reason

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


def refusals(root, answers):
    out = []
    names = set()

    def note(name, msg):
        assert name not in names, f"a refusal's name repeats: {name}"
        names.add(name)
        out.append({"check": name, "refused with": msg[:240]})

    law = Formation("L.05")
    base = run_formation(root, "refusal-base", law)

    def copy(name):
        dst = Path(root) / name
        shutil.copytree(base, dst)
        return dst

    # the parser
    req = {"model": FAM, "messages": [{"role": "user", "content": "x"}]}
    letters = {"A": 3, "B": 1}
    cases = {"none": (response('{"choice": "none"}', request=req), D.NONE),
             "a code": (response('{"choice": "B"}', request=req), 1),
             "decline": (response('{"choice": "decline"}', request=req), DECLINE),
             "refusal field": (response(None, refusal="no", request=req), DECLINE),
             "a filter's stop": (response(None, finish="content_filter", request=req), FILTERED),
             "a moderation rejection": ({"rejected": {"status": 403}}, FILTERED),
             "prose": (response("A, I think", request=req), INVALID),
             "a code not shown": (response('{"choice": "C"}', request=req), INVALID),
             "none under a filter's stop": (response('{"choice": "none"}', finish="content_filter", request=req), D.NONE)}
    parsed = {k: D.classify(r, "choice", letters)[0] for k, (r, _w) in cases.items()}
    assert all(parsed[k] == w for k, (_r, w) in cases.items()), parsed

    # the lock
    with RUN.pin_lock(FAM, root):
        note("a second command of a pin while one holds its lock",
             refused(lambda: RUN.pin_lock(FAM, root).__enter__(), want="another command"))

    # a log cut short, and mend
    f = copy("cut-last")
    with (f / "calls.jsonl").open("ab") as fh:
        fh.write(b'{"id": "tr1|cut')
    note("a last line cut short", refused(RUN.refuse_cut, f, want="a write cut short"))
    note("the reading of a folder cut short", refused(RUN.load, f, allow_dry=True, want="a write cut short"))
    got = RUN.mend(f, FAM, "a kill\nmid-write")
    assert got == {"calls.jsonl": len(b'{"id": "tr1|cut')}
    cutf = (f / "calls.jsonl.cut").read_bytes().split(b"\n")
    assert cutf[0] == b'{"id": "tr1|cut' and cutf[1].startswith(b"# cut ") and cutf[1].endswith(b": a kill mid-write")
    RUN.refuse_cut(f)
    note("mend where every log reads whole", refused(RUN.mend, f, FAM, want="every log reads whole"))
    quiet(RUN.load, f, allow_dry=True)
    f = copy("cut-newline")
    (f / "calls.jsonl").write_bytes((f / "calls.jsonl").read_bytes()[:-1])
    note("a last line without its newline", refused(RUN.refuse_cut, f, want="no final newline"))
    RUN.mend(f, FAM)
    assert len(R.logged(f)) == len(R.logged(base)) - 1
    f = copy("cut-catalog")
    cat = (f / "catalog.jsonl").read_bytes()
    (f / "catalog.jsonl").write_bytes(cat[:cat[:-1].rfind(b"\n") + 12])     # the closing read cut short
    RUN.mend(f, FAM, "a full disk")
    assert R.catalog_reads(f)[-1][1] is None and json.loads((f / "catalog.jsonl").read_text().splitlines()[-1])["slug"] is None
    meta, good, _ = RUN.load(f, allow_dry=True)
    last_good = max(t for t, s in R.catalog_reads(f) if s is not None)
    assert all(r["t1"] <= last_good for r in good) and len(good) < len(R.logged(f))
    f = copy("cut-before-last")
    lines = (f / "calls.jsonl").read_bytes().split(b"\n")
    lines[3] = lines[3][:40]
    (f / "calls.jsonl").write_bytes(b"\n".join(lines))
    note("a line before the last that does not read", refused(RUN.refuse_cut, f, want="a line before the last"))
    note("mend on a line before the last", refused(RUN.mend, f, FAM, want="a line before the last"))
    f = copy("meta-missing")
    (f / "meta.json").unlink()
    note("a log and no meta", refused(RUN.refuse_cut, f, want="a log and no meta.json"))
    note("mend with no meta", refused(RUN.mend, f, FAM, want="a log and no meta.json"))
    f = copy("meta-cut")
    (f / "meta.json").write_text('{"kind": "dr')
    note("a meta that does not read", refused(RUN.refuse_cut, f, want="does not read"))
    f = copy("mend-clock")
    with (f / "calls.jsonl").open("ab") as fh:
        fh.write(b'{"x')
    real = time.time
    time.time = lambda: 1.0
    try:
        note("mend where the clock is not later", refused(RUN.mend, f, FAM, want="the clock is not later"))
    finally:
        time.time = real
    f = copy("mend-stopped")
    with (f / "calls.jsonl").open("ab") as fh:
        fh.write(b'{"y')
    RUN.mend(f, FAM, "first")
    with (f / "calls.jsonl").open("ab") as fh:      # as a mend stopped before its last write leaves the log
        fh.write(b'{"y')
    RUN.mend(f, FAM, "again")
    assert (f / "calls.jsonl.cut").read_bytes().count(b"# cut ") == 1, "a mend made again adds no second line"
    meta = RUN.read_json(f / "meta.json")
    meta["starts"] = [{"t": 0, "conditions": []}]
    RUN.write_whole(f / "meta.json", json.dumps(meta))
    with (f / "calls.jsonl").open("ab") as fh:      # cut again after a later start of run
        fh.write(b'{"y')
    RUN.mend(f, FAM, "later")
    assert (f / "calls.jsonl.cut").read_bytes().count(b"# cut ") == 2

    # the line writer
    f = dry_folder(root, "separators", FAM)
    sink, _ = RUN.open_sink(f)
    rec = {"id": "x", "text": "a" + chr(0x2028) + "b" + chr(0x2029) + "c" + chr(0x85) + "d" + chr(0xd800) + "e", "pair": chr(0x1F600)}
    sink(rec)
    raw = (f / "calls.jsonl").read_bytes()
    assert raw.count(b"\n") == 1 and b"\\u2028" in raw and b"\\ud800" in raw
    back = R.logged(f)
    assert back[0]["text"] == rec["text"] and back[0]["pair"] == rec["pair"]
    note("a record holding a surrogate pair as two code points", _refused_write(sink))
    note("a write after a failed one", refused(sink, {"id": "z"}, want="nothing more is written"))
    assert (f / "calls.jsonl").read_bytes() == raw

    # the reading
    f = copy("edited-answer")
    lines = (f / "calls.jsonl").read_text().splitlines()
    r = json.loads(lines[5])
    r["answer"] = D.NONE if r["answer"] != D.NONE else 0
    lines[5] = json.dumps(r, ensure_ascii=False)
    (f / "calls.jsonl").write_text("\n".join(lines) + "\n")
    note("a logged answer the parser does not read from its response",
         refused(RUN.load, f, allow_dry=True, want="the logged answer is not the one"))
    f = copy("edited-prompt")
    lines = (f / "calls.jsonl").read_text().splitlines()
    r = json.loads(lines[7])
    r["prompt"] = r["prompt"].replace("Which", "Whch")
    lines[7] = json.dumps(r, ensure_ascii=False)
    (f / "calls.jsonl").write_text("\n".join(lines) + "\n")
    note("a logged prompt whose text is not its rebuild's, its hash kept",
         refused(RUN.load, f, allow_dry=True, want="whose logged prompt is not"))
    f = copy("enlarged")
    with (f / "calls.jsonl").open("a") as fh:
        fh.write(json.dumps({**json.loads((f / "calls.jsonl").read_text().splitlines()[0]), "id": "tr1|extra"}) + "\n")
    note("a record not in the plan", refused(RUN.load, f, allow_dry=True, want="not in the plan"))
    f = copy("other-model")
    lines = (f / "calls.jsonl").read_text().splitlines()
    r = json.loads(lines[9])
    r["response"]["model"] = "other/model"
    lines[9] = json.dumps(r, ensure_ascii=False)
    (f / "calls.jsonl").write_text("\n".join(lines) + "\n")
    note("a record another model answered", refused(RUN.load, f, allow_dry=True, want="not the pin"))
    f = copy("smoke-folder")
    RUN.write_whole(f / "meta.json", json.dumps({"kind": "smoke", "family": FAM}))
    note("a smoke run's folder read for a verdict", refused(RUN.load, f, allow_dry=True, want="carries no verdict"))

    # a history built otherwise than from the records logged before it
    def wrong(x, smoke=False):
        prompt, req = D.prepared(x, sink_w.records, smoke)
        if x["condition"] == "H" and x["step"] == 2:
            recs = [dict(r, answer=D.NONE) for r in sink_w.records]
            prompt, req = D.prepared(x, recs, smoke)
        return prompt, req
    f = dry_folder(root, "wrong-history", FAM)
    sink_w, _ = RUN.open_sink(f)
    R.execute(D.plan(FAM, ("H",)), Stub(law), sink_w, R.SpendGuard(1e9, 10 ** 9), (), 1, catalog=lambda x: SLUG[x],
              link="dry", prepare=wrong, classify=D.classify)
    note("an H call whose history is not the records logged before it",
         refused(RUN.load, f, allow_dry=True, want="are not those its id rebuilds"))

    # H made again after a kill: the reading rebuilds each record from the records before it
    f = dry_folder(root, "h-killed", FAM)

    class Kill(Stub):
        def call(self, request, meta):
            if self.calls == 250:
                raise KeyboardInterrupt
            return super().call(request, meta)
    sink, _ = RUN.open_sink(f)
    try:
        R.execute(D.plan(FAM, ("H",)), Kill(law), sink, R.SpendGuard(1e9, 10 ** 9), (), 1,
                  catalog=lambda x: SLUG[x], link="dry", prepare=D.preparer(sink.records), classify=D.classify)
    except KeyboardInterrupt:
        pass
    n_before = len(R.logged(f))
    cat = (f / "catalog.jsonl").read_bytes()         # and the catalog's last read cut short with it
    (f / "catalog.jsonl").write_bytes(cat[:cat[:-1].rfind(b"\n") + 12])
    RUN.mend(f, FAM, "a kill")
    sink, _ = RUN.open_sink(f)
    done = R.resume(f, FAM, sink, lambda x: SLUG[x])
    again = n_before - len(done)
    assert again > R.CATALOG_EVERY // 2
    R.execute(D.plan(FAM, ("H",)), Stub(law), sink, R.SpendGuard(1e9, 10 ** 9), done, 1, catalog=lambda x: SLUG[x],
              link="dry", prepare=D.preparer(sink.records), classify=D.classify)
    res = quiet(RUN.verdicts, f, allow_dry=True)
    assert res["conditions"]["H"]["outcome"] == "passed" and res["calls_made_again"] == again
    assert not res["histories_not_the_answers_read"]
    h_killed = {"calls before the kill": n_before, "made again": again, "H": res["conditions"]["H"]["outcome"]}

    # python3 -O
    p = subprocess.run([sys.executable, "-O", "-B", str(HERE / "tr1_run.py"), "plan"], capture_output=True, text=True)
    assert p.returncode != 0 and "python3 -O" in p.stderr
    note("any module of this folder under python3 -O", p.stderr.strip().splitlines()[-1])
    return out, h_killed


def _refused_write(sink):
    try:
        sink({"id": "y", "text": chr(0xd83d) + chr(0xde00)})
    except UnicodeEncodeError as e:
        return f"UnicodeEncodeError: {e}"
    raise AssertionError("a surrogate pair written")


# ------------------------------------------------------------------------------------------------
# 5. The commands, in a stand-in folder

def commands(root):
    out = []
    names = set()

    def note(name, msg):
        assert name not in names, f"a command check's name repeats: {name}"
        names.add(name)
        out.append({"check": name, "result": msg[:240]})

    root = Path(root) / "commands"
    root.mkdir()
    hashes = {"told-tr1/tr1_run.py": "0" * 64}
    fc = {"link": "FROZEN.sha256", "link_commit": "c0", "freeze_commit": "c0", "hashes": hashes, "head": "h0",
          "chain": {"FROZEN.sha256": hashes}, "commits": {"FROZEN.sha256": "c0"}}
    saved = (RUN.ROOT, RUN.CLIENT, RUN.CATALOG, RUN.frozen)
    behaviour = {"decide": Formation("L.05")}
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
        # a smoke run stopped by the provider (a stop of the run), then one that passes
        behaviour["decide"] = lambda s, m: "filtered" if s["domain"] == "K" else Formation("L.05")(s, m)
        code = main("smoke", "--family", fam, "--max-usd", "1")
        runs = RUN.smoke_runs(fam)
        assert code == 0 and runs[-1]["go_on"] == {"T": True, "F": True, "K": False, "H": True}
        note("a smoke run whose K calls the provider filtered", f"exit {code}; go on {runs[-1]['go_on']}")
        note("run asking for K after that smoke run", main("run", "--family", fam, "--conditions", "K", "--max-usd", "9"))
        assert "a stop of the run" in out[-1]["result"]
        time.sleep(1.1)
        behaviour["decide"] = Formation("L.05")
        assert main("smoke", "--family", fam, "--max-usd", "1") == 0
        note("smoke where the latest smoke run passed every condition",
             main("smoke", "--family", fam, "--max-usd", "1"))
        assert "no smoke run of" in out[-1]["result"]
        rep = RUN.read_json(RUN.smoke_folders(fam)[-1] / "smoke-report.json")
        assert rep["calls"] == 16 and rep["projected_full_design"]["calls"] == 2520
        note("H asked at a parallel above 1", main("run", "--family", fam, "--conditions", "H", "--max-usd", "9",
                                                   "--parallel", "4"))
        assert "parallel 1" in out[-1]["result"]
        note("an unknown condition", main("run", "--family", fam, "--conditions", "T,X", "--max-usd", "9"))
        # the fresh conditions at parallel 4, killed partway, the log's last line cut, mended and resumed
        killed = {"n": 0}

        class Killing(Stub):
            def call(self, request, meta):
                killed["n"] += 1
                if killed["n"] == 900:
                    raise KeyboardInterrupt
                return super().call(request, meta)
        RUN.CLIENT = lambda: Killing(behaviour["decide"])
        try:
            quiet(RUN.main, ["run", "--family", fam, "--conditions", "T,F,K", "--max-usd", "50", "--parallel", "1"])
        except KeyboardInterrupt:
            pass
        out_f = RUN.scored(fam)
        with (out_f / "calls.jsonl").open("ab") as fh:
            fh.write(b'{"id": "tr1|half')
        RUN.CLIENT = lambda: Stub(lambda s, m: behaviour["decide"](s, m))
        note("run on a log cut short", main("run", "--family", fam, "--conditions", "T,F,K", "--max-usd", "50"))
        assert "a write cut short" in out[-1]["result"]
        note("verdicts on a log cut short", main("verdicts", "--family", fam))
        assert "a write cut short" in out[-1]["result"]
        assert main("mend", "--family", fam, "--cause", "a kill") == 0
        note("mend with nothing cut", main("mend", "--family", fam))
        assert "every log reads whole" in out[-1]["result"]
        before = len(R.logged(out_f))
        assert main("run", "--family", fam, "--conditions", "T,F,K", "--max-usd", "50", "--parallel", "4") == 0
        note("the fresh conditions resumed at parallel 4 after a kill and a mend",
             f"{before} records before, {len(R.logged(out_f))} after")
        assert all(RUN.read_whole(fam, c) for c in ("T", "F", "K")) and not RUN.read_whole(fam, "H")
        note("run asking only for conditions read whole",
             main("run", "--family", fam, "--conditions", "T,K", "--max-usd", "50"))
        assert "no call is left to make" in out[-1]["result"]
        # a smoke run after T, F and K began: the pin's own unreadable answers stop none of them; H not begun
        assert RUN.begun(fam) == {"T", "F", "K"}
        time.sleep(1.1)
        behaviour["decide"] = lambda s, m: "invalid"
        hashes2 = {"told-tr1/tr1_run.py": "0" * 64, "told-tr1/addenda/ADDENDUM-1.md": "1" * 64}
        fc2 = {**fc, "link": "addenda/FROZEN-1.sha256", "link_commit": "c1", "hashes": hashes2,
               "chain": {"FROZEN.sha256": hashes, "addenda/FROZEN-1.sha256": hashes2},
               "commits": {"FROZEN.sha256": "c0", "addenda/FROZEN-1.sha256": "c1"}}
        RUN.frozen = lambda repo=None: fc2           # as an addendum leaves the chain: a smoke run is needed
        code = main("smoke", "--family", fam, "--max-usd", "1")
        runs = RUN.smoke_runs(fam)
        assert runs[-1]["stands"]["H"] and not any(runs[-1]["stands"][c] for c in ("T", "F", "K"))
        note("a smoke run of prose answers after T, F and K began", f"exit {code}; stands {RUN.stood(runs)}")
        note("run asking for H after a stop that stands",
             main("run", "--family", fam, "--conditions", "H", "--max-usd", "50"))
        assert "a stop that stands" in out[-1]["result"]
        note("smoke where no condition can be released",
             main("smoke", "--family", fam, "--max-usd", "1"))
        assert "no smoke run of" in out[-1]["result"]
        assert main("verdicts", "--family", fam) == 0
        v = RUN.read_json(out_f / "verdicts.json")
        assert v["reading"]["bridge"] == "passed" and v["conditions"]["H"] is None and v["stops_that_stand"]["H"]
        assert v["lines_moved_by_mend"]["calls.jsonl.cut"]["notes"]
        note("verdicts after the kill, the mend and the resume",
             f"bridge {v['reading']['bridge']}; H {v['not_read_whole']['H']}; made again {v['calls_made_again']}")
        # H on another pin, then a lock held
        fam2 = PINS[1]
        behaviour["decide"] = Formation("HOrd", fam2)
        assert main("smoke", "--family", fam2, "--max-usd", "1") == 0
        assert main("run", "--family", fam2, "--conditions", "H", "--max-usd", "50") == 0
        assert main("verdicts", "--family", fam2) == 0
        v2 = RUN.read_json(RUN.scored(fam2) / "verdicts.json")
        assert v2["conditions"]["H"]["outcome"] == "passed" and v2["reading"]["bridge"] == "no verdict"
        note("H alone on a second pin, through the commands", f"H {v2['conditions']['H']['outcome']}; "
             f"bridge {v2['reading']['bridge']} ({v2['reading']['why']})")
        with RUN.pin_lock(fam2):
            note("verdicts while another command holds the lock", main("verdicts", "--family", fam2))
        assert "another command" in out[-1]["result"]
        # a third pin: a start of all four killed in the fresh calls begins no H; the catalog's last read cut and
        # mended, so calls are made again; after an addendum, one unreadable H answer and a begun T's unreadable
        # answers each stop only as a stop of the run, lifted by a smoke run that passes; then the whole plan,
        # H's 630 calls made in full under the folder's spend guard
        fam3 = PINS[2]
        behaviour["decide"] = Formation("L.05", fam3)
        assert main("smoke", "--family", fam3, "--max-usd", "1") == 0
        killed["n"] = 0
        RUN.CLIENT = lambda: Killing(behaviour["decide"])
        try:
            quiet(RUN.main, ["run", "--family", fam3, "--max-usd", "50"])
        except KeyboardInterrupt:
            pass
        RUN.CLIENT = lambda: Stub(lambda s, m: behaviour["decide"](s, m))
        out3 = RUN.scored(fam3)
        assert RUN.begun(fam3) == {"T", "F", "K"}
        note("a start of all four killed before any H call", f"begun {sorted(RUN.begun(fam3))}")
        cat = (out3 / "catalog.jsonl").read_bytes()
        (out3 / "catalog.jsonl").write_bytes(cat[:cat[:-1].rfind(b"\n") + 12])
        assert main("mend", "--family", fam3, "--cause", "a kill") == 0
        hashes3 = {**hashes2, "told-tr1/addenda/ADDENDUM-2.md": "2" * 64}
        fc3 = {**fc2, "link": "addenda/FROZEN-2.sha256", "link_commit": "c2", "hashes": hashes3,
               "chain": {**fc2["chain"], "addenda/FROZEN-2.sha256": hashes3},
               "commits": {**fc2["commits"], "addenda/FROZEN-2.sha256": "c2"}}
        RUN.frozen = lambda repo=None: fc3
        time.sleep(1.1)
        first_h = {"n": 0}

        def one_bad(s, m):
            if s["series"] and not first_h["n"]:
                first_h["n"] = 1
                return "invalid"
            return Formation("L.05", fam3)(s, m)
        behaviour["decide"] = one_bad
        main("smoke", "--family", fam3, "--max-usd", "1")
        last = RUN.smoke_runs(fam3)[-1]
        assert not last["stands"]["H"] and not last["go_on"]["H"] and last["go_on"]["T"]
        note("one unreadable H answer at a smoke run, H not begun", f"go on {last['go_on']}; nothing stands")
        note("run after it", main("run", "--family", fam3, "--max-usd", "50"))
        assert "stopped H, a stop of the run" in out[-1]["result"]
        time.sleep(1.1)
        behaviour["decide"] = lambda s, m: ("invalid" if s["domain"] == "T" and s["none"] and not s["series"]
                                            else Formation("L.05", fam3)(s, m))
        main("smoke", "--family", fam3, "--max-usd", "1")
        last = RUN.smoke_runs(fam3)[-1]
        assert not last["stands"]["T"] and not last["go_on"]["T"] and last["go_on"]["H"]
        note("every T answer unreadable at a smoke run, T begun", f"go on {last['go_on']}; nothing stands")
        note("run asking for T after it", main("run", "--family", fam3, "--conditions", "T", "--max-usd", "50"))
        assert "stopped T, a stop of the run" in out[-1]["result"]
        time.sleep(1.1)
        behaviour["decide"] = Formation("L.05", fam3)
        assert main("smoke", "--family", fam3, "--max-usd", "1") == 0
        assert main("run", "--family", fam3, "--conditions", "T,F,K", "--max-usd", "50", "--parallel", "4") == 0
        assert main("run", "--family", fam3, "--conditions", "H", "--max-usd", "50") == 0
        assert all(RUN.read_whole(fam3, c) for c in D.CONDITIONS)
        assert main("verdicts", "--family", fam3) == 0
        v3 = RUN.read_json(out3 / "verdicts.json")
        assert v3["reading"]["bridge"] == "passed" and v3["calls_made_again"] > 0
        assert v3["reads_naming_no_snapshot_put_in_by_mend"]
        note("the whole plan after the kill, the mend, the addendum and three smoke runs",
             f"bridge {v3['reading']['bridge']}; {len(R.logged(out3))} records, {v3['calls_made_again']} calls made again; "
             f"H's 630 made in full")
    finally:
        RUN.ROOT, RUN.CLIENT, RUN.CATALOG, RUN.frozen = saved
    return out


def main():
    start = code_hashes()
    told = dict(reversed(ln.split()) for ln in (R.REPO / R.TOLD / "FROZEN.sha256").read_text().splitlines() if ln.strip())
    assert all(f in told for f in FILES if f.startswith(REL + "told/")) \
        and all(start[f] == told[f] for f in FILES if f in told), "freeze 1's files have freeze 1's hashes"
    root = Path(tempfile.mkdtemp(prefix="tr1-dry-"))
    try:
        rows, answers = formations(root)
        n_rule = against_stage0(answers)
        pr = prompts()
        refs, h_killed = refusals(root, answers)
        cmds = commands(root)
    finally:
        shutil.rmtree(root, ignore_errors=True)
    est = {f: RUN.estimate(f) for f in PINS}
    res = {"test": D.TEST, "seed": D.SEED, "python": sys.version.split()[0],
           "design": {"presentations": len(D.DESIGN.pres), "r": D.R_CALLS, "q": D.Q,
                      "calls per condition": 70 * D.R_CALLS, "conditions": list(D.CONDITIONS),
                      "calls per pin": 4 * 70 * D.R_CALLS, "pins": len(PINS), "calls in all": 4 * 70 * D.R_CALLS * len(PINS),
                      "smoke calls per pin": len(D.plan(FAM, smoke=True)),
                      "met presentations": sum(D.DESIGN.met), "course order": D.DESIGN.course_order},
           "formations": rows, "rule against Stage 0 (conditions and answer sets compared)": n_rule,
           "prompts": pr, "refusals": refs, "parser shapes read as section 3 says": 9,
           "random answer sets compared": 400, "formations' conditions compared": n_rule - 400,
           "a stop that stands at a smoke run, at one unreadable answer in twenty a call":
               {"a condition (two or more of its four)": round(1 - 0.95 ** 4 - 4 * 0.05 * 0.95 ** 3, 4),
                "on at least one of two deciding pins": round(1 - (0.95 ** 4 + 4 * 0.05 * 0.95 ** 3) ** 2, 4),
                "were one to stand (one or more of four)": round(1 - 0.95 ** 4, 4)}, "H killed and made again": h_killed, "commands": cmds,
           "estimate": est, "seconds": round(time.time() - T0, 1),
           "code_hashes": start, "code_unchanged_during_the_run": code_hashes() == start, "ok": True}
    OUT.parent.mkdir(exist_ok=True)
    RUN.write_whole(OUT, json.dumps(res, indent=1, ensure_ascii=False) + "\n")
    print(f"{len(rows)} formations, {n_rule} rule comparisons, {len(refs)} refusals, {len(cmds)} command checks; "
          f"{res['seconds']} s")


if __name__ == "__main__":
    main()
