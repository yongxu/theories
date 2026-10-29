# Review of UE19: expected free energy within a lumping

29 October 2026. Independent review, AI-written, of `Becoming.LumpedSeeking` ([module](tree/Becoming/LumpedSeeking.lean), [build](scratch-5.log)) and `ExpectedFreeEnergyReals` ([draft](periphery/ExpectedFreeEnergyReals.lean), [axioms](periphery/probe-1.log)), against the [NOTE](NOTE.md), candidate 7 of the [search](../ue1-fep-bridge/THIRD-PART-SEARCH.md), item 4 of the [plan](../ue-unified-explanation/FEP-INTEGRATION.md), `ConditionalWeights`, `Learning`, [03 §6](../../../../../../theories/becoming/chapters/03-KNOWING.md#r-generalization-through-lumping) and UE17's `FreeEnergyReals`. Wen (2025), Da Costa and others (2020) and Parr and Friston (2019) were read at the source. Of Friston and others (2015) only the abstract was reachable, so its T-maze is taken from later work that reproduces it. The probes' scratch trees are not kept; their sources are below.

## Verdict

The Lean is sound and reports what the NOTE says. Rebuilt with a probe (the cached compile and audit of identical bytes reused), the core module has 8 theorems in 17 declarations, all with empty axiom reports. The probe's 9 theorems in 14 declarations are empty too, with no warnings. The periphery module compiles against the pinned Mathlib after UE17's, with no warnings. Its 13 declarations and the probe's 10 report exactly `propext`, `Classical.choice` and `Quot.sound`. No hypothesis is unsatisfiable: the Coin witness instantiates every hypothesis of `error_kept`, and `separating_corrects` shows the tie is needed. The definitions are Parr and Friston's (2019), and the identities hold as stated.

The text says more than the Lean in four places, which must be fixed before landing:
- the reading "what the likelihood lumps, no outcome sought separates" is false of the principle's own T-maze unless the tie holds under every policy, and the core models no seeking (F1);
- "nothing to learn on what the likelihood lumps" is proved only where one likelihood serves every state the policy reaches (F2);
- the core laws are corollaries of landed laws, so as they stand they are not another result (F3);
- Da Costa and others define risk over states, so the exact identity is not theirs (F4).

With F1's qualification, the third part against candidate 7 is a fair forbidding, graded (b), weak. It forbids Wen's wording, not active inference's own account (F10). F5 to F11 are improvements. F5, together with the fixes for F1 and F2, lets UE19 meet the quantity Wen names and explain more.

## Findings

**F1 (O). Seeking needs ties under every policy, and a law about seeking** (core header l. 20–21; NOTE §1, reading). The core law concerns one likelihood and one record. "Records of many outcomes are records on a product domain" covers a fixed design, not seeking. In active inference a policy chooses which states the outcomes come from, and so which likelihood. In the T-maze (Friston and others 2015, as later work reproduces it), the likelihood at the centre ties the two contexts and the likelihood at the cue separates them, so the epistemic term takes the agent to the cue. Read literally, the reading is false of the principle's standard example. What holds is narrower: what every experiment the agent can choose ties, no seeking separates. This holds even when each experiment is chosen from the record so far, because the choice reads only the record ([selection through couplings](../../../../../../theories/becoming/chapters/03-KNOWING.md#r-selection-through-couplings)). *Fix:*
- add P2. `seekWeight` weighs a course of seeking under a hypothesis: at each step, the weight of choosing an experiment, read from the course so far, times the outcome's weight under that experiment. The choice weights are the same under every hypothesis, so they cancel. `seek_lumped` and `seeking_keeps_error` follow;
- reword the header and the reading to "tied under every policy the agent can take", and cite the T-maze as the case that seeking does correct.

**F2 (O). The epistemic value of a lumped distinction** (`epistemic_eq_zero_of_lumped`, l. 181–198; NOTE §1, §3). The theorem needs one likelihood for every state of nonzero weight, that is, a policy whose outcomes read nothing. The NOTE's "nothing to learn on what the likelihood lumps" speaks of one distinction among others. *Fix:* add Q1. Where the likelihood reads a state only through its class (`A s = B (π s)`), the epistemic value and the expected free energy are those of the coarse variable: the classes, with their total weights (`epistemic_through`, `efe_through`). Two beliefs alike on the classes then score the policy alike, so no choice by expected free energy turns on how weight is split within a class (`efe_same_of_coarse`). `epistemic_eq_zero_of_lumped` is the one-class case. This states plan item 4 in the principle's own terms.

**F3 (O). The core laws instance landed laws** (l. 46–108; NOTE §4–§5). Each core law follows from a landed one:
- `lumped_mass` is the pointwise form of "a valuation through the map gives tied alternatives equal values" (`Relabel.EquivariantValue.tied`, law 4 of [selection through a model of the options](../../../../../../theories/becoming/chapters/03-KNOWING.md#r-selection-through-a-model-of-the-options)). It is pointwise because equating the likelihoods as functions would take `funext`;
- `posterior_le_iff_prior` is `posterior_le_iff_single` with a positive common factor cancelled;
- `posterior_ratio_kept` is `posterior_single` applied twice;
- `error_kept` is the contrapositive.

What a record contributes, its weight under each hypothesis, is a valuation through the likelihood. The third part is then law 6 of that record (`Learning.selects_not_right_of_parted`) with the likelihood as the map, and the prior supplies the rest. The formal parent is not `determines_lumped_iff`, which fixes values at untried inputs, so "the counting form of generalization through a lumping" is an analogy. The docstring states it, and "what changes a lumping is what couples in", without an AI label. As they stand, the core laws are a wrapper. *Fix:* either carry F1's seeking form, which no landed law states, and cite [conditioning by restriction](../../../../../../theories/becoming/chapters/03-KNOWING.md#r-conditioning-by-restriction) and the record above as its basis, or fold the core laws into the periphery record as its counting form. Label both readings. Standing: known, identification (Rothenberg 1971) in its Bayesian form (Poirier 1998).

**F4 (O). Whose definitions** (periphery header l. 6–7; NOTE §1, §4 and references). Parr and Friston (2019) define risk over outcomes and ambiguity as the expected entropy of the likelihood, and they call the epistemic term a mutual information (their Eq. 20). Those are the module's definitions, and the identity is exact for them. Da Costa and others (2020) define risk over states (Eq. 10) and reach the outcome form only by assuming a divergence small (Eq. 15); their epistemic terms are salience and novelty (Eq. 16). Friston and others (2015) split a policy's quality into extrinsic and epistemic value. *Fix:*
- cite each source for what it states;
- write the author as "Wen, B." and cite arXiv v1 (7 August 2025);
- drop "structure learning" for Wen, who does not use the term. His mechanism is a higher-level agent spreading work across subcontractor agents when every candidate's prediction error is high (§3.4).

**F5 (I). The gain form, which Wen names** (`epistemic`, l. 61–64). Wen's Definition 3.4 and Da Costa's salience are the expected divergence of the posterior over states from the prior. The module never states that form, so the third part never meets the quantity Wen's claim is about. *Fix:* add Q2, `epistemic_eq_expected_gain`. With nonnegative weights and likelihoods, the epistemic value is the average, over the predicted outcomes, of the divergence of UE17's `posterior` given each outcome from the states' weights. The identity needs the predicted outcomes to be the likelihood-weighted ones. They are by definition here; with another predictive distribution, or an approximate posterior, the two forms differ.

**F6 (O). Zero conventions, and one docstring.** With `log 0 = 0`, `risk` and `pragmatic` are finite where the predicted outcomes weigh an outcome of preference zero, although the divergence and the expected log preference are infinite there as usually defined. The identity holds between the conventional values. Separately, `epistemic_eq_divergence` calls `product` "the product of its marginals", which needs each `A s` to total one. *Fix:* state both in the docstrings, as UE17 does off the support. Preferences given as a softmax are positive.

**F7 (I). A fairer witness** (l. 110–183). Under `blind` the hypotheses have no observable content, so the witness shows only that a model reading nothing learns nothing. `reading` changes the model, not the record or the seeking. *Fix:* add or substitute P3, a model that reads some distinctions:
- three hypotheses: biased toward heads (true), fair, and biased toward tails, with prior weights 5, 6 and 7;
- the model reads only whether two tosses agree. Under either bias, agreeing outcomes weigh 5 and differing ones 3; under the fair coin every outcome weighs 4. Each total is 16, so prior weights read as prior shares;
- given two heads, the posterior parts are 25, 24 and 35. In one model under one record, the wrong order the model separates turns (`turns_fair`) and the wrong order it ties stays (`keeps_tails`).

Enumerate the cases: a match with an overlapping wildcard on `Bool × Bool` costs `propext` in this Lean.

**F8 (O). `error_kept` does not need `positive`** (l. 100). `weighs` and `wrong` give it (P1: `single_le_evidence`, `error_kept'`). It is also redundant in `posterior_le_iff_prior`: if the whole is nothing, `weighs` forces `prior h₁ = 0` and both sides hold (not probed). *Fix:* drop `positive` from `error_kept`.

**F9 (S). Names.**
- `Lumped lik h₁ h₂` names a pair that one likelihood ties. It shares its name with `Learning.Lumped π g`, a function going alike across a lumping, which 03 §6's reading calls "the local hypothesis `Lumped`", in the record's own home section. Use 03 §1's word, "the map ties them": `Tied` and `tied_mass`.
- `error_kept` names a truth the statement does not contain: `order_kept`.
- `LumpedSeeking`: "seeking" in 03 §8 is target seeking, and this module holds no seeking unless F1's form goes in.
- `efe` is an acronym beside UE17's `freeEnergy`: `expectedFreeEnergy`.

**F10 (I). The third part, honestly placed.** Wen's §2 does claim "inherent self-verification and self-correction", and §4 concedes that the predictions remain hypothetical, so (b), weak stands. But the principle's literature already adds an epistemic term over the likelihood's parameters (novelty; Da Costa and others 2020, Eq. 16) and structure learning by Bayesian model reduction (Friston, Lin, Frith, Pezzulo, Hobson and Ondobaka 2017). It adds them because the state term does not revise the model. Both are conditioning in a larger model, so the law covers that model's ties too, and a hypothesis never listed gains nothing (`mass_absent`). *Fix:*
- write that the epistemic drive corrects within its hypothesis space (the states, parameters and structures it compares) under the policies it has, and not beyond it;
- say that the third part forbids Wen's unqualified wording, not active inference's account;
- link [selection under registration revision](../../../../../../theories/becoming/chapters/03-KNOWING.md#r-selection-under-registration-revision), the theory's law of what changes a lumping.

**F11 (I). Toward the full form, and placement.** None of the following is probed:
- Join the two halves. Through UE17's `givenShare_eq_posterior`, the cast of `posterior_ratio_kept` is the periphery's posterior ratio. That makes the periphery header's "the counting form of the second is `Becoming.LumpedSeeking`" a theorem. `posterior_ratio_of_lumped` is already about UE17's `posterior` by definition (Q0).
- Many steps. Suppose the model's transitions are lumpable (Kemeny and Snell 1960): each action moves every member of a class alike among the classes, and the likelihood reads only the class. Then the class totals at every horizon follow from the current ones, so no policy's expected free energy at any horizon turns on the split within a class. This is 03 §6's "structure and change are one lumping" (`goAlike_iff_lumped`) for a generative model.
- Data processing. A policy's epistemic value is at least that of its coarse variable, and the excess is what it tells about the split.

Two records at 03 §6 stand once F3 gives the core one a delta. Modelling choices to add to the NOTE:
- no transitions;
- exact posteriors;
- risk over outcomes;
- a fixed, pointwise tie;
- listed hypotheses.

## Probes

Core, from the package folder: `python3 -B scratch_build.py <tree> Becoming.LumpedSeeking Becoming.UE19ReviewProbe`, with the module byte-identical to the study's. Result: 9 theorems in 14 declarations, every axiom report empty, no warnings.

```lean
import Becoming.LumpedSeeking

/-! Review probe for UE19: not for landing. -/

namespace Becoming

namespace UE19ReviewProbe

open ConditionalWeights LumpedSeeking

/-! ## P1. `positive` follows from `weighs` and the wrong order -/

/-- A listed hypothesis's prior weight times the record's weight under it is within the record's
weight. -/
theorem single_le_evidence {α β : Type} [DecidableEq α] (prior : α → Nat) (lik : α → β → Nat)
    {hs : List α} (os : List β) (rec : β → Bool) (distinct : Distinct hs) {h : α} (mem : h ∈ hs) :
    prior h * mass os (lik h) rec ≤ mass (openSteps hs os) (pairWeight prior lik) (fun c => rec c.2) :=
  Nat.le_trans
    (Nat.le_of_eq (mass_single (fun h => prior h * mass os (lik h) rec) h distinct mem).symm)
    (Nat.le_trans (mass_mono (fun h => prior h * mass os (lik h) rec) fun _ _ _ => rfl)
      (Nat.le_of_eq (evidence prior lik hs os rec).symm))

/-- `error_kept` without `positive`: the wrong order and `weighs` give it. -/
theorem error_kept' {α β : Type} [DecidableEq α] (prior : α → Nat) (lik : α → β → Nat)
    {hs : List α} (os : List β) (rec : β → Bool) (distinct : Distinct hs) {h₁ h₂ : α}
    (mem₁ : h₁ ∈ hs) (mem₂ : h₂ ∈ hs) (lumped : Lumped lik h₁ h₂)
    (weighs : 0 < mass os (lik h₁) rec) (wrong : prior h₁ < prior h₂) :
    ¬ (share (openSteps hs os) (ConditionalWeights.restrict (fun c => rec c.2) (pairWeight prior lik))
        (fun c => decide (c.1 = h₂))).le
      (share (openSteps hs os) (ConditionalWeights.restrict (fun c => rec c.2) (pairWeight prior lik))
        (fun c => decide (c.1 = h₁))) :=
  error_kept prior lik os rec distinct mem₁ mem₂ lumped weighs
    (Nat.lt_of_lt_of_le
      (Nat.mul_pos (Nat.lt_of_le_of_lt (Nat.zero_le _) wrong) ((lumped_mass lumped os rec) ▸ weighs))
      (single_le_evidence prior lik os rec distinct mem₂))
    wrong

/-! ## P2. Seeking: each experiment chosen from the course so far -/

/-- The weight of a course of seeking under a hypothesis, latest step first: at each step the
weight of choosing the experiment, read from the course so far, times the outcome's weight under
that experiment. -/
def seekWeight {α E O : Type} (choose : List (E × O) → E → Nat) (lik : E → α → O → Nat) (h : α) :
    List (E × O) → Nat
  | [] => 1
  | (e, o) :: rest => choose rest e * lik e h o * seekWeight choose lik h rest

/-- **A pair tied under every experiment is tied over every course of seeking**, however each
experiment is chosen from the course so far. -/
theorem seek_lumped {α E O : Type} (choose : List (E × O) → E → Nat) {lik : E → α → O → Nat}
    {h₁ h₂ : α} (tied : ∀ e, Lumped (lik e) h₁ h₂) :
    ∀ course, seekWeight choose lik h₁ course = seekWeight choose lik h₂ course
  | [] => rfl
  | (e, o) :: rest =>
    show choose rest e * lik e h₁ o * seekWeight choose lik h₁ rest =
      choose rest e * lik e h₂ o * seekWeight choose lik h₂ rest from
    congr (congrArg (fun a b => choose rest e * a * b) (tied e o)) (seek_lumped choose tied rest)

/-- **Seeking does not correct an error its every experiment ties.** -/
theorem seeking_keeps_error {α E O : Type} [DecidableEq α] (prior : α → Nat)
    (choose : List (E × O) → E → Nat) (lik : E → α → O → Nat) {hs : List α}
    (courses : List (List (E × O))) (rec : List (E × O) → Bool) (distinct : Distinct hs)
    {h₁ h₂ : α} (mem₁ : h₁ ∈ hs) (mem₂ : h₂ ∈ hs) (tied : ∀ e, Lumped (lik e) h₁ h₂)
    (weighs : 0 < mass courses (seekWeight choose lik h₁) rec) (wrong : prior h₁ < prior h₂) :
    ¬ (share (openSteps hs courses)
        (ConditionalWeights.restrict (fun c => rec c.2) (pairWeight prior (seekWeight choose lik)))
        (fun c => decide (c.1 = h₂))).le
      (share (openSteps hs courses)
        (ConditionalWeights.restrict (fun c => rec c.2) (pairWeight prior (seekWeight choose lik)))
        (fun c => decide (c.1 = h₁))) :=
  error_kept' prior (seekWeight choose lik) courses rec distinct mem₁ mem₂
    (seek_lumped choose tied) weighs wrong

/-! ## P3. A model that reads some distinctions: it turns one wrong order and keeps another -/

namespace Agree

/-- Three hypotheses: biased toward heads (true here), fair, biased toward tails. -/
inductive Bias where
  | heads
  | fair
  | tails

instance : DecidableEq Bias
  | .heads, .heads => isTrue rfl
  | .fair, .fair => isTrue rfl
  | .tails, .tails => isTrue rfl
  | .heads, .fair => isFalse fun same => nomatch same
  | .heads, .tails => isFalse fun same => nomatch same
  | .fair, .heads => isFalse fun same => nomatch same
  | .fair, .tails => isFalse fun same => nomatch same
  | .tails, .heads => isFalse fun same => nomatch same
  | .tails, .fair => isFalse fun same => nomatch same

def hypotheses : List Bias := [.heads, .fair, .tails]

theorem distinct : Distinct hypotheses :=
  ⟨fun mem => (match mem with
    | .tail _ (.tail _ no) => nomatch no),
   (fun mem => (match mem with
    | .tail _ no => nomatch no)), (fun mem => nomatch mem), trivial⟩

/-- The prior weighs the fair coin and the tails-biased one, both false, above the true one. -/
def prior : Bias → Nat
  | .heads => 5
  | .fair => 6
  | .tails => 7

/-- **A model reading only whether two tosses agree**: an outcome weighs its class's chance under
the bias, in sixteenths, shared between the class's two outcomes (agree: 10 or 8; differ: 6 or 8).
It ties the two biases and separates them from the fair coin. -/
def agreeing : Bias → Bool × Bool → Nat
  | .heads, (true, true) => 5
  | .heads, (true, false) => 3
  | .heads, (false, true) => 3
  | .heads, (false, false) => 5
  | .fair, (true, true) => 4
  | .fair, (true, false) => 4
  | .fair, (false, true) => 4
  | .fair, (false, false) => 4
  | .tails, (true, true) => 5
  | .tails, (true, false) => 3
  | .tails, (false, true) => 3
  | .tails, (false, false) => 5

theorem ties : Lumped agreeing .heads .tails
  | (true, true) => rfl
  | (true, false) => rfl
  | (false, true) => rfl
  | (false, false) => rfl

/-- Every bias's weights total sixteen, so prior weights read as prior shares. -/
theorem totals : ∀ h, mass Coin.outcomes (agreeing h) (fun _ => true) = 16
  | .heads => rfl
  | .fair => rfl
  | .tails => rfl

/-- Given two heads, the true coin comes above the fair one: the order the record separates turns. -/
theorem turns_fair :
    ¬ (share (openSteps hypotheses Coin.outcomes)
        (ConditionalWeights.restrict (fun c => Coin.twoHeads c.2) (pairWeight prior agreeing))
        (fun c => decide (c.1 = Bias.heads))).le
      (share (openSteps hypotheses Coin.outcomes)
        (ConditionalWeights.restrict (fun c => Coin.twoHeads c.2) (pairWeight prior agreeing))
        (fun c => decide (c.1 = Bias.fair))) :=
  fun le => absurd ((posterior_le_iff prior agreeing hypotheses Coin.outcomes Coin.twoHeads
    (fun h => decide (h = Bias.heads)) (fun h => decide (h = Bias.fair)) (by decide)).mp le)
    (by decide)

/-- Given two heads, the tails-biased coin stays above the true one: the order the model ties
stays. -/
theorem keeps_tails :
    ¬ (share (openSteps hypotheses Coin.outcomes)
        (ConditionalWeights.restrict (fun c => Coin.twoHeads c.2) (pairWeight prior agreeing))
        (fun c => decide (c.1 = Bias.tails))).le
      (share (openSteps hypotheses Coin.outcomes)
        (ConditionalWeights.restrict (fun c => Coin.twoHeads c.2) (pairWeight prior agreeing))
        (fun c => decide (c.1 = Bias.heads))) :=
  error_kept' prior agreeing Coin.outcomes Coin.twoHeads distinct (.head _)
    (.tail _ (.tail _ (.head _))) ties (by decide) (by decide)

end Agree

end UE19ReviewProbe

end Becoming
```

Periphery: built with UE17's `build.sh` pointed at the review's folder, compiling `FreeEnergyReals`, then `ExpectedFreeEnergyReals`, then the probe. Result: all 10 declarations on the three standard axioms, no `sorryAx`, no warnings.

```lean
import ExpectedFreeEnergyReals

/-! Review probe for UE19's periphery: not for landing. -/

namespace Becoming.ExpectedFreeEnergy.UE19ReviewProbe

open Becoming.FreeEnergy Becoming.ExpectedFreeEnergy

variable {σ ω κ : Type*}

/-! ## Q0. `posterior_ratio_of_lumped` is about UE17's `posterior`, by definition -/

theorem ratio_as_posterior (S : Finset σ) (Qs : σ → ℝ) (A : σ → ω → ℝ) {s₁ s₂ : σ}
    (lumped : ∀ o, A s₁ o = A s₂ o) (o : ω) :
    posterior S (fun s => Qs s * A s o) s₁ * Qs s₂ =
      posterior S (fun s => Qs s * A s o) s₂ * Qs s₁ :=
  posterior_ratio_of_lumped S Qs A lumped o

/-! ## Q1. Expected free energy reads the states only through the lumping its likelihood makes -/

variable [DecidableEq κ]

/-- The coarse weights: each class's total under the lumping `π`. -/
noncomputable def coarse (S : Finset σ) (Qs : σ → ℝ) (π : σ → κ) (k : κ) : ℝ :=
  ∑ s ∈ S.filter (fun s => π s = k), Qs s

theorem sum_through (S : Finset σ) (Qs : σ → ℝ) (π : σ → κ) (f : κ → ℝ) :
    ∑ s ∈ S, Qs s * f (π s) = ∑ k ∈ S.image π, coarse S Qs π k * f k := by
  rw [← Finset.sum_fiberwise_of_maps_to (t := S.image π) (g := π)
    (fun s hs => Finset.mem_image_of_mem π hs)]
  refine Finset.sum_congr rfl fun k _ => ?_
  unfold coarse
  rw [Finset.sum_mul]
  refine Finset.sum_congr rfl fun s hs => ?_
  rw [(Finset.mem_filter.mp hs).2]

theorem predicted_through (S : Finset σ) (Qs : σ → ℝ) (π : σ → κ) (B : κ → ω → ℝ) (o : ω) :
    predicted S Qs (fun s => B (π s)) o = predicted (S.image π) (coarse S Qs π) B o :=
  sum_through S Qs π (fun k => B k o)

/-- **The epistemic value is the coarse variable's.** Where the likelihood reads a state only
through its class, the information the outcomes carry about the states is the information they
carry about the classes: nothing about which member of a class. -/
theorem epistemic_through (S : Finset σ) (O : Finset ω) (Qs : σ → ℝ) (π : σ → κ)
    (B : κ → ω → ℝ) :
    epistemic S O Qs (fun s => B (π s)) = epistemic (S.image π) O (coarse S Qs π) B := by
  unfold epistemic
  calc ∑ s ∈ S, ∑ o ∈ O, Qs s * B (π s) o *
          (Real.log (B (π s) o) - Real.log (predicted S Qs (fun s => B (π s)) o))
      = ∑ s ∈ S, Qs s * (∑ o ∈ O, B (π s) o *
          (Real.log (B (π s) o) - Real.log (predicted (S.image π) (coarse S Qs π) B o))) :=
        Finset.sum_congr rfl fun s _ => by
          rw [Finset.mul_sum]
          refine Finset.sum_congr rfl fun o _ => ?_
          rw [predicted_through]
          ring
    _ = ∑ k ∈ S.image π, coarse S Qs π k * (∑ o ∈ O, B k o *
          (Real.log (B k o) - Real.log (predicted (S.image π) (coarse S Qs π) B o))) :=
        sum_through S Qs π (fun k => ∑ o ∈ O, B k o *
          (Real.log (B k o) - Real.log (predicted (S.image π) (coarse S Qs π) B o)))
    _ = _ := Finset.sum_congr rfl fun k _ => by
          rw [Finset.mul_sum]
          exact Finset.sum_congr rfl fun o _ => by ring

theorem efe_through (S : Finset σ) (O : Finset ω) (Qs : σ → ℝ) (π : σ → κ) (B : κ → ω → ℝ)
    (P : ω → ℝ) :
    efe S O Qs (fun s => B (π s)) P = efe (S.image π) O (coarse S Qs π) B P := by
  unfold efe risk ambiguity
  have pred : predicted S Qs (fun s => B (π s)) = predicted (S.image π) (coarse S Qs π) B :=
    funext (predicted_through S Qs π B)
  rw [pred, sum_through S Qs π (fun k => ∑ o ∈ O, -(B k o * Real.log (B k o)))]

/-- **Two beliefs alike on the classes score every such policy alike**: however the weight is
split within a class, the expected free energy is the same, so no choice by it turns on the split. -/
theorem efe_same_of_coarse (S : Finset σ) (O : Finset ω) {Qs Qs' : σ → ℝ} (π : σ → κ)
    (B : κ → ω → ℝ) (P : ω → ℝ) (alike : ∀ k, coarse S Qs π k = coarse S Qs' π k) :
    efe S O Qs (fun s => B (π s)) P = efe S O Qs' (fun s => B (π s)) P := by
  have same : coarse S Qs π = coarse S Qs' π := funext alike
  rw [efe_through S O Qs π B P, efe_through S O Qs' π B P, same]

/-- Where the lumping has one class, the epistemic value is nothing: `epistemic_eq_zero_of_lumped`
as the coarse form's least case. -/
theorem epistemic_one_class (O : Finset ω) (Q : Unit → ℝ) (B : Unit → ω → ℝ) (one : Q () = 1) :
    epistemic {()} O Q B = 0 := by
  unfold epistemic predicted
  simp [one]

/-! ## Q2. The epistemic value is the expected divergence of the posterior from the prior -/

/-- One term of the expected information gain. -/
theorem gain_term (q a P : ℝ) (hq : 0 ≤ q) (ha : 0 ≤ a) (within : q * a ≤ P) :
    q * a * (Real.log a - Real.log P) = P * (q * a / P * (Real.log (q * a / P) - Real.log q)) := by
  rcases hq.eq_or_lt with zero | pos
  · rw [← zero]; simp
  rcases ha.eq_or_lt with zero | posA
  · rw [← zero]; simp
  have posP : 0 < P := lt_of_lt_of_le (mul_pos pos posA) within
  rw [Real.log_div (mul_pos pos posA).ne' posP.ne', Real.log_mul pos.ne' posA.ne']
  field_simp
  ring

omit [DecidableEq κ] in
/-- **Expected information gain.** With the states' weights and the likelihoods nonnegative, the
epistemic value is the predicted outcomes' average of the divergence of the posterior given each
outcome (UE17's `posterior`) from the states' weights: Friston and others' (2015) form. -/
theorem epistemic_eq_expected_gain (S : Finset σ) (O : Finset ω) (Qs : σ → ℝ) (A : σ → ω → ℝ)
    (hQ : ∀ s ∈ S, 0 ≤ Qs s) (hA : ∀ s ∈ S, ∀ o ∈ O, 0 ≤ A s o) :
    epistemic S O Qs A =
      ∑ o ∈ O, predicted S Qs A o * divergence S (posterior S (fun s => Qs s * A s o)) Qs := by
  unfold epistemic divergence
  rw [Finset.sum_comm]
  refine Finset.sum_congr rfl fun o ho => ?_
  rw [Finset.mul_sum]
  refine Finset.sum_congr rfl fun s hs => ?_
  exact gain_term (Qs s) (A s o) (predicted S Qs A o) (hQ s hs) (hA s hs o ho)
    (Finset.single_le_sum (f := fun t => Qs t * A t o)
      (fun t ht => mul_nonneg (hQ t ht) (hA t ht o ho)) hs)

end Becoming.ExpectedFreeEnergy.UE19ReviewProbe
```

## References checked

- Da Costa, L., Parr, T., Sajid, N., Veselic, S., Neacsu, V., and Friston, K. (2020). Active inference on discrete state-spaces: a synthesis. *Journal of Mathematical Psychology* 99, 102447 (PMC7732703).
- Friston, K., Lin, M., Frith, C. D., Pezzulo, G., Hobson, J. A., and Ondobaka, S. (2017). Active inference, curiosity and insight. *Neural Computation* 29, 2633–2683.
- Friston, K., Rigoli, F., Ognibene, D., Mathys, C., FitzGerald, T., and Pezzulo, G. (2015). Active inference and epistemic value. *Cognitive Neuroscience* 6(4), 187–214.
- Kemeny, J. G., and Snell, J. L. (1960). *Finite Markov Chains*. Van Nostrand.
- Parr, T., and Friston, K. J. (2019). Generalised free energy and active inference. *Biological Cybernetics* 113(5–6), 495–513 (PMC6848054).
- Poirier, D. J. (1998). Revising beliefs in nonidentified models. *Econometric Theory* 14(4), 483–509.
- Rothenberg, T. J. (1971). Identification in parametric models. *Econometrica* 39(3), 577–591.
- Wen, B. (2025). A framework for inherently safer AGI through language-mediated active inference. arXiv:2508.05766, v1, 7 August 2025.
