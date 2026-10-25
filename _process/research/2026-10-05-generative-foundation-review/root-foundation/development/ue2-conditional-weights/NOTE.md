# UE2: conditional weights and surprisal on the counting layer (note)

25 October 2026. AI-authored note for board item UE2 of [UE, a unified explanation of reality](../ue-unified-explanation/PLAN.md) (§4 item 3), the free-energy principle's main debt in [UE1's premise card](../ue1-fep-bridge/NOTE.md#3-its-premises-on-the-premise-card): the principle states belief, surprisal and a free-energy bound; the core had weights over courses but no conditioning, share or surprisal. Drafted in this kit; nothing here is landed. Results go to their records and home sections when they land, not here.

Files:

- [`tree/Becoming/ConditionalWeights.lean`](tree/Becoming/ConditionalWeights.lean): the new pure-core module (imports `Becoming.Typicality`).
- [`tree/Becoming/Typicality.lean`](tree/Becoming/Typicality.lean): a proposed change to the landed module, under board rule 9 (§2).
- [`periphery/VariationalBound.lean`](periphery/VariationalBound.lean): the optional periphery draft, Gibbs' inequality with Mathlib (§3).
- [`scratch.log`](scratch.log) and [`periphery/periphery.log`](periphery/periphery.log): the builds.

## 1. What is proved

Scratch build ([log](scratch.log)), every step run fresh against the checkout, with the six core modules downstream of Typicality built against the changed Typicality: `Becoming.ConditionalWeights` 109 declarations, 93 theorems; `Becoming.Typicality` 70 declarations, 50 theorems (52 and 40 landed). Nothing unclean; every axiom report empty, also for TypicalRuns, Situations, Drift, FinerTraces, SituationTraces and HistorySums.

All statements are on `mass` of `Becoming.Weighted` (a listed domain, a natural weighting, a Boolean event) and on Typicality's courses; no division, real number or logarithm.

**Conditional weights** (any listed domain of courses):

- `given r w`: the weighting given a record; a course agreeing with `r` keeps its weight, any other weighs nothing.
- `mass_given`: under `given r w`, an event weighs what the courses meeting the event and `r` weigh (conditioning is restriction).
- `whole_given`: the whole of `given r w` is the weight of the courses agreeing with `r`.
- `mass_split`: an event weighs its courses agreeing with `r` plus those disagreeing (the law of total weight).
- `given_le`, `mass_given_le`: a record raises no weight and no mass.
- `given_given`, `given_comm`: two records in turn are their conjunction, in either order.

**Shares and Bayes's rule:**

- `Share` (part, whole), `Share.le` and `Share.Same` by cross-multiplication, `Share.mul` (parts and wholes multiply), `Share.reciprocal` (whole over part); `share l w e` = ⟨mass of `e`, whole mass⟩.
- `Share.le_refl`, `Share.le_trans` (through a positive whole): the share order is a preorder.
- `share_le_of_included`: a wider event has no smaller share (from `mass_mono`). `share_within`: part ≤ whole.
- `joint_two_ways`: share(h given r) × share(r) and share(r given h) × share(h) are the same ratio, with no condition (Bayes's theorem; both count the courses meeting h and r).
- `joint_eq_record_times_given`: mass(h ∧ r) × whole(given r) = mass(r) × mass under given r of h (the brief's cross-multiplied form).
- Generative model, courses `openSteps hs os`, weight `joint prior lik (h, o) = prior h · lik h o`:
  - `mass_pairs` (general, the second weight may depend on the first), `mass_joint`: the joint weight factors as Σ over hypotheses meeting `hyp` of prior × record weight.
  - `evidence`: the courses agreeing with a record weigh Σₕ prior h · (record weight under h).
  - `posterior_single`: a hypothesis listed once has, given the record, the share ⟨prior h₀ · lik-mass h₀, evidence⟩.
  - `posterior_le_iff`, `posterior_le_iff_single`: with positive evidence, two hypotheses (or classes) compare after the record exactly as prior weights times likelihood weights.
  - `Witness.record_reverses`: weights 15 against 5 before the record become 3 against 5 after it.

**Shares under independence and surprise:**

- `Share.le_iff_reciprocal`: a ≤ b exactly where reciprocal b ≤ reciprocal a (less share, more surprise).
- `Share.reciprocal_mul`: the reciprocal of a product is the product of reciprocals (where surprisal adds).
- `Share.mul_le_mul`: taking shares together keeps their order. `Share.mul_le_left`: a share times one within its whole is at most the first.
- `mass_product`, `share_product`: over pairs with product weights, two independent events weigh the product of their masses and take the product of their shares (equal as pairs).
- `share_product_le`: both are at least as surprising as the first.
- `given_independent`: a record of one independent part leaves the share of an event of the other the same ratio.
- `independentWeight w s`: `counting.along` with a step weight that reads only the step; `meetsEach es`: one event at each step.
- `mass_meetsEach`, `whole_courses`, `share_meetsEach`: over Weighted's `courses moves all n`, the share of a conjunction of step events is the product of the step shares (equal as pairs).

**The exit from a margin** (Typicality's courses, weights `p` and `q`, a level `m` above a need, raised `q` by a one and lowered `p` by a zero):

- `rises_balance_falls`: weighted, the rises `q·a` add up to the falls `p·b` (no drift).
- `margin_square`: x + m ≤ y gives m·m + 2xy ≤ x² + y².
- `deviates_bound`: the courses whose deviation reaches `m` either way at the end weigh, times m·m, at most n·p·q·(p + q)ⁿ (from `Typicality.typical`).
- `fallsWithin_bound`: the courses in which the level falls to the need at some step, the start included, weigh, times m·m, at most n·p·q·(p + q)ⁿ (from `Typicality.typical_throughout`).
- `fallsTo_bound`: those ending at the need or below, the corollary at the horizon.
- `fallsWithin_share`: their share is at most ⟨n·p·q, m·m⟩. `fallsWithin_reciprocal`: its reciprocal is at least m·m over n·p·q.
- `Witness.within_exceeds_end`: over two steps with p = q = 1, m = 1, two courses fall within and one ends fallen (a course can fall and recover).

**What a record of the course so far says of the exit:**

- `courses_add`: the courses of k + n steps are, for each course of the k earliest steps, the courses of the n later steps followed by it.
- `mass_record`: for a record R of the earliest k steps and an event carried to an event F of the later steps, the courses agreeing with R and meeting the event weigh mass(R) × mass(F).
- `margin_shift`, `fallsTo_append`, `fallsWithin_append`: after a record leaving the level m' above the need, falling from m is falling in the record or falling from m'.
- `record_fallsWithin`: for a record every agreeing course of which leaves the level m' above the need without having fallen, the agreeing courses that fall within the horizon weigh mass(R) × (courses of the n steps left falling from m').
- `record_share`: given the record, their share is the unconditional share from m' (same ratio).
- `record_bound`: given the record, that share is at most ⟨n·p·q, m'·m'⟩.

Helpers (entry lemmas `entry_*`, `mass_congr`, `mass_congr_mem`, `mass_le_of_entries`, `mass_none`, `mass_append`, `mass_map`, `mass_mul_left`, `mass_mul_right`, `whole_of_entries`, `mass_eq_total`, `mass_and_comm`, `mass_and_true`, `mass_scaled_event`, `mass_first`, `mass_absent`, `mass_single`, `mass_joinMap`, `foldr_whole`, `foldr_part`, `regroup_square`, `square_gap`, `rises_step`, `falls_step`, `deviates_offBy`, `whole_typical`, `fallsWithin_of_end`, `fallsWithin_reachesBy`, `fallsWithin_entry`, `joinMap_congr`, `joinMap_single`, `extend_append`, `extend_joinMap`, `extend_map_append`, `drop_append_length`, `weight_append`, `ones_append`, `zeros_append`) are arithmetic or list lemmas; a search of the core for mass, `joinMap`, `extend` and append lemmas found none they duplicate.

## 2. The proposed change to Typicality (board rule 9)

The exit within a horizon needs Kolmogorov's maximal inequality, not Chebyshev's: a continuation ends at the first step its level falls past the need, so the courses that fall and recover by the horizon must count (`Witness.within_exceeds_end`). The maximal law strictly generalizes `Typicality.typical` (the last step is one step). Rule 9 asks that a generalization land below the law and prove it, and the maximal law needs Typicality's own courses, weights and spread identities, so it goes into Typicality and `typical` becomes its corollary. The kit's [Typicality](tree/Becoming/Typicality.lean) is the landed file (sha256 `904976890149…`) with:

- one new section before `typical`: `pairSquare`, `pairCross`, `stopStep`, `stopped`, `reachesBy`, `moving`, `stepCross`, `offByWithin` (definitions); `reachesBy_of_end`, `stopped_spec`, `moving_le`, `stopped_go`, `stopped_square_step`, `stopped_cross_step`, `stopped_spread`, `offByWithin_le`, `typical_throughout`, `offBy_le_within` (theorems);
- `typical`'s statement unchanged, its proof now three lines from `typical_throughout`;
- a docstring bullet and a classical-source sentence for the new law. Nothing else changes.

`typical_throughout`: the courses of n steps whose squared deviation reaches d at some step, the start included, weigh, times d, at most n·p·q·(p + q)ⁿ. The proof stops each course's pair where it first reaches d (`stopped`), shows the stopped pair is the course's own until then (`stopped_spec`), and reuses `weighted_square` and `weighted_cross` for the moving courses, so a step adds p·q·(p + q) times the weight of the courses still moving and nothing for the others (`stopped_spread`).

For the lander: `offBy_le` is no longer used by `typical` but is kept, since the record [typicality-by-counting](../../../../../../theories/becoming/results/records/typicality-by-counting.md) cites it in law 3; removing it means re-pointing that record. The record's declaration counts change (52 and 40 landed, by this audit; the record's evidence still cites the 15 October receipt's 56 and 43). If the change to Typicality is declined, the new section moves to `ConditionalWeights` unchanged, and the row then has to say why it lands beside `typical`.

`Becoming.ConditionalWeights` itself is a leaf. Its conditional weights, shares, independence and record laws are new statements on `mass`, which no existing law states in a special case. Its exit laws read Typicality's two bounds at a margin, as instances. A possible later consolidation, not done: `whole_courses` covers the total weight of free branching on any listed values, and `Typicality.transfer_weight` is its two-valued case through `Weights.sum_courses`.

## 3. The periphery draft (optional goal 4)

[`periphery/VariationalBound.lean`](periphery/VariationalBound.lean) states, over Mathlib's reals for a finite set of causes:

- `term_le`: the termwise bound, from log x ≤ x − 1.
- `free_energy_ge_surprisal`: for q ≥ 0 with Σ q = 1 and p > 0, −log Σ p ≤ Σ q (log q − log p): free energy is at least surprisal (Gibbs' inequality).
- `free_energy_posterior`: equality at q = p / Σ p.
- `free_energy_ge_surprisal_counts`: the same with natural joint weights w over a positive total Z, so the surprisal is −log((Σ w)/Z), the logarithm of the reciprocal of the record's share.

It compiles with no error or warning against the pinned Mathlib (`lake env lean` in `~/repos/生生不息`, Lean 4.30.0-rc2, Mathlib `ea11ccc0…`, pin hashes as in `lean/periphery-mathlib-pin/README.md`), each theorem depending on `propext`, `Classical.choice` and `Quot.sound`, as the periphery allows ([log](periphery/periphery.log)). It is a draft: it has no checker and no receipt, and it does not import the core. A periphery checker in the manner of `representation/check_representation.py` would compile the core's closure with the periphery toolchain and could add the instance theorem joining `free_energy_ge_surprisal_counts` to `ConditionalWeights.share` and `posterior_single`.

## 4. Correspondences [AI reading]

1. **Bayes's rule.** A share read as a probability is a number of situations of a kind (`Becoming.Situations`, record weights-count-situations). Then `given` is conditioning and `mass_given` says conditioning is restriction. `joint_two_ways` is P(h|o)P(o) = P(o|h)P(h). `evidence` is a generative model's marginal likelihood and `posterior_single` its posterior. `given_comm` says that evidence taken in either order gives one posterior.
2. **Surprisal.** Surprisal is log(1/P). The core takes no logarithm, but the reciprocal share orders as surprisal does (`Share.le_iff_reciprocal`) and multiplies where surprisal adds (`share_meetsEach`, `Share.reciprocal_mul`).
3. **The principle's bound.** The free-energy principle bounds the surprisal of a system's states by variational free energy, and reads persisting as keeping that surprisal low, within the states its continuation needs. The periphery draft proves the bound itself for finite causes. The core's exit laws give the counting form of what that reading asks of a margin: the share of courses leaving a margin m within n steps is at most n·p·q/m², and with nothing recorded the surprisal of leaving is at least log(m²/(n·p·q)). The bound reads the margin and the spread only, never the system's generative model.
4. **The margin vocabulary** ([02 §5](../../../../../../theories/becoming/chapters/02-MAP.md#margin)). The margin there is how far levels stand above needs. `fallsWithin_bound` is a bound on breaks in the stochastic case: a balanced level m above its need breaks within n steps on at most n·p·q/m² of the weight. It is not the regime's point of no return: no giving law reads the level here, and the level only fluctuates.
5. **A break seen coming** ([03 §10, T6](../../../../../../theories/becoming/chapters/03-KNOWING.md#break-seen-coming)). `record_share` and `record_bound` are the seen half in counting form. Where a record holds the level and the need, the conditional share of a break within the horizon reads off the margin the record shows, the steps it leaves and the spread, and nothing else in the record matters. T6's invisible half, that a record not holding the level bounds nothing, is not stated here.

Whether UE2 gives UE1's containment a third part, something the theory forbids that the principle leaves open, is for UE0 and UE1 to judge. The candidate is the margin law: whatever an agent's generative model, a balanced level with margin m against spread n·p·q leaves within n steps on at most n·p·q/m² of the weight, and given a record only the margin it shows matters. The principle's own bound is stated in a quantity, free energy, that depends on the model.

## 5. What is not derived

- Which weighting an actual unfolding has, or that the course which happens is typical (as in Typicality).
- Real weights, densities, surprisal as a number, free energy, in the core; in the periphery draft, causes are finite and every joint weight positive.
- Graded evidence on a general domain: records are Boolean. A likelihood weighting multiplying a prior appears only as the generative model's `joint`.
- Exits for a level with a drift (renewal unequal to the draw), more than two values, or steps that are not independent. A drift moves the margin linearly in the steps and is not treated.
- Exponential exit bounds, which `Typicality.concentrated` would give one-sided, are not read at a margin.
- Sequential conditioning on records of Weighted's general courses: the record law is stated for Typicality's two-valued courses only.
- The representation commits to discrete steps and natural weights. No ethical predicate, ranking or axiom occurs.

## 6. What remains

1. **Review.** An independent review of the kit before landing, the Typicality change in particular.
2. **Landing**, through the queue:
   - the Typicality change (§2): a new law in record typicality-by-counting, its counts and receipt, and the decision on `offBy_le`;
   - records for conditional weights and Bayes's rule, for shares under independence, and for the exit from a margin with the record law;
   - home sections: 03's typicality section for the maximal law; 02 §5 for the exit; 08 §8's known results for Bayes, Kolmogorov and, once checked, Gibbs;
   - the board row's rule-9 note (leaf, §2);
   - the generated indexes.
3. **Periphery.** A checker and receipt for `VariationalBound`, and the instance theorem joining it to the core's `share` (§3).
4. **Extensions.** A drifting level, with renewal against the draw; the exponential exit; graded records on general domains; records of Weighted's general courses through `Weights.along_append` (`Becoming.HistorySums`); T6's invisible half in counting form, where a record not holding the level leaves the conditional exit share a mixture over levels with no bound below its prior.
