#!/usr/bin/env python3
"""U4b's board lines, from the checkout root of a worktree on main's tip (the board is edited in one's own worktree):

  python3 -B <dir>/board_u4b.py head                 the head clause, before the Queue line's first clause
  python3 -B <dir>/board_u4b.py landed N K ORDER     the landed clause in place of the head clause (N: the study
                                                     section; K: the findings the re-check and the third look
                                                     added), the order sentence
                                                     after it (ORDER: a file holding the coordinator's sentence),
                                                     earlier clauses kept as they are, and U4b's row

Each edit asserts that it applies exactly once. The counts come from MV's boundary report, which master_laws.py writes
from the amended record.
"""
import json
import sys
from pathlib import Path

BOARD = Path('_process/BECOMING-WORKBOARD.md')
QUEUE = '- **Queue:** '
HEAD = ("U4b at the head of the queue (landing now: counting and amounts, one line; in the record "
        "`one-root-to-its-edge`, row 13 from amounts to counting and the bases of rows 7, 8 and 14 rewritten; 08 §7's "
        "three counts, DESIGN-BOUNDARY's dated pointer and one study section; documents and one record only, no Lean "
        "and no core run; then render, strict check, links and tests, then the fast-forward); ")


def lines():
    t = BOARD.read_text(encoding='utf-8')
    rows = t.split('\n')
    q = [i for i, x in enumerate(rows) if x.startswith(QUEUE)]
    assert len(q) == 1, q
    return rows, q[0]


def head():
    rows, i = lines()
    assert HEAD not in rows[i], 'the head clause is in place'
    first = rows[i][len(QUEUE):]
    assert 'at the head of the queue' not in first[:200], ('another item is at the head', first[:200])
    rows[i] = QUEUE + HEAD + first
    BOARD.write_text('\n'.join(rows), encoding='utf-8')
    print('head clause written')


def landed(n, k, order):
    rows, i = lines()
    assert rows[i].startswith(QUEUE + HEAD), 'the head clause is not first'
    order = Path(order).read_text(encoding='utf-8').strip()
    assert order.startswith("Then, in the coordinator's order: ") and order.endswith('ask the coordinator for a slot.')
    data = json.loads(Path('theories/becoming/results/data/master-laws.json').read_text(encoding='utf-8'))['boundary']
    c = data['counts']
    assert data['record'] == 'one-root-to-its-edge' and not data['unverified'] and c['unplaced'] == 0
    assert c['counting'] == 7 and c['amounts'] == 18, c
    dist = sum(v for x, v in c.items() if x not in ('derived', 'under a stated hypothesis', 'premise', 'counting',
                                                     'unplaced'))
    clause = (
        f"U4b landed (§{n}; documents and one record only, no Lean and no core run): the line between counting and "
        f"amounts drawn by what a statement says of the dynamics, a law of counting saying nothing of it (as a "
        f"hypothesis, in its conclusion or through a run's states) beyond a counting law's arbitrary predicate; "
        f"`SelectionLevels.rises_exact_iff_levels` (row 13) moved to counting, rows 7, 8 and 14 kept at amounts, "
        f"using the gate and descent as hypotheses, their bases rewritten on the line; the record `one-root-to-its-edge` now places "
        f"{c['counting']} counting, {c['amounts']} at amounts and {dist} at a named distance, none unplaced, MV's "
        f"boundary report reading it with nothing unverified; 08 §7's three figures; DESIGN-BOUNDARY's dated §8; a "
        f"test on a core run's constants giving the same partition on all 25 counting and amounts rows, three by named "
        f"readings; an independent review (nine findings), its re-check and a third look ({k} more), every one taken; render, strict "
        f"check, links (0 broken), the record's lint and the tests pass in the landing worktree). ")
    rest = rows[i][len(QUEUE + HEAD):]
    assert ' landed' in rest[:200], ('the next clause is not a landed clause', rest[:200])
    rows[i] = QUEUE + clause + order + ' ' + rest
    u = [j for j, x in enumerate(rows) if x.startswith('| **U4b: counting and amounts, one line**')]
    assert len(u) == 1, u
    cells = rows[u[0]].split(' | ')
    assert len(cells) == 5 and cells[2].startswith('claimed 31 October 2026'), cells[2][:60]  # status cell
    assert 'Landed' not in cells[2]
    note = (f" **Landed** (study §{n}): row 13 at counting, rows 7, 8 and 14 at amounts with their bases rewritten; the "
            f"line was restated after the review by what a statement says of the dynamics, with the same partition as "
            f"the test.")
    cells[2] = cells[2].rstrip().rstrip('.') + '.' + note
    rows[u[0]] = ' | '.join(cells)
    BOARD.write_text('\n'.join(rows), encoding='utf-8')
    print('landed clause written:', clause[:160], '…')


if __name__ == '__main__':
    if sys.argv[1:2] == ['head']:
        head()
    elif sys.argv[1:2] == ['landed'] and len(sys.argv) == 5:
        landed(*sys.argv[2:5])
    else:
        sys.exit(__doc__)
