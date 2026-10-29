import Becoming.ContinuedClasses
import Becoming.Decidedness
import Becoming.Diagonal
import Becoming.GrammarTransport

/-!
# The World as a model of the grammar, both ways, and where amounts fail (表示)

The representation theorem asked of the World (OU's completion criterion 7; 08 §6): the World shown to
be a model of the grammar both ways, or the failure written down. Here both are given.

* The World's relational part is represented both ways.
* Its amounts are not. The model does not determine a world's standings, and at the model balance is
  carried only by conservation's step read along the names, which is defined from the balance equation.
* Amounts in `Nat` limit and condition the relations they induce.

**The occurrence model.** The carrier is the occurrences, `Nat × w.Relatum`, a relatum at a step.

* *The name-free part* reads no name at two steps, so every re-identification carries it:
  * the class of being at the same step (`Web.sameStep`), which reads the shared index of steps, a
    commitment of the model;
  * the step conservation induces (`World.conservationStep`);
  * activity, standing and presence, held as partial identities (`Web.partialIdentity`);
  * the five relations within a step the model selects (`World.withinStep` of requiring, drawing, a
    need met, giving and taking).

  Read as 缘, requiring, drawing, a need met and taking run from the condition to the formation, under
  `«逆»`; giving runs from giver to receiver. Amounts are read only by sign, against a need, and in
  conservation's equation. This selection is a choice: a re-identification carries more, for example a
  standing's value, the order of two standings, the step order, or a multiplicity in the presence list.
* *The names* are the names' step (`Steps.along`, the step along `Web.itself`:
  `Steps.along_iff_itself`), and whatever reads one name at two steps.

**Forward.** The forward direction is a schema, discharged notion by notion by the instance theorems
of the World modules; no single statement says every World notion is a grammar term.

* Recurrence is a statement at the model through the names' step and the same-step class
  (`Steps.later_iff`, `Steps.sameOrLater_iff`, `World.arisingRecurs_iff`, `World.ceasingRecurs_iff`).
  It reads the names, and re-identification does not fix it: a balanced re-identification takes a world
  whose arising recurs to one where nothing arises (`Lineage.world_readings`).
* Every re-identification is a one-to-one correspondence of the name-free part:
  * on the relata of each step (`Reidentify.atStep`), and on the occurrences
    (`Reidentify.onOccurrences`);
  * carrying all ten of its relations (`World.reidentify_carries`).

  So each term of `Becoming.GrammarTransport` read there is fixed under re-identification. One case is
  stated as the pattern (`World.sheng_conservation_reidentify`).

**Converse.**

* *The relational part.* Every choice of activity, requiring, drawing and presence is some world's, with
  no amount (`World.ofRelations`). At the model, every partial identity, with two relations within a step
  and presence lists, is the relational part of some world's model (`World.ofModel_model`).
* *Conservation's form.* Conservation is exactly the relations "`f`'s standing after the step with `b`
  is `a`", for an inhabited type of relata.
  * Every world's conservation has this form by definition (`World.conserves_form`).
  * Conversely, every relation of the form is some world's (`World.ofConservationForm_conserves`).
  * Through one conserving pair it is labelled by standings, so it is difunctional
    (`World.conserves_iff_same_level`, `World.conserves_difunctional`).
* *Decidedness.* Conservation and the other relations amounts induce are decided
  (`World.conserves_decided`, `World.amounts_decided`); on one relatum, conservation is a proposition
  `Q` across every step exactly where `Q` is decided (`World.conservation_iff_decided`), a lemma of
  whole-number equations. Activity, requiring and drawing range over every proposition, so that every
  world decides activity is exactly excluded middle (`World.decides_activity_iff_em`).

**Where it fails, written down.**

