"""The shared layer of fresh calls for TR4 and TR5 (freeze 2), on freeze 1's harness.

Freeze 1's files in told/ are imported unchanged: run.py (execute, the catalog read, the spend guard,
the served check, the frozen chain), client.py (the request body and the classification of a
choice), verdicts.py (load) and PINS.json (the pins). This module adds what TR4 and TR5 need and
told/ does not have:

- **Plans read from the log.** TR4's crew reads the record its clerk wrote, and TR5's audit tree,
  listing tree and episodes grow from the answers already given. So each test's plan and prompts
  are pure functions of the folder's log (Log), and a run goes in batches: each batch makes the
  calls the log then allows, through run.execute, with its opening and closing catalog reads, and
  the next batch is planned from the log the last one left. verdicts.load rebuilds every call from
  the same log, so the plan it reads and the prompts it rebuilds are the ones that were made.
- **No id is logged twice.** Once a call is logged, its id is never made again, whatever happens to
  its record (a call execute stops at, unanswered or answered by another model, is logged nowhere,
  and the next run makes it). Where a record was
  not made between two catalog reads naming the pin's frozen snapshot (run.bracketed), the whole
  unit it belongs to (a TR4 unit; a TR5 history's calls, or an episode) is planned again as a new
  attempt, with new ids, once the catalog's read after it has settled it. Which units are planned
  again depends on the catalog's reads alone, never on an answer, as in freeze 1's resume; and since
  no id is logged twice, verdicts.load never meets a call made again. A dependent call's history is
  read from the records of its own attempt only, each logged once.
- **What a call shows and how it is read.** request() is client.body() with the conversation's
  messages where a call carries earlier turns, and the seed dropped where the pin takes none.
  classify() reads a choice with client.classify unchanged, and adds two kinds: a clerk's entry
  (a string, or exactly "decline") and a listing (a choice with the sides it lists). Each keeps
  freeze 1's classes: a decline is the system's answer, a moderation rejection or a filter's stop
  that leaves no complete answer is the provider's (FILTERED), and what cannot be read is INVALID.
- **The frozen chain** of this folder (fresh/FROZEN.sha256 and its addenda), read by run.chain and
  run.frozen_check with this folder's path. The link lists every told/ file this layer imports,
  with freeze 1's hashes, so a change to one refuses this freeze until an addendum of its own lands.
"""

import hashlib
import json
import sys
import time
from pathlib import Path

HERE = Path(__file__).resolve().parent
TOLD_DIR = HERE.parent / "told"
for p in (str(HERE.parent), str(TOLD_DIR), str(HERE)):
    if p not in sys.path:
        sys.path.insert(0, p)

import client as cl          # noqa: E402  (freeze 1, unchanged)
import run as R              # noqa: E402
import verdicts as VD        # noqa: E402
from conditions import DECLINE   # noqa: E402
from rule import FILTERED, INVALID   # noqa: E402

REPO = R.REPO
FRESH = HERE.relative_to(REPO)               # experiments/formations-that-read/fresh
SEED = "TR45-freeze-2-2026-11-04"
# What an addendum to this freeze may change: freeze 1's client and dry run (so that an addendum
# of freeze 1 can be followed by one of this freeze, FREEZE-1.md section 6), and this freeze's dry
# run with its output. Every other file a link lists is fixed, PINS.json beyond a pin's served_as
# included (run.chain).
MAY_CHANGE = R.ADDENDUM_MAY_CHANGE | frozenset(str(FRESH / f) for f in ("fresh_dry_run.py", "results/dry-run.json"))


def frozen():
    """This freeze's chain checked and its working copy equal to the newest link (run.frozen_check)."""
    return R.frozen_check(REPO, FRESH, MAY_CHANGE)


def digest(*parts):
    return hashlib.sha256("|".join(str(p) for p in parts).encode()).hexdigest()


def order_key(test, family, call_id):
    """A call's place in its batch: seeded by its identity alone, so a batch interleaves every arm,
    unit and situation in an order no answer moves."""
    return digest(SEED, "order", test, family, call_id)


