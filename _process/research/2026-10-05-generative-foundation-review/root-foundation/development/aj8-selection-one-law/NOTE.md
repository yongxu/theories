# AJ8: the alignment conditions as cases of 04's selection laws

AI-written study note (one session, 3 November 2026), board item AJ8. Reading time: about 15 minutes; §1 is the ten-minute part.

**Why this note.** Board item AJ asks that selection in evolution, in training an AI and in institutions read as one law. Two of AJ's conditions on capture were proved on their own carriers and only compared with 04's laws of life: the capacity to shape a rule selected by what comes back to the shapers (MA3, `Becoming.RuleShaping`), and the stag hunt of shapers and readers drawn from the selected (MA4, `Becoming.DrawnShaping`). An integration scan of 3 November 2026 (items 2.1 and 2.2 of its [gap map](../ig-integration-gaps/GAP-MAP.md)) found that each, so separated, told readers more than it proves: "p never changes that direction" holds only where the shared part comes to every member alike, and a lock "for good" holds only without noise, though 04 §6 already proves drift and fixation. Both claims were checked against the Lean before anything was written. Here each condition is stated as a case of 04's law, the general law is proved below the special one (board rule 9), and the texts are narrowed where the claims travel.

## 1. What changed for a reader

1. **Condition 1 is Hamilton's rule with what comes back alone added.** Let each unit a member keeps cost it `K`, bring `s` back to it alone, and give `q` to every member of its group, its own included. Then, in groups of `m`, the whole selects for keeping exactly where `K` times the whole's spread falls short of `s` times it plus `m q` times the spread among groups (`SelectionLevels.rises_iff_kept`). Read over the rationals with the assortment `ρ`, that is `K < s + m q ρ`. Returns to groupmates (04 §5) are its case `s = 0`, `K = b + c`, `q = b`, and are now derived from it. The rule after shaping in groups, with the shared part what a group's shapers give, is a case (`RuleShaping.grouped_rises_iff`).
   - At zero assortment the condition is `c < s`, MA3's verdict (`grouped_alike_iff`).
   - Where `c < s`, no grouping undoes it (`grouped_kept_rises`).
   - With the shapers together it is `c < s + m q` (`grouped_uniform_iff`).
   - A witness, `a = s = q = 1` with a cost of two (`c > s`), has shaping selected with the shapers together and selected against with them apart (`RuleShaping.Assorting.either_verdict`).

   So "whatever `p`" and "`p` never changes that direction" are true where the shared part reaches every member alike. They are false where it goes to those near the shapers.
2. **Condition 2's lock holds without noise only, and how noise leaves it is bounded.** 04 §6's Moran chain is restated with weights read from the count (`Drift.Replacement.valueBy`), and every bound is proved there; the constant chain is now a case. DrawnShaping's stag hunt, drawn one member at a time, is a case of that chain (`DrawnReplacement`).
   - From every mixed count, either lock is left by drift with positive weight: losing every shaper at least `down ^ i` (`lost_ge`), fixing them at least `a ^ k` (`fixed_ge`).
   - A bound on the weight of leaving falls across the distance from the critical mass: `t` times the product of `down / up` over the counts crossed, where the rule read favours (`lost_above`, `fixed_below`). The weight itself is not shown monotone.
   - Which state one member arising fixes with more weight is, in the limit, the product of the shapers' weights over the mixed counts against `down ^ M` (`one_each` with `fixation`). That depends on the base `a` and on the part `p` that comes to every member alike, which move nothing without noise.
   - At an even population the rule read strictly favours the shapers exactly where `2c < hi + lo` (`risk_dominant_iff`), risk dominance in counts. With five members, `a = 1`, `c = 9`, `hi = 20` and `lo = 0`, the shapers are risk dominant, yet one shaper fixes with less weight than one other: 6,215,625 against 6,250,000 (`Strong.other_first`). With `a = 100`, or with `p = 99` to every member, the order turns (`Weak.shapers_first`, `Weak.shared_decides`).

   So the texts' "under rare mutation the long-run state is the risk-dominant one" does not hold in general. Risk dominance is what Kandori, Mailath and Rob and Young select in their limit, and the Moran criterion approaches it under weak selection; in a small population under strong selection the two can part. "An exit would need a change of `hi`, `lo` or `c`" is false with drawing.
