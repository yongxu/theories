#!/usr/bin/env python3
"""RV21c: run the stale periphery checkers one at a time, on this slot's own step cache.

Run from the checkout root of the landing worktree, after the fresh core run, with `RV21C_CACHE` set to the folder
the core run used as `BECOMING_LEAN_CACHE` (empty before it). A checker then reuses only steps an earlier run of this
slot ran under the same toolchain and kept the log of: the core run, or an earlier periphery checker (the keys hash
the toolchain and the Lean binary, so the checkers on 4.30.0-rc2 share none with the core run). No step comes from a
build no one kept (the flaw item 9 names is reuse of such steps, not reuse as such); `verify_runs.py` counts, for each
receipt, the steps it reused by the run they came from. `RV21C_FRESH=1` adds `BECOMING_FRESH=1`
(every step run, no reuse at all). Mathlib is the pinned build the checkers find, never rebuilt here.
Each checker writes its retained run and its pointer as it always does. A checker that fails is a finding, not something to fix here: whatever run folder it wrote (with the failing
log, if it got that far) stays where the checker wrote it, its pointer is restored to the committed one, so the
records binding it keep their binding, and it is listed in `out/status.json` and named in the landed clause. A
checker can fail before it writes its receipt; its row then has no `utc` or `retained_run`, `new_folders` lists the
stamp folders it created (perhaps empty, which git does not keep), and `out/<stem>.log` is its kept log.
Writes `out/<stem>.log` (the checker's output) and `out/status.json`.

usage: run_periphery.py [STEM ...]   (default: every receipt in kit.RECEIPTS, in its order)
"""
import json
import os
import subprocess
import sys
import time

from kit import OUT, RECEIPTS, REPO, checker, git, load, runs_folder, stem


def main():
    OUT.mkdir(exist_ok=True)
    wanted = set(sys.argv[1:])
    status_path = OUT / "status.json"
    status = json.loads(status_path.read_text()) if status_path.exists() else {}
    cache = os.environ.get("RV21C_CACHE")
    assert cache and os.path.isdir(cache), "set RV21C_CACHE to this slot's step cache (the core run's)"
    env = {k: v for k, v in os.environ.items() if k != "BECOMING_FRESH"}
    env["BECOMING_LEAN_CACHE"] = cache
    if os.environ.get("RV21C_FRESH") == "1":
        env["BECOMING_FRESH"] = "1"
    for pointer in RECEIPTS:
        s = stem(pointer)
        if wanted and s not in wanted:
            continue
        old = load(pointer, "HEAD")
        script = REPO / checker(pointer)
        folder = REPO / runs_folder(pointer, old)
        before = {f.name for f in folder.iterdir()} if folder.is_dir() else set()
        start = time.time()
        p = subprocess.run([sys.executable, "-B", str(script)], cwd=REPO, env=env, text=True,
                           stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
        (OUT / (s + ".log")).write_text(p.stdout)
        try:
            new = load(pointer)
        except (OSError, ValueError):
            new = {}
        wrote = bool(new) and new.get("utc") != old["utc"]
        passed = p.returncode == 0 and wrote and new.get("status") == "passed"
        created = sorted(f.name for f in folder.iterdir()
                         if f.is_dir() and f.name not in before) if folder.is_dir() else []
        row = {"exit": p.returncode, "status": new.get("status") if wrote else None,
               "utc": new.get("utc") if wrote else None,
               "retained_run": new.get("retained_run") if wrote else None,
               "new_folders": [f"{runs_folder(pointer, old)}/{n}" for n in created
                               if any((folder / n).iterdir())],
               "empty_new_folders": [n for n in created if not any((folder / n).iterdir())],
               "previous_utc": old["utc"], "seconds": round(time.time() - start), "passed": passed,
               "tail": p.stdout[-2000:]}
        if not passed:
            # The failing run stays as the checker left it; the pointer goes back to the committed receipt.
            git("checkout", "HEAD", "--", pointer)
            row["pointer_restored"] = True
        status[s] = row
        status_path.write_text(json.dumps(status, indent=2, ensure_ascii=False) + "\n")
        print(s, "passed" if passed else "FAILED", p.returncode, row["status"], row["utc"],
              f"{row['seconds']}s", flush=True)
    failed = [s for s, r in status.items() if not r["passed"]]
    print("FAILED:", " ".join(failed) if failed else "none")


if __name__ == "__main__":
    main()
