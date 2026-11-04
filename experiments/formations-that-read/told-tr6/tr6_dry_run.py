"""The dry run of TR6: simulated publics through the frozen code, no model called.

    python3 -B tr6_dry_run.py        # writes results/dry-run.json; a few minutes on one core

1. The code path. For each of nine publics, tr6_run.rounds makes the whole plan through freeze 1's
   run.execute, freeze 3's endpoint wrapper and a stub client (prompts built, responses in
   OpenRouter's shape, some choices unreadable, filtered or declined and some probes unreadable), the
   log is written to a temporary folder and tr6_run.load (freeze 1's verdicts.load, given this
   freeze's plan, prepare and parser) reads it back. Its verdicts must equal those of the same rule
   on the same answers without the harness, where the plan is derived in one pass from answers drawn
   as each call is reached. Refused: a planted leak in the harness (the table's count at the forecast
   shown in an arm A prompt, which the rebuild of every logged prompt, the input diff, finds), a
   record's course edited, a logged answer the parser reads otherwise, a record another model
   answered, a call not in the plan, a record another provider or another tier served, the offline
   table's records dropped while the loops derived from them stay, and a smoke folder; a response
   another provider or another tier served stops the run, logging nothing. A round's closing read
   lost, then made by a rerun, must be read with the plan its answers give; a pin that moved and came
   back likewise, the calls made again answering otherwise. The smoke run's stop rule is run through
   the stub; a table of response shapes checks classify(); the chain of this freeze, with freeze 3's
   chain (and freeze 1's) checked first, is checked in stand-in git repositories. The sha-256 of every
   file the freeze fixes is recorded at the start and the end, and must not change between.
2. The shares. V2 and the readings on Stage 0's protocol, through the frozen rule (the plan derived
   in one pass, each call answered as it is reached), 300 replications a row, beside Stage 0's rows
   (tr6.json, D_power): the frozen join public is Stage 0's full climb; the frozen lake public is a
   spread congestion public of its own (its capacities 1, 2, 4, 4, 5, 7, 7, 8, 9, 10), beside Stage
   0's spread one (1 to 10). And what the freeze's readings move: the second start, for a public
   reading the forecast as the count, whose orbit from 0 rests at once; a public moved by the
   presentation, voided by the flag rule; declines read as not taking part; an unreadable answer
   ending its seed; probes that do not restate, which leave the reading unread.

The simulated members are Stage 0's own (tr6.py's thresholds, memory rules and flips): each call
independent, a member's decision a function of the forecast and, in arm B, of its course as the
prompt shows it (its own answers and the counts), with chance eta flipped.
"""

import hashlib
import json
import random
import sys
import tempfile
from collections import Counter
from pathlib import Path

import tr6_design as D          # puts freeze 1's told/ and freeze 3's told-tr3/ on the path
import tr6_rule as TR
import tr6_run as T
import tr3_client as TC
import tr3_run as T3            # noqa: E402
import run as R                 # noqa: E402
from conditions import DECLINE  # noqa: E402
from rule import FILTERED, INVALID  # noqa: E402

sys.path.insert(0, str(D.HERE.parent))
import tr6 as S0                # noqa: E402  Stage 0

HERE = D.HERE
SEED = "RFZ-freeze-6-tr6-dry-run"
FAMILY = R.PINS["pins"][0]["id"]      # any frozen pin: the stub reads none of it
CATALOG = lambda family: R.pin(family)["canonical_slug"]    # the dry run's stand-in for the public catalog
NOISE = {"invalid": 0.0005, "filtered": 0.0005, "decline": 0.002, "probe": 0.0}
REPS = 300
# each member's threshold (join: takes part where the forecast is at least it) and capacity (lake:
# goes where the forecast is below it), by the reading of the forecast as the others who take part
THRESHOLD = [next(p for p in range(TR.N + 2) if p > TR.N or TR.points("join", c, True, p + 1) > 0) for c in TR.COSTS]
CAPACITY = [next(p for p in range(TR.N + 2) if p > TR.N or TR.points("lake", c, True, p + 1) <= 0) for c in TR.COSTS]
# the same by the reading of the forecast as the count
THRESHOLD_COUNT = [next(p for p in range(TR.N + 2) if p > TR.N or TR.points("join", c, True, p) > 0) for c in TR.COSTS]


def base_of(kind, framing):
    """A public's decision of member and forecast in a framing: a reader takes part where its points
    at the forecast plus itself are positive (join: from its threshold; lake: below its capacity)."""
    if kind == "reads":
        return (lambda i, p: int(p >= THRESHOLD[i])) if framing == "join" else (lambda i, p: int(p < CAPACITY[i]))
    if kind == "reads the forecast as the count":
        return (lambda i, p: int(p >= THRESHOLD_COUNT[i])) if framing == "join" else \
            (lambda i, p: int(TR.points("lake", TR.COSTS[i], True, p) > 0))
    if kind == "deaf":
        return lambda i, p: int(i < 4)
    if kind == "identity":
        return lambda i, p: int(i < p)
    if kind == "hybrid":
        b = base_of("reads", framing)
        return lambda i, p: b(i, p) if i % 2 == 0 else int(i < 5)
    raise ValueError(kind)


