import Becoming.Viability
import Becoming.Recurrence
import Becoming.Likeness

/-!
# Lasting: a number of steps, exhaustion, never reaching and reaching

`Becoming.Viability` states where no course ever leaves a guard. This module states the same for
a finite number of steps and reads it from both sides: what suffices for lasting `n` steps and
what lasting `n` steps requires. It then states when a guard is exhausted, where a determined
law never reaches a target, and, dually, when a law reaches a target within `n` steps.

* **Lasting a horizon.** `Lasts f adm guard n s`: `s` is within the guard and, for `n` more
  steps, so is every configuration an admissible disturbance takes it to. A **ladder** is a
  family of levels within the guard in which every admissible step from level `k + 1` lands at
  level `k` (`Ladder`). A start lasts `n` steps exactly when some ladder holds it at level `n`
  (`lasts_iff_ladder`); `Lasts` is itself a ladder, the largest. A family is **necessary** when
  the guard gives level `0` and a configuration within the guard whose admissible successors are
  all at level `k` is at level `k + 1` (`Necessary`). A start lasts `n` steps exactly when every
  necessary family holds it at level `n` (`lasts_iff_necessary`); `Lasts` is the least. A family
  that is both is exactly `Lasts` (`lasts_iff_of_exact`). Given one admissible disturbance,
  lasting `n` steps is staying within the guard for the first `n` steps of every admissible
  history (`lasts_iff_histories`). With no premise, the kernel of `Becoming.Viability` is what
  lasts every horizon (`kernel_iff_lasts`). From within the guard, a guarded history agrees with
  the history at `n` exactly when the history stays within the guard up to `n`
  (`guarded_upto_iff`), and stops exactly when it does not (`guarded_none_iff`).
* **Exhaustion.** A family is **drained** when the guard gives level `0` and a configuration
  within the guard that one admissible step takes to level `k` was at level `k + 1` (`Drains`).
  Along every admissible history that stays within the guard for its first `n` steps, the start
  is at level `n` (`Drains.along`). So a start below level `n` leaves the guard within `n` steps
  on every admissible history (`Drains.leaves`). Being at level `n` does not suffice
  (`Collapse.level_not_lasting`). A sequence whose growth is bounded by a monotone map stays
  below the map's orbit (`below_orbit`), and the orbit is the worst such growth
  (`stays_below_iff`). Let a quantity grow at most by a monotone map, and let each step taken
  while the quantity's orbit stays at or below a threshold lower the level by one. Then every start
  whose orbit stays at or below the threshold for `n` steps and which is not at level `n`
  leaves the guard within `n` steps on every admissible history (`exhausts`).
* **Never reaching.** A determined law's orbit never reaches a target exactly when some set
  containing the start avoids the target and is closed under the law (`avoids_iff_closed`).
  This is the invariance kernel of the target's complement (`avoids_iff_kernel`). Here each
  configuration has one course, so in Aubin's terms this is also the viability kernel. Some seed
  never reaches the target exactly when such a set contains a seed (`some_avoids_iff`). No seed
  avoids the target exactly when no such set contains a seed (`none_avoid_iff`); read with
  excluded middle, which the core does not use, the left side says every seed reaches the
  target. A fixed configuration outside the target is such a set by itself (`fixed_avoids`).
* **Reaching.** `Reaches f adm target n s`: `s` is in the target, or every admissible disturbance
  takes it to a configuration that reaches the target within `n - 1` steps. A **funnel** is a
  family of levels whose level `0` lies in the target and whose configurations at level `k + 1`
  are in the target or go to level `k` under every admissible disturbance (`Funnel`). A start
  reaches the target within `n` steps exactly when some funnel holds it at level `n`
  (`reaches_iff_funnel`), and exactly when every **basin** (the target at every level, and what
  every admissible disturbance takes to level `k` at level `k + 1`) holds it there
  (`reaches_iff_basin`); `Reaches` is the largest funnel and the least basin. Reaching composes
  (`Reaches.trans`). What reaches meets the target within `n` steps on every admissible
  history (`Reaches.histories`); the converse holds for a decided target given one admissible
  disturbance (`reaches_iff_histories`), and needs the decision: for one law it is the limited
  principle of omniscience (`Search.histories_need_decision`). A numeric **variant** (a level
  in `Nat` that every step from outside the target lowers) at most `n` at the start reaches
  within `n` steps (`Variant.reaches`). For a determined law, reaching is meeting the target on
  the orbit (`reaches_iff_orbit`), the funnel law needs no decision
  (`orbit_reaches_iff_funnel`), and with a decided target the orbit meets it within `n` steps
  exactly when a numeric variant is at most `n` at the start (`orbit_reaches_iff_variant`); a
  numeric variant for every law and target would decide equality (`numeric_needs_decision`).
  Reaching and lasting outside the target exclude each other where a disturbance is admissible
  (`Reaches.not_lasts`); for a determined law and a decided target they are complements
  (`reaches_iff_not_lasts`), and without the decision double negation would be eliminated
  (`dual_needs_decision`).
* **Lasting some course.** `Lasts` asks every admissible course to stay; here some course goes
  on. `Continues P n s`: some course of `n` steps starts at `s`; `Unbounded P s`: courses of
  every length do. Where the process branches finitely (`FinitelyBranching`), the depth reached
  is decided (`Continues.decided`), and an unbounded configuration cannot fail to have an
  unbounded successor (`Unbounded.step_not_not`). That it has one follows from
  `EitherThroughout` (`Unbounded.step_of_either`), and asked of every finitely branching process
  it is exactly that principle (`step_iff_either`, witness the two chains of `Chains`). A
  selection of a successor staying in a family gives a run from each member (`runOf`), so
  `EitherThroughout` and a choice of an unbounded successor lift courses of every length to a run
  (`lifting`). Where the branching is infinite, courses of every length need not continue one
  another (`Fan.no_unbounded_step`). `EitherThroughout` is the lesser limited principle of
  omniscience for decided families (`eitherThroughout_iff_llpoForDecided` of
  `Becoming.Likeness`), and gives `LLPO` (`LLPO.of_eitherThroughout`). So between courses of every
  length and an unbounded successor lies exactly `LLPO` for decided families, as weak König's
  lemma is equivalent to `LLPO` (Ishihara 1990; Bridges and Richman 1987); `lifting` needs, besides,
  a choice of the successor.

Every condition named here is local: one step from each configuration. Which guard, levels,
quantity, threshold and target an application uses are supplied with it; nothing here says that
some ladder, drained family, closed set or funnel exists. No premise is added; every declaration
has an empty axiom report.
-/

namespace Becoming

open Generative

universe u v w

namespace Lasting

open Viability

variable {S : Type u} {A : Type v}

/-! ## Lasting a horizon -/

/-- `Lasts f adm guard n s`: `s` is within the guard and, for `n` more steps, so is every
configuration an admissible disturbance takes it to. -/
def Lasts (f : S → A → S) (adm : A → Prop) (guard : S → Prop) : Nat → S → Prop
  | 0, s => guard s
  | n + 1, s => guard s ∧ ∀ a, adm a → Lasts f adm guard n (f s a)

/-- A **ladder** for a guard: levels within the guard, every admissible step from level `k + 1`
landing at level `k`. -/
structure Ladder (f : S → A → S) (adm : A → Prop) (guard : S → Prop) (C : Nat → S → Prop) :
    Prop where
  within : ∀ k x, C k x → guard x
  descends : ∀ k x a, adm a → C (k + 1) x → C k (f x a)

/-- A family **necessary** for lasting: within the guard is level `0`, and a configuration
within the guard whose admissible successors are all at level `k` is at level `k + 1`. -/
structure Necessary (f : S → A → S) (adm : A → Prop) (guard : S → Prop) (L : Nat → S → Prop) :
    Prop where
  base : ∀ x, guard x → L 0 x
  rises : ∀ k x, guard x → (∀ a, adm a → L k (f x a)) → L (k + 1) x

/-- A family **drained** along every admissible step: within the guard is level `0`, and a
configuration within the guard that one admissible step takes to level `k` was at level
`k + 1`. -/
structure Drains (f : S → A → S) (adm : A → Prop) (guard : S → Prop) (L : Nat → S → Prop) :
    Prop where
  base : ∀ x, guard x → L 0 x
  rises : ∀ k x a, guard x → adm a → L k (f x a) → L (k + 1) x

variable {f : S → A → S} {adm : A → Prop} {guard : S → Prop}

/-- What lasts is within the guard. -/
theorem Lasts.within : ∀ {n : Nat} {s : S}, Lasts f adm guard n s → guard s
  | 0, _, lasts => lasts
  | _ + 1, _, lasts => And.left lasts

/-- **Every ladder lasts**: a start at level `n` of a ladder lasts `n` steps. -/
theorem Ladder.lasts {C : Nat → S → Prop} (ladder : Ladder f adm guard C) :
    ∀ (n : Nat) (s : S), C n s → Lasts f adm guard n s
  | 0, s, held => ladder.within 0 s held
  | n + 1, s, held => And.intro (ladder.within (n + 1) s held)
      (fun a admitted => Ladder.lasts ladder n (f s a) (ladder.descends n s a admitted held))

