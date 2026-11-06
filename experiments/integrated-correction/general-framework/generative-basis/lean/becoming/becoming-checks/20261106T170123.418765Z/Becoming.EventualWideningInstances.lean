import Becoming.EventualWidening
import Becoming.Verification
import Becoming.Weightings

/-!
# Eventual widening: its instances and witnesses, and what carries a widening

The instances of `Becoming.EventualWidening` in chapter 03's frame and against the weighting
characterization of C; the property of what carries a widening, *opened by the opened*; and the
witnesses that mark what eventual widening, keeping widening and being opened by the opened do and
do not say. No ethical predicate, ranking or axiom occurs.

* **In chapter 03's frame.** Read the level paths as the runs of the process of all sequences of
  levels (`Sequences.process`). Where some level path eventually widens `l'`, eventually widening
  `l'` and its complement are both dense: every finite stretch is a stretch of a path that does,
  and of one that does not (`Web.eventually_dense`, `Web.not_eventually_dense`, by
  `Web.EventuallyWidens.of_agree_left`). So the reading is neither verifiable nor refutable
  (`Web.eventually_neither`), and a practice fixed by the record can keep the verdict "eventually
  widens `l'`" against every record (`Web.eventually_insulated`, by `insulates_iff_dense`). The
  frame varies the first course only; the second is fixed and known in full.
* **Where the weighting characterization is silent.** A level path whose admissions a list holds
  (`Web.ListsAdmitted`, the hypothesis of `Web.widens_iff_every_weighting`) eventually widens
  nothing (`Web.not_eventually_of_listed`).
* **The disagreement** (`OwnCondition`: each formation requires only its own condition, at need
  one). `rising` admits at step `t` the formations up to `t`; `burst` admits formations `0` and `1`
  at step `0` and nothing after. Up to step `0` the burst widens the rising course
  (`OwnCondition.burst_widens_now`), a first stretch that ends before the rising course first admits
  something the burst does not; over every step the two are mixed (`OwnCondition.mixed`). The rising
  course eventually widens the burst (`OwnCondition.rising_eventually_widens_burst`), keeps widening
  by name (`OwnCondition.rising_keeps_widening`), and the burst keeps widening from no step
  (`OwnCondition.burst_not_keeps_widening`; together `OwnCondition.disagreement`).
* **Saturation.** `full` admits everything throughout. It widens the rising course
  (`OwnCondition.full_widens_rising`), also eventually (`OwnCondition.full_eventually_widens_rising`),
  and keeps widening from no step (`OwnCondition.not_monotone`). No order ranking every course that
  keeps widening above every course that does not agrees with widening.
* **A lag** (`LagWitness`). `travelling` admits only formation `t` at step `t`; `lagging` admits the
  formations below `t`. The lagging course keeps widening by name
  (`LagWitness.lagging_keeps_widening`) and admits, at every step after it, every formation the
  travelling course admits (`LagWitness.kept_later`). Yet neither eventually widens the other
  (`LagWitness.not_eventually_lagging`, `LagWitness.not_eventually_travelling`): one-step
  novelties against a course keeping each of them forever are mixed in every tail. A course whose
  range keeps widening is not thereby compared with one merely wider now.
* **A merge** (`MergedWitness`). Over the two formations of `Bool`, along the continuation in which
  every formation continues as `false`, a course admitting the same at every step keeps widening
  (`MergedWitness.keeps_widening_along_merge`), and by name it does not
  (`MergedWitness.not_keeps_widening_by_name`).
* **What carries a widening.** A flow's range is *opened by the opened* from `T` where gains of
  support recur and every gain after `T` is given, on a condition the gainer requires before the
  step and that rises across it, by a supported formation taking part that itself gained support
  after `T`, earlier (`Flow.OpenedByOpened`). The definition is provisional: its proposed first law,
  the uniform form of `Flow.support_passes_on`, would reach the giver only up to double negation,
  and that law fixes the form. A web on which nothing is supported from some step on is opened by
  the opened from no step (`Flow.OpenedByOpened.not_of_unsupported`): the end of degeneration does
  not qualify.
* **One range, two carriers** (`OpeningChain`). On one web whose levels are the rising course
  (`OpeningChain.level_rising`), two flows balance with only active formations giving and activity
  needing support. In the relay each formation gives the next its unit (`OpeningChain.relay`);
  in the other one formation gives every unit (`OpeningChain.oneGiver`). The relay is opened by the
  opened (`OpeningChain.relay_opened`) and the single giver is not
  (`OpeningChain.oneGiver_not_opened`), while the levels, and so every admission, are the same
  (`OpeningChain.carried`). Neither flow meets the first law: each unit is given from nothing.
* **Opened by the opened without widening** (`ClosedCycle`). Two formations pass one unit around:
  the active one takes it from its own condition and gives it to the other's
  (`ClosedCycle.balances`). Gains of support recur at every step and each is given by the member that
  gained the step before (`ClosedCycle.opened`), while along the continuation in which each
  formation continues as the other nothing is lost and nothing is opened
  (`ClosedCycle.includes_across`, `ClosedCycle.not_opening`), and by name the range does not keep
  widening (`ClosedCycle.not_keeps_widening_by_name`). Opened by the opened neither is nor gives
  widening. On `OwnCondition.web`, where nothing is ever supported, no flow is opened by the opened
  (`OwnCondition.not_opened`): the recurrence clause excludes the vacuous case.
