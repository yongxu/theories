"""The run of TR7, frozen with its rule, on freeze 1's harness: the plan of calls, the call builder,
the game the generator plays, and the command line.

    python3 -B tr7_run.py plan                                  # the calls and the usage estimate, no call
    python3 -B tr7_run.py smoke --family PIN --max-usd 1        # the release's first step (FREEZE-4.md, section 8)
    python3 -B tr7_run.py run --family PIN --framings all --max-usd USD [--parallel 8]
                                                                # USD from the smoke run's projection
    python3 -B tr7_run.py mend --family PIN [--cause CAUSE]     # a log cut short: section 8's procedure, no call

Nothing here runs without Ren's yes: `smoke` and `run` call a model through OpenRouter with his key.
The calls are made, logged and checked by freeze 1's code (told/run.py's execute, open_sink, resume,
catalog read, spend guard and served check, told/client.py's client and parser), imported unchanged;
this module gives it TR7's plan and call builder, and a line writer that escapes three characters
freeze 1's reader would split a line at, and each surrogate standing alone; once a write to a log
fails, this line writer's or the catalog's note, no later record or read is written to that log
(open_sink); only the failed write's own rest, left in the file's buffer, may still be written as the
process ends.
`smoke`, `run` and `mend` each hold the pin's lock while they work, on the command line until their
process ends, and refuse while another command of the pin holds it, so a pin's commands run one at a
time (pin_lock).
Both commands refuse to start unless freeze 1's
frozen check passes and the working copy of every file this freeze's chain lists, its own and the
freeze 1 files it imports, equals its hash in the chain's newest link and its commit (frozen); `run`
also unless the pin's latest smoke run in this folder, on those hashes, passed every framing asked
that is not read whole, and no smoke run of the pin stopped one of them by the pin's own answers, a
stop that stands (smoke_passed). Every smoke run is read by the client as it now stands, so only a
client that reads those answers otherwise lifts such a stop, or, for the oversight framing's
restatements, the neutral framing's coming to be read whole; and once a framing's run has begun, a
start of `run` asking for it having a call logged, the pin's own answers at a smoke run stop it no more
(begun). A stop of the run is lifted
by a later smoke run that passes. `smoke` is refused, before any call, where the frozen check fails,
where no smoke run is needed (smoke_needed: one is needed only for a framing neither read whole nor
stopped by a stop that stands, where the pin has none, after an addendum, and after a stop of the
run on that framing), or in the second another smoke run of the pin began.
Every smoke run is kept, and each start of `run` lists them all in the folder's meta. `run` refuses
the oversight framing without the neutral one until the neutral framing's calls are made, unless the
neutral framing's stop stands, since the oversight framing's premise may be the neutral framing's
(oversight_alone; FREEZE-4.md, sections 3 and 7). Both commands refuse, before any call, a pin whose
scored logs freeze 1's code cannot read or go on from, a write cut short among them, or whose meta does
not read (refuse_cut; FREEZE-4.md, section 8); `mend` moves a write cut short, by section 8's procedure.
`run` writes only into results/tr7/<pin>/, one folder per pin whatever framings a run makes, so each
unit is run once; `smoke` only into smoke/; and each command but `plan` opens the pin's lock beside
the pin's folder, results/tr7/<pin>.lock (pin_lock). All of a pin's calls go in one seeded order
interleaving both framings, every condition and both kinds; a run of one framing makes its calls in
that order.
A call carries no earlier answer, so a call made again (run.resume) reads nothing of the record it
replaces. Each answered choice is played by the generator (played), and the record keeps the play.
"""

import argparse
import contextlib
import fcntl
import hashlib
import json
import os
import random
import re
import sys
import time
from collections import Counter, defaultdict
from pathlib import Path

import tr7_conditions as C        # first: puts freeze 1's harness and tr7.py on the path
import tr7_prompts as P
import client as cl               # freeze 1's (told/client.py)
import run as R                   # freeze 1's (told/run.py)
from rule import FILTERED, INVALID    # freeze 1's (told/rule.py)

C.own_files()

HERE = Path(__file__).resolve().parent
FOLDER = HERE.relative_to(R.REPO)     # told-tr7/, repository-relative
SEED = "TR71-freeze-TR7-2026-11-04"
LOGS = ("calls.jsonl", "catalog.jsonl")    # a folder's logs, each read line by line by freeze 1's code
HELD = []      # on the command line, a duplicate of each pin's lock's descriptor, open until the process ends
SMOKE_CALLS = 2       # per framing, smoke condition and kind
# What an addendum to this freeze may change (FREEZE-4.md, section 8): freeze 1's client, where
# freeze 1's own addendum changed it (this freeze has no client of its own), and this freeze's dry run
# that shows it; in freeze 1's PINS.json only a pin's served_as (run.chain reads that file so). Every
# other file the chain lists is fixed, freeze 1's run, rule, prompts and reading among them. That the
# client and PINS.json change only as freeze 1's own addendum changed them is checked by frozen().
MAY_CHANGE = frozenset({str(R.TOLD / "client.py"), str(FOLDER / "tr7_dry_run.py"),
                        str(FOLDER / "results" / "dry-run.json")})


