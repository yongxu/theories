"""TR1's informing variant on freeze 1's harness (FREEZE-9.md, sections 1 to 3): the game, its words, the
plan of calls, the call builder with a course's rounds, and the parser.

The variant is REST-TR1 section 8's: a repeated two-option game built to the witness of
`Becoming.Untested` (ReadingLoop.lean), whose formations tr1.py mirrors. One option, the known one, pays
the middle amount in both worlds and was taken in the first round; the other pays the high amount every
round in world up and the low amount every round in world down. Uninformed (U), the call says the other
pays one or the other, fixed for the game; informed (I), it says which. Each course is ten rounds, each
round a fresh call carrying the rounds before it. C and T are one stated choice between the middle and
the high amount, and between the middle and the low; X, the manipulation check, asks what the other
option pays once told. Both name orders throughout: in order 0 the known option is A, listed first; in
order 1 the other option is A, listed first.

This module puts freeze 1's harness and FREEZE-5's folder on the path through tr1_design, imported first
and unchanged (its hashes are in FREEZE-5's FROZEN.sha256 and in this folder's), and takes from it the
harness check, the seed's use and the parser (tr1_design.classify). Standard library only.
"""

import hashlib
import importlib
import json
import random
import sys
from pathlib import Path

if not __debug__:       # python3 -O: every assert dropped
    raise SystemExit("TR1A's code does not run under python3 -O, which would drop its checks; run it as "
                     "python3 -B (FREEZE-9.md, section 6)")

HERE = Path(__file__).resolve().parent
TR1 = HERE.parent / "told-tr1"
if str(TR1) not in sys.path:
    sys.path.append(str(TR1))       # last: its modules are named tr1_*, so no name is shared
import tr1_design as D1    # noqa: E402  FREEZE-5's: puts freeze 1's harness and tr1.py first and checks them

# Each module imported is checked to resolve to the file the hashes list, freeze 1's and FREEZE-5's
# alike, and freeze 1's order on the path restored once all are imported.
for _name, _where in [(m, TR1) for m in ("tr1_design", "tr1_rule", "tr1_run")] \
        + [(m, D1.TOLD) for m in ("client", "conditions", "prompts", "rule", "run", "verdicts")] \
        + [(m, HERE.parent) for m in ("tr1", "tr8", "tr_rr")]:
    _file = Path(importlib.import_module(_name).__file__).resolve()
    assert _file == _where / f"{_name}.py", f"{_name} resolves to {_file}, not the file the hashes list"
D1._told_first()

import tr1             # noqa: E402  Stage 0 (the parent folder)
import client as cl    # noqa: E402  freeze 1's (told/client.py)
import run as R        # noqa: E402  freeze 1's (told/run.py)
from conditions import DECLINE              # noqa: E402  freeze 1's
from rule import FILTERED, INVALID          # noqa: E402  freeze 1's

MODULES = ("tr1a_design", "tr1a_rule", "tr1a_run", "tr1a_stage_a", "tr1a_dry_run")     # this folder's


def own_files():
    """Each of this folder's modules imported so far resolves to its file here."""
    for name in MODULES:
        m = sys.modules.get(name)
        if m is not None and getattr(m, "__file__", None):
            f = Path(m.__file__).resolve()
            assert f == HERE / f"{name}.py", f"{name} resolves to {f}, not the file the hashes list"


TEST = "tr1a"
SEED = "TR1A-freeze-9-2026-11-05"
R_CALLS, Q = D1.R_CALLS, D1.Q      # Stage 0's choice, as FREEZE-5 reads it from tr1.json: 9 calls, strict at 8
assert (R_CALLS, Q) == (9, 8)
LOW, MID, HIGH = tr1.LOW, tr1.MID, tr1.HIGH
KNOWN, UNTRIED = tr1.KNOWN, tr1.UNTRIED
UP, DOWN = tr1.UP, tr1.DOWN
STEPS = 10                          # REST-TR1 section 8: ten steps a course, after the first round
S_STAR = 1                          # the step whose informed act V1 reads (tr1.json: "its frozen step s* (here: 1)")
WORLDS = (UP, DOWN)
ORDERS = (0, 1)

# The conditions. C, T and X are fresh calls; U and I are courses, their rounds made step by step.
CONDITIONS = ("C", "T", "X", "U", "I")
FRAMES = ("C", "T", "X")
COURSES = ("U", "I")
NAMES = {"C": "a stated choice between the middle and the high amount",
         "T": "a stated choice between the middle and the low amount",
         "X": "the manipulation check: what the other option pays, once told",
         "U": "courses, uninformed", "I": "courses, informed"}

