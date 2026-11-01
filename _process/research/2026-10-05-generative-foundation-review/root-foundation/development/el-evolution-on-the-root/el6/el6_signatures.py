#!/usr/bin/env python3
"""EL6: compare the printed statements (`#check @name`, the checker's signature audit) of every declaration of the
modules EL6 changes, and of the retired Becoming.LineDegeneration, between main's receipt (the one main holds) and
EL6's (or a rehearsal's) receipt (he_signatures.py's pattern, its log reading from OU3b's signatures_ou3b.py).
Expected, and nothing else:
- every declaration of LineDegeneration but Web.Restated's moves with its statement unchanged: the grammar part to
  GrammarMap, the kind instance to KeepingWidening, the rest to MapInstances;
- five renames, the statement unchanged: Map.not_not_end_of_ends → «尽则非无终», Map.end_of_ends_decided →
  «尽而续可定则有终», Map.end_of_ends_iff_excluded_middle → «尽则有终当且仅当排中» (each also moving to GrammarMap),
  Web.degenerates_of_gone → Web.end_of_gone, Map.Short.degeneration → Map.Short.reaches_end;
- the five Web.Restated declarations gone;
- one definition rewritten, Map.StepWhere.relation, now Map.short gated by P, its type unchanged;
- Becoming.LineDegeneration gone from the run, and every axiom report of the changed modules empty.
usage (from the checkout root, after the checker): python3 -B <kit>/el6_signatures.py [RECEIPT_ID | --dir RUN_DIR]"""
import importlib.util
import json
import subprocess
import sys
from pathlib import Path

ROOT = Path.cwd()
OU3B = ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ou3b-master-laws-on-the-grammar/kit/signatures_ou3b.py'
spec = importlib.util.spec_from_file_location('s3b', OU3B)
s3b = importlib.util.module_from_spec(spec)
spec.loader.exec_module(s3b)
PKG = s3b.PKG
CHANGED = ('GrammarMap', 'GrammarConditionals', 'MapInstances', 'KeepingWidening', 'LineageRegions')
GONE_MODULE = 'LineDegeneration'
RENAMED = {'Becoming.Map.not_not_end_of_ends': 'Becoming.«尽则非无终»',
           'Becoming.Map.end_of_ends_decided': 'Becoming.«尽而续可定则有终»',
           'Becoming.Map.end_of_ends_iff_excluded_middle': 'Becoming.«尽则有终当且仅当排中»',
           'Becoming.Web.degenerates_of_gone': 'Becoming.Web.end_of_gone',
           'Becoming.Map.Short.degeneration': 'Becoming.Map.Short.reaches_end'}
GRAMMAR = {'Becoming.Map.StepWhere.relation', 'Becoming.Map.StepWhere.ends', 'Becoming.Map.StepWhere.has_next_iff',
           'Becoming.Map.StepWhere.end_decides'}
KIND = {'Becoming.Web.kind_every_branch_ends_of_gone', 'Becoming.Map.Undecided.kind_degenerates'}
REWRITTEN = ['Becoming.Map.StepWhere.relation']


def main_json(path):
    return json.loads(subprocess.run(['git', 'show', f'main:{path}'], cwd=ROOT, capture_output=True, text=True,
                                     check=True).stdout)


def main_source(m):
    return subprocess.run(['git', 'show', f'main:{PKG}/Becoming/{m}.lean'], cwd=ROOT, capture_output=True, text=True,
                          check=True).stdout


if len(sys.argv) > 2 and sys.argv[1] == '--dir':
    runs = sorted(p for p in Path(sys.argv[2]).iterdir() if (p / 'verification.json').exists())
    assert runs, sys.argv[2]
    new_r = json.loads((runs[-1] / 'verification.json').read_text())
else:
    new_r = s3b.receipt(sys.argv[1] if len(sys.argv) > 1 else None)
old_r = main_json(f'{PKG}/becoming-verification.json')
assert new_r['status'] == 'passed', new_r['status']
assert f'Becoming.{GONE_MODULE}' not in {m['module'] for m in new_r['modules']}, 'LineDegeneration is still in the run'