def frozen(repo=None):
    """This freeze's frozen check. First freeze 1's own (run.frozen_check on told/): its chain whole and
    every file its newest link lists as committed, so the freeze 1 files this freeze imports are freeze
    1's newest link's and an addendum here takes freeze 1's client or a pin's served_as only as freeze
    1's own addendum changed it. Then this freeze's chain, in this folder, with its MAY_CHANGE."""
    repo = repo or R.REPO
    R.frozen_check(repo, R.TOLD, R.ADDENDUM_MAY_CHANGE)
    return R.frozen_check(repo, FOLDER, MAY_CHANGE)


SMOKE_NO_NUMBER = 2    # of a framing's four smoke restatements, those giving no number that stop it (section 8)


def refused(response):
    """The model's own refusal of a comprehension call, read as freeze 1's parser reads a choice call's
    (told/client.py classify): no moderation rejection, no content filter's stop, and the response's
    refusal field set. A refusal in prose is text, which no rule reads, so it is not one."""
    if not isinstance(response, dict) or "rejected" in response:
        return False
    try:
        ch = response["choices"][0]
        msg = ch.get("message") or {}
    except (TypeError, KeyError, IndexError, AttributeError):
        return False
    return isinstance(msg, dict) and ch.get("finish_reason") != "content_filter" and bool(msg.get("refusal"))


def cause(rec):
    """Why a smoke run's record gives no reading, its response read by the client as it now stands
    (client.classify): None where it is read (a letter or a decline; a number for every key);
    "provider" for a moderation rejection, or a content filter's stop leaving no complete answer, the
    provider's act; "limit" for an answer the client's token limit cut; "refused" for a comprehension
    call the model refused by its refusal field; "answer" for any other answer the parser cannot read,
    the pin's own (a choice in prose, text outside the schema)."""
    resp = rec["response"]
    answer, numbers = cl.classify(resp, rec["kind"], rec["letters"])
    if (answer not in (INVALID, FILTERED)) if rec["kind"] == "choice" else numbers is not None:
        return None
    if isinstance(resp, dict) and "rejected" in resp:
        return "provider"
    try:
        finish = resp["choices"][0].get("finish_reason")
    except (TypeError, KeyError, IndexError, AttributeError):
        finish = None
    if finish == "content_filter":
        return "provider"
    if finish == "length":
        return "limit"
    return "refused" if rec["kind"] != "choice" and refused(resp) else "answer"


def smoke_records(folder):
    """A smoke run's records, in the order they were logged, and how many lines of its log do not read,
    as a kill or a full disk can leave its last line cut short; a line ends at a newline only. Freeze
    1's run.logged refuses such a log, which would leave every later smoke run, run and reading of the
    pin refused."""
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


def smoke_stops(folder, stopped, neutral_stood=False, neutral_read=False, may_stand=None):
    """A smoke run's stops, its records read by the client as it now stands (FREEZE-4.md, section 8).
    stopped: the run's own stop (execute's), or None. "both": calls another model answered or made under
    another catalog slug, which with a stop of the run, a call not made or a line of the log that does
    not read ("cut", smoke_records) stop both framings. Per framing, "run": choices the provider
    rejected or filtered or the token limit cut, a stop of the run, which a later smoke run that passes
    lifts; "answers": the pin's own answers that stop the framing, a stop that stands: a choice the
    parser cannot read. Where a framing's premise is its own, its restatements stop it too: one the
    provider or the limit stopped, a stop of the run; one the parser cannot read, or SMOKE_NO_NUMBER
    giving no number by the pin's own answers, refused or not, a stop that stands. The neutral
    framing's premise is always its own. The oversight framing's is its own where the neutral
    framing's stop stands, at this smoke run or an earlier one (neutral_stood), and the neutral framing
    is not read whole (neutral_read, from neutral_read_whole), since the reader then reads the
    oversight framing on its own premises. Otherwise no restatement stops the oversight framing: the
    scored rule reads one giving no number as giving none, and the neutral framing's premise may stand
    in for it (section 3). may_stand: per framing, whether the pin's own answers may stop it, False
    once its run has begun (begun), True for both where None; "stands": the "answers"
    where they may, else none, the "answers" then reported only. "go": each framing goes on where
    nothing stops it; "no number": each framing's restatements giving no number."""
    folder = Path(folder)
    meta = json.loads((folder / "meta.json").read_text())
    family = meta["family"]
    slug = R.pin(family)["canonical_slug"]
    recs, cut = smoke_records(folder)
    planned = Counter(x["context"] for x in plan(C.TEST, family, smoke=True))
    made = Counter(r["context"] for r in recs)
    both = [r["id"] for r in recs if not R.served_ok(family, r["response"]) or r.get("catalog") != slug]
    by = {f: {"choice": defaultdict(list), "comprehension": defaultdict(list)} for f in C.FRAMINGS}
    for r in recs:
        why = None if r["id"] in both else cause(r)
        if why:
            by[r["context"]][r["kind"]][why].append(r["id"])

    def framing(f, own):
        ch, cp = by[f]["choice"], by[f]["comprehension"]
        run, answers = ch["provider"] + ch["limit"], list(ch["answer"])
        if own:
            run += cp["provider"] + cp["limit"]
            answers += cp["answer"] + (cp["refused"] if len(cp["answer"]) + len(cp["refused"]) >= SMOKE_NO_NUMBER else [])
        return {"run": run, "answers": answers, "stands": answers if may_stand is None or may_stand[f] else []}
    out = {"stopped": stopped, "both": both, "cut": cut, "neutral": framing("neutral", True)}
    out["oversight"] = framing("oversight", (neutral_stood or bool(out["neutral"]["stands"])) and not neutral_read)
    whole = stopped is None and not both and not cut
    out["go"] = {f: whole and made[f] == planned[f] and not out[f]["run"] and not out[f]["stands"] for f in C.FRAMINGS}
    out["no number"] = {f: sum(len(v) for v in by[f]["comprehension"].values()) for f in C.FRAMINGS}
    return out


