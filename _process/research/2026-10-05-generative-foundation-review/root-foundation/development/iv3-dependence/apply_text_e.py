#!/usr/bin/env python3
"""IV3e: need with capacities, exact, in the texts. THE-STEP-OF-INVARIANCE (a bullet in §4.4, the citation of its
empirical paragraph, rows in §8); the study section; D64 item 9; the package README row (EN, ZH). The root module's doc
changes with the Lean, before the checker runs (integrate_e.py).
usage (from the checkout root): python3 -B apply_text_e.py STUDY_SECTION RECEIPT"""
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
assert '**Need with capacities, exactly.**' not in text(STEP)
insert_after(STEP, '- **Capacities of giving.** Supply with the web what each formation can give the family at a step', [
    '- **Need with capacities, exactly.** Where the other members active at a step can together give its demand, '
    'they can share the giving within their capacities: pair, in order, the units each condition is to be given '
    'with the units they can give (`Web.shares`), and the flow in which each gives as it is paired balances, with '
    'the consumer drawing past the stock and the feeder in question never giving (`Flow.sharedDrawn`). So a consumer '
    'needs a feeder\'s giving exactly where, at some step, the others could not together give the demand '
    '(`Flow.needs_giver_iff_short`). Three copies of one unit each, against a demand of two: none can feed alone, '
    'the user needs some copy\'s giving, and no copy\'s (`SharedCopies.none_needed`). Redundancy is what the others '
    'can give together.',
])
replace_once(STEP, 'copies count by capacity, not by number (`Flow.needs_giver_of_short`, `Capacities.needs_both`). If so,',
             'copies count by capacity, not by number (`Flow.needs_giver_iff_short`, `Capacities.needs_both`, '
             '`SharedCopies.none_needed`). If so,')
insert_after(STEP, '| A feeder is needed where the others active at some step could not together give the demand; copies count by '
             'capacity |', [
    '| Giving shared within capacities: the shares and the shared flow | `Web.shares`, `unitsOf`, `pairUp`, '
    '`Flow.sharedDrawn`, `Flow.sharedDrawn_given_members`, `Flow.sharedDrawn_fedOnlyWithin` | `Becoming.Weightings` | '
    'landed |',
    '| A feeder is needed exactly where the others could not together give the demand; three copies of one unit '
    'against a demand of two, none needed | `Flow.needs_giver_iff_short`, `Web.capacityWithout`, '
    '`SharedCopies.none_needed`, `SharedCopies.needs_some` | `Becoming.Weightings` | landed |',
])

# ---- the study ----------------------------------------------------------------------------------------------
st = text(STUDY)
assert '(IV3e)' not in st
last = max(int(m) for m in re.findall(r'^## (\d+)\. ', st, re.M))
assert N == last + 1, ('section number', N, last)
R = json.loads((PKG / 'becoming-checks' / RECEIPT / 'verification.json').read_text())
assert R['status'] == 'passed'
mod = next(m for m in R['modules'] if m['module'] == 'Becoming.Weightings')
sec = (HERE / 'study_iv3e.txt').read_text(encoding='utf-8')
sec = (sec.replace('## {N}.', f'## {N}.').replace('RECEIPT_ID', RECEIPT)
       .replace('THEOREMS', str(mod['theorems'])).replace('DECLS', str(len(mod['declarations']))))
assert '{N}' not in sec and 'THEOREMS' not in sec and 'DECLS' not in sec
PENDING[STUDY] = st.rstrip('\n') + '\n\n' + sec.rstrip('\n') + '\n'

# ---- D64 ---------------------------------------------------------------------------------------------------
insert_after(CHOICES, '8. **Capacities of giving.**', [
    '9. **Giving shared.** Where several members give together, the giving is divided by pairing, in order, the '
    'units each condition is to be given with the units the members can give (`Web.shares`, `Flow.sharedDrawn`); any '
    'division that gives each condition its part within the capacities would serve, and the law does not depend on '
    'the order. With it the clause of item 8 is exact: a feeder is needed exactly where the others could not together '
    f'give the demand (`Flow.needs_giver_iff_short`, `SharedCopies.none_needed`; study section {N}, IV3e).',
])

# ---- the package README row (EN, ZH) ------------------------------------------------------------------------
replace_once(PKG / 'README.md',
             'and it is needed wherever the others could not together give the demand (`Web.demand`, `Flow.feedsAlone_iff`, '
             '`Flow.needs_giver_of_short`, `Capacities.needs_both`)',
             'and it is needed exactly where the others could not together give the demand, since otherwise they can share '
             'the giving (`Web.demand`, `Flow.feedsAlone_iff`, `Flow.needs_giver_iff_short`, `Flow.sharedDrawn`, '
             '`Capacities.needs_both`, `SharedCopies.none_needed`)')
replace_once(PKG / 'README.zh.md',
             '而凡其余者合起来给不出该需求之处，它都被需要（`Web.demand`、`Flow.feedsAlone_iff`、`Flow.needs_giver_of_short`、'
             '`Capacities.needs_both`）',
             '而它恰在其余者合起来给不出该需求之处被需要，否则其余者可以分担给予（`Web.demand`、`Flow.feedsAlone_iff`、'
             '`Flow.needs_giver_iff_short`、`Flow.sharedDrawn`、`Capacities.needs_both`、`SharedCopies.none_needed`）')

for path, s in PENDING.items():
    path.write_text(s, encoding='utf-8')
    print('wrote', path.relative_to(ROOT))
