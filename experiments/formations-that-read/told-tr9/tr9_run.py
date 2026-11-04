"""The run of TR9 and its reading, frozen with the rule, on freeze 1's harness (FREEZE-8.md).

    python3 -B tr9_run.py plan                                   # the calls and the estimate, no call
    python3 -B tr9_run.py smoke --family PIN --max-usd 1         # the release's first step for a pin
    python3 -B tr9_run.py run --family PIN --contexts abstract/compute --max-usd 8 [--parallel 8]
    python3 -B tr9_run.py run --family PIN --contexts all --max-usd 20 [--parallel 8]
    python3 -B tr9_run.py verdicts results/<pin folder>          # writes verdicts.json beside calls.jsonl
    python3 -B tr9_run.py mend results/<pin folder> --cause TEXT # FREEZE-1's note on a log cut short, no call

Nothing here runs without Ren's yes: `smoke` and `run` call a model through OpenRouter with his key.
Both refuse to start unless freeze 1's chain checks (run.frozen_check on told/) and the working copy
of every file the newest link of this freeze's chain lists (FROZEN.sha256 here, then any addendum's
addenda/FROZEN-k.sha256; the files of freeze 1 it imports among them) equals its hash and its commit;
`run` also unless the pin's latest smoke run here passed on those hashes, and unless TR8's premise
holds for every context asked: TR8's abstract unit of the same presentation, for the same pin, read
by freeze 1's reading from freeze 1's folder (told/results/tr8/<pin>) and supported. `run` writes
only into results/<pin>/, one folder per pin whatever contexts a run makes, in the plan's one order
(so a first round is the start of the full run); `smoke` only into smoke/. Freeze 1's run.resume and
run.execute make every call, with their stops (a call no retry answers, another model, a moved
catalog, FILTERED_RUN filtered answers in a row, a request whose messages are not the frozen prompt,
a failed attempt returned as an answer, the spend guard), their catalog reads and their log, each
call built by tr9_design.prepared and read by tr9_design.classify. Requests are freeze 1's: its
routing and the pin's default sampling, as TR8's, whose bridge is TR9's premise; the provider and the
tier each response names are reported, apart, and decide nothing.
`verdicts` reads a folder through freeze 1's verdicts.load, given this freeze's plan, prepare, parser
and frozen chain, so every refusal of freeze 1's reading holds here, and a logged prompt whose text is
not its rebuild's is refused too; TR8's premise is read again from TR8's folder as it then stands,
the sha-256 of its two logs recorded at each start and at the reading; then tr9_rule's verdicts.
The log is freeze 1's, written by TR6's line writer (open_sink, copied here from told-tr6/tr6_run.py
with log_whole, mend, record_start, _whole and moved_lines, so that this freeze's chain takes freeze 1
alone): U+2028, U+2029, U+0085 and a lone surrogate written as their JSON escapes, so that freeze 1's
readers, which split lines at them too, read every record whole. `run` and `verdicts` refuse, before
any call or reading, a folder whose calls.jsonl or catalog.jsonl does not end in a newline or holds a
line that does not read whole (log_whole), and so does the reading of TR8's folder: FREEZE-1's note "A
log cut short" says what is done then, and `mend` does it for a last line cut short here.
"""

import argparse
import hashlib
import json
import os
import re
import sys
import time
from collections import Counter, defaultdict
from pathlib import Path

import tr9_design as D          # puts freeze 1's told/ on the path
import tr9_rule as TR
import client as cl             # noqa: E402  freeze 1's
import rule                     # noqa: E402
import run as R                 # noqa: E402
import verdicts as VD           # noqa: E402
from conditions import DECLINE  # noqa: E402

