#!/usr/bin/env python3
"""The independent read of the note on how evaluation forms: its board edits, in a worktree. head: the clause at the head of the Queue line. landed: the landed clause in its place, and the landing's one row in the history's landed table.
usage (from the checkout root): python3 -B board_ef2.py head | landed"""
import datetime
import sys
from pathlib import Path

BOARD = Path('_process/BECOMING-WORKBOARD.md')
HISTORY = Path('_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md')
LANDED_TABLE = '## Landed after the board was rewritten (17 October 2026)'
Q = '- **Queue:** '
HEAD = ("The independent read of the note on how evaluation forms at the head of the queue (landing now: documents only, "
        "no Lean, no result record and no core run; the note and its block at 07 §1 corrected from two independent "
        "readers' reports, kept as REVIEW-5, and a glossary row for standard; then render, strict check, links, tests and "
        "both dossier checks, then the fast-forward); ")
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
    clause = ("The independent read of the note on how evaluation forms landed (documents only: no Lean, no result record and "
              "no core run): two AI readers, their reports kept as REVIEW-5; a wrong declaration and overstated rows "
              "corrected; the claim that what forms is in general a rival of the condition, and that this is why the "
              "condition is a premise, withdrawn; the word now covers three things and a limit on the free parameter, and no "
              "law alone can supply the identification of a standard with a significance; a glossary row for standard; the "
              "block at 07 §1 rewritten under its anchor; the fronts' sentences sent to the reader revision again; render, "
              "strict check, links, tests and both dossier checks pass. ")
    lines[i] = Q + clause + rest
    BOARD.write_text('\n'.join(lines), encoding='utf-8')
    row = (f"| **The independent read of the note on how evaluation forms, done** (the note's first version had been read by "
           f"its author alone). [The note]({NOTE}) and its block at 07 §1 corrected from two independent AI readers, one "
           "exact against the Lean, one adversarial on the argument, their reports and the dispositions in [REVIEW-5](../../"
           "research/2026-10-05-generative-foundation-review/root-foundation/development/sj-edge-and-judgement/REVIEW-5.md): "
           "a wrong declaration, overstated rows and a too-wide search claim corrected, the reading that what forms is a "
           "rival of the condition withdrawn, the sorting stated as one of the account's statements, a glossary row for "
           "standard. Documents only: no Lean, no result record and no core run | Claude Code desktop session of SJ, 2 "
           "November 2026, with two subagents; no claim row, the head clause its claim | landed "
           f"{datetime.date.today().isoformat()}: render, strict check, links, the 305 tests and both dossier checks pass | "
           "the note, REVIEW-5, 07 §1, the glossary | needs: the note as first landed (6500dce37) → feeds: the fronts' "
           "sentences; the items in the note's §5, if claimed |")
    hist = HISTORY.read_text(encoding='utf-8').split('\n')
    start = hist.index(LANDED_TABLE)
    end = next(k for k in range(start + 1, len(hist)) if hist[k].startswith('## '))
    last = max(k for k in range(start, end) if hist[k].startswith('| **'))
    hist.insert(last + 1, row)
    HISTORY.write_text('\n'.join(hist), encoding='utf-8')


{'head': head, 'landed': landed}[sys.argv[1]]()