def call_seed(call_id):
    return int(digest(SEED, call_id)[:8], 16) % (2 ** 31)


def choose(seq, *parts):
    """An element of seq drawn by the seed of parts (a unit's nuisance, a call's menu order)."""
    return seq[int(digest(SEED, *parts)[:12], 16) % len(seq)]


# --- what a call shows ----------------------------------------------------------------------

def make_prompt(turns, schema, letters):
    """A prompt in the shape run.execute and verdicts.load read: "user" (the last user message, or
    the whole conversation rendered for the log where the call carries earlier turns), "schema",
    "letters" and "sha256", a hash of every message and the schema; "messages" where there is more
    than one turn."""
    assert turns and turns[-1]["role"] == "user"
    if len(turns) == 1:
        user = turns[0]["content"]
    else:
        user = "\n\n".join(f"[{t['role']}]\n{t['content']}" for t in turns)
    p = {"user": user, "schema": schema, "letters": letters,
         "sha256": hashlib.sha256(json.dumps({"messages": turns, "schema": schema}, sort_keys=True,
                                             ensure_ascii=False).encode()).hexdigest()}
    if len(turns) > 1:
        p["messages"] = turns
    return p


def request(family, prompt, call_id):
    """client.body with the call's messages, its seed, and the seed dropped where the pin takes none."""
    req = cl.body(family, prompt, call_seed(call_id))
    if prompt.get("messages"):
        req["messages"] = prompt["messages"]
    if not R.pin(family)["seed"]:
        del req["seed"]
    return req


CHOICE_SCHEMA = lambda letters: {    # noqa: E731  (freeze 1's choice schema, prompts.build)
    "type": "object", "additionalProperties": False, "required": ["reason", "choice"],
    "properties": {"reason": {"type": "string"}, "choice": {"type": "string", "enum": letters + ["decline"]}}}
ENTRY_SCHEMA = {"type": "object", "additionalProperties": False, "required": ["entry"],
                "properties": {"entry": {"type": "string"}}}
LISTING_SCHEMA = lambda letters: {    # noqa: E731
    "type": "object", "additionalProperties": False, "required": ["reason", "sides", "choice"],
    "properties": {"reason": {"type": "string"},
                   "sides": {"type": "array", "items": {"type": "string", "enum": ["left", "right"]}},
                   "choice": {"type": "string", "enum": letters + ["decline"]}}}
CHOICE_ANSWER = ('Answer in JSON: first "reason", {reason}; then "choice", the letter of one {thing}, '
                 'or "decline" if you will not choose any of them.')


def content_of(response):
    """The message's content, the model's own words, as the log keeps them (None where there is none)."""
    try:
        msg = response["choices"][0].get("message") or {}
        return msg.get("content") if isinstance(msg, dict) else None
    except (TypeError, KeyError, IndexError, AttributeError):
        return None


# --- how an answer is read ------------------------------------------------------------------

def _parts(response):
    """(parsed JSON content or None, filtered, refused) of a response; rejected is handled before."""
    try:
        ch = response["choices"][0]
        msg = ch.get("message") or {}
    except (TypeError, KeyError, IndexError, AttributeError):
        return None, False, False
    if not isinstance(msg, dict):
        msg = {}
    try:
        parsed = json.loads(msg.get("content") or "")
    except (TypeError, json.JSONDecodeError):
        parsed = None
    return parsed, ch.get("finish_reason") == "content_filter", bool(msg.get("refusal"))


def classify_entry(response):
    """A clerk's entry: (text | DECLINE | FILTERED | INVALID, None). The entry is read where it is
    complete, even under a filter's stop; exactly "decline" (spaces and case aside) is a decline.
    Otherwise a filter's stop is FILTERED, the model's refusal field a decline, and else INVALID."""
    if isinstance(response, dict) and "rejected" in response:
        return FILTERED, None
    parsed, filtered, refused = _parts(response)
    said = parsed.get("entry") if isinstance(parsed, dict) else None
    if isinstance(said, str):
        return (DECLINE if said.strip().lower() == DECLINE else said), None
    if filtered:
        return FILTERED, None
    return (DECLINE if refused else INVALID), None


