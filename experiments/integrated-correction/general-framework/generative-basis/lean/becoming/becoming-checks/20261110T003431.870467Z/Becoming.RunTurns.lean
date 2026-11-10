import Becoming.RegimeMargin
import Becoming.BandRest
import Becoming.ReadingSchedule

/-!
# Where a run turns: the step breaks the order there (CY's first piece)

A run of a determined law can rise and then fall: it turns. This module states where such a turn
can come from. It ranks no courses.

* **A turn shows the step breaking the relation on the run itself.** For any carrier, and any
  relation decided on every pair, where the relation holds between the run's start and its next
  state and fails between its states at `n` and `n + 1`, some step `k` before `n` has the relation
  holding between the run's states at `k` and `k + 1` and failing between their images under the
  step (`turns_where_order_breaks`, from `Optimum.last_before`). The carrier may carry history, so
  this part holds for a step with memory too. On whole-number levels with their order, a run whose
  first step does not lower it and which later falls names two levels, the lower first, that the
  step carries the other way (`turns_names_levels`).
* **On a regime, such a turn is overcompensation.** Under a standing draw `H` with giving `g`
  (`RegimeMargin.step`, the draw taken first and what is left `x - H` in natural subtraction), a run
  whose first step does not lower it and which later falls names two amounts left, the less first,
  at which more left is given less (`regime_turn_overcompensates`). Where giving rises with what is
  left, the regime's step keeps the order (`RegimeMargin.step_mono`) and the run moves one way only.
* **A step that reverses the order on a band ends at rest or period two.** Where the step reverses
  the order of the levels up to `hi` and keeps them within `hi`, taken twice it keeps the order
  there, so from a start within the band the run's even and odd steps each come to rest
  (`BandRest.rests_on_band`), and from step `hi + hi` on the run is had again two steps later
  (`reversing_period_two`). This forces no turn: a step sending every level to one level reverses
  the order and holds there.
* **A period-three regime whose step neither keeps nor reverses the order.** Under a draw of one,
  giving three from nothing and nothing from anything more, the run from one goes to three, two
  and back to one, and the step neither keeps nor reverses the order of the band up to three
  (`ThreeCycle.returns`, `ThreeCycle.neither`).

The laws on levels are laws of scalar steps; none is new as mathematics: an antitone step's
square is monotone, and a bounded monotone run of whole numbers comes to rest.
-/

namespace Becoming

namespace RunTurns

universe u

/-! ## A turn shows the step breaking the relation -/

section AnyRelation

variable {V : Type u} {rel : V → V → Prop} {g : V → V}

/-- **Where a run turns, the step breaks the relation on the run itself.** For a relation decided
on every pair: where it holds between a run's start and its next state (`rel x (g x)`) and fails
between its states at `n` and `n + 1`, some step `k` before `n` has it holding between the run's
states at `k` and `k + 1` and failing between their images under the step. -/
theorem turns_where_order_breaks (dec : ∀ a b, Decidable (rel a b)) {x : V} (start : rel x (g x))
    {n : Nat} (turns : ¬ rel (Law.orbit g x n) (Law.orbit g x (n + 1))) :
    ∃ k, k < n ∧ rel (Law.orbit g x k) (Law.orbit g x (k + 1)) ∧
      ¬ rel (g (Law.orbit g x k)) (g (Law.orbit g x (k + 1))) :=
  @Optimum.last_before (fun k => rel (Law.orbit g x k) (Law.orbit g x (k + 1))) (fun _ => dec _ _)
    start n turns

end AnyRelation

/-- **On whole numbers a turn names two levels.** A run whose first step does not lower its start
and which falls at step `n` has, at some step `k` before `n`, a level below the next, which the step
carries to a level above the next's image. -/
theorem turns_names_levels {g : Nat → Nat} {x n : Nat} (start : x ≤ g x)
    (falls : Law.orbit g x (n + 1) < Law.orbit g x n) :
    ∃ k, k < n ∧ Law.orbit g x k < Law.orbit g x (k + 1) ∧
      g (Law.orbit g x (k + 1)) < g (Law.orbit g x k) :=
  match turns_where_order_breaks (rel := fun a b : Nat => a ≤ b) (g := g) (fun a b => Nat.decLe a b)
      start (Nat.not_le_of_gt falls) with
  | ⟨k, lt, le, broken⟩ =>
    have back : g (Law.orbit g x (k + 1)) < g (Law.orbit g x k) := Nat.lt_of_not_le broken
    ⟨k, lt, Nat.lt_of_le_of_ne le fun same =>
      broken (Eq.subst (motive := fun v => g (Law.orbit g x k) ≤ g v) same (Nat.le_refl _)), back⟩

