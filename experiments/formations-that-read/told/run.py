"""The run of TR8 and TR-RR, frozen with the rule: the plan of calls, the calls, the log.

    python3 -B run.py plan                                   # the calls and the usage estimate, no call
    python3 -B run.py smoke --family PIN --max-usd 1         # the release's first step (FREEZE-1.md, "The smoke run")
    python3 -B run.py run --test tr_rr --family PIN --contexts all --max-usd 20 [--parallel 8]
    python3 -B run.py run --test tr8 --family PIN --contexts abstract/compute --max-usd 8   # TR8's first round

Nothing here runs without Ren's yes: `smoke` and `run` call a model through OpenRouter with his key.
Both refuse to start unless the working copy of every frozen file equals its hash in the newest link
of the frozen chain and its commit (frozen_check: FROZEN.sha256, then any dated addendum's
addenda/FROZEN-k.sha256, each committed once, after the one before, listing every file the one
before lists and the addendum's own text); `run` also unless the pin's latest smoke run passed on
those hashes. `run` writes only into results/<test>/<pin>/, one folder per test and pin whatever
contexts a run makes (so a first round is the start of the full run and each unit is run once),
`smoke` only into smoke/. The folder's meta lists the links its calls were made under, and each
record names its own; a folder may be resumed under a later link of the chain, whose addendum may
change only the client, the dry run and a pin's served_as (ADDENDUM_MAY_CHANGE). A call shows
exactly its frozen prompt: a request whose messages are other stops the run. Before a scored run's
calls, resume() reads the catalog and, where it names the frozen snapshot, makes again every call
whose latest record was not made between two good reads (that record kept, never read). A test's calls for a
pin go in one seeded order interleaving every condition, context and kind; a run of some contexts
makes theirs in that order. A run can resume, skipping the calls it has logged, its spend guard
counting what they cost (the guard's limit is the folder's total). The pin's dated slug is read from
the public catalog at the start of every run (one with no call left included, so a rerun makes a
lost closing read), every CATALOG_EVERY calls and at the end, each read logged in catalog.jsonl and
the last kept in each record; verdicts.py reads a record only between two reads naming the frozen
snapshot. A run stops at the first call that no retry answers, that a provider rejects other than by
moderation, or that a model other than the pin's answers, logging nothing for it; where the catalog
names another snapshot; and after FILTERED_RUN filtered answers in a row, a pause for the log to be
read (a resume counts afresh). A moderation rejection is logged as the provider's (FILTERED).
"""

import argparse
import hashlib
import json
import subprocess
import sys
import threading
import time
import urllib.error
import urllib.request
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path, PurePosixPath

import client as cl
import conditions as C
import prompts as P
from rule import FILTERED

HERE = Path(__file__).resolve().parent
SEED = "RFZ-freeze-1-2026-11-04"
PINS = json.loads((HERE / "PINS.json").read_text(encoding="utf-8"))
REPO = HERE.parents[2]
TOLD = HERE.relative_to(REPO)          # told/, repository-relative
BASE_LINK = "FROZEN.sha256"            # the chain's first link; addenda's are addenda/FROZEN-k.sha256
# What an addendum to this freeze may change (FREEZE-1.md, section 8): the client (request mechanics,
# parser, the schema's form, a provider's unread response shape) and the dry run that shows it; in
# PINS.json only a pin's served_as. Every other file a link lists is fixed: the rule, the conditions,
# the prompts, the plan, the run, its checks (the catalog read, the spend guard, the filtered pause,
# the served check) and its reading. What a changed client does, an independent reader checks.
ADDENDUM_MAY_CHANGE = frozenset(str(TOLD / f) for f in ("client.py", "dry_run.py", "results/dry-run.json"))
PINS_FILE = str(TOLD / "PINS.json")
SMOKE_CALLS = 2          # per test, context and kind (choice; probe where computed)
CATALOG_EVERY = 100      # calls between reads of the pin's slug in the public catalog
FILTERED_RUN = 20        # filtered answers in a row that pause a run
CATALOG = "https://openrouter.ai/api/v1/models"      # the public catalog, read with no key


