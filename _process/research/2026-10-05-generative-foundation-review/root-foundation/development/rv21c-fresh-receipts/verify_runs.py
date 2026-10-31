#!/usr/bin/env python3
"""RV21c: check that the new receipts are what the item promises, before anything is re-pointed.

The core receipt (the pointer's): passed, `lean_steps.fresh`, no step reused, every keyed step run, its log in the
run folder, on this slot's cache (`RV21C_CACHE`), nothing copied (main held every source byte for byte), the sources
unchanged during the check, and every source and checker file it names identical to REV's bytes. Each periphery
receipt that passed: newer than the committed one, on this slot's cache, every step it ran logged in its own run
folder, every step it reused taken from a run of this slot (the core run or an earlier periphery run, passed or kept
as a finding) whose folder holds that step's log, and every source and checker file it names identical to REV's bytes
(so it is not stale on the main it lands on). For each, the reused steps are counted by the run they came from
(`reused_from`: `core` or a checker's stem), which the texts report. Failed checkers are listed with the folders they
wrote, not checked. Also the size of every new run folder and its largest files, to judge whether anything beyond
what a verifier needs makes it much bigger.

usage: RV21C_CACHE=<slot cache> verify_runs.py CORE_UTC [REV] [--no-write]   -> writes out/verify.json (not with
       --no-write, used to re-check the bound bytes against a later main), prints a summary, exits 1 on any failed
       check
"""
import hashlib
import json
import os
from pathlib import Path
import subprocess
import sys

from kit import CORE_POINTER, CORE_RUNS, LEAN, OUT, RECEIPTS, REPO, helper_path, load, stem

LEAN_ROOT = REPO / LEAN


def sha_at(rev, path):
    p = subprocess.run(["git", "show", f"{rev}:{path}"], cwd=REPO, capture_output=True)
    return hashlib.sha256(p.stdout).hexdigest() if p.returncode == 0 else None


def resolve(rel, base):
    for root in (LEAN_ROOT, base, REPO / "experiments", REPO):
        path = (root / rel).resolve()
        if path.exists():
            return path
    return (LEAN_ROOT / rel).resolve()


def folder_size(folder):
    files = [p for p in folder.rglob("*") if p.is_file()]
    big = sorted(files, key=lambda p: p.stat().st_size, reverse=True)[:3]
    return {"files": len(files), "bytes": sum(p.stat().st_size for p in files),
            "largest": [[p.name, p.stat().st_size] for p in big]}


def bytes_check(d, pointer, rev):
    """Problems where a receipt's sources or checker files are not REV's bytes."""
    base = (REPO / pointer).parent
    problems = []
    differ = [name for name, rel in d.get("source_paths", {}).items()
              if sha_at(rev, str(resolve(rel, base).relative_to(REPO))) != d["source_sha256"].get(name)]
    if differ:
        problems.append(f"{len(differ)} sources differ from {rev}: {differ[:5]}")
    if not d.get("source_paths"):
        problems.append("no source_paths")
    checkers = [n for n, h in d.get("checker_sha256", {}).items() if sha_at(rev, helper_path(pointer, n)) != h]
    if checkers:
        problems.append(f"checker files differ from {rev}: {checkers}")
    return problems


def steps_check(d, folder, cache, slot_runs=None):
    """Problems with a receipt's Lean steps. With `slot_runs` (utc -> run folder) reuse is allowed only from those
    runs, each holding the reused step's log; without it, the receipt must be fresh with nothing reused."""
    ls = d.get("lean_steps", {})
    problems = []
    if Path(ls.get("cache", "")).resolve() != Path(cache).resolve():
        problems.append(f"cache {ls.get('cache')} is not this slot's")
    ran, reused, keys = set(ls.get("ran", [])), ls.get("reused", {}), set(ls.get("keys", {}))
    if slot_runs is None:
        if ls.get("fresh") is not True:
            problems.append("not fresh")
        if reused:
            problems.append(f"{len(reused)} steps reused")
    else:
        for name, origin in reused.items():
            utc = origin.get("utc") if isinstance(origin, dict) else None
            where = slot_runs.get(utc)
            if where is None:
                problems.append(f"{name} reused from {utc}, not a run of this slot")
            elif not (where / name).exists():
                problems.append(f"{name} reused from {utc}, whose folder has no such log")
    # Every keyed step either ran or was reused, never both; a step with no key (version.log) only runs.
    if not (set(reused) <= keys and keys <= ran | set(reused)) or ran & set(reused) or len(ran - keys) > 1:
        problems.append(f"ran {len(ran)} and reused {len(reused)} do not cover the {len(keys)} keyed steps once")
    missing = sorted(name for name in ran if not (folder / name).exists())
    if missing:
        problems.append(f"{len(missing)} logs missing from the run folder, e.g. {missing[:3]}")
    return problems


