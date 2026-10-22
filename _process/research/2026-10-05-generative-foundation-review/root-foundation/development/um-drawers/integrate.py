#!/usr/bin/env python3
"""Join UM to the core package: copy the drawers' Optimum (this kit's tree) and the margins' RegimeMargin (the
um-thresholds kit's tree) in, and state the one model and the one law of thresholds in the root doc, the checker
scope and the README rows (EN, ZH).
usage: python3 -B integrate.py   (UM_ROOT names the checkout to edit; each edit must match exactly once)"""
import os
import shutil
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = Path(os.environ['UM_ROOT']).resolve() if os.environ.get('UM_ROOT') else HERE.parents[5]
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'


def once(text, old, new):
    assert text.count(old) == 1, ('edit does not match once', old[:90], text.count(old))
    return text.replace(old, new)


def region(text, start, stop, new):
    assert text.count(start) == 1, ('start not once', start[:80], text.count(start))
    i = text.index(start)
    j = text.index(stop, i) + len(stop)
    return text[:i] + new + text[j:]


opt = PKG / 'Becoming' / 'Optimum.lean'
assert 'theorem kept_returns' not in opt.read_text(), 'already integrated'
shutil.copyfile(HERE / 'tree' / 'Becoming' / 'Optimum.lean', opt)
shutil.copyfile(HERE.parent / 'um-thresholds' / 'tree' / 'Becoming' / 'RegimeMargin.lean', PKG / 'Becoming' / 'RegimeMargin.lean')

root = (PKG / 'Becoming.lean').read_text()
root = region(root, '  With two drawers in turn, each ranking what it draws over the steps that remain, the\n',
              'any number breaks the dweller.\n',
              '  Drawers in turn, one model: k drawers each leaving at least a floor, a profile perfect where it\n'
              '  revises itself; one law, that a best response keeps above its floor only what returns to it\n'
              '  one for one, gives drawing to capacity wherever what is drawn later is fixed and, with no floor\n'
              '  and two or more drawers, every perfect profile and every revision from round 2N on drawing\n'
              '  everything. Witnesses: under a gate restraint is revised away and every perfect profile breaks\n'
              '  the dweller; under doubling a one-unit floor on the second keeps it.\n')
(PKG / 'Becoming.lean').write_text(root)

chk = (PKG / 'check_becoming.py').read_text()
chk = region(chk, '    "leaving half ending and holding at two are both optima; with two drawers in turn at each "\n',
             '    "of any number from two breaks the dweller at the first step. "\n',
             '    "leaving half ending and holding at two are both optima; with k drawers in turn at each step, "\n'
             '    "drawer d leaving of what it is given a at least its floor low d t a and at most a, what the "\n'
             '    "last leaves standing at the next step as G t of it, each ranking what it draws over the "\n'
             '    "steps that remain, a profile revising another where each of its rules is a best response "\n'
             '    "against the other at every step from every level and perfect where it revises itself: what "\n'
             '    "a best response keeps above its floor returns to it at least one for one, so a drawer leaves "\n'
             '    "its floor wherever what it draws later does not depend on what it leaves, every drawer at "\n'
             '    "the last step; with no floor and k at least two, along every sequence of revisions from round "\n'
             '    "2 c on every drawer leaves nothing at the last c steps, a revision always exists, every "\n'
             '    "perfect profile draws everything, drawing everything is perfect, and where the first leaves "\n'
             '    "nothing the base stands at G t 0 and a dependence above G 0 0 met at the start is broken at "\n'
             '    "the first step; Holding: under the gate, alone an optimum keeps the dweller, restraint keeps "\n'
             '    "it, every perfect profile and every profile revised from restraint from round 2 (n + 2) on "\n'
             '    "breaks it; under doubling over two steps with the second taking at most one unit every perfect "\n'
             '    "profile has the first leave everything from three, keeping the dweller. "\n')
(PKG / 'check_becoming.py').write_text(chk)

rd = (PKG / 'README.md').read_text()
rd = region(rd, 'with two drawers in turn, each ranking what it draws over the steps that remain, every profile at a mutual',
            '`Optimum.Holding.gated_turns` |',
            'drawers in turn, one model: `k` drawers each leaving at least a floor, a profile perfect where it revises '
            'itself (`Optimum.InTurn.Revises`, `Optimum.InTurn.Perfect`); one law, what a best response keeps above its '
            'floor returns to it at least one for one (`Optimum.InTurn.kept_returns`), gives drawing to capacity wherever '
            'what is drawn later is fixed (`Optimum.InTurn.at_floor`) and, with no floor and two or more drawers, '
            'revision from any profile drawing everything from round `2 N` on (`Optimum.InTurn.revisions_end`, '
            '`Optimum.InTurn.revised_draw_all`) and every perfect profile drawing everything '
            '(`Optimum.InTurn.perfect_ends`), a dependence above what stands at nothing broken at the first step '
            '(`Web.drained_broken`); witnesses `Optimum.Holding.gated_in_turn`, `Optimum.Holding.doubling_capacity` |')
rd = once(rd, '`Relay` keeping no band (`Coupled.Relay.threshold_beyond_band`);',
          '`Relay` keeping no band (`Coupled.Relay.threshold_beyond_band`); every threshold exact by one law of exact '
          'thresholds (`leading_exact`, `leading_falls`);')
(PKG / 'README.md').write_text(rd)

zh = (PKG / 'README.zh.md').read_text()
zh = region(zh, '；两个抽取者每步轮流、各自按其后各步所抽取排序时，', '`Optimum.Holding.gated_turns` |',
            '；轮流的抽取者，一个模型：`k` 个抽取者各自至少留其下限，组合修订自身即完美（`Optimum.InTurn.Revises`、'
            '`Optimum.InTurn.Perfect`）；一条律，最优回应在下限之上所留至少一对一地回到自身（`Optimum.InTurn.kept_returns`），'
            '给出：此后所抽固定之处抽到容量（`Optimum.InTurn.at_floor`），无下限且两个及以上抽取者时，自任一组合修订自第 `2 N` 轮起全部抽取'
            '（`Optimum.InTurn.revisions_end`、`Optimum.InTurn.revised_draw_all`），每个完美组合全部抽取（`Optimum.InTurn.perfect_ends`），'
            '高于零处所立者的依存在第一步被打破（`Web.drained_broken`）；见证 `Optimum.Holding.gated_in_turn`、'
            '`Optimum.Holding.doubling_capacity` |')
zh = once(zh, '`Relay` 不保持任何带（`Coupled.Relay.threshold_beyond_band`）；',
          '`Relay` 不保持任何带（`Coupled.Relay.threshold_beyond_band`）；每个阈值由一条精确阈值之律而精确（`leading_exact`、`leading_falls`）；')
(PKG / 'README.zh.md').write_text(zh)
print('integrated')
