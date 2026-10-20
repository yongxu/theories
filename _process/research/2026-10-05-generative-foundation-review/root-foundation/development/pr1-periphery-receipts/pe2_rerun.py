#!/usr/bin/env python3
"""PR1: rerun PE2's propext classification (`pe2-propext-uses/uses.py`, then `summary.py`) on the
renewed receipts, writing into `pe2/` here so that PE2's own `out/` and `summary.json`, the
evidence of its audit at the earlier receipts, stay as they are.

usage: pe2_rerun.py WORKROOT [receipt ...]   (WORKROOT: scratch for the restored closures)
       pe2_rerun.py --summary
"""
from pathlib import Path
import sys

HERE = Path(__file__).resolve().parent
PE2 = HERE.parent / "pe2-propext-uses"
OUT = HERE / "pe2"
sys.path.insert(0, str(PE2))
import uses  # noqa: E402
import summary  # noqa: E402


def main():
    OUT.mkdir(exist_ok=True)
    for name in ("Uses.lean", "restore.py"):
        link = OUT / name
        if not link.exists():
            link.symlink_to(Path("..") / ".." / PE2.name / name)
    if sys.argv[1:] == ["--summary"]:
        summary.HERE = OUT
        summary.main()
        return
    uses.HERE = OUT
    root = Path(sys.argv[1]).resolve()
    for receipt_path in sys.argv[2:] or uses.RECEIPTS:
        uses.run(receipt_path, root)


if __name__ == "__main__":
    main()
