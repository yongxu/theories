# UE2 review: conditional weights and surprisal on the counting layer (25 October 2026)

An AI-authored, independent and adversarial review of board item UE2 as committed at `4c1639402`. It covers:

- [NOTE.md](NOTE.md), sha256 `513c508e…1390bf`;
- [`tree/Becoming/ConditionalWeights.lean`](tree/Becoming/ConditionalWeights.lean), sha256 `c1dc1298…d6f8cf28`;
- [`tree/Becoming/Typicality.lean`](tree/Becoming/Typicality.lean), sha256 `db46cf81…af0aae7e8906`, a modified copy of the landed [`Becoming/Typicality.lean`](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Typicality.lean) (sha256 `90497689…b52e1d8a3`, unchanged on main at this review);
- `periphery/VariationalBound.lean` (renamed [`periphery/ConditionalWeightsReals.lean`](periphery/ConditionalWeightsReals.lean) in the revision `8dfee102e`; the reviewed bytes are at commit `4c1639402`), sha256 `438046c9…d73e48`, and its [log](periphery/periphery.log).

They were read with [AGENTS.md](../../../../../../AGENTS.md), board rules 8 and 9, [the UE plan](../ue-unified-explanation/PLAN.md) §4, [UE1's NOTE](../ue1-fep-bridge/NOTE.md) §3, [02 §5](../../../../../../theories/becoming/chapters/02-MAP.md#margin), [03 §10](../../../../../../theories/becoming/chapters/03-KNOWING.md#break-seen-coming), the package modules `Weighted`, `Typicality`, `Drift`, `RuleCapture`, `Flow`, `Dependence` and the periphery modules `RegimeReals`, `Representation`, `EntropyProduction` and `SlowingDown` with their checkers, and the records that bind `Typicality.lean`.

**How it was checked.**

- **Rebuild.** `scratch_build.py` on the kit tree, naming Typicality, ConditionalWeights and the six core modules downstream of Typicality: 88 steps, all reused from the shared cache, nothing unclean. Their inputs match the kit's fresh run, so the current checkout builds the same. ConditionalWeights 93 theorems in 109 declarations, the kit's Typicality 50 in 70, every axiom report empty, also for TypicalRuns, Situations, Drift, FinerTraces, SituationTraces and HistorySums. Nothing else in the package imports Typicality but the root `Becoming.lean`.
- **Probe.** A module importing the kit, in a separate scratch tree: 9 theorems in 12 declarations, every axiom report empty except one witness (`record_hypothesis_at_length`, `propext` through Lean's compilation of its match). Its text is in [appendix A](#appendix-a-the-probe-module), since the scratch folder is volatile.
- **Variants of Typicality**, each built with ConditionalWeights and the six dependents, every axiom report empty: (V1) the kit's Typicality without `offBy_le`: Typicality 49 theorems in 69 declarations; (V2) V1 with `regroup_square`, `square_gap` and `margin_square` moved from ConditionalWeights into Typicality and `two_mul_le_of_le` derived from `margin_square`: Typicality 52 in 72, ConditionalWeights 90 in 106 ([appendix C](#appendix-c-the-typicality-amendments-built-as-v2)).
- **Periphery.** The draft recompiled with `lake env lean` in the pinned Mathlib project (`~/repos/生生不息`, Lean 4.30.0-rc2, Mathlib `ea11ccc0…`): no error or warning, each theorem on `propext`, `Classical.choice` and `Quot.sound`, as logged. A copy with three added theorems compiles the same way ([appendix B](#appendix-b-periphery-additions)).
- **Not Lean.** Exit shares of a balanced walk were computed by exact enumeration in Python and are labelled where used.

## Verdict

The Lean is sound and the build claims hold. Conditioning as restriction, Bayes's rule, the posterior of a generative model, products of shares under independence, the exit bounds and the record law are correct as stated; Kolmogorov's maximal inequality (`typical_throughout`) is a correct counting form and a strict generalization of `typical`, whose statement is unchanged; "a balanced level falls to its need at some step within the horizon on at most n·p·q/m² of the weight" is exactly `fallsWithin_share`, with the balance, two values, independent steps and natural weights built into the definitions and stated in the module's "what is not derived"; and the record-conditioned bound `record_bound` is right. The problems are in what the text makes of these laws. The exit bound is presented as the counting form of the free-energy principle's persisting and as a candidate third part, but it bounds a level that nothing regulates, it is void once n reaches m²/(p·q), and it constrains the weighting, which the principle takes as given, so it forbids nothing the principle leaves open. The conditioning, Bayes and surprisal laws are near-definitional and read as probabilities only where every hypothesis's likelihood weights have one total; free energy has no counting form, so UE1's premise card overstates what UE2 pays. "Falls to the need" counts standing at the need, which the core counts as supported, so it is not a break; the record laws quantify over lists of every length; several laws repeat landed laws of Drift and Typicality beside them; the periphery names a declaration that does not exist and shows the bound met at the posterior, not only there. The fixes are text, two hypothesis changes, moved or dropped helpers and three periphery theorems, each built here. Land after the fixes, with the Typicality change in Typicality.

**Counts:** 1 error, 4 overclaims, 11 imprecisions, 3 suggestions.

## Findings

Each finding gives its severity, location, what is wrong and the fix. Suggested wording may be taken as written or in words that say the same.

### The free-energy reading

**1. The exit bound read as the principle's persisting, and the candidate third part.** *Overclaim.*
- **Location.** ConditionalWeights docstring, **Correspondence**, lines 78–85 ("The exit bound is the counting form of what that reading asks of a margin … It reads the margin and the spread, and no generative model of the system"); NOTE §4.3; NOTE §4, last paragraph ("The candidate is the margin law: whatever an agent's generative model, …").
- **What is wrong.**
  - The bound concerns a balanced level that nothing reads; NOTE §4.4 says so ("no giving law reads the level here, and the level only fluctuates"). For such a level n·p·q/m² reaches one at n = m²/(p·q), and the share itself tends to one: with p = q = 1 and m = 10 the share falling within n steps is 0.04 at n = 25, 0.32 at 100, 0.62 at 400 and 0.84 at 2500 (exact enumeration, not Lean). What the principle calls persisting is what a system does against this dispersion. The bound is the case that reading is measured against, not what it asks of a margin.
  - "No generative model of the system" depends on a term used two ways. In the principle's own terms the generative model is the system's density over its states; the weighting is its counting form, and the bound reads it through its spread. In active inference's process theory the weighting is the generative process, and "whatever an agent's generative model" is then true but empty: no agent's model occurs in the statement, and its only route to the exit share, acting on the level, is what the bound excludes.
  - So the candidate forbids nothing the principle leaves open: it constrains the weighting, which the principle takes as given.
- **Fix.**
  - Module docstring, replace the two sentences from "The exit bound is the counting form" to "no generative model of the system." with: "The exit bound is the case that reading is measured against: a balanced level that nothing reads leaves a margin `m` within `n` steps on at most `n·p·q` over `m·m` of the weight, so leaving has surprisal at least `log (m·m / (n·p·q))` where `m·m` exceeds `n·p·q`. The bound is void from `n = m·m / (p·q)`, and such a level leaves every margin in time; persisting longer needs a giving that reads the level. The bound reads the weighting, the counting form of a generative density, only through its spread; no belief (recognition density) enters, as one does in free energy."
  - NOTE §4.3: the same change.
  - NOTE §4, last paragraph: replace the candidate with "UE2 adds no third part: the margin law constrains the weighting, which the principle takes as given, and quantifies over no agent's model."

**2. Near-definitional laws, and free energy without a counting form.** *Overclaim.*
- **Location.** NOTE §1 ("Shares and Bayes's rule", "Shares under independence and surprise") and §4.1–4.2; module docstring, first three bullets; UE1 NOTE §3, first row: "the theory states them in counting form only once UE2 lands".
- **What is wrong.**
  - `mass_given` unfolds the definition of `given`. `given_given` and `given_comm` are case splits on two Booleans. `Share.le_iff_reciprocal` is commutativity of multiplication, and `Share.reciprocal_mul` is `rfl`. `joint_eq_record_times_given` is `Nat.mul_comm` after `whole_given` and `mass_given`, and `joint_two_ways` is a rearrangement of four factors after the same unfoldings. Bayes's rule in finite counting is an identity, which is fine. But these are definitions and their unfoldings. The 93 theorems include them and the 46 helpers the NOTE lists.
  - The Lean shows no addition. "Multiplies where surprisal adds" is a reading through a logarithm the core does not take. The reciprocal share is a faithful counting form of pointwise surprisal: its order and its products are surprisal's order and sums. It is not a counting form of surprisal's averages. An average of logarithms is not the logarithm of an average (Jensen), so entropy and free energy, both averages, have no reciprocal-share form.
  - UE1's premise card says the theory states belief, surprisal and free energy in counting form once UE2 lands. Free energy is stated only in the periphery, over the reals.
- **Fix.**
  - Label conditioning, Bayes's rule and the order of surprise "near-definitional (identities of counting)" in the NOTE, the module docstring and their record, as UE1 labels its part 1.
  - Drop `joint_eq_record_times_given` and `Share.reciprocal_mul` as theorems, or keep them as remarks. The record lists laws, not counts.
  - At landing, rewrite UE1 NOTE §3, first row, last cell: "the principle states belief, surprisal and free energy; the theory states belief (the posterior share) and pointwise surprisal (through the reciprocal share) in counting form, and free energy and its bound in the periphery over the reals".

### Conditioning, Bayes's rule and shares

**3. "Prior" is the prior share only where the likelihood totals agree.** *Imprecision.*
- **Location.** The docstrings of `joint` (line 496, "the hypothesis's weight"), `mass_joint`, `evidence`, `posterior_single` and `posterior_le_iff_single` ("prior weights times likelihood weights"); module docstring, lines 27–35 and the Correspondence, lines 72–75; NOTE §1 (generative-model bullets) and §4.1.
- **What is wrong.**
  - The courses of hypothesis `h` weigh `prior h · Σₒ lik h o`, not `prior h`. With equal prior weights and likelihood totals 1 and 3, the hypotheses' shares before any record are 1 and 3 (probe `prior_not_prior_share`).
  - So `prior h` is P(h), and `mass os (lik h) rec` is P(o | h), only where every listed hypothesis's likelihood weights have the same total: the counting form of P(· | h) summing to one. `Witness.record_reverses` has totals 5 and 5.
  - `evidence` is the record's weight; its share of the whole is the marginal likelihood. The theorems hold as identities of weights. Only the readings need the premise.
- **Fix.**
  - In the module Correspondence and NOTE §4.1, after "`posterior_single` is its posterior": "This reads `prior h` as P(h) and the record's weight under `h` as P(o | h), which holds where every listed hypothesis's likelihood weights have one total. Otherwise P(h) is `prior h · Σₒ lik h o` over the whole, and `evidence` over the whole is the marginal likelihood."
  - In `joint`'s docstring, "the hypothesis's weight" becomes "the hypothesis's prior weight".
  - Optionally add `prior_share`: under a common total `L`, the share of a hypothesis listed once is ⟨prior h₀ · L, (Σ prior) · L⟩.

**4. Conditioning is stated for natural weightings only.** *Imprecision.*
- **Location.** Module docstring, lines 6–12 ("for every weighting of steps"; "what a record does to a weighting"). NOTE §1's opening, "a natural weighting", is right.
- **What is wrong.**
  - `mass`, and so `given` and `share`, takes natural weights. Weighted's other weightings are not covered.
  - For signed counts, restriction is not conditioning. A restricted signed mass can balance to (k, k), so its "share" is no part within a whole. Quantum conditioning on a record goes through squared amplitudes and records that decohere, not restriction of amplitudes.
  - For possibility, restriction is the possibilistic case (the elimination in `Learning`), with no share.
- **Fix.**
  - Line 10: "what a record does to a natural weighting".
  - Add to "What is not derived": "possibility and signed counts: for possibility restriction is conditioning, without shares; signed counts cancel, so a restricted signed weighting has no share".
  - Optional (rule 9): if `Learning`'s elimination is to be read as a case of conditioning, state `given` once for every `Weights`, and show that `support` commutes with it.

**5. Shares with a zero whole.** *Imprecision.*
- **Location.** `Share.le`, `Share.Same` (lines 303–307); the docstring of `joint_two_ways` and NOTE §1 ("with no condition"); the docstrings of `given_independent`, `record_share` and `record_bound`; NOTE §1: "the share order is a preorder".
- **What is wrong.**
  - Compared by cross-multiplication, a share with whole 0 is at most and at least every share, and the same ratio as any (probe `zero_whole_wildcard`).
  - So the laws given a record say nothing where the record weighs nothing. "With no condition" holds only in that degenerate sense.
  - The order is not transitive through a zero whole: ⟨1,1⟩ ≤ ⟨0,0⟩ ≤ ⟨0,1⟩, but not ⟨1,1⟩ ≤ ⟨0,1⟩ (probe `le_not_transitive`). It is a preorder only on shares with a positive whole, which is what `Share.le_trans` assumes.
- **Fix.**
  - Module docstring, after the sentence introducing `Share`: "A share with a zero whole compares either way with every share and is the same ratio as any. So the laws given a record (`joint_two_ways`, `given_independent`, `record_share`, `record_bound`) say nothing where the record weighs nothing."
  - NOTE §1: "a preorder on shares with a positive whole"; and "with no condition (where record and hypothesis weigh something; otherwise one side is degenerate)".

**6. Three docstring sentences say more than their theorems.** *Overclaim.*
- **Location and fix.**
  - Line 42: "both are at least as surprising as either (`share_product_le`, …)". The theorem compares the joint share with the first share only. Write "as the first", or add `share_product_le_right` (probe, built).
  - Line 59: "The count at some step exceeds the count at the end". The witness shows it can; in general the count at some step is only at least the count at the end. Write "can exceed".
  - Line 779: `deviates_bound` is headed "The exit bound", but it bounds the two-sided deviation at the horizon, not an exit. Write "The deviation bound at the horizon".

### The exit and record laws

**7. "Falls to the need" is not a break.** *Imprecision.*
- **Location.** NOTE §4.4 ("a bound on breaks … breaks within n steps") and §4.5 ("the conditional share of a break"); the docstrings of `record_fallsWithin`, `record_share` and `record_bound` ("break"); `Witness.within_exceeds_end` ("ends there on one").
- **What is wrong.**
  - `fallsTo` and `fallsWithin` test `x + m ≤ y`: the level at the need or below it.
  - The core counts a formation supported where its need is within the level (`Web.Supported`: need ≤ level; 02 §5), so a level standing at its need is not a break. With p = q = 1 and margin 1, one step brings the level to the need on one course of two and below it on none (probe `falls_to_not_below`).
  - A break, the level below the need, is falling to it from `m + 1`, so its bound is n·p·q/(m + 1)². The stated bound holds for breaks but is weaker, and the two events differ.
  - In the witness, the course that ends fallen ends below the need, not at it.
- **Fix.**
  - Gloss `fallsTo` and `fallsWithin` as "reaches the need or falls below it".
  - Replace "break" with "falls to the need" in the three record docstrings and in NOTE §4.4–4.5.
  - Add to NOTE §4.4: "a break, the level below the need, is falling to it from m + 1, so `fallsWithin_bound p q (m + 1) n` bounds it by n·p·q/(m + 1)²".
  - In the witness, "ends there on one" becomes "ends below it on one".

**8. The record laws' hypotheses quantify over lists of every length.** *Imprecision.*
- **Location.** `mass_record` (`carries`); `record_fallsWithin`, `record_share` and `record_bound` (`shows`).
- **What is wrong.** `shows : ∀ u, R u = true → …` asks the margin of every list on which `R` holds, though only the courses of `k` steps matter. A natural record of the earliest step, read on every list, fails it (probe `record_hypothesis_over_lengths`), though on the courses of one step it holds (`record_hypothesis_at_length`). The laws are true but harder to apply than "a record of the earliest `k` steps" suggests.
- **Fix.** Use `shows : ∀ u, u.length = k → R u = true → …` and `carries : ∀ u v, u.length = k → R u = true → v.length = n → …`. In `mass_record`, use `mass_congr_mem` over `Typicality.courses k` with `Typicality.mem_courses_iff`. Probe `mass_record_at` is this proof; it builds with an empty axiom report.

**9. Two scope statements about the bounds.** *Imprecision.*
- **Location and fix.**
  - The surprisal reading "at least `log (m·m / (n·p·q))`" (module docstring, lines 82–83; NOTE §4.3) says nothing where m·m ≤ n·p·q, since the logarithm is then at most zero. Add "where m·m exceeds n·p·q".
  - NOTE §5: "Exponential exit bounds, which `Typicality.concentrated` would give one-sided". `concentrated` bounds the ones at the horizon, so it gives an exponential bound on ending fallen (`fallsTo`). Falling within the horizon needs a maximal form, stopping the tilted weights as `typical_throughout` stops the square. Write: "An exponential bound on ending fallen follows from `concentrated`; one on falling within the horizon needs its maximal form, not proved."

**10. T6's seen half needs the weighting as its warranted model.** *Imprecision.*
- **Location.** NOTE §4.5; module docstring, lines 87–90.
- **What is wrong.**
  - `record_share` reads the exit off three things: the margin the record shows, the steps left, and p·q.
  - The weights are not read from the record; they are a premise. T6 lets nearness be read where level and need couple in "or where an independently warranted model or bound supplies what does not". Here the weighting is that model.
  - "Nothing else in the record matters" is the independence of the steps, given that model.
- **Fix.** NOTE §4.5 and the module docstring: "… reads off the margin the record shows, the steps it leaves and the spread of the weighting, which the record does not show. The weighting is the independently warranted model T6 allows; given it, nothing else in the record matters, the steps being independent."

**11. Sharper exit bounds.** *Suggestion.*
- **Breaks.** For breaks the bound is n·p·q/(m + 1)² (finding 7).
- **One-sided form.** Kolmogorov's inequality has a one-sided form (Cantelli's): the courses falling to the need within the horizon weigh, times `n·p·q + m·m`, at most `n·p·q·(p + q)^n`.
  - This is never above one and always below n·p·q/m². With p = q = 1 and m = 10 it gives 0.20, 0.50 and 0.80 at n = 25, 100 and 400, against 0.25, 1 and 4 (exact shares 0.04, 0.32, 0.62; direct computation).
  - Its proof is `typical_throughout`'s stopping argument, with two changes. It stops at the first fall, not at the first squared deviation of `d`. It bounds the stopped square of `y − x + c`, with `c = n·p·q / m` scaled to whole numbers, using that the stopped deviation keeps mean zero (a stopped `rises_balance_falls`) and spread at most n·p·q.
- An extension, not needed for landing.

### Rule 9, duplicates and names

**12. Laws beside landed laws, and the leaf reason.** *Imprecision.*
- **Location.** NOTE §1, the helpers paragraph ("a search of the core … found none they duplicate"); NOTE §2, last paragraph ("which no existing law states in a special case"); the declarations below.
- **What is wrong.**
  - **The binomial mean.** `rises_step`, `falls_step` and `rises_balance_falls` restate the binomial mean of `Drift.weighted_ones_step`, `weighted_zeros_step`, `expected_ones` and `expected_zeros`. (p + q)·Σ weight·ones = n·p·(p + q)ⁿ and its zeros form give `rises_balance_falls` after multiplying by q and p and cancelling p + q. No theorem uses `rises_balance_falls`.
  - **The margin square.** `margin_square` generalizes `Typicality.two_mul_le_of_le`, its case m = 0 (built as V2), and is `Drift.far_back` at N = n = 1. `square_gap` is the identity inside both.
  - **The total weight.** `whole_courses` generalizes `Typicality.transfer_weight` (two values, through `Weights.sum_courses`) and lands above it, as the NOTE's own consolidation remark says.
  - **The share order.** `Share.le_trans` repeats line for line the transitivity calc of `RuleCapture.CarrierCounts.order`, which is the same cross-multiplication order.
  - **Mass helpers.** `mass_append` and `mass_map` restate `Flow.total_append` and `Flow.total_map` (and `Weights.sum_append`, `Weights.sum_map`) through `mass_eq_total`.
- **Fix.**
  - With the Typicality change, move `regroup_square`, `square_gap` and `margin_square` into Typicality and derive `two_mul_le_of_le` from `margin_square` (V2, built). Offer Drift's owner `far_back`'s identity from `square_gap`.
  - Either drop `rises_balance_falls` and its two step lemmas and cite `Drift.expected_ones` and `expected_zeros` in `fallsTo`'s docstring, or move the binomial mean down into Typicality and derive both from it (Drift's owner decides).
  - Either move `whole_courses` and `mass_meetsEach` into `Becoming.Weighted` and derive `Typicality.transfer_weight` from them (Weighted's owner decides), or let the row say why `whole_courses` lands above `transfer_weight`.
  - Rewrite the NOTE's duplicate search and its leaf reason to list these.

**13. Names.** *Suggestion.*
- **`given`.** It is the core's word for what is given (glossary: "giving: what is given"; `Flow.given`, `InAmounts.given`, `Counting.given`, `Exchange.given`). The module's own law calls conditioning restriction, and `restrict` (with `mass_restrict`, `whole_restrict`, `restrict_restrict`, `restrict_comm`) says it exactly. Rename at claim time, before landing.
- **`entry_le`.** Inside the `Becoming` namespace it shadows `Becoming.entry_le` of Weighted, a different statement. Rename it `entry_test_le`.
- **`joint`, `prior` and `lik`.** `joint` meets the core's "joint draw" and "joint excess"; `pairWeight` is exact. `prior` and `lik` are exact under finding 3's premise.
- **The periphery module.** Under rule 8 it is named after the core law it instantiates, as [`regime/RegimeReals.lean`](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/regime/RegimeReals.lean) is after `Becoming.RegimeMargin`. `ConditionalWeightsReals` fits, with the free-energy names kept in the docstrings as the correspondence.

### The periphery draft

**14. The docstring names a declaration that does not exist.** *Error.*
- **Location.** `VariationalBound.lean`, line 9: "Bayes's rule in counting form (`bayes`, `posterior_single`)".
- **What is wrong.** ConditionalWeights has no `bayes`. Bayes's rule is `joint_two_ways`.
- **Fix.** Replace `bayes` with `joint_two_ways`.

**15. The bound is met at the posterior, but "only there" is not proved.** *Imprecision.*
- **Location.** `VariationalBound.lean` docstring ("The bound is met at the posterior"; Correspondence: "the posterior at which the bound is met"); NOTE §3.
- **What is wrong.** `free_energy_posterior` shows equality at q = p/Σp. It does not show the bound is met only there. That converse is Gibbs's equality case, and it is what makes minimizing free energy recover the posterior, the principle's point. "The posterior at which the bound is met" reads as the only such point.
- **Fix.** Add `free_energy_eq_iff`: equality exactly where q i = p i / Σ p for every cause ([appendix B](#appendix-b-periphery-additions); compiles against the pinned Mathlib with the three standard axioms).

**16. Positive weights exclude hypotheses a record rules out.** *Imprecision.*
- **Location.** `free_energy_ge_surprisal` (`hp : 0 < p i`); `free_energy_ge_surprisal_counts` (`hw : 0 < w i`); NOTE §3 (the planned join to `posterior_single`).
- **What is wrong.**
  - In a counting generative model a record can weigh nothing under a hypothesis (`Witness.lik true false = 0`), so a joint weight can be zero. The corollary then does not apply, yet the join to `posterior_single` needs it for every such model.
  - Under Mathlib's `log 0 = 0` the inequality fails if q puts weight where p is zero, so the right hypothesis is support, not positivity.
  - `hs` follows from Σ q = 1.
- **Fix.**
  - Add `free_energy_ge_surprisal_support`: p ≥ 0, with q zero wherever p is ([appendix B](#appendix-b-periphery-additions); compiles).
  - Under rule 9, derive the positive form from it.
  - Drop `hs`; the fact is `nonempty_of_total` in appendix B.

**17. Checker and join.** *Suggestion.*
- **The set-up in the repository.**
  - Each periphery module has its own folder under `lean/`, with `check_<name>.py`, a receipt `<name>-verification.json` and run folders `<name>-checks/<utc>/` ([`representation/`](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/representation/check_representation.py), `physics/`, `regime/`, `warning/`).
  - The checker compiles with Lean 4.30.0-rc2 against the Mathlib pinned in [`periphery-mathlib-pin`](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/periphery-mathlib-pin/README.md) (`SYSTEMS_MATHLIB_PROJECT`, revision `ea11ccc0…`).
  - Where the module imports a core module, the checker compiles that module's closure with the same toolchain, and every other module in the closure must match a passed core receipt (`inherited_receipts`).
  - Each declaration's axioms are reported, and any axiom beyond `propext`, `Classical.choice` and `Quot.sound` fails the run. Steps are reused, keyed also by the Mathlib revision.
  - A record binds the receipt through `proof_bindings` at `/source_sha256/<Module>`. `regime/check_regime_reals.py` (RegimeReals imports `Becoming.RegimeMargin`) is the nearest template.
- **The join, as a target** (not compiled here; it needs the checker), in a module importing `Becoming.ConditionalWeights`:

  ```lean
  theorem share_surprisal_le_free_energy [DecidableEq α] (prior : α → ℕ) (lik : α → β → ℕ)
      {hs : List α} (os : List β) (rec : β → Bool) (distinct : Becoming.Distinct hs)
      (q : α → ℝ) (hq : ∀ h ∈ hs, 0 ≤ q h) (hq1 : (hs.map q).sum = 1)
      (support : ∀ h ∈ hs, prior h * Becoming.mass os (lik h) rec = 0 → q h = 0) :
      let r := ConditionalWeights.share (Becoming.openSteps hs os)
        (ConditionalWeights.joint prior lik) (fun c => rec c.2)
      -Real.log ((r.part : ℝ) / r.whole) ≤
        (hs.map fun h => q h * (Real.log (q h) -
          Real.log ((prior h * Becoming.mass os (lik h) rec : ℕ) / (r.whole : ℝ)))).sum
  ```

  - The equality case: equality exactly where every listed `q h` is the part over the whole of `posterior_single`'s share.
  - Ingredients: a cast lemma `(mass l w e : ℝ) = (l.map fun x => if e x = true then (w x : ℝ) else 0).sum`; `evidence`; the sum over a list without repeats as a sum over its finset; `free_energy_ge_surprisal_support`; and, for the equality, `free_energy_eq_iff` with `posterior_single`.

### The Typicality change and the landing

**18. The new bullet's title.** *Overclaim.*
- **Location.** Kit Typicality docstring, line 31: "**Most courses show the weights at every step.**"
- **What is wrong.**
  - `typical_throughout` bounds the deviation x − y at every step k ≤ n by one amount fixed by the horizon.
  - With d = ((p + q)·ε·n)², as in `typical`'s frequency reading, this says the count of ones stays within ε·n of k·p/(p + q) at every step. That bounds the frequency at step k only within ε·n/k, which says nothing at early steps.
  - The frequencies show the weights at the horizon; the counts stay near their means throughout.
- **Fix.**
  - Title: "**The deviation stays within the bound at every step.**"
  - After "(`typical_throughout`)", add: "read with d = ((p + q)·ε·n)², the courses whose count of ones strays from k·p/(p + q) by ε·n or more at some step k ≤ n weigh at most p·q/((p + q)²·ε²·n) of the whole".

**19. The landing list.** *Imprecision.*
- **Location.** NOTE §2 ("For the lander") and §6.2.
- **What is wrong.**
  - Four records bind `Typicality.lean`, each by a reference with sha256 `90497689…` and a proof binding to a core receipt: [typicality-by-counting](../../../../../../theories/becoming/results/records/typicality-by-counting.json), [weights-count-situations](../../../../../../theories/becoming/results/records/weights-count-situations.json), [drift-offspring-sampled](../../../../../../theories/becoming/results/records/drift-offspring-sampled.json) and [fixation-by-drift](../../../../../../theories/becoming/results/records/fixation-by-drift.json). All four show source drift and an invalid binding once Typicality changes.
  - The list also omits steps UE1's landing took:
    - the root `Becoming.lean` import and bullet;
    - `check_becoming.py`'s core list and SCOPE text (Typicality's sentence and a new one);
    - the package README rows, EN and ZH (Typicality's and a new one);
    - 08 §1's receipt and counts;
    - `regions.json` for the new records;
    - the new leaf's apart roots for the connectivity check;
    - the study section;
    - the row's leaf reason (finding 12).
- **Fix.**
  - Add these to §6.2.
  - Re-point the three records whose claims do not change with `tools/research/repoint.py --receipt <new core receipt> --lean <Typicality.lean>`, which logs one `rebinds.jsonl` line.
  - Give typicality-by-counting a history note (below).

## The Typicality change

**What it is.** It is the landed file plus one section before `typical`, eight definitions and ten theorems. `typical`'s statement is unchanged, and its proof is now two lines from `typical_throughout` and `offBy_le_within`. A docstring bullet and a source sentence are added. The diff shows nothing else.

**Rule 9.** This is the case the rule names.
- `typical_throughout` implies `typical`, since `offBy ≤ offByWithin` at every course.
- It is strictly stronger: with p = q = 1 and d = 1, two of the four courses of two steps end a deviation of one away, and all four reach it at some step (probe `throughout_exceeds_end`).
- It uses only Typicality's own courses, weights and step identities (`weighted_square`, `weighted_cross`, `step_weight`, `total_weight`).
- Moved into ConditionalWeights, it would leave `typical` with its direct proof beside a law that implies it: two reasons for one fact, and higher counts.

**Builds.** The six downstream core modules build against the kit's Typicality with every axiom report empty, and they build against V1 and V2 too.

**What breaks, record by record.**

| Record | Cites from Typicality | Needs |
|---|---|---|
| typicality-by-counting | 52 declarations; law 3 cites `offBy_le`; the validation scope says 56 and 43 (15 October receipt; 52 and 40 at the current receipt) | A history note: the maximal law in law 3 or a new law, with its declarations. `offBy_le` out of law 3, `references` and `aliases`. The margin lemmas join its references (V2). Counts 52 theorems in 72 declarations at the new receipt (V2). Re-point. |
| weights-count-situations | `offBy`, `typical` and 14 others | Re-point only |
| drift-offspring-sampled | `spread`, `two_mul_le`, `total_extend`, `total_weight`, `weight`, `courses` | Re-point only |
| fixation-by-drift | `total_congr_mem`, `total_extend`, `total_weight`, `weight`, `courses` | Re-point only |

Also: 03's home section `r-typicality-by-counting` gains the maximal law, with `Typicality.typical_throughout` in its Lean list. Typicality's README rows (EN and ZH) and the checker's SCOPE sentence change with it.

**Recommendation: land the change in Typicality, not in ConditionalWeights, with three amendments.**
1. Delete `offBy_le`, the remains of the direct proof, which nothing uses (V1 builds), and re-point law 3.
2. Retitle the bullet (finding 18).
3. Move `regroup_square`, `square_gap` and `margin_square` into Typicality and derive `two_mul_le_of_le` from `margin_square` (V2 builds; finding 12).

Decide it on the board. Typicality's owner, the fork session that landed P116 on 16 October, is not active, and no definition changes, so the UE2 lander takes it through the queue and the row says so.

Optional, for Drift's owner: `Drift.falls_back` re-runs the spread argument beside `typical`. With `margin_square` in Typicality it can be read from `typical` at a scaled margin.

## Appendix A: the probe module

Built as `Becoming.UE2ReviewTests` in a scratch tree beside unchanged copies of the kit's two modules (9 theorems in 12 declarations).

```lean
import Becoming.ConditionalWeights

namespace Becoming
namespace UE2ReviewTests
open ConditionalWeights

theorem zero_whole_wildcard (a : Share) :
    (⟨0, 0⟩ : Share).le a ∧ a.le ⟨0, 0⟩ ∧ (⟨0, 0⟩ : Share).Same a :=
  ⟨show 0 * a.whole ≤ a.part * 0 by rw [Nat.zero_mul]; exact Nat.zero_le _,
   show a.part * 0 ≤ 0 * a.whole from Nat.zero_le _,
   show 0 * a.whole = a.part * 0 by rw [Nat.zero_mul]; rfl⟩

theorem le_not_transitive :
    (⟨1, 1⟩ : Share).le ⟨0, 0⟩ ∧ (⟨0, 0⟩ : Share).le ⟨0, 1⟩ ∧ ¬ (⟨1, 1⟩ : Share).le ⟨0, 1⟩ :=
  ⟨Nat.le_refl 0, Nat.le_refl 0, fun h => (by decide : ¬ (1 * 1 ≤ 0 * 1)) h⟩

def priorEven : Bool → Nat := fun _ => 1

def likUneven : Bool → Bool → Nat
  | false, false => 1
  | false, true => 0
  | true, false => 1
  | true, true => 2

theorem prior_not_prior_share :
    mass (openSteps [false, true] [false, true]) (joint priorEven likUneven) (fun c => !c.1) = 1 ∧
      mass (openSteps [false, true] [false, true]) (joint priorEven likUneven) (fun c => c.1) = 3 :=
  ⟨rfl, rfl⟩

theorem falls_to_not_below :
    mass (Typicality.courses 1) (Typicality.weight 1 1) (fallsWithin 1 1 1) = 1 ∧
      mass (Typicality.courses 1) (Typicality.weight 1 1) (fallsWithin 1 1 2) = 0 :=
  ⟨rfl, rfl⟩

def earliestOne : List Bool → Bool
  | [] => false
  | b :: [] => b
  | _ :: c :: w => earliestOne (c :: w)

theorem record_hypothesis_over_lengths :
    ¬ ∀ u, earliestOne u = true →
      1 + Typicality.ahead 1 u = 2 + Typicality.behind 1 u ∧ fallsWithin 1 1 1 u = false :=
  fun shows => absurd (shows [false, true] rfl).1 (by decide)

theorem record_hypothesis_at_length :
    ∀ u : List Bool, u.length = 1 → earliestOne u = true →
      1 + Typicality.ahead 1 u = 2 + Typicality.behind 1 u ∧ fallsWithin 1 1 1 u = false
  | [], len, _ => absurd len (by decide)
  | b :: [], _, h => by
    cases b with
    | false => exact absurd h (by decide)
    | true => exact ⟨rfl, rfl⟩
  | _ :: _ :: _, len, _ => absurd len (fun h => Nat.succ_ne_zero _ (Nat.succ.inj h))

theorem mass_record_at (p q k n : Nat) (R E F : List Bool → Bool)
    (carries : ∀ u v : List Bool, u.length = k → R u = true → v.length = n → E (v ++ u) = F v) :
    mass (Typicality.courses (k + n)) (Typicality.weight p q) (fun w => R (w.drop n) && E w) =
      mass (Typicality.courses k) (Typicality.weight p q) R *
        mass (Typicality.courses n) (Typicality.weight p q) F := by
  rw [courses_add k n, mass_joinMap]
  refine (mass_congr_mem (e := fun _ => true) (e' := R)
      (w' := fun u => Typicality.weight p q u * mass (Typicality.courses n) (Typicality.weight p q) F)
      (fun u memu => ?_)).trans
    (mass_mul_right _ (Typicality.weight p q) R (Typicality.courses k))
  have lenu : u.length = k := Typicality.mem_courses_iff.mp memu
  show mass ((Typicality.courses n).map (· ++ u)) (Typicality.weight p q)
      (fun w => R (w.drop n) && E w) =
    if R u = true then Typicality.weight p q u * mass (Typicality.courses n) (Typicality.weight p q) F
    else 0
  rw [mass_map]
  cases hR : R u with
  | false =>
    exact (mass_congr_mem (w' := Typicality.weight p q) (e' := fun _ => false) fun v mem => by
      have len : v.length = n := Typicality.mem_courses_iff.mp mem
      show (if (R ((v ++ u).drop n) && E (v ++ u)) = true then Typicality.weight p q (v ++ u)
        else 0) = 0
      rw [show (v ++ u).drop n = u from len ▸ drop_append_length v u, hR]
      rfl).trans (mass_none _ _)
  | true =>
    refine (mass_congr_mem (w' := fun v => Typicality.weight p q v * Typicality.weight p q u)
      (e' := F) fun v mem => ?_).trans
      ((mass_mul_right _ (Typicality.weight p q) F (Typicality.courses n)).trans (Nat.mul_comm _ _))
    have len : v.length = n := Typicality.mem_courses_iff.mp mem
    show (if (R ((v ++ u).drop n) && E (v ++ u)) = true then Typicality.weight p q (v ++ u)
      else 0) = (if F v = true then Typicality.weight p q v * Typicality.weight p q u else 0)
    rw [show (v ++ u).drop n = u from len ▸ drop_append_length v u, hR, carries u v lenu hR len,
      weight_append]
    rfl

theorem share_product_le_right {α β : Type} (w₁ : α → Nat) (w₂ : β → Nat) (e₁ : α → Bool)
    (e₂ : β → Bool) (as : List α) (bs : List β) :
    (share (openSteps as bs) (fun c => w₁ c.1 * w₂ c.2) (fun c => e₁ c.1 && e₂ c.2)).le
      (share bs w₂ e₂) := by
  rw [share_product w₁ w₂ e₁ e₂ as bs]
  show mass as w₁ e₁ * mass bs w₂ e₂ * mass bs w₂ (fun _ => true) ≤
    mass bs w₂ e₂ * (mass as w₁ (fun _ => true) * mass bs w₂ (fun _ => true))
  have eq : (share as w₁ e₁).whole * mass bs w₂ e₂ * mass bs w₂ (fun _ => true) =
      mass bs w₂ e₂ * ((share as w₁ e₁).whole * mass bs w₂ (fun _ => true)) := by
    rw [Nat.mul_comm (share as w₁ e₁).whole (mass bs w₂ e₂), mul_assoc_nat]
  exact Nat.le_trans
    (Nat.mul_le_mul_right _ (Nat.mul_le_mul_right _ (share_within as w₁ e₁)))
    (Nat.le_of_eq eq)

theorem throughout_exceeds_end :
    total (Typicality.courses 2) (Typicality.offBy 1 1 1) = 2 ∧
      total (Typicality.courses 2) (Typicality.offByWithin 1 1 1) = 4 :=
  ⟨rfl, rfl⟩

end UE2ReviewTests
end Becoming
```

## Appendix B: periphery additions

Appended inside `namespace VariationalBound` to a copy of the draft and compiled with `lake env lean` against the pinned Mathlib. No error or warning; each theorem depends on `propext`, `Classical.choice` and `Quot.sound`.

```lean
theorem term_eq_iff {qi pi P : ℝ} (hq : 0 ≤ qi) (hp : 0 < pi) (hP : 0 < P) :
    qi * (Real.log pi - Real.log qi - Real.log P) = pi / P - qi ↔ qi = pi / P := by
  have hP0 : P ≠ 0 := hP.ne'
  constructor
  · intro h
    rcases hq.eq_or_lt with h0 | h0
    · rw [← h0, zero_mul, sub_zero] at h
      exact absurd h.symm (div_pos hp hP).ne'
    · by_contra hne
      have hx : pi / (qi * P) ≠ 1 := by
        intro h1
        apply hne
        rw [div_eq_one_iff_eq (mul_pos h0 hP).ne'] at h1
        rw [h1]
        field_simp
      have hlt := Real.log_lt_sub_one_of_pos (div_pos hp (mul_pos h0 hP)) hx
      have hlog : Real.log pi - Real.log qi - Real.log P = Real.log (pi / (qi * P)) := by
        rw [Real.log_div hp.ne' (mul_pos h0 hP).ne', Real.log_mul h0.ne' hP.ne']
        ring
      rw [hlog] at h
      have hm : qi * Real.log (pi / (qi * P)) < qi * (pi / (qi * P) - 1) :=
        mul_lt_mul_of_pos_left hlt h0
      have e : qi * (pi / (qi * P) - 1) = pi / P - qi := by
        field_simp
      linarith
  · intro h
    rw [h, Real.log_div hp.ne' hP0]
    ring

theorem free_energy_eq_iff (s : Finset ι) (q p : ι → ℝ) (hq : ∀ i ∈ s, 0 ≤ q i)
    (hq1 : ∑ i ∈ s, q i = 1) (hp : ∀ i ∈ s, 0 < p i) (hs : s.Nonempty) :
    ∑ i ∈ s, q i * (Real.log (q i) - Real.log (p i)) = -Real.log (∑ i ∈ s, p i) ↔
      ∀ i ∈ s, q i = p i / ∑ j ∈ s, p j := by
  set P := ∑ i ∈ s, p i with hPdef
  have hP : 0 < P := Finset.sum_pos hp hs
  have le : ∀ i ∈ s, q i * (Real.log (p i) - Real.log (q i) - Real.log P) ≤ p i / P - q i :=
    fun i hi => term_le (hq i hi) (hp i hi) hP
  have rhs : ∑ i ∈ s, (p i / P - q i) = 0 := by
    rw [Finset.sum_sub_distrib, ← Finset.sum_div, ← hPdef, div_self hP.ne', hq1, sub_self]
  have lhs : ∑ i ∈ s, q i * (Real.log (p i) - Real.log (q i) - Real.log P) =
      -(∑ i ∈ s, q i * (Real.log (q i) - Real.log (p i))) - Real.log P := by
    have split : ∀ i, q i * (Real.log (p i) - Real.log (q i) - Real.log P) =
        -(q i * (Real.log (q i) - Real.log (p i))) - q i * Real.log P := fun i => by ring
    rw [Finset.sum_congr rfl fun i _ => split i, Finset.sum_sub_distrib, Finset.sum_neg_distrib,
      ← Finset.sum_mul, hq1, one_mul]
  constructor
  · intro hF i hi
    have hsum : ∑ i ∈ s, q i * (Real.log (p i) - Real.log (q i) - Real.log P) =
        ∑ i ∈ s, (p i / P - q i) := by
      rw [lhs, rhs]
      linarith
    exact (term_eq_iff (hq i hi) (hp i hi) hP).mp ((Finset.sum_eq_sum_iff_of_le le).mp hsum i hi)
  · intro hall
    have hsum : ∑ i ∈ s, q i * (Real.log (p i) - Real.log (q i) - Real.log P) =
        ∑ i ∈ s, (p i / P - q i) :=
      (Finset.sum_eq_sum_iff_of_le le).mpr fun i hi =>
        (term_eq_iff (hq i hi) (hp i hi) hP).mpr (hall i hi)
    rw [lhs, rhs] at hsum
    linarith

theorem free_energy_ge_surprisal_support (s : Finset ι) (q p : ι → ℝ) (hq : ∀ i ∈ s, 0 ≤ q i)
    (hq1 : ∑ i ∈ s, q i = 1) (hp : ∀ i ∈ s, 0 ≤ p i) (support : ∀ i ∈ s, p i = 0 → q i = 0) :
    -Real.log (∑ i ∈ s, p i) ≤ ∑ i ∈ s, q i * (Real.log (q i) - Real.log (p i)) := by
  classical
  set t := s.filter (fun i => 0 < p i) with ht
  have sub : t ⊆ s := Finset.filter_subset _ _
  have out : ∀ i ∈ s, i ∉ t → p i = 0 := fun i hi hnt => by
    have npos : ¬ 0 < p i := fun pos => hnt (Finset.mem_filter.mpr ⟨hi, pos⟩)
    exact le_antisymm (not_lt.mp npos) (hp i hi)
  have sp : ∑ i ∈ t, p i = ∑ i ∈ s, p i := Finset.sum_subset sub fun i hi hnt => out i hi hnt
  have sq : ∑ i ∈ t, q i = ∑ i ∈ s, q i :=
    Finset.sum_subset sub fun i hi hnt => support i hi (out i hi hnt)
  have sf : ∑ i ∈ t, q i * (Real.log (q i) - Real.log (p i)) =
      ∑ i ∈ s, q i * (Real.log (q i) - Real.log (p i)) :=
    Finset.sum_subset sub fun i hi hnt => by rw [support i hi (out i hi hnt), zero_mul]
  have tne : t.Nonempty := by
    rcases Finset.eq_empty_or_nonempty t with h | h
    · exfalso
      have h0 : ∑ i ∈ t, q i = 0 := by rw [h, Finset.sum_empty]
      linarith [sq, hq1, h0]
    · exact h
  have bound := free_energy_ge_surprisal t q p (fun i hi => hq i (sub hi)) (sq.trans hq1)
    (fun i hi => (Finset.mem_filter.mp hi).2) tne
  rw [sp, sf] at bound
  exact bound

theorem nonempty_of_total (s : Finset ι) (q : ι → ℝ) (hq1 : ∑ i ∈ s, q i = 1) : s.Nonempty :=
  Finset.nonempty_of_sum_ne_zero (by rw [hq1]; exact one_ne_zero)
```

## Appendix C: the Typicality amendments, built as V2

Applied to the kit's Typicality, with the three lemmas removed from ConditionalWeights; ConditionalWeights' uses of `margin_square` then resolve through its `open Typicality`.

1. Delete `offBy_le` (its ten lines before the section "Most courses show the weights at every step").
2. Insert `regroup_square`, `square_gap` and `margin_square`, as written in ConditionalWeights, just before `two_mul_le_of_le`.
3. Replace `two_mul_le_of_le` with:

   ```lean
   /-- `2·x·y ≤ x·x + y·y` where `x ≤ y`: the margin square at margin zero. -/
   theorem two_mul_le_of_le {x y : Nat} (le : x ≤ y) : 2 * (x * y) ≤ x * x + y * y :=
     Nat.le_trans (Nat.le_of_eq (Nat.zero_add _).symm) (margin_square (m := 0) le)
   ```

Result: Typicality 52 theorems in 72 declarations, ConditionalWeights 90 in 106. TypicalRuns, Situations, Drift, FinerTraces, SituationTraces and HistorySums keep their counts. Every axiom report is empty.

## Re-check of the revision (8dfee102e)

This re-check is AI-authored and covers the kit as committed at `8dfee102e`: NOTE.md, LANDING.md, `tree/Becoming/ConditionalWeights.lean` (sha256 `311e0586…1c938c16`), `tree/Becoming/Typicality.lean` (sha256 `9eacd128…de6bc98`) and `periphery/ConditionalWeightsReals.lean` (sha256 `31532e34…4477b0`).

**How it was checked.**

- **Rebuild.** The revised tree was rebuilt with Typicality, ConditionalWeights and the six dependents: 88 steps, all reused from the shared cache, nothing unclean. ConditionalWeights has 92 theorems in 109 declarations and Typicality 52 in 72. The six dependents keep their counts, and every axiom report is empty.
- **Diffs.** The kit's Typicality, diffed against the landed file, is exactly the V2 amendments, plus the retitled bullet with its frequency reading.
- **Declarations.** Comparing the declaration lists before and after confirms the renames, additions and removals the drafter lists.
- **Probe.** Two theorems, every axiom report empty: `positive_part_zero_whole` and `reciprocal_of_impossible` (see N1 below).
- **Periphery.** The module was recompiled against the pinned Mathlib: no error or warning, and the three standard axioms, as logged.

### Verdict

The revision takes the review faithfully. 18 findings are addressed and one is partly addressed (12, whose reason has a false claim), and the new Lean is correct. The re-check finds five new issues: one small error, three imprecisions and a suggestion.

None blocks the core. ConditionalWeights and the Typicality change are ready to land once the three text fixes N1, N2 and N4 are made, with N3 applied to the record fields at landing. The periphery module stays out until it has a checker. Nothing in the core's Lean depends on it, and LANDING §4 keeps Gibbs' inequality unclaimed until it has a receipt.

### The findings

| # | Status | Note |
|---|---|---|
| 1 | Addressed | The Correspondence and NOTE §4.3 are in the review's words; no third part. |
| 2 | Addressed | Near-definitional labels; the two theorems are now remarks. UE1's premise card is corrected through `ue1-fep-bridge/NOTE-CORRECTIONS.md` §1. That is the right route, since the record capture-by-counted-choices cites NOTE §3. |
| 3 | Addressed | The premise is stated, with `prior_share` and `Witness.prior_not_share`. |
| 4 | Addressed | |
| 5 | Addressed | `Share.zero_whole`, `share_zero_whole`, `Witness.le_not_transitive`, and the four docstrings. One wording is too broad (N1); it came from this review's own phrasing. |
| 6 | Addressed | `share_product_le_right` builds. |
| 7 | Addressed | `fallsTo_succ` is by `rfl`. The bound for breaks is `fallsWithin_share` at `m + 1`. |
| 8 | Addressed | `shows` and `carries` take `u.length = k`; `mass_record` goes through `mass_congr_mem`. |
| 9, 10, 11 | Addressed | |
| 12 | Partly addressed | The Lean is done: the margin lemmas moved, the binomial mean dropped and the mass helpers derived. The stated reason for leaving `whole_courses` above `transfer_weight` is false (N2). |
| 13, 14 | Addressed | |
| 15, 16 | Addressed | `neg_log_sum_le` in support form is the main theorem; the equality is exact. |
| 17 | Addressed | A plan in LANDING §4; nothing is built, as appropriate. |
| 18 | Addressed | |
| 19 | Addressed | LANDING.md, with N3's corrections. |

### New issues

**N1. "A share with nothing in its whole compares either way with every share."** *Imprecision.*
- **Location.** Module docstring, lines 25–26; `Share.zero_whole`'s bold title; LANDING §2, record (a), law 2.
- **What is wrong.**
  - Only `⟨0, 0⟩` compares either way with every share. `⟨1, 0⟩` lies above `⟨0, 1⟩` but not below it (probe `positive_part_zero_whole`).
  - The reciprocal of the share of an event no course meets is such a share, `⟨2, 0⟩` over one step (probe `reciprocal_of_impossible`), and `fallsWithin_reciprocal` compares reciprocals.
  - The wording came from finding 5 above, which was loose. NOTE §1 has it right.
- **Fix.** "`⟨0, 0⟩`, the share of an event whose whole is nothing (`share_zero_whole`), compares either way with every share and is the same ratio as any."

**N2. Weighted is not imported by most of the core.** *Error (small).*
- **Location.** NOTE §2, the reason for leaving `whole_courses` above `transfer_weight`.
- **What is wrong.** The NOTE says Weighted "is imported by most of the core, so the move recompiles most of it". From the package's imports, 33 of the receipt's 306 core modules depend on `Becoming.Weighted` (34 of 320 package modules).
- **Fix.** State the number, or drop the reason. Weighted's owner's decision is the reason that stands.

**N3. Record fields in LANDING §2.** *Imprecision.*
- **What is wrong.**
  - Record (b) lists drift-offspring-sampled as a dependency "for the balanced level". But ConditionalWeights does not import Drift, and no theorem of (b) uses the binomial means: the bounds get the balance through Typicality's step identities. It is a `related` link, not an inference edge. The same holds for margin-of-a-regime, which supplies only vocabulary.
  - The formal reuse of `mass`, `mass_mono` and `IncludedOn` is from fulfillment-chance-floor, the record that cites them, not from sum-over-histories-exact. It belongs among the dependencies of (a) and (b).
  - In passing: LANDING §5 says "§408 is the latest", but §409 now exists.

**N4. The core docstring when it lands without the periphery.** *Imprecision.*
- **Location.** Module docstring, lines 98–100: "free energy and its bound are stated only in the periphery, over the reals (`development/ue2-conditional-weights/periphery`)".
- **What is wrong.** Once the core lands alone, this points from a landed module to an unchecked draft as if the result were stated.
- **Fix.** "drafted for the periphery, over the reals, with no receipt yet (…)". LANDING §3 already asks for the same check of UE1's NOTE-CORRECTIONS §1.

**N5. "Drift" in two senses.** *Suggestion.*
- **Location.** Module docstring, lines 63–64: "by the binomial means of `Becoming.Drift` … so no drift wears the margin down"; also line 122, "a level with a drift".
- **What is wrong.** `Becoming.Drift` is sampling drift. Here "drift" also means a mean change of the level. And the balance is arithmetic from those means, not a theorem of this module.
- **Fix.** "no mean change wears the margin down (arithmetic from `Drift.expected_ones` and `expected_zeros`)", and "a level whose rises and falls do not balance".

### What the records should and should not claim

**Should claim.**
- **(a)** The identities of counting on natural weightings of listed domains, labelled near-definitional:
  - restriction and total weight;
  - Bayes's rule as a ratio identity;
  - the generative model's posterior share and the comparison of hypotheses;
  - `prior_share` under one likelihood total;
  - joint shares at most either share;
  - step conjunctions over independent steps.

  The reading of the reciprocal share as pointwise surprisal goes under correspondence.
- **(b)** These laws:
  - Chebyshev at a margin, an instance of `typical`;
  - falling to the need within the horizon on at most n·p·q/m² of the weight, which is Kolmogorov's maximal inequality (1928) restated in counting form;
  - breaks from m + 1;
  - the record law, read as Markov independence given the weighting, with the weighting as T6's warranted model.

  Its hypotheses: two values, natural weights, rises q and falls p (balanced by construction), independent steps, and records asked of the courses of k steps.
- **typicality-by-counting.** The maximal law, with its caveat: the counts stay near their means at every step, and the frequencies show the weights at the horizon only.

**Should not claim.**
- any free-energy content in the core, or Gibbs' inequality as checked before the periphery has a receipt;
- a third part for UE1, or that the exit bound is the principle's quantity: it is only the unregulated case that quantity is measured against;
- that a level leaves every margin in time, since recurrence is not proved;
- the near-definitional laws as substantive results of the containment;
- the prior and likelihood readings without one likelihood total;
- conditioning for possibility or signed counts;
- "break" for falling to the need at m;
- the level's balance as a law of (b), or Drift as a dependency;
- the surprisal bound where m·m ≤ n·p·q;
- exponential exit bounds;
- `whole_courses` as new without saying that it lands above `Typicality.transfer_weight` until Weighted's owner decides;
- that a share with a zero whole, as such, compares either way (only `⟨0, 0⟩` does).

**Probe text** (scratch, beside unchanged copies of the revised modules):

```lean
theorem positive_part_zero_whole :
    (⟨0, 1⟩ : Share).le ⟨1, 0⟩ ∧ ¬ (⟨1, 0⟩ : Share).le ⟨0, 1⟩ :=
  ⟨Nat.zero_le _, fun h => (by decide : ¬ (1 * 1 ≤ 0 * 0)) h⟩

theorem reciprocal_of_impossible :
    (share (Typicality.courses 1) (Typicality.weight 1 1) (fun _ => false)).reciprocal = ⟨2, 0⟩ :=
  rfl
```
