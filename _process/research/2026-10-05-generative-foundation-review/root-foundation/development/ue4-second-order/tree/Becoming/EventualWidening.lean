import Becoming.ContinuedClasses
import Becoming.Regions
import Becoming.Population

/-!
# Eventual widening: widening without end, keeping widening, and comparison in the long run

`Web.Widens` compares two level paths of one web at every step: one widens the other where at
every step it admits everything the other admits, and at some step more. A course wider over the
first steps and a course that keeps opening later are then mixed, and over any first stretch the
first widens the second. This module states, with no premise beyond the representation, what
widening says about the long run: a comparison by the steps from some step on, and a course whose
range keeps widening along it. No ethical predicate, ranking or axiom occurs; whether either
comparison is better is not stated.

* **The comparison in the long run.** From step `T` on `l` includes `l'` (`Web.IncludesFrom`);
  `l` exceeds `l'` at arbitrarily late steps (`Web.ExceedsLate`). `l` *widens `l'` without end*
  where it includes it at every step and exceeds it at arbitrarily late steps
  (`Web.WidensWithoutEnd`), and *eventually widens* it where it includes it from some step on and
  exceeds it at arbitrarily late steps (`Web.EventuallyWidens`). Widening without end is widening
  (`WidensWithoutEnd.widens`) and eventual widening (`WidensWithoutEnd.eventually`). Eventual
  widening is irreflexive, transitive and one-way (`EventuallyWidens.irrefl`,
  `EventuallyWidens.trans`, `EventuallyWidens.not_reverse`).
* **It never runs against widening.** A level path included by another at every step does not
  eventually widen it (`EventuallyWidens.not_included`), so eventual widening never reverses
  widening or keeping the same (`Widens.not_eventually_reversed`). Inclusion composes with it on
  either side (`Includes.trans_eventually`, `EventuallyWidens.trans_includes`), so widening or
  eventual widening (`Web.WidensOrEventually`) is irreflexive and transitive
  (`WidensOrEventually.irrefl`, `WidensOrEventually.trans`): the two can be held together.
* **No first stretch decides it.** Whatever a level path does up to a step `h`, following `l'`
  after `h` leaves no eventual widening of `l'` (`not_eventually_of_splice`), and where some level
  path eventually widens `l'`, following it after `h` gives one (`eventually_of_splice`): no
  finite prefix verifies or refutes eventual widening.
* **A course whose range keeps widening.** Along a continuation `R` (`Web.IncludesAcross`,
  `Web.ExceedsAcross`), from `T` on nothing admitted is lost across any stretch
  (`Web.HoldsFrom`) and after every step something is admitted that continues nothing admitted
  before (`Web.KeepsOpening`); both together are *keeping widening* (`Web.KeepsWidening`). It
  holds from every later step (`KeepsWidening.later`) and is unchanged by every re-identification
  carrying the continuation (`keepsWidening_reidentify`).
* **Over a listed type, no range read by name keeps widening.** Where a list holds every
  formation, no level path keeps widening by name from any step (`KeepsWidening.not_listed`):
  widening without end, read by name, needs formations without end.
* **Keeping widening outlasts a range that settles.** A course keeping widening by name eventually
  widens every course that it includes from some step on and that from some step admits, at each
  step, exactly what it admitted then (`Web.SettlesFrom`, `KeepsWidening.eventually_widens`);
  every course admitting something at arbitrarily late steps eventually widens one that admits
  nothing from some step on (`eventually_of_vanishing`).
* **Witnesses** (`OwnCondition`: each formation requires only its own condition, at need one).
  `rising` admits at step `t` the formations up to `t`; `burst` admits formations `0` and `1` at
  step `0` and nothing after; `full` admits everything throughout. Up to step `0` the burst widens
  the rising course (`OwnCondition.burst_widens_now`), over every step the two are mixed
  (`OwnCondition.mixed`), and the rising course eventually widens the burst
  (`OwnCondition.rising_eventually_widens_burst`), keeps widening by name
  (`OwnCondition.rising_keeps_widening`) where the burst does not
  (`OwnCondition.burst_not_keeps_widening`): plain widening and eventual widening disagree
  (`OwnCondition.disagreement`). Keeping widening is not kept by widening: `full` widens `rising`
  and does not keep widening from any step (`OwnCondition.not_monotone`), so no order that ranks
  each course keeping widening above each that does not agrees with widening.
