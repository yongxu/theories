#!/usr/bin/env python3
"""Join SG6's laws to the core package: copy the extended Becoming.Optimum in, extend its root doc bullet, its scope
text in check_becoming.py and its README rows (EN, ZH).
usage: python3 -B integrate.py   (SG6_ROOT names the checkout to edit; each edit must match exactly once)"""
import os
import shutil
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = Path(os.environ['SG6_ROOT']).resolve() if os.environ.get('SG6_ROOT') else HERE.parents[5]
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'


def once(text, old, new):
    assert text.count(old) == 1, ('edit does not match once', old[:90], text.count(old))
    return text.replace(old, new)


target = PKG / 'Becoming' / 'Optimum.lean'
assert 'holdingTo' not in target.read_text(), 'already integrated'
shutil.copyfile(HERE / 'tree' / 'Becoming' / 'Optimum.lean', target)

DOC_OLD = '  gate, under which holding at the dweller\'s need and below it are both optima.\n'
DOC_NEW = ('  gate, under which holding at the dweller\'s need and below it are both optima.\n'
           '  Kept at a need through the horizon, where what is given at or above the need is at most q,\n'
           '  a course draws with what it leaves at most the start with q a step, and the optima among\n'
           '  the keeping courses hold where q is given and leave exactly the need; so keeping forgoes,\n'
           '  against the course holding the greatest renewal r and leaving nothing, (r - q) n and the\n'
           '  need. A coupling of the dependence below that amount leaves only optima breaking it within\n'
           '  the horizon, one beyond it only optima keeping it, and both have optima; where the need\n'
           '  lies above every level of greatest renewal the amount grows with the horizon and outweighs\n'
           '  every coupling short of it. Witness: under the logistic law, keeping the dweller through\n'
           '  n + 2 steps forgoes n + 3.\n')
SCOPE_OLD = '    "are both optima, taking the same. "\n'
SCOPE_NEW = ('    "are both optima, taking the same; kept at a need m through the horizon, where R gives at "\n'
             '    "most q at or above m, a course draws with what it leaves at most the start with what is "\n'
             '    "given there and q a step after, and every optimum among the keeping courses of every order "\n'
             '    "rising with the draw holds where q is given and leaves exactly m, the course holding such a "\n'
             '    "level being one; so keeping forgoes (r - q) n + m, an order adding to a keeping course a "\n'
             '    "coupling w with w + q n + e < r n + m, e the end the capacity reaches at or below the level "\n'
             '    "of greatest renewal, has only optima falling below m within the horizon, one adding w with "\n'
             '    "r n + e < w + q n and nothing to a course below m only optima keeping it, e between m and "\n'
             '    "the level holding q, and for a worth adding exactly w both have optima; where q < r every "\n'
             '    "coupling w with w + e < n + m is outweighed; the courses attaining these bounds draw "\n'
             '    "nothing after the horizon; Holding: under the logistic law keeping the dweller through "\n'
             '    "n + 2 steps forgoes n + 3. "\n')
README_OLD = '`Optimum.Holding.logistic_broken`, `Optimum.Holding.gated_alike` |'
README_NEW = ('`Optimum.Holding.logistic_broken`, `Optimum.Holding.gated_alike`; kept at a need through the horizon, a course '
              'draws with what it leaves at most the start with the greatest renewal at or above the need a step '
              '(`Optimum.keeping_le_most`, `Flow.Balances.keeping_taken_le`), the optima among the keeping courses hold '
              'that renewal and leave exactly the need (`Optimum.frontier_keeps`, `Web.frontier_keeps`, '
              '`Optimum.continued_keeping_frontier`), so keeping forgoes `(r - q) n + m`: a coupling of the dependence '
              'below that leaves only optima breaking it within the horizon (`Optimum.frontier_breaks_below`, '
              '`Web.frontier_breaks_below`), one beyond it only optima keeping it (`Optimum.frontier_keeps_above`, '
              '`Web.frontier_keeps_above`), both with optima (`Optimum.continued_breaking_frontier`, '
              '`Optimum.continued_kept_frontier`); where the need lies above every level of greatest renewal the amount '
              'grows with the horizon (`Optimum.forgone_grows`, `Web.frontier_breaks_long`); witness '
              '`Optimum.Holding.logistic_coupled` |')
README_ZH_OLD = '`Optimum.Holding.logistic_broken`、`Optimum.Holding.gated_alike` |'
README_ZH_NEW = ('`Optimum.Holding.logistic_broken`、`Optimum.Holding.gated_alike`；在视野内把条件保持在所需之上时，'
                 '进程所抽取与所留下之和至多是起点加每步所需之上的最大更新（`Optimum.keeping_le_most`、'
                 '`Flow.Balances.keeping_taken_le`），保持的进程中的最优停在给出该更新的水平、终点恰留所需（`Optimum.frontier_keeps`、'
                 '`Web.frontier_keeps`、`Optimum.continued_keeping_frontier`），故保持放弃 `(r - q) n + m`：'
                 '对依存的耦合低于此量时每个最优都在视野内打破它（`Optimum.frontier_breaks_below`、`Web.frontier_breaks_below`），'
                 '高于此量时每个最优都保持它（`Optimum.frontier_keeps_above`、`Web.frontier_keeps_above`），两者都有最优'
                 '（`Optimum.continued_breaking_frontier`、`Optimum.continued_kept_frontier`）；所需高于所有最大更新的水平时，'
                 '此量随视野增长（`Optimum.forgone_grows`、`Web.frontier_breaks_long`）；见证 '
                 '`Optimum.Holding.logistic_coupled` |')

root = (PKG / 'Becoming.lean').read_text()
(PKG / 'Becoming.lean').write_text(once(root, DOC_OLD, DOC_NEW))
chk = (PKG / 'check_becoming.py').read_text()
(PKG / 'check_becoming.py').write_text(once(chk, SCOPE_OLD, SCOPE_NEW))
rd = (PKG / 'README.md').read_text()
(PKG / 'README.md').write_text(once(rd, README_OLD, README_NEW))
zh = (PKG / 'README.zh.md').read_text()
(PKG / 'README.zh.md').write_text(once(zh, README_ZH_OLD, README_ZH_NEW))
print('integrated')
