import Lean
open Lean

def Incl {α : Type} (R S : α → α → Prop) : Prop := ∀ a b, R a b → S a b
def Holds {α : Type} (R : α → α → Prop) (x y : α) : Prop := R x y
theorem form {α : Type} (R S : α → α → Prop) (x y : α) (incl : Incl R S) (holds : Holds R x y) : S x y :=
  incl x y holds
def step (n m : Nat) : Prop := m = n + 1
def Clo {α : Type} (R : α → α → Prop) (x y : α) : Prop := x = y ∨ R x y
theorem row (n : Nat) : Clo step n (n + 1) := Or.inr rfl
theorem step_incl : Incl step (Clo step) := fun _ _ h => Or.inr h
theorem recovery (n : Nat) : Clo step n (n + 1) := form step (Clo step) n (n + 1) step_incl rfl

-- (1) the certificate written the other way round
theorem certRev : @recovery = @row := rfl
-- (2) with a type ascription on one side
theorem certAsc : @row = (@recovery : ∀ n, Clo step n (n + 1)) := rfl
-- (3) with `show`
theorem certShow : @row = @recovery := show @row = @recovery from rfl
-- (4) parenthesised Eq with explicit type
theorem certExplicit : @Eq (∀ n, Clo step n (n + 1)) @row @recovery := rfl
-- (5) a recovery that names the form without using it: the row's proof copied, the form mentioned
theorem recoveryFake (n : Nat) : Clo step n (n + 1) :=
  have _unused := @form
  Or.inr rfl
theorem certFake : @row = @recoveryFake := rfl
-- (6) a recovery through `type_of%`
theorem recoveryT : type_of% @row := fun n => form step (Clo step) n (n + 1) step_incl rfl
theorem certT : @row = @recoveryT := rfl
-- (7) Sort u against Type u
universe u
theorem rowS {S : Sort u} (s : S) : s = s := rfl
theorem bT {S : Type u} (s : S) : s = s := rfl
theorem certS.{v} : @rowS.{v+1} = @bT.{v} := rfl
-- (8) HEq: no eq
theorem certH : HEq @row @recovery := HEq.rfl

def eqField (env : Environment) (n : Name) : Option (Name × Name × Bool × Bool) := do
  let some (.thmInfo v) := env.find? n | none
  let t := v.type.consumeMData
  let general (ls : List Level) : Bool := ls.all (·.isParam) && ls.eraseDups.length == ls.length
  match t.getAppFn, t.getAppArgs.map (·.consumeMData) with
  | Expr.const ``Eq _, #[_, Expr.const a us, Expr.const b vs] => some (a, b, general us, general vs)
  | _, _ => none

#eval show CoreM Unit from do
  let env ← getEnv
  for n in [``certRev, ``certAsc, ``certShow, ``certExplicit, ``certFake, ``certT, ``certS, ``certH] do
    IO.println s!"{n}: {repr (eqField env n)}"
  -- what the dump's `v` would show for the fake recovery
  let some ci := env.find? ``recoveryFake | pure ()
  IO.println s!"recoveryFake value names: {ci.value?.get!.getUsedConstants}"
  let some ci := env.find? ``recoveryT | pure ()
  IO.println s!"recoveryT type: {ci.type}"
#print axioms recoveryFake