MEMORY = {"inertia": lambda framing: S0.inertia, "trend reader": lambda framing: S0.trend_reader,
          "momentum": lambda framing: S0.momentum_band(THRESHOLD),
          "regret after a crowded round": lambda framing: S0.regret_cong(CAPACITY),
          "momentum, as the count": lambda framing: S0.momentum_band(THRESHOLD_COUNT),
          "agents exchange rules": lambda framing: None}


class Public:
    """A simulated public: in each framing a base decision of member and forecast (base_of); an
    optional memory rule (Stage 0's, by name, reading the course the prompt shows) with strength w;
    flips with chance eta; unreadable, filtered and declined answers with NOISE's chances; and,
    optionally, a presentation lean (the option listed first chosen wherever the member's points at the
    forecast plus itself are within `lean`), declines at forecasts from `declines_from` on, probes
    that miscompute, and a filter at one arm B round."""

    def __init__(self, name, kind, eta=0.001, memory=None, w=0.0, noise=None, lean=None, declines_from=None,
                 bad_probes=False, filter_at=None, untold=None):
        self.name, self.kind, self.eta, self.memory, self.w = name, kind, eta, memory, w
        self.base = {f: base_of(kind, f) for f in TR.FRAMINGS}
        pick = {"momentum": {"join": "momentum", "lake": "regret after a crowded round"}}.get(memory)
        self.mem = {f: (S0.rule_exchange(self.base[f]) if memory == "agents exchange rules"
                        else MEMORY[pick[f] if pick else memory](f)) for f in TR.FRAMINGS} if memory else {}
        self.noise, self.lean, self.declines_from, self.bad_probes = noise or {}, lean, declines_from, bad_probes
        self.filter_at, self.untold = filter_at, untold or (lambda p: int(p >= 5))

    def answer(self, x, rep, again=0):
        rng = random.Random(f"{SEED}|{rep}|{self.name}|{again}|{x['id']}")
        if x["kind"] == "probe":
            if self.bad_probes and x["forecast"] == 3:
                return {"forecast": x["forecast"], "points": 0}
            if rng.random() < self.noise.get("probe", 0):
                return None
            return {"forecast": x["forecast"], "points": TR.points(x["framing"], TR.COSTS[x["member"]], True,
                                                                   max(x["forecast"], 1))}
        u = rng.random()
        lo = 0.0
        for k, a in (("invalid", INVALID), ("filtered", FILTERED), ("decline", DECLINE)):
            lo += self.noise.get(k, 0)
            if u < lo:
                return a
        if self.filter_at and x["arm"] == "B" and (x["round"], x["member"]) == self.filter_at and x["variant"] == 0:
            return FILTERED
        i, p, f = x["member"], x["forecast"], x["framing"]
        if f == "untold":
            d = self.untold(p)
        else:
            p0 = 0 if p is None else p
            if self.declines_from is not None and p0 >= self.declines_from:
                return DECLINE
            d = self.base[f](i, p0)
            if self.lean is not None and abs(TR.points(f, TR.COSTS[i], True, p0 + 1)) <= self.lean:
                d = 1 if x["variant"] % 2 == 0 else 0
            if x["arm"] in ("B", "right-B") and self.mem and x["course"]:
                course = D.parse_course(x["course"])
                past = {"own": [1 if c == "T" else 0 for _, c, _ in course], "counts": [n for _, _, n in course]}
                d = self.mem[f](i, p0, d, past, rng, self.w)
        if self.eta and rng.random() < self.eta:
            d = 1 - d
        return TR.TAKE if d else TR.STAY


def publics():
    return [
        Public("reads, memoryless", "reads", noise=NOISE),
        Public("reads, momentum (join) and regret (lake) 1", "reads", memory="momentum", w=1.0, noise=NOISE),
        Public("reads, trend reader 0.5", "reads", memory="trend reader", w=0.5, noise=NOISE),
        Public("reads, agents exchange rules", "reads", memory="agents exchange rules", w=1.0, noise=NOISE),
        Public("reads the forecast as the count, inertia 0.3", "reads the forecast as the count", memory="inertia",
               w=0.3, noise=NOISE),
        Public("deaf", "deaf", noise=NOISE),
        Public("reads, a presentation lean within 5 points", "reads", lean=5, noise=NOISE),
        Public("reads, declines from forecast 8", "reads", declines_from=8, noise=NOISE),
        Public("reads, a filter at arm B's round 3, probes miscomputed", "reads", filter_at=(3, 0), bad_probes=True,
               noise=NOISE),
    ]


