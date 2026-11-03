"""The verdicts of TR8 and TR-RR from a run's log, by the frozen rule (rule.py).

    python3 -B verdicts.py results/tr_rr/<pin folder>     # writes verdicts.json beside calls.jsonl

It refuses: a folder whose meta is not a scored run's (a smoke run, a dry run, or no kind); a scored
run whose frozen files are not as the newest link of the frozen chain commits them, or that lists a
link not the chain's or with other hashes (run.frozen_check, run.links_ok; an addendum's link
changes no file but the client, the dry run and a pin's served_as, so the rule and the prompts are
the base link's); a pin not frozen; a record made under a link its folder does not list, whose
fields, letters, prompt hash or request differ from those its id rebuilds now, whose answer the
current parser reads otherwise, or whose response names a model other than the pin's; a record not
in the plan; and a call logged again after a record of it made between good catalog reads. So an
addendum can change how calls not yet made are sent and read, never how a logged call is read:
where it would, the folder is refused. A record not made between two catalog reads naming the pin's
dated slug (the last read at or before its start and the first at or after its end, in
catalog.jsonl) is not read; run.resume makes that call again once the catalog names the snapshot
again, and only the later record, made between good reads, is read. A context wholly absent, or
only partly read, has no verdict and is listed (TR8's first round is the full run's abstract/compute
context). The rebuild guards each record's identity, letters, prompt and request; the response and
its answer are the log's own, and the answer is re-read from the response. TR8's off-switch units
take their premise from the abstract unit of the same presentation. Each unit's bridge is printed
with the pin's role, and a void unit with why: a pin of the theory's own family is reported apart
and decides nothing alone (PINS.json, "rule"). verdicts.json records the link and commits it was
read under.

load() reads a folder by this freeze's plan, prepare, parser and frozen chain unless given others:
a later freeze passes its own, each call of its plan carrying an "id" and a "context" (its unit).
"""

import json
import sys
from collections import Counter, defaultdict
from pathlib import Path

import client as cl
import conditions as C
import rule
import run as R


def load(folder, allow_dry=False, plan=None, prepare=None, classify=None, frozen=None):
    """The folder's meta and the records it reads (see the module's docstring). plan(test, family)
    gives every planned call; prepare(call) -> (prompt, request) rebuilds one; classify(response,
    kind, letters) re-reads its answer; frozen() is the frozen check."""
    plan = plan or (lambda test, family: R.plan(test, family, C.contexts(test)))
    prepare = prepare or (lambda x: R.prepared(x))
    classify = classify or cl.classify
    frozen = frozen or R.frozen_check
    folder = Path(folder)
    meta = json.loads((folder / "meta.json").read_text(encoding="utf-8"))
    kind = meta.get("kind")
    if kind == "smoke":
        raise SystemExit("a smoke run carries no verdict")
    if kind == "dry" and not allow_dry:
        raise SystemExit("a dry run's folder: use dry_run.py")
    if kind not in ("scored", "dry"):
        raise SystemExit(f"not a scored run's folder (kind {kind!r})")
    read_under = None
    if kind == "scored":
        fc = frozen()
        if not R.links_ok(meta.get("links"), fc["chain"]):
            raise SystemExit("the run lists a link that is not the frozen chain's, or with other hashes")
        read_under = {"link": fc["link"], "commits": fc["commits"], "head": fc["head"]}
    R.pin(meta["family"])
    calls = {x["id"]: x for x in plan(meta["test"], meta["family"])}
    recs = R.logged(folder)
    extra = {r["id"] for r in recs} - set(calls)
    if extra:
        raise SystemExit(f"refusing an enlarged log: {len(extra)} calls not in the plan")
    reads = R.catalog_reads(folder)
    frozen_slug = R.pin(meta["family"])["canonical_slug"]
    good = []
    for r in recs:
        x = calls[r["id"]]
        if any(r.get(k) != v for k, v in x.items()):
            raise SystemExit(f"{r['id']}: the record's fields are not its id's")
        if kind == "scored" and r.get("link") not in meta["links"]:
            raise SystemExit(f"{r['id']}: made under {r.get('link')!r}, a link its folder does not list")
        prompt, req = prepare(x)           # the call rebuilt from its id
        if r["letters"] != prompt["letters"] or r["prompt_sha256"] != prompt["sha256"] \
                or r["request"] != {k: v for k, v in req.items() if k != "messages"}:
            raise SystemExit(f"{r['id']}: the record's letters, prompt or request are not those its id rebuilds")
        if not R.served_ok(meta["family"], r["response"]):
            raise SystemExit(f"{r['id']}: answered by {R.served_model(r['response'])!r}, not the pin")
        answer, numbers = classify(r["response"], r["kind"], prompt["letters"])   # re-read, not taken
        if (answer, numbers) != (r["answer"], r["probe"]):
            raise SystemExit(f"{r['id']}: the logged answer is not the one the parser reads from its response")
        good.append(R.bracketed(r, reads, frozen_slug))    # not read where the pin may have moved under it
    by_id = defaultdict(list)
    for r, g in zip(recs, good):
        by_id[r["id"]].append(g)
    for i, gs in by_id.items():
        # a call is made again only where its record was not between good reads (run.resume)
        if sum(gs) > 1 or (any(gs) and not gs[-1]):
            raise SystemExit(f"{i}: logged again after a record made between good catalog reads")
    read_ids = {i for i, gs in by_id.items() if gs[-1]}
    per_ctx = Counter(x["context"] for x in calls.values())
    read_ctx = Counter(calls[i]["context"] for i in read_ids)
    out_ctx = Counter(calls[i]["context"] for i in set(by_id) - read_ids)
    partial = sorted(c for c in set(read_ctx) | set(out_ctx) if read_ctx[c] != per_ctx[c])
    meta = {**meta, "read_under": read_under, "made_again": sum(1 for gs in by_id.values() if len(gs) > 1),
            "partial_contexts": {c: {"read": read_ctx[c], "planned": per_ctx[c],
                                     "not_between_good_catalog_reads": out_ctx[c]} for c in partial}}
    return meta, [r for r, g in zip(recs, good) if g and r["context"] not in meta["partial_contexts"]]