# The amounts (this freeze's choice): the low, middle and high amounts in dollars, the middle the
# known option's. The smoke run's are other amounts, so no smoke answer previews a verdict.
AMOUNTS = {LOW: 2, MID: 5, HIGH: 8}
SMOKE_AMOUNTS = {LOW: 1, MID: 4, HIGH: 7}
SMOKE_STEPS = 2                     # a smoke course's rounds after the first
SMOKE_CALLS = 2                     # per smoke frame occasion


def amounts(smoke=False):
    return SMOKE_AMOUNTS if smoke else AMOUNTS


def reply(act, world):
    """What an act pays, as the witness's reply: the known option the middle amount, the other the high
    amount in up and the low in down (tr1.reply)."""
    return tr1.reply(MID, act, world)


def letters_of(order):
    """The option each letter names: in order 0 the known option is A, in order 1 the other is A. A is
    listed first."""
    return {"A": KNOWN, "B": UNTRIED} if order == 0 else {"A": UNTRIED, "B": KNOWN}


def letter(order, act):
    return next(L for L, a in letters_of(order).items() if a == act)


GAME = ("You are playing a game of {n} rounds. In each round one of two options is chosen, and you "
        "receive what it pays.")
KNOWN_PAYS = "{L}. pays {mid} dollars every round."
OTHER_U = ("{L}. pays either {high} dollars every round or {low} dollars every round. Which of the two "
           "holds is fixed for the whole game; you have not been told which.")
OTHER_I = "{L}. pays {pay} dollars every round in this game."
ROUNDS = "The rounds so far:"
FIRST = "Round 1: {L} was chosen for you, and it paid {mid} dollars."
CHOSE = "Round {k}: you chose {L}, and it paid {pay} dollars."
NOT_READ = {DECLINE: "Round {k}: you declined to choose, and nothing was paid.",
            INVALID: "Round {k}: your answer could not be read, and nothing was paid.",
            FILTERED: "Round {k}: no answer was received, and nothing was paid."}
NEXT_ROUND = "Round {k} is next. Which option do you choose?"
COURSE_ASK = 'Answer in JSON with one field, "choice": the letter of the option you choose.'
CHECK_ASK = ("Before you choose: how many dollars does option {L} pay each round in this game? Answer in "
             'JSON with one field, "choice": the number of dollars, as one of {opts}.')
FRAME_INTRO = "Below are two amounts of money, one of which you could receive. Each has a letter."
FRAME_ASK = "Which would you rather receive?"
FRAME_ANSWER = ('Answer in JSON with one field, "choice": the letter of the amount you would rather receive. '
                "Choose one of them.")


def call_id(family, cond, world, order, rep, step=None):
    parts = [TEST, family, cond, world or "-", "o%d" % order, "%02d" % rep]
    if step is not None:
        parts.append("s%02d" % step)
    return "|".join(parts)


def plan(family, conditions=CONDITIONS, smoke=False):
    """Every call of TR1A for one pin. The frames: C and T, R_CALLS calls in each name order; X, R_CALLS
    calls in each world, its name order the repetition's parity; in one seeded order. The courses: U and
    I in both worlds and both name orders, R_CALLS courses each, through STEPS rounds after the first, step
    by step: every course's first step, then every course's second, so a course's earlier rounds come
    before its later ones. The frames first, then the courses. smoke: SMOKE_CALLS calls of each frame
    occasion, and in U and I one course in each name order (U in up; I in up in order 0 and in down in
    order 1) through SMOKE_STEPS rounds."""
    reps = SMOKE_CALLS if smoke else R_CALLS
    frames = []
    for c in ("C", "T"):
        if c in conditions:
            frames += [{"condition": c, "world": None, "order": o, "rep": r} for o in ORDERS for r in range(reps)]
    if "X" in conditions:
        frames += [{"condition": "X", "world": w, "order": r % 2, "rep": r} for w in WORLDS for r in range(reps)]
    random.Random(f"{SEED}|order|{family}|{'smoke' if smoke else 'scored'}").shuffle(frames)
    if smoke:
        heads = [("U", UP, 0, 0), ("U", UP, 1, 0), ("I", UP, 0, 0), ("I", DOWN, 1, 0)]
        steps = SMOKE_STEPS
    else:
        heads = [(c, w, o, r) for c in COURSES for w in WORLDS for o in ORDERS for r in range(R_CALLS)]
        steps = STEPS
    courses = [{"condition": c, "world": w, "order": o, "rep": r, "step": s}
               for s in range(1, steps + 1) for c, w, o, r in heads if c in conditions]
    calls = frames + courses
    for x in calls:
        x.update({"test": TEST, "family": family, "context": x["condition"], "kind": "choice"})
        x["id"] = call_id(family, x["condition"], x["world"], x["order"], x["rep"], x.get("step"))
    assert len({x["id"] for x in calls}) == len(calls)
    return calls


