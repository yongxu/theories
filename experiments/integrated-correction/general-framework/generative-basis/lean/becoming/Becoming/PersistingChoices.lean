import Becoming.Weightings
import Becoming.MutualDependence
import Becoming.ShownOrder

/-!
# PersistingChoices: what persisting shows of an order (所续之示)

Self-concern, an order increasing in one's own continuation (`Weighting.IncreasingInOwn`), enters every
ranking result that uses it as a hypothesis, and the continuation condition read de se takes its relation
and its class as given. This module asks what the dynamics give in place of self-concern, and where every
center's closure is the whole, and says where each answer stops (board item ZA; which class is one's own is
board item ZC's, `Becoming.OwnClass`, and which formations are centers ZA-G1's, `Becoming.FlowCenters`).

* **Mutual dependence gives the condition held de se, along being affected and along affecting.** In a
  mutually dependent flow, significance held de se as what lies within a center's closure under being
  affected (what can affect its continuation, at some remove), or under affecting (what it can affect, at
  some remove), is the continuation condition (`Flow.unrestricted_of_mutuallyDependent`); where every
  formation is some standpoint's center, each is exactly mutual dependence
  (`Flow.mutuallyDependent_iff_unrestricted`). In `Clearing`, every formation a center, neither holds
  (`Clearing.not_unrestricted_ownClosure`). Mutual dependence is closure under being affected; mutual
  feeding gives it, and not conversely (`Becoming.MutualDependence`).
* **Choices with comparisons required.** Read a relation's pairs as further occasions of choosing
  (`ChoiceOccasions.withPairs`). Some strict order accords with the choices and makes every required
  comparison exactly where the shown relation with those pairs added has no cycle
  (`ChoiceOccasions.accorded_containing_iff`); every such order shares exactly that relation's reach
  (`ChoiceOccasions.above_in_every_containing_iff_reach`), and beyond it some such order ranks either way
  (`ChoiceOccasions.above_in_some_containing_of_unreached`). These are `ShownOrder`'s laws on the
  enlarged occasions.
* **Where no choice ends, keeping stands above ending.** Let `ends` be any predicate on alternatives, read
  as ending what the chooser depends on. Where the choices come from some strict order and no chosen
  alternative ends, some strict order according with them puts every alternative that does not end above
  every one that ends and was open with it (`ChoiceOccasions.keeping_above_ending`).
* **Self-concern on the occasions met: consistent with the choices, not shown to be held.** Read an order
  on courses as increasing in its own continuation on the pairs met together
  (`Weighting.IncreasingInOwnOn`). Some strict order according with the choices is so exactly where the
  shown relation with every own-widening met added has no cycle
  (`ChoiceOccasions.selfConcerned_consistent_iff`). Where the choices come from some strict order, no
  chosen course ends, and on the occasions met a course adds to the own continuation beyond one it widens
  only where it does not end and the other does, some is (`ChoiceOccasions.selfConcerned_consistent_of_kept`),
  as where every course open keeps all of the own continuation listed or none
  (`ChoiceOccasions.selfConcerned_consistent_of_allOrNone`). Off the occasions met it is free: where some
  such order exists and a course met nowhere widens another and adds to the own continuation, some strict
  order according with the choices and increasing in its own continuation on the pairs met ranks the other
  above it, and so is not increasing in its own continuation (`ChoiceOccasions.reversed_off_met`). Pairs
  never met together, of courses each met, can still be fixed through what was met, by transitivity.
* **A line that persists never overdrew what it depends on.** On the World, under balance, only active
  formations giving and activity needing support, with the renewal of a family of conditions gated on the
  family and every member of every cohort of descent depending on the family, each at a need of at least
  `m`, a line with members in arbitrarily late cohorts (`SelectionTerm.Generations.Persists`) never had the
  family's uptake exceed its replenishment for `n` steps from a stock below `n + m`
  (`Flow.persists_never_overdraws`, from `GroupEnding.Flow.family_childless`). Where a chosen course that
  ends what the line depends on is realized as such an overdraw, the persisting line's choices, coming from
  some strict order, are consistent with self-concern on the occasions met wherever only ending was at stake
  there (`Flow.persisting_consistent_with_selfConcern`).
