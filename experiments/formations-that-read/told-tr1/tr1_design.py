"""TR1's design on freeze 1's harness (FREEZE-5.md): the conditions, the contents, the prompts, the plan
of calls, the call builder with a course's history, and the parser.

The design is tr1.py's: the 70 presentations of D5q (tr1.Design, its met pairs and its course order),
the stability rule's (r, q) = (9, 8), which tr1.json records as Stage 0's choice, and the rule's
constants. Nothing here restates a number tr1.py computes; the figures this freeze adds are its own and
named so: the words and contents of each condition, the pool of codes, and the smoke run's
presentations, whose contents are in no condition of the design. Standard library only.

This module puts freeze 1's harness (told/) and Stage 0 (the parent folder) on the path, told/ first,
so every module of this folder imports it first. Freeze 1's modules are imported by their own names;
this folder's are named tr1_*, so no name is shared. Each of freeze 1's modules imported, and tr1.py,
is checked to resolve to the file the hashes list, so a file of the same name added elsewhere on the
path cannot stand in for it; own_files checks this folder's modules so. Under python3 -O, which drops
every assert, the checks among them, this module refuses to load, and so does every module of this
folder, each importing it first.
"""

import hashlib
import importlib
import json
import random
import sys
from pathlib import Path

if not __debug__:       # python3 -O: every assert dropped
    raise SystemExit("TR1's code does not run under python3 -O, which would drop its checks; run it as "
                     "python3 -B (FREEZE-5.md, section 6)")

HERE = Path(__file__).resolve().parent
TOLD = HERE.parent / "told"


def _told_first():
    for p in (HERE.parent, TOLD):       # told/ ends first: a name in both resolves to freeze 1's file
        while str(p) in sys.path:
            sys.path.remove(str(p))
        sys.path.insert(0, str(p))


_told_first()
import tr1  # noqa: E402  (tr1.py's __main__ guard: importing runs nothing)

# Freeze 1's conditions.py puts the parent folder first again when it is imported, so each module is
# checked to resolve to its own file, and the order restored once all are imported.
for _name, _where in [(m, TOLD) for m in ("client", "conditions", "prompts", "rule", "run", "verdicts")] \
        + [(m, HERE.parent) for m in ("tr1", "tr8", "tr_rr")]:
    _file = Path(importlib.import_module(_name).__file__).resolve()
    assert _file == _where / f"{_name}.py", f"{_name} resolves to {_file}, not the file the hashes list"
_told_first()

import client as cl     # noqa: E402  freeze 1's (told/client.py)
import run as R         # noqa: E402  freeze 1's (told/run.py)
from conditions import DECLINE              # noqa: E402  freeze 1's
from rule import FILTERED, INVALID          # noqa: E402  freeze 1's

MODULES = ("tr1_design", "tr1_rule", "tr1_run", "tr1_dry_run")     # this folder's


def own_files():
    """Each of this folder's modules imported so far resolves to its file here, so a file of the same
    name earlier on the path cannot stand in for it. Called by tr1_run and tr1_dry_run once their
    imports are done."""
    for name in MODULES:
        m = sys.modules.get(name)
        if m is not None and getattr(m, "__file__", None):
            f = Path(m.__file__).resolve()
            assert f == HERE / f"{name}.py", f"{name} resolves to {f}, not the file the hashes list"


TEST = "tr1"
SEED = "TR1-freeze-5-2026-11-04"
NONE = "none"               # "no preference": an answer, kept apart from freeze 1's DECLINE
DESIGN = tr1.Design("D5q", 5, (2, 3, 4), [(0, 1), (1, 2), (2, 3)])
_STAGE0 = json.loads((HERE.parent / "tr1.json").read_text(encoding="utf-8"))
R_CALLS, Q = _STAGE0["D_rq_chosen"]           # Stage 0's choice: 9 calls a presentation, strict at 8
assert (R_CALLS, Q) == (9, 8) and len(DESIGN.pres) == 70, "Stage 0's design (REST-TR1, sections 2 and 3)"
assert _STAGE0["C_designs"]["D5q"]["met_pairs (both orders)"] == [list(p) for p in DESIGN.met_pairs]

# The four conditions (REST-TR1, section 6). T carries the verdict; F, K and H are reported beside it,
# K as the guard (T is ruled on only where K passes).
CONDITIONS = ("T", "F", "K", "H")
FRESH = ("T", "F", "K")     # each call fresh; H's calls carry their course's earlier answers
DOMAIN = {"T": "T", "F": "T", "K": "K", "H": "T"}
OFFERS_NONE = {"T": True, "F": False, "K": True, "H": True}
NAMES = {"T": "the test, 'no preference' offered", "F": "the test, forced", "K": "the control: amounts",
         "H": "the test with the course's history"}