HERE = Path(__file__).resolve().parent
TOLD = HERE.relative_to(R.REPO)
# What an addendum to this freeze may change (FREEZE-8.md, section 8): the dry run and its result, and
# freeze 1's client, where an addendum to freeze 1 changed it. Every other file is fixed.
MAY_CHANGE = frozenset({str(TOLD / "tr9_dry_run.py"), str(TOLD / "results/dry-run.json"), str(R.TOLD / "client.py")})
TR8_RESULTS = R.HERE / "results" / "tr8"       # freeze 1's folders of TR8, one per pin


LONE = re.compile("[\ud800-\udbff](?![\udc00-\udfff])|(?<![\ud800-\udbff])[\udc00-\udfff]")


def line(rec):
    """A record's line: freeze 1's json.dumps(rec, ensure_ascii=False), with the three characters that
    str.splitlines breaks at and JSON leaves raw written as their escapes, and a surrogate standing
    alone, which UTF-8 cannot encode, as its escape (a response escaped in UTF-16 can hold one, cut
    mid-character at its token limit). json.dumps writes them only inside strings, and every backslash
    it writes is part of a whole escape, so the line loads as rec. A high and a low surrogate side by
    side, which a response body holding raw encoded surrogates decodes to, are left as they are: no
    JSON line keeps them two code points, so the sink's encoding raises before it writes, and the run
    stops at that call, as FREEZE-1's note says."""
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
    moved, byte for byte, to NAME.cut beside it, followed by one line beginning "# " that names the time,
    the log's length and sha-256 before the move, how many starts of `run` the meta lists, and the cause
    (on one line). With this freeze's line writer that is the last line alone. Where catalog lines move,
    a whole read naming no snapshot is put in their place, timed at the move, later than every read and
    every call: the calls that ended after the last whole read then lack a good closing read, and resume
    makes them again rather than the rerun's first read closing them. A moved call's record is no longer
    logged, so its call is made again. Where a line holds a raw line separator, nothing is changed and
    the folder stays refused."""
    folder = Path(folder)
    starts = len(json.loads((folder / "meta.json").read_text(encoding="utf-8")).get("starts", []))
    kept, cut, recs, raws = {}, {}, {}, {}
    for name in ("calls.jsonl", "catalog.jsonl"):
        p = folder / name
        raw = raws[name] = p.read_bytes() if p.exists() else b""
        lines = raw.split(b"\n")
        ends = lines[-1] == b""
        lines = lines[:-1] if ends else lines
        k, recs[name] = 0, []
        for k, ln in enumerate(lines):
            try:
                s = ln.decode("utf-8")
                rec = json.loads(s)
            except ValueError:
                break
            if not isinstance(rec, dict) or not (ends or k < len(lines) - 1):
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
        # the .cut first, then the log, each whole by a rename: a stop between leaves the lines in both,
        # and a second mend, finding the .cut's last note naming the log and the starts as they still
        # stand, does not add them again; a later cut, which only a later start of run can make, is added
        # with its own note, its bytes and the log's the same as before or not
        moved, p, q = b"".join(ln + b"\n" for ln in c), folder / name, folder / (name + ".cut")
        left = (f"from {len(raws[name])} bytes, sha-256 {hashlib.sha256(raws[name]).hexdigest()}, "
                f"after {starts} start{'' if starts == 1 else 's'} of run")
        old = q.read_bytes() if q.exists() else b""
        body, _, last = old.rstrip(b"\n").rpartition(b"\n")
        if not (last.startswith(b"# cut ") and last[6:].partition(b" ")[2].startswith(left.encode() + b": ")
                and (body + b"\n").endswith(moved)):
            _whole(q, old + moved + f"# cut {stamp} {left}: {' '.join(cause.split())}\n".encode("utf-8"))
        _whole(p, b"".join(ln + b"\n" for ln in kept[name]))
    log_whole(folder)
    for d in done:
        print(f"{folder}: {d}")
    return done


def record_start(folder, link, facts=None):
    """A start of `run`, recorded in the meta once both logs read whole and before any call, with the
    start's facts (here the contexts asked and TR8's premise as read). mend's note names how many
    there were: a log cut again can only follow a later start, since `run` refuses a log not whole and
    mend's own writes are whole, so a later cut is told from a mend stopped and made again."""
    log_whole(folder)
    mp = Path(folder) / "meta.json"
    meta = json.loads(mp.read_text(encoding="utf-8"))
    meta.setdefault("starts", []).append({"link": link, "t": round(time.time(), 3), **(facts or {})})
    _whole(mp, (json.dumps(meta, indent=1) + "\n").encode("utf-8"))


