import Lean
open Lean

/-! The idioms of BOUNDARY-FIELD.md §3.2 in miniature, with the dump field `eq` it proposes (§3.0).
Run with `lean +leanprover/lean4:v4.29.1 certificate-idiom.lean`; certificate-idiom-wrong.lean holds the cases that must fail. -/

-- The root in miniature: two hypotheses as named definitions over variable relations, and a form F.
def Incl {α : Type} (R S : α → α → Prop) : Prop := ∀ a b, R a b → S a b
def Holds {α : Type} (R : α → α → Prop) (x y : α) : Prop := R x y
theorem form {α : Type} (R S : α → α → Prop) (x y : α) (incl : Incl R S) (holds : Holds R x y) : S x y :=
  incl x y holds

-- A model, and a row stated on it and proved without the form.
def step (n m : Nat) : Prop := m = n + 1
def Clo {α : Type} (R : α → α → Prop) (x y : α) : Prop := x = y ∨ R x y
theorem row (n : Nat) : Clo step n (n + 1) := Or.inr rfl

-- The recovery: the row's statement, proved through the form; the model meets the hypotheses by its own theorem.
theorem step_incl : Incl step (Clo step) := fun _ _ h => Or.inr h
theorem recovery (n : Nat) : Clo step n (n + 1) := form step (Clo step) n (n + 1) step_incl rfl
-- The certificate: Lean accepts it only where the row and the recovery state the same thing.
theorem cert : @row = @recovery := rfl

-- The countermodel for `Incl`, as `H_needed`: at a witness the other hypothesis holds and the conclusion fails, so
-- applying the form to them refutes `Incl` there. The kernel checks that the facts fit the form's other hypotheses
-- and its conclusion.
def wR (_ _ : Unit) : Prop := True
def wS (_ _ : Unit) : Prop := False
theorem w_holds : Holds wR () () := trivial
theorem w_fails : ¬ wS () () := id
theorem incl_needed : ¬ Incl wR wS := fun incl => w_fails (form wR wS () () incl w_holds)

-- Binder kinds are ignored: an implicit and an explicit binder state the same thing.
theorem rowImp {n : Nat} : n = n := rfl
theorem bExp (n : Nat) : n = n := rfl
theorem certKind : @rowImp = @bExp := rfl

-- Universes: a row at `Type u` against a statement at `Type` checks only at `u := 0`; the field says so.
universe u
theorem rowU {S : Type u} (s : S) : s = s := rfl
theorem bAtType {S : Type} (s : S) : s = s := rfl
theorem certAtZero : @rowU.{0} = @bAtType := rfl
theorem bGeneral {S : Type u} (s : S) : s = s := rfl
theorem certGeneral.{v} : @rowU.{v} = @bGeneral.{v} := rfl

-- Definitional equality includes evaluation: a computed statement equals a trivial one.
def twice (n : Nat) : Nat := n + n
theorem rowNum : twice 3 = 6 := rfl
theorem trivialB : 6 = 6 := rfl
theorem certEval : @rowNum = @trivialB := rfl

-- A theorem naming the row and another, equating neither with the other: it checks, and its names are those of a
-- certificate, but it has no `eq` field.
theorem other (n : Nat) : Clo step n n := Or.inl rfl
theorem vacuous : @row = @row ∧ @other = @other := ⟨rfl, rfl⟩

/-- The proposed dump field `eq`: for a theorem whose type, metadata aside, is `@Eq _ (const a us) (const b vs)`,
the pair `[a, b]`, with whether each side is at distinct level parameters of the theorem (its full generality). -/
def eqField (env : Environment) (n : Name) : Option (Name × Name × Bool × Bool) := do
  let some (.thmInfo v) := env.find? n | none
  let t := v.type.consumeMData
  let general (ls : List Level) : Bool := ls.all (·.isParam) && ls.eraseDups.length == ls.length
  match t.getAppFn, t.getAppArgs.map (·.consumeMData) with
  | Expr.const ``Eq _, #[_, Expr.const a us, Expr.const b vs] => some (a, b, general us, general vs)
  | _, _ => none

#eval show CoreM Unit from do
  let env ← getEnv
  for n in [``cert, ``certKind, ``certAtZero, ``certGeneral, ``certEval, ``vacuous] do
    IO.println s!"{n}: {repr (eqField env n)}"

#print axioms cert
#print axioms incl_needed
#print axioms certGeneral
