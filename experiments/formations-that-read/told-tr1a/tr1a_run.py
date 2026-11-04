"""The run of TR1's informing variant and its reading, frozen with its rule, on freeze 1's harness and
FREEZE-5's folder handling (FREEZE-9.md).

    python3 -B tr1a_run.py plan                                    # the calls and the usage estimate, no call
    python3 -B tr1a_run.py smoke --family PIN --max-usd 1          # the release's first step (section 8)
    python3 -B tr1a_run.py run --family PIN --max-usd USD          # every condition, at --parallel 1
    python3 -B tr1a_run.py run --family PIN --conditions C,T,X --max-usd USD [--parallel 8]
    python3 -B tr1a_run.py verdicts --family PIN                   # writes verdicts.json beside calls.jsonl
    python3 -B tr1a_run.py mend --family PIN [--cause CAUSE]       # a log cut short: section 8, no call

USD from the smoke run's projection. Nothing here runs without Ren's yes: `smoke` and `run` call a model
through OpenRouter with his key. The calls are made, logged and checked by freeze 1's code (told/run.py's
execute, resume, catalog read, spend guard and served check; told/client.py's client and parser),
imported unchanged; the folder handling is FREEZE-5's (told-tr1/tr1_run.py: its line writer, the
whole meta, the check of a log cut short, `mend`, and the smoke run's cause of a stop), imported
unchanged, its messages citing FREEZE-5's section 8, which FREEZE-9's section 8 carries over. This module
gives them TR1A's plan, call builder and parser (tr1a_design), its folder (results/tr1a/<pin>/) and its
lock, and reads the smoke runs, the starts and the verdicts as FREEZE-5's run reads TR1's.

The rules, as FREEZE-5's (section 8): one command of a pin at a time (pin_lock, results/tr1a/<pin>.lock);
each meta written whole before any log; a folder whose meta does not serve or whose logs do not read whole
refused before any call or reading, until `mend`; a smoke run read per condition, a stop of the run
lifted by a later smoke run that passes, a stop by the pin's own answers standing where at least
SMOKE_STANDS of a condition's four smoke answers do not read and its run has not begun; `--max-usd` the
folder's total over every start; a command refused before any call where it could gain nothing.
A course's calls carry its earlier rounds (tr1a_design.rounds): each reads, for every earlier step of its
course, that step's latest record logged before it; the courses run at parallel 1 in the plan's order,
so an earlier step made again is logged before any later step that reads it, and the reading rebuilds
each record's prompt from the records logged before it (load).
"""

import argparse
import contextlib
import fcntl
import json
import sys
import time
from collections import Counter, defaultdict
from pathlib import Path

import tr1a_design as D           # first: puts freeze 1's harness, Stage 0 and FREEZE-5's folder on the path
import tr1a_rule as TR
import client as cl               # freeze 1's (told/client.py)
import run as R                   # freeze 1's (told/run.py)
import verdicts as VD             # freeze 1's (told/verdicts.py)
import tr1_run as T1              # FREEZE-5's (told-tr1/tr1_run.py): the folder handling

D.own_files()

read_json, write_whole, open_sink = T1.read_json, T1.write_whole, T1.open_sink
cut_short, meta_missing, refuse_cut, mend, moved_lines = T1.cut_short, T1.meta_missing, T1.refuse_cut, T1.mend, T1.moved_lines
cause, smoke_records, LOGS = T1.cause, T1.smoke_records, T1.LOGS
assert T1.D.classify is D.classify, "the smoke run's cause reads by the parser TR1A reads by"

HERE = Path(__file__).resolve().parent
FOLDER = HERE.relative_to(R.REPO)     # told-tr1a/, repository-relative
SMOKE_STANDS = T1.SMOKE_STANDS        # FREEZE-5's: two of a condition's four smoke answers
# What an addendum to this freeze may change (section 8): freeze 1's client, where freeze 1's own addendum
# changed it, and this freeze's dry run and its result; in freeze 1's PINS.json only a pin's served_as.
MAY_CHANGE = frozenset({str(R.TOLD / "client.py"), str(FOLDER / "tr1a_dry_run.py"),
                        str(FOLDER / "results" / "dry-run.json")})
ROOT = HERE                     # where smoke/ and results/ are; the dry run's command checks set another
CLIENT = cl.OpenRouterClient    # the dry run's command checks set stand-ins for these two
CATALOG = R.catalog_slug


