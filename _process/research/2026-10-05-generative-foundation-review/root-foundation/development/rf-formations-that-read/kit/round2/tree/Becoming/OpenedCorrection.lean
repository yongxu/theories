import Becoming.GuardHorizon
import Becoming.Revision

/-!
# A revision of a reading that opens a correction, along one process

A formation correcting through the reading in force chooses its act from what that reading tells
apart: where two situations needing different acts are read alike, no act chosen through the reading
fits both. Revising the reading is itself a step of what goes on, drawing on what supports it, and
whether the correction can then be taken is read at the configuration the revision reaches. This
module states when a revision opens a correction on one process (board item RF, round 2: RF6.1),
keeping apart what the reading tells apart, what can be executed at a configuration, and what counts
as acceptable, which is held fixed.

* **Correctable at a configuration** (`Correctable`). Through the reading in force at a
  configuration, a uniform policy exists whose act at each reading is acceptable at every situation
  giving it and executable at the configuration; given choice over the readings, exactly where each
  reading has one such act (`correctable_iff`, from `GuardHorizon.uniform_policy_iff_fiber_feasible`).
* **Opening along a course** (`OpensAlong`). A revision opens a correction from `x` to `x'` where a
  trace of the process leads from `x` to `x'`, no fitting uniform policy exists at `x` and one exists
  at `x'`, with one acceptability throughout. A revision to a reading the old one is read off, losing
  no executability, closes nothing (`finer_keeps`); one to a reading read off the old, gaining no
  executability, opens nothing (`coarser_opens_nothing`). With every act counted acceptable, a
  configuration with an executable act is correctable already (`widened_correctable`), so an opening
  counts only with the acceptability fixed.
* **On Revising's process** (`Linked`). The process of `Becoming.Revision`: a stock supporting
  activity and a link reading a situation, the link off reading both situations alike. A correction
  is acceptable where it is needed and replenishing where it is not; executability is the process's
  enabling. With the link off no configuration is correctable (`Linked.unlinked_uncorrectable`); with
  it on and a unit of stock, every configuration is (`Linked.linked_correctable`); with it on and no
  stock, none is (`Linked.starved_uncorrectable`). So rebuilding the link from two units opens the
  correction in one step (`Linked.opens`); rebuilding it from one does not (`Linked.rebuilt_starved`),
  though replenishing after it does (`Linked.opens_after_replenishing`); and with every act counted
  acceptable, the unlinked configuration is correctable already (`Linked.widened_unlinked`).

**Readings** [AI reading]. Read for an institution, the link is its rule of reading what its
members report, by which line rather than by how many, the stock what that reading draws on, and the
correction the repair a report calls for. Revising an observation map is one formal mechanism that
may take part in organizational learning; its relation to double-loop learning (Argyris and Schön
1978) depends on whether inquiry changes a governing norm or assumption, and here the acceptability is
held fixed and the theorem concerns uniform-policy existence along a course only. Replacing a finer
reading by a coarser one, as by a summary measure, losing no executability, opens no correction.
These are readings, not containments.

**Modelling choices.** Readings in force at a configuration as maps of one type of readings;
acceptability fixed on situations and acts; executability read at the configuration; the revision a
trace of one process; Revising's natural-number stock. Uniform-policy existence is not what a
formation chooses: a supplied controller and its run are another statement (Revising's
`controlled_revision`). Every declaration has an empty axiom report. No ethical predicate, ranking or
axiom occurs.
-/

namespace Becoming

namespace OpenedCorrection

open Generative

section General

variable {X B S A O : Type}

/-- **Correctable at a configuration**: through the reading in force there, a uniform policy exists
whose act at each reading is acceptable at every situation giving it and executable there. -/
def Correctable (reading : X → S → O) (acceptable : S → A → Prop) (executable : X → A → Prop) (x : X) :
    Prop :=
  GuardHorizon.UniformPolicy (reading x) (fun s a => acceptable s a ∧ executable x a)

/-- **Correctable exactly where each reading has one act acceptable at every situation giving it and
executable at the configuration**, given choice over the readings. -/
theorem correctable_iff (choice : Viability.ChoiceOver O A) (reading : X → S → O)
    (acceptable : S → A → Prop) (executable : X → A → Prop) (x : X) :
    Correctable reading acceptable executable x ↔
      ∀ o, ∃ a, ∀ s, reading x s = o → acceptable s a ∧ executable x a :=
  GuardHorizon.uniform_policy_iff_fiber_feasible choice (reading x) _