def read_json(p):
    """A JSON file's content, or None where it is missing or cut short."""
    try:
        return json.loads(Path(p).read_text())
    except (OSError, ValueError):
        return None


def read_whole(family, framing, root=None):
    """Whether the reader reads the pin's framing whole: every one of its calls logged in the pin's
    results folder, its latest record made between two catalog reads naming the frozen snapshot, as
    freeze 1's verdicts.load reads a call. Such a framing has no call left to make."""
    out = scored(family, root)
    reads, slug = R.catalog_reads(out), R.pin(family)["canonical_slug"]
    latest = {r["id"]: r for r in R.logged(out)}
    return all(i in latest and R.bracketed(latest[i], reads, slug)
               for i in (x["id"] for x in plan(C.TEST, family) if x["context"] == framing))


def neutral_read_whole(family, root=None):
    """Whether the reader reads the pin's neutral framing whole (read_whole). The oversight framing then
    takes its premises beside the neutral framing's, whatever stop came to stand after
    (tr7_verdicts.units)."""
    return read_whole(family, "neutral", root)


def begun(family, root=None):
    """The framings whose run has begun: those a start of `run` asked for that has a call logged, as the
    meta of the pin's results folder lists its starts and its log the calls, a record begun after the
    start and before the next one. None where the folder has no meta; a start with no call logged, its
    key missing, its opening catalog read failed or its only record moved by mend, counts as none. The
    windows read the machine's clock, and a pin's commands run one at a time (pin_lock). `run` starts no
    framing whose stop stands, and once its run has begun the pin's own answers at a smoke run, earlier or
    later, stop that framing no more: its scored calls, not a smoke run's, show what the pin answers
    (smoke_runs; FREEZE-4.md, section 8). Read after refuse_cut, which refuses a meta that does not read."""
    out = scored(family, root)
    starts = (read_json(out / "meta.json") or {}).get("starts") or []
    t0 = [r["t0"] for r in R.logged(out) if r.get("t0") is not None]
    ends = [s["t"] for s in starts[1:]] + [float("inf")]
    return {f for s, end in zip(starts, ends) if any(s["t"] <= t < end for t in t0) for f in s["framings"]}


def scored(family, root=None):
    """The pin's results folder, into which `run` writes its calls."""
    return Path(root or HERE) / "results" / C.TEST / family.replace("/", "__")


@contextlib.contextmanager
def pin_lock(family, root=None, hold=False):
    """One command of a pin at a time (FREEZE-4.md, section 8): `smoke`, `run` and `mend` each hold the
    pin's lock while they work, an exclusive lock on results/tr7/<pin>.lock beside the pin's results
    folder, and each refuses, before anything, while another holds it or where it cannot be taken, on a
    file system that does not lock. The lock belongs to the open file. With hold, as on the command line
    (main), a duplicate of its descriptor stays open (HELD), so the lock outlasts the with and the system
    drops it only when the process ends, killed or not, after any call still in flight and the logs' last
    flush: after a second interrupt of `run`, the calls in flight go on and are logged as they end. The
    file left behind holds nothing, and is not removed while a command of the pin may run, since another
    command would then lock a new file at the same path."""
    p = scored(family, root).with_name(family.replace("/", "__") + ".lock")
    p.parent.mkdir(parents=True, exist_ok=True)
    with p.open("a") as fh:
        try:
            fcntl.flock(fh.fileno(), fcntl.LOCK_EX | fcntl.LOCK_NB)
        except BlockingIOError:
            raise SystemExit(f"another command of {family} is running, holding {p.name}: one command of a pin at a "
                             "time (FREEZE-4.md, section 8); nothing was done") from None
        except OSError as e:
            raise SystemExit(f"{p.name} could not be locked ({e}): a pin's commands need a folder that locks "
                             "(FREEZE-4.md, section 8); nothing was done") from None
        if hold:
            HELD.append(os.dup(fh.fileno()))       # the lock outlasts the with, until the process ends
        yield p


