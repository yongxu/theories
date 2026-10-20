import Becoming.Amounts
import Becoming.Resolution
import Becoming.Recurrence
import Becoming.Branching
import Becoming.Likeness

/-!
# Least loss: rest over amounts that may be dense

The spine counts amounts in whole numbers, and its rest laws take their force from them: a
whole number that falls strictly falls by at least one, and no whole number lies beyond its own
count of ones. Every law of the rest family reaches its conclusion through one of two descents
on whole numbers, `falls_not_recurring` (taking from a closed family does not recur,
`Flow.taking_not_recurring_from`, and a continuing family is fed from beyond,
`Flow.fed_from_beyond`) or `falls_stop_unrefuted` (that a world comes to rest cannot be
refuted, `World.rests_unrefuted`, `World.comes_to_rest_unrefuted`,
`World.rests_unrefuted_enclosed`). This module states that descent over amounts that may be
dense, with what the whole numbers supplied named as two premises.

* **Amounts and the least-loss law** are stated in `Becoming.Amounts`, below the rest family,
  which proves its laws as their whole-number instance (`falls_not_recurring` from
  `Amounts.rests`, `falls_stop_unrefuted` from `Amounts.rests_unrefuted`,
  `Flow.taking_not_recurring_from` from `Amounts.family_rests_of_archimedean`,
  `Flow.takers_within_on` from `Amounts.losses_within`, `Flow.change_stops_unrefuted` from
  `Amounts.rests_unrefuted`, and through them `World.rests_unrefuted_enclosed`). This module states
  that each of the two premises is needed, and what rest has to do with return.
* **Each premise is needed.**
  - *Without a least loss.* In dyadic amounts (`Dyadic`, `num / 2 ^ exp`), which are dense
    (`Dyadic.half_below`) and Archimedean (`Dyadic.archimedean`), the stock halves at every step,
    `1 / 2 ^ t`, each step losing `1 / 2 ^ (t + 1)`: every loss is above nothing, no amount above
    nothing is within every loss, and the stock falls at every step, so it never rests
    (`Halving.never_rests`). The losses add to within the stock, as the loss law requires.
  - *Without the bound by least losses.* In layered amounts (`Layered`: a dyadic coarse layer and
    a whole-number fine layer counting only where the coarse layers agree), the stock falls by a
    least loss of one fine unit at every step, and lies beyond every multiple of it, so it never
    rests (`Layered.never_rests`). Layered amounts are not Archimedean (`Layered.not_archimedean`),
    so the approach to rest fails there too.
  - *Approach without rest.* The halving stock comes arbitrarily near rest, as the approach law
    says, and still falls at every step (`Halving.approaches_without_reaching`): with no least
    loss, approach does not become rest, as in exponential relaxation.
  - *Takers without bound, replenishment bounded.* With halving takes, `2 ^ (t + 1)` takers each
    take `1 / 2 ^ (t + 1)` at the step from `t`, one whole in all: the takers are more without
    end, every take is above nothing, and one whole given at each step balances them
    (`Halving.takes_halve`). More without end needs replenishment without bound only with a least
    take (`Amounts.replenishment_unbounded`).
* **Rest and return.** Over finitely many configurations, a law that merges nothing returns every
  configuration (`Law.Lossless.returns`, `Becoming.Recurrence`), so an amount that does not rise
  along an orbit regains its value (`Law.Lossless.regains`) and every loss along it is nothing
  (`Law.Lossless.loses_nothing`). A loss above nothing needs a law that merges
  (`Law.loss_needs_merge`). The same holds along a run of every process
  (`Branching.Lossless.loses_nothing`, `Branching.loss_needs_merge`). Rest is a law of descriptions that lump configurations and dissipate;
  a finite world that merges nothing returns rather than rests.
* **Rest from a finite reading.** Where a list holds the configurations an amount is read off,
  steps across which it falls strictly do not recur, and of any `l.length + 1` steps not every one
  falls (`Amounts.rests_of_finite_reading`, `Amounts.falls_within_reading`), over any amounts: no
  least loss, no Archimedean property, no totality and no decision; with the amount's not rising
  and the falls only not refuted, that the falls stop cannot be refuted
  (`Amounts.rests_unrefuted_of_finite_reading`). A strict fall leaves a
  configuration the amount never reads again (pigeonhole, `revisits_within`). So falls that recur
  need a reading no list holds, as the halving stock's values (`Halving.stock_unlisted`). Along a
  run of every process held by a list (`Branching.rests_along_run`), a run's falls come to rest,
  and where the process merges nothing it loses nothing at all.
* **A part's merge, kept by the rest.** Read a whole's configurations by a part and a rest that
  together tell them apart. Under a law that merges nothing, possibilities no two alike stay so
  (`Law.Lossless.keeps_apart`), so `k` of them, their parts held by `ps` and their rests by `es`,
  number at most `ps.length * es.length` (`Law.distinct_within`, `Law.Lossless.narrowing_spreads`): a
  part narrowed is matched by the rest's spread, Landauer's count with no energy. A part reset to one
  configuration at every step, inside a whole that merges nothing, needs a whole no list holds
  (`Law.Lossless.reset_unlisted`); in `Reset` the part merges at every step, the whole merges
  nothing, and the rest is the part's kept history, which no list holds (`Reset.kept_by_rest`).

