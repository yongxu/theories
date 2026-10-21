#!/usr/bin/env python3
"""Join SG5's laws to the core package: copy the extended Becoming.Optimum in, extend its root doc bullet, its scope
text in check_becoming.py and its README rows (EN, ZH).
usage: python3 -B integrate.py   (SG5_ROOT names the checkout to edit; each edit must match exactly once)"""
import os
import shutil
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = Path(os.environ['SG5_ROOT']).resolve() if os.environ.get('SG5_ROOT') else HERE.parents[5]
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'


def once(text, old, new):
    assert text.count(old) == 1, ('edit does not match once', old[:90], text.count(old))
    return text.replace(old, new)


target = PKG / 'Becoming' / 'Optimum.lean'
assert 'OpenCourse' not in target.read_text(), 'already integrated'
shutil.copyfile(HERE / 'tree' / 'Becoming' / 'Optimum.lean', target)

DOC_OLD = '  keeps, holding less than the course in which one restrains.\n'
DOC_NEW = ('  keeps, holding less than the course in which one restrains.\n'
           '  Ranked as whole courses over a horizon, what a course draws, leaves and forgoes adds to the\n'
           '  start with the greatest renewal a step, so what is drawn registers a level only through what\n'
           '  is renewed there; against a renewal given by a law of the level, the\n'
           '  courses drawing the most hold a level of greatest renewal through the horizon and leave\n'
           '  nothing at its end, and every optimum is one where such a level is within reach and the\n'
           '  capacity: a dependence whose need lies above every such level is broken at the first step,\n'
           '  one they all meet is kept to the horizon and broken there. Witnesses: the logistic law,\n'
           '  whose optimum draws a source from the level a dweller needs to where it renews most, and a\n'
           '  gate, under which holding at the dweller\'s need and below it are both optima.\n')
SCOPE_OLD = '    "than the course in which one restrains, none of whose steps is a mutual best response. "\n'
SCOPE_NEW = ('    "than the course in which one restrains, none of whose steps is a mutual best response; "\n'
             '    "ranked as whole courses over a horizon, what a course draws, what it leaves and everything "\n'
             '    "the renewal falls short of r add to the start with r a step, so balanced courses from one "\n'
             '    "level are ranked by what is taken exactly as by what they forgo and leave, and two given "\n'
             '    "alike and ending alike take the same; against a renewal R of the level, at most r, a course "\n'
             '    "draws across n + 1 steps at most the start with what is given there and r a step after, "\n'
             '    "exactly where it stands where R gives r at every step to the n-th and leaves nothing; where "\n'
             '    "such a level is within reach and the capacity, over at least two steps, every optimum of "\n'
             '    "every order rising with the draw is such a course, breaking at the first step a dependence "\n'
             '    "whose need lies above every such level and keeping to the horizon one they all meet; "\n'
             '    "Holding: under the logistic law s (2 - s) from the dweller\'s need the optimum holds the "\n'
             '    "source at one and breaks the dweller, and under a gate holding at the need and below it "\n'
             '    "are both optima, taking the same. "\n')
README_OLD = '`Optimum.Renewing.restraint_holds_more` |'
README_NEW = ('`Optimum.Renewing.restraint_holds_more`; ranked as whole courses over a horizon, what a course draws, '
              'leaves and forgoes adds to the start with the greatest renewal a step (`Optimum.drawn_add_shortfall`, '
              '`Flow.Balances.taken_add_shortfall`), so balanced courses are ranked by what is taken exactly as by what '
              'they forgo and leave (`Flow.Balances.taken_le_iff`) and two given alike and ending alike take the same '
              '(`Flow.Balances.taken_eq_of_alike`); against a renewal given by a law of the level the courses drawing the '
              'most are exactly those holding a level of greatest renewal through the horizon and leaving nothing '
              '(`Optimum.most_iff`), every optimum is one where such a level is within reach and the capacity '
              '(`Optimum.frontier_holds`), breaking at the first step a dependence above every such level '
              '(`Web.frontier_broken`) and keeping to the horizon one they all meet (`Web.frontier_kept`); witnesses '
              '`Optimum.Holding.logistic_broken`, `Optimum.Holding.gated_alike` |')
README_ZH_OLD = '`Optimum.Renewing.alone_kept`、`Optimum.Renewing.restraint_holds_more` |'
README_ZH_NEW = ('`Optimum.Renewing.alone_kept`、`Optimum.Renewing.restraint_holds_more`；按整个进程在一个视野上排序时，'
                 '进程所抽取、所留下与所放弃者之和是起点加每步最大更新（`Optimum.drawn_add_shortfall`、'
                 '`Flow.Balances.taken_add_shortfall`），故平衡的进程按所取排序恰如按所放弃与所留下排序'
                 '（`Flow.Balances.taken_le_iff`），给予相同、终点相同的两个进程所取相同（`Flow.Balances.taken_eq_of_alike`）；'
                 '更新是水平的一个律时，抽取最多的进程恰是在视野内保持在最大更新的水平、终点不留的进程（`Optimum.most_iff`），'
                 '这样的水平可及且容量足够时每个最优都是如此（`Optimum.frontier_holds`），在第一步就打破所需高于所有这些水平的'
                 '依存（`Web.frontier_broken`），而把它们都满足的依存保持到视野之末（`Web.frontier_kept`）；见证 '
                 '`Optimum.Holding.logistic_broken`、`Optimum.Holding.gated_alike` |')

root = (PKG / 'Becoming.lean').read_text()
(PKG / 'Becoming.lean').write_text(once(root, DOC_OLD, DOC_NEW))
chk = (PKG / 'check_becoming.py').read_text()
(PKG / 'check_becoming.py').write_text(once(chk, SCOPE_OLD, SCOPE_NEW))
rd = (PKG / 'README.md').read_text()
(PKG / 'README.md').write_text(once(rd, README_OLD, README_NEW))
zh = (PKG / 'README.zh.md').read_text()
(PKG / 'README.zh.md').write_text(once(zh, README_ZH_OLD, README_ZH_NEW))
print('integrated')