def line_reads(line):
    """Whether a line of a log, as bytes, reads as freeze 1's code reads a line: as UTF-8, as one line to
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
    """What freeze 1's code cannot read or go on from in the folder's logs (FREEZE-4.md, section 8), per
    log: its last line, where the log does not end in a newline (cut just before it, the line would take
    the next run's first record onto it) or where that line does not read (a write cut short); and each
    line before the last that does not read, which no write cut short leaves, since once a write to a
    log fails no later record or read is written to it (open_sink), and a kill ends every write. A line
    ends at a newline only. Empty where every log reads whole."""
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
    meta. `run` leaves neither, writing the meta before any log, and whole or not at all, as far as the
    file system's fsync holds (write_whole)."""
    folder = Path(folder)
    if (folder / "meta.json").exists():
        return None if read_json(folder / "meta.json") is not None else "its meta.json does not read"
    return "a log and no meta.json" if any((folder / n).exists() for n in LOGS) else None


def refuse_cut(folder, done="no call was made"):
    """Refuses a folder whose meta does not serve (meta_missing), which stays refused, and one whose logs
    freeze 1's code cannot read or go on from (cut_short), saying what section 8 of FREEZE-4.md has done
    there: `mend` moves a write cut short, else the folder stays refused."""
    why = meta_missing(folder)
    if why:
        raise SystemExit(f"{Path(folder).name}: {why}, which `run` never leaves, writing the meta before any log, and "
                         "whole or not at all, so the folder stays refused and is reported for Ren (FREEZE-4.md, "
                         f"section 8); {done}")
    cut = cut_short(folder)
    if any(v["lines before the last that do not read"] for v in cut.values()):
        raise SystemExit(f"{Path(folder).name}: {cut}: a line before the last does not read, which no write cut short "
                         "leaves, so the folder stays refused, as freeze 1's code refuses it, and is reported "
                         f"for Ren (FREEZE-4.md, section 8); {done}")
    if cut:
        raise SystemExit(f"{Path(folder).name}: {cut}: a write cut short. `mend` moves each such log's last line, byte "
                         "for byte, to a file beside it named as the log with .cut added (calls.jsonl.cut, "
                         "catalog.jsonl.cut), followed by one line beginning '# cut ' that names the time, the log "
                         "as it stood and, where known, the cause, and "
                         "puts a read naming no snapshot in place of a catalog line; every other line stays. Then "
                         f"start again (FREEZE-4.md, section 8); {done}")


def write_whole(p, data):
    """Writes data, text as UTF-8 or bytes, to p whole or not at all: to a file beside it, flushed to the
    file system (fsync), then renamed over it, and the folder flushed after the rename, so that a full
    disk, a kill or a crash of the system leaves p as it was or as written, never cut short, as far as
    the file system's fsync holds: on macOS not against a cut of power, since fsync there leaves a
    drive's own cache unflushed."""
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


def mend(folder, family, cause=None):
    """Section 8's procedure on a pin's results folder whose write was cut short (FREEZE-4.md), with no other
    command of the pin going: each log's last line that cut_short names moves, byte for byte, to the .cut file
    beside it, followed by one line beginning "# cut " that names the time, the log as it stood before the
    move (its length in bytes and its sha-256), how many starts of `run` the meta lists and, where known,
    the cause, its whitespace joined onto that one line, and every other line stays; where a catalog line
    moves, a read naming no snapshot, timed at the move, is put in its place, so that the calls that ended
    after the last whole read lack a good closing read and are made again. The .cut files are written
    first, each whole or not at all, then the catalog, with that read, and then the calls log is cut back
    in place, each flushed to the file system (write_whole), so that a kill or a crash of the machine
    leaves each moved line in its log, its .cut file or both, and never a read moved with none in its
    place, as far as the file system's fsync holds. A line already at its .cut file's end is not added a
    second time where the note after it names its log as it still stands and as many starts as the meta
    still lists, as a mend stopped between its writes leaves them. A log cut again after a completed mend
    can only have been cut by a later start of `run`, since `run` refuses to start while a log is cut and
    mend's own writes are whole, so its line is added with its own note, whatever its bytes. The pin's
    lock, which main holds while mend works, keeps every other command of the pin out (pin_lock).
    Refused, changing nothing, where the folder stays refused (refuse_cut), where nothing is cut, or
    where the clock is not later than every read and every call the logs keep. Returns, per log, the
    length of the line moved."""
    folder = Path(folder)
    why = meta_missing(folder)
    if why:
        raise SystemExit(f"{folder.name}: {why}: the folder stays refused, and `mend` changes nothing "
                         "(FREEZE-4.md, section 8)")
    meta = read_json(folder / "meta.json") or {}
    if meta.get("family") != family:
        raise SystemExit(f"{folder.name}: no meta of this pin's run: `mend` changes nothing")
    cut = cut_short(folder)
    if not cut:
        raise SystemExit(f"{folder.name}: every log reads whole: `mend` changes nothing (FREEZE-4.md, section 8)")
    if any(v["lines before the last that do not read"] for v in cut.values()):
        raise SystemExit(f"{folder.name}: {cut}: a line before the last does not read, which no write cut short "
                         "leaves, so the folder stays refused and is reported for Ren, and `mend` changes nothing "
                         "(FREEZE-4.md, section 8)")
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
                         "`mend` changes nothing (FREEZE-4.md, section 8)")
    cause = " ".join(str(cause).split()) if cause else ""      # on the note's one line, whatever its whitespace
    stamp = time.strftime("%Y%m%dT%H%M%SZ", time.gmtime()).encode("utf-8")
    tail = (f": {cause}" if cause else "").encode("utf-8")
    k = len(meta.get("starts") or [])
    out = {}
    for n in LOGS:
        if n in cut:
            b = data[n]
            line = (b[:-1] if b.endswith(b"\n") else b)[keep[n]:]
            # the log as it stood, and the starts: a later cut, even of the same bytes, follows a later start
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


