#!/usr/bin/env python3
"""EV8: register the apart roots of Becoming.Drift.

The bound on falling back reaches the base through Flow.ended_falls_back (ending among groups raises the mean on a
flow); unbiasedness for the second kind and over listed generations, and the witness, are the roots no base law goes
through: registered as general structure and as a model witness.

usage: python3 -B apart.py   (once, from the checkout root)"""
import json
from pathlib import Path

HERE = Path(__file__).resolve().parent
REGISTER = HERE.parents[1] / 'THEOREM-CONNECTIVITY-APART.json'
register = json.loads(REGISTER.read_text())
D = 'Becoming.Drift'
LAW = ('a law of any two-kind sampling counted by Typicality\'s courses, with no world; on the base the bound on '
       'falling back is reached through Flow.ended_falls_back')
NEW = {
    D + '.expected_zeros': (D, 'general-structure',
        'p + q times the weighted count of draws of the second kind is n q times the whole weight, unbiasedness for '
        'the second kind: ' + LAW),
    D + '.Generations.expected_sampled': (D, 'general-structure',
        'sampled from a listed generation of holders and others, the holders\' count averages the listed share, '
        'unbiasedness over listed generations: ' + LAW),
    D + '.OneDraw.falls_back': (D, 'model-witness',
        'one draw from three and two after a step raising the share from a half: the draw of the second kind falls '
        'back, weighing two of five; a fact about one constructed sampling, not a law of the unfolding'),
}
for name, (module, category, reason) in NEW.items():
    assert name not in register['roots'], name
    register['roots'][name] = {'module': module, 'category': category, 'reason': reason}
REGISTER.write_text(json.dumps(register, ensure_ascii=False, indent=1) + '\n')
print('registered', len(NEW))