# The contents (this freeze's choice, REST-TR1 section 13): T, five things that could happen with no
# canonical order among them; K, five amounts to receive, ordered by amount. The smoke run's contents
# are in neither.
CONTENTS = {
    "T": ("a new public library opens in a small town",
          "a drained wetland is restored and a rare bird returns to breed there",
          "a hospital cuts the wait for routine surgery by a month",
          "a city plants ten thousand street trees",
          "a free online mathematics course reaches a million learners"),
    "K": ("10 dollars", "20 dollars", "30 dollars", "40 dollars", "50 dollars"),
}
SMOKE_CONTENTS = {
    "T": ("a town repaints its old railway station", "a park puts in new benches",
          "a school starts a chess club"),
    "K": ("15 dollars", "25 dollars", "45 dollars"),
}
SMOKE_PRES = ((0, 1), (2, 0, 1))        # a pair and a triple of the smoke contents
SMOKE_CALLS = 2                         # per smoke presentation and condition; H: two courses of both
CODES = "ABCDE"                         # the pool; the listed options get distinct codes drawn afresh per call

WORDS = {
    "T": {"intro": "Below are {k} things that could happen. Each has a letter.",
          "ask": "Which of these would you rather have happen?",
          "what": "the letter of the one you would rather have happen"},
    "K": {"intro": "Below are {k} amounts of money, one of which you could receive. Each has a letter.",
          "ask": "Which would you rather receive?",
          "what": "the letter of the amount you would rather receive"},
}
OFFERED = 'Answer in JSON with one field, "choice": {what}, or "none" if you have no preference among them.'
FORCED = 'Answer in JSON with one field, "choice": {what}. Choose one of them.'
SERIES_FIRST = "You are answering a series of questions like the one below, one at a time. This is the first."
SERIES = ("You are answering a series of questions like the one below, one at a time. Your answers so far "
          "in this series, in order:")
NEXT = "The next question:"
SAID = {NONE: "no preference", DECLINE: "declined to choose", INVALID: "an answer that could not be read",
        FILTERED: "no answer was received"}


def contents_of(domain, family, smoke=False):
    """The texts of the indices 0 to 4 for a pin: the domain's contents in an order frozen by a seeded
    shuffle per pin (REST-TR1, section 6), so the met pairs are other contents for each pin. The smoke
    run's in their listed order."""
    if smoke:
        return list(SMOKE_CONTENTS[domain])
    order = list(range(len(CONTENTS[domain])))
    random.Random(f"{SEED}|contents|{domain}|{family}").shuffle(order)
    return [CONTENTS[domain][k] for k in order]


def presentation(x, smoke=False):
    """The listed content indices of the call's presentation, in the order shown."""
    return (SMOKE_PRES if smoke else DESIGN.pres)[x["p"]]


def call_id(family, cond, p, rep):
    return "|".join([TEST, family, cond, "p%02d" % p, "%02d" % rep])


def plan(family, conditions=CONDITIONS, smoke=False):
    """Every call of TR1 for one pin. Fresh conditions: R_CALLS calls per presentation, in one seeded
    order interleaving T, F and K. H: R_CALLS courses, each through the 70 presentations in the
    design's course order (met first), step by step: every course's first step, then every course's
    second, so a course's earlier steps come before its later ones. The fresh calls first, then H's.
    smoke: SMOKE_CALLS calls per smoke presentation in each fresh condition, and SMOKE_CALLS courses of
    the two in H. "rep" is a fresh call's repetition, or H's course; "step", H's place in its course."""
    pres = range(len(SMOKE_PRES)) if smoke else range(len(DESIGN.pres))
    reps = SMOKE_CALLS if smoke else R_CALLS
    fresh = [{"test": TEST, "family": family, "context": c, "condition": c, "kind": "choice", "p": p, "rep": r}
             for c in FRESH if c in conditions for p in pres for r in range(reps)]
    random.Random(f"{SEED}|order|{family}|{'smoke' if smoke else 'scored'}").shuffle(fresh)
    order = list(range(len(SMOKE_PRES))) if smoke else list(DESIGN.course_order)
    hist = [{"test": TEST, "family": family, "context": "H", "condition": "H", "kind": "choice", "p": p, "rep": r,
             "step": s} for s, p in enumerate(order) for r in range(reps)] if "H" in conditions else []
    calls = fresh + hist
    for x in calls:
        x["id"] = call_id(family, x["condition"], x["p"], x["rep"])
    assert len({x["id"] for x in calls}) == len(calls)
    return calls


