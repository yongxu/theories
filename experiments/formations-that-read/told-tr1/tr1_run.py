"""The run of TR1 and its reading, frozen with its rule, on freeze 1's harness (FREEZE-5.md).

    python3 -B tr1_run.py plan                                    # the calls and the usage estimate, no call
    python3 -B tr1_run.py smoke --family PIN --max-usd 1          # the release's first step (section 8)
    python3 -B tr1_run.py run --family PIN --conditions T,F,K --max-usd USD [--parallel 8]
    python3 -B tr1_run.py run --family PIN --conditions H --max-usd USD          # H at parallel 1 only
    python3 -B tr1_run.py verdicts --family PIN                   # writes verdicts.json beside calls.jsonl
    python3 -B tr1_run.py mend --family PIN [--cause CAUSE]       # a log cut short: section 8, no call

USD from the smoke run's projection. Nothing here runs without Ren's yes: `smoke` and `run` call a model
through OpenRouter with his key. The calls are made, logged and checked by freeze 1's code (told/run.py's
execute, open_sink, resume, catalog read, spend guard and served check; told/client.py's client and
parser), imported unchanged; this module gives it TR1's plan, call builder and parser (tr1_design) and a
line writer of its own (open_sink).

The folder handling, in one place (section 8):
- A pin's commands run one at a time: `smoke`, `run`, `mend` and `verdicts` each hold the pin's lock,
  results/tr1/<pin>.lock, while they work, and refuse before anything while another holds it (pin_lock).
- `run` writes only into results/tr1/<pin>/, one folder whatever conditions a start asks for; `smoke`
  only into smoke/<pin>-<UTC time>/. Each meta is written whole, by a rename (write_whole), before any
  log, and lists the frozen hashes; a scored meta lists every start of `run`.
- Each log is written by this freeze's line writer: U+2028, U+2029, U+0085 and a surrogate standing
  alone as their JSON escapes, so every record reads whole in freeze 1's code; unbuffered; and once a
  write to a log fails, nothing more is written to it. So a kill or a full disk can leave at most the
  last line of a log cut short. `smoke`, `run` and `verdicts` refuse, before any call or reading, a
  folder whose meta does not serve or whose logs do not read whole (refuse_cut); `mend` moves a last
  line cut short, by FREEZE-1's dated note, and a line before the last that does not read leaves the
  folder refused.
- A smoke run is read by the client as it now stands, per condition (smoke_stops): a stop of the run,
  lifted by a later smoke run that passes; a stop by the pin's own answers, which stands, where at least
  two of the condition's four answers do not read and its run has not begun (begun). Fewer, or any once
  its run has begun, are a stop of the run.
- `--max-usd` caps the folder's spend over every start of `run`, the records already logged counted.
- A command is refused before any call where it could gain nothing: `smoke` where no smoke run is
  needed (smoke_needed), `run` where every condition asked is read whole or one has a stop that stands,
  or where H is asked at a parallel above 1; `mend` where nothing is cut.
H's calls carry their course's earlier answers (tr1_design.history): each reads, for every earlier step
of its course, that step's latest record logged before it. freeze 1's resume makes again a call whose
latest record was not between two good catalog reads; a course's calls are made in the plan's order at
parallel 1, so an earlier step made again is logged before any later step that reads it, and the
reading rebuilds each record's prompt from the records logged before it (load).
"""

import argparse
import contextlib
import fcntl
import hashlib
import json
import os
import re
import sys
import time
from collections import Counter, defaultdict
from pathlib import Path

import tr1_design as D            # first: puts freeze 1's harness and tr1.py on the path
import tr1_rule as TR
import client as cl               # freeze 1's (told/client.py)
import run as R                   # freeze 1's (told/run.py)
import verdicts as VD             # freeze 1's (told/verdicts.py)
from rule import FILTERED, INVALID    # freeze 1's (told/rule.py)

D.own_files()

