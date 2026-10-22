import Becoming.Typicality
import Becoming.Joint

/-!
# Situations: what natural weights count

Ren, 16 October 2026: "we are describing what everything obeys, but at every moment, the actual
change depends on the situation", and "just saying we are all one doesn't make it true, the
situation makes it true". `Becoming.Weighted` leaves open where weights come from;
`Becoming.Typicality` counts courses by natural weights and does not derive that the course
which happens is typical. This module states, with no premise, what natural weights are when
each step is taken in situations that each fix it.

* **With the situation as the move, the law is determined.** A step weighing `k` is taken in `k`
  situations. The law whose moves are the situations (`finerLaw`) is determined
  (`finerLaw_determined`). It takes a step exactly where that step has a situation, that is,
  positive weight (`finerLaw_step_iff`). A law whose steps are those of positive weight is this
  determined law with the situation forgotten.
* **Natural weights count situations.** Each finer course (`finer`) takes the course it forgets to
  (`coarse`). For every process with listed moves and configurations and every natural weighting
  of its steps, summing any reading of the courses over the finer courses of `n` steps is summing
  it over the courses, each counted by its weight (`sum_finer`). So the finer courses number the
  sum over histories (`finer_count`, through `Weights.sum_courses`). Nothing is assumed beyond
  the weighting.
