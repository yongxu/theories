import FreeEnergyReals
import Becoming.LumpedSeeking

/-!
# Expected free energy over the reals: risk and ambiguity, epistemic and pragmatic value; seeking

Active inference scores a policy by its expected free energy over the outcomes the policy predicts.
For a finite set of states `S` and of outcomes `O`, a distribution `Qs` over states under the
policy, a likelihood `A s o` of each outcome in each state and a preferred distribution `P` over
outcomes, the predicted outcomes are `predicted S Qs A o = Σ_s Qs s · A s o`. Risk is the divergence
of the predicted outcomes from the preferred ones, ambiguity the expected entropy of the likelihood,
and the epistemic value the mutual information of states and outcomes, as Parr and Friston (2019)
define them (Da Costa and others 2020 take risk over states and reach this form approximately;
Friston and others 2015 split a policy's quality into extrinsic and epistemic value). This module
states, over Mathlib's reals beside `FreeEnergyReals` (board item UE19; the seeking section UE23):

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
  `Becoming.LumpedSeeking`, joined below.
* **Seeking by expected free energy, joined to the core's seeking** (UE23). A course of seeking is a
  list of experiments and outcomes, latest first, each experiment chosen from the course so far, as
  in the core's `seekWeight`. The posterior after a course is UE17's `posterior` of the prior times
  the course's likelihood (`coursePosterior`, `courseLik`); with a nonnegative prior and
  likelihoods, where the course weighs something under the prior, it is, among beliefs over the
  states that are zero wherever the joint weights are, the one of least free energy against them
  (`coursePosterior_minimizes`). Choice weights reading the course drop out of it wherever they
  weigh something along it (`posterior_choice_eq_coursePosterior`), and so does each experiment's
  nonzero scale (`coursePosterior_rescale`). With natural weights and the hypotheses listed once, it
  is, as a real number, the core's share given a listed course whose choices weigh something
  (`givenCourse_eq_coursePosterior`, through `cast_seekWeight` and `mass_count`; where they weigh
  nothing the share is 0, `unchosen_share_zero`), and the core's order of two shares given the
  course is the order of the posterior (`givenCourse_le_iff`, through `share_le_iff_toReal_le`).
  Choosing each experiment by a rule with natural weights reading the experiments' expected free
  energies at the posterior (`efeChoice`) reads only the course, so it is one of the core's
  policies, and the core's law holds at it whatever the agent's model (`efe_seeking_keeps_order`, an
  instance that uses no join). A real-valued rule, the softmax among them, is not one of the core's
  policies. Over the reals, two states every experiment ties keep their prior ratio in the posterior
  after every course, and their strict order where the course is possible under them and weighs
  something under the prior (`coursePosterior_ratio_kept`, `coursePosterior_order_kept`), so also in
  the posterior of the joint weights under every policy whose choices along the course weigh
  something, the softmax over all the experiments among them (`softmax`, `softmax_choiceWeight_pos`;
  `softmax_order_kept`, an instance). Where every experiment's likelihood reads a state only through
  its class, conditioning commutes with the lumping (`coarse_coursePosterior`): at the posterior
  after every course, every experiment's expected free energy and epistemic value are the classes'
  (`efe_through_course`, `epistemic_through_course`), every course's predictive weight is the
  classes' under any policy (`courseWeight_through`), and two priors alike on the classes choose
  alike at every course under every rule, and give every course one predictive weight and one weight
  under every state (`efeChoice_same_of_coarse`, `seeking_blind_to_split`; for the softmax,
  `softmax_blind_to_split`, an instance). Taking as a state's class its likelihood under every
  experiment, for any likelihoods, seeking by expected free energy reads the prior only through the
  weight it gives each such profile (`seeking_reads_profiles`, an instance): what no experiment
  tells apart, no course of seeking by it tells apart, in its choices or in its predictive weights.
  In the coin of `Becoming.LumpedSeeking`, an outcome of a separating experiment turns the posterior
  and no course turns an order every experiment ties (`Witness.separating_turns`); with an
  experiment reading agreement and one telling nothing, two priors whose posteriors differ give both
  experiments the same weights at every course under every rule (`Witness.split_unseen`).

**Modelling choices.** Finite states and outcomes; real distributions; one step, one policy, its
predicted state distribution given; exact posteriors; no transitions. In the seeking section, a
policy is one experiment, the hidden state stays fixed over a course, and the preferences are the
same for every experiment. A rule reads the experiments' expected free energies and may read the
experiment itself, so a fixed habit (`σ(ln E − γG)`) is among the rules; with one-step policies and
a fixed state, the free energy of the past is the same under every policy. With natural weights the
expected free energy is that of the cast weights: where every state's weights under an experiment
total `N_e` and the belief totals one, it is `N_e` times the principle's, so the principle's choice
is the rule reading `G e / N_e` (for this `efe_seeking_keeps_order` takes any real model), and the
prior weights read as prior probabilities only where the likelihood totals agree (the core's
`prior_share`). Mathlib's conventions `log 0 = 0` and `x / 0 = 0`: where the predicted outcomes
weigh an outcome of preference nothing, `risk` and `pragmatic` are finite here though infinite as
usually defined, and the identity holds between these values (preferences given as a softmax are
positive). **What is not derived:** precision as a belief, habits learned from the course, learning
of the likelihood, multi-step policies with transitions, any process by which an agent reaches its
choice; whether, or how often, an agent choosing by expected free energy chooses an experiment that
separates, which turns on its preferences, its posterior and the experiments' information (under the
softmax every experiment has some weight). **Standing** of the seeking section: near-definitional.
That data leave a prior's split within a class of observationally equivalent states unchanged is
Bayesian non-identification (Kadane 1974, Dawid 1979, Poirier 1998); the blindness of seeking is its
corollary for adaptive designs whose criterion reads the posterior only through the classes, and the
expected free energy enters only through `expectedFreeEnergy_through`. New are the join to the
core's seeking and its statement for the agent the principle describes; none of it is a new
inequality. The declarations here depend on Lean's standard axioms, through Mathlib; the checker
reports each one's. No ethical premise occurs.
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

