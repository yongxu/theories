#!/usr/bin/env python3
"""The board for the correction of C's premise entry in one-root-to-its-edge, a documents slot of its own, from the
checkout root of a worktree on main's tip (the board is edited in one's own worktree):

  python3 -B <dir>/board_u4pc.py head            the head clause at the start of the Queue line
  python3 -B <dir>/board_u4pc.py landed RECEIPT  the head clause replaced by the landed clause and the coordinator's
                                                 order, and the row after the history table's last row (RECEIPT: the
                                                 core receipt master_laws.py was rerun on)

`head` refuses while any clause says "(landing now"; each step asserts that it applies once.

The slot, in the coordinator's order (1 November 2026): after EL, the collective page's fixes, OPENING's follow-up,
UE28 and TX have landed, and no "(landing now" clause stands.
  1. On main's tip: `head`; commit the board alone, re-read the Queue line, fast-forward main.
  2. On branch u4-premise-c: merge main; rerun tools/research/master_laws.py (the core receipt current then); render.
  3. In a clean detached worktree of the branch: render (no change), check --strict-fresh, links, lint on the record,
     the tests, and both dossier checks (review-packet/check_dossiers.py, default and on ue8's SCIENCES.md).
  4. `landed RECEIPT`; render; commit; re-read the Queue line; fast-forward main.
  5. Re-cut stage 10-u4c on the new main (u4c-stage/cut_u4c_patches.py) before OU7's rehearsal.
"""
import sys
from pathlib import Path

BOARD = Path('_process/BECOMING-WORKBOARD.md')
HISTORY = Path('_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md')
STUDY = 'research/2026-10-05-generative-foundation-review/root-foundation/development/u4-one-root-to-its-edge'
NAME = "U4's C line"
HEAD = (f"{NAME} at the head of the queue (landing now: the record one-root-to-its-edge only, no Lean, no chapter change "
        "and no core run: C's entry among the premises of the ethics names `ReadsNoOrder.not_entails` as its theorem "
        "of not being entailed, and the non-implication on the premises' warrant says neither is entailed by "
        "statements of the dynamics, each under its condition; master_laws.py rerun on the current core receipt; "
        "render, strict check, links, tests and the dossier checks, then the fast-forward)")
# The coordinator's order sentence for this landed clause, verbatim (1 November 2026).
ORDER = ("Then, in the coordinator's order: core items, by readiness: SJ's leaf, then OU7's rebuild with U4c's and ND's "
         "Lean stages, ND's record id and final renames after it; ask the coordinator for a slot.")


def landed(receipt):
    return (f"{NAME} landed (the record one-root-to-its-edge only, no Lean, no chapter change and no core run): C's "
            "entry among the premises of the ethics names `ReadsNoOrder.not_entails` (DU) as its theorem of not being "
            "entailed, read against the field (development/u4-one-root-to-its-edge/REVIEW-U4-PREMISE-C.md, an AI "
            "reading): a statement whose truth does not change with the order, entailing C at a datum on a frame with "
            "an extension, fails there at every order; the reason for its absence dropped and the basis stating the "
            "condition; the non-implication on the premises' warrant says neither is entailed by statements of the "
            "dynamics, the condition given a standpoint and a formation, C given a frame with an extension, and each "
            f"warrant is open; master_laws.py rerun on core receipt `{receipt}` (C: not entailed); the row in the "
            f"history file). {ORDER}")


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


def land(receipt):
    rows = BOARD.read_text(encoding='utf-8').split('\n')
    j = queue(rows)
    lead = '- **Queue:** ' + HEAD + '; '
    assert rows[j].startswith(lead), ('the head clause is not at the start of the Queue line', rows[j][:300])
    rows[j] = '- **Queue:** ' + landed(receipt) + ' ' + rows[j][len(lead):]
    BOARD.write_text('\n'.join(rows), encoding='utf-8')
    h = HISTORY.read_text(encoding='utf-8').split('\n')
    assert not any(x.startswith(f"| **{NAME}") for x in h), 'the history row is there already'
    last = next(k for k in range(len(h)) if h[k].startswith('## Lapsed claims')) - 1
    while not h[last].startswith('| **'):
        last -= 1
    row = ' | '.join([
        f"| **{NAME}: C's premise entry in one-root-to-its-edge, named by its theorem (documents)** (LN's landing "
        "found the record's boundary field stale since DU: C's entry still said no theorem shows it unentailed by the "
        "dynamics). `ReadsNoOrder.not_entails` read against the field: `ReadsOnlyDynamics.not_entails` with the order "
        "in the place of the significance, under a frame with an extension (needed: with none, C holds at every order), "
        "entailment asked at one datum only, immediate; C's `not_entailed` set, the reason for its absence dropped, "
        "the basis stating the condition; the non-implication on the premises' warrant brought into line",
        'Claude Code desktop session "time moves fast, for all our" (U4\'s owner), 1 November 2026',
        f"landed 2026-11-01 (a record correction, no Lean, no chapter change and no core run): an AI reading, "
        f"REVIEW-U4-PREMISE-C.md; master_laws.py rerun on core receipt `{receipt}`, C's result not entailed; render, "
        "strict check, links, the record's lint, tests and both dossier checks pass on the landing tree",
        f"[development/u4-one-root-to-its-edge/](../../{STUDY}/REVIEW-U4-PREMISE-C.md)",
        "DU (`Becoming.PremiseWitnesses`), LN (its note), U4c (its stage re-cut on top) |",
    ])
    h.insert(last + 1, row)
    HISTORY.write_text('\n'.join(h), encoding='utf-8')
    print('landed clause and history row written')


if __name__ == '__main__':
    if sys.argv[1:] == ['head']:
        head()
    elif sys.argv[1:2] == ['landed'] and len(sys.argv) == 3:
        land(sys.argv[2])
    else:
        sys.exit(__doc__)
