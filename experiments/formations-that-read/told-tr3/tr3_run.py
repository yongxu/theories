"""The run of TR3 and its reading, frozen with the rule, on freeze 1's harness (FREEZE-3.md).

    python3 -B tr3_run.py plan                                   # the fixed calls and the estimate, no call
    python3 -B tr3_run.py smoke --family PIN --max-usd 1         # the release's first step for a pin
    python3 -B tr3_run.py run --family PIN --max-usd 10 [--parallel 8]
    python3 -B tr3_run.py verdicts results/<pin folder>          # writes verdicts.json beside calls.jsonl

Nothing here runs without Ren's yes: `smoke` and `run` call a model through OpenRouter with his key.
Both refuse to start unless freeze 1's own chain checks (run.frozen_check on told/: its files are
as freeze 1's newest link has them) and the working copy of every file the newest link of this
freeze's chain lists (FROZEN.sha256 here, then any addendum's addenda/FROZEN-k.sha256; freeze 1's
files it imports among them) equals its hash and its commit; `run` also unless the pin's latest
smoke run here passed on those hashes. freeze 1's run.execute makes every call, with its stops (a call no retry answers,
another model, a moved catalog, FILTERED_RUN filtered answers in a row, a request whose messages are
not the frozen prompt, a failed attempt returned as an answer, the spend guard), its catalog reads
and its log; TR3's client wrapper stops it, logging nothing, at a response another provider or
another tier served.
`run` makes the plan in rounds: each round's calls are those tr3_design.derive gives for
the answers of records made between two good catalog reads, less those records' calls; a call whose
latest record is not between good reads is made again, that record kept and never read; the run ends
when a round has nothing to make. `verdicts` reads a folder through freeze 1's verdicts.load, given
this freeze's plan (derive on the folder's own good records), prepare, parser and frozen chain, so
every refusal of freeze 1's reading holds here, and a logged record another provider or another
tier served is refused too; then tr3_rule's verdicts.
"""

import argparse
import json
import math
import random
import sys
import time
from collections import Counter, defaultdict
from pathlib import Path

import tr3_design as D          # puts freeze 1's told/ on the path
import tr3_client as TC
import tr3_rule as TR
import client as cl             # noqa: E402  freeze 1's
import run as R                 # noqa: E402
import verdicts as VD           # noqa: E402
from conditions import DECLINE  # noqa: E402

HERE = Path(__file__).resolve().parent
TOLD = HERE.relative_to(R.REPO)
# What an addendum to this freeze may change (FREEZE-3.md, section 8): TR3's client, the endpoint
# lists it reads (read again where a pin's endpoint changes), the dry run that shows it, and freeze
# 1's client where an addendum to freeze 1 changed it; in PINS.json only a pin's served_as, where an
# addendum to freeze 1 changed it. Every other file is fixed.
MAY_CHANGE = frozenset({str(TOLD / "tr3_client.py"), str(TOLD / "ENDPOINTS.json"), str(TOLD / "tr3_dry_run.py"),
                        str(TOLD / "results/dry-run.json"), str(R.TOLD / "client.py")})
TOKENS = 450                    # a call's input and output tokens, rounded up, before reasoning (FREEZE-3.md, section 9)


def frozen(repo=R.REPO, told=TOLD):
    """Freeze 1's chain first, so that freeze 1's client and PINS.json are taken only as freeze 1's
    newest link has them; then this freeze's chain."""
    first = R.frozen_check(repo, R.TOLD)
    fc = R.frozen_check(repo, told, MAY_CHANGE)
    fc["freeze_1_link"] = first["link"]
    return fc


def good_answers(folder, family):
    """The answers of the calls whose latest record was made between two good catalog reads."""
    reads, slug = R.catalog_reads(folder), R.pin(family)["canonical_slug"]
    latest = {}
    for r in R.logged(folder):
        latest[r["id"]] = r
    return {i: (r["answer"] if r["kind"] == "guess" else r["probe"]) for i, r in latest.items()
            if R.bracketed(r, reads, slug)}


