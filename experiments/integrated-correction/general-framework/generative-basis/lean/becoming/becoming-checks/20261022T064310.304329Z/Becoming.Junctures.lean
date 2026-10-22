import Becoming.Branching
import Becoming.TimedResponse
import Becoming.Undecided
import Becoming.Prelude

/-!
# Junctures: where a configuration can still be had again and where it is lost

`Becoming.Branching` states what every process keeps, loses and returns to. A configuration `s`
that returns can still be lost where the course branches: `OneWay`'s `false` returns and is
possibly drawn into `{true}` (`OneWay.possibly_not_necessarily`). This module says where the loss
happens, with no premise beyond what each law names.

* **A juncture.** A configuration `x` is a juncture for `s` where it has a step after which `s`
  can still be had and a step after which it cannot (`Juncture`). A juncture can have `s` again
  (`Juncture.reach`), its two steps lead to different configurations (`Juncture.outcomes_differ`),
  it is possibly drawn (`Juncture.possiblyDrawn`), and on the course of `s` it returns
  (`Juncture.returns`): a juncture is where possibly and necessarily drawn come apart.
* **Every loss passes a juncture.** Where `s` returns, every course from `s` to a configuration
  from which `s` cannot be had again passes a juncture on that course, at which the course takes
  the losing step (`loss_passes_juncture`, from any configuration that can have `s`:
  `loss_passes_juncture_from`), and a returning configuration possibly drawn has a juncture on its
  course (`PossiblyDrawn.passes_juncture`). This holds up to double negation. Where it is decided,
  along the course, whether `s` can still be had, the juncture is found
  (`loss_passes_juncture_decided`); for configurations a list holds, with steps decided, it is
  (`reach_decided_listed`, by the settling of `Undecided.settles_within`), and the juncture is found
  (`loss_passes_juncture_listed`). The double negation cannot be dropped in general: finding the
  juncture of every loss in every process decides whether a sequence of truth values has a `true`,
  the limited principle of omniscience (`lpo_of_junctures_found`, on `Hidden`). Finding the
  juncture is deciding whether `s` can still be had again.
* **Keeping and losing.** `keeping P s` keeps exactly the steps of `P` after which `s` can still be
  had, and `losing P s` the steps after which it cannot (`keeping`, `losing`); a juncture is where
  both have a step (`juncture_iff`). Keeping has `s` again from where `P` does
  (`reach_keeping_iff`), keeps `s` (`keeping_keeps`: from wherever its course from `s` leads, it can
  have `s` again) and returns to `s` exactly where `P` does (`keeping_returns_iff`); every
  sub-process of `P` that keeps `s` takes, on its course from `s`, only steps of keeping
  (`keeping_greatest`), so keeping is the greatest. On its own course from `s`, what keeping removes
  are the losing steps at junctures (`keeping_removes_at_juncture`). Losing never returns to `s`
  (`losing_not_returns`) and leaves `s` behind at its first step (`losing_loses`).
* **Many options make no juncture.** Where `P` keeps `s`, nothing on its course is a juncture for it
  (`no_juncture_of_keeps`): in `Many` every configuration has a step for each natural number and
  none is a juncture (`Many.options`, `Many.no_juncture`), while `OneWay`'s `false`, with two
  moves, is one (`OneWay.juncture`). A juncture needs two steps (`Juncture.outcomes_differ`), and
  two are not enough.

