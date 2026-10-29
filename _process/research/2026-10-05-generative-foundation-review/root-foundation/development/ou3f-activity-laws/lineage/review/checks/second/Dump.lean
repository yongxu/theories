import Becoming.Identity
import Becoming.MapInstances
import Lean

/-! Reviewer's check, not for landing: every constant of `Becoming.Identity` and
`Becoming.MapInstances`, sorted by name, with its kind and its type printed with `pp.all`
(binder names, binder kinds, universes and implicit arguments shown), and the value of each
definition that is not a compiler-made auxiliary. Run against main's build and the tree's;
the two outputs are compared with `diff`. -/

open Lean Meta Elab Command

set_option pp.all true
set_option pp.maxSteps 10000000
set_option format.width 160

def reviewKind : ConstantInfo → String
  | .thmInfo _ => "theorem" | .defnInfo _ => "def" | .axiomInfo _ => "axiom"
  | .opaqueInfo _ => "opaque" | .inductInfo _ => "inductive" | .ctorInfo _ => "ctor"
  | .recInfo _ => "rec" | .quotInfo _ => "quot"

elab "#review_dump " m:ident : command => do
  let env ← getEnv
  let some idx := env.getModuleIdx? m.getId | throwError "no module {m.getId}"
  let data := env.header.moduleData[idx.toNat]!
  let names := data.constNames.qsort (fun a b => toString a < toString b)
  IO.println s!"== module {m.getId}: {names.size} constants"
  for n in names do
    let some ci := env.find? n | continue
    let ty ← liftTermElabM (ppExpr ci.type)
    IO.println s!"{reviewKind ci} {n} : {ty}"
    if let .defnInfo d := ci then
      unless (← liftTermElabM (isMatcher n)) || n.isInternal do
        let v ← liftTermElabM (ppExpr d.value)
        IO.println s!"  := {v}"

#review_dump Becoming.Identity
#review_dump Becoming.MapInstances
