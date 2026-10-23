#!/usr/bin/env python3
"""IV3f: what a feeder can give, read off its own supply, and need up a hierarchy, in the texts.
THE-STEP-OF-INVARIANCE (two bullets in §4.4, a sentence in its empirical paragraph, rows in §8); the study section;
D64 item 10; the package README row (EN, ZH). The root module's doc changes with the Lean (integrate_f.py).
usage (from the checkout root): python3 -B apply_text_f.py STUDY_SECTION RECEIPT"""
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
assert '**Need up a hierarchy.**' not in text(STEP)
insert_after(STEP, '- **Need with capacities, exactly.**', [
    '- **What a feeder can give, read off its own supply.** A feeder gives what it takes from its own supply '
    '(`Flow.PassesOn`): what a family is given is then at most what is taken from the supply, and a supply that '
    'nothing feeds passes on at most what it loses, an exhausted one nothing (`Flow.passed_le_drop`, '
    '`Flow.passed_zero_of_exhausted`). With each feeder drawing on its own store, its capacity at a step is what '
    'the store falls, read off the web (`Web.storeFall`, `Flow.fedFromStores_within`), and the exact law of need '
    'holds with it (`Flow.needs_giver_iff_store_short`). A feeder whose store runs out is no copy from then on '
    '(`OwnStores.second_spent`, `OwnStores.needs_first`).',
    '- **Need up a hierarchy.** Where each family of a hierarchy is given only what is passed on from the family '
    'above it, what is drawn from the bottom is at most what the whole hierarchy held and what its top was given '
    '(`Flow.uptake_le_tiers`); so drawing past what the whole hierarchy holds needs giving into its top '
    '(`Flow.needsSome_tiers`; in `TwoTiers` a user needs the giving of its feeder\'s source, `TwoTiers.needs_source`). '
    'Drawn along need, self-concern reaches what feeds its feeders, up to what feeds the top of every hierarchy it '
    'draws past.',
])
replace_once(STEP, 'has one scope there, whoever holds it. ',
             'has one scope there, whoever holds it. Nor does it stop at the conditions people draw on directly: what '
             'feeds those, up to whatever enters at the top of a hierarchy they draw past, is reached too '
             '(`Flow.needsSome_tiers`). ')
insert_after(STEP, '| A feeder is needed exactly where the others could not together give the demand; three copies of one '
             'unit against a demand of two, none needed |', [
    '| What a family is given, passed on from a supply, is bounded by the supply; an exhausted supply that nothing '
    'feeds passes on nothing | `Flow.PassesOn`, `Flow.replenishment_le_uptake`, `Flow.passed_le_supply`, '
    '`Flow.passed_le_drop`, `Flow.passed_zero_of_exhausted` | `Becoming.Weightings` | landed |',
    '| A feeder\'s capacity read off its own store; the exact law of need with it | `Web.storeFall`, '
    '`Flow.FedFromStores`, `Flow.fedFromStores_within`, `Flow.storeDrawn`, `Flow.needs_giver_iff_store_short`, '
    '`OwnStores.needs_first`, `OwnStores.not_needs_second` | `Becoming.Weightings` | landed |',
    '| Need climbs a hierarchy: drawing past what it holds needs giving into its top | `Flow.uptake_le_tiers`, '
    '`Flow.FedThroughTiers`, `Flow.needsSome_tiers`, `TwoTiers.needs_source` | `Becoming.Weightings` | landed |',
])

# ---- the study ----------------------------------------------------------------------------------------------
st = text(STUDY)
assert '(IV3f)' not in st
last = max(int(m) for m in re.findall(r'^## (\d+)\. ', st, re.M))
assert N == last + 1, ('section number', N, last)
R = json.loads((PKG / 'becoming-checks' / RECEIPT / 'verification.json').read_text())
assert R['status'] == 'passed'
mod = next(m for m in R['modules'] if m['module'] == 'Becoming.Weightings')
sec = (HERE / 'study_iv3f.txt').read_text(encoding='utf-8')
sec = (sec.replace('## {N}.', f'## {N}.').replace('RECEIPT_ID', RECEIPT)
       .replace('THEOREMS', str(mod['theorems'])).replace('DECLS', str(len(mod['declarations']))))
assert '{N}' not in sec and 'THEOREMS' not in sec and 'DECLS' not in sec
PENDING[STUDY] = st.rstrip('\n') + '\n\n' + sec.rstrip('\n') + '\n'

# ---- D64 ---------------------------------------------------------------------------------------------------
insert_after(CHOICES, '9. **Giving shared.**', [
    '10. **Supply and hierarchy.** A feeder\'s capacity is read as what its own supply passes on: what it gives a '
    'family it takes from what it holds (`Flow.PassesOn`), and from a store that nothing feeds it can take at a step '
    'what the store falls (`Web.storeFall`, `Flow.fedFromStores_within`). A hierarchy is read as families each given '
    'only what is passed on from the one above, so that nothing enters it below its top (`Flow.PassesTiers`). Ren\'s '
    '"If a life does not have its outside, does not have its environment, then this life will not last" '
    '([source](../../../../sources/15-codex-theory-conversations/2026-10-23-one-system.md)) is read as '
    '`Flow.needsSome_tiers`: drawing past what a whole hierarchy holds needs giving into its top. The reading takes '
    f'the supply side of his "hierarchy", not its emergence (study section {N}, IV3f).',
])

# ---- the package README row (EN, ZH) ------------------------------------------------------------------------
replace_once(PKG / 'README.md',
             "`Capacities.needs_both`, `SharedCopies.none_needed`); the readings are the AI's (D59, D60, D64) |",
             '`Capacities.needs_both`, `SharedCopies.none_needed`); read off a feeder\'s own store, its capacity at a '
             'step is what the store falls, and the exact law holds with it, while drawing past what a whole hierarchy '
             'of supplies holds needs giving into its top (`Flow.needs_giver_iff_store_short`, `Flow.needsSome_tiers`, '
             '`OwnStores`, `TwoTiers`); the readings are the AI\'s (D59, D60, D64) |')
replace_once(PKG / 'README.zh.md',
             '`Capacities.needs_both`、`SharedCopies.none_needed`）；读法是 AI 的（D59、D60、D64） |',
             '`Capacities.needs_both`、`SharedCopies.none_needed`）；从供给者自身的库存读出，其某步的容量就是库存的下降量，精确之律'
             '对它成立；而汲取超出整个供给层级所持有者，需要向其顶层的给予（`Flow.needs_giver_iff_store_short`、'
             '`Flow.needsSome_tiers`、`OwnStores`、`TwoTiers`）；读法是 AI 的（D59、D60、D64） |')

for path, s in PENDING.items():
    path.write_text(s, encoding='utf-8')
    print('wrote', path.relative_to(ROOT))
