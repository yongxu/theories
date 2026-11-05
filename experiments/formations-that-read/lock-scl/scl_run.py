"""SCL's run and its reading, frozen with its rule, on freeze 1's harness and FREEZE-5's folder handling
(FREEZE-12.md, sections 6 to 8).

    python3 -B scl_run.py plan                                    # the calls and the usage estimate, no call
    python3 -B scl_run.py smoke --family PIN --max-usd 1          # the release's first step (section 8)
    python3 -B scl_run.py run --family PIN --max-usd USD          # every condition, at --parallel 1
    python3 -B scl_run.py run --family PIN --conditions C --max-usd USD [--parallel 8]
    python3 -B scl_run.py status --family PIN                     # what is logged and read whole, no call, no readout
    python3 -B scl_run.py verdicts --family PIN                   # the readout, once, from a whole run
    python3 -B scl_run.py mend --family PIN [--cause CAUSE]       # a log cut short (FREEZE-5's mend), no call

USD from the smoke run's projection. Nothing here runs without Ren's yes: `smoke` and `run` call a model through
OpenRouter with his key. The calls are made, logged and checked by freeze 1's code (told/run.py's execute, resume,
catalog read, spend guard and served check; told/client.py's client), imported unchanged; the parser is FREEZE-5's,
as FREEZE-10 reads by it; the folder handling is FREEZE-5's (told-tr1/tr1_run.py: the line writer, the whole meta,
a log cut short and `mend`), imported unchanged. This module gives them SCL's plan and call builder (scl_design),
its folder (results/scl/<pin>/) and its lock.

The rules (sections 6 and 8): one command of a pin at a time (results/scl/<pin>.lock); the meta written whole before
any log; a folder whose logs do not read whole refused until `mend`; a course's calls carry its earlier rounds
(scl_design.rounds), each reading, for every earlier round of its course, that round's latest record logged before
it, so the courses run at parallel 1 in the plan's order and the reading rebuilds each record's prompt from the
records logged before it; `--max-usd` the folder's total over every start; a run needs the pin's latest smoke run on
its own frozen files passed and the readability rule letting it start; the readout is written once, from a run
read whole, and once it is there no further call of the pin is made.
"""

import argparse
import contextlib
import fcntl
import json
import sys
import time
from collections import Counter
from pathlib import Path

import scl_design as D            # first: puts FREEZE-10's, FREEZE-5's and freeze 1's files on the path
import scl_rule as RU
import client as cl               # freeze 1's (told/client.py)
import run as R                   # freeze 1's (told/run.py)
import verdicts as VD             # freeze 1's (told/verdicts.py)

T1 = D.T1A.T1                     # FREEZE-5's tr1_run: the folder handling, imported unchanged
D.own_files()

read_json, write_whole, open_sink = T1.read_json, T1.write_whole, T1.open_sink
refuse_cut, mend, moved_lines, cause, smoke_records = T1.refuse_cut, T1.mend, T1.moved_lines, T1.cause, T1.smoke_records
assert T1.D.classify is D.classify, "the smoke run's cause reads by the parser SCL reads by"

HERE = Path(__file__).resolve().parent
ROOT = HERE                     # where smoke/ and results/ are; the dry run's command checks set another
CLIENT = cl.OpenRouterClient    # the dry run's command checks set stand-ins for these three
CATALOG = R.catalog_slug
frozen = D.frozen
CLIENT_FILE = str(R.TOLD / "client.py")
READOUT = "verdicts.json"


def scored(family, root=None):
    return Path(root or ROOT) / "results" / D.TEST / family.replace("/", "__")


def smoke_folders(family, root=None):
    return sorted((Path(root or ROOT) / "smoke").glob(family.replace("/", "__") + "-*"))


@contextlib.contextmanager
def pin_lock(family, root=None):
    """One command of a pin at a time: an exclusive lock on results/scl/<pin>.lock, refused while another command
    holds it. The system drops it when its process ends, killed or not."""
    p = scored(family, root).with_name(family.replace("/", "__") + ".lock")
    p.parent.mkdir(parents=True, exist_ok=True)
    with p.open("a") as fh:
        try:
            fcntl.flock(fh.fileno(), fcntl.LOCK_EX | fcntl.LOCK_NB)
        except BlockingIOError:
            raise SystemExit(f"another command of {family} is running, holding {p.name}: one command of a pin at a "
                             "time (FREEZE-12.md, section 8); nothing was done") from None
        except OSError as e:
            raise SystemExit(f"{p.name} could not be locked ({e}) (FREEZE-12.md, section 8); nothing was done") from None
        yield p


