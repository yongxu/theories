#!/usr/bin/env python3
"""OG2's board edits, made in a worktree (never the shared checkout); board_bd4.py's pattern.

head: put OG2's clause at the head of the Queue line, behind no other "landing now" clause; the coordinator's order
      sentence is kept as it stands.
landed RECEIPT N: replace OG2's head clause with the landed one, followed by the coordinator's order sentence, given
      verbatim in OG2_ORDER (required: the coordinator sends it with its word, computed from what is still queued),
      and move OG2's row to the history file (titled done, its status the landing, its links rebased there), after
      the last landed row.
usage (from the checkout root): python3 -B board_og.py head | landed RECEIPT N"""
import datetime
import os
import re
import sys
from pathlib import Path

BOARD = Path('_process/BECOMING-WORKBOARD.md')
HISTORY = Path('_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md')
TITLE = '| **OG2: one kind of institution on the root, an entry rule on a shared stock, passed through members who also keep it**'
HEAD = ("OG2 at the head of the queue (landing now: `Becoming.RuleRebuilding`, a new instance of the ring on the "
        "grammar, no other module changed; one incremental core run; a new record with home 05 §12, 01's test-systems "
        "bullet, the status sentence on the one page and overview in both editions, 08's ring sentence and counts; "
        "then render, strict check, links, tests and both dossier checks, then the fast-forward); ")


def queue(text):
    lines = text.split('\n')
    i = [k for k, l in enumerate(lines) if l.startswith('- **Queue:** ')]
    assert len(i) == 1, i
    return lines, i[0]


def head():
    lines, i = queue(BOARD.read_text(encoding='utf-8'))
    line = lines[i]
    assert '(landing now' not in line, 'another clause holds the head: ' + line[:200]
    assert sum(l.startswith(TITLE) for l in lines) == 1, 'OG2 not claimed'
    lines[i] = '- **Queue:** ' + HEAD + line[len('- **Queue:** '):]
    BOARD.write_text('\n'.join(lines), encoding='utf-8')
    print('head: OG2 at the head')


def landed(receipt, n):
    lines, i = queue(BOARD.read_text(encoding='utf-8'))
    line = lines[i]
    assert line.startswith('- **Queue:** ' + HEAD), 'OG2 does not hold the head'
    counts = Path('_process/research/2026-10-05-generative-foundation-review/root-foundation/development/og-organism/og2/LANDED-COUNTS.txt').read_text(encoding='utf-8').strip()
    clause = (f"OG2 landed (§{n}, core receipt `{receipt}`, every axiom report empty, one incremental core run: "
              f"`Becoming.RuleRebuilding`, a new instance of the ring on the grammar, {counts}, "
              "no other module changed: one rule makes a family of nets by where a rule of entry is taught from "
              "(members, outside, nowhere), others entering past a door of a strength per teacher, every member "
              "drawing one unit and an overdraw ending everything; from the steady state the rule is held at every "
              "step exactly where teaching fits a tenure, the quota is at least one and the take fits the renewal; "
              "a region is closed under a revision inside it, and the band does not settle what follows a revision; "
              "no holder comes from no holder; the steady state and open entry are two tests, each its own; at a "
              "teaching age of one less than the tenure held and empty cohorts rotate, and the count of held ones "
              "weighs one take against the other; the new record a-rule-rebuilt-from-the-members-it-limits, home "
              "05 §12 with an AI reading, 01's test-systems bullet, the status sentence on the one page and overview "
              "in both editions, 08's ring sentence and counts; the root module's bullet, the checker's core list "
              "and scope, both package READMEs and regions.json; two independent AI readings of the design with a "
              "re-check by runs of the rule, one of the Lean, every finding taken; the connectivity register's new "
              "apart roots each with a reason; OG2's row in the history file; render, strict check, links, tests "
              "and both dossier checks pass). ")
    rest = line[len('- **Queue:** ' + HEAD):]
    # the coordinator computes the order from what is still queued when it gives the word, and sends it verbatim
    steps = os.environ.get('OG2_ORDER', '').strip()
    assert steps, "OG2_ORDER, the coordinator's order sentence sent with its word, is required"
    assert 'OG2' not in steps.replace(',', ' ').replace(';', ' ').split(), steps
    print('landed: order after OG2:', steps)
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
                '`Becoming.RuleRebuilding`, a new instance of the ring, every axiom report empty, no other module '
                'changed; the record a-rule-rebuilt-from-the-members-it-limits, home 05 §12; the design\'s readings and '
                'the Lean\'s ([REVIEW-4](../../research/2026-10-05-generative-foundation-review/root-foundation/'
                'development/og-organism/og2/REVIEW-4.md)), every finding taken')
    cells[3] = '`development/og-organism/og2/`'
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
