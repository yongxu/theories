#!/usr/bin/env python3
"""Join SG8's laws to the core package: copy the extended Becoming.Optimum in, extend its root doc bullet, its scope
text in check_becoming.py and its README rows (EN, ZH).
usage: python3 -B integrate.py   (SG8_ROOT names the checkout to edit; each edit must match exactly once)"""
import os
import shutil
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = Path(os.environ['SG8_ROOT']).resolve() if os.environ.get('SG8_ROOT') else HERE.parents[5]
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'


def once(text, old, new):
    assert text.count(old) == 1, ('edit does not match once', old[:90], text.count(old))
    return text.replace(old, new)


target = PKG / 'Becoming' / 'Optimum.lean'
assert 'weightedOver' not in target.read_text(), 'already integrated'
shutil.copyfile(HERE / 'tree' / 'Becoming' / 'Optimum.lean', target)

DOC_OLD = '  step to the last step, at most one a step breaks it.\n'
DOC_NEW = (DOC_OLD +
           '  With the draw of the step from t weighted by w t, any weighting, what a course could draw\n'
           '  at a step with what it drew before changes by what the level it leaves gains, w (t + 1)\n'
           '  on it with its renewal against w t on it held; against an open course leaving nothing\n'
           '  whose level gains the most at each step, every optimum of every order rising with the\n'
           '  weighted draw gains what that course\'s level gains at each step and leaves nothing\n'
           '  weighted, and that course is one. Where the weighting falls faster than every positive\n'
           '  level renews, every optimum ends its own base at the first step; where some level within\n'
           '  reach renews faster and nothing is given at nothing, none does. Witness: under the\n'
           '  logistic law weights falling more than twofold end the source, less than twofold hold it\n'
           '  at one, and at twofold both are optima.\n')
SCOPE_OLD = '    "step, and at most one a step breaks it. "\n'
SCOPE_NEW = ('    "step, and at most one a step breaks it; with the draw of the step from t weighted by w t, "\n'
             '    "any weighting, what a course could draw at a step with what it drew before changes from "\n'
             '    "one step to the next by w (t + 1) on the level left with its renewal against w t on it "\n'
             '    "held; against an open course from the start leaving nothing whose level gains the most "\n'
             '    "at each step to the n-th, no course draws more, weighted, across n + 1 steps, every "\n'
             '    "optimum of every order rising with the weighted draw gains at each step what that "\n'
             '    "course\'s level gains and leaves nothing weighted at the end, and that course is an "\n'
             '    "optimum; every optimum stands below a need above which every level gains less, breaking "\n'
             '    "at the first step a dependence needing it; where w (t + 1) (z + R z) < w t z for every "\n'
             '    "positive z, with a capacity covering the start with its renewal, every optimum stands at "\n'
             '    "nothing at every step to the n-th, and with <= the course doing so is an optimum; where "\n'
             '    "R 0 = 0 and some y within reach has w t y < w (t + 1) (y + R y) at each step, with a "\n'
             '    "capacity drawing down to y and holding it, no optimum stands at nothing at the first "\n'
             '    "step; Holding: under the logistic law with weights falling more than twofold a step the "\n'
             '    "source is ended at once and the dweller broken, at exactly twofold ending and holding at "\n'
             '    "one are both optima, and falling less than twofold every optimum holds it at one and "\n'
             '    "breaks the dweller. "\n')
README_OLD = 'witness `Optimum.Holding.logistic_stepwise` |'
README_NEW = ('witness `Optimum.Holding.logistic_stepwise`; with the draw of the step from `t` weighted by `w t`, any '
              'weighting, what a course could draw at a step with what it drew before changes by what the level it '
              'leaves gains (`Optimum.drawable_step`), so against an open course leaving nothing whose level gains the '
              'most at each step no course draws more, weighted, every optimum of every order rising with the weighted '
              'draw gains what that course\'s level gains and leaves nothing weighted, and that course is an optimum '
              '(`Optimum.weighted_le_of_gains`, `Optimum.frontier_gains_weighted`, `Optimum.weighted_frontier`, '
              '`Optimum.weighted_holding_frontier`), breaking at the first step a dependence above every level of '
              'greatest weighted gain (`Optimum.frontier_below_weighted`, `Web.frontier_broken_weighted`); where the '
              'weighting falls faster than every positive level renews every optimum ends its own base at the first '
              'step (`Optimum.frontier_exhausts`, `Web.frontier_exhausts`, `Optimum.exhausting_frontier`), and where '
              'some level within reach renews faster none does (`Optimum.ended_outdrawn`, `Optimum.frontier_leaves`, '
              '`Web.frontier_leaves`); witness `Optimum.Holding.logistic_weighted` |')
README_ZH_OLD = '见证 `Optimum.Holding.logistic_stepwise` |'
README_ZH_NEW = ('见证 `Optimum.Holding.logistic_stepwise`；以 `w t` 加权自 `t` 起一步的抽取（任意权重），进程在一步可抽取的连同之前所抽取的，'
                 '逐步变化的量是它留下的水平的增益（`Optimum.drawable_step`），故相对于一个开放、最后不留、每步水平增益最大的进程，'
                 '没有进程加权抽取更多，每个随加权抽取上升的次序的每个最优在每步都得到该进程水平的增益且最后不留加权之物，'
                 '而该进程是一个最优（`Optimum.weighted_le_of_gains`、`Optimum.frontier_gains_weighted`、'
                 '`Optimum.weighted_frontier`、`Optimum.weighted_holding_frontier`），在第一步打破所需高于每个最大加权增益水平的依存'
                 '（`Optimum.frontier_below_weighted`、`Web.frontier_broken_weighted`）；权重下降快于每个正水平的更新时，'
                 '每个最优在第一步终结自己的基础（`Optimum.frontier_exhausts`、`Web.frontier_exhausts`、`Optimum.exhausting_frontier`），'
                 '可达的某水平更新更快时没有最优这样做（`Optimum.ended_outdrawn`、`Optimum.frontier_leaves`、`Web.frontier_leaves`）；'
                 '见证 `Optimum.Holding.logistic_weighted` |')

root = (PKG / 'Becoming.lean').read_text()
(PKG / 'Becoming.lean').write_text(once(root, DOC_OLD, DOC_NEW))
chk = (PKG / 'check_becoming.py').read_text()
(PKG / 'check_becoming.py').write_text(once(chk, SCOPE_OLD, SCOPE_NEW))
rd = (PKG / 'README.md').read_text()
(PKG / 'README.md').write_text(once(rd, README_OLD, README_NEW))
zh = (PKG / 'README.zh.md').read_text()
(PKG / 'README.zh.md').write_text(once(zh, README_ZH_OLD, README_ZH_NEW))
print('integrated')
