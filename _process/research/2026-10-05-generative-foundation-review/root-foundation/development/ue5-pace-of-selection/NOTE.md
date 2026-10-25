# UE5: the pace of selection bounded by the inflow (draft)

25 October 2026. AI-drafted Lean for board item UE5, claimed by the coordinating session. Only this kit was written. No record, chapter, board row or generated page was changed, and nothing is committed.

## Files

- `tree/Becoming/SelectionPace.lean`: the module `Becoming.SelectionPace`, 1194 lines. It is pure core: it imports `Becoming.Reproduction` and `Becoming.Entropy` and nothing else.
- `scratch.log`: the final scratch build. It has the command, the checkout HEAD and the source's sha256.
- `tree/.build/`: scratch build output. It is git-ignored and can be regenerated.

## Build

The build used `python3 -B scratch_build.py <kit>/tree` (Lean v4.29.1).

- The module's compile and its axiom audit ran on the final bytes (sha256 `893cce81…`). The 30 imported modules were reused from passed steps.
- **43 theorems in 84 declarations. No error and no warning (`unclean: []`). Every axiom report is empty (`with_axioms: {}`).**
- Overlapping match patterns pull in `propext`, so the witnesses use disjoint, exhaustive patterns only.

## The natural statement fails; what holds instead

The natural statement is this: across a step, how far selection moves a target's share is bounded by what flows into the population and by what each member needs. **It is false.** `Displacement` is a family that is closed, balanced and dissipated on. Its inflow is zero, its size stays at two, and every member stands at its least standing. Yet the carriers' share rises from a half to the whole in one step. The carrier's lineage draws the other member's standing and a pool unit. This is soft selection: what one lineage gains, another loses.

What holds is this: the pace is bounded by what flows into the **lineages carrying** the amount (`carriedInflow`). That inflow may be drawn from other lineages.

## What is proved (one line each; m is the least standing of each offspring)

Premise words used below:
- **balanced on the lineage**: the flow balances on the parents and offspring across the step (`BalancesOn`).
- **arising at m**: each listed offspring comes to stand across the step, at level m or more.
- **capped**: each parent stands at no more than m, so it holds no surplus.
- **sustained**: the population is not shrinking.
- **exact**: exact transmission.

