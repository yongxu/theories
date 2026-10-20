#!/usr/bin/env python3
"""EV9: register the apart roots of Becoming.Drift's sampled generations, and retire the register entry of
Typicality.total_congr_mem, which sampled_one and sampled_count now use (it is no longer a root).

The laws over many sampled generations hold of any two-kind population sampled from itself, with no world: registered
as general structure, the witness as a model witness.

usage: python3 -B apart.py   (once, from the checkout root)"""
import json
from pathlib import Path

HERE = Path(__file__).resolve().parent
REGISTER = HERE.parents[1] / 'THEOREM-CONNECTIVITY-APART.json'
register = json.loads(REGISTER.read_text())
D = 'Becoming.Drift'
LAW = ('a law of any two-kind population of N sampled generation after generation from itself, counted by '
       'Typicality\'s courses, with no world')
NEW = {
    D + '.fixation': (D, 'general-structure',
        'N times the histories fixing the first kind lies within N r^k below h (N^N)^k and at most it, so the fixing '
        'share tends to the starting share h/N: ' + LAW),
    D + '.sampled_one': (D, 'general-structure',
        'the histories of k sampled generations weigh (N^N)^k together: ' + LAW),
    D + '.TwoMembers.one_generation': (D, 'model-witness',
        'two members, one of each kind, one generation: one history fixes, one loses, two stay varied; a fact about '
        'one constructed population, not a law of the unfolding'),
}
for name, (module, category, reason) in NEW.items():
    assert name not in register['roots'], name
    register['roots'][name] = {'module': module, 'category': category, 'reason': reason}
assert 'Becoming.Typicality.total_congr_mem' in register['roots']
del register['roots']['Becoming.Typicality.total_congr_mem']
REGISTER.write_text(json.dumps(register, ensure_ascii=False, indent=1) + '\n')
print('registered', len(NEW), 'retired 1')