HERE = Path(__file__).resolve().parent
FOLDER = HERE.relative_to(R.REPO)     # told-tr1/, repository-relative
LOGS = ("calls.jsonl", "catalog.jsonl")
SMOKE_STANDS = 2        # a condition's unreadable smoke answers (of its four) that stop it for good (section 8)
# What an addendum to this freeze may change (section 8): freeze 1's client, where freeze 1's own addendum
# changed it, and this freeze's dry run and its result; in freeze 1's PINS.json only a pin's served_as
# (run.chain reads that file so). Every other file the chain lists is fixed.
MAY_CHANGE = frozenset({str(R.TOLD / "client.py"), str(FOLDER / "tr1_dry_run.py"),
                        str(FOLDER / "results" / "dry-run.json")})
ROOT = HERE                     # where smoke/ and results/ are; the dry run's command checks set another
CLIENT = cl.OpenRouterClient    # the dry run's command checks set stand-ins for these two
CATALOG = R.catalog_slug


def frozen(repo=None):
    """This freeze's frozen check: freeze 1's own first (its chain whole and every file its newest link
    lists as committed, so the freeze 1 files imported here are its newest link's), then this freeze's
    chain in this folder, with its MAY_CHANGE."""
    repo = repo or R.REPO
    R.frozen_check(repo, R.TOLD, R.ADDENDUM_MAY_CHANGE)
    return R.frozen_check(repo, FOLDER, MAY_CHANGE)


def scored(family, root=None):
    """The pin's results folder, into which `run` writes its calls."""
    return Path(root or ROOT) / "results" / D.TEST / family.replace("/", "__")


def smoke_folders(family, root=None):
    return sorted((Path(root or ROOT) / "smoke").glob(family.replace("/", "__") + "-*"))


@contextlib.contextmanager
def pin_lock(family, root=None):
    """One command of a pin at a time: an exclusive lock on results/tr1/<pin>.lock, refused before
    anything while another command holds it or where it cannot be taken, on a file system that does not
    lock. The lock belongs to the open file, so the system drops it when its process ends, killed or not;
    the file left behind holds nothing."""
    p = scored(family, root).with_name(family.replace("/", "__") + ".lock")
    p.parent.mkdir(parents=True, exist_ok=True)
    with p.open("a") as fh:
        try:
            fcntl.flock(fh.fileno(), fcntl.LOCK_EX | fcntl.LOCK_NB)
        except BlockingIOError:
            raise SystemExit(f"another command of {family} is running, holding {p.name}: one command of a pin at a "
                             "time (FREEZE-5.md, section 8); nothing was done") from None
        except OSError as e:
            raise SystemExit(f"{p.name} could not be locked ({e}): a pin's commands need a folder that locks "
                             "(FREEZE-5.md, section 8); nothing was done") from None
        yield p


def read_json(p):
    """A JSON file's content, or None where it is missing or does not read."""
    try:
        return json.loads(Path(p).read_text(encoding="utf-8"))
    except (OSError, ValueError):
        return None


def write_whole(p, data):
    """Writes data, text as UTF-8 or bytes, to p whole or not at all: to a file beside it, flushed to the
    file system (fsync), renamed over it, and the folder flushed after the rename, so that a full disk, a
    kill or a crash leaves p as it was or as written, as far as the file system's fsync holds (on macOS
    not against a cut of power, since fsync there leaves a drive's own cache unflushed)."""
    p = Path(p)
    tmp = p.with_name(p.name + ".tmp")
    with tmp.open("wb") as fh:
        fh.write(data.encode("utf-8") if isinstance(data, str) else data)
        fh.flush()
        os.fsync(fh.fileno())
    os.replace(tmp, p)
    fd = os.open(p.parent, os.O_RDONLY)
    try:
        os.fsync(fd)
    finally:
        os.close(fd)


LONE = re.compile("[\ud800-\udbff](?![\udc00-\udfff])|(?<![\ud800-\udbff])[\udc00-\udfff]")   # a surrogate alone


def escaped(line):
    """A record's dumped line with U+2028, U+2029 and U+0085, and each surrogate standing alone, written as
    their JSON escapes. json.dumps leaves them raw only inside strings, where every backslash before them
    belongs to a whole escape; freeze 1's reader splits a line at the three, and no UTF-8 file holds a
    surrogate. So the line loads to the same record. A high surrogate followed by a low one, which no
    line of JSON carries as two code points, is left, and writing that record fails (open_sink)."""
    line = line.replace("\u2028", "\\u2028").replace("\u2029", "\\u2029").replace("\x85", "\\u0085")
    return LONE.sub(lambda m: "\\u%04x" % ord(m.group()), line)


