import Lean
import Becoming.PairFlow

/-! Which modules the declarations of `Becoming.PairFlow` refer to directly: anything outside
`Init` and the Becoming package (with its foundation) would keep the module from compiling from the
prelude alone, as the checker's prelude-only run requires of the core. -/
open Lean Elab Command in
#eval show CommandElabM Unit from do
  let env ← getEnv
  let mut mods : NameSet := {}
  let mut bad : Array String := #[]
  for (n, ci) in env.constants.toList do
    if (`Becoming.PairFlow).isPrefixOf n then
      for u in ci.getUsedConstantsAsSet.toList do
        match env.getModuleIdxFor? u with
        | some idx =>
          let m := env.header.moduleNames[idx.toNat]!
          mods := mods.insert m
          if !((`Init).isPrefixOf m || (`Becoming).isPrefixOf m) then
            bad := bad.push s!"{n} uses {u} from {m}"
        | none => pure ()
  IO.println s!"modules referenced directly: {mods.toList.length}"
  for m in mods.toList do IO.println s!"  {m}"
  IO.println s!"references outside Init and Becoming: {bad.size}"
  for b in bad do IO.println b
