import Becoming.Frame
import Becoming.Extension
import Becoming.Witnesses

/-!
# What comparison C ranks under each reading of `living`

In the periphery, `RenewalComparison` reads `living` over whole runs: a formation event
is living when its formation is active and does not consume in that course. With this
reading, C ranks the course of the support-gated law without an overdrawing formation
strictly above the course with it, and ranks sharing above winning by consumption.
Here both comparisons are stated on the core, and repeated under the stepwise reading,
kept beside the whole-run reading on Ren's delegation of 15 October 2026, with no comparison using
it (DELEGATED-CHOICES D1, D10): an event is living when it is active and not undermining.

A reading is compared through a frame whose configurations are the courses and whose
realized claims are the events the reading includes; C is `Comparison` on that frame.

Results:
* The law of comparison with a renewing course, for every family of courses
  (`renewed_extends_iff`): under either reading, a course that renews every condition
  extends another exactly when it is active at every event the other includes and at some
  event the other withholds; where every formation is active at every step of it, exactly
  when the other withholds some event (`renewed_active_extends_iff`). The family results
  below on absence (whole-run), restraint and sharing are instances. The renewal cannot be
  dropped under the stepwise reading (`ThirdParty.renewal_needed`).
* The whole-run law of easing (`wholeRun_extends_iff_of_eases`): from a course where
  activity needs support to one that asks no more, holds every condition at least as high
  and draws on nothing more, and where activity follows support, no event the whole-run
  reading includes is withdrawn, so the second extends the first exactly when it includes
  an event the first withholds. Under the stepwise reading easing withdraws exactly the events the
  easing course undermines (`stepwise_kept_iff`), so the second extends the first exactly when it
  undermines no event the first includes and includes one the first withholds
  (`stepwise_extends_iff_of_eases`); a course in which no condition's level falls undermines nothing
  (`not_undermining_of_rising`), so there the stepwise law is the whole-run one
  (`stepwise_extends_iff_of_rising`). Easing alone does not suffice (`ThirdParty.stepwise_not_monotone`).
* The relation-level reading (`relational`, the `living` of `Web.relations`): a claim is a formation's
  relation to a condition at a step. Under easing it withdraws exactly the relations the easing course
  no longer takes part in or undermines (`relational_kept_iff`, `relational_extends_iff_of_eases`), so
  where no level falls and the easing course takes part wherever the other does its law is the
  whole-run one (`relational_extends_iff_of_rising`); in the two-part family it includes the focal
  formation's relation where the stepwise reading includes its event, and leaves absence and
  occurrence unranked as that reading does (`relational_unranked`).
* The course without a formation extends the course with it only if the reading
  withholds every event of that formation. This holds for every reading that includes
  only active events.
* Whole-run reading: for every law of the family in which the focal formation draws
  beyond renewal, the course without it extends the course with it, so every comparison
  satisfying C ranks it higher.
* Stepwise reading: an event of the focal formation whose step leaves every need met is
  included, and the course without the formation lacks it. Each course then has
  included events the other lacks, and an irreflexive, transitive comparison satisfying
  C prefers the course with the formation. Malignant growth and winning by consumption
  are instances. When no event of the formation is included, as when its first step
  already crosses support, the stepwise reading too ranks the absence higher
  (`Immediate`).
* Stepwise reading, contest: sharing still extends winning by consumption, because
  sharing includes every event, the winner's among them.
* Either reading, restraint: a course in which every need stays met and every formation is
  active extends any course in which some event is withheld, an instance of the law of
  comparison; in the two-part family, meeting every need makes every formation active, and
  overdraw that ends the sustaining formation's support withholds its later events. Malignant
  growth is ranked below the same formation stopping after its first step, before the
  threshold, though under the stepwise reading that first step is included in both.
* When the restrained course does not meet every need, the restraint comparison can be
  lost under the stepwise reading: when a third formation shares the condition, a
  restrained formation's later draw can undermine the third formation's once-met
  dependence, and neither course extends the other (`ThirdParty`): the restrained course
  undermines an event the overdrawing one includes, the premise the stepwise law of easing adds
  (`ThirdParty.undermines_included`). Under the whole-run reading restraint still extends overdraw
  there, by the law of easing.

So under the stepwise reading C alone still ranks sharing above winning by consumption,
and restraint that meets every need above overdraw. For a formation with an event
whose step leaves every need met, it no longer ranks the formation's absence above its
occurrence: in that family what it loses is the comparison with non-existence. A reading
of `living` that keeps that ranking must withhold the formation's events before the
loss, as the whole-run reading does. Which reading C should use belongs to the choice of
the reading of 生生.

Each course is a web (`Web F C`): the law's unfolding is read through `Web.static`, whose
dependences do not change (R34, 20 October 2026; before, a course was the foundation's
fixed-dependence record). That the stepwise reading is the `living` of `Web.valuation` is stated
in `Becoming.Relevance` (`Ranking.stepwise_iff`), so this module imports no valuation and no
condition.

C occurs only as a hypothesis or as the definition `Comparison`. No axiom occurs.
-/

namespace Becoming

open RelationalRenewal RelationalRenewal.Law

namespace Ranking

/-! ## Courses and readings -/

/-- Courses as a frame whose realized claims are the events a reading includes. -/
def frame {W E : Type} (reading : W → E → Prop) : Frame W Unit E :=
  ⟨⟨fun _ _ _ => False⟩, reading⟩

