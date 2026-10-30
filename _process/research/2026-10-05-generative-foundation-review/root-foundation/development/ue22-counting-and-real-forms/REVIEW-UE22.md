# Review of UE22: the counting form and the real form of the free-energy bound, joined

30 October 2026. AI-written, independent, read-only review of the UE22 draft (the drafting worktree on `119d464ca`, with the module, the checker, this folder and its kit uncommitted), by an AI agent other than the one that drafted it. Not reviewed by a person.

**Read.** AGENTS.md. The draft's diff of `FreeEnergyReals.lean` and `check_free_energy_reals.py` against main, and the whole module. `Becoming.FreeEnergyCounting`; in `ConditionalWeights`, `Share`, `share`, `whole_restrict` and `posterior_single`; in `Prelude`, `total` and `Distinct`. This folder's NOTE.md, DependencyAudit.lean, dependency-audit.log, scratch-1.log, scratch-2.log and LANDING.md, and the kit (`board_ue22.py`, `make_records_ue22.py`, `texts_ue22.py`, `study_ue22.txt`). The records free-energy-bounds-surprisal and free-energy-bound-in-counts and their home sections in 03 §6. UE21's NOTE and REVIEW-UE21 (F6, F7). The counting-form sentences of the principle's page, of 08 and of FEP-INTEGRATION.

