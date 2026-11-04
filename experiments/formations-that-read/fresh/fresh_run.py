"""TR4 and TR5 against the pinned models (freeze 2), on freeze 1's harness.

    python3 -B fresh_run.py plan                                    # the calls per pin and test, no call made
    python3 -B fresh_run.py smoke --family <pin> --max-usd 1        # both tests' smoke calls; report under smoke/
    python3 -B fresh_run.py run --test tr4 --family <pin> --max-usd <usd>
    python3 -B fresh_run.py verdicts --test tr4 [--final]           # every pin's folder under results/tr4/

Nothing runs without Ren's yes, which says which pins and up to what cost (FREEZE-2.md, "What
Ren's yes releases"). A run is refused where the frozen files are not as the newest link of this
freeze's chain commits them (layer.frozen), and where the pin's latest smoke run under smoke/ did
not say go on or was made on other frozen files. A run made in part goes on where it stopped: the
plan is read from the folder's log, and the calls it then allows are made (layer.run_batches). A
scored folder's meta lists every link it was made under, as freeze 1's does.
"""

import argparse
import json
import sys
import time
from collections import Counter, defaultdict
from pathlib import Path

import layer as Ly
import rule4
import rule5
import tr4_live
import tr5_live

R, cl, VD = Ly.R, Ly.cl, Ly.VD
HERE = Ly.HERE
TESTS = {"tr4": tr4_live, "tr5": tr5_live}
PINS = json.loads((Ly.TOLD_DIR / "PINS.json").read_text(encoding="utf-8"))
# The spend guard's call ceiling per pin and test: twice the upper count (TR4's 560 calls; TR5's 927,
# the largest mean over its stand-ins at 9 episodes, with the 15 outside the relation), room for
# attempts made again and reasks.
MAX_CALLS = {"tr4": 2 * 560, "tr5": 2 * 927}
SMOKE_MAX_CALLS = 4 * 22


def pins():
    return [(p["id"], p["role"]) for p in PINS["pins"]]


def results(test, family):
    return HERE / "results" / test / family.replace("/", "__")


def smoke_report(folder, stopped=None):
    """The smoke run's report and its stop rule (FREEZE-2.md, "The smoke run"): every planned call
    made, answered by the pin's model between catalog reads naming its snapshot, and read (an act
    or a decline; an entry or a decline; a listing's sides and its act); the served models,
    declines and tokens per kind of call reported, the last for the projection. Exit 0 to go on,
    2 to stop before any scored call."""
    folder = Path(folder)
    meta = json.loads((folder / "meta.json").read_text())
    log = Ly.Log(folder, meta["family"])
    planned = [x for t in TESTS.values() for x in t.plan(log, meta["family"], smoke=True)]
    tok, bad = defaultdict(list), []
    for r in log.recs:
        u = (r["response"] or {}).get("usage") or {}
        key = f"{r['test']}/{'carried' if r.get('mode') == 'carried' and r.get('step') else r['kind']}"
        tok[key].append((u.get("prompt_tokens") or 0, u.get("completion_tokens") or 0, float(u.get("cost") or 0)))
        if not Ly.READABLE(r["answer"]) or (r["kind"] == "listing" and r["probe"] is None and r["answer"] != Ly.DECLINE) \
                or not R.served_ok(meta["family"], r["response"]) or log.status(r["id"]) != "good":
            bad.append(r["id"])
    per_call = {k: {"n": len(v), "in": sum(a for a, _, _ in v) / len(v), "out": sum(b for _, b, _ in v) / len(v),
                    "usd": sum(c for _, _, c in v) / len(v)} for k, v in tok.items()}
    report = {"family": meta["family"], "calls": len(log.recs), "planned": len(planned), "stopped": stopped,
              "unmade": sorted({x["id"] for x in planned} - set(log.by_id)), "unread": bad,
              "served_by": dict(Counter(str(R.served_model(r["response"])) for r in log.recs)),
              "catalog": sorted({str(r.get("catalog")) for r in log.recs}),
              "declined": sum(1 for r in log.recs if r["answer"] == Ly.DECLINE), "per_call": per_call,
              "projected": projection(per_call)}
    report["go_on"] = stopped is None and not bad and not report["unmade"]
    (folder / "smoke-report.json").write_text(json.dumps(report, indent=1) + "\n")
    print(json.dumps(report, indent=1))
    return 0 if report["go_on"] else 2


def projection(per_call):
    """Tokens and cost at the frozen counts, from the smoke run's measured means: TR4's 560 calls
    (180 clerk entries, 380 choices); TR5 at the law's model's 747 calls (467 single messages,
    the audit, the outside histories and every episode's first step; 180 carried steps after the
    first; 100 listings) and at the upper 927, scaled."""
    def at(counts):
        if not all(k in per_call for k in counts):
            return {"calls": sum(counts.values()), "tokens": "not measured", "usd": "not measured"}
        return {"calls": sum(counts.values()),
                "tokens": round(sum(n * (per_call[k]["in"] + per_call[k]["out"]) for k, n in counts.items())),
                "usd": round(sum(n * per_call[k]["usd"] for k, n in counts.items()), 2)}
    tr5 = {"tr5/choice": 467, "tr5/carried": 180, "tr5/listing": 100}
    up = at({k: round(n * 927 / 747) for k, n in tr5.items()})
    return {"tr4": at({"tr4/entry": 60 * 3, "tr4/choice": 20 * 4 + 20 * 3 + 20 * 3 + 60 * 3}), "tr5": at(tr5),
            "tr5_upper": up}