* **The law of large numbers counts situations.** On two values, with `p` situations for one and
  `q` for the other at each step (`Typicality.stepWeight`), there are `(p + q) ^ n` finer courses
  of `n` steps (`situations_count`), and the weight of a course is the number of them that take
  it (`situations_of_course`, each course occurring once, `total_only`). Those whose course
  deviates by at least `d` number, times `d`, at most `n·p·q·(p + q)^n` (`situations_typical`,
  from `Typicality.typical`, through `sum_courses_values`, which reads Weighted's courses of free
  branching as Typicality's).
  Most situations of a kind give frequencies near the ratio of the weights. Which situation is
  the one that happens is not a count, and nothing here fixes it.
* **Any number of values counts as two through an event.** Take free branching on any listed
  values, each with a natural weight (`valueWeight`), read through any event. Summing a reading
  of what the event shows over the courses, each counted by its weight, is summing it over
  Typicality's courses with the event's weight `P` (`inside`) for one and the rest's `Q`
  (`outside`) for the other (`sum_event`). So the law of large numbers (`event_typical`) and
  exponential concentration (`event_concentrated`) count situations for every event, out of
  `(P + Q) ^ n` finer courses (`event_count`). Each value is an event, so in most situations
  each value's frequency is near its share of the weight.
* **Counting per course, for every process.** The finer courses taking a course number its
  weight times how often the course is listed (`situations_take`). Where every move and
  configuration is listed once, they number its weight (`situations_of_course_listed`).
* **Signed weights count situations of two kinds.** In any weights, steps whose weights are sums
  over their situations are counted by those situations (`sum_finer_weights`). A signed step
  `(P, N)` is `P` situations that add and `N` that subtract (`signed_sums`). Every finer course
  composes to adding or to subtracting (`signs_unit`), and the signed transfer is the pair of
  the two counts (`signed_counts`). Where signed weights cancel, the situations do not: the
  balanced `(1, 1)` of `Interference.cancels` is two situations (`cancels_situations`). A
  cancellation is a balance between counts of situations of opposite sign, not an absence of
  situations.

Classical sources: the law of large numbers counted here is Bernoulli's weak law (1713), through
Chebyshev's inequality (1867), and the exponential concentration is Chernoff's bound (1952), as
credited in `Becoming.Typicality`; reading a probability as a number of situations of a kind is the
classical (Laplacean) ratio of favourable to possible cases, here with the cases weighted by their
situations.

The arithmetic uses the core's `mul_assoc_nat` and `add_mul_split`, since the prelude's associativity of
multiplication uses propositional extensionality.

What is not derived: which situation is actual; weights that are neither natural numbers nor
pairs of them, such as real or complex amplitudes. A count of situations does not cancel
(`counting_transfer_iff`); signed weights cancel in what adds against what subtracts, and the
situations they count do not (`cancels_situations`). No ethical predicate, ranking or axiom occurs. Ren took the AI's readings of their words on
16 October 2026 ("yes, i take those readings"): the core states what every situation obeys,
the situation makes the actual change true, and a chance is a number of situations of a kind.
* **The move alone underdetermines.** Where a step by `a` from `s` has situations reaching two
  configurations, the finer law takes both by the same move and no law giving the next configuration
  from the configuration and the move alone is right on both (`move_underdetermines`):
  `Confound.misattributes` generalized.
-/

namespace Becoming

open Generative

namespace Situations

universe u v

/-! ## Counting the first `k` numbers -/

/-- A reading constant over the first `k` numbers sums to `k` times it. -/
theorem sum_upto (c : Nat) : ∀ k, counting.sum (Undecided.upto k) (fun _ => c) = k * c
  | 0 => (Nat.zero_mul c).symm
  | k + 1 => by
    show c + counting.sum (Undecided.upto k) (fun _ => c) = (k + 1) * c
    rw [sum_upto c k, Nat.succ_mul, Nat.add_comm]

/-! ## The law with the situation as the move -/

section Finer

variable {S : Type u} {A : Type v}

/-- The law whose moves are situations: the situation `(a, m, k)` takes a configuration `s` to
`m`, where it is one of the `weight s a m` situations of the step by `a` to `m`. -/
def finerLaw (weight : S → A → S → Nat) : Process S (A × S × Nat) :=
  ⟨fun s x t => t = x.2.1 ∧ x.2.2 < weight s x.1 x.2.1⟩

/-- **With the situation as the move, the law is determined.** -/
theorem finerLaw_determined (weight : S → A → S → Nat) : Determined (finerLaw weight) :=
  fun _ _ _ _ first second => first.1.trans second.1.symm

/-- **The finer law takes a step exactly where the step has a situation.** -/
theorem finerLaw_step_iff (weight : S → A → S → Nat) {s m : S} {a : A} :
    (∃ k, (finerLaw weight).step s (a, m, k) m) ↔ 0 < weight s a m :=
  ⟨fun ⟨_, _, within⟩ => Nat.lt_of_le_of_lt (Nat.zero_le _) within,
   fun positive => ⟨0, rfl, positive⟩⟩

/-- The situations of the open steps from `s`: each open step `(a, m)` once for each of the
`weight s a m` situations taking it. -/
def finerSteps (weight : S → A → S → Nat) (moves : List A) (all : List S) (s : S) :
    List (A × S × Nat) :=
  joinMap (fun p => (Undecided.upto (weight s p.1 p.2)).map fun k => (p.1, p.2, k)) (openSteps moves all)

/-- The finer courses of `n` steps from `s`: every sequence of situations, each taken from where
the one before leads. -/
def finer (weight : S → A → S → Nat) (moves : List A) (all : List S) : Nat → S →
    List (List (A × S × Nat))
  | 0, _ => [[]]
  | n + 1, s => joinMap (fun x => (finer weight moves all n x.2.1).map fun h => x :: h)
      (finerSteps weight moves all s)

/-- The course a finer course takes: its steps with the situation forgotten. -/
def coarse : List (A × S × Nat) → List (A × S)
  | [] => []
  | x :: h => (x.1, x.2.1) :: coarse h

/-- **Natural weights count situations.** For every natural weighting of the steps, summing any
reading of the courses over the finer courses of `n` steps is summing it over the courses of
`n` steps, each counted by its weight. -/
theorem sum_finer (weight : S → A → S → Nat) (moves : List A) (all : List S) :
    ∀ (n : Nat) (s : S) (g : List (A × S) → Nat),
      counting.sum (finer weight moves all n s) (fun h => g (coarse h)) =
        counting.sum (courses moves all n)
          (fun c => counting.along weight (fun _ => 1) s c * g c)
  | 0, _, g => by
    show g [] + 0 = 1 * g [] + 0
    rw [Nat.one_mul]
  | n + 1, s, g =>
    have inner : ∀ x : A × S × Nat,
        counting.sum ((finer weight moves all n x.2.1).map fun h => x :: h)
            (fun h => g (coarse h)) =
          counting.sum (courses moves all n)
            (fun c => counting.along weight (fun _ => 1) x.2.1 c * g ((x.1, x.2.1) :: c)) :=
      fun x => (Weights.sum_map _ _ _).trans
        (sum_finer weight moves all n x.2.1 fun c => g ((x.1, x.2.1) :: c))
    have each : ∀ p : A × S,
        counting.sum ((Undecided.upto (weight s p.1 p.2)).map fun k => (p.1, p.2, k))
            (fun x => counting.sum (courses moves all n)
              (fun c => counting.along weight (fun _ => 1) x.2.1 c * g ((x.1, x.2.1) :: c))) =
          counting.sum (courses moves all n)
            (fun c => counting.along weight (fun _ => 1) s (p :: c) * g (p :: c)) :=
      fun p => (Weights.sum_map _ _ _).trans
        ((sum_upto (counting.sum (courses moves all n)
            (fun c => counting.along weight (fun _ => 1) p.2 c * g (p :: c))) _).trans
          ((Weights.mul_sum (W := counting) (weight s p.1 p.2) _ _).trans
            (Weights.sum_congr _ fun c _ => (mul_assoc_nat _ _ _).symm)))
    have whole : counting.sum (courses moves all (n + 1))
          (fun c => counting.along weight (fun _ => 1) s c * g c) =
        counting.sum (openSteps moves all) (fun p => counting.sum (courses moves all n)
          (fun c => counting.along weight (fun _ => 1) s (p :: c) * g (p :: c))) :=
      (Weights.sum_joinMap _ _ _).trans (Weights.sum_congr _ fun _ _ => Weights.sum_map _ _ _)
    (Weights.sum_joinMap _ _ _).trans <|
      (Weights.sum_congr _ fun x _ => inner x).trans <|
      (Weights.sum_joinMap _ _ _).trans <|
      (Weights.sum_congr _ fun p _ => each p).trans whole.symm

/-- **The finer courses number the sum over histories.** -/
theorem finer_count (weight : S → A → S → Nat) (moves : List A) (all : List S) (n : Nat)
    (s : S) :
    (finer weight moves all n s).length = counting.transfer weight moves all (fun _ => 1) n s :=
  (sum_one _).symm.trans <|
    (sum_finer weight moves all n s fun _ => 1).trans <|
    (Weights.sum_congr _ fun _ _ => Nat.mul_one _).trans
      (Weights.sum_courses weight moves all (fun _ => 1) n s)

/-- **The move alone does not fix the outcome where it has two situations.** Where a step by `a`
from `s` has situations reaching two different configurations, the finer law takes both, by the
same move, and no law giving the next configuration from the configuration and the move alone is
right on both: whatever difference between them is set down to the move is misattributed. -/
theorem move_underdetermines (weight : S → A → S → Nat) {s m m' : S} {a : A} (ne : m ≠ m')
    (pos : 0 < weight s a m) (pos' : 0 < weight s a m') :
    (finerLaw weight).step s (a, m, 0) m ∧ (finerLaw weight).step s (a, m', 0) m' ∧
      ∀ next : S → A → S, ¬ (next s a = m ∧ next s a = m') :=
  ⟨⟨rfl, pos⟩, ⟨rfl, pos'⟩, fun _ ⟨first, second⟩ => ne (first.symm.trans second)⟩

end Finer

/-! ## Two values -/

/-- **Free branching on two values has Typicality's courses.** Summing a reading of the values
over the histories of `n` steps is summing it over the courses of `n` steps. -/
theorem sum_courses_values (F : List Bool → Nat) : ∀ n,
    counting.sum (Becoming.courses [()] [true, false] n) (fun c => F (c.map Prod.snd)) =
      total (Typicality.courses n) F
  | 0 => rfl
  | n + 1 =>
    have each : ∀ b : Bool,
        counting.sum ((Becoming.courses [()] [true, false] n).map fun h => ((), b) :: h)
            (fun c => F (c.map Prod.snd)) =
          total (Typicality.courses n) (fun w => F (b :: w)) :=
      fun b => (Weights.sum_map _ _ _).trans (sum_courses_values (fun w => F (b :: w)) n)
    (Weights.sum_joinMap _ _ _).trans <| by
      show counting.sum ((Becoming.courses [()] [true, false] n).map fun h => ((), true) :: h)
            (fun c => F (c.map Prod.snd)) +
          (counting.sum ((Becoming.courses [()] [true, false] n).map fun h => ((), false) :: h)
            (fun c => F (c.map Prod.snd)) + 0) =
        total (Typicality.extend (Typicality.courses n)) F
      rw [each true, each false, Nat.add_zero, Typicality.total_extend, Typicality.total_add]

/-- **There are `(p + q) ^ n` finer courses of `n` steps.** With `p` situations for one value
and `q` for the other at each step. -/
theorem situations_count (p q n : Nat) (s : Bool) :
    (finer (Typicality.stepWeight p q) [()] [true, false] n s).length = (p + q) ^ n :=
  (finer_count _ _ _ n s).trans (Typicality.transfer_weight p q n s)

/-- Multiplying by one where a condition holds and by nothing otherwise. -/
theorem mul_indicator (x : Nat) (c : Prop) [Decidable c] :
    x * (if c then 1 else 0) = if c then x else 0 :=
  if holds : c then by rw [if_pos holds, if_pos holds, Nat.mul_one]
  else by rw [if_neg holds, if_neg holds, Nat.mul_zero]

/-- Each course of `n` steps occurs once among the courses: a reading kept at `w` alone sums
to its value at `w`. -/
theorem total_only (f : List Bool → Nat) : ∀ (n : Nat) (w : List Bool), w.length = n →
    total (Typicality.courses n) (fun v => if v = w then f v else 0) = f w
  | 0, [], _ => by
    show (if ([] : List Bool) = [] then f [] else 0) + 0 = f []
    rw [if_pos rfl, Nat.add_zero]
  | 0, _ :: _, len => nomatch len
  | _ + 1, [], len => nomatch len
  | n + 1, b :: w, len => by
    have same : ∀ v, (if true :: v = b :: w then f (true :: v) else 0) +
        (if false :: v = b :: w then f (false :: v) else 0) =
          (if v = w then f (b :: v) else 0) := fun v =>
      if here : v = w then
        match b with
        | true => by
          rw [if_pos (congrArg _ here), if_neg (fun e => Bool.noConfusion (List.cons.inj e).1),
            if_pos here, Nat.add_zero]
        | false => by
          rw [if_neg (fun e => Bool.noConfusion (List.cons.inj e).1),
            if_pos (congrArg _ here), if_pos here, Nat.zero_add]
      else by
        rw [if_neg (fun e => here (List.cons.inj e).2), if_neg (fun e => here (List.cons.inj e).2),
          if_neg here]
    show total (Typicality.extend (Typicality.courses n)) _ = _
    rw [Typicality.total_extend, Typicality.total_congr same]
    exact total_only (fun v => f (b :: v)) n w (Nat.succ.inj len)

/-- **The weight of a course is the number of situations that take it.** With `p` situations
for one value and `q` for the other at each step, the finer courses taking a course with `a`
ones and `b` zeros number `p ^ a · q ^ b`, its weight. -/
theorem situations_of_course (p q : Nat) (s : Bool) (w : List Bool) :
    counting.sum (finer (Typicality.stepWeight p q) [()] [true, false] w.length s)
        (fun h => if (coarse h).map Prod.snd = w then 1 else 0) = Typicality.weight p q w :=
  (sum_finer _ _ _ w.length s fun c => if c.map Prod.snd = w then 1 else 0).trans <|
    (Weights.sum_congr _ fun c _ =>
      congrArg (· * (if c.map Prod.snd = w then 1 else 0)) (Typicality.along_weight p q s c)).trans <|
    (sum_courses_values (fun v => Typicality.weight p q v * (if v = w then 1 else 0))
      w.length).trans <|
    (Typicality.total_congr (fun v => mul_indicator (Typicality.weight p q v) (v = w)) _).trans
      (total_only (Typicality.weight p q) w.length w rfl)

/-- One where a course deviates by at least `d`, and nothing otherwise. -/
def far (p q d : Nat) (w : List Bool) : Nat :=
  if d + Typicality.cross p q w ≤ Typicality.square p q w then 1 else 0

theorem weight_far (p q d : Nat) (w : List Bool) :
    Typicality.weight p q w * far p q d w = Typicality.offBy p q d w :=
  mul_indicator _ _

/-- **The law of large numbers counts situations.** Of the `(p + q) ^ n` finer courses of `n`
steps, those whose course deviates by at least `d` number, times `d`, at most
`n·p·q·(p + q)^n`. -/
theorem situations_typical (p q n d : Nat) (s : Bool) :
    counting.sum (finer (Typicality.stepWeight p q) [()] [true, false] n s)
        (fun h => far p q d ((coarse h).map Prod.snd)) * d ≤ n * (p * q * (p + q) ^ n) := by
  have count : counting.sum (finer (Typicality.stepWeight p q) [()] [true, false] n s)
        (fun h => far p q d ((coarse h).map Prod.snd)) =
      total (Typicality.courses n) (Typicality.offBy p q d) :=
    (sum_finer _ _ _ n s fun c => far p q d (c.map Prod.snd)).trans <|
      (Weights.sum_congr _ fun c _ =>
        congrArg (· * far p q d (c.map Prod.snd)) (Typicality.along_weight p q s c)).trans <|
      (sum_courses_values (fun w => Typicality.weight p q w * far p q d w) n).trans
        (Typicality.total_congr (weight_far p q d) _)
  rw [count]
  exact Typicality.typical p q n d

/-! ## Any number of values: an event -/

section Event

variable {V : Type u}

/-- A weight kept where the event holds. -/
def keep : Bool → Nat → Nat
  | true, x => x
  | false, _ => 0

/-- A weight kept where the event fails. -/
def drop : Bool → Nat → Nat
  | true, _ => 0
  | false, x => x

/-- The weight of the values where the event holds. -/
def inside (vals : List V) (wt : V → Nat) (event : V → Bool) : Nat :=
  counting.sum vals fun v => keep (event v) (wt v)

/-- The weight of the values where the event fails. -/
def outside (vals : List V) (wt : V → Nat) (event : V → Bool) : Nat :=
  counting.sum vals fun v => drop (event v) (wt v)

theorem keep_drop (G : Bool → Nat) (x : Nat) : ∀ b,
    x * G b = keep b x * G true + drop b x * G false
  | true => by
    show x * G true = x * G true + 0 * G false
    rw [Nat.zero_mul, Nat.add_zero]
  | false => by
    show x * G false = 0 * G true + x * G false
    rw [Nat.zero_mul, Nat.zero_add]

/-- A reading of the event, summed over the values with their weights, splits into the event's
weight and the rest's. -/
theorem sum_split (wt : V → Nat) (event : V → Bool) (G : Bool → Nat) : ∀ vals : List V,
    counting.sum vals (fun v => wt v * G (event v)) =
      inside vals wt event * G true + outside vals wt event * G false
  | [] => by
    show 0 = 0 * G true + 0 * G false
    rw [Nat.zero_mul, Nat.zero_mul]
  | v :: vals => by
    show wt v * G (event v) + counting.sum vals (fun v => wt v * G (event v)) =
      (keep (event v) (wt v) + inside vals wt event) * G true +
        (drop (event v) (wt v) + outside vals wt event) * G false
    rw [sum_split wt event G vals, keep_drop G (wt v) (event v), add_mul_split, add_mul_split,
      Nat.add_add_add_comm]

theorem inside_add_outside (wt : V → Nat) (event : V → Bool) : ∀ vals : List V,
    inside vals wt event + outside vals wt event = counting.sum vals wt
  | [] => rfl
  | v :: vals => by
    show (keep (event v) (wt v) + inside vals wt event) +
        (drop (event v) (wt v) + outside vals wt event) = wt v + counting.sum vals wt
    rw [Nat.add_add_add_comm, inside_add_outside wt event vals]
    exact congrArg (· + _) (match event v with | true => Nat.add_zero _ | false => Nat.zero_add _)

/-- Free branching on any values, a step to `v` weighing `wt v` whatever it comes from. -/
def valueWeight (wt : V → Nat) (_ : V) (_ : Unit) (v : V) : Nat := wt v

/-- What an event shows along a course of values. -/
def seen (event : V → Bool) (c : List (Unit × V)) : List Bool := c.map fun x => event x.2

/-- **Any number of values, read through an event, counts as two.** For every list of values
with natural weights and every event, summing a reading of what the event shows over the
courses of `n` steps, each counted by its weight, is summing it over Typicality's courses with
the event's weight for one and the rest's for the other. -/
theorem sum_event (vals : List V) (wt : V → Nat) (event : V → Bool) : ∀ (n : Nat) (s : V)
    (F : List Bool → Nat),
    counting.sum (Becoming.courses [()] vals n)
        (fun c => counting.along (valueWeight wt) (fun _ => 1) s c * F (seen event c)) =
      total (Typicality.courses n)
        (fun w => Typicality.weight (inside vals wt event) (outside vals wt event) w * F w)
  | 0, _, F => by
    show 1 * F [] + 0 = 1 * F [] + 0
    rfl
  | n + 1, s, F =>
    have each : ∀ v : V,
        counting.sum ((Becoming.courses [()] vals n).map fun h => ((), v) :: h)
            (fun c => counting.along (valueWeight wt) (fun _ => 1) s c * F (seen event c)) =
          wt v * total (Typicality.courses n)
            (fun w => Typicality.weight (inside vals wt event) (outside vals wt event) w *
              F (event v :: w)) :=
      fun v => (Weights.sum_map _ _ _).trans <|
        (Weights.sum_congr _ fun c _ => mul_assoc_nat (wt v) _ _).trans <|
        (Weights.mul_sum (W := counting) (wt v) _ _).symm.trans
          (congrArg (wt v * ·) (sum_event vals wt event n v fun w => F (event v :: w)))
    have steps : ∀ g : Unit × V → Nat,
        counting.sum (openSteps [()] vals) g = counting.sum vals fun v => g ((), v) :=
      fun g => (Weights.sum_joinMap _ _ _).trans <|
        (Nat.add_zero _).trans (Weights.sum_map _ _ _)
    (Weights.sum_joinMap _ _ _).trans <|
      (steps _).trans <|
      (Weights.sum_congr _ fun v _ => each v).trans <|
      (sum_split wt event (fun b => total (Typicality.courses n)
        (fun w => Typicality.weight (inside vals wt event) (outside vals wt event) w *
          F (b :: w))) vals).trans <| by
      show _ = total (Typicality.extend (Typicality.courses n)) _
      rw [Typicality.total_extend, Typicality.total_add, ← Typicality.total_mul,
        ← Typicality.total_mul]
      exact congr (congrArg _ (Typicality.total_congr (fun w => (mul_assoc_nat _ _ _).symm) _))
        (Typicality.total_congr (fun w => (mul_assoc_nat _ _ _).symm) _)

/-- **The law of large numbers counts situations for every event.** With `wt v` situations for
each value `v` at each step, the finer courses of `n` steps whose event deviates by at least `d`
from the ratio of the event's weight to the rest's number, times `d`, at most
`n·P·Q·(P + Q)^n`, where `P + Q` is the weight of all values. -/
theorem event_typical (vals : List V) (wt : V → Nat) (event : V → Bool) (n d : Nat) (s : V) :
    counting.sum (finer (valueWeight wt) [()] vals n s)
        (fun h => far (inside vals wt event) (outside vals wt event) d (seen event (coarse h))) * d ≤
      n * (inside vals wt event * outside vals wt event *
        (inside vals wt event + outside vals wt event) ^ n) := by
  have count : counting.sum (finer (valueWeight wt) [()] vals n s)
        (fun h => far (inside vals wt event) (outside vals wt event) d (seen event (coarse h))) =
      total (Typicality.courses n)
        (Typicality.offBy (inside vals wt event) (outside vals wt event) d) :=
    (sum_finer _ _ _ n s fun c =>
        far (inside vals wt event) (outside vals wt event) d (seen event c)).trans <|
      (sum_event vals wt event n s _).trans
        (Typicality.total_congr (weight_far _ _ d) _)
  rw [count]
  exact Typicality.typical _ _ n d

/-- **Exponentially few situations run far ahead for every event.** For every `u ≥ v`, the
finer courses of `n` steps in which the event holds at least `k` times number, times
`u ^ k · v ^ n`, at most `(P·u + Q·v) ^ n · v ^ k`. -/
theorem event_concentrated (vals : List V) (wt : V → Nat) (event : V → Bool) (k n : Nat)
    (s : V) {u v : Nat} (le : v ≤ u) :
    counting.sum (finer (valueWeight wt) [()] vals n s)
        (fun h => if k ≤ Typicality.ones (seen event (coarse h)) then 1 else 0) *
        (u ^ k * v ^ n) ≤
      (inside vals wt event * u + outside vals wt event * v) ^ n * v ^ k := by
  have count : counting.sum (finer (valueWeight wt) [()] vals n s)
        (fun h => if k ≤ Typicality.ones (seen event (coarse h)) then 1 else 0) =
      total (Typicality.courses n)
        (Typicality.atLeast (inside vals wt event) (outside vals wt event) k) :=
    (sum_finer _ _ _ n s fun c => if k ≤ Typicality.ones (seen event c) then 1 else 0).trans <|
      (sum_event vals wt event n s _).trans
        (Typicality.total_congr (fun w => mul_indicator _ (k ≤ Typicality.ones w)) _)
  rw [count]
  exact Typicality.concentrated _ _ k n le

/-- The finer courses number `(P + Q) ^ n`, the weight of all values to the `n`. -/
theorem event_count (vals : List V) (wt : V → Nat) (n : Nat) (s : V) :
    (finer (valueWeight wt) [()] vals n s).length = (counting.sum vals wt) ^ n :=
  (sum_one _).symm.trans <|
    (sum_finer _ _ _ n s fun _ => 1).trans <|
    (sum_event vals wt (fun _ => true) n s fun _ => 1).trans <|
    (Typicality.total_congr (fun _ => Nat.mul_one _) _).trans <|
    (Typicality.total_weight _ _ n).trans
      (congrArg (· ^ n) (inside_add_outside wt (fun _ => true) vals))

end Event

/-! ## Counting per course, for every process -/

section Course

variable {S : Type u} {A : Type v}

/-- How often a list holds `a`. -/
def occ {α : Type u} [DecidableEq α] (l : List α) (a : α) : Nat :=
  counting.sum l fun x => if x = a then 1 else 0

/-- A reading kept at `a` alone sums to how often the list holds `a`, times its value. -/
theorem sum_only {α : Type u} [DecidableEq α] (a : α) (K : Nat) : ∀ l : List α,
    counting.sum l (fun x => if x = a then K else 0) = occ l a * K
  | [] => (Nat.zero_mul K).symm
  | x :: l => by
    show (if x = a then K else 0) + counting.sum l (fun x => if x = a then K else 0) =
      ((if x = a then 1 else 0) + occ l a) * K
    rw [sum_only a K l, add_mul_split, Nat.mul_comm (if x = a then 1 else 0) K, mul_indicator]

/-- **The situations taking a course number its weight times how often it is listed.** For
every process with listed moves and configurations and every natural weighting of its steps. -/
theorem situations_take [DecidableEq A] [DecidableEq S] (weight : S → A → S → Nat)
    (moves : List A) (all : List S) (n : Nat) (s : S) (c : List (A × S)) :
    counting.sum (finer weight moves all n s) (fun h => if coarse h = c then 1 else 0) =
      occ (courses moves all n) c * counting.along weight (fun _ => 1) s c :=
  (sum_finer weight moves all n s fun c' => if c' = c then 1 else 0).trans <|
    (Weights.sum_congr _ fun c' _ => (mul_indicator _ _).trans
      (if same : c' = c then by rw [if_pos same, if_pos same, same]
       else by rw [if_neg same, if_neg same])).trans
      (sum_only c _ _)

theorem occ_map_cons {α : Type u} [DecidableEq α] (p' p : α) (c : List α) :
    ∀ l : List (List α), occ (l.map (p' :: ·)) (p :: c) = if p' = p then occ l c else 0
  | [] => if same : p' = p then (if_pos same).symm else (if_neg same).symm
  | x :: l => by
    show (if p' :: x = p :: c then 1 else 0) + occ (l.map (p' :: ·)) (p :: c) =
      if p' = p then (if x = c then 1 else 0) + occ l c else 0
    rw [occ_map_cons p' p c l]
    exact if first : p' = p then
      if rest : x = c then by
        rw [if_pos (show p' :: x = p :: c by rw [first, rest]), if_pos first, if_pos first,
          if_pos rest]
      else by
        rw [if_neg (fun e => rest (List.cons.inj e).2), if_pos first, if_pos first, if_neg rest]
    else by
      rw [if_neg (fun e => first (List.cons.inj e).1), if_neg first, if_neg first]

theorem occ_map_pair [DecidableEq A] [DecidableEq S] (a' a : A) (m : S) :
    ∀ l : List S, occ (l.map fun m' => (a', m')) (a, m) = if a' = a then occ l m else 0
  | [] => if same : a' = a then (if_pos same).symm else (if_neg same).symm
  | x :: l => by
    show (if (a', x) = (a, m) then 1 else 0) + occ (l.map fun m' => (a', m')) (a, m) =
      if a' = a then (if x = m then 1 else 0) + occ l m else 0
    rw [occ_map_pair a' a m l]
    exact if first : a' = a then
      if rest : x = m then by
        rw [if_pos (show (a', x) = (a, m) by rw [first, rest]), if_pos first, if_pos first,
          if_pos rest]
      else by
        rw [if_neg (fun e => rest (Prod.mk.inj e).2), if_pos first, if_pos first, if_neg rest]
    else by
      rw [if_neg (fun e => first (Prod.mk.inj e).1), if_neg first, if_neg first]

theorem occ_openSteps [DecidableEq A] [DecidableEq S] (moves : List A) (all : List S) (a : A)
    (m : S) : occ (openSteps moves all) (a, m) = occ moves a * occ all m :=
  (Weights.sum_joinMap _ _ _).trans <|
    (Weights.sum_congr _ fun a' _ => occ_map_pair a' a m all).trans (sum_only a _ _)

theorem occ_courses [DecidableEq A] [DecidableEq S] (moves : List A) (all : List S) (n : Nat)
    (p : A × S) (c : List (A × S)) :
    occ (courses moves all (n + 1)) (p :: c) =
      occ (openSteps moves all) p * occ (courses moves all n) c :=
  (Weights.sum_joinMap _ _ _).trans <|
    (Weights.sum_congr _ fun p' _ => occ_map_cons p' p c _).trans (sum_only p _ _)

/-- Where every move and configuration is listed once, every course of `n` steps is listed
once among the courses of `n` steps. -/
theorem occ_courses_once [DecidableEq A] [DecidableEq S] {moves : List A} {all : List S}
    (once_moves : ∀ a, occ moves a = 1) (once_all : ∀ m, occ all m = 1) :
    ∀ c : List (A × S), occ (courses moves all c.length) c = 1
  | [] => by
    show (if ([] : List (A × S)) = [] then 1 else 0) + 0 = 1
    rw [if_pos rfl]
  | p :: c => by
    rw [List.length_cons, occ_courses, occ_courses_once once_moves once_all c,
      occ_openSteps moves all p.1 p.2, once_moves, once_all]

/-- **Natural weights count situations course by course, for every process.** Where every move
and configuration is listed once, the finer courses taking a course number its weight. -/
theorem situations_of_course_listed [DecidableEq A] [DecidableEq S] (weight : S → A → S → Nat)
    {moves : List A} {all : List S} (once_moves : ∀ a, occ moves a = 1)
    (once_all : ∀ m, occ all m = 1) (s : S) (c : List (A × S)) :
    counting.sum (finer weight moves all c.length s) (fun h => if coarse h = c then 1 else 0) =
      counting.along weight (fun _ => 1) s c := by
  rw [situations_take, occ_courses_once once_moves once_all c, Nat.one_mul]

end Course

/-! ## Weights that are sums over situations -/

section Sums

universe w

variable {S : Type u} {A : Type v} {R : Type w}

/-- What the situations of a finer course compose to, in any weights. -/
def signs (W : Weights R) (σ : S → A → S → Nat → R) : S → List (A × S × Nat) → R
  | _, [] => W.one
  | s, x :: h => W.mul (σ s x.1 x.2.1 x.2.2) (signs W σ x.2.1 h)

theorem sum_mul_right (W : Weights R) {α : Type u} (c : R) (f : α → R) :
    ∀ l : List α, W.mul (W.sum l f) c = W.sum l fun a => W.mul (f a) c
  | [] => W.zero_mul c
  | _ :: l => (W.right_distrib _ _ _).trans (congrArg (W.add _) (sum_mul_right W c f l))

/-- **Weights that are sums over situations count them.** For every weights and every weighting
of steps in which each step weighs the sum of what its situations contribute, summing a reading
of the courses over the finer courses, each with what its situations compose to, is summing it
over the courses, each with its weight. -/
theorem sum_finer_weights (W : Weights R) (count : S → A → S → Nat) (σ : S → A → S → Nat → R)
    (weight : S → A → S → R) (sums : ∀ s a m, weight s a m = W.sum (Undecided.upto (count s a m)) (σ s a m))
    (moves : List A) (all : List S) : ∀ (n : Nat) (s : S) (g : List (A × S) → R),
      W.sum (finer count moves all n s) (fun h => W.mul (signs W σ s h) (g (coarse h))) =
        W.sum (courses moves all n) (fun c => W.mul (W.along weight (fun _ => W.one) s c) (g c))
  | 0, _, _ => rfl
  | n + 1, s, g =>
    have inner : ∀ x : A × S × Nat,
        W.sum ((finer count moves all n x.2.1).map fun h => x :: h)
            (fun h => W.mul (signs W σ s h) (g (coarse h))) =
          W.mul (σ s x.1 x.2.1 x.2.2) (W.sum (courses moves all n)
            (fun c => W.mul (W.along weight (fun _ => W.one) x.2.1 c) (g ((x.1, x.2.1) :: c)))) :=
      fun x => (Weights.sum_map _ _ _).trans <|
        (Weights.sum_congr _ fun _ _ => W.mul_assoc _ _ _).trans <|
        (Weights.mul_sum _ _ _).symm.trans
          (congrArg (W.mul _) (sum_finer_weights W count σ weight sums moves all n x.2.1
            fun c => g ((x.1, x.2.1) :: c)))
    have each : ∀ p : A × S,
        W.sum ((Undecided.upto (count s p.1 p.2)).map fun k => (p.1, p.2, k))
            (fun x => W.mul (σ s x.1 x.2.1 x.2.2) (W.sum (courses moves all n)
              (fun c => W.mul (W.along weight (fun _ => W.one) x.2.1 c)
                (g ((x.1, x.2.1) :: c))))) =
          W.mul (weight s p.1 p.2) (W.sum (courses moves all n)
            (fun c => W.mul (W.along weight (fun _ => W.one) p.2 c) (g (p :: c)))) :=
      fun p => (Weights.sum_map _ _ _).trans <|
        (sum_mul_right W (W.sum (courses moves all n)
            (fun c => W.mul (W.along weight (fun _ => W.one) p.2 c) (g (p :: c))))
          (σ s p.1 p.2) _).symm.trans
          (congrArg (fun x => W.mul x _) (sums s p.1 p.2).symm)
    have whole : W.sum (courses moves all (n + 1))
          (fun c => W.mul (W.along weight (fun _ => W.one) s c) (g c)) =
        W.sum (openSteps moves all) (fun p => W.mul (weight s p.1 p.2)
          (W.sum (courses moves all n)
            (fun c => W.mul (W.along weight (fun _ => W.one) p.2 c) (g (p :: c))))) :=
      (Weights.sum_joinMap _ _ _).trans (Weights.sum_congr _ fun _ _ =>
        (Weights.sum_map _ _ _).trans <|
          (Weights.sum_congr _ fun _ _ => W.mul_assoc _ _ _).trans (Weights.mul_sum _ _ _).symm)
    (Weights.sum_joinMap _ _ _).trans <|
      (Weights.sum_congr _ fun x _ => inner x).trans <|
      (Weights.sum_joinMap _ _ _).trans <|
      (Weights.sum_congr _ fun p _ => each p).trans whole.symm

end Sums

/-! ## Signed weights count situations of two kinds -/

section Signed

variable {S : Type u} {A : Type v}

/-- The situations of a step of signed weight `(P, N)`: the first `P` add, the next `N`
subtract. -/
def sign (weight : S → A → S → Nat × Nat) (s : S) (a : A) (m : S) (k : Nat) : Nat × Nat :=
  if k < (weight s a m).1 then (1, 0) else (0, 1)

/-- The number of situations of a step of signed weight `(P, N)`: `P + N`. -/
def both (weight : S → A → S → Nat × Nat) (s : S) (a : A) (m : S) : Nat :=
  (weight s a m).1 + (weight s a m).2

theorem sum_adding (P : Nat) : ∀ k, k ≤ P →
    signed.sum (Undecided.upto k) (fun k => if k < P then (1, 0) else (0, 1)) = (k, 0)
  | 0, _ => rfl
  | k + 1, le => by
    show signed.add (if k < P then (1, 0) else (0, 1))
      (signed.sum (Undecided.upto k) (fun k => if k < P then (1, 0) else (0, 1))) = (k + 1, 0)
    rw [if_pos (show k < P from le), sum_adding P k (Nat.le_of_succ_le le)]
    exact pair_eq (Nat.add_comm 1 k) rfl

theorem sum_signed (P : Nat) : ∀ N,
    signed.sum (Undecided.upto (P + N)) (fun k => if k < P then (1, 0) else (0, 1)) = (P, N)
  | 0 => sum_adding P P (Nat.le_refl P)
  | N + 1 => by
    show signed.add (if P + N < P then (1, 0) else (0, 1))
      (signed.sum (Undecided.upto (P + N)) (fun k => if k < P then (1, 0) else (0, 1))) = (P, N + 1)
    rw [if_neg (fun lt => Nat.lt_irrefl P (Nat.lt_of_le_of_lt (Nat.le_add_right P N) lt)),
      sum_signed P N]
    exact pair_eq (Nat.zero_add P) (Nat.add_comm 1 N)

/-- A signed weight is the sum of its situations. -/
theorem signed_sums (weight : S → A → S → Nat × Nat) (s : S) (a : A) (m : S) :
    weight s a m = signed.sum (Undecided.upto (both weight s a m)) (sign weight s a m) :=
  (sum_signed (weight s a m).1 (weight s a m).2).symm

/-- **Signed weights count signed situations.** The signed transfer is the sum, over the finer
courses through the `P + N` situations of each step, of what their situations compose to. -/
theorem signed_situations (weight : S → A → S → Nat × Nat) (moves : List A) (all : List S)
    (n : Nat) (s : S) :
    signed.transfer weight moves all (fun _ => signed.one) n s =
      signed.sum (finer (both weight) moves all n s) (signs signed (sign weight) s) :=
  (Weights.sum_courses weight moves all _ n s).symm.trans <|
    (Weights.sum_congr _ fun _ _ => (signed.mul_one _).symm).trans <|
    (sum_finer_weights signed (both weight) (sign weight) weight (signed_sums weight) moves all n s
      fun _ => signed.one).symm.trans
      (Weights.sum_congr _ fun _ _ => signed.mul_one _)

/-- Every finer course composes to adding or to subtracting. -/
theorem signs_unit (weight : S → A → S → Nat × Nat) : ∀ (s : S) (h : List (A × S × Nat)),
    signs signed (sign weight) s h = (1, 0) ∨ signs signed (sign weight) s h = (0, 1)
  | _, [] => Or.inl rfl
  | s, x :: h =>
    have here : sign weight s x.1 x.2.1 x.2.2 = (1, 0) ∨ sign weight s x.1 x.2.1 x.2.2 = (0, 1) :=
      if lt : x.2.2 < (weight s x.1 x.2.1).1 then Or.inl (if_pos lt) else Or.inr (if_neg lt)
    show signed.mul (sign weight s x.1 x.2.1 x.2.2) (signs signed (sign weight) x.2.1 h) = (1, 0) ∨
      signed.mul (sign weight s x.1 x.2.1 x.2.2) (signs signed (sign weight) x.2.1 h) = (0, 1) from
    match here, signs_unit weight x.2.1 h with
    | .inl a, .inl b => Or.inl (by rw [a, b]; rfl)
    | .inl a, .inr b => Or.inr (by rw [a, b]; rfl)
    | .inr a, .inl b => Or.inr (by rw [a, b]; rfl)
    | .inr a, .inr b => Or.inl (by rw [a, b]; rfl)

/-- A signed sum of contributions each adding or subtracting one is the pair of their counts. -/
theorem sum_units {α : Type u} (f : α → Nat × Nat) : ∀ l : List α,
    (∀ x, x ∈ l → f x = (1, 0) ∨ f x = (0, 1)) →
      signed.sum l f = (counting.sum l (fun x => if f x = (1, 0) then 1 else 0),
        counting.sum l (fun x => if f x = (0, 1) then 1 else 0))
  | [], _ => rfl
  | x :: l, unit => by
    show signed.add (f x) (signed.sum l f) =
      ((if f x = (1, 0) then 1 else 0) + counting.sum l (fun x => if f x = (1, 0) then 1 else 0),
       (if f x = (0, 1) then 1 else 0) + counting.sum l (fun x => if f x = (0, 1) then 1 else 0))
    rw [sum_units f l fun y mem => unit y (.tail _ mem)]
    exact match unit x (.head _) with
      | .inl adds => by
        rw [adds, if_pos rfl, if_neg (by decide : ((1, 0) : Nat × Nat) ≠ (0, 1))]
        rfl
      | .inr subtracts => by
        rw [subtracts, if_pos rfl, if_neg (by decide : ((0, 1) : Nat × Nat) ≠ (1, 0))]
        rfl

/-- **A signed weight is a pair of counts of situations.** The signed transfer counts, among the
finer courses, those whose situations compose to adding and those whose situations compose to
subtracting. -/
theorem signed_counts (weight : S → A → S → Nat × Nat) (moves : List A) (all : List S)
    (n : Nat) (s : S) :
    signed.transfer weight moves all (fun _ => signed.one) n s =
      (counting.sum (finer (both weight) moves all n s)
          (fun h => if signs signed (sign weight) s h = (1, 0) then 1 else 0),
        counting.sum (finer (both weight) moves all n s)
          (fun h => if signs signed (sign weight) s h = (0, 1) then 1 else 0)) :=
  (signed_situations weight moves all n s).trans
    (sum_units _ _ fun h _ => signs_unit weight s h)

/-- **Where signed weights cancel, the situations do not.** The two courses of
`Interference.cancels` balance, and two situations take them. -/
theorem cancels_situations :
    signed.transfer Interference.weight [true, false] [()] (fun _ => signed.one) 1 () = (1, 1) ∧
      (finer (both Interference.weight) [true, false] [()] 1 ()).length = 2 :=
  ⟨rfl, rfl⟩

end Signed

end Situations

end Becoming
