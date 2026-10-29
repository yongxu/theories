# Review of UE17: variational free energy and its bound

29 October 2026. This is an AI-written, independent, read-only review of board item UE17, item 2 of [FEP-INTEGRATION](../ue-unified-explanation/FEP-INTEGRATION.md) (that file is on branch `ue16`), read with [AGENTS.md](../../../../../../AGENTS.md).

**Reviewed** (as of 20:53, UTC+7):
- [`FreeEnergyReals.lean`](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/free-energy/FreeEnergyReals.lean) (sha256 `51cd4ad5…77ebaf1`, the receipt's);
- [its checker](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/free-energy/check_free_energy_reals.py), [receipt](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/free-energy/free-energy-reals-verification.json) and [run folder](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/free-energy/free-energy-reals-checks/20261029T134610.999747Z/);
- [DRAFT-NOTES](DRAFT-NOTES.md), [NOTE](NOTE.md), [the record kit](kit/make_records_ue17.py) and [`warm_closure.py`](warm_closure.py).

**Read against:** [`ConditionalWeights`](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ConditionalWeights.lean) (the same bytes as main), [conditioning-by-restriction](../../../../../../theories/becoming/results/records/conditioning-by-restriction.json), UE2's [draft](../../../history/root-foundation/development/ue2-conditional-weights/periphery/ConditionalWeightsReals.lean) and [`check_regime_reals.py`](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/regime/check_regime_reals.py).

**Built:** the module (against the warm-up's core oleans and the pinned Mathlib, Lean 4.30.0-rc2) and a probe importing it, with no error or warning and every probe theorem on the three standard axioms; and a numeric check in Python ([appendix](#appendix-probes)).

## Verdict

The Lean is sound, and each theorem's docstring says what the theorem proves.

- **Receipt.** It passed. Of its 44 declarations (39 theorems), 43 depend on `propext`, `Classical.choice` and `Quot.sound`, and `jointShare_part` depends on none. There is no `sorryAx`, `sorry`, `native_decide` or `axiom`.
- **Hypotheses.** Each theorem carries what its proof needs: nonnegativity, total one, support and a nonzero total. One hypothesis is redundant (F6).
- **Statements.** Each iff runs both ways, and none is vacuous. `Witness.bound_fails_off_support` shows that the support condition cannot be dropped.
- **Quantities.** `freeEnergy s q p` is the variational free energy (natural logarithms; `E_q[ln q − ln p(o, ·)] ≥ −ln p(o)`, minus the evidence lower bound), `surprisal (Σ p)` is the surprisal of the evidence, and the decompositions are divergence plus surprise and complexity less accuracy, with Friston's signs.
- **The join is real.** The printed statements of `givenShare_eq_posterior`, `freeEnergy_eq_record_surprisal_iff` and `minimizes_iff_givenShare` name the core's `share`, `restrict`, `pairWeight`, `openSteps`, `mass` and `Distinct`. Among beliefs with no weight where the joint weight is zero, minimizing free energy against the core's joint shares gives exactly the core's share given the record, with no common likelihood total needed.

The faults are in the prose. Summaries drop the support condition (F1), deny the bound the counting form it has (F2), and call the join one law in two forms (F3). The kit's axiom check is vacuous (F4). The checker is the regime checker with the stated changes plus a new temporary folder prefix, and the receipt says what the notes claim. The drafting receipt cannot land, because main has changed the closure (F5).

**Land after F1–F5. F6–F12 can go with it or follow.**

## Findings

### F1 (O). "Minimizing free energy over beliefs" drops the support condition

- **Where:**
  - `FreeEnergyReals.lean`, lines 14–15 and 66–67;
  - the checker's `SCOPE` (lines 56–58);
  - NOTE §1 (end of the first paragraph) and §3 ("Shows", bullet 2);
  - the kit's `statement` and `RELATED[RIDC]`;
  - `kit/texts_ue17.py` (written at 21:09): "minimizing free energy over beliefs gives exactly that share" and "exact minimization of variational free energy over beliefs reaches it".
- **What the Lean says.** `minimizes_iff` and `minimizes_iff_givenShare` compare only beliefs that are zero wherever the joint weight is. Over all beliefs the claim is false for this `freeEnergy`. In `Witness.bound_fails_off_support`, the belief (½, ½) has free energy −log 2, below the posterior (1, 0)'s 0, because `log 0 = 0` gives the ruled-out cause a finite term.
- **Fix:**
  - Lines 14–15: "minimizing free energy over beliefs that put no weight where the joint weight is zero (elsewhere it is infinite as usually defined), given a record that weighs something, gives the core's share given the record."
  - Lines 66–67: "…over the beliefs where it is finite is exact Bayesian inference."
  - `SCOPE`: "…the one belief with the least free energy among beliefs zero wherever a hypothesis's prior weight times the record's weight under it is zero. Surprisal adds over independent parts whose events each weigh something (share_product)…".
  - NOTE §1, NOTE §3 and the kit's `statement`: "exact minimization of free energy, over beliefs with no weight where the joint weight is zero, is conditioning by restriction".
  - `RELATED[RIDC]`: "…over beliefs with no weight on a hypothesis the prior or the record rules out…".
  - The zh to match.

### F2 (O). The bound has a counting form; "no counting form" says too much

- **Where:**
  - line 11 ("Averages of logarithms have no counting form there.");
  - NOTE §1 ("no counting form in the pure core") and §6 ("Placement");
  - the kit's `next_delta` ("a core form of the bound") and `kit/study_ue17.txt`;
  - the same claim in the core (F7).
- **What holds.** Take a belief with natural counts `n_h` (total `N`), joint masses `a_h = prior h * mass os (lik h) rec`, record mass `A = Σ a_h` and whole `Z`.
  - **The form.** `N` times the free energy is the logarithm of the reciprocal of the share `⟨N^N·∏ a_h^{n_h}, Z^N·∏ n_h^{n_h}⟩`.
  - **The bound.** It is `N^N·∏ a_h^{n_h} ≤ A^N·∏ n_h^{n_h}`: that share is at most the record's share `⟨A, Z⟩` taken `N` times by `Share.mul`.
  - **Equality.** It holds exactly where every `⟨n_h, N⟩` is `Share.Same` as the core's share given the record, `⟨a_h, A⟩`.
  - **Support.** Weight where `a_h = 0` makes the part zero, so this form needs no support condition and has no counterpart of the witness.
  - **Evidence.** Checked on 15,968 small cases, not proved; a proof is the arithmetic–geometric mean inequality on naturals, applied to `n_h` copies of `a_h·∏_{k≠h} n_k`. It is the core form that plan item 2 and `next_delta` name.
- **Fix:**
  - Line 11 and NOTE §1: "The core takes no logarithm and states no average of logarithms."
  - NOTE §6: "the real form needs Mathlib's logarithm; for beliefs with natural counts the bound has a counting form, not stated here."
  - `next_delta`: "a core form of the bound, N^N·∏ a^n ≤ A^N·∏ n^n for beliefs with natural counts, equal exactly at the share given the record."

### F3 (O). "One law in two forms" and "near-definitional"

- **Where:**
  - NOTE §1, its reading: "one law, stated in counting form in the core and in its logarithmic form in the periphery";
  - NOTE §5: "Known and near-definitional … so that one law has a counting form in the core and a logarithmic form in the periphery";
  - the kit's `correspondence`, `kit/texts_ue17.py` and `kit/study_ue17.txt`.
- **What the Lean says.** The core states the posterior (`posterior_single`), not the bound. The periphery proves that the posterior is the bound's one minimizer among supported beliefs. That is a variational characterization of conditioning, as NOTE §4 says, not one law twice. Gibbs' inequality with its equality case is a classical theorem; only the decompositions and the join are near-definitional.
- **Fix:**
  - NOTE §1: "…is the theory's conditioning by restriction: the core states the posterior by counting, the periphery characterizes it as the one minimizer of free energy, and a theorem whose statement names the core's definitions joins them."
  - NOTE §5 and the kit: "Gibbs' inequality and its equality case are classical; the decompositions and the join are near-definitional. New is the join…".
  - Drop "one law … in the periphery".

### F4 (E, in the kit, not the Lean). The kit's axiom check checks nothing

- **Where.** `kit/make_records_ue17.py`: `for d in mod['declarations']: assert set(d.get('axioms', [])) <= STANDARD, d`.
- **What holds.** The receipt's declaration entries carry only `kind` and `name`; the reports are in `modules[0]['axiom_dependencies']`. The loop therefore tests the empty set 44 times, although the kit's docstring says it asserts the axioms. The record is right only because the checker fails on any other axiom.
- **Fix:**

```python
deps = mod['axiom_dependencies']
assert set(deps) == names, sorted(names ^ set(deps))
for name, axioms in deps.items():
    assert set(axioms) <= STANDARD, (name, axioms)
```

### F5 (I). Rerun on the merged head, fresh

- **Where.** The receipt's `source_commit` (main `f1a4f6b81`, with copies of Reserve, Retaining and `check_becoming.py`) and `lean_steps.reused`; NOTE §6 ("Checking").
- **What holds:**
  - **Main has moved.** Main (`84f09acf6` here) holds OU3f's closure: Reserve and Retaining import the new `Becoming.KeptOnward`. On the merged head KeptOnward joins the closure, and the module and 24 of the 56 core modules get new keys (Reserve, Retaining and the 22 after them, ConditionalWeights among them). F1, F6 and F8–F10 change the module's bytes too.
  - **The 51 warm-up steps are sound in substance.** The key covers the binary, the Mathlib revision, the bytes and the imports' keys; the warm-up used the checker's command, environment and pass test; its logs are empty; and board rule 5 allows steps stored by a scratch build.
  - **But their recorded run will vanish.** It is a scratch folder no landed tool wrote, and a non-fresh merged-head run would still cite it for the 27 steps upstream of Reserve and Retaining. A fresh run is cheap (the warm-up took 90 seconds) and re-stores those keys with the landing run as their origin.
- **Fix:**
  1. Land after UE16, or merge `ue16`: NOTE and DRAFT-NOTES link FEP-INTEGRATION, which exists only there, as does the UE17 claim.
  2. Merge main. No core run is needed unless F7(a) is bundled; if it is, that run comes first.
  3. Run `BECOMING_FRESH=1 python3 -B check_free_energy_reals.py`.
  4. Run the kit on the new receipt.
  5. In a clean worktree, render and run `research-check --strict-fresh`, the links check and the tests.

  If reuse is kept instead, land `warm_closure.py` (F11) and name it in the validation scope.

### F6 (I). `positive` is redundant in `minimizes_iff_givenShare`

- **Where.** Lines 600–607 ("where the record weighs something", hypothesis `positive`); DRAFT-NOTES, "Where positivity enters".
- **What the Lean says:**
  - The belief's hypotheses imply it: a belief with total one weighs some hypothesis, whose product is then nonzero, and the record's mass is at least that product. Probe P3 proves this (`record_pos_of_belief`, from `total_pos`, `sum_jointShare` and `weight_zero_of_jointShare_zero`), and P3′ proves the theorem without `positive`.
  - In `freeEnergy_givenShare` the hypothesis is not needed for truth either: where the record weighs nothing both sides are 0 by `x / 0 = 0` and `log 0 = 0` (P4). There it only excludes a degenerate case.
- **Fix:**
  - Add `record_pos_of_belief` and drop `positive`.
  - Open the proof with `have positive := record_pos_of_belief prior lik os rec distinct q hq1 ruledOut`.
  - Replace "where the record weighs something," with "(such a belief exists only where the record weighs something: `record_pos_of_belief`)".
  - In `freeEnergy_givenShare`'s docstring, add: "Where the record weighs nothing both sides are 0 by Mathlib's conventions; the hypothesis excludes that case."
  - In DRAFT-NOTES, say positivity is assumed only in `freeEnergy_givenShare`.

### F7 (I). Texts that go stale when UE17 lands

- **(a) The core docstring.** `ConditionalWeights.lean`, lines 98–101, says averages "have no reciprocal-share form" and free energy is "drafted for the periphery … with no receipt yet (`development/ue2-conditional-weights/periphery`)". Replace that with: "An average of surprisal, such as entropy or free energy, is not the surprisal of one share, since an average of logarithms is not the logarithm of an average; free energy and its bound are stated in the periphery, over the reals, and joined to `posterior_single` there (`lean/free-energy/FreeEnergyReals.lean`)." Only the root imports the module, so either bundle this before F5's run or record it in NOTE §6 as pending for the module's next change.
- **(b) conditioning-by-restriction.** The kit records "no statement, next step or declaration changed", yet three fields go stale:
  - from `next_delta`, drop "the join to the periphery's variational bound once it has a receipt" (zh "外围变分界有回执后与之相接"), which UE17 completes;
  - in `correspondence`, replace "have no such form; free energy and its bound are drafted for the periphery with no receipt" with "are not the logarithm of one reciprocal share; free energy and its bound are stated in the periphery and joined to posterior_single there (free-energy-bounds-surprisal)";
  - in `does_not_show[2]`, replace "averages of logarithms have no reciprocal-share form" with "an average of logarithms is not the logarithm of one reciprocal share".

  The history line then says what changed.
- **(c) UE2's draft.** `ue2-conditional-weights/periphery/` is superseded. Move it to `history/` with `research.py move`, running `--plan` first.
- **(d) FEP-INTEGRATION §2** ("Not stated anywhere in Lean: free energy") is for the plan's owner to change.
- **(e) DRAFT-NOTES** overlaps NOTE. Fold its "Deviations" into NOTE §6 and move it to history, or head it as the drafting record.

### F8 (I). What the principle has that the module does not state

- **Where.** "What is not derived" (lines 73–82); NOTE §3 ("Does not show").
- **What holds.** Both name densities, continuous causes and time, expected free energy, and any descent or message passing, and NOTE adds the Laplace approximation. Neither names:
  1. restricted families of beliefs, such as mean-field or the Laplace approximation's Gaussian, whose least free energy exceeds the surprisal by the family's divergence from the posterior (a reading of `freeEnergy_eq_divergence_add_surprisal`, not a theorem here);
  2. free energy as a bound on the long-run average of surprisal, the entropy of sensory states, which carries the principle's reading of persisting;
  3. free energy over parameters and models, as in learning and model comparison;
  4. the energy-less-entropy form, which gives the quantity its name.
- **Fix.** Name items 1–3 in both places. Add item 4 after the complexity law (probe P2, standard axioms):

```lean
/-- **Energy less entropy**: the `q`-average of `−log p` less the entropy of `q`. -/
theorem freeEnergy_eq_energy_sub_entropy (s : Finset ι) (q p : ι → ℝ) :
    freeEnergy s q p = ∑ i ∈ s, q i * -Real.log (p i) - ∑ i ∈ s, q i * -Real.log (q i) := by
  unfold freeEnergy
  rw [← Finset.sum_sub_distrib]
  exact Finset.sum_congr rfl fun i _ => by ring
```

### F9 (S). Names and placement

- **Folder.** `lean/free-energy/`, with its checker, receipt and run folder, follows `regime/`, `physics/` and `warning/`.
- **`Share.toReal` in the core's namespace** is acceptable. `RegimeReals` sits wholly in `Becoming.RegimeMargin.Drawn`, `lean_catalogue.py` (line 173) and `completion.py` (line 156) strip `_root_.`, and the kit cites the definition under the module's path.
  - Its lemmas `toReal_nonneg` and `toReal_mul` (lines 389–403) sit in `Becoming.FreeEnergy`, so `a.toReal_mul` does not resolve. Declare them as `_root_.Becoming.ConditionalWeights.Share.toReal_nonneg` and `…Share.toReal_mul`.
  - The record should say that `Share.toReal` is a periphery definition that depends on the three axioms.
- **`freeEnergy` and `divergence`** have one body: P1 is `rfl`, and `divergence_nonneg` and `divergence_eq_zero_iff` use it. Define `freeEnergy s q p := divergence s q p` ("the divergence of `q` from the joint weights, whose total need not be one"), or state `freeEnergy_eq_divergence … := rfl`.
- **`minimizes_iff`** → `minimizes_iff_posterior`, beside `minimizes_iff_givenShare`.
- **The module's name.** Board rule 8 names a correspondence module after its core law, and REVIEW-UE2 proposed `ConditionalWeightsReals`. `FreeEnergyReals` follows `EntropyProduction` instead, which is exact for laws of free energy. NOTE §6 should say so.
- **To the core.** `jointShare_part` is about naturals only and has an empty axiom report; it can move beside `posterior_single` at the next change of ConditionalWeights. Nothing else needs to move, and F2 gives the substantive core form.

### F10 (S). Conventions at zero, where a reading fails

- **Where:** `surprisal` (lines 103–104), `surprisal_eq_log_reciprocal` (405–409) and `freeEnergy_eq_complexity_sub_accuracy` (341–355).
- **What the Lean says.**
  - `surprisal 0 = 0`, so `surprisal_eq_log_reciprocal` holds for a share with part 0 with both sides 0, where surprisal is usually infinite.
  - The complexity identity holds for any real `prior`, but `divergence s q prior` is nonnegative only where `prior` has total one.
- **Fix:**
  - `surprisal`: "…read for a positive amount; `surprisal 0 = 0` by `log 0 = 0`, where surprisal is usually infinite."
  - The complexity docstring: "…the divergence of `q` from the prior (the complexity, nonnegative where the prior has total one: `divergence_nonneg`)…".

### F11 (S). `warm_closure.py`, and how the checker is described

- **Where.** `warm_closure.py`'s docstring; DRAFT-NOTES ("everything else is identical").
- **What holds.** The script says it is "not part of the repository" but sits in it. It hard-codes the drafting worktree and writes `work/` (sources and oleans) and `warm-logs/` beside itself, so if run from `_process/` it would put build output in the repository. `scratch_build.py` cannot replace it, because its context lacks the Mathlib revision. The checker also changed its temporary folder's prefix (line 149), which is harmless.
- **Fix.**
  - Keep the script as the drafting record, with this docstring: "Kept as the record of the warm-up the drafting receipt reused. Run only from a scratch copy: W names the drafting worktree, and it writes work/ and warm-logs/ beside itself."
  - DRAFT-NOTES: "…docstring and the temporary folder's prefix".

### F12 (I, not for UE17). The closure is matched by text

- **Where.** `passed_receipts` (lines 80–88) and line 140, as in `check_regime_reals.py`.
- **What holds.** Any JSON under the Lean root that contains `"passed"` counts, and a module matches wherever its digest appears, kept copies included. The core checker's `passed_receipts` and `receipts_for` bind name, path and digest. Here all 56 modules match `becoming/becoming-verification.json`, so the notes' claim holds.
- **Fix.** In both periphery checkers, as a change of its own: `receipts = core.passed_receipts((RECEIPT, RETAINED))` and `found = core.receipts_for(name, paths[name], receipt["source_sha256"][name], receipts)`.

## Appendix: probes

The probes were kept in the volatile scratchpad (`/private/tmp/claude-501/-Users-ren-theories/7e73c253-c642-4ddd-ad8f-cc6d011978ec/scratchpad/ue17review/`). The module was copied there and compiled with `./build.sh -o FreeEnergyReals.olean FreeEnergyReals.lean`, and then the probe with `./build.sh ReviewProbe.lean`.

- **The probe's output:** four `#print axioms` lines, each `[propext, Classical.choice, Quot.sound]`, and no error or warning.
- **`python3 -I counting_form.py` printed:** `{'cases': 15968, 'equalities': 312, 'off_support': 6400}`.

### build.sh

```sh
#!/bin/zsh
# Review probe: compile a file in this folder against the warmed core oleans and the pinned Mathlib.
S=/private/tmp/claude-501/-Users-ren-theories/7e73c253-c642-4ddd-ad8f-cc6d011978ec/scratchpad
PR=$S/ue17review
P=$HOME/repos/生生不息/.lake/packages
LP=$PR:$S/ue17/work
for d in $P/*; do [ -d $d/.lake/build/lib/lean ] && LP=$LP:$d/.lake/build/lib/lean; done
cd $PR
LEAN_PATH=$LP $HOME/.elan/toolchains/leanprover--lean4---v4.30.0-rc2/bin/lean "$@"
```

### ReviewProbe.lean

```lean
import FreeEnergyReals

/-! Review probe for UE17 (read-only review; nothing here is proposed as a result by itself). -/

namespace Becoming.FreeEnergy.ReviewProbe

open Becoming.ConditionalWeights

/-- P1. The two definitions are one function: free energy is the divergence from the joint. -/
example {ι : Type*} (s : Finset ι) (q p : ι → ℝ) : freeEnergy s q p = divergence s q p := rfl

/-- P2. Energy less entropy, with no hypothesis. -/
theorem freeEnergy_eq_energy_sub_entropy {ι : Type*} (s : Finset ι) (q p : ι → ℝ) :
    freeEnergy s q p = ∑ i ∈ s, q i * -Real.log (p i) - ∑ i ∈ s, q i * -Real.log (q i) := by
  unfold freeEnergy
  rw [← Finset.sum_sub_distrib]
  exact Finset.sum_congr rfl fun i _ => by ring

variable {α : Type*} {β : Type*}

/-- P3. A belief over the listed hypotheses with total one, zero wherever a hypothesis's prior
weight times the record's weight under it is zero, already makes the record weigh something. -/
theorem record_pos_of_belief [DecidableEq α] (prior : α → ℕ) (lik : α → β → ℕ) {hs : List α}
    (os : List β) (rec : β → Bool) (distinct : Distinct hs) (q : α → ℝ)
    (hq1 : ∑ h ∈ hs.toFinset, q h = 1)
    (ruledOut : ∀ h ∈ hs, prior h * mass os (lik h) rec = 0 → q h = 0) :
    0 < mass (openSteps hs os) (pairWeight prior lik) (fun c => rec c.2) := by
  have total := total_pos hs.toFinset q (fun h => (share (openSteps hs os) (pairWeight prior lik)
      (fun c => decide (c.1 = h) && rec c.2)).toReal) hq1 (fun _ _ => toReal_nonneg _)
      fun h mem zero => ruledOut h (List.mem_toFinset.mp mem)
        (weight_zero_of_jointShare_zero prior lik os rec distinct (List.mem_toFinset.mp mem) zero)
  rw [sum_jointShare prior lik os rec distinct] at total
  rcases Nat.eq_zero_or_pos (mass (openSteps hs os) (pairWeight prior lik) (fun c => rec c.2))
    with zero | positive
  · exfalso
    have : (share (openSteps hs os) (pairWeight prior lik) (fun c => rec c.2)).toReal = 0 := by
      show ((mass (openSteps hs os) (pairWeight prior lik) (fun c => rec c.2) : ℕ) : ℝ) / _ = 0
      rw [zero, Nat.cast_zero, zero_div]
    linarith
  · exact positive

/-- P3'. So `minimizes_iff_givenShare` holds without its hypothesis `positive`. -/
theorem minimizes_iff_givenShare' [DecidableEq α] (prior : α → ℕ) (lik : α → β → ℕ)
    {hs : List α} (os : List β) (rec : β → Bool) (distinct : Distinct hs)
    (q : α → ℝ) (hq : ∀ h ∈ hs, 0 ≤ q h) (hq1 : ∑ h ∈ hs.toFinset, q h = 1)
    (ruledOut : ∀ h ∈ hs, prior h * mass os (lik h) rec = 0 → q h = 0) :
    (∀ q' : α → ℝ, (∀ h ∈ hs, 0 ≤ q' h) → ∑ h ∈ hs.toFinset, q' h = 1 →
        (∀ h ∈ hs, prior h * mass os (lik h) rec = 0 → q' h = 0) →
        freeEnergy hs.toFinset q (fun h => (share (openSteps hs os) (pairWeight prior lik)
            (fun c => decide (c.1 = h) && rec c.2)).toReal) ≤
          freeEnergy hs.toFinset q' (fun h => (share (openSteps hs os) (pairWeight prior lik)
            (fun c => decide (c.1 = h) && rec c.2)).toReal)) ↔
      ∀ h ∈ hs, q h = (share (openSteps hs os)
        (ConditionalWeights.restrict (fun c => rec c.2) (pairWeight prior lik))
        (fun c => decide (c.1 = h))).toReal :=
  minimizes_iff_givenShare prior lik os rec distinct
    (record_pos_of_belief prior lik os rec distinct q hq1 ruledOut) q hq hq1 ruledOut

/-- P4. Where the record weighs nothing, both sides of `freeEnergy_givenShare` are zero by
Mathlib's conventions: its hypothesis `positive` keeps the law off a degenerate case rather
than being needed for its truth. -/
theorem freeEnergy_givenShare_degenerate [DecidableEq α] (prior : α → ℕ) (lik : α → β → ℕ)
    {hs : List α} (os : List β) (rec : β → Bool) (distinct : Distinct hs)
    (nothing : mass (openSteps hs os) (pairWeight prior lik) (fun c => rec c.2) = 0) :
    freeEnergy hs.toFinset
        (fun h => (share (openSteps hs os)
          (ConditionalWeights.restrict (fun c => rec c.2) (pairWeight prior lik))
          (fun c => decide (c.1 = h))).toReal)
        (fun h => (share (openSteps hs os) (pairWeight prior lik)
          (fun c => decide (c.1 = h) && rec c.2)).toReal) = 0 ∧
      surprisal (share (openSteps hs os) (pairWeight prior lik) (fun c => rec c.2)).toReal = 0 := by
  have ev : mass hs (fun h => prior h * mass os (lik h) rec) (fun _ => true) = 0 := by
    rw [← evidence prior lik hs os rec]; exact nothing
  constructor
  · unfold freeEnergy
    refine Finset.sum_eq_zero fun h mem => ?_
    dsimp only
    rw [givenShare_toReal prior lik os rec distinct (List.mem_toFinset.mp mem), ev, Nat.cast_zero,
      div_zero, zero_mul]
  · show -Real.log (((mass (openSteps hs os) (pairWeight prior lik) (fun c => rec c.2) : ℕ) : ℝ) /
      _) = 0
    rw [nothing, Nat.cast_zero, zero_div, Real.log_zero, neg_zero]

end Becoming.FreeEnergy.ReviewProbe

#print axioms Becoming.FreeEnergy.ReviewProbe.freeEnergy_eq_energy_sub_entropy
#print axioms Becoming.FreeEnergy.ReviewProbe.record_pos_of_belief
#print axioms Becoming.FreeEnergy.ReviewProbe.minimizes_iff_givenShare'
#print axioms Becoming.FreeEnergy.ReviewProbe.freeEnergy_givenShare_degenerate
```

### counting_form.py

```python
"""Review probe for UE17: the variational bound in counting form, checked exhaustively on small cases.

A belief with natural counts n_i (total N) against natural joint weights a_i (total A) satisfies
    N^N * prod a_i^{n_i} <= A^N * prod n_i^{n_i}        (0^0 = 1),
which is N times Gibbs' inequality exponentiated; equality exactly where n_i * A = N * a_i for every i
(the belief is the posterior), and a belief putting weight where a_i = 0 makes the left side 0, so no
support hypothesis is needed. The real form is also compared, with log 0 = 0 as in Mathlib."""
from fractions import Fraction
from itertools import product
from math import log, prod

checked = equalities = off_support = 0
for k in (1, 2, 3):
    for a in product(range(0, 5), repeat=k):
        A = sum(a)
        if A == 0:
            continue
        for n in product(range(0, 5), repeat=k):
            N = sum(n)
            if N == 0:
                continue
            left = N ** N * prod(x ** m for x, m in zip(a, n))
            right = A ** N * prod(m ** m for m in n)
            assert left <= right, (a, n)
            posterior = all(m * A == N * x for x, m in zip(a, n))
            assert (left == right) == posterior, (a, n)
            equalities += left == right
            supported = all(x > 0 for x, m in zip(a, n) if m > 0)
            if supported:
                # the real form: F = sum q (log q - log p) >= -log sum p, p = a / Z with Z = A + 3
                Z = A + 3
                F = sum((m / N) * (log(m / N) - log(x / Z)) for x, m in zip(a, n) if m > 0)
                assert F >= -log(A / Z) - 1e-12, (a, n)
                assert abs(N * F - log(Fraction(Z ** N * prod(m ** m for m in n),
                                                 N ** N * prod(x ** m for x, m in zip(a, n))))) < 1e-9
            else:
                off_support += 1
                assert left == 0
            checked += 1
print({"cases": checked, "equalities": equalities, "off_support": off_support})
```
