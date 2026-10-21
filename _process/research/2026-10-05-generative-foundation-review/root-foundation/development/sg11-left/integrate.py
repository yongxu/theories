#!/usr/bin/env python3
"""Join SG11's laws to the core package: copy the extended Becoming.Optimum in, extend its root doc bullet, its scope
text in check_becoming.py and its README rows (EN, ZH).
usage: python3 -B integrate.py   (SG11_ROOT names the checkout to edit; each edit must match exactly once)"""
import os
import shutil
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = Path(os.environ['SG11_ROOT']).resolve() if os.environ.get('SG11_ROOT') else HERE.parents[5]
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'


def once(text, old, new):
    assert text.count(old) == 1, ('edit does not match once', old[:90], text.count(old))
    return text.replace(old, new)


target = PKG / 'Becoming' / 'Optimum.lean'
assert 'byDrawnLeft' not in target.read_text(), 'already integrated'
shutil.copyfile(HERE / 'tree' / 'Becoming' / 'Optimum.lean', target)

DOC_OLD = "  gate, under which holding at the dweller's need and below it are both optima.\n"
DOC_NEW = (DOC_OLD +
           '  Valuing what is left after the horizon alike with what is drawn, the courses ranked most\n'
           '  are exactly those holding a level of greatest renewal through the horizon, whatever they\n'
           '  leave, and every optimum is one where such a level is within reach and the capacity\n'
           '  covers the renewal: the course keeping that level past the horizon is an optimum, as is\n'
           '  the one drawing it down at the end, so the drain at the end is no longer forced; a\n'
           '  dependence every such level meets is kept to the horizon, and one above them all is\n'
           '  broken at the first step as before. Witnesses: under a gate, keeping the source at the\n'
           '  dweller\'s need through and past the horizon is an optimum, no optimum by the draw alone;\n'
           '  under the logistic law every optimum still breaks the dweller.\n')
SCOPE_OLD = '    "are both optima, taking the same; kept at a need m through the horizon, where R gives at "\n'
SCOPE_NEW = ('    "are both optima, taking the same; valuing what is left after the horizon alike with what is "\n'
             '    "drawn, a course draws across n + 1 steps with what it leaves at most the start with what is "\n'
             '    "given there and r a step after, exactly where R gives r at every step to the n-th, whatever "\n'
             '    "it leaves; where such a level y is within reach and the capacity covers the first step\'s "\n'
             '    "draw down to y and r, over any horizon, every optimum of every order rising with what is "\n'
             '    "drawn and left stands where R gives r at every step to the n-th, the optima of the order by "\n'
             '    "what is drawn and left are exactly the open courses doing so, the course holding y and "\n'
             '    "leaving it is one, and over at least two steps with a capacity covering y with r so is the "\n'
             '    "course leaving nothing; where y is positive the course leaving it is no optimum of the "\n'
             '    "order by the draw alone; under every such optimum a dependence every such level meets is "\n'
             '    "kept to the horizon and one whose need lies above every such level is broken at the first "\n'
             '    "step; Holding: under the gate from the dweller\'s need with capacity three the course keeping "\n'
             '    "the source at two through and past the horizon is an optimum and keeps the dweller at every "\n'
             '    "step, draining it at the end is one too, and keeping is no optimum by the draw alone; under "\n'
             '    "the logistic law every such optimum breaks the dweller at the first step; kept at a need m "\n'
             '    "through the horizon, where R gives at "\n')
README_OLD = 'witnesses `Optimum.Holding.logistic_broken`, `Optimum.Holding.gated_alike`; '
README_NEW = (README_OLD +
              'valuing what is left after the horizon alike with what is drawn (`Optimum.byDrawnLeft`), a course '
              'draws with what it leaves at most the same (`Optimum.drawn_add_left_le_most`, '
              '`Optimum.open_left_le_most`), exactly where it holds a level of greatest renewal through the horizon, '
              'whatever it leaves (`Optimum.most_left_iff`); with a capacity covering the first step\'s draw and the '
              'greatest renewal, over any horizon, every optimum of every order rising with what is drawn and left is '
              'such a course (`Optimum.frontier_holds_left`), the optima of that order are exactly the open courses '
              'doing so (`Optimum.frontier_left_iff`), the course keeping such a level past the horizon is one '
              '(`Optimum.keeping_frontier_left`, `Optimum.holdingTo_same`) as is the one leaving nothing '
              '(`Optimum.holding_frontier_left`), where by what is drawn alone keeping it is none '
              '(`Optimum.keeping_not_frontier`); a dependence they all meet is kept to the horizon '
              '(`Web.frontier_kept_left`) and one above them all broken at the first step (`Web.frontier_broken_left`); '
              'witnesses `Optimum.Holding.gated_left`, `Optimum.Holding.logistic_left`; ')
README_ZH_OLD = '见证 `Optimum.Holding.logistic_broken`、`Optimum.Holding.gated_alike`；'
README_ZH_NEW = (README_ZH_OLD +
                 '视野之后所留与所抽取同等计值时（`Optimum.byDrawnLeft`），进程所抽取与所留下之和至多相同'
                 '（`Optimum.drawn_add_left_le_most`、`Optimum.open_left_le_most`），恰在它于视野内保持在最大更新的水平时'
                 '取等，不论留下多少（`Optimum.most_left_iff`）；容量覆盖第一步的抽取与最大更新时，在任何视野上，'
                 '每个随所抽取与所留下升高之序的每个最优都是这样的进程（`Optimum.frontier_holds_left`），该序的最优恰是'
                 '如此的开放进程（`Optimum.frontier_left_iff`），把该水平保持到视野之后的进程是一个最优'
                 '（`Optimum.keeping_frontier_left`、`Optimum.holdingTo_same`），终点不留的进程亦是'
                 '（`Optimum.holding_frontier_left`），而只按所抽取排序时保持者不是最优（`Optimum.keeping_not_frontier`）；'
                 '它们都满足的依存保持到视野之末（`Web.frontier_kept_left`），高于它们全部的依存在第一步即被打破'
                 '（`Web.frontier_broken_left`）；见证 `Optimum.Holding.gated_left`、`Optimum.Holding.logistic_left`；')

root = (PKG / 'Becoming.lean').read_text()
(PKG / 'Becoming.lean').write_text(once(root, DOC_OLD, DOC_NEW))
chk = (PKG / 'check_becoming.py').read_text()
(PKG / 'check_becoming.py').write_text(once(chk, SCOPE_OLD, SCOPE_NEW))
rd = (PKG / 'README.md').read_text()
(PKG / 'README.md').write_text(once(rd, README_OLD, README_NEW))
zh = (PKG / 'README.zh.md').read_text()
(PKG / 'README.zh.md').write_text(once(zh, README_ZH_OLD, README_ZH_NEW))
print('integrated')
