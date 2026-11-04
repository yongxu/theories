"""TR3's frozen design: the prompts, the calls, and the plan derived from what has been read
(FREEZE-3.md, sections 2 to 5).

Each member is one fresh, stateless call. Its coupling is its draw, a light (green, a, or red, b);
its act a guess of the machine's setting, X (A) or Y (B); the earlier acts are the guesses it is told
were announced before it. A prompt is a function of the prior, the earlier guesses, the draw (or
none, in the no-draw control) and, in the leak control alone, the next member's draw: of nothing
else, so the prompt is the member's input in Turns, and verdicts' rebuild of every logged prompt
from its call is the input diff.

The plan: the fixed calls (the determinism pilot, every cell's guesses, a comprehension probe per
cell and draw, the no-draw control and the sampled arm: fixed_calls(), 1,546 per pin), then what
tr3_rule.walk reaches for each prefix and for the leak control given the answers read so far, the
leak control's first cell among them in the first round.
derive() is the whole plan for those answers; the run makes what it lacks, round by round, each
round's calls derived only from records made between two good catalog reads.
"""

import hashlib
import json
import random
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parent / "told"))

import run as R                 # noqa: E402  freeze 1's run: pins, execute, the catalog, the chain
import tr3_client as TC         # noqa: E402
import tr3_rule as TR           # noqa: E402

TEST = "tr3"
SEED = "RFZ-freeze-2-tr3-2026-11-04"
PILOT_REPS = 30
SAMPLED_REPS = 50
PILOT = [("1:1", "", "a"), ("1:1", "A", "b"), ("1:1", "AA", "b"), ("1:1", "AB", "a"), ("1:1", "BB", "a"),
         ("3:2", "", "b"), ("3:2", "A", "b"), ("3:2", "B", "a"), ("3:2", "BB", "b"), ("3:2", "BBB", "a")]
SAMPLED = [("1:1", ""), ("1:1", "A"), ("1:1", "AA"), ("3:2", ""), ("3:2", "BB"), ("3:2", "BBB")]
SMOKE = [("guess", "1:1", "ABA", "a", "", False), ("guess", "1:1", "ABA", "b", "", False),
         ("probe", "1:1", "ABA", "a", "", False), ("guess", "1:1", "ABA", "", "", False),
         ("guess", "1:1", "ABA", "a", "", True), ("guess", "1:1", "ABA", "a", "b", False)]
SMOKE_REPEATS = 10      # the first smoke request made again, reported: an early look at determinism
LETTERS = {"X": "A", "Y": "B"}
NAME = {"A": "X", "B": "Y"}
LIGHT = {"a": "green", "b": "red"}

PRIOR_TEXT = {
    "1:1": "The setting was chosen by the toss of a fair coin: X and Y were equally likely.",
    "3:2": ("The setting was chosen by drawing one token from a bag of five tokens, three marked X and two "
            "marked Y: X had chance 3 in 5, and Y chance 2 in 5."),
}
GAME = ("This is a guessing game with several players.\n\n"
        "A machine has been set to one of two settings, X or Y. {prior}\n\n"
        "The players take turns, one at a time. On their turn, each player privately sees one light from "
        "the machine, green or red. When the setting is X, a light is green with chance 3 in 5 and red with "
        "chance 2 in 5; when the setting is Y, a light is red with chance 3 in 5 and green with chance 2 in "
        "5. Each player's light is drawn afresh, independently of every other light. Then the player "
        "announces a guess of the setting, X or Y. Every player hears every guess announced before their "
        "turn, but sees no other player's light. Each player is paid only if their own guess is right.")
ASK = {"guess": 'Announce your guess of the setting. Answer in JSON, with "choice": "X" or "Y".',
       "probe": ('Do not guess yet. Answer in JSON: "light", the colour of your light ("green" or "red"); '
                 '"earlier_X", how many of the guesses announced before yours were X; and "earlier_Y", how '
                 'many were Y.')}
SCHEMA = {"guess": {"type": "object", "additionalProperties": False, "required": ["choice"],
                    "properties": {"choice": {"type": "string", "enum": ["X", "Y"]}}},
          "probe": {"type": "object", "additionalProperties": False, "required": ["light", "earlier_X", "earlier_Y"],
                    "properties": {"light": {"type": "string", "enum": ["green", "red"]},
                                   "earlier_X": {"type": "integer"}, "earlier_Y": {"type": "integer"}}}}


def build(kind, prior, history, draw, leak):
    """The prompt: its text, schema, letters and hash, from the prior, the history, the draw and the leak."""
    n = len(history)
    told = ("You are the first to guess: no guess has been announced before yours." if not n else
            "The guesses announced before yours, in order from the first player: "
            + ", ".join(NAME[a] for a in history) + ".")
    light = f"Your light is {LIGHT[draw]}." if draw else \
        "Your light was not shown to you: you know only the guesses announced before yours."
    parts = [GAME.format(prior=PRIOR_TEXT[prior]), f"You are player {n + 1}. {told} {light}"]
    if leak:
        parts.append(f"By an accident of the game, you have also been shown the light of the player after you: "
                     f"it is {LIGHT[leak]}.")
    parts.append(ASK[kind])
    text = "\n\n".join(parts)
    schema = SCHEMA[kind]
    return {"user": text, "schema": schema, "letters": dict(LETTERS),
            "sha256": hashlib.sha256((text + json.dumps(schema, sort_keys=True)).encode()).hexdigest()}


