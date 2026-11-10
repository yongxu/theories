import Becoming.Regions
import Becoming.ContinuedClasses
import Becoming.Population

/-!
# Eventual widening: widening read on late tails, and keeping widening

`Web.Widens` compares two level paths of one web at every step. This module states what widening
says about the long run, and a course whose range keeps widening, with no premise beyond the
representation. No ethical predicate, ranking or axiom occurs.

**What this is not.** Eventual widening is first-order widening read on late tails. It is not the
second-order comparison the account leaves open, a range whose widening keeps widening against one
merely wider now: it needs no growth (a steady course eventually widens one that collapses), and
it cannot compare a course that keeps every formation of another from one step later
(`LagWitness`, in `Becoming.EventualWideningInstances`). That comparison stays open.

* **Widening on late tails.** The web from step `S` on (`Web.after`, as `World.after` reads a
  world) and a level path from `S` on (`Web.tailFrom`) give the definition: `l` *eventually widens*
  `l'` where, from some step on, `l` widens `l'` on every tail (`Web.EventuallyWidens`). Its order
  laws are widening's: irreflexive, transitive and one-way (`EventuallyWidens.irrefl`,
  `EventuallyWidens.trans`, `EventuallyWidens.not_reverse`, from `Widens.not_reverse` and
  `Widens.trans`). Read pointwise, it is inclusion from some step on (`Web.IncludesFrom`) with
  exceeding at arbitrarily late steps (`Web.ExceedsLate`; `eventuallyWidens_iff`).
* **It never reverses widening.** A level path included by another at every step does not
  eventually widen it (`EventuallyWidens.not_included`, `Widens.not_eventually_reversed`).
  Inclusion composes with it on either side (`Includes.trans_eventually`,
  `EventuallyWidens.trans_includes`), so widening or eventual widening (`Web.WidensOrEventually`)
  is irreflexive and transitive. Where widening orders a pair, eventual widening agrees where the
  wider course exceeds at arbitrarily late steps (widening without end, `Web.WidensWithoutEnd`,
  `WidensWithoutEnd.eventually`). Classically it otherwise is silent, the wider course exceeding
  only over a first stretch. That split is classical: from no excess at arbitrarily late steps no
  step after which excess stops can be named.
* **It reads only tails.** Level paths agreeing from some step on eventually widen, and are
  eventually widened, alike (`EventuallyWidens.of_agree_left`, `EventuallyWidens.of_agree_right`):
  every finite stretch is ignored. A course admitting something at arbitrarily late steps
  eventually widens one that admits nothing from some step on (`eventually_of_vanishing`).
* **Keeping widening.** Along a continuation `R`, from `T` on nothing admitted is lost across any
  stretch (`Web.IncludesAcrossFrom`) and after every step something is admitted that continues
  nothing admitted then (`Web.KeepsOpening`); both together are keeping widening
  (`Web.KeepsWidening`). It holds from every later step (`KeepsWidening.later`) and is unchanged by
  every re-identification carrying the continuation (`keepsWidening_reidentify`).
* **By name over a listed type, no range keeps widening.** Where a list holds every formation, no
  level path keeps widening by name (`KeepsWidening.not_listed`, the pigeonhole through
  `length_le_of_sub`). Along a supplied continuation it can hold of a course admitting the same at
  every step, where a formation re-formed at each step continues nothing (`MergedWitness`, in the
  instances module): read along `R`, keeping widening counts re-formation as opening.
* **Keeping widening and a range admitting alike.** A level path *admits alike* from `T` where at
  every later step it admits exactly what it admits at `T` (`Web.AdmitsAlikeFrom`). A course
  keeping widening by name eventually widens a range that admits alike from some step and whose
  admissions there it admits at some step from `T` (`KeepsWidening.eventually_widens_of_within`):
  nothing lost gives the inclusion. Given the inclusion as a hypothesis, keeping opening alone
  suffices (`KeepsOpening.eventually_widens`, a lemma).

What carries a widening, the property *opened by the opened*, is stated beside its witnesses in
`Becoming.EventualWideningInstances` (`Flow.OpenedByOpened`).

