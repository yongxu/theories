#!/usr/bin/env python3
"""Bind DJ's new record a-line-on-a-stock to the core run (AI-written kit, 16 November 2026; adapted from WU's kit,
wu-a-way-of-units/kit/fill_records.py, for a record whose anchor is in its study NOTE.md and whose proof sources are
two modules). Run from the root of the landing worktree.

usage: python3 -B _process/research/2026-10-05-generative-foundation-review/root-foundation/development/dj-a-line-on-a-stock/kit/fill_records.py [RECEIPT_TIMESTAMP] [--dry-run]

It refuses, writing nothing, if a referenced file is missing, if the receipt did not pass, if the receipt does not bind
a proof source's current sha256, if a declaration the record names is not among those the receipt lists for its
module, or if the study NOTE.md has no anchor r-<id>. Otherwise it sets the receipt reference to that run, the sha256
of every reference to the file's current bytes, one proof binding per Lean proof source (pointer
/source_sha256/Becoming.<Module>), and reviewed_at_utc to now.
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
NOTE = "_process/research/2026-10-05-generative-foundation-review/root-foundation/development/dj-a-line-on-a-stock/NOTE.md"
RECORDS = ROOT / "theories/becoming/results/records"
IDS = ("a-line-on-a-stock",)
RUN = re.compile(r"/becoming-checks/[^/]+/verification\.json$")


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


def fail(message):
    sys.exit(f"fill_dj: {message}; nothing written")


def module_of(path):
    rel = path[len(LEAN) + 1:]
    return rel[:-len(".lean")].replace("/", ".")


def fill(record, receipt_path, receipt, now, anchors):
    ident = record["id"]
    if f"r-{ident}" not in anchors:
        fail(f"{ident}: {NOTE} has no anchor r-{ident}")
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
    if len(bindings) != 2:
        fail(f"{ident}: expected two Lean proof sources, found {len(bindings)}")
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
    anchors = set(re.findall(r'<a id="([^"]+)"></a>', (ROOT / NOTE).read_text()))
    now = datetime.now(timezone.utc).replace(microsecond=0).isoformat()
    for ident in IDS:
        path = RECORDS / f"{ident}.json"
        record = fill(json.loads(path.read_text()), receipt_path, receipt, now, anchors)
        if not dry:
            path.write_text(json.dumps(record, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
        print(("would write" if dry else "wrote"), path.relative_to(ROOT), "bound to", stamp)


if __name__ == "__main__":
    main(sys.argv[1:])
