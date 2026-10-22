#!/usr/bin/env python3
"""EV12: register the apart roots of selection with returns to groupmates in Becoming.SelectionLevels.

The returns laws hold over any finite family read with weights and amounts, with no world: registered as general
structure, the witness facts as model witnesses.

usage: python3 -B apart.py   (once, from the checkout root)"""
import json
from pathlib import Path

HERE = Path(__file__).resolve().parent
REGISTER = HERE.parents[1] / 'THEOREM-CONNECTIVITY-APART.json'
register = json.loads(REGISTER.read_text())
SL = 'Becoming.SelectionLevels'
LAW = 'a law of any finite family read with weights and amounts, with no world'
GROUPS = ('a law of any family listed as groups of equal size whose members\' offspring numbers return to groupmates '
          'additively, with no world')
WIT = 'a fact about one constructed family, not a law of the unfolding'
NEW = {
    SL + '.rises_iff_reading': (SL, 'general-structure',
        'where a weight with k per unit of the amount is a base with b per unit of a reading, the whole selects for the '
        'amount exactly where b times the reading\'s covariation with it exceeds k times its spread: ' + LAW),
    SL + '.within_against': (SL, 'general-structure',
        'selection within groups goes against keeping wherever a group varies in it: ' + GROUPS),
    SL + '.among_for_iff': (SL, 'general-structure',
        'selection among groups goes for keeping exactly where b + c falls short of m b times the spread among them: '
        + GROUPS),
    SL + '.rises_iff_returns_of_uniform': (SL, 'general-structure',
        'groups uniform in the amount select for it, where they differ, exactly where b (m - 1) exceeds c: ' + GROUPS),
    SL + '.not_rises_of_alike': (SL, 'general-structure',
        'groups alike in their totals of the amount never select for it: ' + GROUPS),
    SL + '.rises_exact_iff_returns': (SL, 'general-structure',
        'over listed generations with exact transmission, the mean rises across a step exactly where the rule of '
        'returns to groupmates holds: ' + GROUPS),
    SL + '.Founding.mixed_equal': (SL, 'model-witness', 'the mixed founding lists two groups of two: ' + WIT),
    SL + '.Founding.mixed_returns': (SL, 'model-witness',
        'the mixed founding\'s offspring numbers meet the returns premise: ' + WIT),
    SL + '.Founding.either_verdict': (SL, 'model-witness',
        'the same returns select for keeping with the keepers together and against it with them apart: ' + WIT),
    SL + '.Partly.below_one': (SL, 'model-witness',
        'assortment below one loses where assortment one would win: ' + WIT),
}
for name, (module, category, reason) in NEW.items():
    assert name not in register['roots'], name
    register['roots'][name] = {'module': module, 'category': category, 'reason': reason}
REGISTER.write_text(json.dumps(register, ensure_ascii=False, indent=1) + '\n')
print('registered', len(NEW))
