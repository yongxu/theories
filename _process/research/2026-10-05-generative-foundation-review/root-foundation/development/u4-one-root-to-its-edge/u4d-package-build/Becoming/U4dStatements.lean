import Becoming.Identity

/-! U4d scratch: the four census recurrence laws moved in Identity keep their statements. Each old
statement is written out with its section's variables as binders, in their order (`F C`, `W R`
implicit, then the three decisions), and proved by the moved law itself. -/

namespace Becoming

namespace Web

theorem U4dStatements.arisingFrom_of_ceasingFrom_from :
    ∀ {F C : Type} {W : Web F C} {R : Nat → F → F → Prop} [∀ t f, Decidable (W.active t f)]
      [∀ t f, Decidable (W.Continues R t f)] [∀ t g, Decidable (W.Continued R t g)]
      {alive : Nat → List F} {T : Nat},
      (∀ s, T ≤ s → Distinct (alive s) ∧ ∀ f, W.active s f ↔ f ∈ alive s) →
      (∀ s, T ≤ s → ∀ g f f', W.active s g → R s g f → R s g f' →
        W.active (s + 1) f → W.active (s + 1) f' → f = f') →
      (∀ N, ∃ t g, N ≤ t ∧ W.CeasesFrom R t g) → W.UnceasingFrom R :=
  @Census.arisingFrom_of_ceasingFrom_from

theorem U4dStatements.arisingFrom_of_ceasingFrom :
    ∀ {F C : Type} {W : Web F C} {R : Nat → F → F → Prop} [∀ t f, Decidable (W.active t f)]
      [∀ t f, Decidable (W.Continues R t f)] [∀ t g, Decidable (W.Continued R t g)]
      {alive : Nat → List F}, W.Census alive → W.NoSplit R →
      (∀ N, ∃ t g, N ≤ t ∧ W.CeasesFrom R t g) → W.UnceasingFrom R :=
  @Census.arisingFrom_of_ceasingFrom

theorem U4dStatements.ceasingFrom_of_arisingFrom_from :
    ∀ {F C : Type} {W : Web F C} {R : Nat → F → F → Prop} [∀ t f, Decidable (W.active t f)]
      [∀ t f, Decidable (W.Continues R t f)] [∀ t g, Decidable (W.Continued R t g)]
      {alive : Nat → List F} {T B : Nat},
      (∀ s, T ≤ s → Distinct (alive s) ∧ ∀ f, W.active s f ↔ f ∈ alive s) →
      (∀ s, T ≤ s → ∀ g g' f, W.active s g → W.active s g' → R s g f → R s g' f →
        W.active (s + 1) f → g = g') →
      (∀ t, T ≤ t → (alive t).length ≤ B) → W.UnceasingFrom R →
      ∀ N, ∃ t g, N ≤ t ∧ W.CeasesFrom R t g :=
  @Census.ceasingFrom_of_arisingFrom_from

theorem U4dStatements.ceasingFrom_of_arisingFrom :
    ∀ {F C : Type} {W : Web F C} {R : Nat → F → F → Prop} [∀ t f, Decidable (W.active t f)]
      [∀ t f, Decidable (W.Continues R t f)] [∀ t g, Decidable (W.Continued R t g)]
      {alive : Nat → List F}, W.Census alive → W.NoMerge R → ∀ {T B : Nat},
      (∀ t, T ≤ t → (alive t).length ≤ B) → W.UnceasingFrom R →
      ∀ N, ∃ t g, N ≤ t ∧ W.CeasesFrom R t g :=
  @Census.ceasingFrom_of_arisingFrom

end Web

end Becoming
