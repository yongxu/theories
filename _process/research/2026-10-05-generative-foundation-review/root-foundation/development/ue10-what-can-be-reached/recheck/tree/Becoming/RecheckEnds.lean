import Becoming.ReachableRanges

/-!
# UE10 re-check probe, part 4: a range that keeps widening ranked above one wider now

Probe of the revised `Becoming.ReachableRanges` (re-check RECHECK-UE10.md). Not proposed for
landing as written.

* R23: without the premise that the configuration wider now starts a course, widening what can be
  reached ranks a configuration whose course keeps widening above one that admits now what it does
  not. So the sentence "it never ranks a range that keeps widening above one wider now", planned
  for 07's Open item, needs that premise, as `Reaching.not_above_wider_now` has it.
-/

namespace Becoming

namespace RecheckUE10

open Generative

namespace EndsNow

/-- `some n` climbs to `some (n + 1)`; `none` has no step. -/
def process : Process (Option Nat) Unit := ⟨fun s _ t => match s with
  | none => False
  | some n => t = some (n + 1)⟩

/-- `none` admits every formation; `some n` admits the formations up to `n`. -/
def adm : Option Nat → Nat → Prop
  | none, _ => True
  | some n, x => x ≤ n

/-- The climb from `some 0`. -/
def climb : Run process := ⟨fun t => some t, fun _ => (), fun _ => rfl⟩

/-- `none` starts no course. -/
theorem no_course (r : Run process) (start : r.state 0 = none) : False :=
  (Eq.subst (motive := fun c => process.step c (r.act 0) (r.state 1)) start (r.step 0) : False)

/-- What the climb admits keeps widening, in 07's form. -/
theorem climb_keeps : Reaching.KeepsWidening (fun n => adm (climb.state n)) :=
  ⟨fun n d _ admitted => Nat.le_trans admitted (Nat.le_add_right n d),
   fun n => ⟨1, n + 1, Nat.le_refl _, Nat.not_succ_le_self n⟩⟩

/-- **R23.** What the climb from `some 0` admits keeps widening, `none` admits now what `some 0`
does not, and `some 0` widens what can be reached over `none`, which starts no course. -/
theorem keeps_widening_above_wider_now :
    Reaching.KeepsWidening (fun n => adm (climb.state n)) ∧ adm none 1 ∧ ¬ adm (some 0) 1 ∧
      Reaching.Widens process adm (some 0) none :=
  ⟨climb_keeps, trivial, Nat.not_succ_le_self 0,
   ⟨fun r' start' => (no_course r' start').elim, climb, rfl,
    fun r' start' _ => no_course r' start'⟩⟩

end EndsNow

end RecheckUE10

end Becoming
