#!/usr/bin/env python3
"""BD2's board edits, made in a worktree (never the shared checkout); board_rr2.py's pattern.

head: put BD2's clause at the head of the Queue line, behind no other "landing now" clause; the coordinator's order
      sentence is kept as it stands.
landed RECEIPT N: replace BD2's head clause with the landed one, followed by the coordinator's order with BD2 taken out
      (BD2_ORDER, if set, gives the coordinator's sentence instead), and move BD2's row to the history file (titled
      done, its status the landing, its links rebased there), after the last landed row.
usage (from the checkout root): python3 -B board_bd2.py head | landed RECEIPT N"""
import os
import re
import sys
from pathlib import Path

BOARD = Path('_process/BECOMING-WORKBOARD.md')
HISTORY = Path('_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md')
HEAD = ("BD2 at the head of the queue (landing now: `Becoming.GrammarCrossing`, the grammar's not going out, and "
        "`Becoming.ConveyanceBoundaries`, the World's cut as it by definition and 04 §1's law on 07 §4.1's boundaries, "
        "joined to the core; `«所经必同»` proved from the step going out; one incremental core run; the record "
        "not-going-out-of-a-region and two records amended; 01 §9.9, 04 §1, 07 and the glossary; the records citing "
        "the changed sections re-pointed; then render, strict check, links and tests, then the fast-forward); ")


def queue(text):
    lines = text.split('\n')
    i = [k for k, l in enumerate(lines) if l.startswith('- **Queue:** ')]
    assert len(i) == 1, i
    return lines, i[0]


def head():
    lines, i = queue(BOARD.read_text(encoding='utf-8'))
    line = lines[i]
    assert '(landing now' not in line, 'another clause holds the head: ' + line[:200]
    assert any(l.startswith('| **BD2:') for l in lines), 'BD2 not claimed'
    lines[i] = '- **Queue:** ' + HEAD + line[len('- **Queue:** '):]
    BOARD.write_text('\n'.join(lines), encoding='utf-8')
    print('head: BD2 at the head')


def landed(receipt, n):
    lines, i = queue(BOARD.read_text(encoding='utf-8'))
    line = lines[i]
    assert line.startswith('- **Queue:** ' + HEAD), 'BD2 does not hold the head'
    clause = (f"BD2 landed (§{n}, core receipt `{receipt}`, every axiom report empty, one incremental core run: "
              "`Becoming.GrammarCrossing`, the grammar's `«不出»`, nothing in a region going out of it along a "
              "relation: a closed region, a closure among them, not gone out of; not going out the closedness of what "
              "is not outside, with no decision, and being closed where membership is settled, the two coinciding "
              "for every region exactly under excluded middle; nothing coming in exactly where nothing goes out of "
              "the outside, the two one along a symmetric relation, a closed region able to be come into along one "
              "that is not; a line from inside to outside going out, its step going out placed on the line by the "
              "mark law with keeping to the region as what the ends fail; `Becoming.ConveyanceBoundaries`, "
              "`Flow.Cut` as `«不出»` at a valuation's relation by definition and a continuing family's region no "
              "boundary of any event's self along conveyance; `«所经必同»` proved from the step going out (rule 9, its "
              "statement unchanged); record not-going-out-of-a-region, home 01 §9.9, a sixth law on "
              "conveyance-crosses-the-boundary and a history note on what-a-line-holds-and-a-regularity-takes-in; "
              "01 §9.9 (BD's reading citing the Lean), 04 §1, 07, the glossary row, the root module's bullets, the "
              "checker's core list and scope and both package READMEs, the Chinese Boundaries row and the checker's "
              "Boundaries scope brought to the continuation condition; an independent AI review and its re-check, "
              "every finding taken; the records citing the changed sections re-pointed, nothing they say changed; "
              "BD2's row in the history file; render, strict check, links and tests pass). ")
    rest = line[len('- **Queue:** ' + HEAD):]
    order = re.search(r"Then, in the coordinator's order: ([^;]*(?:;[^;]*)*?); ask the coordinator for a slot\.", rest)
    steps = order.group(1) if order else ''
    kept = []
    for part in steps.split(' → '):
        if part.strip() in ('BD2', 'BD2, by readiness'):
            continue
        suffix = ', by readiness' if part.endswith(', by readiness') else ''
        part = part[:len(part) - len(suffix)]
        part = re.sub(r', BD2(?=,)', '', part)       # X, BD2, Y      -> X, Y
        part = re.sub(r', BD2 and ', ' and ', part)  # X, BD2 and Y   -> X and Y
        if re.search(r' and BD2\b', part):            # X, Y and BD2   -> X and Y
            part = re.sub(r' and BD2\b', '', part)
            if ' and ' not in part and ', ' in part:
                head_, _, last = part.rpartition(', ')
                part = f'{head_} and {last}'
        part = re.sub(r'^BD2(, | and )', '', part)   # BD2, Y / BD2 and Y -> Y
        kept.append(part + (suffix if (' and ' in part or ', ' in part) else ''))
    steps = ' → '.join(kept)
    steps = os.environ.get('BD2_ORDER', '').strip() or steps
    assert steps and 'BD2' not in steps, steps
    print('landed: order after BD2:', steps)
    clause += f"Then, in the coordinator's order: {steps}; ask the coordinator for a slot. "
    lines[i] = '- **Queue:** ' + clause + rest
    rows = [k for k, l in enumerate(lines) if l.startswith('| **BD2: ')]
    assert len(rows) == 1, rows
    row = lines.pop(rows[0])
    BOARD.write_text('\n'.join(lines), encoding='utf-8')
    row = row.replace('| **BD2: not going out of a region, on the root**',
                      '| **BD2: not going out of a region, on the root, done**', 1)
    cells = row.split(' | ')
    assert len(cells) == 5, len(cells)
    cells[2] = (f'landed 2026-10-31 at core receipt `{receipt}`, study §{n}: `Becoming.GrammarCrossing` and '
                '`Becoming.ConveyanceBoundaries` in the core, `«所经必同»` proved from the step going out, every axiom '
                'report empty; the record not-going-out-of-a-region, conveyance-crosses-the-boundary and '
                'what-a-line-holds-and-a-regularity-takes-in amended; the independent review and its re-check '
                '([REVIEW](../../research/2026-10-05-generative-foundation-review/root-foundation/development/'
                'bd-boundaries/REVIEW.md)), every finding taken')
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
