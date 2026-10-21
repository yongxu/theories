#!/usr/bin/env python3
"""Join SG9's laws to the core package: copy the extended Becoming.Optimum in, extend its root doc bullet, its scope
text in check_becoming.py and its README rows (EN, ZH).
usage: python3 -B integrate.py   (SG9_ROOT names the checkout to edit; each edit must match exactly once)"""
import os
import shutil
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = Path(os.environ['SG9_ROOT']).resolve() if os.environ.get('SG9_ROOT') else HERE.parents[5]
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'


def once(text, old, new):
    assert text.count(old) == 1, ('edit does not match once', old[:90], text.count(old))
    return text.replace(old, new)


target = PKG / 'Becoming' / 'Optimum.lean'
assert 'GainsMost' not in target.read_text(), 'already integrated'
shutil.copyfile(HERE / 'tree' / 'Becoming' / 'Optimum.lean', target)

DOC_OLD = '  at one, and at twofold both are optima.\n'
DOC_NEW = (DOC_OLD +
           '  A course gaining at each step at least what the level of any open course gains is an\n'
           '  optimum, and every optimum gains what it does. Below a level y out of one step\'s reach,\n'
           '  where the next level rises with the level below y, the course rising as fast as what is\n'
           '  given allows up to y stands at or above every open course below y; where the weighted gain\n'
           '  rises with the level up to y and is greatest there it is an optimum, and where the gain\n'
           '  rises strictly every optimum stands at its level, drawing nothing, while it is below y,\n'
           '  restoring what that level meets. Witness: a source doubling up to eight, from one, is\n'
           '  rebuilt by every optimum under weights falling less than twofold, ended at more.\n')
SCOPE_OLD = '    "breaks the dweller. "\n'
SCOPE_NEW = ('    "breaks the dweller; a course whose weighted gain at each step to the n-th is at least that "\n'
             '    "of the level of any open course, open and leaving nothing, is an optimum and every optimum "\n'
             '    "gains what it does, the course of greatest weighted gain the case; from s at most y, where "\n'
             '    "z + R z rises with z below y, the course rising as fast as what is given allows up to y "\n'
             '    "stands at each step at or above every open course or at y; where the weighted gain rises "\n'
             '    "with the level up to y and is greatest at y, with a capacity covering y with its renewal "\n'
             '    "and R 0, that course leaving nothing is an optimum; where the gain rises strictly below "\n'
             '    "y, every optimum stands at its level and draws nothing before it at every step to the "\n'
             '    "n-th where it is below y, restoring within those steps every dependence whose need that "\n'
             '    "level meets; where y gains more than every other level, every optimum stands at y where "\n'
             '    "the rising course does; Holding: a source doubling up to eight, from one, with weights "\n'
             '    "falling less than twofold a step is rebuilt to two, four and eight by every optimum and "\n'
             '    "the dweller restored at the first step, at twofold ending at once is an optimum too, and "\n'
             '    "falling more than twofold every optimum ends it. "\n')
README_OLD = 'witness `Optimum.Holding.logistic_weighted` |'
README_NEW = ('witness `Optimum.Holding.logistic_weighted`; a course gaining at each step at least what the level of any '
              'open course gains is an optimum and every optimum gains what it does (`Optimum.frontier_of_gainsMost`, '
              '`Optimum.frontier_gains_of_most`), and below a level `y` out of one step\'s reach, where the next level '
              'rises with the level below `y`, nothing open rises faster than the course rising as fast as what is '
              'given allows (`Optimum.le_rise`), which is an optimum where the weighted gain rises up to `y` and is '
              'greatest there (`Optimum.rebuilding_frontier`); where the gain rises strictly, every optimum stands at '
              'its level, drawing nothing, while it is below `y`, restoring what that level meets '
              '(`Optimum.frontier_rebuilds`, `Web.frontier_rebuilds`), and at `y` after (`Optimum.frontier_rebuilt`); '
              'witness `Optimum.Holding.doubling_rebuilds` |')
README_ZH_OLD = '见证 `Optimum.Holding.logistic_weighted` |'
README_ZH_NEW = ('见证 `Optimum.Holding.logistic_weighted`；每步加权增益不少于任一开放进程水平之增益的进程是最优，每个最优的增益与它相同'
                 '（`Optimum.frontier_of_gainsMost`、`Optimum.frontier_gains_of_most`）；在一步不可及的水平 `y` 之下，下一水平随水平上升时，'
                 '没有开放进程比按所给尽快上升的进程升得更快（`Optimum.le_rise`），加权增益升到 `y` 且在那里最大时它是最优'
                 '（`Optimum.rebuilding_frontier`）；增益严格上升时，每个最优在低于 `y` 时都处于它的水平、不抽取，恢复该水平所满足者'
                 '（`Optimum.frontier_rebuilds`、`Web.frontier_rebuilds`），此后处于 `y`（`Optimum.frontier_rebuilt`）；'
                 '见证 `Optimum.Holding.doubling_rebuilds` |')

root = (PKG / 'Becoming.lean').read_text()
(PKG / 'Becoming.lean').write_text(once(root, DOC_OLD, DOC_NEW))
chk = (PKG / 'check_becoming.py').read_text()
(PKG / 'check_becoming.py').write_text(once(chk, SCOPE_OLD, SCOPE_NEW))
rd = (PKG / 'README.md').read_text()
(PKG / 'README.md').write_text(once(rd, README_OLD, README_NEW))
zh = (PKG / 'README.zh.md').read_text()
(PKG / 'README.zh.md').write_text(once(zh, README_ZH_OLD, README_ZH_NEW))
print('integrated')