def catalog_slug(model, tries=8):
    """The model's dated canonical slug in OpenRouter's public catalog (no key); None if not listed.
    Retried for about five minutes, for a patchy link."""
    for attempt in range(tries):
        try:
            with urllib.request.urlopen(urllib.request.Request(CATALOG), timeout=60) as r:
                for m in json.load(r).get("data", []):
                    if m.get("id") == model:
                        return m.get("canonical_slug")
                return None
        except (urllib.error.URLError, TimeoutError, ConnectionError, json.JSONDecodeError):
            time.sleep(min(60.0, 5.0 * 2 ** attempt))
    raise RuntimeError("the public catalog could not be read")


class SpendGuard:
    """Stops before a call once the run's reported cost reaches max_usd or its calls max_calls."""

    def __init__(self, max_usd, max_calls):
        self.max_usd, self.max_calls, self.usd, self.calls = max_usd, max_calls, 0.0, 0

    def allow(self):
        return self.usd < self.max_usd and self.calls < self.max_calls

    def add(self, response):
        self.calls += 1
        self.usd += float(((response or {}).get("usage") or {}).get("cost") or 0.0)


def is_filtered(response, answer, numbers):
    """The provider stood between the call and its answer: a moderation rejection, or a choice read as
    FILTERED, or a probe with no numbers under a content filter's stop."""
    if isinstance(response, dict) and "rejected" in response:
        return True
    if answer == FILTERED:
        return True
    try:
        return numbers is None and answer is None and response["choices"][0].get("finish_reason") == "content_filter"
    except (TypeError, KeyError, IndexError, AttributeError):
        return False


def pin(family):
    found = [p for p in PINS["pins"] if p["id"] == family]
    if not found:
        raise SystemExit(f"{family} is not a frozen pin: {[p['id'] for p in PINS['pins']]}")
    return found[0]


def parse_contexts(test, arg):
    allc = C.contexts(test)
    if arg == "all":
        return allc
    want = arg.split(",")
    got = [c for c in allc if C.ctx_id(c) in want]
    if len(got) != len(want):
        raise SystemExit(f"unknown context in {arg}; known: {[C.ctx_id(c) for c in allc]}")
    return got


def plan(test, family, contexts, smoke=False):
    """Every call of one test for one family: N_CALLS choice calls per condition and context, and
    PROBE_CALLS probe calls where the numbers are computed; in one seeded interleaved order."""
    conds = [P.smoke_conditions()[test]] if smoke else C.conditions(test)
    n_choice, n_probe = (SMOKE_CALLS, SMOKE_CALLS) if smoke else (C.N_CALLS, C.PROBE_CALLS)
    calls = []
    for ctx in contexts:
        for c in conds:
            for r in range(n_choice):
                calls.append({"test": test, "family": family, "context": C.ctx_id(ctx), "condition": c["id"],
                              "kind": "choice", "rep": r})
            if ctx["presentation"] == "compute":
                for r in range(n_probe):
                    calls.append({"test": test, "family": family, "context": C.ctx_id(ctx), "condition": c["id"],
                                  "kind": "probe", "rep": r})
    for x in calls:
        x["id"] = "|".join([x["test"], x["family"], x["context"], x["condition"], x["kind"], "%02d" % x["rep"]])
    P.call_rng(SEED, "order", test, family, "smoke" if smoke else "scored").shuffle(calls)
    return calls


def prepared(x, smoke=False):
    """The call's prompt, request and letters, all from its identity."""
    cond = P.smoke_conditions()[x["test"]] if smoke else C.by_id(x["test"])[x["condition"]]
    f, pr = x["context"].split("/")
    ctx = {"framing": f, "presentation": pr}
    order = P.shuffled(cond, SEED, x["id"])
    prompt = P.build(x["test"], cond, ctx, x["kind"], order)
    seed = int(hashlib.sha256((SEED + x["id"]).encode()).hexdigest()[:8], 16) % (2 ** 31)
    req = cl.body(x["family"], prompt, seed)
    if not pin(x["family"])["seed"]:
        del req["seed"]
    return prompt, req


