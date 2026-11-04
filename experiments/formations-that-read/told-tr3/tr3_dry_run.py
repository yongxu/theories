"""The dry run of TR3: simulated members through the frozen code, no model called.

    python3 -B tr3_dry_run.py        # writes results/dry-run.json; a few minutes on one core

1. The code path. For each of eight members, tr3_run.rounds makes the whole plan through freeze 1's
   run.execute and a stub client (prompts built, responses in OpenRouter's shape, some guesses
   unreadable, filtered or declined and some probes unreadable), the log is written to a temporary
   folder and tr3_run.load (freeze 1's verdicts.load, given this freeze's plan, prepare and parser)
   reads it back. Its verdicts must equal those of the same rule on the same answers without the
   harness, where the plan is derived in one pass from answers drawn as each call is reached.
   Refused: a planted leak in the harness (the next member's draw in a fresh sequence's prompt,
   which the rebuild of every logged prompt, the input diff, finds), a record's history edited, a
   logged answer the parser reads otherwise, a record another model answered, a call not in the
   plan, a record another provider or another tier served, a path cell's records dropped while the
   calls derived from them stay, and a smoke folder; a response another provider or another tier
   served stops the run, logging nothing. A run stopped in its last round leaves the verdicts that
   reach its missing calls partial and the others equal. A round's closing read lost, then made by a rerun whose remade calls answer
   otherwise, must be read with the plan the later answers give; a pin that moved and came back
   likewise. The smoke run's stop rule is run through the stub. A table of response shapes checks
   classify(); BHW's table is recomputed from tr3.py's FilterType; each pin's route is checked
   against its endpoint list as read (ENDPOINTS.json), under OpenRouter's slug rule and under the
   reading in which a slug also names the tiers below it; the chain of this freeze, with freeze 1's
   own chain checked first, is checked in stand-in git repositories. The sha-256 of every file the
   freeze fixes is recorded at the start and the end, and must not change between.
2. The shares. RF4's conditional verdict for prefix (A,A) beside Stage 0's E3 (4,000 replications
   each) and, for BHW with flips, its exact shares; BHW's timing rule beside Stage 0's E7 under C1
   (2,000 each), read at the ties and beyond them too, for BHW with ties to the own light, toward
   the public belief, toward X and by a coin, and a member weighing its own light below a public
   one; and
   what the freeze's readings move: the walk follows the act a member ignores with, the
   timing rule reads every cell and needs its probes restated, and the leak control reproduces a
   breach for a member whose guess a shown light changes, and not for one whose guess it leaves (a
   Bayesian member breaking ties toward the public belief) or one that declines where shown a red light.

The simulated members are Stage 0's own (tr3.py): each call independent, the member's probability
of A at its position, draw and history; a member with no light shown answers as with a fair coin's
light. One member reads the next player's light where none is shown, from the call's sequence and
context labels: no endpoint can, since a request carries only its prompt, so it shows the rule's
arithmetic, as Stage 0's leaky rows do, not a channel a real member could have.
"""

import hashlib
import json
import random
import sys
import tempfile
from collections import Counter
from fractions import Fraction as Fr
from pathlib import Path

import tr3_design as D          # puts freeze 1's told/ on the path
import tr3_rule as TR
import tr3_run as T
import tr3_client as TC
import client as cl             # noqa: E402
import run as R                 # noqa: E402
from conditions import DECLINE  # noqa: E402
from rule import FILTERED, INVALID  # noqa: E402

sys.path.insert(0, str(D.HERE.parent))
import tr3 as S0                # noqa: E402  Stage 0

HERE = D.HERE
SEED = "RFZ-freeze-2-tr3-dry-run"
FAMILY = R.PINS["pins"][0]["id"]      # any frozen pin: the stub reads none of it
CATALOG = lambda family: R.pin(family)["canonical_slug"]    # the dry run's stand-in for the public catalog
P = Fr(3, 5)
URNS = {"1:1": S0.Urn(P, Fr(1, 2)), "3:2": S0.Urn(P, P)}
NOISE = {"invalid": 0.004, "filtered": 0.002, "decline": 0.002, "probe": 0.01}


def bhw(u):
    return S0.FilterType("BHW", u, S0.decide_own)


def next_draw(x):
    if x["arm"] not in ("fresh", "reask"):
        return None
    ds = D.sequence_draws(x["prior"], x["prefix"], x["sequence"])
    i = x["member"] - len(x["prefix"]) + 1
    return ds[i] if i < len(ds) else None


