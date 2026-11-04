"""TR6's frozen design: the prompts, the calls, and the plan derived from what has been read
(FREEZE-6.md, sections 2 to 5).

Each member is one fresh, stateless call. Ten members, each with its own stated cost (COSTS), decide
whether to take part, in one of two framings: join (a shared work day; the more take part, the more
each gets) and lake (a small lake; the fewer go, the more each gets). A prompt is a function of the
framing, the member's cost, the forecast published (or none), the presentation variant and, in arm
B, the member's own course of earlier rounds (its forecasts, its answers, the counts): of nothing
else, so verdicts' rebuild of every logged prompt from its call is the input diff. Variant v shows
the forecast in wording v // 2 and lists the option of taking part first where v is even.

The plan: the fixed calls (the determinism pilot, the offline table in each framing, its probes, the
no-forecast control and the payoffs-not-told control: fixed_calls(), 1,654 per pin); then, for each
framing whose offline table is whole and has no flagged decision, the loops: arms A and B from 0 in
each of the five variants, from the second start where tr6_rule.second_start gives one, and from the
least right value in variant 0 for RIGHT_ROUNDS rounds. A loop's round is derived from the answers
of the rounds before it; derive() is the whole plan for the answers read so far, and the run makes
what it lacks, round by round, each round's calls derived only from records made between two good
catalog reads.
"""

import hashlib
import json
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parent / "told"))
sys.path.insert(0, str(HERE.parent / "told-tr3"))

import run as R                 # noqa: E402  freeze 1's run: pins, execute, the catalog, the chain
import client as cl             # noqa: E402  freeze 1's client
import tr3_client as TC         # noqa: E402  freeze 3's request and endpoint check
import tr6_rule as TR           # noqa: E402
from conditions import DECLINE  # noqa: E402

TEST = "tr6"
SEED = "RFZ-freeze-6-tr6-2026-11-04"
PILOT_REPS = 30
PILOT = [("join", 0, 0), ("join", 3, 3), ("join", 5, 5), ("join", 6, 6), ("join", 9, 9),
         ("lake", 0, 9), ("lake", 3, 6), ("lake", 5, 5), ("lake", 6, 4), ("lake", 9, 1)]   # framing, member, forecast
PROBE_MEMBERS = (0, 9)
UNTOLD_REPS = 2
SMOKE_REPEATS = 10

STORY = {
    "join": ("Ten neighbours on one street can each choose whether to take part in a shared work day this "
             "Saturday, building raised garden beds on the street's common ground. Each neighbour decides alone, "
             "without talking to the others, and all decide at the same time. The more people take part, the more "
             "is built for those who do: if you take part, you get 10 points for each person who takes part, you "
             "included, and you pay your own cost of taking part, {cost} points. If you stay out, you get 0 points. "
             "Each neighbour has a cost of their own, which the others are not told."),
    "lake": ("Ten neighbours on one street can each choose whether to go to a small lake nearby this Saturday "
             "morning. Each neighbour decides alone, without talking to the others, and all decide at the same "
             "time. The fewer people go, the better the morning is for those there: if you go, you get 110 points "
             "less 10 points for each person who goes, you included, and you pay your own cost of going, {cost} "
             "points. If you stay home, you get 0 points. Each neighbour has a cost of their own, which the others "
             "are not told."),
    "untold": ("Ten neighbours on one street can each choose whether to take part in an activity this Saturday. "
               "Each neighbour decides alone, without talking to the others, and all decide at the same time.")}
WILL = {"join": "take part", "lake": "go", "untold": "take part"}
DID = {"join": "took part", "lake": "went", "untold": "took part"}
OPTIONS = {"join": ("take part", "stay out"), "lake": ("go to the lake", "stay home"),
           "untold": ("take part", "stay out")}
FORECAST = ("A forecast published this morning says that {p} of the 10 neighbours will {will}.",
            "This morning's published forecast: {p} of the 10 neighbours will {will}.",
            "The forecast published this morning is that {p} of the ten neighbours will {will}.")
COURSE_HEAD = "This choice comes every Saturday. On the earlier Saturdays, for you:"
COURSE_TAIL = "Now it is the next Saturday."
OWN = {("join", "T"): "you took part", ("join", "S"): "you stayed out",
       ("join", "D"): "you gave no choice, and so did not take part",
       ("lake", "T"): "you went", ("lake", "S"): "you stayed home",
       ("lake", "D"): "you gave no choice, and so did not go"}
ASK = {"choice": 'Decide now. Answer in JSON, with "choice": "A" or "B".',
       "probe": {"join": ('Do not decide yet. Answer in JSON: "forecast", the number of neighbours the forecast says '
                          'will take part; and "points", the points you would get in all, your cost paid, if you took '
                          'part and {k} of the 10 neighbours took part, you included.'),
                 "lake": ('Do not decide yet. Answer in JSON: "forecast", the number of neighbours the forecast says '
                          'will go; and "points", the points you would get in all, your cost paid, if you went and '
                          '{k} of the 10 neighbours went, you included.')}}
