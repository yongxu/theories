#!/usr/bin/env python3
"""Join UM3 to the core package: copy Optimum in, extend the root doc, the checker scope and the README rows (EN, ZH).
usage: python3 -B integrate.py   (UM3_ROOT names the checkout to edit; each edit must match exactly once)"""
import os
import shutil
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = Path(os.environ['UM3_ROOT']).resolve() if os.environ.get('UM3_ROOT') else HERE.parents[5]
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'


def once(text, old, new):
    assert text.count(old) == 1, ('edit does not match once', old[:90], text.count(old))
    return text.replace(old, new)


opt = PKG / 'Becoming' / 'Optimum.lean'
assert 'namespace AtOnce' not in opt.read_text(), 'already integrated'
shutil.copyfile(HERE / 'tree' / 'Becoming' / 'Optimum.lean', opt)
edits = {
    'Becoming.lean': [('  the dweller; under doubling a one-unit floor on the second keeps it.\n',
                       '  the dweller; under doubling a one-unit floor on the second keeps it. Drawing at once from\n'
                       '  portions is the same law: where each portion returns what its drawer leaves less than one\n'
                       '  for one, every perfect profile and every revision draws everything.\n')],
    'check_becoming.py': [('''    "profile has the first leave everything from three, keeping the dweller. "\n''',
                           '''    "profile has the first leave everything from three, keeping the dweller; AtOnce: drawers drawing "\n'''
                           '''    "at once from portions of the level, what all leave standing next as G t of it, where each "\n'''
                           '''    "portion returns what its drawer leaves less than one for one: revision from any profile draws "\n'''
                           '''    "everything at the last c steps from round c on, drawing everything is perfect, every perfect "\n'''
                           '''    "profile draws everything, and a dependence above G 0 0 met at the start is broken at the first "\n'''
                           '''    "step. "\n''')],
    'README.md': [('witnesses `Optimum.Holding.gated_in_turn`, `Optimum.Holding.doubling_capacity` |',
                   'witnesses `Optimum.Holding.gated_in_turn`, `Optimum.Holding.doubling_capacity`; drawing at once from '
                   'portions is the same law, where each portion returns less than one for one every perfect profile and every '
                   'revision drawing everything (`Optimum.AtOnce.drains`, `Optimum.AtOnce.revisions_drain`, `Web.at_once_broken`) |')],
    'README.zh.md': [('见证 `Optimum.Holding.gated_in_turn`、`Optimum.Holding.doubling_capacity` |',
                      '见证 `Optimum.Holding.gated_in_turn`、`Optimum.Holding.doubling_capacity`；自份额同时抽取是同一条律，每份所回少于一对一时，'
                      '每个完美组合与每次修订都全部抽取（`Optimum.AtOnce.drains`、`Optimum.AtOnce.revisions_drain`、`Web.at_once_broken`） |')],
}
for name, pairs in edits.items():
    p = PKG / name
    t = p.read_text()
    for old, new in pairs:
        t = once(t, old, new)
    p.write_text(t)
print('integrated')
