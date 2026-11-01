#!/usr/bin/env python3
"""EL6's landing (reland_el.py's pattern): 08's counts from the receipt, the study section from study_el6.txt
appended as section N, the receipt and section written into the EL study note's EL6_RECEIPT and EL6_SECTION marks,
and the receipt written into degeneration-from-a-horizon, which the branch left `PENDING`: each of its three proof
references' sha256, its three proof bindings, its validation scope, and a receipt reference. The receipt
must have checked the very bytes the record names, and LineDegeneration must be gone from it.
usage (from the checkout root of the worktree): python3 -B <kit>/reland_el6.py RECEIPT N"""
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
RECORD = ROOT / 'theories/becoming/results/records/degeneration-from-a-horizon.json'
NOTE = ROOT / f'{RF}/development/el-evolution-on-the-root/NOTE.md'
TITLE = "EL3 placed in its owners' modules (EL6)"
MODULES = ('GrammarMap', 'MapInstances', 'KeepingWidening')
CHANGED = ('GrammarMap', 'GrammarConditionals', 'MapInstances', 'KeepingWidening', 'LineageRegions')

rpath = f'{PKG}/becoming-checks/{RECEIPT}/verification.json'
R = json.loads((ROOT / rpath).read_text())
assert R['status'] == 'passed'
mods = {m['module']: m for m in R['modules']}
assert 'Becoming.LineDegeneration' not in mods, 'LineDegeneration is still in the run'
sha = {}
for short in CHANGED:
    m = mods[f'Becoming.{short}']
    assert m['layer'] == 'core', (short, m['layer'])
    assert not any(m['axiom_dependencies'].values()), short
    sha[short] = hashlib.sha256((ROOT / f'{PKG}/Becoming/{short}.lean').read_bytes()).hexdigest()
    assert R['source_sha256'][f'Becoming.{short}'] == sha[short], f'the receipt checked another {short}.lean'

# 08: receipt and counts, every count read from the receipt (reland_el.py's sentence)
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


def tally(short):
    m = mods[f'Becoming.{short}']
    return m['theorems'], len(m['declarations'])


# the study section, appended as section N, with each changed module's counts
section = (HERE / 'study_el6.txt').read_text(encoding='utf-8').replace('{N}', str(N)).replace('{RECEIPT}', RECEIPT)
for short in CHANGED:
    t, d = tally(short)
    section = section.replace(f'({short.upper()})', f'({t} theorems in {d} declarations)')
assert '{' not in section and 'TODO' not in section and not re.search(r'\([A-Z]{8,}\)', section), 'a placeholder left'
t = STUDY.read_text(encoding='utf-8')
assert TITLE not in t, "EL6's section is already in the study"
assert f'\n## {N}. ' not in t and f'\n## {N - 1}. ' in t, N
STUDY.write_text(t.rstrip('\n') + '\n\n' + section.strip('\n') + '\n', encoding='utf-8')

# the study note's marks
s = NOTE.read_text(encoding='utf-8')
assert 'EL6_RECEIPT' in s and 'EL6_SECTION' in s
NOTE.write_text(s.replace('EL6_RECEIPT', RECEIPT).replace('EL6_SECTION', str(N)), encoding='utf-8')

# the record: references, bindings, validation scope, receipt reference
digest = hashlib.sha256((ROOT / rpath).read_bytes()).hexdigest()
text = RECORD.read_text(encoding='utf-8')
d = json.loads(text.replace('becoming-checks/PENDING/', f'becoming-checks/{RECEIPT}/').replace('at receipt PENDING', f'at receipt {RECEIPT}')
               .replace('回执 PENDING', f'回执 {RECEIPT}'))
for ref in d['references']:
    for short in MODULES:
        if ref['path'] == f'{PKG}/Becoming/{short}.lean':
            assert ref['sha256'] == 'PENDING', ref['path']
            ref['sha256'] = sha[short]
for b in d['proof_bindings']:
    assert b['receipt'] == rpath, b
d['references'] = [x for x in d['references'] if x.get('role') != 'receipt']
d['references'].append({'path': rpath, 'role': 'receipt', 'sha256': digest, 'declarations': []})
out = json.dumps(d, ensure_ascii=False, indent=2) + '\n'
assert 'PENDING' not in out, 'a PENDING left in the record'
RECORD.write_text(out, encoding='utf-8')
print('reland:', counts[:110], '...; study section', N, '; receipt written into degeneration-from-a-horizon and NOTE')
