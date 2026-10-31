#!/usr/bin/env python3
"""BD3's board edits, made in a worktree (never the shared checkout); board_bd2.py's pattern.

head: put BD3's clause at the head of the Queue line, behind no other "landing now" clause; the coordinator's order
      sentence is kept as it stands.
landed RECEIPT N: replace BD3's head clause with the landed one, followed by the coordinator's order with BD3 taken out
      (BD3_ORDER, if set, gives the coordinator's sentence instead), and move BD3's row to the history file (titled
      done, its status the landing, its links rebased there), after the last landed row.
usage (from the checkout root): python3 -B board_bd3.py head | landed RECEIPT N"""
import datetime
import os
import re
import sys
from pathlib import Path

BOARD = Path('_process/BECOMING-WORKBOARD.md')
HISTORY = Path('_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md')
TITLE = '| **BD3: a family a relation closes is a region not gone out of, so balance reads on «不出»**'
HEAD = ("BD3 at the head of the queue (landing now: `Becoming.BalanceRegions`, Continuity's closed families as the "
        "grammar's `«不出»` along adjacency among the listed relata and the balance law read on them, a core leaf, no "
        "existing module changed; one incremental core run; a seventh law on "
        "balance-from-conservation-along-a-relation; 01 §8.4's sentence; then render, strict check, links and tests, "
        "then the fast-forward); ")


def queue(text):
    lines = text.split('\n')
    i = [k for k, l in enumerate(lines) if l.startswith('- **Queue:** ')]
    assert len(i) == 1, i
    return lines, i[0]


def head():
    lines, i = queue(BOARD.read_text(encoding='utf-8'))
    line = lines[i]
    assert '(landing now' not in line, 'another clause holds the head: ' + line[:200]
    assert sum(l.startswith(TITLE) for l in lines) == 1, 'BD3 not claimed'
    lines[i] = '- **Queue:** ' + HEAD + line[len('- **Queue:** '):]
    BOARD.write_text('\n'.join(lines), encoding='utf-8')
    print('head: BD3 at the head')


def landed(receipt, n):
    lines, i = queue(BOARD.read_text(encoding='utf-8'))
    line = lines[i]
    assert line.startswith('- **Queue:** ' + HEAD), 'BD3 does not hold the head'
    clause = (f"BD3 landed (§{n}, core receipt `{receipt}`, every axiom report empty, one incremental core run: "
              "`Becoming.BalanceRegions`, a core leaf importing `Becoming.Continuity` and `Becoming.GrammarCrossing`, "
              "no existing module changed: adjacency among the listed relata a symmetric relation of the grammar; a "
              "family the relation closes, membership a test, exactly a region not gone out of along that adjacency "
              "and exactly one closed under it; so, relata listed without repetition and equality decided, transfers "
              "along the relation balancing a step existing exactly where the total is conserved on every such "
              "region, and on a web at every step likewise; a seventh law, a dependency on not-going-out-of-a-region "
              "and a history note on balance-from-conservation-along-a-relation, home 01 §8.4; the root module's "
              "bullet, the checker's core list and scope, both package READMEs and regions.json; an independent AI "
              "reading, every finding taken; the connectivity register's new apart roots each with a reason; BD3's "
              "row in the history file; render, strict check, links and tests pass). ")
    rest = line[len('- **Queue:** ' + HEAD):]
    order = re.search(r"Then, in the coordinator's order: ([^;]*(?:;[^;]*)*?); ask the coordinator for a slot\.", rest)
    steps = order.group(1) if order else ''
    kept = []
    for part in steps.split(' → '):
        if part.strip() in ('BD3', 'BD3, by readiness'):
            continue
        suffix = ', by readiness' if part.endswith(', by readiness') else ''
        part = part[:len(part) - len(suffix)]
        part = re.sub(r', BD3(?=,)', '', part)       # X, BD3, Y      -> X, Y
        part = re.sub(r', BD3 and ', ' and ', part)  # X, BD3 and Y   -> X and Y
        if re.search(r' and BD3\b', part):            # X, Y and BD3   -> X and Y
            part = re.sub(r' and BD3\b', '', part)
            if ' and ' not in part and ', ' in part:
                head_, _, last = part.rpartition(', ')
                part = f'{head_} and {last}'
        part = re.sub(r'^BD3(, | and )', '', part)   # BD3, Y / BD3 and Y -> Y
        kept.append(part + (suffix if (' and ' in part or ', ' in part) else ''))
    steps = ' → '.join(kept)
    steps = os.environ.get('BD3_ORDER', '').strip() or steps
    assert steps and 'BD3' not in steps, steps
    print('landed: order after BD3:', steps)
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
                '`Becoming.BalanceRegions` in the core, every axiom report empty, no existing module changed; a seventh '
                'law on balance-from-conservation-along-a-relation; the independent reading '
                '([REVIEW-BD3](../../research/2026-10-05-generative-foundation-review/root-foundation/development/'
                'bd-boundaries/REVIEW-BD3.md)), every finding taken')
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
