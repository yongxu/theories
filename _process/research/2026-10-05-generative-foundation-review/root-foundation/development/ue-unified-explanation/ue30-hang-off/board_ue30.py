#!/usr/bin/env python3
"""UE30: the two board edits, made in a worktree (never the shared checkout); board_page_time.py's pattern, documents only.

head: put the clause "UE30 at the head of the queue (landing now: ...); " at the front of the Queue line, behind no
      other "landing now" clause.
land ORDER: drop the head clause and put the landed clause first, the coordinator's sentence ORDER after it verbatim;
      add the row to the history file after its last row. There is no claim row on the board to move.
usage (from the checkout root): python3 -B board_ue30.py head | land ORDER"""
import datetime
import re
import sys
from pathlib import Path

BOARD = Path('_process/BECOMING-WORKBOARD.md')
HISTORY = Path('_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md')
NAME = 'UE30'
HEAD_TEXT = ("landing now: documents only, no Lean, no result record and no core run: the principle's page and the sciences "
             "dossier hung off the one path; 08 §8's count of the principle's third parts; what would defeat the central reading, "
             "argued in a note with its home in 08 §9 and 01's two sentences on the claim; the records citing the page, 08 "
             "and 01 re-pointed after reading; render, strict check, links, tests and both dossier checks, then the fast-forward")
HEAD = re.compile(re.escape(NAME) + r' at the head of the queue \([^()]*\); ')
LANDED = ("UE30 landed (documents only: no Lean, no result record and no core run): the principle's page and the sciences "
          "dossier hung off the one path. The page has a line up to the path, In brief in short lists, what forbids nothing "
          "on both sides and a section on what would count against it; the dossier has a ten-minute part, S-17 brought to "
          "the page and what would refute what; 08 §8 counts the principle's five third parts, as the page does; 08 §9 states "
          "what would defeat the central reading in each of its four senses, as a language nothing, as an explanation a rival "
          "deriving the same laws from fewer patterns or a field without it getting there first, where a first count ties, and 01's two sentences say so; the "
          "records citing the page, 08 and 01 re-pointed in their rebinds lines, nothing they say changed; the row in the "
          "history file. ")
ROW = ("| **UE30: the principle's page and the sciences dossier hung off the one path** (the board's way now, item 3; the "
       "coordinator's word of 2 November 2026; [note](../../research/2026-10-05-generative-foundation-review/root-foundation/"
       "development/ue-unified-explanation/ue30-hang-off/NOTE.md)). Purpose: a reader who arrives with one question or field "
       "can see where the page stands and what would count against it. The page's In brief re-cut from one block into short "
       "lists, every condition kept; what forbids nothing on both sides; a section on how a measurement reaches each kind of "
       "claim. The dossier's ten-minute part, its S-17 brought to the page (it had described only the first study), LN2's "
       "sense of law. 08 §8: five third parts, as the page says. 08 §9: the explanatory reading as a philosophical thesis, with "
       "what would defeat each of its four senses, argued in [a note](../../research/2026-10-05-generative-foundation-review/"
       "root-foundation/development/ue-unified-explanation/ue30-hang-off/WHAT-WOULD-DEFEAT-THE-READING.md). Independent AI "
       "reads taken, with the findings not taken stated. No Lean, no result record, no "
       "core run | Claude Code desktop session (farther than FEP), 2 November 2026 "
       f"| landed {datetime.date.today().isoformat()} (on the coordinator's order, documents only): render, strict check, "
       "links (0 broken), the tests and both dossier checks pass on the landing tree "
       "| [FREE-ENERGY-PRINCIPLE](../../../theories/becoming/FREE-ENERGY-PRINCIPLE.md), "
       "[SCIENCES](../../research/2026-10-05-generative-foundation-review/root-foundation/development/ue8-sciences-dossier/SCIENCES.md) "
       "| the AJ4 kit's measure → the page and the dossier |")


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
    print('head: UE30 at the head of the queue')


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