def units(meta, recs):
    """The rule's verdict for each unit (test, family, context) of the log."""
    test = meta["test"]
    conds = C.conditions(test)
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
        premise_ok = None
        if test == "tr8" and framing == "off_switch" and ("abstract/" + presentation) in by:
            premise_ok = rule.premises_hold(test, conds, by["abstract/" + presentation]["answers"])
        out[ctx] = rule.unit_verdict(test, conds, u["answers"], u["probes"] if compute else None, compute,
                                     framing, premise_ok)
    return out


def main(folder):
    meta, recs = load(folder)
    v = units(meta, recs)
    role = R.pin(meta["family"])["role"]
    res = {"test": meta["test"], "family": meta["family"], "pin_role": role, "units": v,
           "no_verdict_partly_logged": meta["partial_contexts"], "calls_made_again": meta["made_again"],
           "read_under": meta["read_under"]}
    (Path(folder) / "verdicts.json").write_text(json.dumps(res, indent=1) + "\n", encoding="utf-8")
    for ctx, p in meta["partial_contexts"].items():
        print(f"{meta['test']} {meta['family']} [{role}] {ctx}: no verdict, {p['read']} of {p['planned']} calls read"
              + (f" ({p['not_between_good_catalog_reads']} made where no two catalog reads name the frozen snapshot)"
                 if p["not_between_good_catalog_reads"] else ""))
    for ctx, u in v.items():
        if u["bridge"] == "void" or "why" in u:
            print(f"{meta['test']} {meta['family']} [{role}] {ctx}: {u['bridge']} ({u['why']})")
            continue
        print(f"{meta['test']} {meta['family']} [{role}] {ctx}: {u['bridge']}"
              + (f" at {u['contradicted_at']}" if u["contradicted_at"] else "")
              + (f", declined at {u['declined_at']}" if u["declined_at"] else ""))


def smoke_report(folder, stopped=None):
    """The smoke run's report and its stop rule: every call answered by the pin's model and read (a
    label, a decline or a probe's numbers), nothing filtered and no provider rejecting the request;
    the served models, declines, catalog reads and tokens per call reported, the last for the
    estimate. Written for a stopped smoke run too, with why. Exit 0 to go on, 2 to stop before any
    scored call (FREEZE-1.md, "The smoke run")."""
    folder = Path(folder)
    recs = [json.loads(l) for l in (folder / "calls.jsonl").read_text(encoding="utf-8").splitlines() if l.strip()] \
        if (folder / "calls.jsonl").exists() else []
    meta = json.loads((folder / "meta.json").read_text())
    tok = defaultdict(list)
    bad = []
    for r in recs:
        u = (r["response"] or {}).get("usage") or {}
        tok[(r["test"], r["kind"])].append((u.get("prompt_tokens") or 0, u.get("completion_tokens") or 0,
                                            float(u.get("cost") or 0)))
        if (r["kind"] == "choice" and r["answer"] in (rule.INVALID, rule.FILTERED)) \
                or (r["kind"] == "probe" and r["probe"] is None) or not R.served_ok(meta["family"], r["response"]) \
                or r.get("catalog") != R.pin(meta["family"])["canonical_slug"]:
            bad.append(r["id"])
    served = Counter(str(R.served_model(r["response"])) for r in recs)
    per_call = {f"{t}/{k}": {"n": len(v), "in": sum(a for a, _, _ in v) / len(v),
                             "out": sum(b for _, b, _ in v) / len(v), "usd": sum(c for _, _, c in v) / len(v)}
                for (t, k), v in tok.items()}
    report = {"family": meta["family"], "calls": len(recs), "planned": meta["calls"], "stopped": stopped,
              "unread": bad, "served_by": dict(served), "catalog": sorted({str(r.get("catalog")) for r in recs}),
              "declined": sum(1 for r in recs if r["answer"] == C.DECLINE), "per_call": per_call}
    proj = {}
    for test in C.TESTS:
        calls = R.plan(test, meta["family"], C.contexts(test))
        n = Counter(x["kind"] for x in calls)
        if all(f"{test}/{k}" in per_call for k in n):
            proj[test] = {"calls": len(calls),
                          "tokens": round(sum(n[k] * (per_call[f"{test}/{k}"]["in"] + per_call[f"{test}/{k}"]["out"])
                                              for k in n)),
                          "usd": round(sum(n[k] * per_call[f"{test}/{k}"]["usd"] for k in n), 2)}
        else:
            proj[test] = {"calls": len(calls), "tokens": "not measured", "usd": "not measured"}
    report["projected_full_design"] = proj
    report["go_on"] = stopped is None and not bad and len(recs) == meta["calls"]
    (folder / "smoke-report.json").write_text(json.dumps(report, indent=1) + "\n")
    print(json.dumps(report, indent=1))
    return 0 if report["go_on"] else 2


if __name__ == "__main__":
    main(sys.argv[1])