def open_sink(out):
    """Freeze 1's open_sink (its reading of the log, the ids logged, the cost spent, the catalog's note),
    with the calls log written by this line writer: each record as freeze 1 dumps it, escaped, unbuffered,
    every byte written before the next record; once a write to a log fails, to calls.jsonl here or to
    catalog.jsonl by freeze 1's note, nothing more is written to that log, so nothing follows a line cut
    short. freeze 1's execute then starts no call, its stop set by the failure. sink.records holds every
    record of the log, those read at the start and each written since, for H's history."""
    sink0, done = R.open_sink(out)
    records = R.logged(out)
    fh = (Path(out) / "calls.jsonl").open("ab", buffering=0)
    failed = {name: [] for name in LOGS}

    def once(name, write):
        def put(x):
            if failed[name]:
                raise RuntimeError(f"a write to {name} failed ({failed[name][0]}), so nothing more is written to it "
                                   "(FREEZE-5.md, section 8)")
            try:
                write(x)
            except Exception as e:
                failed[name].append(f"{type(e).__name__}: {e}")
                raise
        return put

    def line(rec):
        data = (escaped(json.dumps(rec, ensure_ascii=False)) + "\n").encode("utf-8")
        k = 0
        while k < len(data):
            w = fh.write(data[k:])
            if not w:
                raise OSError("the log took no bytes")
            k += w
        records.append(rec)
    sink = once("calls.jsonl", line)
    sink.spent, sink.note, sink.records = sink0.spent, once("catalog.jsonl", sink0.note), records
    return sink, done


def line_reads(line):
    """Whether a line of a log, as bytes, reads as freeze 1's code reads one: as UTF-8, as one line to
    str.splitlines(), and as JSON."""
    try:
        text = line.decode("utf-8")
        if len(text.splitlines()) > 1:
            return False
        json.loads(text)
        return True
    except ValueError:
        return False


def cut_short(folder):
    """What freeze 1's code cannot read or go on from in the folder's logs, per log: its last line, where
    the log does not end in a newline or that line does not read (a write cut short); and each line before
    the last that does not read, which no write cut short leaves (open_sink). Empty where both read whole."""
    out = {}
    for name in LOGS:
        p = Path(folder) / name
        data = p.read_bytes() if p.exists() else b""
        lines = [(i, line) for i, line in enumerate(data.split(b"\n"), 1) if line.strip()]
        if not lines:
            continue
        last = [why for why, bad in (("no final newline", not data.endswith(b"\n")),
                                     ("does not read", not line_reads(lines[-1][1]))) if bad]
        before = [i for i, line in lines[:-1] if not line_reads(line)]
        if last or before:
            out[name] = {"last line": last, "lines before the last that do not read": before}
    return out


def meta_missing(folder):
    """Why the folder's meta does not serve, or None: it does not read, or the folder holds a log and no
    meta. Neither command leaves either, writing the meta whole before any log."""
    folder = Path(folder)
    if (folder / "meta.json").exists():
        return None if read_json(folder / "meta.json") is not None else "its meta.json does not read"
    return "a log and no meta.json" if any((folder / n).exists() for n in LOGS) else None


def refuse_cut(folder, done="no call was made"):
    """Refuses a folder whose meta does not serve, which stays refused, and one whose logs freeze 1's code
    cannot read or go on from (cut_short), saying what section 8 does there."""
    why = meta_missing(folder)
    if why:
        raise SystemExit(f"{Path(folder).name}: {why}, which no command leaves, so the folder stays refused and is "
                         f"reported for Ren (FREEZE-5.md, section 8); {done}")
    cut = cut_short(folder)
    if any(v["lines before the last that do not read"] for v in cut.values()):
        raise SystemExit(f"{Path(folder).name}: {cut}: a line before the last does not read, which no write cut short "
                         "leaves, so the folder stays refused and is reported for Ren (FREEZE-5.md, section 8); "
                         f"{done}")
    if cut:
        raise SystemExit(f"{Path(folder).name}: {cut}: a write cut short. `mend --family PIN` moves each such log's last "
                         "line to the .cut file beside it and, for the catalog, puts a read naming no snapshot in its "
                         f"place; then start again (FREEZE-5.md, section 8); {done}")


