#!/usr/bin/env python3
"""UE25's claim: insert the claim row (claim_row.txt beside this script) after the last UE row of the board, on the
current main. Asserts there is no UE25 row yet and that exactly one line is added.
usage (from the checkout root): python3 -B <kit>/claim_ue25.py"""
from pathlib import Path

ROOT = Path.cwd()
BOARD = ROOT / '_process/BECOMING-WORKBOARD.md'
ROW = (Path(__file__).parent / 'claim_row.txt').read_text(encoding='utf-8').strip('\n')
assert ROW.startswith('| **UE25: ') and ROW.count('\n') == 0 and len(ROW.split(' | ')) == 5, 'the row'
lines = BOARD.read_text(encoding='utf-8').split('\n')
assert not [line for line in lines if line.startswith('| **UE25: ')], 'UE25 is on the board already'
ue = [i for i, line in enumerate(lines) if line.startswith('| **UE') and not line.startswith('| **UE: ')]
assert ue, 'no UE row'
before = len(lines)
lines.insert(ue[-1] + 1, ROW)
assert len(lines) == before + 1
BOARD.write_text('\n'.join(lines), encoding='utf-8')
print('claim: UE25 row inserted after', lines[ue[-1]][:40])
