#!/usr/bin/env python3
"""The board texts of README's three first-screen corrections: the head clause, and at landing the landed clause and the history row.

usage: python3 -B board_corrections.py head BOARD
       python3 -B board_corrections.py landed BOARD HISTORY ORDER_FILE CHECKED_ON TESTS BUDGET
"""
import sys

PREFIX = '- **Queue:** '

HEAD = ("README's three first-screen corrections at the head of the queue (landing now, on the coordinator's word, behind "
        "PF3: the first line no longer says evaluation is included; the continuation condition's gloss whole, ranking "
        "nothing; C gives order and a ranking needs it or a premise in its place; documents only, no Lean, no record "
        "changed and no core run; then render, strict check, links, tests and both dossier checks, then the fast-forward)")

LANDED = ("README's three first-screen corrections landed (documents only, no Lean, no record changed and no core run), the "
          "cold read's findings against 07 as PF3 leaves it. The first line says how anything comes to be, without "
          "\"evaluation included\", which promised more than 07 §1's note on how evaluation forms says. The continuation "
          "condition's gloss has \"from every standpoint\" and \"into the future\" as the glossary does, and the condition "
          "fixes scope and ranks nothing. C gives order, and a ranking needs it or a premise in its place, where \"alone "
          "gives order\" said more than 07 §4's theorem on an order rising with one's own continuation. The screen's pin "
          "follows the first line, PF3 having relaxed the one on C. With them, \"Start with\" names the one path, the one "
          "page then the overview, with the opening set apart. {budget} The row in the history file; render, strict "
          "check, links (0 broken), the {tests} tests and both dossier checks pass on {checked}. {order}")

ROW = ("| **README's three first-screen corrections, done** (the cold read of 2 November, on the coordinator's word, behind "
       "PF3). The first line without \"evaluation included\"; the continuation condition's gloss whole, ranking nothing; C "
       "gives order and a ranking needs it or a premise in its place. With them, \"Start with\" names the one path. No Lean, "
       "no record changed, no core run "
       "| Claude Code desktop session \"Theory status and claims\" (2 November 2026) "
       "| landed 2026-11-02 (documents only): render, strict check, links (0 broken), the {tests} tests and both dossier "
       "checks pass on {checked} "
       "| [the cold read's report](../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/"
       "development/review-packet/COLD-READ-2026-11-02.md#4-where-the-fronts-disagree) "
       "| README's first screen and its pin; the reading budgets' line |")


def queue_index(lines):
    hits = [i for i, l in enumerate(lines) if l.startswith(PREFIX)]
    assert len(hits) == 1, hits
    return hits[0]


def main():
    mode, board = sys.argv[1], sys.argv[2]
    lines = open(board).read().split('\n')
    if mode == 'head':
        i = queue_index(lines)
        rest = lines[i][len(PREFIX):]
        assert 'at the head' not in rest.split('; ')[0], 'head held'
        lines[i] = PREFIX + HEAD + '; ' + rest
    elif mode == 'landed':
        history, order, checked, tests, budget = (sys.argv[3], open(sys.argv[4]).read().strip(), sys.argv[5], sys.argv[6],
                                                  sys.argv[7])
        assert order.startswith("Then, in the coordinator's order") and order.endswith('.'), order
        i = queue_index(lines)
        rest = lines[i][len(PREFIX):]
        assert rest.startswith(HEAD + '; '), 'our head clause is not first'
        lines[i] = PREFIX + LANDED.format(budget=budget, checked=checked, order=order, tests=tests) + ' ' + rest[len(HEAD) + 2:]
        h = open(history).read().split('\n')
        assert not any("README's three first-screen corrections, done" in l for l in h), 'row already present'
        # the landed rows' table: the one holding BD2's row; the new row after its last row
        bd2 = [k for k, l in enumerate(h) if l.startswith('| **BD2: not going out of a region, on the root, done**')]
        assert len(bd2) == 1, bd2
        last = bd2[0]
        while last + 1 < len(h) and h[last + 1].startswith('| '):
            last += 1
        print('history row after line', last + 1, ':', h[last][:90])
        h[last + 1:last + 1] = [ROW.format(checked=checked, tests=tests)]
        updated = '\n'.join(h)
        open(history, 'w').write(updated)
    else:
        raise SystemExit(__doc__)
    open(board, 'w').write('\n'.join(lines))


if __name__ == '__main__':
    main()
