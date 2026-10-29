#!/usr/bin/env python3
"""OU3f, lineage laws: compare the printed statements (`#check @name`, the checker's signature audit) of every declaration
of Identity and MapInstances between main's receipt (the one HEAD holds) and the landing's (or a rehearsal's) receipt.
Expected: every old declaration prints its old statement and no definition is rewritten or gone; Web.steps_advance moves
from MapInstances to Identity printing the same statement; Identity adds the theorems Web.steps_iff_lineage and
Web.steps_start_active and the definition Web.activityFrom; nothing else is added or gone.
OU3b's signatures_ou3b.py supplies the log reading.
usage (from the checkout root, after the checker): python3 -B <kit>/signatures_lineage.py [RECEIPT_ID | --dir RUN_DIR]
(--dir reads a rehearsal's receipt, RUN_DIR/<id>/verification.json, from outside the repository.)"""
import importlib.util
import json
import sys
from pathlib import Path

ROOT = Path.cwd()
OU3B = ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ou3b-master-laws-on-the-grammar/kit/signatures_ou3b.py'
spec = importlib.util.spec_from_file_location('s3b', OU3B)
s3b = importlib.util.module_from_spec(spec)
spec.loader.exec_module(s3b)
PKG = s3b.PKG
CHANGED = ('Identity', 'MapInstances')
MOVED = {'Becoming.Web.steps_advance': ('MapInstances', 'Identity')}
ADDED = {'Becoming.Web.steps_iff_lineage', 'Becoming.Web.steps_start_active'}
ADDED_DEFS = {'Becoming.Web.activityFrom'}

if len(sys.argv) > 2 and sys.argv[1] == '--dir':
    runs = sorted(p for p in Path(sys.argv[2]).iterdir() if (p / 'verification.json').exists())
    assert runs, sys.argv[2]
    new_r = json.loads((runs[-1] / 'verification.json').read_text())
else:
    new_r = s3b.receipt(sys.argv[1] if len(sys.argv) > 1 else None)
old_r = s3b.receipt_at_head()
assert new_r['status'] == 'passed', new_r['status']
old, new, defs_old, defs_new, where_old, where_new = {}, {}, {}, {}, {}, {}
for m in CHANGED:
    step = f'Becoming{m}Signatures.log'
    o, n = s3b.parse(s3b.log_of(old_r, step)), s3b.parse(s3b.log_of(new_r, step))
    old.update(o)
    new.update(n)
    where_old.update({k: m for k in o})
    where_new.update({k: m for k in n})
    defs_old.update(s3b.definitions(s3b.source_at_head(m)))
    defs_new.update(s3b.definitions((ROOT / PKG / f'Becoming/{m}.lean').read_text(encoding='utf-8')))
changed = sorted(n for n in old if n in new and old[n] != new[n])
gone = sorted(n for n in old if n not in new)
added = sorted(n for n in new if n not in old)
moved = sorted(n for n in old if n in new and where_old[n] != where_new[n])
rewritten = sorted(n for n in defs_old if n in defs_new and defs_old[n] != defs_new[n])
report = {'old_receipt': old_r['utc'], 'new_receipt': new_r['utc'], 'declarations_old': len(old),
          'declarations_new': len(new), 'changed': changed, 'gone': gone, 'added': added,
          'moved': {n: [where_old[n], where_new[n]] for n in moved},
          'definitions_rewritten': rewritten, 'definitions_gone': sorted(n for n in defs_old if n not in defs_new),
          'definitions_added': sorted(n for n in defs_new if n not in defs_old)}
print(json.dumps(report, indent=1, ensure_ascii=False))
for n in added:
    print('+++', new[n][:300])
bad = (changed or gone or set(added) ^ ADDED or rewritten or report['definitions_gone']
       or set(report['definitions_added']) ^ ADDED_DEFS
       or {n: tuple(v) for n, v in report['moved'].items()} != MOVED)
for m in new_r['modules']:
    if m['module'] in ('Becoming.' + c for c in CHANGED):
        assert not any(m['axiom_dependencies'].values()), (m['module'], m['axiom_dependencies'])
        print(m['module'], m['theorems'], 'theorems in', len(m['declarations']), 'declarations, axiom report empty')
print('every statement of Identity and MapInstances unchanged; moved:', report['moved'], '; new:', added,
      '; new definitions:', report['definitions_added'])
print('OK' if not bad else f'UNEXPECTED: {bad}')
sys.exit(1 if bad else 0)
