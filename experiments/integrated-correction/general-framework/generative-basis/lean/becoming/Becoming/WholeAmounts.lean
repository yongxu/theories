import Becoming.LeastLoss

/-!
# Whole amounts: what reading amounts in whole numbers carries

The spine's flows, webs and worlds count amounts in whole numbers. Three of its laws depend on that:
rest (`falls_not_recurring`, whose dense form is `Amounts.rests` with a least loss), novelty needing
gain (`Web.rises_late_of_new`: a family new at every step rises at arbitrarily late steps, since a
bounded family has finitely many configurations), and the setting of runaway by frequency
(`carried_doubles_roundTrip`: every return at least doubles, a positive whole strength being at
least one). This module shows where the whole-number reading is not available and where each of the
last two fails over dense amounts.

* **No whole-number reading of an endless fall.** In any amounts in which some amount falls strictly
  at every step, no reading into the whole numbers takes every strict fall to a strict fall
  (`Amounts.no_whole_reading`): the reading would fall at every step without end. Dyadic amounts fall
  without end (`Halving.endless`), so they have none (`Halving.no_whole_reading`). A becoming whose
  amounts change by ever smaller amounts is not represented in whole numbers keeping its order.
* **New without gain.** The halving stock is new at every step, never above any earlier one and
  below every earlier one, never rises and stays within one (`Halving.new_without_gain`): over dense
  amounts a bounded family can be new at every step with no gain, and `Web.rises_late_of_new` fails.
  Its real form, that novelty by at least a least separation needs gain, is in the periphery
  (`Becoming.Representation.separated_bounded`).
* **A return that does not double.** A return of strength one half adds half of what had reached the
  condition: the amount rises and stays below twice what it was (`Dyadic.half_return`). So the
  doubling of `carried_doubles_roundTrip` needs whole strengths; over real strengths a held loop
  still runs away exactly where it returns often, and a damped one where its strength makes up for
  the damping (`Becoming.Representation.held_polynomial_iff`, `Becoming.Representation.every_bounded_iff`).

No ethical predicate, ranking or axiom occurs; every declaration has an empty axiom report.
-/

namespace Becoming

/-- A whole number falling at every step falls, by step `t`, by at least `t`. -/
theorem falls_by_steps (f : Nat → Nat) (falls : ∀ t, f (t + 1) < f t) : ∀ t, f t + t ≤ f 0
  | 0 => Nat.le_of_eq (Nat.add_zero _)
  | t + 1 => Nat.le_trans (Nat.le_of_eq (Nat.succ_add (f (t + 1)) t).symm)
      (Nat.le_trans (Nat.add_le_add_right (Nat.succ_le_of_lt (falls t)) t) (falls_by_steps f falls t))

/-- No whole number falls at every step. -/
theorem not_falls_ever (f : Nat → Nat) : ¬ ∀ t, f (t + 1) < f t := fun falls =>
  Nat.not_succ_le_self (f 0)
    (Nat.le_trans (Nat.le_add_left (f 0 + 1) (f (f 0 + 1))) (falls_by_steps f falls (f 0 + 1)))

namespace Amounts

variable {A : Type} {M : Amounts A}

/-- **No whole-number reading of an endless fall.** Where some amount falls strictly at every step,
no reading of the amounts into the whole numbers takes every strict fall to a strict fall. -/
theorem no_whole_reading (endless : M.EndlessFall) :
    ¬ ∃ φ : A → Nat, ∀ a b, M.le b a → ¬ M.le a b → φ b < φ a :=
  fun ⟨φ, keeps⟩ => match endless with
  | ⟨s, falls⟩ => not_falls_ever (fun t => φ (s t)) fun t => keeps _ _ (falls t).1 (falls t).2

end Amounts

namespace Halving

/-- **Dyadic amounts have no whole-number reading** keeping their strict falls. -/
theorem no_whole_reading :
    ¬ ∃ φ : Dyadic → Nat, ∀ a b, Dyadic.amounts.le b a → ¬ Dyadic.amounts.le a b → φ b < φ a :=
  Amounts.no_whole_reading endless

/-- A power of two below a higher one. -/
theorem two_pow_lt {i j : Nat} (lt : i < j) : 2 ^ i < 2 ^ j :=
  match j, lt with
  | _ + 1, lt => Nat.lt_of_le_of_lt (Nat.pow_le_pow_right (Nat.zero_lt_two) (Nat.le_of_lt_succ lt))
      (Nat.pow_lt_pow_succ (Nat.lt_succ_self 1))

/-- **New without gain.** The halving stock is new at every step: no later stock holds an earlier
one; it never rises; and it stays within one. A bounded amount new at every step with no gain. -/
theorem new_without_gain :
    (∀ i j, i < j → ¬ Dyadic.amounts.le (stock i) (stock j)) ∧
      (∀ t, Dyadic.amounts.le (stock (t + 1)) (stock t)) ∧
      ∀ t, Dyadic.amounts.le (stock t) ⟨1, 0⟩ :=
  ⟨fun _ _ lt le => Nat.lt_irrefl _ (Nat.lt_of_lt_of_le
      (Nat.lt_of_lt_of_le (two_pow_lt lt) (Nat.le_of_eq (Nat.one_mul _).symm))
      (Nat.le_trans le (Nat.le_of_eq (Nat.one_mul _)))),
   never_rests.2.1,
   fun _ => Nat.le_trans (Nat.le_of_eq (Nat.one_mul _))
     (Nat.le_trans (Nat.two_pow_pos _) (Nat.le_of_eq (Nat.one_mul _).symm))⟩

end Halving

namespace Dyadic

/-- **A return of strength one half does not double.** Where a positive amount is returned to with
half of itself, the amount rises, and stays below twice what it was. -/
theorem half_return {a : Dyadic} (positive : ¬ le a zero) :
    ¬ le (add a ⟨a.num, a.exp + 1⟩) a ∧ ¬ le (add a a) (add a ⟨a.num, a.exp + 1⟩) :=
  ⟨fun le' => (half_below positive).1 (le_of_add_le_add_right' a (by
      rw [zero_add']; rw [add_comm'] at le'; exact le')),
   fun le' => (half_below positive).2 (le_of_add_le_add_right' a (by
      rw [add_comm' ⟨a.num, a.exp + 1⟩ a]; exact le'))⟩

end Dyadic

end Becoming
