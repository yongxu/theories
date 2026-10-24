#!/usr/bin/env python3
"""GS3: put Becoming.GrammarCases into the package before the core checker runs: the module, its import and bullet in the
root module, its place in the checker's core list and scope text, and its rows in the package README (EN, ZH).
Adapted from GS2's integrate_gs2.py.
usage (from the checkout root of the landing worktree): python3 -B <kit>/integrate_gs3.py"""
import shutil
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
NAME = 'Becoming.GrammarCases'


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:70], text.count(old))
    path.write_text(text.replace(old, new), encoding='utf-8')


assert not (PKG / 'Becoming/GrammarCases.lean').exists()
shutil.copyfile(HERE / 'tree/Becoming/GrammarCases.lean', PKG / 'Becoming/GrammarCases.lean')

root = PKG / 'Becoming.lean'
lines = root.read_text(encoding='utf-8').split('\n')
last = max(i for i, line in enumerate(lines) if line.startswith('import '))
assert f'import {NAME}' not in lines
lines.insert(last + 1, f'import {NAME}')
root.write_text('\n'.join(lines), encoding='utf-8')
edit(root, """  without end (`«核有续当且仅当有不穷»`); two lines of descent, one endless and one that ends
  (`LineOfDescent`).
""", """  without end (`«核有续当且仅当有不穷»`); two lines of descent, one endless and one that ends
  (`LineOfDescent`).
* `Becoming.GrammarCases` (L1): test systems of the source texts as small witnesses of the grammar
  (board item GS3), the behaviour in question supplied in each net. Decay: an alteration in a net with
  no cycle; in the net of possibilities "intact or not" is constant, so the step is not in its
  regularity, while a history within that net has the time left before the decay in it (`Decay`).
  No clear boundary: two overlapping identities, each a class, an occurrence's positions differing by
  class, their union not a class (`Overlap`). A line of descent generating at two grains
  (`LineOfDescent.Endless.generates`). Two family lines, the class of one strictly between a member's
  and the one, constant, its core going on through each birth, the other family not reached
  (`TwoLines`). A belief whose rate of spread grows with its number, the rate read in its
  regularity (`Belief`).
""")

checker = PKG / 'check_becoming.py'
edit(checker, '"Becoming.GrammarScope", "Becoming"', '"Becoming.GrammarScope", "Becoming.GrammarCases", "Becoming"')
edit(checker, '''SCOPE = (
    "GrammarScope: ''', '''SCOPE = (
    "GrammarCases: small witnesses of two of the source texts' test systems and two narrower stand-ins: decay "
    "an alteration in a net with no cycle, the step not in the regularity of intact or not in the net of "
    "possibilities and the time left in it in a history within that net; two overlapping identities, positions "
    "differing by class, their union not a class; a line of descent generating at two grains; two family lines, "
    "a class between a member's and the one whose core goes on through births; a belief whose "
    "rate grows with its number, the rate read in its regularity. "
    "GrammarScope: ''')

row_en = ('| L1 | [`Becoming.GrammarCases`](Becoming/GrammarCases.lean) | test systems of the source texts as small '
          'witnesses (no premise beyond each net\'s own): decay, the step not in the regularity of intact or not in the '
          'net of possibilities (`Decay.time_not_in_core`), the time left in it in a history within that net '
          '(`Decay.history_apart`); overlapping identities (`Overlap`); a line of descent generating at two grains '
          '(`LineOfDescent.Endless.generates`); two family lines, a core going on through births (`TwoLines`); a belief '
          'whose rate grows with its number (`Belief`) |')
row_zh = ('| L1 | [`Becoming.GrammarCases`](Becoming/GrammarCases.lean) | 来源二篇之检验系统之小见证（除各网所带者外不加前提）：'
          '衰变，可能之网中步不在「完与否」之理中（`Decay.time_not_in_core`），其内一史中余时在其中（`Decay.history_apart`）；'
          '相交之同一（`Overlap`）；传承之线于两种粒度生成（`LineOfDescent.Endless.generates`）；二家族之线，其核于出生处续（`TwoLines`）；'
          '传播之率随其数而增之信念（`Belief`） |')
for name, row in (('README.md', row_en), ('README.zh.md', row_zh)):
    path = PKG / name
    lines = path.read_text(encoding='utf-8').split('\n')
    at = [i for i, line in enumerate(lines) if line.startswith('| L1 | [`Becoming.GrammarScope`]')]
    assert len(at) == 1, (name, at)
    lines.insert(at[0] + 1, row)
    path.write_text('\n'.join(lines), encoding='utf-8')
print('integrated: GrammarCases copied; root import and bullet; checker core list and scope; README rows')