What the whole numbers carry in the rest family is exactly these two premises: a least loss at
each change, and every stock within finitely many least losses. Approach to rest needs no least
loss, only Archimedean amounts; rest, the change counted not recurring, needs the least loss as
well, unless the amount is read off finitely many configurations, where it needs none. Physics supplies amounts of energy in real numbers, and the second law, a non-negative production of entropy, names no least
loss per step; so in a continuous reading the rest laws hold where some least loss per change is
given (a least gap between the levels of a bounded quantised system, a threshold of detection,
Landauer's bound `kT ln 2` per erased bit at a temperature bounded below are candidates), and
fail, as in `Halving`, where losses shrink without a floor. Which physical systems have a least
loss is not settled here; finite distinguishability (finitely many states read at a resolution) is the
premise that makes it unnecessary. `Flow`, `Web` and `World` read their levels in whole numbers;
`Becoming.InAmounts` reads a world's standings and exchanges in any amounts and states the rest
theorem there from a finite reading (`World.InAmounts.rests_unrefuted_enclosed`). `Becoming.Resolution` reads the same boundary at a unit that may split, and its
`Asymptote` and `Dwindle` are halving at a refining unit. Real numbers are not constructed in the
core; dyadic amounts witness that density alone does not break the law. No ethical predicate,
ranking or axiom occurs.
-/

namespace Becoming

/-! ## Dyadic amounts: dense, Archimedean, and without a least loss -/

/-- A dyadic amount, `num / 2 ^ exp`. -/
structure Dyadic where
  num : Nat
  exp : Nat

namespace Dyadic

theorem ext' : ∀ {a b : Dyadic}, a.num = b.num → a.exp = b.exp → a = b
  | ⟨_, _⟩, ⟨_, _⟩, rfl, rfl => rfl

/-- Dyadic amounts added. -/
def add (a b : Dyadic) : Dyadic := ⟨a.num * 2 ^ b.exp + b.num * 2 ^ a.exp, a.exp + b.exp⟩

/-- One dyadic amount within another. -/
def le (a b : Dyadic) : Prop := a.num * 2 ^ b.exp ≤ b.num * 2 ^ a.exp

/-- Nothing. -/
def zero : Dyadic := ⟨0, 0⟩

theorem le_trans' {a b c : Dyadic} (ab : le a b) (bc : le b c) : le a c :=
  Nat.le_of_mul_le_mul_right
    (calc a.num * 2 ^ c.exp * 2 ^ b.exp
        = a.num * 2 ^ b.exp * 2 ^ c.exp := Naturals.mul_right_comm _ _ _
      _ ≤ b.num * 2 ^ a.exp * 2 ^ c.exp := Nat.mul_le_mul_right _ ab
      _ = b.num * 2 ^ c.exp * 2 ^ a.exp := Naturals.mul_right_comm _ _ _
      _ ≤ c.num * 2 ^ b.exp * 2 ^ a.exp := Nat.mul_le_mul_right _ bc
      _ = c.num * 2 ^ a.exp * 2 ^ b.exp := Naturals.mul_right_comm _ _ _)
    (Nat.two_pow_pos _)

theorem add_assoc' (a b c : Dyadic) : add (add a b) c = add a (add b c) :=
  ext' (by
    show (a.num * 2 ^ b.exp + b.num * 2 ^ a.exp) * 2 ^ c.exp + c.num * 2 ^ (a.exp + b.exp)
      = a.num * 2 ^ (b.exp + c.exp) + (b.num * 2 ^ c.exp + c.num * 2 ^ b.exp) * 2 ^ a.exp
    rw [add_mul_split, add_mul_split, Naturals.pow_add 2 a.exp b.exp, Naturals.pow_add 2 b.exp c.exp,
      mul_assoc_nat a.num, Naturals.mul_right_comm b.num (2 ^ a.exp) (2 ^ c.exp),
      mul_assoc_nat c.num (2 ^ b.exp) (2 ^ a.exp), Nat.mul_comm (2 ^ b.exp) (2 ^ a.exp),
      Nat.add_assoc])
    (Nat.add_assoc _ _ _)

theorem add_comm' (a b : Dyadic) : add a b = add b a :=
  ext' (Nat.add_comm _ _) (Nat.add_comm _ _)

theorem zero_add' (a : Dyadic) : add zero a = a :=
  ext' ((congrArg (· + a.num * 1) (Nat.zero_mul _)).trans ((Nat.zero_add _).trans (Nat.mul_one _)))
    (Nat.zero_add _)

theorem expand (x y e f g : Nat) :
    (x * 2 ^ g + y * 2 ^ e) * 2 ^ (f + g) = x * 2 ^ f * (2 ^ g * 2 ^ g) + y * (2 ^ e * 2 ^ f * 2 ^ g) := by
  rw [add_mul_split, Naturals.pow_add, mul_assoc_nat x, mul_turn (2 ^ g) (2 ^ f), ← mul_assoc_nat x,
    mul_assoc_nat y, ← mul_assoc_nat (2 ^ e)]

theorem add_le_add_right' {a b : Dyadic} (c : Dyadic) (h : le a b) : le (add a c) (add b c) := by
  show (a.num * 2 ^ c.exp + c.num * 2 ^ a.exp) * 2 ^ (b.exp + c.exp)
    ≤ (b.num * 2 ^ c.exp + c.num * 2 ^ b.exp) * 2 ^ (a.exp + c.exp)
  rw [expand, expand, Nat.mul_comm (2 ^ b.exp) (2 ^ a.exp)]
  exact Nat.add_le_add_right (Nat.mul_le_mul_right _ h) _

theorem le_of_add_le_add_right' {a b : Dyadic} (c : Dyadic) (h : le (add a c) (add b c)) :
    le a b := by
  have h' : (a.num * 2 ^ c.exp + c.num * 2 ^ a.exp) * 2 ^ (b.exp + c.exp)
      ≤ (b.num * 2 ^ c.exp + c.num * 2 ^ b.exp) * 2 ^ (a.exp + c.exp) := h
  rw [expand, expand, Nat.mul_comm (2 ^ b.exp) (2 ^ a.exp)] at h'
  exact Nat.le_of_mul_le_mul_right (le_of_add_le_add_right _ h')
    (Nat.mul_pos (Nat.two_pow_pos _) (Nat.two_pow_pos _))

theorem zero_le' (a : Dyadic) : le zero a :=
  Nat.le_trans (Nat.le_of_eq (Nat.zero_mul _)) (Nat.zero_le _)

/-- Dyadic amounts with their laws. -/
def amounts : Amounts Dyadic where
  zero := zero
  add := add
  le := le
  le_refl := fun _ => Nat.le_refl _
  le_trans := le_trans'
  add_assoc := add_assoc'
  add_comm := add_comm'
  zero_add := zero_add'
  add_le_add_right := add_le_add_right'
  le_of_add_le_add_right := le_of_add_le_add_right'
  zero_le := zero_le'

/-- An amount above nothing has a positive numerator. -/
theorem num_pos {a : Dyadic} (positive : ¬ le a zero) : 0 < a.num :=
  Nat.pos_of_ne_zero fun none_ => positive (Nat.le_of_eq
    ((congrArg (· * 2 ^ 0) none_).trans ((Nat.zero_mul _).trans (Nat.zero_mul _).symm)))

/-- Dense: below every amount above nothing lies another above nothing, its half. -/
theorem half_below {a : Dyadic} (positive : ¬ le a zero) :
    ¬ le ⟨a.num, a.exp + 1⟩ zero ∧ ¬ le a ⟨a.num, a.exp + 1⟩ :=
  ⟨fun le => Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le (num_pos positive)
      (Nat.le_trans (Nat.le_of_eq (Nat.mul_one _).symm) (Nat.le_trans le (Nat.le_of_eq (Nat.zero_mul _))))),
   fun le => Nat.lt_irrefl _ (Nat.lt_of_lt_of_le (Nat.pow_lt_pow_succ (Nat.lt_succ_self 1))
      (Nat.le_of_mul_le_mul_left le (num_pos positive)))⟩

