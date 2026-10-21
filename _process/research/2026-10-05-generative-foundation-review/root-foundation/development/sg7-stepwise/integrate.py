#!/usr/bin/env python3
"""Join SG7's laws to the core package: copy the extended Becoming.Optimum in, extend its root doc bullet, its scope
text in check_becoming.py and its README rows (EN, ZH).
usage: python3 -B integrate.py   (SG7_ROOT names the checkout to edit; each edit must match exactly once)"""
import os
import shutil
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = Path(os.environ['SG7_ROOT']).resolve() if os.environ.get('SG7_ROOT') else HERE.parents[5]
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'


def once(text, old, new):
    assert text.count(old) == 1, ('edit does not match once', old[:90], text.count(old))
    return text.replace(old, new)


target = PKG / 'Becoming' / 'Optimum.lean'
assert 'metRun' not in target.read_text(), 'already integrated'
shutil.copyfile(HERE / 'tree' / 'Becoming' / 'Optimum.lean', target)

DOC_OLD = '  n + 2 steps forgoes n + 3.\n'
DOC_NEW = ('  n + 2 steps forgoes n + 3.\n'
           '  A course met at a need through j steps draws, with r for each of them, at most the start\n'
           '  with r a step and q for each of them: each met step forgoes at least r - q. So a coupling\n'
           '  of c for each step the need stays met keeps it at every horizon where r <= q + c and c\n'
           '  exceeds the end the keeping course reaches; where c with the end the capacity reaches is\n'
           '  below the need every optimum breaks it within the horizon, and where also r < q + c at the\n'
           '  last step alone; where q + c < r a long horizon outweighs it. Optima exist in every case.\n'
           '  Witness: under the logistic law three a step keeps the dweller at every horizon, two a\n'
           '  step to the last step, at most one a step breaks it.\n')
SCOPE_OLD = '    "n + 2 steps forgoes n + 3. "\n'
SCOPE_NEW = ('    "n + 2 steps forgoes n + 3; a course standing at m or above at every step to the j-th, "\n'
             '    "j <= n, draws across n + 1 steps, with r for each of those steps, at most the start with "\n'
             '    "what is given there, r a step and q for each of those steps; for a worth adding c for "\n'
             '    "each step met, every optimum of every order rising with it keeps m through the horizon "\n'
             '    "where r <= q + c and c exceeds the end e the keeping course reaches, m <= e; meets m at "\n'
             '    "every step to the n-th where r < q + c; falls below m within the horizon where c + e < m, "\n'
             '    "e the end the capacity reaches, and so at the last step alone where also r < q + c and "\n'
             '    "c < m; and where q + c < r and c + e < n + m it breaks the dependence within the horizon; "\n'
             '    "the course keeping m, the course keeping it to the last step and ending at nothing, and "\n'
             '    "the course holding the greatest renewal are optima under r <= q + c with m < c, under "\n'
             '    "r <= q + c with c <= m, and under q + c <= r with c <= m; Holding: under the logistic law "\n'
             '    "a coupling of three a step keeps the dweller at every horizon, two a step to the last "\n'
             '    "step, and at most one a step breaks it. "\n')
README_OLD = '`Optimum.Holding.logistic_coupled` |'
README_NEW = ('`Optimum.Holding.logistic_coupled`; a course met at the need through `j` steps draws, with `r` for each '
              'of them, at most the start with `r` a step and `q` for each of them (`Optimum.met_drawn_le`, '
              '`Optimum.shortfall_ge`, `Flow.Balances.met_taken_le`), so a coupling `c` for each step met keeps the '
              'need at every horizon where `r ≤ q + c` and `c` exceeds the end (`Optimum.frontier_keeps_stepwise`, '
              '`Web.frontier_keeps_stepwise`), keeps it to the last step where `r < q + c` '
              '(`Optimum.frontier_met_before_end`, `Web.frontier_met_before_end`), breaks it within the horizon where '
              '`c` with the end is below the need (`Optimum.frontier_breaks_at_end`, `Web.frontier_breaks_at_end`), at '
              'the last step alone where both (`Web.frontier_breaks_last`), and is outweighed by a long horizon where '
              '`q + c < r` (`Optimum.outweighed_stepwise`, `Web.frontier_breaks_stepwise_long`); optima in every case '
              '(`Optimum.continued_stepwise_frontier`, `Optimum.continued_ending_stepwise_frontier`, '
              '`Optimum.continued_holding_stepwise_frontier`); witness `Optimum.Holding.logistic_stepwise` |')
README_ZH_OLD = '`Optimum.Holding.logistic_coupled` |'
README_ZH_NEW = ('`Optimum.Holding.logistic_coupled`；在所需之上维持 `j` 步的进程，加上这些步每步 `r`，所抽取至多是起点、每步 `r` '
                 '与这些步每步 `q`（`Optimum.met_drawn_le`、`Optimum.shortfall_ge`、`Flow.Balances.met_taken_le`），'
                 '故每维持一步加 `c` 的耦合：`r ≤ q + c` 且 `c` 超过终点时在每个视野都保持所需'
                 '（`Optimum.frontier_keeps_stepwise`、`Web.frontier_keeps_stepwise`），`r < q + c` 时保持到最后一步'
                 '（`Optimum.frontier_met_before_end`、`Web.frontier_met_before_end`），`c` 加终点低于所需时在视野内打破它'
                 '（`Optimum.frontier_breaks_at_end`、`Web.frontier_breaks_at_end`），两者兼具时只在最后一步打破'
                 '（`Web.frontier_breaks_last`），`q + c < r` 时被长视野压过（`Optimum.outweighed_stepwise`、'
                 '`Web.frontier_breaks_stepwise_long`）；每种情形都有最优（`Optimum.continued_stepwise_frontier`、'
                 '`Optimum.continued_ending_stepwise_frontier`、`Optimum.continued_holding_stepwise_frontier`）；见证 '
                 '`Optimum.Holding.logistic_stepwise` |')

root = (PKG / 'Becoming.lean').read_text()
(PKG / 'Becoming.lean').write_text(once(root, DOC_OLD, DOC_NEW))
chk = (PKG / 'check_becoming.py').read_text()
(PKG / 'check_becoming.py').write_text(once(chk, SCOPE_OLD, SCOPE_NEW))
rd = (PKG / 'README.md').read_text()
(PKG / 'README.md').write_text(once(rd, README_OLD, README_NEW))
zh = (PKG / 'README.zh.md').read_text()
(PKG / 'README.zh.md').write_text(once(zh, README_ZH_OLD, README_ZH_NEW))
print('integrated')
