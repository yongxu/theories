import Becoming.Grammar
import Becoming.Transmission
import Becoming.GroupEnding

/-!
# U4, the boundary record (scratch): two strict root forms

Scratch for `../DESIGN-BOUNDARY.md` §1.2 and §4, not package Lean.

**Rows 5 and 17.** The scratch writes the strict root forms of lever 2's rows 5 and 17.
- **The forms.** A form's statement names only grammar terms, `Init` and its own hypotheses. The
  relations, regions and lists it speaks of are variables. Each hypothesis is a named definition
  that names no model and no amount.
- **The countermodels.** Each hypothesis has two theorems, built on one witness over a single
  point and on the same named facts:
  - `needs_H` states that the form with that hypothesis dropped fails;
  - `H_needed` applies the form to the facts, so the kernel checks that they fit its other
    hypotheses and that its conclusion fails there.
- **The recoveries.** A recovery, stated at the row's own type (`type_of%`), gives the row from the
  form at its model. A certificate ties the two by `rfl`.

**What the forms show.** Each row's conclusion follows by logic alone from its hypotheses read as
relations, and none of those hypotheses is redundant. They do not show that a row uses the
grammar's laws: neither form reaches one. Nor do they show that the hypotheses hold: those are
premises of the account.

* **Row 5, `Flow.no_new_dependence`: its relational part.** The form is
  `descent_forms_no_dependence`. Where these three hold, nothing coming to stand depends after the
  step:
  - what comes to stand is given to (`GivenTo`);
  - dependence after the step is inherited along descent (`Inherits`);
  - nothing descended from depends before the step (`UndependedFrom`).

  The row is the form at its one relatum (`no_new_dependence_at_model`). Its balance meets "given
  to" only through amount reasoning (`Flow.descends_of_comes`), not by definitions alone. So the
  recovery does not meet the design's discharge condition, and the row stays "balance in its
  statement". The form records what in the row is relational.
* **Row 17, `GroupEnding.Flow.all_end`.** The form is `outside_leaves_no_offspring`. Where these
  hold, a listing wholly outside the region giving comes from has no listed offspring:
  - giving lies within giving from the region (`GivesFrom`);
  - listed descent lies within giving (`ListedWithin`);
  - the listing lies outside the region (`Outside`).

  The listing and its offspring lists are list facts, counting over any map. The recovery
  (`all_end_at_model`) meets each hypothesis by definitions alone.
-/

namespace Becoming

namespace U4Boundary

variable {X : Type}

/-! ## The witnesses' parts, over one point -/

/-- The region holding the one point. -/
def everywhere : Unit → Prop := fun _ => True

/-- The empty region. -/
def nowhere : Unit → Prop := fun _ => False

/-- The relation holding everywhere. -/
def allRelated : «际» Unit := fun _ _ => True

/-- The empty relation. -/
def noneRelated : «际» Unit := fun _ _ => False

/-- A listing of the one point. -/
def oneListed : List Unit := [()]

/-- One offspring for the one point. -/
def oneOffspring : Unit → List Unit := fun _ => [()]

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
    (undepended : UndependedFrom descends before) : ¬ ∃ x, comes x ∧ after x :=
  fun ⟨x, stands, depends⟩ => match given x stands with
    | ⟨g, descent⟩ => undepended x g descent (inherits x g descent depends)

/-- Over the one point, everything comes to stand and is given to by everything. -/
theorem given_everywhere : GivenTo everywhere allRelated :=
  fun x _ => ⟨x, trivial⟩

/-- Where nothing descends, inheritance holds vacuously. -/
theorem inherits_vacuous : Inherits noneRelated nowhere everywhere :=
  fun _ _ descent _ => descent

/-- Where everything depends before the step, inheritance holds. -/
theorem inherits_everywhere : Inherits allRelated everywhere everywhere :=
  fun _ _ _ _ => trivial

/-- Where nothing descends, nothing descended from depends. -/
theorem undepended_vacuous : UndependedFrom noneRelated nowhere :=
  fun _ _ descent _ => descent

/-- Where nothing depends before the step, nothing descended from depends. -/
theorem undepended_nowhere : UndependedFrom allRelated nowhere :=
  fun _ _ _ before => before

