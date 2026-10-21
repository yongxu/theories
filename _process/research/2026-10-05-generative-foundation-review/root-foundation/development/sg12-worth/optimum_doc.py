# Executed by build_tree.py on `op`, the module text: SG12's bullet in the root doc, its reading, what is not derived,
# and the subsection's header.
BULLET_ANCHOR = '''* **A coupling added for each step a dependence is kept.**'''
BULLET = '''* **Valuing what is left at any worth.** With `v` for each unit left after the horizon, `v` at least
  one, what a course draws with what it leaves at that worth is what it draws with what it leaves and
  `v - 1` for each unit left (`Optimum.valued_eq`). So where no open course leaves more than one
  step's regrowth `y + r` from a level `y` of greatest renewal, it is at most the start with what is
  given there, `r` for each step after and `v - 1` for each unit of `y + r`
  (`Optimum.open_valued_le_most`), and the course holding `y` through the horizon and regrowing at
  the last step reaches it and is an optimum (`Optimum.regrowing_valued`,
  `Optimum.regrowing_frontier`; its steps are `Optimum.holdingTo_steps_of`, of which the steps of a
  course ending at most at `y` are the case). Where `v` exceeds one, the bound is reached exactly
  where a course stands at a level of greatest renewal at every step to the `n`-th and leaves `y + r`
  (`Optimum.valued_most_iff`), so every optimum of every order rising with that worth does so, and
  these are exactly the optima of the order by it (`Optimum.frontier_holds_valued`,
  `Optimum.frontier_valued_iff`, `Optimum.byDrawnLeftAt`): a dependence above every level of
  greatest renewal is broken at the first step, unmet through the horizon and met again only at its
  end, regrown (`Web.frontier_rebuilt_valued`). Whatever the worth, a coupling `w` of a dependence
  at or above whose need at most `q` is given leaves only optima breaking it within the horizon where
  `w + q n < r n` (`Optimum.frontier_breaks_valued`, `Web.frontier_breaks_valued`): against the course
  regrowing at the end, keeping forgoes `(r - q) n`, the value on what is left had by both. With the
  order by what is drawn alone (`Optimum.frontier_holds`) and by what is drawn and left alike
  (`Optimum.frontier_holds_left`), every worth in whole numbers is covered, each under its premises.
  `Holding.logistic_valued` is the instance: from the level a dweller needs, under the logistic law,
  at every worth the course drawing the source to one and regrowing it to two at the last step is an
  optimum; above one every optimum does so, the dweller broken at the first step and restored only
  at the end; and at every worth a coupling of the dweller below the horizon is outweighed.
'''
op = once(op, BULLET_ANCHOR, BULLET + BULLET_ANCHOR)
READ_ANCHOR = '''else: a dependence whose need lies above every such level is broken at the first step as before.
'''
READ = '''A terminal value above the worth of the draw changes what is left, not the path: every optimum still
holds a level of greatest renewal through the horizon and leaves it only at the last step, to regrow
to the most it can leave, so a dependence above those levels is broken at the first step and
restored only at the end. This is the turnpike in exact form (Dorfman, Samuelson and Solow 1958): a
finite-horizon optimum stays on the path of greatest yield and departs from it only at the end, the
departure set by the terminal value, a drain where what is left is worth nothing and a regrowth where
it is worth more than the draw. A dependence measured only at the horizon is restored for the
measurement, a measure becoming the target (Goodhart 1975). What the spine's form adds: every
optimum of every order rising with the valued draw does this, the optima of the order are exactly
these courses, and what keeping a dependence forgoes against them is `(r - q) n` whatever the value,
so a long enough horizon outweighs every coupling fixed in total, a terminal value or not.
'''
op = once(op, READ_ANCHOR, READ_ANCHOR + READ)
op = once(op, '''horizon's last step, an order valuing what is left at the horizon at another worth than what
is drawn, the
''', '''horizon's last step, a worth on what is left where the most a course can leave is not regrown in
one step from a level of greatest renewal, the
''')
op = once(op, '''/-! ### Valuing what is left at any worth -/
''', '''/-! ### Valuing what is left at any worth

With `v` for each unit a course leaves after the horizon, the course holding a level of greatest
renewal and regrowing at the last step to the most any course can leave draws and leaves the most; at
a worth above one every optimum does so, and a coupling of keeping a need is outweighed as without the
value. -/
''')
