#!/usr/bin/env python3
"""Join RM7's core laws to the package: copy the extended Becoming.RegimeMargin in, extend its root doc bullet, its
scope text in check_becoming.py and its README rows (EN, ZH).
usage: python3 -B integrate.py   (RM7_ROOT names the checkout to edit; each edit must match exactly once)"""
import os
import shutil
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = Path(os.environ['RM7_ROOT']).resolve() if os.environ.get('RM7_ROOT') else HERE.parents[5]
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'


def once(text, old, new):
    assert text.count(old) == 1, ('edit does not match once', old[:90], text.count(old))
    return text.replace(old, new)


target = PKG / 'Becoming' / 'RegimeMargin.lean'
assert 'namespace Indexed' not in target.read_text(), 'already integrated'
shutil.copyfile(HERE / 'tree' / 'Becoming' / 'RegimeMargin.lean', target)

RM_DOC_OLD = '  of which holds alone in a cycle that never rests.\n'
RM_DOC_NEW = (RM_DOC_OLD +
              '  The laws of order, ending and dependence hold of a web of any number of conditions, the pair its\n'
              '  case: along every chain of dependence, with positive draws, the end of one ends everything\n'
              '  downstream of it, and a dependence cycle ends together.\n')
RM_SCOPE_OLD = '    "outside a band a pair each of which ends alone moves between (2, 3) and (3, 2) for ever. "\n'
RM_SCOPE_NEW = (RM_SCOPE_OLD +
                '    "A web of any number of conditions, indexed by any type, each giving from what is left of all "\n'
                '    "(Coupled.Indexed): under mutual support its step keeps the order of states and ending is "\n'
                '    "down-closed; a condition giving nothing where nothing is left of another drains once the other "\n'
                '    "stays within its draw, and along every chain of dependence, with positive draws, the end of one "\n'
                '    "ends everything downstream of it; the pair is the web indexed by Bool and its laws of order, "\n'
                '    "ending and dependence are read off the web\'s; three conditions in a chain cascade, and a zero "\n'
                '    "draw on the chain stops it. "\n')
RM_README_OLD = 'of which holds alone in a cycle that never rests (`Coupled.Relay.cycles`) |'
RM_README_NEW = ('of which holds alone in a cycle that never rests (`Coupled.Relay.cycles`); a web of any number of conditions '
                 '(`Coupled.Indexed.step`), the pair its case (`Coupled.pair_run`): under mutual support its step keeps the '
                 'order of states (`Coupled.Indexed.step_mono`), and along every chain of dependence, with positive draws, '
                 'the end of one ends everything downstream of it (`Coupled.Indexed.ends_downstream`), a dependence cycle '
                 'ending together (`Coupled.Indexed.ends_together`); the cascade reaches past direct dependence '
                 '(`Coupled.Indexed.Chain.cascades`) and a zero draw on the chain stops it '
                 '(`Coupled.Indexed.Chain.stopped`) |')
RM_README_ZH_OLD = '可以在永不静止的循环中维持两个单独都不能维持的条件（`Coupled.Relay.cycles`） |'
RM_README_ZH_NEW = ('可以在永不静止的循环中维持两个单独都不能维持的条件（`Coupled.Relay.cycles`）；任意多个条件之网（`Coupled.Indexed.step`），'
                    '一对是其情形（`Coupled.pair_run`）：相互支持下其步保持状态之序（`Coupled.Indexed.step_mono`），沿每条依赖之链，汲取为正时，'
                    '一个的终结终结其下游的一切（`Coupled.Indexed.ends_downstream`），依赖之环同终（`Coupled.Indexed.ends_together`）；'
                    '级联越过直接依赖（`Coupled.Indexed.Chain.cascades`），链上为零的汲取使其停止（`Coupled.Indexed.Chain.stopped`） |')

root = (PKG / 'Becoming.lean').read_text()
(PKG / 'Becoming.lean').write_text(once(root, RM_DOC_OLD, RM_DOC_NEW))
chk = (PKG / 'check_becoming.py').read_text()
(PKG / 'check_becoming.py').write_text(once(chk, RM_SCOPE_OLD, RM_SCOPE_NEW))
rd = (PKG / 'README.md').read_text()
(PKG / 'README.md').write_text(once(rd, RM_README_OLD, RM_README_NEW))
zh = (PKG / 'README.zh.md').read_text()
(PKG / 'README.zh.md').write_text(once(zh, RM_README_ZH_OLD, RM_README_ZH_NEW))
print('integrated')