def _whole(p, data):
    """p holds data, written whole by a rename: the new file, and then the folder, flushed to the file system
    (fsync) before and after it, so that a stopped process or a crashed machine leaves the old file or the
    new one, as far as the file system's fsync holds."""
    tmp = p.with_name(p.name + ".tmp")
    with open(tmp, "wb") as f:
        f.write(data)
        f.flush()
        os.fsync(f.fileno())
    os.replace(tmp, p)
    fd = os.open(p.parent, os.O_RDONLY)
    try:
        os.fsync(fd)
    finally:
        os.close(fd)


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
    """Freeze 1's chain first, so that freeze 1's files taken here are taken only as its newest link
    has them; then this freeze's chain."""
    first = R.frozen_check(repo, R.TOLD)
    fc = R.frozen_check(repo, told, MAY_CHANGE)
    fc["freeze_1_link"] = first["link"]
    return fc


def parse_contexts(arg):
    allc = [D.ctx_id(c) for c in D.contexts()]
    if arg == "all":
        return allc
    want = arg.split(",")
    if not want or any(c not in allc for c in want) or len(set(want)) != len(want):
        raise SystemExit(f"unknown or repeated context in {arg}; known: {allc}")
    return [c for c in allc if c in want]


def logs_sha256(folder):
    """The sha-256 of a folder's two logs, as they stand (None for a log not there)."""
    return {n: (hashlib.sha256((Path(folder) / n).read_bytes()).hexdigest() if (Path(folder) / n).exists() else None)
            for n in ("calls.jsonl", "catalog.jsonl")}


def tr8_premise(family, folder=None, check=None):
    """TR8's premise for each presentation: the bridge of TR8's abstract unit of that presentation for
    the pin, read by freeze 1's reading (verdicts.load and verdicts.units, with freeze 1's chain, or
    check where the dry run gives its own) after log_whole; None for a unit not run or not read whole
    (verdicts.load leaves a context partly logged out), or where the folder holds no TR8 run. Also the
    folder and the sha-256 of its logs. Every refusal of freeze 1's reading, and of log_whole, stands:
    TR9 is then neither started nor read."""
    folder = Path(folder or TR8_RESULTS / family.replace("/", "__"))
    out = {"folder": str(folder), "logs_sha256": logs_sha256(folder), "bridge": {p: None for p in D.PRESENTATIONS}}
    if not (folder / "meta.json").exists():
        return out
    log_whole(folder)
    if check is None:
        meta, recs = VD.load(folder)
    else:
        meta, recs = VD.load(folder, frozen=check)
    if meta.get("test") != "tr8" or meta.get("family") != family:
        raise SystemExit(f"{folder}: not TR8's folder for {family}")
    units = VD.units(meta, recs)
    out["bridge"] = {p: (units["abstract/" + p]["bridge"] if "abstract/" + p in units else None)
                     for p in D.PRESENTATIONS}
    out["read_under"] = meta["read_under"]
    return out


def premise_refused(premise, contexts):
    """The contexts asked whose TR8 premise does not hold; a run makes no call while any does not."""
    return [c for c in contexts if premise["bridge"][c.split("/")[1]] != TR.SUPPORTED]


