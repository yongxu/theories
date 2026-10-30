import Becoming.Grammar
import Becoming.Transmission
import Becoming.GroupEnding

/-!
# U4, the boundary record (scratch): two rows under stated hypotheses

Scratch for `../DESIGN-BOUNDARY.md` §1.2 and §4, not package Lean. It writes the strict root forms
of lever 2's rows 5 and 17. Each form's statement names grammar terms, `Init` and its own
hypotheses only. The relations and regions it speaks of are variables, and each hypothesis is a
named definition naming no model. For each hypothesis, a countermodel is stated as the negation of
the form with that one hypothesis dropped. A bridge, stated at the row's own type (`type_of%`),
gives the row as the form at its model, and a certificate ties the two by `rfl`.

* **Row 5, `Flow.no_new_dependence`.** Nothing coming to stand depends on what nothing it descends
  from depended on (`descent_forms_no_dependence`). Its hypotheses:
  - what comes to stand is given to (`GivenTo`);
  - dependence after the step is inherited along descent (`Inherits`);
  - nothing descended from depends before the step (`UndependedFrom`).

  The row takes balance at its relatum, an equation of amounts, which is more than the form needs:
  balance meets "given to" (`Flow.descends_of_comes`). The form at the relations restricted to the
  row's relatum is the row (`no_new_dependence_at_model`).
* **Row 17, `GroupEnding.Flow.all_end`.** A listing wholly outside the region giving comes from has
  no listed offspring (`outside_leaves_no_offspring`). Its hypotheses:
  - giving lies within giving from the region (`GivesFrom`);
  - listed descent lies within giving (`ListedWithin`);
  - the listing lies outside the region (`Outside`).

  The listing and its offspring lists are list facts, counting over any map. The form at one step's
  giving, activity and generation is the row (`all_end_at_model`).
-/

namespace Becoming

namespace U4Boundary

variable {X : Type}

/-! ## Row 5: descent forms no new dependence -/

/-- What comes to stand is given to: each member of the region `comes` descends from something. -/
def GivenTo (comes : X → Prop) (descends : «际» X) : Prop :=
  ∀ x, comes x → ∃ g, descends x g

/-- Dependence after the step is inherited along descent: what depends after it depends on what
it descends from before it. -/
def Inherits (descends : «际» X) (before after : X → Prop) : Prop :=
  ∀ x g, descends x g → after x → before g

/-- Nothing descended from depends before the step. -/
def UndependedFrom (descends : «际» X) (before : X → Prop) : Prop :=
  ∀ x g, descends x g → ¬ before g

/-- **Descent forms no new dependence, on the root.** Where what comes to stand is given to,
dependence is inherited along descent, and nothing descended from depends before the step, nothing
coming to stand depends after it. -/
theorem descent_forms_no_dependence {comes before after : X → Prop} {descends : «际» X}
    (given : GivenTo comes descends) (inherits : Inherits descends before after)
    (undepended : UndependedFrom descends before) : ∀ x, comes x → ¬ after x :=
  fun x stands depends => match given x stands with
    | ⟨g, descent⟩ => undepended x g descent (inherits x g descent depends)

/-- "Given to" cannot be dropped: nothing descends, and what comes to stand depends after the
step. -/
theorem descent_forms_no_dependence.needs_given :
    ¬ ∀ {X : Type} {comes before after : X → Prop} {descends : «际» X},
      Inherits descends before after → UndependedFrom descends before → ∀ x, comes x → ¬ after x :=
  fun h => @h Unit (fun _ => True) (fun _ => False) (fun _ => True) (fun _ _ => False)
    (fun _ _ descent _ => descent) (fun _ _ descent _ => descent) () trivial trivial

/-- Inheritance cannot be dropped: everything descends from everything, nothing depends before
the step, and everything depends after it. -/
theorem descent_forms_no_dependence.needs_inherits :
    ¬ ∀ {X : Type} {comes before after : X → Prop} {descends : «际» X},
      GivenTo comes descends → UndependedFrom descends before → ∀ x, comes x → ¬ after x :=
  fun h => @h Unit (fun _ => True) (fun _ => False) (fun _ => True) (fun _ _ => True)
    (fun x _ => ⟨x, trivial⟩) (fun _ _ _ before => before) () trivial trivial

/-- "Nothing descended from depends" cannot be dropped: everything descends from everything and
depends before and after the step. -/
theorem descent_forms_no_dependence.needs_undepended :
    ¬ ∀ {X : Type} {comes before after : X → Prop} {descends : «际» X},
      GivenTo comes descends → Inherits descends before after → ∀ x, comes x → ¬ after x :=
  fun h => @h Unit (fun _ => True) (fun _ => True) (fun _ => True) (fun _ _ => True)
    (fun x _ => ⟨x, trivial⟩) (fun _ _ _ _ => trivial) () trivial trivial

/-- **Row 5 at its model.** `Flow.no_new_dependence` is the form at the relations restricted to
its relatum `x`: descent is `L.DescendsAt W t x`, dependence before and after the step is
requiring `c` at `t` and at `t + 1`, and the region coming to stand is `x` alone. The row's
balance at `x` meets "given to" (`Flow.descends_of_comes`); descent includes taking part, so the
row's `none` meets "nothing descended from depends". -/
theorem no_new_dependence_at_model : type_of% @Flow.no_new_dependence := by
  intro X L W t x c balances inherits none comes
  exact descent_forms_no_dependence (comes := fun y => y = x)
    (before := fun g => W.requires t g c) (after := fun y => W.requires (t + 1) y c)
    (descends := fun y g => y = x ∧ L.DescendsAt W t x g)
    (fun _ at_x => match Flow.descends_of_comes balances comes with
      | ⟨g, descent⟩ => ⟨g, at_x, descent⟩)
    (fun _ g ⟨at_x, descent⟩ depends => inherits g descent (at_x ▸ depends))
    (fun _ g ⟨_, descent⟩ => none g descent.1) x rfl

