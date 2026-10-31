#!/usr/bin/env python3
"""RV21c: which records bind each of the 25 periphery receipts, before the reruns.

For every receipt: the records whose proof bindings name its pointer or one of its retained runs (kind `binding`,
with the Lean source bound), and the records whose references name them (kind `reference:<role>`, with the sha256
the reference pins, if any). Run before the checkers, on the revision the runs start from; the output is
`out/bindings-before.json`, which `repoint_all.py` reads.

usage: bindings.py [--out NAME]   -> writes out/NAME (default bindings-before.json) and prints counts
"""
import json
import sys

from kit import OUT, RECEIPTS, RECORDS, REPO, bound_here, load, runs_folder, stem


def main():
    folders = {}
    for pointer in RECEIPTS:
        folders[stem(pointer)] = (pointer, runs_folder(pointer, load(pointer)))
    out = {s: {} for s in folders}
    for path in sorted((REPO / RECORDS).glob("*.json")):
        rec = json.loads(path.read_text())
        rid = rec.get("id", path.stem)
        for b in rec.get("proof_bindings", []):
            for s, (pointer, folder) in folders.items():
                if bound_here(b.get("receipt", ""), pointer, folder):
                    out[s].setdefault(rid, []).append(
                        {"kind": "binding", "source": b.get("source"), "receipt": b["receipt"]})
        for r in rec.get("references", []):
            for s, (pointer, folder) in folders.items():
                if bound_here(r.get("path", ""), pointer, folder):
                    out[s].setdefault(rid, []).append(
                        {"kind": "reference:" + r.get("role", ""), "receipt": r["path"], "sha256": r.get("sha256")})
    OUT.mkdir(exist_ok=True)
    name = sys.argv[sys.argv.index("--out") + 1] if "--out" in sys.argv else "bindings-before.json"
    (OUT / name).write_text(json.dumps(out, indent=1, ensure_ascii=False) + "\n")
    ids = set()
    for s, rows in out.items():
        bound = sorted(r for r, bs in rows.items() if any(b["kind"] == "binding" for b in bs))
        ids.update(bound)
        print(f"{s:50s} binding {len(bound):2d}  citing {len(rows):2d}")
    print("records binding a periphery receipt:", len(ids))


if __name__ == "__main__":
    main()
