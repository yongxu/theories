import Lean
import Becoming.U4Boundary

/-!
# U4, the boundary record (scratch check): the tests of DESIGN-BOUNDARY.md §1.5, run on the forms

A periphery check, not package Lean: it imports `Lean`, so it never lands under the package's
`Becoming/`. It reads the environment, and `checkForm` raises an error wherever a test fails.

* **Admitted constants, by module.** A constant is admitted when:
  - it belongs to no package module (an `Init` constant); or
  - its module is `Becoming.Prelude`; or
  - its module is a `Becoming.Grammar*` module and it is a root constant: everything its type and
    value reach is itself of `Init`, the prelude or a `Grammar*` module.

  A «» name declared elsewhere is not admitted. Neither is the foundation (`GenerativeCore`,
  `RelationalRenewal`, `InquirySufficiency`).
* **The hypotheses' names.** Each hypothesis's type and body name only admitted constants. They
  name no amount: no `Nat`, and none of `LE.le`, `LT.lt`, `HAdd.hAdd`, `HSub.hSub`, `HMul.hMul`.
* **The form's telescope.**
  - Its statement names only admitted constants and its hypotheses.
  - Every binder that is not a proposition is implicit.
  - Every propositional binder is an application of one listed hypothesis, and each hypothesis is
    used exactly once.
* **The hypotheses' home.** Each is a definition of the form's module.
* **The countermodel `needs_H`.**
  - Its type is defeq, at reducible transparency, to `¬` of the form's telescope with `H`'s binder
    removed. Binder names and infos are ignored.
  - Its proof does not reach the form.
* **The fit `H_needed`.**
  - Its type is `¬ H w`. Every constant of `w` is admitted or a witness: a definition of the
    form's module that names only admitted constants.
  - Its proof names the form.
  - Its facts are the package's theorems that its proof names besides the form. No fact reaches
    the form or the row.
  - The countermodel's proof names the same facts.
* **The form's proof.** It reaches only admitted constants and constants of its own module. It
  does not reach the row.
* **The recovery.**
  - The certificate's type is `@Row = @Recovery`.
  - The recovery's proof names the form.
  - **The discharge condition.** The recovery meets the form's hypotheses by definitions alone. Its
    proof, through its own auxiliary definitions, uses no theorem but the form and `Init`'s
    projections (`And.left`, `And.right`). Constructors and `rfl` are not theorems. The check computes whether
    the condition holds, and fails unless that matches what the record expects.

`#eval` runs the tests on the two forms and reports, for the review (`../check-run.log`):
- what each statement names;
- each fit's facts;
- whether each recovery meets the discharge condition.

`../controls/U4BoundaryControls.lean` holds the negative controls, each of which must fail
(`../controls-run.log`).

`scratch_build.py` cannot build a module that imports `Lean`. So `../run_check.sh` builds
`Becoming.U4Boundary` with it, then compiles this module and the controls with Lean directly.
-/

open Lean Meta

namespace Becoming.U4BoundaryCheck

structure Hyp where
  hypothesis : Name
  countermodel : Name
  fit : Name
deriving Inhabited

structure Form where
  form : Name
  hypotheses : List Hyp
  row : Name
  recovery : Name
  certificate : Name
  /-- Whether the record expects the recovery to meet the discharge condition. -/
  discharged : Bool
deriving Inhabited

