#!/usr/bin/env python3
"""RV21c: which periphery receipts bind bytes that differ from a revision's files.

PR1's `stale.py` covers PE2's list of receipts; this adds the periphery checkers written after it
(`NEWER`). Read-only: each receipt's retained run is compared module by module with `git show REV:path`.

usage: stale_all.py [REV]   (default main)
"""
import hashlib
import json
from pathlib import Path
import subprocess
import sys

HERE = Path(__file__).resolve().parent
REPO = HERE.parents[5]
LEAN = REPO / "experiments/integrated-correction/general-framework/generative-basis/lean"
sys.path.insert(0, str(HERE.parent / "pe2-propext-uses"))
from uses import RECEIPTS  # noqa: E402

NEWER = [
    "free-energy/cells-under-noise-verification.json",
    "free-energy/expected-free-energy-reals-verification.json",
    "free-energy/free-energy-reals-verification.json",
    "regime/regime-reals-verification.json",
    "warning/slowing-down-verification.json",
    "representation/representation-verification.json",
]


def differing(receipt, rev):
    d = json.loads(receipt.read_text())
    out = []
    for name, rel in d["source_paths"].items():
        for root in (LEAN, receipt.parent, REPO / "experiments", REPO):
            path = (root / rel).resolve()
            if path.exists():
                break
        p = subprocess.run(["git", "show", f"{rev}:{path.relative_to(REPO)}"], cwd=REPO, capture_output=True)
        sha = hashlib.sha256(p.stdout).hexdigest() if p.returncode == 0 else None
        if sha != d["source_sha256"][name]:
            out.append(name)
    return d["utc"], out


def main():
    rev = sys.argv[1] if len(sys.argv) > 1 else "main"
    paths = [REPO / r for r in RECEIPTS[:-1]] + [LEAN / r for r in NEWER]
    stale = []
    for receipt in paths:
        utc, differ = differing(receipt, rev)
        if differ:
            stale.append(receipt.stem)
        print(receipt.stem, utc, f"differs ({len(differ)}):" if differ else "matches", " ".join(differ[:8]))
    print(f"STALE {len(stale)} of {len(paths)}:", " ".join(stale))


if __name__ == "__main__":
    main()
