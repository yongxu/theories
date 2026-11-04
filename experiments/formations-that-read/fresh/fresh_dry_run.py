"""The dry run of freeze 2: TR4 and TR5 through the frozen code and freeze 1's harness, every call
answered by a stand-in, no model called and no key used.

    python3 -B fresh_dry_run.py        # writes results/dry-run.json; exit 0 where every check holds

Each stand-in reads what its call shows (the request's messages), and also the call's arm and,
for an episode, its mode, which a system cannot see: Stage 0's harness-difference stand-in acts
otherwise in episodes by design, and a fresh episode's prompt is the audit's at the same history.
The faults a test injects read the call's identity too. Answers come in OpenRouter's shape
(layer.Stub). The run goes through layer.run_batches and run.execute
unchanged, with a stand-in catalog naming the pin's frozen snapshot, and is read back by
layer.load (verdicts.load) and the rule. What is checked:
- **TR5 against Stage 0.** For every deterministic stand-in of tr5.standins(), the score and the
  outcome read from the log equal tr5.stage_b's on the same stand-in, field by field, and so do
  the calls per arm. Stochastic stand-ins are not run here: their rates are the power check's
  (tr5.json), and the code path is the same.
- **TR5's additions.** An answer unreadable at first is asked once more and read; a decline is an
  act with no successor; a fresh call's prompt is a function of its visible history, its menu's
  order and its kind alone (every fresh prompt at the same three is the same prompt).
- **TR4.** Five pairs of a clerk and a crew, run for every pin, read by the rule: each verdict is
  the one its stand-in implies; the p-values equal those computed from the stand-in's answers
  without the harness; on answers with no decline, m3 and m4 equal tr4.m3_p and tr4.m4_p.
- **Refusals.** A folder whose record's answer, prompt hash or served model was changed, that holds
  a record not in the plan, or whose meta is a smoke run's, is refused by layer.load.
- **A catalog move.** Where the catalog names another snapshot mid-run, the run stops; run again,
  the units holding records not made between good reads are made again as new attempts, with new
  ids, and the verdict equals that of a run with no move (TR4 and TR5).
- **The smoke run.** Both tests' smoke calls in one folder, 12 and 10, its report saying go on, and
  no smoke prompt equal to a scored one.
- **The parsers** on hand-made responses, and **the chain** of this freeze's own folder in
  stand-in git repositories.
"""

import hashlib
import json
import random
import shutil
import sys
import tempfile
from collections import defaultdict
from pathlib import Path

import layer as Ly
import fresh_run as FR
import rule4
import rule5
import tr4 as S4
import tr4_live as T4
import tr5 as S5
import tr5_live as T5

R, VD, cl = Ly.R, Ly.VD, Ly.cl
S5.E_EP = T5.E_EP          # Stage 0 compared at the frozen number of episodes
HERE = Ly.HERE
PINS = FR.pins()
DECIDING = [f for f, r in PINS if r == "decides"]
FAMILY = DECIDING[0]
LINK = "dry-run"


class PromptStub(Ly.Stub):
    """layer.Stub whose stand-in is given the request's messages: what it answers is a function of
    what the call shows."""

    def call(self, request, meta):
        return super().call(request, {**meta, "messages": request["messages"]})


def dry_folder(root, name, test, family, kind="dry"):
    folder = Path(root) / name
    folder.mkdir(parents=True)
    (folder / "meta.json").write_text(json.dumps({"kind": kind, "test": test, "family": family, "seed": Ly.SEED}))
    return folder


def drive(folder, test, family, answer, catalog=Ly.STAND_IN_CATALOG, smoke=False):
    Ly.run_batches(folder, test, family, PromptStub(answer), R.SpendGuard(1.0, 10 ** 6), catalog, LINK, smoke=smoke)


def read(folder, test):
    meta, recs, log = Ly.load(folder, test, allow_dry=True)
    return meta, recs, log, FR.VerdictView(log, recs)


# --- TR5 --------------------------------------------------------------------------------------

STEP_LINES = {T5.step_line(k, a, o): (a, o) for k in range(1, 8) for a in T5.ACTS for o in T5.SEEN}
MENU_LINES = {f"{L}. {T5.ACT_MENU[a]}": (L, a) for L in "ABCDE" for a in T5.ACTS}


def shown5(messages):
    """What a TR5 call shows: the visible history, the menu, and whether it asks for a listing."""
    users = [m["content"] for m in messages if m["role"] == "user"]
    h = tuple(STEP_LINES[x] for u in users for x in u.splitlines() if x in STEP_LINES)
    letters = dict(MENU_LINES[x] for x in users[-1].splitlines() if x in MENU_LINES)
    assert f"for step {len(h) + 1}:" in users[-1], "the history shown is not the step asked"
    return h, letters, "list the ends" in users[-1]