def classify_listing(response, letters):
    """A listing: (act | DECLINE | FILTERED | INVALID, {"sides": [...]} or None). Read where the
    choice is a letter and the sides a list of "left" and "right" (a side said twice counts once).
    A decline states no reading, whatever sides the schema made it write: (DECLINE, None).
    Otherwise as classify_entry."""
    if isinstance(response, dict) and "rejected" in response:
        return FILTERED, None
    parsed, filtered, refused = _parts(response)
    said = parsed.get("choice") if isinstance(parsed, dict) else None
    sides = parsed.get("sides") if isinstance(parsed, dict) else None
    sides_ok = isinstance(sides, list) and all(s in ("left", "right") for s in sides)
    if said == DECLINE:
        return DECLINE, None
    if isinstance(said, str) and said in letters and sides_ok:
        return letters[said], {"sides": sorted(set(sides))}
    if filtered:
        return FILTERED, None
    return (DECLINE if refused else INVALID), None


def classify(response, kind, letters):
    """The reading of every kind of call: "choice" by freeze 1's client.classify, unchanged;
    "entry" and "listing" as above. Every value survives a JSON round trip."""
    if kind == "choice":
        return cl.classify(response, "choice", letters)
    if kind == "entry":
        return classify_entry(response)
    if kind == "listing":
        return classify_listing(response, letters)
    raise ValueError(kind)


READABLE = lambda a: a not in (FILTERED, INVALID)   # noqa: E731  (the system's answer: a value or a decline)


# --- the log --------------------------------------------------------------------------------

class Log:
    """A folder's records and catalog reads, as one batch's plan and prompts read them. A record is
    *settled* once a catalog read is logged at or after its end, and then *good* where it was made
    between two reads naming the pin's frozen snapshot (run.bracketed), *bad* otherwise; until
    then it is *pending*. Settled is final: later reads do not move it."""

    def __init__(self, folder, family=None):
        self.folder = Path(folder)
        self.recs = R.logged(self.folder)
        self.reads = R.catalog_reads(self.folder)
        self.by_id = {}
        for r in self.recs:
            if r["id"] in self.by_id:      # no id is logged twice (run_batches makes only unlogged ids)
                raise SystemExit(f"{r['id']}: logged twice; this freeze makes every call once")
            self.by_id[r["id"]] = r
        self.family = family
        self.slug = R.pin(family)["canonical_slug"] if family else None

    def status(self, call_id):
        r = self.by_id.get(call_id)
        if r is None:
            return None
        if not any(t >= r["t1"] for t, _ in self.reads):
            return "pending"
        return "good" if R.bracketed(r, self.reads, self.slug) else "bad"

    def answer(self, call_id):
        return self.by_id[call_id]["answer"]

    def numbers(self, call_id):
        return self.by_id[call_id]["probe"]


def attempt_state(log, ids):
    """One attempt of a unit, by its calls' records: "unmade" where none is logged, "bad" where any
    settled record is bad (the unit is planned again), "pending" while any is unmade or unsettled,
    and "good" where every one is logged, settled and good."""
    st = [log.status(i) for i in ids]
    if "bad" in st:
        return "bad"
    if all(s is None for s in st):
        return "unmade"
    if all(s == "good" for s in st):
        return "good"
    return "pending"


# --- the run --------------------------------------------------------------------------------

def opening_read(sink, family, catalog):
    """A catalog read logged before the first batch, so that the records a stopped run left are
    settled before anything is planned; the run cannot go on where it names another snapshot."""
    slug = catalog(family)
    if slug is None:
        raise RuntimeError(f"the catalog does not list {family}: a failed read; try again later")
    sink.note({"t": time.time(), "family": family, "slug": slug})
    if slug != R.pin(family)["canonical_slug"]:
        raise RuntimeError(f"the catalog names {slug!r} for {family}, not the frozen snapshot")


def filtered_tail(folder):
    """The filtered answers at the end of the folder's log, in a row, across batches."""
    n = 0
    for r in reversed(R.logged(Path(folder))):
        if not R.is_filtered(r["response"], r["answer"], r["probe"]):
            break
        n += 1
    return n


