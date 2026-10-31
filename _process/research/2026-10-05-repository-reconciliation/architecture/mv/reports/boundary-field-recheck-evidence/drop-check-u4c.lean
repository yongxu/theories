import Lean
import U4C.Boundary
open Lean Meta

/-- The type with its `i`-th leading binder removed, when that binder is non-dependent. -/
partial def dropBinder : Expr → Nat → Option Expr
  | .mdata _ e, i => dropBinder e i
  | .forallE n d b bi, 0 => if b.hasLooseBVar 0 then none else some (b.lowerLooseBVars 1 1)
  | .forallE n d b bi, i + 1 => (dropBinder b i).map fun b' => .forallE n d b' bi
  | _, _ => none

/-- Every single-binder drop of a type, by index (non-dependent binders only). -/
partial def drops (t : Expr) : List (Nat × Expr) :=
  (List.range 32).filterMap fun i => (dropBinder t i).map (i, ·)

def negated? (t : Expr) : Option Expr :=
  match t.consumeMData with
  | .app (.const ``Not _) p => some p.consumeMData
  | .forallE _ p (.const ``False _) _ => some p
  | _ => none

open Becoming.U4Boundary in
#eval show MetaM Unit from do
  let env ← getEnv
  let pairs := [(``descent_forms_no_dependence, [``descent_forms_no_dependence.needs_given,
      ``descent_forms_no_dependence.needs_inherits, ``descent_forms_no_dependence.needs_undepended]),
    (``outside_leaves_no_offspring, [``outside_leaves_no_offspring.needs_gate,
      ``outside_leaves_no_offspring.needs_descent, ``outside_leaves_no_offspring.needs_outside])]
  for (f, ks) in pairs do
    let some fi := env.find? f | throwError "no {f}"
    for k in ks do
      let some ki := env.find? k | throwError "no {k}"
      let some p := negated? ki.type | IO.println s!"{k}: not a negation"; continue
      let mut hit : List Nat := []
      for (i, d) in drops fi.type do
        if d == p then hit := hit ++ [i]
      let mut dhit : List Nat := []
      for (i, d) in drops fi.type do
        if ← isDefEq d p then dhit := dhit ++ [i]
      IO.println s!"{k}: syntactic drop at {hit}, defeq drop at {dhit}"
