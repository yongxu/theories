import Becoming.MapRegions
import Becoming.WideningOnTheMap
import Becoming.HeldPossible

/-!
HE2's item 5, checked outside the package before the rebuild: the reach laws of the successor
relation stated once, at `Map.step` in GrammarMap (which imports only `Becoming.Grammar`), and each
copy elsewhere recovered from them by one application. The two laws below use only `Becoming.Grammar`
and `Init`, as they would in GrammarMap.
-/

namespace Becoming
namespace HE2Item5

open Map

/-- What a line along the successor reaches is later (to replace `Map.step_reached_le` in
MapRegions, `Steps.reached_le` in WideningOnTheMap and HeldPossible's local `reached_le`). -/
theorem reached_le {L : «际» Nat} : ∀ {x y : Nat}, «所及» step L x y → x ≤ y := by
  intro x y h
  match h with
  | .inl e => exact Nat.le_of_eq e
  | .inr l =>
    have later : ∀ {a b : Nat}, «相续» step L a b → a + 1 ≤ b := by
      intro a b l
      induction l with
      | one c => exact Nat.le_of_eq c.1.symm
      | more c _ ih => exact c.1 ▸ Nat.le_of_succ_le ih
    exact Nat.le_of_succ_le (later l)

/-- Under the one, the line along the successor reaches each later number (to replace
HeldPossible's local `reach_to`). -/
theorem reach_succ : ∀ (k x : Nat), «相续» step «一» x (x + k + 1)
  | 0, _ => .one ⟨rfl, trivial⟩
  | k + 1, x => .more ⟨rfl, trivial⟩
      (Eq.subst (motive := fun z => «相续» step «一» (x + 1) z)
        (congrArg (· + 1) (Nat.succ_add x k)) (reach_succ k (x + 1)))

/-- Under the one, the line along the successor reaches every later number (to replace HeldPossible's
local `reach_to`). -/
theorem reach_of_le {x y : Nat} (le : x ≤ y) : «所及» step «一» x y :=
  match Nat.eq_or_lt_of_le le with
  | .inl same => .inl same
  | .inr lt =>
    -- a later number is the earlier plus a successor, by induction on `≤` alone: GrammarMap
    -- imports only the grammar, not `le_dest` of the prelude
    have lt_dest : ∀ {a b : Nat}, a < b → ∃ k, b = a + k + 1 := by
      intro a b lt
      induction lt with
      | refl => exact ⟨0, rfl⟩
      | step _ ih => match ih with
        | ⟨k, at_⟩ => exact ⟨k + 1, congrArg (· + 1) at_⟩
    match lt_dest lt with
    | ⟨k, at_⟩ => .inr (Eq.subst (motive := fun z => «相续» step «一» x z) at_.symm (reach_succ k x))

/-! Each copy is one application. -/

example {L : «际» Nat} {x y : Nat} : «所及» Map.step L x y → x ≤ y := reached_le
example {L : «际» Nat} {x y : Nat} : «所及» Steps.next L x y → x ≤ y := reached_le
example {x y : Nat} : x ≤ y → «所及» Steps.next «一» x y := reach_of_le

/-- The statements agree with the copies they replace. -/
example : @Map.step_reached_le = fun L x y => @reached_le L x y := rfl
example : @Steps.reached_le = fun L x y => @reached_le L x y := rfl

end HE2Item5
end Becoming
