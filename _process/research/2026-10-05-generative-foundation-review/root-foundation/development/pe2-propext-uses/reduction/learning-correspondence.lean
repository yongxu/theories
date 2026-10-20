import LearningCorrespondence
/-! PE2 reduction checks, Lean 4.30.0-rc2 with Mathlib, against LearningCorrespondence as its
receipt checked it. `Matrix.vecCons` reaches `Fin.induction.go`, whose base case is a cast
(`Eq.mpr`) along `Fin.mk_zero`, a proof on `propext`. `Eq` is a K-like inductive: the kernel
reduces the cast when its two ends are definitionally equal, whatever the proof, so at a
closed index the value computes. -/
theorem vecCons_last : (![1, 2, 3] : Fin 3 → Nat) 2 = 3 := by decide
theorem vecCons_first : (![1, 2, 3] : Fin 3 → Nat) 0 = 1 := rfl
theorem first_computes : DevelopmentalMemory.first 0 = 1 := rfl
#print axioms vecCons_last
#print axioms vecCons_first
#print axioms first_computes
#print axioms DevelopmentalMemory.first