3. **T7 gets its noise case.** A drop by drift alone is a drop with nothing read changed. T7's refuter therefore needs a population and a distance from the mass at which drift alone would rarely leave the lock. Its new forbidden case is such a lock left by its selectors, with nothing read changed, more often than that bound allows.
4. **The §9 models sorted.**
   - *Left by noise (proved):* DrawnShaping and its critical mass. RuleShaping at a step is the case `hi = lo = s`.
   - *By substitution:* ReadInTime's rule after the loss is read is the case `lo′` for `lo`, read at every step without the rule in force's lag; the joined course drawn is not stated.
   - *Left by noise (a reading, not stated as instances):* RuleCapture's favouring rule, and any rule that leaves the disfavoured kind a positive weight at every mixed count. Each reads as the chain with its counts as weights, by `Drift.Replacement.lost_geBy`, losing the favoured kind with weight at least `c ^ i`, `c` the least weight of the disfavoured kind at a mixed count.
   - *Not left:* a rule that leaves the disfavoured kind nothing, because the bound is then zero and no history goes down. Also counts that accumulate instead of being drawn (`ChoiceCountCapture`): read with noisy choices they are an urn with increasing returns, whose lock-in with probability one under strong enough returns is cited (Arthur, Ermoliev and Kaniovski 1987; Arthur 1989), not stated.

## 2. Condition 1 in detail