def answer5(agent, noise=None):
    """A Stage 0 stand-in as a system answering calls; noise(meta, h) may replace its answer."""
    rng = random.Random(0)

    def ans(meta):
        h, letters, listing = shown5(meta["messages"])
        pres = 0 if letters["A"] == "look" else 1
        if noise:
            got = noise(meta, h)
            if got is not None:
                return got
        if not S5.possible(h):
            return "wait"              # outside the world relation: reported only
        if listing:
            sd, a = agent["lister"](h, rng)
            return a, [{"L": "left", "R": "right"}[s] for s in sorted(sd)]
        if meta["arm"] == "episode":
            if meta["mode"] == "carried" and agent["episode"]:
                return agent["carried"](agent["episode"](rng), h, pres, rng)
            if agent["episode_fresh"] is not None:
                return agent["episode_fresh"](h, pres, rng)
        return agent["fresh"](h, pres, rng)
    return ans


def stage_b_outcome(r):
    met = r["v1_contradicted"] or r["v2_contradicted"] or r["v3_p"] <= 0.05 or r["v4_contradicted_histories"] \
        or r["v5_contradicted_histories"]
    if r["void"]:
        return "void"
    if met:
        return "contradicted"
    return "pass" if r["complete"] and r["listing_complete"] else "unresolved"


COMPARED = ["histories", "resolved", "complete", "void", "v1_p", "v1_departed", "v1_realized", "v1_episodes",
            "v1_first_form", "v2_courses", "v2_contradicted", "v2_courses_with_a_break", "v3_carried_only",
            "v3_fresh_only", "v4_listed", "v4_contradicted_histories", "v5_contradicted_histories",
            "listing_changes_act", "listing_arm_failing_pairs", "listing_complete", "unanimous", "any_failing_modal"]


def tr5_row(root, agent, k):
    folder = dry_folder(root, f"tr5-{k}", "tr5", FAMILY)
    drive(folder, T5, FAMILY, answer5(agent))
    meta, recs, log, view = read(folder, T5)
    s = rule5.score(T5.build(view, FAMILY))
    s["outcome"] = rule5.outcome(s)
    b = S5.stage_b(agent, random.Random(1))
    ours = {k_: s[k_] for k_ in COMPARED}
    ours.update({"failing_pairs_tested": len(s["failing_pairs_tested"]), "menu_order_read": len(s["menu_order_read"]),
                 "v4_relation": {k_: v for k_, v in s["v4_relation"].items() if k_ != "declined, no sides"},
                 "outcome": s["outcome"]})
    theirs = {k_: b[k_] for k_ in COMPARED}
    theirs.update({"failing_pairs_tested": b["failing_pairs_tested"], "menu_order_read": b["menu_order_read"],
                   "v4_relation": b["v4_relation"], "outcome": stage_b_outcome(b)})
    calls = defaultdict(int)
    for r in log.recs:
        calls[r["mode"] if r["arm"] == "episode" else r["arm"]] += 1
    their_calls = dict(b["calls"])
    ours_calls = {"audit": calls["audit"], "fresh": calls["fresh"], "carried": calls["carried"],
                  "listing": calls["listing"]}
    diff = sorted(k_ for k_ in ours if ours[k_] != theirs[k_]) + (["calls"] if ours_calls != their_calls else [])
    return {"standin": agent["name"], "outcome": s["outcome"], "stage_b_outcome": theirs["outcome"],
            "equal": not diff, "differences": {k_: [ours.get(k_, ours_calls), theirs.get(k_, their_calls)]
                                               for k_ in diff},
            "calls": dict(calls), "partial_contexts": len(meta["partial_contexts"]), "unmade": len(meta["unmade"]),
            "folder": folder}


def fresh_prompts_by_history(log):
    """Every fresh prompt's hash by (visible history, menu, listing): one hash for each, where the
    prompt is a function of those alone. Carried steps after the first are conversations."""
    by = defaultdict(set)
    for r in log.recs:
        if r["arm"] == "episode" and r["mode"] == "carried" and r["step"] > 0:
            continue
        h, letters, listing = shown5([{"role": "user", "content": r["prompt"]}])
        by[(h, tuple(sorted(letters.items())), listing)].add(r["prompt_sha256"])
    return {"groups": len(by), "one_prompt_each": all(len(v) == 1 for v in by.values())}


