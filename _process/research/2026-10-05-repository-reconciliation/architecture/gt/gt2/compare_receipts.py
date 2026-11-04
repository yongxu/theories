#!/usr/bin/env python3
"""Compare a core receipt written by GT2's checker with one written by the checker before it, on one tree.

usage: python3 -B compare_receipts.py BEFORE.json AFTER.json

Every field must be equal except those naming the run (`utc`, `retained_run`, `artifact_sha256`), the
checker's own bytes (`checker_sha256`, `source_commit`, which names the checker as copied where main does
not hold it) and `lean_steps`. In `lean_steps` the two runs must list the same steps; a step's key may differ
only where GT2 changed its inputs (the environment audit's driver; the compiles from the prelude, which no
longer carry a tag), and every compile from the prelude whose key changed must now have its module's key
or a key no step of the earlier run had. Prints what differs and exits 1 if anything else does.
"""
import json
import sys

RUN_FIELDS = {"utc", "retained_run", "artifact_sha256", "checker_sha256", "source_commit", "lean_steps"}


def main():
    before, after = (json.load(open(path)) for path in sys.argv[1:3])
    problems, report = [], {}
    for field in sorted(set(before) | set(after)):
        if field not in RUN_FIELDS and before.get(field) != after.get(field):
            problems.append(f"field {field} differs")
    b, a = before["lean_steps"], after["lean_steps"]
    logs_b, logs_a = set(b["ran"]) | set(b["reused"]), set(a["ran"]) | set(a["reused"])
    if logs_b != logs_a:
        problems.append(f"steps differ: {sorted(logs_b ^ logs_a)[:10]}")
    changed = sorted(log for log in b["keys"] if b["keys"][log] != a["keys"].get(log))
    allowed = {log for log in changed if log == "EnvironmentAudit.log" or log.endswith(".PreludeOnly.log")}
    problems += [f"key of {log} changed" for log in changed if log not in allowed]
    earlier = set(b["keys"].values())
    shared, new = [], []
    for log in sorted(allowed - {"EnvironmentAudit.log"}):
        module = a["keys"].get(log[:-len(".PreludeOnly.log")] + ".log")
        if a["keys"][log] == module:
            shared.append(log)
        elif a["keys"][log] in earlier:
            problems.append(f"{log} took another step's key")
        else:
            new.append(log)
    report.update({
        "fields_compared": len(set(before) - RUN_FIELDS), "steps": len(logs_a),
        "before": {"ran": len(b["ran"]), "reused": len(b["reused"])},
        "after": {"ran": len(a["ran"]), "reused": len(a["reused"]), "wall_seconds": a.get("wall_seconds"),
                  "seconds_ran": round(sum(a.get("seconds", {}).values()), 1)},
        "keys_changed": len(changed), "prelude_keys_now_their_modules": len(shared), "prelude_keys_new": len(new),
        "environment_audit_seconds": a.get("seconds", {}).get("EnvironmentAudit.log"),
        "slowest": sorted(a.get("seconds", {}).items(), key=lambda kv: -kv[1])[:5],
        "problems": problems})
    print(json.dumps(report, indent=2))
    return 1 if problems else 0


if __name__ == "__main__":
    raise SystemExit(main())
