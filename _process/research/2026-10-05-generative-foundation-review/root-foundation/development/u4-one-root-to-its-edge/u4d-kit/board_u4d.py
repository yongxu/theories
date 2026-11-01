#!/usr/bin/env python3
"""U4d's board edits, made in a worktree (never the shared checkout); board_el6.py's pattern.

head: put U4d's clause at the head of the Queue line, behind no other "landing now" clause; the coordinator's order
      sentence is kept as it stands.
head --rehearse: the same in a rehearsal's scratch tree, where another item may hold the head while U4d waits: that
      item's leading "(landing now …)" clause is stepped past (dropped from the scratch board only), so that every later
      step is rehearsed; nothing of it is committed.
landed RECEIPT N: replace U4d's head clause with the landed one, followed by the coordinator's order sentence, given
      verbatim in U4D_ORDER (required: the coordinator sends it with its word), and move U4d's row to the history
      file (titled done, its status the landing, its links rebased there), after the last landed row.
usage (from the checkout root): python3 -B board_u4d.py head [--rehearse] | landed RECEIPT N"""
import datetime
import os
import re
import sys
from pathlib import Path

BOARD = Path('_process/BECOMING-WORKBOARD.md')
HISTORY = Path('_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md')
TITLE = "| **U4d: the covering laws on the root**"
HEAD = ("U4d at the head of the queue (landing now: the covering laws on the root, `Becoming.GrammarLaws` gaining ends "
        "on lines, the census of a run proved through them with two hypotheses dropped; Locality's, Decidedness' and "
        "Identity's covering laws re-proved as cases, statements unchanged, and Identity's exact forms from covering "
        "lists new; the prelude and Population touched; one core run; then render, strict check, links, tests and both "
        "dossier checks, then the fast-forward); ")


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


def head(rehearse=False):
    lines, i = queue(BOARD.read_text(encoding='utf-8'))
    line = lines[i]
    if rehearse and '(landing now' in line:
        rest = line[len('- **Queue:** '):]
        cut = foreign_head(rest)
        print('head --rehearse: stepped past', rest[:cut].split(' (landing now')[0])
        line = '- **Queue:** ' + rest[cut:]
    assert '(landing now' not in line, 'another clause holds the head: ' + line[:200]
    assert sum(l.startswith(TITLE) for l in lines) == 1, 'U4d not claimed'
    lines[i] = '- **Queue:** ' + HEAD + line[len('- **Queue:** '):]
    BOARD.write_text('\n'.join(lines), encoding='utf-8')
    print('head: U4d at the head')


def landed(receipt, n):
    lines, i = queue(BOARD.read_text(encoding='utf-8'))
    line = lines[i]
    assert line.startswith('- **Queue:** ' + HEAD), 'U4d does not hold the head'
    clause = (f"U4d landed (§{n}, core receipt `{receipt}`, every axiom report empty, one core run: the covering "
              "laws on the root. `Becoming.GrammarLaws` gains lines from a list (the count «线终不过所列», endings and "
              "beginnings on lines, «迭之定于» now the case of «分处定后则迭之定于») and ends on lines at stages (the "
              "stretch form «间无生则间亡不过所覆», its mirror, and the run forms); the census of a run "
              "(`GrammarLaws.census_run`, «定后前者在前则亡屡者生屡») proved through the stretch form, stronger, the units "
              "after each step listed once and the test of endings dropped; Locality's four covering laws, Decidedness' "
              "two counts and Identity's three covering laws re-proved as cases, statements unchanged, Identity's exact "
              "forms from covering lists new and its census recurrence laws their cases; eight helpers with no consumer "
              "gone; the signature audit: every other statement unchanged; records shared-laws-on-the-grammar (law 19, "
              "ends on lines) and census-balance-under-continuation (law 12, the exact forms), six more naming their "
              "routes, one-root-to-its-edge's next step; 01 §7 and §9.5; the root module's bullet and both package "
              "READMEs; the connectivity register; the shared laws' view rerun, 08 §7's figures unchanged; the records "
              "citing what changed re-pointed and the changed modules' proof bindings rebound; U4d's row in the history "
              "file; render, strict check, links, tests and both dossier checks pass). ")
    rest = line[len('- **Queue:** ' + HEAD):]
    # the coordinator computes the order from what is still queued when it gives the word, and sends it verbatim
    steps = os.environ.get('U4D_ORDER', '').strip()
    assert steps, "U4D_ORDER, the coordinator's order sentence sent with its word, is required"
    assert not re.search(r'\bU4d\b', steps), steps
    print('landed: order after U4d:', steps)
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
    cells[2] = (f'landed {datetime.date.today().isoformat()} at core receipt `{receipt}`, study §{n}: one count on '
                'lines from a list in GrammarLaws, the covering laws of Locality, Decidedness and Identity and the census '
                'of a run its cases, the census of a run stronger (two hypotheses dropped), Identity\'s exact forms new, '
                'every other statement unchanged, every axiom report empty '
                '([design](../../research/2026-10-05-generative-foundation-review/root-foundation/development/'
                'u4-one-root-to-its-edge/COVERING-ON-THE-ROOT.md))')
    old = '`Becoming/GrammarLaws.lean`, `Becoming/Locality.lean`, `Becoming/Identity.lean`'
    assert cells[3].count(old) == 1, cells[3]
    cells[3] = cells[3].replace(old, '`Becoming/Prelude.lean`, `Becoming/GrammarLaws.lean`, `Becoming/Population.lean`, '
                                '`Becoming/Locality.lean`, `Becoming/Decidedness.lean`, `Becoming/Identity.lean`')
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
    if sys.argv[1:] in (['head'], ['head', '--rehearse']):
        head(rehearse=sys.argv[2:] == ['--rehearse'])
    elif len(sys.argv) == 4 and sys.argv[1] == 'landed':
        landed(sys.argv[2], int(sys.argv[3]))
    else:
        sys.exit(__doc__)
