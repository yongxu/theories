"""SCL, the self-confirming lock on agents (FREEZE-12.md, sections 1 to 3): the arms, their words, the plan of
calls, the call builder with a course's rounds, the belief probe and the parser.

The game is FREEZE-10's (told-tr1a/tr1a_design.py, imported unchanged and checked to resolve to the file its
freeze hashes): two options, the known one paying the middle amount in both worlds and chosen for the player in
round 1, the other paying the high amount every round in world up and the low amount every round in world down,
fixed for the game; the words are tr1a_design's own sentences. What SCL adds is the two exits of
`ReadingLoop.Loop.rests_of_unrefuted`'s witness and the controls that should not leave the lock:

  B    the lock, read long: every round after the first free, through round 21 of an announced 21;
  E1   the first exit: round 3 chosen for the player as the other option, its pay shown (the explorer start);
  N2a  E1's twin: round 3 chosen for the player as the known option (an answer of the known kind, assigned);
  E2   the second exit: round 3 as in N2a, then a told reading of the world (what the other option pays);
  N2b  E2's twin: round 3 as in N2a, then a telling of what the known option pays (a reading not of the world);
  N3   N2a reworded: every sentence paraphrased, every fact kept (checked on the words by the dry run);
  C    FREEZE-10's stated choice between the middle and the high amount, its words and letters (tr1a_design.build).

Each short arm is read through round 6 of the announced 21; every arm announces the same game, so every course
starts from one start. Both name orders throughout, both worlds. The belief probe is a forked call: a course's
words at a round with the question replaced by what the other option pays, its three answers the low amount, the
high amount, or either (not known which); the course never carries it. Standard library only.
"""

import hashlib
import importlib
import json
import random
import sys
from pathlib import Path

if not __debug__:       # python3 -O: every assert dropped
    raise SystemExit("SCL's code does not run under python3 -O, which would drop its checks; run it as python3 -B "
                     "(FREEZE-12.md, section 6)")

HERE = Path(__file__).resolve().parent
PARENT = HERE.parent
TR1A = PARENT / "told-tr1a"
if str(TR1A) not in sys.path:
    sys.path.append(str(TR1A))       # last: its modules are named tr1a_*, so no name is shared
import tr1a_design as D10    # noqa: E402  FREEZE-10's: puts FREEZE-5's folder, freeze 1's harness and tr1.py first
import tr1a_run as T1A       # noqa: E402  FREEZE-10's run: its frozen check of freeze 1, FREEZE-5 and FREEZE-10

D1 = D10.D1                  # FREEZE-5's tr1_design
for _name, _where in [(m, TR1A) for m in ("tr1a_design", "tr1a_rule", "tr1a_run")] \
        + [(m, PARENT / "told-tr1") for m in ("tr1_design", "tr1_rule", "tr1_run")] \
        + [(m, D1.TOLD) for m in ("client", "conditions", "prompts", "rule", "run", "verdicts")] \
        + [(m, PARENT) for m in ("tr1", "tr8", "tr_rr")]:
    _file = Path(importlib.import_module(_name).__file__).resolve()
    assert _file == _where / f"{_name}.py", f"{_name} resolves to {_file}, not the file the hashes list"
D1._told_first()
if str(HERE) in sys.path:
    sys.path.remove(str(HERE))
sys.path.insert(0, str(HERE))        # this folder's modules (scl_*) first; no name is shared with the others

import tr1             # noqa: E402  Stage 0 of TR1 (the parent folder): the witness's mirror
import client as cl    # noqa: E402  freeze 1's (told/client.py)
import run as R        # noqa: E402  freeze 1's (told/run.py)
from conditions import DECLINE              # noqa: E402  freeze 1's
from rule import FILTERED, INVALID          # noqa: E402  freeze 1's

NONE = D1.NONE
MODULES = ("scl_design", "scl_rule", "scl_stage0", "scl_run", "scl_dry_run")     # this folder's