/-! ## Seeking by expected free energy, joined to the core's seeking -/

section Seeking

open Becoming.ConditionalWeights

variable {ε : Type*}

/-- **The likelihood of a course** under a state: over its steps, latest first as in the core's
`seekWeight`, the product of each outcome's likelihood under the experiment chosen there. -/
noncomputable def courseLik (L : ε → σ → ω → ℝ) (s : σ) : List (ε × ω) → ℝ
  | [] => 1
  | (e, o) :: rest => L e s o * courseLik L s rest

/-- **The weight of the choices along a course**: the product of each experiment's choice weight,
read from the course before it. -/
noncomputable def choiceWeight (pick : List (ε × ω) → ε → ℝ) : List (ε × ω) → ℝ
  | [] => 1
  | (e, _) :: rest => pick rest e * choiceWeight pick rest

/-- **The posterior after a course**: UE17's `posterior` of the prior times the course's likelihood.
Where the prior and the likelihoods are nonnegative and these joint weights total something, it is,
among beliefs over `S` that are nonnegative, total one and are zero wherever the joint weights are,
the one of least free energy against them (`coursePosterior_minimizes`); where they total nothing,
no such belief exists. -/
noncomputable def coursePosterior (S : Finset σ) (Q : σ → ℝ) (L : ε → σ → ω → ℝ)
    (c : List (ε × ω)) : σ → ℝ :=
  posterior S (fun s => Q s * courseLik L s c)

/-- **The predictive weight of a course** under a prior and a policy, as the agent holding the prior
weighs it: the weight of the choices along the course times the prior's average of its likelihood.
The choice weights read only the course, so they are the same under every state. -/
noncomputable def courseWeight (S : Finset σ) (Q : σ → ℝ) (L : ε → σ → ω → ℝ)
    (pick : List (ε × ω) → ε → ℝ) (c : List (ε × ω)) : ℝ :=
  choiceWeight pick c * ∑ s ∈ S, Q s * courseLik L s c

/-- **Choosing by expected free energy**: at each course so far, a rule reads the experiments'
expected free energies at the posterior after that course and gives each experiment its choice
weight. The rule may read the experiment too, so a fixed weighting of the experiments (a habit
fixed in advance) is among the rules. -/
noncomputable def efeChoice {τ : Type*} (rule : (ε → ℝ) → ε → τ) (S : Finset σ) (O : Finset ω)
    (Q : σ → ℝ) (L : ε → σ → ω → ℝ) (P : ω → ℝ) (c : List (ε × ω)) : ε → τ :=
  rule (fun e => expectedFreeEnergy S O (coursePosterior S Q L c) (L e) P)

/-- **The softmax over the experiments** at precision `γ`: each experiment's weight is the
exponential of `-γ` times its value, over the sum over all experiments. -/
noncomputable def softmax [Fintype ε] (γ : ℝ) (G : ε → ℝ) (e : ε) : ℝ :=
  Real.exp (-γ * G e) / ∑ e', Real.exp (-γ * G e')

/-! ### The posterior after a course -/

/-- A course's likelihood is nonnegative where every likelihood is. -/
theorem courseLik_nonneg {L : ε → σ → ω → ℝ} (hL : ∀ e s o, 0 ≤ L e s o) (s : σ) :
    ∀ c, 0 ≤ courseLik L s c
  | [] => zero_le_one
  | (e, o) :: rest => mul_nonneg (hL e s o) (courseLik_nonneg hL s rest)

/-- A course's likelihood is positive where every likelihood is. -/
theorem courseLik_pos {L : ε → σ → ω → ℝ} (hL : ∀ e s o, 0 < L e s o) (s : σ) :
    ∀ c, 0 < courseLik L s c
  | [] => zero_lt_one
  | (e, o) :: rest => mul_pos (hL e s o) (courseLik_pos hL s rest)