* **A witness: the stake cannot be dropped.** In `PersistingChoices.Forgoing` a line of one member a step,
  each giving the next its standing and all requiring a commons, balances, acts, depends and descends, and
  persists; it never overdraws (`PersistingChoices.Forgoing.never_overdraws`). Offered, as courses on a
  listing, one more child, the line as it is, or an ending, it chooses the line as it is, a choice according
  with a strict order (the witness's stipulated valuation, `PersistingChoices.Forgoing.order_accords`). No
  choice ends, and some strict order according with its choice puts both keeping courses above the ending
  (`PersistingChoices.Forgoing.keeping_above_drain`); no strict order according with it is increasing in
  its own continuation on the occasion met, the chosen course being widened by one adding to the own
  continuation (`PersistingChoices.Forgoing.persists_not_selfConcerned`). With ending read as admitting none
  of the own continuation, it meets every premise of `Flow.persisting_consistent_with_selfConcern` but the
  stake; there no reading of ending meets both the stake and `realized` (argued from `never_overdraws`,
  `kept` and `not_selfConcerned`; no single theorem states it). The choice is tied to the flow by
  `realized` alone, which holds vacuously, and the line persists whatever is chosen.

**Readings** (the AI's; correspondences, not theorems).
- *Survivorship.* Persisting is a filter on what was chosen, not a mechanism forming an order. Where a choice
  ending what the line depends on is realized as an overdraw, persisting removes such choices, and leaves the
  choices consistent with ranking keeping above ending where that was at stake; where degrees of keeping are
  at stake it does not force self-concern (the witness).
- *Goal misgeneralization.* Whatever persisting fixes, it fixes on the occasions met; where some consistent
  order is self-concerned there, a course never met can be ranked below the course it widens by strict
  orders according with every choice (`ChoiceOccasions.reversed_off_met`; as in
  `ChoiceOccasions.Untried`, and for a trained response `Training.response_free_where_unlumped`).
- *Revealed preference.* `ChoiceOccasions.selfConcerned_consistent_iff` is rationalizing strict choices by a
  strict partial order (Richter 1966) with required comparisons added.

**What is not derived.** That an actual formation chooses by a strict order, or among these courses; that a
chosen course ending what the line depends on is realized as an overdraw (`realized`, the one premise linking
the choices to the flow); the stake premise; that any order is held, rather than consistent with the choices;
that persisting selects between degrees of keeping; anything on occasions not met; that an actual web is
mutually dependent; which relation a center's concern is drawn along, the own-closure reading being supplied;
which formations are centers.

Every declaration has an empty axiom report. No ethical predicate or normative premise is introduced; the
orders are supplied mathematical relations.
-/

namespace Becoming

/-! ## Mutual dependence and the condition held de se -/

namespace Flow

variable {F C Pos : Type} {L : Flow F C} {W : Web F C}

/-- **Mutual dependence gives the continuation condition held de se, along being affected and along
affecting.** In a mutually dependent flow, significance held de se as what lies within a center's closure
under being affected (what can affect the center's continuation, at some remove) is the continuation
condition, and so is significance held de se as what lies within its closure under affecting (what it can
affect, at some remove), for every assignment of centers: the first by definition of mutual dependence, the
second through `mutuallyDependent_iff_reach`. -/
theorem unrestricted_of_mutuallyDependent (dependent : L.MutuallyDependent W) (center : Pos → F) :
    Unrestricted (selfAscribed (ownClosure (L.AffectedBy W)) center) ∧
      Unrestricted (selfAscribed (ownClosure (L.Affects W)) center) :=
  ⟨ownClosure_unrestricted_of_whole fun p g => dependent (center p) g,
   ownClosure_unrestricted_of_whole fun p g => mutuallyDependent_iff_reach.mp dependent (center p) g⟩

/-- **Where every formation is a center, each de se reading is mutual dependence.** Where every formation is
some standpoint's center, the continuation condition holds for the own closure under being affected, held
de se, exactly where the flow is mutually dependent, and likewise for the own closure under affecting. -/
theorem mutuallyDependent_iff_unrestricted {center : Pos → F} (onto : ∀ f, ∃ p, center p = f) :
    (L.MutuallyDependent W ↔ Unrestricted (selfAscribed (ownClosure (L.AffectedBy W)) center)) ∧
      (L.MutuallyDependent W ↔ Unrestricted (selfAscribed (ownClosure (L.Affects W)) center)) :=
  ⟨⟨fun dependent => (unrestricted_of_mutuallyDependent dependent center).1,
    fun unrestricted f g => match onto f with
      | ⟨p, at_⟩ => Eq.subst (motive := fun x => L.WithinInfluence W x g) at_
          (ownClosure_unrestricted_iff.mp unrestricted p g)⟩,
   ⟨fun dependent => (unrestricted_of_mutuallyDependent dependent center).2,
    fun unrestricted => mutuallyDependent_iff_reach.mpr fun f g => match onto f with
      | ⟨p, at_⟩ => Eq.subst (motive := fun x => L.WithinReach W x g) at_
          (ownClosure_unrestricted_iff.mp unrestricted p g)⟩⟩

end Flow

namespace Clearing

/-- **In the clearer's world neither de se reading is the condition.** With every formation its own center,
the own closure under being affected and the own closure under affecting, each held de se, leave some
formation out: the flow is not mutually dependent, the dweller lying beyond the clearer's influence closure
(`shares_not_mutual`). -/
theorem not_unrestricted_ownClosure :
    ¬ Unrestricted (selfAscribed (ownClosure (flow.AffectedBy web)) (fun f : Formation => f)) ∧
      ¬ Unrestricted (selfAscribed (ownClosure (flow.Affects web)) (fun f : Formation => f)) :=
  have onto : ∀ f : Formation, ∃ p : Formation, (fun f : Formation => f) p = f := fun f => ⟨f, rfl⟩
  ⟨fun unrestricted => shares_not_mutual.2 ((Flow.mutuallyDependent_iff_unrestricted onto).1.mpr
      unrestricted),
   fun unrestricted => shares_not_mutual.2 ((Flow.mutuallyDependent_iff_unrestricted onto).2.mpr
      unrestricted)⟩

end Clearing

/-! ## Choices with comparisons added -/

namespace ChoiceOccasions

universe u v

variable {α : Type u} {O : Type v}

/-- **The choices with a relation's pairs added as choices.** Each pair `x`, `y` related by `Q` is read as one
more occasion, at which `x` and `y` are open and `x` is chosen. -/
def withPairs (ch : ChoiceOccasions α O) (Q : «际» α) :
    ChoiceOccasions α (O ⊕ {p : α × α // Q p.1 p.2}) where
  menu o := match o with
    | .inl o => ch.menu o
    | .inr p => fun z => z = p.1.1 ∨ z = p.1.2
  pick o := match o with
    | .inl o => ch.pick o
    | .inr p => p.1.1

/-- Two alternatives are met together: at some occasion both are open. -/
def Met (ch : ChoiceOccasions α O) (a b : α) : Prop := ∃ o, ch.menu o a ∧ ch.menu o b

/-- An alternative the choices never meet: open at no occasion and chosen at none. -/
def Unmet (ch : ChoiceOccasions α O) (a : α) : Prop := (∀ o, ¬ ch.menu o a) ∧ ∀ o, ch.pick o ≠ a

variable {ch : ChoiceOccasions α O} {Q : «际» α}

/-- What the enlarged occasions show is what the choices show, or a pair of `Q` of two different
alternatives. -/
theorem shown_withPairs_iff {x y : α} :
    (ch.withPairs Q).Shown x y ↔ ch.Shown x y ∨ (Q x y ∧ y ≠ x) := by
  constructor
  · intro shown
    match shown with
    | ⟨.inl o, picked, open_y, other⟩ => exact .inl ⟨o, picked, open_y, other⟩
    | ⟨.inr ⟨(a, b), q⟩, picked, open_y, other⟩ =>
      change a = x at picked
      subst picked
      change y = a ∨ y = b at open_y
      cases open_y with
      | inl same => exact absurd same other
      | inr is_b =>
        subst is_b
        exact .inr ⟨q, other⟩
  · intro found
    match found with
    | .inl ⟨o, picked, open_y, other⟩ => exact ⟨.inl o, picked, open_y, other⟩
    | .inr ⟨q, other⟩ => exact ⟨.inr ⟨(x, y), q⟩, rfl, .inr rfl, other⟩

/-- A relation accords with the enlarged occasions exactly where it accords with the choices and makes
every comparison `Q` asks between two different alternatives. -/
theorem accords_withPairs_iff {P : «际» α} :
    (ch.withPairs Q).Accords P ↔ ch.Accords P ∧ ∀ x y, Q x y → y ≠ x → P x y := by
  constructor
  · intro accords
    exact ⟨fun o y open_y other => accords (.inl o) y open_y other,
      fun x y q other => accords (.inr ⟨(x, y), q⟩) y (.inr rfl) other⟩
  · intro both o y open_y other
    match o, open_y, other with
    | .inl o, open_y, other => exact both.1 o y open_y other
    | .inr ⟨(a, b), q⟩, open_y, other =>
      change y = a ∨ y = b at open_y
      change y ≠ a at other
      change P a y
      cases open_y with
      | inl same => exact absurd same other
      | inr is_b =>
        subst is_b
        exact both.2 a y q other

/-- **Choices and required comparisons, together.** Some irreflexive transitive relation accords with
the choices and puts `x` above `y` wherever `Q` relates two different alternatives exactly where the shown
relation with `Q`'s pairs added has no cycle (`accorded_iff_noCycle` on the enlarged occasions). -/
theorem accorded_containing_iff :
    (∃ P : «际» α, (∀ x, ¬ P x x) ∧ (∀ x y z, P x y → P y z → P x z) ∧ ch.Accords P ∧
        ∀ x y, Q x y → y ≠ x → P x y) ↔
      «无环» (ch.withPairs Q).Shown :=
  ⟨fun ⟨P, irrefl, trans, accords, contains⟩ =>
     accorded_iff_noCycle.mp ⟨P, irrefl, trans, accords_withPairs_iff.mpr ⟨accords, contains⟩⟩,
   fun none => match accorded_iff_noCycle.mpr none with
    | ⟨P, irrefl, trans, accords⟩ =>
      ⟨P, irrefl, trans, (accords_withPairs_iff.mp accords).1, (accords_withPairs_iff.mp accords).2⟩⟩

/-- **The comparisons shared.** With no cycle in the shown relation with `Q`'s pairs added, `x` stands
above `y` in every strict order according with the choices and making `Q`'s comparisons exactly where `x`
reaches `y` in that relation. -/
theorem above_in_every_containing_iff_reach (none : «无环» (ch.withPairs Q).Shown) {x y : α} :
    (∀ P : «际» α, (∀ a, ¬ P a a) → (∀ a b c, P a b → P b c → P a c) → ch.Accords P →
        (∀ a b, Q a b → b ≠ a → P a b) → P x y) ↔
      «及» (ch.withPairs Q).Shown x y :=
  ⟨fun every => (above_in_every_iff_reach none).mp fun P irrefl trans accords =>
      every P irrefl trans (accords_withPairs_iff.mp accords).1 (accords_withPairs_iff.mp accords).2,
   fun reach P irrefl trans accords contains =>
     (above_in_every_iff_reach none).mpr reach P irrefl trans
       (accords_withPairs_iff.mpr ⟨accords, contains⟩)⟩

/-- **Beyond that reach, free.** With no cycle in the shown relation with `Q`'s pairs added, where `y` does
not reach `x` in it and the two differ, some strict order according with the choices and making `Q`'s
comparisons puts `x` above `y`. -/
theorem above_in_some_containing_of_unreached (none : «无环» (ch.withPairs Q).Shown) {x y : α}
    (apart : x ≠ y) (unreached : ¬ «及» (ch.withPairs Q).Shown y x) :
    ∃ P : «际» α, (∀ a, ¬ P a a) ∧ (∀ a b c, P a b → P b c → P a c) ∧ ch.Accords P ∧
      (∀ a b, Q a b → b ≠ a → P a b) ∧ P x y :=
  match above_in_some_of_unreached none apart unreached with
  | ⟨P, irrefl, trans, accords, above⟩ =>
    ⟨P, irrefl, trans, (accords_withPairs_iff.mp accords).1, (accords_withPairs_iff.mp accords).2,
     above⟩

/-- A reach begins with a step. -/
theorem reach_first_step {R : «际» α} {a b : α} (reach : «及» R a b) : ∃ c, R a c :=
  match reach with
  | .one h => ⟨_, h⟩
  | .more h _ => ⟨_, h⟩

/-- Nothing is reached from an alternative the choices never meet, where `Q` relates it to something only
if it is open at some occasion. -/
theorem not_reach_of_unmet {a b : α} (unmet : ch.Unmet a) (from_met : ∀ y, Q a y → ∃ o, ch.menu o a) :
    ¬ «及» (ch.withPairs Q).Shown a b :=
  fun reach => match reach_first_step reach with
    | ⟨_, step⟩ => match shown_withPairs_iff.mp step with
      | .inl ⟨o, picked, _, _⟩ => unmet.2 o picked
      | .inr ⟨q, _⟩ => match from_met _ q with
        | ⟨o, open_a⟩ => unmet.1 o open_a

/-! ## Keeping above ending -/

/-- **Where no choice ends, a path ends at most once.** Let no chosen alternative end (`ends`), and let `Q`
run only from what does not end to what ends. Then whatever an alternative reaches in the shown relation
with `Q`'s pairs added, it reaches in the shown relation alone, or what it reaches ends. -/
theorem reach_withPairs_of_kept {ends : α → Prop} (kept : ∀ o, ¬ ends (ch.pick o))
    (runs : ∀ x y, Q x y → ¬ ends x ∧ ends y) {a c : α}
    (reach : «及» (ch.withPairs Q).Shown a c) : «及» ch.Shown a c ∨ ends c := by
  have source : ∀ x y, (ch.withPairs Q).Shown x y → ¬ ends x := fun x y step =>
    match shown_withPairs_iff.mp step with
    | .inl ⟨o, picked, _, _⟩ => picked ▸ kept o
    | .inr ⟨q, _⟩ => (runs x y q).1
  induction reach with
  | one h =>
    cases shown_withPairs_iff.mp h with
    | inl s => exact .inl (.one s)
    | inr q => exact .inr (runs _ _ q.1).2
  | more h rest ih =>
    cases shown_withPairs_iff.mp h with
    | inl s =>
      cases ih with
      | inl r => exact .inl (.more s r)
      | inr e => exact .inr e
    | inr q =>
      match reach_first_step rest with
      | ⟨_, step⟩ => exact absurd (runs _ _ q.1).2 (source _ _ step)

/-- **What ends is a sink.** Where no chosen alternative ends and `Q` runs only from what does not end to
what ends, the shown relation with `Q`'s pairs added has a cycle only where the shown relation has one. -/
theorem noCycle_withPairs_of_kept {ends : α → Prop} (none : «无环» ch.Shown)
    (kept : ∀ o, ¬ ends (ch.pick o)) (runs : ∀ x y, Q x y → ¬ ends x ∧ ends y) :
    «无环» (ch.withPairs Q).Shown :=
  fun a loop => match reach_withPairs_of_kept kept runs loop with
    | .inl back => none a back
    | .inr ended => match reach_first_step loop with
      | ⟨_, step⟩ => match shown_withPairs_iff.mp step with
        | .inl ⟨o, picked, _, _⟩ => kept o (picked ▸ ended)
        | .inr ⟨q, _⟩ => (runs _ _ q).1 ended

/-- **Where no choice ends, keeping stands above ending.** Where the choices come from some strict order
(no cycle shown) and no chosen alternative ends (`ends`, any predicate, read as ending what the chooser
depends on), some strict order according
with the choices puts every alternative that does not end above every alternative that ends and was open
with it at some occasion. -/
theorem keeping_above_ending {ends : α → Prop} (none : «无环» ch.Shown)
    (kept : ∀ o, ¬ ends (ch.pick o)) :
    ∃ P : «际» α, (∀ x, ¬ P x x) ∧ (∀ x y z, P x y → P y z → P x z) ∧ ch.Accords P ∧
      ∀ x y, ch.Met x y → ¬ ends x → ends y → P x y :=
  match accorded_containing_iff.mpr (noCycle_withPairs_of_kept (Q := fun x y => ch.Met x y ∧ ¬ ends x ∧ ends y)
      none kept fun _ _ q => q.2) with
  | ⟨P, irrefl, trans, accords, contains⟩ =>
    ⟨P, irrefl, trans, accords, fun x y met keeps ended =>
      contains x y ⟨met, keeps, ended⟩ fun same => keeps (same ▸ ended)⟩

end ChoiceOccasions

/-! ## Self-concern on the occasions met -/

namespace Weighting

variable {X : Type}

/-- An order is *increasing in its own continuation on the pairs `met` relates*: wherever `met` relates
`a` to `b` and `a` widens `b` adding to what `own` marks, it ranks `a` above `b`. `R b a` reads "`a` is
ranked above `b`", as in `IncreasingInOwn`. -/
def IncreasingInOwnOn (met : (X → Bool) → (X → Bool) → Prop) (items : List X) (own : X → Bool)
    (R : (X → Bool) → (X → Bool) → Prop) : Prop :=
  ∀ a b, met a b → WidensOn items a b → AddsOwn items own a b → R b a

/-- An order increasing in its own continuation is so on any pairs. -/
theorem increasingInOwnOn_of_increasingInOwn {met : (X → Bool) → (X → Bool) → Prop} {items : List X}
    {own : X → Bool} {R : (X → Bool) → (X → Bool) → Prop} (increasing : IncreasingInOwn items own R) :
    IncreasingInOwnOn met items own R :=
  fun a b _ => increasing a b

/-- On every pair, it is being increasing in its own continuation. -/
theorem increasingInOwnOn_every_iff {items : List X} {own : X → Bool}
    {R : (X → Bool) → (X → Bool) → Prop} :
    IncreasingInOwnOn (fun _ _ => True) items own R ↔ IncreasingInOwn items own R :=
  ⟨fun on a b => on a b trivial, increasingInOwnOn_of_increasingInOwn⟩

/-- A widening differs from what it widens. -/
theorem WidensOn.ne {items : List X} {a b : X → Bool} (widens : WidensOn items a b) : b ≠ a :=
  fun same => match widens.2 with
    | ⟨_, _, admits, not⟩ => Bool.noConfusion ((congrFun same _ ▸ not).symm.trans admits)

/-- A course *ends the own continuation* on the listing: it admits no listed item `own` marks. -/
def EndsOwn (items : List X) (own : X → Bool) (a : X → Bool) : Prop :=
  ∀ x, x ∈ items → own x = true → a x = false

/-- A course keeps all of the own continuation listed or none of it. -/
def AllOrNone (items : List X) (own : X → Bool) (a : X → Bool) : Prop :=
  (∀ x, x ∈ items → own x = true → a x = true) ∨ EndsOwn items own a

/-- Where `b` keeps all of the own continuation or none, a course adding to it beyond `b` does not end it,
and `b` does. -/
theorem adds_ends_of_allOrNone {items : List X} {own : X → Bool} {a b : X → Bool}
    (whole : AllOrNone items own b) (adds : AddsOwn items own a b) :
    ¬ EndsOwn items own a ∧ EndsOwn items own b :=
  match adds with
  | ⟨x, listed, marked, admits, not⟩ =>
    ⟨fun ends => Bool.noConfusion ((ends x listed marked).symm.trans admits),
     whole.elim (fun all => absurd ((all x listed marked).symm.trans not) (fun h => Bool.noConfusion h))
       id⟩

end Weighting

namespace ChoiceOccasions

variable {X : Type} {O : Type}

/-- `a` widens `b` on the listing, adds to the own continuation beyond it, and the two are met together:
the comparisons an order increasing in its own continuation on the occasions met must make. -/
def OwnWidensMet (ch : ChoiceOccasions (X → Bool) O) (items : List X) (own : X → Bool) :
    «际» (X → Bool) :=
  fun a b => ch.Met a b ∧ Weighting.WidensOn items a b ∧ Weighting.AddsOwn items own a b

variable {ch : ChoiceOccasions (X → Bool) O} {items : List X} {own : X → Bool}

/-- Making those comparisons is being increasing in its own continuation on the occasions met. -/
theorem contains_iff_increasingInOwnOn {P : «际» (X → Bool)} :
    (∀ a b, ch.OwnWidensMet items own a b → b ≠ a → P a b) ↔
      Weighting.IncreasingInOwnOn ch.Met items own (fun b a => P a b) :=
  ⟨fun contains a b met widens adds => contains a b ⟨met, widens, adds⟩ widens.ne,
   fun increasing a b q _ => increasing a b q.1 q.2.1 q.2.2⟩

/-- **Self-concern consistent with the choices, exactly.** Some strict order according with the choices is
increasing in its own continuation on the pairs met together exactly where the shown relation with every
own-widening met added has no cycle. -/
theorem selfConcerned_consistent_iff :
    (∃ P : «际» (X → Bool), (∀ a, ¬ P a a) ∧ (∀ a b c, P a b → P b c → P a c) ∧ ch.Accords P ∧
        Weighting.IncreasingInOwnOn ch.Met items own (fun b a => P a b)) ↔
      «无环» (ch.withPairs (ch.OwnWidensMet items own)).Shown :=
  ⟨fun ⟨P, irrefl, trans, accords, increasing⟩ => accorded_containing_iff.mp
      ⟨P, irrefl, trans, accords, contains_iff_increasingInOwnOn.mpr increasing⟩,
   fun none => match accorded_containing_iff.mpr none with
    | ⟨P, irrefl, trans, accords, contains⟩ =>
      ⟨P, irrefl, trans, accords, contains_iff_increasingInOwnOn.mp contains⟩⟩

/-- **Where only ending is at stake, keeping gives self-concern on the occasions met.** Where the choices
come from some strict order, no chosen course ends (`ends`), and on the occasions met a course adds to the
own continuation beyond one it widens only where it does not end and the other does (`stake`), some
strict order according with the choices is increasing in its own continuation on the pairs met. It is consistent
with the choices; the choices do not show that it is held. -/
theorem selfConcerned_consistent_of_kept {ends : (X → Bool) → Prop} (none : «无环» ch.Shown)
    (kept : ∀ o, ¬ ends (ch.pick o))
    (stake : ∀ a b, ch.Met a b → Weighting.WidensOn items a b → Weighting.AddsOwn items own a b →
      ¬ ends a ∧ ends b) :
    ∃ P : «际» (X → Bool), (∀ a, ¬ P a a) ∧ (∀ a b c, P a b → P b c → P a c) ∧ ch.Accords P ∧
      Weighting.IncreasingInOwnOn ch.Met items own (fun b a => P a b) :=
  selfConcerned_consistent_iff.mpr (noCycle_withPairs_of_kept none kept
    fun a b q => stake a b q.1 q.2.1 q.2.2)

/-- **The same, where each course keeps all of the own continuation or none.** Where the choices come from
some strict order, no chosen course admits none of the own continuation listed, and every course open
keeps all of it or none, some strict order according with the choices is increasing in its own
continuation on the pairs met. -/
theorem selfConcerned_consistent_of_allOrNone (none : «无环» ch.Shown)
    (kept : ∀ o, ¬ Weighting.EndsOwn items own (ch.pick o))
    (whole : ∀ o a, ch.menu o a → Weighting.AllOrNone items own a) :
    ∃ P : «际» (X → Bool), (∀ a, ¬ P a a) ∧ (∀ a b c, P a b → P b c → P a c) ∧ ch.Accords P ∧
      Weighting.IncreasingInOwnOn ch.Met items own (fun b a => P a b) :=
  selfConcerned_consistent_of_kept none kept fun _ b ⟨o, _, open_b⟩ _ adds =>
    Weighting.adds_ends_of_allOrNone (whole o b open_b) adds

/-- **Off the occasions met, a consistent order reverses it.** Where some strict order according with the
choices is increasing in its own continuation on the pairs met (the cycle-free case of
`selfConcerned_consistent_iff`), let `a` be met nowhere, widen `b` and add to the own continuation beyond
it. Then some strict order according with the choices and increasing in its own continuation on the pairs
met ranks `b` above `a`, and so is not increasing in its own continuation. -/
theorem reversed_off_met (none : «无环» (ch.withPairs (ch.OwnWidensMet items own)).Shown)
    {a b : X → Bool} (unmet : ch.Unmet a) (widens : Weighting.WidensOn items a b)
    (adds : Weighting.AddsOwn items own a b) :
    ∃ P : «际» (X → Bool), (∀ x, ¬ P x x) ∧ (∀ x y z, P x y → P y z → P x z) ∧ ch.Accords P ∧
      Weighting.IncreasingInOwnOn ch.Met items own (fun y x => P x y) ∧ P b a ∧
      ¬ Weighting.IncreasingInOwn items own (fun y x => P x y) :=
  match above_in_some_containing_of_unreached none widens.ne
      (not_reach_of_unmet unmet fun _ q => match q.1 with | ⟨o, open_a, _⟩ => ⟨o, open_a⟩) with
  | ⟨P, irrefl, trans, accords, contains, above⟩ =>
    ⟨P, irrefl, trans, accords, contains_iff_increasingInOwnOn.mp contains, above,
     fun increasing => irrefl b (trans b a b above (increasing a b widens adds))⟩

end ChoiceOccasions

/-! ## A line that persists, on the World -/

namespace SelectionTerm.Generations

/-- A line *persists through arbitrarily late cohorts*: past every step some cohort of descent has a
member. -/
def Persists {X : Type} (G : SelectionTerm.Generations X) : Prop :=
  ∀ N, ∃ s y, N ≤ s ∧ y ∈ G.family s

end SelectionTerm.Generations

/-- **A line that persists never overdrew what it depends on from a short stock.** Under balance, with
only active formations giving and activity needing support, let the renewal of a family of conditions be
gated on the family as one at a need of at least `m`, and let every member of every cohort of descent
depend on some condition of the family at a need of at least `m`. If the line persists through arbitrarily
late cohorts, then at no step `T` did the family's uptake exceed its replenishment for `n` steps from a
stock below `n + m` (from `GroupEnding.Flow.family_childless`). -/
theorem Flow.persists_never_overdraws {X : Type} {L : Flow X X} {W : Web X X}
    (balances : L.Balances W) (acting : L.Acting W) (dependent : W.Dependent)
    {G : SelectionTerm.Generations X} (descended : SelectionTerm.Flow.Descended L W G)
    {ds : List X} {m : Nat}
    (gated : ∀ t f, f ∈ L.present t → ∀ d, d ∈ ds → 0 < L.give t f d →
      ∃ e, e ∈ ds ∧ W.requires t f e ∧ m ≤ W.need t f e)
    (coupled : ∀ s p, p ∈ G.family s → ∃ e, e ∈ ds ∧ W.requires s p e ∧ m ≤ W.need s p e)
    (persists : G.Persists) (T n : Nat) :
    ¬ ((∀ k, k < n → L.replenishment ds (T + k) < L.uptake ds (T + k)) ∧ W.stock ds T < n + m) :=
  fun ⟨excess, start⟩ =>
    have ended : ∀ k y, ¬ y ∈ G.family (T + n + k + 1) := fun k y mem =>
      match ListTests.mem_flatMap_iff.mp mem with
      | ⟨q, mq, kid⟩ => match coupled (T + n + k) q mq with
        | ⟨_, inside, depends, high⟩ =>
          GroupEnding.Flow.family_childless balances acting dependent gated excess start k inside
            depends high y (descended (T + n + k) q y mq kid)
    match persists (T + n + 1) with
    | ⟨_, y, late, member⟩ => match Nat.le.dest late with
      | ⟨k, at_⟩ => ended k y (Eq.subst (motive := fun r => y ∈ G.family r)
          ((Nat.add_right_comm (T + n) 1 k).symm.trans at_).symm member)

/-- **A persisting line's choices are consistent with self-concern on the occasions it met, where only
ending was at stake.** Under the laws of `persists_never_overdraws`, let the line persist, let a chosen
course that ends what the line depends on be realized as an overdraw of the family from a short stock
(`realized`), let the choices come from some strict order, and let a course on the occasions met add to the
own continuation beyond one it widens only where it does not end and the other does (`stake`). Then some
strict order according with the choices is increasing in its own continuation on the pairs met. -/
theorem Flow.persisting_consistent_with_selfConcern {X Y O : Type} {L : Flow X X} {W : Web X X}
    (balances : L.Balances W) (acting : L.Acting W) (dependent : W.Dependent)
    {G : SelectionTerm.Generations X} (descended : SelectionTerm.Flow.Descended L W G)
    {ds : List X} {m : Nat}
    (gated : ∀ t f, f ∈ L.present t → ∀ d, d ∈ ds → 0 < L.give t f d →
      ∃ e, e ∈ ds ∧ W.requires t f e ∧ m ≤ W.need t f e)
    (coupled : ∀ s p, p ∈ G.family s → ∃ e, e ∈ ds ∧ W.requires s p e ∧ m ≤ W.need s p e)
    (persists : G.Persists)
    {ch : ChoiceOccasions (Y → Bool) O} {items : List Y} {own : Y → Bool}
    {ends : (Y → Bool) → Prop}
    (realized : ∀ o, ends (ch.pick o) → ∃ T n,
      (∀ k, k < n → L.replenishment ds (T + k) < L.uptake ds (T + k)) ∧ W.stock ds T < n + m)
    (none : «无环» ch.Shown)
    (stake : ∀ a b, ch.Met a b → Weighting.WidensOn items a b → Weighting.AddsOwn items own a b →
      ¬ ends a ∧ ends b) :
    ∃ P : «际» (Y → Bool), (∀ a, ¬ P a a) ∧ (∀ a b c, P a b → P b c → P a c) ∧ ch.Accords P ∧
      Weighting.IncreasingInOwnOn ch.Met items own (fun b a => P a b) :=
  ChoiceOccasions.selfConcerned_consistent_of_kept none
    (fun o ends_o => match realized o ends_o with
      | ⟨T, n, overdraw⟩ => Flow.persists_never_overdraws balances acting dependent descended gated
          coupled persists T n overdraw)
    stake

/-! ## A persisting chooser that is not self-concerned -/

namespace PersistingChoices.Forgoing

/-- What is taken across the step from `t`: the member `some t` takes its own unit of standing. -/
def takes (t : Nat) : Option Nat → Option Nat → Nat
  | some f, some c => cond (Nat.beq f t && Nat.beq c t) 1 0
  | some _, none => 0
  | none, _ => 0

/-- What is given across the step from `t`: the member `some t` gives the next member, `some (t + 1)`,
its unit of standing. -/
def gives (t : Nat) : Option Nat → Option Nat → Nat
  | some f, some c => cond (Nat.beq f t && Nat.beq c (t + 1)) 1 0
  | some _, none => 0
  | none, _ => 0

/-- **A line of one member a step.** The member of step `t`, `some t`, alone takes part at `t`; across
the step it takes its own standing and gives the next member its standing. `none` is a commons that
nothing takes from or gives to. -/
def flow : Flow (Option Nat) (Option Nat) where
  present t := [some t]
  take := takes
  give := gives

/-- Each member stands at its own step only, is active then, and requires the commons, which stands at
one, at a need of one. -/
def web : Web (Option Nat) (Option Nat) where
  level t c := match c with
    | none => 1
    | some c => cond (Nat.beq c t) 1 0
  active t f := f = some t
  requires t f c := f = some t ∧ c = none
  need _ _ _ := 1
  draws t f c := f = some t ∧ c = some t

/-- The line's cohorts: `some 0` first, each member leaving the next. -/
def generations : SelectionTerm.Generations (Option Nat) where
  first := [some 0]
  kids t _ := [some (t + 1)]
  amount _ _ := 0

/-- Each number is equal to itself, by `Nat.beq`. -/
theorem beq_self : ∀ t : Nat, Nat.beq t t = true
  | 0 => rfl
  | t + 1 => beq_self t

/-- No number is its own successor, by `Nat.beq`. -/
theorem beq_succ : ∀ t : Nat, Nat.beq (t + 1) t = false
  | 0 => rfl
  | t + 1 => beq_succ t

/-- The cohort of step `t` is the member `some t`. -/
theorem family_eq : ∀ t, generations.family t = [some t]
  | 0 => rfl
  | t + 1 => show (generations.family t).flatMap (generations.kids t) = [some (t + 1)] from
      Eq.subst (motive := fun l => l.flatMap (generations.kids t) = [some (t + 1)])
        (family_eq t).symm rfl

/-- The flow balances. -/
theorem balances : flow.Balances web := fun t c => match c with
  | none => rfl
  | some c => show cond (Nat.beq c (t + 1)) 1 0 + (cond (Nat.beq t t && Nat.beq c t) 1 0 + 0) =
        cond (Nat.beq c t) 1 0 + (cond (Nat.beq t t && Nat.beq c (t + 1)) 1 0 + 0) from by
      rw [beq_self t]
      exact Nat.add_comm _ _

/-- Only active formations give. -/
theorem acting : flow.Acting web := fun t f _ mem _ => by
  change f ∈ [some t] at mem
  cases mem with
  | head => rfl
  | tail _ h => nomatch h

/-- Activity needs support: the commons meets every member's need. -/
theorem dependent : web.Dependent := fun _ _ _ _ ⟨_, at_none⟩ => by
  subst at_none
  exact Nat.le_refl 1

/-- Each cohort descends from the one before. -/
theorem descended : SelectionTerm.Flow.Descended flow web generations := fun t p k mp mk => by
  rw [family_eq t] at mp
  cases mp with
  | head =>
    cases mk with
    | head =>
      refine ⟨.head _, ?_, ?_, ?_⟩
      · show 0 < cond (Nat.beq t t && Nat.beq (t + 1) (t + 1)) 1 0
        rw [beq_self t, beq_self (t + 1)]
        exact Nat.zero_lt_one
      · show ¬ 0 < cond (Nat.beq (t + 1) t) 1 0
        rw [beq_succ t]
        exact Nat.lt_irrefl 0
      · show 0 < cond (Nat.beq (t + 1) (t + 1)) 1 0
        rw [beq_self (t + 1)]
        exact Nat.zero_lt_one
    | tail _ h => nomatch h
  | tail _ h => nomatch h

/-- **The line persists**: every step has a member. -/
theorem persists : generations.Persists :=
  fun N => ⟨N, some N, Nat.le_refl N,
    Eq.subst (motive := fun l => some N ∈ l) (family_eq N).symm (List.Mem.head [])⟩

/-- The commons' renewal is gated, vacuously: nothing gives to it. -/
theorem gated : ∀ t f, f ∈ flow.present t → ∀ d, d ∈ [none] → 0 < flow.give t f d →
    ∃ e, e ∈ [none] ∧ web.requires t f e ∧ 1 ≤ web.need t f e :=
  fun t f mem _ md gives => by
    change f ∈ [some t] at mem
    cases mem with
    | head =>
      cases md with
      | head => exact absurd gives (Nat.lt_irrefl 0)
      | tail _ h => nomatch h
    | tail _ h => nomatch h

/-- Every member of every cohort depends on the commons at a need of one. -/
theorem coupled : ∀ s p, p ∈ generations.family s →
    ∃ e, e ∈ [none] ∧ web.requires s p e ∧ 1 ≤ web.need s p e := fun s p mp => by
  rw [family_eq s] at mp
  cases mp with
  | head => exact ⟨none, .head _, ⟨rfl, rfl⟩, Nat.le_refl 1⟩
  | tail _ h => nomatch h

/-- **The survivorship law holds here**: the line never overdrew the commons from a short stock. -/
theorem never_overdraws (T n : Nat) :
    ¬ ((∀ k, k < n → flow.replenishment [none] (T + k) < flow.uptake [none] (T + k)) ∧
      web.stock [none] T < n + 1) :=
  Flow.persists_never_overdraws balances acting dependent descended gated coupled persists T n

/-- The own continuation listed: the line's member at a later step, and a further child it can have
then. -/
inductive Item where
  | member
  | extra

/-- Both items are listed. -/
def items : List Item := [.member, .extra]

/-- Both are the line's own continuation. -/
def own : Item → Bool := fun _ => true

/-- The course with one more child. -/
def more : Item → Bool := fun _ => true

/-- The course of the line going on as it is: its member, no further child. -/
def fewer : Item → Bool := fun i => match i with
  | .member => true
  | .extra => false

/-- The course ending what the line depends on: neither. -/
def drain : Item → Bool := fun _ => false

/-- One occasion, the three courses open, the line going on as it is chosen. -/
def choices : ChoiceOccasions (Item → Bool) Unit where
  menu _ c := c = more ∨ c = fewer ∨ c = drain
  pick _ := fewer

/-- A valuation stipulated for the witness: the line as it is first, one more child second, the ending
last. -/
def score (c : Item → Bool) : Nat := cond (c .extra) 1 (cond (c .member) 2 0)

/-- The order the witness's choice accords with: a course above another where it scores higher. -/
def order : «际» (Item → Bool) := fun x y => score y < score x

/-- The order is strict. -/
theorem order_strict : (∀ a, ¬ order a a) ∧ (∀ a b c, order a b → order b c → order a c) :=
  ⟨fun _ h => Nat.lt_irrefl _ h, fun _ _ _ first second => Nat.lt_trans second first⟩

/-- **Its choice accords with the order**: the chosen course stands above every other course open. -/
theorem order_accords : choices.Accords order := fun _ y open_y other => by
  cases open_y with
  | inl is_more =>
    subst is_more
    exact Nat.lt_succ_self 1
  | inr rest =>
    cases rest with
    | inl is_fewer => exact absurd is_fewer other
    | inr is_drain =>
      subst is_drain
      exact Nat.zero_lt_succ 1

/-- Nothing shown returns. -/
theorem noCycle : «无环» choices.Shown :=
  ChoiceOccasions.accorded_iff_noCycle.mp ⟨order, order_strict.1, order_strict.2, order_accords⟩

/-- No choice ends the own continuation. -/
theorem kept : ∀ o, ¬ Weighting.EndsOwn items own (choices.pick o) :=
  fun _ ends => Bool.noConfusion (ends .member (.head _) rfl)

/-- One more child is another course. -/
theorem more_ne_fewer : more ≠ fewer := fun same => Bool.noConfusion (congrFun same .extra)

/-- The two keeping courses were met together. -/
theorem met : choices.Met more fewer := ⟨(), .inl rfl, .inr (.inl rfl)⟩

/-- One more child widens the line as it is. -/
theorem widens : Weighting.WidensOn items more fewer :=
  ⟨fun _ _ _ => rfl, ⟨.extra, .tail _ (.head _), rfl, rfl⟩⟩

/-- It adds to the own continuation. -/
theorem adds : Weighting.AddsOwn items own more fewer := ⟨.extra, .tail _ (.head _), rfl, rfl, rfl⟩

/-- **Keeping stands above ending.** Some strict order according with the choice puts both keeping
courses above the ending (`keeping_above_ending`). -/
theorem keeping_above_drain :
    ∃ P : «际» (Item → Bool), (∀ x, ¬ P x x) ∧ (∀ x y z, P x y → P y z → P x z) ∧
      choices.Accords P ∧ P more drain ∧ P fewer drain :=
  match ChoiceOccasions.keeping_above_ending noCycle kept with
  | ⟨P, irrefl, trans, accords, above⟩ =>
    ⟨P, irrefl, trans, accords,
     above more drain ⟨(), .inl rfl, .inr (.inr rfl)⟩
       (fun ends => Bool.noConfusion (ends .member (.head _) rfl)) (fun _ _ _ => rfl),
     above fewer drain ⟨(), .inr (.inl rfl), .inr (.inr rfl)⟩
       (fun ends => Bool.noConfusion (ends .member (.head _) rfl)) (fun _ _ _ => rfl)⟩

/-- **No order according with the choice is increasing in its own continuation on the occasion met**:
the chosen course stands above one that widens it and adds to the own continuation. -/
theorem not_selfConcerned :
    ¬ ∃ P : «际» (Item → Bool), (∀ a, ¬ P a a) ∧ (∀ a b c, P a b → P b c → P a c) ∧
      choices.Accords P ∧ Weighting.IncreasingInOwnOn choices.Met items own (fun b a => P a b) :=
  fun ⟨_, irrefl, trans, accords, increasing⟩ =>
    irrefl fewer (trans fewer more fewer (accords () more (.inl rfl) more_ne_fewer)
      (increasing more fewer met widens adds))

/-- **A persisting chooser that is not self-concerned.** The flow balances, only active formations give,
activity needs support, the cohorts descend and the line persists; the chooser's choice accords with a
strict order, and no choice ends the own continuation; and no strict order according with its choice is
increasing in its own continuation on the occasion met. -/
theorem persists_not_selfConcerned :
    flow.Balances web ∧ flow.Acting web ∧ web.Dependent ∧
      SelectionTerm.Flow.Descended flow web generations ∧ generations.Persists ∧
      choices.Accords order ∧ (∀ o, ¬ Weighting.EndsOwn items own (choices.pick o)) ∧
      ¬ ∃ P : «际» (Item → Bool), (∀ a, ¬ P a a) ∧ (∀ a b c, P a b → P b c → P a c) ∧
        choices.Accords P ∧ Weighting.IncreasingInOwnOn choices.Met items own (fun b a => P a b) :=
  ⟨balances, acting, dependent, descended, persists, order_accords, kept, not_selfConcerned⟩

end PersistingChoices.Forgoing

end Becoming