def smoke_runs(family, root=None):
    """Every smoke run of the pin in this folder, oldest first, read by the client as it now stands
    (smoke_stops): its folder's name, the frozen hashes it was made on, each framing's go or stop, and
    the pin's own answers that stop each framing, whose stop stands. A smoke run without a readable
    report, or whose log does not read whole, is read as stopped, a stop of the run; one without a
    readable meta as stopped on no frozen files (`smoke` writes the meta before any call, so it made
    none). The runs are read in order, so the oversight framing's restatements count at a smoke run
    only once the neutral framing's stop stands, there or earlier, and only while the neutral framing
    is not read whole (neutral_read_whole). The pin's own answers stop no framing whose run has begun
    (begun), at any smoke run, and are reported only (smoke_stops)."""
    out, neutral_stood, neutral_read = [], False, neutral_read_whole(family, root)
    may = {f: f not in begun(family, root) for f in C.FRAMINGS}
    for d in sorted((Path(root or HERE) / "smoke").glob(family.replace("/", "__") + "-*")):
        meta, rep = read_json(d / "meta.json"), read_json(d / "smoke-report.json")
        if meta is None:
            out.append({"folder": d.name, "hashes": None, "go_on": {f: False for f in C.FRAMINGS},
                        "stands": {f: [] for f in C.FRAMINGS}})
            continue
        stopped = rep.get("stopped") if isinstance(rep, dict) else "no report"
        s = smoke_stops(d, stopped, neutral_stood, neutral_read, may)
        neutral_stood = neutral_stood or bool(s["neutral"]["stands"])
        out.append({"folder": d.name, "hashes": meta.get("hashes"), "go_on": s["go"],
                    "stands": {f: s[f]["stands"] for f in C.FRAMINGS}})
    return out


def stood(runs):
    """Each framing's stop that stands among these smoke runs (smoke_runs): the first where the pin's own
    answers stop it, or None. Only a client that reads those answers so that they stop nothing lifts it,
    since every smoke run is read by the client as it now stands, or, for the oversight framing's
    restatements, the neutral framing's coming to be read whole (FREEZE-4.md, section 8)."""
    return {f: next((r["folder"] for r in runs if r["stands"][f]), None) for f in C.FRAMINGS}


def smoke_needed(runs, hashes, done=()):
    """Why a smoke run of the pin is needed, or None (FREEZE-4.md, section 8). One is needed only for a
    framing it could release: one not read whole (done: the framings read whole, read_whole), so with
    calls left to make, and whose stop does not stand. For such a framing it is needed where the pin
    has no smoke run; where its latest was made on other frozen files, or made no call, since every
    addendum needs one; or where its latest stopped that framing by a stop of the run, which a smoke
    run that passes lifts. Otherwise another smoke run could release nothing and could only add a
    stop, so `smoke` is refused."""
    held = stood(runs)
    open_ = [f for f in C.FRAMINGS if f not in done and not held[f]]
    if not open_:
        return None
    if not runs:
        return "the pin has no smoke run"
    last = runs[-1]
    if last["hashes"] != hashes:
        return f"the latest smoke run ({last['folder']}) was made on other frozen files, or made no call"
    lift = [f for f in open_ if not last["go_on"][f]]
    if lift:
        return (f"the latest smoke run ({last['folder']}) stopped the {' and '.join(lift)} "
                f"framing{'s' if len(lift) > 1 else ''}, a stop of the run")
    return None


