# UE2: what the landing needs

25 October 2026. AI-authored, after the kit's revision against [REVIEW-UE2.md](REVIEW-UE2.md) (findings 17 and 19 ask for this list) and its re-check. It names what the landing must change and check. The landing scripts, modelled on UE1's landed kit (`../ue1-fep-bridge/`), are in this kit and listed in §7 in the order they run; none has been run here, beyond a parse check and a check that every anchor they edit occurs exactly once on the main of this writing. [NOTE.md](NOTE.md) holds what is proved and why.

## 0. The decision on Typicality

`typical_throughout`, Kolmogorov's maximal inequality in counting form, strictly generalizes `Typicality.typical`. It uses only Typicality's courses, weights and step identities. Board rule 9 asks that it land below `typical`, with `typical` its corollary, and not beside it in a new module.

Typicality's owner, the fork session that landed P116 on 16 October, is inactive, and no definition changes. So the lander, the session that claimed UE2 and briefed its drafting, decides to land the change in Typicality, below `typical`, as rule 9 asks, and the board row says so.

The change is the kit's [Typicality.lean](tree/Becoming/Typicality.lean), sha256 `9eacd128…de6bc98`, over the landed file, sha256 `904976890149…b52e1d8a3`. It includes the review's three amendments:

- `offBy_le` deleted;
- the bullet retitled "The deviation stays within the bound at every step";
- `regroup_square`, `square_gap` and `margin_square` moved in, with `two_mul_le_of_le` derived from `margin_square`.

Before landing, the lander checks that the landed Typicality is still at `904976890149…`.

## 1. Lean and the checker

- **New core module.** `Becoming.ConditionalWeights` ([source](tree/Becoming/ConditionalWeights.lean), sha256 `479c8401…cac0361f`) goes to `Becoming/ConditionalWeights.lean`. It imports `Becoming.Typicality` and is imported by nothing (a leaf).
- **Changed core module.** `Becoming/Typicality.lean`, as in §0.
- **Expected counts at the new core receipt**, as in the kit's [scratch.log](scratch.log):
  - ConditionalWeights: 93 theorems in 110 declarations;
  - Typicality: 52 in 72 (40 in 52 before);
  - TypicalRuns, Situations, Drift, FinerTraces, SituationTraces and HistorySums: unchanged;
  - every axiom report empty.

  Nothing else in the package imports Typicality but the root.
- **Root module `Becoming.lean`.** Add `import Becoming.ConditionalWeights` and an L1 bullet for it. Typicality's bullet gains the maximal law.
- **`check_becoming.py`.**
  - Add `"Becoming.ConditionalWeights"` to the core list; ChoiceCountCapture was added after RuleShaping, and this one goes after its import, `Becoming.Typicality`, or where the list's order requires.
  - In SCOPE, add a sentence for ConditionalWeights, and extend Typicality's sentence with the bound at every step.
- **Package README rows**, EN (`README.md`) and ZH (`README.zh.md`): a new row for ConditionalWeights. Typicality's row gains `typical_throughout` and `margin_square`, the latter with `two_mul_le` as its case at margin zero.

## 2. Records

### New records for ConditionalWeights (two proposed)

Both are `theorem` records bound to the new core receipt, with references to `ConditionalWeights.lean` (role proof). The second is also bound to `Typicality.lean`.

**(a) Conditioning by restriction and shares** (proposed id `conditioning-by-restriction`; near-definitional, as UE1 labels its part 1).

Laws:

