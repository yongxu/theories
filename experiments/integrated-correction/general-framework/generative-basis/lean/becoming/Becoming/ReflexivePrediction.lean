import Becoming.Keeping
import Becoming.Recurrence

/-!
# A prediction read by what it predicts

A prediction published before what it predicts, and read by it, is one more input to the course it
predicts: the outcome is the response to the prediction. This module states when such a prediction
is right (board item RF, round 2: RF6.3).

* **Right exactly where the response leaves it.** A published prediction read by the response is
  right exactly where the response to it is itself (`Right`). Where the response moves every value,
  no published prediction is right (`none_right_of_moves`), and no predictor is right on every
  admitted response once one admitted response moves every value, even a predictor reading the
  response itself (`no_predictor_right`); for two values, negation is such a response
  (`ListTests.not_ne_self`). A predictor right on every admitted response exists exactly where each admitted
  response leaves some value, given choice over the admitted responses (`predictor_iff`).
* **Repeated publication.** Publishing at each step the outcome of the step before is the
  response's orbit (`Law.orbit`): a step's prediction is right exactly where the next step publishes
  it again (`rests_iff_right`), and a right prediction, once published or once the outcome, is
  published at every later step (`right_rests`, `reached_rests`).
* **A response keeping the order, on a chain.** On the values `0, …, n` with a response keeping
  them and their order, repeated publication from the bottom rises (`rises`), stays at or below every
  right prediction (`below_right`) and is right by step `n` (`bottom_rests`): the least right
  prediction, reached within the chain's length. Where two predictions are right, the one reached is
  decided by where publication starts (`ThresholdResponse`): zero and two are fixed points, and
  publication from zero stays zero, while from one it reaches two after one step and stays there.
* **Boolean negation leaves no value fixed.** On two values, negation leaves none, so no published
  prediction is right and repeated publication alternates for ever (`Negating`). A response reversing
  an order need not leave a value fixed, though some do: on `0, 1, 2`, the reflection `2 − v` reverses
  the order and fixes `1` (`Reflecting`).

**Readings** [AI reading]. Self-fulfilling and self-defeating prophecy (Merton 1948): a public
prediction is one more input to what it predicts. In the bounded scalar setup, a continuous response
mapping a closed interval into itself has a correct public prediction (Grunberg and Modigliani 1954;
Simon 1954), by a fixed-point theorem that gives existence, not the reaching of it by repeated
publication; here, discretely, a response keeping a finite chain and its order reaches the least
right prediction from the bottom by step `n` (Tarski 1955 for the fixed point). The bandwagon and
the underdog effect read as responses keeping and reversing the order. The fixed-point structure is
related to performative stability (Perdomo, Zrnic, Mendler-Dünner and Hardt 2020), defined there by
risk minimization on the distribution a deployed model induces; where deployment yields `r p` and
retraining returns that outcome exactly, retraining is this orbit, and no general correspondence with
risk minimization is proved. Several right predictions, the one reached decided by where publication
starts, is read as self-fulfilling runs (Diamond and Dybvig 1983); the witness is a threshold
response with two fixed points, not a model of coordination. A formation predicting its own act,
where the act reads the prediction and negates it, has no right self-prediction: the one-step form of
the self-reading gap (`Diagonal.gap_unsaid`), whose course form is `Learning.diagonal_misses`. These
are readings, not containments.

**Modelling choices.** The response a function of the prediction alone, read before the outcome;
natural numbers for the chain; no probabilities, so no forecast calibration. Every declaration has
an empty axiom report. No ethical predicate, ranking or axiom occurs.
-/

namespace Becoming

namespace ReflexivePrediction

universe u

variable {V : Type u}

/-- A prediction `p`, published and read by the response `r`, is right: the outcome, the response to
it, is `p`. -/
def Right (r : V → V) (p : V) : Prop := r p = p

/-- **Where the response moves every value, no published prediction is right.** -/
theorem none_right_of_moves {r : V → V} (moves : ∀ v, r v ≠ v) (p : V) : ¬ Right r p :=
  moves p

/-- **No predictor is right on every admitted response once one admitted response moves every
value**, even a predictor reading the response itself. -/
theorem no_predictor_right {admitted : (V → V) → Prop} {r : V → V} (holds : admitted r)
    (moves : ∀ v, r v ≠ v) :
    ¬ ∃ predict : (V → V) → V, ∀ r', admitted r' → Right r' (predict r') :=
  fun ⟨predict, right⟩ => moves (predict r) (right r holds)

