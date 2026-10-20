#!/usr/bin/env python3
"""AP1: register the apart roots of the orders increasing in admission in Becoming.Weightings.

The new laws hold over any finite listing, with no world: registered as general structure. They use
Weighting.mixed_either_way and Weighting.prior_lt_of_widens, which were registered apart roots and are now
within the new roots' groups, so their entries move to the theorems that use them.

usage: python3 -B apart.py   (once, from the checkout root)"""
import json
from pathlib import Path

HERE = Path(__file__).resolve().parent
REGISTER = HERE.parents[1] / 'THEOREM-CONNECTIVITY-APART.json'
register = json.loads(REGISTER.read_text())
W = 'Becoming.Weightings'
LAW = ('a law of any finite listing of items, any class of orders on courses and any weights, with no world; '
       'Web.widens_iff_every_of_class carries it to webs')
OLD = ['Becoming.Weighting.mixed_either_way', 'Becoming.Weighting.prior_lt_of_widens']
NEW = {
    'Becoming.Weighting.widens_iff_every_increasing': (W, 'general-structure',
        'one course widens another exactly when every order increasing in admission ranks it higher: ' + LAW),
    'Becoming.Weighting.widens_iff_every_score': (W, 'general-structure',
        'one course widens another exactly when every complete order (a score) increasing in admission ranks it '
        'higher: ' + LAW),
    'Becoming.Weighting.mixed_either_way_of_class': (W, 'general-structure',
        'within any class of orders holding the positive weightings, a mixed comparison is decided both ways '
        '(from Weighting.mixed_either_way): ' + LAW),
    'Becoming.Weighting.increasing_prior': (W, 'general-structure',
        'a strictly increasing transform of levels is an order increasing in admission (from '
        'Weighting.prior_lt_of_widens), so priority to the worse off lies within the classes the shared order is '
        'taken over: ' + LAW),
}
for name in OLD:
    assert name in register['roots'], name
    del register['roots'][name]
for name, (module, category, reason) in NEW.items():
    assert name not in register['roots'], name
    register['roots'][name] = {'module': module, 'category': category, 'reason': reason}
REGISTER.write_text(json.dumps(register, ensure_ascii=False, indent=1) + '\n')
print('registered', len(NEW), 'retired', len(OLD))
