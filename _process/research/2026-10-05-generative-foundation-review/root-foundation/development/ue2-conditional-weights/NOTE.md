# UE2: conditional weights and surprisal on the counting layer (note)

25 October 2026. AI-authored note for board item UE2 of [UE, a unified explanation of reality](../ue-unified-explanation/PLAN.md) (§4 item 3). Revised the same day after the independent review [REVIEW-UE2.md](REVIEW-UE2.md): all 19 findings taken, listed in §7 with what changed. What UE2 pays of the free-energy principle's debt in [UE1's premise card](../ue1-fep-bridge/NOTE.md#3-its-premises-on-the-premise-card) is belief (the posterior share) and pointwise surprisal (through the reciprocal share) in counting form. Free energy and its bound are stated only in the periphery, over the reals. Nothing here is landed; [LANDING.md](LANDING.md) lists what the landing needs. Results go to their records and home sections when they land, not here.

Files:

- [`tree/Becoming/ConditionalWeights.lean`](tree/Becoming/ConditionalWeights.lean): the new pure-core module (imports `Becoming.Typicality`).
- [`tree/Becoming/Typicality.lean`](tree/Becoming/Typicality.lean): the change to the landed module under board rule 9 (§2).
- [`periphery/ConditionalWeightsReals.lean`](periphery/ConditionalWeightsReals.lean): the periphery draft, Gibbs' inequality with Mathlib (§3). It replaces `periphery/VariationalBound.lean`, whose bytes stay in history at `4c1639402`.
- [`scratch.log`](scratch.log) and [`periphery/periphery.log`](periphery/periphery.log): the builds.
- The landing scripts, modelled on UE1's landed kit and listed in order in [LANDING.md](LANDING.md) §7: [`integrate_ue2.py`](integrate_ue2.py), [`texts_ue2.py`](texts_ue2.py), [`make_records_ue2.py`](make_records_ue2.py), [`update_typicality_record_ue2.py`](update_typicality_record_ue2.py), [`register_ue2.py`](register_ue2.py), [`board_ue2.py`](board_ue2.py) and the study section [`study_ue2.txt`](study_ue2.txt). None has been run here beyond a parse check.

## 1. What is proved

Scratch build ([log](scratch.log)), with the six core modules downstream of Typicality built against the changed Typicality:

- `Becoming.ConditionalWeights`: 93 theorems in 110 declarations;
- `Becoming.Typicality`: 52 theorems in 72 declarations (40 in 52 landed);
- TypicalRuns, Situations, Drift, FinerTraces, SituationTraces and HistorySums: counts unchanged.

Nothing is unclean and every axiom report is empty.

All statements are on `mass` of `Becoming.Weighted` (a listed domain, a natural weighting, a Boolean event) and on Typicality's courses; no division, real number or logarithm. The scope is natural weightings: for possibility, restriction is conditioning without shares, and signed counts cancel, so a restricted signed weighting has no share.

**Conditional weights** (near-definitional: identities of counting):

- `restrict r w`: the weighting restricted to a record; a course agreeing with `r` keeps its weight, any other weighs nothing.
- `mass_restrict`: under `restrict r w`, an event weighs what the courses meeting the event and `r` weigh. Restriction is conditioning; the proof unfolds the definition.
- `whole_restrict`: the whole of `restrict r w` is the weight of the courses agreeing with `r`.
- `mass_split`: an event weighs its courses agreeing with `r` plus those disagreeing (the law of total weight).
- `restrict_le`, `mass_restrict_le`: a record raises no weight and no mass.
- `restrict_restrict`, `restrict_comm`: two records in turn are their conjunction, in either order (case splits on two Booleans).

**Shares and Bayes's rule** (near-definitional: identities of counting):

- `Share` (part, whole), `Share.le` and `Share.Same` by cross-multiplication, `Share.mul` (parts and wholes multiply), `Share.reciprocal` (whole over part). By the definitions, the reciprocal of a product is the product of the reciprocals. `share l w e` = ⟨mass of `e`, whole mass⟩.
- `Share.le_refl`, `Share.le_trans`: a preorder on shares with a positive whole.
- `Share.zero_whole`: ⟨0, 0⟩ is at most and at least every share and the same ratio as any. `share_zero_whole`: an event's share with a zero whole is ⟨0, 0⟩. `Witness.le_not_transitive`: through ⟨0, 0⟩ the order is not transitive. So the laws given a record say nothing where the record weighs nothing. Only ⟨0, 0⟩ compares either way: `Witness.positive_part_zero_whole` shows ⟨1, 0⟩ above ⟨0, 1⟩ and not below it, and the reciprocal of an event no course meets is such a share.
- `share_le_of_included`: a wider event has no smaller share (from `mass_mono`). `share_within`: part ≤ whole.
- `restrict_two_ways`: share(h given r) × share(r) and share(r given h) × share(h) are the same ratio (Bayes's theorem; both count the courses meeting h and r). Where record and hypothesis weigh something it says what Bayes's theorem says; otherwise one side is degenerate.
- Generative model, courses `openSteps hs os`, weight `pairWeight prior lik (h, o) = prior h · lik h o`:
  - `mass_pairs` (general; the second weight may depend on the first) and `mass_pairWeight`: the pair weight factors as Σ over hypotheses meeting `hyp` of prior weight × record weight.
  - `evidence`: the courses agreeing with a record weigh Σₕ prior h · (record weight under h); this weight's share of the whole is the marginal likelihood.
  - `posterior_single`: a hypothesis listed once has, given the record, the share ⟨prior h₀ · lik-mass h₀, evidence⟩.
  - `posterior_le_iff`, `posterior_le_iff_single`: with positive evidence, two hypotheses (or classes) compare after the record exactly as prior weights times likelihood weights.
  - `prior_share`: where every listed hypothesis's likelihood weights have one total `L`, a hypothesis's share before any record is ⟨prior h₀ · L, (Σ prior) · L⟩. In general a hypothesis's share is its prior weight times its own likelihood total, over the whole (`mass_pairWeight`), so a prior weight is not the prior share where the totals differ (`Witness.prior_not_share`: equal prior weights, totals 1 and 3, shares 1 and 3).
  - `Witness.record_reverses`: weights 15 against 5 before the record become 3 against 5 after it (likelihood totals 5 and 5).

**Shares under independence and surprise:**

- `Share.le_iff_reciprocal`: a ≤ b exactly where reciprocal b ≤ reciprocal a (less share, more surprise; commutativity of multiplication, near-definitional).
- `Share.mul_le_mul`: taking shares together keeps their order. `Share.mul_le_left`: a share times one within its whole is at most the first.
- `mass_product`, `share_product`: over pairs with product weights, two independent events weigh the product of their masses and take the product of their shares (equal as pairs).
- `share_product_le`, `share_product_le_right`: both are at least as surprising as either.
- `restrict_independent`: a record of one independent part leaves the share of an event of the other the same ratio.
- `independentWeight w s`: `counting.along` with a step weight that reads only the step; `meetsEach es`: one event at each step.
- `mass_meetsEach`, `whole_courses`, `share_meetsEach`: over Weighted's `courses moves all n`, the share of a conjunction of step events is the product of the step shares (equal as pairs).

**The exit from a margin** (Typicality's courses, weights `p` and `q`, a level `m` above a need, raised `q` by a one and lowered `p` by a zero; its weighted rises and falls are equal, so no mean change wears the margin down, by arithmetic from Drift's binomial means `expected_ones` and `expected_zeros`, not a theorem of this module):

- `deviates_bound`: the deviation bound at the horizon. The courses whose deviation at the horizon reaches `m` either way weigh, times m·m, at most n·p·q·(p + q)ⁿ (from `Typicality.typical`).
- `fallsTo`, `fallsWithin`: the level reaches the need or falls below it, at the horizon or at some step.
- `fallsTo_succ`: a break, the level below the need, is reaching it from m + 1.
- `fallsWithin_bound`: the courses in which the level reaches the need at some step, the start included, weigh, times m·m, at most n·p·q·(p + q)ⁿ (from `Typicality.typical_throughout`). With m + 1, breaks within the horizon take at most n·p·q/(m + 1)².
- `fallsTo_bound`: those ending at the need or below it, the corollary at the horizon.
- `fallsWithin_share`: their share is at most ⟨n·p·q, m·m⟩. `fallsWithin_reciprocal`: the reciprocal of their share is at least m·m over n·p·q.
- `Witness.within_exceeds_end`: over two steps with p = q = 1 and m = 1, two courses reach the need within the horizon and one ends below it, so a course can fall and recover.

**What a record of the course so far says of the exit:**

- `courses_add`: the courses of k + n steps are, for each course of the k earliest steps, the courses of the n later steps followed by it.
- `mass_record`: for a record R of the earliest k steps, and an event carried, on every course of k steps agreeing with R, to an event F of the later steps, the courses agreeing with R and meeting the event weigh mass(R) × mass(F).
- `margin_shift`, `fallsTo_append`, `fallsWithin_append`: after a record leaving the level m' above the need, reaching it from m is reaching it in the record or reaching it from m'.
- `record_fallsWithin`: suppose every course of k steps agreeing with the record leaves the level m' above the need without having reached it. Then the agreeing courses that reach the need within the horizon weigh mass(R) × (the courses of the n steps left reaching it from m').
- `record_share`: given the record, their share is the unconditional share from m' (the same ratio).
- `record_bound`: given the record, that share is at most ⟨n·p·q, m'·m'⟩.

Helpers:

- Entry lemmas: `entry_and`, `entry_swap`, `entry_split`, `entry_test_le`, `entry_mul_left`, `entry_and_true`, `entry_and_comm`, `entry_restrict_le`.
- Derived from Weighted's sum laws through the bridge `mass_eq_sum` (a mass is the sum of counting over its entries), so not restated: `mass_congr_mem` (from `Weights.sum_congr`), `mass_append`, `mass_map`, `mass_joinMap` and `mass_mul_left` (from `Weights.sum_append`, `sum_map`, `sum_joinMap` and `mul_sum`). `mass_congr` and `mass_mul_right` follow from them.
- Others: `mass_le_of_entries`, `mass_none`, `whole_of_entries`, `mass_eq_total` (the bridge to Prelude's `total` for Typicality), `mass_and_comm`, `mass_and_true`, `mass_scaled_event`, `mass_first`, `mass_absent`, `mass_single`, `foldr_whole`, `foldr_part`, `deviates_offBy`, `whole_typical`, `fallsWithin_of_end`, `fallsWithin_reachesBy`, `fallsWithin_entry`, `joinMap_congr`, `joinMap_single`, `extend_append`, `extend_joinMap`, `extend_map_append`, `drop_append_length`, `weight_append`, `ones_append`, `zeros_append`.

## 2. Board rule 9

### The change to Typicality

The exit within a horizon needs Kolmogorov's maximal inequality, not Chebyshev's: a continuation ends at the first step its level falls past the need, so the courses that fall and recover by the horizon must count (`Witness.within_exceeds_end`). The maximal law strictly generalizes `Typicality.typical`, since the last step is one step. It uses only Typicality's own courses, weights and step identities, so it goes into Typicality and `typical` becomes its corollary. The kit's [Typicality](tree/Becoming/Typicality.lean) is the landed file (sha256 `904976890149…`) with:

- **the section "The deviation at every step"** before `typical`:
  - definitions: `pairSquare`, `pairCross`, `stopStep`, `stopped`, `reachesBy`, `moving`, `stepCross`, `offByWithin`;
  - theorems: `reachesBy_of_end`, `stopped_spec`, `moving_le`, `stopped_go`, `stopped_square_step`, `stopped_cross_step`, `stopped_spread`, `offByWithin_le`, `typical_throughout`, `offBy_le_within`.
- **`typical`**, its statement unchanged, now two lines from `typical_throughout` and `offBy_le_within`.
- **The review's three amendments:**
  - `offBy_le`, the remains of the direct proof, deleted;
  - the bullet retitled "The deviation stays within the bound at every step", with its frequency reading: the counts stay near their means throughout, while the frequencies show the weights at the horizon;
  - `regroup_square`, `square_gap` and `margin_square` moved in from ConditionalWeights, with `two_mul_le_of_le` derived from `margin_square` at margin zero (statement unchanged).
- A docstring bullet and a classical-source sentence for the new law.

Typicality's owner (the session that landed P116) is inactive and no definition changes, so the lander decides to land the change below `typical`, as rule 9 asks ([LANDING.md](LANDING.md)).

### What ConditionalWeights lands beside

- **The binomial mean.** The kit's `rises_balance_falls` and its two step lemmas restated Drift's `expected_ones` and `expected_zeros`. They are dropped, and `fallsTo`'s docstring cites Drift.
- **The margin square.** It is now in Typicality, below `two_mul_le_of_le`. `Drift.far_back` is its scaled form; Drift's owner can take `far_back`'s identity from `square_gap` (LANDING.md, optional).
- **The total weight.** `whole_courses` generalizes `Typicality.transfer_weight`, the two-valued case through `Weights.sum_courses`, and lands above it. Moving it down means moving `whole_courses` and `mass_meetsEach`, with `independentWeight`, `meetsEach` and the mass helpers they use, into `Becoming.Weighted`, on which 33 of the 306 core modules at the current receipt depend. That is Weighted's owner's decision, and it is the reason the law stays in this leaf. Until it is made, `transfer_weight` keeps its direct proof and the board row says so.
- **The share order.** `Share.le_trans` repeats the transitivity calc of `RuleCapture.CarrierCounts.order`, the same cross-multiplication order on a structure with a positive second count. RuleCapture lies outside ConditionalWeights' closure. Stating that transitivity once, as a lemma on naturals in `Becoming.Prelude`, would let both use it; that consolidation is left for a later pass.
- **The mass helpers.** They are now derived from Weighted's sum laws (§1, helpers). `total_append` and `total_map`, stated in `Becoming.Flow`, are the same laws for Prelude's `total`.

**The leaf reason.** `Becoming.ConditionalWeights` is imported by nothing. Its conditioning, share, independence and record laws are new statements on `mass`. Its exit laws read Typicality's two bounds at a margin. `whole_courses` is the one law that lands above a landed case of it, for the reason given above.

## 3. The periphery draft

[`periphery/ConditionalWeightsReals.lean`](periphery/ConditionalWeightsReals.lean) is named after the core module it instantiates, as `regime/RegimeReals.lean` is after `Becoming.RegimeMargin`. Its declarations sit in the namespace `Becoming.ConditionalWeights` and take structural names; the free-energy names stay in its docstring as the correspondence. Over Mathlib's reals, for a finite set of causes, it states:

- `term_le`: the termwise bound, from log x ≤ x − 1, where q is zero wherever p is. `term_eq_iff`: with p positive, equality exactly at q = p/P.
- `neg_log_sum_le`: for q ≥ 0 with Σ q = 1, and p ≥ 0 with q zero wherever p is, −log Σ p ≤ Σ q (log q − log p) (Gibbs' inequality). A record can weigh nothing under a hypothesis, so a joint weight can be zero; this support form is the main theorem.
- `neg_log_sum_le_of_pos`: the same with p positive, derived from it.
- `nonempty_of_total`: a set carrying a total of one is not empty, so no theorem needs a nonempty hypothesis beside Σ q = 1.
- `neg_log_sum_eq_iff`: with p positive, equality exactly where q = p / Σ p, so minimizing over q recovers the posterior. `neg_log_sum_at_posterior`: equality there, derived from it.
- `log_reciprocal_share_le`: with natural weights w over a positive total Z, and q zero wherever w is, −log((Σ w)/Z), the logarithm of the reciprocal of the share ⟨Σ w, Z⟩, is at most Σ q (log q − log(w/Z)).

It compiles with no error or warning against the pinned Mathlib (`lake env lean` in `~/repos/生生不息`, Lean 4.30.0-rc2, Mathlib `ea11ccc0…`, pin hashes as in `lean/periphery-mathlib-pin/README.md`). Each theorem depends on `propext`, `Classical.choice` and `Quot.sound`, as the periphery allows ([log](periphery/periphery.log)). It has no checker or receipt, and it does not import the core. LANDING.md says what landing it needs, including the target theorem joining it to `share` and `posterior_single`.

## 4. Correspondences [AI reading]

1. **Bayes's rule** (near-definitional). A share read as a probability is a number of situations of a kind (`Becoming.Situations`, record weights-count-situations).
   - `restrict` is conditioning, and `mass_restrict` says conditioning is restriction.
   - `restrict_two_ways` is P(h|o)P(o) = P(o|h)P(h). `evidence`'s share of the whole is the marginal likelihood, and `posterior_single` gives the posterior.
   - This reads `prior h` as P(h) and the record's weight under `h` as P(o | h). That holds where every listed hypothesis's likelihood weights have one total (`prior_share`). Otherwise P(h) is `prior h · Σₒ lik h o` over the whole, and `evidence` over the whole is the marginal likelihood.
   - `restrict_comm` says evidence taken in either order gives one posterior.
2. **Surprisal.** Surprisal is log(1/P). The core takes no logarithm, but the reciprocal share orders as pointwise surprisal does (`Share.le_iff_reciprocal`), and its products are surprisal's sums. So the reciprocal share is a counting form of pointwise surprisal, not of its averages. An average of logarithms is not the logarithm of an average, so entropy and free energy have no reciprocal-share form. Free energy and its bound are stated only in the periphery, over the reals (§3).
3. **The principle's bound.** The free-energy principle bounds the surprisal of a system's states by variational free energy, and reads persisting as keeping that surprisal low. The exit bound is the case that reading is measured against:
   - A balanced level that nothing reads leaves a margin m within n steps on at most n·p·q over m·m of the weight. So leaving has surprisal at least log(m·m/(n·p·q)) where m·m exceeds n·p·q.
   - The bound is void from n = m·m/(p·q), and such a level leaves every margin in time (a balanced walk recurs; not proved here). Persisting longer needs a giving that reads the level.
   - The bound reads the weighting, the counting form of a generative density, only through its spread. No belief (recognition density) enters, as one does in free energy.
4. **The margin vocabulary** ([02 §5](../../../../../../theories/becoming/chapters/02-MAP.md#margin)). The margin there is how far levels stand above needs.
   - `fallsWithin` is the level reaching the need or falling below it. Standing at the need is not a break, since the core counts a formation supported where its need is within the level.
   - A break, the level below the need, is reaching it from m + 1, so `fallsWithin_bound p q (m + 1) n` bounds it by n·p·q/(m + 1)².
   - This is not the regime's point of no return: no giving law reads the level here, and the level only fluctuates.
5. **A break seen coming** ([03 §10, T6](../../../../../../theories/becoming/chapters/03-KNOWING.md#break-seen-coming)). `record_share` and `record_bound` are T6's seen half in counting form.
   - Where a record holds the level and the need, the conditional share of reaching the need within the horizon reads off the margin the record shows, the steps it leaves, and the spread of the weighting, which the record does not show.
   - The weighting is the independently warranted model T6 allows. Given it, nothing else in the record matters, the steps being independent.
   - T6's invisible half, that a record not holding the level bounds nothing, is not stated here.

**The third part.** UE2 adds no third part to UE1's containment: the margin law constrains the weighting, which the principle takes as given, and quantifies over no agent's model.

## 5. What is not derived

- Which weighting an actual unfolding has, or that the course which happens is typical (as in Typicality).
- In the core: real weights, densities, surprisal as a number, entropy and free energy. In the periphery draft causes are finite, and q must be zero wherever the joint weight is.
- Conditioning beyond natural weightings: for possibility, restriction is conditioning without shares; signed counts cancel, so a restricted signed weighting has no share.
- Graded evidence on a general domain: records are Boolean. A likelihood weighting multiplying a prior appears only as the generative model's `pairWeight`.
- Exits for a level whose rises and falls do not balance (renewal unequal to the draw), more than two values, or steps that are not independent. A mean change moves the margin linearly in the steps and is not treated.
- Exponential exit bounds. One on ending fallen follows from `Typicality.concentrated`. One on reaching the need within the horizon needs its maximal form, stopping the tilted weights as `typical_throughout` stops the square; it is not proved.
- The surprisal reading of the exit bound says something only where m·m exceeds n·p·q.
- Sequential conditioning on records of Weighted's general courses: the record law is stated for Typicality's two-valued courses only.
- The representation commits to discrete steps and natural weights. No ethical predicate, ranking or axiom occurs.

## 6. What remains

1. **Landing**, as listed in [LANDING.md](LANDING.md).
2. **Periphery.** A checker and receipt for `ConditionalWeightsReals`, and the instance theorem joining it to the core's `share` and `posterior_single` (LANDING.md).
3. **Owner decisions under rule 9** (§2):
   - where `whole_courses` and `mass_meetsEach` land (Weighted's owner);
   - `Drift.far_back` from `square_gap` (Drift's owner);
   - the share order's transitivity stated once in Prelude.
4. **Extensions:**
   - The one-sided (Cantelli) form of Kolmogorov's inequality (review finding 11). The courses reaching the need within the horizon weigh, times n·p·q + m·m, at most n·p·q·(p + q)ⁿ. This is never above one and always below n·p·q/m². Its proof is `typical_throughout`'s stopping argument, with two changes: it stops at the first fall, and it bounds the stopped square of y − x + c, with c = n·p·q/m scaled to whole numbers, using a stopped form of the balanced mean.
   - A level whose rises and falls do not balance, with renewal against the draw.
   - The exponential exit within the horizon.
   - Graded records on general domains.
   - `restrict` once for every `Weights`, with `support` commuting with it, so that `Learning`'s elimination reads as a case of conditioning (finding 4, optional).
   - Records of Weighted's general courses through `Weights.along_append` (`Becoming.HistorySums`).
   - T6's invisible half in counting form.

## 7. The review's findings and what was done

| # | Finding | What was done |
|---|---|---|
| 1 | The exit bound read as the principle's persisting, and the candidate third part (overclaim) | The module's Correspondence and §4.3 rewritten in the review's words: the case that reading is measured against, void from n = m·m/(p·q), no recognition density. The candidate third part replaced by "UE2 adds no third part" (§4). |
| 2 | Near-definitional laws; free energy without a counting form (overclaim) | Conditioning, Bayes's rule and the order of surprise labelled near-definitional (identities of counting) in the docstrings and here. `joint_eq_record_times_given` and `Share.reciprocal_mul` dropped as theorems and kept as remarks. Averages of logarithms have no reciprocal-share form; free energy only in the periphery (module docstring, §4.2). UE1's premise card already carries the correction (`ue1-fep-bridge/NOTE-CORRECTIONS.md` §1); LANDING.md checks it. |
| 3 | "Prior" is the prior share only where the likelihood totals agree | The Correspondence and §4.1 state the premise; `pairWeight`'s docstring says "prior weight"; `prior_share` added, and the review's probe `prior_not_share` as `Witness.prior_not_share`. |
| 4 | Conditioning for natural weightings only | "What a record does to a natural weighting"; possibility and signed counts in "what is not derived". The optional `restrict` for every `Weights` is in §6. |
| 5 | Shares with a zero whole | `Share.zero_whole`, `share_zero_whole` and `Witness.le_not_transitive` added. The docstrings of `restrict_two_ways`, `restrict_independent`, `record_share` and `record_bound` say the laws say nothing where the record weighs nothing. "A preorder on shares with a positive whole." |
| 6 | Three docstring sentences | `share_product_le_right` added, so "as either" holds; "can exceed"; `deviates_bound` is "the deviation bound at the horizon". |
| 7 | "Falls to the need" is not a break | `fallsTo` and `fallsWithin` glossed "reaches the need or falls below it"; "break" replaced in the record docstrings and §4; `fallsTo_succ` added, with the bound n·p·q/(m + 1)² for breaks; the witness "ends below it on one". |
| 8 | The record laws over lists of every length | `carries` and `shows` now ask only lists of length k; `mass_record` takes the review's proof through `mass_congr_mem` over the courses of k steps. |
| 9 | Two scope statements | "where m·m exceeds n·p·q" added; the exponential bound restated (§5). |
| 10 | T6's seen half needs the weighting as its warranted model | The module docstring and §4.5 say so in the review's words. |
| 11 | Sharper exit bounds (suggestion) | Breaks: done with finding 7. The one-sided form recorded as an extension with its proof plan (§6). |
| 12 | Laws beside landed laws, and the leaf reason | The margin lemmas moved into Typicality with `two_mul_le_of_le` derived. The binomial mean dropped in favour of Drift's. The mass helpers derived from Weighted's sum laws. `whole_courses` and `Share.le_trans` listed with their reasons and the leaf reason rewritten (§2). |
| 13 | Names (suggestion) | `given` → `restrict` (with `mass_restrict`, `whole_restrict`, `restrict_le`, `mass_restrict_le`, `restrict_restrict`, `restrict_comm`, `restrict_independent`, `restrict_two_ways`); `entry_le` → `entry_test_le`; `joint` → `pairWeight`, `mass_joint` → `mass_pairWeight`; the periphery module renamed `ConditionalWeightsReals` with structural theorem names. |
| 14 | The periphery docstring names a declaration that does not exist (error) | It names `restrict_two_ways`. |
| 15 | "Only there" not proved | `term_eq_iff` and `neg_log_sum_eq_iff` added, from the review's appendix B; `neg_log_sum_at_posterior` now derived from the second. |
| 16 | Positive weights exclude hypotheses a record rules out | The support form `neg_log_sum_le` is the main theorem, proved directly; the positive form is derived from it, and the counting form takes the support hypothesis. The nonempty hypothesis dropped (`nonempty_of_total`). |
| 17 | Checker and join (suggestion) | In LANDING.md, with `regime/check_regime_reals.py` as the template and the join as the target. |
| 18 | The new bullet's title (overclaim) | "The deviation stays within the bound at every step", with the frequency reading; the theorem's docstring and the section title likewise. |
| 19 | The landing list | LANDING.md. |

## 8. The re-check and what was done

The reviewer's re-check of the revision (REVIEW-UE2.md, "Re-check of the revision") found 18 findings addressed, finding 12 partly, and five new issues, none blocking the core.

| # | Issue | What was done |
|---|---|---|
| N1 | Only ⟨0, 0⟩ compares either way with every share; ⟨1, 0⟩ does not | The module docstring, `Share.zero_whole`'s and `share_zero_whole`'s docstrings and LANDING's record (a) say so; `Witness.positive_part_zero_whole` added (the re-check's probe). |
| N2 | Weighted is not imported by "most" of the core | §2 states the number, 33 of the 306 core modules at the current receipt, and gives Weighted's owner's decision as the reason that stands. Finding 12 is then complete. |
| N3 | Record fields | LANDING's records: drift-offspring-sampled and margin-of-a-regime as related, not dependencies; fulfillment-chance-floor as the formal reuse of `mass`, `mass_mono` and `IncludedOn`; §409 noted. The landing scripts follow it. |
| N4 | The core docstring when it lands without the periphery | Free energy and its bound "drafted for the periphery, over the reals, with no receipt yet". |
| N5 | "Drift" in two senses | "no mean change wears the margin down (arithmetic from `Drift.expected_ones` and `Drift.expected_zeros`, not a theorem here)", and "a level whose rises and falls do not balance". |
