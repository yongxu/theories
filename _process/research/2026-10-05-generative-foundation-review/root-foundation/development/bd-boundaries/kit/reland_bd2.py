#!/usr/bin/env python3
"""BD2's landing (reland_rr2.py's pattern): 08's counts from the receipt, the study section from study_bd2.txt appended
as section N, and the receipt written into the two records the kit left `PENDING` (the new record and the sixth law of
conveyance-crosses-the-boundary), with a receipt reference each. The other texts are already on the branch.
usage (from the checkout root of the worktree): python3 -B <kit>/reland_bd2.py RECEIPT N"""
import hashlib
import json
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
RECEIPT, N = sys.argv[1], int(sys.argv[2])
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
STUDY = ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'
CH = ROOT / 'theories/becoming/chapters'
RECORDS = ROOT / 'theories/becoming/results/records'
PENDING = ('not-going-out-of-a-region', 'conveyance-crosses-the-boundary')
TITLE = 'Not going out of a region, on the root (BD2)'
MODULES = ('GrammarCrossing', 'ConveyanceBoundaries', 'GrammarPath', 'GrammarCases')

rpath = f'{PKG}/becoming-checks/{RECEIPT}/verification.json'
R = json.loads((ROOT / rpath).read_text())
assert R['status'] == 'passed'
mods = {m['module']: m for m in R['modules']}
for short in MODULES:
    m = mods[f'Becoming.{short}']
    assert m['layer'] == 'core', (short, m['layer'])
    assert not any(m['axiom_dependencies'].values()), short

# 08: receipt and counts, every count read from the receipt
layers = {}
for module in R['modules']:
    count = layers.setdefault(module['layer'], [0, 0])
    count[0] += 1
    count[1] += module['theorems']
assert set(layers) <= {'foundation', 'core', 'instance', 'application'}, set(layers)
modules = sum(v[0] for v in layers.values())
theorems = sum(v[1] for v in layers.values())
assert modules == len(R['core_closure']), (modules, len(R['core_closure']))
ring = layers.get('instance', [0, 0])[0] + layers.get('application', [0, 0])[0]
declarations = sum(len(m['declarations']) for m in R['modules'])
injeq = sum(1 for name, axioms in R['generated_axiom_dependencies'].items()
            if name.endswith('.injEq') and axioms == ['propext'])
assert injeq == len(R['generated_axiom_dependencies']), 'a generated dependency other than injEq on propext'
superseded = len(R['superseded_modules'])
link = f'../../../{PKG}/becoming-checks/{RECEIPT}/verification.json'
counts = (f"At core receipt [`{RECEIPT}`]({link}) (Lean 4.29.1), the closure held {modules} modules "
          f"({layers['foundation'][0]} foundation, {layers['core'][0]} core, {ring} in the instance and application ring) "
          f"and {theorems:,} theorems; the {layers['core'][0]} core modules held {layers['core'][1]:,} of them; "
          f"{declarations:,} declarations were audited; {injeq} generated `injEq` lemmas depend on `propext`; "
          f"{superseded} superseded modules were kept out of the run.")
path = CH / '08-METHOD.md'
s = path.read_text(encoding='utf-8')
s, k = re.subn(r"At core receipt \[`[0-9TZ.]+`\]\([^)]*\) \(Lean 4\.29\.1\), the closure held \d+ modules \(\d+ foundation, "
               r"\d+ core, \d+ in the instance and application ring\) and [\d,]+ theorems; the \d+ core modules held [\d,]+ of "
               r"them; [\d,]+ declarations were audited; \d+ generated `injEq` lemmas depend on `propext`; \d+ superseded "
               r"modules were kept out of the run\.", lambda m: counts, s)
assert k == 1, k
path.write_text(s, encoding='utf-8')

# the study section, appended as section N
section = (HERE / 'study_bd2.txt').read_text(encoding='utf-8').replace('{N}', str(N)).replace('{RECEIPT}', RECEIPT)
for short in MODULES[:3]:
    m = mods[f'Becoming.{short}']
    section = section.replace(f'({short.upper()})', f"({m['theorems']} theorems in {len(m['declarations'])} declarations)")
assert '{' not in section and 'TODO' not in section and not re.search(r'\([A-Z]{8,}\)', section), 'a placeholder left'
t = STUDY.read_text(encoding='utf-8')
assert TITLE not in t, "BD2's section is already in the study"
assert f'\n## {N}. ' not in t and f'\n## {N - 1}. ' in t, N
STUDY.write_text(t.rstrip('\n') + '\n\n' + section.strip('\n') + '\n', encoding='utf-8')

# the receipt in the two records
digest = hashlib.sha256((ROOT / rpath).read_bytes()).hexdigest()
gc = mods['Becoming.GrammarCrossing']
for rid in PENDING:
    p = RECORDS / f'{rid}.json'
    text = p.read_text(encoding='utf-8')
    assert text.count('PENDING') >= 2, (rid, text.count('PENDING'))
    text = text.replace('PENDING', RECEIPT)
    d = json.loads(text)
    if rid == 'not-going-out-of-a-region':
        n_decl, n_thm = len(gc['declarations']), gc['theorems']
        for lang, old in (('en', '12 declarations (11 theorems)'), ('zh', '12 项声明（11 条定理）')):
            new = (f'{n_decl} declarations ({n_thm} theorems)' if lang == 'en' else f'{n_decl} 项声明（{n_thm} 条定理）')
            assert old in d['validation_scope'][lang], (lang, d['validation_scope'][lang])
            d['validation_scope'][lang] = d['validation_scope'][lang].replace(old, new)
    for b in d['proof_bindings']:
        if RECEIPT in b['receipt']:
            assert b['receipt'] == rpath, b['receipt']
    if not any(x.get('path') == rpath for x in d['references']):
        d['references'].append({'path': rpath, 'role': 'receipt', 'sha256': digest, 'declarations': []})
    p.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('reland:', counts[:110], '...; study section', N, '; receipt written into', PENDING)