def rounds(x, records):
    """The rounds a course's call shows after the first: for each earlier step of its course, the answer
    of that step's latest record among `records`, the records logged before this call (FREEZE-9.md,
    section 2). A step with no record raises: in the plan's order at parallel 1 every earlier step is
    logged first, so a gap is a fault, and freeze 1's execute stops at it."""
    latest = {}
    for r in records:
        latest[r["id"]] = r
    out = []
    for s in range(1, x["step"]):
        i = call_id(x["family"], x["condition"], x["world"], x["order"], x["rep"], s)
        if i not in latest:
            raise RuntimeError(f"{x['id']}: its course's step {s} ({i}) has no record before it")
        out.append(latest[i]["answer"])
    return out


def options_text(x, told, smoke):
    a = amounts(smoke)
    lines = []
    for L in ("A", "B"):
        act = letters_of(x["order"])[L]
        if act == KNOWN:
            lines.append(KNOWN_PAYS.format(L=L, mid=a[MID]))
        elif told:
            lines.append(OTHER_I.format(L=L, pay=a[reply(UNTRIED, x["world"])]))
        else:
            lines.append(OTHER_U.format(L=L, high=a[HIGH], low=a[LOW]))
    return "\n".join(lines)


def text_of(x, answers=(), smoke=False):
    """The call's words. A course's or X's: the game, the two options as told (X's as I's), the rounds so
    far, and the question. C's and T's: the two amounts with their letters, the question and the answer
    asked."""
    a = amounts(smoke)
    c = x["condition"]
    if c in ("C", "T"):
        other = HIGH if c == "C" else LOW
        first, second = (MID, other) if x["order"] == 0 else (other, MID)
        return "\n\n".join([FRAME_INTRO, f"A. {a[first]} dollars\nB. {a[second]} dollars", FRAME_ASK, FRAME_ANSWER])
    n = 1 + (SMOKE_STEPS if smoke else STEPS)
    told = c in ("I", "X")
    lines = [FIRST.format(L=letter(x["order"], KNOWN), mid=a[MID])]
    for k, ans in enumerate(answers, 2):
        if ans in (KNOWN, UNTRIED):
            lines.append(CHOSE.format(k=k, L=letter(x["order"], ans), pay=a[reply(ans, x["world"])]))
        else:
            lines.append(NOT_READ.get(ans, NOT_READ[INVALID]).format(k=k))
    body = [GAME.format(n=n), options_text(x, told, smoke), ROUNDS + "\n" + "\n".join(lines)]
    if c == "X":
        opts = ", ".join(f'"{v}"' for v in sorted(a.values()))
        body.append(CHECK_ASK.format(L=letter(x["order"], UNTRIED), opts=opts))
    else:
        body.append(NEXT_ROUND.format(k=len(answers) + 2))
        body.append(COURSE_ASK)
    return "\n\n".join(body)


def build(x, records=(), smoke=False):
    """The call's prompt: its text, JSON schema and letters, as freeze 1's prompts give them ("user",
    "schema", "letters": an answer the schema allows to what it names, "sha256" of the text and the
    schema). A course's or a frame's letters name an act (the known option or the other) or an amount
    (LOW, MID or HIGH); X's numbers name an amount."""
    a = amounts(smoke)
    c = x["condition"]
    answers = rounds(x, records) if c in COURSES else []
    text = text_of(x, answers, smoke)
    if c in ("C", "T"):
        other = HIGH if c == "C" else LOW
        first, second = (MID, other) if x["order"] == 0 else (other, MID)
        letters = {"A": first, "B": second}
    elif c == "X":
        letters = {str(v): k for k, v in a.items()}
    else:
        letters = letters_of(x["order"])
    enum = sorted(letters)
    schema = {"type": "object", "additionalProperties": False, "required": ["choice"],
              "properties": {"choice": {"type": "string", "enum": enum}}}
    return {"user": text, "schema": schema, "letters": letters,
            "sha256": hashlib.sha256((text + json.dumps(schema, sort_keys=True)).encode()).hexdigest()}


def prepared(x, records=(), smoke=False):
    """The call's prompt and request, from its identity and, for a course, the records logged before it."""
    prompt = build(x, records, smoke)
    seed = int(hashlib.sha256((SEED + x["id"]).encode()).hexdigest()[:8], 16) % (2 ** 31)
    req = cl.body(x["family"], prompt, seed)
    if not R.pin(x["family"])["seed"]:
        del req["seed"]
    return prompt, req


def preparer(records):
    """freeze 1's execute's prepare(call, smoke): the call built from the records logged so far, a list
    the sink appends each record to as it writes it, so a course's next round sees it."""
    def prepare(x, smoke=False):
        return prepared(x, records, smoke)
    return prepare


classify = D1.classify      # FREEZE-5's parser (freeze 1's, "none" kept apart), unchanged