/-- **The posterior after a course is the belief of least free energy.** With a nonnegative prior
and likelihoods, a belief over `S` that is nonnegative, totals one and is zero wherever the joint
weights are has the least free energy against them among such beliefs exactly where it is the
posterior after the course on `S` (UE17's `minimizes_iff_posterior`). Without the condition of
zero there, a belief can have less free energy under Mathlib's `log 0 = 0`. -/
theorem coursePosterior_minimizes (S : Finset σ) (Q : σ → ℝ) (L : ε → σ → ω → ℝ)
    (c : List (ε × ω)) (hQ : ∀ s ∈ S, 0 ≤ Q s) (hL : ∀ e s o, 0 ≤ L e s o) (q : σ → ℝ)
    (hq : ∀ s ∈ S, 0 ≤ q s) (hq1 : ∑ s ∈ S, q s = 1)
    (support : ∀ s ∈ S, Q s * courseLik L s c = 0 → q s = 0) :
    (∀ q' : σ → ℝ, (∀ s ∈ S, 0 ≤ q' s) → ∑ s ∈ S, q' s = 1 →
        (∀ s ∈ S, Q s * courseLik L s c = 0 → q' s = 0) →
        freeEnergy S q (fun s => Q s * courseLik L s c) ≤
          freeEnergy S q' (fun s => Q s * courseLik L s c)) ↔
      ∀ s ∈ S, q s = coursePosterior S Q L c s :=
  minimizes_iff_posterior S q _ hq hq1
    (fun s hs => mul_nonneg (hQ s hs) (courseLik_nonneg hL s c)) support

/-- **The choice weights drop out of the posterior**: for any choice weights reading the course,
the posterior of the prior times the choice weights along the course times its likelihood is the
posterior after the course, where the choice weights along it are not zero. -/
theorem posterior_choice_eq_coursePosterior (S : Finset σ) (Q : σ → ℝ) (L : ε → σ → ω → ℝ)
    (pick : List (ε × ω) → ε → ℝ) (c : List (ε × ω)) (chosen : choiceWeight pick c ≠ 0) :
    posterior S (fun s => Q s * (choiceWeight pick c * courseLik L s c)) =
      coursePosterior S Q L c := by
  funext s
  simp only [posterior, coursePosterior]
  have factor : ∀ s, Q s * (choiceWeight pick c * courseLik L s c) =
      choiceWeight pick c * (Q s * courseLik L s c) := fun s => by ring
  rw [Finset.sum_congr rfl fun s _ => factor s, ← Finset.mul_sum, factor s,
    mul_div_mul_left _ _ chosen]

/-- Choice weights that are never zero weigh every course something. -/
theorem choiceWeight_ne_zero (pick : List (ε × ω) → ε → ℝ) (never : ∀ c e, pick c e ≠ 0) :
    ∀ c, choiceWeight pick c ≠ 0
  | [] => one_ne_zero
  | (e, _) :: rest => mul_ne_zero (never rest e) (choiceWeight_ne_zero pick never rest)

/-- Scaling each experiment's likelihood by a factor scales a course's likelihood by the factors
along the course. -/
theorem courseLik_rescale (k : ε → ℝ) (L : ε → σ → ω → ℝ) (s : σ) :
    ∀ c, courseLik (fun e s o => k e * L e s o) s c =
      choiceWeight (fun _ e => k e) c * courseLik L s c
  | [] => by simp [courseLik, choiceWeight]
  | (e, o) :: rest => by
    simp only [courseLik, choiceWeight, courseLik_rescale k L s rest]
    ring

/-- **The posterior after a course does not read each experiment's scale**: scaling each
experiment's likelihood by a factor not zero, the same under every state, leaves the posterior
after every course unchanged; natural weights in sixteenths and the probabilities they stand for
give one posterior. -/
theorem coursePosterior_rescale (S : Finset σ) (Q : σ → ℝ) (L : ε → σ → ω → ℝ) (k : ε → ℝ)
    (hk : ∀ e, k e ≠ 0) (c : List (ε × ω)) :
    coursePosterior S Q (fun e s o => k e * L e s o) c = coursePosterior S Q L c := by
  show posterior S (fun s => Q s * courseLik (fun e s o => k e * L e s o) s c) = _
  simp only [courseLik_rescale]
  exact posterior_choice_eq_coursePosterior S Q L (fun _ e => k e) c
    (choiceWeight_ne_zero _ (fun _ e => hk e) c)

/-- The softmax weighs every experiment something. -/
theorem softmax_pos [Fintype ε] [Nonempty ε] (γ : ℝ) (G : ε → ℝ) (e : ε) : 0 < softmax γ G e :=
  div_pos (Real.exp_pos _) (Finset.sum_pos (fun _ _ => Real.exp_pos _) Finset.univ_nonempty)

/-- The softmax's weights total one. -/
theorem sum_softmax [Fintype ε] [Nonempty ε] (γ : ℝ) (G : ε → ℝ) : ∑ e, softmax γ G e = 1 := by
  unfold softmax
  rw [← Finset.sum_div]
  exact div_self (Finset.sum_pos (fun _ _ => Real.exp_pos _) Finset.univ_nonempty).ne'

/-- **The softmax weighs every course something**, whatever values it reads at each course. -/
theorem softmax_choiceWeight_pos [Fintype ε] [Nonempty ε] (γ : ℝ) (G : List (ε × ω) → ε → ℝ) :
    ∀ c, 0 < choiceWeight (fun c => softmax γ (G c)) c
  | [] => zero_lt_one
  | (e, _) :: rest => mul_pos (softmax_pos γ (G rest) e) (softmax_choiceWeight_pos γ G rest)

/-! ### The core's course of seeking, over the reals -/

/-- **The core's course weight, as a real number**, is the weight of the choices along the course
times the course's likelihood: the first is the same under every hypothesis. -/
theorem cast_seekWeight {α E O : Type} (choose : List (E × O) → E → ℕ) (lik : E → α → O → ℕ)
    (h : α) : ∀ c, ((LumpedSeeking.seekWeight choose lik h c : ℕ) : ℝ) =
      choiceWeight (fun c e => (choose c e : ℝ)) c * courseLik (fun e h o => (lik e h o : ℝ)) h c
  | [] => by simp [LumpedSeeking.seekWeight, choiceWeight, courseLik]
  | (e, o) :: rest => by
    simp only [LumpedSeeking.seekWeight, choiceWeight, courseLik, Nat.cast_mul,
      cast_seekWeight choose lik h rest]
    ring

/-- The mass of the event that the value is `c` is the number of times `c` is listed times its
weight. -/
theorem mass_count {Ω : Type} [DecidableEq Ω] (f : Ω → ℕ) (c : Ω) :
    ∀ l : List Ω, mass l f (fun x => decide (x = c)) = l.count c * f c
  | [] => by simp [mass]
  | y :: l => by
    show (if decide (y = c) = true then f y else 0) + mass l f (fun x => decide (x = c)) = _
    rw [mass_count f c l, List.count_cons]
    by_cases same : y = c
    · subst same
      simp
      ring
    · simp [same]

/-- **The posterior after a course is the core's share given it.** In the core's generative model of
seeking (`pairWeight prior (seekWeight choose lik)` over the hypotheses, listed once, and a list of
courses), the share of a listed hypothesis given the record that the course was `c`, a listed
course, is, as a real number, the posterior after `c` from the prior, where the choices along `c`
weigh something: the choice weights are the same under every hypothesis and drop out, as does the
number of times `c` is listed. -/
theorem givenCourse_eq_coursePosterior {α E O : Type} [DecidableEq α] [DecidableEq E]
    [DecidableEq O] (prior : α → ℕ) (choose : List (E × O) → E → ℕ) (lik : E → α → O → ℕ)
    {hs : List α} {courses : List (List (E × O))} (distinct : Distinct hs) {c : List (E × O)}
    (mem : c ∈ courses) (chosen : choiceWeight (fun c e => (choose c e : ℝ)) c ≠ 0) {h₀ : α}
    (mem₀ : h₀ ∈ hs) :
    (share (openSteps hs courses)
        (ConditionalWeights.restrict (fun x => decide (x.2 = c))
          (pairWeight prior (LumpedSeeking.seekWeight choose lik)))
        (fun x => decide (x.1 = h₀))).toReal =
      coursePosterior hs.toFinset (fun h => (prior h : ℝ)) (fun e h o => (lik e h o : ℝ)) c h₀ := by
  rw [givenShare_toReal prior (LumpedSeeking.seekWeight choose lik) courses
    (fun x => decide (x = c)) distinct mem₀]
  simp only [mass_count]
  rw [cast_mass_eq_sum _ distinct]
  simp only [Nat.cast_mul, cast_seekWeight, coursePosterior, posterior]
  have cancel : ∀ k : ℝ, k ≠ 0 →
      (prior h₀ : ℝ) * (k * (choiceWeight (fun c e => (choose c e : ℝ)) c *
        courseLik (fun e h o => (lik e h o : ℝ)) h₀ c)) /
          ∑ h ∈ hs.toFinset, (prior h : ℝ) * (k * (choiceWeight (fun c e => (choose c e : ℝ)) c *
            courseLik (fun e h o => (lik e h o : ℝ)) h c)) =
        (prior h₀ : ℝ) * courseLik (fun e h o => (lik e h o : ℝ)) h₀ c /
          ∑ h ∈ hs.toFinset, (prior h : ℝ) * courseLik (fun e h o => (lik e h o : ℝ)) h c := by
    intro k listed
    have factor : ∀ h, (prior h : ℝ) * (k * (choiceWeight (fun c e => (choose c e : ℝ)) c *
        courseLik (fun e h o => (lik e h o : ℝ)) h c)) =
          (k * choiceWeight (fun c e => (choose c e : ℝ)) c) *
            ((prior h : ℝ) * courseLik (fun e h o => (lik e h o : ℝ)) h c) :=
      fun h => by ring
    rw [Finset.sum_congr rfl fun h _ => factor h, ← Finset.mul_sum, factor h₀,
      mul_div_mul_left _ _ (mul_ne_zero listed chosen)]
  exact cancel _ (Nat.cast_ne_zero.mpr (Nat.pos_iff_ne_zero.mp
    ((@List.count_pos_iff _ instBEqOfDecidableEq _ c courses).mpr mem)))

/-- **A course never chosen has share 0**: where the choice weights along a course are zero, the
core's share of every listed hypothesis given that course is 0 as a real number, the course
weighing nothing under any hypothesis. -/
theorem unchosen_share_zero {α E O : Type} [DecidableEq α] [DecidableEq E] [DecidableEq O]
    (prior : α → ℕ) (choose : List (E × O) → E → ℕ) (lik : E → α → O → ℕ) {hs : List α}
    (courses : List (List (E × O))) (distinct : Distinct hs) {c : List (E × O)}
    (unchosen : choiceWeight (fun c e => (choose c e : ℝ)) c = 0) {h₀ : α} (mem₀ : h₀ ∈ hs) :
    (share (openSteps hs courses)
        (ConditionalWeights.restrict (fun x => decide (x.2 = c))
          (pairWeight prior (LumpedSeeking.seekWeight choose lik)))
        (fun x => decide (x.1 = h₀))).toReal = 0 := by
  rw [givenShare_toReal prior (LumpedSeeking.seekWeight choose lik) courses
    (fun x => decide (x = c)) distinct mem₀]
  simp only [mass_count, Nat.cast_mul, cast_seekWeight, unchosen, zero_mul, mul_zero, zero_div]

/-- **The core's order of two shares under one weighting is their order as real numbers**, by
cross-multiplication on one side and division on the other; where the whole weighs nothing both
hold. -/
theorem share_le_iff_toReal_le {Ω : Type*} (l : List Ω)
    (w : Ω → ℕ) (e₁ e₂ : Ω → Bool) :
    (share l w e₁).le (share l w e₂) ↔ (share l w e₁).toReal ≤ (share l w e₂).toReal := by
  unfold Share.le Share.toReal share
  dsimp only
  rcases Nat.eq_zero_or_pos (mass l w (fun _ => true)) with zero | pos
  · simp [zero]
  · have posR : (0 : ℝ) < (mass l w (fun _ => true) : ℝ) := by exact_mod_cast pos
    rw [div_le_div_iff_of_pos_right posR]
    constructor
    · intro le
      exact_mod_cast Nat.le_of_mul_le_mul_right le pos
    · intro le
      exact Nat.mul_le_mul_right _ (by exact_mod_cast le)

/-- **The core's order given a course is the order of the posterior after it**: for two listed
hypotheses, tied or not, and a listed course the policy chooses with some weight, the share of the
first given the course is at most the second's, by cross-multiplication, exactly where the
posterior after the course weighs the first at most as the second. -/
theorem givenCourse_le_iff {α E O : Type} [DecidableEq α] [DecidableEq E] [DecidableEq O]
    (prior : α → ℕ) (choose : List (E × O) → E → ℕ) (lik : E → α → O → ℕ) {hs : List α}
    {courses : List (List (E × O))} (distinct : Distinct hs) {c : List (E × O)}
    (mem : c ∈ courses) (chosen : choiceWeight (fun c e => (choose c e : ℝ)) c ≠ 0) {h₁ h₂ : α}
    (mem₁ : h₁ ∈ hs) (mem₂ : h₂ ∈ hs) :
    (share (openSteps hs courses)
        (ConditionalWeights.restrict (fun x => decide (x.2 = c))
          (pairWeight prior (LumpedSeeking.seekWeight choose lik)))
        (fun x => decide (x.1 = h₁))).le
      (share (openSteps hs courses)
        (ConditionalWeights.restrict (fun x => decide (x.2 = c))
          (pairWeight prior (LumpedSeeking.seekWeight choose lik)))
        (fun x => decide (x.1 = h₂))) ↔
      coursePosterior hs.toFinset (fun h => (prior h : ℝ)) (fun e h o => (lik e h o : ℝ)) c h₁ ≤
        coursePosterior hs.toFinset (fun h => (prior h : ℝ)) (fun e h o => (lik e h o : ℝ)) c
          h₂ := by
  rw [share_le_iff_toReal_le,
    givenCourse_eq_coursePosterior prior choose lik distinct mem chosen mem₁,
    givenCourse_eq_coursePosterior prior choose lik distinct mem chosen mem₂]

/-- **Seeking by expected free energy keeps every order every experiment ties**, an instance of the
core's law. Choosing each experiment by a rule with natural weights reading the experiments'
expected free energies, computed with any real model (`Qr`, `A`, over `S`) at the posterior after
the course so far, reads only the course, so it is one of the core's policies of choice, and
`LumpedSeeking.seeking_keeps_order` applies: where every experiment ties the true `h₁` and the false
`h₂` and the prior weighs `h₂` strictly above, every record of courses weighing something under
them leaves `h₂` above. The agent's model need not be the core's, and no join is used: every
function of the course with natural weights is one of the core's policies. A real-valued rule, the
softmax among them, is not; it is covered over the reals (`softmax_order_kept`). -/
theorem efe_seeking_keeps_order {α E O : Type} [DecidableEq α] (prior : α → ℕ)
    (lik : E → α → O → ℕ) (rule : (E → ℝ) → E → ℕ) (S : Finset α) (Os : Finset O) (Qr : α → ℝ)
    (A : E → α → O → ℝ) (P : O → ℝ) {hs : List α} (courses : List (List (E × O)))
    (rec : List (E × O) → Bool) (distinct : Distinct hs) {h₁ h₂ : α} (mem₁ : h₁ ∈ hs)
    (mem₂ : h₂ ∈ hs) (tied : ∀ e, LumpedSeeking.Tied (lik e) h₁ h₂)
    (weighs : 0 < mass courses
      (LumpedSeeking.seekWeight (efeChoice rule S Os Qr A P) lik h₁) rec)
    (wrong : prior h₁ < prior h₂) :
    ¬ (share (openSteps hs courses)
        (ConditionalWeights.restrict (fun c => rec c.2)
          (pairWeight prior (LumpedSeeking.seekWeight (efeChoice rule S Os Qr A P) lik)))
        (fun c => decide (c.1 = h₂))).le
      (share (openSteps hs courses)
        (ConditionalWeights.restrict (fun c => rec c.2)
          (pairWeight prior (LumpedSeeking.seekWeight (efeChoice rule S Os Qr A P) lik)))
        (fun c => decide (c.1 = h₁))) :=
  LumpedSeeking.seeking_keeps_order prior _ lik courses rec distinct mem₁ mem₂ tied weighs wrong

/-! ### The tie over the reals -/

/-- Two states every experiment ties have one likelihood for every course. -/
theorem courseLik_tied {L : ε → σ → ω → ℝ} {s₁ s₂ : σ} (tied : ∀ e o, L e s₁ o = L e s₂ o) :
    ∀ c, courseLik L s₁ c = courseLik L s₂ c
  | [] => rfl
  | (e, o) :: rest => by simp only [courseLik, tied e o, courseLik_tied tied rest]

/-- **Two states every experiment ties keep their prior ratio after every course**: their weights in
the posterior after it stand as their prior weights do. Under any choice weights the posterior of
the joint weights is the posterior after the course where they weigh something
(`posterior_choice_eq_coursePosterior`), so this holds under every policy. -/
theorem coursePosterior_ratio_kept (S : Finset σ) (Q : σ → ℝ) {L : ε → σ → ω → ℝ} {s₁ s₂ : σ}
    (tied : ∀ e o, L e s₁ o = L e s₂ o) (c : List (ε × ω)) :
    coursePosterior S Q L c s₁ * Q s₂ = coursePosterior S Q L c s₂ * Q s₁ := by
  simp only [coursePosterior, posterior]
  rw [courseLik_tied tied c]
  ring

/-- **No course corrects an order every experiment ties**: where the prior weighs `s₂` strictly
above `s₁`, the course's likelihood under them is positive and its weight under the prior is
positive, the posterior after the course weighs `s₂` strictly above `s₁`. By
`posterior_choice_eq_coursePosterior` this holds of the posterior of the joint weights under every
policy whose choices along the course weigh something; for the softmax, `softmax_order_kept`. -/
theorem coursePosterior_order_kept (S : Finset σ) (Q : σ → ℝ) {L : ε → σ → ω → ℝ} {s₁ s₂ : σ}
    (tied : ∀ e o, L e s₁ o = L e s₂ o) (c : List (ε × ω)) (weighs : 0 < courseLik L s₁ c)
    (total : 0 < ∑ s ∈ S, Q s * courseLik L s c) (wrong : Q s₁ < Q s₂) :
    coursePosterior S Q L c s₁ < coursePosterior S Q L c s₂ := by
  simp only [coursePosterior, posterior]
  rw [← courseLik_tied tied c]
  exact div_lt_div_of_pos_right (mul_lt_mul_of_pos_right wrong weighs) total

/-- **Under the softmax over expected free energy a tied strict order is kept**, an instance over
the reals: the softmax weighs every course something (`softmax_choiceWeight_pos`), so the posterior
of the prior times its choice weights along the course times the course's likelihood is the
posterior after the course (`posterior_choice_eq_coursePosterior`), which keeps the order where the
course is possible under the pair and weighs something under the prior
(`coursePosterior_order_kept`). -/
theorem softmax_order_kept [Fintype ε] [Nonempty ε] (S : Finset σ) (O : Finset ω) (Q : σ → ℝ)
    (L : ε → σ → ω → ℝ) (P : ω → ℝ) (γ : ℝ) {s₁ s₂ : σ} (tied : ∀ e o, L e s₁ o = L e s₂ o)
    (c : List (ε × ω)) (weighs : 0 < courseLik L s₁ c) (total : 0 < ∑ s ∈ S, Q s * courseLik L s c)
    (wrong : Q s₁ < Q s₂) :
    posterior S (fun s => Q s * (choiceWeight (efeChoice (softmax γ) S O Q L P) c *
        courseLik L s c)) s₁ <
      posterior S (fun s => Q s * (choiceWeight (efeChoice (softmax γ) S O Q L P) c *
        courseLik L s c)) s₂ := by
  have pos : 0 < choiceWeight (efeChoice (softmax γ) S O Q L P) c :=
    softmax_choiceWeight_pos γ
      (fun c e => expectedFreeEnergy S O (coursePosterior S Q L c) (L e) P) c
  rw [posterior_choice_eq_coursePosterior S Q L (efeChoice (softmax γ) S O Q L P) c pos.ne']
  exact coursePosterior_order_kept S Q tied c weighs total wrong

/-! ### Through the lumping every experiment's likelihood makes -/

section Through

variable {κ : Type*} [DecidableEq κ]

omit [DecidableEq κ] in
theorem courseLik_through (B : ε → κ → ω → ℝ) (π : σ → κ) (s : σ) :
    ∀ c, courseLik (fun e s => B e (π s)) s c = courseLik B (π s) c
  | [] => rfl
  | (e, o) :: rest => by simp only [courseLik, courseLik_through B π s rest]

theorem coarse_div (S : Finset σ) (f : σ → ℝ) (Z : ℝ) (π : σ → κ) (k : κ) :
    coarse S (fun s => f s / Z) π k = coarse S f π k / Z := by
  unfold coarse
  rw [Finset.sum_div]

/-- **Conditioning commutes with the lumping.** Where every experiment's likelihood reads a state
only through its class, the posterior after any course, summed over a class, is the posterior after
the course over the classes, from the classes' prior weights. -/
theorem coarse_coursePosterior (S : Finset σ) (Q : σ → ℝ) (π : σ → κ) (B : ε → κ → ω → ℝ)
    (c : List (ε × ω)) (k : κ) :
    coarse S (coursePosterior S Q (fun e s => B e (π s)) c) π k =
      coursePosterior (S.image π) (coarse S Q π) B c k := by
  have num : coarse S (fun s => Q s * courseLik (fun e s => B e (π s)) s c) π k =
      coarse S Q π k * courseLik B k c := by
    unfold coarse
    rw [Finset.sum_mul]
    exact Finset.sum_congr rfl fun s hs => by
      simp only [courseLik_through, (Finset.mem_filter.mp hs).2]
  have den : ∑ s ∈ S, Q s * courseLik (fun e s => B e (π s)) s c =
      ∑ k ∈ S.image π, coarse S Q π k * courseLik B k c := by
    simp only [courseLik_through]
    exact sum_through S Q π (fun k => courseLik B k c)
  have unfolded : coursePosterior S Q (fun e s => B e (π s)) c = fun s =>
      Q s * courseLik (fun e s => B e (π s)) s c /
        ∑ j ∈ S, Q j * courseLik (fun e s => B e (π s)) j c := rfl
  rw [unfolded, coarse_div, num, den]
  rfl

/-- **At every step, every experiment's expected free energy is the classes'**: through the lumping,
at the posterior after any course, it is the expected free energy over the classes at the classes'
posterior after the course. -/
theorem efe_through_course (S : Finset σ) (O : Finset ω) (Q : σ → ℝ) (π : σ → κ)
    (B : ε → κ → ω → ℝ) (P : ω → ℝ) (c : List (ε × ω)) (e : ε) :
    expectedFreeEnergy S O (coursePosterior S Q (fun e s => B e (π s)) c) (fun s => B e (π s)) P =
      expectedFreeEnergy (S.image π) O (coursePosterior (S.image π) (coarse S Q π) B c) (B e)
        P := by
  rw [expectedFreeEnergy_through S O _ π (B e) P, funext (coarse_coursePosterior S Q π B c)]

/-- **At every step, every experiment's epistemic value is the classes'**: the information its
outcomes are expected to carry, at the posterior after any course, is information about the classes
alone. -/
theorem epistemic_through_course (S : Finset σ) (O : Finset ω) (Q : σ → ℝ) (π : σ → κ)
    (B : ε → κ → ω → ℝ) (c : List (ε × ω)) (e : ε) :
    epistemic S O (coursePosterior S Q (fun e s => B e (π s)) c) (fun s => B e (π s)) =
      epistemic (S.image π) O (coursePosterior (S.image π) (coarse S Q π) B c) (B e) := by
  rw [epistemic_through S O _ π (B e), funext (coarse_coursePosterior S Q π B c)]

/-- **A course's predictive weight is the classes'**: through the lumping, under any policy. -/
theorem courseWeight_through (S : Finset σ) (Q : σ → ℝ) (π : σ → κ) (B : ε → κ → ω → ℝ)
    (pick : List (ε × ω) → ε → ℝ) (c : List (ε × ω)) :
    courseWeight S Q (fun e s => B e (π s)) pick c =
      courseWeight (S.image π) (coarse S Q π) B pick c := by
  unfold courseWeight
  simp only [courseLik_through]
  rw [sum_through S Q π (fun k => courseLik B k c)]

/-- **Two priors alike on the classes choose alike by expected free energy at every course**, under
every rule, of any kind of value. -/
theorem efeChoice_same_of_coarse {τ : Type*} (S : Finset σ) (O : Finset ω) {Q Q' : σ → ℝ}
    (π : σ → κ) (B : ε → κ → ω → ℝ) (P : ω → ℝ) (alike : ∀ k, coarse S Q π k = coarse S Q' π k)
    (rule : (ε → ℝ) → ε → τ) :
    efeChoice rule S O Q (fun e s => B e (π s)) P =
      efeChoice rule S O Q' (fun e s => B e (π s)) P := by
  have same : coarse S Q π = coarse S Q' π := funext alike
  funext c
  unfold efeChoice
  simp only [efe_through_course, same]

/-- **Seeking by expected free energy is blind to the split within a class.** Where every
experiment's likelihood reads a state only through its class, two priors alike on the classes
choose alike at every course under every rule reading the experiments' expected free energies, give
every course one predictive weight, and give every course one weight under every state: no course
of seeking by expected free energy, its choices or the weights of its outcomes, turns on how the
prior splits a class. -/
theorem seeking_blind_to_split (S : Finset σ) (O : Finset ω) {Q Q' : σ → ℝ} (π : σ → κ)
    (B : ε → κ → ω → ℝ) (P : ω → ℝ) (alike : ∀ k, coarse S Q π k = coarse S Q' π k)
    (rule : (ε → ℝ) → ε → ℝ) :
    (∀ c, efeChoice rule S O Q (fun e s => B e (π s)) P c =
        efeChoice rule S O Q' (fun e s => B e (π s)) P c) ∧
      (∀ c, courseWeight S Q (fun e s => B e (π s))
          (efeChoice rule S O Q (fun e s => B e (π s)) P) c =
        courseWeight S Q' (fun e s => B e (π s))
          (efeChoice rule S O Q' (fun e s => B e (π s)) P) c) ∧
      ∀ s c, choiceWeight (efeChoice rule S O Q (fun e s => B e (π s)) P) c *
          courseLik (fun e s => B e (π s)) s c =
        choiceWeight (efeChoice rule S O Q' (fun e s => B e (π s)) P) c *
          courseLik (fun e s => B e (π s)) s c := by
  have choices := efeChoice_same_of_coarse S O π B P alike rule
  have same : coarse S Q π = coarse S Q' π := funext alike
  refine ⟨fun c => congrFun choices c, fun c => ?_, fun s c => by rw [choices]⟩
  rw [courseWeight_through S Q π B, courseWeight_through S Q' π B, same, choices]

/-- **The softmax over expected free energy is blind to the split too**, at every precision: an
instance of `seeking_blind_to_split`. -/
theorem softmax_blind_to_split [Fintype ε] (S : Finset σ) (O : Finset ω) {Q Q' : σ → ℝ}
    (π : σ → κ) (B : ε → κ → ω → ℝ) (P : ω → ℝ) (alike : ∀ k, coarse S Q π k = coarse S Q' π k)
    (γ : ℝ) (c : List (ε × ω)) :
    courseWeight S Q (fun e s => B e (π s))
        (efeChoice (softmax γ) S O Q (fun e s => B e (π s)) P) c =
      courseWeight S Q' (fun e s => B e (π s))
        (efeChoice (softmax γ) S O Q' (fun e s => B e (π s)) P) c :=
  (seeking_blind_to_split S O π B P alike (softmax γ)).2.1 c

end Through

open Classical in
/-- **Seeking by expected free energy reads the prior only through the weight it gives each
likelihood profile.** For any likelihoods, take as a state's class its profile, its likelihood under
every experiment: two priors giving every profile one total weight choose alike at every course
under every rule reading the experiments' expected free energies, and give every course one
predictive weight. What no experiment tells apart, no course of seeking by expected free energy
tells apart, in its choices or in the weights of its outcomes. -/
theorem seeking_reads_profiles (S : Finset σ) (O : Finset ω) {Q Q' : σ → ℝ}
    (L : ε → σ → ω → ℝ) (P : ω → ℝ)
    (alike : ∀ k, coarse S Q (fun s e => L e s) k = coarse S Q' (fun s e => L e s) k)
    (rule : (ε → ℝ) → ε → ℝ) :
    (∀ c, efeChoice rule S O Q L P c = efeChoice rule S O Q' L P c) ∧
      ∀ c, courseWeight S Q L (efeChoice rule S O Q L P) c =
        courseWeight S Q' L (efeChoice rule S O Q' L P) c :=
  let blind := seeking_blind_to_split S O (fun s e => L e s) (fun e k => k e) P alike rule
  ⟨blind.1, blind.2.1⟩

end Seeking

/-! ## Witnesses: the coin of `Becoming.LumpedSeeking` over the reals -/

namespace Witness

open Becoming.ConditionalWeights LumpedSeeking.Agree

/-- Every weight of the model reading agreement is positive. -/
theorem agreeing_pos (_ : Unit) (h : Bias) (o : Bool × Bool) : 0 < (agreeing h o : ℝ) := by
  rcases o with ⟨_ | _, _ | _⟩ <;> cases h <;> norm_num [agreeing]

/-- **In the coin, an outcome of a separating experiment turns the posterior; where every experiment
ties, no course does.** With the coin's prior (5, 6 and 7 for the heads-biased, the fair and the
tails-biased coin) and its two experiments over the reals, after two heads read by the experiment
reading both tosses the posterior puts the true heads-biased coin above the tails-biased one; in the
model whose only experiment reads whether the tosses agree, the tails-biased coin stays above after
every course (`coursePosterior_order_kept`). -/
theorem separating_turns :
    coursePosterior hypotheses.toFinset (fun h => (prior h : ℝ))
        (fun e h o => (experiment e h o : ℝ)) [(true, (true, true))] Bias.tails <
      coursePosterior hypotheses.toFinset (fun h => (prior h : ℝ))
        (fun e h o => (experiment e h o : ℝ)) [(true, (true, true))] Bias.heads ∧
    ∀ c, coursePosterior hypotheses.toFinset (fun h => (prior h : ℝ))
        (fun (_ : Unit) h o => (agreeing h o : ℝ)) c Bias.heads <
      coursePosterior hypotheses.toFinset (fun h => (prior h : ℝ))
        (fun (_ : Unit) h o => (agreeing h o : ℝ)) c Bias.tails := by
  constructor
  · simp only [coursePosterior, posterior]
    apply div_lt_div_of_pos_right
    · norm_num [courseLik, experiment, readBoth, prior]
    · simp [hypotheses, courseLik, experiment, readBoth, prior]
      norm_num
  · intro c
    refine coursePosterior_order_kept _ _ (fun _ o => by rw [ties o]) c
      (courseLik_pos agreeing_pos _ c) ?_ (by norm_num [prior])
    exact Finset.sum_pos
      (fun h _ => mul_pos (by cases h <;> norm_num [prior]) (courseLik_pos agreeing_pos h c))
      ⟨Bias.heads, by simp [hypotheses]⟩

/-- **Where the policy never chooses the course, the core's share given it is not the posterior.**
The policy choosing the experiment reading both tosses never chooses the course of two heads read by
the experiment reading agreement: the core's share given that course has whole nothing, so it is 0
as a real number, while the posterior after the course is not. -/
theorem unchosen_course :
    (share (openSteps hypotheses [[(false, (true, true))]])
        (ConditionalWeights.restrict (fun x => decide (x.2 = [(false, (true, true))]))
          (pairWeight prior (LumpedSeeking.seekWeight pickReading experiment)))
        (fun x => decide (x.1 = Bias.heads))).toReal = 0 ∧
    coursePosterior hypotheses.toFinset (fun h => (prior h : ℝ))
        (fun e h o => (experiment e h o : ℝ)) [(false, (true, true))] Bias.heads ≠ 0 := by
  constructor
  · have whole : (share (openSteps hypotheses [[(false, (true, true))]])
        (ConditionalWeights.restrict (fun x => decide (x.2 = [(false, (true, true))]))
          (pairWeight prior (LumpedSeeking.seekWeight pickReading experiment)))
        (fun x => decide (x.1 = Bias.heads))).whole = 0 := by decide
    unfold Share.toReal
    rw [whole, Nat.cast_zero, div_zero]
  · simp only [coursePosterior, posterior]
    apply div_ne_zero
    · norm_num [courseLik, experiment, agreeing, prior]
    · simp [hypotheses, courseLik, experiment, agreeing, prior]
      norm_num

/-- The classes the model reading agreement makes: the fair coin apart from the two biases. -/
def biasClass (h : Bias) : Bool := decide (h = Bias.fair)

/-- **Two experiments**: one reading whether the two tosses agree, and one telling nothing, which
gives every outcome the weight 4 under every coin. -/
noncomputable def agreeOrNothing (e : Bool) (h : Bias) (o : Bool × Bool) : ℝ :=
  if e then (agreeing h o : ℝ) else 4

/-- The two experiments, read through the classes. -/
noncomputable def agreeOrNothingByClass (e : Bool) (k : Bool) (o : Bool × Bool) : ℝ :=
  if e then (if k then (agreeing Bias.fair o : ℝ) else (agreeing Bias.heads o : ℝ)) else 4

/-- A second prior: the coin's, the weights of the heads-biased and the tails-biased coins
exchanged. -/
def swappedPrior : Bias → ℕ
  | .heads => 7
  | .fair => 6
  | .tails => 5

/-- Both experiments read a coin only through its class. -/
theorem agreeOrNothing_through :
    (fun e s => agreeOrNothingByClass e (biasClass s)) = agreeOrNothing := by
  funext e h o
  cases e
  · rfl
  · cases h
    · rfl
    · rfl
    · show (agreeing Bias.heads o : ℝ) = (agreeing Bias.tails o : ℝ)
      exact_mod_cast ties o

/-- The coin's prior and the swapped prior are alike on the classes. -/
theorem priors_alike (k : Bool) :
    coarse hypotheses.toFinset (fun h => (prior h : ℝ)) biasClass k =
      coarse hypotheses.toFinset (fun h => (swappedPrior h : ℝ)) biasClass k := by
  have listed : hypotheses.toFinset = ({Bias.heads, Bias.fair, Bias.tails} : Finset Bias) := by
    decide
  rw [listed]
  cases k
  · simp [coarse, Finset.filter_insert, Finset.filter_singleton, biasClass, prior, swappedPrior]
    norm_num
  · simp [coarse, Finset.filter_insert, Finset.filter_singleton, biasClass, prior, swappedPrior]

/-- **The blindness bites: the two priors' posteriors differ, their seeking does not.** With the
experiment reading agreement and the one telling nothing, the coin's prior and the swapped prior are
alike on the classes: after two heads read by the first experiment their posteriors weigh the
heads-biased coin differently (25 and 35 in 84), while for every rule reading the two experiments'
expected free energies, every set of outcomes and every preference, they give both experiments the
same weights at every course and give every course one predictive weight
(`seeking_blind_to_split`). -/
theorem split_unseen :
    coursePosterior hypotheses.toFinset (fun h => (prior h : ℝ)) agreeOrNothing
        [(true, (true, true))] Bias.heads ≠
      coursePosterior hypotheses.toFinset (fun h => (swappedPrior h : ℝ)) agreeOrNothing
        [(true, (true, true))] Bias.heads ∧
    ∀ (O : Finset (Bool × Bool)) (P : Bool × Bool → ℝ) (rule : (Bool → ℝ) → Bool → ℝ),
      (∀ c, efeChoice rule hypotheses.toFinset O (fun h => (prior h : ℝ)) agreeOrNothing P c =
        efeChoice rule hypotheses.toFinset O (fun h => (swappedPrior h : ℝ)) agreeOrNothing P c) ∧
      ∀ c, courseWeight hypotheses.toFinset (fun h => (prior h : ℝ)) agreeOrNothing
          (efeChoice rule hypotheses.toFinset O (fun h => (prior h : ℝ)) agreeOrNothing P) c =
        courseWeight hypotheses.toFinset (fun h => (swappedPrior h : ℝ)) agreeOrNothing
          (efeChoice rule hypotheses.toFinset O (fun h => (swappedPrior h : ℝ)) agreeOrNothing P)
          c := by
  constructor
  · simp only [coursePosterior, posterior]
    simp [hypotheses, courseLik, agreeOrNothing, agreeing, prior, swappedPrior]
    norm_num
  · intro O P rule
    rw [← agreeOrNothing_through]
    let blind := seeking_blind_to_split hypotheses.toFinset O biasClass agreeOrNothingByClass P
      priors_alike rule
    exact ⟨blind.1, blind.2.1⟩

end Witness

end Becoming.ExpectedFreeEnergy
