import Becoming.Sampling
import Becoming.PatternPassing

/-!
HE2's item 1, checked outside the package before the rebuild: «两端分则中有标» with `K` only composing, and
Sampling's `arises_within` and `ceases_within` read from it. The earlier form of the law, with `K` a class, is
one application of the new one, and the earlier statements of Sampling's two theorems, written out, are the new
theorems.
-/

universe u

namespace Becoming
namespace HE2Item1

/-- The law's earlier form, `K` a class, is the new law at the class's `trans`. -/
theorem of_class {α : Type u} {R E K P : «际» α} (hK : «类» K)
    (split : ∀ x y, «续» R E x y → K x y ∨ P x y) {x y : α} (line : «相续» R E x y) :
    ¬ K x y → ∃ u v, «续» R E u v ∧ P u v ∧ (x = u ∨ «相续» R E x u) ∧ (v = y ∨ «相续» R E v y) :=
  «两端分则中有标» split hK.trans line

/-- `arises_within`'s statement, as Sampling stated it before the edit. -/
theorem arises_within_stated {p : Nat → Prop} [∀ n, Decidable (p n)] {T : Nat} :
    ∀ {t : Nat}, T ≤ t → ¬ p T → p t → ∃ u, T ≤ u ∧ u < t ∧ ¬ p u ∧ p (u + 1) :=
  arises_within

/-- `ceases_within`'s statement, as Sampling stated it before the edit. -/
theorem ceases_within_stated {p : Nat → Prop} [∀ n, Decidable (p n)] {T : Nat} :
    ∀ {t : Nat}, T ≤ t → p T → ¬ p t → ∃ u, T ≤ u ∧ u < t ∧ p u ∧ ¬ p (u + 1) :=
  ceases_within

end HE2Item1
end Becoming
