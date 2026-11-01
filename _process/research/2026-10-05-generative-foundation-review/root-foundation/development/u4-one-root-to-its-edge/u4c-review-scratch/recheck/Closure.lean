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

def anchors : List Name := [`Becoming.balance_over_stretch_on, `Becoming.Flow.Balances,
  `Becoming.Flow.BalancesOn, `Becoming.Flow.BalancesBetween, `Becoming.balance_over_stretch]

def report (root : Name) (verbose : Bool := false) : CoreM Unit := do
  let env ← getEnv
  let c := closure env [root]
  let hits := anchors.filter c.contains
  IO.println s!"{root}: closure {c.size}, anchors {hits}"
  if verbose then
    let pkg := c.toList.filter fun n => (`Becoming).isPrefixOf n
    let thms := pkg.filter fun n => match env.find? n with
      | some (.thmInfo _) => true | _ => false
    IO.println s!"  Becoming theorems in closure ({thms.length}): {thms.toArray.qsort (·.toString < ·.toString)}"

#eval report `Becoming.U4cScratch.coming_of_ceasing true
#eval report `Becoming.Listed.coming_of_ceasing
#eval report `Becoming.U4cScratch.«定后前者在前则亡屡者生屡» true
#eval report `Becoming.U4cScratch.across_at
#eval report `Becoming.U4cScratch.balanceFrom_at
#eval report `Becoming.length_le_of_matched
#eval report `Becoming.gaining_of_losing_from
#eval report `Becoming.losing_of_gaining_from
#eval report `Becoming.total_pos
#eval report `Becoming.recurring_accumulates
#eval report `Becoming.Steps.along_hasPred_iff
#eval report `Becoming.distinct_map_on