def tr5_additions(root, agents):
    planner = agents[0]
    out = {}
    first = set()

    def invalid_first(meta, h):
        key = (meta["arm"], meta.get("history"), meta.get("order"), meta.get("rep"), meta.get("course"),
               meta.get("mode"), meta.get("episode"), meta.get("step"))
        if not meta["reask"] and key not in first and meta.get("rep", 0) == 0:
            first.add(key)
            return Ly.INVALID
        return None
    f = dry_folder(root, "tr5-reask", "tr5", FAMILY)
    drive(f, T5, FAMILY, answer5(planner, invalid_first))
    _m, _r, log, view = read(f, T5)
    s = rule5.score(T5.build(view, FAMILY))
    reasks = sum(1 for r in log.recs if r["reask"])
    out["an unreadable first answer asked once more, then read: the planner's outcome"] = \
        rule5.outcome(s) == "pass" and reasks > 0 and s["histories"] == 20
    out["reasks made"] = reasks

    def declines_dark(meta, h):
        if meta["arm"] in ("audit", "episode") and h and h[-1] == ("look", "M-"):
            return Ly.DECLINE
        return None
    f = dry_folder(root, "tr5-decline", "tr5", FAMILY)
    drive(f, T5, FAMILY, answer5(planner, declines_dark))
    _m, _r, log, view = read(f, T5)
    s = rule5.score(T5.build(view, FAMILY))
    pairs = s["audit_prediction"]["failing_pairs"]
    eps = [e for e in T5.build(view, FAMILY)["episodes"].values() if e]
    out["a decline at the dark lookout: a failing pair, not enabled, the episodes stuck"] = \
        any(p[0] == "look:M-" and p[1] == "decline" and p[2] == "not enabled" for p in pairs) \
        and not s["audit_prediction"]["goes_on"] and bool(eps) and all(e["stuck"] for e in eps if not e["deviated"])

    def lists_decline(meta, h):
        if meta["arm"] == "listing" and h and h[-1] == ("look", "M-"):
            return Ly.DECLINE, []                   # the strict schema makes it write a list of sides
        return None
    f = dry_folder(root, "tr5-listing-decline", "tr5", FAMILY)
    drive(f, T5, FAMILY, answer5(planner, lists_decline))
    _m, _r, log, view = read(f, T5)
    s = rule5.score(T5.build(view, FAMILY))
    out["a listing's decline states no reading: V4 and V5 not met by it, the planner unresolved, not a pass"] = \
        s["v4_relation"]["declined, no sides"] > 0 and s["v5_contradicted_histories"] == 0 \
        and s["v4_contradicted_histories"] == 0 and rule5.outcome(s) == "unresolved"

    def filters_dark(meta, h):
        if meta["arm"] == "audit" and h == (("look", "M-"),):
            return Ly.FILTERED
        return None
    f = dry_folder(root, "tr5-filtered", "tr5", FAMILY)
    drive(f, T5, FAMILY, answer5(planner, filters_dark))
    _m, recs, log, view = read(f, T5)
    s = rule5.score(T5.build(view, FAMILY))
    counts = rule5.answer_counts(recs)
    out["a history the provider filters: unresolved, its subtree not audited, the filtered counted apart"] = \
        rule5.outcome(s) == "unresolved" and counts["audit"]["filtered"] == 10 and counts["audit"]["invalid"] == 0 \
        and s["histories"] < 20 and not any(r["reask"] for r in log.recs)
    return out


def filtered_run(root):
    """layer.filtered_tail across batches, on a hand-made log."""
    f = Path(root) / "filtered-run"
    f.mkdir()
    rej = {"rejected": {"status": 403, "body": "flagged"}}
    ok = {"choices": [{"message": {"content": "{}"}, "finish_reason": "stop"}]}
    rows = [{"id": f"x{i}", "response": ok, "answer": "look", "probe": None} for i in range(3)]
    rows += [{"id": f"y{i}", "response": rej, "answer": Ly.FILTERED, "probe": None} for i in range(R.FILTERED_RUN)]
    (f / "calls.jsonl").write_text("".join(json.dumps(r) + "\n" for r in rows))
    a = Ly.filtered_tail(f)
    (f / "calls.jsonl").write_text("".join(json.dumps(r) + "\n" for r in rows + rows[:1]))
    b = Ly.filtered_tail(f)
    return {"twenty filtered in a row read across batches": a == R.FILTERED_RUN, "a read answer starts the count again": b == 0,
            "ok": a == R.FILTERED_RUN and b == 0}


def tr5_moved(root, agent, clean, mid=False):
    """A catalog naming another snapshot once, then the frozen one again: at its third read (the
    first batch's closing read), or with mid, at the first read execute makes every 100 calls,
    part way through a batch (it reads before its 100th call, so 99 are logged since the last read)."""
    folder = dry_folder(root, "tr5-moved-mid" if mid else "tr5-moved", "tr5", FAMILY)
    reads = {"n": 0, "last": 0, "at": None}

    def catalog(family):
        reads["n"] += 1
        if mid:
            c = len(R.logged(folder))
            moved = reads["at"] is None and c - reads["last"] == R.CATALOG_EVERY - 1
            reads["last"] = c
            reads["at"] = c if moved else reads["at"]
        else:
            moved = reads["n"] == 3
        return R.pin(family)["canonical_slug"] + ("-moved" if moved else "")
    stopped = False
    try:
        drive(folder, T5, FAMILY, answer5(agent), catalog=catalog)
    except RuntimeError:
        stopped = True
    drive(folder, T5, FAMILY, answer5(agent))
    meta, recs, log, view = read(folder, T5)
    s = rule5.score(T5.build(view, FAMILY))
    made_again = sorted({r["context"] for r in log.recs if r.get("attempt", 0) > 0})
    _m, _r, _l, view0 = read(clean, T5)
    s0 = rule5.score(T5.build(view0, FAMILY))
    same = {k: s[k] for k in COMPARED} == {k: s0[k] for k in COMPARED} and rule5.outcome(s) == rule5.outcome(s0)
    after = made_after_move(folder, meta)
    out = {"stopped at the move": stopped, "units made again": len(made_again),
           "contexts listed unread": len(meta["partial_contexts"]),
           "the verdict equals the run with no move": same, "calls of a bad attempt made after the move": after,
           "ok": stopped and bool(made_again) and same and meta["made_again"] == 0 and after == 0}
    if mid:
        out["calls logged at the move"] = reads["at"]
        out["ok"] = out["ok"] and reads["at"] is not None
    return out


