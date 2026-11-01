#!/usr/bin/env python3
"""U4c's claim row, from the checkout root of a worktree on main's tip (the board is edited in one's own worktree):

  python3 -B <dir>/board_u4c.py claim BASE    the claim row after U4b's row (BASE: main's short hash it is claimed on)

It refuses while a clause stands at the head of the queue, and asserts that it applies once.
"""
import sys
from pathlib import Path

BOARD = Path('_process/BECOMING-WORKBOARD.md')
DESIGN = ('research/2026-10-05-generative-foundation-review/root-foundation/development/u4-one-root-to-its-edge/'
          'CENSUS-ON-THE-ROOT.md')


def claim(base):
    rows = BOARD.read_text(encoding='utf-8').split('\n')
    q = [x for x in rows if x.startswith('- **Queue:** ')]
    assert len(q) == 1 and 'at the head of the queue' not in q[0][:300], ('a clause stands at the head', q[0][:300])
    assert not any(x.startswith('| **U4c: ') for x in rows), 'U4c is claimed'
    u = [j for j, x in enumerate(rows) if x.startswith('| **U4b: counting and amounts, one line**')]
    assert len(u) == 1, u
    row = ' | '.join([
        f"| **U4c: the census on the root** (the record `one-root-to-its-edge`'s first next step, \"a root form for the "
        f"census rows\"; [design]({DESIGN})). One law of the root's own beginnings and endings (`«生»`, `«亡»` of "
        f"`«续» R E`) over a listed run, in GrammarLaws' census section: its step form (nothing splits, every "
        f"predecessor of a unit listed after stands before, each unit listed once: the units after with the endings "
        f"at most the units before with the beginnings) and its run form (endings without end need beginnings without "
        f"end). `Listed.coming_of_ceasing` and `Web.Census.arisingFrom_of_ceasingFrom(_from)` re-proved as its cases, "
        f"their statements unchanged; `CensusWebs.keep_pace` kept at counting with its reason; the record's standings, "
        f"08 §7's counts, the law in the master laws' record (01 §7)",
        'Claude Code desktop session "time moves fast, for all our" (U4\'s owner), 1 November 2026',
        f"claimed 1 November 2026 on `{base}`; design reviewed before Lean; scratch Lean, its countermodels and the "
        f"re-proofs checked outside the package; names and placement from GrammarLaws' owner; lands in OU7's one "
        f"near-full rebuild, inside its kit or on top of it in the same core run, as OU's owner and U4's owner agree",
        "`development/u4-one-root-to-its-edge/`; at landing `Becoming/GrammarLaws.lean` (the census section), "
        "`Becoming/Population.lean`, `Becoming/Identity.lean`",
        "OU7's rebuild (one core run); GrammarLaws' owner for names |",
    ])
    rows.insert(u[0] + 1, row)
    BOARD.write_text('\n'.join(rows), encoding='utf-8')
    print('claim row written after U4b')


if __name__ == '__main__':
    if sys.argv[1:2] == ['claim'] and len(sys.argv) == 3:
        claim(sys.argv[2])
    else:
        sys.exit(__doc__)