class Stub:
    """The stub client: answer(call) in OpenRouter's shape; `served` the model the response names."""
    live = False

    def __init__(self, answer, served=None, provider=None, tier="default"):
        self.answer, self.served, self.provider, self.tier = answer, served, provider, tier

    def call(self, request, meta):
        a = self.answer(meta)
        finish, msg = "stop", {}
        inv = {v: k for k, v in meta["letters"].items()}
        if meta["kind"] == "probe":
            msg["content"] = "no json here" if a is None else json.dumps(a)
        elif a == FILTERED:
            msg["content"], finish = None, "content_filter"
        elif a == INVALID:
            msg["content"] = "no json here"
        elif a == DECLINE:
            msg = {"content": None, "refusal": "I would rather not choose."}
        else:
            msg["content"] = json.dumps({"choice": inv[a]})
        return {"response": {"model": self.served or request["model"],
                             "provider": self.provider or TC.PROVIDER[meta["family"]],
                             "service_tier": self.tier,
                             "choices": [{"message": msg, "finish_reason": finish}],
                             "usage": {"prompt_tokens": 0, "completion_tokens": 0, "cost": 0.0}},
                "attempts": 1, "errors": []}


def dry_folder(tmp, name):
    folder = Path(tmp) / name
    folder.mkdir(parents=True)
    (folder / "meta.json").write_text(json.dumps({"kind": "dry", "test": D.TEST, "family": FAMILY, "seed": D.SEED}))
    return folder


def fast(answer, family=FAMILY):
    """The plan and the verdicts without the harness: every call answered as it is reached."""
    cache = {}

    def lazy(x):
        if x["id"] not in cache:
            cache[x["id"]] = answer(x)
        return cache[x["id"]]
    plan = D.derive(family, lazy)
    recs = [{**x, "answer": None if x["kind"] == "probe" else lazy(x), "probe": lazy(x) if x["kind"] == "probe" else None}
            for x in plan]
    return plan, T.units({"family": family}, recs)


def same(a, b):
    return json.dumps(a, sort_keys=True) == json.dumps(b, sort_keys=True)


def run_through(folder, answer, catalog=CATALOG, prepare=None):
    sink, _ = R.open_sink(folder)
    return T.rounds(folder, FAMILY, Stub(answer), sink, R.SpendGuard(1.0, 10 ** 6), catalog=catalog, prepare=prepare)


def brief(u):
    out = {}
    for f, v in u["framings"].items():
        out[f] = {k: v[k] for k in ("outcome", "shape", "reading", "second_start") if k in v}
        if "v2" in v:
            out[f]["v2"] = v["v2"]["outcome"]
            out[f]["mismatching_rounds"] = v["v2"]["mismatching_rounds"]
            out[f]["seed_ends"] = dict(Counter(e for a in TR.ARMS for e in v["seed_ends"][a]))
    return out


def code_path(tmp):
    out = []
    for i, m in enumerate(publics()):
        folder = dry_folder(tmp, f"path-{i}")
        k = run_through(folder, lambda x, m=m: m.answer(x, 0))
        meta, recs = T.load(folder, allow_dry=True)
        got = T.units(meta, recs)
        plan, want = fast(lambda x, m=m: m.answer(x, 0))
        out.append({"public": m.name, "calls": len(recs), "rounds": k, "planned": len(plan),
                    "the_logged_calls_are_the_plan": {r["id"] for r in recs} == {x["id"] for x in plan},
                    "verdicts_equal_the_rule": same(got, want), "verdicts": brief(got),
                    "answers": dict(Counter(r["answer"] for r in recs if r["kind"] == "choice"))})
    return out


def refused(f):
    try:
        f()
        return False
    except SystemExit:
        return True


