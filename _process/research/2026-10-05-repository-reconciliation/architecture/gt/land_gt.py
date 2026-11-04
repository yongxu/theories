#!/usr/bin/env python3
"""GT's and AA's board edits at their landing, applied to the board as it then stands.

usage: python3 -B land_gt.py head BOARD          the head clause, at the front of the Queue line
       python3 -B land_gt.py landed BOARD COMMIT  rule 5, the two rows, and the landed clause replacing the head clause

Each edit asserts that the text it replaces occurs exactly once, so a board that moved in an unexpected way stops
the script rather than being edited blind. The Queue line keeps every other clause (the gate's board check).
"""
import sys
from pathlib import Path

QUEUE = '- **Queue:** '
HEAD = ("GT and AA at the head of the queue (landing now, as one train: the landing gate by what a change reaches, "
        "its tool, the drift comparisons kept by the texts compared and AGENTS.md's landing rule revised, landed under "
        "the rules it replaces; and AA's plan with its Phase 0 errata verified and routed; documents and Python, "
        "no Lean, one record re-pointed, no core run); ")
LANDED = ("GT and AA landed as one train (`{commit}`; documents and Python: no Lean, no core run, no law changed; "
          "one record re-pointed with `repoint.py`, its source's output unchanged). GT: a landing now runs the checks "
          "its changed paths can reach, once per tree, heavy runs in slots its worktrees share (`make gate`, "
          "`tools/research/gate.py`), with a board guard, every freeze read from its own records, the core receipt "
          "checked against the Lean and the dossier check run by the gate; `research.py check` takes about 33 s where it took about 77 s, its results "
          "identical; the new rules apply from the next landing, and GT2 (the Lean checker) and GT3 (the tests on "
          "fixtures) follow ([GATE.md](research/2026-10-05-repository-reconciliation/architecture/gt/GATE.md)). "
          "AA: the atlas plan for Ren's review, and its errata verified, 38 of 40 holding, each sent to its page's "
          "owner through the coordinator ([ROUTING](research/2026-10-05-generative-foundation-review/root-foundation/development/aa-attractor-atlas/phase0/ROUTING.md)); ")
RULE5_OLD = "5. **Landing queue.** One checker run at a time, in the queue's order."
RULE5_NEW = ("5. **Landing queue.** Heavy runs take one of the slots this repository's worktrees share "
             "(`tools/research/gate.py status` shows who holds them), and landings go in the queue's order. Landings ready together go as one train: each "
             "keeps its own commits and landed clause, the gate names under a failing check the landings whose change "
             "reaches it, and those leave the train while the rest go on "
             "([GT](research/2026-10-05-repository-reconciliation/architecture/gt/GATE.md#4-part-3-trains)).")
RULE5_TAIL_OLD = "since each such commit sends the lander round another merge and render."
RULE5_TAIL_NEW = ("since each such commit sends the lander round another merge and render; after that merge "
                  "`make gate` re-runs only what the commit reaches.")
GT_OLD = "and `research.py check` spends 131 of its 179 seconds recomputing the same Markdown drift comparisons"
GT_NEW = "and `research.py check` spends about 50 of its 77 seconds recomputing the same Markdown drift comparisons"
GT_STATE_OLD = "claimed 4 November 2026 on `1e9bc6b85`; design and tool in progress; the coordinator is told before its landing"
GT_STATE_NEW = "claimed 4 November 2026 on `1e9bc6b85`; landed `{commit}` with AA's first item; GT2 and GT3 next, each to be claimed"
AA_STATE_OLD = "claimed 4 November 2026 on `1e9bc6b85`; plan written; Phase 0 after GT"
AA_STATE_NEW = "claimed 4 November 2026 on `1e9bc6b85`; plan and Phase 0's routing landed `{commit}` (with GT); the plan awaits Ren's review; the unheld errata next"


def once(text, old, new):
    if text.count(old) != 1:
        raise SystemExit(f'expected exactly one occurrence, found {text.count(old)}: {old[:80]!r}')
    return text.replace(old, new)


def main():
    what, board = sys.argv[1], Path(sys.argv[2])
    text = board.read_text()
    lines = text.split('\n')
    i = next(k for k, l in enumerate(lines) if l.startswith(QUEUE))
    if what == 'head':
        if 'landing now' in lines[i][:400]:
            raise SystemExit('a head clause already stands')
        lines[i] = QUEUE + HEAD + lines[i][len(QUEUE):]
    elif what == 'landed':
        commit = sys.argv[3]
        if not lines[i].startswith(QUEUE + HEAD):
            raise SystemExit('the head clause is not GT and AA\'s')
        lines[i] = QUEUE + LANDED.format(commit=commit) + lines[i][len(QUEUE + HEAD):]
        text = '\n'.join(lines)
        for old, new in ((RULE5_OLD, RULE5_NEW), (RULE5_TAIL_OLD, RULE5_TAIL_NEW), (GT_OLD, GT_NEW),
                         (GT_STATE_OLD, GT_STATE_NEW.format(commit=commit)), (AA_STATE_OLD, AA_STATE_NEW.format(commit=commit))):
            text = once(text, old, new)
        lines = text.split('\n')
    else:
        raise SystemExit(__doc__)
    new = '\n'.join(lines)
    board.write_text(new)
    print(f'{what}: {len(text if what == "head" else new)} characters; Queue line {len(lines[i])}')


if __name__ == '__main__':
    main()