def rounds(folder, family, client, sink, guard, parallel=1, catalog=None, link=None, most=40, prepare=None):
    """Make the plan in rounds until a round has nothing to make (at most `most` rounds). First, as
    freeze 1's run does, run.resume's catalog read, logged: it closes a run before it whose closing
    read was lost, and refuses to go on where the catalog names another snapshot. prepare is
    tr3_design.prepared; the dry run passes a faulty one to show that the reading refuses its log."""
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
    meta, recs = VD.load(folder, allow_dry, plan=lambda test, fam: D.derive(fam, good_answers(folder, fam)),
                         prepare=lambda x: D.prepared(x), classify=D.classify, frozen=check or frozen)
    other = [r["id"] for r in R.logged(folder) if not TC.serving_ok(meta["family"], r.get("response"))]
    if other:
        raise SystemExit(f"records another provider or another tier served: {other[:3]}")
    return meta, recs


def upper95(k, n):
    """The exact one-sided 95% upper bound on a rate after k events in n trials (Clopper and Pearson)."""
    if k >= n:
        return 1.0
    lo, hi = k / n, 1.0
    for _ in range(60):
        mid = (lo + hi) / 2
        if sum(math.comb(n, j) * mid ** j * (1 - mid) ** (n - j) for j in range(k + 1)) > 0.05:
            lo = mid
        else:
            hi = mid
    return round(hi, 5)


def units(meta, recs):
    """TR3's verdicts from the records verdicts.load reads."""
    family = meta["family"]
    ans = {r["id"]: (r["answer"] if r["kind"] == "guess" else r["probe"]) for r in recs}

    def answer(x):
        return ans.get(x["id"])
    out = {}
    classes, probes = {}, {}
    for p, h in D.all_cells():
        c = D.cell(family, p, h)
        classes[(p, h)] = TR.cell_class({d: [answer(x) for x in c[d]] for d in TR.DRAWS}, tol=1)
        for d in TR.DRAWS:
            x = D.call(family, "probe", f"probe/{p}/{h or '()'}", "probe", p, h, d, 0)
            if x["id"] in ans:
                probes[(p, h, d)] = ans[x["id"]]
    out["timing"] = TR.timing(classes, probes)
    out["timing_at_the_ties"] = TR.tie_reading(classes, probes)
    out["cells_c0"] = {f"{p}/{h or '()'}": TR.cell_class({d: [answer(x) for x in D.cell(family, p, h)[d]]
                                                          for d in TR.DRAWS}) for p, h in D.all_cells()}
    out["cells_c1"] = {f"{p}/{h or '()'}": c for (p, h), c in classes.items()}
    out["prefixes"] = {f"{p}/{f}": D.walk(family, p, f, answer)[1] for p, f in TR.PREFIXES}
    out["leak_control"] = D.walk(family, *TR.LEAK_PREFIX, answer, leak=True)[1]
    pilot = defaultdict(list)
    for r in recs:
        if r["arm"] == "pilot":
            pilot[(r["prior"], r["history"], r["draw"])].append(r["answer"])
    flips = {f"{p}/{h or '()'}/{d}": sum(1 for a in xs if a != Counter(xs).most_common(1)[0][0])
             for (p, h, d), xs in pilot.items()}
    n = sum(len(xs) for xs in pilot.values())
    out["pilot"] = {"calls": n, "flips": flips, "upper_95_on_the_flip_rate": upper95(sum(flips.values()), n) if n else None,
                    "complete": n == len(D.PILOT) * D.PILOT_REPS}
    out["probes_restated"] = {"restated": sum(1 for (p, h, d), v in probes.items() if TR.restated(v, d, h)),
                              "read": len(probes), "planned": 2 * len(D.all_cells())}
    nod = defaultdict(Counter)
    samp = defaultdict(Counter)
    for r in recs:
        if r["arm"] == "nodraw":
            nod[f"{r['prior']}/{r['history'] or '()'}"][r["answer"]] += 1
        if r["arm"] == "sampled":
            samp[(r["prior"], r["history"], r["draw"])][r["answer"]] += 1
    out["no_draw"] = {k: dict(v) for k, v in sorted(nod.items())}

    def kinds(xs):
        return dict(sorted(Counter(a for a in xs if a is not None and a not in TR.ACTS).items()))
    by_arm = defaultdict(list)
    for r in recs:
        if r["kind"] == "guess":
            by_arm[r["arm"]].append(r["answer"])
    out["non_guesses"] = {
        "by_arm": {a: kinds(xs) for a, xs in sorted(by_arm.items()) if kinds(xs)},
        "cells": {k: v for k, v in ((f"{p}/{h or '()'}", kinds([answer(x) for d in TR.DRAWS for x in D.cell(family, p, h)[d]]))
                                    for p, h in D.all_cells()) if v},
        "walks": {f"{p}/{f}": kinds([answer(x) for x in D.walk(family, p, f, answer)[0]]) for p, f in TR.PREFIXES},
        "leak_control": kinds([answer(x) for x in D.walk(family, *TR.LEAK_PREFIX, answer, leak=True)[0]])}
    sampled = {}
    for p, h in D.SAMPLED:
        a, b = samp.get((p, h, "a"), Counter()), samp.get((p, h, "b"), Counter())
        na, nb = sum(a.values()), sum(b.values())
        if na and nb:
            xa, xb = a["A"] / na, b["A"] / nb
            hw = 1.96 * math.sqrt(xa * (1 - xa) / na + xb * (1 - xb) / nb)
            sampled[f"{p}/{h or '()'}"] = {"P(A | green)": round(xa, 3), "P(A | red)": round(xb, 3),
                                           "D": round(xa - xb, 3), "half_width_95": round(hw, 3), "calls": na + nb}
    out["sampled_reported_only"] = sampled
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
           "read_under": meta["read_under"]}
    (Path(folder) / "verdicts.json").write_text(json.dumps(res, indent=1) + "\n", encoding="utf-8")
    print(f"TR3 {meta['family']} [{role}] timing (BHW, ties to the own light): {v['timing']['outcome']}; "
          f"read at the ties: {v['timing_at_the_ties']['reading']}; the five tie cells: "
          f"{', '.join(f'{n} {k}' for k, n in v['timing_at_the_ties']['tie_cells_counted'].items() if n)}")
    for k, u in v["prefixes"].items():
        print(f"TR3 {meta['family']} [{role}] prefix {k}: {u['outcome']}" + (f" ({u['at']})" if "at" in u else ""))
    print(f"TR3 {meta['family']} [{role}] leak control: {v['leak_control']['outcome']}")
    print(f"TR3 {meta['family']} [{role}] pilot: {sum(v['pilot']['flips'].values())} flips in {v['pilot']['calls']}")