def faults(tmp, folder, m):
    """Faults on one public's log (the join public with memory, so that arm B's courses are in it)."""
    lines = (folder / "calls.jsonl").read_text().splitlines()
    meta0 = json.loads((folder / "meta.json").read_text())
    recs = [json.loads(l) for l in lines]
    out = {}

    def with_lines(new, f):
        (folder / "calls.jsonl").write_text("\n".join(new) + "\n")
        try:
            return f()
        finally:
            (folder / "calls.jsonl").write_text("\n".join(lines) + "\n")

    def edited(i, f):
        r = json.loads(lines[i])
        f(r)
        return lines[:i] + [json.dumps(r)] + lines[i + 1:]
    load = lambda: T.load(folder, allow_dry=True)
    b_i = next(i for i, r in enumerate(recs) if r["arm"] == "B" and r["course"])
    c_i = next(i for i, r in enumerate(recs) if r["kind"] == "choice" and r["answer"] in (TR.TAKE, TR.STAY))
    out["a record's course edited, refused"] = with_lines(
        edited(b_i, lambda r: r.update(course=r["course"].rsplit("/", 1)[0] if "/" in r["course"] else "")),
        lambda: refused(load))
    out["a logged answer the parser reads otherwise, refused"] = with_lines(
        edited(c_i, lambda r: r.update(answer=TR.STAY if r["answer"] == TR.TAKE else TR.TAKE)), lambda: refused(load))
    out["a record another model answered, refused"] = with_lines(
        edited(c_i, lambda r: r["response"].update(model="another/model")), lambda: refused(load))
    out["a record another provider served, refused"] = with_lines(
        edited(c_i, lambda r: r["response"].update(provider="Another Host")), lambda: refused(load))
    out["a record another tier served, refused"] = with_lines(
        edited(c_i, lambda r: r["response"].update(service_tier="priority")), lambda: refused(load))
    for what, stub in (("provider", dict(provider="Another Host")), ("tier", dict(tier="priority"))):
        other = dry_folder(tmp, f"other-{what}-" + folder.name)
        try:
            T.rounds(other, FAMILY, Stub(lambda x: m.answer(x, 0), **stub), R.open_sink(other)[0],
                     R.SpendGuard(1.0, 10 ** 6), catalog=CATALOG)
            stopped = False
        except RuntimeError:
            stopped = True
        out[f"a response another {what} served stops the run, logging nothing"] = stopped and not R.logged(other)
    out["a call not in the plan, refused"] = with_lines(
        lines + [json.dumps({**recs[b_i], "id": recs[b_i]["id"] + "|extra"})], lambda: refused(load))
    (folder / "meta.json").write_text(json.dumps({**meta0, "kind": "smoke"}))
    out["a smoke folder, refused"] = refused(load)
    (folder / "meta.json").write_text(json.dumps(meta0))
    out["the offline table's records of one forecast dropped while the loops derived from them stay, refused"] = \
        with_lines([l for l in lines if not (json.loads(l)["arm"] == "offline" and json.loads(l)["forecast"] == 5)],
                   lambda: refused(load))
    # a run stopped in its last round (the log's last calls not made): those seeds partial, the rest read
    m2, r2 = with_lines(lines[:-3], load)
    out["a run stopped in its last round: its seeds' contexts partial, no harness fault"] = bool(m2["partial_contexts"]) \
        and all(v["outcome"] in ("read",) or v["outcome"].startswith("partial")
                for v in T.units(m2, r2)["framings"].values())
    # a planted line in the harness: an arm A prompt also shows a count; with its hash recomputed (as
    # a faulty build would), and with the frozen prompt's hash kept (which only the text's rebuild finds)
    for name, rehash in (("its hash recomputed", True), ("the frozen prompt's hash kept", False)):
        leaky = dry_folder(tmp, f"planted-{rehash}-" + folder.name)

        def planted(x, smoke=False, rehash=rehash):
            prompt, req = D.prepared(x, smoke)
            if x["arm"] == "A" and x["round"] == 2:
                text = prompt["user"] + "\n\nLast Saturday, 7 of the 10 took part."
                sha = hashlib.sha256((text + json.dumps(prompt["schema"], sort_keys=True)).encode()).hexdigest() \
                    if rehash else prompt["sha256"]
                prompt = {**prompt, "user": text, "sha256": sha}
                req = {**req, "messages": [{"role": "user", "content": text}]}
            return prompt, req
        run_through(leaky, lambda x: m.answer(x, 0), prepare=planted)
        out[f"a planted line in an arm A prompt, {name}, found by the input diff (refused)"] = \
            refused(lambda: T.load(leaky, allow_dry=True))
    out["ok"] = all(out.values())
    return out


def remade(tmp, m):
    """A round's closing read lost (the first round's): the run stops, the calls after its last good
    read unread; a rerun's first catalog read closes them, nothing is made again, and the plan goes on
    from their answers. A pin that moves at the first round's 12th read and comes back: the calls made
    since the last good read are made again, the stub now answering each choice among them with the
    other option, and the plan is the later answers'."""
    res = {}
    closing = 2 + len(D.derive(FAMILY, {})) // R.CATALOG_EVERY + 1    # resume's read, the opening, the in-round reads
    flip = {TR.TAKE: TR.STAY, TR.STAY: TR.TAKE}
    for name, bad, at in (("a lost closing read", "fail", closing), ("a pin that moved and came back", "move", 12)):
        folder = dry_folder(tmp, "remade-" + bad)
        n = {"reads": 0}

        def catalog(family, at=at, bad=bad):
            n["reads"] += 1
            if n["reads"] == at:
                if bad == "fail":
                    raise RuntimeError("the public catalog could not be read")
                return "another/snapshot-20990101"
            return CATALOG(family)
        try:
            run_through(folder, lambda x: m.answer(x, 0), catalog=catalog)
            stopped = False
        except RuntimeError:
            stopped = True
        slug = R.pin(FAMILY)["canonical_slug"]
        reads = R.catalog_reads(folder)
        unread = {r["id"] for r in R.logged(folder) if not R.bracketed(r, reads, slug)}
        good = T.good_answers(folder, FAMILY)
        again = unread if bad == "move" else set()

        def later(x, again=again):
            a = m.answer(x, 0)
            return flip.get(a, a) if x["id"] in again and x["kind"] == "choice" else a
        run_through(folder, later)
        meta, recs = T.load(folder, allow_dry=True)
        got = T.units(meta, recs)
        plan, want = fast(later)
        res[name] = {"stopped": stopped, "unread_after_the_stop": len(unread), "good_before_the_rerun": len(good),
                     "unread_not_among_the_good": not (unread & set(good)), "remade": meta["made_again"],
                     "read_with_the_answers_it_should": same(got, want) and meta["made_again"] == len(again)
                     and not meta["partial_contexts"] and {r["id"] for r in recs} == {x["id"] for x in plan}}
    res["ok"] = all(v["stopped"] and v["unread_after_the_stop"] and v["unread_not_among_the_good"]
                    and v["read_with_the_answers_it_should"] for v in res.values())
    return res


