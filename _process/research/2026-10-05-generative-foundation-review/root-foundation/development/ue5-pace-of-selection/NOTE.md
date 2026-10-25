# UE5: the pace of selection, within what flows in

25 October 2026, revised 25–26 October against [REVIEW-UE5](REVIEW-UE5.md), and on 26 October against the same reviewer's re-check of that revision ([below](#the-re-check)). AI-drafted Lean and text for board item UE5, claimed by the coordinating session. Only this kit was written; no record, chapter, board row or generated page was changed. The revision was committed at `6170c9fa7`; the re-check's fixes are not committed. [LANDING.md](LANDING.md) says what lands and how.

## Files

- `tree/Becoming/SelectionPace.lean`: the module `Becoming.SelectionPace`, 2,518 lines. It is pure core: it imports `Becoming.Reproduction` and `Becoming.Entropy` and nothing else.
- `scratch.log`: the final scratch build, with the command, the checkout HEAD and the source's sha256.
- `REVIEW-UE5.md`: the independent review of the first draft (`cbf47d521`), and the same reviewer's re-check of the revision (`6170c9fa7`).
- `LANDING.md` and the landing scripts (`integrate_ue5.py`, `texts_ue5.py`, `make_records_ue5.py`, `register_ue5.py`, `board_ue5.py`, `study_ue5.txt`). None has been run; each parses.
- `tree/.build/`: scratch build output, git-ignored and regenerable.

## Build

`python3 -B scratch_build.py <kit>/tree` (Lean v4.29.1), on the final bytes (sha256 `abf440ad…1a72b3`), the 30 imported modules reused from passed steps. The re-check's fixes changed docstrings only; the build before them, on `92556df7…07a3ca`, gave the same counts.

**103 theorems in 224 declarations. No error and no warning (`unclean: []`). Every axiom report is empty (`with_axioms: {}`).** The witnesses use disjoint, exhaustive patterns only, since overlapping patterns pull in `propext`.

**Counts by kind** (review, suggestion 20).
- *The general part*: 41 theorems and 4 definitions (`lineage`, `carriedInflow`, `carriers`, `numbered`).
  - 13 laws: `born_within_inflow`, `parent_within_inflow`, `generation_within_inflow`, `offspring_within_carried`, `total_within_carried`, `response_within_carried`, `inflow_lineage_le`, `joint_within_carried`, `share_within_rest`, `parent_within_factor`, `number_step_within_inflow`, `number_spread_within_inflow`, `response_sq_within_inflow`.
  - 13 corollaries, by arithmetic, induction or a case: `selection_within_carried`, `unfed_rise_shrinks`, `share_within_joint`, `stretch_within_carried`, `moved_within_carried`, `steps_to_move`, `total_within_factor`, `total_within_power`, `share_within_power`, `whole_within_power`, `number_unfed_uniform`, `standing_pinned`, `stands_of_need`.
  - 2 restatements under exact transmission: `sum_exact`, `mean_step_exact`.
  - 13 helpers: `lineage_mono`, `lineage_sub`, `fresh_total`, `standing_total`, `mem_carriers`, `total_lineage_one`, `total_lineage`, `excess_add_le`, `excess_total_le`, `total_carriers_le`, `total_carriers_unit`, `numbered_family`, `numbered_number`.
- *The witnesses*: 62 theorems in 179 declarations, in six worlds. Sixteen theorems state what a world shows (listed below); the other 46 are its facts (balance, closure, dissipation, the premises read by membership).

## The natural statement fails; what holds instead

The natural statement: across a step, how far selection moves a target's share is bounded by what flows into the population and by what each member needs. **It is false** (`Displacement.natural_fails`). In `Displacement` a family is closed, balanced and dissipated on, and gains nothing. The population's size stays at two and every member stands at its least standing, yet the carriers' share rises from a half to the whole in one step. The population's own lineage, members and offspring without the pool, gains nothing either, so the response law fails with either inflow in place of the carried inflow. The carrier's lineage rises by one while the rest of the whole, the pool and the other member, falls by two (`Displacement.rest_falls`).

This is the theory's own law that a rise past the inflow is drawn from beyond (`Flow.Balances.rise_le_inflow_beyond` and `Flow.Balances.rise_paid_from_beyond` in `SelectionReach`, `Flow.Balances.rise_lowers_beyond` in `DrawnBeyond`), read on offspring. It is a zero-sum draw within a closed whole: what one lineage gains, the rest loses. That is the setting of Wallace's soft selection; the soft-selection label is a reading, since one step of a supplied flow cannot show how a population's output responds to its composition.

