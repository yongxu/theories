# Executed by build_tree.py on `op`, the module text: SG11's bullet in the root doc, its reading, and what is not derived.
BULLET_ANCHOR = '''  optimum and breaks the dweller at the first step (`Holding.logistic_broken`); under a gate
  renewing one unit at every level from one, the courses holding the source at the dweller's need
  and below it are both optima and take the same (`Holding.gated_alike`).
'''
BULLET = '''* **Valuing what is left at the horizon.** What a course draws across `n + 1` steps with what it
  leaves after them is at most the start with what is given there and `r` for each step after
  (`Optimum.drawn_add_left_le_most`, `Optimum.open_left_le_most`), exactly where `r` is given at
  every step after the first, whatever is left (`Optimum.most_left_iff`). So where a level `y` of
  greatest renewal is within reach and the capacity covers what the first step draws down to it and
  `r`, over any horizon, every optimum of every order rising with what is drawn and left alike
  stands at a level of greatest renewal at every step from the first to the `n`-th
  (`Optimum.frontier_holds_left`), and the optima of the order by what is drawn and left
  (`Optimum.byDrawnLeft`) are exactly the open courses doing so (`Optimum.frontier_left_iff`). The
  course standing at `y` at every step after the start is one (`Optimum.keeping_frontier_left`,
  `Optimum.holdingTo_same`), and where the capacity covers `y` with `r` over at least two steps so
  is the course drawing `y` down to nothing at the last step (`Optimum.holding_frontier_left`):
  valuing what is left as much as what is drawn makes the last step's draw indifferent, neither
  forced nor forbidden. Where `y` is positive the course keeping it is no optimum of the order by
  what is drawn alone (`Optimum.keeping_not_frontier`). A dependence every level of greatest
  renewal meets stands through the horizon under every such optimum (`Web.frontier_kept_left`) and
  past it along the keeping course; one above every such level is broken at the first step and
  unmet through the horizon as before (`Web.frontier_broken_left`): what is left at the end is
  valued, not what depends on the levels passed through. `Holding.gated_left` is the instance: under
  a gate renewing one unit at every level from one, from the level the dweller needs, the course
  keeping the source there through the horizon and after it is an optimum and keeps the dweller at
  every step, the course drawing it to nothing at the end is one too, and keeping is no optimum of
  the order by what is drawn alone; under the logistic law every optimum still breaks the dweller at
  the first step (`Holding.logistic_left`).
'''
op = once(op, BULLET_ANCHOR, BULLET_ANCHOR + BULLET)
READ_ANCHOR = '''breaks it, at the last step alone where the coupling exceeds the renewal forgone a step.
'''
READ = '''Valuing what is left at the horizon one for one with what is drawn is a terminal value of the stock
at its worth in the draw, the salvage value of a finite-horizon problem in optimal control: with it
the drain at the end is no longer forced, and the course holding a level of greatest renewal
through the horizon and past it, the steady yield, is an optimum. What the spine's form adds: every
optimum of every order rising with what is drawn and left holds such a level through the horizon,
the optima of the order by what is drawn and left are exactly the open courses doing so, the
capacity need cover only the renewal, and the terminal value removes the end's drain and nothing
else: a dependence whose need lies above every such level is broken at the first step as before.
'''
op = once(op, READ_ANCHOR, READ_ANCHOR + READ)
op = once(op, '''horizon's last step, an order valuing what is left at the horizon (a terminal value), the
''', '''horizon's last step, an order valuing what is left at the horizon at another worth than what
is drawn, the
''')