/-- Over the one point, something coming to stand depends after the step. -/
theorem some_depends : ¬ ¬ ∃ x, everywhere x ∧ everywhere x :=
  fun none => none ⟨(), trivial, trivial⟩

/-- "Given to" cannot be dropped: nothing descends, and the one point comes to stand and depends
after the step. -/
theorem descent_forms_no_dependence.needs_given :
    ¬ ∀ {X : Type} {comes before after : X → Prop} {descends : «际» X},
      Inherits descends before after → UndependedFrom descends before → ¬ ∃ x, comes x ∧ after x :=
  fun h => some_depends (@h Unit everywhere nowhere everywhere noneRelated inherits_vacuous
    undepended_vacuous)

/-- The fit: at that witness "given to" fails, by the form. -/
theorem descent_forms_no_dependence.given_needed : ¬ GivenTo everywhere noneRelated :=
  fun given => some_depends (descent_forms_no_dependence given inherits_vacuous undepended_vacuous)

/-- Inheritance cannot be dropped: everything descends from everything, nothing depends before
the step, and everything depends after it. -/
theorem descent_forms_no_dependence.needs_inherits :
    ¬ ∀ {X : Type} {comes before after : X → Prop} {descends : «际» X},
      GivenTo comes descends → UndependedFrom descends before → ¬ ∃ x, comes x ∧ after x :=
  fun h => some_depends (@h Unit everywhere nowhere everywhere allRelated given_everywhere
    undepended_nowhere)

/-- The fit: at that witness inheritance fails, by the form. -/
theorem descent_forms_no_dependence.inherits_needed : ¬ Inherits allRelated nowhere everywhere :=
  fun inherits => some_depends (descent_forms_no_dependence given_everywhere inherits
    undepended_nowhere)

/-- "Nothing descended from depends" cannot be dropped: everything descends from everything and
depends before and after the step. -/
theorem descent_forms_no_dependence.needs_undepended :
    ¬ ∀ {X : Type} {comes before after : X → Prop} {descends : «际» X},
      GivenTo comes descends → Inherits descends before after → ¬ ∃ x, comes x ∧ after x :=
  fun h => some_depends (@h Unit everywhere everywhere everywhere allRelated given_everywhere
    inherits_everywhere)

/-- The fit: at that witness "nothing descended from depends" fails, by the form. -/
theorem descent_forms_no_dependence.undepended_needed : ¬ UndependedFrom allRelated everywhere :=
  fun undepended => some_depends (descent_forms_no_dependence given_everywhere inherits_everywhere
    undepended)

/-- **Row 5 at its model, its relational part.** `Flow.no_new_dependence` is the form at its
relatum `x`:
- descent is `L.DescendsAt W t x`;
- dependence before and after the step is requiring `c` at `t` and at `t + 1`;
- the region coming to stand is `x` where it comes to stand.

The row's balance at `x` meets "given to" through `Flow.descends_of_comes`, which is amount
reasoning: balance and a rise from nothing give a positive giving. -/
theorem no_new_dependence_at_model : type_of% @Flow.no_new_dependence := by
  intro X L W t x c balances inherits none comes depends
  exact descent_forms_no_dependence (comes := fun y => y = x ∧ W.ComesToStand t y)
    (before := fun g => W.requires t g c) (after := fun y => W.requires (t + 1) y c)
    (descends := fun y g => y = x ∧ L.DescendsAt W t x g)
    (fun _ ⟨at_x, stands⟩ => match Flow.descends_of_comes balances (at_x ▸ stands) with
      | ⟨g, descent⟩ => ⟨g, at_x, descent⟩)
    (fun _ g ⟨at_x, descent⟩ dependsAfter => inherits g descent (at_x ▸ dependsAfter))
    (fun _ g ⟨_, descent⟩ => none g descent.1) ⟨x, ⟨rfl, comes⟩, depends⟩

/-- The certificate: the recovery states exactly the row. -/
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

/-- Over the one point, everything gives, and the region holding it is the one giving. -/
theorem gives_from_everywhere : GivesFrom everywhere allRelated :=
  fun x _ _ => ⟨x, ⟨rfl, trivial⟩, trivial⟩

