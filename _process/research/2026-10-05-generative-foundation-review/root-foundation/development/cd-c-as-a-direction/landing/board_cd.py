#!/usr/bin/env python3
"""CD's board texts: the claim row, the head clause, and at landing the landed clause and the row's state.

claim BOARD: CD's row inserted at the end of Open claims (used 3 November 2026).
head BOARD:  the clause "CD at the head of the queue (landing now: ...); " at the front of the Queue line, behind no
             other "landing now" clause.
land BOARD:  the head clause dropped and the landed clause put first; CD's row stays open, its state saying what
             landed and what waits for the next edition, each with its carrier.
usage: python3 -B board_cd.py claim|head|land BOARD
"""
import re
import sys

ITEM = "| **CD: C as a direction, its order read from the difference between options**"
CLAIM = (ITEM + " (Ren's words of 3 November 2026 on ranking as a reader's construct, through the coordinator; kept in "
         "sources at landing). Purpose: whether the ethics needs a ranking at all, or only a direction and a reading of the "
         "difference between options, and C stated through what it reads. Two parts. A sweep of 07, the fronts and the "
         "glossary for comparisons stated with no relational basis (better and worse, higher and lower, best and optimum, "
         "rank), each kept with what it reads and who holds it, restated or dropped, a field's own frame kept as the "
         "field's. And whether C's comparison is exactly the order a direction toward widening what can form induces on the "
         "difference between two options, read against `Comparison`, `Extension`, the reach frame and the weighting laws, "
         "with what is lost said exactly. A change to C's statement goes through the generativity chain's maintenance "
         "record. Documents first; any new Lean takes its own claim row "
         '| Claude Code desktop session "Theory status and claims" '
         "| claimed 3 November 2026 "
         "| worktree `.claude/worktrees/reader-measure` "
         "| behind the finish items, after AGENTS.md's rewrite → C stated as what it reads; the fronts' comparisons on their "
         "relational basis |")

NAME = 'CD'
HEAD_TEXT = ("landing now, by readiness, before the freeze: documents only, no Lean and no core run: C as a direction, its "
             "order read from the difference between options; what \"better\" adds beyond that difference, said exactly; "
             "the names test's two record renames and the shared law's label; premise-free \"ranks\" restated in 07, 08 "
             "and the records, with an independent check's findings taken: 07 §5's sentence on what C ranks, the start "
             "the causal-set laws need, two orders of grain, restraint's condition; a registry fix for renamed records; "
             "24 records re-pointed after reading; render, strict check, links, tests and both dossier checks, then the "
             "fast-forward")
HEAD = re.compile(re.escape(NAME) + r' at the head of the queue \([^()]*\); ')
DESIGN = ('[DESIGN](research/2026-10-05-generative-foundation-review/root-foundation/development/cd-c-as-a-direction/'
          'DESIGN.md)')
LANDED = (
    "CD landed (C as a direction, its order read from the difference between options; documents only: no Lean and no "
    "core run; " + DESIGN + "). The answer: \"better\" adds exactly one thing beyond the difference between two courses, "
    "that the widening side of it is better, the whole of C, a premise not asserted; it adds no measure of the difference, "
    "no top (`Comparison.outgrows`), no verdict on a mixed pair (`Weighting.mixed_either_way`) and no one frame "
    "(`KeptAlternative.no_comparison_both`), so the ethics needs no ranking beyond the differences and that premise. C is "
    "not restated as \"the direction to take\": that would hide its content in \"to take\", where choosing needs L and "
    "J1–J4, and blur four senses of direction; two independent readers refuted that first draft, kept as a failed "
    "candidate. Under the glossary's one sense of ranking (the fronts' owner, 5e7b118a9), a names test (162 names "
    "judged, 61 re-read by refuters) renamed two record ids with their former ids kept "
    "(widening-as-what-every-positive-weighting-ranks, since a zero weight ties; whole-and-regions-and-bounded-centers, "
    "since no priority is proved) and relabelled the shared law \"Order\" as \"Widening\", its id kept; where premise-free "
    "widening or a lagged, tail or lexical order was said to rank, 07's thesis line, §2 and open items, 08 and the laws "
    "and statements of eleven records say what it does (widens, puts above, holds of a pair in opposite directions); "
    "`Ranking`, `Better`, the `_ranks` names, \"gives order\" and the orders offered as rankings are kept with their "
    "reasons. An independent check of the whole change (three lenses, each verified, and a completeness critic; seven AI "
    "agents) found what the first round got wrong, all taken (DESIGN §7): 07 §5 now says C ranks a course above each "
    "course it extends on the reading of living it is read on, which only read on what a course admits is each course it "
    "widens; the causal-set reading names the start from the empty set its laws need; 08's Widening row gives the law as "
    "including and exceeding, retaining and adding only under the condition; the kind relay's generation is \"at two "
    "orders of grain\" (02 §1); restraint extends overdraw exactly where it includes what overdraw withholds. 07 §1's "
    "first sentence names the thesis it stands on, one relational unfolding, argued and not proved. The registry counts a "
    "link to a renamed record's former id as locating it, with a test; the dossiers' quotations follow 07; 24 records "
    "re-pointed after reading, nothing they say changed. Next edition, not before the freeze: C's statement in pairwise "
    "form through the chain's maintenance record, and two Lean renames (`Ranking.readings_rank_presence`, "
    "`Web.widens_iff_every_weighting`) with twelve docstrings, on a row of their own with a core run; P-07 and P-02's "
    "paraphrase with the philosophy dossier's owner at the freeze, the overview's sentence on the unfolding with the "
    "fronts' owner, the cold read key's item 2.11 with the reader measure's owner. With it, the way now's two items carried "
    "from 2 November are marked done with the hashes that did them (a name given as the ground of a step, GC3 6606c273a; "
    "the stale counts, OU's closures bfa1f8cdf). ")
