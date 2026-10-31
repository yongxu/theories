/-
Item 13 of the twenty-first review: the composition 01 §4's paragraph "The core and 理" states, checked
against the package's own declarations (Becoming.Grammar, Becoming.GrammarLaws), outside the package.
Not a package declaration: proposed to the grammar's owner for `Becoming.GrammarLaws`, where HE2's item 6
states it as «定后则类之核同行», «遍后则其内同行之类含于核», «定后遍后则核为其内最粗同行之类» and «后不定则核可不同行».
-/
import Becoming.GrammarLaws

namespace Becoming

variable {α : Type u}

/-- Along a step whose successor is fixed, the core of a class is a class the step goes alike across:
a 理 in 03's sense. -/
theorem coreOfClassGoesAlike {R E : «际» α} (hE : «类» E) (fixed : «定后» R) :
    «类» («核» R E) ∧ «则» («核» R E) E ∧ «同行» R («核» R E) :=
  ⟨«核为类» R hE, («根» R E).1, «有常定后则同行» («根» R E).2.1 fixed⟩

/-- Where every occurrence has a successor, every class inside `E` that the step goes alike across lies
inside the core of `E` (no fixed successor needed). -/
theorem goesAlikeInsideCore {R E : «际» α} (total : ∀ x, ∃ y, R x y) :
    ∀ S, «类» S → «则» S E → «同行» R S → «则» S («核» R E) :=
  fun S hS hSE alike => («根» R E).2.2.2 S hSE (fun _ _ h => hS.symm h) («同行遍后则有常» alike total)

/-- **The core and 理.** Along a fixed successor that every occurrence has, the core of a class `E` is the
coarsest class inside `E` that the step goes alike across. -/
theorem coreIsCoarsestGoingAlike {R E : «际» α} (hE : «类» E) (fixed : «定后» R)
    (total : ∀ x, ∃ y, R x y) :
    («类» («核» R E) ∧ «则» («核» R E) E ∧ «同行» R («核» R E)) ∧
      ∀ S, «类» S → «则» S E → «同行» R S → «则» S («核» R E) :=
  ⟨coreOfClassGoesAlike hE fixed, goesAlikeInsideCore total⟩

/-- Where `0` steps to `1` and to `2`: a step whose successor is not fixed. -/
def branching : «际» Nat := fun x y => x = 0 ∧ (y = 1 ∨ y = 2)

/-- **Witness.** Off a fixed successor the core of a class need not go alike: under `branching` the
identity is a class, the successor is not fixed, the core relates `0` to itself and not `1` to `2`, and the
step does not go alike across it. -/
theorem coreNeedNotGoAlike :
    «类» («静» : «际» Nat) ∧ ¬ «定后» branching ∧ «核» branching «静» 0 0 ∧ ¬ «核» branching «静» 1 2 ∧
      ¬ «同行» branching («核» branching «静») := by
  have hid : «核» branching «静» 0 0 :=
    ⟨«静», fun _ _ h => h, fun _ _ h => h.symm, «静有常» branching, rfl⟩
  have apart : ¬ «核» branching «静» 1 2 := fun ⟨_, hS, _, _, h12⟩ => by
    have same : (1 : Nat) = 2 := hS 1 2 h12
    exact absurd same (by decide)
  refine ⟨⟨fun _ => rfl, Eq.symm, Eq.trans⟩, fun fixed => ?_, hid, apart, fun h => ?_⟩
  · have same : (1 : Nat) = 2 := fixed 1 2 ⟨0, ⟨rfl, Or.inl rfl⟩, ⟨rfl, Or.inr rfl⟩⟩
    exact absurd same (by decide)
  · exact apart (h 1 2 ⟨0, ⟨0, ⟨rfl, Or.inl rfl⟩, hid⟩, ⟨rfl, Or.inr rfl⟩⟩)

end Becoming

#print axioms Becoming.coreOfClassGoesAlike
#print axioms Becoming.goesAlikeInsideCore
#print axioms Becoming.coreIsCoarsestGoingAlike
#print axioms Becoming.coreNeedNotGoAlike
