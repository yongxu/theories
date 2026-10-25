# UE1b, part 1: set-point orders and the optimum (note)

25 October 2026. AI-authored note for board item UE1b (UE1's open item (b)). It tests reading 3 of the [UE1 note](../ue1-fep-bridge/NOTE.md) (§5).

In active inference an agent's preferences are its characteristic states: it ranks outcomes by closeness to a set point, so it has a point of enough. The question is twofold. Does the optimum law of 05 ([what an optimum does beyond what couples in](../../../../../../theories/becoming/chapters/05-COLLECTIVES.md#r-what-an-optimum-does-beyond-what-couples-in)) spare such a chooser? And does joint excess ([own count misses joint excess](../../../../../../theories/becoming/chapters/05-COLLECTIVES.md#r-own-count-misses-joint-excess)) still end what several such choosers draw on?

**Revised after the independent review** ([REVIEW-UE1b.md](REVIEW-UE1b.md): 2 errors, 6 overclaims, 8 imprecisions, 3 suggestions). Every finding was taken (§6). The Lean changed in four ways:

- "nearer" is now read by betweenness;
- the `settled` family is renamed;
- the exact statements the review asked for are added, with witnesses for its counterexamples;
- the three duplicated exchange laws moved into a kit copy of `Becoming.Optimum`, as board rule 9 asks.

The text now says what the Lean proves.

**Re-checked** (the re-check appended to the review): every finding addressed, one suggestion in part. Its new points are taken here:

- four docstrings the rename to `holders` had garbled now read "holding";
- "strictly single-peaked" throughout, with a tolerance band listed as not nearing;
- "where the family holds a condition" wherever no nearing order is said to rise;
- two docstring nits (`counted_after_most`, `held_excess_ends`);
- LANDING's re-points and board row.

The landing scripts are in this folder ([LANDING.md](LANDING.md), §7).

- **Kit.**
  - `Becoming.SetPointOptimum`, [tree/Becoming/SetPointOptimum.lean](tree/Becoming/SetPointOptimum.lean): pure core, importing `Becoming.Optimum` and `Becoming.Regulation` only.
  - [tree/Becoming/Optimum.lean](tree/Becoming/Optimum.lean): the landed `Optimum` with the rule 9 refactor (§5).
- **Build** ([scratch.log](scratch.log)), one scratch build of `Optimum`, `SetPointOptimum`, `RegimeMargin` (`Optimum`'s only importer) and the root module `Becoming`, 323 modules in the closure:

  | Module | Theorems | Declarations |
  |---|---|---|
  | `Optimum` | 506 (was 503) | 637 (was 634) |
  | `SetPointOptimum` | 82 (was 69) | 124 (was 100) |
  | `RegimeMargin` | 246 | 336 |

  The root module compiles. `unclean` is empty and every axiom report is empty. The refactored `Optimum` was restored from the shared cache, so it is byte-identical to the tree the review tested.
- **Statements unchanged.** No statement of `Optimum` or `RegimeMargin` changes. Declaration types were printed as Lean expressions from the landed and the refactored builds and compared (scratch.log §3, with the script):
  - `Optimum`: all 1054 constants common to both have byte-identical types. The only constants not carried over are three compiler-generated matchers of the old proofs.
  - `RegimeMargin`: all 546 are identical.
  - The three moved theorems are alpha-identical to the versions in the reviewed kit.

Results go to their records and home sections when they land, not here. What the landing needs is in [LANDING.md](LANDING.md).

## 1. The answer in brief

A set point removes the drive of the class beyond what couples in. It does not remove the draw, and on its own it does not protect.

- **Below its set point** an order nearing a set point rises with what couples in. Its optima drain as a maximizer's do: to the least level beyond where room holds up to the set point, and by the part's whole capacity in an exchange.
- **At its set point**, where an eligible outcome reaches it, every optimum stands there. Nearing then puts no constraint on what lies beyond: an outcome is an optimum of some nearing order exactly where it is eligible and at the set point.
  - In a balanced step in which the whole gains nothing, the beyond falls by exactly the family's shortfall from its set point with what the step loses.
  - With one condition beyond, its dependence breaks exactly where that exceeds its slack.
  - Where the step can lose what it takes, the order by distance has the draining step among its optima beside the keeping one.
- **What protects at the set point is how the choice among equal optima is made.** A term on what lies beyond, counted after the set point, leaves it, in total, at the most any way of reaching the set point leaves; counted with the other sign, it drains. The same holds after an aspiration level. After a rising order, with room, the term changes nothing. The contrast comes from the plateau, not the set point.
- **Joint excess applies, and needs no choice.** A formation alone with its family, holding the family's stock, takes at least its loss from what it shares. Several so holding end a gated condition where their losses together exceed what the rest gives it, however small each one's loss.

## 2. What is proved, theorem by theorem

Names are in `Becoming`. "Lemma" marks a helper that carries no claim of its own.

**Definitions.**

- `Optimum.gapTo s o`: the gap at each condition (`gap` of `Becoming.Propagation`).
- `Optimum.Nearer ds s o' o`: at each condition of the family, `o'` lies between the set point and `o` (`Regulation.Between`: on `o`'s side of the set point and no farther), and at one it is strictly nearer.
- `Optimum.Nearing ds s better`: the order ranks above every nearer outcome, the analogue of `Optimum.Rising`.
- `Optimum.AtSetPoint`, `Optimum.UpToSetPoint`.
- `Optimum.byGap`: a smaller total gap ranks above.
- `Optimum.byGapThen`: by gap, then more beyond in total. `Optimum.byGapLess`: by gap, then less beyond in total.

**Orders nearing a set point (any outcomes, any orders).**

- `Optimum.setPoint_between`, `Optimum.Nearer.gaps`, `Optimum.gapTo_eq_zero`, `Optimum.total_gapTo_eq_zero`, `Optimum.atSetPoint_single`, `Optimum.nearer_of_atSetPoint`: lemmas.
- `Optimum.nearing_of_gaps`: an order ranking above every outcome no farther from the set point at each condition and nearer at one, the two sides alike, is nearing.
- `Optimum.byGap_nearing`: the order by total gap is nearing.
- `Optimum.Nearing.mono`: an order ranking above wherever a nearing order does is nearing.
- `Optimum.byGap_unbeaten_at`: no outcome ranks above one at the set point by distance.
- `Optimum.atSetPoint_frontier`: an eligible outcome at the set point is an optimum of the order by distance.
- `Optimum.not_rising_of_unbeaten`: an order under which some outcome is ranked below none is not rising, where the family holds a condition.
- `Optimum.byGap_not_rising`: the order by distance is not rising.
- `Optimum.Nearing.not_rising`: no nearing order that never ranks two outcomes above each other is rising, where the family holds a condition.
- `Optimum.byGapThen_asymm`, `Optimum.byGapThen_not_rising`: the order by distance with the beyond counted after never ranks two outcomes above each other, so it is not rising, where the family holds a condition. This reaches an order `not_rising_of_unbeaten` does not, since its hypothesis asks for an outcome ranked below none.
- `Optimum.atSetPoint_iff`: every nearing order has all its optima at the set point exactly where no eligible outcome off it goes unbeaten (doubly negated) by a nearer eligible one.
- `Optimum.atSetPoint_of_reach`: where some eligible outcome stands at the set point, every optimum of every nearing order does, whatever the room.
- `Optimum.mutual_atSetPoint`: where the levels are, for each of several optimizers, an optimum of its nearing order among outcomes eligible to it, one of them at its set point, the levels stand at the set point on every family theirs cover.
- `Optimum.optima_iff`: where some eligible outcome stands at the set point, an outcome is an optimum of some nearing order exactly where it is eligible and at the set point.
- `Optimum.least_at_iff`: where the set point can be reached, every optimum of every nearing order stands beyond at the least level among the eligible outcomes at the set point exactly where those outcomes all stand alike beyond. This is a statement about the class.
- `Optimum.byGapThen_nearing`, `Optimum.byGapLess_nearing`: both orders are nearing.
- `Optimum.counted_after_most`: where the set point can be reached, every optimum of `byGapThen` stands at the set point and leaves the beyond, in total, at least where every eligible outcome at the set point does.
- `Optimum.counted_after_keeps_iff`: with one condition beyond, such an optimum meets a need there exactly where some eligible outcome at the set point does.

**Below the set point, a nearing order rises.**

- `Optimum.sub_le_sub_iff`, `Optimum.sub_lt_sub_iff`, `Optimum.gapTo_of_upTo`: lemmas.
  - The first two are the converses, within a bound, of `Optimum.sub_le_sub_left_of_le` and `Requirement.Formation.sub_lt_sub_of_lt`.
  - The gap is read by `Regulation.gap_of_ge`.
- `Optimum.nearer_iff_exceeds`: for outcomes up to the set point, nearer exactly where higher on the family.
- `Optimum.Nearing.rises_below`: among outcomes up to the set point, a nearing order ranks above every exceeding outcome.
- `Optimum.least_below_iff`: among the eligible outcomes up to the set point, every nearing order has its optima at the least level beyond among them exactly where the (doubly negated) room condition holds among them. It is derived from `Optimum.least_iff`.
- `Optimum.least_below`: with room up to the set point, every nearing optimum among those outcomes stands at the least level beyond among them. Room up to the set point fails at an outcome at the set point standing above another beyond, so the law bites where the set point is out of reach.

**What reaching the set point draws (World: balance; the whole gaining nothing across the step).**

- `Flow.Balances.atSetPoint_draws`: with the family at its set point after the step, `stock rest (t+1) + lost + total ds s = stock ds t + stock rest t`. It is derived from `Flow.Balances.beyond_falls_exactly`.
- `Flow.Balances.held_draws_lost`: at the set point before and after the step, `stock rest (t+1) + lost = stock rest t`.
- `Flow.Balances.atSetPoint_breaks`: each condition beyond depended on at a need it meets, `stock ds t + slack < total ds s + lost` breaks some such dependence. It is derived from `Flow.Balances.breaks_beyond`. It is sufficient, not necessary: with several conditions beyond, the draw's total is fixed, not its spread.
- `Flow.Balances.atSetPoint_broken_iff`: with one condition `c` beyond, the dependence breaks exactly where `stock ds t + (level t c − need) < total ds s + lost`.
- `Flow.nearing_optimum_draws`: every optimum of a nearing order whose set point an eligible outcome reaches satisfies the identity of `atSetPoint_draws`.
- `Flow.Balances.mutual_atSetPoint_draws`: several nearing optimizers, each reaching its set point, draw the joint set point's shortfall with the loss, as one optimizer with their joint set point.
- `Flow.Balances.mutual_atSetPoint_breaks`: there, a dependence beyond breaks where the joint shortfall with the loss exceeds the slack, whatever each one's own shortfall.

**In an exchange (`Flow.Outcome`: one step, capacities).**

- `Optimum.transfer_nearer`: a unit moved from outside the family into a family condition below its set point gives a nearer outcome.
- `Optimum.nearing_beyond`: every optimum of every nearing order standing below its set point at some family condition stands at each condition beyond at `l c + restGiven − restTaken − capacity`, or at nothing. It is derived from `Optimum.beyond_of_ranked`, now in `Optimum`.
- `Optimum.nearing_as_rising`: that is where every optimum of every rising order stands (`Optimum.optimum_beyond`).

**Formations holding their levels: joint excess (World: balance, activity needing support, only active giving; the gate local).**

- `Optimum.total_le_of_only`: lemma, from `total_le_at`.
- `Optimum.stock_eq_of_atSetPoint`: a family at its set point at two steps holds its stock between them.
- `Flow.held_draws`: where the flow balances on a formation's family, the formation alone exchanges with it, and the family's stock after the step is its stock before, the formation takes from a condition `c` at least what it gives there with what it loses on its family with `c`.
- `Flow.held_excess_ends`: the members of a part hold their families' stocks across `n` steps from `T`, each alone with its family. Their losses together exceed at each step what the formations outside the part give `c`, and the level of `c` starts below `n + m`. Then, under the gate at need `m`, every formation depending on `c` at a need of at least `m` is inactive from `T + n` on, however small each member's loss. Where each member's couplings lie in its family, apart from `c`, no member couples into `c` (a restatement of those two hypotheses). It is derived from `Flow.joint_excess_ends`. No order, eligibility or optimum enters.

**Witnesses.**

- `Drain.storedAt_split`: lemma.
- `Drain.atSetPoint_source`: among the splits of three units, every optimum of every order nearing a store of `k ≤ 3` leaves the source at `3 − k`.
- `Drain.kept_iff`: there, the dweller's need of two is met exactly where `k ≤ 1`, the slack.
- `Drain.nearing_keeps`: room holds among the splits. Every optimum of every order nearing a store of one leaves the source at two, and the order by distance has such an optimum. Every optimum of every rising order leaves the source at zero.
- `Drain.nearing_breaks`: nearing a store of two, every optimum leaves the source at one, below the need.
- `Drain.satisficingThen_keeps`: the aspiration level at a store of one, with the source counted after, has every optimum among the splits leave the source at two.
- `Topped.idle_open`, `Topped.discarding_open`, `Topped.store_le_two`: lemmas.
- `Topped.nearing_either`: from a store already at its set point of one, every optimum of every nearing order stands at one. The step exchanging nothing (source two, at the dweller's need of two) and the step taking a unit and losing it (source one, below it) are both optima of the order by distance.
- `Topped.rising_drains`: every rising optimum leaves the source at one. It is derived from `Optimum.optimum_beyond`.
- `Topped.counted_after_keeps`: every optimum of `byGapThen` meets the dweller's need. It is derived from `Optimum.counted_after_most`.
- `Topped.counted_less_drains`: every optimum of `byGapLess` leaves the source at most at one, below the need.
- `Topped.weighted_keeps`: under every positive weight `w`, every optimum of the order ranking by `w` times the source less the store's gap meets the need.
- `Topped.out_of_reach`: every optimum of every order nearing a store of three, which no open outcome reaches, leaves the source at one, as every rising optimum does. It is derived from `Optimum.nearing_beyond`.
- `Spread.counted_after_empties`: with two conditions beyond and two ways of reaching the set point, every optimum of `byGapThen` empties the first, while the other way leaves one at each.
- `Skew.nearing`, `Skew.not_by_gaps`: the order by a cost of three per unit over a set point of two and one per unit under is nearing. It does not fall with the distance alike on both sides.
- `TwoStores.balances`, `TwoStores.gainless`: lemmas.
- `TwoStores.best`: each taker's step is an optimum of its order by distance among the outcomes eligible to it.
- `TwoStores.jointly_broken`: each taker's shortfall is within the slack of one, and the dweller's dependence is broken. It is derived from `Flow.Balances.mutual_atSetPoint_breaks`.
- `HeldPair.balances`, `acting`, `dependent`, `gated`, `members_distinct`, `distinct`, `alone`, `held`, `loses`, `exceeds`, `listed`, `apart`: lemmas, the course law's hypotheses.
- `HeldPair.within`: across the first two steps each holder takes within what the pool is given, and together they take more.
- `HeldPair.held_end`: the renewal, and every formation depending on the pool at need one, is inactive from step two on, and neither holder couples into the pool. It is derived from `Flow.held_excess_ends`, with the stores' set point giving the held stocks (`Optimum.stock_eq_of_atSetPoint`).

## 3. Reading 3: does it hold as written?

As first written in the UE1 note: "A chooser with set points escapes the optimizer's drain, not the commons. … The optimum's drain beyond its couplings needs an order rising with what couples in, so it does not apply to such a chooser as such. Joint excess does … On this reading the principle's agents drain through joint excess and through capture, not through maximization."

**Verdict: it holds in part.** The review confirmed the verdict and corrected its wording.

1. *"It does not apply to such a chooser as such": wrong.*
   - No asymmetric nearing order rises with what couples in, where the family holds a condition (`Optimum.Nearing.not_rising`), so `least_of_room` does not apply to it as stated.
   - But below its set point a nearing order rises (`Optimum.nearer_iff_exceeds`, `Optimum.Nearing.rises_below`), and the drain applies there exactly (`Optimum.least_below_iff`).
   - In an exchange it takes the whole capacity, as a rising order does (`Optimum.nearing_beyond`, `Optimum.nearing_as_rising`; witness `Topped.out_of_reach`).
2. *"Escapes the drain": the class escapes the drive at the set point, not the draw.*
   - Where the set point can be reached, nearing puts no constraint on what lies beyond (`Optimum.optima_iff`).
   - In a balanced step in which the whole gains nothing, the beyond falls by exactly the family's shortfall from its set point with what the step loses (`Flow.Balances.atSetPoint_draws`). With one condition beyond, its dependence breaks exactly where that exceeds its slack (`Flow.Balances.atSetPoint_broken_iff`, `Drain.kept_iff`). With several, some dependence breaks where it exceeds their total slack (`Flow.Balances.atSetPoint_breaks`).
   - Where the step can lose what it takes, the set point alone does not protect what lies beyond (`Topped.nearing_either`).
3. *Joint excess: holds, for any formations holding their levels.*
   - At one step for nearing optimizers: `Flow.Balances.mutual_atSetPoint_breaks`, witness `TwoStores.jointly_broken`.
   - Over a course, for any formations holding their families' stocks: `Flow.held_excess_ends`, witness `HeldPair.held_end`.
   - Each holder takes at least its loss (`Flow.held_draws`).
   - No choice enters. That the holders are nearing choosers re-optimizing at every step is a reading through `Optimum.atSetPoint_of_reach`.
4. *"Not through maximization": wrong as stated.* The agents drain through maximization below their set points.
5. *What protects at the set point is the choice among equal optima.*
   - A term on what lies beyond counted after the set point decides within the plateau of ways of reaching it.
   - Counting more beyond, it leaves the most, in total, that any such way leaves (`Optimum.counted_after_most`). With several conditions beyond that can empty one of them (`Spread.counted_after_empties`).
   - Counting less, it drains (`Topped.counted_less_drains`).
   - An aspiration level with the same term keeps as well (`Drain.satisficingThen_keeps`). Counted after a rising order, with room, the term changes nothing (`Optimum.Rising.mono`, `Optimum.least_of_room`).

**Corrected wording** [AI reading]:

> 3. **A chooser with set points escapes the optimizer's drive at its set point, not the drain below it, nor joint excess.** An order nearing a set point is strictly single-peaked there at each observed condition, each peak not depending on the others and each side weighed as it may be (`Optimum.Nearing`), and, where the family holds a condition, no asymmetric such order rises with what couples in (`Optimum.Nearing.not_rising`).
>
> Below its set point it rises with what couples in, and its optima drain as a maximizer's do: with room up to the set point, to the least level beyond among the outcomes up to it (`Optimum.least_below`); in an exchange, by the part's whole capacity at every condition beyond (`Optimum.nearing_beyond`).
>
> Where an eligible outcome reaches the set point, every optimum stands at it (`Optimum.atSetPoint_of_reach`). The class then asks nothing more: an outcome is an optimum of some nearing order exactly where it is eligible and at the set point (`Optimum.optima_iff`). In a balanced step in which the whole gains nothing, the beyond falls by exactly the family's shortfall from its set point with what the step loses, and rises where the family stood above it (`Flow.Balances.atSetPoint_draws`). With one condition beyond, its dependence breaks exactly where that exceeds its slack (`Flow.Balances.atSetPoint_broken_iff`). With several, some dependence breaks where it exceeds their total slack (`Flow.Balances.atSetPoint_breaks`).
>
> Where the step can lose what it takes, the set point alone does not protect what lies beyond: the order by distance has the draining step among its optima beside the keeping one (`Topped.nearing_either`). What protects there is how the choice among the ways of reaching the set point is made. A term on what lies beyond counted after the set point leaves it, in total, at the most any eligible way of reaching the set point leaves (`Optimum.counted_after_most`). With one condition beyond, that term keeps a need there exactly where some such way keeps it (`Optimum.counted_after_keeps_iff`); with several, it can empty one of them (`Spread.counted_after_empties`). Counting less beyond, a nearing order drains (`Topped.counted_less_drains`). The contrast with maximizers belongs to the plateau, not the set point: counted after a rising order with room, the term changes nothing (`Optimum.Rising.mono`, `Optimum.least_of_room`), and counted after an aspiration level it keeps as well (`Drain.satisficingThen_keeps`).
>
> A formation alone with its family, holding the family's stock across a step, takes from a condition at least what it loses on its family with that condition (`Flow.held_draws`). Several formations so holding end the condition under the gate at need `m`, however small each one's loss, where their losses together exceed what the rest gives it at each of `n` steps and its level starts below `n + m`. Where each one's couplings lie in its family, apart from the condition, none couples into it (`Flow.held_excess_ends`). No choice enters that law. A nearing chooser holds its family wherever, at each step, an eligible outcome reaches its set point (`Optimum.atSetPoint_of_reach`); the course of choices is not formalized.
>
> On this reading the principle's agents drain through maximization below their set points, through joint excess and through capture. At their set points the class is undriven, and whether what lies beyond is kept depends on how the choice among equal optima is made.

## 4. What is not derived

- **The correspondence with the free-energy principle is a reading.**
  - That an agent's preferences form a nearing order is not derived. They do where the preference is strictly single-peaked at the set point at each observed condition, each peak not depending on the others, either side weighed as it may be.
  - A preference indifferent within a tolerance band around the set point, common in homeostasis, is not nearing: the band is a two-sided aspiration level, and the plateau's results apply to it instead.
  - One whose best level at a condition depends on the levels at others is not nearing. `Nearer` is still read condition by condition, though no longer symmetric in distance.
  - No probability, surprisal, expected free energy, epistemic term or precision appears. Optima are the high-precision limit, as for the counted choice of `Becoming.ChoiceCountCapture`.
- **Supplied wherever they enter:** which outcomes are eligible, whether one reaches the set point, and room up to it.
- **Optima not stated.**
  - Where no eligible outcome reaches the set point and some stand above it.
  - In an exchange, the optima at the set point beyond the `Topped` witnesses, and above it.
- **The choice among optima.** Which optimum is taken where several stand at the set point is not treated. It decides keeping wherever a step can lose what it takes.
- **Lexicographic terms.** Terms counted after the set point are lexicographic. With continuous amounts or finite precision exact ties are rare, and a weighted term trades against the set point instead. `Topped.weighted_keeps` is one weighted case, in one world.
- **Several optimizers.**
  - They share one set point on shared conditions; conflicting set points are not treated.
  - The outcomes eligible to each are supplied as those it can bring about with the others as they are, not read off an exchange as `Optimum.MutualBest` does for rising orders.
- **Holders over a course.** That formations hold their levels, exchange alone with their families and lose what they lose is supplied.
- **One step, deterministic.** Every law is of one step or of supplied courses. Under noise over a horizon, a set point on later states makes reserves worth holding: a buffer lowers the chance of a later shortfall, so a rising drive on stores can return.
- **Where set points come from.** Whether a set point is itself selected, or shaped by what it selects (capture), is not treated.
- **Representation.** Discrete steps and natural amounts. No ethical predicate, ranking or axiom occurs.

## 5. Placement, the Optimum change, reuse, names

- **A leaf, with a reason** (board rule 9). The module's laws are cases of laws below it, read on one class of orders:
  - `Optimum.least_iff`;
  - `Optimum.beyond_of_ranked`;
  - `Flow.Balances.beyond_falls_exactly` and `Flow.Balances.breaks_beyond`;
  - `Flow.joint_excess_ends`.

  UE1's containment of the free-energy principle reads it. `Becoming.ChoiceCountCapture` could import it, though nothing needs it to.
- **The rule 9 refactor of `Optimum`, done in the kit copy.**
  - `Optimum.Above.full_of_ranked`, `Optimum.Above.floor_or_full_of_ranked` and `Optimum.beyond_of_ranked` moved verbatim, docstrings included, from the kit into [tree/Becoming/Optimum.lean](tree/Becoming/Optimum.lean):
    - the first two immediately before `Above.full` and `Above.floor_or_full`;
    - the third after `above_nothing`, which it uses.
  - `Above.full`, `Above.floor_or_full` and `optimum_beyond` are now two-line corollaries: each passes `rising _ _ (transfer_exceeds (apart c mem) inside o)` as the ranked unit.
  - `Optimum`'s docstring names the one law under the bullet *Every optimum beyond, exactly*. It names no module above `Optimum`.
  - The three were deleted from the kit, whose `nearing_beyond` now calls `Optimum.beyond_of_ranked`.
  - No statement changes: no name, binder, order of hypotheses or conclusion (scratch.log §3).
  - `Optimum` gains three theorems and three declarations; the kit loses them.
- **The decision to land it.** Optimum's owner is inactive. So the lander, the briefing session, decides to land the refactor, as board rule 9 asks: the general law lands below its special cases, in `Optimum` itself, and the rising laws become its corollaries. This note records the decision; the landing carries it out (LANDING.md).
- **Reused rather than rebuilt:**
  - from `Becoming.Optimum`: `Exceeds`, `Rising`, `Room`, `Least`, `Frontier`, `Above`, `Flow.Outcome`, `Flow.ActsWithin`, `total_split`, `Optimum.sub_le_sub_left_of_le`, and the worlds `Drain`, `TwoTakers.Member` and `Diversion`;
  - from `Becoming.Regulation`: `Between`, its `gap_le` and `refl`, `gap_of_le`, `gap_of_ge`. The order is built on regulation's relation of no overshoot.
  - elsewhere: `gap` and `gap_eq_zero_iff` (Propagation), `Requirement.Formation.sub_lt_sub_of_lt`, `total_le_at` (Dissipation), `Witnesses.Member` and `Witnesses.profile`.
- **Names.**
  - "Set point" is the control-systems term.
  - `Nearer` and `Nearing` pair with `Exceeds` and `Rising`.
  - The `settled` family is renamed `atSetPoint_iff`, `atSetPoint_of_reach`, `mutual_atSetPoint`, `Flow.Balances.atSetPoint_draws`, `atSetPoint_breaks`, `atSetPoint_broken_iff`, `mutual_atSetPoint_draws`, `mutual_atSetPoint_breaks` and `Drain.atSetPoint_source`. In the package, "settle" means a run or a regulated level coming to rest.
  - `not_rising_of_enough` and `byGap_enough` are renamed `not_rising_of_unbeaten` and `byGap_unbeaten_at`. "Enough" is the boundary of `Becoming.Enough`.
  - The part predicate is `holders`, which no longer shadows `Optimum.holding`.
  - No name is dualist, social or a person's, and none collides in the package.

## 6. The review, finding by finding

| # | Finding | Taken how |
|---|---|---|
| 1 | Error: "nothing protects", refuted by `Topped.counted_after_keeps` | §1, §3 and the module docstring say the set point *alone* does not protect, and that a term counted after it does. UE1's correction text is in LANDING.md. |
| 2 | Overclaim: `counted_after_most` maximizes the total only | Stated so everywhere. Added `Optimum.counted_after_keeps_iff` and `Spread.counted_after_empties`. |
| 3 | Overclaim: the contrast comes from the plateau | Stated as the review proposes. Added `Drain.satisficingThen_keeps` (aspiration level), `Optimum.byGapLess` and `Topped.counted_less_drains` (the sign). |
| 4 | Overclaim: "no drive" holds of the class | Added `Optimum.optima_iff`. The `least_at_iff` docstring says it is a statement about the class. |
| 5 | Overclaim: no choice in joint excess; "at least"; a restated hypothesis | `Flow.held_draws` and `Flow.held_excess_ends` now take held stocks, with no set point. Added `Optimum.stock_eq_of_atSetPoint`. The text says "at least" and marks "none couples" as hypotheses. |
| 6 | Overclaim: "exactly" needs one condition beyond | Stated with one condition (`atSetPoint_broken_iff`), several (`atSetPoint_breaks`, sufficient only), the loss and the sign. |
| 7 | Overclaim: the frozen test | §7 rewritten. Added `Topped.weighted_keeps` for the weighted form. |
| 8 | `Nearing` symmetric in distance | `Nearer` redefined by `Regulation.Between`; every law carries over (§2). Added `Optimum.nearing_of_gaps`, `Skew.nearing` and `Skew.not_by_gaps`. |
| 9 | `not_rising_of_enough` misses `byGapThen` | Added `Optimum.Nearing.not_rising`, `byGapThen_asymm` and `byGapThen_not_rising`. |
| 10 | `Topped.nearing_either`'s headline; the dweller read | The headline is "the order by distance"; §2 says "at the need … below it". |
| 11 | `mutual_settled_breaks`'s headline | Now "Together past the slack, whatever each one's shortfall". |
| 12 | One set point for all optimizers | Listed in §4 and in the module's list of what is not derived. |
| 13 | Four omissions | One step, the choice among optima, lexicographic terms and the definitions are listed in §4 and in the module docstring. |
| 14 | Stale references | `Becoming.ChoiceCountCapture`. |
| 15 | "Settled" | Renamed as the review tabulates. |
| 16 | "Enough" | Renamed: `not_rising_of_unbeaten`, `byGap_unbeaten_at`. |
| 17 | Placement and small duplicates | `holders` renamed. `total_le_of_only` derives from `total_le_at`, as before. Moving `Weightings.total_le_at_on`, the prelude lemmas and a shared `transfer` evaluation are left to their owners (LANDING.md, optional). |
| 18 | Error: three proofs beside `Optimum`'s (rule 9) | Refactor applied in the kit copy and built, with no statement changed (§5). |
| 19 | Additions | `optima_iff`, `counted_after_keeps_iff` and `Nearing.not_rising` added. Generalizing `MutualBest.full` and `mutual_beyond` is left to Optimum's owner (LANDING.md, optional). |

## 7. Open issues

- **The frozen test** (UE1 note, §7(c)). An active-inference agent with strictly single-peaked preferences over an observed store shares a renewed source with a dweller. What the law predicts, fixed before the run:
  - where it cannot discard and its shortfall is within the slack, it keeps the dweller (`Drain.kept_iff`);
  - where it can discard, keeping is not implied. The discarding policy is as good as idling (`Topped.nearing_either`), so the share of draining is the tie-break's: one half with a flat prior over the two policies, tilted by any habit or cost of acting. A keeping agent would not refute the law, and a draining one would show only that ties exist;
  - with a weighted log-preference on the source, at any positive weight, it keeps (`Topped.weighted_keeps`). This is a weighted order, not the lexicographic `byGapThen`.
- **Re-optimizing over a renewal.** The course law for set-point choosers re-optimizing against a renewal (`Web.course_lost_iff`'s case) is the next law if UE1's readings need it.
- **Exchange-level mutual responses.** Several nearing optimizers below their set points could be read off an exchange by generalizing `MutualBest.full` and `mutual_beyond` as the refactor did the one-part laws. That is for Optimum's owner.
