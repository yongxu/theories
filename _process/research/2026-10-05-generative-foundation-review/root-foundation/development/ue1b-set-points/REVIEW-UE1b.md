# UE1b review: set-point orders and the optimum (25 October 2026)

This is an AI-authored independent review of board item UE1b, part 1, as committed at `e1427437c`. It covers two files:

- [NOTE.md](NOTE.md), sha256 `52b50c81…e5150ea`;
- [tree/Becoming/SetPointOptimum.lean](tree/Becoming/SetPointOptimum.lean), sha256 `c3ea2427…6bb2bbb`.

They were read with [AGENTS](../../../../../../AGENTS.md); rules 8 and 9 of the [work board](../../../../../BECOMING-WORKBOARD.md); chapter 05 §7, the [optimum law](../../../../../../theories/becoming/chapters/05-COLLECTIVES.md#r-what-an-optimum-does-beyond-what-couples-in) and [thesis T3](../../../../../../theories/becoming/chapters/05-COLLECTIVES.md#t3); §5 of the [UE1 note](../ue1-fep-bridge/NOTE.md); and the package modules `Optimum` (docstring, definitions, `least_iff`, *Room from the exchange*, the `Drain` witnesses, `MutualBest`), `Regulation` (`gap_of_le`, `gap_of_ge`, `Between`), `DrawnBeyond`, `Continuation` (`joint_excess_ends`), `Frontier`, `Dissipation`, `Weightings`, `Enough` and `Settling`.

**How it was checked.** All builds ran in scratch trees under the session scratchpad (`ue1b-review2/`, volatile), with `scratch_build.py` on the shared cache (Lean 4.29.1).

- **Rebuild.** The kit as committed gives 69 theorems in 100 declarations, with every axiom report empty, as the NOTE says. In the same run `Optimum` gives 503 in 634 and `RegimeMargin` 246 in 336. Every step was reused from the cache.
- **Refactor.** The rule 9 refactor was built and its statements compared. See [Rule 9 refactor](#rule-9-refactor).
- **Probe.** A module `Becoming.SetPointProbe` importing the kit gives 18 theorems in 29 declarations, with every axiom report empty. Its text is in the [appendix](#appendix-the-probe-module), sha256 `0fd459d7…76befae2`. "Probe" below refers to it.
- **The attempt cut off by the outage.** Its scratch (`ue1b-review/`) holds a refactor tree and lists of `#check` output. Nothing here relies on it. The refactor here was written independently and then diffed against that tree: the Lean is identical, and one docstring sentence differs (see the refactor section).
- **Sources.** Simon (1955), Taylor (2016), Friston and others (2016) and Keramati and Gutkin (2014) are cited from bibliographic knowledge. No source was fetched this round.
- No repository file other than this review was created or changed.

## Verdict

The Lean is sound: every statement proves what its docstring says apart from three headlines (findings 4, 10 and 11), and the laws derive cleanly from `Optimum`, `DrawnBeyond` and `Continuation`. The verdict on reading 3 is right: below its set point a nearing order rises and its optima drain as a maximizer's do, at its set point a balanced step in which the whole gains nothing draws the shortfall with the loss, and joint excess applies. But the corrected wording and the NOTE's summaries say more than the Lean in six places: "nothing protects" what lies beyond, which the kit's own `Topped.counted_after_keeps` refutes; a term counted after "keeps what lies beyond", where it maximizes only the total among the ways of reaching the set point (a probe empties one condition); the order "no longer drives", true of the class and false of orders with a term counted after (a probe drains at the set point); "choosers" in joint excess, where no choice enters; an "exactly" that needs one condition beyond; and a frozen prediction the law does not make. The "new" contrast with rising orders belongs to lexicographic orders whose first term has a plateau, which an aspiration level shares (probe): it shows that set points leave room for a tie-break, mild optimization's point, not that set points protect. `Nearing` is narrower than single-peakedness, being symmetric in distance; betweenness, `Regulation`'s own relation, fixes that with the key laws intact (probe). The three duplicated exchange laws move cleanly into `Optimum` with the rising laws as one-line corollaries: every statement is unchanged, `RegimeMargin` and the root module rebuild, and every axiom report stays empty. The kit is ready to land after the text fixes (findings 1–7 and 10–14), the renames (finding 15) and the refactor (finding 18, for `Optimum`'s owner); findings 8 and 9 are recommended first, since they change what the reading may claim.

**Counts:** 2 errors, 6 overclaims, 8 imprecisions, 3 suggestions.

## Findings

Each finding gives its severity, location, what is wrong, and the fix proposed. Suggested wording may be taken as written or in words that say the same.

### The verdict on reading 3 and its wording

**1. "Nothing protects it" is refuted by the kit's own witness.** *Error.*
- **Location.**
  - NOTE §3, corrected wording: "Where the step can lose what it takes, nothing protects it (`Topped.nearing_either`)".
  - NOTE §3.2: "the order protects nothing".
  - The UE1 note §5, reading 3: "nothing protects what lies beyond".
- **What is wrong.**
  - `Topped.nearing_either` shows two things: every nearing order stands at the set point, and the *order by distance* has the discarding step among its optima.
  - In the same world, `Topped.counted_after_keeps` shows that every optimum of `byGapThen` meets the dweller's need, and `byGapThen` is also a nearing order (`byGapThen_nearing`).
  - So something does protect what lies beyond: a term on the source counted after the store.
- **Fix.** "Where the step can lose what it takes, the set point alone does not protect what lies beyond: the order by distance has the draining step among its optima beside the keeping one (`Topped.nearing_either`). A term on what lies beyond counted after the set point does protect it there (`Topped.counted_after_keeps`)." Make the same change in §3.2, and in UE1's reading 3 when that note is next revised.

**2. What counting after the set point keeps.** *Overclaim.*
- **Location.**
  - NOTE §1 ("**New:** a term counted after the set point keeps what lies beyond").
  - NOTE §3.5.
  - The last sentence of the corrected wording ("what keeps there is a preference counted after the set point").
  - The module docstring's *Reading* ("What keeps at the set point is a term counted after it").
  - The UE1 note §5 ("keeps the most beyond").
- **What is wrong.** `counted_after_most` says that every optimum stands at the set point and leaves the beyond, **in total**, at least where every eligible outcome at the set point does. Two limits follow, and the text drops both.
  - *The total, not each condition.* Probe `Spread.counted_after_empties` has two conditions beyond and two ways of reaching the set point. Every optimum of `byGapThen` empties the first condition, while `even`, which is eligible and at the set point, leaves one at each.
  - *Only what some way of reaching the set point leaves.* Where every way of reaching it breaks a dependence, no term counted after keeps it. In `Drain` at a set point of two, every nearing optimum leaves the source at one (`Drain.nearing_breaks`), `byGapThen`'s optima included.
- **Fix.** "A term on what lies beyond, counted after the set point, leaves it, in total, at the most any eligible way of reaching the set point leaves (`Optimum.counted_after_most`). With one condition beyond, it keeps a need there exactly where some such way keeps it (probe `counted_after_keeps_iff`, worth adding to the kit). With several, maximizing the total can empty one of them (probe `Spread`)."

**3. The contrast with rising orders comes from the plateau, not the set point.** *Overclaim.*
- **Location.**
  - NOTE §1, "New".
  - NOTE §3.5 ("The same term counted after a rising order keeps nothing … It works only at the set point").
  - The module docstring's *Reading*.
  - The commit message.
- **What is wrong.**
  - *A general theorem against a witness.* The pair sets a general theorem against one world. The general statement for rising orders is `Optimum.Rising.mono` with `least_of_room`: with room, counted after a rising order, every optimum stands at the least level beyond among the eligible outcomes. `Drain.counted_after_drains` is its case, with nothing as that least level, so "keeps nothing" is the witness's number.
  - *Both orders are lexicographic.* What differs is whether the first term has ties.
    - A rising order has none along a unit moved into the family (`transfer_exceeds`), so with room the second term never decides.
    - A set point has a plateau, the ways of reaching it, and the second term decides within it.
    - So does an aspiration level. In probe `AfterTarget.satisficingThen_keeps`, with satisficing at a store of one and the source counted after, every optimum among the splits keeps the dweller, as the set point does.
  - *The sign decides, not the set point.* In probe `AtSetPointDrain.drains`, the order by distance with *less* beyond counted after is a nearing order, and from the set point in `Topped` every one of its optima leaves the source below the dweller's need.
  - *It is a coupling.* A term on what lies beyond means the order reads what lies beyond: it couples it in, ranked second.
- **Fix.** Replace "New" by:

  > Counted after a rising order, with room, a term on what lies beyond changes nothing (`Optimum.Rising.mono`, `Optimum.least_of_room`; `Drain.counted_after_drains`). Counted after an order with a plateau, whether a set point or an aspiration level, it decides within the plateau. Counting more beyond, it leaves the most, in total, that any outcome on the plateau leaves (`Optimum.counted_after_most`); counting less, it drains. Such a term reads what lies beyond: it is a coupling ranked second.

  See also the [section on satisficing and mild optimization](#satisficing-mild-optimization-and-the-counted-after-contrast).

**4. "No drive at the set point" holds of the class, not of an order.** *Overclaim.*
- **Location.**
  - The `least_at_iff` docstring ("at its set point a nearing order does not drive what lies beyond").
  - The module docstring: its bullet "At the set point there is no drive beyond", and its closing paragraph ("at its set point it no longer drives").
  - NOTE §1 ("the order asks nothing of what lies beyond").
  - The corrected wording ("the order no longer drives what lies beyond (`Optimum.least_at_iff`)").
- **What is wrong.**
  - `least_at_iff` quantifies over every nearing order, and its forward direction uses only `byGap`, which is indifferent to what lies beyond.
  - A given nearing order can drive what lies beyond at its set point either way: `byGapThen` drives it up (`counted_after_most`), and the probe's `byGapLess` drives it down (`AtSetPointDrain.drains`).
  - The exact form of "no drive" is this: where the set point can be reached, the optima of all nearing orders together are exactly the eligible outcomes at the set point (probe `optima_iff`, from `settled` and `atSetPoint_frontier`).
- **Fix.** Add `optima_iff` to the kit and say: "Where the set point can be reached, nearing alone puts no constraint on what lies beyond: an outcome is an optimum of some nearing order exactly where it is eligible and at the set point (`Optimum.optima_iff`). Which way of reaching the set point is taken is decided by what else the order counts, or by the choice among optima." Keep `least_at_iff`, with a docstring saying that it is a statement about the class.

**5. Joint excess holds for formations holding levels; no choice enters.** *Overclaim.*
- **Location.**
  - NOTE §1 ("Several holders, each within what a condition renews, end it together").
  - NOTE §3.3.
  - The corrected wording ("Holding its set point, the chooser draws what it loses … Several such choosers …").
  - The module docstring's bullet "Holding a set point draws what is lost".
  - The commit message ("joint excess holds for choosers held at set points").
  - The UE1 note §5 ("Joint excess holds for choosers held at set points").
- **What is wrong.**
  - *No choice in the statements.*
    - `Flow.held_draws` and `Flow.held_excess_ends` mention no order, eligibility or optimum.
    - "At a set point before and after" enters only through `W.stock fam (t + 1) = W.stock fam t` (`held` in the proof), so any level held fixed does the same.
    - That the holders are nearing choosers re-optimizing at every step is a reading through `settled`, with eligibility, aloneness and losses supplied. NOTE §4 states the last three; the text above it does not.
  - *At least, not exactly.* `held_draws` gives `l + give ≤ take`: a holder takes **at least** its loss from the condition. The text says "draws what it loses", and §3.3 says "is its loss". Equality holds only for the whole beyond, in `held_draws_lost`, under balance and a step in which the whole gains nothing.
  - *A restated hypothesis.* "None couples into it" restates the hypotheses `listed` and `apart` (one line); it is not a consequence of holding.
- **Fix.**

  > A formation alone with its family, holding it at a fixed level across a step, takes from a condition at least what it loses on its family with that condition (`Flow.held_draws`). Several formations so holding end the condition under the gate at need `m`, however small each one's loss, where their losses together exceed what the rest gives it at each of `n` steps and its level starts below `n + m`. Where each one's couplings lie in its family, apart from the condition, none couples into it (`Flow.held_excess_ends`). A nearing chooser holds its family wherever, at each step, an eligible outcome reaches its set point (`Optimum.settled`); the course of choices is not formalized.

**6. "Exactly" needs one condition beyond, and the loss is in the identity.** *Overclaim.*
- **Location.**
  - NOTE §1 ("On a step that loses nothing, that is exactly the set point's shortfall: a dependence beyond breaks exactly where the shortfall exceeds the slack").
  - NOTE §3.2.
  - The corrected wording ("On a step that loses nothing, what lies beyond falls by exactly the shortfall with the loss … so a dependence there breaks exactly where the shortfall exceeds the slack").
- **What is wrong.**
  - *One condition beyond.* `settled_broken_iff` is stated for one condition beyond (`rest = [c]`). With several, only `settled_breaks` holds, and it gives a sufficient condition only: the identity fixes the total draw, not its spread, so one dependence can break while the shortfall is within the total slack.
  - *The loss.* The corrected wording says "loses nothing" and "with the loss" in one sentence. The theorems need only that the whole gains nothing, and the loss term stays in the identity.
  - *The sign of the shortfall.* "Shortfall" is the set point's total less the family's stock before the step. Where the family stood above its set point, the beyond rises.
- **Fix.** "In a balanced step in which the whole gains nothing, the beyond falls by exactly the family's shortfall from its set point with what the step loses (`Flow.Balances.settled_draws`). With one condition beyond, its dependence breaks exactly where that exceeds its slack (`Flow.Balances.settled_broken_iff`). With several, some dependence breaks where it exceeds their total slack (`Flow.Balances.settled_breaks`)."

**7. The frozen test predicts more than the law.** *Overclaim.*
- **Location.** NOTE §6, *The frozen test*, the second and third predictions.
- **What is wrong.**
  - *"It does not keep it where it can discard."*
    - The Lean says only that the discarding step is *an* optimum of the order by distance, beside the keeping one. It says nothing about which of them an agent takes.
    - In the 2016 scheme, two policies of equal expected free energy are split by the prior over policies (the habit term `E`) and the softmax. With a flat prior the agent keeps half the time, and any habit or cost of acting tilts that share.
    - So a keeping agent would not refute the law, and a draining one would confirm only that ties exist.
  - *"A preference on the source counted after the store keeps it."*
    - Active inference has no lexicographic preferences; the implementation is a weighted log-preference on the source.
    - In `Topped` any positive weight `w` keeps: idling scores 2w, against w for discarding and −1 + w for topping up.
    - But that is a different order from `byGapThen`, and it needs its own statement before the test is frozen.
- **Fix.**
  - Second prediction: "keeping is not implied. Where it can discard, the discarding policy is as good as idling, so the share of draining is the tie-break's: one half with a flat prior over the two."
  - Third prediction: state the weighted form and its prediction (in `Topped`, every positive weight keeps).

### Definitions and statements

**8. `Nearing` is symmetric in distance, narrower than "an order greatest at a set point".** *Imprecision.*
- **Location.**
  - `Optimum.Nearer` and `Optimum.Nearing`.
  - The module docstring's *Reading* ("a preference falling with the distance from its mode at each observed condition ranks outcomes as an order nearing that mode").
  - NOTE §4 ("They do where the preference falls with the distance from its mode … One … that is not single-peaked at each, is not nearing").
- **What is wrong.**
  - `Nearer` compares gaps, `|o c − s c|`. So every nearing order must rank one unit over the set point above two units under it (probe `nearer_not_between`).
  - A preference single-peaked at the set point but costlier above than below is therefore not nearing. Examples are body temperature, or a store that spoils when overfull. Probe `skew_not_nearing` checks this for a cost of three per unit over and one per unit under.
  - So `Nearing` means "monotone in each observed condition's absolute distance", not "single-peaked" or "greatest at a set point". NOTE §4 leaves the asymmetric case out of both of its lists.
  - The drive of homeostatic reinforcement learning is nearing as defined (Keramati and Gutkin 2014: a norm of the deviations). Asymmetric costs are not.
- **Fix (tested).** Define nearer by betweenness, using `Regulation`'s own relation:

  ```lean
  (∀ c, c ∈ ds → Regulation.Between (s c) (o c) (o' c)) ∧ ∃ c, c ∈ ds ∧ gapTo s o' c < gapTo s o c
  ```

  - *Weaker.* It is weaker than the present `Nearer` (probe `nearer_of_nearerB`). So the orders nearing by it include every order nearing now (`nearingB_of_nearing`), and every law quantified over nearing orders gets stronger. The skewed order is among them (`skew_nearingB`).
  - *The laws carry over.*
    - The probe checks `settled`, `rises_below`, `transfer_nearer` and `nearing_beyond` under it (`settledB`, `rises_belowB`, `transfer_nearerB`, `nearing_beyondB`).
    - `byGap` stays nearing, since being nearer by betweenness implies being nearer by the gap.
    - The other laws derive from these.
  - *A reason for the import.* It also gives the `Regulation` import a reason beyond a two-line lemma: the order is built on regulation's relation of no overshoot.

  If the gap definition is kept, say "falls with the absolute distance at each observed condition, alike on both sides" in the *Reading* and in NOTE §4, and list asymmetric set points among what is not covered.

**9. `not_rising_of_enough` does not reach the orders the reading uses.** *Imprecision.*
- **Location.**
  - NOTE §3.1 ("the order is not rising (`Optimum.not_rising_of_enough`)").
  - The corrected wording.
- **What is wrong.**
  - The theorem needs an outcome ranked below no outcome at all.
  - `byGapThen` has none: where `rest` holds a condition apart from `ds`, any outcome is beaten by itself with one more unit beyond. So the corrected wording's own protective order is not covered.
  - The right statement is that no asymmetric order is both nearing and rising, where the family holds a condition (probe `not_rising_of_asymm`, five lines). It covers both `byGap` and `byGapThen`.
- **Fix.** Add `Nearing.not_rising`, with an asymmetry hypothesis, and cite it. Keep `not_rising_of_enough` as the case of an order with an unbeaten outcome.

**10. `Topped.nearing_either`'s headline, and how its dweller is read.** *Imprecision.*
- **Location.**
  - The docstring of `Topped.nearing_either` ("At the set point the order neither drives nor protects").
  - NOTE §2 ("source two, the dweller kept … source one, the dweller broken").
- **What is wrong.**
  - Only the first conjunct is about every nearing order; the two optima are optima of the order by distance.
  - "Kept" and "broken" are comparisons with the need in `Diversion`'s web (`(web WithinSlack.level).need 0 .dweller .source`). No web on `Topped`'s levels is built, and no `Kept` or `Broken` is proved.
- **Fix.** Headline: "At the set point the order by distance neither drives nor protects". NOTE §2: "(source two, at the dweller's need of two … source one, below it)".

**11. `mutual_settled_breaks`'s headline describes its witness.** *Imprecision.*
- **Location.** The headline of its docstring, "Each within the slack, together past it, they break a dependence beyond".
- **What is wrong.** The theorem has no hypothesis on each optimizer's own shortfall, as its body says ("whatever each optimizer's own shortfall"). "Each within the slack" is the first conjunct of `TwoStores.jointly_broken`.
- **Fix.** "Together past the slack, whatever each one's shortfall, they break a dependence beyond."

**12. One set point for all optimizers.** *Imprecision.*
- **Location.**
  - `mutual_settled`, `Flow.Balances.mutual_settled_draws` and `Flow.Balances.mutual_settled_breaks`.
  - NOTE §4.
- **What is wrong.** One `s` serves every optimizer, so optimizers whose families share a condition share its set point. Conflicting set points on a shared condition, where no level is an optimum for both optimizers, are outside the statements, and the NOTE does not say so.
- **Fix.** Add to NOTE §4 and to the module's list of what is not derived: "several optimizers share one set point on shared conditions; conflicting set points are not treated."

**13. What is not derived: four omissions.** *Imprecision.*
- **Location.**
  - NOTE §4.
  - The last paragraph of the module docstring.
- **What is wrong.** Four things are not listed.
  - *One step, deterministic.* Over a horizon under noise, a set point on future states gives an instrumental preference for reserves, since a buffer lowers the chance of a later shortfall. So a rising drive on stores can return, and "undriven at the set point" is a one-step result.
  - *The choice among optima.* Which optimum is taken where several stand at the set point decides keeping wherever loss is possible (finding 7).
  - *Lexicographic terms.* The secondary terms are lexicographic. With continuous amounts or finite precision exact ties are rare, and a weighted term trades against the set point.
  - *The definitions.* Symmetric distance and the common set point (findings 8 and 12).
- **Fix.** Add the four items.

**14. Stale references.** *Imprecision.*
- **Location.**
  - NOTE §4 ("as for `choose` in `Becoming.HabitCapture`").
  - NOTE §5 ("`Becoming.HabitCapture` could import it when UE1's records land").
- **What is wrong.** The module landed as `Becoming.ChoiceCountCapture` (`edc05fa2a`), and its records have landed.
- **Fix.** Write `Becoming.ChoiceCountCapture`, and drop "when UE1's records land".

### Names and placement

**15. "Settled" states a meaning the package uses for something else.** *Imprecision.*
- **Location.** `settled_iff`, `settled`, `mutual_settled`, `Flow.Balances.settled_draws`, `settled_breaks`, `settled_broken_iff`, `mutual_settled_draws`, `mutual_settled_breaks` and `Drain.settled_source`.
- **What is wrong.**
  - In the package, "settle" is used three other ways:
    - a run settles where its configuration stops changing (`Enough.Settles`, `Becoming.Settling`);
    - a regulated level settles where it reaches `m` and stays there (`Flow.settles`, `Flow.settles_at` and `Flow.settles_from`, in `Regulation`, which the kit imports);
    - `Requirement.Settled` is a discharged undertaking.
  - The kit's laws are one-step: every optimum stands at the set point.
  - AGENTS asks for a name that means exactly the statement, chosen at claim time.
- **Fix.** None of these names collides (checked).

  | Now | Rename to |
  |---|---|
  | `settled` | `atSetPoint_of_reach` |
  | `settled_iff` | `atSetPoint_iff` |
  | `mutual_settled` | `mutual_atSetPoint` |
  | `Flow.Balances.settled_draws` | `Flow.Balances.atSetPoint_draws` |
  | `settled_breaks` | `atSetPoint_breaks` |
  | `settled_broken_iff` | `atSetPoint_broken_iff` |
  | `mutual_settled_draws` | `mutual_atSetPoint_draws` |
  | `mutual_settled_breaks` | `mutual_atSetPoint_breaks` |
  | `Drain.settled_source` | `Drain.atSetPoint_source` |

**16. "Enough".** *Suggestion.*
- **Location.** `not_rising_of_enough` and `byGap_enough`.
- **What is wrong.** In the package, "enough" is the boundary of enough of `Becoming.Seeking` and `Becoming.Enough`: a run coming to rest with its target met. The hypothesis here is an outcome ranked below none.
- **Fix.** Rename to `not_rising_of_unbeaten` and `byGap_unbeaten_at`, keeping "a point of enough" as the prose reading.

**17. Placement and small duplicates.** *Suggestion.*
- **Location and fix.**
  - *A list lemma proved again.* `Optimum.total_le_of_only` states `Weightings.total_le_at_on` (outside the closure) again: a third proof beside `Dissipation.total_le_at`. Move `total_le_at_on` down to `Dissipation`, beside `total_le_at`, and use it. The owner of `Weightings` decides.
  - *Lemmas on Lean's numbers.* `Optimum.sub_le_sub_iff` and `Optimum.sub_lt_sub_iff` are such lemmas, and R31's practice puts them in the prelude (`Naturals`). This is not blocking.
  - *A repeated evaluation.* The evaluation of `transfer` on the family (`kept` in `transfer_nearer`) repeats lines of `transfer_exceeds`, and of `transfer_above`. One lemma in `Optimum` would serve all three.
  - *Shadowing.* `Optimum.HeldPair.holding` shadows `Optimum.holding` (a course holding a level) inside `Optimum`; `holders` reads better (a `holders` exists only in `SharedCodes`, in another namespace).

### Rule 9

**18. Three proofs beside `Optimum`'s.** *Error (process: rule 9; blocks landing).*
- **Location.** `Optimum.Above.full_of_ranked`, `Optimum.Above.floor_or_full_of_ranked` and `Optimum.beyond_of_ranked` (kit lines 548–638).
- **What is wrong.** As the NOTE flags, they repeat line for line the proofs of `Optimum.Above.full`, `Optimum.Above.floor_or_full` and `Optimum.optimum_beyond`. They differ only where the rising hypothesis ranked the one-unit transfer above the optimum. Landing them beside `Optimum`'s is what rule 9 forbids.
- **Fix.** The [refactor below](#rule-9-refactor), tested, with every statement unchanged.

### Additions

**19. Exact statements the reading needs.** *Suggestion.*
- **Fix.** Add these to the kit; all are pure and checked in the probe:
  - `optima_iff` (finding 4);
  - `counted_after_keeps_iff` (finding 2);
  - `Nearing.not_rising` (finding 9).

  After the refactor, `MutualBest.full` and `mutual_beyond` can take the same generalization, with each optimizer ranking above its optimum the unit moved into its family. That would read several nearing optimizers below their set points off an exchange, closing NOTE §4's "several optimizers at once" for that case. The owner of `Optimum` decides.

## Satisficing, mild optimization and the counted-after contrast

- **Is the contrast stated exactly?** It pairs `counted_after_most` (any outcomes) with `Drain.counted_after_drains` (one world). Stated exactly, the contrast is this:
  - With room, counted after a rising order, every optimum stands at the least level beyond among the eligible outcomes (`Rising.mono`, `least_of_room`).
  - Counted after the set point, where it can be reached, every optimum leaves the beyond, in total, at the most any eligible way of reaching the set point leaves (`counted_after_most`).

  What makes the difference is the ties in the first term, not set points (finding 3).
- **Satisficing (Simon 1955).**
  - An aspiration level is `Drain.satisficing`. It neither drives nor keeps: even where nothing can be lost, its optima include the draining outcome, by overshoot (`Drain.satisficing_either`).
  - A set point ranks overshoot below. Where nothing can be lost, that fixes the draw at the shortfall (`Drain.settled_source`, `Flow.Balances.settled_draws`); where something can be lost, it does not (`Topped.nearing_either`).
  - With the beyond counted after, the two keep alike (probe `AfterTarget`).
  - In the usual reading, Simon's chooser takes the first satisfactory alternative in its order of search, so on the plateau the search decides, not the aspiration. The kit's frontier is silent at the same place.
- **Mild optimization (Taylor 2016).**
  - A q-quantilizer samples a base distribution γ restricted to the top q of actions by utility. For every non-negative cost, its expected cost is at most 1/q times γ's.
  - The set point makes the plateau (`settled`, `optima_iff`), and nothing in the nearing condition chooses within it. Three ways of choosing behave differently:
    - A set-point chooser drawing from γ conditioned on reaching its set point is a quantilizer, with q the base probability of reaching it, and inherits that bound on draining.
    - One breaking ties by a term on the beyond is the kit's counted-after case: a deterministic tie-break by side effect.
    - One breaking ties arbitrarily has no bound (`Topped.nearing_either`).
  - So a set point is a bounded objective, not a mild optimizer: what protects is how the chooser picks within the plateau.
- **Thesis T3.** Its forbidden list includes "where room exists, a side-effect term ranked after the reward protecting a condition". The kit is no counterexample, since T3's reward rises; it marks where that clause stops, at orders with a plateau.

## First objections

**A decision theorist.**
- `Nearing` is monotonicity in symmetric distance, not single-peakedness (finding 8).
- An optimum is an undominated element of any relation. So "every optimum of every nearing order" is vacuous for orders that have none, and existence is shown only in witnesses.
- The drain statements are universal (every optimum of every nearing order). The statements of escape and of no protection are existential: they are about the order by distance. The text should keep the quantifiers apart (findings 1, 4 and 10).
- The secondary terms are lexicographic (finding 13).

**An alignment researcher.**
- One step, deterministic: under noise and a horizon, a set point demands reserves (finding 13).
- The set point is a free parameter. Protection is exactly "shortfall with loss within the slack", and where set points come from is open (NOTE §4).
- The choice among optima decides keeping wherever loss is possible (findings 7 and 13).
- The commons result needs no choice at all (finding 5). It is the most robust part of the verdict: formations holding set points drain a commons wherever their losses together exceed what renews it.

## Rule 9 refactor

**What is duplicated.** Three declarations of `Becoming.Optimum`, in the section *Room from the exchange* (namespace `Optimum`, `open Flow`). The file was last changed at `423800365`; the line numbers below are at HEAD.

| `Optimum` | The kit | The only difference in the proof |
|---|---|---|
| `Above.full` (lines 1415–1434) | `Above.full_of_ranked` (548–570) | `rising _ _ (transfer_exceeds (apart c mem) inside o)` replaced by `ranked` |
| `Above.floor_or_full` (1436–1472) | `Above.floor_or_full_of_ranked` (572–608) | calls `full_of_ranked … ranked`, not `full … rising` |
| `optimum_beyond` (1480–1505) | `beyond_of_ranked` (610–638) | calls `floor_or_full_of_ranked … ranked` |

- *The bodies.* They are otherwise identical line for line (diffed).
- *Where the rising hypothesis is used.* In exactly one place: to rank above the optimum the outcome with one unit moved from a condition beyond into the family.
- *Nothing else is duplicated.*
  - `least_below_iff` derives from `least_iff`.
  - `settled_draws` and `settled_breaks` derive from `DrawnBeyond`.
  - `held_excess_ends` derives from `joint_excess_ends`.
- *Where the general laws go.* The general laws use `Above`, `Flow.Outcome`, `Above.transfer` and `above_nothing`, all defined in `Optimum`. So they belong in `Optimum.lean` itself; a lower module would need those definitions moved too.

**The refactor.**

1. In `Becoming/Optimum.lean`, insert the kit's `Above.full_of_ranked`, docstring included, immediately before `Above.full`. Replace the body of `Above.full` with:
   ```lean
     Above.full_of_ranked distinct cdistinct apart inside optimum acts balances mem
       (rising _ _ (transfer_exceeds (apart c mem) inside o)) above present member
   ```
2. Insert the kit's `Above.floor_or_full_of_ranked` before `Above.floor_or_full`. Replace the body of `Above.floor_or_full` with:
   ```lean
     Above.floor_or_full_of_ranked distinct cdistinct apart inside optimum mem
       (rising _ _ (transfer_exceeds (apart c mem) inside o))
   ```
3. Insert the kit's `beyond_of_ranked` after `above_nothing`, which it uses, and before `optimum_beyond`. Replace the body of `optimum_beyond` with:
   ```lean
     beyond_of_ranked distinct cdistinct apart inside optimum mem
       (rising _ _ (transfer_exceeds (apart c mem) inside o))
   ```
4. In `Optimum`'s module docstring, under the bullet *Every optimum beyond, exactly*, add:

   > One law carries the three: an optimum does so at a condition beyond wherever its order ranks above it the outcome with one unit moved from there into the family (`Optimum.Above.full_of_ranked`, `Optimum.Above.floor_or_full_of_ranked`, `Optimum.beyond_of_ranked`); a rising order ranks every such unit above (`Optimum.transfer_exceeds`).

   It names no module above `Optimum`. The earlier attempt's tree pointed up to `Becoming.SetPointOptimum`, and a low module should not name a leaf above it.
5. In the kit:
   - delete the three theorems (lines 548–638);
   - change the docstring's "`Optimum.Above.full`, `Optimum.Above.floor_or_full` and `Optimum.optimum_beyond` state its rising case, with proofs of their own" to "…`Optimum.beyond_of_ranked`, in `Becoming.Optimum`, whose rising laws are their case)";
   - leave `nearing_beyond` unchanged; it then calls `Optimum`'s `beyond_of_ranked`;
   - bring NOTE §2 and §5 ("Generalize below") into line.

No statement of `Optimum` changes: no name, binder, order of hypotheses or conclusion. Three proofs shrink to corollaries and three theorems are added.

The modules depending on `Optimum` are unaffected:

- *Modules importing it.* Only `Becoming.RegimeMargin`, which uses `Optimum.sub_le_sub_left_of_le` alone, and the root module `Becoming.lean`.
- *Callers inside `Optimum`.* `MutualBest.full`, `optimum_untouched`, `optimum_lowers_iff`, `Web.optimum_broken_iff_capacity`, `mutual_as_one` and `course_beyond` call the rising laws through their unchanged statements.

**Test.** Run 25 October 2026, in the scratch tree `ue1b-review2/refactor`, on the shared cache.

- **Build.** `python3 -B scratch_build.py <tree> Becoming.Optimum Becoming.SetPointOptimum Becoming.RegimeMargin Becoming`: exit 0, no unclean step, every axiom report empty.

  | Module | Before | After |
  |---|---|---|
  | `Optimum` | 503 theorems in 634 declarations | 506 in 637 |
  | `SetPointOptimum` | 69 in 100 | 66 in 97 |
  | `RegimeMargin` | 246 in 336 | 246 in 336 |
  | the root `Becoming` (323 modules in its closure) | – | compiles |

- **Statements.**
  - *What was compared.* The types of all 1070 declarations of the three modules: `Optimum`'s 634, the kit's 100 and `RegimeMargin`'s 336. Each was printed as a Lean `Expr`, from a small script importing each build, in the original and the refactored builds.
  - *Result.* Identical. The three moved theorems are identical up to the hygienic names Lean gives anonymous instance binders (`inst._@.Becoming.SetPointOptimum…` against `inst._@.Becoming.Optimum…`). `Above.full`, `Above.floor_or_full` and `optimum_beyond` are byte-identical.
- **Against the earlier attempt.** Its refactor tree (`ue1b-review/refactor`) has the same Lean as this one. It differed in one sentence of `Optimum`'s docstring, the pointer up to the kit (dropped here). Its build numbers match these.
- **Landing.** This is for `Optimum`'s owner.
  - The checker's receipt counts change: `Optimum` +3 theorems and +3 declarations, the kit −3 and −3.
  - The package README's L1 row may name the three laws, and the generated Lean index changes.
  - The shared cache already holds the refactored steps under their own source keys, so the landing run can reuse them.

## Appendix: the probe module

`Becoming/SetPointProbe.lean`, built beside an unchanged copy of the kit: 18 theorems in 29 declarations, every axiom report empty.

```lean
import Becoming.SetPointOptimum

/-!
# Probe for the review of UE1b (scratch, not for landing)

Checks findings of the review in Lean, against the kit as committed:

1. Nearer by betweenness (`Regulation.Between`) is weaker than the kit's `Nearer`, so the orders
   nearing by betweenness include every order the kit calls nearing; the kit's key laws hold for
   them; and an order single-peaked at the set point but costlier above it than below is nearing
   by betweenness and not by the gap.
2. An asymmetric nearing order is not rising, with no globally unbeaten outcome needed.
3. Where the set point can be reached, the optima of nearing orders, taken together, are exactly
   the eligible outcomes at the set point.
4. Counted after the set point, the beyond is maximized in total, not condition by condition;
   with one condition beyond, a need there is kept exactly where some way of reaching the set
   point keeps it.
5. Counted after a target, a satisficing order keeps the source among the splits, as a set point
   counted after does.
6. A nearing order counting less beyond after the set point drains at the set point.
-/

namespace Becoming

open Requirement

namespace Optimum

namespace Probe

variable {C : Type} {ds rest : List C} {s : C → Nat} {eligible : (C → Nat) → Prop}
  {better : (C → Nat) → (C → Nat) → Prop}

/-! ## 1. Betweenness -/

/-- Nearer by betweenness: at each condition of the family between the set point and the other,
and at one strictly nearer. -/
def NearerB (ds : List C) (s o' o : C → Nat) : Prop :=
  (∀ c, c ∈ ds → Regulation.Between (s c) (o c) (o' c)) ∧
    ∃ c, c ∈ ds ∧ gapTo s o' c < gapTo s o c

/-- Nearing by betweenness: ranks above every outcome nearer by betweenness. -/
def NearingB (ds : List C) (s : C → Nat) (better : (C → Nat) → (C → Nat) → Prop) : Prop :=
  ∀ o o', NearerB ds s o' o → better o' o

theorem nearer_of_nearerB {o o' : C → Nat} (nearer : NearerB ds s o' o) : Nearer ds s o' o :=
  ⟨fun c mem => Regulation.Between.gap_le (nearer.1 c mem), nearer.2⟩

/-- Every order nearing by the gap nears by betweenness. -/
theorem nearingB_of_nearing (nearing : Nearing ds s better) : NearingB ds s better :=
  fun o o' nearer => nearing o o' (nearer_of_nearerB nearer)

theorem between_at (m x : Nat) : Regulation.Between m x m :=
  ⟨fun mx => ⟨Nat.le_refl m, mx⟩, fun xm => ⟨xm, Nat.le_refl m⟩⟩

/-- `settled`, for every order nearing by betweenness. -/
theorem settledB (nearing : NearingB ds s better) {o₀ : C → Nat} (reach : eligible o₀)
    (at₀ : AtSetPoint ds s o₀) {o : C → Nat} (optimum : Frontier eligible better o) :
    AtSetPoint ds s o :=
  fun c mem => match Nat.decEq (o c) (s c) with
    | .isTrue same => same
    | .isFalse off => absurd (nearing o o₀
        ⟨fun x listed => Eq.subst (motive := fun y => Regulation.Between (s x) (o x) y)
            (at₀ x listed).symm (between_at (s x) (o x)),
         (nearer_of_atSetPoint at₀ mem off).2⟩) (optimum.2 o₀ reach)

/-- Up to the set point, exceeding is nearer by betweenness. -/
theorem nearerB_of_exceeds {o o' : C → Nat} (upTo' : UpToSetPoint ds s o')
    (exceeds : Exceeds ds o' o) : NearerB ds s o' o :=
  ⟨fun x mem => ⟨fun sx => ⟨Nat.le_trans sx (exceeds.1 x mem), Nat.le_trans (upTo' x mem) sx⟩,
      fun _ => ⟨exceeds.1 x mem, upTo' x mem⟩⟩,
   ((nearer_iff_exceeds (fun x mem => Nat.le_trans (exceeds.1 x mem) (upTo' x mem)) upTo').mpr
     exceeds).2⟩

/-- `Nearing.rises_below`, for every order nearing by betweenness. -/
theorem rises_belowB (nearing : NearingB ds s better) {o o' : C → Nat}
    (upTo' : UpToSetPoint ds s o') (exceeds : Exceeds ds o' o) : better o' o :=
  nearing o o' (nearerB_of_exceeds upTo' exceeds)

/-- `transfer_nearer`, by betweenness. -/
theorem transfer_nearerB [DecidableEq C] {c d : C} (out : ¬ c ∈ ds) (inside : d ∈ ds)
    {o : C → Nat} (short : o d < s d) : NearerB ds s (transfer c d o) o :=
  have kept : ∀ x, x ∈ ds → transfer c d o x = if x = d then o d + 1 else o x :=
    fun _ listed => if_neg fun same => out (Eq.subst (motive := fun y => y ∈ ds) same listed)
  ⟨fun x listed => match decEq x d with
    | .isTrue same =>
      have shortX : o x < s x := Eq.subst (motive := fun y => o y < s y) same.symm short
      have atX : transfer c d o x = o x + 1 :=
        (kept x listed).trans ((if_pos same).trans (congrArg (o · + 1) same.symm))
      Eq.subst (motive := fun y => Regulation.Between (s x) (o x) y) atX.symm
        ⟨fun sx => absurd shortX (Nat.not_lt_of_le sx), fun _ => ⟨Nat.le_succ (o x), shortX⟩⟩
    | .isFalse other => Eq.subst (motive := fun y => Regulation.Between (s x) (o x) y)
        ((kept x listed).trans (if_neg other)).symm (Regulation.Between.refl (s x) (o x)),
   (transfer_nearer out inside short).2⟩

/-- `nearing_beyond`, for every order nearing by betweenness. -/
theorem nearing_beyondB {F : Type} [DecidableEq F] [DecidableEq C] {L : Flow F C}
    {part : F → Bool} {cap : F → C → Nat} {t : Nat} {l : C → Nat}
    (distinct : Distinct (L.present t)) (cdistinct : Distinct (ds ++ rest))
    (apart : ∀ c, c ∈ rest → ¬ c ∈ ds) {d : C} (inside : d ∈ ds) (nearing : NearingB ds s better)
    {o : C → Nat} (optimum : Frontier (L.Outcome part l cap (ds ++ rest) t) better o)
    (short : o d < s d) {c : C} (mem : c ∈ rest) :
    o c = l c + L.restGiven part t c - L.restTaken part t c - L.capacity part cap t c :=
  beyond_of_ranked distinct cdistinct apart inside optimum mem
    (nearing o _ (transfer_nearerB (apart c mem) inside short))

/-- The kit's `Nearer` asks more than betweenness: with the set point at two, one unit over is
nearer than two under, a comparison no single-peaked order needs to make. -/
theorem nearer_not_between :
    Nearer [()] (fun _ => 2) (fun _ => 3) (fun _ => 0) ∧
      ¬ NearerB [()] (fun _ => 2) (fun _ => 3) (fun _ => 0) :=
  ⟨⟨fun _ _ => (Nat.le_succ 1 : 1 ≤ 2), (), .head [], (Nat.lt_succ_self 1 : 1 < 2)⟩,
   fun nearer => Nat.not_succ_le_self 2 ((nearer.1 () (.head [])).2 (Nat.zero_le 2)).2⟩

/-- Single-peaked at two, three per unit over, one per unit under. -/
def skewCost (o : Unit → Nat) : Nat := (o () - 2) + (o () - 2) + (o () - 2) + (2 - o ())

/-- The order by that cost. -/
def skewOrder (o' o : Unit → Nat) : Prop := skewCost o' < skewCost o

/-- **The skewed order nears by betweenness.** -/
theorem skew_nearingB : NearingB [()] (fun _ => 2) skewOrder :=
  fun o o' nearer =>
    have b : Regulation.Between 2 (o ()) (o' ()) := nearer.1 () (.head [])
    have st : gap (o' ()) 2 < gap (o ()) 2 := match nearer.2 with
      | ⟨_, _, lt⟩ => lt
    match Nat.le_total 2 (o ()) with
    | .inl over =>
      have yb := b.1 over
      have lt : o' () - 2 < o () - 2 :=
        Nat.lt_of_le_of_lt (Nat.le_of_eq (Regulation.gap_of_le yb.1).symm)
          (Nat.lt_of_lt_of_le st (Nat.le_of_eq (Regulation.gap_of_le over)))
      show skewCost o' < skewCost o from
        Nat.lt_of_le_of_lt (Nat.le_of_eq (congrArg (_ + ·) (sub_eq_zero_of_le yb.1)))
          (Nat.lt_of_lt_of_le (Nat.add_lt_add_right (Nat.add_lt_add (Nat.add_lt_add lt lt) lt) 0)
            (Nat.le_of_eq (congrArg (_ + ·) (sub_eq_zero_of_le over)).symm))
    | .inr under =>
      have yb := b.2 under
      have lt : 2 - o' () < 2 - o () :=
        Nat.lt_of_le_of_lt (Nat.le_of_eq (Regulation.gap_of_ge yb.2).symm)
          (Nat.lt_of_lt_of_le st (Nat.le_of_eq (Regulation.gap_of_ge under)))
      show skewCost o' < skewCost o from
        Nat.lt_of_le_of_lt
          (Nat.le_of_eq (congrArg (fun a => a + a + a + (2 - o' ())) (sub_eq_zero_of_le yb.2)))
          (Nat.lt_of_lt_of_le (Nat.add_lt_add_left lt (0 + 0 + 0))
            (Nat.le_of_eq
              (congrArg (fun a => a + a + a + (2 - o ())) (sub_eq_zero_of_le under)).symm))

/-- **The skewed order is not nearing by the gap**: it ranks two under above one over. -/
theorem skew_not_nearing : ¬ Nearing [()] (fun _ => 2) skewOrder :=
  fun nearing => (Nat.lt_irrefl 2 (Nat.lt_trans (Nat.lt_succ_self 2)
    (nearing (fun _ => 0) (fun _ => 3) nearer_not_between.1 : 3 < 2)))

/-! ## 2. An asymmetric nearing order is not rising -/

/-- **No asymmetric order is both nearing and rising**, where the family holds a condition: the
set point and the outcome one above it at every condition would rank above each other. -/
theorem not_rising_of_asymm (nearing : Nearing ds s better)
    (asymm : ∀ o o', better o' o → ¬ better o o') {d : C} (inside : d ∈ ds) :
    ¬ Rising ds better :=
  fun rising =>
    asymm s (fun x => s x + 1)
      (rising s _ ⟨fun _ _ => Nat.le_succ _, d, inside, Nat.lt_succ_self _⟩)
      (nearing (fun x => s x + 1) s
        (nearer_of_atSetPoint (fun _ _ => rfl) inside (Nat.succ_ne_self (s d))))

/-! ## 3. The optima of nearing orders, together -/

/-- **Where the set point can be reached, an outcome is an optimum of some nearing order exactly
where it is eligible and at the set point.** -/
theorem optima_iff {o₀ : C → Nat} (reach : eligible o₀) (at₀ : AtSetPoint ds s o₀)
    {o : C → Nat} :
    (∃ better, Nearing ds s better ∧ Frontier eligible better o) ↔
      (eligible o ∧ AtSetPoint ds s o) :=
  ⟨fun ⟨_, nearing, optimum⟩ => ⟨optimum.1, settled nearing reach at₀ optimum⟩,
   fun ⟨eligibleO, atO⟩ => ⟨byGap ds s, byGap_nearing ds s, atSetPoint_frontier eligibleO atO⟩⟩

/-! ## 4. Counted after: the total, not each condition -/

/-- **With one condition beyond, counted after the set point keeps a need exactly where some way
of reaching the set point keeps it.** -/
theorem counted_after_keeps_iff {c : C} {need : Nat} {o₀ : C → Nat} (reach : eligible o₀)
    (at₀ : AtSetPoint ds s o₀) {o : C → Nat}
    (optimum : Frontier eligible (byGapThen ds s [c]) o) :
    need ≤ o c ↔ ∃ o', eligible o' ∧ AtSetPoint ds s o' ∧ need ≤ o' c :=
  ⟨fun kept => ⟨o, optimum.1, (counted_after_most reach at₀ optimum).1, kept⟩,
   fun ⟨o', eligible', at', kept'⟩ => Nat.le_trans kept'
     (le_of_add_le_add_right 0 ((counted_after_most reach at₀ optimum).2 o' eligible' at'))⟩

namespace Spread

/-- A condition of the family and two beyond. -/
inductive Spot where
  | family
  | first
  | second

/-- The set point: one. -/
def one : Spot → Nat := fun _ => 1

/-- At the set point, the first condition beyond emptied, three in the second. -/
def lopsided : Spot → Nat
  | .family => 1
  | .first => 0
  | .second => 3

/-- At the set point, one in each condition beyond. -/
def even : Spot → Nat
  | .family => 1
  | .first => 1
  | .second => 1

/-- Two ways of reaching the set point. -/
def Eligible (o : Spot → Nat) : Prop := o = lopsided ∨ o = even

/-- **Counted after the set point, a condition beyond is emptied though a way of reaching the set
point keeps it.** Every optimum of the order by distance with the beyond counted after leaves the
first condition at nothing, while `even`, eligible and at the set point, leaves one at each. -/
theorem counted_after_empties :
    (∀ o, Frontier Eligible (byGapThen [Spot.family] one [Spot.first, Spot.second]) o →
      o .first = 0) ∧
    Eligible even ∧ AtSetPoint [Spot.family] one even ∧ 1 ≤ even .first ∧ 1 ≤ even .second :=
  ⟨fun _ optimum => match optimum.1 with
    | .inl same => Eq.subst (motive := fun x => x Spot.first = 0) same.symm rfl
    | .inr same => absurd
        (Eq.subst (motive := fun x => byGapThen [Spot.family] one [Spot.first, Spot.second]
            lopsided x)
          same.symm (.inr ⟨rfl, Nat.lt_succ_self 2⟩))
        (optimum.2 lopsided (.inl rfl)),
   .inr rfl, atSetPoint_single rfl, Nat.le_refl 1, Nat.le_refl 1⟩

end Spread

/-! ## 5. Counted after a target -/

namespace AfterTarget

open Diversion DrawnBeyond Drain

/-- Satisficing at a store of one, the source counted after among outcomes alike in reaching it. -/
def satisficingThen (o' o : Place → Nat) : Prop :=
  satisficing o' o ∨ ((1 ≤ o' .store ↔ 1 ≤ o .store) ∧ o .source < o' .source)

/-- **Counted after a target, the source is kept.** Every optimum among the splits of three units
of the satisficing order with the source counted after leaves the source at two, the dweller's
need, as every optimum of every order nearing a store of one does (`Drain.nearing_keeps`). -/
theorem satisficingThen_keeps {o : Place → Nat} (optimum : Frontier Split satisficingThen o) :
    o .source = 2 :=
  have kept : Split keptLevel := rfl
  match hs : o .store with
  | 0 => absurd (Or.inl ⟨Nat.le_refl 1,
        Eq.subst (motive := fun y => y < 1) hs.symm (Nat.zero_lt_succ 0)⟩ :
          satisficingThen keptLevel o)
      (optimum.2 keptLevel kept)
  | n + 1 =>
    have split : o .source + (n + 1) = 3 :=
      Eq.subst (motive := fun y => o .source + y = 3) hs optimum.1
    have atMost : o .source ≤ 2 :=
      Nat.le_of_succ_le_succ (Nat.le_trans
        (Nat.add_le_add_left (Nat.succ_le_succ (Nat.zero_le n)) (o .source))
        (Nat.le_of_eq split))
    Nat.le_antisymm atMost (Nat.ge_of_not_lt fun lower => optimum.2 keptLevel kept
      (Or.inr ⟨⟨fun _ => Eq.subst (motive := fun y => 1 ≤ y) hs.symm
          (Nat.succ_le_succ (Nat.zero_le n)), fun _ => Nat.le_refl 1⟩, lower⟩))

end AfterTarget

/-! ## 6. A nearing order counting less beyond after drains at the set point -/

/-- Nearer first, and among outcomes as near, less beyond in total. -/
def byGapLess (ds : List C) (s : C → Nat) (rest : List C) (o' o : C → Nat) : Prop :=
  byGap ds s o' o ∨ (total ds (gapTo s o') = total ds (gapTo s o) ∧ total rest o' < total rest o)

theorem byGapLess_nearing : Nearing ds s (byGapLess ds s rest) :=
  (byGap_nearing ds s).mono fun _ _ nearer => .inl nearer

namespace AtSetPointDrain

open Diversion DrawnBeyond Drain Topped

/-- **At the set point, a nearing order can drive the drain.** From the store at its set point of
one, every optimum among the outcomes open to the taker of the order by distance with less source
counted after leaves the source at most at one, below the dweller's need of two. -/
theorem drains {o : Place → Nat}
    (optimum : Frontier Open (byGapLess [Place.store] one [Place.source]) o) :
    o .source ≤ 1 ∧ 1 < (web WithinSlack.level).need 0 .dweller .source :=
  ⟨Nat.ge_of_not_lt fun more => optimum.2 drawnOne discarding_open
    (match Nat.eq_zero_or_pos (total [Place.store] (gapTo one o)) with
      | .inl zero => .inr ⟨(rfl : total [Place.store] (gapTo one drawnOne) = 0).trans zero.symm,
          Nat.add_lt_add_right more 0⟩
      | .inr pos => .inl pos),
   Nat.lt_succ_self 1⟩

end AtSetPointDrain

end Probe

end Optimum

end Becoming
```