def mend(folder, family, cause=None):
    """FREEZE-1's dated note "A log cut short", as section 8 carries it out, on a pin's results folder, the
    pin's lock held: each log's last line that cut_short names moves, byte for byte, to the .cut file
    beside it, followed by one line beginning "# cut " naming the time (UTC), the log as it stood (its
    length in bytes and its sha-256), how many starts of `run` the meta lists and, where known, the cause,
    on that one line; every other line stays. Where a catalog line moves, a read naming no snapshot, timed
    at the move, is put in its place, so the calls that ended after the last whole read lack a good
    closing read and are made again. The .cut files are written first, each whole, then the catalog, whole,
    then the calls log is cut back in place, each flushed, so a kill leaves each moved line in its log, its
    .cut file or both, and never a read moved with none in its place. A line already at its .cut file's end
    is not added again where the note after it names its log as it still stands and as many starts as the
    meta still lists, as a mend stopped between its writes leaves them; a log cut again after a completed
    mend was cut by a later start of `run`, so its line is added with its own note. Refused, changing
    nothing, where the folder stays refused, where nothing is cut, or where the clock is not later than
    every read and call the logs keep. Returns, per log, the length of the line moved."""
    folder = Path(folder)
    why = meta_missing(folder)
    if why:
        raise SystemExit(f"{folder.name}: {why}: the folder stays refused, and `mend` changes nothing "
                         "(FREEZE-5.md, section 8)")
    meta = read_json(folder / "meta.json") or {}
    if meta.get("family") != family:
        raise SystemExit(f"{folder.name}: no meta of this pin's run: `mend` changes nothing")
    cut = cut_short(folder)
    if not cut:
        raise SystemExit(f"{folder.name}: every log reads whole: `mend` changes nothing (FREEZE-5.md, section 8)")
    if any(v["lines before the last that do not read"] for v in cut.values()):
        raise SystemExit(f"{folder.name}: {cut}: a line before the last does not read, which no write cut short "
                         "leaves, so the folder stays refused and is reported for Ren, and `mend` changes nothing "
                         "(FREEZE-5.md, section 8)")
    now = time.time()
    data = {n: (folder / n).read_bytes() for n in LOGS if (folder / n).exists()}
    keep = {n: (b[:-1] if b.endswith(b"\n") else b).rfind(b"\n") + 1 if n in cut else len(b) for n, b in data.items()}
    times = []
    for n, b in data.items():
        for line in b[:keep[n]].split(b"\n"):
            if line.strip():
                rec = json.loads(line.decode("utf-8"))
                times += [rec.get("t")] if n == "catalog.jsonl" else [rec.get("t0"), rec.get("t1")]
    if any(t is not None and t >= now for t in times):
        raise SystemExit(f"{folder.name}: the clock is not later than every read and every call the logs keep: "
                         "`mend` changes nothing (FREEZE-5.md, section 8)")
    cause = " ".join(str(cause).split()) if cause else ""      # on the note's one line, whatever its whitespace
    stamp = time.strftime("%Y%m%dT%H%M%SZ", time.gmtime()).encode("utf-8")
    tail = (f": {cause}" if cause else "").encode("utf-8")
    k = len(meta.get("starts") or [])
    out = {}
    for n in LOGS:
        if n in cut:
            b = data[n]
            line = (b[:-1] if b.endswith(b"\n") else b)[keep[n]:]
            named = (f"from {len(b)} bytes, sha-256 {hashlib.sha256(b).hexdigest()}, after {k} "
                     f"start{'' if k == 1 else 's'} of run").encode("utf-8")
            p = folder / (n + ".cut")
            old = p.read_bytes() if p.exists() else b""
            last = old.split(b"\n")[-3:]
            rest = last[1][len(b"# cut "):].partition(b" ")[2] if len(last) == 3 else b""
            if not (len(last) == 3 and last[0] == line and last[2] == b"" and last[1].startswith(b"# cut ")
                    and (rest == named or rest.startswith(named + b": "))):
                write_whole(p, old + line + b"\n# cut " + stamp + b" " + named + tail + b"\n")
            out[n] = len(line)
    if "catalog.jsonl" in cut:
        put = json.dumps({"t": now, "family": family, "slug": None}) + "\n"
        write_whole(folder / "catalog.jsonl", data["catalog.jsonl"][:keep["catalog.jsonl"]] + put.encode("utf-8"))
    if "calls.jsonl" in cut:        # cut back in place, then flushed to the file system
        with (folder / "calls.jsonl").open("r+b") as fh:
            fh.truncate(keep["calls.jsonl"])
            os.fsync(fh.fileno())
    return out


