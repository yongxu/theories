import Becoming.Boundaries
import Becoming.Ranking
import Becoming.Inquiry

/-!
# Relevance: the uses of living significance under the continuation condition

`Becoming.Significance` shows that Ren's proposal, the continuation condition, gives living significance. Before Ren decided whether the continuation condition
replaces living significance, every use of living significance in the core and in the periphery's
generative-capacity modules was audited for what it needs of positive relevance and of
`living`. This module states what the audit found. “Positive relevance” names `LivingSignificance`'s parameter
`relevance` (named `positive` before R30); it carries no valence.

* **Living significance from the continuation condition on every frame.** Read positive relevance from significance: realized
  living content whose continuation has significance from every standpoint
  (`Frame.relevance`). Under the continuation condition living significance holds on every frame for every reading of `living`
  (`livingSignificance_of_unrestricted`), and this relevance is the least satisfying living significance, exactly the realized
  living content (`relevance_least`). Every use of living significance takes it as a hypothesis for an arbitrary
  positive relevance, so each is discharged by this one; `Becoming.Bridge` does so for the
  periphery's interface. With no axiom, living significance with this relevance holds exactly where every
  realized living claim's continuation has significance from every standpoint
  (`livingSignificance_relevance_iff`): it is the continuation condition on realized living content.
* **One evaluative object: admission.** On the level paths of a web the continuation condition is
  living significance over admission, an extension over admission is a widening, and under the
  condition widening is retaining and adding from every standpoint (`Web.paths_one_object`): the
  condition, significance and C read one predicate, a formation's admission at a step. The stepwise
  `living` is one reading of which admissions to count.
* **The continuation condition is living significance for anything.** On a frame whose claims are formations at steps, each
  realized at some configuration, the continuation condition holds exactly when living significance holds with every claim living
  and positive relevance read as significance from every standpoint (`unrestricted_iff_livingSignificance`).
  The level paths of every web are such a frame (`Web.unrestricted_iff_paths_livingSignificance`). Replacing living significance
  by the continuation condition widens its scope from living content to anything and weakens “positive” to “has
  significance”.
* **The reason premises keep their scope only on living content.** Where everything has
  significance, A read with bare significance supplies a reason for every response with access
  that yields any new content, living or not; read on living content it supplies one for every
  response securing new living content (`articulates_total`). In a witness the first forces a
  reason the second does not (`BareSignificance.bare_forces_reason`). Read on living content, A gives D
  on living content (`positioned_articulation_of_articulatesLiving`), and the universal reason
  follows from the continuation condition with no seed, neutrality or connection premise
  (`universal_reason_of_unrestricted`).
* **C read on possibilities.** The possibility reading includes a formation at a step when the
  course's levels admit it there. Under the continuation condition, extension under this reading is the continuation condition's
  comparison, retaining and adding what has significance (`Ranking.possible_extends_iff`). In
  every law of the support-gated family it ranks the course without an overdrawing formation
  above the course with it (`Ranking.possible_ranks`), restraint above overdraw
  (`Ranking.possible_restraint`), also with a third formation where the stepwise reading leaves
  them unranked (`Ranking.ThirdParty.possible_extends`), and sharing above winning by
  consumption (`Ranking.possible_contest`). It withholds no event: in a dependent course it
  includes every active formation (`Ranking.possible_of_active`), the malignant formation's
  first event included, which the whole-run reading withholds (`Ranking.malignant_possible`).
* **What it does not rank.** A formation drawing within renewal adds no possibility. Its course
  and the course without it admit the same formations, and neither extends the other
  (`Ranking.possible_tie`), while both readings of `living` rank its presence higher
  (`Ranking.readings_rank_presence`); sharing is an instance (`Ranking.sharing_presence`).
  Generally a level path nowhere lower is never ranked below (`Web.not_added_of_le`), so rest
  and restraint that leave the levels no lower are never worse.
* **Possibilities first.** Ranking by possibilities first and then by a reading's included
  events satisfies C under the possibility reading and is a strict order
  (`Ranking.possibleFirst_order`). Whatever the reading, it ranks the absence of an overdrawing
  formation above its occurrence (`Ranking.possibleFirst_overdraw`); with either reading of
  `living` second, it ranks the presence of a formation drawing within renewal above its absence
  (`Ranking.possibleFirst_presence`). It also ranks a rest that adds no possibility below
  uninterrupted activity (`Ranking.Pause.pause_ranked_below`): counting continuations beyond
  possibilities counts a pause as a loss. The order is a further premise; the continuation condition gives the
  possibility reading alone.

**Ren's decisions, 11 October 2026.** Positive relevance is folded into significance (“Positive
relevance - yes, let's fold”): it is the significance of realized living content. Ren left the
comparison of courses to the AI (“Comparing courses - you decide”), which compares courses on
possibilities; the theorems of the other comparisons stay.

