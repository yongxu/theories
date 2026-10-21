# Executed by build_tree.py on `op`, the module text: SG14's bullet in the root doc, its reading, and what is not
# derived.
BULLET_ANCHOR = '''  step from `n + 4` the same order rebuilds the source alone and ends it with others drawing all but
  half (`Holding.doubling_drawn_first_linear`).
'''
BULLET = '''* **Drawers in turn, each ranking courses.** The others' rule need not be supplied. With two
  drawers in turn at each step, the first leaving part of the level and the second part of that,
  what remains standing at the next step by a law `G`, each ranking what it draws over the steps
  that remain (`Optimum.InTurn.firstDrawn`, `Optimum.InTurn.secondDrawn`), a profile is perfect where
  each leaves at most what it is given and the two are at a mutual best response at every step from
  every level (`Optimum.InTurn.BestAt`, `Optimum.InTurn.Perfect`). Backward from the horizon, whatever
  the first leaves the second draws, and whatever the second leaves the first draws at its next
  move, so every perfect profile has both leave nothing at every step, whatever stands at nothing
  (`Optimum.InTurn.step_ends`, `Optimum.InTurn.ends_at`, `Optimum.InTurn.perfect_ends`); the base
  stands from the first step at what stands at nothing (`Optimum.InTurn.perfect_levels`), and
  drawing everything is perfect over every horizon (`Optimum.InTurn.perfect_of_zero`). On a web,
  every dependence on the base whose need, met at the start, lies above what stands at nothing is
  broken at the first step (`Web.perfect_broken`). `Holding.gated_in_turn` is the instance: under a
  gate, alone a drawer's optimum may hold the source at the dweller's need, keeping it through the
  horizon; in turn, every perfect profile breaks the dweller at the first step.
'''
op = once(op, BULLET_ANCHOR, BULLET_ANCHOR + BULLET)
op = once(op, '''alone ends it with others drawing first. The others' draws are supplied as a rule reading the level,
not derived as a best response: this is one optimizer's side of the dynamic commons, not its
equilibrium.
''', '''alone ends it with others drawing first. With two drawers in turn, each ranking courses, the
others' rule is derived: at every subgame-perfect profile, a mutual best response at every step from
every level, both draw everything, so the base ends at once wherever nothing stands at nothing, the
open-access outcome as the unique perfect one where no capacity limits a draw (the dynamic commons
with linear payoffs, Levhari and Mirman 1980; alternating moves). What the spine's form adds: every
perfect profile, not one equilibrium, over any law of what stands, and with no discounting: far-sight
on both sides does not keep the base that either alone, far-sighted, may keep.
''')
op = once(op, '''one step from a level of greatest renewal, the
weighted optimum where no course gains the most against every open course, whether others' draws,
supplied as a rule reading the level, are themselves a best response, so several optimizers each
ranking courses at a mutual best response, and how optimizers come to one; for several optimizers,''',
'''one step from a level of greatest renewal, the
weighted optimum where no course gains the most against every open course, drawers ranking courses
whose capacities limit a draw, more than two of them or drawing at once, and how optimizers come to
a mutual best response; for several optimizers,''')
