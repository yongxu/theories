import Lean
open Lean
-- The idiom file's miniature (certificate-idiom.lean), with a recovery that names the form idly.
def Incl {α : Type} (R S : α → α → Prop) : Prop := ∀ a b, R a b → S a b
def Holds {α : Type} (R : α → α → Prop) (x y : α) : Prop := R x y
theorem form {α : Type} (R S : α → α → Prop) (x y : α) (incl : Incl R S) (holds : Holds R x y) : S x y :=
  incl x y holds
def step (n m : Nat) : Prop := m = n + 1
def Clo {α : Type} (R : α → α → Prop) (x y : α) : Prop := x = y ∨ R x y
theorem row (n : Nat) : Clo step n (n + 1) := Or.inr rfl
-- Proves the row by the model's own reasoning; the form is named but not applied.
theorem recovery' (n : Nat) : Clo step n (n + 1) := (fun (_ : type_of% @form) => Or.inr rfl) @form
theorem cert' : @row = @recovery' := rfl
#eval show CoreM Unit from do
  let env ← getEnv
  let some (.thmInfo v) := env.find? `recovery' | throwError "missing"
  IO.println s!"recovery' names: {v.value.getUsedConstants.toList}"
#print axioms cert'
