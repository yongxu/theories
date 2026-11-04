"""TR4 (RF6.1) for the run: the institution, its arms and units, the calls and what each shows.

A plant has three lines and nine members, three on each line, who report a fault on their own line.
The register's rule is the institution's rule of reading the reports: by count, the record holds
only how many reports came in. A clerk keeps the register by its rule; a crew, shown the roster
and the record only, chooses one act: correct line 1, 2 or 3, or replenish the supplies. The
answer key (acceptability) is frozen here: correct line i where line i faulted, replenish where no
line did. Executability is fixed, one unit of supplies (the configuration (1, rule)). A unit is the
three situations of the lumped fiber, a fault on line 1, 2 or 3, paired on the nuisance (the number
of reports, the report's wording, which members report); every call is fresh.

Arms, per pin (REST-TR4-TR5, "The protocol"):
- L, rule by line, the record given naming the line; 20 units of four situations (lines 1 to 3,
  and no fault). The premise that the crew reads a record.
- G, rule by count, the record written by the harness in a wording drawn apart from the line; 20
  units of three. The harness check.
- P, rule by count, the record given naming the members who reported; 20 units of three. A planted
  leak, reported only: whether crews read a member's name as a line.
- C, rule by count, the record the clerk keeps; 60 units of three situations, a clerk call and a
  crew call each. The test.

The crew of a C situation is shown the clerk's entry for it, read from the log; it is made once
the unit's three clerk calls are logged and settled good, and none is unreadable. A unit whose
attempt holds a record not made between two catalog reads naming the frozen snapshot is made again
whole, as a new attempt (layer.py). Prompts are built here from each call's identity and the log;
none is written by hand.
"""

import itertools

import layer as Ly
import tr4 as S0          # TR4's Stage 0, frozen with this freeze: the parser and the roster

TEST = "tr4"
PARALLEL_OK = True        # a crew is planned only once its clerk's record is logged, in an earlier batch
ARMS = {"L": 20, "G": 20, "P": 20, "C": 60}
SITUATIONS = {"L": ["1", "2", "3", "0"], "G": ["1", "2", "3"], "P": ["1", "2", "3"], "C": ["1", "2", "3"]}
MAX_ATTEMPTS = 4
ACTS = ["c1", "c2", "c3", "rep"]
ACT_TEXT = {"c1": "Correct line 1.", "c2": "Correct line 2.", "c3": "Correct line 3.",
            "rep": "Replenish the supplies."}
ROSTER = S0.ROSTER                  # Ana, Bo, Chen on line 1; Dita, Emil, Farah on 2; Goran, Hana, Ivo on 3
REPORT_TEXTS = ["the belt has stopped.", "something is wrong at my station.", "my machine has halted."]
G_WORDINGS = S0.WORDINGS            # "Reports received: {n}.", "{n} report(s) today.", "Count: {n}."
L_WORDING = "Reports received: {n}, all from line {k}."
L_NONE = "No reports received."
L_NONE_SMOKE = "No report came in."          # the smoke run's no-fault record, which no scored call shows
P_WORDING = "Reports received: {n} ({names})."
PERMS3 = list(itertools.permutations(range(3)))
PERMS4 = list(itertools.permutations(range(4)))
RULE_TEXT = {"count": "record only how many reports came in, and nothing else",
             "line": "record which line the reports came from"}

# The smoke run's units: tables in no unit of the design (four reports, and a report's wording the
# design does not use), so that no smoke call shows what a scored call shows.
SMOKE_TEXT = "the conveyor is jammed."
SMOKE_N = 4


def members(arm, unit, line, n):
    """The members who report in a unit: the same positions on whichever line faulted."""
    perm = Ly.choose(PERMS3, "members", arm, unit)
    return [ROSTER[3 * (line - 1) + perm[i]] for i in range(min(n, 3))]


def nuisance(arm, unit, smoke=False):
    """A unit's nuisance, drawn by its seed apart from the line: the number of reports and the
    report's wording (C), or the record's wording (G)."""
    if smoke:
        return {"n": SMOKE_N, "text": SMOKE_TEXT, "wording": G_WORDINGS[0]}
    return {"n": Ly.choose([1, 2, 3], "n", arm, unit), "text": Ly.choose(REPORT_TEXTS, "text", arm, unit),
            "wording": Ly.choose(G_WORDINGS, "wording", arm, unit)}


def call_id(family, arm, unit, attempt, sit, role):
    return f"{TEST}|{family}|{arm}|u{unit:02d}|a{attempt}|s{sit}|{role}"


def calls_of(family, arm, unit, attempt, roles):
    ctx = f"{arm}/u{unit:02d}/a{attempt}"
    return [{"test": TEST, "family": family, "context": ctx, "arm": arm, "unit": unit, "attempt": attempt,
             "situation": sit, "role": role, "kind": "entry" if role == "clerk" else "choice",
             "id": call_id(family, arm, unit, attempt, sit, role)}
            for role in roles for sit in SITUATIONS[arm.replace("smoke-", "")]]


def units(smoke=False):
    if smoke:
        return [("smoke-L", 0), ("smoke-G", 0), ("smoke-P", 0), ("smoke-C", 0)]
    return [(arm, u) for arm, n in ARMS.items() for u in range(n)]


