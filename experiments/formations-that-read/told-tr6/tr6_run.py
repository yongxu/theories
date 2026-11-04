"""The run of TR6 and its reading, frozen with the rule, on freeze 1's harness and freeze 3's endpoint
check (FREEZE-6.md).

    python3 -B tr6_run.py plan                                   # the fixed calls and the estimate, no call
    python3 -B tr6_run.py smoke --family PIN --max-usd 1         # the release's first step for a pin
    python3 -B tr6_run.py run --family PIN --max-usd 20 [--parallel 8]
    python3 -B tr6_run.py verdicts results/<pin folder>          # writes verdicts.json beside calls.jsonl
    python3 -B tr6_run.py mend results/<pin folder> --cause TEXT # FREEZE-1's note on a log cut short, no call

Nothing here runs without Ren's yes: `smoke` and `run` call a model through OpenRouter with his key.
Both refuse to start unless freeze 1's chain and freeze 3's chain check (freeze 3's run.frozen, which
checks freeze 1's first) and the working copy of every file the newest link of this freeze's chain
lists (FROZEN.sha256 here, then any addendum's addenda/FROZEN-k.sha256; the files of freeze 1 and
freeze 3 it imports among them) equals its hash and its commit; `run` also unless the pin's latest
smoke run here passed on those hashes. Freeze 1's run.execute makes every call, with its stops (a
call no retry answers, another model, a moved catalog, FILTERED_RUN filtered answers in a row, a
request whose messages are not the frozen prompt, a failed attempt returned as an answer, the spend
guard), its catalog reads and its log; freeze 3's client wrapper stops it, logging nothing, at a
response another provider or another tier served, and builds every request (one endpoint of the
pin's provider, no fallback, temperature 0 where the pin takes one and a seed fixed by the prompt).
`run` makes the plan in rounds: each round's calls are those tr6_design.derive gives for the answers
of records made between two good catalog reads, less those records' calls; a call whose latest record
is not between good reads is made again, that record kept and never read; the run ends when a round
has nothing to make. A loop's round needs the round before it, so a run takes at least twelve rounds.
`verdicts` reads a folder through freeze 1's verdicts.load, given this freeze's plan (derive on the
folder's own good records), prepare, parser and frozen chain, so every refusal of freeze 1's reading
holds here, and a logged record another provider or another tier served is refused too; then
tr6_rule's verdicts.
The log is freeze 1's, written by this freeze's line writer (open_sink), which writes U+2028, U+2029
and U+0085 as their JSON escapes, so that freeze 1's readers, which split lines at them too, read every
record whole; each record loads as the same values. `run` and `verdicts` refuse, before any call or
reading, a folder whose calls.jsonl or catalog.jsonl does not end in a newline or holds a line that
does not read whole (log_whole): FREEZE-1's note "A log cut short" says what is done then, and `mend`
does it for a last line cut short.
"""

import argparse
import json
import random
import re
import sys
import time
from collections import Counter, defaultdict
from pathlib import Path

import tr6_design as D          # puts freeze 1's told/ and freeze 3's told-tr3/ on the path
import tr6_rule as TR
import tr3_client as TC         # noqa: E402  freeze 3's
import tr3_run as T3            # noqa: E402  freeze 3's chain check
import client as cl             # noqa: E402  freeze 1's
import run as R                 # noqa: E402
import verdicts as VD           # noqa: E402
from conditions import DECLINE  # noqa: E402

HERE = Path(__file__).resolve().parent
TOLD = HERE.relative_to(R.REPO)
# What an addendum to this freeze may change (FREEZE-6.md, section 8): the dry run and its result, and
# the request and response mechanics of the earlier freezes this one imports, where an addendum to
# them changed them: freeze 1's client, freeze 3's client and the endpoint lists it reads. Every other
# file is fixed.
MAY_CHANGE = frozenset({str(TOLD / "tr6_dry_run.py"), str(TOLD / "results/dry-run.json"),
                        str(T3.TOLD / "tr3_client.py"), str(T3.TOLD / "ENDPOINTS.json"), str(R.TOLD / "client.py")})
TOKENS = 300                    # a call's input and output tokens, rounded up, before reasoning (FREEZE-6.md, section 9)
COURSE_TOKENS = 30              # each Saturday of a course arm B shows
FRAME_TOKENS = 10               # each Saturday arm A is shown withheld