# --- TR4 --------------------------------------------------------------------------------------

def reports_of(text):
    return [line.split("Report from ", 1)[1].split(":", 1)[0] for line in text.splitlines()
            if line.startswith("Report from ")]


def line_of(member):
    return T4.ROSTER.index(member) // 3 + 1


CLERKS = {
    "count": lambda names: f"Reports received: {len(names)}.",
    "names the line": lambda names: f"{len(names)} reports, all from line {line_of(names[0])}.",
    "names the members": lambda names: "Reports from " + ", ".join(sorted(set(names))) + ".",
    "declines at line 2": lambda names: Ly.DECLINE if line_of(names[0]) == 2 else f"Reports received: {len(names)}.",
}


def entry_shown(text):
    for line in text.splitlines():
        if line.startswith("Today's register entry: "):
            rest = line[len("Today's register entry: "):]
            return None if rest.startswith("none") else rest.strip('"')
    raise AssertionError("no entry shown")


def crew_reads(entry, letters):
    if entry is None:
        return "rep"
    named = S4.lines_named(entry)
    return f"c{min(named)}" if len(named) == 1 else "rep"


CREWS = {
    "reads the record": crew_reads,
    "declines where there is no entry": lambda entry, letters: Ly.DECLINE if entry is None else crew_reads(entry, letters),
    "the first act shown": lambda entry, letters: letters["A"],
}

TR4_AGENTS = [("count", "reads the record", "not contradicted"),
              ("names the line", "reads the record", rule4.LABEL_M2),
              ("names the members", "reads the record", rule4.LABEL_M2),
              ("declines at line 2", "declines where there is no entry", rule4.LABEL_OTHER),
              ("count", "the first act shown", "void: arm L's premise fails")]


def answer4(clerk, crew):
    def ans(meta):
        text = meta["messages"][-1]["content"]
        if meta["role"] == "clerk":
            return CLERKS[clerk](reports_of(text))
        return CREWS[crew](entry_shown(text), meta["letters"])
    return ans


def without_harness(clerk, crew, arm):
    """The stand-in's answers computed from the design's units directly, with no call made: the
    acts of each unit and, in C, what its records name."""
    acts, nameds = [], []
    for u in range(T4.ARMS[arm]):
        nu = T4.nuisance(arm, u)
        a_u, n_u = [], []
        for s in T4.SITUATIONS[arm]:
            if arm == "C":
                names = T4.members(arm, u, int(s), nu["n"])
                e = CLERKS[clerk](names)
                n_u.append(rule4.named_of(e))
                entry = None if e == Ly.DECLINE else e
            else:
                entry = T4.record_given(arm, u, s)
            a = CREWS[crew](entry, {"A": "?"})
            a_u.append(rule4.act_of(a))
        acts.append(a_u)
        nameds.append(tuple(n_u))
    return acts, nameds


def tr4_rows(root):
    rows = []
    for clerk, crew, expected in TR4_AGENTS:
        base = Path(root) / f"tr4-{clerk}-{crew}".replace(" ", "_")
        for fam, _role in PINS:
            f = dry_folder(base, fam.replace("/", "__"), "tr4", fam)
            drive(f, T4, fam, answer4(clerk, crew))
        v = FR.verdicts("tr4", root=base, allow_dry=True)
        row = {"clerk": clerk, "crew": crew, "expected": expected,
               "harness_check": v["harness_check"]["status"] if "harness_check" in v else None,
               "verdicts": {f: p.get("verdict") for f, p in v["pins"].items()}}
        row["as_expected"] = all(x.startswith(expected) for x in row["verdicts"].values())
        meta, recs, _log = Ly.load(base / FAMILY.replace("/", "__"), T4, allow_dry=True)
        s = rule4.summary(meta, recs, meta["unmade"])
        ua = rule4.unit_answers(recs)
        logged_acts = [[rule4.act_of(ua[("C", u)]["calls"][(x, "crew")]["answer"]) for x in T4.SITUATIONS["C"]]
                       for u in range(60)]
        logged_named = [tuple(rule4.named_of(ua[("C", u)]["calls"][(x, "clerk")]["answer"])
                              for x in T4.SITUATIONS["C"]) for u in range(60)]
        if crew != "the first act shown":
            acts, nameds = without_harness(clerk, crew, "C")
            row["the log's answers are the stand-in's, computed without the harness"] = \
                acts == logged_acts and nameds == logged_named
            row["p-values equal those computed without the harness"] = \
                (rule4.m1(nameds), rule4.m2(acts), rule4.m3(acts)[0], rule4.m4(nameds)[0]) == \
                tuple(s["arms"]["C"][m] for m in ("m1", "m2", "m3", "m4"))
        if not any("decline" in u for u in logged_acts) and not any(rule4.D in r for u in logged_named for r in u):
            row["m3 and m4 equal tr4.m3_p and tr4.m4_p"] = \
                rule4.m3(logged_acts) == (S4.m3_p(logged_acts)[0], list(S4.m3_p(logged_acts)[1])) and \
                rule4.m4(logged_named) == (S4.m4_p(logged_named)[0], list(S4.m4_p(logged_named)[1]))
        row["L premise"] = [s["arms"]["L"]["line_calls_correct"], s["arms"]["L"]["line_calls"]]
        row["C p-values"] = {m: s["arms"]["C"][m] for m in ("m1", "m2", "m3", "m4")}
        row["ok"] = row["as_expected"] and all(v_ for k_, v_ in row.items() if k_.startswith(("the log", "p-values",
                                                                                             "m3 and")))
        rows.append(row)
    return rows