/-- The certificate: the bridge states exactly the row. -/
theorem no_new_dependence_certified : @Flow.no_new_dependence = @no_new_dependence_at_model := rfl

/-! ## Row 17: a listing outside the giving region has no offspring -/

/-- Giving comes only from the region: giving lies within giving from a member of `region`. -/
def GivesFrom (region : X → Prop) (gives : «际» X) : Prop :=
  «则» gives («而» (fun x y => x = y ∧ region x) gives)

/-- Listed descent lies within giving: each listed offspring of a listed member is given to by
it. -/
def ListedWithin (ps : List X) (kids : X → List X) (gives : «际» X) : Prop :=
  «则» (fun p k => p ∈ ps ∧ k ∈ kids p) gives

/-- The listing lies outside the region. -/
def Outside (region : X → Prop) (ps : List X) : Prop :=
  ∀ p, p ∈ ps → ¬ region p

/-- A successor is not zero (Init's `Nat.succ_ne_zero` carries `propext` in this toolchain). -/
theorem succ_ne_zero {n : Nat} : n + 1 ≠ 0 := fun h => Nat.noConfusion h

/-- A list with no member is empty. -/
theorem length_zero_of_none : ∀ {ks : List X}, (∀ k, ¬ k ∈ ks) → ks.length = 0
  | [], _ => rfl
  | k :: _, empty => absurd (List.Mem.head _) (empty k)

/-- **A listing outside the giving region has no offspring, on the root.** Where giving lies
within giving from a region, and listed descent within giving, a listing wholly outside the region
has no listed offspring. -/
theorem outside_leaves_no_offspring {region : X → Prop} {gives : «际» X} {ps : List X}
    {kids : X → List X} (gate : GivesFrom region gives) (descent : ListedWithin ps kids gives)
    (outside : Outside region ps) : (ps.flatMap kids).length = 0 :=
  length_zero_of_none fun k mk => match ListTests.mem_flatMap_iff.mp mk with
    | ⟨p, mp, kp⟩ => match gate p k (descent p k ⟨mp, kp⟩) with
      | ⟨_, ⟨rfl, inside⟩, _⟩ => outside p mp inside

/-- The gate cannot be dropped: everything gives, nothing is in the region, and the one listed
member has an offspring. -/
theorem outside_leaves_no_offspring.needs_gate :
    ¬ ∀ {X : Type} {region : X → Prop} {gives : «际» X} {ps : List X} {kids : X → List X},
      ListedWithin ps kids gives → Outside region ps → (ps.flatMap kids).length = 0 :=
  fun h => absurd (@h Unit (fun _ => False) (fun _ _ => True) [()] (fun _ => [()])
    (fun _ _ _ => trivial) (fun _ _ outside => outside)) succ_ne_zero

/-- Descent within giving cannot be dropped: nothing gives, and the one listed member has an
offspring. -/
theorem outside_leaves_no_offspring.needs_descent :
    ¬ ∀ {X : Type} {region : X → Prop} {gives : «际» X} {ps : List X} {kids : X → List X},
      GivesFrom region gives → Outside region ps → (ps.flatMap kids).length = 0 :=
  fun h => absurd (@h Unit (fun _ => False) (fun _ _ => False) [()] (fun _ => [()])
    (fun _ _ gives => gives.elim) (fun _ _ outside => outside)) succ_ne_zero

/-- "Outside the region" cannot be dropped: everything gives and is in the region, and the one
listed member has an offspring. -/
theorem outside_leaves_no_offspring.needs_outside :
    ¬ ∀ {X : Type} {region : X → Prop} {gives : «际» X} {ps : List X} {kids : X → List X},
      GivesFrom region gives → ListedWithin ps kids gives → (ps.flatMap kids).length = 0 :=
  fun h => absurd (@h Unit (fun _ => True) (fun _ _ => True) [()] (fun _ => [()])
    (fun x _ _ => ⟨x, ⟨rfl, trivial⟩, trivial⟩) (fun _ _ _ => trivial))
    succ_ne_zero

/-- **Row 17 at its model.** `GroupEnding.Flow.all_end` is the form at one step: giving is a
member taking part giving a positive amount, the region is activity at the step, and the listing
is the generation with its offspring lists. "Only active formations give" meets the gate, descent
meets "listed descent lies within giving", and the next generation's size is the length of the
offspring lists' join by `family`'s definition. -/
theorem all_end_at_model : type_of% @GroupEnding.Flow.all_end := by
  intro X L W acting G descended t inactive
  exact outside_leaves_no_offspring (region := W.active t)
    (gives := fun g k => g ∈ L.present t ∧ 0 < L.give t g k)
    (fun g k gives => ⟨g, ⟨rfl, acting t g k gives.1 gives.2⟩, gives⟩)
    (fun p k listed => ⟨(descended t p k listed.1 listed.2).1, (descended t p k listed.1 listed.2).2.1⟩)
    inactive

/-- The certificate: the bridge states exactly the row. -/
theorem all_end_certified : @GroupEnding.Flow.all_end = @all_end_at_model := rfl

end U4Boundary

end Becoming
