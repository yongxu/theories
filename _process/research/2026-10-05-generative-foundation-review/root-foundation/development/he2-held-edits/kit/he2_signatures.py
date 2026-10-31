#!/usr/bin/env python3
"""HE2: compare the printed statements (`#check @name`, the checker's signature audit) of every declaration of the
modules HE2 changes between main's receipt (the one HEAD holds) and HE2's (or a rehearsal's) receipt, against what
the items' kits say they change. Each expectation is read from the item's own kit, so a kit revised before the
landing is followed:
  item 1 (ou3f-activity-laws/he2-item1): «两端分则中有标» changes statement (a class's `hK` gives way to `trans`);
  items 2 to 4 (u4-one-root-to-its-edge/he2-items-2-to-4, `he2_u4.NEW`): 38 declarations added to GrammarLaws;
  item 5 (ou3b-master-laws-on-the-grammar/he2-item5, ITEM5_*): Map.step_reached_le, Map.step_reaches and
    Map.step_reaches_of_le moved from MapRegions to GrammarMap, nothing added;
  items 6 and 7 (rv21-one-sense/kit/he2_core_li.py): four laws added to GrammarLaws; seven names gone and seven
    added, each new statement the old one with the names renamed; kept-name statements and definitions whose text
    differs only by the renames.
Every other statement and definition of the changed modules prints as before, and every axiom report is empty.
usage (from the checkout root, after the checker): python3 -B <kit>/he2_signatures.py [RECEIPT_ID | --dir RUN_DIR]"""
import importlib.util
import json
import sys
from pathlib import Path

ROOT = Path.cwd()
DEV = ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation/development'


def load(name, path):
    spec = importlib.util.spec_from_file_location(name, path)
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod


s3b = load('s3b', DEV / 'ou3b-master-laws-on-the-grammar/kit/signatures_ou3b.py')
k67 = load('k67', DEV / 'rv21-one-sense/kit/he2_core_li.py')
k24 = load('k24', DEV / 'u4-one-root-to-its-edge/he2-items-2-to-4/he2_u4.py')
PKG = s3b.PKG

CHANGED = ('Grammar', 'GrammarLaws', 'GrammarRegularity', 'GrammarScope', 'GrammarCandidates', 'GrammarMap',
           'MapRegions', 'WideningOnTheMap', 'HeldPossible', 'PatternPassing', 'Sampling', 'Response', 'SelectionPool')
ITEM1_CHANGED = {'Becoming.«两端分则中有标»'}
# Item 5 (he2_item5.py, branch he2-item5): MapRegions' three reach laws move to GrammarMap whole, names, statements
# and proofs unchanged; nothing is added.
ITEM5_ADDED = set()
ITEM5_MOVED = {f'Becoming.Map.{n}': ('MapRegions', 'GrammarMap') for n in ('step_reached_le', 'step_reaches',
                                                                          'step_reaches_of_le')}
ADDED = ({k24.full(n) for n in k24.NEW} | {k67.full(n) for n in k67.NEW_LAWS} | ITEM5_ADDED
         | {k67.full(n) for n in k67.RENAMES.values()})
GONE = {k67.full(n) for n in k67.RENAMES}


def renamed(text):
    for old, new in k67.RENAMES.items():
        text = text.replace('«' + old + '»', '«' + new + '»')
    return text


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
gone = sorted(n for n in old if n not in new)
added = sorted(n for n in new if n not in old)
moved = {n: (where_old[n], where_new[n]) for n in old if n in new and where_old[n] != where_new[n]}
changed = sorted(n for n in old if n in new and old[n] != new[n])
by_rename = [n for n in changed if renamed(old[n]) == new[n]]
changed_real = sorted(set(changed) - set(by_rename))
rename_ok = {o: renamed(old[o]) == new.get(k67.full(k67.RENAMES[o[len('Becoming.«'):-1]])) for o in GONE if o in old}
rewritten = sorted(n for n in defs_old if n in defs_new and defs_old[n] != defs_new[n])
# Definitions print no statement in the signature logs, which list theorems: their names are read from the sources.
gone_defs = sorted(n for n in defs_old if n not in defs_new)
added_defs = sorted(n for n in defs_new if n not in defs_old)
rename_ok.update({o: renamed(defs_old[o]) == defs_new.get(k67.full(k67.RENAMES[o[len('Becoming.«'):-1]]))
                  for o in GONE if o in defs_old})
rewritten_real = sorted(n for n in rewritten if renamed(defs_old[n]) != defs_new[n])
report = {'old_receipt': old_r['utc'], 'new_receipt': new_r['utc'], 'declarations_old': len(old),
          'declarations_new': len(new), 'gone': gone, 'added': added, 'definitions_gone': gone_defs,
          'definitions_added': added_defs,
          'moved': {n: list(v) for n, v in sorted(moved.items())}, 'changed': changed_real,
          'changed_by_the_renames_only': sorted(by_rename), 'renamed_statements_equal': rename_ok,
          'definitions_rewritten': rewritten_real,
          'definitions_rewritten_by_the_renames_only': sorted(set(rewritten) - set(rewritten_real))}
print(json.dumps(report, indent=1, ensure_ascii=False))
problems = []
if set(gone) | set(gone_defs) != GONE:
    problems.append(('gone', sorted((set(gone) | set(gone_defs)) ^ GONE)))
if set(added) | set(added_defs) != ADDED:
    problems.append(('added', sorted((set(added) | set(added_defs)) ^ ADDED)))
if moved != ITEM5_MOVED:
    problems.append(('moved', moved))
if set(changed_real) != ITEM1_CHANGED:
    problems.append(('changed', sorted(set(changed_real) ^ ITEM1_CHANGED)))
if set(rename_ok) != GONE or not all(rename_ok.values()):
    problems.append(('renamed statements', [o for o, ok in rename_ok.items() if not ok]))
if rewritten_real:
    problems.append(('definitions rewritten', rewritten_real))
for m in new_r['modules']:
    if m['module'] in {'Becoming.' + c for c in CHANGED} and any(m['axiom_dependencies'].values()):
        problems.append(('axioms', m['module']))
print(f'OK: every statement and definition of the {len(CHANGED)} changed modules as the items say' if not problems
      else f'UNEXPECTED: {problems}')
sys.exit(1 if problems else 0)
