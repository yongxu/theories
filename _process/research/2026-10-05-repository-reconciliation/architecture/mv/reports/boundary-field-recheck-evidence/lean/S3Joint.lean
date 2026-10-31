import Lean
open Lean
/-! S3 of BOUNDARY-FIELD draft 2: one countermodel listed for two hypotheses passes S3's name checks for both. -/
namespace Mini
def «际» (X : Type) : Type := X → X → Prop
def «则» {X : Type} (R S : «际» X) : Prop := ∀ a b, R a b → S a b
variable {X : Type}
def H1 (R S : «际» X) : Prop := «则» R S
def H2 (S T : «际» X) : Prop := «则» S T
def H3 (R : «际» X) (x y : X) : Prop := «则» R R ∧ R x y
theorem F {R S T : «际» X} {x y : X} (h1 : H1 R S) (h2 : H2 S T) (h3 : H3 R x y) : T x y :=
  h2 x y (h1 x y h3.2)
-- witness: R total, S and T empty, so H3 holds and the conclusion fails
def wR (_ _ : Unit) : Prop := True
def wE (_ _ : Unit) : Prop := False
theorem w3 : H3 wR () () := ⟨fun _ _ h => h, trivial⟩
theorem wfails : ¬ wE () () := id
-- one theorem, listed as the countermodel of H1 and of H2: it shows only that H1 and H2 cannot both be dropped
theorem joint_needed : ¬ (H1 wR wE ∧ H2 wE wE) := fun ⟨h1, h2⟩ => wfails (F h1 h2 w3)
-- in fact H2 alone can be dropped at this witness's shape? (H2 wE wE holds trivially) -- so joint_needed says nothing about H2
theorem h2_holds : H2 wE wE := fun _ _ h => h
end Mini
#eval show CoreM Unit from do
  let env ← getEnv
  let mine (ns : Array Name) := (ns.filter (fun n => (`Mini).isPrefixOf n)).toList
  let some (.thmInfo v) := env.find? ``Mini.joint_needed | throwError "x"
  IO.println s!"joint_needed t={mine v.type.getUsedConstants} v={mine v.value.getUsedConstants}"
#print axioms Mini.joint_needed
