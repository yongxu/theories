import Becoming.Frame
import Becoming.Witnesses
import Becoming.CommonResponse

/-!
# Viability: where no course leaves a guard

A guard `guard : S → Prop` marks the configurations in which an activity can go on. This module
states, for every process, exactly where no course leaves the guard, and reads the statement on
laws of change driven by admissible disturbances.

* **The kernel and its certificates.** The viability kernel of a guard holds the configurations
  from which no course leaves it (`Kernel`). A certificate is a set of configurations within the
  guard that every step keeps (`Certificate`: within, and a `Frame` invariant). No course from
  `s` leaves the guard exactly when some certificate contains `s` (`kernel_iff_certificate`);
  the kernel is itself a certificate (`kernel_certificate`) and contains every other
  (`Certificate.kernel`), so it is the largest. The kernel is what holds throughout the closure of
  the steps (`kernel_iff_held`), so these are the grammar's law of the largest closed region inside
  a region (`«所闭之承最大»`) at a process's steps, and are proved from it. One step: a configuration is in the kernel
  exactly when it is within the guard and every successor is in the kernel (`kernel_step_iff`).
  The guard alone need not be a certificate (`Leaves.within_not_kernel`).
* **Laws of change under disturbances.** A law `f : S → A → S` with an admissibility condition
  `adm` on disturbances is a process (`disturbed`): its traces are the admissible courses,
  ending where the law takes the start (`trace_disturbed_iff`). Given one admissible
  disturbance, no history driven by admissible disturbances ever leaves the guard exactly when
  some set containing the start lies within the guard and is closed under every admissible
  disturbance (`never_leaves_iff_certificate`). Without an admissible disturbance the histories
  constrain nothing and the law fails (`needs_admissible`).
* **Guarded histories.** A guarded law stops (`none`) at the first step beginning or ending
  outside the guard, and a stopped history stays stopped (`guardedStep_none`). A guarded
  history agrees with the history at every time exactly when the history stays within the guard
  (`guarded_iff`), so the certificate law holds for guarded histories as well
  (`guarded_never_fails_iff`).

The certificate condition is local: one step from each configuration of the set. Which guard
marks what an activity needs, and which disturbances are admissible, are supplied with each
application; nothing here says that some certificate exists. No premise is added; every
declaration has an empty axiom report.
-/

namespace Becoming

open Generative

universe u v

namespace Viability

variable {S : Type u} {A : Type v}

/-! ## The kernel and its certificates -/

/-- The **viability kernel** of a guard: the configurations from which no course leaves it. -/
def Kernel (P : Process S A) (guard : S → Prop) (s : S) : Prop :=
  ∀ t, Reach P s t → guard t

/-- A **certificate** for a guard: configurations within the guard that every step keeps. -/
structure Certificate (P : Process S A) (guard : S → Prop) (K : S → Prop) : Prop where
  within : ∀ s, K s → guard s
  closed : Invariant P K

/-- **The kernel is what holds throughout the closure of the steps**: the grammar's `«承»` along
the converse of `«所闭»` at the process's steps. -/
theorem kernel_iff_held {P : Process S A} {guard : S → Prop} {s : S} :
    Kernel P guard s ↔ «承» («逆» («所闭» (Steps P))) guard s :=
  ⟨fun kept t within => kept t (reach_iff_withinClosure.mpr within),
   fun held t reach => held t (reach_iff_withinClosure.mp reach)⟩

/-- **Every certificate lies within the kernel**: a region inside the guard and closed under the
steps lies within what holds throughout their closure (`«闭在内则在所闭之承»`). -/
theorem Certificate.kernel {P : Process S A} {guard K : S → Prop} (cert : Certificate P guard K)
    {s : S} (held : K s) : Kernel P guard s :=
  kernel_iff_held.mpr («闭在内则在所闭之承» cert.within (invariant_iff_closedUnder.mp cert.closed) held)

/-- **The kernel is a certificate**: what holds throughout the closure of the steps lies inside the
guard and is closed under them (`«所闭之承在内»`, `«所闭之承闭»`). -/
theorem kernel_certificate (P : Process S A) (guard : S → Prop) :
    Certificate P guard (Kernel P guard) :=
  ⟨fun _ kept => «所闭之承在内» (Steps P) (kernel_iff_held.mp kept),
   invariant_iff_closedUnder.mpr fun x y kept step =>
     kernel_iff_held.mpr («所闭之承闭» (Steps P) guard x y (kernel_iff_held.mp kept) step)⟩

/-- **No course from `s` leaves the guard exactly when some certificate contains `s`.** -/
theorem kernel_iff_certificate {P : Process S A} {guard : S → Prop} {s : S} :
    Kernel P guard s ↔ ∃ K : S → Prop, K s ∧ Certificate P guard K :=
  ⟨fun kept => ⟨Kernel P guard, kept, kernel_certificate P guard⟩,
   fun ⟨_, held, cert⟩ => cert.kernel held⟩