/-- Copies of an amount are at least the amount with its numerator multiplied. -/
theorem times_ge (n k : Nat) : ∀ m, le ⟨m * n, k⟩ (amounts.times m ⟨n, k⟩)
  | 0 => Nat.le_of_eq ((congrArg (· * 2 ^ 0) (Nat.zero_mul n)).trans
      ((Nat.zero_mul _).trans (Nat.zero_mul _).symm))
  | m + 1 => le_trans' (b := add ⟨m * n, k⟩ ⟨n, k⟩)
      (show (m + 1) * n * 2 ^ (k + k) ≤ (m * n * 2 ^ k + n * 2 ^ k) * 2 ^ k from by
        rw [← add_mul_split, Nat.succ_mul, Naturals.pow_add, mul_assoc_nat]
        exact Nat.le_refl _)
      (add_le_add_right' ⟨n, k⟩ (times_ge n k m))

/-- Dyadic amounts are Archimedean. -/
theorem archimedean : amounts.Archimedean :=
  fun a e positive => ⟨a.num * 2 ^ e.exp + 1, fun le =>
    have lower := le_trans' (times_ge e.num e.exp (a.num * 2 ^ e.exp + 1)) le
    Nat.lt_irrefl _ (Nat.lt_of_lt_of_le (Nat.lt_succ_self (a.num * 2 ^ e.exp))
      (Nat.le_trans (Nat.le_mul_of_pos_right _ (num_pos positive))
        (Nat.le_trans (Nat.le_mul_of_pos_right _ (Nat.two_pow_pos a.exp)) lower)))⟩

end Dyadic

/-! ## Halving: a loss at every step and no rest -/

namespace Halving

/-- The stock halves at every step: `1 / 2 ^ t`. -/
def stock (t : Nat) : Dyadic := ⟨1, t⟩

/-- The loss of the step from `t`, half the stock: `1 / 2 ^ (t + 1)`. -/
def loss (t : Nat) : Dyadic := ⟨1, t + 1⟩

theorem falls (t : Nat) : Dyadic.amounts.le (Dyadic.amounts.add (stock (t + 1)) (loss t)) (stock t) := by
  show (1 * 2 ^ (t + 1) + 1 * 2 ^ (t + 1)) * 2 ^ t ≤ 1 * 2 ^ ((t + 1) + (t + 1))
  rw [Nat.one_mul, Nat.one_mul, ← Nat.mul_two, Naturals.pow_add 2 (t + 1) (t + 1),
    mul_assoc_nat, Nat.mul_comm 2 (2 ^ t)]
  exact Nat.le_refl _

theorem loss_positive (t : Nat) : ¬ Dyadic.amounts.le (loss t) Dyadic.amounts.zero :=
  fun le => Nat.not_succ_le_zero 0 (Nat.le_trans le (Nat.le_of_eq (Nat.zero_mul _)))

/-- No amount above nothing is within every loss. -/
theorem no_least_loss (ε : Dyadic) (positive : ¬ Dyadic.amounts.le ε Dyadic.amounts.zero) :
    ¬ ∀ t, Dyadic.amounts.le ε (loss t) :=
  fun least => Nat.lt_irrefl _ (Nat.lt_of_lt_of_le (Nat.pow_lt_pow_succ (Nat.lt_succ_self 1))
    (Nat.le_trans (Nat.le_mul_of_pos_left _ (Dyadic.num_pos positive))
      (Nat.le_trans (least ε.exp) (Nat.le_of_eq (Nat.one_mul _)))))

theorem falls_strictly (t : Nat) : ¬ Dyadic.amounts.le (stock t) (stock (t + 1)) :=
  fun le => Nat.lt_irrefl _ (Nat.lt_of_lt_of_le (Nat.pow_lt_pow_succ (Nat.lt_succ_self 1))
    (Nat.le_trans (Nat.le_of_eq (Nat.one_mul _).symm) (Nat.le_trans le (Nat.le_of_eq (Nat.one_mul _)))))

/-- **The geometric counterexample.** In dyadic amounts, dense and Archimedean, the stock halves
at every step: across each step it falls by its loss, every loss is above nothing, no amount above
nothing is within every loss, and the stock falls at every step, so it never rests. Every premise
of `Amounts.rests` holds for the steps at which the stock falls except the least loss. -/
theorem never_rests :
    (∀ t, Dyadic.amounts.le (Dyadic.amounts.add (stock (t + 1)) (loss t)) (stock t)) ∧
    (∀ t, Dyadic.amounts.le (stock (t + 1)) (stock t)) ∧
    (∀ t, ¬ Dyadic.amounts.le (loss t) Dyadic.amounts.zero) ∧
    (∀ ε, ¬ Dyadic.amounts.le ε Dyadic.amounts.zero → ¬ ∀ t, Dyadic.amounts.le ε (loss t)) ∧
    Dyadic.amounts.Archimedean ∧
    ∀ N, ∃ t, N ≤ t ∧ ¬ Dyadic.amounts.le (stock t) (stock (t + 1)) :=
  ⟨falls, fun t => Dyadic.amounts.le_trans (Amounts.le_add_right _ _) (falls t), loss_positive,
   no_least_loss, Dyadic.archimedean, fun N => ⟨N, Nat.le_refl N, falls_strictly N⟩⟩

/-- **Approaching rest without reaching it.** The halving stock comes arbitrarily near rest, as
every stock with summable losses in Archimedean amounts does: for every `ε` above nothing there is
a count `m` such that no `m` steps each lose at least `ε`, and steps losing at least `ε` do not
recur. Yet it falls at every step. With no least loss, approach does not become rest, as in
exponential relaxation. -/
theorem approaches_without_reaching :
    (∀ ε, ¬ Dyadic.amounts.le ε Dyadic.amounts.zero →
      (∃ m, ¬ ∃ f : Nat → Nat, 0 ≤ f 0 ∧ (∀ i, f i < f (i + 1)) ∧
        ∀ i, i < m → Dyadic.amounts.le ε (loss (f i))) ∧
      ¬ ∀ N, ∃ t, N ≤ t ∧ Dyadic.amounts.le ε (loss t)) ∧
    ∀ t, ¬ Dyadic.amounts.le (stock t) (stock (t + 1)) :=
  ⟨fun _ positive =>
    ⟨Amounts.few_large_losses_of_archimedean Dyadic.archimedean (fun t _ => falls t) positive,
     Amounts.approaches_rest (T := 0) Dyadic.archimedean (fun t _ => falls t) positive⟩,
   falls_strictly⟩

/-- Copies of an amount are at most the amount with its numerator multiplied. -/
theorem times_le_num (n k : Nat) : ∀ m, Dyadic.le (Dyadic.amounts.times m ⟨n, k⟩) ⟨m * n, k⟩
  | 0 => Dyadic.zero_le' _
  | m + 1 => Dyadic.le_trans' (Dyadic.add_le_add_right' ⟨n, k⟩ (times_le_num n k m))
      (show (m * n * 2 ^ k + n * 2 ^ k) * 2 ^ k ≤ (m + 1) * n * 2 ^ (k + k) from by
        rw [← add_mul_split, Nat.succ_mul, Naturals.pow_add, mul_assoc_nat]
        exact Nat.le_refl _)