LONE = re.compile("[\ud800-\udbff](?![\udc00-\udfff])|(?<![\ud800-\udbff])[\udc00-\udfff]")


def line(rec):
    """A record's line: freeze 1's json.dumps(rec, ensure_ascii=False), with the three characters that
    str.splitlines breaks at and JSON leaves raw written as their escapes, and a surrogate standing
    alone, which UTF-8 cannot encode, as its escape (a response escaped in UTF-16 can hold one, cut
    mid-character at its token limit). json.dumps writes them only inside strings, and every backslash
    it writes is part of a whole escape, so the line loads as rec."""
    s = json.dumps(rec, ensure_ascii=False).replace("\u2028", "\\u2028").replace("\u2029", "\\u2029") \
        .replace("\x85", "\\u0085")
    return LONE.sub(lambda m: "\\u%04x" % ord(m.group()), s)


def open_sink(out):
    """Freeze 1's run.open_sink (the ids logged, what they cost, the catalog's note), with this line
    writer in place of its own: unbuffered, and once a write fails, every later write refused, so that
    nothing is appended after a line cut short. The failed write raises, and freeze 1's execute stops
    every call at a fault, so only the calls already in flight are made after it."""
    first, done = R.open_sink(out)

    def sink(rec):
        if sink.broken:
            raise RuntimeError(f"an earlier write to the log failed ({sink.broken}); nothing more is written")
        data = (line(rec) + "\n").encode("utf-8")
        try:
            k = 0
            while k < len(data):
                k += sink.file.write(data[k:])
        except Exception as e:
            sink.broken = repr(e)
            raise
    sink.file, sink.broken = (Path(out) / "calls.jsonl").open("ab", buffering=0), None
    sink.spent, sink.note = first.spent, first.note
    return sink, done


def log_whole(folder):
    """Refuse a folder whose log does not read whole: a file not ending in a newline, a line that does
    not load (split on newlines alone), or a line holding a character str.splitlines breaks at."""
    for name in ("calls.jsonl", "catalog.jsonl"):
        p = Path(folder) / name
        if not p.exists():
            continue
        try:
            text = p.read_bytes().decode("utf-8")
        except UnicodeDecodeError:  # a write cut inside a character
            raise SystemExit(f"{p}: does not decode as UTF-8; see FREEZE-1.md's note \"A log cut short\" before "
                             "any run or reading")
        if not text:            # freeze 1's open_sink creates both files empty, before any read or call
            continue
        bad = [] if text.endswith("\n") else ["no final newline"]
        for k, ln in enumerate(text.split("\n")[:-1] if text.endswith("\n") else text.split("\n")):
            try:
                json.loads(ln)
            except ValueError:
                bad.append(f"line {k + 1} does not read")
            if any(c in ln for c in "\u2028\u2029\x85"):
                bad.append(f"line {k + 1} holds a line separator")
        if bad:
            raise SystemExit(f"{p}: {', '.join(bad[:3])}; see FREEZE-1.md's note \"A log cut short\" before any "
                             "run or reading")


