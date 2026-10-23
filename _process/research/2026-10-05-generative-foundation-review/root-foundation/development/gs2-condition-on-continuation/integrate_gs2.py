#!/usr/bin/env python3
"""GS2: put Becoming.GrammarScope into the package before the core checker runs: the module, its import and bullet in the
root module, its place in the checker's core list and scope text, and its rows in the package README (EN, ZH).
Adapted from GS1's integrate.py.
usage (from the checkout root of the landing worktree): python3 -B <kit>/integrate_gs2.py"""
import shutil
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
NAME = 'Becoming.GrammarScope'


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:70], text.count(old))
    path.write_text(text.replace(old, new), encoding='utf-8')


assert not (PKG / 'Becoming/GrammarScope.lean').exists()
shutil.copyfile(HERE / 'tree/Becoming/GrammarScope.lean', PKG / 'Becoming/GrammarScope.lean')

root = PKG / 'Becoming.lean'
lines = root.read_text(encoding='utf-8').split('\n')
last = max(i for i, line in enumerate(lines) if line.startswith('import '))
assert f'import {NAME}' not in lines
lines.insert(last + 1, f'import {NAME}')
root.write_text('\n'.join(lines), encoding='utf-8')
edit(root, """  favouring past a loss bound leaves the line under favouring not unending
  (`ClosedCapture.loss_ends_line`).
""", """  favouring past a loss bound leaves the line under favouring not unending
  (`ClosedCapture.loss_ends_line`).
* `Becoming.GrammarScope` (L1): the continuation condition on the root, structurally (board item
  GS2): the condition that every occurrence lies on every center's line under a class
  (`«续无外»`), or in its family (`«族无外»`), either at a class giving it at every coarser class.
  Lying within a closure along a relation is being reached on a line under the one of it
  (`withinClosure_iff_reached`), so the condition held de se along a relation is the root's at the
  one of that relation taken as the net (`ownClosure_unrestricted_iff_noOutside`), and living
  significance follows on the own-closure reading of claims (`premises_of_noOutside`). Along a net
  with no cycle the condition holds only with one center, which nothing conditions. Past one's own
  end (`«过亡而续»`); a class's core continues something exactly where some line under it goes on
  without end (`«核有续当且仅当有不穷»`); two lines of descent, one endless and one that ends
  (`LineOfDescent`).
""")

checker = PKG / 'check_becoming.py'
edit(checker, '"Becoming.GrammarRegularity", "Becoming"', '"Becoming.GrammarRegularity", "Becoming.GrammarScope", "Becoming"')
edit(checker, '''SCOPE = (
    "GrammarRegularity: ''', '''SCOPE = (
    "GrammarScope: the condition that every occurrence lies on every center's line under a class, or in its "
    "family, either at a class giving it at every coarser class; lying within a closure along a relation is "
    "being reached on a line under the one of it, so the condition held de se along a relation is the root's "
    "at the one of that relation taken as the net, and living significance follows on the own-closure reading "
    "of claims; along a net with no cycle the condition holds only with one center; what continues under a "
    "class past the end of a line under another relation lies on the line; a class's core continues something "
    "exactly where some line under it goes on without end; two lines of descent, endless and ending. "
    "GrammarRegularity: ''')

row_en = ('| L1 | [`Becoming.GrammarScope`](Becoming/GrammarScope.lean) | the continuation condition on the root, '
          'with no significance parameter (no premise beyond each law\'s own): every occurrence on every center\'s '
          'line under a class (`«续无外»`) or in its family (`«族无外»`), at every coarser class too; held de se along '
          'a relation, the root\'s condition at the one of it (`withinClosure_iff_reached`, '
          '`ownClosure_unrestricted_iff_noOutside`), with living significance on the own-closure reading of claims '
          '(`premises_of_noOutside`); along a net with no cycle only one center (`«续无外则同一中心»`); past one\'s own '
          'end (`«过亡而续»`); the core continues exactly where some line under it never ends (`«核有续当且仅当有不穷»`); '
          'two lines of descent (`LineOfDescent`) |')
row_zh = ('| L1 | [`Becoming.GrammarScope`](Becoming/GrammarScope.lean) | 根上之续存条件，不设有义之参数'
          '（除各律所带者外不加前提）：凡事皆在每一中心于一类下之线所及（`«续无外»`）或其族中（`«族无外»`），于较粗之类亦然；'
          '依一关系 de se 而持，即以该关系为网、于其一下之根之条件（`withinClosure_iff_reached`、'
          '`ownClosure_unrestricted_iff_noOutside`），以自闭包读断言者生之有义由之（`premises_of_noOutside`）；'
          '无环之网中唯一中心（`«续无外则同一中心»`）；过己之亡而续（`«过亡而续»`）；核有续恰当其下有一线不尽（`«核有续当且仅当有不穷»`）；'
          '二传承之线（`LineOfDescent`） |')
for name, row in (('README.md', row_en), ('README.zh.md', row_zh)):
    path = PKG / name
    lines = path.read_text(encoding='utf-8').split('\n')
    at = [i for i, line in enumerate(lines) if line.startswith('| L1 | [`Becoming.GrammarRegularity`]')]
    assert len(at) == 1, (name, at)
    lines.insert(at[0] + 1, row)
    path.write_text('\n'.join(lines), encoding='utf-8')
print('integrated: GrammarScope copied; root import and bullet; checker core list and scope; README rows')