def failed_attempt(response):
    """A body the provider sent as a failure, other than a moderation rejection: a top-level error, no
    choice, or a choice whose finish reason is "error" or which carries an error. The client retries
    these; whatever a changed client does, execute never logs one as an answer."""
    if not isinstance(response, dict):
        return True
    if "rejected" in response:
        return False
    ch = (response.get("choices") or [None])[0]
    return response.get("error") is not None or not isinstance(ch, dict) or ch.get("finish_reason") == "error" \
        or bool(ch.get("error"))


def served_model(response):
    """The model a response says served the call; None for a rejected call."""
    return (response or {}).get("model") if isinstance(response, dict) and "rejected" not in response else None


def served_ok(family, response):
    """The response names the pin's model (its id, its dated catalog slug, or a form an addendum
    added to PINS.json's served_as, naming the same snapshot), or is a moderation rejection, which
    names none."""
    if isinstance(response, dict) and "rejected" in response:
        return True
    p = pin(family)
    return served_model(response) in {p["id"], p["canonical_slug"], *p.get("served_as", [])}


def execute(calls, client, sink, guard, done=(), parallel=1, smoke=False, catalog=None, link=None, prepare=None,
            classify=None):
    """Make each call not yet done, built by prepare(call, smoke) -> (prompt, request), the prompt
    carrying "user", "letters" and "sha256", and its answer
    read by classify(response, kind, letters) (prepared and client.classify by default; a later
    freeze passes its own, the same that its verdicts.load is given; a prepare that reads earlier
    answers, as a course's history does, needs parallel=1, which keeps the plan's order, and must say
    which record of a call made again by resume() its history reads, or never make one again); write one
    record per answered call to sink(record), naming the link of the frozen chain it was made under. Stops (raises) at the first call no retry answers, a
    provider rejects other than by moderation, or another model answers (in a smoke run that call is
    logged, so its report shows what served it); where catalog(family), read at the start (with no
    call left too, so that a rerun makes a lost closing read) and every CATALOG_EVERY calls, is not
    the pin's dated slug; after FILTERED_RUN filtered answers in a row; and when the guard says so."""
    todo = [x for x in calls if x["id"] not in set(done)]
    lock = threading.Lock()
    stop = {"why": None}
    state = {"made": 0, "slug": None, "filtered_run": 0}

    def check_catalog(family):
        if catalog is None:
            return
        slug = catalog(family)
        if slug is None:        # not listed: a failed read, logged as none, never a move
            raise RuntimeError(f"the catalog does not list {family}")
        state["slug"] = slug
        if hasattr(sink, "note"):
            sink.note({"t": time.time(), "family": family, "slug": slug})   # full precision, as t0 and t1
        if slug != pin(family)["canonical_slug"]:
            stop["why"] = stop["why"] or f"the catalog names {slug!r} for {family}, not the frozen snapshot"

    if calls:
        try:
            check_catalog(calls[0]["family"])    # the opening read, the closing read of a run before
        except Exception as e:
            raise RuntimeError(f"the opening catalog read failed: {e}")

    def one(x):
        try:
            one_call(x)
        except Exception as e:          # any fault stops every other call too
            with lock:
                stop["why"] = stop["why"] or f"{type(e).__name__} at {x['id']}: {e}"

    def one_call(x):
        if stop["why"]:
            return
        with lock:
            if not guard.allow():
                stop["why"] = stop["why"] or f"spend guard: {guard.usd:.4f} USD over {guard.calls} calls"
                return
            state["made"] += 1
            if state["made"] % CATALOG_EVERY == 0:
                check_catalog(x["family"])
            if stop["why"]:
                return
        prompt, req = (prepare or prepared)(x, smoke)
        if req.get("messages") != (prompt.get("messages") or [{"role": "user", "content": prompt["user"]}]):
            with lock:      # a call shows exactly its frozen prompt, and nothing else
                stop["why"] = stop["why"] or f"{x['id']}: the request's messages are not the frozen prompt"
            return
        meta = {**x, "letters": prompt["letters"]}
        t0 = time.time()
        got = client.call(req, meta)
        if got["response"] is None:
            with lock:
                stop["why"] = stop["why"] or f"no answer for {x['id']}: {got['errors'][-1:]}"
            return
        if failed_attempt(got["response"]):      # a gap is never counted as an answer
            with lock:
                stop["why"] = stop["why"] or f"{x['id']}: the client returned a failed attempt as an answer"
            return
        if not served_ok(x["family"], got["response"]):
            with lock:
                stop["why"] = stop["why"] or (f"{x['id']} answered by {served_model(got['response'])!r}, "
                                              f"not the pin")
                if not smoke:
                    guard.add(got["response"])     # spent, though nothing is logged
            if not smoke:
                return
        answer, numbers = (classify or cl.classify)(got["response"], x["kind"], prompt["letters"])
        rec = {**x, "letters": prompt["letters"], "prompt_sha256": prompt["sha256"], "prompt": prompt["user"],
               "request": {k: v for k, v in req.items() if k != "messages"}, "response": got["response"],
               "attempts": got["attempts"], "errors": got["errors"], "answer": answer, "probe": numbers,
               "catalog": state["slug"], "link": link, "t0": t0, "t1": time.time()}
        with lock:
            guard.add(got["response"])
            sink(rec)
            filtered_now = is_filtered(got["response"], answer, numbers)
            state["filtered_run"] = state["filtered_run"] + 1 if filtered_now else 0
            if state["filtered_run"] >= FILTERED_RUN:
                stop["why"] = stop["why"] or f"{FILTERED_RUN} filtered answers in a row, the last at {x['id']}"

    if parallel <= 1:
        for x in todo:
            one(x)
            if stop["why"]:
                break
    else:
        with ThreadPoolExecutor(max_workers=parallel) as ex:
            list(ex.map(one, todo))
    if todo and state["slug"] == pin(todo[0]["family"])["canonical_slug"]:
        try:
            check_catalog(todo[0]["family"])     # the closing read: the calls made since the last read
        except Exception as e:
            stop["why"] = stop["why"] or f"the closing catalog read failed ({e}); rerun to make it"
    if stop["why"]:
        raise RuntimeError(stop["why"])