class Member:
    """A simulated member: tr3.py's type at each prior; reads a leak shown to it where leak_reads (True:
    follows the shown light outright; "own" or "public": weighs it as one more light, by Bayes from the
    type's public belief, breaking a tie toward its own light or toward the public belief); with
    chance `hidden`, reads the next member's draw in a fresh sequence's context from the call's labels,
    which no endpoint can (a request carries only its prompt): the rule's arithmetic, not a channel."""

    def __init__(self, name, make, hidden=0, leak_reads=False, noise=None, salt=""):
        self.name, self.hidden, self.leak_reads, self.noise, self.salt = name, Fr(hidden), leak_reads, noise or {}, salt
        self.types = {p: make(u) for p, u in URNS.items()}

    def p_a(self, x):
        t = self.types[x["prior"]]
        h = tuple(1 if a == "A" else 0 for a in x["history"])
        if not x["draw"]:
            return (t.prob_A(len(h), 1, h) + t.prob_A(len(h), 0, h)) / 2
        if x["leak"] and self.leak_reads is True:
            return Fr(1) if x["leak"] == "a" else Fr(0)
        if x["leak"] and self.leak_reads in ("own", "public"):
            u, m, s = URNS[x["prior"]], t.mu(h), 1 if x["draw"] == "a" else 0
            q = u.post(u.post(m, s), 1 if x["leak"] == "a" else 0)
            if q != Fr(1, 2):
                return Fr(1) if q > Fr(1, 2) else Fr(0)
            if self.leak_reads == "public" and m != Fr(1, 2):
                return Fr(1) if m > Fr(1, 2) else Fr(0)
            return Fr(s)
        p = t.prob_A(len(h), 1 if x["draw"] == "a" else 0, h)
        if self.hidden and x.get("where", "fresh") == "fresh":
            nxt = next_draw(x)
            if nxt is not None:
                p = (1 - self.hidden) * p + self.hidden * (1 if nxt == "a" else 0)
        return p

    def answer(self, x, rep, again=0):
        rng = random.Random(f"{SEED}|{rep}|{self.name}|{self.salt}|{again}|{x['id']}")
        u = rng.random()
        if self.leak_reads == "declines" and x["kind"] == "guess" and x["leak"] == "b":
            return DECLINE
        if x["kind"] == "probe":
            if u < self.noise.get("probe", 0):
                return None
            return {"light": D.LIGHT[x["draw"]], "earlier_X": x["history"].count("A"),
                    "earlier_Y": x["history"].count("B")}
        lo = 0.0
        for kind, a in (("invalid", INVALID), ("filtered", FILTERED), ("decline", DECLINE)):
            lo += self.noise.get(kind, 0)
            if u < lo:
                return a
        return "A" if rng.random() < float(self.p_a(x)) else "B"


class Stub:
    """The stub client: answer(call) in OpenRouter's shape; `served` the model the response names."""
    live = False

    def __init__(self, answer, served=None, provider=None, tier="default"):
        self.answer, self.served, self.provider, self.tier = answer, served, provider, tier

    def call(self, request, meta):
        a = self.answer(meta)
        finish, msg = "stop", {}
        if meta["kind"] == "probe":
            msg["content"] = "no json here" if a is None else json.dumps(a)
        elif a == FILTERED:
            msg["content"], finish = None, "content_filter"
        elif a == INVALID:
            msg["content"] = "no json here"
        elif a == DECLINE:
            msg = {"content": None, "refusal": "I would rather not guess."}
        else:
            msg["content"] = json.dumps({"choice": D.NAME[a]})
        return {"response": {"model": self.served or request["model"],
                             "provider": self.provider or TC.PROVIDER[meta["family"]],
                             "service_tier": self.tier,
                             "choices": [{"message": msg, "finish_reason": finish}],
                             "usage": {"prompt_tokens": 0, "completion_tokens": 0, "cost": 0.0}},
                "attempts": 1, "errors": []}


def members():
    naive = lambda u: S0.Naive(u)
    return [
        Member("BHW, ties to the own draw", bhw, noise=NOISE),
        Member("BHW, flips 1/100", lambda u: S0.Noisy(bhw(u), Fr(1, 100)), noise=NOISE),
        Member("hybrid: own draw w.p. 1/10", lambda u: S0.Mix("h", naive(u), q=Fr(1, 10)), noise=NOISE),
        Member("constant A", lambda u: S0.Rule("c", lambda n, s, h: 1), noise=NOISE),
        Member("constant B", lambda u: S0.Rule("c", lambda n, s, h: 0), noise=NOISE),
        Member("own draw always", lambda u: S0.Rule("o", lambda n, s, h: s), noise=NOISE),
        Member("reads a leak shown to it", bhw, leak_reads=True, noise=NOISE),
        Member("reads the next light, never shown it (the rule's arithmetic: no endpoint can)",
               lambda u: S0.Rule("c", lambda n, s, h: 1), hidden=1, noise=NOISE),
    ]


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


def code_path(tmp):
    out = []
    keep = None
    for i, m in enumerate(members()):
        folder = dry_folder(tmp, f"path-{i}")
        k = run_through(folder, lambda x, m=m: m.answer(x, 0))
        meta, recs = T.load(folder, allow_dry=True)
        got = T.units(meta, recs)
        plan, want = fast(lambda x, m=m: m.answer(x, 0))
        out.append({"member": m.name, "calls": len(recs), "rounds": k, "planned": len(plan),
                    "the_logged_calls_are_the_plan": {r["id"] for r in recs} == {x["id"] for x in plan},
                    "verdicts_equal_the_rule": same(got, want),
                    "timing": got["timing"]["outcome"], "prefixes": {p: u["outcome"] for p, u in got["prefixes"].items()},
                    "leak_control": got["leak_control"]["outcome"],
                    "answers": dict(Counter(r["answer"] for r in recs if r["kind"] == "guess"))})
        if m.name.startswith("BHW, flips"):
            keep = (folder, m)
    return out, keep


def refused(f):
    try:
        f()
        return False
    except SystemExit:
        return True


