#!/usr/bin/env python3
"""EV10: register the apart roots of the additive part in Becoming.Reproduction.

The bounds hold of any finite family read with weights and amounts, and over any listed generations with exact
transmission, with no world: registered as general structure, the witness as a model witness.

usage: python3 -B apart.py   (once, from the checkout root)"""
import json
from pathlib import Path

HERE = Path(__file__).resolve().parent
REGISTER = HERE.parents[1] / 'THEOREM-CONNECTIVITY-APART.json'
register = json.loads(REGISTER.read_text())
R = 'Becoming.Reproduction'
LAW = 'a law of any finite family read with natural-number weights and amounts, with no world'
NEW = {
    R + '.covariance_sq_le': (R, 'general-structure',
        'the covariance either way, squared, is at most the squared differences of the weights times those of the '
        'amount: ' + LAW),
    R + '.additive_self': (R, 'general-structure',
        'read on the weights themselves the bound is attained, Fisher\'s exact case: ' + LAW),
    R + '.Generations.response_sq_le': (R, 'general-structure',
        'over listed generations with exact transmission the cross-multiplied rise or fall of the mean, squared, is at '
        'most the product of the spreads: ' + LAW + ' beyond the listed generations'),
    R + '.Unrelated.unrelated': (R, 'model-witness',
        'three members with offspring numbers one to three, the middle one alone carrying an amount: no covariance while '
        'both vary; a fact about one constructed family, not a law of the unfolding'),
}
for name, (module, category, reason) in NEW.items():
    assert name not in register['roots'], name
    register['roots'][name] = {'module': module, 'category': category, 'reason': reason}
REGISTER.write_text(json.dumps(register, ensure_ascii=False, indent=1) + '\n')
print('registered', len(NEW))
