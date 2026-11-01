#!/usr/bin/env python3
"""SJ's last landing: its board edits, made in a worktree (never the shared checkout); board_bd4.py's pattern.

head: put the clause at the head of the Queue line, behind no other "landing now" clause.
landed RECEIPT N: replace the head clause with the landed one, followed by the coordinator's order sentence given
      verbatim in SJ_ORDER (required), and move SJ's row to the board history's landed table, after its last row,
      titled done, its status the landing and its links rebased there: SJ closes, and that row is the landing's one row
      in the history file.
usage (from the checkout root): python3 -B board_sj2.py head | landed RECEIPT N"""
import datetime
import os
import re
import sys
from pathlib import Path

BOARD = Path('_process/BECOMING-WORKBOARD.md')
HISTORY = Path('_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md')
LANDED_TABLE = '## Landed after the board was rewritten (17 October 2026)'
TITLE = '| **SJ: the edge where acting meets the situation, and judgement from a reading on the root**'
HEAD = ("SJ's last parts at the head of the queue (landing now: GuardHorizon's bridge to the core's law of a common "
        "response in a ring module, `uniform_policy_iff_common` with its witness, and `statewise_not_uniform` re-proved "
        "from the leaf's witness; one incremental core run; the map of what a response takes in at 08 §7, 07 §5's "
        "sentence and 03 §12's home; SJ's row closed into the history; then render, strict check, links, tests and both "
        "dossier checks, then the fast-forward); ")


def queue(text):
    lines = text.split('\n')
    i = [k for k, l in enumerate(lines) if l.startswith('- **Queue:** ')]
    assert len(i) == 1, i
    return lines, i[0]


def head():
    lines, i = queue(BOARD.read_text(encoding='utf-8'))
    line = lines[i]
    assert '(landing now' not in line, 'another clause holds the head: ' + line[:200]
    assert sum(l.startswith(TITLE) for l in lines) == 1, 'SJ not on the board'
    lines[i] = '- **Queue:** ' + HEAD + line[len('- **Queue:** '):]
    BOARD.write_text('\n'.join(lines), encoding='utf-8')
    print("head: SJ's last parts at the head")


def landed(receipt, n):
    lines, i = queue(BOARD.read_text(encoding='utf-8'))
    line = lines[i]
    assert line.startswith('- **Queue:** ' + HEAD), "SJ's last parts do not hold the head"
    clause = (f"SJ's last parts landed, and SJ is done (§{n}, core receipt `{receipt}`, every axiom report empty, one "
              "incremental core run: in the ring module `Becoming.GuardHorizon`, `uniform_policy_iff_common`, given "
              "choice over the readings and every reading given, a choice from readings exists exactly where a response "
              "common over the reading's sameness does, through the core's law, with `ungiven_reading_not_uniform` "
              "showing the second hypothesis does work, and `statewise_not_uniform` re-proved from the leaf's witness, "
              "its statement unchanged; the seventh law of a-response-common-over-a-reading and a history line on "
              "when-to-inquire-and-when-to-respond; the map of what a response takes in at 08 §7, read by U4's owner; "
              "07 §5's sentence; 03 §12's home, the root module's bullet and the README row; the text review "
              "(REVIEW-4), every confirmed finding taken; the connectivity register brought to the bridge; the records "
              "citing the changed texts re-pointed and GuardHorizon's proof bindings rebound, nothing they say changed; "
              "SJ's row in the history file; render, strict check, links, tests and both dossier checks pass). ")
    rest = line[len('- **Queue:** ' + HEAD):]
    steps = os.environ.get('SJ_ORDER', '').strip()
    assert steps, "SJ_ORDER, the coordinator's order sentence sent with its word, is required"
    assert not re.search(r'\bSJ1?\b', steps), steps
    print('landed: order after SJ:', steps)
    clause += steps + ' '
    lines[i] = '- **Queue:** ' + clause + rest
    rows = [k for k, l in enumerate(lines) if l.startswith(TITLE)]
    assert len(rows) == 1, rows
    row = lines.pop(rows[0])
    BOARD.write_text('\n'.join(lines), encoding='utf-8')
    row = row.replace(TITLE, TITLE[:-2] + ', done**', 1)
    cells = row.split(' | ')
    assert len(cells) == 5, len(cells)
    cells[2] = (f'claimed 1 November 2026; SJ1 landed 2026-11-01 at core receipt `20261101T112708.430596Z`, study §494 '
                f'(0e01bfafa); the last parts landed {datetime.date.today().isoformat()} at core receipt `{receipt}`, '
                f'study §{n}: GuardHorizon\'s bridge in the ring, the map at 08 §7, 07 §5\'s sentence; every axiom '
                'report empty; four reviews ([REVIEW-1](../../research/2026-10-05-generative-foundation-review/'
                'root-foundation/development/sj-edge-and-judgement/REVIEW-1.md) to [REVIEW-4](../../research/'
                '2026-10-05-generative-foundation-review/root-foundation/development/sj-edge-and-judgement/REVIEW-4.md)), '
                'every confirmed finding taken')
    row = ' | '.join(cells)
    row = re.sub(r'\]\(\.\./theories/', '](../../../theories/', row)
    row = re.sub(r'\]\(research/', '](../../research/', row)
    row = re.sub(r'\]\(\.\./sources/', '](../../../sources/', row)
    hist = HISTORY.read_text(encoding='utf-8').split('\n')
    assert not any(h.startswith(TITLE[:-2] + ', done**') for h in hist), 'SJ is already in the history'
    start = hist.index(LANDED_TABLE)
    end = next(k for k in range(start + 1, len(hist)) if hist[k].startswith('## '))
    last = max(k for k in range(start, end) if hist[k].startswith('| **'))
    hist.insert(last + 1, row)
    HISTORY.write_text('\n'.join(hist), encoding='utf-8')
    print(f'landed: clause written, SJ\'s row moved after history line {last + 1}')


if __name__ == '__main__':
    if sys.argv[1:] == ['head']:
        head()
    elif len(sys.argv) == 4 and sys.argv[1] == 'landed':
        landed(sys.argv[2], int(sys.argv[3]))
    else:
        sys.exit(__doc__)
