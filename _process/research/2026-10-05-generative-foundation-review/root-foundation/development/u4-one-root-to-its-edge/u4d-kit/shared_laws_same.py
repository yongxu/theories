#!/usr/bin/env python3
"""U4d: what reaches the grammar does not change (the design's §6, 08 §7 unchanged). Compares the shared laws' view
after the rerun with the one main holds: the central declarations' reach (its four counts and every row) must be
equal; the counts over the records' laws may move, U4d adding laws, and are printed.
usage (from the checkout root, after tools/research/shared_laws.py): python3 -B shared_laws_same.py BEFORE_JSON"""
import json
import sys
from pathlib import Path

before = json.loads(Path(sys.argv[1]).read_text(encoding='utf-8'))
after = json.loads(Path('theories/becoming/results/data/shared-laws.json').read_text(encoding='utf-8'))
moved = {k: (before['counts'].get(k), after['counts'].get(k)) for k in set(before['counts']) | set(after['counts'])
         if before['counts'].get(k) != after['counts'].get(k)}
print('counts over the records\' laws, before → after:', json.dumps(moved, ensure_ascii=False, sort_keys=True))
print('central reach counts:', json.dumps(after['central_reach']['counts'], ensure_ascii=False))
b, a = before['central_reach'], after['central_reach']
assert b['counts'] == a['counts'], ('the central reach counts moved', b['counts'], a['counts'])
changed = sorted(k for k in set(b['rows']) | set(a['rows']) if b['rows'].get(k) != a['rows'].get(k))
assert not changed, ('central rows changed', changed)
for key in ('anchors', 'names', 'model_relations'):
    assert before[key] == after[key], key
print('OK: the central declarations\' reach unchanged,', len(a['rows']), 'rows; anchors, names and model relations unchanged')
