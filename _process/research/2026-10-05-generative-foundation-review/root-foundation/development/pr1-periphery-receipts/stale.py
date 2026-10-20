#!/usr/bin/env python3
"""PR1: which renewed periphery receipts bind bytes that differ from a revision's files.

usage: stale.py [REV]   (default main) -> prints each receipt whose closure differs, with the modules
"""
import hashlib
import json
from pathlib import Path
import subprocess
import sys

HERE = Path(__file__).resolve().parent
REPO = HERE.parents[5]
sys.path.insert(0, str(HERE.parent / "pe2-propext-uses"))
from uses import RECEIPTS  # noqa: E402


def main():
    rev = sys.argv[1] if len(sys.argv) > 1 else "main"
    stale = []
    for receipt in RECEIPTS[:-1]:
        d = json.loads((REPO / receipt).read_text())
        base = Path(receipt).parent
        lean_root = REPO / "experiments/integrated-correction/general-framework/generative-basis/lean"
        differ = []
        for name, rel in d["source_paths"].items():
            # source paths are relative to the checker's root; try the lean root, then the receipt's folder
            for root in (lean_root, REPO / base, REPO / "experiments", REPO):
                path = (root / rel).resolve()
                if path.exists():
                    break
            git_path = str(path.relative_to(REPO))
            p = subprocess.run(["git", "show", f"{rev}:{git_path}"], cwd=REPO, capture_output=True)
            sha = hashlib.sha256(p.stdout).hexdigest() if p.returncode == 0 else None
            if sha != d["source_sha256"][name]:
                differ.append(name)
        if differ:
            stale.append(Path(receipt).stem)
        print(Path(receipt).stem, d["utc"], "differs:" if differ else "matches", " ".join(differ[:8]))
    print("STALE", " ".join(stale))


if __name__ == "__main__":
    main()
