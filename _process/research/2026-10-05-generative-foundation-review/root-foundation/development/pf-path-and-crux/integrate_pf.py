#!/usr/bin/env python3
"""PF: put Becoming.GrammarPath into the package before the core checker runs: the module, its import and bullet in the
root module, its place in the checker's core list and scope text, and its rows in the package README (EN, ZH).
Adapted from GS2's integrate_gs2.py. GrammarPath is a leaf until the owner of Becoming.GrammarCases decides on the
corollary form of SharedCondition.affecting_member_outside (proposed/GrammarCases.lean).
usage (from the checkout root of the landing worktree): python3 -B <kit>/integrate_pf.py"""
import shutil
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
NAME = 'Becoming.GrammarPath'


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:70], text.count(old))
    path.write_text(text.replace(old, new), encoding='utf-8')


assert not (PKG / 'Becoming/GrammarPath.lean').exists()
shutil.copyfile(HERE / 'tree/Becoming/GrammarPath.lean', PKG / 'Becoming/GrammarPath.lean')

root = PKG / 'Becoming.lean'
lines = root.read_text(encoding='utf-8').split('\n')
last = max(i for i, line in enumerate(lines) if line.startswith('import '))
assert f'import {NAME}' not in lines
lines.insert(last + 1, f'import {NAME}')
root.write_text('\n'.join(lines), encoding='utf-8')
edit(root, """  grows with its number, the rate read in its
  regularity (`Belief`).
""", """  grows with its number, the rate read in its
  regularity (`Belief`).
* `Becoming.GrammarPath` (L1): what a line under a class must hold, and what a regularity takes in
  (board item PF), for every carrier, relation and class. Where a region is left under a class only
  into a set, a line under the class from inside to outside holds a member of that set alike to its
  start (`«所经必同»`, `«所经不同则不及»`). Under a constant class, everything downstream of anything
  alike to a member whose effects the class holds (`«所缘同于»`) is alike to it and on a line under the
  class (`«常闭则后皆续»`), and, given constancy, holding the effects is equivalent to that
  (`«常类之闭当且仅当后皆同类»`); the same holds up to the net's end (`«至终有常»`,
  `«至终常闭则后皆续»`, `«至终常类之闭当且仅当后皆同类»`), and a relation under which a line ends at an
  occurrence that still conditions something is not constant up to the net's end
  (`«亡而网续则不至终有常»`). Witnesses that neither premise can be dropped (`Unclosed`, `Inconstant`),
  and a finite net with two families in which the one is not constant while one family's class,
  narrower than the one, is constant up to the net's end and the organism's is not
  (`FiniteFamilies`); and a finite net with two families sharing a condition they affect, where every
  premise holds at once and the line from one family's first birth reaches the other past the first
  member's end (`FiniteSharedCondition`).
""")

checker = PKG / 'check_becoming.py'
edit(checker, '"Becoming.GrammarCases", "Becoming"', '"Becoming.GrammarCases", "Becoming.GrammarPath", "Becoming"')
edit(checker, '''    "GrammarCases: small witnesses''', '''    "GrammarPath: a line under a class that must pass through a set holds a member of it alike to its start; "
    "under a constant class, and up to the net's end, everything downstream of anything alike to a member whose "
    "effects the class holds is alike to it and on its line, and given the regularity that is equivalent to holding "
    "the effects; a relation under which a line ends where the net goes on is not constant up to the net's end; "
    "witnesses that neither premise can be dropped, a finite net with two families, and one with a shared condition "
    "where every premise holds at once. "
    "GrammarCases: small witnesses''')

row_en = ('| L1 | [`Becoming.GrammarPath`](Becoming/GrammarPath.lean) | what a line under a class must hold, and what a '
          'regularity takes in (no premise beyond each law\'s own): a line leaving a region only into a set holds a '
          'member of it alike to its start (`«所经必同»`); under a constant class, everything downstream of anything '
          'alike to a member whose effects the class holds is on its line, and given the regularity that is equivalent '
          'to holding them (`«常闭则后皆续»`, `«常类之闭当且仅当后皆同类»`), also up to the net\'s end (`«至终有常»`, '
          '`«至终常闭则后皆续»`); a line ending while the net goes on rules out constancy up to the net\'s end '
          '(`«亡而网续则不至终有常»`); witnesses (`Unclosed`, `Inconstant`, `FiniteFamilies`, `FiniteSharedCondition`) |')
row_zh = ('| L1 | [`Becoming.GrammarPath`](Becoming/GrammarPath.lean) | 一类下之线所必含者，与一理所纳者'
          '（除各律所带者外不加前提）：出一域唯经一集之线，含该集中与其始同类者（`«所经必同»`）；有常之类下，'
          '与一所缘皆同于己者同类者之后皆在其线上，有常之下与此等价（`«常闭则后皆续»`、`«常类之闭当且仅当后皆同类»`），至网之终亦然'
          '（`«至终有常»`、`«至终常闭则后皆续»`）；网续而线亡者，其类不至终有常（`«亡而网续则不至终有常»`）；'
          '见证（`Unclosed`、`Inconstant`、`FiniteFamilies`、`FiniteSharedCondition`） |')
for name, row in (('README.md', row_en), ('README.zh.md', row_zh)):
    path = PKG / name
    lines = path.read_text(encoding='utf-8').split('\n')
    at = [i for i, line in enumerate(lines) if line.startswith('| L1 | [`Becoming.GrammarCases`]')]
    assert len(at) == 1, (name, at)
    lines.insert(at[0] + 1, row)
    path.write_text('\n'.join(lines), encoding='utf-8')
print('integrated: GrammarPath copied; root import and bullet; checker core list and scope; README rows')