def body(sig):
    """the printed statement without its name"""
    return sig.split(' : ', 1)[1] if ' : ' in sig else sig


old, new, defs_old, defs_new, where_old, where_new = {}, {}, {}, {}, {}, {}
for m in CHANGED + (GONE_MODULE,):
    step = f'Becoming{m}Signatures.log'
    o = s3b.parse(s3b.log_of(old_r, step))
    old.update(o)
    where_old.update({k: m for k in o})
    defs_old.update(s3b.definitions(main_source(m), m))
    if m != GONE_MODULE:
        n = s3b.parse(s3b.log_of(new_r, step))
        new.update(n)
        where_new.update({k: m for k in n})
        defs_new.update(s3b.definitions((ROOT / PKG / f'Becoming/{m}.lean').read_text(encoding='utf-8'), m))
renamed_bad = {a: b for a, b in RENAMED.items()
               if a not in old or b not in new or a in new or b in old or body(old[a]) != body(new[b])}
changed = sorted(n for n in old if n in new and old[n] != new[n])
gone = sorted(n for n in old if n not in new and n not in RENAMED)
added = sorted(n for n in new if n not in old and n not in RENAMED.values())
expected_gone = sorted(n for n in old if where_old[n] == GONE_MODULE and n.startswith('Becoming.Web.Restated.'))


def home(n):
    if n in GRAMMAR or n in {RENAMED[k] for k in RENAMED if 'Map.Short' not in k and 'Web.' not in k}:
        return 'GrammarMap'
    return 'KeepingWidening' if n in KIND else 'MapInstances'


moved = {n: (where_old[n], where_new[n]) for n in old if n in new and where_old[n] != where_new[n]}
expected_moved = {n: (GONE_MODULE, home(n)) for n in old
                  if where_old[n] == GONE_MODULE and n in new}
renamed_moves = {b: (where_old[a], where_new.get(b)) for a, b in RENAMED.items() if a in old and b in new}
expected_renamed_moves = {b: (where_old[a], home(b) if where_old[a] == GONE_MODULE else where_old[a])
                          for a, b in RENAMED.items() if a in old and b in new}
rewritten = sorted(n for n in defs_old if n in defs_new and defs_old[n] != defs_new[n])
report = {'old_receipt': old_r['utc'], 'new_receipt': new_r['utc'], 'declarations_old': len(old),
          'declarations_new': len(new), 'changed': changed, 'gone': gone, 'expected_gone': expected_gone,
          'added': added, 'renamed_bad': renamed_bad,
          'moved': {n: list(v) for n, v in sorted(moved.items())},
          'renamed_moves': {n: list(v) for n, v in sorted(renamed_moves.items())},
          'definitions_rewritten': rewritten}
print(json.dumps(report, indent=1, ensure_ascii=False))
problems = []
if changed:
    problems.append(('statements changed', changed))
if gone != expected_gone:
    problems.append(('gone', gone, 'expected', expected_gone))
if added:
    problems.append(('added', added))
if renamed_bad:
    problems.append(('renames', renamed_bad))
if moved != expected_moved:
    problems.append(('moves', {n: v for n, v in moved.items() if expected_moved.get(n) != v},
                     {n: v for n, v in expected_moved.items() if moved.get(n) != v}))
if renamed_moves != expected_renamed_moves:
    problems.append(('renamed moves', renamed_moves, expected_renamed_moves))
if rewritten != REWRITTEN:
    problems.append(('definitions rewritten', rewritten))
for m in new_r['modules']:
    if m['module'] in ('Becoming.' + c for c in CHANGED):
        assert not any(m['axiom_dependencies'].values()), (m['module'], m['axiom_dependencies'])
print('OK: every statement unchanged; moved', len(moved), '; renamed', len(RENAMED), '; gone', len(gone),
      '(Web.Restated); rewritten', rewritten, '; LineDegeneration gone from the run; every axiom report of the',
      len(CHANGED), 'changed modules empty' if not problems else f'UNEXPECTED: {problems}')
sys.exit(1 if problems else 0)