def faults(tmp, folder, m):
    """Faults on one member's log (BHW with the code path's non-guesses, so that differences and
    re-asks are in it)."""
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
    fresh_i = next(i for i, r in enumerate(recs) if r["arm"] == "fresh" and r["history"])
    guess_i = next(i for i, r in enumerate(recs) if r["kind"] == "guess" and r["answer"] in TR.ACTS)
    out["a record's history edited, refused"] = with_lines(edited(fresh_i, lambda r: r.update(history=r["history"][:-1])),
                                                           lambda: refused(load))
    out["a logged answer the parser reads otherwise, refused"] = with_lines(
        edited(guess_i, lambda r: r.update(answer="B" if r["answer"] == "A" else "A")), lambda: refused(load))
    out["a record another model answered, refused"] = with_lines(
        edited(guess_i, lambda r: r["response"].update(model="another/model")), lambda: refused(load))
    out["a record another provider served, refused"] = with_lines(
        edited(guess_i, lambda r: r["response"].update(provider="Another Host")), lambda: refused(load))
    out["a record another tier served, refused"] = with_lines(
        edited(guess_i, lambda r: r["response"].update(service_tier="priority")), lambda: refused(load))
    # an earlier record of a call, made before any catalog read and so never read (as one a resume
    # makes again): kept with the endpoint's provider, the folder is read; with another's, refused
    def early(provider):
        r = {**recs[guess_i], "t0": 0.0, "t1": 0.0, "response": {**recs[guess_i]["response"], "provider": provider}}
        return [json.dumps(r)] + lines
    out["an unread record another provider served, refused (the same record the endpoint's provider served, read)"] = \
        not with_lines(early(TC.PROVIDER[FAMILY]), lambda: refused(load)) and \
        with_lines(early("Another Host"), lambda: refused(load))
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
        lines + [json.dumps({**recs[fresh_i], "id": recs[fresh_i]["id"] + "|extra"})], lambda: refused(load))
    (folder / "meta.json").write_text(json.dumps({**meta0, "kind": "smoke"}))
    out["a smoke folder, refused"] = refused(load)
    (folder / "meta.json").write_text(json.dumps(meta0))
    # a prefix's first cell's records dropped while the fresh sequences derived from them stay:
    # those calls are not in the plan the log gives, refused
    meta, rs = load()
    full = T.units(meta, rs)
    ans = {r["id"]: r["answer"] for r in rs}
    walked = [(p, f) for p, f in TR.PREFIXES if full["prefixes"][f"{p}/{f}"]["outcome"] != "premise not met"
              and not full["prefixes"][f"{p}/{f}"]["outcome"].startswith("void")]
    gone = f"cell/{walked[0][0]}/{walked[0][1]}" if walked else None
    out["a path cell's records dropped while the calls derived from them stay, refused"] = bool(gone) and with_lines(
        [l for l in lines if json.loads(l)["context"] != gone], lambda: refused(load))
    # a run stopped in its last round (the log's last calls not made): the verdicts that reach them
    # partial, the others as before
    last = {json.loads(l)["id"] for l in lines[-5:]}
    m2, r2 = with_lines(lines[:-5], load)
    u2 = T.units(m2, r2)
    reach = {f"{p}/{f}" for p, f in TR.PREFIXES
             if any(x["id"] in last for x in D.walk(FAMILY, p, f, lambda x: ans.get(x["id"]))[0])}
    leak = any(x["id"] in last for x in D.walk(FAMILY, *TR.LEAK_PREFIX, lambda x: ans.get(x["id"]), leak=True)[0])
    out["a run stopped in its last round: what reaches its calls partial, the rest as before"] = \
        bool(reach or leak) and bool(m2["partial_contexts"]) \
        and all(u2["prefixes"][p]["outcome"] == "partial" for p in reach) \
        and all(same(u2["prefixes"][p], full["prefixes"][p]) for p in full["prefixes"] if p not in reach) \
        and (u2["leak_control"]["outcome"] == "partial" if leak else same(u2["leak_control"], full["leak_control"])) \
        and same(u2["timing"], full["timing"])
    # a planted leak in the harness: a fresh call's prompt also names the next member's draw
    leaky = dry_folder(tmp, "planted-leak-" + folder.name)

    def planted(x, smoke=False):
        prompt, req = D.prepared(x, smoke)
        nxt = next_draw(x)
        if x["arm"] == "fresh" and nxt:
            prompt = D.build(x["kind"], x["prior"], x["history"], x["draw"], nxt)
            req = {**req, "messages": [{"role": "user", "content": prompt["user"]}]}
        return prompt, req
    run_through(leaky, lambda x: m.answer(x, 0), prepare=planted)
    out["a planted leak in a fresh sequence's prompt, found by the input diff (refused)"] = \
        refused(lambda: T.load(leaky, allow_dry=True))
    out["ok"] = all(out.values())
    return out