def frozen(repo=None):
    """This freeze's frozen check: freeze 1's own first, then FREEZE-5's chain (its files imported here are
    its newest link's), then this freeze's chain in this folder, with its MAY_CHANGE."""
    repo = repo or R.REPO
    R.frozen_check(repo, R.TOLD, R.ADDENDUM_MAY_CHANGE)
    R.frozen_check(repo, T1.FOLDER, T1.MAY_CHANGE)
    return R.frozen_check(repo, FOLDER, MAY_CHANGE)


def scored(family, root=None):
    """The pin's results folder, into which `run` writes its calls."""
    return Path(root or ROOT) / "results" / D.TEST / family.replace("/", "__")


def smoke_folders(family, root=None):
    return sorted((Path(root or ROOT) / "smoke").glob(family.replace("/", "__") + "-*"))


@contextlib.contextmanager
def pin_lock(family, root=None):
    """One command of a pin at a time: an exclusive lock on results/tr1a/<pin>.lock, as FREEZE-5's pin_lock
    on its own folder, refused before anything while another command holds it or where it cannot be taken.
    The system drops it when its process ends, killed or not."""
    p = scored(family, root).with_name(family.replace("/", "__") + ".lock")
    p.parent.mkdir(parents=True, exist_ok=True)
    with p.open("a") as fh:
        try:
            fcntl.flock(fh.fileno(), fcntl.LOCK_EX | fcntl.LOCK_NB)
        except BlockingIOError:
            raise SystemExit(f"another command of {family} is running, holding {p.name}: one command of a pin at a "
                             "time (FREEZE-9.md, section 8); nothing was done") from None
        except OSError as e:
            raise SystemExit(f"{p.name} could not be locked ({e}): a pin's commands need a folder that locks "
                             "(FREEZE-9.md, section 8); nothing was done") from None
        yield p


# ------------------------------------------------------------------------------------------------
# The smoke run and what it releases (section 8), as FREEZE-5's run reads TR1's

def smoke_stops(folder, stopped, may_stand=None):
    """A smoke run's stops, its records read by the parser as it now stands. stopped: the run's own stop
    (execute's), or None. "all": calls another model answered or made under another catalog slug, which,
    with a stop of the run, a call not made or a line of the log that does not read ("cut"), stop every
    condition, a stop of the run. Per condition, "answers": its answers the parser cannot read, the pin's
    own; "stands": those answers where there are at least SMOKE_STANDS of them and the pin's own answers
    may stop the condition for good (may_stand: False once its run has begun, begun; True for all where
    None), a stop that stands; "run": its calls the provider rejected or filtered or the token limit cut,
    and its unreadable answers that do not stand, a stop of the run, which a later smoke run that passes
    lifts. So one unreadable answer, or any once the condition's run has begun (a changed client may be
    misreading the pin), stops the condition until a smoke run passes, and never for good. "go": each
    condition goes on where nothing stops it."""
    folder = Path(folder)
    meta = read_json(folder / "meta.json") or {}
    family = meta["family"]
    slug = R.pin(family)["canonical_slug"]
    recs, cut = smoke_records(folder)
    planned = Counter(x["context"] for x in D.plan(family, smoke=True))
    made = Counter(r["context"] for r in recs)
    every = [r["id"] for r in recs if not R.served_ok(family, r["response"]) or r.get("catalog") != slug]
    by = {c: defaultdict(list) for c in D.CONDITIONS}
    for r in recs:
        why = None if r["id"] in every else cause(r)
        if why:
            by[r["context"]][why].append(r["id"])
    out = {"stopped": stopped, "all": every, "cut": cut}
    whole = stopped is None and not every and not cut
    for c in D.CONDITIONS:
        answers = list(by[c]["answer"])
        stands = answers if len(answers) >= SMOKE_STANDS and (may_stand is None or may_stand[c]) else []
        out[c] = {"run": by[c]["provider"] + by[c]["limit"] + [i for i in answers if i not in stands],
                  "answers": answers, "stands": stands}
    out["go"] = {c: whole and made[c] == planned[c] and not out[c]["run"] and not out[c]["stands"]
                 for c in D.CONDITIONS}
    return out


