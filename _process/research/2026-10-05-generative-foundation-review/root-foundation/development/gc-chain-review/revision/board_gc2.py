#!/usr/bin/env python3
"""GC2's board texts: the claim row, the head clause, and at landing the landed clause and the history row.

usage: python3 -B board_gc2.py claim BOARD
       python3 -B board_gc2.py head BOARD
       python3 -B board_gc2.py landed BOARD HISTORY ORDER_FILE CHECKED_ON
"""
import sys

PREFIX = '- **Queue:** '
ITEM = '| **GC2: the chain\'s open proposals decided, in one revision through its maintenance record**'
CLAIM = (ITEM + ' (DF\'s [LEFT](research/2026-10-05-repository-reconciliation/architecture/df/LEFT.md); the board\'s '
         '"moved to their owners, decided on argument", 31 October; the coordinator\'s word, 2 November 2026). Purpose: '
         'the generativity chain stating the current account in its own entries. A1–A8, batch B\'s option, the retired '
         'labels of 19 October, B1–B6 and DF\'s two registration-sense id renames decided on argument, the declined '
         'kept with their reasons in the [maintenance record](research/2026-10-05-generative-foundation-review/'
         'root-foundation/GENERATIVITY-CHAIN-INDEX-RECORD.md); every pending source read and the table rendered. '
         'Documents only: no Lean, no new record and no core run '
         '| Claude Code desktop session "Theory status and claims" '
         '| claimed 2 November 2026; the text, the renames, the reading and an independent AI read done on the branch, the read\'s findings being taken '
         '| branch `chain-revision` (`.claude/worktrees/chain-revision`) '
         '| the coordinator\'s slot after LN2 → the chain current with the account, DF\'s LEFT closed |')

HEAD = ("GC2 at the head of the queue (landing now, on the coordinator's word: the generativity chain's open proposals "
        "decided in one revision through its maintenance record, A1–A8, batch B's option, the retired labels, B1–B6 "
        "and DF's two registration-sense id renames by research.py rename-id; every pending source read and the table "
        "rendered; documents only, no Lean, no new record and no core run; then render, strict check, links, tests and "
        "both dossier checks, then the fast-forward)")

LANDED = ("GC2 landed (documents only, no Lean, no new record and no core run): the generativity chain's open proposals "
          "decided in one revision through its maintenance record. Taken: A1, the status clause in C03, C17, C24, M15 "
          "and M20 (living significance, the Lean G0 under its present name, follows under the continuation condition; "
          "what G0 stated says more; ranking rests on C; neither premise asserted, 07 §3–§4); A2 to A7, the decisions, "
          "excluded middle, slot counts and range the Lean takes; A8; batch B's option; the retired labels' key, "
          "stating both senses of G0 (option (b)); B1, B2 as a link, B3's labels, B4 at the two renamed records and B6; "
          "the ids selection-when-the-lumping-changes and formed-contacts-change-copying-fidelity by research.py "
          "rename-id, with home anchors at the new ids; D45 (6)'s last sentence marked history. Declined, with reasons: "
          "options (a) and (c), B3's links and B5. Left for the next reading: B7 (Ren's direction as a ground), B8 (the "
          "other registration words), G0 use by use, each entry's route to the live statement, and the relabelling "
          "page's move to history. Every pending source read and recorded, the table rendered from the data, an "
          "independent AI read taken (37 findings, every blocker and fix taken); the records the renames' rewrites "
          "drift re-pointed after reading; render, strict check, links (0 broken), the 305 tests and both dossier "
          "checks pass on {checked}. Then, in the coordinator's order: {order}")

ROW = ("| **GC2: the chain's open proposals decided, in one revision through its maintenance record** (the coordinator's "
       "word, 2 November 2026; DF's LEFT). A1–A8, batch B's option, the retired labels' key with both senses of G0, "
       "B1, B2 as a link, B3's labels, B4 at the renamed records and B6 taken; options (a) and (c), B3's links and B5 "
       "declined with reasons; B7, B8, G0 use by use and the entries' routes left for the next reading; the ids "
       "selection-when-the-lumping-changes and formed-contacts-change-copying-fidelity by research.py rename-id; every "
       "pending source read, the table rendered, an independent AI read taken. No Lean, no new record, no core run "
       "| Claude Code desktop session \"Theory status and claims\" (2 November 2026) "
       "| landed 2026-11-02 (on the coordinator's order, documents only): render, strict check, links (0 broken), the "
       "305 tests and both dossier checks pass on {checked} "
       "| [maintenance record](../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/"
       "GENERATIVITY-CHAIN-INDEX-RECORD.md#gc2-chain-revision-2-november-2026) "
       "| the chain's data and table, its maintenance record, DF's LEFT, the relabelling proposal's note, D45's dated "
       "line, the rename receipt, the records re-pointed, the home anchors |")


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
        history, order, checked = sys.argv[3], open(sys.argv[4]).read().strip(), sys.argv[5]
        i = queue_index(lines)
        rest = lines[i][len(PREFIX):]
        assert rest.startswith(HEAD + '; '), 'our head clause is not first'
        order = order if order.endswith('.') else order + '.'
        lines[i] = PREFIX + LANDED.format(checked=checked, order=order) + ' ' + rest[len(HEAD) + 2:]
        claim = [k for k, l in enumerate(lines) if l.startswith(ITEM)]
        assert len(claim) == 1, claim
        del lines[claim[0]]
        h = open(history).read().split('\n')
        assert not any('GC2: the chain\'s open proposals decided' in l for l in h), 'row already present'
        # the landed rows' table: the one holding BD2's row; the new row after its last row
        bd2 = [k for k, l in enumerate(h) if l.startswith('| **BD2: not going out of a region, on the root, done**')]
        assert len(bd2) == 1, bd2
        last = bd2[0]
        while last + 1 < len(h) and h[last + 1].startswith('| '):
            last += 1
        print('history row after line', last + 1, ':', h[last][:90])
        h.insert(last + 1, ROW.format(checked=checked))
        open(history, 'w').write('\n'.join(h))
    else:
        raise SystemExit(__doc__)
    open(board, 'w').write('\n'.join(lines))


if __name__ == '__main__':
    main()