def own_files():
    """Each of this folder's modules imported so far resolves to its file here."""
    for name in MODULES:
        m = sys.modules.get(name)
        if m is not None and getattr(m, "__file__", None):
            f = Path(m.__file__).resolve()
            assert f == HERE / f"{name}.py", f"{name} resolves to {f}, not the file the hashes list"


TEST = "scl"
SEED = "SCL-freeze-12-2026-11-05"
LOW, MID, HIGH = tr1.LOW, tr1.MID, tr1.HIGH
KNOWN, UNTRIED = tr1.KNOWN, tr1.UNTRIED
UP, DOWN = tr1.UP, tr1.DOWN
WORLDS, ORDERS = D10.WORLDS, D10.ORDERS
AMOUNTS, SMOKE_AMOUNTS = D10.AMOUNTS, D10.SMOKE_AMOUNTS      # FREEZE-10's: 2, 5, 8; the smoke run's 1, 4, 7
BOTH = "both"                       # the probe's answer: either amount, not known which
PROBE_LABELS = (LOW, HIGH, BOTH)
UNREAD = "unread"                   # a probe answer that names none of the three

N_ANN = 21                          # every arm's game: 21 rounds announced, round 1 chosen for the player
K0 = 3                              # the round of each exit and of its twin, stated in advance
REPS = 12                           # courses per arm, world and name order
C_CALLS = D10.R_CALLS               # FREEZE-10's 9 calls of C in each name order, strict at Q = 8
Q = D10.Q
SHORT_LAST = 6                      # the short arms' last round read
SHORT_PROBES = (2, 4, 7)            # probes before these rounds: the start, after the exit, three rounds on
B_PROBES = (2, 4, 7, 14, 21)

# The arms (section 1). assigned: rounds chosen for the player; told: (round after which, the option told of).
ARMS = {
    "B":   {"last": N_ANN, "assigned": {}, "told": None, "words": "base", "probes": B_PROBES},
    "E1":  {"last": SHORT_LAST, "assigned": {K0: UNTRIED}, "told": None, "words": "base", "probes": SHORT_PROBES},
    "N2a": {"last": SHORT_LAST, "assigned": {K0: KNOWN}, "told": None, "words": "base", "probes": SHORT_PROBES},
    "E2":  {"last": SHORT_LAST, "assigned": {K0: KNOWN}, "told": (K0, UNTRIED), "words": "base",
            "probes": SHORT_PROBES},
    "N2b": {"last": SHORT_LAST, "assigned": {K0: KNOWN}, "told": (K0, KNOWN), "words": "base",
            "probes": SHORT_PROBES},
    "N3":  {"last": SHORT_LAST, "assigned": {K0: KNOWN}, "told": None, "words": "paraphrase",
            "probes": SHORT_PROBES},
}
COURSE_ARMS = tuple(ARMS)
CONDITIONS = ("C",) + COURSE_ARMS
NAMES = {"B": "the lock, read through round 21 (N1: more rounds)",
         "E1": "the first exit: the other option chosen for the player at round 3",
         "N2a": "the exits' twin: the known option chosen for the player at round 3 (N2: an answer of the same kind)",
         "E2": "the second exit: round 3 as N2a's, then told what the other option pays",
         "N2b": "E2's twin: round 3 as N2a's, then told what the known option pays (N2: a telling of the same kind)",
         "N3": "N2a reworded, every fact kept (N3)",
         "C": "FREEZE-10's stated choice: 5 dollars or 8"}
# A larger or smaller model (N5) is a new pin: freeze 1's PINS.json, which an addendum may change only in a pin's
# served_as, cannot carry it, so N5 is frozen here as a plan (N5_PLAN) and runs only under a freeze of its own.
N5_PROPOSED = {"family": "qwen/qwen3.8-flash", "sibling of": "qwen/qwen3.8-max-0902",
               "why": "the smaller sibling of a deciding family, named in PINS.json's own record (a VD1 valuer)"}

SMOKE_LAST = 4                      # a smoke course's last round
SMOKE_PROBES = (2, 4)
SMOKE_C = 2


