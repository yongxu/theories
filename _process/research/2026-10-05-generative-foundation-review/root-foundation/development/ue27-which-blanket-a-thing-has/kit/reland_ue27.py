#!/usr/bin/env python3
"""UE27's landing (reland_ue26.py's pattern, with no periphery): 08's counts from the core receipt, the study section
from study_ue27.txt appended as section N with the receipt and counts filled in, and the records built and amended by
make_records_ue27.py after copying the blanket's record and moving any earlier new record to ASIDE (a folder outside
the repository; nothing is deleted). The other texts are put in place by integrate_ue27.py and texts_ue27.py.
usage (from the checkout root of the landing worktree): python3 -B <kit>/reland_ue27.py CORE N ASIDE"""
import json
import re
import shutil
import subprocess
import sys
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
RECEIPT, N, ASIDE = sys.argv[1], int(sys.argv[2]), Path(sys.argv[3])
LEANR = 'experiments/integrated-correction/general-framework/generative-basis/lean'
PKG = f'{LEANR}/becoming'
STUDY = ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'
CH = ROOT / 'theories/becoming/chapters'
RECORDS = ROOT / 'theories/becoming/results/records'
RIDS = ('a-formations-couplings-as-its-blanket',)
AMENDED = ('the-markov-blanket-as-a-coupling-structure',)
TITLE = "Which blanket a thing has, and a formation's couplings as its blanket (UE27)"

R = json.loads((ROOT / PKG / 'becoming-checks' / RECEIPT / 'verification.json').read_text())
assert R['status'] == 'passed'
mod = next(m for m in R['modules'] if m['module'] == 'Becoming.BlanketCouplings')
assert not any(mod['axiom_dependencies'].values())

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
section = (HERE / 'study_ue27.txt').read_text(encoding='utf-8')
section = section.replace('{N}', str(N)).replace('{RECEIPT}', RECEIPT)
section = section.replace('(COUNTS)', f"({mod['theorems']} theorems in {len(mod['declarations'])} declarations)")
assert '{' not in section and 'TODO' not in section and 'COUNTS)' not in section, 'a placeholder left'
t = STUDY.read_text(encoding='utf-8')
assert TITLE not in t, 'UE27\'s section is already in the study'
assert f'\n## {N}. ' not in t and f'\n## {N - 1}. ' in t, N
STUDY.write_text(t.rstrip('\n') + '\n\n' + section.strip('\n') + '\n', encoding='utf-8')

# the records: the earlier ones moved aside, then rebuilt
ASIDE.mkdir(parents=True, exist_ok=True)
for rid in AMENDED:
    shutil.copyfile(RECORDS / f'{rid}.json', ASIDE / f'{rid}.before.json')
for rid in RIDS:
    for ext in ('.json', '.md'):
        p = RECORDS / f'{rid}{ext}'
        if p.exists():
            shutil.move(str(p), str(ASIDE / f'{rid}{ext}'))
subprocess.run([sys.executable, '-B', str(HERE / 'make_records_ue27.py'), RECEIPT, str(N)], check=True)
print('reland:', counts[:100], '...; study section', N, '; records built; earlier records in', ASIDE)