def classification():
    """classify() on response shapes: the reading of a choice is freeze 1's, by each variant's letters."""
    msg = lambda content, finish="stop", **kw: {"choices": [{"message": {"content": content, **kw}, "finish_reason": finish}]}
    L0, L1 = D.letters(0), D.letters(1)
    rows = [
        ("choice A, take part listed first", msg('{"choice": "A"}'), "choice", L0, (TR.TAKE, None)),
        ("choice A, stay out listed first", msg('{"choice": "A"}'), "choice", L1, (TR.STAY, None)),
        ("choice B, stay out listed first", msg('{"choice": "B"}'), "choice", L1, (TR.TAKE, None)),
        ("choice, a letter not offered", msg('{"choice": "C"}'), "choice", L0, (INVALID, None)),
        ("choice, not JSON", msg("A"), "choice", L0, (INVALID, None)),
        ("choice, the refusal field", msg(None, refusal="no"), "choice", L0, (DECLINE, None)),
        ("choice, a filter's stop with no answer", msg(None, "content_filter"), "choice", L0, (FILTERED, None)),
        ("choice, a filter's stop after a whole answer", msg('{"choice": "B"}', "content_filter"), "choice", L0,
         (TR.STAY, None)),
        ("choice, a moderation rejection", {"rejected": {"status": 403}}, "choice", L0, (FILTERED, None)),
        ("choice, no choices", {"choices": []}, "choice", L0, (INVALID, None)),
        ("probe, whole", msg('{"forecast": 3, "points": -5}'), "probe", {}, (None, {"forecast": 3, "points": -5})),
        ("probe, a number as text", msg('{"forecast": "3", "points": -5}'), "probe", {}, (None, None)),
        ("probe, a number true", msg('{"forecast": true, "points": -5}'), "probe", {}, (None, None)),
        ("probe, a number 3.0", msg('{"forecast": 3.0, "points": -5}'), "probe", {}, (None, None)),
        ("probe, a field missing", msg('{"forecast": 3}'), "probe", {}, (None, None)),
        ("probe, not JSON", msg("3"), "probe", {}, (None, None)),
        ("probe, a message that is a string", {"choices": [{"message": "x"}]}, "probe", {}, (None, None)),
        ("probe, a moderation rejection", {"rejected": {"status": 403}}, "probe", {}, (None, None)),
    ]
    out = [{"shape": n, "read": list(D.classify(r, k, L)), "ok": D.classify(r, k, L) == want} for n, r, k, L, want in rows]
    return {"rows": out, "ok": all(r["ok"] for r in out)}


def smoke(tmp):
    """The smoke run through the stub: as planned it goes on and reports its repeated request; a
    decline is read and does not stop it; an unreadable choice, or a response another provider or
    another tier served, stops it."""
    import contextlib
    import io
    clean = Public("reads", "reads", eta=0)
    calls = D.smoke_calls(FAMILY)
    cases = (("as planned", lambda x: clean.answer(x, 0), {}, True),
             ("a decline", lambda x: DECLINE if x["context"] == "smoke/1" else clean.answer(x, 0), {}, True),
             ("an unreadable choice", lambda x: INVALID if x["context"] == "smoke/1" else clean.answer(x, 0), {}, False),
             ("another provider", lambda x: clean.answer(x, 0), {"provider": "Another Host"}, False),
             ("another tier", lambda x: clean.answer(x, 0), {"tier": "priority"}, False))
    res = {}
    for name, answer, serving, want in cases:
        folder = Path(tmp) / ("smoke-" + name.replace(" ", "-"))
        folder.mkdir()
        (folder / "meta.json").write_text(json.dumps({"kind": "smoke", "test": D.TEST, "family": FAMILY, "calls": len(calls)}))
        sink, done = R.open_sink(folder)
        stopped = None
        try:
            R.execute(calls, Stub(answer, **serving), sink, R.SpendGuard(1.0, len(calls)), done, smoke=True,
                      catalog=CATALOG, prepare=D.prepared, classify=D.classify)
        except RuntimeError as e:
            stopped = str(e)
        with contextlib.redirect_stdout(io.StringIO()):
            code = T.smoke_report(folder, stopped)
        rep = json.loads((folder / "smoke-report.json").read_text())
        res[name] = {"go_on": code == 0, "declines": rep["declines"], "repeated_request": rep["repeated_request"],
                     "as_it_should": (code == 0) == want and len(rep["repeated_request"]["answers"]) == 1 + D.SMOKE_REPEATS}
    res["ok"] = all(v["as_it_should"] for v in res.values()) and res["as planned"]["repeated_request"]["alike"]
    return res