def smoke_report(folder, stopped=None, may_stand=None):
    """The smoke run's report (section 8), written for a stopped smoke run too: each condition's go or stop,
    the calls that stop every condition, per condition those that stop it (a stop of the run, or a stop
    that stands) and the pin's unreadable answers that stop it only as a stop of the run; the served models and the
    catalog's slugs; tokens and cost per call, and the full plan's projection. Nothing of the answers is
    reported beyond whether each was read. Exit 0 where a condition goes on, 2 where none does."""
    folder = Path(folder)
    recs, _ = smoke_records(folder)
    meta = read_json(folder / "meta.json")
    s = smoke_stops(folder, stopped, may_stand)
    use = [((r["response"] or {}).get("usage") or {}) for r in recs]
    chars = [len(r["prompt"]) for r in recs]
    tin = [u.get("prompt_tokens") or 0 for u in use]
    tout = [u.get("completion_tokens") or 0 for u in use]
    usd = [float(u.get("cost") or 0) for u in use]
    report = {"family": meta["family"], "calls": len(recs), "planned": meta["calls"], "stopped": stopped,
              "go_on": s["go"], "stops every condition": s["all"], "log lines that do not read": s["cut"],
              "stops of the run": {c: s[c]["run"] for c in D.CONDITIONS},
              "stops that stand": {c: s[c]["stands"] for c in D.CONDITIONS},
              "the pin's unreadable answers that stop as a stop of the run (fewer than two, or its run begun)":
                  {c: [i for i in s[c]["answers"] if i not in s[c]["stands"]] for c in D.CONDITIONS},
              "served_by": dict(Counter(str(R.served_model(r["response"])) for r in recs)),
              "catalog": sorted({str(r.get("catalog")) for r in recs}),
              "per_call": {"n": len(recs), "prompt_chars": sum(chars) / len(recs) if recs else None,
                           "in": sum(tin) / len(recs) if recs else None, "out": sum(tout) / len(recs) if recs else None,
                           "usd": sum(usd) / len(recs) if recs else None}}
    report["projected_full_design"] = projection(meta["family"], sum(chars), sum(tin), sum(tout), len(recs))
    write_whole(folder / "smoke-report.json", json.dumps(report, indent=1) + "\n")
    print(json.dumps(report, indent=1))
    return 0 if any(s["go"].values()) else 2


def plan_chars(family):
    """The characters of every planned call's text, a course's with stand-in rounds (the other option taken
    at every round, which pays its words the longest), by condition."""
    recs, out = [], Counter()
    for x in D.plan(family):
        prompt = D.build(x, recs if x["condition"] in D.COURSES else ())
        out[x["condition"]] += len(prompt["user"])
        if x["condition"] in D.COURSES:
            recs.append({"id": x["id"], "answer": D.UNTRIED})
    return dict(out)


def projection(family, chars, tin, tout, n):
    """The full plan's tokens and cost, from a smoke run's tokens per character of text and its mean
    output, at the pin's listed prices; "not measured" where the smoke run has no tokens."""
    total = plan_chars(family)
    calls = len(D.plan(family))
    if not n or not chars or not tin:
        return {"calls": calls, "tokens": "not measured", "usd": "not measured"}
    pr = R.pin(family)["pricing"]
    t_in = sum(total.values()) * tin / chars
    t_out = calls * tout / n
    return {"calls": calls, "tokens_in": round(t_in), "tokens_out": round(t_out),
            "usd": round(t_in * float(pr["prompt"]) + t_out * float(pr["completion"]), 2),
            "note": "the smoke run's tokens per character of text and mean output per call, at the listed prices"}


def scored_meta(family, root=None):
    return read_json(scored(family, root) / "meta.json") or {}


def read_whole(family, cond, root=None):
    """Whether the reading reads the pin's condition whole: every one of its calls logged in the pin's
    results folder, its latest record made between two catalog reads naming the frozen snapshot. Such a
    condition has no call left to make."""
    out = scored(family, root)
    reads, slug = R.catalog_reads(out), R.pin(family)["canonical_slug"]
    latest = {r["id"]: r for r in R.logged(out)}
    return all(i in latest and R.bracketed(latest[i], reads, slug)
               for i in (x["id"] for x in D.plan(family, (cond,))))