def mend(folder, cause):
    """FREEZE-1's note "A log cut short": in calls.jsonl and catalog.jsonl, the first line that does not
    read whole, or the last where the file does not end in a newline, and every line after it, are
    moved, byte for byte, to NAME.cut beside it, followed by one line beginning "# " that names the time
    and the cause. With this freeze's line writer that is the last line alone. Where catalog lines move,
    a whole read naming no snapshot is put in their place, timed at the move, later than every read and
    every call: the calls that ended after the last whole read then lack a good closing read, and
    resume makes them again rather than the rerun's first read closing them. A moved call's record is no
    longer logged, so its call is made again. Where a line holds a raw line separator, nothing is
    changed and the folder stays refused."""
    folder = Path(folder)
    kept, cut, recs = {}, {}, {}
    for name in ("calls.jsonl", "catalog.jsonl"):
        p = folder / name
        raw = p.read_bytes() if p.exists() else b""
        lines = raw.split(b"\n")
        ends = lines[-1] == b""
        lines = lines[:-1] if ends else lines
        k, recs[name] = 0, []
        for k, ln in enumerate(lines):
            try:
                s = ln.decode("utf-8")
                rec = json.loads(s)
                assert isinstance(rec, dict) and (ends or k < len(lines) - 1)
            except (ValueError, AssertionError):
                break
            if any(c in s for c in "\u2028\u2029\x85"):
                raise SystemExit(f"{p}: line {k + 1} holds a raw line separator; nothing changed, and the folder "
                                 "stays refused (FREEZE-1.md)")
            recs[name].append(rec)
        else:
            k = len(lines)
        kept[name] = lines[:k]
        if k < len(lines):
            cut[name] = lines[k:]
    if not cut:
        print(f"{folder}: every line reads whole; nothing moved")
        return []
    now = time.time()
    done = [f"{name}: {len(c)} line{'s' if len(c) > 1 else ''} from line {len(kept[name]) + 1} moved to {name}.cut"
            for name, c in cut.items()]
    if "catalog.jsonl" in cut:
        times = [float(c["t"]) for c in recs["catalog.jsonl"]] + [float(r["t1"]) for r in recs["calls.jsonl"]]
        if times and now <= max(times):
            raise SystemExit(f"{folder}: the clock is not later than every read and call; nothing changed")
        family = json.loads((folder / "meta.json").read_text(encoding="utf-8"))["family"]
        kept["catalog.jsonl"].append(line({"t": now, "family": family, "slug": None}).encode("utf-8"))
        done.append(f"catalog.jsonl: a read naming no snapshot put in their place, at t {now}")
    stamp = time.strftime("%Y-%m-%dT%H:%M:%S%z")
    for name, c in cut.items():
        with (folder / (name + ".cut")).open("ab") as fh:
            fh.write(b"".join(ln + b"\n" for ln in c) + f"# cut {stamp}: {cause}\n".encode("utf-8"))
        (folder / name).write_bytes(b"".join(ln + b"\n" for ln in kept[name]))
    log_whole(folder)
    for d in done:
        print(f"{folder}: {d}")
    return done


def moved_lines(folder):
    """The lines FREEZE-1's note moved, per .cut file: the moved records, and the notes beside them (lines
    beginning "# "). A record cut inside a character is shown with the replacement character."""
    out = {}
    for p in sorted(Path(folder).glob("*.jsonl.cut")):
        ls = [ln for ln in p.read_bytes().decode("utf-8", errors="replace").split("\n") if ln]
        out[p.name] = {"lines_moved": [ln for ln in ls if not ln.startswith("# ")],
                       "notes": [ln for ln in ls if ln.startswith("# ")]}
    return out


def frozen(repo=R.REPO, told=TOLD):
    """Freeze 3's chain first (which checks freeze 1's first), so that the files of both taken here are
    taken only as their newest links have them; then this freeze's chain."""
    third = T3.frozen(repo)
    fc = R.frozen_check(repo, told, MAY_CHANGE)
    fc["freeze_1_link"], fc["freeze_3_link"] = third["freeze_1_link"], third["link"]
    return fc


def good_answers(folder, family):
    """The answers of the calls whose latest record was made between two good catalog reads."""
    reads, slug = R.catalog_reads(folder), R.pin(family)["canonical_slug"]
    latest = {}
    for r in R.logged(folder):
        latest[r["id"]] = r
    return {i: (r["answer"] if r["kind"] == "choice" else r["probe"]) for i, r in latest.items()
            if R.bracketed(r, reads, slug)}


def rounds(folder, family, client, sink, guard, parallel=1, catalog=None, link=None, most=40, prepare=None):
    """Make the plan in rounds until a round has nothing to make (at most `most` rounds). First, as
    freeze 1's run does, run.resume's catalog read, logged. prepare is tr6_design.prepared; the dry run
    passes a faulty one to show that the reading refuses its log."""
    client = TC.OneEndpoint(client)
    if catalog is not None:
        R.resume(folder, family, sink, catalog)
    for k in range(most):
        answers = good_answers(folder, family)
        todo = [x for x in D.derive(family, answers) if x["id"] not in answers]
        if not todo:
            return k
        random.Random(f"{D.SEED}|order|{family}|{len(answers)}").shuffle(todo)
        R.execute(todo, client, sink, guard, (), parallel, catalog=catalog, link=link, prepare=prepare or D.prepared,
                  classify=D.classify)
    raise RuntimeError(f"the plan was not complete after {most} rounds")


