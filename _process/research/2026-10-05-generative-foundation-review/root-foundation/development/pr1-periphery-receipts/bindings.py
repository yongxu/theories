#!/usr/bin/env python3
"""PR1: which records bind each periphery receipt (proof bindings and references to its retained runs).

usage: bindings.py   -> prints JSON {receipt stem: {record id: [{kind, source, receipt}]}}
"""
import json
from pathlib import Path
import sys

HERE = Path(__file__).resolve().parent
REPO = HERE.parents[5]
sys.path.insert(0, str(HERE.parent / "pe2-propext-uses"))
from uses import RECEIPTS  # noqa: E402

RECORDS = REPO / "theories/becoming/results/records"


def main():
    out = {}
    runs = {}
    for receipt in RECEIPTS[:-1]:
        d = json.loads((REPO / receipt).read_text())
        folder = str(Path(receipt).parent / d["retained_run"].split("/")[0]) + "/"
        runs[Path(receipt).stem] = folder
    for path in sorted(RECORDS.glob("*.json")):
        rec = json.loads(path.read_text())
        for b in rec.get("proof_bindings", []):
            for stem, folder in runs.items():
                if b.get("receipt", "").startswith(folder):
                    out.setdefault(stem, {}).setdefault(rec.get("id", path.stem), []).append(
                        {"kind": "binding", "source": b.get("source"), "receipt": b["receipt"]})
        for r in rec.get("references", []):
            for stem, folder in runs.items():
                if r.get("path", "").startswith(folder):
                    out.setdefault(stem, {}).setdefault(rec.get("id", path.stem), []).append(
                        {"kind": "reference:" + r.get("role", ""), "receipt": r["path"]})
    print(json.dumps(out, indent=1, ensure_ascii=False))


if __name__ == "__main__":
    main()
