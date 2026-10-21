#!/usr/bin/env python3
"""Build SG9's tree: the package's Becoming.Optimum (SG8's) with SG8's reference course generalized below to a course
gaining the most against every open course (gains_most.lean, inserted before `weighted_frontier`, which with
`frontier_gains_weighted` is now its case), the root docstring's bullet and reading for rebuilding from below, and the
section of sg9_section.lean appended before the module's end.
usage: python3 -B build_tree.py   (SG9_ROOT names the checkout to read, one whose Optimum is SG8's; default this
repository)"""
import os
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = Path(os.environ['SG9_ROOT']).resolve() if os.environ.get('SG9_ROOT') else HERE.parents[5]
REL = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Optimum.lean'
s = (ROOT / REL).read_text(encoding='utf-8')
assert 'weightedOver' in s and 'GainsMost' not in s, 'not SG8\'s Optimum'


def once(text, old, new):
    assert text.count(old) == 1, ('edit does not match once', old[:90], text.count(old))
    return text.replace(old, new)


# SG8's reference course generalized below.
WF = '/-- **A course of greatest weighted gain is an optimum.**'
s = once(s, WF, (HERE / 'gains_most.lean').read_text(encoding='utf-8') + WF)
s = once(s, '''  ⟨opens, fun b openB more => Nat.not_le_of_gt more
    (weighted_le_of_gains (fun t => (openB.2 t).1) (fun t => (opens.2 t).1)
      (openB.1.trans opens.1.symm) ends fun t lt => greatest t lt (b (t + 1)))⟩
''', '''  frontier_of_gainsMost opens ends (gainsMost_of_greatest greatest)
''')
i = s.index('theorem frontier_gains_weighted')
j = s.index('  have gains : ∀ t, t < n →', i)
k = s.index('    | .inr ge => Nat.le_antisymm (gains t lt) ge⟩\n', j) + len('    | .inr ge => Nat.le_antisymm (gains t lt) ge⟩\n')
s = s[:j] + '  frontier_gains_of_most rising opens ends (gainsMost_of_greatest greatest) front\n' + s[k:]
s = once(s, '''least what any level does, it is an optimum, among the open courses, of the order by the weighted
draw across `n + 1` steps. -/''', '''least what any level does, it is an optimum, among the open courses, of the order by the weighted
draw across `n + 1` steps: the case of `frontier_of_gainsMost`. -/''')
s = once(s, '''at the last step, nothing, and at each step to the `n`-th leaves a level gaining what the course of
greatest gain's level gains. -/''', '''at the last step, nothing, and at each step to the `n`-th leaves a level gaining what the course of
greatest gain's level gains: the case of `frontier_gains_of_most`. -/''')

BULLET_END = '  courses are optima, so neither strict premise can be dropped.\n'
s = once(s, BULLET_END, BULLET_END + """* **Rebuilding from below.** A course gaining at each step, weighted, at least what the level of any
  open course gains is an optimum, and every optimum gains what it does
  (`Optimum.frontier_of_gainsMost`, `Optimum.frontier_gains_of_most`); the course whose level gains
  at least what any level does is the case (`Optimum.weighted_frontier`,
  `Optimum.frontier_gains_weighted`). Where the start lies below a level `y` and the next level
  rises with the level below `y`, the course rising as fast as what is given allows up to `y`
  stands at each step at or above every open course below `y` (`Optimum.le_rise`); so where the
  weighted gain rises with the level up to `y` and is greatest there, that course, leaving nothing
  at the end, gains the most and is an optimum (`Optimum.rebuilding_gainsMost`,
  `Optimum.rebuilding_frontier`). Where the gain rises strictly below `y`, every optimum stands at
  its level at every step where that level is below `y`, drawing nothing at the step before
  (`Optimum.frontier_rebuilds`), and restores every dependence whose need that level meets
  (`Web.frontier_rebuilds`); where `y` gains more than every other level, every optimum stands at
  `y` once the rising course does (`Optimum.frontier_rebuilt`). The instance
  `Holding.doubling_rebuilds`: a source doubling up to eight, from one, under weights falling by
  less than half a step, is rebuilt to two, four and eight by every optimum, the dweller restored at
  the first step; at exactly twofold the course ending it at once is an optimum too; falling
  faster, every optimum ends it.
""")
READING_END = 'the threshold is exact: where the rates tie, ending and holding are both optima.\n'
s = once(s, READING_END, READING_END[:-1] + """ Rebuilding
from below is the most rapid approach path (Spence and Starrett 1975; Clark 1976): with a draw
counted linearly, a stock below its best level is left to grow as fast as it can, nothing drawn,
until it reaches it. What the spine's form adds: every optimum of every order rising with the
weighted draw does so, under any weighting whose gain rises with the level, and on the way
restores what depends on the base; in the witness the threshold for rebuilding is the one for
ending at once, a weighting falling faster than the base renews ending it rather than rebuilding it.
""")
NOT_DERIVED = ('greatest renewal is out of reach or the capacity cannot draw down to it in one step or draw\n'
               'everything at the horizon\'s last step, an order valuing what is left at the horizon (a\n'
               'terminal value), the weighted optimum where no course whose level gains the most at each step is\n'
               'open, several optimizers ranking courses')
s = once(s, NOT_DERIVED, ('greatest gain is out of one step\'s reach and the next level does not rise with the level\n'
                          'below it, or the capacity cannot draw down to it in one step or draw everything at the\n'
                          'horizon\'s last step, an order valuing what is left at the horizon (a terminal value), the\n'
                          'weighted optimum where no course gains the most against every open course, several optimizers\n'
                          'ranking courses'))


END = '\nend Becoming\n'
assert s.endswith(END)
section = (HERE / 'sg9_section.lean').read_text(encoding='utf-8')
s = s[:-len(END)] + '\n' + section.rstrip('\n') + '\n' + END
out = HERE / 'tree' / 'Becoming' / 'Optimum.lean'
out.parent.mkdir(parents=True, exist_ok=True)
out.write_text(s, encoding='utf-8')
print('wrote', out, len(s.splitlines()), 'lines')
