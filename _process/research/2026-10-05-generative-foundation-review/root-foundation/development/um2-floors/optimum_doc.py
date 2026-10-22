# Executed by build_tree.py on `op`: UM2's root-doc text.
op = once(op, '''  the last step every drawer does (`Optimum.InTurn.last_at_floor`). With no floor and at least two
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
  step (`Web.drained_broken`).''', '''  the last step every drawer does (`Optimum.InTurn.last_at_floor`). Where two drawers have no floor,
  whatever floors the others have, nothing any drawer keeps comes back to it: through a drawer that
  leaves nothing nothing passes (`Optimum.InTurn.pass_through`), after one the others draw nothing
  (`Optimum.InTurn.after_draw_nothing`), so a drawer after it, and a drawer before one, leaves its
  floor (`Optimum.InTurn.floor_after`, `Optimum.InTurn.floor_through`). Revising from any profile,
  from round `p c` on every drawer leaves its floor at the last `c` steps, three rounds a step, two
  where the first drawer has no floor (`Optimum.InTurn.revisions_reach_floors`); a revision always
  exists, the first amount from the floor up that draws the most (`Optimum.InTurn.revise`,
  `Optimum.InTurn.revise_revises`), so drawers come to their floors (`Optimum.InTurn.revised_at_floors`).
  A perfect profile is its own sequence of revisions, so every perfect profile is the floor profile
  (`Optimum.InTurn.perfect_at_floors`), which is perfect (`Optimum.InTurn.floors_perfect`); with no floor
  anywhere that is drawing everything. One drawer with no floor is not enough
  (`Holding.doubling_capacity`). Where a drawer leaves nothing the base stands from the first step at
  what stands at nothing (`Optimum.InTurn.levels_through`), and on a web every dependence above it is
  broken at the first step (`Web.drained_broken`).''')