/-- **`Lasts` is a ladder.** -/
theorem lasts_ladder : Ladder f adm guard (Lasts f adm guard) :=
  ⟨fun _ _ lasts => Lasts.within lasts, fun _ _ a admitted lasts => And.right lasts a admitted⟩

/-- **A start lasts `n` steps exactly when some ladder holds it at level `n`.** -/
theorem lasts_iff_ladder {n : Nat} {s : S} :
    Lasts f adm guard n s ↔ ∃ C : Nat → S → Prop, C n s ∧ Ladder f adm guard C :=
  ⟨fun lasts => ⟨Lasts f adm guard, lasts, lasts_ladder⟩,
   fun ⟨_, held, ladder⟩ => Ladder.lasts ladder n s held⟩

/-- **Every necessary family holds what lasts.** -/
theorem Necessary.of_lasts {L : Nat → S → Prop} (necessary : Necessary f adm guard L) :
    ∀ (n : Nat) (s : S), Lasts f adm guard n s → L n s
  | 0, s, lasts => necessary.base s lasts
  | n + 1, s, lasts => necessary.rises n s (And.left lasts)
      (fun a admitted => Necessary.of_lasts necessary n (f s a) (And.right lasts a admitted))

/-- **`Lasts` is necessary.** -/
theorem lasts_necessary : Necessary f adm guard (Lasts f adm guard) :=
  ⟨fun _ held => held, fun _ _ held next => And.intro held next⟩

/-- **A start lasts `n` steps exactly when every necessary family holds it at level `n`.** -/
theorem lasts_iff_necessary {n : Nat} {s : S} :
    Lasts f adm guard n s ↔ ∀ L : Nat → S → Prop, Necessary f adm guard L → L n s :=
  ⟨fun lasts _ necessary => Necessary.of_lasts necessary n s lasts,
   fun every => every (Lasts f adm guard) lasts_necessary⟩

/-- **A family that is both a ladder and necessary is exactly lasting.** -/
theorem lasts_iff_of_exact {C : Nat → S → Prop} (ladder : Ladder f adm guard C)
    (necessary : Necessary f adm guard C) (n : Nat) (s : S) : Lasts f adm guard n s ↔ C n s :=
  ⟨Necessary.of_lasts necessary n s, Ladder.lasts ladder n s⟩

/-! ### Histories -/

theorem prepend_admissible {a : A} {d : Nat → A} (admitted : adm a)
    (admissible : ∀ k, adm (d k)) : ∀ k, adm (Settling.consAct a d k)
  | 0 => admitted
  | k + 1 => admissible k

/-- **What lasts `n` steps stays within the guard for the first `n` steps of every admissible
history.** -/
theorem Lasts.histories : ∀ {n : Nat} {s : S}, Lasts f adm guard n s →
    ∀ d : Nat → A, (∀ k, adm (d k)) → ∀ k, k ≤ n → guard (history f s d k)
  | 0, _, lasts, _, _, 0, _ => lasts
  | 0, _, _, _, _, k + 1, bound => absurd bound (Nat.not_succ_le_zero k)
  | _ + 1, _, lasts, _, _, 0, _ => And.left lasts
  | _ + 1, s, lasts, d, admissible, k + 1, bound =>
      Eq.mpr (congrArg guard (history_shift f s d k))
        (Lasts.histories (And.right lasts (d 0) (admissible 0)) (fun j => d (j + 1))
          (fun j => admissible (j + 1)) k (Nat.le_of_succ_le_succ bound))

/-- **Given one admissible disturbance, what stays within the guard for the first `n` steps of
every admissible history lasts `n` steps.** -/
theorem lasts_of_histories {a₀ : A} (h₀ : adm a₀) : ∀ {n : Nat} {s : S},
    (∀ d : Nat → A, (∀ k, adm (d k)) → ∀ k, k ≤ n → guard (history f s d k)) →
      Lasts f adm guard n s
  | 0, _, every => every (fun _ => a₀) (fun _ => h₀) 0 (Nat.le_refl 0)
  | _ + 1, s, every => And.intro (every (fun _ => a₀) (fun _ => h₀) 0 (Nat.zero_le _))
      (fun a admitted => lasts_of_histories h₀ (fun d admissible k bound =>
        Eq.mp (congrArg guard (history_shift f s (Settling.consAct a d) k))
          (every (Settling.consAct a d) (prepend_admissible admitted admissible) (k + 1)
            (Nat.succ_le_succ bound))))

/-- **Given one admissible disturbance, a start lasts `n` steps exactly when every admissible
history from it stays within the guard for its first `n` steps.** -/
theorem lasts_iff_histories {a₀ : A} (h₀ : adm a₀) {n : Nat} {s : S} :
    Lasts f adm guard n s ↔
      ∀ d : Nat → A, (∀ k, adm (d k)) → ∀ k, k ≤ n → guard (history f s d k) :=
  ⟨fun lasts => Lasts.histories lasts, lasts_of_histories h₀⟩

/-- What lasts `n` steps keeps every course of at most `n` admissible steps within the guard. -/
theorem Lasts.trace : ∀ {plan : List A} {n : Nat} {s t : S}, Lasts f adm guard n s →
    Trace (disturbed f adm) s plan t → plan.length ≤ n → guard t
  | [], _, _, _, lasts, .nil _, _ => Lasts.within lasts
  | _ :: _, 0, _, _, _, _, bound => absurd bound (Nat.not_succ_le_zero _)
  | a :: _, n + 1, _, _, lasts, .cons ⟨admitted, moved⟩ tail, bound =>
      Lasts.trace (Eq.mpr (congrArg (Lasts f adm guard n) moved) (And.right lasts a admitted))
        tail (Nat.le_of_succ_le_succ bound)

/-- What no course leaves lasts every horizon. -/
theorem lasts_of_kernel : ∀ (n : Nat) {s : S}, Kernel (disturbed f adm) guard s →
    Lasts f adm guard n s
  | 0, s, kept => kept s (Reach.refl _ s)
  | n + 1, s, kept => And.intro (kept s (Reach.refl _ s))
      (fun a admitted => lasts_of_kernel n (fun t reach =>
        kept t (Reach.trans
          (Reach.of_step (show (disturbed f adm).step s a (f s a) from ⟨admitted, rfl⟩)) reach)))

/-- **What no course leaves is exactly what lasts every horizon**, with no premise. -/
theorem kernel_iff_lasts {s : S} :
    Kernel (disturbed f adm) guard s ↔ ∀ n, Lasts f adm guard n s :=
  ⟨fun kept n => lasts_of_kernel n kept,
   fun every _ ⟨plan, path⟩ => Lasts.trace (every plan.length) path (Nat.le_refl _)⟩

/-! ### Guarded histories up to a horizon -/

/-- A history within the guard up to `n` agrees with its guarded history at `n`. -/
theorem guarded_agrees [DecidablePred guard] {s : S} {d : Nat → A} : ∀ {n : Nat},
    (∀ k, k ≤ n → guard (history f s d k)) →
      guardedHistory f guard s d n = some (history f s d n)
  | 0, _ => rfl
  | n + 1, within => (congrArg (guardedStep f guard (d n))
      (guarded_agrees (fun k bound => within k (Nat.le_succ_of_le bound)))).trans
      (step_of_ready ⟨within n (Nat.le_succ n), within (n + 1) (Nat.le_refl _)⟩)

/-- A guarded history that goes on at `n + 1` is the history there, and the history stayed
within the guard up to `n + 1`. -/
theorem guarded_within [DecidablePred guard] {s : S} {d : Nat → A} : ∀ {n : Nat} {t : S},
    guardedHistory f guard s d (n + 1) = some t →
      t = history f s d (n + 1) ∧ ∀ k, k ≤ n + 1 → guard (history f s d k)
  | 0, t, moved => by
    have ready : guard s ∧ guard (f s (d 0)) := ready_of_step moved
    have next : t = f s (d 0) := by
      change (if guard s ∧ guard (f s (d 0)) then some (f s (d 0)) else none) = some t at moved
      rw [if_pos ready] at moved
      exact (Option.some.inj moved).symm
    exact ⟨next, fun k bound => match k, bound with
      | 0, _ => ready.1
      | 1, _ => ready.2
      | _ + 2, bound => absurd (Nat.le_of_succ_le_succ bound) (Nat.not_succ_le_zero _)⟩
  | n + 1, t, moved => by
    change guardedStep f guard (d (n + 1)) (guardedHistory f guard s d (n + 1)) = some t at moved
    cases prior : guardedHistory f guard s d (n + 1) with
    | none =>
      rw [prior] at moved
      exact absurd moved ListTests.none_ne_some
    | some u =>
      rw [prior] at moved
      have earlier := guarded_within prior
      have ready : guard u ∧ guard (f u (d (n + 1))) := ready_of_step moved
      have next : t = f u (d (n + 1)) := by
        change (if guard u ∧ guard (f u (d (n + 1))) then some (f u (d (n + 1))) else none)
          = some t at moved
        rw [if_pos ready] at moved
        exact (Option.some.inj moved).symm
      have same : u = history f s d (n + 1) := earlier.1
      subst same
      exact ⟨next, fun k bound => match Nat.eq_or_lt_of_le bound with
        | .inl at_end => Eq.mpr (congrArg (fun j => guard (history f s d j)) at_end) ready.2
        | .inr before => earlier.2 k (Nat.le_of_lt_succ before)⟩

