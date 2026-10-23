#!/usr/bin/env python3
"""IV3d: capacities of giving, read with the web, in the texts. THE-STEP-OF-INVARIANCE (a bullet in §4.4, a sentence
in its empirical paragraph, rows in §8); the study section; D64 item 8; the package README row (EN, ZH). The root
module's doc changes with the Lean, before the checker runs (integrate_d.py).
usage (from the checkout root): python3 -B apply_text_d.py STUDY_SECTION RECEIPT"""
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
assert '**Capacities of giving.**' not in text(STEP)
insert_after(STEP, '- **Which feeders can feed alone, read off a web.** Fix the web', [
    '- **Capacities of giving.** Supply with the web what each formation can give the family at a step, and read '
    'the possible flows off the two (`Flow.FedOnlyWithin`). A step\'s demand is what the family\'s conditions rise, '
    'and one more where none falls (`Web.demand`); every flow with a drawing consumer gives the family at least that '
    '(`Flow.demand_le_replenishment`), and the least flow, with one giver, exactly that '
    '(`Flow.leastDrawn_given_total`). So a member can feed the family alone exactly where, at every step calling for '
    'giving, it is active and its capacity covers the demand (`Flow.feedsAlone_iff`, `Flow.partAlone_within_iff`), '
    'and a feeder is needed wherever, at some step, the others active there could not together give the demand '
    '(`Flow.needs_giver_of_short`). Two copies active throughout, one able to give one unit a step and the other '
    'two, against a demand of two: the user needs the second and not the first (`Capacities.needs_second`, '
    '`Capacities.not_needs_first`); with one unit each, neither can feed alone and the user needs both '
    '(`Capacities.needs_both`). Copies count by capacity, not by number.',
])
replace_once(STEP, 'and several conditions they all need have no second copy. If so,',
             'and several conditions they all need have no second copy, or none that with the rest could give what '
             'they draw: copies count by capacity, not by number (`Flow.needs_giver_of_short`, '
             '`Capacities.needs_both`). If so,')
insert_after(STEP, '| A feeder is needed exactly where, at some step calling for giving, it is the only one active |', [
    '| A step\'s demand: every flow with a drawing consumer gives the family at least it, and the least flow exactly '
    'it | `Web.demand`, `Web.callsForGiving_iff_demand_pos`, `Flow.demand_le_replenishment`, `Flow.leastDrawn`, '
    '`Flow.leastDrawn_given_total` | `Becoming.Weightings` | landed |',
    '| With capacities, a member can feed the family alone exactly where its capacity covers the demand at every step '
    'calling for giving; the copies law with capacities | `Flow.FedOnlyWithin`, `Web.CanFeedAlone`, '
    '`Flow.feedsAlone_iff`, `Flow.partAlone_within_iff`, `Flow.needs_giver_iff_only_within` | `Becoming.Weightings` '
    '| landed |',
    '| A feeder is needed where the others active at some step could not together give the demand; copies count by '
    'capacity | `Flow.needs_giver_of_short`, `Capacities.needs_second`, `Capacities.not_needs_first`, '
    '`Capacities.needs_both` | `Becoming.Weightings` | landed |',
])

# ---- the study ----------------------------------------------------------------------------------------------
st = text(STUDY)
assert '(IV3d)' not in st
last = max(int(m) for m in re.findall(r'^## (\d+)\. ', st, re.M))
assert N == last + 1, ('section number', N, last)
R = json.loads((PKG / 'becoming-checks' / RECEIPT / 'verification.json').read_text())
assert R['status'] == 'passed'
mod = next(m for m in R['modules'] if m['module'] == 'Becoming.Weightings')
sec = (HERE / 'study_iv3d.txt').read_text(encoding='utf-8')
sec = (sec.replace('## {N}.', f'## {N}.').replace('RECEIPT_ID', RECEIPT)
       .replace('THEOREMS', str(mod['theorems'])).replace('DECLS', str(len(mod['declarations']))))
assert '{N}' not in sec and 'THEOREMS' not in sec and 'DECLS' not in sec
PENDING[STUDY] = st.rstrip('\n') + '\n\n' + sec.rstrip('\n') + '\n'

# ---- D64 ---------------------------------------------------------------------------------------------------
insert_after(CHOICES, '7. **The flows read off a web.**', [
    '8. **Capacities of giving.** What a formation can give the family at a step is read as a capacity supplied '
    'with the web, the base web having none (`Flow.FedOnlyWithin`); a step\'s demand as what the family\'s conditions '
    'rise and one more where none falls, the least giving of any flow with a drawing consumer (`Web.demand`, '
    '`Flow.demand_le_replenishment`); being able to feed the family alone as being active with a capacity covering '
    'the demand at every step calling for giving (`Flow.feedsAlone_iff`); and copies as counted by capacity, not by '
    'number: a feeder is needed wherever the others could not together give the demand '
    f'(`Flow.needs_giver_of_short`, `Capacities.needs_both`; study section {N}, IV3d).',
])

# ---- the package README row (EN, ZH) ------------------------------------------------------------------------
replace_once(PKG / 'README.md', "; the readings are the AI's (D59, D60, D64) |",
             '; with capacities of giving supplied with the web, a feeder can feed a family alone exactly where its '
             'capacity covers each step\'s demand, and it is needed wherever the others could not together give the '
             'demand (`Web.demand`, `Flow.feedsAlone_iff`, `Flow.needs_giver_of_short`, `Capacities.needs_both`); '
             'the readings are the AI\'s (D59, D60, D64) |')
replace_once(PKG / 'README.zh.md', '；读法是 AI 的（D59、D60、D64） |',
             '；以随依存网给定的给予容量，供给者恰在其容量覆盖每个需要给予之步的需求时能单独供给该族，而凡其余者合起来给不出该需求之处，'
             '它都被需要（`Web.demand`、`Flow.feedsAlone_iff`、`Flow.needs_giver_of_short`、`Capacities.needs_both`）；'
             '读法是 AI 的（D59、D60、D64） |')

for path, s in PENDING.items():
    path.write_text(s, encoding='utf-8')
    print('wrote', path.relative_to(ROOT))