/-- **On a regime, a turn is overcompensation.** Under a standing draw `H` with giving `g`, a run
whose first step does not lower its level and which falls at step `n` has, at some step `k` before
`n`, a level below the next whose amount left is below the next's, and at which more left is given
less: `g` of the next's amount left is below `g` of its own. -/
theorem regime_turn_overcompensates {g : Nat → Nat} {H x n : Nat}
    (start : x ≤ RegimeMargin.step g H x)
    (falls : Law.orbit (RegimeMargin.step g H) x (n + 1) < Law.orbit (RegimeMargin.step g H) x n) :
    ∃ k, k < n ∧
      Law.orbit (RegimeMargin.step g H) x k < Law.orbit (RegimeMargin.step g H) x (k + 1) ∧
      Law.orbit (RegimeMargin.step g H) x k - H < Law.orbit (RegimeMargin.step g H) x (k + 1) - H ∧
      g (Law.orbit (RegimeMargin.step g H) x (k + 1) - H) < g (Law.orbit (RegimeMargin.step g H) x k - H) :=
  match turns_names_levels (g := RegimeMargin.step g H) start falls with
  | ⟨k, lt, rise, back⟩ =>
    have left : Law.orbit (RegimeMargin.step g H) x k - H ≤
        Law.orbit (RegimeMargin.step g H) x (k + 1) - H := Nat.sub_le_sub_right (Nat.le_of_lt rise) H
    have less : g (Law.orbit (RegimeMargin.step g H) x (k + 1) - H) <
        g (Law.orbit (RegimeMargin.step g H) x k - H) :=
      Nat.lt_of_not_le fun more => Nat.not_le_of_gt back (Nat.add_le_add left more)
    ⟨k, lt, rise, Nat.lt_of_le_of_ne left fun same =>
      Nat.lt_irrefl _ (Eq.subst (motive := fun v => g v < g (Law.orbit (RegimeMargin.step g H) x k - H))
        same.symm less), less⟩

/-! ## A step that reverses the order on a band ends at rest or period two -/

section Band

variable {g : Nat → Nat} {hi : Nat}

/-- For every `m`, `m + m` steps of `g` are `m` steps of `g` taken twice. -/
theorem orbit_twice (g : Nat → Nat) (x : Nat) :
    ∀ m, Law.orbit g x (m + m) = Law.orbit (fun y => g (g y)) x m
  | 0 => rfl
  | m + 1 =>
    have e : (m + 1) + (m + 1) = m + m + 1 + 1 :=
      (Nat.add_assoc (m + 1) m 1).symm.trans (congrArg (· + 1) (Nat.add_right_comm m 1 m))
    (congrArg (Law.orbit g x) e).trans (congrArg (fun y => g (g y)) (orbit_twice g x m))

/-- For every `m`, `g` after `m` steps of `g` taken twice is `m` steps of `g` taken twice from
`g x`. -/
theorem step_after_twice (g : Nat → Nat) (x : Nat) :
    ∀ m, g (Law.orbit (fun y => g (g y)) x m) = Law.orbit (fun y => g (g y)) (g x) m
  | 0 => rfl
  | m + 1 => congrArg (fun y => g (g y)) (step_after_twice g x m)

