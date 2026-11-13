#!/usr/bin/env python3
"""Rows added to the six-family mapping after the pass, for theorems an entry lists under `premises` that the pass
never read. Run from the repository root: add_rows.py LISTER_OUTPUT ASSIGNMENT.

LISTER_OUTPUT holds the `AAROW` lines printed by lister.py's own Lean function (`aaRow`) for the theorems named, run
against the compiled module. ASSIGNMENT is a JSON file: {"family": F, "laws": {law: {"binders": {binder name:
[premise ids]}, "takes_unbound": {premise id: "data" | "definition" | "commitment" | "form"}}}}. A binder name that
occurs twice in one statement takes the same premises both times. Each row is checked against the entry's own list
before anything is written: every premise a binder is given is listed, and every premise listed is given to a binder
or taken unbound. integrate.py does not regenerate these rows; rerun this after it. AI-written, 13 November 2026."""
import json
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
MAPPING = HERE.parent / 'mapping.json'
ROOT = HERE.parents[7]
lister, assignment = Path(sys.argv[1]), json.loads(Path(sys.argv[2]).read_text(encoding='utf-8'))
rows = {r['law']: r for r in (json.loads(l[len('AAROW '):]) for l in lister.read_text(encoding='utf-8').split('\n')
                              if l.startswith('AAROW '))}
dynamics = json.loads((ROOT / 'theories/becoming/results/atlas/entries/dynamics.json').read_text(encoding='utf-8'))
takes = {h['law']: set(h['takes']) for d in dynamics for h in d.get('premises') or []}
ledger = {p['id'] for p in json.loads((ROOT / 'theories/becoming/results/atlas/entries/premises.json')
                                      .read_text(encoding='utf-8'))}
raw = MAPPING.read_text(encoding='utf-8')
mapping = json.loads(raw)
assert json.dumps(mapping, ensure_ascii=False, indent=1) + '\n' == raw, 'mapping.json: formatting not reproduced'
added = 0
for law, given in assignment['laws'].items():
    assert law in rows and not rows[law].get('missing'), (law, 'not in the lister output')
    assert rows[law]['kind'] == 'theorem', (law, rows[law]['kind'])
    assert law in takes, (law, 'no entry lists it')
    assert law not in mapping, (law, 'already in the mapping')
    names = [b['name'] for b in rows[law]['binders']]
    assert set(given['binders']) == set(names), (law, sorted(set(given['binders']) ^ set(names)))
    binders = [{'position': b['position'], 'name': b['name'], 'type': b['type'], 'premises': given['binders'][b['name']]}
               for b in rows[law]['binders']]
    bound = {p for b in binders for p in b['premises']}
    unbound = set(given['takes_unbound'])
    assert bound | unbound <= ledger, (law, sorted((bound | unbound) - ledger))
    assert bound | unbound == takes[law], (law, 'given not listed', sorted((bound | unbound) - takes[law]),
                                           'listed not given', sorted(takes[law] - bound - unbound))
    assert not bound & unbound, (law, sorted(bound & unbound))
    mapping[law] = {'family': assignment['family'], 'source': 'lister', 'binders': binders,
                    'takes_unbound': given['takes_unbound']}
    added += 1
MAPPING.write_text(json.dumps(mapping, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')
print('rows added', added, '; mapping now', len(mapping))
