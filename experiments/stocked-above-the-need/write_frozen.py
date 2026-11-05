#!/usr/bin/env python3
"""Write FROZEN.sha256, the base link of T1R's chain (DESIGN.md, section 14): the sha-256 of each file the
freeze fixes, paths repository-relative, sorted. They are the code the dry run ran with, as its record names
them as it starts; the dry run's record; and this writer. It refuses unless the dry run passed every check,
its code the same at its end as at its start, and the hashes it recorded are the files' now, so that the
record hashed is the one the hashed code gives; and it writes the link once, refusing where one is there.

    python3 -B experiments/stocked-above-the-need/write_frozen.py      # on the merged tree, last
"""

import hashlib
import json
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import dry_run as D             # noqa: E402

RECORD = HERE / "results" / "dry-run.json"
OUT = HERE / "FROZEN.sha256"
OWN = ("write_frozen.py", "results/dry-run.json")


def main():
    run = json.loads(RECORD.read_text())
    if run["failed"] or not run["code unchanged during the run"]:
        raise SystemExit("the dry run did not pass every check, or its code changed while it ran")
    if run["code hashes"] != D.code_hashes():
        raise SystemExit("the dry run was made on other files than these: run it again")
    if OUT.exists():
        raise SystemExit(f"{OUT.name} is there already: the base link is written once")
    rel = HERE.relative_to(HERE.parents[1])
    files = dict(run["code hashes"])
    files.update({str(rel / f): hashlib.sha256((HERE / f).read_bytes()).hexdigest() for f in OWN})
    OUT.write_text("".join(f"{h}  {p}\n" for p, h in sorted(files.items())))
    print(OUT.read_text(), end="")


if __name__ == "__main__":
    main()