def smoke_passed(family, hashes, framings, root=None):
    """The folder of the pin's latest smoke run, where no framing asked has a stop that stands (stood),
    and that smoke run, made on these frozen hashes and read by the client as it now stands, passed
    every framing asked that is not read whole: one read whole has no call left to make (read_whole),
    and a run asking only for such framings is refused. A run needs a smoke run on its own frozen files,
    so every addendum needs a new one; a stop of the run is lifted by a later smoke run that passes
    (FREEZE-4.md, section 8)."""
    runs = smoke_runs(family, root)
    if not runs:
        raise SystemExit(f"no smoke run for {family}: run `smoke` first")
    held = stood(runs)
    if any(held[f] for f in framings):
        raise SystemExit("; ".join(f"{family}'s {f} framing was stopped by the pin's own answers at its smoke run "
                                   f"({held[f]}), a stop that stands" for f in sorted(framings) if held[f])
                         + " (FREEZE-4.md, section 8)")
    left = [f for f in sorted(framings) if not read_whole(family, f, root)]
    if not left:
        raise SystemExit(f"{family}'s {' and '.join(sorted(framings))} framing{'s are' if len(framings) > 1 else ' is'} "
                         "read whole: no call is left to make (FREEZE-4.md, section 8)")
    last = runs[-1]
    if last["hashes"] is None:
        raise SystemExit(f"{family}'s latest smoke run ({last['folder']}) has no meta, so it made no call: make another "
                         "(FREEZE-4.md, section 8)")
    if last["hashes"] != hashes:
        raise SystemExit(f"{family}'s latest smoke run was made on other frozen files ({last['folder']}): a run needs "
                         "a smoke run on its own frozen files, so every addendum needs one (FREEZE-4.md, section 8)")
    stopped = [f for f in left if not last["go_on"][f]]
    if stopped:
        raise SystemExit(f"{family}'s latest smoke run stopped the {' and '.join(stopped)} "
                         f"framing{'s' if len(stopped) > 1 else ''} ({last['folder']}), "
                         "a stop of the run, which a later smoke run that passes lifts (FREEZE-4.md, section 8)")
    return last["folder"]


def oversight_alone(family, out, root=None):
    """None where the oversight framing may run without the neutral one, else why not. Its premise may be
    the neutral framing's, so it runs alone only once the neutral framing's calls are all made in out,
    the pin's results folder, or where the neutral framing's stop stands, so that no more of them will
    be made (FREEZE-4.md, sections 3 and 7)."""
    made = {r["id"] for r in R.logged(out)}
    if {x["id"] for x in plan(C.TEST, family) if x["context"] == "neutral"} <= made \
            or stood(smoke_runs(family, root))["neutral"]:
        return None
    return ("the oversight framing's premise may be the neutral framing's, so it runs without it only once the neutral "
            "framing's calls are made, or where the neutral framing's stop stands (FREEZE-4.md, sections 3 and 7)")


def plan(test=C.TEST, family=None, framings=C.FRAMINGS, smoke=False):
    """Every call of TR7 for one pin: N_CALLS choice calls and COMPREHENSION_CALLS comprehension calls
    per condition and framing, in one seeded interleaved order."""
    assert test == C.TEST
    conds = C.smoke_conditions() if smoke else C.conditions()
    n_choice, n_comp = (SMOKE_CALLS, SMOKE_CALLS) if smoke else (C.N_CALLS, C.COMPREHENSION_CALLS)
    calls = []
    for f in framings:
        for c in conds:
            for kind, n in (("choice", n_choice), ("comprehension", n_comp)):
                for r in range(n):
                    calls.append({"test": test, "family": family, "context": f, "condition": c["id"],
                                  "kind": kind, "rep": r})
    for x in calls:
        x["id"] = "|".join([x["test"], x["family"], x["context"], x["condition"], x["kind"], "%02d" % x["rep"]])
    P.call_rng(SEED, "order", test, family, "smoke" if smoke else "scored").shuffle(calls)
    return calls


def condition_of(x, smoke=False):
    return (C.smoke_by_id() if smoke else C.by_id())[x["condition"]]


def prepared(x, smoke=False):
    """The call's prompt and request, both from its identity."""
    cond = condition_of(x, smoke)
    order = P.shuffled(cond, SEED, x["id"])
    prompt = P.build(cond, x["context"], x["kind"], order)
    seed = int(hashlib.sha256((SEED + x["id"]).encode()).hexdigest()[:8], 16) % (2 ** 31)
    req = cl.body(x["family"], prompt, seed)
    if not R.pin(x["family"])["seed"]:
        del req["seed"]
    return prompt, req


def played(rec, cond):
    """The generator plays the plan or rule a choice declared, with the chances the game states, and
    records the points: the acts at the two stages, whether one's own way was kept, and the points.
    Seeded by the call's identity, so a record's play can be checked; no call is shown any play. None
    for a comprehension call, a decline and an unreadable answer, which declare nothing."""
    if rec["kind"] != "choice" or rec["answer"] not in cond["options"]:
        return None
    rng = random.Random("|".join((SEED, "play", rec["id"])))
    s = cond["prospects"]
    if cond["kind"] == "told":
        acts = C.ACTS[rec["answer"]]
    elif rec["answer"] == C.OWN_BOTH:
        acts = (C.OWN, C.OWN)
    elif cond["offer"]["kind"] == "fresh":       # complies with chance x / (x + y), drawn afresh at each stage
        x, y = cond["offer"]["x"], cond["offer"]["y"]
        acts = tuple(C.COMPLY if rng.randrange(x + y) < x else C.OWN for _ in range(2))
    else:                                       # one draw before the first stage, followed at both
        x, y = cond["offer"]["x"], cond["offer"]["y"]
        acts = (C.COMPLY, C.COMPLY) if rng.randrange(x + y) < x else (C.OWN, C.OWN)
    kept = rng.randrange(s.total) < (s.keptComplying if acts[0] == C.COMPLY else s.keptOwn)
    points = (-s.cost if acts[0] == C.COMPLY else 0) + (s.value if acts[1] == C.OWN and kept else 0)
    return {"acts": list(acts), "kept": kept, "points": points}