def begun(family, root=None):
    """The conditions whose run has begun: those of which a start of `run` that asked for them has a call
    logged, a record of that condition begun after the start and before the next one. A start with no call
    of a condition logged begins none of it. The
    windows read the machine's clock, and a pin's commands run one at a time (pin_lock). Once a
    condition's run has begun, nothing the pin answers at a smoke run, earlier or later, stops it for
    good; its unreadable answers are a stop of the run (smoke_stops)."""
    out = scored(family, root)
    starts = scored_meta(family, root).get("starts") or []
    made = [(r["t0"], r.get("condition")) for r in R.logged(out) if r.get("t0") is not None]
    ends = [s["t"] for s in starts[1:]] + [float("inf")]
    return {c for s, end in zip(starts, ends) for t, c in made if s["t"] <= t < end and c in s["conditions"]}


def smoke_runs(family, root=None):
    """Every smoke run of the pin, oldest first, read by the parser as it now stands (smoke_stops): its
    folder's name, the frozen hashes it was made on, each condition's go or stop, and the pin's own answers
    that stop each condition, a stop that stands, none for a condition whose run has begun. A smoke run
    with no readable report is read as stopped, a stop of the run; one with no readable meta as stopped on
    no frozen files (`smoke` writes its meta before any call, so it made none)."""
    out = []
    may = {c: c not in begun(family, root) for c in D.CONDITIONS}
    for d in smoke_folders(family, root):
        meta, rep = read_json(d / "meta.json"), read_json(d / "smoke-report.json")
        if meta is None:
            out.append({"folder": d.name, "hashes": None, "go_on": {c: False for c in D.CONDITIONS},
                        "stands": {c: [] for c in D.CONDITIONS}})
            continue
        stopped = rep.get("stopped") if isinstance(rep, dict) else "no report"
        s = smoke_stops(d, stopped, may)
        out.append({"folder": d.name, "hashes": meta.get("hashes"), "go_on": s["go"],
                    "stands": {c: s[c]["stands"] for c in D.CONDITIONS}})
    return out


def stood(runs):
    """Each condition's stop that stands among these smoke runs: the first where the pin's own answers stop
    it, or None. Only a parser that reads those answers so that they stop nothing lifts it (every smoke run
    is read by the parser as it now stands), or the condition's run having begun."""
    return {c: next((r["folder"] for r in runs if r["stands"][c]), None) for c in D.CONDITIONS}


def smoke_needed(runs, hashes, done=()):
    """Why a smoke run of the pin is needed, or None. One is needed only for a condition it could release:
    one not read whole (done: those read whole) and whose stop does not stand; for such a condition, where
    the pin has no smoke run, where its latest was made on other frozen files or made no call, or where its
    latest stopped that condition by a stop of the run. Otherwise another smoke run could release nothing
    and could only add a stop, so `smoke` is refused."""
    held = stood(runs)
    open_ = [c for c in D.CONDITIONS if c not in done and not held[c]]
    if not open_:
        return None
    if not runs:
        return "the pin has no smoke run"
    last = runs[-1]
    if last["hashes"] != hashes:
        return f"the latest smoke run ({last['folder']}) was made on other frozen files, or made no call"
    lift = [c for c in open_ if not last["go_on"][c]]
    return f"the latest smoke run ({last['folder']}) stopped {', '.join(lift)}, a stop of the run" if lift else None


def smoke_passed(family, hashes, conditions, root=None):
    """The folder of the pin's latest smoke run, where no condition asked has a stop that stands, some
    condition asked is not read whole, and that smoke run, made on these frozen hashes, passed every
    condition asked that is not read whole. A stop of the run is lifted by a later smoke run that passes."""
    runs = smoke_runs(family, root)
    if not runs:
        raise SystemExit(f"no smoke run for {family}: run `smoke` first; no call was made")
    held = stood(runs)
    if any(held[c] for c in conditions):
        raise SystemExit("; ".join(f"{family}'s condition {c} was stopped by the pin's own answers at its smoke run "
                                   f"({held[c]}), a stop that stands" for c in sorted(conditions) if held[c])
                         + " (FREEZE-9.md, section 8); no call was made")
    left = [c for c in sorted(conditions) if not read_whole(family, c, root)]
    if not left:
        raise SystemExit(f"{family}'s {', '.join(sorted(conditions))} read whole: no call is left to make "
                         "(FREEZE-9.md, section 8); no call was made")
    last = runs[-1]
    if last["hashes"] != hashes:
        raise SystemExit(f"{family}'s latest smoke run ({last['folder']}) was made on other frozen files, or made no "
                         "call: a run needs a smoke run on its own frozen files (FREEZE-9.md, section 8); no call was made")
    stopped = [c for c in left if not last["go_on"][c]]
    if stopped:
        raise SystemExit(f"{family}'s latest smoke run ({last['folder']}) stopped {', '.join(stopped)}, a stop of the "
                         "run, which a later smoke run that passes lifts (FREEZE-9.md, section 8); no call was made")
    return last["folder"]


