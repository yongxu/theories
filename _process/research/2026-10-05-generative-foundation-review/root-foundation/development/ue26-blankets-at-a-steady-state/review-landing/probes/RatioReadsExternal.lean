import Becoming.BlanketWeights

/-! Landing review probe (not for landing). The texts that say "detailed balance of the internal moves
(within one closure of moves present at every external state) gives the statistical form" drop the
ratio condition. One internal bit, one blanket state, two external states: the internal flip is
present at positive rate at both external states (so the closure joins the internal states at
every external state), the weighting is positive and in detailed balance with the moves, and the
weighting is not in cross form, because the flip's rate ratio reads the external state. -/

namespace ReviewProbe
open Becoming Becoming.BlanketWeights

/-- Flip 0 → 1 at 1 where the external bit is off and at 2 where it is on; 1 → 0 at 1. -/
def rate (_b : Unit) (e μ μ' : Bool) : Nat :=
  if μ' = μ then 0 else if μ = false then (if e then 2 else 1) else 1

def w (μ : Bool) (_b : Unit) (e : Bool) : Nat :=
  if e then (if μ then 2 else 1) else 1

theorem pos : ∀ μ b e, 0 < w μ b e := by
  intro μ b e; cases b; cases μ <;> cases e <;> decide

theorem balanced : DetailedBalance w rate := by
  intro μ μ' b e; cases μ <;> cases μ' <;> cases e <;> rfl

/-- The flip is present at positive rate at every external state. -/
theorem moves : ∀ (b : Unit) (e μ μ' : Bool), μ ≠ μ' → 0 < rate b e μ μ' := by
  intro b e μ μ' ne; cases b
  cases μ <;> cases μ' <;> cases e <;> first | exact absurd rfl ne | decide

/-- Its closure joins the two internal states. -/
theorem joined : ∀ (_b : Unit) (μ μ' : Bool), «所闭» (fun a c : Bool => a ≠ c) μ μ' := by
  intro _ μ μ'
  match μ, μ' with
  | false, false => exact «所闭之自反» _ _
  | true, true => exact «所闭之自反» _ _
  | false, true => exact fun _ closed held => closed false true held (fun h => Bool.noConfusion h)
  | true, false => exact fun _ closed held => closed true false held (fun h => Bool.noConfusion h)

/-- The ratio reads the external state. -/
theorem ratio_reads : rate () false false true * rate () true true false ≠
    rate () false true false * rate () true false true := by decide

/-- And the weighting is not in cross form, so (listing each state once) not independent. -/
theorem not_crossForm : ¬ CrossForm w := fun h => absurd (h false true () false true) (by decide)

theorem dist : Distinct [false, true] :=
  ⟨(fun m => by cases m with | tail _ m' => cases m'), (fun m => by cases m), trivial⟩

theorem mem (b : Bool) : b ∈ [false, true] := by
  cases b
  · exact .head _
  · exact .tail _ (.head _)

theorem not_independent : ¬ IndependentGiven [false, true] [false, true] w := fun h =>
  not_crossForm (crossForm_of_crossFormOn [false, true] [false, true] w
    mem mem
    (crossFormOn_of_independentGiven [false, true] [false, true] w
      dist dist h))

end ReviewProbe

#print axioms ReviewProbe.not_crossForm
#print axioms ReviewProbe.balanced
#print axioms ReviewProbe.not_independent