def free_rounds(arm, smoke=False):
    """The rounds whose choice the player makes: 2 to the arm's last, those chosen for the player left out."""
    a = ARMS[arm]
    last = min(a["last"], SMOKE_LAST) if smoke else a["last"]
    return [k for k in range(2, last + 1) if k not in a["assigned"]]


def probe_rounds(arm, smoke=False):
    return SMOKE_PROBES if smoke else ARMS[arm]["probes"]


LAYOUTS = ((LOW, HIGH, BOTH), (LOW, BOTH, HIGH), (HIGH, LOW, BOTH), (HIGH, BOTH, LOW), (BOTH, LOW, HIGH),
           (BOTH, HIGH, LOW))     # every order of the three answers


def layout(rep):
    """The probe's letters P, Q and R: the three answers in the order LAYOUTS[rep % 6], so that every answer is at
    every letter and place in two of a cell's twelve courses."""
    return LAYOUTS[rep % len(LAYOUTS)]


def course_key(x):
    return (x["condition"], x["world"], x["order"], x["rep"])


def call_id(family, cond, world, order, rep, what=None, k=None):
    parts = [TEST, family, cond, world or "-", "o%d" % order, "%02d" % rep]
    if what is not None:
        parts.append(("r" if what == "act" else "p") + "%02d" % k)
    return "|".join(parts)


def plan(family, conditions=CONDITIONS, smoke=False):
    """Every call of SCL for one pin. C first, in one seeded order: C_CALLS calls in each name order (SMOKE_C in a
    smoke run). Then the courses, round by round: for round k = 2, 3, ..., every course's call choosing round k
    (where k is a free round of its arm), then every probe before round k; so each course's earlier rounds come
    before its later ones and before any probe that shows them. Every arm in both worlds and both name orders,
    REPS courses each. A smoke run: one course of each arm in each name order (up in order 0, down in order 1)
    through round SMOKE_LAST, probes before rounds 2 and 4."""
    frames = []
    if "C" in conditions:
        reps = SMOKE_C if smoke else C_CALLS
        frames = [{"condition": "C", "world": None, "order": o, "rep": r, "what": "frame"}
                  for o in ORDERS for r in range(reps)]
        random.Random(f"{SEED}|order|{family}|{'smoke' if smoke else 'scored'}").shuffle(frames)
    if smoke:
        heads = [(c, w, o, 0) for c in COURSE_ARMS for o, w in ((0, UP), (1, DOWN))]
    else:
        heads = [(c, w, o, r) for c in COURSE_ARMS for w in WORLDS for o in ORDERS for r in range(REPS)]
    heads = [h for h in heads if h[0] in conditions]
    courses = []
    for k in range(2, N_ANN + 1):
        courses += [{"condition": c, "world": w, "order": o, "rep": r, "what": "act", "round": k}
                    for c, w, o, r in heads if k in free_rounds(c, smoke)]
        courses += [{"condition": c, "world": w, "order": o, "rep": r, "what": "probe", "round": k}
                    for c, w, o, r in heads if k in probe_rounds(c, smoke)]
    calls = frames + courses
    for x in calls:
        x.update({"test": TEST, "family": family, "context": x["condition"], "kind": "choice"})
        x["id"] = call_id(family, x["condition"], x["world"], x["order"], x["rep"],
                          None if x["what"] == "frame" else x["what"], x.get("round"))
    assert len({x["id"] for x in calls}) == len(calls)
    return calls


def rounds(x, records, smoke=False):
    """The answers a course's call or probe shows, before round x["round"]: for each earlier free round of its
    course, the answer of that round's latest record among `records`, the records logged before this call
    (FREEZE-12.md, section 6). A round with no record raises: in the plan's order at parallel 1 every earlier
    round is logged first, so a gap is a fault, and freeze 1's execute stops at it."""
    latest = {}
    for r in records:
        latest[r["id"]] = r
    out = {}
    for k in free_rounds(x["condition"], smoke):
        if k >= x["round"]:
            break
        i = call_id(x["family"], x["condition"], x["world"], x["order"], x["rep"], "act", k)
        if i not in latest:
            raise RuntimeError(f"{x['id']}: its course's round {k} ({i}) has no record before it")
        out[k] = latest[i]["answer"]
    return out