def moved_lines(folder):
    """The lines mend moved, per .cut file, and the notes beside them (lines beginning "# cut ")."""
    out = {}
    for p in sorted(Path(folder).glob("*.jsonl.cut")):
        ls = [ln for ln in p.read_bytes().decode("utf-8", errors="replace").split("\n") if ln]
        out[p.name] = {"lines_moved": [ln for ln in ls if not ln.startswith("# cut ")],
                       "notes": [ln for ln in ls if ln.startswith("# cut ")]}
    return out


# ------------------------------------------------------------------------------------------------
# The smoke run and what it releases (section 8)

def cause(rec):
    """Why a smoke record gives no reading, its response read by the parser as it now stands
    (tr1_design.classify): None where it is read (a content, "none" or a decline); "provider" for a
    moderation rejection or a content filter's stop leaving no complete answer; "limit" for an answer the
    client's token limit cut; "answer" for any other answer the parser cannot read, the pin's own."""
    resp = rec["response"]
    answer, _ = D.classify(resp, rec["kind"], rec["letters"])
    if answer not in (INVALID, FILTERED):
        return None
    if isinstance(resp, dict) and "rejected" in resp:
        return "provider"
    try:
        finish = resp["choices"][0].get("finish_reason")
    except (TypeError, KeyError, IndexError, AttributeError):
        finish = None
    if finish == "content_filter":
        return "provider"
    return "limit" if finish == "length" else "answer"


def smoke_records(folder):
    """A smoke run's records, in the order logged, and how many lines of its log do not read, as a kill or a
    full disk can leave its last line. A line ends at a newline only."""
    p = Path(folder) / "calls.jsonl"
    recs, cut = [], 0
    for line in (p.read_text(encoding="utf-8", errors="replace").split("\n") if p.exists() else []):
        if not line.strip():
            continue
        try:
            rec = json.loads(line)
        except ValueError:
            rec = None
        if isinstance(rec, dict) and {"id", "context", "kind", "response", "letters"} <= rec.keys():
            recs.append(rec)
        else:
            cut += 1
    return recs, cut


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
    """The characters of every planned call's text, H's with a stand-in history (each earlier answer the
    first listed content), by condition."""
    recs, out = [], Counter()
    for x in D.plan(family):
        prompt = D.build(x, recs if x["condition"] == "H" else ())
        out[x["condition"]] += len(prompt["user"])
        if x["condition"] == "H":
            recs.append({"id": x["id"], "answer": D.presentation(x)[0]})
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
    condition's run has begun, nothing the pin answers at a smoke run, earlier or later, stops it."""
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
                         + " (FREEZE-5.md, section 8); no call was made")
    left = [c for c in sorted(conditions) if not read_whole(family, c, root)]
    if not left:
        raise SystemExit(f"{family}'s {', '.join(sorted(conditions))} read whole: no call is left to make "
                         "(FREEZE-5.md, section 8); no call was made")
    last = runs[-1]
    if last["hashes"] != hashes:
        raise SystemExit(f"{family}'s latest smoke run ({last['folder']}) was made on other frozen files, or made no "
                         "call: a run needs a smoke run on its own frozen files (FREEZE-5.md, section 8); no call was made")
    stopped = [c for c in left if not last["go_on"][c]]
    if stopped:
        raise SystemExit(f"{family}'s latest smoke run ({last['folder']}) stopped {', '.join(stopped)}, a stop of the "
                         "run, which a later smoke run that passes lifts (FREEZE-5.md, section 8); no call was made")
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
        return D.prepared(x, recs[:k] if x["condition"] == "H" else ())
    meta, good = VD.load(folder, allow_dry, plan=lambda test, fam: D.plan(fam), prepare=prepare,
                         classify=D.classify, frozen=check or frozen)
    plan = {x["id"]: x for x in D.plan(meta["family"])}
    text = [r["id"] for k, r in enumerate(recs)
            if r.get("prompt") != D.build(plan[r["id"]], recs[:k] if r["condition"] == "H" else ())["user"]]
    if text:
        raise SystemExit(f"records whose logged prompt is not the one their call rebuilds: {text[:3]}")
    return meta, good, recs


