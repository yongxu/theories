import Lean
import RTest.RT
open Lean

/-!
# Theorem-level dependencies of the Becoming spine run

Run by `THEOREM-CONNECTIVITY.py` against the spine's compiled modules restored from the
checker's cache; it reads the environment and declares nothing.

Every constant of every tracked module (the modules of the spine run: the foundation and the core,
with a bridge and the modules it imports were there one; that is, every module not rooted
at `Init`, `Std`, `Lean` or `Lake`) is written as one JSON line to the file named by `THEOREM_CONNECTIVITY_OUT`:
its name `n`, module `m`, kind `k`, the tracked constants its type uses `t`, and `v`, the tracked
constants its value uses (for an inductive, its constructors; for a constructor, its inductive).

Two further fields since R32 (20 October 2026):
- `f`, for a theorem that is a pure forwarder: the theorem of the run its whole proof applies. The
  proof, under at most as many binders as the theorem's type has leading foralls, is that theorem
  applied to arguments in which every explicit argument is one of those binders and no argument
  names a closed value of the run (a witness model, a constructor without arguments) or a literal;
  `fk` is `pure`, or `projection` where the application is under `Iff.mp` or `Iff.mpr` (applied
  to a binder or to nothing), `Iff.symm`, `Eq.symm` or `Ne.symm`.
- `g`, for a definition, opaque, inductive or constructor: how many of its type's leading binders
  range over a sort (its type parameters); `cv` where it is a closed value of the run.
- `w`, for a theorem's type or a definition's value: the heads of the laws given to the
  determined-law vocabulary (`Becoming.Law.*`, `Assurance.ofMap`, `Assurance.ofPartial`), the
  first explicit argument of each such application (under its own binders).
-/

/-- Modules supplied by the toolchain, not by the run. -/
def toolchainRoots : List Name := [`Init, `Std, `Lean, `Lake]

/-- Strip leading lambdas and metadata, counting the binders. -/
partial def stripLams : Expr → Nat → Expr × Nat
  | .lam _ _ b _, k => stripLams b (k + 1)
  | .mdata _ e, k => stripLams e k
  | e, k => (e, k)

/-- The binder infos of a type's leading foralls. -/
partial def binderInfos : Expr → Array BinderInfo → Array BinderInfo
  | .forallE _ _ b bi, acc => binderInfos b (acc.push bi)
  | .mdata _ e, acc => binderInfos e acc
  | _, acc => acc

/-- A closed value of the run: a tracked definition, opaque or constructor whose type is neither
a function type nor a sort. -/
def closedValue (env : Environment) (home : Std.HashMap Name Name) (c : Name) : Bool :=
  home.contains c && match env.find? c with
    | some (.defnInfo v) => !v.type.isForall && !v.type.isSort
    | some (.opaqueInfo v) => !v.type.isForall && !v.type.isSort
    | some (.ctorInfo v) => !v.type.isForall && !v.type.isSort
    | _ => false

/-- Whether an expression names a closed value of the run or a literal. -/
def namesWitness (env : Environment) (home : Std.HashMap Name Name) (e : Expr) : Bool :=
  (e.find? fun x => match x with
    | .lit _ => true
    | .const c _ => closedValue env home c
    | _ => false).isSome

/-- `e` as a tracked theorem other than `self` applied to arguments in which every explicit argument is
a bound variable and none names a closed value of the run or a literal: that theorem. -/
def appliedTheorem (env : Environment) (home : Std.HashMap Name Name) (self : Name) (e : Expr) :
    Option Name :=
  match e.getAppFn with
  | .const g _ =>
    if g == self || !home.contains g then none else
    match env.find? g with
    | some (.thmInfo v) =>
      let infos := binderInfos v.type #[]
      let args := e.getAppArgs
      if args.size > infos.size then none else
      let ok := (List.range args.size).all fun i =>
        let a := args[i]!
        !namesWitness env home a && (!infos[i]!.isExplicit || a.isBVar)
      if ok then some g else none
    | _ => none
  | _ => none

