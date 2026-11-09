# ZA: concern formed within the dynamics

*AI-written (Claude Opus 5.5), 9 November 2026, for board item ZA. About ten minutes to read. It says what `Becoming.PersistingChoices` proves, in plain words first, and where each part stops. No person's review is recorded. The four AI readings and the check this item starts from are outside the repository, in `/Users/ren/tmp/za-how-far/`.*

## The question

On 9 November 2026 Ren said that there is no warrant, that ethics emerges from the continuation condition and not the other way around, and asked how far the zero-axiom target is. Three AI readers and a checker agreed: what follows once self-concern and a closed scope are present is proved in detail; how self-concern forms within the dynamics is not modelled at all. `Weighting.IncreasingInOwn`, an order increasing in one's own continuation, occurred only as a hypothesis. Under Ren's view nothing normative is to be derived, so the target is descriptive: how concern and scope form, how far they reach, where they lock. This item takes three steps of it, in the order the brief gave.

## In plain words

**What now comes out of the dynamics, with no self-concern supplied.**

1. *Scope, where everything is entangled.* In a mutually dependent flow, a center's concern for what its continuation depends on, held de se, already counts every continuation; so does its concern for what it affects. Where every formation is a center, that is exactly what mutual dependence is. Where something lies beyond, as the clearer's dweller does, neither holds.
2. *Keeping above ending, from persisting.* A line that persists through arbitrarily late cohorts never overdrew, from a short stock, the gated family of conditions it depends on. That is a law of the World. Where a choice ending what the line depends on is realized as such an overdraw, a persisting line never made one. So its choices, if they come from any strict order at all, are consistent with an order ranking every keeping course above every ending course it met. Where only ending was at stake on the occasions it met, its choices are consistent with self-concern there.
3. *The own class, given P2 and P4.* Under 07 §4.6's P2 and P4, the classes that can be one's own have a least member: oneself with everything downstream of one's acts. All of them give one's own line the same reach. So, under those premises, which class is one's own does not change what one's own line reaches.

**What does not.**

1. *Self-concern as held.* Persisting is a filter on what was chosen, not a mechanism that forms an order. It shows that the choices are consistent with self-concern where ending was at stake. It does not show that any order is held.
2. *Degree.* Persisting fixes nothing between degrees of keeping. A line that forgoes a child it could have had persists as well, choosing by a strict order of its own that reads each course whole, and no order consistent with its choice is self-concerned. This is the countermodel one reader proposed (a persisting, fully informed chooser that is not self-concerned), built here on a World that meets every law the positive result uses.
3. *Beyond the occasions met.* Off the occasions met, orders consistent with every choice rank either way. Read with training, this is where goal misgeneralization sits.
4. *What is still supplied.* Which relation a center's concern is drawn along; that significance is the own-closure reading; which formations are centers; that a chosen ending is realized as an overdraw; that any actual web is mutually dependent; that P2 and P4 hold for anyone. The crux of 07 §4.7, whether one's effects are one's own, is untouched.
5. *Nothing normative.* None of this derives a "should". What it gives is descriptive: where concern and scope form, how far they reach, and what persisting does and does not fix.

Against the readers' list of gaps: the composition from mutual dependence to the condition is done; G3 is done in the form "consistent with, not had", positive where only ending is at stake, negative between degrees and off the occasions met; G2 is answered the other way from the conjecture in one reading (that such classes close only under joins, with two whose meet fails), which is false. G1 proper, reading centers from the dynamics, is not done here: `center` is still supplied.

## The results, with their names