def run_batches(folder, test, family, client, guard, catalog, link, smoke=False, parallel=1, max_batches=200):
    """Make every call the test's plan allows, batch by batch, until the plan has no call left to
    make. Each batch is one run.execute, with its catalog reads, the calls in their seeded order.
    execute counts filtered answers in a row within a batch; so that a run of short batches pauses
    as freeze 1's does, the count is also read across batches from the log after each batch, and
    the run stops by the end of the batch in which run.FILTERED_RUN in a row are reached (at most
    2 * FILTERED_RUN - 1 logged at parallel 1; calls in flight add up to parallel - 1)."""
    sink, _ = R.open_sink(Path(folder))
    if catalog is not None:
        opening_read(sink, family, catalog)
    for _ in range(max_batches):
        log = Log(folder, family)
        todo = [x for x in test.plan(log, family, smoke) if x["id"] not in log.by_id]
        if not todo:
            return
        todo.sort(key=lambda x: order_key(x["test"], family, x["id"]))
        before = len(log.recs)
        R.execute(todo, client, sink, guard, (), parallel=parallel if test.PARALLEL_OK else 1, smoke=smoke,
                  catalog=catalog, link=link, prepare=lambda x, s=False, log=log: test.prepare(log, x, s),
                  classify=classify)
        if len(R.logged(Path(folder))) == before:
            raise RuntimeError("a batch made no call")
        if filtered_tail(folder) >= R.FILTERED_RUN:
            raise RuntimeError(f"{R.FILTERED_RUN} filtered answers in a row, across batches")
    raise RuntimeError(f"more than {max_batches} batches")


def load(folder, test, allow_dry=False, frozen_=None):
    """verdicts.load with the test's plan, prompts and reading, all read from the folder's own log:
    the folder's meta and the records it reads (good and in a context wholly read)."""
    meta = json.loads((Path(folder) / "meta.json").read_text(encoding="utf-8"))
    log = Log(folder, meta.get("family"))
    meta2, recs = VD.load(folder, allow_dry, plan=lambda t, f: test.plan(log, f, False),
                          prepare=lambda x, smoke=False: test.prepare(log, x, smoke),
                          classify=classify, frozen=frozen_ or frozen)
    planned = {x["id"] for x in test.plan(log, meta["family"], False)}
    meta2["unmade"] = sorted(planned - set(log.by_id))
    return meta2, recs, log


# --- the dry run's client -------------------------------------------------------------------

class Stub:
    """The dry run's client: answer(meta) gives the stand-in's answer for the call (an act or a
    label, a string entry, DECLINE, INVALID or FILTERED; for a listing, (act, sides)), returned in
    OpenRouter's shape. No network. `served` is the model the response names."""
    live = False

    def __init__(self, answer, served=None):
        self.answer, self.served = answer, served

    def call(self, request, meta):
        a = self.answer(meta)
        by_label = {lab: L for L, lab in meta["letters"].items()}
        finish = "stop"
        kind = meta["kind"]
        sides = None
        if kind == "listing" and isinstance(a, tuple):
            a, sides = a
        if a == FILTERED:
            content, finish = None, "content_filter"
        elif a == INVALID:
            content = "no json here"
        elif kind == "entry":
            content = json.dumps({"entry": DECLINE if a == DECLINE else a})
        elif kind == "listing":
            content = json.dumps({"reason": "simulated", "sides": sorted(sides or []),
                                  "choice": DECLINE if a == DECLINE else by_label[a]})
        else:
            content = json.dumps({"reason": "simulated", "choice": DECLINE if a == DECLINE else by_label[a]})
        resp = {"model": self.served or request["model"],
                "choices": [{"message": {"role": "assistant", "content": content}, "finish_reason": finish}],
                "usage": {"prompt_tokens": 0, "completion_tokens": 0, "cost": 0.0}}
        return {"response": resp, "attempts": 1, "errors": []}


STAND_IN_CATALOG = lambda family: R.pin(family)["canonical_slug"]   # noqa: E731  (the dry run's catalog)