/-- **From within the guard, a guarded history agrees with the history at `n` exactly when the
history stays within the guard up to `n`.** -/
theorem guarded_upto_iff [DecidablePred guard] {s : S} {d : Nat → A} (start : guard s)
    {n : Nat} :
    guardedHistory f guard s d n = some (history f s d n) ↔
      ∀ k, k ≤ n → guard (history f s d k) :=
  ⟨fun agree => match n, agree with
    | 0, _ => fun k bound => match k, bound with
      | 0, _ => start
      | _ + 1, bound => absurd bound (Nat.not_succ_le_zero _)
    | _ + 1, agree => (guarded_within agree).2,
   guarded_agrees⟩

/-- **From within the guard, a guarded history stops by `n` exactly when the history leaves the
guard by `n`.** -/
theorem guarded_none_iff [DecidablePred guard] {s : S} {d : Nat → A} (start : guard s)
    {n : Nat} :
    guardedHistory f guard s d n = none ↔ ¬ ∀ k, k ≤ n → guard (history f s d k) :=
  ⟨fun stopped within => ListTests.none_ne_some (stopped.symm.trans (guarded_agrees within)),
   fun leaves => by
    cases going : guardedHistory f guard s d n with
    | none => rfl
    | some t =>
      cases n with
      | zero => exact absurd (fun k bound => match k, bound with
          | 0, _ => start
          | _ + 1, bound => absurd bound (Nat.not_succ_le_zero _)) leaves
      | succ n => exact absurd (guarded_within going).2 leaves⟩

/-! ## Exhaustion -/

/-- **Along every admissible history within the guard for its first `n` steps, a drained family
holds the start at level `n`.** -/
theorem Drains.along {L : Nat → S → Prop} (drains : Drains f adm guard L) :
    ∀ (n : Nat) (s : S) (d : Nat → A), (∀ k, adm (d k)) →
      (∀ k, k ≤ n → guard (history f s d k)) → L n s
  | 0, s, _, _, within => drains.base s (within 0 (Nat.le_refl 0))
  | n + 1, s, d, admissible, within =>
      drains.rises n s (d 0) (within 0 (Nat.zero_le _)) (admissible 0)
        (Drains.along drains n (f s (d 0)) (fun k => d (k + 1)) (fun k => admissible (k + 1))
          (fun k bound => Eq.mp (congrArg guard (history_shift f s d k))
            (within (k + 1) (Nat.succ_le_succ bound))))

/-- **Exhaustion**: a start below level `n` of a drained family leaves the guard within `n`
steps on every admissible history. -/
theorem Drains.leaves {L : Nat → S → Prop} (drains : Drains f adm guard L) {n : Nat} {s : S}
    (below : ¬ L n s) (d : Nat → A) (admissible : ∀ k, adm (d k)) :
    ¬ ∀ k, k ≤ n → guard (history f s d k) :=
  fun within => below (Drains.along drains n s d admissible within)

/-- Given one admissible disturbance, a drained family is necessary. -/
theorem Drains.necessary {L : Nat → S → Prop} (drains : Drains f adm guard L) {a₀ : A}
    (h₀ : adm a₀) : Necessary f adm guard L :=
  ⟨drains.base, fun k x held next => drains.rises k x a₀ held h₀ (next a₀ h₀)⟩

/-! ### Being at a level does not suffice -/

namespace Collapse

/-- Every step goes to `false`. -/
def step (_ : Bool) (_ : Unit) : Bool := false

/-- The family "is `true`" is drained for the guard "is `true`" and holds `true` at level `1`,
yet `true` does not last one step. -/
theorem level_not_lasting :
    Drains step (fun _ => True) (fun b => b = true) (fun _ b => b = true) ∧
      (fun (_ : Nat) (b : Bool) => b = true) 1 true ∧
      ¬ Lasts step (fun _ => True) (fun b => b = true) 1 true :=
  ⟨⟨fun _ held => held, fun _ _ _ _ _ next => Bool.noConfusion next⟩, rfl,
   fun lasts => Bool.noConfusion (And.right lasts () trivial)⟩

end Collapse

/-! ### Growth bounded by a monotone map -/

section Growth

variable {V : Type w} {rel : V → V → Prop} {g : V → V}

/-- The orbit of a pair under the map applied to both is the pair of orbits. -/
theorem orbit_pair (a b : V) :
    ∀ n, Law.orbit (fun p : V × V => (g p.1, g p.2)) (a, b) n = (Law.orbit g a n, Law.orbit g b n)
  | 0 => rfl
  | n + 1 => congrArg (fun p : V × V => (g p.1, g p.2)) (orbit_pair a b n)

/-- A monotone map keeps the order along its orbits: the region of ordered pairs is closed under
the map applied to both (`mono`), so the orbit of an ordered pair stays in it (`Invariant.reach`,
the closure law), and that orbit is the pair of orbits (`orbit_pair`). -/
theorem orbit_mono (mono : ∀ a b, rel a b → rel (g a) (g b)) {a b : V} (below : rel a b) :
    ∀ n, rel (Law.orbit g a n) (Law.orbit g b n) := fun n =>
  Eq.subst (motive := fun p : V × V => rel p.1 p.2) (orbit_pair a b n)
    (Eq.subst (motive := fun m => rel (Law.orbit (fun p : V × V => (g p.1, g p.2)) (a, b) m).1
        (Law.orbit (fun p : V × V => (g p.1, g p.2)) (a, b) m).2) (Nat.zero_add n)
      (Invariant.reach (P := Law.process (fun p : V × V => (g p.1, g p.2)))
        (I := fun p => rel p.1 p.2)
        (fun p _ _ stepped held => Eq.subst (motive := fun q : V × V => rel q.1 q.2) stepped.symm
          (mono p.1 p.2 held))
        ((Law.run (fun p : V × V => (g p.1, g p.2)) (a, b)).reach 0 n) below))

/-- **Growth bounded by a monotone map stays below the map's orbit.** -/
theorem below_orbit (trans : ∀ a b c, rel a b → rel b c → rel a c)
    (mono : ∀ a b, rel a b → rel (g a) (g b)) {x : Nat → V} {v : V} (start : rel (x 0) v)
    (grows : ∀ n, rel (x (n + 1)) (g (x n))) : ∀ n, rel (x n) (Law.orbit g v n)
  | 0 => start
  | n + 1 => trans _ _ _ (grows n) (mono _ _ (below_orbit trans mono start grows n))

/-- **The orbit is the worst growth**: every sequence starting at or below `v` whose growth `g`
bounds stays at or below `θ` for its first `n` steps exactly when the orbit of `v` does. -/
theorem stays_below_iff (refl : ∀ a, rel a a) (trans : ∀ a b c, rel a b → rel b c → rel a c)
    (mono : ∀ a b, rel a b → rel (g a) (g b)) {v θ : V} {n : Nat} :
    (∀ x : Nat → V, rel (x 0) v → (∀ k, rel (x (k + 1)) (g (x k))) →
        ∀ k, k ≤ n → rel (x k) θ) ↔
      ∀ k, k ≤ n → rel (Law.orbit g v k) θ :=
  ⟨fun every => every (Law.orbit g v) (refl v) (fun _ => refl _),
   fun bound _ start grows k before =>
    trans _ _ _ (below_orbit trans mono start grows k) (bound k before)⟩

/-- Where a quantity `q` grows at most by a monotone `g` on every admissible step from a region,
a configuration of the region whose quantity's orbit is at or below `θ` at `k + 1` steps goes,
after an admissible step, to one whose quantity's orbit is at or below `θ` at `k` steps. -/
theorem small_descends (trans : ∀ a b c, rel a b → rel b c → rel a c)
    (mono : ∀ a b, rel a b → rel (g a) (g b)) {R : S → Prop} {q : S → V}
    (grows : ∀ x a, adm a → R x → rel (q (f x a)) (g (q x))) {θ : V} {k : Nat} {x : S} {a : A}
    (admitted : adm a) (region : R x) (small : rel (Law.orbit g (q x) (k + 1)) θ) :
    rel (Law.orbit g (q (f x a)) k) θ :=
  trans _ _ _ (orbit_mono mono (grows x a admitted region) k)
    (Eq.mp (congrArg (fun y => rel y θ) (Law.orbit_shift g (q x) k)) small)