def git(repo, *args):
    return subprocess.run(["git", "-C", str(repo), *args], capture_output=True, text=True, check=True).stdout


def blobs(repo, rel):
    """Every commit of the full history that touches rel, oldest last, and the blob rel has in each
    (None where it is absent): a link is committed once where it has one blob in all of them."""
    commits = git(repo, "rev-list", "--full-history", "--topo-order", "HEAD", "--", rel).split()
    out = []
    for c in commits:
        r = subprocess.run(["git", "-C", str(repo), "rev-parse", "--verify", "-q", f"{c}:{rel}"],
                           capture_output=True, text=True)
        out.append((c, r.stdout.strip() if r.returncode == 0 else None))
    return out


def shown(repo, commit, path):
    return subprocess.run(["git", "-C", str(repo), "show", f"{commit}:{path}"], capture_output=True,
                          check=True).stdout


def chain(repo=REPO, told_rel=TOLD, may_change=ADDENDUM_MAY_CHANGE):
    """The frozen chain's links in order: FROZEN.sha256, then addenda/FROZEN-1.sha256, -2, ... as
    [(name, commit, {path: sha256})], in the folder told_rel (this freeze's by default; a later
    freeze names its own, and what its addenda may change). Each link has one blob across the full
    history (committed once, never replaced by a merge, never deleted), committed after the one
    before; no later link was ever committed and then removed. Each addendum's link lists every
    file the one before lists, adds only its own addenda/ADDENDUM-k.md, and changes no file but
    those in may_change and, in PINS.json, a pin's served_as."""
    told = Path(repo) / told_rel
    names = [BASE_LINK]
    while (told / "addenda" / f"FROZEN-{len(names)}.sha256").exists():
        names.append(f"addenda/FROZEN-{len(names)}.sha256")
    found = sorted((told / "addenda").glob("FROZEN-*.sha256")) if (told / "addenda").exists() else []
    if len(found) != len(names) - 1:
        raise SystemExit(f"the addenda's links are not numbered 1 to {len(found)}: {[p.name for p in found]}")
    if git(repo, "rev-list", "--full-history", "HEAD", "--", str(told_rel / "addenda" / f"FROZEN-{len(names)}.sha256")).split():
        raise SystemExit(f"addenda/FROZEN-{len(names)}.sha256 was committed and is gone: the chain was cut")
    links = []
    for k, name in enumerate(names):
        rel = str(told_rel / name)
        history = blobs(repo, rel)
        if not history or len({b for _, b in history}) != 1 or history[0][1] is None:
            raise SystemExit(f"{rel} must be committed exactly once and never changed; found "
                             f"{len({b for _, b in history})} contents in {len(history)} commits")
        commit = history[-1][0]
        hashes = {str(PurePosixPath(p)): h for h, p in
                  (l.split() for l in (told / name).read_text().splitlines() if l.strip())}
        if links:
            prev_commit, prev = links[-1][1], links[-1][2]
            if subprocess.run(["git", "-C", str(repo), "merge-base", "--is-ancestor", prev_commit, commit],
                              capture_output=True).returncode != 0:
                raise SystemExit(f"{rel} was not committed after the link before it")
            own = str(told_rel / "addenda" / f"ADDENDUM-{k}.md")
            if own not in hashes:
                raise SystemExit(f"{rel} does not list its own addendum, addenda/ADDENDUM-{k}.md")
            if not set(prev) <= set(hashes):
                raise SystemExit(f"{rel} drops a file the link before it lists")
            if set(hashes) - set(prev) - {own}:
                raise SystemExit(f"{rel} adds files an addendum may not add: {sorted(set(hashes) - set(prev) - {own})}")
            for p in sorted(x for x in prev if prev[x] != hashes[x]):
                if p in may_change:
                    continue
                if p == PINS_FILE:
                    was, now = shown(repo, prev_commit, p), shown(repo, commit, p)
                    if hashlib.sha256(was).hexdigest() == prev[p] and hashlib.sha256(now).hexdigest() == hashes[p]:
                        def fixed(b):
                            d = json.loads(b)
                            for q in d.get("pins", []):
                                q.pop("served_as", None)
                            return d
                        if fixed(was) == fixed(now):
                            continue
                raise SystemExit(f"{rel} changes {p}, which an addendum may not change")
        links.append((name, commit, hashes))
    return links


