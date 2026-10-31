import Lean

/-!
# The boundary check: standing 2 of U4's edge, tested on terms

MV's boundary field (BOUNDARY-FIELD.md) records, for a central declaration "on the root under a stated
hypothesis", a form F on the root, F's hypotheses with a countermodel and a fit for each, and the row recovered
through F with a certificate. The constants dump holds names, not terms, so `master_laws.py` runs this check in
the environment of the core run, restored from the checker's cache. It is U4's scratch check
(`U4BoundaryCheck.lean`), generalized to read its entries from JSON and to report every failure of every entry
instead of raising the first.

**Running it.** The runner writes the imports of the modules holding the entries' declarations after `import Lean`,
sets `LEAN_PATH` to the restored modules and runs Lean on this file. `BOUNDARY_CHECK_IN` names the input, a JSON
object:

```
{"entries": [{"row": "…", "form": "…",
              "hypotheses": [{"hypothesis": "…", "countermodel": "…", "fit": "…"}],
              "recovery": "…", "certificate": "…", "bridges": ["…"]}],
 "names": ["…"], "equivalences": ["…"], "generated": ["…"]}
```

`bridges`, `names`, `equivalences` and `generated` may be left out. Names are written as Lean prints them
(`Becoming.«际»`). The output, written to `BOUNDARY_CHECK_OUT`, gives for each entry its row, form, whether it passed,
its failures, and what the review reads: the names F's statement and each hypothesis use, each fit's facts, and the
theorems the recovery uses. For each of `names`, it gives whether the name test admits it (`admitted`), and for each of
`equivalences`, whether it is a theorem stating an equivalence (`equivalence`, as test 9 reads it): the derived rows'
bridges are checked there. For each of `generated`, it gives whether the walk takes it for a generated auxiliary
(`generated`), and the kind of it and of each name before it (`kinds`, `""` for none, `opaque` apart from `def`, as the
dump writes them). boundary.py takes from these the kinds of names the dump lacks (a declaration of `Init`, whose
equation lemma Lean realizes in the package module that needs it), and the tests hold this file's copy of boundary.py's
rule to it on the dump's kinds. A hygienic name cannot be listed, since `String.toName` does not read macro scopes.
Malformed input is an error; a failed test never is.

**The name test.** A constant is admitted when:
- it is of `Init` (module `Init` or `Init.*`); `Lean.*` and `Std.*` are not admitted; or
- its module is `Becoming.Prelude`; or
- its module is a `Becoming.Grammar*` module and it is a root constant: everything its type and value reach is of
  `Init`, the prelude or a `Grammar*` module.

**The tests.** For each entry, in order:
1. Every declaration named is in the environment: the row, F, the recovery, the certificate, the countermodels,
   the fits and the bridges as theorems, the hypotheses as definitions. Hypotheses, countermodels and fits are
   each distinct, and the row, F and the recovery are three.
2. **The hypotheses.** Each is a definition of F's module. Its type and body name only admitted constants. No
   constant they reach is an amount: `Nat`, `LE.le`, `LT.lt`, `HAdd.hAdd`, `HSub.hSub`, `HMul.hMul`. Reaching
   is through the package's constants, so an amount behind a prelude definition counts.
