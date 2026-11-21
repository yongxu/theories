# Routes

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Routes.lean`
- *result records that name this place's file as a source* (computed; not a link): `orders-as-a-sum-over-histories`, `sums-over-histories-by-support-horizon-and-order`, `two-act-worlds-carry-the-difference`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-17, as "Routes.lean: Weights.Hom.within, carried_eq_courses, finite_horizon_iff_no_loop" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-17.md.txt)); pass b: reader whole-b-65, as "Routes.lean: Weights.within, Weights.within_exact, Weights.Hom.within, routeSum_eq_carriedWithin, carried_eq_courses, finite_horizon_iff_no_loop, carried_le_routeSum_add, Routes.SelfLoop.within_eq" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-65.md.txt)); the third pass, where the two differed: reader whole-c-settle-25, as "Routes.lean: settled fields giving, both_outcomes, closed_region" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-25.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: The carried amount at t equals the counting sum over routes of t+1 steps (`carried_eq_courses`, l. 464). With all conditions listed, stationary strengths and fixed participants, every initial gap admits a horizon exact at c for all dates iff no upstream condition lies on a loop (`finite_horizon_iff_no_loop`, l. 500).
  - *pass b:* General: any sum over histories, each step's weight split into ground and response parts, expands by order (`Weights.within`). Each order is exact up to its own horizon and can be read through any weight homomorphism; for counting, the orders rise and are bounded by the whole sum. Propagation's carried amount is such a sum over routes back in time (order j is horizon j+1), a finite horizon is exact exactly where no loop lies upstream, and the self-loop's order j is Loops.orderSum, while the whole sum is (1+M)^n.
- **moves**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: moves are summed over as courses (`openSteps`, `courses`). There is no law of what a choice keeps.
- **a reading**
  - *pass a:* S: `Weights.Hom.within` (l. 118) carries the order-j weighted reading exactly through any weight homomorphism, mapping ground, response and terminal readings.
  - *pass b:* S, as a reading of weights: `Weights.Hom.within` (l. 118): a map keeping the laws of weights can be taken order by order. There is no observation class deciding anything.
- **a share**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a level that runs down**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: the carried levels of conditions (`carried`, `carriedFrom`) are differences carried, with no running down.
- **a giving that is itself a going-on**
  - *settled by the third pass:* S, in a weak form: `give_split` (l.358): for levels `l`, step `t`, condition `c`, the total over `present t` of `carriedGive cs part σ k t h c l` equals that total from zero levels plus the sum over steps and conditions of `respondAt part k present t c s d * l s d`. The givers are formations `h : F` listed in `present t`; `present : Nat → List F`, `k` and `σ` are section variables (l.353-354), handed in. No statement says a giver is lost by a law of the step. [which pass was right: both in part; opened: `give_split` (l.358) with the `variable` line l.353-354; `respondAt` (l.251); `responseWeight` (l.258); `carriedFrom_eq_routes` (l.390); opening account l.62 ('the strengths, which are supplied').]
  - *pass a:* S: `give_split` (l. 358) sums contributions of the formations present at t and splits that sum into the zero-level amount plus responses to levels. Changes in the list of givers are supplied by `present`.
  - *pass b:* N: what formations give (`give_split`, l. 358) uses formations `present t` and strengths `k` handed in. The opening account says the strengths are supplied and not derived.
- **a cost to the one that keeps or gives**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **multiplying**
  - *pass a:* N: `SelfLoop.transfer_eq` (l. 224) gives exponential growth of the weighted sum of courses. I found no offspring population in that law.
  - *pass b:* N for units. S for courses: `Routes.SelfLoop.transfer_eq` (l. 224): the self-loop's sum over histories is (1+M)^n, courses doubling around a loop where M = 1.
- **a point of no return**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **both outcomes**
  - *settled by the third pass:* N for going on and ending or keeping and losing. There is an exact 'iff' of another kind: `finite_horizon_iff_no_loop` (l.500): with `every : ∀ c, c ∈ cs`, stationary strengths `stationary K` and constant formations `fun _ => hs`, (for every `δ` some `j` makes `routeSum … t (j+1) (.level t c) = carried … t c` at every `t`) ↔ no `e` with `Upstream … e c` is `OnLoop`. It is about exactness of a finite horizon, not an outcome of a course. [which pass was right: both in part; opened: `finite_horizon_iff_no_loop` (l.500); `routeSum_exact` (l.471); `routeSum_le_carried` (l.483); `carried_le_routeSum_add` (l.490).]
  - *pass a:* N: Not found in the statements read.
  - *pass b:* S, not of going on and ending: `finite_horizon_iff_no_loop` (l. 500). With every condition listed, stationary strengths and fixed formations, some finite horizon of the route sum is exact at c, at every step and from every starting gap, iff no condition upstream of c lies on a loop.
- **a comparison between two**
  - *pass a:* S: `routeSum_mono` (l. 476) orders route sums by horizon for a date within the listed time range; `Weights.Hom.within` (l. 118) transports each order between weightings.
  - *pass b:* S: `routeSum_eq_carriedWithin` (l. 439): up to T, the route sum at horizon j+1 equals order j of the carried amount, two formulations shown equal. `carried_eq_courses` (l. 464). `Weights.Hom.within` (l. 118) carries orders across weightings.
- **a rank (an ending within a bound)**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N for ending within a bound. S for truncation bounds: `carried_le_routeSum_add` (l. 490): with starting gaps ≤ D and inflow ≤ M, horizon j+1 misses at most `Loops.missBound M D j t`. `routeSum_mono` (l. 476) and `counting_within_le_succ` (l. 152): the orders rise.
- **a closed region**
  - *settled by the third pass:* S, in a weak form: `routeSum_source` (l.417): for every `T` and `n`, `routeSum cs part σ k present δ T n .source = 1`, no premise beyond the section variables. The absorbing source is by definition in `routeWeight` (l.266): `.source → .source` weighs 1, `.source → .level` weighs 0. It is one absorbing point of the route points traced back, not a region of the model's configurations closed under its step. [which pass was right: both in part; opened: `routeWeight` (l.266); `routeSum_source` (l.417); `routeSum_level` (l.427); `routeRead` (l.275).]
  - *pass a:* S: `routeWeight` (l. 266) gives a source-to-source weight of one and zero to every level from the source; `routeSum_source` (l. 417) is one at every horizon.
  - *pass b:* N
- **forms change while the going on continues, or more can go on after**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **how it was read**
  - *pass a:* S: I read the opening account, all declaration statements and docstrings. S for states, reading, giving, comparison, closed_region. N for moves, share, level, cost, multiplying, no_return, both_outcomes, rank, forms_change.
  - *pass b:* From statements throughout (S or N). All statements were read (all 518 lines).
