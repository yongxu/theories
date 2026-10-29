#!/usr/bin/env python3
"""U2 texts. 08's receipt counts, read from the receipt (as texts_wrp2.py); 08 §7's account of the rows on no master
law, one sentence after its count of the 36, with F5's figures read from MV's master-laws.json; and the study section,
from study_u2.txt, its figures read from the receipt and from master-laws.json. Run after the checker, after
make_records_u2.py and after tools/research/master_laws.py. Every edit is asserted to apply exactly once.
usage (from the checkout root): python3 -B texts_u2.py RECEIPT N"""
import json
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
RECEIPT, N = sys.argv[1], int(sys.argv[2])
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
CH = ROOT / 'theories/becoming/chapters'
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation'
STUDY = ROOT / RF / 'BECOMING-RENEWAL-READING.md'
MV = json.loads((ROOT / 'theories/becoming/results/data/master-laws.json').read_text(encoding='utf-8'))
assert MV['core_receipt'] == RECEIPT, ('master-laws.json is not on this receipt', MV['core_receipt'])
reach = MV['central_reach']['counts']
REACH, AT_MODEL = reach['reaching the grammar'], reach['stated at a represented model']
OWN, REST = reach['stated on its own carrier only'], reach['the rest']
assert REACH + AT_MODEL + OWN + REST == 118, reach
assert (AT_MODEL, OWN) == (16, 4), ('F5 does not verify all of U2: expected 16 at a represented model and 4 on their '
                                    'own carrier only', reach)

# 08: receipt and counts, every count read from the receipt (as texts_wrp2.py)
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

# 08 §7: what U2 does with the 24 rows that are laws of their models, single applications or definitional
anchor = ("4 single applications of a premise or a closed region, and 13 definitional or representational. ")
assert s.count(anchor) == 1, s.count(anchor)
design = '../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/u2-rows-on-the-root/DESIGN.md'
sentence = (f"Of those 24, 20 are stated where their terms are the grammar's, each proved through its row and declared on "
            f"its row's record as a statement at a model, a representation and not a derivation ([U2]({design})); three "
            f"resist, their terms amounts computed over a family; and one is read on the root with the significance rows. "
            f"So F5's report, over the 118, counts {REACH} reaching the grammar, {AT_MODEL} stated at a represented model, "
            f"{OWN} stated on their own carrier only, and {REST} the rest. ")
assert sentence not in s
s = s.replace(anchor, anchor + sentence)
path.write_text(s, encoding='utf-8')

# the study section
mods = {m['module']: m for m in R['modules']}
leaf = mods['Becoming.ModelStatements']
assert not any(leaf['axiom_dependencies'].values())
section = (HERE / 'study_u2.txt').read_text(encoding='utf-8')
for key, value in (('{N}', N), ('{RECEIPT}', RECEIPT), ('{REACH}', REACH), ('{AT_MODEL}', AT_MODEL), ('{OWN}', OWN),
                   ('{REST}', REST)):
    section = section.replace(key, str(value))
section = section.replace('(COUNTS)', f"({leaf['theorems']} theorems in {len(leaf['declarations'])} declarations)")
assert '{' not in section and '(COUNTS)' not in section, 'a placeholder left'
t = STUDY.read_text(encoding='utf-8')
assert f'\n## {N}. ' not in t and f'\n## {N - 1}. ' in t, N
STUDY.write_text(t.rstrip('\n') + '\n\n' + section.strip('\n') + '\n', encoding='utf-8')
print('texts: 08 counts:', counts[:80], '...; 08 §7 sentence; study section', N, '; F5:', reach)
