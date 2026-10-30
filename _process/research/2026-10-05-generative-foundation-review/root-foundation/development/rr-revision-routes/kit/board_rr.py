#!/usr/bin/env python3
"""RR's two board edits, made in the landing worktree (never the shared checkout).

claim: put RR's clause at the head of the Queue line, behind no other "landing now" clause, and set the order
       sentence to the coordinator's.
landed RECEIPT N: replace RR's head clause with the landed one, and move RR's row to the history file
       (titled done, its status the landing, its links rebased there), after the last landed row.
usage (from the checkout root): python3 -B board_rr.py claim | landed RECEIPT N"""
import re
import sys
from pathlib import Path

BOARD = Path('_process/BECOMING-WORKBOARD.md')
HISTORY = Path('_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md')
ORDER = ("Then, in the coordinator's order: GW's text fixes, item 13 with LW's follow-up, RV21b, AJ6b, MV, fm-cond1, "
         "LA4's formal part, MA4c; ask the coordinator for a slot.")
HEAD = ("RR at the head of the queue (landing now: `Becoming.RevisionRoutes` joined as a core leaf importing only the "
        "prelude, with `Becoming.ReadStages` taking its order from it; one incremental core run; one new record, "
        "when-no-route-stands-above-a-revision, and RF7's record amended; 07 §7, 03 §11, 08, the overview, the alignment "
        "dossier and FAILURE-MODE-MAP §6; the records citing the rewritten sections re-pointed; then render, strict "
        "check, links and tests, then the fast-forward); ")


def queue(text):
    lines = text.split('\n')
    i = [k for k, l in enumerate(lines) if l.startswith('- **Queue:** ')]
    assert len(i) == 1, i
    return lines, i[0]


def claim():
    text = BOARD.read_text(encoding='utf-8')
    lines, i = queue(text)
    line = lines[i]
    assert '(landing now' not in line, 'another clause holds the head: ' + line[:200]
    assert not line.startswith('- **Queue:** RR '), 'RR already at the head'
    found = re.findall(r"Then, in the coordinator's order: .*?ask the coordinator for a slot\.", line)
    assert len(found) == 1, found
    line = line.replace(found[0], ORDER)
    lines[i] = '- **Queue:** ' + HEAD + line[len('- **Queue:** '):]
    BOARD.write_text('\n'.join(lines), encoding='utf-8')
    print('claim: RR at the head; order sentence set')


def landed(receipt, n):
    text = BOARD.read_text(encoding='utf-8')
    lines, i = queue(text)
    line = lines[i]
    assert line.startswith('- **Queue:** ' + HEAD), 'RR does not hold the head'
    clause = (f"RR landed (§{n}, core receipt `{receipt}`, every axiom report empty, one incremental core run: "
              "`Becoming.RevisionRoutes` as a core leaf importing only the prelude, 28 theorems in 43 declarations, "
              "and `Becoming.ReadStages` taking its order from it, 57 theorems in 79 declarations, every statement and "
              "name kept: the order of a gain and a loss; when no route of keeping a formation's law stands above "
              "letting a revision of it go through, ties included; its exits; at every loss of the routes exactly where "
              "every route's kept value with the revision's loss is at most the revision's kept value, and at every "
              "value and loss exactly where no route keeps the law more surely than the revision does and the revision "
              "loses nothing beyond; restoring the revised-from law as the lever; RF7's four plans as a revision with "
              "three routes, complying at both maximal exactly where `k_C V = k_O V = c T = 0`; record "
              "when-no-route-stands-above-a-revision, home 07 §7, and RF7's record amended as its owner asked, rule 9 "
              "decided with RF's owner; 03 §11 with RF's two edits, 08, the overview, the alignment dossier's "
              "corrigibility bullet with RF-M.2's sentence kept, FAILURE-MODE-MAP §6 as its owner agreed; an "
              "independent cross-model review, every finding taken; the records citing the rewritten sections "
              "re-pointed, nothing they say changed; RR's row in the history file; render, strict check, links and "
              "tests pass); ")
    lines[i] = '- **Queue:** ' + clause + line[len('- **Queue:** ' + HEAD):]
    rows = [k for k, l in enumerate(lines) if l.startswith('| **RR: corrigibility on the map')]
    assert len(rows) == 1, rows
    row = lines.pop(rows[0])
    BOARD.write_text('\n'.join(lines), encoding='utf-8')
    row = row.replace('| **RR: corrigibility on the map — a revision and the routes of keeping a law**',
                      '| **RR: corrigibility on the map — a revision and the routes of keeping a law, done**', 1)
    cells = row.split(' | ')
    assert len(cells) == 5, len(cells)
    cells[2] = (f'landed 2026-10-30 at core receipt `{receipt}`, study §{n}: `Becoming.RevisionRoutes` (28 theorems in 43 '
                'declarations), a new core leaf importing only the prelude, and `Becoming.ReadStages` (57 in 79) taking its order '
                'from it, every axiom report empty; the record when-no-route-stands-above-a-revision, RF7\'s record amended; '
                'the independent review ([REVIEW](../../research/2026-10-05-generative-foundation-review/root-foundation/'
                'development/rr-revision-routes/REVIEW.md)), every finding taken; RF\'s and FAILURE-MODE-MAP\'s owners agreed '
                'to the edits in their texts')
    row = ' | '.join(cells)
    row = row.replace('at every cost of the routes', 'at every loss of the routes').replace(
        'the revision costs nothing beyond', 'the revision loses nothing beyond')
    row = re.sub(r'\]\(research/', '](../../research/', row)
    row = re.sub(r'\]\(\.\./sources/', '](../../../sources/', row)
    row = re.sub(r'\]\(history/', '](../', row)
    hist = HISTORY.read_text(encoding='utf-8').split('\n')
    lapsed = hist.index('## Lapsed claims (18 October 2026)')
    k = lapsed - 1
    while k > 0 and not hist[k].startswith('| **'):
        k -= 1
    hist.insert(k + 1, row)
    HISTORY.write_text('\n'.join(hist), encoding='utf-8')
    print(f'landed: clause written, row moved after history line {k + 1}')


if __name__ == '__main__':
    if sys.argv[1] == 'claim':
        claim()
    elif sys.argv[1] == 'landed':
        landed(sys.argv[2], int(sys.argv[3]))
    else:
        sys.exit(__doc__)
