#!/usr/bin/env python3
"""OU3f, the twins: copy ContinuedClasses and PatternPassing from the kit tree into the package, after checking that each
package file is still the one the tree was derived from (main at a34db4227; tree/BASE.sha256, in that order).
usage (from the checkout root of the landing worktree): python3 -B <kit>/integrate_twins.py"""
import hashlib
import shutil
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
TREE = HERE.parent / 'tree'
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
MODULES = ('ContinuedClasses', 'PatternPassing')
BASE = dict(zip(MODULES, (TREE / 'BASE.sha256').read_text().split()))
for module, sha in BASE.items():
    now = hashlib.sha256((PKG / 'Becoming' / f'{module}.lean').read_bytes()).hexdigest()
    assert now == sha, f'{module} changed on main since the kit tree was derived; re-derive it ({now[:12]})'
for module in MODULES:
    shutil.copyfile(TREE / 'Becoming' / f'{module}.lean', PKG / 'Becoming' / f'{module}.lean')
print('integrated: ContinuedClasses and PatternPassing copied')
