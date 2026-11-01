#!/usr/bin/env python3
"""The board for U4c's figures, a documents slot after OU7 landed U4c's census: 08 §7's reach figures read off OU7's
core run, and U4c's and U4b's landed rows moved to the history file (board rule 4). From the checkout root of a
worktree on main's tip (the board is edited in one's own worktree):

  python3 -B <dir>/board_u4cf.py head            the head clause at the start of the Queue line
  python3 -B <dir>/board_u4cf.py landed ORDER    the head clause replaced by the landed clause and ORDER (the
                                                 coordinator's order sentence, verbatim); U4b's and U4c's rows moved
                                                 from the open claims to the history table's end, U4c's as landed

`head` refuses while any clause says "(landing now"; each step asserts that it applies once.

The slot, on the coordinator's word:
  1. On main's tip: `head`; commit the board alone, re-read the Queue line, fast-forward main.
  2. On branch u4c-figures: merge main; render.
  3. In a clean detached worktree of the branch: render (no change), check --strict-fresh, links, the tests and both
     dossier checks (review-packet/check_dossiers.py, default and on ue8's SCIENCES.md).
  4. `landed ORDER`; render; commit; re-read the Queue line; fast-forward main.
"""
import sys
from pathlib import Path

BOARD = Path('_process/BECOMING-WORKBOARD.md')
HISTORY = Path('_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md')
STUDY = 'research/2026-10-05-generative-foundation-review/root-foundation/development/u4-one-root-to-its-edge'
RECEIPT = '20261101T094230.205342Z'
NAME = "U4c's figures"
HEAD = (f"{NAME} at the head of the queue (landing now: documents only, no Lean, no record and no core run: 08 §7's "
        "reach figures read off OU7's core run with U4c's census in place, 46 of 126 rows reaching the grammar and 4 "
        "of them on no anchor, `Listed.coming_of_ceasing` the fourth; U4c's and U4b's landed rows moved to the "
        "history file; render, strict check, links, tests and the dossier checks, then the fast-forward)")
LANDED = (f"{NAME} landed (documents only, no Lean, no record and no core run): 08 §7's reach figures read off OU7's "
          f"core run `{RECEIPT}` with U4c's census in place: of the 126 central rows 86 rest on a shared law and 46 "
          "reach the grammar, 16 of 54 on balance and 4 on no anchor, `Listed.coming_of_ceasing` the fourth, through "
          "the root's census of a run; of the 117 distinct declarations 45 reach the grammar and 30 rest on balance; "
          "F5's report 45, 16, 6 and 50; no record cites the paragraph; U4c's row and U4b's moved to the history "
          "file as landed (board rule 4).")
U4B = '| **U4b: counting and amounts, one line**'
U4C = '| **U4c: the census on the root**'


def queue(rows):
    q = [j for j, x in enumerate(rows) if x.startswith('- **Queue:** ')]
    assert len(q) == 1, q
    return q[0]


def head():
    rows = BOARD.read_text(encoding='utf-8').split('\n')
    j = queue(rows)
    assert '(landing now' not in rows[j], ('a clause is landing now', rows[j][:300])
    assert NAME not in rows[j], f'{NAME} is on the Queue line already'
    rows[j] = '- **Queue:** ' + HEAD + '; ' + rows[j][len('- **Queue:** '):]
    BOARD.write_text('\n'.join(rows), encoding='utf-8')
    print('head clause written')


def for_history(row):
    """A board row's links, relative to _process/, made relative to the history file's folder."""
    return row.replace('](research/', '](../../research/').replace('](../sources/', '](../../../sources/')


