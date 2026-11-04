import Lean
{imports}
open Lean Elab Command

#eval show CommandElabM Unit from do
  let env ← getEnv
  for m in [{modules}] do
    let some index := env.getModuleIdx? m | throwError m!"no module {{m}}"
    let mut count := 0
    for (n, _) in env.constants.map₁.toList do
      if env.getModuleIdxFor? n == some index then
        count := count + 1
        let axioms ← liftCoreM <| Lean.collectAxioms n
        if axioms.size > 0 then logInfo m!"AXIOMS {{n}} {{axioms.toList}}"
    logInfo m!"CONSTANTS {{m}} {{count}}"