/-- **A revision opens a correction along a course of the process**: a trace leads from `x` to `x'`,
no fitting uniform policy exists at `x`, and one exists at `x'`, with one acceptability. -/
def OpensAlong (P : Process X B) (reading : X → S → O) (acceptable : S → A → Prop)
    (executable : X → A → Prop) (x x' : X) : Prop :=
  (∃ w, Trace P x w x') ∧ ¬ Correctable reading acceptable executable x ∧
    Correctable reading acceptable executable x'

/-- **A revision to a reading the old one is read off, losing no executability, closes nothing.** -/
theorem finer_keeps {reading : X → S → O} {acceptable : S → A → Prop} {executable : X → A → Prop}
    {x x' : X} (forget : O → O) (refines : ∀ s, forget (reading x' s) = reading x s)
    (kept : ∀ a, executable x a → executable x' a)
    (correctable : Correctable reading acceptable executable x) :
    Correctable reading acceptable executable x' :=
  match correctable with
  | ⟨policy, fits⟩ => ⟨fun o => policy (forget o), fun s =>
      have at_s := fits s
      have same : policy (forget (reading x' s)) = policy (reading x s) := congrArg policy (refines s)
      ⟨Eq.mpr (congrArg (acceptable s) same) at_s.1, kept _ (Eq.mpr (congrArg (executable x) same) at_s.2)⟩⟩

/-- **A revision to a reading read off the old one, gaining no executability, opens nothing.** -/
theorem coarser_opens_nothing {P : Process X B} {reading : X → S → O} {acceptable : S → A → Prop}
    {executable : X → A → Prop} {x x' : X} (forget : O → O)
    (coarser : ∀ s, forget (reading x s) = reading x' s) (no_gain : ∀ a, executable x' a → executable x a) :
    ¬ OpensAlong P reading acceptable executable x x' :=
  fun ⟨_, closed, opened⟩ => closed (finer_keeps forget coarser no_gain opened)

/-- **With every act counted acceptable, a configuration with an executable act is correctable
already**: an opening counts only with the acceptability fixed. -/
theorem widened_correctable (reading : X → S → O) (executable : X → A → Prop) {x : X} {a : A}
    (can : executable x a) : Correctable reading (fun (_ : S) (_ : A) => True) executable x :=
  ⟨fun _ => a, fun _ => ⟨trivial, can⟩⟩

end General

/-! ## On Revising's process -/

namespace Linked

open Revising

/-- What is acceptable: the correction where it is needed, replenishing where it is not. -/
abbrev acceptable (needed : Bool) (a : Act) : Prop :=
  match needed with
  | true => a = .correct
  | false => a = .replenish

/-- What can be executed at a configuration: what the process enables there. -/
abbrev executable (x : State) (a : Act) : Prop := Enabled P x a

/-- **With the link off, no configuration is correctable**: both situations read alike, and they need
different acts. -/
theorem unlinked_uncorrectable (n : Nat) (v : Bool) :
    ¬ Correctable read acceptable executable (n, false, v) :=
  fun ⟨policy, fits⟩ =>
    have at_needed : policy false = .correct := (fits true).1
    have at_unneeded : policy false = .replenish := (fits false).1
    nomatch at_needed.symm.trans at_unneeded

/-- **With the link on and a unit of stock, every configuration is correctable.** -/
theorem linked_correctable (n : Nat) (v : Bool) :
    Correctable read acceptable executable (n + 1, true, v) :=
  ⟨fun b => match b with
    | true => .correct
    | false => .replenish,
   fun s => match s with
    | true => ⟨rfl, (n, true, true), rfl, n, rfl, rfl⟩
    | false => ⟨rfl, (n + 1 + 1, true, v), rfl⟩⟩

/-- **With the link on and no stock, none is**: the correction a needed situation calls for cannot
be taken. -/
theorem starved_uncorrectable (v : Bool) : ¬ Correctable read acceptable executable (0, true, v) :=
  fun ⟨policy, fits⟩ =>
    have chosen : policy true = .correct := (fits true).1
    match (fits true).2 with
    | ⟨t, step⟩ =>
      have taken : P.step (0, true, v) .correct t :=
        Eq.mp (congrArg (fun a => P.step (0, true, v) a t) chosen) step
      match taken with
      | ⟨_, _, empty, _⟩ => Nat.noConfusion empty

/-- **Rebuilding the link from two units opens the correction in one step.** -/
theorem opens (n : Nat) (v : Bool) :
    OpensAlong P read acceptable executable (n + 2, false, v) (n + 1, true, v) :=
  ⟨⟨[.rebuild true], .cons ⟨n + 1, rfl, rfl⟩ (.nil _)⟩, unlinked_uncorrectable (n + 2) v,
   linked_correctable n v⟩

/-- **Rebuilding it from one unit does not**: the rebuilt link consumes the last unit, and the
correction cannot be taken. -/
theorem rebuilt_starved (v : Bool) :
    P.step (1, false, v) (.rebuild true) (0, true, v) ∧
      ¬ Correctable read acceptable executable (0, true, v) :=
  ⟨⟨0, rfl, rfl⟩, starved_uncorrectable v⟩

/-- **Replenishing after it does**: along rebuilding and then replenishing, from one unit, the
correction is opened. -/
theorem opens_after_replenishing (v : Bool) :
    OpensAlong P read acceptable executable (1, false, v) (1, true, v) :=
  ⟨⟨[.rebuild true, .replenish], .cons ⟨0, rfl, rfl⟩ (.cons rfl (.nil _))⟩,
   unlinked_uncorrectable 1 v, linked_correctable 0 v⟩

/-- **With every act counted acceptable, the unlinked configuration is correctable already**, by
replenishing. -/
theorem widened_unlinked (n : Nat) (v : Bool) :
    Correctable read (fun (_ : Bool) (_ : Act) => True) executable (n, false, v) :=
  widened_correctable read executable (a := .replenish) ⟨(n + 1, false, v), rfl⟩

end Linked

end OpenedCorrection

end Becoming
