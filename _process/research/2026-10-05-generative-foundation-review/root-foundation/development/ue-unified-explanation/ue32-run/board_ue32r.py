#!/usr/bin/env python3
"""UE32's run, its result landed (board_t2s.py's pattern): documents and the run's output, no Lean, no record, no core
run; the archive downloaded on Ren's yes and kept outside the repository.

head:  put the clause "UE32 at the head of the queue (...); " at the front of the Queue line.
land:  drop the head clause and put the landed clause first (landed.txt); move UE32's row off the open claims into the
       history file's landed rows (history.txt); restate UE32's clause in the way now's item 2; take UE32's run off
       the runs that wait on Ren's yes; add the batched precision pass's entry (batched.txt).
usage (from the checkout root): python3 -B board_ue32r.py head | land"""
import re
import sys
from pathlib import Path

BOARD = Path('_process/BECOMING-WORKBOARD.md')
HISTORY = Path('_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md')
STUDY = Path('_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md')
TITLE = "T2's three numbers against the field's fitted delay embedding, out of sample (UE32's run)"
HERE = Path(__file__).resolve().parent

NAME = 'UE32'
HEAD_TEXT = ("landing now, by readiness: UE32's run on Ren's yes, its output and result, documents and no Lean, no record "
             "and no core run: the result in UE32's README, T2's home and 08's row, S-15 and the whole's time, the "
             "overview's row, with a study section; the records binding the changed chapters re-pointed after reading; "
             "render, strict check, links, tests and both dossier checks, then the fast-forward")
HEAD = re.compile(re.escape(NAME) + r' at the head of the queue \([^()]*\); ')
ROW = '| **UE32: T2 against empirical dynamic modelling**'
ROW_STATE = "the download and the run wait on Ren's yes |"

WAY_OLD = ("UE32, T2's three numbers against the field's fitted delay embedding on MQ5's assessed fish stocks, by the "
           "field's own criterion, out-of-sample skill, frozen before any series is read by it "
           "([design](../experiments/state-against-embedding/DESIGN.md)), its download and run Ren's;")
WAY_NEW = ("UE32, T2's three numbers against the field's fitted delay embedding on MQ5's assessed fish stocks, by the "
           "field's own criterion, out-of-sample skill, frozen before any series was read by it "
           "([design](../experiments/state-against-embedding/DESIGN.md)) and run on 4 November 2026 on Ren's yes: T2 "
           "better than the field's fitted embedding by its frozen criterion, post hoc only where the embedding went past "
           "the field's bound on its size, both behind persistence in most stocks ([result](../experiments/state-against-embedding/README.md#the-result));")
RUNS = re.compile(r" UE32's run is frozen \(\[design\]\(\.\./experiments/state-against-embedding/DESIGN\.md\)\); his yes "
                  r"would release .*?the answer expected stated in the design's §1\.")


def lines_of():
    return BOARD.read_text(encoding='utf-8').split('\n')


def queue_line(lines):
    at = [i for i, line in enumerate(lines) if line.startswith('- **Queue:** ')]
    assert len(at) == 1, at
    return at[0]


def head():
    lines = lines_of()
    q = queue_line(lines)
    assert '(landing now' not in lines[q], 'another clause holds the head: ' + lines[q][:200]
    clause = f'{NAME} at the head of the queue ({HEAD_TEXT}); '
    assert HEAD.fullmatch(clause), clause
    lines[q] = lines[q].replace('- **Queue:** ', '- **Queue:** ' + clause, 1)
    BOARD.write_text('\n'.join(lines), encoding='utf-8')
    print('head: clause written')


def land():
    found = re.findall(r'^## (\d+)\. ' + re.escape(TITLE) + '$', STUDY.read_text(encoding='utf-8'), flags=re.M)
    assert len(found) == 1, found
    n = found[0]
    anchor = re.sub(r"[^\w\- ]", '', f'{n}. {TITLE}'.lower()).replace(' ', '-')
    link = f'research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md#{anchor}'
    landed, history, batched = (HERE.joinpath(name).read_text(encoding='utf-8').strip().replace('{N}', n)
                                .replace('{STUDY}', link) for name in ('landed.txt', 'history.txt', 'batched.txt'))
    assert '{' not in landed + history + batched
    for mark in ('TODO', 'FIGURES', 'REVIEW_SUMMARY'):
        assert mark not in landed + history + batched, mark
    lines = lines_of()
    q = queue_line(lines)
    assert len(HEAD.findall(lines[q])) == 1 and lines[q].startswith('- **Queue:** ' + NAME + ' at the head'), 'not at the head'
    lines[q] = HEAD.sub('', lines[q], count=1)
    lines[q] = lines[q].replace('- **Queue:** ', '- **Queue:** ' + landed + ' ', 1)
    way = [i for i, line in enumerate(lines) if WAY_OLD in line]
    assert len(way) == 1 and lines[way[0]].count(WAY_OLD) == 1, way
    lines[way[0]] = lines[way[0]].replace(WAY_OLD, WAY_NEW, 1)
    runs = [i for i, line in enumerate(lines) if line.startswith("- **Runs that wait on Ren's yes**")]
    assert len(runs) == 1 and len(RUNS.findall(lines[runs[0]])) == 1, runs
    lines[runs[0]] = RUNS.sub('', lines[runs[0]], count=1)
    assert 'UE32' not in lines[runs[0]] and "UE31b's run is frozen" in lines[runs[0]]
    at = [i for i, line in enumerate(lines) if line.startswith(ROW)]
    assert len(at) == 1 and lines[at[0]].count(ROW_STATE) == 1, at
    del lines[at[0]]
    top = [i for i, line in enumerate(lines) if line.startswith('## Batched precision pass')]
    nxt = [i for i, line in enumerate(lines) if line.startswith('## Decisions pending Ren')]
    assert len(top) == 1 and len(nxt) == 1 and top[0] < nxt[0], (top, nxt)
    last = max(i for i in range(top[0], nxt[0]) if lines[i].startswith('- **'))
    lines.insert(last + 1, batched)
    BOARD.write_text('\n'.join(lines), encoding='utf-8')
    h = HISTORY.read_text(encoding='utf-8').split('\n')
    lapsed = [i for i, line in enumerate(h) if line.startswith('## Lapsed claims')]
    assert len(lapsed) == 1 and h[lapsed[0] - 1] == '' and h[lapsed[0] - 2].startswith('| **'), lapsed
    h.insert(lapsed[0] - 1, history)
    HISTORY.write_text('\n'.join(h), encoding='utf-8')
    print('land: clause, way now, runs line, history row and batched entry written')


if __name__ == '__main__':
    if len(sys.argv) == 2 and sys.argv[1] in ('head', 'land'):
        {'head': head, 'land': land}[sys.argv[1]]()
    else:
        sys.exit(__doc__)
