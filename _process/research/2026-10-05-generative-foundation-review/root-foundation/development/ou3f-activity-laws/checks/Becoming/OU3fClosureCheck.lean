import Becoming.Retaining
import Becoming.Wholes
import Becoming.Reserve

/-! Reviewer's check, not for landing: two "(c) model" inductions over steps re-proved by closure
(`Invariant.reach` with `Run.reach`), as EC6b re-proved `Pace.stays`. -/

namespace Becoming
namespace OU3fClosureCheck

open Generative

/-- The clock: the run of the successor law, its state the step itself (no induction). -/
def clock : Run (Law.process Nat.succ) := ⟨id, fun _ => (), fun _ => rfl⟩

variable {F C : Type} {W : Web F C}

/-- `Web.inactive_of_not_arising`, by closure: not being active is kept by every step. -/
theorem inactive_of_not_arising {f : F} (start : ¬ W.active 0 f) (never : ∀ t, ¬ W.Arises t f) :
    ∀ t, ¬ W.active t f := fun t =>
  Eq.subst (motive := fun n => ¬ W.active n f) (Nat.zero_add t)
    (Invariant.reach (P := Law.process Nat.succ) (I := fun n => ¬ W.active n f)
      (fun n _ m stepped inactive => Eq.subst (motive := fun i => ¬ W.active i f) stepped.symm
        (fun active => never n ⟨inactive, active⟩))
      (Run.reach clock 0 t) start)

/-- `Web.active_back`, by closure of a bounded region. -/
theorem active_back {parts : F → Prop} {S k : Nat}
    (quiet : ∀ j, j < k → ∀ p, parts p → ¬ W.Arises (S + j) p) {p : F} (part : parts p)
    (active : W.active (S + k) p) : ¬ ¬ W.active S p :=
  have kept := Invariant.reach (P := Law.process Nat.succ)
    (I := fun n => n ≤ k → W.active (S + n) p → ¬ ¬ W.active S p)
    (fun n _ m stepped held =>
      Eq.subst (motive := fun i => i ≤ k → W.active (S + i) p → ¬ ¬ W.active S p) stepped.symm
        (fun le act inactive =>
          quiet n le p part ⟨fun before => held (Nat.le_of_succ_le le) before inactive, act⟩))
    (Run.reach clock 0 k) (fun _ act inactive => inactive act)
  Eq.subst (motive := fun i => i ≤ k → W.active (S + i) p → ¬ ¬ W.active S p) (Nat.zero_add k)
    kept (Nat.le_refl k) active

/-- The statements are the real ones. -/
example : ∀ {f : F}, ¬ W.active 0 f → (∀ t, ¬ W.Arises t f) → ∀ t, ¬ W.active t f :=
  fun start never => Web.inactive_of_not_arising start never
example {parts : F → Prop} {S k : Nat} : (∀ j, j < k → ∀ p, parts p → ¬ W.Arises (S + j) p) →
    ∀ {p : F}, parts p → W.active (S + k) p → ¬ ¬ W.active S p :=
  fun quiet {_} part active => Web.active_back (W := W) quiet part active

end OU3fClosureCheck
end Becoming