# ------------------------------------------------------------------------------------------------
# The smoke run, the readability rule and what they release (section 8)

def smoke_stops(folder, stopped):
    """A smoke run's stops of the run, each lifted by a later smoke run that passes: the run's own stop, a call not
    made, a response naming another model or made under another catalog slug, a log line that does not read, and a
    call the provider rejected or filtered or the token limit cut. The pin's own unreadable answers stop nothing
    here: they enter the readability rule."""
    folder = Path(folder)
    meta = read_json(folder / "meta.json") or {}
    family = meta["family"]
    slug = R.pin(family)["canonical_slug"]
    recs, cut = smoke_records(folder)
    planned = {x["id"] for x in D.plan(family, smoke=True)}
    other = [r["id"] for r in recs if not R.served_ok(family, r["response"]) or r.get("catalog") != slug]
    provider = [r["id"] for r in recs if r["id"] not in other and cause(r) in ("provider", "limit")]
    missing = sorted(planned - {r["id"] for r in recs})
    passed = stopped is None and not other and not cut and not provider and not missing
    return {"stopped": stopped, "another model or snapshot": other, "log lines that do not read": cut,
            "provider or limit": provider, "not made": missing[:5], "passed": passed}


def calls_counted(family, hashes, root=None):
    """The readability rule's calls: every SCL call of the pin made under freeze 1's client in force (its hash the
    newest link's), answered by the pin while the catalog named its snapshot, in every smoke run and the scored
    log; and how many of them name nothing the parser reads."""
    slug = R.pin(family)["canonical_slug"]
    client = hashes.get(CLIENT_FILE)
    n = bad = 0
    recs = []
    for d in smoke_folders(family, root):
        meta = read_json(d / "meta.json") or {}
        if (meta.get("hashes") or {}).get(CLIENT_FILE) == client:
            recs += smoke_records(d)[0]
    out = scored(family, root)
    meta = read_json(out / "meta.json") or {}
    links = meta.get("links") or {}
    recs += [r for r in R.logged(out) if (links.get(r.get("link")) or {}).get(CLIENT_FILE) == client]
    for r in recs:
        if not R.served_ok(family, r["response"]) or r.get("catalog") != slug:
            continue
        n += 1
        bad += RU.unreadable(D.classify(r["response"], r["kind"], r["letters"])[0])
    return bad, n


def readability(family, hashes, root=None):
    bad, n = calls_counted(family, hashes, root)
    return RU.readability(bad, n)


def smoke_runs(family, root=None):
    out = []
    for d in smoke_folders(family, root):
        meta, rep = read_json(d / "meta.json"), read_json(d / "smoke-report.json")
        if meta is None:
            out.append({"folder": d.name, "hashes": None, "passed": False})
            continue
        stopped = rep.get("stopped") if isinstance(rep, dict) else "no report"
        out.append({"folder": d.name, "hashes": meta.get("hashes"), "passed": smoke_stops(d, stopped)["passed"]})
    return out


def smoke_report(folder, stopped=None, root=None):
    """The smoke run's report: whether it passed, its stops, the readability rule at its end, the served models and
    the catalog's slugs, tokens and cost per call and the full plan's projection. Nothing of the answers is
    reported beyond whether each was read. Exit 0 where it passed and the rule lets the run start, else 2."""
    folder = Path(folder)
    recs, _ = smoke_records(folder)
    meta = read_json(folder / "meta.json")
    s = smoke_stops(folder, stopped)
    rd = readability(meta["family"], meta["hashes"], root)
    use = [((r["response"] or {}).get("usage") or {}) for r in recs]
    chars = sum(len(r["prompt"]) for r in recs)
    tin = sum(u.get("prompt_tokens") or 0 for u in use)
    tout = sum(u.get("completion_tokens") or 0 for u in use)
    report = {"family": meta["family"], "calls": len(recs), "planned": meta["calls"], "stops": s,
              "readability": rd, "go_on": s["passed"] and rd["starts"],
              "unreadable answers (the pin's own)": sum(RU.unreadable(r["answer"]) for r in recs),
              "served_by": dict(Counter(str(R.served_model(r["response"])) for r in recs)),
              "catalog": sorted({str(r.get("catalog")) for r in recs}),
              "per_call": {"n": len(recs), "prompt_chars": chars / len(recs) if recs else None,
                           "in": tin / len(recs) if recs else None, "out": tout / len(recs) if recs else None,
                           "usd": sum(float(u.get("cost") or 0) for u in use) / len(recs) if recs else None},
              "projected_full_design": projection(meta["family"], chars, tin, tout, len(recs))}
    write_whole(folder / "smoke-report.json", json.dumps(report, indent=1) + "\n")
    print(json.dumps(report, indent=1))
    return 0 if report["go_on"] else 2


