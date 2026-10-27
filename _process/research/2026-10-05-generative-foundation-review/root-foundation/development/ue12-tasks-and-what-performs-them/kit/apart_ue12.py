#!/usr/bin/env python3
"""UE12: register the module's four apart roots in THEOREM-CONNECTIVITY-APART.json, each a fact about one witness
that names no process (category model-witness), and retire the entry of `Becoming.«定后之逐点»`, which UE12's climbing
witness now uses on the base (`Tasks.ClimbTask.fixed`), so that it is no longer an apart root; the retired entry moves
with its bytes to this kit's apart-retired.json, as R28's retire_apart.py moved its own. Run after the checker and
before the connectivity check; each new entry is asserted new and the retired one present.
usage (from the checkout root of the landing worktree): python3 -B <kit>/apart_ue12.py"""
import json
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
REGISTER = ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation/THEOREM-CONNECTIVITY-APART.json'
RETIRED = HERE / 'apart-retired.json'
NEW = {
    'Becoming.Tasks.Conserved.holdsOne_eq_xor': {
        'module': 'Becoming.Tasks', 'category': 'model-witness',
        'reason': 'whether the two substrates of the conserved-amount witness together hold one unit is their exclusive '
                  'or, case by case, naming no process: a witness of Becoming.Tasks (UE12), whose process keeps that '
                  'reading at every move (Conserved.holdsOne_kept)'},
    'Becoming.Tasks.Conserved.holdsOne_recodes': {
        'module': 'Becoming.Tasks', 'category': 'model-witness',
        'reason': 'with the first substrate, whether the two substrates of the conserved-amount witness together hold '
                  'one unit recodes their configuration one to one, case by case, naming no process: a witness of '
                  'Becoming.Tasks (UE12), whose division performs the four single tasks (Conserved.performs_with_one)'},
    'Becoming.Tasks.Resetting.listed_not_regular': {
        'module': 'Becoming.Tasks', 'category': 'model-witness',
        'reason': "the resetting witness's two tasks, listed with the second part that every delivery of the first sets "
                  'off, are not a regular pair, naming only the tasks: a witness of Becoming.Tasks (UE12), whose '
                  'process is in Resetting.not_holding and Resetting.composition_fails'},
    'Becoming.Tasks.Unregular.not_regular': {
        'module': 'Becoming.Tasks', 'category': 'model-witness',
        'reason': "the unregular witness's two tasks, 0 to 1 or 2 and 2 to 3, are not a regular pair, naming only the "
                  'tasks: a witness of Becoming.Tasks (UE12), whose process is in Unregular.composite_not_possible'}}
GONE = ['Becoming.«定后之逐点»']
raw = REGISTER.read_text(encoding='utf-8')
register = json.loads(raw)
assert json.dumps(register, ensure_ascii=False, indent=1) + '\n' == raw, 'the register is not in its usual format'
for name in NEW:
    assert name not in register['roots'], name
    assert NEW[name]['category'] in register['categories'], NEW[name]['category']
assert not RETIRED.exists(), RETIRED
retired = {
    'about': 'Apart-register entries retired by UE12 (27 October 2026): Tasks.ClimbTask.fixed uses them on the base, '
             'so they are no longer apart roots. Bytes as they stood in THEOREM-CONNECTIVITY-APART.json.',
    'roots': {name: register['roots'].pop(name) for name in GONE}}
register['roots'].update(NEW)
REGISTER.write_text(json.dumps(register, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')
RETIRED.write_text(json.dumps(retired, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')
print('apart register: added', ', '.join(NEW) + '; retired', ', '.join(GONE))
