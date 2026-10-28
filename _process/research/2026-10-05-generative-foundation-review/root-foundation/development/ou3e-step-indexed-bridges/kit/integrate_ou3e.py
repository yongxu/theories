#!/usr/bin/env python3
"""OU3e: copy Withholding and Labelled from the kit tree into the package, after checking that each package file is
still the one the tree was derived from (main at 4fcfc7011); then bring the root module's GrammarLaws entry to the
bridges (Withholding's closed forms and WithinMoves.after_course proved from the laws of steps counted).
usage (from the checkout root of the landing worktree): python3 -B <kit>/integrate_ou3e.py"""
import hashlib
import shutil
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
TREE = HERE.parent / 'tree' / 'Becoming'
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
BASE = {'Withholding': 'f064373e1adf6dc1355174342c235a0a40d2c371f39153151f4095a47bfa0aa9',
        'Labelled': 'f2c55215f94a1ddf795d238cf4a37c041d66540ef56c83ce4a0c3319dfa19d7d'}


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:70], text.count(old))
    path.write_text(text.replace(old, new), encoding='utf-8')


for module, sha in BASE.items():
    target = PKG / 'Becoming' / f'{module}.lean'
    now = hashlib.sha256(target.read_bytes()).hexdigest()
    assert now == sha, f'{module} changed on main since the kit tree was derived; re-derive it ({now[:12]})'
for module in BASE:
    shutil.copyfile(TREE / f'{module}.lean', PKG / 'Becoming' / f'{module}.lean')

edit(PKG / 'Becoming.lean', """  `Becoming.Withholding`'s closed forms have these shapes for its chains; their bridges are a
  second step (board item OU3d).""", """  `Becoming.Withholding`'s closed forms are proved from them, its chains of waits read as the
  grammar's steps, and so is `WithinMoves.after_course` in `Becoming.Labelled`, a trace read as
  them (board items OU3d, OU3e).""")
print('integrated: Withholding and Labelled copied; the root entry brought to the bridges')
