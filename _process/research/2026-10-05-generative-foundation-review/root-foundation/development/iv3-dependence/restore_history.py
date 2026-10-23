#!/usr/bin/env python3
"""Repair the workboard history file. The XL4 landing (6c07c37e9) wrote only its own row to
_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md, replacing the 635 lines it held at
c31156426 (the verbatim board of 17 October and every landed row since); the FC1 landing (14f083da0) then appended its
row. This restores the file from c31156426 and puts the rows written since (XL4, FC1), unchanged and in their order,
after the last landed row, where the landing scripts insert rows (before '## Lapsed claims (18 October 2026)').
Nothing is dropped: the restored bytes are git's, and the rows are copied from the current file.
usage (from the checkout root): python3 -B restore_history.py"""
import subprocess
from pathlib import Path

ROOT = Path.cwd()
REL = '_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md'
GOOD = 'c31156426'
current = (ROOT / REL).read_text(encoding='utf-8').split('\n')
rows = [line for line in current if line.strip()]
assert len(rows) == 2 and all(r.startswith('| **') for r in rows), rows
assert rows[0].startswith('| **XL4:') and rows[1].startswith('| **FC1:'), [r[:20] for r in rows]
good = subprocess.run(['git', 'show', f'{GOOD}:{REL}'], capture_output=True, text=True, check=True).stdout.split('\n')
assert len(good) > 600, len(good)
for r in rows:
    assert r not in good, r[:40]
lapsed = good.index('## Lapsed claims (18 October 2026)')
end = lapsed - 1
while not good[end].startswith('| '):
    end -= 1
restored = good[:end + 1] + rows + good[end + 1:]
(ROOT / REL).write_text('\n'.join(restored), encoding='utf-8')
print('restored', len(good), 'lines from', GOOD, 'with', len(rows), 'rows kept:', len(restored), 'lines')