theorem le_two_pow : ∀ K, K ≤ 2 ^ K
  | 0 => Nat.zero_le _
  | K + 1 => Nat.le_trans (Nat.add_le_add (le_two_pow K) (Nat.two_pow_pos K))
      (Nat.le_of_eq ((Nat.mul_two _).symm.trans (Nat.pow_succ 2 K).symm))

/-- One whole. -/
def one : Dyadic := ⟨1, 0⟩

/-- At the step from `t`, `2 ^ (t + 1)` takers take `loss t` each, `1 / 2 ^ (t + 1)`: one whole
in all. -/
theorem takes_within_one (t : Nat) :
    Dyadic.amounts.le (Dyadic.amounts.times (2 ^ (t + 1)) (loss t)) one :=
  Dyadic.le_trans' (times_le_num 1 (t + 1) (2 ^ (t + 1)))
    (Nat.le_of_eq ((Nat.mul_one _).trans ((Nat.mul_one _).trans (Nat.one_mul _).symm)))

/-- **The counterexample to replenishment without bound, with no least take.** In dyadic amounts,
dense and Archimedean, a family keeps a stock of one whole and is given one whole at every step;
at the step from `t`, `2 ^ (t + 1)` takers take `1 / 2 ^ (t + 1)` each. The family is balanced
(its stock after a step with the uptake is within its stock before with the replenishment), each
take is above nothing, the takers are more without end (for every number, from some step on at
least that many take), and the replenishment is one whole at every step; what fails is
the least take: no amount above nothing is within every take. So the whole-number law
`Flow.More.replenishment_unbounded` needs that each taker takes at least a least amount, as
`Amounts.replenishment_unbounded` states. -/
theorem takes_halve :
    (∀ t, Dyadic.amounts.le
      (Dyadic.amounts.add one (Dyadic.amounts.times (2 ^ (t + 1)) (loss t)))
      (Dyadic.amounts.add one one)) ∧
    (∀ t, ¬ Dyadic.amounts.le (loss t) Dyadic.amounts.zero) ∧
    (∀ K, ∃ T, ∀ t, T ≤ t → K ≤ 2 ^ (t + 1)) ∧
    ∀ ε, ¬ Dyadic.amounts.le ε Dyadic.amounts.zero → ¬ ∀ t, Dyadic.amounts.le ε (loss t) :=
  ⟨fun t => Amounts.add_le_add_left one (takes_within_one t), loss_positive,
   fun K => ⟨K, fun _ later => Nat.le_trans (le_two_pow K)
     (Nat.pow_le_pow_right (Nat.succ_pos 1) (Nat.le_succ_of_le later))⟩,
   no_least_loss⟩

end Halving

/-! ## Layered amounts: a least loss, and a stock beyond every multiple of it -/

/-- A layered amount: a coarse dyadic amount and a fine whole-number one, the fine layer counting
only where the coarse layers are each within the other. -/
structure Layered where
  coarse : Dyadic
  fine : Nat

namespace Layered

theorem ext' : ∀ {a b : Layered}, a.coarse = b.coarse → a.fine = b.fine → a = b
  | ⟨_, _⟩, ⟨_, _⟩, rfl, rfl => rfl

/-- Layered amounts added, layer by layer. -/
def add (a b : Layered) : Layered := ⟨Dyadic.add a.coarse b.coarse, a.fine + b.fine⟩

/-- One layered amount within another: the coarse layer within, and where the coarse layers are
each within the other, the fine layer within. -/
def le (a b : Layered) : Prop :=
  Dyadic.le a.coarse b.coarse ∧ (Dyadic.le b.coarse a.coarse → a.fine ≤ b.fine)

/-- Nothing. -/
def zero : Layered := ⟨Dyadic.zero, 0⟩

theorem le_trans' {a b c : Layered} (ab : le a b) (bc : le b c) : le a c :=
  ⟨Dyadic.le_trans' ab.1 bc.1, fun ca =>
    Nat.le_trans (ab.2 (Dyadic.le_trans' bc.1 ca)) (bc.2 (Dyadic.le_trans' ca ab.1))⟩

