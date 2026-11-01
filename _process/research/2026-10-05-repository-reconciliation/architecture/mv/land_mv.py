#!/usr/bin/env python3
"""MV landing texts: python3 -B <kit>/land_mv.py (from the checkout root, after the generator has run on the merged
sources), then make research-render.

Appends the study section (the study's last + 1) with the core receipt the data was computed on; puts MV's landed
entry in place of its claim on the board's queue line and its outcome in the RA row."""
import json
import re
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
STUDY = ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'
BOARD = ROOT / '_process/BECOMING-WORKBOARD.md'
DATA = json.loads((ROOT / 'theories/becoming/results/data/shared-laws.json').read_text())
assert not DATA.get('from_dump'), 'the landing data must be computed on the checked sources, not a saved dump'

st = STUDY.read_text(encoding='utf-8')
N = max(int(m) for m in re.findall(r'^## (\d+)\. ', st, re.M)) + 1
sec = (HERE / 'study_mv.txt').read_text(encoding='utf-8').replace('## NNN.', f'## {N}.').replace('CRECEIPT', f'`{DATA["core_receipt"]}`')
assert 'NNN' not in sec and 'CRECEIPT' not in sec
c = DATA['counts']
for figure in (f'{c["laws"]:,} laws', f'{c["grammar"]} reach the grammar', f'{c["no master law"]:,} have no'):
    assert figure in ' '.join(sec.split()), ('the study section\'s figures differ from the data; update study_mv.txt', figure)
STUDY.write_text(st.rstrip('\n') + '\n\n' + sec.strip('\n') + '\n', encoding='utf-8')

b = BOARD.read_text(encoding='utf-8')
claim = re.findall(r'MV holds the head of the queue \([^)]*\); ', b)
assert len(claim) == 1, claim
b = b.replace(claim[0], (f'MV landed (the master laws under each law of a record, computed from the Lean dependencies of its declarations '
                         f'by tools/research/shared_laws.py reading the measure, unchanged; data/shared-laws.json on core receipt '
                         f'`{DATA["core_receipt"]}`; the check reports when it goes stale; tooling only, no Lean; study §{N}); '))
old = re.findall(r"\*\*MV claimed\*\* \(29 October 2026, on Ren's yes\): .*?tooling only, no Lean\.", b)
assert len(old) == 1, old
b = b.replace(old[0], (f"MV landed 29 October 2026 (study §{N}, [kit](research/2026-10-05-repository-reconciliation/architecture/mv/README.md)): "
                       f"under each law of a record, the master laws its declarations rest on by Lean dependency, computed from the "
                       f"measure, unchanged, and the checker cache; landers rerun `tools/research/shared_laws.py` after a core landing "
                       f"that changes dependencies, and the check's `master_laws` entry says when it is stale."))
BOARD.write_text(b, encoding='utf-8')
print('STUDY_SECTION', N)