# ------------------------------------------------------------------------------------------------
# The words. The base words are FREEZE-10's sentences, from tr1a_design; SCL adds the round chosen for the player
# after the first (FREEZE-10's round 1 sentence at another round, asserted below), the telling (FREEZE-10's
# informed sentence as something told after a round) and the probe. The paraphrase rewords every sentence.

ASSIGNED = "Round {k}: {L} was chosen for you, and it paid {pay} dollars."
assert ASSIGNED.format(k=1, L="A", pay=5) == D10.FIRST.format(L="A", mid=5)
TOLD = "After round {k}, you were told: {L} pays {pay} dollars every round in this game."
# In a call after a telling (E2's and N2b's rounds after K0) the other option's line does not deny the telling: it
# says what was so at the start. FREEZE-10's OTHER_U is kept everywhere else, so B's words stay FREEZE-10's.
OTHER_T = ("{L}. pays either {high} dollars every round or {low} dollars every round. Which of the two holds is "
           "fixed for the whole game; you were not told which at the start.")
assert OTHER_T.split("; ")[0] == D10.OTHER_U.split("; ")[0]
assert TOLD.endswith(D10.OTHER_I.format(L="{L}", pay="{pay}")[len("{L}. "):])
PROBE_ASK = "Before you choose in round {k}: from what you have seen and been told, what does {L} pay?"
PROBE_OPTS = {LOW: "{low} dollars every round", HIGH: "{high} dollars every round",
              BOTH: "either {high} dollars every round or {low} dollars every round; it is not known which of the "
                    "two holds"}
PROBE_ANSWER = 'Answer in JSON with one field, "choice": the letter of your answer.'

BASE = {"game": D10.GAME, "known": D10.KNOWN_PAYS, "other": D10.OTHER_U, "other_told": OTHER_T, "rounds": D10.ROUNDS,
        "first": D10.FIRST,
        "assigned": ASSIGNED, "chose": D10.CHOSE, "not_read": D10.NOT_READ, "told": TOLD,
        "next": D10.NEXT_ROUND, "ask": D10.COURSE_ASK, "probe_ask": PROBE_ASK, "probe_opts": PROBE_OPTS,
        "probe_answer": PROBE_ANSWER}
PARAPHRASE = {
    "game": "This is a game lasting {n} rounds. Each round, one of two options is picked, and you get what that "
            "option gives.",
    "known": "{L}. gives {mid} dollars in each round.",
    "other": "{L}. gives either {high} dollars in each round or {low} dollars in each round. Which of these is the "
             "case stays the same for the entire game, and nobody has told you which.",
    "other_told": "{L}. gives either {high} dollars in each round or {low} dollars in each round. Which of these is "
                  "the case stays the same for the entire game, and nobody told you which at the start.",
    "rounds": "What has happened so far:",
    "first": "Round 1: {L} was picked for you, and it gave {mid} dollars.",
    "assigned": "Round {k}: {L} was picked for you, and it gave {pay} dollars.",
    "chose": "Round {k}: you picked {L}, and it gave {pay} dollars.",
    "not_read": {DECLINE: "Round {k}: you did not pick, and nothing was given.",
                 INVALID: "Round {k}: your reply could not be understood, and nothing was given.",
                 FILTERED: "Round {k}: no reply arrived, and nothing was given."},
    "told": "After round {k}, someone told you: {L} gives {pay} dollars in each round of this game.",
    "next": "Now comes round {k}. Which option do you pick?",
    "ask": 'Reply in JSON with a single field, "choice": the letter of the option you pick.',
    "probe_ask": "Before you pick in round {k}: given what you have seen and been told, what does {L} give?",
    "probe_opts": {LOW: "{low} dollars in each round", HIGH: "{high} dollars in each round",
                   BOTH: "either {high} dollars in each round or {low} dollars in each round; nobody knows which of "
                         "the two is the case"},
    "probe_answer": 'Reply in JSON with a single field, "choice": the letter of your reply.'}
