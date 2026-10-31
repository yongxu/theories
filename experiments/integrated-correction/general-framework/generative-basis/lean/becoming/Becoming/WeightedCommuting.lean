import Becoming.Commuting

/-!
# What a weighted law commuting with an exchange keeps: no drive on what the law does not read

`Becoming.Commuting` states what a law of change commuting with a map `σ` keeps: the run from
`σ x` is the image of the run from `x`, and what `σ` fixes stays fixed. This module states the same
for a law that goes from each configuration to finitely many successors, each with a weight: a
learner drawing its samples and updating from them, a population moved by a kernel, any process
read through weights. The weights are of any type with addition, multiplication and zero, and no
law of that arithmetic is used.

* **Commuting, for a weighted law** (`Weighted.Commutes`): the successors of `σ x` are those of
  `x` carried by `σ`, weights included, read through every weighted total. A deterministic law
  commuting with `σ` (`Law.Commutes`) is a case (`law_commutes`).
* **What commutes is kept in expectation.** For a weighted law commuting with `σ`, the expectation
  of any observable `n` steps on from `σ x` is the expectation of the observable read through `σ`
  from `x` (`Commutes.carried`). From a configuration `σ` fixes, or from starting weights `σ` leaves
  unchanged, every expectation equals the expectation of its image under `σ` at every step
  (`Commutes.fixed_expect`, `Commutes.start_expect`).
* **A learner** (`Commutes.of_samples`). A law that draws one of finitely many samples with a
  weight read off the configuration and moves by an update commutes with `σ` where some map of the
  samples permutes them, the weight of a sample at `σ x` is the weight of its image at `x`, and the
  update at `σ x` is `σ` of the update at `x` from the image sample. For a learner choosing among
  values the reward and the dynamics do not read, with `σ` exchanging two such values in its
  parameters, these are the conditions that its policy and its optimizer treat the two values
  alike.
* **Reading (AI).** Where neither the reward nor the dynamics read a choice, a learner whose
  sampling and update commute with exchanging two of its values, started where the exchange
  changes nothing, drives neither value in expectation at any step: the expected weight of each is
  the other's.
  A drive on such a choice, of either sign, needs a start the exchange changes, a prior preference
  for one value, or a learner that treats the values apart.
* **Witnesses on two values** (`Reinforcing`, `Pooling`). Reinforcing, drawing a value in
  proportion to its count and adding one to the value drawn, commutes with the exchange
  (`Reinforcing.commutes`); from equal counts the expected counts stay equal at every step
  (`Reinforcing.expect_equal`), while a run drawing one value at every one of any number of steps
  has positive weight (`Reinforcing.oneSided`): equal expectations allow arbitrarily long one-sided
  runs. Pooling, adding one to both values, commutes with the exchange (`Pooling.commutes`); from
  counts of three and one the share of the less drawn value rises at every step and stays below
  one half (`Pooling.run_counts`, `Pooling.share_rises`, `Pooling.share_below_half`): a commuting
  law can wear away a start's asymmetry, nothing reading the choice.

What is not derived: which learners commute with an exchange. For a policy-gradient learner it is
a property of its parametrization and optimizer, checked on the learner, not stated here; a
learner reading its own past choices commutes only with its inputs exchanged as well, and a
random initialization only in distribution. Normalized weights (probabilities), the expectation's
value as a number and any rate of drift are not stated. No ethical predicate or axiom occurs.
-/

namespace Becoming

universe u v w

namespace Weighted

variable {S : Type u} {W : Type v} [Add W] [Mul W] [Zero W]

omit [Mul W] [Zero W] in
/-- Sums of equals are equal. -/
theorem add_congr {a b c d : W} (ab : a = b) (cd : c = d) : a + c = b + d := ab ▸ cd ▸ rfl

/-- The weighted total of a quantity over finitely many weighted configurations. -/
def total : List (W × S) → (W × S → W) → W
  | [], _ => 0
  | p :: ps, F => F p + total ps F

omit [Mul W] in
/-- Totals of quantities agreeing on the list agree. -/
theorem total_congr {F G : W × S → W} :
    ∀ {ps : List (W × S)}, (∀ p, p ∈ ps → F p = G p) → total ps F = total ps G
  | [], _ => rfl
  | p :: _, same => add_congr (same p (List.Mem.head _))
      (total_congr fun q m => same q (List.Mem.tail p m))

/-- The weighted expectation of an observable `n` steps on, under a law going from each
configuration to finitely many weighted successors. -/
def expect (K : S → List (W × S)) : Nat → (S → W) → S → W
  | 0, f, x => f x
  | n + 1, f, x => total (K x) fun p => p.1 * expect K n f p.2