* *F1, standings not determined.* For positive standings `k` and `k'`, two worlds agree on every field
  the model's selection reads, while their standings are `k` and `k'` (`World.standingAt_alike`). So the
  model does not determine a world's standing, and the World is not equivalent to its model.
* *F1′, balance only through conservation.* The idle world balances and its double does not, while they
  have the same web (every level, need, activity, requirement and drawing) and the same signs of exchange
  (`World.balance_needs_conservation`). Balance is the names lying within conservation
  (`World.balanced_iff_conserves`): represented both ways in the sense of one notion and its grammar
  statement, near-definitionally, and derived from nothing.
* *F2, identity not induced.* Conservation across a step is never identity on the predicates of `Nat`:
  where it is, the standings after the step tell every two relata apart
  (`World.conserves_identity_injective`), and no map of the predicates on `Nat` into `Nat` is one to one
  (`Diagonal.no_injection_of_predicates`, from `Diagonal.claims_incomplete`).
* *F3, a line of falls ends.* Along the names, a line of falls ends on every branch
  (`World.falls_exhaust`). This comes from the amounts' law of falls ending (`Amounts.falls_end` at
  `Amounts.whole`, least loss one) through `«尽之拉回»`, so the line does not go on without end
  (`World.falls_not_endless`), and no world with a relatum falls at every occurrence
  (`World.not_falls_everywhere`). A line of steps under the class of a predicate holding everywhere goes
  on without end (`Steps.along_endless`). So this is a condition of the World's image, not a law of the
  grammar.

**What is not shown.**

* That amounts are represented: the model does not determine a world's standings, so a world is not
  recovered from its model.
* That balance is derived: at the occurrence model it is represented only through conservation's step
  read along the names, which is defined from the balance equation; its other representations, unit
  pairings and an added idle relatum, are near-definitional too. F1′ rules out properties of the web and
  the signs of exchange only.
* The amount part's image beyond conservation alone: conservation's form is exact taken alone, with one
  relatum present; the joint image with presence, falls and the other relations is open.
* Anything about the unfolding beyond the commitment to whole amounts: decidedness comes from
  whole-number equations, F2 holds for relata with no injection into `Nat`, and F3 rests on the least
  loss one.
* A forward theorem: the forward direction is a schema of instance theorems, and that keeping to
  correspondences gives a term is not stated, since the embedding has no syntax of terms.
* Re-identification beyond the ten relations and the class of activity. That the names' step is carried
  only by renamings the same at every step, and that the representation is faithful but not full on
  re-identifications, are not stated here.
* A representation of processes; one reading only the order of joined exchanges rather than the shared
  index (reorderings and inserted idle steps keep the first and change the second); whether the descent
  laws follow from F3 with the grammar's laws of finite runs; classes finer than any the World's
  predicates read; mutual interpretation with a fragment of Lean.

Every declaration has an empty axiom report.
-/

namespace Becoming

/-! ## The occurrence model -/

/-- Two occurrences are at the same step: the class the shared index of steps gives. -/
def Web.sameStep {R : Type} : «际» (Nat × R) := fun x y => x.1 = y.1

theorem Web.sameStep_class {R : Type} : «类» (Web.sameStep (R := R)) :=
  ⟨fun _ => rfl, fun same => same.symm, fun s t => s.trans t⟩

/-- The partial identity of a predicate (`«合» «静»` with it): a point related to itself where the
predicate holds, the reading of what a path admits (`Web.admitted`). -/
def Web.partialIdentity {α : Type} (P : α → Prop) : «际» α :=
  «合» «静» (fun x _ => P x)

/-- The names' step is the step along the names' continuation. -/
theorem Steps.along_iff_itself {F : Type} {x y : Nat × F} :
    Steps.along x y ↔ Web.continuationStep Web.itself x y :=
  ⟨fun ⟨next, same⟩ => ⟨next, same.symm⟩, fun ⟨next, same⟩ => ⟨next, same.symm⟩⟩

/-- **A later step, on the occurrences**: reached along the names, then read across by the same
step. -/
theorem Steps.later_iff {R : Type} {x y : Nat × R} :
    x.1 < y.1 ↔ «而» («及» Steps.along) Web.sameStep x y :=
  ⟨fun lt =>
    have reach : ∀ k, «及» Steps.along x (x.1 + k + 1, x.2) := fun k =>
      Nat.rec (motive := fun k => «及» Steps.along x (x.1 + k + 1, x.2)) (.one ⟨rfl, rfl⟩)
        (fun _ ih => «及之传递» ih (.one ⟨rfl, rfl⟩)) k
    match gap_of_lt lt with
    | ⟨k, same⟩ => ⟨(x.1 + k + 1, x.2), reach k, same.symm⟩,
   fun ⟨_, r, same⟩ =>
    Eq.subst (motive := fun n => x.1 < n) same
      (Web.reach_advances («及之单调» (fun _ _ step => Steps.along_iff_itself.mp step) _ _ r))⟩

/-- **The same step or later, on the occurrences**: within the names' closure, then read across. -/
theorem Steps.sameOrLater_iff {R : Type} {x y : Nat × R} :
    x.1 ≤ y.1 ↔ «而» («所闭» Steps.along) Web.sameStep x y :=
  ⟨fun le =>
    have within : ∀ k, «所闭» Steps.along x (x.1 + k, x.2) := fun k =>
      Nat.rec (motive := fun k => «所闭» Steps.along x (x.1 + k, x.2)) (fun _ _ held => held)
        (fun _ ih P closed held => closed _ _ (ih P closed held) ⟨rfl, rfl⟩) k
    match le_dest le with
    | ⟨k, same⟩ => ⟨(x.1 + k, x.2), within k, same.symm⟩,
   fun ⟨_, within, same⟩ =>
    Eq.subst (motive := fun n => x.1 ≤ n) same
      (within (fun a => x.1 ≤ a.1)
        (fun _ _ inside step => Eq.subst (motive := fun n => x.1 ≤ n) step.1.symm
          (Nat.le_succ_of_le inside))
        (Nat.le_refl _))⟩

namespace World

/-- The step conservation induces, on occurrences. -/
def conservationStep (w : World) : «际» (Nat × w.Relatum) :=
  Web.continuationStep w.Conserves

/-- A relation within each step, read on occurrences: `x` relates to `y` where they are at one step
and `r` relates their relata there. A world's requiring, drawing, a need met and taking read the
formation first and the condition second, so as 缘 they are read under `«逆»`; giving runs from giver
to receiver. -/
def withinStep {R : Type} (r : Nat → R → R → Prop) : «际» (Nat × R) :=
  fun x y => x.1 = y.1 ∧ r x.1 x.2 y.2

/-- **Arising recurs, on the occurrence model**: some occurrence exists, and after every occurrence an
active one begins under the class of activity at a later step. -/
theorem arisingRecurs_iff (w : World) :
    w.ArisingRecurs ↔ (∃ _ : w.Relatum, True) ∧
      ∀ x : Nat × w.Relatum, ∃ y, «而» («及» Steps.along) Web.sameStep x y ∧ w.web.active y.1 y.2 ∧
        «生» Steps.along w.web.activityClass y :=
  ⟨fun recurs =>
    have late := (Web.unceasing_iff_late_beginnings (W := w.web)).mp recurs
    ⟨match late 0 with | ⟨y, _, _, _⟩ => ⟨y.2, trivial⟩,
     fun x => match late x.1 with
      | ⟨y, after, active, begins⟩ => ⟨y, Steps.later_iff.mp after, active, begins⟩⟩,
   fun ⟨⟨f, _⟩, all⟩ => (Web.unceasing_iff_late_beginnings (W := w.web)).mpr fun N =>
    match all (N, f) with
    | ⟨y, after, active, begins⟩ => ⟨y, Steps.later_iff.mpr after, active, begins⟩⟩

/-- **Ceasing recurs, on the occurrence model**: some occurrence exists, and at or after every
occurrence an active one ends under the class of activity. -/
theorem ceasingRecurs_iff (w : World) :
    w.CeasingRecurs ↔ (∃ _ : w.Relatum, True) ∧
      ∀ x : Nat × w.Relatum, ∃ y, «而» («所闭» Steps.along) Web.sameStep x y ∧ w.web.active y.1 y.2 ∧
        «亡» Steps.along w.web.activityClass y :=
  ⟨fun recurs =>
    ⟨match recurs 0 with | ⟨_, f, _, _⟩ => ⟨f, trivial⟩,
     fun x => match recurs x.1 with
      | ⟨t, f, after, ceases⟩ =>
        match Web.ceases_iff_wang.mp ceases with
        | ⟨active, ends⟩ => ⟨(t, f), Steps.sameOrLater_iff.mp after, active, ends⟩⟩,
   fun ⟨⟨f, _⟩, all⟩ N => match all (N, f) with
    | ⟨y, after, active, ends⟩ =>
      ⟨y.1, y.2, Steps.sameOrLater_iff.mpr after, Web.ceases_iff_wang.mpr ⟨active, ends⟩⟩⟩

end World

/-! ## Re-identification is a correspondence of the name-free part -/

/-- A re-identification at one step is a one-to-one correspondence of the relata named there. -/
def Reidentify.atStep {R R' : Type} (σ : Reidentify R R') (t : Nat) : «一一对应» R' R :=
  ⟨σ.old t, σ.new t, σ.new_old t, σ.old_new t⟩

/-- A re-identification is a one-to-one correspondence of occurrences, `(t, x) ↦ (t, σ.old t x)`: at
each step, its correspondence there. -/
def Reidentify.onOccurrences {R R' : Type} (σ : Reidentify R R') : «一一对应» (Nat × R') (Nat × R) :=
  ⟨fun x => (x.1, (σ.atStep x.1).to x.2), fun y => (y.1, (σ.atStep y.1).back y.2),
   fun x => congrArg (Prod.mk x.1) ((σ.atStep x.1).back_to x.2),
   fun y => congrArg (Prod.mk y.1) ((σ.atStep y.1).to_back y.2)⟩

theorem Reidentify.sameStep_carried {R R' : Type} (σ : Reidentify R R') :
    «谓» («像» σ.onOccurrences.to Web.sameStep) Web.sameStep :=
  («对应之像» _ _ _).mpr fun _ _ => Iff.rfl

/-- A relation within each step read through the naming there is carried. -/
theorem Reidentify.withinStep_carried {R R' : Type} (σ : Reidentify R R') {r : Nat → R → R → Prop}
    {r' : Nat → R' → R' → Prop} (pointwise : ∀ t x y, r' t x y ↔ r t (σ.old t x) (σ.old t y)) :
    «谓» («像» σ.onOccurrences.to (World.withinStep r')) (World.withinStep r) :=
  («对应之像» _ _ _).mpr fun x y =>
    ⟨fun ⟨same, h⟩ => ⟨same, Eq.subst (motive := fun s => r x.1 (σ.old x.1 x.2) (σ.old s y.2)) same
        ((pointwise _ _ _).mp h)⟩,
     fun ⟨same, h⟩ => ⟨same, (pointwise _ _ _).mpr
        (Eq.subst (motive := fun s => r x.1 (σ.old x.1 x.2) (σ.old s y.2)) same.symm h)⟩⟩

/-- A snapshot predicate read through the naming there is carried, as a partial identity
(`«部分恒等之像»`). -/
theorem Reidentify.partialIdentity_carried {R R' : Type} (σ : Reidentify R R') {p : Nat → R → Prop}
    {p' : Nat → R' → Prop} (pointwise : ∀ t x, p' t x ↔ p t (σ.old t x)) :
    «谓» («像» σ.onOccurrences.to (Web.partialIdentity fun x => p' x.1 x.2))
      (Web.partialIdentity fun x => p x.1 x.2) :=
  «部分恒等之像» fun x => pointwise x.1 x.2

namespace World

variable {w : World} {R' : Type}

/-- **Conservation is carried by every re-identification**: the re-identified world's conservation is
the world's, carried (`Reidentify.carry`). -/
theorem conserves_reidentify (σ : Reidentify w.Relatum R') (t : Nat) (x y : R') :
    (w.reidentify σ).Conserves t x y ↔ σ.carry w.Conserves t x y :=
  ⟨fun h => (congrArg (w.web.level (t + 1) (σ.old (t + 1) y) + ·)
      (World.reidentify_taken σ t x)).symm.trans
      (h.trans (congrArg (w.web.level t (σ.old t x) + ·) (World.reidentify_given σ t x))),
   fun h => (congrArg (w.web.level (t + 1) (σ.old (t + 1) y) + ·)
      (World.reidentify_taken σ t x)).trans
      (h.trans (congrArg (w.web.level t (σ.old t x) + ·) (World.reidentify_given σ t x)).symm)⟩

/-- Conservation's step is carried. -/
theorem conservationStep_reidentify (σ : Reidentify w.Relatum R') :
    «谓» («像» σ.onOccurrences.to (w.reidentify σ).conservationStep) w.conservationStep :=
  («对应之像» _ _ _).mpr fun x y =>
    ⟨fun ⟨next, h⟩ => ⟨next, Eq.subst (motive := fun s => w.Conserves x.1 (σ.old x.1 x.2) (σ.old s y.2))
        next.symm ((conserves_reidentify σ _ _ _).mp h)⟩,
     fun ⟨next, h⟩ => ⟨next, (conserves_reidentify σ _ _ _).mpr
        (Eq.subst (motive := fun s => w.Conserves x.1 (σ.old x.1 x.2) (σ.old s y.2)) next h)⟩⟩

/-- The class of activity is carried. -/
theorem activityClass_reidentify (σ : Reidentify w.Relatum R') :
    «谓» («像» σ.onOccurrences.to (w.reidentify σ).web.activityClass) w.web.activityClass :=
  («对应之像» _ _ _).mpr fun _ _ => Iff.rfl

/-- **Every re-identification carries the name-free part's ten relations**: the same-step class,
conservation's step, activity, standing and presence as partial identities, and the five relations
within a step the model selects (requiring, drawing, a need met, giving, taking). -/
theorem reidentify_carries (σ : Reidentify w.Relatum R') :
    «谓» («像» σ.onOccurrences.to Web.sameStep) Web.sameStep ∧
    «谓» («像» σ.onOccurrences.to (w.reidentify σ).conservationStep) w.conservationStep ∧
    «谓» («像» σ.onOccurrences.to (Web.partialIdentity fun x => (w.reidentify σ).web.active x.1 x.2))
      (Web.partialIdentity fun x => w.web.active x.1 x.2) ∧
    «谓» («像» σ.onOccurrences.to (Web.partialIdentity fun x => 0 < (w.reidentify σ).web.level x.1 x.2))
      (Web.partialIdentity fun x => 0 < w.web.level x.1 x.2) ∧
    «谓» («像» σ.onOccurrences.to (Web.partialIdentity fun x => x.2 ∈ (w.reidentify σ).flow.present x.1))
      (Web.partialIdentity fun x => x.2 ∈ w.flow.present x.1) ∧
    «谓» («像» σ.onOccurrences.to (withinStep (w.reidentify σ).web.requires)) (withinStep w.web.requires) ∧
    «谓» («像» σ.onOccurrences.to (withinStep (w.reidentify σ).web.draws)) (withinStep w.web.draws) ∧
    «谓» («像» σ.onOccurrences.to (withinStep fun t f c =>
        (w.reidentify σ).web.need t f c ≤ (w.reidentify σ).web.level t c))
      (withinStep fun t f c => w.web.need t f c ≤ w.web.level t c) ∧
    «谓» («像» σ.onOccurrences.to (withinStep fun t f c => 0 < (w.reidentify σ).flow.give t f c))
      (withinStep fun t f c => 0 < w.flow.give t f c) ∧
    «谓» («像» σ.onOccurrences.to (withinStep fun t f c => 0 < (w.reidentify σ).flow.take t f c))
      (withinStep fun t f c => 0 < w.flow.take t f c) :=
  ⟨Reidentify.sameStep_carried σ, conservationStep_reidentify σ,
   Reidentify.partialIdentity_carried σ (p := w.web.active) (p' := (w.reidentify σ).web.active)
     fun _ _ => Iff.rfl,
   Reidentify.partialIdentity_carried σ (p := fun t x => 0 < w.web.level t x)
     (p' := fun t x => 0 < (w.reidentify σ).web.level t x) fun _ _ => Iff.rfl,
   Reidentify.partialIdentity_carried σ (p := fun t x => x ∈ w.flow.present t)
     (p' := fun t x => x ∈ (w.reidentify σ).flow.present t) fun t _ => Reidentify.mem_map σ t,
   Reidentify.withinStep_carried σ fun _ _ _ => Iff.rfl, Reidentify.withinStep_carried σ fun _ _ _ => Iff.rfl,
   Reidentify.withinStep_carried σ fun _ _ _ => Iff.rfl, Reidentify.withinStep_carried σ fun _ _ _ => Iff.rfl,
   Reidentify.withinStep_carried σ fun _ _ _ => Iff.rfl⟩

/-- **Beginning under conservation is fixed under re-identification**: the pattern by which each term of
`Becoming.GrammarTransport` read on the name-free part is fixed. -/
theorem sheng_conservation_reidentify (σ : Reidentify w.Relatum R') (x : Nat × R') :
    «生» (w.reidentify σ).conservationStep (w.reidentify σ).web.activityClass x ↔
      «生» w.conservationStep w.web.activityClass (σ.onOccurrences.to x) :=
  «生之对应» (conservationStep_reidentify σ) (activityClass_reidentify σ) x

end World

/-! ## The converse -/

namespace World

/-- The world with relata `F` whose activity, requiring, drawing and presence are the given ones, with
no amount. -/
def ofRelations (F : Type) (active : Nat → F → Prop) (requires draws : Nat → F → F → Prop)
    (present : Nat → List F) : World :=
  World.of F ⟨present, fun _ _ _ => 0, fun _ _ _ => 0⟩
    ⟨fun _ _ => 0, active, requires, fun _ _ _ => 0, draws⟩

/-- The world's activity, requiring, drawing and presence are the given ones. -/
theorem ofRelations_relations (F : Type) (active : Nat → F → Prop) (requires draws : Nat → F → F → Prop)
    (present : Nat → List F) (t : Nat) :
    (∀ x, (ofRelations F active requires draws present).web.active t x ↔ active t x) ∧
    (∀ x y, (ofRelations F active requires draws present).web.requires t x y ↔ requires t x y) ∧
    (∀ x y, (ofRelations F active requires draws present).web.draws t x y ↔ draws t x y) ∧
    (∀ x, x ∈ (ofRelations F active requires draws present).flow.present t ↔ x ∈ present t) :=
  ⟨fun _ => Iff.rfl, fun _ _ => Iff.rfl, fun _ _ => Iff.rfl, fun _ => Iff.rfl⟩

/-- The world whose model's relational part is the given one: activity the predicate `a`, requiring
and drawing the relations `q` and `d`, presence the lists `present`. -/
def ofModel (F : Type) (a : Nat × F → Prop) (q d : «际» (Nat × F)) (present : Nat → List F) : World :=
  ofRelations F (fun t f => a (t, f)) (fun t f c => q (t, f) (t, c)) (fun t f c => d (t, f) (t, c)) present

/-- **At the model, the relational part ranges over everything**: a predicate's partial identity, two
relations lying within a step and presence lists are the relational part of a world's model. -/
theorem ofModel_model (F : Type) (a : Nat × F → Prop) {q d : «际» (Nat × F)}
    (hq : «则» q Web.sameStep) (hd : «则» d Web.sameStep) (present : Nat → List F) :
    «谓» (Web.partialIdentity fun x => (ofModel F a q d present).web.active x.1 x.2)
      (Web.partialIdentity a) ∧
    «谓» (withinStep (ofModel F a q d present).web.requires) q ∧
    «谓» (withinStep (ofModel F a q d present).web.draws) d ∧
    (∀ x : Nat × F, x.2 ∈ (ofModel F a q d present).flow.present x.1 ↔ x.2 ∈ present x.1) :=
  have within : ∀ {r : «际» (Nat × F)}, «则» r Web.sameStep → «谓» (withinStep fun t f c => r (t, f) (t, c)) r :=
    fun {r} hr x y =>
      ⟨fun ⟨same, h⟩ => Eq.subst (motive := fun s => r x (s, y.2)) same h,
       fun h => ⟨hr x y h, Eq.subst (motive := fun s => r x (s, y.2)) (hr x y h).symm h⟩⟩
  ⟨fun _ _ => Iff.rfl, within hq, within hd, fun _ => Iff.rfl⟩

/-- **Conservation's form, by definition**: `f`'s standing after the step, with what is taken from
`g`, is `g`'s standing with what is given to it. -/
theorem conserves_form {w : World} {t : Nat} {g f : w.Relatum} :
    w.Conserves t g f ↔ w.web.level (t + 1) f + w.flow.taken t g = w.web.level t g + w.flow.given t g :=
  Iff.rfl

/-- The world on relata `R` with one relatum `r₀` exchanging, whose standings are `level`, in which,
across the step from `t`, `r₀` takes `b t g` and `g`'s standing from `g` and gives `a t g` to it. -/
def ofConservationForm {R : Type} (r₀ : R) (level a b : Nat → R → Nat) : World :=
  World.of R ⟨fun _ => [r₀], fun t _ g => b t g + level t g, fun t _ g => a t g⟩
    (Witnesses.unrequired level fun _ _ => False)

/-- **Conservation is exactly a relation of this form.** Every relation "`f`'s standing after the step
with `b t g` is `a t g`", for any whole numbers `a` and `b`, is some world's conservation; with
`World.conserves_form`, these are all of them. -/
theorem ofConservationForm_conserves {R : Type} (r₀ : R) (level a b : Nat → R → Nat) (t : Nat)
    (g f : R) :
    (ofConservationForm r₀ level a b).Conserves t g f ↔ level (t + 1) f + b t g = a t g :=
  ⟨fun h => add_right_cancel (level t g)
      ((Nat.add_assoc (level (t + 1) f) (b t g) (level t g)).trans
        (h.trans (Nat.add_comm (level t g) (a t g)))),
   fun h => (Nat.add_assoc (level (t + 1) f) (b t g) (level t g)).symm.trans
      ((congrArg (· + level t g) h).trans (Nat.add_comm (a t g) (level t g)))⟩

/-- **Conservation is labelled by standings.** Given one relatum it conserves into, a relatum conserves
into exactly those standing after the step as that one does. -/
theorem conserves_iff_same_level {w : World} {t : Nat} {g f : w.Relatum} (h : w.Conserves t g f)
    (f' : w.Relatum) : w.Conserves t g f' ↔ w.web.level (t + 1) f' = w.web.level (t + 1) f :=
  ⟨fun h' => add_right_cancel (w.flow.taken t g) (h'.trans h.symm),
   fun same => Eq.subst (motive := fun n => n + w.flow.taken t g = w.web.level t g + w.flow.given t g)
     same.symm h⟩

/-- So conservation is difunctional. -/
theorem conserves_difunctional {w : World} {t : Nat} {g g' f f' : w.Relatum}
    (h₁ : w.Conserves t g f) (h₂ : w.Conserves t g' f) (h₃ : w.Conserves t g' f') :
    w.Conserves t g f' :=
  (conserves_iff_same_level h₁ f').mpr ((conserves_iff_same_level h₂ f').mp h₃)

/-- Conservation is decided. -/
theorem conserves_decided (w : World) (t : Nat) (g f : w.Relatum) : Decided (w.Conserves t g f) :=
  Decidable.em (w.web.level (t + 1) f + w.flow.taken t g = w.web.level t g + w.flow.given t g)

/-- **What amounts induce is decided**: a need met, giving, taking, standing and falling. -/
theorem amounts_decided (w : World) (t : Nat) (f c : w.Relatum) :
    Decided (w.web.need t f c ≤ w.web.level t c) ∧ Decided (0 < w.flow.give t f c) ∧
    Decided (0 < w.flow.take t f c) ∧ Decided (0 < w.web.level t f) ∧ Decided (w.web.Falls t f) :=
  ⟨Decidable.em _, Decidable.em _, Decidable.em _, Decidable.em _,
   Decidable.em (w.web.level (t + 1) f < w.web.level t f)⟩

/-- **Some world on one relatum has conservation `Q` across every step exactly where `Q` is decided**:
a lemma of whole-number equations (compare `indicates_iff_decided`). -/
theorem conservation_iff_decided (Q : Prop) :
    (∃ (L : Flow Unit Unit) (W : Web Unit Unit), ∀ t, (World.of Unit L W).Conserves t () () ↔ Q) ↔
      Decided Q :=
  ⟨fun ⟨L, W, h⟩ => match conserves_decided (World.of Unit L W) 0 () () with
     | .inl c => Or.inl ((h 0).mp c)
     | .inr n => Or.inr fun q => n ((h 0).mpr q),
   fun d => match d with
     | .inl q => ⟨Flow.still, Witnesses.unrequired (fun _ _ => 0) (fun _ _ => False),
         fun _ => ⟨fun _ => q, fun _ => rfl⟩⟩
     | .inr nq => ⟨⟨fun _ => [()], fun _ _ _ => 1, fun _ _ _ => 0⟩,
         Witnesses.unrequired (fun _ _ => 0) (fun _ _ => False),
         fun _ => ⟨fun c => absurd c (fun h => Nat.noConfusion h), fun q => absurd q nq⟩⟩⟩

/-- **That every world decides its activity is exactly excluded middle**: activity ranges over every
proposition. -/
theorem decides_activity_iff_em :
    (∀ w : World, ∀ t x, Decided (w.web.active t x)) ↔ ∀ Q : Prop, Decided Q :=
  ⟨fun all Q => all (ofRelations Unit (fun _ _ => Q) (fun _ _ _ => False) (fun _ _ _ => False)
      (fun _ => [])) 0 (),
   fun em _ _ _ => em _⟩

/-! ## Where it fails -/

/-- One relatum, never active, standing at `k` throughout, with nothing exchanged. -/
def standingAt (k : Nat) : World :=
  World.of Unit Flow.still (Witnesses.unrequired (fun _ _ => k) fun _ _ => False)

/-- **F1: the model does not determine the standing.** For positive `k` and `k'`, the two worlds agree,
at every step, on each field the model's selection reads (activity, standing, requiring, drawing,
presence, a need met, giving, taking, conservation and falling), while their standings are `k` and
`k'`. -/
theorem standingAt_alike {k k' : Nat} (pos : 0 < k) (pos' : 0 < k') (t : Nat) :
    ((standingAt k).web.active t () ↔ (standingAt k').web.active t ()) ∧
    (0 < (standingAt k).web.level t () ↔ 0 < (standingAt k').web.level t ()) ∧
    ((standingAt k).web.requires t () () ↔ (standingAt k').web.requires t () ()) ∧
    ((standingAt k).web.draws t () () ↔ (standingAt k').web.draws t () ()) ∧
    ((() ∈ (standingAt k).flow.present t) ↔ (() ∈ (standingAt k').flow.present t)) ∧
    ((standingAt k).web.need t () () ≤ (standingAt k).web.level t () ↔
      (standingAt k').web.need t () () ≤ (standingAt k').web.level t ()) ∧
    (0 < (standingAt k).flow.give t () () ↔ 0 < (standingAt k').flow.give t () ()) ∧
    (0 < (standingAt k).flow.take t () () ↔ 0 < (standingAt k').flow.take t () ()) ∧
    ((standingAt k).Conserves t () () ↔ (standingAt k').Conserves t () ()) ∧
    ((standingAt k).web.Falls t () ↔ (standingAt k').web.Falls t ()) ∧
    (standingAt k).web.level t () = k :=
  ⟨Iff.rfl, ⟨fun _ => pos', fun _ => pos⟩, Iff.rfl, Iff.rfl, Iff.rfl,
   ⟨fun _ => Nat.zero_le _, fun _ => Nat.zero_le _⟩, Iff.rfl,
   Iff.rfl, ⟨fun _ => rfl, fun _ => rfl⟩,
   ⟨fun h => absurd h (Nat.lt_irrefl k), fun h => absurd h (Nat.lt_irrefl k')⟩, rfl⟩

/-- The signs of a world's exchange: who is present, who gives to whom and who takes from whom. -/
structure ExchangeSigns (R : Type) where
  present : Nat → R → Prop
  gives : Nat → R → R → Prop
  takes : Nat → R → R → Prop

/-- A world's signs of exchange. -/
def exchangeSigns (w : World) : ExchangeSigns w.Relatum :=
  ⟨fun t x => x ∈ w.flow.present t, fun t f c => 0 < w.flow.give t f c,
   fun t f c => 0 < w.flow.take t f c⟩

/-- Two readings of the signs of exchange agree pointwise. -/
def ExchangeSigns.Agree {R : Type} (a b : ExchangeSigns R) : Prop :=
  (∀ t x, a.present t x ↔ b.present t x) ∧ (∀ t x y, a.gives t x y ↔ b.gives t x y) ∧
  (∀ t x y, a.takes t x y ↔ b.takes t x y)

/-- The idle world giving itself two units each step in place of one. -/
def idleTwice : World :=
  World.of Unit (Witnesses.giving () 2) World.Idle.web

theorem idleTwice_unbalanced : ¬ idleTwice.Balanced :=
  fun balanced => Nat.succ_ne_self 1 (balanced 0 ()).symm

/-- **F1′: balance is not determined by the web and the signs of exchange.** No property of a world's
web (every level, need, activity, requirement and drawing) and its signs of exchange that keeps to the
signs' agreement is balance: the idle world and its double have the same web and agreeing signs, and
the first balances while the second does not. -/
theorem balance_needs_conservation :
    ¬ ∃ Φ : (R : Type) → Web R R → ExchangeSigns R → Prop,
      (∀ R W (a b : ExchangeSigns R), a.Agree b → (Φ R W a ↔ Φ R W b)) ∧
      ∀ w : World, w.Balanced ↔ Φ w.Relatum w.web (exchangeSigns w) :=
  fun ⟨_, keeps, balance⟩ =>
    have agree : (exchangeSigns World.idle).Agree (exchangeSigns idleTwice) :=
      ⟨fun _ _ => Iff.rfl, fun _ _ _ => ⟨fun _ => Nat.zero_lt_succ 1, fun _ => Nat.zero_lt_succ 0⟩,
       fun _ _ _ => Iff.rfl⟩
    idleTwice_unbalanced ((balance idleTwice).mpr
      ((keeps Unit World.idle.web _ _ agree).mp ((balance World.idle).mp World.idle_world.1)))

/-- Where conservation across a step is identity, the standings after it tell every two relata
apart. -/
theorem conserves_identity_injective {w : World} {t : Nat}
    (identity : ∀ g f, w.Conserves t g f ↔ g = f) :
    ∀ f f', w.web.level (t + 1) f = w.web.level (t + 1) f' → f = f' :=
  fun f f' same =>
    have self : w.Conserves t f f := (identity f f).mpr rfl
    (identity f f').mp
      (Eq.subst (motive := fun n => n + w.flow.taken t f = w.web.level t f + w.flow.given t f)
        same self)

end World

/-- **No map of the predicates on `Nat` into `Nat` is one to one**, a diagonal fact: an injection would
make every predicate a claim of one family indexed by `Nat`. -/
theorem Diagonal.no_injection_of_predicates (i : (Nat → Prop) → Nat) :
    ¬ ∀ A B, i A = i B → A = B :=
  fun inj => Diagonal.claims_incomplete (fun n m => ∃ B, i B = n ∧ B m)
    (fun g => ⟨i g, fun m => ⟨fun ⟨B, same, b⟩ => Eq.subst (motive := fun C => C m) (inj B g same) b,
      fun gm => ⟨g, rfl, gm⟩⟩⟩)

namespace World

/-- **F2: conservation across a step is never identity on the predicates of `Nat`.** -/
theorem not_conserves_identity (L : Flow (Nat → Prop) (Nat → Prop))
    (W : Web (Nat → Prop) (Nat → Prop)) (t : Nat) :
    ¬ ∀ g f, (World.of (Nat → Prop) L W).Conserves t g f ↔ g = f :=
  fun identity => Diagonal.no_injection_of_predicates ((World.of (Nat → Prop) L W).web.level (t + 1))
    (conserves_identity_injective identity)

/-- **F3: a line of falls ends (尽).** The levels along it are a course of falls of a whole amount,
which ends (`Amounts.falls_end` at `Amounts.whole`, least loss one), and ending is pulled back along the
levels (`«尽之拉回»`). -/
theorem falls_exhaust (w : World) (x : Nat × w.Relatum) (falls : w.web.Falls x.1 x.2) :
    «尽» Steps.along (Web.alikeBy fun y => w.web.Falls y.1 y.2) x :=
  «尽之拉回» (R' := «而» («所闭» (fun a b => Amounts.whole.le b a))
      (fun a b => Amounts.whole.le (Amounts.whole.add b 1) a)) (L' := «一»)
    (fun y => w.web.level y.1 y.2) (fun y => w.web.Falls y.1 y.2)
    (fun _ _ hx c => c.2.mp hx)
    (fun x y hx c => by
      cases y with
      | mk s g =>
        cases c with
        | intro along _ =>
          cases along with
          | intro h₁ h₂ =>
            cases h₁; cases h₂
            exact ⟨⟨w.web.level x.1 x.2, fun _ _ held => held, hx⟩, trivial⟩)
    x falls
    (Amounts.falls_end (M := Amounts.whole) (ε := 1) (w.web.level x.1 x.2 + 1) (w.web.level x.1 x.2)
      (Amounts.whole_within (w.web.level x.1 x.2)))

/-- So a line of falls does not go on without end. -/
theorem falls_not_endless (w : World) (x : Nat × w.Relatum) (falls : w.web.Falls x.1 x.2) :
    ¬ «不穷» Steps.along (Web.alikeBy fun y => w.web.Falls y.1 y.2) x :=
  «尽则非不穷» (falls_exhaust w x falls)

/-- **No world with a relatum falls at every occurrence.** -/
theorem not_falls_everywhere (w : World) (x : Nat × w.Relatum) :
    ¬ ∀ y : Nat × w.Relatum, w.web.Falls y.1 y.2 :=
  fun all => falls_not_endless w x (all x)
    fun y _ => ⟨(y.1 + 1, y.2), ⟨rfl, rfl⟩, ⟨fun _ => all _, fun _ => all _⟩⟩

end World

/-- **A line of steps under the class of a predicate holding everywhere goes on without end**: the
grammar model where every occurrence falls, which no world with a relatum is
(`World.not_falls_everywhere`). -/
theorem Steps.along_endless {F : Type} (x : Nat × F) :
    «不穷» Steps.along (Web.alikeBy fun _ : Nat × F => True) x :=
  fun y _ => ⟨(y.1 + 1, y.2), ⟨rfl, rfl⟩, Iff.rfl⟩

end Becoming
