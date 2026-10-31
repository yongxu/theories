#!/usr/bin/env python3
"""RV21c: rebind the records' proof bindings from each periphery receipt's earlier runs to its renewed run.

For each receipt whose checker passed (`out/status.json`): the records whose proof bindings name its pointer or one
of its runs (`out/bindings-before.json`, written by `bindings.py` before the reruns), the Lean sources so bound, and
the renewed run's `verification.json`. Calls `tools/research/repoint.py` once per receipt with `--receipt` that run,
`--lean` those sources and `--ids` those records; repoint.py checks that the run binds each source's current bytes
and passed, and rebinds the matching receipt references. Where a record's reference pins the pointer's own bytes
(two records each for learning-correspondence and representation, whose pointer the rerun rewrote), the pointer is
added to `--paths` and the record to `--ids` (whether or not it binds the receipt), so the pinned sha256 follows. A
record that only cites an earlier run as a reference (a receipt of an earlier statement), and every record of a
checker that failed, is left as it is. No statement changes. The reason logged says how each receipt ran, from
`out/verify.json`: every Lean step run when it reused none, else on this slot's step cache.

Then the older-layout step's receipts (`out/older.json`): each renewed one is its own receipt, rewritten in place by
its checker, so its records' proof bindings keep their path; only the sha256 their references pin follows the new
bytes (`repoint.py --paths` that receipt `--ids` its records), and the reason names the old and new hashes.

usage: repoint_all.py [--apply]   -> prints, per receipt, the records and the bindings rebound; writes out/repoint.json
"""
import datetime as _dt
import json
import subprocess
import sys

from kit import CORE_POINTER, OUT, RECEIPTS, REPO, git, load, run_receipt, stem

REASON = ("RV21c: the periphery receipt renewed on main {how}, after the fresh core receipt {core}; no statement "
          "changed; the receipt's Lean sources rebound to the renewed run")
FRESH = "with every Lean step run"
SLOT = "on this slot's step cache, reusing only steps that earlier runs of this slot ran and kept"


def main():
    apply = "--apply" in sys.argv
    core = load(CORE_POINTER)["utc"]
    before = json.loads((OUT / "bindings-before.json").read_text())
    status = json.loads((OUT / "status.json").read_text())
    verify = json.loads((OUT / "verify.json").read_text())
    report = {}
    for pointer in RECEIPTS:
        s = stem(pointer)
        rows = before.get(s, {})
        bound = sorted(r for r, bs in rows.items() if any(b["kind"] == "binding" for b in bs))
        pinned = sorted({r for r, bs in rows.items() for b in bs
                         if b["kind"].startswith("reference") and b["receipt"] == pointer and b.get("sha256")})
        ids = sorted(set(bound) | set(pinned))
        if not status.get(s, {}).get("passed"):
            report[s] = {"skipped": "checker failed; bindings kept", "records": ids}
            print(s, "FAILED: kept", len(ids), "records on their binding")
            continue
        if not ids:
            report[s] = {"records": []}
            print(s, "no record binds it")
            continue
        lean = sorted({b["source"] for bs in rows.values() for b in bs if b["kind"] == "binding"})
        assert lean, (s, "a record pins the pointer, but none binds it")
        assert verify[s]["utc"] == status[s]["utc"] and not verify[s].get("problems"), s
        how = FRESH if verify[s]["reused"] == 0 else SLOT
        d = load(pointer)
        assert d["status"] == "passed" and d["utc"] == status[s]["utc"], s
        run = run_receipt(pointer, d)
        paths = lean + ([pointer] if pinned else [])
        command = [sys.executable, "-B", "tools/research/repoint.py", "--reason",
                   REASON.format(core=core, how=how) + f": {s} {d['utc']}",
                   "--receipt", run, "--lean", *lean, "--paths", *paths, "--ids", *ids] + (["--apply"] if apply else [])
        p = subprocess.run(command, cwd=REPO, text=True, capture_output=True)
        assert p.returncode == 0, (s, p.stderr)
        out = json.loads(p.stdout)
        report[s] = {"run": run, "records": bound, "pointer_pinned_by": pinned, "how": how, "repoint": out}
        print(s, d["utc"], "records", out.get("records"),
              {k: (len(v.get("paths", [])), len(v.get("rebound", []))) for k, v in out.get("by_record", {}).items()})
    older = json.loads((OUT / "older.json").read_text()) if (OUT / "older.json").exists() else {}
    for receipt, row in older.get("receipts", {}).items():
        if not row["passed"]:
            continue
        reason = (f"RV21c: the older-layout receipt {receipt} renewed in place by its own checker on main "
                  f"(sha256 {row['old_sha256']} -> {row['new_sha256']}, checked {row['old_checked_at_utc']} -> "
                  f"{row['new_checked_at_utc']}); its proof bindings keep the path; no statement changed")
        if not row["records"]:
            # No record binds it (formal's receipt, which evolution's inherits): the log line alone names the old
            # hash, with the files the checker rewrote in place, so every renewed receipt's earlier bytes are found.
            line = {"date": _dt.datetime.now(_dt.timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
                    "base": git("rev-parse", "--short=9", "HEAD").strip(),
                    "reason": reason.replace("; its proof bindings keep the path", "; no record binds it"),
                    "records": [], "paths": sorted(x for x in row["changed"] if not x.endswith("/")),
                    "receipt": receipt, "rebound": []}
            if apply:
                with open(REPO / "_process/architecture/rebinds.jsonl", "a", encoding="utf-8") as log:
                    log.write(json.dumps(line, ensure_ascii=False) + "\n")
            report["older:" + receipt] = {"records": [], "logged": line}
            print("older", receipt, "no record binds it; logged" if apply else "no record binds it; would log")
            continue
        command = [sys.executable, "-B", "tools/research/repoint.py", "--reason", reason, "--paths", receipt,
                   "--ids", *row["records"]] + (["--apply"] if apply else [])
        p = subprocess.run(command, cwd=REPO, text=True, capture_output=True)
        assert p.returncode == 0, (receipt, p.stderr)
        out = json.loads(p.stdout)
        assert set(out.get("by_record", {})) == set(row["records"]), (receipt, out)
        report["older:" + receipt] = {"records": row["records"], "repoint": out}
        print("older", receipt, "records", out.get("records"))
    (OUT / ("repoint.json" if apply else "repoint-dry.json")).write_text(
        json.dumps(report, indent=1, ensure_ascii=False) + "\n")


if __name__ == "__main__":
    main()