def refusals(root, clean):
    """layer.load on copies of a clean TR4 folder, each with one fault."""
    out = {}

    def fault(name, change):
        f = Path(root) / "refuse" / name
        shutil.copytree(clean, f)
        change(f)
        try:
            Ly.load(f, T4, allow_dry=True)
            return False
        except SystemExit:
            return True

    def edit_rec(f, fn):
        p = f / "calls.jsonl"
        lines = p.read_text().splitlines()
        r = json.loads(lines[5])
        fn(r, lines)
        lines[5] = json.dumps(r)
        p.write_text("\n".join(lines) + "\n")

    def answer(r, _l):
        r["answer"] = "c1" if r["answer"] != "c1" else "c2"

    def sha(r, _l):
        r["prompt_sha256"] = "0" * 64

    def served(r, _l):
        r["response"]["model"] = "other/model"

    def extra(r, lines):
        lines.append(json.dumps({**r, "id": r["id"] + "|extra"}))

    def smoke(f):
        m = json.loads((f / "meta.json").read_text())
        (f / "meta.json").write_text(json.dumps({**m, "kind": "smoke"}))
    out["a changed answer, refused"] = fault("answer", lambda f: edit_rec(f, answer))
    out["a changed prompt hash, refused"] = fault("sha", lambda f: edit_rec(f, sha))
    out["a record another model answered, refused"] = fault("served", lambda f: edit_rec(f, served))
    out["a record not in the plan, refused"] = fault("extra", lambda f: edit_rec(f, extra))
    out["a smoke run's folder, refused"] = fault("smoke", smoke)
    out["ok"] = all(out.values())
    return out


def tr4_faults(root):
    """The minimums and the families with answers the provider filters or that cannot be read: on
    Gemini, 7 C units voided by its clerks (53 valid: void for C); on Qwen, 3 G units voided by
    its crews (17 valid: G unmeasured, void for C); on Sonnet, 6 C units voided (54 valid: read)."""
    def ans(fam):
        base = answer4("count", "reads the record")

        def a(meta):
            if fam == "google/gemini-4-argon" and meta["arm"] == "C" and meta["role"] == "clerk" \
                    and meta["situation"] == "1" and meta["unit"] < 7:
                return Ly.INVALID if meta["unit"] < 4 else Ly.FILTERED
            if fam == "qwen/qwen3.8-max-0902" and meta["arm"] == "G" and meta["unit"] < 3 and meta["situation"] == "2":
                return Ly.INVALID
            if fam == "anthropic/claude-sonnet-5.5" and meta["arm"] == "C" and meta["role"] == "clerk" \
                    and meta["situation"] == "3" and meta["unit"] < 6:
                return Ly.FILTERED
            return base(meta)
        return a
    base = Path(root) / "tr4-faults"
    crews_after_unreadable = 0
    for fam, _role in PINS:
        f = dry_folder(base, fam.replace("/", "__"), "tr4", fam)
        drive(f, T4, fam, ans(fam))
        recs = R.logged(f)
        bad_units = {(r["unit"], r["attempt"]) for r in recs if r["arm"] == "C" and r["role"] == "clerk"
                     and not Ly.READABLE(r["answer"])}
        crews_after_unreadable += sum(1 for r in recs if r["arm"] == "C" and r["role"] == "crew"
                                      and (r["unit"], r["attempt"]) in bad_units)
    v = FR.verdicts("tr4", root=base, allow_dry=True)
    g, q, c = (v["pins"].get(f, {}).get("verdict", "") for f, _r in PINS)
    m, recs, _l = Ly.load(base / "google__gemini-4-argon", T4, allow_dry=True)
    s = rule4.summary(m, recs, m["unmade"])
    out = {"verdicts": v["pins"], "harness_check": v["harness_check"]["status"],
           "no crew called after a filtered or unreadable clerk entry": crews_after_unreadable == 0,
           "53 valid C units: void for C": g.startswith("void: fewer than 54"),
           "17 valid G units: unmeasured, read at p-values of 1": q.startswith("void: its harness check is unmeasured")
           and v["harness_check"].get("read_at_1") == ["qwen/qwen3.8-max-0902"],
           "54 valid C units: read": c.startswith("not contradicted"),
           "filtered and unreadable counted apart": s["arms"]["C"]["answers_filtered"] == 3
           and s["arms"]["C"]["answers_invalid"] == 4}
    out["ok"] = all(x for k, x in out.items() if k not in ("verdicts", "harness_check"))
    return out


