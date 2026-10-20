/-
PE2: where `propext` enters each declaration, read from the kernel terms.

This file is the analysis part of a driver; `uses.py` writes the driver as
`import <TARGET>` followed by this text and a `#eval PE2.main` line naming the
declarations and the output file. It proves nothing.

For each declaration it reports:
* `onPropext`: whether its axiom report includes `propext`, computed as Lean's
  `CollectAxioms` does (type, value, constructors), to be compared with the receipt;
* `proof`: whether the declaration is a proof (its type is a proposition);
* for a declaration that is not a proof, every place in its type and value where
  something on `propext` occurs, classified:
  - `proof-arg`: a proof on `propext` given as an argument to a constructor, a quotient
    primitive or a definition that does not eliminate it into data, so reduction never
    inspects it;
  - `eliminated`: a proof on `propext` that is the major premise of an elimination into
    data (a cast `Eq.mpr`/`Eq.mp`/`cast`/`Eq.rec`/…, `Acc.rec` and well-founded recursion,
    `False.elim`, or any recursor of an inductive proposition), so a value is computed
    through it and its reduction can stop there;
  - `to-def`: a proof on `propext` passed to some other definition (reported for reading);
  - `value-ref`: another declaration on `propext` that is not a proof, used as data; it is
    analysed in turn, so the verdict of a declaration is the worst over its occurrences
    and the values it uses;
* for a proof, the constants on `propext` its proof term uses directly, and every value
  on `propext` its statement mentions, with that value's verdict.
-/
import Lean
open Lean Meta

namespace PE2

structure State where
  onPropext : Std.HashMap Name Bool := {}
  verdict : Std.HashMap Name String := {}
  occurrences : Std.HashMap Name (Array Json) := {}
  reach : Std.HashMap (Name × Nat) (Option String) := {}

abbrev M := StateRefT State MetaM

partial def onPropext (c : Name) : M Bool := do
  if c == ``propext then return true
  if let some b := (← get).onPropext[c]? then return b
  modify fun s => { s with onPropext := s.onPropext.insert c false }
  let some ci := (← getEnv).find? c | return false
  let mut cs : Array Name := ci.type.getUsedConstants
  match ci with
  | .defnInfo v => cs := cs ++ v.value.getUsedConstants
  | .thmInfo v => cs := cs ++ v.value.getUsedConstants
  | .opaqueInfo v => cs := cs ++ v.value.getUsedConstants
  | .inductInfo v => cs := cs ++ v.ctors.toArray
  | _ => pure ()
  let mut r := false
  for d in cs do
    if ← onPropext d then
      r := true
      break
  modify fun s => { s with onPropext := s.onPropext.insert c r }
  return r

def exprOnPropext (e : Expr) : M (Array Name) := do
  let mut out := #[]
  for d in e.getUsedConstants do
    if ← onPropext d then out := out.push d
  return out

/-- Casts and eliminations whose proof arguments a reduction must take apart. -/
def eliminators : List Name :=
  [``Eq.mpr, ``Eq.mp, ``cast, ``Eq.rec, ``Eq.ndrec, ``Eq.recOn, ``Eq.casesOn,
   ``HEq.rec, ``HEq.ndrec, ``HEq.ndrecOn, ``HEq.elim, ``HEq.recOn, ``HEq.casesOn,
   ``absurd, ``False.elim, ``False.rec, ``False.casesOn, ``Not.elim,
   ``Acc.rec, ``Acc.recOn, ``Acc.ndrec, ``Acc.ndrecOn, ``WellFounded.fix, ``WellFounded.fixF]