/-- **A step that reverses the order on a band and keeps the band ends at rest or period two.**
Where `a ≤ b ≤ hi` gives `g b ≤ g a` and `y ≤ hi` gives `g y ≤ hi`, from a start within the band:
taken twice the step keeps the order on the band, so the run's even steps and its odd steps each
come to rest within `hi` steps of their own (`BandRest.rests_on_band`), and from step `hi + hi` on
the run is had again two steps later. -/
theorem reversing_period_two (anti : ∀ a b, a ≤ b → b ≤ hi → g b ≤ g a)
    (keeps : ∀ y, y ≤ hi → g y ≤ hi) {x : Nat} (high : x ≤ hi) :
    ∀ n, hi + hi ≤ n → Law.orbit g x (n + 1 + 1) = Law.orbit g x n :=
  have mono2 : ∀ a b, a ≤ b → b ≤ hi → g (g a) ≤ g (g b) := fun a b le top =>
    anti (g b) (g a) (anti a b le top) (keeps a (Nat.le_trans le top))
  have keeps2 : ∀ y, y ≤ hi → g (g y) ≤ hi := fun y within => keeps (g y) (keeps y within)
  have stays : ∀ (y N m : Nat), LastChange.StillFrom (Law.run (fun v => g (g v)) y) N → N ≤ m →
      Law.orbit (fun v => g (g v)) y (m + 1) = Law.orbit (fun v => g (g v)) y m :=
    fun y _ _ still le => match le_dest le with
      | ⟨k, at_m⟩ => Eq.subst
          (motive := fun j => Law.orbit (fun v => g (g v)) y (j + 1) = Law.orbit (fun v => g (g v)) y j)
          at_m.symm (still k)
  match BandRest.rests_on_band (g := fun v => g (g v)) mono2 keeps2 high,
      BandRest.rests_on_band (g := fun v => g (g v)) mono2 keeps2 (keeps x high) with
  | ⟨N₁, le₁, still₁⟩, ⟨N₂, le₂, still₂⟩ => fun n late =>
    have twice : (m : Nat) → (m + 1) + (m + 1) = m + m + 1 + 1 := fun m =>
      (Nat.add_assoc (m + 1) m 1).symm.trans (congrArg (· + 1) (Nat.add_right_comm m 1 m))
    match ReadingSchedule.halves n with
    | ⟨m, .inl even'⟩ =>
      have even : n = m + m := even'.trans (Naturals.two_mul m)
      have far : hi ≤ m := Nat.ge_of_not_lt fun lt =>
        Nat.not_le_of_gt (Nat.add_lt_add lt lt) (Eq.subst (motive := fun j => hi + hi ≤ j) even late)
      have at_n : n + 1 + 1 = (m + 1) + (m + 1) :=
        (congrArg (· + 1 + 1) even).trans (twice m).symm
      (congrArg (Law.orbit g x) at_n).trans ((orbit_twice g x (m + 1)).trans
        ((stays x N₁ m still₁ (Nat.le_trans le₁ far)).trans
          ((orbit_twice g x m).symm.trans (congrArg (Law.orbit g x) even.symm))))
    | ⟨m, .inr odd'⟩ =>
      have odd : n = m + m + 1 := odd'.trans (congrArg (· + 1) (Naturals.two_mul m))
      have far : hi ≤ m := Nat.ge_of_not_lt fun lt =>
        Nat.not_le_of_gt
          (Eq.subst (motive := fun j => j < hi + hi) (Nat.add_right_comm m 1 m)
            (Nat.add_lt_add_of_le_of_lt lt lt))
          (Eq.subst (motive := fun j => hi + hi ≤ j) odd late)
      have at_n : n + 1 + 1 = (m + 1) + (m + 1) + 1 :=
        (congrArg (· + 1 + 1) odd).trans (congrArg (· + 1) (twice m)).symm
      have odd_run : ∀ j, Law.orbit g x (j + j + 1) = Law.orbit (fun y => g (g y)) (g x) j := fun j =>
        (congrArg g (orbit_twice g x j)).trans (step_after_twice g x j)
      (congrArg (Law.orbit g x) at_n).trans ((odd_run (m + 1)).trans
        ((stays (g x) N₂ m still₂ (Nat.le_trans le₂ far)).trans
          ((odd_run m).symm.trans (congrArg (Law.orbit g x) odd.symm))))

end Band

/-! ## A period-three regime whose step neither keeps nor reverses the order -/

namespace ThreeCycle

/-- Giving three from nothing, nothing from anything more. -/
def giving (z : Nat) : Nat := if z = 0 then 3 else 0

/-- Under a draw of one, the regime's step keeps every level up to three within three. -/
theorem keeps : RegimeMargin.Keeps giving 1 3
  | 0, _ => by decide
  | 1, _ => by decide
  | 2, _ => by decide
  | 3, _ => by decide
  | n + 4, high => absurd high (Nat.not_le_of_gt (Nat.lt_of_lt_of_le (by decide) (Nat.le_add_left 4 n)))

/-- From one, the regime's run goes to three, then two, and is back at one at the third step. -/
theorem cycle :
    Law.orbit (RegimeMargin.step giving 1) 1 1 = 3 ∧ Law.orbit (RegimeMargin.step giving 1) 1 2 = 2 ∧
      Law.orbit (RegimeMargin.step giving 1) 1 3 = 1 :=
  ⟨by decide, by decide, by decide⟩

/-- **The run from one returns every third step and at no earlier one.** -/
theorem returns : (∀ k, Law.orbit (RegimeMargin.step giving 1) 1 (3 * k) = 1) ∧
    Law.orbit (RegimeMargin.step giving 1) 1 1 ≠ 1 ∧ Law.orbit (RegimeMargin.step giving 1) 1 2 ≠ 1 :=
  ⟨fun k => Law.orbit_mul (next := RegimeMargin.step giving 1) (s := 1) (p := 3) cycle.2.2 k,
   by decide, by decide⟩

/-- **The step neither keeps nor reverses the order of the band up to three.** One is below two,
and the step carries them to three and one; two is below three, and the step carries them to one
and two. -/
theorem neither :
    ¬ (∀ a b, a ≤ b → b ≤ 3 → RegimeMargin.step giving 1 a ≤ RegimeMargin.step giving 1 b) ∧
      ¬ (∀ a b, a ≤ b → b ≤ 3 → RegimeMargin.step giving 1 b ≤ RegimeMargin.step giving 1 a) :=
  ⟨fun keepsOrder => absurd (keepsOrder 1 2 (by decide) (by decide)) (by decide),
   fun reverses => absurd (reverses 2 3 (by decide) (by decide)) (by decide)⟩

end ThreeCycle

end RunTurns

end Becoming