def load(folder, allow_dry=False, check=None):
    """freeze 1's verdicts.load with this freeze's plan, prepare, parser and chain."""
    folder = Path(folder)
    log_whole(folder)
    meta, recs = VD.load(folder, allow_dry, plan=lambda test, fam: D.derive(fam, good_answers(folder, fam)),
                         prepare=lambda x: D.prepared(x), classify=D.classify, frozen=check or frozen)
    other = [r["id"] for r in R.logged(folder) if not TC.serving_ok(meta["family"], r.get("response"))]
    if other:
        raise SystemExit(f"records another provider or another tier served: {other[:3]}")
    plan = {x["id"]: x for x in D.derive(meta["family"], good_answers(folder, meta["family"]))}
    text = [r["id"] for r in R.logged(folder) if r.get("prompt") != D.prepared(plan[r["id"]])[0]["user"]]
    if text:            # freeze 1's reading compares a logged prompt's hash with its rebuild's; this, its text
        raise SystemExit(f"records whose logged prompt is not the one their call rebuilds: {text[:3]}")
    return meta, recs


def units(meta, recs):
    """TR6's verdicts from the records verdicts.load reads."""
    family = meta["family"]
    ans = {r["id"]: (r["answer"] if r["kind"] == "choice" else r["probe"]) for r in recs}
    _, per = D.readings(family, lambda x: ans.get(x["id"]))
    # a probe not read (never logged, logged outside good reads, or in a context partly logged, which
    # verdicts.load drops) is not an unreadable one: the reading is then partial; a loop call not read
    # leaves its seed open, and the rule reads V2 as partial
    out = {"framings": {f: TR.framing_verdict(f, *per[f], probes_not_read=sum(
        x["id"] not in ans for x in D.probe_calls(family, f).values())) for f in TR.FRAMINGS}}
    pilot = defaultdict(list)
    for r in recs:
        if r["arm"] == "pilot":
            pilot[r["which"]].append(r["answer"])
    flips = {"/".join(map(str, D.PILOT[w])): sum(1 for a in xs if a != Counter(xs).most_common(1)[0][0])
             for w, xs in sorted(pilot.items())}
    n = sum(len(xs) for xs in pilot.values())
    out["pilot"] = {"calls": n, "flips": flips,
                    "upper_95_on_the_flip_rate": T3.upper95(sum(flips.values()), n) if n else None,
                    "complete": n == len(D.PILOT) * D.PILOT_REPS}
    nof = defaultdict(lambda: defaultdict(Counter))
    untold = defaultdict(Counter)
    for r in recs:
        if r["arm"] == "noforecast":
            nof[r["framing"]][r["variant"]][r["answer"]] += 1
        if r["arm"] == "untold":
            untold[r["forecast"]][r["answer"]] += 1
    out["no_forecast"] = {f: {f"v{v}": dict(c) for v, c in sorted(vs.items())} for f, vs in sorted(nof.items())}
    out["payoffs_not_told"] = {"share_taking_part": {str(p): round(c[TR.TAKE] / sum(c.values()), 3)
                                                     for p, c in sorted(untold.items())},
                               "answers": {str(p): dict(c) for p, c in sorted(untold.items())}}
    by_arm = defaultdict(Counter)
    for r in recs:
        if r["kind"] == "choice" and r["answer"] not in (TR.TAKE, TR.STAY):
            by_arm[r["arm"]][r["answer"]] += 1
    out["non_choices_by_arm"] = {a: dict(c) for a, c in sorted(by_arm.items())}
    return out


def verdicts(folder):
    meta, recs = load(folder)
    v = units(meta, recs)
    role = R.pin(meta["family"])["role"]
    res = {"test": D.TEST, "family": meta["family"], "pin_role": role, **v,
           "served_by_provider": dict(Counter(str(TC.served_provider(r["response"])) for r in recs)),
           "served_at_tier": dict(Counter(str(TC.served_tier(r["response"])) for r in recs)),
           "system_fingerprints": dict(Counter(str((r["response"] or {}).get("system_fingerprint")) for r in recs)),
           "no_verdict_partly_logged": meta["partial_contexts"], "calls_made_again": meta["made_again"],
           "lines_moved_by_freeze_1s_note": moved_lines(folder),
           "catalog_reads": [{"t": t_, "slug": s} for t_, s in R.catalog_reads(folder)],
           "read_under": meta["read_under"]}
    (Path(folder) / "verdicts.json").write_text(json.dumps(res, indent=1) + "\n", encoding="utf-8")
    for f, u in v["framings"].items():
        print(f"TR6 {meta['family']} [{role}] {f}: {u['outcome']}"
              + (f"; V1 {u['shape']}; reading {u['reading']}; V2 {u['v2']['outcome']} (p {u['v2']['p']})"
                 if "v2" in u else ""))
    print(f"TR6 {meta['family']} [{role}] pilot: {sum(v['pilot']['flips'].values())} flips in {v['pilot']['calls']}")


