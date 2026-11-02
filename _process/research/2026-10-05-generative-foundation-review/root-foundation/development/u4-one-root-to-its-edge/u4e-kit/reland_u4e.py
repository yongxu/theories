#!/usr/bin/env python3
"""U4e's landing (reland_u4d.py's pattern): 08's counts from the receipt; the study section from study_u4e.txt appended
as section N, each changed module's counts read from the receipt; the section written into the records' U4E_SECTION
marks. The receipt must have checked the very bytes of the three changed modules, each in the core with every axiom
report empty. The changed modules' proof bindings are repoint_u4e.py's.
usage (from the checkout root of the worktree): python3 -B <kit>/reland_u4e.py RECEIPT N"""
import hashlib
import json
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
RECEIPT, N = sys.argv[1], int(sys.argv[2])
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation'
STUDY = ROOT / f'{RF}/BECOMING-RENEWAL-READING.md'
CH = ROOT / 'theories/becoming/chapters'
RECORDS = ROOT / 'theories/becoming/results/records'
TITLE = "Identity's covering laws finished (U4e)"
CHANGED = ('Identity', 'Persistence', 'RootForms')
MARKED = ('census-balance-under-continuation', 'identity-across-steps', 'one-root-to-its-edge')

rpath = f'{PKG}/becoming-checks/{RECEIPT}/verification.json'
R = json.loads((ROOT / rpath).read_text())
assert R['status'] == 'passed'
mods = {m['module']: m for m in R['modules']}
for short in CHANGED:
    m = mods[f'Becoming.{short}']
    assert m['layer'] == 'core', (short, m['layer'])
    assert not any(m['axiom_dependencies'].values()), short
    sha = hashlib.sha256((ROOT / f'{PKG}/Becoming/{short}.lean').read_bytes()).hexdigest()
    assert R['source_sha256'][f'Becoming.{short}'] == sha, f'the receipt checked another {short}.lean'

# 08: receipt and counts, every count read from the receipt (reland_u4d.py's sentence)
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

# the study section, appended as section N, with each changed module's counts
section = (HERE / 'study_u4e.txt').read_text(encoding='utf-8').replace('{N}', str(N)).replace('{RECEIPT}', RECEIPT)
for short in CHANGED:
    m = mods[f'Becoming.{short}']
    section = section.replace(f'({short.upper()})', f"({m['theorems']} theorems in {len(m['declarations'])} declarations)")
assert '{' not in section and 'TODO' not in section and not re.search(r'\([A-Z]{6,}\)', section), 'a placeholder left'
t = STUDY.read_text(encoding='utf-8')
assert TITLE not in t, "U4e's section is already in the study"
assert f'\n## {N}. ' not in t and f'\n## {N - 1}. ' in t, N
STUDY.write_text(t.rstrip('\n') + '\n\n' + section.strip('\n') + '\n', encoding='utf-8')

# the records: the section marks
for rid in MARKED:
    p = RECORDS / f'{rid}.json'
    text = p.read_text(encoding='utf-8')
    assert text.count('U4E_SECTION') == 2, rid  # the history line's two languages
    out = text.replace('U4E_SECTION', str(N))
    json.loads(out)
    p.write_text(out, encoding='utf-8')
print('reland:', counts[:110], '...; study section', N, '; marks filled in', len(MARKED), 'records')
