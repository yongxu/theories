#!/usr/bin/env python3
"""RR2's board edits, made in a worktree (never the shared checkout).

row: add RR2's claim row at the end of the open claims table.
head: put RR2's clause at the head of the Queue line, behind no other "landing now" clause; the coordinator's order
      sentence is kept as it stands.
landed RECEIPT N: replace RR2's head clause with the landed one, and move RR2's row to the history file (titled done,
      its status the landing, its links rebased there), after the last landed row.
usage (from the checkout root): python3 -B board_rr2.py row | head | landed RECEIPT N"""
import os
import re
import sys
from pathlib import Path

BOARD = Path('_process/BECOMING-WORKBOARD.md')
HISTORY = Path('_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md')
HEAD = ("RR2 at the head of the queue (landing now: `Becoming.RevisionPlans` joined to the core below "
        "`Becoming.HeldForReading`, which derives from it its balances, ties, thresholds and comparisons with an amount "
        "forgone, every statement and name kept, and `ListingValuation.forgone_lt_iff` from its order; one incremental "
        "core run; one new record, when-holding-for-a-reading-stands-above-a-route, and RF-M.2's, RR's and RF-M.3's "
        "records amended; 07 §7, 03 §12, 08 §8 and the alignment dossier; the records citing the rewritten sections "
        "re-pointed; then render, strict check, links and tests, then the fast-forward); ")
NOTE = 'research/2026-10-05-generative-foundation-review/root-foundation/development/rr-revision-routes/NOTE.md'
ROW = (
    "| **RR2: holding for a reading against the routes of keeping, one order** "
    "([Ren, 31 October 2026](../sources/15-codex-theory-conversations/2026-10-31-join-and-unify.md); RR's note §9, "
    f"the off-switch game's information value not yet joined to RR's prospects; [note §10]({NOTE})). Purpose: one account "
    "of corrigibility as an incentive, RR's routes of keeping a law and RF-M.2's value of holding an act for a reading "
    "(the off-switch game) on one order, for the alignment dossier's corrigibility bullet. New Lean: "
    "`Becoming.RevisionPlans`, a core module below `HeldForReading` (importing Flow, Dissipation and `RevisionRoutes`): "
    "a plan keeps the law going on at some weight and switches it off at some weight at each candidate of a formation's "
    "model, and has a loss of its own, ordered by RR's `GainLoss`; the balance, every two plans splitting the weights "
    "gaining the same with their excesses, so that between them the order is that of each one's own loss with its "
    "excess; RR's revision and routes as plans on one candidate; moving weight between keeping and switching off. "
    "`HeldForReading` imports it and derives from it its balances, ties, thresholds and comparisons with an amount "
    "forgone, every "
    "statement kept and the direct proofs gone (rule 9, with RF's owner), and `ListingValuation.forgone_lt_iff` "
    "comes from its order. Record working title "
    "when-holding-for-a-reading-stands-above-a-route, home 07 §7 (with RF's owner) "
    "| Claude Code desktop session (corrigibility on the map), 31 October 2026 "
    "| claimed: note §10 written; scratch Lean built with the checker's cache (`RevisionPlans` 33 theorems in 48 "
    "declarations, `HeldForReading` 97 in 127, RF-M.3's `ListingValuation` 138 in 186 on them, every axiom report "
    "empty); an independent review (one blocker, rule 9, and eight more) and its re-check taken; RF's owner agreed to "
    "land below with HeldForReading's statements unchanged, the final diff with them; core slot after RF-M.3 "
    "| `development/rr-revision-routes/` "
    "| RR, RF-M.2 → 07 §7, the alignment dossier's corrigibility bullet, FAILURE-MODE-MAP §6 |")


def row():
    lines = BOARD.read_text(encoding='utf-8').split('\n')
    assert not any(l.startswith('| **RR2:') for l in lines), 'RR2 already claimed'
    start = lines.index('## Open claims')
    end = [k for k in range(start + 1, len(lines)) if lines[k].startswith('## ')][0]
    rows = [k for k in range(start, end) if lines[k].startswith('| **')]
    assert rows, 'no rows'
    lines.insert(rows[-1] + 1, ROW)
    BOARD.write_text('\n'.join(lines), encoding='utf-8')
    print(f'row: RR2 added after line {rows[-1] + 1}')



def queue(text):
    lines = text.split('\n')
    i = [k for k, l in enumerate(lines) if l.startswith('- **Queue:** ')]
    assert len(i) == 1, i
    return lines, i[0]