SCHEMA = {"choice": {"type": "object", "additionalProperties": False, "required": ["choice"],
                     "properties": {"choice": {"type": "string", "enum": ["A", "B"]}}},
          "probe": {"type": "object", "additionalProperties": False, "required": ["forecast", "points"],
                    "properties": {"forecast": {"type": "integer"}, "points": {"type": "integer"}}}}
CODE = {TR.TAKE: "T", TR.STAY: "S", DECLINE: "D"}


def letters(variant):
    return {"A": TR.TAKE, "B": TR.STAY} if variant % 2 == 0 else {"A": TR.STAY, "B": TR.TAKE}


def course_lines(framing, member, course):
    """Arm B's course, one line a Saturday: the forecast, the member's own answer, the count, its points."""
    lines = [COURSE_HEAD]
    for k, (f, d, c) in enumerate(course):
        pts = TR.points(framing, TR.COSTS[member], d == "T", c)
        lines.append(f"- Saturday {k + 1}: the forecast said {f} of the 10 would {WILL[framing]}; {OWN[(framing, d)]}; "
                     f"{c} of the 10 {DID[framing]}; you got {pts} points.")
    return "\n".join(lines + [COURSE_TAIL])


def parse_course(s):
    return [(int(f), d, int(c)) for f, d, c in (x.split(".") for x in s.split("/"))] if s else []