FILES_STAGE0 = ("tr6.py", "tr6.json", "tr8.py", "tr_rr.py")
FILES_1 = ("client.py", "conditions.py", "prompts.py", "rule.py", "run.py", "verdicts.py", "PINS.json")
FILES_3 = ("tr3_client.py", "tr3_design.py", "tr3_rule.py", "tr3_run.py", "ENDPOINTS.json")
FILES_6 = ("tr6_design.py", "tr6_rule.py", "tr6_run.py", "tr6_dry_run.py", "write_frozen.py")


def code_hashes():
    """The sha-256 of every file the freeze fixes but this run's output (told-tr6/FROZEN.sha256's list)."""
    d = R.TOLD.parent
    files = [d / f for f in FILES_STAGE0] + [R.TOLD / f for f in FILES_1] + [T3.TOLD / f for f in FILES_3] + \
        [T.TOLD / f for f in FILES_6]
    return {str(f): hashlib.sha256((R.REPO / f).read_bytes()).hexdigest() for f in sorted(files)}


def chain(tmp):
    """This freeze's chain in stand-in git repositories with freeze 1's and freeze 3's folders and their
    own chains beside it, read as the run reads them (tr6_run.frozen: freeze 3's chain, which checks
    freeze 1's first, then this one)."""
    t1, t3, t6 = R.TOLD, T3.TOLD, T.TOLD

    def sha(p):
        return hashlib.sha256(p.read_bytes()).hexdigest()

    def link(r, folder, name, files):
        (r / folder / name).parent.mkdir(parents=True, exist_ok=True)
        (r / folder / name).write_text("".join(f"{sha(r / f)}  {f}\n" for f in files))

    def commit(r):
        R.git(r, "add", "-A")
        R.git(r, "-c", "commit.gpgsign=false", "-c", "core.hooksPath=/dev/null", "commit", "-qm", "step")
    F1 = [t1 / "client.py", t1 / "run.py"]
    F3 = F1 + [t3 / "tr3_client.py", t3 / "tr3_rule.py"]
    F6 = F3 + [t6 / "tr6_rule.py", t6 / "tr6_dry_run.py"]

    def repo(name):
        r = Path(tmp) / "chain" / name
        for d in (t1, t3, t6):
            (r / d).mkdir(parents=True)
        R.git(r, "init", "-q")
        R.git(r, "config", "user.email", "dry-run@localhost")
        R.git(r, "config", "user.name", "dry run")
        for f in F6:
            (r / f).write_text(f.name + " 1\n")
        for folder, files in ((t1, F1), (t3, F3), (t6, F6)):
            link(r, folder, R.BASE_LINK, files)
            commit(r)
        return r

    def read(r):
        try:
            return T.frozen(r, t6)
        except SystemExit:
            return None

    def addendum(r, folder, files, change=None):
        if change:
            (r / change).write_text("changed\n")
        k = 1 + len(list((r / folder / "addenda").glob("ADDENDUM-*.md"))) if (r / folder / "addenda").exists() else 1
        (r / folder / "addenda").mkdir(exist_ok=True)
        (r / folder / "addenda" / f"ADDENDUM-{k}.md").write_text(f"addendum {k}\n")
        link(r, folder, f"addenda/FROZEN-{k}.sha256", files + [folder / "addenda" / f"ADDENDUM-{j}.md" for j in range(1, k + 1)])
        commit(r)
    out = {"the base link read": bool(read(repo("base")))}
    for name, f in (("freeze 1's run", t1 / "run.py"), ("freeze 3's rule", t3 / "tr3_rule.py")):
        r = repo("changed-" + f.name)
        (r / f).write_text("changed\n")
        commit(r)
        out[f"{name} changed, with no addendum, refused"] = read(r) is None
    for name, f, ok in (("TR6's dry run", t6 / "tr6_dry_run.py", True), ("TR6's rule", t6 / "tr6_rule.py", False),
                        ("freeze 3's client, which freeze 3's chain has not taken", t3 / "tr3_client.py", False),
                        ("freeze 1's run", t1 / "run.py", False)):
        r = repo("addendum-" + f.name + "-" + f.parent.name)
        addendum(r, t6, F6, f)
        fc = read(r)
        out[f"a TR6 addendum changing {name}, {'read' if ok else 'refused'}"] = bool(fc) == ok and \
            (not ok or fc["link"] == "addenda/FROZEN-1.sha256")
    r = repo("freeze-3-addendum")
    addendum(r, t3, F3, t3 / "tr3_client.py")
    out["an addendum to freeze 3 changing its client, which TR6 has not taken, refused"] = read(r) is None
    addendum(r, t6, F6)
    fc = read(r)
    out["the same, taken by a TR6 addendum, read"] = bool(fc) and fc["link"] == "addenda/FROZEN-1.sha256" and \
        fc["freeze_3_link"] == "addenda/FROZEN-1.sha256"
    out["ok"] = all(out.values())
    return out