def smoke_report(folder, stopped=None):
    """The smoke run's report and its stop rule: every call answered by the pin's model through the
    chosen endpoint's provider at the standard tier, while the catalog names the frozen snapshot, and
    read (a choice an option or a decline, the probe its two fields). Reported: served models,
    providers and tiers, the system fingerprints, the catalog's slugs, declines, the repeated request's
    answers, tokens and cost per call, and the projection at the plan's bound. Exit 0 to go on, 2 to
    stop before any scored call."""
    folder = Path(folder)
    meta = json.loads((folder / "meta.json").read_text())
    recs = R.logged(folder)
    fam, slug = meta["family"], R.pin(meta["family"])["canonical_slug"]
    bad = [r["id"] for r in recs if (r["kind"] == "choice" and r["answer"] not in TR.READABLE)
           or (r["kind"] == "probe" and r["probe"] is None) or not R.served_ok(fam, r["response"])
           or not TC.serving_ok(fam, r["response"]) or r.get("catalog") != slug]
    use = [((r["response"] or {}).get("usage") or {}) for r in recs]
    usd = [float(u.get("cost") or 0) for u in use]
    per = sum(usd) / len(usd) if usd else None
    most = len(D.fixed_calls(fam)) + D.reached_most()
    repeats = [r["answer"] for r in recs if r["context"] in ("smoke/0", "smoke/repeat")]
    report = {"family": fam, "calls": len(recs), "planned": meta["calls"], "stopped": stopped,
              "unread": bad, "served_by": dict(Counter(str(R.served_model(r["response"])) for r in recs)),
              "served_by_provider": dict(Counter(str(TC.served_provider(r["response"])) for r in recs)),
              "provider_expected": TC.PROVIDER[fam],
              "served_at_tier": dict(Counter(str(TC.served_tier(r["response"])) for r in recs)),
              "system_fingerprints": dict(Counter(str((r["response"] or {}).get("system_fingerprint")) for r in recs)),
              "catalog_named": dict(Counter(str(r.get("catalog")) for r in recs)),
              "catalog_reads": [s for _, s in R.catalog_reads(folder)],
              "declines": sum(1 for r in recs if r["answer"] == DECLINE),
              "repeated_request": {"answers": repeats, "alike": len(set(repeats)) <= 1},
              "tokens_per_call": [(u.get("prompt_tokens"), u.get("completion_tokens")) for u in use],
              "usd_per_call": per, "projected_usd": None if per is None else round(per * most, 2),
              "projection_note": f"the plan's bound, {most} calls, at the smoke run's mean cost a call"}
    report["go_on"] = stopped is None and not bad and len(recs) == meta["calls"]
    (folder / "smoke-report.json").write_text(json.dumps(report, indent=1) + "\n")
    print(json.dumps(report, indent=1))
    return 0 if report["go_on"] else 2


def estimate():
    """The plan's calls and tokens before reasoning: the fixed calls, then at most every loop."""
    fixed, most = len(D.fixed_calls(R.PINS["pins"][0]["id"])), D.reached_most()
    course = len(TR.FRAMINGS) * 2 * TR.VARIANTS * TR.N * sum(range(TR.ROUNDS)) * (COURSE_TOKENS + FRAME_TOKENS)
    planned = fixed + len(TR.FRAMINGS) * (TR.VARIANTS * TR.ROUNDS * TR.N * len(TR.ARMS) + len(TR.ARMS) * TR.RIGHT_ROUNDS * TR.N)
    return {"fixed": fixed, "planned_without_a_second_start": planned, "most": fixed + most,
            "tokens_most": (fixed + most) * TOKENS + course}


