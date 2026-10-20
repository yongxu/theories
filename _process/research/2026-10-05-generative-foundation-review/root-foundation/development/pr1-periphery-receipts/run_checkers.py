#!/usr/bin/env python3
"""PR1: run the periphery checkers one at a time and keep each run's outcome.

The receipts are PE2's (`pe2-propext-uses/uses.py` RECEIPTS, the core's excluded); each one's
checker is the first file its `checker_sha256` names, beside it. A run writes its receipt and
retained folder as the checker always does; this script records the exit status and the last
lines of output in `out/<receipt stem>.log` and `out/status.json`.

usage: run_checkers.py [STEM ...]   (default: every receipt, in PE2's order)
"""
import json
from pathlib import Path
import subprocess
import sys
import time

HERE = Path(__file__).resolve().parent
REPO = HERE.parents[5]
sys.path.insert(0, str(HERE.parent / "pe2-propext-uses"))
from uses import RECEIPTS  # noqa: E402

OUT = HERE / "out"


def main():
    OUT.mkdir(exist_ok=True)
    wanted = set(sys.argv[1:])
    status_path = OUT / "status.json"
    status = json.loads(status_path.read_text()) if status_path.exists() else {}
    for receipt in RECEIPTS[:-1]:
        stem = Path(receipt).stem
        if wanted and stem not in wanted:
            continue
        old = json.loads((REPO / receipt).read_text())
        checker = (REPO / receipt).parent / next(iter(old["checker_sha256"]))
        start = time.time()
        p = subprocess.run([sys.executable, "-B", str(checker)], cwd=REPO, text=True,
                           stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
        (OUT / (stem + ".log")).write_text(p.stdout)
        new = json.loads((REPO / receipt).read_text())
        status[stem] = {"exit": p.returncode, "status": new.get("status"), "utc": new.get("utc"),
                        "seconds": round(time.time() - start), "tail": p.stdout[-1500:]}
        status_path.write_text(json.dumps(status, indent=2, ensure_ascii=False) + "\n")
        print(stem, p.returncode, new.get("status"), new.get("utc"), flush=True)


if __name__ == "__main__":
    main()
