import ContinuationCorrespondence
/-! PE2 reduction checks, Lean 4.30.0-rc2 with Mathlib, against ContinuationCorrespondence as
its receipt checked it. `zipPlan` and `compatible` match on the length index `n + 1`, which
compiles through `Nat.elimOffset`, whose continuation receives a proof on `propext`
(`Nat.add_right_cancel`). On closed plans both compute. -/
open ContinuationAdequacy JointContinuation
def p : Plan Unit Unit 1 := .act () (fun _ => .stop)
theorem zip_computes : zipPlan p p = .act ((), ()) (fun _ => .stop) := rfl
theorem compatible_stop :
    compatible (X := Unit) (U := Unit) (V := Unit) (O := Unit) (P := Unit) (fun _ _ _ => True) (fun _ => ((), ())) (fun _ _ => True)
      (Plan.stop : Plan Unit Unit 0) Plan.stop (fun _ => True) = True := rfl
#print axioms zipPlan
#print axioms zip_computes
#print axioms compatible_stop
