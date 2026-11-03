#!/usr/bin/env python3
"""T2S, T2's statement from UE32's proposals 1, 2 and 4 (board_ue32.py's pattern): documents only, no Lean, no core run
and nothing downloaded.

claim: T2S's row in the open claims, after UE32's (a board-only commit in a gap with no head clause).
head:  put the clause "T2S at the head of the queue (...); " at the front of the Queue line.
land:  drop the head clause and put the landed clause first (landed.txt), move T2S's row off the open claims into the
       history file's landed rows (history.txt), and add the batched precision pass's entry (batched.txt).
usage (from the checkout root): python3 -B board_t2s.py claim | head | land"""
import re
import sys
from pathlib import Path

BOARD = Path('_process/BECOMING-WORKBOARD.md')
PROPOSALS = '../experiments/state-against-embedding/T2-PROPOSALS.md'

NAME = 'T2S'
ROW = ("| **T2S: T2's statement, from UE32's proposals 1, 2 and 4** (the way now's item 1, what a reader is told; the "
       f"coordinator's word, 4 November 2026; [T2-PROPOSALS]({PROPOSALS})). Purpose: a unified explanation of reality "
       "(UE). T2's second forbidden item, the level alone forecasting as well at five years, is met by T2's own law at "
       "the regime's-step end T2 names; its horizon is given in years where the tests read it at the grain the three "
       "numbers are read at; its one lag has no place named before the data. Proposal 3, narrowing \"as far as "
       "anything measured does\", waits on a frozen run that fails it. | Claude Code desktop session (Free Energy "
       "Principle and self-organization), 4 November 2026 | claimed 2026-11-04 on `{base}`; documents only: no Lean, "
       "no record, no core run and nothing downloaded | T2's home (02 §5), its row in 08's thesis table, the sciences "
       "dossier's S-15 and summary row, the overview's thesis row where it now says something false (EN, ZH), a study "
       "section with the correction (branch `t2-statement`) | one reader other than the author, against T2-PROPOSALS "
       "and the study → what a reader is told of T2 |")
STATE_CLAIMED = re.compile(r"\| claimed 2026-11-04 on `[0-9a-f]{9}`; documents only: no Lean, no record, no core run and "
                           r"nothing downloaded \|")
UE32_ROW = '| **UE32: T2 against empirical dynamic modelling**'

HEAD_TEXT = ("landing now, by readiness: documents only, no Lean, no record and no core run: T2's statement from UE32's "
             "proposals 1, 2 and 4, in T2's home, 08's row, the sciences dossier and the overview's row, with a study "
             "section; the records binding the changed chapters re-pointed after reading; render, strict check, links, "
             "tests and both dossier checks, then the fast-forward")
HEAD = re.compile(re.escape(NAME) + r' at the head of the queue \([^()]*\); ')


def lines_of():
    return BOARD.read_text(encoding='utf-8').split('\n')


def queue_line(lines):
    at = [i for i, line in enumerate(lines) if line.startswith('- **Queue:** ')]
    assert len(at) == 1, at
    return at[0]


def claim():
    import subprocess
    base = subprocess.run(['git', 'rev-parse', '--short=9', 'HEAD'], capture_output=True, text=True,
                          check=True).stdout.strip()
    lines = lines_of()
    assert '(landing now' not in lines[queue_line(lines)], 'a clause holds the head'
    assert not any(line.startswith('| **T2S: ') for line in lines), 'already claimed'
    at = [i for i, line in enumerate(lines) if line.startswith(UE32_ROW)]
    assert len(at) == 1, at
    lines.insert(at[0] + 1, ROW.format(base=base))
    BOARD.write_text('\n'.join(lines), encoding='utf-8')
    print('claim: row written on', base)


def head():
    lines = lines_of()
    q = queue_line(lines)
    assert '(landing now' not in lines[q], 'another clause holds the head: ' + lines[q][:200]
    clause = f'{NAME} at the head of the queue ({HEAD_TEXT}); '
    assert HEAD.fullmatch(clause), clause
    lines[q] = lines[q].replace('- **Queue:** ', '- **Queue:** ' + clause, 1)
    BOARD.write_text('\n'.join(lines), encoding='utf-8')
    print('head: clause written')


HISTORY = Path('_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md')
HERE = Path(__file__).resolve().parent


def land():
    study = Path('_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md')
    title = "T2's statement: the level alone at the regime's-step end, the horizon's grain and the lag's place (T2S)"
    found = re.findall(r'^## (\d+)\. ' + re.escape(title) + '$', study.read_text(encoding='utf-8'), flags=re.M)
    assert len(found) == 1, found
    n = found[0]
    anchor = re.sub(r"[^\w\- ]", '', f'{n}. {title}'.lower()).replace(' ', '-')
    link = f'research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md#{anchor}'
    landed, history, batched = (HERE.joinpath(name).read_text(encoding='utf-8').strip().replace('{N}', n)
                                .replace('{STUDY}', link) for name in ('landed.txt', 'history.txt', 'batched.txt'))
    assert '{' not in landed + history + batched
    for mark in ('SECOND_SUMMARY', 'FRONT words', 'HOURMIN', 'HOUR (', 'WHOLE minutes'):
        assert mark not in landed + history + batched, mark
    lines = lines_of()
    q = queue_line(lines)
    assert len(HEAD.findall(lines[q])) == 1 and lines[q].startswith('- **Queue:** ' + NAME + ' at the head'), 'not at the head'
    lines[q] = HEAD.sub('', lines[q], count=1)
    lines[q] = lines[q].replace('- **Queue:** ', '- **Queue:** ' + landed + ' ', 1)
    at = [i for i, line in enumerate(lines) if line.startswith('| **T2S: ')]
    assert len(at) == 1 and STATE_CLAIMED.search(lines[at[0]]), at
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
    print('land: clause, history row and batched entry written')


if __name__ == '__main__':
    if len(sys.argv) == 2 and sys.argv[1] in ('claim', 'head', 'land'):
        {'claim': claim, 'head': head, 'land': land}[sys.argv[1]]()
    else:
        sys.exit(__doc__)
