import Lean
import U4C.Boundary
open Lean

/-- The head constant of a value under leading lambdas and metadata. -/
partial def headUnderLams : Expr → Option Name
  | .lam _ _ b _ => headUnderLams b
  | .mdata _ e => headUnderLams e
  | e => match e.getAppFn.consumeMData with
    | .const c _ => some c
    | _ => none

#eval show CoreM Unit from do
  let env ← getEnv
  for n in [``Becoming.U4Boundary.no_new_dependence_at_model, ``Becoming.U4Boundary.all_end_at_model,
            ``Becoming.U4Boundary.descent_forms_no_dependence.needs_given] do
    let some ci := env.find? n | throwError "no {n}"
    IO.println s!"{n}: head {headUnderLams ci.value?.get!}"
