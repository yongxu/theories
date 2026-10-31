#!/usr/bin/env python3
"""RV21c: compare each renewed periphery receipt with the one it replaces (PR1's compare.py, on the kit's list).

For every receipt that passed (`out/status.json`): the committed one (at BASE, default HEAD) and the new one. Reports
the declarations added or removed, the axiom reports that changed, and the printed signature of each theorem where
both runs kept a Signatures log (the run folder, or for an old reused step the step cache). `swap_stamps.py` reads
this: a record's stamp is swapped only where its cited declarations are unchanged.

usage: compare.py [BASE]   -> writes out/compare.json and prints a summary
"""
import json
import os
from pathlib import Path
import re
import sys

from kit import OUT, RECEIPTS, REPO, load, stem

CACHE = Path.home() / ".cache/becoming-lean"


def modules(d):
    return {m["module"]: m for m in d.get("modules", [])}


def signatures(pointer, d):
    """Map declaration -> printed type from the run's Signatures log, if kept."""
    base = (REPO / pointer).parent / d["retained_run"]
    target = d.get("bridge_module") or d.get("instance_module") or d.get("module")
    if not target:
        return None
    log = base / (target + "Signatures.log")
    text = None
    if log.exists():
        text = log.read_text()
    else:
        key = d.get("lean_steps", {}).get("keys", {}).get(target + "Signatures.log")
        # The step cache the run itself names, then this slot's, then the default.
        caches = [Path(c) for c in (d.get("lean_steps", {}).get("cache"), os.environ.get("RV21C_CACHE")) if c] + [CACHE]
        for cache in caches:
            entry = cache / (key + ".json") if key else None
            if entry and entry.exists():
                text = json.loads(entry.read_text())["log"]
                break
    if text is None:
        return None
    out, name = {}, None
    for line in text.splitlines():
        m = re.match(r"^(@?[^\s:]+) :(.*)$", line)
        if m:
            name = m[1].lstrip("@")
            out[name] = m[2].strip()
        elif name and line.startswith(" "):
            out[name] += " " + line.strip()
    return {k: re.sub(r"\s+", " ", v) for k, v in out.items()}


def main():
    base = sys.argv[1] if len(sys.argv) > 1 else "HEAD"
    status = json.loads((OUT / "status.json").read_text())
    report = {}
    for pointer in RECEIPTS:
        s = stem(pointer)
        if not status.get(s, {}).get("passed"):
            continue
        old, new = load(pointer, base), load(pointer)
        om, nm = modules(old), modules(new)
        row = {"old_utc": old["utc"], "new_utc": new["utc"], "status": new["status"], "modules": {}}
        for name in sorted(set(om) | set(nm)):
            o, n = om.get(name, {}), nm.get(name, {})
            od = {x["name"] for x in o.get("declarations", [])}
            nd = {x["name"] for x in n.get("declarations", [])}
            oa, na = o.get("axiom_dependencies", {}), n.get("axiom_dependencies", {})
            row["modules"][name] = {
                "theorems": [o.get("theorems"), n.get("theorems")],
                "declarations": [len(od), len(nd)],
                "removed": sorted(od - nd), "added": sorted(nd - od),
                "axioms_changed": {k: [oa.get(k), na.get(k)] for k in sorted(od & nd)
                                   if sorted(oa.get(k) or []) != sorted(na.get(k) or [])},
            }
        os_, ns_ = signatures(pointer, old), signatures(pointer, new)
        if os_ is None or ns_ is None:
            row["signatures"] = "old log not kept" if os_ is None else "new log not kept"
        else:
            row["signatures_compared"] = len(set(os_) & set(ns_))
            row["signatures_changed"] = {k: [os_[k], ns_[k]] for k in sorted(set(os_) & set(ns_))
                                         if os_[k] != ns_[k]}
        report[s] = row
    (OUT / "compare.json").write_text(json.dumps(report, indent=1, ensure_ascii=False) + "\n")
    for s, row in report.items():
        summary = "; ".join(f"{k}: thms {v['theorems']}, decls {v['declarations']}, -{len(v['removed'])} "
                            f"+{len(v['added'])}, axioms changed {len(v['axioms_changed'])}"
                            for k, v in row["modules"].items())
        sig = row.get("signatures") or (f"sigs {row['signatures_compared']} compared, "
                                        f"{len(row['signatures_changed'])} changed")
        print(s, row["old_utc"], "->", row["new_utc"], row["status"], "|", summary, "|", sig)


if __name__ == "__main__":
    main()
