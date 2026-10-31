import Lean
open Lean

/-! Miniature of U4's row-5/row-17 hypotheses and a mixed amount hypothesis, with the dump's `t`/`v`
(constants outside Init/Std/Lean, here: constants of namespace `Mini`), to test BOUNDARY-FIELD draft 2's S0 and S2. -/
namespace Mini
def «际» (X : Type) : Type := X → X → Prop
def «则» {X : Type} (R S : «际» X) : Prop := ∀ a b, R a b → S a b
def «而» {X : Type} (R S : «际» X) : «际» X := fun a c => ∃ b, R a b ∧ S b c
variable {X : Type}
-- U4's row-5 hypotheses (U4Boundary.lean), relations as variables
def GivenTo (comes : X → Prop) (descends : «际» X) : Prop := ∀ x, comes x → ∃ g, descends x g
def Inherits (descends : «际» X) (before after : X → Prop) : Prop := ∀ x g, descends x g → after x → before g
def UndependedFrom (descends : «际» X) (before : X → Prop) : Prop := ∀ x g, descends x g → ¬ before g
-- U4's row-17 hypotheses
def GivesFrom (region : X → Prop) (gives : «际» X) : Prop := «则» gives («而» (fun x y => x = y ∧ region x) gives)
def Outside (region : X → Prop) (ps : List X) : Prop := ∀ p, p ∈ ps → ¬ region p
-- A hypothesis that constrains amounts and names a grammar term: U4's §1.5 refuses it ("no amounts in a hypothesis")
def MixedCancel (R : «际» X) (raised lowered : X → Nat) : Prop := «则» R R ∧ ∀ x, raised x = lowered x
theorem form5 {comes before after : X → Prop} {descends : «际» X}
    (given : GivenTo comes descends) (inherits : Inherits descends before after)
    (undepended : UndependedFrom descends before) : ∀ x, comes x → ¬ after x :=
  fun x stands depends => match given x stands with
    | ⟨g, descent⟩ => undepended x g descent (inherits x g descent depends)
end Mini

#eval show CoreM Unit from do
  let env ← getEnv
  let mine (ns : Array Name) := (ns.filter (fun n => (`Mini).isPrefixOf n)).toList
  for n in [``Mini.GivenTo, ``Mini.Inherits, ``Mini.UndependedFrom, ``Mini.GivesFrom, ``Mini.Outside, ``Mini.MixedCancel, ``Mini.form5] do
    let some ci := env.find? n | throwError "missing"
    let v := match ci with | .defnInfo d => d.value.getUsedConstants | .thmInfo t => t.value.getUsedConstants | _ => #[]
    let term (m : Name) : Bool := (m.toString.splitOn "«").length > 1 && m != ``Mini.«际»
    let t := mine ci.type.getUsedConstants
    let vv := mine v
    let stmt := if ci matches .thmInfo _ then t else t ++ vv
    IO.println s!"{n}: t={t} v={vv} names_grammar_term_directly={stmt.any term}"
