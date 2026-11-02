#!/usr/bin/env python3
"""U4e: compare the printed statements (`#check @name`, the checker's signature audit) of every declaration of the two
modules U4e changes between main's receipt (the one main holds) and U4e's (or a rehearsal's), main's side read at
U4E_BASE, the main merged in (default main); u4d_signatures.py's pattern. Expected, and nothing else:
- five statements each main's with exactly the decision binders its proof does not use removed: the four census
  recurrence laws of Identity (the arising direction drops decided activity and decided `Continued`, the ceasing
  direction decided activity and decided `Continues`) and Persistence's `Web.persisting_census` (decided holding
  activity and the decided continuation);
- RootForms.some_depends stating its witness: main's statement less its double negation (the Lean review's finding);
- every other statement unchanged, Web.arisingFrom_not_stopping_covered's included (its proof alone changes);
- nothing added, gone or moved, and every axiom report of the two modules empty.
usage (from the checkout root, after the checker): python3 -B <kit>/u4e_signatures.py [RECEIPT_ID | --dir RUN_DIR]"""
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
CHANGED = ('Identity', 'Persistence', 'RootForms')
B = 'Becoming.'
ACTIVE = '[(t : Nat) → (f : F) → Decidable (W.active t f)]'
CONTINUES = '[(t : Nat) → (f : F) → Decidable (W.Continues R t f)]'
CONTINUED = '[(t : Nat) → (g : F) → Decidable (W.Continued R t g)]'
DROPPED = {
    B + 'Web.Census.arisingFrom_of_ceasingFrom_from': (ACTIVE, CONTINUED),
    B + 'Web.Census.arisingFrom_of_ceasingFrom': (ACTIVE, CONTINUED),
    B + 'Web.Census.ceasingFrom_of_arisingFrom_from': (ACTIVE, CONTINUES),
    B + 'Web.Census.ceasingFrom_of_arisingFrom': (ACTIVE, CONTINUES),
    B + 'Web.persisting_census': ('[(t : Nat) → (f : F) → Decidable ((W.persisting h).active t f)]',
                                  '[(t : Nat) → (g f : F) → Decidable (R t g f)]'),
}
STRONGER = B + 'RootForms.some_depends'
BASE = os.environ.get('U4E_BASE') or 'main'


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
if set(changed) != set(DROPPED) | {STRONGER}:
    problems.append(('statements changed', sorted(set(changed) ^ (set(DROPPED) | {STRONGER}))))
elif not (body(old[STRONGER]).startswith('¬¬') and body(old[STRONGER])[2:].lstrip() == body(new[STRONGER])):
    problems.append(('not main\'s statement less its double negation', STRONGER))
for name, binders in DROPPED.items():
    if name not in old or name not in new:
        problems.append(('missing', name))
        continue
    expected = body(old[name])
    for binder in binders:
        if expected.count(binder + ' ') != 1:
            problems.append(('binder not found once', name, binder))
        expected = expected.replace(binder + ' ', '', 1)
    if expected != body(new[name]):
        problems.append(('not main\'s statement less the binders', name))
if gone or added or moved:
    problems.append(('gone, added or moved', gone, added, moved))
if decl_old != decl_new:
    problems.append(('declarations', sorted(decl_old ^ decl_new)))
for m in new_r['modules']:
    if m['module'] in (B + c for c in CHANGED):
        assert not any(m['axiom_dependencies'].values()), (m['module'], m['axiom_dependencies'])
print('OK: five statements main\'s less the decision binders their proofs do not use; RootForms.some_depends '
      'main\'s less its double negation; every other statement of Identity, Persistence and RootForms unchanged; nothing added, gone or moved; every axiom report of the three modules empty'
      if not problems else f'UNEXPECTED: {problems}')
sys.exit(1 if problems else 0)