def plan_chars(family):
    """The characters of every planned call's text, a course's with stand-in rounds (each an answer that could not
    be read, whose line is the longest a round shows), by condition."""
    recs, out = [], Counter()
    for x in D.plan(family):
        prompt = D.build(x, recs)
        out[x["condition"]] += len(prompt["user"])
        if x.get("what") == "act":
            recs.append({"id": x["id"], "answer": D.INVALID})
    return dict(out)


def projection(family, chars, tin, tout, n):
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


def estimate(family):
    """The design's estimate, before any call: tokens in from the text's characters at four a token, out from 50 to
    1,000 a call (the answer and low reasoning), at the pin's listed prices."""
    chars = plan_chars(family)
    calls = Counter(x["condition"] for x in D.plan(family))
    pr = R.pin(family)["pricing"]
    t_in = sum(chars.values()) / 4
    lo, hi = (t_in * float(pr["prompt"]) + sum(calls.values()) * out * float(pr["completion"]) for out in (50, 1000))
    return {"calls": dict(calls), "tokens_in": round(t_in), "usd_low": round(lo, 2), "usd_high": round(hi, 2),
            "tokens_in_by_condition": {c: round(v / 4) for c, v in chars.items()}}


def read_whole(family, cond, root=None):
    out = scored(family, root)
    reads, slug = R.catalog_reads(out), R.pin(family)["canonical_slug"]
    latest = {r["id"]: r for r in R.logged(out)}
    return all(i in latest and R.bracketed(latest[i], reads, slug) for i in (x["id"] for x in D.plan(family, (cond,))))


def release(family, fc, want, root=None):
    """Refuses a run, before any call, that its smoke runs and the readability rule do not release, that a readout
    forbids, or that could gain nothing."""
    out = scored(family, root)
    if (out / READOUT).exists():
        raise SystemExit(f"{family}'s readout ({READOUT}) is written: no further call of the pin is made (FREEZE-12.md, "
                         "section 7); no call was made")
    runs = smoke_runs(family, root)
    if not runs:
        raise SystemExit(f"no smoke run for {family}: run `smoke` first; no call was made")
    last = runs[-1]
    if last["hashes"] != fc["hashes"]:
        raise SystemExit(f"{family}'s latest smoke run ({last['folder']}) was made on other frozen files, or made no call: "
                         "a run needs a smoke run on its own frozen files (FREEZE-12.md, section 8); no call was made")
    if not last["passed"]:
        raise SystemExit(f"{family}'s latest smoke run ({last['folder']}) stopped, a stop of the run, which a later smoke "
                         "run that passes lifts (FREEZE-12.md, section 8); no call was made")
    rd = readability(family, fc["hashes"], root)
    if not rd["starts"]:
        raise SystemExit(f"{family}'s answers cannot be read often enough: {rd} (the readability rule, FREEZE-12.md, "
                         "section 8); no call was made")
    left = [c for c in sorted(want) if not read_whole(family, c, root)]
    if not left:
        raise SystemExit(f"{family}'s {', '.join(sorted(want))} read whole: no call is left to make (FREEZE-12.md, "
                         "section 8); no call was made")
    return last["folder"], rd


# ------------------------------------------------------------------------------------------------
# The reading (section 7)

def load(folder, allow_dry=False, check=None):
    """freeze 1's verdicts.load with SCL's plan, parser and frozen check, and a prepare that rebuilds each record's
    call from the records logged before it; then each logged prompt's text against its rebuild."""
    folder = Path(folder)
    refuse_cut(folder, "nothing was read")
    recs = R.logged(folder)
    pos = iter(range(len(recs)))

    def prepare(x):
        k = next(pos)
        assert recs[k]["id"] == x["id"], "freeze 1's reading takes the records in their logged order"
        try:
            return D.prepared(x, recs[:k])
        except RuntimeError as e:
            raise SystemExit(f"{e}: a course's record logged before an earlier round of its course, which no run in "
                             "the plan's order leaves (FREEZE-12.md, section 6); nothing was read") from None
    meta, good = VD.load(folder, allow_dry, plan=lambda test, fam: D.plan(fam), prepare=prepare,
                         classify=D.classify, frozen=check or frozen)
    plan = {x["id"]: x for x in D.plan(meta["family"])}
    text = [r["id"] for k, r in enumerate(recs) if r.get("prompt") != D.build(plan[r["id"]], recs[:k])["user"]]
    if text:
        raise SystemExit(f"records whose logged prompt is not the one their call rebuilds: {text[:3]}")
    return meta, good, recs


