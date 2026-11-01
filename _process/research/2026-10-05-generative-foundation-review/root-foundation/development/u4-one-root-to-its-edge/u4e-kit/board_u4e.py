#!/usr/bin/env python3
"""U4e's board edits, made in a worktree (never the shared checkout); board_u4d.py's pattern.

claim: add U4e's row at the end of the open claims.
head: put U4e's clause at the head of the Queue line, behind no other "landing now" clause.
head --rehearse: the same in a rehearsal's scratch tree, where another item may hold the head while U4e waits: that
      item's leading "(landing now …)" clause is stepped past (dropped from the scratch board only); nothing of it is
      committed.
landed RECEIPT N: replace U4e's head clause with the landed one, followed by the coordinator's order sentence, given
      verbatim in U4E_ORDER (required: the coordinator sends it with its word), and move U4e's row to the history
      file (titled done, its status the landing, its links rebased there), after the last landed row.
usage (from the checkout root): python3 -B board_u4e.py claim | head [--rehearse] | landed RECEIPT N"""
import datetime
import os
import re
import sys
from pathlib import Path

BOARD = Path('_process/BECOMING-WORKBOARD.md')
HISTORY = Path('_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md')
TITLE = "| **U4e: Identity's covering laws finished**"
U4 = "| **U4: one root to its edge**"
ROW = (TITLE + " (U4d's study §498, its boundary: \"the census recurrence laws keep decisions their proofs no longer "
       "use, left to Identity's laws' next change\"; census-balance-under-continuation's Next). "
       "`Web.arisingFrom_not_stopping_covered` re-proved as the root's «有覆而亡屡则生不止» at the formations' "
       "occurrences, statement unchanged (the root form, registered by U4d with no use on the base, gains its use); "
       "the four census recurrence laws and Persistence's `Web.persisting_census` drop the decision binders their "
       "proofs do not use, each keeping only the continuation's decision its direction needs; `RootForms.some_depends` "
       "states its witness (the Lean review's finding); the record and 01 §9.5's row say which decision each law takes | Claude Code desktop session \"time moves fast, for all our\" "
       "(U4's owner), 2 November 2026 | claimed 2 November 2026; Lean and texts on branch `u4e`; one core run when the "
       "coordinator gives the slot | `development/u4-one-root-to-its-edge/u4e-kit/`; at landing "
       "`Becoming/Identity.lean`, `Becoming/Persistence.lean`, `Becoming/RootForms.lean` | the coordinator for the core run's slot |")
HEAD = ("U4e at the head of the queue (landing now: Identity's covering laws finished, "
        "`Web.arisingFrom_not_stopping_covered` re-proved as the root's «有覆而亡屡则生不止» and the four census "
        "recurrence laws and `Web.persisting_census` dropping the decision binders their proofs do not use, "
        "`RootForms.some_depends` stating its witness, every other statement unchanged; one core run; then render, strict check, links, tests and both dossier checks, then the "
        "fast-forward); ")


def queue(text):
    lines = text.split('\n')
    i = [k for k, l in enumerate(lines) if l.startswith('- **Queue:** ')]
    assert len(i) == 1, i
    return lines, i[0]


def foreign_head(rest):
    """the length of another item's leading "X at the head of the queue (landing now …); " clause in `rest`, the Queue
    line after its label: its parentheses matched, then the "; " or ". " after them"""
    open_ = rest.find(' (landing now')
    assert open_ > 0 and ' at the head of the queue' in rest[:open_], 'no leading head clause: ' + rest[:200]
    depth = 0
    for k in range(open_ + 1, len(rest)):
        depth += {'(': 1, ')': -1}.get(rest[k], 0)
        if depth == 0:
            end = k + 1
            assert rest[end:end + 2] in ('; ', '. '), rest[open_:end + 10]
            return end + 2
    raise AssertionError('the head clause does not close: ' + rest[:200])


def claim():
    lines = BOARD.read_text(encoding='utf-8').split('\n')
    assert not any(l.startswith(TITLE) for l in lines), 'U4e already claimed'
    end = [k for k, l in enumerate(lines) if l.startswith('Not open claims, kept in history')]
    assert len(end) == 1, end
    k = end[0] - 1
    while not lines[k].startswith('| **'):
        k -= 1
    lines.insert(k + 1, ROW)
    BOARD.write_text('\n'.join(lines), encoding='utf-8')
    print('claim: U4e row added after board line', k + 1)


