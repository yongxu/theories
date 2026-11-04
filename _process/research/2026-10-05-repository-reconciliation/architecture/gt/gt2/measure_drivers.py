#!/usr/bin/env python3
"""Time the per-module drivers (the axiom audit and the signatures) against one merged driver.

usage: python3 -B measure_drivers.py MODULE ...

The checked modules' compiled files are restored from the checker's step cache by their keys, so nothing is
compiled. For each MODULE the script runs the checker's two drivers and one driver holding both, timing each,
and prints the seconds and whether the merged output is the two outputs joined.
"""
import json
import os
import sys
import tempfile
from pathlib import Path

HERE = Path(__file__).resolve()
sys.path.insert(0, str(HERE.parent))
from measure_environment_audit import cb, timed  # noqa: E402


def main():
    targets = sys.argv[1:]
    index = cb.module_index()
    order = cb.closure(index)
    sources = {name: index[name][0].read_bytes() for name in order}
    command, binary, _ = cb.resolve_lean()
    context = [cb.audit_support.TOOLCHAIN, cb.audit_support.digest(binary.read_bytes())]
    keys = cb.module_keys(context, sources, order)
    needed = cb.closure(index, targets)
    with tempfile.TemporaryDirectory(prefix="gt2-drivers-") as scratch:
        work = Path(scratch)
        for name in needed:
            target = work / cb.source_file(name)
            target.parent.mkdir(parents=True, exist_ok=True)
            target.write_bytes(sources[name])
            assert cb.reuse(keys[name], [work / (cb.source_file(name)[:-5] + ".olean")]), name
        env = {**os.environ, "LEAN_PATH": str(work)}
        rows = []
        for name in targets:
            registry = cb.declarations(sources[name])
            audit = "\n".join("#print axioms " + item["name"] for item in registry)
            signatures = "\n".join("#check @" + item["name"] for item in registry if item["kind"] == "theorem")
            row = {"module": name, "imports_closure": len(cb.closure(index, [name])),
                   "declarations": len(registry)}
            outs = {}
            for label, body in (("audit", audit), ("signatures", signatures), ("merged", audit + "\n" + signatures)):
                (work / "Driver.lean").write_text("import " + name + "\n" + body + "\n")
                code, out, wall, cpu = timed(command + ["Driver.lean"], work, env)
                assert code == 0, out[-2000:]
                outs[label] = out
                row[label + "_s"] = round(wall, 2)
            row["merged_is_joined"] = outs["merged"] == outs["audit"] + outs["signatures"]
            rows.append(row)
        print(json.dumps({"load": os.getloadavg(), "rows": rows}, indent=2))


if __name__ == "__main__":
    main()
