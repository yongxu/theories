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

#eval show CoreM Unit from do
  for n in [`Becoming.mem_remove, `Becoming.length_le_of_matched, `Becoming.not_not_all,
    `Becoming.gaining_of_losing, `Becoming.losing_of_gaining, `Becoming.recurs_shift,
    `Becoming.recurs_unshift, `Becoming.gaining_of_losing_from, `Becoming.losing_of_gaining_from,
    `Becoming.steps_mem, `Becoming.steps_last, `Becoming.steps_mono, `Becoming.recurring_accumulates,
    `Becoming.pos_of_exceeds, `Becoming.total_pos, `Becoming.U4cScratch.mem_pairs,
    `Becoming.U4cScratch.pair_mem, `Becoming.U4cScratch.not_decide_iff,
    `Becoming.U4cScratch.coming_of_ceasing, `Becoming.U4cScratch.balanceFrom_at] do
    report n
