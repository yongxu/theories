#!/usr/bin/env python3
"""Build SG8's tree: the package's Becoming.Optimum (SG7's) with the root docstring's bullet and reading for an order
weighting later draws less, and the section of sg8_section.lean appended before the module's end.
usage: python3 -B build_tree.py   (SG8_ROOT names the checkout to read, one whose Optimum is SG7's; default this
repository)"""
import os
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = Path(os.environ['SG8_ROOT']).resolve() if os.environ.get('SG8_ROOT') else HERE.parents[5]
REL = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Optimum.lean'
s = (ROOT / REL).read_text(encoding='utf-8')
assert 'weightedOver' not in s and 'metRun' in s, 'not SG7\'s Optimum'


def once(text, old, new):
    assert text.count(old) == 1, ('edit does not match once', old[:90], text.count(old))
    return text.replace(old, new)


BULLET_END = '  one of at most one a step breaks it.\n'
s = once(s, BULLET_END, BULLET_END + """* **An order weighting later draws less.** With the draw of the step from `t` weighted by `w t`,
  any weighting, what a course could draw at a step, with what it drew before, changes from one
  step to the next by what the level it leaves gains: that level with its renewal weighted at the
  next step, against it held, weighted at this one (`Optimum.drawable_step`). So against an open
  course from the start leaving nothing whose level at each step gains the most, no course draws
  more, weighted, and every optimum of every order rising with the weighted draw gains at each
  step what that course's level gains and leaves nothing weighted at the end
  (`Optimum.weighted_le_of_gains`, `Optimum.frontier_gains_weighted`); that course is an optimum
  (`Optimum.weighted_frontier`), the course holding a level of greatest weighted gain a case
  (`Optimum.weighted_holding_frontier`), and every optimum breaks at the first step a dependence
  above every level of greatest weighted gain (`Optimum.frontier_below_weighted`,
  `Web.frontier_broken_weighted`). With every weight one the gain of a level is its renewal. Where
  the weighting falls faster than every positive level renews, `w (t + 1) (z + R z) < w t z`, every
  optimum draws its own base to nothing at the first step and holds it there, breaking every
  dependence on it with a positive need (`Optimum.frontier_exhausts`, `Web.frontier_exhausts`), and
  where it falls at least that fast the course doing so is an optimum
  (`Optimum.exhausting_frontier`); where nothing is given at nothing and some level within reach
  renews faster than the weighting falls, `w t y < w (t + 1) (y + R y)`, the course holding it
  outdraws every course ending the base at once, and no optimum stands at nothing after the first
  step (`Optimum.ended_outdrawn`, `Optimum.frontier_leaves`, `Web.frontier_leaves`). The instance
  `Holding.logistic_weighted`: under the logistic law, where one returns two for one, a weighting
  falling more than twofold at every step ends the source at once and breaks the dweller; one
  falling by less than half holds the source at one and breaks the dweller; at exactly twofold both
  courses are optima, so neither strict premise can be dropped.
""")
READING_END = ('breaks it, at the last step alone where the coupling exceeds the renewal forgone a step.\n')
s = once(s, READING_END, READING_END + """Weighting later draws less is discounting (Ramsey 1928; Koopmans 1960). A level gains, weighted,
`w (t + 1) (z + R z)` less `w t z`; at a constant rate `δ`, `w t = (1 + δ) w (t + 1)`, that is
`w (t + 1) (R z - δ z)`, so a level of greatest weighted gain is one of greatest renewal less `δ`
for each unit held, the modified golden rule's level, where the marginal renewal is the rate (Clark
and Munro 1975). Where the weighting falls faster than every positive level renews, a sole owner,
however far-sighted, with a capacity drawing the base down in one step ends its own base at once,
and where some level within reach renews faster, no optimum ends it at once: Clark's result that
extinction is optimal where the rate exceeds the greatest rate of renewal (Clark 1973). An order
weighting each step's draw by `γ` times the one before, `γ` below one as in reinforcement learning,
has every optimum end at the first step any base where every positive level returns less than
`1 / γ` for one and the capacity draws it down in one step. What the spine's form adds: the laws
hold over any order rising with the weighted draw and any weighting, one whose rate changes from
step to step included (Ainslie 1975), through a course whose level gains the most at each step, and
the threshold is exact: where the rates tie, ending and holding are both optima.
""")
NOT_DERIVED = ('everything at the horizon\'s last step, an order valuing what is left or earlier draws more (a\n'
               'terminal value or a discount), several optimizers ranking courses')
s = once(s, NOT_DERIVED, 'everything at the horizon\'s last step, an order valuing what is left at the horizon (a\n'
         'terminal value), the weighted optimum where no course whose level gains the most at each step is\n'
         'open, several optimizers ranking courses')


END = '\nend Becoming\n'
assert s.endswith(END)
section = (HERE / 'sg8_section.lean').read_text(encoding='utf-8')
s = s[:-len(END)] + '\n' + section.rstrip('\n') + '\n' + END
out = HERE / 'tree' / 'Becoming' / 'Optimum.lean'
out.parent.mkdir(parents=True, exist_ok=True)
out.write_text(s, encoding='utf-8')
print('wrote', out, len(s.splitlines()), 'lines')
