#!/usr/bin/env python3
"""DF1 landing texts after a passing core checker: python3 -B <kit>/land_df1.py PRECEIPT (from the checkout root).

PRECEIPT is the organization-correspondence receipt. Appends the study section (the study's last + 1) with both
receipts, sets that section number in every record's DF history note and in DEFECTS-FOUND's status paragraph, and
brings the RA row's DF cell to what landed and what is left. The board's queue line is the coordinator's."""
import json
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
STUDY = ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'
BOARD = ROOT / '_process/BECOMING-WORKBOARD.md'
RECORDS = ROOT / 'theories/becoming/results/records'
DEFECTS = ROOT / '_process/research/2026-10-05-repository-reconciliation/architecture/DEFECTS-FOUND.md'
PRECEIPT = sys.argv[1]

rid = json.loads((PKG / 'becoming-verification.json').read_text())['utc']
R = json.loads((PKG / 'becoming-checks' / rid / 'verification.json').read_text())
assert R['status'] == 'passed'

st = STUDY.read_text(encoding='utf-8')
N = max(int(m) for m in re.findall(r'^## (\d+)\. ', st, re.M)) + 1
sec = (HERE / 'study_df1.txt').read_text(encoding='utf-8')
sec = sec.replace('## NNN.', f'## {N}.').replace('PRECEIPT', f'`{PRECEIPT}`').replace('RECEIPT', f'`{rid}`')
assert 'NNN' not in sec and 'RECEIPT' not in sec
STUDY.write_text(st.rstrip('\n') + '\n\n' + sec.strip('\n') + '\n', encoding='utf-8')

ids = (HERE / 'changed-ids.txt').read_text(encoding='utf-8').split()
for name in ids:
    p = RECORDS / f'{name}.json'
    t = p.read_text(encoding='utf-8')
    assert t.count('DF_N') == 2, name
    p.write_text(t.replace('DF_N', str(N)), encoding='utf-8')
assert not [p.name for p in RECORDS.glob('*.json') if 'DF_N' in p.read_text(encoding='utf-8')]

t = DEFECTS.read_text(encoding='utf-8')
old = 'landed in its first part, DF1)'
assert t.count(old) == 1
DEFECTS.write_text(t.replace(old, f'landed in its first part, DF1, study §{N})'), encoding='utf-8')

b = BOARD.read_text(encoding='utf-8')
rows = [l for l in b.split('\n') if l.startswith('| **RA: repository architecture**')]
assert len(rows) == 1
row = rows[0]
old = ('**in progress from 25 October 2026 (DF)**: every entry checked against the current records, chapters and Lean; '
       'record wording brought to what the Lean shows, regions corrected, results without a record given one where the '
       'chapter states them; each entry marked with what was done')
assert row.count(old) == 1
new = (f'DF1 landed 26 October 2026 (core receipt `{rid}`, organization correspondence `{PRECEIPT}`, study §{N}): every '
       'entry checked against the current records, chapters and Lean and marked with what became of it; 168 records, '
       'regions, 14 module docstrings, six chapters and the RO kit corrected '
       '([kit](research/2026-10-05-repository-reconciliation/architecture/df/README.md)); **DF2 next** '
       '([left](research/2026-10-05-repository-reconciliation/architecture/df/LEFT.md)): the 33 records still missing, '
       'two statements, schema-2 migrations with laws, two ids in the retired registration sense, a decision entry for '
       "the grammar's readings. For owners: OU3b, likeness as «核» of realizing the same claims (`Becoming.Alike F F s "
       "s' ↔ «核» (moveRel P ()) (claims alike) s s'`); the grammar map, the witness `Map.OnceThenStill`; UE1b, "
       '`SelectionPool.lean` cites `Revision.web_keeps_iff` for `Registration.web_keeps_iff`; Growth, '
       '`Web.grow_widens_unregistered` named in the retired vocabulary (proposed `Web.grow_widens_old_unchanged`)')
BOARD.write_text(b.replace(row, row.replace(old, new)), encoding='utf-8')
print('STUDY_SECTION', N, 'RECEIPT', rid, 'PRECEIPT', PRECEIPT)