WORDS = {"base": BASE, "paraphrase": PARAPHRASE}
PROBE_LETTERS = D10.CHECK_LETTERS          # P, Q, R: FREEZE-10's letters for answers that are not options


def amounts(smoke=False):
    return SMOKE_AMOUNTS if smoke else AMOUNTS


def reply(act, world):
    return D10.reply(act, world)


def text_of(x, acts, smoke=False):
    """A course call's or probe's words. acts: the answers shown, by free round before x["round"]. The game, the
    two options as described at the start (the other "either", never which; after a telling, "not told which at the
    start", OTHER_T), the rounds so far (round 1 and the arm's assigned rounds chosen for the player, its told line
    after its round), and the question: the course's choice of round x["round"], or the probe."""
    a = amounts(smoke)
    arm = ARMS[x["condition"]]
    W = WORDS[arm["words"]]
    o, k = x["order"], x["round"]
    lines = [W["first"].format(L=D10.letter(o, KNOWN), mid=a[MID])]
    for r in range(2, k):
        if r in arm["assigned"]:
            act = arm["assigned"][r]
            lines.append(W["assigned"].format(k=r, L=D10.letter(o, act), pay=a[reply(act, x["world"])]))
        else:
            ans = acts[r]
            if ans in (KNOWN, UNTRIED):
                lines.append(W["chose"].format(k=r, L=D10.letter(o, ans), pay=a[reply(ans, x["world"])]))
            else:
                lines.append(W["not_read"].get(ans, W["not_read"][INVALID]).format(k=r))
        if arm["told"] and arm["told"][0] == r:
            act = arm["told"][1]
            lines.append(W["told"].format(k=r, L=D10.letter(o, act), pay=a[reply(act, x["world"])]))
    opts = []
    for L in ("A", "B"):
        if D10.letters_of(o)[L] == KNOWN:
            opts.append(W["known"].format(L=L, mid=a[MID]))
        else:
            told_before = arm["told"] and arm["told"][0] < k
            opts.append(W["other_told" if told_before else "other"].format(L=L, high=a[HIGH], low=a[LOW]))
    body = [W["game"].format(n=N_ANN), "\n".join(opts), W["rounds"] + "\n" + "\n".join(lines)]
    if x["what"] == "probe":
        body.append(W["probe_ask"].format(k=k, L=D10.letter(o, UNTRIED)))
        body.append("\n".join(f"{L}. " + W["probe_opts"][v].format(low=a[LOW], high=a[HIGH])
                              for L, v in zip(PROBE_LETTERS, layout(x["rep"]))))
        body.append(W["probe_answer"])
    else:
        body.append(W["next"].format(k=k))
        body.append(W["ask"])
    return "\n\n".join(body)


def build(x, records=(), smoke=False):
    """The call's prompt as freeze 1's prompts give it ("user", "schema", "letters", "sha256"). C's is FREEZE-10's
    own (tr1a_design.build). A course call's letters name an act; a probe's name LOW, HIGH or BOTH."""
    if x["condition"] == "C":
        return D10.build({"condition": "C", "order": x["order"]}, (), smoke)
    text = text_of(x, rounds(x, records, smoke), smoke)
    letters = dict(zip(PROBE_LETTERS, layout(x["rep"]))) if x["what"] == "probe" else D10.letters_of(x["order"])
    schema = {"type": "object", "additionalProperties": False, "required": ["choice"],
              "properties": {"choice": {"type": "string", "enum": sorted(letters)}}}
    return {"user": text, "schema": schema, "letters": letters,
            "sha256": hashlib.sha256((text + json.dumps(schema, sort_keys=True)).encode()).hexdigest()}


