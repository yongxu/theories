#!/usr/bin/env python3
"""UE32's design landed (board_ue31b.py's pattern): documents and dry runs only, no data read or downloaded, no Lean.

edit: the board's way now (item 2), UE32's row and the Decisions line of runs waiting on Ren's yes; the experiments
      index gains the folder's row. Every file is shared, so the edits are made by script on the landing tree.
head: put the clause "UE32 at the head of the queue (...); " at the front of the Queue line.
land: drop the head clause and put the landed clause first.
usage (from the checkout root): python3 -B board_ue32.py edit | head | land"""
import re
import sys
from pathlib import Path

BOARD = Path('_process/BECOMING-WORKBOARD.md')
INDEX = Path('experiments/README.md')
DESIGN = 'experiments/state-against-embedding/DESIGN.md'

EDITS = {
    BOARD: [
        ("and UE31b, the same cultures read by cell, frozen before any of their values is read "
         "([design](../experiments/state-named-in-advance/cells/DESIGN.md)), its run Ren's;",
         "and UE31b, the same cultures read by cell, frozen before any of their values is read "
         "([design](../experiments/state-named-in-advance/cells/DESIGN.md)), its run Ren's; UE32, T2's three numbers "
         "against the field's fitted delay embedding on MQ5's assessed fish stocks, by the field's own criterion, "
         f"out-of-sample skill, frozen before any series is read by it ([design](../{DESIGN})), its download and run "
         "Ren's;"),
        ("Where no life stage is counted, T2's nearest rival is the field that reads a state from a series without "
         "naming it in advance",
         "Where T2's tests read no life stage, one rival is the field that reads a state from a series without naming "
         "it in advance"),
        ("| claimed 2026-11-03 on `d0b1c6f51`; begins once UE31b's design has landed | "
         "`experiments/state-against-embedding/` (branch `ue32`)",
         "| claimed 2026-11-03 on `d0b1c6f51`; design landed and frozen, no series read by it and no data downloaded "
         f"([DESIGN](../{DESIGN})): the answer expected stated before the run (its §1), two readers' findings taken, "
         "one on the documents and one on the design (its §12); the download and the run wait on Ren's yes | "
         "`experiments/state-against-embedding/` (branch `ue32`)"),
        ("LA1b, LA1c, LA2 and LA3 have all run (26 to 28 October); none of them waits.",
         f"UE32's run is frozen ([design](../{DESIGN})); his yes would release one download, RAM Legacy v4.66 from "
         "Zenodo record 14043031 (about 112 MB, md5 `ed6d7cd3f7da1fdcbc60015c3d65014b`, the archive MQ3 to MQ5 read), "
         "into a new folder outside the repository, and one run of its script in the design's order (its §9) on "
         "MQ5's 98 stocks, checked against its committed fits before any rule is computed; the rules take seconds of CPU "
         "and MQ5's reader of the workbook the rest, its time not recorded; nothing else downloaded; "
         "the output kept whatever it is, the answer expected stated in the design's §1. LA1b, LA1c, LA2 and LA3 have "
         "all run (26 to 28 October); none of them waits."),
    ],
    INDEX: [
        ("| [circular-construction](circular-construction/README.md) |",
         "| [state-against-embedding](state-against-embedding/README.md) | Thesis T2's three numbers against the "
         "field's fitted delay embedding of the same two series, on MQ5's assessed fish stocks, by the field's own "
         "criterion, out-of-sample skill (UE32): the field read source by source, its published per-stock dimensions "
         "tabled against T2's stocks, four proposals for T2's statement, and a test designed and frozen 3 Nov 2026 "
         "before any series was read by it, its download and run Ren's |\n"
         "| [circular-construction](circular-construction/README.md) |"),
    ],
}

NAME = 'UE32'
HEAD_TEXT = ("landing now, by readiness: documents and dry runs only, no data read or downloaded, no Lean and no core "
             "run: T2's named state against the field's fitted delay embedding on MQ5's fish stocks, frozen before "
             "any series is read by it, its download and run Ren's; the field's reading, its per-stock estimates and "
             "four proposals for T2's owner; the board and the experiments index; render, strict check, links and "
             "tests, then the fast-forward")
HEAD = re.compile(re.escape(NAME) + r' at the head of the queue \([^()]*\); ')
LANDED = ("UE32's design landed (documents and dry runs only: no series read by it, no data downloaded, no Lean, no "
          "record and no core run): T2's three numbers, the escapement, the escapement a year back and the recent "
          "giving, against the field's delay embedding of the same two series, its dimension chosen by the S-map's own "
          "leave-one-out error, both read by the same S-map on MQ5's stocks, share and split and scored by "
          "out-of-sample error; T2 fails if the embedding removes a tenth of T2's held-out error in the median stock "
          "and wins in significantly more stocks, and how a fail is read is frozen too. The answer expected is stated "
          "before the run: not separated, from MQ5's one-year and S3 readings of these stocks, which place them "
          "between its synthetic worlds, and from a mixed world, a third of its stocks age-structured, where the test "
          "says not separated in 94% of 200 archives. In 200 archives for each of ten worlds the test fails T2 in "
          "47.5% to 78% where an age structure holds in every stock and in 44.5% under a second lag, in one of the "
          "1,200 archives elsewhere, and says T2 better in 22% to 33% under T2's own law. With it, the field read source by "
          "source, its per-stock dimensions tabled against T2's stocks, and four proposals for T2's owner. "
          "Two readers' findings taken, sixteen on the documents and fifteen on the design, then the design's reader's second and third readings of the revisions; the rules changed on them (the embedding's dimension chosen by the scored criterion, a fail's reading frozen, T2's state read in the form T2 named) and every dry run rerun under them "
          f"([design §12](../{DESIGN}#12-review)); the download and the run wait on Ren's yes; ")


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