**The general law** (`SelectionLevels`, three theorems, derived returns). In counts with nothing subtracted, each member's offspring with `K` per unit of its own amount is a base `B` plus `s` per unit of its own amount plus `q` per unit its group holds: `w + K a = B + s a + q · (group's total of a)`. Write the three parts in Price's form, each concordance balanced against a discordance with nothing subtracted.
- Within each group, `concordWithin w a + K · concordWithin a a = discordWithin w a + s · concordWithin a a` (`within_kept`). What is shared within a group comes to its members alike and selects nothing within it.
- Among groups read by their totals, the same identity holds with `s + m q` for `s` (`among_kept`).
- In the whole, keeping rises exactly where `K · spread < s · spread + m q · spreadAmong` (`rises_iff_kept`).

`within_returns`, `among_returns` and `rises_iff_returns` now follow from these with `s := 0`. Their direct proofs are gone.

**The join** (`RuleShaping`, section `Groups`). `Grouped gs w shapes a s q c pos` says that each member either shapes (one) and leaves the shapers' count of `shaped a s (q · group's shapers) c`, or does not (none) and leaves the others' count. `grouped_returns` shows that this is the kept form with `B = a + c`, `K = c`, `s` and `q`. The cost is counted, as in MA3, as extra offspring to the others; read as offspring the shapers leave less, the base moves and the identity is the same with `K = c` on the other side. The four group theorems follow:
- `grouped_rises_iff`: exact, at every assortment.
- `grouped_alike_iff`: groups alike in how many shape and shaping varying give `c < s`.
- `grouped_kept_rises`: `c < s` is sufficient at every grouping.
- `grouped_uniform_iff`: uniform groups that differ give `c < s + m q`.

The witness reuses `SelectionLevels.Founding`'s two groups of two (`keeps`, `assorted`, `mixed`): one coming back alone, two the cost, one to each member of a group for each shaper in it. With the shapers together, each shaper leaves `1 + 1 + 2 = 4` and each other `1 + 2 + 0 = 3`. With the shapers apart, each shaper leaves `1 + 1 + 1 = 3` and each other `1 + 2 + 1 = 4`. The whole rises in the first case and falls in the second (`either_verdict`, which also checks `¬ favours (shaped 1 1 2 2)` and the two spreads, `2 · S = 8 < 1 · S + 2 · 1 · A = 12` and `A = 0`).

**Relation to what was there.** EL4b's `PairSelection.assorted_counts` had the complete-assortment end for pairs. That is the case `m = 2`, `ρ = 1` of `grouped_uniform_iff` with its own carriers, left as it is. MA3's record listed "a gain made by the shapers and divided among all" as not stated. In one group of all, `concordAmong = 0` and the verdict is `c < s` again. Divided among the shaper's own group, it is the law above.

**Boundary.**
- Groups are of equal size and listed as given.
- How groups form, and assortment that changes over generations or with the share, are not stated. This is 04's open item, unchanged.
- The step law needs exact transmission, as in 04 §5.
- Shaping is one or none; graded capacities stay open.

## 3. Condition 2 in detail

**The general chain** (`Drift.Replacement`, section `Weights`).
- *The step.* Among `M + 1` members with `i` of the first kind, a mixed step goes up with weight `u i`, down with `d i` and stays with `e i`. `Steps M T u d e` says `u i + d i + e i = T` at every mixed count. `valueBy M T u d e f k i` weighs the histories of `k` steps. Its algebra (`_mixed`, `_one_kind`, `_stays`, `_add`, `_mul`, `_le`, `_congr`, `_const`, `_comp`) is the constant case's, with the staying weight carried.
- *The potential.* Its steps are `riseBy j = downs d j · ups u (M − j)` with the downs below and the ups above, and `u (j+1) · riseBy (j+1) = d (j+1) · riseBy j` (`riseBy_step`). So it is harmonic (`potentialBy_harmonic`) and keeps its weighted value (`valueBy_potential`).
- *The bounds* (`valueBy_partition`, `fixedBy_below`, `potentialBy_within`, `fixationBy_bounds`, `varied_vanishesBy`, `fixationBy`, `lost_geBy`). Where every up is at least `c` and `c ≤ T`, the histories still varied after `(M + 1) m` steps weigh at most `r ^ m` with `r + c ^ (M + 1) = T ^ (M + 1)`. The fixing share lies within that of the potential's ratio. The first kind is lost with weight at least the product of the downs.

**Side bounds.**
- `riseBy_shift` moves the potential's step `n` counts: `ups u j n · riseBy (j + n) = ups d j n · riseBy j`.
- Where the ups are at least the downs at `s + 1 … M`, `potentialBy_tail` bounds the potential's tail. `lostBy_favoured` then bounds the histories losing every member of the first kind from `s + n`: times the ups at `s + 1 … s + n`, they weigh at most `t` times the downs there times `T ^ k`, with `t` the distance to the top.
- Where the ups are at most the downs at `1 … j + n`, `fixedBy_disfavoured` bounds the fixing histories from `j + 1` the same way.
- `riseBy_ends` gives the first and last steps.

**The constant case.** `value`, `rise` and `potential` are the chain with constant `a`, `b` and no staying weight. `rise_closed` recovers `b ^ j a ^ (M − j)`, and every earlier theorem keeps its name and is derived. `potential_above` now comes through `potentialBy_tail`.

**DrawnShaping drawn** (`DrawnReplacement`, a new leaf importing `Drift` and `DrawnShaping`).
- *The weights.* `up M a p hi lo i = i (a + hi + p) + (M + 1 − i)(a + lo + p)` and `down M a p c i = (M + 1)(a + c + p)` are the shapers' and the others' counts of the rule read at `i` (`drawn_carrier`, `drawn_other`). `stay` makes every step weigh `whole = (M + 1)(a + hi + p) + (M + 1)(a + c + p)` (`steps`, with `lo ≤ hi`).
- *Each member reads.* Each member is counted among its own readers, as `DrawnShaping` counts them.
- *What carries over.* `favours_iff` and `up_mono` carry the critical mass to the chain. `fixation` is `fixationBy` at these weights. `lost_ge` and `fixed_ge` are the two exits. `lost_above` and `fixed_below` are the side bounds, with `down` constant.
- *The comparison.* `one_each` gives the first and last steps of the potential. `risk_dominant_iff` is the comparison at `⟨n, n⟩`.

**Witnesses.** All three take `M = 4`, `c = 9`, `hi = 20`, `lo = 0`, so `lo < c < hi` and `2c = 18 < 20`, with the critical mass at share `9/20`.
- *Strong.* At `a = 1`, `p = 0`, the shapers' weights at the counts 1 to 4 are `up = 20 i + 5`: 25, 45, 65 and 85, whose product is 6,215,625, against `down ^ 4 = 50 ^ 4 = 6,250,000` (`Strong.other_first`, by `decide` after `one_each`).
- *Weak.* At `a = 100`, or at `a = 1` with `p = 99`, the order reverses (`Weak.shapers_first`, `Weak.shared_decides`).
- Without noise all three have the same critical mass (`DrawnShaping.drawn_favours_alike`).

**Correspondence** (an AI reading, cited, not proved).
- The chain is the Moran process of a two-strategy game in a finite population (Nowak, Sasaki, Taylor and Fudenberg 2004; Taylor, Fudenberg, Sasaki and Nowak 2004), read with a staying weight. `one_each` is the counting form of `ρ_A / ρ_B = ∏ f / g`.
- Under rare mutation the long-run shares stand as the fixation probabilities (Fudenberg and Imhof 2006).
- Kandori, Mailath and Rob (1993) and Young (1993) take mutation rare against a deterministic dynamic and select the state with the larger basin: risk dominance. Nowak and others (2004) show the Moran criterion approaching it under weak selection, and the witnesses show the two parting under strong selection.
- That a product above `down ^ M` implies `2c < hi + lo` follows from pairing the counts `k` and `M + 1 − k`, by the arithmetic–geometric mean inequality. That argument is not checked in Lean.

**Boundary.**
- Offspring are drawn one at a time. Sampled generations with selection (Wright–Fisher) stay open.
- The rare-mutation limit and any time to leave beyond the geometric bound are not proved.
- Weights are constants of the rule read at each count; readers who learn stay open.
- Selection that accumulates counts is not stated.

## 4. T7

T7 (02 §9) says a measure read from what it selects is dropped only through a change in what the loop reads, not on evidence alone. Its *in the model* clause proves invariance and the lock outliving an unread loss, both without noise. With drawing, a lock is left by drift alone with positive weight. That is a drop with no new reader, no change in the reading and no loss entering the share, which is exactly T7's refuter. So T7 holds for courses without noise, and its refuter must exclude what drift alone accounts for. The bound across the distance from the mass (`lost_above`) gives the exclusion: a lock in a population large enough, at a share far enough above its critical mass, for drift alone to leave it rarely. The new forbidden case is the converse: such a lock left by its selectors with nothing read changed, more often than the drawn model's bound allows, its premises read on the case. The bound is a weight of histories in the model, not a frequency of actual cases, so reading it on cases is part of the test's coding. The thesis sentence itself now says "drift aside", and the earlier fourth forbidden case and "for good" carry the noise scope. Both are stated in 02 §9 and in 08's thesis row. Neither is frozen. T7's frozen test is still the field test of reform events, now coded with a population size and a distance from the mass.

## 5. Texts narrowed

- **02 §9.** "whatever `p`" in MA3's home is scoped, and two theorem paragraphs are added: shaping selected among groups, and drawn shaping drawn one at a time. In the D45 readings, the first is joined to the second order's lever and the second's KMR sentence is replaced. A sorting paragraph is added; T7 gets its noise caveat, forbidden case and refuter's exclusion; the Open item drops what is now stated.
- **04 §5 and §6.** The kept form is added to Hamilton's paragraph, and the fixation row gets weights read from the count and the side bounds.
- **07 §6, the alignment dossier, GOALS (through its goal source), COLLECTIVE-DIRECTION and 08's thesis row.** These follow the homes.
- **Records.**
  - Two are new: `shaping-selected-among-groups` and `drawn-shaping-drawn-one-at-a-time`.
  - Four are extended or narrowed: `selection-with-returns-to-groupmates`, `fixation-with-selection`, `shaping-the-rule-selected-by-what-comes-back` and `shaping-read-by-readers-drawn-from-the-selected`.

## 6. Result block

- **Result(s).**
  - `SelectionLevels.rises_iff_kept` and its two parts.
  - `RuleShaping.grouped_*` with the witness `Assorting.either_verdict`.
  - `Drift.Replacement`'s chain with weights read from the count, its bounds and side bounds.
  - `DrawnReplacement` with its witnesses.
- **Delta.** MA3's direction is the zero-assortment case of Hamilton's rule with `s` added. MA4's lock is the no-noise case of a Moran chain whose exits are bounded across the distance from the mass. Risk dominance is the even-share comparison, and it parts from the Moran criterion under strong selection.
- **Premises.**
  - Discrete steps and natural counts, with exact transmission for the step law.
  - Groups of equal size listed as given.
  - Readers counted as the population counts them, with `lo ≤ hi`.
  - Offspring drawn one at a time, with constant `a`, `p`, `c`, `hi` and `lo`.
- **Evidence.**
  - Scratch builds of the edited modules, then the root with every dependent, all clean (367 steps reused).
  - Every axiom report is empty for SelectionLevels (81 theorems), RuleShaping (61), Drift (129) and DrawnReplacement (19).
  - The core receipt is named in the records at landing.
- **Boundary.** §2 and §3 above. The rare-mutation limit, KMR/Young and the AM–GM pairing are cited or argued, not proved. No ethical premise enters, and nothing here ranks capture against open rule-making: that needs C.
- **Integration.**
  - Homes: 04 §5, 04 §6 and 02 §9.
  - Readers' texts: 07 §6, ALIGNMENT A-10 and A-10b, COLLECTIVE-DIRECTION and 08 T7.
  - Board item AJ, conditions 1 and 2.
  - Where these laws meet ZH's mapping (reading in time, the pool), ReadInTime and `ClosedCapture.Drawn` are cited and left unchanged.

## 7. Not done

- Drift for accumulating counts (`ChoiceCountCapture`).
- Wright–Fisher with selection.
- Assortment formed by the share.
- A frozen test of T7 with its new exclusion.
## 8. The independent reading

One independent AI reader (read-only, 3 November 2026) checked every restatement against its home and the Lean. It confirmed the witness arithmetic, the group witness, the homes of `grouped_*` and `rises_iff_kept`, the cited standings and the Chinese texts. It found twelve faults, and all twelve were taken:
1. A weight said to fall where Lean bounds it above by a product that falls.
2. T7 and 08's row generalising drift from the critical mass to every lock.
3. A weight of histories read as a frequency of cases.
4. T7's fourth forbidden case and "for good" without the noise scope.
5. The sorting paragraph contradicting its own not-left case, and misstating `lost_geBy`'s bound; it has no standing tag.
6. ReadInTime's `lo′` case filed as proved where it is a substitution.
7. The fixation ratio credited to `one_each` alone.
8. "Only in the limit" claimed where one witness shows only that the two can part.
9. The cited standing of the rare-mutation limit dropped in A-10b.
10. A wrong hypothesis for `lost_geBy` in 04's row and the kit.
11. The `ρ` form attributed to the theorem, which is in spreads.
12. Four unchanged lines still unscoped (AJ's plan, the failure-mode map, the meta-attractor page twice).

It also noted that 08's T7 row lists only some of 02's forbidden cases; the row now says so.