/-- A constant's module; `none` for a constant of `Init` (one the package does not declare), and
the main module for one declared in the file being checked. -/
def moduleOf (env : Environment) (c : Name) : Option Name :=
  match env.getModuleIdxFor? c with
  | some i =>
    let m := env.header.moduleNames[i.toNat]!
    if (`Init).isPrefixOf m || m == `Init then none else some m
  | none => some env.mainModule

def grammarModule (m : Name) : Bool := m.toString.startsWith "Becoming.Grammar"

def rootModule : Option Name → Bool
  | none => true
  | some m => m == `Becoming.Prelude || grammarModule m

/-- The constants a declaration's type and value name. -/
def namesOf (env : Environment) (c : Name) : List Name :=
  match env.find? c with
  | some ci => ci.type.getUsedConstants.toList ++
      ((ci.value? (allowOpaque := true)).map (·.getUsedConstants.toList)).getD []
  | none => []

/-- Everything a constant reaches through types and values, not expanding `Init`. -/
partial def closure (env : Environment) (start : Name) : NameSet := Id.run do
  let mut seen : NameSet := {}
  let mut stack := [start]
  repeat
    match stack with
    | [] => break
    | n :: rest =>
      stack := rest
      if seen.contains n then continue
      seen := seen.insert n
      if (moduleOf env n).isNone then continue
      stack := namesOf env n ++ stack
  return seen

/-- The name test: a constant of `Init` or the prelude, or a root constant of a grammar module. -/
def admitted (env : Environment) (c : Name) : Bool :=
  match moduleOf env c with
  | none => true
  | some m =>
    if m == `Becoming.Prelude then true
    else if grammarModule m then (closure env c).toList.all (rootModule <| moduleOf env ·)
    else false

def amounts : List Name := [``Nat, ``LE.le, ``LT.lt, ``HAdd.hAdd, ``HSub.hSub, ``HMul.hMul]

def isTheorem (env : Environment) (c : Name) : Bool :=
  match env.find? c with
  | some (.thmInfo _) => true
  | _ => false

def isDefinition (env : Environment) (c : Name) : Bool :=
  match env.find? c with
  | some (.defnInfo _) => true
  | _ => false

/-- The theorems a proof uses, through its own auxiliary definitions (those under its name). -/
partial def theoremsUsed (env : Environment) (owner c : Name) : List Name :=
  (namesOf env c).foldl (fun acc n =>
    if owner.isPrefixOf n && n != owner && n != c then acc ++ theoremsUsed env owner n
    else if isTheorem env n then acc ++ [n] else acc) []

def checkForm (f : Form) : MetaM String := do
  let env ← getEnv
  let hyps := f.hypotheses.map (·.hypothesis)
  let home := moduleOf env f.form
  let mut out := ""
  -- The hypotheses: they name admitted constants and no amount.
  for h in hyps do
    let ns := (namesOf env h).eraseDups
    let bad := ns.filter (!admitted env ·)
    unless bad.isEmpty do throwError "the hypothesis {h} names {bad}"
    let amount := ns.filter amounts.contains
    unless amount.isEmpty do throwError "the hypothesis {h} names amounts: {amount}"
    out := out ++ s!"{h}: {ns}\n"
  -- The form's statement and its telescope.
  let formInfo ← getConstInfo f.form
  let stated := formInfo.type.getUsedConstants.toList.eraseDups
  let bad := stated.filter fun c => !admitted env c && !hyps.contains c
  unless bad.isEmpty do throwError "the form {f.form} names {bad}"
  out := out ++ s!"{f.form}: {stated}\n"
  forallTelescope formInfo.type fun xs body => do
    let mut used : List Name := []
    for x in xs do
      let decl ← x.fvarId!.getDecl
      if ← isProp decl.type then
        match decl.type.getAppFn.constName? with
        | some c =>
          unless hyps.contains c do
            throwError "{f.form}: the binder {decl.userName} : {decl.type} is not a listed hypothesis"
          used := used ++ [c]
        | none =>
          throwError "{f.form}: the binder {decl.userName} : {decl.type} is not a listed hypothesis"
      else unless decl.binderInfo.isImplicit do
        throwError "{f.form}: the binder {decl.userName} is explicit and not a proposition"
    unless used.length == hyps.length && hyps.all (fun h => used.count h == 1) do
      throwError "{f.form}: its hypotheses are {used}, not each of {hyps} once"
    for h in f.hypotheses do
      let mut rest := #[]
      for x in xs do
        unless (← x.fvarId!.getDecl).type.getAppFn.constName? == some h.hypothesis do
          rest := rest.push x
      let expected := mkNot (← mkForallFVars rest body)
      let cm ← getConstInfo h.countermodel
      unless ← withReducible (isDefEq expected cm.type) do
        throwError "the countermodel {h.countermodel} is not ¬ {f.form} without {h.hypothesis}"
  -- The hypotheses are the form's own definitions.
  for h in hyps do
    unless isDefinition env h && moduleOf env h == home do
      throwError "the hypothesis {h} is not a definition of {f.form}'s module"
  -- The countermodels and fits.
  for h in f.hypotheses do
    let cm ← getConstInfo h.countermodel
    if (closure env h.countermodel).contains f.form then
      throwError "the countermodel {h.countermodel} reaches {f.form}"
    let fit ← getConstInfo h.fit
    unless fit.type.isAppOfArity ``Not 1 &&
        fit.type.appArg!.getAppFn.constName? == some h.hypothesis do
      throwError "the fit {h.fit} is not ¬ {h.hypothesis} at a witness"
    for w in fit.type.getUsedConstants.toList.eraseDups do
      unless admitted env w || w == h.hypothesis do
        unless isDefinition env w && moduleOf env w == home do
          throwError "the fit {h.fit} names {w}, neither admitted nor a witness of {f.form}'s module"
        let wBad := (namesOf env w).filter (!admitted env ·)
        unless wBad.isEmpty do throwError "the witness {w} names {wBad}"
    let fitNames := namesOf env h.fit
    unless fitNames.contains f.form do throwError "the fit {h.fit} does not apply {f.form}"
    let facts := (fitNames.filter fun c =>
      isTheorem env c && (moduleOf env c).isSome && c != f.form).eraseDups
    for fact in facts do
      let reach := closure env fact
      if reach.contains f.form || reach.contains f.row then
        throwError "the fact {fact} reaches {f.form} or {f.row}"
    let cmFacts := ((namesOf env h.countermodel).filter fun c =>
      isTheorem env c && (moduleOf env c).isSome).eraseDups
    unless facts.all cmFacts.contains && cmFacts.all facts.contains do
      throwError "the countermodel {h.countermodel} uses {cmFacts}, the fit {h.fit} uses {facts}"
    out := out ++ s!"{h.countermodel}: {cm.type.getUsedConstants.toList.eraseDups}\n"
    out := out ++ s!"{h.fit}: {fit.type.getUsedConstants.toList.eraseDups}; facts {facts}\n"
  -- The form's proof: admitted constants and its own module's only.
  for c in (closure env f.form).toList do
    unless rootModule (moduleOf env c) || moduleOf env c == home do
      throwError "the form {f.form}'s proof reaches {c}"
  if (closure env f.form).contains f.row then throwError "the form {f.form} reaches {f.row}"
  -- The recovery, its certificate and the discharge condition.
  let cert ← getConstInfo f.certificate
  unless cert.type.isAppOfArity ``Eq 3 && cert.type.appFn!.appArg!.constName? == some f.row &&
      cert.type.appArg!.constName? == some f.recovery do
    throwError "the certificate {f.certificate} is not @{f.row} = @{f.recovery}"
  unless (namesOf env f.recovery).contains f.form do
    throwError "the recovery {f.recovery} does not apply {f.form}"
  let others := (theoremsUsed env f.recovery f.recovery).eraseDups.filter fun c =>
    c != f.form && !env.isProjectionFn c
  let discharged := others.isEmpty
  unless discharged == f.discharged do
    throwError "the recovery {f.recovery}: the discharge condition {if discharged then "holds" else "fails"}, the record expects it {if f.discharged then "to hold" else "to fail"} (other theorems: {others})"
  out := out ++ s!"{f.recovery}: the discharge condition {if discharged then "holds" else "fails"}; other theorems {others}\n"
  return out

open U4Boundary in
def forms : List Form := [
  { form := ``descent_forms_no_dependence,
    hypotheses := [
      ⟨``GivenTo, ``descent_forms_no_dependence.needs_given,
        ``descent_forms_no_dependence.given_needed⟩,
      ⟨``Inherits, ``descent_forms_no_dependence.needs_inherits,
        ``descent_forms_no_dependence.inherits_needed⟩,
      ⟨``UndependedFrom, ``descent_forms_no_dependence.needs_undepended,
        ``descent_forms_no_dependence.undepended_needed⟩],
    row := ``Flow.no_new_dependence, recovery := ``no_new_dependence_at_model,
    certificate := ``no_new_dependence_certified, discharged := false },
  { form := ``outside_leaves_no_offspring,
    hypotheses := [
      ⟨``GivesFrom, ``outside_leaves_no_offspring.needs_gate,
        ``outside_leaves_no_offspring.gate_needed⟩,
      ⟨``ListedWithin, ``outside_leaves_no_offspring.needs_descent,
        ``outside_leaves_no_offspring.descent_needed⟩,
      ⟨``Outside, ``outside_leaves_no_offspring.needs_outside,
        ``outside_leaves_no_offspring.outside_needed⟩],
    row := ``GroupEnding.Flow.all_end, recovery := ``all_end_at_model,
    certificate := ``all_end_certified, discharged := true }]

#eval show MetaM Unit from do
  let mut out := ""
  for f in forms do
    out := out ++ (← checkForm f)
  logInfo out

end Becoming.U4BoundaryCheck