* **What carries a widening.** A flow's range is *opened by the opened* from `T` where every gain
  of support after `T` is given, to a condition the gainer requires, by a supported formation
  taking part that itself gained support after `T`, earlier (`Flow.OpenedByOpened`). On one web
  whose levels are the rising course (`OpeningChain.web`, `OpeningChain.level_rising`), two flows
  balance with only active formations giving and activity needing support: in the relay each
  formation gives the next its unit (`OpeningChain.flow`), and in the other one formation gives
  every unit (`OpeningChain.sun`). The relay's range is opened by the opened
  (`OpeningChain.flow_opened`) and the single giver's is not (`OpeningChain.sun_not_opened`),
  while the levels, and so every admission, are the same (`OpeningChain.carried`): what carries a
  range is invisible to widening.

**Readings (the AI's, for UE4's design note; not adopted).** Eventual widening is the comparison
of courses in the long run, the inclusion form of an overtaking criterion with no discount;
keeping widening is "a range whose widening keeps widening"; opened by the opened is "generation
generating generation" read on support. None ranks: calling any of them better is a premise beyond
C, and the note names it.

**What is not derived.** Which courses an actual unfolding offers; the gain, renewal or number of
givers that keeping widening needs (the note states those laws as next statements); comparisons over
branching courses. The representation commits to discrete steps on one index and natural-number
levels. Every declaration has an empty axiom report (scratch build). No ethical predicate, ranking
or axiom occurs.
-/

namespace Becoming

namespace Web

