#!/usr/bin/env python3
"""OU's owner's board closures (2 November 2026, the coordinator passing on the request that everything merged be
finished and every session say what it has left); board_og.py's pattern, run in a worktree, never the shared checkout.

head: put the closures' clause at the head of the Queue line, behind no other "landing now" clause.
land: the closures, and the landed clause in place of the head clause, ending with the coordinator's order sentence
      given verbatim in CLOSE_ORDER:
  - EC, U1b, RN and UE6, landed, titled done and moved to the history file after the last landed row, links rebased;
  - OU's row stays open and states what is left after the gate;
  - WHAT-REMAINS names what rides the next near-full rebuild of the grammar: BD4's three pieces, the quick Lean
    review's open findings in the grammar and six leaves, and one docstring in KeepingWidening;
  - three stale lines: the board's count of commits ahead, the push WHAT-REMAINS names, the central declarations' number.
usage (from the checkout root): python3 -B close_rows.py head | land"""
import os
import re
import sys
from pathlib import Path

BOARD = Path('_process/BECOMING-WORKBOARD.md')
HISTORY = Path('_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md')
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/'
REMAINS = Path(RF + 'ou3b-master-laws-on-the-grammar/WHAT-REMAINS.md')
HEAD = ("OU's owner's board closures at the head of the queue (landing now: EC, U1b, RN and UE6 closed into the "
        "history file, OU's row stating what is left after the gate, and WHAT-REMAINS naming what rides the next near-full rebuild of the grammar; documents only, no Lean, no record "
        "and no core run; then render, strict check, links, tests and both dossier checks, then the fast-forward); ")
LANDED = ("OU's owner's board closures landed (documents only: no Lean, no record and no core run): EC, U1b, RN and UE6 "
          "closed into the history file, each done (EC's measure closed by EC6 and OU3c to OU3e, U1b and RN the gate's "
          "items 3 and 6, UE6 as stated); OU's row open, stating what is left after the gate (plan §十三 items 6, 8, "
          "11 and item 9's institution, each to be claimed on its own, on Ren's word to go past the gate); "
          "WHAT-REMAINS naming what rides the next near-full "
          "rebuild of the grammar (BD4's three pieces, the quick Lean review's open findings in the grammar and six "
          "leaves, and one docstring in KeepingWidening); three stale lines brought current (the board's count of "
          "commits ahead, the push WHAT-REMAINS names, 117 central declarations since DU); render, strict check, links, tests and both dossier checks pass. ")
CLOSE = {
    '| **EC: an elegant completion**':
        '; closed 2 November 2026: EC6 then took the gaps from 13 to 4 (`994c9d10f`), and OU3c to OU3e closed the '
        'measure (§433, §437, §439): every central declaration follows from a shared law or has its reason (08 §7), '
        'so no declaration remains for EC',
    '| **U1b: amounts\' interface in the package**': '; closed 2 November 2026: the release gate\'s item 3 met',
    '| **UE6: the search for results no neighbouring field states**':
        '; closed 2 November 2026: done as stated; the scratch `Becoming.CoupledDrawers` stays in the study folder '
        'for 05\'s owner, no claim of this row\'s',
    '| **RN: the opening\'s notes, about three minutes each**':
        ' (`e825d6e1e`); closed 2 November 2026: the release gate\'s item 6 met',
}
OU = '| **OU: one-unfolding root, continuity (续) at the centre**'
OU_LEFT = ('; 2 November 2026: the release gate\'s items 1 to 6 are met, item 4 the last (OU7, §492), and item 7, the '
           'freeze, is Ren\'s; left after the gate (WHAT-REMAINS): plan §十三 item 6 (the map on each model class), '
           'item 8 (pairing and power with their uses, and the fragments mutual translation reaches, in Lean), item '
           '9\'s institution (OG having given the organism its model, §497) and item 11 (the three minimalities\' '
           'report, MDL and Pareto), each to be claimed as an item of its own on Ren\'s word to go past the gate')
REBUILD = '''## What rides the next near-full rebuild of the grammar (2 November 2026)

A change to Grammar, GrammarMap or GrammarLaws recompiles nearly every module, so such changes wait and go in one rebuild, as HE2's did. Each keeps its statement unless its owner decides otherwise.

- **BD4's three pieces** ("BD3 and BD4 landed" above): the counting lemmas of `«计»`, `paired_single`, and the merge of `unitsOn` with `Weightings.unitsOf`.
- **The quick Lean review's open findings in the grammar** ([FINDINGS](../qr-quick-lean-review/FINDINGS.md)):
  - in Grammar, `«火薪相须»`, `«四相无自立»`'s docstring and `«不复生则息»`;
  - in GrammarMap, `Endless.generation` and its siblings' identity-class witnesses, `«有终则粗不有常»` and `«不穷有终之定当且仅当排中»`;
  - in GrammarLaws, `«无后者不入亦不返»` and `«止而不入之例»`.
- **KeepingWidening's `Flow.whole_not_keepsWidening`**: its docstring's bold headline says nothing keeps widening, where its body and its statement say by name.
- **The review's six optional statement or name changes in leaves**: PremiseWitnesses, UnitMatchings, RevisionPlans, ReadStages, CountedCodes and Wholes. They ride the same rebuild so that one core run carries them.

The review's docstring-only findings outside the grammar ride UE29.

'''