def main():
    args = [a for a in sys.argv[1:] if not a.startswith("--")]
    core_utc = args[0]
    rev = args[1] if len(args) > 1 else "HEAD"
    cache = os.environ.get("RV21C_CACHE")
    assert cache, "set RV21C_CACHE to this slot's step cache"
    report, bad = {}, []
    core = load(CORE_POINTER)
    folder = REPO / CORE_RUNS / core_utc
    problems = []
    if core.get("utc") != core_utc:
        problems.append(f"pointer holds {core.get('utc')}")
    if core.get("status") != "passed":
        problems.append(f"status {core.get('status')}")
    problems += steps_check(core, folder, cache)
    if core.get("source_commit", {}).get("copied"):
        problems.append(f"copied {core['source_commit']['copied']}")
    if core.get("source_unchanged_during_check") is not True:
        problems.append("sources changed during the check")
    problems += bytes_check(core, CORE_POINTER, rev)
    report["core"] = {"utc": core_utc, "modules": len(core.get("modules", [])),
                      "steps": len(core.get("lean_steps", {}).get("keys", {})),
                      "source_commit": core.get("source_commit"), "size": folder_size(folder), "problems": problems}
    if problems:
        bad.append("core")
    status = json.loads((OUT / "status.json").read_text())
    # This slot's runs: the core's and every periphery checker's, passed or kept as a finding.
    slot_runs = {core_utc: REPO / CORE_RUNS / core_utc}
    origin = {core_utc: "core"}
    for pointer in RECEIPTS:
        row = status.get(stem(pointer))
        if row and row.get("retained_run") and row.get("utc") and row["utc"] != row.get("previous_utc"):
            slot_runs[row["utc"]] = (REPO / pointer).parent / row["retained_run"]
            origin[row["utc"]] = stem(pointer)
    for pointer in RECEIPTS:
        s = stem(pointer)
        row = status.get(s)
        if row is None:
            report[s] = {"problems": ["not run"]}
            bad.append(s)
            continue
        if not row["passed"]:
            report[s] = {"failed": True, "utc": row.get("utc"), "retained_run": row.get("retained_run"),
                         "new_folders": row.get("new_folders", []), "log": f"out/{s}.log"}
            continue
        d = load(pointer)
        base = (REPO / pointer).parent
        folder = base / d["retained_run"]
        problems = []
        if d["utc"] != row["utc"] or d["status"] != "passed":
            problems.append("pointer does not hold the passed run")
        problems += steps_check(d, folder, cache, slot_runs)
        problems += bytes_check(d, pointer, rev)
        ls = d.get("lean_steps", {})
        came = {}
        for o in ls.get("reused", {}).values():
            k = origin.get(o.get("utc") if isinstance(o, dict) else None, "?")
            came[k] = came.get(k, 0) + 1
        report[s] = {"utc": d["utc"], "previous_utc": row["previous_utc"], "modules": len(d["source_paths"]),
                     "steps": len(ls.get("keys", {})), "ran": len(ls.get("ran", [])),
                     "reused": len(ls.get("reused", {})), "reused_from": came, "fresh": ls.get("fresh"),
                     "toolchain": d.get("toolchain"),
                     "mathlib_revision": d.get("mathlib_revision"), "seconds": row["seconds"],
                     "source_commit": d.get("source_commit"), "size": folder_size(folder), "problems": problems}
        if problems:
            bad.append(s)
    if "--no-write" not in sys.argv:
        OUT.mkdir(exist_ok=True)
        (OUT / "verify.json").write_text(json.dumps(report, indent=1, ensure_ascii=False) + "\n")
    total = sum(v.get("size", {}).get("bytes", 0) for v in report.values())
    for s, v in report.items():
        if v.get("failed"):
            print(f"{s:50s} FAILED (finding) run {v.get('retained_run') or v.get('new_folders') or v['log']}")
        else:
            size = v.get("size", {})
            print(f"{s:50s} {v.get('utc')} steps {v.get('steps')} files {size.get('files')} "
                  f"{size.get('bytes', 0) / 1e6:.1f} MB {'OK' if not v.get('problems') else v['problems']}")
    print(f"new run folders: {total / 1e6:.1f} MB; checks failed: {' '.join(bad) if bad else 'none'}")
    sys.exit(1 if bad else 0)


if __name__ == "__main__":
    main()
