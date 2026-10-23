#!/usr/bin/env python3
"""IV3j: 08-METHOD's receipt and counts ("Rings and receipts"), every count read from the receipt: the closure's modules
by layer and theorems, the core's theorems, the declarations audited, the generated injEq lemmas depending on propext and
the superseded modules kept out of the run.
usage (from the checkout root): python3 -B receipts_j.py RECEIPT"""
import json
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
RECEIPT = sys.argv[1]
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
R = json.loads((ROOT / PKG / 'becoming-checks' / RECEIPT / 'verification.json').read_text())
assert R['status'] == 'passed'
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
injeq = sum(1 for name, axioms in R['generated_axiom_dependencies'].items() if name.endswith('.injEq') and axioms == ['propext'])
assert injeq == len(R['generated_axiom_dependencies']), 'a generated dependency other than injEq on propext'
superseded = len(R['superseded_modules'])
link = f'../../../{PKG}/becoming-checks/{RECEIPT}/verification.json'
new = (f"At core receipt [`{RECEIPT}`]({link}) (Lean 4.29.1), the closure held {modules} modules "
       f"({layers['foundation'][0]} foundation, {layers['core'][0]} core, {ring} in the instance and application ring) "
       f"and {theorems:,} theorems; the {layers['core'][0]} core modules held {layers['core'][1]:,} of them; "
       f"{declarations:,} declarations were audited; {injeq} generated `injEq` lemmas depend on `propext`; "
       f"{superseded} superseded modules were kept out of the run.")
path = ROOT / 'theories/becoming/chapters/08-METHOD.md'
s = path.read_text(encoding='utf-8')
s, k = re.subn(r"At core receipt \[`[0-9TZ.]+`\]\([^)]*\) \(Lean 4\.29\.1\), the closure held \d+ modules \(\d+ foundation, "
               r"\d+ core, \d+ in the instance and application ring\) and [\d,]+ theorems; the \d+ core modules held [\d,]+ of "
               r"them; [\d,]+ declarations were audited; \d+ generated `injEq` lemmas depend on `propext`; \d+ superseded "
               r"modules were kept out of the run\.", lambda m: new, s)
assert k == 1, k
path.write_text(s, encoding='utf-8')
print(new)
