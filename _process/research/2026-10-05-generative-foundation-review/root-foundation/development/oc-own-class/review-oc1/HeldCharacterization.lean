/-! For a member that conditions something and whose effects the class holds, constancy up to the
net's end at its class is exactly that every occurrence alike to it conditions only what is alike to
it (classical in the backward direction, which must decide whether an occurrence conditions anything). -/
namespace Scratch3
universe u
abbrev «际» (α : Type u) : Type u := α → α → Prop
structure «类» {α : Type u} (E : «际» α) : Prop where
  refl : ∀ x, E x x
  symm : ∀ {x y}, E x y → E y x
  trans : ∀ {x y z}, E x y → E y z → E x z
variable {α : Type u}
def «所缘同于» (R E : «际» α) (m : α) : Prop := ∀ v, R m v → E m v
def «本类至终有常» (R E : «际» α) (m : α) : Prop :=
  ∀ u u', E m u → E m u' → ∀ v, R u v → (∃ v', R u' v' ∧ E v v') ∨ ∀ w, ¬ R u' w
theorem heldChar {R E : «际» α} (hE : «类» E) {m : α} (goes : ∃ w, R m w)
    (held : «所缘同于» R E m) :
    «本类至终有常» R E m ↔ ∀ u v, E m u → R u v → E m v := by
  constructor
  · intro a u v mu r
    match a u m mu (hE.refl m) v r with
    | .inl ⟨v', hv', e⟩ => exact hE.trans (held v' hv') (hE.symm e)
    | .inr st => match goes with
      | ⟨w, hw⟩ => exact absurd hw (st w)
  · intro all u u' mu mu' v r
    match Classical.em (∃ w, R u' w) with
    | .inr no => exact .inr (fun w h => no ⟨w, h⟩)
    | .inl ⟨w, hw⟩ => exact .inl ⟨w, hw, hE.trans (hE.symm (all u v mu r)) (all u' w mu' hw)⟩
end Scratch3
#print axioms Scratch3.heldChar