# ---------------------------------------------------------------------------------------------
# 2. The shares
# ---------------------------------------------------------------------------------------------

def share_rows():
    """Stage 0's rows on the frozen public, which reads in each framing; each row is read in the framing
    it names."""
    rows = []
    for f, mname in (("join", "momentum"), ("lake", "regret after a crowded round")):
        for eta in (0.0, 0.001, 0.01):
            rows.append((f, Public(f"{f}: memoryless, eta {eta}", "reads", eta=eta)))
        for w in (0.1, 0.3):
            rows.append((f, Public(f"{f}: inertia w {w}", "reads", memory="inertia", w=w)))
        for w in (0.3, 1.0):
            rows.append((f, Public(f"{f}: {mname} w {w}", "reads", memory="momentum", w=w)))
        rows.append((f, Public(f"{f}: trend reader w 0.5", "reads", memory="trend reader", w=0.5)))
        rows.append((f, Public(f"{f}: agents exchange rules", "reads", memory="agents exchange rules", w=1.0)))
    for kind in ("deaf", "identity", "hybrid"):
        rows.append(("join", Public(f"{kind}: memoryless", kind)))
    return rows


STAGE0 = {"join": "bandwagon, full climb", "lake": "congestion, spread"}
STAGE0_RIVALS = {"deaf: memoryless": "constant 4 (deaf): memoryless, eta 0.001",
                 "identity: memoryless": "identity: memoryless, eta 0.001",
                 "hybrid: memoryless": "hybrid: even agents bandwagon-stalled, odd agents deaf, eta 0.001"}


def stage0_row(name):
    """Stage 0's row for the same memory rule on its nearest public (tr6.json, D_power)."""
    rows = json.loads((D.HERE.parent / "tr6.json").read_text())["D_power"]["rows"]
    if name in STAGE0_RIVALS:
        return rows.get(STAGE0_RIVALS[name])
    kind, rest = name.split(": ", 1)
    key = STAGE0[kind] + ": " + (rest if rest.startswith("memoryless") else
                                 "agents exchange rules (cancellation control), eta 0.001" if "exchange" in rest else
                                 rest + ", eta 0.001")
    return rows.get(key)


def shares(nrep=REPS, moves_only=False):
    out = {}
    for kind, m in share_rows():
        tally = Counter()
        mism = {"A": 0, "B": 0}
        for rep in range(nrep):
            _, u = fast(lambda x, m=m, rep=rep: m.answer(x, rep))
            v = u["framings"][kind]
            tally["void"] += v["outcome"].startswith("void")
            if "v2" in v:
                tally["V2 contradicted"] += v["v2"]["outcome"] == "contradicted"
                tally["diagnostic resolved"] += v["individual_diagnostic"]["p"] < TR.ALPHA
                tally[f"V1: {v['shape']}"] += 1
                for a in TR.ARMS:
                    mism[a] += v["v2"]["mismatching_rounds"][a]
                tally["harness fault"] += bool(v["harness_fault"])
                tally["some seed in A shows a fall"] += any("a fall (rises)" in fs for fs in v["forbidden_from_0"]["A"])
        row = {k: round(n / nrep, 4) for k, n in sorted(tally.items())}
        row["mean mismatching rounds A / B"] = [round(mism[a] / nrep, 2) for a in TR.ARMS]
        s0 = stage0_row(m.name)
        if s0:
            row["Stage 0 (its own public): V2 contradicted"] = s0["V2 contradicted (rounds whose count mismatches; Fisher one-sided 0.05)"]
            row["Stage 0: mean mismatching rounds A / B"] = s0["mean rounds whose count mismatches A / B"]
        out[m.name] = row
    return out


