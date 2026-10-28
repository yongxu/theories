#!/usr/bin/env python3
"""OU3e texts: 01 §7's finite-runs bullet says the models' step-indexed laws are proved from the laws of steps counted;
08 §7's measure sentence takes the rerun measure (the three step-indexed rows reaching the grammar, no gap left); 08's
receipt and counts; the study section.
usage (from the checkout root of the landing worktree, after the checker, measure_ou3e.py and the measure):
  python3 -B <kit>/texts_ou3e.py RECEIPT N MEASURE_JSON"""
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
ROWS = ('Becoming.Withholding.withholding_spreads', 'Becoming.Tolerance.answers_restores_iff',
        'Becoming.WithinMoves.after_course')


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:80], text.count(old))
    path.write_text(text.replace(old, new), encoding='utf-8')


# 01 §7
edit(CH / '01-ROOT.md', """Giving that waits on giving has these closed forms for its chains (`Withholding.answers_closed`, `Withholding.waitsAll_closed`); the bridges are a second step.""",
     """Giving that waits on giving has these closed forms, a chain of waits being the grammar's steps (`Withholding.answers_closed`, `Withholding.waitsAll_closed`, through `Withholding.chain_iff_steps`), and a course carries every bound on realizing a bundle together by the composition of within, a trace being the grammar's steps (`WithinMoves.after_course`, through `trace_iff_steps`).""")

# 08 §7: the measure sentence, every number from the rerun measure
A = json.loads(MEASURE.read_text(encoding='utf-8'))
assert A['distinct_gaps'] == 0, A['distinct_gaps']
assert not A.get('pending_derivations'), A.get('pending_derivations')
rows = {r['declaration']: r for r in A['rows']}
assert all(rows[d]['grammar'] for d in ROWS), [d for d in ROWS if not rows[d]['grammar']]
dep = A['distinct_by_dependence']
cat = A['distinct_by_category']
no_law = dep['no master law']
# the three rows rest on no master law's anchor: say so beside the per-law counts
on_no_anchor = sum(1 for d in ROWS if not rows[d]['laws'])
path = CH / '08-METHOD.md'
s = path.read_text(encoding='utf-8')
replacements = [
    (r"Of the 127, \d+ now reach the grammar", f"Of the 127, {A['reaching_the_grammar']} now reach the grammar"),
    (r"fall four ways: \d+ reach the grammar;", f"fall four ways: {dep['grammar']} reach the grammar;"),
    (r"and \d+ rest on no master law\. Each of the \d+ has its reason", f"and {no_law} rest on no master law. Each of the {no_law} has its reason"),
    (r" The other 3 are cases of a master law whose derivation is a named item \(reaching within \*n\* steps, now stated "
     r"on the grammar, their bridges board item OU3e\), and they are the measure's 3 gaps\.",
     " The measure has no gap: every central declaration follows from a master law or has its reason."),
]
if on_no_anchor:
    replacements.append((r"1 of 2 on lumping\.", f"1 of 2 on lumping, and {on_no_anchor} on no anchor, through the laws of steps "
                                                  f"counted."))
for pattern, repl in replacements:
    s, k = re.subn(pattern, repl, s)
    assert k == 1, (pattern[:60], k)
# the reasons' breakdown must add up to the rows on no master law
breakdown = sum(cat[c] for c in ('premise of the account', 'counting identity', 'law of its model', 'single application',
                                 'definitional or representational'))
assert breakdown == no_law, (breakdown, no_law)
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
s = path.read_text(encoding='utf-8')
s, k = re.subn(r"At core receipt \[`[0-9TZ.]+`\]\([^)]*\) \(Lean 4\.29\.1\), the closure held \d+ modules \(\d+ foundation, "
               r"\d+ core, \d+ in the instance and application ring\) and [\d,]+ theorems; the \d+ core modules held [\d,]+ of "
               r"them; [\d,]+ declarations were audited; \d+ generated `injEq` lemmas depend on `propext`; \d+ superseded "
               r"modules were kept out of the run\.", lambda m: counts, s)
assert k == 1, k
path.write_text(s, encoding='utf-8')

# the study section
section = (HERE / 'study_ou3e.txt').read_text(encoding='utf-8')
for key, value in (('{N}', str(N)), ('{RECEIPT}', RECEIPT), ('{REACH}', str(A['reaching_the_grammar'])),
                   ('{G}', str(dep['grammar'])), ('{NM}', str(no_law))):
    section = section.replace(key, value)
assert not re.search(r'\{[A-Z]+\}', section), 'unfilled placeholder'
t = STUDY.read_text(encoding='utf-8')
assert f'\n## {N}. ' not in t
assert max(int(x) for x in re.findall(r'^## (\d+)\. ', t, re.M)) == N - 1, 'N must be the last section plus one'
STUDY.write_text(t.rstrip('\n') + '\n\n' + section.strip('\n') + '\n', encoding='utf-8')
print('texts: 01 §7; 08 §7 measure (no gap) and counts:', counts[:80], '...; study section', N)