All in [`Becoming.PersistingChoices`](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/PersistingChoices.lean), a leaf of the pure core; every axiom report is empty. Their home is [07 §4.8](../../../../../../theories/becoming/chapters/07-SIGNIFICANCE.md#what-the-dynamics-give).

- **Mutual dependence gives the condition held de se** ([record](../../../../../../theories/becoming/results/records/mutual-dependence-gives-the-condition-de-se.md)). `Flow.unrestricted_of_mutuallyDependent`: along being affected (`AffectedBy`) by the definition of mutual dependence, along affecting (`Affects`) through `mutuallyDependent_iff_reach`, each into `ownClosure_unrestricted_of_whole`. `Flow.mutuallyDependent_iff_unrestricted`: with every formation a center, each is exactly mutual dependence. `Clearing.not_unrestricted_ownClosure`: neither holds in the clearer's world. Mutual dependence is closure under being affected; mutual feeding gives it and not conversely, as the checker of the readings noted.
- **What persisting shows of an order** ([record](../../../../../../theories/becoming/results/records/what-persisting-shows-of-an-order.md)). Choices with required comparisons: `ChoiceOccasions.withPairs` reads a relation's pairs as further occasions, so `ShownOrder`'s laws give `accorded_containing_iff`, `above_in_every_containing_iff_reach` and `above_in_some_containing_of_unreached`. Survivorship in order form: `keeping_above_ending`, from `noCycle_withPairs_of_kept` (what ends is a sink). Self-concern on the occasions met: `Weighting.IncreasingInOwnOn`, exact in `selfConcerned_consistent_iff`, positive in `selfConcerned_consistent_of_kept` and `selfConcerned_consistent_of_allOrNone`, free off them in `reversed_off_met`. On the World: `Flow.persists_never_overdraws` (from `GroupEnding.Flow.family_childless`) and the composition `Flow.persisting_consistent_with_selfConcern`. The witness: `PersistingChoices.Forgoing`, its World laws (`balances`, `acting`, `dependent`, `descended`, `persists`, `gated`, `coupled`, `never_overdraws`), the chooser's order (`order_strict`, `order_accords`), `keeping_above_drain` and `persists_not_selfConcerned`.
- **The least own class** ([record](../../../../../../theories/becoming/results/records/the-least-own-class.md)). `OwnClass.downstreamClass` with `downstreamClass_class`, `downstreamClass_held`, `downstreamClass_constant_at` and `downstreamClass_least`; `meet_class`, `meet_held` and `meet_constant_at`; `held_iff_contains_downstream`; `reach_iff_downstream`; `one_constant_at`, `one_held` and `least_own_class`. Near-definitional: `«本类常则闭当且仅当后皆同类»` already says that under P2 holding one's effects is everything downstream being alike; what is added is that the class of exactly that meets P2 itself, so a least class exists, and that two such classes meet in one.

## The modelling choices

- *Choice.* `ChoiceOccasions` as in 03 §11: strict dominance at each occasion; no noise, no probabilities, no computation of the choice represented. "Increasing in its own continuation on the occasions met" reads `IncreasingInOwn` only on pairs open together at some occasion.
- *The link to the flow.* The one premise tying the choices to the World is `realized`: a chosen course that ends what the line depends on is realized as an overdraw of the family from a short stock. The courses are listings of what they admit; they are not flows. A model whose alternatives are flows, with the pick being the flow that comes about, would remove the premise and is the natural next step.
- *Stake.* The positive result needs that, on the occasions met, a course adds to the own continuation beyond one it widens only by keeping where the other ends. The witness shows the result fails without it.
- *Persisting.* Members in arbitrarily late cohorts, a statement about descent; no share, rate or fitness. Differential persistence among several lines, with shares (the selection terms of 04), is what could bear on degrees of keeping; nothing here says it does, and 04 already finds that the selection terms need not decide a lineage's fate.
- *Fully informed.* The witness's chooser ranks by a valuation that reads every listed item of each course, its own continuation included. Nothing is hidden from it; it simply ranks a fewer-member course first.
- *The own class.* Root, any carrier; `goes` (the member conditions something) and either some class meeting P2 and P4, or a decision whether each occurrence conditions anything.

## What would extend it

- Alternatives that are flows, so that what a chosen course does to the line is a law, not the premise `realized`.
- Several lines under selection by share, to ask whether differential persistence fixes anything between degrees of keeping, and whether the answer is again "consistent with" on the occasions met.
- Centers read from the dynamics (G1): a center as a self-bearing formation whose reach returns (`Web.SelfBearing`, `Flow.ReachReturns`), so that `center` is no longer supplied in the first part.
- A test that could fail: whether trained systems' choices, on occasions where ending was not at stake, track their own continuation's degree (the witness says nothing forces it). Under Ren's hold of 6 November on new test designs, this is named, not designed.

## What was checked

The module was built with `scratch_build.py` while it was written, and by the checker's core run for the landing (receipt named in the records); every axiom report is empty and no step was unclean. The records were checked with `research.py check`. The full gate is deferred to the landing gate. This note's claims about the Lean were checked against the statements by the author only; no other reader has read it yet.