**Standing.** Every law here is near-definitional: the order laws are widening's on late tails, the
tail laws are the definition read pointwise, `not_listed` is the pigeonhole, and the joining laws
use their hypotheses directly.

**Readings (the AI's, for UE4's design note; not adopted).** Eventual widening is the long-run
form of widening: a tail comparison in inclusion form. Unlike overtaking, which sums, it ignores
every finite stretch. Neither it nor keeping widening ranks:
* ranking a course above every course it eventually widens is a requirement beyond C, named C∞ in
  the note;
* ranking by keeping widening runs against widening wholesale (`OwnCondition.not_monotone`), and
  so does ranking by opened by the opened (`Saturated.reverses`), both in the instances module.
  Either could enter only after C, deciding what C asks nothing of, by a named requirement.

**What is not derived.** Which courses an actual unfolding offers; the gain, renewal or number of
givers that keeping widening needs, which the note keeps as design; comparisons over branching
courses. The representation commits to discrete steps on one index and natural-number levels.
Every declaration has an empty axiom report (scratch build).
-/

namespace Becoming

namespace Web

variable {F F' C : Type}

/-! ## Widening read on late tails -/

/-- **The web from step `S` on**: its step `t` is step `S + t`, as `World.after` reads a world. -/
def after (W : Web F C) (S : Nat) : Web F C :=
  ⟨fun t => W.level (S + t), fun t => W.active (S + t), fun t => W.requires (S + t),
   fun t => W.need (S + t), fun t => W.draws (S + t)⟩

/-- A level path from step `S` on. -/
def tailFrom (S : Nat) (l : Nat → C → Nat) : Nat → C → Nat := fun t => l (S + t)

section Tails

variable (W : Web F C)

/-- **Eventual widening**: from some step on, `l` widens `l'` on every tail, each read on the web
from its first step. First-order widening read on late tails. -/
def EventuallyWidens (l l' : Nat → C → Nat) : Prop :=
  ∃ T, ∀ S, T ≤ S → (W.after S).Widens (tailFrom S l) (tailFrom S l')

/-- From step `T` on, `l` includes `l'`: at every step from `T` it admits every formation `l'`
admits. -/
def IncludesFrom (T : Nat) (l l' : Nat → C → Nat) : Prop :=
  ∀ t f, T ≤ t → W.Admits (l' t) t f → W.Admits (l t) t f

/-- `l` exceeds `l'` at arbitrarily late steps. -/
def ExceedsLate (l l' : Nat → C → Nat) : Prop :=
  ∀ S, ∃ t f, S ≤ t ∧ W.Admits (l t) t f ∧ ¬ W.Admits (l' t) t f

/-- **Widening without end**: `l` includes `l'` at every step and exceeds it at arbitrarily late
steps. -/
def WidensWithoutEnd (l l' : Nat → C → Nat) : Prop :=
  W.Includes l l' ∧ W.ExceedsLate l l'

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

/-- Inclusion holds on every tail. -/
theorem Includes.after (includes : W.Includes l l') (S : Nat) :
    (W.after S).Includes (tailFrom S l) (tailFrom S l') :=
  fun t f admitted => includes (S + t) f admitted

/-- **Eventual widening is irreflexive**, as widening is. -/
theorem EventuallyWidens.irrefl : ¬ W.EventuallyWidens l l :=
  fun ⟨T, tails⟩ => (tails T (Nat.le_refl T)).not_reverse (tails T (Nat.le_refl T))

/-- **Eventual widening is transitive**, as widening is. -/
theorem EventuallyWidens.trans (first : W.EventuallyWidens l l')
    (second : W.EventuallyWidens l' l'') : W.EventuallyWidens l l'' :=
  match first, second with
  | ⟨T, tails⟩, ⟨T', tails'⟩ => ⟨T + T', fun S le =>
      (tails S (Nat.le_trans (Nat.le_add_right T T') le)).trans
        (tails' S (Nat.le_trans (Nat.le_add_left T' T) le))⟩

/-- **Eventual widening goes one way.** -/
theorem EventuallyWidens.not_reverse (widens : W.EventuallyWidens l l') :
    ¬ W.EventuallyWidens l' l :=
  fun back => EventuallyWidens.irrefl (widens.trans back)

/-- **Read pointwise**, eventual widening is inclusion from some step on with exceeding at
arbitrarily late steps. -/
theorem eventuallyWidens_iff :
    W.EventuallyWidens l l' ↔ (∃ T, W.IncludesFrom T l l') ∧ W.ExceedsLate l l' :=
  ⟨fun ⟨T, tails⟩ =>
     ⟨⟨T, fun _ f from_ admitted => match le_dest from_ with
        | ⟨k, apart⟩ =>
          Eq.subst (motive := fun x => W.Admits (l x) x f) apart.symm
            ((tails T (Nat.le_refl T)).1 k f
              (Eq.subst (motive := fun x => W.Admits (l' x) x f) apart admitted))⟩,
      fun S₀ => match (tails (S₀ + T) (Nat.le_add_left T S₀)).2 with
        | ⟨k, f, admitted, not⟩ =>
          ⟨S₀ + T + k, f, Nat.le_trans (Nat.le_add_right S₀ T) (Nat.le_add_right (S₀ + T) k),
           admitted, not⟩⟩,
   fun ⟨⟨T, inc⟩, late⟩ => ⟨T, fun S le =>
     ⟨fun t f admitted => inc (S + t) f (Nat.le_trans le (Nat.le_add_right S t)) admitted,
      match late S with
      | ⟨_, f, from_, admitted, not⟩ => match le_dest from_ with
        | ⟨k, apart⟩ =>
          ⟨k, f, Eq.subst (motive := fun x => W.Admits (l x) x f) apart admitted,
           fun back => not (Eq.subst (motive := fun x => W.Admits (l' x) x f) apart.symm back)⟩⟩⟩⟩

/-- Exceeding at arbitrarily late steps is exceeding. -/
theorem ExceedsLate.exceeds (late : W.ExceedsLate l l') : W.Exceeds l l' :=
  match late 0 with
  | ⟨t, f, _, admitted, not⟩ => ⟨t, f, admitted, not⟩

/-- A level path that includes another at every step is not exceeded by it, late or not. -/
theorem Includes.not_exceedsLate (includes : W.Includes l' l) : ¬ W.ExceedsLate l l' :=
  fun late => includes.not_exceeded late.exceeds

/-- **Eventual widening never reverses inclusion**: a level path included by another at every step
does not eventually widen it. -/
theorem EventuallyWidens.not_included (widens : W.EventuallyWidens l l') : ¬ W.Includes l' l :=
  fun includes => match widens with
    | ⟨T, tails⟩ => (includes.after T).not_exceeded (tails T (Nat.le_refl T)).2

/-- **Eventual widening never reverses widening.** -/
theorem Widens.not_eventually_reversed (widens : W.Widens l l') : ¬ W.EventuallyWidens l' l :=
  fun back => back.not_included widens.1

/-- Inclusion, then eventual widening, is eventual widening. -/
theorem Includes.trans_eventually (includes : W.Includes l l')
    (widens : W.EventuallyWidens l' l'') : W.EventuallyWidens l l'' :=
  match widens with
  | ⟨T, tails⟩ => ⟨T, fun S le => match tails S le with
      | ⟨inc, ⟨t, f, admitted, not⟩⟩ =>
        ⟨(includes.after S).trans inc, ⟨t, f, includes.after S t f admitted, not⟩⟩⟩

/-- Eventual widening, then inclusion, is eventual widening. -/
theorem EventuallyWidens.trans_includes (widens : W.EventuallyWidens l l')
    (includes : W.Includes l' l'') : W.EventuallyWidens l l'' :=
  match widens with
  | ⟨T, tails⟩ => ⟨T, fun S le => match tails S le with
      | ⟨inc, ⟨t, f, admitted, not⟩⟩ =>
        ⟨inc.trans (includes.after S),
         ⟨t, f, admitted, fun held => not (includes.after S t f held)⟩⟩⟩

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

/-- Widening without end is widening. -/
theorem WidensWithoutEnd.widens (widens : W.WidensWithoutEnd l l') : W.Widens l l' :=
  ⟨widens.1, widens.2.exceeds⟩

/-- **Widening without end is eventual widening**: where widening orders a pair and the wider course
exceeds at arbitrarily late steps, eventual widening agrees. -/
theorem WidensWithoutEnd.eventually (widens : W.WidensWithoutEnd l l') :
    W.EventuallyWidens l l' :=
  eventuallyWidens_iff.mpr ⟨⟨0, fun t f _ admitted => widens.1 t f admitted⟩, widens.2⟩

/-- **Eventual widening reads only the tail of the first course**: level paths agreeing from some
step on eventually widen alike. -/
theorem EventuallyWidens.of_agree_left {l₁ l₂ : Nat → C → Nat} {T : Nat}
    (agree : ∀ t, T ≤ t → l₁ t = l₂ t) (widens : W.EventuallyWidens l₁ l') :
    W.EventuallyWidens l₂ l' :=
  match widens with
  | ⟨T₀, tails⟩ => ⟨T + T₀, fun S le =>
      have same : ∀ k, l₁ (S + k) = l₂ (S + k) := fun k =>
        agree (S + k) (Nat.le_trans (Nat.le_trans (Nat.le_add_right T T₀) le) (Nat.le_add_right S k))
      match tails S (Nat.le_trans (Nat.le_add_left T₀ T) le) with
      | ⟨inc, ⟨k, f, admitted, not⟩⟩ =>
        ⟨fun t g held => Eq.subst (motive := fun x => (W.after S).Admits x t g) (same t)
            (inc t g held),
         ⟨k, f, Eq.subst (motive := fun x => (W.after S).Admits x k f) (same k) admitted, not⟩⟩⟩

/-- **Eventual widening reads only the tail of the second course.** -/
theorem EventuallyWidens.of_agree_right {l₁ l₂ : Nat → C → Nat} {T : Nat}
    (agree : ∀ t, T ≤ t → l₁ t = l₂ t) (widens : W.EventuallyWidens l l₁) :
    W.EventuallyWidens l l₂ :=
  match widens with
  | ⟨T₀, tails⟩ => ⟨T + T₀, fun S le =>
      have same : ∀ k, l₁ (S + k) = l₂ (S + k) := fun k =>
        agree (S + k) (Nat.le_trans (Nat.le_trans (Nat.le_add_right T T₀) le) (Nat.le_add_right S k))
      match tails S (Nat.le_trans (Nat.le_add_left T₀ T) le) with
      | ⟨inc, ⟨k, f, admitted, not⟩⟩ =>
        ⟨fun t g held => inc t g
            (Eq.subst (motive := fun x => (W.after S).Admits x t g) (same t).symm held),
         ⟨k, f, admitted,
          fun held => not (Eq.subst (motive := fun x => (W.after S).Admits x k f) (same k).symm held)⟩⟩⟩

/-- **What admits nothing from some step on is eventually widened** by every course admitting
something at arbitrarily late steps. -/
theorem eventually_of_vanishing {T : Nat} (gone : ∀ t f, T ≤ t → ¬ W.Admits (l' t) t f)
    (admits : ∀ S, ∃ t f, S ≤ t ∧ W.Admits (l t) t f) : W.EventuallyWidens l l' :=
  eventuallyWidens_iff.mpr ⟨⟨T, fun t f from_ admitted => absurd admitted (gone t f from_)⟩,
    fun S => match admits (S + T) with
      | ⟨t, f, from_, admitted⟩ =>
        ⟨t, f, Nat.le_trans (Nat.le_add_right S T) from_, admitted,
         gone t f (Nat.le_trans (Nat.le_add_left T S) from_)⟩⟩

/-! ## Keeping widening -/

section Keeping

variable (W : Web F C)

/-- From `T` on, along the continuation `R`, nothing the levels `l` admit is lost: across every
stretch from `T` on they include along `R`. -/
def IncludesAcrossFrom (R : Nat → F → F → Prop) (l : Nat → C → Nat) (T : Nat) : Prop :=
  ∀ S U, T ≤ S → S ≤ U → W.IncludesAcross R l S U

/-- From `T` on, along `R`, after every step something is admitted that continues nothing admitted
at that step. -/
def KeepsOpening (R : Nat → F → F → Prop) (l : Nat → C → Nat) (T : Nat) : Prop :=
  ∀ S, T ≤ S → ∃ U, S ≤ U ∧ W.ExceedsAcross R l S U

/-- **Keeping widening**: from `T` on, along `R`, nothing admitted is lost and something keeps
being opened. -/
def KeepsWidening (R : Nat → F → F → Prop) (l : Nat → C → Nat) (T : Nat) : Prop :=
  W.IncludesAcrossFrom R l T ∧ W.KeepsOpening R l T

/-- The level path `l` admits alike from `T`: at every step from `T` it admits exactly what it
admits at `T`. -/
def AdmitsAlikeFrom (l : Nat → C → Nat) (T : Nat) : Prop :=
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

/-- **Keeping opening, with the inclusion given.** A course keeping opening by name eventually widens
a course it includes from some step on and that admits alike from some step. Nothing lost is not
used: the inclusion is a hypothesis. A lemma of `KeepsWidening.eventually_widens_of_within`. -/
theorem KeepsOpening.eventually_widens {T T₁ T₂ : Nat} (opens : W.KeepsOpening itself l T)
    (includes : W.IncludesFrom T₁ l l') (alike : W.AdmitsAlikeFrom l' T₂) :
    W.EventuallyWidens l l' :=
  eventuallyWidens_iff.mpr ⟨⟨T₁, includes⟩, fun S₀ =>
    have inner : T₁ + T₂ ≤ T + (T₁ + T₂) := Nat.le_add_left (T₁ + T₂) T
    have outer : T + (T₁ + T₂) ≤ S₀ + (T + (T₁ + T₂)) := Nat.le_add_left _ S₀
    have atT : T ≤ S₀ + (T + (T₁ + T₂)) := Nat.le_trans (Nat.le_add_right T _) outer
    have atT₁ : T₁ ≤ S₀ + (T + (T₁ + T₂)) :=
      Nat.le_trans (Nat.le_add_right T₁ T₂) (Nat.le_trans inner outer)
    have atT₂ : T₂ ≤ S₀ + (T + (T₁ + T₂)) :=
      Nat.le_trans (Nat.le_add_left T₂ T₁) (Nat.le_trans inner outer)
    match opens (S₀ + (T + (T₁ + T₂))) atT with
    | ⟨U, later, exceeds⟩ => match (exceedsAcross_itself_iff later).mp exceeds with
      | ⟨g, admitted, before⟩ =>
        ⟨U, g, Nat.le_trans (Nat.le_add_right S₀ _) later, admitted, fun held =>
          before (includes _ g atT₁ ((alike _ g atT₂).mpr
            ((alike U g (Nat.le_trans atT₂ later)).mp held)))⟩⟩

/-- **Keeping widening eventually widens a range that admits alike on what it admits at some step.**
A course keeping widening by name from `T` eventually widens a range admitting alike from `T₂` whose
admissions at `T₂` it admits at some step `S` from `T`: nothing lost carries that inclusion to every
later step. -/
theorem KeepsWidening.eventually_widens_of_within {T T₂ S : Nat}
    (keeps : W.KeepsWidening itself l T) (alike : W.AdmitsAlikeFrom l' T₂) (from_ : T ≤ S)
    (within : ∀ f, W.Admits (l' T₂) T₂ f → W.Admits (l S) S f) : W.EventuallyWidens l l' :=
  KeepsOpening.eventually_widens keeps.2 (T₁ := S + T₂)
    (fun t f later admitted =>
      (includesAcross_itself_iff (Nat.le_trans (Nat.le_add_right S T₂) later)).mp
        (keeps.1 S t from_ (Nat.le_trans (Nat.le_add_right S T₂) later)) f
        (within f ((alike t f (Nat.le_trans (Nat.le_add_left T₂ S) later)).mp admitted)))
    alike

end Web

end Becoming
