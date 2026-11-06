/-
Read-only: which predicates theorems assume and nothing ever discharges. A predicate P is discharged if some
declaration reads a theorem assuming P while not itself assuming P, or some theorem concludes P, or a term of
P is built by its constructors. What remains are premises whose laws have no use and no witness in the package.
`lean --run EnvAudit3.lean OUTDIR`
-/
import Lean
open Lean Meta

namespace EnvAudit

def foundation : List Name := [`GenerativeCore, `InquirySufficiency, `RelationalRenewal]
def moduleOf (env : Environment) (n : Name) : Option Name :=
  (env.getModuleIdxFor? n).map fun i => env.header.moduleNames[i.toNat]!
def scopedModule (m : Name) : Bool := (`Becoming).isPrefixOf m || foundation.contains m
def inScope (env : Environment) (n : Name) : Bool :=
  match moduleOf env n with
  | some m => scopedModule m
  | none => false
def shown (n : Name) : String := (privateToUserName n).toString (escape := false)
partial def concl (e : Expr) : Expr :=
  match e with
  | .forallE _ _ b _ => concl b
  | .mdata _ b => concl b
  | _ => e
partial def binders (e : Expr) (acc : Array Expr := #[]) : Array Expr :=
  match e with
  | .forallE _ t b _ => binders b (acc.push t)
  | .mdata _ b => binders b acc
  | _ => acc
partial def endsInProp (e : Expr) : Bool :=
  match e with
  | .forallE _ _ b _ => endsInProp b
  | .mdata _ b => endsInProp b
  | .sort .zero => true
  | _ => false
def written (n : Name) : Bool :=
  let u := privateToUserName n
  !(u.isInternal || u.hasNum)

def run (out : System.FilePath) (env : Environment) : IO Unit := do
  -- the predicates
  let mut preds : Std.HashMap Name Name := {}
  for (n, c) in env.constants.toList do
    if !inScope env n then continue
    if !written n then continue
    match c with
    | .defnInfo _ | .inductInfo _ =>
      if endsInProp c.type && !(isMatcherCore env n) && !(isAuxRecursor env n) then
        preds := preds.insert n (moduleOf env n).get!
    | _ => pure ()
  -- what each theorem assumes, and what is concluded
  let mut assumes : Std.HashMap Name (Array Name) := {}
  let mut assumedCount : Std.HashMap Name Nat := {}
  let mut concluded : Std.HashSet Name := {}
  for (n, c) in env.constants.toList do
    if !inScope env n then continue
    match c with
    | .thmInfo _ =>
      let mut a : Array Name := #[]
      for t in binders c.type do
        for r in t.getUsedConstants do
          if preds.contains r && !a.contains r then a := a.push r
      for r in a do assumedCount := assumedCount.insert r ((assumedCount.getD r 0) + 1)
      if !a.isEmpty then assumes := assumes.insert n a
      for r in (concl c.type).getUsedConstants do
        if preds.contains r then concluded := concluded.insert r
    | _ => pure ()
  -- discharged
  let mut discharged : Std.HashMap Name Name := {}
  let mut ctor : Std.HashSet Name := {}
  for (n, c) in env.constants.toList do
    if !inScope env n then continue
    let some v := c.value? (allowOpaque := true) | continue
    let own : Std.HashSet Name := (binders c.type).foldl (fun acc t => t.getUsedConstants.foldl (·.insert ·) acc) {}
    for r in v.getUsedConstants do
      if let some (.ctorInfo k) := env.find? r then ctor := ctor.insert k.induct
      if let some as := assumes.get? r then
        for p in as do
          if !own.contains p && !discharged.contains p then
            discharged := discharged.insert p n
  let mut rows := ""
  let mut count := 0
  let mut ready := ""
  for (p, m) in preds.toList do
    let times := assumedCount.getD p 0
    if times == 0 then continue
    if concluded.contains p || ctor.contains p then continue
    match discharged.get? p with
    | some d => ready := ready ++ s!"{shown p}\t{times}\t{m}\t{shown d}\n"
    | none =>
      count := count + 1
      rows := rows ++ s!"{shown p}\t{times}\t{m}\n"
  IO.FS.writeFile (out / "never_discharged.tsv") rows
  IO.FS.writeFile (out / "discharged_only_by_use.tsv") ready
  IO.println s!"never discharged: {count}"

end EnvAudit

unsafe def main (args : List String) : IO UInt32 := do
  let out : System.FilePath := (args.headD "out")
  IO.FS.createDirAll out
  initSearchPath (← findSysroot)
  let env ← importModules #[{ module := `Becoming }] {} 0
  EnvAudit.run out env
  return 0
