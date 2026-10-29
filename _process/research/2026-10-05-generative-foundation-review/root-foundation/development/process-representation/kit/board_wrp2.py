#!/usr/bin/env python3
"""WRP2 (WRT2's board_wrt2.py): the board row. `claim OWNER STATE` sets the proposed row's owner and state;
`head TEXT` puts WRP2's head-of-queue clause, "WRP2 at the head of the queue (TEXT); ", on the queue note, behind
every earlier claim (board rule 5); `land RECEIPT N QUEUE STATE` moves the row, its state set to STATE and its statements brought to
what the Lean shows (STATEMENTS), to the
history file after the last landed row, drops WRP2's head-of-queue clause, puts QUEUE at the head of the queue note
and names the receipt as the latest.
usage (from the checkout root): python3 -B board_wrp2.py claim OWNER STATE | python3 -B board_wrp2.py head TEXT |
       python3 -B board_wrp2.py land RECEIPT N QUEUE STATE"""
import datetime
import json
import os
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
BOARD = ROOT / '_process/BECOMING-WORKBOARD.md'
HISTORY = ROOT / '_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md'
HEAD = re.compile(r'WRP2 at the head of the queue \([^()]*\); ')
CLAIM = re.compile(r'[A-Z][A-Za-z0-9]* at the head of the queue \([^()]*\); ')
TODAY = datetime.date.today()
# the row's statements, brought to what the Lean shows after the review, in the row moved to history; the last is
# filled from the receipt
STATEMENTS = [
    ("and correspondence lemmas for the terms WRP2 reads (proposed, not checked).",
     "and the correspondence lemmas for the terms a renaming of a process reads, passing through a word with its "
     "letters renamed among them, and correspondences side by side."),
    ("the composite of a family of relations along a word («历», adopted: passing through a word's relations in turn), "
     "`«迭»` its case for a constant family, with its laws (two words, the last letter, the reversed word with the "
     "converse family, merging nothing, going alike)",
     "the composite of relations along a word («历», adopted: passing through a word's relations in turn), `«迭»` its "
     "case for one relation repeated, with its laws (two words, the last letter, the reversed word with the converse "
     "relations, merging nothing, going alike)"),
    ("a law over processes holds of every family of relations, and one reading only the steps of every relation "
     "(`forall_steps_iff`)",
     "a law over processes holds of all relations indexed by moves, and one reading only the steps of every relation "
     "(`forall_steps_iff`)"),
    ("the twist and the flip (up to correspondence neither the class of the same move nor that of the same "
     "configuration alone makes that model faithful);",
     "with both classes that model faithful up to correspondence from a configuration and a move "
     "(`renaming_of_withMove`, `withMove_of_renaming`), a renaming keeping the bridged notions (`renaming_trace`, "
     "`renaming_determined` and the others), and the twist and the flip showing neither class alone suffices;"),
    ("Every statement but the proposed ones was checked in a scratch build (53 theorems in 66 declarations, every axiom "
     "report empty, nothing landed).", None),
]

board = BOARD.read_text(encoding='utf-8').split('\n')
rows = [i for i, line in enumerate(board) if line.startswith('| **WRP2: ')]
assert len(rows) == 1, rows
cells = board[rows[0]].split(' | ')
assert len(cells) == 5, len(cells)
queue = [i for i, line in enumerate(board) if line.startswith('- **Queue:** ')]
assert len(queue) == 1, queue


def history_links(row):
    """The row's links, relative to the board, re-pointed for the history file."""
    def fix(m):
        target = m.group(1)
        if re.match(r'[a-z]+:|#', target):
            return m.group(0)
        path, _, frag = target.partition('#')
        full = os.path.normpath(os.path.join('_process', path))
        assert (ROOT / full).exists(), full
        return '](' + os.path.relpath(full, '_process/history/workboard') + ('#' + frag if frag else '') + ')'
    return re.sub(r'\]\(([^)]+)\)', fix, row)


if sys.argv[1] == 'claim':
    assert cells[1].startswith('— (proposed') and cells[2].startswith('proposed'), 'the row is not unclaimed'
    cells[1], cells[2] = sys.argv[2], sys.argv[3]
    board[rows[0]] = ' | '.join(cells)
    BOARD.write_text('\n'.join(board), encoding='utf-8')
elif sys.argv[1] == 'head':
    note = board[queue[0]]
    assert not HEAD.findall(note), 'a head-of-queue clause is already there'
    clause = f'WRP2 at the head of the queue ({sys.argv[2]}); '
    assert HEAD.fullmatch(clause), clause
    # behind every earlier claim: after the run of head-of-queue clauses that opens the note
    at = len('- **Queue:** ')
    while (m := CLAIM.match(note, at)):
        at = m.end()
    board[queue[0]] = note[:at] + clause + note[at:]
    BOARD.write_text('\n'.join(board), encoding='utf-8')
elif sys.argv[1] == 'land':
    receipt, section, queue_text, state_text = sys.argv[2], int(sys.argv[3]), sys.argv[4], sys.argv[5]
    assert f'§{section}' in queue_text and receipt in queue_text
    cells[2] = state_text
    core = json.loads((ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming/'
                       'becoming-checks' / receipt / 'verification.json').read_text())
    mods = {m['module']: m for m in core['modules']}
    count = lambda m: f"{mods[m]['theorems']} theorems in {len(mods[m]['declarations'])} declarations"
    last = (f"After an independent review of the Lean, every finding taken: GrammarLaws ({count('Becoming.GrammarLaws')}), "
            f"GrammarTransport ({count('Becoming.GrammarTransport')}) and ProcessRepresentation "
            f"({count('Becoming.ProcessRepresentation')}), every axiom report empty, at core receipt `{receipt}`; the "
            f"signature audit shows only additions and six changed proofs; record processes-represented-both-ways "
            f"(01 §8.1), and a law added to master-laws-on-the-grammar.")
    for old, new in STATEMENTS:
        assert cells[0].count(old) == 1, old[:60]
        cells[0] = cells[0].replace(old, new if new is not None else last)
    row = history_links(' | '.join(cells))
    del board[rows[0]]
    queue = [i for i, line in enumerate(board) if line.startswith('- **Queue:** ')]
    assert len(queue) == 1
    assert len(HEAD.findall(board[queue[0]])) == 1, 'head-of-queue clause'
    board[queue[0]] = HEAD.sub('', board[queue[0]], count=1)
    board[queue[0]] = board[queue[0]].replace('- **Queue:** ', '- **Queue:** ' + queue_text + '; ', 1)
    latest = [i for i, line in enumerate(board) if 'the latest core receipt is' in line]
    assert len(latest) == 1, latest
    m = re.search(r"the latest core receipt is [^;]*?`(\d{8}T\d{6}\.\d+Z)` \(\d{1,2} October 2026\)", board[latest[0]])
    assert m, 'latest receipt sentence'
    board[latest[0]] = board[latest[0]].replace(
        m.group(0), f"the latest core receipt is WRP2's `{receipt}` ({TODAY.day} {TODAY:%B} {TODAY.year})")
    BOARD.write_text('\n'.join(board), encoding='utf-8')
    history = HISTORY.read_text(encoding='utf-8').split('\n')
    before = len(history)
    lapsed = history.index('## Lapsed claims (18 October 2026)')
    end = lapsed - 1
    while not history[end].startswith('| '):
        end -= 1
    history.insert(end + 1, row)
    assert len(history) == before + 1
    HISTORY.write_text('\n'.join(history), encoding='utf-8')
else:
    raise SystemExit(__doc__)
print('board', sys.argv[1], 'WRP2')
