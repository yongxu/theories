#!/usr/bin/env python3
"""Bind WU's record a-way-of-units to the core run (AI-written kit, 13 November 2026; adapted from TT's kit,
tt-turning-in-time/kit/fill_records.py, for one record).

usage: python3 -B fill_records.py [RECEIPT_TIMESTAMP] [--dry-run]

Run from the repository root of the clean landing worktree, after the core run whose receipt binds the final bytes of
WayOfUnits.lean, and after every file the record cites is final (the study's NOTE.md, READER.md, DESIGN.md,
DESIGN-attacked.md, readers/r3-logic.md and readers/v2-premises.md, 02-MAP.md, the sources file): a later edit to any
of them drifts the record.

Without a timestamp the kit takes the run the live receipt names (`retained_run` of becoming-verification.json).
For the record it
  - refuses, writing nothing, if any referenced file is missing, if the receipt did not pass, if the receipt does not
    bind a proof source's current sha256, if a declaration the record names is not among those the receipt lists for
    its module, or if 02-MAP.md has no anchor r-<id>;
  - sets the receipt reference to that run's verification.json (the draft holds a placeholder path);
  - sets the sha256 of every reference to the file's current bytes;
  - writes one proof binding per Lean proof source, pointer /source_sha256/Becoming.<Module>, as K2's kit did;
  - sets reviewed_at_utc to now (UTC, seconds).
The record is written only when it passes. With --dry-run nothing is written.
"""
import hashlib
import json
import re
import sys
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path.cwd()
LEAN = "experiments/integrated-correction/general-framework/generative-basis/lean/becoming"
LIVE = f"{LEAN}/becoming-verification.json"
CH02 = "theories/becoming/chapters/02-MAP.md"
RECORDS = ROOT / "theories/becoming/results/records"
IDS = ("a-way-of-units",)
RUN = re.compile(r"/becoming-checks/[^/]+/verification\.json$")


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


def fail(message):
    sys.exit(f"fill_records: {message}; nothing written")


def module_of(path):
    """Becoming/WayOfUnits.lean -> Becoming.WayOfUnits (the package names modules by path)."""
    rel = path[len(LEAN) + 1:]
    return rel[:-len(".lean")].replace("/", ".")


def fill(record, receipt_path, receipt, now, anchors):
    ident = record["id"]
    if f"r-{ident}" not in anchors:
        fail(f"{ident}: {CH02} has no anchor r-{ident}")
    receipts = [r for r in record["references"] if r["role"] == "receipt"]
    if len(receipts) != 1 or not RUN.search(receipts[0]["path"]):
        fail(f"{ident}: expected exactly one receipt reference under becoming-checks/")
    receipts[0]["path"] = receipt_path
    for ref in record["references"]:
        if not (ROOT / ref["path"]).is_file():
            fail(f"{ident}: referenced file missing: {ref['path']}")
    elaborated = {m.get("module"): {d.get("name") for d in m.get("declarations", [])}
                  for m in receipt.get("modules", []) if isinstance(m, dict)}
    bindings = []
    for ref in record["references"]:
        ref["sha256"] = sha(ref["path"])
        if ref["role"] != "proof" or not ref["path"].endswith(".lean"):
            continue
        module = module_of(ref["path"])
        bound = receipt.get("source_sha256", {}).get(module)
        if bound != ref["sha256"]:
            fail(f"{ident}: {receipt_path} binds {module} at {bound}, not its current bytes {ref['sha256']}")
        unknown = [d for d in ref.get("declarations", []) if d not in elaborated.get(module, set())]
        if unknown:
            fail(f"{ident}: not elaborated in {module} by that run: {', '.join(unknown)}")
        bindings.append({"source": ref["path"], "receipt": receipt_path,
                         "sha256_pointer": f"/source_sha256/{module}",
                         "success_pointer": "/status", "success_value": "passed"})
    if not bindings:
        fail(f"{ident}: no Lean proof source to bind")
    record["proof_bindings"] = bindings
    record["reviewed_at_utc"] = now
    return record


def main(argv):
    dry = "--dry-run" in argv
    args = [a for a in argv if a != "--dry-run"]
    if not (ROOT / LIVE).is_file():
        fail(f"run from the repository root: {LIVE} not found")
    stamp = args[0] if args else json.loads((ROOT / LIVE).read_text())["retained_run"].rsplit("/", 1)[-1]
    receipt_path = f"{LEAN}/becoming-checks/{stamp}/verification.json"
    if not (ROOT / receipt_path).is_file():
        fail(f"receipt missing: {receipt_path}")
    receipt = json.loads((ROOT / receipt_path).read_text())
    if receipt.get("status") != "passed":
        fail(f"{receipt_path} records status {receipt.get('status')!r}, not passed")
    anchors = set(re.findall(r'<a id="([^"]+)"></a>', (ROOT / CH02).read_text()))
    now = datetime.now(timezone.utc).replace(microsecond=0).isoformat()
    out = []
    for ident in IDS:
        path = RECORDS / f"{ident}.json"
        out.append((path, fill(json.loads(path.read_text()), receipt_path, receipt, now, anchors)))
    for path, record in out:
        if not dry:
            path.write_text(json.dumps(record, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
        print(("would write" if dry else "wrote"), path.relative_to(ROOT), "bound to", stamp)


if __name__ == "__main__":
    main(sys.argv[1:])
