#!/usr/bin/env python3
"""GS6: replace Becoming.GrammarCases and Becoming.GrammarScope in the package with the versions in which board rule 9 is
applied (PF's proposal, and the further cases the review found): SharedCondition.affecting_member_outside and
SharedCondition.fed_outside from «所经不同则不及» (Becoming.GrammarPath), TwoLines.line_in_family and
LineOfDescent.Endless.member_line from «线内同类», ThirdThing.family_keeps_third from «续即缘当且仅当含族». Say so in the
root module's bullets for GrammarCases and GrammarPath and in their package README rows (EN, ZH); the root bullets of
GrammarMap and GrammarTesting, which GS2 and GS3 made importers of, no longer call them leaves.
Run before lean_docs_gs6.py, which revises the GrammarCases bullet written here (second review).
usage (from the checkout root of the landing worktree): python3 -B <kit>/integrate_gs6.py"""
import shutil
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:70], text.count(old))
    path.write_text(text.replace(old, new), encoding='utf-8')


assert 'affecting_member_stays' in (PKG / 'Becoming/GrammarCases.lean').read_text(encoding='utf-8')
for name in ('GrammarCases', 'GrammarScope'):
    shutil.copyfile(HERE / f'tree/Becoming/{name}.lean', PKG / f'Becoming/{name}.lean')
root = PKG / 'Becoming.lean'
edit(root, """  reaches the other's through it under the one, not under "a member or not"; where they only feed
  from it, under no relation (`SharedCondition`, board item GS4). A third thing""",
     """  reaches the other's through it under the one, not under "a member or not"; where they only feed
  from it, under no relation (`SharedCondition`, board item GS4; both of these derived from
  `«所经不同则不及»`, board item GS6). A third thing""")
edit(root, """  member's end (`FiniteSharedCondition`).
* `Becoming.Composition` (L1)""", """  member's end (`FiniteSharedCondition`). `Becoming.GrammarCases` derives from `«所经不同则不及»` its
  shared-condition witnesses under "a member or not" and where the members only feed from the
  condition (board item GS6).
* `Becoming.Composition` (L1)""")
edit(root, """  branch of renewing into (`«生生即延»`, `«息即尽»`). A leaf.""",
     """  branch of renewing into (`«生生即延»`, `«息即尽»`). Imported by `Becoming.GrammarScope`,
  `Becoming.GrammarPath` and `Becoming.MapInstances`.""")
edit(root, """  (`«恒温与平衡»`): no intervener outside the net. A leaf.""",
     """  (`«恒温与平衡»`): no intervener outside the net. Imported by `Becoming.GrammarCases`.""")
for name, old, new in (
        ('README.md', 'one line reaching another through a condition its members affect (`SharedCondition`);',
         'one line reaching another through a condition its members affect, not under "a member or not" and not '
         'where they only feed from it (both derived from `«所经不同则不及»`) (`SharedCondition`);'),
        ('README.zh.md', '经其成员所影响之条件，一线及于他线（`SharedCondition`）；',
         '经其成员所影响之条件，一线及于他线，而于「成员与否」之下不及，成员唯受养于此条件时亦不及'
         '（二者皆由 `«所经不同则不及»` 推得）（`SharedCondition`）；'),
        ('README.md', 'witnesses (`Unclosed`, `Inconstant`, `FiniteFamilies`, `FiniteSharedCondition`) |',
         'witnesses (`Unclosed`, `Inconstant`, `FiniteFamilies`, `FiniteSharedCondition`); '
         '`Becoming.GrammarCases` derives from `«所经不同则不及»` its shared-condition witnesses under "a member or '
         'not" and where the members only feed from the condition |')):
    edit(PKG / name, old, new)
zh = (PKG / 'README.zh.md').read_text(encoding='utf-8')
row = next(line for line in zh.split('\n') if line.startswith('| L1 | [`Becoming.GrammarPath`]'))
assert row.endswith(' |'), row[-40:]
edit(PKG / 'README.zh.md', row,
     row[:-2] + '；`Becoming.GrammarCases` 之共条件见证，于「成员与否」之下者与成员唯受养于此条件者，皆由 `«所经不同则不及»` 推得 |')
print('integrated: GrammarCases and GrammarScope replaced; root bullets and README rows (EN, ZH) updated')