def head(rehearse=False):
    lines, i = queue(BOARD.read_text(encoding='utf-8'))
    line = lines[i]
    if rehearse and '(landing now' in line:
        rest = line[len('- **Queue:** '):]
        cut = foreign_head(rest)
        print('head --rehearse: stepped past', rest[:cut].split(' (landing now')[0])
        line = '- **Queue:** ' + rest[cut:]
    assert '(landing now' not in line, 'another clause holds the head: ' + line[:200]
    assert sum(l.startswith(TITLE) for l in lines) == 1, 'U4e not claimed'
    lines[i] = '- **Queue:** ' + HEAD + line[len('- **Queue:** '):]
    BOARD.write_text('\n'.join(lines), encoding='utf-8')
    print('head: U4e at the head')


def landed(receipt, n):
    lines, i = queue(BOARD.read_text(encoding='utf-8'))
    line = lines[i]
    assert line.startswith('- **Queue:** ' + HEAD), 'U4e does not hold the head'
    clause = (f"U4e landed (§{n}, core receipt `{receipt}`, every axiom report empty, one core run: Identity's covering "
              "laws finished. `Web.arisingFrom_not_stopping_covered` re-proved as the root's «有覆而亡屡则生不止», "
              "statement unchanged, the root form's register entry gone; the four census recurrence laws and "
              "Persistence's `Web.persisting_census` drop the decision binders their proofs do not use, each statement "
              "more general; `RootForms.some_depends` states its witness; the signature audit: every other statement of the "
              "three modules unchanged; "
              "census-balance-under-continuation's hypotheses, laws 4 and 12 and Next and 01 §9.5's row say which "
              "decision each law takes; one-root-to-its-edge's Next drops the item DU gave; the records citing what "
              "changed re-pointed and the two modules' proof bindings rebound; U4e's and U4's rows in the history file, "
              "what U4 leaves being the edge record's Next; render, strict check, links, tests and both dossier checks "
              "pass). ")
    rest = line[len('- **Queue:** ' + HEAD):]
    steps = os.environ.get('U4E_ORDER', '').strip()
    assert steps, "U4E_ORDER, the coordinator's order sentence sent with its word, is required"
    assert not re.search(r'\bU4e\b', steps), steps
    print('landed: order after U4e:', steps)
    clause += steps + ' '
    lines[i] = '- **Queue:** ' + clause + rest
    rows = [k for k, l in enumerate(lines) if l.startswith(TITLE)]
    assert len(rows) == 1, rows
    row = lines.pop(rows[0])
    BOARD.write_text('\n'.join(lines), encoding='utf-8')
    row = row.replace(TITLE, TITLE[:-2] + ', done**', 1)
    cells = row.split(' | ')
    assert len(cells) == 5, len(cells)
    cells[2] = (f'landed {datetime.date.today().isoformat()} at core receipt `{receipt}`, study §{n}: '
                'Web.arisingFrom_not_stopping_covered a case of the root\'s «有覆而亡屡则生不止»; the four census '
                'recurrence laws and Web.persisting_census without the decisions their proofs do not use, each '
                'statement more general, every other statement unchanged, every axiom report empty')
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
    # U4's row closes with U4e: what it leaves is the edge record's Next, unclaimed
    lines = BOARD.read_text(encoding='utf-8').split('\n')
    rows = [j for j, l in enumerate(lines) if l.startswith(U4)]
    assert len(rows) == 1, rows
    u4 = lines.pop(rows[0])
    BOARD.write_text('\n'.join(lines), encoding='utf-8')
    u4 = u4.replace(U4, U4[:-2] + ', done**', 1)
    cells = u4.split(' | ')
    assert len(cells) == 5, len(cells)
    cells[2] += (f' **Closed {datetime.date.today().isoformat()} with U4e (study §{n}):** levers 1 to 3, the leaf and '
                 'the boundary record, U4b, U4c, U4d and U4e landed; what is left is the edge record\'s Next (a '
                 'stretch form of the census on positions, of which `CensusWebs.keep_pace` would be a case; the root '
                 'reading of significance for the three rows keeping it free; HE2\'s laws read as cases at more '
                 'connected rows), unclaimed')
    u4 = ' | '.join(cells)
    u4 = re.sub(r'\]\(\.\./theories/', '](../../../theories/', u4)
    u4 = re.sub(r'\]\(research/', '](../../research/', u4)
    u4 = re.sub(r'\]\(\.\./sources/', '](../../../sources/', u4)
    hist.insert(k + 2, u4)
    HISTORY.write_text('\n'.join(hist), encoding='utf-8')
    print(f'landed: clause written, U4e\'s and U4\'s rows moved after history line {k + 1}')


if __name__ == '__main__':
    if sys.argv[1:] == ['claim']:
        claim()
    elif sys.argv[1:] in (['head'], ['head', '--rehearse']):
        head(rehearse=sys.argv[2:] == ['--rehearse'])
    elif len(sys.argv) == 4 and sys.argv[1] == 'landed':
        landed(sys.argv[2], int(sys.argv[3]))
    else:
        sys.exit(__doc__)