def frozen_check(repo=REPO, told_rel=TOLD, may_change=ADDENDUM_MAY_CHANGE):
    """The working copy of every file the newest link lists equals its hash and its commit, and the
    chain in told_rel is whole (chain()). Returns the newest link, its hashes, the whole chain and
    each link's commit."""
    links = chain(repo, told_rel, may_change)
    name, commit, hashes = links[-1]
    bad = [p for p, h in hashes.items() if hashlib.sha256((Path(repo) / p).read_bytes()).hexdigest() != h]
    if bad:
        raise SystemExit(f"frozen files changed: {bad}")
    dirty = git(repo, "status", "--porcelain", "--", *[str(told_rel / n) for n, _, _ in links], *hashes).strip()
    if dirty:
        raise SystemExit(f"frozen files differ from the commit: {dirty}")
    return {"link": name, "link_commit": commit, "freeze_commit": links[0][1], "hashes": hashes,
            "head": git(repo, "rev-parse", "HEAD").strip(), "chain": {n: h for n, _, h in links},
            "commits": {n: c for n, c, _ in links}}


def catalog_reads(folder):
    """The folder's catalog reads, (time, slug), in time order."""
    p = Path(folder) / "catalog.jsonl"
    if not p.exists():
        return []
    return sorted((float(c["t"]), c["slug"]) for c in
                  (json.loads(l) for l in p.read_text(encoding="utf-8").splitlines() if l.strip()))


def logged(folder):
    """The folder's records, in the order they were logged."""
    p = Path(folder) / "calls.jsonl"
    return [json.loads(l) for l in p.read_text(encoding="utf-8").splitlines() if l.strip()] if p.exists() else []


