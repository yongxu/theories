import Lean
{imports}
open Lean Elab Command

#eval show CommandElabM Unit from do
  let env ← getEnv
  let modules : Array Name := #[{modules}]
  let mut position : Std.HashMap Nat Nat := {{}}
  for i in [0:modules.size] do
    let m := modules[i]!
    let some index := env.getModuleIdx? m | throwError m!"no module {{m}}"
    position := position.insert index.toNat i
  let mut found : Array (Array Name) := Array.replicate modules.size #[]
  for (n, _) in env.constants.map₁.toList do
    if let some index := env.getModuleIdxFor? n then
      if let some i := position[index.toNat]? then
        found := found.modify i (·.push n)
  for i in [0:modules.size] do
    let names := found[i]!
    for n in names do
      let axioms ← liftCoreM <| Lean.collectAxioms n
      if axioms.size > 0 then logInfo m!"AXIOMS {{n}} {{axioms.toList}}"
    logInfo m!"CONSTANTS {{modules[i]!}} {{names.size}}"