/-- **The kernel is the largest certificate**: it is one, and it contains every other. -/
theorem kernel_largest {P : Process S A} {guard : S → Prop} :
    Certificate P guard (Kernel P guard) ∧
      ∀ K : S → Prop, Certificate P guard K → ∀ s, K s → Kernel P guard s :=
  ⟨kernel_certificate P guard, fun _ cert _ held => cert.kernel held⟩

/-- **One step.** A configuration is in the kernel exactly when it is within the guard and every
successor is in the kernel. -/
theorem kernel_step_iff {P : Process S A} {guard : S → Prop} {s : S} :
    Kernel P guard s ↔ guard s ∧ ∀ a t, P.step s a t → Kernel P guard t :=
  ⟨fun kept => ⟨kept s (Reach.refl P s),
     fun _ _ step u reach => kept u (Reach.trans (Reach.of_step step) reach)⟩,
   fun ⟨held, next⟩ t reach =>
     match reach with
     | ⟨[], path⟩ => match path with
       | .nil _ => held
     | ⟨a :: rest, path⟩ => match path with
       | .cons step tail => next a _ step t ⟨rest, tail⟩⟩

/-- A wider guard has a wider kernel. -/
theorem Kernel.mono {P : Process S A} {guard guard' : S → Prop} (wider : ∀ s, guard s → guard' s)
    {s : S} (kept : Kernel P guard s) : Kernel P guard' s :=
  fun t reach => wider t (kept t reach)

/-- Along every run starting in the kernel, every configuration is within the guard. -/
theorem Kernel.run {P : Process S A} {guard : S → Prop} (r : Run P)
    (kept : Kernel P guard (r.state 0)) (n : Nat) : guard (r.state n) :=
  kept _ (Nat.zero_add n ▸ r.reach 0 n)

/-! ## The guard alone is not a certificate -/

namespace Leaves

/-- From `true` one step leads to `false`. -/
def process : Process Bool Unit := Witnesses.single Unit true false

/-- The guard holds at `true`, yet a course from `true` leaves it. -/
theorem within_not_kernel :
    (fun b : Bool => b = true) true ∧ ¬ Kernel process (fun b => b = true) true :=
  ⟨rfl, fun kept => Bool.noConfusion (kept false (Reach.of_step (a := ()) ⟨rfl, rfl⟩))⟩

end Leaves

/-! ## Laws of change under disturbances -/

/-- A **law of change under disturbances**: an admissible disturbance `a` takes `s` to
`f s a`. -/
def disturbed (f : S → A → S) (adm : A → Prop) : Process S A :=
  ⟨fun s a t => adm a ∧ t = f s a⟩

/-- The history of a law of change under a sequence of disturbances. -/
def history (f : S → A → S) (s : S) (d : Nat → A) : Nat → S
  | 0 => s
  | n + 1 => f (history f s d n) (d n)

/-- **The traces of a disturbed law are its admissible courses**, ending where the law takes the
start. -/
theorem trace_disturbed_iff {f : S → A → S} {adm : A → Prop} :
    ∀ {s t : S} {plan : List A},
      Trace (disturbed f adm) s plan t ↔ (∀ a, a ∈ plan → adm a) ∧ plan.foldl f s = t
  | s, t, [] =>
    ⟨fun path => match path with
      | .nil _ => ⟨fun _ mem => (nomatch mem), rfl⟩,
     fun ⟨_, same⟩ => by
      subst same
      exact .nil s⟩
  | s, t, a :: rest =>
    ⟨fun path => match path with
      | .cons (m := m) ⟨admitted, moved⟩ tail => by
        subst moved
        exact match (trace_disturbed_iff (f := f) (adm := adm)).mp tail with
          | ⟨rest_admitted, ended⟩ =>
            ⟨fun b mem => match mem with
              | .head _ => admitted
              | .tail _ inner => rest_admitted b inner, ended⟩,
     fun ⟨admitted, ended⟩ =>
      .cons ⟨admitted a (.head _), rfl⟩
        ((trace_disturbed_iff (f := f) (adm := adm)).mpr
          ⟨fun b mem => admitted b (.tail _ mem), ended⟩)⟩

/-- **A certificate for a disturbed law** is a set within the guard closed under every
admissible disturbance. -/
theorem certificate_disturbed_iff {f : S → A → S} {adm : A → Prop} {guard K : S → Prop} :
    Certificate (disturbed f adm) guard K ↔
      (∀ x, K x → guard x) ∧ ∀ x a, adm a → K x → K (f x a) :=
  ⟨fun cert => ⟨cert.within, fun x a admitted held => cert.closed x a _ ⟨admitted, rfl⟩ held⟩,
   fun ⟨within, closed⟩ => ⟨within, fun x a _ ⟨admitted, moved⟩ held => by
     subst moved
     exact closed x a admitted held⟩⟩

