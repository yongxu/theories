import MachineInstances
/-! PE2 reduction checks, Lean 4.29.1, against MachineInstances as its receipt checked it.
`revises` is on `propext` only through its wildcard match: the match compiles to
`_sparseCasesOn_1`, whose `else` branch receives a proof of `Nat.hasNotBit 4 t.ctorIdx`, a
statement naming `Nat.land`, whose definition (well-founded `Nat.bitwise`) is on `propext`.
The kernel computes `Nat.land` on literals itself, and the branch ignores the proof, so
closed values compute. -/
open Becoming.MachineInstances JointPracticeContinuation
theorem revise_computes : revises .revise = true := by decide
theorem retry_computes : revises .retry = false := by decide
theorem retry_by_rfl : revises .retry = false := rfl
theorem land_computes : Nat.land 12 10 = 8 := by decide
theorem hasNotBit_computes : Nat.land 1 (Nat.shiftRight 4 3) ≠ 1 := by decide
#print axioms revises
#print axioms Nat.land
#print axioms revise_computes
#print axioms retry_computes
#print axioms retry_by_rfl
#print axioms land_computes
#print axioms hasNotBit_computes
