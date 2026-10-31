import Lean
open Lean
namespace Becoming
universe u
abbrev «际» (α : Type u) : Type u := α → α → Prop
def «则» {α : Type u} (R S : «际» α) : Prop := ∀ x y, R x y → S x y
namespace U4Boundary
variable {X : Type}
/-- A named relational hypothesis. -/
def Gate (R S : «际» X) : Prop := «则» R S
/-- A form keeping, besides the named `Gate`, an inline hypothesis on amounts (cancellation) that no countermodel covers. -/
theorem form_inline {R S : «际» X} {raised lowered : X → Nat} (gate : Gate R S)
    (cancel : ∀ x, raised x = lowered x) : ∀ x y, R x y → S x y ∧ raised x = lowered x :=
  fun x y r => ⟨gate x y r, cancel x⟩
end U4Boundary
end Becoming
#eval show CoreM Unit from do
  let env ← getEnv
  let some ci := env.find? `Becoming.U4Boundary.form_inline | throwError "missing"
  IO.println s!"t (run constants only): {(ci.type.getUsedConstants.filter (fun n => (`Becoming).isPrefixOf n)).toList}"
  IO.println s!"t (all, incl. Init): {ci.type.getUsedConstants.toList}"