/-- Every configuration of a history driven by admissible disturbances is reached. -/
theorem history_reach {f : S → A → S} {adm : A → Prop} {s : S} {d : Nat → A}
    (admissible : ∀ n, adm (d n)) : ∀ n, Reach (disturbed f adm) s (history f s d n)
  | 0 => Reach.refl _ s
  | n + 1 => Reach.trans (history_reach admissible n) (Reach.of_step ⟨admissible n, rfl⟩)

/-- A finite course of disturbances continued by `a₀` without end. -/
def extend : List A → A → Nat → A
  | [], a₀, _ => a₀
  | a :: _, _, 0 => a
  | _ :: rest, a₀, n + 1 => extend rest a₀ n

theorem extend_admissible {adm : A → Prop} {a₀ : A} (h₀ : adm a₀) :
    ∀ {plan : List A}, (∀ a, a ∈ plan → adm a) → ∀ n, adm (extend plan a₀ n)
  | [], _, _ => h₀
  | a :: _, all, 0 => all a (.head _)
  | _ :: _, all, n + 1 => extend_admissible h₀ (fun b mem => all b (.tail _ mem)) n

/-- A history read from its first disturbance on. -/
theorem history_shift (f : S → A → S) (s : S) (d : Nat → A) :
    ∀ n, history f s d (n + 1) = history f (f s (d 0)) (fun k => d (k + 1)) n
  | 0 => rfl
  | n + 1 => congrArg (fun x => f x (d (n + 1))) (history_shift f s d n)

/-- The extended course reaches, at the length of the finite course, where the law takes the
start along it. -/
theorem history_extend (f : S → A → S) (a₀ : A) :
    ∀ (plan : List A) (s : S), history f s (extend plan a₀) plan.length = plan.foldl f s
  | [], _ => rfl
  | a :: rest, s =>
    (history_shift f s (extend (a :: rest) a₀) rest.length).trans
      (history_extend f a₀ rest (f s a))

/-- **Given one admissible disturbance, no admissible history leaves the guard exactly when the
start is in the kernel.** -/
theorem never_leaves_iff_kernel {f : S → A → S} {adm : A → Prop} {guard : S → Prop} {s : S}
    {a₀ : A} (h₀ : adm a₀) :
    (∀ d : Nat → A, (∀ n, adm (d n)) → ∀ n, guard (history f s d n)) ↔
      Kernel (disturbed f adm) guard s :=
  ⟨fun every t ⟨plan, path⟩ =>
    match trace_disturbed_iff.mp path with
    | ⟨admitted, ended⟩ => by
      subst ended
      exact history_extend f a₀ plan s ▸
        every (extend plan a₀) (extend_admissible h₀ admitted) plan.length,
   fun kept _ admissible n => kept _ (history_reach admissible n)⟩

/-- **Given one admissible disturbance, no history driven by admissible disturbances ever leaves
the guard exactly when some set containing the start lies within the guard and is closed under
every admissible disturbance.** -/
theorem never_leaves_iff_certificate {f : S → A → S} {adm : A → Prop} {guard : S → Prop}
    {s : S} {a₀ : A} (h₀ : adm a₀) :
    (∀ d : Nat → A, (∀ n, adm (d n)) → ∀ n, guard (history f s d n)) ↔
      ∃ K : S → Prop, K s ∧ (∀ x, K x → guard x) ∧ ∀ x a, adm a → K x → K (f x a) :=
  (never_leaves_iff_kernel h₀).trans
    (kernel_iff_certificate.trans
      ⟨fun ⟨K, held, cert⟩ => ⟨K, held, certificate_disturbed_iff.mp cert⟩,
       fun ⟨K, held, cert⟩ => ⟨K, held, certificate_disturbed_iff.mpr cert⟩⟩)

/-- **A certificate suffices with no further condition**: every history from a configuration of
a certificate stays within the guard. -/
theorem certificate_never_leaves {f : S → A → S} {adm : A → Prop} {guard K : S → Prop}
    (within : ∀ x, K x → guard x) (closed : ∀ x a, adm a → K x → K (f x a)) {s : S} (held : K s)
    (d : Nat → A) (admissible : ∀ n, adm (d n)) : ∀ n, guard (history f s d n) :=
  fun n => (Certificate.kernel (certificate_disturbed_iff.mpr ⟨within, closed⟩) held) _
    (history_reach admissible n)