def load(folder, allow_dry=False, check=None):
    """Freeze 1's verdicts.load with this freeze's plan, prepare, parser and chain, after log_whole;
    and a logged prompt's text, not only its hash, checked against its rebuild's."""
    folder = Path(folder)
    log_whole(folder)
    meta, recs = VD.load(folder, allow_dry, plan=lambda _test, fam: D.plan(fam), prepare=lambda x: D.prepared(x),
                         classify=D.classify, frozen=check or frozen)
    plan = {x["id"]: x for x in D.plan(meta["family"])}
    text = [r["id"] for r in R.logged(folder) if r.get("prompt") != D.prepared(plan[r["id"]])[0]["user"]]
    if text:            # freeze 1's reading compares a logged prompt's hash with its rebuild's; this, its text
        raise SystemExit(f"records whose logged prompt is not the one their call rebuilds: {text[:3]}")
    return meta, recs


def units(recs, premise):
    """TR9's verdict for each unit (framing, presentation) of the records verdicts.load reads: tr9_rule
    on its answers, with TR8's premise of its presentation."""
    by = defaultdict(lambda: {"answers": defaultdict(list), "probes": defaultdict(list)})
    for r in sorted(recs, key=lambda r: r["id"]):
        u = by[r["context"]]
        if r["kind"] == "choice":
            u["answers"][r["condition"]].append(r["answer"])
        else:
            u["probes"][r["condition"]].append(r["probe"])
    out = {}
    for ctx, u in sorted(by.items()):
        framing, presentation = ctx.split("/")
        compute = presentation == "compute"
        out[ctx] = TR.unit_verdict(D.CONDS, u["answers"], u["probes"] if compute else None, compute, framing,
                                   premise["bridge"][presentation])
    return out


def verdicts(folder, tr8_folder=None, check=None, tr8_check=None, write=True):
    """The reading; the dry run gives stand-ins for TR8's folder and both chains' checks."""
    meta, recs = load(folder, check=check)
    premise = tr8_premise(meta["family"], tr8_folder, check=tr8_check)
    v = units(recs, premise)
    role = R.pin(meta["family"])["role"]
    res = {"test": D.TEST, "family": meta["family"], "pin_role": role, "units": v,
           "tr8_premise_at_reading": premise, "tr8_premise_at_starts": [s.get("tr8_premise") for s in meta.get("starts", [])],
           "served_by_provider": dict(Counter(str(served_provider(r["response"])) for r in recs)),
           "served_at_tier": dict(Counter(str(served_tier(r["response"])) for r in recs)),
           "system_fingerprints": dict(Counter(str((r["response"] or {}).get("system_fingerprint")) for r in recs)),
           "no_verdict_partly_logged": meta["partial_contexts"], "calls_made_again": meta["made_again"],
           "lines_moved_by_freeze_1s_note": moved_lines(folder),
           "catalog_reads": [{"t": t_, "slug": s} for t_, s in R.catalog_reads(folder)],
           "read_under": meta["read_under"]}
    if write:
        (Path(folder) / "verdicts.json").write_text(json.dumps(res, indent=1) + "\n", encoding="utf-8")
    for ctx, p in meta["partial_contexts"].items():
        print(f"TR9 {meta['family']} [{role}] {ctx}: no verdict, {p['read']} of {p['planned']} calls read")
    for ctx, u in v.items():
        print(f"TR9 {meta['family']} [{role}] {ctx}: {u['bridge']}"
              + (f" ({u['why']})" if "why" in u else "")
              + (f" at {u['contradicted_at']}" if u["contradicted_at"] else "")
              + (f", declined at {u['declined_at']}" if u["declined_at"] else "")
              + (f"; read: {u['reading']}" if "reading" in u else ""))
    return res


def served_provider(response):
    """The provider a response names (freeze 3's reading of OpenRouter's field), reported only."""
    return response.get("provider") if isinstance(response, dict) else None


def served_tier(response):
    return response.get("service_tier") if isinstance(response, dict) else None


