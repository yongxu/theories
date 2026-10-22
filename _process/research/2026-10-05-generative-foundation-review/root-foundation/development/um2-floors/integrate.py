#!/usr/bin/env python3
"""Join UM2 to the core package: copy the generalized Optimum in and restate the drain in the root doc, the checker
scope and the README rows (EN, ZH).
usage: python3 -B integrate.py   (UM2_ROOT names the checkout to edit; each edit must match exactly once)"""
import os
import shutil
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = Path(os.environ['UM2_ROOT']).resolve() if os.environ.get('UM2_ROOT') else HERE.parents[5]
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'


def once(text, old, new):
    assert text.count(old) == 1, ('edit does not match once', old[:90], text.count(old))
    return text.replace(old, new)


opt = PKG / 'Becoming' / 'Optimum.lean'
assert 'theorem pass_through' not in opt.read_text(), 'already integrated'
shutil.copyfile(HERE / 'tree' / 'Becoming' / 'Optimum.lean', opt)
edits = {
    'Becoming.lean': [('''  one for one, gives drawing to capacity wherever what is drawn later is fixed and, with no floor
  and two or more drawers, every perfect profile and every revision from round 2N on drawing
  everything.''', '''  one for one, gives drawing to capacity wherever what is drawn later is fixed and, where two
  drawers have no floor, whatever the others' floors, every perfect profile the floor profile and
  every revision reaching it; with no floor anywhere, drawing everything.''')],
    'check_becoming.py': [('''    "the last step; with no floor and k at least two, along every sequence of revisions from round "
    "2 c on every drawer leaves nothing at the last c steps, a revision always exists, every "
    "perfect profile draws everything, drawing everything is perfect, and where the first leaves "
    "nothing the base stands at G t 0 and a dependence above G 0 0 met at the start is broken at "''',
        '''    "the last step; where two drawers u < v have no floor, whatever the others' floors, through a "
    "drawer leaving nothing nothing passes, along every sequence of revisions from round p c on (p "
    "three, or two where u is the first) every drawer leaves its floor at the last c steps, a "
    "revision always exists, every perfect profile is the floor profile and the floor profile is "
    "perfect, and where a drawer leaves nothing the base stands at G t 0 and a dependence above "
    "G 0 0 met at the start is broken at "''')],
    'README.md': [('with no floor and two or more drawers, revision from any profile drawing everything from round `2 N` on '
                   '(`Optimum.InTurn.revisions_end`, `Optimum.InTurn.revised_draw_all`) and every perfect profile drawing '
                   'everything (`Optimum.InTurn.perfect_ends`)',
                   'where two drawers have no floor, whatever the others\' floors, revision from any profile reaching the '
                   'floor profile (`Optimum.InTurn.revisions_reach_floors`, `Optimum.InTurn.revised_at_floors`) and every '
                   'perfect profile the floor profile, itself perfect (`Optimum.InTurn.perfect_at_floors`, '
                   '`Optimum.InTurn.floors_perfect`), with no floor anywhere drawing everything')],
    'README.zh.md': [('无下限且两个及以上抽取者时，自任一组合修订自第 `2 N` 轮起全部抽取（`Optimum.InTurn.revisions_end`、'
                      '`Optimum.InTurn.revised_draw_all`），每个完美组合全部抽取（`Optimum.InTurn.perfect_ends`）',
                      '两个抽取者无下限时，不论其他下限，自任一组合修订达到下限组合（`Optimum.InTurn.revisions_reach_floors`、'
                      '`Optimum.InTurn.revised_at_floors`），每个完美组合即下限组合，且下限组合完美（`Optimum.InTurn.perfect_at_floors`、'
                      '`Optimum.InTurn.floors_perfect`），处处无下限即全部抽取')],
}
for name, pairs in edits.items():
    p = PKG / name
    t = p.read_text()
    for old, new in pairs:
        t = once(t, old, new)
    p.write_text(t)
print('integrated')
