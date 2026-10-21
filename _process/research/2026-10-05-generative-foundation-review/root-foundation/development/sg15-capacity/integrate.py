#!/usr/bin/env python3
"""Join SG15's laws to the core package: copy the extended Becoming.Optimum in, extend its root doc entry, its scope
text in check_becoming.py and its README rows (EN, ZH).
usage: python3 -B integrate.py   (SG15_ROOT names the checkout to edit; each edit must match exactly once)"""
import os
import shutil
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = Path(os.environ['SG15_ROOT']).resolve() if os.environ.get('SG15_ROOT') else HERE.parents[5]
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'


def once(text, old, new):
    assert text.count(old) == 1, ('edit does not match once', old[:90], text.count(old))
    return text.replace(old, new)


target = PKG / 'Becoming' / 'Optimum.lean'
assert 'def PerfectWithin' not in target.read_text(), 'already integrated'
shutil.copyfile(HERE / 'tree' / 'Becoming' / 'Optimum.lean', target)
DOC_OLD = '  within twice the horizon. Witness: from restraint under the gate, revision breaks the dweller.\n'
DOC_NEW = (DOC_OLD +
           '  Where capacities limit a draw, each draws to capacity at the last step and wherever what the\n'
           '  other draws after is fixed; with no limit this is the perfect profile. Witness: under doubling, a\n'
           '  one-unit limit on the second makes leaving everything the first\'s best response, keeping the dweller.\n')
SCOPE_OLD = ('    "two drawers both leaving everything keep the dweller, and revised from round 2 (n + 2) on they "\n'
             '    "break it. "\n')
SCOPE_NEW = ('    "two drawers both leaving everything keep the dweller, and revised from round 2 (n + 2) on they "\n'
             '    "break it; where each leaves at least a floor (a capacity), every profile perfect within the "\n'
             '    "capacities has each leave its floor at the last step, the second wherever it draws nothing "\n'
             '    "after and the first wherever what it draws after does not depend on what it leaves, and with "\n'
             '    "no floor it is perfect; Holding: under doubling over two steps, the second taking at most one "\n'
             '    "unit, every such profile has the first leave everything at the first step from three, keeping "\n'
             '    "the dweller, which every unlimited perfect profile breaks. "\n')
README_OLD = '`Optimum.Holding.gated_revised` |'
README_NEW = ('`Optimum.Holding.gated_revised`; where capacities limit a draw (`Optimum.InTurn.PerfectWithin`), each draws '
              'to capacity at the last step (`Optimum.InTurn.last_at_floor`) and wherever what the other draws after is '
              'fixed (`Optimum.InTurn.second_at_floor`, `Optimum.InTurn.first_at_floor`), with no limit perfect '
              '(`Optimum.InTurn.within_zero_iff`); a limit on the other\'s draw can make restraint the best response '
              '(`Optimum.Holding.doubling_capacity`) |')
README_ZH_OLD = '`Optimum.Holding.gated_revised` |'
README_ZH_NEW = ('`Optimum.Holding.gated_revised`；容量限制抽取时（`Optimum.InTurn.PerfectWithin`），各自在最后一步抽到容量'
                 '（`Optimum.InTurn.last_at_floor`），在对方此后所抽固定之处亦然（`Optimum.InTurn.second_at_floor`、'
                 '`Optimum.InTurn.first_at_floor`），无限制时即完美（`Optimum.InTurn.within_zero_iff`）；对方抽取受限可使克制成为最优回应'
                 '（`Optimum.Holding.doubling_capacity`） |')
for name, old, new in (('Becoming.lean', DOC_OLD, DOC_NEW), ('check_becoming.py', SCOPE_OLD, SCOPE_NEW),
                       ('README.md', README_OLD, README_NEW), ('README.zh.md', README_ZH_OLD, README_ZH_NEW)):
    p = PKG / name
    p.write_text(once(p.read_text(), old, new))
print('integrated')
