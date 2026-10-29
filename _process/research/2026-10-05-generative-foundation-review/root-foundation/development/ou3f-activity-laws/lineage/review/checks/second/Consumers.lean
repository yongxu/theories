import Becoming.Identity
import Becoming.MapInstances
import Lean

/-! Reviewer's check, not for landing: for every declaration of `Becoming.Identity` and
`Becoming.MapInstances` (compiler-made matchers folded into the declaration that owns them), the
declarations of the two modules that use it. Run against main's build and the tree's, then
compared, to see whether any declaration loses its last consumer in the two modules. -/

open Lean Meta Elab Command

def reviewOwner (n : Name) : Name :=
  if (n.toString.splitOn ".match_").length > 1 || (n.toString.splitOn ".proof_").length > 1 then n.getPrefix else n

elab "#review_consumers" : command => do
  let env ← getEnv
  let mut mine : Array Name := #[]
  for m in [`Becoming.Identity, `Becoming.MapInstances] do
    let some idx := env.getModuleIdx? m | throwError "no module {m}"
    mine := mine ++ env.header.moduleData[idx.toNat]!.constNames
  let set : NameSet := mine.foldl (·.insert ·) {}
  let mut users : Std.HashMap Name NameSet := {}
  for n in mine do
    let some ci := env.find? n | continue
    let cs := ci.type.getUsedConstants ++ ((ci.value? (allowOpaque := true)).map (·.getUsedConstants)).getD #[]
    for c in cs do
      if set.contains c then
        let o := reviewOwner c
        let u := reviewOwner n
        if o != u then
          users := users.insert o ((users.getD o {}).insert u)
  let owners := (mine.map reviewOwner).toList.eraseDups.toArray.qsort (fun a b => toString a < toString b)
  for o in owners do
    if o.isInternal then continue
    let us := (users.getD o {}).toList.map toString |>.toArray.qsort (· < ·)
    IO.println s!"{o} <- {us.toList}"

#review_consumers
