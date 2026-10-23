#!/usr/bin/env python3
"""IV3i: need in degree with capacities read off the stores, in the texts. THE-STEP-OF-INVARIANCE (a sentence in the
§4.4 degree bullet, a row in §8); the study section; D64 item 11; the package README row (EN, ZH).
usage (from the checkout root): python3 -B apply_text_i.py STUDY_SECTION RECEIPT"""
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
    assert s.count(old) == 1, (path.name, old[:70], s.count(old))
    PENDING[path] = s.replace(old, new)


replace_once(STEP, "With copies of one unit and two against a demand of two, the user needs the second for one unit a step "
             "and the first not at all (`Capacities.second_in_degree`).",
             "With copies of one unit and two against a demand of two, the user needs the second for one unit a step "
             "and the first not at all (`Capacities.second_in_degree`). The same holds with capacities read off the "
             "feeders' own stores (`Flow.least_giving_from_stores`; in `OwnStores` the first feeder is needed in degree "
             "two, `OwnStores.first_in_degree`).")
insert_after(STEP, "| Some flow lets the consumer draw past the stock exactly where the class can give each step's demand", [
    '| Need in degree with capacities read off the stores | `Flow.gradedStoreDrawn`, '
    '`Flow.gradedStoreDrawn_fedFromStores`, `Flow.least_giving_from_stores`, `OwnStores.first_in_degree` | '
    '`Becoming.Weightings` | landed |',
])
replace_once(CHOICES, "wherever some flow lets the consumer draw past it (`Flow.least_giving_of_possible`).",
             "wherever some flow lets the consumer draw past it (`Flow.least_giving_of_possible`), and with capacities read "
             f"off the feeders' own stores alike (`Flow.least_giving_from_stores`; study section {N}, IV3i).")
replace_once(PKG / 'README.md', "`Flow.least_giving_of_possible`, `Capacities.second_in_degree`); the readings are the AI's",
             "`Flow.least_giving_of_possible`, `Capacities.second_in_degree`), with capacities read off the stores alike "
             "(`Flow.least_giving_from_stores`, `OwnStores.first_in_degree`); the readings are the AI's")
replace_once(PKG / 'README.zh.md', "`Flow.least_giving_of_possible`、`Capacities.second_in_degree`）；读法是 AI 的",
             "`Flow.least_giving_of_possible`、`Capacities.second_in_degree`），以从库存读出的容量亦然"
             "（`Flow.least_giving_from_stores`、`OwnStores.first_in_degree`）；读法是 AI 的")

st = text(STUDY)
assert '(IV3i)' not in st
last = max(int(m) for m in re.findall(r'^## (\d+)\. ', st, re.M))
assert N == last + 1, ('section number', N, last)
R = json.loads((PKG / 'becoming-checks' / RECEIPT / 'verification.json').read_text())
assert R['status'] == 'passed'
mod = next(m for m in R['modules'] if m['module'] == 'Becoming.Weightings')
sec = (HERE / 'study_iv3i.txt').read_text(encoding='utf-8')
sec = (sec.replace('## {N}.', f'## {N}.').replace('RECEIPT_ID', RECEIPT)
       .replace('THEOREMS', str(mod['theorems'])).replace('DECLS', str(len(mod['declarations']))))
assert '{N}' not in sec and 'THEOREMS' not in sec and 'DECLS' not in sec
PENDING[STUDY] = st.rstrip('\n') + '\n\n' + sec.rstrip('\n') + '\n'

for path, s in PENDING.items():
    path.write_text(s, encoding='utf-8')
    print('wrote', path.relative_to(ROOT))