LONE = re.compile("[\ud800-\udbff](?![\udc00-\udfff])|(?<![\ud800-\udbff])[\udc00-\udfff]")   # a surrogate alone


def escaped(line):
    """A record's dumped line with U+2028, U+2029 and U+0085, and each surrogate code point standing alone,
    written as their JSON escapes. json.dumps leaves them raw, only inside string literals, where every
    backslash before them belongs to a complete escape; freeze 1's reader splits a line at the three, and
    no UTF-8 file holds a surrogate. So the line loads to the same record, value for value, and reads in
    freeze 1's code. A high surrogate followed by a low one, two code points that no line of JSON carries
    as two, is left as it is, and writing that record fails (open_sink)."""
    line = line.replace("\u2028", "\\u2028").replace("\u2029", "\\u2029").replace("\x85", "\\u0085")
    return LONE.sub(lambda m: "\\u%04x" % ord(m.group()), line)


def open_sink(out):
    """Freeze 1's open_sink (told/run.py), its reading of the log, the cost spent and the catalog's note
    unchanged, with its line writer replaced by one writing each record as freeze 1's does, save that the
    characters escaped names are escaped (FREEZE-4.md, section 6); and once a write to a log fails, to
    calls.jsonl by this line writer or to catalog.jsonl by freeze 1's note, no later record or read is
    written to that log, so that nothing is appended after a line cut short (section 8); only the failed
    write's own rest, left in the file's buffer, may still be written as the process ends, completing
    that line. Freeze 1's execute then starts no call, its stop set by the failure, so those in flight
    are the only ones made after it."""
    sink0, done = R.open_sink(out)
    fh = (Path(out) / "calls.jsonl").open("a", encoding="utf-8")
    failed = {name: [] for name in LOGS}

    def once(name, write):
        def put(x):
            if failed[name]:
                raise RuntimeError(f"a write to {name} failed ({failed[name][0]}), so no later record or read "
                                   "is written to it (FREEZE-4.md, section 8)")
            try:
                write(x)
            except Exception as e:
                failed[name].append(f"{type(e).__name__}: {e}")
                raise
        return put

    def line(rec):
        fh.write(escaped(json.dumps(rec, ensure_ascii=False)) + "\n")
        fh.flush()
    sink = once("calls.jsonl", line)
    sink.spent, sink.note = sink0.spent, once("catalog.jsonl", sink0.note)
    return sink, done


def playing(sink, smoke=False):
    """The log's writer, with each record's play added before it is written."""
    def write(rec):
        sink({**rec, "played": played(rec, condition_of(rec, smoke))})
    write.spent, write.note = sink.spent, sink.note
    return write


def estimate(calls):
    """The design's estimate per call (REST-TR2-TR7, Stage B: 1,000 to 2,500 tokens a call), at its low end."""
    return 1000 * len(calls)


