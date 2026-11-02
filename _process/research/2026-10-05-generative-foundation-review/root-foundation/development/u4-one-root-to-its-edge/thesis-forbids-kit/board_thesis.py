#!/usr/bin/env python3
"""The philosophical thesis's statement: the board's clauses, board_u4e.py's pattern.
head: this landing's clause at the head of the Queue line, behind no other "landing now" clause.
landed: the head clause replaced by the landed one, and the row in the history file, after the last landed row.
usage (from the root of a tree holding the board): python3 -B board_thesis.py head | landed"""
import datetime
import sys
from pathlib import Path

BOARD = Path('_process/BECOMING-WORKBOARD.md')
HISTORY = Path('_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md')
HEAD = ("The philosophical thesis's statement at the head of the queue (landing now: 08 §9's one relational unfolding "
        "says what it forbids, explanations and not observations, and what would defeat it, an argument, in place of "
        "a refuter whose cases cannot occur or do not touch it; documents only, no Lean, no record and no core "
        "run; render, strict check, links, tests and both dossier checks, then the fast-forward); ")
LANDED = ("The philosophical thesis's statement landed (documents only: no Lean, no record and no core run): 08 §9's one "
          "relational unfolding said it would be refuted by two configurations that no test or relation tells apart "
          "and that go on differently, whose cases cannot occur or do not touch it; a cold read's finding, checked "
          "against the Lean. It now says the thesis forbids explanations and not observations, that none could refute it as argued and "
          "not proved, three cases "
          "that look like refuters (`Alike.tests`, `DeterminedAt.goAlike` with the nucleus's `Decay` witnesses, "
          "`Twins.retarget_breaks`), what would defeat it, an argument measurements can support and cannot replace, with equality on the carrier the nearest case "
          "in the account, and that its content is a demand on explanations. No record cites the section, so nothing "
          "is re-pointed. The fronts' sentence is the reader revision's. Render, strict check, links, tests and both "
          "dossier checks pass. ")
ROW = ("| **The philosophical thesis's statement, done** (the cold read of 2 November 2026: the stated refuter may be "
       "unmeetable) | Claude Code desktop session \"time moves fast, for all our\" (U4's owner), on the coordinator's "
       "word | landed {date}: 08 §9 says the thesis forbids explanations and not observations and what would defeat "
       "it; the reader's conclusion confirmed against the Lean, two of its steps corrected | "
       "`development/u4-one-root-to-its-edge/thesis-forbids-kit/`; at landing `theories/becoming/chapters/08-METHOD.md` "
       "| none |")


def queue(text):
    lines = text.split('\n')
    i = [k for k, l in enumerate(lines) if l.startswith('- **Queue:** ')]
    assert len(i) == 1, i
    return lines, i[0]


def head():
    lines, i = queue(BOARD.read_text(encoding='utf-8'))
    assert '(landing now' not in lines[i], 'another clause holds the head: ' + lines[i][:200]
    lines[i] = '- **Queue:** ' + HEAD + lines[i][len('- **Queue:** '):]
    BOARD.write_text('\n'.join(lines), encoding='utf-8')
    print('head: the thesis at the head')


def landed():
    lines, i = queue(BOARD.read_text(encoding='utf-8'))
    assert lines[i].startswith('- **Queue:** ' + HEAD), 'this landing does not hold the head'
    lines[i] = '- **Queue:** ' + LANDED + lines[i][len('- **Queue:** ' + HEAD):]
    BOARD.write_text('\n'.join(lines), encoding='utf-8')
    hist = HISTORY.read_text(encoding='utf-8').split('\n')
    k = hist.index('## Lapsed claims (18 October 2026)') - 1
    while k > 0 and not hist[k].startswith('| **'):
        k -= 1
    hist.insert(k + 1, ROW.format(date=datetime.date.today().isoformat()))
    HISTORY.write_text('\n'.join(hist), encoding='utf-8')
    print('landed: clause written, row after history line', k + 1)


if __name__ == '__main__':
    {'head': head, 'landed': landed}[sys.argv[1]]()
