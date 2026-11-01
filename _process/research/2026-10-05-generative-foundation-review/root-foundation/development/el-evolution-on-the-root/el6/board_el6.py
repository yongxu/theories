#!/usr/bin/env python3
"""EL6's board edits, made in a worktree (never the shared checkout); board_el.py's pattern.

head: put EL6's clause at the head of the Queue line, behind no other "landing now" clause; the coordinator's order
      sentence is kept as it stands.
landed RECEIPT N: replace EL6's head clause with the landed one, followed by the coordinator's order sentence, given
      verbatim in EL6_ORDER (required: the coordinator sends it with its word), and move EL6's row to the history
      file (titled done, its status the landing, its links rebased there), after the last landed row.
usage (from the checkout root): python3 -B board_el6.py head | landed RECEIPT N"""
import datetime
import os
import re
import sys
from pathlib import Path

BOARD = Path('_process/BECOMING-WORKBOARD.md')
HISTORY = Path('_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md')
TITLE = "| **EL6: EL3 placed in its owners' modules**"
HEAD = ("EL6 at the head of the queue (landing now: EL3's leaf `Becoming.LineDegeneration` placed in its owners' "
        "modules on their yes and retired, the grammar part in `Becoming.GrammarMap`, the rest in "
        "`Becoming.MapInstances` with the landed laws proved from degeneration, the kind instance in "
        "`Becoming.KeepingWidening`, and the renames `Web.degenerates_of_gone` → `Web.end_of_gone` and "
        "`Map.Short.degeneration` → `Map.Short.reaches_end`, no statement changed; one near-full core run; then render, "
        "strict check, links and tests, then the fast-forward); ")


def queue(text):
    lines = text.split('\n')
    i = [k for k, l in enumerate(lines) if l.startswith('- **Queue:** ')]
    assert len(i) == 1, i
    return lines, i[0]


def head():
    lines, i = queue(BOARD.read_text(encoding='utf-8'))
    line = lines[i]
    assert '(landing now' not in line, 'another clause holds the head: ' + line[:200]
    assert sum(l.startswith(TITLE) for l in lines) == 1, 'EL6 not claimed'
    lines[i] = '- **Queue:** ' + HEAD + line[len('- **Queue:** '):]
    BOARD.write_text('\n'.join(lines), encoding='utf-8')
    print('head: EL6 at the head')


def landed(receipt, n):
    lines, i = queue(BOARD.read_text(encoding='utf-8'))
    line = lines[i]
    assert line.startswith('- **Queue:** ' + HEAD), 'EL6 does not hold the head'
    clause = (f"EL6 landed (§{n}, core receipt `{receipt}`, every axiom report empty, one near-full core run: EL3's "
              "leaf `Becoming.LineDegeneration` placed in its owners' modules, each on its owner's yes, and retired to "
              "the Lean history folder; in `Becoming.GrammarMap` «尽则非无终», «尽而续可定则有终» and "
              "«尽则有终当且仅当排中», with `Map.StepWhere` the short life gated by a proposition; in "
              "`Becoming.MapInstances` the constructive degeneration law, the regimes' degeneration and the witnesses, "
              "the landed laws that a line is not without end and `Web.end_of_gone` proved from degeneration in place "
              "and `Web.Restated` dropped; in `Becoming.KeepingWidening` the kind instance; renamed, each concluding an "
              "end and not degeneration, `Web.degenerates_of_gone` → `Web.end_of_gone` and `Map.Short.degeneration` → "
              "`Map.Short.reaches_end`; the signature audit: every statement unchanged; records "
              "degeneration-from-a-horizon and generation-and-degeneration-at-two-grains, home 02 §1; the root module's "
              "bullets, the checker's core list and scope, both package READMEs and regions.json; the connectivity "
              "register; the records citing what changed re-pointed and the changed modules' proof bindings rebound, "
              "nothing they say changed; EL6's row in the history file; render, strict check, links, tests and both "
              "dossier checks pass). ")
    rest = line[len('- **Queue:** ' + HEAD):]
    # the coordinator computes the order from what is still queued when it gives the word, and sends it verbatim
    steps = os.environ.get('EL6_ORDER', '').strip()
    assert steps, "EL6_ORDER, the coordinator's order sentence sent with its word, is required"
    assert not re.search(r'\bEL6\b', steps), steps
    print('landed: order after EL6:', steps)
    # the sentence is the coordinator's, verbatim: it carries its own "Then, in the coordinator's order:" and its end
    clause += steps + ' '
    lines[i] = '- **Queue:** ' + clause + rest
    rows = [k for k, l in enumerate(lines) if l.startswith(TITLE)]
    assert len(rows) == 1, rows
    row = lines.pop(rows[0])
    BOARD.write_text('\n'.join(lines), encoding='utf-8')
    row = row.replace(TITLE, TITLE[:-2] + ', done**', 1)
    cells = row.split(' | ')
    assert len(cells) == 5, len(cells)
    cells[2] = (f'landed {datetime.date.today().isoformat()} at core receipt `{receipt}`, study §{n}: EL3 placed in '
                'GrammarMap, MapInstances and KeepingWidening on their owners\' yes, `Becoming.LineDegeneration` '
                'retired, two renames, every statement unchanged, every axiom report empty '
                '([note](../../research/2026-10-05-generative-foundation-review/root-foundation/development/'
                'el-evolution-on-the-root/NOTE.md#state-of-the-lean))')
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
