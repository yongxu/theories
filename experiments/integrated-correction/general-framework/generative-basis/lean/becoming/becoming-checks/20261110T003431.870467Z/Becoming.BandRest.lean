import Becoming.Lasting
import Becoming.LastChange
import Becoming.Optimum

/-!
# Rest on a band: a step that keeps the order there brings every run to rest

Where a step of a determined law on whole-number levels keeps the order of the levels up to `hi`
and keeps those levels within `hi`, every run starting within the band comes to rest within `hi`
steps (`rests_on_band`). The run moves one way only: `Lasting.orbit_mono` read on the order within
the band, with the second run started one step later, which is the closure law (`Invariant.reach`)
on the levels the step does not lower. So the level, or its distance below the start, marks the
run's changes, and a marked run bounded by the band is still within the bound
(`LastChange.still_within`).

`RegimeMargin.rests_within` is the case of the regime's step under giving that rises with what is
left, and is derived from this law. `RunTurns.reversing_period_two` uses it for a step taken twice.
Nothing here is new as mathematics: a bounded monotone run of whole numbers comes to rest.
-/

namespace Becoming

namespace BandRest

variable {g : Nat → Nat} {hi : Nat}

/-- **A step that keeps the order on a band and keeps the band brings every run starting within it
to rest within `hi` steps.** Where `a ≤ b ≤ hi` gives `g a ≤ g b` and `y ≤ hi` gives `g y ≤ hi`, the
run from a level up to `hi` is still from some step at most `hi`: within `hi - x` steps where its
first step does not lower it, within `x` where its first step does not raise it. -/
theorem rests_on_band (mono : ∀ a b, a ≤ b → b ≤ hi → g a ≤ g b) (keeps : ∀ y, y ≤ hi → g y ≤ hi)
    {x : Nat} (high : x ≤ hi) : ∃ N, N ≤ hi ∧ LastChange.StillFrom (Law.run g x) N :=
  have band : ∀ a b, (a ≤ b ∧ b ≤ hi) → (g a ≤ g b ∧ g b ≤ hi) := fun a b within =>
    ⟨mono a b within.1 within.2, keeps b within.2⟩
  have top : ∀ n, Law.orbit g x n ≤ hi := fun n => by
    induction n with
    | zero => exact high
    | succ n ih => exact keeps _ ih
  (Nat.le_total x (g x)).elim
    (fun first =>
      have up : ∀ n, Law.orbit g x n ≤ Law.orbit g x (n + 1) := fun n =>
        Eq.subst (motive := fun v => Law.orbit g x n ≤ v) (Law.orbit_shift g x n).symm
          (Lasting.orbit_mono (rel := fun a b => a ≤ b ∧ b ≤ hi) (g := g) band
            ⟨first, keeps x high⟩ n).1
      have ⟨N, le, still⟩ := LastChange.still_within (q := fun v => v) (B := hi) (hi - x) x
        (Nat.le_of_eq (Naturals.sub_add_cancel high).symm) (fun n => ⟨up n, fun apart =>
          Nat.lt_of_le_of_ne (up n) fun same => apart same.symm⟩) top
      ⟨N, Nat.le_trans le (Nat.sub_le hi x), still⟩)
    (fun first =>
      have down : ∀ n, Law.orbit g x (n + 1) ≤ Law.orbit g x n := fun n =>
        Eq.subst (motive := fun v => v ≤ Law.orbit g x n) (Law.orbit_shift g x n).symm
          (Lasting.orbit_mono (rel := fun a b => a ≤ b ∧ b ≤ hi) (g := g) band ⟨first, high⟩ n).1
      have below : ∀ n, Law.orbit g x n ≤ x := fun n => by
        induction n with
        | zero => exact Nat.le_refl x
        | succ n ih => exact Nat.le_trans (down n) ih
      have ⟨N, le, still⟩ := LastChange.still_within (q := fun v => x - v) (B := x) x x
        (Nat.le_add_right x _) (fun n => ⟨Optimum.sub_le_sub_left_of_le (down n) x, fun apart =>
          Requirement.Formation.sub_lt_sub_of_lt (Nat.lt_of_le_of_ne (down n) apart) (below n)⟩)
        (fun n => Nat.sub_le x _)
      ⟨N, Nat.le_trans le high, still⟩)

end BandRest

end Becoming