def prepared(x, records=(), smoke=False):
    prompt = build(x, records, smoke)
    seed = int(hashlib.sha256((SEED + x["id"]).encode()).hexdigest()[:8], 16) % (2 ** 31)
    req = cl.body(x["family"], prompt, seed)
    if not R.pin(x["family"])["seed"]:
        del req["seed"]
    return prompt, req


def preparer(records):
    """freeze 1's execute's prepare(call, smoke): built from the records logged so far (the sink's list)."""
    def prepare(x, smoke=False):
        return prepared(x, records, smoke)
    return prepare


classify = D10.classify      # FREEZE-5's parser, as FREEZE-10 reads by it, unchanged


# ------------------------------------------------------------------------------------------------
# The freeze's own check (section 15), before freeze 1's chain check of this folder: the hash file is there, lists
# every file REQUIRED names, and each listed file has its bytes. Then FREEZE-10's frozen check (freeze 1's,
# FREEZE-5's and FREEZE-10's chains) and freeze 1's chain check of this folder (committed once, unchanged).

REL = "experiments/formations-that-read/"
OWN = [REL + "lock-scl/" + f for f in ("scl_design.py", "scl_rule.py", "scl_stage0.py", "scl_run.py",
                                       "scl_dry_run.py", "write_frozen.py", "results/dry-run.json")]
IMPORTED = [REL + f for f in ("tr1.py", "tr1.json", "tr8.py", "tr_rr.py")] + \
           [REL + "told/" + f for f in ("client.py", "conditions.py", "prompts.py", "rule.py", "run.py", "verdicts.py",
                                        "PINS.json")] + \
           [REL + "told-tr1/" + f for f in ("tr1_design.py", "tr1_rule.py", "tr1_run.py")] + \
           [REL + "told-tr1a/" + f for f in ("tr1a_design.py", "tr1a_rule.py", "tr1a_run.py")]
REQUIRED = sorted(OWN + IMPORTED)
FOLDER = HERE.relative_to(R.REPO)
# What an addendum to this freeze may change: freeze 1's client, where freeze 1's own addendum changed it, and this
# freeze's dry run and its result; in freeze 1's PINS.json only a pin's served_as (freeze 1's chain rule).
MAY_CHANGE = frozenset({str(R.TOLD / "client.py"), str(FOLDER / "scl_dry_run.py"),
                        str(FOLDER / "results" / "dry-run.json")})


def own_check(repo=None, folder=None):
    """The hash file is there, lists every REQUIRED file, and each listed file has its bytes. Refuses otherwise."""
    repo = Path(repo or R.REPO)
    hf = repo / (folder or FOLDER) / "FROZEN.sha256"
    if not hf.exists():
        raise SystemExit(f"refused: no {hf.name} in {folder or FOLDER}: SCL is not frozen (FREEZE-12.md, section 15); "
                         "nothing was done")
    listed = {}
    for line in hf.read_text(encoding="utf-8").splitlines():
        if line.strip():
            h, p = line.split(None, 1)
            listed[p] = h
    missing = [p for p in REQUIRED if p not in listed]
    if missing:
        raise SystemExit(f"refused: FROZEN.sha256 does not list {missing[:3]} (FREEZE-12.md, section 15); nothing was "
                         "done")
    bad = [p for p, h in listed.items()
           if not (repo / p).exists() or hashlib.sha256((repo / p).read_bytes()).hexdigest() != h]
    if bad:
        raise SystemExit(f"refused: frozen files differ from FROZEN.sha256: {bad[:3]} (FREEZE-12.md, section 15); "
                         "nothing was done")
    return listed


def frozen(repo=None):
    """SCL's frozen check: its own (own_check), then FREEZE-10's (freeze 1's chain, FREEZE-5's, FREEZE-10's), then
    freeze 1's chain check of this folder with its MAY_CHANGE. Returns the newest link of this folder's chain."""
    repo = repo or R.REPO
    own_check(repo)
    T1A.frozen(repo)
    return R.frozen_check(repo, FOLDER, MAY_CHANGE)
