#!/usr/bin/env python3
"""U4d: compare the printed statements (`#check @name`, the checker's signature audit) of every declaration of the
six modules U4d changes between main's receipt (the one main holds) and U4d's (or a rehearsal's) receipt, main's side
read at U4D_BASE, the main merged in (default main), so that main moving during a long run changes nothing
(el6_signatures.py's pattern, its log reading from OU3b's signatures_ou3b.py). Expected, and nothing else:
- the statements of the census of a run's two laws changed, each with two hypotheses fewer (the units after each step
  listed once, and the test of endings): GrammarLaws.census_run and «定后前者在前则亡屡者生屡»;
- the four census recurrence laws of Identity, their decisions now binders where the section's variables supplied
  them, allowed to print otherwise (they print the same at the rehearsal; checked equal to the old statements in Lean,
  u4d-package-build/Becoming/U4dStatements.lean);
- gone, each with no consumer left: Locality's accumulates_or, ceases_once and ceasing_steps_unrefuted, Identity's
  Web.Lineage.ends, Web.ceasingFrom_found, Web.arisingFrom_found and Web.lineages_apart, and Population's definition
  endTest (read from the receipt's declaration lists, the signature audit printing theorems);
- added: the laws and helpers of the design's §6, read from the list below;
- nothing moved between modules, and every axiom report of the changed modules empty.
usage (from the checkout root, after the checker): python3 -B <kit>/u4d_signatures.py [RECEIPT_ID | --dir RUN_DIR]"""
import importlib.util
import json
import os
import subprocess
import sys
from pathlib import Path

