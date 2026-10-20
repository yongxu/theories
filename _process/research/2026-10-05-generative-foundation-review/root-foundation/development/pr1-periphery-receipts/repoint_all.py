#!/usr/bin/env python3
"""PR1: rebind the records' proof bindings from each periphery receipt's earlier runs to its renewed run.

For each receipt (PE2's list, the core's excluded): the records whose proof bindings name a run of
that checker (`out/bindings-before.json`, from `bindings.py` before the reruns), the Lean sources so
bound, and the renewed run's `verification.json`. Calls `tools/research/repoint.py` once per receipt
with `--receipt`, `--lean` and `--paths` those sources, and `--ids` those records; repoint.py checks
that the new run binds each source's current bytes and passed. A record that cites an earlier run
only as a reference (a receipt of an earlier statement) is left as it is.

usage: repoint_all.py [--apply]
"""
import json
from pathlib import Path
import subprocess
import sys

HERE = Path(__file__).resolve().parent
REPO = HERE.parents[5]
sys.path.insert(0, str(HERE.parent / "pe2-propext-uses"))
from uses import RECEIPTS  # noqa: E402

REASON = ("PR1: the periphery receipt renewed on the current core (no statement changed; the receipt's "
          "Lean sources rebound to the renewed run)")


def main():
    before = json.loads((HERE / "out/bindings-before.json").read_text())
    apply = "--apply" in sys.argv
    for receipt in RECEIPTS[:-1]:
        stem = Path(receipt).stem
        rows = before.get(stem, {})
        ids = sorted(r for r, bs in rows.items() if any(b["kind"] == "binding" for b in bs))
        lean = sorted({b["source"] for bs in rows.values() for b in bs if b["kind"] == "binding"})
        if not ids:
            print(stem, "no record binds it")
            continue
        d = json.loads((REPO / receipt).read_text())
        assert d["status"] == "passed"
        run = str(Path(receipt).parent / d["retained_run"] / "verification.json")
        command = [sys.executable, "-B", "tools/research/repoint.py", "--reason", REASON + f": {stem} {d['utc']}",
                   "--receipt", run, "--lean", *lean, "--paths", *lean, "--ids", *ids] + (["--apply"] if apply else [])
        p = subprocess.run(command, cwd=REPO, text=True, capture_output=True)
        assert p.returncode == 0, p.stderr
        out = json.loads(p.stdout)
        print(stem, d["utc"], "records", out["records"],
              {k: (len(v["paths"]), len(v["rebound"])) for k, v in out["by_record"].items()})


if __name__ == "__main__":
    main()
