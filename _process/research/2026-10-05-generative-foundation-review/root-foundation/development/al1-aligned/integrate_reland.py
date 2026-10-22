#!/usr/bin/env python3
"""Join AL1 to the core package on main after IF1/RP1 (anchors moved): copy Optimum in, extend the root doc, the checker scope and the README rows (EN, ZH).
usage: python3 -B integrate.py   (AL1_ROOT names the checkout to edit; each edit must match exactly once)"""
import os
import shutil
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = Path(os.environ['AL1_ROOT']).resolve() if os.environ.get('AL1_ROOT') else HERE.parents[5]
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'


def once(text, old, new):
    assert text.count(old) == 1, ('edit does not match once', old[:90], text.count(old))
    return text.replace(old, new)


opt = PKG / 'Becoming' / 'Optimum.lean'
shutil.copyfile(HERE / 'tree' / 'Becoming' / 'Optimum.lean', opt)
edits = {
    'Becoming.lean': [('  keeping it to stop what the first drawer would draw next.\n',
                       '  keeping it to stop what the first drawer would draw next. Drawing at once, conversely, drawing\n'
                       '  everything is perfect exactly where no portion returns more than one for one on what its\n'
                       '  drawer alone leaves; where each returns less, in whole amounts a portion never rises with\n'
                       '  what is left and no profile draws any drawer more, so restraint pays none; where the drain\n'
                       '  is perfect and holding the level draws each more at every later step, holding draws each\n'
                       '  more over a long horizon, and for a drawer given the whole drawing everything is not perfect where the whole\n'
                       '  returns more than one for one.\n')],
    'check_becoming.py': [('''    "and every perfect profile has the second drawer keep the unit it is given at the first step. "\n''',
                           '''    "and every perfect profile has the second drawer keep the unit it is given at the first step. "\n'''
                           '''    "AtOnce: drawing everything is perfect exactly where no portion returns more than one for one on "\n'''
                           '''    "what its drawer alone leaves, the others drawing everything; where each returns less, a portion "\n'''
                           '''    "never rises with what is left and no profile draws any drawer more than drawing everything; a "\n'''
                           '''    "profile holding the level and drawing each drawer more at every later step than the drained base "\n'''
                           '''    "gives draws it more over a horizon longer than its first portion; a perfect profile draws "\n'''
                           '''    "everything at the last step; for a drawer given the whole drawing everything is not perfect where the whole returns "\n'''
                           '''    "more than one for one; under halves, drawing everything is perfect for two and breaks the "\n'''
                           '''    "dweller, holding at six keeps it and draws each more, and for the whole drawing everything is not perfect. "\n''')],
    'README.md': [('`Web.at_once_broken`); drawers in turn ranking their position',
                   '`Web.at_once_broken`); conversely drawing '
                   'everything is perfect exactly where no portion returns more than one for one on what its drawer alone leaves '
                   '(`Optimum.AtOnce.drain_perfect_iff`), where each returns less no profile draws any drawer more '
                   '(`Optimum.AtOnce.drain_most`, `Web.at_once_beyond`), holding the level can draw every drawer more where the drain '
                   'is perfect (`Optimum.AtOnce.holding_draws_more`), and for a drawer given the whole drawing everything is not perfect where the whole '
                   'returns more than one for one (`Optimum.AtOnce.whole_not_drained`; witness `Optimum.Holding.halves_race`); drawers in turn ranking their position')],
    'README.zh.md': [('`Web.at_once_broken`）；轮流的抽取者按位次排序',
                      '`Web.at_once_broken`）；反之，恰在无一份对其抽取者独留之量所回多于一对一处，'
                      '全部抽取是完美的（`Optimum.AtOnce.drain_perfect_iff`）；每份所回少于一对一时，没有任何组合使任一抽取者多得'
                      '（`Optimum.AtOnce.drain_most`、`Web.at_once_beyond`）；全部抽取完美时，持守水平可使每个抽取者多得'
                      '（`Optimum.AtOnce.holding_draws_more`）；所得为全体者，在全体所回多于一对一处不全部抽取'
                      '（`Optimum.AtOnce.whole_not_drained`；见证 `Optimum.Holding.halves_race`）；轮流的抽取者按位次排序')],
}
for name, pairs in edits.items():
    p = PKG / name
    t = p.read_text()
    for old, new in pairs:
        t = once(t, old, new)
    p.write_text(t)
print('integrated')
