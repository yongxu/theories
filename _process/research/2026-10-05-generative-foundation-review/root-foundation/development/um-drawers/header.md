* **Drawers in turn.** The others' rule need not be supplied. At each step `k` drawers draw in turn,
  each leaving of what it is given at least its floor, what a capacity leaves it, and at most all of
  it (`Optimum.InTurn.pass`, `Optimum.InTurn.drawn`, `Optimum.InTurn.later`), what the last leaves
  standing at the next step by a law `G`. A profile revises another where each of its rules, at every
  step from every level, leaves what draws its drawer the most over the steps that remain against the
  other profile (`Optimum.InTurn.Revises`); a profile is perfect where it revises itself
  (`Optimum.InTurn.Perfect`). One law carries every result: what a best response keeps above its
  floor returns to it at least one for one (`Optimum.InTurn.kept_returns`), so it leaves its floor
  wherever nothing it keeps returns to it (`Optimum.InTurn.leaves_floor`): a drawer draws to capacity
  wherever what it draws later does not depend on what it leaves (`Optimum.InTurn.at_floor`), and at
  the last step every drawer does (`Optimum.InTurn.last_at_floor`). With no floor and at least two
  drawers, backward from the horizon every drawer after the first draws nothing later
  (`Optimum.InTurn.others_draw_nothing`), and what the first leaves goes to the second: revising from
  any profile, from round `2 c` on every drawer leaves nothing at the last `c` steps
  (`Optimum.InTurn.revisions_end`). A revision always exists, the first amount from the floor up that
  draws the most (`Optimum.InTurn.revise`, `Optimum.InTurn.revise_revises`), so from round `2 N` on
  drawers come to drawing everything (`Optimum.InTurn.revised_draw_all`); a perfect profile is its own
  sequence of revisions, so every perfect profile draws everything (`Optimum.InTurn.perfect_ends`),
  drawing everything being perfect (`Optimum.InTurn.perfect_of_zero`). Where the first drawer leaves
  nothing the base stands from the first step at what stands at nothing
  (`Optimum.InTurn.levels_of_first`), and on a web every dependence above it is broken at the first
  step (`Web.drained_broken`). `Holding.gated_in_turn` is the gate witness: alone a drawer's optimum
  may keep the dweller, drawers in turn who all leave everything keep it, and every perfect profile and
  every profile revised from restraint breaks it. `Holding.doubling_capacity` is the floor witness:
  under doubling, where the second can take one unit a step, what the first leaves returns to it
  twice, less one, so leaving everything is its only best response and the dweller is kept.
