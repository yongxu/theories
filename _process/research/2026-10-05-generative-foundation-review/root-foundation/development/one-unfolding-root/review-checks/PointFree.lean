namespace PF
variable {α : Type}
def comp (R S : α → α → Prop) : α → α → Prop := fun x z => ∃ y, R x y ∧ S y z
def conv (R : α → α → Prop) : α → α → Prop := fun x y => R y x
def incl (R S : α → α → Prop) : Prop := ∀ x y, R x y → S x y
def carriesPF (R E : α → α → Prop) : Prop := incl (comp (conv E) R) (comp R (conv E))
def carries (R E : α → α → Prop) : Prop :=
  ∀ u u', E u u' → ∀ v, R u v → ∃ v', R u' v' ∧ E v v'
theorem carries_iff (R E : α → α → Prop) : carries R E ↔ carriesPF R E :=
  ⟨fun c x z ⟨y, e, r⟩ => match c y x e z r with | ⟨v', r', e'⟩ => ⟨v', r', e'⟩,
   fun c u u' e v r => match c u' v ⟨u, e, r⟩ with | ⟨v', r', e'⟩ => ⟨v', r', e'⟩⟩
end PF
#print axioms PF.carries_iff