# ------------------------------------------------------------------------------------------------
# The reading (section 7)

def load(folder, allow_dry=False, check=None):
    """freeze 1's verdicts.load with this freeze's plan, parser and chain, and a prepare that rebuilds
    each record's call from the records logged before it, as it was made (freeze 1's load takes the
    records in their logged order, and the identity of each is asserted); every refusal of freeze 1's
    reading holds here. Then each logged prompt's text against its rebuild (freeze 1 compares its hash)."""
    folder = Path(folder)
    refuse_cut(folder, "nothing was read")
    recs = R.logged(folder)
    pos = iter(range(len(recs)))

    def prepare(x):
        k = next(pos)
        assert recs[k]["id"] == x["id"], "freeze 1's reading takes the records in their logged order"
        return D.prepared(x, recs[:k] if x["condition"] in D.COURSES else ())
    meta, good = VD.load(folder, allow_dry, plan=lambda test, fam: D.plan(fam), prepare=prepare,
                         classify=D.classify, frozen=check or frozen)
    plan = {x["id"]: x for x in D.plan(meta["family"])}
    text = [r["id"] for k, r in enumerate(recs)
            if r.get("prompt") != D.build(plan[r["id"]], recs[:k] if r["condition"] in D.COURSES else ())["user"]]
    if text:
        raise SystemExit(f"records whose logged prompt is not the one their call rebuilds: {text[:3]}")
    return meta, good, recs


def rounds_apart(family, good, recs):
    """The course records read whose rounds show, for an earlier step, an answer other than that step's
    record read: none where each course carried the answers the reading reads (section 6)."""
    read = {r["id"]: r for r in good}
    out = []
    for k, r in enumerate(recs):
        if r["condition"] not in D.COURSES or read.get(r["id"]) is not r:
            continue
        for s, a in enumerate(D.rounds(r, recs[:k]), 1):
            i = D.call_id(family, r["condition"], r["world"], r["order"], r["rep"], s)
            if i not in read or read[i]["answer"] != a:
                out.append(r["id"])
                break
    return out


def verdicts(folder, check=None, allow_dry=False):
    """The pin's reading (section 7): V1 where every one of its occasions and X are read whole, the
    premise, and the descriptive reading of the courses where U and I are read whole."""
    meta, good, recs = load(folder, allow_dry, check)
    family = meta["family"]
    role = R.pin(family)["role"]
    by = {r["id"]: r for r in good}
    part = set(meta["partial_contexts"])
    whole = {c: c not in part and all(x["id"] in by for x in D.plan(family, (c,))) for c in D.CONDITIONS}
    v = TR.v1(TR.occasion_answers(by, family)) if all(whole[c] for c in ("C", "T", "I")) else None
    prem = TR.premise(TR.x_answers(by, family)) if whole["X"] else None
    if v is None or prem is None:
        reading = {"family": family, "pin_role": role, "decides": role == "decides", "bridge": "no verdict",
                   "why": "not read whole: " + ", ".join(c for c in ("C", "T", "I", "X") if not whole[c]), "said": None}
    else:
        reading = TR.reading(family, v, prem, role)
    desc = TR.descriptive(by, family, v, prem) if v is not None and prem is not None and whole["U"] else None
    runs = smoke_runs(family, Path(folder).parents[2]) if not allow_dry else []
    res = {"test": D.TEST, "family": family, "pin_role": role, "reading": reading, "V1": v, "premise": prem,
           "descriptive": desc,
           "not_read_whole": {c: ("partly read" if c in part else "no call read") for c in D.CONDITIONS if not whole[c]},
           "expectation": TR.expectations([{"family": family, "premise": prem}]),
           "rounds_not_the_answers_read": rounds_apart(family, good, recs),
           "served_by": dict(Counter(str(R.served_model(r["response"])) for r in good)),
           "no_verdict_partly_logged": meta["partial_contexts"], "calls_made_again": meta["made_again"],
           "starts": meta.get("starts", []), "stops_that_stand": stood(runs) if runs else {},
           "lines_moved_by_mend": moved_lines(folder),
           "catalog_reads": [{"t": t_, "slug": s} for t_, s in R.catalog_reads(folder)],
           "reads_naming_no_snapshot_put_in_by_mend": [t_ for t_, s in R.catalog_reads(folder) if s is None],
           "read_under": meta["read_under"]}
    write_whole(Path(folder) / "verdicts.json", json.dumps(res, indent=1) + "\n")
    print(f"TR1A {family} [{role}]: {reading['bridge']}" + (f" ({reading['why']})" if reading["why"] else "")
          + (f"; {reading['said']}" if reading["said"] else ""))
    if desc:
        print(f"  class (descriptive): {desc['class (descriptive)']}")
    return res