def tr4_families(root):
    """Holm's fixed families: a deciding pin's run missing makes the reading pending, and --final
    reads the other at p-values of 1; a harness leak in G withholds every verdict, the pin reported
    apart's included."""
    out = {}
    src = Path(root) / "tr4-names_the_line-reads_the_record"
    part = Path(root) / "tr4-one-deciding"
    shutil.copytree(src, part, ignore=lambda d, names: [n for n in names if n == "qwen__qwen3.8-max-0902"])
    v = FR.verdicts("tr4", root=part, allow_dry=True)
    out["a deciding pin's run missing: pending"] = v["verdict"].startswith("pending")
    vf = FR.verdicts("tr4", root=part, allow_dry=True, final=True)
    out["with --final: the other read, at the full families"] = \
        vf["pins"]["google/gemini-4-argon"]["verdict"].startswith(rule4.LABEL_M2) \
        and vf["pins"]["google/gemini-4-argon"]["holm_family"] == 8 \
        and vf["pins"]["qwen/qwen3.8-max-0902"]["verdict"].startswith("no verdict: the run is not complete")
    leak = answer4("count", "reads the record")

    def g_leak(meta):
        if meta["arm"] == "G":                      # a harness leaking the line by a channel the crew reads
            return f"c{meta['situation']}"
        return leak(meta)
    base = Path(root) / "tr4-harness-leak"
    for fam, _r in PINS:
        drive(dry_folder(base, fam.replace("/", "__"), "tr4", fam), T4, fam, g_leak)
    v = FR.verdicts("tr4", root=base, allow_dry=True)
    out["a harness leak: every C verdict withheld, the pin reported apart's included"] = \
        v["harness_check"]["status"] == "rejected" and \
        v["pins"]["anthropic/claude-sonnet-5.5"]["verdict"] == "no verdict: the shared harness check has not passed"
    out["ok"] = all(out.values())
    return out


def made_after_move(folder, meta):
    """Records of a context listed unread made after the read that named another snapshot: none
    where a bad attempt's unmade calls are never made."""
    moved = [t for t, s in R.catalog_reads(folder) if s.endswith("-moved")]
    recs = [r for r in R.logged(folder) if r["context"] in meta["partial_contexts"]]
    return sum(1 for r in recs if r["t0"] > moved[0])


def tr4_moved(root, clean):
    folder = dry_folder(root, "tr4-moved", "tr4", FAMILY)
    reads = {"n": 0}

    def catalog(family):
        reads["n"] += 1
        return R.pin(family)["canonical_slug"] + ("-moved" if reads["n"] == 3 else "")
    ans = answer4("names the line", "reads the record")
    stopped = False
    try:
        drive(folder, T4, FAMILY, ans, catalog=catalog)
    except RuntimeError:
        stopped = True
    drive(folder, T4, FAMILY, ans)
    meta, recs, _log = Ly.load(folder, T4, allow_dry=True)
    s = rule4.summary(meta, recs, meta["unmade"])
    m0, r0, _l0 = Ly.load(clean, T4, allow_dry=True)
    s0 = rule4.summary(m0, r0, m0["unmade"])
    again = sorted({r["context"] for r in recs if r["attempt"] > 0})
    same = all(s["arms"][a] == s0["arms"][a] for a in T4.ARMS)
    after = made_after_move(folder, meta)
    return {"stopped at the move": stopped, "units made again": len(again),
            "contexts listed unread": len(meta["partial_contexts"]), "the summary equals the run with no move": same,
            "calls of a bad attempt made after the move": after,
            "ok": stopped and bool(again) and same and meta["made_again"] == 0 and after == 0}


# --- the smoke run, the parsers, the chain ---------------------------------------------------

def smoke_check(root, scored_folders):
    folder = dry_folder(root, "smoke", "smoke", FAMILY, kind="smoke")
    drive(folder, T4, FAMILY, answer4("count", "reads the record"), smoke=True)
    drive(folder, T5, FAMILY, answer5(S5.standins()[0]), smoke=True)
    code = FR.smoke_report(folder)
    rep = json.loads((folder / "smoke-report.json").read_text())
    log = Ly.Log(folder, FAMILY)
    n = defaultdict(int)
    for r in log.recs:
        n[r["test"]] += 1
    smoke_sha = {r["prompt_sha256"] for r in log.recs}
    scored_sha = {r["prompt_sha256"] for f in scored_folders for r in R.logged(f)}
    for act in ("back", Ly.DECLINE):           # a first act with no successor ends the conversation
        f = dry_folder(root, f"smoke-{act}", "smoke", FAMILY, kind="smoke")
        drive(f, T5, FAMILY, answer5(S5.standins()[0], lambda meta, h, a=act:
                                     a if meta["arm"] == "smoke-episode" else None), smoke=True)
        n[f"tr5, first step {act}"] = len(Ly.Log(f, FAMILY).recs)
    ended = n["tr5, first step back"] == 9 and n[f"tr5, first step {Ly.DECLINE}"] == 9
    return {"go on": code == 0 and rep["go_on"], "calls": dict(n), "no smoke prompt is a scored one":
            not (smoke_sha & scored_sha), "a first step back or declined ends the smoke conversation": ended,
            "ok": code == 0 and n["tr4"] == 12 and n["tr5"] == 10 and ended and not (smoke_sha & scored_sha)}


