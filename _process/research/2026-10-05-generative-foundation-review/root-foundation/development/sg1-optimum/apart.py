#!/usr/bin/env python3
"""SG1: register the one apart root of Becoming.Optimum, the witness that room binds.

usage: python3 -B apart.py   (once, from the checkout root)"""
import json
from pathlib import Path

REGISTER = Path.cwd() / '_process/research/2026-10-05-generative-foundation-review/root-foundation/THEOREM-CONNECTIVITY-APART.json'
register = json.loads(REGISTER.read_text())
NAME = 'Becoming.Optimum.Drain.room_needed'
assert NAME not in register['roots'], NAME
register['roots'][NAME] = {
    'module': 'Becoming.Optimum', 'category': 'model-witness',
    'reason': 'Two outcomes, the source kept or spilled with the store empty in both: under the store\'s order keeping '
              'is an optimum and is not at the least level beyond; a fact about one constructed set of outcomes showing '
              'that Optimum.least_of_room needs room.'}
REGISTER.write_text(json.dumps(register, ensure_ascii=False, indent=1) + '\n')
print('registered', NAME)
