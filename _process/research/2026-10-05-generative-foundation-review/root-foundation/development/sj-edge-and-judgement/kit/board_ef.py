#!/usr/bin/env python3
"""The note on how evaluation forms: its board edits, in a worktree. head: the clause at the head of the Queue line. landed
HASHLESS: the landed clause in its place, and the landing's one row in the history's landed table.
usage (from the checkout root): python3 -B board_ef.py head | landed"""
import datetime
import sys
from pathlib import Path

BOARD = Path('_process/BECOMING-WORKBOARD.md')
HISTORY = Path('_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md')
LANDED_TABLE = '## Landed after the board was rewritten (17 October 2026)'
Q = '- **Queue:** '
HEAD = ("The note on how evaluation forms at the head of the queue (landing now, on the coordinator's word: documents only, "
        "no Lean, no record and no core run; a note in SJ's study and an added block at 07 §1; then render, strict check, "
        "links, tests and both dossier checks, then the fast-forward); ")
NOTE = ('../../research/2026-10-05-generative-foundation-review/root-foundation/development/sj-edge-and-judgement/'
        'HOW-EVALUATION-FORMS.md')


def queue(text):
    lines = text.split('\n')
    i = [k for k, l in enumerate(lines) if l.startswith(Q)]
    assert len(i) == 1, i
    return lines, i[0]


def head():
    lines, i = queue(BOARD.read_text(encoding='utf-8'))
    assert '(landing now' not in lines[i], 'another clause holds the head: ' + lines[i][:200]
    lines[i] = Q + HEAD + lines[i][len(Q):]
    BOARD.write_text('\n'.join(lines), encoding='utf-8')


def landed():
    lines, i = queue(BOARD.read_text(encoding='utf-8'))
    assert lines[i].startswith(Q + HEAD), 'the note does not hold the head'
    rest = lines[i][len(Q + HEAD):]
    clause = ("The note on how evaluation forms landed (documents only: no Lean, no record and no core run): the word covers "
              "four standings, how needs form and standards are shaped and gain influence (shown under stated conditions), a "
              "significance tied to a center (read), the free `sig` and the rest of what a judgement takes in (supplied), and "
              "what the represented dynamics do not reach for the untied `sig`; no law joins the first to the second; the "
              "block at 07 §1, the note in SJ's study, the fronts' sentence sent to the reader revision; render, strict "
              "check, links, tests and both dossier checks pass. ")
    lines[i] = Q + clause + rest
    BOARD.write_text('\n'.join(lines), encoding='utf-8')
    row = (f"| **The note on how evaluation forms, done** (the cold read of the fronts, item \"how evaluation forms is defined "
           f"and read, not derived\"; the coordinator's word, 2 November 2026). [The note]({NOTE}) decides that neither half "
           "of the choice is right as put: the word covers four standings, shown, read, supplied and out of reach of the "
           "represented dynamics for the untied `sig`, and no law joins the first to the second; its home is the block "
           "`what-forms-and-what-is-supplied` at [07 §1](../../../theories/becoming/chapters/07-SIGNIFICANCE.md#what-forms-and-"
           "what-is-supplied); the fronts' sentence went to the reader revision. Documents only: no Lean, no record and no "
           "core run | Claude Code desktop session of SJ, 2 November 2026; no claim row, the head clause its claim | landed "
           f"{datetime.date.today().isoformat()}, on the coordinator's word: render, strict check, links, the 305 tests and "
           "both dossier checks pass | the note, 07 §1 | needs: the map at 08 §7, 07 §1's theorem → feeds: the fronts' "
           "sentence; a law taking a net with no standard to one with, if claimed |")
    hist = HISTORY.read_text(encoding='utf-8').split('\n')
    start = hist.index(LANDED_TABLE)
    end = next(k for k in range(start + 1, len(hist)) if hist[k].startswith('## '))
    last = max(k for k in range(start, end) if hist[k].startswith('| **'))
    hist.insert(last + 1, row)
    HISTORY.write_text('\n'.join(hist), encoding='utf-8')


{'head': head, 'landed': landed}[sys.argv[1]]()