ROOT = Path.cwd()
OU3B = next((ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation/development').glob('*/kit/signatures_ou3b.py'))
spec = importlib.util.spec_from_file_location('s3b', OU3B)
s3b = importlib.util.module_from_spec(spec)
spec.loader.exec_module(s3b)
PKG = s3b.PKG
CHANGED = ('Prelude', 'GrammarLaws', 'Population', 'Locality', 'Decidedness', 'Identity')
B = 'Becoming.'
STRONGER = {B + 'GrammarLaws.census_run', B + '«定后前者在前则亡屡者生屡»'}
BINDERS = {B + 'Web.Census.arisingFrom_of_ceasingFrom_from', B + 'Web.Census.arisingFrom_of_ceasingFrom',
           B + 'Web.Census.ceasingFrom_of_arisingFrom_from', B + 'Web.Census.ceasingFrom_of_arisingFrom'}
GONE = {B + n for n in ('accumulates_or', 'ceases_once', 'ceasing_steps_unrefuted', 'Web.Lineage.ends',
                        'Web.ceasingFrom_found', 'Web.arisingFrom_found', 'Web.lineages_apart')}
GONE_DEFINITIONS = {B + 'endTest'}  # a definition: the signature audit prints theorems, the receipt lists it
ADDED = {B + n for n in (
    # GrammarLaws: lines from a list, ends on lines at stages, the census of a run's search
    '«所闭当且仅当有迭»', '«分处定后则迭之定于»', 'GrammarLaws.reorder', '«亡者不在长迭»', '«定后则线至多一亡»',
    '«线终不过所列»', 'GrammarLaws.line_ends_unrefuted', '«线亡不过所列»', '«线亡不过所列之未否»', '«线生不过所列»',
    '«线生不过所列之未否»', 'GrammarLaws.stage_steps', 'GrammarLaws.fixed_of_noSplit', 'GrammarLaws.found_cons',
    'GrammarLaws.found', 'GrammarLaws.found_unrefuted', 'GrammarLaws.found_or_all', 'GrammarLaws.trace',
    'GrammarLaws.trace_unrefuted', '«间无生则间亡不过所覆»', '«所覆后亡屡则有生»', '«有覆而亡屡则生屡»',
    '«所覆后亡屡则生未否»', '«有覆而亡屡则生不止»', 'GrammarLaws.onward_within', '«间无亡则间生不过所覆»',
    '«有界覆而生屡则亡不止»', 'GrammarLaws.trace_on', '«有界覆而生屡则亡屡»', 'GrammarLaws.pair_eq',
    'GrammarLaws.stage_search',
    # Prelude
    'exists_pairs_over', 'distinct_of_map',
    # Locality
    'Covers.occurrences', 'Steps.along_back', 'Steps.along_decided', 'Steps.along_ending', 'Steps.along_noSplit',
    'Steps.along_stage',
    # Decidedness
    'Steps.along_family_back', 'Steps.along_family_on', 'Steps.along_noMerge', 'Steps.family_occurrences',
    # Identity
    'Web.arisingFrom_of_ceasingFrom_covered', 'Web.ceasingFrom_of_arisingFrom_covered', 'Web.continuation_arises',
    'Web.continuation_back', 'Web.continuation_begins', 'Web.continuation_ceases', 'Web.continuation_covers',
    'Web.continuation_decided_begin', 'Web.continuation_decided_end', 'Web.continuation_ending',
    'Web.continuation_noMerge', 'Web.continuation_noSplit', 'Web.continuation_on', 'Web.continuation_stage')}
BASE = os.environ.get('U4D_BASE') or 'main'


def main_json(path):
    return json.loads(subprocess.run(['git', 'show', f'{BASE}:{path}'], cwd=ROOT, capture_output=True, text=True,
                                     check=True).stdout)


if len(sys.argv) > 2 and sys.argv[1] == '--dir':
    runs = sorted(p for p in Path(sys.argv[2]).iterdir() if (p / 'verification.json').exists())
    assert runs, sys.argv[2]
    new_r = json.loads((runs[-1] / 'verification.json').read_text())
else:
    new_r = s3b.receipt(sys.argv[1] if len(sys.argv) > 1 else None)
old_r = main_json(f'{PKG}/becoming-verification.json')
assert new_r['status'] == 'passed', new_r['status']


def body(sig):
    """the printed statement without its name, its runs of whitespace collapsed (the printer wraps at a fixed width)"""
    return ' '.join((sig.split(' : ', 1)[1] if ' : ' in sig else sig).split())


old, new, where_old, where_new = {}, {}, {}, {}
for m in CHANGED:
    step = f'Becoming{m}Signatures.log'
    o = s3b.parse(s3b.log_of(old_r, step))
    n = s3b.parse(s3b.log_of(new_r, step))
    old.update(o)
    new.update(n)
    where_old.update({k: m for k in o})
    where_new.update({k: m for k in n})
changed = sorted(n for n in old if n in new and body(old[n]) != body(new[n]))
gone = sorted(n for n in old if n not in new)
added = sorted(n for n in new if n not in old)
moved = sorted(n for n in old if n in new and where_old[n] != where_new[n])
decl_old = {d['name'] for m in old_r['modules'] if m['module'] in {B + c for c in CHANGED} for d in m['declarations']}
decl_new = {d['name'] for m in new_r['modules'] if m['module'] in {B + c for c in CHANGED} for d in m['declarations']}
report = {'base': BASE, 'old_receipt': old_r['utc'], 'new_receipt': new_r['utc'], 'declarations_old': len(old),
          'declarations_new': len(new), 'changed': changed, 'gone': gone, 'added': added, 'moved': moved}
if '--show' in sys.argv:
    for n in changed:
        print('OLD', old[n]); print('NEW', new[n]); print()
print(json.dumps(report, indent=1, ensure_ascii=False))
problems = []
if not set(changed) <= STRONGER | BINDERS or not STRONGER <= set(changed):
    problems.append(('statements changed', sorted(set(changed) - STRONGER - BINDERS), 'missing',
                     sorted(STRONGER - set(changed))))
if set(gone) != GONE:
    problems.append(('gone', sorted(set(gone) ^ GONE)))
if set(added) != ADDED:
    problems.append(('added', sorted(set(added) ^ ADDED)))
if moved:
    problems.append(('moved', moved))
if decl_old - decl_new != GONE | GONE_DEFINITIONS:
    problems.append(('declarations gone', sorted((decl_old - decl_new) ^ (GONE | GONE_DEFINITIONS))))
if decl_new - decl_old != ADDED:
    problems.append(('declarations added', sorted((decl_new - decl_old) ^ ADDED)))
for m in new_r['modules']:
    if m['module'] in (B + c for c in CHANGED):
        assert not any(m['axiom_dependencies'].values()), (m['module'], m['axiom_dependencies'])
print('OK: the census of a run\'s two laws stronger, the four census recurrence laws printed with their binders,',
      len(set(changed) & BINDERS), 'of them changed in print; every other statement unchanged; gone', len(gone),
      '; added', len(added), '; nothing moved; every axiom report of the', len(CHANGED), 'changed modules empty; endTest gone'
      if not problems else f'UNEXPECTED: {problems}')
sys.exit(1 if problems else 0)