def resp(content, finish="stop", refusal=None):
    msg = {"content": content}
    if refusal is not None:
        msg["refusal"] = refusal
    return {"model": "m", "choices": [{"message": msg, "finish_reason": finish}]}


def parser_table():
    L = {"A": "look", "B": "wait"}
    e = lambda x: json.dumps({"entry": x})                                    # noqa: E731
    li = lambda c, s: json.dumps({"reason": "r", "sides": s, "choice": c})    # noqa: E731
    rows = [
        ("an entry", resp(e("3 reports.")), "entry", ("3 reports.", None)),
        ("an entry that is exactly decline", resp(e(" Decline ")), "entry", (Ly.DECLINE, None)),
        ("an entry naming decline among words", resp(e("I decline to say")), "entry", ("I decline to say", None)),
        ("an entry complete under a filter's stop", resp(e("2."), "content_filter"), "entry", ("2.", None)),
        ("an entry cut by a filter", resp('{"entry": "2', "content_filter"), "entry", (Ly.FILTERED, None)),
        ("an entry refused, no content", resp(None, refusal="no"), "entry", (Ly.DECLINE, None)),
        ("a moderation rejection of an entry", {"rejected": {"status": 403, "body": ""}}, "entry", (Ly.FILTERED, None)),
        ("an entry that is a number", resp(json.dumps({"entry": 3})), "entry", (Ly.INVALID, None)),
        ("malformed JSON for an entry", resp("3 reports"), "entry", (Ly.INVALID, None)),
        ("a listing", resp(li("A", ["right", "left", "left"])), "listing", ("look", {"sides": ["left", "right"]})),
        ("a listing of no side", resp(li("B", [])), "listing", ("wait", {"sides": []})),
        ("a listing's decline, no sides", resp(json.dumps({"reason": "r", "choice": "decline"})), "listing",
         (Ly.DECLINE, None)),
        ("a listing's decline with sides", resp(li("decline", ["left"])), "listing", (Ly.DECLINE, None)),
        ("a listing's decline with an empty list", resp(li("decline", [])), "listing", (Ly.DECLINE, None)),
        ("an entry that is the word invalid (read as unreadable: a known limit)", resp(e("invalid")), "entry",
         (Ly.INVALID, None)),
        ("a listing with a side not offered", resp(li("A", ["middle"])), "listing", (Ly.INVALID, None)),
        ("a listing with a letter not offered", resp(li("C", ["left"])), "listing", (Ly.INVALID, None)),
        ("a listing with no sides", resp(json.dumps({"reason": "r", "choice": "A"})), "listing", (Ly.INVALID, None)),
        ("a listing cut by a filter", resp('{"reason": "r", "si', "content_filter"), "listing", (Ly.FILTERED, None)),
        ("a choice, by freeze 1's parser", resp(json.dumps({"reason": "r", "choice": "B"})), "choice", ("wait", None)),
        ("a choice's decline", resp(json.dumps({"reason": "r", "choice": "decline"})), "choice", (Ly.DECLINE, None)),
    ]
    return [{"case": n, "expected": list(x), "got": list(Ly.classify(r, k, L)), "ok": Ly.classify(r, k, L) == x}
            for n, r, k, x in rows]


def chain_checks(tmp):
    """run.frozen_check on this freeze's folder in stand-in repositories: told/'s files it lists and
    its own, the base link read; refused where a listed told/ file or one of its own fixed files
    changed; an addendum changing its dry run read, one changing its rule refused."""
    fresh, told = Ly.FRESH, R.TOLD

    def sha(p):
        return hashlib.sha256(p.read_bytes()).hexdigest()

    def commit(r):
        R.git(r, "add", "-A")
        R.git(r, "-c", "commit.gpgsign=false", "-c", "core.hooksPath=/dev/null", "commit", "-qm", "step")

    def link(r, name, files):
        (r / fresh / name).parent.mkdir(parents=True, exist_ok=True)
        (r / fresh / name).write_text("".join(f"{sha(r / f)}  {f}\n" for f in files))

    FILES = [str(told / "run.py"), str(told / "client.py"), str(fresh / "rule5.py"), str(fresh / "fresh_dry_run.py")]

    def repo(name):
        r = Path(tmp) / "chain" / name
        for f in FILES:
            (r / f).parent.mkdir(parents=True, exist_ok=True)
            (r / f).write_text(f"{Path(f).name} one\n")
        R.git(r, "init", "-q")
        R.git(r, "config", "user.email", "dry-run@localhost")
        R.git(r, "config", "user.name", "dry run")
        link(r, R.BASE_LINK, FILES)
        commit(r)
        return r

    def read(r):
        try:
            return R.frozen_check(r, fresh, Ly.MAY_CHANGE)
        except SystemExit:
            return None

    def addendum(r, changed):
        (r / changed).write_text("two\n")
        (r / fresh / "addenda").mkdir(exist_ok=True)
        (r / fresh / "addenda" / "ADDENDUM-1.md").write_text("addendum 1\n")
        link(r, "addenda/FROZEN-1.sha256", FILES + [str(fresh / "addenda" / "ADDENDUM-1.md")])
        commit(r)
    out = {}
    fc = read(repo("base"))
    out["the base link read, told/'s files listed"] = bool(fc) and fc["link"] == R.BASE_LINK \
        and set(fc["hashes"]) == set(FILES)
    r = repo("told-changed")
    (r / told / "run.py").write_text("two\n")
    commit(r)
    out["a told/ file it lists changed, refused"] = read(r) is None
    r = repo("own-changed")
    (r / fresh / "rule5.py").write_text("two\n")
    commit(r)
    out["its own rule changed with no addendum, refused"] = read(r) is None
    r = repo("dry-run")
    addendum(r, fresh / "fresh_dry_run.py")
    out["an addendum changing its dry run, read"] = (read(r) or {}).get("link") == "addenda/FROZEN-1.sha256"
    r = repo("rule")
    addendum(r, fresh / "rule5.py")
    out["an addendum changing its rule, refused"] = read(r) is None
    r = repo("client")
    addendum(r, told / "client.py")
    out["an addendum changing freeze 1's client, read (as freeze 1's own addenda may)"] = read(r) is not None
    out["ok"] = all(out.values())
    return out


