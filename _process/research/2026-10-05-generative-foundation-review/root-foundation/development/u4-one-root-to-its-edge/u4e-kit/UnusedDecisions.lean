import Lean
import Becoming.Persistence

/-!
U4e's check (a periphery tool, run by `unused_decisions.py` against compiled modules; the core never imports `Lean`).
For every declaration of `Becoming.Identity` and `Becoming.Persistence`, each binder whose type is a decidability
family under binders (`Decidable`, `DecidablePred`, `DecidableEq`, or a definition unfolding to one): whether the
statement after it depends on it, and whether the proof (or definition body) uses it, as
`DECIDABILITY-INVENTORY.lean` reads them. Prints one line per binder used by neither, then the count.
-/

open Lean Meta

def isDecision (t : Expr) : MetaM Bool := do
  try
    forallTelescopeReducing t fun _ body => return (← whnfD body).isAppOf ``Decidable
  catch _ => return false

def unusedDecisions : MetaM Unit := do
  let env ← getEnv
  let mut count := 0
  let mut binders := 0
  for (n, ci) in env.constants.toList do
    if n.isInternal then continue
    let some m := env.getModuleIdxFor? n | continue
    let mod := env.header.moduleNames[m.toNat]!
    unless mod == `Becoming.Identity || mod == `Becoming.Persistence do continue
    let some v := ci.value? (allowOpaque := true) | continue
    let found ← forallTelescope ci.type fun xs body => do
      let applied := v.beta xs
      let mut out : Array String := #[]
      for i in [0:xs.size] do
        let x := xs[i]!
        let t ← inferType x
        unless ← isDecision t do continue
        let later ← mkForallFVars (xs.extract (i+1) xs.size) body
        let stmt := later.containsFVar x.fvarId!
        let proof := (Lean.collectFVars {} applied).fvarSet.contains x.fvarId!
        let shown ← ppExpr t
        out := out.push (if stmt || proof then "" else s!"{mod} {n} binder {i}: {shown}")
      return out
    binders := binders + found.size
    for line in found do
      unless line.isEmpty do
        IO.println s!"UNUSED {line}"
        count := count + 1
  IO.println s!"{binders} decision binders in Identity and Persistence, {count} used by neither statement nor proof"

#eval unusedDecisions
