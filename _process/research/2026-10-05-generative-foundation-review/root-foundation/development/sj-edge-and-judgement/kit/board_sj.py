#!/usr/bin/env python3
"""SJ1's board edits, made in a worktree (never the shared checkout); board_el.py's pattern.

head: put SJ1's clause at the head of the Queue line, behind no other "landing now" clause; the coordinator's order
      sentence is kept as it stands.
landed RECEIPT N: replace SJ1's head clause with the landed one, followed by the coordinator's order sentence, given
      verbatim in SJ_ORDER (required: the coordinator sends it with its word, computed from what is still queued),
      and set the status cell of SJ's row to SJ1's landing and what is left. The row stays on the board: the map
      (08 §7), 07 §5's sentence and GuardHorizon's bridge are still to land.
history RECEIPT N: add the landing's one row to the board history's landed table, after its last row, nothing else in
      that file changed (the coordinator, 1 November 2026: each landing adds exactly one row there, as QR's 7c90d62ef
      and SJ1's 7fc329fd9 did). The row is given in SJ_HISTORY_ROW (required: five cells, links relative to the
      history file), with {RECEIPT}, {N} and {DATE} filled in here; a row with the same title stops the script.
usage (from the checkout root): python3 -B board_sj.py head | landed RECEIPT N | history RECEIPT N"""
import datetime
import os
import re
import sys
from pathlib import Path

BOARD = Path('_process/BECOMING-WORKBOARD.md')
HISTORY = Path('_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md')
LANDED_TABLE = '## Landed after the board was rewritten (17 October 2026)'
TITLE = '| **SJ: the edge where acting meets the situation, and judgement from a reading on the root**'
HEAD = ("SJ1 at the head of the queue (landing now: one core leaf, `Becoming.CommonResponse`, and `Becoming.Viability`'s "
        "two kernel laws re-proved from it with their statements unchanged; one incremental core run; one new record, "
        "home 03 §12, 03's bases line and 05 §10's row; then render, strict check, links and tests, then the fast-forward); ")


def queue(text):
    lines = text.split('\n')
    i = [k for k, l in enumerate(lines) if l.startswith('- **Queue:** ')]
    assert len(i) == 1, i
    return lines, i[0]


def head():
    lines, i = queue(BOARD.read_text(encoding='utf-8'))
    line = lines[i]
    assert '(landing now' not in line, 'another clause holds the head: ' + line[:200]
    assert sum(l.startswith(TITLE) for l in lines) == 1, 'SJ not claimed'
    lines[i] = '- **Queue:** ' + HEAD + line[len('- **Queue:** '):]
    BOARD.write_text('\n'.join(lines), encoding='utf-8')
    print('head: SJ1 at the head')


def landed(receipt, n):
    lines, i = queue(BOARD.read_text(encoding='utf-8'))
    line = lines[i]
    assert line.startswith('- **Queue:** ' + HEAD), 'SJ1 does not hold the head'
    clause = (f"SJ1 landed (§{n}, core receipt `{receipt}`, every axiom report empty, one incremental core run: one "
              "core leaf, `Becoming.CommonResponse`: the occurrences whose closure under a relation stays in a region "
              "form its largest part closed under the relation, the invariance kernel at a process's steps, and a response common over "
              "a reading within a requirement exists exactly where the acts' kernels cover the situations, so judgment "
              "is viability indexed by acts; with exactly one act at each situation, one common over a map's sameness "
              "exists exactly where the image of the response relation along the map has a fixed successor; `Viability.Certificate.kernel` and "
              "`Viability.kernel_certificate` re-proved from it, statements unchanged; one new record, "
              "a-response-common-over-a-reading, home 03 §12; the root module's import and bullets, the checker's core "
              "list and scope, both package READMEs and regions.json; three reviews, of the design, the Lean and the map, "
              "and the landing texts, every confirmed finding taken; the names "
              "provisional for the grammar's owner; the connectivity register's new apart roots each with a reason; "
              "the records citing the changed texts re-pointed and Viability's proof bindings rebound, nothing they "
              "say changed; render, strict check, links and tests pass). ")
    rest = line[len('- **Queue:** ' + HEAD):]
    steps = os.environ.get('SJ_ORDER', '').strip()
    assert steps, "SJ_ORDER, the coordinator's order sentence sent with its word, is required"
    assert not re.search(r'\bSJ1?\b', steps), steps
    print('landed: order after SJ1:', steps)
    clause += steps + ' '
    lines[i] = '- **Queue:** ' + clause + rest
    rows = [k for k, l in enumerate(lines) if l.startswith(TITLE)]
    assert len(rows) == 1, rows
    cells = lines[rows[0]].split(' | ')
    assert len(cells) == 5, len(cells)
    cells[2] = (f'claimed 1 November 2026; SJ1 landed {datetime.date.today().isoformat()} at core receipt '
                f'`{receipt}`, study §{n}; left: the map at 08 §7 once U4\'s owner has read it, 07 §5\'s sentence, '
                'GuardHorizon\'s bridge in a ring slot after ND')
    lines[rows[0]] = ' | '.join(cells)
    BOARD.write_text('\n'.join(lines), encoding='utf-8')
    print('landed: clause written, the row\'s status set')


def history(receipt, n):
    row = os.environ.get('SJ_HISTORY_ROW', '').strip()
    assert row, 'SJ_HISTORY_ROW, the landing\'s history row, is required'
    row = row.replace('{RECEIPT}', receipt).replace('{N}', str(n)).replace('{DATE}', datetime.date.today().isoformat())
    assert row.startswith('| **') and row.endswith(' |') and len(row.split(' | ')) == 5, row[:80]
    assert not re.search(r'\{[A-Z]+\}', row), 'a placeholder left'
    text = HISTORY.read_text(encoding='utf-8')
    lines = text.split('\n')
    title = row.split('** ', 1)[0] + '**'
    assert not any(l.startswith(title) for l in lines), ('the row is already there', title)
    start = lines.index(LANDED_TABLE)
    end = next(k for k in range(start + 1, len(lines)) if lines[k].startswith('## '))
    last = max(k for k in range(start, end) if lines[k].startswith('| **'))
    lines.insert(last + 1, row)
    HISTORY.write_text('\n'.join(lines), encoding='utf-8')
    print('history: row added after line', last + 1)


if __name__ == '__main__':
    if sys.argv[1:] == ['head']:
        head()
    elif len(sys.argv) == 4 and sys.argv[1] == 'landed':
        landed(sys.argv[2], int(sys.argv[3]))
    elif len(sys.argv) == 4 and sys.argv[1] == 'history':
        history(sys.argv[2], int(sys.argv[3]))
    else:
        sys.exit(__doc__)
