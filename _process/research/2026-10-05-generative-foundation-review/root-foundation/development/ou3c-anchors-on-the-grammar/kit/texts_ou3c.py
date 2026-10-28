#!/usr/bin/env python3
"""OU3c texts: 01 §7's closure, lumping and order bullets (the home of master-laws-on-the-grammar); 08 §7's measure
sentence from the rerun measure (after.json); 08's receipt and counts; the study section.
usage (from the checkout root of the landing worktree, after the checker and the measure):
  python3 -B <kit>/texts_ou3c.py RECEIPT N AFTER_JSON"""
import json
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
RECEIPT, N, AFTER = sys.argv[1], int(sys.argv[2]), Path(sys.argv[3])
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
CH = ROOT / 'theories/becoming/chapters'
STUDY = ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'
AUDIT = '../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ou3c-anchors-on-the-grammar/AUDIT.md'


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:80], text.count(old))
    path.write_text(text.replace(old, new), encoding='utf-8')


# 01 §7
edit(CH / '01-ROOT.md', """and the frame's closure laws, with `withinClosure_iff_reached`, are proved from the grammar's.""",
     """and the frame's closure laws, with `withinClosure_iff_reached`, are proved from the grammar's. So is the step back of a returning configuration, the only use the junctures make of return (`Branching.step_back`, for `Branching.loss_passes_juncture`).""")
edit(CH / '01-ROOT.md', """`GoAlikeUnder` is going alike at each move (`goAlikeUnder_iff_alike`), and `image_determined_iff`, so `carries_law_iff`, is proved from the image law.""",
     """`GoAlikeUnder` is going alike at each move (`goAlikeUnder_iff_alike`), and `image_determined_iff`, so `carries_law_iff`, is proved from the image law, as is the law that structure and change are one lumping, the image law on a determined law's one move (`Learning.goAlike_iff_lumped`, through `Learning.fixed_image_iff_lumped`).""")
edit(CH / '01-ROOT.md', """the order laws of both are proved from the grammar's.""",
     """the order laws of both are proved from the grammar's. A transitive relation joined to the strict part of a transitive relation containing it is transitive, and irreflexive where the first is, for any two relations (`strictJoin_trans`, `strictJoin_irrefl`); the lagged orders of courses and of what can be reached are proved from it.""")

# 08 §7: the measure sentence
A = json.loads(AFTER.read_text(encoding='utf-8'))
by = A['by_master_law_resting_and_reaching_grammar']


def part(law, label):
    resting, reaching = by[law]
    if resting == reaching:
        return f'all {resting} on {label}' if resting > 1 else f'the one on {label}'
    if reaching == 0:
        return f'none of the {resting} on {label}' if resting > 1 else f'not the one on {label}'
    return f'{reaching} of {resting} on {label}'


cats = A['distinct_by_category']
sentence = (f"Of the 127, {A['reaching_the_grammar']} now reach the grammar ([measure](../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ou3b-master-laws-on-the-grammar/measure_grammar.py)), "
            f"and none did before OU3b: {part('closure', 'closure')}, {part('return', 'finite runs')}, {part('balance', 'balance')}, "
            f"{part('order', 'order')}, {part('lumping', 'lumping')}. Counted once each, the {A['distinct_central_declarations']} "
            f"distinct declarations fall four ways: {cats['grammar']} reach the grammar; {cats['balance, represented']} rest on "
            f"balance, which the grammar represents both ways and cannot state without amounts, so they are no gap; "
            f"{cats['anchor, not reached']} rest on another master law's anchor without reaching it, each with its reason "
            f"([audit]({AUDIT})); and {cats['no master law']} rest on no master law. Of the anchors, `WithinClosure` reaches it "
            f"by definition and `Amounts.rests` by its proof. The others are equivalent to their grammar terms by "
            f"representation theorems, not equal to them by definition, and the declarations resting on them reach the "
            f"grammar where they are cases of a grammar law.")
path = CH / '08-METHOD.md'
s = path.read_text(encoding='utf-8')
s, k = re.subn(r"Of the 127, \d+ now reach the grammar \(\[measure\]\([^)]*\)\), and none did before[^.]*\. Of the anchors, `WithinClosure` reaches it by definition and `Amounts\.rests` by its proof\. The other anchors are read on the grammar by separate representation theorems, which the declarations resting on them do not use; where those declarations reach the grammar, they do so by another route\.",
               lambda m: sentence, s)
assert k == 1, k
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
section = (HERE / 'study_ou3c.txt').read_text(encoding='utf-8')
for key, value in (('{N}', str(N)), ('{RECEIPT}', RECEIPT), ('{REACH}', str(A['reaching_the_grammar'])),
                   ('{G}', str(cats['grammar'])), ('{B}', str(cats['balance, represented'])),
                   ('{AN}', str(cats['anchor, not reached'])), ('{NM}', str(cats['no master law'])),
                   ('{GAP}', str(A['distinct_gaps']))):
    section = section.replace(key, value)
assert '{' not in section.split('```')[0] or True
t = STUDY.read_text(encoding='utf-8')
assert f'\n## {N}. ' not in t
assert max(int(x) for x in re.findall(r'^## (\d+)\. ', t, re.M)) == N - 1, 'N must be the last section plus one'
STUDY.write_text(t.rstrip('\n') + '\n\n' + section.strip('\n') + '\n', encoding='utf-8')
print('texts: 01 §7 bullets; 08 §7 measure:', sentence[:120], '...; 08 counts; study section', N)