variable {F F' C : Type}

/-! ## The comparison in the long run -/

section Tails

variable (W : Web F C)

/-- From step `T` on, the level path `l` includes `l'`: at every step from `T` it admits every
formation `l'` admits. -/
def IncludesFrom (T : Nat) (l l' : Nat → C → Nat) : Prop :=
  ∀ t f, T ≤ t → W.Admits (l' t) t f → W.Admits (l t) t f

/-- `l` exceeds `l'` at arbitrarily late steps: after every step, at some step it admits a
formation `l'` does not. -/
def ExceedsLate (l l' : Nat → C → Nat) : Prop :=
  ∀ S, ∃ t f, S ≤ t ∧ W.Admits (l t) t f ∧ ¬ W.Admits (l' t) t f

/-- **Widening without end**: `l` includes `l'` at every step and exceeds it at arbitrarily late
steps. -/
def WidensWithoutEnd (l l' : Nat → C → Nat) : Prop :=
  W.Includes l l' ∧ W.ExceedsLate l l'

/-- **Eventual widening**: from some step on `l` includes `l'`, and it exceeds it at arbitrarily
late steps. -/
def EventuallyWidens (l l' : Nat → C → Nat) : Prop :=
  (∃ T, W.IncludesFrom T l l') ∧ W.ExceedsLate l l'

/-- **Wider up to a step**: up to step `h`, `l` admits every formation `l'` admits, and at some step
up to `h` one it does not. -/
def WidensUpTo (h : Nat) (l l' : Nat → C → Nat) : Prop :=
  (∀ t f, t ≤ h → W.Admits (l' t) t f → W.Admits (l t) t f) ∧
    ∃ t f, t ≤ h ∧ W.Admits (l t) t f ∧ ¬ W.Admits (l' t) t f

/-- Widening, or eventual widening. -/
def WidensOrEventually (l l' : Nat → C → Nat) : Prop :=
  W.Widens l l' ∨ W.EventuallyWidens l l'

end Tails

variable {W : Web F C} {l l' l'' : Nat → C → Nat}

/-- Inclusion at every step is inclusion from every step. -/
theorem Includes.from_ (includes : W.Includes l l') (T : Nat) : W.IncludesFrom T l l' :=
  fun t f _ admitted => includes t f admitted

/-- Inclusion from a step holds from every later step. -/
theorem IncludesFrom.later {T T' : Nat} (later : T ≤ T') (includes : W.IncludesFrom T l l') :
    W.IncludesFrom T' l l' :=
  fun t f from_ admitted => includes t f (Nat.le_trans later from_) admitted

/-- Inclusion from a step composes. -/
theorem IncludesFrom.trans {T T' : Nat} (first : W.IncludesFrom T l l')
    (second : W.IncludesFrom T' l' l'') : W.IncludesFrom (T + T') l l'' :=
  fun t f from_ admitted =>
    first t f (Nat.le_trans (Nat.le_add_right T T') from_)
      (second t f (Nat.le_trans (Nat.le_add_left T' T) from_) admitted)

/-- Exceeding at arbitrarily late steps is exceeding. -/
theorem ExceedsLate.exceeds (late : W.ExceedsLate l l') : W.Exceeds l l' :=
  match late 0 with
  | ⟨t, f, _, admitted, not⟩ => ⟨t, f, admitted, not⟩

/-- A level path that includes another at every step is not exceeded by it at any step, late or
not. -/
theorem Includes.not_exceedsLate (includes : W.Includes l' l) : ¬ W.ExceedsLate l l' :=
  fun late => includes.not_exceeded late.exceeds

/-- **Widening without end is widening.** -/
theorem WidensWithoutEnd.widens (widens : W.WidensWithoutEnd l l') : W.Widens l l' :=
  ⟨widens.1, widens.2.exceeds⟩

/-- **Widening without end is eventual widening.** -/
theorem WidensWithoutEnd.eventually (widens : W.WidensWithoutEnd l l') :
    W.EventuallyWidens l l' :=
  ⟨⟨0, widens.1.from_ 0⟩, widens.2⟩

/-- No level path eventually widens itself. -/
theorem EventuallyWidens.irrefl : ¬ W.EventuallyWidens l l :=
  fun ⟨_, late⟩ => match late 0 with
    | ⟨_, _, _, admitted, not⟩ => not admitted

/-- **Eventual widening is transitive.** -/
theorem EventuallyWidens.trans (first : W.EventuallyWidens l l')
    (second : W.EventuallyWidens l' l'') : W.EventuallyWidens l l'' :=
  match first.1, second.1 with
  | ⟨T, inc⟩, ⟨T', inc'⟩ =>
    ⟨⟨T + T', inc.trans inc'⟩, fun S => match second.2 (S + (T + T')) with
      | ⟨t, f, from_, admitted, not⟩ =>
        have late : T + T' ≤ t := Nat.le_trans (Nat.le_add_left (T + T') S) from_
        ⟨t, f, Nat.le_trans (Nat.le_add_right S (T + T')) from_,
          inc t f (Nat.le_trans (Nat.le_add_right T T') late) admitted, not⟩⟩

/-- **Eventual widening goes one way.** -/
theorem EventuallyWidens.not_reverse (widens : W.EventuallyWidens l l') :
    ¬ W.EventuallyWidens l' l :=
  fun back => EventuallyWidens.irrefl (widens.trans back)

/-- **Eventual widening never reverses inclusion**: a level path included by another at every
step does not eventually widen it. -/
theorem EventuallyWidens.not_included (widens : W.EventuallyWidens l l') : ¬ W.Includes l' l :=
  fun includes => includes.not_exceedsLate widens.2

/-- **Eventual widening never reverses widening.** -/
theorem Widens.not_eventually_reversed (widens : W.Widens l l') : ¬ W.EventuallyWidens l' l :=
  fun back => back.not_included widens.1

/-- Inclusion, then eventual widening, is eventual widening. -/
theorem Includes.trans_eventually (includes : W.Includes l l')
    (widens : W.EventuallyWidens l' l'') : W.EventuallyWidens l l'' :=
  match widens.1 with
  | ⟨T, inc⟩ =>
    ⟨⟨T, fun t f from_ admitted => includes t f (inc t f from_ admitted)⟩,
     fun S => match widens.2 S with
      | ⟨t, f, from_, admitted, not⟩ => ⟨t, f, from_, includes t f admitted, not⟩⟩

/-- Eventual widening, then inclusion, is eventual widening. -/
theorem EventuallyWidens.trans_includes (widens : W.EventuallyWidens l l')
    (includes : W.Includes l' l'') : W.EventuallyWidens l l'' :=
  match widens.1 with
  | ⟨T, inc⟩ =>
    ⟨⟨T, fun t f from_ admitted => inc t f from_ (includes t f admitted)⟩,
     fun S => match widens.2 S with
      | ⟨t, f, from_, admitted, not⟩ =>
        ⟨t, f, from_, admitted, fun held => not (includes t f held)⟩⟩

/-- Widening or eventual widening is irreflexive. -/
theorem WidensOrEventually.irrefl : ¬ W.WidensOrEventually l l
  | .inl widens => widens.not_reverse widens
  | .inr widens => EventuallyWidens.irrefl widens

/-- **Widening or eventual widening is transitive**: the two can be held together. -/
theorem WidensOrEventually.trans (first : W.WidensOrEventually l l')
    (second : W.WidensOrEventually l' l'') : W.WidensOrEventually l l'' :=
  match first, second with
  | .inl a, .inl b => .inl (a.trans b)
  | .inl a, .inr b => .inr (a.1.trans_eventually b)
  | .inr a, .inl b => .inr (a.trans_includes b.1)
  | .inr a, .inr b => .inr (a.trans b)

/-! ## No first stretch decides it -/

/-- The level path that follows `l` up to step `h` and `m` after it. -/
def splice (h : Nat) (l m : Nat → C → Nat) : Nat → C → Nat :=
  fun t => if t ≤ h then l t else m t

theorem splice_after {h t : Nat} {l m : Nat → C → Nat} (after : h < t) :
    splice h l m t = m t :=
  match (inferInstance : Decidable (t ≤ h)) with
  | .isTrue le => absurd (Nat.lt_of_lt_of_le after le) (Nat.lt_irrefl h)
  | .isFalse not => if_neg not

theorem splice_before {h t : Nat} {l m : Nat → C → Nat} (before : t ≤ h) :
    splice h l m t = l t :=
  if_pos before

/-- **No first stretch verifies eventual widening.** Whatever `l` admits up to `h`, the level path
following it up to `h` and `l'` after it does not eventually widen `l'`. -/
theorem not_eventually_of_splice (h : Nat) (l l' : Nat → C → Nat) :
    ¬ W.EventuallyWidens (splice h l l') l' :=
  fun ⟨_, late⟩ => match late (h + 1) with
    | ⟨t, f, from_, admitted, not⟩ =>
      not (Eq.subst (motive := fun x => W.Admits x t f)
        (splice_after (Nat.lt_of_lt_of_le (Nat.lt_succ_self h) from_)) admitted)

/-- **No first stretch refutes it.** Where some level path `m` eventually widens `l'`, whatever `l`
admits up to `h`, the level path following it up to `h` and `m` after it eventually widens `l'`. -/
theorem eventually_of_splice {m : Nat → C → Nat} (widens : W.EventuallyWidens m l') (h : Nat)
    (l : Nat → C → Nat) : W.EventuallyWidens (splice h l m) l' :=
  match widens.1 with
  | ⟨T, inc⟩ =>
    ⟨⟨T + (h + 1), fun t f from_ admitted =>
        Eq.subst (motive := fun x => W.Admits x t f)
          (splice_after (Nat.lt_of_lt_of_le (Nat.lt_succ_self h)
            (Nat.le_trans (Nat.le_add_left (h + 1) T) from_))).symm
          (inc t f (Nat.le_trans (Nat.le_add_right T (h + 1)) from_) admitted)⟩,
     fun S => match widens.2 (S + (h + 1)) with
      | ⟨t, f, from_, admitted, not⟩ =>
        ⟨t, f, Nat.le_trans (Nat.le_add_right S (h + 1)) from_,
         Eq.subst (motive := fun x => W.Admits x t f)
          (splice_after (Nat.lt_of_lt_of_le (Nat.lt_succ_self h)
            (Nat.le_trans (Nat.le_add_left (h + 1) S) from_))).symm admitted,
         not⟩⟩

/-! ## A course whose range keeps widening -/

section Keeping

variable (W : Web F C)

/-- From `T` on, along the continuation `R`, nothing the levels `l` admit is lost: across every
stretch from `T` on they include along `R`. -/
def HoldsFrom (R : Nat → F → F → Prop) (l : Nat → C → Nat) (T : Nat) : Prop :=
  ∀ S U, T ≤ S → S ≤ U → W.IncludesAcross R l S U

/-- From `T` on, along `R`, after every step something is admitted that continues nothing admitted
at that step. -/
def KeepsOpening (R : Nat → F → F → Prop) (l : Nat → C → Nat) (T : Nat) : Prop :=
  ∀ S, T ≤ S → ∃ U, S ≤ U ∧ W.ExceedsAcross R l S U

/-- **Keeping widening**: from `T` on, along `R`, nothing admitted is lost and something keeps
being opened. -/
def KeepsWidening (R : Nat → F → F → Prop) (l : Nat → C → Nat) (T : Nat) : Prop :=
  W.HoldsFrom R l T ∧ W.KeepsOpening R l T

/-- The level path `l` settles from `T`: at every step from `T` it admits exactly what it admits
at `T`. -/
def SettlesFrom (l : Nat → C → Nat) (T : Nat) : Prop :=
  ∀ U f, T ≤ U → (W.Admits (l U) U f ↔ W.Admits (l T) T f)

end Keeping

variable {R : Nat → F → F → Prop}

/-- Keeping widening from a step holds from every later step. -/
theorem KeepsWidening.later {T T' : Nat} (later : T ≤ T') (keeps : W.KeepsWidening R l T) :
    W.KeepsWidening R l T' :=
  ⟨fun S U from_ le => keeps.1 S U (Nat.le_trans later from_) le,
   fun S from_ => keeps.2 S (Nat.le_trans later from_)⟩

/-- **Keeping widening is the continuation's**: unchanged by every re-identification carrying the
continuation. -/
theorem keepsWidening_reidentify (σ : Reidentify F F') {T : Nat} :
    (W.reidentify σ).KeepsWidening (σ.carry R) l T ↔ W.KeepsWidening R l T :=
  ⟨fun ⟨holds, opens⟩ => ⟨fun S U from_ le => (includesAcross_reidentify σ).mp (holds S U from_ le),
     fun S from_ => match opens S from_ with
      | ⟨U, le, exceeds⟩ => ⟨U, le, (exceedsAcross_reidentify σ).mp exceeds⟩⟩,
   fun ⟨holds, opens⟩ => ⟨fun S U from_ le => (includesAcross_reidentify σ).mpr (holds S U from_ le),
     fun S from_ => match opens S from_ with
      | ⟨U, le, exceeds⟩ => ⟨U, le, (exceedsAcross_reidentify σ).mpr exceeds⟩⟩⟩

/-- Keeping widening by name gathers, for every `n`, `n` distinct formations admitted together at
some step from `T` on. -/
theorem KeepsWidening.gathers {T : Nat} (keeps : W.KeepsWidening itself l T) :
    ∀ n, ∃ xs : List F, ∃ S, T ≤ S ∧ xs.length = n ∧ Distinct xs ∧
      ∀ f, f ∈ xs → W.Admits (l S) S f
  | 0 => ⟨[], T, Nat.le_refl T, rfl, trivial, fun _ mem => nomatch mem⟩
  | n + 1 => match KeepsWidening.gathers keeps n with
    | ⟨xs, S, from_, length, distinct, all⟩ => match keeps.2 S from_ with
      | ⟨U, later, exceeds⟩ => match (exceedsAcross_itself_iff later).mp exceeds with
        | ⟨g, admitted, before⟩ =>
          have kept := (includesAcross_itself_iff later).mp (keeps.1 S U from_ later)
          ⟨g :: xs, U, Nat.le_trans from_ later, congrArg Nat.succ length,
           ⟨fun mem => before (all g mem), distinct⟩,
           fun f mem => match mem_cons_cases mem with
            | .inl same => Eq.subst (motive := fun x => W.Admits (l U) U x) same.symm admitted
            | .inr mem => kept f (all f mem)⟩

/-- **Over a listed type of formations, no range read by name keeps widening.** -/
theorem KeepsWidening.not_listed {fs : List F} (every : ∀ f, f ∈ fs) {T : Nat} :
    ¬ W.KeepsWidening itself l T :=
  fun keeps => match keeps.gathers (fs.length + 1) with
    | ⟨_, _, _, length, distinct, _⟩ =>
      Nat.not_succ_le_self fs.length
        (Eq.subst (motive := fun n => n ≤ fs.length) length
          (length_le_of_sub distinct fun f _ => every f))

/-- **Keeping widening outlasts a range that settles.** A course keeping widening by name eventually
widens a course it includes from some step on and that settles from some step. -/
theorem KeepsWidening.eventually_widens {T T₁ T₂ : Nat} (keeps : W.KeepsWidening itself l T)
    (includes : W.IncludesFrom T₁ l l') (settles : W.SettlesFrom l' T₂) :
    W.EventuallyWidens l l' :=
  ⟨⟨T₁, includes⟩, fun S₀ =>
    have inner : T₁ + T₂ ≤ T + (T₁ + T₂) := Nat.le_add_left (T₁ + T₂) T
    have outer : T + (T₁ + T₂) ≤ S₀ + (T + (T₁ + T₂)) := Nat.le_add_left _ S₀
    have atT : T ≤ S₀ + (T + (T₁ + T₂)) := Nat.le_trans (Nat.le_add_right T _) outer
    have atT₁ : T₁ ≤ S₀ + (T + (T₁ + T₂)) :=
      Nat.le_trans (Nat.le_add_right T₁ T₂) (Nat.le_trans inner outer)
    have atT₂ : T₂ ≤ S₀ + (T + (T₁ + T₂)) :=
      Nat.le_trans (Nat.le_add_left T₂ T₁) (Nat.le_trans inner outer)
    match keeps.2 (S₀ + (T + (T₁ + T₂))) atT with
    | ⟨U, later, exceeds⟩ => match (exceedsAcross_itself_iff later).mp exceeds with
      | ⟨g, admitted, before⟩ =>
        ⟨U, g, Nat.le_trans (Nat.le_add_right S₀ _) later, admitted, fun held =>
          before (includes _ g atT₁ ((settles _ g atT₂).mpr
            ((settles U g (Nat.le_trans atT₂ later)).mp held)))⟩⟩

/-- **What ends is outlasted.** A course admitting something at arbitrarily late steps eventually
widens a course that admits nothing from some step on. -/
theorem eventually_of_vanishing {T : Nat} (gone : ∀ t f, T ≤ t → ¬ W.Admits (l' t) t f)
    (admits : ∀ S, ∃ t f, S ≤ t ∧ W.Admits (l t) t f) : W.EventuallyWidens l l' :=
  ⟨⟨T, fun t f from_ admitted => absurd admitted (gone t f from_)⟩, fun S =>
    match admits (S + T) with
    | ⟨t, f, from_, admitted⟩ =>
      ⟨t, f, Nat.le_trans (Nat.le_add_right S T) from_, admitted,
       gone t f (Nat.le_trans (Nat.le_add_left T S) from_)⟩⟩

end Web

/-! ## What carries a widening: openings that were opened -/

namespace Flow

variable {F C : Type}

/-- **Opened by the opened**: every gain of support after step `T` is given, to a condition the
gainer requires after the step, by a supported formation taking part, which itself gained support
after `T`, earlier. -/
def OpenedByOpened (L : Flow F C) (W : Web F C) (T : Nat) : Prop :=
  ∀ t f, T < t → W.GainsSupport t f → ∃ c g u, W.requires (t + 1) f c ∧ g ∈ L.present t ∧
    0 < L.give t g c ∧ W.Supported t g ∧ T ≤ u ∧ u < t ∧ W.GainsSupport u g

end Flow

/-! ## Witnesses: a range wider now, one that keeps widening, and one saturated -/

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

/-- Each formation `n` requires only its own condition `n`, at need one. -/
def web : Web Nat Nat :=
  ⟨fun _ _ => 0, fun _ _ => True, fun _ n c => c = n, fun _ _ _ => 1, fun _ _ _ => False⟩

theorem admits_iff {m : Nat → Nat} {t n : Nat} : web.Admits m t n ↔ 0 < m n :=
  ⟨fun admitted => admitted n rfl,
   fun pos _ same => Eq.subst (motive := fun x => 0 < m x) same.symm pos⟩

/-- At step `t` the conditions up to `t` stand at one: one formation more a step. -/
def rising : Nat → Nat → Nat := fun t c => rung c t

/-- At step `0` conditions `0` and `1` stand at one, and nothing after: wider at once, then gone. -/
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

/-- Steps up to `0` are `0`. -/
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

/-- **The burst does not keep opening from any step.** -/
theorem burst_not_opening (T : Nat) : ¬ web.KeepsOpening Web.itself burst T :=
  fun opens => match opens (T + 1) (Nat.le_succ T) with
    | ⟨U, later, ⟨_, admitted, _⟩⟩ => match U, later, admitted with
      | 0, later, _ => absurd later (Nat.not_succ_le_zero T)
      | _ + 1, _, admitted => burst_later admitted

theorem burst_not_keeps_widening (T : Nat) : ¬ web.KeepsWidening Web.itself burst T :=
  fun keeps => burst_not_opening T keeps.2

/-- **Plain widening and eventual widening disagree.** Up to step `0` the burst widens the rising
course; over every step the two are mixed; the rising course eventually widens the burst, and keeps
widening by name where the burst does not. -/
theorem disagreement :
    web.WidensUpTo 0 burst rising ∧ web.Mixed rising burst ∧ web.EventuallyWidens rising burst ∧
      web.KeepsWidening Web.itself rising 0 ∧ ∀ T, ¬ web.KeepsWidening Web.itself burst T :=
  ⟨burst_widens_now, mixed, rising_eventually_widens_burst, rising_keeps_widening,
   burst_not_keeps_widening⟩

/-- The saturated course widens the rising one. -/
theorem full_widens_rising : web.Widens full rising :=
  ⟨fun _ _ _ => full_admits, ⟨0, 1, full_admits,
    fun admitted => Nat.not_succ_le_zero 0 (rising_iff.mp admitted)⟩⟩

/-- The saturated course opens nothing from any step. -/
theorem full_not_opening (T : Nat) : ¬ web.KeepsOpening Web.itself full T :=
  fun opens => match opens T (Nat.le_refl T) with
    | ⟨_, later, ⟨g, _, apart⟩⟩ => apart g (Web.Linked.itself_of_le later) full_admits

/-- **Keeping widening is not kept by widening.** The saturated course widens the rising course,
which keeps widening by name, and keeps widening from no step: no order ranking every course that
keeps widening above every course that does not agrees with widening. -/
theorem not_monotone :
    web.Widens full rising ∧ web.KeepsWidening Web.itself rising 0 ∧
      ∀ T, ¬ web.KeepsWidening Web.itself full T :=
  ⟨full_widens_rising, rising_keeps_widening, fun T keeps => full_not_opening T keeps.2⟩

theorem rung_mono : ∀ c t, rung c t ≤ rung c (t + 1)
  | 0, _ => Nat.le_refl 1
  | _ + 1, 0 => Nat.zero_le _
  | c + 1, t + 1 => (rung_mono c t : rung c t ≤ rung c (t + 1))

theorem rung_zero : ∀ {c t : Nat}, t < c → rung c t = 0
  | 0, _, lt => absurd lt (Nat.not_lt_zero _)
  | _ + 1, 0, _ => rfl
  | c + 1, t + 1, lt => (rung_zero (c := c) (t := t) (Nat.lt_of_succ_lt_succ lt) : rung c t = 0)

end OwnCondition

/-! ## Witnesses: one range, carried by its own openings or by one giver -/

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

/-- What steps the level of condition `c` from `g` to `g + 1`: one unit to condition `g + 1`. -/
def opening (g c : Nat) : Nat := rung c (g + 1) - rung c g

theorem opening_pos (t : Nat) : 0 < opening t (t + 1) :=
  Eq.subst (motive := fun x => 0 < rung (t + 1) (t + 1) - x) (rung_zero (Nat.lt_succ_self t)).symm
    (rung_pos (Nat.le_refl (t + 1)))

/-- **The relay**: at step `t` formation `t` alone takes part and gives one unit to condition
`t + 1`. -/
def flow : Flow Nat Nat := ⟨fun t => [t], fun _ _ _ => 0, fun _ g c => opening g c⟩

/-- **One giver**: at step `t` formation `0` alone takes part and gives the same unit. -/
def sun : Flow Nat Nat := ⟨fun _ => [0], fun _ _ _ => 0, fun t _ c => opening t c⟩

theorem balanced_step (t c : Nat) : rung c (t + 1) = rung c t + opening t c :=
  (add_sub_of_le (rung_mono c t)).symm

/-- The relay balances. -/
theorem flow_balances : flow.Balances web := fun t c =>
  show rung c (t + 1) + (0 + 0) = rung c t + (opening t c + 0) from balanced_step t c

/-- The single giver balances on the same web. -/
theorem sun_balances : sun.Balances web := fun t c =>
  show rung c (t + 1) + (0 + 0) = rung c t + (opening t c + 0) from balanced_step t c

/-- In the relay only active formations give. -/
theorem flow_acting : flow.Acting web := fun _ _ _ mem _ =>
  match mem_cons_cases mem with
  | .inl same => Nat.le_of_eq same
  | .inr inner => nomatch inner

/-- With the single giver only active formations give. -/
theorem sun_acting : sun.Acting web := fun t _ _ mem _ =>
  match mem_cons_cases mem with
  | .inl same => Eq.subst (motive := fun x => x ≤ t) same.symm (Nat.zero_le t)
  | .inr inner => nomatch inner

/-- In both, a formation is active only where supported. -/
theorem dependent : web.Dependent := fun _ _ active => supported_iff.mpr active

/-- **The relay is opened by the opened**: every gain after step `0` is given by the formation that
gained support at the step before. -/
theorem flow_opened : Flow.OpenedByOpened flow web 0 := fun t f after gains =>
  match t, after, gains_iff.mp gains with
  | s + 1, _, same => ⟨f, s + 1, s, rfl, .head [],
      Eq.subst (motive := fun x => 0 < opening (s + 1) x) same.symm (opening_pos (s + 1)),
      supported_iff.mpr (Nat.le_refl (s + 1)), Nat.zero_le s, Nat.lt_succ_self s,
      gains_iff.mpr rfl⟩

/-- **The single giver's range is not opened by the opened**: its giver never gained support. -/
theorem sun_not_opened : ¬ Flow.OpenedByOpened sun web 0 := fun opened =>
  match opened 1 2 (Nat.lt_succ_self 0) (gains_iff.mpr rfl) with
  | ⟨_, _, u, _, mem, _, _, _, _, gained⟩ =>
    match mem_cons_cases mem with
    | .inl same => gained.1 (supported_iff.mpr
        (Eq.subst (motive := fun x => x ≤ u) same.symm (Nat.zero_le u)))
    | .inr inner => nomatch inner

/-- **One range, two carriers.** On one web, so with the same levels at every step and so the same
admissions (widening keeps them the same), the relay and the single giver both balance with only
active formations giving, and the relay's range is opened by the opened while the single giver's is
not. -/
theorem carried :
    flow.Balances web ∧ sun.Balances web ∧ flow.Acting web ∧ sun.Acting web ∧ web.Dependent ∧
      Flow.OpenedByOpened flow web 0 ∧ ¬ Flow.OpenedByOpened sun web 0 :=
  ⟨flow_balances, sun_balances, flow_acting, sun_acting, dependent, flow_opened, sun_not_opened⟩

end OpeningChain

end Becoming