Offspring within what stood and what flowed in:
- `lineage`: a list of parents followed by their offspring, the family a lineage occupies across a step.
- `lineage_sub`: a parent's lineage lies within the lineage of any list containing that parent.
- `fresh_total`: offspring that come to stand across the step total nothing before it.
- `standing_total`: offspring standing at m or more total at least m times their number.
- `born_within_inflow`: take a list made of some relata `es` followed by offspring arising at m, with the flow balanced on it. Then m·born + standing(es) after the step ≤ standing(es) before + inflow(list).
- `parent_within_inflow`: m · (a parent's offspring number) ≤ the parent's standing + the inflow into its lineage.
- `generation_within_inflow`: m · (next size) ≤ the generation's standing + the inflow into the generation and its offspring.

The response of a carried amount:
- `carriedInflow`: the inflow into each parent's lineage, counted as often as the parent's amount.
- `sum_exact`: with exact transmission, the next total equals `selected` (the parents' amounts weighted by offspring number).
- `mean_step_exact`: with exact transmission, n·s' + discord = n'·s + concord.
- `offspring_within_carried`: m·s' ≤ Σ amount·standing + carriedInflow (balanced, arising at m, exact).
- `total_within_carried`: adding capped, m·s' ≤ m·s + carriedInflow. Each unit gained costs m units of carried inflow.
- `response_within_carried`: adding sustained, m·(n·s') ≤ m·(n'·s) + n·carriedInflow. This is the per-step pace of the mean.
- `selection_within_carried`: under the same premises, m·concord ≤ m·discord + n·carriedInflow. This bounds the selection term proper.
- `unfed_rise_shrinks`: with m > 0, capped and no carried inflow, a rise of the mean makes the next generation smaller.

Over a stretch:
- `stretch_within_carried`: m·s_T ≤ m·s_0 + the carried inflow summed over the stretch. Every step must be balanced, arising at m, exact and capped.
- `moved_within_carried`: adding n_0 ≤ n_T, m·(n_0·s_T) ≤ m·(n_T·s_0) + n_0·(the stretch's carried inflow).
- `steps_to_move`: if each step carries at most I, m·(n_0·s_T) ≤ m·(n_T·s_0) + n_0·(T·I). So moving a mean by D (cross-multiplied) takes T ≥ m·D/(n_0·I) steps. This is Haldane's cost in counting form.

Offspring number:
- `number_step_within_inflow`: read by offspring number, exact at t, and the t+1 lineage balanced and arising at m. Then m·(n₁² + V_t) ≤ n_t·(standing at t+1 + inflow at t+1), where V_t is the squared differences over pairs.
- `number_spread_within_inflow`: adding capped at t+1 and sustained, m·V_t ≤ n_t·I_{t+1}. So Var(offspring number) ≤ inflow per member / m.
- `number_unfed_uniform`: under the same premises, with m > 0 and no inflow, offspring numbers are uniform.
- `numbered`, `numbered_family`: the same generations, read by offspring number; they have the same families.
- `response_sq_within_inflow`: needs offspring number itself transmitted exactly. Then m·(response)² ≤ n_t·I_{t+1}·spread(amount), in both directions. This is the audit's Cauchy–Schwarz route.

Witnesses:
- `Displacement.displacement`: the family is closed, dissipated on and has inflow 0. Sizes are 2 → 2, the share goes 1/2 → 1, concord 2, discord 0, carried inflow 1. The response and selection laws hold **with equality**.
- `Displacement.premises`: the premises of the response law hold at step 0 with m = 1.
- `Displacement.least`: in any world meeting those premises with these counts, the carried inflow is ≥ 1.
- `Displacement.spread_needs_inheritance`: V_0 = 4 while the inflow at step 1 is 0. Every premise of the spread bound holds except exact transmission of offspring number, which fails.
- `Fed.fed`: sizes 2, 2, 4 with V = 4 and an inflow of 2 from a source. Both offspring-number bounds hold **with equality**.
- `Fed.premises`: the premises of `number_spread_within_inflow` hold of `Fed`.
- `Fed.least`: in any world meeting those premises with these counts, the inflow is ≥ 2.
- The remaining declarations of each witness define its relata, standings, flow and generations, and prove balance (plus closure and dissipation for `Displacement`) and membership facts.

## Third part against Price and Fisher

**Verdict: yes, weak. It is carried by a premise: balance read on the lineage family, with a least standing and no surplus as local hypotheses. Each forbidden statement is known in a neighbouring field.**

- **Against Price** (an identity that admits every count). This is forbidden: in a sustained population holding no surplus, the mean of an exactly transmitted amount rising across a step by more than carriedInflow / (m·n'). Concretely, a share going from a half to the whole at constant size two with less than one unit drawn into the carrier's lineage (`Displacement.least`). Price allows that pace with nothing flowing in.
- **Against Fisher** (exact case: the mean offspring number rises by Var/mean, and the identity is free). This is forbidden: in a sustained population whose next generation holds no surplus, exact transmission of offspring number with Var > I/(m·n). Concretely, sizes 2, 2, 4 with an inflow below 2 (`Fed.least`). With nothing flowing in, no variance is possible at all (`number_unfed_uniform`).
- **Strength.** Row 23 of the audit gives the closed-family case qualitatively: some step lowers offspring number. This module gives a per-step, quantitative version with an inflow, for any exactly transmitted amount, with the bounds attained. Following the audit's method, it is still a conservation join, and nothing here is new to the sciences taken jointly. The known neighbours are:
  - Malthusian, resource-limited reproduction;
  - the parental-investment budget (Smith and Fretwell 1974);
  - Haldane's cost (1957) in resource form;
  - density regulation of heritable variance in fitness.

  Wallace's soft selection (1975) is why the inflow into the whole does not bound composition.
- **Haldane, precisely.** Haldane's cost grows with ln(1/p₀) and is paid in selective deaths against a reproductive excess. The cost here is linear: m units for each unit an amount gains. That is the standing of the members gained, which is conserved. An unpaid gain is paid in population size (`unfed_rise_shrinks`). The two costs differ, and neither is the other's case.
- **The audit's candidate as stated** ("bounded by I and the amount's spread, by Cauchy–Schwarz") holds only where offspring number is itself transmitted exactly (`response_sq_within_inflow`). Without that premise it fails (`spread_needs_inheritance`). The carried-inflow law needs no transmission of offspring number, but it bounds by the lineage inflow.
- **Test**, if wanted: heritable variation in offspring number at capacity under a controlled inflow. Freeze the ceiling Var ≤ I/(m·n) in advance. This is low risk: the outcome is the Malthusian bound read on Fisher's rate.

## What is not derived

- These are premises, stated where used, not derived: the least standing m, no surplus, exact transmission, a sustained population.
- A bound by the inflow into the whole family is not derived, and it is false (`Displacement`).
- Haldane's logarithmic cost is not derived.
- No stretch law for a pace through each parent's fecundity: where parents hold more than m, the general `offspring_within_carried` carries such a pace, but it is not stated over a stretch.
- How long exact transmission of offspring number with growth can last within a bounded inflow. The closed case is `Reproduction.Flow.closed_lineage_lowered`.
- Drift and mutation.
- Dissipation is not used. Losses (at least one unit per taker) would tighten every bound; this is not stated.
- Modelling choices:
  - natural-number amounts and standings, discrete steps, non-overlapping generations;
  - the least standing is a level, not the web's `need`;
  - lineage lists may repeat a relatum and the bounds still hold, but reading the inflow as the lineage's own needs a listing without repetition.

## Place in the spine and board rule 9

- **Leaf.** It joins `Reproduction` and `Entropy`, which do not import each other (checked on the import closure), and nothing below needs it.
- `born_within_inflow` is a sibling of `Reproduction.Flow.born_within_stock`: the same shape, with the inflow in place of the takers, and with balance instead of dissipation. Its stock step is derived inline from `Flow.BalancesOn.over` and `Flow.replenishment_le_inflow`, so no new general lemma sits beside Entropy's `Flow.Balances.stock_inflow`. That law is stated for a globally balanced flow; this module needs balance only on the lineage family.
- If a landing applies rule 9 in full, two things could follow:
  - a general form for any family with distinct offspring inside it, m·born ≤ stock + inflow, placed below both siblings;
  - a `BalancesOn` form of the stock law in Entropy.

  Both are integrator decisions.
- `numbered` builds the generations read by offspring number. Reproduction has only the predicate `ByNumber`.
- **Suggested home:** 04 §4, beside what-bounds-offspring-numbers, as a new record. Also the missing evolution row in 08 §8 (audit §7, item 6).

## Open issues

- A share law over the carriers' joint lineage would be tighter than the per-parent carried inflow. It would need the carriers as a filtered sub-list.
- No witnesses for the necessity of `capped` and `sustained`. For the latter, `unfed_rise_shrinks` states what an unpaid rise does.
- No multi-step witness of `steps_to_move` attained. `Displacement` attains it with T = 1 and I = 1.
- The literature verdicts come from the AI's prior knowledge, with no web search. No independent review was made.
