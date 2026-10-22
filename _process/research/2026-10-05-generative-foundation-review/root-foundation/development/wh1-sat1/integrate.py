#!/usr/bin/env python3
"""Join WH1's and SAT1's laws to the core package: copy the extended Becoming.Wholes and Becoming.Frequency in, extend
their root doc entries, their scope text in check_becoming.py and their README rows (EN, ZH).
usage: python3 -B integrate.py   (WH1_ROOT names the checkout to edit; each edit must match exactly once)"""
import os
import shutil
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = Path(os.environ['WH1_ROOT']).resolve() if os.environ.get('WH1_ROOT') else HERE.parents[5]
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'


def once(text, old, new):
    assert text.count(old) == 1, ('edit does not match once', old[:90], text.count(old))
    return text.replace(old, new)


for name, mark in (('Wholes', 'def AllWhole'), ('Frequency', 'namespace Saturation')):
    target = PKG / 'Becoming' / f'{name}.lean'
    assert mark not in target.read_text(), 'already integrated'
    shutil.copyfile(HERE / 'tree' / 'Becoming' / f'{name}.lean', target)

EDITS = {
    'Becoming.lean': [
        ('  above the need: no part arises from then on. The uptake is the joint draw, the whole\'s with\n'
         '  whatever else takes.\n',
         '  above the need: no part arises from then on. The uptake is the joint draw, the whole\'s with\n'
         '  whatever else takes. A whole may instead be active while every part is: it ends as soon as\n'
         '  one part ends, persists exactly while every part does, and coincides with the whole of some\n'
         '  part exactly where the parts are in step. Counted where their activity is decided, the grade\n'
         '  of listed parts, how many are active, gains what arises and loses what ceases across each\n'
         '  step, so a whole active while at least `j` of them are arises and ceases only through a part;\n'
         '  at `j` one it is the whole of some part, at the number listed the whole of every one, and\n'
         '  where some parts are active and not all the whole is diminished.\n'),
        ('  settles is exactly a dichotomy on decided two-place families, which gives the limited principle\n'
         '  of omniscience, even for schedules coupling at most once.\n',
         '  settles is exactly a dichotomy on decided two-place families, which gives the limited principle\n'
         '  of omniscience, even for schedules coupling at most once. Strengths read off what has passed\n'
         '  through a coupling read the levels before; where they are zero once an amount has passed, the\n'
         '  coupling stops by the step that amount has passed, nothing more passes and, every coupling so\n'
         '  saturated, a finite order is exact; acting at each step until saturated from a standing level,\n'
         '  it stops by the threshold as a step. With a response not rising, it stops exactly where the\n'
         '  response reaches zero; floored at one, it recurs and, coupled into itself, leaves every finite\n'
         '  order inexact.\n'),
    ],
    'check_becoming.py': [
        ('    "arising without depending on the drawn condition. "\n',
         '    "arising without depending on the drawn condition. A formation active exactly while every part is "\n'
         '    "ends as soon as one part ends, persists exactly while every part does, and, with some part, is "\n'
         '    "active at the steps the whole of some part is exactly where the parts are in step; the grade of "\n'
         '    "listed parts, counted where their activity is decided, gains what arises and loses what ceases "\n'
         '    "across a step, so a formation active exactly where the grade is at least j arises and ceases only "\n'
         '    "through a listed part, at j one the whole of some and at the number listed the whole of every one, "\n'
         '    "and the whole is diminished exactly where the whole of some is active and the whole of every one "\n'
         '    "is not; a house of three rafters, one taken, is diminished and does not stand. "\n'),
        ('    "LPO; the loops of Loops and Closing are instances. "\n',
         '    "LPO; the loops of Loops and Closing are instances. Strengths read off what has passed through each "\n'
         '    "coupling read the levels before, and what passes is what the formed course carries through it; "\n'
         '    "where they are zero once A has passed and A has passed by N, the coupling stops by N, nothing more "\n'
         '    "passes, what passes in all is below A and the most one step passes, and with every coupling so "\n'
         '    "saturated a finite order is exact; acting at each step until saturated from a standing level it "\n'
         '    "stops by step A; with strengths f(a) times a coupling acting at each step, f not rising, it stops "\n'
         '    "exactly where f reaches zero, and floored at one it recurs and, coupled into itself, leaves every "\n'
         '    "finite order inexact. "\n'),
    ],
    'README.md': [
        ("`WholeUnending.persists`, `WholeUngated.persists` |",
         "`WholeUnending.persists`, `WholeUngated.persists`; the whole of every part (`Web.AllWhole`) ends as soon as one "
         "part ends (`AllWhole.ends_of_part`), persists exactly while every part does (`AllWhole.persists_iff`) and "
         "coincides with the whole of some part exactly where the parts are in step (`Whole.same_iff_inStep`); a whole of "
         "some part ceases only as a part ceases (`Whole.ceases_part`); the grade of listed parts (`Web.Grade`, a count) "
         "gains what arises and loses what ceases across a step (`Grade.across_step`), so a whole of at least j listed parts "
         "(`Web.AtLeastWhole`) arises and ceases only through one (`AtLeastWhole.arises_part`, `AtLeastWhole.ceases_part`), "
         "at j one the whole of some and at the number listed the whole of every one (`AtLeastWhole.whole`, "
         "`AtLeastWhole.allWhole`), and the diminished whole (`Web.Diminished`) is the whole of some active and the whole of "
         "every one not (`diminished_iff`); witnesses `Generations.allWhole_never`, `Rafters.taken` |"),
        ("for every law with the strengths: `gap_le_count`; the readings are the AI's, open |",
         "for every law with the strengths: `gap_le_count`; a coupling saturated by what it has carried "
         "(`Saturation.strengths`, reading before: `Saturation.readsBefore`; what passes is what the course carries: "
         "`Saturation.course_succ`) stops where its strength reaches zero (`Saturation.stops`, `Saturation.passed_from`, "
         "`Saturation.exact`), what passes in all bounded (`Saturation.passed_lt`), by its threshold as a step where it acts "
         "until saturated (`Saturation.stops_by`, `Saturation.course_stops_by`), exactly where its response reaches zero "
         "(`Saturation.stops_iff`), and floored at one it recurs (`Saturation.floored`, `Saturation.floored_inexact`); the "
         "readings are the AI's, open |"),
    ],
    'README.zh.md': [
        ("`WholeUnending.persists`、`WholeUngated.persists` |",
         "`WholeUnending.persists`、`WholeUngated.persists`；每个部分之整体（`Web.AllWhole`）：一个部分终结它即终结"
         "（`AllWhole.ends_of_part`），恰在每个部分都持续时持续（`AllWhole.persists_iff`），恰在诸部分同步时与某部分之整体重合"
         "（`Whole.same_iff_inStep`）；某部分之整体只经由某部分的止息而止息（`Whole.ceases_part`）；所列部分的等级"
         "（`Web.Grade`，一个计数）跨一步增其生起者、减其止息者（`Grade.across_step`），故至少 j 个所列部分之整体"
         "（`Web.AtLeastWhole`）只经由其一生起与止息（`AtLeastWhole.arises_part`、`AtLeastWhole.ceases_part`），j 为一即某部分之整体，"
         "j 为所列之数即每个部分之整体（`AtLeastWhole.whole`、`AtLeastWhole.allWhole`），减损之整体（`Web.Diminished`）恰是某部分之整体"
         "活跃而每个部分之整体不活跃（`diminished_iff`）；见证 `Generations.allWhole_never`、`Rafters.taken` |"),
        ("对一切具有这些强度的律：`gap_le_count`；读法是 AI 的",
         "对一切具有这些强度的律：`gap_le_count`；为已传之量所饱和的耦合（`Saturation.strengths`，读先前："
         "`Saturation.readsBefore`；所传即进程经它所携：`Saturation.course_succ`）在强度归零处停止（`Saturation.stops`、"
         "`Saturation.passed_from`、`Saturation.exact`），所传总量有界（`Saturation.passed_lt`），未饱和时每步作用则至阈值之步停止"
         "（`Saturation.stops_by`、`Saturation.course_stops_by`），恰在响应归零处停止（`Saturation.stops_iff`），下限为一则复现"
         "（`Saturation.floored`、`Saturation.floored_inexact`）；读法是 AI 的"),
    ],
}
for name, edits in EDITS.items():
    path = PKG / name
    text = path.read_text(encoding='utf-8')
    for old, new in edits:
        text = once(text, old, new)
    path.write_text(text, encoding='utf-8')
print('integrated')
