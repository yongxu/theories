#!/usr/bin/env python3
"""WL3: put Becoming.GrammarCourse into the package before the core checker runs: the module, its import and bullet in
the root module, its place in the checker's core list and scope text, and its rows in the package README (EN, ZH).
usage (from the checkout root of the landing worktree): python3 -B <kit>/integrate.py"""
import shutil
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
NAME = 'Becoming.GrammarCourse'


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:70], text.count(old))
    path.write_text(text.replace(old, new), encoding='utf-8')


assert not (PKG / 'Becoming/GrammarCourse.lean').exists()
shutil.copyfile(HERE / 'tree/Becoming/GrammarCourse.lean', PKG / 'Becoming/GrammarCourse.lean')

# --- the root module: the import (after the last one) and the bullet after IdentificationRuns'
root = PKG / 'Becoming.lean'
lines = root.read_text(encoding='utf-8').split('\n')
last = max(i for i, line in enumerate(lines) if line.startswith('import '))
assert f'import {NAME}' not in lines
lines.insert(last + 1, f'import {NAME}')
root.write_text('\n'.join(lines), encoding='utf-8')
edit(root, """  prefix, and own courses with at most N and N' states fix what it tells apart within N + N' - 1
  steps, a bound attained.
""", """  prefix, and own courses with at most N and N' states fix what it tells apart within N + N' - 1
  steps, a bound attained.
* `Becoming.GrammarCourse` (L1): 文 in the grammar of continuation (board item WL3). A determined
  law's step is 缘 and a map's values a class; a relation is constant under the step exactly where
  the law keeps it, so the same course through the map is the core of the value class
  (`Law.core_is_sameFuture`), likeness by bisimulation is that core (`Law.alike_iff_core`), and the
  coarsest class keeping the values and carrying the law is the core (`Law.coarsest_iff_core`).
  Two moments of a 文 are one state exactly where they lie in one class of its core along the steps
  (`SameAhead.is_core`); a step continues under the core exactly where the line under the value
  class never ends (`Law.continues_in_core_iff`); the bounded laws, two 文 read as one net, and
  learnability are restated through the core where exact. The prefix, the bounds as numbers and
  eventual agreement have no counterpart in the grammar.
""")

# --- the checker: core list and scope
checker = PKG / 'check_becoming.py'
edit(checker, '"Becoming.TypicalRuns", "Becoming.WeightedTraces", "Becoming"',
     '"Becoming.TypicalRuns", "Becoming.WeightedTraces", "Becoming.GrammarCourse", "Becoming"')
edit(checker, '''SCOPE = (
    "GrammarReadings: ''', '''SCOPE = (
    "GrammarCourse: a determined law's step read as 缘 and a map's values as a class; a relation is constant "
    "under the step exactly where the law keeps it; the same course through the map is the core of the value "
    "class and likeness by bisimulation in the frame by the map is that core; the coarsest class keeping the "
    "values and carrying the law is the core; two moments of a course are one state exactly where they lie in "
    "one class of its core along the steps; a step continues under the core exactly where the line under the "
    "value class never ends; the bounded laws, two courses as one net and learnability restated through the "
    "core. "
    "GrammarReadings: ''')

# --- the package README rows (EN, ZH), after IdentificationRuns'
row_en = ('| L1 | [`Becoming.GrammarCourse`](Becoming/GrammarCourse.lean) | 文 in the grammar of continuation (no premise): '
          'a law\'s step as 缘 and a map\'s values as a class; the same course through the map is the core of the value '
          'class (`Law.core_is_sameFuture`) and likeness by bisimulation is that core (`Law.alike_iff_core`); the coarsest '
          'value-keeping class is the core (`Law.coarsest_iff_core`); the states of a course are its core along the steps '
          '(`SameAhead.is_core`); the bounded laws, two courses as one net and learnability through the core |')
row_zh = ('| L1 | [`Becoming.GrammarCourse`](Becoming/GrammarCourse.lean) | 文入续之文法（不加前提）：法之步为缘，象之值为类；'
          '经象文同即值之类之核（`Law.core_is_sameFuture`），象所示之系辞中之同即此核（`Law.alike_iff_core`）；守值之最粗之类即核'
          '（`Law.coarsest_iff_core`）；文之状即其沿步之核（`SameAhead.is_core`）；有界之律、二文合为一网与可知皆经核而述 |')
for name, row, after in (('README.md', row_en, 'IdentificationRuns'), ('README.zh.md', row_zh, 'LearnableRuns')):
    path = PKG / name
    lines = path.read_text(encoding='utf-8').split('\n')
    at = [i for i, line in enumerate(lines) if line.startswith(f'| L1 | [`Becoming.{after}`]')]
    assert len(at) == 1, (name, at)
    lines.insert(at[0] + 1, row)
    path.write_text('\n'.join(lines), encoding='utf-8')
print('integrated: GrammarCourse copied; root import and bullet; checker core list and scope; README rows')