def histories_apart(family, good, recs):
    """H's records read whose history shows, for an earlier step, an answer other than that step's record
    read: none where each course carried the answers the reading reads (section 6)."""
    read = {r["id"]: r for r in good}
    out = []
    for k, r in enumerate(recs):
        if r["condition"] != "H" or read.get(r["id"]) is not r:
            continue
        for p, a in D.history(r, recs[:k]):
            i = D.call_id(family, "H", p, r["rep"])
            if i not in read or read[i]["answer"] != a:
                out.append(r["id"])
                break
    return out


def units(meta, good):
    """Each condition's verdict from the records verdicts.load reads, None for a condition not read whole."""
    by = defaultdict(lambda: defaultdict(list))
    for r in good:
        by[r["condition"]][r["p"]].append(r["answer"])
    return {c: (TR.condition_verdict(c, by[c]) if c in by and c not in meta["partial_contexts"] else None)
            for c in D.CONDITIONS}


def verdicts(folder, check=None, allow_dry=False):
    meta, good, recs = load(folder, allow_dry, check)
    family = meta["family"]
    per = units(meta, good)
    role = R.pin(family)["role"]
    reading = TR.pin_reading(family, per, role)
    runs = smoke_runs(family, Path(folder).parents[2]) if not allow_dry else []
    res = {"test": D.TEST, "family": family, "pin_role": role, "reading": reading, "conditions": per,
           "not_read_whole": {c: ("partly read" if c in meta["partial_contexts"] else "no call read")
                              for c in D.CONDITIONS if per[c] is None},
           "expectation": TR.expectations([{"family": family, "K": per["K"]}]),
           "histories_not_the_answers_read": histories_apart(family, good, recs),
           "served_by": dict(Counter(str(R.served_model(r["response"])) for r in good)),
           "no_verdict_partly_logged": meta["partial_contexts"], "calls_made_again": meta["made_again"],
           "starts": meta.get("starts", []), "stops_that_stand": stood(runs) if runs else {},
           "lines_moved_by_mend": moved_lines(folder),
           "catalog_reads": [{"t": t_, "slug": s} for t_, s in R.catalog_reads(folder)],
           "reads_naming_no_snapshot_put_in_by_mend": [t_ for t_, s in R.catalog_reads(folder) if s is None],
           "read_under": meta["read_under"]}
    write_whole(Path(folder) / "verdicts.json", json.dumps(res, indent=1) + "\n")
    print(f"TR1 {family} [{role}]: {reading['bridge']}" + (f" ({reading['why']})" if reading["why"] else "")
          + (f"; {reading['said']}" if reading["said"] else ""))
    for c in D.CONDITIONS:
        v = per[c]
        print(f"  {c} ({D.NAMES[c]}): " + (res["not_read_whole"][c] if v is None else
                                           f"{v['outcome']}, P1 {v['P1']}, strict {v['strict']} of {v['presentations']}"))
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
            print(f"moved, per log, a line of so many bytes: {got} (FREEZE-5.md, section 8); start `run` again")
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
                                 "(FREEZE-5.md, section 8); no call was made")
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
            if "H" in want and a.parallel != 1:
                raise SystemExit("H's calls carry their course's earlier answers, so H runs at --parallel 1 "
                                 "(FREEZE-5.md, section 6); no call was made")
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
            print(f"done: the {', '.join(sorted(want))} calls of TR1 for {a.family} in {out}")


if __name__ == "__main__":
    main()
