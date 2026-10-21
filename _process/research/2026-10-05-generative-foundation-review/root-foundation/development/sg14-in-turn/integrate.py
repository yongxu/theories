#!/usr/bin/env python3
"""Join SG14's laws to the core package: copy the extended Becoming.Optimum in, extend its root doc bullet, its scope
text in check_becoming.py and its README rows (EN, ZH).
usage: python3 -B integrate.py   (SG14_ROOT names the checkout to edit; each edit must match exactly once)"""
import os
import shutil
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = Path(os.environ['SG14_ROOT']).resolve() if os.environ.get('SG14_ROOT') else HERE.parents[5]
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'


def once(text, old, new):
    assert text.count(old) == 1, ('edit does not match once', old[:90], text.count(old))
    return text.replace(old, new)


target = PKG / 'Becoming' / 'Optimum.lean'
assert 'namespace InTurn' not in target.read_text(), 'already integrated'
shutil.copyfile(HERE / 'tree' / 'Becoming' / 'Optimum.lean', target)

DOC_OLD = '  rebuilt alone and ended with others drawing first, under the same weights.\n'
DOC_NEW = (DOC_OLD +
           '  With two drawers in turn, each ranking what it draws over the steps that remain, the\n'
           '  others\' rule is derived: at every profile that is a mutual best response at every step\n'
           '  from every level, both leave nothing at every step, so the base stands from the first step\n'
           '  at what stands at nothing, and drawing everything is such a profile. Witness: under a gate,\n'
           '  alone an optimum may keep the dweller; in turn every perfect profile breaks it at once.\n')
SCOPE_OLD = '    "leaving half ending and holding at two are both optima. "\n'
SCOPE_NEW = ('    "leaving half ending and holding at two are both optima; with two drawers in turn at each "\n'
             '    "step, the first leaving first t z of the level z and the second second t a of what the first "\n'
             '    "left, what remains standing at the next step as G t of it, each ranking what it draws over "\n'
             '    "the steps that remain, every profile in which each leaves at most what it is given and the "\n'
             '    "two are at a mutual best response at every step of a horizon from every level has both "\n'
             '    "leave nothing at every step before the horizon, the base standing from the first step at "\n'
             '    "G t 0, and the profile drawing everything is such a profile over every horizon; on a web a "\n'
             '    "dependence on the base whose need, met at the start, is above G 0 0 is broken at the first "\n'
             '    "step; Holding: under the gate from the dweller\'s need, alone an optimum keeps the dweller "\n'
             '    "through the horizon, and in turn every perfect profile breaks it at the first step. "\n')
README_OLD = 'witness `Optimum.Holding.doubling_drawn_first` |'
README_NEW = ('witness `Optimum.Holding.doubling_drawn_first`; with two drawers in turn, each ranking what it draws over '
              'the steps that remain, every profile at a mutual best response at every step from every level '
              '(`Optimum.InTurn.Perfect`) has both leave nothing at every step, so the base stands from the first step '
              'at what stands at nothing (`Optimum.InTurn.perfect_ends`, `Optimum.InTurn.perfect_levels`), drawing '
              'everything being such a profile (`Optimum.InTurn.perfect_of_zero`), and a dependence on the base above '
              'what stands at nothing is broken at the first step (`Web.perfect_broken`); witness '
              '`Optimum.Holding.gated_in_turn` |')
README_ZH_OLD = '见证 `Optimum.Holding.doubling_drawn_first` |'
README_ZH_NEW = ('见证 `Optimum.Holding.doubling_drawn_first`；两个抽取者每步轮流、各自按其后各步所抽取排序时，每步、从每个水平都处于相互最优回应的'
                 '每个组合（`Optimum.InTurn.Perfect`）都使两者每步不留，故自第一步起基础立于零处所立者'
                 '（`Optimum.InTurn.perfect_ends`、`Optimum.InTurn.perfect_levels`），全部抽取即是这样的组合'
                 '（`Optimum.InTurn.perfect_of_zero`），对基础的依存若高于零处所立者则在第一步被打破（`Web.perfect_broken`）；见证 '
                 '`Optimum.Holding.gated_in_turn` |')

root = (PKG / 'Becoming.lean').read_text()
(PKG / 'Becoming.lean').write_text(once(root, DOC_OLD, DOC_NEW))
chk = (PKG / 'check_becoming.py').read_text()
(PKG / 'check_becoming.py').write_text(once(chk, SCOPE_OLD, SCOPE_NEW))
rd = (PKG / 'README.md').read_text()
(PKG / 'README.md').write_text(once(rd, README_OLD, README_NEW))
zh = (PKG / 'README.zh.md').read_text()
(PKG / 'README.zh.md').write_text(once(zh, README_ZH_OLD, README_ZH_NEW))
print('integrated')