def build(kind, framing, member, forecast, variant, course=""):
    """The prompt: its text, schema, letters and hash, from its inputs alone."""
    story = STORY[framing].format(cost=TR.COSTS[member]) if framing != "untold" else STORY[framing]
    parts = [story]
    if course:
        parts.append(course_lines(framing, member, parse_course(course)))
    if forecast is not None:
        parts.append(FORECAST[variant // 2].format(p=forecast, will=WILL[framing]))
    if kind == "probe":
        parts.append(ASK["probe"][framing].format(k=max(forecast, 1)))
        lt = {}
    else:
        take, stay = OPTIONS[framing]
        first, second = (take, stay) if variant % 2 == 0 else (stay, take)
        parts.append(f"A: {first}.\nB: {second}.")
        parts.append(ASK["choice"])
        lt = letters(variant)
    text = "\n\n".join(parts)
    schema = SCHEMA[kind]
    return {"user": text, "schema": schema, "letters": lt,
            "sha256": hashlib.sha256((text + json.dumps(schema, sort_keys=True)).encode()).hexdigest()}


def prepared(x, smoke=False):
    """The call's prompt and request, from its identity alone."""
    prompt = build(x["kind"], x["framing"], x["member"], x["forecast"], x["variant"], x["course"])
    return prompt, TC.request(R.pin(x["family"]), prompt, False, x["id"])


def classify(response, kind, letters):
    """A choice: (TAKE | STAY | DECLINE | FILTERED | INVALID, None), as freeze 1's client reads a choice.
    A probe: (None, {"forecast", "points"}) where both are integers, else (None, None)."""
    if kind == "choice":
        return cl.classify(response, "choice", letters)
    if isinstance(response, dict) and "rejected" in response:
        return None, None
    try:
        parsed = json.loads((response["choices"][0].get("message") or {}).get("content") or "")
    except (TypeError, KeyError, IndexError, AttributeError, json.JSONDecodeError):
        return None, None
    if not isinstance(parsed, dict) or any(not isinstance(parsed.get(f), int) or isinstance(parsed.get(f), bool)
                                           for f in ("forecast", "points")):
        return None, None
    return None, {"forecast": parsed["forecast"], "points": parsed["points"]}


def call(family, arm, context, kind, framing, member, forecast, variant, rep, course="", **more):
    x = {"test": TEST, "family": family, "arm": arm, "context": context, "kind": kind, "framing": framing,
         "member": member, "forecast": forecast, "variant": variant, "course": course, "rep": rep, **more}
    x["id"] = "|".join([TEST, family, context, kind, f"m{member}", f"f{forecast}", f"v{variant}",
                        *[f"{k}={more[k]}" for k in sorted(more)], f"c={course}" if course else "c=-", "%02d" % rep])
    return x


def offline_calls(family, framing):
    return {(i, p): [call(family, "offline", f"offline/{framing}", "choice", framing, i, p, v, 0)
                     for v in range(TR.VARIANTS)] for i in range(TR.N) for p in range(TR.N + 1)}


def probe_calls(family, framing):
    return {(i, p): call(family, "probe", f"probe/{framing}", "probe", framing, i, p, 0, 0)
            for i in PROBE_MEMBERS for p in range(TR.N + 1)}


def fixed_calls(family):
    calls = []
    for i, (f, m, p) in enumerate(PILOT):
        calls += [call(family, "pilot", "pilot", "choice", f, m, p, 0, r, which=i) for r in range(PILOT_REPS)]
    for f in TR.FRAMINGS:
        calls += [x for xs in offline_calls(family, f).values() for x in xs]
        calls += list(probe_calls(family, f).values())
        calls += [call(family, "noforecast", f"noforecast/{f}", "choice", f, i, None, v, 0)
                  for i in range(TR.N) for v in range(TR.VARIANTS)]
    calls += [call(family, "untold", "untold", "choice", "untold", 0, p, v, r)
              for p in range(TR.N + 1) for v in range(TR.VARIANTS) for r in range(UNTOLD_REPS)]
    return calls


def seed(family, framing, arm, start, variant, answer, rounds=TR.ROUNDS, right=False):
    """One loop: its calls so far and its reading. Round k's calls are derived from the rounds before it;
    in arm B each member's prompt carries its own course."""
    kind = ("right-" if right else "") + arm
    ctx = f"{kind}/{framing}/s{start}/v{variant}"
    calls, answers = [], []
    pubs, counts, end = [start], [], "open"
    for k in range(rounds):
        f = pubs[-1]
        xs = []
        for i in range(TR.N):
            course = "/".join(f"{pubs[j]}.{CODE[answers[j][i]]}.{counts[j]}" for j in range(k)) if arm == "B" else ""
            xs.append(call(family, kind, ctx, "choice", framing, i, f, variant, 0, course,
                           start=start, round=k))
        calls += xs
        ans = [answer(x) for x in xs]
        answers.append(ans)
        pubs, counts, end = TR.loop(start, answers)
        if end != "open" or len(counts) < k + 1:
            break
    if end == "open" and len(counts) == rounds:
        end = "done"
    return calls, {"pubs": pubs, "counts": counts, "answers": answers, "end": end, "variant": variant}


def readings(family, answer):
    """Every call of the plan for these answers and, per framing, what the rule reads: (calls, {framing:
    (offline, probes, seeds, second, right_seeds)}), offline None where not whole."""
    calls = fixed_calls(family)
    out = {}
    for f in TR.FRAMINGS:
        oc = offline_calls(family, f)
        got = {k: [answer(x) for x in xs] for k, xs in oc.items()}
        offline = None if any(a is None for v in got.values() for a in v) else got
        probes = {k: answer(x) for k, x in probe_calls(family, f).items()}
        seeds = second = right = None
        if offline is not None and not TR.table(offline)["flagged"]:
            t = TR.table(offline)["count"]
            seeds = {a: [] for a in TR.ARMS}
            for a in TR.ARMS:
                for v in range(TR.VARIANTS):
                    xs, s = seed(family, f, a, 0, v, answer)
                    calls += xs
                    seeds[a].append(s)
            s2 = TR.second_start(t)
            if s2 is not None:
                second = {a: [] for a in TR.ARMS}
                for a in TR.ARMS:
                    for v in range(TR.VARIANTS):
                        xs, s = seed(family, f, a, s2, v, answer)
                        calls += xs
                        second[a].append(s)
            if TR.rights(t):
                right = {a: [] for a in TR.ARMS}
                for a in TR.ARMS:
                    xs, s = seed(family, f, a, min(TR.rights(t)), 0, answer, rounds=TR.RIGHT_ROUNDS, right=True)
                    calls += xs
                    right[a].append(s)
        out[f] = (offline, probes, seeds, second, right)
    return calls, out


def derive(family, answers):
    """Every call of the plan for these read answers ({id: answer}, or a function of the call), the
    fixed calls first, each once."""
    def answer(x):
        return answers(x) if callable(answers) else answers.get(x["id"])
    calls = readings(family, answer)[0]
    seen, out = set(), []
    for x in calls:
        if x["id"] not in seen:
            seen.add(x["id"])
            out.append(x)
    return out


def smoke_calls(family):
    return [call(family, "smoke", "smoke/0", "choice", "join", 3, 3, 0, 0),
            call(family, "smoke", "smoke/1", "choice", "lake", 3, 6, 1, 0),
            call(family, "smoke", "smoke/2", "probe", "join", 0, 3, 0, 0),
            call(family, "smoke", "smoke/3", "choice", "join", 3, None, 0, 0),
            call(family, "smoke", "smoke/4", "choice", "join", 3, 2, 2, 0, "0.T.1/1.S.2"),
            call(family, "smoke", "smoke/5", "choice", "untold", 0, 3, 0, 0)] + \
        [call(family, "smoke", "smoke/repeat", "choice", "join", 3, 3, 0, r) for r in range(SMOKE_REPEATS)]


def reached_most():
    """At most this many calls beyond the fixed ones, per framing the loops from 0, from a second start
    and from the least right value."""
    loops = len(TR.ARMS) * TR.VARIANTS * TR.ROUNDS * TR.N
    return len(TR.FRAMINGS) * (2 * loops + len(TR.ARMS) * TR.RIGHT_ROUNDS * TR.N)
