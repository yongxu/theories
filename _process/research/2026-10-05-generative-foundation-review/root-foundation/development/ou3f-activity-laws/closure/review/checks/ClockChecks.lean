import Becoming.Clock
import Becoming.Retaining
import Becoming.Wholes
import Becoming.Exclusion
import Becoming.Reserve
import Becoming.PatternPassing
import Becoming.Persistence

/-! Review checks for OU3f closure (independent review, 29 October 2026). Compiled against the
scratch build of the tree (`tree-new/.build`); output in `clock-checks.out`. -/

namespace Becoming

open Generative

/-! ## 1. The two statements of `Becoming.Clock` -/

#check @Law.clock
#print Law.clock
#check @kept_onward
#check kept_onward

/-! ## 2. Axiom reports: the clock, the law and the six re-proved theorems -/

#print axioms Law.clock
#print axioms kept_onward
#print axioms Web.inactive_of_not_arising
#print axioms Web.active_back
#print axioms Web.active_before
#print axioms Web.ended_for_good
#print axioms Web.ByPassing.present_earlier
#print axioms Web.steady_held

/-! ## 3. Is it a second clock? The existing run of the successor law, `Law.run Nat.succ`
(`Becoming.Recurrence`), and the local copies of the successor's process. -/

-- `Law.run Nat.succ 0` is a run of the same process, from the same start.
example : Run (Law.process Nat.succ) := Law.run Nat.succ 0

-- Its state is the step, by the existing `Law.succ_orbit` (Recurrence): the two runs agree at every
-- step, and their moves agree by definition.
example (n : Nat) : (Law.run Nat.succ 0).state n = Law.clock.state n :=
  (Law.succ_orbit 0 n).trans (Nat.zero_add n)
example : (Law.run Nat.succ 0).act = Law.clock.act := rfl

-- The local processes are the successor's process by definition: `Climb.process`
-- (ReachableRanges), `Changing.process` (LawAlongRun), `AdjacentHeld.process` (HeldPossible) and
-- `clock Unit` (MoveFormation) all have this body.
example : (⟨fun n _ m => m = n + 1⟩ : Process Nat Unit) = Law.process Nat.succ := rfl
example : (⟨fun s _ t => t = s + 1⟩ : Process Nat Unit) = Law.process Nat.succ := rfl
-- So `Climb.course` and `Changing.run` (both `⟨fun n => n, fun _ => (), fun _ => rfl⟩`) are
-- `Law.clock` by definition.
example : (⟨fun n => n, fun _ => (), fun _ => rfl⟩ : Run ⟨fun n _ m => m = n + 1⟩) = Law.clock := rfl

/-! ## 4. `kept_onward` without a new run

(A) By the existing reach of the successor law: a course of a determined law is its orbit
(`Branching.law_reach_iff`) and counting on's orbit is addition (`Law.succ_orbit`). -/

theorem kept_onward_byLaw {I : Nat → Prop} (keeps : ∀ n, I n → I (n + 1)) {a b : Nat}
    (holds : I a) (later : a ≤ b) : I b :=
  match le_dest later with
  | ⟨k, at_⟩ => Eq.subst (motive := I) at_.symm
      (Invariant.reach (P := Law.process Nat.succ)
        (fun n _ _ stepped held => Eq.subst (motive := I) stepped.symm (keeps n held))
        (Branching.law_reach_iff.mpr ⟨k, Law.succ_orbit a k⟩) holds)

/-- (A') By the existing run `Law.run Nat.succ a` and `Run.reach`, as the tree's proof does with
`Law.clock`. -/
theorem kept_onward_byRun {I : Nat → Prop} (keeps : ∀ n, I n → I (n + 1)) {a b : Nat}
    (holds : I a) (later : a ≤ b) : I b :=
  match le_dest later with
  | ⟨k, at_⟩ => Eq.subst (motive := I)
      ((congrArg (Law.orbit Nat.succ a) (Nat.zero_add k)).trans ((Law.succ_orbit a k).trans at_.symm))
      (Invariant.reach (P := Law.process Nat.succ)
        (fun n _ _ stepped held => Eq.subst (motive := I) stepped.symm (keeps n held))
        ((Law.run Nat.succ a).reach 0 k) holds)

/-- (B) On the grammar alone: a line's places lie within the closure from its first place
(`«线则所闭»`), and a closed region holds what lies within the closure (`«闭含所闭»`), at the
successor relation; no process and no run. -/
theorem kept_onward_onGrammar {I : Nat → Prop} (keeps : ∀ n, I n → I (n + 1)) {a b : Nat}
    (holds : I a) (later : a ≤ b) : I b :=
  match le_dest later with
  | ⟨k, at_⟩ => Eq.subst (motive := I) at_.symm
      («闭含所闭» (R := fun x y => y = x + 1)
        (fun x _ held stepped => Eq.subst (motive := I) stepped.symm (keeps x held)) holds
        («线则所闭» (g := fun i => a + i) (N := k) (fun _ _ => rfl) k (Nat.le_refl k)))

#print axioms kept_onward_byLaw
#print axioms kept_onward_byRun
#print axioms kept_onward_onGrammar

/-! ## 5. The existing Frame law of the same kind (`Invariant.run`, its own induction) at the
existing run gives the same content from every start. -/

example {I : Nat → Prop} (keeps : ∀ n, I n → I (n + 1)) {a : Nat} (holds : I a) (k : Nat) :
    I (a + k) :=
  Eq.subst (motive := I) (Law.succ_orbit a k)
    (Invariant.run (P := Law.process Nat.succ) (I := I)
      (fun n _ _ stepped held => Eq.subst (motive := I) stepped.symm (keeps n held))
      (Law.run Nat.succ a) holds k)

end Becoming