What holds instead:
- **The corrected natural statement**, at the level of the whole (`share_within_rest`). For an amount of zero or one, the carriers' rise times `m` is within what the rest of a whole falls by and what flows into the whole.
- **The lineage form.** The pace is within what flows into the lineages carrying the amount (`carriedInflow`). That sum is taken lineage by lineage, so what passes between carrying lineages counts (`Swap`: two against none). It is at least the inflow into the carriers' joint lineage (`joint_within_carried`), and for an amount of zero or one the joint form holds too (`share_within_joint`).

## What is proved (`m` is the least standing)

The premise words:
- **balanced on the lineage**: the flow balances on the parents and their offspring across the step (`Flow.BalancesOn`);
- **arising at `m`**: each listed offspring comes to stand across the step, at `m` or more;
- **capped**: each parent stands at no more than `m`;
- **sustained**: the population is not shrinking;
- **exact**: exact transmission.

Arising at `m` and capped together pin a member of the next generation at exactly `m` (`standing_pinned`). Over a stretch with the parents capped at each step before `T`, the members of generations 1 to T − 1 are pinned, and those of generation T only where they are capped too. A capped parent never stands above the least, so every offspring beyond one for each parent must be fed by what flows in at its own step. This is where the laws' strength and their narrowness both lie. `m` is a supplied level. It follows from a dependence only through `stands_of_need`: in a web where activity needs support (`Web.Dependent`), a relatum active at a step that requires its own standing at need `m` or more stands at `m` or more.