OLD_STATE = "| claimed 3 November 2026 |"
NEW_STATE = ("| claimed 3 November 2026; documents landed (the answer in " + DESIGN + " §1, the names in §3); next "
             "edition: C's statement in pairwise form (*of two courses, one that widens the other is better than it*) "
             "through the generativity chain's maintenance record with the fronts' owner, and the two Lean renames and "
             "twelve docstrings of its §3 on a row of their own with a core run |")


CARRIED_OLD = ('two items carried from 2 November, a name given as the ground of a step (held by "Theory status and '
               'claims") and the stale counts (with OU\'s closures), each closed by its holder or said to be done;')
CARRIED_NEW = ('the two items carried from 2 November are done, a name given as the ground of a step by GC3 (6606c273a) '
               'and the stale counts by OU\'s closures (bfa1f8cdf);')


def queue_line(lines):
    at = [i for i, line in enumerate(lines) if line.startswith('- **Queue:** ')]
    assert len(at) == 1, at
    return at[0]


def main():
    mode, board = sys.argv[1], sys.argv[2]
    lines = open(board, encoding='utf-8').read().split('\n')
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
        q = queue_line(lines)
        assert '(landing now' not in lines[q], 'another clause holds the head: ' + lines[q][:200]
        clause = f'{NAME} at the head of the queue ({HEAD_TEXT}); '
        assert HEAD.fullmatch(clause), clause
        lines[q] = lines[q].replace('- **Queue:** ', '- **Queue:** ' + clause, 1)
    elif mode == 'land':
        q = queue_line(lines)
        assert lines[q].startswith('- **Queue:** ' + NAME + ' at the head') and len(HEAD.findall(lines[q])) == 1, \
            'not at the head'
        lines[q] = HEAD.sub('', lines[q], count=1)
        lines[q] = lines[q].replace('- **Queue:** ', '- **Queue:** ' + LANDED, 1)
        rows = [i for i, line in enumerate(lines) if line.startswith(ITEM)]
        assert len(rows) == 1, rows
        assert lines[rows[0]].count(OLD_STATE) == 1, "the row's state"
        lines[rows[0]] = lines[rows[0]].replace(OLD_STATE, NEW_STATE, 1)
        # The two items carried from 2 November, struck in the way now with the hashes that did them (the
        # coordinator's word: carried in CD's landing, not a gap commit); skipped if their holder struck them already.
        text = '\n'.join(lines)
        n = text.count(CARRIED_OLD)
        assert n in (0, 1), n
        if n == 1:
            text = text.replace(CARRIED_OLD, CARRIED_NEW, 1)
            print('carried items struck')
        lines = text.split('\n')
    else:
        raise SystemExit(__doc__)
    open(board, 'w', encoding='utf-8').write('\n'.join(lines))
    print(mode, 'written')


if __name__ == '__main__':
    main()
