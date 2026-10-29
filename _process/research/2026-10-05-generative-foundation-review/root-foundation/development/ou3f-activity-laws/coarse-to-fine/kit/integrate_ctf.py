#!/usr/bin/env python3
"""OU3f's coarse-to-fine pair: copy Persistence from the tree after checking that the package file is still the one the
tree was derived from (tree/BASE.sha256). No module is added or removed.
usage (from the checkout root of the landing worktree): python3 -B <kit>/integrate_ctf.py"""
import hashlib
import shutil
from pathlib import Path

ROOT = Path.cwd()
TREE = Path(__file__).resolve().parent.parent / 'tree'
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
BASE = {line.split()[1]: line.split()[0] for line in (TREE / 'BASE.sha256').read_text().splitlines()}
assert sorted(BASE) == ['Becoming/Persistence.lean'], sorted(BASE)
for name, sha in BASE.items():
    now = hashlib.sha256((PKG / name).read_bytes()).hexdigest()
    assert now == sha, f'{name} changed on main since the tree was derived; re-derive it ({now[:12]})'
    shutil.copyfile(TREE / name, PKG / name)
print('integrated: Persistence copied')
