#!/usr/bin/env python3
"""Join SG16's laws to the core package: copy the extended Becoming.Optimum in, extend its root doc entry, its scope
text in check_becoming.py and its README rows (EN, ZH).
usage: python3 -B integrate.py   (SG16_ROOT names the checkout to edit; each edit must match exactly once)"""
import os
import shutil
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = Path(os.environ['SG16_ROOT']).resolve() if os.environ.get('SG16_ROOT') else HERE.parents[5]
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'


def once(text, old, new):
    assert text.count(old) == 1, ('edit does not match once', old[:90], text.count(old))
    return text.replace(old, new)


target = PKG / 'Becoming' / 'Optimum.lean'
assert 'def Revises' not in target.read_text(), 'already integrated'
shutil.copyfile(HERE / 'tree' / 'Becoming' / 'Optimum.lean', target)
DOC_OLD = '  alone an optimum may keep the dweller; in turn every perfect profile breaks it at once.\n'
DOC_NEW = (DOC_OLD +
           '  Revising toward best responses, from any profile, both come to leave nothing at every step\n'
           '  within twice the horizon. Witness: from restraint under the gate, revision breaks the dweller.\n')
SCOPE_OLD = '    "through the horizon, and in turn every perfect profile breaks it at the first step. "\n'
SCOPE_NEW = ('    "through the horizon, and in turn every perfect profile breaks it at the first step; a profile "\n'
             '    "revises another where each new rule, at every step from every level, is a best response to the "\n'
             '    "old profile, and the first amount drawing the most always gives one; along every sequence of "\n'
             '    "revisions over a horizon of N steps, from any profile, both leave nothing at every step of the "\n'
             '    "last k from round 2 k on, so from round 2 N on the base stands from the first step at G t 0 and "\n'
             '    "a dependence above G 0 0 met at the start is broken at the first step; Holding: under the gate "\n'
             '    "two drawers both leaving everything keep the dweller, and revised from round 2 (n + 2) on they "\n'
             '    "break it. "\n')
README_OLD = 'witness `Optimum.Holding.gated_in_turn` |'
README_NEW = ('witness `Optimum.Holding.gated_in_turn`; revising toward best responses (`Optimum.InTurn.Revises`, '
              'always possible, `Optimum.InTurn.revise_revises`), from any profile both leave nothing at every step from '
              'round `2 N` on (`Optimum.InTurn.revisions_end`, `Optimum.InTurn.revised_draw_all`), breaking at the first '
              'step a dependence above what stands at nothing (`Web.revised_broken`); witness '
              '`Optimum.Holding.gated_revised` |')
README_ZH_OLD = '见证 `Optimum.Holding.gated_in_turn` |'
README_ZH_NEW = ('见证 `Optimum.Holding.gated_in_turn`；向最优回应修订（`Optimum.InTurn.Revises`，总可做到，'
                 '`Optimum.InTurn.revise_revises`），自任一组合出发，自第 `2 N` 轮起两者每步不留（`Optimum.InTurn.revisions_end`、'
                 '`Optimum.InTurn.revised_draw_all`），在第一步打破高于零处所立者的依存（`Web.revised_broken`）；见证 '
                 '`Optimum.Holding.gated_revised` |')
for name, old, new in (('Becoming.lean', DOC_OLD, DOC_NEW), ('check_becoming.py', SCOPE_OLD, SCOPE_NEW),
                       ('README.md', README_OLD, README_NEW), ('README.zh.md', README_ZH_OLD, README_ZH_NEW)):
    p = PKG / name
    p.write_text(once(p.read_text(), old, new))
print('integrated')