**Readings (the AI's; SSBX review G1, decided from the work by D45).**
- 机 (the earlier text: "势临开闭之门", a state from which two continuations lead to different
  open futures, with two or more options necessary and not sufficient) is a juncture: the
  configuration where one step keeps the possibility of having `s` again and another loses it.
  What counts as "open" is read here as one configuration still to be had, not a profile of
  openness; the profile's further components are not formalized.
- 护闭 is keeping: it removes, at junctures, the steps that lose `s`, and is the largest closure that
  keeps `s` to be had again. 成闭 is losing: it removes the steps that keep `s`, and `s` never
  returns. Neither carries a value: which configuration is kept, and whether keeping it supports
  or damages 生生, is not in these laws (chapter §6.15).
- A juncture is found by deciding whether `s` can still be had; that decision is where the earlier
  text placed action ("于机识间而行"). The laws say only that such a place exists on every loss,
  and that finding it asks for that decision.

What is not derived: junctures for sets of configurations or for profiles of several
possibilities; a measure of how many steps a juncture loses; which junctures actual unfoldings
pass. No ethical predicate, ranking or axiom occurs.
* **Within the count, and before a juncture.** With every configuration listed and steps decided,
  what can be had again is had within as many steps as there are configurations
  (`reach_within_listed`, `leadsWithin_trace`), so a keeping step at a juncture reaches `s` within
  that count; at a configuration that is not a juncture, no step can be refuted to keep `s`
  (`keeps_before_juncture`): choosing is needed only at a juncture.
* **A source arriving before a juncture.** With `Becoming.TimedResponse`: where a source has not
  reached a reader by `D`, a reader whose step at `x` is chosen from its answer read through its
  couplings up to `D` takes the same step in both courses, so a losing step in one is losing in the
  other (`TimedResponse.same_step_unreached`); where the chosen steps keep `s` in one course and
  lose it in the other, `x` is a juncture and the source has, not not, reached the reader by `D`
  (`TimedResponse.turned_at_juncture`).
-/

namespace Becoming

open Generative

universe u v

namespace Branching

section Junctures

variable {S : Type u} {A : Type v} {P : Process S A} {s : S}

/-! ## Junctures -/

/-- `x` is a juncture for `s`: it has a step after which `s` can still be had, and a step after
which it cannot. -/
def Juncture (P : Process S A) (s x : S) : Prop :=
  (∃ a y, P.step x a y ∧ Reach P y s) ∧ ∃ b z, P.step x b z ∧ ¬ Reach P z s

/-- A juncture can have `s` again. -/
theorem Juncture.reach {x : S} (juncture : Juncture P s x) : Reach P x s :=
  match juncture.1 with
  | ⟨_, _, step, back⟩ => (Reach.of_step step).trans back

/-- The two steps of a juncture lead to different configurations. -/
theorem Juncture.outcomes_differ {x : S} (juncture : Juncture P s x) :
    ∃ a y b z, P.step x a y ∧ P.step x b z ∧ y ≠ z :=
  match juncture with
  | ⟨⟨a, y, step, back⟩, b, z, step', gone⟩ =>
    ⟨a, y, b, z, step, step', fun same => gone (Eq.subst (motive := fun w => Reach P w s) same back)⟩

/-- A juncture is possibly drawn: after its losing step it cannot be had again. -/
theorem Juncture.possiblyDrawn {x : S} (juncture : Juncture P s x) : PossiblyDrawn P x :=
  match juncture.2 with
  | ⟨_, z, step, gone⟩ =>
    possiblyDrawn_iff.mpr ⟨z, Reach.of_step step, fun back => gone (back.trans juncture.reach)⟩

/-- On the course of `s`, a juncture returns. -/
theorem Juncture.returns {x : S} (from_s : Reach P s x) (juncture : Juncture P s x) : Returns P x :=
  match juncture.1 with
  | ⟨a, y, step, back⟩ => ⟨a, y, step, back.trans from_s⟩

/-- Where `s` returns, a configuration that can have `s` has a step after which it still can. -/
theorem step_back (returns : Returns P s) {x : S} : Reach P x s → ∃ a y, P.step x a y ∧ Reach P y s
  | ⟨[], path⟩ => by
    cases path
    exact returns
  | ⟨_ :: as, .cons step rest⟩ => ⟨_, _, step, as, rest⟩

/-! ## Every loss passes a juncture -/

/-- **Every loss passes a juncture**, from any configuration that can have `s`: on a course from
`x` to a configuration from which `s` cannot be had again, not not some configuration of the
course is a juncture for `s` and the course takes its losing step there. -/
theorem loss_passes_juncture_from (returns : Returns P s) :
    ∀ {x t : S} {as : List A}, Trace P x as t → Reach P x s → ¬ Reach P t s →
      ¬¬ ∃ y a z, Reach P x y ∧ P.step y a z ∧ Reach P z t ∧ ¬ Reach P z s ∧ Juncture P s y
  | _, _, _, .nil _, back, lost => fun _ => lost back
  | x, _, a :: as, @Trace.cons _ _ _ _ m _ _ _ step rest, back, lost => fun none =>
    (fun h : ¬ (Reach P m s ∨ ¬ Reach P m s) => h (.inr fun r => h (.inl r))) fun
      | .inl back' => loss_passes_juncture_from returns rest back' lost
          fun ⟨y, b, z, r, step', on, gone, juncture⟩ =>
            none ⟨y, b, z, (Reach.of_step step).trans r, step', on, gone, juncture⟩
      | .inr gone => none ⟨x, a, m, Reach.refl P x, step, ⟨as, rest⟩, gone,
          step_back returns back, a, m, step, gone⟩

/-- **Every loss of a returning configuration passes a juncture**, up to double negation. -/
theorem loss_passes_juncture (returns : Returns P s) {t : S} {as : List A}
    (path : Trace P s as t) (lost : ¬ Reach P t s) :
    ¬¬ ∃ y a z, Reach P s y ∧ P.step y a z ∧ Reach P z t ∧ ¬ Reach P z s ∧ Juncture P s y :=
  loss_passes_juncture_from returns path (Reach.refl P s) lost

/-- A returning configuration possibly drawn has, not not, a juncture on its course. -/
theorem PossiblyDrawn.passes_juncture (returns : Returns P s) (drawn : PossiblyDrawn P s) :
    ¬¬ ∃ y, Reach P s y ∧ Juncture P s y :=
  match possiblyDrawn_iff.mp drawn with
  | ⟨_, ⟨_, path⟩, lost⟩ => fun none => loss_passes_juncture returns path lost
      fun ⟨y, _, _, from_s, _, _, _, juncture⟩ => none ⟨y, from_s, juncture⟩

/-- Where it is decided, along the course from `s`, whether `s` can still be had, the juncture of
a loss is found. -/
theorem loss_passes_juncture_decided_from (returns : Returns P s)
    (decided : ∀ y, Reach P s y → Reach P y s ∨ ¬ Reach P y s) :
    ∀ {x t : S} {as : List A}, Trace P x as t → Reach P s x → Reach P x s → ¬ Reach P t s →
      ∃ y a z, Reach P x y ∧ P.step y a z ∧ Reach P z t ∧ ¬ Reach P z s ∧ Juncture P s y
  | _, _, _, .nil _, _, back, lost => absurd back lost
  | x, _, a :: as, @Trace.cons _ _ _ _ m _ _ _ step rest, from_s, back, lost =>
    match decided m (from_s.trans (Reach.of_step step)) with
    | .inl back' =>
      match loss_passes_juncture_decided_from returns decided rest
          (from_s.trans (Reach.of_step step)) back' lost with
      | ⟨y, b, z, r, step', on, gone, juncture⟩ =>
        ⟨y, b, z, (Reach.of_step step).trans r, step', on, gone, juncture⟩
    | .inr gone => ⟨x, a, m, Reach.refl P x, step, ⟨as, rest⟩, gone,
        step_back returns back, a, m, step, gone⟩

/-- **The juncture of a loss is found where it is decided whether `s` can still be had.** -/
theorem loss_passes_juncture_decided (returns : Returns P s)
    (decided : ∀ y, Reach P s y → Reach P y s ∨ ¬ Reach P y s) {t : S} {as : List A}
    (path : Trace P s as t) (lost : ¬ Reach P t s) :
    ∃ y a z, Reach P s y ∧ P.step y a z ∧ Reach P z t ∧ ¬ Reach P z s ∧ Juncture P s y :=
  loss_passes_juncture_decided_from returns decided path (Reach.refl P s) (Reach.refl P s) lost

/-! ## Listed configurations with decided steps -/

section Listed

variable (all : List S) (edge : S → S → Bool)

/-- `z` has a course of one to `k` steps into `s`, read by the decided steps `edge`. -/
def leadsWithin (s : S) : Nat → S → Bool
  | 0, _ => false
  | k + 1, z => edge z s || all.any (fun y => edge z y && leadsWithin s k y)

variable {all edge}

theorem any_congr {p q : S → Bool} (same : ∀ y, p y = q y) : ∀ l : List S, l.any p = l.any q
  | [] => rfl
  | a :: l => by
    show (p a || l.any p) = (q a || l.any q)
    rw [same a, any_congr same l]

theorem leadsWithin_sound (decides : ∀ x y, edge x y = true ↔ ∃ a, P.step x a y) :
    ∀ {k : Nat} {z : S}, leadsWithin all edge s k z = true → ∃ a y, P.step z a y ∧ Reach P y s
  | 0, _, h => Bool.noConfusion h
  | _ + 1, z, h => match ListTests.or_true_iff.mp h with
    | .inl into => match (decides z s).mp into with
      | ⟨a, step⟩ => ⟨a, s, step, Reach.refl P s⟩
    | .inr via => match ListTests.any_true_iff.mp via with
      | ⟨y, _, both⟩ => match ListTests.and_true_iff.mp both with
        | ⟨edge_on, leads⟩ => match (decides z y).mp edge_on, leadsWithin_sound decides leads with
          | ⟨a, step⟩, ⟨_, _, step', back⟩ => ⟨a, y, step, (Reach.of_step step').trans back⟩

