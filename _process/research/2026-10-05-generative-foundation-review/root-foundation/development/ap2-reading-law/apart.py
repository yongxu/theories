#!/usr/bin/env python3
"""AP2: register the apart root of lexical priority in Becoming.Weightings.

The law holds over any finite listing and any marking of basic items, with no world: registered as general structure.

usage: python3 -B apart.py   (once, from the checkout root)"""
import json
from pathlib import Path

HERE = Path(__file__).resolve().parent
REGISTER = HERE.parents[1] / 'THEOREM-CONNECTIVITY-APART.json'
register = json.loads(REGISTER.read_text())
NEW = {
    'Becoming.Weighting.increasing_lexical': ('Becoming.Weightings', 'general-structure',
        'lexical priority, the basic items first, ranks every widening higher: a law of any finite listing of items and '
        'any marking of basic items, with no world; with Weighting.widens_iff_every_of_class it places lexical priority '
        'within the classes whose shared order is widening'),
}
for name, (module, category, reason) in NEW.items():
    assert name not in register['roots'], name
    register['roots'][name] = {'module': module, 'category': category, 'reason': reason}
REGISTER.write_text(json.dumps(register, ensure_ascii=False, indent=1) + '\n')
print('registered', len(NEW))
