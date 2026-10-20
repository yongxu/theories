#!/usr/bin/env python3
"""PR1: compare each periphery receipt with the one it replaces.

For every receipt: the old one (at git revision BASE, default HEAD) and the current file. Reports
the declarations added or removed, axiom reports that changed, and the printed signature of each
theorem where both runs kept a Signatures log (the old run's retained folder or the step cache).

usage: compare.py [BASE]   -> writes out/compare.json and prints a summary
"""
import json
from pathlib import Path
import re
import subprocess
import sys

HERE = Path(__file__).resolve().parent
REPO = HERE.parents[5]
sys.path.insert(0, str(HERE.parent / "pe2-propext-uses"))
from uses import RECEIPTS  # noqa: E402

CACHE = Path.home() / ".cache/becoming-lean"


def modules(d):
    return {m["module"]: m for m in d.get("modules", [])}


def signatures(receipt_path, d):
    """Map declaration -> printed type from the run's Signatures log, if kept."""
    base = (REPO / receipt_path).parent / d["retained_run"]
    target = d.get("bridge_module") or d.get("instance_module")
    log = base / (target + "Signatures.log")
    text = None
    if log.exists():
        text = log.read_text()
    else:
        key = d.get("lean_steps", {}).get("keys", {}).get(target + "Signatures.log")
        entry = CACHE / (key + ".json") if key else None
        if entry and entry.exists():
            # a reused step: its log is kept with the cache entry (check_becoming.store)
            text = json.loads(entry.read_text())["log"]
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
    report = {}
    for receipt in RECEIPTS[:-1]:
        old = json.loads(subprocess.check_output(["git", "show", f"{base}:{receipt}"], cwd=REPO))
        new = json.loads((REPO / receipt).read_text())
        om, nm = modules(old), modules(new)
        row = {"old_utc": old["utc"], "new_utc": new["utc"], "status": new["status"]}
        for name in sorted(set(om) | set(nm)):
            o, n = om.get(name, {}), nm.get(name, {})
            od = {x["name"] for x in o.get("declarations", [])}
            nd = {x["name"] for x in n.get("declarations", [])}
            oa, na = o.get("axiom_dependencies", {}), n.get("axiom_dependencies", {})
            row[name] = {
                "theorems": [o.get("theorems"), n.get("theorems")],
                "declarations": [len(od), len(nd)],
                "removed": sorted(od - nd), "added": sorted(nd - od),
                "axioms_changed": {k: [oa.get(k), na.get(k)] for k in sorted(od & nd)
                                   if sorted(oa.get(k) or []) != sorted(na.get(k) or [])},
            }
        os_, ns_ = signatures(receipt, old), signatures(receipt, new)
        if os_ is None or ns_ is None:
            row["signatures"] = "old log not kept" if os_ is None else "new log not kept"
        else:
            row["signatures_compared"] = len(set(os_) & set(ns_))
            row["signatures_changed"] = {k: [os_[k], ns_[k]] for k in sorted(set(os_) & set(ns_))
                                         if os_[k] != ns_[k]}
        report[Path(receipt).stem] = row
    (HERE / "out/compare.json").write_text(json.dumps(report, indent=1, ensure_ascii=False) + "\n")
    for stem, row in report.items():
        mods = {k: v for k, v in row.items() if isinstance(v, dict) and "theorems" in v}
        summary = "; ".join(f"{k}: thms {v['theorems']}, decls {v['declarations']}, -{len(v['removed'])} +{len(v['added'])}, axioms changed {len(v['axioms_changed'])}"
                            for k, v in mods.items())
        sig = row.get("signatures") or f"sigs {row['signatures_compared']} compared, {len(row['signatures_changed'])} changed"
        print(stem, row["old_utc"], "->", row["new_utc"], row["status"], "|", summary, "|", sig)


if __name__ == "__main__":
    main()
