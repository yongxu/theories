# Edits to Optimum's module docstring, run by build_tree.py with `op` and `once` in scope.
op = once(op, '''  nothing (`Optimum.AtOnce.levels_drained`), and a dependence above it is broken at the first step
  (`Web.at_once_broken`).
''', '''  nothing (`Optimum.AtOnce.levels_drained`), and a dependence above it is broken at the first step
  (`Web.at_once_broken`).
* **When drawing at once drains, and whom restraint pays.** The converse is exact: drawing
  everything is perfect exactly where no drawer's portion of what stands next returns more than one
  for one on what it alone leaves, the others drawing everything (`Optimum.AtOnce.drain_perfect_iff`,
  `Web.drain_perfect_broken`). In whole amounts the premise of `drains` says more than it seems: a
  unit left returns less than a unit, so nothing, and a portion never rises with what is left
  (`Optimum.AtOnce.portion_falls`), so along no profile does any drawer draw more than where all draw
  everything (`Optimum.AtOnce.drain_most`): there restraint pays no drawer, and what the drain breaks
  lies beyond every drawer (`Web.at_once_beyond`). Where the drain is perfect and a profile holding
  the level draws a drawer more at every later step than the drained base gives, over a horizon longer
  than its first portion it draws that drawer more (`Optimum.AtOnce.holding_draws_more`), and no
  profile leaving something at the last step is perfect (`Optimum.AtOnce.last_draws`). A drawer whose
  portion is all that stands finds the drain imperfect wherever the whole returns more than one for
  one (`Optimum.AtOnce.whole_not_drained`, `Optimum.AtOnce.whole_perfect_iff`); where the whole never does,
  drawing everything is perfect for it and still breaks what depends on the base
  (`Web.whole_drain_broken`). In
  `Optimum.Holding.halves_race`, two drawers share a level by halves and what both leave stands next
  with half of it again: drawing everything is perfect for the two and breaks the dweller, holding the
  source at six keeps it and draws each drawer more, and for a single drawer given the whole drawing
  everything is not perfect.
''')
op = once(op, '''drawer draws later is fixed; drawing at once where a portion returns at least one for one; for
several optimizers,''', '''drawer draws later is fixed; drawing at once, which perfect profiles there are where a portion returns
at least one for one, and whether, where drawing everything is perfect and holding pays every drawer
more, every other perfect profile draws each drawer less than holding (the halves show it only for
drawing everything); for several optimizers,''')
