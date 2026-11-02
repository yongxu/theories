#!/usr/bin/env python3
"""GC4's board texts: the claim row, the head clause, and at landing the landed clause and the history row.

usage: python3 -B board_gc4.py claim BOARD
       python3 -B board_gc4.py head BOARD
       python3 -B board_gc4.py landed BOARD HISTORY ORDER_FILE CHECKED_ON TESTS
"""
import sys

PREFIX = '- **Queue:** '
ITEM = "| **GC4: the generativity chain's next reading**"
RECORD = ('research/2026-10-05-generative-foundation-review/root-foundation/GENERATIVITY-CHAIN-INDEX-RECORD.md'
          '#gc4-the-next-reading-2-november-2026')
CLAIM = (ITEM + " (what GC2 and GC3 left, and C's role after PF3). Purpose: the chain saying what the account says, so that a "
         "reader of it meets no retired word, no premise presented as acting now and no receipt calling itself current. Through "
         "the [maintenance record](" + RECORD + "), with independent reads. Documents only: no Lean, no result statement changed "
         "and no core run "
         '| Claude Code desktop session "Theory status and claims" '
         "| claimed 2 November 2026; the text and three independent AI reads done on the branch, their findings taken "
         "| branch `chain-next-reading` (`.claude/worktrees/reader-measure`) "
         "| behind README's first-screen corrections → the chain agrees with 07 §4; each entry's route to the live statement left |")

HEAD = ("GC4 at the head of the queue (landing now: the generativity chain's next reading through its maintenance record, C's "
        "role as 07 §4 states it, \"registration\" by its sources, G0 use by use, the link labels' tense; 03 §6's one link "
        "text; the relabelling page to history; documents only, no Lean, no result statement changed and no core run; then "
        "render, strict check, links, tests and both dossier checks, then the fast-forward)")

LANDED = ("GC4 landed (documents only, no Lean, no result statement changed and no core run): the generativity chain's next "
          "reading, through its maintenance record. C's role now as 07 §4 states it, in the key and five entries; M21's count "
          "of new living split, a reason under living significance with a supplied articulation and correspondence, and in a "
          "ranking of courses under C or a premise in its place. \"Registration\" by its sources: in C33, F29 and M23 the plain "
          "word, a request's pin; M21's three and three labels by the renamed records. G0 use by use, 108 uses in 15 entries "
          "listed one by one: the test applied selects F14, M25 and C23, which now name the route then taken, and M20's "
          "sentence went against its own note. Link labels that called themselves current now give their date or what they "
          "hold. 03 §6's link text is the record's title, the records binding 03 re-pointed after reading; the relabelling "
          "page in history. Three independent AI reads taken, 21, 30 and 11 findings, each read against its source, about 1.1 "
          "million tokens. Left: each entry's route to the live statement, and the steps neither argued nor marked. GC4's row "
          "in the history file; render, strict check, links (0 broken), the {tests} tests and both dossier checks pass on "
          "{checked}. {order}")

ROW = ("| **GC4: the generativity chain's next reading, done** (what GC2 and GC3 left, and C's role after PF3). C's role as 07 "
       "§4 states it; \"registration\" by its sources; G0 use by use, a per-use list in the kit; the link labels' tense; 03 "
       "§6's link text; the relabelling page in history. Three independent AI reads, 62 findings. Each entry's route to the "
       "live statement and the steps neither argued nor marked left. No Lean, no result statement changed, no core run "
       '| Claude Code desktop session "Theory status and claims" (2 November 2026) '
       "| landed 2026-11-02 (documents only): render, strict check, links (0 broken), the {tests} tests and both dossier "
       "checks pass on {checked} "
       "| [maintenance record](../../../_process/" + RECORD + ") "
       "| the chain's data and table, its maintenance record, 03 §6's link, the re-points, the moved page, the kit with the readers' reports |")


def queue_index(lines):
    hits = [i for i, l in enumerate(lines) if l.startswith(PREFIX)]
    assert len(hits) == 1, hits
    return hits[0]


def main():
    mode, board = sys.argv[1], sys.argv[2]
    lines = open(board).read().split('\n')
    if mode == 'claim':
        assert not any(l.startswith(ITEM) for l in lines), 'already claimed'
        top = lines.index('## Open claims')
        last = top
        while not lines[last].startswith('| Item'):
            last += 1
        while last + 1 < len(lines) and lines[last + 1].startswith('|'):
            last += 1
        lines.insert(last + 1, CLAIM)
    elif mode == 'head':
        i = queue_index(lines)
        rest = lines[i][len(PREFIX):]
        assert 'at the head' not in rest.split('; ')[0], 'head held'
        lines[i] = PREFIX + HEAD + '; ' + rest
    elif mode == 'landed':
        history, order, checked, tests = sys.argv[3], open(sys.argv[4]).read().strip(), sys.argv[5], sys.argv[6]
        assert order.startswith("Then, in the coordinator's order") and order.endswith('.'), order
        i = queue_index(lines)
        rest = lines[i][len(PREFIX):]
        assert rest.startswith(HEAD + '; '), 'our head clause is not first'
        lines[i] = PREFIX + LANDED.format(checked=checked, order=order, tests=tests) + ' ' + rest[len(HEAD) + 2:]
        claim = [k for k, l in enumerate(lines) if l.startswith(ITEM)]
        assert len(claim) == 1, claim
        del lines[claim[0]]
        h = open(history).read().split('\n')
        assert not any("GC4: the generativity chain's next reading" in l for l in h), 'row already present'
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
