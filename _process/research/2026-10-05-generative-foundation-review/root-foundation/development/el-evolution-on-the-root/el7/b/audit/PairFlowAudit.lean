import Lean
import Becoming.PairFlow

open Lean Elab Command in
#eval show CommandElabM Unit from do
  let env ← getEnv
  let mut names : Array Name := #[]
  for (n, _) in env.constants.toList do
    if (`Becoming.PairFlow).isPrefixOf n then names := names.push n
  let sorted := names.qsort (fun a b => a.toString < b.toString)
  let mut clean := 0
  let mut dirty : Array String := #[]
  for n in sorted do
    let axs ← liftCoreM (Lean.collectAxioms n)
    if axs.isEmpty then clean := clean + 1
    else dirty := dirty.push s!"{n}: {axs}"
  IO.println s!"constants under Becoming.PairFlow: {sorted.size}; empty axiom report: {clean}"
  for d in dirty do IO.println s!"NONEMPTY {d}"
  let thms := sorted.filter fun n => match env.find? n with
    | some (.thmInfo _) => true
    | _ => false
  IO.println s!"theorems: {thms.size}"
  for n in thms do IO.println s!"thm {n}"
