import Becoming.U4Boundary

/-! Declarations for the boundary check's negative controls (scratch): U4's controls, adapted, and controls for
the tests the generalized check adds. -/

namespace Becoming.BoundaryCheckControls

open U4Boundary

/-- A countermodel for the gate whose proof names the form. -/
theorem needs_gate_through_form :
    ¬ ∀ {X : Type} {region : X → Prop} {gives : «际» X} {ps : List X} {kids : X → List X},
      ListedWithin ps kids gives → Outside region ps → (ps.flatMap kids).length = 0 :=
  have _form := @outside_leaves_no_offspring
  outside_leaves_no_offspring.needs_gate

set_option linter.unusedVariables false in
/-- The second review's vacuous countermodel for "given to". -/
theorem needs_given_vacuous :
    ¬ ∀ {X : Type} {comes before after : X → Prop} {descends : «际» X},
      Inherits descends before after → UndependedFrom descends before → False :=
  fun h => @h Unit everywhere nowhere everywhere noneRelated inherits_vacuous undepended_vacuous

/-- Row 5's form with an inline amount hypothesis. -/
theorem bounded_form {X : Type} {comes before after : X → Prop} {descends : «际» X} {q : X → Nat}
    (given : GivenTo comes descends) (inherits : Inherits descends before after)
    (undepended : UndependedFrom descends before) (_bound : ∀ x, comes x → q x ≤ 0) :
    ¬ ∃ x, comes x ∧ after x :=
  descent_forms_no_dependence given inherits undepended

/-- A fact whose proof names the form. -/
theorem one_offspring_through_form : ¬ (oneListed.flatMap oneOffspring).length = 0 :=
  have _form := @outside_leaves_no_offspring
  one_offspring

/-- A fit through that fact. -/
theorem gate_needed_through_fact : ¬ GivesFrom nowhere allRelated :=
  fun gate => one_offspring_through_form
    (outside_leaves_no_offspring gate listed_within_all outside_nowhere)

/-- A fit that refutes the gate directly, naming the form aside. -/
theorem gate_needed_aside : ¬ GivesFrom nowhere allRelated :=
  fun gate => match gate () () trivial with
    | ⟨_, ⟨_, inside⟩, _⟩ =>
      have _form := @outside_leaves_no_offspring
      inside

/-- A hypothesis that is the conclusion itself. -/
def Holds (a : Prop) : Prop := a

theorem holds_form {a : Prop} (holds : Holds a) : a := holds
theorem holds_form.needs_holds : ¬ ∀ {a : Prop}, a := fun h => @h False
theorem holds_form.holds_needed : ¬ Holds False := fun holds => holds_form holds

/-- Row 17 recovered through the degenerate form, by the row's own proof. -/
theorem all_end_by_holds : type_of% @GroupEnding.Flow.all_end := by
  intro X L W acting G descended t inactive
  exact holds_form (@GroupEnding.Flow.all_end X L W acting G descended t inactive)

theorem all_end_by_holds_certified : @GroupEnding.Flow.all_end = @all_end_by_holds := rfl

/-- A «» name declared off the grammar, for the name test. -/
theorem «不在文法» : True := trivial

/-- Row 17's certificate in the other order. -/
theorem all_end_certified_reversed : @all_end_at_model = @GroupEnding.Flow.all_end := rfl

/-- A theorem naming the row and the recovery that equates neither with the other. -/
theorem all_end_vacuous : @GroupEnding.Flow.all_end = @GroupEnding.Flow.all_end ∧ @all_end_at_model = @all_end_at_model :=
  ⟨rfl, rfl⟩

/-- Row 17 recovered with the form's application under a `have`. -/
theorem all_end_through_have : type_of% @GroupEnding.Flow.all_end := by
  intro X L W acting G descended t inactive
  have h := outside_leaves_no_offspring (region := W.active t)
    (gives := fun g k => g ∈ L.present t ∧ 0 < L.give t g k)
    (fun g k gives => ⟨g, ⟨rfl, acting t g k gives.1 gives.2⟩, gives⟩)
    (fun p k listed => ⟨(descended t p k listed.1 listed.2).1, (descended t p k listed.1 listed.2).2.1⟩)
    inactive
  exact h

theorem all_end_through_have_certified : @GroupEnding.Flow.all_end = @all_end_through_have := rfl

/-- A bridge: an equivalence proved by constructors alone. -/
theorem swap_bridge {a b : Prop} : a ∧ b ↔ b ∧ a := ⟨fun ⟨x, y⟩ => ⟨y, x⟩, fun ⟨x, y⟩ => ⟨y, x⟩⟩

/-- Row 17 recovered through the form, meeting descent through the bridge. -/
theorem all_end_by_bridge : type_of% @GroupEnding.Flow.all_end := by
  intro X L W acting G descended t inactive
  exact outside_leaves_no_offspring (region := W.active t)
    (gives := fun g k => g ∈ L.present t ∧ 0 < L.give t g k)
    (fun g k gives => ⟨g, ⟨rfl, acting t g k gives.1 gives.2⟩, gives⟩)
    (fun p k listed => swap_bridge.mp ⟨(descended t p k listed.1 listed.2).2.1, (descended t p k listed.1 listed.2).1⟩)
    inactive

theorem all_end_by_bridge_certified : @GroupEnding.Flow.all_end = @all_end_by_bridge := rfl

universe u

/-- A row at `Type u`, and a statement at `Type` with a certificate at `u := 0`. -/
theorem rowU {S : Type u} (s : S) : s = s := rfl
theorem atType {S : Type} (s : S) : s = s := rfl
theorem certAtZero : @rowU.{0} = @atType := rfl

end Becoming.BoundaryCheckControls
