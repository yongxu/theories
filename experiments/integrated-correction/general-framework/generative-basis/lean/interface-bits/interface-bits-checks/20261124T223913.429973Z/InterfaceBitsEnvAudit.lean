import Lean
import InterfaceBits
open Lean Elab Command

#eval show CommandElabM Unit from do
  let env ← getEnv
  let some idx := env.getModuleIdx? `InterfaceBits | throwError "missing module"
  let mut count : Nat := 0
  for (n, _) in env.constants.map₁.toList do
    if env.getModuleIdxFor? n == some idx then
      count := count + 1
      let axs ← liftCoreM <| Lean.collectAxioms n
      let isInst ← liftCoreM <| Lean.Meta.isInstance n
      let dr ← liftCoreM <| findDeclarationRanges? n
      let eqStemImp := match env.getModuleIdxFor? n.getPrefix with | some pidx => pidx != idx | none => false
      IO.println s!"ENV_CONST\t{n}\t{axs.toList}\t{isInst}\t{dr.isSome}\t{eqStemImp}"
      if let some si := getStructureInfo? env n then
        IO.println s!"ENV_STRUCT\t{n}\t{si.fieldNames.toList}"
  IO.println s!"ENV_AUDIT_DONE COUNT={count}"
