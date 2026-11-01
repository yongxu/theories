#!/usr/bin/env python3
"""BD4's board edits, made in a worktree (never the shared checkout); board_bd4.py's pattern.

head: put BD4's clause at the head of the Queue line, behind no other "landing now" clause; the coordinator's order
      sentence is kept as it stands.
landed RECEIPT N: replace BD4's head clause with the landed one, followed by the coordinator's order sentence, given
      verbatim in BD4_ORDER (required: the coordinator sends it with its word, computed from what is still queued),
      and move BD4's row to the history file (titled done, its status the landing, its links rebased there), after
      the last landed row.
usage (from the checkout root): python3 -B board_bd4.py head | landed RECEIPT N"""
import datetime
import os
import re
import sys
from pathlib import Path

BOARD = Path('_process/BECOMING-WORKBOARD.md')
HISTORY = Path('_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md')
TITLE = '| **BD4: balance on each closure, the «所闭» form**'
HEAD = ("BD4 at the head of the queue (landing now: `Becoming.BalanceRegions` extended, each closure under "
        "adjacency among the listed relata, the grammar's `«所闭»`, decided as a test, the balance law read on each "
        "closure, and at the unit grain a case of `«类之对当且仅当类类等数»`, the two grains joined; a core leaf, no "
        "other module changed; "
        "one incremental core run; an eighth law on balance-from-conservation-along-a-relation; 01 §8.4's "
        "sentence; then render, strict check, links and tests, then the fast-forward); ")


def queue(text):
    lines = text.split('\n')
    i = [k for k, l in enumerate(lines) if l.startswith('- **Queue:** ')]
    assert len(i) == 1, i
    return lines, i[0]


def head():
    lines, i = queue(BOARD.read_text(encoding='utf-8'))
    line = lines[i]
    assert '(landing now' not in line, 'another clause holds the head: ' + line[:200]
    assert sum(l.startswith(TITLE) for l in lines) == 1, 'BD4 not claimed'
    lines[i] = '- **Queue:** ' + HEAD + line[len('- **Queue:** '):]
    BOARD.write_text('\n'.join(lines), encoding='utf-8')
    print('head: BD4 at the head')


def landed(receipt, n):
    lines, i = queue(BOARD.read_text(encoding='utf-8'))
    line = lines[i]
    assert line.startswith('- **Queue:** ' + HEAD), 'BD4 does not hold the head'
    clause = (f"BD4 landed (§{n}, core receipt `{receipt}`, every axiom report empty, one incremental core run: "
              "`Becoming.BalanceRegions` extended, a core leaf, no other module changed: each relatum's closure "
              "under adjacency among the listed relata, the grammar's «所闭», decided as a test by a counting "
              "bound; so, relata listed without repetition and equality decided, transfers along the relation "
              "balancing a step existing exactly where the total is conserved on the closure of each listed "
              "relatum, and on a web at every step likewise, each relatum's closure the least family the relation "
              "closes that holds it; at the unit grain a pairing under the closure the count kept on the closure of "
              "each relatum, a case of «类之对当且仅当类类等数», so that the transfers exist exactly where the units "
              "before pair one to one with the units after under the closure, though not always along one step "
              "(the path 0 — 1 — 2); the uncapacitated, undirected case of Gale's and Hoffman's conditions, read on "
              "the grammar; an eighth law, two items on what is not shown in place of the «所闭» form, the first "
              "hypothesis's wording, Gale and Hoffman in the correspondence and a history note on "
              "balance-from-conservation-along-a-relation, "
              "home 01 §8.4; the root module's bullet, the checker's scope, both package READMEs and "
              "regions.json; an independent AI review, every finding taken; the connectivity register's new "
              "apart roots each with a reason; BD4's row in the history file; render, strict check, links and "
              "tests pass). ")
    rest = line[len('- **Queue:** ' + HEAD):]
    # the coordinator computes the order from what is still queued when it gives the word, and sends it verbatim
    steps = os.environ.get('BD4_ORDER', '').strip()
    assert steps, "BD4_ORDER, the coordinator's order sentence sent with its word, is required"
    assert 'BD4' not in steps, steps
    print('landed: order after BD4:', steps)
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
                '`Becoming.BalanceRegions` extended in the core, every axiom report empty, no other module '
                'changed; an eighth law on balance-from-conservation-along-a-relation; the independent review '
                '([REVIEW-BD4](../../research/2026-10-05-generative-foundation-review/root-foundation/development/'
                'bd-boundaries/REVIEW-BD4.md)), every finding taken')
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