def head():
    lines, i = queue(BOARD.read_text(encoding='utf-8'))
    line = lines[i]
    assert '(landing now' not in line, 'another clause holds the head: ' + line[:200]
    assert any(l.startswith('| **RR2:') for l in lines), 'RR2 not claimed'
    lines[i] = '- **Queue:** ' + HEAD + line[len('- **Queue:** '):]
    BOARD.write_text('\n'.join(lines), encoding='utf-8')
    print('head: RR2 at the head')


def landed(receipt, n):
    lines, i = queue(BOARD.read_text(encoding='utf-8'))
    line = lines[i]
    assert line.startswith('- **Queue:** ' + HEAD), 'RR2 does not hold the head'
    clause = (f"RR2 landed (§{n}, core receipt `{receipt}`, every axiom report empty, one incremental core run: "
              "`Becoming.RevisionPlans` joined to the core below `Becoming.HeldForReading`, 33 theorems in 48 "
              "declarations: plans keeping a law going on and switching it off at a model's candidates, each with a "
              "loss of its own, on RR's order; the balance, every two plans splitting the weights gaining the same "
              "with their excesses, so that between them one stands above another exactly where its loss with its "
              "excess is below the other's; RR's revision and routes as plans on one candidate; `HeldForReading` "
              "deriving from it its balances, ties, thresholds and comparisons with an amount forgone, holding for a "
              "rule being a plan whose excess is the rule's shortfall, every statement and name kept and its direct "
              "proofs gone (rule 9, with RF's owner), 97 theorems in 127 declarations, and "
              "`ListingValuation.forgone_lt_iff` from its order; record when-holding-for-a-reading-stands-above-a-route, "
              "home 07 §7, and RF-M.2's, RR's and RF-M.3's records amended; 07 §7, 03 §12, 08 §8 (with X19 of RF-M.3's "
              "cold read, RR's bullet pointing to the next), the alignment dossier, the root module's bullets, the "
              "checker's scope and both READMEs; an independent cross-model review and its re-check, every finding "
              "taken; the records citing the rewritten sections re-pointed, nothing they say changed; RR2's row in the "
              "history file; render, strict check, links and tests pass). ")
    # the coordinator's order as the clause after it gives it, RR2 taken out
    rest = line[len('- **Queue:** ' + HEAD):]
    # the latest order sentence on the line, in whichever clause carries it (a short landing may carry none)
    order = re.search(r"Then, in the coordinator's order: ([^;]*); ask the coordinator for a slot\.", rest)
    steps = order.group(1) if order else ''
    # RR2's step taken out: a step naming RR2 alone goes, a step naming RR2 or HE2 keeps HE2
    kept = []
    for part in steps.split(' → '):
        if part.startswith(('RR2 or HE2', 'HE2 or RR2')):
            kept.append('HE2')
        elif not part.startswith('RR2'):
            kept.append(part)
    steps = ' → '.join(kept)
    # the coordinator's sentence for the landing, where it gave one (RR2_ORDER), over the derived one
    steps = os.environ.get('RR2_ORDER', '').strip() or steps
    assert steps and 'RR2' not in steps, steps
    print('landed: order after RR2:', steps)
    clause += f"Then, in the coordinator's order: {steps}; ask the coordinator for a slot. "
    lines[i] = '- **Queue:** ' + clause + rest
    rows = [k for k, l in enumerate(lines) if l.startswith('| **RR2: ')]
    assert len(rows) == 1, rows
    row = lines.pop(rows[0])
    BOARD.write_text('\n'.join(lines), encoding='utf-8')
    # the claim's wording before HeldForReading's owner's last note, brought to it
    row = row.replace('proves from it its balances, ties, thresholds and amounts forgone',
                      'derives from it its balances, ties, thresholds and comparisons with an amount forgone')
    row = row.replace('| **RR2: holding for a reading against the routes of keeping, one order**',
                      '| **RR2: holding for a reading against the routes of keeping, one order, done**', 1)
    cells = row.split(' | ')
    assert len(cells) == 5, len(cells)
    cells[2] = (f'landed 2026-10-31 at core receipt `{receipt}`, study §{n}: `Becoming.RevisionPlans` below '
                '`HeldForReading`, which takes its two balances from it, every axiom report empty; the record '
                'when-holding-for-a-reading-stands-above-a-route, RF-M.2\'s and RR\'s records amended; the independent '
                'review and its re-check ([REVIEW](../../research/2026-10-05-generative-foundation-review/root-foundation/'
                'development/rr-revision-routes/REVIEW.md)), every finding taken; RF\'s owner reviewed the change to '
                'its module')
    row = ' | '.join(cells)
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
    if sys.argv[1:] == ['row']:
        row()
    elif sys.argv[1:] == ['head']:
        head()
    elif sys.argv[1] == 'landed':
        landed(sys.argv[2], int(sys.argv[3]))
    else:
        sys.exit(__doc__)
