import Becoming.CountedCodes

/-! Review probes for UE25 (`Becoming.CountedCodes`), part b: where `onto` is needed, and what
the speaker hypothesis already excludes. Scratch only; `omega` may report axioms here. -/

namespace Becoming

namespace Probe25b

open CountedCodes

/-! ### P9. Without `onto`, `never_shared_greatest`'s conclusion fails for an exchange that is not
an involution: agents `Int` shifted by one, words `Nat` renamed by `succ` (moving every word, not
onto), the counts of agent `i` at word `w` read off `w - i`. Agents `0` and `1` each hold word `0`
as greatest, and the start is related to itself. (The identity law keeps every relation.) -/

def g (k : Int) : Nat := if k = 0 then 1 else if k = -1 then 2 else 0

def X : Int → Unit → Nat → Nat := fun i _ w => g ((w : Int) - i)

theorem p9_symmetric : Renamed (fun i => i + 1) (fun (_ : Unit) w => w + 1) X X := by
  intro i _ w
  show g ((w : Int) - i) = g (((w + 1 : Nat) : Int) - (i + 1))
  congr 1
  omega

theorem p9_moves : ∀ w : Nat, w + 1 ≠ w := fun w h => Nat.succ_ne_self w h

theorem p9_not_onto : ¬ ∀ u : Nat, ∃ v, v + 1 = u :=
  fun h => match h 0 with
    | ⟨v, e⟩ => Nat.succ_ne_zero v e

theorem p9_zero_greatest : Greatest (X 0 ()) 0 := by
  intro w ne
  show g ((w : Int) - 0) < g ((0 : Nat) - (0 : Int))
  have h1 : ((w : Int) - 0) ≠ 0 := by omega
  have h2 : ((w : Int) - 0) ≠ -1 := by omega
  unfold g
  rw [if_neg h1, if_neg h2]
  decide

theorem p9_one_greatest : Greatest (X 1 ()) 0 := by
  intro w ne
  show g ((w : Int) - 1) < g ((0 : Nat) - (1 : Int))
  have h0 : ((0 : Nat) : Int) - 1 = -1 := by omega
  rw [h0]
  have h1 : ((w : Int) - 1) ≠ -1 := by omega
  unfold g
  by_cases h : ((w : Int) - 1) = 0
  · rw [if_pos h]; decide
  · rw [if_neg h, if_neg h1]; decide

/-- The conclusion of `never_shared_greatest` fails: the identity law keeps the relation, the start
is related to itself, the renaming moves every word, and agents `0` and `0 + 1` hold one word as
greatest. Only `onto` is missing. -/
theorem p9_counterexample :
    Law.KeepsRelation (fun Y => Y) (Renamed (fun i : Int => i + 1) (fun (_ : Unit) w => w + 1)) ∧
      Renamed (fun i => i + 1) (fun (_ : Unit) w => w + 1) X X ∧
      Greatest ((Law.run (fun Y => Y) X).state 0 0 ()) 0 ∧
      Greatest ((Law.run (fun Y => Y) X).state 0 (0 + 1) ()) 0 :=
  ⟨fun _ _ r => r, p9_symmetric, p9_zero_greatest, p9_one_greatest⟩

/-! ### P10. The speaker hypothesis already excludes naming one word from a tie: a speaker reading
count by count and commuting with a renaming says, from counts the renaming fixes, counts the
renaming fixes. So the deterministic speakers the law covers are those that never name a word
from a tie. -/

theorem p10_tied_says_tied {M F : Type} {σ : M → F → F} {say : M → (F → Nat) → F → Nat}
    (reads : CountByCount say) (alike : CommutesWithRenaming σ say) {m : M} {c : F → Nat}
    (fixed : ∀ x, c (σ m x) = c x) (w : F) : say m c (σ m w) = say m c w :=
  (alike m c w).symm.trans (reads m (rename σ m c) c fixed w)

end Probe25b

end Becoming