1. **Conditional weights.** The weighting restricted to a record. An event's weight under it, its whole, the law of total weight, a record raising no weight, and two records in turn being their conjunction in either order. Declarations: `restrict`, `mass_restrict`, `whole_restrict`, `mass_split`, `restrict_le`, `mass_restrict_le`, `restrict_restrict`, `restrict_comm`.
2. **Shares.** Shares are compared by cross-multiplication, a preorder on shares with a positive whole. `⟨0, 0⟩`, the share of an event whose whole is nothing, compares either way with every share, so the laws given a record say nothing where it weighs nothing; a positive part over nothing does not. Less share is more surprise. Declarations: `Share`, `Share.le`, `Share.Same`, `Share.mul`, `Share.one`, `Share.reciprocal`, `Share.le_refl`, `Share.le_trans`, `Share.zero_whole`, `Share.le_iff_reciprocal`, `Share.mul_le_mul`, `Share.mul_le_left`, `share`, `share_le_of_included`, `share_within`, `share_zero_whole`, `Witness.le_not_transitive`, `Witness.positive_part_zero_whole`.
3. **Bayes's rule** in counting form. Declaration: `restrict_two_ways`.
4. **The generative model.** The pair weight factors; `evidence`; the posterior share; hypotheses compared as prior weights times likelihood weights; a prior weight being the prior share only under one likelihood total; a record turning the order. Declarations: `pairWeight`, `mass_pairs`, `mass_pairWeight`, `evidence`, `posterior_single`, `posterior_le_iff`, `posterior_le_iff_single`, `prior_share`, `mass_absent`, `mass_single`, `Witness.likUneven`, `Witness.prior_not_share`, `Witness.prior`, `Witness.lik`, `Witness.record_reverses`.
5. **Independence.** Products of masses and shares, a joint share at most either share, a record of one part leaving the other's share, and conjunctions of step events over courses of independent steps. Declarations: `mass_scaled_event`, `mass_product`, `share_product`, `share_product_le`, `share_product_le_right`, `mass_first`, `restrict_independent`, `independentWeight`, `meetsEach`, `mass_meetsEach`, `whole_courses`, `foldr_whole`, `foldr_part`, `share_meetsEach`.

Helpers to list in references: the entry lemmas, and `mass_eq_sum`, `mass_congr_mem`, `mass_congr`, `mass_le_of_entries`, `mass_none`, `mass_append`, `mass_map`, `mass_joinMap`, `mass_mul_left`, `mass_mul_right`, `whole_of_entries`, `mass_eq_total`, `mass_and_comm`, `mass_and_true`.

Other fields:

- **Conditions.** Natural weightings, Boolean records, listed domains.
- **Does not show.** Possibility and signed counts: for possibility, restriction is conditioning without shares, and signed counts cancel. Graded evidence beyond the generative model. Averages of logarithms (entropy, free energy).
- **Correspondence** [AI reading]. Bayes's theorem; the posterior and marginal likelihood under the premise of one likelihood total; pointwise surprisal through the reciprocal share.
- **Dependencies.**
  - `fulfillment-chance-floor` (formal reuse: `mass`, `mass_mono`, `IncludedOn`; re-check N3);
  - `sum-over-histories-exact` (formal reuse: `counting`, `openSteps`, `courses`, `joinMap`, `Weights.along`, and `Weights.sum_congr`, `sum_append`, `sum_map`, `sum_joinMap` and `mul_sum` through `mass_eq_sum`).
- **Related:** `weights-count-situations` (shares read as numbers of situations, a reading).
- **Next.** `restrict` stated once for every `Weights`, with `support` commuting with it (review finding 4).

**(b) The exit from a margin** (proposed id `exit-from-a-margin`).

Laws:

1. **The deviation bound at the horizon.** Declarations: `deviates`, `deviates_offBy`, `whole_typical`, `deviates_bound`.
2. **Reaching the need within the horizon.** The bound is the spread over the margin squared, as a share and as its reciprocal. A break is reaching the need from m + 1, so its bound is n·p·q/(m + 1)². A course can fall and recover. Declarations: `fallsTo`, `fallsTo_succ`, `fallsWithin`, `fallsWithin_of_end`, `fallsWithin_reachesBy`, `fallsWithin_entry`, `fallsWithin_bound`, `fallsTo_bound`, `fallsWithin_share`, `fallsWithin_reciprocal`, `Witness.within_exceeds_end`.
3. **What a record of the course so far says.** The courses factor at a record; given a record showing m', the share is the share from m', at most n·p·q/m'². Declarations: `courses_add`, `mass_record`, `margin_shift`, `fallsTo_append`, `fallsWithin_append`, `record_fallsWithin`, `record_share`, `record_bound`, with helpers `joinMap_congr`, `joinMap_single`, `extend_append`, `extend_joinMap`, `extend_map_append`, `drop_append_length`, `weight_append`, `ones_append`, `zeros_append`.

Other fields:

