#!/usr/bin/env python3
"""RV21c: every receipt a record's proof binding names, and whether it binds bytes that differ from a revision's.

Read-only. For each run a proof binding names (`receipt`, a retained run's verification.json), every module
in that run's `source_paths` is compared with `git show REV:path`. A receipt is stale when any differs.
Prints, per stale receipt, its checker, the records binding it and the modules that differ; then the
pointer (`*-verification.json`) of each checker, so a rerun can be planned by checker.

usage: stale_bound.py [REV] [--json OUT]
"""
import hashlib
import json
from pathlib import Path
import subprocess
import sys

HERE = Path(__file__).resolve().parent
REPO = HERE.parents[5]
LEAN = REPO / "experiments/integrated-correction/general-framework/generative-basis/lean"
RECORDS = REPO / "theories/becoming/results/records"


def sha_at(rev, path, cache={}):
    key = (rev, path)
    if key not in cache:
        p = subprocess.run(["git", "show", f"{rev}:{path}"], cwd=REPO, capture_output=True)
        cache[key] = hashlib.sha256(p.stdout).hexdigest() if p.returncode == 0 else None
    return cache[key]


def resolve(rel, base):
    for root in (LEAN, base, REPO / "experiments", REPO):
        path = (root / rel).resolve()
        if path.exists():
            return path
    return (LEAN / rel).resolve()


def main():
    args = [a for a in sys.argv[1:] if not a.startswith("--")]
    rev = args[0] if args else "main"
    out_json = sys.argv[sys.argv.index("--json") + 1] if "--json" in sys.argv else None
    bound = {}
    for path in sorted(RECORDS.glob("*.json")):
        rec = json.loads(path.read_text())
        for b in rec.get("proof_bindings", []):
            r = b.get("receipt")
            if r:
                bound.setdefault(r, set()).add(rec.get("id", path.stem))
    report = {}
    for receipt, ids in sorted(bound.items()):
        rp = REPO / receipt
        if not rp.exists():
            report[receipt] = {"missing": True, "records": sorted(ids)}
            continue
        d = json.loads(rp.read_text())
        differ = []
        for name, rel in d.get("source_paths", {}).items():
            path = resolve(rel, rp.parent.parent)
            if sha_at(rev, str(path.relative_to(REPO))) != d["source_sha256"].get(name):
                differ.append(name)
        checker = next(iter(d.get("checker_sha256", {})), None)
        runs = rp.parent.parent
        report[receipt] = {"utc": d.get("utc"), "status": d.get("status"), "checker": checker,
                           "runs": str(runs.relative_to(REPO)), "records": sorted(ids), "differ": differ,
                           "core": runs.name == "becoming-checks"}
    stale = {r: v for r, v in report.items() if v.get("differ")}
    by_runs = {}
    for r, v in stale.items():
        by_runs.setdefault((v["runs"], v["checker"]), []).append(r)
    for (runs, checker), rs in sorted(by_runs.items()):
        ids = sorted({i for r in rs for i in stale[r]["records"]})
        n = max(len(stale[r]["differ"]) for r in rs)
        print(f"{runs}  [{checker}]  runs {len(rs)}  records {len(ids)}  modules differ up to {n}")
    missing = [r for r, v in report.items() if v.get("missing")]
    core = [r for r, v in stale.items() if v["core"]]
    print(f"BOUND RUNS {len(report)}; STALE {len(stale)} in {len(by_runs)} checkers "
          f"({len(core)} core runs); MISSING {len(missing)}")
    if out_json:
        Path(out_json).write_text(json.dumps(report, indent=1, ensure_ascii=False) + "\n")


if __name__ == "__main__":
    main()
