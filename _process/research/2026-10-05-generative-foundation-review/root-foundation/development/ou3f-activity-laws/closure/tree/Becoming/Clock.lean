import Becoming.Recurrence

/-!
# The clock: the successor law's run, its state the step

`Law.clock` is the run of the successor law (`Law.process Nat.succ`) whose state at step `n` is
`n` itself, so its steps are the steps of time with nothing to prove: each is `n + 1 = n + 1`.

**A region every step keeps holds from where it holds on** (`kept_onward`). A region of the steps
of time that every step keeps, holding at step `a`, holds at every later step: the clock reaches
every later step from every earlier one (`Run.reach`), and a region the steps of a process keep is
closed under what they reach (`Invariant.reach`, by `reach_iff_withinClosure`). So an induction
over steps that keeps a region is a case of closure, as `Becoming.Pace`'s `stays` is (board items
EC6b, OU3f).

**Where it belongs.** Its home is beside `Run.reach` and `Invariant.reach` in `Becoming.Frame`. It
is stated here, a leaf importing `Becoming.Recurrence` (where `Law.process` is), so that adding it
rebuilds only the modules that use it, not every module above `Becoming.Frame`; it moves there at
the next full rebuild of the package. The same run stands as a witness on local copies of the
successor's process, `Changing.run` (`Becoming.LawAlongRun`) and `Climb.course`
(`Becoming.ReachableRanges`), and the process `clock` of `Becoming.MoveFormation` is the
successor's step at any action; once the clock is in `Becoming.Frame` they can be read through it.
-/

namespace Becoming

open Generative

/-- **The clock**: the run of the successor law whose state at step `n` is `n`. -/
def Law.clock : Run (Law.process Nat.succ) := ⟨id, fun _ => (), fun _ => rfl⟩

/-- **A region every step keeps holds from where it holds on.** A region of the steps of time
that every step keeps, holding at step `a`, holds at every later step `b`: the clock reaches `b`
from `a` (`Run.reach`), and a region the successor law's steps keep is closed under what they
reach (`Invariant.reach`). -/
theorem kept_onward {I : Nat → Prop} (keeps : ∀ n, I n → I (n + 1)) {a b : Nat} (holds : I a)
    (later : a ≤ b) : I b :=
  match le_dest later with
  | ⟨k, at_⟩ => Eq.subst (motive := I) at_.symm
      (Invariant.reach (P := Law.process Nat.succ)
        (fun n _ _ stepped held => Eq.subst (motive := I) stepped.symm (keeps n held))
        (Law.clock.reach a k) holds)

end Becoming