def remade(tmp, m):
    """A round's closing read lost (the first round's closing read failing): the run stops, the
    calls after its last good read unread; a rerun's first catalog read closes them, nothing is made
    again, and the plan goes on from their answers. A pin that moves at the first round's 12th read
    and comes back: the calls made since the last good read are made again, the stub now answering
    each guess among them with the other act, and the plan is the later answers'."""
    res = {}
    closing = 2 + len(D.derive(FAMILY, {})) // R.CATALOG_EVERY + 1    # resume's read, the opening, the in-round reads
    flip = {"A": "B", "B": "A"}
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
            return flip.get(a, a) if x["id"] in again and x["kind"] == "guess" else a
        run_through(folder, later)
        meta, recs = T.load(folder, allow_dry=True)
        got = T.units(meta, recs)
        plan, want = fast(later)
        res[name] = {"stopped": stopped, "unread_after_the_stop": len(unread), "good_before_the_rerun": len(good),
                     "unread_not_among_the_good": not (unread & set(good)), "remade": meta["made_again"],
                     "read_with_the_answers_it_should": same(got, want) and meta["made_again"] == len(again)
                     and not meta["partial_contexts"] and {r["id"] for r in recs} == {x["id"] for x in plan}}
    res["ok"] = all(v["stopped"] and v["unread_after_the_stop"] and v["unread_not_among_the_good"]
                    and v["read_with_the_answers_it_should"] for k, v in res.items())
    return res


def classification():
    """classify() on response shapes: the reading of a guess is freeze 1's of a choice."""
    L = D.LETTERS
    msg = lambda content, finish="stop", **kw: {"choices": [{"message": {"content": content, **kw}, "finish_reason": finish}]}
    rows = [
        ("guess X", msg('{"choice": "X"}'), "guess", ("A", None)),
        ("guess Y", msg('{"choice": "Y"}'), "guess", ("B", None)),
        ("guess, a letter not offered", msg('{"choice": "Z"}'), "guess", (INVALID, None)),
        ("guess, not JSON", msg("X"), "guess", (INVALID, None)),
        ("guess, the refusal field", msg(None, refusal="no"), "guess", (DECLINE, None)),
        ("guess, a filter's stop with no answer", msg(None, "content_filter"), "guess", (FILTERED, None)),
        ("guess, a filter's stop after a whole answer", msg('{"choice": "X"}', "content_filter"), "guess", ("A", None)),
        ("guess, a moderation rejection", {"rejected": {"status": 403}}, "guess", (FILTERED, None)),
        ("guess, no choices", {"choices": []}, "guess", (INVALID, None)),
        ("probe, whole", msg('{"light": "red", "earlier_X": 2, "earlier_Y": 0}'), "probe",
         (None, {"light": "red", "earlier_X": 2, "earlier_Y": 0})),
        ("probe, a count as text", msg('{"light": "red", "earlier_X": "2", "earlier_Y": 0}'), "probe", (None, None)),
        ("probe, a count true", msg('{"light": "red", "earlier_X": true, "earlier_Y": 0}'), "probe", (None, None)),
        ("probe, a count 2.0", msg('{"light": "red", "earlier_X": 2.0, "earlier_Y": 0}'), "probe", (None, None)),
        ("probe, another colour", msg('{"light": "blue", "earlier_X": 2, "earlier_Y": 0}'), "probe", (None, None)),
        ("probe, a field missing", msg('{"light": "red", "earlier_X": 2}'), "probe", (None, None)),
        ("probe, not JSON", msg("red"), "probe", (None, None)),
        ("probe, a message that is a string", {"choices": [{"message": "x"}]}, "probe", (None, None)),
        ("probe, a moderation rejection", {"rejected": {"status": 403}}, "probe", (None, None)),
    ]
    out = [{"shape": n, "read": list(TC.classify(r, k, L)), "ok": TC.classify(r, k, L) == want} for n, r, k, want in rows]
    return {"rows": out, "ok": all(r["ok"] for r in out)}


def decide_first(q, s, mu):
    """BHW's decision, a tie broken toward X (A), the name the prompt lists first."""
    return Fr(1) if q > Fr(1, 2) else Fr(0) if q < Fr(1, 2) else Fr(1)


class ReadsAsBHW:
    """A member that reads the earlier guesses as BHW does (BHW's public belief) and decides by its
    own rule on that belief and its light."""

    def __init__(self, urn, decide):
        self.bhw, self.urn, self.decide = bhw(urn), urn, decide

    def prob_A(self, n, s, h):
        m = self.bhw.mu(h)
        return self.decide(self.urn.post(m, s), s, m)


