#!/usr/bin/env python3
"""UE31's sentence in T2's home and in 08's thesis table, landed apart from the design (board_ue31.py's pattern).

edit: in 02 §5, after T2's Standing, one sentence saying what UE31's frozen test expects where a stage before
      recruitment is counted; in 08's thesis table, the same in T2's Standing cell (both files are shared, so the
      edits are made by script on the landing tree, not the branch's copies checked out).
head: put the clause "T2's sentence on the life cycle at the head of the queue (...); " at the front of the Queue line.
land: drop the head clause and put the landed clause first.
usage (from the checkout root): python3 -B board_t2.py edit | head | land"""
import re
import sys
from pathlib import Path

BOARD = Path('_process/BECOMING-WORKBOARD.md')
M02 = Path('theories/becoming/chapters/02-MAP.md')
M08 = Path('theories/becoming/chapters/08-METHOD.md')
END02 = ("[§316](../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/"
         "BECOMING-RENEWAL-READING.md#316-fates-on-either-side-of-the-curve-in-the-plane-in-the-field-mq7)).")
ADD02 = (" In one domain where a stage before recruitment is counted, the flour beetle's laboratory cultures, the frozen "
         "test UE31 ([design](../../../experiments/state-named-in-advance/DESIGN.md), not yet run) expects the wording "
         "\"as far as anything measured does\" to fail, as the life cycle implies: the pupae counted now are the next "
         "recruits and carry the chance events between egg and pupa, which no history of the adults can hold, so a class "
         "of fewer variables, the pupae and the adults, would leave less of the next giving unaccounted for, meeting "
         "[08 §9](08-METHOD.md#what-would-defeat-the-reading)'s defeater. The beetle is not on the *Refuted by* list, but "
         "a culture under a set loss is a renewable condition under a draw, so such a failure would count against the "
         "claim for every one; it would defeat T2's class as worded in that domain, not the reading 08 §9 names, nor T2 "
         "in the fisheries, where MQ5 passed. What would remain is \"as far as the level's own history does\": on the "
         "adults' own course, with the lag two censuses back, where the life cycle puts it, the test expects the three "
         "numbers to tie the field's state by construction. Their one contrary prediction is the lag's sign: if the "
         "field's model holds, the test expects it mostly undecided at the archive's size, and any decision there to go "
         "to the field; if T2's law held, it would often go to T2.")
ROW08 = ("| T2. The state of a renewable condition under a draw is its level, its recent giving and one lag | "
         "[02](02-MAP.md#t2) | conjectured, on three frozen fish-stock tests; untested outside fisheries |")
NEW08 = ("| T2. The state of a renewable condition under a draw is its level, its recent giving and one lag | "
         "[02](02-MAP.md#t2) | conjectured, on three frozen fish-stock tests; untested outside fisheries; in the flour "
         "beetle, where a stage before recruitment is counted, its wording \"as far as anything measured does\" is "
         "expected to fail to the pupae and the adults, a class of fewer variables ([§9](#what-would-defeat-the-reading)'s "
         "defeater, in that domain only), so that \"as far as the level's own history does\" would remain; the lag's "
         "sign is expected mostly undecided at the archive's size if the field's model holds, any decision then the "
         "field's, and often T2's if T2's law holds (UE31, frozen, not yet run) |")
YEAST02 = "outside the deteriorating environments that could refute T2;"
YEAST02_NEW = "outside the deteriorating environments T2's *Refuted by* names;"
YEAST08 = "outside the settings that could refute T2,"
YEAST08_NEW = "outside the settings T2's *Refuted by* names,"

NAME = "T2's sentence on the life cycle"
HEAD_TEXT = ("landing now, by readiness, before the freeze: documents only, no Lean, no new record and no core run: one "
             "sentence in T2's home and its row in 08's thesis table saying what UE31's frozen test expects where a stage "
             "before recruitment is counted, found by the gap scan; the fourteen records binding 02 and 08 re-pointed "
             "after reading; render, strict check, links and tests, then the fast-forward")
HEAD = re.compile(re.escape(NAME) + r' at the head of the queue \([^()]*\); ')
LANDED = ("T2's sentence on the life cycle landed (documents only: no Lean, no new record and no core run). T2's home "
          "(02 §5) and its row in 08's thesis table now say what UE31's frozen test, not yet run, expects in one domain "
          "where a stage before recruitment is counted, the flour beetle's laboratory cultures: T2's wording \"as far as "
          "anything measured does\" failing, as the life cycle implies, to a class of fewer variables, the pupae and the "
          "adults (08 §9's defeater, in that domain only, defeating the class as worded, not the reading, nor T2 in the "
          "fisheries); \"as far as the level's own history does\" remaining, the adults' own course tying the field's "
          "state by construction; and the lag's sign, their one contrary prediction, mostly undecided at the archive's "
          "size if the field's model holds, any decision then the field's, and often T2's if T2's law holds. With it, "
          "MQ6's yeast at one constant dilution lies outside the settings T2's *Refuted by* names, no longer outside "
          "those that could refute T2, since a constant draw is a draw. The gap scan found that the design said so and the chapters did not, so that a reader would take T2's "
          "wording as standing everywhere; the design's reader checked both sentences against it and its seven points "
          "were taken, and the sciences dossier's reader's two after them. The fourteen records binding 02 and 08 by their whole bytes were read against the change (their "
          "home sections lie elsewhere, and none cites T2) and re-pointed in their rebinds line; nothing they say "
          "changed. ")


def edit():
    s = M02.read_text(encoding='utf-8')
    lines = [line for line in s.split('\n') if line.startswith('**Thesis T2.**')]
    assert len(lines) == 1 and lines[0].endswith(END02) and ADD02 not in s, "T2's line"
    assert s.count(lines[0]) == 1
    assert s.count(YEAST02) == 1, 'the yeast phrase in 02'
    M02.write_text(s.replace(lines[0], lines[0] + ADD02, 1).replace(YEAST02, YEAST02_NEW, 1), encoding='utf-8')
    t = M08.read_text(encoding='utf-8')
    assert t.count(ROW08) == 1 and NEW08 not in t, "08's T2 row"
    assert t.count(YEAST08) == 1, 'the yeast phrase in 08'
    M08.write_text(t.replace(ROW08, NEW08, 1).replace(YEAST08, YEAST08_NEW, 1), encoding='utf-8')
    print('edit: 02 §5 and 08 thesis table')


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