* **Ranking by opened by the opened reverses widening** (`Saturated`). The relay is opened by the
  opened and its levels are the rising course; a flow that gives nothing, on a web where every
  condition stands at one throughout, is opened by the opened from no step, since no gain recurs,
  and its levels are the saturated course, which widens the rising one on the same requirements
  (`Saturated.reverses`). So ranking by opened by the opened runs against widening wholesale.

**Standing.** Near-definitional: the frame laws are the density of a tail reading (03 §5), the listing
law is the definition read against a list, and the witnesses are constructions.

**What is not derived.** Any comparison over branching courses, any gain or giver law, and which
actual courses meet any of these readings. Every declaration has an empty axiom report (scratch
build).
-/

namespace Becoming

open Generative

namespace Web

variable {F C : Type} {W : Web F C} {l l' m : Nat → C → Nat}

/-! ## In chapter 03's frame -/

/-- The level path that follows `l` before step `h` and `m` from it. -/
def splice (h : Nat) (l m : Nat → C → Nat) : Nat → C → Nat :=
  fun t => if t < h then l t else m t

theorem splice_before {h t : Nat} {l m : Nat → C → Nat} (before : t < h) :
    splice h l m t = l t :=
  if_pos before

theorem splice_from {h t : Nat} {l m : Nat → C → Nat} (from_ : h ≤ t) :
    splice h l m t = m t :=
  if_neg (Nat.not_lt_of_le from_)

/-- **Eventually widening `l'` is dense** where some level path does: every finite stretch is a
stretch of a level path that eventually widens `l'`. -/
theorem eventually_dense (widens : W.EventuallyWidens m l') :
    Dense (fun r : Run (Sequences.process (C → Nat)) => W.EventuallyWidens r.act l') :=
  fun r h => ⟨Sequences.run (splice h r.act m),
    EventuallyWidens.of_agree_left (T := h) (fun _ from_ => (splice_from from_).symm) widens,
    Sequences.agree_iff.mpr fun _ before => (splice_before before).symm⟩

/-- **Not eventually widening `l'` is dense.** -/
theorem not_eventually_dense :
    Dense (fun r : Run (Sequences.process (C → Nat)) => ¬ W.EventuallyWidens r.act l') :=
  fun r h => ⟨Sequences.run (splice h r.act l'),
    fun widens => EventuallyWidens.irrefl
      (EventuallyWidens.of_agree_left (T := h) (fun _ from_ => splice_from from_) widens),
    Sequences.agree_iff.mpr fun _ before => (splice_before before).symm⟩

/-- **Neither verifiable nor refutable**, where some level path eventually widens `l'`. -/
theorem eventually_neither (widens : W.EventuallyWidens m l') :
    ¬ Verifiable (fun r : Run (Sequences.process (C → Nat)) => W.EventuallyWidens r.act l') ∧
    ¬ Refutable (fun r : Run (Sequences.process (C → Nat)) => W.EventuallyWidens r.act l') :=
  ⟨not_verifiable_of_adheres (r := Sequences.run m) (not_eventually_dense _) widens,
   not_refutable_of_adheres (r := Sequences.run l') (eventually_dense widens _)
     EventuallyWidens.irrefl⟩

/-- **The verdict can be insulated**: a practice fixed by the record keeps "eventually widens `l'`"
against every record, where some level path eventually widens `l'`. -/
theorem eventually_insulated (widens : W.EventuallyWidens m l') :
    ∃ V : Practice (Sequences.process (C → Nat)), ByRecord V ∧
      Insulates V (fun r => W.EventuallyWidens r.act l') :=
  insulates_iff_dense.mpr (eventually_dense widens)

/-! ## Where the weighting characterization is silent -/

/-- A step beyond every listed step. -/
def stepBound : List (Nat × F) → Nat
  | [] => 0
  | p :: ps => p.1 + 1 + stepBound ps

theorem lt_stepBound : ∀ {ps : List (Nat × F)} {p : Nat × F}, p ∈ ps → p.1 < stepBound ps
  | _ :: _, _, .head _ => Nat.lt_of_lt_of_le (Nat.lt_succ_self _) (Nat.le_add_right _ _)
  | _ :: _, _, .tail _ mem => Nat.lt_of_lt_of_le (lt_stepBound mem) (Nat.le_add_left _ _)

/-- **A level path whose admissions are listed eventually widens nothing.** -/
theorem not_eventually_of_listed {items : List (Nat × F)} (listed : W.ListsAdmitted items l) :
    ¬ W.EventuallyWidens l l' :=
  fun widens => match (eventuallyWidens_iff.mp widens).2 (stepBound items) with
    | ⟨t, f, from_, admitted, _⟩ =>
      Nat.lt_irrefl t (Nat.lt_of_lt_of_le (lt_stepBound (listed t f admitted)) from_)

end Web

/-! ## What carries a widening -/

namespace Flow

variable {F C : Type}

/-- **Opened by the opened**: gains of support recur, and every gain after step `T` is given, on a
condition the gainer requires before the step and that rises across it, by a supported formation
taking part that itself gained support after `T`, earlier. Provisional: its first law, the uniform
form of `Flow.support_passes_on`, would reach the giver only up to double negation, and that law
fixes the form. -/
def OpenedByOpened (L : Flow F C) (W : Web F C) (T : Nat) : Prop :=
  (∀ N, ∃ t f, N ≤ t ∧ W.GainsSupport t f) ∧
    ∀ t f, T < t → W.GainsSupport t f → ∃ c g u, W.requires t f c ∧ W.Rises t c ∧
      g ∈ L.present t ∧ 0 < L.give t g c ∧ W.Supported t g ∧ T ≤ u ∧ u < t ∧ W.GainsSupport u g

/-- **The end of degeneration is not opened by the opened**: where nothing is supported from some
step on, no gain recurs. -/
theorem OpenedByOpened.not_of_unsupported {L : Flow F C} {W : Web F C} {T : Nat}
    (none_ : ∀ t f, T ≤ t → ¬ W.Supported t f) (T' : Nat) : ¬ L.OpenedByOpened W T' :=
  fun ⟨recur, _⟩ => match recur T with
    | ⟨t, f, from_, gains⟩ => none_ (t + 1) f (Nat.le_succ_of_le from_) gains.2

end Flow

/-! ## The disagreement and saturation -/

namespace OwnCondition

/-- One where `c` is at most `t`, nothing otherwise. -/
def rung : Nat → Nat → Nat
  | 0, _ => 1
  | _ + 1, 0 => 0
  | c + 1, t + 1 => rung c t

theorem rung_pos : ∀ {c t : Nat}, c ≤ t → 0 < rung c t
  | 0, _, _ => Nat.zero_lt_one
  | _ + 1, 0, le => absurd le (Nat.not_succ_le_zero _)
  | c + 1, t + 1, le => (rung_pos (c := c) (t := t) (Nat.le_of_succ_le_succ le) : 0 < rung c t)

theorem le_of_rung_pos : ∀ {c t : Nat}, 0 < rung c t → c ≤ t
  | 0, _, _ => Nat.zero_le _
  | _ + 1, 0, pos => absurd pos (Nat.lt_irrefl 0)
  | c + 1, t + 1, pos => Nat.succ_le_succ (le_of_rung_pos (c := c) (t := t) pos)

theorem rung_mono : ∀ c t, rung c t ≤ rung c (t + 1)
  | 0, _ => Nat.le_refl 1
  | _ + 1, 0 => Nat.zero_le _
  | c + 1, t + 1 => (rung_mono c t : rung c t ≤ rung c (t + 1))

theorem rung_zero : ∀ {c t : Nat}, t < c → rung c t = 0
  | 0, _, lt => absurd lt (Nat.not_lt_zero _)
  | _ + 1, 0, _ => rfl
  | c + 1, t + 1, lt => (rung_zero (c := c) (t := t) (Nat.lt_of_succ_lt_succ lt) : rung c t = 0)

/-- Each formation `n` requires only its own condition `n`, at need one. -/
def web : Web Nat Nat :=
  ⟨fun _ _ => 0, fun _ _ => True, fun _ n c => c = n, fun _ _ _ => 1, fun _ _ _ => False⟩

theorem admits_iff {m : Nat → Nat} {t n : Nat} : web.Admits m t n ↔ 0 < m n :=
  ⟨fun admitted => admitted n rfl,
   fun pos _ same => Eq.subst (motive := fun x => 0 < m x) same.symm pos⟩

/-- At step `t` the conditions up to `t` stand at one: one formation more a step. -/
def rising : Nat → Nat → Nat := fun t c => rung c t

/-- At step `0` conditions `0` and `1` stand at one, and nothing after. -/
def burst : Nat → Nat → Nat
  | 0, c => rung c 1
  | _ + 1, _ => 0

/-- Every condition stands at one at every step. -/
def full : Nat → Nat → Nat := fun _ _ => 1

theorem rising_iff {t n : Nat} : web.Admits (rising t) t n ↔ n ≤ t :=
  ⟨fun admitted => le_of_rung_pos ((admits_iff (m := rising t)).mp admitted),
   fun le => (admits_iff (m := rising t)).mpr (rung_pos le)⟩

theorem burst_zero_iff {n : Nat} : web.Admits (burst 0) 0 n ↔ n ≤ 1 :=
  ⟨fun admitted => le_of_rung_pos ((admits_iff (m := burst 0)).mp admitted),
   fun le => (admits_iff (m := burst 0)).mpr (rung_pos le)⟩

theorem burst_later {t n : Nat} : ¬ web.Admits (burst (t + 1)) (t + 1) n :=
  fun admitted => Nat.lt_irrefl 0 (admits_iff.mp admitted)

theorem full_admits {t n : Nat} : web.Admits (full t) t n :=
  admits_iff.mpr Nat.zero_lt_one

theorem zero_of_le_zero : ∀ {t : Nat}, t ≤ 0 → t = 0
  | 0, _ => rfl
  | _ + 1, le => absurd le (Nat.not_succ_le_zero _)

/-- **Up to step 0 the burst widens the rising course.** -/
theorem burst_widens_now : web.WidensUpTo 0 burst rising :=
  ⟨fun t n le admitted =>
    have zero : t = 0 := zero_of_le_zero le
    have atZero : web.Admits (rising 0) 0 n :=
      Eq.subst (motive := fun s => web.Admits (rising s) s n) zero admitted
    Eq.subst (motive := fun s => web.Admits (burst s) s n) zero.symm
      (burst_zero_iff.mpr (Nat.le_trans (rising_iff.mp atZero) (Nat.zero_le 1))),
   ⟨0, 1, Nat.le_refl 0, burst_zero_iff.mpr (Nat.le_refl 1),
    fun admitted => Nat.not_succ_le_zero 0 (rising_iff.mp admitted)⟩⟩

/-- **Over every step the two are mixed.** -/
theorem mixed : web.Mixed rising burst :=
  ⟨⟨1, 0, rising_iff.mpr (Nat.zero_le 1), burst_later⟩,
   ⟨0, 1, burst_zero_iff.mpr (Nat.le_refl 1),
    fun admitted => Nat.not_succ_le_zero 0 (rising_iff.mp admitted)⟩⟩

/-- **The rising course eventually widens the burst.** -/
theorem rising_eventually_widens_burst : web.EventuallyWidens rising burst :=
  Web.eventually_of_vanishing (T := 1)
    (fun t _ from_ admitted => match t, from_, admitted with
      | _ + 1, _, admitted => burst_later admitted)
    (fun S => ⟨S, 0, Nat.le_refl S, rising_iff.mpr (Nat.zero_le S)⟩)

/-- **The rising course keeps widening by name.** -/
theorem rising_keeps_widening : web.KeepsWidening Web.itself rising 0 :=
  ⟨fun _ _ _ later => (Web.includesAcross_itself_iff later).mpr fun _ admitted =>
      rising_iff.mpr (Nat.le_trans (rising_iff.mp admitted) later),
   fun S _ => ⟨S + 1, Nat.le_succ S, (Web.exceedsAcross_itself_iff (Nat.le_succ S)).mpr
      ⟨S + 1, rising_iff.mpr (Nat.le_refl (S + 1)),
       fun admitted => Nat.not_succ_le_self S (rising_iff.mp admitted)⟩⟩⟩

/-- The burst does not keep opening from any step. -/
theorem burst_not_opening (T : Nat) : ¬ web.KeepsOpening Web.itself burst T :=
  fun opens => match opens (T + 1) (Nat.le_succ T) with
    | ⟨U, later, ⟨_, admitted, _⟩⟩ => match U, later, admitted with
      | 0, later, _ => absurd later (Nat.not_succ_le_zero T)
      | _ + 1, _, admitted => burst_later admitted

theorem burst_not_keeps_widening (T : Nat) : ¬ web.KeepsWidening Web.itself burst T :=
  fun keeps => burst_not_opening T keeps.2

/-- **Widening and eventual widening disagree.** -/
theorem disagreement :
    web.WidensUpTo 0 burst rising ∧ web.Mixed rising burst ∧ web.EventuallyWidens rising burst ∧
      web.KeepsWidening Web.itself rising 0 ∧ ∀ T, ¬ web.KeepsWidening Web.itself burst T :=
  ⟨burst_widens_now, mixed, rising_eventually_widens_burst, rising_keeps_widening,
   burst_not_keeps_widening⟩

/-- The saturated course widens the rising one. -/
theorem full_widens_rising : web.Widens full rising :=
  ⟨fun _ _ _ => full_admits, ⟨0, 1, full_admits,
    fun admitted => Nat.not_succ_le_zero 0 (rising_iff.mp admitted)⟩⟩

/-- **Where widening orders a pair and the wider course keeps exceeding, eventual widening
agrees**: the saturated course also eventually widens the rising one. -/
theorem full_eventually_widens_rising : web.EventuallyWidens full rising :=
  Web.WidensWithoutEnd.eventually ⟨full_widens_rising.1, fun S =>
    ⟨S, S + 1, Nat.le_refl S, full_admits,
     fun admitted => Nat.not_succ_le_self S (rising_iff.mp admitted)⟩⟩

/-- The saturated course opens nothing from any step. -/
theorem full_not_opening (T : Nat) : ¬ web.KeepsOpening Web.itself full T :=
  fun opens => match opens T (Nat.le_refl T) with
    | ⟨_, later, ⟨g, _, apart⟩⟩ => apart g (Web.Linked.itself_of_le later) full_admits

/-- **Keeping widening is not kept by widening.** -/
theorem not_monotone :
    web.Widens full rising ∧ web.KeepsWidening Web.itself rising 0 ∧
      ∀ T, ¬ web.KeepsWidening Web.itself full T :=
  ⟨full_widens_rising, rising_keeps_widening, fun T keeps => full_not_opening T keeps.2⟩

/-- **On this web no flow is opened by the opened**: nothing is ever supported, so no gain recurs. -/
theorem not_opened (L : Flow Nat Nat) (T : Nat) : ¬ Flow.OpenedByOpened L web T :=
  Flow.OpenedByOpened.not_of_unsupported (T := 0)
    (fun _ f _ supported => Nat.not_succ_le_zero 0 (supported f rfl)) T

end OwnCondition

/-! ## A lag defeats eventual widening -/

namespace LagWitness

open OwnCondition

/-- At step `t` only formation `t` is admitted: each formation for one step. -/
def travelling : Nat → Nat → Nat := fun t c => if c = t then 1 else 0

/-- At step `t` the formations below `t` are admitted: each kept forever from the step after. -/
def lagging : Nat → Nat → Nat := fun t c => rung (c + 1) t

theorem lagging_iff {t n : Nat} : OwnCondition.web.Admits (lagging t) t n ↔ n < t :=
  ⟨fun admitted => le_of_rung_pos ((admits_iff (m := lagging t)).mp admitted),
   fun lt => (admits_iff (m := lagging t)).mpr (rung_pos lt)⟩

theorem travelling_iff {t n : Nat} : OwnCondition.web.Admits (travelling t) t n ↔ n = t :=
  ⟨fun admitted => match Nat.decEq n t with
     | .isTrue same => same
     | .isFalse other => absurd ((admits_iff (m := travelling t)).mp admitted)
         (show ¬ 0 < (if n = t then 1 else 0) from (if_neg other).symm ▸ Nat.lt_irrefl 0),
   fun same => (admits_iff (m := travelling t)).mpr
     (show 0 < (if n = t then 1 else 0) from (if_pos same).symm ▸ Nat.zero_lt_one)⟩

/-- The lagging course keeps widening by name. -/
theorem lagging_keeps_widening : OwnCondition.web.KeepsWidening Web.itself lagging 0 :=
  ⟨fun _ _ _ later => (Web.includesAcross_itself_iff later).mpr fun _ admitted =>
      lagging_iff.mpr (Nat.lt_of_lt_of_le (lagging_iff.mp admitted) later),
   fun S _ => ⟨S + 1, Nat.le_succ S, (Web.exceedsAcross_itself_iff (Nat.le_succ S)).mpr
      ⟨S, lagging_iff.mpr (Nat.lt_succ_self S),
       fun admitted => Nat.lt_irrefl S (lagging_iff.mp admitted)⟩⟩⟩

/-- Every formation the travelling course admits, the lagging course admits at every later step. -/
theorem kept_later {t u n : Nat} (admitted : OwnCondition.web.Admits (travelling t) t n)
    (later : t < u) : OwnCondition.web.Admits (lagging u) u n :=
  lagging_iff.mpr (Eq.subst (motive := fun x => x < u) (travelling_iff.mp admitted).symm later)

/-- The lagging course does not eventually widen the travelling one. -/
theorem not_eventually_lagging : ¬ OwnCondition.web.EventuallyWidens lagging travelling :=
  fun widens => match (Web.eventuallyWidens_iff.mp widens).1 with
    | ⟨T, inc⟩ => Nat.lt_irrefl T (lagging_iff.mp (inc T T (Nat.le_refl T) (travelling_iff.mpr rfl)))

/-- The travelling course does not eventually widen the lagging one. -/
theorem not_eventually_travelling : ¬ OwnCondition.web.EventuallyWidens travelling lagging :=
  fun widens => match (Web.eventuallyWidens_iff.mp widens).1 with
    | ⟨T, inc⟩ => Nat.noConfusion
        (travelling_iff.mp (inc (T + 1) 0 (Nat.le_succ T) (lagging_iff.mpr (Nat.zero_lt_succ T))))

/-- **A lag**: the lagging course keeps widening and keeps every formation of the travelling course
from one step later, yet neither eventually widens the other. -/
theorem lag :
    OwnCondition.web.KeepsWidening Web.itself lagging 0 ∧
      (∀ t u n, OwnCondition.web.Admits (travelling t) t n → t < u →
        OwnCondition.web.Admits (lagging u) u n) ∧
      ¬ OwnCondition.web.EventuallyWidens lagging travelling ∧
      ¬ OwnCondition.web.EventuallyWidens travelling lagging :=
  ⟨lagging_keeps_widening, fun _ _ _ admitted later => kept_later admitted later,
   not_eventually_lagging, not_eventually_travelling⟩

end LagWitness

/-! ## Along a merging continuation a constant course keeps widening -/

namespace MergedWitness

/-- Two formations, requiring nothing. -/
def web : Web Bool Unit :=
  ⟨fun _ _ => 0, fun _ _ => True, fun _ _ _ => False, fun _ _ _ => 0, fun _ _ _ => False⟩

/-- Every formation continues as `false`; nothing continues as `true`. -/
def merge : Nat → Bool → Bool → Prop := fun _ _ f => f = false

/-- The constant course. -/
def steady : Nat → Unit → Nat := fun _ _ => 0

theorem admits (m : Unit → Nat) (t : Nat) (f : Bool) : web.Admits m t f := fun _ no => nomatch no

theorem into_true_aux : ∀ {s : Nat} {g : Bool} {u : Nat} {h : Bool},
    Web.Linked merge s g u h → h = true → s = u ∧ g = true
  | _, _, _, _, .here _ _, same => ⟨rfl, same⟩
  | _, _, _, _, .next step rest, same => match into_true_aux rest same with
    | ⟨_, same'⟩ => nomatch (same'.symm.trans step : true = false)

theorem into_true {s : Nat} {g : Bool} {u : Nat} (linked : Web.Linked merge s g u true) :
    s = u ∧ g = true :=
  into_true_aux linked rfl

theorem to_false : ∀ (k s : Nat) (g : Bool), Web.Linked merge s g (s + 1 + k) false
  | 0, s, _ => .next (f := false) rfl (.here (s + 1) false)
  | k + 1, s, _ => .next (f := false) rfl
      (Eq.subst (motive := fun x => Web.Linked merge (s + 1) false x false)
        (Nat.succ_add (s + 1) k) (to_false k (s + 1) false))

/-- **Along the merge, the constant course keeps widening**: `true`, re-formed at each step,
continues nothing. -/
theorem keeps_widening_along_merge : web.KeepsWidening merge steady 0 :=
  ⟨fun S _ _ le => fun f _ => match Nat.eq_or_lt_of_le le with
     | .inl same => ⟨f, same ▸ .here S f, admits _ _ _⟩
     | .inr lt => match le_dest (Nat.succ_le_of_lt lt) with
       | ⟨k, apart⟩ => ⟨false, apart ▸ to_false k S f, admits _ _ _⟩,
   fun S _ => ⟨S + 1, Nat.le_succ S, ⟨true, admits _ _ _, fun _ linked _ =>
     Nat.succ_ne_self S (into_true linked).1.symm⟩⟩⟩

theorem listed : ∀ f : Bool, f ∈ [false, true]
  | false => .head _
  | true => .tail _ (.head _)

/-- By name the constant course does not keep widening. -/
theorem not_keeps_widening_by_name (T : Nat) : ¬ web.KeepsWidening Web.itself steady T :=
  Web.KeepsWidening.not_listed listed

end MergedWitness

/-! ## One range, two carriers -/

namespace OpeningChain

open OwnCondition

/-- The rising course as a web: the conditions up to `t` stand at one at step `t`, the formations up
to `t` are active, and each formation requires only its own condition, at need one. -/
def web : Web Nat Nat :=
  ⟨fun t c => rung c t, fun t n => n ≤ t, fun _ n c => c = n, fun _ _ _ => 1, fun _ _ _ => False⟩

/-- Its levels are the rising course. -/
theorem level_rising : web.level = rising := rfl

theorem supported_iff {t n : Nat} : web.Supported t n ↔ n ≤ t :=
  ⟨fun supported => le_of_rung_pos (supported n rfl),
   fun le _ same => Eq.subst (motive := fun x => 0 < rung x t) same.symm (rung_pos le)⟩

/-- A gain of support across the step from `t` is formation `t + 1`'s. -/
theorem gains_iff {t f : Nat} : web.GainsSupport t f ↔ f = t + 1 :=
  ⟨fun ⟨before, after⟩ => Nat.le_antisymm (supported_iff.mp after)
      ((Nat.lt_or_ge t f).resolve_right fun le => before (supported_iff.mpr le)),
   fun same => ⟨fun supported => Nat.not_succ_le_self t
      (Eq.subst (motive := fun x => x ≤ t) same (supported_iff.mp supported)),
     supported_iff.mpr (Nat.le_of_eq same)⟩⟩

/-- Condition `t + 1` rises across the step from `t`. -/
theorem rises_next (t : Nat) : web.Rises t (t + 1) :=
  show rung (t + 1) t < rung (t + 1) (t + 1) from
  Eq.subst (motive := fun x => x < rung (t + 1) (t + 1)) (rung_zero (Nat.lt_succ_self t)).symm
    (rung_pos (Nat.le_refl (t + 1)))

/-- What steps the level of condition `c` from `g` to `g + 1`: one unit to condition `g + 1`. -/
def opening (g c : Nat) : Nat := rung c (g + 1) - rung c g

theorem opening_pos (t : Nat) : 0 < opening t (t + 1) :=
  Eq.subst (motive := fun x => 0 < rung (t + 1) (t + 1) - x) (rung_zero (Nat.lt_succ_self t)).symm
    (rung_pos (Nat.le_refl (t + 1)))

/-- **The relay**: at step `t` formation `t` alone takes part and gives one unit to condition
`t + 1`. -/
def relay : Flow Nat Nat := ⟨fun t => [t], fun _ _ _ => 0, fun _ g c => opening g c⟩

/-- **One giver**: at step `t` formation `0` alone takes part and gives the same unit. -/
def oneGiver : Flow Nat Nat := ⟨fun _ => [0], fun _ _ _ => 0, fun t _ c => opening t c⟩

theorem balanced_step (t c : Nat) : rung c (t + 1) = rung c t + opening t c :=
  (add_sub_of_le (rung_mono c t)).symm

/-- The relay balances. -/
theorem relay_balances : relay.Balances web := fun t c =>
  show rung c (t + 1) + (0 + 0) = rung c t + (opening t c + 0) from balanced_step t c

/-- The single giver balances on the same web. -/
theorem oneGiver_balances : oneGiver.Balances web := fun t c =>
  show rung c (t + 1) + (0 + 0) = rung c t + (opening t c + 0) from balanced_step t c

/-- In the relay only active formations give. -/
theorem relay_acting : relay.Acting web := fun _ _ _ mem _ =>
  match mem_cons_cases mem with
  | .inl same => Nat.le_of_eq same
  | .inr inner => nomatch inner

/-- With the single giver only active formations give. -/
theorem oneGiver_acting : oneGiver.Acting web := fun t _ _ mem _ =>
  match mem_cons_cases mem with
  | .inl same => Eq.subst (motive := fun x => x ≤ t) same.symm (Nat.zero_le t)
  | .inr inner => nomatch inner

/-- In both, a formation is active only where supported. -/
theorem dependent : web.Dependent := fun _ _ active => supported_iff.mpr active

/-- **The relay is opened by the opened**: a gain at every step, each given on the rising condition
the gainer requires by the formation that gained support at the step before. -/
theorem relay_opened : Flow.OpenedByOpened relay web 0 :=
  ⟨fun N => ⟨N, N + 1, Nat.le_refl N, gains_iff.mpr rfl⟩,
   fun t f after gains => match t, after, gains_iff.mp gains with
    | s + 1, _, same => ⟨f, s + 1, s, rfl,
        Eq.subst (motive := fun x => web.Rises (s + 1) x) same.symm (rises_next (s + 1)),
        .head [],
        Eq.subst (motive := fun x => 0 < opening (s + 1) x) same.symm (opening_pos (s + 1)),
        supported_iff.mpr (Nat.le_refl (s + 1)), Nat.zero_le s, Nat.lt_succ_self s,
        gains_iff.mpr rfl⟩⟩

/-- **The single giver's range is not opened by the opened**: its giver never gained support. -/
theorem oneGiver_not_opened : ¬ Flow.OpenedByOpened oneGiver web 0 := fun ⟨_, opened⟩ =>
  match opened 1 2 (Nat.lt_succ_self 0) (gains_iff.mpr rfl) with
  | ⟨_, _, u, _, _, mem, _, _, _, _, gained⟩ =>
    match mem_cons_cases mem with
    | .inl same => gained.1 (supported_iff.mpr
        (Eq.subst (motive := fun x => x ≤ u) same.symm (Nat.zero_le u)))
    | .inr inner => nomatch inner

/-- **One range, two carriers.** On one web, so with the same levels at every step and so the same
admissions, the relay and the single giver both balance with only active formations giving, and the
relay's range is opened by the opened while the single giver's is not. -/
theorem carried :
    relay.Balances web ∧ oneGiver.Balances web ∧ relay.Acting web ∧ oneGiver.Acting web ∧
      web.Dependent ∧ Flow.OpenedByOpened relay web 0 ∧ ¬ Flow.OpenedByOpened oneGiver web 0 :=
  ⟨relay_balances, oneGiver_balances, relay_acting, oneGiver_acting, dependent, relay_opened,
   oneGiver_not_opened⟩

end OpeningChain

/-! ## Ranking by opened by the opened reverses widening -/

namespace Saturated

open OwnCondition

/-- Every condition stands at one throughout; each formation requires its own condition at need
one. -/
def web : Web Nat Nat :=
  ⟨fun _ _ => 1, fun _ _ => True, fun _ n c => c = n, fun _ _ _ => 1, fun _ _ _ => False⟩

/-- Nothing takes part. -/
def still : Flow Nat Nat := ⟨fun _ => [], fun _ _ _ => 0, fun _ _ _ => 0⟩

theorem level_full : web.level = full := rfl

theorem still_balances : still.Balances web := fun _ _ => rfl

/-- Everything is supported throughout, so nothing gains support, and no gain recurs. -/
theorem still_not_opened (T : Nat) : ¬ Flow.OpenedByOpened still web T :=
  fun ⟨recur, _⟩ => match recur 0 with
    | ⟨_, _, _, gains⟩ => gains.1 (fun _ _ => Nat.le_refl 1)

/-- **Ranking by opened by the opened reverses widening.** The relay is opened by the opened and its
levels are the rising course; a flow that is not, on a web whose levels are the saturated course,
has levels that widen the rising course (read on the same requirements). -/
theorem reverses :
    Flow.OpenedByOpened OpeningChain.relay OpeningChain.web 0 ∧ OpeningChain.web.level = rising ∧
      (∀ T, ¬ Flow.OpenedByOpened still web T) ∧ web.level = full ∧
      OwnCondition.web.Widens full rising :=
  ⟨OpeningChain.relay_opened, OpeningChain.level_rising, still_not_opened, level_full,
   full_widens_rising⟩

end Saturated

/-! ## Opened by the opened without widening -/

namespace ClosedCycle

/-- Alternates from `false`. -/
def parity : Nat → Bool
  | 0 => false
  | n + 1 => !parity n

/-- One where the two agree. -/
def mark : Bool → Bool → Nat
  | true, true => 1
  | false, false => 1
  | true, false => 0
  | false, true => 0

theorem mark_pos_iff : ∀ {a b : Bool}, 0 < mark a b ↔ a = b
  | true, true => ⟨fun _ => rfl, fun _ => Nat.zero_lt_one⟩
  | false, false => ⟨fun _ => rfl, fun _ => Nat.zero_lt_one⟩
  | true, false => ⟨fun pos => absurd pos (Nat.lt_irrefl 0), fun same => nomatch same⟩
  | false, true => ⟨fun pos => absurd pos (Nat.lt_irrefl 0), fun same => nomatch same⟩

theorem mark_self : ∀ a : Bool, mark a a = 1
  | true => rfl
  | false => rfl

theorem mark_not_left : ∀ a : Bool, mark (!a) a = 0
  | true => rfl
  | false => rfl

/-- Two formations, each requiring its own condition at need one. At step `t` the unit stands at the
condition of `parity t`, and that formation alone is active. -/
def web : Web Bool Bool :=
  ⟨fun t c => mark c (parity t), fun t f => f = parity t, fun _ f c => c = f, fun _ _ _ => 1,
   fun _ f c => c = f⟩

/-- At step `t` the active formation takes the unit from its own condition and gives it to the
other's. -/
def flow : Flow Bool Bool :=
  ⟨fun t => [parity t], fun _ g c => mark c g, fun _ g c => mark c (!g)⟩

theorem supported_iff {t : Nat} {f : Bool} : web.Supported t f ↔ f = parity t :=
  ⟨fun supported => mark_pos_iff.mp (supported f rfl),
   fun same _ c_eq => Eq.subst (motive := fun x => 0 < mark x (parity t)) c_eq.symm
     (mark_pos_iff.mpr same)⟩

/-- A gain of support across the step from `t` is the other formation's. -/
theorem gains_iff {t : Nat} {f : Bool} : web.GainsSupport t f ↔ f = parity (t + 1) :=
  ⟨fun ⟨_, after⟩ => supported_iff.mp after,
   fun same => ⟨fun supported => ListTests.not_ne_self (parity t) (same.symm.trans (supported_iff.mp supported)),
     supported_iff.mpr same⟩⟩

/-- The cycle balances: the unit moves, nothing is made. -/
theorem balances : flow.Balances web := fun t c =>
  show mark c (!parity t) + (mark c (parity t) + 0) = mark c (parity t) + (mark c (!parity t) + 0)
  from Nat.add_comm _ _

/-- Only the active formation gives. -/
theorem acting : flow.Acting web := fun _ _ _ mem _ =>
  match mem_cons_cases mem with
  | .inl same => same
  | .inr inner => nomatch inner

/-- A formation is active only where supported. -/
theorem dependent : web.Dependent := fun _ _ active => supported_iff.mpr active

/-- The gainer's own condition rises across the step. -/
theorem rises_at {t : Nat} {f : Bool} (same : f = parity (t + 1)) : web.Rises t f :=
  show mark f (parity t) < mark f (parity (t + 1)) from
  Eq.subst (motive := fun x => mark x (parity t) < mark x (parity (t + 1))) same.symm
    (show mark (!parity t) (parity t) < mark (!parity t) (!parity t) from
      Eq.subst (motive := fun x => x < mark (!parity t) (!parity t)) (mark_not_left (parity t)).symm
        (Eq.subst (motive := fun x => 0 < x) (mark_self (!parity t)).symm Nat.zero_lt_one))

/-- The active formation gives the gainer's condition its unit. -/
theorem give_pos {t : Nat} {f : Bool} (same : f = parity (t + 1)) :
    0 < flow.give t (parity t) f :=
  show 0 < mark f (!parity t) from
  Eq.subst (motive := fun x => 0 < mark x (!parity t)) same.symm
    (Eq.subst (motive := fun x => 0 < x) (mark_self (!parity t)).symm Nat.zero_lt_one)

/-- **The cycle is opened by the opened**: a gain at every step, each given by the member that gained
the step before. -/
theorem opened : Flow.OpenedByOpened flow web 0 :=
  ⟨fun N => ⟨N, parity (N + 1), Nat.le_refl N, gains_iff.mpr rfl⟩,
   fun t f after gains => match t, after, gains_iff.mp gains with
    | s + 1, _, same => ⟨f, parity (s + 1), s, rfl, rises_at same, .head [], give_pos same,
        supported_iff.mpr rfl, Nat.zero_le s, Nat.lt_succ_self s, gains_iff.mpr rfl⟩⟩

/-- Each formation continues as the other. -/
def passing : Nat → Bool → Bool → Prop := fun _ g f => f = !g

theorem linked_parity : ∀ (k S : Nat), Web.Linked passing S (parity S) (S + k) (parity (S + k))
  | 0, S => .here S (parity S)
  | k + 1, S => .next (f := parity (S + 1)) rfl
      (Eq.subst (motive := fun x => Web.Linked passing (S + 1) (parity (S + 1)) x (parity x))
        (Nat.succ_add S k) (linked_parity k (S + 1)))

theorem linked_to {S U : Nat} (le : S ≤ U) : Web.Linked passing S (parity S) U (parity U) :=
  match le_dest le with
  | ⟨k, apart⟩ => Eq.subst (motive := fun x => Web.Linked passing S (parity S) x (parity x))
      apart.symm (linked_parity k S)

/-- **Along the passing continuation nothing admitted is lost.** -/
theorem includes_across : web.IncludesAcrossFrom passing web.level 0 :=
  fun S U _ le _ admitted => ⟨parity U,
    Eq.subst (motive := fun x => Web.Linked passing S x U (parity U))
      (supported_iff.mp admitted).symm (linked_to le),
    supported_iff.mpr rfl⟩

/-- **Along the passing continuation nothing is opened.** -/
theorem not_opening (T : Nat) : ¬ web.KeepsOpening passing web.level T :=
  fun opens => match opens T (Nat.le_refl T) with
    | ⟨U, le, ⟨_, admitted, apart⟩⟩ =>
      apart (parity T)
        (Eq.subst (motive := fun x => Web.Linked passing T (parity T) U x)
          (supported_iff.mp admitted).symm (linked_to le))
        (supported_iff.mpr rfl)

theorem listed : ∀ f : Bool, f ∈ [false, true]
  | false => .head _
  | true => .tail _ (.head _)

/-- By name the range does not keep widening. -/
theorem not_keeps_widening_by_name (T : Nat) : ¬ web.KeepsWidening Web.itself web.level T :=
  Web.KeepsWidening.not_listed listed

/-- **Opened by the opened without widening.** The cycle balances with only active formations
giving and activity needing support, is opened by the opened with a gain at every step, keeps its
range along the passing continuation, and keeps widening neither along it nor by name. -/
theorem cycle :
    flow.Balances web ∧ flow.Acting web ∧ web.Dependent ∧ Flow.OpenedByOpened flow web 0 ∧
      web.IncludesAcrossFrom passing web.level 0 ∧ (∀ T, ¬ web.KeepsOpening passing web.level T) ∧
      ∀ T, ¬ web.KeepsWidening Web.itself web.level T :=
  ⟨balances, acting, dependent, opened, includes_across, not_opening, not_keeps_widening_by_name⟩

end ClosedCycle

end Becoming