**AI reading, adopted on Ren's delegation of 15 October 2026 (DELEGATED-CHOICES D1, D16).**
- Significance need not be positive, and neither the condition nor `LivingSignificance`'s parameter supplies a
  valence: read from significance, the relevance holds of exactly the realized living content
  (`relevance_least`). The AI once read the living content as 生生; D1's revision withdrew that,
  since the `living` readings do not include further generation. So the AI reads Ren's
  “doesn't have to be positive”.
- The possibility reading of C reads “what has significance is what can form”
  (`Becoming.Significance`) and Ren's “more possibilities of becoming”. It counts what can form,
  not what does: a course in which a formation lives without adding a possibility is neither
  better nor worse than one in which it could live and does not.

What is not derived: the warrant of the continuation condition; the step from significance to a reason (A), which
stays a premise. After the audit Ren folded living significance (`LivingSignificance`) (11 October 2026): it is no longer an axiom.
-/

namespace Becoming

open Generative Generative.InquirySufficiency

/-! ## Positive relevance read from significance -/

section Relevance

variable {S A Q F Pos : Type}

/-- Positive relevance read from significance: realized living content whose continuation has
significance from every standpoint, a claim being some formation's continuation at some step. -/
def Frame.relevance (M : Frame S A Q) (living : Q → Prop) (sig : Pos → Nat → F → Prop)
    (formation : Q → F) (step : Q → Nat) (s : S) (c : Q) : Prop :=
  living c ∧ M.realized s c ∧ ∀ p, sig p (step c) (formation c)

/-- Under the continuation condition living significance holds on every frame for every reading of `living`, with positive
relevance read from significance. The proof instantiates `Unrestricted`, which says that `sig`
holds of every standpoint, step and formation. -/
theorem livingSignificance_of_unrestricted (M : Frame S A Q) (living : Q → Prop) {sig : Pos → Nat → F → Prop}
    (unrestricted : Unrestricted sig) (formation : Q → F) (step : Q → Nat) :
    LivingSignificance M living (M.relevance living sig formation step) :=
  fun _ c alive realized => ⟨alive, realized, fun p => unrestricted (p, step c, formation c)⟩

/-- It is the least positive relevance satisfying living significance: under the continuation condition it holds of exactly the
realized living content, and every positive relevance satisfying living significance holds wherever it does. -/
theorem relevance_least (M : Frame S A Q) (living : Q → Prop) {sig : Pos → Nat → F → Prop}
    (unrestricted : Unrestricted sig) (formation : Q → F) (step : Q → Nat) :
    (∀ s c, M.relevance living sig formation step s c ↔ living c ∧ M.realized s c) ∧
      ∀ relevance, LivingSignificance M living relevance →
        ∀ s c, M.relevance living sig formation step s c → relevance s c :=
  ⟨fun _ c => ⟨fun ⟨alive, realized, _⟩ => ⟨alive, realized⟩,
     fun ⟨alive, realized⟩ => ⟨alive, realized, fun p => unrestricted (p, step c, formation c)⟩⟩,
   fun _ g0 s c ⟨alive, realized, _⟩ => g0 s c alive realized⟩

/-- Positive relevance folded into significance (Ren, 11 October 2026). Read from significance, living significance
holds exactly where the continuation of every realized living claim has significance from every
standpoint: it is the continuation condition on realized living content, with no axiom. -/
theorem livingSignificance_relevance_iff (M : Frame S A Q) (living : Q → Prop) (sig : Pos → Nat → F → Prop)
    (formation : Q → F) (step : Q → Nat) :
    LivingSignificance M living (M.relevance living sig formation step) ↔
      ∀ s c, living c → M.realized s c → ∀ p, sig p (step c) (formation c) :=
  ⟨fun g0 s c alive realized => (g0 s c alive realized).2.2,
   fun all s c alive realized => ⟨alive, realized, all s c alive realized⟩⟩

/-- The continuation condition is living significance for anything. On a frame whose claims are formations at steps, each realized
at some configuration, the continuation condition holds exactly when living significance holds with every claim living and
positive relevance read as significance from every standpoint. -/
theorem unrestricted_iff_livingSignificance (M : Frame S A (F × Nat)) (somewhere : ∀ e, ∃ s, M.realized s e)
    {sig : Pos → Nat → F → Prop} :
    Unrestricted sig ↔ LivingSignificance M (fun _ => True) (fun _ e => ∀ p, sig p e.2 e.1) :=
  ⟨fun unrestricted _ e _ _ p => unrestricted (p, e.2, e.1),
   fun g0 ⟨p, t, f⟩ => match somewhere (f, t) with
    | ⟨s, realized⟩ => g0 s (f, t) trivial realized p⟩

end Relevance

section Paths

variable {F C Pos : Type}

