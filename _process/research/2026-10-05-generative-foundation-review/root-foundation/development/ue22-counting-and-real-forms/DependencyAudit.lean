import FreeEnergyReals

/-! Dependency audit for UE22 (kept as evidence; run against FreeEnergyReals compiled with the periphery toolchain).
For each theorem joining the counting form to the real form: whether its proof reaches the core's counting laws, and
whether it reaches UE17's Gibbs argument (`surprisal_le_freeEnergy`, `term_le`, `term_eq_iff`, `term_eq_iff_of_pos`,
`freeEnergy_eq_surprisal_iff`, `freeEnergy_eq_record_surprisal_iff`) or Mathlib's `log x ≤ x − 1` lemmas. Theorem bodies
are read with `allowOpaque` (in this Lean, `ConstantInfo.value?` returns a theorem's value only with that flag); an
unknown target stops the run, and `surprisal_le_freeEnergy` is the positive control.

Every statement about Mathlib's `Real.log` reaches `Real.add_one_le_exp` (`x + 1 ≤ exp x`, which is `log y ≤ y − 1`),
through the definition of `Real.log` as the inverse of `exp` (`Real.expOrderIso`). The second pass leaves that
definition unexpanded (`Real.log` and `Real.expOrderIso` as stop nodes): there the join's theorems reach neither
`Real.add_one_le_exp` nor `Real.add_one_lt_exp`, while the positive control reaches both. -/
open Lean

/-- Every constant reachable from `root` through declaration values and types, the constants in `stop` not
expanded; with the empty set it is the plain reach. -/
partial def reachStop (env : Environment) (stop : NameSet) (root : Name) : NameSet := Id.run do
  let mut seen : NameSet := {}
  let mut todo : List Name := [root]
  while !todo.isEmpty do
    match todo with
    | [] => pure ()
    | c :: rest =>
      todo := rest
      if seen.contains c then continue
      seen := seen.insert c
      if stop.contains c then continue
      match env.find? c with
      | none => pure ()
      | some info =>
        let used := info.type.getUsedConstants ++
          ((info.value? (allowOpaque := true)).map (·.getUsedConstants) |>.getD #[])
        for u in used do
          if !seen.contains u then todo := u :: todo
  return seen

def logDefinition : NameSet := ({} : NameSet).insert `Real.log |>.insert `Real.expOrderIso

def report (pass : String) (stop : NameSet) (root : Name) (targets : List Name) : CoreM Unit := do
  let env ← getEnv
  unless env.contains root do throwError s!"unknown root {root}"
  for t in targets do
    unless env.contains t do throwError s!"unknown target {t}"
  let r := reachStop env stop root
  for t in targets do
    IO.println s!"[{pass}] {root} uses {t}: {r.contains t}"

def gibbs : List Name :=
  [`Becoming.FreeEnergy.surprisal_le_freeEnergy, `Becoming.FreeEnergy.term_le, `Becoming.FreeEnergy.term_eq_iff,
   `Becoming.FreeEnergy.term_eq_iff_of_pos, `Becoming.FreeEnergy.freeEnergy_eq_surprisal_iff,
   `Becoming.FreeEnergy.freeEnergy_eq_record_surprisal_iff, `Real.log_le_sub_one_of_pos,
   `Real.log_lt_sub_one_of_pos]

def expBounds : List Name := [`Real.add_one_le_exp, `Real.add_one_lt_exp]

def joins : List (Name × List Name) :=
  [(`Becoming.FreeEnergy.surprisal_le_freeEnergy_of_counts, [`Becoming.FreeEnergyCounting.bound]),
   (`Becoming.FreeEnergy.freeEnergy_eq_surprisal_iff_of_counts, [`Becoming.FreeEnergyCounting.bound_eq_iff]),
   (`Becoming.FreeEnergy.surprisal_lt_freeEnergy_of_counts,
     [`Becoming.FreeEnergyCounting.bound_lt_of_not_proportional]),
   (`Becoming.FreeEnergy.surprisal_le_freeEnergy_iff_bound, [`Becoming.FreeEnergyCounting.bound]),
   (`Becoming.FreeEnergy.gap_counts, [`Becoming.FreeEnergyCounting.bound]),
   (`Becoming.FreeEnergy.gap_counts_given_record,
     [`Becoming.FreeEnergyCounting.record_total, `Becoming.FreeEnergy.jointShare_toReal]),
   (`Becoming.FreeEnergy.record_surprisal_le_freeEnergy_of_counts,
     [`Becoming.FreeEnergyCounting.bound_given_record]),
   (`Becoming.FreeEnergy.record_surprisal_lt_freeEnergy_of_counts,
     [`Becoming.FreeEnergyCounting.given_record_eq_iff_share]),
   (`Becoming.FreeEnergy.freeEnergy_eq_record_surprisal_iff_of_counts,
     [`Becoming.FreeEnergyCounting.given_record_eq_iff_share]),
   (`Becoming.FreeEnergy.freeEnergy_eq_record_surprisal_iff_toReal_of_counts,
     [`Becoming.FreeEnergyCounting.given_record_eq_iff_share, `Becoming.ConditionalWeights.whole_restrict]),
   (`Becoming.FreeEnergy.divergence_counts, [`Becoming.FreeEnergy.freeEnergy_eq_divergence_add_surprisal]),
   (`Becoming.FreeEnergy.proportional_iff_posterior, [])]

-- the positive control: UE17's bound reaches its own argument, in full
#eval report "plain" {} `Becoming.FreeEnergy.surprisal_le_freeEnergy
  [`Becoming.FreeEnergy.term_le, `Real.log_le_sub_one_of_pos]
#eval report "log unexpanded" logDefinition `Becoming.FreeEnergy.surprisal_le_freeEnergy
  ([`Becoming.FreeEnergy.term_le, `Real.log_le_sub_one_of_pos] ++ expBounds)
-- the join: the core's laws it reads, UE17's argument it does not, and the exponential bounds
#eval show CoreM Unit from do
  for (root, core) in joins do
    report "plain" {} root (core ++ gibbs ++ expBounds)
#eval show CoreM Unit from do
  for (root, _) in joins do
    report "log unexpanded" logDefinition root expBounds