/-- **The admissible disturbance is needed**: with none, every history condition holds
vacuously, while no set within an empty guard contains the start. -/
theorem needs_admissible :
    (∀ d : Nat → Unit, (∀ n, (fun _ : Unit => False) (d n)) →
        ∀ n, (fun _ : Unit => False) (history (fun s _ => s) () d n)) ∧
      ¬ ∃ K : Unit → Prop, K () ∧ (∀ x, K x → False) ∧
        ∀ x a, (fun _ : Unit => False) a → K x → K ((fun s _ => s) x a) :=
  ⟨fun _ admissible _ => admissible 0, fun ⟨_, held, within, _⟩ => within () held⟩

/-! ## Guarded histories -/

/-- A **guarded law** stops at the first step that begins or ends outside the guard. -/
def guardedStep (f : S → A → S) (guard : S → Prop) [DecidablePred guard] (a : A) :
    Option S → Option S
  | none => none
  | some s => if guard s ∧ guard (f s a) then some (f s a) else none

/-- The guarded history under a sequence of disturbances. -/
def guardedHistory (f : S → A → S) (guard : S → Prop) [DecidablePred guard] (s : S)
    (d : Nat → A) : Nat → Option S
  | 0 => some s
  | n + 1 => guardedStep f guard (d n) (guardedHistory f guard s d n)

/-- A stopped history stays stopped. -/
theorem guardedStep_none (f : S → A → S) (guard : S → Prop) [DecidablePred guard] (a : A) :
    guardedStep f guard a none = none := rfl

/-- A guarded step goes on only from and into the guard. -/
theorem ready_of_step {f : S → A → S} {guard : S → Prop} [DecidablePred guard] {a : A}
    {s t : S} (moved : guardedStep f guard a (some s) = some t) : guard s ∧ guard (f s a) := by
  change (if guard s ∧ guard (f s a) then some (f s a) else none) = some t at moved
  by_cases ready : guard s ∧ guard (f s a)
  · exact ready
  · rw [if_neg ready] at moved
    exact absurd moved ListTests.none_ne_some

/-- Within the guard at both ends, a guarded step goes on. -/
theorem step_of_ready {f : S → A → S} {guard : S → Prop} [DecidablePred guard] {a : A} {s : S}
    (ready : guard s ∧ guard (f s a)) : guardedStep f guard a (some s) = some (f s a) := by
  change (if guard s ∧ guard (f s a) then some (f s a) else none) = some (f s a)
  rw [if_pos ready]

/-- A history within the guard at every time is its own guarded history. -/
theorem agrees_of_within {f : S → A → S} {guard : S → Prop} [DecidablePred guard] {s : S}
    {d : Nat → A} (within : ∀ n, guard (history f s d n)) :
    ∀ n, guardedHistory f guard s d n = some (history f s d n)
  | 0 => rfl
  | n + 1 => (congrArg (guardedStep f guard (d n)) (agrees_of_within within n)).trans
      (step_of_ready ⟨within n, within (n + 1)⟩)

/-- **A guarded history agrees with the history at every time exactly when the history stays
within the guard.** -/
theorem guarded_iff {f : S → A → S} {guard : S → Prop} [DecidablePred guard] {s : S}
    {d : Nat → A} :
    (∀ n, guardedHistory f guard s d n = some (history f s d n)) ↔
      ∀ n, guard (history f s d n) :=
  ⟨fun agree n =>
    (ready_of_step (((congrArg (guardedStep f guard (d n)) (agree n)).symm).trans
      (agree (n + 1)))).1,
   agrees_of_within⟩

/-- **Given one admissible disturbance, no guarded history driven by admissible disturbances
ever stops exactly when some set containing the start lies within the guard and is closed under
every admissible disturbance.** -/
theorem guarded_never_fails_iff {f : S → A → S} {adm : A → Prop} {guard : S → Prop}
    [DecidablePred guard] {s : S} {a₀ : A} (h₀ : adm a₀) :
    (∀ d : Nat → A, (∀ n, adm (d n)) →
        ∀ n, guardedHistory f guard s d n = some (history f s d n)) ↔
      ∃ K : S → Prop, K s ∧ (∀ x, K x → guard x) ∧ ∀ x a, adm a → K x → K (f x a) :=
  (⟨fun every d admissible => guarded_iff.mp (every d admissible),
    fun every d admissible => guarded_iff.mpr (every d admissible)⟩ :
      (∀ d : Nat → A, (∀ n, adm (d n)) →
          ∀ n, guardedHistory f guard s d n = some (history f s d n)) ↔
        ∀ d : Nat → A, (∀ n, adm (d n)) → ∀ n, guard (history f s d n)).trans
    (never_leaves_iff_certificate h₀)

end Viability

end Becoming
