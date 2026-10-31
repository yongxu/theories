#!/usr/bin/env python3
"""U4's board lines, from the checkout root of a worktree on main's tip (the board is edited in one's own worktree):

  python3 -B <dir>/board_u4.py head                     the head clause, before the Queue line's first clause
  python3 -B <dir>/board_u4.py landed RECEIPT N ORDER   the landed clause in place of the head clause, the order
                                                        sentence after it (ORDER: a file holding the coordinator's
                                                        sentence), earlier clauses kept as they are, and U4's row

Each edit asserts that it applies exactly once.
"""
import json
import re
import sys
from pathlib import Path

BOARD = Path('_process/BECOMING-WORKBOARD.md')
QUEUE = '- **Queue:** '
HEAD = ("U4's leaf and boundary record at the head of the queue (landing now: `Becoming.RootForms` joins the core as a "
        "leaf, 30 theorems in 42 declarations, one incremental core run in place; the record `one-root-to-its-edge`, "
        "home 08 §7, carrying MV's boundary field, each central declaration placed; 08 §3's receipt sentence from the "
        "landing's run; the leaf's roots in the apart register; one study section; then render, strict check, links and "
        "tests, then the fast-forward); ")
ORDER = re.compile(r"Then, in the coordinator's order: [^\n]*?ask the coordinator for a slot\. ")


def lines():
    t = BOARD.read_text(encoding='utf-8')
    rows = t.split('\n')
    q = [i for i, x in enumerate(rows) if x.startswith(QUEUE)]
    assert len(q) == 1, q
    return t, rows, q[0]


def head():
    t, rows, i = lines()
    assert HEAD not in rows[i], 'the head clause is in place'
    rows[i] = QUEUE + HEAD + rows[i][len(QUEUE):]
    BOARD.write_text('\n'.join(rows), encoding='utf-8')
    print('head clause written')


def landed(receipt, n, order):
    t, rows, i = lines()
    assert rows[i].startswith(QUEUE + HEAD), 'the head clause is not first'
    order = Path(order).read_text(encoding='utf-8').strip()
    assert order.startswith("Then, in the coordinator's order: ") and order.endswith('ask the coordinator for a slot.')
    v = json.loads(Path(receipt).read_text(encoding='utf-8'))
    assert v['status'] == 'passed'
    m = {x['module']: x for x in v['modules']}['Becoming.RootForms']
    assert not any(a for x in v['modules'] for a in x['axiom_dependencies'].values())
    stamp = Path(receipt).parent.name
    run = json.loads(Path(receipt).parent.parent.parent.joinpath('becoming-verification.json').read_text(encoding='utf-8'))
    assert run['utc'] == stamp, (run['utc'], stamp)
    steps = run['lean_steps']
    ran = [x for x in steps['ran'] if x in steps['keys']]
    data = json.loads(Path('theories/becoming/results/data/master-laws.json').read_text(encoding='utf-8'))['boundary']
    c = data['counts']
    assert data['record'] == 'one-root-to-its-edge' and not data['unverified'] and c['unplaced'] == 0
    dist = sum(v for k, v in c.items() if k not in ('derived', 'under a stated hypothesis', 'premise', 'counting',
                                                     'unplaced'))
    clause = (
        f"U4's leaf and boundary record landed (§{n}, core receipt `{stamp}`, every axiom report empty, one incremental "
        f"core run in place, {len(ran)} module steps run and {len(steps['reused']):,} reused: `Becoming.RootForms` joined "
        f"the core as a leaf, {m['theorems']} theorems in {len(m['declarations'])} declarations, row 17's root form "
        f"`outside_leaves_no_offspring` with a countermodel and a fit for each of its three hypotheses, "
        f"`GroupEnding.Flow.all_end` its case at one step, and row 5's relational part `descent_forms_no_dependence`; "
        f"the record `one-root-to-its-edge`, home 08 §7, places the {c['derived'] + c['under a stated hypothesis'] + c['counting'] + dist} "
        f"distinct central declarations, {c['derived']} derived (two of them through HE2's laws of a closure), "
        f"{c['under a stated hypothesis']} under a stated hypothesis, {c['counting']} counting and {dist} at a named "
        f"distance with its reason, none unplaced, the ethics' two premises listed apart (the condition for scope, not "
        f"entailed; C for order, no such theorem); MV's boundary report reads it, nothing unverified or unplaced, the "
        f"Lean check run; 08 §3's receipt sentence from the run; the leaf's 12 roots in the apart register; an "
        f"independent review, 22 findings, every one taken; rehearsed three times, the last two under MV's follow-up "
        f"rule; render, strict check, links (0 broken), the record's lint and the 305 tests pass in the landing worktree). ")
    rest = rows[i][len(QUEUE + HEAD):]
    assert ORDER.match(rest) is None and rest.startswith("MV's follow-up and the README's first screen landed")
    rows[i] = QUEUE + clause + order + ' ' + rest
    u = [j for j, x in enumerate(rows) if x.startswith('| **U4: one root to its edge**')]
    assert len(u) == 1, u
    cells = rows[u[0]].split(' | ')
    note = (f" **Leaf and boundary record landed 31 October 2026** (study §{n}, core receipt `{stamp}`): "
            f"`Becoming.RootForms` in the core and the record `one-root-to-its-edge` (home 08 §7); next, the record's "
            f"next step (a root form for the census rows, a theorem that no statement reading only the dynamics "
            f"entails C, the root reading of significance for the three rows keeping it free).")
    assert 'Leaf and boundary record landed' not in rows[u[0]]
    assert cells[2].startswith('claimed 30 October 2026'), cells[2][:60]  # item | owner | status | paths | depends
    cells[2] = cells[2].rstrip().rstrip('.') + '.' + note
    rows[u[0]] = ' | '.join(cells)
    BOARD.write_text('\n'.join(rows), encoding='utf-8')
    print('landed clause written:', clause[:160], '…')


if __name__ == '__main__':
    if sys.argv[1] == 'head':
        head()
    elif sys.argv[1] == 'landed':
        landed(*sys.argv[2:5])
    else:
        sys.exit(__doc__)