def probe_read(cond, probe):
    """A probe call read whole: every option's number, and an answer for every option that waits and
    every situation (right or not)."""
    got = (probe or {}).get("answers") or {}
    return TR.worths(probe) is not None and all((got.get(lab) or {}).get(s) is not None
                                                for lab, sits in D.stops_named(cond).items() for s in sits)


def smoke_report(folder, stopped=None):
    """The smoke run's report and its stop rule: every call answered by the pin's model while the
    catalog names the frozen snapshot, and read (a choice an option or a decline, a probe whole: see
    probe_read), nothing filtered and no provider rejecting the request. Reported: the served models,
    providers and tiers, the system fingerprints, the catalog's slugs, the declines, whether each probe
    states the reader rightly, tokens and cost per call by kind, and the projection for the full plan
    and its first round, abstract/compute. Exit 0 to go on, 2 to stop before any scored call."""
    folder = Path(folder)
    meta = json.loads((folder / "meta.json").read_text())
    recs = R.logged(folder)
    fam, slug = meta["family"], R.pin(meta["family"])["canonical_slug"]
    bad = [r["id"] for r in recs if (r["kind"] == "choice" and r["answer"] in (rule.INVALID, rule.FILTERED))
           or (r["kind"] == "probe" and not probe_read(D.SMOKE, r["probe"])) or not R.served_ok(fam, r["response"])
           or r.get("catalog") != slug]
    tok = defaultdict(list)
    for r in recs:
        u = (r["response"] or {}).get("usage") or {}
        tok[r["kind"]].append((u.get("prompt_tokens") or 0, u.get("completion_tokens") or 0, float(u.get("cost") or 0)))
    per_call = {k: {"n": len(v), "in": sum(a for a, _, _ in v) / len(v), "out": sum(b for _, b, _ in v) / len(v),
                    "usd": sum(c for _, _, c in v) / len(v)} for k, v in tok.items()}
    proj = {}
    for name, ctxs in (("all", None), ("abstract/compute", ["abstract/compute"])):
        calls = [x for x in D.plan(fam) if ctxs is None or x["context"] in ctxs]
        n = Counter(x["kind"] for x in calls)
        proj[name] = ({"calls": len(calls), "usd": round(sum(n[k] * per_call[k]["usd"] for k in n), 2),
                       "tokens": round(sum(n[k] * (per_call[k]["in"] + per_call[k]["out"]) for k in n))}
                      if all(k in per_call for k in n) else {"calls": len(calls), "usd": "not measured"})
    report = {"family": fam, "calls": len(recs), "planned": meta["calls"], "stopped": stopped, "unread": bad,
              "served_by": dict(Counter(str(R.served_model(r["response"])) for r in recs)),
              "served_by_provider": dict(Counter(str(served_provider(r["response"])) for r in recs)),
              "served_at_tier": dict(Counter(str(served_tier(r["response"])) for r in recs)),
              "system_fingerprints": dict(Counter(str((r["response"] or {}).get("system_fingerprint")) for r in recs)),
              "catalog_named": dict(Counter(str(r.get("catalog")) for r in recs)),
              "catalog_reads": [s for _, s in R.catalog_reads(folder)],
              "declines": sum(1 for r in recs if r["answer"] == DECLINE),
              "reader_right": {"right": sum(1 for r in recs if r["kind"] == "probe" and TR.reader_right(D.SMOKE, r["probe"])),
                               "of": sum(1 for r in recs if r["kind"] == "probe")},
              "per_call": per_call, "projected": proj}
    report["go_on"] = stopped is None and not bad and len(recs) == meta["calls"]
    (folder / "smoke-report.json").write_text(json.dumps(report, indent=1) + "\n")
    print(json.dumps(report, indent=1))
    return 0 if report["go_on"] else 2


