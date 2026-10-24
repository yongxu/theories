#!/usr/bin/env python3
"""GS1: put Becoming.GrammarRegularity into the package before the core checker runs: the module, its import and bullet
in the root module, its place in the checker's core list and scope text, and its rows in the package README (EN, ZH).
Adapted from WL3's integrate.py.
usage (from the checkout root of the landing worktree): python3 -B <kit>/integrate.py"""
import shutil
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
NAME = 'Becoming.GrammarRegularity'


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:70], text.count(old))
    path.write_text(text.replace(old, new), encoding='utf-8')


assert not (PKG / 'Becoming/GrammarRegularity.lean').exists()
shutil.copyfile(HERE / 'tree/Becoming/GrammarRegularity.lean', PKG / 'Becoming/GrammarRegularity.lean')

# --- the root module: the import (after the last one) and the bullet after GrammarCourse's
root = PKG / 'Becoming.lean'
lines = root.read_text(encoding='utf-8').split('\n')
last = max(i for i, line in enumerate(lines) if line.startswith('import '))
assert f'import {NAME}' not in lines
lines.insert(last + 1, f'import {NAME}')
root.write_text('\n'.join(lines), encoding='utf-8')
edit(root, """  learnability are restated through the core where exact. The prefix, the bounds as numbers and
  eventual agreement have no counterpart in the grammar.
""", """  learnability are restated through the core where exact. The prefix, the bounds as numbers and
  eventual agreement have no counterpart in the grammar.
* `Becoming.GrammarRegularity` (L1): the regularity of a line, kept and left, and rules that change
  themselves, in the grammar (board item GS1). From a step continuing under the core, every
  occurrence its line under the core reaches has a successor under the core (`«守理则不穷»`); a step
  into an end leaves the core, for every relation (`«亡前理变»`), and so does the last step of every
  line that ends (`«有亡之线末步离核»`). A move of a process is a relation (`moveRel`); the state of a
  process changing its own rule has a class constant under every move exactly where the rule makes
  no difference to it (`adaptive_constant_iff`). In closed capture the class of share, rule and step
  count is constant along every schedule exactly where nothing beyond the share is read
  (`ClosedCapture.constant_iff_unread`); from a locked start the line under being locked never ends
  while every step alters the loss (`ClosedCapture.lock_line`); a reading that turns against
  favouring past a loss bound leaves the line under favouring not unending
  (`ClosedCapture.loss_ends_line`).
""")

# --- the checker: core list and scope
checker = PKG / 'check_becoming.py'
edit(checker, '"Becoming.GrammarCourse", "Becoming"', '"Becoming.GrammarCourse", "Becoming.GrammarRegularity", "Becoming"')
edit(checker, '''SCOPE = (
    "GrammarCourse: ''', '''SCOPE = (
    "GrammarRegularity: from a step continuing under the core every occurrence its line under the core "
    "reaches has a successor under the core; a step into an end leaves the core, and so does the last step of "
    "every line that ends; a move of a process read as a relation, a process with every move possible and "
    "going alike by a map having the map's class constant under every move, and a determined one the "
    "converse; the state of a process changing its own rule has a class constant under every move exactly "
    "where the rule makes no difference to it; in closed capture the class of share, rule and step count is "
    "constant along every schedule exactly where nothing beyond the share is read, from a locked start the "
    "line under being locked never ends while every step alters the loss, and a reading turning against "
    "favouring past a loss bound leaves the line under favouring not unending. "
    "GrammarCourse: ''')

# --- the package README rows (EN, ZH), after GrammarCourse's
row_en = ('| L1 | [`Becoming.GrammarRegularity`](Becoming/GrammarRegularity.lean) | the regularity of a line, kept and '
          'left, and rules that change themselves, in the grammar (no premise beyond each law\'s own): from a step '
          'under the core every occurrence its line under the core reaches is continued under it (`«守理则不穷»`); a '
          'step into an end, and the last step of every line that ends, leaves the core (`«亡前理变»`, '
          '`«有亡之线末步离核»`); a process with moves as relations (`constant_of_goAlike`, `goAlike_of_constant`); a '
          'rule that changes itself (`adaptive_constant_iff`, `adaptive_core_apart`); closed capture: the class of '
          'share, rule and step count constant along every schedule exactly where nothing beyond is read '
          '(`ClosedCapture.constant_iff_unread`), the locked line unending while the loss alters '
          '(`ClosedCapture.lock_line`), the line under favouring not unending under a reading that turns against '
          'favouring past a loss bound (`ClosedCapture.loss_ends_line`) |')
row_zh = ('| L1 | [`Becoming.GrammarRegularity`](Becoming/GrammarRegularity.lean) | 理之守与离，及自改其则者，于文法中读'
          '（除各律所带者外不加前提）：自核下之一步起，其核下之续所及者皆于核下有后（`«守理则不穷»`）；入亡之一步、凡终之线之末步，'
          '皆离核（`«亡前理变»`、`«有亡之线末步离核»`）；以动为际（`constant_of_goAlike`、`goAlike_of_constant`）；自改其则者'
          '（`adaptive_constant_iff`、`adaptive_core_apart`）；闭合之捕获：份额、规则与步数之类于每一读之时序皆有常，恰当份额之外无所读'
          '（`ClosedCapture.constant_iff_unread`），自锁住之始，锁之续不尽而损每步皆异（`ClosedCapture.lock_line`），读过损之界即不偏向者，'
          '偏向之续非不尽（`ClosedCapture.loss_ends_line`） |')
for name, row in (('README.md', row_en), ('README.zh.md', row_zh)):
    path = PKG / name
    lines = path.read_text(encoding='utf-8').split('\n')
    at = [i for i, line in enumerate(lines) if line.startswith('| L1 | [`Becoming.GrammarCourse`]')]
    assert len(at) == 1, (name, at)
    lines.insert(at[0] + 1, row)
    path.write_text('\n'.join(lines), encoding='utf-8')
print('integrated: GrammarRegularity copied; root import and bullet; checker core list and scope; README rows')
