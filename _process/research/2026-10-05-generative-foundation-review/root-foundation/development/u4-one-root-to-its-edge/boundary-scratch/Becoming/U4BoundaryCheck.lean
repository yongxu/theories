import Lean
import Becoming.U4Boundary

/-!
# U4, the boundary record (scratch check): the tests of DESIGN-BOUNDARY.md §1.5, run on the forms

A periphery check, not package Lean. It reads the environment and fails (an error) where a test
fails:

* **The name test.** Every constant each form's and countermodel's statement names directly, and
  each hypothesis's definition names in its type or body, is a grammar constant (a «» name or a constant of a `Becoming.Grammar*` module), a
  constant of `Becoming.Prelude`, a constant outside `Becoming`, or, for a form and its
  countermodels, one of the form's own hypotheses.
* **No amounts in a hypothesis.** `Init` holds the numbers, so the name test alone would admit a
  hypothesis on amounts. No hypothesis's definition names `Nat` or its order and arithmetic
  (`LE.le`, `LT.lt`, `HAdd.hAdd`, `HSub.hSub`, `HMul.hMul`) in its type or body.
* **The countermodels' shape, as far as names show it.** Each countermodel's statement names
  every hypothesis of its form but one, and a different one for each.
* **Reach.** Each form's proof does not reach its row; no countermodel's proof reaches its form;
  each bridge's proof reaches its form.

It reports what each statement names, for the review (`../check-run.log`).

`scratch_build.py` cannot build a module importing `Lean`, so this one runs with Lean directly: build
`Becoming.U4Boundary` with `scratch_build.py boundary-scratch Becoming.U4Boundary`, then, in
`boundary-scratch/.build`, run `lean ../Becoming/U4BoundaryCheck.lean` with `LEAN_PATH` set to that
folder and the toolchain's `lib/lean`.
-/

open Lean Meta

namespace Becoming.U4BoundaryCheck

structure Form where
  form : Name
  hypotheses : List Name
  countermodels : List Name
  row : Name
  bridge : Name

def forms : List Form := [
  { form := ``U4Boundary.descent_forms_no_dependence,
    hypotheses := [``U4Boundary.GivenTo, ``U4Boundary.Inherits, ``U4Boundary.UndependedFrom],
    countermodels := [``U4Boundary.descent_forms_no_dependence.needs_given,
      ``U4Boundary.descent_forms_no_dependence.needs_inherits,
      ``U4Boundary.descent_forms_no_dependence.needs_undepended],
    row := ``Flow.no_new_dependence, bridge := ``U4Boundary.no_new_dependence_at_model },
  { form := ``U4Boundary.outside_leaves_no_offspring,
    hypotheses := [``U4Boundary.GivesFrom, ``U4Boundary.ListedWithin, ``U4Boundary.Outside],
    countermodels := [``U4Boundary.outside_leaves_no_offspring.needs_gate,
      ``U4Boundary.outside_leaves_no_offspring.needs_descent,
      ``U4Boundary.outside_leaves_no_offspring.needs_outside],
    row := ``GroupEnding.Flow.all_end, bridge := ``U4Boundary.all_end_at_model }]

def moduleOf (env : Environment) (c : Name) : Name :=
  match env.getModuleIdxFor? c with
  | some i => env.header.moduleNames[i.toNat]!
  | none => env.mainModule

def grammarOrPrelude (env : Environment) (c : Name) : Bool :=
  let m := moduleOf env c
  (c.toString.any (· == '«')) || (`Becoming).isPrefixOf m && ((m.toString.startsWith "Becoming.Grammar") ||
    m == `Becoming.Prelude) || !(`Becoming).isPrefixOf m

/-- The constants a statement names directly; for a hypothesis's definition, its body as well. -/
def named (env : Environment) (n : Name) : MetaM (List Name) := do
  let some ci := env.find? n | throwError "missing {n}"
  let body := match ci with
    | .defnInfo d => d.value.getUsedConstants.toList
    | _ => []
  return ci.type.getUsedConstants.toList ++ body.filter (!ci.type.getUsedConstants.contains ·)

/-- The constants a proof reaches, through the values of `Becoming` constants. -/
partial def reaches (env : Environment) (start target : Name) : Bool := Id.run do
  let mut seen : NameSet := {}
  let mut stack := [start]
  while true do
    match stack with
    | [] => return false
    | n :: rest =>
      stack := rest
      if n == target && n != start then return true
      if seen.contains n then continue
      seen := seen.insert n
      if !(`Becoming).isPrefixOf n then continue
      match env.find? n with
      | some ci =>
        let used := ci.type.getUsedConstants.toList ++ (ci.value?.map (·.getUsedConstants.toList)).getD []
        stack := used ++ stack
      | none => pure ()
  return false

#eval show MetaM Unit from do
  let env ← getEnv
  let mut out := ""
  for f in forms do
    for item in [f.form] ++ f.hypotheses ++ f.countermodels do
      let ns ← named env item
      let bad := ns.filter fun c => !grammarOrPrelude env c && !f.hypotheses.contains c
      out := out ++ s!"{item}: {ns}\n"
      unless bad.isEmpty do throwError "{item} names {bad}"
    for h in f.hypotheses do
      let ns ← named env h
      let amounts := ns.filter fun c => [``Nat, ``LE.le, ``LT.lt, ``HAdd.hAdd, ``HSub.hSub, ``HMul.hMul].contains c
      unless amounts.isEmpty do throwError "{h} names amounts: {amounts}"
    let mut dropped : List Name := []
    for cm in f.countermodels do
      let ns ← named env cm
      match f.hypotheses.filter (!ns.contains ·) with
      | [h] => dropped := h :: dropped
      | hs => throwError "{cm} leaves out {hs}, not one hypothesis"
      if reaches env cm f.form then throwError "{cm} reaches {f.form}"
    unless dropped.length == f.hypotheses.length && f.hypotheses.all dropped.contains do
      throwError "{f.form}: the countermodels do not each drop a different hypothesis"
    if reaches env f.form f.row then throwError "{f.form} reaches {f.row}"
    unless reaches env f.bridge f.form do throwError "{f.bridge} does not reach {f.form}"
  logInfo out

end Becoming.U4BoundaryCheck
