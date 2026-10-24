#!/usr/bin/env python3
"""IV3g: need in degree, in the texts. THE-STEP-OF-INVARIANCE (two stale markers in §1 removed, a bullet in §4.4, a row
in §8); the study section; D64 item 11; the package README row (EN, ZH). The root module's doc changes with the Lean
(integrate_g.py).
usage (from the checkout root): python3 -B apply_text_g.py STUDY_SECTION RECEIPT"""
import json
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
N, RECEIPT = int(sys.argv[1]), sys.argv[2]
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation/'
STUDY = ROOT / (RF + 'BECOMING-RENEWAL-READING.md')
CHOICES = ROOT / (RF + 'DELEGATED-CHOICES.md')
STEP = ROOT / 'theories/becoming/chapters/THE-STEP-OF-INVARIANCE.md'
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
PENDING = {}


def text(path):
    return PENDING.get(path, path.read_text(encoding='utf-8'))


def insert_after(path, prefix, block):
    lines = text(path).split('\n')
    at = [i for i, line in enumerate(lines) if line.startswith(prefix)]
    assert len(at) == 1, (path.name, prefix[:60], len(at))
    PENDING[path] = '\n'.join(lines[:at[0] + 1] + block + lines[at[0] + 1:])


def replace_once(path, old, new):
    s = text(path)
    assert s.count(old) == 1, (path.name, old[:60], s.count(old))
    PENDING[path] = s.replace(old, new)


# ---- THE-STEP-OF-INVARIANCE ------------------------------------------------------------------------------
replace_once(STEP, '**What the step across standpoints reaches without covering** (new, `Becoming.Weightings`). ',
             '**What the step across standpoints reaches without covering** (`Becoming.Weightings`). ')
replace_once(STEP, "**What a standpoint's own presupposition reaches** (new). ",
             "**What a standpoint's own presupposition reaches.** ")
assert '**Need in degree.**' not in text(STEP)
insert_after(STEP, '- **Need up a hierarchy.**', [
    '- **Need in degree.** A feeder\'s shortfall at a step is what the step demands beyond what the other active '
    'members can give together (`Web.shortfall`). In every possible flow in which the consumer draws past the stock '
    'the feeder gives at least its shortfalls (`Flow.shortfalls_le_given`), and where it can give each, some possible '
    'flow has it give exactly that (`Flow.least_giving`): the least it gives is its degree of need, and need is a '
    'positive degree (`Flow.needs_giver_iff_shortfalls_pos`). With copies of one unit and two against a demand of two, '
    'the user needs the second for one unit a step and the first not at all (`Capacities.second_in_degree`). Drawn '
    'along need, self-concern reaches a feeder in degree: for what the others cannot give, and only for that.',
])
insert_after(STEP, '| Need climbs a hierarchy: drawing past what it holds needs giving into its top |', [
    '| A feeder is needed in degree: the least it gives while the consumer draws past the stock is the sum of its '
    'shortfalls | `Web.shortfall`, `Flow.shortfalls_le_given`, `Flow.least_giving`, '
    '`Flow.needs_giver_iff_shortfalls_pos`, `Capacities.second_in_degree` | `Becoming.Weightings` | landed |',
])

# ---- the study ----------------------------------------------------------------------------------------------
st = text(STUDY)
assert '(IV3g)' not in st
last = max(int(m) for m in re.findall(r'^## (\d+)\. ', st, re.M))
assert N == last + 1, ('section number', N, last)
R = json.loads((PKG / 'becoming-checks' / RECEIPT / 'verification.json').read_text())
assert R['status'] == 'passed'
mod = next(m for m in R['modules'] if m['module'] == 'Becoming.Weightings')
sec = (HERE / 'study_iv3g.txt').read_text(encoding='utf-8')
sec = (sec.replace('## {N}.', f'## {N}.').replace('RECEIPT_ID', RECEIPT)
       .replace('THEOREMS', str(mod['theorems'])).replace('DECLS', str(len(mod['declarations']))))
assert '{N}' not in sec and 'THEOREMS' not in sec and 'DECLS' not in sec
PENDING[STUDY] = st.rstrip('\n') + '\n\n' + sec.rstrip('\n') + '\n'

# ---- D64 ---------------------------------------------------------------------------------------------------
insert_after(CHOICES, '10. **Supply and hierarchy.**', [
    '11. **Need in degree.** A feeder\'s degree of need is read as the least it gives while the consumer draws past '
    'the stock, the sum of what each step demands beyond what the others can give (`Flow.least_giving`). Read with the '
    'grades of IV2, need is the standing, a positive degree (`Flow.needs_giver_iff_shortfalls_pos`), and the degree '
    'is a status the web fixes for each consumer, not one a standpoint sets; units at different steps count alike '
    f'(study section {N}, IV3g).',
])

# ---- the package README row (EN, ZH) ------------------------------------------------------------------------
replace_once(PKG / 'README.md', "`OwnStores`, `TwoTiers`); the readings are the AI's (D59, D60, D64) |",
             '`OwnStores`, `TwoTiers`); a feeder\'s degree of need, the least it gives while the consumer draws past the '
             'stock, is the sum of what each step demands beyond what the others can give (`Flow.least_giving`, '
             '`Capacities.second_in_degree`); the readings are the AI\'s (D59, D60, D64) |')
replace_once(PKG / 'README.zh.md', '`OwnStores`、`TwoTiers`）；读法是 AI 的（D59、D60、D64） |',
             '`OwnStores`、`TwoTiers`）；供给者被需要的程度，即消耗者汲取超出存量时它至少要给的，是每步需求超出其余者合起来能给者之和'
             '（`Flow.least_giving`、`Capacities.second_in_degree`）；读法是 AI 的（D59、D60、D64） |')

for path, s in PENDING.items():
    path.write_text(s, encoding='utf-8')
    print('wrote', path.relative_to(ROOT))
