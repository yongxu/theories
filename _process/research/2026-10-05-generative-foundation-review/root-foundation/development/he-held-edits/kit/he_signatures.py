#!/usr/bin/env python3
"""HE: compare the printed statements (`#check @name`, the checker's signature audit) of every declaration of the
modules HE changes between main's receipt (the one HEAD holds) and HE's (or a rehearsal's) receipt. Expected:
every declaration prints its old statement, none changed, gone or added, and no definition rewritten; three move
module with their statements unchanged: kept_onward from KeptOnward to GrammarLaws, «保之像» from GrammarTransport to
GrammarLaws, total_eq_of_supports from KeepingWidening to Dissipation. Becoming.KeptOnward is gone from the run.
OU3b's signatures_ou3b.py supplies the log reading.
usage (from the checkout root, after the checker): python3 -B <kit>/he_signatures.py [RECEIPT_ID | --dir RUN_DIR]"""
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
CHANGED = ('GrammarLaws', 'GrammarTransport', 'Mechanism', 'KeepingWidening', 'Dissipation', 'Retaining', 'Wholes',
           'Exclusion', 'Reserve', 'PatternPassing', 'Persistence', 'GrammarPath')
GONE_MODULE = 'KeptOnward'
MOVED = {'Becoming.kept_onward': ('KeptOnward', 'GrammarLaws'),
         'Becoming.«保之像»': ('GrammarTransport', 'GrammarLaws'),
         'Becoming.total_eq_of_supports': ('KeepingWidening', 'Dissipation')}

if len(sys.argv) > 2 and sys.argv[1] == '--dir':
    runs = sorted(p for p in Path(sys.argv[2]).iterdir() if (p / 'verification.json').exists())
    assert runs, sys.argv[2]
    new_r = json.loads((runs[-1] / 'verification.json').read_text())
else:
    new_r = s3b.receipt(sys.argv[1] if len(sys.argv) > 1 else None)
old_r = s3b.receipt_at_head()
assert new_r['status'] == 'passed', new_r['status']
assert f'Becoming.{GONE_MODULE}' not in {m['module'] for m in new_r['modules']}, 'KeptOnward is still in the run'
old, new, defs_old, defs_new, where_old, where_new = {}, {}, {}, {}, {}, {}
for m in CHANGED + (GONE_MODULE,):
    step = f'Becoming{m}Signatures.log'
    o = s3b.parse(s3b.log_of(old_r, step))
    old.update(o)
    where_old.update({k: m for k in o})
    defs_old.update(s3b.definitions(s3b.source_at_head(m)))
    if m != GONE_MODULE:
        n = s3b.parse(s3b.log_of(new_r, step))
        new.update(n)
        where_new.update({k: m for k in n})
        defs_new.update(s3b.definitions((ROOT / PKG / f'Becoming/{m}.lean').read_text(encoding='utf-8')))
changed = sorted(n for n in old if n in new and old[n] != new[n])
gone = sorted(n for n in old if n not in new)
added = sorted(n for n in new if n not in old)
moved = {n: (where_old[n], where_new[n]) for n in old if n in new and where_old[n] != where_new[n]}
rewritten = sorted(n for n in defs_old if n in defs_new and defs_old[n] != defs_new[n])
# The source scanner reads a line starting with `class `, `def ` or `structure ` as a definition, docstrings
# included (GrammarPath's reflowed docstring of «本类出类随行» has a line starting "class constant up to ..."). A
# scanned definition that is no declaration of its receipt is reported as the scanner's, not a change.
real_old = {d['name'] for m in old_r['modules'] if m['module'] in {f'Becoming.{c}' for c in CHANGED + (GONE_MODULE,)}
            for d in m['declarations']}
real_new = {d['name'] for m in new_r['modules'] if m['module'] in {f'Becoming.{c}' for c in CHANGED}
            for d in m['declarations']}
scanned_gone = sorted(n for n in defs_old if n not in defs_new)
scanned_added = sorted(n for n in defs_new if n not in defs_old)
report = {'old_receipt': old_r['utc'], 'new_receipt': new_r['utc'], 'declarations_old': len(old),
          'declarations_new': len(new), 'changed': changed, 'gone': gone, 'added': added,
          'moved': {n: list(v) for n, v in sorted(moved.items())}, 'definitions_rewritten': rewritten,
          'definitions_gone': [n for n in scanned_gone if n in real_old],
          'definitions_added': [n for n in scanned_added if n in real_new],
          'scanner_false_positives': [n for n in scanned_gone + scanned_added if n not in real_old | real_new]}
print(json.dumps(report, indent=1, ensure_ascii=False))
bad = (changed or gone or added or rewritten or report['definitions_gone'] or report['definitions_added']
       or moved != MOVED)
for m in new_r['modules']:
    if m['module'] in ('Becoming.' + c for c in CHANGED):
        assert not any(m['axiom_dependencies'].values()), (m['module'], m['axiom_dependencies'])
print('every statement of the', len(CHANGED), 'changed modules unchanged; moved:', report['moved'],
      '; Becoming.KeptOnward gone from the run; every axiom report of them empty; scanner false positives:',
      report['scanner_false_positives'])
print('OK' if not bad else f'UNEXPECTED: {bad}')
sys.exit(1 if bad else 0)