/-- Where nothing gives, giving comes from any region, the empty one included. -/
theorem gives_from_vacuous : GivesFrom nowhere noneRelated :=
  fun _ _ gives => False.elim gives

/-- Where everything gives, listed descent lies within giving. -/
theorem listed_within_all : ListedWithin oneListed oneOffspring allRelated :=
  fun _ _ _ => trivial

/-- Nothing is in the empty region. -/
theorem outside_nowhere : Outside nowhere oneListed :=
  fun _ _ inside => inside

/-- The one point has an offspring. -/
theorem one_offspring : ¬ (oneListed.flatMap oneOffspring).length = 0 :=
  Naturals.succ_ne_zero 0

/-- The gate cannot be dropped: everything gives, nothing is in the region, and the one listed
member has an offspring. -/
theorem outside_leaves_no_offspring.needs_gate :
    ¬ ∀ {X : Type} {region : X → Prop} {gives : «际» X} {ps : List X} {kids : X → List X},
      ListedWithin ps kids gives → Outside region ps → (ps.flatMap kids).length = 0 :=
  fun h => one_offspring (@h Unit nowhere allRelated oneListed oneOffspring listed_within_all
    outside_nowhere)

/-- The fit: at that witness the gate fails, by the form. -/
theorem outside_leaves_no_offspring.gate_needed : ¬ GivesFrom nowhere allRelated :=
  fun gate => one_offspring (outside_leaves_no_offspring gate listed_within_all outside_nowhere)

/-- Descent within giving cannot be dropped: nothing gives, and the one listed member has an
offspring. -/
theorem outside_leaves_no_offspring.needs_descent :
    ¬ ∀ {X : Type} {region : X → Prop} {gives : «际» X} {ps : List X} {kids : X → List X},
      GivesFrom region gives → Outside region ps → (ps.flatMap kids).length = 0 :=
  fun h => one_offspring (@h Unit nowhere noneRelated oneListed oneOffspring gives_from_vacuous
    outside_nowhere)

/-- The fit: at that witness descent within giving fails, by the form. -/
theorem outside_leaves_no_offspring.descent_needed :
    ¬ ListedWithin oneListed oneOffspring noneRelated :=
  fun descent => one_offspring (outside_leaves_no_offspring gives_from_vacuous descent
    outside_nowhere)

/-- "Outside the region" cannot be dropped: everything gives and is in the region, and the one
listed member has an offspring. -/
theorem outside_leaves_no_offspring.needs_outside :
    ¬ ∀ {X : Type} {region : X → Prop} {gives : «际» X} {ps : List X} {kids : X → List X},
      GivesFrom region gives → ListedWithin ps kids gives → (ps.flatMap kids).length = 0 :=
  fun h => one_offspring (@h Unit everywhere allRelated oneListed oneOffspring
    gives_from_everywhere listed_within_all)

/-- The fit: at that witness "outside the region" fails, by the form. -/
theorem outside_leaves_no_offspring.outside_needed : ¬ Outside everywhere oneListed :=
  fun outside => one_offspring (outside_leaves_no_offspring gives_from_everywhere listed_within_all
    outside)

/-- **Row 17 at its model.** `GroupEnding.Flow.all_end` is the form at one step:
- giving is a member taking part giving a positive amount;
- the region is activity at the step;
- the listing is the generation, with its offspring lists.

"Only active formations give" meets the gate, and descent meets "listed descent lies within
giving", each by definitions alone. The next generation's size is the length of the offspring
lists' join, by `family`'s definition. -/
theorem all_end_at_model : type_of% @GroupEnding.Flow.all_end := by
  intro X L W acting G descended t inactive
  exact outside_leaves_no_offspring (region := W.active t)
    (gives := fun g k => g ∈ L.present t ∧ 0 < L.give t g k)
    (fun g k gives => ⟨g, ⟨rfl, acting t g k gives.1 gives.2⟩, gives⟩)
    (fun p k listed => ⟨(descended t p k listed.1 listed.2).1, (descended t p k listed.1 listed.2).2.1⟩)
    inactive

/-- The certificate: the recovery states exactly the row. -/
theorem all_end_certified : @GroupEnding.Flow.all_end = @all_end_at_model := rfl

end U4Boundary

end Becoming