def u4c_row(board_row):
    cols = board_row.split(' | ')
    assert len(cols) == 5 and cols[1].startswith('Claude Code desktop session'), len(cols)
    return ' | '.join([
        f"| **U4c: the census on the root, done** (the record `one-root-to-its-edge`'s first next step, \"a root form "
        f"for the census rows\"; [design](../../{STUDY}/CENSUS-ON-THE-ROOT.md)). GrammarLaws gains the census "
        "counted, with no decision of identity: the census of a step and its mirror, their count meeting in HE2's "
        "census, and the census of a run, each the corollary of a local form among the listed units. "
        "`Listed.coming_of_ceasing` re-proved as the run law at a member's occurrences, from counting to derived; "
        "`Listed.across_at` and `Web.Census.balanceFrom_at` re-proved as cases of the two halves; "
        "`CensusWebs.keep_pace` kept at counting with its reason; fifteen counting lemmas moved to the prelude with "
        "their names",
        cols[1],
        f"landed 2026-11-01 in OU7's rebuild as its stage `10-u4c` (main `e5951932b`, core receipt `{RECEIPT}`, "
        "study §492, every axiom report empty): GrammarLaws 192 theorems in 221 declarations; the boundary 11 "
        "derived, 1 under a stated hypothesis, 6 counting; the four roots it predicted registered apart; then 08 "
        "§7's reach figures read off that run in a documents landing (46 of 126 rows reach the grammar)",
        "`development/u4-one-root-to-its-edge/`; `Becoming/Prelude.lean`, `GrammarLaws.lean`, `Arising.lean`, "
        "`Change.lean`, `Flow.lean`, `Population.lean`, `Identity.lean`",
        "OU7's rebuild (landed); feeds the record's next step, the covering laws' root form |",
    ])


def figures_row(board_row):
    """This landing's own row."""
    return ' | '.join([
        f"| **{NAME}: 08 §7's reach figures read off OU7's core run (documents)** (U4c's census moved "
        "`Listed.coming_of_ceasing` from counting to derived, and 08 §7's connectivity paragraph still gave the counts "
        "from before it). Of the 126 central rows 86 rest on a shared law and 46 reach the grammar, 16 of 54 on "
        "balance and 4 on no anchor, `Listed.coming_of_ceasing` the fourth through the root's census of a run; of the "
        "117 distinct declarations 45 reach the grammar and 30 rest on balance; F5's report 45, 16, 6 and 50. U4c's "
        "and U4b's landed rows moved here (board rule 4)",
        board_row.split(' | ')[1],
        "landed 2026-11-01 (documents only, no Lean, no record and no core run): the figures as "
        "`measure_grammar.py` and `master_laws.py` give them on main `e5951932b` at core receipt "
        f"`{RECEIPT}`; no record cites the paragraph; render, strict check, links, tests and both dossier checks "
        "pass on the landing tree",
        f"[development/u4-one-root-to-its-edge/](../../{STUDY}/board_u4cf.py)",
        "U4c (landed with OU7), OU3b's measure |",
    ])


def land(order):
    assert order.startswith('Then') and order.endswith('.'), 'ORDER is the coordinator\'s sentence, verbatim'
    rows = BOARD.read_text(encoding='utf-8').split('\n')
    j = queue(rows)
    lead = '- **Queue:** ' + HEAD + '; '
    assert rows[j].startswith(lead), ('the head clause is not at the start of the Queue line', rows[j][:300])
    rows[j] = '- **Queue:** ' + LANDED + ' ' + order + ' ' + rows[j][len(lead):]
    b = [k for k, x in enumerate(rows) if x.startswith(U4B)]
    c = [k for k, x in enumerate(rows) if x.startswith(U4C)]
    assert len(b) == 1 and len(c) == 1 and c[0] == b[0] + 1, (b, c)
    moved = [for_history(rows[b[0]]), u4c_row(rows[c[0]]), figures_row(rows[c[0]])]
    del rows[b[0]:c[0] + 1]
    BOARD.write_text('\n'.join(rows), encoding='utf-8')
    h = HISTORY.read_text(encoding='utf-8').split('\n')
    assert not any(x.startswith(U4B) or x.startswith('| **U4c: ') for x in h), 'a row is in the history file already'
    last = next(k for k in range(len(h)) if h[k].startswith('## Lapsed claims')) - 1
    while not h[last].startswith('| **'):
        last -= 1
    h[last + 1:last + 1] = moved
    HISTORY.write_text('\n'.join(h), encoding='utf-8')
    print('landed clause written; U4b and U4c moved to the history file')


if __name__ == '__main__':
    if sys.argv[1:] == ['head']:
        head()
    elif sys.argv[1:2] == ['landed'] and len(sys.argv) == 3:
        land(sys.argv[2])
    else:
        sys.exit(__doc__)