# ------------------------------------------------------------------------------------------------

def estimate(family):
    """The design's estimate, before any call: tokens in from the text's characters at four a token, out
    from 50 to 1,000 a call (the answer and low reasoning), at the pin's listed prices."""
    chars = plan_chars(family)
    calls = Counter(x["condition"] for x in D.plan(family))
    pr = R.pin(family)["pricing"]
    t_in = sum(chars.values()) / 4
    lo, hi = (t_in * float(pr["prompt"]) + sum(calls.values()) * out * float(pr["completion"]) for out in (50, 1000))
    return {"calls": dict(calls), "tokens_in": round(t_in), "usd_low": round(lo, 2), "usd_high": round(hi, 2),
            "tokens_in_by_condition": {c: round(v / 4) for c, v in chars.items()}}


def main(argv=None):
    ap = argparse.ArgumentParser()
    sub = ap.add_subparsers(dest="cmd", required=True)
    sub.add_parser("plan")
    sm = sub.add_parser("smoke")
    sm.add_argument("--family", required=True)
    sm.add_argument("--max-usd", type=float, required=True)
    rn = sub.add_parser("run")
    rn.add_argument("--family", required=True)
    rn.add_argument("--conditions", default="all")
    rn.add_argument("--max-usd", type=float, required=True)
    rn.add_argument("--parallel", type=int, default=1)
    vd = sub.add_parser("verdicts")
    vd.add_argument("--family", required=True)
    mn = sub.add_parser("mend")
    mn.add_argument("--family", required=True)
    mn.add_argument("--cause", default=None)
    a = ap.parse_args(argv)
    if a.cmd == "plan":
        for p_ in R.PINS["pins"]:
            e = estimate(p_["id"])
            print(f"{p_['id']:32s} {sum(e['calls'].values())} calls ({', '.join(f'{c} {k}' for c, k in e['calls'].items())}), "
                  f"about {e['tokens_in'] / 1e6:.2f}M tokens in, ${e['usd_low']} to ${e['usd_high']} at the listed "
                  "prices (the design's estimate; the smoke run measures it)")
        return
    R.pin(a.family)
    if a.cmd == "verdicts":
        with pin_lock(a.family):
            verdicts(scored(a.family))
        return
    if a.cmd == "mend":
        with pin_lock(a.family):
            frozen()
            got = mend(scored(a.family), a.family, a.cause)
            print(f"moved, per log, a line of so many bytes: {got} (FREEZE-9.md, section 8); start `run` again")
            if "catalog.jsonl" in got:
                put = json.loads((scored(a.family) / "catalog.jsonl").read_bytes().splitlines()[-1])
                print(f"put in the catalog's place: a read naming no snapshot, at t {put['t']} (section 8)")
        return
    if a.cmd == "smoke":
        with pin_lock(a.family):
            fc = frozen()
            refuse_cut(scored(a.family))
            runs = smoke_runs(a.family)
            if smoke_needed(runs, fc["hashes"], [c for c in D.CONDITIONS if read_whole(a.family, c)]) is None:
                raise SystemExit(f"no smoke run of {a.family} is needed: each condition is read whole, stopped by the "
                                 "pin's own answers, a stop that stands, or released by its latest smoke run on these "
                                 "frozen files, so another could release nothing and could only add a stop "
                                 "(FREEZE-9.md, section 8); no call was made")
            may = {c: c not in begun(a.family) for c in D.CONDITIONS}
            calls = D.plan(a.family, smoke=True)
            out = Path(ROOT) / "smoke" / (a.family.replace("/", "__") + "-"
                                          + time.strftime("%Y%m%dT%H%M%SZ", time.gmtime()))
            try:
                out.mkdir(parents=True)
            except FileExistsError:
                raise SystemExit(f"a smoke run of {a.family} began this second ({out.name}); no call was made: start "
                                 "it again") from None
            write_whole(out / "meta.json", json.dumps({"kind": "smoke", "test": D.TEST, "family": a.family,
                                                       "seed": D.SEED, "calls": len(calls), "link": fc["link"],
                                                       "hashes": fc["hashes"], "freeze_commit": fc["freeze_commit"]},
                                                      indent=1) + "\n")
            sink, done = open_sink(out)
            stopped = None
            try:
                R.execute(calls, CLIENT(), sink, R.SpendGuard(a.max_usd, len(calls)), done, smoke=True,
                          catalog=CATALOG, link=fc["link"], prepare=D.preparer(sink.records), classify=D.classify)
            except RuntimeError as e:
                stopped = str(e)
                print(f"the smoke run stopped: {e}")
            code = smoke_report(out, stopped, may)
        sys.exit(code)
    if a.cmd == "run":
        with pin_lock(a.family):
            fc = frozen()
            want = set(D.CONDITIONS) if a.conditions == "all" else set(a.conditions.split(","))
            if not want or not want <= set(D.CONDITIONS):
                raise SystemExit(f"unknown condition in {a.conditions}; known: {', '.join(D.CONDITIONS)}; no call was made")
            if want & set(D.COURSES) and a.parallel != 1:
                raise SystemExit("a course's calls carry its earlier rounds, so U and I run at --parallel 1 "
                                 "(FREEZE-9.md, section 6); no call was made")
            if a.parallel < 1:
                raise SystemExit("--parallel is at least 1; no call was made")
            out = scored(a.family)
            refuse_cut(out)
            smoke = smoke_passed(a.family, fc["hashes"], want)
            start = {"t": time.time(), "link": fc["link"], "head": fc["head"], "conditions": sorted(want),
                     "parallel": a.parallel, "smoke": smoke,
                     "smoke_runs": [{"folder": s["folder"], "on these frozen files": s["hashes"] == fc["hashes"],
                                     "go_on": s["go_on"], "stands": {c: bool(v) for c, v in s["stands"].items()}}
                                    for s in smoke_runs(a.family)]}
            meta = {"kind": "scored", "test": D.TEST, "family": a.family, "seed": D.SEED,
                    "freeze_commit": fc["freeze_commit"], "head": fc["head"], "pin": R.pin(a.family), "smoke": smoke,
                    "links": {fc["link"]: fc["hashes"]}, "link_commits": {fc["link"]: fc["commits"][fc["link"]]},
                    "starts": [start]}
            out.mkdir(parents=True, exist_ok=True)
            mp = out / "meta.json"
            keys = ("kind", "test", "family", "seed")
            if mp.exists():
                old = read_json(mp)
                if {k: old.get(k) for k in keys} != {k: meta.get(k) for k in keys} \
                        or not R.links_ok(old.get("links"), fc["chain"]):
                    raise SystemExit("this folder holds another run's calls; refusing to mix them; no call was made")
                if fc["link"] not in old["links"]:     # resumed under a later link of the chain
                    old["links"][fc["link"]] = fc["hashes"]
                    old.setdefault("link_commits", {})[fc["link"]] = fc["commits"][fc["link"]]
                old.setdefault("starts", []).append(start)
                write_whole(mp, json.dumps(old, indent=1) + "\n")
            else:
                write_whole(mp, json.dumps(meta, indent=1) + "\n")
            sink, _ = open_sink(out)
            done = R.resume(out, a.family, sink, CATALOG)      # calls outside good reads made again
            calls = [x for x in D.plan(a.family) if x["context"] in want]    # the full plan's order
            # the guard's limits are the folder's totals: what every record logged has cost, and its calls
            # with those this start has left to make
            guard = R.SpendGuard(a.max_usd, len(R.logged(out)) + len([x for x in calls if x["id"] not in done]))
            guard.usd, guard.calls = sink.spent, len(R.logged(out))
            R.execute(calls, CLIENT(), sink, guard, done, a.parallel, catalog=CATALOG, link=fc["link"],
                      prepare=D.preparer(sink.records), classify=D.classify)
            print(f"done: the {', '.join(sorted(want))} calls of TR1A for {a.family} in {out}")


if __name__ == "__main__":
    main()
