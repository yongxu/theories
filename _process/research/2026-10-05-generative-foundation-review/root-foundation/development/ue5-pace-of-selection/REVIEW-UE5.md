# UE5 review: the pace of selection bounded by the inflow (25 October 2026)

This is an AI-authored independent review of board item UE5 as committed at `cbf47d521`. It covers two files:

- [NOTE.md](NOTE.md), sha256 `25d8ea6e…21c98e`;
- `tree/Becoming/SelectionPace.lean`, sha256 `893cce81…884487`, the bytes the NOTE's build log names.

They were read with [AGENTS.md](../../../../../../AGENTS.md), rules 8 and 9 of [the work board](../../../../../BECOMING-WORKBOARD.md), [the audit](../ue0-third-parts/AUDIT.md) (summary, row 23, §5.1, §8 candidate 1), [chapter 04](../../../../../../theories/becoming/chapters/04-LIFE.md) (§3 evolution on descent, §4 what bounds offspring numbers), and the package modules `World`, `Flow`, `Dissipation`, `Entropy`, `Evolution`, `SelectionTerm`, `Reproduction`, `SelectionReach` and `DrawnBeyond`.

**How it was checked.**

- **Rebuild.** A copy of the module was built with `scratch_build.py` in a separate scratch tree. It gives 43 theorems in 84 declarations, every axiom report empty, no warning, as the NOTE says. Every step was reused from the shared cache, so the step keys match the NOTE's build.
- **Statements.** Each of the 43 theorems was read against its docstring, the module docstring and the NOTE.
- **Probe.** Variants were built in a second scratch tree: a module importing the kit, 41 theorems in 81 declarations, no warning. Its general laws (R1, R2 and R7 in the appendix) have empty axiom reports. Its witness worlds use overlapping match patterns and so report `propext`, which does not matter in scratch; a landing would use disjoint patterns, as the kit does. Its text is in the [appendix](#appendix-the-probe-module), since the scratch folder is volatile. "Probe" below refers to it.
- **Imports.** The import closure was computed from the sources. `Reproduction` and `Entropy` do not import each other, and `Reproduction` importing `Entropy` would close no cycle.
- **Sources read this round, through a search and fetching tool.**
  - Matheson, Exposito-Alonso and Masel, *Genetics* 229(4), iyaf011 (2025). It restates Haldane's cost and the limit of Nei and Felsenstein with their formulas.
  - The Wikipedia article "Haldane's dilemma".
  - Bibliographic records for Nei (1971), Kimura (1968), Maynard Smith (1968), Van Valen (1963) and Smith and Fretwell (1974).
  - Felsenstein (1971), Ewens (1970), Sved (1968) and Wallace (1975) were not reached. What is said of them below comes from the 2025 paper or from prior knowledge, and is labelled.

## Verdict

The Lean is sound and the statements match their docstrings: the 43 theorems build with empty axiom reports, the premises hold together with a rise (`Displacement.premises`, `Fed.premises`, and probe worlds for `unfed_rise_shrinks` and for two steps), and both witnesses are what they say. The finding that the natural statement fails is right and robust. In `Displacement` even the population's own lineage, without the pool, gains nothing (probe), so the failure is no artefact of the pool or of members moving between lineages. It is a part of a closed whole growing by drawing on the rest: the theory's own law that a rise past the inflow is drawn from beyond (`SelectionReach`, `DrawnBeyond`), which the kit should cite, and whose whole-level form `born_within_inflow` already states when `es` lists the carriers and the rest of the whole. The text says more than the Lean in four places. The NOTE's claim that the audit's candidate holds where offspring number is transmitted exactly is false: probe `Inherited` inherits offspring number in a whole closed, dissipated on and gaining nothing at both steps, with a response of two; what holds is a variant with the next step's inflow. "Haldane's cost in counting form" names a linear bound by a total budget, which the NOTE's own paragraph says differs from Haldane's logarithmic cost; the counting analogue of the reproductive-excess limit of Nei and Felsenstein needs a cap on each parent, and the probe proves it in the pure core. The claim that dissipation would tighten every bound is contradicted by `Displacement` itself. And the module is not a quantitative version of row 23's law, whose premises differ. `carriedInflow` is exact as defined but sums lineage by lineage, so what passes between carrying lineages counts as inflow (probe `Swap`: two against none). The bounds' attainment is the generic equality case of the stock law, not added stringency. The third-part verdict, yes and weak, stands. Malthus is the main neighbour, Smith and Fretwell supply the budget premise rather than their result, density regulation fits, and "Haldane in resource form" does not. On rule 9: land a balanced-on form of Entropy's stock law and derive the global law from it (tested, empty axiom report); keep `born_within_stock` beside `born_within_inflow`, since in the pure core neither placement of the offspring derives the other; move `mean_step_exact` to `SelectionTerm` and `numbered` beside `ByNumber`. **Recommendation: land after fixes.** Counts: 1 error, 3 overclaims, 9 imprecisions, 7 suggestions.

## Findings

Each finding gives its severity, location, what is wrong, and the fix proposed. Suggested wording may be taken as written or in words that say the same.

### Statements and their readings

**1. The audit's candidate does not hold where offspring number is transmitted exactly.** *Error.*
- **Location.**
  - NOTE, third part, the bullet "The audit's candidate as stated" (line 89).
  - NOTE line 63: "This is the audit's Cauchy–Schwarz route."
- **What is wrong.**
  - The audit's candidate (§8, candidate 1) bounds the response across a step by `I`, the inflow of a family across *that* step, under balance and dissipation, with the amount's spread.
  - It fails even where offspring number is transmitted exactly. Probe `Inherited` extends `Displacement` by one step. Each of the carrier's two offspring leaves two, as the carrier did, so offspring number is inherited (`inherited0`). The whole is closed, dissipated on and gains nothing at both steps (`closed0`, `closed1`, `dissipates0`, `dissipates1`, `facts`), and the population's lineage gains nothing at the first step. The response across that step is two (squared, four) and the amount's spread is one. `same_step_fails`: 1 · 4 ≤ 2 · 0 · 1 is false.
  - What `response_sq_within_inflow` proves is a different statement. It bounds the response across step `t` by the inflow across step `t + 1` into the next generation's lineage. With inheritance, the variance of offspring number at `t` becomes growth at `t + 1`, and that growth is what the inflow pays for. In `Inherited` that inflow is two, and the bound holds with equality (`next_step_law`, `next_step_attained`).
  - So `Displacement.displacement` alone refutes the candidate as stated, with or without inheritance. `spread_needs_inheritance` refutes the next-step variant without inheritance.
- **Fix.** Line 89: "The audit's candidate as stated, with the inflow of the same step, is false whether or not offspring number is transmitted exactly (`Displacement.displacement`; with offspring number inherited, probe `Inherited`). What holds is a variant with the inflow of the next step into the next generation's lineage, where offspring number is transmitted exactly (`response_sq_within_inflow`). Without that premise the variant fails too (`spread_needs_inheritance`)." Line 63: "a variant of the audit's Cauchy–Schwarz route, with the next step's inflow." The module docstring (lines 57–71) is exact and needs no change; the record should keep the timing.

**2. "Haldane's cost in counting form."** *Overclaim.*
- **Location.**
  - NOTE line 56: "This is Haldane's cost in counting form."
  - NOTE line 84: "Haldane's cost (1957) in resource form".
  - Module docstring, the Haldane reading (lines 94–102): "the counting form of selective deaths".
  - The board row and the summary of `cbf47d521`. The commit is history; the landing commit, the record and the board row should not repeat the phrase.
- **What is wrong.**
  - *Haldane's cost* is the total of selective deaths over a substitution. In a haploid population of constant size `N` it is `N · D` with `D ≈ −ln p₀` (more with recessiveness). With about a tenth of deaths selective, Haldane put it at about one substitution in 300 generations. *The reproductive-excess form* (Nei 1971; Felsenstein 1971, via the 2025 paper): with each adult leaving `k` offspring before juvenile deaths, substitutions are at least `ln(1/p₀) / ln k` generations apart. Both are logarithmic in the starting frequency, and both rest on a cap per individual (selective deaths per generation, or offspring per parent).
  - *`steps_to_move` is linear and rests on a total cap*, the carried inflow of each step at most `I`. For a 0–1 amount at constant size `N`, fixation needs a carried inflow of at least `m · N (1 − p₀)` in all, which is at most `m · N` whatever `p₀` is (from `stretch_within_carried`). It cannot carry `ln(1/p₀)`. It is the Malthusian bound read on the carrying lineages.
  - *The NOTE contradicts itself.* Its own "Haldane, precisely" (line 88) and the module reading (line 100) say the two costs differ and neither is the other's case.
  - *The model has no selective deaths.* Generations list only offspring that come to stand; nothing is produced and then culled. `unfed_rise_shrinks` concludes only that the next generation is smaller than this one. That is not a count of deaths.
- **Fix.**
  - Line 56: replace the last sentence with "A linear bound: moving a mean needs the standing of the units gained drawn into the carrying lineages; for a 0–1 amount at constant size, at most `m · N` in all, whatever the starting share."
  - Lines 99–100: delete "the counting form of selective deaths".
  - Line 84: "the Malthusian bound read on the carrying lineages. The logarithmic, reproductive-excess form of Haldane's limit (Nei 1971; Felsenstein 1971) answers to a cap on each parent's lineage inflow, not on the total (suggestion 18)."
  - Keep line 88, and state the comparison in the record as it does.

**3. "Losses would tighten every bound."** *Overclaim.*
- **Location.** NOTE line 100; module docstring lines 127–128.
- **What is wrong.**
  - *Dissipation on the lineage's own family leaves it no inflow.* `Flow.DissipatesOn.gainlessOn` with `Flow.gainlessOn_iff_inflow` gives zero inflow (probe `DissipatesOn.inflow_zero'`). Every bound then collapses to the closed case of `Reproduction`: no inflow, and the stock falling by the takers. Inflow and loss cannot both be read on one family.
  - *Dissipation on a wider family need not tighten anything.* `Displacement` is dissipated on its whole family and attains the response and selection laws with equality (`Displacement.displacement`). The unit it loses is drawn from the pool, outside the carrying lineage.
  - What can be added is the lineage's loss `Flow.lost`. Keeping it costs nothing (suggestion 14), but it is zero wherever the lineage's stock does not fall, which includes the case of interest, a lineage that grows.
- **Fix.** "Dissipation is not used. Dissipation on the lineage's own family would leave it no inflow (the closed case, `Reproduction.Flow.born_within_stock`). Dissipation on a wider family does not tighten these bounds: `Displacement` is dissipated on its whole family and attains them."

**4. Not a quantitative version of row 23's law.** *Overclaim.*
- **Location.** NOTE line 81: "This module gives a per-step, quantitative version with an inflow".
- **What is wrong.**
  - Row 23 rests on `Reproduction.Flow.closed_lineage_lowered`: a family closed and dissipated on, over a stretch, with no premise on standings.
  - `number_spread_within_inflow` and `number_unfed_uniform` need parents standing at no more than `m` and a population not shrinking. They need neither closure nor dissipation.
  - Neither implies the other. A closed, dissipated family whose parents stand above `m` is row 23's case and not the kit's. A fed family is the kit's case and not row 23's.
- **Fix.** "a per-step, quantitative companion under other premises: no standing above `m` and no shrinking, instead of closure and dissipation."

**5. What `carriedInflow` counts.** *Imprecision.*
- **Location.**
  - NOTE line 23 ("the pace is bounded by what flows into the lineages carrying the amount") and line 48 ("Each unit gained costs m units of carried inflow").
  - Module docstring lines 32–34, 55–56, 72–73 and 87–89; the docstring of `Displacement.displacement` (line 759).
- **What is wrong.**
  - *The definition is exact* (lines 245–248): the inflow into each parent's lineage, counted as often as the parent's amount. It is a sum lineage by lineage. Each lineage's inflow nets each formation's giving against its taking on that lineage only. So what passes from one carrying lineage to another counts as inflow into the receiver and is not subtracted from the giver.
  - *A witness.* In probe `Swap` two carriers each give their unit to the other's offspring. The carried inflow is two, the inflow into the carriers' joint lineage is none, and nothing is gained (`swap`). The response law holds with slack two.
  - *What follows.* `carriedInflow` is at least the inflow into the carriers' joint lineage, since an excess of sums is at most the sum of the excesses, and for an amount above one it is weighted. The bound is valid. The readings "what flows into the carrying lineages" and "each unit gained costs `m` units drawn into them" overstate what is counted.
  - On the brief's question 3: `carriedInflow` is faithful lineage by lineage. It is not the joint inflow, and the joint form, which is tighter, is available (suggestion 17).
- **Fix.** "What flows into each carrying lineage, summed lineage by lineage and weighted by the amount, so what passes between carrying lineages counts; it is at least the inflow into the carriers' joint lineage." In line 48 write "needs" for "costs".

**6. Attainment is the equality case of the stock law.** *Imprecision.*
- **Location.** NOTE lines 66, 70 and 81 ("with the bounds attained"); module docstring lines 78–84.
- **What is wrong.**
  - *What the law is.* The response law is the stock law of each carrying lineage under two bounds per member (parents at no more than `m`, offspring at `m` or more), summed with the amount as weight. It holds with equality whenever three things hold: the carrying parents stand at exactly `m` and spend it, their offspring stand at exactly `m`, and no formation takes more from a carrying lineage than it gives it. Then the carried inflow is exactly `m` times the units gained.
  - *Its witnesses.* `Displacement` is an instance of that equality for the response law, and `Fed` for the generation law read by offspring number, with `capped` and `sustained` tight. So is probe `Inherited` over two steps (`stretch_attained`: 1 · 4 = 1 · 1 + (1 + 2)). This answers the NOTE's open issue (line 122) for `stretch_within_carried`, though not for `steps_to_move`, whose uniform cap per step is slack there.
  - *What it shows.* Attainment shows the inequalities lose nothing beyond the conservation identity. It does not show stringency of the kind the audit's §7.3 credits. The NOTE's grade (line 77, "carried by a premise") is right, and "attained" should not be read as more. `Displacement.least` and `Fed.least` are the laws instantiated at fixed counts.
- **Fix.** Add to the NOTE and the record: "Each response law is the stock law of the carrying lineages under the per-member bounds. It is an equality where the parents stand at `m` and spend it, the offspring stand at `m`, and no formation takes more from a carrying lineage than it gives; the witnesses are instances."

**7. The failure of the natural statement: state it, and place it.** *Imprecision.*
- **Location.** NOTE line 21; module docstring lines 72–77; `Displacement.displacement`.
- **What is wrong.**
  - *The failure is not stated.* Neither the natural statement nor its failure is written in Lean; `displacement` gives the values from which the failure follows.
  - *The pool invites an objection.* `displacement` states the inflow of the whole family, pool included, which suggests that the pool does the work. It does not. The population's own lineage, members and offspring without the pool, also gains nothing (probe `displacement_population_inflow`, by `rfl`). The response law with that inflow in place of the carried inflow fails (probe `displacement_natural_fails`, by `decide`, empty axiom report).
  - *The phenomenon is the theory's own.* A rise past a family's inflow is drawn from beyond it: `Flow.Balances.rise_le_inflow_beyond` and `Flow.Balances.rise_paid_from_beyond` in `SelectionReach`, and `Flow.Balances.rise_lowers_beyond` in `DrawnBeyond`. These are [chapter 05's](../../../../../../theories/becoming/chapters/05-COLLECTIVES.md#r-a-rise-past-the-inflow-is-drawn-from-beyond) laws, which the audit named as the candidate's template. In `Displacement` the carrier's lineage rises by one while the rest of the whole, pool and other, falls by two.
  - *The whole-level form already holds.* It is `born_within_inflow` with `es` the carriers followed by the rest of the whole: the carriers' offspring, `m` for each, with what the carriers and the rest stand at after the step, are within what they stood at before and the whole's inflow (probe `displacement_whole_level`: 2 + 0 ≤ 3 + 0). With parents at no more than `m`, `m · (s′ − s)` is at most what the rest falls by plus the whole's inflow. This is the natural statement corrected: the pace is bounded by what flows into the whole and what the rest of the whole loses, soft selection in counting form.
- **Fix.**
  - Add `Displacement.natural_fails`, the response law with the population lineage's inflow failing, and add the population lineage's zero inflow to `displacement` or beside it.
  - In the NOTE and the record, cite the drawn-from-beyond laws as what the failure instantiates.
  - State the whole-level corollary of `born_within_inflow`, in one line of the record or as a named corollary.

**8. "Soft selection" is a reading.** *Imprecision.*
- **Location.** NOTE line 21 ("This is soft selection"); module docstring lines 113–116.
- **What is wrong.**
  - The Lean shows a part of a closed whole growing by drawing on the rest. That is the zero-sum feature Wallace's soft selection names: selection decides which members leave offspring, not how many.
  - Hard and soft selection differ in how a population's output responds to its composition. One step of a supplied flow cannot show that; whether the output would be two without the carrier is not modelled.
  - The reading is fair, but it is not a theorem.
- **Fix.** "a zero-sum draw within a closed whole: what one lineage gains, the rest loses (the setting of Wallace's soft selection; a reading)."

**9. `spread_needs_inheritance` states values, not the failure.** *Imprecision.*
- **Location.** Lines 814–830; NOTE line 69.
- **What is wrong.**
  - The theorem gives the spread four, the next inflow zero, balance, `capped`, `sustained` and the failure of inheritance.
  - It omits the premises `arise` and `stands` at the next step. They hold vacuously, since the second generation has no offspring.
  - It does not state that the conclusion fails (1 · 4 ≤ 2 · 0). Nor does it state the failure of the response-squared variant (1 · (2 · 2 − 2 · 1)² ≤ 2 · 0 · 1), which is how the NOTE uses it.
  - The premises are those of `number_spread_within_inflow` read on `numbered generations`, which the docstring leaves implicit.
- **Fix.** Add the two failing inequalities to the conjunction. `by decide` proves both with empty axiom reports (checked in scratch; the text is at the end of the appendix). Say in the docstring that the premises are read on `numbered generations` and that `arise` and `stands` hold vacuously.

**10. Smith and Fretwell supply the budget, not their result.** *Imprecision.*
- **Location.** Module docstring lines 117–118; NOTE line 83.
- **What is wrong.** Smith and Fretwell (1974) take a fixed reproductive investment and derive the offspring size that maximizes the parent's return. The budget, number times size within the investment, is their premise. `parent_within_inflow` is that premise read on standing and inflow, with size fixed at `m`. It says nothing of the optimum.
- **Fix.** "the budget constraint of Smith and Fretwell's model (its premise; its result, the best offspring size, is not read)."

**11. The test.** *Imprecision.*
- **Location.** NOTE line 90.
- **What is wrong.**
  - The ceiling `Var ≤ I/(m·n)` needs exact transmission of offspring number, which no population meets.
  - `I` is the inflow into the next generation's lineage, net of what its members take from it. It is not the inflow into a chemostat's medium.
  - As stated, the test is of the idealization and needs accounting lineage by lineage.
- **Fix.** Say so. Better, design the test on the whole-level form of finding 7, the carriers' rise within what the rest loses and what flows into the whole, whose quantities are measured on the whole population.

**12. What the premises pin.** *Imprecision.*
- **Location.** NOTE "Premise words" (lines 27–32) and "What is not derived" (lines 92–104).
- **What is wrong.**
  - *Members stand at exactly `m`.* Over a stretch, `capped` at step `t` with `stands` at step `t − 1` pins every parent after the first generation at exactly `m`. Members never stand above the least, so every unit of growth beyond replacement must flow in at its own step. This is where the stretch laws' strength and narrowness lie, and the text should say it.
  - *`m` is a supplied level.* The board item asks for a bound set by "what each member needs", but `m` is not the web's `need` (the NOTE says so, line 103). It could be tied to the web. In a web where activity needs support (`Web.Dependent`), an offspring active at `t + 1` that requires its own standing at need `m` or more stands at `m` or more (`Web.Supported`: need at most level). Then `stands` would follow from a dependence instead of being supplied.
- **Fix.** Add both points: the first to "Premise words", the second as an open item or a one-line lemma.

**13. Small text fixes.** *Imprecision.*
- Module docstring lines 80–81: each of `Fed`'s offspring takes one unit from itself and one from the source, and the line omits the first.
- NOTE line 21 and module docstring line 75: "its size staying at two" is the population's size; the family has five relata.
- NOTE line 109: "so no new general lemma sits beside Entropy's `Flow.Balances.stock_inflow`". The inline derivation is that general lemma, unnamed (see [Rule 9](#rule-9)).

## Rule 9

**Placement.** The module is a leaf, as the NOTE says. It imports `Reproduction` and `Entropy`, neither of which imports the other, and nothing imports it. If `Reproduction` imported `Entropy`, no cycle would close; `Entropy`'s closure would add nine modules to `Reproduction`'s (`InAmounts`, `Locality`, `Openness`, `Premises`, `Recurrence`, `Reserve`, `Resolution`, `Roles`, `Space`).

**`born_within_inflow` beside `born_within_stock`.** They are siblings, not a general law and its case.

- *Both rest on the balance identity on a list* (`Flow.BalancesOn.over`), with different inequalities for each formation. `born_within_stock` goes through Dissipation's `BalancesOn.runs_down`: under dissipation the stock falls by the takers. `born_within_inflow` goes through Entropy's stock law: the stock rises by at most the inflow, re-derived inline on a balanced-on list.
- *Neither derives the other in the pure core, because they place the offspring differently.*
  - `born_within_stock` bounds distinct offspring lying anywhere in a family, through `total_le_of_support`.
  - `born_within_inflow` bounds offspring listed after `es` in the very list balanced on, repetition allowed.
  - The support form needs the offspring distinct, which the suffix form does not assume, so it cannot give the suffix form. Without decidable equality on `X`, a family cannot be split into its offspring and the rest, so the suffix form cannot give the support form either.
  - They also differ in the least standing (`m` against one) and in what is subtracted (nothing against the takers).
- *There is a law below both.* Entropy's stock law keeps `lost` (`Flow.Balances.stock_inflow`). Under dissipation the inflow is zero and the takers are at most `lost` (`Flow.DissipatesOn.takers_le_lost`, `Flow.gainlessOn_iff_inflow`), so `runs_down` is its case. But `Dissipation` lies below `Entropy`; making `runs_down` a corollary would move `inflow` and `lost` down. That is a refactor of shared modules, not UE5's to make.

**14. A balanced-on form of Entropy's stock law.** *Suggestion.*
- **What.** In `Entropy`, add `Flow.BalancesOn.stock_gained` and `Flow.BalancesOn.stock_inflow`, and prove the existing `Flow.Balances.stock_gained` and `Flow.Balances.stock_inflow` as `(balances.on cs t).…`. The statements stay unchanged, and their consumers (`DrawnBeyond`, `SelectionReach`) are untouched. The precedent is Dissipation's own `BalancesOn.runs_down` with `Balances.runs_down` derived from it.
- **Tested.** Probe R1 (`BalancesOn.stock_gained'`, `BalancesOn.stock_inflow'`, `Balances.stock_inflow_of_on`) has empty axiom reports; the proof is Entropy's, with `BalancesOn.over` in place of `Balances.over`.
- **Then.** `born_within_inflow` cites it instead of deriving the step inline, and keeps `lost` on the left (probe `born_within_inflow_lost`, empty report). Its case with no inflow on a dissipated list then carries the takers through `takers_le_lost`.
- **Keep `born_within_stock`.** The record says why both stay: the placement of the offspring, in the pure core.
- **Decision.** This is the `Entropy` owner's call. If declined, the record says that the inline step re-derives Entropy's law on a balanced-on list, and why.
- `Flow` itself proves `Balances.over` and `BalancesOn.over` separately. That predates the rule and is noted for the integrator only.

**15. `mean_step_exact` and `numbered` belong below.** *Suggestion.*
- *`mean_step_exact`* (lines 259–267) is the rewrite of `Generations.mean_step` under exact transmission. The same rewrite already appears inline in `SelectionTerm.Generations.balanced_exact_iff`, `raises_exact_iff`, `Reproduction.Generations.response_sq_le` and `Reproduction.Breeding.response`, so the kit adds a fifth copy. Its home is `SelectionTerm`, as `Generations.mean_step_exact`, used by those four. This is the owner's decision; if declined, keep it local and say it is the fifth copy.
- *`numbered`* (lines 526–534) builds the generations that `Reproduction.Generations.ByNumber` describes. It belongs beside that predicate, with `numbered_family` and a lemma `ByNumber (numbered G)`, which the kit now proves inline as `fun _ _ => rfl`.
- *No other duplicates.* `sum_exact` has none. No other `lineage` or `carriedInflow` is defined in the package. "Lineage" names other things in the prose of `Copying`, `Courses`, `Evolution` and `Founding`, so a name for `lineage` chosen when it moves below should avoid confusion with them.
- *Names* are structural, and rule 8 does not apply to a new module. On wording, see suggestion 19.
- *Witness reuse.* `Displacement` is `Reproduction.OnePool`'s flow, a parent taking three units and giving one to each of two offspring, with the pool split into a pool and a competitor, read with `SelectionTerm.Rising`'s counts. The record could say so.

## Additions

**16. Witnesses for `capped` and `sustained`.** *Suggestion.*
- The NOTE's open issue (line 121) has short answers, both tested in the probe.
- *Without `capped` the response law fails* (`Surplus`). A parent standing at two leaves two offspring from its own standing while the other member's standing is lost. Nothing flows into the carrying lineage, the size stays at two, and the share rises from a half to the whole.
- *Without `sustained` it fails too* (`Shrink`). The carrier leaves one offspring from its own standing and the other member none. The share rises from a half to the whole while the size falls from two to one, with no carried inflow. `Shrink` also meets every premise of `unfed_rise_shrinks`, so that theorem is not vacuous.

**17. The share law over the carriers' joint lineage.** *Suggestion.*
- *For a 0–1 amount,* `born_within_inflow` with `es` the list of carriers gives `m · s′ ≤ m · s + inflow (lineage carriers kids)` under `capped` and exact transmission. This nets what passes among carriers and so makes the reading of finding 5 exact.
- *What it needs.* The carriers as a list, each once. `List.filter` with `Nat.decLt` is available in the core, but its membership lemmas must be proved without `propext`.
- *For a general amount,* the same idea in layers: the sum over `j ≥ 1` of the inflow into the joint lineage of the members whose amount is at least `j`.

**18. A cap on each parent: the counting form of the reproductive-excess limit.** *Suggestion.*
- *Tested.* Probe R7 (`fecund_number`, `fecund_step`, `fecund_stretch`, empty axiom reports).
- *The chain.* Suppose each parent stands at no more than `m` and its lineage's inflow is at most `(k − 1) · m`. Then each parent leaves at most `k` offspring. An exactly transmitted total multiplies by at most `k` a step, and by at most `k ^ T` over a stretch.
- *The limit.* At constant size, going from `c` carriers to all `N` needs `N ≤ k ^ T · c`, that is `T ≥ log_k (N/c) = log_k (1/p₀)`. This is the limit of Nei (1971) and Felsenstein (1971) in counts.
- *What it adds.* It is near-definitional once the cap is supplied; the flow's part is turning a cap on resources into a cap on offspring (`parent_within_inflow`). `Displacement` attains it with `k = 2` (probe `displacement_fecund`).
- If the record keeps a Haldane reading, it belongs on this law, not on `steps_to_move`.

**19. Wording.** *Suggestion.*
- Statement prose uses economic words: "holds no surplus", "pays for", "costs", "budget". Prefer "stands at no more than `m`", "is fed by", "draws" and "needs", and keep "cost" inside the Haldane reading.
- The glossary's "carried amount" (02, loops) is another sense. `carriedInflow` is acceptable with its docstring, but "carried" invites the joint reading (finding 5).

**20. Counts.** *Suggestion.*
- *The laws with content.* Of the 43 theorems they are `born_within_inflow`, `offspring_within_carried` (with `total_within_carried` and `response_within_carried`), `number_step_within_inflow` (with `number_spread_within_inflow`) and `response_sq_within_inflow`.
- *The rest.* `sum_exact`, `mean_step_exact` and `selection_within_carried` restate under exact transmission. The stretch laws are an induction and arithmetic. Twenty-two theorems belong to the two witnesses, the two `least` among them.
- A record or README row counting 43 should say which is which.

## The third part and the literature

**What the sources say about the cost of selection.**
- **Haldane (1957).** The cost of a substitution is the total of selective deaths, about `N · D` with `D ≈ −ln p₀` in a haploid population of constant size, more with recessiveness. He took about 30 as typical and about a tenth of deaths as selective, hence about one substitution in 300 generations. Source: the 2025 paper and the Wikipedia article.
- **Van Valen (1963)** named the limit "Haldane's dilemma". Source: the Wikipedia article.
- **Kimura (1968)** used it as a constraint, a load of about 0.1 per generation and a cost of about 30 per substitution, and argued that the observed rate of molecular substitution would be an intolerable load unless most substitutions are neutral. Source: the 2025 paper and a search excerpt of Kimura's text.
- **Maynard Smith (1968)** argued that with truncation selection one selective death counts toward several substitutions, which lifts the limit by orders of magnitude. The 2025 paper notes that his model lets survivors refill the population, assuming ample reproductive excess. Sved (1968), from prior knowledge, made the same point with truncation selection.
- **Ewens (1970)** objected to measuring the cost against an optimal genotype that need not exist; measured against the best genotype present, the limit is much weaker. Source: the 2025 paper.
- **Nei (1971) and Felsenstein (1971)** restated the limit from a finite reproductive excess: substitutions at least `ln(1/p₀) / ln k` generations apart, Nei for populations regulated by density, Felsenstein for low density, where too little excess means extinction. Source: the 2025 paper.
- **Wallace (1968, 1975)**: under soft selection, selection decides which members survive, not how many, and the demographic cost largely disappears. From prior knowledge and secondary summaries.

**The NOTE's comparison.** "Haldane, precisely" (line 88) is fair: the costs differ, Haldane's is logarithmic and paid in deaths, the kit's linear and paid in standing. Line 56's label contradicts it (finding 2).

**The verdict "yes, weak" stands, with three remarks.**
- *It is carried by premises.* Under the per-member bounds the forbidden pace is the stock law of the carrying lineages read in Price's terms, with equality as the generic case (finding 6). The NOTE's grade says so.
- *The carried inflow is not a quantity measured on the whole population.* In a closed population it is itself the draw from the non-carriers, the selective outcome. The whole-level form of finding 7, the carriers' rise within what the rest loses and what flows into the whole, is the statement a test can freeze.
- *The neighbours.*
  - Malthus: yes, the main one.
  - Smith and Fretwell: the budget premise, not the result (finding 10).
  - Density regulation of heritable variance in fitness: yes. This is Fisher's deterioration of the environment; at a stable size the mean absolute fitness is one, and `number_unfed_uniform` is that statement in counts under exact transmission of offspring number.
  - Haldane's cost in resource form: no, as stated (finding 2). The reproductive-excess form needs the cap on each parent of suggestion 18.
  - Wallace's soft selection as the reason the whole's inflow does not bound composition: yes, as a reading (finding 8).
- *Against Fisher.* The variance bound is the Malthusian bound read on Fisher's rate under exact transmission of offspring number, which no population meets. It is a known join, as the NOTE says.

## Recommendation

**Land after fixes.**

- **Required before landing (text).** Findings 1–4, 5 and 6 (readings), 7 (state the failure and cite the drawn-from-beyond laws), 9 and 13, in the NOTE, the module docstring, the record and the board row.
- **Required decision (rule 9).** Suggestion 14 is the `Entropy` owner's call. If it is declined, the record states the reason.
- **Optional.** Suggestions 15–20. Of these, 17 and 18 strengthen the kit most: the joint form makes the reading exact, and the per-parent form is the only counting analogue of Haldane's limit in reach.
- **The Lean.** No theorem statement needs to change. The Lean changes are additions (`natural_fails`, the failing inequalities, and optionally the worlds and laws of suggestions 16–18) and the rule 9 refactor.

## Not reviewed

- The record and the home-section text, not yet written, and the evolution row for 08 §8 that the NOTE proposes.
- Whether the global premise `Flow.Dissipative` holds of `Displacement` and of probe `Inherited` at every step. Only dissipation on the whole family at the steps used was checked.
- The board row beyond its Haldane phrase.

## Appendix: the probe module

`Becoming/SelectionPaceReview.lean`, built in a scratch tree beside a copy of the kit's module with `scratch_build.py` (41 theorems in 81 declarations, no error or warning; sha256 of the file `65176685…fe8c0`). R1, R2 and R7 and `displacement_natural_fails`, `displacement_whole_level` and `displacement_whole_level_values` have empty axiom reports. The witness worlds `Inherited`, `Swap`, `Surplus` and `Shrink` use overlapping match patterns and so report `propext`; for landing they would be rewritten with disjoint patterns, as the kit's witnesses are.

```lean
import Becoming.SelectionPace

/-!
Review probes for UE5 (scratch only, not for landing). Each block tests one claim of the
kit or one proposed fix.
-/

namespace Becoming

namespace Flow

variable {F C : Type} {L : Flow F C} {W : Web F C} {cs : List C} {t : Nat}

/-- R1 (rule 9): Entropy's `Flow.Balances.stock_gained`, on a family balanced on. -/
theorem BalancesOn.stock_gained' (balanced : L.BalancesOn W cs t) :
    W.stock cs (t + 1) + L.lost cs t =
      W.stock cs t + excess (L.replenishment cs t) (L.uptake cs t) :=
  add_right_cancel (L.replenishment cs t) (calc
    W.stock cs (t + 1) + L.lost cs t + L.replenishment cs t
        = W.stock cs (t + 1) + (L.replenishment cs t + L.lost cs t) :=
          (Nat.add_assoc _ _ _).trans (congrArg (W.stock cs (t + 1) + ·) (Nat.add_comm _ _))
    _ = W.stock cs (t + 1) + (L.uptake cs t + excess (L.replenishment cs t) (L.uptake cs t)) :=
          congrArg (W.stock cs (t + 1) + ·) (excess_balance _ _)
    _ = W.stock cs (t + 1) + L.uptake cs t + excess (L.replenishment cs t) (L.uptake cs t) :=
          (Nat.add_assoc _ _ _).symm
    _ = W.stock cs t + L.replenishment cs t + excess (L.replenishment cs t) (L.uptake cs t) :=
          congrArg (· + _) balanced.over
    _ = W.stock cs t + excess (L.replenishment cs t) (L.uptake cs t) + L.replenishment cs t :=
          Nat.add_right_comm _ _ _)

/-- R1: Entropy's `Flow.Balances.stock_inflow`, on a family balanced on. -/
theorem BalancesOn.stock_inflow' (balanced : L.BalancesOn W cs t) :
    W.stock cs (t + 1) + L.lost cs t ≤ W.stock cs t + L.inflow cs t :=
  Nat.le_trans (Nat.le_of_eq balanced.stock_gained')
    (Nat.add_le_add_left (L.gained_le_inflow cs t) _)

/-- R1: the global law as its case. -/
theorem Balances.stock_inflow_of_on (balances : L.Balances W) (cs : List C) (t : Nat) :
    W.stock cs (t + 1) + L.lost cs t ≤ W.stock cs t + L.inflow cs t :=
  (balances.on cs t).stock_inflow'

/-- R2: dissipated on, a family has no inflow, so dissipation on a lineage's own family collapses
every inflow bound to the closed case. -/
theorem DissipatesOn.inflow_zero' (dissipates : L.DissipatesOn cs t) : L.inflow cs t = 0 :=
  gainlessOn_iff_inflow.mp dissipates.gainlessOn

end Flow

namespace SelectionPaceReview

open SelectionTerm SelectionPace

section General

variable {X : Type} {L : Flow X X} {W : Web X X}

/-- R1: `born_within_inflow` from the balanced-on stock law, keeping what the list loses. -/
theorem born_within_inflow_lost {t m : Nat} {es ps : List X} {kids : X → List X}
    (balanced : L.BalancesOn W (es ++ ps.flatMap kids) t)
    (arise : ∀ p k, p ∈ ps → k ∈ kids p → W.ComesToStand t k)
    (stands : ∀ p k, p ∈ ps → k ∈ kids p → m ≤ W.level (t + 1) k) :
    m * born ps kids + total es (W.level (t + 1)) + L.lost (es ++ ps.flatMap kids) t ≤
      total es (W.level t) + L.inflow (es ++ ps.flatMap kids) t :=
  have after : m * born ps kids + total es (W.level (t + 1)) ≤
      W.stock (es ++ ps.flatMap kids) (t + 1) :=
    Nat.le_trans (Nat.le_of_eq (Nat.add_comm _ _))
      (Nat.le_trans (Nat.add_le_add_left (standing_total stands) _)
        (Nat.le_of_eq (total_append (W.level (t + 1)) (ps.flatMap kids) es).symm))
  have before : W.stock (es ++ ps.flatMap kids) t = total es (W.level t) :=
    (total_append (W.level t) (ps.flatMap kids) es).trans
      ((congrArg (total es (W.level t) + ·) (fresh_total arise)).trans (Nat.add_zero _))
  Nat.le_trans (Nat.add_le_add_right after _)
    (Nat.le_trans balanced.stock_inflow'
      (Nat.le_of_eq (congrArg (· + L.inflow (es ++ ps.flatMap kids) t) before)))

/-- R7: a cap on what flows into a parent's lineage caps its offspring number. -/
theorem fecund_number {t m k : Nat} {p : X} {kids : X → List X}
    (balanced : L.BalancesOn W (lineage [p] kids) t)
    (arise : ∀ c, c ∈ kids p → W.ComesToStand t c)
    (stands : ∀ c, c ∈ kids p → m ≤ W.level (t + 1) c)
    (capped : W.level t p ≤ m) (positive : 0 < m)
    (fed : L.inflow (lineage [p] kids) t + m ≤ k * m) :
    (kids p).length ≤ k :=
  le_of_mul_le_mul positive
    (Nat.le_trans (parent_within_inflow balanced arise stands)
      (Nat.le_trans (Nat.add_le_add_right capped _)
        (Nat.le_trans (Nat.le_of_eq (Nat.add_comm _ _))
          (Nat.le_trans fed (Nat.le_of_eq (Nat.mul_comm _ _))))))

/-- R7: so an exactly transmitted amount's total multiplies by at most `k` a step. -/
theorem fecund_step {G : Generations X} {t m k : Nat}
    (balanced : L.BalancesOn W (lineage (G.family t) (G.kids t)) t)
    (arise : ∀ p c, p ∈ G.family t → c ∈ G.kids t p → W.ComesToStand t c)
    (stands : ∀ p c, p ∈ G.family t → c ∈ G.kids t p → m ≤ W.level (t + 1) c)
    (exact : Exact (G.family t) (G.kids t) (G.amount t) (G.amount (t + 1)))
    (capped : ∀ p, p ∈ G.family t → W.level t p ≤ m) (positive : 0 < m)
    (fed : ∀ p, p ∈ G.family t → L.inflow (lineage [p] (G.kids t)) t + m ≤ k * m) :
    G.sum (t + 1) ≤ k * G.sum t :=
  Nat.le_trans (Nat.le_of_eq (sum_exact exact))
    (Nat.le_trans
      (total_le _ fun p mp => Nat.mul_le_mul_right (G.amount t p)
        (fecund_number (fun c mc => balanced c (lineage_sub mp c mc))
          (fun c mc => arise p c mp mc) (fun c mc => stands p c mp mc) (capped p mp) positive
          (fed p mp)))
      (Nat.le_of_eq (total_mul k _ _)))

/-- R7: over a stretch, by at most `k ^ T`: from `c` carriers to `N`, `N ≤ k ^ T · c`, so
`T ≥ log_k (N / c)`, the reproductive-excess limit of Nei (1971) and Felsenstein (1971). -/
theorem fecund_stretch {G : Generations X} {m k : Nat} (positive : 0 < m) :
    ∀ T : Nat,
      (∀ t, t < T → L.BalancesOn W (lineage (G.family t) (G.kids t)) t) →
      (∀ t p c, t < T → p ∈ G.family t → c ∈ G.kids t p → W.ComesToStand t c) →
      (∀ t p c, t < T → p ∈ G.family t → c ∈ G.kids t p → m ≤ W.level (t + 1) c) →
      (∀ t, t < T → Exact (G.family t) (G.kids t) (G.amount t) (G.amount (t + 1))) →
      (∀ t p, t < T → p ∈ G.family t → W.level t p ≤ m) →
      (∀ t p, t < T → p ∈ G.family t → L.inflow (lineage [p] (G.kids t)) t + m ≤ k * m) →
      G.sum T ≤ k ^ T * G.sum 0
  | 0, _, _, _, _, _, _ => Nat.le_of_eq (Nat.one_mul _).symm
  | T + 1, balanced, arise, stands, exact, capped, fed =>
    have before := fecund_stretch positive T
      (fun t lt => balanced t (Nat.lt_succ_of_lt lt))
      (fun t p c lt => arise t p c (Nat.lt_succ_of_lt lt))
      (fun t p c lt => stands t p c (Nat.lt_succ_of_lt lt))
      (fun t lt => exact t (Nat.lt_succ_of_lt lt))
      (fun t p lt => capped t p (Nat.lt_succ_of_lt lt))
      (fun t p lt => fed t p (Nat.lt_succ_of_lt lt))
    have last := fecund_step (t := T) (balanced T (Nat.lt_succ_self T))
      (fun p c => arise T p c (Nat.lt_succ_self T)) (fun p c => stands T p c (Nat.lt_succ_self T))
      (exact T (Nat.lt_succ_self T)) (fun p => capped T p (Nat.lt_succ_self T)) positive
      (fun p => fed T p (Nat.lt_succ_self T))
    Nat.le_trans last (Nat.le_trans (Nat.mul_le_mul_left k before)
      (Nat.le_of_eq ((mul_assoc_nat k (k ^ T) (G.sum 0)).symm.trans
        (congrArg (· * G.sum 0) (Nat.mul_comm k (k ^ T))))))

end General

/-! ## T1. Displacement: the population's own lineage has no inflow; the natural statement fails -/

theorem displacement_population_inflow :
    Displacement.flow.inflow
      (lineage (Displacement.generations.family 0) (Displacement.generations.kids 0)) 0 = 0 :=
  rfl

theorem displacement_natural_fails :
    ¬ (1 * (Displacement.generations.size 0 * Displacement.generations.sum 1) ≤
        1 * (Displacement.generations.size 1 * Displacement.generations.sum 0) +
          Displacement.generations.size 0 * Displacement.flow.inflow
            (lineage (Displacement.generations.family 0) (Displacement.generations.kids 0)) 0) := by
  decide

/-- The whole-level form already in the kit: `born_within_inflow` with `es` the carriers and the
rest of the whole. The carrier's offspring (two, at one each) are within the carrier's standing,
what the rest falls by (pool and other, two to none) and the whole's inflow (none). -/
theorem displacement_whole_level :
    1 * born [Displacement.Relatum.carrier] (Displacement.kids 0) +
        total [Displacement.Relatum.carrier, Displacement.Relatum.pool, Displacement.Relatum.other]
          (Displacement.web.level (0 + 1)) ≤
      total [Displacement.Relatum.carrier, Displacement.Relatum.pool, Displacement.Relatum.other]
          (Displacement.web.level 0) +
        Displacement.flow.inflow
          ([Displacement.Relatum.carrier, Displacement.Relatum.pool, Displacement.Relatum.other] ++
            [Displacement.Relatum.carrier].flatMap (Displacement.kids 0)) 0 :=
  born_within_inflow (Displacement.balances.on _ 0)
    (fun p k mp mk => match p, mp, mk with
      | _, .head _, mk => Displacement.arise _ k (.head _) mk
      | _, .tail _ no, _ => nomatch no)
    (fun p k mp mk => match p, mp, mk with
      | _, .head _, mk => Displacement.stands _ k (.head _) mk
      | _, .tail _ no, _ => nomatch no)

theorem displacement_whole_level_values :
    born [Displacement.Relatum.carrier] (Displacement.kids 0) = 2 ∧
    total [Displacement.Relatum.pool, Displacement.Relatum.other] (Displacement.web.level 0) = 2 ∧
    total [Displacement.Relatum.pool, Displacement.Relatum.other] (Displacement.web.level 1) = 0 ∧
    Displacement.flow.inflow
      ([Displacement.Relatum.carrier, Displacement.Relatum.pool, Displacement.Relatum.other] ++
        [Displacement.Relatum.carrier].flatMap (Displacement.kids 0)) 0 = 0 :=
  ⟨rfl, rfl, rfl, rfl⟩

/-- The fecundity law attained by Displacement with `k = 2`. -/
theorem displacement_fecund :
    Displacement.generations.sum 1 = 2 ^ 1 * Displacement.generations.sum 0 := rfl

/-! ## T2. The audit's same-step candidate fails even with offspring number inherited -/

namespace Inherited

inductive Relatum where
  | pool | carrier | other | left | right | ll | lr | rl | rr

open Relatum

def levelAt : Nat → Relatum → Nat
  | 0, pool => 5
  | 0, carrier => 1
  | 0, other => 1
  | 0, _ => 0
  | 1, pool => 4
  | 1, left => 1
  | 1, right => 1
  | 1, _ => 0
  | _ + 2, ll => 1
  | _ + 2, lr => 1
  | _ + 2, rl => 1
  | _ + 2, rr => 1
  | _ + 2, _ => 0

def web : Web Relatum Relatum where
  level := levelAt
  active _ _ := True
  requires _ _ _ := False
  need _ _ _ := 0
  draws _ _ _ := False

def take : Nat → Relatum → Relatum → Nat
  | 0, carrier, pool => 1
  | 0, carrier, carrier => 1
  | 0, carrier, other => 1
  | 1, left, left => 1
  | 1, left, pool => 2
  | 1, right, right => 1
  | 1, right, pool => 2
  | _, _, _ => 0

def give : Nat → Relatum → Relatum → Nat
  | 0, carrier, left => 1
  | 0, carrier, right => 1
  | 1, left, ll => 1
  | 1, left, lr => 1
  | 1, right, rl => 1
  | 1, right, rr => 1
  | _, _, _ => 0

def present : Nat → List Relatum
  | 0 => [carrier]
  | 1 => [left, right]
  | _ + 2 => []

def flow : Flow Relatum Relatum where
  present := present
  take := take
  give := give

def family : List Relatum := [pool, carrier, other, left, right, ll, lr, rl, rr]

theorem every : ∀ c, c ∈ family
  | pool => .head _
  | carrier => .tail _ (.head _)
  | other => .tail _ (.tail _ (.head _))
  | left => .tail _ (.tail _ (.tail _ (.head _)))
  | right => .tail _ (.tail _ (.tail _ (.tail _ (.head _))))
  | ll => .tail _ (.tail _ (.tail _ (.tail _ (.tail _ (.head _)))))
  | lr => .tail _ (.tail _ (.tail _ (.tail _ (.tail _ (.tail _ (.head _))))))
  | rl => .tail _ (.tail _ (.tail _ (.tail _ (.tail _ (.tail _ (.tail _ (.head _)))))))
  | rr => .tail _ (.tail _ (.tail _ (.tail _ (.tail _ (.tail _ (.tail _ (.tail _ (.head _))))))))

theorem balances : flow.Balances web := by
  intro t c
  match t with
  | 0 => cases c <;> rfl
  | 1 => cases c <;> rfl
  | _ + 2 => cases c <;> rfl

theorem closed0 : flow.ClosedAt family 0 := fun _ _ c outside => absurd (every c) outside

theorem closed1 : flow.ClosedAt family 1 := fun _ _ c outside => absurd (every c) outside

theorem dissipates0 : flow.DissipatesOn family 0
  | _, .head _ => Nat.le_refl 3
  | _, .tail _ mem => nomatch mem

theorem dissipates1 : flow.DissipatesOn family 1
  | _, .head _ => Nat.le_refl 3
  | _, .tail _ (.head _) => Nat.le_refl 3
  | _, .tail _ (.tail _ mem) => nomatch mem

def kids : Nat → Relatum → List Relatum
  | 0, carrier => [left, right]
  | 1, left => [ll, lr]
  | 1, right => [rl, rr]
  | _, _ => []

def marks : Relatum → Nat
  | pool => 0
  | other => 0
  | _ => 1

def generations : Generations Relatum where
  first := [carrier, other]
  kids := kids
  amount _ := marks

theorem exact0 : Exact (generations.family 0) (generations.kids 0) (generations.amount 0)
    (generations.amount (0 + 1))
  | _, .head _, _, .head _ => rfl
  | _, .head _, _, .tail _ (.head _) => rfl
  | _, .head _, _, .tail _ (.tail _ mem) => nomatch mem
  | _, .tail _ (.head _), _, mem => nomatch mem
  | _, .tail _ (.tail _ mem), _, _ => nomatch mem

theorem inherited0 : ∀ p, p ∈ generations.family 0 → ∀ k, k ∈ generations.kids 0 p →
    generations.offspringNumber (0 + 1) k = generations.offspringNumber 0 p
  | _, .head _, _, .head _ => rfl
  | _, .head _, _, .tail _ (.head _) => rfl
  | _, .head _, _, .tail _ (.tail _ mem) => nomatch mem
  | _, .tail _ (.head _), _, mem => nomatch mem
  | _, .tail _ (.tail _ mem), _, _ => nomatch mem

theorem arise1 : ∀ p k, p ∈ generations.family (0 + 1) → k ∈ generations.kids (0 + 1) p →
    web.ComesToStand (0 + 1) k
  | _, _, .head _, .head _ => ⟨Nat.lt_irrefl 0, Nat.succ_pos 0⟩
  | _, _, .head _, .tail _ (.head _) => ⟨Nat.lt_irrefl 0, Nat.succ_pos 0⟩
  | _, _, .head _, .tail _ (.tail _ mem) => nomatch mem
  | _, _, .tail _ (.head _), .head _ => ⟨Nat.lt_irrefl 0, Nat.succ_pos 0⟩
  | _, _, .tail _ (.head _), .tail _ (.head _) => ⟨Nat.lt_irrefl 0, Nat.succ_pos 0⟩
  | _, _, .tail _ (.head _), .tail _ (.tail _ mem) => nomatch mem
  | _, _, .tail _ (.tail _ mem), _ => nomatch mem

theorem stands1 : ∀ p k, p ∈ generations.family (0 + 1) → k ∈ generations.kids (0 + 1) p →
    1 ≤ web.level (0 + 1 + 1) k
  | _, _, .head _, .head _ => Nat.le_refl 1
  | _, _, .head _, .tail _ (.head _) => Nat.le_refl 1
  | _, _, .head _, .tail _ (.tail _ mem) => nomatch mem
  | _, _, .tail _ (.head _), .head _ => Nat.le_refl 1
  | _, _, .tail _ (.head _), .tail _ (.head _) => Nat.le_refl 1
  | _, _, .tail _ (.head _), .tail _ (.tail _ mem) => nomatch mem
  | _, _, .tail _ (.tail _ mem), _ => nomatch mem

theorem capped1 : ∀ p, p ∈ generations.family (0 + 1) → web.level (0 + 1) p ≤ 1
  | _, .head _ => Nat.le_refl 1
  | _, .tail _ (.head _) => Nat.le_refl 1
  | _, .tail _ (.tail _ mem) => nomatch mem

/-- The whole is closed, dissipated on and gains nothing at both steps; the population's own
lineage gains nothing at the first step; the next lineage gains two at the second. -/
theorem facts :
    flow.inflow family 0 = 0 ∧ flow.inflow family 1 = 0 ∧
    flow.inflow (lineage (generations.family 0) (generations.kids 0)) 0 = 0 ∧
    flow.inflow (lineage (generations.family 1) (generations.kids 1)) 1 = 2 ∧
    generations.size 0 = 2 ∧ generations.size 1 = 2 ∧ generations.size 2 = 4 ∧
    generations.sum 0 = 1 ∧ generations.sum 1 = 2 ∧
    concord (generations.family 0) (generations.amount 0) (generations.amount 0) = 1 ∧
    concord (generations.family 0) (generations.offspringNumber 0)
      (generations.offspringNumber 0) = 4 :=
  ⟨rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl⟩

/-- The kit's law (inflow at the next step) holds, and here with equality. -/
theorem next_step_law :
    1 * ((generations.size 0 * generations.sum (0 + 1) - generations.size (0 + 1) * generations.sum 0) *
        (generations.size 0 * generations.sum (0 + 1) - generations.size (0 + 1) * generations.sum 0)) ≤
      generations.size 0 * flow.inflow (lineage (generations.family (0 + 1)) (generations.kids (0 + 1))) (0 + 1) *
        concord (generations.family 0) (generations.amount 0) (generations.amount 0) :=
  (response_sq_within_inflow (L := flow) (W := web) (G := generations) (t := 0) (m := 1)
    exact0 inherited0 (balances.on _ _) arise1 stands1 capped1 (Nat.le_refl 2)).1

theorem next_step_attained :
    1 * ((generations.size 0 * generations.sum 1 - generations.size 1 * generations.sum 0) *
        (generations.size 0 * generations.sum 1 - generations.size 1 * generations.sum 0)) =
      generations.size 0 * flow.inflow (lineage (generations.family 1) (generations.kids 1)) 1 *
        concord (generations.family 0) (generations.amount 0) (generations.amount 0) :=
  rfl

/-- Over the two steps the stretch law holds with equality: `1 · 4 = 1 · 1 + (1 + 2)`. -/
theorem stretch_attained :
    carriedInflow flow generations 0 = 1 ∧ carriedInflow flow generations 1 = 2 ∧
    generations.sum 2 = 4 ∧
    1 * generations.sum 2 = 1 * generations.sum 0 + total (steps 0 2) (carriedInflow flow generations) :=
  ⟨rfl, rfl, rfl, rfl⟩

/-- The audit's candidate with the inflow of the same step fails, offspring number inherited. -/
theorem same_step_fails :
    ¬ (1 * ((generations.size 0 * generations.sum 1 - generations.size 1 * generations.sum 0) *
          (generations.size 0 * generations.sum 1 - generations.size 1 * generations.sum 0)) ≤
        generations.size 0 * flow.inflow (lineage (generations.family 0) (generations.kids 0)) 0 *
          concord (generations.family 0) (generations.amount 0) (generations.amount 0)) := by
  decide

end Inherited

/-! ## T3. Swap: `carriedInflow` counts what passes between carrying lineages -/

namespace Swap

inductive Relatum where
  | a | b | ka | kb

open Relatum

def level : Nat → Relatum → Nat
  | 0, a => 1
  | 0, b => 1
  | 0, _ => 0
  | _ + 1, ka => 1
  | _ + 1, kb => 1
  | _ + 1, _ => 0

def web : Web Relatum Relatum where
  level := level
  active _ _ := True
  requires _ _ _ := False
  need _ _ _ := 0
  draws _ _ _ := False

def take : Nat → Relatum → Relatum → Nat
  | 0, a, a => 1
  | 0, b, b => 1
  | _, _, _ => 0

def give : Nat → Relatum → Relatum → Nat
  | 0, a, kb => 1
  | 0, b, ka => 1
  | _, _, _ => 0

def present : Nat → List Relatum
  | 0 => [a, b]
  | _ + 1 => []

def flow : Flow Relatum Relatum where
  present := present
  take := take
  give := give

theorem balances : flow.Balances web := by
  intro t c
  match t with
  | 0 => cases c <;> rfl
  | _ + 1 => cases c <;> rfl

def kids : Nat → Relatum → List Relatum
  | 0, a => [ka]
  | 0, b => [kb]
  | _, _ => []

/-- Both members carry the amount. -/
def generations : Generations Relatum where
  first := [a, b]
  kids := kids
  amount _ _ := 1

/-- Each carrier gives its unit to the other's offspring: the carried inflow is two, what flows
into the carriers' joint lineage nothing, and nothing is gained. -/
theorem swap :
    carriedInflow flow generations 0 = 2 ∧
    flow.inflow (lineage (generations.family 0) (generations.kids 0)) 0 = 0 ∧
    generations.size 0 = 2 ∧ generations.size 1 = 2 ∧
    generations.sum 0 = 2 ∧ generations.sum 1 = 2 :=
  ⟨rfl, rfl, rfl, rfl, rfl, rfl⟩

end Swap

/-! ## T4. Surplus: without `capped` the response law fails -/

namespace Surplus

inductive Relatum where
  | carrier | other | left | right

open Relatum

def level : Nat → Relatum → Nat
  | 0, carrier => 2
  | 0, other => 1
  | 0, _ => 0
  | _ + 1, left => 1
  | _ + 1, right => 1
  | _ + 1, _ => 0

def web : Web Relatum Relatum where
  level := level
  active _ _ := True
  requires _ _ _ := False
  need _ _ _ := 0
  draws _ _ _ := False

def take : Nat → Relatum → Relatum → Nat
  | 0, carrier, carrier => 2
  | 0, other, other => 1
  | _, _, _ => 0

def give : Nat → Relatum → Relatum → Nat
  | 0, carrier, left => 1
  | 0, carrier, right => 1
  | _, _, _ => 0

def present : Nat → List Relatum
  | 0 => [carrier, other]
  | _ + 1 => []

def flow : Flow Relatum Relatum where
  present := present
  take := take
  give := give

theorem balances : flow.Balances web := by
  intro t c
  match t with
  | 0 => cases c <;> rfl
  | _ + 1 => cases c <;> rfl

def kids : Nat → Relatum → List Relatum
  | 0, carrier => [left, right]
  | _, _ => []

def marks : Relatum → Nat
  | other => 0
  | _ => 1

def generations : Generations Relatum where
  first := [carrier, other]
  kids := kids
  amount _ := marks

theorem arise : ∀ p k, p ∈ generations.family 0 → k ∈ generations.kids 0 p →
    web.ComesToStand 0 k
  | _, _, .head _, .head _ => ⟨Nat.lt_irrefl 0, Nat.succ_pos 0⟩
  | _, _, .head _, .tail _ (.head _) => ⟨Nat.lt_irrefl 0, Nat.succ_pos 0⟩
  | _, _, .head _, .tail _ (.tail _ mem) => nomatch mem
  | _, _, .tail _ (.head _), mem => nomatch mem
  | _, _, .tail _ (.tail _ mem), _ => nomatch mem

theorem exact : Exact (generations.family 0) (generations.kids 0) (generations.amount 0)
    (generations.amount (0 + 1))
  | _, .head _, _, .head _ => rfl
  | _, .head _, _, .tail _ (.head _) => rfl
  | _, .head _, _, .tail _ (.tail _ mem) => nomatch mem
  | _, .tail _ (.head _), _, mem => nomatch mem
  | _, .tail _ (.tail _ mem), _, _ => nomatch mem

/-- A parent standing at two leaves two offspring from its own standing: nothing flows into
the carrying lineage, the size stays at two, the share rises from a half to the whole, and the
response law fails; only `capped` is missing. -/
theorem surplus :
    carriedInflow flow generations 0 = 0 ∧ ¬ web.level 0 carrier ≤ 1 ∧
    generations.size 0 ≤ generations.size 1 ∧
    ¬ (1 * (generations.size 0 * generations.sum 1) ≤
        1 * (generations.size 1 * generations.sum 0) +
          generations.size 0 * carriedInflow flow generations 0) :=
  ⟨rfl, by decide, Nat.le_refl 2, by decide⟩

end Surplus

/-! ## T5. Shrink: without `sustained` the response law fails, and `unfed_rise_shrinks` is not
vacuous -/

namespace Shrink

inductive Relatum where
  | carrier | other | kid

open Relatum

def level : Nat → Relatum → Nat
  | 0, carrier => 1
  | 0, other => 1
  | 0, kid => 0
  | _ + 1, carrier => 0
  | _ + 1, other => 1
  | _ + 1, kid => 1

def web : Web Relatum Relatum where
  level := level
  active _ _ := True
  requires _ _ _ := False
  need _ _ _ := 0
  draws _ _ _ := False

def take : Nat → Relatum → Relatum → Nat
  | 0, carrier, carrier => 1
  | _, _, _ => 0

def give : Nat → Relatum → Relatum → Nat
  | 0, carrier, kid => 1
  | _, _, _ => 0

def present : Nat → List Relatum
  | 0 => [carrier]
  | _ + 1 => []

def flow : Flow Relatum Relatum where
  present := present
  take := take
  give := give

theorem balances : flow.Balances web := by
  intro t c
  match t with
  | 0 => cases c <;> rfl
  | _ + 1 => cases c <;> rfl

def kids : Nat → Relatum → List Relatum
  | 0, carrier => [kid]
  | _, _ => []

def marks : Relatum → Nat
  | other => 0
  | _ => 1

def generations : Generations Relatum where
  first := [carrier, other]
  kids := kids
  amount _ := marks

theorem arise : ∀ p k, p ∈ generations.family 0 → k ∈ generations.kids 0 p →
    web.ComesToStand 0 k
  | _, _, .head _, .head _ => ⟨Nat.lt_irrefl 0, Nat.succ_pos 0⟩
  | _, _, .head _, .tail _ mem => nomatch mem
  | _, _, .tail _ (.head _), mem => nomatch mem
  | _, _, .tail _ (.tail _ mem), _ => nomatch mem

theorem stands : ∀ p k, p ∈ generations.family 0 → k ∈ generations.kids 0 p →
    1 ≤ web.level (0 + 1) k
  | _, _, .head _, .head _ => Nat.le_refl 1
  | _, _, .head _, .tail _ mem => nomatch mem
  | _, _, .tail _ (.head _), mem => nomatch mem
  | _, _, .tail _ (.tail _ mem), _ => nomatch mem

theorem exact : Exact (generations.family 0) (generations.kids 0) (generations.amount 0)
    (generations.amount (0 + 1))
  | _, .head _, _, .head _ => rfl
  | _, .head _, _, .tail _ mem => nomatch mem
  | _, .tail _ (.head _), _, mem => nomatch mem
  | _, .tail _ (.tail _ mem), _, _ => nomatch mem

theorem capped : ∀ p, p ∈ generations.family 0 → web.level 0 p ≤ 1
  | _, .head _ => Nat.le_refl 1
  | _, .tail _ (.head _) => Nat.le_refl 1
  | _, .tail _ (.tail _ mem) => nomatch mem

/-- The carrier leaves one offspring from its own standing, the other none: nothing flows into the
carrying lineage, the share rises from a half to the whole, the size falls from two to one, the
response law fails, and `unfed_rise_shrinks` applies. -/
theorem shrink :
    carriedInflow flow generations 0 = 0 ∧ generations.size 1 < generations.size 0 ∧
    ¬ (1 * (generations.size 0 * generations.sum 1) ≤
        1 * (generations.size 1 * generations.sum 0) +
          generations.size 0 * carriedInflow flow generations 0) :=
  ⟨rfl,
   unfed_rise_shrinks (L := flow) (W := web) (G := generations) (t := 0) (m := 1)
     (balances.on _ 0) arise stands exact capped (Nat.succ_pos 0) rfl (by decide),
   by decide⟩

end Shrink

end SelectionPaceReview

end Becoming
```

**A second scratch check** (finding 9): `Becoming/SelectionPaceDiag.lean`, 2 theorems, both axiom reports empty.

```lean
import Becoming.SelectionPace

namespace Becoming
namespace SelectionPaceDiag

open SelectionTerm SelectionPace

theorem spread_bound_fails :
    ¬ (1 * concord (Displacement.generations.family 0) (Displacement.generations.offspringNumber 0)
          (Displacement.generations.offspringNumber 0) ≤
        Displacement.generations.size 0 *
          Displacement.flow.inflow
            (lineage (Displacement.generations.family 1) (Displacement.generations.kids 1)) 1) := by
  decide

theorem response_sq_fails :
    ¬ (1 * ((Displacement.generations.size 0 * Displacement.generations.sum 1 -
            Displacement.generations.size 1 * Displacement.generations.sum 0) *
          (Displacement.generations.size 0 * Displacement.generations.sum 1 -
            Displacement.generations.size 1 * Displacement.generations.sum 0)) ≤
        Displacement.generations.size 0 *
          Displacement.flow.inflow
            (lineage (Displacement.generations.family 1) (Displacement.generations.kids 1)) 1 *
          concord (Displacement.generations.family 0) (Displacement.generations.amount 0)
            (Displacement.generations.amount 0)) := by
  decide

end SelectionPaceDiag
end Becoming
```
