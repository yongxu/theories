/-! Inconstant at the member's class, with GrammarPath's own net (full tables) and the module's
proof style; checks that the suggested lemma has an empty axiom report. -/
namespace Scratch2
universe u
abbrev «际» (α : Type u) : Type u := α → α → Prop
def «本类至终有常» {α : Type u} (R E : «际» α) (m : α) : Prop :=
  ∀ u u', E m u → E m u' → ∀ v, R u v → (∃ v', R u' v' ∧ E v v') ∨ ∀ w, ¬ R u' w
namespace Inconstant
inductive Occ | m | v | w
def step : «际» Occ
  | .m, .m => False
  | .m, .v => True
  | .m, .w => False
  | .v, .m => False
  | .v, .v => False
  | .v, .w => True
  | .w, .m => False
  | .w, .v => False
  | .w, .w => False
def upper : Occ → Bool
  | .m => true
  | .v => true
  | .w => false
def same : «际» Occ := fun x y => upper x = upper y
/-- The class holds the member's effects but is not constant up to the net's end even at the
member's class. -/
theorem not_constant_at : ¬ «本类至终有常» step same .m := fun atClass =>
  match atClass .v .m rfl rfl .w trivial with
  | .inl ⟨.v, _, e⟩ => Bool.noConfusion e
  | .inl ⟨.m, h, _⟩ => h
  | .inl ⟨.w, h, _⟩ => h
  | .inr stops => stops .v trivial
end Inconstant
end Scratch2
#print axioms Scratch2.Inconstant.not_constant_at