def bracketed(rec, reads, slug):
    """The record was made between two catalog reads naming slug (the last at or before its start
    and the first at or after its end), and the last read before it ended named slug."""
    before = [s for t, s in reads if t <= rec["t0"]]
    after = [s for t, s in reads if t >= rec["t1"]]
    return rec.get("catalog") == slug and bool(before) and bool(after) and before[-1] == slug and after[0] == slug


def resume(folder, family, sink, catalog):
    """Before a scored run's calls: a catalog read, logged. Where it names the frozen snapshot, every
    logged call whose latest record was not made between two good reads is made again, that record
    kept in the log and never read; so which calls are made again depends on the catalog's reads
    alone, never on an answer. Returns the ids not to make again. Where the catalog does not list the
    pin (a failed read, logged as none) or names another snapshot, the run cannot resume."""
    slug = catalog(family)
    if slug is None:
        raise RuntimeError(f"the catalog does not list {family}: a failed read; try again later")
    sink.note({"t": time.time(), "family": family, "slug": slug})
    frozen = pin(family)["canonical_slug"]
    if slug != frozen:
        raise RuntimeError(f"the catalog names {slug!r} for {family}, not the frozen snapshot: no resume")
    reads = catalog_reads(folder)
    latest = {r["id"]: r for r in logged(folder)}
    return {i for i, r in latest.items() if bracketed(r, reads, frozen)}


def links_ok(links, chain_):
    """Each link a scored folder lists is one of the chain's, with the chain's hashes."""
    return bool(links) and all(chain_.get(n) == h for n, h in links.items())


def open_sink(out):
    """The log's writer, the ids already logged and what they cost (for the spend guard on a resume)."""
    out.mkdir(parents=True, exist_ok=True)
    path = out / "calls.jsonl"
    done, spent = set(), 0.0
    if path.exists():
        for line in path.read_text(encoding="utf-8").splitlines():
            if line.strip():
                rec = json.loads(line)
                done.add(rec["id"])
                spent += float(((rec.get("response") or {}).get("usage") or {}).get("cost") or 0.0)
    fh = path.open("a", encoding="utf-8")
    ch = (out / "catalog.jsonl").open("a", encoding="utf-8")

    def sink(rec):
        fh.write(json.dumps(rec, ensure_ascii=False) + "\n")
        fh.flush()

    def note(read):
        ch.write(json.dumps(read) + "\n")
        ch.flush()
    sink.spent, sink.note = spent, note
    return sink, done


def smoke_passed(family, hashes, root=HERE):
    """The pin's latest smoke run under root/smoke (this freeze's by default), whose report must say
    go on, made on these frozen hashes."""
    folders = sorted((Path(root) / "smoke").glob(family.replace("/", "__") + "-*"))
    if not folders or not (folders[-1] / "smoke-report.json").exists():
        raise SystemExit(f"no smoke run for {family}: run `smoke` first")
    rep = json.loads((folders[-1] / "smoke-report.json").read_text())
    meta = json.loads((folders[-1] / "meta.json").read_text())
    if meta.get("hashes") != hashes:
        raise SystemExit(f"{family}'s latest smoke run was made on other frozen files ({folders[-1].name})")
    if not rep.get("go_on"):
        raise SystemExit(f"{family}'s latest smoke run stopped ({folders[-1].name}): see FREEZE-1.md, the smoke run")
    return folders[-1].name


def estimate(calls):
    """The design's token estimate per call (REST-TR8-TR9 R6, REST-TR-RR section 7)."""
    per = {("tr8", "choice"): 800, ("tr8", "probe"): 900, ("tr_rr", "choice"): 600, ("tr_rr", "probe"): 700}
    return sum(per[(x["test"], x["kind"])] for x in calls)