def main(argv=None):
    ap = argparse.ArgumentParser()
    sub = ap.add_subparsers(dest="cmd", required=True)
    sub.add_parser("plan")
    sm = sub.add_parser("smoke")
    sm.add_argument("--family", required=True)
    sm.add_argument("--max-usd", type=float, required=True)
    rn = sub.add_parser("run")
    rn.add_argument("--family", required=True)
    rn.add_argument("--max-usd", type=float, required=True)
    rn.add_argument("--parallel", type=int, default=1)
    vd = sub.add_parser("verdicts")
    vd.add_argument("folder")
    md = sub.add_parser("mend")
    md.add_argument("folder")
    md.add_argument("--cause", required=True)
    a = ap.parse_args(argv)
    if a.cmd == "plan":
        e = estimate()
        for p_ in R.PINS["pins"]:
            print(f"{p_['id']:32s} tr6 {e['fixed']} fixed calls, {e['planned_without_a_second_start']} with every "
                  f"loop but a second start, at most {e['most']} in all, at most about {e['tokens_most'] / 1e6:.2f}M "
                  f"tokens before reasoning (the smoke run measures it)")
        return
    if a.cmd == "verdicts":
        verdicts(a.folder)
        return
    if a.cmd == "mend":
        mend(a.folder, a.cause)
        return
    fc = frozen()
    if a.cmd == "smoke":
        R.pin(a.family)
        calls = D.smoke_calls(a.family)
        out = HERE / "smoke" / (a.family.replace("/", "__") + "-" + time.strftime("%Y%m%dT%H%M%S"))
        out.mkdir(parents=True)
        (out / "meta.json").write_text(json.dumps({"kind": "smoke", "test": D.TEST, "family": a.family,
                                                   "seed": D.SEED, "calls": len(calls), "link": fc["link"],
                                                   "hashes": fc["hashes"], "freeze_commit": fc["freeze_commit"]},
                                                  indent=1) + "\n")
        sink, done = open_sink(out)
        stopped = None
        try:
            R.execute(calls, cl.OpenRouterClient(), sink, R.SpendGuard(a.max_usd, len(calls)), done, smoke=True, catalog=R.catalog_slug, link=fc["link"], prepare=D.prepared, classify=D.classify)
        except RuntimeError as e:
            stopped = str(e)
            print(f"the smoke run stopped: {e}")
        sys.exit(smoke_report(out, stopped))
    if a.cmd == "run":
        smoke = R.smoke_passed(a.family, fc["hashes"], root=HERE)
        meta = {"kind": "scored", "test": D.TEST, "family": a.family, "seed": D.SEED,
                "freeze_commit": fc["freeze_commit"], "head": fc["head"], "pin": R.pin(a.family), "smoke": smoke,
                "links": {fc["link"]: fc["hashes"]}, "link_commits": {fc["link"]: fc["commits"][fc["link"]]}}
        out = HERE / "results" / a.family.replace("/", "__")
        out.mkdir(parents=True, exist_ok=True)
        mp = out / "meta.json"
        keys = ("kind", "test", "family", "seed")
        if mp.exists():
            old = json.loads(mp.read_text())
            if {k: old.get(k) for k in keys} != {k: meta.get(k) for k in keys} \
                    or not R.links_ok(old.get("links"), fc["chain"]):
                raise SystemExit("this folder holds another run's calls; refusing to mix them")
            if fc["link"] not in old["links"]:
                old["links"][fc["link"]] = fc["hashes"]
                old.setdefault("link_commits", {})[fc["link"]] = fc["commits"][fc["link"]]
                old.setdefault("resumed", []).append({"link": fc["link"], "head": fc["head"], "smoke": smoke,
                                                      "t": round(time.time(), 3)})
                mp.write_text(json.dumps(old, indent=1) + "\n")
        else:
            mp.write_text(json.dumps(meta, indent=1) + "\n")
        log_whole(out)
        sink, _ = open_sink(out)
        guard = R.SpendGuard(a.max_usd, len(R.logged(out)) + 2 * (len(D.fixed_calls(a.family)) + D.reached_most()))
        guard.usd, guard.calls = sink.spent, len(R.logged(out))
        k = rounds(out, a.family, cl.OpenRouterClient(), sink, guard, a.parallel, catalog=R.catalog_slug,
                   link=fc["link"])
        print(f"done: TR6 for {a.family} in {out}, {k} rounds")


if __name__ == "__main__":
    main()
