import Lean
import Becoming.U4cCases
open Lean Meta

partial def closure (env : Environment) (roots : List Name) : NameSet := Id.run do
  let mut seen : NameSet := {}
  let mut stack := roots
  while !stack.isEmpty do
    match stack with
    | [] => break
    | n :: rest =>
      stack := rest
      if seen.contains n then continue
      seen := seen.insert n
      match env.find? n with
      | none => pure ()
      | some ci =>
        let ts := ci.type.getUsedConstants
        let vs := match ci.value? (allowOpaque := true) with
          | some v => v.getUsedConstants
          | none => #[]
        for c in ts ++ vs do
          if !seen.contains c then stack := c :: stack
  return seen

def movedNames : List Name := [`Becoming.mem_remove, `Becoming.length_le_of_matched, `Becoming.not_not_all,
    `Becoming.gaining_of_losing, `Becoming.losing_of_gaining, `Becoming.recurs_shift,
    `Becoming.recurs_unshift, `Becoming.gaining_of_losing_from, `Becoming.losing_of_gaining_from,
    `Becoming.steps_mem, `Becoming.steps_last, `Becoming.steps_mono, `Becoming.recurring_accumulates,
    `Becoming.pos_of_exceeds, `Becoming.total_pos]
#eval show CoreM Unit from do
  let env ← getEnv
  for n in movedNames do
    let c := closure env [n]
    let mut outside : Array (Name × Name) := #[]
    for m in c.toList do
      if m == n || movedNames.contains m then continue
      match env.getModuleIdxFor? m with
      | some i =>
        let mod := env.header.moduleNames[i.toNat]!
        if (`Becoming).isPrefixOf mod && mod != `Becoming.Prelude then outside := outside.push (m, mod)
      | none => pure ()
    let home := match env.getModuleIdxFor? n with
      | some i => env.header.moduleNames[i.toNat]! | none => `here
    IO.println s!"{n} [{home}]: outside Prelude {outside}"
