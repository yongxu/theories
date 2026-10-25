# UE1b, part 1: set-point orders and the optimum (note)

25 October 2026. AI-authored note for board item UE1b (UE1's open item (b)), testing reading 3 of the [UE1 note](../ue1-fep-bridge/NOTE.md) (§5). In active inference an agent's preferences are its characteristic states, so it ranks outcomes by closeness to a set point and has a point of enough. The question: does the optimum law of 05 ([what an optimum does beyond what couples in](../../../../../../theories/becoming/chapters/05-COLLECTIVES.md#r-what-an-optimum-does-beyond-what-couples-in)) spare such a chooser, and does joint excess ([own count misses joint excess](../../../../../../theories/becoming/chapters/05-COLLECTIVES.md#r-own-count-misses-joint-excess)) still end what several such choosers draw on?

- Kit: `Becoming.SetPointOptimum`, [tree/Becoming/SetPointOptimum.lean](tree/Becoming/SetPointOptimum.lean), pure core (imports `Becoming.Optimum` and `Becoming.Regulation` only).
- Build: [scratch.log](scratch.log). 50 modules in the closure, 49 reused from the shared cache, the module compiled fresh. 69 theorems in 100 declarations, `unclean` empty, every axiom report empty (`with_axioms: {}`).

Results go to their records and home sections when they land, not here.

## 1. The answer in brief

A point of enough removes the drive beyond what couples in. It does not remove the draw.

- **Below its set point** a set-point order rises with what couples in. Its optima drain as a maximizer's do: with room up to the set point, to the least level beyond; in an exchange, by the whole capacity.
- **At its set point**, where the set point can be reached, every optimum stands there and the order asks nothing of what lies beyond. What lies beyond is then what reaching the set point leaves. On a step that loses nothing, that is exactly the set point's shortfall: a dependence beyond breaks exactly where the shortfall exceeds the slack. Where the step can lose what it takes, a draining outcome can be an optimum beside the keeping one (a witness).
- **Joint excess applies as read.** Holding a set point draws what is lost: the beyond falls by exactly the loss, and each holder takes from what it shares at least its own loss. Several holders, each within what a condition renews, end it together, and none couples into it.
- **New:** a term counted after the set point keeps what lies beyond, at the set point, where the same term counted after a rising order keeps nothing.

## 2. What is proved, theorem by theorem

Names are in `Becoming`. "Lemma" marks a helper that carries no claim of its own.

**Definitions.** `Optimum.gapTo s o` (the gap at each condition, `gap` of `Becoming.Propagation`); `Optimum.Nearer ds s o' o` (`Exceeds` read on the gaps: no farther at each condition of the family, nearer at one); `Optimum.Nearing ds s better` (ranks above every nearer outcome, the analogue of `Optimum.Rising`); `Optimum.AtSetPoint`, `Optimum.UpToSetPoint`; `Optimum.byGap` (smaller total gap ranks above); `Optimum.byGapThen` (by gap, then more beyond in total).

**Orders nearing a set point (any outcomes, any orders).**

- `Optimum.byGap_nearing`: the order by total gap is nearing.
- `Optimum.Nearing.mono`: an order ranking above wherever a nearing order does is nearing.
- `Optimum.gapTo_eq_zero`, `Optimum.total_gapTo_eq_zero`, `Optimum.atSetPoint_single`, `Optimum.nearer_of_atSetPoint`: lemmas.
- `Optimum.byGap_enough`: nothing ranks above an outcome at the set point by distance.
- `Optimum.atSetPoint_frontier`: an eligible outcome at the set point is an optimum of the order by distance.
- `Optimum.not_rising_of_enough`: an order under which some outcome is ranked below none is not rising, where the family holds a condition.
- `Optimum.byGap_not_rising`: the order by distance is not rising.
- `Optimum.settled_iff`: every nearing order has all its optima at the set point exactly where no eligible outcome off it goes unbeaten (doubly negated) by a nearer eligible one.
- `Optimum.settled`: where some eligible outcome stands at the set point, every optimum of every nearing order does, whatever the room.
- `Optimum.mutual_settled`: where the levels are, for each of several optimizers, an optimum of its nearing order among outcomes eligible to it, one of them at its set point, the levels stand at the set point on every family theirs cover.
- `Optimum.least_at_iff`: the set point reachable, every optimum of every nearing order stands beyond at the least level among the eligible outcomes at the set point exactly where those outcomes all stand alike beyond. Room plays no part.
- `Optimum.byGapThen_nearing`: the order by distance with the beyond counted after is nearing.
- `Optimum.counted_after_most`: the set point reachable, every optimum of that order stands at the set point and leaves the beyond, in total, at least where every eligible outcome at the set point does.

**Below the set point, a nearing order rises.**

- `Optimum.sub_le_sub_iff`, `Optimum.sub_lt_sub_iff`, `Optimum.gapTo_of_upTo`: lemmas (the converses of `Optimum.sub_le_sub_left_of_le` and `Requirement.Formation.sub_lt_sub_of_lt` within the bound; the gap read by `Regulation.gap_of_ge`).
- `Optimum.nearer_iff_exceeds`: for outcomes up to the set point, nearer exactly where higher on the family.
- `Optimum.Nearing.rises_below`: among outcomes up to the set point, a nearing order ranks above every exceeding outcome.
- `Optimum.least_below_iff`: among the eligible outcomes up to the set point, every nearing order has its optima at the least level beyond among them exactly where the (doubly negated) room condition holds among them. It is derived from `Optimum.least_iff`.
- `Optimum.least_below`: with room up to the set point, every nearing optimum among those outcomes stands at the least level beyond among them. Room up to the set point fails at an outcome at the set point standing above another beyond, so the law bites where the set point is out of reach.

**What reaching the set point draws (World: balance; the whole gaining nothing across the step).**

- `Flow.Balances.settled_draws`: with the family at its set point after the step, `stock rest (t+1) + lost + total ds s = stock ds t + stock rest t`. It is derived from `Flow.Balances.beyond_falls_exactly`.
- `Flow.Balances.held_draws_lost`: at the set point before and after the step, `stock rest (t+1) + lost = stock rest t`.
- `Flow.Balances.settled_breaks`: each condition beyond depended on at a need it meets, `stock ds t + slack < total ds s + lost` breaks some such dependence. It is derived from `Flow.Balances.breaks_beyond`.
- `Flow.Balances.settled_broken_iff`: with one condition `c` beyond, the dependence breaks exactly where `stock ds t + (level t c − need) < total ds s + lost`.
- `Flow.nearing_optimum_draws`: every optimum of a nearing order whose set point an eligible outcome reaches satisfies the identity of `settled_draws`.
- `Flow.Balances.mutual_settled_draws`: several nearing optimizers, each reaching its set point, draw exactly the joint set point's shortfall with the loss, as one optimizer with their joint set point.
- `Flow.Balances.mutual_settled_breaks`: there, a dependence beyond breaks where the joint shortfall with the loss exceeds the slack, whatever each one's own shortfall.

**In an exchange (`Flow.Outcome`: one step, capacities).**

- `Optimum.transfer_nearer`: a unit moved from outside the family into a family condition below its set point gives a nearer outcome.
- `Optimum.Above.full_of_ranked`: above its floor, an optimum takes the whole capacity at a condition beyond, and gives nothing there, wherever its order ranks above it the outcome with one unit moved from there into the family.
- `Optimum.Above.floor_or_full_of_ranked`: such an optimum stands at its floor there, or at full capacity.
- `Optimum.beyond_of_ranked`: among the open outcomes, such an optimum stands there at `l c + restGiven − restTaken − capacity`, or at nothing.
- `Optimum.nearing_beyond`: every optimum of every nearing order standing below its set point at a condition of the family stands at each condition beyond at that level.
- `Optimum.nearing_as_rising`: that is where every optimum of every rising order stands (`Optimum.optimum_beyond`).

**Several holding set points: joint excess (World: balance, activity needing support, only active giving; the gate local).**

- `Optimum.total_le_of_only`: lemma, from `total_le_at`.
- `Flow.held_draws`: where the flow balances on a formation's family, the formation alone exchanges with the family and holds it at a set point across a step, it takes from a condition `c` at least what it gives there with what it loses on its family with `c`.
- `Flow.held_excess_ends`: let the members of a part hold their families at set points across `n` steps from `T`, each alone with its family, their losses together exceeding at each step what the formations outside the part give `c`, from a level below `n + m`, under the gate at need `m`. Then every formation depending on `c` at a need of at least `m` is inactive from `T + n` on, however small each member's loss. Where each member's couplings lie in its family, apart from `c`, no member couples into `c`. It is derived from `Flow.joint_excess_ends`.

**Witnesses.**

- `Drain.storedAt_split`: lemma.
- `Drain.settled_source`: among the splits of three units, every optimum of every order nearing a store of `k ≤ 3` leaves the source at `3 − k`.
- `Drain.kept_iff`: there, the dweller's need of two is met exactly where `k ≤ 1`, the slack.
- `Drain.nearing_keeps`: room holds among the splits. Every optimum of every order nearing a store of one leaves the source at two, and the order by distance has such an optimum. Every optimum of every rising order leaves the source at zero.
- `Drain.nearing_breaks`: nearing a store of two, every optimum leaves the source at one, below the need.
- `Topped.idle_open`, `Topped.discarding_open`, `Topped.store_le_two`: lemmas.
- `Topped.nearing_either`: from a store already at its set point of one, every optimum of every nearing order stands at one. The step exchanging nothing (source two, the dweller kept) and the step taking a unit and losing it (source one, the dweller broken) are both optima of the order by distance.
- `Topped.rising_drains`: every rising optimum leaves the source at one. It is derived from `Optimum.optimum_beyond`.
- `Topped.counted_after_keeps`: every optimum of the order by distance with the source counted after meets the dweller's need. It is derived from `Optimum.counted_after_most`.
- `Topped.out_of_reach`: every optimum of every order nearing a store of three, which no open outcome reaches, leaves the source at one, as every rising optimum does. It is derived from `Optimum.nearing_beyond`.
- `TwoStores.balances`, `TwoStores.gainless`: lemmas.
- `TwoStores.best`: each taker's step is an optimum of its order by distance among the outcomes eligible to it.
- `TwoStores.jointly_broken`: each taker's shortfall is within the slack of one, and the dweller's dependence is broken. It is derived from `Flow.Balances.mutual_settled_breaks`.
- `HeldPair.balances`, `acting`, `dependent`, `gated`, `members_distinct`, `distinct`, `alone`, `held`, `loses`, `exceeds`, `listed`, `apart`: lemmas, the course law's hypotheses.
- `HeldPair.within`: across the first two steps each holder takes within what the pool is given, and together they take more.
- `HeldPair.held_end`: the renewal, and every formation depending on the pool at need one, is inactive from step two on, and neither holder couples into the pool. It is derived from `Flow.held_excess_ends`.

## 3. Reading 3: does it hold as written?

As written: "A chooser with set points escapes the optimizer's drain, not the commons. … The optimum's drain beyond its couplings needs an order rising with what couples in, so it does not apply to such a chooser as such. Joint excess does … On this reading the principle's agents drain through joint excess and through capture, not through maximization."

**Verdict: it holds in part; the first half is wrong as written.**

1. *"It does not apply to such a chooser as such": wrong.*
   - True part: the order is not rising (`Optimum.not_rising_of_enough`), so `least_of_room` does not apply to it as stated.
   - But below its set point the order rises (`Optimum.nearer_iff_exceeds`, `Optimum.Nearing.rises_below`), and the drain applies there exactly (`Optimum.least_below_iff`). In an exchange it applies by the whole capacity, exactly as for a rising order (`Optimum.nearing_beyond`, `Optimum.nearing_as_rising`; witness `Topped.out_of_reach`).
   - So the chooser escapes only at its set point.
2. *"Escapes the drain": only the drive, not the draw.*
   - At its set point what lies beyond is what reaching the set point leaves (`Optimum.least_at_iff`).
   - On a step that loses nothing, that is exactly the shortfall (`Flow.Balances.settled_draws`), and a dependence beyond breaks exactly where the shortfall exceeds the slack (`Flow.Balances.settled_broken_iff`, `Drain.kept_iff`, `Drain.nearing_breaks`).
   - Where the step can lose what it takes, the order protects nothing: a draining outcome is an optimum beside the keeping one (`Topped.nearing_either`), as for an order rising only to a target (`Drain.satisficing_either`).
   - A point of enough bounds the draw by the shortfall only where the exchange conserves.
3. *Joint excess: holds, in two forms.*
   - At one step: `Flow.Balances.mutual_settled_breaks`, witness `TwoStores.jointly_broken`.
   - Over a course: `Flow.held_excess_ends`, witness `HeldPair.held_end`.
   - The mechanism is `Flow.held_draws`: a holder's draw on what it shares is its loss.
4. *"Not through maximization": wrong as stated.* The agents drain through maximization below their set points.
5. *Not in the reading: what keeps at the set point.* A term counted after the set point keeps what lies beyond (`Optimum.counted_after_most`, `Topped.counted_after_keeps`). The same term counted after a rising order keeps nothing (`Drain.counted_after_drains`). It works only at the set point.

**Corrected wording** [AI reading]:

> 3. **A chooser with set points escapes the optimizer's drive at its set point, not the drain below it, nor the commons.** Where preferences are characteristic states, the order has a point of enough and is not rising (`Optimum.not_rising_of_enough`). Below its set point it rises with what couples in, and its optima drain as a maximizer's do: to the least level beyond where room holds up to the set point, by the whole capacity in an exchange (`Optimum.least_below`, `Optimum.nearing_beyond`). Where the set point is within reach, every optimum stands at it (`Optimum.settled`), and the order no longer drives what lies beyond (`Optimum.least_at_iff`). On a step that loses nothing, what lies beyond falls by exactly the shortfall with the loss (`Flow.Balances.settled_draws`), so a dependence there breaks exactly where the shortfall exceeds the slack (`Flow.Balances.settled_broken_iff`). Where the step can lose what it takes, nothing protects it (`Topped.nearing_either`). Holding its set point, the chooser draws what it loses (`Flow.held_draws`). Several such choosers, each within what a condition renews, end it together, and none couples into it (`Flow.held_excess_ends`; at one step `Flow.Balances.mutual_settled_breaks`). On this reading the principle's agents drain through maximization below their set points, through joint excess and through capture. At their set points they are undriven, not protective, and what keeps there is a preference counted after the set point (`Optimum.counted_after_most`).

## 4. What is not derived

- **The correspondence with the free-energy principle is a reading.**
  - That an agent's preferences form a nearing order is not derived. They do where the preference falls with the distance from its mode at each observed condition. One whose best level at a condition depends on the others, or that is not single-peaked at each, is not nearing.
  - No probability, surprisal, expected free energy, epistemic term or precision appears. Optima are the high-precision limit, as for `choose` in `Becoming.HabitCapture`.
- **Supplied wherever they enter:** which outcomes are eligible, whether one reaches the set point, and room up to it.
- **Optima not stated.**
  - Where no eligible outcome reaches the set point and some stand above it.
  - In an exchange, the optima at the set point (beyond the `Topped` witness) and above it.
- **Several optimizers at once.** The outcomes eligible to each are supplied as those it can bring about with the others as they are. They are not read off an exchange, as `Optimum.MutualBest` does for rising orders.
- **Holders over a course.** That a formation exchanges alone with its family, holds it at every step, and loses what it loses is supplied. Holding is what every nearing optimum does where the set point can be reached (`Optimum.settled`).
- **Re-optimizing over a renewal.** The analogue of `Web.course_lost_iff` (lost exactly where the joint loss exceeds the renewal, kept within it) is not stated.
- **Where set points come from.** Whether a set point is itself selected, or shaped by what it selects (capture), is not treated.
- **Representation.** Discrete steps and natural amounts. No ethical predicate, ranking or axiom occurs.

## 5. Placement, reuse, names

- **A leaf, with a reason** (board rule 9). Its laws are cases of laws below it under one class of orders:
  - `Optimum.least_iff`;
  - `Optimum.optimum_beyond`, through `Optimum.Above.transfer`;
  - `Flow.Balances.beyond_falls_exactly` and `Flow.Balances.breaks_beyond`;
  - `Flow.joint_excess_ends`.

  UE1's containment of the free-energy principle reads it. `Becoming.HabitCapture` could import it when UE1's records land.
- **Generalize below.** `Optimum.Above.full_of_ranked`, `Optimum.Above.floor_or_full_of_ranked` and `Optimum.beyond_of_ranked` generalize Optimum's `Above.full`, `Above.floor_or_full` and `optimum_beyond`. Their hypothesis is that the order ranks the one-unit transfer above, not that it rises.
  - Until landing, this module carries three proofs parallel to Optimum's.
  - Under rule 9 the three general forms belong in `Becoming.Optimum`, with the rising laws derived from them and their direct proofs removed. That changes proofs, not statements, in a shared module, so Optimum's owner decides it.
- **Reused rather than rebuilt:**
  - from `Becoming.Optimum`: `Exceeds`, `Rising`, `Room`, `Least`, `Frontier`, `Above`, `Flow.Outcome`, `Flow.ActsWithin`, `total_split`, `Optimum.sub_le_sub_left_of_le`, and the worlds `Drain`, `TwoTakers.Member` and `Diversion`;
  - elsewhere: `gap` and `gap_eq_zero_iff` (Propagation), `Regulation.gap_of_ge`, `Requirement.Formation.sub_lt_sub_of_lt`, `total_le_at` (Dissipation), `Witnesses.Member`, `Witnesses.profile`.
  - Importing `Becoming.Regulation` adds that module to the closure, which fits: a set point is regulation's `m`, read as an order.
- **Names.**
  - "Set point" is the control-systems term.
  - `Nearer` and `Nearing` pair with `Exceeds` and `Rising`.
  - "Hold" follows Optimum's holding a level. The part predicate is `holding`, and the course witness `HeldPair`.
  - No name is dualist, social or a person's.
  - The new names were checked against every module of the package: none collides. `settled`, `gap_of_le` and `kept_iff` exist only in other namespaces, and the module's own `gap_of_le` was dropped for `Regulation.gap_of_ge`.

## 6. Open issues

- **Review.** An independent review before landing, as for UE1's kit.
- **Record and home section.** Suggested: a row in 05 §7's table of cases ("set-point orders": the drive below the set point, the draw at it, the commons), with a record of its own. The name is decided at landing.
- **The frozen test.** UE1's frozen test (UE1 note, §7(c)) can carry a prediction from this law, fixed before the run. An active-inference agent with single-peaked preferences over an observed store, sharing a renewed source with a dweller:
  - it keeps the dweller where it cannot discard and its shortfall is within the slack;
  - it does not keep it where it can discard;
  - a preference on the source counted after the store keeps it.
- **Re-optimizing over a renewal.** The course analogue for re-optimizing set-point choosers against a renewal (`Web.course_lost_iff`'s case) is the next law if UE1's readings need it.
