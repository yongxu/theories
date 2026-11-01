import Lean
import Becoming.U4cCases
open Lean Meta

partial def closure (env : Environment) (roots : List Name) : NameSet := Id.run do
  let mut seen : NameSet := {}
  let mut stack := roots
  while !stack.isEmpty do
    match stack with
    | [] => break
    | n :: rest =>
      stack := rest
      if seen.contains n then continue
      seen := seen.insert n
      match env.find? n with
      | none => pure ()
      | some ci =>
        let ts := ci.type.getUsedConstants
        let vs := match ci.value? (allowOpaque := true) with
          | some v => v.getUsedConstants
          | none => #[]
        for c in ts ++ vs do
          if !seen.contains c then stack := c :: stack
  return seen

#eval show CoreM Unit from do
  let env ← getEnv
  let c := closure env [`Becoming.U4cScratch.balanceFrom_at]
  IO.println s!"{[`Becoming.mark_le_total, `Becoming.total_le_mark, `Becoming.total_swap].map c.contains}"
  let c2 := closure env [`Becoming.U4cScratch.coming_of_ceasing]
  IO.println s!"{[`Becoming.Listed.over_stretch, `Becoming.Listed.coming_iff_excess, `Becoming.recurring_accumulates, `Becoming.U4cScratch.recurring_accumulates].map c2.contains}"