**Built and ran.** Lean 4.30.0-rc2 with the pinned Mathlib, against the draft as compiled for the drafting run. Its source has sha256 `9d2d7e1a…`, the same as the worktree file, and the core modules it reads (`FreeEnergyCounting`, `ConditionalWeights`, `Prelude`) match the worktree's. The probes are in `/private/tmp/claude-501/-Users-ren-theories/7e73c253-c642-4ddd-ad8f-cc6d011978ec/scratchpad/ue22review/`. That is scratch space and may be wiped, so the Lean the fixes need is quoted below.
- **A copy of the module**: no error or warning.
- **Lean probes**: `ProbeHypotheses`, `ProbePositive`, `ProbeWitness`, `ProbeWitnessFinal`, `ProbeDuplicate`, and `SuggestedAdditions` (the Lean proposed below, compiled in the module's own namespace and section setting). No error or warning, and every declaration depends on Lean's three standard axioms at most.
- **Audit probes**: `ProbeAudit`, `ProbePath`, `ProbeAuditStop` and `ProbeAuditStopList` (F1). They use the study's reach, with:
  - existence checks and positive controls;
  - more targets;
  - a shortest path;
  - a pass with the definition of the logarithm left unexpanded.
- **Numerics**: `offsupport_check.py` evaluates the identity under Mathlib's conventions on every small case: one to three hypotheses, counts and weights from 0 to 3, positive total.

## Verdict

**The Lean is sound, and the main identity is exact.**
- `gap_counts` says what its docstring says, and the bound, equality and strictness follow from the core's laws as claimed.
- "The whole weight drops out" is exactly `gap_div` applied in `gap_counts_given_record`.
- `gap_counts_given_record` and `freeEnergy_eq_record_surprisal_iff_of_counts` read UE17's terms and UE21's two sides with no slippage.
- The placement (a section of `FreeEnergyReals`) and the names are right.

**What overreaches is the prose around the Lean, repeated in the kit's drafts:**
- The dependency sentence names the inequality `log x ≤ x − 1`. The proofs do reach it, in exponential form, through the definition of the real logarithm (F1).
- "Off the support the identity fails" is stated as general. The identity holds off the support at one count, including at UE21's own off-support witness, where the real form also holds (F2).
- The witness's docstring says more than its statement, and it cites a core witness about other counts (F3).
- The real-number form of the equality given the record is asserted but not proved (F4).

**The join is also incomplete.** In the generative model it has no bound and no strictness, and no theorem states the "one law" (F5).

**Land after F1–F4.** They need prose, one restated witness, and either one theorem or a rewording. F5–F8 are best taken with them; F9–F13 are wording and options.

## Errors: claims beyond what the Lean or the audit shows

### F1 (error). The dependency claim names `log x ≤ x − 1`, which every statement about the logarithm reaches

**Where.**
- Module docstring, counting-form bullet: "None of the three uses `surprisal_le_freeEnergy` or `log x ≤ x − 1`."
- NOTE §1, first bullet: "for beliefs in counts, Gibbs' inequality is the core's counting law plus the algebra of the logarithm"; NOTE §3, Shows: "without Gibbs' inequality".
- SCOPE: "follow from the core's counting laws without Gibbs' inequality".
- The kit:
  - `make_records_ue22.py`, second law ("From the core's counting laws, without Gibbs' inequality");
  - `texts_ue22.py`, the 03 §6 edit ("follow from the core's counting laws without Gibbs' inequality");
  - `study_ue22.txt`, Delta (2).
- `DependencyAudit.lean`.

**What.**
- **The audit's method is sound as far as it goes.** In this Lean, `ConstantInfo.value?` returns a theorem's value only with `allowOpaque := true` (`thmInfo` is gated on the flag), so the flag is needed, and the audit's docstring says so correctly. The `true` rows for core laws that only the proofs reach show that the audit reads proofs. My rerun agrees with every row whose target it shares.
- **Every statement about the logarithm reaches the inequality.** Mathlib's `Real.add_one_le_exp : ∀ x, x + 1 ≤ exp x` is `log y ≤ y − 1` with `x = log y`, and `Real.add_one_lt_exp` is its strict form. Both are in the reach of:
  - the three theorems and `freeEnergy_eq_record_surprisal_iff_of_counts`;
  - `gap_counts`, `gap_counts_given_record`, `divergence_counts` and `counts_eq_mul_exp`;
  - the definition of `freeEnergy` itself.
- **The path.** A shortest one is `Real.log → Real.expOrderIso → Real.expOrderIso._proof_5 → _proof_2 → …expOrderIso._simp_1 → Real.tendsto_exp_atTop → Real.add_one_le_exp`. Mathlib builds `Real.log` as the inverse of `exp` on the positive reals, and the proof that `exp` takes every positive value uses that lemma.
- **So the sentence is false as written.** The closure method cannot exclude `log x ≤ x − 1` for any statement about the logarithm. The sentence is true only of the lemma `Real.log_le_sub_one_of_pos`.
- **A narrower claim is exact, and is checked.**
  - Leave the logarithm's definition unexpanded (`Real.log` and `Real.expOrderIso` as stop nodes). Then the four theorems and `gap_counts` reach neither `Real.add_one_le_exp` nor `Real.add_one_lt_exp`.
  - Outside that definition, the lower bounds of `exp` by its series that they reach all hold for nonnegative arguments only: Mathlib's private `Real.add_one_le_exp_of_nonneg` and `Real.add_one_lt_exp_of_pos` through `Real.exp_strictMono`, and `Real.one_le_exp`, `Real.quadratic_le_exp_of_nonneg` and `Real.sum_le_exp_of_nonneg`. So they reach `x + 1 ≤ exp x` only for `x ≥ 0`, which is `log y ≤ y − 1` for `y ≥ 1` only: they use that `exp` increases.
  - The positive control `surprisal_le_freeEnergy`, with the same stop nodes, reaches `term_le`, `Real.log_le_sub_one_of_pos`, `Real.add_one_le_exp` and `Real.add_one_lt_exp`.
  - The unstopped reach of the four theorems contains none of `term_eq_iff`, `term_eq_iff_of_pos`, `freeEnergy_eq_surprisal_iff` and `Real.log_lt_sub_one_of_pos`.
- **The study's audit has three gaps.**
  - No existence check on its target names, so a misspelled target would report `false`.
  - No positive control.
  - For the equality and strictness theorems, no rows for `Real.log_le_sub_one_of_pos`, `Real.log_lt_sub_one_of_pos` or `term_eq_iff_of_pos`.
- **The proofs also use the logarithm's order.** They use `Real.log_le_log`, `Real.log_lt_log` and `Real.log_injOn_pos`, not only its algebra.
- **The checker does not run the audit**, so the receipt's scope should not state the audit's result.

**Fix.**
- **Module docstring.** Replace the sentence with: "None of these four reaches `surprisal_le_freeEnergy`, `term_le` or Mathlib's `Real.log_le_sub_one_of_pos`; outside the definition of `Real.log`, which reaches `x + 1 ≤ exp x` (`Real.add_one_le_exp`), they reach that inequality only for `x ≥ 0`, that is, that `exp` increases (a dependency audit in the UE22 study)."
- **NOTE §1, first bullet**, from "The dependency audit": "The dependency audit (…) shows that none of the three proofs, nor that of `freeEnergy_eq_record_surprisal_iff_of_counts`, reaches `surprisal_le_freeEnergy`, `term_le`, `term_eq_iff`, `freeEnergy_eq_surprisal_iff`, `Real.log_le_sub_one_of_pos` or `Real.log_lt_sub_one_of_pos`. Every statement about Mathlib's logarithm reaches `x + 1 ≤ exp x` (`Real.add_one_le_exp`), through the definition of `Real.log` as the inverse of `exp` (`Real.expOrderIso`, by `Real.tendsto_exp_atTop`). With that definition not expanded, the proofs reach `x + 1 ≤ exp x` only for `x ≥ 0` (that `exp` increases), where UE17's `surprisal_le_freeEnergy` reaches it in full. So, for beliefs in counts, the real bound is the core's counting law plus the algebra and order of the logarithm, not UE17's argument."
- **NOTE §3, Shows:** "derived from the core's counting laws, not through UE17's Gibbs lemmas, and reaching `x + 1 ≤ exp x` only through the definition of the logarithm (§1)".
- **SCOPE:** replace "follow from the core's counting laws without Gibbs' inequality" with "are proved from the core's counting laws (FreeEnergyCounting.bound, bound_eq_iff, bound_lt_of_not_proportional)".
- **The kit**:
  - the second law: "From the core's counting laws, not through UE17's Gibbs lemmas (a dependency audit):";
  - the 03 §6 edit: "follow from the core's counting laws (`…`), whose proofs do not pass through UE17's Gibbs argument";
  - Delta (2): name the lemmas as above and add the sentence on `Real.add_one_le_exp`.
- **DependencyAudit.lean:**
  - throw on an unknown target (`unless env.contains t do throwError s!"unknown target {t}"`);
  - add a positive-control row: `surprisal_le_freeEnergy` reaches `term_le` and `Real.log_le_sub_one_of_pos`;
  - add the missing targets and a row for `Real.add_one_le_exp`;
  - add a second pass with the stop nodes below;
  - regenerate the log.

```lean
/-- The study's `reach`, with the constants in `stop` not expanded; with the empty set it is `reach`. -/
partial def reachStop (env : Environment) (stop : NameSet) (root : Name) : NameSet := Id.run do
  let mut seen : NameSet := {}
  let mut todo : List Name := [root]
  while !todo.isEmpty do
    match todo with
    | [] => pure ()
    | c :: rest =>
      todo := rest
      if seen.contains c then continue
      seen := seen.insert c
      if stop.contains c then continue
      match env.find? c with
      | none => pure ()
      | some info =>
        let used := info.type.getUsedConstants ++
          ((info.value? (allowOpaque := true)).map (·.getUsedConstants) |>.getD #[])
        for u in used do
          if !seen.contains u then todo := u :: todo
  return seen
-- the definition of the logarithm: ({} : NameSet).insert `Real.log |>.insert `Real.expOrderIso
```

### F2 (error). "Off the support the identity fails" is stated as general; it holds there at one count

**Where.**
- Module docstring: "Off the support the identity fails (`Witness.gap_counts_off_support`): there the core's bound holds and the real form, under `log 0 = 0`, does not."
- NOTE §1, last bullet; NOTE §3, Shows.
- SCOPE: "off the support the identity fails (a two-hypothesis witness)".
- The board row ("off the support the identity fails (a witness)").
- The kit:
  - `make_records_ue22.py`, the fourth law, the counterexample, and `c_dns0` ("there the real form fails under log 0 = 0 while this bound holds");
  - `texts_ue22.py`, the 03 §6 edit and FEP-INTEGRATION item 7;
  - `study_ue22.txt`, Delta (5).

**What.**
- **One witness shows the identity can fail; it does not always fail.** Take UE21's own off-support counts, `FreeEnergyCounting.Witness.first` against `secondOnly`: one count, on the hypothesis of weight nothing. There:
  - `N` times the gap and the log ratio (`log 1 − log 0`) are both `0`;
  - the real free energy equals the surprisal (`0 = 0`);
  - the counts are not in proportion, so the core's bound is strict (`FreeEnergyCounting.Witness.off_support`).

  `Witness.one_count_off_support` (below; compiled) states the identity, the equality of free energy and surprisal (so both values are `0`) and that the counts are not in proportion.
- **"There … the real form … does not [hold]" is false in general.** At those counts the real bound holds, at equality.
- **By hand, with a positive total.** Off the support, where some weight is positive, `N · (F − S)` falls short of the log ratio by `N log N + Σ_{a h ≠ 0} n h log a h`. Where every weight is nothing, the shortfall is `N log N − Σ n h log n h`. So the identity holds off the support exactly at one count, or where every weight is nothing and one hypothesis holds every count. On the small cases:
  - on the support the identity holds in all 2,295 cases (as REVIEW-UE21 found);
  - off it, it holds in 69 of 1,989, exactly these;
  - the real bound holds in 916 of the 1,989.
- **This sharpens the reason for the support hypothesis.** Off the support, even where the identity holds, the two cases of equality part: the real form is at equality while the core's bound is strict. So `freeEnergy_eq_surprisal_iff_of_counts` would be false without the support even at counts where the identity holds.

**Fix.**
- **Module docstring:** "Off the support the identity can fail (`Witness.gap_counts_off_support`: counts one and one against weights nothing and one, where the core's bound holds strictly and the real form, under `log 0 = 0`, fails); at one count, on a hypothesis of weight nothing, it holds, the real form at equality and the core's bound strict (`Witness.one_count_off_support`), so off the support the two cases of equality part even where the identity holds." Without the second witness, end the sentence after "fails)".
- **NOTE §1, last bullet:** head it "Off the support the identity can fail". After "cannot be dropped" add: "It holds off the support exactly at one count, or where every weight is nothing and one hypothesis holds every count (by hand; 69 of the 1,989 off-support small cases, all of these); at one count the real form is at equality while the core's bound is strict (`Witness.one_count_off_support`)."
- **NOTE §3, Shows:** "that off the support the identity can fail, so the support cannot be dropped, and that where it holds off the support the two cases of equality part".
- **SCOPE:** "off the support the identity can fail (a two-hypothesis witness)".
- **Board.** Add to `STATEMENTS`: `("off the support the identity fails (a witness)", "off the support the identity can fail (a witness)")`.
- **Kit records.**
  - Fourth law and counterexample: "can fail".
  - Counts record, first item of what it does not show: "Off the support the two laws are not one: the identity joining them can fail there (FreeEnergy.Witness.gap_counts_off_support), and where it holds, at one count, the real form is at equality while this bound is strict (FreeEnergy.Witness.one_count_off_support)."
- **Kit texts:** FEP-INTEGRATION item 7 and the 03 §6 edit: "off the support the identity can fail".
- **If the second witness is not added**, cite this review for the one-count case wherever the text above cites `Witness.one_count_off_support`.

The second witness, in the module's `namespace Witness`, compiled:

```lean
/-- **Off the support with one count the identity holds and the two equalities part**: at UE21's
off-support counts (`FreeEnergyCounting.Witness.first` against
`FreeEnergyCounting.Witness.secondOnly`), `N` times the gap equals the log ratio, the free energy is
the surprisal (so both are nothing), and the counts are not in proportion, so the core's bound is
strict (`FreeEnergyCounting.Witness.off_support`). -/
theorem one_count_off_support :
    (Becoming.total [true, false] FreeEnergyCounting.Witness.first : ℝ) *
        (freeEnergy [true, false].toFinset
            (countBelief [true, false] FreeEnergyCounting.Witness.first)
            (fun h => (FreeEnergyCounting.Witness.secondOnly h : ℝ)) -
          surprisal (∑ h ∈ [true, false].toFinset, (FreeEnergyCounting.Witness.secondOnly h : ℝ))) =
      Real.log ((Becoming.total [true, false] FreeEnergyCounting.Witness.secondOnly ^
          Becoming.total [true, false] FreeEnergyCounting.Witness.first *
          FreeEnergyCounting.powerProduct FreeEnergyCounting.Witness.first
            FreeEnergyCounting.Witness.first [true, false] : ℕ) : ℝ) -
        Real.log ((Becoming.total [true, false] FreeEnergyCounting.Witness.first ^
          Becoming.total [true, false] FreeEnergyCounting.Witness.first *
          FreeEnergyCounting.powerProduct FreeEnergyCounting.Witness.secondOnly
            FreeEnergyCounting.Witness.first [true, false] : ℕ) : ℝ) ∧
    freeEnergy [true, false].toFinset
        (countBelief [true, false] FreeEnergyCounting.Witness.first)
        (fun h => (FreeEnergyCounting.Witness.secondOnly h : ℝ)) =
      surprisal (∑ h ∈ [true, false].toFinset, (FreeEnergyCounting.Witness.secondOnly h : ℝ)) ∧
    ¬ (∀ h, h ∈ [true, false] →
        FreeEnergyCounting.Witness.first h *
            Becoming.total [true, false] FreeEnergyCounting.Witness.secondOnly =
          FreeEnergyCounting.Witness.secondOnly h *
            Becoming.total [true, false] FreeEnergyCounting.Witness.first) := by
  refine ⟨?_, ?_, by decide⟩
  · simp [freeEnergy, surprisal, countBelief, Becoming.total, FreeEnergyCounting.powerProduct,
      FreeEnergyCounting.Witness.first, FreeEnergyCounting.Witness.secondOnly]
  · simp [freeEnergy, surprisal, countBelief, Becoming.total, FreeEnergyCounting.Witness.first,
      FreeEnergyCounting.Witness.secondOnly]
```

### F3 (error). The witness's docstring says more than its statement, and cites a core witness about other counts

**Where.** `Witness.gap_counts_off_support` and its docstring; NOTE §1, last bullet ("There the core's bound holds strictly (`FreeEnergyCounting.Witness.off_support`)"); the kit's counterexample.

**What.**
- **The statement is only `LHS ≠ RHS`.** The docstring's values (`N` times the gap is `−2 log 2`, the log ratio `log 1 − log 0 = 0`) are `have`s inside the proof, and "the real form fails" is not stated at all.
- **The citation points at other counts.** `FreeEnergyCounting.Witness.off_support` is about the counts `first` (one and nothing), not `even` (one and one), and at `first` the identity holds (F2). The core's bound is strict at `even` (`0 < 1`, by decision), but no cited theorem states it.

**Fix.** Restate the witness so that its statement carries what its docstring says. The text below compiled under another name in the module's namespace; the draft's `≠` follows from its first and fourth conjuncts, `log 2` being positive.

```lean
open Becoming.FreeEnergyCounting.Witness (even secondOnly) in
/-- **Off the support the identity can fail**: counts one and one against weights nothing and one
(`FreeEnergyCounting.Witness.even`, `FreeEnergyCounting.Witness.secondOnly`). Under Mathlib's
`log 0 = 0`, `N` times the gap is `−2 log 2`, below nothing, so the real bound fails there; the
counting bound's left side is nothing and its right side one, so the core's bound holds strictly,
and the logarithm of its ratio is `log 1 − log 0 = 0`. -/
theorem gap_counts_off_support :
    (Becoming.total [true, false] even : ℝ) *
        (freeEnergy [true, false].toFinset (countBelief [true, false] even)
            (fun h => (secondOnly h : ℝ)) -
          surprisal (∑ h ∈ [true, false].toFinset, (secondOnly h : ℝ))) = -2 * Real.log 2 ∧
      Becoming.total [true, false] even ^ Becoming.total [true, false] even *
          FreeEnergyCounting.powerProduct secondOnly even [true, false] = 0 ∧
      Becoming.total [true, false] secondOnly ^ Becoming.total [true, false] even *
          FreeEnergyCounting.powerProduct even even [true, false] = 1 ∧
      Real.log ((Becoming.total [true, false] secondOnly ^ Becoming.total [true, false] even *
          FreeEnergyCounting.powerProduct even even [true, false] : ℕ) : ℝ) -
        Real.log ((Becoming.total [true, false] even ^ Becoming.total [true, false] even *
          FreeEnergyCounting.powerProduct secondOnly even [true, false] : ℕ) : ℝ) = 0 := by
  refine ⟨?_, by decide, by decide, ?_⟩
  · simp [freeEnergy, surprisal, countBelief, Becoming.total, even, secondOnly]
    ring
  · simp [Becoming.total, FreeEnergyCounting.powerProduct, even, secondOnly]
```

In NOTE §1, replace "(`FreeEnergyCounting.Witness.off_support`)" with "(its left side nothing, its right side one)", and "(as `Witness.bound_fails_off_support` shows over two causes)" with "(UE17's `Witness.bound_fails_off_support` is the same belief, the causes swapped)". Word the kit's counterexample the same way.

### F4 (error). The real-number form of the equality given the record is asserted, not proved

**Where.**
- The docstring of `freeEnergy_eq_record_surprisal_iff_of_counts`: "as real numbers, that is where the belief in counts is the share given the record, as `freeEnergy_eq_record_surprisal_iff` states (`Share.same_iff_toReal_eq`)".
- The module bullet: "as real numbers, `Share.same_iff_toReal_eq`".
- The kit's study Delta (4).

**What.**
- The theorem's right side is UE21's `Share.Same` form.
- Reaching UE17's form takes `Share.same_iff_toReal_eq`, which needs both wholes positive.
- The share given the record has the record's weight as its whole (`whole_restrict`), and that weight is positive under the hypotheses (`record_total`, `total_pos_of_counts`).
- So the real-number form is true, but no theorem states it.

**Fix.** Add the theorem below, compiled in the module's setting. Its proof reaches no Gibbs lemma, and it is the exact counterpart, at beliefs in counts, of UE17's `freeEnergy_eq_record_surprisal_iff`. Cite it for "as real numbers". Otherwise, reword both places: "and `Share.same_iff_toReal_eq` turns each such ratio, where both wholes are positive, into equality of real numbers, the form of `freeEnergy_eq_record_surprisal_iff`".

```lean
/-- **Equality given the record as real numbers, from the core**: under the hypotheses of
`gap_counts_given_record`, the free energy against the joint shares is the surprisal of the
record's share exactly where the belief in counts is, at every listed hypothesis, the share given
the record, as `freeEnergy_eq_record_surprisal_iff` states; through
`freeEnergy_eq_record_surprisal_iff_of_counts` and `Share.same_iff_toReal_eq`, the share given the
record having the record's weight, positive here, as its whole (`whole_restrict`). -/
theorem freeEnergy_eq_record_surprisal_iff_toReal_of_counts [DecidableEq α] (prior : α → ℕ)
    (lik : α → β → ℕ) {hs : List α} (os : List β) (rec : β → Bool) (distinct : Distinct hs)
    (n : α → ℕ) (positive : 0 < Becoming.total hs n)
    (ruledOut : ∀ h ∈ hs, prior h * mass os (lik h) rec = 0 → n h = 0) :
    freeEnergy hs.toFinset (countBelief hs n) (fun h => (share (openSteps hs os)
        (pairWeight prior lik) (fun c => decide (c.1 = h) && rec c.2)).toReal) =
        surprisal (share (openSteps hs os) (pairWeight prior lik) (fun c => rec c.2)).toReal ↔
      ∀ h ∈ hs, countBelief hs n h = (share (openSteps hs os)
        (ConditionalWeights.restrict (fun c => rec c.2) (pairWeight prior lik))
        (fun c => decide (c.1 = h))).toReal := by
  rw [freeEnergy_eq_record_surprisal_iff_of_counts prior lik os rec distinct n positive ruledOut]
  have Epos : 0 < mass (openSteps hs os) (pairWeight prior lik) (fun c => rec c.2) := by
    rw [FreeEnergyCounting.record_total prior lik hs os rec]
    exact total_pos_of_counts n _ positive ruledOut
  refine forall₂_congr fun h _ => ?_
  rw [Share.same_iff_toReal_eq _ _ positive
    (by rw [show (share (openSteps hs os)
          (ConditionalWeights.restrict (fun c => rec c.2) (pairWeight prior lik))
          (fun c => decide (c.1 = h))).whole =
          mass (openSteps hs os) (pairWeight prior lik) (fun c => rec c.2) from
        whole_restrict _ _ _]; exact Epos)]
  rfl
```

## Completeness: forms the join lacks, and what it reaches

### F5 (completeness). The generative model lacks the bound and its strictness, and no theorem says "one law"

**Where.**
- Subsection "In the core's generative model".
- NOTE §1, third bullet, and §3.
- The board row's purpose: "the principle's central bound stated as one law in its two forms".
- The kit's 03 §6 edit ("in a core generative model the same holds") and the principle's page edit ("The two forms are one law on beliefs in counts").

**What.**
- **The generative model is half covered.** The plain form has the bound, its equality and its strictness from the core. The generative-model form has the identity and the equality only:
  - nothing reads UE17's `record_surprisal_le_freeEnergy` from `bound_given_record`;
  - nothing states the strictness.

  So of UE17's two forms, `freeEnergy_eq_record_surprisal_iff` is matched (with F4) and `record_surprisal_le_freeEnergy` is not. "The same holds" in the kit's 03 §6 edit says more than the Lean.
- **"One law in two forms" rests on the identity.** The equivalence of the two inequalities follows from it, and stating that equivalence makes the item's purpose a theorem. `surprisal_le_freeEnergy_iff_bound` (below) reaches neither the core's `bound` nor any Gibbs lemma (audited): it is the translation alone.

**Fix.**
- Add the three theorems below, compiled in the module's setting. `surprisal_le_freeEnergy_iff_bound` reaches neither the core's bound nor a Gibbs lemma; the other two reach the core's laws and no Gibbs lemma (audited).
- Name them in the module bullet, in NOTE §1–§3 and in the kit's texts.
- With F4's theorem the module goes from 64 theorems in 70 declarations to 68 in 74, or 70 in 76 with the optional witnesses of F2 and F6.

```lean
/-- **The two bounds are one at a belief in counts**: under the hypotheses of `gap_counts`, the
surprisal of the total weight is at most the free energy exactly where the counting bound holds.
Neither bound is used: the equivalence is `gap_counts` and the logarithm's order. -/
theorem surprisal_le_freeEnergy_iff_bound [DecidableEq α] (n a : α → ℕ) {hs : List α}
    (distinct : Distinct hs) (positive : 0 < Becoming.total hs n)
    (support : ∀ h ∈ hs, a h = 0 → n h = 0) :
    surprisal (∑ h ∈ hs.toFinset, (a h : ℝ)) ≤
        freeEnergy hs.toFinset (countBelief hs n) (fun h => (a h : ℝ)) ↔
      Becoming.total hs n ^ Becoming.total hs n * FreeEnergyCounting.powerProduct a n hs ≤
        Becoming.total hs a ^ Becoming.total hs n * FreeEnergyCounting.powerProduct n n hs := by
  have gap := gap_counts n a distinct positive support
  have Lpos := counting_lhs_pos n a support
  have Npos : (0 : ℝ) < Becoming.total hs n := Nat.cast_pos.mpr positive
  have Rpos : 0 < Becoming.total hs a ^ Becoming.total hs n *
      FreeEnergyCounting.powerProduct n n hs :=
    Nat.mul_pos (pow_pos (total_pos_of_counts n a positive support) _)
      (FreeEnergyCounting.powerProduct_self_pos n hs)
  constructor
  · intro le
    have logs : Real.log ((Becoming.total hs n ^ Becoming.total hs n *
        FreeEnergyCounting.powerProduct a n hs : ℕ) : ℝ) ≤
        Real.log ((Becoming.total hs a ^ Becoming.total hs n *
          FreeEnergyCounting.powerProduct n n hs : ℕ) : ℝ) := by nlinarith
    exact_mod_cast (Real.log_le_log_iff (Nat.cast_pos.mpr Lpos) (Nat.cast_pos.mpr Rpos)).mp logs
  · intro le
    have logs := Real.log_le_log (Nat.cast_pos.mpr Lpos) (Nat.cast_le.mpr le)
    nlinarith

/-- **The bound given the record, from the core**: under the hypotheses of
`gap_counts_given_record`, the surprisal of the record's share is at most the free energy against
the joint shares, as `record_surprisal_le_freeEnergy` states, here read from
`FreeEnergyCounting.bound_given_record`. -/
theorem record_surprisal_le_freeEnergy_of_counts [DecidableEq α] (prior : α → ℕ)
    (lik : α → β → ℕ) {hs : List α} (os : List β) (rec : β → Bool) (distinct : Distinct hs)
    (n : α → ℕ) (positive : 0 < Becoming.total hs n)
    (ruledOut : ∀ h ∈ hs, prior h * mass os (lik h) rec = 0 → n h = 0) :
    surprisal (share (openSteps hs os) (pairWeight prior lik) (fun c => rec c.2)).toReal ≤
      freeEnergy hs.toFinset (countBelief hs n) (fun h => (share (openSteps hs os)
        (pairWeight prior lik) (fun c => decide (c.1 = h) && rec c.2)).toReal) := by
  have gap := gap_counts_given_record prior lik os rec distinct n positive ruledOut
  have le := Real.log_le_log (Nat.cast_pos.mpr (counting_lhs_pos n _ ruledOut))
    (Nat.cast_le.mpr (FreeEnergyCounting.bound_given_record prior lik hs os rec n))
  have Npos : (0 : ℝ) < Becoming.total hs n := Nat.cast_pos.mpr positive
  nlinarith

/-- **Away from the share given the record the bound is strict, from the core**: under the
hypotheses of `gap_counts_given_record`, where some count over the total is not the same ratio as
its hypothesis's share given the record. -/
theorem record_surprisal_lt_freeEnergy_of_counts [DecidableEq α] (prior : α → ℕ)
    (lik : α → β → ℕ) {hs : List α} (os : List β) (rec : β → Bool) (distinct : Distinct hs)
    (n : α → ℕ) (positive : 0 < Becoming.total hs n)
    (ruledOut : ∀ h ∈ hs, prior h * mass os (lik h) rec = 0 → n h = 0)
    (apart : ¬ ∀ h, h ∈ hs → Share.Same ⟨n h, Becoming.total hs n⟩ (share (openSteps hs os)
        (ConditionalWeights.restrict (fun c => rec c.2) (pairWeight prior lik))
        (fun c => decide (c.1 = h)))) :
    surprisal (share (openSteps hs os) (pairWeight prior lik) (fun c => rec c.2)).toReal <
      freeEnergy hs.toFinset (countBelief hs n) (fun h => (share (openSteps hs os)
        (pairWeight prior lik) (fun c => decide (c.1 = h) && rec c.2)).toReal) := by
  have gap := gap_counts_given_record prior lik os rec distinct n positive ruledOut
  have lt := Real.log_lt_log (Nat.cast_pos.mpr (counting_lhs_pos n _ ruledOut))
    (Nat.cast_lt.mpr (Nat.lt_of_le_of_ne
      (FreeEnergyCounting.bound_given_record prior lik hs os rec n)
      fun eq => apart ((FreeEnergyCounting.given_record_eq_iff_share prior lik os rec n
        distinct).mp eq)))
  have Npos : (0 : ℝ) < Becoming.total hs n := Nat.cast_pos.mpr positive
  nlinarith
```

### F6 (completeness). What each hypothesis of `gap_counts` does

**Where.** `gap_counts`, and the docstrings that cite "the hypotheses of `gap_counts`"; NOTE §3 ("listings with repetition") and §4 ("Refutation").

**What.**
- **`Distinct` is needed for the identity itself**, not only for the join to the share. With `true` listed twice and every count and weight one, `N` times the gap is `−log 2` while the log ratio is `0` (below; compiled). The real side sums over the set of hypotheses, the core's over the listing. The NOTE cites only UE21's `Witness.duplicate_share`, which is about the share.
- **`positive` is not needed for the identity**: at total nothing both sides are `0` (a probe proves `gap_counts` without it). It is needed for two other things:
  - the reading, since a belief has total one;
  - the case of equality. No counts against weights nothing and two are vacuously in proportion, while the free energy (`0`, by `x / 0 = 0`) is not the surprisal (`−log 2`) (probe).
- **`support` is sufficient, not necessary** (F2). It is needed for the two cases of equality to agree, even where the identity holds.
- **Optional:** `proportional_iff_posterior` needs only `0 < total hs a` in place of `support`.

**Fix.**
- **NOTE §4, Refutation:** "…the free-energy reading needs a positive total, the support and the hypotheses listed once, each a hypothesis of the Lean. The last two are needed for the identity itself (`Witness.gap_counts_duplicate`, or this review if that witness is not added; `Witness.gap_counts_off_support`). At total nothing both sides are `0`, so positivity serves the reading and the case of equality, where counts of total nothing would be in proportion to every weighting."
- **NOTE §3, the repetition item.** Add: "and the identity itself fails there (`Witness.gap_counts_duplicate`, or this review): the real side sums over the set of hypotheses, the core's over the listing."
- **Optionally**, add the witness:

```lean
/-- **A hypothesis listed twice breaks the identity**: with `true` listed twice and every count and
weight one, `N` times the gap is `−log 2`, the real side summing over the set of hypotheses, while
the log ratio, over the listing, is `0`. -/
theorem gap_counts_duplicate :
    (Becoming.total [true, true] (fun _ : Bool => 1) : ℝ) *
        (freeEnergy [true, true].toFinset (countBelief [true, true] (fun _ : Bool => 1))
            (fun h => ((fun _ : Bool => 1) h : ℝ)) -
          surprisal (∑ h ∈ [true, true].toFinset, ((fun _ : Bool => 1) h : ℝ))) = -Real.log 2 ∧
      Real.log ((Becoming.total [true, true] (fun _ : Bool => 1) ^
          Becoming.total [true, true] (fun _ : Bool => 1) *
          FreeEnergyCounting.powerProduct (fun _ : Bool => 1) (fun _ : Bool => 1) [true, true] : ℕ) :
            ℝ) -
        Real.log ((Becoming.total [true, true] (fun _ : Bool => 1) ^
          Becoming.total [true, true] (fun _ : Bool => 1) *
          FreeEnergyCounting.powerProduct (fun _ : Bool => 1) (fun _ : Bool => 1) [true, true] : ℕ) :
            ℝ) = 0 := by
  refine ⟨?_, sub_self _⟩
  simp [freeEnergy, surprisal, countBelief, Becoming.total]
```

### F7 (completeness). What the join does not reach, beyond irrational shares

**Where.** Module docstring, what is not derived: "The counting form reaches only beliefs in counts over hypotheses listed once: beliefs with irrational shares are not read from it." NOTE §3, Does not show. The kit's new does-not-show item for free-energy-bounds-surprisal.

**What.**
- **Weights.** The join needs natural joint weights.
  - Through `gap_div` it extends to natural weights divided by one amount, that is, to rational weights, though no theorem states that case.
  - Weights whose ratios are irrational, such as one and `√2`, are not reached, even for beliefs in counts.
- **A record weighing nothing is excluded by the hypotheses.** A positive total with no count where a weight is nothing forces the record's weight positive (`total_pos_of_counts`), as UE17's `record_pos_of_belief` does. UE21's degenerate case (`nothing_record_reach_all`) is therefore not read through the logarithm.
- **Optional.** Over beliefs in counts of every total, the least free energy is the surprisal, reached exactly in proportion. This is implied (the bound, its equality, and the joint weights themselves as counts) but not stated as one theorem.

**Fix.**
- **Module docstring:** "The counting form reaches only beliefs in counts over hypotheses listed once, against natural joint weights or, by `gap_div`, natural weights divided by one amount: beliefs with irrational shares, and joint weights whose ratios are irrational, are not read from it."
- **NOTE §3, Does not show**, add:
  - "joint weights whose ratios are irrational";
  - "a record weighing nothing, which the hypotheses exclude (`total_pos_of_counts`)".
- **The kit:** extend the new does-not-show item the same way.

### F8 (completeness). Records and texts at landing

**Where.** NOTE §5 and the kit's `make_records_ue22.py` and `texts_ue22.py`.

**What and fix.**
- **free-energy-bounds-surprisal, first hypothesis.** "Share.toReal and its two lemmas among them" goes stale, since `Share.same_iff_toReal_eq` is a third periphery lemma in the core's namespace. Write "Share.toReal and its three lemmas". The kit does not change it.
- **free-energy-bounds-surprisal, `dependencies`.** The module now reuses UE21's declarations: `powerProduct`, `self_pow_pos`, `bound`, `bound_eq_iff`, `bound_lt_of_not_proportional`, `joint`, `record_total`, `bound_given_record`, `given_record_eq_iff_share`, and the witnesses' `even` and `secondOnly`. Add `{"id": "free-energy-bound-in-counts", "relation": "formal-reuse", …}` naming them. Without it, the theory graph does not show the real bound at beliefs in counts resting on the core's. The kit adds only a proof binding, references and the `related` detail.
- **The two `related` details** (the kit's `related_c` and `related_fe`, "on the support this bound is it through the logarithm"): add "over hypotheses listed once". The core's bound holds for any listing; the join does not (F6). The kit's new second hypothesis of the counts record already says it.
- **Counts record, first does-not-show item** (the kit's `c_dns0`): as in F2.
- **The new counterexample**: as in F3.
- **If F4–F6 land:** the laws' counts ("23 new declarations", "70") and the history lines change with them.
- **Board row:** F2's statement, and the citation fix in F11.

## Wording

### F9 (wording). The reading in NOTE §1 and in the kit's study and texts

**Where.** NOTE §1's "[AI reading, D45]" paragraph and its first paragraph; `study_ue22.txt`, Readings; `texts_ue22.py`, the 03 §6, 08 and principle's page edits ("the two one law on beliefs in counts", "for beliefs in counts the real form is its logarithm", "The two forms are one law on beliefs in counts").

**Fix.**
- "So for beliefs in counts the principle's bound is one law in two forms" → "So for beliefs in counts, on the support and over hypotheses listed once, the principle's bound is one law in two forms (`surprisal_le_freeEnergy_iff_bound`, if F5 adds it)". Put the same conditions in the three kit texts.
- "by exactly `1 / N` times the logarithm of how far the counting bound's right side exceeds its left" → "by exactly `1 / N` times the logarithm of the ratio of the counting bound's right side to its left".
- "The real form adds the logarithm and the beliefs whose shares are not ratios of counts; on beliefs in counts it adds no law to the core." → "The real form adds the logarithm, the beliefs whose shares are not ratios of counts and the weights whose ratios are irrational. On beliefs in counts, on the support and over hypotheses listed once, its bound, equality and strictness add no law to the core's, while the core's bound also holds off the support and for any listing, where the real form does not follow it."
- "so the free-energy gap per count is the divergence by which the model misses the frequencies" → "so the free-energy gap, the log ratio per count, is the divergence by which the model misses the frequencies".
- §1's first paragraph omits two of UE17's hypotheses. Write "for a nonnegative belief `q` with total one and nonnegative joint weights `p`, `q` zero wherever `p` is".

### F10 (wording). The module docstring and SCOPE, smaller points

- **Introduction.** "For beliefs in counts the bound itself is read from the core" → "For beliefs in counts over hypotheses listed once, on the support, the bound itself is read from the core".
- **"None of the three"** follows four theorem names; F1's text says "these four".
- **Commitments.** "Discrete causes, natural weights in the core and Boolean records are the representation's commitments" → "Discrete causes, natural weights and counts in the core, `0 ^ 0 = 1` and Boolean records are the representation's commitments".
- **`surprisal_lt_freeEnergy_of_counts`' docstring** omits its hypotheses. Add "under the hypotheses of `gap_counts`".
- **SCOPE and the kit's first law.** "the counting bound's two sides differing by its exponential" → "differing by the exponential of the total times that divergence".
- **Optional.** The bullet on the quantities names `freeEnergy_congr`; name `freeEnergy_congr_weights` beside it.

### F11 (wording). Citations

- **Which REVIEW-UE21 finding asked for the join.** NOTE §1 says "UE21's review (F7) asked for it", and the board row says "UE21's review F7". The join was asked for in REVIEW-UE21's F6 ("Add it at `FreeEnergyReals`' next change, with F7(a)"); F7(a) asked for the docstring. Write "(F6, with F7(a))".
- **The method-of-types reading is correct.** Dividing `counts_eq_mul_exp` by `N^N · A^N` gives `Q^N(x) = P^N(x) · exp(−N · D(P ‖ Q))`, with `P = n/N`, `Q = a/A` and `x` a sequence with these counts. That is Cover and Thomas (2006), Theorem 11.1.2 in §11.1, in base 2 there. It is labelled: "Correspondence (an AI reading)" in the module, the Lean convention, and "[AI reading, D45]" in the NOTE.
- **Uncited references.**
  - Csiszár and Körner (1981) is in the NOTE's references and cited nowhere. Cite it where the method of types is named (its section on types) or drop it.
  - Cauchy, Gibbs and Kullback–Leibler are listed but not cited in the body. Cite them in §4 where the arithmetic–geometric mean inequality, Gibbs' inequality and the divergence are named.
- **The "classical" equivalence carries no source.** For "the equivalence of the arithmetic–geometric mean inequality with Gibbs' inequality for rational distributions is classical", give a source, or say what it is: Gibbs' inequality is the weighted mean inequality with the belief's shares as weights and the ratios of posterior to belief as values, and with rational weights that is Cauchy's unweighted inequality by repetition (REVIEW-UE21, F8). `study_ue22.txt`'s Standing repeats the sentence.

## Optional

### F12 (optional). UE17's own sentences in the same docstring and scope

UE17's sentences have the shape F2 corrects:
- in the equality bullet, "Off the support the bound fails (`Witness.bound_fails_off_support`)";
- in what is not derived, "with Mathlib's `log 0 = 0`, the bound fails";
- in the SCOPE, "off that support the bound fails".

The real bound holds in 916 of the 1,989 off-support small cases, and always at one count. Historical results keep their scope, but this change edits the docstring and the scope anyway, so "can fail" costs nothing here. The owner decides.

### F13 (optional). Placement and naming

- **The section is the right place.**
  - REVIEW-UE21 asked for the join at this module's next change, with its docstring.
  - The module's subject is the real free energy joined to the core.
  - A new module would be a leaf that nothing imports, which board rule 9 asks a row to justify.
  - The cost is nil: `ExpectedFreeEnergyReals`' closure gains `Becoming.FreeEnergyCounting`.
- **The names are structural and exact**, and none is dualist, social or financial.
  - `countBelief` uses the module's term for `q` (precedent: `record_pos_of_belief`). It is definitionally `(⟨n h, total hs n⟩ : Share).toReal`, which is why F4's proof closes by `rfl`. A lemma saying so would tie the belief to the core's share (optional).
  - `counting_lhs_pos` follows UE21's `_lhs` names.
  - `Share.same_iff_toReal_eq` sits in the core's namespace, following UE17's `Share.toReal`; the record should say so (F8).
- **`countBelief_nonneg` has no consumer in the module.** Keep it: it is the lemma that lets UE17's theorems be applied to a belief in counts.

## The seven questions, briefly

1. **Statements against their docstrings, the bullet, SCOPE and NOTE.** They are exact, except for the witness (F3), the real-number equality (F4) and the prose in F1 and F2. On the hypotheses: `Distinct` and `support` are needed for the identity, and `positive` only for the reading and the case of equality (F6).
2. **The dependency audit.** Its method is sound and its rows reproduce. The sentence is not exact, and the exact claim is checked (F1).
3. **The method of types and the attributions.** Both are correct and labelled; some references are uncited (F11).
4. **The generative-model theorems.** They read UE17's terms and UE21's two sides exactly, and "the whole weight drops out" is exactly `gap_div` applied in `gap_counts_given_record`. The real-number equality (F4) and the bound and strictness (F5) are missing.
5. **The witness.** It shows only `≠`. Its docstring says more and cites other counts (F3), and "fails" is not general (F2).
6. **Placement and naming.** Both are right (F13).
7. **What is missing.** F5 to F8; stale or overgeneral sentences are covered in F10 and F12.
