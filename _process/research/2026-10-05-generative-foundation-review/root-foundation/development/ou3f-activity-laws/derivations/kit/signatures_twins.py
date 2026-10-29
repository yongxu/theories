#!/usr/bin/env python3
"""OU3f twins: compare the printed statements (`#check @name`, the checker's signature audit) of every declaration of
ContinuedClasses and PatternPassing between main's receipt (the one HEAD holds) and the landing's receipt. Expected: every old declaration
prints its old statement, no definition rewritten or gone, nothing added, and exactly the three twins gone.
OU3b's signatures_ou3b.py supplies the log reading.
usage (from the checkout root, after the checker): python3 -B <kit>/signatures_laws.py [RECEIPT_ID]"""
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
CHANGED = ('ContinuedClasses', 'PatternPassing')
# The signature driver checks theorems; definitions are compared by their source text.
ADDED = set()
GONE = {'Becoming.Web.Continuing.mono_by_reach', 'Becoming.Web.ByPassing.passes_within_by_line',
        'Becoming.Web.ByPassing.begins_passed_by_grammar'}
ADDED_DEFS = set()

old_r, new_r = s3b.receipt_at_head(), s3b.receipt(sys.argv[1] if len(sys.argv) > 1 else None)
old, new, defs_old, defs_new = {}, {}, {}, {}
for m in CHANGED:
    step = f'Becoming{m}Signatures.log'
    old.update(s3b.parse(s3b.log_of(old_r, step)))
    new.update(s3b.parse(s3b.log_of(new_r, step)))
    defs_old.update(s3b.definitions(s3b.source_at_head(m)))
    defs_new.update(s3b.definitions((ROOT / PKG / f'Becoming/{m}.lean').read_text(encoding='utf-8')))
changed = sorted(n for n in old if n in new and old[n] != new[n])
gone = sorted(n for n in old if n not in new)
added = sorted(n for n in new if n not in old)
rewritten = sorted(n for n in defs_old if n in defs_new and defs_old[n] != defs_new[n])
report = {'old_receipt': old_r['utc'], 'new_receipt': new_r['utc'], 'declarations_old': len(old),
          'declarations_new': len(new), 'changed': changed, 'gone': gone, 'added': added,
          'definitions_rewritten': rewritten, 'definitions_gone': sorted(n for n in defs_old if n not in defs_new),
          'definitions_added': sorted(n for n in defs_new if n not in defs_old)}
print(json.dumps(report, indent=1, ensure_ascii=False))
for n in added:
    print('+++', new[n][:300])
bad = (changed or (set(gone) ^ GONE) or (set(added) ^ ADDED) or rewritten or report['definitions_gone']
       or {n.rsplit('.', 1)[-1] for n in report['definitions_added']} ^ ADDED_DEFS)
print('every remaining statement of ContinuedClasses and PatternPassing unchanged; gone:', gone, '; new:', added,
      '; new definitions:', report['definitions_added'])
print('OK' if not bad else f'UNEXPECTED: {bad}')
sys.exit(1 if bad else 0)
