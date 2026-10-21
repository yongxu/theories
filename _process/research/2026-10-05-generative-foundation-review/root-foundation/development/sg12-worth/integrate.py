#!/usr/bin/env python3
"""Join SG12's laws to the core package: copy the extended Becoming.Optimum in, extend its root doc bullet, its scope
text in check_becoming.py and its README rows (EN, ZH).
usage: python3 -B integrate.py   (SG12_ROOT names the checkout to edit; each edit must match exactly once)"""
import os
import shutil
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = Path(os.environ['SG12_ROOT']).resolve() if os.environ.get('SG12_ROOT') else HERE.parents[5]
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'


def once(text, old, new):
    assert text.count(old) == 1, ('edit does not match once', old[:90], text.count(old))
    return text.replace(old, new)


target = PKG / 'Becoming' / 'Optimum.lean'
assert 'byDrawnLeftAt' not in target.read_text(), 'already integrated'
shutil.copyfile(HERE / 'tree' / 'Becoming' / 'Optimum.lean', target)

DOC_OLD = '  under the logistic law every optimum still breaks the dweller.\n'
DOC_NEW = (DOC_OLD +
           '  At any worth above one for each unit left, where no course leaves more than one step\'s\n'
           '  regrowth from a level of greatest renewal, every optimum holds such a level through the\n'
           '  horizon and regrows to that most at the last step: a dependence above those levels is\n'
           '  broken at the first step and restored only at the end. At every worth a coupling of keeping\n'
           '  a need is outweighed as without the value, keeping forgoing (r - q) n against the course\n'
           '  regrowing at the end. Witness: under the logistic law the source is drawn to one and\n'
           '  regrown to the dweller\'s need at the last step.\n')
SCOPE_OLD = '    "the logistic law every such optimum breaks the dweller at the first step; kept at a need m "\n'
SCOPE_NEW = ('    "the logistic law every such optimum breaks the dweller at the first step; with v of at least "\n'
             '    "one for each unit left, where no open course leaves after n + 1 steps more than y + r, a "\n'
             '    "course draws with v times what it leaves at most the start with what is given there, r a "\n'
             '    "step after and v - 1 times y + r, the course holding y and regrowing to y + r at the last "\n'
             '    "step reaching it and being an optimum; where v > 1, exactly where it stands where R gives r "\n'
             '    "at every step to the n-th and leaves y + r, so every optimum of every order rising with it "\n'
             '    "does so and breaks at the first step a dependence above every such level, restoring it only "\n'
             '    "at the end; at every such v, a worth adding at most w to a course keeping a need m, at or "\n'
             '    "above which R gives at most q, leaves only optima falling below m within the horizon where "\n'
             '    "w + q n < r n; Holding: under the logistic law from the dweller\'s need, the course drawing "\n'
             '    "the source to one and regrowing it to two at the last step is an optimum at every v, the "\n'
             '    "only kind above one, and every coupling below n + 1 is outweighed at every v; kept at a need m "\n')
README_OLD = 'witnesses `Optimum.Holding.gated_left`, `Optimum.Holding.logistic_left`; '
README_NEW = (README_OLD +
              'valuing what is left at any worth `v` of at least one (`Optimum.byDrawnLeftAt`), where no course leaves more '
              'than one step\'s regrowth `y + r` from a level of greatest renewal, a course draws with `v` times what it '
              'leaves at most the start with what is given there, `r` a step after and `v - 1` times `y + r` '
              '(`Optimum.open_valued_le_most`), the course holding `y` and regrowing at the last step reaching it '
              '(`Optimum.regrowing_frontier`); above one, exactly where it holds a level of greatest renewal through the '
              'horizon and leaves `y + r` (`Optimum.valued_most_iff`), so every optimum does so '
              '(`Optimum.frontier_holds_valued`, `Optimum.frontier_valued_iff`), breaking at the first step a dependence '
              'above every such level and restoring it only at the end (`Web.frontier_rebuilt_valued`); at every worth a '
              'coupling `w` of keeping a need is outweighed where `w + q n < r n` (`Optimum.frontier_breaks_valued`, '
              '`Web.frontier_breaks_valued`); witness `Optimum.Holding.logistic_valued`; ')
README_ZH_OLD = '见证 `Optimum.Holding.gated_left`、`Optimum.Holding.logistic_left`；'
README_ZH_NEW = (README_ZH_OLD +
                 '以至少为一的任一价值 `v` 对所留计值时（`Optimum.byDrawnLeftAt`），若没有进程留下多于从最大更新水平一步再生的 `y + r`，'
                 '进程所抽取加 `v` 倍所留至多是起始加所给、此后每步 `r` 再加 `v - 1` 倍 `y + r`（`Optimum.open_valued_le_most`），'
                 '保持在 `y` 并在最后一步再生的进程达到此值（`Optimum.regrowing_frontier`）；`v` 大于一时，恰在进程于视野内保持在最大更新的水平'
                 '并留下 `y + r` 时取等（`Optimum.valued_most_iff`），故每个最优都如此（`Optimum.frontier_holds_valued`、'
                 '`Optimum.frontier_valued_iff`），在第一步打破高于每个这样水平的依存，只在终了才恢复它（`Web.frontier_rebuilt_valued`）；'
                 '在每个价值下，对保持所需的耦合 `w` 在 `w + q n < r n` 时都被胜过（`Optimum.frontier_breaks_valued`、'
                 '`Web.frontier_breaks_valued`）；见证 `Optimum.Holding.logistic_valued`；')

root = (PKG / 'Becoming.lean').read_text()
(PKG / 'Becoming.lean').write_text(once(root, DOC_OLD, DOC_NEW))
chk = (PKG / 'check_becoming.py').read_text()
(PKG / 'check_becoming.py').write_text(once(chk, SCOPE_OLD, SCOPE_NEW))
rd = (PKG / 'README.md').read_text()
(PKG / 'README.md').write_text(once(rd, README_OLD, README_NEW))
zh = (PKG / 'README.zh.md').read_text()
(PKG / 'README.zh.md').write_text(once(zh, README_ZH_OLD, README_ZH_NEW))
print('integrated')