/-- One course extends another under a reading: it includes every event the other does,
and one more. -/
def ExtendsUnder {W E : Type} (reading : W → E → Prop) (w w' : W) : Prop :=
  Extension (frame reading) (fun _ => True) w w'

/-- C over courses under a reading. -/
def ComparisonUnder {W E : Type} (reading : W → E → Prop) (Better : W → W → Prop) : Prop :=
  Comparison (frame reading) (fun _ => True) Better

variable {W F C : Type}

/-- The whole-run reading of a family of courses, each a web: active and not consuming over the
run. -/
def wholeRun (U : W → Web F C) (w : W) (e : F × Nat) : Prop :=
  (U w).active e.2 e.1 ∧ ¬ (U w).ConsumingIn e.1

/-- The stepwise reading: active and not undermining. It is the `living` of `Web.valuation`
(`Ranking.stepwise_iff`, in `Becoming.Relevance`). -/
def stepwise (U : W → Web F C) (w : W) (e : F × Nat) : Prop :=
  (U w).active e.2 e.1 ∧ ¬ (U w).UnderminingAt e.2 e.1

/-! ## Laws over every family of courses -/

/-- Where a reading includes exactly the events of `w'` that satisfy `A`, `w'` extends another
course exactly when every event the other includes satisfies `A` and some event satisfying
`A` is withheld by the other. -/
theorem extendsUnder_iff_of_exact {E : Type} {reading : W → E → Prop} {w w' : W}
    {A : E → Prop} (exact : ∀ e, reading w' e ↔ A e) :
    ExtendsUnder reading w w' ↔ (∀ e, reading w e → A e) ∧ ∃ e, A e ∧ ¬ reading w e :=
  ⟨fun ⟨covers, e, _, included, withheld⟩ =>
    ⟨fun e c => (exact e).mp (covers e c), e, (exact e).mp included, withheld⟩,
   fun ⟨covers, e, holds, withheld⟩ =>
    ⟨fun e c => (exact e).mpr (covers e c), e, trivial, (exact e).mpr holds, withheld⟩⟩

/-- In a course that renews every condition the whole-run reading includes exactly the
active events: nothing there consumes. -/
theorem wholeRun_of_renewed {U : W → Web F C} {w : W} (renewed : ∀ c, (U w).Renewed c)
    (e : F × Nat) : wholeRun U w e ↔ (U w).active e.2 e.1 :=
  ⟨fun included => included.1,
   fun active => ⟨active, fun ⟨_, c, _, consumed⟩ => Web.renewed_not_consumed (renewed c) consumed⟩⟩

/-- In a course that renews every condition the stepwise reading includes exactly the active
events: nothing there undermines. -/
theorem stepwise_of_renewed {U : W → Web F C} {w : W} (renewed : ∀ c, (U w).Renewed c)
    (e : F × Nat) : stepwise U w e ↔ (U w).active e.2 e.1 :=
  ⟨fun included => included.1,
   fun active => ⟨active, fun ⟨c, _, g, depends, _, fell⟩ =>
     Nat.not_le_of_gt fell (renewed c e.2 g depends).2⟩⟩

/-- The law of comparison with a renewing course, for every family of courses: under either
reading, a course that renews every condition extends another exactly when it is active at
every event the other includes and at some event the other withholds. -/
theorem renewed_extends_iff {U : W → Web F C} {w w' : W}
    (renewed : ∀ c, (U w').Renewed c) :
    (ExtendsUnder (wholeRun U) w w' ↔ (∀ e, wholeRun U w e → (U w').active e.2 e.1) ∧
      ∃ e, (U w').active e.2 e.1 ∧ ¬ wholeRun U w e) ∧
    (ExtendsUnder (stepwise U) w w' ↔ (∀ e, stepwise U w e → (U w').active e.2 e.1) ∧
      ∃ e, (U w').active e.2 e.1 ∧ ¬ stepwise U w e) :=
  ⟨extendsUnder_iff_of_exact (wholeRun_of_renewed renewed),
   extendsUnder_iff_of_exact (stepwise_of_renewed renewed)⟩

/-- Where moreover every formation is active at every step of the renewing course, it
extends exactly the courses that withhold some event, under either reading. -/
theorem renewed_active_extends_iff {U : W → Web F C} {w w' : W}
    (renewed : ∀ c, (U w').Renewed c) (always : ∀ t f, (U w').active t f) :
    (ExtendsUnder (wholeRun U) w w' ↔ ∃ e, ¬ wholeRun U w e) ∧
    (ExtendsUnder (stepwise U) w w' ↔ ∃ e, ¬ stepwise U w e) :=
  ⟨⟨fun ext => match ((renewed_extends_iff renewed).1.mp ext).2 with
      | ⟨e, _, withheld⟩ => ⟨e, withheld⟩,
    fun ⟨e, withheld⟩ => (renewed_extends_iff renewed).1.mpr
      ⟨fun e _ => always e.2 e.1, e, always e.2 e.1, withheld⟩⟩,
   ⟨fun ext => match ((renewed_extends_iff renewed).2.mp ext).2 with
      | ⟨e, _, withheld⟩ => ⟨e, withheld⟩,
    fun ⟨e, withheld⟩ => (renewed_extends_iff renewed).2.mpr
      ⟨fun e _ => always e.2 e.1, e, always e.2 e.1, withheld⟩⟩⟩

/-- A formation is active wherever the conditions it depends on support it. -/
def ActiveWhereSupported (U : Web F C) : Prop :=
  ∀ t f, U.Supported t f → U.active t f

/-- Activity that follows support makes every formation active at every step of a course
that renews every condition. -/
theorem active_of_renewed {U : Web F C} (gated : ActiveWhereSupported U)
    (renewed : ∀ c, U.Renewed c) (t : Nat) (f : F) : U.active t f :=
  gated t f fun c depends => (renewed c t f depends).1

/-- `V` eases `U`: it asks no dependence `U` lacks and no greater need, holds every condition
at least as high, and draws on nothing `U` does not. -/
def Eases (U V : Web F C) : Prop :=
  (∀ t f c, V.requires t f c → U.requires t f c) ∧ (∀ t f c, V.need t f c ≤ U.need t f c) ∧
    (∀ t c, U.level t c ≤ V.level t c) ∧ ∀ t f c, V.draws t f c → U.draws t f c

/-- **Easing keeps activity.** From a course where activity needs support to one where activity
follows support and that eases it, a formation active in the first at a step is active in the
second there: the first's support there is the second's. -/
theorem active_of_eases {U V : Web F C} (dependent : U.Dependent) (gated : ActiveWhereSupported V)
    (eases : Eases U V) {t : Nat} {f : F} (active : U.active t f) : V.active t f :=
  gated t f fun c depends => Nat.le_trans (eases.2.1 t f c)
    (Nat.le_trans (dependent t f active c (eases.1 t f c depends)) (eases.2.2.1 t c))

/-- Easing never withdraws an event the whole-run reading includes: from a course where
activity needs support to one where activity follows support and that eases it, every event
the whole-run reading includes stays included. -/
theorem wholeRun_mono {U : W → Web F C} {w w' : W} (dependent : (U w).Dependent)
    (gated : ActiveWhereSupported (U w')) (eases : Eases (U w) (U w')) {e : F × Nat} :
    wholeRun U w e → wholeRun U w' e
  | ⟨active, notConsuming⟩ =>
    ⟨active_of_eases dependent gated eases active,
     fun ⟨s, c, drawn, g, T, depends, lost⟩ => notConsuming ⟨s, c, eases.2.2.2 s e.1 c drawn, g, T,
       eases.1 T g c depends, fun t later => Nat.lt_of_le_of_lt (eases.2.2.1 t c)
         (Nat.lt_of_lt_of_le (lost t later) (eases.2.1 T g c))⟩⟩

/-- The whole-run law of easing: under its conditions the easing course extends the other
exactly when it includes some event the other withholds. Under the stepwise reading the law
needs a further premise, that the easing course undermine no event the other includes
(`stepwise_extends_iff_of_eases`, `ThirdParty.stepwise_not_monotone`). -/
theorem wholeRun_extends_iff_of_eases {U : W → Web F C} {w w' : W}
    (dependent : (U w).Dependent) (gated : ActiveWhereSupported (U w'))
    (eases : Eases (U w) (U w')) :
    ExtendsUnder (wholeRun U) w w' ↔ ∃ e, wholeRun U w' e ∧ ¬ wholeRun U w e :=
  ⟨fun ⟨_, e, _, included, withheld⟩ => ⟨e, included, withheld⟩,
   fun ⟨e, included, withheld⟩ =>
    ⟨fun _ c => wholeRun_mono dependent gated eases c, e, trivial, included, withheld⟩⟩

/-- **Under easing the stepwise reading withdraws exactly what the easing course undermines.** From
a course where activity needs support to one where activity follows support and that eases it, an
event the stepwise reading includes in the first stays included in the second exactly where the
second does not undermine there. -/
theorem stepwise_kept_iff {U : W → Web F C} {w w' : W} (dependent : (U w).Dependent)
    (gated : ActiveWhereSupported (U w')) (eases : Eases (U w) (U w')) {e : F × Nat}
    (included : stepwise U w e) : stepwise U w' e ↔ ¬ (U w').UnderminingAt e.2 e.1 :=
  ⟨fun kept => kept.2, fun keeps => ⟨active_of_eases dependent gated eases included.1, keeps⟩⟩

/-- **The stepwise law of easing.** Under the conditions of the whole-run law, the easing course
extends the other under the stepwise reading exactly when it undermines no event the other
includes and includes some event the other withholds. -/
theorem stepwise_extends_iff_of_eases {U : W → Web F C} {w w' : W} (dependent : (U w).Dependent)
    (gated : ActiveWhereSupported (U w')) (eases : Eases (U w) (U w')) :
    ExtendsUnder (stepwise U) w w' ↔
      (∀ e, stepwise U w e → ¬ (U w').UnderminingAt e.2 e.1) ∧
        ∃ e, stepwise U w' e ∧ ¬ stepwise U w e :=
  ⟨fun ⟨covers, e, _, included, withheld⟩ => ⟨fun e c => (covers e c).2, e, included, withheld⟩,
   fun ⟨keeps, e, included, withheld⟩ =>
    ⟨fun e c => (stepwise_kept_iff dependent gated eases c).2 (keeps e c), e, trivial, included,
      withheld⟩⟩

/-- A condition's level that falls at no step is at least as high at every later step. -/
theorem level_never_falls {V : Web F C} {c : C} (rises : ∀ t, V.level t c ≤ V.level (t + 1) c)
    (s : Nat) : ∀ k, V.level s c ≤ V.level (s + k) c
  | 0 => Nat.le_refl _
  | k + 1 => Nat.le_trans (level_never_falls rises s k) (rises (s + k))

/-- **A course in which no condition's level falls undermines nothing.** An undermining relation needs
a condition to fall, after a draw, below a need of a dependence it met while the dependence held,
and a level that never falls stays at or above every need it once met. -/
theorem not_undermining_of_rising {V : Web F C} (rises : ∀ t c, V.level t c ≤ V.level (t + 1) c)
    (t : Nat) (f : F) : ¬ V.UnderminingAt t f := fun ⟨c, _, _, _, ⟨s, before, _, met, above⟩, _⟩ =>
  Nat.lt_irrefl _ (Nat.lt_of_lt_of_le above (Nat.le_trans met
    (Nat.le_trans (level_never_falls (rises · c) s (t + 1 - s))
      (Nat.le_of_eq (congrArg (V.level · c) (Becoming.add_sub_of_le (Nat.le_succ_of_le before)))))))

/-- **Easing that lets nothing fall, under the stepwise reading.** Under the conditions of the
whole-run law, where no condition's level falls at any step of the easing course, it extends the other
under the stepwise reading exactly when it includes some event the other withholds, as under the
whole-run reading. -/
theorem stepwise_extends_iff_of_rising {U : W → Web F C} {w w' : W} (dependent : (U w).Dependent)
    (gated : ActiveWhereSupported (U w')) (eases : Eases (U w) (U w'))
    (rises : ∀ t c, (U w').level t c ≤ (U w').level (t + 1) c) :
    ExtendsUnder (stepwise U) w w' ↔ ∃ e, stepwise U w' e ∧ ¬ stepwise U w e :=
  ⟨fun ext => ((stepwise_extends_iff_of_eases dependent gated eases).1 ext).2,
   fun witness => (stepwise_extends_iff_of_eases dependent gated eases).2
     ⟨fun e _ => not_undermining_of_rising rises e.2 e.1, witness⟩⟩

/-! ## The relation-level reading -/

/-- **The relation-level reading** of a family of courses, each a web: a claim is a formation's
relation to a condition at a step, included when the formation is active and takes part in the
condition there and the relation does not undermine. It is the `living` of `Web.relations`
(`Ranking.relational_iff`, in `Becoming.Relevance`). -/
def relational (U : W → Web F C) (w : W) (e : F × C × Nat) : Prop :=
  (U w).active e.2.2 e.1 ∧ (U w).Participates e.2.2 e.1 e.2.1 ∧ ¬ (U w).UnderminingOn e.2.2 e.1 e.2.1

/-- **Under easing the relation-level reading withdraws exactly the relations the easing course no
longer takes part in or undermines.** From a course where activity needs support to one where activity
follows support and that eases it, a relation the reading includes in the first stays included in the
second exactly where the second still takes part in the condition and does not undermine there. -/
theorem relational_kept_iff {U : W → Web F C} {w w' : W} (dependent : (U w).Dependent)
    (gated : ActiveWhereSupported (U w')) (eases : Eases (U w) (U w')) {e : F × C × Nat}
    (included : relational U w e) :
    relational U w' e ↔ (U w').Participates e.2.2 e.1 e.2.1 ∧ ¬ (U w').UnderminingOn e.2.2 e.1 e.2.1 :=
  ⟨fun kept => kept.2,
   fun ⟨joins, keeps⟩ => ⟨active_of_eases dependent gated eases included.1, joins, keeps⟩⟩

/-- **The relation-level law of easing.** Under the conditions of the whole-run law, the easing
course extends the other under the relation-level reading exactly when it still takes part in, and
does not undermine, every relation the other includes, and includes one the other withholds. -/
theorem relational_extends_iff_of_eases {U : W → Web F C} {w w' : W} (dependent : (U w).Dependent)
    (gated : ActiveWhereSupported (U w')) (eases : Eases (U w) (U w')) :
    ExtendsUnder (relational U) w w' ↔
      (∀ e, relational U w e →
        (U w').Participates e.2.2 e.1 e.2.1 ∧ ¬ (U w').UnderminingOn e.2.2 e.1 e.2.1) ∧
      ∃ e, relational U w' e ∧ ¬ relational U w e :=
  ⟨fun ⟨covers, e, _, included, withheld⟩ => ⟨fun e c => (covers e c).2, e, included, withheld⟩,
   fun ⟨keeps, e, included, withheld⟩ =>
    ⟨fun e c => (relational_kept_iff dependent gated eases c).2 (keeps e c), e, trivial, included,
      withheld⟩⟩

/-- **Easing that lets nothing fall and keeps every relation, under the relation-level reading.** Under
the conditions of the whole-run law, where no condition's level falls at any step of the easing course
and the easing course takes part wherever the other does, it extends the other under the relation-level
reading exactly when it includes some relation the other withholds. -/
theorem relational_extends_iff_of_rising {U : W → Web F C} {w w' : W} (dependent : (U w).Dependent)
    (gated : ActiveWhereSupported (U w')) (eases : Eases (U w) (U w'))
    (rises : ∀ t c, (U w').level t c ≤ (U w').level (t + 1) c)
    (joins : ∀ t f c, (U w).Participates t f c → (U w').Participates t f c) :
    ExtendsUnder (relational U) w w' ↔ ∃ e, relational U w' e ∧ ¬ relational U w e :=
  ⟨fun ext => ((relational_extends_iff_of_eases dependent gated eases).1 ext).2,
   fun witness => (relational_extends_iff_of_eases dependent gated eases).2
     ⟨fun e c => ⟨joins _ _ _ c.2.1, fun undermining =>
       not_undermining_of_rising rises e.2.2 e.1 ⟨e.2.1, undermining⟩⟩, witness⟩⟩

/-! ## The course without the focal formation -/

/-- One law read as two courses: the focal formation occurs, or it does not. Here a course is
one of two alternative unfoldings of the law (`course`), indexed by this type; elsewhere in the
spine a course is a trace of moves (`Generative.Trace`) or a run's sequence of configurations
(`Parting.course`). -/
inductive Course where
  | occurs
  | absent

/-- The condition under the sustaining formation's renewal alone. -/
def undisturbed (L : Law) : Nat → Nat
  | 0 => L.start
  | t + 1 => if L.needG ≤ undisturbed L t then undisturbed L t + L.renew else undisturbed L t

/-- The law's course in which the focal formation does not occur and draws nothing, as a web. -/
def absent (L : Law) : Web Part Unit where
  level t _ := undisturbed L t
  active t p := match p with
    | .focal => False
    | .sustaining => L.needG ≤ undisturbed L t
  requires _ p _ := L.requiresPart p
  need _ p _ := L.need p
  draws _ _ _ := False

/-- The two courses of a law as webs: the law's unfolding read as a web with fixed dependences
(`Web.static`), or the course without the focal formation. -/
def course (L : Law) : Course → Web Part Unit
  | .occurs => Web.static L.unfolding
  | .absent => absent L

theorem undisturbed_sustains (L : Law) (gStart : L.needG ≤ L.start) :
    ∀ t, L.start ≤ undisturbed L t
  | 0 => Nat.le_refl _
  | t + 1 =>
    have before := undisturbed_sustains L gStart t
    Nat.le_trans (Nat.le_trans before (Nat.le_add_right _ _))
      (Nat.le_of_eq (if_pos (Nat.le_trans gStart before)).symm)

theorem absent_sustains (L : Law) (gStart : L.needG ≤ L.start) (t : Nat) :
    (course L .absent).active t .sustaining :=
  Nat.le_trans gStart (undisturbed_sustains L gStart t)

/-- The course without the focal formation renews every condition. -/
theorem absent_renews (L : Law) (fWithin : L.needF ≤ L.needG) (gStart : L.needG ≤ L.start) :
    ∀ c, (course L .absent).Renewed c :=
  fun _ t g _ => match g with
    | .focal => ⟨Nat.le_trans fWithin (absent_sustains L gStart t),
        Nat.le_trans fWithin (absent_sustains L gStart (t + 1))⟩
    | .sustaining => ⟨absent_sustains L gStart t, absent_sustains L gStart (t + 1)⟩

/-- The course without a formation extends the course with it only if the reading
withholds every event of that formation. -/
theorem withheld_of_extends {L : Law} {reading : Course → Part × Nat → Prop}
    (active : ∀ w e, reading w e → (course L w).active e.2 e.1)
    (extends_ : ExtendsUnder reading .occurs .absent) (t : Nat) : ¬ reading .occurs (.focal, t) :=
  fun included => active .absent (.focal, t) (extends_.1 _ included)

/-! ## The whole-run reading ranks the absence higher -/

/-- For every law of the family in which the focal formation draws beyond renewal from
some step on, the course without it extends the course with it under the whole-run
reading. -/
theorem whole_run_extends (L : Law) (positive : 0 < L.needG) (fWithin : L.needF ≤ L.needG)
    (gStart : L.needG ≤ L.start) {T0 : Nat}
    (over : ∀ t, T0 ≤ t → L.renew + L.contrib t < L.draw t) :
    ExtendsUnder (wholeRun (course L)) .occurs .absent :=
  match overdraw_consuming L positive fWithin over with
  | ⟨consuming, T, lost⟩ =>
    (renewed_extends_iff (U := course L) (w := .occurs) (w' := .absent)
      (absent_renews L fWithin gStart)).1.mpr
      ⟨fun
        | (.focal, _), ⟨_, notConsuming⟩ =>
          absurd ((Web.static_consumingIn _ _).mpr consuming) notConsuming
        | (.sustaining, t), _ => absent_sustains L gStart t,
       (.sustaining, T), absent_sustains L gStart T, fun alive => lost T (Nat.le_refl T) alive.1⟩

/-- Every comparison satisfying C under the whole-run reading ranks the course without
the overdrawing formation strictly higher. -/
theorem whole_run_ranks (L : Law) (positive : 0 < L.needG) (fWithin : L.needF ≤ L.needG)
    (gStart : L.needG ≤ L.start) {T0 : Nat}
    (over : ∀ t, T0 ≤ t → L.renew + L.contrib t < L.draw t)
    {Better : Course → Course → Prop} (ranks : ComparisonUnder (wholeRun (course L)) Better) :
    Better .occurs .absent :=
  ranks _ _ (whole_run_extends L positive fWithin gStart over)

/-! ## The stepwise reading leaves the two courses unranked -/

/-- An event of the focal formation whose step leaves every need met is included by the
stepwise reading. -/
theorem included_before_loss (L : Law) {t : Nat} (active : L.needF ≤ L.level t)
    (keepsG : L.needG ≤ L.level (t + 1)) (keepsF : L.needF ≤ L.level (t + 1)) :
    stepwise (course L) .occurs (.focal, t) :=
  ⟨active, fun ⟨_, _, g, _, _, fell⟩ =>
    match g, fell with
    | .focal, fell => Nat.not_le_of_gt fell keepsF
    | .sustaining, fell => Nat.not_le_of_gt fell keepsG⟩

/-- Under the stepwise reading neither course extends the other once the focal formation
has a included event: the course without it lacks that event, and the course with it
lacks the sustaining formation's events after the loss. -/
theorem stepwise_unranked (L : Law) (positive : 0 < L.needG) (fWithin : L.needF ≤ L.needG)
    (gStart : L.needG ≤ L.start) {T0 : Nat}
    (over : ∀ t, T0 ≤ t → L.renew + L.contrib t < L.draw t) {t : Nat}
    (included : stepwise (course L) .occurs (.focal, t)) :
    ¬ ExtendsUnder (stepwise (course L)) .occurs .absent ∧
      ¬ ExtendsUnder (stepwise (course L)) .absent .occurs :=
  match overdraw_consuming L positive fWithin over with
  | ⟨_, T, lost⟩ =>
    ⟨fun extends_ => withheld_of_extends (fun _ _ alive => alive.1) extends_ t included,
     fun extends_ => lost T (Nat.le_refl T)
      (extends_.1 (.sustaining, T) ⟨absent_sustains L gStart T, fun ⟨_, drawn, _⟩ => drawn⟩).1⟩

/-- **The relation-level reading too leaves absence and occurrence unranked.** Under the stepwise
reading's premises, once the focal formation has an event that reading includes, the relation-level
reading includes its relation to the condition at that step, which the course without it lacks, and
the course with it lacks the sustaining formation's relations after the loss. -/
theorem relational_unranked (L : Law) (positive : 0 < L.needG) (fWithin : L.needF ≤ L.needG)
    (gStart : L.needG ≤ L.start) {T0 : Nat}
    (over : ∀ t, T0 ≤ t → L.renew + L.contrib t < L.draw t) {t : Nat}
    (included : stepwise (course L) .occurs (.focal, t)) :
    ¬ ExtendsUnder (relational (course L)) .occurs .absent ∧
      ¬ ExtendsUnder (relational (course L)) .absent .occurs :=
  match overdraw_consuming L positive fWithin over with
  | ⟨_, T, lost⟩ =>
    ⟨fun extends_ => (extends_.1 (.focal, (), t)
       ⟨included.1, Or.inr ⟨T0, Nat.lt_of_le_of_lt (Nat.zero_le _) (over T0 (Nat.le_refl T0))⟩,
        fun undermining => included.2 ⟨(), undermining⟩⟩).1,
     fun extends_ => lost T (Nat.le_refl T)
      (extends_.1 (.sustaining, (), T) ⟨absent_sustains L gStart T, Or.inl trivial,
        fun ⟨drawn, _⟩ => drawn⟩).1⟩

/-- A comparison preferring the course in which the focal formation occurs, alongside
every extension under a reading. `preferOccurs reading w w'` says `w'` is better. -/
def preferOccurs (reading : Course → Part × Nat → Prop) (w w' : Course) : Prop :=
  ExtendsUnder reading w w' ∨ (w = .absent ∧ w' = .occurs)

theorem preferOccurs_only {reading : Course → Part × Nat → Prop}
    (unranked : ¬ ExtendsUnder reading .occurs .absent) {w w' : Course} :
    preferOccurs reading w w' → w = .absent ∧ w' = .occurs
  | .inr pair => pair
  | .inl ext =>
    match w, w', ext with
    | .occurs, .occurs, ⟨_, _, _, included, notIncluded⟩ => absurd included notIncluded
    | .occurs, .absent, ext => absurd ext unranked
    | .absent, .occurs, _ => ⟨rfl, rfl⟩
    | .absent, .absent, ⟨_, _, _, included, notIncluded⟩ => absurd included notIncluded

/-- When the course without the formation does not extend the course with it, C does not
decide between them: an irreflexive, transitive comparison satisfying C prefers the
course with the formation. -/
theorem admits_occurrence {reading : Course → Part × Nat → Prop}
    (unranked : ¬ ExtendsUnder reading .occurs .absent) :
    ComparisonUnder reading (preferOccurs reading) ∧ preferOccurs reading .absent .occurs ∧
      ¬ preferOccurs reading .occurs .absent ∧ (∀ w, ¬ preferOccurs reading w w) ∧
      ∀ w w' w'', preferOccurs reading w w' → preferOccurs reading w' w'' →
        preferOccurs reading w w'' :=
  ⟨fun _ _ ext => .inl ext, .inr ⟨rfl, rfl⟩,
   fun better => Course.noConfusion (preferOccurs_only unranked better).1,
   fun _ better =>
    match preferOccurs_only unranked better with
    | ⟨first, second⟩ => Course.noConfusion (first.symm.trans second),
   fun _ _ _ first second =>
    Course.noConfusion
      ((preferOccurs_only unranked first).2.symm.trans (preferOccurs_only unranked second).1)⟩

/-- For every law of the family in which the focal formation draws beyond renewal and
has an event leaving every need met, C under the stepwise reading admits a comparison
preferring the course with the formation, while every comparison satisfying C under the
whole-run reading prefers the course without it. -/
theorem readings_rank_differently (L : Law) (positive : 0 < L.needG)
    (fWithin : L.needF ≤ L.needG) (gStart : L.needG ≤ L.start) {T0 : Nat}
    (over : ∀ t, T0 ≤ t → L.renew + L.contrib t < L.draw t) {t : Nat}
    (active : L.needF ≤ L.level t) (keepsG : L.needG ≤ L.level (t + 1))
    (keepsF : L.needF ≤ L.level (t + 1)) :
    (∀ Better, ComparisonUnder (wholeRun (course L)) Better → Better .occurs .absent) ∧
      ¬ ExtendsUnder (stepwise (course L)) .occurs .absent ∧
      ¬ ExtendsUnder (stepwise (course L)) .absent .occurs ∧
      ComparisonUnder (stepwise (course L)) (preferOccurs (stepwise (course L))) ∧
      preferOccurs (stepwise (course L)) .absent .occurs :=
  have unranked := stepwise_unranked L positive fWithin gStart over
    (included_before_loss L active keepsG keepsF)
  have admits := admits_occurrence unranked.1
  ⟨fun _ ranks => whole_run_ranks L positive fWithin gStart over ranks,
   unranked.1, unranked.2, admits.1, admits.2.1⟩

/-- Malignant growth: from level four, a formation needing one unit draws three where
one is renewed, and the sustaining formation needs two. Its first step leaves every
need met. -/
theorem malignant_ranking :
    (∀ Better, ComparisonUnder (wholeRun (course malignant)) Better → Better .occurs .absent) ∧
      ¬ ExtendsUnder (stepwise (course malignant)) .occurs .absent ∧
      ¬ ExtendsUnder (stepwise (course malignant)) .absent .occurs ∧
      ComparisonUnder (stepwise (course malignant)) (preferOccurs (stepwise (course malignant))) ∧
      preferOccurs (stepwise (course malignant)) .absent .occurs :=
  readings_rank_differently malignant Nat.zero_lt_two (Nat.le_succ 1)
    (Nat.le_succ_of_le (Nat.le_succ 2)) (T0 := 0) (fun _ _ => Nat.lt_succ_of_le (Nat.le_succ 1))
    (t := 0) (Nat.le_succ_of_le (Nat.le_succ_of_le (Nat.le_succ 1))) (Nat.le_refl 2) (Nat.le_succ 1)

/-- Winning by consumption compared with its absence: a formation that does not depend
on the condition draws two units where one is renewed. -/
theorem winning_ranking :
    (∀ Better, ComparisonUnder (wholeRun (course winning)) Better → Better .occurs .absent) ∧
      ¬ ExtendsUnder (stepwise (course winning)) .occurs .absent ∧
      ¬ ExtendsUnder (stepwise (course winning)) .absent .occurs ∧
      ComparisonUnder (stepwise (course winning)) (preferOccurs (stepwise (course winning))) ∧
      preferOccurs (stepwise (course winning)) .absent .occurs :=
  readings_rank_differently winning Nat.zero_lt_one (Nat.zero_le 1)
    (Nat.le_succ_of_le (Nat.le_succ 1)) (T0 := 0) (fun _ _ => Nat.lt_succ_self 1)
    (t := 0) (Nat.zero_le 3) (Nat.le_succ 1) (Nat.zero_le 2)

/-! ## With no included event, the stepwise reading ranks the absence higher too -/

namespace Immediate

/-- Start at the sustaining need; the focal formation, needing nothing, draws three where
one is renewed. Its first step already crosses support. -/
def law : Law := ⟨1, 1, 1, 0, fun _ => 3, fun _ => 0⟩

theorem law_low : ∀ n, law.level (n + 1) = 0
  | 0 => rfl
  | n + 1 => by
    rw [level_succ, law_low n]
    rfl

theorem focal_withheld (t : Nat) : ¬ stepwise (course law) .occurs (.focal, t) :=
  have fell := Nat.lt_of_le_of_lt (Nat.le_of_eq (law_low t)) Nat.zero_lt_one
  fun ⟨_, notUndermining⟩ => notUndermining
    ⟨(), ⟨0, Nat.zero_lt_succ 2⟩, .sustaining, trivial,
      ⟨0, Nat.zero_le t, fun _ _ _ => trivial, Nat.le_refl 1, fell⟩, fell⟩

/-- The law meets every premise of `whole_run_extends` and `stepwise_unranked` except an
event of the focal formation leaving every need met. No focal event is included, the
course without the formation extends the course with it under the stepwise reading, and
every comparison satisfying C ranks the absence higher. -/
theorem stepwise_ranks_absence :
    0 < law.needG ∧ law.needF ≤ law.needG ∧ law.needG ≤ law.start ∧
    (∀ t, law.renew + law.contrib t < law.draw t) ∧
    (∀ t, ¬ stepwise (course law) .occurs (.focal, t)) ∧
    ExtendsUnder (stepwise (course law)) .occurs .absent ∧
    ∀ Better, ComparisonUnder (stepwise (course law)) Better → Better .occurs .absent :=
  have sustains : ∀ t, stepwise (course law) .absent (.sustaining, t) :=
    fun t => ⟨absent_sustains law (Nat.le_refl 1) t, fun ⟨_, drawn, _⟩ => drawn⟩
  have ext : ExtendsUnder (stepwise (course law)) .occurs .absent :=
    ⟨fun e included => match e, included with
      | (.focal, t), included => absurd included (focal_withheld t)
      | (.sustaining, t), _ => sustains t,
     (.sustaining, 1), trivial, sustains 1, fun ⟨active, _⟩ =>
       Nat.not_succ_le_zero 0 (Nat.le_trans active (Nat.le_of_eq (law_low 0)))⟩
  ⟨Nat.zero_lt_one, Nat.zero_le 1, Nat.le_refl 1, fun _ => Nat.lt_succ_of_le (Nat.le_succ 1),
   focal_withheld, ext, fun _ ranks => ranks _ _ ext⟩

end Immediate

/-! ## The stepwise reading still ranks sharing above winning -/

inductive Contest where
  | shares
  | wins

def contest : Contest → Web Part Unit
  | .shares => Web.static sharing.unfolding
  | .wins => Web.static winning.unfolding

/-- Sharing includes every event under the stepwise reading: the condition never falls
below its start. -/
theorem sharing_included (e : Part × Nat) : stepwise contest .shares e :=
  have kept := within_renewal_sustains sharing (fun _ => Nat.le_refl 1)
    (Nat.le_succ_of_le (Nat.le_succ 1)) (Nat.zero_le 3)
  have supports : ∀ t, sharing.needG ≤ sharing.level t := fun t =>
    Nat.le_trans (Nat.le_succ_of_le (Nat.le_succ 1)) (kept t)
  ⟨match e with
    | (.focal, t) => Nat.zero_le (sharing.level t)
    | (.sustaining, t) => supports t,
   fun ⟨_, _, g, _, _, fell⟩ =>
    match g, fell with
    | .focal, fell => Nat.not_lt_zero _ fell
    | .sustaining, fell => Nat.not_le_of_gt fell (supports _)⟩

/-- Under the stepwise reading the winner's events before the loss are included, and
sharing still extends winning by consumption: it includes every event, and the
sustaining formation continues only there. -/
theorem stepwise_contest :
    stepwise contest .wins (.focal, 0) ∧ stepwise contest .wins (.focal, 1) ∧
      ¬ stepwise contest .wins (.focal, 2) ∧ ExtendsUnder (stepwise contest) .wins .shares :=
  match overdraw_consuming winning Nat.zero_lt_one (Nat.zero_le 1) (T0 := 0)
      (fun _ _ => Nat.lt_succ_self 1) with
  | ⟨_, T, lost⟩ =>
    ⟨included_before_loss winning (t := 0) (Nat.zero_le 3) (Nat.le_succ 1) (Nat.zero_le 2),
     included_before_loss winning (t := 1) (Nat.zero_le 2) (Nat.le_refl 1) (Nat.zero_le 1),
     fun alive => alive.2 ⟨(), ⟨1, Nat.zero_lt_two⟩, .sustaining, trivial,
       ⟨0, Nat.zero_le 2, fun _ _ _ => trivial, Nat.le_succ_of_le (Nat.le_succ 1), Nat.le_refl _⟩,
       Nat.zero_lt_one⟩,
     (renewed_active_extends_iff (U := contest) (w := .wins) (w' := .shares)
        (fun _ t g depends => match g, depends with
          | .focal, depends => absurd depends (Nat.lt_irrefl 0)
          | .sustaining, _ => ⟨(sharing_included (.sustaining, t)).1,
              (sharing_included (.sustaining, t + 1)).1⟩)
        fun t p => (sharing_included (p, t)).1).2.mpr
      ⟨(.sustaining, T), fun alive => lost T (Nat.le_refl T) alive.1⟩⟩

/-! ## Restraint ranks above overdraw under either reading, in the two-part family -/

/-- Two courses of a formation: it stops drawing beyond renewal while every need is
still met, or it keeps overdrawing. -/
inductive Restraint where
  | stops
  | overdraws

def restraint (stopping overdrawing : Law) : Restraint → Web Part Unit
  | .stops => Web.static stopping.unfolding
  | .overdraws => Web.static overdrawing.unfolding

variable {stopping overdrawing : Law}

/-- A course in which every need stays met is included at every event by both
readings. -/
theorem stops_included (met : ∀ t, stopping.needG ≤ stopping.level t ∧
      stopping.needF ≤ stopping.level t) (e : Part × Nat) :
    wholeRun (restraint stopping overdrawing) .stops e ∧
      stepwise (restraint stopping overdrawing) .stops e :=
  have active : (restraint stopping overdrawing .stops).active e.2 e.1 :=
    match e with
    | (.focal, t) => (met t).2
    | (.sustaining, t) => (met t).1
  ⟨⟨active, fun ⟨_, _, _, g, T, _, below⟩ =>
      match g, below (T + 1) (Nat.lt_succ_self T) with
      | .focal, fell => Nat.not_le_of_gt fell (met (T + 1)).2
      | .sustaining, fell => Nat.not_le_of_gt fell (met (T + 1)).1⟩,
   ⟨active, fun ⟨_, _, g, _, _, fell⟩ =>
      match g, fell with
      | .focal, fell => Nat.not_le_of_gt fell (met _).2
      | .sustaining, fell => Nat.not_le_of_gt fell (met _).1⟩⟩

/-- Under either reading, a course in which every need stays met extends a course of the
family in which overdraw ends the sustaining formation's support, so every comparison
satisfying C ranks restraint higher. Under the stepwise reading this holds although the
overdrawing formation's events before the loss are included. -/
theorem restraint_ranks (met : ∀ t, stopping.needG ≤ stopping.level t ∧
      stopping.needF ≤ stopping.level t)
    (positive : 0 < overdrawing.needG) (fWithin : overdrawing.needF ≤ overdrawing.needG)
    {T0 : Nat}
    (over : ∀ t, T0 ≤ t → overdrawing.renew + overdrawing.contrib t < overdrawing.draw t) :
    ExtendsUnder (wholeRun (restraint stopping overdrawing)) .overdraws .stops ∧
      ExtendsUnder (stepwise (restraint stopping overdrawing)) .overdraws .stops ∧
      (∀ Better, ComparisonUnder (wholeRun (restraint stopping overdrawing)) Better →
        Better .overdraws .stops) ∧
      ∀ Better, ComparisonUnder (stepwise (restraint stopping overdrawing)) Better →
        Better .overdraws .stops :=
  match overdraw_consuming overdrawing positive fWithin over with
  | ⟨_, T, lost⟩ =>
    have laws := renewed_active_extends_iff (U := restraint stopping overdrawing)
      (w := .overdraws) (w' := .stops)
      (fun _ t g _ => match g with
        | .focal => ⟨(met t).2, (met (t + 1)).2⟩
        | .sustaining => ⟨(met t).1, (met (t + 1)).1⟩)
      fun t p => match p with
        | .focal => (met t).2
        | .sustaining => (met t).1
    have whole := laws.1.mpr ⟨(.sustaining, T), fun alive => lost T (Nat.le_refl T) alive.1⟩
    have step := laws.2.mpr ⟨(.sustaining, T), fun alive => lost T (Nat.le_refl T) alive.1⟩
    ⟨whole, step, fun _ ranks => ranks _ _ whole, fun _ ranks => ranks _ _ step⟩

/-- The malignant formation's first step, three units where one is renewed, and then
drawing within renewal: the level stays at the sustaining formation's need. -/
def stoppingMalignant : Law := ⟨4, 1, 2, 1, fun | 0 => 3 | _ + 1 => 1, fun _ => 0⟩

theorem stoppingMalignant_level : ∀ t, stoppingMalignant.level (t + 1) = 2
  | 0 => rfl
  | t + 1 => by
    rw [level_succ, stoppingMalignant_level t]
    rfl

/-- Malignant growth compared with the same formation stopping after its first step,
before the threshold. The first event is the same in both courses and included by the
stepwise reading in both, and under either reading every comparison satisfying C ranks
stopping above malignant growth. Under the stepwise reading, then, what C loses here is
the comparison with the formation's absence, not with its restraint; with a third
formation sharing the condition the restraint comparison can be lost too
(`ThirdParty`). -/
theorem malignant_restraint :
    stoppingMalignant.draw 0 = malignant.draw 0 ∧
    stepwise (restraint stoppingMalignant malignant) .stops (.focal, 0) ∧
    stepwise (restraint stoppingMalignant malignant) .overdraws (.focal, 0) ∧
    (∀ Better, ComparisonUnder (wholeRun (restraint stoppingMalignant malignant)) Better →
      Better .overdraws .stops) ∧
    ∀ Better, ComparisonUnder (stepwise (restraint stoppingMalignant malignant)) Better →
      Better .overdraws .stops :=
  have met : ∀ t, stoppingMalignant.needG ≤ stoppingMalignant.level t ∧
      stoppingMalignant.needF ≤ stoppingMalignant.level t
    | 0 => ⟨Nat.le_succ_of_le (Nat.le_succ 2),
        Nat.le_succ_of_le (Nat.le_succ_of_le (Nat.le_succ 1))⟩
    | t + 1 => ⟨Nat.le_of_eq (stoppingMalignant_level t).symm,
        Nat.le_trans (Nat.le_succ 1) (Nat.le_of_eq (stoppingMalignant_level t).symm)⟩
  have ranks := restraint_ranks (overdrawing := malignant) met Nat.zero_lt_two (Nat.le_succ 1)
    (T0 := 0) fun _ _ => Nat.lt_succ_of_le (Nat.le_succ 1)
  ⟨rfl, (stops_included met _).2,
   included_before_loss malignant (t := 0)
     (Nat.le_succ_of_le (Nat.le_succ_of_le (Nat.le_succ 1))) (Nat.le_refl 2) (Nat.le_succ 1),
   ranks.2.2.1, ranks.2.2.2⟩

/-! ## With a third formation, restraint need not extend overdraw stepwise -/

namespace ThirdParty

inductive Part where
  | focal
  | sustaining
  | third

/-- Restraint: the first step is the same overdraw (6 to 5); then the focal formation
takes nothing for two steps (5, 6, 7); at step 3 a third formation, supported only at 7,
takes two (7 to 6); afterwards the focal formation takes the renewal (6). -/
def stopsLevel : Nat → Nat := Witnesses.profile [6, 5, 6, 7] 6

/-- Overdraw: the focal formation takes two where one is renewed, down to 0. -/
def overLevel : Nat → Nat := Witnesses.profile [6, 5, 4, 3, 2, 1] 0

/-- The focal formation needs nothing and always draws; the sustaining formation needs
one; the third formation needs seven and draws while active. Its dependences do not change with
the step, and `draws` carries no amount. -/
def web (level : Nat → Nat) : Web Part Unit where
  level t _ := level t
  active t p := match p with
    | .focal => True
    | .sustaining => 1 ≤ level t
    | .third => 7 ≤ level t
  requires _ p _ := match p with
    | .focal => False
    | .sustaining => True
    | .third => True
  need _ p _ := match p with
    | .focal => 0
    | .sustaining => 1
    | .third => 7
  draws _ p _ := match p with
    | .focal => True
    | .sustaining => False
    | .third => True

def courses : Restraint → Web Part Unit
  | .stops => web stopsLevel
  | .overdraws => web overLevel

theorem dependent (level : Nat → Nat) : (web level).Dependent :=
  fun _ p active _ depends => match p, active, depends with
  | .sustaining, active, _ => active
  | .third, active, _ => active

theorem over_below_seven : ∀ t, overLevel t < 7
  | 0 => by decide
  | 1 => by decide
  | 2 => by decide
  | 3 => by decide
  | 4 => by decide
  | 5 => by decide
  | _ + 6 => Nat.zero_lt_succ 6

theorem stops_supports : ∀ t, 1 ≤ stopsLevel t
  | 0 => by decide
  | 1 => by decide
  | 2 => by decide
  | 3 => by decide
  | _ + 4 => (by decide : 1 ≤ 6)

/-- The focal formation's event at step 3 is included stepwise when it overdraws (the
sustaining need stays met and the third formation was never met), and withheld when it
has stopped (the third formation, met at step 3, is unmet after it). -/
theorem focal_three :
    stepwise courses .overdraws (.focal, 3) ∧ ¬ stepwise courses .stops (.focal, 3) :=
  ⟨⟨trivial, fun ⟨_, _, g, depends, ⟨s, _, _, met, _⟩, fell⟩ => match g, depends with
    | .sustaining, _ => Nat.not_le_of_gt fell (Nat.le_succ 1)
    | .third, _ => Nat.not_le_of_gt (over_below_seven s) met⟩,
   fun ⟨_, notUndermining⟩ => notUndermining
    ⟨(), trivial, .third, trivial,
      ⟨3, Nat.le_refl 3, fun _ _ _ => trivial, Nat.le_refl 7, Nat.le_refl _⟩,
      Nat.lt_succ_self 6⟩⟩

/-- Both courses are dependent. Under the stepwise reading neither course extends the
other, so extension itself is a comparison satisfying C that does not rank restraint
above overdraw. Under the whole-run reading restraint extends overdraw. -/
theorem restraint_unranked_stepwise :
    (courses .stops).Dependent ∧ (courses .overdraws).Dependent ∧
    ¬ ExtendsUnder (stepwise courses) .overdraws .stops ∧
    ¬ ExtendsUnder (stepwise courses) .stops .overdraws ∧
    ComparisonUnder (stepwise courses) (ExtendsUnder (stepwise courses)) ∧
    ExtendsUnder (wholeRun courses) .overdraws .stops :=
  have overConsumed : (courses .overdraws).Consumed () :=
    ⟨.sustaining, 6, trivial, fun t later => match t, later with
      | _ + 7, _ => Nat.zero_lt_one⟩
  have sustains : ∀ t, wholeRun courses .stops (.sustaining, t) :=
    fun t => ⟨stops_supports t, fun ⟨_, _, drawn, _⟩ => drawn⟩
  ⟨dependent stopsLevel, dependent overLevel,
   fun ⟨sub, _⟩ => focal_three.2 (sub _ focal_three.1),
   fun ⟨sub, _⟩ => Nat.not_succ_le_zero 0
     (sub (.sustaining, 6) ⟨stops_supports 6, fun ⟨_, drawn, _⟩ => drawn⟩).1,
   fun _ _ ext => ext,
   ⟨fun e included => match e, included with
     | (.focal, _), ⟨_, notConsuming⟩ => absurd ⟨0, (), trivial, overConsumed⟩ notConsuming
     | (.sustaining, t), _ => sustains t
     | (.third, _), ⟨active, _⟩ => absurd active (Nat.not_le_of_gt (over_below_seven _)),
    (.sustaining, 6), trivial, sustains 6, fun ⟨active, _⟩ => Nat.not_succ_le_zero 0 active⟩⟩

/-- Stepwise, the renewal in `renewed_extends_iff` cannot be dropped: the restrained course
is active at every event the overdrawing course includes and at an event it withholds, yet
does not extend it, since it does not renew the third formation's condition. -/
theorem renewal_needed :
    ¬ (courses .stops).Renewed () ∧
    (∀ e, stepwise courses .overdraws e → (courses .stops).active e.2 e.1) ∧
    (∃ e, (courses .stops).active e.2 e.1 ∧ ¬ stepwise courses .overdraws e) ∧
    ¬ ExtendsUnder (stepwise courses) .overdraws .stops :=
  ⟨fun renewed => absurd (renewed 0 .third trivial).1 (by decide),
   fun e included => match e, included with
    | (.focal, _), _ => trivial
    | (.sustaining, t), _ => stops_supports t
    | (.third, t), ⟨active, _⟩ => absurd active (Nat.not_le_of_gt (over_below_seven t)),
   ⟨(.sustaining, 6), stops_supports 6, fun ⟨active, _⟩ => Nat.not_succ_le_zero 0 active⟩,
   restraint_unranked_stepwise.2.2.1⟩

/-- The overdrawing course never holds the condition higher than the restrained one. -/
theorem over_le_stops : ∀ t, overLevel t ≤ stopsLevel t
  | 0 => by decide
  | 1 => by decide
  | 2 => by decide
  | 3 => by decide
  | 4 => by decide
  | 5 => by decide
  | _ + 6 => Nat.zero_le _

/-- Easing alone gives the stepwise reading no law: the restrained course eases the overdrawing
one, activity needs support in both and follows support in the restrained one, yet the
stepwise reading includes the focal event at step 3 only in the overdrawing course, which the
restrained course undermines there (`undermines_included`), the premise
`stepwise_extends_iff_of_eases` adds. The whole-run reading ranks restraint higher, as
`wholeRun_extends_iff_of_eases` gives. -/
theorem stepwise_not_monotone :
    (courses .overdraws).Dependent ∧ ActiveWhereSupported (courses .stops) ∧
    Eases (courses .overdraws) (courses .stops) ∧
    stepwise courses .overdraws (.focal, 3) ∧ ¬ stepwise courses .stops (.focal, 3) ∧
    ExtendsUnder (wholeRun courses) .overdraws .stops :=
  have gated : ActiveWhereSupported (courses .stops) := fun _ p supported => match p with
    | .focal => trivial
    | .sustaining => supported () trivial
    | .third => supported () trivial
  have eases : Eases (courses .overdraws) (courses .stops) :=
    ⟨fun _ _ _ depends => depends, fun _ _ _ => Nat.le_refl _, fun t _ => over_le_stops t,
     fun _ _ _ drawn => drawn⟩
  ⟨dependent overLevel, gated, eases, focal_three.1, focal_three.2,
   (wholeRun_extends_iff_of_eases (U := courses) (w := .overdraws) (w' := .stops)
     (dependent overLevel) gated eases).mpr
     ⟨(.sustaining, 6), ⟨stops_supports 6, fun ⟨_, _, drawn, _⟩ => drawn⟩,
      fun ⟨active, _⟩ => Nat.not_succ_le_zero 0 active⟩⟩

/-- **Where the stepwise law's premise fails.** The restrained course undermines at step 3 the
focal event the overdrawing course includes: the third formation, met at seven only in the
restrained course, falls below its need after the focal draw. -/
theorem undermines_included :
    stepwise courses .overdraws (.focal, 3) ∧ (courses .stops).UnderminingAt 3 .focal ∧
    ¬ ExtendsUnder (stepwise courses) .overdraws .stops :=
  ⟨focal_three.1,
   ⟨(), trivial, .third, trivial, ⟨3, Nat.le_refl 3, fun _ _ _ => trivial, Nat.le_refl 7, Nat.le_refl _⟩,
    Nat.lt_succ_self 6⟩,
   fun ext => ((stepwise_extends_iff_of_eases (U := courses) (w := .overdraws) (w' := .stops)
     stepwise_not_monotone.1 stepwise_not_monotone.2.1 stepwise_not_monotone.2.2.1).1 ext).1
       (.focal, 3) focal_three.1
       ⟨(), trivial, .third, trivial, ⟨3, Nat.le_refl 3, fun _ _ _ => trivial, Nat.le_refl 7, Nat.le_refl _⟩,
        Nat.lt_succ_self 6⟩⟩

end ThirdParty

end Ranking

end Becoming
