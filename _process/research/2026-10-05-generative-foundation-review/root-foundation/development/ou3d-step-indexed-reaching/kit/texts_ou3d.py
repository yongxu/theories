#!/usr/bin/env python3
"""OU3d texts: 01 §7's finite-runs bullet (the home of master-laws-on-the-grammar) gains the laws of steps counted;
the measure gives PartForms.goAlike its reason (a law of its model, OU3d's review) in place of a pending derivation, and
08 §7's measure sentence takes the rerun measure where that changes it (one gap fewer); 08's receipt and counts; the
study section. The three step-indexed rows are not bridged, so they stay the measure's pending derivations.
usage (from the checkout root of the landing worktree, after the checker, measure_reason_ou3d.py and the measure):
  python3 -B <kit>/texts_ou3d.py RECEIPT N MEASURE_JSON"""
import json
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
RECEIPT, N, MEASURE = sys.argv[1], int(sys.argv[2]), Path(sys.argv[3])
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
CH = ROOT / 'theories/becoming/chapters'
STUDY = ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:80], text.count(old))
    path.write_text(text.replace(old, new), encoding='utf-8')


# 01 §7
edit(CH / '01-ROOT.md', """`Learning.lasso_of_held`), so the learnability laws reach the grammar through it.""",
     """`Learning.lasso_of_held`), so the learnability laws reach the grammar through it. Steps are counted too: within `m` steps and then within `n` is within `m + n` (`«迭内之接»`), and a course of regions each of whose rounds holds what every condition held at the round before (`«承»`) holds at round `n` exactly where everything reaching in `n` steps held at the start (`«承之迭»`); with memory, within `n` steps, the law without memory under staying or a step (`«存承之迭»`). Giving that waits on giving has these closed forms for its chains (`Withholding.answers_closed`, `Withholding.waitsAll_closed`); the bridges are a second step.""")

# 08 §7: the measure sentence where the reason changes it, every number from the measure rerun after
# measure_reason_ou3d.py
DESIGN = '../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ou3d-step-indexed-reaching/DESIGN.md'
A = json.loads(MEASURE.read_text(encoding='utf-8'))
assert 'Becoming.PartForms.goAlike' not in A.get('pending_derivations', {}), 'PartForms.goAlike still pending: rerun the measure'
dep = A['distinct_by_dependence']
path = CH / '08-METHOD.md'
s = path.read_text(encoding='utf-8')
for pattern, repl in (
        (r"\d+ rest on another master law's anchor without reaching it, \d+ each with its reason (\(\[audit\]\([^)]*\)\)) and 1 a case of the "
         r"grammar's lumping law whose derivation is not yet given \(`PartForms\.goAlike`, the part carrying a law of its own\);",
         lambda m: (f"{dep['anchor, not reached']} rest on another master law's anchor without reaching it, each with its "
                    f"reason {m.group(1)[:-1]}; for `PartForms.goAlike`, the part carrying a law of its own, a law of its "
                    f"model ([design]({DESIGN})));")),
        (r",? and with `PartForms\.goAlike` they are the measure's \d+ gaps", f", and they are the measure's {A['distinct_gaps']} gaps")):
    s, k = re.subn(pattern, repl, s)
    assert k == 1, (pattern[:50], k)
path.write_text(s, encoding='utf-8')

# 08: receipt and counts, every count read from the receipt
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
injeq = sum(1 for name, axioms in R['generated_axiom_dependencies'].items()
            if name.endswith('.injEq') and axioms == ['propext'])
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

# the study section
section = (HERE / 'study_ou3d.txt').read_text(encoding='utf-8')
gl = next(x for x in R['modules'] if x['module'] == 'Becoming.GrammarLaws')
for key, value in (('{N}', str(N)), ('{RECEIPT}', RECEIPT), ('{GLT}', str(gl['theorems'])),
                   ('{GLD}', str(len(gl['declarations'])))):
    section = section.replace(key, value)
assert not re.search(r'\{[A-Z]+\}', section), 'unfilled placeholder'
t = STUDY.read_text(encoding='utf-8')
assert f'\n## {N}. ' not in t
assert max(int(x) for x in re.findall(r'^## (\d+)\. ', t, re.M)) == N - 1, 'N must be the last section plus one'
STUDY.write_text(t.rstrip('\n') + '\n\n' + section.strip('\n') + '\n', encoding='utf-8')
print('texts: 01 §7 finite-runs bullet; 08 §7 measure and counts:', counts[:90], '...; measure; study section', N)