def main(argv=None):
    ap = argparse.ArgumentParser()
    sub = ap.add_subparsers(dest="cmd", required=True)
    sub.add_parser("plan")
    sm = sub.add_parser("smoke")
    sm.add_argument("--family", required=True)
    sm.add_argument("--max-usd", type=float, required=True)
    rn = sub.add_parser("run")
    rn.add_argument("--test", choices=C.TESTS, required=True)
    rn.add_argument("--family", required=True)
    rn.add_argument("--contexts", default="all")
    rn.add_argument("--max-usd", type=float, required=True)
    rn.add_argument("--parallel", type=int, default=1)
    a = ap.parse_args(argv)
    if a.cmd == "plan":
        for p_ in PINS["pins"]:
            for test in C.TESTS:
                calls = plan(test, p_["id"], C.contexts(test))
                print(f"{p_['id']:32s} {test:6s} {len(calls):5d} calls, about {estimate(calls) / 1e6:.2f}M tokens "
                      f"(the design's estimate; the smoke run measures it)")
        return
    if a.cmd == "smoke":
        pin(a.family)
        fc = frozen_check()
        calls = [x for t in C.TESTS for x in plan(t, a.family, C.contexts(t), smoke=True)]
        out = HERE / "smoke" / (a.family.replace("/", "__") + "-" + time.strftime("%Y%m%dT%H%M%S"))
        (out).mkdir(parents=True)
        (out / "meta.json").write_text(json.dumps({"kind": "smoke", "family": a.family, "seed": SEED,
                                                   "calls": len(calls), "link": fc["link"], "hashes": fc["hashes"],
                                                   "freeze_commit": fc["freeze_commit"]}, indent=1) + "\n")
        sink, done = open_sink(out)
        import verdicts
        stopped = None
        try:
            execute(calls, cl.OpenRouterClient(), sink, SpendGuard(a.max_usd, len(calls)), done, smoke=True,
                    catalog=catalog_slug, link=fc["link"])
        except RuntimeError as e:
            stopped = str(e)
            print(f"the smoke run stopped: {e}")
        sys.exit(verdicts.smoke_report(out, stopped))
    if a.cmd == "run":
        fc = frozen_check()
        smoke = smoke_passed(a.family, fc["hashes"])
        meta = {"kind": "scored", "test": a.test, "family": a.family, "seed": SEED,
                "freeze_commit": fc["freeze_commit"], "head": fc["head"], "pin": pin(a.family), "smoke": smoke,
                "links": {fc["link"]: fc["hashes"]}, "link_commits": {fc["link"]: fc["commits"][fc["link"]]}}
        want = {C.ctx_id(c) for c in parse_contexts(a.test, a.contexts)}
        # the full run's order, kept for any part of it
        calls = [x for x in plan(a.test, a.family, C.contexts(a.test)) if x["context"] in want]
        out = HERE / "results" / a.test / a.family.replace("/", "__")
        out.mkdir(parents=True, exist_ok=True)
        mp = out / "meta.json"
        keys = ("kind", "test", "family", "seed")
        if mp.exists():
            old = json.loads(mp.read_text())
            if {k: old.get(k) for k in keys} != {k: meta.get(k) for k in keys} \
                    or not links_ok(old.get("links"), fc["chain"]):
                raise SystemExit("this folder holds another run's calls; refusing to mix them")
            if fc["link"] not in old["links"]:     # resumed under a later link of the chain
                old["links"][fc["link"]] = fc["hashes"]
                old.setdefault("link_commits", {})[fc["link"]] = fc["commits"][fc["link"]]
                old.setdefault("resumed", []).append({"link": fc["link"], "head": fc["head"], "smoke": smoke,
                                                      "t": round(time.time(), 3)})
                mp.write_text(json.dumps(old, indent=1) + "\n")
        else:
            mp.write_text(json.dumps(meta, indent=1) + "\n")
        sink, logged_ids = open_sink(out)
        done = resume(out, a.family, sink, catalog_slug)      # calls outside good reads made again
        guard = SpendGuard(a.max_usd, len(calls) + len(logged_ids))
        guard.usd, guard.calls = sink.spent, len(logged(out))
        execute(calls, cl.OpenRouterClient(), sink, guard, done, a.parallel, catalog=catalog_slug, link=fc["link"])
        print(f"done: the {a.contexts} calls of {a.test} for {a.family} in {out}")


if __name__ == "__main__":
    main()
