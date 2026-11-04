#!/usr/bin/env python3
"""GT2's board edits at its landing, applied to the board as it then stands.

usage: python3 -B land_gt2.py head BOARD                    the head clause, at the front of the Queue line
       python3 -B land_gt2.py landed BOARD HISTORY COMMIT   the landed clause in its place, GT2's row done in the history file

Each edit asserts that the text it replaces occurs exactly once, so a board that moved in an unexpected way stops the
script rather than being edited blind. The Queue line keeps every other clause (the gate's board check).
"""
import sys
from pathlib import Path

QUEUE = '- **Queue:** '
HEAD = ("GT2 at the head of the queue (landing now: the Lean checker made fast, what it checks unchanged: the environment "
        "audit in one pass, one plan and one runner for the checker, the fallible-inquiry checker and scratch_build, the "
        "runner in every step's key, a lock per step key, the machine's Lean slots, each step's seconds; its fresh core run "
        "compared step by step with the old checker's results, the fallible-inquiry receipt renewed, eleven records "
        "re-pointed; Python, documents and receipts, no Lean source, no record's law); ")
LANDED = ("GT2 landed (`{commit}`; Python, documents and receipts: no Lean source and no record's law; core receipt "
          "`20261104T201844.426739Z`, run fresh; eleven records re-pointed with `repoint.py`; readers on what is checked, "
          "on concurrency and on the runner in the key, each round's fixes read again). The checker, the fallible-inquiry "
          "checker and `scratch_build.py` take their steps from one plan and run each through one runner. Every step's key "
          "holds a digest of that runner's code, so a change to what a step runs changes every key by itself, and each "
          "cache entry names the runner that wrote it. The environment audit lists the constants once, its output byte for "
          "byte the old one's on the core's 386 modules, in 27 s where it took 90. A step not in the cache runs under its "
          "key's lock, so two runs of one tree compute it once, and every Lean process of the three takes one of the "
          "machine's slots (`BECOMING_LEAN_SLOTS`). Each step's seconds are in the receipt, and a scratch build's steps "
          "are the checker's, so a landing reuses them. The fresh run took 219 s, and every one of its 1,544 steps gave "
          "the old checker's log and output digests. The fallible-inquiry receipt is renewed from it and passed. "
          "BoundaryModels' current bytes cannot be bound by the pre-spine checker, which requires them as preserved on "
          "6 October, so AA's E11 keeps its fallback wording. The merged drivers were measured, about 20 s of a full run, "
          "and left, since kits read the signature logs by name. A periphery checker's search for its inherited receipts "
          "(about 215 s for the fallible-inquiry checker) comes next ([GATE.md §5.1](research/2026-10-05-repository-"
          "reconciliation/architecture/gt/GATE.md#51-gt2-what-was-done-and-measured)); ")
ROW_START = '| **GT2: the Lean checker made fast, what it checks unchanged** ('
ROW_TITLE_OLD = '| **GT2: the Lean checker made fast, what it checks unchanged** ('
ROW_TITLE_NEW = '| **GT2: the Lean checker made fast, what it checks unchanged, done** ('
ROW_STATE_OLD = '| claimed 5 November 2026 on `614865ff2` |'
ROW_STATE_NEW = '| claimed 5 November 2026 on `614865ff2`; landed `{commit}` (two readers, their fixes read again); done |'
HISTORY_AFTER = '| **RAE2: 06\'s Lean names checked exactly, done** ('


def once(text, old, new):
    if text.count(old) != 1:
        raise SystemExit(f'expected exactly one occurrence, found {text.count(old)}: {old[:80]!r}')
    return text.replace(old, new)


def main():
    what, board = sys.argv[1], Path(sys.argv[2])
    lines = board.read_text().split('\n')
    i = next(k for k, l in enumerate(lines) if l.startswith(QUEUE))
    if what == 'head':
        if 'landing now' in lines[i][:400]:
            raise SystemExit('a head clause already stands')
        lines[i] = QUEUE + HEAD + lines[i][len(QUEUE):]
        board.write_text('\n'.join(lines))
        print(f'head: Queue line {len(lines[i])}')
        return
    if what != 'landed':
        raise SystemExit(__doc__)
    history, commit = Path(sys.argv[3]), sys.argv[4]
    if not lines[i].startswith(QUEUE + HEAD):
        raise SystemExit("the head clause is not GT2's")
    lines[i] = QUEUE + LANDED.format(commit=commit) + lines[i][len(QUEUE + HEAD):]
    rows = [k for k, l in enumerate(lines) if l.startswith(ROW_START)]
    if len(rows) != 1:
        raise SystemExit(f'expected GT2\'s row once, found {len(rows)}')
    row = lines.pop(rows[0])
    row = once(once(row, ROW_TITLE_OLD, ROW_TITLE_NEW), ROW_STATE_OLD, ROW_STATE_NEW.format(commit=commit))
    board.write_text('\n'.join(lines))
    past = history.read_text().split('\n')
    at = [k for k, l in enumerate(past) if l.startswith(HISTORY_AFTER)]
    if len(at) != 1:
        raise SystemExit('RAE2\'s row not found once in the history file')
    k = at[0]
    while k + 1 < len(past) and past[k + 1].startswith('| **'):
        k += 1
    past.insert(k + 1, row)
    history.write_text('\n'.join(past))
    print(f'landed: Queue line {len(lines[i])}; row moved to line {k + 2} of the history file')


if __name__ == '__main__':
    main()
