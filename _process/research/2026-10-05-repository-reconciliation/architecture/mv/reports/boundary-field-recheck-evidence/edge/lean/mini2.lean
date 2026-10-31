import Lean
open Lean

/-! A miniature of the root and of U4's scratch leaf (u4-edge 3fd7dad75, boundary-scratch/Becoming/U4Boundary.lean),
copied for the hypotheses and forms, to read what the dump would record (`t`, `v` as getUsedConstants, kept to the
run's namespace `Becoming`). Module stand-ins: names under `Becoming.G` are the grammar (root), names under
`Becoming.U4Boundary` the leaf. -/

namespace Becoming
universe u
abbrev «际» (α : Type u) : Type u := α → α → Prop
def «而» {α : Type u} (R S : «际» α) : «际» α := fun x z => ∃ y, R x y ∧ S y z
def «则» {α : Type u} (R S : «际» α) : Prop := ∀ x y, R x y → S x y
namespace ListTests
theorem mem_flatMap_iff {α β : Type} {f : α → List β} {b : β} : ∀ {l : List α}, b ∈ l.flatMap f ↔ ∃ a, a ∈ l ∧ b ∈ f a
  | l => List.mem_flatMap
end ListTests

namespace U4Boundary
variable {X : Type}
def GivenTo (comes : X → Prop) (descends : «际» X) : Prop := ∀ x, comes x → ∃ g, descends x g
def Inherits (descends : «际» X) (before after : X → Prop) : Prop := ∀ x g, descends x g → after x → before g
def UndependedFrom (descends : «际» X) (before : X → Prop) : Prop := ∀ x g, descends x g → ¬ before g
theorem descent_forms_no_dependence {comes before after : X → Prop} {descends : «际» X}
    (given : GivenTo comes descends) (inherits : Inherits descends before after)
    (undepended : UndependedFrom descends before) : ∀ x, comes x → ¬ after x :=
  fun x stands depends => match given x stands with
    | ⟨g, descent⟩ => undepended x g descent (inherits x g descent depends)
theorem descent_forms_no_dependence.needs_given :
    ¬ ∀ {X : Type} {comes before after : X → Prop} {descends : «际» X},
      Inherits descends before after → UndependedFrom descends before → ∀ x, comes x → ¬ after x :=
  fun h => @h Unit (fun _ => True) (fun _ => False) (fun _ => True) (fun _ _ => False)
    (fun _ _ descent _ => descent) (fun _ _ descent _ => descent) () trivial trivial
def GivesFrom (region : X → Prop) (gives : «际» X) : Prop :=
  «则» gives («而» (fun x y => x = y ∧ region x) gives)
def ListedWithin (ps : List X) (kids : X → List X) (gives : «际» X) : Prop :=
  «则» (fun p k => p ∈ ps ∧ k ∈ kids p) gives
def Outside (region : X → Prop) (ps : List X) : Prop := ∀ p, p ∈ ps → ¬ region p
theorem length_zero_of_none : ∀ {ks : List X}, (∀ k, ¬ k ∈ ks) → ks.length = 0
  | [], _ => rfl
  | k :: _, empty => absurd (List.Mem.head _) (empty k)
theorem outside_leaves_no_offspring {region : X → Prop} {gives : «际» X} {ps : List X}
    {kids : X → List X} (gate : GivesFrom region gives) (descent : ListedWithin ps kids gives)
    (outside : Outside region ps) : (ps.flatMap kids).length = 0 :=
  length_zero_of_none fun k mk => match ListTests.mem_flatMap_iff.mp mk with
    | ⟨p, mp, kp⟩ => match gate p k (descent p k ⟨mp, kp⟩) with
      | ⟨_, ⟨rfl, inside⟩, _⟩ => outside p mp inside

-- Hypotheses the draft's S2 should refuse (U4 §1.2, §1.5 'no amounts in a hypothesis'): amounts constrained,
-- packaged with a grammar inclusion.
def CancelsAlong (R : «际» X) (raised lowered : X → Nat) : Prop := «则» R (fun x y => raised x = lowered y)
def BoundedAlong (R : «际» X) (need level : X → Nat) : Prop := «则» R R ∧ ∀ x, need x ≤ level x

-- A form with a hypothesis that can be dropped, and an `H_needed` that names the form and a fact.
def Redundant (R : «际» X) : Prop := «则» R R ∧ ∃ x, R x x
theorem loose_form {R : «际» X} (r : Redundant R) (incl : «则» R R) : «则» R R := incl
def wR : «际» Unit := fun _ _ => False
theorem w_not_redundant : ¬ Redundant wR := fun ⟨_, x, h⟩ => h
theorem Redundant_needed : ¬ Redundant wR :=
  fun h => (fun (_ : type_of% @loose_form) => w_not_redundant h) @loose_form
-- Without the redundant hypothesis the form still holds: it can be dropped.
theorem loose_form_without (R : «际» X) (incl : «则» R R) : «则» R R := incl
end U4Boundary
end Becoming

open Lean in
#eval show CoreM Unit from do
  let env ← getEnv
  let keep (ns : Array Name) := (ns.filter (fun n => (`Becoming).isPrefixOf n)).toList
  for (n, ci) in env.constants.map₂.toList do
    if (`Becoming).isPrefixOf n && !n.isInternal then
      let (k, v) : String × Array Name := match ci with
        | .thmInfo v => ("thm", v.value.getUsedConstants)
        | .defnInfo v => ("def", v.value.getUsedConstants)
        | _ => ("other", #[])
      IO.println s!"{n}\t{k}\t{keep ci.type.getUsedConstants}\t{keep v}"
