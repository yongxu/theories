#!/usr/bin/env python3
"""EL's board edits, made in a worktree (never the shared checkout); board_bd3.py's pattern.

head: put EL's clause at the head of the Queue line, behind no other "landing now" clause; the coordinator's order
      sentence is kept as it stands.
landed RECEIPT N: replace EL's head clause with the landed one, followed by the coordinator's order sentence, given
      verbatim in EL_ORDER (required: the coordinator sends it with its word, computed from what is still queued),
      and move EL's row to the history file (titled done, its status the landing, its links rebased there), after
      the last landed row. The row's old status cell, which named the conditional-laws item by a wrong id (OU5, taken
      on 23 October; the item is OU7), is replaced whole.
usage (from the checkout root): python3 -B board_el.py head | landed RECEIPT N"""
import datetime
import os
import re
import sys
from pathlib import Path

BOARD = Path('_process/BECOMING-WORKBOARD.md')
HISTORY = Path('_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md')
TITLE = "| **EL: evolution read on the root's map**"
HEAD = ("EL at the head of the queue (landing now: six core leaves, `Becoming.LineDegeneration`, "
        "`Becoming.SelectionShift`, `Becoming.LineageRegions`, `Becoming.LineageRegimes`, `Becoming.WindowedWaiting` "
        "and `Becoming.PairSelection`, no existing module changed; one incremental core run; six new records, homes "
        "02 §1, 04 §3–§4 and 05 §5–§6; then render, strict check, links and tests, then the fast-forward); ")


def queue(text):
    lines = text.split('\n')
    i = [k for k, l in enumerate(lines) if l.startswith('- **Queue:** ')]
    assert len(i) == 1, i
    return lines, i[0]


def head():
    lines, i = queue(BOARD.read_text(encoding='utf-8'))
    line = lines[i]
    assert '(landing now' not in line, 'another clause holds the head: ' + line[:200]
    assert sum(l.startswith(TITLE) for l in lines) == 1, 'EL not claimed'
    lines[i] = '- **Queue:** ' + HEAD + line[len('- **Queue:** '):]
    BOARD.write_text('\n'.join(lines), encoding='utf-8')
    print('head: EL at the head')


def landed(receipt, n):
    lines, i = queue(BOARD.read_text(encoding='utf-8'))
    line = lines[i]
    assert line.startswith('- **Queue:** ' + HEAD), 'EL does not hold the head'
    clause = (f"EL landed (§{n}, core receipt `{receipt}`, every axiom report empty, one incremental core run: six "
              "core leaves, no existing module changed: `Becoming.LineDegeneration` (EL3: a uniform horizon not before "
              "the start, at which nothing reached is active, ends a line on every branch, «尽», at every class within activity, constructively; an end, 有终, from the "
              "law's premise is exactly excluded middle), `Becoming.SelectionShift` and `Becoming.LineageRegions` "
              "(EL1: what the selection term proper does and does not decide; descent read on the map; a whole "
              "cohort degenerating is extinction where listed offspring continue their parents; the same terms "
              "through a horizon, two fates), `Becoming.LineageRegimes` (EL2: three ending laws as regimes on a "
              "lineage, the stock their horizon, deciding neither fate from any stock of at least one), `Becoming.WindowedWaiting` and "
              "`Becoming.PairSelection` (EL4: keeping inclusion splits restoring from answering, the window of two "
              "doing both; offspring read from a pair's run, no kind rising against withholders in a cohort "
              "listed as pairs where a withheld step weighs at least a received one; where a gift's surplus comes from); six new records, homes 02 "
              "§1, 04 §3–§4 and 05 §5–§6; the root module's bullets, the checker's core list and scope, both package "
              "READMEs and regions.json; four rounds of independent AI verification and a reading of the landing "
              "texts, every finding taken; the moves into GrammarMap, MapInstances and KeepingWidening and the "
              "rename of `Web.degenerates_of_gone` (it concludes an end, not degeneration) proposed to their owners, after OU7's rebuild; the connectivity "
              "register's new apart roots each with a reason; the records citing the changed sections re-pointed, "
              "nothing they say changed; EL's row in the history file; render, strict check, links and tests "
              "pass). ")
    rest = line[len('- **Queue:** ' + HEAD):]
    # the coordinator computes the order from what is still queued when it gives the word, and sends it verbatim
    steps = os.environ.get('EL_ORDER', '').strip()
    assert steps, "EL_ORDER, the coordinator's order sentence sent with its word, is required"
    assert not re.search(r'\bEL\b', steps), steps
    print('landed: order after EL:', steps)
    clause += f"Then, in the coordinator's order: {steps}; ask the coordinator for a slot. "
    lines[i] = '- **Queue:** ' + clause + rest
    rows = [k for k, l in enumerate(lines) if l.startswith(TITLE)]
    assert len(rows) == 1, rows
    row = lines.pop(rows[0])
    BOARD.write_text('\n'.join(lines), encoding='utf-8')
    row = row.replace(TITLE, TITLE[:-2] + ', done**', 1)
    cells = row.split(' | ')
    assert len(cells) == 5, len(cells)
    cells[2] = (f'landed {datetime.date.today().isoformat()} at core receipt `{receipt}`, study §{n}: six core leaves, '
                'every axiom report empty, no existing module changed; six new records; the moves into the owners\' '
                'modules and a rename proposed in `Becoming.LineDegeneration`\'s docstring, each on its owner\'s yes '
                '([note](../../research/2026-10-05-generative-foundation-review/root-foundation/development/'
                'el-evolution-on-the-root/NOTE.md))')
    row = ' | '.join(cells)
    assert 'OU5' not in row, 'the wrong id OU5 left in the row'
    row = re.sub(r'\]\(\.\./theories/', '](../../../theories/', row)
    row = re.sub(r'\]\(research/', '](../../research/', row)
    row = re.sub(r'\]\(\.\./sources/', '](../../../sources/', row)
    hist = HISTORY.read_text(encoding='utf-8').split('\n')
    lapsed = hist.index('## Lapsed claims (18 October 2026)')
    k = lapsed - 1
    while k > 0 and not hist[k].startswith('| **'):
        k -= 1
    hist.insert(k + 1, row)
    HISTORY.write_text('\n'.join(hist), encoding='utf-8')
    print(f'landed: clause written, row moved after history line {k + 1}')


if __name__ == '__main__':
    if sys.argv[1:] == ['head']:
        head()
    elif len(sys.argv) == 4 and sys.argv[1] == 'landed':
        landed(sys.argv[2], int(sys.argv[3]))
    else:
        sys.exit(__doc__)