def main(argv=None):
    ap = argparse.ArgumentParser()
    sub = ap.add_subparsers(dest="cmd", required=True)
    sub.add_parser("plan")
    sm = sub.add_parser("smoke")
    sm.add_argument("--family", required=True)
    sm.add_argument("--max-usd", type=float, required=True)
    rn = sub.add_parser("run")
    rn.add_argument("--test", choices=sorted(TESTS), required=True)
    rn.add_argument("--family", required=True)
    rn.add_argument("--max-usd", type=float, required=True)
    rn.add_argument("--parallel", type=int, default=1)
    vd = sub.add_parser("verdicts")
    vd.add_argument("--test", choices=sorted(TESTS), required=True)
    vd.add_argument("--final", action="store_true",
                    help="TR4: read where a deciding pin's run cannot be completed (it counts at p-values of 1)")
    a = ap.parse_args(argv)
    if a.cmd == "plan":
        for fam, role in pins():
            first = Ly.Log(results("tr4", fam), fam) if results("tr4", fam).exists() else None
            n4 = sum(tr4_live.ARMS[k] * len(tr4_live.SITUATIONS[k]) * (2 if k == "C" else 1) for k in tr4_live.ARMS)
            print(f"{fam:32s} {role:15s} tr4 {n4} calls (more where a unit is made again); tr5 grows with the "
                  f"answers: 747 for the law's model, 927 the largest mean over the stand-ins"
                  + ("" if first is None else f"; {len(first.recs)} tr4 records logged"))
        return
    if a.cmd == "smoke":
        R.pin(a.family)
        fc = Ly.frozen()
        out = HERE / "smoke" / (a.family.replace("/", "__") + "-" + time.strftime("%Y%m%dT%H%M%S"))
        out.mkdir(parents=True)
        (out / "meta.json").write_text(json.dumps({"kind": "smoke", "family": a.family, "seed": Ly.SEED,
                                                   "link": fc["link"], "hashes": fc["hashes"],
                                                   "freeze_commit": fc["freeze_commit"]}, indent=1) + "\n")
        guard = R.SpendGuard(a.max_usd, SMOKE_MAX_CALLS)
        stopped = None
        try:
            for test in TESTS.values():
                Ly.run_batches(out, test, a.family, cl.OpenRouterClient(), guard, R.catalog_slug, fc["link"],
                               smoke=True)
        except RuntimeError as e:
            stopped = str(e)
            print(f"the smoke run stopped: {e}")
        sys.exit(smoke_report(out, stopped))
    if a.cmd == "run":
        fc = Ly.frozen()
        smoke = R.smoke_passed(a.family, fc["hashes"], root=HERE)
        meta = {"kind": "scored", "test": a.test, "family": a.family, "seed": Ly.SEED,
                "freeze_commit": fc["freeze_commit"], "head": fc["head"], "pin": R.pin(a.family), "smoke": smoke,
                "links": {fc["link"]: fc["hashes"]}, "link_commits": {fc["link"]: fc["commits"][fc["link"]]}}
        out = results(a.test, a.family)
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
        guard = R.SpendGuard(a.max_usd, MAX_CALLS[a.test])
        guard.usd, guard.calls = sink.spent, len(R.logged(out))
        Ly.run_batches(out, TESTS[a.test], a.family, cl.OpenRouterClient(), guard, R.catalog_slug, fc["link"],
                       parallel=a.parallel)
        print(f"done: {a.test} for {a.family} in {out}")
        return
    if a.cmd == "verdicts":
        print(json.dumps(verdicts(a.test, final=a.final), indent=1, default=str))


def verdicts(test, root=None, allow_dry=False, frozen_=None, final=False):
    """Every pin's folder under results/<test>/ read by layer.load, then the test's rule; written to
    results/<test>/verdicts.json with the link and commits it was read under."""
    root = Path(root or HERE / "results" / test)
    loaded, metas = {}, {}
    for fam, role in pins():
        folder = root / fam.replace("/", "__")
        if not (folder / "meta.json").exists():
            continue
        meta, recs, log = Ly.load(folder, TESTS[test], allow_dry=allow_dry, frozen_=frozen_)
        loaded[fam], metas[fam] = (meta, recs, log), {k: meta.get(k) for k in
                                                      ("read_under", "made_again", "partial_contexts", "unmade")}
    present = [(f, r) for f, r in pins() if f in loaded]
    if test == "tr4":
        sums = {f: rule4.summary(loaded[f][0], loaded[f][1], loaded[f][0]["unmade"]) for f, _ in present}
        out = rule4.verdicts(sums, HERE / "results" / "power.json", final=final)
    else:
        out = rule5.verdicts(lambda f: VerdictView(loaded[f][2], loaded[f][1]), present, lambda f: loaded[f][1])
    out["folders"] = metas
    (root / "verdicts.json").write_text(json.dumps(out, indent=1, default=str) + "\n")
    return out


class VerdictView:
    """The log as the rule reads it: only the records layer.load read (good, in a context wholly
    read) count as good; every other logged record is bad, so its attempt is not read."""

    def __init__(self, log, recs):
        self.log, self.read = log, {r["id"] for r in recs}
        self.by_id = log.by_id

    def status(self, call_id):
        st = self.log.status(call_id)
        if st is None:
            return None
        return "good" if call_id in self.read else "bad"

    def answer(self, call_id):
        return self.log.answer(call_id)

    def numbers(self, call_id):
        return self.log.numbers(call_id)


if __name__ == "__main__":
    main()
