# Re-check of UE17 after the fold

29 October 2026. AI-written, read-only re-check of how the twelve findings of [REVIEW-UE17](REVIEW-UE17.md) were folded in.

**Read:**
- [`FreeEnergyReals.lean`](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/free-energy/FreeEnergyReals.lean) (sha256 `b9161f9c…`), diffed against the reviewed bytes;
- [the checker](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/free-energy/check_free_energy_reals.py) (`390bcb0f…`);
- [NOTE](NOTE.md), [DRAFT-NOTES](DRAFT-NOTES.md), [`warm_closure.py`](warm_closure.py) and the kit (`make_records_ue17.py`, `texts_ue17.py`, `study_ue17.txt`), as of 21:23 (UTC+7).

**Built:**
- The module, against the warm-up's core oleans and the pinned Mathlib (Lean 4.30.0-rc2).
- A probe of all 47 declarations and the new or changed signatures ([appendix](#appendix-probe)). Neither the module nor the probe gave an error or a warning.

**Ran:** the kit's read-only `--caps source`, which printed "47 declarations in 8 laws; statement 278 77" against caps of 300 and 150. It left the worktree unchanged.

## Verdict

The fold is sound, and the Lean says what the folded texts claim.

**What the probe and diff confirm.**
- **Axioms.** 46 declarations depend on exactly `propext`, `Classical.choice` and `Quot.sound`, and `jointShare_part` on none: 42 theorems and 5 definitions.
- **F6.** `minimizes_iff_givenShare` no longer takes positivity, and `record_pos_of_belief` needs only total one and the support condition.
- **F9.** `a.toReal_mul b` and `a.toReal_nonneg` resolve by dot notation. `freeEnergy_eq_divergence` is `rfl`, and `minimizes_iff_posterior` has the old statement.

**Finding by finding.**
- **F1:** carried in the module, `SCOPE`, NOTE, the kit's related text and the 03, 08 and study texts, but not in the record's statement (R1).
- **F2:** carried everywhere except the study section's "Decisions at landing" (R2).
- **F3, F4, F8, F11:** carried as written.
- **F5:** recorded for the landing.
- **F7:**
  - (a) is pending in NOTE §6;
  - (b) is applied by asserts, each old text present once in the record;
  - (c) happens at landing;
  - (d) is partial (R7);
  - (e) is done.
- **F10:** carried, with the review's own parenthetical too loose (R4).
- **F12:** left by design.

**What remains.** Two overstatements remain in texts that land (R1, R2), along with six style points; none touches the Lean. Fix R1 and R2 before landing. Main has moved again. RF round 1 has landed (`cbb396723`), and WRP2 now holds the head (`e519da671`); it changes `GrammarLaws` and so rebuilds nearly the whole closure. F5's merge and fresh run cover both, behind WRP2 and UE16 in the queue.

## Findings

R numbers keep these apart from the review's F1–F12.

### R1 (O). The record's statement drops the support condition in its first clause

- **Where.** `kit/make_records_ue17.py`, `statement`, en and zh. The en text also reads "…where the joint weight is is conditioning."
- **What the Lean says.** `surprisal_le_freeEnergy` holds for beliefs zero wherever the joint weight is, and `Witness.bound_fails_off_support` breaks it otherwise. "A belief's variational free energy is at least the record's surprisal" is true only with that condition, or with the value infinite off the support as usually defined.
- **Fix** (283 and 80 characters, under the caps):
  - en: "Over finitely many causes, a belief zero where the joint weight is has variational free energy at least the record's surprisal, equal exactly at the posterior; in a core generative model that is the share given the record, so minimizing free energy over such beliefs is conditioning."
  - zh: "于有限诸因之上，于联合权重为零处为零之信念，其变分自由能至少为记录之惊异，恰于后验取等；于核心之生成模型，此即记录下之份额，故于此等信念上最小化自由能即条件化。"

### R2 (O). The study section repeats F2's overstatement

- **Where.** `kit/study_ue17.txt`, "Decisions at landing": "averages of logarithms need the reals and Mathlib's logarithm, which the pure core does not have".
- **Fix.** "the real form needs Mathlib's logarithm, which the pure core does not have; for beliefs with natural counts the bound has a counting form, not yet stated, so the record says the law is in the periphery until a core form lands."

### R3 (S). The counting form's equality case needs the record to weigh something

This is the review's own F2 wording.
- **Where.**
  - The module's "What is not derived": "equal exactly at the share given the record; it is not stated here".
  - NOTE §3.
  - The kit's `next_delta`.
- **What holds.**
  - Where `A = 0`, both sides are 0 for every belief, since some `n_h > 0` meets `a_h = 0`.
  - Read as "each `⟨n_h, N⟩` is `Share.Same` as `⟨a_h, A⟩`", the statement still holds, because `⟨0, 0⟩` is the same ratio as any share (`Share.zero_whole`).
  - The module states the inequality without its standing.
- **Fix.**
  - In the module: "…`N^N · ∏ a^n ≤ A^N · ∏ n^n`, equal, where the record weighs something, exactly at the share given the record (the weighted inequality of arithmetic and geometric means; checked on small cases in REVIEW-UE17, not proved here)".
  - In NOTE §3 and `next_delta`: insert "where the record weighs something".

### R4 (S). The complexity parenthetical names only one condition of `divergence_nonneg`

This is the review's own F10 wording.
- **Where.** The docstring of `freeEnergy_eq_complexity_sub_accuracy`, and NOTE §2 item 5: "nonnegative where the prior has total one".
- **What the Lean says.** `divergence_nonneg` also needs `q` and the prior nonnegative, with `q` of total one. That `q` is zero where the prior is follows from the theorem's support hypothesis.
- **Fix.** "(the complexity, nonnegative where `q` and the prior are distributions: `divergence_nonneg`)".

### R5 (S). `record_pos_of_belief`'s bold title misnames what is ruled out

- **Where.** Its docstring: "A belief zero where the record is ruled out exists only where the record weighs something." The body is exact.
- **Fix.** "A belief zero on the hypotheses the prior or the record rules out exists only where the record weighs something."

### R6 (S). Two stale lines in the record kit

- **Docstring.** "neither's statement, next step or declarations change" contradicts F7(b). Fix: "conditioning-by-restriction's next step, correspondence and third does-not-show item are brought to UE17; neither record's statement or declarations change."
- **The new record's history.** "the two decompositions" (zh "二分解") should become "the three decompositions" ("三分解"), since energy less entropy was added.

### R7 (S). FEP-INTEGRATION and UE2's draft at landing

- **Where.** `kit/texts_ue17.py`.
- **What holds.**
  - It edits FEP-INTEGRATION's item 2 and its "Not stated anywhere in Lean" line. It leaves §2's UE2 bullet stale: "The variational bound was drafted for the periphery (`ConditionalWeightsReals.lean`, …) with no checker and no record."
  - No kit step moves UE2's draft, yet the study section says it "moved to history".
  - The plan edit hard-codes "landed 29 October".
- **Fix.**
  - Add one edit to that bullet: "…; UE17 states it in the periphery with its checker and record".
  - Run `research.py move --plan` and the move before the study text lands.
  - Take the date at run time, as `make_records_ue17.py` does.

### R8 (S). Wording and wrapping

- **Line length.** Module lines 71, 84 and 90 run to 121–162 characters; the rest wrap at 100.
- **Grammar.** "the energy less the entropy that give it its name" should read "that gives it its name", in the module (line 25) and NOTE §2 item 1.
- **Qualifier.** "the one minimizer of free energy" lacks "among the beliefs where it is finite" in NOTE §1's reading, NOTE §5 and the kit's `correspondence`. The study's standing and the 08 bullet carry it.

## Appendix: probe

Built in `/private/tmp/claude-501/-Users-ren-theories/7e73c253-c642-4ddd-ad8f-cc6d011978ec/scratchpad/ue17review/recheck/`:
- the module was copied there and compiled with `./build.sh -o FreeEnergyReals.olean FreeEnergyReals.lean`;
- the probe was compiled with `./build.sh RecheckProbe.lean`.

`build.sh` is REVIEW-UE17's with `PR=$S/ue17review/recheck`. The `#print axioms` lines list every declaration in source order, read as the kit's `source_names` reads them.

```lean
import FreeEnergyReals

#print axioms Becoming.FreeEnergy.freeEnergy
#print axioms Becoming.FreeEnergy.divergence
#print axioms Becoming.FreeEnergy.freeEnergy_eq_divergence
#print axioms Becoming.FreeEnergy.surprisal
#print axioms Becoming.FreeEnergy.posterior
#print axioms Becoming.FreeEnergy.term_le
#print axioms Becoming.FreeEnergy.term_eq_iff_of_pos
#print axioms Becoming.FreeEnergy.term_eq_iff
#print axioms Becoming.FreeEnergy.freeEnergy_congr
#print axioms Becoming.FreeEnergy.sum_terms
#print axioms Becoming.FreeEnergy.sum_normalized_sub
#print axioms Becoming.FreeEnergy.total_pos
#print axioms Becoming.FreeEnergy.surprisal_le_freeEnergy
#print axioms Becoming.FreeEnergy.freeEnergy_eq_surprisal_iff
#print axioms Becoming.FreeEnergy.freeEnergy_eq_surprisal_iff_of_pos
#print axioms Becoming.FreeEnergy.posterior_nonneg
#print axioms Becoming.FreeEnergy.posterior_eq_zero
#print axioms Becoming.FreeEnergy.sum_posterior
#print axioms Becoming.FreeEnergy.freeEnergy_posterior
#print axioms Becoming.FreeEnergy.minimizes_iff_posterior
#print axioms Becoming.FreeEnergy.freeEnergy_eq_divergence_add_surprisal
#print axioms Becoming.FreeEnergy.divergence_nonneg
#print axioms Becoming.FreeEnergy.divergence_eq_zero_iff
#print axioms Becoming.FreeEnergy.divergence_posterior_nonneg
#print axioms Becoming.FreeEnergy.divergence_posterior_eq_zero_iff
#print axioms Becoming.FreeEnergy.freeEnergy_eq_complexity_sub_accuracy
#print axioms Becoming.FreeEnergy.freeEnergy_eq_energy_sub_entropy
#print axioms Becoming.FreeEnergy.Witness.bound_fails_off_support
#print axioms Becoming.ConditionalWeights.Share.toReal
#print axioms Becoming.ConditionalWeights.Share.toReal_nonneg
#print axioms Becoming.FreeEnergy.share_toReal_pos
#print axioms Becoming.ConditionalWeights.Share.toReal_mul
#print axioms Becoming.FreeEnergy.surprisal_eq_log_reciprocal
#print axioms Becoming.FreeEnergy.cast_mass_eq_sum
#print axioms Becoming.FreeEnergy.jointShare_part
#print axioms Becoming.FreeEnergy.jointShare_toReal
#print axioms Becoming.FreeEnergy.recordShare_toReal
#print axioms Becoming.FreeEnergy.sum_jointShare
#print axioms Becoming.FreeEnergy.givenShare_toReal
#print axioms Becoming.FreeEnergy.givenShare_eq_posterior
#print axioms Becoming.FreeEnergy.weight_zero_of_jointShare_zero
#print axioms Becoming.FreeEnergy.record_pos_of_belief
#print axioms Becoming.FreeEnergy.record_surprisal_le_freeEnergy
#print axioms Becoming.FreeEnergy.freeEnergy_eq_record_surprisal_iff
#print axioms Becoming.FreeEnergy.freeEnergy_givenShare
#print axioms Becoming.FreeEnergy.minimizes_iff_givenShare
#print axioms Becoming.FreeEnergy.surprisal_product

#check @Becoming.FreeEnergy.record_pos_of_belief
#check @Becoming.FreeEnergy.minimizes_iff_givenShare
#check @Becoming.FreeEnergy.minimizes_iff_posterior
#check @Becoming.FreeEnergy.freeEnergy_eq_divergence
#check @Becoming.FreeEnergy.freeEnergy_eq_energy_sub_entropy
#check @Becoming.ConditionalWeights.Share.toReal_nonneg
#check @Becoming.ConditionalWeights.Share.toReal_mul
open Becoming.ConditionalWeights in
example (a b : Share) : (a.mul b).toReal = a.toReal * b.toReal := a.toReal_mul b
open Becoming.ConditionalWeights in
example (a : Share) : 0 ≤ a.toReal := a.toReal_nonneg
```

**Output.**
- 46 lines of `depends on axioms: [propext, Classical.choice, Quot.sound]`, and `'Becoming.FreeEnergy.jointShare_part' does not depend on any axioms`.
- The seven signatures as described in the verdict.
- No error or warning.
