#!/usr/bin/env python3
"""Join SG13's laws to the core package: copy the extended Becoming.Optimum in, extend its root doc bullet, its scope
text in check_becoming.py and its README rows (EN, ZH).
usage: python3 -B integrate.py   (SG13_ROOT names the checkout to edit; each edit must match exactly once)"""
import os
import shutil
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = Path(os.environ['SG13_ROOT']).resolve() if os.environ.get('SG13_ROOT') else HERE.parents[5]
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'


def once(text, old, new):
    assert text.count(old) == 1, ('edit does not match once', old[:90], text.count(old))
    return text.replace(old, new)


target = PKG / 'Becoming' / 'Optimum.lean'
assert 'metCount' not in target.read_text(), 'already integrated'
shutil.copyfile(HERE / 'tree' / 'Becoming' / 'Optimum.lean', target)

DOC_OLD = '  step to the last step, at most one a step breaks it.\n'
DOC_NEW = (DOC_OLD +
           '  Counted at every step met, wherever, each met step still forgoes at least r - q, but a\n'
           '  fall met again loses the coupling only at the steps below: every optimum keeps the need\n'
           '  where r + e < q + c + m and e < c, strictly above the count from the start. Witness: under\n'
           '  a burst renewing four at one, a coupling of four a step keeps the dweller counted from the\n'
           '  start, while counting every step met a course falling once and met again is an optimum.\n')
SCOPE_OLD = '    "step, and at most one a step breaks it; with the draw of the step from t weighted by w t, "\n'
SCOPE_NEW = ('    "step, and at most one a step breaks it; counting every step from the first to the last at "\n'
             '    "which a course stands at m or above, wherever, each such step forgoes at least r - q, the "\n'
             '    "count from the start its case, so a course below m at some step is worth at most the "\n'
             '    "keeping course ending at e where r <= q + c, r + e <= q + c + m and e <= c, every optimum "\n'
             '    "keeps m through the horizon where r + e < q + c + m and e < c, and the keeping course "\n'
             '    "ending at m is an optimum where r <= q + c and m <= c; Holding: under a burst renewing "\n'
             '    "four at one, from the dweller\'s need with capacity three, a coupling of four a step keeps "\n'
             '    "the dweller under every optimum counting from the start, while counting every step met the "\n'
             '    "course falling once and met again is an optimum beside the course keeping it, and five a "\n'
             '    "step keeps it; with the draw of the step from t weighted by w t, "\n')
README_OLD = 'witness `Optimum.Holding.logistic_stepwise`; '
README_NEW = (README_OLD +
              'counted at every step met, wherever (`Optimum.metCount`), each met step forgoes at least `r - q` '
              '(`Optimum.shortfall_count_ge`, of which `Optimum.shortfall_ge` is the case; '
              '`Optimum.met_count_drawn_le`), so every optimum keeps the need where `r + e < q + c + m` and `e < c` '
              '(`Optimum.frontier_keeps_met`, `Web.frontier_met_kept`) and the keeping course is an optimum where '
              '`r ≤ q + c` and `m ≤ c` (`Optimum.continued_met_frontier`): a fall met again loses the coupling only at '
              'the steps below, so the threshold rises above the count from the start; witness '
              '`Optimum.Holding.burst_met`; ')
README_ZH_OLD = '见证 `Optimum.Holding.logistic_stepwise`；'
README_ZH_NEW = (README_ZH_OLD +
                 '按每个被满足的步计数而不论其位置时（`Optimum.metCount`），每个被满足的步仍至少放弃 `r - q`'
                 '（`Optimum.shortfall_count_ge`，`Optimum.shortfall_ge` 是其情形；`Optimum.met_count_drawn_le`），故在 '
                 '`r + e < q + c + m` 且 `e < c` 时每个最优都保持所需（`Optimum.frontier_keeps_met`、`Web.frontier_met_kept`），'
                 '在 `r ≤ q + c` 且 `m ≤ c` 时保持的进程是最优（`Optimum.continued_met_frontier`）：跌落后再被满足只在其下各步失去耦合，'
                 '故门槛高于自起点计数的门槛；见证 `Optimum.Holding.burst_met`；')

root = (PKG / 'Becoming.lean').read_text()
(PKG / 'Becoming.lean').write_text(once(root, DOC_OLD, DOC_NEW))
chk = (PKG / 'check_becoming.py').read_text()
(PKG / 'check_becoming.py').write_text(once(chk, SCOPE_OLD, SCOPE_NEW))
rd = (PKG / 'README.md').read_text()
(PKG / 'README.md').write_text(once(rd, README_OLD, README_NEW))
zh = (PKG / 'README.zh.md').read_text()
(PKG / 'README.zh.md').write_text(once(zh, README_ZH_OLD, README_ZH_NEW))
print('integrated')
