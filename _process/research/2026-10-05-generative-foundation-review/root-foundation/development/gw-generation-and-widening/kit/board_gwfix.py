#!/usr/bin/env python3
"""GW's text fixes (after item 13's fourth review): the board's Queue line.
  claim   prepend the head clause (run in a temporary worktree at main, then fast-forward the shared checkout)
  landed  replace the head clause with the landed clause, carrying the coordinator's order after it, and drop the
          earlier clauses' order sentences, which it supersedes (each printed for review)
usage (from the checkout root): python3 -B <kit>/board_gwfix.py claim|landed"""
import re
import sys
from pathlib import Path

MODE = sys.argv[1]
assert MODE in ('claim', 'landed')
board = Path('_process/BECOMING-WORKBOARD.md')
text = board.read_text(encoding='utf-8')
q = [l for l in text.split('\n') if l.startswith('- **Queue:** ')]
assert len(q) == 1
line = q[0]
WHAT = ("07 §2's reading and theorem worded to their laws, the two-grains record's law 8 brought into line with law 6 "
        "with a history note, the Chinese overview and both one pages following GW's English, and 02's coverage theorem "
        "labelled as holding a witness")
HEAD = (f"GW's text fixes at the head of the queue (landing now: docs and one record, no Lean and no core run: {WHAT}; "
        'then render, strict check, links and tests, then the fast-forward); ')
if MODE == 'claim':
    new = '- **Queue:** ' + HEAD + line[len('- **Queue:** '):]
else:
    assert line.startswith('- **Queue:** ' + HEAD), 'head clause'
    rest = line[len('- **Queue:** ' + HEAD):]
    for s in re.findall(r"\)\. Then, in the coordinator's order: [^;]*; ask the coordinator for a slot[;.] ", rest):
        print('dropped an earlier order sentence:', s)
        rest = rest.replace(s, '); ', 1)
    landed = (f"GW's text fixes landed (docs and one record only, no Lean and no core run, after item 13's fourth review: "
              f"{WHAT}; item 13 carries 01 §6's one word; no record re-pointed; render, strict check, links and tests "
              "pass). Then, in the coordinator's order: item 13 with LW's follow-up, RV21b, AJ6b, MV, fm-cond1, "
              "LA4's formal part, MA4c; ask the coordinator for a slot. ")
    new = '- **Queue:** ' + landed + rest
text = text.replace(line, new)
board.write_text(text, encoding='utf-8')
print(MODE, 'written')
