#!/usr/bin/env python3
"""The principle's page's reading time: the two board edits, made in a worktree (never the shared checkout);
board_ue28.py's pattern, documents only.

head: put the clause "The principle's page's reading time at the head of the queue (landing now: ...); " at the front
      of the Queue line, behind no other "landing now" clause.
land ORDER: drop the head clause and put the landed clause first, the coordinator's sentence ORDER after it verbatim;
      add the row to the history file after its last row. There is no claim row on the board to move.
usage (from the checkout root): python3 -B board_page_time.py head | land ORDER"""
import datetime
import re
import sys
from pathlib import Path

BOARD = Path('_process/BECOMING-WORKBOARD.md')
HISTORY = Path('_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md')
NAME = "The principle's page's reading time"
HEAD_TEXT = ("landing now: documents only, no Lean, no result record and no core run: one line stating the reading time "
             "of the principle's page, theories/becoming/FREE-ENERGY-PRINCIPLE.md; the four records citing the page "
             "re-pointed; render, strict check, links, tests and both dossier checks, then the fast-forward")
HEAD = re.compile(re.escape(NAME) + r' at the head of the queue \([^()]*\); ')
LANDED = ("The principle's page states its reading time (documents only, no Lean, no result record and no core run: one "
          "line before its first section, about 50 minutes and in brief about seven, by the AJ4 kit's measure; the "
          "four records citing the page re-pointed, each read against it, nothing they say changed; the row in the "
          "history file; render, strict check, links, tests and both dossier checks pass). ")
ROW = ("| **The principle's page states its reading time** (AGENTS.md: each front states its reading time; the AJ4 "
       "kit's measure, [READING-BUDGETS](../../research/2026-10-05-generative-foundation-review/root-foundation/"
       "development/aj4-alignment-readers/READING-BUDGETS.md#how-a-time-is-measured)). One line before the page's "
       "first section: about 50 minutes to read, in brief about seven (5,371 words, 41.3 to 53.7 minutes; In brief "
       "772 words, 5.9 to 7.7), the page already within an hour and its In brief within ten minutes, so nothing is "
       "cut. The four records citing the page by its whole bytes (a-code-held-as-counts, "
       "a-formations-couplings-as-its-blanket, the-blanket-at-a-steady-state, the-blanket-in-a-linear-steady-state) "
       "re-pointed, each read against the line, nothing they say changed. No Lean, no result record, no core run "
       "| Claude Code desktop session (farther than FEP), 1 November 2026 "
       f"| landed {datetime.date.today().isoformat()} (on the coordinator's order, documents only): render, strict "
       "check, links (0 broken), the 305 tests and both dossier checks pass on the landing tree "
       "| [FREE-ENERGY-PRINCIPLE](../../../theories/becoming/FREE-ENERGY-PRINCIPLE.md) "
       "| the AJ4 kit's measure → the principle's page |")


def queue_line(lines):
    at = [i for i, line in enumerate(lines) if line.startswith('- **Queue:** ')]
    assert len(at) == 1, at
    return at[0]


def head():
    lines = BOARD.read_text(encoding='utf-8').split('\n')
    q = queue_line(lines)
    assert '(landing now' not in lines[q], 'another clause holds the head: ' + lines[q][:200]
    clause = f'{NAME} at the head of the queue ({HEAD_TEXT}); '
    assert HEAD.fullmatch(clause), clause
    lines[q] = lines[q].replace('- **Queue:** ', '- **Queue:** ' + clause, 1)
    BOARD.write_text('\n'.join(lines), encoding='utf-8')
    print('head: the principle\'s page\'s reading time at the head of the queue')


def land(order):
    order = order.strip()
    assert order.startswith("Then, in the coordinator's order: ") and order.endswith('ask the coordinator for a slot.'), order
    assert '); ' not in order and '\n' not in order and ' | ' not in order, 'the order sentence'
    assert ROW.count(' | ') == 4, ROW.count(' | ')
    lines = BOARD.read_text(encoding='utf-8').split('\n')
    q = queue_line(lines)
    assert len(HEAD.findall(lines[q])) == 1 and lines[q].startswith('- **Queue:** ' + NAME + ' at the head'), 'not at the head'
    lines[q] = HEAD.sub('', lines[q], count=1)
    lines[q] = lines[q].replace('- **Queue:** ', '- **Queue:** ' + LANDED + order + ' ', 1)
    BOARD.write_text('\n'.join(lines), encoding='utf-8')
    history = HISTORY.read_text(encoding='utf-8').split('\n')
    lapsed = history.index('## Lapsed claims (18 October 2026)')
    end = lapsed - 1
    while not history[end].startswith('| '):
        end -= 1
    history.insert(end + 1, ROW)
    HISTORY.write_text('\n'.join(history), encoding='utf-8')
    print(f'land: clause written, row added after history line {end + 1}')


if __name__ == '__main__':
    if sys.argv[1:] == ['head']:
        head()
    elif len(sys.argv) == 3 and sys.argv[1] == 'land':
        land(sys.argv[2])
    else:
        sys.exit(__doc__)
