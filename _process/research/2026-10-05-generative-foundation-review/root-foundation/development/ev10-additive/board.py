#!/usr/bin/env python3
"""EV10: the board part of apply_text.py alone, for a rebase that took main's board.
usage (from the checkout root): python3 -B board.py RECEIPT STUDY_SECTION THEOREMS"""
import sys
from pathlib import Path
HERE = Path(__file__).resolve().parent
exec((HERE / 'board_part.py').read_text(), {'ROOT': Path.cwd(), 'BOARD': '_process/BECOMING-WORKBOARD.md',
     'HISTORY': '_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md',
     'RID': 'additive-part-of-offspring-variance', 'receipt_id': sys.argv[1], 'N': int(sys.argv[2]), 'n_thm': int(sys.argv[3])})
