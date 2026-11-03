#!/usr/bin/env python3
"""U4e: which decision binders of Identity and Persistence neither their statement nor their proof uses.

Builds `Becoming.Persistence`'s closure with `scratch_build.py` in TREE (the modules TREE holds over this checkout's;
an empty TREE reads this checkout as it is), every step restored from the checker's shared cache where it passed
before, then runs `UnusedDecisions.lean` against the compiled modules with the checker's Lean and prints its lines.
Exits 1 where any binder is unused and `--none` is given.
usage (from the checkout root): python3 -B <kit>/unused_decisions.py TREE [--none]"""
import os
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
sys.path.insert(0, str(PKG))
import check_becoming as cb  # noqa: E402

tree = Path(sys.argv[1]).resolve()
tree.mkdir(parents=True, exist_ok=True)
build = subprocess.run([sys.executable, '-B', str(PKG / 'scratch_build.py'), str(tree), 'Becoming.Persistence'],
                       cwd=PKG, capture_output=True, text=True)
print(build.stdout[-1500:], build.stderr[-1500:])
assert build.returncode == 0, build.returncode
command, _, _ = cb.resolve_lean()
(tree / '.build' / 'UnusedDecisions.lean').write_bytes((HERE / 'UnusedDecisions.lean').read_bytes())
p = subprocess.run(command + ['UnusedDecisions.lean'], cwd=tree / '.build', capture_output=True, text=True,
                   env={**os.environ, 'LEAN_PATH': str(tree / '.build')})
print(p.stdout.strip())
assert p.returncode == 0 and not re.search(r'\b(?:error|warning):', p.stdout), p.stdout[-3000:] + p.stderr[-2000:]
unused = [line for line in p.stdout.split('\n') if line.startswith('UNUSED ')]
sys.exit(1 if unused and '--none' in sys.argv[2:] else 0)