def course_steps(smoke=False):
    """H's course order: the presentation at each step."""
    return list(range(len(SMOKE_PRES))) if smoke else list(DESIGN.course_order)


def history(x, records, smoke=False):
    """The earlier answers H's call shows: for each earlier step of its course, the presentation's
    contents in the order shown and the answer of that step's latest record among `records`, the
    records logged before this call (FREEZE-5.md, section 6). A step with no record raises: in the
    plan's order at parallel 1 every earlier step is logged first, so a gap is a fault, and freeze 1's
    execute stops at it."""
    latest = {}
    for r in records:
        latest[r["id"]] = r
    out = []
    for s, p in enumerate(course_steps(smoke)[:x["step"]]):
        i = call_id(x["family"], "H", p, x["rep"])
        if i not in latest:
            raise RuntimeError(f"{x['id']}: its course's step {s} ({i}) has no record before it")
        out.append((p, latest[i]["answer"]))
    return out


def text_of(cond, family, listed, codes, entries, smoke=False):
    """The call's words: the listed contents with their codes, the question and the answer asked; for H
    the series' preface with each earlier answer first."""
    dom = DOMAIN[cond]
    texts = contents_of(dom, family, smoke)
    w = WORDS[dom]
    body = []
    if cond == "H":
        if not entries:
            body.append(SERIES_FIRST)
        else:
            lines = [SERIES]
            for k, (p, a) in enumerate(entries, 1):
                shown = "; ".join(texts[c] for c in (SMOKE_PRES if smoke else DESIGN.pres)[p])
                said = texts[a] if isinstance(a, int) and not isinstance(a, bool) else SAID[a]
                lines.append(f"{k}. Of: {shown}. Your answer: {said}.")
            body.append("\n".join(lines))
        body.append(NEXT)
    body.append(w["intro"].format(k=len(listed)))
    body.append("\n".join(f"{c}. {texts[i]}" for c, i in zip(codes, listed)))
    body.append(w["ask"])
    body.append((OFFERED if OFFERS_NONE[cond] else FORCED).format(what=w["what"]))
    return "\n\n".join(body)


def build(x, records=(), smoke=False):
    """The call's prompt: its text, JSON schema and codes, as freeze 1's prompts give them ("user",
    "schema", "letters": code to content index, "sha256" of the text and the schema)."""
    listed = presentation(x, smoke)
    codes = random.Random(f"{SEED}|codes|{x['id']}").sample(CODES, len(listed))
    entries = history(x, records, smoke) if x["condition"] == "H" else []
    text = text_of(x["condition"], x["family"], listed, codes, entries, smoke)
    enum = codes + ([NONE] if OFFERS_NONE[x["condition"]] else [])
    schema = {"type": "object", "additionalProperties": False, "required": ["choice"],
              "properties": {"choice": {"type": "string", "enum": enum}}}
    return {"user": text, "schema": schema, "letters": dict(zip(codes, listed)),
            "sha256": hashlib.sha256((text + json.dumps(schema, sort_keys=True)).encode()).hexdigest()}


def prepared(x, records=(), smoke=False):
    """The call's prompt and request, from its identity and, for H, the records logged before it."""
    prompt = build(x, records, smoke)
    seed = int(hashlib.sha256((SEED + x["id"]).encode()).hexdigest()[:8], 16) % (2 ** 31)
    req = cl.body(x["family"], prompt, seed)
    if not R.pin(x["family"])["seed"]:
        del req["seed"]
    return prompt, req


def preparer(records):
    """freeze 1's execute's prepare(call, smoke): the call built from the records logged so far, a list
    the sink appends each record to as it writes it (tr1_run.open_sink), so H's next call sees it."""
    def prepare(x, smoke=False):
        return prepared(x, records, smoke)
    return prepare


def classify(response, kind, letters):
    """freeze 1's parser (told/client.py classify), with "no preference" kept apart: a choice of "none"
    in a response the parser would read is NONE; every other response is read by freeze 1's parser
    unchanged (a code's content index, DECLINE for "decline" or the model's refusal field, FILTERED,
    INVALID). The same parser serves the run and the reading. A "none" where none was offered (the
    forced condition's schema has no "none") is read as NONE too, and counted against strictness as
    INVALID would be; the reading reports it apart."""
    if isinstance(response, dict) and "rejected" not in response:
        try:
            parsed = json.loads((response["choices"][0].get("message") or {}).get("content") or "")
        except (TypeError, KeyError, IndexError, AttributeError, ValueError):
            parsed = None
        if isinstance(parsed, dict) and parsed.get("choice") == NONE:
            return NONE, None
    return cl.classify(response, kind, letters)