- **Conditions.** Two values, natural weights p and q, one level raised q by a one and lowered p by a zero, independent steps. The record's hypothesis is asked of lists of length k only.
- **Does not show.**
  - A level whose rises and falls do not balance, more than two values, dependent steps.
  - Exponential bounds within the horizon.
  - That the bound says anything where m·m ≤ n·p·q.
  - T6's invisible half.
- **Correspondence** [AI reading]. The case the free-energy principle's reading of persisting is measured against, in the review's words. The seen half of T6, with the weighting as its independently warranted model. No third part.
- **Dependencies.**
  - `typicality-by-counting` (formal reuse: `typical`, `typical_throughout`, `margin_square`, `offBy`, `offByWithin`, `reachesBy`, the total lemmas, `mem_courses_iff`);
  - `fulfillment-chance-floor` (formal reuse: `mass`, `mass_mono`);
  - `conditioning-by-restriction` (formal reuse: `restrict`, `share`, `Share`, the mass helpers).
- **Related, not dependencies** (re-check N3; nothing of (b) uses them as an inference edge):
  - `drift-offspring-sampled` (the binomial means, from which the level's balance is arithmetic);
  - `margin-of-a-regime` (the margin vocabulary; the regime's point of no return is a different distance).

A single record is also possible; two keep the near-definitional identities apart from the bounds.

### The four records that bind Typicality

Each refers to `Typicality.lean` at sha256 `904976890149…` and binds a core receipt, so each shows source drift and an invalid binding once Typicality changes. The kit's audit confirms that none of the last three cites `offBy_le`.

| Record | What it needs |
|---|---|
| [typicality-by-counting](../../../../../../theories/becoming/results/records/typicality-by-counting.json) | A **history note**, since its claim gains a law:<br>- the bound at every step (`typical_throughout`) added, in law 3 or as a new law, with its declarations: `pairSquare`, `pairCross`, `stopStep`, `stopped`, `reachesBy`, `reachesBy_of_end`, `stopped_spec`, `moving`, `moving_le`, `stepCross`, `stopped_go`, `stopped_square_step`, `stopped_cross_step`, `stopped_spread`, `offByWithin`, `offByWithin_le`, `typical_throughout`, `offBy_le_within`;<br>- `regroup_square`, `square_gap` and `margin_square` joining law 3's arithmetic beside `two_mul_le_of_le` and `two_mul_le`;<br>- `offBy_le` removed from law 3, `references` and `aliases`.<br>The validation scope gets the new receipt and counts (52 theorems in 72 declarations; it now cites the 15 October receipt's 56 and 43, while the current receipt has 40 in 52). The statement can add that the deviation stays within the bound at every step. `update_typicality_record_ue2.py` writes all of this and rebinds Typicality.lean to the new receipt, so the record needs no separate re-point. |
| [weights-count-situations](../../../../../../theories/becoming/results/records/weights-count-situations.json) | Re-point only (it cites `offBy`, `typical` and others, all kept). |
| [drift-offspring-sampled](../../../../../../theories/becoming/results/records/drift-offspring-sampled.json) | Re-point only (`spread`, `two_mul_le`, `total_extend`, `total_weight`, `weight`, `courses`). |
| [fixation-by-drift](../../../../../../theories/becoming/results/records/fixation-by-drift.json) | Re-point only (`total_congr_mem`, `total_extend`, `total_weight`, `weight`, `courses`). |

The three re-points change nothing a record says, so they are bookkeeping. A fourth joins them. capture-by-counted-choices takes 03 as a statement but cites no part of it and is not linked from it, so the registry counts every rewritten line of 03 against it; `texts_ue2.py` rewrites the Typicality paragraph of 03 §6 (§3), which says nothing the record states. The other text edits only add lines, and a check of every record's references against the edits, simulated in memory, finds no other record put out of date. The command, with its reason, is in `study_ue2.txt`: `tools/research/repoint.py --reason … --ids weights-count-situations drift-offspring-sampled fixation-by-drift capture-by-counted-choices --paths <Typicality.lean> theories/becoming/chapters/03-KNOWING.md --receipt <new core receipt>/verification.json --lean <Typicality.lean>`, dry run first, then `--apply`. That logs one line of `_process/architecture/rebinds.jsonl`.

## 3. Home sections and chapter text

- **03 §6, `r-typicality-by-counting`**: add the bound at every step, with `Typicality.typical_throughout` in the Lean list. The counts stay near their means throughout, and the frequencies show the weights at the horizon.
- **Record (a)'s home**: 03, beside `r-typicality-by-counting`, since it is inference on the counting layer. Give it a labelled reading: Bayes's rule, near-definitional, under the premise of one likelihood total. A one-line pointer can go in 01's table row for `r-weights-count-situations`.
- **Record (b)'s home**: 02 §5 (draw and margin), after the margin of a regime, with the break at m + 1 and the contrast with the point of no return. Add a pointer in 03 §10 for T6's seen half, with the weighting as the warranted model.
- **08 §8, "Known results beyond the table"**:
  - Bayes's theorem in counting form (near-definitional);
  - Kolmogorov's maximal inequality (1928), restated in counting form;
  - Gibbs' inequality, only once the periphery module has a receipt (§4).
- **08 §1**: the core receipt and its counts.
- **UE1's premise card.** [`ue1-fep-bridge/NOTE-CORRECTIONS.md`](../ue1-fep-bridge/NOTE-CORRECTIONS.md) §1 already states what UE2 delivers: belief and pointwise surprisal in counting form, free energy only in the periphery. Check it against the landed wording. Do not edit UE1's NOTE.md §3, which the record capture-by-counted-choices cites.
- **The UE plan** (§4 item 3 and §3): UE2 pays belief and pointwise surprisal, not free energy, and adds no third part.

## 4. The periphery module

[`periphery/ConditionalWeightsReals.lean`](../../../history/root-foundation/development/ue2-conditional-weights/periphery/ConditionalWeightsReals.lean) compiles against the pinned Mathlib with the three standard axioms ([log](../../../history/root-foundation/development/ue2-conditional-weights/periphery/periphery.log)). A compile by hand is not a receipt, so the module needs a checker to land: every periphery module in the repository has one.

- **Where.** A folder `lean/conditional-weights-reals/` beside `regime/` and `representation/`, holding `ConditionalWeightsReals.lean`, `check_conditional_weights_reals.py`, a receipt `conditional-weights-reals-verification.json` and run folders `conditional-weights-reals-checks/<utc>/`.
- **Template.** `regime/check_regime_reals.py`, since RegimeReals imports `Becoming.RegimeMargin` as this module would import `Becoming.ConditionalWeights` once it states the join:
  - Lean 4.30.0-rc2 against the Mathlib in `periphery-mathlib-pin` (`SYSTEMS_MATHLIB_PROJECT`, revision `ea11ccc0…`);
  - the imported core module's closure compiled with the same toolchain, every other closure module matching a passed core receipt (`inherited_receipts`);
  - each declaration's axioms reported, any axiom beyond `propext`, `Classical.choice` and `Quot.sound` failing the run;
  - steps reused, keyed also by the Mathlib revision.
- **Two ways to land it.**
  - **As it is**, importing only Mathlib: the checker is simpler, and the record of (a) or (b) gains a periphery law. The join to the core stays a stated correspondence.
  - **With the join**: the module imports `Becoming.ConditionalWeights` and adds the review's target theorem (finding 17): the surprisal of a generative model's record share is at most the free energy of any q supported where the record has weight, with equality exactly at `posterior_single`'s share. Its ingredients:
    - a cast lemma `(mass l w e : ℝ) = (l.map fun x => if e x = true then (w x : ℝ) else 0).sum`;
    - `evidence`;
    - a sum over a list without repeats as a sum over its finset;
    - `neg_log_sum_le`, and for the equality `neg_log_sum_eq_iff` with `posterior_single`.

  The second is what makes "free energy at least surprisal" a law about the core's shares.
- **Its record.** It binds the periphery receipt through `proof_bindings` at `/source_sha256/ConditionalWeightsReals` (or the module's name as the checker reports it). Until it has a receipt, nothing claims Gibbs' inequality as checked: not 08 §8, not any record.

## 5. Registration and checks

- `regions.json`: regions for the new records (03 for (a), 02 for (b)).
- Connectivity: register the new leaf's apart roots, each with a category and a reason, as UE1's landing did, then write connectivity.
- The study: a new section in `BECOMING-RENEWAL-READING.md` (the next free number; §409 exists at this writing).
- The board: UE2's row to history. It states the leaf reason, the Typicality decision (§0) and `whole_courses` landing above `Typicality.transfer_weight` until Weighted's owner decides (NOTE §2).
- Generated pages: `make research-render`, then `research-check`, `research-links` and `research-test`.

## 6. Optional, for other owners

- **Drift's owner:**
  - `Drift.far_back`'s identity can come from `Typicality.square_gap`;
  - `Drift.falls_back` can be read from `typical` at a scaled margin;
  - the binomial mean can move down into Typicality, with `expected_ones` and `expected_zeros` derived from it.
- **Weighted's owner:** `whole_courses` and `mass_meetsEach` (with `independentWeight`, `meetsEach` and the mass helpers) can move down into `Becoming.Weighted`, with `Typicality.transfer_weight` derived from them.
- **A later consolidation:** the transitivity of the cross-multiplication order, stated once in `Becoming.Prelude` for `RuleCapture.CarrierCounts.order` and `ConditionalWeights.Share.le_trans`.

## 7. The scripts, in order

The lander runs them from the checkout root of a clean worktree at the then-current main, after UE4's landing. Every edit asserts that it applies exactly once, so a script stops rather than writing where an anchor has moved; a script that stops keeps the edits it made before, so restore the worktree before running it again.

1. `python3 -B <kit>/integrate_ue2.py`: copies ConditionalWeights; replaces Typicality.lean only after asserting the landed file is still at `904976890149…`; the root import and bullets, the checker's core list and scope, the README rows (EN, ZH).
2. The core checker (`check_becoming.py`), giving the core receipt RECEIPT; N is the next free study section.
3. `python3 -B <kit>/texts_ue2.py RECEIPT N`: in 03 §6, Typicality's home section (`r-typicality-by-counting`) gains the bound at every step, and record (a)'s home goes beside it, before `r-the-split-that-makes-sense`; in 02 §5, record (b)'s home goes after the margin of a regime, before `r-threshold-in-the-state-plane`; in 03 §10, the pointer for T6's seen half goes before `does-not-show`; in 08 §8, two bullets go after the bullet beginning "A rule read from the count of its choices", and 08's receipt and counts are read from the receipt; the study section (`study_ue2.txt`) and the regions.
4. `python3 -B <kit>/make_records_ue2.py RECEIPT N`: records (a) and (b), each citing exactly its declarations, together all 110 of ConditionalWeights.
5. `python3 -B <kit>/update_typicality_record_ue2.py RECEIPT N`: typicality-by-counting, with its history note.
6. The re-point of the other three Typicality records and capture-by-counted-choices, with the command in `study_ue2.txt`: dry run first, then `--apply`.
7. Connectivity, then `python3 -B <kit>/register_ue2.py CONNECTIVITY_LOG`, then connectivity written.
8. `python3 -B <kit>/board_ue2.py land UE2 RECEIPT N QUEUE_TEXT STATE_TEXT` (a copy of UE1's board script, except the date).
9. `make research-render`, then `research-check`, `research-links` and `research-test`.

The history notes the record scripts write, in (a), (b) and typicality-by-counting, and the board's latest receipt are dated by the receipt's own day in local time, as the repository dates them, so a landing after midnight needs no edit. `texts_ue2.py` checks the receipt, the study section and the regions before it writes anything.

**Checked here, without running the scripts**, by [`check_ue2_landing.py`](check_ue2_landing.py), which writes nothing; the lander can run it from the worktree's root before step 1 to recheck the anchors on the main after UE4's landing (its record part needs the kit's ignored build files, and is skipped without them).

- All six compile (`py_compile`).
- Their 16 anchors, applied in order in memory, each occur exactly once on the current main and again after UE4's integrate and texts edits are applied first.
- `make_records_ue2.records()`, called in memory on the kit build's audited names, puts 78 declarations in (a) and 32 in (b), disjoint and together all 110; every name is declared in the source.
- Both records pass the repository's schema-2 field checks and `style.lint` with no finding, with a placeholder receipt and hashes. So does typicality-by-counting after `update_typicality_record_ue2.py`'s edits, applied in memory to a copy. Their aliases clash with no other record's.

