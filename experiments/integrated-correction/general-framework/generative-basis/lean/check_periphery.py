#!/usr/bin/env python3
"""Unified manifest driver and staleness auditor for active Becoming periphery Lean modules.

Reads `periphery-manifest.json` beside this script. Supports:
  --all           Run every periphery checker listed in the manifest sequentially.
  --module NAME   Run only the named module(s) (repeatable).
  --stale-only    Run only modules whose receipt is missing, non-passed, or stale on any source/dep.
  --check-stale   Read-only audit of all manifest receipts against live file SHA-256 digests;
                  exits 0 iff every active periphery receipt is `passed` with 0 stale sources/deps.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import os
from pathlib import Path
import subprocess
import sys

sys.dont_write_bytecode = True
LEAN_ROOT = Path(__file__).resolve().parent
MANIFEST = LEAN_ROOT / "periphery-manifest.json"


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def audit_entry(entry: dict) -> dict:
    receipt_path = LEAN_ROOT / entry["receipt"]
    problems = []
    status = None
    utc = None
    if not receipt_path.is_file():
        problems.append("missing receipt")
    else:
        data = json.loads(receipt_path.read_text(encoding="utf-8"))
        status = data.get("status")
        utc = data.get("utc")
        if status != "passed":
            problems.append(f"status={status!r}")
        expected_hashes = data.get("source_sha256") or {}
        source_paths = data.get("source_paths") or {}
        own_rel = entry["source"]
        if own_rel not in source_paths.values():
            problems.append(f"own source {own_rel} missing from receipt")
        for mod, rel in source_paths.items():
            f = LEAN_ROOT / rel
            if not f.is_file():
                problems.append(f"missing {rel}")
            elif sha256(f) != expected_hashes.get(mod):
                kind = "own-source" if rel == own_rel else "dependency"
                problems.append(f"stale {kind}: {rel}")
    return {
        "module": entry["module"],
        "receipt": entry["receipt"],
        "status": status,
        "utc": utc,
        "stale": bool(problems),
        "problems": problems,
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--all", action="store_true", help="Run all active periphery checkers")
    mode.add_argument("--module", action="append", default=[], help="Run named periphery module(s)")
    mode.add_argument("--stale-only", action="store_true", help="Run only stale/missing checkers")
    mode.add_argument("--check-stale", action="store_true", help="Read-only audit of all receipts")
    args = parser.parse_args()

    manifest = json.loads(MANIFEST.read_text(encoding="utf-8"))
    entries = manifest["modules"]
    by_name = {e["module"]: e for e in entries}

    if args.check_stale:
        audits = [audit_entry(e) for e in entries]
        stale = [a["module"] for a in audits if a["stale"]]
        print(json.dumps({"total": len(audits), "stale_count": len(stale), "stale": stale, "modules": audits}, indent=2))
        return 0 if not stale else 1

    if args.all:
        targets = entries
    elif args.module:
        unknown = [m for m in args.module if m not in by_name]
        if unknown:
            print(json.dumps({"error": f"Unknown periphery module(s): {unknown}", "known": list(by_name)}), file=sys.stderr)
            return 2
        targets = [by_name[m] for m in args.module]
    else:
        targets = [e for e in entries if audit_entry(e)["stale"]]

    results = []
    failed = []
    env = os.environ.copy()
    for e in targets:
        checker = LEAN_ROOT / e["checker"]
        proc = subprocess.run([sys.executable, "-B", str(checker)], env=env, text=True,
                              stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
        last_line = proc.stdout.strip().splitlines()[-1] if proc.stdout.strip() else ""
        ok = proc.returncode == 0
        results.append({"module": e["module"], "checker": e["checker"], "returncode": proc.returncode, "output": last_line})
        if not ok:
            failed.append(e["module"])
            print(proc.stdout, file=sys.stderr)

    post_audits = [audit_entry(e) for e in entries]
    stale_after = [a["module"] for a in post_audits if a["stale"]]
    print(json.dumps({
        "ran": [r["module"] for r in results],
        "failed": failed,
        "stale_after_count": len(stale_after),
        "stale_after": stale_after,
        "results": results,
    }, indent=2))
    return 0 if not failed else 1


if __name__ == "__main__":
    raise SystemExit(main())