def bhw_table():
    """BHW's frozen classes, recomputed from tr3.py's FilterType at precision 3/5; and its ties: BHW
    breaking ties toward the public belief differs from it at exactly the five tie cells, with the
    class TIES gives; a member that leaves its light unless the odds for it reach 3:2 (tr3.py's
    decide_overweight at 4/5, leaving it where the odds against it exceed 4:5, as a member weighing
    its own light below a public one does) has those classes at all 38 cells where it reads the
    earlier guesses as made by members like itself, and at the 33 timing cells where it reads them
    as BHW does, differing then at every exploration cell; and BHW breaking ties toward X, the name
    listed first, has the class toward the public belief at the three ties where that belief is X
    and BHW's at every other cell."""
    bad = []

    def cls(t, hh):
        return {(1, 1): "ignores A", (0, 0): "ignores B", (1, 0): "reads (follows)", (0, 1): "reads (inverted)"}[
            (t.prob_A(len(hh), 1, hh), t.prob_A(len(hh), 0, hh))]

    for p, u in URNS.items():
        t, tp = bhw(u), S0.FilterType("BHW, public ties", u, S0.decide_public)
        tu = S0.FilterType("own light at 4/5", u, S0.decide_overweight(Fr(4, 5)))
        tb, tx = ReadsAsBHW(u, S0.decide_overweight(Fr(4, 5))), S0.FilterType("ties to X", u, decide_first)
        for h in list(TR.BHW[p]) + list(TR.EXPLORE[p]):
            hh = tuple(1 if a == "A" else 0 for a in h)
            if cls(tu, hh) != cls(tp, hh):
                bad.append(f"{p}/{h}: own light at 4/5 {cls(tu, hh)}, public ties {cls(tp, hh)}")
            if (h in TR.BHW[p]) != (cls(tb, hh) == cls(tp, hh)):
                bad.append(f"{p}/{h}: own light at 4/5, read as BHW reads, {cls(tb, hh)}, public ties {cls(tp, hh)}")
            want_x = TR.TIES[(p, h)] if TR.TIES.get((p, h)) == "ignores A" else cls(t, hh)
            if cls(tx, hh) != want_x:
                bad.append(f"{p}/{h}: ties to X {cls(tx, hh)}, expected {want_x}")
        for h, want in TR.BHW[p].items():
            hh = tuple(1 if a == "A" else 0 for a in h)
            got = S0.bhw_prediction(t, len(hh), hh)
            if got != want:
                bad.append(f"{p}/{h}: {got} vs {want}")
            pub = cls(tp, hh)
            if (pub != want) != ((p, h) in TR.TIES) or ((p, h) in TR.TIES and pub != TR.TIES[(p, h)]):
                bad.append(f"{p}/{h}: public ties {pub}, own ties {want}, TIES {TR.TIES.get((p, h))}")
        for h in TR.EXPLORE[p]:
            hh = tuple(1 if a == "A" else 0 for a in h)
            if t.on_path(hh):
                bad.append(f"{p}/{h} is on BHW's path")
    return {"differences": bad, "ok": not bad}


def endpoints():
    """Each pin's route names one endpoint in its list as read (ENDPOINTS.json), by OpenRouter's rule
    as its routing page states it (a slug names its own endpoint and every endpoint below it but a
    service tier's; ignore removes what its slugs name), and also under the reading in which a slug
    names the tiers below it too: the pin's dated snapshot, a standard tier, not listing implicit
    caching, taking every parameter request() sends it, and named by the provider the run checks."""
    lists = json.loads((HERE / "ENDPOINTS.json").read_text())
    bad = []
    if lists["chosen"] != TC.ENDPOINT or lists["routes"] != TC.ROUTE:
        bad.append("ENDPOINTS.json's endpoints or routes are not tr3_client's")
    for p in R.PINS["pins"]:
        es = lists["lists"][p["id"]]["endpoints"]
        route, tag = TC.ROUTE[p["id"]], TC.ENDPOINT[p["id"]]

        def named(slug, tiers):
            return {e["tag"] for e in es if e["tag"] == slug or (e["tag"].startswith(slug + "/")
                                                                 and (tiers or not e["service_tier"]))}
        for tiers in (False, True):
            left = set().union(*(named(x, tiers) for x in route["order"])) - \
                set().union(set(), *(named(x, tiers) for x in route.get("ignore", [])))
            if left != {tag}:
                bad.append(f"{p['id']}: the route names {sorted(left)}, not {tag}"
                           + (" where a slug names its tiers" if tiers else ""))
        if any(b.startswith(p["id"] + ": the route") for b in bad):
            continue
        e = next(x for x in es if x["tag"] == tag)
        req = TC.request(p, D.build("guess", "1:1", "", "a", ""), False, "x")
        if req["provider"] != {**route, "allow_fallbacks": False, "require_parameters": True}:
            bad.append(f"{p['id']}: the request's route is not ROUTE's")
        sent = {"response_format", "structured_outputs", "max_tokens", "reasoning"} | ({"temperature"} & set(req)) \
            | ({"seed"} & set(req))
        if not e["name"].endswith(p["canonical_slug"]) or e["service_tier"] or e.get("supports_implicit_caching") \
                or not sent <= set(e["supported_parameters"]) or e["provider_name"] != TC.PROVIDER[p["id"]]:
            bad.append(f"{p['id']}: {tag} serves {e['name']}, tier {e['service_tier']}, caching "
                       f"{e.get('supports_implicit_caching')}, missing {sorted(sent - set(e['supported_parameters']))}")
    return {"differences": bad, "ok": not bad}