**Offspring within what stood and what flowed in.**
- `born_within_inflow`: some relata `es`, then the offspring of some parents arising at `m`, with the flow balanced on the list. Then m·born + standing(es) after the step ≤ standing(es) before + inflow(list).
- `parent_within_inflow`: m · (a parent's offspring number) ≤ the parent's standing + the inflow into its lineage.
- `generation_within_inflow`: m · (next size) ≤ the generation's standing + the inflow into the generation and its offspring.

**The response of a carried amount.**
- `carriedInflow`: what flows into each parent's lineage, summed lineage by lineage and weighted by the amount. What passes between carrying lineages counts, so it is at least the inflow into the carriers' joint lineage.
- `offspring_within_carried`: balanced, arising at `m` and exact give m·s′ ≤ Σ amount·standing + carriedInflow.
- `total_within_carried`: adding capped, m·s′ ≤ m·s + carriedInflow. Each unit gained needs `m` units of carried inflow.
- `response_within_carried`: adding sustained, m·(n·s′) ≤ m·(n′·s) + n·carriedInflow, the per-step pace of the mean.
- `selection_within_carried`: under the same premises, m·concord ≤ m·discord + n·carriedInflow, the selection term proper.
- `unfed_rise_shrinks`: with m > 0, capped and no carried inflow, a rise of the mean makes the next generation smaller.

**The carriers and the rest of a whole** (an amount of zero or one).
- `share_within_rest`: m·s′ + standing(rest) after ≤ m·s + standing(rest) before + inflow(carriers, rest, carriers' offspring).
- `share_within_joint`: with no rest, m·s′ ≤ m·s + inflow(the carriers' joint lineage). `joint_within_carried`, which holds for any amounts, puts that inflow at or below carriedInflow; it rests on `inflow_lineage_le`, the subadditivity of inflow over lineages.

**Over a stretch.**
- `stretch_within_carried`: m·s_T ≤ m·s_0 + the carried inflow over the stretch.
- `moved_within_carried`: adding n_0 ≤ n_T, m·(n_0·s_T) ≤ m·(n_T·s_0) + n_0·(the stretch's carried inflow).
- `steps_to_move`: where each step carries at most I, m·(n_0·s_T) ≤ m·(n_T·s_0) + n_0·T·I. This is a linear bound from a cap on the total. For a 0–1 amount at constant size `N`, reaching the whole from share p₀ needs a carried inflow of at least m·N·(1 − p₀) over the stretch, which is at most m·N whatever p₀ is.

**A cap on each parent** (the reviewer's per-parent law, added). Assume each step balanced on the generation's lineage, arising at `m`, exact and capped, with `m > 0`, and what flows into each parent's lineage at most `(k − 1)·m` (stated as `inflow + m ≤ k·m`). Then:
- `parent_within_factor`: each parent leaves at most `k` offspring.
- `total_within_factor`: s_{t+1} ≤ k·s_t.
- `total_within_power`: s_T ≤ k^T·s_0 over `T` such steps.
- `share_within_power`: adding n_0 ≤ n_T, n_0·s_T ≤ k^T·(n_T·s_0), so the share multiplies by at most k^T.
- `whole_within_power`: adding n_T ≤ s_T (every final member carries a 0–1 amount), n_0 ≤ k^T·s_0. So one substitution, from `c` carriers among `N`, takes T ≥ log_k(N/c) = log_k(1/p₀) steps.

The law bounds the steps one substitution takes from p₀ under a cap on each parent: the one-substitution form behind the reproductive-excess limit of Nei (1971) and Felsenstein (1971), in counts. It is not the spacing of successive substitutions that their limit states, and that spacing is not derived: with exact transmission a lineage carries all its amounts together, so two amounts starting in the same carriers reach the whole together. It is near-definitional once the cap is supplied: the flow's part is turning a cap on what flows in into a cap on offspring (`parent_within_inflow`). `Displacement` meets the factor law with equality for `k = 2` (`Displacement.factor`).

Two further points come from the re-check's probe, proved there with empty axiom reports and not in this module:
- Both of `whole_within_power`'s premises beyond the power law are needed. `whole` is fixation for a 0–1 amount; without `sustained`, `Shrink` reaches the whole in one step with k = 1.
- The premises are asked of every parent, while their bound caps only what the favoured type leaves. The factor law asking them of the carriers alone holds, with balance on the carriers' joint lineage (the probe's `total_within_factor_carriers`), and the power and whole laws would follow by the same induction. It is left as a follow-up ([LANDING](LANDING.md#follow-ups)), since adopting it changes the hypotheses of four laws and their uses.

**Offspring number.**
- `number_step_within_inflow`: read by offspring number, exact at t, and the lineage at t+1 balanced and arising at `m`. Then m·(n₁² + V_t) ≤ n_t·(standing at t+1 + inflow at t+1), where V_t is the squared differences over pairs.
- `number_spread_within_inflow`: adding capped at t+1 and sustained, m·V_t ≤ n_t·I_{t+1}, so Var(offspring number) ≤ the inflow per member over m.
- `number_unfed_uniform`: with m > 0 and no inflow, offspring numbers are uniform.
- `numbered`, `numbered_family`, `numbered_number`: the same generations read by offspring number, with the same families and read by number.
- `response_sq_within_inflow`: where offspring number is itself transmitted exactly, m·(response)² ≤ n_t·I_{t+1}·spread(amount), in both directions. Note the timing: the inflow is the next step's, into the next generation and its offspring. With offspring number inherited, its variance at t becomes growth at t+1, and that growth is what the inflow at t+1 feeds. This is a variant of the audit's Cauchy–Schwarz route.

## Witnesses

- `Displacement` (Reproduction's `OnePool` shape read with SelectionTerm's `Rising` counts: a parent takes three units, here one each from a pool, itself and another member, and gives one to each of two offspring):
  - `displacement`: closed, dissipated on, inflow 0; sizes 2 → 2, share 1/2 → 1, concord 2, discord 0, carried inflow 1; the response and selection laws hold with equality;
  - `natural_fails`: the population lineage's inflow is 0, and the response law with either the whole's or the population lineage's inflow fails;
  - `rest_falls`: the instance of `share_within_rest` (2 + 0 ≤ 1 + 2 + 0; the slack is the unit the carrier takes and gives to none);
  - `factor`: the factor law with k = 2, met with equality;
  - `premises`: the premises of the response law, with m = 1;
  - `least`: in any world with these premises and counts, carried inflow ≥ 1;
  - `spread_needs_inheritance`: read on `numbered generations`, every premise of the spread bound holds at the first step, `arise` and `stands` at the next step vacuously, except exact transmission of offspring number, which fails; the spread bound (1·4 ≤ 2·0) and the next-step response bound (1·(2·2 − 2·1)² ≤ 2·0·1) both fail.
- `Fed`:
  - `fed`: sizes 2, 2, 4, V = 4, and an inflow of 2 from a source (each offspring takes one unit from itself and one from the source); both offspring-number bounds hold with equality;
  - `premises` and `least` (inflow ≥ 2), as for `Displacement`.
- `Inherited`, `Displacement` extended by a step at which each offspring leaves two, as the carrier did:
  - `same_step_fails`: closed, dissipated on and gaining nothing at both steps, the population lineage gaining nothing at the first, offspring number inherited; the audit's candidate with the same step's inflow fails (1·4 ≤ 2·0·1 is false);
  - `next_step_attained`: the inflow at the next step is 2, and the next-step law holds with equality;
  - `stretch_attained`: the stretch law over two steps with equality, 1·4 = 1·1 + (1 + 2).
- `Swap` (`swap`): two carriers each give their unit to the other's offspring; the carried inflow is two, the joint lineage's inflow none.
- `Uncapped` (`uncapped`): a carrier standing at two; every premise of the response law but capped holds, and the law fails.
- `Shrink` (`shrink`): the share rises while the size falls from two to one; `unfed_rise_shrinks`'s premises hold, and the response law fails.

**Where the bounds are equalities.** Each response law is the stock law of the carrying lineages under the per-member bounds. The law of the total is an equality where three things hold:
- the carrying parents stand at `m` before the step and at nothing after it;
- their offspring stand at `m`;
- no formation takes more from a carrying lineage than it gives to it.

The response and selection laws are equalities where, besides, the population's size stays. The witnesses are instances of this equality case for the response, selection, factor, stretch, next-step and offspring-number laws. Not every law is attained: `share_within_rest` keeps one unit of slack in `Displacement.rest_falls` (the unit the carrier takes and gives to none), and `joint_within_carried` is strict in `Swap`, none against two. Attainment shows the inequalities lose nothing beyond the conservation identity. It does not show stringency, and "attained" should be read as no more.

## Third part against Price and Fisher

**Verdict: yes, and weak.** The result is carried by premises: balance read on the lineage family, a least standing, and parents standing at no more than `m`. Each forbidden statement is known in a neighbouring field.

- **Against Price** (an identity admitting every count). Forbidden: in a sustained population whose parents stand at no more than `m`, the mean of an exactly transmitted amount rising across a step by more than carriedInflow / (m·n′). Concretely, a share going from a half to the whole at constant size two with less than one unit of carried inflow (`Displacement.least`). Price allows that pace with nothing flowing in.
- **Against Fisher** (exact case: the mean offspring number rises by Var/mean, the counts free). Forbidden: in a sustained population whose next generation stands at no more than `m`, exact transmission of offspring number with Var > I/(m·n). Concretely, sizes 2, 2, 4 with an inflow below 2 (`Fed.least`). With nothing flowing in, no variance at all (`number_unfed_uniform`).
- **Against row 23 of the audit.** This module is a per-step, quantitative companion of row 23's law under other premises: no standing above `m` and no shrinking, instead of closure and dissipation. Neither implies the other.
- **The neighbours.**
  - Malthus (1798), the main one: reproduction limited by what sustains it, here read on the lineages carrying an amount.
  - Smith and Fretwell (1974): `parent_within_inflow` is the budget constraint of their model (its premise; its result, the best offspring size, is not read).
  - Density regulation of heritable variance in fitness: `number_unfed_uniform` in counts, under exact transmission of offspring number.
  - Haldane (1957): his cost is a total of selective deaths, logarithmic in 1/p₀. The model has no selective deaths, since generations list only offspring that come to stand. `steps_to_move` is linear and is not Haldane's cost. The per-parent law is the one-substitution form behind the Nei–Felsenstein limit, in counts; the spacing of successive substitutions is not derived.
- **The audit's candidate as stated**, with the inflow of the same step, is false whether or not offspring number is transmitted exactly (`Displacement.displacement`; with offspring number inherited, `Inherited.same_step_fails`). What holds is a variant with the inflow of the next step into the next generation's lineage, where offspring number is transmitted exactly (`response_sq_within_inflow`, attained in `Inherited.next_step_attained`). Without that premise the variant fails too (`Displacement.spread_needs_inheritance`).
- **The test.** The variance ceiling Var ≤ I/(m·n) needs exact transmission of offspring number, which no population meets, and its `I` is the inflow into the next generation's lineage net of what members take, counted lineage by lineage. As stated it tests the idealization. A test that can be frozen is the whole-level form (`share_within_rest`), whose quantities are measured on the whole population: for a marker carried at zero or one, in a population whose members stand at a fixed least amount (for example, cells at a fixed biomass just after division), `m` times the carriers' rise is at most what the rest of the population and its medium lose, plus the supply. The risk is low: a failure would show the accounting misread (the least standing, the rest's standing, the supply), not a law refuted.

## What is not derived

- **Premises, stated where used, not derived:** the least standing `m` (beyond `stands_of_need`), parents standing at no more than `m`, exact transmission, a sustained population.
- **A bound by the inflow into the whole family or into the population's own lineage.** It is false (`Displacement.natural_fails`).
- **Haldane's cost in selective deaths.**
- **The spacing of successive substitutions.** `whole_within_power` bounds one substitution.
- **The carriers' joint law for an amount above one**; it would go in layers (the members whose amount is at least `j`, for each `j`).
- **How long exact transmission of offspring number with growth can last within a bounded inflow.** The closed case is `Reproduction.Flow.closed_lineage_lowered`.
- **Drift and mutation.**
- **Dissipation is not used.** Dissipation on the lineage's own family would leave it no inflow (`Flow.DissipatesOn.gainlessOn`, `Flow.gainlessOn_iff_inflow`), the case dissipated on that `Reproduction.Flow.born_within_stock` treats. Dissipation on a wider family does not tighten these bounds: `Displacement` is dissipated on its whole family and attains the response and selection laws.
- **Modelling choices:**
  - natural-number amounts and standings, discrete steps, generations each listed as the offspring of the last, each offspring coming to stand across its step;
  - a lineage's family is listed as parents then offspring and may repeat a relatum; the bounds still hold, but reading the inflow as the lineage's own needs a listing without repetition.

## Place in the spine and board rule 9

The module is a **leaf**. It joins `Reproduction` and `Entropy`, neither of which imports the other, and nothing below needs it. No landed module was changed. The rule 9 moves the review recommends are listed in [LANDING.md](LANDING.md#rule-9) as owners' decisions and follow-ups:
- a balanced-on form of Entropy's stock law, with the global law derived from it;
- `born_within_stock` kept beside `born_within_inflow`, because in the pure core neither placement of the offspring derives the other;
- `mean_step_exact` moved to `SelectionTerm`, or kept and called the fifth copy, as its docstring now does;
- `numbered`, `numbered_family` and `numbered_number` moved beside `ByNumber`;
- the inflow subadditivity moved to `Entropy`.

## The review, finding by finding

[REVIEW-UE5](REVIEW-UE5.md) found the Lean sound and recommended landing after fixes: 1 error, 3 overclaims, 9 imprecisions, 7 suggestions. Every finding was taken.

| # | Finding | Fix |
|---|---|---|
| 1 | Error: the audit's candidate fails even with offspring number inherited | `Inherited.same_step_fails`; `response_sq_within_inflow`'s docstring and the module's state the next step's inflow; `Inherited.next_step_attained`; third part rewritten |
| 2 | "Haldane's cost in counting form" | Dropped from module, NOTE, record and board row (`board_ue5.py` replaces the title phrase and the state); the Haldane reading sits on `whole_within_power` only; `steps_to_move` called linear |
| 3 | "Losses would tighten every bound" | The review's text, in the module and here |
| 4 | Not a quantitative version of row 23 | "a per-step, quantitative companion under other premises" |
| 5 | What `carriedInflow` counts | Definition docstring and readings; `joint_within_carried`; `Swap`; "needs" for "costs" |
| 6 | Attainment is the equality case | The equality-case paragraph (module, NOTE, record); witnesses as instances |
| 7 | State the natural statement's failure and place it | `Displacement.natural_fails`, `Displacement.rest_falls`; the whole-level corollary named (`share_within_rest`); drawn-from-beyond laws cited |
| 8 | "Soft selection" is a reading | Worded as a reading |
| 9 | `spread_needs_inheritance` states values only | Vacuous `arise` and `stands`, both failing inequalities, "read on `numbered generations`" |
| 10 | Smith and Fretwell supply the premise | "its premise; its result is not read" |
| 11 | The test | Tests the idealization; redesigned on `share_within_rest` |
| 12 | What the premises pin | `standing_pinned`; `stands_of_need` |
| 13 | Small text fixes | `Fed`'s docstring; "the population's size"; "re-derived here unnamed" |
| 14 | A balanced-on form of Entropy's stock law | LANDING, Entropy owner's decision; `born_within_inflow`'s docstring says what it re-derives and why `born_within_stock` stays |
| 15 | `mean_step_exact` and `numbered` belong below | LANDING moves; "fifth statement" in the docstring; `numbered_number` added; `Displacement`'s shape named |
| 16 | Witnesses for `capped` and `sustained` | `Uncapped` (the probe's `Surplus`, renamed: the name says which premise fails), `Shrink` |
| 17 | The joint law | `carriers`, `share_within_joint`, `joint_within_carried`; layers for amounts above one stay open |
| 18 | The per-parent law | `parent_within_factor`, `total_within_factor`, `total_within_power`, `share_within_power`, `whole_within_power`; `Displacement.factor` |
| 19 | Wording | "stands at no more than `m`", "is fed by", "draws", "needs"; "cost" only in the Haldane reading, "budget" only naming Smith and Fretwell's model |
| 20 | Counts | Counts by kind, here and in LANDING |

The probe's witness worlds reported `propext` (overlapping patterns); `Inherited`, `Swap`, `Uncapped` and `Shrink` were rewritten with disjoint patterns and have empty axiom reports. The probe's R7 is the per-parent law, renamed (`fecund_number` → `parent_within_factor`, `fecund_step` → `total_within_factor`, `fecund_stretch` → `total_within_power`). Its general laws R1 (a balanced-on stock law, with `born_within_inflow` keeping what the list loses) and R2 (dissipated on, a family has no inflow) were not taken into the module. Both are statements about `Flow` whose home is `Entropy` (rule 9), and R1 is the Entropy owner's decision; the module's text cites R2's two Entropy lemmas instead.

## The re-check

The same reviewer re-checked the revision committed at `6170c9fa7` ([REVIEW-UE5](REVIEW-UE5.md#re-check-of-the-revision-6170c9fa7)). Its verdict:
- the revision takes all twenty findings, and each fix holds;
- the Lean is sound (rebuilt at `6170c9fa7` and at main `841d2cb51`: 103 theorems in 224 declarations, every axiom report empty);
- the per-parent law is right and can hold with growth, and both of `whole_within_power`'s further premises are needed;
- the landing scripts apply exactly once in a scratch dry run.

It found 1 overclaim, 3 imprecisions and 1 suggestion, all in text, and recommended landing after R1–R4. The findings use the re-check's own labels, not the first probe's. All five were taken, R5 as a follow-up:

| # | Finding | Fix |
|---|---|---|
| R1 | Overclaim: `whole_within_power` bounds one substitution, where the texts called it the Nei–Felsenstein spacing of successive substitutions | Module, NOTE, LANDING, study, record and the 04 and 08 texts: the steps one substitution takes from p₀ under a cap on each parent, the form behind the classical limit, not the spacing of successive substitutions. The spacing is added to the record's scope items, and the alias is narrowed |
| R2 | `born_within_stock` assumes dissipation, not closure | "The case dissipated on" for "the closed case" (module, NOTE, record's scope item); "its sibling for a family dissipated on" in the record's link to what bounds offspring numbers |
| R3 | Not every law is an equality in the witnesses | The attained laws are named (response, selection, factor, stretch, next-step, offspring number); `share_within_rest`'s unit of slack and `joint_within_carried`'s strictness are stated (04 and 08 texts, study, NOTE, LANDING) |
| R4 | Stale facts | No study number assumed (`N` is read at landing); the line count and hashes updated; the stretch reading of `standing_pinned` corrected (generations 1 to T − 1, and generation T only where capped); `steps_to_move`'s attainment at T = 1 stated as the witnesses'; "not re-checked" dropped |
| R5 | Suggestion: the cap is needed only at carriers | Not a one-line change (the hypotheses of four laws and their uses), so it is a follow-up in [LANDING](LANDING.md#follow-ups). The module's docstrings say the premises are asked of every parent and leave the carriers-only form open |

## Open issues

- The carriers' joint law for an amount above one (layers).
- The least standing tied to need beyond the one lemma.
- The cap laws asked of the carriers alone (the re-check's R5; [LANDING](LANDING.md#follow-ups)).
- The witnesses attain `steps_to_move`'s uniform cap per step only at T = 1 (in `Displacement`, not stated as a theorem); nothing shows that it cannot be attained over a longer stretch. `stretch_within_carried` is attained over two steps (`Inherited.stretch_attained`).
- The literature verdicts come from the AI's prior knowledge and the review's sources; no new search was made for this revision.
