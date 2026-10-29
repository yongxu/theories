import Becoming.Identity
import Becoming.MapInstances
import Lean
set_option pp.oneline false
open Lean in
#eval show Lean.Elab.Command.CommandElabM Unit from do
  let env ← Lean.getEnv
  for n in [`Becoming.Web.Lineage.cons, `Becoming.Web.activityFrom] do
    IO.println s!"{n}: {if (env.find? n).isSome then "present" else "absent"}"