# Stale lines the coordinator confirmed on main 2fd433b2d: a count of commits ahead that drifts, the push superseded,
# and the central declarations' number since DU.
AHEAD = ('main was 75 commits ahead of it when this line was written on 1 November (`git rev-list --count '
         'origin/main..main` gives the number now)',
         'main is ahead of it (`git rev-list --count origin/main..main` gives by how much)')
STALE = [
    ('A working version went out to GitHub at `d00f1724d` on 31 October 2026.',
     'A working version went out to GitHub on 31 October 2026, last at `74e2c9a69` (a push at `d00f1724d` that day '
     'came first).'),
    ('(全二). Of the 118 distinct central declarations, 44 reach the grammar',
     '(全二). Of the 118 distinct central declarations then (117 since DU took `Web.paths_comparison_widens` off its row; now 45, 16, 6 and 50, and the item met), 44 reach the grammar'),
]


def queue(lines):
    i = [k for k, l in enumerate(lines) if l.startswith('- **Queue:** ')]
    assert len(i) == 1, i
    return i[0]


def head():
    lines = BOARD.read_text(encoding='utf-8').split('\n')
    i = queue(lines)
    assert '(landing now' not in lines[i], 'another clause holds the head: ' + lines[i][:200]
    lines[i] = '- **Queue:** ' + HEAD + lines[i][len('- **Queue:** '):]
    BOARD.write_text('\n'.join(lines), encoding='utf-8')
    print('head: the closures at the head')


def land():
    order = os.environ.get('CLOSE_ORDER', '').strip()
    assert order.startswith("Then, in the coordinator's order: ") and order.endswith('ask the coordinator for a slot.'), order
    lines = BOARD.read_text(encoding='utf-8').split('\n')
    i = queue(lines)
    assert lines[i].startswith('- **Queue:** ' + HEAD), 'the closures do not hold the head'
    lines[i] = '- **Queue:** ' + LANDED + order + ' ' + lines[i][len('- **Queue:** ' + HEAD):]
    moved = []
    for title, closing in CLOSE.items():
        rows = [k for k, l in enumerate(lines) if l.startswith(title)]
        assert len(rows) == 1, (title, rows)
        row = lines.pop(rows[0])
        _, name, rest = row.split('**', 2)
        cells = ('| **' + name + ', done**' + rest).split(' | ')
        assert len(cells) == 5, (title, len(cells))
        cells[2] = cells[2].rstrip() + closing
        row = ' | '.join(cells)
        row = re.sub(r'\]\(\.\./theories/', '](../../../theories/', row)
        row = re.sub(r'\]\(research/', '](../../research/', row)
        row = re.sub(r'\]\(\.\./sources/', '](../../../sources/', row)
        moved.append(row)
    ou = [k for k, l in enumerate(lines) if l.startswith(OU)]
    assert len(ou) == 1, ou
    cells = lines[ou[0]].split(' | ')
    assert len(cells) == 5 and 'left after the gate' not in cells[2]
    cells[2] = cells[2].rstrip() + OU_LEFT
    lines[ou[0]] = ' | '.join(cells)
    lines = '\n'.join(lines)
    assert lines.count(AHEAD[0]) == 1
    BOARD.write_text(lines.replace(*AHEAD), encoding='utf-8')

    hist = HISTORY.read_text(encoding='utf-8').split('\n')
    k = hist.index('## Lapsed claims (18 October 2026)') - 1
    while k > 0 and not hist[k].startswith('| **'):
        k -= 1
    hist[k + 1:k + 1] = moved
    HISTORY.write_text('\n'.join(hist), encoding='utf-8')

    t = REMAINS.read_text(encoding='utf-8')
    a = '## What this note does not do\n'
    assert t.count(a) == 1 and 'What rides the next near-full rebuild of the grammar' not in t
    t = t.replace(a, REBUILD + a)
    for a, b in STALE:
        assert t.count(a) == 1, a[:60]
        t = t.replace(a, b)
    REMAINS.write_text(t, encoding='utf-8')
    print('closed', len(moved), 'rows after history line', k + 1)


if __name__ == '__main__':
    {'head': head, 'land': land}[sys.argv[1]]()