/-- **A predictor right on every admitted response exists exactly where each admitted response
leaves some value**, given choice over the admitted responses. -/
theorem predictor_iff {admitted : (V → V) → Prop}
    (choice : Viability.ChoiceOver {r : V → V // admitted r} V) :
    (∃ predict : {r : V → V // admitted r} → V, ∀ r, Right r.1 (predict r)) ↔
      ∀ r : V → V, admitted r → ∃ p, Right r p :=
  ⟨fun ⟨predict, right⟩ r holds => ⟨predict ⟨r, holds⟩, right ⟨r, holds⟩⟩,
   fun each => choice (fun r p => Right r.1 p) fun r => each r.1 r.2⟩

/-! ## Repeated publication -/

/-- **A step's prediction is right exactly where the next step publishes it again.** -/
theorem rests_iff_right (r : V → V) (p : V) (n : Nat) :
    Law.orbit r p (n + 1) = Law.orbit r p n ↔ Right r (Law.orbit r p n) :=
  Iff.rfl

/-- **A right prediction is published again at every later step.** -/
theorem right_rests {r : V → V} {p : V} (right : Right r p) : ∀ n, Law.orbit r p n = p
  | 0 => rfl
  | n + 1 => (congrArg r (right_rests right n)).trans right

/-- **A prediction whose outcome is a right one is followed by it at every later step.** -/
theorem reached_rests {r : V → V} {p q : V} (first : r p = q) (right : Right r q) :
    ∀ n, Law.orbit r p (n + 1) = q
  | 0 => first
  | n + 1 => (congrArg r (reached_rests first right n)).trans right

/-! ## A response keeping the order, on a chain -/

section Chain

variable {n : Nat} {r : Nat → Nat}

/-- **Repeated publication from the bottom stays on the chain.** -/
theorem on_chain (within : ∀ v, v ≤ n → r v ≤ n) : ∀ k, Law.orbit r 0 k ≤ n
  | 0 => Nat.zero_le n
  | k + 1 => within _ (on_chain within k)

/-- **Repeated publication from the bottom rises**, under a response keeping the chain and its
order. -/
theorem rises (within : ∀ v, v ≤ n → r v ≤ n) (keeps : ∀ v w, v ≤ w → w ≤ n → r v ≤ r w) :
    ∀ k, Law.orbit r 0 k ≤ Law.orbit r 0 (k + 1)
  | 0 => Nat.zero_le _
  | k + 1 => keeps _ _ (rises within keeps k) (on_chain within (k + 1))

/-- **Repeated publication from the bottom stays at or below every right prediction on the
chain.** -/
theorem below_right (keeps : ∀ v w, v ≤ w → w ≤ n → r v ≤ r w) {f : Nat} (on : f ≤ n)
    (right : Right r f) : ∀ k, Law.orbit r 0 k ≤ f
  | 0 => Nat.zero_le f
  | k + 1 => Nat.le_trans (keeps _ _ (below_right keeps on right k) on) (Nat.le_of_eq right)

/-- Once a step publishes again, every later step does. -/
theorem stays_from (r : Nat → Nat) {j : Nat} (again : Law.orbit r 0 (j + 1) = Law.orbit r 0 j) :
    ∀ m, Law.orbit r 0 (j + m) = Law.orbit r 0 j
  | 0 => rfl
  | m + 1 => (congrArg r (stays_from r again m)).trans again

/-- Before step `k`, either some step published again, or the prediction has risen at least
`k`. -/
theorem again_or_risen (within : ∀ v, v ≤ n → r v ≤ n) (keeps : ∀ v w, v ≤ w → w ≤ n → r v ≤ r w) :
    ∀ k, (∃ j, j < k ∧ Law.orbit r 0 (j + 1) = Law.orbit r 0 j) ∨ k ≤ Law.orbit r 0 k
  | 0 => .inr (Nat.zero_le _)
  | k + 1 =>
    match again_or_risen within keeps k with
    | .inl ⟨j, before, again⟩ => .inl ⟨j, Nat.lt_succ_of_lt before, again⟩
    | .inr risen =>
      match Nat.decEq (Law.orbit r 0 (k + 1)) (Law.orbit r 0 k) with
      | isTrue again => .inl ⟨k, Nat.lt_succ_self k, again⟩
      | isFalse moved =>
        .inr (Nat.succ_le_of_lt (Nat.lt_of_le_of_lt risen
          (Nat.lt_of_le_of_ne (rises within keeps k) fun same => moved same.symm)))

/-- **On a chain of `n + 1` values with a response keeping them and their order, repeated publication
from the bottom is right by step `n`**, and stays at or below every right prediction there: the
least right prediction, reached within the chain's length. -/
theorem bottom_rests (within : ∀ v, v ≤ n → r v ≤ n) (keeps : ∀ v w, v ≤ w → w ≤ n → r v ≤ r w) :
    Right r (Law.orbit r 0 n) ∧ ∀ f, f ≤ n → Right r f → Law.orbit r 0 n ≤ f :=
  ⟨match again_or_risen within keeps (n + 1) with
    | .inl ⟨j, before, again⟩ =>
      match Nat.le.dest (Nat.le_of_lt_succ before) with
      | ⟨m, sum⟩ =>
        have at_n : Law.orbit r 0 n = Law.orbit r 0 j := sum ▸ stays_from r again m
        have at_next : Law.orbit r 0 (n + 1) = Law.orbit r 0 j :=
          (congrArg r at_n).trans again
        at_next.trans at_n.symm
    | .inr risen => absurd (Nat.le_trans risen (on_chain within (n + 1))) (Nat.not_succ_le_self n),
   fun _ on right => below_right keeps on right n⟩

end Chain

/-! ## Two right predictions, the one reached decided by the first published -/

namespace ThresholdResponse

/-- On the values `0`, `1`, `2`, a response by threshold: two where anything is predicted, zero where
nothing is. -/
def threshold (v : Nat) : Nat := if 1 ≤ v then 2 else 0

/-- It keeps the chain and its order. -/
theorem within : ∀ v, v ≤ 2 → threshold v ≤ 2 :=
  fun v _ => match Nat.decLe 1 v with
    | isTrue one => Nat.le_of_eq (if_pos one)
    | isFalse below => Nat.le_trans (Nat.le_of_eq (if_neg below)) (Nat.zero_le 2)

theorem keeps : ∀ v w, v ≤ w → w ≤ 2 → threshold v ≤ threshold w :=
  fun v _ le _ => match Nat.decLe 1 v with
    | isTrue one => Nat.le_of_eq ((if_pos one).trans (if_pos (Nat.le_trans one le)).symm)
    | isFalse below => Nat.le_trans (Nat.le_of_eq (if_neg below)) (Nat.zero_le _)

/-- **Zero and two are both right.** -/
theorem both_right : Right threshold 0 ∧ Right threshold 2 := ⟨rfl, rfl⟩

/-- **Where publication starts decides the right prediction reached**: from zero it stays zero; from
one it reaches two after one step and stays there. -/
theorem reached_by_start : ∀ k, Law.orbit threshold 0 k = 0 ∧ Law.orbit threshold 1 (k + 1) = 2
  | k => ⟨right_rests both_right.1 k, reached_rests rfl both_right.2 k⟩

end ThresholdResponse

/-! ## Boolean negation leaves no value fixed -/

namespace Negating

/-- On two values, negation. -/
def negate (v : Bool) : Bool := !v

/-- **It leaves no value fixed**, so no published prediction is right. -/
theorem none_right : ∀ p, ¬ Right negate p :=
  none_right_of_moves ListTests.not_ne_self

/-- **Repeated publication alternates for ever**: no step publishes again. -/
theorem alternates : ∀ p k, Law.orbit negate p (k + 1) ≠ Law.orbit negate p k :=
  fun _ k => none_right (Law.orbit negate _ k)

end Negating

/-! ## A response reversing the order can leave a value fixed -/

namespace Reflecting

/-- On `0, 1, 2`, the reflection. -/
def reflect (v : Nat) : Nat := 2 - v

/-- **It reverses the order.** -/
theorem reverses {v w : Nat} (le : v ≤ w) : reflect w ≤ reflect v :=
  Naturals.sub_antitone 2 le

/-- **And leaves the middle fixed.** -/
theorem middle_right : Right reflect 1 := rfl

end Reflecting

end ReflexivePrediction

end Becoming
