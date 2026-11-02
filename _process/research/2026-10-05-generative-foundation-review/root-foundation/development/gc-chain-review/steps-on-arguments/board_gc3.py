#!/usr/bin/env python3
"""GC3's board texts: the claim row, the head clause, and at landing the landed clause and the history row.

usage: python3 -B board_gc3.py claim BOARD
       python3 -B board_gc3.py head BOARD
       python3 -B board_gc3.py landed BOARD HISTORY ORDER_FILE CHECKED_ON TESTS
"""
import sys

PREFIX = '- **Queue:** '
ITEM = '| **GC3: each step in the generativity chain on its argument**'
CLAIM = (ITEM + ' (GC2\'s B7; the coordinator\'s word, 2 November 2026). Purpose: the chain\'s steps resting on arguments '
         'a reader can weigh, not on a name, as AGENTS.md asks. Each step that stood on the name gives its argument, or '
         'says that it has none yet; the words stay verbatim in `sources/`. Through the [maintenance record]'
         '(research/2026-10-05-generative-foundation-review/root-foundation/GENERATIVITY-CHAIN-INDEX-RECORD.md'
         '#gc3-steps-on-their-arguments-2-november-2026), with an independent read. Documents only: no Lean, no record '
         'changed and no core run '
         '| Claude Code desktop session "Theory status and claims" '
         '| claimed 2 November 2026; the text, an independent AI read and its re-check done on the branch, every finding taken '
         '| branch `chain-b7` (`.claude/worktrees/reader-measure`) '
         '| the head after SJ, on the coordinator\'s word → B7 closed; README\'s three first-screen corrections with it if PF3 has landed, else after PF3 |')

HEAD = ("GC3 at the head of the queue (landing now, on the coordinator's word: each step in the generativity chain that "
        "stood on a name given its argument, or marked as resting on none yet, through its maintenance record; D43's "
        "dated line; documents only, no Lean, no record changed and no core run; then render, strict check, links, tests "
        "and both dossier checks, then the fast-forward)")

LANDED = ("GC3 landed (documents only, no Lean, no record changed and no core run): GC2's B7 through the chain's maintenance "
          "record. Each step in the generativity chain that stood on a name (13 entries and 22 pairs of link labels) now "
          "gives its argument or says that it has none yet, the words untouched in `sources/`. Eleven steps carry the "
          "mark \"no argument given\", none supplied for them: C01's standard, C03's direction, C14's turn to theory, "
          "C17's taking of G0, the reopening of the zero-axiom target in C17 and C20, C20's turn to universal normative "
          "grounding, M15's objective, M20's priority and its next routes, and the place of M26's links. Sentences that "
          "said a thing was requested now say the thing; C03, C17 and C20 link their sources; the key says that an argument "
          "given is the work's reason at the entry's scope and that a step neither argued nor marked has not yet been read "
          "for this, so the chain as a whole is not finished by it; D43's sentence on the chain marked outgrown by a dated "
          "line, as D45's was. Two independent AI reads taken, 42 findings and then 13 on the changed sentences, each read "
          "against its source and all taken. Left for the next reading: B8, G0 use by use, the 82 entries' routes to the "
          "live statement, the labels' tense, the relabelling page's move to history and the opening scope's four links. "
          "GC3's row in the history file; render, strict check, links (0 broken), the {tests} tests and both dossier checks "
          "pass on {checked}. {order}")

ROW = ("| **GC3: each step in the generativity chain on its argument, done** (GC2's B7; the coordinator's word, 2 November "
       "2026). Each step that stood on a name (13 entries, 22 pairs of link labels) gives its argument or says that it has "
       "none yet; eleven carry the mark, none supplied for them; the words untouched in `sources/`; the key says a step "
       "neither argued nor marked has not yet been read for this; D43's dated line. Two independent AI reads, 55 findings, "
       "all taken. B8, G0 use by use and the entries' routes left for the next reading. No Lean, no record changed, no "
       "core run "
       "| Claude Code desktop session \"Theory status and claims\" (2 November 2026) "
       "| landed 2026-11-02 (on the coordinator's word, documents only): render, strict check, links (0 broken), the "
       "{tests} tests and both dossier checks pass on {checked} "
       "| [maintenance record](../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/"
       "GENERATIVITY-CHAIN-INDEX-RECORD.md#gc3-steps-on-their-arguments-2-november-2026) "
       "| the chain's data and table, its maintenance record, D43's dated line, the kit with the readers' reports |")


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
        assert not any('GC3: each step in the generativity chain' in l for l in h), 'row already present'
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