def estimate(family):
    """The plan's calls and the design's tokens per call (tr9_design.tokens), by context and kind, and
    the cost at the pin's listed prices before reasoning tokens."""
    price = R.pin(family)["pricing"]
    out = {D.ctx_id(c): {"choice": 0, "probe": 0, "tokens_in": 0, "tokens_out": 0, "usd": 0.0} for c in D.contexts()}
    for x in D.plan(family):
        i, o = D.tokens(x)
        e = out[x["context"]]
        e[x["kind"]] += 1
        e["tokens_in"] += i
        e["tokens_out"] += o
        e["usd"] += i * float(price["prompt"]) + o * float(price["completion"])
    return out


def main(argv=None):
    ap = argparse.ArgumentParser()
    sub = ap.add_subparsers(dest="cmd", required=True)
    sub.add_parser("plan")
    sm = sub.add_parser("smoke")
    sm.add_argument("--family", required=True)
    sm.add_argument("--max-usd", type=float, required=True)
    rn = sub.add_parser("run")
    rn.add_argument("--family", required=True)
    rn.add_argument("--contexts", required=True)
    rn.add_argument("--max-usd", type=float, required=True)
    rn.add_argument("--parallel", type=int, default=1)
    vd = sub.add_parser("verdicts")
    vd.add_argument("folder")
    md = sub.add_parser("mend")
    md.add_argument("folder")
    md.add_argument("--cause", required=True)
    a = ap.parse_args(argv)
    if a.cmd == "plan":
        for p_ in R.PINS["pins"]:
            e = estimate(p_["id"])
            for ctx, x in e.items():
                print(f"{p_['id']:32s} tr9 {ctx:17s} {x['choice'] + x['probe']:5d} calls ({x['probe']} probes), "
                      f"about {(x['tokens_in'] + x['tokens_out']) / 1e6:.2f}M tokens, ${x['usd']:.2f} before reasoning")
            tot = sum(x["usd"] for x in e.values())
            print(f"{p_['id']:32s} tr9 all               {sum(x['choice'] + x['probe'] for x in e.values()):5d} calls, "
                  f"${tot:.2f} before reasoning (the smoke run measures it)")
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
            R.execute(calls, cl.OpenRouterClient(), sink, R.SpendGuard(a.max_usd, len(calls)), done, smoke=True,
                      catalog=R.catalog_slug, link=fc["link"], prepare=D.prepared, classify=D.classify)
        except RuntimeError as e:
            stopped = str(e)
            print(f"the smoke run stopped: {e}")
        sys.exit(smoke_report(out, stopped))
    if a.cmd == "run":
        smoke = R.smoke_passed(a.family, fc["hashes"], root=HERE)
        want = parse_contexts(a.contexts)
        premise = tr8_premise(a.family)
        refused = premise_refused(premise, want)
        if refused:
            raise SystemExit(f"TR8's premise does not hold for {refused} (TR8's abstract unit of the same "
                             f"presentation, for {a.family}: {premise['bridge']}); no call made")
        meta = {"kind": "scored", "test": D.TEST, "family": a.family, "seed": D.SEED,
                "freeze_commit": fc["freeze_commit"], "head": fc["head"], "pin": R.pin(a.family), "smoke": smoke,
                "links": {fc["link"]: fc["hashes"]}, "link_commits": {fc["link"]: fc["commits"][fc["link"]]}}
        # the full plan's order, kept for any part of it
        calls = [x for x in D.plan(a.family) if x["context"] in want]
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
        record_start(out, fc["link"], {"contexts": want, "tr8_premise": premise})
        sink, logged_ids = open_sink(out)
        done = R.resume(out, a.family, sink, R.catalog_slug)      # calls outside good reads made again
        guard = R.SpendGuard(a.max_usd, len(calls) + len(logged_ids))
        guard.usd, guard.calls = sink.spent, len(R.logged(out))
        R.execute(calls, cl.OpenRouterClient(), sink, guard, done, a.parallel, catalog=R.catalog_slug,
                  link=fc["link"], prepare=D.prepared, classify=D.classify)
        print(f"done: the {a.contexts} calls of TR9 for {a.family} in {out}")


if __name__ == "__main__":
    main()
