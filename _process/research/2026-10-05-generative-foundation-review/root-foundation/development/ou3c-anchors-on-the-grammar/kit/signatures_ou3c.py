#!/usr/bin/env python3
"""OU3c: compare the printed statements (`#check @name`, the checker's signature audit) of every declaration of the
five changed modules between main's receipt (the one HEAD holds) and the landing's receipt, by name across the five
modules, so that a declaration moving between them (strictJoin_trans and strictJoin_irrefl, ComparingCourses to
GrammarLaws) is compared with itself. Expected: those two changed only by their universe (`Type` to `Type u`), and
the one new declaration `Becoming.Learning.fixed_image_iff_lumped`; no definition rewritten. OU3b's
signatures_ou3b.py supplies the log reading.
usage (from the checkout root, after the checker): python3 -B <kit>/signatures_ou3c.py [RECEIPT_ID]"""
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
CHANGED = ('GrammarLaws', 'ComparingCourses', 'ReachableRanges', 'LearningRuns', 'Junctures')
MOVED = {'Becoming.strictJoin_trans', 'Becoming.strictJoin_irrefl'}
ADDED = {'Becoming.Learning.fixed_image_iff_lumped'}

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
          'definitions_rewritten': rewritten, 'definitions_gone': sorted(n for n in defs_old if n not in defs_new)}
print(json.dumps(report, indent=1, ensure_ascii=False))
for n in changed:
    print('---', n, '\nold:', old[n][:400], '\nnew:', new[n][:400])
bad = (set(changed) - MOVED) or gone or (set(added) - ADDED) or rewritten or report['definitions_gone']
print('deliberate change (the one): Becoming.strictJoin_trans and Becoming.strictJoin_irrefl, moved from '
      'ComparingCourses to GrammarLaws and generalised from Type to Type u: the statement now covers more, every '
      'earlier use an instance:', [n for n in changed if n in MOVED])
print('statements otherwise unchanged in the five modules; one new declaration:', [n for n in added])
print('OK' if not bad else f'UNEXPECTED: {bad}')
sys.exit(1 if bad else 0)
