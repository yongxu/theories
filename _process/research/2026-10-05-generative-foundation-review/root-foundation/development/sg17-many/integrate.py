#!/usr/bin/env python3
"""Join SG17's laws to the core package: copy the extended Becoming.Optimum in, extend its root doc entry, its scope
text in check_becoming.py and its README rows (EN, ZH).
usage: python3 -B integrate.py   (SG17_ROOT names the checkout to edit; each edit must match exactly once)"""
import os
import shutil
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = Path(os.environ['SG17_ROOT']).resolve() if os.environ.get('SG17_ROOT') else HERE.parents[5]
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'


def once(text, old, new):
    assert text.count(old) == 1, ('edit does not match once', old[:90], text.count(old))
    return text.replace(old, new)


target = PKG / 'Becoming' / 'Optimum.lean'
assert 'namespace Many' not in target.read_text(), 'already integrated'
shutil.copyfile(HERE / 'tree' / 'Becoming' / 'Optimum.lean', target)
DOC_OLD = '  one-unit limit on the second makes leaving everything the first\'s best response, keeping the dweller.\n'
DOC_NEW = (DOC_OLD +
           '  With any number of drawers in turn from two, every perfect profile has every drawer leave\n'
           '  nothing; two drawers are the case k = 2. Witness: under the gate, any number breaks the dweller.\n')
SCOPE_OLD = '    "the dweller, which every unlimited perfect profile breaks. "\n'
SCOPE_NEW = ('    "the dweller, which every unlimited perfect profile breaks; with k drawers in turn at each step, "\n'
             '    "k at least two, every perfect profile has every drawer leave nothing at every step before the "\n'
             '    "horizon, the base standing at G t 0, and drawing everything is perfect; two drawers are the "\n'
             '    "case k = 2, from which their laws are derived; Holding: under the gate every perfect profile "\n'
             '    "of any number from two breaks the dweller at the first step. "\n')
README_OLD = '(`Optimum.Holding.doubling_capacity`) |'
README_NEW = ('(`Optimum.Holding.doubling_capacity`); with any number of drawers in turn from two every perfect profile '
              'draws everything (`Optimum.InTurn.Many.perfect_ends`, `Web.turns_broken`), two drawers its case '
              '(`Optimum.InTurn.Many.perfect_pair`); witness `Optimum.Holding.gated_turns` |')
README_ZH_OLD = '（`Optimum.Holding.doubling_capacity`） |'
README_ZH_NEW = ('（`Optimum.Holding.doubling_capacity`）；两个及以上任意多个轮流的抽取者，每个完美组合都全部抽取'
                 '（`Optimum.InTurn.Many.perfect_ends`、`Web.turns_broken`），两个抽取者是其情形（`Optimum.InTurn.Many.perfect_pair`）；'
                 '见证 `Optimum.Holding.gated_turns` |')
for name, old, new in (('Becoming.lean', DOC_OLD, DOC_NEW), ('check_becoming.py', SCOPE_OLD, SCOPE_NEW),
                       ('README.md', README_OLD, README_NEW), ('README.zh.md', README_ZH_OLD, README_ZH_NEW)):
    p = PKG / name
    p.write_text(once(p.read_text(), old, new))
print('integrated')