3. **F's statement.**
   - It names only admitted constants and its hypotheses.
   - It, or a hypothesis it applies, names `«际»` or another «» term of the root. This excludes only forms free of
     relations.
   - Nothing it reaches is a closed value of the package: a definition, opaque or constructor whose type is
     neither a function type nor a sort (the dump's `cv`).
   - Every binder that is not a proposition is implicit. Every propositional binder is an application of one
     listed hypothesis, and each hypothesis is used exactly once.
4. **The countermodel `needs_H`.**
   - Its type is defeq, at reducible transparency, to `¬` of F's telescope with `H`'s binder removed. Binder names
     and infos are ignored.
   - Its proof reaches neither F nor the row.
5. **The fit `H_needed`.**
   - Its type is `¬ H w`. Every constant of `w` is admitted, or a witness: a definition of F's module naming only
     admitted constants.
   - Its proof is `fun h => …`, and applies F with `h` among F's arguments.
   - Its facts are the package's proofs its proof uses besides F, found as in test 9, so from its value alone and
     not from `¬ H w`. No fact reaches F or the row. The countermodel's proof uses the same facts.
6. **F's proof.** It reaches only constants of `Init`, the prelude, `Grammar*` modules and F's own module. It
   does not reach the row.
7. **The certificate.** Its type is `@Row = @Recovery`, in either order. The row is at distinct universe
   parameters of the certificate, so the recovery states the row at its full generality.
8. **The recovery.** Under its leading binders, its proof is F applied.
9. **The discharge condition.** The recovery meets F's hypotheses from the row's own by definitions alone.
   - Its proof uses no proof but F, the declared bridges and projections (`And.left`, `Iff.mp`, …). A proof is a
     theorem, or a definition or opaque of the package whose type is a proposition. The proofs it uses are those
     its value and its own auxiliary definitions name at term positions, outside binder types and `∀`, and the
     package's proofs inside every definition of the package they reach, so a fact held in a definition, or
     carried by a model's data, counts. An auxiliary Lean generated (BOUNDARY-FIELD §3.0: a name Lean gives such an
     auxiliary, under a declaration of the kind Lean gives it for, such as the `_proof_N` of a termination proof, a
     `decide`, a derived instance or a structure's default) is walked through, not collected; but another
     declaration's lifted proof (`_proof_N`) that the recovery names itself is collected, being a fact. Constructors
     and `rfl` are not proofs, and `Init`'s proofs inside a definition are not counted, so an `Init` proof carried by
     a model's data is left to the review. Every other proof counts, so a recovery through a package proof that
     carries no fact (a package lemma in a termination proof, a package instance of a class of propositions) fails:
     the check fails closed.
   - Each bridge the recovery uses is an equivalence: under its binders, an `Iff`, or an `Eq` between
     propositions, predicates or relations (an `Eq` at a type of values, `size = 0`, is not one).
   - The bridges are a closed set: each bridge's proof uses no theorem but admitted ones, other bridges and
     projections, and each bridge is used by the recovery or by another bridge.

The kernel has checked every declaration, so the certificate's statement holding is the kernel's verdict that the
recovery states the row. What a review still reads: that the hypotheses are the row's relational content, and that
each principal bridge adds no hypothesis the row lacks. `tools/research/tests/test_boundary.py` (TheLeanCheck) runs it on
stub modules, with the negative controls.
-/

open Lean Meta

namespace BoundaryCheck

structure Hyp where
  hypothesis : Name
  countermodel : Name
  fit : Name

structure Entry where
  row : Name
  form : Name
  hypotheses : List Hyp
  recovery : Name
  certificate : Name
  bridges : List Name

/-- A constant's module; `none` for a constant of `Init`, and the main module for one declared in this file. -/
def moduleOf (env : Environment) (c : Name) : Option Name :=
  match env.getModuleIdxFor? c with
  | some i =>
    let m := env.header.moduleNames[i.toNat]!
    if (`Init).isPrefixOf m then none else some m
  | none => some env.mainModule

def grammarModule (m : Name) : Bool := m.toString.startsWith "Becoming.Grammar"

def rootModule : Option Name → Bool
  | none => true
  | some m => m == `Becoming.Prelude || grammarModule m

/-- A constant of the package: of a module that is not `Init`, `Lean`, `Std` or `Lake`. -/
def packaged (env : Environment) (c : Name) : Bool :=
  match moduleOf env c with
  | none => false
  | some m => !([`Lean, `Std, `Lake].contains m.getRoot)

/-- The constants a declaration's type and value name. -/
def namesOf (env : Environment) (c : Name) : List Name :=
  match env.find? c with
  | some ci => ci.type.getUsedConstants.toList ++
      ((ci.value? (allowOpaque := true)).map (·.getUsedConstants.toList)).getD []
  | none => []

/-- The constants an expression names at its term positions: not in a binder's type or a `∀`, which are types, so
that no proof inside a definition they name can flow into the term. Each distinct subterm is read once. -/
def termNames (e : Expr) : List Name := Id.run do
  let mut seen : Std.HashSet Expr := {}
  let mut found : NameSet := {}
  let mut out : Array Name := #[]
  let mut stack := [e]
  repeat
    match stack with
    | [] => break
    | x :: rest =>
      stack := rest
      if seen.contains x then continue
      seen := seen.insert x
      match x with
      | .const c _ => unless found.contains c do found := found.insert c; out := out.push c
      | .app f a => stack := f :: a :: stack
      | .lam _ _ b _ => stack := b :: stack
      | .letE _ _ v b _ => stack := v :: b :: stack
      | .mdata _ b => stack := b :: stack
      | .proj _ _ b => stack := b :: stack
      | _ => pure ()
  return out.toList

/-- The constants a declaration's value names at its term positions (`termNames`); none for a declaration with no
value. -/
def valueNames (env : Environment) (c : Name) : List Name :=
  match env.find? c with
  | some ci => ((ci.value? (allowOpaque := true)).map termNames).getD []
  | none => []

/-- Digits only, at least one. -/
def digits (l : List Char) : Bool := !l.isEmpty && l.all Char.isDigit

/-- Numerals joined by single underscores (`1`, `1_3`). -/
def numerals (l : List Char) : Bool :=
  l.head?.any Char.isDigit && l.getLast?.any Char.isDigit && l.all (fun c => c.isDigit || c == '_') &&
    !(l.zip l.tail).any (fun p => p.1 == '_' && p.2 == '_')

/-- A constant's kind, as the dump writes it; a private name the environment lacks is read by its user name (Lean makes
an equation lemma or a matcher of another module's declaration private to the module that needs it). -/
def kindOf (env : Environment) (c : Name) : String :=
  let c := if env.contains c then c else (privateToUserName? c).getD c
  match env.find? c with
  | some (.defnInfo _) => "def"
  | some (.opaqueInfo _) => "opaque"
  | some (.thmInfo _) => "thm"
  | some (.ctorInfo _) => "ctor"
  | some (.inductInfo _) => "ind"
  | some (.recInfo _) => "rec"
  | _ => ""

/-- Whether a name component Lean generates attaches to a declaration of kind `k`: boundary.py's `AUX`, which is
normative (BOUNDARY-FIELD §3.0). -/
def attaches (s k : String) : Bool :=
  let l := s.toList
  let after (p : String) : Option (List Char) := if p.toList.isPrefixOf l then some (l.drop p.length) else none
  let numbered (p : String) : Bool := (after p).any digits
  if ["_proof_", "proof_"].any (fun p => (after p).any numerals) then ["def", "opaque", "thm", "ind"].contains k
  else if (after "match_").any numerals then ["def", "opaque", "thm"].contains k
  else if s == "_unsafe_rec" then k == "def" || k == "opaque"
  else if numbered "eq_" || numbered "_aux_" ||
      ["eq_def", "splitter", "_sunfold", "_default", "_arg_pusher"].contains s then k == "def"
  else if ["inj", "injEq", "sizeOf_spec", "elim", "_flat_ctor"].contains s then k == "ctor"
  else if s == "noConfusion" then k == "ctor" || k == "ind"
  else if numbered "_sizeOf_" || ["_sizeOf_inst", "brecOn", "below", "binductionOn", "casesOn", "recOn", "rec",
      "noConfusionType", "ctorIdx", "toCtorIdx", "ofNat_ctorIdx", "ctorElim", "ctorElimType"].contains s then
    k == "ind"
  else false

/-- A generated auxiliary (§3.0): its last component attaches to the kind of the declaration before it, or it is a
constructor of a generated inductive (`below.cons`) or a part of a generated `brecOn` that is a definition (`go`,
`eq`). So `match_1.eq_1` is generated, and a theorem written by hand as `next.inj` on a definition `next` is not. A
hygienic name is read without its macro scopes, and the name before it with them (a declaration a macro makes,
`aux._proof_1._@.M._hyg.3` under `aux._@.M._hyg.3`). -/
partial def generated (env : Environment) (n : Name) : Bool :=
  let v := extractMacroScopes n
  let sc (m : Name) : Name := if n.hasMacroScopes then { v with name := m }.review else m
  match v.name with
  | .str p s =>
    let p' := sc p
    !p.isAnonymous && (attaches s (kindOf env p') || generated env p' &&
      ((kindOf env n == "ctor" && kindOf env p' == "ind") ||
       (match p with | .str _ "brecOn" => kindOf env p' == "def" && (s == "go" || s == "eq") | _ => false)))
  | _ => false

/-- An abstracted proof, `_proof_N` or `proof_N` (`_proof_1_1`): Lean's name for a proof it lifts out of a
declaration, read without macro scopes. -/
def abstracted (n : Name) : Bool :=
  match (extractMacroScopes n).name with
  | .str _ s => let l := s.toList
      ["_proof_", "proof_"].any fun p => p.toList.isPrefixOf l && numerals (l.drop p.length)
  | _ => false

/-- The names before a name: its prefixes, longest first. -/
def prefixes : Name → List Name
  | .str p _ | .num p _ => if p.isAnonymous then [] else p :: prefixes p
  | .anonymous => []

/-- Everything the constants `start` reach through types and values, not expanding `Init`. -/
partial def closureOf (env : Environment) (start : List Name) : NameSet := Id.run do
  let mut seen : NameSet := {}
  let mut stack := start
  repeat
    match stack with
    | [] => break
    | n :: rest =>
      stack := rest
      if seen.contains n then continue
      seen := seen.insert n
      if (moduleOf env n).isNone then continue
      stack := namesOf env n ++ stack
  return seen

def closure (env : Environment) (c : Name) : NameSet := closureOf env [c]

/-- The name test. -/
def admitted (env : Environment) (c : Name) : Bool :=
  match moduleOf env c with
  | none => true
  | some m =>
    if m == `Becoming.Prelude then true
    else if grammarModule m then (closure env c).toList.all (rootModule <| moduleOf env ·)
    else false

def amounts : List Name := [``Nat, ``LE.le, ``LT.lt, ``HAdd.hAdd, ``HSub.hSub, ``HMul.hMul]

def isTheorem (env : Environment) (c : Name) : Bool :=
  match env.find? c with
  | some (.thmInfo _) => true
  | _ => false

def isDefinition (env : Environment) (c : Name) : Bool :=
  match env.find? c with
  | some (.defnInfo _) => true
  | _ => false

/-- The dump's `cv`: a constant of the package that is a definition, opaque or constructor whose type is neither a
function type nor a sort. -/
def closedValue (env : Environment) (c : Name) : Bool :=
  packaged env c && match env.find? c with
    | some (.defnInfo v) => !v.type.isForall && !v.type.isSort
    | some (.opaqueInfo v) => !v.type.isForall && !v.type.isSort
    | some (.ctorInfo v) => !v.type.isForall && !v.type.isSort
    | _ => false

def grammarTerm (env : Environment) (c : Name) : Bool :=
  packaged env c && admitted env c && (toString c).contains '«'

/-- A proof: a theorem, or a definition or opaque of the package whose type is a proposition (a fact held in a
definition, or an instance of a class of propositions). `Init`'s, such as `rfl`, are not. -/
def isProof (c : Name) : MetaM Bool := do
  let env ← getEnv
  match env.find? c with
  | some (.thmInfo _) => return true
  | some (.defnInfo v) => return packaged env c && (← Meta.isProp v.type)
  | some (.opaqueInfo v) => return packaged env c && (← Meta.isProp v.type)
  | _ => return false

def isDefOrOpaque (env : Environment) (c : Name) : Bool :=
  match env.find? c with
  | some (.defnInfo _) | some (.opaqueInfo _) => true
  | _ => false

/-- The proofs a proof uses: every proof its value and its own auxiliary definitions (those under its name) name at
term positions (`termNames`), and the package's proofs inside every definition of the package they reach, all the way
down. So a fact held in a definition, or carried by a model's data (`⟨f, f_rel⟩ : {f // …}`), counts. An auxiliary
Lean generated (`generated`), such as the `_proof_N` Lean makes of a termination proof, a `decide` or a derived
instance's proof, is walked through like a definition, never collected, except another declaration's lifted proof
named by the owner itself (`abstracted`), which is a fact the owner uses. `Init`'s proofs inside a definition or an
auxiliary are not counted. -/
partial def theoremsUsed (owner : Name) : MetaM (List Name) := do
  let env ← getEnv
  let mut seen : NameSet := {}
  let mut found : List Name := []
  let mut stack : List (Name × Bool) := [(owner, true)]
  repeat
    match stack with
    | [] => break
    | (n, own) :: rest =>
      stack := rest
      if seen.contains n then continue
      seen := seen.insert n
      for m in valueNames env n do
        if own && owner.isPrefixOf m && m != owner then stack := (m, true) :: stack
        else if ← isProof m then
          if generated env m && !(own && abstracted m) then stack := (m, false) :: stack
          else if (own || packaged env m) && !found.contains m then found := found ++ [m]
        else if packaged env m && isDefOrOpaque env m then stack := (m, false) :: stack
  return found

/-- An expression with its leading binders and metadata removed. -/
partial def body : Expr → Expr
  | .lam _ _ b _ => body b
  | .mdata _ e => body e
  | e => e

/-- Whether F is applied, somewhere in `e`, with the free variable `h` among its arguments. -/
def appliesWith (e : Expr) (form : Name) (h : Expr) : Bool :=
  (e.find? fun x => x.isAppOf form && x.getAppArgs.any (·.consumeMData == h)).isSome

def show_ (ns : List Name) : String := toString (ns.map toString)

/-- An equivalence: a theorem whose statement, under its binders, is an `Iff`, or an `Eq` between propositions,
predicates or relations. -/
def isEquivalence (c : Name) : MetaM Bool := do
  let some (.thmInfo v) := (← getEnv).find? c | return false
  forallTelescope v.type fun _ c => do
    let c := c.consumeMData
    if c.isAppOfArity ``Iff 2 then return true
    if c.isAppOfArity ``Eq 3 then
      forallTelescopeReducing c.appFn!.appFn!.appArg! fun _ t => return t.isProp
    else return false

def checkEntry (e : Entry) : MetaM Json := do
  let env ← getEnv
  let fails ← IO.mkRef (#[] : Array String)
  let fail (s : String) : MetaM Unit := fails.modify (·.push s)
  let report ← IO.mkRef (#[] : Array (String × Json))
  let note (k : String) (v : Json) : MetaM Unit := report.modify (·.push (k, v))
  let hyps := e.hypotheses.map (·.hypothesis)
  let finish : MetaM Json := do
    let fs ← fails.get
    return Json.mkObj ([("row", toJson (toString e.row)), ("form", toJson (toString e.form)),
      ("passed", toJson fs.isEmpty), ("failures", toJson fs)] ++ (← report.get).toList)
  -- 1. The declarations named.
  let theorems := [e.row, e.form, e.recovery, e.certificate] ++
    e.hypotheses.flatMap (fun h => [h.countermodel, h.fit]) ++ e.bridges
  let missing := (theorems ++ hyps).filter (env.find? · |>.isNone)
  unless missing.isEmpty do
    fail s!"not in the environment: {show_ missing}"
    return ← finish
  for c in theorems do
    unless isTheorem env c do fail s!"{c} is not a theorem"
  for h in hyps do
    unless isDefinition env h do fail s!"the hypothesis {h} is not a definition"
  if !isTheorem env e.form || !hyps.all (isDefinition env) then return ← finish
  let distinct (what : String) (ns : List Name) : MetaM Unit := do
    unless ns.eraseDups.length == ns.length do fail s!"the {what} are not distinct: {show_ ns}"
  distinct "hypotheses" hyps
  distinct "countermodels" (e.hypotheses.map (·.countermodel))
  distinct "fits" (e.hypotheses.map (·.fit))
  distinct "row, form and recovery" [e.row, e.form, e.recovery]
  if hyps.isEmpty then fail "the form has no hypotheses"
  let home := moduleOf env e.form
  -- 2. The hypotheses.
  let mut hypNames : List (String × Json) := []
  for h in hyps do
    unless moduleOf env h == home do fail s!"the hypothesis {h} is not a definition of the form's module"
    let ns := (namesOf env h).eraseDups
    let bad := ns.filter (!admitted env ·)
    unless bad.isEmpty do fail s!"the hypothesis {h} names constants the name test does not admit: {show_ bad}"
    let amount := amounts.filter (closure env h).contains
    unless amount.isEmpty do fail s!"the hypothesis {h} names amounts: {show_ amount}"
    hypNames := hypNames ++ [(toString h, toJson (ns.map toString))]
  note "hypothesis_names" (Json.mkObj hypNames)
  -- 3. F's statement.
  let formInfo ← getConstInfo e.form
  let stated := formInfo.type.getUsedConstants.toList.eraseDups
  note "statement_names" (toJson (stated.map toString))
  let bad := stated.filter fun c => !admitted env c && !hyps.contains c
  unless bad.isEmpty do
    fail s!"the form's statement names constants neither admitted nor its hypotheses: {show_ bad}"
  unless (stated ++ hyps.flatMap (namesOf env)).any (grammarTerm env) do
    fail "neither the form's statement nor a hypothesis it applies names a «» term of the root"
  let closed := (closureOf env stated).toList.filter (closedValue env)
  unless closed.isEmpty do fail s!"the form's statement reaches closed values: {show_ closed}"
  forallTelescope formInfo.type fun xs concl => do
    let mut used : List Name := []
    for x in xs do
      let decl ← x.fvarId!.getDecl
      if ← isProp decl.type then
        match decl.type.getAppFn.constName? with
        | some c =>
          if hyps.contains c then used := used ++ [c]
          else fail s!"the form's binder {decl.userName} : {← ppExpr decl.type} is not a listed hypothesis"
        | none => fail s!"the form's binder {decl.userName} : {← ppExpr decl.type} is not a listed hypothesis"
      else unless decl.binderInfo.isImplicit do
        fail s!"the form's binder {decl.userName} is explicit and not a proposition"
    unless used.length == hyps.length && hyps.all (fun h => used.count h == 1) do
      fail s!"the form's hypotheses are {show_ used}, not each of {show_ hyps} once"
    -- 4. The countermodels.
    for h in e.hypotheses do
      let mut rest := #[]
      for x in xs do
        unless (← x.fvarId!.getDecl).type.getAppFn.constName? == some h.hypothesis do
          rest := rest.push x
      let expected := mkNot (← mkForallFVars rest concl)
      let cm ← getConstInfo h.countermodel
      unless ← withReducible (isDefEq expected cm.type) do
        fail s!"the countermodel {h.countermodel} is not ¬ {e.form} without {h.hypothesis}"
  -- 4–5. The countermodels' proofs and the fits.
  let mut factsOf : List (String × Json) := []
  for h in e.hypotheses do
    let reach := closure env h.countermodel
    if reach.contains e.form || reach.contains e.row then
      fail s!"the countermodel {h.countermodel} reaches the form or the row"
    let fit ← getConstInfo h.fit
    let fitType := fit.type.consumeMData
    unless fitType.isAppOfArity ``Not 1 && fitType.appArg!.getAppFn.constName? == some h.hypothesis do
      fail s!"the fit {h.fit} is not ¬ {h.hypothesis} at a witness"
    for w in fit.type.getUsedConstants.toList.eraseDups do
      unless admitted env w || w == h.hypothesis do
        if isDefinition env w && moduleOf env w == home then
          let wBad := (namesOf env w).filter (!admitted env ·)
          unless wBad.isEmpty do fail s!"the witness {w} names constants the name test does not admit: {show_ wBad}"
        else fail s!"the fit {h.fit} names {w}, neither admitted nor a witness of the form's module"
    match fit.value? with
    | some (.lam n t b bi) =>
      let applied ← withLocalDecl n bi t fun x => pure (appliesWith (b.instantiate1 x) e.form x)
      unless applied do fail s!"the fit {h.fit} does not apply the form to its hypothesis"
    | _ => fail s!"the fit {h.fit}'s proof is not a function of its hypothesis"
    let facts := (← theoremsUsed h.fit).filter fun c => packaged env c && c != e.form
    for fact in facts do
      let r := closure env fact
      if r.contains e.form || r.contains e.row then fail s!"the fact {fact} reaches the form or the row"
    let cmFacts := (← theoremsUsed h.countermodel).filter fun c => packaged env c
    unless facts.all cmFacts.contains && cmFacts.all facts.contains do
      fail s!"the countermodel {h.countermodel} uses {show_ cmFacts}, the fit {h.fit} uses {show_ facts}"
    factsOf := factsOf ++ [(toString h.fit, toJson (facts.map toString))]
  note "facts" (Json.mkObj factsOf)
  -- 6. F's proof.
  let formReach := closure env e.form
  let off := formReach.toList.filter fun c => !rootModule (moduleOf env c) && moduleOf env c != home
  unless off.isEmpty do fail s!"the form's proof reaches constants off the root: {show_ off}"
  if formReach.contains e.row then fail "the form's proof reaches the row"
  -- 7. The certificate.
  let cert := (← getConstInfo e.certificate).type.consumeMData
  let rowInfo ← getConstInfo e.row
  let general (us : List Level) : Bool :=
    us.all (·.isParam) && us.eraseDups.length == us.length && us.length == rowInfo.levelParams.length
  match cert.getAppFn, cert.getAppArgs.map (·.consumeMData) with
  | Expr.const ``Eq _, #[_, Expr.const a us, Expr.const b vs] =>
    if a == e.row && b == e.recovery then
      unless general us do fail "the certificate states the row at a specialized universe"
    else if a == e.recovery && b == e.row then
      unless general vs do fail "the certificate states the row at a specialized universe"
    else fail s!"the certificate {e.certificate} is not @{e.row} = @{e.recovery}"
  | _, _ => fail s!"the certificate {e.certificate} is not @{e.row} = @{e.recovery}"
  -- 8. The recovery.
  let recovery ← getConstInfo e.recovery
  match recovery.value? with
  | some v =>
    unless (body v).getAppFn.constName? == some e.form do
      fail s!"the recovery {e.recovery} is not, under its binders, the form applied"
  | none => fail s!"the recovery {e.recovery} has no proof"
  -- 9. The discharge condition and the bridges.
  let projection (c : Name) : Bool := env.isProjectionFn c
  let used ← theoremsUsed e.recovery
  note "recovery_uses" (toJson (used.map toString))
  let others := used.filter fun c => c != e.form && !e.bridges.contains c && !projection c
  unless others.isEmpty do
    fail s!"the discharge condition fails: the recovery uses {show_ others}"
  let mut usedBy : List Name := used
  for b in e.bridges do
    let bUsed ← theoremsUsed b
    usedBy := usedBy ++ bUsed
    let outside := bUsed.filter fun c => !admitted env c && !e.bridges.contains c && !projection c
    unless outside.isEmpty do fail s!"the bridge {b} uses theorems outside the closed set: {show_ outside}"
  for b in e.bridges do
    unless usedBy.contains b do fail s!"the bridge {b} is used by neither the recovery nor another bridge"
    if used.contains b then
      unless ← isEquivalence b do fail s!"the bridge {b}, used by the recovery, is not an equivalence"
  finish

def nameField (j : Json) (k : String) : Except String Name := do
  let s ← j.getObjValAs? String k
  let n := s.toName
  if n.isAnonymous then throw s!"the field {k} is empty" else pure n

def parseEntry (j : Json) : Except String Entry := do
  let hs ← j.getObjValAs? (Array Json) "hypotheses"
  let hyps ← hs.toList.mapM fun h => do
    pure { hypothesis := ← nameField h "hypothesis", countermodel := ← nameField h "countermodel",
           fit := ← nameField h "fit" : Hyp }
  let bridges := ((j.getObjValAs? (Array String) "bridges").toOption.getD #[]).toList.map (·.toName)
  return { row := ← nameField j "row", form := ← nameField j "form", hypotheses := hyps,
           recovery := ← nameField j "recovery", certificate := ← nameField j "certificate", bridges }

#eval show MetaM Unit from do
  let some input ← IO.getEnv "BOUNDARY_CHECK_IN" | throwError "BOUNDARY_CHECK_IN is not set"
  let some output ← IO.getEnv "BOUNDARY_CHECK_OUT" | throwError "BOUNDARY_CHECK_OUT is not set"
  let j ← IO.ofExcept (Json.parse (← IO.FS.readFile input))
  let entries ← IO.ofExcept (j.getObjValAs? (Array Json) "entries")
  let mut results := #[]
  for x in entries do
    let entry ← IO.ofExcept (parseEntry x)
    let r ← try checkEntry entry catch err => do
      pure (Json.mkObj [("row", toJson (toString entry.row)), ("form", toJson (toString entry.form)),
        ("passed", toJson false), ("failures", toJson #[s!"the check raised: {← err.toMessageData.toString}"])])
    results := results.push r
  let names := ((j.getObjValAs? (Array String) "names").toOption.getD #[]).toList
  let env ← getEnv
  let admits := names.map fun s => (s, toJson (env.contains s.toName && admitted env s.toName))
  let mut equivalences := #[]
  for s in ((j.getObjValAs? (Array String) "equivalences").toOption.getD #[]).toList do
    equivalences := equivalences.push (s, toJson (← isEquivalence s.toName))
  let listed := ((j.getObjValAs? (Array String) "generated").toOption.getD #[]).toList.map (·.toName)
  let auxiliaries := listed.map fun n => (toString n, toJson (generated env n))
  let kinds := (listed.flatMap fun n => n :: prefixes n).eraseDups.map fun n => (toString n, toJson (kindOf env n))
  IO.FS.writeFile output ((Json.mkObj [("entries", toJson results), ("admitted", Json.mkObj admits),
    ("equivalence", Json.mkObj equivalences.toList), ("generated", Json.mkObj auxiliaries),
    ("kinds", Json.mkObj kinds)]).pretty ++ "\n")

end BoundaryCheck