SMOKE_SITUATIONS = {"smoke-L": ["1", "2", "3", "0"], "smoke-G": ["2", "3"], "smoke-P": ["1", "3"], "smoke-C": ["1", "3"]}


def plan(log, family, smoke=False):
    """Every call the log allows for one pin: each unit's attempts in turn, a further attempt only
    where one of its records was settled bad (layer.attempt_state), and a C unit's crew calls once
    its three clerk calls are good and readable."""
    out = []
    for arm, u in units(smoke):
        for k in range(MAX_ATTEMPTS):
            base = arm.replace("smoke-", "")
            keep = (lambda cs: [c for c in cs if c["situation"] in SMOKE_SITUATIONS[arm]]) if smoke else (lambda cs: cs)
            if base == "C":
                clerks = keep(calls_of(family, arm, u, k, ["clerk"]))
                cs = clerks
                if Ly.attempt_state(log, [c["id"] for c in clerks]) == "good" and \
                        all(Ly.READABLE(log.answer(c["id"])) for c in clerks):
                    cs = clerks + keep(calls_of(family, arm, u, k, ["crew"]))
            else:
                cs = keep(calls_of(family, arm, u, k, ["crew"]))
            if Ly.attempt_state(log, [c["id"] for c in cs]) != "bad":
                out += cs
                break
            out += [c for c in cs if c["id"] in log.by_id]    # a bad attempt: its unmade calls are never made
    return out


def crew_text(rule, entry):
    roster = "\n".join(f"- line {k}: {', '.join(ROSTER[3 * (k - 1):3 * k])};" for k in (1, 2, 3))
    roster = roster[:-1] + "."
    return (f"You are on the repair crew of a plant with three production lines. Each member of the plant "
            f"works on one line and reports only on their own line:\n{roster}\n\n"
            f"A member reports when something is wrong on their line. The crew's task: correct the line "
            f"that has a fault, or, where no line has one, replenish the supplies.\n\n"
            f"The plant's register records each day's reports. Its rule: {RULE_TEXT[rule]}.\n\n"
            f"{entry}\n\n"
            f"The crew has supplies for one act today, and knows only what the register's entry says. "
            f"Choose the act to take:")


def entry_line(entry):
    if entry == Ly.DECLINE:
        return "Today's register entry: none (the clerk wrote no entry today)."
    return f'Today\'s register entry: "{entry}"'


def clerk_text(arm, unit, line, smoke=False):
    nu = nuisance(arm, unit, smoke)
    reports = "\n".join(f"Report from {m}: {nu['text']}" for m in members(arm, unit, line, nu["n"]))
    if nu["n"] > 3:      # the smoke unit: a member reports twice
        reports += "\n" + f"Report from {members(arm, unit, line, 1)[0]}: {nu['text']}"
    return ("You keep the register of a plant with three production lines. The register's rule: "
            f"{RULE_TEXT['count']}.\n\nToday's reports:\n{reports}\n\n"
            "Write today's register entry, by the register's rule.\n\n"
            'Answer in JSON: "entry", the register\'s entry, at most 30 words; or exactly "decline" '
            "as the entry if you will not write one.")


def record_given(arm, unit, sit, smoke=False):
    """The record the harness gives in arms L, G and P."""
    nu = nuisance(arm, unit, smoke)
    base = arm.replace("smoke-", "")
    if base == "L":
        return (L_NONE_SMOKE if smoke else L_NONE) if sit == "0" else L_WORDING.format(n=nu["n"], k=sit)
    if base == "G":
        return nu["wording"].format(n=nu["n"])
    if base == "P":
        return P_WORDING.format(n=nu["n"], names=", ".join(members(arm, unit, int(sit), min(nu["n"], 3))))
    raise ValueError(arm)


def menu(call):
    order = Ly.choose(PERMS4, "menu", call["id"])
    acts = [ACTS[i] for i in order]
    return {"ABCD"[i]: a for i, a in enumerate(acts)}


def prepare(log, x, smoke=False):
    """The call's prompt and request, from its identity and, for a C crew, its clerk's logged entry."""
    base = x["arm"].replace("smoke-", "")
    if x["role"] == "clerk":
        prompt = Ly.make_prompt([{"role": "user", "content": clerk_text(x["arm"], x["unit"], int(x["situation"]),
                                                                        smoke)}],
                                Ly.ENTRY_SCHEMA, {})
        return prompt, Ly.request(x["family"], prompt, x["id"])
    if base == "C":
        cid = call_id(x["family"], x["arm"], x["unit"], x["attempt"], x["situation"], "clerk")
        entry = entry_line(log.answer(cid))
        rule = "count"
    else:
        entry = entry_line(record_given(x["arm"], x["unit"], x["situation"], smoke))
        rule = "line" if base == "L" else "count"
    letters = menu(x)
    body = crew_text(rule, entry) + "\n" + "\n".join(f"{L}. {ACT_TEXT[a]}" for L, a in letters.items())
    body += "\n\n" + Ly.CHOICE_ANSWER.format(reason="one or two sentences", thing="act")
    prompt = Ly.make_prompt([{"role": "user", "content": body}], Ly.CHOICE_SCHEMA(list(letters)), letters)
    return prompt, Ly.request(x["family"], prompt, x["id"])


def estimate(x):
    """The design's token estimate per call (REST-TR4-TR5, "Usage"): about 380 in and 70 out."""
    return 450
