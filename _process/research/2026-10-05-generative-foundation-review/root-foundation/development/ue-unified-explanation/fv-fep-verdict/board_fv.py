#!/usr/bin/env python3
"""FV, where the free-energy principle stands in 08's verdict (board_t2s.py's pattern): documents only, no Lean, no core
run. FV was claimed by a board-only commit (14b0276fb).

head:  put the clause "FV at the head of the queue (...); " at the front of the Queue line.
land:  drop the head clause and put the landed clause first (landed.txt), move FV's row off the open claims into the
       history file's landed rows (history.txt), and add the batched precision pass's entry (batched.txt).
usage (from the checkout root): python3 -B board_fv.py head | land"""
import re
import sys
from pathlib import Path

BOARD = Path('_process/BECOMING-WORKBOARD.md')

NAME = 'FV'
STATE_CLAIMED = re.compile(r"\| claimed 2026-11-04 on `[0-9a-f]{9}`; documents only: no Lean, no record, no core run; "
                           r"lands after T2S \|")
HEAD_TEXT = ("landing now, by readiness: documents only, no Lean, no record and no core run: where the free-energy "
             "principle stands in 08's verdict, both sides in its page's words, S-02 following and the page's own list "
             "of what the theory does not state made exact; the records the change drifts re-pointed after reading; "
             "render, strict check, links, tests and both dossier checks, then the fast-forward")
HEAD = re.compile(re.escape(NAME) + r' at the head of the queue \([^()]*\); ')


def lines_of():
    return BOARD.read_text(encoding='utf-8').split('\n')


def queue_line(lines):
    at = [i for i, line in enumerate(lines) if line.startswith('- **Queue:** ')]
    assert len(at) == 1, at
    return at[0]


def head():
    lines = lines_of()
    q = queue_line(lines)
    assert '(landing now' not in lines[q], 'another clause holds the head: ' + lines[q][:200]
    clause = f'{NAME} at the head of the queue ({HEAD_TEXT}); '
    assert HEAD.fullmatch(clause), clause
    lines[q] = lines[q].replace('- **Queue:** ', '- **Queue:** ' + clause, 1)
    BOARD.write_text('\n'.join(lines), encoding='utf-8')
    print('head: clause written')


HISTORY = Path('_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md')
HERE = Path(__file__).resolve().parent


def land():
    landed, history, batched = (HERE.joinpath(name).read_text(encoding='utf-8').strip() for name in
                                ('landed.txt', 'history.txt', 'batched.txt'))
    for mark in ('FIGURES', 'TODO'):
        assert mark not in landed + history + batched, mark
    lines = lines_of()
    q = queue_line(lines)
    assert len(HEAD.findall(lines[q])) == 1 and lines[q].startswith('- **Queue:** ' + NAME + ' at the head'), 'not at the head'
    lines[q] = HEAD.sub('', lines[q], count=1)
    lines[q] = lines[q].replace('- **Queue:** ', '- **Queue:** ' + landed + ' ', 1)
    at = [i for i, line in enumerate(lines) if line.startswith('| **FV: ')]
    assert len(at) == 1 and STATE_CLAIMED.search(lines[at[0]]), at
    del lines[at[0]]
    top = [i for i, line in enumerate(lines) if line.startswith('## Batched precision pass')]
    nxt = [i for i, line in enumerate(lines) if line.startswith('## Decisions pending Ren')]
    assert len(top) == 1 and len(nxt) == 1 and top[0] < nxt[0], (top, nxt)
    last = max(i for i in range(top[0], nxt[0]) if lines[i].startswith('- **'))
    lines[last + 1:last + 1] = batched.split('\n')
    BOARD.write_text('\n'.join(lines), encoding='utf-8')
    h = HISTORY.read_text(encoding='utf-8').split('\n')
    lapsed = [i for i, line in enumerate(h) if line.startswith('## Lapsed claims')]
    assert len(lapsed) == 1 and h[lapsed[0] - 1] == '' and h[lapsed[0] - 2].startswith('| **'), lapsed
    h.insert(lapsed[0] - 1, history)
    HISTORY.write_text('\n'.join(h), encoding='utf-8')
    print('land: clause, history row and batched entry written')


if __name__ == '__main__':
    if len(sys.argv) == 2 and sys.argv[1] in ('head', 'land'):
        {'head': head, 'land': land}[sys.argv[1]]()
    else:
        sys.exit(__doc__)