def rounds_apart(family, good, recs):
    """The course records read whose rounds show, for an earlier round, an answer other than that round's record
    read: none where each course carried the answers the reading reads (section 6). Reported, never refused."""
    read = {r["id"]: r for r in good}
    last = {r["id"]: k for k, r in enumerate(recs)}
    out = []
    for k, r in enumerate(recs):
        if r["condition"] == "C" or r["id"] not in read or last[r["id"]] != k:
            continue
        for s, a in D.rounds(r, recs[:k]).items():
            i = D.call_id(family, r["condition"], r["world"], r["order"], r["rep"], "act", s)
            if i not in read or read[i]["answer"] != a:
                out.append(r["id"])
                break
    return out


def verdicts(folder, check=None, allow_dry=False):
    """The pin's readout (section 7), written once: refused where one is there, and where any condition is not read
    whole (a reading reads a whole run only)."""
    folder = Path(folder)
    if (folder / READOUT).exists():
        raise SystemExit(f"{folder.name}: its readout ({READOUT}) is written, once (FREEZE-12.md, section 7); nothing "
                         "was read")
    meta, good, recs = load(folder, allow_dry, check)
    family = meta["family"]
    role = R.pin(family)["role"]
    by = {r["id"]: r for r in good}
    part = set(meta["partial_contexts"])
    whole = {c: c not in part and all(x["id"] in by for x in D.plan(family, (c,))) for c in D.CONDITIONS}
    if not all(whole.values()):
        raise SystemExit(f"{folder.name}: not read whole: {', '.join(c for c in D.CONDITIONS if not whole[c])}; the "
                         "reading reads a whole run only (FREEZE-12.md, section 7); `status` shows what is left; nothing "
                         "was written")
    courses, c_ans = RU.courses_of(good, recs)      # the lock read from the rounds each record showed
    res = RU.reading(courses, c_ans, family, role)
    out = {"test": D.TEST, "family": family, "pin_role": role, "decides": role == "decides", "reading": res,
           "expectation (AI, section 13)": RU.expectations(res),
           "rounds_not_the_answers_read": rounds_apart(family, good, recs),
           "served_by": dict(Counter(str(R.served_model(r["response"])) for r in good)),
           "calls_made_again": meta["made_again"], "starts": meta.get("starts", []),
           "lines_moved_by_mend": moved_lines(folder),
           "catalog_reads": [{"t": t_, "slug": s} for t_, s in R.catalog_reads(folder)],
           "read_under": meta["read_under"]}
    write_whole(folder / READOUT, json.dumps(out, indent=1) + "\n")
    print(f"SCL {family} [{role}]: " + "; ".join(f"{v} {s}" for v, s in res["summary"].items()))
    return out


def status(family, root=None):
    out = scored(family, root)
    logged = R.logged(out)
    return {"family": family, "logged": len(logged), "planned": len(D.plan(family)),
            "read whole": {c: read_whole(family, c, root) for c in D.CONDITIONS},
            "readout": (out / READOUT).exists(), "smoke runs": smoke_runs(family, root)}


