#!/usr/bin/env python3
"""OU3f, lineage laws: copy Identity and MapInstances from the tree, after checking that each package file is still the
one the tree was derived from (tree/BASE.sha256), and say in the root module's Identity and GrammarLaws bullets that the
lineage laws are cases of the grammar's laws of steps. No module is added, so the checker's core list, the root
module's imports and the README rows do not change. Each edit is asserted to apply exactly once.
usage (from the checkout root of the landing worktree): python3 -B <kit>/integrate_lineage.py"""
import hashlib
import shutil
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
TREE = HERE.parent / 'tree'
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
BASE = {line.split()[1]: line.split()[0] for line in (TREE / 'BASE.sha256').read_text().splitlines()}
assert sorted(BASE) == ['Becoming/Identity.lean', 'Becoming/MapInstances.lean'], sorted(BASE)


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:70], text.count(old))
    path.write_text(text.replace(old, new), encoding='utf-8')


for name, sha in BASE.items():
    now = hashlib.sha256((PKG / name).read_bytes()).hexdigest()
    assert now == sha, f'{name} changed on main since the kit tree was derived; re-derive it ({now[:12]})'
for name in BASE:
    shutil.copyfile(TREE / name, PKG / name)

root = PKG / 'Becoming.lean'
edit(root, """  ceasing recurring needs arising recurring; without merges, under a bounded census,
  arising recurring needs ceasing recurring.
""", """  ceasing recurring needs arising recurring; without merges, under a bounded census,
  arising recurring needs ceasing recurring. A lineage under a continuation is the grammar's
  steps of the continuation within activity from its start (`Web.steps_iff_lineage`), so the
  lineage laws the covering forms of these halves rest on are cases of the grammar's laws of
  steps (board item OU3f).
""")
edit(root, """  and `Web.reaches_onward` in `Becoming.MapInstances`, an unending line's index advancing with its
  steps (board items OU3d, OU3e, OU3f).""", """  and `Web.reaches_onward` in `Becoming.MapInstances`, an unending line's index advancing with its
  steps; and the lineage laws in `Becoming.Identity`, a lineage read as steps of the continuation
  within activity (`Web.Lineage.unique`, `origin`, `split`, `through`, `onward`, `back`, and a
  lineage as a line both ways, `Web.Lineage.line`, `Web.line_lineage`; board items OU3d, OU3e,
  OU3f).""")
print('integrated: Identity and MapInstances copied; the root module\'s Identity and GrammarLaws bullets')