theorem add_le_add_right' {a b : Layered} (c : Layered) (h : le a b) : le (add a c) (add b c) :=
  ⟨Dyadic.add_le_add_right' c.coarse h.1, fun ba =>
    Nat.add_le_add_right (h.2 (Dyadic.le_of_add_le_add_right' c.coarse ba)) _⟩

theorem le_of_add_le_add_right' {a b : Layered} (c : Layered) (h : le (add a c) (add b c)) :
    le a b :=
  ⟨Dyadic.le_of_add_le_add_right' c.coarse h.1, fun ba =>
    _root_.Becoming.le_of_add_le_add_right _ (h.2 (Dyadic.add_le_add_right' c.coarse ba))⟩

/-- Layered amounts with their laws. They are not Archimedean: a fine amount above nothing,
taken any number of times, stays within every coarse amount above nothing. -/
def amounts : Amounts Layered where
  zero := zero
  add := add
  le := le
  le_refl := fun _ => ⟨Nat.le_refl _, fun _ => Nat.le_refl _⟩
  le_trans := le_trans'
  add_assoc := fun _ _ _ => ext' (Dyadic.add_assoc' _ _ _) (Nat.add_assoc _ _ _)
  add_comm := fun _ _ => ext' (Dyadic.add_comm' _ _) (Nat.add_comm _ _)
  zero_add := fun _ => ext' (Dyadic.zero_add' _) (Nat.zero_add _)
  add_le_add_right := add_le_add_right'
  le_of_add_le_add_right := le_of_add_le_add_right'
  zero_le := fun _ => ⟨Dyadic.zero_le' _, fun _ => Nat.zero_le _⟩

/-- The stock: the coarse layer halving at every step, nothing in the fine layer. -/
def stock (t : Nat) : Layered := ⟨Halving.stock t, 0⟩

/-- The least loss: one fine unit, nothing coarse. -/
def least : Layered := ⟨Dyadic.zero, 1⟩

theorem least_positive : ¬ amounts.le least amounts.zero :=
  fun le => Nat.not_succ_le_zero 0 (le.2 (Nat.le_refl _))

/-- Across every step the stock falls by at least the least loss. -/
theorem loses (t : Nat) : amounts.le (amounts.add (stock (t + 1)) least) (stock t) :=
  ⟨Eq.subst (motive := fun x => Dyadic.le x (Halving.stock t))
      (Amounts.add_zero (M := Dyadic.amounts) (Halving.stock (t + 1))).symm
      (Halving.never_rests.2.1 t),
   fun back => absurd (Eq.subst (motive := fun x => Dyadic.le (Halving.stock t) x)
      (Amounts.add_zero (M := Dyadic.amounts) (Halving.stock (t + 1))) back)
      (Halving.falls_strictly t)⟩

/-- Copies of the least loss stay coarse nothing. -/
theorem times_coarse : ∀ m, Dyadic.le (amounts.times m least).coarse Dyadic.zero
  | 0 => Nat.le_refl _
  | m + 1 => Eq.subst (motive := fun x => Dyadic.le x Dyadic.zero)
      (Amounts.add_zero (M := Dyadic.amounts) (amounts.times m least).coarse).symm
      (times_coarse m)

/-- The stock at the start lies beyond every multiple of the least loss. -/
theorem beyond_every_multiple (m : Nat) : amounts.le (amounts.times m least) (stock 0) :=
  ⟨Dyadic.le_trans' (times_coarse m) (Dyadic.zero_le' _), fun above =>
    False.elim (Nat.not_succ_le_zero 0 (Nat.le_trans (Dyadic.le_trans' above (times_coarse m))
      (Nat.le_of_eq (Nat.zero_mul _))))⟩

/-- **The counterexample to rest without the stock's bound.** In layered amounts the stock falls
by at least a least loss above nothing across every step and never rests: it changes at every
step. What fails is the second premise of `Amounts.rests`: the stock at the start lies beyond every
multiple of the least loss. -/
theorem never_rests :
    (∀ t, amounts.le (stock (t + 1)) (stock t)) ∧
    (∀ t, amounts.le (amounts.add (stock (t + 1)) least) (stock t)) ∧
    ¬ amounts.le least amounts.zero ∧
    (∀ m, amounts.le (amounts.times m least) (stock 0)) ∧
    ∀ N, ∃ t, N ≤ t ∧ ¬ amounts.le (stock t) (stock (t + 1)) :=
  ⟨fun t => amounts.le_trans (Amounts.le_add_right _ _) (loses t), loses, least_positive,
   beyond_every_multiple, fun N => ⟨N, Nat.le_refl N, fun le => Halving.falls_strictly N le.1⟩⟩

/-- Layered amounts are not Archimedean: every multiple of the least loss, above nothing, is within
the stock at the start. So the approach to rest needs the Archimedean property: here a bounded
stock loses at least the least loss at every step. -/
theorem not_archimedean : ¬ amounts.Archimedean :=
  fun archimedean => match archimedean (stock 0) least least_positive with
    | ⟨m, within⟩ => within (beyond_every_multiple m)

end Layered

/-! ## Rest from a finite reading: no least loss -/

namespace Amounts

variable {A : Type} {M : Amounts A} {S : Type}

/-- Steps rising one after another, `f i < f (i + 1)` below `K`, lie at least as far apart as
their indices. -/
theorem rising_apart {f : Nat → Nat} {K : Nat} (rising : ∀ i, i < K → f i < f (i + 1)) (i : Nat) :
    ∀ d, i + d ≤ K → f i + d ≤ f (i + d)
  | 0, _ => Nat.le_refl _
  | d + 1, within => Nat.le_trans (Nat.succ_le_succ (rising_apart rising i d
      (Nat.le_of_succ_le within))) (rising (i + d) within)

/-- Steps rising one after another below `K`, the first from `T` on, are each from `T` on. -/
theorem from_start {f : Nat → Nat} {K T : Nat} (start : T ≤ f 0)
    (rising : ∀ i, i < K → f i < f (i + 1)) {n : Nat} (within : n ≤ K) : T ≤ f n :=
  Nat.le_trans start (Nat.le_trans (Nat.le_add_right (f 0) n)
    (Nat.le_trans (rising_apart rising 0 n (Nat.le_trans (Nat.le_of_eq (Nat.zero_add n)) within))
      (Nat.le_of_eq (congrArg f (Nat.zero_add n)))))

/-- **A finite reading counts the falls.** Read an amount `q` off configurations `g t` that a
list `l` holds from `T` on, and let it not rise across any step from `T` on, as far as can be
refuted. Then of any `l.length + 1` steps `f 0 < f 1 < ⋯` from `T` on, not every one is a step
across which the amount falls strictly (is not, after the step, back within its value before): at
most `l.length` steps fall strictly. No least loss is asked, no Archimedean property, no totality
and no decision: a strict fall leaves a configuration the amount never reads again, and the list
has room for only so many. -/
theorem falls_within_reading {g : Nat → S} {q : S → A} {l : List S} {T : Nat}
    (held : ∀ t, T ≤ t → g t ∈ l) (still : ∀ t, T ≤ t → ¬¬ M.le (q (g (t + 1))) (q (g t)))
    {f : Nat → Nat} (start : T ≤ f 0) (rising : ∀ i, i < l.length → f i < f (i + 1)) :
    ¬ ∀ i, i ≤ l.length → ¬ M.le (q (g (f i))) (q (g (f i + 1))) := fun falls =>
  match revisits_within l (fun i => g (f i))
      (fun n within => held (f n) (from_start start rising within)) with
  | ⟨i, j, lt, le, same⟩ =>
    match gap_of_lt lt with
    | ⟨d, at_j⟩ =>
      have from_i : T ≤ f i := from_start start rising (Nat.le_trans (Nat.le_of_lt lt) le)
      have apart : f i + 1 ≤ f j :=
        Nat.le_trans (Nat.succ_le_succ (Nat.le_add_right (f i) d))
          (Nat.le_trans (rising_apart rising i (d + 1) (Nat.le_trans (Nat.le_of_eq at_j.symm) le))
            (Nat.le_of_eq (congrArg f at_j.symm)))
      match le_dest apart with
      | ⟨e, at_fj⟩ =>
        still_le (s := fun t => q (g t)) still e (f i + 1) (Nat.le_succ_of_le from_i) fun down =>
          falls i (Nat.le_trans (Nat.le_of_lt lt) le)
            (Eq.subst (motive := fun x => M.le (q x) (q (g (f i + 1)))) same.symm
              (Eq.subst (motive := fun x => M.le (q (g x)) (q (g (f i + 1)))) at_fj.symm down))

/-- A chain of `m + 1` strict falls from `T` on, at rising steps, extended by one more strict fall
after its last. -/
theorem extend_falls {g : Nat → S} {q : S → A} {T m : Nat} {f : Nat → Nat} (start : T ≤ f 0)
    (rising : ∀ i, i < m → f i < f (i + 1))
    (falls : ∀ i, i ≤ m → ¬ M.le (q (g (f i))) (q (g (f i + 1)))) {t : Nat} (after : f m + 1 ≤ t)
    (fall : ¬ M.le (q (g t)) (q (g (t + 1)))) :
    ∃ f' : Nat → Nat, T ≤ f' 0 ∧ (∀ i, i < m + 1 → f' i < f' (i + 1)) ∧
      ∀ i, i ≤ m + 1 → ¬ M.le (q (g (f' i))) (q (g (f' i + 1))) := by
  refine ⟨fun i => if i ≤ m then f i else t, ?_, ?_, ?_⟩
  · exact Eq.subst (motive := fun x => T ≤ x) (if_pos (Nat.zero_le m)).symm start
  · intro i below
    have at_i : (if i ≤ m then f i else t) = f i := if_pos (Nat.le_of_lt_succ below)
    show (if i ≤ m then f i else t) < (if i + 1 ≤ m then f (i + 1) else t)
    rw [at_i]
    match Nat.decLe (i + 1) m with
    | isTrue next =>
      rw [if_pos next]
      exact rising i next
    | isFalse past =>
      rw [if_neg past]
      have same : i = m := Nat.le_antisymm (Nat.le_of_lt_succ below)
        (Nat.le_of_lt_succ (Nat.gt_of_not_le past))
      rw [same]
      exact after
  · intro i _
    match Nat.decLe i m with
    | isTrue earlier =>
      show ¬ M.le (q (g (if i ≤ m then f i else t))) (q (g ((if i ≤ m then f i else t) + 1)))
      rw [if_pos earlier]
      exact falls i earlier
    | isFalse later =>
      show ¬ M.le (q (g (if i ≤ m then f i else t))) (q (g ((if i ≤ m then f i else t) + 1)))
      rw [if_neg later]
      exact fall

/-- **Rest from a finite reading, unrefuted.** Where a list holds, from `T` on, the configurations
an amount is read off, and that the amount does not rise across any step from `T` on is not
refuted, it is not the case that after every step from `T` on a later step across which it falls
strictly stays unrefuted. Over any amounts: no least loss, no Archimedean property, no totality of
the order and no decision is asked. Each chain of strict falls is extended inside the refutation,
so only the `l.length + 1` falls the list cannot hold are ever used. -/
theorem rests_unrefuted_of_finite_reading {g : Nat → S} {q : S → A} {l : List S} {T : Nat}
    (held : ∀ t, T ≤ t → g t ∈ l) (still : ∀ t, T ≤ t → ¬¬ M.le (q (g (t + 1))) (q (g t))) :
    ¬ ∀ N, T ≤ N → ¬¬ ∃ t, N ≤ t ∧ ¬ M.le (q (g t)) (q (g (t + 1))) := fun recurs =>
  have chain : ∀ m, ¬¬ ∃ f : Nat → Nat, T ≤ f 0 ∧ (∀ i, i < m → f i < f (i + 1)) ∧
      ∀ i, i ≤ m → ¬ M.le (q (g (f i))) (q (g (f i + 1))) := fun m => by
    induction m with
    | zero =>
      exact fun no => recurs T (Nat.le_refl T) fun ⟨t, after, fall⟩ =>
        no ⟨fun _ => t, after, fun i below => absurd below (Nat.not_lt_zero i), fun _ _ => fall⟩
    | succ m ih =>
      exact fun no => ih fun ⟨f, start, rising, falls⟩ =>
        recurs (f m + 1) (Nat.le_succ_of_le (from_start start rising (Nat.le_refl m)))
          fun ⟨t, after, fall⟩ => no (extend_falls start rising falls after fall)
  chain l.length fun ⟨f, start, rising, falls⟩ => falls_within_reading held still start rising falls

/-- **Rest from a finite reading.** Where a list holds, from `T` on, the configurations an amount
is read off and the amount does not rise across any step from `T` on, steps across which it falls
strictly do not recur. Over any amounts: no least loss, no Archimedean property, no totality of the
order and no decision is asked (`rests_unrefuted_of_finite_reading` is the stronger form). The least
loss on which `Amounts.rests` turns is needed only where the amount reads configurations no list
holds: falls that recur need an unbounded reading (`Halving.stock_unlisted`). -/
theorem rests_of_finite_reading {g : Nat → S} {q : S → A} {l : List S} {T : Nat}
    (held : ∀ t, T ≤ t → g t ∈ l) (still : ∀ t, T ≤ t → M.le (q (g (t + 1))) (q (g t))) :
    ¬ ∀ N, ∃ t, N ≤ t ∧ ¬ M.le (q (g t)) (q (g (t + 1))) := fun recurs =>
  rests_unrefuted_of_finite_reading held (fun t later no => no (still t later))
    fun N _ no => no (recurs N)

end Amounts

namespace Halving

/-- **Falls that recur need an unbounded reading.** The halving stock falls strictly at every
step, so no list holds its values: by `Amounts.rests_of_finite_reading`, a list holding them would
bring its falls to rest. Halving's lack of a least loss and the unbounded count of its values are
one fact read twice. -/
theorem stock_unlisted : ¬ ∃ l : List Dyadic, ∀ t, stock t ∈ l := fun ⟨_, held⟩ =>
  Amounts.rests_of_finite_reading (M := Dyadic.amounts) (q := fun x => x) (T := 0)
    (fun t _ => held t) (fun t _ => never_rests.2.1 t) (fun N => ⟨N, Nat.le_refl N, falls_strictly N⟩)

end Halving

/-! ## Rest and return: dissipation needs a law that merges -/

namespace Branching

open Generative

variable {S : Type} {Act : Type} {P : Process S Act} {A : Type} {M : Amounts A}

/-- **Merging nothing, a run loses nothing**, for every process. Where `P` merges nothing and a
list holds every configuration of a run, an amount that, with each step's loss, is within its
value before the step along the run loses nothing at any step: the run comes back to each of its
configurations (`Branching.Lossless.recurs`), so what it lost it has again. -/
theorem Lossless.loses_nothing (lossless : Lossless P) (r : Run P) {l : List S}
    (held : ∀ n, r.state n ∈ l) {q : S → A} {d : Nat → A}
    (falls : ∀ n, M.le (M.add (q (r.state (n + 1))) (d n)) (q (r.state n))) (n : Nat) :
    M.le (d n) M.zero :=
  match lossless.recurs r held n with
  | ⟨0, pos, _⟩ => absurd pos (Nat.lt_irrefl 0)
  | ⟨e + 1, _, back⟩ =>
    have same : r.state (n + 1 + e) = r.state n :=
      (congrArg r.state (Nat.succ_add n e)).trans back
    have up : M.le (q (r.state n)) (q (r.state (n + 1))) :=
      Eq.subst (motive := fun x => M.le (q x) (q (r.state (n + 1)))) same
        (Amounts.still_within (T := 0) (s := fun k => q (r.state k))
          (fun t _ => M.le_trans (Amounts.le_add_right _ (d t)) (falls t)) e (n + 1)
          (Nat.zero_le _))
    M.le_of_add_le_add_right (q (r.state (n + 1)))
      (M.le_trans (Amounts.le_of_eq (M.add_comm (d n) _))
        (M.le_trans (falls n) (M.le_trans up (Amounts.le_of_eq (M.zero_add _).symm))))

/-- **A loss along a run needs a merge**, for every process: where a list holds every
configuration of a run and an amount, with each step's loss, is within its value before the step
along it, a loss above nothing at some step means the process merges configurations. -/
theorem loss_needs_merge (r : Run P) {l : List S} (held : ∀ n, r.state n ∈ l) {q : S → A}
    {d : Nat → A} (falls : ∀ n, M.le (M.add (q (r.state (n + 1))) (d n)) (q (r.state n)))
    {n : Nat} (positive : ¬ M.le (d n) M.zero) : ¬ Lossless P :=
  fun lossless => positive (lossless.loses_nothing r held falls n)

/-- **Rest from a finite reading, along a run of every process.** Where a list holds every
configuration of a run and an amount read off them does not rise from `T` on, steps across which
it falls strictly do not recur, whether or not the process merges: `Amounts.rests_of_finite_reading`
along the run. With `Branching.loss_needs_merge`, a run within finitely many configurations either
loses nothing (where the process merges nothing) or comes to rest, with no least loss. -/
theorem rests_along_run (r : Run P) {l : List S} (held : ∀ n, r.state n ∈ l) {q : S → A} {T : Nat}
    (still : ∀ t, T ≤ t → M.le (q (r.state (t + 1))) (q (r.state t))) :
    ¬ ∀ N, ∃ t, N ≤ t ∧ ¬ M.le (q (r.state t)) (q (r.state (t + 1))) :=
  Amounts.rests_of_finite_reading (fun t _ => held t) still

end Branching

namespace Law

variable {S : Type} {A : Type} {M : Amounts A}

/-- **A law that merges nothing regains its amounts.** Where a list holds every configuration
and the law merges nothing, an amount that does not rise along an orbit is, at its start, within
its value at every step of the orbit: the orbit returns to its start, so nothing it lost stays
lost. -/
theorem Lossless.regains {next : S → S} (lossless : Lossless next) {all : List S}
    (every : ∀ s, s ∈ all) {q : S → A} {s : S}
    (still : ∀ n, M.le (q (orbit next s (n + 1))) (q (orbit next s n))) (n : Nat) :
    M.le (q s) (q (orbit next s n)) :=
  match returns_iff.mp (lossless.returns every s) with
  | ⟨0, pos, _⟩ => absurd pos (Nat.lt_irrefl 0)
  | ⟨p + 1, _, back⟩ =>
    have whole : orbit next s (n + p * n) = s :=
      (congrArg (orbit next s) ((Nat.add_comm n (p * n)).trans (Nat.succ_mul p n).symm)).trans
        (orbit_mul back n)
    Eq.subst (motive := fun x => M.le (q x) (q (orbit next s n))) whole
      (Amounts.still_within (s := fun k => q (orbit next s k)) (fun t _ => still t) (p * n) n
        (Nat.zero_le n))

/-- **Losing nothing, a law loses nothing.** Where a list holds every configuration and the law
merges nothing, an amount that, with each step's loss, is within its value before the step loses
nothing at any step: every loss is within nothing. The law of every process
(`Branching.Lossless.loses_nothing`) along the law's run from `s`. -/
theorem Lossless.loses_nothing {next : S → S} (lossless : Lossless next) {all : List S}
    (every : ∀ s, s ∈ all) {q : S → A} {d : Nat → A} {s : S}
    (falls : ∀ n, M.le (M.add (q (orbit next s (n + 1))) (d n)) (q (orbit next s n)))
    (n : Nat) : M.le (d n) M.zero :=
  Branching.Lossless.loses_nothing lossless (run next s) (fun _ => every _) falls n

/-- **A loss needs a merge.** Where a list holds every configuration and an amount, with each
step's loss, is within its value before the step along an orbit, a loss above nothing at some
step means the law merges configurations: the law of every process (`Branching.loss_needs_merge`)
along the law's run from `s`. The least loss on which the rest laws turn is a premise of laws that
merge: of descriptions that lump configurations, not of a law over finitely many configurations
that merges nothing, which returns rather than rests. -/
theorem loss_needs_merge {next : S → S} {all : List S} (every : ∀ s, s ∈ all) {q : S → A}
    {d : Nat → A} {s : S}
    (falls : ∀ n, M.le (M.add (q (orbit next s (n + 1))) (d n)) (q (orbit next s n)))
    {n : Nat} (positive : ¬ M.le (d n) M.zero) : ¬ Lossless next :=
  Branching.loss_needs_merge (run next s) (fun _ => every _) falls positive

end Law


/-! ## A part's merge, kept by the rest -/

namespace Law

variable {S : Type} {P : Type} {E : Type}

/-- **Distinct configurations need room in their readings.** Where two readings, a part `part`
and a rest `rest`, together tell every configuration apart, `k` configurations no two of which
coincide, with their parts held by `ps` and their rests by `es`, number at most
`ps.length * es.length`. -/
theorem distinct_within {part : S → P} {rest : S → E}
    (tells : ∀ x y, part x = part y → rest x = rest y → x = y)
    {h : Nat → S} {k : Nat} (distinct : ∀ i j, i < j → j < k → h i ≠ h j)
    {ps : List P} {es : List E} (inP : ∀ i, i < k → part (h i) ∈ ps)
    (inE : ∀ i, i < k → rest (h i) ∈ es) : ¬ ps.length * es.length < k := fun beyond =>
  have size : (pairsOf ps es).length = ps.length * es.length :=
    (length_pairsOf es ps).trans (Nat.mul_comm _ _)
  have room : ∀ n, n ≤ (pairsOf ps es).length → (part (h n), rest (h n)) ∈ pairsOf ps es :=
    fun n le =>
      have below : n < k := Nat.lt_of_le_of_lt (Nat.le_trans le (Nat.le_of_eq size)) beyond
      mem_pairsOf (inP n below) (inE n below)
  match revisits_within (pairsOf ps es) (fun n => (part (h n), rest (h n))) room with
  | ⟨i, j, lt, le, same⟩ =>
    distinct i j lt (Nat.lt_of_le_of_lt (Nat.le_trans le (Nat.le_of_eq size)) beyond)
      (tells _ _ (congrArg Prod.fst same) (congrArg Prod.snd same))

/-- **Merging nothing, a law keeps the possibilities apart.** Under a law that merges nothing,
configurations no two of which coincide are, any number of steps on, still no two alike. -/
theorem Lossless.keeps_apart {next : S → S} (lossless : Lossless next) {h : Nat → S} {k : Nat}
    (distinct : ∀ i j, i < j → j < k → h i ≠ h j) (n : Nat) :
    ∀ i j, i < j → j < k → orbit next (h i) n ≠ orbit next (h j) n :=
  fun i j lt below same => distinct i j lt below (lossless.cancel n same)

/-- **A part's narrowing spreads the rest.** Under a law that merges nothing, read every
configuration by a part and a rest that together tell configurations apart. Of `k` possibilities
no two alike, if `n` steps on their parts are held by `ps` and their rests by `es`, then `k` is at
most `ps.length * es.length`: the possibilities are conserved, so where the part is narrowed to
fewer configurations the rest must hold correspondingly more: where the parts of `k` possibilities
are narrowed to one configuration (`ps` of length one), every list holding their rests has at least
`k` members, and where every rest lies in a list of `N`, the parts need a list of at least `k / N`.
This is Landauer's count, with no energy, temperature or probability, from the law's merging
nothing alone. -/
theorem Lossless.narrowing_spreads {next : S → S} (lossless : Lossless next) {part : S → P}
    {rest : S → E} (tells : ∀ x y, part x = part y → rest x = rest y → x = y)
    {h : Nat → S} {k : Nat} (distinct : ∀ i j, i < j → j < k → h i ≠ h j) (n : Nat)
    {ps : List P} {es : List E} (inP : ∀ i, i < k → part (orbit next (h i) n) ∈ ps)
    (inE : ∀ i, i < k → rest (orbit next (h i) n) ∈ es) : ¬ ps.length * es.length < k :=
  distinct_within tells (lossless.keeps_apart distinct n) inP inE

/-- **Resetting a part at every step needs an unbounded whole.** Where a law merges nothing and,
after every step, a part reads one configuration `p`, then if any configuration has another part,
no list holds every configuration: within finitely many configurations the law would return every
configuration (`Law.Lossless.returns`), each would come after a step, and its part would be `p`.
A part whose reading merges at every step, inside a whole that merges nothing, passes what it
loses into a rest that grows without bound. -/
theorem Lossless.reset_unlisted {next : S → S} (lossless : Lossless next) {part : S → P} {p : P}
    (reset : ∀ x, part (next x) = p) {y : S} (other : part y ≠ p) :
    ¬ ∃ all : List S, ∀ s, s ∈ all := fun ⟨_, every⟩ =>
  match returns_iff.mp (lossless.returns every y) with
  | ⟨0, pos, _⟩ => absurd pos (Nat.lt_irrefl 0)
  | ⟨k + 1, _, back⟩ =>
    other (Eq.subst (motive := fun x => part x = p) back (reset (orbit next y k)))

end Law

/-! ## Reset: a part merged at every step, a whole that merges nothing -/

namespace Reset

/-- The part, one bit, is set to `false` at every step, and the bit it held passes onto the rest,
a list kept: the history of what the part held. -/
def next (x : Bool × List Bool) : Bool × List Bool := (false, x.1 :: x.2)

/-- The whole merges nothing. -/
theorem lossless : Law.Lossless next := Law.lossless_iff.mpr fun x y same => by
  cases x with
  | mk a h =>
    cases y with
    | mk b h' =>
      injection same with _ rest
      injection rest with bit hist
      subst bit
      subst hist
      rfl

/-- The part merges at every step: whatever it held, it reads `false` after the step. -/
theorem part_merges (x : Bool × List Bool) : (next x).1 = false := rfl

/-- The rest grows by one at every step. -/
theorem rest_length (x : Bool × List Bool) : ∀ n, (Law.orbit next x n).2.length = x.2.length + n
  | 0 => rfl
  | n + 1 => congrArg Nat.succ (rest_length x n)

/-- **The part's merges kept by the rest.** The part merges at every step and the whole merges
nothing; the rest of every run never repeats, so no list holds it, as `Law.Lossless.reset_unlisted`
requires of every such law. -/
theorem kept_by_rest :
    Law.Lossless next ∧ (∀ x, (next x).1 = false) ∧ (next (true, [])).1 = (next (false, [])).1 ∧
    (∀ x, ¬ ∃ l : List (List Bool), ∀ n, (Law.orbit next x n).2 ∈ l) ∧
    ¬ ∃ all : List (Bool × List Bool), ∀ s, s ∈ all :=
  ⟨lossless, part_merges, rfl,
   fun x => unlisted_of_new (g := fun n => (Law.orbit next x n).2) fun i j lt same =>
     Naturals.ne_of_lt lt (Naturals.add_left_cancel ((rest_length x i).symm.trans
       ((congrArg List.length same).trans (rest_length x j)))),
   lossless.reset_unlisted (part := Prod.fst) (p := false) part_merges (y := (true, []))
     (fun same => Bool.noConfusion same)⟩

end Reset

end Becoming