/-- **Exhaustion by bounded growth.** Let every admissible step keep a region, and bound the
growth of a quantity `q` there by a monotone `g`. Let within the guard be level `0`, and let an
admissible step from a configuration of the region within the guard, whose quantity's orbit is
at or below `θ` at `k + 1` steps, lower the level by one: reaching level `k` means having had level
`k + 1`. Then from a start in the region whose quantity's orbit is at or below `θ` at `n` steps
and which is not at level `n`, every admissible history leaves the guard within `n` steps. -/
theorem exhausts (trans : ∀ a b c, rel a b → rel b c → rel a c)
    (mono : ∀ a b, rel a b → rel (g a) (g b)) {R : S → Prop} {q : S → V} {θ : V}
    {level : Nat → S → Prop}
    (kept : ∀ x a, adm a → R x → R (f x a))
    (grows : ∀ x a, adm a → R x → rel (q (f x a)) (g (q x)))
    (base : ∀ x, guard x → level 0 x)
    (lowers : ∀ k x a, R x → guard x → adm a → rel (Law.orbit g (q x) (k + 1)) θ →
      level k (f x a) → level (k + 1) x)
    {n : Nat} {s : S} (region : R s) (small : rel (Law.orbit g (q s) n) θ)
    (short : ¬ level n s) (d : Nat → A) (admissible : ∀ k, adm (d k)) :
    ¬ ∀ k, k ≤ n → guard (history f s d k) :=
  Drains.leaves (f := f) (adm := adm) (guard := guard)
    (L := fun k x => R x → rel (Law.orbit g (q x) k) θ → level k x)
    ⟨fun x held _ _ => base x held,
     fun k x a held admitted next region' small' =>
       lowers k x a region' held admitted small'
         (next (kept x a admitted region')
           (small_descends trans mono grows admitted region' small'))⟩
    (fun at_level => short (at_level region small)) d admissible

end Growth

/-! ## Never reaching -/

section Reaching

variable {next : S → S} {target : S → Prop}

/-- Every configuration of the orbit of a member of a closed set is in the set. -/
theorem closed_orbit {K : S → Prop} (closed : ∀ x, K x → K (next x)) {s : S} (held : K s) :
    ∀ n, K (Law.orbit next s n)
  | 0 => held
  | n + 1 => closed _ (closed_orbit closed held n)

/-- **A determined law's orbit never reaches a target exactly when some set containing the start
avoids the target and is closed under the law.** -/
theorem avoids_iff_closed {s : S} :
    (∀ n, ¬ target (Law.orbit next s n)) ↔
      ∃ K : S → Prop, K s ∧ (∀ x, K x → ¬ target x) ∧ ∀ x, K x → K (next x) :=
  ⟨fun avoids => ⟨fun x => ∀ n, ¬ target (Law.orbit next x n), avoids, fun _ held => held 0,
    fun x held n =>
      Eq.mp (congrArg (fun y => ¬ target y) (Law.orbit_shift next x n)) (held (n + 1))⟩,
   fun ⟨_, held, avoid, closed⟩ n => avoid _ (closed_orbit closed held n)⟩

/-- A determined law as a law of change under one disturbance. -/
def determined (next : S → S) (x : S) (_ : Unit) : S := next x

theorem orbit_eq_history (next : S → S) (s : S) (d : Nat → Unit) :
    ∀ n, Law.orbit next s n = history (determined next) s d n
  | 0 => rfl
  | n + 1 => congrArg next (orbit_eq_history next s d n)

/-- **Never reaching a target is never leaving its complement**: the orbit never reaches the
target exactly when the start is in the invariance kernel of the target's complement. -/
theorem avoids_iff_kernel {s : S} :
    (∀ n, ¬ target (Law.orbit next s n)) ↔
      Kernel (disturbed (determined next) (fun _ => True)) (fun x => ¬ target x) s :=
  (⟨fun avoids d _ n =>
      Eq.mp (congrArg (fun y => ¬ target y) (orbit_eq_history next s d n)) (avoids n),
    fun every n =>
      Eq.mpr (congrArg (fun y => ¬ target y) (orbit_eq_history next s (fun _ => ()) n))
        (every (fun _ => ()) (fun _ => trivial) n)⟩ :
      (∀ n, ¬ target (Law.orbit next s n)) ↔
        ∀ d : Nat → Unit, (∀ n, (fun _ : Unit => True) (d n)) →
          ∀ n, (fun x => ¬ target x) (history (determined next) s d n)).trans
    (never_leaves_iff_kernel (f := determined next) (adm := fun _ => True)
      (guard := fun x => ¬ target x) (s := s) (a₀ := ()) trivial)

/-- **Some seed never reaches the target exactly when some set closed under the law and avoiding
the target contains a seed.** -/
theorem some_avoids_iff {seed : S → Prop} :
    (∃ s, seed s ∧ ∀ n, ¬ target (Law.orbit next s n)) ↔
      ∃ K : S → Prop, (∃ s, seed s ∧ K s) ∧ (∀ x, K x → ¬ target x) ∧
        ∀ x, K x → K (next x) :=
  ⟨fun ⟨s, seeded, avoids⟩ => match avoids_iff_closed.mp avoids with
    | ⟨K, held, avoid, closed⟩ => ⟨K, ⟨s, seeded, held⟩, avoid, closed⟩,
   fun ⟨K, ⟨s, seeded, held⟩, avoid, closed⟩ =>
    ⟨s, seeded, avoids_iff_closed.mpr ⟨K, held, avoid, closed⟩⟩⟩

/-- **No seed avoids the target exactly when no set closed under the law and avoiding the target
contains a seed.** Read with excluded middle, the left side says every seed reaches the
target. -/
theorem none_avoid_iff {seed : S → Prop} :
    (∀ s, seed s → ¬ ∀ n, ¬ target (Law.orbit next s n)) ↔
      ¬ ∃ K : S → Prop, (∃ s, seed s ∧ K s) ∧ (∀ x, K x → ¬ target x) ∧
        ∀ x, K x → K (next x) :=
  ⟨fun none_avoid found => match some_avoids_iff.mpr found with
    | ⟨s, seeded, avoids⟩ => none_avoid s seeded avoids,
   fun none_found s seeded avoids => none_found (some_avoids_iff.mp ⟨s, seeded, avoids⟩)⟩

/-- Reaching the target from every seed rules out every set closed under the law and avoiding
the target that contains a seed. -/
theorem reaches_excludes {seed : S → Prop}
    (reaches : ∀ s, seed s → ∃ n, target (Law.orbit next s n)) :
    ¬ ∃ K : S → Prop, (∃ s, seed s ∧ K s) ∧ (∀ x, K x → ¬ target x) ∧
      ∀ x, K x → K (next x) :=
  none_avoid_iff.mp (fun s seeded avoids => match reaches s seeded with
    | ⟨n, reached⟩ => avoids n reached)

/-- **A fixed configuration outside the target never reaches it**: it is a closed set by
itself. -/
theorem fixed_avoids {x : S} (fixed : next x = x) (outside : ¬ target x) :
    ∀ n, ¬ target (Law.orbit next x n) :=
  avoids_iff_closed.mpr ⟨fun y => y = x, rfl,
    fun _ same => Eq.mpr (congrArg (fun z => ¬ target z) same) outside,
    fun _ same => Eq.mpr (congrArg (fun z => next z = x) same) fixed⟩

end Reaching

/-! ## Reaching a target -/

section Reaches

variable {target : S → Prop}

/-- `Reaches f adm target n s`: `s` is in the target, or `n` steps remain and every admissible
disturbance takes `s` to a configuration that reaches the target within one step fewer. -/
def Reaches (f : S → A → S) (adm : A → Prop) (target : S → Prop) : Nat → S → Prop
  | 0, s => target s
  | n + 1, s => target s ∨ ∀ a, adm a → Reaches f adm target n (f s a)

/-- A **funnel** into a target: level `0` lies in the target, and a configuration at level
`k + 1` is in the target or every admissible disturbance takes it to level `k`. -/
structure Funnel (f : S → A → S) (adm : A → Prop) (target : S → Prop) (F : Nat → S → Prop) :
    Prop where
  base : ∀ x, F 0 x → target x
  descends : ∀ k x, F (k + 1) x → target x ∨ ∀ a, adm a → F k (f x a)

/-- A **basin** of a target: the target lies at every level, and a configuration that every
admissible disturbance takes to level `k` is at level `k + 1`. -/
structure Basin (f : S → A → S) (adm : A → Prop) (target : S → Prop) (L : Nat → S → Prop) :
    Prop where
  holds : ∀ k x, target x → L k x
  gathers : ∀ k x, (∀ a, adm a → L k (f x a)) → L (k + 1) x

/-- **Every funnel reaches**: a start at level `n` of a funnel reaches the target within `n`
steps. -/
theorem Funnel.reaches {F : Nat → S → Prop} (funnel : Funnel f adm target F) :
    ∀ (n : Nat) (s : S), F n s → Reaches f adm target n s
  | 0, s, held => funnel.base s held
  | n + 1, s, held => match funnel.descends n s held with
    | .inl inside => .inl inside
    | .inr next => .inr (fun a admitted => Funnel.reaches funnel n (f s a) (next a admitted))

/-- **`Reaches` is a funnel.** -/
theorem reaches_funnel : Funnel f adm target (Reaches f adm target) :=
  ⟨fun _ held => held, fun _ _ held => held⟩

/-- **The reaching law.** A start reaches the target within `n` steps on every admissible
disturbance exactly when some funnel holds it at level `n`. -/
theorem reaches_iff_funnel {n : Nat} {s : S} :
    Reaches f adm target n s ↔ ∃ F : Nat → S → Prop, F n s ∧ Funnel f adm target F :=
  ⟨fun reaches => ⟨Reaches f adm target, reaches, reaches_funnel⟩,
   fun ⟨_, held, funnel⟩ => funnel.reaches n s held⟩

/-- What is in the target reaches it within every number of steps. -/
theorem Reaches.of_target : ∀ (n : Nat) {s : S}, target s → Reaches f adm target n s
  | 0, _, inside => inside
  | _ + 1, _, inside => .inl inside

/-- **Every basin holds what reaches.** -/
theorem Basin.of_reaches {L : Nat → S → Prop} (basin : Basin f adm target L) :
    ∀ (n : Nat) (s : S), Reaches f adm target n s → L n s
  | 0, s, inside => basin.holds 0 s inside
  | n + 1, s, .inl inside => basin.holds (n + 1) s inside
  | n + 1, s, .inr next =>
      basin.gathers n s (fun a admitted => Basin.of_reaches basin n (f s a) (next a admitted))

/-- **`Reaches` is a basin.** -/
theorem reaches_basin : Basin f adm target (Reaches f adm target) :=
  ⟨fun k _ inside => Reaches.of_target k inside, fun _ _ next => .inr next⟩

/-- **A start reaches the target within `n` steps exactly when every basin holds it at level
`n`.** `Reaches` is the largest funnel and the least basin. -/
theorem reaches_iff_basin {n : Nat} {s : S} :
    Reaches f adm target n s ↔ ∀ L : Nat → S → Prop, Basin f adm target L → L n s :=
  ⟨fun reaches _ basin => basin.of_reaches n s reaches,
   fun every => every (Reaches f adm target) reaches_basin⟩

/-- **A family that is both a funnel and a basin is exactly reaching.** -/
theorem reaches_iff_of_exact {C : Nat → S → Prop} (funnel : Funnel f adm target C)
    (basin : Basin f adm target C) (n : Nat) (s : S) : Reaches f adm target n s ↔ C n s :=
  ⟨basin.of_reaches n s, funnel.reaches n s⟩

/-- What reaches within `n` steps reaches within `n + 1`. -/
theorem Reaches.succ : ∀ {n : Nat} {s : S}, Reaches f adm target n s →
    Reaches f adm target (n + 1) s
  | 0, _, inside => .inl inside
  | _ + 1, _, .inl inside => .inl inside
  | _ + 1, _, .inr next => .inr (fun a admitted => Reaches.succ (next a admitted))

/-- What reaches within `n` steps reaches within `n + j`. -/
theorem Reaches.add {n : Nat} {s : S} (reaches : Reaches f adm target n s) :
    ∀ j, Reaches f adm target (n + j) s
  | 0 => reaches
  | j + 1 => Reaches.succ (Reaches.add reaches j)

/-- What reaches within `n` steps reaches within every larger number. -/
theorem Reaches.mono {n m : Nat} {s : S} (reaches : Reaches f adm target n s) (le : n ≤ m) :
    Reaches f adm target m s := by
  induction le with
  | refl => exact reaches
  | step _ before => exact Reaches.succ before

/-- **Reaching composes.** Where a start reaches a region within `m` steps and every
configuration of the region reaches the target within `k`, the start reaches the target within
`k + m`. -/
theorem Reaches.trans {B : S → Prop} {k : Nat} (onward : ∀ x, B x → Reaches f adm target k x) :
    ∀ {m : Nat} {s : S}, Reaches f adm B m s → Reaches f adm target (k + m) s
  | 0, s, inside => onward s inside
  | m + 1, s, .inl inside => Reaches.add (onward s inside) (m + 1)
  | _ + 1, _, .inr next => .inr (fun a admitted => Reaches.trans onward (next a admitted))

/-! ### Histories -/

/-- **What reaches the target within `n` steps meets it within the first `n` steps of every
admissible history.** -/
theorem Reaches.histories : ∀ {n : Nat} {s : S}, Reaches f adm target n s →
    ∀ d : Nat → A, (∀ k, adm (d k)) → ∃ k, k ≤ n ∧ target (history f s d k)
  | 0, _, inside, _, _ => ⟨0, Nat.le_refl 0, inside⟩
  | _ + 1, _, .inl inside, _, _ => ⟨0, Nat.zero_le _, inside⟩
  | _ + 1, s, .inr next, d, admissible =>
    match Reaches.histories (next (d 0) (admissible 0)) (fun k => d (k + 1))
        (fun k => admissible (k + 1)) with
    | ⟨k, bound, inside⟩ => ⟨k + 1, Nat.succ_le_succ bound,
        Eq.mpr (congrArg target (history_shift f s d k)) inside⟩

/-- Given one admissible disturbance and a decided target, what meets the target within the
first `n` steps of every admissible history reaches it within `n` steps. -/
theorem reaches_of_histories [DecidablePred target] {a₀ : A} (h₀ : adm a₀) :
    ∀ {n : Nat} {s : S},
      (∀ d : Nat → A, (∀ k, adm (d k)) → ∃ k, k ≤ n ∧ target (history f s d k)) →
        Reaches f adm target n s
  | 0, _, every => match every (fun _ => a₀) (fun _ => h₀) with
    | ⟨0, _, inside⟩ => inside
    | ⟨_ + 1, bound, _⟩ => absurd bound (Nat.not_succ_le_zero _)
  | _ + 1, s, every =>
    if inside : target s then .inl inside else
    .inr (fun a admitted => reaches_of_histories h₀ (fun d admissible =>
      match every (Settling.consAct a d) (prepend_admissible admitted admissible) with
      | ⟨0, _, first⟩ => absurd first inside
      | ⟨k + 1, bound, later⟩ => ⟨k, Nat.le_of_succ_le_succ bound,
          Eq.mp (congrArg target (history_shift f s (Settling.consAct a d) k)) later⟩))

/-- **Given one admissible disturbance and a decided target, a start reaches the target within
`n` steps exactly when every admissible history meets it within its first `n` steps.**
`Search.histories_need_decision` shows that the direction from histories needs a decision. -/
theorem reaches_iff_histories [DecidablePred target] {a₀ : A} (h₀ : adm a₀) {n : Nat} {s : S} :
    Reaches f adm target n s ↔
      ∀ d : Nat → A, (∀ k, adm (d k)) → ∃ k, k ≤ n ∧ target (history f s d k) :=
  ⟨fun reaches => Reaches.histories reaches, reaches_of_histories h₀⟩

/-- **Reaching and lasting outside the target exclude each other** where some disturbance is
admissible. -/
theorem Reaches.not_lasts {a₀ : A} (h₀ : adm a₀) : ∀ {n : Nat} {s : S},
    Reaches f adm target n s → ¬ Lasts f adm (fun x => ¬ target x) n s
  | 0, _, inside, lasts => lasts inside
  | _ + 1, _, .inl inside, lasts => And.left lasts inside
  | _ + 1, _, .inr next, lasts => Reaches.not_lasts h₀ (next a₀ h₀) (And.right lasts a₀ h₀)

/-! ### A numeric variant -/

/-- A **variant** for reaching within `n`: a level in `Nat` such that a configuration at a level
at most `n` is in the target, or is at a positive level and every admissible disturbance takes
it to a lower one. -/
def Variant (f : S → A → S) (adm : A → Prop) (target : S → Prop) (n : Nat) (V : S → Nat) :
    Prop :=
  ∀ x, V x ≤ n → target x ∨ (0 < V x ∧ ∀ a, adm a → V (f x a) < V x)

/-- **A variant gives a funnel**: the configurations at a level at most `k` and at most `n`. -/
theorem Variant.funnel {n : Nat} {V : S → Nat} (variant : Variant f adm target n V) :
    Funnel f adm target (fun k x => V x ≤ k ∧ V x ≤ n) :=
  ⟨fun x ⟨low, bound⟩ => match variant x bound with
    | .inl inside => inside
    | .inr ⟨pos, _⟩ => absurd (Nat.lt_of_lt_of_le pos low) (Nat.lt_irrefl 0),
   fun _ x ⟨low, bound⟩ => match variant x bound with
    | .inl inside => .inl inside
    | .inr ⟨_, lowers⟩ => .inr (fun a admitted =>
        ⟨Nat.le_of_lt_succ (Nat.lt_of_lt_of_le (lowers a admitted) low),
         Nat.le_trans (Nat.le_of_lt (lowers a admitted)) bound⟩)⟩

/-- **A variant at most `n` at the start reaches within `n` steps.** -/
theorem Variant.reaches {n : Nat} {V : S → Nat} (variant : Variant f adm target n V) {s : S}
    (start : V s ≤ n) : Reaches f adm target n s :=
  variant.funnel.reaches n s ⟨start, start⟩

/-! ### A determined law -/

section Determined

variable {next : S → S}

/-- **For a determined law, reaching within `n` steps is meeting the target on the orbit within
`n` steps**, with no premise. -/
theorem reaches_iff_orbit : ∀ {n : Nat} {s : S},
    Reaches (determined next) (fun _ => True) target n s ↔
      ∃ k, k ≤ n ∧ target (Law.orbit next s k)
  | 0, _ => ⟨fun inside => ⟨0, Nat.le_refl 0, inside⟩, fun found => match found with
      | ⟨0, _, inside⟩ => inside
      | ⟨_ + 1, bound, _⟩ => absurd bound (Nat.not_succ_le_zero _)⟩
  | _ + 1, s => ⟨fun reaches => match reaches with
      | .inl inside => ⟨0, Nat.zero_le _, inside⟩
      | .inr onward => match reaches_iff_orbit.mp (onward () trivial) with
        | ⟨k, bound, inside⟩ => ⟨k + 1, Nat.succ_le_succ bound,
            Eq.mpr (congrArg target (Law.orbit_shift next s k)) inside⟩,
     fun found => match found with
      | ⟨0, _, inside⟩ => .inl inside
      | ⟨k + 1, bound, inside⟩ => .inr (fun _ _ => reaches_iff_orbit.mpr
          ⟨k, Nat.le_of_succ_le_succ bound,
            Eq.mp (congrArg target (Law.orbit_shift next s k)) inside⟩)⟩

/-- **The reaching law for a determined law.** The orbit meets the target within `n` steps
exactly when some funnel holds the start at level `n`: level `0` lies in the target, and a
configuration at level `k + 1` is in the target or its successor is at level `k`. No decision
of the target is used. -/
theorem orbit_reaches_iff_funnel {n : Nat} {s : S} :
    (∃ k, k ≤ n ∧ target (Law.orbit next s k)) ↔
      ∃ F : Nat → S → Prop, F n s ∧ (∀ x, F 0 x → target x) ∧
        ∀ k x, F (k + 1) x → target x ∨ F k (next x) :=
  reaches_iff_orbit.symm.trans (reaches_iff_funnel.trans
    ⟨fun ⟨F, held, funnel⟩ => ⟨F, held, funnel.base, fun k x level =>
      match funnel.descends k x level with
      | .inl inside => .inl inside
      | .inr onward => .inr (onward () trivial)⟩,
     fun ⟨F, held, base, descends⟩ => ⟨F, held, ⟨base, fun k x level =>
      match descends k x level with
      | .inl inside => .inl inside
      | .inr onward => .inr (fun _ _ => onward)⟩⟩⟩)

/-- Steps to the target along the orbit, counted up to `m`: `0` in the target, otherwise one
more than from the successor; `0` once no steps remain. -/
def hitTime (target : S → Prop) [DecidablePred target] (next : S → S) : Nat → S → Nat
  | 0, _ => 0
  | m + 1, x => if target x then 0 else hitTime target next m (next x) + 1

theorem hitTime_succ [DecidablePred target] (m : Nat) (x : S) :
    hitTime target next (m + 1) x = if target x then 0 else hitTime target next m (next x) + 1 :=
  rfl

/-- A count reached below its bound does not change with a larger bound. -/
theorem hitTime_stable [DecidablePred target] : ∀ (m : Nat) (y : S),
    hitTime target next m y < m → hitTime target next (m + 1) y = hitTime target next m y
  | 0, _, lt => absurd lt (Nat.lt_irrefl 0)
  | m + 1, y, lt =>
    if inside : target y then
      (hitTime_succ (m + 1) y).trans
        ((if_pos inside).trans ((hitTime_succ m y).trans (if_pos inside)).symm)
    else
      have counted : hitTime target next (m + 1) y = hitTime target next m (next y) + 1 :=
        (hitTime_succ m y).trans (if_neg inside)
      have lt' : hitTime target next m (next y) + 1 < m + 1 :=
        Eq.mp (congrArg (· < m + 1) counted) lt
      (hitTime_succ (m + 1) y).trans ((if_neg inside).trans
        ((congrArg (· + 1) (hitTime_stable m (next y) (Nat.lt_of_succ_lt_succ lt'))).trans
          counted.symm))

/-- What reaches within `m` steps is counted at most `m` with bound `m + 1`. -/
theorem hitTime_of_reaches [DecidablePred target] : ∀ (m : Nat) (y : S),
    Reaches (determined next) (fun _ => True) target m y → hitTime target next (m + 1) y ≤ m
  | 0, y, inside => Nat.le_of_eq ((hitTime_succ 0 y).trans (if_pos (c := target y) inside))
  | m + 1, y, reaches =>
    if inside : target y then
      Nat.le_trans (Nat.le_of_eq ((hitTime_succ (m + 1) y).trans (if_pos inside))) (Nat.zero_le _)
    else
      Nat.le_trans (Nat.le_of_eq ((hitTime_succ (m + 1) y).trans (if_neg inside)))
        (match reaches with
          | .inl found => absurd found inside
          | .inr onward => Nat.succ_le_succ (hitTime_of_reaches m (next y) (onward () trivial)))

/-- The count with bound `n + 1` lowers along every step from a configuration outside the target
at a level at most `n`. -/
theorem hitTime_lowers [DecidablePred target] (n : Nat) (x : S)
    (low : hitTime target next (n + 1) x ≤ n) :
    target x ∨ hitTime target next (n + 1) (next x) < hitTime target next (n + 1) x :=
  if inside : target x then .inl inside else
    have counted : hitTime target next (n + 1) x = hitTime target next n (next x) + 1 :=
      (hitTime_succ n x).trans (if_neg inside)
    have low' : hitTime target next n (next x) < n := Eq.mp (congrArg (· ≤ n) counted) low
    .inr (Eq.mpr (congrArg (· < hitTime target next (n + 1) x) (hitTime_stable n (next x) low'))
      (Eq.mpr (congrArg (hitTime target next n (next x) < ·) counted) (Nat.lt_succ_self _)))

/-- **The reaching law with a numeric variant.** Where the target is decided, the orbit meets it
within `n` steps exactly when some level in `Nat`, at most `n` at the start, is lowered by every
step from a configuration outside the target at a level at most `n`. The direction from a
variant to reaching uses no decision; `numeric_needs_decision` shows that the other one needs
one. -/
theorem orbit_reaches_iff_variant [DecidablePred target] {n : Nat} {s : S} :
    (∃ k, k ≤ n ∧ target (Law.orbit next s k)) ↔
      ∃ V : S → Nat, V s ≤ n ∧ ∀ x, V x ≤ n → target x ∨ V (next x) < V x :=
  ⟨fun found => ⟨hitTime target next (n + 1),
     hitTime_of_reaches n s (reaches_iff_orbit.mpr found), hitTime_lowers n⟩,
   fun ⟨V, start, lowers⟩ => reaches_iff_orbit.mp
     (Variant.reaches (f := determined next) (adm := fun _ => True) (n := n) (V := V)
       (fun x bound => match lowers x bound with
         | .inl inside => .inl inside
         | .inr lt => .inr ⟨Nat.lt_of_le_of_lt (Nat.zero_le _) lt, fun _ _ => lt⟩) start)⟩

/-- For a determined law and a decided target, what does not last outside the target reaches
it. -/
theorem reaches_of_not_lasts [DecidablePred target] : ∀ {n : Nat} {s : S},
    ¬ Lasts (determined next) (fun _ => True) (fun x => ¬ target x) n s →
      Reaches (determined next) (fun _ => True) target n s
  | 0, s, not_lasts => if inside : target s then inside else absurd inside not_lasts
  | _ + 1, s, not_lasts => if inside : target s then .inl inside else
      .inr (fun _ _ => reaches_of_not_lasts (fun lasts => not_lasts ⟨inside, fun _ _ => lasts⟩))

/-- **For a determined law and a decided target, reaching within `n` steps is not lasting
outside the target for `n` steps.** `dual_needs_decision` shows that the decision is
needed. -/
theorem reaches_iff_not_lasts [DecidablePred target] {n : Nat} {s : S} :
    Reaches (determined next) (fun _ => True) target n s ↔
      ¬ Lasts (determined next) (fun _ => True) (fun x => ¬ target x) n s :=
  ⟨Reaches.not_lasts (a₀ := ()) trivial, reaches_of_not_lasts⟩

end Determined

/-! ### Where a decision is needed -/

/-- **The lasting duality needs a decision.** If not lasting outside every target gave reaching
it, at the start with no step, double negation would be eliminated. -/
theorem dual_needs_decision {next : S → S} {s : S}
    (dual : ∀ target : S → Prop,
      ¬ Lasts (determined next) (fun _ => True) (fun x => ¬ target x) 0 s →
        Reaches (determined next) (fun _ => True) target 0 s)
    (p : Prop) : ¬ ¬ p → p :=
  dual (fun _ => p)

/-- A numeric variant for the law that keeps every configuration, with the target `{s}`, decides
at every configuration whether it is `s`. -/
theorem variant_decides {s : S} {n : Nat} {V : S → Nat} (start : V s ≤ n)
    (lowers : ∀ x, V x ≤ n → x = s ∨ V x < V x) (x : S) : x = s ↔ V x ≤ n :=
  ⟨fun same => Eq.mpr (congrArg (fun y => V y ≤ n) same) start,
   fun low => match lowers x low with
    | .inl same => same
    | .inr lt => absurd lt (Nat.lt_irrefl _)⟩

/-- **The numeric form needs a decision.** If every determined law meeting a target within `n`
steps had a numeric variant, equality of configurations would be decided. -/
theorem numeric_needs_decision
    (numeric : ∀ (next : S → S) (target : S → Prop) (n : Nat) (s : S),
      (∃ k, k ≤ n ∧ target (Law.orbit next s k)) →
        ∃ V : S → Nat, V s ≤ n ∧ ∀ x, V x ≤ n → target x ∨ V (next x) < V x)
    (x y : S) : x = y ∨ ¬ x = y :=
  match numeric (fun z => z) (fun z => z = y) 0 y ⟨0, Nat.le_refl 0, rfl⟩ with
  | ⟨V, start, lowers⟩ =>
    match Nat.decLe (V x) 0 with
    | isTrue low => .inl ((variant_decides start lowers x).mpr low)
    | isFalse high => .inr (fun same => high ((variant_decides start lowers x).mp same))

namespace Search

/-- Before a choice, or after the choice of `a`. -/
def step (_ : Option Nat) (a : Nat) : Option Nat := some a

/-- Before the choice the target is that `g` holds somewhere; after the choice of `a`, that `g`
fails at `a`. -/
def found (g : Nat → Bool) : Option Nat → Prop
  | none => ∃ b, g b = true
  | some a => g a = false

/-- Every history from before the choice meets the target within one step. -/
theorem every_history (g : Nat → Bool) (d : Nat → Nat) (_ : ∀ k, (fun _ => True) (d k)) :
    ∃ k, k ≤ 1 ∧ found g (history step none d k) :=
  match h : g (d 0) with
  | true => ⟨0, Nat.zero_le 1, ⟨d 0, h⟩⟩
  | false => ⟨1, Nat.le_refl 1, h⟩

/-- Reaching within one step from before the choice is the limited principle of omniscience for
`g`. -/
theorem reaches_iff_lpo (g : Nat → Bool) :
    Reaches step (fun _ => True) (found g) 1 none ↔ (∃ b, g b = true) ∨ ∀ a, g a = false :=
  ⟨fun reaches => match reaches with
    | .inl inside => .inl inside
    | .inr onward => .inr (fun a => onward a trivial),
   fun lpo => match lpo with
    | .inl inside => .inl inside
    | .inr never => .inr (fun a _ => never a)⟩

/-- **The histories form needs a decision.** If meeting the target on every admissible history
gave reaching it for this law, the limited principle of omniscience would hold. -/
theorem histories_need_decision
    (converse : ∀ g : Nat → Bool,
      (∀ d : Nat → Nat, (∀ k, (fun _ => True) (d k)) →
          ∃ k, k ≤ 1 ∧ found g (history step none d k)) →
        Reaches step (fun _ => True) (found g) 1 none)
    (g : Nat → Bool) : (∃ b, g b = true) ∨ ∀ a, g a = false :=
  (reaches_iff_lpo g).mp (converse g (every_history g))

end Search

end Reaches

/-! ## Lasting some course: lifting where the process branches finitely

`Lasts` asks every admissible course to stay. Here some course goes on: `Continues P n s` says
that some course of `n` steps starts at `s`, and `Unbounded P s` that courses of every length
do. Whether some course goes on for ever is not decided by the courses of each length: a
configuration stepping to arms of every length has courses of every length, but no successor
does (`Fan.no_unbounded_step`). Where the process branches finitely (`FinitelyBranching`: the
successors of each configuration are listed), the depth reached is decided
(`Continues.decided`). An unbounded configuration then cannot fail to have an unbounded
successor (`Unbounded.step_not_not`), with no premise. That it has one is
`EitherThroughout.list` applied to the listed successors (`Unbounded.step_of_either`), and asked
of every finitely branching process this is exactly `EitherThroughout` (`step_iff_either`;
witness: the two chains of `Chains`). A selection of an unbounded successor wherever there is
one gives a run (`runOf`, `lifting`): the principle and the selection are hypotheses of the law,
never assumed.
-/

section Lifting

/-- Some course of `n` steps starts at `s`. -/
def Continues (P : Process S A) : Nat → S → Prop
  | 0, _ => True
  | n + 1, s => ∃ a t, P.step s a t ∧ Continues P n t

/-- Courses of every length start at `s`. -/
def Unbounded (P : Process S A) (s : S) : Prop :=
  ∀ n, Continues P n s

/-- The process branches finitely: the successors of each configuration are listed. -/
def FinitelyBranching (P : Process S A) : Prop :=
  ∀ s, ∃ l : List S, ∀ t, (∃ a, P.step s a t) ↔ t ∈ l

/-- A course of `n + 1` steps begins one of `n` steps. -/
theorem Continues.down {P : Process S A} : ∀ (n : Nat) (s : S), Continues P (n + 1) s → Continues P n s
  | 0, _, _ => trivial
  | n + 1, _, ⟨a, t, step, onward⟩ => ⟨a, t, step, Continues.down n t onward⟩

/-- **Where the process branches finitely, the depth reached is decided.** -/
theorem Continues.decided {P : Process S A} (branching : FinitelyBranching P) :
    ∀ (n : Nat) (s : S), Decided (Continues P n s)
  | 0, _ => .inl trivial
  | n + 1, s => match branching s with
    | ⟨_, listed⟩ =>
      match Decided.exists_listed (P := fun t => Continues P n t)
          (fun t _ => Continues.decided branching n t) with
      | .inl ⟨t, mem, onward⟩ => match (listed t).mpr mem with
        | ⟨a, step⟩ => .inl ⟨a, t, step, onward⟩
      | .inr refuted => .inr fun ⟨a, t, step, onward⟩ => refuted ⟨t, (listed t).mp ⟨a, step⟩, onward⟩

/-- **Some member of a list holds throughout, up to double negation**, where each step of a
decided decreasing family is met by some member. No principle is used: the goal is a refutation,
so whether the first member fails somewhere may be taken as decided. -/
theorem list_throughout_not_not {β : Type w} {Q : Nat → β → Prop} (decided : ∀ k b, Decided (Q k b))
    (down : ∀ k b, Q (k + 1) b → Q k b) :
    ∀ l : List β, (∀ k, ∃ b, b ∈ l ∧ Q k b) → ¬ ¬ ∃ b, b ∈ l ∧ ∀ k, Q k b
  | [], each => fun _ => match each 0 with
    | ⟨_, mem, _⟩ => nomatch mem
  | b :: l, each => fun refuted => not_not_decided (∃ k, ¬ Q k b) fun failsOrNot => match failsOrNot with
    | .inr never =>
      refuted ⟨b, .head l, fun k => (decided k b).of_not_not fun fails => never ⟨k, fails⟩⟩
    | .inl ⟨k₀, fails⟩ => list_throughout_not_not decided down l
        (fun k => match each (k + k₀) with
          | ⟨c, mem, holds⟩ => match mem_cons_cases mem with
            | .inl same => absurd (holds_below (P := Q) down (Nat.le_add_left k₀ k)
                (Eq.subst (motive := Q (k + k₀)) same holds)) fails
            | .inr mem => ⟨c, mem, holds_below (P := Q) down (Nat.le_add_right k k₀) holds⟩)
        (fun ⟨c, mem, all⟩ => refuted ⟨c, .tail b mem, all⟩)

/-- Where the process branches finitely, the listed successors of an unbounded configuration meet
every depth. -/
theorem Unbounded.successors {P : Process S A} {s : S} (unbounded : Unbounded P s) {l : List S}
    (listed : ∀ t, (∃ a, P.step s a t) ↔ t ∈ l) : ∀ k, ∃ t, t ∈ l ∧ Continues P k t :=
  fun k => match unbounded (k + 1) with
    | ⟨a, t, step, onward⟩ => ⟨t, (listed t).mp ⟨a, step⟩, onward⟩

/-- **An unbounded configuration cannot fail to have an unbounded successor**, where the process
branches finitely. No premise. -/
theorem Unbounded.step_not_not {P : Process S A} (branching : FinitelyBranching P) {s : S}
    (unbounded : Unbounded P s) : ¬ ¬ ∃ t, (∃ a, P.step s a t) ∧ Unbounded P t :=
  match branching s with
  | ⟨l, listed⟩ => fun refuted =>
    list_throughout_not_not (Q := fun k t => Continues P k t)
      (fun k t => Continues.decided branching k t) (fun k t => Continues.down k t) l
      (unbounded.successors listed) (fun ⟨t, mem, all⟩ => refuted ⟨t, (listed t).mpr mem, all⟩)

/-- **An unbounded configuration has an unbounded successor**, where the process branches
finitely, given `EitherThroughout`: the principle applied to the listed successors
(`EitherThroughout.list`). -/
theorem Unbounded.step_of_either (either : EitherThroughout) {P : Process S A}
    (branching : FinitelyBranching P) {s : S} (unbounded : Unbounded P s) :
    ∃ t, (∃ a, P.step s a t) ∧ Unbounded P t :=
  match branching s with
  | ⟨l, listed⟩ =>
    match EitherThroughout.list either (P := fun k t => Continues P k t)
        (fun k t => Continues.decided branching k t) (fun k t => Continues.down k t) l
        (unbounded.successors listed) with
    | ⟨t, mem, all⟩ => ⟨t, (listed t).mpr mem, all⟩

/-- Of finitely many starts with courses of every length among them, one is unbounded, given
`EitherThroughout`. -/
theorem unbounded_start_of_either (either : EitherThroughout) {P : Process S A}
    (branching : FinitelyBranching P) (starts : List S)
    (each : ∀ n, ∃ s, s ∈ starts ∧ Continues P n s) : ∃ s, s ∈ starts ∧ Unbounded P s :=
  EitherThroughout.list either (P := fun k t => Continues P k t)
    (fun k t => Continues.decided branching k t) (fun k t => Continues.down k t) starts each

/-- The configurations along a family, each step taken by a selection that stays in it. -/
def along {P : Process S A} {K : S → Prop} (select : ∀ s, K s → {p : A × S // P.step s p.1 p.2 ∧ K p.2})
    (s : S) (held : K s) : Nat → {x : S // K x}
  | 0 => ⟨s, held⟩
  | n + 1 => ⟨(select (along select s held n).1 (along select s held n).2).1.2,
      (select (along select s held n).1 (along select s held n).2).2.2⟩

/-- **A selection of a step that stays in a family gives a run from each of its members.** -/
def runOf {P : Process S A} {K : S → Prop} (select : ∀ s, K s → {p : A × S // P.step s p.1 p.2 ∧ K p.2})
    (s : S) (held : K s) : Run P :=
  ⟨fun n => (along select s held n).1,
   fun n => (select (along select s held n).1 (along select s held n).2).1.1,
   fun n => (select (along select s held n).1 (along select s held n).2).2.1⟩

theorem runOf_start {P : Process S A} {K : S → Prop}
    (select : ∀ s, K s → {p : A × S // P.step s p.1 p.2 ∧ K p.2}) (s : S) (held : K s) :
    (runOf select s held).state 0 = s :=
  rfl

theorem runOf_within {P : Process S A} {K : S → Prop}
    (select : ∀ s, K s → {p : A × S // P.step s p.1 p.2 ∧ K p.2}) (s : S) (held : K s) (n : Nat) :
    K ((runOf select s held).state n) :=
  (along select s held n).2

/-- **Lifting.** Where the process branches finitely, given `EitherThroughout` and a choice of an
unbounded successor wherever one exists, every unbounded configuration starts a run along
unbounded configurations. -/
theorem lifting (either : EitherThroughout) {P : Process S A} (branching : FinitelyBranching P)
    (choose : ∀ s, (∃ t, (∃ a, P.step s a t) ∧ Unbounded P t) →
      {p : A × S // P.step s p.1 p.2 ∧ Unbounded P p.2})
    {s : S} (unbounded : Unbounded P s) :
    ∃ r : Run P, r.state 0 = s ∧ ∀ n, Unbounded P (r.state n) :=
  ⟨runOf (fun x held => choose x (Unbounded.step_of_either either branching held)) s unbounded, rfl,
   runOf_within _ s unbounded⟩

/-! ### The boundary: two chains -/

namespace TwoChains

variable {α β : Nat → Prop}

/-- The process of `Chains`: `two` steps to the starts of the chains, and the chain on a side
goes on from `n` exactly where its family holds at `n`. -/
def process (α β : Nat → Prop) : Process Chains.Pos Unit :=
  (Chains.frame α β).P

theorem branching (decided : ∀ k, Decided (α k)) (decided' : ∀ k, Decided (β k)) :
    FinitelyBranching (process α β) :=
  fun s => match Chains.outcomes decided decided' s with
    | ⟨l, listed⟩ => ⟨l, fun t => ⟨fun ⟨_, step⟩ => (listed t).mp step, fun mem => ⟨(), (listed t).mpr mem⟩⟩⟩

/-- Where a decreasing family holds at `n + m`, the chain on its side goes on `n` steps from `m`. -/
theorem chain_continues {b : Bool} (down : ∀ k, Chains.Side α β b (k + 1) → Chains.Side α β b k) :
    ∀ (n m : Nat), Chains.Side α β b (n + m) → Continues (process α β) n (.on b m)
  | 0, _, _ => trivial
  | n + 1, m, holds =>
    ⟨(), .on b (m + 1),
     .onward b m (holds_below (P := fun k (_ : Unit) => Chains.Side α β b k) (x := ())
       (fun k _ holds => down k holds) (Nat.le_add_left m (n + 1)) holds),
     chain_continues down n (m + 1) (Eq.subst (motive := Chains.Side α β b) (Nat.succ_add n m) holds)⟩

/-- Where the chain on a side goes on `n + 1` steps from `m`, its family holds at `m + n`. -/
theorem chain_holds {b : Bool} : ∀ (n m : Nat), Continues (process α β) (n + 1) (.on b m) →
    Chains.Side α β b (m + n)
  | 0, _, ⟨_, _, .onward _ _ holds, _⟩ => holds
  | n + 1, m, ⟨_, _, .onward _ _ _, onward⟩ =>
    Eq.subst (motive := Chains.Side α β b) (Nat.succ_add m n) (chain_holds n (m + 1) onward)

/-- Where one of two decreasing families holds at each step, `two` is unbounded. -/
theorem two_unbounded (down : ∀ k, α (k + 1) → α k) (down' : ∀ k, β (k + 1) → β k)
    (each : ∀ k, α k ∨ β k) : Unbounded (process α β) .two
  | 0 => trivial
  | n + 1 => match each n with
    | .inl holds => ⟨(), .on true 0, .twoOn true, chain_continues (b := true) down n 0 holds⟩
    | .inr holds => ⟨(), .on false 0, .twoOn false, chain_continues (b := false) down' n 0 holds⟩

/-- An unbounded chain start has its family holding at every step. -/
theorem side_of_unbounded {b : Bool} (unbounded : Unbounded (process α β) (.on b 0)) (k : Nat) :
    Chains.Side α β b k :=
  Eq.subst (motive := Chains.Side α β b) (Nat.zero_add k) (chain_holds k 0 (unbounded (k + 1)))

end TwoChains

/-- **The boundary.** Asked of every finitely branching process, that an unbounded configuration
has an unbounded successor is exactly `EitherThroughout`. Witness: two decreasing decided
families, one holding at each step, give the two chains of `Chains`, whose fork `two` is
unbounded; an unbounded successor is a chain start whose family holds throughout. -/
theorem step_iff_either :
    (∀ (S A : Type) (P : Process S A), FinitelyBranching P → ∀ s, Unbounded P s →
      ∃ t, (∃ a, P.step s a t) ∧ Unbounded P t) ↔ EitherThroughout :=
  ⟨fun law α β decided decided' down down' each =>
    match law Chains.Pos Unit (TwoChains.process α β) (TwoChains.branching decided decided') .two
        (TwoChains.two_unbounded down down' each) with
    | ⟨_, ⟨_, .twoOn true⟩, unbounded⟩ => .inl (TwoChains.side_of_unbounded (b := true) unbounded)
    | ⟨_, ⟨_, .twoOn false⟩, unbounded⟩ => .inr (TwoChains.side_of_unbounded (b := false) unbounded),
   fun either _ _ _ branching _ unbounded => Unbounded.step_of_either either branching unbounded⟩

/-! ### Without finite branching: the fan -/

namespace Fan

/-- Configurations: the root, and place `k` on the arm of length `n`. -/
inductive Pos where
  | root
  | arm (n k : Nat)

/-- The root steps to the start of every arm; an arm goes on to its end. -/
inductive Step : Pos → Pos → Prop where
  | out (n : Nat) : Step .root (.arm n 0)
  | along (n k : Nat) : k < n → Step (.arm n k) (.arm n (k + 1))

def process : Process Pos Unit :=
  ⟨fun s _ t => Step s t⟩

theorem arm_continues : ∀ (j k n : Nat), k + j ≤ n → Continues process j (.arm n k)
  | 0, _, _, _ => trivial
  | j + 1, k, n, within =>
    ⟨(), .arm n (k + 1), .along n k (Nat.lt_of_le_of_lt (Nat.le_add_right k j) within),
     arm_continues j (k + 1) n (Eq.subst (motive := fun x => x ≤ n) (Nat.succ_add k j).symm within)⟩

theorem arm_bounded : ∀ (j k n : Nat), k ≤ n → Continues process j (.arm n k) → k + j ≤ n
  | 0, _, _, within, _ => within
  | j + 1, k, n, _, ⟨_, _, .along _ _ before, onward⟩ =>
    Eq.subst (motive := fun x => x ≤ n) (Nat.succ_add k j) (arm_bounded j (k + 1) n before onward)

/-- **The root has courses of every length.** -/
theorem root_unbounded : Unbounded process .root
  | 0 => trivial
  | n + 1 => ⟨(), .arm n 0, .out n,
      arm_continues n 0 n (Eq.subst (motive := fun x => x ≤ n) (Nat.zero_add n).symm (Nat.le_refl n))⟩

/-- **No successor of the root is unbounded**: the arm of length `n` has no course of `n + 1`
steps. So courses of every length need not continue one another where the branching is infinite. -/
theorem no_unbounded_step : ¬ ∃ t, (∃ a, process.step .root a t) ∧ Unbounded process t
  | ⟨_, ⟨_, .out n⟩, unbounded⟩ =>
    Nat.lt_irrefl n (Eq.subst (motive := fun x => x ≤ n) (Nat.zero_add (n + 1))
      (arm_bounded (n + 1) 0 n (Nat.zero_le n) (unbounded (n + 1))))

end Fan

end Lifting

end Lasting

end Becoming
