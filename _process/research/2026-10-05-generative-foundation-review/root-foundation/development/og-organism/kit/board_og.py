#!/usr/bin/env python3
"""OG's board edits, made in a worktree (never the shared checkout); board_bd4.py's pattern.

head: put OG's clause at the head of the Queue line, behind no other "landing now" clause; the coordinator's order
      sentence is kept as it stands.
landed RECEIPT N: replace OG's head clause with the landed one, followed by the coordinator's order sentence, given
      verbatim in OG_ORDER (required: the coordinator sends it with its word, computed from what is still queued),
      and move OG's row to the history file (titled done, its status the landing, its links rebased there), after
      the last landed row.
usage (from the checkout root): python3 -B board_og.py head | landed RECEIPT N"""
import datetime
import os
import re
import sys
from pathlib import Path

BOARD = Path('_process/BECOMING-WORKBOARD.md')
HISTORY = Path('_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md')
TITLE = '| **OG: an organism on the root, a reader rebuilt from what it reads**'
HEAD = ("OG at the head of the queue (landing now: `Becoming.ReaderRebuilding`, a new instance of the ring on the "
        "grammar, no other module changed; ND's checker-scope patch carried; one incremental core run; a new record "
        "with home 04 §8, 01's test-systems bullet, the one page's open item in both editions, 08's ring sentence "
        "and counts; then render, strict check, links, tests and both dossier checks, then the fast-forward); ")


def queue(text):
    lines = text.split('\n')
    i = [k for k, l in enumerate(lines) if l.startswith('- **Queue:** ')]
    assert len(i) == 1, i
    return lines, i[0]


def head():
    lines, i = queue(BOARD.read_text(encoding='utf-8'))
    line = lines[i]
    assert '(landing now' not in line, 'another clause holds the head: ' + line[:200]
    assert sum(l.startswith(TITLE) for l in lines) == 1, 'OG not claimed'
    lines[i] = '- **Queue:** ' + HEAD + line[len('- **Queue:** '):]
    BOARD.write_text('\n'.join(lines), encoding='utf-8')
    print('head: OG at the head')


def landed(receipt, n):
    lines, i = queue(BOARD.read_text(encoding='utf-8'))
    line = lines[i]
    assert line.startswith('- **Queue:** ' + HEAD), 'OG does not hold the head'
    clause = (f"OG landed (§{n}, core receipt `{receipt}`, every axiom report empty, one incremental core run: "
              "`Becoming.ReaderRebuilding`, a new instance of the ring on the grammar, 48 declarations (32 theorems), "
              "no other module changed: one rule makes a family of four readers by where a spent unit is rebuilt "
              "from (given, the supply, the level, nothing), the supply chosen at every step; where the rebuild "
              "draws on the level the reader is kept while supplied from every level, under a cut present after "
              "k + 1 steps from every level of at least 2 (k + 1), and its end at an empty stock closed under the "
              "net; rebuilt from the supply or never, it is gone at its span from every level; the family law, the "
              "stock buys time under a cut exactly where the rebuild draws on the level, at every span of at least "
              "one, so the rebuild's source, not the turnover, separates the members; one unit's horizon decided "
              "at spans two and three for small levels only; the new record "
              "the-stock-buys-time-where-the-rebuild-draws-on-it, home 04 §8 with an AI reading, 01's test-systems "
              "bullet, the one page's open item in both editions (four words more), 08's ring sentence and counts; "
              "ND's checker-scope patch carried; the root module's bullet, the checker's core list and scope, both "
              "package READMEs and regions.json; an independent AI reading of the design with its re-check by runs "
              "of the rule, and one of the Lean, every finding taken; the connectivity register's nine new "
              "apart roots each with a reason; OG's row in the history file; render, strict check, links, tests "
              "and both dossier checks pass). ")
    rest = line[len('- **Queue:** ' + HEAD):]
    # the coordinator computes the order from what is still queued when it gives the word, and sends it verbatim
    steps = os.environ.get('OG_ORDER', '').strip()
    assert steps, "OG_ORDER, the coordinator's order sentence sent with its word, is required"
    assert 'OG' not in steps.replace(',', ' ').replace(';', ' ').split(), steps
    print('landed: order after OG:', steps)
    clause += f"Then, in the coordinator's order: {steps}; ask the coordinator for a slot. "
    lines[i] = '- **Queue:** ' + clause + rest
    rows = [k for k, l in enumerate(lines) if l.startswith(TITLE)]
    assert len(rows) == 1, rows
    row = lines.pop(rows[0])
    BOARD.write_text('\n'.join(lines), encoding='utf-8')
    row = row.replace(TITLE, TITLE[:-2] + ', done**', 1)
    cells = row.split(' | ')
    assert len(cells) == 5, len(cells)
    cells[2] = (f'landed {datetime.date.today().isoformat()} at core receipt `{receipt}`, study §{n}: '
                '`Becoming.ReaderRebuilding`, a new instance of the ring, every axiom report empty, no other module '
                'changed; the record the-stock-buys-time-where-the-rebuild-draws-on-it, home 04 §8; the design\'s '
                'readings ([REVIEW-1](../../research/2026-10-05-generative-foundation-review/root-foundation/'
                'development/og-organism/REVIEW-1.md)) and the Lean\'s ([REVIEW-2](../../research/2026-10-05-generative-'
                'foundation-review/root-foundation/development/og-organism/REVIEW-2.md)), every finding taken')
    cells[3] = '`development/og-organism/`'
    row = ' | '.join(cells)
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