theorem leadsWithin_complete (every : ∀ x, x ∈ all)
    (decides : ∀ x y, edge x y = true ↔ ∃ a, P.step x a y) :
    ∀ {y : S} {as : List A}, Trace P y as s →
      ∀ z a, P.step z a y → leadsWithin all edge s (as.length + 1) z = true
  | _, _, .nil _, z, a, step => ListTests.or_true_iff.mpr (.inl ((decides z s).mpr ⟨a, step⟩))
  | y, _, .cons step' rest, z, a, step => ListTests.or_true_iff.mpr (.inr
      (ListTests.any_true_iff.mpr ⟨y, every y, ListTests.and_true_iff.mpr
        ⟨(decides z y).mpr ⟨a, step⟩, leadsWithin_complete every decides rest y _ step'⟩⟩))

theorem leadsWithin_up : ∀ {k : Nat} {z : S}, leadsWithin all edge s k z = true →
    leadsWithin all edge s (k + 1) z = true
  | 0, _, h => Bool.noConfusion h
  | _ + 1, _, h => match ListTests.or_true_iff.mp h with
    | .inl into => ListTests.or_true_iff.mpr (.inl into)
    | .inr via => match ListTests.any_true_iff.mp via with
      | ⟨y, m, both⟩ => match ListTests.and_true_iff.mp both with
        | ⟨edge_on, leads⟩ => ListTests.or_true_iff.mpr (.inr (ListTests.any_true_iff.mpr
            ⟨y, m, ListTests.and_true_iff.mpr ⟨edge_on, leadsWithin_up leads⟩⟩))

/-- Steady at step `k`: one more step reaches nothing new. -/
def LeadsSteady (all : List S) (edge : S → S → Bool) (s : S) (k : Nat) : Prop :=
  ∀ z, leadsWithin all edge s (k + 1) z = leadsWithin all edge s k z

theorem LeadsSteady.next {k : Nat} (steady : LeadsSteady all edge s k) :
    LeadsSteady all edge s (k + 1) :=
  fun z => congrArg (edge z s || ·)
    (any_congr (fun y => congrArg (edge z y && ·) (steady y)) all)

theorem leads_steady_or_rises (every : ∀ x, x ∈ all) (k : Nat) :
    LeadsSteady all edge s k ∨ ∃ z, z ∈ all ∧ leadsWithin all edge s k z = false ∧
      leadsWithin all edge s (k + 1) z = true :=
  match Undecided.each_or_some (l := all)
      (A := fun z => leadsWithin all edge s (k + 1) z = leadsWithin all edge s k z)
      (B := fun z => leadsWithin all edge s k z = false ∧ leadsWithin all edge s (k + 1) z = true)
      (fun z _ => by
        cases h : leadsWithin all edge s k z with
        | true => exact .inl ((leadsWithin_up h).trans h.symm)
        | false =>
          cases h' : leadsWithin all edge s (k + 1) z with
          | true => exact .inr ⟨h, h'⟩
          | false => exact .inl (h'.trans h.symm)) with
  | .inl same => .inl fun z => same z (every z)
  | .inr rises => .inr rises

/-- **Reading the steps settles within the number of listed configurations.** -/
theorem leads_settles (every : ∀ x, x ∈ all) : LeadsSteady all edge s all.length :=
  Undecided.settles_within all (fun k z => leadsWithin all edge s k z)
    (fun _ _ _ h => leadsWithin_up h) (fun _ steady => steady.next)
    (leads_steady_or_rises every)

theorem leads_bound (every : ∀ x, x ∈ all) {k : Nat} {z : S}
    (h : leadsWithin all edge s k z = true) : leadsWithin all edge s all.length z = true :=
  match Nat.lt_or_ge k all.length with
  | .inl lt => Undecided.kept_from (Q := fun j => leadsWithin all edge s j z = true)
      (fun _ h' => leadsWithin_up h') h (Nat.le_of_lt lt)
  | .inr ge =>
    have stays : ∀ m, all.length ≤ m → leadsWithin all edge s m z = leadsWithin all edge s all.length z :=
      fun m le => by
        induction le with
        | refl => rfl
        | step le' ih =>
          exact (Undecided.kept_from (fun _ steady => LeadsSteady.next steady) (leads_settles every)
            le' z).trans ih
    (stays k ge).symm.trans h

/-- With `s` returning, `y` can have `s` exactly where the decided steps read a course of at most
the number of listed configurations into `s`. -/
theorem reach_iff_leads (every : ∀ x, x ∈ all)
    (decides : ∀ x y, edge x y = true ↔ ∃ a, P.step x a y) (returns : Returns P s) {y : S} :
    Reach P y s ↔ leadsWithin all edge s all.length y = true :=
  ⟨fun
    | ⟨[], path⟩ => by
      cases path
      exact match returns with
        | ⟨a, _, step, _, rest⟩ => leads_bound every (leadsWithin_complete every decides rest _ a step)
    | ⟨_ :: _, .cons step rest⟩ => leads_bound every (leadsWithin_complete every decides rest _ _ step),
   fun h => match leadsWithin_sound decides h with
    | ⟨_, _, step, back⟩ => (Reach.of_step step).trans back⟩

/-- **For listed configurations with decided steps, whether `s` can be had again is decided**,
where `s` returns. -/
theorem reach_decided_listed (every : ∀ x, x ∈ all)
    (decides : ∀ x y, edge x y = true ↔ ∃ a, P.step x a y) (returns : Returns P s) (y : S) :
    Reach P y s ∨ ¬ Reach P y s := by
  cases h : leadsWithin all edge s all.length y with
  | true => exact .inl ((reach_iff_leads every decides returns).mpr h)
  | false => exact .inr fun r =>
      Bool.noConfusion (((reach_iff_leads every decides returns).mp r).symm.trans h)

/-- **For listed configurations with decided steps, every loss of a returning configuration
passes a juncture**, found. -/
theorem loss_passes_juncture_listed (every : ∀ x, x ∈ all)
    (decides : ∀ x y, edge x y = true ↔ ∃ a, P.step x a y) (returns : Returns P s) {t : S}
    {as : List A} (path : Trace P s as t) (lost : ¬ Reach P t s) :
    ∃ y a z, Reach P s y ∧ P.step y a z ∧ Reach P z t ∧ ¬ Reach P z s ∧ Juncture P s y :=
  loss_passes_juncture_decided returns
    (fun y _ => reach_decided_listed every decides returns y) path lost

/-- A configuration leading into `s` within `k` steps has a step and a course of fewer than `k`
steps after it into `s`. -/
theorem leadsWithin_trace (decides : ∀ x y, edge x y = true ↔ ∃ a, P.step x a y) :
    ∀ {k : Nat} {z : S}, leadsWithin all edge s k z = true →
      ∃ a y as, P.step z a y ∧ Trace P y as s ∧ as.length < k
  | 0, _, h => Bool.noConfusion h
  | k + 1, z, h => match ListTests.or_true_iff.mp h with
    | .inl into => match (decides z s).mp into with
      | ⟨a, step⟩ => ⟨a, s, [], step, .nil s, Nat.succ_pos k⟩
    | .inr via => match ListTests.any_true_iff.mp via with
      | ⟨y, _, both⟩ => match ListTests.and_true_iff.mp both with
        | ⟨edge_on, leads⟩ => match (decides z y).mp edge_on, leadsWithin_trace decides leads with
          | ⟨a, step⟩, ⟨b, _, as, step', path, short⟩ =>
            ⟨a, y, b :: as, step, .cons step' path, Nat.succ_lt_succ short⟩

/-- **What can be had is had within the count.** With every configuration listed, steps decided and
`s` returning, a configuration that can have `s` again has it along a course of at most as many
steps as there are configurations: after a keeping step at a juncture, `s` is had within that many
steps, and no keeping needs more. -/
theorem reach_within_listed (every : ∀ x, x ∈ all)
    (decides : ∀ x y, edge x y = true ↔ ∃ a, P.step x a y) (returns : Returns P s) {y : S}
    (reach : Reach P y s) : ∃ as, as.length ≤ all.length ∧ Trace P y as s :=
  match leadsWithin_trace decides ((reach_iff_leads every decides returns).mp reach) with
  | ⟨a, _, as, step, path, short⟩ => ⟨a :: as, Nat.succ_le_of_lt short, .cons step path⟩

end Listed

/-- **Before a juncture no step needs choosing.** At a configuration with a step after which `s`
can still be had, and which is not a juncture for `s`, no step can be refuted to keep `s`: the
choice comes only at a juncture, where keeping must leave out the losing steps
(`keeping_removes_at_juncture`), and after a losing step nothing brings `s` back
(`losing_not_returns`). -/
theorem keeps_before_juncture {x : S} (keeps : ∃ a y, P.step x a y ∧ Reach P y s)
    (none : ¬ Juncture P s x) : ∀ b z, P.step x b z → ¬ ¬ Reach P z s :=
  fun b z step lost => none ⟨keeps, b, z, step, lost⟩

/-! ## Keeping and losing -/

/-- The steps of `P` after which `s` can still be had. -/
def keeping (P : Process S A) (s : S) : Process S A := ⟨fun x a y => P.step x a y ∧ Reach P y s⟩

/-- The steps of `P` after which `s` cannot be had again. -/
def losing (P : Process S A) (s : S) : Process S A := ⟨fun x a y => P.step x a y ∧ ¬ Reach P y s⟩

/-- `Q`'s steps are among `P`'s. -/
def SubProcess (Q P : Process S A) : Prop := ∀ x a y, Q.step x a y → P.step x a y

/-- `Q` keeps `s`: from wherever its course from `s` leads, it can have `s` again. -/
def Keeps (Q : Process S A) (s : S) : Prop := ∀ y, Reach Q s y → Reach Q y s

theorem SubProcess.reach {Q : Process S A} (sub : SubProcess Q P) {x y : S} :
    Reach Q x y → Reach P x y :=
  Reach.map (f := id) sub

theorem keeping_sub : SubProcess (keeping P s) P := fun _ _ _ step => step.1

theorem losing_sub : SubProcess (losing P s) P := fun _ _ _ step => step.1

/-- **A juncture is where keeping and losing both have a step.** -/
theorem juncture_iff {x : S} :
    Juncture P s x ↔ (∃ a y, (keeping P s).step x a y) ∧ ∃ b z, (losing P s).step x b z :=
  Iff.rfl

/-- A course of `P` into `s` is a course of keeping. -/
theorem reach_keeping_of_trace : ∀ {y : S} {as : List A}, Trace P y as s → Reach (keeping P s) y s
  | _, _, .nil _ => Reach.refl _ _
  | _, _, .cons step rest => (Reach.of_step (P := keeping P s) ⟨step, _, rest⟩).trans
      (reach_keeping_of_trace rest)

/-- Keeping can have `s` from where `P` can. -/
theorem reach_keeping_iff {y : S} : Reach (keeping P s) y s ↔ Reach P y s :=
  ⟨keeping_sub.reach, fun ⟨_, path⟩ => reach_keeping_of_trace path⟩

/-- **Keeping keeps `s`.** -/
theorem keeping_keeps : Keeps (keeping P s) s :=
  fun _ ⟨_, path⟩ => match trace_last path with
  | .inl same => Eq.subst (motive := fun w => Reach (keeping P s) w s) same (Reach.refl _ s)
  | .inr ⟨_, _, _, step⟩ => reach_keeping_iff.mpr step.2

/-- Keeping returns to `s` exactly where `P` does. -/
theorem keeping_returns_iff : Returns (keeping P s) s ↔ Returns P s :=
  ⟨fun ⟨a, t, step, back⟩ => ⟨a, t, step.1, keeping_sub.reach back⟩,
   fun ⟨a, t, step, back⟩ => ⟨a, t, ⟨step, back⟩, reach_keeping_iff.mpr back⟩⟩

/-- **Keeping is the greatest sub-process that keeps `s`**: every sub-process of `P` keeping `s`
takes, on its course from `s`, only steps of keeping. -/
theorem keeping_greatest {Q : Process S A} (sub : SubProcess Q P) (keeps : Keeps Q s) {x y : S}
    {a : A} (from_s : Reach Q s x) (step : Q.step x a y) : (keeping P s).step x a y :=
  ⟨sub _ _ _ step, sub.reach (keeps y (from_s.trans (Reach.of_step step)))⟩

/-- **On its course from `s`, what keeping removes are the losing steps at junctures.** -/
theorem keeping_removes_at_juncture (returns : Returns P s) {x y : S} {a : A}
    (from_s : Reach (keeping P s) s x) (step : P.step x a y) (removed : ¬ (keeping P s).step x a y) :
    ¬ Reach P y s ∧ Juncture P s x :=
  have gone : ¬ Reach P y s := fun back => removed ⟨step, back⟩
  ⟨gone, step_back returns (keeping_sub.reach (keeping_keeps x from_s)), a, y, step, gone⟩

/-- Losing never returns to `s`. -/
theorem losing_not_returns : ¬ Returns (losing P s) s :=
  fun ⟨_, _, step, back⟩ => step.2 (losing_sub.reach back)

/-- Losing leaves `s` behind at its first step: from every configuration its course from `s` reaches
beyond `s`, `P` cannot have `s` again. -/
theorem losing_loses {y : S} (from_s : Reach (losing P s) s y) : s = y ∨ ¬ Reach P y s :=
  match from_s with
  | ⟨_, path⟩ => match trace_last path with
    | .inl same => .inl same
    | .inr ⟨_, _, _, step⟩ => .inr step.2

/-- **Where `P` keeps `s`, nothing on its course is a juncture for it.** -/
theorem no_juncture_of_keeps (keeps : Keeps P s) {x : S} (from_s : Reach P s x) :
    ¬ Juncture P s x :=
  fun ⟨_, _, z, step, gone⟩ => gone (keeps z (from_s.trans (Reach.of_step step)))

end Junctures

/-! ## Many options, no juncture -/

namespace Many

/-- One configuration, a step for each natural number. -/
def process : Process Unit Nat := everyStep Unit Nat

theorem options : ∀ n : Nat, process.step () n () := fun _ => trivial

/-- **Many options make no juncture.** -/
theorem no_juncture : ∀ x : Unit, ¬ Juncture process () x :=
  fun _ ⟨_, _, z, _, gone⟩ => gone (match z with | () => Reach.refl _ _)

end Many

/-- `OneWay`'s `false` is a juncture for itself, with two moves: `false` keeps it, `true` loses
it. -/
theorem OneWay.juncture : Juncture OneWay.process false false :=
  ⟨⟨false, false, rfl, Reach.refl _ _⟩, true, true, rfl,
   fun back => Bool.noConfusion (OneWay.atTrue_invariant.reach back rfl)⟩

/-! ## Finding the juncture of every loss is omniscience -/

namespace Hidden

/-- The configurations of a process in which whether `origin` can be had again from `fork` is
hidden in a sequence of truth values. -/
inductive Pos where
  | origin
  | fork
  | sink
  | chain (k : Nat)

/-- From `origin`: to itself and to `fork`. -/
def fromOrigin : Pos → Prop
  | .origin => True
  | .fork => True
  | .sink => False
  | .chain _ => False

/-- From `fork`: to `sink` and to the start of the chain. -/
def fromFork : Pos → Prop
  | .origin => False
  | .fork => False
  | .sink => True
  | .chain k => k = 0

/-- From the chain at `k`: on to `k + 1`, and back to `origin` where `α k` is `true`. -/
def fromChain (α : Nat → Bool) (k : Nat) : Pos → Prop
  | .origin => α k = true
  | .fork => False
  | .sink => False
  | .chain j => j = k + 1

/-- `origin` steps to itself and to `fork`; `fork` steps to `sink` and into the chain; the chain
goes on, and steps back to `origin` at `k` where `α k` is `true`; `sink` does not move. -/
def step (α : Nat → Bool) : Pos → Unit → Pos → Prop
  | .origin, _, t => fromOrigin t
  | .fork, _, t => fromFork t
  | .sink, _, _ => False
  | .chain k, _, t => fromChain α k t

def process (α : Nat → Bool) : Process Pos Unit := ⟨step α⟩

variable {α : Nat → Bool}

/-- `origin` is had again only from itself or through a `true`. -/
theorem to_origin {x y : Pos} {as : List Unit} (path : Trace (process α) x as y) :
    y = .origin → x = .origin ∨ ∃ k, α k = true := by
  induction path with
  | nil => exact .inl
  | @cons x m _ _ _ step _ ih =>
    intro at_origin
    cases ih at_origin with
    | inr found => exact .inr found
    | inl m_origin =>
      subst m_origin
      cases x with
      | origin => exact .inl rfl
      | fork => exact (step : False).elim
      | sink => exact (step : False).elim
      | chain k => exact .inr ⟨k, step⟩

theorem sink_stuck {a : Unit} {z : Pos} : ¬ (process α).step .sink a z := fun step => step

theorem sink_lost : ¬ Reach (process α) .sink .origin :=
  fun ⟨_, path⟩ => by
    cases path with
    | cons step _ => exact sink_stuck step

theorem chain_reach : ∀ k, Reach (process α) (.chain 0) (.chain k)
  | 0 => Reach.refl _ _
  | k + 1 => (chain_reach k).trans
      (Reach.of_step (P := process α) (s := .chain k) (a := ()) (t := .chain (k + 1)) rfl)

theorem fork_back {k : Nat} (on : α k = true) : Reach (process α) .fork .origin :=
  (Reach.of_step (P := process α) (s := .fork) (a := ()) (t := .chain 0) rfl).trans
    ((chain_reach k).trans (Reach.of_step (P := process α) (s := .chain k) (a := ()) (t := .origin) on))

theorem returns : Returns (process α) .origin := ⟨(), .origin, trivial, Reach.refl _ _⟩

theorem path : Trace (process α) .origin [(), ()] .sink :=
  @Trace.cons Pos Unit (process α) .origin .fork .sink () [()] trivial
    (@Trace.cons Pos Unit (process α) .fork .sink .sink () [] trivial (.nil _))

/-- A juncture on the course from `origin` to `sink` tells whether the sequence has a `true`. -/
theorem juncture_decides
    (found : ∃ y, Reach (process α) .origin y ∧ Reach (process α) y .sink ∧
      Juncture (process α) .origin y) :
    (∃ k, α k = true) ∨ ∀ k, α k = false := by
  obtain ⟨y, _, _, ⟨a, z, stepz, backz⟩, b, w, stepw, gonew⟩ := found
  cases y with
  | origin =>
    cases w with
    | origin => exact absurd (Reach.refl _ _) gonew
    | fork =>
      exact .inr fun k => by
        cases h : α k with
        | false => rfl
        | true => exact absurd (fork_back h) gonew
    | sink => exact (stepw : False).elim
    | chain _ => exact (stepw : False).elim
  | fork =>
    cases z with
    | sink => exact absurd backz sink_lost
    | chain _ =>
      obtain ⟨_, pathz⟩ := backz
      cases to_origin pathz rfl with
      | inl e => exact Pos.noConfusion e
      | inr h => exact .inl h
    | origin => exact (stepz : False).elim
    | fork => exact (stepz : False).elim
  | sink => exact (sink_stuck stepz).elim
  | chain k =>
    cases z with
    | origin => exact .inl ⟨k, stepz⟩
    | chain _ =>
      obtain ⟨_, pathz⟩ := backz
      cases to_origin pathz rfl with
      | inl e => exact Pos.noConfusion e
      | inr h => exact .inl h
    | fork => exact (stepz : False).elim
    | sink => exact (stepz : False).elim

end Hidden

/-- **Finding the juncture of every loss is the limited principle of omniscience.** If every loss
of a returning configuration, in every process, had a juncture found on its course, every
sequence of truth values would have a `true` or be `false` throughout: finding the juncture is
deciding whether the configuration can still be had again. -/
theorem lpo_of_junctures_found
    (found : ∀ (S : Type) (A : Type) (P : Process S A) (s t : S) (as : List A), Returns P s →
      Trace P s as t → ¬ Reach P t s → ∃ y, Reach P s y ∧ Reach P y t ∧ Juncture P s y) :
    LPO :=
  fun α => Hidden.juncture_decides
    (found _ _ (Hidden.process α) .origin .sink _ Hidden.returns Hidden.path Hidden.sink_lost)

end Branching

/-! ## A source arriving before a juncture -/

namespace TimedResponse

variable {F C : Type} {L L' : Flow F C} {W W' : Web F C} {obs : F → C → Prop}
  {source : Nat → F → Prop} {D : Nat} {S : Type u} {Act : Type v} {P : Process S Act} {s x : S}

/-- **A source not yet arrived leaves the reader's step at a juncture as it was.** Two courses of
one description, alike up to `D` but for a source (the hypotheses of `answer_alike_before`); a reader
`g` whose answer is read through its couplings up to `D`, and whose step at the configuration `x` of
a process is chosen from that answer. Where the source has not reached `g` by `D`, `g` takes the same
step at `x` in both courses; so where that step loses `s` in one, no configuration it leads to
having `s` again, it loses `s` in the other. -/
theorem same_step_unreached
    (balanced : ∀ t, t < D → ∀ c, W.level (t+1) c + L.taken t c = W.level t c + L.given t c)
    (balanced' : ∀ t, t < D → ∀ c, W'.level (t+1) c + L'.taken t c = W'.level t c + L'.given t c)
    (present : ∀ t, t < D → L.present t = L'.present t)
    (start : ∀ c, W.level 0 c = W'.level 0 c)
    (responds : ∀ t, t < D → ∀ h, ¬ source t h → W.AlikeThroughUpTo obs h W.level W'.level t →
      ∀ c, L.take t h c = L'.take t h c ∧ L.give t h c = L'.give t h c)
    {A : Type} {g : F} (read : (Nat → C → Nat) → A)
    (through : ∀ l l', W.AlikeThroughUpTo obs g l l' D → read l = read l') (choose : A → Act)
    (unreached : ¬ ReachedBy L L' W obs source g D) :
    choose (read W.level) = choose (read W'.level) ∧
      ((∀ y, P.step x (choose (read W.level)) y → ¬ Reach P y s) →
        ∀ y, P.step x (choose (read W'.level)) y → ¬ Reach P y s) :=
  have same : choose (read W.level) = choose (read W'.level) :=
    congrArg choose (answer_alike_before balanced balanced' present start responds read through unreached)
  ⟨same, fun loses y step => loses y (Eq.subst (motive := fun a => P.step x a y) same.symm step)⟩

/-- **To turn the reader at a juncture, a source must reach it before.** Under the same hypotheses,
where the step chosen in the first course can keep `s` and the step chosen in the second leads
somewhere and loses `s` wherever it leads, `x` is a juncture for `s` and the source has, not not,
reached the reader by `D`. -/
theorem turned_at_juncture
    (balanced : ∀ t, t < D → ∀ c, W.level (t+1) c + L.taken t c = W.level t c + L.given t c)
    (balanced' : ∀ t, t < D → ∀ c, W'.level (t+1) c + L'.taken t c = W'.level t c + L'.given t c)
    (present : ∀ t, t < D → L.present t = L'.present t)
    (start : ∀ c, W.level 0 c = W'.level 0 c)
    (responds : ∀ t, t < D → ∀ h, ¬ source t h → W.AlikeThroughUpTo obs h W.level W'.level t →
      ∀ c, L.take t h c = L'.take t h c ∧ L.give t h c = L'.give t h c)
    {A : Type} {g : F} (read : (Nat → C → Nat) → A)
    (through : ∀ l l', W.AlikeThroughUpTo obs g l l' D → read l = read l') (choose : A → Act)
    (keeps : ∃ y, P.step x (choose (read W.level)) y ∧ Reach P y s)
    (moves : ∃ z, P.step x (choose (read W'.level)) z)
    (loses : ∀ z, P.step x (choose (read W'.level)) z → ¬ Reach P z s) :
    Branching.Juncture P s x ∧ ¬ ¬ ReachedBy L L' W obs source g D :=
  ⟨match keeps, moves with
    | ⟨y, step, back⟩, ⟨z, step'⟩ => ⟨⟨_, y, step, back⟩, _, z, step', loses z step'⟩,
   fun unreached => match keeps with
    | ⟨y, step, back⟩ =>
      loses y (Eq.subst (motive := fun a => P.step x a y)
        (same_step_unreached (P := P) (s := s) (x := x) balanced balanced' present start responds read
          through choose unreached).1 step) back⟩

end TimedResponse

end Becoming
