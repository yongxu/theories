import FreeEnergyReals

/-!
# Expected free energy over the reals: risk and ambiguity, epistemic and pragmatic value

Active inference scores a policy by its expected free energy over the outcomes the policy predicts.
For a finite set of states `S` and of outcomes `O`, a distribution `Qs` over states under the
policy, a likelihood `A s o` of each outcome in each state and a preferred distribution `P` over
outcomes, the predicted outcomes are `predicted S Qs A o = Σ_s Qs s · A s o`. Risk is the divergence
of the predicted outcomes from the preferred ones, ambiguity the expected entropy of the likelihood,
and the epistemic value the mutual information of states and outcomes, as Parr and Friston (2019)
define them (Da Costa and others 2020 take risk over states and reach this form approximately;
Friston and others 2015 split a policy's quality into extrinsic and epistemic value). This module
states, over Mathlib's reals beside `FreeEnergyReals` (board item UE19):

* **The decompositions** (`expectedFreeEnergy_eq_neg_epistemic_sub_pragmatic`, with no hypothesis).
  Risk plus ambiguity is the negative of the epistemic value less the pragmatic value (the expected
  log preference).
* **The epistemic value is a divergence and an information gain.** Of the joint distribution of
  states and outcomes from the product of the states' weights and the predicted outcomes
  (`epistemic_eq_divergence`), a product of marginals where each likelihood totals one, so it is
  nonnegative where `Qs` and each `A s` are distributions (`epistemic_nonneg`); and the predicted
  outcomes' average of the divergence of UE17's `posterior` given each outcome from the states'
  weights (`epistemic_eq_expected_gain`), the form Wen's (2025) proposal names.
* **Expected free energy reads the states only through the lumping its likelihood makes.** Where the
  likelihood reads a state only through its class (`A s = B (π s)`), the epistemic value and the
  expected free energy are those of the classes with their total weights (`coarse`,
  `epistemic_through`, `expectedFreeEnergy_through`), so two beliefs alike on the classes score
  every such policy alike (`expectedFreeEnergy_same_of_coarse`): no choice by expected free energy
  turns on how weight is split within a class. Where every state the policy may reach has one
  likelihood the epistemic value is nothing (`epistemic_eq_zero_of_lumped`), and two states of one
  likelihood keep, under every outcome, the ratio of their prior weights in UE17's `posterior`
  (`posterior_ratio_of_lumped`). Its counting form, with seeking, is stated in
  `Becoming.LumpedSeeking`; no theorem here joins the two.

**Modelling choices.** Finite states and outcomes; real distributions; one step, one policy, its
predicted state distribution given; exact posteriors; no transitions. Mathlib's conventions `log 0 =
0` and `x / 0 = 0`: where the predicted outcomes weigh an outcome of preference nothing, `risk` and
`pragmatic` are finite here though infinite as usually defined, and the identity holds between these
values (preferences given as a softmax are positive). **What is not derived:** the softmax over
policies, precision, learning, multi-step policies, any process by which an agent reaches its
choice. The declarations here depend on Lean's standard axioms, through Mathlib; the checker reports
each one's. No ethical premise occurs.
-/

namespace Becoming.ExpectedFreeEnergy

open Becoming.FreeEnergy

variable {σ ω : Type*}

/-- **The predicted outcomes** under a policy: each outcome's likelihood averaged over the
states. -/
noncomputable def predicted (S : Finset σ) (Qs : σ → ℝ) (A : σ → ω → ℝ) (o : ω) : ℝ :=
  ∑ s ∈ S, Qs s * A s o

/-- **Risk**: the divergence of the predicted outcomes from the preferred ones (as usually defined
where `P` is positive wherever the predicted outcomes are; see the header). -/
noncomputable def risk (S : Finset σ) (O : Finset ω) (Qs : σ → ℝ) (A : σ → ω → ℝ) (P : ω → ℝ) : ℝ :=
  divergence O (predicted S Qs A) P

/-- **Ambiguity**: the expected entropy of the outcome in each state. -/
noncomputable def ambiguity (S : Finset σ) (O : Finset ω) (Qs : σ → ℝ) (A : σ → ω → ℝ) : ℝ :=
  ∑ s ∈ S, Qs s * ∑ o ∈ O, -(A s o * Real.log (A s o))

/-- **Expected free energy**: risk plus ambiguity. -/
noncomputable def expectedFreeEnergy (S : Finset σ) (O : Finset ω) (Qs : σ → ℝ) (A : σ → ω → ℝ)
    (P : ω → ℝ) : ℝ :=
  risk S O Qs A P + ambiguity S O Qs A

/-- **Pragmatic value**: the expected log preference of the predicted outcomes (as usually defined
where `P` is positive wherever the predicted outcomes are; see the header). -/
noncomputable def pragmatic (S : Finset σ) (O : Finset ω) (Qs : σ → ℝ) (A : σ → ω → ℝ)
    (P : ω → ℝ) : ℝ :=
  ∑ o ∈ O, predicted S Qs A o * Real.log (P o)

/-- **Epistemic value**: the information the outcomes carry about the states, the expected
divergence of each state's likelihood from the predicted outcomes. -/
noncomputable def epistemic (S : Finset σ) (O : Finset ω) (Qs : σ → ℝ) (A : σ → ω → ℝ) : ℝ :=
  ∑ s ∈ S, ∑ o ∈ O, Qs s * A s o * (Real.log (A s o) - Real.log (predicted S Qs A o))

/-- **Expected free energy is the negative of epistemic and pragmatic value**: risk plus ambiguity
equals the negative of the epistemic value less the pragmatic value, with no hypothesis. -/
theorem expectedFreeEnergy_eq_neg_epistemic_sub_pragmatic (S : Finset σ) (O : Finset ω) (Qs : σ → ℝ)
    (A : σ → ω → ℝ) (P : ω → ℝ) :
    expectedFreeEnergy S O Qs A P = -epistemic S O Qs A - pragmatic S O Qs A P := by
  have swap : ∑ s ∈ S, ∑ o ∈ O, Qs s * A s o * Real.log (predicted S Qs A o) =
      ∑ o ∈ O, predicted S Qs A o * Real.log (predicted S Qs A o) := by
    rw [Finset.sum_comm]
    refine Finset.sum_congr rfl fun o _ => ?_
    unfold predicted
    rw [Finset.sum_mul]
  have own : ∑ s ∈ S, ∑ o ∈ O, Qs s * A s o * Real.log (A s o) =
      ∑ s ∈ S, Qs s * ∑ o ∈ O, A s o * Real.log (A s o) := by
    refine Finset.sum_congr rfl fun s _ => ?_
    rw [Finset.mul_sum]
    refine Finset.sum_congr rfl fun o _ => ?_
    ring
  have split : epistemic S O Qs A =
      ∑ s ∈ S, ∑ o ∈ O, Qs s * A s o * Real.log (A s o) -
        ∑ s ∈ S, ∑ o ∈ O, Qs s * A s o * Real.log (predicted S Qs A o) := by
    unfold epistemic
    rw [← Finset.sum_sub_distrib]
    refine Finset.sum_congr rfl fun s _ => ?_
    rw [← Finset.sum_sub_distrib]
    refine Finset.sum_congr rfl fun o _ => ?_
    ring
  have amb : ambiguity S O Qs A = -∑ s ∈ S, Qs s * ∑ o ∈ O, A s o * Real.log (A s o) := by
    unfold ambiguity
    rw [← Finset.sum_neg_distrib]
    refine Finset.sum_congr rfl fun s _ => ?_
    rw [Finset.sum_neg_distrib, mul_neg]
  have rsk : risk S O Qs A P = ∑ o ∈ O, predicted S Qs A o * Real.log (predicted S Qs A o) -
      ∑ o ∈ O, predicted S Qs A o * Real.log (P o) := by
    unfold risk divergence
    rw [← Finset.sum_sub_distrib]
    refine Finset.sum_congr rfl fun o _ => ?_
    ring
  unfold expectedFreeEnergy pragmatic
  rw [split, own, swap, amb, rsk]
  ring

/-- The joint distribution of states and outcomes. -/
noncomputable def joint (Qs : σ → ℝ) (A : σ → ω → ℝ) (x : σ × ω) : ℝ := Qs x.1 * A x.1 x.2

/-- The product of the marginals: the state's weight times the predicted outcome's. -/
noncomputable def product (S : Finset σ) (Qs : σ → ℝ) (A : σ → ω → ℝ) (x : σ × ω) : ℝ :=
  Qs x.1 * predicted S Qs A x.2

/-- **The epistemic value is a divergence**: of the joint distribution from the product of the
states' weights and the predicted outcomes, over the pairs of states and outcomes, where the
policy's states and the likelihoods are nonnegative; a product of the joint's marginals where each
likelihood totals one. -/
theorem epistemic_eq_divergence (S : Finset σ) (O : Finset ω) (Qs : σ → ℝ) (A : σ → ω → ℝ)
    (hQ : ∀ s ∈ S, 0 ≤ Qs s) (hA : ∀ s ∈ S, ∀ o ∈ O, 0 ≤ A s o) :
    epistemic S O Qs A = divergence (S ×ˢ O) (joint Qs A) (product S Qs A) := by
  unfold epistemic divergence
  rw [Finset.sum_product]
  refine Finset.sum_congr rfl fun s hs => Finset.sum_congr rfl fun o ho => ?_
  unfold joint product
  dsimp only
  rcases (hQ s hs).eq_or_lt with zero | pos
  · rw [← zero]; ring
  rcases (hA s hs o ho).eq_or_lt with zero | posA
  · rw [← zero]; ring
  have within : Qs s * A s o ≤ predicted S Qs A o :=
    Finset.single_le_sum (f := fun t => Qs t * A t o)
      (fun t ht => mul_nonneg (hQ t ht) (hA t ht o ho)) hs
  have posP : 0 < predicted S Qs A o := lt_of_lt_of_le (mul_pos pos posA) within
  rw [Real.log_mul pos.ne' posA.ne', Real.log_mul pos.ne' posP.ne']
  ring

/-- **The epistemic value is nonnegative** where the policy's states and each state's likelihood
are distributions. -/
theorem epistemic_nonneg (S : Finset σ) (O : Finset ω) (Qs : σ → ℝ) (A : σ → ω → ℝ)
    (hQ : ∀ s ∈ S, 0 ≤ Qs s) (hQ1 : ∑ s ∈ S, Qs s = 1) (hA : ∀ s ∈ S, ∀ o ∈ O, 0 ≤ A s o)
    (hA1 : ∀ s ∈ S, ∑ o ∈ O, A s o = 1) : 0 ≤ epistemic S O Qs A := by
  rw [epistemic_eq_divergence S O Qs A hQ hA]
  have predicted_nonneg : ∀ o ∈ O, 0 ≤ predicted S Qs A o := fun o ho =>
    Finset.sum_nonneg fun s hs => mul_nonneg (hQ s hs) (hA s hs o ho)
  have total_joint : ∑ x ∈ S ×ˢ O, joint Qs A x = 1 := by
    rw [Finset.sum_product]
    unfold joint
    dsimp only
    rw [← hQ1]
    refine Finset.sum_congr rfl fun s hs => ?_
    rw [← Finset.mul_sum, hA1 s hs, mul_one]
  have total_product : ∑ x ∈ S ×ˢ O, product S Qs A x = 1 := by
    rw [Finset.sum_product]
    unfold product
    dsimp only
    have each : ∀ s ∈ S, ∑ o ∈ O, Qs s * predicted S Qs A o = Qs s * ∑ o ∈ O, predicted S Qs A o :=
      fun s _ => (Finset.mul_sum _ _ _).symm
    rw [Finset.sum_congr rfl each, ← Finset.sum_mul, hQ1, one_mul]
    unfold predicted
    rw [Finset.sum_comm, ← hQ1]
    refine Finset.sum_congr rfl fun s hs => ?_
    rw [← Finset.mul_sum, hA1 s hs, mul_one]
  exact divergence_nonneg (S ×ˢ O) (joint Qs A) (product S Qs A)
    (fun x hx => mul_nonneg (hQ x.1 (Finset.mem_product.mp hx).1)
      (hA x.1 (Finset.mem_product.mp hx).1 x.2 (Finset.mem_product.mp hx).2))
    total_joint
    (fun x hx => mul_nonneg (hQ x.1 (Finset.mem_product.mp hx).1)
      (predicted_nonneg x.2 (Finset.mem_product.mp hx).2))
    total_product
    (fun x hx zero => by
      have hs := (Finset.mem_product.mp hx).1
      have ho := (Finset.mem_product.mp hx).2
      unfold joint
      unfold product at zero
      rcases mul_eq_zero.mp zero with q | p
      · rw [q, zero_mul]
      · have within : Qs x.1 * A x.1 x.2 ≤ predicted S Qs A x.2 :=
          Finset.single_le_sum (f := fun t => Qs t * A t x.2)
            (fun t ht => mul_nonneg (hQ t ht) (hA t ht x.2 ho)) hs
        exact le_antisymm (p ▸ within) (mul_nonneg (hQ x.1 hs) (hA x.1 hs x.2 ho)))

/-- **Nothing to learn where the likelihood lumps every state.** Where every state the policy may
reach (weight not zero) has one likelihood `B`, and the states' weights total one, the predicted
outcomes are `B` and the epistemic value is nothing. -/
theorem epistemic_eq_zero_of_lumped (S : Finset σ) (O : Finset ω) (Qs : σ → ℝ) (A : σ → ω → ℝ)
    (B : ω → ℝ) (hQ1 : ∑ s ∈ S, Qs s = 1) (lumped : ∀ s ∈ S, Qs s ≠ 0 → ∀ o ∈ O, A s o = B o) :
    epistemic S O Qs A = 0 := by
  have pred : ∀ o ∈ O, predicted S Qs A o = B o := fun o ho => by
    unfold predicted
    have each : ∀ s ∈ S, Qs s * A s o = Qs s * B o := fun s hs => by
      by_cases zero : Qs s = 0
      · rw [zero, zero_mul, zero_mul]
      · rw [lumped s hs zero o ho]
    rw [Finset.sum_congr rfl each, ← Finset.sum_mul, hQ1, one_mul]
  unfold epistemic
  refine Finset.sum_eq_zero fun s hs => Finset.sum_eq_zero fun o ho => ?_
  by_cases zero : Qs s = 0
  · rw [zero, zero_mul, zero_mul]
  · rw [lumped s hs zero o ho, pred o ho, sub_self, mul_zero]

/-- **Two states of one likelihood keep their prior ratio under every outcome**: their weights in
UE17's `posterior` given an outcome stand to each other as their prior weights do. -/
theorem posterior_ratio_of_lumped (S : Finset σ) (Qs : σ → ℝ) (A : σ → ω → ℝ) {s₁ s₂ : σ}
    (lumped : ∀ o, A s₁ o = A s₂ o) (o : ω) :
    posterior S (fun s => Qs s * A s o) s₁ * Qs s₂ =
      posterior S (fun s => Qs s * A s o) s₂ * Qs s₁ := by
  unfold posterior
  dsimp only
  rw [lumped o]
  ring

/-! ## Through the lumping the likelihood makes -/

section Through

variable {κ : Type*} [DecidableEq κ]

/-- **The coarse weights**: each class's total weight under the lumping `π`. -/
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

/-- **The epistemic value is the classes'.** Where the likelihood reads a state only through its
class, the information the outcomes carry about the states is the information they carry about the
classes: nothing about which member of a class. -/
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

/-- **The expected free energy is the classes'**, through the same lumping. -/
theorem expectedFreeEnergy_through (S : Finset σ) (O : Finset ω) (Qs : σ → ℝ) (π : σ → κ)
    (B : κ → ω → ℝ) (P : ω → ℝ) :
    expectedFreeEnergy S O Qs (fun s => B (π s)) P =
      expectedFreeEnergy (S.image π) O (coarse S Qs π) B P := by
  unfold expectedFreeEnergy risk ambiguity
  have pred : predicted S Qs (fun s => B (π s)) = predicted (S.image π) (coarse S Qs π) B :=
    funext (predicted_through S Qs π B)
  rw [pred, sum_through S Qs π (fun k => ∑ o ∈ O, -(B k o * Real.log (B k o)))]

/-- **Two beliefs alike on the classes score every such policy alike**: however the weight is
split within a class, the expected free energy is the same, so no choice by it turns on the
split. -/
theorem expectedFreeEnergy_same_of_coarse (S : Finset σ) (O : Finset ω) {Qs Qs' : σ → ℝ}
    (π : σ → κ) (B : κ → ω → ℝ) (P : ω → ℝ) (alike : ∀ k, coarse S Qs π k = coarse S Qs' π k) :
    expectedFreeEnergy S O Qs (fun s => B (π s)) P =
      expectedFreeEnergy S O Qs' (fun s => B (π s)) P := by
  have same : coarse S Qs π = coarse S Qs' π := funext alike
  rw [expectedFreeEnergy_through S O Qs π B P, expectedFreeEnergy_through S O Qs' π B P, same]

end Through

/-! ## The information-gain form -/

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

/-- **The epistemic value is the expected information gain**: with the states' weights and the
likelihoods nonnegative, it is the predicted outcomes' average of the divergence of UE17's
`posterior` given each outcome from the states' weights. -/
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

end Becoming.ExpectedFreeEnergy
