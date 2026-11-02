#!/usr/bin/env python3
"""ND2's claim row on the board (board_nd_final.py's pattern), in a worktree detached at main: one row after the last
open row, before nothing else changes. usage (from the checkout root): python3 -B claim_nd_anchor.py"""
from pathlib import Path

BOARD = Path('_process/BECOMING-WORKBOARD.md')
TITLE = '| **ND2: the home anchor of shared-laws-on-the-grammar**'
ROW = (TITLE + " (ND's final stage, §495, renamed the record id by research.py rename-id, which leaves anchors alone: "
       "01 §7, the record's home section, kept only `r-master-laws-on-the-grammar`, where every other renamed record's "
       "home anchor is at its id). `<a id=\"r-shared-laws-on-the-grammar\"></a>` beside the old anchor, which stays "
       "for the records, the map and the links in history and branches that cite it; 01's three links and 08 §7's one "
       "read the new anchor; the theory graph follows; a line in study §495. Documents only: no Lean, no record and "
       "no core run; no record drifts, since section hashes leave anchors and link targets out"
       " | Claude Code desktop session (master laws and dualist names, ND's owner), 1 November 2026"
       " | claimed 1 November 2026; ready on branch `nd-anchor`, render, strict check, links, the 305 tests and both "
       "dossier checks passing on `6cb16bbce`; its slot from the coordinator, after EL6 and AJ4's map"
       " | `development/nd-nondual-names/final/`; at landing `theories/becoming/chapters/01-ROOT.md`, "
       "`theories/becoming/chapters/08-METHOD.md`"
       " | needs: nothing open → feeds: AJ4's map's link to the closure law |")
lines = BOARD.read_text(encoding='utf-8').split('\n')
assert not any(l.startswith(TITLE) for l in lines), 'ND2 already claimed'
rows = [k for k, l in enumerate(lines) if l.startswith('| **')]
k = rows[-1]
lines.insert(k + 1, ROW)
BOARD.write_text('\n'.join(lines), encoding='utf-8')
print(f'claimed: row after board line {k + 1}')