def main(argv=None, hold=False):
    ap = argparse.ArgumentParser()
    sub = ap.add_subparsers(dest="cmd", required=True)
    sub.add_parser("plan")
    sm = sub.add_parser("smoke")
    sm.add_argument("--family", required=True)
    sm.add_argument("--max-usd", type=float, required=True)
    rn = sub.add_parser("run")
    rn.add_argument("--family", required=True)
    rn.add_argument("--framings", default="all")
    rn.add_argument("--max-usd", type=float, required=True)
    rn.add_argument("--parallel", type=int, default=1)
    mn = sub.add_parser("mend")
    mn.add_argument("--family", required=True)
    mn.add_argument("--cause", default=None)
    a = ap.parse_args(argv)
    if a.cmd == "plan":
        for p_ in R.PINS["pins"]:
            calls = plan(C.TEST, p_["id"])
            n = {f: sum(1 for x in calls if x["context"] == f) for f in C.FRAMINGS}
            print(f"{p_['id']:32s} {len(calls):5d} calls ({', '.join(f'{f} {k}' for f, k in n.items())}), "
                  f"about {estimate(calls) / 1e6:.2f}M tokens (the design's low estimate; the smoke run measures it)")
        return
    if a.cmd == "mend":
        R.pin(a.family)
        with pin_lock(a.family, hold=hold):    # one command of a pin at a time (section 8)
            frozen()
            got = mend(scored(a.family), a.family, a.cause)
            print(f"moved, per log, a line of so many bytes: {got} (FREEZE-4.md, section 8); start `run` again")
            if "catalog.jsonl" in got:
                put = json.loads((scored(a.family) / "catalog.jsonl").read_bytes().splitlines()[-1])
                print(f"put in the catalog's place: a read naming no snapshot, at t {put['t']} (section 8)")
        return
    if a.cmd == "smoke":
        R.pin(a.family)
        with pin_lock(a.family, hold=hold):    # one command of a pin at a time (section 8)
            fc = frozen()
            refuse_cut(scored(a.family))
            runs = smoke_runs(a.family)
            if smoke_needed(runs, fc["hashes"], [f for f in C.FRAMINGS if read_whole(a.family, f)]) is None:
                raise SystemExit(f"no smoke run of {a.family} is needed: each framing is read whole, stopped by the "
                                 "pin's own answers, a stop that stands, or released by its latest smoke run, on these "
                                 "frozen files, so another could release nothing and could only add a stop "
                                 "(FREEZE-4.md, section 8); no call was made")
            neutral_stood, neutral_read = stood(runs)["neutral"] is not None, neutral_read_whole(a.family)
            may = {f: f not in begun(a.family) for f in C.FRAMINGS}
            calls = plan(C.TEST, a.family, smoke=True)
            out = HERE / "smoke" / (a.family.replace("/", "__") + "-" + time.strftime("%Y%m%dT%H%M%SZ", time.gmtime()))
            try:
                out.mkdir(parents=True)
            except FileExistsError:
                raise SystemExit(f"a smoke run of {a.family} began this second ({out.name}); no call was made: start "
                                 "it again")
            (out / "meta.json").write_text(json.dumps({"kind": "smoke", "test": C.TEST, "family": a.family,
                                                       "seed": SEED, "calls": len(calls), "link": fc["link"],
                                                       "hashes": fc["hashes"], "freeze_commit": fc["freeze_commit"]},
                                                      indent=1) + "\n")
            sink, done = open_sink(out)
            import tr7_verdicts
            stopped = None
            try:
                R.execute(calls, cl.OpenRouterClient(), playing(sink, smoke=True), R.SpendGuard(a.max_usd, len(calls)),
                          done, smoke=True, catalog=R.catalog_slug, link=fc["link"], prepare=prepared)
            except RuntimeError as e:
                stopped = str(e)
                print(f"the smoke run stopped: {e}")
            sys.exit(tr7_verdicts.smoke_report(out, stopped, neutral_stood, neutral_read, may))
    if a.cmd == "run":
        R.pin(a.family)
        with pin_lock(a.family, hold=hold):    # one command of a pin at a time (section 8)
            fc = frozen()
            want = set(C.FRAMINGS) if a.framings == "all" else set(a.framings.split(","))
            if not want <= set(C.FRAMINGS):
                raise SystemExit(f"unknown framing in {a.framings}; known: {list(C.FRAMINGS)}")
            out = scored(a.family)
            refuse_cut(out)
            smoke = smoke_passed(a.family, fc["hashes"], want)
            if "oversight" in want and "neutral" not in want and oversight_alone(a.family, out):
                raise SystemExit(oversight_alone(a.family, out))
            start = {"t": time.time(), "link": fc["link"], "head": fc["head"], "framings": sorted(want),
                     "smoke": smoke,
                     "smoke_runs": [{"folder": s["folder"], "on these frozen files": s["hashes"] == fc["hashes"],
                                     "go_on": s["go_on"], "stands": {f: bool(v) for f, v in s["stands"].items()}}
                                    for s in smoke_runs(a.family)]}
            meta = {"kind": "scored", "test": C.TEST, "family": a.family, "seed": SEED,
                    "freeze_commit": fc["freeze_commit"], "head": fc["head"], "pin": R.pin(a.family), "smoke": smoke,
                    "links": {fc["link"]: fc["hashes"]}, "link_commits": {fc["link"]: fc["commits"][fc["link"]]},
                    "starts": [start]}
            calls = [x for x in plan(C.TEST, a.family) if x["context"] in want]    # the full run's order
            out.mkdir(parents=True, exist_ok=True)
            mp = out / "meta.json"
            keys = ("kind", "test", "family", "seed")
            if mp.exists():
                old = json.loads(mp.read_text())
                if {k: old.get(k) for k in keys} != {k: meta.get(k) for k in keys} \
                        or not R.links_ok(old.get("links"), fc["chain"]):
                    raise SystemExit("this folder holds another run's calls; refusing to mix them")
                if fc["link"] not in old["links"]:     # resumed under a later link of the chain
                    old["links"][fc["link"]] = fc["hashes"]
                    old.setdefault("link_commits", {})[fc["link"]] = fc["commits"][fc["link"]]
                    old.setdefault("resumed", []).append({"link": fc["link"], "head": fc["head"], "smoke": smoke,
                                                          "t": round(time.time(), 3)})
                old.setdefault("starts", []).append(start)
                write_whole(mp, json.dumps(old, indent=1) + "\n")
            else:
                write_whole(mp, json.dumps(meta, indent=1) + "\n")
            sink, logged_ids = open_sink(out)
            done = R.resume(out, a.family, sink, R.catalog_slug)      # calls outside good reads made again
            guard = R.SpendGuard(a.max_usd, len(calls) + len(logged_ids))
            guard.usd, guard.calls = sink.spent, len(R.logged(out))
            R.execute(calls, cl.OpenRouterClient(), playing(sink), guard, done, a.parallel, catalog=R.catalog_slug,
                      link=fc["link"], prepare=prepared)
            print(f"done: the {a.framings} calls of TR7 for {a.family} in {out}")


if __name__ == "__main__":
    main(hold=True)        # the pin's lock held until this process ends (pin_lock)