/-- The theorem a proof forwards to, if it is a pure forwarder (see the module doc): under at most
as many binders as the theorem's type has leading foralls, its proof is `appliedTheorem`, or that
under `Iff.mp`/`Iff.mpr` (applied to a bound variable or to nothing) or under a `symm`. -/
def forwardTarget (env : Environment) (home : Std.HashMap Name Name) (self : Name) (type value : Expr) :
    Option (Name × String) :=
  let (body, k) := stripLams value 0
  if k > (binderInfos type #[]).size then none else
  let args := body.getAppArgs
  match body.getAppFn with
  | .const c _ =>
    if (c == ``Iff.mp || c == ``Iff.mpr) && (args.size == 3 || (args.size == 4 && args[3]!.isBVar)) then
      (appliedTheorem env home self (stripLams args[2]! 0).1).map (·, "projection")
    else if (c == ``Iff.symm || c == ``Eq.symm || c == ``Ne.symm) && args.size > 0 then
      (appliedTheorem env home self args.back!).map (·, "projection")
    else (appliedTheorem env home self body).map (·, "pure")
  | _ => none

/-- The number of a type's leading binders whose domain is a sort (its type parameters). -/
partial def sortBinders : Expr → Nat
  | .forallE _ d b _ => (if d.isSort then 1 else 0) + sortBinders b
  | .mdata _ e => sortBinders e
  | _ => 0

/-- Every application node of an expression. -/
partial def applications (e : Expr) (acc : Array Expr) : Array Expr :=
  match e with
  | .app f a => applications a (applications f (acc.push e))
  | .lam _ d b _ => applications b (applications d acc)
  | .forallE _ d b _ => applications b (applications d acc)
  | .letE _ t v b _ => applications b (applications v (applications t acc))
  | .mdata _ x => applications x acc
  | .proj _ _ x => applications x acc
  | _ => acc

/-- The heads of the laws given to the determined-law vocabulary in an expression. -/
def lawHeads (env : Environment) (e : Expr) : Array Name := Id.run do
  let mut out : Array Name := #[]
  for x in applications e #[] do
    match x.getAppFn with
    | .const c _ =>
      if (`Becoming.Law).isPrefixOf c || c == `Becoming.Assurance.ofMap || c == `Becoming.Assurance.ofPartial then
        match env.find? c with
        | some ci =>
          let infos := binderInfos ci.type #[]
          let args := x.getAppArgs
          match (List.range (min args.size infos.size)).find? (fun i => infos[i]!.isExplicit) with
          | some i =>
            match (stripLams args[i]! 0).1.getAppFn with
            | .const d _ => if !out.contains d then out := out.push d
            | _ => pure ()
          | none => pure ()
        | none => pure ()
    | _ => pure ()
  return out


def eqField (env : Environment) (n : Name) : Option (Name × Name × Bool × Bool) := do
  let some (.thmInfo v) := env.find? n | none
  let t := v.type.consumeMData
  let general (ls : List Level) : Bool := ls.all (·.isParam) && ls.eraseDups.length == ls.length
  match t.getAppFn, t.getAppArgs.map (·.consumeMData) with
  | Expr.const ``Eq _, #[_, Expr.const a us, Expr.const b vs] => some (a, b, general us, general vs)
  | _, _ => none

#eval show CoreM Unit from do
  let env ← getEnv
  let some out ← IO.getEnv "THEOREM_CONNECTIVITY_OUT"
    | throwError "THEOREM_CONNECTIVITY_OUT is not set"
  let mut home : Std.HashMap Name Name := {}
  let mut idxs : Array Nat := #[]
  for i in [0:env.header.moduleNames.size] do
    let m := env.header.moduleNames[i]!
    if !toolchainRoots.contains m.getRoot then
      idxs := idxs.push i
      for n in env.header.moduleData[i]!.constNames do
        home := home.insert n m
  let keep (ns : Array Name) : Array Json :=
    (ns.filter (fun n => home.contains n)).map (fun n => toJson n.toString)
  IO.FS.withFile out .write fun h => do
    for i in idxs do
      let m := env.header.moduleNames[i]!
      for ci in env.header.moduleData[i]!.constants do
        let (kind, val) : String × Array Name := match ci with
          | .thmInfo v => ("thm", v.value.getUsedConstants)
          | .defnInfo v => ("def", v.value.getUsedConstants)
          | .opaqueInfo v => ("opaque", v.value.getUsedConstants)
          | .inductInfo v => ("ind", v.ctors.toArray)
          | .ctorInfo v => ("ctor", #[v.induct])
          | .recInfo _ => ("rec", #[])
          | .axiomInfo _ => ("axiom", #[])
          | .quotInfo _ => ("quot", #[])
        let mut fields := [("n", toJson ci.name.toString), ("m", toJson m.toString),
          ("k", toJson kind), ("t", Json.arr (keep ci.type.getUsedConstants)),
          ("v", Json.arr (keep val))]
        match ci with
        | .thmInfo v =>
          if let some (g, fk) := forwardTarget env home ci.name v.type v.value then
            fields := fields ++ [("f", toJson g.toString), ("fk", toJson fk)]
          let heads := lawHeads env ci.type
          if !heads.isEmpty then
            fields := fields ++ [("w", Json.arr (heads.map (toJson ·.toString)))]
        | .defnInfo v =>
          let heads := lawHeads env v.value
          if !heads.isEmpty then
            fields := fields ++ [("w", Json.arr (heads.map (toJson ·.toString)))]
        | _ => pure ()
        match ci with
        | .defnInfo _ | .opaqueInfo _ | .inductInfo _ | .ctorInfo _ =>
          fields := fields ++ [("g", toJson (sortBinders ci.type))]
          if closedValue env home ci.name then fields := fields ++ [("cv", toJson true)]
        | _ => pure ()
        if let some (a, b, ga, gb) := eqField env ci.name then
          fields := fields ++ [("eq", Json.arr #[toJson a.toString, toJson b.toString]), ("eqg", Json.arr #[toJson ga, toJson gb])]
        let initT := ci.type.getUsedConstants.filter (fun n => !home.contains n)
        let initV := (ci.value?.map (·.getUsedConstants)).getD #[] |>.filter (fun n => !home.contains n)
        fields := fields ++ [("it", Json.arr (initT.map (toJson ·.toString))), ("iv", Json.arr (initV.map (toJson ·.toString)))]
        h.putStrLn (Json.mkObj fields).compress
  IO.println s!"tracked modules {idxs.size}"
