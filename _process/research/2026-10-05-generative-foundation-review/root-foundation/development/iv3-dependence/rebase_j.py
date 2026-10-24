#!/usr/bin/env python3
"""IV3j, after GS1 landed first: the study section becomes the next number after GS1's, and the receipt is the run on
the merged tree. Appends the study section (from study_iv3j.txt), moves D64 item 13's study reference, and moves the
record self-concern-through-dependence from the first IV3j receipt to the merged one (same Weightings source).
usage (from the checkout root, mid-merge, after the checker): python3 -B rebase_j.py OLD_RECEIPT NEW_RECEIPT"""
import datetime
import hashlib
import json
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
OLD, NEW = sys.argv[1], sys.argv[2]
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation/'
STUDY = ROOT / (RF + 'BECOMING-RENEWAL-READING.md')
CHOICES = ROOT / (RF + 'DELEGATED-CHOICES.md')
SOURCE = f'{PKG}/Becoming/Weightings.lean'
R = json.loads((ROOT / PKG / 'becoming-checks' / NEW / 'verification.json').read_text())
assert R['status'] == 'passed'
mod = next(m for m in R['modules'] if m['module'] == 'Becoming.Weightings')
assert not any(mod['axiom_dependencies'].values())
assert R['source_sha256']['Becoming.Weightings'] == hashlib.sha256((ROOT / SOURCE).read_bytes()).hexdigest()

st = STUDY.read_text(encoding='utf-8')
assert '(IV3j)' not in st
last = max(int(m) for m in re.findall(r'^## (\d+)\. ', st, re.M))
N = last + 1
sec = (HERE / 'study_iv3j.txt').read_text(encoding='utf-8')
sec = (sec.replace('## {N}.', f'## {N}.').replace('RECEIPT_ID', NEW)
       .replace('THEOREMS', str(mod['theorems'])).replace('DECLS', str(len(mod['declarations']))))
STUDY.write_text(st.rstrip('\n') + '\n\n' + sec.rstrip('\n') + '\n', encoding='utf-8')

ch = CHOICES.read_text(encoding='utf-8')
assert ch.count('(study section 390, IV3j)') == 1
CHOICES.write_text(ch.replace('(study section 390, IV3j)', f'(study section {N}, IV3j)'), encoding='utf-8')

path = ROOT / 'theories/becoming/results/records/self-concern-through-dependence.json'
text = path.read_text(encoding='utf-8')
for a, b in [(OLD, NEW), ('study sections 373, 378, 382 to 386, 388 and 390', f'study sections 373, 378, 382 to 386, 388 and {N}'),
             ('388 与 390 节', f'388 与 {N} 节'), ('study section 390.', f'study section {N}.'), ('研究第 390 节', f'研究第 {N} 节')]:
    assert a in text, a
    text = text.replace(a, b)
d = json.loads(text)
receipt = f'{PKG}/becoming-checks/{NEW}/verification.json'
for ref in d['references']:
    if ref['role'] == 'receipt':
        assert ref['path'] == receipt
        ref['sha256'] = hashlib.sha256((ROOT / receipt).read_bytes()).hexdigest()
d['reviewed_at_utc'] = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
path.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('study section', N, '; receipt', NEW)
