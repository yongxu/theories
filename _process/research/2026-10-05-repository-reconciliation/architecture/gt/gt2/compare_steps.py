#!/usr/bin/env python3
"""Compare every step of a fresh run of GT2's checker with the old checker's result for the same step.

usage: python3 -B compare_steps.py snapshot BEFORE.json DIR
       python3 -B compare_steps.py compare BEFORE.json DIR AFTER.json

BEFORE.json is a core receipt the old checker wrote; every step its run listed has an entry in the step cache under
the key the receipt names, holding the step's log and its outputs' digests as the old checker stored them. `snapshot`
copies those entries into DIR, since a fresh run stores its own results under the same keys. `compare` reads AFTER.json,
a receipt of the new checker run fresh (every step ran, none reused), and for each step, by its log's name, compares
the log the fresh run kept in its run folder and the digests it stored in the cache with the old ones in DIR. A step
whose key GT2 changed (the environment audit, the compiles from the prelude) is compared by its log's name all the
same. Prints the counts and every step that differs; exits 1 if any does.
"""
import json
import shutil
import sys
from pathlib import Path

REPO = Path(__file__).resolve().parents[6]
LEAN = REPO / "experiments/integrated-correction/general-framework/generative-basis/lean"


def run_folder(receipt):
    shown = Path(receipt["retained_run"])
    for base in (Path(), REPO, LEAN, LEAN / "becoming"):
        if (base / shown).is_dir():
            return base / shown
    raise SystemExit(f"run folder not found: {shown}")


def snapshot(before_path, out):
    before = json.loads(Path(before_path).read_text())
    cache = Path(before["lean_steps"]["cache"])
    out.mkdir(parents=True, exist_ok=True)
    missing = []
    for log, key in before["lean_steps"]["keys"].items():
        entry = cache / (key + ".json")
        if entry.is_file():
            shutil.copyfile(entry, out / (key + ".json"))
        else:
            missing.append(log)
    version = run_folder(before) / "version.log"
    shutil.copyfile(version, out / "version.log")
    print(json.dumps({"entries": len(before["lean_steps"]["keys"]) - len(missing), "missing": missing}))
    return 1 if missing else 0


def compare(before_path, out, after_path):
    before, after = (json.loads(Path(p).read_text()) for p in (before_path, after_path))
    steps = after["lean_steps"]
    cache, folder = Path(steps["cache"]), run_folder(after)
    problems, same_log, same_outputs = [], 0, 0
    if not steps.get("fresh") or steps["reused"]:
        problems.append("the later run was not fresh: it reused %d steps" % len(steps["reused"]))
    old_logs = set(before["lean_steps"]["ran"]) | set(before["lean_steps"]["reused"])
    if set(steps["ran"]) != old_logs:
        problems.append("the runs list different steps: %s" % sorted(set(steps["ran"]) ^ old_logs)[:10])
    for log in steps["ran"]:
        new_log = (folder / log).read_text()
        if log == "version.log":
            old = {"log": (out / "version.log").read_text(), "outputs": []}
            new_outputs = []
        else:
            old = json.loads((out / (before["lean_steps"]["keys"][log] + ".json")).read_text())
            entry = json.loads((cache / (steps["keys"][log] + ".json")).read_text())
            new_outputs = entry["outputs"]
            if entry["run"].get("utc") != after["utc"]:
                problems.append(f"{log}: its cache entry is not the fresh run's")
        if new_log == old["log"]:
            same_log += 1
        else:
            problems.append(f"{log}: the log differs")
        if new_outputs == old["outputs"]:
            same_outputs += 1
        else:
            problems.append(f"{log}: the outputs differ")
    print(json.dumps({"steps": len(steps["ran"]), "fresh": steps.get("fresh"), "reused": len(steps["reused"]),
                      "same_log": same_log, "same_outputs": same_outputs, "wall_seconds": steps.get("wall_seconds"),
                      "seconds_of_lean": round(sum(steps.get("seconds", {}).values()), 1),
                      "problems": problems}, indent=2))
    return 1 if problems else 0


def main():
    what = sys.argv[1] if len(sys.argv) > 1 else ""
    if what == "snapshot" and len(sys.argv) == 4:
        return snapshot(sys.argv[2], Path(sys.argv[3]))
    if what == "compare" and len(sys.argv) == 5:
        return compare(sys.argv[2], Path(sys.argv[3]), sys.argv[4])
    print(__doc__)
    return 2


if __name__ == "__main__":
    raise SystemExit(main())