/-- Every formation at every step is admitted along some level path: the one meeting its needs
there. -/
theorem Web.paths_somewhere (W : Web F C) (e : F × Nat) : ∃ l, W.paths.realized l e :=
  ⟨fun _ c => W.need e.2 e.1 c, fun _ _ => Nat.le_refl _⟩

/-- So on the level paths of every web the continuation condition is living significance for anything. -/
theorem Web.unrestricted_iff_paths_livingSignificance (W : Web F C) {sig : Pos → Nat → F → Prop} :
    Unrestricted sig ↔ LivingSignificance W.paths (fun _ => True) (fun _ e => ∀ p, sig p e.2 e.1) :=
  unrestricted_iff_livingSignificance W.paths W.paths_somewhere

/-- **One evaluative object: admission.** On the level paths of a web, with every admitted
formation at a step taken as a claim, the continuation condition, living significance, C and the
retaining and adding of what has significance read one predicate, `W.Admits (l t) t f`. The
condition is living significance over admission (`Web.unrestricted_iff_paths_livingSignificance`);
an extension over admission is a widening (`Web.paths_extension_iff_widens`), so C read as
widening ranks exactly the extensions; and under the condition widening is retaining and adding
from every standpoint (`Web.widens_iff_retains_adds`). The stepwise `living` (active and not
undermining) is then one reading of which admissions to count, and no part of this chain. -/
theorem Web.paths_one_object (W : Web F C) {sig : Pos → Nat → F → Prop} :
    (Unrestricted sig ↔ LivingSignificance W.paths (fun _ => True) (fun _ e => ∀ p, sig p e.2 e.1)) ∧
      (∀ l l' : Nat → C → Nat, Extension W.paths (fun _ => True) l' l ↔ W.Widens l l') ∧
      (Unrestricted sig → ∀ (p : Pos) (l l' : Nat → C → Nat),
        W.Widens l l' ↔ W.Retains sig p l l' ∧ W.Adds sig p l l') :=
  ⟨W.unrestricted_iff_paths_livingSignificance, fun _ _ => W.paths_extension_iff_widens,
   fun unrestricted p _ _ => Web.widens_iff_retains_adds unrestricted p⟩

end Paths

/-! ## The reason premises keep their scope on living content -/

section Reasons

variable {S A Q F Pos : Type}

/-- Where everything has significance, securing ground with bare significance is securing any
new content. -/
theorem securesNewContent_total {H R : Type} {admitted : R → H → Prop}
    {before : H → Q → Prop} {sig : H → Q → Prop} (total : ∀ h c, sig h c) (r : R) :
    SecuresNewContent admitted before sig r ↔ ∀ h, admitted r h → ∃ c, ¬ before h c :=
  ⟨fun secured h inScope => match secured h inScope with
    | ⟨c, _, fresh⟩ => ⟨c, fresh⟩,
   fun novel h inScope => match novel h inScope with
    | ⟨c, fresh⟩ => ⟨c, total h c, fresh⟩⟩

/-- A read on living content: securing living content with significance from one's own
standpoint, with access, supplies a contributory reason. -/
def articulatesLiving {H R : Type} (V : Valuation Pos Q) (access : Pos → R → Prop)
    (admitted : R → H → Prop) (before : H → Q → Prop) (Reason : Pos → R → Prop) :
    Pos × R → Prop
  | (p, r) => access p r →
      SecuresNewContent admitted before (fun _ c => V.living c ∧ V.sig p c) r → Reason p r

/-- Where everything has significance, A read with bare significance supplies a reason for every
response with access that yields any new content, living or not; read on living content it
supplies one for every response securing new living content. -/
theorem articulates_total {H R : Type} {V : Valuation Pos Q} {access : Pos → R → Prop}
    {admitted : R → H → Prop} {before : H → Q → Prop} {Reason : Pos → R → Prop}
    (total : ∀ p c, V.sig p c) :
    (Neutral (articulates V access admitted before Reason) ↔
      ∀ p r, access p r → (∀ h, admitted r h → ∃ c, ¬ before h c) → Reason p r) ∧
    (Neutral (articulatesLiving V access admitted before Reason) ↔
      ∀ p r, access p r → SecuresNewContent admitted before (fun _ c => V.living c) r →
        Reason p r) :=
  ⟨⟨fun articulate p r available novel =>
      articulate (p, r) available ((securesNewContent_total (fun _ c => total p c) r).2 novel),
    fun all ⟨p, r⟩ available secured =>
      all p r available ((securesNewContent_total (fun _ c => total p c) r).1 secured)⟩,
   ⟨fun articulate p r available secured =>
      articulate (p, r) available fun h inScope => match secured h inScope with
        | ⟨c, alive, fresh⟩ => ⟨c, ⟨alive, total p c⟩, fresh⟩,
    fun all ⟨p, r⟩ available secured =>
      all p r available fun h inScope => match secured h inScope with
        | ⟨c, ⟨alive, _⟩, fresh⟩ => ⟨c, alive, fresh⟩⟩⟩

/-- D on living content follows from A read on living content, with living significance's unindexed
significance. -/
theorem positioned_articulation_of_articulatesLiving {H R : Type} {V : Valuation Pos Q}
    {access : Pos → R → Prop} {admitted : R → H → Prop} {before : H → Q → Prop}
    {Reason : Pos → R → Prop}
    (articulate : Neutral (articulatesLiving V access admitted before Reason)) :
    PositionedArticulation access admitted before (fun _ c => V.living c ∧ ∀ p, V.sig p c)
      Reason :=
  fun p r available secured => articulate (p, r) available fun h inScope =>
    match secured h inScope with
    | ⟨c, ⟨alive, all⟩, fresh⟩ => ⟨c, ⟨alive, all p⟩, fresh⟩

/-- A sound inquiry whose goal is new living content gives every position with access to it a
contributory reason, from living significance at the level of claims and A read on living content. -/
theorem universal_reason_living {R : Type} {k : Nat} (M : Frame S A Q) (V : Valuation Pos Q)
    (before : S → Q → Prop) {safe : S → A → S → Prop} {sense : S → A → S → Fin k}
    {response : R → List A} {B : S → Prop}
    (access : Pos → Policy A R k → Prop) (Reason : Pos → Policy A R k → Prop)
    (all : V.Significant)
    (articulate : Neutral (articulatesLiving V access (Scope M.P sense response B) before Reason))
    (policy : Policy A R k)
    (sound : Sound M.P safe (Novel M V.living before) sense response policy B) :
    ∀ p, access p policy → Reason p policy :=
  fun p available => articulate (p, policy) available fun t reached =>
    match Scope.secures sound t reached with
    | ⟨c, alive, _, fresh⟩ => ⟨c, ⟨alive, all p c alive⟩, fresh⟩

/-- Under the continuation condition the universal reason needs no seed, neutrality or connection premise: on
every reading in which a claim's significance from a standpoint is that of some formation's
continuation at some step, a sound inquiry whose goal is new living content gives every
position with access to it a contributory reason, from A read on living content. -/
theorem universal_reason_of_unrestricted {R : Type} {k : Nat} (M : Frame S A Q)
    (V : Valuation Pos Q) (before : S → Q → Prop) {safe : S → A → S → Prop}
    {sense : S → A → S → Fin k} {response : R → List A} {B : S → Prop}
    (access : Pos → Policy A R k → Prop) (Reason : Pos → Policy A R k → Prop)
    {sig : Pos → Nat → F → Prop} (unrestricted : Unrestricted sig) (formation : Q → F)
    (step : Q → Nat) (reads : ∀ p c, sig p (step c) (formation c) → V.sig p c)
    (articulate : Neutral (articulatesLiving V access (Scope M.P sense response B) before Reason))
    (policy : Policy A R k)
    (sound : Sound M.P safe (Novel M V.living before) sense response policy B) :
    ∀ p, access p policy → Reason p policy :=
  universal_reason_living M V before access Reason
    (Valuation.premises_of_unrestricted unrestricted formation step reads).1 articulate policy sound

end Reasons

/-! ### Bare significance widens A

One position and one response with one outcome. Of two claims, `true` is living and held before;
`false` is new and not living. -/

namespace BareSignificance

def valuation : Valuation Unit Bool :=
  ⟨fun c => c = true, fun _ _ => False, fun _ _ => True, fun _ _ => True⟩

def admitted : Unit → Unit → Prop := fun _ _ => True

def before : Unit → Bool → Prop := fun _ c => c = true

/-- Everything has significance. A read with bare significance forces a reason for the response,
whose only new content is not living; read on living content it forces none, for the empty
reason satisfies it. -/
theorem bare_forces_reason :
    (∀ p c, valuation.sig p c) ∧
    (∀ Reason : Unit → Unit → Prop,
      Neutral (articulates valuation (fun _ _ => True) admitted before Reason) → Reason () ()) ∧
    Neutral (articulatesLiving valuation (fun _ _ => True) admitted before fun _ _ => False) :=
  ⟨fun _ _ => trivial,
   fun _ articulate => articulate ((), ()) trivial fun _ _ => ⟨false, trivial, Bool.noConfusion⟩,
   fun ⟨_, _⟩ _ secured => match secured () trivial with
    | ⟨_, ⟨alive, _⟩, fresh⟩ => fresh alive⟩

end BareSignificance

/-! ## Levels nowhere lower are never ranked below -/

namespace Web

variable {F C : Type} {W : Web F C}

/-- A level path at least as high at every step and condition includes the other: it admits
whatever the other admits. -/
theorem Includes.of_le {l l' : Nat → C → Nat} (le : ∀ t c, l' t c ≤ l t c) : W.Includes l l' :=
  fun t _ admits => Admits.mono (le t) admits

/-- A level path nowhere lower is never ranked below by retaining and adding: a path whose levels
are nowhere higher adds nothing against it, whatever has significance. -/
theorem not_added_of_le {Pos : Type} {sig : Pos → Nat → F → Prop} {p : Pos}
    {l l' : Nat → C → Nat} (le : ∀ t c, l' t c ≤ l t c) : ¬ W.Adds sig p l' l :=
  ((Includes.of_le le).retains sig p).not_added

end Web

/-! ## C read on possibilities -/

namespace Ranking

open RelationalRenewal RelationalRenewal.Law

variable {W F C : Type}

/-- The stepwise reading is the `living` of `Web.valuation`. -/
theorem stepwise_iff {Pos : Type} (U : W → Web F C) (w : W) (own sig : Pos → F × Nat → Prop)
    (e : F × Nat) : stepwise U w e ↔ ((U w).valuation own sig).living e :=
  Iff.rfl

/-- The relation-level reading is the `living` of `Web.relations`. -/
theorem relational_iff {Pos : Type} (U : W → Web F C) (w : W) (own sig : Pos → F × C × Nat → Prop)
    (e : F × C × Nat) : relational U w e ↔ ((U w).relations own sig).living e :=
  Iff.rfl

/-- The possibility reading: a course includes a formation at a step when the course's levels
admit it there, active or not. -/
def possible (U : W → Web F C) (w : W) (e : F × Nat) : Prop :=
  (U w).Admits ((U w).level e.2) e.2 e.1

/-- In a dependent course the possibility reading includes every active formation, so every event
that either reading of `living` includes. -/
theorem possible_of_active {U : W → Web F C} {w : W} (dependent : (U w).Dependent)
    {e : F × Nat} (active : (U w).active e.2 e.1) : possible U w e :=
  dependent e.2 e.1 active

/-- The course without the focal formation admits every formation at every step. -/
theorem absent_admits_all (L : Law) (fWithin : L.needF ≤ L.needG) (gStart : L.needG ≤ L.start) :
    ∀ e, possible (course L) .absent e
  | (.focal, t), _, _ =>
    Nat.le_trans fWithin (Nat.le_trans gStart (undisturbed_sustains L gStart t))
  | (.sustaining, t), _, _ => Nat.le_trans gStart (undisturbed_sustains L gStart t)

/-- For every law of the family in which the focal formation draws beyond renewal from some step
on, the course without it extends the course with it under the possibility reading. -/
theorem possible_extends (L : Law) (positive : 0 < L.needG) (fWithin : L.needF ≤ L.needG)
    (gStart : L.needG ≤ L.start) {T0 : Nat}
    (over : ∀ t, T0 ≤ t → L.renew + L.contrib t < L.draw t) :
    ExtendsUnder (possible (course L)) .occurs .absent :=
  match overdraw_consuming L positive fWithin over with
  | ⟨_, T, lost⟩ =>
    ⟨fun e _ => absent_admits_all L fWithin gStart e, (.sustaining, T), trivial,
     absent_admits_all L fWithin gStart (.sustaining, T),
     fun admitted => lost T (Nat.le_refl T) (admitted () trivial)⟩

/-- So every comparison satisfying C under the possibility reading ranks the course without the
overdrawing formation strictly higher. -/
theorem possible_ranks (L : Law) (positive : 0 < L.needG) (fWithin : L.needF ≤ L.needG)
    (gStart : L.needG ≤ L.start) {T0 : Nat}
    (over : ∀ t, T0 ≤ t → L.renew + L.contrib t < L.draw t)
    {Better : Course → Course → Prop} (ranks : ComparisonUnder (possible (course L)) Better) :
    Better .occurs .absent :=
  ranks _ _ (possible_extends L positive fWithin gStart over)

/-- Both courses of a law have the law's requirements and needs, so the possibility reading of
either is admission on the law's web. -/
theorem possible_course_iff (L : Law) : ∀ w e, possible (course L) w e ↔
    (Web.static L.unfolding).Admits ((course L w).level e.2) e.2 e.1
  | .occurs, _ => Iff.rfl
  | .absent, _ => Iff.rfl

/-- Under the continuation condition, extension under the possibility reading is the continuation condition's comparison: one
course extends another exactly when, on the law's web, its levels retain what has significance
along the other's and add to it. -/
theorem possible_extends_iff (L : Law) {Pos : Type} {sig : Pos → Nat → Part → Prop}
    (unrestricted : Unrestricted sig) (p : Pos) (w w' : Course) :
    ExtendsUnder (possible (course L)) w w' ↔
      (Web.static L.unfolding).Retains sig p (course L w').level (course L w).level ∧
        (Web.static L.unfolding).Adds sig p (course L w').level (course L w).level :=
  have conv := possible_course_iff L
  ⟨fun ⟨keeps, e, _, included, fresh⟩ =>
    ⟨fun t f _ admits => (conv w' (f, t)).1 (keeps (f, t) ((conv w (f, t)).2 admits)),
     e.2, e.1, unrestricted (p, e.2, e.1), (conv w' e).1 included,
     fun admits => fresh ((conv w e).2 admits)⟩,
   fun ⟨retains, t, f, _, admits, ended⟩ =>
    ⟨fun e included =>
      (conv w' e).2 (retains e.2 e.1 (unrestricted (p, e.2, e.1)) ((conv w e).1 included)),
     (f, t), trivial, (conv w' (f, t)).2 admits,
     fun included => ended ((conv w (f, t)).1 included)⟩⟩

/-- Malignant growth under the possibility reading: the course without the formation extends the
course with it, while the formation's first event is included, as the stepwise reading includes
it and the whole-run reading withholds it. -/
theorem malignant_possible :
    ExtendsUnder (possible (course malignant)) .occurs .absent ∧
      possible (course malignant) .occurs (.focal, 0) ∧
      stepwise (course malignant) .occurs (.focal, 0) ∧
      ¬ wholeRun (course malignant) .occurs (.focal, 0) :=
  have over : ∀ t, 0 ≤ t → malignant.renew + malignant.contrib t < malignant.draw t :=
    fun _ _ => Nat.lt_succ_of_le (Nat.le_succ 1)
  ⟨possible_extends malignant Nat.zero_lt_two (Nat.le_succ 1)
     (Nat.le_succ_of_le (Nat.le_succ 2)) over,
   fun _ _ => Nat.le_succ_of_le (Nat.le_succ_of_le (Nat.le_succ 1)),
   included_before_loss malignant (t := 0)
     (Nat.le_succ_of_le (Nat.le_succ_of_le (Nat.le_succ 1))) (Nat.le_refl 2) (Nat.le_succ 1),
   fun ⟨_, notConsuming⟩ => notConsuming ((Web.static_consumingIn _ _).mpr
     (overdraw_consuming malignant Nat.zero_lt_two (Nat.le_succ 1) over).1)⟩

/-- Under the possibility reading sharing extends winning by consumption. -/
theorem possible_contest : ExtendsUnder (possible contest) .wins .shares :=
  match overdraw_consuming winning Nat.zero_lt_one (Nat.zero_le 1) (T0 := 0)
      (fun _ _ => Nat.lt_succ_self 1) with
  | ⟨_, T, lost⟩ =>
    have shares : ∀ e, possible contest .shares e := fun e =>
      possible_of_active (U := contest) (w := .shares)
        ((Web.static_dependent _).mpr (unfolding_dependent sharing))
        (sharing_included e).1
    ⟨fun e _ => shares e, (.sustaining, T), trivial, shares (.sustaining, T),
     fun admitted => lost T (Nat.le_refl T) (admitted () trivial)⟩

/-- In the two-part family, a course in which every need stays met extends, under the
possibility reading, any course in which overdraw ends the sustaining formation's support. -/
theorem possible_restraint {stopping overdrawing : Law}
    (met : ∀ t, stopping.needG ≤ stopping.level t ∧ stopping.needF ≤ stopping.level t)
    (positive : 0 < overdrawing.needG) (fWithin : overdrawing.needF ≤ overdrawing.needG)
    {T0 : Nat}
    (over : ∀ t, T0 ≤ t → overdrawing.renew + overdrawing.contrib t < overdrawing.draw t) :
    ExtendsUnder (possible (restraint stopping overdrawing)) .overdraws .stops :=
  match overdraw_consuming overdrawing positive fWithin over with
  | ⟨_, T, lost⟩ =>
    have stops : ∀ e, possible (restraint stopping overdrawing) .stops e
      | (.focal, t), _, _ => (met t).2
      | (.sustaining, t), _, _ => (met t).1
    ⟨fun e _ => stops e, (.sustaining, T), trivial, stops (.sustaining, T),
     fun admitted => lost T (Nat.le_refl T) (admitted () trivial)⟩

namespace ThirdParty

/-- With a third formation sharing the condition, restraint still extends overdraw under the
possibility reading: every formation the overdrawing course admits, the restrained course admits,
and the sustaining formation is admitted only there from step 6. -/
theorem possible_extends : ExtendsUnder (possible courses) .overdraws .stops :=
  ⟨fun e admitted => match e, admitted with
    | (.focal, _), _ => fun _ no => False.elim no
    | (.sustaining, t), _ => fun _ _ => stops_supports t
    | (.third, t), admitted =>
      absurd (admitted () trivial) (Nat.not_le_of_gt (over_below_seven t)),
   (.sustaining, 6), trivial, fun _ _ => stops_supports 6,
   fun admitted => Nat.not_succ_le_zero 0 (admitted () trivial)⟩

end ThirdParty

/-- A formation drawing within renewal adds no possibility: its course and the course without it
admit every formation at every step, and neither extends the other. -/
theorem possible_tie (L : Law) (within : ∀ t, L.draw t ≤ L.renew + L.contrib t)
    (gStart : L.needG ≤ L.start) (fStart : L.needF ≤ L.start) :
    (∀ w e, possible (course L) w e) ∧ ¬ ExtendsUnder (possible (course L)) .occurs .absent ∧
      ¬ ExtendsUnder (possible (course L)) .absent .occurs :=
  have kept := within_renewal_sustains L within gStart fStart
  have all : ∀ w e, possible (course L) w e
    | .occurs, (.focal, t), _, _ => Nat.le_trans fStart (kept t)
    | .occurs, (.sustaining, t), _, _ => Nat.le_trans gStart (kept t)
    | .absent, (.focal, t), _, _ => Nat.le_trans fStart (undisturbed_sustains L gStart t)
    | .absent, (.sustaining, t), _, _ => Nat.le_trans gStart (undisturbed_sustains L gStart t)
  ⟨all, fun ⟨_, _, _, _, fresh⟩ => fresh (all _ _), fun ⟨_, _, _, _, fresh⟩ => fresh (all _ _)⟩

/-- Both readings of `living` rank the course of a formation drawing within renewal above the
course without it: they include its events, which the course without it lacks. -/
theorem readings_rank_presence (L : Law) (within : ∀ t, L.draw t ≤ L.renew + L.contrib t)
    (gStart : L.needG ≤ L.start) (fStart : L.needF ≤ L.start) :
    ExtendsUnder (wholeRun (course L)) .absent .occurs ∧
      ExtendsUnder (stepwise (course L)) .absent .occurs :=
  have kept := within_renewal_sustains L within gStart fStart
  have included := stops_included (stopping := L) (overdrawing := L)
    (fun t => ⟨Nat.le_trans gStart (kept t), Nat.le_trans fStart (kept t)⟩)
  ⟨⟨fun e _ => (included e).1, (.focal, 0), trivial, (included (.focal, 0)).1,
     fun ⟨active, _⟩ => active⟩,
   ⟨fun e _ => (included e).2, (.focal, 0), trivial, (included (.focal, 0)).2,
     fun ⟨active, _⟩ => active⟩⟩

/-- In sharing, whose formation draws only the renewal, the possibility reading leaves the course
with the formation and the course without it unranked, while both readings of `living` rank the
course with it higher. -/
theorem sharing_presence :
    ¬ ExtendsUnder (possible (course sharing)) .absent .occurs ∧
      ¬ ExtendsUnder (possible (course sharing)) .occurs .absent ∧
      ExtendsUnder (wholeRun (course sharing)) .absent .occurs ∧
      ExtendsUnder (stepwise (course sharing)) .absent .occurs :=
  have within : ∀ t, sharing.draw t ≤ sharing.renew + sharing.contrib t := fun _ => Nat.le_refl 1
  have tie := possible_tie sharing within (Nat.le_succ_of_le (Nat.le_succ 1)) (Nat.zero_le 3)
  have ranks :=
    readings_rank_presence sharing within (Nat.le_succ_of_le (Nat.le_succ 1)) (Nat.zero_le 3)
  ⟨tie.2.2, tie.2.1, ranks.1, ranks.2⟩

/-! ### Possibilities first, then a reading -/

/-- Possibilities first, then a reading's included events: the second course is better when it
extends the first under the possibility reading, or admits the same formations and extends it
under the reading. -/
def possibleFirst (U : W → Web F C) (reading : W → F × Nat → Prop) (w w' : W) : Prop :=
  ExtendsUnder (possible U) w w' ∨
    ((∀ e, possible U w e ↔ possible U w' e) ∧ ExtendsUnder reading w w')

/-- It satisfies C under the possibility reading, and it is irreflexive and transitive. -/
theorem possibleFirst_order (U : W → Web F C) (reading : W → F × Nat → Prop) :
    ComparisonUnder (possible U) (possibleFirst U reading) ∧
      (∀ w, ¬ possibleFirst U reading w w) ∧
      ∀ w w' w'', possibleFirst U reading w w' → possibleFirst U reading w' w'' →
        possibleFirst U reading w w'' :=
  ⟨fun _ _ ext => .inl ext,
   fun _ better => match better with
    | .inl ⟨_, _, _, included, fresh⟩ => fresh included
    | .inr ⟨_, _, _, _, included, fresh⟩ => fresh included,
   fun _ _ _ first second => match first, second with
    | .inl ⟨keeps, _, _, _, _⟩, .inl ⟨keeps', e, _, included, fresh⟩ =>
      .inl ⟨fun e held => keeps' e (keeps e held), e, trivial, included,
        fun held => fresh (keeps e held)⟩
    | .inl ⟨keeps, e, _, included, fresh⟩, .inr ⟨same, _⟩ =>
      .inl ⟨fun e held => (same e).1 (keeps e held), e, trivial, (same e).1 included, fresh⟩
    | .inr ⟨same, _⟩, .inl ⟨keeps, e, _, included, fresh⟩ =>
      .inl ⟨fun e held => keeps e ((same e).1 held), e, trivial, included,
        fun held => fresh ((same e).1 held)⟩
    | .inr ⟨same, keeps, _, _, _, _⟩, .inr ⟨same', keeps', e, _, included, fresh⟩ =>
      .inr ⟨fun e => (same e).trans (same' e),
        fun e held => keeps' e (keeps e held), e, trivial, included,
        fun held => fresh (keeps e held)⟩⟩

/-- In every law of the family, possibilities first ranks the absence of an overdrawing formation
above its occurrence, whatever the reading. -/
theorem possibleFirst_overdraw (L : Law) (reading : Course → Part × Nat → Prop)
    (positive : 0 < L.needG) (fWithin : L.needF ≤ L.needG) (gStart : L.needG ≤ L.start)
    {T0 : Nat} (over : ∀ t, T0 ≤ t → L.renew + L.contrib t < L.draw t) :
    possibleFirst (course L) reading .occurs .absent :=
  .inl (possible_extends L positive fWithin gStart over)

/-- With either reading of `living` second, it ranks the presence of a formation drawing within
renewal above its absence. -/
theorem possibleFirst_presence (L : Law) (within : ∀ t, L.draw t ≤ L.renew + L.contrib t)
    (gStart : L.needG ≤ L.start) (fStart : L.needF ≤ L.start) :
    possibleFirst (course L) (wholeRun (course L)) .absent .occurs ∧
      possibleFirst (course L) (stepwise (course L)) .absent .occurs :=
  have all := (possible_tie L within gStart fStart).1
  have same : ∀ e, possible (course L) .absent e ↔ possible (course L) .occurs e :=
    fun e => ⟨fun _ => all .occurs e, fun _ => all .absent e⟩
  have ranks := readings_rank_presence L within gStart fStart
  ⟨.inr ⟨same, ranks.1⟩, .inr ⟨same, ranks.2⟩⟩

/-! ### A rest

One formation needing one unit of a condition held at one. In the course `true` it rests at
step 0, though supported; in the course `false` it is active at every step. -/

namespace Pause

def courses (rests : Bool) : Web Unit Unit where
  level _ _ := 1
  active t _ := rests = true → t ≠ 0
  requires _ _ _ := True
  need _ _ _ := 1
  draws _ _ _ := False

/-- The two courses admit the same formations, so neither extends the other under the
possibility reading; with either reading of `living` second, possibilities first ranks the
rest below uninterrupted activity. -/
theorem pause_ranked_below :
    (∀ w e, possible courses w e) ∧ ¬ ExtendsUnder (possible courses) true false ∧
      ¬ ExtendsUnder (possible courses) false true ∧
      possibleFirst courses (wholeRun courses) true false ∧
      possibleFirst courses (stepwise courses) true false :=
  have all : ∀ w e, possible courses w e := fun _ _ _ _ => Nat.le_refl 1
  have same : ∀ e, possible courses true e ↔ possible courses false e :=
    fun e => ⟨fun _ => all false e, fun _ => all true e⟩
  have notConsuming : ∀ w f, ¬ (courses w).ConsumingIn f := fun _ _ ⟨_, _, drawn, _⟩ => drawn
  have notUndermining : ∀ w t f, ¬ (courses w).UnderminingAt t f :=
    fun _ _ _ ⟨_, drawn, _⟩ => drawn
  have active : ∀ e : Unit × Nat, (courses false).active e.2 e.1 := fun _ no => Bool.noConfusion no
  have resting : ¬ (courses true).active 0 () := fun rests => rests rfl rfl
  ⟨all, fun ⟨_, _, _, _, fresh⟩ => fresh (all _ _), fun ⟨_, _, _, _, fresh⟩ => fresh (all _ _),
   .inr ⟨same, fun e _ => ⟨active e, notConsuming false e.1⟩, ((), 0), trivial,
     ⟨active ((), 0), notConsuming false ()⟩, fun ⟨rests, _⟩ => resting rests⟩,
   .inr ⟨same, fun e _ => ⟨active e, notUndermining false e.2 e.1⟩, ((), 0), trivial,
     ⟨active ((), 0), notUndermining false 0 ()⟩, fun ⟨rests, _⟩ => resting rests⟩⟩

end Pause

end Ranking

end Becoming