# ------------------------------------------------------------------------------------------------

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
    for name in ("verdicts", "status"):
        sub.add_parser(name).add_argument("--family", required=True)
    mn = sub.add_parser("mend")
    mn.add_argument("--family", required=True)
    mn.add_argument("--cause", default=None)
    a = ap.parse_args(argv)
    if a.cmd == "plan":
        for p_ in R.PINS["pins"]:
            e = estimate(p_["id"])
            print(f"{p_['id']:32s} {sum(e['calls'].values())} calls ({', '.join(f'{c} {k}' for c, k in e['calls'].items())}), "
                  f"about {e['tokens_in'] / 1e6:.2f}M tokens in, ${e['usd_low']} to ${e['usd_high']} at the listed prices")
        return
    R.pin(a.family)        # a family not among freeze 1's pins is refused here (N5 needs a freeze of its own)
    if a.cmd == "status":
        print(json.dumps(status(a.family), indent=1))
        return
    if a.cmd == "verdicts":
        with pin_lock(a.family):
            verdicts(scored(a.family))
        return
    if a.cmd == "mend":
        with pin_lock(a.family):
            frozen()
            got = mend(scored(a.family), a.family, a.cause)
            print(f"moved, per log, a line of so many bytes: {got} (FREEZE-12.md, section 8); start `run` again")
        return
    if a.cmd == "smoke":
        with pin_lock(a.family):
            fc = frozen()
            refuse_cut(scored(a.family))
            if (scored(a.family) / READOUT).exists():
                raise SystemExit(f"{a.family}'s readout is written: no further call of the pin is made; no call was made")
            runs = smoke_runs(a.family)
            if runs and runs[-1]["hashes"] == fc["hashes"] and runs[-1]["passed"] \
                    and readability(a.family, fc["hashes"])["starts"]:
                raise SystemExit(f"no smoke run of {a.family} is needed: its latest, on these frozen files, passed and the "
                                 "readability rule lets the run start, so another could release nothing (FREEZE-12.md, "
                                 "section 8); no call was made")
            calls = D.plan(a.family, smoke=True)
            out = Path(ROOT) / "smoke" / (a.family.replace("/", "__") + "-" + time.strftime("%Y%m%dT%H%M%SZ", time.gmtime()))
            try:
                out.mkdir(parents=True)
            except FileExistsError:
                raise SystemExit(f"a smoke run of {a.family} began this second ({out.name}); no call was made") from None
            write_whole(out / "meta.json", json.dumps({"kind": "smoke", "test": D.TEST, "family": a.family, "seed": D.SEED,
                                                       "calls": len(calls), "link": fc["link"], "hashes": fc["hashes"],
                                                       "freeze_commit": fc["freeze_commit"]}, indent=1) + "\n")
            sink, done = open_sink(out)
            stopped = None
            try:
                R.execute(calls, CLIENT(), sink, R.SpendGuard(a.max_usd, len(calls)), done, smoke=True, catalog=CATALOG,
                          link=fc["link"], prepare=D.preparer(sink.records), classify=D.classify)
            except RuntimeError as e:
                stopped = str(e)
                print(f"the smoke run stopped: {e}")
            code = smoke_report(out, stopped)
        sys.exit(code)
    if a.cmd == "run":
        with pin_lock(a.family):
            fc = frozen()
            want = set(D.CONDITIONS) if a.conditions == "all" else set(a.conditions.split(","))
            if not want or not want <= set(D.CONDITIONS):
                raise SystemExit(f"unknown condition in {a.conditions}; known: {', '.join(D.CONDITIONS)}; no call was made")
            if want & set(D.COURSE_ARMS) and a.parallel != 1:
                raise SystemExit("a course's calls carry its earlier rounds, so the arms run at --parallel 1 "
                                 "(FREEZE-12.md, section 6); no call was made")
            if a.parallel < 1:
                raise SystemExit("--parallel is at least 1; no call was made")
            out = scored(a.family)
            refuse_cut(out)
            smoke, rd = release(a.family, fc, want)
            start = {"t": time.time(), "link": fc["link"], "head": fc["head"], "conditions": sorted(want),
                     "parallel": a.parallel, "smoke": smoke, "readability": rd}
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
                if fc["link"] not in old["links"]:
                    old["links"][fc["link"]] = fc["hashes"]
                    old.setdefault("link_commits", {})[fc["link"]] = fc["commits"][fc["link"]]
                old.setdefault("starts", []).append(start)
                write_whole(mp, json.dumps(old, indent=1) + "\n")
            else:
                write_whole(mp, json.dumps(meta, indent=1) + "\n")
            sink, _ = open_sink(out)
            done = R.resume(out, a.family, sink, CATALOG)
            calls = [x for x in D.plan(a.family) if x["context"] in want]
            guard = R.SpendGuard(a.max_usd, len(R.logged(out)) + len([x for x in calls if x["id"] not in done]))
            guard.usd, guard.calls = sink.spent, len(R.logged(out))
            R.execute(calls, CLIENT(), sink, guard, done, a.parallel, catalog=CATALOG, link=fc["link"],
                      prepare=D.preparer(sink.records), classify=D.classify)
            print(f"done: the {', '.join(sorted(want))} calls of SCL for {a.family} in {out}")


if __name__ == "__main__":
    main()