def moves(nrep=REPS):
    """What the freeze's readings move, each beside the case it changes."""
    out = {}
    lit = Public("as the count, inertia 0.3", "reads the forecast as the count", memory="inertia", w=0.3)
    mom = Public("as the count, momentum 1", "reads the forecast as the count", memory="momentum, as the count", w=1.0)
    for m in (lit, mom):
        c = Counter()
        starts = Counter()
        for rep in range(nrep):
            v = fast(lambda x, m=m, rep=rep: m.answer(x, rep))[1]["framings"]["join"]
            if "v2" not in v:
                c["void"] += 1
                continue
            starts[v["second_start"]] += 1
            c["V2 contradicted, both starts"] += v["v2"]["outcome"] == "contradicted"
            c["V2 contradicted, from 0 alone (reported)"] += v["v2_from_0_alone_reported"]["outcome"] == "contradicted"
        c["second start"] = {str(k): n for k, n in starts.items()}
        out[f"the second start: a public reading the forecast as the count, {m.name.split(', ')[1]}"] = {
            "table (no flips)": [sum(base_of("reads the forecast as the count", "join")(i, p) for i in range(TR.N))
                                 for p in range(TR.N + 1)],
            "second start (runs read)": c["second start"], "void": round(c["void"] / nrep, 4),
            "V2 contradicted with the second start": round(c["V2 contradicted, both starts"] / nrep, 4),
            "V2 contradicted from 0 alone": round(c["V2 contradicted, from 0 alone (reported)"] / nrep, 4)}
    lean = Public("lean", "reads", lean=5)
    v = fast(lambda x: lean.answer(x, 0))[1]["framings"]["join"]
    out["a presentation lean (the option listed first, within 5 points): the flag rule voids it"] = {
        "outcome": v["outcome"], "flagged": len(v["flagged"]),
        "note": "with the five offline calls one identical request, a lean would not be flagged; with them the five presentations, it is"}
    dec = Public("declines", "reads", declines_from=8)
    v = fast(lambda x: dec.answer(x, 0))[1]["framings"]["join"]
    out["declines from forecast 8, read as not taking part"] = {"table": v["table"], "outcome": v["outcome"],
                                                                "shape": v.get("shape"), "v2": v["v2"]["outcome"]}
    fil = Public("filter", "reads", filter_at=(3, 0), bad_probes=True)
    v = fast(lambda x: fil.answer(x, 0))[1]["framings"]["lake"]
    out["a filtered answer at arm B's round 3 ends its seed; probes miscomputed leave the reading unread"] = {
        "seed_ends": v["seed_ends"], "rounds_read": v["v2"]["rounds_read"], "reading": v["reading"],
        "probes_restated": v["probes_restated"]}
    fewest = {}
    for b in (0, 1, 2, 5):
        a = 0
        while TR.fisher_one_sided(a, 55, b, 55) >= TR.ALPHA:
            a += 1
        fewest[f"arm A {b}"] = a
    out["fewest arm B mismatching rounds of 55 contradicting V2"] = fewest
    return out


def main():
    import time
    t0 = time.time()
    out = {"test": "TR6 (RF6.3, a prediction read by what it predicts), freeze 6's dry run", "seed": SEED,
           "no_model_called": True, "code_hashes": code_hashes(), "replications": REPS,
           "thresholds_join": THRESHOLD, "capacities_lake": CAPACITY, "thresholds_join_forecast_as_the_count": THRESHOLD_COUNT}
    with tempfile.TemporaryDirectory() as tmp:
        out["code_path"] = code_path(tmp)
        out["code_path_all_equal"] = all(r["verdicts_equal_the_rule"] and r["the_logged_calls_are_the_plan"]
                                         for r in out["code_path"])
        print(f"code path: {time.time() - t0:.0f} s, all equal {out['code_path_all_equal']}", flush=True)
        out["faults"] = faults(tmp, Path(tmp) / "path-1", publics()[1])
        out["remade"] = remade(tmp, publics()[1])
        out["chain"] = chain(tmp)
        out["smoke"] = smoke(tmp)
    out["classification"] = classification()
    print(f"checks: {time.time() - t0:.0f} s", flush=True)
    out["shares"] = shares()
    print(f"shares: {time.time() - t0:.0f} s", flush=True)
    out["moves"] = moves()
    out["code_unchanged_during_the_run"] = code_hashes() == out["code_hashes"]
    out["ok"] = out["code_path_all_equal"] and out["code_unchanged_during_the_run"] and all(
        out[k]["ok"] for k in ("faults", "remade", "chain", "smoke", "classification")) and \
        not any(r.get("harness fault") for r in out["shares"].values())
    (HERE / "results").mkdir(exist_ok=True)
    (HERE / "results" / "dry-run.json").write_text(json.dumps(out, indent=1, ensure_ascii=False) + "\n")
    print(f"ok {out['ok']}; {time.time() - t0:.0f} s")
    return 0 if out["ok"] else 1


if __name__ == "__main__":
    sys.exit(main())
