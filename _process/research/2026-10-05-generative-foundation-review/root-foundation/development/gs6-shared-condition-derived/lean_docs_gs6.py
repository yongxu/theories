#!/usr/bin/env python3
"""GS6: documentation edits to the Lean after the reviews (no statement or proof changes). In the kit tree's
GrammarCases.lean, the module doc's SharedCondition bullet (first review: which member, which net) and fed_outside's
docstring (second review: the exit set is empty, not "the one has nothing outside it"); in the package root module, the
GrammarCases bullet names the two negative results (second review). Each edit is skipped where already applied, so the
script reproduces the committed files from integrate_gs6.py's output and lean_edits_gs6.py's.
usage (from the checkout root, after lean_edits_gs6.py; the root module edit after integrate_gs6.py): python3 -B lean_docs_gs6.py"""
import shutil
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
CASES = HERE / 'tree/Becoming/GrammarCases.lean'


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    if new in text and old not in text:
        return
    assert text.count(old) == 1, (path.name, old[:70], text.count(old))
    path.write_text(text.replace(old, new), encoding='utf-8')


edit(CASES, """  (`SharedCondition.affecting_member_outside`): the first family is left only into the condition,
  which that class does not hold alike to the member, so the case follows from `«所经不同则不及»`
  (`Becoming.GrammarPath`). Where the members only feed from a condition they do
  not affect, the line under no relation reaches the other family (`SharedCondition.fed_outside`). No
  class narrower than the one is shown to reach, and no core is computed.""",
     """  (`SharedCondition.affecting_member_outside`): along the net the first family is left only into the
  condition, and that class holds no stage of the condition alike to the first family's first member,
  so this follows from `«所经不同则不及»` (`Becoming.GrammarPath`). Where the members only feed from a
  condition they do not affect, the line under no relation reaches the other family
  (`SharedCondition.fed_outside`): a line under any relation is a line under the one, and along `fed`
  the first family is never left, so the same law applies with nothing to pass. No class narrower than
  the one is shown to reach in this net, and no core is computed.""")
edit(CASES, """left, so the one has nothing outside it to pass (`«所经不同则不及»` with no exit). -/""",
     """left, so under the one the first family has no exit to pass (`«所经不同则不及»` with an empty set
of exits). -/""")
shutil.copyfile(CASES, PKG / 'Becoming/GrammarCases.lean')
edit(PKG / 'Becoming.lean', """  from it, under no relation (`SharedCondition`, board item GS4; both of these derived from
  `«所经不同则不及»`, board item GS6). A third thing""",
     """  from it, under no relation (`SharedCondition`, board item GS4; the two negative results, under
  "a member or not" and where the members only feed from it, derived from `«所经不同则不及»`, board
  item GS6). A third thing""")
print('lean docs: GrammarCases module doc and fed_outside docstring; root bullet for GrammarCases')