/-- Constants that only carry a proof argument: reduction does not inspect it. -/
def carriers : List Name :=
  [``Quot.lift, ``Quot.ind, ``Quot.rec, ``Quot.recOn, ``Quotient.lift, ``Quotient.lift₂,
   ``Subtype.mk, ``Exists.intro, ``dite, ``ite, ``Decidable.decide, ``decidable_of_iff,
   ``decidable_of_iff', ``Decidable.byCases]

def isPropRecursor (k : Name) : MetaM Bool := do
  let env ← getEnv
  let base := if isAuxRecursor env k || isCasesOnRecursor env k then k.getPrefix else
    match env.find? k with
    | some (.recInfo v) => v.getMajorInduct
    | _ => Name.anonymous
  if base.isAnonymous then return false
  match env.find? base with
  | some (.inductInfo v) =>
    forallTelescopeReducing v.type fun _ s => return s.isProp
  | _ => return false

/-- Where a proof argument goes. -/
inductive Sink where
  | carried (head : Name)
  | eliminated (head : Name)
  | toDef (head : Name) (index : Nat)
  | toLocal
  deriving Inhabited

def Sink.str : Sink → String
  | .carried k => s!"carried by {k}"
  | .eliminated k => s!"eliminated by {k}"
  | .toDef k i => s!"argument {i} of {k}"
  | .toLocal => "argument of a local function"

def sinkOf (f : Expr) (i : Nat) : MetaM Sink := do
  match f with
  | .const k _ =>
    if eliminators.contains k || (← isPropRecursor k) then return .eliminated k
    if carriers.contains k || (← getEnv).isConstructor k then return .carried k
    match (← getEnv).find? k with
    | some (.recInfo _) | some (.quotInfo _) | some (.opaqueInfo _) | some (.axiomInfo _) =>
      return .carried k
    | _ => return .toDef k i
  | _ => return .toLocal

/-- Walk a term in data position: `onProof` sees every maximal proof subterm with its sink,
`onConst` every constant used as data. -/
partial def walk (onProof : Sink → Expr → M Unit) (onConst : Name → M Unit) (e : Expr) : M Unit := do
  match e with
  | .app .. =>
    let f := e.getAppFn
    let args := e.getAppArgs
    walk onProof onConst f
    for h : i in [0:args.size] do
      let a := args[i]
      if ← isProof a then onProof (← sinkOf f i) a
      else walk onProof onConst a
  | .lam n t b bi | .forallE n t b bi =>
    walk onProof onConst t
    withLocalDecl n bi t fun x => walk onProof onConst (b.instantiate1 x)
  | .letE n t v b _ =>
    walk onProof onConst t
    if ← isProof v then onProof (.carried `«let») v
    else walk onProof onConst v
    withLetDecl n t v fun x => walk onProof onConst (b.instantiate1 x)
  | .mdata _ b => walk onProof onConst b
  | .proj _ _ b => walk onProof onConst b
  | .const k _ => onConst k
  | _ => pure ()

/-- Whether a proof given at a sink is taken apart by reduction, with the route if so.
For a definition: whether its parameter at that place reaches, in its body, a proof that is
eliminated (memoised; a parameter still being read counts as not reaching one). -/
partial def reaches (s : Sink) : M (Option String) := do
  match s with
  | .carried _ => return none
  | .eliminated k => return some k.toString
  | .toLocal => return some "a local function (a well-founded recursive call)"
  | .toDef k i =>
    if let some r := (← get).reach[(k, i)]? then return r
    modify fun st => { st with reach := st.reach.insert (k, i) none }
    let some (.defnInfo v) := (← getEnv).find? k | return none
    let sinks ← lambdaTelescope v.value fun xs body => do
      if h : i < xs.size then
        let x := xs[i]
        let found ← IO.mkRef (#[] : Array Sink)
        walk (fun s' p => do if p.containsFVar x.fvarId! then found.modify (·.push s'))
          (fun _ => pure ()) body
        found.get
      else
        return #[Sink.toLocal]
    let mut out := none
    for s' in sinks do
      if let some route ← reaches s' then
        out := some s!"{k} → {route}"
        break
    modify fun st => { st with reach := st.reach.insert (k, i) out }
    return out

def rank : String → Nat
  | "eliminated" => 3
  | "kernel-native" => 2
  | "carried" => 1
  | _ => 0

/-- `Nat` functions the kernel computes on literals itself (GMP), without unfolding their
definitions: a proof inside such a definition is never reached when the arguments are
literals. -/
def kernelNat : List Name :=
  [``Nat.add, ``Nat.sub, ``Nat.mul, ``Nat.div, ``Nat.mod, ``Nat.gcd, ``Nat.beq, ``Nat.ble,
   ``Nat.land, ``Nat.lor, ``Nat.xor, ``Nat.shiftLeft, ``Nat.shiftRight, ``Nat.pow, ``Nat.log2]

def moduleOf (k : Name) : MetaM String := do
  let env ← getEnv
  match env.getModuleIdxFor? k with
  | some i => return (env.header.moduleNames[i.toNat]!).toString
  | none => return "(this file)"

/-- The verdict of a value: `eliminated` if a value is computed through a proof on `propext`
(a proof on `propext` taken apart by reduction, here or in a value it uses), `carried` if every
proof on `propext` in it is only carried, `clean` if it does not depend on `propext`. -/
partial def valueVerdict (c : Name) : M String := do
  if let some v := (← get).verdict[c]? then return v
  if kernelNat.contains c && (← onPropext c) then
    modify fun s => { s with verdict := s.verdict.insert c "kernel-native" }
    return "kernel-native"
  modify fun s => { s with verdict := s.verdict.insert c "clean" }
  let some ci := (← getEnv).find? c | return "clean"
  let occ ← IO.mkRef (#[] : Array Json)
  let worst ← IO.mkRef "clean"
  let note (kind : String) (j : Json) : M Unit := do
    occ.modify (·.push j)
    if rank kind > rank (← worst.get) then worst.set kind
  let onConst (k : Name) : M Unit := do
    if k == ``propext || !(← onPropext k) then return
    let v ← valueVerdict k
    if v != "clean" then
      note v (Json.mkObj [("kind", "value"), ("value", toJson k.toString), ("its_verdict", toJson v)])
  let onProof (s : Sink) (p : Expr) : M Unit := do
    -- A proof is on propext through a proof it uses (propext or a theorem on it), or only
    -- because it mentions a value on propext (in an implicit argument or its statement);
    -- the second is a use of that value, judged as the value.
    let cs ← exprOnPropext p
    let mut pfs := #[]
    for k in cs do
      if k == ``propext then pfs := pfs.push k
      else if let some kci := (← getEnv).find? k then
        if ← isProp kci.type then pfs := pfs.push k else onConst k
    if pfs.isEmpty then return
    let cs := pfs
    let route ← reaches s
    let kind := if route.isSome then "eliminated" else "carried"
    note kind (Json.mkObj [("kind", toJson kind), ("sink", toJson s.str),
      ("route", toJson route), ("via", toJson (cs.toList.take 4 |>.map Name.toString))])
  let body := match ci with
    | .defnInfo v => some v.value
    | .opaqueInfo v => some v.value
    | _ => none
  walk onProof onConst ci.type
  if let some b := body then walk onProof onConst b
  if let .inductInfo v := ci then
    for k in v.ctors do
      if let some cinfo := (← getEnv).find? k then walk onProof onConst cinfo.type
  let v ← worst.get
  let pe ← onPropext c
  let v := if v == "clean" && pe then "carried" else v
  let found ← occ.get
  modify fun s => { s with verdict := s.verdict.insert c v,
                           occurrences := s.occurrences.insert c found }
  return v

def analyse (c : Name) : M Json := do
  let some ci := (← getEnv).find? c | return Json.mkObj [("name", toJson c.toString), ("missing", true)]
  let pe ← onPropext c
  let proof ← isProp ci.type
  let mut fields : List (String × Json) := [("name", toJson c.toString), ("onPropext", toJson pe),
    ("proof", toJson proof), ("kind", toJson (match ci with
      | .thmInfo _ => "theorem" | .defnInfo _ => "def" | .inductInfo _ => "inductive"
      | .ctorInfo _ => "constructor" | .recInfo _ => "recursor" | .opaqueInfo _ => "opaque"
      | _ => "other"))]
  if !pe then return Json.mkObj fields
  if proof then
    let value := match ci with
      | .thmInfo v => some v.value
      | .defnInfo v => some v.value
      | _ => none
    let direct ← match value with
      | some e => exprOnPropext e
      | none => pure #[]
    let usesPropextItself := match value with
      | some e => e.getUsedConstants.contains ``propext
      | none => false
    let mut entries := #[]
    for d in direct do
      if d == ``propext then continue
      let some dci := (← getEnv).find? d | continue
      let isPf ← isProp dci.type
      let mut fs : List (String × Json) := [("name", toJson d.toString), ("proof", toJson isPf),
        ("module", toJson (← moduleOf d))]
      if !isPf then fs := fs ++ [("verdict", toJson (← valueVerdict d))]
      entries := entries.push (Json.mkObj fs)
    let mut statement := #[]
    for d in ← exprOnPropext ci.type do
      let dci := (← getEnv).find? d
      if let some dci := dci then
        if !(← isProp dci.type) then
          statement := statement.push (Json.mkObj [("value", toJson d.toString),
            ("verdict", toJson (← valueVerdict d))])
    fields := fields ++ [("propext_in_term", toJson usesPropextItself),
      ("entries", Json.arr entries), ("statement_values", Json.arr statement)]
  else
    let v ← valueVerdict c
    fields := fields ++ [("verdict", toJson v),
      ("occurrences", Json.arr ((← get).occurrences[c]?.getD #[]))]
  return Json.mkObj fields

/-- A declaration name as the receipts print it (`«…»` quoting allowed). -/
def parseName (s : String) : Name :=
  (Syntax.decodeNameLit ("`" ++ s)).getD s.toName

def main (given : List String) (out : String) : MetaM Unit := do
  let names := given.map parseName
  let (results, s) ← ((names.zip given).mapM fun (p : Name × String) => do
      let (n, g) := p
      let j ← analyse n
      return j.setObjVal! "name" (toJson g)).run {}
  let library := s.verdict.toList.filter (fun (n, v) => v != "clean" && !names.contains n)
  let libraryJson := library.map fun (n, v) => Json.mkObj [("name", toJson n.toString),
    ("verdict", toJson v), ("occurrences", Json.arr (s.occurrences[n]?.getD #[]))]
  IO.FS.writeFile out (Json.mkObj [("declarations", Json.arr results.toArray),
    ("values_reached", Json.arr libraryJson.toArray)]).pretty

end PE2