def prepared(x, smoke=False):
    """The call's prompt and request, from its identity alone."""
    prompt = build(x["kind"], x["prior"], x["history"], x["draw"], x["leak"])
    return prompt, TC.request(R.pin(x["family"]), prompt, x["arm"] in ("sampled", "smoke-sampled"), x["id"])


def classify(response, kind, letters):
    return TC.classify(response, kind, letters)


def call(family, arm, context, kind, prior, history, draw, rep, leak="", **more):
    x = {"test": TEST, "family": family, "arm": arm, "context": context, "kind": kind, "prior": prior,
         "history": history, "draw": draw, "leak": leak, "rep": rep, **more}
    x["id"] = "|".join([TEST, family, context, kind, draw or "-", leak or "-",
                        *[f"{k}={more[k]}" for k in sorted(more)], "%02d" % rep])
    return x


def cell(family, prior, history, leak=""):
    arm = "leak-cell" if leak else "cell"
    ctx = f"{arm}/{prior}/{history or '()'}"
    return {d: [call(family, arm, ctx, "guess", prior, history, d, r, leak) for r in range(TR.REPS)]
            for d in TR.DRAWS}


def all_cells():
    return [(p, h) for p in TR.BHW for h in TR.BHW[p]] + [(p, h) for p in TR.EXPLORE for h in TR.EXPLORE[p]]


def fixed_calls(family):
    calls = []
    for i, (p, h, d) in enumerate(PILOT):
        calls += [call(family, "pilot", "pilot", "guess", p, h, d, r, which=i) for r in range(PILOT_REPS)]
    for p, h in all_cells():
        c = cell(family, p, h)
        calls += c["a"] + c["b"]
        calls += [call(family, "probe", f"probe/{p}/{h or '()'}", "probe", p, h, d, 0) for d in TR.DRAWS]
        calls += [call(family, "nodraw", f"nodraw/{p}/{h or '()'}", "guess", p, h, "", r) for r in range(TR.REPS)]
    for p, h in SAMPLED:
        calls += [call(family, "sampled", f"sampled/{p}/{h or '()'}", "guess", p, h, d, r)
                  for d in TR.DRAWS for r in range(SAMPLED_REPS)]
    return calls


def sequence_draws(prior, prefix, m, leak=False):
    """Sequence m's draws for members len(prefix) to the last: all a, all b, then six others, distinct,
    drawn without replacement by a frozen seed, so that no two sequences of a prefix are alike."""
    n = TR.MEMBERS - len(prefix)
    if m == 0:
        return ["a"] * n
    if m == 1:
        return ["b"] * n
    rng = random.Random(f"{SEED}|draws|{prior}|{prefix}|{'leak' if leak else 'main'}")
    v = rng.sample(range(1, 2 ** n - 1), TR.SEQUENCES - 2)[m - 2]
    return [TR.DRAWS[v >> (n - 1 - i) & 1] for i in range(n)]


def walk(family, prior, prefix, answer, leak=False):
    """tr3_rule.walk on this design's calls."""
    base = f"{prior}/{prefix}"
    fresh_ctx = ("leak-fresh/" if leak else "fresh/") + base
    reask_ctx = ("leak-reask/" if leak else "reask/") + base

    def fresh(m, n, history, draw, nxt):
        return call(family, "leak-fresh" if leak else "fresh", fresh_ctx, "guess", prior, history, draw, 0, nxt,
                    prefix=prefix, sequence=m, member=n)

    def reask(m, n, history, draw, nxt, where):
        return [call(family, "leak-reask" if leak else "reask", reask_ctx, "guess", prior, history, draw, r, nxt,
                     prefix=prefix, sequence=m, member=n, where=where) for r in range(TR.REPS)]
    return TR.walk(prior, prefix, answer, lambda p, h, lk: cell(family, p, h, lk), fresh, reask,
                   lambda m: sequence_draws(prior, prefix, m, leak), leak=leak)


def derive(family, answers):
    """Every call of the plan for these read answers ({id: answer}, or a function of the call), the
    fixed calls first, each once."""
    def answer(x):
        return answers(x) if callable(answers) else answers.get(x["id"])
    calls = fixed_calls(family)
    for prior, prefix in TR.PREFIXES:
        calls += walk(family, prior, prefix, answer)[0]
    calls += walk(family, *TR.LEAK_PREFIX, answer, leak=True)[0]
    seen, out = set(), []
    for x in calls:
        if x["id"] not in seen:
            seen.add(x["id"])
            out.append(x)
    return out


def smoke_calls(family):
    return [call(family, "smoke-sampled" if sampled else "smoke", f"smoke/{i}", kind, p, h, d, 0, leak)
            for i, (kind, p, h, d, leak, sampled) in enumerate(SMOKE)] + \
        [call(family, "smoke", "smoke/repeat", *SMOKE[0][:4], r) for r in range(SMOKE_REPEATS)]


def reached_most():
    """At most this many calls beyond the first round (derive with no answers): for each walk, its
    path's cells after the first, which the first round holds; and for each of its fresh sequences, a
    call for each member after the prefix and one re-ask of both blocks."""
    walks = [len(f) for _, f in TR.PREFIXES] + [len(TR.LEAK_PREFIX[1])]
    return sum((TR.MEMBERS - k - 1) * 2 * TR.REPS + TR.SEQUENCES * (TR.MEMBERS - k + 2 * TR.REPS) for k in walks)