/-- A weighted law commutes with `σ`: every weighted total over the successors of `σ x` is the
total over the successors of `x` carried by `σ`. -/
def Commutes (K : S → List (W × S)) (σ : S → S) : Prop :=
  ∀ x (F : W × S → W), total (K (σ x)) F = total (K x) fun p => F (p.1, σ p.2)

variable {K : S → List (W × S)} {σ : S → S}

/-- **What commutes is kept in expectation.** -/
theorem Commutes.carried (commutes : Commutes K σ) :
    ∀ (n : Nat) (f : S → W) (x : S), expect K n f (σ x) = expect K n (fun y => f (σ y)) x
  | 0, _, _ => rfl
  | n + 1, f, x => (commutes x _).trans
      (total_congr fun p _ => congrArg (p.1 * ·) (Commutes.carried commutes n f p.2))

/-- **From a configuration the exchange fixes, every expectation equals its image's.** -/
theorem Commutes.fixed_expect (commutes : Commutes K σ) {x : S} (fixed : σ x = x) (n : Nat)
    (f : S → W) : expect K n f x = expect K n (fun y => f (σ y)) x :=
  (congrArg (expect K n f) fixed).symm.trans (commutes.carried n f x)

/-- Starting weights `σ` leaves unchanged. -/
def Unchanged (μ : List (W × S)) (σ : S → S) : Prop :=
  ∀ F : W × S → W, total μ F = total μ fun p => F (p.1, σ p.2)

/-- **From starting weights the exchange leaves unchanged, every expectation equals its
image's.** -/
theorem Commutes.start_expect (commutes : Commutes K σ) {μ : List (W × S)} (unchanged : Unchanged μ σ)
    (n : Nat) (f : S → W) :
    total μ (fun p => p.1 * expect K n f p.2) =
      total μ fun p => p.1 * expect K n (fun y => f (σ y)) p.2 :=
  (unchanged _).trans (total_congr fun p _ => congrArg (p.1 * ·) (commutes.carried n f p.2))

/-! ## A deterministic law -/

/-- A law of change as a weighted law: one successor, of weight one. -/
def law [OfNat W 1] (T : S → S) : S → List (W × S) := fun x => [(1, T x)]

omit [Mul W] in
/-- **A commuting law commutes as a weighted law.** -/
theorem law_commutes [OfNat W 1] {T : S → S} (commutes : Law.Commutes T σ) :
    Commutes (law (W := W) T) σ := fun x F =>
  congrArg (fun y => F (1, y) + (0 : W)) (commutes x)

/-! ## A learner: samples, their weights and an update -/

section Samples

variable {Ω : Type w}

/-- The weighted total of a quantity over finitely many samples. -/
def over : List Ω → (Ω → W) → W
  | [], _ => 0
  | ω :: ωs, G => G ω + over ωs G

omit [Mul W] in
theorem total_map (P : S → Ω → W) (U : S → Ω → S) (x : S) (F : W × S → W) :
    ∀ ωs : List Ω, total (ωs.map fun ω => (P x ω, U x ω)) F = over ωs fun ω => F (P x ω, U x ω)
  | [] => rfl
  | ω :: ωs => congrArg (F (P x ω, U x ω) + ·) (total_map P U x F ωs)

omit [Mul W] in
theorem over_congr {G H : Ω → W} : ∀ (ωs : List Ω), (∀ ω, G ω = H ω) → over ωs G = over ωs H
  | [], _ => rfl
  | ω :: ωs, same => add_congr (same ω) (over_congr ωs same)

omit [Mul W] in
/-- **A learner commutes with an exchange** where a map of the samples permutes them, the weight
of a sample at `σ x` is the weight of its image at `x`, and the update at `σ x` is `σ` of the
update at `x` from the image sample. -/
theorem Commutes.of_samples (ωs : List Ω) (τ : Ω → Ω)
    (permutes : ∀ G : Ω → W, over ωs (fun ω => G (τ ω)) = over ωs G)
    (P : S → Ω → W) (U : S → Ω → S) (weight : ∀ x ω, P (σ x) ω = P x (τ ω))
    (update : ∀ x ω, U (σ x) ω = σ (U x (τ ω))) :
    Commutes (fun x => ωs.map fun ω => (P x ω, U x ω)) σ := fun x F =>
  (total_map P U (σ x) F ωs).trans
    ((over_congr ωs fun ω => (weight x ω) ▸ (update x ω) ▸ rfl).trans
      ((permutes fun ω => F (P x ω, σ (U x ω))).trans
        (total_map P U x (fun p => F (p.1, σ p.2)) ωs).symm))

end Samples

/-! ## Witnesses on two values -/

/-- Exchanging the counts of two values. -/
def swap (c : Nat × Nat) : Nat × Nat := (c.2, c.1)

namespace Reinforcing

