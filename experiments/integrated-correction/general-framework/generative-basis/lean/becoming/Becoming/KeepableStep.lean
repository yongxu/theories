import Becoming.JointKeeping
import Becoming.Horizon

/-!
# KeepableStep: one step of keeping along some course

`Becoming.Viability` states one step
of keeping under every course: a configuration is in the kernel exactly when it is within the
guard and every successor is in the kernel (`kernel_step_iff`). This module states the twin for
keeping along some course (`Keepable`, `Becoming.JointKeeping`), and what a step does to not
being keepable.

* **One step.** A guard is keepable from a configuration exactly when it holds there and some
  step leads to a configuration it is keepable from (`keepable_step_iff`). For every process and
  guard, with no further premise: a run read from its step 1 on is a run (`Run.onward`), and a
  step into a run's start followed by the run is a run (`Run.cons`).
* **Whether a step can gain keepability.** Every step keeps not being keepable exactly where no
  step from outside the guard leads to a configuration the guard is keepable from
  (`not_keepable_invariant_iff`). Where every step keeps the guard's complement this holds
  (`not_keepable_step`), and then along every run whose start is not keepable no configuration is
  (`not_keepable_run`). No decision of the guard is used.
* **The premise is needed, and is not the least.** On `ChoicePoint.process`, a guard that does
  not hold at `split` and holds at `left` is not keepable from `split` and keepable from `left`,
  one step on (`ChoicePoint.keepable_gained`, along the run `ChoicePoint.leftRun`
  `ChoicePoint.keepable_gained_along_run`). On the successor law of the numbers, where a run
  starts from every number, the guard "is `1`" is keepable from no number
  (`Successor.nowhere_keepable`), so every step keeps not being keepable, while the step from
  `0` leads from outside the guard into it (`Successor.not_keepable_kept_complement_not`).

No premise is added beyond what each statement names.
-/

namespace Becoming

open Generative

universe u v

namespace Viability

variable {S : Type u} {A : Type v}

/-! ## One step -/

/-- **One step, along some course.** For every process `P`, guard `g` and configuration `s`,
with no further premise: `g` is keepable from `s` (some run of `P` from `s` stays within `g`)
exactly when `g` holds at `s` and some step of `P` from `s` leads to a configuration `g` is
keepable from. The twin of `kernel_step_iff`, with "some step" for "every step". -/
theorem keepable_step_iff {P : Process S A} {g : S → Prop} {s : S} :
    Keepable P g s ↔ g s ∧ ∃ a t, P.step s a t ∧ Keepable P g t :=
  ⟨fun ⟨r, start, held⟩ =>
    ⟨Eq.subst (motive := g) start (held 0), r.act 0, r.state 1,
     Eq.subst (motive := fun x => P.step x (r.act 0) (r.state 1)) start (r.step 0),
     r.onward 1, rfl, fun n => held (1 + n)⟩,
   fun ⟨here, a, _, step, r, start, held⟩ =>
    ⟨Run.cons s a r (Eq.subst (motive := fun x => P.step s a x) start.symm step), rfl, fun
      | 0 => here
      | n + 1 => held n⟩⟩

/-! ## Whether a step can gain keepability -/

/-- **Every step keeps not being keepable exactly where no step from outside the guard leads to
a configuration the guard is keepable from.** For every process `P` and guard `g`, with no
further premise: "not keepable" is kept by every step of `P` (`Invariant`) exactly when, for
every step of `P` from `s` to `t`, if `g` does not hold at `s` then `g` is not keepable from `t`.
No decision of `g` is used. -/
theorem not_keepable_invariant_iff {P : Process S A} {g : S → Prop} :
    Invariant P (fun s => ¬ Keepable P g s) ↔
      ∀ s a t, P.step s a t → ¬ g s → ¬ Keepable P g t :=
  ⟨fun kept s a t step out => kept s a t step (fun keepable => out keepable.start),
   fun closed s a t step lost keepable =>
    closed s a t step
      (fun here => lost (keepable_step_iff.mpr ⟨here, a, t, step, keepable⟩)) keepable⟩

/-- **Where every step keeps the guard's complement, a step keeps not being keepable.** Premises:
every step of `P` from a configuration where `g` does not hold leads to a configuration where `g`
does not hold (`closed`); `g` is not keepable from `s` (`lost`); `P` steps from `s` to `t` by `a`
(`step`). Conclusion: `g` is not keepable from `t`. The premise `closed` is needed
(`ChoicePoint.keepable_gained`) and is not the least that serves
(`not_keepable_invariant_iff`, `Successor.not_keepable_kept_complement_not`). No decision of `g`
is used. -/
theorem not_keepable_step {P : Process S A} {g : S → Prop}
    (closed : ∀ s a t, P.step s a t → ¬ g s → ¬ g t) {s : S} {a : A} {t : S}
    (lost : ¬ Keepable P g s) (step : P.step s a t) : ¬ Keepable P g t :=
  not_keepable_invariant_iff.mpr
    (fun s a t step out keepable => closed s a t step out keepable.start) s a t step lost

