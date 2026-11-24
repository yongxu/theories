import Lean
import MovingFeatureCone
open Lean Elab Command

#eval show CommandElabM Unit from do
  let env ← getEnv
  let some idx := env.getModuleIdx? `MovingFeatureCone | throwError "missing module"
  let mut count : Nat := 0
  for (n, _) in env.constants.map₁.toList do
    if env.getModuleIdxFor? n == some idx then
      count := count + 1
      let axs ← liftCoreM <| Lean.collectAxioms n
      IO.println s!"ENV_CONST\t{n}\t{axs.toList}"
  IO.println s!"ENV_AUDIT_DONE COUNT={count}"