/-- Reinforcing: draw a value with weight its count, and add one to the value drawn. -/
def law (c : Nat × Nat) : List (Nat × (Nat × Nat)) := [(c.1, (c.1 + 1, c.2)), (c.2, (c.1, c.2 + 1))]

/-- **Reinforcing commutes with the exchange.** -/
theorem commutes : Commutes law swap := fun c F =>
  show F (c.2, (c.2 + 1, c.1)) + (F (c.1, (c.2, c.1 + 1)) + 0) =
      F (c.1, (c.2, c.1 + 1)) + (F (c.2, (c.2 + 1, c.1)) + 0) from
  (congrArg (F (c.2, (c.2 + 1, c.1)) + ·) (Nat.add_zero _)).trans
    ((Nat.add_comm _ _).trans (congrArg (F (c.1, (c.2, c.1 + 1)) + ·) (Nat.add_zero _).symm))

/-- **From equal counts the expected counts stay equal at every step.** -/
theorem expect_equal (k n : Nat) :
    expect law n (fun c => c.2) (k, k) = expect law n (fun c => c.1) (k, k) :=
  Commutes.fixed_expect commutes rfl n _

/-- The run drawing the second value every time. -/
def oneSidedRun : Nat → Nat × Nat → Nat × Nat
  | 0, c => c
  | n + 1, c => oneSidedRun n (c.1, c.2 + 1)

/-- The weight of that run: the product of the counts it draws with. -/
def oneSidedWeight : Nat → Nat × Nat → Nat
  | 0, _ => 1
  | n + 1, c => c.2 * oneSidedWeight n (c.1, c.2 + 1)

theorem oneSidedRun_eq : ∀ (n a b : Nat), oneSidedRun n (a, b) = (a, b + n)
  | 0, _, _ => rfl
  | n + 1, a, b => (oneSidedRun_eq n a (b + 1)).trans (congrArg (a, ·) (Nat.add_right_comm b 1 n))

theorem oneSidedWeight_pos : ∀ (n a b : Nat), 0 < b → 0 < oneSidedWeight n (a, b)
  | 0, _, _, _ => Nat.zero_lt_one
  | n + 1, a, b, pos => Nat.mul_pos pos (oneSidedWeight_pos n a (b + 1) (Nat.succ_pos b))

/-- **A run can stay one-sided.** From counts of one and one, drawing the second value at every
one of `n` steps has positive weight and ends at one and `n + 1`. -/
theorem oneSided (n : Nat) : 0 < oneSidedWeight n (1, 1) ∧ oneSidedRun n (1, 1) = (1, 1 + n) :=
  ⟨oneSidedWeight_pos n 1 1 Nat.zero_lt_one, oneSidedRun_eq n 1 1⟩

end Reinforcing

namespace Pooling

/-- Pooling: one added to both values at every step. -/
def step (c : Nat × Nat) : Nat × Nat := (c.1 + 1, c.2 + 1)

/-- **Pooling commutes with the exchange.** -/
theorem commutes : Law.Commutes step swap := fun _ => rfl

/-- **From counts of three and one, after `k` steps the counts are `3 + k` and `1 + k`.** -/
theorem run_counts : ∀ k : Nat, (Law.run step (3, 1)).state k = (3 + k, 1 + k)
  | 0 => rfl
  | k + 1 => (congrArg step (run_counts k)).trans
      (congr (congrArg Prod.mk (Nat.add_assoc 3 k 1)) (Nat.add_assoc 1 k 1))

/-- **The share of the less drawn value rises at every step**: of total `4 + 2k`, it is
`(1 + k) / (4 + 2k)`, below `(2 + k) / (6 + 2k)`, compared across. -/
theorem share_rises (k : Nat) : (1 + k) * (6 + 2 * k) < (2 + k) * (4 + 2 * k) := by
  have left : (1 + k) * (6 + 2 * k) = (1 + k) * (4 + 2 * k) + (1 + k) * 2 := by
    rw [← Nat.left_distrib, Nat.add_right_comm 4 (2 * k) 2]
  have right : (2 + k) * (4 + 2 * k) = (1 + k) * (4 + 2 * k) + (4 + 2 * k) := by
    rw [show 2 + k = 1 + (1 + k) from Nat.add_assoc 1 1 k, add_mul_split, Nat.one_mul]
    exact Nat.add_comm _ _
  rw [left, right]
  apply Nat.add_lt_add_left
  rw [add_mul_split, Nat.one_mul, Nat.mul_comm k 2]
  exact Nat.add_lt_add_right (by decide : 2 < 4) (2 * k)

/-- **And stays below one half.** -/
theorem share_below_half (k : Nat) : 2 * (1 + k) < (3 + k) + (1 + k) := by
  rw [Nat.two_mul]
  exact Nat.add_lt_add_right (Nat.add_lt_add_right (by decide : 1 < 3) k) (1 + k)

end Pooling

end Weighted

end Becoming
