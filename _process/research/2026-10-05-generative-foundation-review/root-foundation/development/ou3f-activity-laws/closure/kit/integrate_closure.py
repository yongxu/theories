#!/usr/bin/env python3
"""OU3f, closure: join Becoming.KeptOnward (a leaf importing GrammarLaws) to the core and copy the six modules whose
inductions over steps it replaces, after checking that each package file is still the one the tree was derived from
(tree/BASE.sha256, in MODULES order). KeptOnward joins the checker's core list after GrammarTransport, with a sentence in
the scope text before GrammarPath's; the root module's imports, with an L1 bullet before Ideals'; and the package README
rows (EN, ZH) after GrammarTransport's. Each edit is asserted to apply exactly once.
usage (from the checkout root of the landing worktree): python3 -B <kit>/integrate_closure.py"""
import hashlib
import shutil
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
TREE = HERE.parent / 'tree'
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
MODULES = ('Retaining', 'Wholes', 'Exclusion', 'Reserve', 'PatternPassing', 'Persistence')
BASE = dict(zip(MODULES, (TREE / 'BASE.sha256').read_text().split()))


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:70], text.count(old))
    path.write_text(text.replace(old, new), encoding='utf-8')


for module, sha in BASE.items():
    now = hashlib.sha256((PKG / 'Becoming' / f'{module}.lean').read_bytes()).hexdigest()
    assert now == sha, f'{module} changed on main since the kit tree was derived; re-derive it ({now[:12]})'
target = PKG / 'Becoming/KeptOnward.lean'
assert not target.exists(), target
shutil.copyfile(TREE / 'Becoming/KeptOnward.lean', target)
for module in MODULES:
    shutil.copyfile(TREE / 'Becoming' / f'{module}.lean', PKG / 'Becoming' / f'{module}.lean')

checker = PKG / 'check_becoming.py'
edit(checker, '"Becoming.GrammarLaws", "Becoming.GrammarTransport", "Becoming.World"',
     '"Becoming.GrammarLaws", "Becoming.GrammarTransport", "Becoming.KeptOnward", "Becoming.World"')
edit(checker, """    "GrammarPath: a line under a class that must pass through a set holds a member of it alike to its start; \"""",
     """    "KeptOnward: a region of the steps of time that every step keeps holds from where it holds on, the "
    "grammar's closure at the successor along a line; the inductions over steps that keep a region are its cases. "
    "GrammarPath: a line under a class that must pass through a set holds a member of it alike to its start; \"""")

root = PKG / 'Becoming.lean'
edit(root, 'import Becoming.GrammarTransport\n', 'import Becoming.GrammarTransport\nimport Becoming.KeptOnward\n')
edit(root, "* `Becoming.Ideals` (L1):", """* `Becoming.KeptOnward` (L1): a region every step keeps holds from where it holds on. A region of
  the steps of time that every step keeps, holding at step `a`, holds at every later step
  (`kept_onward`): the steps are a line under the successor (`«线则所闭»`), and a closed region
  holds what lies within the closure (`«闭含所闭»`). The inductions over steps that keep a region in
  `Becoming.Retaining`, `Becoming.Wholes`, `Becoming.Exclusion`, `Becoming.Reserve`,
  `Becoming.PatternPassing` and `Becoming.Persistence` are its cases. Its home is beside
  `«线则所闭»` in `Becoming.GrammarLaws`, where it moves at the next full rebuild (board item OU3f).
* `Becoming.Ideals` (L1):""")

EN = ('| L1 | [`Becoming.KeptOnward`](Becoming/KeptOnward.lean) | a region every step keeps holds from where it holds on '
      '(`kept_onward`), the grammar\'s closure at the successor along a line (`«线则所闭»`, `«闭含所闭»`); the inductions '
      'over steps that keep a region are its cases; its home is beside `«线则所闭»` in `Becoming.GrammarLaws` |')
ZH = ('| L1 | [`Becoming.KeptOnward`](Becoming/KeptOnward.lean) | 每步皆守之域，自其所守处以后皆守（`kept_onward`），即文法之闭包'
      '于后继沿线（`«线则所闭»`、`«闭含所闭»`）；守一域之逐步归纳皆为其例；其所居在 `Becoming.GrammarLaws` 中 `«线则所闭»` 之旁 |')
for path, row in ((PKG / 'README.md', EN), (PKG / 'README.zh.md', ZH)):
    lines = path.read_text(encoding='utf-8').split('\n')
    at = [i for i, l in enumerate(lines) if l.startswith('| L1 | [`Becoming.GrammarTransport`]')]
    assert len(at) == 1, (path.name, at)
    assert not any(l.startswith('| L1 | [`Becoming.KeptOnward`]') for l in lines)
    lines.insert(at[0] + 1, row)
    path.write_text('\n'.join(lines), encoding='utf-8')
print('integrated: Becoming.KeptOnward joined (checker core list and scope, root import and L1 bullet, README rows EN '
      'and ZH); the six modules copied')
