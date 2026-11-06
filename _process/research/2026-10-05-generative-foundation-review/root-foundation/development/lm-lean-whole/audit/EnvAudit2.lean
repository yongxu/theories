/-
Second read-only audit over the compiled package: predicates no theorem ever concludes (premises the
package takes and never establishes, where a law could hold vacuously), and imports a module does not
read. Run with LEAN_PATH at the package's compiled modules: `lean --run EnvAudit2.lean OUTDIR`.
-/
import Lean
open Lean Meta

namespace EnvAudit

def isThm : ConstantInfo → Bool
  | .thmInfo _ => true
  | _ => false

def foundation : List Name := [`GenerativeCore, `InquirySufficiency, `RelationalRenewal]

def moduleOf (env : Environment) (n : Name) : Option Name :=
  (env.getModuleIdxFor? n).map fun i => env.header.moduleNames[i.toNat]!

def scopedModule (m : Name) : Bool := (`Becoming).isPrefixOf m || foundation.contains m

def inScope (env : Environment) (n : Name) : Bool :=
  match moduleOf env n with
  | some m => scopedModule m
  | none => false

def shown (n : Name) : String := (privateToUserName n).toString (escape := false)

def tsv (xs : List String) : String := "\t".intercalate xs ++ "\n"

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

/-- Whether the type's final result is `Prop`. -/
partial def endsInProp (e : Expr) : Bool :=
  match e with
  | .forallE _ _ b _ => endsInProp b
  | .mdata _ b => endsInProp b
  | .sort .zero => true
  | _ => false

/-- Is it a written declaration? -/
def written (n : Name) : Bool :=
  let u := privateToUserName n
  !(u.isInternal || u.hasNum)

def run (out : System.FilePath) : MetaM Unit := do
  let env ← getEnv
  let mut preds : Std.HashMap Name Name := {}
  let mut concluded : Std.HashSet Name := {}
  let mut assumed : Std.HashMap Name Nat := {}
  let mut usedAnywhere : Std.HashSet Name := {}
  let mut ctorUsed : Std.HashSet Name := {}
  let mut moduleUses : Std.HashMap Name (Std.HashSet Name) := {}
  for (n, c) in env.constants.toList do
    if !inScope env n then continue
    let m := (moduleOf env n).get!
    let mut uses : Std.HashSet Name := moduleUses.getD m {}
    for r in c.type.getUsedConstants do
      if let some rm := moduleOf env r then uses := uses.insert rm
      usedAnywhere := usedAnywhere.insert r
    if let some v := c.value? (allowOpaque := true) then
      for r in v.getUsedConstants do
        if let some rm := moduleOf env r then uses := uses.insert rm
        usedAnywhere := usedAnywhere.insert r
        if let some (.ctorInfo k) := env.find? r then ctorUsed := ctorUsed.insert k.induct
    moduleUses := moduleUses.insert m uses
    if written n then
      match c with
      | .defnInfo _ | .inductInfo _ =>
        if endsInProp c.type && !(isMatcherCore env n) && !(isAuxRecursor env n) then
          preds := preds.insert n m
      | _ => pure ()
    if (isThm c) then
      for r in (concl c.type).getUsedConstants do concluded := concluded.insert r
      for t in binders c.type do
        for r in t.getUsedConstants do
          assumed := assumed.insert r ((assumed.getD r 0) + 1)
  let mut unestablished := ""
  let mut count := 0
  for (p, m) in preds.toList do
    if concluded.contains p then continue
    if ctorUsed.contains p then continue
    let times := assumed.getD p 0
    let readByDef := usedAnywhere.contains p
    count := count + 1
    unestablished := unestablished ++ tsv [shown p, toString times, toString readByDef, toString m]
  IO.FS.writeFile (out / "never_concluded.tsv") unestablished
  IO.println s!"predicates no theorem concludes: {count}"
  let mut direct : Std.HashMap Name (Array Name) := {}
  let mut closure : Std.HashMap Name (Std.HashSet Name) := {}
  for md in env.header.moduleData, name in env.header.moduleNames do
    let imps := md.imports.map (·.module)
    direct := direct.insert name imps
    let mut c : Std.HashSet Name := {}
    for i in imps do
      c := c.insert i
      for x in (closure.getD i {}).toList do c := c.insert x
    closure := closure.insert name c
  let mut redundant := ""
  let mut unread := ""
  for name in env.header.moduleNames do
    if !scopedModule name then continue
    if name == `Becoming then continue
    let imps := direct.getD name #[]
    let uses := moduleUses.getD name {}
    for i in imps do
      if !scopedModule i then continue
      let others := imps.filter (· != i)
      let mut otherClosure : Std.HashSet Name := {}
      for o in others do
        otherClosure := otherClosure.insert o
        for x in (closure.getD o {}).toList do otherClosure := otherClosure.insert x
      if otherClosure.contains i then
        redundant := redundant ++ tsv [toString name, toString i]
      else
        let exclusive := ((closure.getD i {}).insert i).toList
        let needed := exclusive.any fun x => uses.contains x && !otherClosure.contains x
        if !needed then
          unread := unread ++ tsv [toString name, toString i]
  IO.FS.writeFile (out / "imports_implied.tsv") redundant
  IO.FS.writeFile (out / "imports_unread.tsv") unread

end EnvAudit

unsafe def main (args : List String) : IO UInt32 := do
  let out : System.FilePath := (args.headD "out")
  IO.FS.createDirAll out
  initSearchPath (← findSysroot)
  let env ← importModules #[{ module := `Becoming }] {} 0
  let core : Core.Context := { fileName := "<audit>", fileMap := default, maxHeartbeats := 0, maxRecDepth := 100000 }
  let state : Core.State := { env }
  let _ ← (EnvAudit.run out).run' {} {} |>.toIO core state
  return 0