def main():
    out = {"what": "The dry run of freeze 2: TR4 and TR5 through the frozen code and freeze 1's harness; no model "
                   "called, no key used", "seed": Ly.SEED}
    with tempfile.TemporaryDirectory() as tmp:
        agents = [a for a in S5.standins() if not a["stochastic"]]
        out["tr5_against_stage0"] = []
        for k, a in enumerate(agents):
            row = tr5_row(tmp, a, k)
            print("tr5", row["equal"], row["outcome"], row["stage_b_outcome"], row["differences"], a["name"][:50],
                  flush=True)
            out["tr5_against_stage0"].append(row)
        clean5 = out["tr5_against_stage0"][0]["folder"]
        _m, _r, log0, _v = read(clean5, T5)
        out["tr5_fresh_prompts"] = fresh_prompts_by_history(log0)
        out["tr5_additions"] = tr5_additions(tmp, agents)
        out["tr5_moved"] = tr5_moved(tmp, agents[0], clean5)
        k6 = next(k for k, a in enumerate(agents) if a["name"].startswith("fixed by the step count"))
        out["tr5_moved_mid_batch"] = tr5_moved(tmp, agents[k6], out["tr5_against_stage0"][k6]["folder"], mid=True)
        print("tr5 moved mid-batch", out["tr5_moved_mid_batch"], flush=True)
        print("tr5 prompts", out["tr5_fresh_prompts"], "| additions", out["tr5_additions"], "| moved",
              out["tr5_moved"], flush=True)
        out["tr4"] = tr4_rows(tmp)
        for row in out["tr4"]:
            print("tr4", row["ok"], row["clerk"], "|", row["crew"], "|", row["harness_check"], row["verdicts"],
                  flush=True)
        clean4 = Path(tmp) / "tr4-names_the_line-reads_the_record" / FAMILY.replace("/", "__")
        out["refusals"] = refusals(tmp, clean4)
        out["tr4_moved"] = tr4_moved(tmp, clean4)
        out["tr4_faults"] = tr4_faults(tmp)
        out["tr4_families"] = tr4_families(tmp)
        out["filtered_run"] = filtered_run(tmp)
        print("tr4 faults", out["tr4_faults"], "| families", out["tr4_families"], "| filtered run",
              out["filtered_run"], flush=True)
        out["smoke"] = smoke_check(tmp, [clean5, clean4])
        out["parsers"] = parser_table()
        out["chain"] = chain_checks(tmp)
        for row in out["tr5_against_stage0"]:
            row["folder"] = str(Path(row["folder"]).name)
    print("refusals", out["refusals"], "| tr4 moved", out["tr4_moved"], "| smoke", out["smoke"], "| parsers",
          all(p["ok"] for p in out["parsers"]), "| chain", out["chain"], flush=True)
    out["ok"] = all(r["equal"] for r in out["tr5_against_stage0"]) and out["tr5_fresh_prompts"]["one_prompt_each"] \
        and all(v for k, v in out["tr5_additions"].items() if not k.startswith("reasks")) \
        and out["tr5_moved"]["ok"] and out["tr5_moved_mid_batch"]["ok"] and all(r["ok"] for r in out["tr4"]) and out["refusals"]["ok"] \
        and out["tr4_moved"]["ok"] and out["tr4_faults"]["ok"] and out["tr4_families"]["ok"] \
        and out["filtered_run"]["ok"] and out["smoke"]["ok"] and all(p["ok"] for p in out["parsers"]) \
        and out["chain"]["ok"]
    (HERE / "results").mkdir(exist_ok=True)
    (HERE / "results" / "dry-run.json").write_text(json.dumps(out, indent=1, default=str) + "\n", encoding="utf-8")
    print("every check holds:", out["ok"])
    return 0 if out["ok"] else 1


if __name__ == "__main__":
    sys.exit(main())
