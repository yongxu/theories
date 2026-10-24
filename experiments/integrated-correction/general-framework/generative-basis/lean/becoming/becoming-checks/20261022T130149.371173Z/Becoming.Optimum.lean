import Becoming.DrawnBeyond
import Becoming.Frontier

/-!
# Optimum: what optimizing through couplings does beyond them

(Drawers in turn ranking their position rather than their draw, the race of
`Becoming.RelativePosition` read on the draws, are in `InTurn`'s section *A race for position*.)

`Becoming.DrawnBeyond` showed that where the whole gains nothing the beyond falls by the rise and
the loss, that above the slack a dependence beyond breaks, and that a selection rewarding the rise
rewards that break unseen. It did not say what an *optimum* does: how far a selection that takes
the best it can, by an order rising with what couples in, lowers what lies beyond. This module
states it, over any set of outcomes and any such order, and on a web's dependences. An outcome is
the levels after a step (`C → Nat`); the eligible outcomes are any set of them; an optimum is a
member of the frontier of `Requirement.Frontier` (eligible, with no eligible outcome ranked above
it). The family `ds` is what couples in, `rest` the conditions beyond, listed apart.

* **The drive to the least level, exactly.** Call an order *rising* with a family where it ranks
  above every outcome exceeding another on the family (at least as high at each of its conditions
  and higher at one), whatever either holds beyond (`Optimum.Rising`). Every rising order's optima
  stand at the least level beyond, condition by condition, among the eligible outcomes, exactly
  where every eligible outcome standing above another at a condition beyond is not unbeaten on the
  family (`Optimum.least_iff`). So, where lowering a condition beyond leaves the family room to
  rise (`Optimum.Room`), every optimum is at the least level beyond (`Optimum.least_of_room`); where
  it does not, an optimum need not be (`Drain.room_needed`). One case of room is *shared units*:
  the eligible outcomes are closed under moving a unit from a condition beyond that holds one into
  a condition of the family (`Optimum.Shared.room`, `Optimum.least_of_shared`).
* **Counting the beyond after the proxy changes nothing.** An order ranking above wherever a rising
  order does is rising (`Optimum.Rising.mono`): a lexicographic order with the family first and
  the beyond counted after has its optima at the least level beyond (`Drain.counted_after_drains`).
  The stock of the family is a rising order (`Optimum.rising_total`); an order rising only to a
  target is not, and its optima include the outcome keeping what lies beyond and the outcome
  ending it (`Drain.satisficing_either`).
* **An optimum breaks exactly what any outcome breaks.** On a web whose levels after the step are
  an optimum of a rising order with room, with each condition beyond depended on at a need it meets,
  a dependence beyond is broken exactly where some eligible outcome leaves its condition below the
  need (`Web.optimum_broken_iff`): of the dependences beyond, the optimum breaks the most any
  eligible outcome breaks. Where activity needs support and the dependence is as it was, the
  formation ends, it is no member of a group all of whose couplings are in the family, and no
  member couples into its condition (`Web.optimum_ends_beyond`). `Drain` is the instance: the
  store's optimum drains the source and the dweller ends (`Drain.drained_ends`).
* **Raising the family is lowering the beyond with the loss, unit for unit.** Of two balanced
  steps from equal totals, each gaining nothing on the whole, one leaves the family at most where
  the other does exactly where it leaves the beyond with the loss at least where the other does
  (`Flow.Balances.family_le_iff`); so among such moves the ones whose family stock is highest are
  exactly the ones leaving least beyond with the loss (`Flow.top_iff_least`).
* **Keeping each dependence, the optimum takes exactly the slack.** Restricted to the outcomes
  keeping every dependence beyond at its need, a rising order with room among them, where each
  need is attained by one of them, has its optimum stand at the needs: it breaks nothing, and in a
  balanced step gaining nothing on the whole the family rises, with the loss, by exactly the slack
  (`Flow.keeping_optimum_takes_slack`). `Drain.kept_takes_slack` is the instance: the keeping
  optimum is `DrawnBeyond.WithinSlack`'s world.
* **Room, read off the exchange.** The outcomes open to a part across one step are the levels
  after every step that balances in which the formations outside the part exchange as they do and
  each member of the part takes from each condition at most its capacity there, gives only to a
  listed family and gives it no more than it takes from it (`Flow.ActsWithin`, `Flow.Outcome`).
  Among them, above any floors, there is room, with no premise beyond listings without
  repetition: an outcome above another at a condition beyond is exceeded on the family, by a unit
  taken there through a member whose capacity the other step uses more, or a unit given there
  that can go to the family instead (`Optimum.Above.room`).
* **Every optimum beyond, exactly.** Above its floor, an optimum of every order rising with the
  family has each member take its whole capacity at a condition beyond and give nothing there
  (`Optimum.Above.full`), so it stands at its floor or at what the rest leaves less the capacity
  (`Optimum.Above.floor_or_full`); with no floor, at the level before, with what the rest gives
  and less what it takes, less the part's capacity, or at nothing (`Optimum.optimum_beyond`).
* **No drive where no units are shared; the drain exactly where they are.** Where no member may
  take from a condition beyond, every optimum leaves it where the rest leaves it
  (`Optimum.optimum_untouched`); an optimum lowers it below that exactly where the part has some
  capacity there and the rest leaves something there (`Optimum.optimum_lowers_iff`); on a web, a
  dependence beyond is broken exactly where its need exceeds what the rest leaves less the
  capacity (`Web.optimum_broken_iff_capacity`). `Drain.drawing_optimum` is the instance: a taker
  of capacity `k` drains the source to `2 - k`, and the dweller's dependence breaks exactly where
  `0 < k` (`Drain.drawing_broken_iff`).
* **Several optimizers at once.** Where several formations each optimize alone, by its own order
  rising with its own family, and each one's step is an optimum among the outcomes open to it, the
  others exchanging as they do in the step that happened (a mutual best response,
  `Optimum.MutualBest`), a condition beyond every optimizer's family stands after the step at what
  the formations outside every optimizer leave there less the optimizers' joint capacity, or at
  nothing (`Optimum.mutual_beyond`). Where something stands there, each optimizer takes its whole
  capacity there and gives nothing, so restraint is no mutual best response
  (`Optimum.MutualBest.full`); the optimizers leave the condition where every optimum of one part
  made of all of them would, by any order rising with any family (`Optimum.mutual_as_one`); it is
  lowered exactly where they have some capacity there and something is left
  (`Optimum.mutual_lowers_iff`), and a dependence on it breaks exactly where its need exceeds that
  level (`Web.mutual_broken_iff_capacity`). `TwoTakers` is the instance: two takers of capacity
  one at a source of two, each take within the slack of a need of one, leave nothing at their
  mutual best response (`TwoTakers.joint_best`, `TwoTakers.joint_drains`,
  `TwoTakers.within_slack_jointly_below`), and the step where one restrains is no mutual best
  response (`TwoTakers.restrained_not_mutual`).
* **A course of steps.** Where a part chooses again at every step, the levels after each an
  optimum among the outcomes open to it from the levels before (`Optimum.Reoptimizes`), a
  condition beyond stands after each step at the level before with what the rest gives, less what
  the rest takes and the part's capacity, or at nothing (`Optimum.course_beyond`); for several
  optimizers at a mutual best response at every step, less their joint capacity
  (`Optimum.mutual_course_beyond`). Where the rest renews the condition by exactly `r` a step
  while it stands at a positive need `m`, by at most `r` below, and the draw there is `k`, a
  dependence at that need is lost exactly where `r < k` (`Web.course_lost_iff`): above the renewal
  the level never rises, falls by at least one at every step while something stands, and stands
  below the need once the steps exceed its starting excess over it, for good
  (`Optimum.never_rises`, `Optimum.ends_within`, `Optimum.level_stays_below`); within it the level
  never falls (`Optimum.kept_at_need`). Several optimizers each within the renewal lose it where
  their joint capacity exceeds it (`Web.mutual_course_lost`). No course draws more than the
  starting level with `r` for each step (`Optimum.drawn_within`); within the renewal it draws `k`
  at every step (`Optimum.kept_drawn`). What the renewal does below the need decides only what is
  drawn: where it stops there (a gate), as where whatever renews the condition depends on it
  (`Flow.restGiven_unsupported`), a course above the renewal draws at most the starting level with
  `r` for each of its units, however long (`Optimum.ended_drawn_le`, `Web.course_ended_drawn`), so
  a positive draw is bounded exactly where `r < k` (`Optimum.drawn_bounded_iff`) and over a long
  enough course keeping draws more (`Optimum.keeping_draws_more`); where at least one is given at
  every step, the dependence is lost all the same and the draw has no bound
  (`Optimum.drawn_unbounded`, `Web.course_drawn_unbounded`). `Renewing` is the instance: a taker
  choosing the store's optimum at every step against a dweller renewing the source loses the
  dweller exactly where `r < k` (`Renewing.lost_iff`), its store bounded exactly then
  (`Renewing.store_bounded_iff`) and below a taker of capacity `r` after long enough
  (`Renewing.keeping_holds_more`); two takers of
  capacity one at a mutual best response at every step lose a source renewed by one, which either
  alone keeps (`Renewing.joint_course_lost`, `Renewing.alone_kept`), and hold less than the course
  in which one restrains, no step of which is a mutual best response
  (`Renewing.restrained_course_not_best`, `Renewing.restraint_holds_more`).
* **Courses ranked over a horizon.** Where each step leaves at most the level with what is given
  and at most `r` is given at each step, what a course draws, what it leaves and everything the
  renewal falls short of `r` add to the starting level with `r` for each step
  (`Optimum.drawn_add_shortfall`, `Flow.Balances.taken_add_shortfall`); so of two balanced courses
  from one level, one takes at most what the other takes exactly where the other forgoes and leaves
  at most what the one does (`Flow.Balances.taken_le_iff`), and two given alike and ending alike
  take the same, whatever levels they pass through (`Flow.Balances.taken_eq_of_alike`). Where what
  is given is a law `R` of the level, a course draws across `n + 1` steps at most the start with
  what is given there and `r` for each step after (`Optimum.drawn_le_most`), exactly where it stands
  at a level where `R` gives `r` at every step to the `n`-th and leaves nothing after the last
  (`Optimum.most_iff`). Where such a level is within reach and the capacity, over at least two
  steps, every optimum of every order rising with what is drawn is such a course
  (`Optimum.frontier_holds`): it breaks at the first step a dependence whose need lies above every
  level of greatest renewal and leaves it unmet through the horizon (`Web.frontier_broken`), and
  keeps one that every such level meets through the horizon, breaking it at its end
  (`Web.frontier_kept`). `Holding` is the instance: from the level a dweller needs, under the
  logistic law `s (2 - s)`, the course holding the source at one, where the law renews most, is an
  optimum and breaks the dweller at the first step (`Holding.logistic_broken`); under a gate
  renewing one unit at every level from one, the courses holding the source at the dweller's need
  and below it are both optima and take the same (`Holding.gated_alike`).
* **Valuing what is left at the horizon.** What a course draws across `n + 1` steps with what it
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
* **What keeping a dependence forgoes.** Where what is given at every level at or above a need `m`
  is at most `q`, what a course keeping the condition at `m` or above through the horizon draws,
  with what it leaves, is at most the start with what is given there and `q` for each step after
  (`Optimum.keeping_le_most`, `Flow.Balances.keeping_taken_le`); among the courses keeping it,
  every optimum of every order rising with what is drawn holds a level where `q` is given and
  leaves exactly `m` (`Optimum.frontier_keeps`, `Web.frontier_keeps`), and the course holding such
  a level is one (`Optimum.continued_keeping_frontier`). So keeping forgoes, against the course
  holding a level of greatest renewal `r` and leaving nothing, `(r - q) n + m`: under an order
  adding to what a keeping course draws a coupling below that, every optimum falls below the need
  within the horizon, breaking the dependence (`Optimum.frontier_breaks_below`,
  `Web.frontier_breaks_below`); under one adding more to a keeping course and nothing to a course
  falling below the need, every optimum keeps it (`Optimum.frontier_keeps_above`,
  `Web.frontier_keeps_above`); and for a coupling of exactly `w` both have optima
  (`Optimum.continued_breaking_frontier`, `Optimum.continued_kept_frontier`). Where the capacity
  cannot draw down to nothing or to the need, the end it reaches enters the thresholds. Where the
  need lies above every level of greatest renewal, `q < r`, what keeping forgoes grows with the
  horizon, and every coupling below the horizon with the need is outweighed
  (`Optimum.forgone_grows`, `Web.frontier_breaks_long`). The courses attaining these bounds draw
  nothing after the horizon (`Optimum.continued`), so nothing is supposed beyond it; the identity
  and the holding course of the section above are generalized below it
  (`drawn_add_shortfall_after_up_to`, `holdingTo`). `Holding.logistic_coupled` is the instance:
  from the level the dweller needs, under the logistic law, keeping the dweller through `n + 2`
  steps forgoes `n + 3`, and the order by what the taker draws with a coupling `w` of the dweller
  has optima, all breaking it below that and all keeping it above.
* **Valuing what is left at any worth.** With `v` for each unit left after the horizon, `v` at least
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
* **A coupling added for each step a dependence is kept.** A course standing at a need `m` or
  above at every step to the `j`-th draws across the horizon, with `r` for each of those steps, at
  most the start with what is given there, `r` a step and `q` for each of those steps
  (`Optimum.met_drawn_le`, from `Optimum.shortfall_ge`; `Flow.Balances.met_taken_le`): each met step
  forgoes at least `r - q`. So under an order adding `c` for each step the need stays met from the
  start, every optimum keeps it through the horizon where `c` covers the renewal forgone a step and
  exceeds the end the keeping course can reach, `r ≤ q + c` and `e < c`, whatever the horizon
  (`Optimum.frontier_keeps_stepwise`, `Web.frontier_keeps_stepwise`); where `c` with the end
  reached is below the need, every optimum falls below it within the horizon
  (`Optimum.frontier_breaks_at_end`, `Web.frontier_breaks_at_end`), and where `c` also exceeds the
  renewal forgone a step, `r < q + c`, every optimum meets the need at every step but the last and
  breaks it there alone, drawing the need itself: the end does not reach back
  (`Optimum.frontier_met_before_end`, `Web.frontier_met_before_end`, `Web.frontier_breaks_last`);
  and where `q + c < r` the coupling is at most `c` a step and a long horizon outweighs it
  (`Optimum.outweighed_stepwise`, `Web.frontier_breaks_stepwise_long`). Optima exist in every
  case (`Optimum.continued_stepwise_frontier`, `Optimum.continued_ending_stepwise_frontier`,
  `Optimum.continued_holding_stepwise_frontier`). The instance `Holding.logistic_stepwise`: under
  the logistic law a coupling of three a step keeps the dweller at every horizon, where a coupling
  of the whole keeping must exceed `n + 3`; one of two a step keeps it to the horizon's last step;
  one of at most one a step breaks it.
  Counted at every step met, wherever those steps fall, the coupling meets a fall met again: each
  step met forgoes at least `r - q` wherever it lies (`Optimum.shortfall_count_ge`, of which the
  count from the start, `Optimum.shortfall_ge`, is the case; `Optimum.met_count_drawn_le`), so a
  course below the need at some step is worth at most a course keeping it where `r ≤ q + c`,
  `r + e ≤ q + c + m` and `e ≤ c` (`Optimum.falls_met_le`), every optimum keeps the need through the
  horizon where `r + e < q + c + m` and `e < c` (`Optimum.frontier_keeps_met`,
  `Web.frontier_met_kept`), and the keeping course is an optimum where `r ≤ q + c` and `m ≤ c`
  (`Optimum.continued_met_frontier`). Against the count from the start, `r ≤ q + c`, the threshold
  rises by the end's excess over the need and becomes strict: a fall met again forgoes the coupling
  only at the steps below. `Holding.burst_met` is the instance: under a burst renewing four at one,
  from the level a dweller needs, a coupling of four a step keeps the dweller under every optimum
  counting from the start, while counting every step met, the course falling once and met again
  is an optimum beside the course keeping it; five a step keeps it under every optimum.
* **An order weighting later draws less.** With the draw of the step from `t` weighted by `w t`,
  any weighting, what a course could draw at a step, with what it drew before, changes from one
  step to the next by what the level it leaves gains: that level with its renewal weighted at the
  next step, against it held, weighted at this one (`Optimum.Next.drawable_step`). So against an open
  course from the start leaving nothing whose level at each step gains the most, no course draws
  more, weighted, and every optimum of every order rising with the weighted draw gains at each
  step what that course's level gains and leaves nothing weighted at the end
  (`Optimum.Next.weighted_le_of_gains`, `Optimum.frontier_gains_weighted`); that course is an optimum
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
  step (`Optimum.Next.ended_outdrawn`, `Optimum.frontier_leaves`, `Web.frontier_leaves`). The instance
  `Holding.logistic_weighted`: under the logistic law, where one returns two for one, a weighting
  falling more than twofold at every step ends the source at once and breaks the dweller; one
  falling by less than half holds the source at one and breaks the dweller; at exactly twofold both
  courses are optima, so neither strict premise can be dropped.
* **Rebuilding from below.** A course gaining at each step, weighted, at least what the level of any
  open course gains is an optimum, and every optimum gains what it does
  (`Optimum.frontier_of_gainsMost`, `Optimum.frontier_gains_of_most`); the course whose level gains
  at least what any level does is the case (`Optimum.weighted_frontier`,
  `Optimum.frontier_gains_weighted`). Where the start lies below a level `y` and the next level
  rises with the level below `y`, the course rising as fast as what is given allows up to `y`
  stands at each step at or above every open course below `y` (`Optimum.Next.le_rise`); so where the
  weighted gain rises with the level up to `y` and is greatest there, that course, leaving nothing
  at the end, gains the most and is an optimum (`Optimum.Next.rebuilding_gainsMost`,
  `Optimum.rebuilding_frontier`). Where the gain rises strictly below `y`, every optimum stands at
  its level at every step where that level is below `y`, drawing nothing at the step before
  (`Optimum.frontier_rebuilds`), and restores every dependence whose need that level meets
  (`Web.frontier_rebuilds`); where `y` gains more than every other level, every optimum stands at
  `y` once the rising course does (`Optimum.frontier_rebuilt`). The instance
  `Holding.doubling_rebuilds`: a source doubling up to eight, from one, under weights falling by
  less than half a step, is rebuilt to two, four and eight by every optimum, the dweller restored at
  the first step; at exactly twofold the course ending it at once is an optimum too; falling
  faster, every optimum ends it.
* **Over every law of what stands.** Each law above on an order weighting later draws less, and on
  rebuilding from below, uses only what stands to be drawn at each step, so each holds over any law
  `G` of what stands: at the step from `t`, a level `z` gives `G t z` (`Optimum.Next`, `Web.Next`);
  the law may change with the step and give less than the level or more. The renewal law,
  `G t z = z + R z`, is the case: the laws above are stated from those over every law, their
  statements unchanged; lemmas no law reads in the renewal form any more stand in their general
  form only. Holding or rising to a level `y` needs only that what stands at `y` be at least `y`.
  Where others first draw from the level an optimizer leaves, and what remains renews, what stands
  for it is what remains with its renewal (`Optimum.Next.leftBy`): where they draw at least what the
  remainder renews, every optimum of every order whose weighting falls at every
  step, however slightly, stands at nothing from the first step on
  (`Optimum.Next.frontier_ends_of_le`, `Optimum.Next.frontier_ends_drawn_first`), and where they
  draw more, so does every optimum of every order with positive weights rising at no step
  (`Optimum.Next.frontier_ends_of_lt`, `Optimum.Next.frontier_ends_drawn_more`), breaking every
  dependence on the base with a positive need (`Web.Next.frontier_ends_drawn_first`,
  `Web.Next.frontier_ends_drawn_more`). The instance `Holding.doubling_drawn_first`: from two, a
  source doubling up to eight is rebuilt to four and eight by every optimum alone under weights
  falling by less than half a step; with others first drawing all but a quarter of what is left,
  every optimum under the same weights ends it at once; with others drawing all but half, every
  optimum under weights falling at every step ends it, and under equal weights ending it and holding
  it at two are both optima, so the strict fall cannot be dropped. Under weights falling by one a
  step from `n + 4` the same order rebuilds the source alone and ends it with others drawing all but
  half (`Holding.doubling_drawn_first_linear`).
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
  the last step every drawer does (`Optimum.InTurn.last_at_floor`). Where two drawers have no floor,
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
  broken at the first step (`Web.drained_broken`). `Holding.gated_in_turn` is the gate witness: alone a drawer's optimum
  may keep the dweller, drawers in turn who all leave everything keep it, and every perfect profile and
  every profile revised from restraint breaks it. `Holding.doubling_capacity` is the floor witness:
  under doubling, where the second can take one unit a step, what the first leaves returns to it
  twice, less one, so leaving everything is its only best response and the dweller is kept.
* **Drawing at once, the same law.** At each step the level is divided into portions and all draw at
  once from theirs, what all leave standing next as `G` says (`Optimum.AtOnce.drawn`,
  `Optimum.AtOnce.later`, `Optimum.AtOnce.Revises`, `Optimum.AtOnce.Perfect`). What a drawer leaves
  comes back to it only through its portion of what stands next. Where that return is less than one
  for one (`Optimum.AtOnce.ReturnsLess`), by the law's strict form (`Optimum.InTurn.floor_of_less`, of
  which `leaves_floor` is the case) revising from any profile comes to drawing everything within one
  round a step back (`Optimum.AtOnce.revisions_drain`), drawing everything is perfect and every
  perfect profile draws everything (`Optimum.AtOnce.drains`), the base standing at what stands at
  nothing (`Optimum.AtOnce.levels_drained`), and a dependence above it is broken at the first step
  (`Web.at_once_broken`).

**Reading (the AI's).** This is the spine's form of a known result: optimizing a proxy that
references only some attributes drives the others to their lower bounds (Zhuang and
Hadfield-Menell, "Consequences of Misaligned AI", 2020, Theorem 1). What the spine's form adds:
the characterization is over any order rising with what couples in, not a scalar proxy, and exact
on any set of outcomes (`least_iff`), with shared resources one sufficient case; no utility over
what lies beyond is assumed, the degradation being read as dependences broken and formations
ended, exactly those some outcome breaks; and the conservation identity says by how much: the
beyond with the loss falls by exactly what the family rises. Counting the beyond only after the
proxy keeps nothing, and restricting to keeping outcomes uses the slack and no more, which is less
than holding the beyond where it was (their Proposition 2). It does not reach their continuous
setting, the compactness characterization of their Theorem 2, or the interactive improvement of
their Theorem 3 and Propositions 4 and 5. Their Theorem 1 assumes a resource constraint shared by
the attributes; read off the exchange it is conservation with capacity: what a part's members
take they give, and what they may take is their capacity, so the drain lies exactly where the
part shares units with what lies beyond, by the capacity, and nowhere else. With several
optimizers each blind to the same condition, the drain is the sum of their capacities: how many
optimize, and whether they act together or each alone, does not change where the condition stands
(the tragedy of the commons, Hardin 1968, and open access, Gordon 1954, in the spine's form). Over
a course against a renewal this is the open-access depletion of a renewable resource (Gordon 1954;
Clark, *Mathematical Bioeconomics*, 1976) and, with several optimizers, the dynamic commons
(Levhari and Mirman 1980): what the form adds is that the threshold is exact over any orders
rising with any families, the dependence lost exactly above it whatever the renewal does below the
need, and that the gate decides the optimizer's own draw, the measure its order rises with: where
the renewal stops below the need that draw is bounded, and after long enough below what a capacity
at the renewal draws; where it does not, the draw goes on without bound after the dependence is
lost. Ranking whole courses changes when, not whether: what a course draws, leaves and forgoes is
conservation over the horizon, so what a course draws registers its levels only through what is
renewed there, and every optimum of a far-sighted order rising with it holds a level of greatest
renewal, the maximum sustainable yield's level (half of room in the logistic law; Schaefer 1954), as
a sole owner does (Scott 1955), and draws everything at its horizon, the end of a finite-horizon
harvest (Clark 1976); a dependence beyond needing more than
those levels is lost at the first step however far the horizon, as single-species management leaves
predators of a forage stock uncounted (Pikitch and others 2012). What keeping such a dependence
forgoes is exact: the renewal given up at the need for each step and the need left at the end, so a
coupling of the dependence decides the optimum at that amount, and where the need lies above every
level of greatest renewal the amount grows with the horizon: the yield forgone by holding a stock
for what depends on it, the ecosystem constraint on a single-species yield, is no fixed sum, and a
far-sighted optimizer's gain from breaking the dependence grows with how far it sees. A coupling
added for each step the dependence is kept does not erode so: at the renewal forgone a step and
above the need it keeps the dependence at every horizon, and below the need the horizon's end
breaks it, at the last step alone where the coupling exceeds the renewal forgone a step.
Counted at every step the need is met rather than from the start, the same coupling can be had by a
course that falls and recovers: what the fall forgoes is the coupling at the steps below, what it
gains is the renewal forgone there and what the end leaves above the need, so the coupling must
exceed the renewal forgone a step outright. A constraint rewarded step by step without memory of a
breach is gamed exactly at that threshold.
Valuing what is left at the horizon one for one with what is drawn is a terminal value of the stock
at its worth in the draw, the salvage value of a finite-horizon problem in optimal control: with it
the drain at the end is no longer forced, and the course holding a level of greatest renewal
through the horizon and past it, the steady yield, is an optimum. What the spine's form adds: every
optimum of every order rising with what is drawn and left holds such a level through the horizon,
the optima of the order by what is drawn and left are exactly the open courses doing so, the
capacity need cover only the renewal, and the terminal value removes the end's drain and nothing
else: a dependence whose need lies above every such level is broken at the first step as before.
A terminal value above the worth of the draw changes what is left, not the path: every optimum still
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
Weighting later draws less is discounting (Ramsey 1928; Koopmans 1960). A level gains, weighted,
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
the threshold is exact: where the rates tie, ending and holding are both optima. Rebuilding
from below is the most rapid approach path (Spence and Starrett 1975; Clark 1976): with a draw
counted linearly, a stock below its best level is left to grow as fast as it can, nothing drawn,
until it reaches it. What the spine's form adds: every optimum of every order rising with the
weighted draw does so, under any weighting whose gain rises with the level, and on the way
restores what depends on the base; in the witness the threshold for rebuilding is the one for
ending at once, a weighting falling faster than the base renews ending it rather than rebuilding it. Over
every law of what stands the laws cover a base that decays and one renewing differently from step
to step; where others draw first, they are the optimizer's side of the dissipation of a common pool:
what an optimizer leaves the others draw, so it stands no higher when the next step comes, and where
they draw at least what the remainder renews any weighting falling at every step makes drawing it
now better (Gordon 1954; Levhari and Mirman 1980, where the stock at equilibrium falls as players
are added). What the spine's form adds: the threshold moves exactly from what the base renews to what the others' leaving
renews, for every order rising with the weighted draw, and the same order that rebuilds the base
alone ends it with others drawing first. With drawers in turn, each ranking courses, the
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

What is not derived: outside the outcomes open to a part across one step of exchange, which
outcomes are eligible and whether there is room (hypotheses wherever they enter, with witnesses
that each binds); within them, the capacities, the family the part gives to, and that a member
may give what it takes to any condition of that family (a member giving only to some is not
covered); over a course, against a renewal varying with the level, the optimum where a level of
greatest gain is out of one step's reach and the next level does not rise with the level
below it, or the capacity cannot draw down to it in one step or draw everything at the
horizon's last step, a worth on what is left where the most a course can leave is not regrown in
one step from a level of greatest renewal, the
weighted optimum where no course gains the most against every open course, drawers ranking courses
and how drawers come to a mutual best response other than by revision; for drawers whose floors bind,
at most one drawer free, which profiles are perfect away from the last step and the steps where what a
drawer draws later is fixed; drawing at once where a portion returns at least one for one; for
several optimizers,
that a mutual best response exists in general (the instance has one) and where a condition lies
within some optimizer's family; that a given optimizer's order rises with just the couplings listed (supplied, as in `Becoming.SelectionGap`); which formation depends on which
condition beyond and at what need (named by `dep`). That an order keeping what lies beyond
separates outcomes differing only beyond, and so goes through a member coupled into it, is
`Direction.widening_selected_by_pool`, not repeated here. The representation commits to discrete
steps and natural amounts. No ethical predicate, ranking of the beyond or axiom occurs.
-/

namespace Becoming

open Requirement

variable {F C : Type}

namespace Optimum

/-- One outcome exceeds another on a family: at least as high at each of its conditions and higher
at one. -/
def Exceeds (ds : List C) (o' o : C → Nat) : Prop :=
  (∀ c, c ∈ ds → o c ≤ o' c) ∧ ∃ c, c ∈ ds ∧ o c < o' c

/-- An order rises with a family: it ranks every outcome exceeding another on the family above
it, whatever either holds elsewhere. -/
def Rising (ds : List C) (better : (C → Nat) → (C → Nat) → Prop) : Prop :=
  ∀ o o', Exceeds ds o' o → better o' o

/-- Room beyond: an eligible outcome standing above another at a condition beyond is exceeded on
the family by an eligible outcome. -/
def Room (ds rest : List C) (eligible : (C → Nat) → Prop) : Prop :=
  ∀ o o', eligible o → eligible o' → ∀ c, c ∈ rest → o' c < o c →
    ∃ o'', eligible o'' ∧ Exceeds ds o'' o

/-- At the least level beyond: at each condition beyond, no eligible outcome stands lower. -/
def Least (rest : List C) (eligible : (C → Nat) → Prop) (o : C → Nat) : Prop :=
  ∀ c, c ∈ rest → ∀ o', eligible o' → o c ≤ o' c

variable {ds rest : List C} {eligible : (C → Nat) → Prop}
  {better : (C → Nat) → (C → Nat) → Prop}

/-- Where an outcome exceeds another on a family, the family's total under it is higher. -/
theorem Exceeds.total_lt {o o' : C → Nat} :
    ∀ {ds : List C}, Exceeds ds o' o → total ds o < total ds o'
  | [], ⟨_, _, mem, _⟩ => nomatch mem
  | a :: ds, ⟨le, c, mem, lt⟩ => match mem_cons_cases mem with
    | .inl same =>
      Nat.add_lt_add_of_lt_of_le (Eq.subst (motive := fun y => o y < o' y) same lt)
        (total_le ds fun b listed => le b (.tail a listed))
    | .inr rest =>
      Nat.add_lt_add_of_le_of_lt (le a (.head ds))
        (Exceeds.total_lt ⟨fun b listed => le b (.tail a listed), c, rest, lt⟩)

/-- **The family's stock is a rising order.** -/
theorem rising_total (ds : List C) : Rising ds fun o' o => total ds o < total ds o' :=
  fun _ _ exceeds => exceeds.total_lt

/-- **An order ranking above wherever a rising order does is rising**: a lexicographic order with
the family first, whatever it counts after, is one. -/
theorem Rising.mono (rising : Rising ds better) {better' : (C → Nat) → (C → Nat) → Prop}
    (above : ∀ o' o, better o' o → better' o' o) : Rising ds better' :=
  fun o o' exceeds => above o' o (rising o o' exceeds)

/-- **The drive to the least level, exactly.** Every order rising with the family has its optima
at the least level beyond, condition by condition, among the eligible outcomes, exactly where every
eligible outcome standing above another at a condition beyond is not unbeaten on the family. -/
theorem least_iff :
    (∀ better, Rising ds better → ∀ o, Frontier eligible better o → Least rest eligible o) ↔
      ∀ o o', eligible o → eligible o' → ∀ c, c ∈ rest → o' c < o c →
        ¬ ¬ ∃ o'', eligible o'' ∧ Exceeds ds o'' o :=
  ⟨fun drives o o' eligibleO eligibleO' c mem lower unbeaten =>
      Nat.not_le_of_gt lower
        (drives (fun o₁ o₂ => Exceeds ds o₁ o₂) (fun _ _ exceeds => exceeds) o
          ⟨eligibleO, fun o'' eligible'' exceeds => unbeaten ⟨o'', eligible'', exceeds⟩⟩
          c mem o' eligibleO'),
   fun beaten _ rising o optimum c mem o' eligibleO' => Nat.ge_of_not_lt fun lower =>
      beaten o o' optimum.1 eligibleO' c mem lower fun ⟨o'', eligible'', exceeds⟩ =>
        optimum.2 o'' eligible'' (rising o o'' exceeds)⟩

/-- **With room, every optimum is at the least level beyond.** -/
theorem least_of_room (rising : Rising ds better) (room : Room ds rest eligible) {o : C → Nat}
    (optimum : Frontier eligible better o) : Least rest eligible o :=
  least_iff.mpr (fun o o' eligibleO eligibleO' c mem lower unbeaten =>
    unbeaten (room o o' eligibleO eligibleO' c mem lower)) better rising o optimum

/-! ## Shared units -/

/-- One unit moved from `c` to `d`. -/
def transfer [DecidableEq C] (c d : C) (o : C → Nat) : C → Nat :=
  fun x => if x = c then o c - 1 else if x = d then o d + 1 else o x

/-- Shared units: the eligible outcomes are closed under moving a unit from a condition beyond
that holds one into a condition of the family. -/
def Shared [DecidableEq C] (ds rest : List C) (eligible : (C → Nat) → Prop) : Prop :=
  ∀ o, eligible o → ∀ c d, c ∈ rest → d ∈ ds → 0 < o c → eligible (transfer c d o)

/-- A unit moved from outside a family into it exceeds on the family. -/
theorem transfer_exceeds [DecidableEq C] {c d : C} (out : ¬ c ∈ ds) (inside : d ∈ ds)
    (o : C → Nat) : Exceeds ds (transfer c d o) o :=
  have kept : ∀ x, x ∈ ds → transfer c d o x = if x = d then o d + 1 else o x :=
    fun _ listed => if_neg fun same => out (Eq.subst (motive := fun y => y ∈ ds) same listed)
  ⟨fun x listed => Nat.le_trans
      (match decEq x d with
        | .isTrue same => Nat.le_trans (Nat.le_succ (o x))
            (Nat.le_of_eq ((congrArg (o · + 1) same).trans (if_pos same).symm))
        | .isFalse other => Nat.le_of_eq (if_neg other).symm)
      (Nat.le_of_eq (kept x listed).symm),
   d, inside, Nat.lt_of_lt_of_le (Nat.lt_succ_self (o d))
      (Nat.le_of_eq (((if_pos (rfl : d = d) : (if d = d then o d + 1 else o d) = o d + 1).symm).trans
        (kept d inside).symm))⟩

/-- **Shared units give room.** With the conditions beyond apart from a family holding at least
one condition, shared units give room beyond. -/
theorem Shared.room [DecidableEq C] (apart : ∀ c, c ∈ rest → ¬ c ∈ ds) {d : C} (inside : d ∈ ds)
    (shared : Shared ds rest eligible) : Room ds rest eligible :=
  fun o _ eligibleO _ c mem lower =>
    ⟨transfer c d o, shared o eligibleO c d mem inside (Nat.lt_of_le_of_lt (Nat.zero_le _) lower),
     transfer_exceeds (apart c mem) inside o⟩

/-- **With shared units, every optimum is at the least level beyond.** -/
theorem least_of_shared [DecidableEq C] (rising : Rising ds better)
    (apart : ∀ c, c ∈ rest → ¬ c ∈ ds) {d : C} (inside : d ∈ ds)
    (shared : Shared ds rest eligible) {o : C → Nat} (optimum : Frontier eligible better o) :
    Least rest eligible o :=
  least_of_room rising (shared.room apart inside) optimum

end Optimum

/-! ## On a web: what an optimum breaks -/

namespace Web

variable {W : Web F C} {ds rest : List C} {eligible : (C → Nat) → Prop}
  {better : (C → Nat) → (C → Nat) → Prop} {dep : C → F} {t : Nat}

/-- **An optimum breaks exactly what any outcome breaks.** Where the levels after the step are an
optimum of an order rising with the family, with room beyond, and each condition beyond is
depended on at a need it meets, a dependence beyond is broken across the step exactly where some
eligible outcome leaves its condition below the need. -/
theorem optimum_broken_iff (rising : Optimum.Rising ds better)
    (room : Optimum.Room ds rest eligible) (optimum : Frontier eligible better (W.level (t + 1)))
    (met : W.MetOn dep rest t) {c : C} (mem : c ∈ rest) :
    W.Broken t (dep c) c ↔ ∃ o, eligible o ∧ o c < W.need t (dep c) c :=
  ⟨fun broken => ⟨W.level (t + 1), optimum.1, broken.2.2⟩,
   fun ⟨_, eligibleO, below⟩ => ⟨(met c mem).1, (met c mem).2,
     Nat.lt_of_le_of_lt (Optimum.least_of_room rising room optimum c mem _ eligibleO) below⟩⟩

/-- **The formations beyond end, unseen.** Under the conditions of `Web.optimum_broken_iff`, where
activity needs support, some eligible outcome leaves a condition beyond below the need of the
dependence on it, and that dependence is as it was across the step, the dependence is broken and
its formation is not active after the step; where every condition a member of a group couples
into is in the family, that formation is no member, and no member couples into the condition. -/
theorem optimum_ends_beyond {obs : F → C → Prop} {members : F → Prop}
    (rising : Optimum.Rising ds better) (room : Optimum.Room ds rest eligible)
    (optimum : Frontier eligible better (W.level (t + 1))) (met : W.MetOn dep rest t)
    (dependent : W.Dependent) (apart : ∀ c, c ∈ rest → ¬ c ∈ ds)
    (listed : ∀ h c, members h → W.CoupledInto obs h c → c ∈ ds) {c : C} (mem : c ∈ rest)
    {o : C → Nat} (eligibleO : eligible o) (below : o c < W.need t (dep c) c)
    (fixed : W.requires (t + 1) (dep c) c ∧ W.need t (dep c) c ≤ W.need (t + 1) (dep c) c) :
    W.Broken t (dep c) c ∧ ¬ W.active (t + 1) (dep c) ∧ ¬ members (dep c) ∧
      ∀ h, members h → ¬ W.CoupledInto obs h c :=
  have broken := (optimum_broken_iff rising room optimum met mem).mpr ⟨o, eligibleO, below⟩
  have unseen : ∀ h, members h → ¬ W.CoupledInto obs h c :=
    fun h member couples => apart c mem (listed h c member couples)
  ⟨broken,
   fun active => Nat.not_le_of_gt broken.2.2
     (Nat.le_trans fixed.2 (dependent (t + 1) (dep c) active c fixed.1)),
   fun member => unseen (dep c) member (.inl ⟨t, broken.1⟩), unseen⟩

end Web

/-! ## Conservation: the family's rise is the beyond's fall with the loss -/

namespace Flow

variable {ds rest : List C} {t : Nat}

/-- **Raising the family is lowering the beyond with the loss, unit for unit.** Of two balanced
steps from equal totals of the family and the beyond, each gaining nothing on the whole, one
leaves the family's stock at most where the other does exactly where it leaves the beyond's stock
with the loss at least where the other does. -/
theorem Balances.family_le_iff {L L' : Flow F C} {W W' : Web F C} (balances : L.Balances W)
    (balances' : L'.Balances W') (gainless : L.GainlessOn (ds ++ rest) t)
    (gainless' : L'.GainlessOn (ds ++ rest) t)
    (start : W.stock ds t + W.stock rest t = W'.stock ds t + W'.stock rest t) :
    W.stock ds (t + 1) ≤ W'.stock ds (t + 1) ↔
      W'.stock rest (t + 1) + L'.lost (ds ++ rest) t ≤
        W.stock rest (t + 1) + L.lost (ds ++ rest) t :=
  have same : W.stock ds (t + 1) + (W.stock rest (t + 1) + L.lost (ds ++ rest) t) =
      W'.stock ds (t + 1) + (W'.stock rest (t + 1) + L'.lost (ds ++ rest) t) :=
    (Nat.add_assoc _ _ _).symm.trans ((balances.beyond_falls_exactly gainless).trans
      (start.trans ((balances'.beyond_falls_exactly gainless').symm.trans (Nat.add_assoc _ _ _))))
  have turned : W.stock rest (t + 1) + L.lost (ds ++ rest) t + W.stock ds (t + 1) =
      W'.stock rest (t + 1) + L'.lost (ds ++ rest) t + W'.stock ds (t + 1) :=
    (Nat.add_comm _ _).trans (same.trans (Nat.add_comm _ _))
  ⟨fun le => le_of_add_le_add_right (W.stock ds (t + 1))
      (Nat.le_trans (Nat.add_le_add_left le _) (Nat.le_of_eq turned.symm)),
   fun le => le_of_add_le_add_right (W'.stock rest (t + 1) + L'.lost (ds ++ rest) t)
      (Nat.le_trans (Nat.add_le_add_left le _) (Nat.le_of_eq same))⟩

/-- **The top of the family is the least beyond.** Among moves, each a balanced step from equal
totals gaining nothing on the whole, a move leaves the family's stock at least where every move
does exactly where it leaves the beyond's stock with the loss at most where every move does. -/
theorem top_iff_least {A : Type} {L : A → Flow F C} {W : A → Web F C}
    (balances : ∀ a, (L a).Balances (W a)) (gainless : ∀ a, (L a).GainlessOn (ds ++ rest) t)
    (start : ∀ a b, (W a).stock ds t + (W a).stock rest t = (W b).stock ds t + (W b).stock rest t)
    (a : A) :
    (∀ b, (W b).stock ds (t + 1) ≤ (W a).stock ds (t + 1)) ↔
      ∀ b, (W a).stock rest (t + 1) + (L a).lost (ds ++ rest) t ≤
        (W b).stock rest (t + 1) + (L b).lost (ds ++ rest) t :=
  ⟨fun top b => ((balances b).family_le_iff (balances a) (gainless b) (gainless a)
      (start b a)).mp (top b),
   fun least b => ((balances b).family_le_iff (balances a) (gainless b) (gainless a)
      (start b a)).mpr (least b)⟩

variable {L : Flow F C} {W : Web F C} {eligible : (C → Nat) → Prop}
  {better : (C → Nat) → (C → Nat) → Prop} {dep : C → F}

/-- **Keeping each dependence, the optimum takes exactly the slack.** Restrict the outcomes to
those keeping every dependence beyond at its need. Where the levels after a balanced step gaining
nothing on the whole are an optimum among them of an order rising with the family, with room among
them, each condition beyond depended on at a need it meets, and each need attained by one of them,
no dependence beyond is broken, and the family's stock after the step, with what the whole loses,
is its stock before with the slack. -/
theorem keeping_optimum_takes_slack (balances : L.Balances W)
    (gainless : L.GainlessOn (ds ++ rest) t) (met : W.MetOn dep rest t)
    (rising : Optimum.Rising ds better)
    (room : Optimum.Room ds rest fun o => eligible o ∧ ∀ c, c ∈ rest → W.need t (dep c) c ≤ o c)
    (attained : ∀ c, c ∈ rest → ∃ o, (eligible o ∧ ∀ c, c ∈ rest → W.need t (dep c) c ≤ o c) ∧
      o c ≤ W.need t (dep c) c)
    (optimum : Frontier (fun o => eligible o ∧ ∀ c, c ∈ rest → W.need t (dep c) c ≤ o c) better
      (W.level (t + 1))) :
    (∀ c, c ∈ rest → ¬ W.Broken t (dep c) c) ∧
      W.stock ds (t + 1) + L.lost (ds ++ rest) t = W.stock ds t + W.slack dep rest t :=
  have least := Optimum.least_of_room rising room optimum
  have atNeed : ∀ c, c ∈ rest → W.level (t + 1) c = W.need t (dep c) c :=
    fun c mem => match attained c mem with
      | ⟨_, keeping, atMost⟩ =>
        Nat.le_antisymm (Nat.le_trans (least c mem _ keeping) atMost) (optimum.1.2 c mem)
  have beyond : W.stock rest (t + 1) = total rest fun c => W.need t (dep c) c :=
    total_congr_on atNeed
  have exact : W.stock ds (t + 1) + L.lost (ds ++ rest) t + total rest
      (fun c => W.need t (dep c) c) =
      W.stock ds t + W.slack dep rest t + total rest fun c => W.need t (dep c) c :=
    (Nat.add_right_comm _ _ _).trans
      ((congrArg (W.stock ds (t + 1) + · + L.lost (ds ++ rest) t) beyond.symm).trans
        ((balances.beyond_falls_exactly gainless).trans
          ((congrArg (W.stock ds t + ·) (met.stock_eq.trans (Nat.add_comm _ _))).trans
            (Nat.add_assoc _ _ _).symm)))
  ⟨fun c mem broken => Nat.not_le_of_gt broken.2.2 (optimum.1.2 c mem),
   add_right_cancel _ exact⟩

end Flow

/-! ## Witnesses -/

namespace Optimum

namespace Drain

open Diversion DrawnBeyond

/-- Every split of three units between the source and the store. -/
def Split (o : Place → Nat) : Prop :=
  o .source + o .store = 3

/-- The store's stock order. -/
def storeOrder (o' o : Place → Nat) : Prop :=
  total [Place.store] o < total [Place.store] o'

/-- The source three at the start; after the step, everything in the store. -/
def drainedLevel (t : Nat) : Place → Nat
  | .source => Witnesses.profile [3] 0 t
  | .store => Witnesses.profile [0] 3 t

/-- The store's stock order rises with the store. -/
theorem storeOrder_rising : Rising [Place.store] storeOrder :=
  rising_total [Place.store]

/-- The splits are shared units between the source and the store. -/
theorem split_shared : Shared [Place.store] [Place.source] Split :=
  fun o split _ d beyond inside positive =>
    match mem_cons_cases beyond, mem_cons_cases inside with
    | .inr nothing, _ => nomatch nothing
    | _, .inr nothing => nomatch nothing
    | .inl atSource, .inl atStore =>
      Eq.subst (motive := fun x => Split (transfer x d o)) atSource.symm
        (Eq.subst (motive := fun y => Split (transfer Place.source y o)) atStore.symm
          (show o .source - 1 + (o .store + 1) = 3 from
            (Nat.add_left_comm _ _ _).trans
              ((congrArg (o .store + ·) (Naturals.sub_add_cancel
                (Eq.subst (motive := fun x => 0 < o x) atSource positive))).trans
                ((Nat.add_comm _ _).trans split))))

/-- Draining the source into the store is an optimum of the store's order among the splits. -/
theorem drained_optimum : Frontier Split storeOrder ((web drainedLevel).level 1) :=
  ⟨rfl, fun o split above => Nat.not_le_of_gt above
    (show o .store ≤ 3 from Nat.le_trans (Nat.le_add_left (o .store) (o .source)) (Nat.le_of_eq split))⟩

/-- The taker couples into the store alone, whatever the levels. -/
theorem taker_couples_store (level : Nat → Place → Nat) : ∀ h c, h = Formation.taker →
    (web level).CoupledInto gauge h c → c ∈ [Place.store] :=
  fun _ c same => Eq.subst
    (motive := fun x => (web level).CoupledInto gauge x c → c ∈ [Place.store]) same.symm
    fun couples => match couples with
      | .inl ⟨_, requires⟩ => False.elim (requires : False)
      | .inr observes => match c with
        | .source => False.elim (observes : False)
        | .store => .head []

/-- **The optimum drains the source and the dweller ends.** In the splits of three units, the
store's optimum leaves the source below the dweller's need: the dweller's dependence is broken,
the dweller is not active after the step, it is not the taker, and the taker does not couple into
the source; derived from `Web.optimum_ends_beyond`. -/
theorem drained_ends :
    (web drainedLevel).Broken 0 .dweller .source ∧ ¬ (web drainedLevel).active 1 .dweller ∧
      ¬ dwellerOn Place.source = Formation.taker ∧
      ¬ (web drainedLevel).CoupledInto gauge .taker .source :=
  match Web.optimum_ends_beyond (W := web drainedLevel) (ds := [Place.store])
      (rest := [Place.source]) (t := 0) (dep := dwellerOn) (obs := gauge)
      (members := fun h => h = Formation.taker) storeOrder_rising
      (split_shared.room source_apart (.head [])) drained_optimum
      (met_source drainedLevel 0 (Nat.le_succ 2)) (dependent drainedLevel) source_apart
      (taker_couples_store drainedLevel) (.head []) (o := (web drainedLevel).level 1) rfl
      (Nat.zero_lt_succ 1) (fixed_source drainedLevel 0 Place.source (.head [])) with
  | ⟨broken, ended, other, unseen⟩ => ⟨broken, ended, other, unseen .taker rfl⟩

/-- Counting the source after the store: the store's order first, the source among outcomes
alike on the store. -/
def countedAfter (o' o : Place → Nat) : Prop :=
  storeOrder o' o ∨ (o' .store = o .store ∧ o .source < o' .source)

/-- **Counting the beyond after the proxy changes nothing.** Every optimum among the splits of the
order counting the source after the store leaves the source empty. -/
theorem counted_after_drains {o : Place → Nat} (optimum : Frontier Split countedAfter o) :
    o .source = 0 :=
  Nat.le_zero.mp
    (least_of_shared (storeOrder_rising.mono fun _ _ above => .inl above) source_apart
      (.head []) split_shared optimum Place.source (.head []) ((web drainedLevel).level 1) rfl)

/-- Keeping the source at its need, the slack moved to the store. -/
def keptLevel : Place → Nat := WithinSlack.level 1

/-- One unit in each place. -/
def low : Place → Nat
  | .source => 1
  | .store => 1

/-- Two units in the store, none in the source. -/
def high : Place → Nat
  | .source => 0
  | .store => 2

/-- An order satisfied at a store of one: it ranks an outcome reaching one above one that does
not. -/
def satisficing (o' o : Place → Nat) : Prop :=
  1 ≤ o' .store ∧ o .store < 1

/-- **A satisficing order neither drives nor protects.** It is not rising with the store, and
among the splits both the outcome keeping the dweller's need and the outcome draining the source
are its optima. -/
theorem satisficing_either :
    ¬ Rising [Place.store] satisficing ∧ Frontier Split satisficing keptLevel ∧
      Frontier Split satisficing ((web drainedLevel).level 1) ∧
      (web DrawnBeyond.WithinSlack.level).need 0 .dweller .source ≤ keptLevel .source ∧
      (web drainedLevel).level 1 .source < (web drainedLevel).need 0 .dweller .source :=
  ⟨fun rising => Nat.lt_irrefl 1
      (rising low high
        ⟨fun _ mem => (match mem_cons_cases mem with
          | .inl same => Eq.subst (motive := fun y => low y ≤ high y) same.symm (Nat.le_succ 1)
          | .inr nothing => nomatch nothing),
         .store, .head [], Nat.lt_succ_self 1⟩).2,
   ⟨rfl, fun _ _ above => Nat.lt_irrefl 1 above.2⟩,
   ⟨rfl, fun _ _ above => Nat.not_lt_zero 2 (Nat.lt_of_succ_lt_succ above.2)⟩,
   Nat.le_refl 2, Nat.zero_lt_succ 1⟩

/-- Spilling the source: two outcomes, the source kept or spilled, the store empty in both. -/
def Spilling (o : Place → Nat) : Prop :=
  o = drainedLevel 0 ∨ o = fun _ => 0

/-- **Without room, an optimum need not be at the least level.** Where lowering the source frees
nothing for the store, keeping the source is an optimum of the store's order, and it is not at
the least level beyond. -/
theorem room_needed :
    Frontier Spilling storeOrder (drainedLevel 0) ∧
      ¬ Least [Place.source] Spilling (drainedLevel 0) :=
  ⟨⟨.inl rfl, fun _ spilling above => match spilling with
      | .inl same => Nat.lt_irrefl 0
          (Eq.subst (motive := fun x => total [Place.store] (drainedLevel 0) <
            total [Place.store] x) same above)
      | .inr same => Nat.lt_irrefl 0
          (Eq.subst (motive := fun x => total [Place.store] (drainedLevel 0) <
            total [Place.store] x) same above)⟩,
   fun least => Nat.not_succ_le_zero 2 (least Place.source (.head []) (fun _ => 0) (.inr rfl))⟩

/-- The outcomes keeping the dweller's need. -/
def Keeping (o : Place → Nat) : Prop :=
  Split o ∧ ∀ c, c ∈ [Place.source] →
    (web WithinSlack.level).need 0 (dwellerOn c) c ≤ o c

/-- Among the splits keeping the need, an outcome standing above another at the source is
exceeded on the store by one. -/
theorem keeping_room : Room [Place.store] [Place.source] Keeping :=
  fun o o' keeping keeping' c mem lower =>
    have atSource : c = Place.source := match mem_cons_cases mem with
      | .inl same => same
      | .inr nothing => nomatch nothing
    have above : 3 ≤ o .source := Nat.lt_of_le_of_lt (keeping'.2 .source (.head []))
      (Eq.subst (motive := fun x => o' x < o x) atSource lower)
    ⟨transfer .source .store o,
     ⟨split_shared o keeping.1 .source .store (.head []) (.head [])
        (Nat.lt_of_lt_of_le (Nat.zero_lt_succ 2) above),
      fun _ listed => Eq.subst (motive := fun y =>
          (web WithinSlack.level).need 0 (dwellerOn y) y ≤ transfer .source .store o y)
        (match mem_cons_cases listed with
          | .inl same => same.symm
          | .inr nothing => nomatch nothing)
        (Nat.sub_le_sub_right above 1)⟩,
     transfer_exceeds (source_apart .source (.head [])) (.head []) o⟩

/-- **Keeping the dweller's need, the optimum takes exactly the slack.** The keeping outcome of
`DrawnBeyond.WithinSlack` is the store's optimum among the splits keeping the need: no dependence
on the source breaks, and the store rises by exactly the slack; derived from
`Flow.keeping_optimum_takes_slack`. -/
theorem kept_takes_slack :
    Frontier Keeping storeOrder ((web WithinSlack.level).level 1) ∧
      (∀ c, c ∈ [Place.source] → ¬ (web WithinSlack.level).Broken 0 (dwellerOn c) c) ∧
      (web WithinSlack.level).stock [Place.store] 1 + diverting.lost ([Place.store] ++ [Place.source]) 0 =
        (web WithinSlack.level).stock [Place.store] 0 +
          (web WithinSlack.level).slack dwellerOn [Place.source] 0 :=
  have optimum : Frontier Keeping storeOrder ((web WithinSlack.level).level 1) :=
    ⟨⟨rfl, fun _ mem => match mem_cons_cases mem with
        | .inl same => Eq.subst (motive := fun y =>
            (web WithinSlack.level).need 0 (dwellerOn y) y ≤ WithinSlack.level 1 y)
            same.symm (Nat.le_refl 2)
        | .inr nothing => nomatch nothing⟩,
     fun o keeping above => Nat.not_le_of_gt above
       (show o .store ≤ 1 from le_of_add_le_add_right 2
         (show o .store + 2 ≤ 1 + 2 from Nat.le_trans
           (Nat.add_le_add_left (keeping.2 .source (.head [])) (o .store))
           (Nat.le_of_eq ((Nat.add_comm _ _).trans keeping.1))))⟩
  ⟨optimum, Flow.keeping_optimum_takes_slack (eligible := Split) WithinSlack.balances
     (whole_gainless diverting 0 (Nat.le_refl 1) (Nat.le_refl 0))
     (met_source WithinSlack.level 0 (Nat.le_succ 2)) storeOrder_rising keeping_room
     (fun _ mem => match mem_cons_cases mem with
       | .inl same => ⟨(web WithinSlack.level).level 1, optimum.1,
           Eq.subst (motive := fun y => (web WithinSlack.level).level 1 y ≤
             (web WithinSlack.level).need 0 (dwellerOn y) y) same.symm (Nat.le_refl 2)⟩
       | .inr nothing => nomatch nothing)
     optimum⟩

end Drain

end Optimum


/-! ## Room from the exchange

Above, which outcomes are eligible and whether there is room are supplied. Here both are read off
one step of exchange. A part's members take from each condition at most their capacity there,
give only to a listed family and gain nothing on it, and the formations outside the part exchange
as they do; the outcomes open to the part are the levels after every such step that balances.
Room follows, and every optimum stands at each condition beyond at what the rest leaves there,
less the part's capacity there. -/

/-- A quantity one more at one member and the same elsewhere totals one more, over a list in
which that member stands once. -/
theorem total_raise_at {α : Type} {p q : α → Nat} {a : α} (at_a : p a = q a + 1)
    (off : ∀ x, ¬ x = a → p x = q x) :
    ∀ {l : List α}, Distinct l → a ∈ l → total l p = total l q + 1
  | b :: l, ⟨fresh, distinct⟩, mem =>
    match mem_cons_cases mem with
    | .inl same =>
      have rest : total l p = total l q :=
        total_congr_on fun x listed => off x fun xa =>
          fresh (Eq.subst (motive := fun y => y ∈ l) (xa.trans same) listed)
      (congrArg (· + total l p) (Eq.subst (motive := fun y => p y = q y + 1) same at_a)).trans
        ((congrArg (q b + 1 + ·) rest).trans (Nat.add_right_comm (q b) 1 (total l q)))
    | .inr later =>
      (congrArg (· + total l p)
          (off b fun ba => fresh (Eq.subst (motive := fun y => y ∈ l) ba.symm later))).trans
        ((congrArg (q b + ·) (total_raise_at at_a off distinct later)).trans
          (Nat.add_assoc _ _ _).symm)

/-- A total splits into the members outside a part and the members of it. -/
theorem total_split {α : Type} (part : α → Bool) (f : α → Nat) (l : List α) :
    total l f = total l (fun a => bif part a then 0 else f a) +
      total l (fun a => bif part a then f a else 0) :=
  (total_congr (fun a => Bool.casesOn
      (motive := fun b => f a = (bif b then 0 else f a) + (bif b then f a else 0)) (part a)
      (Nat.add_zero (f a)).symm (Nat.zero_add (f a)).symm) l).trans (total_add _ _ l)

/-- Less by some amount is less exactly where the amount and what it is taken from are
positive. -/
theorem sub_lt_self_iff (n k : Nat) : n - k < n ↔ 0 < k ∧ 0 < n :=
  ⟨fun lt => ⟨match k with
      | 0 => absurd lt (Nat.lt_irrefl n)
      | _ + 1 => Nat.succ_pos _,
     Nat.lt_of_le_of_lt (Nat.zero_le _) lt⟩,
   fun ⟨positive, from_⟩ => match n, k, positive, from_ with
     | n + 1, k + 1, _, _ => Nat.lt_of_le_of_lt
         (Nat.le_of_eq (Naturals.succ_sub_succ n k)) (Nat.lt_succ_of_le (Nat.sub_le n k))⟩

namespace Flow

variable (L : Flow F C) (part : F → Bool)

/-- What the formations outside a part take from a condition across the step from `t`. -/
def restTaken (t : Nat) (c : C) : Nat :=
  total (L.present t) fun h => bif part h then 0 else L.take t h c

/-- What the formations outside a part give to a condition across the step from `t`. -/
def restGiven (t : Nat) (c : C) : Nat :=
  total (L.present t) fun h => bif part h then 0 else L.give t h c

/-- A part's capacity at a condition: the most its members taking part may take from it across
the step from `t`. -/
def capacity (cap : F → C → Nat) (t : Nat) (c : C) : Nat :=
  total (L.present t) fun h => bif part h then cap h c else 0

/-- Across the step from `t`, `L'` exchanges as `L` does outside a part, with the same formations
taking part, and each member of the part takes from each condition at most its capacity there,
gives only to the family `cs`, and gives the family no more than it takes from it. -/
def ActsWithin (cap : F → C → Nat) (cs : List C) (t : Nat) (L' : Flow F C) : Prop :=
  L'.present t = L.present t ∧
    (∀ h c, part h = false → L'.take t h c = L.take t h c ∧ L'.give t h c = L.give t h c) ∧
    (∀ h c, part h = true → L'.take t h c ≤ cap h c) ∧
    (∀ h c, part h = true → ¬ c ∈ cs → L'.give t h c = 0) ∧
    ∀ h, part h = true → total cs (L'.give t h) ≤ total cs (L'.take t h)

/-- The outcomes open to a part: the levels after a step within its capacity that balances from
the levels `l`. -/
def Outcome (l : C → Nat) (cap : F → C → Nat) (cs : List C) (t : Nat) (o : C → Nat) : Prop :=
  ∃ L', L.ActsWithin part cap cs t L' ∧ ∀ c, o c + L'.taken t c = l c + L'.given t c

variable {L part}

/-- **The step that happened is open.** Where the step balances and the part acts within its
capacity, the levels after it are an outcome open to the part. -/
theorem Outcome.of_balances {W : Web F C} {cap : F → C → Nat} {cs : List C} {t : Nat}
    (balances : L.Balances W) (acts : L.ActsWithin part cap cs t L) :
    L.Outcome part (W.level t) cap cs t (W.level (t + 1)) :=
  ⟨L, acts, balances t⟩

/-- Where no member taking part may take from a condition, the part's capacity there is
nothing. -/
theorem capacity_eq_zero {cap : F → C → Nat} {t : Nat} {c : C}
    (none : ∀ h, h ∈ L.present t → part h = true → cap h c = 0) :
    L.capacity part cap t c = 0 :=
  (total_congr_on fun h mem => by
    show (bif part h then cap h c else 0) = 0
    cases member : part h
    · rfl
    · exact none h mem member).trans (total_zero (L.present t))

variable {cap : F → C → Nat} {cs : List C} {t : Nat} {L' : Flow F C}

/-- What a step within the part's capacity takes from a condition: what the rest takes, with
what the part's members take. -/
theorem ActsWithin.taken_eq (acts : L.ActsWithin part cap cs t L') (c : C) :
    L'.taken t c = L.restTaken part t c +
      total (L.present t) fun h => bif part h then L'.take t h c else 0 :=
  (congrArg (fun ps => total ps fun h => L'.take t h c) acts.1).trans
    ((total_split part (fun h => L'.take t h c) (L.present t)).trans
      (congrArg (· + _) (total_congr (fun h => by
        show (bif part h then 0 else L'.take t h c) = (bif part h then 0 else L.take t h c)
        cases member : part h
        · exact (acts.2.1 h c member).1
        · rfl) _)))

/-- What a step within the part's capacity gives to a condition: what the rest gives, with what
the part's members give. -/
theorem ActsWithin.given_eq (acts : L.ActsWithin part cap cs t L') (c : C) :
    L'.given t c = L.restGiven part t c +
      total (L.present t) fun h => bif part h then L'.give t h c else 0 :=
  (congrArg (fun ps => total ps fun h => L'.give t h c) acts.1).trans
    ((total_split part (fun h => L'.give t h c) (L.present t)).trans
      (congrArg (· + _) (total_congr (fun h => by
        show (bif part h then 0 else L'.give t h c) = (bif part h then 0 else L.give t h c)
        cases member : part h
        · exact (acts.2.1 h c member).2
        · rfl) _)))

/-- The part's members take from a condition at most the part's capacity there. -/
theorem ActsWithin.part_taken_le (acts : L.ActsWithin part cap cs t L') (c : C) :
    (total (L.present t) fun h => bif part h then L'.take t h c else 0) ≤
      L.capacity part cap t c :=
  total_le _ fun h _ => by
    show (bif part h then L'.take t h c else 0) ≤ (bif part h then cap h c else 0)
    cases member : part h
    · exact Nat.le_refl 0
    · exact acts.2.2.1 h c member

/-- A member of the part is no formation outside it. -/
theorem other_of_out {h : F} (member : part h = true) {g : F} (out : part g = false) : ¬ g = h :=
  fun same => Bool.noConfusion
    ((Eq.subst (motive := fun y => part y = true) same.symm member).symm.trans out)

/-! ### Moving one unit -/

variable [DecidableEq F] [DecidableEq C]

/-- One more unit taken by `h` from `c` and given to `d` across the step from `t`. -/
def moveUnit (L : Flow F C) (t : Nat) (h : F) (c d : C) : Flow F C :=
  ⟨L.present, fun s g x => if s = t ∧ g = h ∧ x = c then L.take s g x + 1 else L.take s g x,
    fun s g x => if s = t ∧ g = h ∧ x = d then L.give s g x + 1 else L.give s g x⟩

/-- One unit `h` gave to `c` across the step from `t` given to `d` instead. -/
def redirect (L : Flow F C) (t : Nat) (h : F) (c d : C) : Flow F C :=
  ⟨L.present, L.take, fun s g x => if s = t ∧ g = h ∧ x = c then L.give s g x - 1
    else if s = t ∧ g = h ∧ x = d then L.give s g x + 1 else L.give s g x⟩

variable {h : F} {c d : C}

theorem moveUnit_take (g : F) (x : C) :
    (L'.moveUnit t h c d).take t g x =
      if g = h ∧ x = c then L'.take t g x + 1 else L'.take t g x := by
  show (if t = t ∧ g = h ∧ x = c then _ else _) = _
  by_cases at_ : g = h ∧ x = c
  · rw [if_pos ⟨rfl, at_⟩, if_pos at_]
  · rw [if_neg fun same => at_ same.2, if_neg at_]

theorem moveUnit_give (g : F) (x : C) :
    (L'.moveUnit t h c d).give t g x =
      if g = h ∧ x = d then L'.give t g x + 1 else L'.give t g x := by
  show (if t = t ∧ g = h ∧ x = d then _ else _) = _
  by_cases at_ : g = h ∧ x = d
  · rw [if_pos ⟨rfl, at_⟩, if_pos at_]
  · rw [if_neg fun same => at_ same.2, if_neg at_]

theorem redirect_give (g : F) (x : C) :
    (L'.redirect t h c d).give t g x =
      if g = h ∧ x = c then L'.give t g x - 1
      else if g = h ∧ x = d then L'.give t g x + 1 else L'.give t g x := by
  show (if t = t ∧ g = h ∧ x = c then _ else if t = t ∧ g = h ∧ x = d then _ else _) = _
  by_cases first : g = h ∧ x = c
  · rw [if_pos ⟨rfl, first⟩, if_pos first]
  · rw [if_neg fun same => first same.2, if_neg first]
    by_cases second : g = h ∧ x = d
    · rw [if_pos ⟨rfl, second⟩, if_pos second]
    · rw [if_neg fun same => second same.2, if_neg second]

/-- The moved unit raises what is taken from `c` by one. -/
theorem moveUnit_taken_at (distinct : Distinct (L'.present t)) (mem : h ∈ L'.present t) :
    (L'.moveUnit t h c d).taken t c = L'.taken t c + 1 :=
  total_raise_at (p := fun g => (L'.moveUnit t h c d).take t g c)
    (q := fun g => L'.take t g c) (a := h)
    ((moveUnit_take h c).trans (if_pos ⟨rfl, rfl⟩))
    (fun g gh => (moveUnit_take g c).trans (if_neg fun same => gh same.1)) distinct mem

theorem moveUnit_taken_off {x : C} (off : ¬ x = c) :
    (L'.moveUnit t h c d).taken t x = L'.taken t x :=
  total_congr (fun g => (moveUnit_take g x).trans (if_neg fun same => off same.2)) _

/-- The moved unit raises what is given to `d` by one. -/
theorem moveUnit_given_at (distinct : Distinct (L'.present t)) (mem : h ∈ L'.present t) :
    (L'.moveUnit t h c d).given t d = L'.given t d + 1 :=
  total_raise_at (p := fun g => (L'.moveUnit t h c d).give t g d)
    (q := fun g => L'.give t g d) (a := h)
    ((moveUnit_give h d).trans (if_pos ⟨rfl, rfl⟩))
    (fun g gh => (moveUnit_give g d).trans (if_neg fun same => gh same.1)) distinct mem

theorem moveUnit_given_off {x : C} (off : ¬ x = d) :
    (L'.moveUnit t h c d).given t x = L'.given t x :=
  total_congr (fun g => (moveUnit_give g x).trans (if_neg fun same => off same.2)) _

/-- The redirected unit lowers what is given to `c` by one. -/
theorem redirect_given_at (distinct : Distinct (L'.present t)) (mem : h ∈ L'.present t)
    (gave : 0 < L'.give t h c) :
    (L'.redirect t h c d).given t c + 1 = L'.given t c :=
  (total_raise_at (p := fun g => L'.give t g c)
    (q := fun g => (L'.redirect t h c d).give t g c) (a := h)
    ((Naturals.sub_add_cancel gave).symm.trans
      (congrArg (· + 1) ((if_pos ⟨rfl, rfl⟩).symm.trans (redirect_give h c).symm)))
    (fun g gh => ((if_neg fun same => gh same.1).trans
        (if_neg fun same => gh same.1)).symm.trans (redirect_give g c).symm)
    distinct mem).symm

/-- The redirected unit raises what is given to `d` by one. -/
theorem redirect_given_to (distinct : Distinct (L'.present t)) (mem : h ∈ L'.present t)
    (apart : ¬ c = d) :
    (L'.redirect t h c d).given t d = L'.given t d + 1 :=
  total_raise_at (p := fun g => (L'.redirect t h c d).give t g d)
    (q := fun g => L'.give t g d) (a := h)
    ((redirect_give h d).trans ((if_neg fun same => apart same.2.symm).trans (if_pos ⟨rfl, rfl⟩)))
    (fun g gh => (redirect_give g d).trans ((if_neg fun same => gh same.1).trans
      (if_neg fun same => gh same.1))) distinct mem

theorem redirect_given_off {x : C} (offC : ¬ x = c) (offD : ¬ x = d) :
    (L'.redirect t h c d).given t x = L'.given t x :=
  total_congr (fun g => (redirect_give g x).trans ((if_neg fun same => offC same.2).trans
    (if_neg fun same => offD same.2))) _

/-- **A moved unit balances into a transfer.** Where a step balances from `l` to `o` and `o`
holds a unit at `c`, the step with one more unit taken by a member taking part from `c` and given
to `d` balances from `l` to the transfer of that unit. -/
theorem moveUnit_balances {l o : C → Nat} (distinct : Distinct (L'.present t))
    (mem : h ∈ L'.present t) (apart : ¬ c = d) (positive : 0 < o c)
    (balances : ∀ x, o x + L'.taken t x = l x + L'.given t x) (x : C) :
    Optimum.transfer c d o x + (L'.moveUnit t h c d).taken t x =
      l x + (L'.moveUnit t h c d).given t x := by
  show (if x = c then o c - 1 else if x = d then o d + 1 else o x) + _ = _
  by_cases xc : x = c
  · subst xc
    rw [if_pos rfl, moveUnit_taken_at distinct mem, moveUnit_given_off apart, ← Nat.add_assoc,
      Nat.add_right_comm, Naturals.sub_add_cancel positive]
    exact balances x
  · rw [if_neg xc, moveUnit_taken_off xc]
    by_cases xd : x = d
    · subst xd
      rw [if_pos rfl, moveUnit_given_at distinct mem, Nat.add_right_comm, balances x,
        Nat.add_assoc]
    · rw [if_neg xd, moveUnit_given_off xd]
      exact balances x

/-- **A redirected unit balances into a transfer.** Where a step balances from `l` to `o`, `o`
holds a unit at `c` and a member taking part gave `c` a unit, the step giving that unit to `d`
instead balances from `l` to the transfer of that unit. -/
theorem redirect_balances {l o : C → Nat} (distinct : Distinct (L'.present t))
    (mem : h ∈ L'.present t) (apart : ¬ c = d) (positive : 0 < o c)
    (gave : 0 < L'.give t h c) (balances : ∀ x, o x + L'.taken t x = l x + L'.given t x)
    (x : C) :
    Optimum.transfer c d o x + (L'.redirect t h c d).taken t x =
      l x + (L'.redirect t h c d).given t x := by
  show (if x = c then o c - 1 else if x = d then o d + 1 else o x) + L'.taken t x = _
  by_cases xc : x = c
  · subst xc
    rw [if_pos rfl]
    apply Naturals.add_right_cancel (k := 1)
    rw [Nat.add_right_comm, Naturals.sub_add_cancel positive, Nat.add_assoc,
      redirect_given_at distinct mem gave]
    exact balances x
  · rw [if_neg xc]
    by_cases xd : x = d
    · subst xd
      rw [if_pos rfl, redirect_given_to distinct mem apart, Nat.add_right_comm, balances x,
        Nat.add_assoc]
    · rw [if_neg xd, redirect_given_off xc xd]
      exact balances x

/-- **A moved unit keeps the step within the part's capacity.** Where a member takes from `c`
less than its capacity, taking one more from `c` and giving it to `d`, both in the family, keeps
the step within the part's capacity. -/
theorem ActsWithin.moveUnit (acts : L.ActsWithin part cap cs t L') (member : part h = true)
    (room : L'.take t h c < cap h c) (distinct : Distinct cs) (inC : c ∈ cs) (inD : d ∈ cs) :
    L.ActsWithin part cap cs t (L'.moveUnit t h c d) := by
  refine ⟨acts.1, fun g x out => ?_, fun g x inside => ?_, fun g x inside outside => ?_,
    fun g inside => ?_⟩
  · rw [moveUnit_take, moveUnit_give, if_neg fun same => other_of_out member out same.1,
      if_neg fun same => other_of_out member out same.1]
    exact acts.2.1 g x out
  · rw [moveUnit_take]
    by_cases at_ : g = h ∧ x = c
    · rw [if_pos at_]
      rcases at_ with ⟨rfl, rfl⟩
      exact room
    · rw [if_neg at_]
      exact acts.2.2.1 g x inside
  · rw [moveUnit_give, if_neg fun same =>
      outside (Eq.subst (motive := fun y => y ∈ cs) same.2.symm inD)]
    exact acts.2.2.2.1 g x inside outside
  · by_cases gh : g = h
    · subst gh
      have gives : total cs (fun x => (L'.moveUnit t g c d).give t g x) =
          total cs (L'.give t g) + 1 :=
        total_raise_at (a := d) ((moveUnit_give g d).trans (if_pos ⟨rfl, rfl⟩))
          (fun x xd => (moveUnit_give g x).trans (if_neg fun same => xd same.2)) distinct inD
      have takes : total cs (fun x => (L'.moveUnit t g c d).take t g x) =
          total cs (L'.take t g) + 1 :=
        total_raise_at (a := c) ((moveUnit_take g c).trans (if_pos ⟨rfl, rfl⟩))
          (fun x xc => (moveUnit_take g x).trans (if_neg fun same => xc same.2)) distinct inC
      exact Nat.le_trans (Nat.le_of_eq gives) (Nat.le_trans
        (Nat.add_le_add_right (acts.2.2.2.2 g inside) 1) (Nat.le_of_eq takes.symm))
    · exact Nat.le_trans (Nat.le_of_eq (total_congr
          (fun x => (moveUnit_give g x).trans (if_neg fun same => gh same.1)) cs))
        (Nat.le_trans (acts.2.2.2.2 g inside) (Nat.le_of_eq (total_congr
          (fun x => (moveUnit_take g x).trans (if_neg fun same => gh same.1)) cs).symm))

/-- **A redirected unit keeps the step within the part's capacity.** Where a member gives `c` a
unit, giving it to `d` instead, both in the family, keeps the step within the part's
capacity. -/
theorem ActsWithin.redirect (acts : L.ActsWithin part cap cs t L') (member : part h = true)
    (distinct : Distinct cs) (inC : c ∈ cs) (inD : d ∈ cs) (apart : ¬ c = d)
    (gave : 0 < L'.give t h c) :
    L.ActsWithin part cap cs t (L'.redirect t h c d) := by
  refine ⟨acts.1, fun g x out => ?_, fun g x inside => acts.2.2.1 g x inside,
    fun g x inside outside => ?_, fun g inside => ?_⟩
  · refine ⟨(acts.2.1 g x out).1, ?_⟩
    rw [redirect_give, if_neg fun same => other_of_out member out same.1,
      if_neg fun same => other_of_out member out same.1]
    exact (acts.2.1 g x out).2
  · rw [redirect_give, if_neg fun same =>
        outside (Eq.subst (motive := fun y => y ∈ cs) same.2.symm inC),
      if_neg fun same => outside (Eq.subst (motive := fun y => y ∈ cs) same.2.symm inD)]
    exact acts.2.2.2.1 g x inside outside
  · show total cs (fun x => (L'.redirect t h c d).give t g x) ≤ total cs (L'.take t g)
    by_cases gh : g = h
    · subst gh
      have raised : total cs (fun x => if x = d then L'.give t g x + 1 else L'.give t g x) =
          total cs (L'.give t g) + 1 :=
        total_raise_at (a := d) (if_pos rfl) (fun x xd => if_neg xd) distinct inD
      have lowered : total cs (fun x => if x = d then L'.give t g x + 1 else L'.give t g x) =
          total cs (fun x => (L'.redirect t g c d).give t g x) + 1 :=
        total_raise_at (a := c)
          ((if_neg (c := c = d) apart).trans ((Naturals.sub_add_cancel gave).symm.trans
            (congrArg (· + 1) ((if_pos (c := g = g ∧ c = c) ⟨rfl, rfl⟩).symm.trans
              (redirect_give g c).symm))))
          (fun x xc => by
            rw [redirect_give, if_neg (c := g = g ∧ x = c) fun same => xc same.2]
            by_cases xd : x = d
            · rw [if_pos (c := x = d) xd, if_pos (c := g = g ∧ x = d) ⟨rfl, xd⟩]
            · rw [if_neg (c := x = d) xd, if_neg (c := g = g ∧ x = d) fun same => xd same.2])
          distinct inC
      exact Nat.le_trans (Nat.le_of_eq (Naturals.add_right_cancel (k := 1)
        (lowered.symm.trans raised))) (acts.2.2.2.2 g inside)
    · exact Nat.le_trans (Nat.le_of_eq (total_congr (fun x => (redirect_give g x).trans
          ((if_neg fun same => gh same.1).trans (if_neg fun same => gh same.1))) cs))
        (acts.2.2.2.2 g inside)

end Flow

namespace Optimum

open Flow

variable {L : Flow F C} {part : F → Bool} {cap : F → C → Nat} {t : Nat} {l : C → Nat}
  {ds rest : List C} {better : (C → Nat) → (C → Nat) → Prop}

/-- The outcomes open to a part standing at each condition beyond at least at its floor. -/
def Above (L : Flow F C) (part : F → Bool) (l : C → Nat) (cap : F → C → Nat) (ds rest : List C)
    (t : Nat) (floor : C → Nat) (o : C → Nat) : Prop :=
  L.Outcome part l cap (ds ++ rest) t o ∧ ∀ c, c ∈ rest → floor c ≤ o c

/-- A transfer from a condition beyond above its floor into the family keeps every floor
beyond. -/
theorem transfer_above [DecidableEq C] {floor o : C → Nat} {c d : C}
    (apart : ∀ c, c ∈ rest → ¬ c ∈ ds) (inside : d ∈ ds) (above : floor c < o c)
    (floors : ∀ x, x ∈ rest → floor x ≤ o x) : ∀ x, x ∈ rest → floor x ≤ transfer c d o x :=
  fun x mem => by
    show floor x ≤ if x = c then o c - 1 else if x = d then o d + 1 else o x
    by_cases xc : x = c
    · subst xc
      rw [if_pos rfl]
      exact Naturals.le_sub_of_add_le (a := 1)
        (Nat.le_trans (Nat.le_of_eq (Nat.add_comm 1 (floor x))) above)
    · rw [if_neg xc, if_neg fun same => apart x mem
        (Eq.subst (motive := fun y => y ∈ ds) same.symm inside)]
      exact floors x mem

/-- **A unit moved or redirected above the floor reaches an outcome exceeding on the family.**
Where an outcome open to the part stands above the floor at a condition beyond, and a member of
the part, taking part, either takes there less than its capacity or gives there something, the
transfer of one unit from that condition into the family is open to the part above every
floor. -/
theorem Above.transfer [DecidableEq F] [DecidableEq C] {floor o : C → Nat} {L' : Flow F C}
    (distinct : Distinct (L.present t)) (cdistinct : Distinct (ds ++ rest))
    (apart : ∀ c, c ∈ rest → ¬ c ∈ ds) {c d : C} (mem : c ∈ rest) (inside : d ∈ ds)
    (acts : L.ActsWithin part cap (ds ++ rest) t L')
    (balances : ∀ x, o x + L'.taken t x = l x + L'.given t x)
    (floors : ∀ x, x ∈ rest → floor x ≤ o x) (above : floor c < o c) {h : F}
    (present : h ∈ L.present t) (member : part h = true)
    (spare : L'.take t h c < cap h c ∨ 0 < L'.give t h c) :
    Above L part l cap ds rest t floor (transfer c d o) :=
  have cd : ¬ c = d := fun same =>
    apart c mem (Eq.subst (motive := fun y => y ∈ ds) same.symm inside)
  have inC : c ∈ ds ++ rest := ListTests.mem_append_iff.mpr (.inr mem)
  have inD : d ∈ ds ++ rest := ListTests.mem_append_iff.mpr (.inl inside)
  have distinct' : Distinct (L'.present t) := Eq.subst (motive := Distinct) acts.1.symm distinct
  have present' : h ∈ L'.present t := Eq.subst (motive := (h ∈ ·)) acts.1.symm present
  have positive : 0 < o c := Nat.lt_of_le_of_lt (Nat.zero_le _) above
  ⟨match spare with
    | .inl room => ⟨L'.moveUnit t h c d, acts.moveUnit member room cdistinct inC inD,
        moveUnit_balances distinct' present' cd positive balances⟩
    | .inr gave => ⟨L'.redirect t h c d, acts.redirect member cdistinct inC inD cd gave,
        redirect_balances distinct' present' cd positive gave balances⟩,
   transfer_above apart inside above floors⟩

/-- Under two steps within the part's capacity whose totals at a condition differ, some member
taking part differs the same way. -/
theorem member_below {L₁ L₂ : Flow F C} {cs : List C} (acts₁ : L.ActsWithin part cap cs t L₁)
    (acts₂ : L.ActsWithin part cap cs t L₂) {q₁ q₂ : F → Nat}
    (lt : total (L₁.present t) q₁ < total (L₂.present t) q₂)
    (outside : ∀ g, part g = false → q₁ g = q₂ g) :
    ∃ g, g ∈ L.present t ∧ part g = true ∧ q₁ g < q₂ g :=
  match exists_lt_of_total_lt (Nat.lt_of_le_of_lt (Nat.le_of_eq
      (congrArg (total · q₁) acts₁.1.symm)) (Nat.lt_of_lt_of_le lt
        (Nat.le_of_eq (congrArg (total · q₂) acts₂.1)))) with
  | ⟨g, listed, below⟩ => match member : part g with
    | true => ⟨g, listed, member, below⟩
    | false => absurd (Eq.subst (motive := fun y => q₁ g < y) (outside g member).symm below)
        (Nat.lt_irrefl _)

/-- **Room, read off the exchange.** Among the outcomes open to a part above any floors, an
outcome standing above another at a condition beyond is exceeded on the family by an outcome
open to the part: the other's step takes more there through some member, which this step can
also take and give to the family, or gives less there through some member, whose unit this step
can give to the family instead. -/
theorem Above.room [DecidableEq F] [DecidableEq C] (distinct : Distinct (L.present t))
    (cdistinct : Distinct (ds ++ rest)) (apart : ∀ c, c ∈ rest → ¬ c ∈ ds) {d : C}
    (inside : d ∈ ds) (floor : C → Nat) :
    Room ds rest (Above L part l cap ds rest t floor) :=
  fun o _ ⟨⟨L₁, acts₁, balances₁⟩, floors⟩ ⟨⟨L₂, acts₂, balances₂⟩, floors'⟩ c mem lower =>
    have above : floor c < o c := Nat.lt_of_le_of_lt (floors' c mem) lower
    ⟨Optimum.transfer c d o,
     match Nat.lt_or_ge (L₁.taken t c) (L₂.taken t c) with
     | .inl more =>
       match member_below acts₁ acts₂ (q₁ := fun g => L₁.take t g c)
           (q₂ := fun g => L₂.take t g c) more
           (fun g out => (acts₁.2.1 g c out).1.trans (acts₂.2.1 g c out).1.symm) with
       | ⟨_, listed, member, below⟩ =>
         Above.transfer distinct cdistinct apart mem inside acts₁ balances₁ floors above listed
           member (.inl (Nat.lt_of_lt_of_le below (acts₂.2.2.1 _ c member)))
     | .inr ge =>
       match member_below acts₂ acts₁ (q₁ := fun g => L₂.give t g c)
           (q₂ := fun g => L₁.give t g c)
           (Naturals.le_of_add_le_add_left (k := l c) (a := L₂.given t c + 1)
             (Nat.le_trans (Nat.le_of_eq (congrArg (· + 1) (balances₂ c).symm))
               (Nat.le_trans (Nat.add_lt_add_of_lt_of_le lower ge)
                 (Nat.le_of_eq (balances₁ c)))))
           (fun g out => (acts₂.2.1 g c out).2.trans (acts₁.2.1 g c out).2.symm) with
       | ⟨_, listed, member, below⟩ =>
         Above.transfer distinct cdistinct apart mem inside acts₁ balances₁ floors above listed
           member (.inr (Nat.lt_of_le_of_lt (Nat.zero_le _) below)),
     transfer_exceeds (apart c mem) inside o⟩

/-- **Above its floor, an optimum takes the part's whole capacity and gives nothing there.** Where an
optimum of an order rising with the family, among the outcomes open to the part above the
floors, stands above the floor at a condition beyond, every step reaching it has each member
taking part take its whole capacity there and give nothing there. -/
theorem Above.full [DecidableEq F] [DecidableEq C] {floor o : C → Nat} {L' : Flow F C}
    (distinct : Distinct (L.present t)) (cdistinct : Distinct (ds ++ rest))
    (apart : ∀ c, c ∈ rest → ¬ c ∈ ds) {d : C} (inside : d ∈ ds) (rising : Rising ds better)
    (optimum : Frontier (Above L part l cap ds rest t floor) better o)
    (acts : L.ActsWithin part cap (ds ++ rest) t L')
    (balances : ∀ x, o x + L'.taken t x = l x + L'.given t x) {c : C} (mem : c ∈ rest)
    (above : floor c < o c) {h : F} (present : h ∈ L.present t) (member : part h = true) :
    L'.take t h c = cap h c ∧ L'.give t h c = 0 :=
  have beaten : (L'.take t h c < cap h c ∨ 0 < L'.give t h c) → False := fun spare =>
    optimum.2 _ (Above.transfer distinct cdistinct apart mem inside acts balances optimum.1.2
      above present member spare) (rising _ _ (transfer_exceeds (apart c mem) inside o))
  ⟨Nat.le_antisymm (acts.2.2.1 h c member) (Nat.ge_of_not_lt fun lt => beaten (.inl lt)),
   match gave : L'.give t h c with
   | 0 => rfl
   | n + 1 => absurd (.inr (Nat.lt_of_lt_of_le (Nat.succ_pos n) (Nat.le_of_eq gave.symm)))
       beaten⟩

/-- **Every optimum stands at its floor or takes the whole capacity.** Where an optimum of an order
rising with the family, among the outcomes open to the part above the floors, stands at a
condition beyond, it stands at its floor there, or there the part takes its whole capacity and
gives nothing: what it leaves, with what the rest takes and the capacity, is the level before
with what the rest gives. -/
theorem Above.floor_or_full [DecidableEq F] [DecidableEq C] {floor o : C → Nat}
    (distinct : Distinct (L.present t)) (cdistinct : Distinct (ds ++ rest))
    (apart : ∀ c, c ∈ rest → ¬ c ∈ ds) {d : C} (inside : d ∈ ds) (rising : Rising ds better)
    (optimum : Frontier (Above L part l cap ds rest t floor) better o) {c : C} (mem : c ∈ rest) :
    o c = floor c ∨
      o c + L.restTaken part t c + L.capacity part cap t c = l c + L.restGiven part t c :=
  match optimum.1, Nat.lt_or_ge (floor c) (o c) with
  | _, .inr atMost => Or.inl (Nat.le_antisymm atMost (optimum.1.2 c mem))
  | ⟨⟨L', acts, balances⟩, _⟩, .inl above => by
    have full := fun h (present : h ∈ L.present t) (member : part h = true) =>
      Above.full distinct cdistinct apart inside rising optimum acts balances mem above
        present member
    have takes : (total (L.present t) fun h => bif part h then L'.take t h c else 0) =
        L.capacity part cap t c :=
      total_congr_on fun h present => by
        show (bif part h then L'.take t h c else 0) = (bif part h then cap h c else 0)
        cases member : part h
        · rfl
        · exact (full h present member).1
    have gives : (total (L.present t) fun h => bif part h then L'.give t h c else 0) = 0 :=
      (total_congr_on fun h present => by
        show (bif part h then L'.give t h c else 0) = 0
        cases member : part h
        · rfl
        · exact (full h present member).2).trans (total_zero (L.present t))
    have taken := acts.taken_eq c
    have given := acts.given_eq c
    rw [takes] at taken
    rw [gives, Nat.add_zero] at given
    refine Or.inr ?_
    rw [Nat.add_assoc, ← taken, ← given]
    exact balances c

/-- An optimum among the outcomes open to the part is an optimum above the floor nothing. -/
theorem above_nothing {o : C → Nat}
    (optimum : Frontier (L.Outcome part l cap (ds ++ rest) t) better o) :
    Frontier (Above L part l cap ds rest t fun _ => 0) better o :=
  ⟨⟨optimum.1, fun _ _ => Nat.zero_le _⟩, fun b eligible => optimum.2 b eligible.1⟩

/-- **Every optimum stands beyond at what the rest leaves less the part's capacity.** Among the
outcomes open to a part, every optimum of every order rising with the family stands at each
condition beyond at the level before, with what the rest gives and less what the rest takes,
less the part's whole capacity there, or at nothing. -/
theorem optimum_beyond [DecidableEq F] [DecidableEq C] (distinct : Distinct (L.present t))
    (cdistinct : Distinct (ds ++ rest)) (apart : ∀ c, c ∈ rest → ¬ c ∈ ds) {d : C}
    (inside : d ∈ ds) (rising : Rising ds better) {o : C → Nat}
    (optimum : Frontier (L.Outcome part l cap (ds ++ rest) t) better o) {c : C} (mem : c ∈ rest) :
    o c = l c + L.restGiven part t c - L.restTaken part t c - L.capacity part cap t c :=
  match Above.floor_or_full distinct cdistinct apart inside rising (above_nothing optimum) mem with
  | .inr full => by
    rw [← full, Naturals.sub_sub, Nat.add_assoc, Naturals.add_sub_cancel]
  | .inl nothing => by
    have nothing : o c = 0 := nothing
    obtain ⟨L', acts, balances⟩ := optimum.1
    have reach : l c + L.restGiven part t c ≤ L.restTaken part t c + L.capacity part cap t c :=
      calc l c + L.restGiven part t c
          ≤ l c + L'.given t c := Nat.add_le_add_left (by
            rw [acts.given_eq c]
            exact Nat.le_add_right _ _) _
        _ = o c + L'.taken t c := (balances c).symm
        _ = L'.taken t c := by rw [nothing, Nat.zero_add]
        _ ≤ L.restTaken part t c + L.capacity part cap t c := by
            rw [acts.taken_eq c]
            exact Nat.add_le_add_left (acts.part_taken_le c) _
    rw [nothing, Naturals.sub_sub, sub_eq_zero_of_le reach]

/-- **No drive where no units are shared.** At a condition beyond from which no member of the
part taking part may take, every optimum among the outcomes open to the part stands where the
rest leaves it. -/
theorem optimum_untouched [DecidableEq F] [DecidableEq C] (distinct : Distinct (L.present t))
    (cdistinct : Distinct (ds ++ rest)) (apart : ∀ c, c ∈ rest → ¬ c ∈ ds) {d : C}
    (inside : d ∈ ds) (rising : Rising ds better) {o : C → Nat}
    (optimum : Frontier (L.Outcome part l cap (ds ++ rest) t) better o) {c : C} (mem : c ∈ rest)
    (none : ∀ h, h ∈ L.present t → part h = true → cap h c = 0) :
    o c = l c + L.restGiven part t c - L.restTaken part t c :=
  (optimum_beyond distinct cdistinct apart inside rising optimum mem).trans
    (congrArg (_ - ·) (capacity_eq_zero none))

/-- **The drain, exactly where units are shared.** Every optimum among the outcomes open to a
part lowers a condition beyond below where the rest leaves it exactly where the part has some
capacity there and the rest leaves something there. -/
theorem optimum_lowers_iff [DecidableEq F] [DecidableEq C] (distinct : Distinct (L.present t))
    (cdistinct : Distinct (ds ++ rest)) (apart : ∀ c, c ∈ rest → ¬ c ∈ ds) {d : C}
    (inside : d ∈ ds) (rising : Rising ds better) {o : C → Nat}
    (optimum : Frontier (L.Outcome part l cap (ds ++ rest) t) better o) {c : C} (mem : c ∈ rest) :
    o c < l c + L.restGiven part t c - L.restTaken part t c ↔
      0 < L.capacity part cap t c ∧ 0 < l c + L.restGiven part t c - L.restTaken part t c :=
  Eq.subst (motive := fun y => y < l c + L.restGiven part t c - L.restTaken part t c ↔
      0 < L.capacity part cap t c ∧ 0 < l c + L.restGiven part t c - L.restTaken part t c)
    (optimum_beyond distinct cdistinct apart inside rising optimum mem).symm
    (sub_lt_self_iff _ _)

end Optimum

namespace Web

open Flow

variable {L : Flow F C} {part : F → Bool} {cap : F → C → Nat} {t : Nat} {ds rest : List C}
  {better : (C → Nat) → (C → Nat) → Prop}

/-- **An optimum breaks a dependence beyond exactly where its need exceeds what the rest leaves
less the part's capacity.** Where the levels after the step are an optimum, among the outcomes
open to a part, of an order rising with the family, and each condition beyond is depended on at a
need it meets, a dependence beyond is broken across the step exactly where its need exceeds the
level before, with what the rest gives and less what it takes, less the part's capacity there. -/
theorem optimum_broken_iff_capacity [DecidableEq F] [DecidableEq C] {W : Web F C} {dep : C → F}
    (distinct : Distinct (L.present t)) (cdistinct : Distinct (ds ++ rest))
    (apart : ∀ c, c ∈ rest → ¬ c ∈ ds) {d : C} (inside : d ∈ ds) (rising : Optimum.Rising ds better)
    (optimum : Frontier (L.Outcome part (W.level t) cap (ds ++ rest) t) better (W.level (t + 1)))
    (met : W.MetOn dep rest t) {c : C} (mem : c ∈ rest) :
    W.Broken t (dep c) c ↔
      W.level t c + L.restGiven part t c - L.restTaken part t c - L.capacity part cap t c <
        W.need t (dep c) c :=
  have at_ := Optimum.optimum_beyond distinct cdistinct apart inside rising optimum mem
  ⟨fun broken => Eq.subst (motive := fun y => y < W.need t (dep c) c) at_ broken.2.2,
   fun below => ⟨(met c mem).1, (met c mem).2,
     Eq.subst (motive := fun y => y < W.need t (dep c) c) at_.symm below⟩⟩

end Web

namespace Optimum

namespace Drain

open Diversion DrawnBeyond

/-- Equality of formations is decided. -/
instance : DecidableEq Formation
  | .taker, .taker => isTrue rfl
  | .dweller, .dweller => isTrue rfl
  | .taker, .dweller => isFalse fun same => nomatch same
  | .dweller, .taker => isFalse fun same => nomatch same

/-- The part: the taker. -/
def takerPart : Formation → Bool
  | .taker => true
  | .dweller => false

/-- The taker may take `k` from the source and nothing from the store. -/
def takerCap (k : Nat) : Formation → Place → Nat
  | .taker, .source => k
  | .taker, .store => 0
  | .dweller, _ => 0

/-- The taker takes `k` units of the source and gives them to the store; the dweller exchanges
nothing. -/
def drawing (k : Nat) : Flow Formation Place where
  present _ := [.taker, .dweller]
  take _ f c := match f, c with
    | .taker, .source => k
    | .taker, .store => 0
    | .dweller, _ => 0
  give _ f c := match f, c with
    | .taker, .store => k
    | .taker, .source => 0
    | .dweller, _ => 0

/-- Two units at the source and nothing in the store. -/
def before : Place → Nat
  | .source => 2
  | .store => 0

/-- The source less `k`, the store at `k`. -/
def drawnTo (k : Nat) : Place → Nat
  | .source => 2 - k
  | .store => k

/-- The levels: `before` at the start, `drawnTo k` after. -/
def drawnLevel (k : Nat) : Nat → Place → Nat
  | 0 => before
  | _ + 1 => drawnTo k

/-- The taker and the dweller, without repetition. -/
theorem formations_distinct : Distinct [Formation.taker, Formation.dweller] :=
  show ¬ Formation.taker ∈ [Formation.dweller] ∧ (¬ Formation.dweller ∈ ([] : List Formation) ∧ True)
    from ⟨fun mem => (match mem_cons_cases mem with
    | .inl same => nomatch same
    | .inr mem => nomatch mem), fun mem => (nomatch mem), trivial⟩

/-- The store and the source, without repetition. -/
theorem store_source_distinct : Distinct ([Place.store] ++ [Place.source]) :=
  show ¬ Place.store ∈ [Place.source] ∧ (¬ Place.source ∈ ([] : List Place) ∧ True) from
  ⟨fun mem => (match mem_cons_cases mem with
    | .inl same => nomatch same
    | .inr mem => nomatch mem), fun mem => (nomatch mem), trivial⟩

/-- The taker drawing `k` acts within its capacity `k`. -/
theorem drawing_within (k : Nat) :
    (drawing k).ActsWithin takerPart (takerCap k) ([Place.store] ++ [Place.source]) 0
      (drawing k) :=
  ⟨rfl, fun _ _ _ => ⟨rfl, rfl⟩,
   fun h c member => match h, c, member with
    | .taker, .source, _ => Nat.le_refl k
    | .taker, .store, _ => Nat.le_refl 0,
   fun h c _ outside => match h, c with
    | .taker, .store => absurd (.head _) outside
    | .taker, .source => rfl
    | .dweller, _ => rfl,
   fun h member => match h, member with
    | .taker, _ => Nat.le_of_eq ((Nat.add_zero (k + 0)).trans (Nat.add_comm k 0))⟩

/-- **Within capacity `k` of two, the taker's drawing is an optimum of the store's order.**
Every outcome open to the taker leaves the store at most `k`: the taker gives the family no
more than it takes, and takes at most `k`, from the source alone. -/
theorem drawing_optimum {k : Nat} (within : k ≤ 2) :
    Frontier ((drawing k).Outcome takerPart before (takerCap k) ([Place.store] ++ [Place.source]) 0)
      storeOrder (drawnTo k) :=
  ⟨⟨drawing k, drawing_within k, fun c => match c with
      | .source => Naturals.sub_add_cancel within
      | .store => (Nat.add_zero k).trans (Nat.zero_add k).symm⟩,
   fun o ⟨L', acts, balances⟩ above => by
    have store : o .store + L'.taken 0 .store = 0 + L'.given 0 .store := balances .store
    have gives : L'.given 0 .store = L'.give 0 .taker .store + (L'.give 0 .dweller .store + 0) :=
      congrArg (fun ps => total ps fun f => L'.give 0 f .store) acts.1
    have dweller : L'.give 0 .dweller .store = 0 := (acts.2.1 .dweller .store rfl).2
    have conserved : L'.give 0 .taker .store + (L'.give 0 .taker .source + 0) ≤
        L'.take 0 .taker .store + (L'.take 0 .taker .source + 0) := acts.2.2.2.2 .taker rfl
    have fromStore : L'.take 0 .taker .store ≤ 0 := acts.2.2.1 .taker .store rfl
    have fromSource : L'.take 0 .taker .source ≤ k := acts.2.2.1 .taker .source rfl
    have atMost : o .store ≤ k :=
      calc o .store ≤ o .store + L'.taken 0 .store := Nat.le_add_right _ _
        _ = L'.given 0 .store := store.trans (Nat.zero_add _)
        _ = L'.give 0 .taker .store := by rw [gives, dweller]; rfl
        _ ≤ L'.give 0 .taker .store + (L'.give 0 .taker .source + 0) := Nat.le_add_right _ _
        _ ≤ L'.take 0 .taker .store + (L'.take 0 .taker .source + 0) := conserved
        _ ≤ 0 + (k + 0) := Nat.add_le_add fromStore (Nat.add_le_add_right fromSource 0)
        _ = k := Nat.zero_add k
    exact Nat.not_le_of_gt above atMost⟩

/-- **The dweller's dependence breaks exactly where the taker shares units with the source.**
Within capacity `k` of two, at the store's optimum the dweller's dependence on the source, at
need two, is broken across the first step exactly where the taker may take something from the
source; derived from `Web.optimum_broken_iff_capacity`. -/
theorem drawing_broken_iff {k : Nat} (within : k ≤ 2) :
    (Diversion.web (drawnLevel k)).Broken 0 .dweller .source ↔ 0 < k :=
  (Web.optimum_broken_iff_capacity (W := Diversion.web (drawnLevel k)) (dep := dwellerOn)
    (ds := [Place.store]) (rest := [Place.source]) formations_distinct store_source_distinct
    source_apart (.head []) storeOrder_rising (drawing_optimum within)
    (met_source (drawnLevel k) 0 (Nat.le_refl 2)) (.head [])).trans
    ((sub_lt_self_iff 2 k).trans ⟨fun both => both.1, fun positive => ⟨positive, by decide⟩⟩)

end Drain

end Optimum

/-! ## Several optimizers at once

Above, one part optimizes and the formations outside it exchange as they do. Here several
formations optimize at once, each alone, by its own order rising with its own family, and each
one's step is an optimum among the outcomes open to it, the others exchanging as they do in the
step that happened: a mutual best response. At a condition beyond every optimizer's family the
levels after the step are then exact: what the formations outside every optimizer leave there,
less the optimizers' joint capacity there, or nothing. -/

namespace Optimum

open Flow

/-- One formation as a part. -/
def alone [DecidableEq F] (h : F) : F → Bool := fun g => decide (g = h)

/-- A formation is the one part it forms alone. -/
theorem alone_self [DecidableEq F] (h : F) : alone h h = true :=
  decide_eq_true rfl

/-- **A mutual best response.** Across the step from `t`, each optimizer taking part acts within
its capacity in `L`, and the levels `o` are an optimum of its order among the outcomes open to it
alone, every other formation exchanging as it does in `L`. -/
def MutualBest [DecidableEq F] (L : Flow F C) (optimizer : F → Bool) (l : C → Nat)
    (cap : F → C → Nat) (ds rest : F → List C) (better : F → (C → Nat) → (C → Nat) → Prop)
    (t : Nat) (o : C → Nat) : Prop :=
  ∀ h, h ∈ L.present t → optimizer h = true →
    L.ActsWithin (alone h) cap (ds h ++ rest h) t L ∧
      Frontier (L.Outcome (alone h) l cap (ds h ++ rest h) t) (better h) o

variable {L : Flow F C} {optimizer : F → Bool} {l : C → Nat} {cap : F → C → Nat}
  {ds rest : F → List C} {better : F → (C → Nat) → (C → Nat) → Prop} {t : Nat} {o : C → Nat}

/-- **Restraint is no mutual best response.** Where something stands at a condition beyond an
optimizer's family after a mutual best response, that optimizer takes its whole capacity there and
gives nothing there. -/
theorem MutualBest.full [DecidableEq F] [DecidableEq C] (distinct : Distinct (L.present t))
    (cdistinct : ∀ h, optimizer h = true → Distinct (ds h ++ rest h))
    (apart : ∀ h, optimizer h = true → ∀ c, c ∈ rest h → ¬ c ∈ ds h)
    (inside : ∀ h, optimizer h = true → ∃ d, d ∈ ds h)
    (rising : ∀ h, optimizer h = true → Rising (ds h) (better h))
    (best : MutualBest L optimizer l cap ds rest better t o)
    (balances : ∀ x, o x + L.taken t x = l x + L.given t x) {h : F}
    (present : h ∈ L.present t) (opt : optimizer h = true) {c : C} (mem : c ∈ rest h)
    (positive : 0 < o c) : L.take t h c = cap h c ∧ L.give t h c = 0 :=
  (inside h opt).elim fun _ there =>
    Above.full distinct (cdistinct h opt) (apart h opt) there (rising h opt)
      (above_nothing (best h present opt).2) (best h present opt).1 balances mem positive
      present (alone_self h)

/-- **Several optimizers beyond, exactly.** After a mutual best response, at a condition beyond
every optimizer's family, the levels stand at the level before, with what the formations outside
every optimizer give and less what they take, less the optimizers' joint capacity there, or at
nothing. Where nothing stands, balance and capacity alone give it; where something stands, every
optimizer takes its whole capacity there and gives nothing. -/
theorem mutual_beyond [DecidableEq F] [DecidableEq C] (distinct : Distinct (L.present t))
    (cdistinct : ∀ h, optimizer h = true → Distinct (ds h ++ rest h))
    (apart : ∀ h, optimizer h = true → ∀ c, c ∈ rest h → ¬ c ∈ ds h)
    (inside : ∀ h, optimizer h = true → ∃ d, d ∈ ds h)
    (rising : ∀ h, optimizer h = true → Rising (ds h) (better h))
    (best : MutualBest L optimizer l cap ds rest better t o)
    (balances : ∀ x, o x + L.taken t x = l x + L.given t x) {c : C}
    (beyond : ∀ h, h ∈ L.present t → optimizer h = true → c ∈ rest h) :
    o c = l c + L.restGiven optimizer t c - L.restTaken optimizer t c -
      L.capacity optimizer cap t c :=
  have taken := total_split optimizer (fun h => L.take t h c) (L.present t)
  have given := total_split optimizer (fun h => L.give t h c) (L.present t)
  match Nat.eq_zero_or_pos (o c) with
  | .inl nothing => by
    have within : (total (L.present t) fun h => bif optimizer h then L.take t h c else 0) ≤
        L.capacity optimizer cap t c :=
      total_le _ fun h present => by
        show (bif optimizer h then L.take t h c else 0) ≤ (bif optimizer h then cap h c else 0)
        cases opt : optimizer h
        · exact Nat.le_refl 0
        · exact (best h present opt).1.2.2.1 h c (alone_self h)
    have reach : l c + L.restGiven optimizer t c ≤
        L.restTaken optimizer t c + L.capacity optimizer cap t c :=
      calc l c + L.restGiven optimizer t c
          ≤ l c + L.given t c := Nat.add_le_add_left (by
            rw [show L.given t c = _ from given]
            exact Nat.le_add_right _ _) _
        _ = o c + L.taken t c := (balances c).symm
        _ = L.taken t c := by rw [nothing, Nat.zero_add]
        _ ≤ L.restTaken optimizer t c + L.capacity optimizer cap t c := by
            rw [show L.taken t c = _ from taken]
            exact Nat.add_le_add_left within _
    rw [nothing, Naturals.sub_sub, sub_eq_zero_of_le reach]
  | .inr positive => by
    have takes : (total (L.present t) fun h => bif optimizer h then L.take t h c else 0) =
        L.capacity optimizer cap t c :=
      total_congr_on fun h present => by
        show (bif optimizer h then L.take t h c else 0) = (bif optimizer h then cap h c else 0)
        cases opt : optimizer h
        · rfl
        · exact (MutualBest.full distinct cdistinct apart inside rising best balances present opt
            (beyond h present opt) positive).1
    have gives : (total (L.present t) fun h => bif optimizer h then L.give t h c else 0) = 0 :=
      (total_congr_on fun h present => by
        show (bif optimizer h then L.give t h c else 0) = 0
        cases opt : optimizer h
        · rfl
        · exact (MutualBest.full distinct cdistinct apart inside rising best balances present opt
            (beyond h present opt) positive).2).trans (total_zero (L.present t))
    have full : o c + L.restTaken optimizer t c + L.capacity optimizer cap t c =
        l c + L.restGiven optimizer t c := by
      have step := balances c
      rw [show L.taken t c = _ from taken, show L.given t c = _ from given, takes, gives,
        Nat.add_zero, ← Nat.add_assoc] at step
      exact step
    rw [← full, Naturals.sub_sub, Nat.add_assoc, Naturals.add_sub_cancel]

/-- **Several optimizers leave the beyond where one with their joint capacity would.** At a
condition beyond every optimizer's family, the levels after a mutual best response stand where
every optimum of one part made of all the optimizers, of any order rising with any family apart
from that condition, would leave them. -/
theorem mutual_as_one [DecidableEq F] [DecidableEq C] (distinct : Distinct (L.present t))
    (cdistinct : ∀ h, optimizer h = true → Distinct (ds h ++ rest h))
    (apart : ∀ h, optimizer h = true → ∀ c, c ∈ rest h → ¬ c ∈ ds h)
    (inside : ∀ h, optimizer h = true → ∃ d, d ∈ ds h)
    (rising : ∀ h, optimizer h = true → Rising (ds h) (better h))
    (best : MutualBest L optimizer l cap ds rest better t o)
    (balances : ∀ x, o x + L.taken t x = l x + L.given t x) {c : C}
    (beyond : ∀ h, h ∈ L.present t → optimizer h = true → c ∈ rest h)
    {dsJ restJ : List C} (cdistinctJ : Distinct (dsJ ++ restJ))
    (apartJ : ∀ c, c ∈ restJ → ¬ c ∈ dsJ) {dJ : C} (insideJ : dJ ∈ dsJ)
    {betterJ : (C → Nat) → (C → Nat) → Prop} (risingJ : Rising dsJ betterJ) {o' : C → Nat}
    (optimum : Frontier (L.Outcome optimizer l cap (dsJ ++ restJ) t) betterJ o')
    (memJ : c ∈ restJ) : o c = o' c :=
  (mutual_beyond distinct cdistinct apart inside rising best balances beyond).trans
    (optimum_beyond distinct cdistinctJ apartJ insideJ risingJ optimum memJ).symm

/-- **Lowered exactly where the optimizers can take.** After a mutual best response, a condition
beyond every optimizer's family stands below where the formations outside every optimizer leave it
exactly where the optimizers have some capacity there and something is left there. -/
theorem mutual_lowers_iff [DecidableEq F] [DecidableEq C] (distinct : Distinct (L.present t))
    (cdistinct : ∀ h, optimizer h = true → Distinct (ds h ++ rest h))
    (apart : ∀ h, optimizer h = true → ∀ c, c ∈ rest h → ¬ c ∈ ds h)
    (inside : ∀ h, optimizer h = true → ∃ d, d ∈ ds h)
    (rising : ∀ h, optimizer h = true → Rising (ds h) (better h))
    (best : MutualBest L optimizer l cap ds rest better t o)
    (balances : ∀ x, o x + L.taken t x = l x + L.given t x) {c : C}
    (beyond : ∀ h, h ∈ L.present t → optimizer h = true → c ∈ rest h) :
    o c < l c + L.restGiven optimizer t c - L.restTaken optimizer t c ↔
      0 < L.capacity optimizer cap t c ∧
        0 < l c + L.restGiven optimizer t c - L.restTaken optimizer t c :=
  Eq.subst (motive := fun y => y < l c + L.restGiven optimizer t c - L.restTaken optimizer t c ↔
      0 < L.capacity optimizer cap t c ∧
        0 < l c + L.restGiven optimizer t c - L.restTaken optimizer t c)
    (mutual_beyond distinct cdistinct apart inside rising best balances beyond).symm
    (sub_lt_self_iff _ _)

end Optimum

namespace Web

open Flow Optimum

/-- **Several optimizers break a dependence beyond exactly where its need exceeds what the rest
leaves less their joint capacity.** Where the levels after the step are a mutual best response and
a condition beyond every optimizer's family is depended on at a need it meets, the dependence is
broken across the step exactly where its need exceeds the level before, with what the formations
outside every optimizer give and less what they take, less the optimizers' joint capacity. -/
theorem mutual_broken_iff_capacity [DecidableEq F] [DecidableEq C] {W : Web F C} {L : Flow F C}
    {optimizer : F → Bool} {cap : F → C → Nat} {ds rest : F → List C}
    {better : F → (C → Nat) → (C → Nat) → Prop} {t : Nat} {g : F} {c : C}
    (distinct : Distinct (L.present t))
    (cdistinct : ∀ h, optimizer h = true → Distinct (ds h ++ rest h))
    (apart : ∀ h, optimizer h = true → ∀ c, c ∈ rest h → ¬ c ∈ ds h)
    (inside : ∀ h, optimizer h = true → ∃ d, d ∈ ds h)
    (rising : ∀ h, optimizer h = true → Rising (ds h) (better h))
    (best : MutualBest L optimizer (W.level t) cap ds rest better t (W.level (t + 1)))
    (balances : ∀ x, W.level (t + 1) x + L.taken t x = W.level t x + L.given t x)
    (beyond : ∀ h, h ∈ L.present t → optimizer h = true → c ∈ rest h)
    (depends : W.requires t g c) (meets : W.need t g c ≤ W.level t c) :
    W.Broken t g c ↔
      W.level t c + L.restGiven optimizer t c - L.restTaken optimizer t c -
        L.capacity optimizer cap t c < W.need t g c :=
  have at_ := mutual_beyond distinct cdistinct apart inside rising best balances beyond
  ⟨fun broken => Eq.subst (motive := fun y => y < W.need t g c) at_ broken.2.2,
   fun below => ⟨depends, meets, Eq.subst (motive := fun y => y < W.need t g c) at_.symm below⟩⟩

end Web

namespace Optimum

namespace TwoTakers

open Diversion

/-- Two takers and a dweller. -/
inductive Member where
  | taker (which : Bool)
  | dweller

/-- Equality of members is decided. -/
instance : DecidableEq Member
  | .taker true, .taker true => isTrue rfl
  | .taker false, .taker false => isTrue rfl
  | .taker true, .taker false => isFalse fun same => nomatch same
  | .taker false, .taker true => isFalse fun same => nomatch same
  | .dweller, .dweller => isTrue rfl
  | .taker _, .dweller => isFalse fun same => nomatch same
  | .dweller, .taker _ => isFalse fun same => nomatch same

/-- The optimizers: the two takers. -/
def takers : Member → Bool
  | .taker _ => true
  | .dweller => false

/-- Each taker may take one unit of the source and nothing of the store; the dweller nothing. -/
def capOf : Member → Place → Nat
  | .taker _, .source => 1
  | .taker _, .store => 0
  | .dweller, _ => 0

/-- What each taker gives: one unit to the store. -/
def giveOf : Member → Place → Nat
  | .taker _, .store => 1
  | .taker _, .source => 0
  | .dweller, _ => 0

/-- Both takers take one unit of the source and give it to the store. -/
def joint : Flow Member Place where
  present _ := [.taker true, .taker false, .dweller]
  take _ := capOf
  give _ := giveOf

/-- The second taker takes and gives as in `joint`; the first takes nothing. -/
def restrained : Flow Member Place where
  present _ := [.taker true, .taker false, .dweller]
  take _ f c := match f with
    | .taker true => 0
    | .taker false => capOf (.taker false) c
    | .dweller => 0
  give _ f c := match f with
    | .taker true => 0
    | .taker false => giveOf (.taker false) c
    | .dweller => 0

/-- After both takers draw: the source empty, the store at two. -/
def drained : Place → Nat
  | .source => 0
  | .store => 2

/-- After the second alone draws: one unit in each. -/
def kept : Place → Nat
  | .source => 1
  | .store => 1

/-- The members, without repetition. -/
theorem members_distinct :
    Distinct [Member.taker true, Member.taker false, Member.dweller] :=
  show ¬ Member.taker true ∈ [Member.taker false, Member.dweller] ∧
      (¬ Member.taker false ∈ [Member.dweller] ∧ (¬ Member.dweller ∈ ([] : List Member) ∧ True))
    from ⟨fun mem => (match mem_cons_cases mem with
      | .inl same => nomatch same
      | .inr mem => match mem_cons_cases mem with
        | .inl same => nomatch same
        | .inr mem => nomatch mem),
     fun mem => (match mem_cons_cases mem with
      | .inl same => nomatch same
      | .inr mem => nomatch mem),
     fun mem => (nomatch mem), trivial⟩

/-- Each taker acts within its capacity in `joint`. -/
theorem joint_within (w : Bool) :
    joint.ActsWithin (alone (Member.taker w)) capOf ([Place.store] ++ [Place.source]) 0 joint :=
  ⟨rfl, fun _ _ _ => ⟨rfl, rfl⟩, fun _ _ _ => Nat.le_refl _,
   fun _ c _ outside => match c with
    | .store => absurd (.head _) outside
    | .source => absurd (.tail _ (.head _)) outside,
   fun g member => match g, member with
    | .taker _, _ => Nat.le_refl 1
    | .dweller, member => absurd (of_decide_eq_true member) fun same => nomatch same⟩

/-- `joint` balances from `Drain.before` into `drained`. -/
theorem joint_balances : ∀ x, drained x + joint.taken 0 x = Drain.before x + joint.given 0 x
  | .source => rfl
  | .store => rfl

/-- Under a step within a taker's capacity, it gives the store at most one unit. -/
theorem gives_at_most_one {w : Bool} {L' : Flow Member Place}
    (acts : joint.ActsWithin (alone (Member.taker w)) capOf ([Place.store] ++ [Place.source]) 0 L') :
    L'.give 0 (.taker w) .store ≤ 1 :=
  have conserved : L'.give 0 (.taker w) .store + (L'.give 0 (.taker w) .source + 0) ≤
      L'.take 0 (.taker w) .store + (L'.take 0 (.taker w) .source + 0) :=
    acts.2.2.2.2 (.taker w) (alone_self _)
  have fromStore : L'.take 0 (.taker w) .store ≤ 0 := acts.2.2.1 (.taker w) .store (alone_self _)
  have fromSource : L'.take 0 (.taker w) .source ≤ 1 :=
    acts.2.2.1 (.taker w) .source (alone_self _)
  Nat.le_trans (Nat.le_add_right _ _) (Nat.le_trans conserved
    (Nat.le_trans (Nat.add_le_add fromStore (Nat.add_le_add_right fromSource 0))
      (Nat.le_refl 1)))

/-- **Each taker's draw is an optimum of the store's order, given the other's.** Every outcome open
to one taker alone, the other taking and giving as in `joint`, leaves the store at most two. -/
theorem joint_optimum (w : Bool) :
    Frontier (joint.Outcome (alone (Member.taker w)) Drain.before capOf
      ([Place.store] ++ [Place.source]) 0) Drain.storeOrder drained :=
  ⟨⟨joint, joint_within w, joint_balances⟩,
   fun o ⟨L', acts, balances⟩ above => by
    have store : o .store + L'.taken 0 .store = 0 + L'.given 0 .store := balances .store
    have gives : L'.given 0 .store = L'.give 0 (.taker true) .store +
        (L'.give 0 (.taker false) .store + (L'.give 0 .dweller .store + 0)) :=
      congrArg (fun ps => total ps fun f => L'.give 0 f .store) acts.1
    have dweller : L'.give 0 .dweller .store = 0 := (acts.2.1 .dweller .store rfl).2
    have atMost : L'.given 0 .store ≤ 2 := by
      rw [gives, dweller]
      cases w with
      | true =>
        rw [(acts.2.1 (.taker false) .store rfl).2]
        exact Nat.add_le_add_right (gives_at_most_one acts) _
      | false =>
        rw [(acts.2.1 (.taker true) .store rfl).2]
        exact Nat.add_le_add_left (Nat.add_le_add_right (gives_at_most_one acts) _) _
    exact Nat.not_le_of_gt above (Nat.le_trans (Nat.le_add_right _ _)
      (Nat.le_trans (Nat.le_of_eq (store.trans (Nat.zero_add _))) atMost))⟩

/-- **Both takers drawing is a mutual best response.** -/
theorem joint_best :
    MutualBest joint takers Drain.before capOf (fun _ => [Place.store]) (fun _ => [Place.source])
      (fun _ => Drain.storeOrder) 0 drained :=
  fun h _ opt => match h, opt with
    | .taker w, _ => ⟨joint_within w, joint_optimum w⟩

/-- The hypotheses on the takers' lists and orders. -/
theorem lists :
    (∀ h, takers h = true → Distinct ([Place.store] ++ [Place.source])) ∧
      (∀ h, takers h = true → ∀ c, c ∈ [Place.source] → ¬ c ∈ [Place.store]) ∧
      (∀ h, takers h = true → ∃ d, d ∈ [Place.store]) ∧
      (∀ h, takers h = true → Rising [Place.store] Drain.storeOrder) :=
  ⟨fun _ _ => Drain.store_source_distinct, fun _ _ => DrawnBeyond.source_apart,
   fun _ _ => ⟨_, .head []⟩, fun _ _ => Drain.storeOrder_rising⟩

/-- **The source falls by the takers' joint capacity, to nothing.** Derived from `mutual_beyond`:
the source stood at two, the dweller neither gives nor takes there, and the takers' joint capacity
there is two. -/
theorem joint_drains : drained .source = Drain.before .source - joint.capacity takers capOf 0 .source ∧
    joint.capacity takers capOf 0 .source = 2 :=
  ⟨mutual_beyond (ds := fun _ => [Place.store]) (rest := fun _ => [Place.source])
    members_distinct lists.1 lists.2.1 lists.2.2.1 lists.2.2.2 joint_best joint_balances
    (fun _ _ _ => .head []), rfl⟩

/-- **Each take is within the slack of a need of one; together they fall below it.** Each taker
takes one unit, leaving the source at the need of one or above were it alone, and the mutual best
response leaves the source below that need. -/
theorem within_slack_jointly_below :
    (∀ w, joint.take 0 (.taker w) .source + 1 ≤ Drain.before .source) ∧ drained .source < 1 :=
  ⟨fun _ => Nat.le_refl 2, Nat.succ_pos 0⟩

/-- `restrained` balances from `Drain.before` into `kept`. -/
theorem restrained_balances :
    ∀ x, kept x + restrained.taken 0 x = Drain.before x + restrained.given 0 x
  | .source => rfl
  | .store => rfl

/-- **One taker's restraint is no mutual best response.** Where the first taker takes nothing and
the second draws, a unit stands at the source, so the first does not take its whole capacity there:
whatever the orders, families and listings, the step is no mutual best response. -/
theorem restrained_not_mutual :
    ¬ MutualBest restrained takers Drain.before capOf (fun _ => [Place.store])
      (fun _ => [Place.source]) (fun _ => Drain.storeOrder) 0 kept := fun best =>
  absurd (MutualBest.full (L := restrained) (ds := fun _ => [Place.store])
    (rest := fun _ => [Place.source]) members_distinct lists.1 lists.2.1 lists.2.2.1 lists.2.2.2
    best restrained_balances (h := .taker true) (.head _) rfl (.head [])
    (Nat.succ_pos 0)).1 fun same => nomatch same

end TwoTakers

end Optimum

/-! ## A course of steps

Above, one step. Here a part chooses again at every step of a course: at each, the levels after
are an optimum of its order among the outcomes open to it from the levels before, the formations
outside it exchanging as they do in that step. At a condition beyond, each step's level is read off
the one before by the law of one step: the level with what the rest gives, less what the rest takes
and the part's capacity, or nothing. Where what the rest gives there is at most `r` a step,
however low the level, a draw above `r` brings it below any positive need `m` once the steps
exceed its starting excess over `m`, and for good, and a dependence at that need is lost; where it
renews by exactly `r` while it stands at the need, a draw of `k` keeps it there exactly where
`k ≤ r`. Over `n` steps no course draws more than the starting level with `r` for each step. What
the renewal does below the need decides only what is drawn: where it stops below the need (a
gate), a draw above the renewal draws at most the starting level with `r` for each of its units,
however long the course; where at least one is given at every step, however low the level, the
draw has no bound, everything given drawn and the dependence lost all the same. A draw of
`k ≤ r` draws `k` at every step. -/

namespace Optimum

/-! ### Levels renewed and drawn

A level `x` along a course, `g t` given to it and `d t` taken from it at the step from `t`, each
step taking at most what stands with what is given: `x (t + 1) = x t + g t - d t`. -/

section Levels

variable {x g d : Nat → Nat} {r m : Nat}

/-- Less the same amount keeps the order (as `Nat.sub_le_sub_right`, with an empty axiom
report). -/
theorem sub_le_sub_right_of_le {n k : Nat} (le : n ≤ k) : ∀ a, n - a ≤ k - a
  | 0 => le
  | a + 1 => Nat.pred_le_pred (sub_le_sub_right_of_le le a)

/-- Less more is at most less less (as `Nat.sub_le_sub_left`, with an empty axiom report). -/
theorem sub_le_sub_left_of_le {a b : Nat} (le : a ≤ b) (n : Nat) : n - b ≤ n - a :=
  match le_dest le with
  | ⟨j, same⟩ => Eq.subst (motive := fun y => n - y ≤ n - a) same.symm
      (Nat.le_trans (Nat.le_of_eq (Naturals.sub_sub n a j).symm) (Nat.sub_le (n - a) j))

/-- **Above the renewal, the level never rises.** Where at most `r` is given and more than `r`
taken at a step, the level after is at most the level before. -/
theorem never_rises (step : ∀ t, x (t + 1) = x t + g t - d t) {t : Nat} (renews : g t ≤ r)
    (over : r < d t) : x (t + 1) ≤ x t := by
  rw [step t]
  exact Nat.le_trans (sub_le_sub_left_of_le (Nat.le_trans renews (Nat.le_of_lt over)) _)
    (Nat.le_of_eq (Naturals.add_sub_cancel _ _))

/-- **Above the renewal, below the need the level stays below.** Where at most `r` is given and
more than `r` taken at every step, a level below the need at one step is below it at every later
step, whatever is given below the need. -/
theorem level_stays_below (step : ∀ t, x (t + 1) = x t + g t - d t) (renews : ∀ t, g t ≤ r)
    (over : ∀ t, r < d t) {s : Nat} (below : x s < m) : ∀ j, x (s + j) < m
  | 0 => below
  | j + 1 => Nat.lt_of_le_of_lt (never_rises step (renews (s + j)) (over (s + j)))
      (level_stays_below step renews over below j)

/-- Above the renewal, the level stays within its start. -/
theorem level_le_start (step : ∀ t, x (t + 1) = x t + g t - d t) (renews : ∀ t, g t ≤ r)
    (over : ∀ t, r < d t) : ∀ t, x t ≤ x 0
  | 0 => Nat.le_refl _
  | t + 1 => Nat.le_trans (never_rises step (renews t) (over t)) (level_le_start step renews over t)

/-- **Above the renewal, a positive level falls.** Where at most `r` is given and more than `r`
taken at a step, a positive level falls by at least one across it. -/
theorem falls_over (step : ∀ t, x (t + 1) = x t + g t - d t) {t : Nat} (renews : g t ≤ r)
    (over : r < d t) (positive : 0 < x t) : x (t + 1) + 1 ≤ x t :=
  calc x (t + 1) + 1 = x t + g t - d t + 1 := by rw [step t]
    _ ≤ x t + r - (r + 1) + 1 :=
        Nat.add_le_add_right (Nat.le_trans (sub_le_sub_right_of_le (Nat.add_le_add_left renews _) _)
          (sub_le_sub_left_of_le over _)) 1
    _ = x t := by
        rw [← Naturals.sub_sub, Naturals.add_sub_cancel,
          Naturals.sub_add_cancel (c := 1) positive]

/-- **Above the renewal, the level falls below any need, within its starting excess over it.**
Where at every step at most `r` is given, however low the level, and more than `r` is taken, the
level stands below a positive need `m` at every step `t` with `x 0 < m + t`, so at every step from
`x 0` on. -/
theorem ends_within (step : ∀ t, x (t + 1) = x t + g t - d t) (renews : ∀ t, g t ≤ r)
    (over : ∀ t, r < d t) (needs : 0 < m) :
    ∀ t, x 0 < m + t → x t < m :=
  have falling : ∀ t, x t = 0 ∨ x t + t ≤ x 0 := fun t => by
    induction t with
    | zero => exact .inr (Nat.le_refl _)
    | succ t ih =>
      match Nat.eq_zero_or_pos (x t) with
      | .inl gone => exact .inl (Nat.eq_zero_of_le_zero
          (Nat.le_trans (never_rises step (renews t) (over t)) (Nat.le_of_eq gone)))
      | .inr positive =>
        match ih with
        | .inl gone => exact (absurd (Eq.subst (motive := fun y => 0 < y) gone positive)
            (Nat.lt_irrefl 0))
        | .inr fell =>
          exact .inr (calc x (t + 1) + (t + 1) = x (t + 1) + 1 + t :=
                (Nat.add_assoc _ _ _).symm.trans (Nat.add_right_comm _ _ _)
            _ ≤ x t + t := Nat.add_le_add_right (falls_over step (renews t) (over t) positive) t
            _ ≤ x 0 := fell)
  fun t within => match falling t with
    | .inl gone => Nat.lt_of_le_of_lt (Nat.le_of_eq gone) needs
    | .inr fell => Nat.lt_of_add_lt_add_right (Nat.lt_of_le_of_lt fell within)

/-- **Within the renewal, the level stays at the need and never falls.** Where exactly `r` is
given while the level stands at the need or above and at most `r` is taken at every step, a level
starting at the need stands at it or above at every step and does not fall across any. -/
theorem kept_at_need (step : ∀ t, x (t + 1) = x t + g t - d t)
    (renewing : ∀ t, m ≤ x t → g t = r) (within : ∀ t, d t ≤ r) (start : m ≤ x 0) :
    ∀ t, m ≤ x t ∧ x t ≤ x (t + 1) :=
  have rises : ∀ t, m ≤ x t → x t ≤ x (t + 1) := fun t atNeed => by
    rw [step t, renewing t atNeed]
    exact Nat.le_trans (Nat.le_of_eq (Naturals.add_sub_cancel _ _).symm)
      (sub_le_sub_left_of_le (within t) _)
  have stands : ∀ t, m ≤ x t := fun t => by
    induction t with
    | zero => exact start
    | succ t ih => exact Nat.le_trans ih (rises t ih)
  fun t => ⟨stands t, rises t (stands t)⟩

/-- What is given at a step is at most `r` where it is `r` at the need or above and nothing
below. -/
theorem renews_of (renewing : ∀ t, m ≤ x t → g t = r)
    (unsupported : ∀ t, x t < m → g t = 0) (t : Nat) : g t ≤ r :=
  match Nat.lt_or_ge (x t) m with
  | .inl below => Nat.le_trans (Nat.le_of_eq (unsupported t below)) (Nat.zero_le r)
  | .inr atNeed => Nat.le_of_eq (renewing t atNeed)

/-- **Kept exactly within the renewal.** Where exactly `r` is given while the level stands at a
positive need `m` or above, at most `r` below it, and `k` is taken at every step, a level starting
at the need stands at it at every step exactly where `k ≤ r`. -/
theorem kept_iff_within (step : ∀ t, x (t + 1) = x t + g t - d t) {k : Nat}
    (renewing : ∀ t, m ≤ x t → g t = r) (renews : ∀ t, g t ≤ r)
    (draws : ∀ t, d t = k) (needs : 0 < m) (start : m ≤ x 0) :
    (∀ t, m ≤ x t) ↔ k ≤ r :=
  ⟨fun kept => match Nat.lt_or_ge r k with
    | .inl over => absurd (kept (x 0)) (Nat.not_le_of_gt (ends_within step renews
        (fun t => Nat.lt_of_lt_of_le over (Nat.le_of_eq (draws t).symm)) needs (x 0)
        (Nat.lt_add_of_pos_left needs)))
    | .inr within => within,
   fun within t => (kept_at_need step renewing (fun t => Nat.le_trans (Nat.le_of_eq (draws t))
      within) start t).1⟩

/-- What the step from `t` takes from a level `x` given `g`: the level with what is given, less
what stands after. -/
def drawnAt (x g : Nat → Nat) (t : Nat) : Nat := x t + g t - x (t + 1)

/-- **What stands and what was drawn.** Where each step leaves at most the level with what is
given, across `n` steps what stands after with everything drawn is the starting level with
everything given (sums of `Amounts.whole`). -/
theorem level_add_drawn_of_within (within : ∀ t, x (t + 1) ≤ x t + g t) :
    ∀ n, x n + Amounts.whole.sum (drawnAt x g) 0 n = x 0 + Amounts.whole.sum g 0 n :=
  fun n => (Amounts.whole_sum (drawnAt x g) n 0).symm ▸ (Amounts.whole_sum g n 0).symm ▸
    Eq.subst (motive := fun k => x k + total (steps 0 n) (drawnAt x g) = x 0 + total (steps 0 n) g)
      (Nat.zero_add n)
      (balance_over_stretch (fun t => Naturals.add_sub_of_le (within t)) 0 n)

/-- **What stands and what was drawn** along a course whose steps take `d`: the case of
`level_add_drawn_of_within`. -/
theorem level_add_drawn (step : ∀ t, x (t + 1) = x t + g t - d t) :
    ∀ n, x n + Amounts.whole.sum (drawnAt x g) 0 n = x 0 + Amounts.whole.sum g 0 n :=
  level_add_drawn_of_within fun t => by rw [step t]; exact Nat.sub_le _ _

/-- A sum of at most `r` at each step is at most `r` for each step. -/
theorem sum_le_mul (renews : ∀ t, g t ≤ r) :
    ∀ n, Amounts.whole.sum g 0 n ≤ r * n
  | 0 => Nat.zero_le _
  | n + 1 => Nat.le_trans
      (Nat.le_of_eq (congrArg (Amounts.whole.sum g 0 n + g ·) (Nat.zero_add n)))
      (Nat.le_trans (Nat.add_le_add (sum_le_mul renews n) (renews n))
        (Nat.le_of_eq (Nat.mul_succ r n).symm))

/-- Where at most `r` is given at each step and nothing from `N` on, the sum over any number of
steps is at most `r` for each step before `N`. -/
theorem sum_le_mul_until {N : Nat} (renews : ∀ t, g t ≤ r)
    (after : ∀ t, N ≤ t → g t = 0) :
    ∀ n, Amounts.whole.sum g 0 n ≤ r * N
  | 0 => Nat.zero_le _
  | n + 1 => match Nat.lt_or_ge n N with
    | .inl before => Nat.le_trans (sum_le_mul renews (n + 1)) (Nat.mul_le_mul_left r before)
    | .inr later => Nat.le_trans (Nat.le_of_eq ((congrArg (Amounts.whole.sum g 0 n + g ·)
        (Nat.zero_add n)).trans ((congrArg (_ + ·) (after n later)).trans (Nat.add_zero _))))
        (sum_le_mul_until renews after n)

/-- **No course draws more than its start and the renewal.** Where at most `r` is given at each
step, everything drawn across `n` steps is at most the starting level with `r` for each step. -/
theorem drawn_within (step : ∀ t, x (t + 1) = x t + g t - d t) (renews : ∀ t, g t ≤ r)
    (n : Nat) : Amounts.whole.sum (drawnAt x g) 0 n ≤ x 0 + r * n :=
  Nat.le_trans (Nat.le_add_left _ (x n)) (Nat.le_trans (Nat.le_of_eq (level_add_drawn step n))
    (Nat.add_le_add_left (sum_le_mul renews n) _))

/-- **Gated, above the renewal a course draws a bounded amount, however long.** Where at most `r`
is given at each step, nothing while the level stands below a positive need (the gate), and more
than `r` is taken at each step, everything drawn across any number of steps is at most the
starting level with `r` for each of its units. -/
theorem ended_drawn_le (step : ∀ t, x (t + 1) = x t + g t - d t) (renews : ∀ t, g t ≤ r)
    (unsupported : ∀ t, x t < m → g t = 0) (over : ∀ t, r < d t) (needs : 0 < m) (n : Nat) :
    Amounts.whole.sum (drawnAt x g) 0 n ≤ x 0 + r * x 0 :=
  Nat.le_trans (Nat.le_add_left _ (x n)) (Nat.le_trans (Nat.le_of_eq (level_add_drawn step n))
    (Nat.add_le_add_left (sum_le_mul_until (N := x 0) renews (fun t later => unsupported t
      (ends_within step renews over needs t
        (Nat.lt_of_le_of_lt later (Nat.lt_add_of_pos_left needs)))) n) _))

/-- A sum of at least `a` at each step is at least `a` for each step. -/
theorem mul_le_sum {a : Nat} (gives : ∀ t, a ≤ g t) : ∀ n, a * n ≤ Amounts.whole.sum g 0 n
  | 0 => Nat.le_trans (Nat.le_of_eq (Nat.mul_zero a)) (Nat.zero_le _)
  | n + 1 => Nat.le_trans (Nat.le_of_eq (Nat.mul_succ a n))
      (Nat.le_trans (Nat.add_le_add (mul_le_sum gives n) (gives n))
        (Nat.le_of_eq (congrArg (Amounts.whole.sum g 0 n + g ·) (Nat.zero_add n)).symm))

/-- **Where the level ends no higher than it started, everything given was drawn.** -/
theorem given_le_drawn (step : ∀ t, x (t + 1) = x t + g t - d t) {n : Nat} (within : x n ≤ x 0) :
    Amounts.whole.sum g 0 n ≤ Amounts.whole.sum (drawnAt x g) 0 n :=
  Naturals.le_of_add_le_add_left (k := x 0)
    (Nat.le_trans (Nat.le_of_eq (level_add_drawn step n).symm) (Nat.add_le_add_right within _))

/-- **Above the renewal, everything given is drawn.** Where at least `a` and at most `r` is given at
every step, however low the level, and more than `r` is taken, everything drawn across `n` steps is
at least `a` for each step: with `a = r`, as much as a level kept at its need by a draw of `r`
yields (`kept_drawn`). -/
theorem drawn_at_least (step : ∀ t, x (t + 1) = x t + g t - d t) {a : Nat} (renews : ∀ t, g t ≤ r)
    (gives : ∀ t, a ≤ g t) (over : ∀ t, r < d t) (n : Nat) :
    a * n ≤ Amounts.whole.sum (drawnAt x g) 0 n :=
  Nat.le_trans (mul_le_sum gives n) (given_le_drawn step (level_le_start step renews over n))

/-- **Ungated, above the renewal the draw has no bound.** Where at least one and at most `r` is
given at every step, however low the level, and more than `r` is taken, everything drawn has no
bound, at least one a step, while the level falls below any positive need all the same
(`ends_within`). -/
theorem drawn_unbounded (step : ∀ t, x (t + 1) = x t + g t - d t) (renews : ∀ t, g t ≤ r)
    (gives : ∀ t, 0 < g t) (over : ∀ t, r < d t) :
    ¬ ∃ B, ∀ n, Amounts.whole.sum (drawnAt x g) 0 n ≤ B :=
  fun ⟨B, bounded⟩ => Nat.not_succ_le_self B
    (Nat.le_trans (Nat.le_of_eq (Nat.one_mul _).symm)
      (Nat.le_trans (drawn_at_least step renews gives over (B + 1)) (bounded _)))

/-- A level less what is left of it after `k` is taken is `k`, where `k` is within it. -/
theorem sub_sub_of_le {a k : Nat} (within : k ≤ a) : a - (a - k) = k :=
  (congrArg (· - (a - k)) (Naturals.add_sub_of_le within).symm).trans
    (Naturals.add_sub_cancel k (a - k))

/-- **Within the renewal, a course draws its whole take at every step.** Where exactly `r` is
given while the level stands at the need or above and `k ≤ r` is taken at every step, a level
starting at the need has `k` drawn at every step: `k` for each step of the course. -/
theorem kept_drawn (step : ∀ t, x (t + 1) = x t + g t - d t) {k : Nat}
    (renewing : ∀ t, m ≤ x t → g t = r) (draws : ∀ t, d t = k) (within : k ≤ r)
    (start : m ≤ x 0) : ∀ n, Amounts.whole.sum (drawnAt x g) 0 n = k * n
  | 0 => rfl
  | n + 1 =>
    have atNeed := (kept_at_need step renewing (fun t => Nat.le_trans (Nat.le_of_eq (draws t))
      within) start n).1
    have each : drawnAt x g n = k := by
      show x n + g n - x (n + 1) = k
      rw [step n, renewing n atNeed, draws n]
      exact sub_sub_of_le (Nat.le_trans within (Nat.le_add_left r (x n)))
    (congrArg (Amounts.whole.sum (drawnAt x g) 0 n + drawnAt x g ·) (Nat.zero_add n)).trans
      ((congrArg (· + drawnAt x g n) (kept_drawn step renewing draws within start n)).trans
        ((congrArg (k * n + ·) each).trans (Nat.mul_succ k n).symm))

/-- **Gated, over a long enough course keeping draws more.** Of two levels from the same kind of
renewal, `r` a step at a positive need and nothing below, one drawn above `r` at every step and one
drawn `r` at every step from a start at the need: over `n` steps with `x 0 + r * x 0 < r * n`, the
second has had more drawn from it. -/
theorem keeping_draws_more {x' g' d' : Nat → Nat} (step : ∀ t, x (t + 1) = x t + g t - d t)
    (renews : ∀ t, g t ≤ r) (unsupported : ∀ t, x t < m → g t = 0) (over : ∀ t, r < d t)
    (needs : 0 < m) (step' : ∀ t, x' (t + 1) = x' t + g' t - d' t)
    (renewing' : ∀ t, m ≤ x' t → g' t = r) (draws' : ∀ t, d' t = r) (start' : m ≤ x' 0)
    {n : Nat} (long : x 0 + r * x 0 < r * n) :
    Amounts.whole.sum (drawnAt x g) 0 n < Amounts.whole.sum (drawnAt x' g') 0 n :=
  Nat.lt_of_le_of_lt (ended_drawn_le step renews unsupported over needs n)
    (Nat.lt_of_lt_of_le long (Nat.le_of_eq
      (kept_drawn step' renewing' draws' (Nat.le_refl r) start' n).symm))

/-- **Gated, the draw is bounded exactly above the renewal.** Where exactly `r` is given while the
level stands at a positive need or above, nothing below it, and `k > 0` is taken at every step, a
level starting at the need has a bound on everything ever drawn from it exactly where `r < k`. -/
theorem drawn_bounded_iff (step : ∀ t, x (t + 1) = x t + g t - d t) {k : Nat}
    (renewing : ∀ t, m ≤ x t → g t = r) (unsupported : ∀ t, x t < m → g t = 0)
    (draws : ∀ t, d t = k) (positive : 0 < k) (needs : 0 < m) (start : m ≤ x 0) :
    (∃ B, ∀ n, Amounts.whole.sum (drawnAt x g) 0 n ≤ B) ↔ r < k :=
  ⟨fun ⟨B, bounded⟩ => match Nat.lt_or_ge r k with
    | .inl over => over
    | .inr within => absurd (bounded (B + 1)) (Nat.not_le_of_gt (Nat.lt_of_lt_of_le
        (Nat.lt_succ_self B) (Nat.le_trans (Nat.le_of_eq (Nat.one_mul (B + 1)).symm)
          (Nat.le_trans (Nat.mul_le_mul_right (B + 1) positive)
            (Nat.le_of_eq (kept_drawn step renewing draws within start (B + 1)).symm))))),
   fun over => ⟨x 0 + r * x 0, ended_drawn_le step (renews_of renewing unsupported) unsupported
    (fun t => Nat.lt_of_lt_of_le over (Nat.le_of_eq (draws t).symm)) needs⟩⟩

/-- Where a decided property holds at `0` and fails at `n`, it holds at some step before `n` and
fails at the next. -/
theorem last_before {P : Nat → Prop} [DecidablePred P] (first : P 0) :
    ∀ {n : Nat}, ¬ P n → ∃ T, T < n ∧ P T ∧ ¬ P (T + 1)
  | 0, fails => absurd first fails
  | n + 1, fails =>
    if holds : P n then ⟨n, Nat.lt_succ_self n, holds, fails⟩
    else match last_before first holds with
      | ⟨T, lt, at_, next⟩ => ⟨T, Nat.lt_succ_of_lt lt, at_, next⟩

end Levels

open Flow

/-- **A course of re-optimizing steps.** At every step, the levels after are an optimum of the
part's order among the outcomes open to it from the levels before, the formations outside it
exchanging as they do in that step. -/
def Reoptimizes (L : Flow F C) (W : Web F C) (part : F → Bool) (cap : F → C → Nat)
    (ds rest : List C) (better : (C → Nat) → (C → Nat) → Prop) : Prop :=
  ∀ t, Frontier (L.Outcome part (W.level t) cap (ds ++ rest) t) better (W.level (t + 1))

variable {L : Flow F C} {W : Web F C} {part : F → Bool} {cap : F → C → Nat} {ds rest : List C}
  {better : (C → Nat) → (C → Nat) → Prop}

/-- **Each step of the course read off the one before.** Over a course of re-optimizing steps, at
a condition beyond, the level after each step is the level before with what the rest gives, less
what the rest takes and the part's capacity, or nothing. -/
theorem course_beyond [DecidableEq F] [DecidableEq C] (distinct : ∀ t, Distinct (L.present t))
    (cdistinct : Distinct (ds ++ rest)) (apart : ∀ c, c ∈ rest → ¬ c ∈ ds) {e : C}
    (inside : e ∈ ds) (rising : Rising ds better)
    (course : Reoptimizes L W part cap ds rest better)
    {c : C} (mem : c ∈ rest) (t : Nat) :
    W.level (t + 1) c = W.level t c + L.restGiven part t c -
      (L.restTaken part t c + L.capacity part cap t c) :=
  (optimum_beyond (distinct t) cdistinct apart inside rising (course t) mem).trans
    (Naturals.sub_sub _ _ _)

/-- **Several optimizers along a course.** Where every step of a balanced course is a mutual best
response, at a condition beyond every optimizer's family the level after each step is the level
before with what the formations outside every optimizer give, less what they take and the
optimizers' joint capacity, or nothing. -/
theorem mutual_course_beyond [DecidableEq F] [DecidableEq C] {optimizer : F → Bool}
    {dsOf restOf : F → List C} {betterOf : F → (C → Nat) → (C → Nat) → Prop}
    (distinct : ∀ t, Distinct (L.present t))
    (cdistinct : ∀ h, optimizer h = true → Distinct (dsOf h ++ restOf h))
    (apart : ∀ h, optimizer h = true → ∀ c, c ∈ restOf h → ¬ c ∈ dsOf h)
    (inside : ∀ h, optimizer h = true → ∃ e, e ∈ dsOf h)
    (rising : ∀ h, optimizer h = true → Rising (dsOf h) (betterOf h))
    (best : ∀ t, MutualBest L optimizer (W.level t) cap dsOf restOf betterOf t (W.level (t + 1)))
    (balances : L.Balances W) {c : C}
    (beyond : ∀ t h, h ∈ L.present t → optimizer h = true → c ∈ restOf h) (t : Nat) :
    W.level (t + 1) c = W.level t c + L.restGiven optimizer t c -
      (L.restTaken optimizer t c + L.capacity optimizer cap t c) :=
  (mutual_beyond (distinct t) cdistinct apart inside rising (best t) (balances t)
    (beyond t)).trans (Naturals.sub_sub _ _ _)

end Optimum

namespace Flow

/-- **A renewal needs support.** Where whatever gives to `c` across the step from `t` is
supported there (`Flow.GiversSupported`, as where only active formations give and activity needs
support) and every formation outside a part giving to `c` depends on `c` at a need of at least
`m`, nothing outside the part gives to `c` across a step from a level below `m`: the gate on which
`Flow.stays_below` turns, for the formations outside a part. -/
theorem restGiven_unsupported {L : Flow F C} {W : Web F C} {part : F → Bool} {t : Nat} {c : C}
    {m : Nat} (givers : L.GiversSupported W t c)
    (gated : ∀ h, h ∈ L.present t → part h = false → 0 < L.give t h c →
      W.requires t h c ∧ m ≤ W.need t h c)
    (below : W.level t c < m) : L.restGiven part t c = 0 :=
  (total_congr_on fun h present => by
    show (bif part h then 0 else L.give t h c) = 0
    cases out : part h
    · show L.give t h c = 0
      match zero : L.give t h c with
      | 0 => rfl
      | n + 1 =>
        have positive : 0 < L.give t h c :=
          Eq.subst (motive := fun y => 0 < y) zero.symm (Nat.succ_pos n)
        exact absurd (Nat.le_trans (gated h present out positive).2
            (givers h present positive c (gated h present out positive).1))
          (Nat.not_le_of_gt below)
    · rfl).trans (total_zero _)

end Flow

namespace Web

open Flow Optimum

variable {W : Web F C} {c : C} {f : F} {r m : Nat}

/-- **Above the renewal, a dependence on the condition is lost.** Where a condition's level is
given at most `r` at each step, however low it stands, more than `r` is taken at each step, and a
formation depends on it at a positive need `m` throughout, starting met, the dependence is broken
at some step and never met again. -/
theorem lost_over {g d : Nat → Nat} (step : ∀ t, W.level (t + 1) c = W.level t c + g t - d t)
    (renews : ∀ t, g t ≤ r) (over : ∀ t, r < d t) (needs : 0 < m)
    (depends : ∀ t, W.requires t f c) (need : ∀ t, W.need t f c = m)
    (start : m ≤ W.level 0 c) : W.Lost c :=
  have ended := ends_within (x := fun t => W.level t c) step renews over needs
  match last_before (P := fun t => m ≤ W.level t c) start (n := W.level 0 c)
      (Nat.not_le_of_gt (ended _ (Nat.lt_add_of_pos_left needs))) with
  | ⟨T, _, met, fails⟩ =>
    have next : W.level (T + 1) c < m := Nat.gt_of_not_le fails
    ⟨f, T, ⟨depends T, Nat.le_trans (Nat.le_of_eq (need T)) met,
        Nat.lt_of_lt_of_le next (Nat.le_of_eq (need T).symm)⟩,
     fun _ later => match le_dest later with
      | ⟨j, same⟩ => Eq.subst (motive := fun y => W.level y c < W.need T f c) same.symm
          (Nat.lt_of_lt_of_le
            (level_stays_below (x := fun t => W.level t c) step renews over next j)
            (Nat.le_of_eq (need T).symm))⟩

/-- **Lost exactly above the renewal.** Where a condition's level is given exactly `r` while it
stands at a positive need `m` or above, at most `r` below it, `k` is taken at every step, and a
formation depends on it at that need throughout, starting met, the dependence is lost exactly where
`r < k`; where `k ≤ r` the level does not fall across any step. -/
theorem lost_iff {g d : Nat → Nat} {k : Nat}
    (step : ∀ t, W.level (t + 1) c = W.level t c + g t - d t)
    (renewing : ∀ t, m ≤ W.level t c → g t = r) (renews : ∀ t, g t ≤ r)
    (draws : ∀ t, d t = k) (needs : 0 < m) (depends : ∀ t, W.requires t f c)
    (need : ∀ t, W.need t f c = m) (start : m ≤ W.level 0 c) : W.Lost c ↔ r < k :=
  ⟨fun ⟨_, T, broken, _⟩ => match Nat.lt_or_ge r k with
    | .inl over => over
    | .inr within => absurd (Nat.lt_of_lt_of_le broken.2.2 broken.2.1)
        (Nat.not_lt_of_ge (kept_at_need (x := fun t => W.level t c) step renewing
          (fun t => Nat.le_trans (Nat.le_of_eq (draws t)) within) start T).2),
   fun over => lost_over step renews
    (fun t => Nat.lt_of_lt_of_le over (Nat.le_of_eq (draws t).symm)) needs depends need start⟩

variable {L : Flow F C} {part : F → Bool} {cap : F → C → Nat} {ds rest : List C}
  {better : (C → Nat) → (C → Nat) → Prop}

/-- **A re-optimizing course loses a dependence beyond exactly where its draw exceeds the
renewal.** Over a course of re-optimizing steps, at a condition beyond that the rest renews by
exactly `r` while it stands at a positive need `m`, by at most `r` below, with what the rest takes
and the part's capacity there `k` at every step, and a formation depending on it at `m` throughout,
starting met, the dependence is lost exactly where `r < k`. -/
theorem course_lost_iff [DecidableEq F] [DecidableEq C] (distinct : ∀ t, Distinct (L.present t))
    (cdistinct : Distinct (ds ++ rest)) (apart : ∀ c, c ∈ rest → ¬ c ∈ ds) {e : C}
    (inside : e ∈ ds) (rising : Rising ds better)
    (course : Reoptimizes L W part cap ds rest better)
    (mem : c ∈ rest) {k : Nat} (renewing : ∀ t, m ≤ W.level t c → L.restGiven part t c = r)
    (renews : ∀ t, L.restGiven part t c ≤ r)
    (draws : ∀ t, L.restTaken part t c + L.capacity part cap t c = k) (needs : 0 < m)
    (depends : ∀ t, W.requires t f c) (need : ∀ t, W.need t f c = m)
    (start : m ≤ W.level 0 c) :
    W.Lost c ↔ r < k :=
  lost_iff (course_beyond distinct cdistinct apart inside rising course mem) renewing renews
    draws needs depends need start

/-- **A re-optimizing course keeps a condition beyond at its need exactly within the renewal.**
Over a course of re-optimizing steps, at a condition beyond that the rest renews by exactly `r`
while it stands at a positive need `m`, by at most `r` below, with what the rest takes and the
part's capacity there `k` at every step, from a start at the need, the condition stands at the need
at every step exactly where `k ≤ r`. -/
theorem course_kept_iff [DecidableEq F] [DecidableEq C] (distinct : ∀ t, Distinct (L.present t))
    (cdistinct : Distinct (ds ++ rest)) (apart : ∀ c, c ∈ rest → ¬ c ∈ ds) {e : C}
    (inside : e ∈ ds) (rising : Rising ds better)
    (course : Reoptimizes L W part cap ds rest better)
    (mem : c ∈ rest) {k : Nat} (renewing : ∀ t, m ≤ W.level t c → L.restGiven part t c = r)
    (renews : ∀ t, L.restGiven part t c ≤ r)
    (draws : ∀ t, L.restTaken part t c + L.capacity part cap t c = k) (needs : 0 < m)
    (start : m ≤ W.level 0 c) : (∀ t, m ≤ W.level t c) ↔ k ≤ r :=
  kept_iff_within (x := fun t => W.level t c)
    (course_beyond distinct cdistinct apart inside rising course mem) renewing renews draws
    needs start

/-- **No re-optimizing course draws more than its start and the renewal.** Over a course of
re-optimizing steps, at a condition beyond that the rest gives at most `r` a step, everything
drawn there across `n` steps (the level with what the rest gives, less what stands after) is at
most the starting level with `r` for each step. -/
theorem course_drawn_within [DecidableEq F] [DecidableEq C]
    (distinct : ∀ t, Distinct (L.present t)) (cdistinct : Distinct (ds ++ rest))
    (apart : ∀ c, c ∈ rest → ¬ c ∈ ds) {e : C} (inside : e ∈ ds) (rising : Rising ds better)
    (course : Reoptimizes L W part cap ds rest better) (mem : c ∈ rest)
    (renews : ∀ t, L.restGiven part t c ≤ r) (n : Nat) :
    Amounts.whole.sum (drawnAt (fun t => W.level t c) fun t => L.restGiven part t c) 0 n ≤
      W.level 0 c + r * n :=
  drawn_within (x := fun t => W.level t c)
    (course_beyond distinct cdistinct apart inside rising course mem) renews n

/-- **Gated, a re-optimizing course above the renewal draws a bounded amount.** Over a course of
re-optimizing steps, at a condition beyond that the rest gives at most `r` a step and nothing while
it stands below a positive need `m`, with what the rest takes and the part's capacity there above
`r` at every step, everything ever drawn there is at most the starting level with `r` for each of
its units. -/
theorem course_ended_drawn [DecidableEq F] [DecidableEq C]
    (distinct : ∀ t, Distinct (L.present t)) (cdistinct : Distinct (ds ++ rest))
    (apart : ∀ c, c ∈ rest → ¬ c ∈ ds) {e : C} (inside : e ∈ ds) (rising : Rising ds better)
    (course : Reoptimizes L W part cap ds rest better) (mem : c ∈ rest)
    (renews : ∀ t, L.restGiven part t c ≤ r)
    (unsupported : ∀ t, W.level t c < m → L.restGiven part t c = 0)
    (over : ∀ t, r < L.restTaken part t c + L.capacity part cap t c) (needs : 0 < m) (n : Nat) :
    Amounts.whole.sum (drawnAt (fun t => W.level t c) fun t => L.restGiven part t c) 0 n ≤
      W.level 0 c + r * W.level 0 c :=
  ended_drawn_le (x := fun t => W.level t c)
    (course_beyond distinct cdistinct apart inside rising course mem) renews unsupported over
    needs n

/-- **Ungated, a re-optimizing course above the renewal loses the dependence and draws without
bound.** Over a course of re-optimizing steps, at a condition beyond that the rest gives at least
`a` and at most `r` at every step, however low it stands, with what the rest takes and the part's
capacity there above `r` at every step, a dependence on it at a positive need `m` throughout,
starting met, is lost, while everything drawn there across `n` steps is at least `a` for each step
and, for a positive `a`, has no bound: where the dependence is lost, the gate is what bounds the
draw. -/
theorem course_drawn_unbounded [DecidableEq F] [DecidableEq C]
    (distinct : ∀ t, Distinct (L.present t)) (cdistinct : Distinct (ds ++ rest))
    (apart : ∀ c, c ∈ rest → ¬ c ∈ ds) {e : C} (inside : e ∈ ds) (rising : Rising ds better)
    (course : Reoptimizes L W part cap ds rest better) (mem : c ∈ rest)
    {a : Nat} (renews : ∀ t, L.restGiven part t c ≤ r) (gives : ∀ t, a ≤ L.restGiven part t c)
    (over : ∀ t, r < L.restTaken part t c + L.capacity part cap t c) (needs : 0 < m)
    (depends : ∀ t, W.requires t f c) (need : ∀ t, W.need t f c = m)
    (start : m ≤ W.level 0 c) :
    W.Lost c ∧ (∀ n, a * n ≤
      Amounts.whole.sum (drawnAt (fun t => W.level t c) fun t => L.restGiven part t c) 0 n) ∧
      (0 < a → ¬ ∃ B, ∀ n,
        Amounts.whole.sum (drawnAt (fun t => W.level t c) fun t => L.restGiven part t c) 0 n ≤ B) :=
  have step := course_beyond distinct cdistinct apart inside rising course mem
  ⟨lost_over step renews over needs depends need start,
   drawn_at_least (x := fun t => W.level t c) step renews gives over,
   fun positive => drawn_unbounded (x := fun t => W.level t c) step renews
     (fun t => Nat.lt_of_lt_of_le positive (gives t)) over⟩

/-- **Several optimizers each within the renewal can lose it together.** Where every step of a
balanced course is a mutual best response, a condition beyond every optimizer's family is given by
the formations outside them at most `r` a step, however low it stands, what those formations take
with the optimizers' joint capacity there exceeds `r` at every step, and a formation depends on it
at a positive need `m` throughout, starting met, the dependence is lost, however small each
optimizer's own capacity. -/
theorem mutual_course_lost [DecidableEq F] [DecidableEq C] {optimizer : F → Bool}
    {dsOf restOf : F → List C} {betterOf : F → (C → Nat) → (C → Nat) → Prop}
    (distinct : ∀ t, Distinct (L.present t))
    (cdistinct : ∀ h, optimizer h = true → Distinct (dsOf h ++ restOf h))
    (apart : ∀ h, optimizer h = true → ∀ c, c ∈ restOf h → ¬ c ∈ dsOf h)
    (inside : ∀ h, optimizer h = true → ∃ e, e ∈ dsOf h)
    (rising : ∀ h, optimizer h = true → Rising (dsOf h) (betterOf h))
    (best : ∀ t, MutualBest L optimizer (W.level t) cap dsOf restOf betterOf t (W.level (t + 1)))
    (balances : L.Balances W)
    (beyond : ∀ t h, h ∈ L.present t → optimizer h = true → c ∈ restOf h)
    (renews : ∀ t, L.restGiven optimizer t c ≤ r)
    (over : ∀ t, r < L.restTaken optimizer t c + L.capacity optimizer cap t c) (needs : 0 < m)
    (depends : ∀ t, W.requires t f c) (need : ∀ t, W.need t f c = m)
    (start : m ≤ W.level 0 c) :
    W.Lost c :=
  lost_over (mutual_course_beyond distinct cdistinct apart inside rising best balances beyond)
    renews over needs depends need start

end Web

namespace Optimum

namespace Renewing

open Diversion DrawnBeyond Drain

/-- What the dweller gives the source across a step from level `s`: `r` where the source meets its
need of two, nothing below. -/
def renewal (r s : Nat) : Nat := if 2 ≤ s then r else 0

/-- The source along the course from `s₀`: each step adds the renewal and the taker takes `k`, or
all there is. -/
def source (k r s₀ : Nat) : Nat → Nat
  | 0 => s₀
  | t + 1 => source k r s₀ t + renewal r (source k r s₀ t) - k

/-- What the dweller gives the source at each step of the course. -/
def renewed (k r s₀ : Nat) (t : Nat) : Nat := renewal r (source k r s₀ t)

/-- What the taker takes from the source at the step from `t`. -/
def draw (k r s₀ : Nat) : Nat → Nat := drawnAt (source k r s₀) (renewed k r s₀)

/-- The store along the course: everything the taker has drawn. -/
def store (k r s₀ : Nat) : Nat → Nat
  | 0 => 0
  | t + 1 => store k r s₀ t + draw k r s₀ t

/-- The levels along the course. -/
def level (k r s₀ : Nat) (t : Nat) : Place → Nat
  | .source => source k r s₀ t
  | .store => store k r s₀ t

/-- At each step the taker takes what it draws from the source and gives it to the store; the
dweller gives the source the renewal. -/
def course (k r s₀ : Nat) : Flow Formation Place where
  present _ := [.taker, .dweller]
  take t f c := match f, c with
    | .taker, .source => draw k r s₀ t
    | .taker, .store => 0
    | .dweller, _ => 0
  give t f c := match f, c with
    | .taker, .store => draw k r s₀ t
    | .taker, .source => 0
    | .dweller, .source => renewed k r s₀ t
    | .dweller, .store => 0

variable {k r s₀ : Nat}

/-- What the step leaves is within the level with the renewal. -/
theorem source_within (t : Nat) :
    source k r s₀ (t + 1) ≤ source k r s₀ t + renewed k r s₀ t :=
  Nat.sub_le _ _

/-- The renewal is `r` where the source stands at its need. -/
theorem renewed_at {t : Nat} (atNeed : 2 ≤ source k r s₀ t) : renewed k r s₀ t = r :=
  if_pos atNeed

/-- Nothing is renewed where the source stands below its need. -/
theorem renewed_below {t : Nat} (below : source k r s₀ t < 2) : renewed k r s₀ t = 0 :=
  if_neg (Nat.not_le_of_gt below)

/-- The renewal is at most `r`. -/
theorem renewal_le (r s : Nat) : renewal r s ≤ r :=
  match Nat.lt_or_ge s 2 with
  | .inl below => Nat.le_trans (Nat.le_of_eq (if_neg (Nat.not_le_of_gt below))) (Nat.zero_le r)
  | .inr atNeed => Nat.le_of_eq (if_pos atNeed)

/-- What the taker draws at a step is at most `k`. -/
theorem draw_le (t : Nat) : draw k r s₀ t ≤ k :=
  match Nat.lt_or_ge (source k r s₀ t + renewed k r s₀ t) k with
  | .inl below => Nat.le_trans (Nat.sub_le _ _) (Nat.le_of_lt below)
  | .inr within => Nat.le_of_eq (sub_sub_of_le within)

/-- At most `k`, and at most the level with the renewal, is at most what the taker draws. -/
theorem le_draw {a : Nat} (t : Nat) (atMostK : a ≤ k)
    (atMostLevel : a ≤ source k r s₀ t + renewed k r s₀ t) : a ≤ draw k r s₀ t :=
  match Nat.lt_or_ge (source k r s₀ t + renewed k r s₀ t) k with
  | .inl below => Nat.le_trans atMostLevel (Nat.le_of_eq (show source k r s₀ t +
      renewed k r s₀ t = source k r s₀ t + renewed k r s₀ t -
        (source k r s₀ t + renewed k r s₀ t - k) by
      rw [sub_eq_zero_of_le (Nat.le_of_lt below), Nat.sub_zero]))
  | .inr within => Nat.le_trans atMostK (Nat.le_of_eq (sub_sub_of_le within).symm)

/-- The course balances: the source loses what the taker draws and gains the renewal; the store
gains what the taker draws. -/
theorem course_balances : (course k r s₀).Balances (web (level k r s₀)) := fun t c =>
  match c with
  | .source => show source k r s₀ (t + 1) + (draw k r s₀ t + 0) =
      source k r s₀ t + (0 + (renewed k r s₀ t + 0)) by
    rw [Nat.add_zero, Nat.add_zero, Nat.zero_add]
    exact Naturals.add_sub_of_le (source_within t)
  | .store => show store k r s₀ (t + 1) + (0 + 0) = store k r s₀ t + (draw k r s₀ t + 0) from
    rfl

/-- The taker acts within its capacity `k` at every step. -/
theorem course_within (t : Nat) :
    (course k r s₀).ActsWithin takerPart (takerCap k) ([Place.store] ++ [Place.source]) t
      (course k r s₀) :=
  ⟨rfl, fun _ _ _ => ⟨rfl, rfl⟩,
   fun h c member => match h, c, member with
    | .taker, .source, _ => draw_le t
    | .taker, .store, _ => Nat.le_refl 0,
   fun h c member outside => match h, c, member with
    | .taker, .store, _ => absurd (.head _) outside
    | .taker, .source, _ => rfl,
   fun h member => match h, member with
    | .taker, _ => show draw k r s₀ t + (0 + 0) ≤ 0 + (draw k r s₀ t + 0) from
        Nat.le_of_eq (Nat.zero_add _).symm⟩

/-- **At every step, the taker's draw is an optimum of the store's order.** Every outcome open to
the taker leaves the store at most where its draw does: it gives the store no more than it takes,
takes at most `k`, from the source alone, and at most what stands there with the renewal. -/
theorem course_optimum (t : Nat) :
    Frontier ((course k r s₀).Outcome takerPart (level k r s₀ t) (takerCap k)
      ([Place.store] ++ [Place.source]) t) storeOrder (level k r s₀ (t + 1)) :=
  ⟨⟨course k r s₀, course_within t, course_balances t⟩,
   fun o ⟨L', acts, balances⟩ above => by
    have atStore : o .store + L'.taken t .store = store k r s₀ t + L'.given t .store :=
      balances .store
    have src : o .source + L'.taken t .source = source k r s₀ t + L'.given t .source :=
      balances .source
    have gives : L'.given t .store = L'.give t .taker .store + (L'.give t .dweller .store + 0) :=
      congrArg (fun ps => total ps fun f => L'.give t f .store) acts.1
    have takes : L'.taken t .source = L'.take t .taker .source + (L'.take t .dweller .source + 0) :=
      congrArg (fun ps => total ps fun f => L'.take t f .source) acts.1
    have renews : L'.given t .source =
        L'.give t .taker .source + (L'.give t .dweller .source + 0) :=
      congrArg (fun ps => total ps fun f => L'.give t f .source) acts.1
    have dwellerStore : L'.give t .dweller .store = 0 := (acts.2.1 .dweller .store rfl).2
    have dwellerTake : L'.take t .dweller .source = 0 := (acts.2.1 .dweller .source rfl).1
    have dwellerGive : L'.give t .dweller .source = renewed k r s₀ t :=
      (acts.2.1 .dweller .source rfl).2
    have conserved : L'.give t .taker .store + (L'.give t .taker .source + 0) ≤
        L'.take t .taker .store + (L'.take t .taker .source + 0) := acts.2.2.2.2 .taker rfl
    have fromStore : L'.take t .taker .store ≤ 0 := acts.2.2.1 .taker .store rfl
    have fromSource : L'.take t .taker .source ≤ k := acts.2.2.1 .taker .source rfl
    rw [dwellerStore] at gives
    rw [dwellerTake] at takes
    rw [dwellerGive] at renews
    have gives : L'.given t .store = L'.give t .taker .store := gives
    have takes : L'.taken t .source = L'.take t .taker .source := takes
    have renews : L'.given t .source = L'.give t .taker .source + renewed k r s₀ t := renews
    have conserved : L'.give t .taker .store + L'.give t .taker .source ≤
        L'.take t .taker .store + L'.take t .taker .source := conserved
    rw [Nat.le_antisymm fromStore (Nat.zero_le _), Nat.zero_add] at conserved
    rw [takes, renews] at src
    have toSource : L'.take t .taker .source ≤
        source k r s₀ t + renewed k r s₀ t + L'.give t .taker .source :=
      calc L'.take t .taker .source ≤ o .source + L'.take t .taker .source := Nat.le_add_left _ _
        _ = source k r s₀ t + (L'.give t .taker .source + renewed k r s₀ t) := src
        _ = source k r s₀ t + renewed k r s₀ t + L'.give t .taker .source := by
            rw [Nat.add_comm (L'.give t .taker .source), Nat.add_assoc]
    have atMostLevel : L'.give t .taker .store ≤ source k r s₀ t + renewed k r s₀ t :=
      Naturals.le_of_add_le_add_right (Nat.le_trans conserved toSource)
    have atMostK : L'.give t .taker .store ≤ k :=
      Nat.le_trans (Nat.le_add_right _ _) (Nat.le_trans conserved fromSource)
    have atMost : o .store ≤ store k r s₀ (t + 1) :=
      calc o .store ≤ o .store + L'.taken t .store := Nat.le_add_right _ _
        _ = store k r s₀ t + L'.give t .taker .store := by rw [atStore, gives]
        _ ≤ store k r s₀ t + draw k r s₀ t :=
            Nat.add_le_add_left (le_draw t atMostK atMostLevel) _
    exact Nat.not_le_of_gt above atMost⟩

/-- **The taker re-optimizes at every step of the course.** -/
theorem course_reoptimizes :
    Reoptimizes (course k r s₀) (web (level k r s₀)) takerPart (takerCap k) [Place.store]
      [Place.source] storeOrder :=
  course_optimum

/-- **Each step of the source read off the one before, by the law of the course.** Derived from
`Optimum.course_beyond`. -/
theorem source_beyond (t : Nat) :
    (web (level k r s₀)).level (t + 1) .source = (web (level k r s₀)).level t .source +
      (course k r s₀).restGiven takerPart t .source -
        ((course k r s₀).restTaken takerPart t .source +
          (course k r s₀).capacity takerPart (takerCap k) t .source) :=
  course_beyond (fun _ => formations_distinct) store_source_distinct source_apart (.head [])
    storeOrder_rising course_reoptimizes (.head []) t

/-- What the dweller gives the source is the renewal. -/
theorem restGiven_source (t : Nat) :
    (course k r s₀).restGiven takerPart t .source = renewed k r s₀ t :=
  show 0 + (renewed k r s₀ t + 0) = renewed k r s₀ t from Nat.zero_add _

/-- Nothing outside the taker takes from the source, and the taker's capacity there is `k`. -/
theorem draws_source (t : Nat) :
    (course k r s₀).restTaken takerPart t .source +
      (course k r s₀).capacity takerPart (takerCap k) t .source = k :=
  show 0 + (0 + 0) + (k + (0 + 0)) = k from Nat.zero_add k

/-- The renewal is `r` where the source stands at its need of two. -/
theorem renewing_source (t : Nat) (atNeed : 2 ≤ (web (level k r s₀)).level t .source) :
    (course k r s₀).restGiven takerPart t .source = r :=
  (restGiven_source t).trans (renewed_at atNeed)

/-- Nothing is renewed where the source stands below its need. -/
theorem unsupported_source (t : Nat) (below : (web (level k r s₀)).level t .source < 2) :
    (course k r s₀).restGiven takerPart t .source = 0 :=
  (restGiven_source t).trans (renewed_below below)

/-- **The dweller's dependence is lost exactly where the taker's capacity exceeds the renewal.**
From a source at its need of two or above, at every step of the course the store's optimum, the
dweller's dependence on the source is lost exactly where `r < k`; derived from
`Web.course_lost_iff`. -/
theorem lost_iff (start : 2 ≤ s₀) : (web (level k r s₀)).Lost .source ↔ r < k :=
  Web.course_lost_iff (f := Formation.dweller) (fun _ => formations_distinct) store_source_distinct
    source_apart (.head []) storeOrder_rising course_reoptimizes (.head []) renewing_source
    (fun t => Nat.le_trans (Nat.le_of_eq (restGiven_source t)) (renewal_le r _)) draws_source
    (Nat.succ_pos 1) (fun _ => trivial) (fun _ => rfl) start

/-- The store holds everything drawn. -/
theorem store_eq_sum : ∀ n, store k r s₀ n = Amounts.whole.sum (draw k r s₀) 0 n
  | 0 => rfl
  | n + 1 => (congrArg (· + draw k r s₀ n) (store_eq_sum n)).trans
      (congrArg (Amounts.whole.sum (draw k r s₀) 0 n + draw k r s₀ ·) (Nat.zero_add n).symm)

/-- **Above the renewal, the store stays bounded however long the course.** -/
theorem store_bounded (over : r < k) (n : Nat) :
    (web (level k r s₀)).level n .store ≤ s₀ + r * s₀ :=
  Nat.le_trans (Nat.le_of_eq (store_eq_sum n)) (ended_drawn_le (x := source k r s₀) (m := 2)
    (g := renewed k r s₀) (d := fun _ => k) (fun _ => rfl) (renews_of (x := source k r s₀)
      (g := renewed k r s₀) (fun _ atNeed => renewed_at atNeed)
      (fun _ below => renewed_below below))
    (fun _ below => renewed_below below) (fun _ => over) (Nat.succ_pos 1) n)

/-- **Within the renewal, the store gains `k` at every step.** -/
theorem store_kept (start : 2 ≤ s₀) (within : k ≤ r) (n : Nat) :
    (web (level k r s₀)).level n .store = k * n :=
  (store_eq_sum n).trans (kept_drawn (x := source k r s₀) (m := 2) (g := renewed k r s₀)
    (d := fun _ => k) (fun _ => rfl) (fun _ atNeed => renewed_at atNeed) (fun _ => rfl) within
    start n)

/-- **Re-optimizing the store with more capacity than the renewal leaves less in the store.** From
a source at its need, the taker of capacity `r < k`, choosing the store's optimum at every step,
holds less in the store after `n` steps with `s₀ + r * s₀ < r * n` than a taker of capacity `r`
does, choosing the same way. -/
theorem keeping_holds_more (start : 2 ≤ s₀) (over : r < k) {n : Nat}
    (long : s₀ + r * s₀ < r * n) :
    (web (level k r s₀)).level n .store < (web (level r r s₀)).level n .store :=
  Nat.lt_of_le_of_lt (Nat.le_of_eq (store_eq_sum n))
    (Nat.lt_of_lt_of_le (keeping_draws_more (x := source k r s₀) (m := 2) (g := renewed k r s₀)
      (d := fun _ => k) (x' := source r r s₀) (g' := renewed r r s₀) (d' := fun _ => r)
      (fun _ => rfl) (renews_of (x := source k r s₀) (g := renewed k r s₀)
        (fun _ atNeed => renewed_at atNeed) (fun _ below => renewed_below below))
      (fun _ below => renewed_below below) (fun _ => over) (Nat.succ_pos 1) (fun _ => rfl)
      (fun _ atNeed => renewed_at atNeed) (fun _ => rfl) start long)
      (Nat.le_of_eq (store_eq_sum n).symm))

/-- **The store is bounded exactly where the capacity exceeds the renewal.** From a source at its
need, with `0 < k`, the store has a bound over every course length exactly where `r < k`. -/
theorem store_bounded_iff (start : 2 ≤ s₀) (positive : 0 < k) :
    (∃ B, ∀ n, (web (level k r s₀)).level n .store ≤ B) ↔ r < k :=
  have sums : (∃ B, ∀ n, (web (level k r s₀)).level n .store ≤ B) ↔
      ∃ B, ∀ n, Amounts.whole.sum (drawnAt (source k r s₀) (renewed k r s₀)) 0 n ≤ B :=
    ⟨fun ⟨B, bounded⟩ => ⟨B, fun n => Nat.le_trans (Nat.le_of_eq (store_eq_sum n).symm)
        (bounded n)⟩,
     fun ⟨B, bounded⟩ => ⟨B, fun n => Nat.le_trans (Nat.le_of_eq (store_eq_sum n))
        (bounded n)⟩⟩
  sums.trans (drawn_bounded_iff (x := source k r s₀) (m := 2) (g := renewed k r s₀)
    (d := fun _ => k) (fun _ => rfl) (fun _ atNeed => renewed_at atNeed)
    (fun _ below => renewed_below below) (fun _ => rfl) positive (Nat.succ_pos 1) start)

/-! ### Two takers along a course

Two takers, each of capacity one at the source, each ordering by the store, and the dweller
renewing the source by `r` while it stands at its need of two. At every step both drawing what
there is is a mutual best response. With `r < 2` the joint capacity exceeds the renewal and the
dweller's dependence is lost, though with `r = 1` either taker alone would keep it; the store stays
bounded, while the course in which one taker restrains, none of whose steps is a mutual best
response, gains a unit at every step. -/

section Pair

open TwoTakers

/-- One unit where something stands: the amount less what is left after one. -/
def takeOne (a : Nat) : Nat := a - (a - 1)

/-- At most one unit. -/
theorem takeOne_le_one : ∀ a, takeOne a ≤ 1
  | 0 => Nat.zero_le 1
  | n + 1 => Nat.le_of_eq (succ_sub_self n)

/-- What is left after one unit: the amount less one. -/
theorem sub_takeOne : ∀ a, a - takeOne a = a - 1
  | 0 => rfl
  | n + 1 => congrArg (n + 1 - ·) (succ_sub_self n)

/-- One unit and what is left make the amount. -/
theorem takeOne_split (a : Nat) : takeOne a + (a - 1) = a :=
  (congrArg (takeOne a + ·) (sub_takeOne a).symm).trans
    (Naturals.add_sub_of_le (Nat.sub_le a (a - 1)))

/-- At most one, and at most the amount, is at most one unit of it. -/
theorem le_takeOne {x : Nat} : ∀ {a : Nat}, x ≤ 1 → x ≤ a → x ≤ takeOne a
  | 0, _, within => within
  | n + 1, one, _ => Nat.le_trans one (Nat.le_of_eq (succ_sub_self n).symm)

/-- The source along the two takers' course from `s₀`: each step adds the renewal and the two take
one unit each, or what there is. -/
def jointSource (r s₀ : Nat) : Nat → Nat
  | 0 => s₀
  | t + 1 => jointSource r s₀ t + renewal r (jointSource r s₀ t) - 2

/-- What stands at the source with the renewal across the step from `t`. -/
def avail (r s₀ t : Nat) : Nat := jointSource r s₀ t + renewal r (jointSource r s₀ t)

/-- The first taker takes one unit where one stands with the renewal. -/
def first (r s₀ t : Nat) : Nat := takeOne (avail r s₀ t)

/-- The second takes one unit where one is left. -/
def second (r s₀ t : Nat) : Nat := takeOne (avail r s₀ t - 1)

/-- The store along the course: everything the two have drawn. -/
def jointStore (r s₀ : Nat) : Nat → Nat
  | 0 => 0
  | t + 1 => jointStore r s₀ t + (first r s₀ t + second r s₀ t)

/-- The levels along the two takers' course. -/
def jointLevel (r s₀ : Nat) (t : Nat) : Place → Nat
  | .source => jointSource r s₀ t
  | .store => jointStore r s₀ t

/-- Each taker takes its unit from the source and gives it to the store; the dweller gives the
source the renewal. -/
def jointCourse (r s₀ : Nat) : Flow Member Place where
  present _ := [.taker true, .taker false, .dweller]
  take t f c := match f, c with
    | .taker true, .source => first r s₀ t
    | .taker false, .source => second r s₀ t
    | .taker _, .store => 0
    | .dweller, _ => 0
  give t f c := match f, c with
    | .taker true, .store => first r s₀ t
    | .taker false, .store => second r s₀ t
    | .taker _, .source => 0
    | .dweller, .source => renewal r (jointSource r s₀ t)
    | .dweller, .store => 0

/-- The dweller requires the source at need two and is active exactly while it stands so; the
takers require nothing, are active throughout and draw on the source. -/
def jointWeb (level : Nat → Place → Nat) : Web Member Place where
  level := level
  active t f := match f with
    | .taker _ => True
    | .dweller => 2 ≤ level t .source
  requires _ f c := match f, c with
    | .dweller, .source => True
    | .dweller, .store => False
    | .taker _, _ => False
  need _ _ _ := 2
  draws _ f c := match f, c with
    | .taker _, .source => True
    | .taker _, .store => False
    | .dweller, _ => False

variable {r s₀ : Nat}

/-- What the two draw and what stands after make what stood with the renewal. -/
theorem joint_split (t : Nat) :
    jointSource r s₀ (t + 1) + (first r s₀ t + second r s₀ t) = avail r s₀ t :=
  have rest : second r s₀ t + jointSource r s₀ (t + 1) = avail r s₀ t - 1 :=
    (congrArg (takeOne (avail r s₀ t - 1) + ·)
      (Naturals.sub_sub (avail r s₀ t) 1 1)).symm.trans
      (takeOne_split (avail r s₀ t - 1))
  (Nat.add_comm _ _).trans ((Nat.add_assoc _ _ _).trans
    ((congrArg (first r s₀ t + ·) rest).trans (takeOne_split (avail r s₀ t))))

/-- The two takers' course balances. -/
theorem joint_course_balances : (jointCourse r s₀).Balances (jointWeb (jointLevel r s₀)) :=
  fun t c => match c with
  | .source => show jointSource r s₀ (t + 1) + (first r s₀ t + (second r s₀ t + 0)) =
      jointSource r s₀ t + (0 + (0 + (renewal r (jointSource r s₀ t) + 0))) by
    rw [Nat.add_zero (second r s₀ t), Nat.add_zero (renewal r (jointSource r s₀ t)),
      Nat.zero_add (0 + renewal r (jointSource r s₀ t)),
      Nat.zero_add (renewal r (jointSource r s₀ t))]
    exact joint_split t
  | .store => show jointStore r s₀ (t + 1) + (0 + (0 + 0)) =
      jointStore r s₀ t + (first r s₀ t + (second r s₀ t + 0)) from rfl

/-- Each taker acts within its capacity of one in the two takers' course. -/
theorem joint_course_within (w : Bool) (t : Nat) :
    (jointCourse r s₀).ActsWithin (alone (Member.taker w)) capOf
      ([Place.store] ++ [Place.source]) t (jointCourse r s₀) :=
  ⟨rfl, fun _ _ _ => ⟨rfl, rfl⟩,
   fun h c member => match h, c, member with
    | .taker true, .source, _ => takeOne_le_one _
    | .taker false, .source, _ => takeOne_le_one _
    | .taker true, .store, _ => Nat.le_refl 0
    | .taker false, .store, _ => Nat.le_refl 0
    | .dweller, _, member => absurd (of_decide_eq_true member) fun same => (nomatch same),
   fun _ c _ outside => match c with
    | .store => absurd (.head _) outside
    | .source => absurd (.tail _ (.head _)) outside,
   fun h member => match h, member with
    | .taker true, _ => show first r s₀ t + (0 + 0) ≤ 0 + (first r s₀ t + 0) from
        Nat.le_of_eq (Nat.zero_add _).symm
    | .taker false, _ => show second r s₀ t + (0 + 0) ≤ 0 + (second r s₀ t + 0) from
        Nat.le_of_eq (Nat.zero_add _).symm
    | .dweller, member => absurd (of_decide_eq_true member) fun same => nomatch same⟩

/-- **The first taker's draw is an optimum of the store's order, given the second's.** Every
outcome open to the first taker alone leaves the store at most where the course does: it gives the
store at most one unit, and with the second's draw at most what stands with the renewal. -/
theorem first_optimum (t : Nat) :
    Frontier ((jointCourse r s₀).Outcome (alone (Member.taker true)) (jointLevel r s₀ t) capOf
      ([Place.store] ++ [Place.source]) t) storeOrder (jointLevel r s₀ (t + 1)) :=
  ⟨⟨jointCourse r s₀, joint_course_within true t, joint_course_balances t⟩,
   fun o ⟨L', acts, balances⟩ above => by
    have atStore : o .store + L'.taken t .store = jointStore r s₀ t + L'.given t .store :=
      balances .store
    have src : o .source + L'.taken t .source = jointSource r s₀ t + L'.given t .source :=
      balances .source
    have gives : L'.given t .store = L'.give t (.taker true) .store +
        (L'.give t (.taker false) .store + (L'.give t .dweller .store + 0)) :=
      congrArg (fun ps => total ps fun f => L'.give t f .store) acts.1
    have takes : L'.taken t .source = L'.take t (.taker true) .source +
        (L'.take t (.taker false) .source + (L'.take t .dweller .source + 0)) :=
      congrArg (fun ps => total ps fun f => L'.take t f .source) acts.1
    have renews : L'.given t .source = L'.give t (.taker true) .source +
        (L'.give t (.taker false) .source + (L'.give t .dweller .source + 0)) :=
      congrArg (fun ps => total ps fun f => L'.give t f .source) acts.1
    rw [(acts.2.1 (.taker false) .store rfl).2, (acts.2.1 .dweller .store rfl).2] at gives
    rw [(acts.2.1 (.taker false) .source rfl).1, (acts.2.1 .dweller .source rfl).1] at takes
    rw [(acts.2.1 (.taker false) .source rfl).2, (acts.2.1 .dweller .source rfl).2] at renews
    have gives : L'.given t .store = L'.give t (.taker true) .store + second r s₀ t := gives
    have takes : L'.taken t .source = L'.take t (.taker true) .source + second r s₀ t := takes
    have renews : L'.given t .source =
        L'.give t (.taker true) .source + renewal r (jointSource r s₀ t) :=
      renews.trans (congrArg (L'.give t (.taker true) .source + ·)
        (Nat.zero_add (renewal r (jointSource r s₀ t) + 0)))
    have conserved : L'.give t (.taker true) .store + L'.give t (.taker true) .source ≤
        L'.take t (.taker true) .store + L'.take t (.taker true) .source :=
      acts.2.2.2.2 (.taker true) (alone_self _)
    have fromStore : L'.take t (.taker true) .store ≤ 0 :=
      acts.2.2.1 (.taker true) .store (alone_self _)
    have fromSource : L'.take t (.taker true) .source ≤ 1 :=
      acts.2.2.1 (.taker true) .source (alone_self _)
    rw [Nat.le_antisymm fromStore (Nat.zero_le _), Nat.zero_add] at conserved
    rw [takes, renews] at src
    have toSource : L'.take t (.taker true) .source + second r s₀ t ≤
        avail r s₀ t + L'.give t (.taker true) .source :=
      calc L'.take t (.taker true) .source + second r s₀ t
          ≤ o .source + (L'.take t (.taker true) .source + second r s₀ t) := Nat.le_add_left _ _
        _ = jointSource r s₀ t + (L'.give t (.taker true) .source +
            renewal r (jointSource r s₀ t)) := src
        _ = avail r s₀ t + L'.give t (.taker true) .source := by
            rw [Nat.add_comm (L'.give t (.taker true) .source), ← Nat.add_assoc]; rfl
    have withSecond : L'.give t (.taker true) .store + second r s₀ t ≤ avail r s₀ t :=
      Naturals.le_of_add_le_add_right (k := L'.give t (.taker true) .source)
        (Nat.le_trans (Nat.le_of_eq (Nat.add_right_comm _ _ _))
          (Nat.le_trans (Nat.add_le_add_right conserved _) toSource))
    have atMostFirst : L'.give t (.taker true) .store ≤ first r s₀ t :=
      le_takeOne (Nat.le_trans (Nat.le_add_right _ _) (Nat.le_trans conserved fromSource))
        (Nat.le_trans (Nat.le_add_right _ _) withSecond)
    have atMost : o .store ≤ jointStore r s₀ (t + 1) :=
      calc o .store ≤ o .store + L'.taken t .store := Nat.le_add_right _ _
        _ = jointStore r s₀ t + (L'.give t (.taker true) .store + second r s₀ t) := by
            rw [atStore, gives]
        _ ≤ jointStore r s₀ t + (first r s₀ t + second r s₀ t) :=
            Nat.add_le_add_left (Nat.add_le_add_right atMostFirst _) _
    exact Nat.not_le_of_gt above atMost⟩

/-- **The second taker's draw is an optimum of the store's order, given the first's.** -/
theorem second_optimum (t : Nat) :
    Frontier ((jointCourse r s₀).Outcome (alone (Member.taker false)) (jointLevel r s₀ t) capOf
      ([Place.store] ++ [Place.source]) t) storeOrder (jointLevel r s₀ (t + 1)) :=
  ⟨⟨jointCourse r s₀, joint_course_within false t, joint_course_balances t⟩,
   fun o ⟨L', acts, balances⟩ above => by
    have atStore : o .store + L'.taken t .store = jointStore r s₀ t + L'.given t .store :=
      balances .store
    have src : o .source + L'.taken t .source = jointSource r s₀ t + L'.given t .source :=
      balances .source
    have gives : L'.given t .store = L'.give t (.taker true) .store +
        (L'.give t (.taker false) .store + (L'.give t .dweller .store + 0)) :=
      congrArg (fun ps => total ps fun f => L'.give t f .store) acts.1
    have takes : L'.taken t .source = L'.take t (.taker true) .source +
        (L'.take t (.taker false) .source + (L'.take t .dweller .source + 0)) :=
      congrArg (fun ps => total ps fun f => L'.take t f .source) acts.1
    have renews : L'.given t .source = L'.give t (.taker true) .source +
        (L'.give t (.taker false) .source + (L'.give t .dweller .source + 0)) :=
      congrArg (fun ps => total ps fun f => L'.give t f .source) acts.1
    rw [(acts.2.1 (.taker true) .store rfl).2, (acts.2.1 .dweller .store rfl).2] at gives
    rw [(acts.2.1 (.taker true) .source rfl).1, (acts.2.1 .dweller .source rfl).1] at takes
    rw [(acts.2.1 (.taker true) .source rfl).2, (acts.2.1 .dweller .source rfl).2] at renews
    have gives : L'.given t .store = first r s₀ t + L'.give t (.taker false) .store := gives
    have takes : L'.taken t .source = first r s₀ t + L'.take t (.taker false) .source := takes
    have renews : L'.given t .source =
        L'.give t (.taker false) .source + renewal r (jointSource r s₀ t) :=
      renews.trans (Nat.zero_add (L'.give t (.taker false) .source +
        (renewal r (jointSource r s₀ t) + 0)))
    have conserved : L'.give t (.taker false) .store + L'.give t (.taker false) .source ≤
        L'.take t (.taker false) .store + L'.take t (.taker false) .source :=
      acts.2.2.2.2 (.taker false) (alone_self _)
    have fromStore : L'.take t (.taker false) .store ≤ 0 :=
      acts.2.2.1 (.taker false) .store (alone_self _)
    have fromSource : L'.take t (.taker false) .source ≤ 1 :=
      acts.2.2.1 (.taker false) .source (alone_self _)
    rw [Nat.le_antisymm fromStore (Nat.zero_le _), Nat.zero_add] at conserved
    rw [takes, renews] at src
    have toSource : first r s₀ t + L'.take t (.taker false) .source ≤
        avail r s₀ t + L'.give t (.taker false) .source :=
      calc first r s₀ t + L'.take t (.taker false) .source
          ≤ o .source + (first r s₀ t + L'.take t (.taker false) .source) := Nat.le_add_left _ _
        _ = jointSource r s₀ t + (L'.give t (.taker false) .source +
            renewal r (jointSource r s₀ t)) := src
        _ = avail r s₀ t + L'.give t (.taker false) .source := by
            rw [Nat.add_comm (L'.give t (.taker false) .source), ← Nat.add_assoc]; rfl
    have withFirst : first r s₀ t + L'.give t (.taker false) .store ≤ avail r s₀ t :=
      Naturals.le_of_add_le_add_right (k := L'.give t (.taker false) .source)
        (Nat.le_trans (Nat.le_of_eq (Nat.add_assoc _ _ _))
          (Nat.le_trans (Nat.add_le_add_left conserved _) toSource))
    have atMostSecond : L'.give t (.taker false) .store ≤ second r s₀ t :=
      le_takeOne (Nat.le_trans (Nat.le_add_right _ _) (Nat.le_trans conserved fromSource))
        (Nat.le_trans (Naturals.le_sub_of_add_le withFirst)
          (Nat.le_of_eq (sub_takeOne (avail r s₀ t))))
    have atMost : o .store ≤ jointStore r s₀ (t + 1) :=
      calc o .store ≤ o .store + L'.taken t .store := Nat.le_add_right _ _
        _ = jointStore r s₀ t + (first r s₀ t + L'.give t (.taker false) .store) := by
            rw [atStore, gives]
        _ ≤ jointStore r s₀ t + (first r s₀ t + second r s₀ t) :=
            Nat.add_le_add_left (Nat.add_le_add_left atMostSecond _) _
    exact Nat.not_le_of_gt above atMost⟩

/-- **At every step both drawing is a mutual best response.** -/
theorem joint_course_best (t : Nat) :
    MutualBest (jointCourse r s₀) takers (jointLevel r s₀ t) capOf (fun _ => [Place.store])
      (fun _ => [Place.source]) (fun _ => storeOrder) t (jointLevel r s₀ (t + 1)) :=
  fun h _ opt => match h, opt with
    | .taker true, _ => ⟨joint_course_within true t, first_optimum t⟩
    | .taker false, _ => ⟨joint_course_within false t, second_optimum t⟩

/-- What the dweller gives the source in the two takers' course is the renewal. -/
theorem joint_restGiven (t : Nat) :
    (jointCourse r s₀).restGiven takers t .source = renewal r (jointSource r s₀ t) :=
  show 0 + (0 + (renewal r (jointSource r s₀ t) + 0)) = renewal r (jointSource r s₀ t) from
    (Nat.zero_add _).trans (Nat.zero_add _)

/-- **Each within the renewal, jointly above it: the dependence is lost.** From a source at its
need, with a renewal `r < 2`, the two takers' joint capacity of two exceeds it, and at mutual best
responses at every step the dweller's dependence on the source is lost; derived from
`Web.mutual_course_lost`. -/
theorem joint_course_lost (start : 2 ≤ s₀) (below : r < 2) :
    (jointWeb (jointLevel r s₀)).Lost .source :=
  Web.mutual_course_lost (f := Member.dweller) (fun _ => members_distinct) lists.1 lists.2.1
    lists.2.2.1 lists.2.2.2 joint_course_best joint_course_balances (fun _ _ _ _ => .head [])
    (fun t => Nat.le_trans (Nat.le_of_eq (joint_restGiven t)) (renewal_le r _))
    (fun _ => below) (Nat.succ_pos 1) (fun _ => trivial) (fun _ => rfl) start

/-- **Alone, a taker of capacity one keeps a source renewed by one.** -/
theorem alone_kept (start : 2 ≤ s₀) : ¬ (web (level 1 1 s₀)).Lost .source :=
  fun lost => Nat.lt_irrefl 1 ((lost_iff start).mp lost)

/-- The two takers' store holds everything drawn from the source. -/
theorem joint_store_eq_sum : ∀ n, jointStore r s₀ n =
    Amounts.whole.sum (drawnAt (jointSource r s₀) fun t => renewal r (jointSource r s₀ t)) 0 n
  | 0 => rfl
  | n + 1 => (congrArg (· + (first r s₀ n + second r s₀ n)) (joint_store_eq_sum n)).trans
      ((congrArg (Amounts.whole.sum (drawnAt (jointSource r s₀)
          fun t => renewal r (jointSource r s₀ t)) 0 n + ·)
        ((Naturals.add_sub_cancel_left (jointSource r s₀ (n + 1)) _).symm.trans
          (congrArg (· - jointSource r s₀ (n + 1)) (joint_split n)))).trans
        (congrArg (Amounts.whole.sum (drawnAt (jointSource r s₀)
          fun t => renewal r (jointSource r s₀ t)) 0 n + drawnAt (jointSource r s₀)
            (fun t => renewal r (jointSource r s₀ t)) ·) (Nat.zero_add n).symm))

/-- **Above the renewal jointly, the two takers' store stays bounded however long the course.** -/
theorem joint_store_bounded (below : r < 2) (n : Nat) : jointStore r s₀ n ≤ s₀ + r * s₀ :=
  Nat.le_trans (Nat.le_of_eq (joint_store_eq_sum n)) (ended_drawn_le (x := jointSource r s₀)
    (m := 2) (g := fun t => renewal r (jointSource r s₀ t)) (d := fun _ => 2) (fun _ => rfl)
    (fun _ => renewal_le r _) (fun _ low => if_neg (Nat.not_le_of_gt low)) (fun _ => below)
    (Nat.succ_pos 1) n)

/-- One taker draws a unit at every step and the other nothing; the dweller renews by one. -/
def restrainedCourse (s₀ : Nat) : Flow Member Place where
  present _ := [.taker true, .taker false, .dweller]
  take _ f c := match f, c with
    | .taker true, .source => 1
    | .taker true, .store => 0
    | .taker false, _ => 0
    | .dweller, _ => 0
  give _ f c := match f, c with
    | .taker true, .store => 1
    | .taker true, .source => 0
    | .taker false, _ => 0
    | .dweller, .source => renewal 1 s₀
    | .dweller, .store => 0

/-- The levels of the restrained course: the source where it started, the store at the step
count. -/
def restrainedLevel (s₀ : Nat) (t : Nat) : Place → Nat
  | .source => s₀
  | .store => t

/-- The restrained course balances from a source at its need. -/
theorem restrained_course_balances (start : 2 ≤ s₀) :
    (restrainedCourse s₀).Balances (jointWeb (restrainedLevel s₀)) := fun t c =>
  match c with
  | .source => show s₀ + (1 + (0 + (0 + 0))) = s₀ + (0 + (0 + (renewal 1 s₀ + 0))) from
      (congrArg (fun y => s₀ + (0 + (0 + (y + 0)))) (if_pos start : renewal 1 s₀ = 1)).symm
  | .store => show t + 1 + (0 + (0 + (0 + 0))) = t + (1 + (0 + (0 + 0))) from rfl

/-- **No step of the restrained course is a mutual best response.** Something stands at the
source after each step, and the restraining taker does not take its whole capacity there. -/
theorem restrained_course_not_best (start : 2 ≤ s₀) (t : Nat) :
    ¬ MutualBest (restrainedCourse s₀) takers (restrainedLevel s₀ t) capOf
      (fun _ => [Place.store]) (fun _ => [Place.source]) (fun _ => storeOrder) t
      (restrainedLevel s₀ (t + 1)) := fun best =>
  absurd (MutualBest.full (L := restrainedCourse s₀) (ds := fun _ => [Place.store])
    (rest := fun _ => [Place.source]) members_distinct lists.1 lists.2.1 lists.2.2.1 lists.2.2.2
    best (restrained_course_balances start t) (h := .taker false) (.tail _ (.head _)) rfl
    (.head []) (Nat.lt_of_lt_of_le (Nat.succ_pos 1) start)).1 fun same => nomatch same

/-- **Restraint, which no mutual best response allows, holds more.** From a source at its need
renewed by one, after `n` steps with `s₀ + s₀ < n` the two takers' store at mutual best
responses at every step holds less than the restrained course's. -/
theorem restraint_holds_more {n : Nat} (long : s₀ + s₀ < n) :
    (jointWeb (jointLevel 1 s₀)).level n .store < (jointWeb (restrainedLevel s₀)).level n .store :=
  Nat.lt_of_le_of_lt (Nat.le_trans (joint_store_bounded (Nat.lt_succ_self 1) n)
    (Nat.le_of_eq (congrArg (s₀ + ·) (Nat.one_mul s₀)))) long

end Pair

end Renewing

end Optimum

/-! ## Courses ranked over a horizon

Above, the part chooses again at each step. Here it ranks whole courses: an order on the courses
open to it at a condition beyond, rising with what a course draws there across a horizon of steps.
Where at most `r` is given at each step, what a course draws, what it leaves after the horizon and
everything the renewal falls short of `r` add to the starting level with `r` for each step; so
what is drawn ranks courses exactly as the renewal they forgo with what they leave does, reversed,
and registers a level only through what is given there. Where what is given is a law `R` of
the level, at most `r`, a course from a start draws across `n + 1` steps at most the start with what
is given there and `r` for each step after, exactly where it stands at a level of greatest renewal
at every step from the first to the `n`-th and leaves nothing after the last; where such a level is
within reach and the capacity, every optimum of every order rising with what is drawn is such a
course. So every optimum breaks at the first step a dependence whose need lies above every level of
greatest renewal and leaves it unmet through the horizon; a dependence every such level meets stands
through the horizon and is broken at its end; and where the renewal is the same at every level at or
above a need, two courses standing there and ending alike draw the same, whatever dependence above
the need one keeps and the other breaks. -/

namespace Optimum

section Horizon

variable {x g : Nat → Nat} {r : Nat}

/-- Sums over `n` steps of what agrees at each of them are the same. -/
theorem sum_eq_of_eq {f f' : Nat → Nat} :
    ∀ {n : Nat}, (∀ t, t < n → f t = f' t) →
      Amounts.whole.sum f 0 n = Amounts.whole.sum f' 0 n
  | 0, _ => rfl
  | n + 1, same => by
    show Amounts.whole.sum f 0 n + f (0 + n) = Amounts.whole.sum f' 0 n + f' (0 + n)
    rw [Nat.zero_add, sum_eq_of_eq (n := n) (fun t lt => same t (Nat.lt_succ_of_lt lt)),
      same n (Nat.lt_succ_self n)]

/-- A sum across `n + 1` steps is the first step with the sum across the `n` after it. -/
theorem sum_succ_first (f : Nat → Nat) :
    ∀ n, Amounts.whole.sum f 0 (n + 1) = f 0 + Amounts.whole.sum (fun t => f (t + 1)) 0 n
  | 0 => show 0 + f (0 + 0) = f 0 + 0 from (Nat.zero_add _).trans (Nat.add_zero _).symm
  | n + 1 => by
    show Amounts.whole.sum f 0 (n + 1) + f (0 + (n + 1)) =
      f 0 + (Amounts.whole.sum (fun t => f (t + 1)) 0 n + f (0 + n + 1))
    rw [sum_succ_first f n, Nat.add_assoc, Nat.zero_add, Nat.zero_add]

/-- Two amounts added and two more: the middle two exchanged. -/
theorem add_four (a b c d : Nat) : a + b + (c + d) = a + c + (b + d) := by
  rw [Nat.add_assoc, Nat.add_left_comm b c d, ← Nat.add_assoc]

/-- Nothing from two amounts added is nothing from each. -/
theorem eq_zero_of_add {a : Nat} : ∀ {b : Nat}, a + b = 0 → a = 0 ∧ b = 0
  | 0, zero => ⟨zero, rfl⟩
  | _ + 1, zero => absurd zero (Naturals.succ_ne_zero _)

/-- Adding the same amount first keeps two amounts apart. -/
theorem add_left_cancel_of {k a b : Nat} (same : k + a = k + b) : a = b :=
  Nat.le_antisymm (Naturals.le_of_add_le_add_left (k := k) (Nat.le_of_eq same))
    (Naturals.le_of_add_le_add_left (k := k) (Nat.le_of_eq same.symm))

/-- Of two equal sums of two amounts, the first amount of one is at most the first of the other
exactly where the second of the other is at most the second of the one. -/
theorem le_iff_of_add_eq {a b a' b' : Nat} (same : a + b = a' + b') : a ≤ a' ↔ b' ≤ b :=
  ⟨fun le => Naturals.le_of_add_le_add_left (k := a')
      (Nat.le_trans (Nat.le_of_eq same.symm) (Nat.add_le_add_right le b)),
   fun le => Naturals.le_of_add_le_add_right (k := b)
      (Nat.le_trans (Nat.le_of_eq same) (Nat.add_le_add_left le a'))⟩

/-- Nothing left of `n` less `m` is `n` at most `m`. -/
theorem le_of_sub_zero {n m : Nat} (zero : n - m = 0) : n ≤ m :=
  match Nat.lt_or_ge m n with
  | .inl lt => absurd (Nat.lt_of_lt_of_le lt (Nat.le_of_eq
      ((Naturals.sub_add_cancel (Nat.le_of_lt lt)).symm.trans
        ((congrArg (· + m) zero).trans (Nat.zero_add m))))) (Nat.lt_irrefl m)
  | .inr ge => ge

/-- A sum over `n` steps is nothing exactly where each step is nothing. -/
theorem sum_eq_zero_iff {f : Nat → Nat} :
    ∀ {n : Nat}, Amounts.whole.sum f 0 n = 0 ↔ ∀ t, t < n → f t = 0
  | 0 => ⟨fun _ _ lt => absurd lt (Nat.not_lt_zero _), fun _ => rfl⟩
  | n + 1 => ⟨fun zero =>
      have both := eq_zero_of_add (a := Amounts.whole.sum f 0 n) (b := f (0 + n)) zero
      fun t lt => match Nat.lt_or_ge t n with
        | .inl before => sum_eq_zero_iff.mp both.1 t before
        | .inr later => (congrArg f ((Nat.le_antisymm (Nat.le_of_lt_succ lt) later).trans
            (Nat.zero_add n).symm)).trans both.2,
     fun all => show Amounts.whole.sum f 0 n + f (0 + n) = 0 from
       (congrArg (· + f (0 + n))
         (sum_eq_zero_iff.mpr fun t lt => all t (Nat.lt_succ_of_lt lt))).trans
         ((Nat.zero_add _).trans
           ((congrArg f (Nat.zero_add n)).trans (all n (Nat.lt_succ_self n))))⟩

/-- **What is given and what it falls short of.** Where at most `r` is given at each step,
everything given across `n` steps, with everything it falls short of `r`, is `r` for each step. -/
theorem sum_add_shortfall (renews : ∀ t, g t ≤ r) :
    ∀ n, Amounts.whole.sum g 0 n + Amounts.whole.sum (fun t => r - g t) 0 n = r * n
  | 0 => rfl
  | n + 1 => by
    show Amounts.whole.sum g 0 n + g (0 + n) +
        (Amounts.whole.sum (fun t => r - g t) 0 n + (r - g (0 + n))) = r * (n + 1)
    rw [Nat.zero_add, add_four, sum_add_shortfall renews n, Naturals.add_sub_of_le (renews n),
      Nat.mul_succ]

/-- **What is given and what it falls short of, at the steps counted.** Where at most `r` is given at
each of `n` steps, everything given across them, with everything it falls short of `r`, is `r` for
each step: `sum_add_shortfall` for what is given at those steps and nothing after. -/
theorem sum_add_shortfall_up_to {n : Nat} (renews : ∀ t, t < n → g t ≤ r) :
    Amounts.whole.sum g 0 n + Amounts.whole.sum (fun t => r - g t) 0 n = r * n := by
  have given : Amounts.whole.sum g 0 n =
      Amounts.whole.sum (fun t => if t < n then g t else 0) 0 n :=
    sum_eq_of_eq fun _ lt => (if_pos lt).symm
  have short : Amounts.whole.sum (fun t => r - g t) 0 n =
      Amounts.whole.sum (fun t => r - if t < n then g t else 0) 0 n :=
    sum_eq_of_eq fun _ lt => congrArg (r - ·) (if_pos lt).symm
  rw [given, short]
  exact sum_add_shortfall (g := fun t => if t < n then g t else 0) (fun t => by
    show (if t < n then g t else 0) ≤ r
    match Nat.lt_or_ge t n with
    | .inl lt => rw [if_pos lt]; exact renews t lt
    | .inr ge => rw [if_neg (Nat.not_lt_of_ge ge)]; exact Nat.zero_le r) n

/-- **What a course draws, leaves and forgoes.** Where each step leaves at most the level with what
is given and at most `r` is given at each of `n` steps, what is drawn across them, with what stands
after them and everything the renewal falls short of `r`, is the starting level with `r` for each
step. -/
theorem drawn_add_shortfall_up_to (within : ∀ t, x (t + 1) ≤ x t + g t) {n : Nat}
    (renews : ∀ t, t < n → g t ≤ r) :
    Amounts.whole.sum (drawnAt x g) 0 n + x n + Amounts.whole.sum (fun t => r - g t) 0 n =
      x 0 + r * n := by
  rw [Nat.add_comm (Amounts.whole.sum (drawnAt x g) 0 n), level_add_drawn_of_within within n,
    Nat.add_assoc, sum_add_shortfall_up_to renews]

/-- **What a course draws, leaves and forgoes**, where at most `r` is given at every step: the case
of `drawn_add_shortfall_up_to`. -/
theorem drawn_add_shortfall (within : ∀ t, x (t + 1) ≤ x t + g t) (renews : ∀ t, g t ≤ r)
    (n : Nat) :
    Amounts.whole.sum (drawnAt x g) 0 n + x n + Amounts.whole.sum (fun t => r - g t) 0 n =
      x 0 + r * n :=
  drawn_add_shortfall_up_to within fun t _ => renews t

/-- **What a course draws after its first step, leaves and forgoes.** Where each step leaves at most
the level with what is given and at most `r` is given at each of the `n` steps after the first,
what is drawn across `n + 1` steps, with what stands after them and everything the renewal falls
short of `r` at those steps, is the starting level with what is given at the first step and `r` for
each step after. -/
theorem drawn_add_shortfall_after_up_to (within : ∀ t, x (t + 1) ≤ x t + g t) {n : Nat}
    (renews : ∀ t, t < n → g (t + 1) ≤ r) :
    Amounts.whole.sum (drawnAt x g) 0 (n + 1) + x (n + 1) +
        Amounts.whole.sum (fun t => r - g (t + 1)) 0 n = x 0 + g 0 + r * n := by
  have later : Amounts.whole.sum (fun t => drawnAt x g (t + 1)) 0 n + x (n + 1) +
      Amounts.whole.sum (fun t => r - g (t + 1)) 0 n = x 1 + r * n :=
    drawn_add_shortfall_up_to (x := fun t => x (t + 1)) (g := fun t => g (t + 1))
      (fun t => within (t + 1)) renews
  have first : x 1 + drawnAt x g 0 = x 0 + g 0 := Naturals.add_sub_of_le (within 0)
  rw [sum_succ_first, Nat.add_assoc (drawnAt x g 0), Nat.add_assoc (drawnAt x g 0), later,
    ← Nat.add_assoc, Nat.add_comm (drawnAt x g 0), first]

/-- **What a course draws after its first step, leaves and forgoes**, where at most `r` is given at
every step: the case of `drawn_add_shortfall_after_up_to`. -/
theorem drawn_add_shortfall_after (within : ∀ t, x (t + 1) ≤ x t + g t)
    (renews : ∀ t, g t ≤ r) (n : Nat) :
    Amounts.whole.sum (drawnAt x g) 0 (n + 1) + x (n + 1) +
        Amounts.whole.sum (fun t => r - g (t + 1)) 0 n = x 0 + g 0 + r * n :=
  drawn_add_shortfall_after_up_to within fun t _ => renews (t + 1)

/-- **The most a course draws.** Where each step leaves at most the level with what is given and at
most `r` is given at each step, no course draws across `n + 1` steps more than the starting level
with what is given at the first step and `r` for each step after. -/
theorem drawn_le_most (within : ∀ t, x (t + 1) ≤ x t + g t) (renews : ∀ t, g t ≤ r)
    (n : Nat) :
    Amounts.whole.sum (drawnAt x g) 0 (n + 1) ≤ x 0 + g 0 + r * n :=
  Nat.le_trans (Nat.le_add_right _ (x (n + 1))) (Nat.le_trans (Nat.le_add_right _ _)
    (Nat.le_of_eq (drawn_add_shortfall_after within renews n)))

/-- **Exactly which courses draw the most.** Where each step leaves at most the level with what is
given and at most `r` is given at each step, a course draws across `n + 1` steps the starting level
with what is given at the first step and `r` for each step after exactly where `r` is given at every
step after the first and nothing stands after the last. -/
theorem most_iff (within : ∀ t, x (t + 1) ≤ x t + g t) (renews : ∀ t, g t ≤ r) (n : Nat) :
    Amounts.whole.sum (drawnAt x g) 0 (n + 1) = x 0 + g 0 + r * n ↔
      x (n + 1) = 0 ∧ ∀ t, t < n → g (t + 1) = r :=
  have whole := drawn_add_shortfall_after within renews n
  ⟨fun most =>
    have rest : x (n + 1) + Amounts.whole.sum (fun t => r - g (t + 1)) 0 n = 0 :=
      add_left_cancel_of ((Nat.add_assoc _ _ _).symm.trans
        (whole.trans (most.symm.trans (Nat.add_zero _).symm)))
    have both := eq_zero_of_add rest
    ⟨both.1, fun t lt => Nat.le_antisymm (renews (t + 1))
        (le_of_sub_zero (sum_eq_zero_iff.mp both.2 t lt))⟩,
   fun ⟨left, renewed⟩ => by
    have none : Amounts.whole.sum (fun t => r - g (t + 1)) 0 n = 0 :=
      sum_eq_zero_iff.mpr fun t lt => (congrArg (r - ·) (renewed t lt)).trans (Nat.sub_self r)
    rw [left, none] at whole
    exact whole⟩

/-- **What a course draws and leaves, at most.** Where each step leaves at most the level with what
is given and at most `r` is given at each step, what a course draws across `n + 1` steps with what
stands after them is at most the starting level with what is given at the first step and `r` for each
step after. -/
theorem drawn_add_left_le_most (within : ∀ t, x (t + 1) ≤ x t + g t) (renews : ∀ t, g t ≤ r)
    (n : Nat) :
    Amounts.whole.sum (drawnAt x g) 0 (n + 1) + x (n + 1) ≤ x 0 + g 0 + r * n :=
  Nat.le_trans (Nat.le_add_right _ _) (Nat.le_of_eq (drawn_add_shortfall_after within renews n))

/-- **Exactly which courses draw and leave the most.** Where each step leaves at most the level with
what is given and at most `r` is given at each step, what a course draws across `n + 1` steps with
what stands after them is the starting level with what is given at the first step and `r` for each
step after exactly where `r` is given at every step after the first, whatever stands after the last. -/
theorem most_left_iff (within : ∀ t, x (t + 1) ≤ x t + g t) (renews : ∀ t, g t ≤ r) (n : Nat) :
    Amounts.whole.sum (drawnAt x g) 0 (n + 1) + x (n + 1) = x 0 + g 0 + r * n ↔
      ∀ t, t < n → g (t + 1) = r :=
  have whole := drawn_add_shortfall_after within renews n
  ⟨fun most =>
    have none : Amounts.whole.sum (fun t => r - g (t + 1)) 0 n = 0 :=
      add_left_cancel_of (whole.trans (most.symm.trans (Nat.add_zero _).symm))
    fun t lt => Nat.le_antisymm (renews (t + 1)) (le_of_sub_zero (sum_eq_zero_iff.mp none t lt)),
   fun renewed => by
    have none : Amounts.whole.sum (fun t => r - g (t + 1)) 0 n = 0 :=
      sum_eq_zero_iff.mpr fun t lt => (congrArg (r - ·) (renewed t lt)).trans (Nat.sub_self r)
    rw [none] at whole
    exact whole⟩

end Horizon

/-- What a course of levels `x` draws across `n` steps where `R` gives at each level. -/
def drawnOver (R : Nat → Nat) (x : Nat → Nat) (n : Nat) : Nat :=
  Amounts.whole.sum (drawnAt x fun t => R (x t)) 0 n

/-- **The courses open from a start.** From level `s`, where `R` gives at each level and at most
`k` may be drawn a step: each step leaves at most the level with what is given, and draws at most
`k`. -/
def OpenCourse (R : Nat → Nat) (k s : Nat) (x : Nat → Nat) : Prop :=
  x 0 = s ∧ ∀ t, x (t + 1) ≤ x t + R (x t) ∧ drawnAt x (fun t => R (x t)) t ≤ k

/-- The order of courses by what they draw across `n + 1` steps: more is better. -/
def byDrawn (R : Nat → Nat) (n : Nat) (b a : Nat → Nat) : Prop :=
  drawnOver R a (n + 1) < drawnOver R b (n + 1)

/-- From `s`, the course standing at `y` from the first step to the `n`-th and at `e` after. -/
def holdingTo (s y e n : Nat) : Nat → Nat
  | 0 => s
  | t + 1 => if t < n then y else e

/-- From `s`, the course standing at `y` from the first step to the `n`-th and at nothing after: the
course holding `y` and ending at nothing. -/
def holding (s y n : Nat) : Nat → Nat := holdingTo s y 0 n

variable {R : Nat → Nat} {k r s y e n : Nat}

/-- The course holding `y` stands there from the first step to the `n`-th. -/
theorem holdingTo_before {t : Nat} (before : t < n) : holdingTo s y e n (t + 1) = y :=
  if_pos before

/-- The course holding `y` and ending at `e` stands at `e` after the `n`-th step. -/
theorem holdingTo_after {t : Nat} (after : n ≤ t) : holdingTo s y e n (t + 1) = e :=
  if_neg (Nat.not_lt_of_ge after)

/-- After its start, the course holding `y` and ending at `e` at most `y` stands at `e` or above. -/
theorem holdingTo_ge (settles : e ≤ y) (t : Nat) : e ≤ holdingTo s y e n (t + 1) :=
  match Nat.lt_or_ge t n with
  | .inl before => Nat.le_trans settles (Nat.le_of_eq (holdingTo_before before).symm)
  | .inr after => Nat.le_of_eq (holdingTo_after after).symm

/-- Each step of the course holding `y` and ending at `e` at most `y` leaves at most the level with
what is given, where `y` is within the start with what is given there. -/
theorem holdingTo_within (reach : y ≤ s + R s) (settles : e ≤ y) :
    ∀ t, holdingTo s y e n (t + 1) ≤ holdingTo s y e n t + R (holdingTo s y e n t)
  | 0 => match Nat.lt_or_ge 0 n with
    | .inl lt => Nat.le_trans (Nat.le_of_eq (holdingTo_before lt)) reach
    | .inr ge => Nat.le_trans (Nat.le_of_eq (holdingTo_after ge)) (Nat.le_trans settles reach)
  | t + 1 => match Nat.lt_or_ge (t + 1) n with
    | .inl lt => Nat.le_trans (Nat.le_of_eq ((holdingTo_before lt).trans
        (holdingTo_before (Nat.lt_of_succ_lt lt)).symm)) (Nat.le_add_right _ _)
    | .inr ge => Nat.le_trans (Nat.le_of_eq (holdingTo_after ge))
        (Nat.le_trans (holdingTo_ge settles t) (Nat.le_add_right _ _))

/-- The holding course stands at `y` from the first step to the `n`-th. -/
theorem holding_before {t : Nat} (before : t < n) : holding s y n (t + 1) = y :=
  holdingTo_before before

/-- The holding course stands at nothing after the `n`-th step. -/
theorem holding_after {t : Nat} (after : n ≤ t) : holding s y n (t + 1) = 0 :=
  holdingTo_after after

/-- Each step of the holding course leaves at most the level with what is given, where `y` is
within the start with what is given there. -/
theorem holding_within (reach : y ≤ s + R s) (n : Nat) :
    ∀ t, holding s y n (t + 1) ≤ holding s y n t + R (holding s y n t) :=
  holdingTo_within reach (Nat.zero_le y)

/-- **A course holding a level of greatest renewal draws the most.** Where `R` gives at most `r` at
every level and `r` at `y`, within the start with what is given there, the course holding `y` draws
across `n + 1` steps the start with what is given there and `r` for each step after. -/
theorem holding_most (renews : ∀ z, R z ≤ r) (greatest : R y = r) (reach : y ≤ s + R s)
    (n : Nat) : drawnOver R (holding s y n) (n + 1) = s + R s + r * n :=
  (most_iff (x := holding s y n) (g := fun t => R (holding s y n t)) (holding_within reach n)
    (fun _ => renews _) n).mpr
    ⟨holding_after (Nat.le_refl n), fun _ lt => (congrArg R (holding_before lt)).trans greatest⟩

/-- What a step draws is at most `k` where the level with what is given is at most the level after
with `k`. -/
theorem drawnAt_le_of {a b c k : Nat} (le : a + b ≤ c + k) : a + b - c ≤ k :=
  Nat.le_trans (sub_le_sub_right_of_le le c) (Nat.le_of_eq (Naturals.add_sub_cancel_left c k))

/-- **The steps of the course holding `y` and ending at `e` within the horizon, `e` within `y` with
`r`.** Over a horizon of at least two steps, with a capacity covering what the first step draws down
to `y`, `r`, and `y` with `r` down to `e`, each step to the `n`-th leaves at most the level with what
is given and draws at most `k`: the end may lie above `y`, regrown at the last step. -/
theorem holdingTo_steps_of (greatest : R y = r) (reach : y ≤ s + R s) (rises : e ≤ y + r)
    (drawsDown : s + R s ≤ y + k) (middle : r ≤ k) (holds : y + r ≤ e + k) (long : 0 < n) :
    ∀ t, t ≤ n → holdingTo s y e n (t + 1) ≤ holdingTo s y e n t + R (holdingTo s y e n t) ∧
      drawnAt (holdingTo s y e n) (fun t => R (holdingTo s y e n t)) t ≤ k
  | 0, _ => ⟨Nat.le_trans (Nat.le_of_eq (holdingTo_before long)) reach, drawnAt_le_of
      (Nat.le_trans drawsDown (Nat.le_of_eq (congrArg (· + k) (holdingTo_before long).symm)))⟩
  | t + 1, le =>
    have stands : holdingTo s y e n (t + 1) + R (holdingTo s y e n (t + 1)) = y + r :=
      (congrArg (fun z => z + R z) (holdingTo_before (Nat.lt_of_succ_le le))).trans
        (congrArg (y + ·) greatest)
    match Nat.lt_or_ge (t + 1) n with
    | .inl lt => ⟨Nat.le_trans (Nat.le_of_eq (holdingTo_before lt))
          (Nat.le_trans (Nat.le_add_right y r) (Nat.le_of_eq stands.symm)),
        drawnAt_le_of (Nat.le_trans (Nat.le_of_eq stands) (Nat.le_trans (Nat.add_le_add_left middle y)
          (Nat.le_of_eq (congrArg (· + k) (holdingTo_before lt).symm))))⟩
    | .inr ge => ⟨Nat.le_trans (Nat.le_of_eq (holdingTo_after ge))
          (Nat.le_trans rises (Nat.le_of_eq stands.symm)),
        drawnAt_le_of (Nat.le_trans (Nat.le_of_eq stands)
          (Nat.le_trans holds (Nat.le_of_eq (congrArg (· + k) (holdingTo_after ge).symm))))⟩

/-- **The steps of the course holding `y` and ending at `e` within the horizon.** Over a horizon of
at least two steps, with a capacity covering what the first step draws down to `y` and `y` with `r`
down to `e`, each step to the `n`-th leaves at most the level with what is given and draws at most
`k`: the case of `holdingTo_steps_of` ending at most at `y`. -/
theorem holdingTo_steps (greatest : R y = r) (reach : y ≤ s + R s) (settles : e ≤ y)
    (drawsDown : s + R s ≤ y + k) (holds : y + r ≤ e + k) (long : 0 < n) :
    ∀ t, t ≤ n → holdingTo s y e n (t + 1) ≤ holdingTo s y e n t + R (holdingTo s y e n t) ∧
      drawnAt (holdingTo s y e n) (fun t => R (holdingTo s y e n t)) t ≤ k :=
  holdingTo_steps_of greatest reach (Nat.le_trans settles (Nat.le_add_right y r)) drawsDown
    (Naturals.le_of_add_le_add_left (Nat.le_trans holds (Nat.add_le_add_right settles k))) holds long

/-- **The course holding `y` and ending at `e` is open**, over a horizon of at least two steps, with
a capacity covering what the first step draws down to `y`, `y` with `r` down to `e`, and what is
given at `e`. -/
theorem holdingTo_open (greatest : R y = r) (reach : y ≤ s + R s) (settles : e ≤ y)
    (drawsDown : s + R s ≤ y + k) (holds : y + r ≤ e + k) (rests : R e ≤ k) (long : 0 < n) :
    OpenCourse R k s (holdingTo s y e n) :=
  ⟨rfl, fun t => match Nat.lt_or_ge t (n + 1) with
    | .inl lt =>
      holdingTo_steps greatest reach settles drawsDown holds long t (Nat.le_of_lt_succ lt)
    | .inr ge => ⟨holdingTo_within reach settles t, match t, ge with
      | 0, ge => absurd ge (Nat.not_succ_le_zero n)
      | j + 1, ge => drawnAt_le_of (by
          show holdingTo s y e n (j + 1) + R (holdingTo s y e n (j + 1)) ≤
            holdingTo s y e n (j + 1 + 1) + k
          rw [holdingTo_after (Nat.le_of_succ_le_succ ge),
            holdingTo_after (Nat.le_succ_of_le (Nat.le_of_succ_le_succ ge))]
          exact Nat.add_le_add_left rests e)⟩⟩

/-- **The holding course is open**, over a horizon of at least two steps, with a capacity covering
what the first step draws down to `y` and `y` with `r`: the case of `holdingTo_open` ending at
nothing. -/
theorem holding_open (renews : ∀ z, R z ≤ r) (greatest : R y = r) (reach : y ≤ s + R s)
    (drawsDown : s + R s ≤ y + k) (holds : y + r ≤ k) (long : 0 < n) :
    OpenCourse R k s (holding s y n) :=
  holdingTo_open greatest reach (Nat.zero_le y) drawsDown
    (Nat.le_trans holds (Nat.le_of_eq (Nat.zero_add k).symm))
    (Nat.le_trans (renews 0) (Nat.le_trans (Nat.le_add_left r y) holds)) long

/-- No open course draws across `n + 1` steps more than the start with what is given there and `r`
for each step after, where `R` gives at most `r`. -/
theorem open_le_most (renews : ∀ z, R z ≤ r) {x : Nat → Nat} (opens : OpenCourse R k s x)
    (n : Nat) : drawnOver R x (n + 1) ≤ s + R s + r * n :=
  Eq.subst (motive := fun z => drawnOver R x (n + 1) ≤ z + R z + r * n) opens.1
    (drawn_le_most (fun t => (opens.2 t).1) (fun t => renews (x t)) n)

/-- **The holding course is an optimum** of the order by what is drawn. -/
theorem holding_frontier (renews : ∀ z, R z ≤ r) (greatest : R y = r) (reach : y ≤ s + R s)
    (drawsDown : s + R s ≤ y + k) (holds : y + r ≤ k) (long : 0 < n) :
    Frontier (OpenCourse R k s) (byDrawn R n) (holding s y n) :=
  ⟨holding_open renews greatest reach drawsDown holds long, fun _ opens more =>
    Nat.not_le_of_gt more (Nat.le_trans (open_le_most renews opens n)
      (Nat.le_of_eq (holding_most renews greatest reach n).symm))⟩

/-- **Every optimum holds a level of greatest renewal and leaves nothing.** Where `R` gives at most
`r` at every level and `r` at some `y` within the start with what is given there, over a horizon of
at least two steps, with a capacity covering what the first step draws down to `y` and `y` with
`r`, every optimum of every order on the courses open from the start that rises with what is drawn
across `n + 1` steps draws the most: it
stands at a level of greatest renewal at every step from the first to the `n`-th and at nothing
after the last. -/
theorem frontier_holds {better : (Nat → Nat) → (Nat → Nat) → Prop}
    (renews : ∀ z, R z ≤ r)
    (rising : ∀ a b, drawnOver R a (n + 1) < drawnOver R b (n + 1) → better b a)
    (greatest : R y = r) (reach : y ≤ s + R s) (drawsDown : s + R s ≤ y + k)
    (holds : y + r ≤ k) (long : 0 < n) {x : Nat → Nat}
    (front : Frontier (OpenCourse R k s) better x) :
    x (n + 1) = 0 ∧ ∀ t, t < n → R (x (t + 1)) = r :=
  have most : drawnOver R x (n + 1) = s + R s + r * n :=
    Nat.le_antisymm (open_le_most renews front.1 n)
      (match Nat.lt_or_ge (drawnOver R x (n + 1)) (s + R s + r * n) with
      | .inl less => absurd (rising x (holding s y n) (Nat.lt_of_lt_of_le less
          (Nat.le_of_eq (holding_most renews greatest reach n).symm)))
          (front.2 _ (holding_open renews greatest reach drawsDown holds long))
      | .inr ge => ge)
  (most_iff (fun t => (front.1.2 t).1) (fun t => renews (x t)) n).mp
    (Eq.subst (motive := fun z => drawnOver R x (n + 1) = z + R z + r * n) front.1.1.symm most)

/-! ### Valuing what is left at the horizon -/

/-- The order of courses by what they draw across `n + 1` steps with what they leave after them,
valued alike: more is better. -/
def byDrawnLeft (R : Nat → Nat) (n : Nat) (b a : Nat → Nat) : Prop :=
  drawnOver R a (n + 1) + a (n + 1) < drawnOver R b (n + 1) + b (n + 1)

/-- No open course draws and leaves across `n + 1` steps more than the start with what is given there
and `r` for each step after, where `R` gives at most `r`. -/
theorem open_left_le_most (renews : ∀ z, R z ≤ r) {x : Nat → Nat} (opens : OpenCourse R k s x)
    (n : Nat) : drawnOver R x (n + 1) + x (n + 1) ≤ s + R s + r * n :=
  Eq.subst (motive := fun z => drawnOver R x (n + 1) + x (n + 1) ≤ z + R z + r * n) opens.1
    (drawn_add_left_le_most (fun t => (opens.2 t).1) (fun t => renews (x t)) n)

/-- The course holding `y` and leaving it stands at `y` at every step after its start. -/
theorem holdingTo_same (t : Nat) : holdingTo s y y n (t + 1) = y :=
  match Nat.lt_or_ge t n with
  | .inl before => holdingTo_before before
  | .inr after => holdingTo_after after

/-- **A course holding a level of greatest renewal and leaving it draws and leaves the most.** Where
`R` gives at most `r` at every level and `r` at `y`, within the start with what is given there, the
course holding `y` and leaving it draws across `n + 1` steps, with what it leaves after them, the
start with what is given there and `r` for each step after. -/
theorem keeping_left_most (renews : ∀ z, R z ≤ r) (greatest : R y = r) (reach : y ≤ s + R s)
    (n : Nat) :
    drawnOver R (holdingTo s y y n) (n + 1) + holdingTo s y y n (n + 1) = s + R s + r * n :=
  (most_left_iff (x := holdingTo s y y n) (g := fun t => R (holdingTo s y y n t))
    (holdingTo_within reach (Nat.le_refl y)) (fun _ => renews _) n).mpr
    fun t _ => (congrArg R (holdingTo_same t)).trans greatest

/-- **The course holding a level of greatest renewal and leaving it is open**, over any horizon, with
a capacity covering what the first step draws down to it and `r`: after the first step it draws only
what is given. -/
theorem keeping_open (greatest : R y = r) (reach : y ≤ s + R s) (drawsDown : s + R s ≤ y + k)
    (holds : r ≤ k) : OpenCourse R k s (holdingTo s y y n) :=
  ⟨rfl, fun t => ⟨holdingTo_within reach (Nat.le_refl y) t, match t with
    | 0 => drawnAt_le_of (Nat.le_trans drawsDown
        (Nat.le_of_eq (congrArg (· + k) (holdingTo_same 0).symm)))
    | j + 1 => drawnAt_le_of (by
        show holdingTo s y y n (j + 1) + R (holdingTo s y y n (j + 1)) ≤
          holdingTo s y y n (j + 1 + 1) + k
        rw [holdingTo_same j, holdingTo_same (j + 1), greatest]
        exact Nat.add_le_add_left holds y)⟩⟩

/-- **Keeping is an optimum when what is left is valued.** The course holding a level of greatest
renewal and leaving it is an optimum of the order by what is drawn and left alike. -/
theorem keeping_frontier_left (renews : ∀ z, R z ≤ r) (greatest : R y = r) (reach : y ≤ s + R s)
    (drawsDown : s + R s ≤ y + k) (holds : r ≤ k) :
    Frontier (OpenCourse R k s) (byDrawnLeft R n) (holdingTo s y y n) :=
  ⟨keeping_open greatest reach drawsDown holds, fun _ opens more =>
    Nat.not_le_of_gt more (Nat.le_trans (open_left_le_most renews opens n)
      (Nat.le_of_eq (keeping_left_most renews greatest reach n).symm))⟩

/-- **Draining at the end is an optimum too.** The course holding a level of greatest renewal and
leaving nothing is an optimum of the order by what is drawn and left alike: valuing what is left as
much as what is drawn makes the last step's draw indifferent. -/
theorem holding_frontier_left (renews : ∀ z, R z ≤ r) (greatest : R y = r) (reach : y ≤ s + R s)
    (drawsDown : s + R s ≤ y + k) (holds : y + r ≤ k) (long : 0 < n) :
    Frontier (OpenCourse R k s) (byDrawnLeft R n) (holding s y n) :=
  ⟨holding_open renews greatest reach drawsDown holds long, fun _ opens more =>
    Nat.not_le_of_gt more (Nat.le_trans (open_left_le_most renews opens n)
      (Nat.le_of_eq ((congr (congrArg HAdd.hAdd (holding_most renews greatest reach n))
        (holding_after (Nat.le_refl n))).trans (Nat.add_zero _)).symm))⟩

/-- **Without valuing what is left, keeping is no optimum.** Where a level of greatest renewal is
positive, the course holding it and leaving it is not an optimum of the order by what is drawn alone,
whose every optimum leaves nothing (`frontier_holds`). -/
theorem keeping_not_frontier (renews : ∀ z, R z ≤ r) (greatest : R y = r) (reach : y ≤ s + R s)
    (drawsDown : s + R s ≤ y + k) (holds : y + r ≤ k) (long : 0 < n) (positive : 0 < y) :
    ¬ Frontier (OpenCourse R k s) (byDrawn R n) (holdingTo s y y n) := fun front =>
  Nat.lt_irrefl 0 (Eq.subst (motive := fun z => 0 < z)
    ((holdingTo_after (Nat.le_refl n)).symm.trans
      (frontier_holds renews (fun _ _ more => more) greatest reach drawsDown holds long front).1)
    positive)

/-- **Every optimum valuing what is left holds a level of greatest renewal to the horizon.** Where `R`
gives at most `r` at every level and `r` at some `y` within the start with what is given there, over
any horizon, with a capacity covering what the first step draws down to `y` and `r`, every optimum of every order on the courses open from the start that rises with what is
drawn across `n + 1` steps and what is left after them, valued alike, stands at a level of greatest
renewal at every step from the first to the `n`-th; what it leaves is not fixed. -/
theorem frontier_holds_left {better : (Nat → Nat) → (Nat → Nat) → Prop}
    (renews : ∀ z, R z ≤ r)
    (rising : ∀ a b, drawnOver R a (n + 1) + a (n + 1) < drawnOver R b (n + 1) + b (n + 1) →
      better b a)
    (greatest : R y = r) (reach : y ≤ s + R s) (drawsDown : s + R s ≤ y + k)
    (holds : r ≤ k) {x : Nat → Nat}
    (front : Frontier (OpenCourse R k s) better x) : ∀ t, t < n → R (x (t + 1)) = r :=
  have most : drawnOver R x (n + 1) + x (n + 1) = s + R s + r * n :=
    Nat.le_antisymm (open_left_le_most renews front.1 n)
      (match Nat.lt_or_ge (drawnOver R x (n + 1) + x (n + 1)) (s + R s + r * n) with
      | .inl less => absurd (rising x (holdingTo s y y n) (Nat.lt_of_lt_of_le less
          (Nat.le_of_eq (keeping_left_most renews greatest reach n).symm)))
          (front.2 _ (keeping_open greatest reach drawsDown holds))
      | .inr ge => ge)
  (most_left_iff (fun t => (front.1.2 t).1) (fun t => renews (x t)) n).mp
    (Eq.subst (motive := fun z => drawnOver R x (n + 1) + x (n + 1) = z + R z + r * n)
      front.1.1.symm most)

/-- **Exactly the optima valuing what is left.** Under the same conditions, the optima of the order by
what is drawn and left alike are exactly the open courses standing at a level of greatest renewal at
every step from the first to the `n`-th. -/
theorem frontier_left_iff (renews : ∀ z, R z ≤ r) (greatest : R y = r) (reach : y ≤ s + R s)
    (drawsDown : s + R s ≤ y + k) (holds : r ≤ k) {x : Nat → Nat} :
    Frontier (OpenCourse R k s) (byDrawnLeft R n) x ↔
      OpenCourse R k s x ∧ ∀ t, t < n → R (x (t + 1)) = r :=
  ⟨fun front => ⟨front.1,
     frontier_holds_left renews (fun _ _ more => more) greatest reach drawsDown holds front⟩,
   fun ⟨opens, renewed⟩ => ⟨opens, fun _ opens' more => Nat.not_le_of_gt more
     (Nat.le_trans (open_left_le_most renews opens' n) (Nat.le_of_eq
       (Eq.subst (motive := fun z => drawnOver R x (n + 1) + x (n + 1) = z + R z + r * n) opens.1
         ((most_left_iff (fun t => (opens.2 t).1) (fun t => renews (x t)) n).mpr renewed)).symm))⟩⟩

end Optimum

namespace Flow

open Optimum

variable {L L' : Flow F C} {W W' : Web F C} {c : C} {r : Nat}

/-- **Under balance, what is drawn is what is taken.** -/
theorem Balances.drawnAt_eq (balances : L.Balances W) (c : C) (t : Nat) :
    drawnAt (fun t => W.level t c) (fun t => L.given t c) t = L.taken t c :=
  (congrArg (· - W.level (t + 1) c) (balances t c).symm).trans
    ((congrArg (· - W.level (t + 1) c) (Nat.add_comm _ _)).trans (Naturals.add_sub_cancel _ _))

/-- Under balance, each step leaves at most the level with what is given. -/
theorem Balances.within (balances : L.Balances W) (c : C) (t : Nat) :
    W.level (t + 1) c ≤ W.level t c + L.given t c :=
  Nat.le_trans (Nat.le_add_right _ _) (Nat.le_of_eq (balances t c))

/-- Under balance, everything taken from a condition across `n` steps is what is drawn there. -/
theorem Balances.sum_taken (balances : L.Balances W) (c : C) (n : Nat) :
    Amounts.whole.sum (fun t => L.taken t c) 0 n =
      Amounts.whole.sum (drawnAt (fun t => W.level t c) fun t => L.given t c) 0 n :=
  sum_eq_of_eq fun t _ => (balances.drawnAt_eq c t).symm

/-- **What a balanced course takes, leaves and forgoes.** Where the formations taking part give a
condition at most `r` a step, what they take from it across `n` steps, with its level after them and
everything given there falls short of `r`, is its starting level with `r` for each step. -/
theorem Balances.taken_add_shortfall (balances : L.Balances W) (renews : ∀ t, L.given t c ≤ r)
    (n : Nat) :
    Amounts.whole.sum (fun t => L.taken t c) 0 n + W.level n c +
        Amounts.whole.sum (fun t => r - L.given t c) 0 n = W.level 0 c + r * n := by
  rw [balances.sum_taken c n]
  exact drawn_add_shortfall (balances.within c) renews n

/-- **Balanced courses ranked by what they forgo and leave.** Of two balanced courses from one
level at a condition, each given at most `r` there a step, the first takes from it across `n` steps
at most what the second takes exactly where what the second leaves with everything given to it
falls short of `r` is at most the first's: what is taken registers the levels a course passes
through only through what is given at them. -/
theorem Balances.taken_le_iff (balances : L.Balances W) (balances' : L'.Balances W')
    (renews : ∀ t, L.given t c ≤ r) (renews' : ∀ t, L'.given t c ≤ r)
    (same : W'.level 0 c = W.level 0 c) (n : Nat) :
    Amounts.whole.sum (fun t => L.taken t c) 0 n ≤
        Amounts.whole.sum (fun t => L'.taken t c) 0 n ↔
      W'.level n c + Amounts.whole.sum (fun t => r - L'.given t c) 0 n ≤
        W.level n c + Amounts.whole.sum (fun t => r - L.given t c) 0 n :=
  le_iff_of_add_eq (by
    rw [← Nat.add_assoc, ← Nat.add_assoc, balances.taken_add_shortfall renews n,
      balances'.taken_add_shortfall renews' n, same])

/-- **Alike in what is given and left, alike in what is taken.** Two balanced courses from one
level at a condition, given the same there at each of `n` steps and leaving the same after them,
take the same from it across them, whatever levels they pass through. -/
theorem Balances.taken_eq_of_alike (balances : L.Balances W) (balances' : L'.Balances W')
    (same : W'.level 0 c = W.level 0 c) {n : Nat}
    (given : ∀ t, t < n → L'.given t c = L.given t c)
    (left : W'.level n c = W.level n c) :
    Amounts.whole.sum (fun t => L'.taken t c) 0 n = Amounts.whole.sum (fun t => L.taken t c) 0 n :=
  add_left_cancel_of (k := W.level n c)
    (calc W.level n c + Amounts.whole.sum (fun t => L'.taken t c) 0 n
        = W'.level n c + Amounts.whole.sum (drawnAt (fun t => W'.level t c)
            fun t => L'.given t c) 0 n := by rw [left, balances'.sum_taken c n]
      _ = W'.level 0 c + Amounts.whole.sum (fun t => L'.given t c) 0 n :=
          level_add_drawn_of_within (x := fun t => W'.level t c) (g := fun t => L'.given t c)
            (balances'.within c) n
      _ = W.level 0 c + Amounts.whole.sum (fun t => L.given t c) 0 n := by
          rw [same, sum_eq_of_eq given]
      _ = W.level n c + Amounts.whole.sum (drawnAt (fun t => W.level t c)
            fun t => L.given t c) 0 n :=
          (level_add_drawn_of_within (x := fun t => W.level t c) (g := fun t => L.given t c)
            (balances.within c) n).symm
      _ = W.level n c + Amounts.whole.sum (fun t => L.taken t c) 0 n := by
          rw [balances.sum_taken c n])

/-- **A balanced course is open.** Where what is given to a condition is a law `R` of its level and
what is taken there is at most `k` a step, the course of its levels is open from its start. -/
theorem Balances.open_course {R : Nat → Nat} {k : Nat} (balances : L.Balances W)
    (renewal : ∀ t, L.given t c = R (W.level t c)) (within : ∀ t, L.taken t c ≤ k) :
    OpenCourse R k (W.level 0 c) fun t => W.level t c :=
  ⟨rfl, fun t => ⟨Nat.le_trans (balances.within c t) (Nat.le_of_eq
      (congrArg (W.level t c + ·) (renewal t))),
    Nat.le_trans (Nat.le_of_eq ((congrArg (fun z => W.level t c + z - W.level (t + 1) c)
      (renewal t)).symm.trans (balances.drawnAt_eq c t))) (within t)⟩⟩

end Flow

namespace Web

open Optimum

variable {W : Web F C} {c : C} {f : F} {R : Nat → Nat} {k r y m n : Nat}
  {better : (Nat → Nat) → (Nat → Nat) → Prop}

/-- **Far-sight breaks at the first step a dependence above every level of greatest renewal.** Where
what is given to a condition is a law `R` of its level, at most `r` at every level and `r` at some
`y` within the start with what is given there, over a horizon of at least two steps, with a capacity
covering what the first step draws down to `y` and `y` with `r`, and every level where `R` gives `r`
lies below a formation's need on the condition, met at the start: every optimum, among the courses
open from the start, of every order rising with what is drawn across `n + 1` steps breaks the
dependence at the first step and leaves it unmet through the horizon. -/
theorem frontier_broken (renews : ∀ z, R z ≤ r)
    (rising : ∀ a b, drawnOver R a (n + 1) < drawnOver R b (n + 1) → better b a)
    (greatest : R y = r) (reach : y ≤ W.level 0 c + R (W.level 0 c))
    (drawsDown : W.level 0 c + R (W.level 0 c) ≤ y + k) (holds : y + r ≤ k) (long : 0 < n)
    (front : Frontier (OpenCourse R k (W.level 0 c)) better fun t => W.level t c)
    (above : ∀ z, R z = r → z < m) (depends : W.requires 0 f c) (need : W.need 0 f c = m)
    (start : m ≤ W.level 0 c) :
    W.Broken 0 f c ∧ ∀ t, t < n + 1 → W.level (t + 1) c < m :=
  have held := frontier_holds renews rising greatest reach drawsDown holds long front
  have unmet : ∀ t, t < n + 1 → W.level (t + 1) c < m := fun t lt =>
    match Nat.lt_or_ge t n with
    | .inl before => above _ (held.2 t before)
    | .inr after => Eq.subst (motive := fun z => W.level (z + 1) c < m)
        (Nat.le_antisymm after (Nat.le_of_lt_succ lt))
        (Nat.lt_of_le_of_lt (Nat.le_of_eq held.1)
          (Nat.lt_of_le_of_lt (Nat.zero_le y) (above y greatest)))
  ⟨⟨depends, Nat.le_trans (Nat.le_of_eq need) start,
    Nat.lt_of_lt_of_le (unmet 0 (Nat.succ_pos n)) (Nat.le_of_eq need.symm)⟩, unmet⟩

/-- **Far-sight keeps a dependence every level of greatest renewal meets through the horizon, and
breaks it at its end.** Where what is given to a condition is a law `R` of its level, at most `r` at
every level and `r` at some `y` within the start with what is given there, over a horizon of at
least two steps, with a capacity covering what the first step draws down to `y` and `y` with `r`,
and every level where `R` gives `r` meets a formation's positive need on the condition, met at the
start: under every optimum, among the
courses open from the start, of every order rising with what is drawn across `n + 1` steps, the
dependence stands at every step to the `n`-th and is broken at the last. -/
theorem frontier_kept (renews : ∀ z, R z ≤ r)
    (rising : ∀ a b, drawnOver R a (n + 1) < drawnOver R b (n + 1) → better b a)
    (greatest : R y = r) (reach : y ≤ W.level 0 c + R (W.level 0 c))
    (drawsDown : W.level 0 c + R (W.level 0 c) ≤ y + k) (holds : y + r ≤ k) (long : 0 < n)
    (front : Frontier (OpenCourse R k (W.level 0 c)) better fun t => W.level t c)
    (meets : ∀ z, R z = r → m ≤ z) (needs : 0 < m) (depends : W.requires n f c)
    (need : W.need n f c = m) (start : m ≤ W.level 0 c) :
    (∀ t, t ≤ n → m ≤ W.level t c) ∧ W.Broken n f c :=
  have held := frontier_holds renews rising greatest reach drawsDown holds long front
  have stands : ∀ t, t ≤ n → m ≤ W.level t c := fun t le => match t, le with
    | 0, _ => start
    | t + 1, le => meets _ (held.2 t (Nat.lt_of_succ_le le))
  ⟨stands, depends, Nat.le_trans (Nat.le_of_eq need) (stands n (Nat.le_refl n)),
    Nat.lt_of_le_of_lt (Nat.le_of_eq held.1) (Nat.lt_of_lt_of_le needs (Nat.le_of_eq need.symm))⟩

/-- **Valuing what is left, far-sight keeps a dependence every level of greatest renewal meets through
the horizon.** Where what is given to a condition is a law `R` of its level, at most `r` at every level
and `r` at some `y` within the start `s` with what is given there, with a capacity covering what the
first step draws down to `y` and `r`, over any horizon, and every level where `R` gives `r` meets a
need `m` met at the start: under every optimum, among the courses open from the start, of every order
rising with what is drawn across `n + 1` steps and what is left after them, valued alike, the
condition stands at `m` or above at every step to the `n`-th. The course standing at `y` at every step
after the start is such an optimum (`Optimum.keeping_frontier_left`, `Optimum.holdingTo_same`),
keeping the need met past the horizon, where under the order by what is drawn alone every optimum
leaves nothing at the last step (`frontier_kept`; witness `Optimum.Holding.gated_left`). -/
theorem frontier_kept_left {s : Nat} (renews : ∀ z, R z ≤ r)
    (rising : ∀ a b, drawnOver R a (n + 1) + a (n + 1) < drawnOver R b (n + 1) + b (n + 1) →
      better b a)
    (greatest : R y = r) (reach : y ≤ s + R s) (drawsDown : s + R s ≤ y + k) (holds : r ≤ k)
    (front : Frontier (OpenCourse R k s) better fun t => W.level t c)
    (meets : ∀ z, R z = r → m ≤ z) (start : m ≤ s) :
    ∀ t, t ≤ n → m ≤ W.level t c := fun t le => match t, le with
  | 0, _ => Eq.subst (motive := fun z => m ≤ z) front.1.1.symm start
  | t + 1, le => meets _ (frontier_holds_left renews rising greatest reach drawsDown holds front t
      (Nat.lt_of_succ_le le))

/-- **Valuing what is left does not reach a dependence above every level of greatest renewal.** Where
what is given to a condition is a law `R` of its level, at most `r` at every level and `r` at some `y`
within the start `s` with what is given there, over a horizon of at least two steps, with a capacity
covering what the first step draws down to `y` and `r`, and every level where `R` gives `r` lies below
a formation's need on the condition, met at the start: every optimum, among the courses open from the
start, of every order rising with what is drawn and what is left alike breaks the dependence at the
first step and leaves it unmet to the `n`-th (witness `Optimum.Holding.logistic_left`). -/
theorem frontier_broken_left {s : Nat} (renews : ∀ z, R z ≤ r)
    (rising : ∀ a b, drawnOver R a (n + 1) + a (n + 1) < drawnOver R b (n + 1) + b (n + 1) →
      better b a)
    (greatest : R y = r) (reach : y ≤ s + R s) (drawsDown : s + R s ≤ y + k) (holds : r ≤ k)
    (long : 0 < n) (front : Frontier (OpenCourse R k s) better fun t => W.level t c)
    (above : ∀ z, R z = r → z < m) (depends : W.requires 0 f c) (need : W.need 0 f c = m)
    (start : m ≤ s) :
    W.Broken 0 f c ∧ ∀ t, t < n → W.level (t + 1) c < m :=
  have unmet : ∀ t, t < n → W.level (t + 1) c < m := fun t before =>
    above _ (frontier_holds_left renews rising greatest reach drawsDown holds front t before)
  ⟨⟨depends, Nat.le_trans (Nat.le_of_eq need) (Eq.subst (motive := fun z => m ≤ z) front.1.1.symm start),
    Nat.lt_of_lt_of_le (unmet 0 long) (Nat.le_of_eq need.symm)⟩, unmet⟩

end Web

namespace Optimum

namespace Holding

open Diversion DrawnBeyond Drain

/-- What the taker draws from the source at each step of the holding course. -/
def draw (R : Nat → Nat) (s y n : Nat) : Nat → Nat :=
  drawnAt (holding s y n) fun t => R (holding s y n t)

/-- The store along the holding course: everything the taker has drawn. -/
def store (R : Nat → Nat) (s y n : Nat) : Nat → Nat
  | 0 => 0
  | t + 1 => store R s y n t + draw R s y n t

/-- The levels along the holding course. -/
def level (R : Nat → Nat) (s y n : Nat) (t : Nat) : Place → Nat
  | .source => holding s y n t
  | .store => store R s y n t

/-- At each step the taker takes what the holding course draws from the source and gives it to the
store; the dweller gives the source what `R` gives at its level. -/
def course (R : Nat → Nat) (s y n : Nat) : Flow Formation Place where
  present _ := [.taker, .dweller]
  take t f c := match f, c with
    | .taker, .source => draw R s y n t
    | .taker, .store => 0
    | .dweller, _ => 0
  give t f c := match f, c with
    | .taker, .store => draw R s y n t
    | .taker, .source => 0
    | .dweller, .source => R (holding s y n t)
    | .dweller, .store => 0

variable {R : Nat → Nat} {s y n : Nat}

/-- The holding course balances: the source loses what the taker draws and gains what `R` gives;
the store gains what the taker draws. -/
theorem course_balances (reach : y ≤ s + R s) : (course R s y n).Balances (web (level R s y n)) :=
  fun t c => match c with
  | .source => show holding s y n (t + 1) + (draw R s y n t + 0) =
      holding s y n t + (0 + (R (holding s y n t) + 0)) by
    rw [Nat.add_zero, Nat.add_zero, Nat.zero_add]
    exact Naturals.add_sub_of_le (holding_within reach n t)
  | .store => show store R s y n (t + 1) + (0 + 0) = store R s y n t + (draw R s y n t + 0) from
    rfl

/-- The logistic law with room for two, `s (2 - s)`: one unit renewed at level one, nothing at
none or at two or more. -/
def logistic (s : Nat) : Nat := s * (2 - s)

/-- The logistic law gives one unit at one and nothing from two on. -/
theorem logistic_beyond (s : Nat) : logistic (s + 2) = 0 :=
  (congrArg ((s + 2) * ·) (sub_eq_zero_of_le (Nat.le_add_left 2 s))).trans (Nat.mul_zero _)

/-- The logistic law gives at most one. -/
theorem logistic_le : ∀ s, logistic s ≤ 1
  | 0 => Nat.zero_le 1
  | 1 => Nat.le_refl 1
  | s + 2 => Nat.le_trans (Nat.le_of_eq (logistic_beyond s)) (Nat.zero_le 1)

/-- The logistic law gives one only at one, below the dweller's need. -/
theorem logistic_greatest : ∀ z, logistic z = 1 → z < 2
  | 0, zero => absurd zero (Naturals.succ_ne_zero 0).symm
  | 1, _ => Nat.lt_succ_self 1
  | s + 2, one => absurd ((logistic_beyond s).symm.trans one) (Naturals.succ_ne_zero 0).symm

/-- **The logistic witness: far-sight breaks the dweller.** From a source at two, the level the
dweller needs and where the logistic law renews nothing, the course holding the source at one, where
the law renews most, balances and is an optimum of the order by what the taker draws across
`n + 2` steps among the courses open to it with capacity two; it breaks the dweller's dependence at
the first step and leaves it unmet through the horizon, as every such optimum does
(`Web.frontier_broken`). -/
theorem logistic_broken (n : Nat) :
    (course logistic 2 1 (n + 1)).Balances (web (level logistic 2 1 (n + 1))) ∧
      Frontier (OpenCourse logistic 2 2) (byDrawn logistic (n + 1)) (holding 2 1 (n + 1)) ∧
      (web (level logistic 2 1 (n + 1))).Broken 0 .dweller .source ∧
      ∀ t, t < n + 2 → (web (level logistic 2 1 (n + 1))).level (t + 1) .source < 2 :=
  have front :
      Frontier (OpenCourse logistic 2 2) (byDrawn logistic (n + 1)) (holding 2 1 (n + 1)) :=
    holding_frontier logistic_le rfl (Nat.le_succ 1) (Nat.le_succ 2) (Nat.le_refl 2)
      (Nat.succ_pos n)
  ⟨course_balances (Nat.le_succ 1), front,
   Web.frontier_broken (W := web (level logistic 2 1 (n + 1))) (c := Place.source)
     (f := Formation.dweller) (y := 1) logistic_le (fun _ _ more => more) rfl (Nat.le_succ 1)
     (Nat.le_succ 2) (Nat.le_refl 2) (Nat.succ_pos n) front logistic_greatest trivial rfl
     (Nat.le_refl 2)⟩

/-- A gate: one unit renewed at every level from one, nothing at none. -/
def gate : Nat → Nat
  | 0 => 0
  | _ + 1 => 1

/-- The gate gives at most one. -/
theorem gate_le : ∀ s, gate s ≤ 1
  | 0 => Nat.zero_le 1
  | _ + 1 => Nat.le_refl 1

/-- **The gated witness: the order registers nothing of a dependence above the gate.** From a source
at two, under a gate renewing one unit at every level from one, the course holding the source at two
and the course holding it at one are both optima of the order by what the taker draws across `n + 2`
steps among the courses open to it with capacity three, and the taker takes the same from the
source along both (`Flow.Balances.taken_eq_of_alike`); the first keeps the dweller's dependence at
every step to the `(n + 1)`-th, the second breaks it at the first step. -/
theorem gated_alike (n : Nat) :
    Frontier (OpenCourse gate 3 2) (byDrawn gate (n + 1)) (holding 2 2 (n + 1)) ∧
      Frontier (OpenCourse gate 3 2) (byDrawn gate (n + 1)) (holding 2 1 (n + 1)) ∧
      Amounts.whole.sum (fun t => (course gate 2 1 (n + 1)).taken t .source) 0 (n + 2) =
        Amounts.whole.sum (fun t => (course gate 2 2 (n + 1)).taken t .source) 0 (n + 2) ∧
      (∀ t, t ≤ n + 1 → 2 ≤ (web (level gate 2 2 (n + 1))).level t .source) ∧
      (web (level gate 2 1 (n + 1))).Broken 0 .dweller .source :=
  have alike : ∀ t, t < n + 2 →
      (course gate 2 1 (n + 1)).given t .source = (course gate 2 2 (n + 1)).given t .source :=
    fun t lt => congrArg (fun z => 0 + (z + 0)) (match t, lt with
      | 0, _ => rfl
      | _ + 1, lt =>
        have before := Nat.lt_of_succ_lt_succ lt
        (congrArg gate (holding_before (s := 2) (y := 1) before)).trans
          (congrArg gate (holding_before (s := 2) (y := 2) before)).symm)
  ⟨holding_frontier gate_le rfl (Nat.le_succ 2) (Nat.le_add_left 3 2) (Nat.le_refl 3)
     (Nat.succ_pos n),
   holding_frontier gate_le rfl (Nat.le_trans (Nat.le_succ 1) (Nat.le_succ 2)) (Nat.le_succ 3)
     (Nat.le_succ 2) (Nat.succ_pos n),
   Flow.Balances.taken_eq_of_alike (L := course gate 2 2 (n + 1))
     (W := web (level gate 2 2 (n + 1)))
     (L' := course gate 2 1 (n + 1)) (W' := web (level gate 2 1 (n + 1))) (c := Place.source)
     (n := n + 2) (course_balances (Nat.le_succ 2))
     (course_balances (Nat.le_trans (Nat.le_succ 1) (Nat.le_succ 2))) rfl alike
     ((holding_after (s := 2) (y := 1) (Nat.le_refl (n + 1))).trans
       (holding_after (s := 2) (y := 2) (Nat.le_refl (n + 1))).symm),
   fun t le => match t, le with
     | 0, _ => Nat.le_refl 2
     | _ + 1, le => Nat.le_of_eq (holding_before (s := 2) (y := 2) (Nat.lt_of_succ_le le)).symm,
   trivial, Nat.le_refl 2,
   Nat.lt_of_le_of_lt (Nat.le_of_eq (holding_before (s := 2) (y := 1) (Nat.succ_pos n)))
     (Nat.lt_succ_self 1)⟩

end Holding

end Optimum

/-! ## What keeping a dependence forgoes over a horizon

Above, every optimum of an order rising with what is drawn holds a level of greatest renewal. Here
a condition is kept at a need `m` or above through the `n + 1` steps of a horizon. Where what is
given at or above `m` is at most `q`, what a course keeping it draws, with what it leaves, is at
most the start with what is given there and `q` for each step after; among the courses keeping it,
the optima of every order rising with what is drawn hold a level where `q` is given and leave
exactly `m`. Against the course holding a level where `r` is given and leaving nothing, keeping
forgoes `(r - q) n + m`. So an order adding to what a keeping course draws a coupling below that
has only optima falling below the need within the horizon, and one adding more to a keeping course
and nothing to a course falling below the need has only optima keeping it; where the worth adds
exactly the coupling, both have optima, so neither holds vacuously. Where `q < r`, what
keeping forgoes grows with the horizon, and every coupling below the horizon with the need is
outweighed. The courses that attain these bounds draw nothing after the horizon, so nothing is
supposed about what lies beyond it; where the capacity cannot draw down to nothing or to the need,
the end `e` it can reach enters the thresholds. -/

namespace Optimum

/-- A course keeps its level at `m` or above through the `n + 1` steps of a horizon. -/
def Keeps (m n : Nat) (x : Nat → Nat) : Prop := ∀ t, t ≤ n + 1 → m ≤ x t

/-- A step at most one past `n` is at most `n` or one past it. -/
theorem le_or_eq_succ {t n : Nat} (le : t ≤ n + 1) : t ≤ n ∨ t = n + 1 :=
  match Nat.lt_or_ge t (n + 1) with
  | .inl lt => .inl (Nat.le_of_lt_succ lt)
  | .inr ge => .inr (Nat.le_antisymm le ge)

variable {R : Nat → Nat} {k q r s y m n : Nat}

/-- **What a course keeping a need draws and leaves.** Where each step leaves at most the level with
what `R` gives there, `R` gives at most `q` at every level at or above `m`, and a course keeps its
level at `m` or above through `n + 1` steps, what it draws across them with what it leaves is at
most its start with what is given there and `q` for each step after. -/
theorem keeping_le_most (above : ∀ z, m ≤ z → R z ≤ q) {x : Nat → Nat}
    (within : ∀ t, x (t + 1) ≤ x t + R (x t)) (keeps : Keeps m n x) :
    drawnOver R x (n + 1) + x (n + 1) ≤ x 0 + R (x 0) + q * n :=
  Nat.le_trans (Nat.le_add_right _ _) (Nat.le_of_eq
    (drawn_add_shortfall_after_up_to (x := x) (g := fun t => R (x t)) (r := q) (n := n) within
      fun t lt => above _ (keeps (t + 1) (Nat.succ_le_succ (Nat.le_of_lt lt)))))

/-- What a course keeping a need draws, with the need, is at most its start with what is given there
and `q` for each step after. -/
theorem keeping_drawn_le (above : ∀ z, m ≤ z → R z ≤ q) {x : Nat → Nat}
    (within : ∀ t, x (t + 1) ≤ x t + R (x t)) (keeps : Keeps m n x) :
    drawnOver R x (n + 1) + m ≤ x 0 + R (x 0) + q * n :=
  Nat.le_trans (Nat.add_le_add_left (keeps (n + 1) (Nat.le_refl _)) _)
    (keeping_le_most above within keeps)

/-- **What the course holding a level draws.** Where `R` gives `r` at `y`, within the start with
what is given there, the course holding `y` to the `n`-th step and ending at `e` at most `y` draws
across `n + 1` steps, with `e`, the start with what is given there and `r` for each step after. -/
theorem holdingTo_most {e : Nat} (greatest : R y = r) (reach : y ≤ s + R s) (settles : e ≤ y)
    (n : Nat) : drawnOver R (holdingTo s y e n) (n + 1) + e = s + R s + r * n := by
  have whole := drawn_add_shortfall_after_up_to (x := holdingTo s y e n)
    (g := fun t => R (holdingTo s y e n t)) (r := r) (n := n) (holdingTo_within reach settles)
    fun t lt => Nat.le_of_eq ((congrArg R (holdingTo_before lt)).trans greatest)
  have none : Amounts.whole.sum (fun t => r - R (holdingTo s y e n (t + 1))) 0 n = 0 :=
    sum_eq_zero_iff.mpr fun t lt =>
      (congrArg (fun z => r - R z) (holdingTo_before lt)).trans
        ((congrArg (r - ·) greatest).trans (Nat.sub_self r))
  rw [holdingTo_after (Nat.le_refl n), none, Nat.add_zero] at whole
  exact whole

/-- The course holding `y` at or above `m`, from a start at or above `m` and ending at `e` at or
above `m`, keeps its level at `m` or above. -/
theorem holdingTo_keeps {e : Nat} (meets : m ≤ s) (needs : m ≤ y) (ends : m ≤ e) :
    Keeps m n (holdingTo s y e n) :=
  fun t _ => match t with
  | 0 => meets
  | t + 1 => match Nat.lt_or_ge t n with
    | .inl before => Nat.le_trans needs (Nat.le_of_eq (holdingTo_before before).symm)
    | .inr after => Nat.le_trans ends (Nat.le_of_eq (holdingTo_after after).symm)

/-- The course `x` through the `n + 1` steps of a horizon, drawing nothing after them. -/
def continued (R : Nat → Nat) (x : Nat → Nat) (n : Nat) : Nat → Nat
  | 0 => x 0
  | t + 1 => if t ≤ n then x (t + 1) else continued R x n t + R (continued R x n t)

/-- The continued course stands where the course does through the horizon. -/
theorem continued_le {x : Nat → Nat} : ∀ {t : Nat}, t ≤ n + 1 → continued R x n t = x t
  | 0, _ => rfl
  | _ + 1, le => if_pos (Nat.le_of_succ_le_succ le)

/-- After the horizon the continued course draws nothing. -/
theorem continued_after {x : Nat → Nat} {t : Nat} (after : n < t) :
    continued R x n (t + 1) = continued R x n t + R (continued R x n t) :=
  if_neg (Nat.not_le_of_gt after)

/-- **A course open through the horizon continues openly.** A course from `s` whose steps to the
`n`-th leave at most the level with what is given and draw at most `k`, continued by drawing
nothing after them, is open. -/
theorem continued_open {x : Nat → Nat} (start : x 0 = s)
    (steps : ∀ t, t ≤ n → x (t + 1) ≤ x t + R (x t) ∧ drawnAt x (fun t => R (x t)) t ≤ k) :
    OpenCourse R k s (continued R x n) :=
  ⟨start, fun t => match Nat.lt_or_ge n t with
    | .inr le => by
      show continued R x n (t + 1) ≤ continued R x n t + R (continued R x n t) ∧
        continued R x n t + R (continued R x n t) - continued R x n (t + 1) ≤ k
      rw [continued_le (Nat.le_succ_of_le le), continued_le (Nat.succ_le_succ le)]
      exact steps t le
    | .inl after => by
      show continued R x n (t + 1) ≤ continued R x n t + R (continued R x n t) ∧
        continued R x n t + R (continued R x n t) - continued R x n (t + 1) ≤ k
      rw [continued_after after, Nat.sub_self]
      exact ⟨Nat.le_refl _, Nat.zero_le k⟩⟩

/-- The continued course draws across the horizon what the course draws. -/
theorem continued_drawn {x : Nat → Nat} :
    drawnOver R (continued R x n) (n + 1) = drawnOver R x (n + 1) :=
  sum_eq_of_eq fun t lt => by
    show continued R x n t + R (continued R x n t) - continued R x n (t + 1) =
      x t + R (x t) - x (t + 1)
    rw [continued_le (Nat.le_succ_of_le (Nat.le_of_lt_succ lt)),
      continued_le (Nat.succ_le_succ (Nat.le_of_lt_succ lt))]

/-- The continued course keeps its level at `m` or above through the horizon where the course
does. -/
theorem continued_keeps {x : Nat → Nat} (keeps : Keeps m n x) : Keeps m n (continued R x n) :=
  fun t le => Nat.le_trans (keeps t le) (Nat.le_of_eq (continued_le le).symm)

/-- Comparing worths below what keeping forgoes. -/
theorem lt_of_forgone_below {A D Wa Da S w q' r' e : Nat} (coupled : A ≤ D + w)
    (kept : D + m ≤ S + q') (most : Da + e = S + r') (draws : Da ≤ Wa)
    (below : w + q' + e < r' + m) : A < Wa := by
  have less : A + (m + e) < Wa + (m + e) :=
    calc A + (m + e) ≤ D + w + (m + e) := Nat.add_le_add_right coupled _
      _ = D + m + (w + e) := by
        rw [Nat.add_assoc D w, Nat.add_assoc D m, Nat.add_left_comm w m e]
      _ ≤ S + q' + (w + e) := Nat.add_le_add_right kept _
      _ = S + (w + q' + e) := by
        rw [Nat.add_assoc S q' (w + e), Nat.add_left_comm q' w e, Nat.add_assoc w q' e]
      _ < S + (r' + m) := Nat.add_lt_add_left below _
      _ = Da + e + m := by rw [← Nat.add_assoc, ← most]
      _ ≤ Wa + e + m := Nat.add_le_add_right (Nat.add_le_add_right draws e) m
      _ = Wa + (m + e) := by rw [Nat.add_assoc, Nat.add_comm e m]
  exact Nat.lt_of_add_lt_add_right less

/-- Comparing worths beyond what keeping forgoes. -/
theorem lt_of_forgone_beyond {A D Wa Da S w q' r' e : Nat} (uncoupled : A ≤ D)
    (bound : D ≤ S + r') (most : Da + e = S + q') (coupled : Da + w ≤ Wa)
    (beyond : r' + e < w + q') : A < Wa := by
  have less : A + e < Wa + e :=
    calc A + e ≤ S + r' + e := Nat.add_le_add_right (Nat.le_trans uncoupled bound) e
      _ = S + (r' + e) := Nat.add_assoc _ _ _
      _ < S + (w + q') := Nat.add_lt_add_left beyond _
      _ = Da + e + w := by rw [Nat.add_comm w q', ← Nat.add_assoc, ← most]
      _ = Da + w + e := Nat.add_right_comm _ _ _
      _ ≤ Wa + e := Nat.add_le_add_right coupled e
  exact Nat.lt_of_add_lt_add_right less

/-- **Among the courses keeping a need, the optima hold its greatest renewal and leave the need.**
Where `R` gives at most `q` at every level at or above `m` and `q` at some `y` at or above `m`
within the start with what is given there, from a start meeting `m`, over a horizon of at least two
steps, with a capacity covering what the first step draws down to `y` and `y` with `q` down to
`m`: every optimum, among the open courses keeping their level at `m` or above through the horizon,
of every order rising with what is drawn across `n + 1` steps stands where `R` gives `q` at every
step to the `n`-th and at `m` after the last. -/
theorem frontier_keeps {better : (Nat → Nat) → (Nat → Nat) → Prop}
    (above : ∀ z, m ≤ z → R z ≤ q)
    (rising : ∀ a b, drawnOver R a (n + 1) < drawnOver R b (n + 1) → better b a)
    (greatest : R y = q) (needs : m ≤ y) (meets : m ≤ s) (reach : y ≤ s + R s)
    (drawsDown : s + R s ≤ y + k) (holds : y + q ≤ m + k) (long : 0 < n)
    {x : Nat → Nat} (front : Frontier (fun a => OpenCourse R k s a ∧ Keeps m n a) better x) :
    x (n + 1) = m ∧ ∀ t, t < n → R (x (t + 1)) = q := by
  have opens : OpenCourse R k s (continued R (holdingTo s y m n) n) :=
    continued_open (x := holdingTo s y m n) rfl
      (holdingTo_steps greatest reach needs drawsDown holds long)
  have most := holdingTo_most (n := n) greatest reach needs
  have atLeast : drawnOver R (holdingTo s y m n) (n + 1) ≤ drawnOver R x (n + 1) :=
    Nat.ge_of_not_lt fun less =>
      front.2 _ ⟨opens, continued_keeps (holdingTo_keeps meets needs (Nat.le_refl m))⟩
        (rising x _ (Nat.lt_of_lt_of_le less (Nat.le_of_eq continued_drawn.symm)))
  have whole : drawnOver R x (n + 1) + x (n + 1) +
      Amounts.whole.sum (fun t => q - R (x (t + 1))) 0 n = x 0 + R (x 0) + q * n :=
    drawn_add_shortfall_after_up_to (x := x) (g := fun t => R (x t)) (r := q) (n := n)
      (fun t => (front.1.1.2 t).1)
      fun t lt => above _ (front.1.2 (t + 1) (Nat.succ_le_succ (Nat.le_of_lt lt)))
  rw [front.1.1.1, ← most, Nat.add_assoc] at whole
  have rest : x (n + 1) + Amounts.whole.sum (fun t => q - R (x (t + 1))) 0 n ≤ m :=
    Naturals.le_of_add_le_add_left (k := drawnOver R x (n + 1))
      (Nat.le_trans (Nat.le_of_eq whole) (Nat.add_le_add_right atLeast m))
  have stands : m ≤ x (n + 1) := front.1.2 (n + 1) (Nat.le_refl _)
  have none : Amounts.whole.sum (fun t => q - R (x (t + 1))) 0 n = 0 :=
    Nat.le_antisymm (Naturals.le_of_add_le_add_left (k := x (n + 1))
      (Nat.le_trans rest (Nat.le_trans stands (Nat.le_of_eq (Nat.add_zero _).symm))))
      (Nat.zero_le _)
  exact ⟨Nat.le_antisymm (Nat.le_trans (Nat.le_add_right _ _) rest) stands, fun t lt =>
    Nat.le_antisymm (above _ (front.1.2 (t + 1) (Nat.succ_le_succ (Nat.le_of_lt lt))))
      (le_of_sub_zero (sum_eq_zero_iff.mp none t lt))⟩

/-- **A course keeps a need or falls after meeting it.** A course from a start meeting `m` either
keeps its level at `m` or above through the `n + 1` steps of a horizon or falls below `m`, at some
step to the `n`-th, after standing at `m` or above at every step to it. -/
theorem keeps_or_falls {x : Nat → Nat} (start : m ≤ x 0) :
    ∀ n, Keeps m n x ∨ ∃ t, t ≤ n ∧ (∀ u, u ≤ t → m ≤ x u) ∧ x (t + 1) < m
  | 0 => match Nat.lt_or_ge (x 1) m with
    | .inl lt => .inr ⟨0, Nat.le_refl 0, fun u le => Eq.subst (motive := fun z => m ≤ x z)
        (Nat.le_antisymm le (Nat.zero_le u)).symm start, lt⟩
    | .inr ge => .inl fun t le => match le_or_eq_succ le with
      | .inl first => Eq.subst (motive := fun z => m ≤ x z)
          (Nat.le_antisymm first (Nat.zero_le t)).symm start
      | .inr second => Eq.subst (motive := fun z => m ≤ x z) second.symm ge
  | n + 1 => match keeps_or_falls start n with
    | .inr ⟨t, le, met, lt⟩ => .inr ⟨t, Nat.le_succ_of_le le, met, lt⟩
    | .inl keeps => match Nat.lt_or_ge (x (n + 1 + 1)) m with
      | .inl lt => .inr ⟨n + 1, Nat.le_refl _, keeps, lt⟩
      | .inr ge => .inl fun t le => match le_or_eq_succ le with
        | .inl earlier => keeps t earlier
        | .inr last => Eq.subst (motive := fun z => m ≤ x z) last.symm ge

/-- A course from a start meeting `m` either keeps its level at `m` or above through the `n + 1`
steps of a horizon or falls below `m`, at some step to the `n`-th, from a level meeting it: the
case of `keeps_or_falls`. -/
theorem keeps_or_drops {x : Nat → Nat} (start : m ≤ x 0) (n : Nat) :
    Keeps m n x ∨ ∃ t, t ≤ n ∧ m ≤ x t ∧ x (t + 1) < m :=
  (keeps_or_falls start n).imp id fun ⟨t, le, met, lt⟩ => ⟨t, le, met t (Nat.le_refl t), lt⟩

/-- A course from a start meeting `m` that does not keep its level at `m` or above through the
horizon falls below `m`, at some step to the `n`-th, from a level meeting it. -/
theorem drops_of_not_keeps {x : Nat → Nat} (start : m ≤ x 0) (fails : ¬ Keeps m n x) :
    ∃ t, t ≤ n ∧ m ≤ x t ∧ x (t + 1) < m :=
  match keeps_or_drops start n with
  | .inl keeps => absurd keeps fails
  | .inr drops => drops

/-- A course either keeps its level at `m` or above through the `n + 1` steps of a horizon or stands
below `m` at some step through them. -/
theorem keeps_or_below {x : Nat → Nat} : Keeps m n x ∨ ∃ t, t ≤ n + 1 ∧ x t < m :=
  match Nat.lt_or_ge (x 0) m with
  | .inl lt => .inr ⟨0, Nat.zero_le _, lt⟩
  | .inr start => match keeps_or_drops start n with
    | .inl keeps => .inl keeps
    | .inr ⟨t, le, _, lt⟩ => .inr ⟨t + 1, Nat.succ_le_succ le, lt⟩

/-- **The optimum among the courses keeping a need.** Under the premises of `frontier_keeps`, the
course holding `y` to the `n`-th step, standing at `m` after the last and drawing nothing after it,
is an optimum, among the open courses keeping their level at `m` or above through the horizon, of
the order by what is drawn. -/
theorem continued_keeping_frontier (above : ∀ z, m ≤ z → R z ≤ q)
    (greatest : R y = q) (needs : m ≤ y) (meets : m ≤ s) (reach : y ≤ s + R s)
    (drawsDown : s + R s ≤ y + k) (holds : y + q ≤ m + k) (long : 0 < n) :
    Frontier (fun a => OpenCourse R k s a ∧ Keeps m n a) (byDrawn R n)
      (continued R (holdingTo s y m n) n) :=
  have most : drawnOver R (continued R (holdingTo s y m n) n) (n + 1) + m = s + R s + q * n := by
    rw [continued_drawn]
    exact holdingTo_most greatest reach needs n
  ⟨⟨continued_open (x := holdingTo s y m n) rfl
      (holdingTo_steps greatest reach needs drawsDown holds long),
    continued_keeps (holdingTo_keeps meets needs (Nat.le_refl m))⟩,
   fun b ⟨opens, keeps⟩ more => by
    have kept := keeping_drawn_le above (fun t => (opens.2 t).1) keeps
    rw [opens.1] at kept
    exact Nat.not_le_of_gt more
      (Naturals.le_of_add_le_add_right (Nat.le_trans kept (Nat.le_of_eq most.symm)))⟩

/-- **What keeping forgoes grows with the horizon.** Where `q < r`, every coupling `w` that with an
end `e` is below the horizon with the need is below what keeping forgoes against the course leaving
`e`, `(r - q) n + m - e`, stated as `w + q n + e < r n + m`. -/
theorem forgone_grows {w e : Nat} (less : q < r) (short : w + e < n + m) :
    w + q * n + e < r * n + m :=
  have grows : q * n + n ≤ r * n :=
    Nat.le_trans (Nat.le_of_eq (Nat.succ_mul q n).symm)
      (Nat.mul_le_mul_right n (Nat.succ_le_of_lt less))
  calc w + q * n + e = q * n + (w + e) := by rw [Nat.add_right_comm, Nat.add_comm (w + e)]
    _ < q * n + (n + m) := Nat.add_lt_add_left short _
    _ = q * n + n + m := (Nat.add_assoc _ _ _).symm
    _ ≤ r * n + m := Nat.add_le_add_right grows m

/-- **A coupling below what keeping forgoes leaves no optimum keeping the need.** Where `R` gives
`r` at `y`, within the start with what is given there, over a horizon of at least two steps, with a
capacity covering what the first step draws down to `y` and `y` with `r` down to some `e` at most
`y`, and `R` gives at most `q` at every level at or above `m`: every optimum, among the open
courses, of every order rising with a worth at least what a course draws and at most `w` more for a
course keeping its level at `m` or above falls below `m` within the horizon, where
`w + q n + e < r n + m`. -/
theorem frontier_breaks_below {better : (Nat → Nat) → (Nat → Nat) → Prop}
    {worth : (Nat → Nat) → Nat} {w e : Nat}
    (rising : ∀ a b, worth a < worth b → better b a)
    (draws : ∀ a, drawnOver R a (n + 1) ≤ worth a)
    (coupled : ∀ a, OpenCourse R k s a → Keeps m n a → worth a ≤ drawnOver R a (n + 1) + w)
    (above : ∀ z, m ≤ z → R z ≤ q) (below : w + q * n + e < r * n + m)
    (greatest : R y = r) (reach : y ≤ s + R s) (settles : e ≤ y) (drawsDown : s + R s ≤ y + k)
    (holds : y + r ≤ e + k) (long : 0 < n)
    {x : Nat → Nat} (front : Frontier (OpenCourse R k s) better x) : ¬ Keeps m n x := by
  intro keeps
  have opens : OpenCourse R k s (continued R (holdingTo s y e n) n) :=
    continued_open (x := holdingTo s y e n) rfl
      (holdingTo_steps greatest reach settles drawsDown holds long)
  have most : drawnOver R (continued R (holdingTo s y e n) n) (n + 1) + e = s + R s + r * n := by
    rw [continued_drawn]
    exact holdingTo_most greatest reach settles n
  have kept := keeping_drawn_le above (fun t => (front.1.2 t).1) keeps
  rw [front.1.1] at kept
  exact front.2 _ opens
    (rising x _ (lt_of_forgone_below (coupled x front.1 keeps) kept most (draws _) below))

/-- **An optimum falling below the need.** Where `R` gives at most `r` at every level, under the
premises of `frontier_breaks_below` with the course ending at nothing, and for a worth adding
nothing to what a course standing below `m` within the horizon draws: the course holding `y` to the
`n`-th step, at nothing after the last and drawing nothing after it, is an optimum, among the open
courses, of the order by the worth. -/
theorem continued_breaking_frontier {worth : (Nat → Nat) → Nat} {w : Nat}
    (draws : ∀ a, drawnOver R a (n + 1) ≤ worth a)
    (coupled : ∀ a, OpenCourse R k s a → Keeps m n a → worth a ≤ drawnOver R a (n + 1) + w)
    (uncoupled : ∀ a t, OpenCourse R k s a → t ≤ n + 1 → a t < m →
      worth a ≤ drawnOver R a (n + 1))
    (renews : ∀ z, R z ≤ r) (above : ∀ z, m ≤ z → R z ≤ q) (below : w + q * n < r * n + m)
    (greatest : R y = r) (reach : y ≤ s + R s) (drawsDown : s + R s ≤ y + k)
    (holds : y + r ≤ k) (long : 0 < n) :
    Frontier (OpenCourse R k s) (fun b a => worth a < worth b) (continued R (holding s y n) n) :=
  have most : drawnOver R (continued R (holding s y n) n) (n + 1) = s + R s + r * n :=
    continued_drawn.trans (holding_most renews greatest reach n)
  ⟨continued_open (x := holding s y n) rfl (holdingTo_steps greatest reach (Nat.zero_le y)
      drawsDown (Nat.le_trans holds (Nat.le_of_eq (Nat.zero_add k).symm)) long),
   fun b opens more => Nat.not_le_of_gt more (match keeps_or_below (x := b) with
    | .inl keeps => by
      have kept := keeping_drawn_le above (fun t => (opens.2 t).1) keeps
      rw [opens.1] at kept
      exact Nat.le_of_lt (lt_of_forgone_below (e := 0) (coupled b opens keeps) kept
        ((Nat.add_zero _).trans most) (draws _) below)
    | .inr ⟨t, le, lt⟩ => Nat.le_trans (uncoupled b t opens le lt)
        (Nat.le_trans (open_le_most renews opens n)
          (Nat.le_trans (Nat.le_of_eq most.symm) (draws _))))⟩

/-- **A coupling beyond what keeping forgoes leaves no optimum falling below the need.** Where `R`
gives at most `r` at every level and `q` at some `y` within the start with what is given there, from
a start meeting `m`, over a horizon of at least two steps, with a capacity covering what the first
step draws down to `y` and `y` with `q` down to some `e` between `m` and `y`: every optimum, among
the open courses, of every order rising with a worth adding at least `w` to what a course keeping
its level at `m` or above draws and nothing to what a course falling below `m` within the horizon
draws keeps its level at `m` or above through the horizon, where `r n + e < w + q n`. -/
theorem frontier_keeps_above {better : (Nat → Nat) → (Nat → Nat) → Prop}
    {worth : (Nat → Nat) → Nat} {w e : Nat}
    (rising : ∀ a b, worth a < worth b → better b a)
    (coupled : ∀ a, OpenCourse R k s a → Keeps m n a → drawnOver R a (n + 1) + w ≤ worth a)
    (uncoupled : ∀ a t, OpenCourse R k s a → t ≤ n + 1 → a t < m →
      worth a ≤ drawnOver R a (n + 1))
    (renews : ∀ z, R z ≤ r) (beyond : r * n + e < w + q * n)
    (greatest : R y = q) (meets : m ≤ s) (ends : m ≤ e) (reach : y ≤ s + R s) (settles : e ≤ y)
    (drawsDown : s + R s ≤ y + k) (holds : y + q ≤ e + k) (long : 0 < n)
    {x : Nat → Nat} (front : Frontier (OpenCourse R k s) better x) : Keeps m n x :=
  fun t le => match Nat.lt_or_ge (x t) m with
  | .inr ge => ge
  | .inl lt => by
    have opens : OpenCourse R k s (continued R (holdingTo s y e n) n) :=
      continued_open (x := holdingTo s y e n) rfl
        (holdingTo_steps greatest reach settles drawsDown holds long)
    have most : drawnOver R (continued R (holdingTo s y e n) n) (n + 1) + e =
        s + R s + q * n := by
      rw [continued_drawn]
      exact holdingTo_most greatest reach settles n
    exact absurd (rising x _ (lt_of_forgone_beyond (uncoupled x t front.1 le lt)
      (open_le_most renews front.1 n) most
      (coupled _ opens (continued_keeps (holdingTo_keeps meets (Nat.le_trans ends settles) ends)))
      beyond)) (front.2 _ opens)

/-- **An optimum keeping the need.** Where `R` gives at most `r` at every level, at most `q` at
every level at or above `m`, and `q` at some `y` at or above `m` within the start with what is given
there, from a start meeting `m`, over a horizon of at least two steps, with a capacity covering what
the first step draws down to `y` and `y` with `q` down to `m`, and for a worth adding exactly `w` to
what a course keeping its level at `m` or above draws and nothing to what a course standing below
`m` within the horizon draws, where `r n + m < w + q n`: the course holding `y` to the `n`-th step,
at `m` after the last and drawing nothing after it, is an optimum, among the open courses, of the
order by the worth. -/
theorem continued_kept_frontier {worth : (Nat → Nat) → Nat} {w : Nat}
    (coupled : ∀ a, OpenCourse R k s a → Keeps m n a → drawnOver R a (n + 1) + w ≤ worth a)
    (bounded : ∀ a, OpenCourse R k s a → Keeps m n a → worth a ≤ drawnOver R a (n + 1) + w)
    (uncoupled : ∀ a t, OpenCourse R k s a → t ≤ n + 1 → a t < m →
      worth a ≤ drawnOver R a (n + 1))
    (renews : ∀ z, R z ≤ r) (above : ∀ z, m ≤ z → R z ≤ q) (beyond : r * n + m < w + q * n)
    (greatest : R y = q) (needs : m ≤ y) (meets : m ≤ s) (reach : y ≤ s + R s)
    (drawsDown : s + R s ≤ y + k) (holds : y + q ≤ m + k) (long : 0 < n) :
    Frontier (OpenCourse R k s) (fun b a => worth a < worth b)
      (continued R (holdingTo s y m n) n) :=
  have optimum := continued_keeping_frontier above greatest needs meets reach drawsDown holds long
  have most : drawnOver R (continued R (holdingTo s y m n) n) (n + 1) + m = s + R s + q * n := by
    rw [continued_drawn]
    exact holdingTo_most greatest reach needs n
  have least := coupled _ optimum.1.1 optimum.1.2
  ⟨optimum.1.1, fun b opens more => Nat.not_le_of_gt more (match keeps_or_below (x := b) with
    | .inl keeps => Nat.le_trans (bounded b opens keeps) (Nat.le_trans (Nat.add_le_add_right
        (Nat.ge_of_not_lt (optimum.2 b ⟨opens, keeps⟩)) w) least)
    | .inr ⟨t, le, lt⟩ => Nat.le_of_lt (lt_of_forgone_beyond (uncoupled b t opens le lt)
        (open_le_most renews opens n) most least beyond))⟩

/-! ### Valuing what is left at any worth

With `v` for each unit a course leaves after the horizon, the course holding a level of greatest
renewal and regrowing at the last step to the most any course can leave draws and leaves the most; at
a worth above one every optimum does so, and a coupling of keeping a need is outweighed as without the
value. -/

/-- The order of courses by what they draw across `n + 1` steps with `v` for each unit they leave
after them: more is better. -/
def byDrawnLeftAt (R : Nat → Nat) (v n : Nat) (b a : Nat → Nat) : Prop :=
  drawnOver R a (n + 1) + v * a (n + 1) < drawnOver R b (n + 1) + v * b (n + 1)

/-- At a worth of at least one, what is drawn with `v` for each unit left is what is drawn with what
is left and `v - 1` for each unit left. -/
theorem valued_eq {d l : Nat} : ∀ {v : Nat}, 0 < v → d + v * l = d + l + (v - 1) * l
  | 0, pos => absurd pos (Nat.lt_irrefl 0)
  | j + 1, _ => by
    show d + (j + 1) * l = d + l + j * l
    rw [Nat.succ_mul, Nat.add_comm (j * l) l, Nat.add_assoc]

/-- Two sums each at most another, the sums equal, are each equal. -/
theorem eq_of_add_eq_of_le {a b c d : Nat} (ab : a ≤ b) (cd : c ≤ d) (same : a + c = b + d) :
    a = b ∧ c = d :=
  have first : a = b := Nat.le_antisymm ab (Naturals.le_of_add_le_add_right
    (Nat.le_trans (Nat.le_of_eq same.symm) (Nat.add_le_add_left cd a)))
  ⟨first, Naturals.add_left_cancel (same.trans (congrArg (· + d) first.symm))⟩

/-- Multiplying by a positive number cancels. -/
theorem mul_left_cancel_of_pos {k : Nat} (pos : 0 < k) : ∀ {a b : Nat}, k * a = k * b → a = b
  | 0, 0, _ => rfl
  | 0, b + 1, same => absurd same (Nat.ne_of_lt (Nat.lt_of_lt_of_le pos (Nat.le_add_left k (k * b))))
  | a + 1, 0, same => absurd same.symm
      (Nat.ne_of_lt (Nat.lt_of_lt_of_le pos (Nat.le_add_left k (k * a))))
  | _ + 1, _ + 1, same => congrArg Nat.succ (mul_left_cancel_of_pos pos (Naturals.add_right_cancel same))

/-- **What a course draws with `v` for each unit it leaves, at most.** Where `R` gives at most `r`,
an open course leaving at most `e` after `n + 1` steps draws across them, with `v` of at least one
for each unit it leaves, at most the start with what is given there, `r` for each step after and
`v - 1` for each unit of `e`. -/
theorem open_valued_le_most (renews : ∀ z, R z ≤ r) {v e : Nat} (pos : 0 < v) {x : Nat → Nat}
    (opens : OpenCourse R k s x) (bounded : x (n + 1) ≤ e) :
    drawnOver R x (n + 1) + v * x (n + 1) ≤ s + R s + r * n + (v - 1) * e :=
  Nat.le_trans (Nat.le_of_eq (valued_eq pos))
    (Nat.add_le_add (open_left_le_most renews opens n) (Nat.mul_le_mul_left (v - 1) bounded))

/-- A course drawing and leaving the most, leaving `e`, draws with `v` for each unit it leaves the
start with what is given there, `r` for each step after and `v - 1` for each unit of `e`. -/
theorem valued_of_most {v e : Nat} (pos : 0 < v) {x : Nat → Nat}
    (most : drawnOver R x (n + 1) + x (n + 1) = s + R s + r * n) (left : x (n + 1) = e) :
    drawnOver R x (n + 1) + v * x (n + 1) = s + R s + r * n + (v - 1) * e :=
  (valued_eq pos).trans (Eq.subst (motive := fun z => drawnOver R x (n + 1) + x (n + 1) +
    (v - 1) * z = s + R s + r * n + (v - 1) * e) left.symm (congrArg (· + (v - 1) * e) most))

/-- **Exactly which courses draw and leave the most at a worth above one.** Where `R` gives at most
`r` and `v` exceeds one, an open course leaving at most `e` after `n + 1` steps draws across them,
with `v` for each unit it leaves, the start with what is given there, `r` for each step after and
`v - 1` for each unit of `e` exactly where it stands at a level of greatest renewal at every step
from the first to the `n`-th and leaves `e`. -/
theorem valued_most_iff (renews : ∀ z, R z ≤ r) {v e : Nat} (more : 1 < v) {x : Nat → Nat}
    (opens : OpenCourse R k s x) (bounded : x (n + 1) ≤ e) :
    drawnOver R x (n + 1) + v * x (n + 1) = s + R s + r * n + (v - 1) * e ↔
      (∀ t, t < n → R (x (t + 1)) = r) ∧ x (n + 1) = e :=
  have pos : 0 < v := Nat.lt_trans (Nat.zero_lt_one) more
  have identity := most_left_iff (x := x) (g := fun t => R (x t)) (fun t => (opens.2 t).1)
    (fun t => renews (x t)) n
  have start : x 0 + R (x 0) + r * n = s + R s + r * n :=
    congrArg (fun z => z + R z + r * n) opens.1
  ⟨fun most =>
    have parts := eq_of_add_eq_of_le (open_left_le_most renews opens n)
      (Nat.mul_le_mul_left (v - 1) bounded) ((valued_eq pos).symm.trans most)
    ⟨identity.mp (parts.1.trans start.symm),
     mul_left_cancel_of_pos (SupportGated.sub_pos_of_lt more) parts.2⟩,
   fun ⟨renewed, left⟩ => valued_of_most pos ((identity.mpr renewed).trans start) left⟩

/-- **The course regrowing at the end draws and leaves the most.** Where `R` gives at most `r` and
`r` at `y`, within the start with what is given there, over a horizon of at least two steps, with a
capacity covering what the first step draws down to `y` and `r`, the course holding `y` to the
`n`-th step, regrowing to `y` with `r` at the last and drawing nothing after it, is open, and draws
across `n + 1` steps, with `v` of at least one for each unit it leaves, the start with what is given
there, `r` for each step after and `v - 1` for each unit of `y` with `r`. -/
theorem regrowing_valued (renews : ∀ z, R z ≤ r) {v : Nat} (pos : 0 < v) (greatest : R y = r)
    (reach : y ≤ s + R s) (drawsDown : s + R s ≤ y + k) (middle : r ≤ k) (long : 0 < n) :
    OpenCourse R k s (continued R (holdingTo s y (y + r) n) n) ∧
      drawnOver R (continued R (holdingTo s y (y + r) n) n) (n + 1) +
        v * continued R (holdingTo s y (y + r) n) n (n + 1) =
          s + R s + r * n + (v - 1) * (y + r) :=
  have opens : OpenCourse R k s (continued R (holdingTo s y (y + r) n) n) :=
    continued_open (x := holdingTo s y (y + r) n) rfl
      (holdingTo_steps_of greatest reach (Nat.le_refl _) drawsDown middle (Nat.le_add_right _ k) long)
  have left : continued R (holdingTo s y (y + r) n) n (n + 1) = y + r :=
    (continued_le (Nat.le_refl _)).trans (holdingTo_after (Nat.le_refl n))
  have most := (most_left_iff (x := continued R (holdingTo s y (y + r) n) n)
    (g := fun t => R (continued R (holdingTo s y (y + r) n) n t)) (fun t => (opens.2 t).1)
    (fun _ => renews _) n).mpr fun _ lt =>
      (congrArg R ((continued_le (Nat.succ_le_succ (Nat.le_of_lt lt))).trans
        (holdingTo_before lt))).trans greatest
  ⟨opens, valued_of_most pos most left⟩

/-- **The course regrowing at the end is an optimum at every worth of at least one.** Under the
conditions of `regrowing_valued`, where no open course leaves after `n + 1` steps more than `y` with
`r`, the course holding `y` and regrowing at the last step is an optimum of the order by what is drawn
with `v` for each unit left. -/
theorem regrowing_frontier (renews : ∀ z, R z ≤ r) {v : Nat} (pos : 0 < v)
    (bounded : ∀ a, OpenCourse R k s a → a (n + 1) ≤ y + r) (greatest : R y = r)
    (reach : y ≤ s + R s) (drawsDown : s + R s ≤ y + k) (middle : r ≤ k) (long : 0 < n) :
    Frontier (OpenCourse R k s) (byDrawnLeftAt R v n) (continued R (holdingTo s y (y + r) n) n) :=
  have witness := regrowing_valued renews pos greatest reach drawsDown middle long
  ⟨witness.1, fun a opens more => Nat.not_le_of_gt more (Nat.le_trans
    (open_valued_le_most renews pos opens (bounded a opens)) (Nat.le_of_eq witness.2.symm))⟩

/-- **At a worth above one, every optimum holds a level of greatest renewal and leaves the most.**
Where `R` gives at most `r` at every level and `r` at some `y` within the start with what is given
there, over a horizon of at least two steps, with a capacity covering what the first step draws down
to `y` and `r`, and no open course leaves after `n + 1` steps more than `y` with `r`: every optimum
of every order on the open courses rising with what is drawn across them with `v` above one for each
unit left stands at a level of greatest renewal at every step from the first to the `n`-th and leaves
`y` with `r`, regrown at the last step. -/
theorem frontier_holds_valued {better : (Nat → Nat) → (Nat → Nat) → Prop}
    (renews : ∀ z, R z ≤ r) {v : Nat} (more : 1 < v)
    (rising : ∀ a b, drawnOver R a (n + 1) + v * a (n + 1) < drawnOver R b (n + 1) + v * b (n + 1) →
      better b a)
    (bounded : ∀ a, OpenCourse R k s a → a (n + 1) ≤ y + r) (greatest : R y = r)
    (reach : y ≤ s + R s) (drawsDown : s + R s ≤ y + k) (middle : r ≤ k) (long : 0 < n)
    {x : Nat → Nat} (front : Frontier (OpenCourse R k s) better x) :
    (∀ t, t < n → R (x (t + 1)) = r) ∧ x (n + 1) = y + r :=
  have pos : 0 < v := Nat.lt_trans (Nat.zero_lt_one) more
  have witness := regrowing_valued renews pos greatest reach drawsDown middle long
  (valued_most_iff renews more front.1 (bounded x front.1)).mp
    (Nat.le_antisymm (open_valued_le_most renews pos front.1 (bounded x front.1))
      (Nat.ge_of_not_lt fun less => front.2 _ witness.1
        (rising x _ (Nat.lt_of_lt_of_le less (Nat.le_of_eq witness.2.symm)))))

/-- **Exactly the optima at a worth above one.** Under the conditions of `frontier_holds_valued`, the
optima of the order by what is drawn with `v` above one for each unit left are exactly the open
courses standing at a level of greatest renewal at every step from the first to the `n`-th and
leaving `y` with `r`. -/
theorem frontier_valued_iff (renews : ∀ z, R z ≤ r) {v : Nat} (more : 1 < v)
    (bounded : ∀ a, OpenCourse R k s a → a (n + 1) ≤ y + r) (greatest : R y = r)
    (reach : y ≤ s + R s) (drawsDown : s + R s ≤ y + k) (middle : r ≤ k) (long : 0 < n)
    {x : Nat → Nat} :
    Frontier (OpenCourse R k s) (byDrawnLeftAt R v n) x ↔
      OpenCourse R k s x ∧ (∀ t, t < n → R (x (t + 1)) = r) ∧ x (n + 1) = y + r :=
  ⟨fun front => ⟨front.1, frontier_holds_valued renews more (fun _ _ less => less) bounded greatest
     reach drawsDown middle long front⟩,
   fun ⟨opens, held⟩ => ⟨opens, fun a opens' less => Nat.not_le_of_gt less (Nat.le_trans
     (open_valued_le_most renews (Nat.lt_trans (Nat.zero_lt_one) more) opens' (bounded a opens'))
     (Nat.le_of_eq ((valued_most_iff renews more opens (bounded x opens)).mpr held).symm))⟩⟩

/-- Comparing a keeping course's worth with the regrowing course's, at any worth. -/
theorem lt_of_valued_below {A D L S w q' r' u : Nat} (coupled : A ≤ D + L + u + w)
    (kept : D + L ≤ S + q') (left : u ≤ u') (below : w + q' < r') : A < S + r' + u' :=
  calc A ≤ D + L + u + w := coupled
    _ ≤ S + q' + u' + w := Nat.add_le_add_right (Nat.add_le_add kept left) w
    _ = S + u' + (w + q') := by
      rw [Nat.add_assoc S q' u', Nat.add_comm q' u', ← Nat.add_assoc, Nat.add_assoc, Nat.add_comm q' w]
    _ < S + u' + r' := Nat.add_lt_add_left below _
    _ = S + r' + u' := Nat.add_right_comm _ _ _

/-- **A value on what is left does not change what keeping forgoes.** Where `R` gives at most `r` at
every level, `r` at some `y` within the start with what is given there and at most `q` at every level
at or above `m`, over a horizon of at least two steps, with a capacity covering what the first step
draws down to `y` and `r`, and no open course leaves after `n + 1` steps more than `y` with `r`:
every optimum, among the open courses, of every order rising with a worth at least what a course
draws with `v` of at least one for each unit it leaves, and at most `w` more for a course keeping its
level at `m` or above, falls below `m` within the horizon, where `w + q n < r n`, whatever `v`: the
value on what is left is had by the course that draws down and regrows at the end. -/
theorem frontier_breaks_valued {better : (Nat → Nat) → (Nat → Nat) → Prop}
    {worth : (Nat → Nat) → Nat} {v w : Nat}
    (rising : ∀ a b, worth a < worth b → better b a) (pos : 0 < v)
    (values : ∀ a, drawnOver R a (n + 1) + v * a (n + 1) ≤ worth a)
    (coupled : ∀ a, OpenCourse R k s a → Keeps m n a →
      worth a ≤ drawnOver R a (n + 1) + v * a (n + 1) + w)
    (renews : ∀ z, R z ≤ r) (above : ∀ z, m ≤ z → R z ≤ q) (below : w + q * n < r * n)
    (bounded : ∀ a, OpenCourse R k s a → a (n + 1) ≤ y + r) (greatest : R y = r)
    (reach : y ≤ s + R s) (drawsDown : s + R s ≤ y + k) (middle : r ≤ k) (long : 0 < n)
    {x : Nat → Nat} (front : Frontier (OpenCourse R k s) better x) : ¬ Keeps m n x := fun keeps =>
  have witness := regrowing_valued renews pos greatest reach drawsDown middle long
  have kept : drawnOver R x (n + 1) + x (n + 1) ≤ s + R s + q * n :=
    Eq.subst (motive := fun z => drawnOver R x (n + 1) + x (n + 1) ≤ z + R z + q * n) front.1.1
      (keeping_le_most above (fun t => (front.1.2 t).1) keeps)
  front.2 _ witness.1 (rising x _ (Nat.lt_of_lt_of_le
    (lt_of_valued_below
      (Nat.le_trans (coupled x front.1 keeps) (Nat.le_of_eq (congrArg (· + w) (valued_eq pos))))
      kept (Nat.mul_le_mul_left (v - 1) (bounded x front.1)) below)
    (Nat.le_trans (Nat.le_of_eq witness.2.symm) (values _))))

end Optimum

namespace Flow

open Optimum

variable {L : Flow F C} {W : Web F C} {c : C}

/-- **What a balanced course keeping a need takes.** Where what is given to a condition is a law
`R` of its level, at most `q` at every level at or above `m`, and the course of its levels keeps
them at `m` or above through `n + 1` steps, what is taken there across them, with `m`, is at most
the starting level with what is given there and `q` for each step after. -/
theorem Balances.keeping_taken_le {R : Nat → Nat} {q m n : Nat} (balances : L.Balances W)
    (renewal : ∀ t, L.given t c = R (W.level t c)) (above : ∀ z, m ≤ z → R z ≤ q)
    (keeps : Optimum.Keeps m n fun t => W.level t c) :
    Amounts.whole.sum (fun t => L.taken t c) 0 (n + 1) + m ≤
      W.level 0 c + R (W.level 0 c) + q * n :=
  Nat.le_trans (Nat.le_of_eq (congrArg (· + m) (sum_eq_of_eq fun t _ =>
      ((congrArg (fun z => W.level t c + z - W.level (t + 1) c) (renewal t)).symm.trans
        (balances.drawnAt_eq c t)).symm)))
    (keeping_drawn_le above (fun t => Nat.le_trans (balances.within c t)
      (Nat.le_of_eq (congrArg (W.level t c + ·) (renewal t)))) keeps)

end Flow

namespace Web

open Optimum

variable {W : Web F C} {c : C} {f : F} {R : Nat → Nat} {k q r s y m n w e : Nat}
  {better : (Nat → Nat) → (Nat → Nat) → Prop} {worth : (Nat → Nat) → Nat}

/-- **Among the courses keeping a dependence, the optima leave exactly its need.** Under the
premises of `Optimum.frontier_keeps`, with a formation's need on the condition `m` at the horizon's
last step: every optimum, among the open courses keeping the condition at `m` or above through the
horizon, of every order rising with what is drawn stands at exactly the need after the last step,
and where `R` gives `q` at every step to the `n`-th. -/
theorem frontier_keeps (above : ∀ z, m ≤ z → R z ≤ q)
    (rising : ∀ a b, drawnOver R a (n + 1) < drawnOver R b (n + 1) → better b a)
    (greatest : R y = q) (needs : m ≤ y) (meets : m ≤ s) (reach : y ≤ s + R s)
    (drawsDown : s + R s ≤ y + k) (holds : y + q ≤ m + k) (long : 0 < n)
    (front : Frontier (fun a => OpenCourse R k s a ∧ Optimum.Keeps m n a) better
      fun t => W.level t c)
    (need : W.need (n + 1) f c = m) :
    W.level (n + 1) c = W.need (n + 1) f c ∧ ∀ t, t < n → R (W.level (t + 1) c) = q :=
  have held := Optimum.frontier_keeps above rising greatest needs meets reach drawsDown holds long
    front
  ⟨held.1.trans need.symm, held.2⟩

/-- **A coupling below what keeping forgoes breaks the dependence within the horizon.** Under the
premises of `Optimum.frontier_breaks_below`, with a formation depending on the condition at the need
`m` at every step, met at the start: every optimum, among the open courses, of every order rising
with a worth at least what a course draws and at most `w` more for a course keeping the condition at
`m` or above breaks the dependence at some step to the `n`-th, where `w + q n + e < r n + m`. -/
theorem frontier_breaks_below
    (rising : ∀ a b, worth a < worth b → better b a)
    (draws : ∀ a, drawnOver R a (n + 1) ≤ worth a)
    (coupled : ∀ a, OpenCourse R k s a → Optimum.Keeps m n a →
      worth a ≤ drawnOver R a (n + 1) + w)
    (above : ∀ z, m ≤ z → R z ≤ q) (below : w + q * n + e < r * n + m)
    (greatest : R y = r) (reach : y ≤ s + R s) (settles : e ≤ y) (drawsDown : s + R s ≤ y + k)
    (holds : y + r ≤ e + k) (long : 0 < n)
    (front : Frontier (OpenCourse R k s) better fun t => W.level t c)
    (depends : ∀ t, W.requires t f c) (need : ∀ t, W.need t f c = m) (start : m ≤ s) :
    ∃ t, t ≤ n ∧ W.Broken t f c :=
  match drops_of_not_keeps (Eq.subst (motive := fun z => m ≤ z) front.1.1.symm start)
      (Optimum.frontier_breaks_below rising draws coupled above below greatest reach settles
        drawsDown holds long front) with
  | ⟨t, le, met, lt⟩ => ⟨t, le, depends t, Nat.le_trans (Nat.le_of_eq (need t)) met,
      Nat.lt_of_lt_of_le lt (Nat.le_of_eq (need t).symm)⟩

/-- **Far-sight breaks a dependence above every level of greatest renewal against every coupling
short of the horizon.** Under the premises of `Web.frontier_breaks_below`, where the renewal at or
above the need is below the greatest, `q < r`, and the coupling with the end `e` is below the
horizon with the need: every optimum breaks the dependence within the horizon. -/
theorem frontier_breaks_long
    (rising : ∀ a b, worth a < worth b → better b a)
    (draws : ∀ a, drawnOver R a (n + 1) ≤ worth a)
    (coupled : ∀ a, OpenCourse R k s a → Optimum.Keeps m n a →
      worth a ≤ drawnOver R a (n + 1) + w)
    (above : ∀ z, m ≤ z → R z ≤ q) (less : q < r) (short : w + e < n + m)
    (greatest : R y = r) (reach : y ≤ s + R s) (settles : e ≤ y) (drawsDown : s + R s ≤ y + k)
    (holds : y + r ≤ e + k) (long : 0 < n)
    (front : Frontier (OpenCourse R k s) better fun t => W.level t c)
    (depends : ∀ t, W.requires t f c) (need : ∀ t, W.need t f c = m) (start : m ≤ s) :
    ∃ t, t ≤ n ∧ W.Broken t f c :=
  Web.frontier_breaks_below rising draws coupled above (forgone_grows less short) greatest reach
    settles drawsDown holds long front depends need start

/-- **A coupling beyond what keeping forgoes keeps the dependence through the horizon.** Under the
premises of `Optimum.frontier_keeps_above`, with a formation's need on the condition `m` at every
step: every optimum, among the open courses, of every order rising with a worth adding at least `w`
to what a course keeping the condition at `m` or above draws and nothing to what a course falling
below `m` within the horizon draws meets the need at every step through the horizon, where
`r n + e < w + q n`. -/
theorem frontier_keeps_above
    (rising : ∀ a b, worth a < worth b → better b a)
    (coupled : ∀ a, OpenCourse R k s a → Optimum.Keeps m n a →
      drawnOver R a (n + 1) + w ≤ worth a)
    (uncoupled : ∀ a t, OpenCourse R k s a → t ≤ n + 1 → a t < m →
      worth a ≤ drawnOver R a (n + 1))
    (renews : ∀ z, R z ≤ r) (beyond : r * n + e < w + q * n)
    (greatest : R y = q) (meets : m ≤ s) (ends : m ≤ e) (reach : y ≤ s + R s) (settles : e ≤ y)
    (drawsDown : s + R s ≤ y + k) (holds : y + q ≤ e + k) (long : 0 < n)
    (front : Frontier (OpenCourse R k s) better fun t => W.level t c)
    (need : ∀ t, W.need t f c = m) :
    ∀ t, t ≤ n + 1 → W.need t f c ≤ W.level t c :=
  fun t le => Nat.le_trans (Nat.le_of_eq (need t))
    (Optimum.frontier_keeps_above rising coupled uncoupled renews beyond greatest meets ends reach
      settles drawsDown holds long front t le)

/-- **At a worth above one, far-sight draws a dependence above every level of greatest renewal down at
the first step and rebuilds only at the end.** Under the conditions of
`Optimum.frontier_holds_valued`, where every level where `R` gives `r` lies below a formation's need
on the condition, met at the start: every optimum, among the open courses, of every order rising
with what is drawn across `n + 1` steps with `v` above one for each unit left breaks the dependence at
the first step, leaves it unmet at every step to the `n`-th and stands at `y` with `r` after the last,
regrown there. -/
theorem frontier_rebuilt_valued (renews : ∀ z, R z ≤ r) {v : Nat} (more : 1 < v)
    (rising : ∀ a b, drawnOver R a (n + 1) + v * a (n + 1) < drawnOver R b (n + 1) + v * b (n + 1) →
      better b a)
    (bounded : ∀ a, OpenCourse R k s a → a (n + 1) ≤ y + r) (greatest : R y = r)
    (reach : y ≤ s + R s) (drawsDown : s + R s ≤ y + k) (middle : r ≤ k) (long : 0 < n)
    (front : Frontier (OpenCourse R k s) better fun t => W.level t c)
    (above : ∀ z, R z = r → z < m) (depends : W.requires 0 f c) (need : W.need 0 f c = m)
    (start : m ≤ s) :
    W.Broken 0 f c ∧ (∀ t, t < n → W.level (t + 1) c < m) ∧ W.level (n + 1) c = y + r :=
  have held := Optimum.frontier_holds_valued renews more rising bounded greatest reach drawsDown
    middle long front
  have unmet : ∀ t, t < n → W.level (t + 1) c < m := fun t before => above _ (held.1 t before)
  ⟨⟨depends, Nat.le_trans (Nat.le_of_eq need) (Eq.subst (motive := fun z => m ≤ z) front.1.1.symm start),
    Nat.lt_of_lt_of_le (unmet 0 long) (Nat.le_of_eq need.symm)⟩, unmet, held.2⟩

/-- **A value on what is left breaks the dependence within the horizon as without it.** Under the
premises of `Optimum.frontier_breaks_valued`, with a formation depending on the condition at the need
`m` at every step, met at the start: every optimum, among the open courses, of every order rising
with a worth at least what a course draws with `v` of at least one for each unit left and at most `w`
more for a course keeping the condition at `m` or above breaks the dependence at some step to the
`n`-th, where `w + q n < r n`, whatever `v`. -/
theorem frontier_breaks_valued {v : Nat}
    (rising : ∀ a b, worth a < worth b → better b a) (pos : 0 < v)
    (values : ∀ a, drawnOver R a (n + 1) + v * a (n + 1) ≤ worth a)
    (coupled : ∀ a, OpenCourse R k s a → Optimum.Keeps m n a →
      worth a ≤ drawnOver R a (n + 1) + v * a (n + 1) + w)
    (renews : ∀ z, R z ≤ r) (above : ∀ z, m ≤ z → R z ≤ q) (below : w + q * n < r * n)
    (bounded : ∀ a, OpenCourse R k s a → a (n + 1) ≤ y + r) (greatest : R y = r)
    (reach : y ≤ s + R s) (drawsDown : s + R s ≤ y + k) (middle : r ≤ k) (long : 0 < n)
    (front : Frontier (OpenCourse R k s) better fun t => W.level t c)
    (depends : ∀ t, W.requires t f c) (need : ∀ t, W.need t f c = m) (start : m ≤ s) :
    ∃ t, t ≤ n ∧ W.Broken t f c :=
  match drops_of_not_keeps (Eq.subst (motive := fun z => m ≤ z) front.1.1.symm start)
      (Optimum.frontier_breaks_valued rising pos values coupled renews above below bounded greatest
        reach drawsDown middle long front) with
  | ⟨t, le, met, lt⟩ => ⟨t, le, depends t, Nat.le_trans (Nat.le_of_eq (need t)) met,
      Nat.lt_of_lt_of_le lt (Nat.le_of_eq (need t).symm)⟩

end Web

namespace Optimum

namespace Holding

open Diversion

/-- One where a course stands at `m` or above at every step to the `T`-th, nothing otherwise. -/
def metThrough (m : Nat) (x : Nat → Nat) : Nat → Nat
  | 0 => if m ≤ x 0 then 1 else 0
  | t + 1 => if m ≤ x (t + 1) then metThrough m x t else 0

/-- A course standing at `m` or above at every step to the `T`-th is met through it. -/
theorem metThrough_of_keeps {m : Nat} {x : Nat → Nat} :
    ∀ {T : Nat}, (∀ t, t ≤ T → m ≤ x t) → metThrough m x T = 1
  | 0, keeps => show (if m ≤ x 0 then 1 else 0) = 1 from if_pos (keeps 0 (Nat.le_refl 0))
  | T + 1, keeps => show (if m ≤ x (T + 1) then metThrough m x T else 0) = 1 from
      (if_pos (keeps (T + 1) (Nat.le_refl _))).trans
        (metThrough_of_keeps fun t le => keeps t (Nat.le_succ_of_le le))

/-- A course below `m` at some step to the `T`-th is not met through it. -/
theorem metThrough_of_below {m : Nat} {x : Nat → Nat} :
    ∀ {T t : Nat}, t ≤ T → x t < m → metThrough m x T = 0
  | 0, t, le, lt => show (if m ≤ x 0 then 1 else 0) = 0 from
      if_neg (Nat.not_le_of_gt (Eq.subst (motive := fun z => x z < m)
        (Nat.le_antisymm le (Nat.zero_le t)) lt))
  | T + 1, _, le, lt => show (if m ≤ x (T + 1) then metThrough m x T else 0) = 0 from
    match le_or_eq_succ le with
    | .inl earlier => match Nat.lt_or_ge (x (T + 1)) m with
      | .inl below => if_neg (Nat.not_le_of_gt below)
      | .inr meets => (if_pos meets).trans (metThrough_of_below earlier lt)
    | .inr last => if_neg (Nat.not_le_of_gt (Eq.subst (motive := fun z => x z < m) last lt))

/-- What a course draws across `n + 1` steps under `R`, with `w` where it stands at `m` or above at
every step through them. -/
def coupledDraw (R : Nat → Nat) (m w n : Nat) (x : Nat → Nat) : Nat :=
  drawnOver R x (n + 1) + w * metThrough m x (n + 1)

/-- A course keeping its level at `m` or above through the horizon adds `w` to what it draws. -/
theorem coupledDraw_of_keeps {R : Nat → Nat} {m w n : Nat} {x : Nat → Nat} (keeps : Keeps m n x) :
    coupledDraw R m w n x = drawnOver R x (n + 1) + w :=
  congrArg (drawnOver R x (n + 1) + ·)
    ((congrArg (w * ·) (metThrough_of_keeps keeps)).trans (Nat.mul_one w))

/-- A course standing below `m` at some step through the horizon adds nothing to what it draws. -/
theorem coupledDraw_of_below {R : Nat → Nat} {m w n t : Nat} {x : Nat → Nat} (le : t ≤ n + 1)
    (below : x t < m) : coupledDraw R m w n x = drawnOver R x (n + 1) :=
  (congrArg (drawnOver R x (n + 1) + ·)
    ((congrArg (w * ·) (metThrough_of_below le below)).trans (Nat.mul_zero w))).trans
      (Nat.add_zero _)

/-- The levels with the source along a course and the store empty. -/
def onSource (x : Nat → Nat) (t : Nat) : Place → Nat
  | .source => x t
  | .store => 0

/-- Under the logistic law nothing is renewed at two or above. -/
theorem logistic_above : ∀ z, 2 ≤ z → logistic z ≤ 0 := fun _ le =>
  match le_dest le with
  | ⟨j, same⟩ => Nat.le_of_eq ((congrArg logistic (same.trans (Nat.add_comm 2 j))).trans
      (logistic_beyond j))

/-- **The gate witness: valuing what is left keeps the dweller past the horizon.** From a source at
two, the level the dweller needs, under a gate renewing one unit at every level from one, with
capacity three: the course holding the source at two through the horizon and after it is an optimum
of the order by what the taker draws across `n + 2` steps and leaves after them, and keeps the
dweller's need met at every step; the course drawing the source to nothing at the last step is an
optimum of that order too; the optima of that order are exactly the open courses standing where the
gate renews at every step to the horizon; and the course keeping the dweller is no optimum of the
order by what is drawn alone (`keeping_not_frontier`), whose every optimum leaves nothing at the last
step (`frontier_holds`). -/
theorem gated_left (n : Nat) :
    Frontier (OpenCourse gate 3 2) (byDrawnLeft gate (n + 1)) (holdingTo 2 2 2 (n + 1)) ∧
      (∀ t, (web (onSource (holdingTo 2 2 2 (n + 1)))).need t .dweller .source ≤
        (web (onSource (holdingTo 2 2 2 (n + 1)))).level t .source) ∧
      Frontier (OpenCourse gate 3 2) (byDrawnLeft gate (n + 1)) (holding 2 2 (n + 1)) ∧
      (∀ x, Frontier (OpenCourse gate 3 2) (byDrawnLeft gate (n + 1)) x ↔
        OpenCourse gate 3 2 x ∧ ∀ t, t < n + 1 → gate (x (t + 1)) = 1) ∧
      ¬ Frontier (OpenCourse gate 3 2) (byDrawn gate (n + 1)) (holdingTo 2 2 2 (n + 1)) :=
  ⟨keeping_frontier_left gate_le rfl (Nat.le_succ 2) (Nat.le_add_left 3 2) (Nat.le_add_left 1 2),
   fun t => match t with
    | 0 => Nat.le_refl 2
    | t + 1 => Nat.le_of_eq (holdingTo_same (s := 2) (y := 2) (n := n + 1) t).symm,
   holding_frontier_left gate_le rfl (Nat.le_succ 2) (Nat.le_add_left 3 2) (Nat.le_refl 3)
     (Nat.succ_pos n),
   fun _ => frontier_left_iff gate_le rfl (Nat.le_succ 2) (Nat.le_add_left 3 2) (Nat.le_add_left 1 2),
   keeping_not_frontier gate_le rfl (Nat.le_succ 2) (Nat.le_add_left 3 2) (Nat.le_refl 3)
     (Nat.succ_pos n) (Nat.succ_pos 1)⟩

/-- **The logistic witness: valuing what is left does not keep the dweller.** From a source at two,
the level the dweller needs, under the logistic law with capacity two, the course holding the source
at one through the horizon and after it is an optimum of the order by what the taker draws across
`n + 2` steps and leaves after them, and every optimum of that order breaks the dweller's dependence
at the first step and leaves it unmet to the horizon (`Web.frontier_broken_left`). -/
theorem logistic_left (n : Nat) :
    Frontier (OpenCourse logistic 2 2) (byDrawnLeft logistic (n + 1)) (holdingTo 2 1 1 (n + 1)) ∧
      ∀ x, Frontier (OpenCourse logistic 2 2) (byDrawnLeft logistic (n + 1)) x →
        (web (onSource x)).Broken 0 .dweller .source ∧
        ∀ t, t < n + 1 → (web (onSource x)).level (t + 1) .source < 2 :=
  ⟨keeping_frontier_left logistic_le rfl (Nat.le_succ 1) (Nat.le_succ 2) (Nat.le_succ 1),
   fun x front => Web.frontier_broken_left (W := web (onSource x)) (c := Place.source)
     (f := Formation.dweller) (y := 1) (s := 2) logistic_le (fun _ _ more => more) rfl
     (Nat.le_succ 1) (Nat.le_succ 2) (Nat.le_succ 1) (Nat.succ_pos n) front logistic_greatest trivial
     rfl (Nat.le_refl 2)⟩

/-- **The logistic witness: what keeping the dweller forgoes.** From a source at two, the level the
dweller needs, under the logistic law with capacity two, keeping the dweller through `n + 2` steps
forgoes `n + 3`. Under the order by what the taker draws with `w` added where the source stays at
two or above through the horizon: where `w < n + 3`, the course drawing the source to one and then
holding it there has the greatest worth (`continued_breaking_frontier`) and every optimum breaks
the dweller's dependence within the horizon (`Web.frontier_breaks_below`); where `n + 3 < w`, the
course staying at two has the greatest worth (`continued_kept_frontier`) and every optimum keeps the
dependence met through the horizon (`Web.frontier_keeps_above`). -/
theorem logistic_coupled (n w : Nat) :
    (w < n + 3 →
      Frontier (OpenCourse logistic 2 2)
        (fun b a => coupledDraw logistic 2 w (n + 1) a < coupledDraw logistic 2 w (n + 1) b)
        (continued logistic (holding 2 1 (n + 1)) (n + 1)) ∧
      ∀ x, Frontier (OpenCourse logistic 2 2)
        (fun b a => coupledDraw logistic 2 w (n + 1) a < coupledDraw logistic 2 w (n + 1) b) x →
      ∃ t, t ≤ n + 1 ∧ (web (onSource x)).Broken t .dweller .source) ∧
    (n + 3 < w →
      Frontier (OpenCourse logistic 2 2)
        (fun b a => coupledDraw logistic 2 w (n + 1) a < coupledDraw logistic 2 w (n + 1) b)
        (continued logistic (holdingTo 2 2 2 (n + 1)) (n + 1)) ∧
      ∀ x, Frontier (OpenCourse logistic 2 2)
        (fun b a => coupledDraw logistic 2 w (n + 1) a < coupledDraw logistic 2 w (n + 1) b) x →
      ∀ t, t ≤ n + 2 → (web (onSource x)).need t .dweller .source ≤
        (web (onSource x)).level t .source) :=
  have draws : ∀ a, drawnOver logistic a (n + 1 + 1) ≤ coupledDraw logistic 2 w (n + 1) a :=
    fun _ => Nat.le_add_right _ _
  have bounded : ∀ a, OpenCourse logistic 2 2 a → Keeps 2 (n + 1) a →
      coupledDraw logistic 2 w (n + 1) a ≤ drawnOver logistic a (n + 1 + 1) + w :=
    fun _ _ keeps => Nat.le_of_eq (coupledDraw_of_keeps keeps)
  have coupled : ∀ a, OpenCourse logistic 2 2 a → Keeps 2 (n + 1) a →
      drawnOver logistic a (n + 1 + 1) + w ≤ coupledDraw logistic 2 w (n + 1) a :=
    fun _ _ keeps => Nat.le_of_eq (coupledDraw_of_keeps keeps).symm
  have uncoupled : ∀ a t, OpenCourse logistic 2 2 a → t ≤ n + 1 + 1 → a t < 2 →
      coupledDraw logistic 2 w (n + 1) a ≤ drawnOver logistic a (n + 1 + 1) :=
    fun _ _ _ le below => Nat.le_of_eq (coupledDraw_of_below le below)
  ⟨fun short =>
    have below : w + 0 * (n + 1) < 1 * (n + 1) + 2 := by
      rw [Nat.zero_mul, Nat.one_mul, Nat.add_zero]; exact short
    ⟨continued_breaking_frontier (R := logistic) (k := 2) (s := 2) (m := 2) (n := n + 1)
      (y := 1) (q := 0) (r := 1) draws bounded uncoupled logistic_le logistic_above below rfl
      (Nat.le_succ 1) (Nat.le_succ 2) (Nat.le_refl 2) (Nat.succ_pos n),
    fun x front =>
      Web.frontier_breaks_below (W := web (onSource x)) (c := Place.source)
        (f := Formation.dweller) (R := logistic) (k := 2) (s := 2) (m := 2) (n := n + 1) (w := w)
        (worth := coupledDraw logistic 2 w (n + 1)) (y := 1) (q := 0) (r := 1) (e := 0)
        (fun _ _ less => less) draws bounded logistic_above below rfl (Nat.le_succ 1)
        (Nat.zero_le 1) (Nat.le_succ 2) (Nat.le_refl 2) (Nat.succ_pos n) front
        (fun _ => trivial) (fun _ => rfl) (Nat.le_refl 2)⟩,
   fun beyond' =>
    have beyond : 1 * (n + 1) + 2 < w + 0 * (n + 1) := by
      rw [Nat.zero_mul, Nat.one_mul, Nat.add_zero]; exact beyond'
    ⟨continued_kept_frontier (R := logistic) (k := 2) (s := 2) (m := 2) (n := n + 1)
      (y := 2) (q := 0) (r := 1) coupled bounded uncoupled logistic_le logistic_above beyond rfl
      (Nat.le_refl 2) (Nat.le_refl 2) (Nat.le_refl 2) (Nat.le_add_right 2 2)
      (Nat.le_add_right 2 2) (Nat.succ_pos n),
    fun x front =>
      Web.frontier_keeps_above (W := web (onSource x)) (c := Place.source)
        (f := Formation.dweller) (R := logistic) (k := 2) (s := 2) (m := 2) (n := n + 1) (w := w)
        (worth := coupledDraw logistic 2 w (n + 1)) (y := 2) (q := 0) (r := 1) (e := 2)
        (fun _ _ less => less) coupled uncoupled logistic_le
        (Nat.le_trans (Nat.le_of_eq (Nat.add_zero _)) beyond) rfl (Nat.le_refl 2)
        (Nat.le_refl 2) (Nat.le_refl 2) (Nat.le_refl 2) (Nat.le_add_right 2 2)
        (Nat.le_add_right 2 2) (Nat.succ_pos n) front (fun _ => rfl)⟩⟩

/-- Under the logistic law a level at most two with what is given there is at most two. -/
theorem logistic_within : ∀ z, z ≤ 2 → z + logistic z ≤ 2
  | 0, _ => Nat.zero_le 2
  | 1, _ => Nat.le_refl 2
  | 2, _ => Nat.le_refl 2
  | z + 3, le => absurd le (Nat.not_le_of_gt (Nat.lt_of_lt_of_le (Nat.lt_succ_self 2)
      (Nat.le_add_left 3 z)))

/-- Every course open from two under the logistic law stands at two or below. -/
theorem logistic_open_le {k : Nat} {x : Nat → Nat} (opens : OpenCourse logistic k 2 x) :
    ∀ t, x t ≤ 2
  | 0 => Nat.le_of_eq opens.1
  | t + 1 => Nat.le_trans (opens.2 t).1 (logistic_within _ (logistic_open_le opens t))

/-- **The logistic witness at any worth: drawn down, and regrown at the end.** From a source at two,
the level the dweller needs, under the logistic law with capacity two: at every worth `v` of at least
one for each unit the source is left with after `n + 2` steps, the course holding the source at one
through the horizon and regrowing it to two at the last step, drawing nothing after, is an optimum of
the order by what the taker draws with `v` for each unit left (`regrowing_frontier`); at every worth
above one, the optima of that order are exactly the open courses standing at one through the horizon
and at two after it (`frontier_valued_iff`), and every optimum of that order breaks the dweller at the first step, leaves it unmet through
the horizon and stands at two, the dweller's need, after its last step
(`Web.frontier_rebuilt_valued`); and with a coupling `w` of the dweller below `n + 1`, every optimum
of the order by what the taker draws with `w` where the dweller stays met and `v` for each unit left
breaks the dweller within the horizon, whatever `v` (`Web.frontier_breaks_valued`). -/
theorem logistic_valued (n v w : Nat) (pos : 0 < v) :
    Frontier (OpenCourse logistic 2 2) (byDrawnLeftAt logistic v (n + 1))
        (continued logistic (holdingTo 2 1 2 (n + 1)) (n + 1)) ∧
      (1 < v → ∀ x, (Frontier (OpenCourse logistic 2 2) (byDrawnLeftAt logistic v (n + 1)) x ↔
        OpenCourse logistic 2 2 x ∧ (∀ t, t < n + 1 → logistic (x (t + 1)) = 1) ∧
          x (n + 1 + 1) = 1 + 1)) ∧
      (1 < v → ∀ x, Frontier (OpenCourse logistic 2 2) (byDrawnLeftAt logistic v (n + 1)) x →
        (web (onSource x)).Broken 0 .dweller .source ∧
        (∀ t, t < n + 1 → (web (onSource x)).level (t + 1) .source < 2) ∧
        (web (onSource x)).level (n + 1 + 1) .source = 2) ∧
      (w < n + 1 → ∀ x, Frontier (OpenCourse logistic 2 2)
        (fun b a => coupledDraw logistic 2 w (n + 1) a + v * a (n + 1 + 1) <
          coupledDraw logistic 2 w (n + 1) b + v * b (n + 1 + 1)) x →
        ∃ t, t ≤ n + 1 ∧ (web (onSource x)).Broken t .dweller .source) :=
  have bounded : ∀ a, OpenCourse logistic 2 2 a → a (n + 1 + 1) ≤ 1 + 1 :=
    fun _ opens => logistic_open_le opens _
  ⟨regrowing_frontier (R := logistic) (k := 2) (s := 2) (y := 1) (r := 1) (n := n + 1) logistic_le
      pos bounded rfl (Nat.le_succ 1) (Nat.le_succ 2) (Nat.le_succ 1) (Nat.succ_pos n),
   fun more _ => frontier_valued_iff (R := logistic) (k := 2) (s := 2) (y := 1) (r := 1) (n := n + 1)
     logistic_le more bounded rfl (Nat.le_succ 1) (Nat.le_succ 2) (Nat.le_succ 1) (Nat.succ_pos n),
   fun more x front => Web.frontier_rebuilt_valued (W := web (onSource x)) (c := Place.source)
     (f := Formation.dweller) (R := logistic) (k := 2) (s := 2) (y := 1) (r := 1) (m := 2)
     (n := n + 1) logistic_le more (fun _ _ less => less) bounded rfl (Nat.le_succ 1)
     (Nat.le_succ 2) (Nat.le_succ 1) (Nat.succ_pos n) front logistic_greatest trivial rfl
     (Nat.le_refl 2),
   fun short x front =>
    have below : w + 0 * (n + 1) < 1 * (n + 1) := by
      rw [Nat.zero_mul, Nat.one_mul, Nat.add_zero]; exact short
    Web.frontier_breaks_valued (W := web (onSource x)) (c := Place.source)
      (f := Formation.dweller) (R := logistic) (k := 2) (s := 2) (y := 1) (r := 1) (q := 0)
      (m := 2) (n := n + 1) (w := w)
      (worth := fun a => coupledDraw logistic 2 w (n + 1) a + v * a (n + 1 + 1))
      (fun _ _ less => less) pos
      (fun _ => Nat.add_le_add_right (Nat.le_add_right _ _) _)
      (fun _ _ keeps => Nat.le_of_eq (by
        show coupledDraw logistic 2 w (n + 1) _ + _ = _
        rw [coupledDraw_of_keeps keeps, Nat.add_right_comm]))
      logistic_le logistic_above below bounded rfl (Nat.le_succ 1) (Nat.le_succ 2) (Nat.le_succ 1)
      (Nat.succ_pos n) front (fun _ => trivial) (fun _ => rfl) (Nat.le_refl 2)⟩

end Holding

end Optimum

/-! ## A coupling added for each step a dependence is kept

Above, a coupling of keeping a need through the whole horizon must exceed what keeping forgoes,
which grows with the horizon where the need lies above every level of greatest renewal. Here the
worth adds `c` for each step a course stays at the need from the start. A course met through `j`
steps of the horizon draws, with `r` for each of them, at most the start with what is given there,
`r` a step and `q` for each of them: each met step forgoes at least `r - q`. So every optimum keeps
the need through every horizon where `c` covers the renewal forgone a step, `r ≤ q + c`, and
exceeds the end the keeping course can reach, at least the need; where `c` with the end the
capacity reaches is below the need, every optimum falls below it within the horizon, and where `c`
also exceeds the renewal forgone a step it falls at the horizon's last step alone, drawing the need
itself there: the end does not reach back; and where `q + c < r` the coupling is at most `c` a step
and a long horizon outweighs it. Optima exist on both sides. Where the worth adds `c` for every step
the need is met, wherever, each met step still forgoes at least `r - q`, but a fall met again loses
the coupling only at the steps below, so every optimum keeps the need where `r + e < q + c + m` and
`e < c`, a strict threshold above the count from the start. -/

namespace Optimum

variable {R : Nat → Nat} {k q r s y m n c : Nat}

/-- What falls short of `r` from at most `q`, with `q`, is at least `r`. -/
theorem le_sub_add_of_le {g : Nat} (le : g ≤ q) : r ≤ r - g + q :=
  match Nat.le_total g r with
  | .inl within => Nat.le_trans (Nat.le_of_eq (Naturals.sub_add_cancel within).symm)
      (Nat.add_le_add_left le _)
  | .inr beyond => Nat.le_trans (Nat.le_trans beyond le) (Nat.le_add_left q _)

/-- The steps among the first `n` at which `p` holds, counted. -/
def countUpTo (p : Nat → Bool) : Nat → Nat
  | 0 => 0
  | n + 1 => countUpTo p n + if p n then 1 else 0

/-- At most one is counted at a step. -/
theorem counted_le_one (b : Bool) : (if b then 1 else 0) ≤ 1 := by
  cases b <;> decide

/-- At most every step is counted. -/
theorem countUpTo_le (p : Nat → Bool) : ∀ n, countUpTo p n ≤ n
  | 0 => Nat.le_refl 0
  | n + 1 => Nat.add_le_add (countUpTo_le p n) (counted_le_one (p n))

/-- Every step is counted where `p` holds at every step. -/
theorem countUpTo_all {p : Nat → Bool} :
    ∀ {n : Nat}, (∀ t, t < n → p t = true) → countUpTo p n = n
  | 0, _ => rfl
  | n + 1, all => by
    show countUpTo p n + (if p n = true then 1 else 0) = n + 1
    rw [countUpTo_all fun t lt => all t (Nat.lt_succ_of_lt lt), if_pos (all n (Nat.lt_succ_self n))]

/-- A step at which `p` fails leaves the count below the steps. -/
theorem countUpTo_lt {p : Nat → Bool} {t : Nat} (fails : p t = false) :
    ∀ {n : Nat}, t < n → countUpTo p n < n
  | 0, lt => absurd lt (Nat.not_lt_zero t)
  | n + 1, lt => match Nat.lt_or_ge t n with
    | .inl before => Nat.lt_of_le_of_lt (Nat.le_trans (Nat.add_le_add_left (counted_le_one _) _)
        (countUpTo_lt fails before)) (Nat.lt_succ_self n)
    | .inr after =>
      have none : (if p n = true then 1 else 0) = 0 := if_neg fun holds => Bool.noConfusion
        ((Eq.subst (motive := fun z => p z = false)
          (Nat.le_antisymm (Nat.le_of_lt_succ lt) after) fails).symm.trans holds)
      Nat.lt_of_le_of_lt (Nat.le_trans (Nat.le_of_eq (congrArg (countUpTo p n + ·) none))
        (countUpTo_le p n)) (Nat.lt_succ_self n)

/-- The steps before `j` among the first `n`, `j ≤ n`, number `j`. -/
theorem countUpTo_below {j : Nat} : ∀ {n : Nat}, j ≤ n → countUpTo (fun t => decide (t < j)) n = j
  | 0, le => (Nat.le_antisymm le (Nat.zero_le j)).symm
  | n + 1, le => match le_or_eq_succ le with
    | .inl earlier => by
      show countUpTo (fun t => decide (t < j)) n + (if decide (n < j) = true then 1 else 0) = j
      rw [countUpTo_below earlier, if_neg fun holds =>
        Nat.lt_irrefl n (Nat.lt_of_lt_of_le (of_decide_eq_true holds) earlier)]
      exact Nat.add_zero j
    | .inr last => by
      show countUpTo (fun t => decide (t < j)) n + (if decide (n < j) = true then 1 else 0) = j
      rw [countUpTo_all fun t lt => decide_eq_true
          (Nat.lt_of_lt_of_le lt (Nat.le_trans (Nat.le_succ n) (Nat.le_of_eq last.symm))),
        if_pos (decide_eq_true (Nat.lt_of_lt_of_le (Nat.lt_succ_self n) (Nat.le_of_eq last.symm)))]
      exact last.symm

/-- One more step, counted where `b` holds: what is forgone there with `q` covers `r`. -/
theorem counted_step (b : Bool) {J S δ : Nat} (earlier : J * r ≤ S + J * q)
    (met : b = true → r ≤ δ + q) :
    (J + if b then 1 else 0) * r ≤ S + δ + (J + if b then 1 else 0) * q :=
  match b, met with
  | true, met => Nat.le_trans (Nat.le_of_eq (Nat.succ_mul J r))
      (Nat.le_trans (Nat.add_le_add earlier (met rfl))
        (Nat.le_of_eq ((add_four S (J * q) δ q).trans
          (congrArg (S + δ + ·) (Nat.succ_mul J q).symm))))
  | false, _ => Nat.le_trans earlier (Nat.add_le_add_right (Nat.le_add_right S δ) _)

/-- **What counted steps forgo.** Where what is given at each counted step among the first `n` is at
most `q`, `r` for each counted step is at most everything given falls short of `r` across the `n`
steps, with `q` for each counted step: the steps may fall anywhere. -/
theorem shortfall_count_ge {g : Nat → Nat} (p : Nat → Bool) :
    ∀ {n : Nat}, (∀ t, t < n → p t = true → g t ≤ q) →
      countUpTo p n * r ≤ Amounts.whole.sum (fun t => r - g t) 0 n + countUpTo p n * q
  | 0, _ => Nat.le_of_eq ((Nat.zero_mul r).trans
      ((Nat.zero_add 0).symm.trans (congrArg (0 + ·) (Nat.zero_mul q).symm)))
  | n + 1, met => counted_step (p n) (S := Amounts.whole.sum (fun t => r - g t) 0 n)
      (δ := r - g (0 + n)) (shortfall_count_ge p fun t lt => met t (Nat.lt_succ_of_lt lt))
      fun holds => Eq.subst (motive := fun z => r ≤ r - g z + q) (Nat.zero_add n).symm
        (le_sub_add_of_le (met n (Nat.lt_succ_self n) holds))

/-- **What met steps forgo.** Where what is given at each of the first `j` of `n` steps is at most
`q`, `r` for each of those steps is at most everything given falls short of `r` across the `n`
steps, with `q` for each of those steps: the case of `shortfall_count_ge` counting the steps before
`j`. -/
theorem shortfall_ge {g : Nat → Nat} {n j : Nat} (le : j ≤ n) (met : ∀ t, t < j → g t ≤ q) :
    j * r ≤ Amounts.whole.sum (fun t => r - g t) 0 n + j * q :=
  Eq.subst (motive := fun z => z * r ≤ Amounts.whole.sum (fun t => r - g t) 0 n + z * q)
    (countUpTo_below le)
    (shortfall_count_ge (fun t => decide (t < j)) fun t _ holds => met t (of_decide_eq_true holds))

/-- **What a course met through `j` steps draws.** Where each step leaves at most the level with
what is given, `R` gives at most `r` at every level and at most `q` at every level at or above `m`,
and a course stands at `m` or above at every step to the `j`-th, `j ≤ n`: what it draws across
`n + 1` steps, with `r` for each of those `j` steps, is at most its start with what is given there,
`r` for each step after the first and `q` for each of those `j` steps. -/
theorem met_drawn_le (renews : ∀ z, R z ≤ r) (above : ∀ z, m ≤ z → R z ≤ q) {x : Nat → Nat}
    (within : ∀ t, x (t + 1) ≤ x t + R (x t)) {j : Nat} (met : ∀ t, t ≤ j → m ≤ x t)
    (le : j ≤ n) : drawnOver R x (n + 1) + j * r ≤ x 0 + R (x 0) + r * n + j * q := by
  have whole : drawnOver R x (n + 1) + x (n + 1) +
      Amounts.whole.sum (fun t => r - R (x (t + 1))) 0 n = x 0 + R (x 0) + r * n :=
    drawn_add_shortfall_after (x := x) (g := fun t => R (x t)) within (fun t => renews (x t)) n
  have short : j * r ≤ Amounts.whole.sum (fun t => r - R (x (t + 1))) 0 n + j * q :=
    shortfall_ge (g := fun t => R (x (t + 1))) le fun t lt => above _ (met (t + 1) lt)
  calc drawnOver R x (n + 1) + j * r
      ≤ drawnOver R x (n + 1) + (Amounts.whole.sum (fun t => r - R (x (t + 1))) 0 n + j * q) :=
        Nat.add_le_add_left short _
    _ = drawnOver R x (n + 1) + Amounts.whole.sum (fun t => r - R (x (t + 1))) 0 n + j * q :=
        (Nat.add_assoc _ _ _).symm
    _ ≤ drawnOver R x (n + 1) + x (n + 1) +
          Amounts.whole.sum (fun t => r - R (x (t + 1))) 0 n + j * q :=
        Nat.add_le_add_right (Nat.add_le_add_right (Nat.le_add_right _ _) _) _
    _ = x 0 + R (x 0) + r * n + j * q := by rw [whole]

/-- The course holding `y` at or above `m`, from a start at or above `m`, stands at `m` or above at
every step to the `n`-th, whatever its end. -/
theorem holdingTo_met {e : Nat} (meets : m ≤ s) (needs : m ≤ y) :
    ∀ t, t ≤ n → m ≤ holdingTo s y e n t
  | 0, _ => meets
  | _ + 1, le => Nat.le_trans needs (Nat.le_of_eq (holdingTo_before le).symm)

/-- What a step coupling adds over the renewal forgone, step by step. -/
theorem stepwise_arith {e j i : Nat} (rate : r ≤ q + c) (exceeds : e < c) :
    r * (j + i) + j * q + c * j + e < q * (j + i) + c * (j + i + 1) + j * r :=
  have key : r * i + e < q * i + c * i + c :=
    Nat.lt_of_le_of_lt
      (Nat.add_le_add_right (Nat.le_trans (Nat.le_of_eq (Nat.mul_comm r i))
        (Nat.le_trans (Nat.mul_le_mul_left i rate)
          (Nat.le_of_eq ((Nat.mul_add i q c).trans (by rw [Nat.mul_comm i q, Nat.mul_comm i c])))))
        e)
      (Nat.add_lt_add_left exceeds _)
  calc r * (j + i) + j * q + c * j + e
      = j * r + j * q + c * j + (r * i + e) := by
        rw [Nat.mul_add, Nat.mul_comm r j, Nat.add_right_comm (j * r) (r * i) (j * q),
          Nat.add_right_comm (j * r + j * q) (r * i) (c * j), Nat.add_assoc (j * r + j * q + c * j)]
    _ < j * r + j * q + c * j + (q * i + c * i + c) := Nat.add_lt_add_left key _
    _ = j * r + (q * j + (c * j + (q * i + (c * i + c)))) := by
        rw [Nat.mul_comm j q, Nat.add_assoc (j * r), Nat.add_assoc (j * r), Nat.add_assoc (q * i),
          Nat.add_assoc (q * j)]
    _ = j * r + (q * j + (q * i + (c * j + (c * i + c)))) := by
        rw [Nat.add_left_comm (c * j) (q * i)]
    _ = q * (j + i) + c * (j + i + 1) + j * r := by
        rw [Nat.mul_add q j i, Nat.mul_add c (j + i) 1, Nat.mul_add c j i, Nat.mul_one,
          Nat.add_comm _ (j * r), Nat.add_assoc (q * j), Nat.add_assoc (c * j)]

/-- Comparing a course met through `j` steps with a keeping course, under a step coupling. -/
theorem lt_of_stepwise {A D Da Wa S e j : Nat} (coupledAt : A ≤ D + c * j)
    (met : D + j * r ≤ S + r * n + j * q) (le : j ≤ n) (most : Da + e = S + q * n)
    (coupled : Da + c * (n + 1) ≤ Wa) (rate : r ≤ q + c) (exceeds : e < c) : A < Wa :=
  match le_dest le with
  | ⟨i, split⟩ => by
    subst split
    have less : A + j * r + e < Wa + j * r + e :=
      calc A + j * r + e ≤ D + c * j + j * r + e :=
            Nat.add_le_add_right (Nat.add_le_add_right coupledAt _) _
        _ = D + j * r + c * j + e := by rw [Nat.add_right_comm D (c * j) (j * r)]
        _ ≤ S + r * (j + i) + j * q + c * j + e :=
            Nat.add_le_add_right (Nat.add_le_add_right met _) _
        _ = S + (r * (j + i) + j * q + c * j + e) := by
            rw [Nat.add_assoc S, Nat.add_assoc S, Nat.add_assoc S]
        _ < S + (q * (j + i) + c * (j + i + 1) + j * r) :=
            Nat.add_lt_add_left (stepwise_arith rate exceeds) _
        _ = Da + e + c * (j + i + 1) + j * r := by
            rw [most, Nat.add_assoc S, Nat.add_assoc S]
        _ = Da + c * (j + i + 1) + j * r + e := by
            rw [Nat.add_right_comm Da e, Nat.add_right_comm (Da + c * (j + i + 1)) e]
        _ ≤ Wa + j * r + e := Nat.add_le_add_right (Nat.add_le_add_right coupled _) _
    exact Nat.lt_of_add_lt_add_right (Nat.lt_of_add_lt_add_right less)

/-- **A coupling a step covering the renewal forgone and exceeding the end keeps the need at every
horizon.** Where `R` gives at most `r` at every level, at most `q` at every level at or above `m`,
and `q` at some `y` within the start with what is given there, from a start meeting `m`, over a
horizon of at least two steps, with a capacity covering what the first step draws down to `y` and
`y` with `q` down to some `e` between `m` and `y`; for a worth adding at least `c` for each step to
what a keeping course draws, and at most `c` for each step met to what a course falling below `m`
within the horizon draws: where `r ≤ q + c` and `e < c`, every optimum, among the open courses, of
every order rising with the worth keeps its level at `m` or above through the horizon. -/
theorem frontier_keeps_stepwise {better : (Nat → Nat) → (Nat → Nat) → Prop}
    {worth : (Nat → Nat) → Nat} {e : Nat}
    (rising : ∀ a b, worth a < worth b → better b a)
    (coupled : ∀ a, OpenCourse R k s a → Keeps m n a → drawnOver R a (n + 1) + c * (n + 1) ≤ worth a)
    (coupledAt : ∀ a j, OpenCourse R k s a → (∀ t, t ≤ j → m ≤ a t) → a (j + 1) < m → j ≤ n →
      worth a ≤ drawnOver R a (n + 1) + c * j)
    (renews : ∀ z, R z ≤ r) (above : ∀ z, m ≤ z → R z ≤ q) (rate : r ≤ q + c) (exceeds : e < c)
    (greatest : R y = q) (meets : m ≤ s) (ends : m ≤ e) (reach : y ≤ s + R s) (settles : e ≤ y)
    (drawsDown : s + R s ≤ y + k) (holds : y + q ≤ e + k) (long : 0 < n)
    {x : Nat → Nat} (front : Frontier (OpenCourse R k s) better x) : Keeps m n x :=
  match keeps_or_falls (Eq.subst (motive := fun z => m ≤ z) front.1.1.symm meets) n with
  | .inl keeps => keeps
  | .inr ⟨j, le, met, lt⟩ => by
    have opens : OpenCourse R k s (continued R (holdingTo s y e n) n) :=
      continued_open (x := holdingTo s y e n) rfl
        (holdingTo_steps greatest reach settles drawsDown holds long)
    have most : drawnOver R (continued R (holdingTo s y e n) n) (n + 1) + e = s + R s + q * n := by
      rw [continued_drawn]
      exact holdingTo_most greatest reach settles n
    have drawn := met_drawn_le renews above (fun t => (front.1.2 t).1) met le
    rw [front.1.1] at drawn
    exact absurd (rising x _ (lt_of_stepwise (coupledAt x j front.1 met lt le) drawn le most
      (coupled _ opens (continued_keeps (holdingTo_keeps meets (Nat.le_trans ends settles) ends)))
      rate exceeds)) (front.2 _ opens)

/-- **The optimum keeping the need under a step coupling.** Under the premises of
`frontier_keeps_stepwise` with the keeping course ending at `m`, for a worth adding exactly `c` for
each step to what a keeping course draws: the course holding `y` to the `n`-th step, at `m` after
the last and drawing nothing after it, is an optimum, among the open courses, of the order by the
worth. -/
theorem continued_stepwise_frontier {worth : (Nat → Nat) → Nat}
    (coupled : ∀ a, OpenCourse R k s a → Keeps m n a → drawnOver R a (n + 1) + c * (n + 1) ≤ worth a)
    (bounded : ∀ a, OpenCourse R k s a → Keeps m n a → worth a ≤ drawnOver R a (n + 1) + c * (n + 1))
    (coupledAt : ∀ a j, OpenCourse R k s a → (∀ t, t ≤ j → m ≤ a t) → a (j + 1) < m → j ≤ n →
      worth a ≤ drawnOver R a (n + 1) + c * j)
    (renews : ∀ z, R z ≤ r) (above : ∀ z, m ≤ z → R z ≤ q) (rate : r ≤ q + c) (exceeds : m < c)
    (greatest : R y = q) (needs : m ≤ y) (meets : m ≤ s) (reach : y ≤ s + R s)
    (drawsDown : s + R s ≤ y + k) (holds : y + q ≤ m + k) (long : 0 < n) :
    Frontier (OpenCourse R k s) (fun b a => worth a < worth b)
      (continued R (holdingTo s y m n) n) :=
  have optimum := continued_keeping_frontier above greatest needs meets reach drawsDown holds long
  have most : drawnOver R (continued R (holdingTo s y m n) n) (n + 1) + m = s + R s + q * n := by
    rw [continued_drawn]
    exact holdingTo_most greatest reach needs n
  have least := coupled _ optimum.1.1 optimum.1.2
  ⟨optimum.1.1, fun b opens more => Nat.not_le_of_gt more
    (match keeps_or_falls (Eq.subst (motive := fun z => m ≤ z) opens.1.symm meets) n with
    | .inl keeps => Nat.le_trans (bounded b opens keeps) (Nat.le_trans (Nat.add_le_add_right
        (Nat.ge_of_not_lt (optimum.2 b ⟨opens, keeps⟩)) _) least)
    | .inr ⟨j, le, met, lt⟩ => by
      have drawn := met_drawn_le renews above (fun t => (opens.2 t).1) met le
      rw [opens.1] at drawn
      exact Nat.le_of_lt (lt_of_stepwise (coupledAt b j opens met lt le) drawn le most least rate
        exceeds))⟩

/-- **Below the need, the horizon's end breaks it.** Where `R` gives at most `q` at every level at
or above `m` and `q` at some `y` at or above `m` within the start with what is given there, from a
start meeting `m`, over a horizon of at least two steps, with a capacity covering what the first
step draws down to `y` and `y` with `q` down to some `e` at most `y`; for a worth adding at most `c`
for each step to what a keeping course draws, and at least `c` for each of the first `n` steps to
what a course meeting `m` at each of them draws: where `c + e < m`, no optimum, among the open
courses, of any order rising with the worth keeps its level at `m` or above through the horizon. -/
theorem frontier_breaks_at_end {better : (Nat → Nat) → (Nat → Nat) → Prop}
    {worth : (Nat → Nat) → Nat} {e : Nat}
    (rising : ∀ a b, worth a < worth b → better b a)
    (bounded : ∀ a, OpenCourse R k s a → Keeps m n a → worth a ≤ drawnOver R a (n + 1) + c * (n + 1))
    (coupledTo : ∀ a, OpenCourse R k s a → (∀ t, t ≤ n → m ≤ a t) →
      drawnOver R a (n + 1) + c * n ≤ worth a)
    (above : ∀ z, m ≤ z → R z ≤ q) (short : c + e < m)
    (greatest : R y = q) (needs : m ≤ y) (meets : m ≤ s) (reach : y ≤ s + R s) (settles : e ≤ y)
    (drawsDown : s + R s ≤ y + k) (holds : y + q ≤ e + k) (long : 0 < n)
    {x : Nat → Nat} (front : Frontier (OpenCourse R k s) better x) : ¬ Keeps m n x := by
  intro keeps
  have opens : OpenCourse R k s (continued R (holdingTo s y e n) n) :=
    continued_open (x := holdingTo s y e n) rfl
      (holdingTo_steps greatest reach settles drawsDown holds long)
  have most : drawnOver R (continued R (holdingTo s y e n) n) (n + 1) + e = s + R s + q * n := by
    rw [continued_drawn]
    exact holdingTo_most greatest reach settles n
  have least := coupledTo _ opens fun t le => Nat.le_trans (holdingTo_met meets needs t le)
    (Nat.le_of_eq (continued_le (Nat.le_succ_of_le le)).symm)
  have kept := keeping_drawn_le above (fun t => (front.1.2 t).1) keeps
  rw [front.1.1] at kept
  have less : worth x + m < worth (continued R (holdingTo s y e n) n) + m :=
    calc worth x + m ≤ drawnOver R x (n + 1) + c * (n + 1) + m :=
          Nat.add_le_add_right (bounded x front.1 keeps) m
      _ = drawnOver R x (n + 1) + m + c * (n + 1) := Nat.add_right_comm _ _ _
      _ ≤ s + R s + q * n + c * (n + 1) := Nat.add_le_add_right kept _
      _ = drawnOver R (continued R (holdingTo s y e n) n) (n + 1) + c * n + (c + e) := by
          rw [← most, Nat.mul_succ c n,
            Nat.add_add_add_comm (drawnOver R (continued R (holdingTo s y e n) n) (n + 1)) e (c * n) c,
            Nat.add_comm e c]
      _ ≤ worth (continued R (holdingTo s y e n) n) + (c + e) := Nat.add_le_add_right least _
      _ < worth (continued R (holdingTo s y e n) n) + m := Nat.add_lt_add_left short _
  exact front.2 _ opens (rising x _ (Nat.lt_of_add_lt_add_right less))

/-- What a step coupling covering the renewal forgone adds, step by step. -/
theorem stepwise_arith_le {j i : Nat} (rate : r ≤ q + c) :
    r * (j + i) + j * q + c * j ≤ q * (j + i) + c * (j + i) + j * r :=
  have key : r * i ≤ q * i + c * i :=
    Nat.le_trans (Nat.le_of_eq (Nat.mul_comm r i))
      (Nat.le_trans (Nat.mul_le_mul_left i rate)
        (Nat.le_of_eq ((Nat.mul_add i q c).trans (by rw [Nat.mul_comm i q, Nat.mul_comm i c]))))
  calc r * (j + i) + j * q + c * j
      = j * r + j * q + c * j + r * i := by
        rw [Nat.mul_add, Nat.mul_comm r j, Nat.add_right_comm (j * r) (r * i) (j * q),
          Nat.add_right_comm (j * r + j * q) (r * i) (c * j)]
    _ ≤ j * r + j * q + c * j + (q * i + c * i) := Nat.add_le_add_left key _
    _ = j * r + (q * j + (c * j + (q * i + c * i))) := by
        rw [Nat.mul_comm j q, Nat.add_assoc (j * r), Nat.add_assoc (j * r), Nat.add_assoc (q * j)]
    _ = j * r + (q * j + (q * i + (c * j + c * i))) := by
        rw [Nat.add_left_comm (c * j) (q * i)]
    _ = q * (j + i) + c * (j + i) + j * r := by
        rw [Nat.mul_add q j i, Nat.mul_add c j i, Nat.add_comm _ (j * r), Nat.add_assoc (q * j)]

/-- Comparing a course met through `j` steps with one met through every step but the last and
ending at nothing, under a step coupling. -/
theorem le_of_stepwise_end {A D Da Wa S j : Nat} (coupledAt : A ≤ D + c * j)
    (met : D + j * r ≤ S + r * n + j * q) (le : j ≤ n) (most : Da = S + q * n)
    (coupledTo : Da + c * n ≤ Wa) (rate : r ≤ q + c) : A ≤ Wa :=
  match le_dest le with
  | ⟨i, split⟩ => by
    subst split
    have sum : A + j * r ≤ Wa + j * r :=
      calc A + j * r ≤ D + c * j + j * r := Nat.add_le_add_right coupledAt _
        _ = D + j * r + c * j := by rw [Nat.add_right_comm D (c * j) (j * r)]
        _ ≤ S + r * (j + i) + j * q + c * j := Nat.add_le_add_right met _
        _ = S + (r * (j + i) + j * q + c * j) := by rw [Nat.add_assoc S, Nat.add_assoc S]
        _ ≤ S + (q * (j + i) + c * (j + i) + j * r) := Nat.add_le_add_left (stepwise_arith_le rate) _
        _ = Da + c * (j + i) + j * r := by rw [most, Nat.add_assoc S, Nat.add_assoc S]
        _ ≤ Wa + j * r := Nat.add_le_add_right coupledTo _
    exact Naturals.le_of_add_le_add_right sum

/-- **Between the renewal forgone and the need, the optimum keeps the need to the horizon's last step
and draws everything there.** Where `R` gives at most `r` at every level, at most `q` at every level
at or above `m`, and `q` at some `y` at or above `m` within the start with what is given there, from
a start meeting `m`, over a horizon of at least two steps, with a capacity covering what the first
step draws down to `y` and `y` with `q`; for a worth adding exactly `c` for each step a keeping
course or a course falling below `m` within the horizon stays met, and at least `c` for each of the
first `n` steps to a course meeting `m` at each of them: where `r ≤ q + c` and `c ≤ m`, the course
holding `y` to the `n`-th step, at nothing after the last and drawing nothing after it, is an
optimum, among the open courses, of the order by the worth. -/
theorem continued_ending_stepwise_frontier {worth : (Nat → Nat) → Nat}
    (bounded : ∀ a, OpenCourse R k s a → Keeps m n a → worth a ≤ drawnOver R a (n + 1) + c * (n + 1))
    (coupledAt : ∀ a j, OpenCourse R k s a → (∀ t, t ≤ j → m ≤ a t) → a (j + 1) < m → j ≤ n →
      worth a ≤ drawnOver R a (n + 1) + c * j)
    (coupledTo : ∀ a, OpenCourse R k s a → (∀ t, t ≤ n → m ≤ a t) →
      drawnOver R a (n + 1) + c * n ≤ worth a)
    (renews : ∀ z, R z ≤ r) (above : ∀ z, m ≤ z → R z ≤ q) (rate : r ≤ q + c) (low : c ≤ m)
    (greatest : R y = q) (needs : m ≤ y) (meets : m ≤ s) (reach : y ≤ s + R s)
    (drawsDown : s + R s ≤ y + k) (holds : y + q ≤ k) (long : 0 < n) :
    Frontier (OpenCourse R k s) (fun b a => worth a < worth b)
      (continued R (holdingTo s y 0 n) n) :=
  have opens : OpenCourse R k s (continued R (holdingTo s y 0 n) n) :=
    continued_open (x := holdingTo s y 0 n) rfl (holdingTo_steps greatest reach (Nat.zero_le y)
      drawsDown (Nat.le_trans holds (Nat.le_of_eq (Nat.zero_add k).symm)) long)
  have most : drawnOver R (continued R (holdingTo s y 0 n) n) (n + 1) = s + R s + q * n := by
    rw [continued_drawn]
    exact holdingTo_most greatest reach (Nat.zero_le y) n
  have least := coupledTo _ opens fun t le => Nat.le_trans (holdingTo_met meets needs t le)
    (Nat.le_of_eq (continued_le (Nat.le_succ_of_le le)).symm)
  ⟨opens, fun b openB more => Nat.not_le_of_gt more
    (match keeps_or_falls (Eq.subst (motive := fun z => m ≤ z) openB.1.symm meets) n with
    | .inl keeps => by
      have kept := keeping_drawn_le above (fun t => (openB.2 t).1) keeps
      rw [openB.1] at kept
      have sum : worth b + m ≤ worth (continued R (holdingTo s y 0 n) n) + m :=
        calc worth b + m ≤ drawnOver R b (n + 1) + c * (n + 1) + m :=
              Nat.add_le_add_right (bounded b openB keeps) m
          _ = drawnOver R b (n + 1) + m + c * (n + 1) := Nat.add_right_comm _ _ _
          _ ≤ s + R s + q * n + c * (n + 1) := Nat.add_le_add_right kept _
          _ = drawnOver R (continued R (holdingTo s y 0 n) n) (n + 1) + c * n + c := by
              rw [most, Nat.mul_succ c n, Nat.add_assoc (s + R s + q * n) (c * n) c]
          _ ≤ worth (continued R (holdingTo s y 0 n) n) + m := Nat.add_le_add least low
      exact Naturals.le_of_add_le_add_right sum
    | .inr ⟨j, le, met, lt⟩ => by
      have drawn := met_drawn_le renews above (fun t => (openB.2 t).1) met le
      rw [openB.1] at drawn
      exact le_of_stepwise_end (coupledAt b j openB met lt le) drawn le most least rate)⟩

/-- What a step coupling above the renewal forgone adds over the steps before the last. -/
theorem stepwise_arith_lt {j i : Nat} (rate : r < q + c) :
    r * (j + 1 + i) + j * q + c * j < q * (j + 1 + i) + c * (j + 1 + i) + j * r :=
  calc r * (j + 1 + i) + j * q + c * j
      = r * (j + i) + j * q + c * j + r := by
        rw [Nat.add_right_comm j 1 i, Nat.mul_succ r (j + i),
          Nat.add_right_comm (r * (j + i)) r (j * q),
          Nat.add_right_comm (r * (j + i) + j * q) r (c * j)]
    _ < q * (j + i) + c * (j + i) + j * r + (q + c) :=
        Nat.lt_of_le_of_lt (Nat.add_le_add_right (stepwise_arith_le (Nat.le_of_lt rate)) r)
          (Nat.add_lt_add_left rate _)
    _ = q * (j + 1 + i) + c * (j + 1 + i) + j * r := by
        rw [Nat.add_right_comm j 1 i, Nat.mul_succ q (j + i), Nat.mul_succ c (j + i),
          Nat.add_right_comm (q * (j + i) + c * (j + i)) (j * r) (q + c),
          Nat.add_add_add_comm (q * (j + i)) (c * (j + i)) q c]

/-- Comparing a course falling below the need before the horizon's last step with one met through
every step but the last and ending at nothing, under a step coupling above the renewal forgone. -/
theorem lt_of_stepwise_end {A D Da Wa S j : Nat} (coupledAt : A ≤ D + c * j)
    (met : D + j * r ≤ S + r * n + j * q) (before : j < n) (most : Da = S + q * n)
    (coupledTo : Da + c * n ≤ Wa) (rate : r < q + c) : A < Wa :=
  have succ : j + 1 ≤ n := before
  match le_dest succ with
  | ⟨i, split⟩ => by
    subst split
    have less : A + j * r < Wa + j * r :=
      calc A + j * r ≤ D + c * j + j * r := Nat.add_le_add_right coupledAt _
        _ = D + j * r + c * j := by rw [Nat.add_right_comm D (c * j) (j * r)]
        _ ≤ S + r * (j + 1 + i) + j * q + c * j := Nat.add_le_add_right met _
        _ = S + (r * (j + 1 + i) + j * q + c * j) := by rw [Nat.add_assoc S, Nat.add_assoc S]
        _ < S + (q * (j + 1 + i) + c * (j + 1 + i) + j * r) :=
            Nat.add_lt_add_left (stepwise_arith_lt rate) _
        _ = Da + c * (j + 1 + i) + j * r := by rw [most, Nat.add_assoc S, Nat.add_assoc S]
        _ ≤ Wa + j * r := Nat.add_le_add_right coupledTo _
    exact Nat.lt_of_add_lt_add_right less

/-- **A coupling a step above the renewal forgone keeps the need to the horizon's last step.** Where
`R` gives at most `r` at every level, at most `q` at every level at or above `m`, and `q` at some `y`
at or above `m` within the start with what is given there, from a start meeting `m`, over a horizon
of at least two steps, with a capacity covering what the first step draws down to `y` and `y` with
`q`; for a worth adding at most `c` for each step met to what a course falling below `m` within the
horizon draws, and at least `c` for each of the first `n` steps to what a course meeting `m` at each
of them draws: where `r < q + c`, every optimum, among the open courses, of every order rising with
the worth stands at `m` or above at every step to the `n`-th. -/
theorem frontier_met_before_end {better : (Nat → Nat) → (Nat → Nat) → Prop}
    {worth : (Nat → Nat) → Nat}
    (rising : ∀ a b, worth a < worth b → better b a)
    (coupledAt : ∀ a j, OpenCourse R k s a → (∀ t, t ≤ j → m ≤ a t) → a (j + 1) < m → j ≤ n →
      worth a ≤ drawnOver R a (n + 1) + c * j)
    (coupledTo : ∀ a, OpenCourse R k s a → (∀ t, t ≤ n → m ≤ a t) →
      drawnOver R a (n + 1) + c * n ≤ worth a)
    (renews : ∀ z, R z ≤ r) (above : ∀ z, m ≤ z → R z ≤ q) (rate : r < q + c)
    (greatest : R y = q) (needs : m ≤ y) (meets : m ≤ s) (reach : y ≤ s + R s)
    (drawsDown : s + R s ≤ y + k) (holds : y + q ≤ k) (long : 0 < n)
    {x : Nat → Nat} (front : Frontier (OpenCourse R k s) better x) : ∀ t, t ≤ n → m ≤ x t :=
  match keeps_or_falls (Eq.subst (motive := fun z => m ≤ z) front.1.1.symm meets) n with
  | .inl keeps => fun t le => keeps t (Nat.le_succ_of_le le)
  | .inr ⟨j, le, met, lt⟩ =>
    match Nat.lt_or_ge j n with
    | .inr ge => fun t within => met t (Nat.le_trans within ge)
    | .inl before => by
      have opens : OpenCourse R k s (continued R (holdingTo s y 0 n) n) :=
        continued_open (x := holdingTo s y 0 n) rfl (holdingTo_steps greatest reach (Nat.zero_le y)
          drawsDown (Nat.le_trans holds (Nat.le_of_eq (Nat.zero_add k).symm)) long)
      have most : drawnOver R (continued R (holdingTo s y 0 n) n) (n + 1) = s + R s + q * n := by
        rw [continued_drawn]
        exact holdingTo_most greatest reach (Nat.zero_le y) n
      have least := coupledTo _ opens fun t le => Nat.le_trans (holdingTo_met meets needs t le)
        (Nat.le_of_eq (continued_le (Nat.le_succ_of_le le)).symm)
      have drawn := met_drawn_le renews above (fun t => (front.1.2 t).1) met le
      rw [front.1.1] at drawn
      exact absurd (rising x _ (lt_of_stepwise_end (coupledAt x j front.1 met lt le) drawn before
        most least rate)) (front.2 _ opens)

/-- **An optimum falling below the need under a step coupling.** Where `R` gives at most `r` at every
level, at most `q` at every level at or above `m`, and `r` at some `y` within the start with what is
given there, from a start meeting `m`, over a horizon of at least two steps, with a capacity covering
what the first step draws down to `y` and `y` with `r`; for a worth at least what a course draws,
at most `c` more for each step a keeping course or a course falling below `m` within the horizon
stays met: where `q + c ≤ r` and `c ≤ m`, the course holding `y` to the `n`-th step, at nothing after
the last and drawing nothing after it, is an optimum, among the open courses, of the order by the
worth. -/
theorem continued_holding_stepwise_frontier {worth : (Nat → Nat) → Nat}
    (draws : ∀ a, drawnOver R a (n + 1) ≤ worth a)
    (bounded : ∀ a, OpenCourse R k s a → Keeps m n a → worth a ≤ drawnOver R a (n + 1) + c * (n + 1))
    (coupledAt : ∀ a j, OpenCourse R k s a → (∀ t, t ≤ j → m ≤ a t) → a (j + 1) < m → j ≤ n →
      worth a ≤ drawnOver R a (n + 1) + c * j)
    (renews : ∀ z, R z ≤ r) (above : ∀ z, m ≤ z → R z ≤ q) (rate : q + c ≤ r) (low : c ≤ m)
    (greatest : R y = r) (meets : m ≤ s) (reach : y ≤ s + R s) (drawsDown : s + R s ≤ y + k)
    (holds : y + r ≤ k) (long : 0 < n) :
    Frontier (OpenCourse R k s) (fun b a => worth a < worth b) (continued R (holding s y n) n) :=
  have most : drawnOver R (continued R (holding s y n) n) (n + 1) = s + R s + r * n :=
    continued_drawn.trans (holding_most renews greatest reach n)
  have least : s + R s + r * n ≤ worth (continued R (holding s y n) n) :=
    Nat.le_trans (Nat.le_of_eq most.symm) (draws _)
  have per : q * n + c * n ≤ r * n :=
    Nat.le_trans (Nat.le_of_eq (by rw [Nat.mul_comm q, Nat.mul_comm c, ← Nat.mul_add,
      Nat.mul_comm])) (Nat.mul_le_mul_right n rate)
  ⟨continued_open (x := holding s y n) rfl (holdingTo_steps greatest reach (Nat.zero_le y)
      drawsDown (Nat.le_trans holds (Nat.le_of_eq (Nat.zero_add k).symm)) long),
   fun b opens more => Nat.not_le_of_gt more (Nat.le_trans (match keeps_or_falls
      (Eq.subst (motive := fun z => m ≤ z) opens.1.symm meets) n with
    | .inl keeps => by
      have kept := keeping_drawn_le above (fun t => (opens.2 t).1) keeps
      rw [opens.1] at kept
      have sum : worth b + m ≤ s + R s + r * n + m :=
        calc worth b + m ≤ drawnOver R b (n + 1) + c * (n + 1) + m :=
              Nat.add_le_add_right (bounded b opens keeps) m
          _ = drawnOver R b (n + 1) + m + c * (n + 1) := Nat.add_right_comm _ _ _
          _ ≤ s + R s + q * n + c * (n + 1) := Nat.add_le_add_right kept _
          _ = s + R s + (q * n + c * n) + c := by
              rw [Nat.mul_succ c n, ← Nat.add_assoc (s + R s + q * n) (c * n) c,
                Nat.add_assoc (s + R s) (q * n) (c * n)]
          _ ≤ s + R s + r * n + m := Nat.add_le_add (Nat.add_le_add_left per _) low
      exact Naturals.le_of_add_le_add_right sum
    | .inr ⟨j, le, met, lt⟩ => by
      have drawn := met_drawn_le renews above (fun t => (opens.2 t).1) met le
      rw [opens.1] at drawn
      have perStep : j * q + c * j ≤ j * r :=
        Nat.le_trans (Nat.le_of_eq (by rw [Nat.mul_comm c j, ← Nat.mul_add]))
          (Nat.mul_le_mul_left j rate)
      have sum : worth b + j * r ≤ s + R s + r * n + j * r :=
        calc worth b + j * r ≤ drawnOver R b (n + 1) + c * j + j * r :=
              Nat.add_le_add_right (coupledAt b j opens met lt le) _
          _ = drawnOver R b (n + 1) + j * r + c * j := Nat.add_right_comm _ _ _
          _ ≤ s + R s + r * n + j * q + c * j := Nat.add_le_add_right drawn _
          _ = s + R s + r * n + (j * q + c * j) := Nat.add_assoc _ _ _
          _ ≤ s + R s + r * n + j * r := Nat.add_le_add_left perStep _
      exact Naturals.le_of_add_le_add_right sum) least)⟩

/-- **A coupling a step below the renewal forgone is outweighed by a long horizon.** Where
`q + c < r`, every end `e` with `c + e < n + m` has `c (n + 1) + q n + e < r n + m`: a coupling of at
most `c` a step falls below what keeping forgoes. -/
theorem outweighed_stepwise {e : Nat} (less : q + c < r) (short : c + e < n + m) :
    c * (n + 1) + q * n + e < r * n + m :=
  have grows : q * n + c * n + n ≤ r * n :=
    Nat.le_trans (Nat.le_of_eq (by rw [Nat.mul_comm q, Nat.mul_comm c, ← Nat.mul_add,
      ← Nat.mul_succ, Nat.mul_comm]))
      (Nat.mul_le_mul_right n (Nat.succ_le_of_lt less))
  calc c * (n + 1) + q * n + e = q * n + c * n + (c + e) := by
        rw [Nat.mul_succ c n, Nat.add_comm (c * n + c) (q * n), Nat.add_assoc (q * n) (c * n + c) e,
          Nat.add_assoc (c * n) c e, ← Nat.add_assoc (q * n) (c * n) (c + e)]
    _ < q * n + c * n + (n + m) := Nat.add_lt_add_left short _
    _ = q * n + c * n + n + m := (Nat.add_assoc _ _ _).symm
    _ ≤ r * n + m := Nat.add_le_add_right grows m


/-! ### Steps met again after a fall -/

/-- The steps from the first to the `n`-th at which a course stands at `m` or above, counted,
wherever they fall. -/
def metCount (m : Nat) (x : Nat → Nat) (n : Nat) : Nat :=
  countUpTo (fun t => decide (m ≤ x (t + 1))) n

/-- A course standing at `m` or above at every step from the first to the `n`-th is met at each. -/
theorem metCount_of_met {x : Nat → Nat} {n : Nat} (met : ∀ t, 0 < t → t ≤ n → m ≤ x t) :
    metCount m x n = n :=
  countUpTo_all fun t lt => decide_eq_true (met (t + 1) (Nat.succ_pos t) lt)

/-- **What a course met at any steps draws and leaves.** Where each step leaves at most the level with
what is given, `R` gives at most `r` at every level and at most `q` at every level at or above `m`:
what a course draws across `n + 1` steps, with what it leaves and `r` for each step from the first
to the `n`-th at which it stands at `m` or above, is at most its start with what is given there,
`r` for each step after the first and `q` for each of those steps, wherever they fall. -/
theorem met_count_drawn_le (renews : ∀ z, R z ≤ r) (above : ∀ z, m ≤ z → R z ≤ q) {x : Nat → Nat}
    (within : ∀ t, x (t + 1) ≤ x t + R (x t)) (n : Nat) :
    drawnOver R x (n + 1) + x (n + 1) + metCount m x n * r ≤
      x 0 + R (x 0) + r * n + metCount m x n * q :=
  have whole : drawnOver R x (n + 1) + x (n + 1) +
      Amounts.whole.sum (fun t => r - R (x (t + 1))) 0 n = x 0 + R (x 0) + r * n :=
    drawn_add_shortfall_after (x := x) (g := fun t => R (x t)) within (fun t => renews (x t)) n
  have short : metCount m x n * r ≤
      Amounts.whole.sum (fun t => r - R (x (t + 1))) 0 n + metCount m x n * q :=
    shortfall_count_ge (g := fun t => R (x (t + 1))) (fun t => decide (m ≤ x (t + 1)))
      fun _ _ holds => above _ (of_decide_eq_true holds)
  Nat.le_trans (Nat.add_le_add_left short _) (Nat.le_of_eq
    ((Nat.add_assoc _ _ _).symm.trans (congrArg (· + metCount m x n * q) whole)))

/-- Comparing a course met at counted steps with a keeping course, under a coupling for every step
met: `J` steps met to the `n`-th, `M` after the last, leaving at least `l`. -/
theorem le_of_met_count {A D Da Wa S e J u M l d : Nat} (split : n = J + u)
    (coupledAt : A ≤ D + c * (J + M)) (drawn : D + l + J * r ≤ S + r * n + J * q)
    (most : Da + e = S + q * n) (coupled : Da + c * (n + 1) ≤ Wa)
    (key : r * u + (c * M + (d + e)) ≤ q * u + (c * u + c) + l) : A + d ≤ Wa := by
  subst split
  rw [Nat.mul_add c J M] at coupledAt
  rw [Nat.mul_add r J u, Nat.mul_comm J r, Nat.mul_comm J q] at drawn
  rw [Nat.mul_add q J u] at most
  rw [Nat.mul_add c (J + u) 1, Nat.mul_add c J u, Nat.mul_one] at coupled
  have short : D + l ≤ S + r * u + q * J := by
    rw [Nat.add_comm (r * J) (r * u), ← Nat.add_assoc S (r * u) (r * J),
      Nat.add_right_comm (S + r * u) (r * J) (q * J)] at drawn
    exact Naturals.le_of_add_le_add_right drawn
  have kept : Da + (c * J + c * u + c) + (l + e) =
      S + q * J + c * J + (q * u + (c * u + c) + l) :=
    calc Da + (c * J + c * u + c) + (l + e) = Da + e + (c * J + c * u + c) + l := by
          rw [Nat.add_comm l e, ← Nat.add_assoc (Da + (c * J + c * u + c)) e l,
            Nat.add_right_comm Da (c * J + c * u + c) e]
      _ = S + (q * J + q * u) + (c * J + c * u + c) + l := by rw [most]
      _ = S + q * J + c * J + (q * u + (c * u + c) + l) := by
          rw [← Nat.add_assoc S (q * J) (q * u), Nat.add_assoc (c * J) (c * u) c,
            add_four (S + q * J) (q * u) (c * J) (c * u + c),
            Nat.add_assoc (S + q * J + c * J) (q * u + (c * u + c)) l]
  apply Naturals.le_of_add_le_add_right (k := l + e)
  calc A + d + (l + e) ≤ D + (c * J + c * M) + d + (l + e) :=
        Nat.add_le_add_right (Nat.add_le_add_right coupledAt d) _
    _ = D + l + (c * J + c * M + (d + e)) := by
        rw [add_four (D + (c * J + c * M)) d l e, Nat.add_right_comm D (c * J + c * M) l,
          Nat.add_assoc (D + l) (c * J + c * M) (d + e)]
    _ ≤ S + r * u + q * J + (c * J + c * M + (d + e)) := Nat.add_le_add_right short _
    _ = S + q * J + c * J + (r * u + (c * M + (d + e))) := by
        rw [Nat.add_right_comm S (r * u) (q * J), Nat.add_assoc (c * J) (c * M) (d + e),
          add_four (S + q * J) (r * u) (c * J) (c * M + (d + e))]
    _ ≤ S + q * J + c * J + (q * u + (c * u + c) + l) := Nat.add_le_add_left key _
    _ = Da + (c * J + c * u + c) + (l + e) := kept.symm
    _ ≤ Wa + (l + e) := Nat.add_le_add_right coupled _

/-- What `r` gives over `v` steps is at most what `q` and `c` give, where `r ≤ q + c`. -/
theorem mul_le_of_rate (rate : r ≤ q + c) (v : Nat) : r * v ≤ q * v + c * v :=
  Nat.le_trans (Nat.le_of_eq (Nat.mul_comm r v)) (Nat.le_trans (Nat.mul_le_mul_left v rate)
    (Nat.le_of_eq ((Nat.mul_add v q c).trans (by rw [Nat.mul_comm v q, Nat.mul_comm v c]))))

/-- The renewal forgone at steps met short of the horizon, against a fall that is met again at its
end. -/
theorem met_key_end {v e d : Nat} (rate : r ≤ q + c) (atEnd : r + e + d ≤ q + c + m) :
    r * (v + 1) + (c * 1 + (d + e)) ≤ q * (v + 1) + (c * (v + 1) + c) + m :=
  have hv : r * v ≤ q * v + c * v := mul_le_of_rate rate v
  calc r * (v + 1) + (c * 1 + (d + e)) = r * v + (r + e + d) + c := by
        rw [Nat.mul_add r v 1, Nat.mul_one r, Nat.mul_one c, Nat.add_assoc (r * v) r (c + (d + e)),
          Nat.add_assoc (r * v) (r + e + d) c, Nat.add_comm d e, Nat.add_comm c (e + d),
          ← Nat.add_assoc r (e + d) c, ← Nat.add_assoc r e d]
    _ ≤ q * v + c * v + (q + c + m) + c := Nat.add_le_add_right (Nat.add_le_add hv atEnd) c
    _ = q * (v + 1) + (c * (v + 1) + c) + m := by
        rw [Nat.mul_add q v 1, Nat.mul_one q, Nat.mul_add c v 1, Nat.mul_one c,
          Nat.add_assoc (q * v + c * v) (q + c + m) c, Nat.add_right_comm (q + c) m c,
          Nat.add_assoc q c c, Nat.add_assoc (c * v) c c, add_four (q * v) q (c * v) (c + c),
          Nat.add_assoc (q * v + c * v) (q + (c + c)) m]

/-- The renewal forgone at steps met short of the horizon, against a course below the need at its
end. -/
theorem met_key_drop {u e d : Nat} (rate : r ≤ q + c) (drop : e + d ≤ c) :
    r * u + (c * 0 + (d + e)) ≤ q * u + (c * u + c) + 0 :=
  have hu : r * u ≤ q * u + c * u := mul_le_of_rate rate u
  calc r * u + (c * 0 + (d + e)) = r * u + (e + d) := by
        rw [Nat.mul_zero, Nat.zero_add, Nat.add_comm d e]
    _ ≤ q * u + c * u + c := Nat.add_le_add hu drop
    _ = q * u + (c * u + c) + 0 := by rw [Nat.add_zero, Nat.add_assoc]

/-- **A course falling below the need is worth no more than one keeping it, wherever it is met
again.** Where `R` gives at most `r` at every level and at most `q` at every level at or above `m`,
for a worth at most what a course draws with `c` for each step from the first to the horizon's last
at which it stands at `m` or above, and a keeping course drawing with what it leaves `e` the start
with what is given there and `q` for each step after, worth at least what it draws with `c` for each
step: an open course below `m` at some step from the first to the last is worth at most the keeping
course, less `d`, where `r ≤ q + c`, `r + e + d ≤ q + c + m` and `e + d ≤ c`. -/
theorem falls_met_le {worth : (Nat → Nat) → Nat} {e d : Nat} {x K : Nat → Nat}
    (renews : ∀ z, R z ≤ r) (above : ∀ z, m ≤ z → R z ≤ q) (opens : OpenCourse R k s x)
    (counted : worth x ≤ drawnOver R x (n + 1) + c * metCount m x (n + 1))
    (most : drawnOver R K (n + 1) + e = s + R s + q * n)
    (coupled : drawnOver R K (n + 1) + c * (n + 1) ≤ worth K)
    (rate : r ≤ q + c) (atEnd : r + e + d ≤ q + c + m) (drop : e + d ≤ c)
    {t : Nat} (le : t ≤ n) (below : x (t + 1) < m) : worth x + d ≤ worth K := by
  have drawn : drawnOver R x (n + 1) + x (n + 1) + metCount m x n * r ≤
      s + R s + r * n + metCount m x n * q :=
    Eq.subst (motive := fun z => drawnOver R x (n + 1) + x (n + 1) + metCount m x n * r ≤
      z + R z + r * n + metCount m x n * q) opens.1
      (met_count_drawn_le renews above (fun t => (opens.2 t).1) n)
  have unmet : decide (m ≤ x (t + 1)) = false := decide_eq_false (Nat.not_le_of_gt below)
  cases holds : decide (m ≤ x (n + 1)) with
  | true =>
    have met : m ≤ x (n + 1) := of_decide_eq_true holds
    have count : metCount m x (n + 1) = metCount m x n + 1 := by
      show countUpTo (fun t => decide (m ≤ x (t + 1))) n +
        (if decide (m ≤ x (n + 1)) = true then 1 else 0) = _
      rw [holds]
      rfl
    have short : t < n := match Nat.lt_or_ge t n with
      | .inl lt => lt
      | .inr ge => absurd met (Nat.not_le_of_gt (Eq.subst (motive := fun z => x (z + 1) < m)
          (Nat.le_antisymm le ge) below))
    match le_dest (countUpTo_lt (p := fun t => decide (m ≤ x (t + 1))) unmet short) with
    | ⟨v, split⟩ =>
      exact le_of_met_count (J := metCount m x n) (u := v + 1) (M := 1) (l := m)
        (split.trans ((Nat.add_right_comm _ 1 v).trans (Nat.add_assoc _ v 1)))
        (Nat.le_trans counted (Nat.le_of_eq
          (congrArg (fun z => drawnOver R x (n + 1) + c * z) count)))
        (Nat.le_trans (Nat.add_le_add_right (Nat.add_le_add_left met _) _) drawn) most coupled
        (met_key_end rate atEnd)
  | false =>
    have count : metCount m x (n + 1) = metCount m x n + 0 := by
      show countUpTo (fun t => decide (m ≤ x (t + 1))) n +
        (if decide (m ≤ x (n + 1)) = true then 1 else 0) = _
      rw [holds]
      rfl
    match le_dest (countUpTo_le (fun t => decide (m ≤ x (t + 1))) n) with
    | ⟨u, split⟩ =>
      exact le_of_met_count (J := metCount m x n) (u := u) (M := 0) (l := 0) split
        (Nat.le_trans counted (Nat.le_of_eq
          (congrArg (fun z => drawnOver R x (n + 1) + c * z) count)))
        (Nat.le_trans (Nat.add_le_add_right (Nat.add_le_add_left (Nat.zero_le _) _) _) drawn) most
        coupled (met_key_drop rate drop)

/-- **A coupling for every step met keeps the need, wherever those steps fall.** Where `R` gives at
most `r` at every level, at most `q` at every level at or above `m`, and `q` at some `y` within the
start with what is given there, from a start meeting `m`, over a horizon of at least two steps, with
a capacity covering what the first step draws down to `y` and `y` with `q` down to some `e` between
`m` and `y`; for a worth adding at least `c` for each step to what a keeping course draws, and at
most `c` for each step at which a course stands at `m` or above, wherever: where
`r + e < q + c + m` and `e < c`, every optimum, among the open courses, of every order rising with
the worth keeps its level at `m` or above through the horizon. A fall met again forgoes `c` for each
step below and gains at most the renewal forgone there and the end's excess over the need, so the
threshold is above the one counting from the start, `r ≤ q + c` (`frontier_keeps_stepwise`). -/
theorem frontier_keeps_met {better : (Nat → Nat) → (Nat → Nat) → Prop}
    {worth : (Nat → Nat) → Nat} {e : Nat}
    (rising : ∀ a b, worth a < worth b → better b a)
    (coupled : ∀ a, OpenCourse R k s a → Keeps m n a → drawnOver R a (n + 1) + c * (n + 1) ≤ worth a)
    (counted : ∀ a, OpenCourse R k s a →
      worth a ≤ drawnOver R a (n + 1) + c * metCount m a (n + 1))
    (renews : ∀ z, R z ≤ r) (above : ∀ z, m ≤ z → R z ≤ q) (atEnd : r + e < q + c + m)
    (exceeds : e < c) (greatest : R y = q) (meets : m ≤ s) (ends : m ≤ e) (reach : y ≤ s + R s)
    (settles : e ≤ y) (drawsDown : s + R s ≤ y + k) (holds : y + q ≤ e + k) (long : 0 < n)
    {x : Nat → Nat} (front : Frontier (OpenCourse R k s) better x) : Keeps m n x :=
  match keeps_or_falls (Eq.subst (motive := fun z => m ≤ z) front.1.1.symm meets) n with
  | .inl keeps => keeps
  | .inr ⟨_, le, _, below⟩ =>
    have opens : OpenCourse R k s (continued R (holdingTo s y e n) n) :=
      continued_open (x := holdingTo s y e n) rfl
        (holdingTo_steps greatest reach settles drawsDown holds long)
    have most : drawnOver R (continued R (holdingTo s y e n) n) (n + 1) + e = s + R s + q * n :=
      (congrArg (· + e) continued_drawn).trans (holdingTo_most greatest reach settles n)
    have rate : r ≤ q + c := Nat.le_of_lt (Naturals.le_of_add_le_add_right (k := m)
      (Nat.le_trans (Nat.le_of_eq (Nat.add_right_comm r 1 m))
        (Nat.lt_of_le_of_lt (Nat.add_le_add_left ends r) atEnd)))
    absurd (rising x _ (falls_met_le (d := 1) renews above front.1 (counted x front.1) most
      (coupled _ opens (continued_keeps (holdingTo_keeps meets (Nat.le_trans ends settles) ends)))
      rate atEnd exceeds le below)) (front.2 _ opens)

/-- **The optimum keeping the need under a coupling for every step met.** Under the premises of
`frontier_keeps_met` with the keeping course ending at `m`, for a worth adding exactly `c` for each
step to what a keeping course draws, where `r ≤ q + c` and `m ≤ c`: the course holding `y` to the
`n`-th step, at `m` after the last and drawing nothing after it, is an optimum, among the open
courses, of the order by the worth. -/
theorem continued_met_frontier {worth : (Nat → Nat) → Nat}
    (coupled : ∀ a, OpenCourse R k s a → Keeps m n a → drawnOver R a (n + 1) + c * (n + 1) ≤ worth a)
    (bounded : ∀ a, OpenCourse R k s a → Keeps m n a → worth a ≤ drawnOver R a (n + 1) + c * (n + 1))
    (counted : ∀ a, OpenCourse R k s a →
      worth a ≤ drawnOver R a (n + 1) + c * metCount m a (n + 1))
    (renews : ∀ z, R z ≤ r) (above : ∀ z, m ≤ z → R z ≤ q) (rate : r ≤ q + c) (exceeds : m ≤ c)
    (greatest : R y = q) (needs : m ≤ y) (meets : m ≤ s) (reach : y ≤ s + R s)
    (drawsDown : s + R s ≤ y + k) (holds : y + q ≤ m + k) (long : 0 < n) :
    Frontier (OpenCourse R k s) (fun b a => worth a < worth b)
      (continued R (holdingTo s y m n) n) :=
  have optimum := continued_keeping_frontier above greatest needs meets reach drawsDown holds long
  have most : drawnOver R (continued R (holdingTo s y m n) n) (n + 1) + m = s + R s + q * n :=
    (congrArg (· + m) continued_drawn).trans (holdingTo_most greatest reach needs n)
  have least := coupled _ optimum.1.1 optimum.1.2
  have atEnd : r + m + 0 ≤ q + c + m := Nat.add_le_add_right rate m
  ⟨optimum.1.1, fun b opens more => Nat.not_le_of_gt more
    (match keeps_or_falls (Eq.subst (motive := fun z => m ≤ z) opens.1.symm meets) n with
    | .inl keeps => Nat.le_trans (bounded b opens keeps) (Nat.le_trans (Nat.add_le_add_right
        (Nat.ge_of_not_lt (optimum.2 b ⟨opens, keeps⟩)) _) least)
    | .inr ⟨_, le, _, below⟩ => falls_met_le (d := 0) renews above opens (counted b opens) most least
        rate atEnd exceeds le below)⟩

end Optimum

namespace Flow

open Optimum

variable {L : Flow F C} {W : Web F C} {c : C}

/-- **What a balanced course met through `j` steps takes.** Where what is given to a condition is a
law `R` of its level, at most `r` at every level and at most `q` at every level at or above `m`, and
the course of its levels stands at `m` or above at every step to the `j`-th, `j ≤ n`: what is taken
there across `n + 1` steps, with `r` for each of those `j` steps, is at most the starting level with
what is given there, `r` for each step after the first and `q` for each of those `j` steps. -/
theorem Balances.met_taken_le {R : Nat → Nat} {q r m n j : Nat} (balances : L.Balances W)
    (renewal : ∀ t, L.given t c = R (W.level t c)) (renews : ∀ z, R z ≤ r)
    (above : ∀ z, m ≤ z → R z ≤ q) (met : ∀ t, t ≤ j → m ≤ W.level t c) (le : j ≤ n) :
    Amounts.whole.sum (fun t => L.taken t c) 0 (n + 1) + j * r ≤
      W.level 0 c + R (W.level 0 c) + r * n + j * q :=
  Nat.le_trans (Nat.le_of_eq (congrArg (· + j * r) (sum_eq_of_eq fun t _ =>
      ((congrArg (fun z => W.level t c + z - W.level (t + 1) c) (renewal t)).symm.trans
        (balances.drawnAt_eq c t)).symm)))
    (met_drawn_le (x := fun t => W.level t c) renews above (fun t => Nat.le_trans (balances.within c t)
      (Nat.le_of_eq (congrArg (W.level t c + ·) (renewal t)))) met le)

end Flow

namespace Web

open Optimum

variable {W : Web F C} {c : C} {f : F} {R : Nat → Nat} {k q r s y m n e w : Nat}
  {better : (Nat → Nat) → (Nat → Nat) → Prop} {worth : (Nat → Nat) → Nat}

/-- **A coupling a step covering the renewal forgone and exceeding the end keeps a dependence at
every horizon.** Under the premises of `Optimum.frontier_keeps_stepwise`, with a formation's need on
the condition `m` at every step: every optimum, among the open courses, of every order rising with a
worth adding at least `w` for each step to what a keeping course draws and at most `w` for each step
met to what a course falling below the need draws meets the need at every step through the horizon,
where `r ≤ q + w` and `e < w`. -/
theorem frontier_keeps_stepwise
    (rising : ∀ a b, worth a < worth b → better b a)
    (coupled : ∀ a, OpenCourse R k s a → Optimum.Keeps m n a →
      drawnOver R a (n + 1) + w * (n + 1) ≤ worth a)
    (coupledAt : ∀ a j, OpenCourse R k s a → (∀ t, t ≤ j → m ≤ a t) → a (j + 1) < m → j ≤ n →
      worth a ≤ drawnOver R a (n + 1) + w * j)
    (renews : ∀ z, R z ≤ r) (above : ∀ z, m ≤ z → R z ≤ q) (rate : r ≤ q + w) (exceeds : e < w)
    (greatest : R y = q) (meets : m ≤ s) (ends : m ≤ e) (reach : y ≤ s + R s) (settles : e ≤ y)
    (drawsDown : s + R s ≤ y + k) (holds : y + q ≤ e + k) (long : 0 < n)
    (front : Frontier (OpenCourse R k s) better fun t => W.level t c)
    (need : ∀ t, W.need t f c = m) :
    ∀ t, t ≤ n + 1 → W.need t f c ≤ W.level t c :=
  fun t le => Nat.le_trans (Nat.le_of_eq (need t))
    (Optimum.frontier_keeps_stepwise rising coupled coupledAt renews above rate exceeds greatest
      meets ends reach settles drawsDown holds long front t le)

/-- **Below the need, the horizon's end breaks a dependence.** Under the premises of
`Optimum.frontier_breaks_at_end`, with a formation depending on the condition at the need `m` at
every step, met at the start: every optimum, among the open courses, of every order rising with a
worth adding at most `w` for each step to what a keeping course draws and at least `w` for each of
the first `n` steps to a course meeting the need at each of them breaks the dependence at some step
to the `n`-th, where `w + e < m`. -/
theorem frontier_breaks_at_end
    (rising : ∀ a b, worth a < worth b → better b a)
    (bounded : ∀ a, OpenCourse R k s a → Optimum.Keeps m n a →
      worth a ≤ drawnOver R a (n + 1) + w * (n + 1))
    (coupledTo : ∀ a, OpenCourse R k s a → (∀ t, t ≤ n → m ≤ a t) →
      drawnOver R a (n + 1) + w * n ≤ worth a)
    (above : ∀ z, m ≤ z → R z ≤ q) (short : w + e < m)
    (greatest : R y = q) (needs : m ≤ y) (meets : m ≤ s) (reach : y ≤ s + R s) (settles : e ≤ y)
    (drawsDown : s + R s ≤ y + k) (holds : y + q ≤ e + k) (long : 0 < n)
    (front : Frontier (OpenCourse R k s) better fun t => W.level t c)
    (depends : ∀ t, W.requires t f c) (need : ∀ t, W.need t f c = m) :
    ∃ t, t ≤ n ∧ W.Broken t f c :=
  match drops_of_not_keeps (Eq.subst (motive := fun z => m ≤ z) front.1.1.symm meets)
      (Optimum.frontier_breaks_at_end rising bounded coupledTo above short greatest needs meets
        reach settles drawsDown holds long front) with
  | ⟨t, le, met, lt⟩ => ⟨t, le, depends t, Nat.le_trans (Nat.le_of_eq (need t)) met,
      Nat.lt_of_lt_of_le lt (Nat.le_of_eq (need t).symm)⟩

/-- **A coupling a step above the renewal forgone keeps a dependence to the horizon's last step.**
Under the premises of `Optimum.frontier_met_before_end`, with a formation's need on the condition
`m` at every step: every optimum, among the open courses, of every order rising with a worth adding
at most `w` for each step met to what a course falling below the need draws and at least `w` for
each of the first `n` steps to a course meeting the need at each of them meets the need at every
step to the `n`-th, where `r < q + w`. -/
theorem frontier_met_before_end
    (rising : ∀ a b, worth a < worth b → better b a)
    (coupledAt : ∀ a j, OpenCourse R k s a → (∀ t, t ≤ j → m ≤ a t) → a (j + 1) < m → j ≤ n →
      worth a ≤ drawnOver R a (n + 1) + w * j)
    (coupledTo : ∀ a, OpenCourse R k s a → (∀ t, t ≤ n → m ≤ a t) →
      drawnOver R a (n + 1) + w * n ≤ worth a)
    (renews : ∀ z, R z ≤ r) (above : ∀ z, m ≤ z → R z ≤ q) (rate : r < q + w)
    (greatest : R y = q) (needs : m ≤ y) (meets : m ≤ s) (reach : y ≤ s + R s)
    (drawsDown : s + R s ≤ y + k) (holds : y + q ≤ k) (long : 0 < n)
    (front : Frontier (OpenCourse R k s) better fun t => W.level t c)
    (need : ∀ t, W.need t f c = m) :
    ∀ t, t ≤ n → W.need t f c ≤ W.level t c :=
  fun t le => Nat.le_trans (Nat.le_of_eq (need t))
    (Optimum.frontier_met_before_end rising coupledAt coupledTo renews above rate greatest needs
      meets reach drawsDown holds long front t le)

/-- **Between the renewal forgone and the need, the horizon's end breaks a dependence at its last
step alone.** Under the premises of `Web.frontier_met_before_end` and of `Web.frontier_breaks_at_end`
with the end at nothing, for a dependence at the need `m` at every step: every optimum, among the
open courses, of every order rising with a worth adding at most `w` for each step met to what a
course falling below the need or keeping it draws and at least `w` for each of the first `n` steps
to a course meeting the need at each of them, where `r < q + w` and `w < m`, meets the need at every
step to the `n`-th and breaks the dependence at the `n`-th. -/
theorem frontier_breaks_last
    (rising : ∀ a b, worth a < worth b → better b a)
    (bounded : ∀ a, OpenCourse R k s a → Optimum.Keeps m n a →
      worth a ≤ drawnOver R a (n + 1) + w * (n + 1))
    (coupledAt : ∀ a j, OpenCourse R k s a → (∀ t, t ≤ j → m ≤ a t) → a (j + 1) < m → j ≤ n →
      worth a ≤ drawnOver R a (n + 1) + w * j)
    (coupledTo : ∀ a, OpenCourse R k s a → (∀ t, t ≤ n → m ≤ a t) →
      drawnOver R a (n + 1) + w * n ≤ worth a)
    (renews : ∀ z, R z ≤ r) (above : ∀ z, m ≤ z → R z ≤ q) (rate : r < q + w) (short : w < m)
    (greatest : R y = q) (needs : m ≤ y) (meets : m ≤ s) (reach : y ≤ s + R s)
    (drawsDown : s + R s ≤ y + k) (holds : y + q ≤ k) (long : 0 < n)
    (front : Frontier (OpenCourse R k s) better fun t => W.level t c)
    (depends : ∀ t, W.requires t f c) (need : ∀ t, W.need t f c = m) :
    (∀ t, t ≤ n → W.need t f c ≤ W.level t c) ∧ W.Broken n f c :=
  have met := Web.frontier_met_before_end rising coupledAt coupledTo renews above rate greatest
    needs meets reach drawsDown holds long front need
  match Web.frontier_breaks_at_end (e := 0) rising bounded coupledTo above short greatest needs
      meets reach (Nat.zero_le y) drawsDown (Nat.le_trans holds (Nat.le_of_eq (Nat.zero_add k).symm))
      long front depends need with
  | ⟨t, le, broken⟩ =>
    match Nat.lt_or_ge t n with
    | .inl before => (Nat.lt_irrefl (W.level (t + 1) c) (Nat.lt_of_lt_of_le broken.2.2
        (Nat.le_trans (Nat.le_of_eq ((need t).trans (need (t + 1)).symm)) (met (t + 1) before)))).elim
    | .inr ge => ⟨met, Nat.le_antisymm le ge ▸ broken⟩

/-- **A coupling a step below the renewal forgone breaks a dependence over a long horizon.** Under
the premises of `Web.frontier_breaks_below`, for a worth adding at most `w (n + 1)` to what a keeping
course draws, where `q + w < r` and `w + e < n + m`: every optimum breaks the dependence within the
horizon. -/
theorem frontier_breaks_stepwise_long
    (rising : ∀ a b, worth a < worth b → better b a)
    (draws : ∀ a, drawnOver R a (n + 1) ≤ worth a)
    (bounded : ∀ a, OpenCourse R k s a → Optimum.Keeps m n a →
      worth a ≤ drawnOver R a (n + 1) + w * (n + 1))
    (above : ∀ z, m ≤ z → R z ≤ q) (less : q + w < r) (short : w + e < n + m)
    (greatest : R y = r) (reach : y ≤ s + R s) (settles : e ≤ y) (drawsDown : s + R s ≤ y + k)
    (holds : y + r ≤ e + k) (long : 0 < n)
    (front : Frontier (OpenCourse R k s) better fun t => W.level t c)
    (depends : ∀ t, W.requires t f c) (need : ∀ t, W.need t f c = m) (start : m ≤ s) :
    ∃ t, t ≤ n ∧ W.Broken t f c :=
  Web.frontier_breaks_below rising draws bounded above (outweighed_stepwise less short) greatest
    reach settles drawsDown holds long front depends need start


/-- **A coupling for every step met keeps the dependence, wherever those steps fall.** Under the
premises of `Optimum.frontier_keeps_met`, with a formation's need on the condition `m` at every step:
every optimum, among the open courses, of every order rising with a worth adding at least `w` for each
step to what a course keeping the condition at `m` or above draws, and at most `w` for each step at
which a course stands at `m` or above, wherever, meets the need at every step through the horizon,
where `r + e < q + w + m` and `e < w`. -/
theorem frontier_met_kept
    (rising : ∀ a b, worth a < worth b → better b a)
    (coupled : ∀ a, OpenCourse R k s a → Optimum.Keeps m n a →
      drawnOver R a (n + 1) + w * (n + 1) ≤ worth a)
    (counted : ∀ a, OpenCourse R k s a →
      worth a ≤ drawnOver R a (n + 1) + w * Optimum.metCount m a (n + 1))
    (renews : ∀ z, R z ≤ r) (above : ∀ z, m ≤ z → R z ≤ q) (atEnd : r + e < q + w + m)
    (exceeds : e < w) (greatest : R y = q) (meets : m ≤ s) (ends : m ≤ e) (reach : y ≤ s + R s)
    (settles : e ≤ y) (drawsDown : s + R s ≤ y + k) (holds : y + q ≤ e + k) (long : 0 < n)
    (front : Frontier (OpenCourse R k s) better fun t => W.level t c)
    (need : ∀ t, W.need t f c = m) :
    ∀ t, t ≤ n + 1 → W.need t f c ≤ W.level t c :=
  fun t le => Nat.le_trans (Nat.le_of_eq (need t))
    (Optimum.frontier_keeps_met rising coupled counted renews above atEnd exceeds greatest meets ends
      reach settles drawsDown holds long front t le)

end Web

namespace Optimum

namespace Holding

open Diversion

/-- How many of the steps to the `T`-th a course stands at `m` or above from the start through. -/
def metRun (m : Nat) (x : Nat → Nat) : Nat → Nat
  | 0 => 0
  | t + 1 => metRun m x t + metThrough m x (t + 1)

/-- A course standing at `m` or above at every step to the `T`-th is met for all `T` of them. -/
theorem metRun_of_met {m : Nat} {x : Nat → Nat} :
    ∀ {T : Nat}, (∀ t, t ≤ T → m ≤ x t) → metRun m x T = T
  | 0, _ => rfl
  | T + 1, met => show metRun m x T + metThrough m x (T + 1) = T + 1 from
      (congrArg (· + metThrough m x (T + 1))
        (metRun_of_met fun t le => met t (Nat.le_succ_of_le le))).trans
        (congrArg (T + ·) (metThrough_of_keeps met))

/-- A course met through `j` steps and below `m` at the next is met for `j` steps, whatever later. -/
theorem metRun_of_falls {m j : Nat} {x : Nat → Nat} (met : ∀ t, t ≤ j → m ≤ x t)
    (below : x (j + 1) < m) : ∀ i, metRun m x (j + i) = j
  | 0 => metRun_of_met met
  | i + 1 => show metRun m x (j + i) + metThrough m x (j + i + 1) = j from
      (congrArg (· + metThrough m x (j + i + 1)) (metRun_of_falls met below i)).trans
        (congrArg (j + ·) (metThrough_of_below (Nat.succ_le_succ (Nat.le_add_right j i)) below))

/-- A course met through `j` steps is met for at least `j` of any `j + i` steps. -/
theorem metRun_ge {m j : Nat} {x : Nat → Nat} (met : ∀ t, t ≤ j → m ≤ x t) :
    ∀ i, j ≤ metRun m x (j + i)
  | 0 => Nat.le_of_eq (metRun_of_met met).symm
  | i + 1 => Nat.le_trans (metRun_ge met i) (Nat.le_add_right _ _)

/-- What a course draws across `n + 1` steps under `R`, with `c` for each of them it stays at `m` or
above from the start through. -/
def stepwiseDraw (R : Nat → Nat) (m c n : Nat) (x : Nat → Nat) : Nat :=
  drawnOver R x (n + 1) + c * metRun m x (n + 1)

/-- A course keeping `m` through the horizon adds `c` for each of its steps. -/
theorem stepwiseDraw_of_keeps {R : Nat → Nat} {m c n : Nat} {x : Nat → Nat} (keeps : Keeps m n x) :
    stepwiseDraw R m c n x = drawnOver R x (n + 1) + c * (n + 1) :=
  congrArg (fun z => drawnOver R x (n + 1) + c * z) (metRun_of_met keeps)

/-- A course met through `j` steps of the horizon and below `m` at the next adds `c` for each of the
`j`. -/
theorem stepwiseDraw_of_falls {R : Nat → Nat} {m c n j : Nat} {x : Nat → Nat}
    (met : ∀ t, t ≤ j → m ≤ x t) (below : x (j + 1) < m) (le : j ≤ n) :
    stepwiseDraw R m c n x = drawnOver R x (n + 1) + c * j :=
  match le_dest (Nat.le_succ_of_le le) with
  | ⟨i, split⟩ => congrArg (fun z => drawnOver R x (n + 1) + c * z)
      ((congrArg (metRun m x) split).trans (metRun_of_falls met below i))

/-- A course met through the first `n` steps adds at least `c` for each. -/
theorem stepwiseDraw_ge {R : Nat → Nat} {m c n : Nat} {x : Nat → Nat}
    (met : ∀ t, t ≤ n → m ≤ x t) : drawnOver R x (n + 1) + c * n ≤ stepwiseDraw R m c n x :=
  Nat.add_le_add_left (Nat.mul_le_mul_left c (metRun_ge met 1)) _

/-- **The logistic witness: a coupling a step.** From a source at two, the level the dweller needs,
under the logistic law with capacity two, under the order by what the taker draws with `c` added for
each step the source stays at two or above from the start through the horizon of `n + 2` steps:
where `3 ≤ c`, the course staying at two is an optimum and every optimum keeps the dweller met
through the horizon, whatever `n` (`continued_stepwise_frontier`, `Web.frontier_keeps_stepwise`);
where `2 ≤ c`, every optimum meets the dweller at every step but the horizon's last
(`Web.frontier_met_before_end`); where `1 ≤ c ≤ 2`, the course keeping the dweller met to the last
step and drawing the source to nothing there is an optimum
(`continued_ending_stepwise_frontier`); where `c ≤ 1`, the course drawing the source to one and holding it there is an optimum and every
optimum breaks the dweller within the horizon (`continued_holding_stepwise_frontier`,
`Web.frontier_breaks_at_end`). A coupling of the whole keeping must exceed `n + 3`
(`logistic_coupled`). -/
theorem logistic_stepwise (n c : Nat) :
    (3 ≤ c →
      Frontier (OpenCourse logistic 2 2)
        (fun b a => stepwiseDraw logistic 2 c (n + 1) a < stepwiseDraw logistic 2 c (n + 1) b)
        (continued logistic (holdingTo 2 2 2 (n + 1)) (n + 1)) ∧
      ∀ x, Frontier (OpenCourse logistic 2 2)
        (fun b a => stepwiseDraw logistic 2 c (n + 1) a < stepwiseDraw logistic 2 c (n + 1) b) x →
      ∀ t, t ≤ n + 2 → (web (onSource x)).need t .dweller .source ≤
        (web (onSource x)).level t .source) ∧
    (2 ≤ c → ∀ x, Frontier (OpenCourse logistic 2 2)
        (fun b a => stepwiseDraw logistic 2 c (n + 1) a < stepwiseDraw logistic 2 c (n + 1) b) x →
      ∀ t, t ≤ n + 1 → (web (onSource x)).need t .dweller .source ≤
        (web (onSource x)).level t .source) ∧
    (1 ≤ c → c ≤ 2 →
      Frontier (OpenCourse logistic 2 2)
        (fun b a => stepwiseDraw logistic 2 c (n + 1) a < stepwiseDraw logistic 2 c (n + 1) b)
        (continued logistic (holdingTo 2 2 0 (n + 1)) (n + 1))) ∧
    (c ≤ 1 →
      Frontier (OpenCourse logistic 2 2)
        (fun b a => stepwiseDraw logistic 2 c (n + 1) a < stepwiseDraw logistic 2 c (n + 1) b)
        (continued logistic (holding 2 1 (n + 1)) (n + 1)) ∧
      ∀ x, Frontier (OpenCourse logistic 2 2)
        (fun b a => stepwiseDraw logistic 2 c (n + 1) a < stepwiseDraw logistic 2 c (n + 1) b) x →
      ∃ t, t ≤ n + 1 ∧ (web (onSource x)).Broken t .dweller .source) :=
  have coupled : ∀ a, OpenCourse logistic 2 2 a → Keeps 2 (n + 1) a →
      drawnOver logistic a (n + 1 + 1) + c * (n + 1 + 1) ≤ stepwiseDraw logistic 2 c (n + 1) a :=
    fun _ _ keeps => Nat.le_of_eq (stepwiseDraw_of_keeps keeps).symm
  have bounded : ∀ a, OpenCourse logistic 2 2 a → Keeps 2 (n + 1) a →
      stepwiseDraw logistic 2 c (n + 1) a ≤ drawnOver logistic a (n + 1 + 1) + c * (n + 1 + 1) :=
    fun _ _ keeps => Nat.le_of_eq (stepwiseDraw_of_keeps keeps)
  have coupledAt : ∀ a j, OpenCourse logistic 2 2 a → (∀ t, t ≤ j → 2 ≤ a t) → a (j + 1) < 2 →
      j ≤ n + 1 → stepwiseDraw logistic 2 c (n + 1) a ≤ drawnOver logistic a (n + 1 + 1) + c * j :=
    fun _ _ _ met below le => Nat.le_of_eq (stepwiseDraw_of_falls met below le)
  ⟨fun three =>
    have rate : 1 ≤ 0 + c :=
      Nat.le_trans (Nat.le_trans (Nat.le_add_left 1 2) three) (Nat.le_of_eq (Nat.zero_add c).symm)
    ⟨continued_stepwise_frontier (R := logistic) (k := 2) (s := 2) (m := 2) (n := n + 1)
      (y := 2) (q := 0) (r := 1) coupled bounded coupledAt logistic_le logistic_above rate three rfl
      (Nat.le_refl 2) (Nat.le_refl 2) (Nat.le_refl 2) (Nat.le_add_right 2 2) (Nat.le_add_right 2 2)
      (Nat.succ_pos n),
    fun x front =>
      Web.frontier_keeps_stepwise (W := web (onSource x)) (c := Place.source)
        (f := Formation.dweller) (R := logistic) (k := 2) (s := 2) (m := 2) (n := n + 1) (w := c)
        (worth := stepwiseDraw logistic 2 c (n + 1)) (y := 2) (q := 0) (r := 1) (e := 2)
        (fun _ _ less => less) coupled coupledAt logistic_le logistic_above rate three rfl
        (Nat.le_refl 2) (Nat.le_refl 2) (Nat.le_refl 2) (Nat.le_refl 2) (Nat.le_add_right 2 2)
        (Nat.le_add_right 2 2) (Nat.succ_pos n) front (fun _ => rfl)⟩,
   fun two x front =>
    Web.frontier_met_before_end (W := web (onSource x)) (c := Place.source)
      (f := Formation.dweller) (R := logistic) (k := 2) (s := 2) (m := 2) (n := n + 1) (w := c)
      (worth := stepwiseDraw logistic 2 c (n + 1)) (y := 2) (q := 0) (r := 1)
      (fun _ _ less => less) coupledAt (fun _ _ met => stepwiseDraw_ge met) logistic_le
      logistic_above (Nat.lt_of_lt_of_le (Nat.lt_succ_self 1)
        (Nat.le_trans two (Nat.le_of_eq (Nat.zero_add c).symm)))
      rfl (Nat.le_refl 2) (Nat.le_refl 2) (Nat.le_refl 2) (Nat.le_add_right 2 2) (Nat.le_refl 2)
      (Nat.succ_pos n) front (fun _ => rfl),
   fun one two =>
    continued_ending_stepwise_frontier (R := logistic) (k := 2) (s := 2) (m := 2) (n := n + 1)
      (y := 2) (q := 0) (r := 1) bounded coupledAt (fun _ _ met => stepwiseDraw_ge met) logistic_le
      logistic_above (Nat.le_trans one (Nat.le_of_eq (Nat.zero_add c).symm)) two rfl
      (Nat.le_refl 2) (Nat.le_refl 2) (Nat.le_refl 2) (Nat.le_add_right 2 2) (Nat.le_refl 2)
      (Nat.succ_pos n),
   fun one =>
    have rate : 0 + c ≤ 1 := Nat.le_trans (Nat.le_of_eq (Nat.zero_add c)) one
    ⟨continued_holding_stepwise_frontier (R := logistic) (k := 2) (s := 2) (m := 2) (n := n + 1)
      (y := 1) (q := 0) (r := 1) (fun _ => Nat.le_add_right _ _) bounded coupledAt logistic_le
      logistic_above rate (Nat.le_trans one (Nat.le_succ 1)) rfl (Nat.le_refl 2) (Nat.le_succ 1)
      (Nat.le_succ 2) (Nat.le_refl 2) (Nat.succ_pos n),
    fun x front =>
      Web.frontier_breaks_at_end (W := web (onSource x)) (c := Place.source)
        (f := Formation.dweller) (R := logistic) (k := 2) (s := 2) (m := 2) (n := n + 1) (w := c)
        (worth := stepwiseDraw logistic 2 c (n + 1)) (y := 2) (q := 0) (e := 0)
        (fun _ _ less => less) bounded (fun _ _ met => stepwiseDraw_ge met) logistic_above
        (Nat.lt_succ_of_le one) rfl (Nat.le_refl 2) (Nat.le_refl 2) (Nat.le_refl 2) (Nat.zero_le 2)
        (Nat.le_add_right 2 2) (Nat.le_refl 2) (Nat.succ_pos n) front (fun _ => trivial)
        (fun _ => rfl)⟩⟩


/-- A burst: four units renewed at one, nothing at any other level. -/
def burst : Nat → Nat
  | 1 => 4
  | _ => 0

/-- The burst gives at most four. -/
theorem burst_le : ∀ z, burst z ≤ 4
  | 0 => Nat.zero_le 4
  | 1 => Nat.le_refl 4
  | _ + 2 => Nat.zero_le 4

/-- The burst gives nothing at two or above. -/
theorem burst_above : ∀ z, 2 ≤ z → burst z ≤ 0
  | 0, le => absurd le (by decide)
  | 1, le => absurd le (by decide)
  | _ + 2, _ => Nat.le_refl 0

/-- From two, the course falling to one at the first step and regrown to two at the next, standing
there after. -/
def fallOnce : Nat → Nat
  | 1 => 1
  | _ => 2

/-- The course falling once is open from two under the burst with capacity three. -/
theorem fallOnce_open : OpenCourse burst 3 2 fallOnce :=
  ⟨rfl, fun t => match t with
    | 0 => ⟨by decide, by decide⟩
    | 1 => ⟨by decide, by decide⟩
    | _ + 2 => ⟨Nat.le_refl 2, Nat.zero_le 3⟩⟩

/-- The course falling once draws four across every horizon of at least two steps. -/
theorem fallOnce_drawn : ∀ n, drawnOver burst fallOnce (n + 2) = 4
  | 0 => rfl
  | n + 1 => show drawnOver burst fallOnce (n + 2) + drawnAt fallOnce (fun t => burst (fallOnce t))
      (0 + (n + 2)) = 4 by rw [fallOnce_drawn n, Nat.zero_add]; rfl

/-- The course falling once is met at every step from the second on. -/
theorem fallOnce_met : ∀ n, metCount 2 fallOnce (n + 2) = n + 1
  | 0 => rfl
  | n + 1 => show metCount 2 fallOnce (n + 2) + (if decide (2 ≤ fallOnce (n + 2 + 1)) = true then 1
      else 0) = n + 2 by rw [fallOnce_met n]; rfl

/-- What a course draws across `n + 1` steps under `R`, with `c` for each step from the first to the
last at which it stands at `m` or above, wherever. -/
def metDraw (R : Nat → Nat) (m c n : Nat) (x : Nat → Nat) : Nat :=
  drawnOver R x (n + 1) + c * metCount m x (n + 1)

/-- A course keeping `m` through the horizon adds `c` for each of its steps. -/
theorem metDraw_of_keeps {R : Nat → Nat} {m c n : Nat} {x : Nat → Nat} (keeps : Keeps m n x) :
    metDraw R m c n x = drawnOver R x (n + 1) + c * (n + 1) :=
  congrArg (fun z => drawnOver R x (n + 1) + c * z)
    (metCount_of_met fun t _ le => keeps t le)

/-- **The burst witness: steps met again after a fall.** From a source at two, the level the dweller
needs, under a burst renewing four units at one and nothing elsewhere, with capacity three, and a
coupling of four a step, the renewal forgone a step at the need: under the order by what the taker
draws with four for each step the source stays at two or above from the start, every optimum keeps
the dweller met through the horizon of `n + 2` steps (`Web.frontier_keeps_stepwise`); under the order
adding four for every step the source stands at two or above, wherever, the course staying at two is
an optimum (`continued_met_frontier`) and so is the course falling to one at the first step and
regrown to two at the next, which breaks the dweller and meets it again; with five a step every
optimum of that order keeps the dweller met (`Web.frontier_met_kept`). -/
theorem burst_met (n : Nat) :
    (∀ x, Frontier (OpenCourse burst 3 2)
        (fun b a => stepwiseDraw burst 2 4 (n + 1) a < stepwiseDraw burst 2 4 (n + 1) b) x →
      ∀ t, t ≤ n + 2 → (web (onSource x)).need t .dweller .source ≤
        (web (onSource x)).level t .source) ∧
    Frontier (OpenCourse burst 3 2)
        (fun b a => metDraw burst 2 4 (n + 1) a < metDraw burst 2 4 (n + 1) b)
        (continued burst (holdingTo 2 2 2 (n + 1)) (n + 1)) ∧
    Frontier (OpenCourse burst 3 2)
        (fun b a => metDraw burst 2 4 (n + 1) a < metDraw burst 2 4 (n + 1) b) fallOnce ∧
    (web (onSource fallOnce)).Broken 0 .dweller .source ∧
    (web (onSource fallOnce)).need 2 .dweller .source ≤ (web (onSource fallOnce)).level 2 .source ∧
    (∀ x, Frontier (OpenCourse burst 3 2)
        (fun b a => metDraw burst 2 5 (n + 1) a < metDraw burst 2 5 (n + 1) b) x →
      ∀ t, t ≤ n + 2 → (web (onSource x)).need t .dweller .source ≤
        (web (onSource x)).level t .source) :=
  have keepK : Keeps 2 (n + 1) (continued burst (holdingTo 2 2 2 (n + 1)) (n + 1)) :=
    continued_keeps (holdingTo_keeps (Nat.le_refl 2) (Nat.le_refl 2) (Nat.le_refl 2))
  have optimum : Frontier (OpenCourse burst 3 2)
      (fun b a => metDraw burst 2 4 (n + 1) a < metDraw burst 2 4 (n + 1) b)
      (continued burst (holdingTo 2 2 2 (n + 1)) (n + 1)) :=
    continued_met_frontier (R := burst) (k := 3) (s := 2) (m := 2) (n := n + 1) (y := 2) (q := 0)
      (r := 4) (c := 4) (fun _ _ keeps => Nat.le_of_eq (metDraw_of_keeps keeps).symm)
      (fun _ _ keeps => Nat.le_of_eq (metDraw_of_keeps keeps)) (fun _ _ => Nat.le_refl _) burst_le
      burst_above (Nat.le_refl 4) (by decide) rfl (Nat.le_refl 2) (Nat.le_refl 2) (Nat.le_refl 2)
      (Nat.le_add_right 2 3) (Nat.le_add_right 2 3) (Nat.succ_pos n)
  have twice : drawnOver burst (continued burst (holdingTo 2 2 2 (n + 1)) (n + 1)) (n + 1 + 1) + 2 =
      0 + 2 :=
    (congrArg (· + 2) continued_drawn).trans
      ((holdingTo_most (R := burst) (r := 0) (s := 2) (y := 2) rfl (Nat.le_refl 2) (Nat.le_refl 2)
        (n + 1)).trans (congrArg (2 + burst 2 + ·) (Nat.zero_mul (n + 1))))
  have drawnK : drawnOver burst (continued burst (holdingTo 2 2 2 (n + 1)) (n + 1)) (n + 1 + 1) = 0 :=
    Naturals.add_right_cancel twice
  have alike : metDraw burst 2 4 (n + 1) (continued burst (holdingTo 2 2 2 (n + 1)) (n + 1)) =
      metDraw burst 2 4 (n + 1) fallOnce :=
    (metDraw_of_keeps keepK).trans (by
      show _ = drawnOver burst fallOnce (n + 2) + 4 * metCount 2 fallOnce (n + 2)
      rw [drawnK, fallOnce_drawn, fallOnce_met, Nat.zero_add, Nat.mul_succ 4 (n + 1), Nat.add_comm])
  have coupledS : ∀ a, OpenCourse burst 3 2 a → Keeps 2 (n + 1) a →
      drawnOver burst a (n + 1 + 1) + 4 * (n + 1 + 1) ≤ stepwiseDraw burst 2 4 (n + 1) a :=
    fun _ _ keeps => Nat.le_of_eq (stepwiseDraw_of_keeps keeps).symm
  have coupledAt : ∀ a j, OpenCourse burst 3 2 a → (∀ t, t ≤ j → 2 ≤ a t) → a (j + 1) < 2 →
      j ≤ n + 1 → stepwiseDraw burst 2 4 (n + 1) a ≤ drawnOver burst a (n + 1 + 1) + 4 * j :=
    fun _ _ _ met below le => Nat.le_of_eq (stepwiseDraw_of_falls met below le)
  ⟨fun x front =>
    Web.frontier_keeps_stepwise (W := web (onSource x)) (c := Place.source)
      (f := Formation.dweller) (R := burst) (k := 3) (s := 2) (m := 2) (n := n + 1) (w := 4)
      (worth := stepwiseDraw burst 2 4 (n + 1)) (y := 2) (q := 0) (r := 4) (e := 2)
      (fun _ _ less => less) coupledS coupledAt burst_le burst_above (Nat.le_refl 4) (by decide) rfl
      (Nat.le_refl 2) (Nat.le_refl 2) (Nat.le_refl 2) (Nat.le_refl 2) (Nat.le_add_right 2 3)
      (Nat.le_add_right 2 3) (Nat.succ_pos n) front (fun _ => rfl),
   optimum,
   ⟨fallOnce_open, fun b opens more => optimum.2 b opens (Nat.lt_of_le_of_lt (Nat.le_of_eq alike) more)⟩,
   ⟨trivial, Nat.le_refl 2, by decide⟩,
   Nat.le_refl 2,
   fun x front =>
    Web.frontier_met_kept (W := web (onSource x)) (c := Place.source)
      (f := Formation.dweller) (R := burst) (k := 3) (s := 2) (m := 2) (n := n + 1) (w := 5)
      (worth := metDraw burst 2 5 (n + 1)) (y := 2) (q := 0) (r := 4) (e := 2)
      (fun _ _ less => less) (fun _ _ keeps => Nat.le_of_eq (metDraw_of_keeps keeps).symm)
      (fun _ _ => Nat.le_refl _) burst_le burst_above (by decide) (by decide) rfl (Nat.le_refl 2)
      (Nat.le_refl 2) (Nat.le_refl 2) (Nat.le_refl 2) (Nat.le_add_right 2 3) (Nat.le_add_right 2 3)
      (Nat.succ_pos n) front (fun _ => rfl)⟩

end Holding

end Optimum

/-! ## Over every law of what stands

The laws below on an order weighting later draws less, and on rebuilding from below, read what
stands to be drawn at a step as the level with its renewal, `z + R z`. Each uses that amount alone,
step by step, so each holds over any law `G` of what stands: at the step from `t`, a level `z` there
gives `G t z` to be drawn or left. The law may change with the step, give less than the level (a
base that decays, or one from which others draw first) or more. They are stated here over every such
law; below, the renewal law, `G t z = z + R z`, is their case. -/

namespace Optimum

/-- Two steps set side by side. -/
theorem add_steps {P P' H H' a b u v : Nat} (stepP : P' + a = P + u) (stepH : H' + b = H + v) :
    P' + (a + b) = P + (u + b) ∧ H' + (a + b) = H + (v + a) :=
  ⟨by rw [← Nat.add_assoc P' a b, stepP, Nat.add_assoc P u b],
   by rw [Nat.add_comm a b, ← Nat.add_assoc H' b a, stepH, Nat.add_assoc H v a]⟩

/-- What `y` gains at each step, said of the course holding it. -/
theorem holding_gains {s y n : Nat} {P : Nat → Nat → Prop} (at_y : ∀ t, t < n → P t y) :
    ∀ t, t < n → P t (holding s y n (t + 1)) :=
  fun t lt => Eq.subst (motive := P t) (holding_before lt).symm (at_y t lt)

namespace Next

/-- **The courses open under a law of what stands.** From level `s`, where a level `z` at the step
from `t` gives `G t z` to be drawn or left: each step leaves at most what stands, and draws at most
`k`. -/
def Open (G : Nat → Nat → Nat) (k s : Nat) (x : Nat → Nat) : Prop :=
  x 0 = s ∧ ∀ t, x (t + 1) ≤ G t (x t) ∧ G t (x t) - x (t + 1) ≤ k

/-- What a course of levels `x` draws across `n` steps under `G`, the draw of the step from `t`
weighted by `w t`. -/
def weighted (w : Nat → Nat) (G : Nat → Nat → Nat) (x : Nat → Nat) (n : Nat) : Nat :=
  Amounts.whole.sum (fun t => w t * (G t (x t) - x (t + 1))) 0 n

/-- What a course drew under `G`, weighted, before the step from `t`, with all it could draw at that
step, what stands there, weighted by `w t`. -/
def drawable (w : Nat → Nat) (G : Nat → Nat → Nat) (x : Nat → Nat) (t : Nat) : Nat :=
  weighted w G x t + w t * G t (x t)

variable {w : Nat → Nat} {G : Nat → Nat → Nat} {k s y m n : Nat}

/-- **The weighted draw to the last step.** Where each step leaves at most what stands, what a
course draws across `n + 1` steps, weighted, with what it leaves weighted at the last step, is what
it could draw at the `n`-th with what it drew before. -/
theorem weighted_add_left {x : Nat → Nat} (within : ∀ t, x (t + 1) ≤ G t (x t)) (n : Nat) :
    weighted w G x (n + 1) + w n * x (n + 1) = drawable w G x n := by
  show weighted w G x n + w (0 + n) * (G (0 + n) (x (0 + n)) - x (0 + n + 1)) + w n * x (n + 1) =
    weighted w G x n + w n * G n (x n)
  have back : x (n + 1) + (G n (x n) - x (n + 1)) = G n (x n) := Naturals.add_sub_of_le (within n)
  rw [Nat.zero_add, Nat.add_assoc, ← Nat.mul_add, Nat.add_comm (G n (x n) - x (n + 1)), back]

/-- **A step of the weighted draw.** What a course could draw at the step from `t + 1`, with what it
drew before and the level it left there weighted by `w t`, is what it could draw at the step from
`t`, with what it drew before, and what stands at that level weighted by `w (t + 1)`. -/
theorem drawable_step {x : Nat → Nat} (within : ∀ t, x (t + 1) ≤ G t (x t)) (t : Nat) :
    drawable w G x (t + 1) + w t * x (t + 1) =
      drawable w G x t + w (t + 1) * G (t + 1) (x (t + 1)) := by
  show weighted w G x (t + 1) + w (t + 1) * G (t + 1) (x (t + 1)) + w t * x (t + 1) =
    drawable w G x t + w (t + 1) * G (t + 1) (x (t + 1))
  rw [Nat.add_right_comm (weighted w G x (t + 1)), weighted_add_left within t]

/-- **Against a course gaining the most.** Where each step of two courses from one start leaves at
most what stands, and at each step to the `n`-th the level the first leaves gains, weighted, at most
what the level the second leaves gains (`w (t + 1)` on what stands at it, against `w t` on it held),
what the first could draw at each step to the `n`-th, with what it drew before, is at most what the
second could. -/
theorem drawable_le_of_gains {x h : Nat → Nat} (within : ∀ t, x (t + 1) ≤ G t (x t))
    (withinH : ∀ t, h (t + 1) ≤ G t (h t)) (start : x 0 = h 0)
    (gains : ∀ t, t < n → w (t + 1) * G (t + 1) (x (t + 1)) + w t * h (t + 1) ≤
      w (t + 1) * G (t + 1) (h (t + 1)) + w t * x (t + 1)) :
    ∀ t, t ≤ n → drawable w G x t ≤ drawable w G h t
  | 0, _ => by
    show 0 + w 0 * G 0 (x 0) ≤ 0 + w 0 * G 0 (h 0)
    rw [start]
    exact Nat.le_refl _
  | t + 1, le =>
    have sum := add_steps (drawable_step (w := w) within t) (drawable_step (w := w) withinH t)
    Naturals.le_of_add_le_add_right (k := w t * x (t + 1) + w t * h (t + 1))
      (Nat.le_trans (Nat.le_of_eq sum.1) (Nat.le_trans (Nat.add_le_add
        (drawable_le_of_gains within withinH start gains t (Nat.le_of_succ_le le))
        (gains t (Nat.lt_of_succ_le le))) (Nat.le_of_eq sum.2.symm)))

/-- Where, besides, the level the first course leaves at some step before the `n`-th gains less
than the second's, the first could draw less at every later step to the `n`-th. -/
theorem drawable_lt_of_gains {x h : Nat → Nat} (within : ∀ t, x (t + 1) ≤ G t (x t))
    (withinH : ∀ t, h (t + 1) ≤ G t (h t)) (start : x 0 = h 0)
    (gains : ∀ t, t < n → w (t + 1) * G (t + 1) (x (t + 1)) + w t * h (t + 1) ≤
      w (t + 1) * G (t + 1) (h (t + 1)) + w t * x (t + 1)) {j : Nat} (lt : j < n)
    (short : w (j + 1) * G (j + 1) (x (j + 1)) + w j * h (j + 1) <
      w (j + 1) * G (j + 1) (h (j + 1)) + w j * x (j + 1)) :
    ∀ i, j + 1 + i ≤ n → drawable w G x (j + 1 + i) < drawable w G h (j + 1 + i)
  | 0, _ =>
    have sum := add_steps (drawable_step (w := w) within j) (drawable_step (w := w) withinH j)
    Nat.lt_of_add_lt_add_right (Nat.lt_of_le_of_lt (Nat.le_of_eq sum.1)
      (Nat.lt_of_lt_of_le (Nat.add_lt_add_of_le_of_lt
        (drawable_le_of_gains within withinH start gains j (Nat.le_of_lt lt)) short)
        (Nat.le_of_eq sum.2.symm)))
  | i + 1, le =>
    have before : j + 1 + i < n := le
    have sum := add_steps (drawable_step (w := w) within (j + 1 + i))
      (drawable_step (w := w) withinH (j + 1 + i))
    Nat.lt_of_add_lt_add_right (Nat.lt_of_le_of_lt (Nat.le_of_eq sum.1)
      (Nat.lt_of_lt_of_le (Nat.add_lt_add_of_lt_of_le
        (drawable_lt_of_gains within withinH start gains lt short i (Nat.le_of_lt before))
        (gains _ before)) (Nat.le_of_eq sum.2.symm)))

/-- What a course leaving nothing at the last step draws, weighted, across `n + 1` steps is what it
could draw at the `n`-th with what it drew before. -/
theorem weighted_of_ends {h : Nat → Nat} (withinH : ∀ t, h (t + 1) ≤ G t (h t))
    (ends : h (n + 1) = 0) : weighted w G h (n + 1) = drawable w G h n :=
  (Nat.add_zero _).symm.trans ((congrArg (weighted w G h (n + 1) + w n * ·) ends).symm.trans
    (weighted_add_left withinH n))

/-- **No course outdraws, weighted, a course gaining the most and leaving nothing.** Where each step
of two courses from one start leaves at most what stands, the second leaves nothing at the last
step, and at each step to the `n`-th the level the first leaves gains, weighted, at most what the
second's gains, the first draws across `n + 1` steps, weighted, at most what the second does. -/
theorem weighted_le_of_gains {x h : Nat → Nat} (within : ∀ t, x (t + 1) ≤ G t (x t))
    (withinH : ∀ t, h (t + 1) ≤ G t (h t)) (start : x 0 = h 0) (ends : h (n + 1) = 0)
    (gains : ∀ t, t < n → w (t + 1) * G (t + 1) (x (t + 1)) + w t * h (t + 1) ≤
      w (t + 1) * G (t + 1) (h (t + 1)) + w t * x (t + 1)) :
    weighted w G x (n + 1) ≤ weighted w G h (n + 1) :=
  Nat.le_trans (Nat.le_add_right _ (w n * x (n + 1)))
    (Nat.le_trans (Nat.le_of_eq (weighted_add_left within n))
      (Nat.le_trans (drawable_le_of_gains within withinH start gains n (Nat.le_refl n))
        (Nat.le_of_eq (weighted_of_ends withinH ends).symm)))

/-- Where, besides, the level the first course leaves at some step before the `n`-th gains less
than the second's, or the first leaves something weighted at the last step, it draws less. -/
theorem weighted_lt_of_gains {x h : Nat → Nat} (within : ∀ t, x (t + 1) ≤ G t (x t))
    (withinH : ∀ t, h (t + 1) ≤ G t (h t)) (start : x 0 = h 0) (ends : h (n + 1) = 0)
    (gains : ∀ t, t < n → w (t + 1) * G (t + 1) (x (t + 1)) + w t * h (t + 1) ≤
      w (t + 1) * G (t + 1) (h (t + 1)) + w t * x (t + 1))
    (short : (∃ j, j < n ∧ w (j + 1) * G (j + 1) (x (j + 1)) + w j * h (j + 1) <
      w (j + 1) * G (j + 1) (h (j + 1)) + w j * x (j + 1)) ∨ 0 < w n * x (n + 1)) :
    weighted w G x (n + 1) < weighted w G h (n + 1) :=
  match short with
  | .inl ⟨j, lt, less⟩ => match le_dest (show j + 1 ≤ n from lt) with
    | ⟨i, split⟩ =>
      Nat.lt_of_le_of_lt (Nat.le_add_right _ (w n * x (n + 1)))
        (Nat.lt_of_le_of_lt (Nat.le_of_eq (weighted_add_left within n))
          (Nat.lt_of_lt_of_le
            (Eq.subst (motive := fun z => drawable w G x z < drawable w G h z) split.symm
              (drawable_lt_of_gains within withinH start gains lt less i (Nat.le_of_eq split.symm)))
            (Nat.le_of_eq (weighted_of_ends withinH ends).symm)))
  | .inr pos =>
    Nat.lt_of_lt_of_le (Nat.lt_add_of_pos_right pos)
      (Nat.le_trans (Nat.le_of_eq (weighted_add_left within n))
        (Nat.le_trans (drawable_le_of_gains within withinH start gains n (Nat.le_refl n))
          (Nat.le_of_eq (weighted_of_ends withinH ends).symm)))

/-- **A course gaining the most against every open course.** At each step to the `n`-th the level
`h` leaves gains, weighted, at least what the level any course open from `s` leaves there does. -/
def GainsMost (w : Nat → Nat) (G : Nat → Nat → Nat) (k s n : Nat) (h : Nat → Nat) : Prop :=
  ∀ x, Open G k s x → ∀ t, t < n →
    w (t + 1) * G (t + 1) (x (t + 1)) + w t * h (t + 1) ≤
      w (t + 1) * G (t + 1) (h (t + 1)) + w t * x (t + 1)

/-- A course whose level gains at each step to the `n`-th at least what any level does gains the
most against every open course. -/
theorem gainsMost_of_greatest {h : Nat → Nat}
    (greatest : ∀ t, t < n → ∀ z, w (t + 1) * G (t + 1) z + w t * h (t + 1) ≤
      w (t + 1) * G (t + 1) (h (t + 1)) + w t * z) : GainsMost w G k s n h :=
  fun x _ t lt => greatest t lt (x (t + 1))

/-- **A course gaining the most against every open course is an optimum.** Where an open course from
`s` leaves nothing at the last step and gains the most against every open course, it is an optimum,
among the open courses, of the order by the weighted draw across `n + 1` steps. -/
theorem frontier_of_gainsMost {h : Nat → Nat} (opens : Open G k s h) (ends : h (n + 1) = 0)
    (most : GainsMost w G k s n h) :
    Frontier (Open G k s) (fun b a => weighted w G a (n + 1) < weighted w G b (n + 1)) h :=
  ⟨opens, fun b openB more => Nat.not_le_of_gt more
    (weighted_le_of_gains (fun t => (openB.2 t).1) (fun t => (opens.2 t).1)
      (openB.1.trans opens.1.symm) ends (most b openB))⟩

/-- **Every optimum gains what a course gaining the most gains, and leaves nothing weighted.** Under
the premises of `frontier_of_gainsMost`, every optimum of every order on the courses open from the
start that rises with the weighted draw across `n + 1` steps leaves, weighted at the last step,
nothing, and at each step to the `n`-th leaves a level gaining what that course's level gains. -/
theorem frontier_gains_of_most {better : (Nat → Nat) → (Nat → Nat) → Prop}
    (rising : ∀ a b, weighted w G a (n + 1) < weighted w G b (n + 1) → better b a)
    {h : Nat → Nat} (opens : Open G k s h) (ends : h (n + 1) = 0)
    (most : GainsMost w G k s n h) {x : Nat → Nat} (front : Frontier (Open G k s) better x) :
    w n * x (n + 1) = 0 ∧ ∀ t, t < n →
      w (t + 1) * G (t + 1) (x (t + 1)) + w t * h (t + 1) =
        w (t + 1) * G (t + 1) (h (t + 1)) + w t * x (t + 1) :=
  have gains := most x front.1
  have outdrawn : ¬ ((∃ j, j < n ∧ w (j + 1) * G (j + 1) (x (j + 1)) + w j * h (j + 1) <
      w (j + 1) * G (j + 1) (h (j + 1)) + w j * x (j + 1)) ∨ 0 < w n * x (n + 1)) :=
    fun short => front.2 _ opens (rising x _ (weighted_lt_of_gains (fun t => (front.1.2 t).1)
      (fun t => (opens.2 t).1) (front.1.1.trans opens.1.symm) ends gains short))
  ⟨match Nat.eq_zero_or_pos (w n * x (n + 1)) with
    | .inl zero => zero
    | .inr pos => absurd (Or.inr pos) outdrawn,
   fun t lt => match Nat.lt_or_ge (w (t + 1) * G (t + 1) (x (t + 1)) + w t * h (t + 1))
      (w (t + 1) * G (t + 1) (h (t + 1)) + w t * x (t + 1)) with
    | .inl less => absurd (Or.inl ⟨t, lt, less⟩) outdrawn
    | .inr ge => Nat.le_antisymm (gains t lt) ge⟩

/-- **Every optimum stands below a need above every level of greatest weighted gain.** Where an open
course from `s` leaving nothing at the last step gains at each step to the `n`-th at least what any
level does, and every level at or above `m` gains less, every optimum of every order rising with the
weighted draw stands below `m` at every step from the first to the `n`-th. -/
theorem frontier_below {better : (Nat → Nat) → (Nat → Nat) → Prop}
    (rising : ∀ a b, weighted w G a (n + 1) < weighted w G b (n + 1) → better b a)
    {h : Nat → Nat} (opens : Open G k s h) (ends : h (n + 1) = 0)
    (greatest : ∀ t, t < n → ∀ z, w (t + 1) * G (t + 1) z + w t * h (t + 1) ≤
      w (t + 1) * G (t + 1) (h (t + 1)) + w t * z)
    (above : ∀ t, t < n → ∀ z, m ≤ z → w (t + 1) * G (t + 1) z + w t * h (t + 1) <
      w (t + 1) * G (t + 1) (h (t + 1)) + w t * z)
    {x : Nat → Nat} (front : Frontier (Open G k s) better x) :
    ∀ t, t < n → x (t + 1) < m :=
  fun t lt => match Nat.lt_or_ge (x (t + 1)) m with
  | .inl below => below
  | .inr ge => absurd
      ((frontier_gains_of_most rising opens ends (gainsMost_of_greatest greatest) front).2 t lt)
      (Nat.ne_of_lt (above t lt _ ge))

/-- Each step of the holding course leaves at most what stands, where `y` is within what stands at
the start and what stands at `y` is at least `y` at every step. -/
theorem holding_within (reach : y ≤ G 0 s) (keeps : ∀ t, y ≤ G t y) (n : Nat) :
    ∀ t, holding s y n (t + 1) ≤ G t (holding s y n t)
  | 0 => match Nat.lt_or_ge 0 n with
    | .inl lt => Nat.le_trans (Nat.le_of_eq (holding_before lt)) reach
    | .inr ge => Nat.le_trans (Nat.le_of_eq (holding_after ge)) (Nat.zero_le _)
  | j + 1 => match Nat.lt_or_ge (j + 1) n with
    | .inl lt => Nat.le_trans (Nat.le_of_eq (holding_before lt))
        (Eq.subst (motive := fun v => y ≤ G (j + 1) v) (holding_before (Nat.lt_of_succ_lt lt)).symm
          (keeps _))
    | .inr ge => Nat.le_trans (Nat.le_of_eq (holding_after ge)) (Nat.zero_le _)

/-- **The course holding `y` and leaving nothing is open** over a horizon of at least two steps,
where `y` is within what stands at the start and what stands at `y` is at least `y` at every step,
with a capacity covering what the first step draws down to `y`, what stands at `y` and what stands
at nothing at every step. -/
theorem holding_open (reach : y ≤ G 0 s) (drawsDown : G 0 s ≤ y + k) (keeps : ∀ t, y ≤ G t y)
    (holds : ∀ t, G t y ≤ k) (rests : ∀ t, G t 0 ≤ k) (long : 0 < n) :
    Open G k s (holding s y n) :=
  ⟨rfl, fun t => ⟨Next.holding_within reach keeps n t, match t with
    | 0 => Nat.le_trans (Nat.le_of_eq (congrArg (G 0 s - ·) (holding_before long)))
        (Nat.le_trans (sub_le_sub_right_of_le drawsDown y)
          (Nat.le_of_eq (Naturals.add_sub_cancel_left y k)))
    | j + 1 => Nat.le_trans (Nat.sub_le _ _) (match Nat.lt_or_ge j n with
      | .inl lt => Eq.subst (motive := fun v => G (j + 1) v ≤ k) (holding_before lt).symm (holds _)
      | .inr ge => Eq.subst (motive := fun v => G (j + 1) v ≤ k) (holding_after ge).symm
          (rests _))⟩⟩

/-- **The course holding a level of greatest weighted gain is an optimum**, where `y` gains,
weighted, at each step to the `n`-th at least what any level does, under the premises of
`holding_open`. -/
theorem holding_frontier
    (greatest : ∀ t, t < n → ∀ z,
      w (t + 1) * G (t + 1) z + w t * y ≤ w (t + 1) * G (t + 1) y + w t * z)
    (reach : y ≤ G 0 s) (drawsDown : G 0 s ≤ y + k) (keeps : ∀ t, y ≤ G t y)
    (holds : ∀ t, G t y ≤ k) (rests : ∀ t, G t 0 ≤ k) (long : 0 < n) :
    Frontier (Open G k s) (fun b a => weighted w G a (n + 1) < weighted w G b (n + 1))
      (holding s y n) :=
  frontier_of_gainsMost (Next.holding_open reach drawsDown keeps holds rests long)
    (holding_after (Nat.le_refl n))
    (gainsMost_of_greatest (holding_gains (P := fun t v => ∀ z, w (t + 1) * G (t + 1) z + w t * v ≤
      w (t + 1) * G (t + 1) v + w t * z) greatest))

/-- Where the weighting falls at least as fast as what stands at every positive level rises over
it, nothing gains at least what any level does. -/
theorem outpaced_greatest
    (outpaced : ∀ t, t < n → ∀ z, 0 < z → w (t + 1) * G (t + 1) z ≤ w t * z) :
    ∀ t, t < n → ∀ z, w (t + 1) * G (t + 1) z + w t * 0 ≤ w (t + 1) * G (t + 1) 0 + w t * z :=
  fun t lt z => match Nat.eq_zero_or_pos z with
  | .inl zero => by subst zero; exact Nat.le_refl _
  | .inr pos => Nat.le_trans (Nat.le_of_eq (Nat.add_zero _))
      (Nat.le_trans (outpaced t lt z pos) (Nat.le_add_left _ _))

/-- Where the weighting falls faster than what stands at every positive level rises over it, every
positive level gains less than nothing does. -/
theorem outpaced_above
    (strictly : ∀ t, t < n → ∀ z, 0 < z → w (t + 1) * G (t + 1) z < w t * z) :
    ∀ t, t < n → ∀ z, 1 ≤ z → w (t + 1) * G (t + 1) z + w t * 0 < w (t + 1) * G (t + 1) 0 + w t * z :=
  fun t lt z pos => Nat.lt_of_le_of_lt (Nat.le_of_eq (Nat.add_zero _))
    (Nat.lt_of_lt_of_le (strictly t lt z pos) (Nat.le_add_left _ _))

/-- **The course ending the base at once is an optimum** where the weighting falls at least as fast
as what stands at every positive level rises over it, over a horizon of at least two steps, with a
capacity covering what stands at the start and what stands at nothing at every step. -/
theorem exhausting_frontier
    (outpaced : ∀ t, t < n → ∀ z, 0 < z → w (t + 1) * G (t + 1) z ≤ w t * z)
    (drawsDown : G 0 s ≤ k) (rests : ∀ t, G t 0 ≤ k) (long : 0 < n) :
    Frontier (Open G k s) (fun b a => weighted w G a (n + 1) < weighted w G b (n + 1))
      (holding s 0 n) :=
  Next.holding_frontier (outpaced_greatest outpaced) (Nat.zero_le _)
    (Nat.le_trans drawsDown (Nat.le_of_eq (Nat.zero_add k).symm)) (fun _ => Nat.zero_le _) rests
    rests long

/-- **A weighting falling faster than what stands rises ends the base at once.** Where at each step
to the `n`-th the weighting falls faster than what stands at every positive level rises over it,
`w (t + 1)` on what stands at a level less than `w t` on the level held, over a horizon of at least
two steps, with a capacity covering what stands at the start and what stands at nothing at every
step, every optimum of every order on the courses open from the start that rises with the weighted
draw across `n + 1` steps stands at nothing at every step from the first to the `n`-th. -/
theorem frontier_exhausts {better : (Nat → Nat) → (Nat → Nat) → Prop}
    (rising : ∀ a b, weighted w G a (n + 1) < weighted w G b (n + 1) → better b a)
    (strictly : ∀ t, t < n → ∀ z, 0 < z → w (t + 1) * G (t + 1) z < w t * z)
    (drawsDown : G 0 s ≤ k) (rests : ∀ t, G t 0 ≤ k) (long : 0 < n) {x : Nat → Nat}
    (front : Frontier (Open G k s) better x) : ∀ t, t < n → x (t + 1) = 0 :=
  have opens := Next.holding_open (y := 0) (Nat.zero_le _)
    (Nat.le_trans drawsDown (Nat.le_of_eq (Nat.zero_add k).symm)) (fun _ => Nat.zero_le _) rests
    rests long
  fun t lt => Nat.le_antisymm (Nat.le_of_lt_succ (frontier_below (m := 1) rising opens
      (holding_after (Nat.le_refl n))
      (holding_gains (P := fun t v => ∀ z, w (t + 1) * G (t + 1) z + w t * v ≤
        w (t + 1) * G (t + 1) v + w t * z)
        (outpaced_greatest fun t lt z pos => Nat.le_of_lt (strictly t lt z pos)))
      (holding_gains (P := fun t v => ∀ z, 1 ≤ z → w (t + 1) * G (t + 1) z + w t * v <
        w (t + 1) * G (t + 1) v + w t * z) (outpaced_above strictly)) front t lt))
    (Nat.zero_le _)

/-- **Ending the base at once is outdrawn by a level rising faster than the weighting falls.**
Where each step of a course from `s` leaves at most what stands and the course stands at nothing at
every step from the first to the `n`-th, and some `y` within what stands at the start, with what
stands at `y` at least `y` at every step, gains, weighted, more than nothing does at each step to the
`n`-th, over a horizon of at least two steps, the course holding `y` and leaving nothing draws more,
weighted, across `n + 1` steps. -/
theorem ended_outdrawn {x : Nat → Nat} (within : ∀ t, x (t + 1) ≤ G t (x t))
    (start : x 0 = s) (ended : ∀ t, t < n → x (t + 1) = 0) (reach : y ≤ G 0 s)
    (keeps : ∀ t, y ≤ G t y)
    (outgrows : ∀ t, t < n → w (t + 1) * G (t + 1) 0 + w t * y < w (t + 1) * G (t + 1) y)
    (long : 0 < n) :
    weighted w G x (n + 1) < weighted w G (holding s y n) (n + 1) :=
  have gains : ∀ t, t < n → w (t + 1) * G (t + 1) (x (t + 1)) + w t * holding s y n (t + 1) <
      w (t + 1) * G (t + 1) (holding s y n (t + 1)) + w t * x (t + 1) :=
    fun t lt => by
      rw [ended t lt, holding_before lt]
      exact outgrows t lt
  weighted_lt_of_gains within (Next.holding_within reach keeps n) start
    (holding_after (Nat.le_refl n)) (fun t lt => Nat.le_of_lt (gains t lt))
    (.inl ⟨0, long, gains 0 long⟩)

/-- A course leaving at most what stands stays at nothing after reaching it, where nothing stands at
nothing. -/
theorem stays_empty {x : Nat → Nat} (within : ∀ t, x (t + 1) ≤ G t (x t))
    (empty : ∀ t, G t 0 = 0) (ended : x 1 = 0) : ∀ t, x (t + 1) = 0
  | 0 => ended
  | t + 1 => Nat.le_antisymm (Nat.le_trans (within (t + 1))
      (Nat.le_of_eq (by rw [stays_empty within empty ended t, empty]))) (Nat.zero_le _)

/-- **No optimum ends the base at once where a level rises faster than the weighting falls.** Where
nothing stands at nothing and some `y` within what stands at the start, with what stands at `y` at
least `y` at every step, rises faster than the weighting falls at each step to the `n`-th,
`w t y < w (t + 1) (G (t + 1) y)`, over a horizon of at least two steps, with a capacity covering
what the first step draws down to `y` and what stands at `y`, no optimum of any order on the courses
open from the start that rises with the weighted draw across `n + 1` steps stands at nothing after
the first step. -/
theorem frontier_leaves {better : (Nat → Nat) → (Nat → Nat) → Prop}
    (rising : ∀ a b, weighted w G a (n + 1) < weighted w G b (n + 1) → better b a)
    (empty : ∀ t, G t 0 = 0) (outgrows : ∀ t, t < n → w t * y < w (t + 1) * G (t + 1) y)
    (reach : y ≤ G 0 s) (drawsDown : G 0 s ≤ y + k) (keeps : ∀ t, y ≤ G t y)
    (holds : ∀ t, G t y ≤ k) (long : 0 < n)
    {x : Nat → Nat} (front : Frontier (Open G k s) better x) : 0 < x 1 :=
  have nothing : ∀ t, t < n → w (t + 1) * G (t + 1) 0 + w t * y < w (t + 1) * G (t + 1) y :=
    fun t lt => by
      rw [empty]
      exact Nat.lt_of_le_of_lt (Nat.le_of_eq (Nat.zero_add _)) (outgrows t lt)
  match Nat.eq_zero_or_pos (x 1) with
  | .inr pos => pos
  | .inl ended => absurd
      (rising x _ (ended_outdrawn (fun t => (front.1.2 t).1) front.1.1
        (fun t _ => Next.stays_empty (fun t => (front.1.2 t).1) empty ended t) reach keeps nothing
        long))
      (front.2 _ (Next.holding_open reach drawsDown keeps holds
        (fun t => Nat.le_trans (Nat.le_of_eq (empty t)) (Nat.zero_le k)) long))

/-- The level a course from `s` rising as fast as what stands allows, up to `y`, stands at after `t`
steps. -/
def rise (G : Nat → Nat → Nat) (y s : Nat) : Nat → Nat
  | 0 => s
  | t + 1 => if G t (rise G y s t) ≤ y then G t (rise G y s t) else y

/-- From `s`, the course rising as fast as what stands allows up to `y` to the `n`-th step and
standing at nothing after: the course rebuilding toward `y`. -/
def rebuilding (G : Nat → Nat → Nat) (y s n : Nat) : Nat → Nat
  | 0 => s
  | t + 1 => if t < n then rise G y s (t + 1) else 0

/-- One step of the rising course. -/
theorem rise_succ (t : Nat) : rise G y s (t + 1) =
    if G t (rise G y s t) ≤ y then G t (rise G y s t) else y :=
  rfl

/-- After its start the rising course stands at most at `y`. -/
theorem rise_le (t : Nat) : rise G y s (t + 1) ≤ y :=
  match Nat.lt_or_ge y (G t (rise G y s t)) with
  | .inl over => Nat.le_of_eq ((rise_succ t).trans (if_neg (Nat.not_le_of_gt over)))
  | .inr fits => Nat.le_trans (Nat.le_of_eq ((rise_succ t).trans (if_pos fits))) fits

/-- From a start at most `y` the rising course stands at most at `y`. -/
theorem rise_le_top (low : s ≤ y) : ∀ t, rise G y s t ≤ y
  | 0 => low
  | t + 1 => rise_le t

/-- Each step of the rising course leaves at most what stands. -/
theorem rise_within (t : Nat) : rise G y s (t + 1) ≤ G t (rise G y s t) :=
  match Nat.lt_or_ge y (G t (rise G y s t)) with
  | .inl over => Nat.le_trans (Nat.le_of_eq ((rise_succ t).trans (if_neg (Nat.not_le_of_gt over))))
      (Nat.le_of_lt over)
  | .inr fits => Nat.le_of_eq ((rise_succ t).trans (if_pos fits))

/-- Where the rising course stands below `y` after a step, that step drew nothing. -/
theorem rise_of_below {t : Nat} (below : rise G y s (t + 1) < y) :
    rise G y s (t + 1) = G t (rise G y s t) :=
  match Nat.lt_or_ge y (G t (rise G y s t)) with
  | .inl over => absurd (Nat.le_of_eq ((rise_succ t).trans (if_neg (Nat.not_le_of_gt over))).symm)
      (Nat.not_le_of_gt below)
  | .inr fits => (rise_succ t).trans (if_pos fits)

/-- Once at `y`, the rising course stays there, where what stands at `y` is at least `y`. -/
theorem rise_at_top (keeps : ∀ t, y ≤ G t y) {t : Nat} (top : rise G y s t = y) :
    rise G y s (t + 1) = y :=
  Nat.le_antisymm (rise_le t)
    (match Nat.lt_or_ge y (G t (rise G y s t)) with
    | .inl over => Nat.le_of_eq ((rise_succ t).trans (if_neg (Nat.not_le_of_gt over))).symm
    | .inr fits => Nat.le_trans
        (Eq.subst (motive := fun v => y ≤ G t v) top.symm (keeps t))
        (Nat.le_of_eq ((rise_succ t).trans (if_pos fits)).symm))

/-- Where the rising course stands below `y` after two steps, it stood below `y` after one. -/
theorem rise_below_before (keeps : ∀ t, y ≤ G t y) {t : Nat}
    (below : rise G y s (t + 1 + 1) < y) : rise G y s (t + 1) < y :=
  match Nat.lt_or_ge (rise G y s (t + 1)) y with
  | .inl lt => lt
  | .inr ge => absurd (Nat.le_of_eq (rise_at_top keeps (Nat.le_antisymm (rise_le t) ge)).symm)
      (Nat.not_le_of_gt below)

/-- Once at `y`, the rising course stands there at every later step. -/
theorem rise_stays (keeps : ∀ t, y ≤ G t y) {j : Nat} (top : rise G y s j = y) :
    ∀ i, rise G y s (j + i) = y
  | 0 => top
  | i + 1 => rise_at_top keeps (rise_stays keeps top i)

/-- **Nothing open rises faster.** Where what stands rises with the level below `y` and what stands
at `y` is at least `y`, every course from `s` at most `y` whose steps each leave at most what stands
stands, at each step, at or below the rising course, or the rising course stands at `y`. -/
theorem le_rise {x : Nat → Nat} (within : ∀ t, x (t + 1) ≤ G t (x t)) (start : x 0 = s)
    (low : s ≤ y) (grows : ∀ t z z', z ≤ z' → z' ≤ y → G t z ≤ G t z')
    (keeps : ∀ t, y ≤ G t y) :
    ∀ t, x t ≤ rise G y s t ∨ rise G y s t = y
  | 0 => .inl (Nat.le_of_eq start)
  | t + 1 => match le_rise within start low grows keeps t with
    | .inl le => match Nat.lt_or_ge y (G t (rise G y s t)) with
      | .inl over => .inr ((rise_succ t).trans (if_neg (Nat.not_le_of_gt over)))
      | .inr fits => .inl (Nat.le_trans (within t)
          (Nat.le_trans (grows t _ _ le (rise_le_top low t))
            (Nat.le_of_eq ((rise_succ t).trans (if_pos fits)).symm)))
    | .inr top => .inr (rise_at_top keeps top)

/-- The rebuilding course stands at the rising course's level from the first step to the `n`-th. -/
theorem rebuilding_before {t : Nat} (before : t < n) :
    rebuilding G y s n (t + 1) = rise G y s (t + 1) :=
  if_pos before

/-- The rebuilding course stands at nothing after the `n`-th step. -/
theorem rebuilding_after {t : Nat} (after : n ≤ t) : rebuilding G y s n (t + 1) = 0 :=
  if_neg (Nat.not_lt_of_ge after)

/-- To the `n`-th step the rebuilding course stands where the rising course does. -/
theorem rebuilding_at : ∀ {t : Nat}, t ≤ n → rebuilding G y s n t = rise G y s t
  | 0, _ => rfl
  | _ + 1, le => rebuilding_before le

/-- Each step of the rebuilding course leaves at most what stands. -/
theorem rebuilding_within (t : Nat) :
    rebuilding G y s n (t + 1) ≤ G t (rebuilding G y s n t) :=
  match Nat.lt_or_ge t n with
  | .inl lt => Nat.le_trans (Nat.le_of_eq (rebuilding_before lt))
      (Eq.subst (motive := fun v => rise G y s (t + 1) ≤ G t v)
        (rebuilding_at (Nat.le_of_lt lt)).symm (rise_within t))
  | .inr ge => Nat.le_trans (Nat.le_of_eq (rebuilding_after ge)) (Nat.zero_le _)

/-- At each step what stands at the rebuilding course is within a capacity covering what stands at
`y` and what stands at nothing at every step, from a start at most `y`, where what stands rises with
the level below `y`. -/
theorem rebuilding_le_cap (low : s ≤ y) (grows : ∀ t z z', z ≤ z' → z' ≤ y → G t z ≤ G t z')
    (holds : ∀ t, G t y ≤ k) (rests : ∀ t, G t 0 ≤ k) :
    ∀ t, G t (rebuilding G y s n t) ≤ k
  | 0 => Nat.le_trans (grows 0 _ _ low (Nat.le_refl y)) (holds 0)
  | t + 1 => match Nat.lt_or_ge t n with
    | .inl lt => Eq.subst (motive := fun v => G (t + 1) v ≤ k) (rebuilding_before lt).symm
        (Nat.le_trans (grows (t + 1) _ _ (rise_le t) (Nat.le_refl y)) (holds (t + 1)))
    | .inr ge => Eq.subst (motive := fun v => G (t + 1) v ≤ k) (rebuilding_after ge).symm
        (rests (t + 1))

/-- **The rebuilding course is open**, from a start at most `y`, where what stands rises with the
level below `y`, with a capacity covering what stands at `y` and at nothing at every step. -/
theorem rebuilding_open (low : s ≤ y) (grows : ∀ t z z', z ≤ z' → z' ≤ y → G t z ≤ G t z')
    (holds : ∀ t, G t y ≤ k) (rests : ∀ t, G t 0 ≤ k) : Open G k s (rebuilding G y s n) :=
  ⟨rfl, fun t => ⟨rebuilding_within t,
    Nat.le_trans (Nat.sub_le _ _) (rebuilding_le_cap low grows holds rests t)⟩⟩

/-- **The rebuilding course gains the most against every open course**, from a start at most `y`,
where what stands rises with the level below `y`, what stands at `y` is at least `y`, and, at each
step to the `n`-th, the weighted gain rises with the level up to `y` and is greatest at `y`. -/
theorem rebuilding_gainsMost (low : s ≤ y) (grows : ∀ t z z', z ≤ z' → z' ≤ y → G t z ≤ G t z')
    (keeps : ∀ t, y ≤ G t y)
    (rises : ∀ t, t < n → ∀ z z', z ≤ z' → z' ≤ y →
      w (t + 1) * G (t + 1) z + w t * z' ≤ w (t + 1) * G (t + 1) z' + w t * z)
    (top : ∀ t, t < n → ∀ z,
      w (t + 1) * G (t + 1) z + w t * y ≤ w (t + 1) * G (t + 1) y + w t * z) :
    GainsMost w G k s n (rebuilding G y s n) :=
  fun x opens t lt =>
    Eq.subst (motive := fun v => w (t + 1) * G (t + 1) (x (t + 1)) + w t * v ≤
        w (t + 1) * G (t + 1) v + w t * x (t + 1)) (rebuilding_before lt).symm
      (match le_rise (fun t => (opens.2 t).1) opens.1 low grows keeps (t + 1) with
      | .inl le => rises t lt _ _ le (rise_le t)
      | .inr at_top => Eq.subst (motive := fun v => w (t + 1) * G (t + 1) (x (t + 1)) +
          w t * v ≤ w (t + 1) * G (t + 1) v + w t * x (t + 1)) at_top.symm (top t lt (x (t + 1))))

/-- **The rebuilding course is an optimum**, under the premises of `rebuilding_gainsMost`, with a
capacity covering what stands at `y` and at nothing at every step: of the order by the weighted draw
across `n + 1` steps, among the courses open from `s`. -/
theorem rebuilding_frontier (low : s ≤ y) (grows : ∀ t z z', z ≤ z' → z' ≤ y → G t z ≤ G t z')
    (keeps : ∀ t, y ≤ G t y)
    (rises : ∀ t, t < n → ∀ z z', z ≤ z' → z' ≤ y →
      w (t + 1) * G (t + 1) z + w t * z' ≤ w (t + 1) * G (t + 1) z' + w t * z)
    (top : ∀ t, t < n → ∀ z,
      w (t + 1) * G (t + 1) z + w t * y ≤ w (t + 1) * G (t + 1) y + w t * z)
    (holds : ∀ t, G t y ≤ k) (rests : ∀ t, G t 0 ≤ k) :
    Frontier (Open G k s) (fun b a => weighted w G a (n + 1) < weighted w G b (n + 1))
      (rebuilding G y s n) :=
  frontier_of_gainsMost (rebuilding_open low grows holds rests) (rebuilding_after (Nat.le_refl n))
    (rebuilding_gainsMost low grows keeps rises top)

/-- **Every optimum rebuilds.** Under the premises of `rebuilding_frontier`, where the weighted gain
rises strictly with the level below `y`, every optimum of every order on the courses open from `s`
that rises with the weighted draw across `n + 1` steps stands at the rising course's level at every
step from the first to the `n`-th where that level is below `y`, and draws nothing at the step
before: it rebuilds as fast as what stands allows. -/
theorem frontier_rebuilds {better : (Nat → Nat) → (Nat → Nat) → Prop}
    (rising : ∀ a b, weighted w G a (n + 1) < weighted w G b (n + 1) → better b a)
    (low : s ≤ y) (grows : ∀ t z z', z ≤ z' → z' ≤ y → G t z ≤ G t z')
    (keeps : ∀ t, y ≤ G t y)
    (rises : ∀ t, t < n → ∀ z z', z ≤ z' → z' ≤ y →
      w (t + 1) * G (t + 1) z + w t * z' ≤ w (t + 1) * G (t + 1) z' + w t * z)
    (strictly : ∀ t, t < n → ∀ z z', z < z' → z' ≤ y →
      w (t + 1) * G (t + 1) z + w t * z' < w (t + 1) * G (t + 1) z' + w t * z)
    (top : ∀ t, t < n → ∀ z,
      w (t + 1) * G (t + 1) z + w t * y ≤ w (t + 1) * G (t + 1) y + w t * z)
    (holds : ∀ t, G t y ≤ k) (rests : ∀ t, G t 0 ≤ k) {x : Nat → Nat}
    (front : Frontier (Open G k s) better x) :
    ∀ t, t < n → rise G y s (t + 1) < y →
      x (t + 1) = rise G y s (t + 1) ∧ x (t + 1) = G t (x t) :=
  have gains := (frontier_gains_of_most rising (rebuilding_open low grows holds rests)
    (rebuilding_after (Nat.le_refl n)) (rebuilding_gainsMost low grows keeps rises top) front).2
  have stands : ∀ t, t < n → rise G y s (t + 1) < y → x (t + 1) = rise G y s (t + 1) :=
    fun t lt below =>
      have same := Eq.subst (motive := fun v => w (t + 1) * G (t + 1) (x (t + 1)) + w t * v =
        w (t + 1) * G (t + 1) v + w t * x (t + 1)) (rebuilding_before lt) (gains t lt)
      match le_rise (fun t => (front.1.2 t).1) front.1.1 low grows keeps (t + 1) with
      | .inr at_top => absurd (Nat.le_of_eq at_top.symm) (Nat.not_le_of_gt below)
      | .inl le => match Nat.lt_or_ge (x (t + 1)) (rise G y s (t + 1)) with
        | .inl lt' => absurd same (Nat.ne_of_lt (strictly t lt _ _ lt' (rise_le t)))
        | .inr ge => Nat.le_antisymm le ge
  fun t lt below =>
    have before : x t = rise G y s t := match t, lt, below with
      | 0, _, _ => front.1.1
      | j + 1, lt, below => stands j (Nat.lt_of_succ_lt lt) (rise_below_before keeps below)
    ⟨stands t lt below, (stands t lt below).trans ((rise_of_below below).trans
      (congrArg (G t) before.symm))⟩

/-- **Every optimum stands at `y` once the rising course reaches it.** Under the premises of
`rebuilding_frontier`, where `y` gains, weighted, more than every other level at each step to the
`n`-th, every optimum of every order on the courses open from `s` that rises with the weighted draw
across `n + 1` steps stands at `y` at every step from the first to the `n`-th where the rising
course does. -/
theorem frontier_rebuilt {better : (Nat → Nat) → (Nat → Nat) → Prop}
    (rising : ∀ a b, weighted w G a (n + 1) < weighted w G b (n + 1) → better b a)
    (low : s ≤ y) (grows : ∀ t z z', z ≤ z' → z' ≤ y → G t z ≤ G t z')
    (keeps : ∀ t, y ≤ G t y)
    (rises : ∀ t, t < n → ∀ z z', z ≤ z' → z' ≤ y →
      w (t + 1) * G (t + 1) z + w t * z' ≤ w (t + 1) * G (t + 1) z' + w t * z)
    (above : ∀ t, t < n → ∀ z, z ≠ y →
      w (t + 1) * G (t + 1) z + w t * y < w (t + 1) * G (t + 1) y + w t * z)
    (holds : ∀ t, G t y ≤ k) (rests : ∀ t, G t 0 ≤ k) {x : Nat → Nat}
    (front : Frontier (Open G k s) better x) :
    ∀ t, t < n → rise G y s (t + 1) = y → x (t + 1) = y :=
  have top : ∀ t, t < n → ∀ z,
      w (t + 1) * G (t + 1) z + w t * y ≤ w (t + 1) * G (t + 1) y + w t * z :=
    fun t lt z => match Nat.decEq z y with
    | isTrue same => Eq.subst (motive := fun v => w (t + 1) * G (t + 1) v + w t * y ≤
        w (t + 1) * G (t + 1) y + w t * v) same.symm (Nat.le_refl _)
    | isFalse other => Nat.le_of_lt (above t lt z other)
  have gains := (frontier_gains_of_most rising (rebuilding_open low grows holds rests)
    (rebuilding_after (Nat.le_refl n)) (rebuilding_gainsMost low grows keeps rises top) front).2
  fun t lt at_top =>
    have same := Eq.subst (motive := fun v => w (t + 1) * G (t + 1) (x (t + 1)) + w t * v =
      w (t + 1) * G (t + 1) v + w t * x (t + 1)) ((rebuilding_before lt).trans at_top) (gains t lt)
    match Nat.decEq (x (t + 1)) y with
    | isTrue e => e
    | isFalse other => absurd same (Nat.ne_of_lt (above t lt _ other))

end Next

end Optimum

namespace Web

namespace Next

open Optimum.Next

variable {W : Web F C} {c : C} {f : F} {w : Nat → Nat} {G : Nat → Nat → Nat} {k s y m n : Nat}
  {better : (Nat → Nat) → (Nat → Nat) → Prop}

/-- **A dependence above every level of greatest weighted gain is broken at the first step.** Under
the premises of `Optimum.Next.frontier_below`, over a horizon of at least two steps, with a
formation depending on the condition at the start, met there, and needing at least `m`: every
optimum, among the open courses, of every order rising with the weighted draw breaks the dependence
at the first step. -/
theorem frontier_broken
    (rising : ∀ a b, weighted w G a (n + 1) < weighted w G b (n + 1) → better b a)
    {h : Nat → Nat} (opens : Open G k s h) (ends : h (n + 1) = 0)
    (greatest : ∀ t, t < n → ∀ z, w (t + 1) * G (t + 1) z + w t * h (t + 1) ≤
      w (t + 1) * G (t + 1) (h (t + 1)) + w t * z)
    (above : ∀ t, t < n → ∀ z, m ≤ z → w (t + 1) * G (t + 1) z + w t * h (t + 1) <
      w (t + 1) * G (t + 1) (h (t + 1)) + w t * z)
    (long : 0 < n) (front : Frontier (Open G k s) better fun t => W.level t c)
    (depends : W.requires 0 f c) (met : W.need 0 f c ≤ W.level 0 c) (need : m ≤ W.need 0 f c) :
    W.Broken 0 f c :=
  ⟨depends, met, Nat.lt_of_lt_of_le (Optimum.Next.frontier_below rising opens ends greatest
    above front 0 long) need⟩

/-- **A weighting falling faster than what stands rises ends the condition at once.** Under the
premises of `Optimum.Next.frontier_exhausts`, every optimum, among the open courses, of every order
rising with the weighted draw leaves the condition at nothing at every step from the first to the
`n`-th, and breaks at the first step every dependence on it with a positive need, met at the
start. -/
theorem frontier_exhausts
    (rising : ∀ a b, weighted w G a (n + 1) < weighted w G b (n + 1) → better b a)
    (strictly : ∀ t, t < n → ∀ z, 0 < z → w (t + 1) * G (t + 1) z < w t * z)
    (drawsDown : G 0 s ≤ k) (rests : ∀ t, G t 0 ≤ k) (long : 0 < n)
    (front : Frontier (Open G k s) better fun t => W.level t c)
    (depends : W.requires 0 f c) (met : W.need 0 f c ≤ W.level 0 c) (needs : 0 < W.need 0 f c) :
    W.Broken 0 f c ∧ ∀ t, t < n → W.level (t + 1) c = 0 :=
  have ended := Optimum.Next.frontier_exhausts rising strictly drawsDown rests long front
  ⟨⟨depends, met, Nat.lt_of_le_of_lt (Nat.le_of_eq (ended 0 long)) needs⟩, ended⟩

/-- **Where a level rises faster than the weighting falls, no optimum ends the condition at once.**
Under the premises of `Optimum.Next.frontier_leaves`, every optimum, among the open courses, of
every order rising with the weighted draw leaves the condition above nothing after the first
step. -/
theorem frontier_leaves
    (rising : ∀ a b, weighted w G a (n + 1) < weighted w G b (n + 1) → better b a)
    (empty : ∀ t, G t 0 = 0) (outgrows : ∀ t, t < n → w t * y < w (t + 1) * G (t + 1) y)
    (reach : y ≤ G 0 s) (drawsDown : G 0 s ≤ y + k) (keeps : ∀ t, y ≤ G t y)
    (holds : ∀ t, G t y ≤ k) (long : 0 < n)
    (front : Frontier (Open G k s) better fun t => W.level t c) : 0 < W.level 1 c :=
  Optimum.Next.frontier_leaves rising empty outgrows reach drawsDown keeps holds long front

/-- **Every optimum rebuilds the condition and restores what that level meets.** Under the premises
of `Optimum.Next.frontier_rebuilds`, every optimum, among the open courses, of every order rising
with the weighted draw leaves the condition at the rising course's level, drawing nothing before it,
at every step from the first to the `n`-th where that level is below `y`; and every dependence on
the condition, as it stands at the start, whose need that level meets by the `j + 1`-th step is
restored within `j + 1` steps. -/
theorem frontier_rebuilds
    (rising : ∀ a b, weighted w G a (n + 1) < weighted w G b (n + 1) → better b a)
    (low : s ≤ y) (grows : ∀ t z z', z ≤ z' → z' ≤ y → G t z ≤ G t z')
    (keeps : ∀ t, y ≤ G t y)
    (rises : ∀ t, t < n → ∀ z z', z ≤ z' → z' ≤ y →
      w (t + 1) * G (t + 1) z + w t * z' ≤ w (t + 1) * G (t + 1) z' + w t * z)
    (strictly : ∀ t, t < n → ∀ z z', z < z' → z' ≤ y →
      w (t + 1) * G (t + 1) z + w t * z' < w (t + 1) * G (t + 1) z' + w t * z)
    (top : ∀ t, t < n → ∀ z,
      w (t + 1) * G (t + 1) z + w t * y ≤ w (t + 1) * G (t + 1) y + w t * z)
    (holds : ∀ t, G t y ≤ k) (rests : ∀ t, G t 0 ≤ k)
    (front : Frontier (Open G k s) better fun t => W.level t c) :
    (∀ t, t < n → Optimum.Next.rise G y s (t + 1) < y →
      W.level (t + 1) c = Optimum.Next.rise G y s (t + 1) ∧
        W.level (t + 1) c = G t (W.level t c)) ∧
    ∀ f j, j < n → Optimum.Next.rise G y s (j + 1) < y →
      W.need 0 f c ≤ Optimum.Next.rise G y s (j + 1) → W.RestoredWithin (j + 1) 0 f c :=
  have stands := Optimum.Next.frontier_rebuilds rising low grows keeps rises strictly top holds
    rests front
  ⟨stands, fun _ j lt below meets => ⟨j + 1, Nat.succ_pos j, Nat.le_refl _,
    Nat.le_trans meets (Nat.le_of_eq ((stands j lt below).1.symm.trans
      (congrArg (W.level · c) (Nat.zero_add (j + 1)).symm)))⟩⟩

end Next

end Web

/-! ## An order weighting later draws less

Above, every step's draw counts alike. Here the draw of the step from `t` is weighted by `w t`, any
weighting, as an order weighting later draws less does. What a course could draw at a step, with
what it drew before, all weighted, changes from one step to the next by what the level it leaves
gains: that level with its renewal weighted at the next step, against it held, weighted at this
one. So against an open course leaving nothing whose level at each step gains the most, every
optimum of every order rising with the weighted draw gains at each step what that course's level
gains and leaves nothing weighted at the end, and that course is an optimum; the course holding a
level of greatest weighted gain at every step is a case. With every weight one the gain of a level
is its renewal, and a level of greatest gain one of greatest renewal (above). Where the weighting
falls faster than every positive level renews, `w (t + 1) (z + R z) < w t z`, nothing is the only
level of greatest gain: every optimum draws its own base to nothing at the first step, breaking
every dependence on it; where some level within reach renews faster than the weighting falls, the
course holding it outdraws every course ending the base at once, and no optimum ends it at the
first step. -/

namespace Optimum

/-- What a course of levels `x` draws across `n` steps where `R` gives at each level, the draw of
the step from `t` weighted by `w t`. -/
def weightedOver (w R : Nat → Nat) (x : Nat → Nat) (n : Nat) : Nat :=
  Next.weighted w (fun _ z => z + R z) x n

variable {w R : Nat → Nat} {k s y m n : Nat}

/-- **A course gaining the most against every open course.** At each step to the `n`-th the level
`h` leaves gains, weighted, at least what the level any course open from `s` leaves there does. -/
def GainsMost (w R : Nat → Nat) (k s n : Nat) (h : Nat → Nat) : Prop :=
  Next.GainsMost w (fun _ z => z + R z) k s n h

/-- A course whose level gains at each step to the `n`-th at least what any level does gains the
most against every open course. -/
theorem gainsMost_of_greatest {h : Nat → Nat}
    (greatest : ∀ t, t < n → ∀ z, w (t + 1) * (z + R z) + w t * h (t + 1) ≤
      w (t + 1) * (h (t + 1) + R (h (t + 1))) + w t * z) : GainsMost w R k s n h :=
  Next.gainsMost_of_greatest (G := fun _ z => z + R z) greatest

/-- **A course gaining the most against every open course is an optimum.** Where an open course from
`s` leaves nothing at the last step and gains the most against every open course, it is an optimum,
among the open courses, of the order by the weighted draw across `n + 1` steps. -/
theorem frontier_of_gainsMost {h : Nat → Nat} (opens : OpenCourse R k s h) (ends : h (n + 1) = 0)
    (most : GainsMost w R k s n h) :
    Frontier (OpenCourse R k s)
      (fun b a => weightedOver w R a (n + 1) < weightedOver w R b (n + 1)) h :=
  Next.frontier_of_gainsMost (G := fun _ z => z + R z) opens ends most

/-- **Every optimum gains what a course gaining the most gains, and leaves nothing weighted.** Under
the premises of `frontier_of_gainsMost`, every optimum of every order on the courses open from the
start that rises with the weighted draw across `n + 1` steps leaves, weighted at the last step,
nothing, and at each step to the `n`-th leaves a level gaining what that course's level gains. -/
theorem frontier_gains_of_most {better : (Nat → Nat) → (Nat → Nat) → Prop}
    (rising : ∀ a b, weightedOver w R a (n + 1) < weightedOver w R b (n + 1) → better b a)
    {h : Nat → Nat} (opens : OpenCourse R k s h) (ends : h (n + 1) = 0)
    (most : GainsMost w R k s n h) {x : Nat → Nat} (front : Frontier (OpenCourse R k s) better x) :
    w n * x (n + 1) = 0 ∧ ∀ t, t < n →
      w (t + 1) * (x (t + 1) + R (x (t + 1))) + w t * h (t + 1) =
        w (t + 1) * (h (t + 1) + R (h (t + 1))) + w t * x (t + 1) :=
  Next.frontier_gains_of_most (G := fun _ z => z + R z) rising opens ends most front

/-- **A course of greatest weighted gain is an optimum.** Where an open course from `s` leaves
nothing at the last step and the level it leaves at each step to the `n`-th gains, weighted, at
least what any level does, it is an optimum, among the open courses, of the order by the weighted
draw across `n + 1` steps: the case of `frontier_of_gainsMost`. -/
theorem weighted_frontier {h : Nat → Nat} (opens : OpenCourse R k s h) (ends : h (n + 1) = 0)
    (greatest : ∀ t, t < n → ∀ z, w (t + 1) * (z + R z) + w t * h (t + 1) ≤
      w (t + 1) * (h (t + 1) + R (h (t + 1))) + w t * z) :
    Frontier (OpenCourse R k s)
      (fun b a => weightedOver w R a (n + 1) < weightedOver w R b (n + 1)) h :=
  frontier_of_gainsMost opens ends (gainsMost_of_greatest greatest)

/-- **Every optimum gains, at each step, what a course of greatest weighted gain gains, and leaves
nothing weighted.** Under the premises of `weighted_frontier`, every optimum of every order on the
courses open from the start that rises with the weighted draw across `n + 1` steps leaves, weighted
at the last step, nothing, and at each step to the `n`-th leaves a level gaining what the course of
greatest gain's level gains: the case of `frontier_gains_of_most`. -/
theorem frontier_gains_weighted {better : (Nat → Nat) → (Nat → Nat) → Prop}
    (rising : ∀ a b, weightedOver w R a (n + 1) < weightedOver w R b (n + 1) → better b a)
    {h : Nat → Nat} (opens : OpenCourse R k s h) (ends : h (n + 1) = 0)
    (greatest : ∀ t, t < n → ∀ z, w (t + 1) * (z + R z) + w t * h (t + 1) ≤
      w (t + 1) * (h (t + 1) + R (h (t + 1))) + w t * z)
    {x : Nat → Nat} (front : Frontier (OpenCourse R k s) better x) :
    w n * x (n + 1) = 0 ∧ ∀ t, t < n →
      w (t + 1) * (x (t + 1) + R (x (t + 1))) + w t * h (t + 1) =
        w (t + 1) * (h (t + 1) + R (h (t + 1))) + w t * x (t + 1) :=
  frontier_gains_of_most rising opens ends (gainsMost_of_greatest greatest) front

/-- **Every optimum stands below a need above every level of greatest weighted gain.** Under the
premises of `weighted_frontier`, where every level at or above `m` gains, weighted, less than the
course of greatest gain's level at each step to the `n`-th, every optimum of every order rising
with the weighted draw stands below `m` at every step from the first to the `n`-th. -/
theorem frontier_below_weighted {better : (Nat → Nat) → (Nat → Nat) → Prop}
    (rising : ∀ a b, weightedOver w R a (n + 1) < weightedOver w R b (n + 1) → better b a)
    {h : Nat → Nat} (opens : OpenCourse R k s h) (ends : h (n + 1) = 0)
    (greatest : ∀ t, t < n → ∀ z, w (t + 1) * (z + R z) + w t * h (t + 1) ≤
      w (t + 1) * (h (t + 1) + R (h (t + 1))) + w t * z)
    (above : ∀ t, t < n → ∀ z, m ≤ z → w (t + 1) * (z + R z) + w t * h (t + 1) <
      w (t + 1) * (h (t + 1) + R (h (t + 1))) + w t * z)
    {x : Nat → Nat} (front : Frontier (OpenCourse R k s) better x) :
    ∀ t, t < n → x (t + 1) < m :=
  Next.frontier_below (G := fun _ z => z + R z) rising opens ends greatest above front

/-- The course holding `y` and leaving nothing is open over a horizon of at least two steps, with a
capacity covering what the first step draws down to `y`, `y` with its renewal, and what is given at
nothing. -/
theorem holding_open_at (reach : y ≤ s + R s) (drawsDown : s + R s ≤ y + k) (holds : y + R y ≤ k)
    (rests : R 0 ≤ k) (long : 0 < n) : OpenCourse R k s (holding s y n) :=
  Next.holding_open (G := fun _ z => z + R z) reach drawsDown (fun _ => Nat.le_add_right y (R y))
    (fun _ => holds) (fun _ => Nat.le_trans (Nat.le_of_eq (Nat.zero_add (R 0))) rests) long

/-- **The course holding a level of greatest weighted gain is an optimum**, where `y` is within the
start with what is given there and gains, weighted, at each step to the `n`-th at least what any
level does, over a horizon of at least two steps, with a capacity covering what the first step
draws down to `y`, `y` with its renewal, and what is given at nothing: the case of
`weighted_frontier`. -/
theorem weighted_holding_frontier
    (greatest : ∀ t, t < n → ∀ z, w (t + 1) * (z + R z) + w t * y ≤ w (t + 1) * (y + R y) + w t * z)
    (reach : y ≤ s + R s) (drawsDown : s + R s ≤ y + k) (holds : y + R y ≤ k) (rests : R 0 ≤ k)
    (long : 0 < n) :
    Frontier (OpenCourse R k s)
      (fun b a => weightedOver w R a (n + 1) < weightedOver w R b (n + 1)) (holding s y n) :=
  weighted_frontier (holding_open_at reach drawsDown holds rests long)
    (holding_after (Nat.le_refl n))
    (holding_gains (P := fun t v => ∀ z, w (t + 1) * (z + R z) + w t * v ≤
      w (t + 1) * (v + R v) + w t * z) greatest)

/-- **The course ending the base at once is an optimum** where the weighting falls at least as fast
as every positive level renews, over a horizon of at least two steps, with a capacity covering the
start with what is given there and what is given at nothing. -/
theorem exhausting_frontier
    (outpaced : ∀ t, t < n → ∀ z, 0 < z → w (t + 1) * (z + R z) ≤ w t * z)
    (drawsDown : s + R s ≤ k) (rests : R 0 ≤ k) (long : 0 < n) :
    Frontier (OpenCourse R k s)
      (fun b a => weightedOver w R a (n + 1) < weightedOver w R b (n + 1)) (holding s 0 n) :=
  Next.exhausting_frontier (G := fun _ z => z + R z) outpaced drawsDown (fun _ => Nat.le_trans
    (Nat.le_of_eq (Nat.zero_add (R 0))) rests) long

/-- **A weighting falling faster than every level renews ends the base at once.** Where the
weighting falls faster than every positive level renews at each step to the `n`-th, `w (t + 1)`
on a level with its renewal less than `w t` on it held, over a horizon of at least two steps, with
a capacity covering the start with what is given there and what is given at nothing, every optimum
of every order on the courses open from the start that rises with the weighted draw across `n + 1`
steps stands at nothing at every step from the first to the `n`-th. -/
theorem frontier_exhausts {better : (Nat → Nat) → (Nat → Nat) → Prop}
    (rising : ∀ a b, weightedOver w R a (n + 1) < weightedOver w R b (n + 1) → better b a)
    (strictly : ∀ t, t < n → ∀ z, 0 < z → w (t + 1) * (z + R z) < w t * z)
    (drawsDown : s + R s ≤ k) (rests : R 0 ≤ k) (long : 0 < n) {x : Nat → Nat}
    (front : Frontier (OpenCourse R k s) better x) : ∀ t, t < n → x (t + 1) = 0 :=
  Next.frontier_exhausts (G := fun _ z => z + R z) rising strictly drawsDown (fun _ => Nat.le_trans
    (Nat.le_of_eq (Nat.zero_add (R 0))) rests) long front

/-- **No optimum ends the base at once where a level renews faster than the weighting falls.**
Where nothing is given at nothing and some `y` within the start with what is given there renews
faster than the weighting falls at each step to the `n`-th, `w t y < w (t + 1) (y + R y)`, over a
horizon of at least two steps, with a capacity covering what the first step draws down to `y` and
`y` with its renewal, no optimum of any order on the courses open from the start that rises with
the weighted draw across `n + 1` steps stands at nothing after the first step. -/
theorem frontier_leaves {better : (Nat → Nat) → (Nat → Nat) → Prop}
    (rising : ∀ a b, weightedOver w R a (n + 1) < weightedOver w R b (n + 1) → better b a)
    (empty : R 0 = 0) (outgrows : ∀ t, t < n → w t * y < w (t + 1) * (y + R y))
    (reach : y ≤ s + R s) (drawsDown : s + R s ≤ y + k) (holds : y + R y ≤ k) (long : 0 < n)
    {x : Nat → Nat} (front : Frontier (OpenCourse R k s) better x) : 0 < x 1 :=
  Next.frontier_leaves (G := fun _ z => z + R z) rising (fun _ => (Nat.zero_add (R 0)).trans empty)
    outgrows reach drawsDown (fun _ => Nat.le_add_right y (R y)) (fun _ => holds) long front

end Optimum

namespace Web

open Optimum

variable {W : Web F C} {c : C} {f : F} {w R : Nat → Nat} {k s y m n : Nat}
  {better : (Nat → Nat) → (Nat → Nat) → Prop}

/-- **A dependence above every level of greatest weighted gain is broken at the first step.**
Under the premises of `Optimum.frontier_below_weighted`, over a horizon of at least two steps, with
a formation depending on the condition at the start, met there, and needing at least `m`: every
optimum, among the open courses, of every order rising with the weighted draw breaks the dependence
at the first step. -/
theorem frontier_broken_weighted
    (rising : ∀ a b, weightedOver w R a (n + 1) < weightedOver w R b (n + 1) → better b a)
    {h : Nat → Nat} (opens : OpenCourse R k s h) (ends : h (n + 1) = 0)
    (greatest : ∀ t, t < n → ∀ z, w (t + 1) * (z + R z) + w t * h (t + 1) ≤
      w (t + 1) * (h (t + 1) + R (h (t + 1))) + w t * z)
    (above : ∀ t, t < n → ∀ z, m ≤ z → w (t + 1) * (z + R z) + w t * h (t + 1) <
      w (t + 1) * (h (t + 1) + R (h (t + 1))) + w t * z)
    (long : 0 < n) (front : Frontier (OpenCourse R k s) better fun t => W.level t c)
    (depends : W.requires 0 f c) (met : W.need 0 f c ≤ W.level 0 c) (need : m ≤ W.need 0 f c) :
    W.Broken 0 f c :=
  ⟨depends, met, Nat.lt_of_lt_of_le (Optimum.frontier_below_weighted rising opens ends greatest
    above front 0 long) need⟩

/-- **A weighting falling faster than every level renews ends the condition at once.** Under the
premises of `Optimum.frontier_exhausts`, every optimum, among the open courses, of every order
rising with the weighted draw leaves the condition at nothing at every step from the first to the
`n`-th, and breaks at the first step every dependence on it with a positive need, met at the
start. -/
theorem frontier_exhausts
    (rising : ∀ a b, weightedOver w R a (n + 1) < weightedOver w R b (n + 1) → better b a)
    (strictly : ∀ t, t < n → ∀ z, 0 < z → w (t + 1) * (z + R z) < w t * z)
    (drawsDown : s + R s ≤ k) (rests : R 0 ≤ k) (long : 0 < n)
    (front : Frontier (OpenCourse R k s) better fun t => W.level t c)
    (depends : W.requires 0 f c) (met : W.need 0 f c ≤ W.level 0 c) (needs : 0 < W.need 0 f c) :
    W.Broken 0 f c ∧ ∀ t, t < n → W.level (t + 1) c = 0 :=
  have ended := Optimum.frontier_exhausts rising strictly drawsDown rests long front
  ⟨⟨depends, met, Nat.lt_of_le_of_lt (Nat.le_of_eq (ended 0 long)) needs⟩, ended⟩

/-- **Where a level renews faster than the weighting falls, no optimum ends the condition at
once.** Under the premises of `Optimum.frontier_leaves`, every optimum, among the open courses, of
every order rising with the weighted draw leaves the condition above nothing after the first
step. -/
theorem frontier_leaves
    (rising : ∀ a b, weightedOver w R a (n + 1) < weightedOver w R b (n + 1) → better b a)
    (empty : R 0 = 0) (outgrows : ∀ t, t < n → w t * y < w (t + 1) * (y + R y))
    (reach : y ≤ s + R s) (drawsDown : s + R s ≤ y + k) (holds : y + R y ≤ k) (long : 0 < n)
    (front : Frontier (OpenCourse R k s) better fun t => W.level t c) : 0 < W.level 1 c :=
  Optimum.frontier_leaves rising empty outgrows reach drawsDown holds long front

end Web

namespace Optimum

namespace Holding

open Diversion

/-- Under the logistic law a level renews at most itself. -/
theorem logistic_le_self : ∀ z, logistic z ≤ z
  | 0 => Nat.le_refl 0
  | 1 => Nat.le_refl 1
  | z + 2 => Nat.le_trans (Nat.le_of_eq (logistic_beyond z)) (Nat.zero_le _)

/-- Under the logistic law, where a weight `a` is at least twice `b`, a positive level gains,
weighted by `b` at the next step, at most what it does held, weighted by `a`. -/
theorem logistic_outpaced_le {a b : Nat} (steep : 2 * b ≤ a) :
    ∀ z, 0 < z → b * (z + logistic z) ≤ a * z :=
  fun z _ => calc b * (z + logistic z) ≤ b * (z + z) :=
        Nat.mul_le_mul_left b (Nat.add_le_add_left (logistic_le_self z) z)
    _ = 2 * b * z := by rw [Nat.mul_add, ← Nat.two_mul, mul_assoc_nat]
    _ ≤ a * z := Nat.mul_le_mul_right z steep

/-- Under the logistic law, where a weight `a` is more than twice `b`, a positive level gains,
weighted by `b` at the next step, less than what it does held, weighted by `a`. -/
theorem logistic_outpaced {a b : Nat} (steep : 2 * b < a) :
    ∀ z, 0 < z → b * (z + logistic z) < a * z :=
  fun z pos => Nat.lt_of_le_of_lt (logistic_outpaced_le (Nat.le_refl _) z pos)
    (match le_dest (show 1 ≤ z from pos) with
    | ⟨i, split⟩ => by
      rw [split, Nat.add_comm 1 i, Nat.mul_succ, Nat.mul_succ]
      exact Nat.add_lt_add_of_le_of_lt (Nat.mul_le_mul_right i (Nat.le_of_lt steep)) steep)

/-- Under the logistic law, with a weight `a` at a step at least `b` at the next, a level of two or
more gains, weighted, with `a` to spare, at most what one gains. -/
theorem logistic_beyond_gain {a b : Nat} (falls : b ≤ a) (z : Nat) :
    b * (z + 2 + logistic (z + 2)) + a * 1 + a ≤ b * (1 + logistic 1) + a * (z + 2) := by
  rw [logistic_beyond z, Nat.add_zero, Nat.mul_one]
  show b * (z + 2) + a + a ≤ b * 2 + a * (z + 2)
  rw [Nat.mul_add b z 2, Nat.mul_add a z 2, Nat.mul_two a, Nat.add_assoc (b * z + b * 2) a a,
    Nat.add_comm (b * z) (b * 2), Nat.add_assoc (b * 2) (b * z) (a + a)]
  exact Nat.add_le_add_left (Nat.add_le_add_right (Nat.mul_le_mul_right z falls) (a + a)) (b * 2)

/-- **One gains the most under the logistic law** where the weight falls by at most half a step:
with `b ≤ a ≤ 2 b`, no level gains, weighted, more than one does. -/
theorem logistic_gain_le {a b : Nat} (falls : b ≤ a) (gentle : a ≤ 2 * b) :
    ∀ z, b * (z + logistic z) + a * 1 ≤ b * (1 + logistic 1) + a * z
  | 0 => by
    show b * 0 + a * 1 ≤ b * 2 + a * 0
    rw [Nat.mul_zero b, Nat.mul_zero a, Nat.zero_add, Nat.add_zero, Nat.mul_one, Nat.mul_comm b 2]
    exact gentle
  | 1 => Nat.le_refl _
  | z + 2 => Nat.le_trans (Nat.le_add_right _ a) (logistic_beyond_gain falls z)

/-- Under the logistic law, with a positive weight `b` at most `a`, every level of two or more
gains less than one does. -/
theorem logistic_gain_lt {a b : Nat} (falls : b ≤ a) (pos : 0 < b) :
    ∀ z, 2 ≤ z → b * (z + logistic z) + a * 1 < b * (1 + logistic 1) + a * z
  | 0, le => absurd le (Nat.not_succ_le_zero 1)
  | 1, le => absurd le (Nat.not_succ_le_self 1)
  | z + 2, _ => Nat.lt_of_lt_of_le (Nat.lt_add_of_pos_right (Nat.lt_of_lt_of_le pos falls))
      (logistic_beyond_gain falls z)

/-- Under the logistic law, where the weight falls by less than half a step, nothing gains less
than one does. -/
theorem logistic_gain_zero {a b : Nat} (gentle : a < 2 * b) :
    b * (0 + logistic 0) + a * 1 < b * (1 + logistic 1) + a * 0 := by
  show b * 0 + a * 1 < b * 2 + a * 0
  rw [Nat.mul_zero b, Nat.mul_zero a, Nat.zero_add, Nat.add_zero, Nat.mul_one, Nat.mul_comm b 2]
  exact gentle

/-- A weight less than twice another leaves the other positive. -/
theorem pos_of_lt_two_mul {a b : Nat} (lt : a < 2 * b) : 0 < b :=
  match Nat.eq_zero_or_pos b with
  | .inl zero => absurd (Eq.subst (motive := fun z => a < 2 * z) zero lt) (Nat.not_lt_zero a)
  | .inr pos => pos

/-- **The logistic witness: a weighting falling faster or slower than the source renews.** From a
source at two under the logistic law with capacity two, the order by what the taker draws over
`n + 2` steps, the draw of the step from `t` weighted by `w t`. One, the level of greatest renewal,
returns two for one. Where the weight falls more than twofold at every step, `2 w (t + 1) < w t`,
the course drawing the source to nothing at the first step is an optimum, and every optimum draws
the source to nothing there and breaks the dweller, which needs two (`exhausting_frontier`,
`Web.frontier_exhausts`). Where it falls exactly twofold, the course ending the source at once and
the course holding it at one are both optima: neither strict premise can be dropped. Where it falls
at a step by less than half, `w (t + 1) ≤ w t < 2 w (t + 1)`, the course holding the source at one
is an optimum, and every optimum holds it at one at every step to the last and breaks the dweller
at the first step (`weighted_holding_frontier`, `frontier_gains_weighted`,
`Web.frontier_broken_weighted`). -/
theorem logistic_weighted (n : Nat) (w : Nat → Nat) :
    ((∀ t, t < n + 1 → 2 * w (t + 1) < w t) →
      Frontier (OpenCourse logistic 2 2)
        (fun b a => weightedOver w logistic a (n + 1 + 1) < weightedOver w logistic b (n + 1 + 1))
        (holding 2 0 (n + 1)) ∧
      ∀ x, Frontier (OpenCourse logistic 2 2)
        (fun b a => weightedOver w logistic a (n + 1 + 1) < weightedOver w logistic b (n + 1 + 1))
        x →
      (web (onSource x)).Broken 0 .dweller .source ∧
        ∀ t, t < n + 1 → (web (onSource x)).level (t + 1) .source = 0) ∧
    ((∀ t, t < n + 1 → w t = 2 * w (t + 1)) →
      Frontier (OpenCourse logistic 2 2)
        (fun b a => weightedOver w logistic a (n + 1 + 1) < weightedOver w logistic b (n + 1 + 1))
        (holding 2 0 (n + 1)) ∧
      Frontier (OpenCourse logistic 2 2)
        (fun b a => weightedOver w logistic a (n + 1 + 1) < weightedOver w logistic b (n + 1 + 1))
        (holding 2 1 (n + 1))) ∧
    ((∀ t, t < n + 1 → w (t + 1) ≤ w t ∧ w t < 2 * w (t + 1)) →
      Frontier (OpenCourse logistic 2 2)
        (fun b a => weightedOver w logistic a (n + 1 + 1) < weightedOver w logistic b (n + 1 + 1))
        (holding 2 1 (n + 1)) ∧
      ∀ x, Frontier (OpenCourse logistic 2 2)
        (fun b a => weightedOver w logistic a (n + 1 + 1) < weightedOver w logistic b (n + 1 + 1))
        x →
      (web (onSource x)).Broken 0 .dweller .source ∧
        ∀ t, t < n + 1 → (web (onSource x)).level (t + 1) .source = 1) :=
  ⟨fun steep =>
    have strictly : ∀ t, t < n + 1 → ∀ z, 0 < z →
        w (t + 1) * (z + logistic z) < w t * z := fun t lt => logistic_outpaced (steep t lt)
    ⟨exhausting_frontier (fun t lt z pos => Nat.le_of_lt (strictly t lt z pos)) (Nat.le_refl 2)
      (Nat.zero_le 2) (Nat.succ_pos n),
     fun x front =>
      Web.frontier_exhausts (W := web (onSource x)) (c := Place.source) (f := Formation.dweller)
        (fun _ _ less => less) strictly (Nat.le_refl 2) (Nat.zero_le 2) (Nat.succ_pos n) front
        trivial (Nat.le_of_eq front.1.1.symm) (Nat.succ_pos 1)⟩,
   fun tie =>
    ⟨exhausting_frontier (fun t lt => logistic_outpaced_le (Nat.le_of_eq (tie t lt).symm))
      (Nat.le_refl 2) (Nat.zero_le 2) (Nat.succ_pos n),
     weighted_holding_frontier (fun t lt => logistic_gain_le
        (Nat.le_trans (Nat.le_add_right _ _)
          (Nat.le_of_eq ((Nat.two_mul _).symm.trans (tie t lt).symm)))
        (Nat.le_of_eq (tie t lt)))
      (Nat.le_succ 1) (Nat.le_succ 2) (Nat.le_refl 2) (Nat.zero_le 2) (Nat.succ_pos n)⟩,
   fun gentle =>
    have greatest : ∀ t, t < n + 1 → ∀ z, w (t + 1) * (z + logistic z) + w t * 1 ≤
        w (t + 1) * (1 + logistic 1) + w t * z :=
      fun t lt => logistic_gain_le (gentle t lt).1 (Nat.le_of_lt (gentle t lt).2)
    have above : ∀ t, t < n + 1 → ∀ z, 2 ≤ z → w (t + 1) * (z + logistic z) + w t * 1 <
        w (t + 1) * (1 + logistic 1) + w t * z :=
      fun t lt => logistic_gain_lt (gentle t lt).1 (pos_of_lt_two_mul (gentle t lt).2)
    ⟨weighted_holding_frontier greatest (Nat.le_succ 1) (Nat.le_succ 2) (Nat.le_refl 2)
      (Nat.zero_le 2) (Nat.succ_pos n),
     fun x front =>
      have opens := holding_open_at (s := 2) (k := 2) (n := n + 1) (R := logistic) (y := 1)
        (Nat.le_succ 1) (Nat.le_succ 2) (Nat.le_refl 2) (Nat.zero_le 2) (Nat.succ_pos n)
      have ends := holding_after (s := 2) (y := 1) (Nat.le_refl (n + 1))
      have greatestH := holding_gains (s := 2) (P := fun t v => ∀ z, w (t + 1) * (z + logistic z) +
        w t * v ≤ w (t + 1) * (v + logistic v) + w t * z) greatest
      have aboveH := holding_gains (s := 2) (P := fun t v => ∀ z, 2 ≤ z →
        w (t + 1) * (z + logistic z) + w t * v < w (t + 1) * (v + logistic v) + w t * z) above
      have below := frontier_below_weighted (m := 2) (fun _ _ less => less) opens ends greatestH
        aboveH front
      have gains := (frontier_gains_weighted (fun _ _ less => less) opens ends greatestH front).2
      ⟨Web.frontier_broken_weighted (W := web (onSource x)) (c := Place.source)
          (f := Formation.dweller) (m := 2) (fun _ _ less => less) opens ends greatestH aboveH
          (Nat.succ_pos n) front trivial (Nat.le_of_eq front.1.1.symm) (Nat.le_refl 2),
       fun t lt => match Nat.eq_zero_or_pos (x (t + 1)) with
        | .inl zero => by
          have same := gains t lt
          rw [zero, holding_before lt] at same
          exact absurd same (Nat.ne_of_lt (logistic_gain_zero (gentle t lt).2))
        | .inr pos => Nat.le_antisymm (Nat.le_of_lt_succ (below t lt)) pos⟩⟩⟩

end Holding

end Optimum

/-! ## Rebuilding from below

Above, an optimum holds a level of greatest gain the start reaches in one step. Where the start lies
further below, a course rises only as fast as what is given allows. Where the next level rises with
the level below `y`, the course rising so up to `y` stands at each step at or above every open
course below `y`: nothing open rises faster. So where the weighted gain rises with the level up to
`y` and is greatest there, that course, leaving nothing at the end, gains the most against every
open course and is an optimum of every order rising with the weighted draw; where the gain rises
strictly below `y`, every optimum stands at its level, drawing nothing, at every step where that
level is below `y`: every optimum rebuilds a depleted base as fast as it renews, and meets again
every dependence on it whose need that level meets. -/

namespace Optimum

/-- The level a course from `s` rising as fast as what is given allows, up to `y`, stands at after
`t` steps. -/
def rise (R : Nat → Nat) (y s : Nat) : Nat → Nat :=
  Next.rise (fun _ z => z + R z) y s

/-- From `s`, the course rising as fast as what is given allows up to `y` to the `n`-th step and
standing at nothing after: the course rebuilding toward `y`. -/
def rebuilding (R : Nat → Nat) (y s n : Nat) : Nat → Nat :=
  Next.rebuilding (fun _ z => z + R z) y s n

variable {w R : Nat → Nat} {k s y n : Nat}

/-- Once at `y`, the rising course stands there at every later step. -/
theorem rise_stays {j : Nat} (top : rise R y s j = y) : ∀ i, rise R y s (j + i) = y :=
  Next.rise_stays (G := fun _ z => z + R z) (fun _ => Nat.le_add_right y (R y)) top

/-- **The rebuilding course is an optimum**, under the premises of `rebuilding_gainsMost`, with a
capacity covering `y` with what is given there and what is given at nothing: of the order by the
weighted draw across `n + 1` steps, among the courses open from `s`. -/
theorem rebuilding_frontier (low : s ≤ y) (grows : ∀ z z', z ≤ z' → z' ≤ y → z + R z ≤ z' + R z')
    (rises : ∀ t, t < n → ∀ z z', z ≤ z' → z' ≤ y →
      w (t + 1) * (z + R z) + w t * z' ≤ w (t + 1) * (z' + R z') + w t * z)
    (top : ∀ t, t < n → ∀ z, w (t + 1) * (z + R z) + w t * y ≤ w (t + 1) * (y + R y) + w t * z)
    (holds : y + R y ≤ k) (rests : R 0 ≤ k) :
    Frontier (OpenCourse R k s)
      (fun b a => weightedOver w R a (n + 1) < weightedOver w R b (n + 1)) (rebuilding R y s n) :=
  Next.rebuilding_frontier (G := fun _ z => z + R z) low (fun _ => grows) (fun _ => Nat.le_add_right
    y (R y)) rises top (fun _ => holds) (fun _ => Nat.le_trans (Nat.le_of_eq (Nat.zero_add (R 0)))
    rests)

/-- **Every optimum rebuilds.** Under the premises of `rebuilding_frontier`, where the weighted gain
rises strictly with the level below `y`, every optimum of every order on the courses open from `s`
that rises with the weighted draw across `n + 1` steps stands at the rising course's level at every
step from the first to the `n`-th where that level is below `y`, and draws nothing at the step
before: it rebuilds as fast as what is given allows. -/
theorem frontier_rebuilds {better : (Nat → Nat) → (Nat → Nat) → Prop}
    (rising : ∀ a b, weightedOver w R a (n + 1) < weightedOver w R b (n + 1) → better b a)
    (low : s ≤ y) (grows : ∀ z z', z ≤ z' → z' ≤ y → z + R z ≤ z' + R z')
    (rises : ∀ t, t < n → ∀ z z', z ≤ z' → z' ≤ y →
      w (t + 1) * (z + R z) + w t * z' ≤ w (t + 1) * (z' + R z') + w t * z)
    (strictly : ∀ t, t < n → ∀ z z', z < z' → z' ≤ y →
      w (t + 1) * (z + R z) + w t * z' < w (t + 1) * (z' + R z') + w t * z)
    (top : ∀ t, t < n → ∀ z, w (t + 1) * (z + R z) + w t * y ≤ w (t + 1) * (y + R y) + w t * z)
    (holds : y + R y ≤ k) (rests : R 0 ≤ k) {x : Nat → Nat}
    (front : Frontier (OpenCourse R k s) better x) :
    ∀ t, t < n → rise R y s (t + 1) < y →
      x (t + 1) = rise R y s (t + 1) ∧ x (t + 1) = x t + R (x t) :=
  Next.frontier_rebuilds (G := fun _ z => z + R z) rising low (fun _ => grows) (fun _ =>
    Nat.le_add_right y (R y)) rises strictly top (fun _ => holds) (fun _ => Nat.le_trans
    (Nat.le_of_eq (Nat.zero_add (R 0))) rests) front

/-- **Every optimum stands at `y` once the rising course reaches it.** Under the premises of
`rebuilding_frontier`, where `y` gains, weighted, more than every other level at each step to the
`n`-th, every optimum of every order on the courses open from `s` that rises with the weighted
draw across `n + 1` steps stands at `y` at every step from the first to the `n`-th where the rising
course does. -/
theorem frontier_rebuilt {better : (Nat → Nat) → (Nat → Nat) → Prop}
    (rising : ∀ a b, weightedOver w R a (n + 1) < weightedOver w R b (n + 1) → better b a)
    (low : s ≤ y) (grows : ∀ z z', z ≤ z' → z' ≤ y → z + R z ≤ z' + R z')
    (rises : ∀ t, t < n → ∀ z z', z ≤ z' → z' ≤ y →
      w (t + 1) * (z + R z) + w t * z' ≤ w (t + 1) * (z' + R z') + w t * z)
    (above : ∀ t, t < n → ∀ z, z ≠ y →
      w (t + 1) * (z + R z) + w t * y < w (t + 1) * (y + R y) + w t * z)
    (holds : y + R y ≤ k) (rests : R 0 ≤ k) {x : Nat → Nat}
    (front : Frontier (OpenCourse R k s) better x) :
    ∀ t, t < n → rise R y s (t + 1) = y → x (t + 1) = y :=
  Next.frontier_rebuilt (G := fun _ z => z + R z) rising low (fun _ => grows) (fun _ =>
    Nat.le_add_right y (R y)) rises above (fun _ => holds) (fun _ => Nat.le_trans (Nat.le_of_eq
    (Nat.zero_add (R 0))) rests) front

end Optimum

namespace Web

open Optimum

variable {W : Web F C} {c : C} {w R : Nat → Nat} {k s y n : Nat}
  {better : (Nat → Nat) → (Nat → Nat) → Prop}

/-- **Every optimum rebuilds the condition and restores what that level meets.** Under the premises
of `Optimum.frontier_rebuilds`, every optimum, among the open courses, of every order rising with
the weighted draw leaves the condition at the rising course's level, drawing nothing before it, at
every step from the first to the `n`-th where that level is below `y`; and every dependence on the
condition, as it stands at the start, whose need that level meets by the `j + 1`-th step is
restored within `j + 1` steps. -/
theorem frontier_rebuilds
    (rising : ∀ a b, weightedOver w R a (n + 1) < weightedOver w R b (n + 1) → better b a)
    (low : s ≤ y) (grows : ∀ z z', z ≤ z' → z' ≤ y → z + R z ≤ z' + R z')
    (rises : ∀ t, t < n → ∀ z z', z ≤ z' → z' ≤ y →
      w (t + 1) * (z + R z) + w t * z' ≤ w (t + 1) * (z' + R z') + w t * z)
    (strictly : ∀ t, t < n → ∀ z z', z < z' → z' ≤ y →
      w (t + 1) * (z + R z) + w t * z' < w (t + 1) * (z' + R z') + w t * z)
    (top : ∀ t, t < n → ∀ z, w (t + 1) * (z + R z) + w t * y ≤ w (t + 1) * (y + R y) + w t * z)
    (holds : y + R y ≤ k) (rests : R 0 ≤ k)
    (front : Frontier (OpenCourse R k s) better fun t => W.level t c) :
    (∀ t, t < n → Optimum.rise R y s (t + 1) < y →
      W.level (t + 1) c = Optimum.rise R y s (t + 1) ∧
        W.level (t + 1) c = W.level t c + R (W.level t c)) ∧
    ∀ f j, j < n → Optimum.rise R y s (j + 1) < y → W.need 0 f c ≤ Optimum.rise R y s (j + 1) →
      W.RestoredWithin (j + 1) 0 f c :=
  have stands := Optimum.frontier_rebuilds rising low grows rises strictly top holds rests front
  ⟨stands, fun _ j lt below meets => ⟨j + 1, Nat.succ_pos j, Nat.le_refl _,
    Nat.le_trans meets (Nat.le_of_eq ((stands j lt below).1.symm.trans
      (congrArg (W.level · c) (Nat.zero_add (j + 1)).symm)))⟩⟩

end Web

namespace Optimum

namespace Holding

open Diversion

/-- A level of at most eight renews itself, doubling; above eight nothing is given. -/
def doubling (z : Nat) : Nat := if z ≤ 8 then z else 0

/-- Twice `b`, `d` times, is `b` on `d` twice. -/
theorem twice_mul (b d : Nat) : 2 * b * d = b * (d + d) := by
  rw [mul_assoc_nat, Nat.two_mul, Nat.mul_add]

/-- Where `a` is at most twice `b`, a level doubling gains, weighted by `b` at the next step against
`a` held, no less at a higher level. -/
theorem doubling_gain_le {a b z z' : Nat} (gentle : a ≤ 2 * b) (le : z ≤ z') :
    b * (z + z) + a * z' ≤ b * (z' + z') + a * z :=
  match le_dest le with
  | ⟨d, split⟩ => by
    rw [split, add_four, Nat.mul_add b (z + z) (d + d), Nat.mul_add a z d, Nat.add_assoc,
      Nat.add_comm (b * (d + d)) (a * z)]
    exact Nat.add_le_add_left (Nat.add_le_add_left (Nat.le_trans (Nat.mul_le_mul_right d gentle)
      (Nat.le_of_eq (twice_mul b d))) (a * z)) (b * (z + z))

/-- Where `a` is less than twice `b`, a level doubling gains, weighted, more at a higher level. -/
theorem doubling_gain_lt {a b z z' : Nat} (gentle : a < 2 * b) (lt : z < z') :
    b * (z + z) + a * z' < b * (z' + z') + a * z :=
  match le_dest (show z + 1 ≤ z' from lt) with
  | ⟨e, split⟩ => by
    have scaled : a * (e + 1) < 2 * b * (e + 1) := by
      rw [Nat.mul_succ, Nat.mul_succ]
      exact Nat.add_lt_add_of_le_of_lt (Nat.mul_le_mul_right e (Nat.le_of_lt gentle)) gentle
    rw [split, Nat.add_assoc z 1 e, Nat.add_comm 1 e, add_four, Nat.mul_add b (z + z),
      Nat.mul_add a z, Nat.add_assoc, Nat.add_comm (b * ((e + 1) + (e + 1))) (a * z)]
    exact Nat.add_lt_add_left (Nat.add_lt_add_left (Nat.lt_of_lt_of_le scaled
      (Nat.le_of_eq (twice_mul b (e + 1)))) (a * z)) (b * (z + z))

/-- At most eight, a level with what is given is twice the level. -/
theorem doubling_low {z : Nat} (le : z ≤ 8) : z + doubling z = z + z :=
  congrArg (z + ·) (if_pos le)

/-- Above eight, a level with what is given is the level. -/
theorem doubling_high {z : Nat} (lt : 8 < z) : z + doubling z = z :=
  (congrArg (z + ·) (if_neg (Nat.not_le_of_gt lt))).trans (Nat.add_zero z)

/-- Under the doubling law, the next level rises with the level up to eight. -/
theorem doubling_grows : ∀ z z', z ≤ z' → z' ≤ 8 → z + doubling z ≤ z' + doubling z' :=
  fun _ _ le top => Nat.le_trans (Nat.le_of_eq (doubling_low (Nat.le_trans le top)))
    (Nat.le_trans (Nat.add_le_add le le) (Nat.le_of_eq (doubling_low top).symm))

/-- Under the doubling law, where `a` is at most twice `b`, the weighted gain rises with the level
up to eight. -/
theorem doubling_rises {a b : Nat} (gentle : a ≤ 2 * b) :
    ∀ z z', z ≤ z' → z' ≤ 8 → b * (z + doubling z) + a * z' ≤ b * (z' + doubling z') + a * z :=
  fun _ _ le top => by
    rw [doubling_low (Nat.le_trans le top), doubling_low top]
    exact doubling_gain_le gentle le

/-- Under the doubling law, where `a` is less than twice `b`, the weighted gain rises strictly with
the level up to eight. -/
theorem doubling_rises_strictly {a b : Nat} (gentle : a < 2 * b) :
    ∀ z z', z < z' → z' ≤ 8 → b * (z + doubling z) + a * z' < b * (z' + doubling z') + a * z :=
  fun _ _ lt top => by
    rw [doubling_low (Nat.le_trans (Nat.le_of_lt lt) top), doubling_low top]
    exact doubling_gain_lt gentle lt

/-- Under the doubling law, where `a` is at least `b` and at most twice it, eight gains, weighted,
the most. -/
theorem doubling_top {a b : Nat} (falls : b ≤ a) (gentle : a ≤ 2 * b) :
    ∀ z, b * (z + doubling z) + a * 8 ≤ b * (8 + doubling 8) + a * z :=
  fun z => match Nat.lt_or_ge 8 z with
  | .inl over => by
    rw [doubling_high over, doubling_low (Nat.le_refl 8), Nat.add_comm (b * (8 + 8))]
    exact Nat.add_le_add (Nat.mul_le_mul_right z falls)
      (Nat.le_trans (Nat.mul_le_mul_right 8 gentle) (Nat.le_of_eq (twice_mul b 8)))
  | .inr le => doubling_rises gentle z 8 le (Nat.le_refl 8)

/-- Under the doubling law, where `a` is more than twice `b`, every positive level gains, weighted
by `b` at the next step, less than it does held, weighted by `a`. -/
theorem doubling_outpaced {a b : Nat} (steep : 2 * b < a) :
    ∀ z, 0 < z → b * (z + doubling z) < a * z :=
  fun z pos => match le_dest (show 1 ≤ z from pos) with
  | ⟨i, split⟩ =>
    have scaled : 2 * b * z < a * z := by
      rw [split, Nat.add_comm 1 i, Nat.mul_succ, Nat.mul_succ]
      exact Nat.add_lt_add_of_le_of_lt (Nat.mul_le_mul_right i (Nat.le_of_lt steep)) steep
    match Nat.lt_or_ge 8 z with
    | .inl over => Nat.lt_of_le_of_lt (Nat.le_trans (Nat.le_of_eq (congrArg (b * ·)
        (doubling_high over))) (Nat.le_trans (Nat.mul_le_mul_right z (Nat.le_add_left b b))
          (Nat.le_of_eq (congrArg (· * z) (Nat.two_mul b).symm)))) scaled
    | .inr le => Nat.lt_of_le_of_lt (Nat.le_of_eq ((congrArg (b * ·) (doubling_low le)).trans
        (twice_mul b z).symm)) scaled

/-- Under the doubling law, where `a` is twice `b`, every positive level gains, weighted by `b` at
the next step, at most what it does held, weighted by `a`. -/
theorem doubling_outpaced_le {a b : Nat} (tie : a = 2 * b) :
    ∀ z, 0 < z → b * (z + doubling z) ≤ a * z :=
  fun z _ => match Nat.lt_or_ge 8 z with
  | .inl over => Nat.le_trans (Nat.le_of_eq (congrArg (b * ·) (doubling_high over)))
      (Nat.le_trans (Nat.mul_le_mul_right z (Nat.le_trans (Nat.le_add_left b b)
        (Nat.le_of_eq ((Nat.two_mul b).symm.trans tie.symm)))) (Nat.le_refl _))
  | .inr le => Nat.le_of_eq ((congrArg (b * ·) (doubling_low le)).trans
      ((twice_mul b z).symm.trans (congrArg (· * z) tie.symm)))

/-- A product keeps a strict order under a positive factor. -/
theorem mul_lt_of_pos {a c d : Nat} (lt : a < c) (pos : 0 < d) : a * d < c * d :=
  match le_dest (show 1 ≤ d from pos) with
  | ⟨i, split⟩ => by
    rw [split, Nat.add_comm 1 i, Nat.mul_succ, Nat.mul_succ]
    exact Nat.add_lt_add_of_le_of_lt (Nat.mul_le_mul_right i (Nat.le_of_lt lt)) lt

/-- Under the doubling law, where `a` is at least `b` and less than twice it, eight gains, weighted,
more than every other level. -/
theorem doubling_above {a b : Nat} (falls : b ≤ a) (gentle : a < 2 * b) :
    ∀ z, z ≠ 8 → b * (z + doubling z) + a * 8 < b * (8 + doubling 8) + a * z :=
  fun z other => match Nat.lt_or_ge 8 z with
  | .inl over => by
    rw [doubling_high over, doubling_low (Nat.le_refl 8), Nat.add_comm (b * (8 + 8))]
    exact Nat.add_lt_add_of_le_of_lt (Nat.mul_le_mul_right z falls)
      (Nat.lt_of_lt_of_le (mul_lt_of_pos gentle (Nat.succ_pos 7)) (Nat.le_of_eq (twice_mul b 8)))
  | .inr le => match Nat.lt_or_ge z 8 with
    | .inl lt => doubling_rises_strictly gentle z 8 lt (Nat.le_refl 8)
    | .inr ge => absurd (Nat.le_antisymm le ge) other

/-- **The doubling witness: rebuilding from below.** A source doubling up to eight, from one, with
capacity sixteen, and the order by what the taker draws over `n + 3` steps, the draw of the step
from `t` weighted by `w t`. Two rebuilding steps lie below eight: one reaches two, the next four.
Where the weight falls at every step by less than half, `w (t + 1) ≤ w t < 2 w (t + 1)`, the course
rebuilding the source to eight is an optimum, and every optimum draws nothing at the first two
steps, standing at two and then four, stands at eight at every later step to the horizon's last,
and restores the dweller, which needs two, at the first step (`rebuilding_frontier`,
`frontier_rebuilds`, `frontier_rebuilt`, `Web.frontier_rebuilds`): every optimum stands where the
rebuilding course does at every step to the horizon's last. Where it falls exactly twofold, the
rebuilding course and the course ending the source at once are both optima: the strict premise
cannot be dropped. Where it falls more than twofold, every optimum ends the source at once
(`frontier_exhausts`). -/
theorem doubling_rebuilds (n : Nat) (w : Nat → Nat) :
    ((∀ t, t < n + 2 → w (t + 1) ≤ w t ∧ w t < 2 * w (t + 1)) →
      Frontier (OpenCourse doubling 16 1)
        (fun b a => weightedOver w doubling a (n + 2 + 1) < weightedOver w doubling b (n + 2 + 1))
        (rebuilding doubling 8 1 (n + 2)) ∧
      ∀ x, Frontier (OpenCourse doubling 16 1)
        (fun b a => weightedOver w doubling a (n + 2 + 1) < weightedOver w doubling b (n + 2 + 1))
        x →
      x 1 = 2 ∧ x 2 = 4 ∧ (∀ t, 2 ≤ t → t < n + 2 → x (t + 1) = 8) ∧
        x 1 = x 0 + doubling (x 0) ∧ x 2 = x 1 + doubling (x 1) ∧
        (web (onSource x)).RestoredWithin 1 0 .dweller .source) ∧
    ((∀ t, t < n + 2 → w t = 2 * w (t + 1)) →
      Frontier (OpenCourse doubling 16 1)
        (fun b a => weightedOver w doubling a (n + 2 + 1) < weightedOver w doubling b (n + 2 + 1))
        (rebuilding doubling 8 1 (n + 2)) ∧
      Frontier (OpenCourse doubling 16 1)
        (fun b a => weightedOver w doubling a (n + 2 + 1) < weightedOver w doubling b (n + 2 + 1))
        (holding 1 0 (n + 2))) ∧
    ((∀ t, t < n + 2 → 2 * w (t + 1) < w t) →
      ∀ x, Frontier (OpenCourse doubling 16 1)
        (fun b a => weightedOver w doubling a (n + 2 + 1) < weightedOver w doubling b (n + 2 + 1))
        x →
      ∀ t, t < n + 2 → x (t + 1) = 0) :=
  ⟨fun gentle =>
    have rises := fun t lt => doubling_rises (Nat.le_of_lt (gentle t lt).2)
    have strictly := fun t lt => doubling_rises_strictly (gentle t lt).2
    have top := fun t lt => doubling_top (gentle t lt).1 (Nat.le_of_lt (gentle t lt).2)
    ⟨rebuilding_frontier (Nat.succ_le_succ (Nat.zero_le 7)) doubling_grows rises top
      (Nat.le_refl 16) (Nat.zero_le 16),
     fun x front =>
      have both := Web.frontier_rebuilds (W := web (onSource x)) (c := Place.source)
        (fun _ _ less => less) (Nat.succ_le_succ (Nat.zero_le 7)) doubling_grows rises strictly top
        (Nat.le_refl 16) (Nat.zero_le 16) front
      have first := both.1 0 (Nat.succ_pos (n + 1)) (show 2 < 8 from by decide)
      have second := both.1 1 (Nat.succ_lt_succ (Nat.succ_pos n)) (show 4 < 8 from by decide)
      have rebuilt := frontier_rebuilt (fun _ _ less => less) (Nat.succ_le_succ (Nat.zero_le 7))
        doubling_grows rises (fun t lt => doubling_above (gentle t lt).1 (gentle t lt).2)
        (Nat.le_refl 16) (Nat.zero_le 16) front
      ⟨first.1, second.1, fun t two lt => match le_dest two with
        | ⟨i, split⟩ => rebuilt t lt (by
          rw [split, Nat.add_right_comm]
          exact rise_stays (j := 3) rfl i),
       first.2, second.2,
       both.2 .dweller 0 (Nat.succ_pos (n + 1)) (show 2 < 8 from by decide) (Nat.le_refl 2)⟩⟩,
   fun tie =>
    have gentle : ∀ t, t < n + 2 → w t ≤ 2 * w (t + 1) := fun t lt => Nat.le_of_eq (tie t lt)
    have falls : ∀ t, t < n + 2 → w (t + 1) ≤ w t := fun t lt =>
      Nat.le_trans (Nat.le_add_right _ _)
        (Nat.le_of_eq ((Nat.two_mul _).symm.trans (tie t lt).symm))
    ⟨rebuilding_frontier (Nat.succ_le_succ (Nat.zero_le 7)) doubling_grows
      (fun t lt => doubling_rises (gentle t lt))
      (fun t lt => doubling_top (falls t lt) (gentle t lt))
      (Nat.le_refl 16) (Nat.zero_le 16),
     exhausting_frontier (fun t lt => doubling_outpaced_le (tie t lt)) (by decide) (Nat.zero_le 16)
      (Nat.succ_pos (n + 1))⟩,
   fun steep x front => Optimum.frontier_exhausts (fun _ _ less => less)
    (fun t lt => doubling_outpaced (steep t lt)) (by decide) (Nat.zero_le 16) (Nat.succ_pos (n + 1))
    front⟩

end Holding

end Optimum

/-! ## Others drawing first

Under a law of what stands, whatever else draws from a base enters only through that law. Where at
each step others first draw from the level a far-sighted optimizer left, and what remains renews,
what stands for the optimizer is what remains with its renewal. Where they draw at least what that
remainder renews, nothing left stands higher at the next step: every order weighting later draws
less, however slightly, has every optimum end the base at once; where they draw more, so does every
order weighting no later step more. Alone, the same optimizer under the same weighting may rebuild
the base. The others' draws are supplied as a rule reading the level; whether that rule is itself
a best response is not derived. -/

namespace Optimum

namespace Next

variable {w : Nat → Nat} {G : Nat → Nat → Nat} {k s n : Nat}

/-- What stands at the step from `t` where, of the level `z` there, others first leave `K t z` and
that renews by `R`. -/
def leftBy (R : Nat → Nat) (K : Nat → Nat → Nat) (t z : Nat) : Nat := K t z + R (K t z)

/-- **Where nothing left stands higher at the next step, every falling weighting ends the base at
once.** Where at each step to the `n`-th what stands at a level is at most the level, and the
weighting falls at every step, over a horizon of at least two steps, with a capacity covering what
stands at the start and what stands at nothing, every optimum of every order on the courses open
from the start that rises with the weighted draw across `n + 1` steps stands at nothing at every
step from the first to the `n`-th. -/
theorem frontier_ends_of_le {better : (Nat → Nat) → (Nat → Nat) → Prop}
    (rising : ∀ a b, weighted w G a (n + 1) < weighted w G b (n + 1) → better b a)
    (atMost : ∀ t, t < n → ∀ z, G (t + 1) z ≤ z) (falls : ∀ t, t < n → w (t + 1) < w t)
    (drawsDown : G 0 s ≤ k) (rests : ∀ t, G t 0 ≤ k) (long : 0 < n) {x : Nat → Nat}
    (front : Frontier (Open G k s) better x) : ∀ t, t < n → x (t + 1) = 0 :=
  Next.frontier_exhausts rising (fun t lt z pos => Nat.lt_of_le_of_lt
      (Nat.mul_le_mul_left (w (t + 1)) (atMost t lt z)) (Holding.mul_lt_of_pos (falls t lt) pos))
    drawsDown rests long front

/-- **Where nothing left stands as high at the next step, every weighting rising at no step ends
the base at once.** Where at each step to the `n`-th what stands at every positive level is less
than the level, and the weighting is positive and rises at no step, over a horizon of at least two
steps, with a capacity covering what stands at the start and what stands at nothing, every optimum
of every order on the courses open from the start that rises with the weighted draw across `n + 1`
steps stands at nothing at every step from the first to the `n`-th. -/
theorem frontier_ends_of_lt {better : (Nat → Nat) → (Nat → Nat) → Prop}
    (rising : ∀ a b, weighted w G a (n + 1) < weighted w G b (n + 1) → better b a)
    (below : ∀ t, t < n → ∀ z, 0 < z → G (t + 1) z < z) (falls : ∀ t, t < n → w (t + 1) ≤ w t)
    (pos : ∀ t, t < n → 0 < w t) (drawsDown : G 0 s ≤ k) (rests : ∀ t, G t 0 ≤ k) (long : 0 < n)
    {x : Nat → Nat} (front : Frontier (Open G k s) better x) : ∀ t, t < n → x (t + 1) = 0 :=
  Next.frontier_exhausts rising (fun t lt z zpos => Nat.lt_of_le_of_lt
      (Nat.mul_le_mul_right (G (t + 1) z) (falls t lt))
      (Nat.lt_of_le_of_lt (Nat.le_of_eq (Nat.mul_comm _ _))
        (Nat.lt_of_lt_of_le (Holding.mul_lt_of_pos (below t lt z zpos) (pos t lt))
          (Nat.le_of_eq (Nat.mul_comm _ _)))))
    drawsDown rests long front

/-- **Others drawing first at least the renewal of what they leave end the base under every falling
weighting.** Where at each step to the `n`-th others first leave of every level `z` at most what,
with its renewal by `R`, is `z`, and the weighting falls at every step, over a horizon of at least
two steps, with a capacity covering what stands at the start and what stands at nothing, every
optimum of every order rising with the optimizer's weighted draw stands at nothing at every step
from the first to the `n`-th. -/
theorem frontier_ends_drawn_first {R : Nat → Nat} {K : Nat → Nat → Nat}
    {better : (Nat → Nat) → (Nat → Nat) → Prop}
    (rising : ∀ a b, weighted w (leftBy R K) a (n + 1) < weighted w (leftBy R K) b (n + 1) →
      better b a)
    (draws : ∀ t, t < n → ∀ z, K (t + 1) z + R (K (t + 1) z) ≤ z)
    (falls : ∀ t, t < n → w (t + 1) < w t) (drawsDown : leftBy R K 0 s ≤ k)
    (rests : ∀ t, leftBy R K t 0 ≤ k) (long : 0 < n) {x : Nat → Nat}
    (front : Frontier (Open (leftBy R K) k s) better x) : ∀ t, t < n → x (t + 1) = 0 :=
  Next.frontier_ends_of_le rising draws falls drawsDown rests long front

/-- **Others drawing first more than the renewal of what they leave end the base under every
weighting rising at no step.** Where at each step to the `n`-th others first leave of every positive
level `z` less than what, with its renewal by `R`, is `z`, and the weighting is positive and rises
at no step, under the remaining premises of `frontier_ends_drawn_first`, every optimum stands at
nothing at every step from the first to the `n`-th: even an order weighting every step alike. -/
theorem frontier_ends_drawn_more {R : Nat → Nat} {K : Nat → Nat → Nat}
    {better : (Nat → Nat) → (Nat → Nat) → Prop}
    (rising : ∀ a b, weighted w (leftBy R K) a (n + 1) < weighted w (leftBy R K) b (n + 1) →
      better b a)
    (draws : ∀ t, t < n → ∀ z, 0 < z → K (t + 1) z + R (K (t + 1) z) < z)
    (falls : ∀ t, t < n → w (t + 1) ≤ w t) (pos : ∀ t, t < n → 0 < w t)
    (drawsDown : leftBy R K 0 s ≤ k) (rests : ∀ t, leftBy R K t 0 ≤ k) (long : 0 < n)
    {x : Nat → Nat} (front : Frontier (Open (leftBy R K) k s) better x) :
    ∀ t, t < n → x (t + 1) = 0 :=
  Next.frontier_ends_of_lt rising draws falls pos drawsDown rests long front

end Next

end Optimum

namespace Web

namespace Next

open Optimum.Next

variable {W : Web F C} {c : C} {f : F} {w : Nat → Nat} {k s n : Nat}
  {better : (Nat → Nat) → (Nat → Nat) → Prop}

/-- **Others drawing first at least the renewal of what they leave break every dependence on the
condition.** Under the premises of `Optimum.Next.frontier_ends_drawn_first`, every optimum, among
the open courses, of every order rising with the optimizer's weighted draw leaves the condition at
nothing at every step from the first to the `n`-th, and breaks at the first step every dependence on
it with a positive need, met at the start. -/
theorem frontier_ends_drawn_first {R : Nat → Nat} {K : Nat → Nat → Nat}
    (rising : ∀ a b, weighted w (leftBy R K) a (n + 1) < weighted w (leftBy R K) b (n + 1) →
      better b a)
    (draws : ∀ t, t < n → ∀ z, K (t + 1) z + R (K (t + 1) z) ≤ z)
    (falls : ∀ t, t < n → w (t + 1) < w t) (drawsDown : leftBy R K 0 s ≤ k)
    (rests : ∀ t, leftBy R K t 0 ≤ k) (long : 0 < n)
    (front : Frontier (Open (leftBy R K) k s) better fun t => W.level t c)
    (depends : W.requires 0 f c) (met : W.need 0 f c ≤ W.level 0 c) (needs : 0 < W.need 0 f c) :
    W.Broken 0 f c ∧ ∀ t, t < n → W.level (t + 1) c = 0 :=
  have ended := Optimum.Next.frontier_ends_drawn_first rising draws falls drawsDown rests long front
  ⟨⟨depends, met, Nat.lt_of_le_of_lt (Nat.le_of_eq (ended 0 long)) needs⟩, ended⟩

/-- **Others drawing first more than the renewal of what they leave break every dependence on the
condition under every weighting rising at no step.** Under the premises of
`Optimum.Next.frontier_ends_drawn_more`, every optimum, among the open courses, of every order
rising with the optimizer's weighted draw leaves the condition at nothing at every step from the
first to the `n`-th, and breaks at the first step every dependence on it with a positive need, met
at the start. -/
theorem frontier_ends_drawn_more {R : Nat → Nat} {K : Nat → Nat → Nat}
    (rising : ∀ a b, weighted w (leftBy R K) a (n + 1) < weighted w (leftBy R K) b (n + 1) →
      better b a)
    (draws : ∀ t, t < n → ∀ z, 0 < z → K (t + 1) z + R (K (t + 1) z) < z)
    (falls : ∀ t, t < n → w (t + 1) ≤ w t) (pos : ∀ t, t < n → 0 < w t)
    (drawsDown : leftBy R K 0 s ≤ k) (rests : ∀ t, leftBy R K t 0 ≤ k) (long : 0 < n)
    (front : Frontier (Open (leftBy R K) k s) better fun t => W.level t c)
    (depends : W.requires 0 f c) (met : W.need 0 f c ≤ W.level 0 c) (needs : 0 < W.need 0 f c) :
    W.Broken 0 f c ∧ ∀ t, t < n → W.level (t + 1) c = 0 :=
  have ended := Optimum.Next.frontier_ends_drawn_more rising draws falls pos drawsDown rests long
    front
  ⟨⟨depends, met, Nat.lt_of_le_of_lt (Nat.le_of_eq (ended 0 long)) needs⟩, ended⟩

end Next

end Web

namespace Optimum

namespace Holding

open Diversion

/-- Half a level, rounded down. -/
def halved : Nat → Nat
  | 0 => 0
  | 1 => 0
  | z + 2 => halved z + 1

/-- Twice half a level is at most the level. -/
theorem halved_twice : ∀ z, halved z + halved z ≤ z
  | 0 => Nat.le_refl 0
  | 1 => Nat.zero_le 1
  | z + 2 => Nat.succ_le_succ (Nat.le_trans (Nat.le_of_eq (Nat.succ_add (halved z) (halved z)))
      (Nat.succ_le_succ (halved_twice z)))

/-- Half a level with its doubling renewal is at most the level: where others first draw all but
half of a level, rounded down, what is left renews at most to the level. -/
theorem halved_left_le (z : Nat) : halved z + doubling (halved z) ≤ z :=
  match Nat.lt_or_ge 8 (halved z) with
  | .inl over => Nat.le_trans (Nat.le_of_eq (doubling_high over))
      (Nat.le_trans (Nat.le_add_right _ _) (halved_twice z))
  | .inr le => Nat.le_trans (Nat.le_of_eq (doubling_low le)) (halved_twice z)

/-- Half a positive level is less than the level. -/
theorem halved_lt {z : Nat} (pos : 0 < z) : halved z < z :=
  match Nat.eq_zero_or_pos (halved z) with
  | .inl zero => Nat.lt_of_le_of_lt (Nat.le_of_eq zero) pos
  | .inr half => Nat.lt_of_lt_of_le (Nat.lt_add_of_pos_right half) (halved_twice z)

/-- A quarter of a positive level with its doubling renewal is less than the level: where others
first draw all but a quarter of a level, what is left renews to less than the level. -/
theorem quartered_left_lt {z : Nat} (pos : 0 < z) :
    halved (halved z) + doubling (halved (halved z)) < z :=
  Nat.lt_of_le_of_lt (halved_left_le (halved z)) (halved_lt pos)

/-- What stands where others first draw from a doubling source all but half of the level, rounded
down. -/
def halfLeft : Nat → Nat → Nat := Next.leftBy doubling fun _ z => halved z

/-- What stands where others first draw from a doubling source all but a quarter of the level,
rounded down. -/
def quarterLeft : Nat → Nat → Nat := Next.leftBy doubling fun _ z => halved (halved z)

/-- Weights falling by one a step from `n + 4` fall at every step to the `n + 2`-th, by less than
half. -/
theorem linear_falls (n : Nat) :
    ∀ t, t < n + 2 → n + 4 - (t + 1) < n + 4 - t ∧ n + 4 - t < 2 * (n + 4 - (t + 1)) :=
  fun t lt => match le_dest (show t + 1 ≤ n + 2 from lt) with
  | ⟨j, split⟩ =>
    have whole : n + 4 = t + 1 + (j + 2) :=
      (congrArg (· + 2) split).trans (Nat.add_assoc (t + 1) j 2)
    have next : n + 4 - (t + 1) = j + 2 := by
      rw [whole]
      exact Naturals.add_sub_cancel_left (t + 1) (j + 2)
    have here : n + 4 - t = 1 + (j + 2) := by
      rw [whole, Nat.add_assoc t 1 (j + 2)]
      exact Naturals.add_sub_cancel_left t (1 + (j + 2))
    by
      rw [next, here]
      exact ⟨Nat.lt_of_lt_of_le (Nat.lt_succ_self (j + 2)) (Nat.le_of_eq (Nat.add_comm (j + 2) 1)),
        Nat.lt_of_lt_of_le (Nat.add_lt_add_right (Nat.succ_lt_succ (Nat.succ_pos j)) (j + 2))
          (Nat.le_of_eq (Nat.two_mul (j + 2)).symm)⟩

/-- **The doubling witness: alone every optimum rebuilds; with others drawing first, every optimum
ends it.** A source doubling up to eight, from two, with capacity sixteen, and the order by what the
taker draws over `n + 3` steps, the draw of the step from `t` weighted by `w t`. Where the weight
rises at no step and falls by less than half, `w (t + 1) ≤ w t < 2 w (t + 1)` (equal positive
weights among them): alone, every optimum draws nothing at the first step, standing at four, and stands at
eight at every later step to the horizon's last (`frontier_rebuilds`, `frontier_rebuilt`); with
others first drawing all but a quarter of what the taker leaves, every optimum of the same order
stands at nothing at every step and breaks the dweller, which needs two, at the first step
(`Web.Next.frontier_ends_drawn_more`). Where the weight falls at every step, however slightly, with
others first drawing all but half, every optimum ends it and breaks the dweller
(`Web.Next.frontier_ends_drawn_first`); weights falling by one a step from `n + 4` fall at every
step and by less than half (`linear_falls`), so the same order rebuilds the source alone. Where the weights are equal, with others first
drawing all but half, the course ending the source at once and the course holding it at two are both
optima: the strict fall in `Next.frontier_ends_of_le` cannot be dropped. -/
theorem doubling_drawn_first (n : Nat) (w : Nat → Nat) :
    ((∀ t, t < n + 2 → w (t + 1) ≤ w t ∧ w t < 2 * w (t + 1)) →
      (∀ x, Frontier (OpenCourse doubling 16 2)
          (fun b a => weightedOver w doubling a (n + 2 + 1) < weightedOver w doubling b (n + 2 + 1))
          x →
        x 1 = 4 ∧ x 1 = x 0 + doubling (x 0) ∧ ∀ t, 1 ≤ t → t < n + 2 → x (t + 1) = 8) ∧
      ∀ x, Frontier (Next.Open quarterLeft 16 2)
          (fun b a => Next.weighted w quarterLeft a (n + 2 + 1) <
            Next.weighted w quarterLeft b (n + 2 + 1)) x →
        (web (onSource x)).Broken 0 .dweller .source ∧ ∀ t, t < n + 2 → x (t + 1) = 0) ∧
    ((∀ t, t < n + 2 → w (t + 1) < w t) →
      ∀ x, Frontier (Next.Open halfLeft 16 2)
          (fun b a => Next.weighted w halfLeft a (n + 2 + 1) <
            Next.weighted w halfLeft b (n + 2 + 1)) x →
        (web (onSource x)).Broken 0 .dweller .source ∧ ∀ t, t < n + 2 → x (t + 1) = 0) ∧
    ((∀ t, t < n + 2 → w (t + 1) = w t) →
      Frontier (Next.Open halfLeft 16 2)
          (fun b a => Next.weighted w halfLeft a (n + 2 + 1) <
            Next.weighted w halfLeft b (n + 2 + 1)) (holding 2 0 (n + 2)) ∧
      Frontier (Next.Open halfLeft 16 2)
          (fun b a => Next.weighted w halfLeft a (n + 2 + 1) <
            Next.weighted w halfLeft b (n + 2 + 1)) (holding 2 2 (n + 2))) :=
  ⟨fun gentle =>
    have rises := fun t lt => doubling_rises (Nat.le_of_lt (gentle t lt).2)
    ⟨fun x front =>
      have first := frontier_rebuilds (fun _ _ less => less) (Nat.succ_le_succ (Nat.succ_le_succ
        (Nat.zero_le 6))) doubling_grows rises (fun t lt => doubling_rises_strictly (gentle t lt).2)
        (fun t lt => doubling_top (gentle t lt).1 (Nat.le_of_lt (gentle t lt).2))
        (Nat.le_refl 16) (Nat.zero_le 16) front 0 (Nat.succ_pos (n + 1)) (show 4 < 8 from by decide)
      have rebuilt := frontier_rebuilt (fun _ _ less => less) (Nat.succ_le_succ (Nat.succ_le_succ
        (Nat.zero_le 6))) doubling_grows rises
        (fun t lt => doubling_above (gentle t lt).1 (gentle t lt).2)
        (Nat.le_refl 16) (Nat.zero_le 16) front
      ⟨first.1, first.2, fun t one lt => match le_dest one with
        | ⟨i, split⟩ => rebuilt t lt (by
          rw [split, Nat.add_right_comm]
          exact rise_stays (j := 2) rfl i)⟩,
     fun x front => Web.Next.frontier_ends_drawn_more (W := web (onSource x)) (c := Place.source)
      (f := Formation.dweller) (w := w) (k := 16) (s := 2) (n := n + 2) (R := doubling)
      (K := fun _ z => halved (halved z)) (fun _ _ less => less)
      (fun _ _ _ pos => quartered_left_lt pos) (fun t lt => (gentle t lt).1)
      (fun t lt => Nat.lt_of_lt_of_le (pos_of_lt_two_mul (gentle t lt).2) (gentle t lt).1)
      (by decide) (fun _ => Nat.zero_le 16) (Nat.succ_pos (n + 1)) front trivial
      (Nat.le_of_eq front.1.1.symm) (Nat.succ_pos 1)⟩,
   fun falls x front => Web.Next.frontier_ends_drawn_first (W := web (onSource x))
    (c := Place.source) (f := Formation.dweller) (w := w) (k := 16) (s := 2) (n := n + 2)
    (R := doubling) (K := fun _ z => halved z) (fun _ _ less => less)
    (fun _ _ z => halved_left_le z) falls (by decide)
    (fun _ => Nat.zero_le 16) (Nat.succ_pos (n + 1)) front trivial (Nat.le_of_eq front.1.1.symm)
    (Nat.succ_pos 1),
   fun same =>
    ⟨Next.exhausting_frontier (G := halfLeft)
      (fun t lt z _ => Nat.le_trans (Nat.mul_le_mul_left (w (t + 1)) (halved_left_le z))
        (Nat.le_of_eq (congrArg (· * z) (same t lt))))
      (by decide) (fun _ => Nat.zero_le 16) (Nat.succ_pos (n + 1)),
     Next.holding_frontier (G := halfLeft) (y := 2)
      (fun t lt z => by
        rw [same t lt]
        exact Nat.le_trans (Nat.add_le_add_right (Nat.mul_le_mul_left (w t) (halved_left_le z)) _)
          (Nat.le_of_eq (Nat.add_comm _ _)))
      (Nat.le_refl 2) (by decide) (fun _ => Nat.le_refl 2) (fun _ => (by decide : 2 ≤ 16))
      (fun _ => Nat.zero_le 16) (Nat.succ_pos (n + 1))⟩⟩

/-- **The same order, alone and with others drawing first: the linear case.** With weights falling
by one a step from `n + 4`, alone every optimum of the taker's weighted order rebuilds the doubling
source to four and then eight; where others first draw all but half of what the taker leaves, every
optimum of the same order ends it at once and breaks the dweller (`doubling_drawn_first`,
`linear_falls`). -/
theorem doubling_drawn_first_linear (n : Nat) :
    (∀ x, Frontier (OpenCourse doubling 16 2)
        (fun b a => weightedOver (fun t => n + 4 - t) doubling a (n + 2 + 1) <
          weightedOver (fun t => n + 4 - t) doubling b (n + 2 + 1)) x →
      x 1 = 4 ∧ ∀ t, 1 ≤ t → t < n + 2 → x (t + 1) = 8) ∧
    ∀ x, Frontier (Next.Open halfLeft 16 2)
        (fun b a => Next.weighted (fun t => n + 4 - t) halfLeft a (n + 2 + 1) <
          Next.weighted (fun t => n + 4 - t) halfLeft b (n + 2 + 1)) x →
      (web (onSource x)).Broken 0 .dweller .source ∧ ∀ t, t < n + 2 → x (t + 1) = 0 :=
  have falls := linear_falls n
  ⟨fun x front =>
    have alone := ((doubling_drawn_first n (fun t => n + 4 - t)).1
      (fun t lt => ⟨Nat.le_of_lt (falls t lt).1, (falls t lt).2⟩)).1 x front
    ⟨alone.1, alone.2.2⟩,
   (doubling_drawn_first n (fun t => n + 4 - t)).2.1 fun t lt => (falls t lt).1⟩

end Holding

end Optimum

/-! ## Drawers in turn

Above, others drawing first were supplied as a rule reading the level. Here every drawer ranks
courses. At each step `k` drawers draw in turn: drawer `0` is given the level, drawer `d` leaves of
what it is given `a` at least its floor `low d t a`, what a capacity leaves it, and at most `a`, and
what the last leaves stands at the next step as `G t` of it. Each ranks what it draws over the steps
that remain. A profile revises another where each of its rules, at every step from every level,
leaves what draws its drawer the most against the other profile; a profile is perfect where it
revises itself. One law carries every result: what a best response keeps above its floor returns
to it at least one for one (`kept_returns`). So a drawer leaves its floor wherever what it draws later
does not depend on what it leaves (`at_floor`). Where two drawers have no floor, whatever floors the
others have, nothing any drawer keeps comes back to it: what one of the two leaves passes through the
other, and what any other drawer leaves passes through one of them. So revising from any profile
comes to every drawer leaving its floor, and every perfect profile is the floor profile, which is
perfect; with no floor anywhere, that is drawing everything. -/

namespace Optimum

namespace InTurn

/-- What drawers `d, …, d + c - 1` leave in turn of `b` at step `t`, drawer `d` leaving `rules d t b`
of the `b` it is given. -/
def pass (rules : Nat → Nat → Nat → Nat) (t : Nat) : Nat → Nat → Nat → Nat
  | _, 0, b => b
  | d, c + 1, b => pass rules t (d + 1) c (rules d t b)

/-- What stands at the step after `t`, `k` drawers in turn from the level `z`. -/
def next (G : Nat → Nat → Nat) (rules : Nat → Nat → Nat → Nat) (k t z : Nat) : Nat :=
  G t (pass rules t 0 k z)

/-- What drawer `d` of `k` draws over `j` steps from step `t` at level `z`. -/
def drawn (G : Nat → Nat → Nat) (rules : Nat → Nat → Nat → Nat) (k d : Nat) : Nat → Nat → Nat → Nat
  | 0, _, _ => 0
  | j + 1, t, z => (pass rules t 0 d z - rules d t (pass rules t 0 d z)) +
      drawn G rules k d j (t + 1) (next G rules k t z)

/-- What drawer `d` draws over the `j` steps after step `t`, having left `b` there: the drawers after
it at `t` and every drawer later following `rules`. -/
def later (G : Nat → Nat → Nat) (rules : Nat → Nat → Nat → Nat) (k d j t b : Nat) : Nat :=
  drawn G rules k d j (t + 1) (G t (pass rules t (d + 1) (k - (d + 1)) b))

/-- The levels along a profile of `k` drawers from `s`. -/
def levels (G : Nat → Nat → Nat) (rules : Nat → Nat → Nat → Nat) (k s : Nat) : Nat → Nat
  | 0 => s
  | t + 1 => next G rules k t (levels G rules k s t)

/-- **A revision.** Each rule of `rules'` leaves between its floor and all of what it is given, and
over a horizon of `N` steps, at every step from every level, it leaves what draws its drawer the most
against the profile `rules`: of what drawer `d` is given at `t`, its draw there and what it draws
later. -/
def Revises (G : Nat → Nat → Nat) (low rules rules' : Nat → Nat → Nat → Nat) (k N : Nat) : Prop :=
  (∀ d t a, low d t a ≤ rules' d t a ∧ rules' d t a ≤ a) ∧
  ∀ t j, t + j + 1 = N → ∀ d, d < k → ∀ a b, low d t a ≤ b → b ≤ a →
    a - b + later G rules k d j t b ≤ a - rules' d t a + later G rules k d j t (rules' d t a)

/-- **Perfect over a horizon**: the profile revises itself, every drawer at a best response at every
step from every level, over the steps that remain. -/
def Perfect (G : Nat → Nat → Nat) (low rules : Nat → Nat → Nat → Nat) (k N : Nat) : Prop :=
  Revises G low rules rules k N

/-- **What a best response keeps above its floor returns to it at least one for one.** Of `a`, leaving
`r` draws `a - r` now and `C r` later; where that draws no less than leaving the floor `low ≤ r ≤ a`,
what `r` brings later exceeds what the floor brings by at least what it keeps above the floor. -/
theorem kept_returns {C : Nat → Nat} {a low r : Nat} (floor : low ≤ r) (le : r ≤ a)
    (best : a - low + C low ≤ a - r + C r) : C low + (r - low) ≤ C r := by
  match le_dest floor, le_dest le with
  | ⟨e, hr⟩, ⟨d, ha⟩ =>
    subst ha
    subst hr
    rw [Naturals.add_sub_cancel_left low e]
    rw [Nat.add_assoc low e d, Naturals.add_sub_cancel_left low (e + d),
      ← Nat.add_assoc low e d, Naturals.add_sub_cancel_left (low + e) d] at best
    rw [Nat.add_comm (C low) e]
    exact Naturals.le_of_add_le_add_right (Nat.le_trans
      (Nat.le_of_eq (Nat.add_right_comm e (C low) d))
      (Nat.le_trans best (Nat.le_of_eq (Nat.add_comm d (C (low + e))))))

/-- **Where what it keeps returns less than one for one, a best response leaves its floor.** The strict
reading of `kept_returns`: where every amount above the floor would bring back later less than it
keeps, the best response keeps nothing above the floor. -/
theorem floor_of_less {C : Nat → Nat} {a low r : Nat} (floor : low ≤ r) (le : r ≤ a)
    (best : a - low + C low ≤ a - r + C r) (less : low < r → C r < C low + (r - low)) : r = low :=
  match Nat.lt_or_ge low r with
  | .inl lt => absurd (kept_returns floor le best) (Nat.not_le_of_gt (less lt))
  | .inr ge => Nat.le_antisymm ge floor

/-- **A best response leaves its floor wherever nothing it keeps above the floor returns to it**: the
case of `floor_of_less` in which what it keeps brings back nothing. -/
theorem leaves_floor {C : Nat → Nat} {a low r : Nat} (floor : low ≤ r) (le : r ≤ a)
    (best : a - low + C low ≤ a - r + C r) (same : C r = C low) : r = low :=
  floor_of_less floor le best fun lt =>
    Nat.lt_of_le_of_lt (Nat.le_of_eq same) (Nat.lt_add_of_pos_right (SupportGated.sub_pos_of_lt lt))

variable {G : Nat → Nat → Nat} {low rules rules' : Nat → Nat → Nat → Nat} {k N : Nat}

/-- **A drawer draws to capacity wherever what it draws later does not depend on what it leaves.** In
a revision, where what drawer `d` draws after step `t` is the same whether it leaves its rule's amount
or its floor, its rule leaves the floor. -/
theorem at_floor (rev : Revises G low rules rules' k N) {t j : Nat} (at_ : t + j + 1 = N) {d : Nat}
    (lt : d < k) (a : Nat)
    (same : later G rules k d j t (rules' d t a) = later G rules k d j t (low d t a)) :
    rules' d t a = low d t a :=
  leaves_floor (C := later G rules k d j t) (rev.1 d t a).1 (rev.1 d t a).2
    (rev.2 t j at_ d lt a (low d t a) (Nat.le_refl _) (Nat.le_trans (rev.1 d t a).1 (rev.1 d t a).2)) same

/-- **At the last step every drawer draws to capacity**, nothing being drawn after it. -/
theorem last_at_floor (rev : Revises G low rules rules' k N) {t : Nat} (at_ : t + 1 = N) :
    ∀ d, d < k → ∀ a, rules' d t a = low d t a := fun _ lt a =>
  at_floor rev (j := 0) at_ lt a rfl

/-- Of nothing, drawers who leave at most what they are given leave nothing. -/
theorem pass_zero (leaves : ∀ d t a, rules d t a ≤ a) (t : Nat) : ∀ d c, pass rules t d c 0 = 0
  | _, 0 => rfl
  | d, c + 1 => (congrArg (pass rules t (d + 1) c) (Nat.eq_zero_of_le_zero (leaves d t 0))).trans
      (pass_zero leaves t (d + 1) c)

/-- **Through a drawer that leaves nothing, nothing passes.** Where drawer `u` leaves nothing at `t`,
drawers `d, …, d + c - 1`, `u` among them, leave nothing of whatever they are given. -/
theorem pass_through (leaves : ∀ d t a, rules d t a ≤ a) {t u : Nat} (none : ∀ a, rules u t a = 0) :
    ∀ c d b, d ≤ u → u < d + c → pass rules t d c b = 0
  | 0, d, _, le, lt => absurd (Nat.lt_of_lt_of_le lt (Nat.le_of_eq (Nat.add_zero d))) (Nat.not_lt_of_ge le)
  | c + 1, d, b, le, lt => (Nat.lt_or_ge d u).elim
      (fun dlt => pass_through leaves none c (d + 1) (rules d t b) dlt
        (Nat.lt_of_lt_of_le lt (Nat.le_of_eq (Nat.add_right_comm d 1 c).symm)))
      (fun dge => (congrArg (pass rules t (d + 1) c)
        ((congrArg (fun x => rules x t b) (Nat.le_antisymm le dge)).trans (none b))).trans (pass_zero leaves t (d + 1) c))

/-- **After a drawer that leaves nothing, the others draw nothing.** Where drawer `u` leaves nothing at
every step from `t` to the horizon, every drawer after it draws nothing over the steps that remain. -/
theorem after_draw_nothing (leaves : ∀ d t a, rules d t a ≤ a) {t u : Nat}
    (zero : ∀ s, t ≤ s → s < N → ∀ a, rules u s a = 0) :
    ∀ j, t + j = N → ∀ d, u < d → ∀ w, drawn G rules k d j t w = 0
  | 0, _, _, _, _ => rfl
  | j + 1, at_, d, lt, w => by
    have now : ∀ a, rules u t a = 0 := zero t (Nat.le_refl t)
      (Nat.lt_of_lt_of_le (Nat.lt_add_of_pos_right (Nat.succ_pos j)) (Nat.le_of_eq at_))
    show pass rules t 0 d w - rules d t (pass rules t 0 d w) +
      drawn G rules k d j (t + 1) (next G rules k t w) = 0
    rw [pass_through leaves now d 0 w (Nat.zero_le u) (Nat.lt_of_lt_of_le lt (Nat.le_of_eq (Nat.zero_add d).symm)),
      after_draw_nothing leaves (t := t + 1) (fun s le lt' => zero s (Nat.le_of_succ_le le) lt') j
        ((Nat.add_right_comm t 1 j).trans at_) d lt, Nat.zero_sub]

/-- **A drawer after one that leaves nothing later draws to capacity.** In a revision, where drawer `u`
of the profile revised leaves nothing at every step after `t`, every drawer after `u` leaves its
floor at `t`: nothing it keeps comes back to it. -/
theorem floor_after (rev : Revises G low rules rules' k N) (leaves : ∀ d t a, rules d t a ≤ a) {t j u : Nat}
    (at_ : t + j + 1 = N) (zero : ∀ s, t + 1 ≤ s → s < N → ∀ a, rules u s a = 0) {d : Nat} (lt : u < d)
    (dk : d < k) (a : Nat) : rules' d t a = low d t a :=
  have none := after_draw_nothing (G := G) (k := k) leaves (t := t + 1) zero j ((Nat.add_right_comm t 1 j).trans at_) d lt
  at_floor rev at_ dk a ((none _).trans (none _).symm)

/-- **A drawer before one that leaves nothing draws to capacity.** In a revision, where drawer `w` of
the profile revised leaves nothing at `t`, every drawer before `w` leaves its floor at `t`: what it
keeps passes through `w`. -/
theorem floor_through (rev : Revises G low rules rules' k N) (leaves : ∀ d t a, rules d t a ≤ a) {t j w : Nat}
    (at_ : t + j + 1 = N) (zero : ∀ a, rules w t a = 0) (wk : w < k) {d : Nat} (dw : d < w) (a : Nat) :
    rules' d t a = low d t a :=
  have dk : d < k := Nat.lt_trans dw wk
  have through : ∀ b, pass rules t (d + 1) (k - (d + 1)) b = 0 := fun b =>
    pass_through leaves zero (k - (d + 1)) (d + 1) b dw
      (Nat.lt_of_lt_of_le wk (Nat.le_of_eq (Becoming.add_sub_of_le dk).symm))
  at_floor rev at_ dk a (by
    show drawn G rules k d j (t + 1) (G t (pass rules t (d + 1) (k - (d + 1)) _)) =
      drawn G rules k d j (t + 1) (G t (pass rules t (d + 1) (k - (d + 1)) _))
    rw [through, through])

/-- **Revising from the horizon back, every drawer comes to its floor.** Where two drawers `u < v`
have no floor, along every sequence of profiles each revising the one before over `N` steps, at
every round from `p c` on every drawer leaves its floor at every step of the last `c`, from every
level, whatever profile they started from, where `p` is at least three, or two where `u` is the first
drawer: after `u` nothing returns once `u` leaves nothing later, `u`'s keeping passes through `v`,
and before `u` everything passes through `u`. -/
theorem revisions_reach_floors {fs : Nat → Nat → Nat → Nat → Nat} {u v p : Nat} (uv : u < v) (vk : v < k)
    (freeU : ∀ t a, low u t a = 0) (freeV : ∀ t a, low v t a = 0) (two : 2 ≤ p) (rounds : u = 0 ∨ 3 ≤ p)
    (leaves : ∀ m d t a, fs m d t a ≤ a) (rev : ∀ m, Revises G low (fs m) (fs (m + 1)) k N) :
    ∀ c t, t + c = N → ∀ m, p * c ≤ m → ∀ s, t ≤ s → s < N → ∀ d, d < k → ∀ a, fs m d s a = low d s a
  | 0, _, at_, _, _, _, le, lt => absurd (Nat.lt_of_lt_of_le lt (Nat.le_of_eq at_.symm))
      (Nat.not_lt_of_ge le)
  | c + 1, t, at_, m, enough, s, le, lt =>
    have here : t + c + 1 = N := (Nat.add_assoc t c 1).trans at_
    have after : t + 1 + c = N := (Nat.add_right_comm t 1 c).trans here
    have later_ := revisions_reach_floors uv vk freeU freeV two rounds leaves rev c (t + 1) after
    have uk : u < k := Nat.lt_trans uv vk
    have uLater : ∀ m', p * c ≤ m' → ∀ s', t + 1 ≤ s' → s' < N → ∀ a, fs m' u s' a = 0 :=
      fun m' big s' le' lt' a => (later_ m' big s' le' lt' u uk a).trans (freeU s' a)
    -- From round `p c + 1` on, every drawer after `u` leaves its floor at `t`.
    have stageA : ∀ m', p * c + 1 ≤ m' → ∀ d, u < d → d < k → ∀ a, fs m' d t a = low d t a :=
      fun m' big _ ud dk a => match m', big with
      | m'' + 1, big => floor_after (rev m'') (leaves m'') here (uLater m'' (Nat.le_of_succ_le_succ big)) ud dk a
    -- From round `p c + 2` on, `u` leaves nothing at `t`.
    have stageB : ∀ m', p * c + 2 ≤ m' → ∀ a, fs m' u t a = 0 := fun m' big a => match m', big with
      | m'' + 1, big =>
        (floor_through (rev m'') (leaves m'') here
          (fun b => (stageA m'' (Nat.le_of_succ_le_succ big) v uv vk b).trans (freeV t b)) vk uv a).trans (freeU t a)
    -- From round `p c + 3` on, every drawer before `u` leaves its floor at `t`.
    have stageC : ∀ m', p * c + 3 ≤ m' → ∀ d, d < u → ∀ a, fs m' d t a = low d t a :=
      fun m' big _ du a => match m', big with
      | m'' + 1, big => floor_through (rev m'') (leaves m'') here (stageB m'' (Nat.le_of_succ_le_succ big)) uk du a
    have full : p * (c + 1) = p * c + p := Nat.mul_succ p c
    match Nat.lt_or_ge t s with
    | .inl later' => later_ m (Nat.le_trans (Nat.mul_le_mul_left p (Nat.le_succ c)) enough) s later' lt
    | .inr before =>
      have same : s = t := Nat.le_antisymm before le
      fun d dk a => same ▸ match Nat.lt_trichotomy d u with
        | .inr (.inr ud) => stageA m (Nat.le_trans (Nat.add_le_add_left (Nat.le_trans (Nat.le_succ 1) two) _)
            (Nat.le_trans (Nat.le_of_eq full.symm) enough)) d ud dk a
        | .inr (.inl du) => (congrArg (fun x => fs m x t a) du).trans ((stageB m (Nat.le_trans
            (Nat.add_le_add_left two _) (Nat.le_trans (Nat.le_of_eq full.symm) enough)) a).trans
            ((freeU t a).symm.trans (congrArg (fun x => low x t a) du.symm)))
        | .inl du => match rounds with
          | .inl zero => absurd (zero ▸ du) (Nat.not_lt_zero d)
          | .inr three => stageC m (Nat.le_trans (Nat.add_le_add_left three _)
              (Nat.le_trans (Nat.le_of_eq full.symm) enough)) d du a

/-- **Where two drawers have no floor, every perfect profile is the floor profile.** Along every profile
perfect over `N` steps in which two drawers have no floor, whatever floors the others have, every
drawer leaves exactly its floor at every step before the horizon, from every level: a perfect profile
is its own sequence of revisions. With no floor anywhere every drawer leaves nothing. -/
theorem perfect_at_floors {u v : Nat} (uv : u < v) (vk : v < k) (freeU : ∀ t a, low u t a = 0)
    (freeV : ∀ t a, low v t a = 0) (perfect : Perfect G low rules k N) {t : Nat} (before : t < N) :
    ∀ d, d < k → ∀ a, rules d t a = low d t a :=
  revisions_reach_floors (fs := fun _ => rules) (p := 3) uv vk freeU freeV (Nat.le_succ 2) (.inr (Nat.le_refl 3))
    (fun _ d t a => (perfect.1 d t a).2) (fun _ => perfect) N 0 (Nat.zero_add N) (3 * N) (Nat.le_refl _) t
    (Nat.zero_le t) before

/-- **Where a drawer leaves nothing, the base stands at what stands at nothing**, from the first step
to the `N`-th. -/
theorem levels_through (leaves : ∀ d t a, rules d t a ≤ a) {u : Nat} (uk : u < k)
    (zero : ∀ t, t < N → ∀ a, rules u t a = 0) (s : Nat) {t : Nat} (before : t < N) :
    levels G rules k s (t + 1) = G t 0 :=
  congrArg (G t) (pass_through leaves (zero t before) k 0 _ (Nat.zero_le u)
    (Nat.lt_of_lt_of_le uk (Nat.le_of_eq (Nat.zero_add k).symm)))

/-- **Where two drawers have no floor, leaving the floor is perfect.** -/
theorem floors_perfect {u v : Nat} (uv : u < v) (vk : v < k) (floors : ∀ d t a, low d t a ≤ a)
    (freeU : ∀ t a, low u t a = 0) (freeV : ∀ t a, low v t a = 0) (N : Nat) : Perfect G low low k N :=
  ⟨fun d t a => ⟨Nat.le_refl _, floors d t a⟩, fun t j at_ d dk a b floor _ =>
    have uk : u < k := Nat.lt_trans uv vk
    have same : later G low k d j t b = later G low k d j t (low d t a) :=
      match Nat.lt_trichotomy d u with
      | .inr (.inr ud) =>
        have none := after_draw_nothing (G := G) (k := k) floors (t := t + 1) (N := N)
          (fun s _ _ a' => freeU s a') j ((Nat.add_right_comm t 1 j).trans at_) d ud
        (none _).trans (none _).symm
      | .inr (.inl du) =>
        have through : ∀ b', pass low t (d + 1) (k - (d + 1)) b' = 0 := fun b' =>
          pass_through floors (freeV t) (k - (d + 1)) (d + 1) b' (Eq.subst (motive := fun x => x < v) du.symm uv)
            (Nat.lt_of_lt_of_le vk (Nat.le_of_eq (Becoming.add_sub_of_le dk).symm))
        by
          show drawn G low k d j (t + 1) (G t (pass low t (d + 1) (k - (d + 1)) b)) =
            drawn G low k d j (t + 1) (G t (pass low t (d + 1) (k - (d + 1)) (low d t a)))
          rw [through, through]
      | .inl du =>
        have through : ∀ b', pass low t (d + 1) (k - (d + 1)) b' = 0 := fun b' =>
          pass_through floors (freeU t) (k - (d + 1)) (d + 1) b' du
            (Nat.lt_of_lt_of_le uk (Nat.le_of_eq (Becoming.add_sub_of_le dk).symm))
        by
          show drawn G low k d j (t + 1) (G t (pass low t (d + 1) (k - (d + 1)) b)) =
            drawn G low k d j (t + 1) (G t (pass low t (d + 1) (k - (d + 1)) (low d t a)))
          rw [through, through]
    Nat.le_trans (Nat.add_le_add_right (sub_le_sub_left_of_le floor a) _)
      (Nat.le_of_eq (congrArg (a - low d t a + ·) same))⟩

/-- The first of `0, …, z` at which `f` is greatest among them. -/
def bestUpTo (f : Nat → Nat) : Nat → Nat
  | 0 => 0
  | z + 1 => if f (bestUpTo f z) < f (z + 1) then z + 1 else bestUpTo f z

theorem bestUpTo_le (f : Nat → Nat) : ∀ z, bestUpTo f z ≤ z
  | 0 => Nat.le_refl 0
  | z + 1 => by
    show (if f (bestUpTo f z) < f (z + 1) then z + 1 else bestUpTo f z) ≤ z + 1
    exact if h : f (bestUpTo f z) < f (z + 1) then by rw [if_pos h]; exact Nat.le_refl _
      else by rw [if_neg h]; exact Nat.le_succ_of_le (bestUpTo_le f z)

/-- **The greatest of finitely many.** No value of `f` at `0, …, z` exceeds its value at `bestUpTo f z`. -/
theorem bestUpTo_max (f : Nat → Nat) : ∀ z a, a ≤ z → f a ≤ f (bestUpTo f z)
  | 0, a, le => Nat.le_of_eq (congrArg f (Nat.le_antisymm le (Nat.zero_le a)))
  | z + 1, a, le => by
    show f a ≤ f (if f (bestUpTo f z) < f (z + 1) then z + 1 else bestUpTo f z)
    exact if h : f (bestUpTo f z) < f (z + 1) then by
        rw [if_pos h]
        exact match le_or_eq_succ le with
          | .inl earlier => Nat.le_of_lt (Nat.lt_of_le_of_lt (bestUpTo_max f z a earlier) h)
          | .inr last => Nat.le_of_eq (congrArg f last)
      else by
        rw [if_neg h]
        exact match le_or_eq_succ le with
          | .inl earlier => bestUpTo_max f z a earlier
          | .inr last => Nat.le_trans (Nat.le_of_eq (congrArg f last)) (Nat.ge_of_not_lt h)

/-- **The greatest from a floor.** No value of `f` between `low` and `a` exceeds its value at the
first amount from `low` up at which it is greatest. -/
theorem best_from (f : Nat → Nat) {low a b : Nat} (floor : low ≤ b) (le : b ≤ a) :
    f b ≤ f (low + bestUpTo (fun i => f (low + i)) (a - low)) :=
  Nat.le_trans (Nat.le_of_eq (congrArg f (Becoming.add_sub_of_le floor)).symm)
    (bestUpTo_max (fun i => f (low + i)) (a - low) (b - low) (Nat.sub_le_sub_right le low))

/-- **The revision of a profile**: of what drawer `d` is given at `t`, the first amount from its floor
up that draws it the most against the profile over the steps that remain. -/
def revise (G : Nat → Nat → Nat) (low rules : Nat → Nat → Nat → Nat) (k N d t a : Nat) : Nat :=
  low d t a + bestUpTo (fun i => a - (low d t a + i) + later G rules k d (N - t - 1) t (low d t a + i))
    (a - low d t a)

/-- **A revision always exists.** Where every floor is at most what is given, `revise` revises every
profile. -/
theorem revise_revises (floors : ∀ d t a, low d t a ≤ a) (rules : Nat → Nat → Nat → Nat) :
    Revises G low rules (revise G low rules k N) k N :=
  ⟨fun d t a => ⟨Nat.le_add_right _ _, Nat.le_trans (Nat.add_le_add_left (bestUpTo_le _ _) _)
      (Nat.le_of_eq (Becoming.add_sub_of_le (floors d t a)))⟩,
   fun t j at_ d _ a b floor le => by
    have steps : N - t - 1 = j := by rw [← at_, Nat.add_assoc, Naturals.add_sub_cancel_left]; rfl
    have h := best_from (fun b => a - b + later G rules k d (N - t - 1) t b) floor le
    rw [← steps]
    exact h⟩

/-- The profiles of successive revisions from `start`. -/
def revised (G : Nat → Nat → Nat) (low : Nat → Nat → Nat → Nat) (k N : Nat)
    (start : Nat → Nat → Nat → Nat) : Nat → Nat → Nat → Nat → Nat
  | 0 => start
  | m + 1 => revise G low (revised G low k N start m) k N

/-- Every profile revised from one leaving at most what it is given leaves at most what it is given. -/
theorem revised_leaves (floors : ∀ d t a, low d t a ≤ a) {start : Nat → Nat → Nat → Nat}
    (starts : ∀ d t a, start d t a ≤ a) : ∀ i d t a, revised G low k N start i d t a ≤ a
  | 0 => starts
  | i + 1 => fun d t a => ((revise_revises (G := G) (k := k) (N := N) floors (revised G low k N start i)).1 d t a).2

/-- **Revising toward best responses, drawers in turn come to their floors.** Where two drawers `u < v`
have no floor, from every profile leaving at most what it is given, at every round of revision from
`p N` on every drawer leaves its floor at every step before the horizon (`p` at least three, or two
where `u` is the first drawer), and where a drawer leaves nothing the base stands from the first step
at what stands at nothing. -/
theorem revised_at_floors {u v p : Nat} (uv : u < v) (vk : v < k) (floors : ∀ d t a, low d t a ≤ a)
    (freeU : ∀ t a, low u t a = 0) (freeV : ∀ t a, low v t a = 0) (two : 2 ≤ p) (rounds : u = 0 ∨ 3 ≤ p)
    {start : Nat → Nat → Nat → Nat} (starts : ∀ d t a, start d t a ≤ a) {m : Nat} (enough : p * N ≤ m) :
    (∀ t, t < N → ∀ d, d < k → ∀ a, revised G low k N start m d t a = low d t a) ∧
    ∀ s t, t < N → levels G (revised G low k N start m) k s (t + 1) = G t 0 :=
  have leaves := revised_leaves (G := G) (k := k) (N := N) floors starts
  have floorsAt : ∀ t, t < N → ∀ d, d < k → ∀ a, revised G low k N start m d t a = low d t a :=
    fun t lt => revisions_reach_floors (fs := revised G low k N start) uv vk freeU freeV two rounds leaves
      (fun m => revise_revises floors (revised G low k N start m))
      N 0 (Nat.zero_add N) m enough t (Nat.zero_le t) lt
  ⟨floorsAt, fun s _ lt => levels_through (leaves m) (Nat.lt_trans uv vk)
    (fun t lt' a => (floorsAt t lt' u (Nat.lt_trans uv vk) a).trans (freeU t a)) s lt⟩

/-! ### A race for position

Each drawer ranks its position over the steps that remain, not its draw: what it draws counted once
for each of the `k` drawers, against what all of them draw, the count of `Becoming.RelativePosition`
(`n * a p` against `total ps a`) read on the draws. What every drawer drew before is the same
whatever a drawer leaves, so ranking the position over the steps that remain ranks the position.
One law carries the results (`position_keeps_nothing`): where what a drawer keeps comes back to it in
no later draw, what passes on of it is at most it, and all draw no less later for it, a best response
for position keeps nothing, since what it keeps lowers its own count by `k` times that and the count
of all by at most once that. So at the last step every best response draws everything
(`position_last`), with no premise on what stands next; and where what stands from nothing is at most
what stands from anything left (`G t 0 ≤ G t x`) and there are at least two drawers, every perfect
profile draws everything at every step before the horizon (`position_perfect_ends`), the base stands
at what stands from nothing (`position_levels`), and drawing everything is perfect
(`zero_position_perfect`). Each premise binds: with one drawer every profile is perfect
(`position_one`); where something left stops what stands next, drawing everything is not perfect,
and in every perfect profile a drawer given something keeps it, so that what stands next is stopped
before the first drawer draws it (`Stopping`). -/

/-- What all `k` drawers draw over `j` steps from step `t` at level `z`. -/
def drawnAll (G : Nat → Nat → Nat) (rules : Nat → Nat → Nat → Nat) (k j t z : Nat) : Nat :=
  total (steps 0 k) fun e => drawn G rules k e j t z

/-- What all drawers draw from drawer `d` on at step `t` and over the `j` steps after it, where `d` is
given `a` and leaves `b`: `a` less what passes the drawers after `d`, and what all draw later. -/
def whole (G : Nat → Nat → Nat) (rules : Nat → Nat → Nat → Nat) (k d j t a b : Nat) : Nat :=
  a - pass rules t (d + 1) (k - (d + 1)) b +
    drawnAll G rules k j (t + 1) (G t (pass rules t (d + 1) (k - (d + 1)) b))

/-- **A revision for position.** Each rule of `rules'` leaves at most what it is given, and over a
horizon of `N` steps, at every step from every level, it leaves what places its drawer highest
against the profile `rules`: of what drawer `d` is given at `t`, `k` times what it draws there and
later, against what all draw from it on. -/
def RevisesPosition (G : Nat → Nat → Nat) (rules rules' : Nat → Nat → Nat → Nat) (k N : Nat) :
    Prop :=
  (∀ d t a, rules' d t a ≤ a) ∧
  ∀ t j, t + j + 1 = N → ∀ d, d < k → ∀ a b, b ≤ a →
    k * (a - b + later G rules k d j t b) + whole G rules k d j t a (rules' d t a) ≤
      k * (a - rules' d t a + later G rules k d j t (rules' d t a)) + whole G rules k d j t a b

/-- **Perfect for position over a horizon**: the profile revises itself for position. -/
def PerfectPosition (G : Nat → Nat → Nat) (rules : Nat → Nat → Nat → Nat) (k N : Nat) : Prop :=
  RevisesPosition G rules rules k N

/-- **What a drawer keeps for position, it keeps for nothing.** Of `a`, leaving `r` rather than
nothing, where its own later draw is the same, what passes on of `r` is at most `r`, and all draw no
less later: if leaving `r` places the drawer no lower among `k ≥ 2` drawers, `r` is nothing. Keeping
`r` lowers `k` times its own draw by `k r` and what all draw by at most `r`. -/
theorem position_keeps_nothing {k a r own own' all all' through : Nat} (two : 2 ≤ k) (le : r ≤ a)
    (best : k * (a + own) + (a - through + all') ≤ k * (a - r + own') + (a + all))
    (same : own' = own) (within : through ≤ r) (grows : all ≤ all') : r = 0 := by
  match le_dest le with
  | ⟨m, ha⟩ =>
    subst ha
    subst same
    have low : m + all ≤ r + m - through + all' :=
      Nat.add_le_add (Nat.le_trans (Nat.le_of_eq (Naturals.add_sub_cancel_left r m).symm)
        (sub_le_sub_left_of_le within (r + m))) grows
    have split : k * (r + m + own') = k * (m + own') + k * r :=
      (congrArg (k * ·) (Nat.add_assoc r m own')).trans
        ((Nat.left_distrib k r (m + own')).trans (Nat.add_comm _ _))
    have best' : k * (m + own') + (k * r + (r + m - through + all')) ≤
        k * (m + own') + (r + (m + all)) :=
      Nat.le_trans (Nat.le_of_eq ((Nat.add_assoc _ _ _).symm.trans (congrArg (· + _) split.symm)))
        (Nat.le_trans best (Nat.le_of_eq ((congrArg (fun x => k * (x + own') + (r + m + all))
          (Naturals.add_sub_cancel_left r m)).trans
            (congrArg (k * (m + own') + ·) (Nat.add_assoc r m all)))))
    have kept : k * r + (m + all) ≤ r + (m + all) :=
      Nat.le_trans (Nat.add_le_add_left low _) (le_of_add_le_add_right (k * (m + own'))
        (Nat.le_trans (Nat.le_of_eq (Nat.add_comm _ _)) (Nat.le_trans best' (Nat.le_of_eq (Nat.add_comm _ _)))))
    have kr : 2 * r ≤ r := Nat.le_trans (Nat.mul_le_mul_right r two)
      (le_of_add_le_add_right (m + all) kept)
    have rr : r + r ≤ 0 + r := Nat.le_trans (Nat.le_of_eq (Nat.two_mul r).symm)
      (Nat.le_trans kr (Nat.le_of_eq (Nat.zero_add r).symm))
    exact Nat.eq_zero_of_le_zero (le_of_add_le_add_right r rr)

/-- **Drawing everything places a drawer no lower.** Of `a`, leaving `b` rather than nothing, where
its own later draw is the same, what passes on of `b` is at most `b`, and all draw no less later for
`b`, leaving nothing places the drawer among `k ≥ 1` drawers at least as high. -/
theorem position_nothing_best {k a b own all all' through : Nat} (one : 1 ≤ k) (le : b ≤ a)
    (within : through ≤ b) (grows : all ≤ all') :
    k * (a - b + own) + (a + all) ≤ k * (a + own) + (a - through + all') := by
  match le_dest le with
  | ⟨m, ha⟩ =>
    subst ha
    have low : m + all ≤ b + m - through + all' :=
      Nat.add_le_add (Nat.le_trans (Nat.le_of_eq (Naturals.add_sub_cancel_left b m).symm)
        (sub_le_sub_left_of_le within (b + m))) grows
    have split : k * (b + m + own) = k * (m + own) + k * b :=
      (congrArg (k * ·) (Nat.add_assoc b m own)).trans
        ((Nat.left_distrib k b (m + own)).trans (Nat.add_comm _ _))
    have kb : b ≤ k * b := Nat.le_trans (Nat.le_of_eq (Nat.one_mul b).symm)
      (Nat.mul_le_mul_right b one)
    exact Nat.le_trans
      (Nat.le_of_eq (congrArg (fun x => k * (x + own) + (b + m + all))
        (Naturals.add_sub_cancel_left b m)))
      (Nat.le_trans (Nat.add_le_add_left (Nat.le_trans (Nat.le_of_eq (Nat.add_assoc b m all))
          (Nat.add_le_add kb low)) _)
        (Nat.le_of_eq ((Nat.add_assoc _ _ _).symm.trans (congrArg (· + _) split.symm))))

variable {G : Nat → Nat → Nat} {rules rules' : Nat → Nat → Nat → Nat} {k N : Nat}

/-- What passes drawers who leave at most what they are given is at most what they were given. -/
theorem pass_le (leaves : ∀ d t a, rules d t a ≤ a) (t : Nat) : ∀ d c b, pass rules t d c b ≤ b
  | _, 0, _ => Nat.le_refl _
  | d, c + 1, b => Nat.le_trans (pass_le leaves t (d + 1) c (rules d t b)) (leaves d t b)

/-- **Where every drawer draws everything at a step, the first draws the level** and stands at what
stands from nothing after it. -/
theorem drawn_first_none (leaves : ∀ d t a, rules d t a ≤ a) (one : 0 < k) {s : Nat}
    (none : ∀ d, d < k → ∀ a, rules d s a = 0) (j w : Nat) :
    drawn G rules k 0 (j + 1) s w = w + drawn G rules k 0 j (s + 1) (G s 0) := by
  show w - rules 0 s w + drawn G rules k 0 j (s + 1) (G s (pass rules s 0 k w)) = _
  rw [none 0 one w, pass_through leaves (none 0 one) k 0 w (Nat.le_refl 0)
    (Nat.lt_of_lt_of_le one (Nat.le_of_eq (Nat.zero_add k).symm))]
  rfl

/-- **And every other drawer draws nothing there.** -/
theorem drawn_other_none (leaves : ∀ d t a, rules d t a ≤ a) (one : 0 < k) {s : Nat}
    (none : ∀ d, d < k → ∀ a, rules d s a = 0) {e : Nat} (pos : 0 < e) (j w : Nat) :
    drawn G rules k e (j + 1) s w = drawn G rules k e j (s + 1) (G s 0) := by
  show pass rules s 0 e w - rules e s (pass rules s 0 e w) +
    drawn G rules k e j (s + 1) (G s (pass rules s 0 k w)) = _
  rw [pass_through leaves (none 0 one) e 0 w (Nat.le_refl 0)
      (Nat.lt_of_lt_of_le pos (Nat.le_of_eq (Nat.zero_add e).symm)),
    pass_through leaves (none 0 one) k 0 w (Nat.le_refl 0)
      (Nat.lt_of_lt_of_le one (Nat.le_of_eq (Nat.zero_add k).symm)), Nat.zero_sub, Nat.zero_add]

/-- **What all draw from a step at which every drawer draws everything** is the level with what all
draw from what stands from nothing after it. -/
theorem drawnAll_none (leaves : ∀ d t a, rules d t a ≤ a) (one : 0 < k) {s : Nat}
    (none : ∀ d, d < k → ∀ a, rules d s a = 0) (j w : Nat) :
    drawnAll G rules k (j + 1) s w = w + drawnAll G rules k j (s + 1) (G s 0) :=
  match k, one, leaves, none with
  | k' + 1, one, leaves, none => by
    show drawn G rules (k' + 1) 0 (j + 1) s w +
        total (steps 1 k') (fun e => drawn G rules (k' + 1) e (j + 1) s w) =
      w + (drawn G rules (k' + 1) 0 j (s + 1) (G s 0) +
        total (steps 1 k') (fun e => drawn G rules (k' + 1) e j (s + 1) (G s 0)))
    rw [drawn_first_none leaves one none j w, Nat.add_assoc,
      total_congr_on fun e mem => drawn_other_none leaves one none
        (Nat.lt_of_lt_of_le (Nat.zero_lt_one) (between_of_mem_steps mem).1) j w]

/-- **What a drawer after the first draws later is the same whatever it leaves**, where its later
steps begin with every drawer drawing everything, or there are none. -/
theorem later_same (leaves : ∀ d t a, rules d t a ≤ a) (one : 0 < k) {t j d : Nat}
    (next : j = 0 ∨ ∀ d, d < k → ∀ a, rules d (t + 1) a = 0) (pos : 0 < d) (b : Nat) :
    later G rules k d j t b = later G rules k d j t 0 :=
  match j, next with
  | 0, _ => rfl
  | _ + 1, .inl zero => Nat.noConfusion zero
  | j' + 1, .inr held =>
    (drawn_other_none leaves one held pos j' _).trans (drawn_other_none leaves one held pos j' _).symm

/-- **All draw no less later from what stands from more**, where what stands from nothing is least
and the later steps begin with every drawer drawing everything, or there are none. -/
theorem drawnAll_grows (leaves : ∀ d t a, rules d t a ≤ a) (one : 0 < k) {t j : Nat}
    (next : j = 0 ∨ ∀ d, d < k → ∀ a, rules d (t + 1) a = 0) {x y : Nat} (le : G t x ≤ G t y) :
    drawnAll G rules k j (t + 1) (G t x) ≤ drawnAll G rules k j (t + 1) (G t y) :=
  match j, next with
  | 0, _ => Nat.le_refl _
  | _ + 1, .inl zero => Nat.noConfusion zero
  | j' + 1, .inr held => Nat.le_trans (Nat.le_of_eq (drawnAll_none leaves one held j' _))
      (Nat.le_trans (Nat.add_le_add_right le _)
        (Nat.le_of_eq (drawnAll_none leaves one held j' _).symm))

/-- **A step of the race.** In a revision for position among `k ≥ 2` drawers, where drawer `d`'s
later draw is the same whatever it leaves and all draw no less later from what passes on than from
nothing, `d` leaves nothing. -/
theorem position_step (rev : RevisesPosition G rules rules' k N)
    (leaves : ∀ d t a, rules d t a ≤ a) (two : 2 ≤ k) {t j : Nat} (at_ : t + j + 1 = N) {d : Nat}
    (dk : d < k) (a : Nat) (same : ∀ b, later G rules k d j t b = later G rules k d j t 0)
    (grows : ∀ b, drawnAll G rules k j (t + 1) (G t 0) ≤
      drawnAll G rules k j (t + 1) (G t (pass rules t (d + 1) (k - (d + 1)) b))) :
    rules' d t a = 0 := by
  have best := rev.2 t j at_ d dk a 0 (Nat.zero_le a)
  show rules' d t a = 0
  unfold whole at best
  rw [pass_zero leaves t (d + 1) (k - (d + 1))] at best
  exact position_keeps_nothing two (rev.1 d t a) best (same _) (pass_le leaves t _ _ _)
    (grows _)

/-- **At the last step every best response for position draws everything**, among at least two
drawers, whatever stands next. -/
theorem position_last (rev : RevisesPosition G rules rules' k N)
    (leaves : ∀ d t a, rules d t a ≤ a) (two : 2 ≤ k) {t : Nat} (at_ : t + 1 = N) :
    ∀ d, d < k → ∀ a, rules' d t a = 0 := fun _ dk a =>
  position_step (j := 0) rev leaves two at_ dk a (fun _ => rfl) fun _ => Nat.le_refl _

/-- **Racing for position, every perfect profile draws everything.** Among at least two drawers with
no floor, each ranking its position over the steps that remain, where what stands from nothing is at
most what stands from anything left, every profile perfect for position over `N` steps leaves
nothing at every step `t` with `t + c + 1 = N`, from every level: from the horizon back, a drawer
after the first keeps nothing since what it keeps comes back only to others, and then the first
keeps nothing since what it keeps passes to the others. -/
theorem position_perfect_ends (perfect : PerfectPosition G rules k N) (two : 2 ≤ k)
    (least : ∀ t x, G t 0 ≤ G t x) :
    ∀ c t, t + c + 1 = N → ∀ d, d < k → ∀ a, rules d t a = 0
  | 0, _, at_ => position_last perfect (fun d t a => (perfect.1 d t a)) two at_
  | c + 1, t, at_ =>
    have leaves : ∀ d t a, rules d t a ≤ a := perfect.1
    have one : 0 < k := Nat.lt_of_lt_of_le (Nat.zero_lt_succ 1) two
    have none : ∀ d, d < k → ∀ a, rules d (t + 1) a = 0 :=
      position_perfect_ends perfect two least c (t + 1)
        ((congrArg (· + 1) (Nat.add_right_comm t 1 c)).trans at_)
    have after : ∀ d, 0 < d → d < k → ∀ a, rules d t a = 0 := fun _ pos dk a =>
      position_step perfect leaves two at_ dk a (later_same leaves one (.inr none) pos)
        fun _ => drawnAll_grows leaves one (.inr none) (least t _)
    fun d dk a => match d with
      | 0 =>
        have through : ∀ b, pass rules t 1 (k - 1) b = 0 := fun b =>
          pass_through leaves (after 1 (Nat.zero_lt_one) two) (k - 1) 1 b (Nat.le_refl 1)
            (Nat.lt_of_lt_of_le (Nat.lt_of_lt_of_le (Nat.lt_succ_self 1) two)
              (Nat.le_of_eq (Becoming.add_sub_of_le (Nat.le_trans (Nat.le_succ 1) two)).symm))
        position_step perfect leaves two at_ dk a
          (fun b => congrArg (fun z => drawn G rules k 0 (c + 1) (t + 1) (G t z))
            ((through b).trans (through 0).symm))
          (fun b => Nat.le_of_eq (congrArg (fun z => drawnAll G rules k (c + 1) (t + 1) (G t z))
            (through b).symm))
      | d' + 1 => after (d' + 1) (Nat.zero_lt_succ d') dk a

/-- **Before the horizon, racing for position draws everything.** -/
theorem position_perfect_draws (perfect : PerfectPosition G rules k N) (two : 2 ≤ k)
    (least : ∀ t x, G t 0 ≤ G t x) {t : Nat} (before : t < N) :
    ∀ d, d < k → ∀ a, rules d t a = 0 :=
  position_perfect_ends perfect two least (N - (t + 1)) t
    ((Nat.add_right_comm t (N - (t + 1)) 1).trans (Becoming.add_sub_of_le before))

/-- **So the base stands at what stands from nothing**, from the first step to the `N`-th. -/
theorem position_levels (perfect : PerfectPosition G rules k N) (two : 2 ≤ k)
    (least : ∀ t x, G t 0 ≤ G t x) (s : Nat) {t : Nat} (before : t < N) :
    levels G rules k s (t + 1) = G t 0 :=
  levels_through perfect.1 (Nat.lt_of_lt_of_le (Nat.zero_lt_succ 1) two)
    (fun _ lt a => position_perfect_draws perfect two least lt 0
      (Nat.lt_of_lt_of_le (Nat.zero_lt_succ 1) two) a) s before

/-- **Drawing everything is perfect for position**, among at least two drawers, where what stands
from nothing is least. -/
theorem zero_position_perfect (two : 2 ≤ k) (least : ∀ t x, G t 0 ≤ G t x) (N : Nat) :
    PerfectPosition G (fun _ _ _ => 0) k N :=
  have leaves : ∀ (d t a : Nat), (fun _ _ _ => 0 : Nat → Nat → Nat → Nat) d t a ≤ a :=
    fun _ _ a => Nat.zero_le a
  have one : 0 < k := Nat.lt_of_lt_of_le (Nat.zero_lt_succ 1) two
  have none : ∀ s d, d < k → ∀ a, (fun _ _ _ => 0 : Nat → Nat → Nat → Nat) d s a = 0 :=
    fun _ _ _ _ => rfl
  ⟨fun _ _ a => Nat.zero_le a, fun t j _ d _ a b le => by
    show k * (a - b + later G (fun _ _ _ => 0) k d j t b) +
        whole G (fun _ _ _ => 0) k d j t a 0 ≤
      k * (a - 0 + later G (fun _ _ _ => 0) k d j t 0) + whole G (fun _ _ _ => 0) k d j t a b
    unfold whole
    rw [pass_zero leaves t (d + 1) (k - (d + 1))]
    match d with
    | 0 =>
      have through : ∀ b, pass (fun _ _ _ => 0) t 1 (k - 1) b = 0 := fun b =>
        pass_through leaves (u := 1) (fun _ => rfl) (k - 1) 1 b (Nat.le_refl 1)
          (Nat.lt_of_lt_of_le (Nat.lt_of_lt_of_le (Nat.lt_succ_self 1) two)
            (Nat.le_of_eq (Becoming.add_sub_of_le (Nat.le_trans (Nat.le_succ 1) two)).symm))
      have same : later G (fun _ _ _ => 0) k 0 j t b = later G (fun _ _ _ => 0) k 0 j t 0 :=
        congrArg (fun z => drawn G (fun _ _ _ => 0) k 0 j (t + 1) (G t z))
          ((through b).trans (through 0).symm)
      rw [same]
      exact position_nothing_best one le (Nat.le_trans (Nat.le_of_eq (through b)) (Nat.zero_le b))
        (Nat.le_of_eq (congrArg (fun z => drawnAll G (fun _ _ _ => 0) k j (t + 1) (G t z))
          (through b).symm))
    | d' + 1 =>
      rw [later_same (G := G) leaves one (j := j) (t := t) (.inr (none (t + 1)))
        (Nat.zero_lt_succ d') b]
      exact position_nothing_best one le (pass_le leaves t _ _ _)
        (drawnAll_grows leaves one (.inr (none (t + 1))) (least t _))⟩

/-- **With one drawer, every profile is perfect for position**: its draw is all that is drawn. -/
theorem position_one (leaves : ∀ d t a, rules d t a ≤ a) (N : Nat) : PerfectPosition G rules 1 N :=
  ⟨leaves, fun t j _ d dk a b _ => by
    match d, dk with
    | 0, _ =>
      show 1 * (a - b + later G rules 1 0 j t b) + (a - rules 0 t a +
          (drawn G rules 1 0 j (t + 1) (G t (rules 0 t a)) + 0)) ≤
        1 * (a - rules 0 t a + later G rules 1 0 j t (rules 0 t a)) +
          (a - b + (drawn G rules 1 0 j (t + 1) (G t b) + 0))
      rw [Nat.one_mul, Nat.one_mul, Nat.add_zero, Nat.add_zero]
      exact Nat.le_of_eq (Nat.add_comm _ _)
    | d' + 1, dk => exact absurd (Nat.le_of_succ_le_succ dk) (Nat.not_succ_le_zero d')⟩

/-- A world where something left stops what stands next: from nothing two stand, from anything
left nothing. -/
def stopping : Nat → Nat → Nat
  | _, 0 => 2
  | _, _ + 1 => 0

namespace Stopping

/-- What stands from nothing is not least: it stands above what stands from one unit. -/
theorem not_least : ¬ ∀ t x, stopping t 0 ≤ stopping t x :=
  fun least => absurd (least 0 1) (by decide)

/-- **Drawing everything is not perfect for position.** With two drawers over two steps, the second,
given one unit at the first step, places itself higher by keeping it: what it keeps stops the two
units the first drawer would draw next. -/
theorem zero_not_perfect : ¬ PerfectPosition stopping (fun _ _ _ => 0) 2 2 :=
  fun perfect => absurd (perfect.2 0 1 rfl 1 (by decide) 1 1 (Nat.le_refl 1)) (by decide)

/-- **In every perfect profile the second drawer keeps what it is given at the first step**, a unit
of one, so that nothing stands for the first drawer next. -/
theorem perfect_keeps {rules : Nat → Nat → Nat → Nat} (perfect : PerfectPosition stopping rules 2 2) :
    rules 1 0 1 = 1 := by
  have leaves : ∀ d t a, rules d t a ≤ a := perfect.1
  have last := position_last perfect leaves (Nat.le_refl 2) (t := 1) rfl
  have none : ∀ d, d < 2 → ∀ a, rules d 1 a = 0 := last
  have own : ∀ b, later stopping rules 2 1 1 0 b = 0 := fun b =>
    (drawn_other_none (G := stopping) leaves (Nat.zero_lt_succ 1) none (Nat.zero_lt_one) 0 _).trans rfl
  have all : ∀ b, whole stopping rules 2 1 1 0 1 b = 1 - b + stopping 0 b := fun b =>
    congrArg (1 - b + ·) ((drawnAll_none (G := stopping) leaves (Nat.zero_lt_succ 1) none 0 _).trans
      (Nat.add_zero _))
  have best := perfect.2 0 1 rfl 1 (by decide) 1 1 (Nat.le_refl 1)
  rw [own, own, all, all] at best
  have le := leaves 1 0 1
  match h : rules 1 0 1 with
  | 0 => rw [h] at best; exact absurd best (by decide)
  | 1 => rfl
  | n + 2 => rw [h] at le; exact absurd (Nat.le_of_succ_le_succ le) (Nat.not_succ_le_zero n)

end Stopping

end InTurn

/-! ### Drawing at once

The same law at a second arrangement. At each step the level `z` is divided into portions, drawer
`d` given `portion d t z`, and all draw at once; what all leave, added, stands at the next step as
`G t` of it, and what lies in no portion does not stand. What a drawer leaves comes back to it only
through its portion of what stands next. Where that return is less than one for one, by the strict
law (`InTurn.floor_of_less`) every perfect profile draws everything, drawing everything is perfect,
and revising from any profile reaches it within one round a step back. -/

namespace AtOnce

/-- The values of `f` below `n`, added. -/
def sumTo (f : Nat → Nat) : Nat → Nat
  | 0 => 0
  | n + 1 => sumTo f n + f n

/-- What all `k` drawers leave at step `t` of the level `z`. -/
def pool (portion rules : Nat → Nat → Nat → Nat) (k t z : Nat) : Nat :=
  sumTo (fun d => rules d t (portion d t z)) k

/-- What stands at the step after `t`. -/
def next (G : Nat → Nat → Nat) (portion rules : Nat → Nat → Nat → Nat) (k t z : Nat) : Nat :=
  G t (pool portion rules k t z)

/-- What drawer `d` draws over `j` steps from step `t` at level `z`. -/
def drawn (G : Nat → Nat → Nat) (portion rules : Nat → Nat → Nat → Nat) (k d : Nat) : Nat → Nat → Nat → Nat
  | 0, _, _ => 0
  | j + 1, t, z => (portion d t z - rules d t (portion d t z)) +
      drawn G portion rules k d j (t + 1) (next G portion rules k t z)

/-- What drawer `d` draws over the `j` steps after `t`, having left `b` of its portion of `z`, the
others leaving as `rules` says. -/
def later (G : Nat → Nat → Nat) (portion rules : Nat → Nat → Nat → Nat) (k d j t z b : Nat) : Nat :=
  drawn G portion rules k d j (t + 1)
    (G t (sumTo (fun e => if e = d then b else rules e t (portion e t z)) k))

/-- The levels along a profile from `s`. -/
def levels (G : Nat → Nat → Nat) (portion rules : Nat → Nat → Nat → Nat) (k s : Nat) : Nat → Nat
  | 0 => s
  | t + 1 => next G portion rules k t (levels G portion rules k s t)

/-- **A revision**, drawing at once: each rule of `rules'` leaves between its floor and all of its
portion, and at every step from every level it leaves what draws its drawer the most, the others
leaving as `rules` says. -/
def Revises (G : Nat → Nat → Nat) (portion low rules rules' : Nat → Nat → Nat → Nat) (k N : Nat) : Prop :=
  (∀ d t a, low d t a ≤ rules' d t a ∧ rules' d t a ≤ a) ∧
  ∀ t j, t + j + 1 = N → ∀ d, d < k → ∀ z b, low d t (portion d t z) ≤ b → b ≤ portion d t z →
    portion d t z - b + later G portion rules k d j t z b ≤
      portion d t z - rules' d t (portion d t z) + later G portion rules k d j t z (rules' d t (portion d t z))

/-- **Perfect**, drawing at once: the profile revises itself. -/
def Perfect (G : Nat → Nat → Nat) (portion low rules : Nat → Nat → Nat → Nat) (k N : Nat) : Prop :=
  Revises G portion low rules rules k N

/-- **Each portion returns less than one for one**: of what stands at the step after `t`, raised by a
positive amount left, drawer `d`'s portion rises by less than that amount. -/
def ReturnsLess (G : Nat → Nat → Nat) (portion : Nat → Nat → Nat → Nat) (k N : Nat) : Prop :=
  ∀ d, d < k → ∀ t, t + 1 < N → ∀ x b, 0 < b → portion d (t + 1) (G t (x + b)) < portion d (t + 1) (G t x) + b

variable {G : Nat → Nat → Nat} {portion : Nat → Nat → Nat → Nat} {k N : Nat}

theorem sumTo_congr {f g : Nat → Nat} : ∀ {n}, (∀ e, e < n → f e = g e) → sumTo f n = sumTo g n
  | 0, _ => rfl
  | n + 1, same => (congrArg (· + f n) (sumTo_congr fun e lt => same e (Nat.lt_succ_of_lt lt))).trans
      (congrArg (sumTo g n + ·) (same n (Nat.lt_succ_self n)))

theorem sumTo_zeros : ∀ n, sumTo (fun _ => 0) n = 0
  | 0 => rfl
  | n + 1 => sumTo_zeros n

theorem sumTo_zero {f : Nat → Nat} {n : Nat} (zero : ∀ e, e < n → f e = 0) : sumTo f n = 0 :=
  (sumTo_congr (g := fun _ => 0) zero).trans (sumTo_zeros n)

/-- **One summand set apart.** With `d` below `n`, the sum with `b` at `d` is the sum with nothing
there, and `b`. -/
theorem sumTo_set {f : Nat → Nat} {d b : Nat} : ∀ {n}, d < n →
    sumTo (fun e => if e = d then b else f e) n = sumTo (fun e => if e = d then 0 else f e) n + b
  | 0, lt => absurd lt (Nat.not_lt_zero d)
  | n + 1, lt => (Nat.lt_or_ge d n).elim
      (fun dn => by
        show sumTo (fun e => if e = d then b else f e) n + (if n = d then b else f n) =
          sumTo (fun e => if e = d then 0 else f e) n + (if n = d then 0 else f n) + b
        rw [sumTo_set dn, if_neg (Nat.ne_of_gt dn), if_neg (Nat.ne_of_gt dn), Nat.add_right_comm])
      (fun nd => have same : n = d := Nat.le_antisymm nd (Nat.le_of_lt_succ lt)
        have below : ∀ e, e < n → (if e = d then b else f e) = (if e = d then 0 else f e) := fun e en => by
          rw [if_neg (Nat.ne_of_lt (Nat.lt_of_lt_of_le en (Nat.le_of_eq same))),
            if_neg (Nat.ne_of_lt (Nat.lt_of_lt_of_le en (Nat.le_of_eq same)))]
        by
          show sumTo (fun e => if e = d then b else f e) n + (if n = d then b else f n) =
            sumTo (fun e => if e = d then 0 else f e) n + (if n = d then 0 else f n) + b
          rw [sumTo_congr below, if_pos same, if_pos same, Nat.add_zero])

/-- Where every drawer draws everything at a step, drawer `d` draws its portion there and nothing is
left to stand but what stands at nothing. -/
theorem drawn_step {rules : Nat → Nat → Nat → Nat} {d t : Nat} (dk : d < k)
    (zero : ∀ e, e < k → ∀ z, rules e t (portion e t z) = 0) (j w : Nat) :
    drawn G portion rules k d (j + 1) t w = portion d t w + drawn G portion rules k d j (t + 1) (G t 0) := by
  show portion d t w - rules d t (portion d t w) +
    drawn G portion rules k d j (t + 1) (G t (sumTo (fun e => rules e t (portion e t w)) k)) = _
  rw [zero d dk w, Nat.sub_zero, sumTo_zero (fun e ek => zero e ek w)]

/-- **Where the others draw everything later, what a drawer keeps returns less than one for one.** -/
theorem later_less {rules : Nat → Nat → Nat → Nat} (returns : ReturnsLess G portion k N) {d t c z r : Nat}
    (dk : d < k) (here : t + c + 1 = N)
    (after : ∀ s, t + 1 ≤ s → s < N → ∀ e, e < k → ∀ z, rules e s (portion e s z) = 0) (pos : 0 < r) :
    later G portion rules k d c t z r < later G portion rules k d c t z 0 + (r - 0) :=
  match c, here with
  | 0, _ => by
    show 0 < 0 + (r - 0)
    rw [Nat.zero_add, Nat.sub_zero]
    exact pos
  | c' + 1, here =>
    have next_ : t + 1 < N := Nat.lt_of_lt_of_le
      (Nat.lt_succ_of_le (Nat.add_le_add_left (Nat.succ_pos c') t)) (Nat.le_of_eq here)
    have v : ∀ b, later G portion rules k d (c' + 1) t z b =
        portion d (t + 1) (G t (sumTo (fun e => if e = d then 0 else rules e t (portion e t z)) k + b)) +
          drawn G portion rules k d c' (t + 1 + 1) (G (t + 1) 0) := fun b =>
      (drawn_step (G := G) dk (fun e ek z' => after (t + 1) (Nat.le_refl _) next_ e ek z') c' _).trans
        (congrArg (fun x => portion d (t + 1) (G t x) + drawn G portion rules k d c' (t + 1 + 1) (G (t + 1) 0))
          (sumTo_set dk))
    by
      rw [v r, v 0, Nat.sub_zero, Nat.add_right_comm _ (drawn G portion rules k d c' (t + 1 + 1) (G (t + 1) 0)) r]
      exact Nat.add_lt_add_right (returns d dk t next_ _ r pos) _

/-- **Revising from the horizon back, every drawer comes to draw everything.** Where each portion
returns less than one for one, along every sequence of profiles each revising the one before over
`N` steps, with no floor, at every round from `c` on every drawer draws all of its portion at every
step of the last `c`, whatever profile they started from. -/
theorem revisions_drain {fs : Nat → Nat → Nat → Nat → Nat} (returns : ReturnsLess G portion k N)
    (rev : ∀ m, Revises G portion (fun _ _ _ => 0) (fs m) (fs (m + 1)) k N) :
    ∀ c t, t + c = N → ∀ m, c ≤ m → ∀ s, t ≤ s → s < N → ∀ d, d < k → ∀ z, fs m d s (portion d s z) = 0
  | 0, _, at_, _, _, _, le, lt => absurd (Nat.lt_of_lt_of_le lt (Nat.le_of_eq at_.symm)) (Nat.not_lt_of_ge le)
  | c + 1, t, at_, m, enough, s, le, lt =>
    have here : t + c + 1 = N := (Nat.add_assoc t c 1).trans at_
    have later_ := revisions_drain returns rev c (t + 1) ((Nat.add_right_comm t 1 c).trans here)
    have now : ∀ m', c + 1 ≤ m' → ∀ d, d < k → ∀ z, fs m' d t (portion d t z) = 0 := fun m' big d dk z =>
      match m', big with
      | m'' + 1, big =>
        InTurn.floor_of_less (C := later G portion (fs m'') k d c t z) (Nat.zero_le _)
          ((rev m'').1 d t (portion d t z)).2 ((rev m'').2 t c here d dk z 0 (Nat.zero_le _) (Nat.zero_le _))
          (later_less returns dk here (later_ m'' (Nat.le_of_succ_le_succ big)))
    match Nat.lt_or_ge t s with
    | .inl after => later_ m (Nat.le_trans (Nat.le_succ c) enough) s after lt
    | .inr before => (Nat.le_antisymm before le) ▸ now m enough

/-- **Drawing at once, every perfect profile draws everything, and drawing everything is perfect.**
Where each portion returns less than one for one, with no floor, the profile drawing everything is
perfect over every horizon, and every perfect profile has every drawer draw all of its portion at
every step before the horizon: a perfect profile is its own sequence of revisions. -/
theorem drains (returns : ReturnsLess G portion k N) :
    Perfect G portion (fun _ _ _ => 0) (fun _ _ _ => 0) k N ∧
      ∀ rules, Perfect G portion (fun _ _ _ => 0) rules k N →
        ∀ t, t < N → ∀ d, d < k → ∀ z, rules d t (portion d t z) = 0 :=
  ⟨⟨fun _ _ _ => ⟨Nat.le_refl 0, Nat.zero_le _⟩, fun t j at_ d dk z b _ le =>
      have ret : later G portion (fun _ _ _ => 0) k d j t z b ≤
          later G portion (fun _ _ _ => 0) k d j t z 0 + (b - 0) :=
        match b with
        | 0 => Nat.le_add_right _ _
        | b + 1 => Nat.le_of_lt (later_less returns dk at_ (fun _ _ _ _ _ _ => rfl) (Nat.succ_pos b))
      Nat.le_trans (Nat.add_le_add_left ret _) (Nat.le_of_eq
        ((congrArg (portion d t z - b + ·) (Nat.add_comm (later G portion (fun _ _ _ => 0) k d j t z 0) b)).trans
          ((Nat.add_assoc _ b _).symm.trans (congrArg (· + later G portion (fun _ _ _ => 0) k d j t z 0)
            (Naturals.sub_add_cancel le)))))⟩,
   fun rules perfect t lt => revisions_drain (fs := fun _ => rules) returns (fun _ => perfect)
     N 0 (Nat.zero_add N) N (Nat.le_refl N) t (Nat.zero_le t) lt⟩

/-- **Where every drawer draws everything, the base stands at what stands at nothing**, from the first
step to the `N`-th. -/
theorem levels_drained {rules : Nat → Nat → Nat → Nat}
    (zero : ∀ t, t < N → ∀ d, d < k → ∀ z, rules d t (portion d t z) = 0) (s : Nat) {t : Nat} (before : t < N) :
    levels G portion rules k s (t + 1) = G t 0 :=
  congrArg (G t) (sumTo_zero fun e ek => zero t before e ek _)

end AtOnce

end Optimum

namespace Web

variable {W : Web F C} {c : C} {f : F}

/-- **Where a drawer leaves nothing, every dependence on the base above what stands at nothing is
broken at the first step.** Along a profile of drawers in turn, each leaving at most what it is given,
one of which leaves nothing at every step before a horizon of at least one step, the base stands from
the first step at what stands at nothing: a formation depending on it, whose need, met at the start,
lies above what stands at nothing at the first step, is broken there. Where two drawers have no floor,
every perfect profile (`Optimum.InTurn.perfect_at_floors`) and every profile revised long enough
(`Optimum.InTurn.revised_at_floors`) is such a profile. -/
theorem drained_broken {G : Nat → Nat → Nat} {rules : Nat → Nat → Nat → Nat} {k N s u : Nat} (uk : u < k)
    (leaves : ∀ d t a, rules d t a ≤ a) (zero : ∀ t, t < N → ∀ a, rules u t a = 0)
    (follows : ∀ t, t ≤ N → W.level t c = Optimum.InTurn.levels G rules k s t)
    (long : 0 < N) (depends : W.requires 0 f c) (low : G 0 0 < W.need 0 f c)
    (start : W.need 0 f c ≤ W.level 0 c) :
    W.Broken 0 f c ∧ ∀ t, t < N → W.level (t + 1) c = G t 0 :=
  have stands : ∀ t, t < N → W.level (t + 1) c = G t 0 := fun t before =>
    (follows (t + 1) before).trans (Optimum.InTurn.levels_through leaves uk zero s before)
  ⟨⟨depends, start, Nat.lt_of_le_of_lt (Nat.le_of_eq (stands 0 long)) low⟩, stands⟩


/-- **Drawing at once, every perfect profile breaks at the first step every dependence above what
stands at nothing.** Where each portion returns less than one for one, along every perfect profile
over a horizon of at least one step, with no floor, the base stands at what stands at nothing after
the first step: a formation depending on it, whose need, met at the start, lies above that, is broken
there (`Optimum.AtOnce.drains`). -/
theorem at_once_broken {G : Nat → Nat → Nat} {portion rules : Nat → Nat → Nat → Nat} {k N s : Nat}
    (returns : Optimum.AtOnce.ReturnsLess G portion k N)
    (perfect : Optimum.AtOnce.Perfect G portion (fun _ _ _ => 0) rules k N)
    (follows : ∀ t, t ≤ N → W.level t c = Optimum.AtOnce.levels G portion rules k s t)
    (long : 0 < N) (depends : W.requires 0 f c) (low : G 0 0 < W.need 0 f c)
    (start : W.need 0 f c ≤ W.level 0 c) : W.Broken 0 f c :=
  ⟨depends, start, Nat.lt_of_le_of_lt (Nat.le_of_eq ((follows 1 long).trans
    (Optimum.AtOnce.levels_drained ((Optimum.AtOnce.drains returns).2 rules perfect) s long))) low⟩
/-- **Racing for position, every perfect profile breaks at the first step every dependence above what
stands from nothing.** Among at least two drawers in turn ranking their position, where what stands
from nothing is at most what stands from anything left, along every profile perfect for position over
a horizon of at least one step, the base stands from the first step at what stands from nothing: a
formation depending on it, whose need, met at the start, lies above what stands from nothing at the
first step, is broken there (`Optimum.InTurn.position_perfect_draws`). -/
theorem position_broken {G : Nat → Nat → Nat} {rules : Nat → Nat → Nat → Nat} {k N s : Nat}
    (perfect : Optimum.InTurn.PerfectPosition G rules k N) (two : 2 ≤ k)
    (least : ∀ t x, G t 0 ≤ G t x)
    (follows : ∀ t, t ≤ N → W.level t c = Optimum.InTurn.levels G rules k s t)
    (long : 0 < N) (depends : W.requires 0 f c) (low : G 0 0 < W.need 0 f c)
    (start : W.need 0 f c ≤ W.level 0 c) :
    W.Broken 0 f c ∧ ∀ t, t < N → W.level (t + 1) c = G t 0 :=
  have stands : ∀ t, t < N → W.level (t + 1) c = G t 0 := fun t before =>
    (follows (t + 1) before).trans (Optimum.InTurn.position_levels perfect two least s before)
  ⟨⟨depends, start, Nat.lt_of_le_of_lt (Nat.le_of_eq (stands 0 long)) low⟩, stands⟩

/-- **Drawing everything is a perfect race for position, and it breaks what depends above nothing.**
Among at least two drawers in turn, where what stands from nothing is at most what stands from
anything left, drawing everything is perfect for position (`Optimum.InTurn.zero_position_perfect`),
and on a web whose base follows it over a horizon of at least one step, a formation depending on the
base, whose need, met at the start, lies above what stands from nothing at the first step, is broken
there. -/
theorem drain_position_broken {G : Nat → Nat → Nat} {k N s : Nat} (two : 2 ≤ k)
    (least : ∀ t x, G t 0 ≤ G t x)
    (follows : ∀ t, t ≤ N → W.level t c = Optimum.InTurn.levels G (fun _ _ _ => 0) k s t)
    (long : 0 < N) (depends : W.requires 0 f c) (low : G 0 0 < W.need 0 f c)
    (start : W.need 0 f c ≤ W.level 0 c) :
    Optimum.InTurn.PerfectPosition G (fun _ _ _ => 0) k N ∧ W.Broken 0 f c :=
  have perfect := Optimum.InTurn.zero_position_perfect two least N
  ⟨perfect, (position_broken perfect two least follows long depends low start).1⟩

end Web

namespace Optimum

namespace Holding

open Diversion

/-- Drawers who leave everything they are given pass it on whole. -/
theorem pass_keep (t : Nat) : ∀ d c b, InTurn.pass (fun _ _ a => a) t d c b = b
  | _, 0, _ => rfl
  | d, c + 1, b => pass_keep t (d + 1) c b

/-- Under the gate, drawers in turn who all leave everything keep the source at two or above. -/
theorem restraint_keeps (k : Nat) : ∀ t, 2 ≤ InTurn.levels (fun _ z => z + gate z) (fun _ _ a => a) k 2 t
  | 0 => Nat.le_refl 2
  | t + 1 => Nat.le_trans (restraint_keeps k t) (Nat.le_trans (Nat.le_of_eq (pass_keep t 0 k _).symm)
      (Nat.le_add_right _ _))

/-- **The gate witness.** From a source at two, the level the dweller needs, under a gate renewing
one unit at every level from one: alone, the course holding the source at two is an optimum of the
order by what the taker draws across `n + 2` steps with capacity three, keeping the dweller met
through the horizon (`gated_alike`). Any number of drawers in turn from two who all leave
everything keep the source at two or above; drawing everything is perfect for them; every perfect
profile breaks the dweller at the first step; and revising from restraint, from round `2 (n + 2)` on
every profile breaks it there. -/
theorem gated_in_turn (n : Nat) {k : Nat} (two : 2 ≤ k) {m : Nat} (enough : 2 * (n + 2) ≤ m) :
    Frontier (OpenCourse gate 3 2) (byDrawn gate (n + 1)) (holding 2 2 (n + 1)) ∧
      (∀ t, t ≤ n + 1 → 2 ≤ (web (level gate 2 2 (n + 1))).level t .source) ∧
      (∀ t, 2 ≤ InTurn.levels (fun _ z => z + gate z) (fun _ _ a => a) k 2 t) ∧
      InTurn.Perfect (fun _ z => z + gate z) (fun _ _ _ => 0) (fun _ _ _ => 0) k (n + 2) ∧
      (∀ rules, InTurn.Perfect (fun _ z => z + gate z) (fun _ _ _ => 0) rules k (n + 2) →
        (web (onSource (InTurn.levels (fun _ z => z + gate z) rules k 2))).Broken 0 .dweller .source) ∧
      (web (onSource (InTurn.levels (fun _ z => z + gate z)
        (InTurn.revised (fun _ z => z + gate z) (fun _ _ _ => 0) k (n + 2) (fun _ _ a => a) m) k 2))).Broken 0
          .dweller .source :=
  have alone := gated_alike n
  have firstPos : 0 < k := Nat.lt_of_lt_of_le (Nat.zero_lt_succ 1) two
  have second : 1 < k := Nat.lt_of_lt_of_le (Nat.lt_succ_self 1) two
  have revised := InTurn.revised_at_floors (G := fun _ z => z + gate z) (N := n + 2) (u := 0) (v := 1) (p := 2)
    Nat.zero_lt_one second (fun _ _ _ => Nat.zero_le _) (fun _ _ => rfl) (fun _ _ => rfl) (Nat.le_refl 2) (.inl rfl)
    (start := fun _ _ a => a) (fun _ _ a => Nat.le_refl a) enough
  ⟨alone.1, alone.2.2.2.1, restraint_keeps k,
   InTurn.floors_perfect Nat.zero_lt_one second (fun _ _ _ => Nat.zero_le _) (fun _ _ => rfl) (fun _ _ => rfl) (n + 2),
   fun rules perfect =>
    (Web.drained_broken (W := web (onSource (InTurn.levels (fun _ z => z + gate z) rules k 2)))
      (c := Place.source) (f := Formation.dweller) firstPos (fun d t a => (perfect.1 d t a).2)
      (fun _ lt => InTurn.perfect_at_floors Nat.zero_lt_one second (fun _ _ => rfl) (fun _ _ => rfl) perfect lt 0 firstPos)
      (fun _ _ => rfl) (Nat.succ_pos (n + 1))
      trivial (Nat.succ_pos 1) (Nat.le_refl 2)).1,
   (Web.drained_broken (W := web (onSource (InTurn.levels (fun _ z => z + gate z)
      (InTurn.revised (fun _ z => z + gate z) (fun _ _ _ => 0) k (n + 2) (fun _ _ a => a) m) k 2)))
      (c := Place.source) (f := Formation.dweller)
      (rules := InTurn.revised (fun _ z => z + gate z) (fun _ _ _ => 0) k (n + 2) (fun _ _ a => a) m) firstPos
      (InTurn.revised_leaves (fun _ _ _ => Nat.zero_le _) (fun _ _ a => Nat.le_refl a) m)
      (fun t lt => revised.1 t lt 0 firstPos) (fun _ _ => rfl) (Nat.succ_pos (n + 1))
      trivial (Nat.succ_pos 1) (Nat.le_refl 2)).1⟩

/-- A capacity of one unit a step for every drawer after the first, none for the first. -/
def oneUnit : Nat → Nat → Nat → Nat
  | 0, _, _ => 0
  | _ + 1, _, a => a - 1

/-- The first leaves everything at the first step from two up and draws everything otherwise. -/
def keepsFirst : Nat → Nat → Nat
  | 0, z => if 2 ≤ z then z else 0
  | _ + 1, _ => 0

/-- The first keeps as `keepsFirst` says, the others take their unit. -/
def keeping : Nat → Nat → Nat → Nat
  | 0, t, z => keepsFirst t z
  | _ + 1, _, a => a - 1

theorem keepsFirst_le : ∀ t z, keepsFirst t z ≤ z
  | 0, z => if h : 2 ≤ z then Nat.le_of_eq (if_pos h) else Nat.le_trans (Nat.le_of_eq (if_neg h)) (Nat.zero_le z)
  | _ + 1, z => Nat.zero_le z

/-- `b + d` twice is `d` with `b` twice, and `d` again. -/
theorem twice_sum (b d : Nat) : (b + d) + (b + d) = (d + (b + b)) + d :=
  (Nat.add_assoc b d (b + d)).trans ((Nat.add_left_comm b d (b + d)).trans
    ((congrArg (d + ·) (Nat.add_assoc b b d).symm).trans (Nat.add_assoc d (b + b) d).symm))

/-- Under doubling, leaving `a` of `z` and drawing what doubles of the rest after the second takes one,
draws at most what `keepsFirst` draws. -/
theorem keepsFirst_best (z a : Nat) (le : a ≤ z) :
    z - a + ((a - 1) + (a - 1)) ≤
      z - keepsFirst 0 z + ((keepsFirst 0 z - 1) + (keepsFirst 0 z - 1)) :=
  if two : 2 ≤ z then by
    show z - a + ((a - 1) + (a - 1)) ≤
      z - (if 2 ≤ z then z else 0) + (((if 2 ≤ z then z else 0) - 1) + ((if 2 ≤ z then z else 0) - 1))
    rw [if_pos two, Nat.sub_self, Nat.zero_add]
    exact match a, le with
    | 0, _ => match z, two with
      | e + 2, _ => Nat.succ_le_succ (Nat.le_add_right (e + 1) e)
    | b + 1, le => match le_dest le with
      | ⟨d, split⟩ => by
        rw [split, Naturals.add_sub_cancel_left (b + 1) d, Nat.add_right_comm b 1 d]
        show d + (b + b) ≤ (b + d) + (b + d)
        exact Nat.le_trans (Nat.le_add_right _ d) (Nat.le_of_eq (twice_sum b d).symm)
  else by
    show z - a + ((a - 1) + (a - 1)) ≤
      z - (if 2 ≤ z then z else 0) + (((if 2 ≤ z then z else 0) - 1) + ((if 2 ≤ z then z else 0) - 1))
    rw [if_neg two]
    have small : a - 1 = 0 := Becoming.sub_eq_zero_of_le
      (Nat.le_of_lt_succ (Nat.lt_of_le_of_lt le (Nat.gt_of_not_le two)))
    rw [small]
    exact Nat.sub_le z a

/-- Only leaving all three, where the second takes one and what doubles of the rest is drawn after,
draws four. -/
theorem only_three : ∀ f, f ≤ 3 → 4 ≤ 3 - f + ((f - 1) + (f - 1)) → f = 3
  | 0, _, h => absurd h (by decide)
  | 1, _, h => absurd h (by decide)
  | 2, _, h => absurd h (by decide)
  | 3, _, _ => rfl
  | f + 4, le, _ => absurd le (Nat.not_le_of_gt (Nat.lt_of_lt_of_le (Nat.lt_succ_self 3) (Nat.le_add_left 4 f)))

/-- **The capacity witness: a limit on the other's draw makes restraint the best response.** What
stands after a step is twice what is left; over two steps, the first of two drawers can take any
amount and the second one unit a step. The profile in which the first leaves everything at the first
step from two up, and draws everything otherwise, and the second takes its unit, is perfect within
these floors. In every such perfect profile, from three, the second takes its unit, so what the first
leaves returns to it twice, less one: the first leaves everything at the first step, the source stands
at four after it and a dweller needing two, met at three, is kept across the first step. With no
floor every perfect profile breaks it there. -/
theorem doubling_capacity :
    InTurn.Perfect (fun _ z => z + z) oneUnit keeping 2 2 ∧
    (∀ rules, InTurn.Perfect (fun _ z => z + z) oneUnit rules 2 2 →
      rules 0 0 3 = 3 ∧ (web (onSource (InTurn.levels (fun _ z => z + z) rules 2 3))).Kept 0 .dweller .source) ∧
    ∀ rules, InTurn.Perfect (fun _ z => z + z) (fun _ _ _ => 0) rules 2 2 →
      (web (onSource (InTurn.levels (fun _ z => z + z) rules 2 3))).Broken 0 .dweller .source :=
  ⟨⟨fun d t a => match d with
      | 0 => ⟨Nat.zero_le _, keepsFirst_le t a⟩
      | _ + 1 => ⟨Nat.le_refl _, Nat.sub_le a 1⟩,
    fun t j at_ d lt a b floor _ => match t, j, at_, d, lt with
      | 0, 0, h, _, _ => absurd h (by decide)
      | 0, j + 2, h, _, _ => absurd h (Nat.ne_of_gt (Nat.succ_le_succ
          (Nat.succ_le_succ (Nat.succ_le_succ (Nat.zero_le (0 + j))))))
      | 1, j + 1, h, _, _ => absurd h (Nat.ne_of_gt (Nat.succ_le_succ (Nat.succ_le_succ (Nat.le_add_right 1 j))))
      | t + 2, j, h, _, _ => absurd h (Nat.ne_of_gt (Nat.succ_le_succ
          (Nat.le_trans (Nat.le_add_left 2 t) (Nat.le_add_right (t + 2) j))))
      | _, _, _, d + 2, lt => absurd lt (Nat.not_lt_of_ge (Nat.le_add_left 2 d))
      | 0, 1, _, 0, _ => keepsFirst_best a b ‹b ≤ a›
      | 0, 1, _, 1, _ => sub_le_sub_left_of_le floor a
      | 1, 0, _, 0, _ => Nat.sub_le a b
      | 1, 0, _, 1, _ => sub_le_sub_left_of_le floor a⟩,
   fun rules perfect =>
    have last := InTurn.last_at_floor perfect (t := 1) rfl
    have none : ∀ w, InTurn.drawn (fun _ z => z + z) rules 2 1 1 1 w = 0 := fun w => by
      show rules 0 1 w - rules 1 1 (rules 0 1 w) + 0 = 0
      rw [last 0 (Nat.zero_lt_succ 1) w, last 1 (Nat.lt_succ_self 1) (oneUnit 0 1 w)]
      try rfl
    have sec : ∀ a, rules 1 0 a = a - 1 := fun a =>
      InTurn.at_floor perfect (t := 0) (j := 1) rfl (Nat.lt_succ_self 1) a (by
        show InTurn.drawn (fun _ z => z + z) rules 2 1 1 1 _ = InTurn.drawn (fun _ z => z + z) rules 2 1 1 1 _
        rw [none, none])
    have drawnOne : ∀ w, InTurn.drawn (fun _ z => z + z) rules 2 0 1 1 w = w := fun w =>
      congrArg (fun x => w - x + 0) (last 0 (Nat.zero_lt_succ 1) w)
    have laterOne : ∀ b, InTurn.later (fun _ z => z + z) rules 2 0 1 0 b = (b - 1) + (b - 1) := fun b =>
      (drawnOne _).trans (by
        show rules 1 0 b + rules 1 0 b = _
        rw [sec])
    have pick := perfect.2 0 1 rfl 0 (Nat.zero_lt_succ 1) 3 3 (Nat.zero_le 3) (Nat.le_refl 3)
    have three : rules 0 0 3 = 3 := only_three (rules 0 0 3) (perfect.1 0 0 3).2 (by
      rw [laterOne, laterOne] at pick
      exact pick)
    have four : InTurn.levels (fun _ z => z + z) rules 2 3 1 = 4 := by
      show rules 1 0 (rules 0 0 3) + rules 1 0 (rules 0 0 3) = 4
      rw [three, sec]
    ⟨three, Nat.le_succ 2,
     Nat.le_trans (Nat.le_trans (Nat.le_succ 2) (Nat.le_succ 3)) (Nat.le_of_eq four.symm)⟩,
   fun rules perfect =>
    (Web.drained_broken (W := web (onSource (InTurn.levels (fun _ z => z + z) rules 2 3)))
      (c := Place.source) (f := Formation.dweller) (Nat.zero_lt_succ 1) (fun d t a => (perfect.1 d t a).2)
      (fun _ lt => InTurn.perfect_at_floors Nat.zero_lt_one (Nat.lt_succ_self 1) (fun _ _ => rfl) (fun _ _ => rfl)
        perfect lt 0 (Nat.zero_lt_succ 1)) (fun _ _ => rfl)
      (Nat.succ_pos 1) trivial (Nat.succ_pos 1) (Nat.le_succ 2)).1⟩


end Holding

end Optimum


end Becoming