def smoke(tmp):
    """The smoke run through the stub: as planned it goes on and reports its repeated request; a
    decline is read and does not stop it; an unreadable guess, or a response another provider or
    another tier served, stops it."""
    import contextlib
    import io
    clean = Member("BHW", bhw)
    calls = D.smoke_calls(FAMILY)
    cases = (("as planned", lambda x: clean.answer(x, 0), {}, True),
             ("a decline", lambda x: DECLINE if x["context"] == "smoke/1" else clean.answer(x, 0), {}, True),
             ("an unreadable guess", lambda x: INVALID if x["context"] == "smoke/1" else clean.answer(x, 0), {}, False),
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


def code_hashes():
    """The sha-256 of every file the freeze fixes but this run's output (told-tr3/FROZEN.sha256's list)."""
    d = R.TOLD.parent
    files = [d / f for f in ("tr3.py", "tr3.json", "tr8.py", "tr_rr.py")] + \
        [R.TOLD / f for f in ("client.py", "conditions.py", "prompts.py", "rule.py", "run.py", "verdicts.py", "PINS.json")] + \
        [T.TOLD / f for f in ("tr3_client.py", "tr3_design.py", "tr3_rule.py", "tr3_run.py", "tr3_dry_run.py", "ENDPOINTS.json",
                              "write_frozen.py")]
    return {str(f): hashlib.sha256((R.REPO / f).read_bytes()).hexdigest() for f in sorted(files)}


def chain(tmp):
    """This freeze's chain in stand-in git repositories with freeze 1's folder and its own chain beside
    it, read as the run reads them (tr3_run.frozen: freeze 1's chain first, then this one)."""
    t1, t2 = R.TOLD, T.TOLD

    def sha(p):
        return hashlib.sha256(p.read_bytes()).hexdigest()

    def link(r, folder, name, files):
        (r / folder / name).parent.mkdir(parents=True, exist_ok=True)
        (r / folder / name).write_text("".join(f"{sha(r / f)}  {f}\n" for f in files))

    def commit(r):
        R.git(r, "add", "-A")
        R.git(r, "-c", "commit.gpgsign=false", "-c", "core.hooksPath=/dev/null", "commit", "-qm", "step")

    def repo(name):
        r = Path(tmp) / "chain" / name
        for d in (t1, t2):
            (r / d).mkdir(parents=True)
        R.git(r, "init", "-q")
        R.git(r, "config", "user.email", "dry-run@localhost")
        R.git(r, "config", "user.name", "dry run")
        for f, s_ in ((t1 / "client.py", "c1\n"), (t1 / "run.py", "r1\n"), (t2 / "tr3_client.py", "tc1\n"),
                      (t2 / "tr3_rule.py", "rule1\n")):
            (r / f).write_text(s_)
        link(r, t1, R.BASE_LINK, F1)
        commit(r)
        link(r, t2, R.BASE_LINK, FILES)
        commit(r)
        return r
    F1 = [t1 / "client.py", t1 / "run.py"]
    FILES = F1 + [t2 / "tr3_client.py", t2 / "tr3_rule.py"]

    def read(r):
        try:
            return T.frozen(r, t2)
        except SystemExit:
            return None

    def addendum(r, folder, files, change=None):
        if change:
            (r / change).write_text("changed\n")
        (r / folder / "addenda").mkdir(exist_ok=True)
        (r / folder / "addenda" / "ADDENDUM-1.md").write_text("addendum 1\n")
        link(r, folder, "addenda/FROZEN-1.sha256", files + [folder / "addenda" / "ADDENDUM-1.md"])
        commit(r)
    out = {}
    out["the base link read"] = bool(read(repo("base")))
    r = repo("freeze-1-file")
    (r / t1 / "run.py").write_text("r2\n")
    commit(r)
    out["a freeze 1 file it lists changed, with no addendum, refused"] = read(r) is None
    for name, f, ok in (("TR3's client", t2 / "tr3_client.py", True), ("TR3's rule", t2 / "tr3_rule.py", False),
                        ("freeze 1's client, which freeze 1's chain has not taken", t1 / "client.py", False),
                        ("freeze 1's run", t1 / "run.py", False)):
        r = repo("addendum-" + f.name + "-" + f.parent.name)
        addendum(r, t2, FILES, f)
        fc = read(r)
        out[f"a TR3 addendum changing {name}, {'read' if ok else 'refused'}"] = bool(fc) == ok and \
            (not ok or fc["link"] == "addenda/FROZEN-1.sha256")
    r = repo("freeze-1-addendum")
    addendum(r, t1, F1, t1 / "client.py")
    out["an addendum to freeze 1 changing its client, which TR3 has not taken, refused"] = read(r) is None
    addendum(r, t2, FILES)
    fc = read(r)
    out["the same, taken by a TR3 addendum, read"] = bool(fc) and fc["link"] == "addenda/FROZEN-1.sha256" and \
        fc["freeze_1_link"] == "addenda/FROZEN-1.sha256"
    out["ok"] = all(out.values())
    return out


def e3_shares(nrep=4000):
    """RF4's conditional verdict for prefix (A,A) at 1:1, by the frozen walk, beside Stage 0's E3."""
    naive = lambda u: S0.Naive(u)
    rows = [("BHW, ties to the own draw", bhw, 0)]
    for e in ("1/1000", "1/200", "1/100", "1/20"):
        rows.append((f"BHW, flips {e}", lambda u, e=e: S0.Noisy(bhw(u), Fr(e)), 0))
    for q in ("1/20", "1/10", "1/4"):
        rows.append((f"hybrid: own draw w.p. {q}", lambda u, q=q: S0.Mix("h", naive(u), q=Fr(q)), 0))
    rows += [("majority copier", lambda u: S0.Rule("m", lambda n, s, h: S0.majority(h, s)), 0),
             ("constant A", lambda u: S0.Rule("c", lambda n, s, h: 1), 0),
             ("leaky 1 (guesses the next member's draw)", lambda u: S0.Rule("f", lambda n, s, h: 1), 1),
             ("leaky 1/2", lambda u: S0.Rule("f", lambda n, s, h: 1), Fr(1, 2)),
             ("own draw always", lambda u: S0.Rule("o", lambda n, s, h: s), 0)]
    stage0 = json.loads((D.HERE.parent / "tr3.json").read_text())["E_power"]["E3_conditional_verdict_prefix_(A,A)"]["rows"]
    names = {"premise not met": "no verdict: premise not met", "void: a flagged cell": "no verdict: flagged cell",
             "passed": "passed", "breach reproduced": "breach reproduced",
             "unresolved difference": "unresolved: unreproduced difference"}
    out = {}
    for name, make, hidden in rows:
        m = Member(name, make, hidden=hidden)
        c = Counter()
        for rep in range(nrep):
            cache = {}

            def lazy(x):
                if x["id"] not in cache:
                    cache[x["id"]] = m.answer(x, rep)
                return cache[x["id"]]
            c[D.walk(FAMILY, "1:1", "AA", lazy)[1]["outcome"]] += 1
        frozen = {names[k]: round(c[k] / nrep, 4) for k in names}
        s0 = stage0.get(name)
        out[name] = {"frozen": frozen, "stage0": s0,
                     "largest_difference": None if s0 is None else round(max(abs(frozen[k] - s0[k]) for k in frozen), 4)}
        if name.startswith("BHW, flips"):
            # BHW ignores at every cell of the path, so each call flips alone: 60 cell calls, then 48
            # fresh ones; a reproduced breach (both re-ask blocks unanimous) has chance below eta^5
            e, cells, fresh = float(Fr(name.split()[-1])), 6 * 2 * TR.REPS, 6 * TR.SEQUENCES
            out[name]["exact"] = {"no verdict: flagged cell": round(1 - (1 - e) ** cells, 4),
                                  "passed": round((1 - e) ** (cells + fresh), 4),
                                  "unresolved: unreproduced difference": round((1 - e) ** cells * (1 - (1 - e) ** fresh), 4)}
            out[name]["z"] = {k: round((frozen[k] - v) / (v * (1 - v) / nrep) ** 0.5, 2) if 0 < v < 1 else None
                              for k, v in out[name]["exact"].items()}
    return out


def e7_shares(nrep=2000):
    """BHW's timing rule, both priors, frozen (every cell read, its probes restated), beside Stage 0's E7, C1."""
    stage0 = json.loads((D.HERE.parent / "tr3.json").read_text())["E_power"]["E7_cell_rule_choice_both_priors"][
        "C1: R 5, one off allowed"]
    makers = [("BHW, ties to the own draw", bhw),
              ("BHW, ties toward the public belief", lambda u: S0.FilterType("p", u, S0.decide_public)),
              ("BHW, coin ties", lambda u: S0.FilterType("c", u, S0.decide_coin)),
              ("leaves its light unless the odds for it reach 3:2",
               lambda u: S0.FilterType("u", u, S0.decide_overweight(Fr(4, 5)))),
              ("BHW, ties to X, the name listed first", lambda u: S0.FilterType("x", u, decide_first)),
              ("overweighting 2:1", lambda u: S0.FilterType("o", u, S0.decide_overweight(Fr(2)))),
              ("hybrid 1/5", lambda u: S0.Mix("h", S0.Naive(u), q=Fr(1, 5))),
              ("hybrid 1/10", lambda u: S0.Mix("h", S0.Naive(u), q=Fr(1, 10)))]
    out = {}
    cells = [(p, h) for p in TR.BHW for h in TR.BHW[p]]
    for base, make in makers:
        for eta in (None, "1/1000", "3/1000", "1/100", "3/100"):
            name = base if eta is None else f"{base}, flips {eta}"
            types = {p: (make(u) if eta is None else S0.Noisy(make(u), Fr(eta))) for p, u in URNS.items()}
            pa = {(p, h, d): float(types[p].prob_A(len(h), 1 if d == "a" else 0, tuple(1 if a == "A" else 0 for a in h)))
                  for p, h in cells for d in TR.DRAWS}
            rng = random.Random(f"{SEED}|e7|{name}")
            c, ties = Counter(), Counter()
            for _ in range(nrep):
                classes = {(p, h): TR.cell_class({d: ["A" if rng.random() < pa[(p, h, d)] else "B" for _ in range(TR.REPS)]
                                                  for d in TR.DRAWS}, tol=1) for p, h in cells}
                probes = {(p, h, d): {"light": D.LIGHT[d], "earlier_X": h.count("A"), "earlier_Y": h.count("B")}
                          for p, h in cells for d in TR.DRAWS}
                c[TR.timing(classes, probes)["outcome"]] += 1
                ties[TR.tie_reading(classes, probes)["reading"]] += 1
            s0 = stage0.get(name)
            out[name] = {"frozen": {k: round(c[k] / nrep, 4) for k in ("placed", "contradicted", "unresolved")},
                         "stage0": s0, "read_at_the_ties": {k: round(v / nrep, 4) for k, v in sorted(ties.items())}}
    return out


def moves(nrep=2000):
    """What the freeze's readings move. A member that ignores with the act opposite to the prefix's
    (constant B after (A,A)) is followed along the path it reaches: passed, where a walk held to the
    planned cells (A,A,A)... would have none. BHW whose probes fail in 5% of calls: unresolved
    where they fail. The leak control: a member that follows the shown light is a reproduced breach;
    BHW, which reads no leak, passes; a Bayesian member weighing the shown light as one more light
    changes its guess only where its own light and the shown one are both red, offsetting the two
    guesses, and there only if it breaks the tie toward its own light: a reproduced breach if it
    does, a pass, as BHW's, if it breaks it toward the public belief. A member that declines wherever it is
    shown a red light differs by a non-guess, which never reproduces: unresolved."""
    out = {}
    for name, make, leak_reads, probe in (("constant B, prefix (A,A)", lambda u: S0.Rule("c", lambda n, s, h: 0), False, 0),
                                          ("BHW, probes failing in 5% of calls", bhw, False, 0.05),
                                          ("BHW, the leak control", bhw, False, 0),
                                          ("reads a leak shown to it, the leak control", bhw, True, 0),
                                          ("weighs a shown light as one more, ties to its own light, the leak control",
                                           bhw, "own", 0),
                                          ("weighs a shown light as one more, ties toward the public belief, the leak control",
                                           bhw, "public", 0),
                                          ("declines where it is shown a red light, the leak control", bhw,
                                           "declines", 0)):
        m = Member(name, make, leak_reads=leak_reads, noise={"probe": probe})
        c = Counter()
        n = 200 if "probes" not in name else nrep
        for rep in range(n):
            cache = {}

            def lazy(x):
                if x["id"] not in cache:
                    cache[x["id"]] = m.answer(x, rep)
                return cache[x["id"]]
            if "probes" in name:
                classes, probes = {}, {}
                for p, h in [(p, h) for p in TR.BHW for h in TR.BHW[p]]:
                    cl_ = D.cell(FAMILY, p, h)
                    classes[(p, h)] = TR.cell_class({d: [lazy(x) for x in cl_[d]] for d in TR.DRAWS}, tol=1)
                    for d in TR.DRAWS:
                        probes[(p, h, d)] = lazy(D.call(FAMILY, "probe", f"probe/{p}/{h or '()'}", "probe", p, h, d, 0))
                c[TR.timing(classes, probes)["outcome"]] += 1
            elif "leak" in name:
                c[D.walk(FAMILY, *TR.LEAK_PREFIX, lazy, leak=True)[1]["outcome"]] += 1
            else:
                c[D.walk(FAMILY, "1:1", "AA", lazy)[1]["outcome"]] += 1
        out[name] = {"replications": n, "shares": {k: round(v / n, 4) for k, v in sorted(c.items())}}
    return out


def main():
    import time
    t0 = time.time()
    out = {"test": "TR3 (RF4, readers reading readers), freeze 3's dry run", "seed": SEED, "no_model_called": True,
           "code_hashes": code_hashes()}
    with tempfile.TemporaryDirectory() as tmp:
        rows, (folder, m) = code_path(tmp)
        out["code_path"] = rows
        out["code_path_all_equal"] = all(r["verdicts_equal_the_rule"] and r["the_logged_calls_are_the_plan"] for r in rows)
        print(f"code path: {time.time() - t0:.0f} s, all equal {out['code_path_all_equal']}", flush=True)
        out["faults"] = faults(tmp, Path(tmp) / "path-0", members()[0])
        out["remade"] = remade(tmp, m)
        out["chain"] = chain(tmp)
        out["smoke"] = smoke(tmp)
    out["classification"] = classification()
    out["bhw_table"] = bhw_table()
    out["sequences"] = {("leak " if leak else "") + f"{p}/{h}": ["".join(D.sequence_draws(p, h, m, leak))
                                                              for m in range(TR.SEQUENCES)]
                        for p, h, leak in [(p, h, False) for p, h in TR.PREFIXES] + [(*TR.LEAK_PREFIX, True)]}
    out["endpoints"] = endpoints()
    print(f"checks: {time.time() - t0:.0f} s", flush=True)
    out["E3_shares"] = e3_shares()
    print(f"E3: {time.time() - t0:.0f} s", flush=True)
    out["E7_shares"] = e7_shares()
    print(f"E7: {time.time() - t0:.0f} s", flush=True)
    out["moves"] = moves()
    out["code_unchanged_during_the_run"] = code_hashes() == out["code_hashes"]
    out["ok"] = out["code_path_all_equal"] and out["code_unchanged_during_the_run"] and all(
        out[k]["ok"] for k in ("faults", "remade", "chain", "smoke", "classification", "bhw_table", "endpoints"))
    out["largest_E3_difference_from_stage0"] = max(v["largest_difference"] for v in out["E3_shares"].values()
                                                   if v["largest_difference"] is not None)
    (HERE / "results").mkdir(exist_ok=True)
    (HERE / "results" / "dry-run.json").write_text(json.dumps(out, indent=1, ensure_ascii=False) + "\n")
    print(f"ok {out['ok']}; largest E3 difference from Stage 0 {out['largest_E3_difference_from_stage0']}; "
          f"{time.time() - t0:.0f} s")
    return 0 if out["ok"] else 1


if __name__ == "__main__":
    sys.exit(main())
