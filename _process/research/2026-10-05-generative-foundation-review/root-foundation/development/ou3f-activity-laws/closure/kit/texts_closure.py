#!/usr/bin/env python3
"""OU3f, closure: 01 §7's closure bullet gains the closure at the successor and its cases; 08's receipt and counts; the
study section.
usage (from the checkout root of the landing worktree, after the checker): python3 -B <kit>/texts_closure.py RECEIPT N"""
import json
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
RECEIPT, N = sys.argv[1], int(sys.argv[2])
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
CH = ROOT / 'theories/becoming/chapters'
STUDY = ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:80], text.count(old))
    path.write_text(text.replace(old, new), encoding='utf-8')


edit(CH / '01-ROOT.md',
     """every loss of a returning configuration passes a juncture (`Branching.loss_passes_juncture`).""",
     """every loss of a returning configuration passes a juncture (`Branching.loss_passes_juncture`). A region of the steps of time that every step keeps holds from where it holds on, the closure at the successor along a line (`kept_onward`, from `«线则所闭»` and `«闭含所闭»`); the activity laws that keep a region along the steps by their own induction, from never arising from an inactive start being never active (`Web.inactive_of_not_arising`) to tracing a carrier back (`Web.ByPassing.trace`), are its cases.""")

R = json.loads((ROOT / PKG / 'becoming-checks' / RECEIPT / 'verification.json').read_text())
assert R['status'] == 'passed'
layers = {}
for module in R['modules']:
    count = layers.setdefault(module['layer'], [0, 0])
    count[0] += 1
    count[1] += module['theorems']
modules = sum(v[0] for v in layers.values())
theorems = sum(v[1] for v in layers.values())
assert modules == len(R['core_closure'])
ring = layers.get('instance', [0, 0])[0] + layers.get('application', [0, 0])[0]
declarations = sum(len(m['declarations']) for m in R['modules'])
injeq = sum(1 for name, axioms in R['generated_axiom_dependencies'].items() if name.endswith('.injEq') and axioms == ['propext'])
assert injeq == len(R['generated_axiom_dependencies'])
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

section = (HERE / 'study_closure.txt').read_text(encoding='utf-8')
mods = {x['module']: x for x in R['modules']}
fill = {'{N}': str(N), '{RECEIPT}': RECEIPT,
        '{KOT}': str(mods['Becoming.KeptOnward']['theorems']), '{KOD}': str(len(mods['Becoming.KeptOnward']['declarations']))}
for key, value in fill.items():
    section = section.replace(key, value)
assert not re.search(r'\{[A-Z]+\}', section), 'unfilled placeholder'
t = STUDY.read_text(encoding='utf-8')
assert f'\n## {N}. ' not in t
assert max(int(x) for x in re.findall(r'^## (\d+)\. ', t, re.M)) == N - 1, 'N must be the last section plus one'
STUDY.write_text(t.rstrip('\n') + '\n\n' + section.strip('\n') + '\n', encoding='utf-8')
print('texts: 01 §7 closure bullet; 08 counts; study section', N)
