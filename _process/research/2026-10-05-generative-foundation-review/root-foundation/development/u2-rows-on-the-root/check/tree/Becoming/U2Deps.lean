import Lean
import Becoming.U2Check

/-!
# Scratch dependency check of the U2 readings (not a landed module)

A reachability and mention check, its own test and not OU3b's measure. For each reading it reports:
whether its proof reaches its row's declaration (through declarations of `Becoming`, grammar constants
not expanded); the grammar terms its statement names, a grammar term being a «» name other than the
relation type «际»; and every other constant its statement names that is neither a grammar term, nor
one of the readings' own named relations (`Becoming.ModelStatements`), nor a relation of WRT2's or
WRP2's models listed below, nor a constant of Lean's `Init`. That last list is what the reading keeps
in other terms: the row's own notion on the left of a definitional reading, the model's structures
and their data, and supplied parameters' types.
-/

open Lean

#eval show CoreM Unit from do
  let env ← getEnv
  let pairs : List (Name × Name) := [
    (`Becoming.ModelStatements.roles_supported_reading, `Becoming.Web.roles_supported),
    (`Becoming.ModelStatements.roles_dependent_reading, `Becoming.Web.roles_dependent),
    (`Becoming.ModelStatements.roles_alive_reading, `Becoming.Web.roles_alive),
    (`Becoming.ModelStatements.renewingAt_iff_over_all_reading, `Becoming.Web.renewingAt_iff_over_all),
    (`Becoming.ModelStatements.transmits_at_reading, `Becoming.Web.transmits_at_iff),
    (`Becoming.ModelStatements.identifies_iff_reading, `Becoming.Limit.identifies_iff_tracks),
    (`Becoming.ModelStatements.verifiableBy_reading, `Becoming.Ideals.verifiableBy_iff_interior),
    (`Becoming.ModelStatements.significant_iff_held_reading, `Becoming.Valuation.significant_iff_held),
    (`Becoming.ModelStatements.significance_undetermined_reading, `Becoming.Web.significance_undetermined),
    (`Becoming.ModelStatements.only_together_reading, `Becoming.Dependence.Overdetermined.only_together),
    (`Becoming.ModelStatements.response_not_fixed_reading, `Becoming.ExchangeLaw.response_not_fixed_by_coupling),
    (`Becoming.ModelStatements.kernel_and_reading, `Becoming.Viability.kernel_and_iff),
    (`Becoming.ModelStatements.differenceOnlyTogether_reading, `Becoming.Dependence.differenceOnlyTogether_iff),
    (`Becoming.ModelStatements.not_fixes_reading, `Becoming.Run.not_fixes_of_untaken),
    (`Becoming.ModelStatements.run_agrees_every_start_reading, `Becoming.SharedCodes.run_agrees_every_start_iff),
    (`Becoming.ModelStatements.optimum_broken_reading, `Becoming.Web.optimum_broken_iff),
    (`Becoming.ModelStatements.living_on_reaches_reading, `Becoming.Web.living_on_reaches),
    (`Becoming.ModelStatements.descent_reaches_reading, `Becoming.Flow.descent_reaches),
    (`Becoming.ModelStatements.unselected_beyond_data_reading, `Becoming.Learning.Training.unselected_beyond_data),
    (`Becoming.ModelStatements.finite_reading_not_exact, `Becoming.Renewable.no_exact_finite_reading),
    (`Becoming.ModelStatements.renewing_not_closed, `Becoming.Renewable.no_exact_finite_reading)]
  let moduleOf : Name → Option Name := fun n =>
    (env.getModuleIdxFor? n).map fun idx => env.allImportedModuleNames[idx.toNat]!
  let fromInit : Name → Bool := fun n =>
    match moduleOf n with
    | some m => m.getRoot == `Init
    | none => false
  let isGrammarTerm : Name → Bool := fun n => n.toString.any (· == '«') && n != `Becoming.«际»
  let ownRelations : Name → Bool := fun n => (`Becoming.ModelStatements).isPrefixOf n
  let modelRelations : List Name := [`Becoming.World.withinStep, `Becoming.Web.partialIdentity,
    `Becoming.Steps.along, `Becoming.Steps.next, `Becoming.moveRel, `Becoming.sameValue,
    `Becoming.Web.admitted, `Becoming.Web.roles, `Becoming.Steps, `Becoming.«际»]
  let mut failures : Array String := #[]
  for (reading, row) in pairs do
    let some info := env.find? reading | throwError s!"missing {reading}"
    let mut seen : NameSet := {}
    let mut todo : List Name := [reading]
    let mut usesRow := false
    let mut fuel := 200000
    while fuel > 0 do
      fuel := fuel - 1
      match todo with
      | [] => fuel := 0
      | n :: rest =>
        todo := rest
        if seen.contains n then continue
        seen := seen.insert n
        if n == row then usesRow := true
        if !((`Becoming).isPrefixOf n) || isGrammarTerm n then continue
        match env.find? n with
        | some ci =>
          let used := ci.type.getUsedConstants ++ (ci.value?.map Expr.getUsedConstants).getD #[]
          todo := used.toList ++ todo
        | none => pure ()
    let stated := info.type.getUsedConstants.toList.eraseDups
    let grammar := stated.filter isGrammarTerm
    let other := stated.filter fun n => !(isGrammarTerm n) && !(ownRelations n) &&
      !(modelRelations.contains n) && !(fromInit n)
    logInfo m!"{reading.getString!} | row reached: {usesRow} | grammar terms: {grammar} | other terms: {other}"
    if !usesRow || grammar.isEmpty then failures := failures.push reading.toString
  unless failures.isEmpty do throwError m!"readings failing the check: {failures}"
