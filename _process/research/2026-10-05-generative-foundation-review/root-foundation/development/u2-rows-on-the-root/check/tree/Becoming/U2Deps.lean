import Lean
import Becoming.U2Check

/-!
# Scratch dependency check of the U2 readings (not a landed module)

For each reading: whether its proof reaches its row (through declarations of `Becoming`, not
expanding grammar constants), and which grammar constants its statement names directly. A grammar
constant is one with a «» name or one declared in a module named `Becoming.Grammar*`, as OU3b's
measure recognises them.
-/

open Lean

#eval show CoreM Unit from do
  let env ← getEnv
  let pairs : List (Name × Name) := [
    (`Becoming.U2Check.roles_supported_reading, `Becoming.Web.roles_supported),
    (`Becoming.U2Check.roles_dependent_reading, `Becoming.Web.roles_dependent),
    (`Becoming.U2Check.roles_alive_reading, `Becoming.Web.roles_alive),
    (`Becoming.U2Check.renewingAt_reading, `Becoming.Web.renewingAt_iff_over_all),
    (`Becoming.U2Check.transmits_at_reading, `Becoming.Web.transmits_at_iff),
    (`Becoming.U2Check.transmits_at_one_kind, `Becoming.Web.transmits_at_iff),
    (`Becoming.U2Check.identifies_iff_reading, `Becoming.Limit.identifies_iff_tracks),
    (`Becoming.U2Check.kernel_and_reading, `Becoming.Viability.kernel_and_iff),
    (`Becoming.U2Check.verifiableBy_reading, `Becoming.Ideals.verifiableBy_iff_interior),
    (`Becoming.U2Check.significant_iff_held_reading, `Becoming.Valuation.significant_iff_held),
    (`Becoming.U2Check.significance_undetermined_reading, `Becoming.Web.significance_undetermined),
    (`Becoming.U2Check.only_together_reading, `Becoming.Dependence.Overdetermined.only_together),
    (`Becoming.U2Check.response_not_fixed_reading, `Becoming.ExchangeLaw.response_not_fixed_by_coupling),
    (`Becoming.U2Check.differenceOnlyTogether_reading, `Becoming.Dependence.differenceOnlyTogether_iff),
    (`Becoming.U2Check.not_fixes_reading, `Becoming.Run.not_fixes_of_untaken),
    (`Becoming.U2Check.run_agrees_every_start_reading, `Becoming.SharedCodes.run_agrees_every_start_iff),
    (`Becoming.U2Check.living_on_reaches_reading, `Becoming.Web.living_on_reaches),
    (`Becoming.U2Check.descent_reaches_reading, `Becoming.Flow.descent_reaches),
    (`Becoming.U2Check.unselected_beyond_data_reading, `Becoming.Learning.Training.unselected_beyond_data),
    (`Becoming.U2Check.no_exact_finite_reading_reading, `Becoming.Renewable.no_exact_finite_reading)]
  let isGrammar : Name → Bool := fun n =>
    n.toString.any (· == '«') ||
      match env.getModuleIdxFor? n with
      | some idx => (env.allImportedModuleNames[idx.toNat]!).toString.startsWith "Becoming.Grammar"
      | none => false
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
        if !((`Becoming).isPrefixOf n) || isGrammar n then continue
        match env.find? n with
        | some ci =>
          let used := ci.type.getUsedConstants ++ (ci.value?.map Expr.getUsedConstants).getD #[]
          todo := used.toList ++ todo
        | none => pure ()
    let stated := (info.type.getUsedConstants.filter isGrammar).toList.eraseDups
    logInfo m!"{reading}: uses its row {row}: {usesRow}; grammar terms in the statement: {stated}"
    if !usesRow || stated.isEmpty then failures := failures.push reading.toString
  unless failures.isEmpty do throwError m!"readings failing the check: {failures}"