/-- **Where every step keeps the guard's complement, keepability is not gained along a run.**
Premises: every step of `P` from a configuration where `g` does not hold leads to a
configuration where `g` does not hold (`closed`); `r` is a run of `P`; `g` is not keepable from
the start of `r` (`lost`). Conclusion: `g` is not keepable from any configuration of `r`. It is
`Invariant.run` at `not_keepable_step`. -/
theorem not_keepable_run {P : Process S A} {g : S → Prop}
    (closed : ∀ s a t, P.step s a t → ¬ g s → ¬ g t) (r : Run P)
    (lost : ¬ Keepable P g (r.state 0)) : ∀ n, ¬ Keepable P g (r.state n) :=
  Invariant.run (I := fun s => ¬ Keepable P g s)
    (fun _ _ _ step lost => not_keepable_step closed lost step) r lost

/-! ## The premise is needed -/

namespace ChoicePoint

/-- A condition that does not hold at `split` and holds at `left`, `right` and `joint`. -/
def afterSplit : Config → Prop
  | .split => False
  | .left => True
  | .right => True
  | .joint => True

/-- **Without the premise a step gains keepability.** On `ChoicePoint.process` with the guard
`afterSplit`: the guard is not keepable from `split`; the move `true` steps from `split` to
`left`; the guard is keepable from `left`; and it is not so that every step keeps the guard's
complement. No premise. -/
theorem keepable_gained :
    ¬ Keepable process afterSplit .split ∧ process.step .split true .left ∧
      Keepable process afterSplit .left ∧
      ¬ ∀ s a t, process.step s a t → ¬ afterSplit s → ¬ afterSplit t :=
  ⟨fun keepable => keepable.start, rfl, ⟨restRun .left rfl, rfl, fun _ => trivial⟩,
   fun closed => closed .split true .left rfl (fun here => here) trivial⟩

/-- **Without the premise keepability is gained along a run.** Along the run `leftRun` of
`ChoicePoint.process`, the guard `afterSplit` is not keepable from the configuration at step 0
and keepable from the configuration at step 1. No premise. -/
theorem keepable_gained_along_run :
    ¬ Keepable process afterSplit (leftRun.state 0) ∧
      Keepable process afterSplit (leftRun.state 1) :=
  ⟨keepable_gained.1, keepable_gained.2.2.1⟩

end ChoicePoint

/-! ## The premise is not the least -/

namespace Successor

/-- The witness's process: each number steps to its successor. -/
def process : Process Nat Unit := Law.process Nat.succ

/-- The guard holds at `1` only. -/
def atOne (n : Nat) : Prop := n = 1

/-- Under the successor law the guard "is `1`" is keepable from no number: a run within it would
be at `1` at steps 0 and 1. No premise. -/
theorem nowhere_keepable (n : Nat) : ¬ Keepable process atOne n :=
  fun ⟨r, _, held⟩ =>
    have first : r.state 0 = 1 := held 0
    have second : r.state 1 = 1 := held 1
    have step : r.state 1 = Nat.succ (r.state 0) := r.step 0
    Nat.noConfusion (Nat.succ.inj
      (((congrArg Nat.succ first).symm.trans step.symm).trans second))

/-- **Not being keepable can be kept by every step where the guard's complement is not.** On the
successor law with the guard "is `1`": a run starts from every number; every step keeps not
being keepable (the guard is keepable from no number, `nowhere_keepable`); and it is not so that
every step keeps the guard's complement (the step from `0` leads to `1`). No premise. -/
theorem not_keepable_kept_complement_not :
    (∀ n, ∃ r : Run process, r.state 0 = n) ∧
      (∀ s a t, process.step s a t → ¬ Keepable process atOne s → ¬ Keepable process atOne t) ∧
      ¬ ∀ s a t, process.step s a t → ¬ atOne s → ¬ atOne t :=
  ⟨fun n => ⟨Law.run Nat.succ n, rfl⟩,
   fun _ _ t _ _ => nowhere_keepable t,
   fun closed => closed 0 () 1 rfl (fun (same : (0 : Nat) = 1) => Nat.noConfusion same) rfl⟩

end Successor

end Viability

end Becoming
