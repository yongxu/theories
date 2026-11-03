#!/usr/bin/env python3
"""UE31b's design landed (board_ue31.py's pattern): documents and dry runs only, no data read, no Lean.

edit: the board's way now (item 2), UE31b's row and the Decisions line of runs waiting on Ren's yes; the experiments
      index's UE31 row; UE31's README, whose "What follows" named this design as new work. Every file but UE31's README
      is shared, so the edits are made by script on the landing tree.
head: put the clause "UE31b at the head of the queue (...); " at the front of the Queue line.
land: drop the head clause and put the landed clause first.
usage (from the checkout root): python3 -B board_ue31b.py edit | head | land"""
import re
import sys
from pathlib import Path

BOARD = Path('_process/BECOMING-WORKBOARD.md')
INDEX = Path('experiments/README.md')
UE31 = Path('experiments/state-named-in-advance/README.md')
DESIGN = 'experiments/state-named-in-advance/cells/DESIGN.md'

EDITS = {
    BOARD: [
        ("the adult-loss experiment's cultures too short for its frozen rules "
         "([result](../experiments/state-named-in-advance/README.md#the-result));",
         "the adult-loss experiment's cultures too short for its frozen rules "
         "([result](../experiments/state-named-in-advance/README.md#the-result)), and UE31b, the same cultures read "
         f"by cell, frozen before any of their values is read ([design](../{DESIGN})), its run Ren's;"),
        ("| claimed 2026-11-03 on `d0b1c6f51` | `experiments/state-named-in-advance/cells/`",
         "| claimed 2026-11-03 on `d0b1c6f51`; design landed and frozen, no value of these cultures read "
         f"([DESIGN](../{DESIGN})): the answer expected stated before the run (its §1), one independent reader's "
         "findings taken (its §12); the run waits on Ren's yes | `experiments/state-named-in-advance/cells/`"),
        ("Neither is frozen or run. LA1b, LA1c, LA2 and LA3 have all run",
         "Neither is frozen or run. UE31b's run is frozen ([design](../" + DESIGN + ")): the cell rules on the 40 "
         "adult-loss cultures of the workbook UE31 downloaded on his yes, a few seconds of CPU and nothing downloaded; "
         "the answer expected is in the design. LA1b, LA1c, LA2 and LA3 have all run"),
    ],
    INDEX: [
        ("which shows the rules run on the archive, not how cultures under a loss would read) |",
         "which shows the rules run on the archive, not how cultures under a loss would read; UE31b, the same 40 "
         "cultures read by cell, the four replicates of one strain at one loss under one law, designed and frozen "
         "3 Nov 2026 before any of their values was read ([design](state-named-in-advance/cells/DESIGN.md)), its run "
         "Ren's) |"),
    ],
    UE31: [
        ("**What follows.** A design that reads these cultures would be a new frozen test with its own dry runs at their "
         "shape, for example one fitting each loss's eight cultures together. Since no primary culture's own numbers "
         "were printed, it can still be designed before any is seen. It is not part of UE31.",
         "**What follows.** A design that reads these cultures, made before any of their values is seen, is "
         "[UE31b](cells/DESIGN.md): the four replicates of one strain at one loss read together as one cell, ten "
         "cells, with UE31's rules at that unit and dry runs at the archive's own shape. It is frozen, and its run "
         "waits on Ren's yes. It is not part of UE31."),
    ],
}

NAME = 'UE31b'
HEAD_TEXT = ("landing now, by readiness: documents and dry runs only, no data read, no Lean and no core run: a design "
             "reading the archive's adult-loss cultures by cell, frozen before any of their values is read, its run "
             "Ren's; the board, the experiments index and UE31's README; render, strict check, links and tests, then "
             "the fast-forward")
HEAD = re.compile(re.escape(NAME) + r' at the head of the queue \([^()]*\); ')
LANDED = "LANDED_TEXT "


def edit():
    for path, pairs in EDITS.items():
        s = path.read_text(encoding='utf-8')
        for old, new in pairs:
            assert s.count(old) == 1, (str(path), old[:80])
            assert new not in s, (str(path), 'already applied', new[:80])
            s = s.replace(old, new, 1)
        path.write_text(s, encoding='utf-8')
        print('edit:', path)


def queue_line(lines):
    at = [i for i, line in enumerate(lines) if line.startswith('- **Queue:** ')]
    assert len(at) == 1, at
    return at[0]


def head():
    lines = BOARD.read_text(encoding='utf-8').split('\n')
    q = queue_line(lines)
    assert '(landing now' not in lines[q], 'another clause holds the head: ' + lines[q][:200]
    clause = f'{NAME} at the head of the queue ({HEAD_TEXT}); '
    assert HEAD.fullmatch(clause), clause
    lines[q] = lines[q].replace('- **Queue:** ', '- **Queue:** ' + clause, 1)
    BOARD.write_text('\n'.join(lines), encoding='utf-8')
    print('head: clause written')


def land():
    lines = BOARD.read_text(encoding='utf-8').split('\n')
    q = queue_line(lines)
    assert len(HEAD.findall(lines[q])) == 1 and lines[q].startswith('- **Queue:** ' + NAME + ' at the head'), 'not at the head'
    lines[q] = HEAD.sub('', lines[q], count=1)
    lines[q] = lines[q].replace('- **Queue:** ', '- **Queue:** ' + LANDED, 1)
    BOARD.write_text('\n'.join(lines), encoding='utf-8')
    print('land: clause written')


if __name__ == '__main__':
    commands = {'edit': edit, 'head': head, 'land': land}
    if len(sys.argv) == 2 and sys.argv[1] in commands:
        commands[sys.argv[1]]()
    else:
        sys.exit(__doc__)
