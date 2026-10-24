import Lean
import Becoming
open Lean

/-!
Supplement to `THEOREM-CONNECTIVITY-DUMP.lean` for the dependency audit (plan §9.1): for every
tracked constant, the structures named by primitive projection nodes (`Expr.proj`) in its type
`pt` and value `pv`, with the field index, as `Struct#i`. `getUsedConstants` does not see these
nodes. Reads the environment, declares nothing.
-/

def toolchainRoots : List Name := [`Init, `Std, `Lean, `Lake]

partial def projs (e : Expr) : StateM (Std.HashSet String) Unit := do
  match e with
  | .proj s i b => modify (·.insert s!"{s}#{i}"); projs b
  | .app f a => projs f; projs a
  | .lam _ t b _ => projs t; projs b
  | .forallE _ t b _ => projs t; projs b
  | .letE _ t v b _ => projs t; projs v; projs b
  | .mdata _ b => projs b
  | _ => pure ()

def collect (e : Expr) : Array Json :=
  ((projs e).run {}).2.toArray.qsort (· < ·) |>.map toJson

#eval show CoreM Unit from do
  let env ← getEnv
  let some out ← IO.getEnv "AUDIT_PROJ_OUT" | throwError "AUDIT_PROJ_OUT is not set"
  IO.FS.withFile out .write fun h => do
    for i in [0:env.header.moduleNames.size] do
      let m := env.header.moduleNames[i]!
      if toolchainRoots.contains m.getRoot then continue
      for ci in env.header.moduleData[i]!.constants do
        let pt := collect ci.type
        let pv := match ci.value? (allowOpaque := true) with
          | some v => collect v
          | none => #[]
        if !pt.isEmpty || !pv.isEmpty then
          h.putStrLn (Json.mkObj [("n", toJson ci.name.toString), ("pt", Json.arr pt), ("pv", Json.arr pv)]).compress
