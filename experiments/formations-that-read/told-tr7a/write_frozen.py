#!/usr/bin/env python3
"""Write told-tr7a/FROZEN.sha256, the base link of TR7A's chain (FREEZE-9.md, section 10): the sha-256 of each
file this folder's link lists, paths repository-relative, sorted. They are Stage A's code and Stage 0's output,
which the dry run records as it starts; the dry run's record; and this writer. The files Stage A imports are
FREEZE-4's, held at its newest link by its frozen check, and are not listed here (FREEZE-9.md, "What is
frozen"). It refuses unless FREEZE-4's frozen check passes, freeze 1's within it; unless the dry run passed
every check, its code the same at its end as at its start; and unless the hashes it recorded are the files'
now, so that the record hashed is the one the hashed code gives. It writes the link once, and refuses where one
is there already.

    python3 -B experiments/formations-that-read/told-tr7a/write_frozen.py     # on the merged tree, last
"""

import hashlib
import json
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import tr7a_stage as S        # noqa: E402
import tr7a_dry_run as D      # noqa: E402

RECORD = HERE / "results" / "dry-run.json"
OUT = HERE / "FROZEN.sha256"
OWN = ("write_frozen.py", "results/dry-run.json")     # listed beside the files the dry run records


def main():
    S.TR.frozen(S.R.REPO)                             # FREEZE-4's frozen check, freeze 1's within it
    run = json.loads(RECORD.read_text())
    if run["failed"] or not run["code unchanged during the run"]:
        raise SystemExit("the dry run did not pass every check, or its code changed while it ran")
    if run["code hashes"] != D.code_hashes():
        raise SystemExit("the dry run was made on other files than these: run it again")
    if OUT.exists():
        raise SystemExit(f"{OUT.name} is there already: the base link is written once")
    files = dict(run["code hashes"])
    files.update({str(S.FOLDER / f): hashlib.sha256((HERE / f).read_bytes()).hexdigest() for f in OWN})
    OUT.write_text("".join(f"{h}  {p}\n" for p, h in sorted(files.items())))
    print(OUT.read_text(), end="")


if __name__ == "__main__":
    main()
