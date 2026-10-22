#!/usr/bin/env python3
"""EV13-EV16: register the apart roots among the declarations this landing adds to Becoming.Drift,
Becoming.Reproduction and Becoming.Transmission, read from the connectivity check's unclassified roots.

The replacement chain, the mutation counts and the breeding value hold of any counts with no world: general structure;
a law of the forming section stated on the web without a world likewise; witness facts are model witnesses.

usage: python3 -B apart.py CONNECTIVITY_LOG RECEIPT PREVIOUS_RECEIPT   (once, from the checkout root)"""
import json
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
REGISTER = HERE.parents[1] / 'THEOREM-CONNECTIVITY-APART.json'
register = json.loads(REGISTER.read_text())
t = Path(sys.argv[1]).read_text()
conn = json.loads(t[t.index('{'):t.rindex('}') + 1])
R, P = (json.loads(Path(a).read_text()) for a in sys.argv[2:4])
MODS = ('Becoming.Drift', 'Becoming.Reproduction', 'Becoming.Transmission')
new = {}
for mod in MODS:
    old = {d['name'] for m in P['modules'] if m['module'] == mod for d in m['declarations']}
    for m in R['modules']:
        if m['module'] == mod:
            for d in m['declarations']:
                if d['name'] not in old:
                    new[d['name']] = mod
WITNESS = ('Becoming.Drift.Favoured.', 'Becoming.Reproduction.Threshold.', 'Becoming.Reproduction.Additive.',
           'Becoming.Reproduction.Interaction.', 'Becoming.World.', 'Becoming.TwoGivers.')
LAW = {'Becoming.Drift': 'a law of replacement one at a time between two kinds with constant weights, read in counts '
                         'of weighted histories, with no world',
       'Becoming.Reproduction': 'a law of finite families read with offspring numbers and carried amounts (mutation '
                                'counts or the breeding value), with no world',
       'Becoming.Transmission': 'a law of one descent on a web, with no world'}
n = 0
for name in conn['apart_roots_unclassified']:
    if name not in new:
        continue
    assert name not in register['roots'], name
    if name.startswith(WITNESS):
        cat, reason = 'model-witness', 'a fact about one constructed population or world, not a law of the unfolding'
    else:
        cat, reason = 'general-structure', LAW[new[name]]
    register['roots'][name] = {'module': new[name], 'category': cat,
                               'reason': name.rsplit('.', 1)[1].replace('_', ' ') + ': ' + reason}
    n += 1
REGISTER.write_text(json.dumps(register, ensure_ascii=False, indent=1) + '\n')
print('registered', n)
