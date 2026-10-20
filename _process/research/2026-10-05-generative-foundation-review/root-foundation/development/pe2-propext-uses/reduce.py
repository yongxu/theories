#!/usr/bin/env python3
"""PE2: run the reduction checks in `reduction/` against the work directories `uses.py` made.

usage: reduce.py WORKROOT   (writes reduction/<name>.log)
"""
import json
import os
from pathlib import Path
import subprocess
import sys

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import restore  # noqa: E402

CHECKS = {"machine-instances": "machine-instances-verification",
          "learning-correspondence": "learning-correspondence-verification",
          "ideals-correspondence": "ideals-correspondence-verification",
          "continuation-correspondence": "continuation-correspondence-verification"}


def main():
    root = Path(sys.argv[1]).resolve()
    for check, folder in CHECKS.items():
        work = root / folder
        info = json.loads((work / "restore.json").read_text())
        lean_path = [str(work)] + ([str(p) for p in restore.mathlib_path()] if info["mathlib_revision"] else [])
        name = "PE2Reduction.lean"
        (work / name).write_bytes((HERE / "reduction" / (check + ".lean")).read_bytes())
        p = subprocess.run([info["lean"], name], cwd=work, env={**os.environ, "LEAN_PATH": ":".join(lean_path)},
                           text=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
        (HERE / "reduction" / (check + ".log")).write_text(f"# {info['toolchain']}; target {info['target']} as {info['receipt']}\n# exit {p.returncode}\n" + p.stdout)
        print(check, "exit", p.returncode)
        print(p.stdout)


if __name__ == "__main__":
    main()
