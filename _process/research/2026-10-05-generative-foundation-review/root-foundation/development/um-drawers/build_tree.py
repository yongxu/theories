#!/usr/bin/env python3
"""Build UM's tree: Optimum with one model of drawers in turn, every drawer with a floor, and one law of best response.
usage: python3 -B build_tree.py   (UM_ROOT names the checkout to read; UM_BASE, a git ref of it, reads it at that ref).
Writes tree/Becoming/Optimum.lean."""
import os
import subprocess
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = Path(os.environ['UM_ROOT']).resolve() if os.environ.get('UM_ROOT') else HERE.parents[5]
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'


def once(text, old, new):
    assert text.count(old) == 1, ('edit does not match once', old[:90], text.count(old))
    return text.replace(old, new)


def region(text, start, stop, new, keep_stop=True):
    assert text.count(start) == 1, ('start not once', start[:80], text.count(start))
    i = text.index(start)
    j = text.index(stop, i)
    return text[:i] + new + (text[j:] if keep_stop else text[j + len(stop):])


def read(name):
    if os.environ.get('UM_BASE'):
        rel = (PKG / 'Becoming' / f'{name}.lean').relative_to(ROOT)
        return subprocess.run(['git', '-C', str(ROOT), 'show', f"{os.environ['UM_BASE']}:{rel}"], check=True,
                              capture_output=True, text=True).stdout
    return (PKG / 'Becoming' / f'{name}.lean').read_text(encoding='utf-8')


op = read('Optimum')
assert 'theorem kept_returns' not in op, 'already built'
text = lambda n: (HERE / n).read_text(encoding='utf-8')
# The one model: SG14's two drawers, SG17's any number, SG16's revision and SG15's capacities replaced.
op = region(op, '/-! ## Drawers in turn, each ranking courses', 'end InTurn\n', text('in_turn.lean'), keep_stop=False)
# One web law.
op = region(op, '/-- **Drawers in turn, any number from two, break at the first step', '\nend Web\n', text('web.lean'))
# Two witnesses.
op = region(op, '/-- **The gate witness: alone a drawer may keep the dweller; in turn every perfect profile breaks',
            '\n\nend Holding\n\nend Optimum\n', text('witness.lean'))
# The header: one bullet for the model, the reading and what is not derived.
op = region(op, '* **Drawers in turn, each ranking courses.**', '\n**Reading (the AI\'s).** This is the spine\'s form',
            text('header.md'))
op = region(op, 'With two drawers in turn, each ranking courses, the\n', 'every perfect profile draws everything.\n',
            '''With drawers in turn, each ranking courses, the
others' rule is derived: at every subgame-perfect profile, a mutual best response at every step from
every level, every drawer draws everything wherever there are two or more and no floor, so the base
ends at once wherever nothing stands at nothing, the open-access outcome as the unique perfect one
(the dynamic commons, Levhari and Mirman 1980; alternating moves). What the spine's form adds: every
perfect profile, not one equilibrium, over any law of what stands and any number of drawers, with no
discounting, and the reason in one law: a drawer keeps only what returns to it at least one for one,
and what one drawer leaves goes to the next. Far-sight on all sides does not keep the base that one
alone, far-sighted, may keep, nor does learning: revising toward best responses from any profile,
restraint included, comes to drawing everything within twice the horizon, the backward induction run
as a process (best-response dynamics; Fudenberg and Levine 1998). A floor can bring restraint back:
where the other can take only a unit a step, what the first leaves returns to it, and leaving
everything is its best response.
''', keep_stop=False)
op = once(op, '''drawers ranking courses
and drawing at once, and how such optimizers come to a mutual best response other than by revision;
for drawers whose capacities limit a draw, which profiles are perfect away from the last step and the
steps where what the other draws after is fixed; for several optimizers,''', '''drawers ranking courses
and drawing at once, and how drawers come to a mutual best response other than by revision; for
drawers whose floors bind, which profiles are perfect away from the last step and the steps where what
a drawer draws later is fixed; for several optimizers,''')
out = HERE / 'tree' / 'Becoming' / 'Optimum.lean'
out.parent.mkdir(parents=True, exist_ok=True)
out.write_text(op, encoding='utf-8')
print('wrote', out.name, len(op.splitlines()), 'lines')