def smoke_report(folder, stopped=None):
    """The smoke run's report and its stop rule: every call answered by the pin's model through the
    chosen endpoint's provider at the standard tier, while the catalog names the frozen snapshot, and
    read (a guess an act or a decline, the probe its three fields). Reported: served models, providers
    and tiers, the system fingerprints, the catalog's slugs, declines, the repeated request's answers,
    tokens and cost per call, and the projection at the plan's bound. Exit 0 to go on, 2 to stop
    before any scored call."""
    folder = Path(folder)
    meta = json.loads((folder / "meta.json").read_text())
    recs = R.logged(folder)
    fam, slug = meta["family"], R.pin(meta["family"])["canonical_slug"]
    bad = [r["id"] for r in recs if (r["kind"] == "guess" and r["answer"] not in TR.ACTS + (DECLINE,))
           or (r["kind"] == "probe" and r["probe"] is None) or not R.served_ok(fam, r["response"])
           or not TC.serving_ok(fam, r["response"]) or r.get("catalog") != slug]
    use = [((r["response"] or {}).get("usage") or {}) for r in recs]
    usd = [float(u.get("cost") or 0) for u in use]
    per = sum(usd) / len(usd) if usd else None
    most = len(D.derive(fam, {})) + D.reached_most()
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
    a = ap.parse_args(argv)
    if a.cmd == "plan":
        for p_ in R.PINS["pins"]:
            fixed, most = D.fixed_calls(p_["id"]), len(D.derive(p_["id"], {})) + D.reached_most()
            print(f"{p_['id']:32s} tr3 {len(fixed)} fixed calls, at most {most} in all, at most about "
                  f"{most * TOKENS / 1e6:.2f}M tokens before reasoning (the smoke run measures it)")
        return
    if a.cmd == "verdicts":
        verdicts(a.folder)
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
        sink, done = R.open_sink(out)
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
        sink, _ = R.open_sink(out)
        guard = R.SpendGuard(a.max_usd, len(R.logged(out)) + 2 * len(D.fixed_calls(a.family)))
        guard.usd, guard.calls = sink.spent, len(R.logged(out))
        k = rounds(out, a.family, cl.OpenRouterClient(), sink, guard, a.parallel, catalog=R.catalog_slug,
                   link=fc["link"])
        print(f"done: TR3 for {a.family} in {out}, {k} rounds")


if __name__ == "__main__":
    main()
