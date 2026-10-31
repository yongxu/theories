import Mathlib.LinearAlgebra.Matrix.NonsingularInverse
import Mathlib.LinearAlgebra.Basis.VectorSpace
import Mathlib.LinearAlgebra.Isomorphisms
import Mathlib.Tactic

/-! Probe for UE26's design (periphery): scratch only. -/

namespace LinearBlanketsProbe

open Matrix

variable {n : Type*} [Fintype n]

/-- The Lyapunov equation gives the Helmholtz form `B = (D - Q) Π` with `Q` antisymmetric. -/
theorem helmholtz_of_lyapunov [DecidableEq n] (B S D : Matrix n n ℝ) (symm : Sᵀ = S) (hS : IsUnit S.det)
    (lyap : B * S + S * Bᵀ = (2 : ℝ) • D) :
    ((1 / 2 : ℝ) • (S * Bᵀ - B * S))ᵀ = -((1 / 2 : ℝ) • (S * Bᵀ - B * S)) ∧
      B = (D - (1 / 2 : ℝ) • (S * Bᵀ - B * S)) * S⁻¹ := by
  have hD : D = (1 / 2 : ℝ) • (B * S + S * Bᵀ) := by
    rw [lyap, smul_smul]; norm_num
  refine ⟨?_, ?_⟩
  · rw [transpose_smul, transpose_sub, transpose_mul, transpose_mul, transpose_transpose, symm,
      ← smul_neg, neg_sub]
  · have : D - (1 / 2 : ℝ) • (S * Bᵀ - B * S) = B * S := by
      rw [hD, ← smul_sub]
      have : B * S + S * Bᵀ - (S * Bᵀ - B * S) = (2 : ℝ) • (B * S) := by
        rw [two_smul]; abel
      rw [this, smul_smul]; norm_num
    rw [this, Matrix.mul_assoc, mul_nonsing_inv _ hS, Matrix.mul_one]

/-- Conversely the Helmholtz form with `Q` antisymmetric and `D`, `Π` symmetric gives the Lyapunov
equation for `Π⁻¹`. -/
theorem lyapunov_of_helmholtz [DecidableEq n] (B D Q P : Matrix n n ℝ) (hP : IsUnit P.det) (symmP : Pᵀ = P)
    (symmD : Dᵀ = D) (anti : Qᵀ = -Q) (helm : B = (D - Q) * P) :
    B * P⁻¹ + P⁻¹ * Bᵀ = (2 : ℝ) • D := by
  have h1 : B * P⁻¹ = D - Q := by rw [helm, Matrix.mul_assoc, mul_nonsing_inv _ hP, Matrix.mul_one]
  have hPi : (P⁻¹)ᵀ = P⁻¹ := by rw [transpose_nonsing_inv, symmP]
  have h2 : P⁻¹ * Bᵀ = D + Q := by
    have : (B * P⁻¹)ᵀ = P⁻¹ * Bᵀ := by rw [transpose_mul, hPi]
    rw [← this, h1, transpose_sub, symmD, anti, sub_neg_eq_add]
  rw [h1, h2, two_smul]; abel

inductive Part | internal | blanket | external
  deriving DecidableEq

/-- **No circulation through the internal coordinates.** With the Helmholtz form, noise each
coordinate's own and positive, and no solenoidal flow through an internal coordinate `i`, the
internal drift at `i` reads coordinate `j` exactly where the precision couples them. -/
theorem drift_zero_iff (B D Q P : Matrix n n ℝ) (helm : B = (D - Q) * P)
    (diag : ∀ i k, i ≠ k → D i k = 0) (noisePos : ∀ i, 0 < D i i)
    (i : n) (noCirc : ∀ k, Q i k = 0) (j : n) : B i j = 0 ↔ P i j = 0 := by
  have : B i j = D i i * P i j := by
    rw [helm, mul_apply, Finset.sum_eq_single i]
    · simp [noCirc]
    · intro k _ hk; simp [diag i k (Ne.symm hk), noCirc]
    · intro h; exact absurd (Finset.mem_univ i) h
  rw [this, mul_eq_zero]; exact ⟨fun h => h.resolve_left (noisePos i).ne', Or.inr⟩

/-- In general (Heins and Da Costa 2022, eq. 13): where the drift at `i` does not read `j`, the
precision couples them exactly where `(Q Π) i j` does not vanish. -/
theorem zero_iff_solenoidal (B D Q P : Matrix n n ℝ) (helm : B = (D - Q) * P)
    (diag : ∀ i k, i ≠ k → D i k = 0) (noisePos : ∀ i, 0 < D i i)
    {i j : n} (absent : B i j = 0) : P i j = 0 ↔ (Q * P) i j = 0 := by
  have hB : B i j = D i i * P i j - (Q * P) i j := by
    rw [helm, Matrix.sub_mul, sub_apply, mul_apply, Finset.sum_eq_single i]
    · intro k _ hk; simp [diag i k (Ne.symm hk)]
    · intro h; exact absurd (Finset.mem_univ i) h
  rw [absent] at hB
  constructor
  · intro h; rw [h, mul_zero, zero_sub] at hB; linarith
  · intro h; rw [h, sub_zero] at hB
    exact (mul_eq_zero.mp hB.symm).resolve_left (noisePos i).ne'

namespace Relay

/-- The canonical relay: internal 0 reads blanket 1, blanket 1 reads external 2. -/
noncomputable def B : Matrix (Fin 3) (Fin 3) ℝ := !![1, -1, 0; 0, 1, -1; 0, 0, 1]
noncomputable def S : Matrix (Fin 3) (Fin 3) ℝ := !![15/8, 7/8, 1/4; 7/8, 3/2, 1/2; 1/4, 1/2, 1]
noncomputable def P : Matrix (Fin 3) (Fin 3) ℝ := !![80/109, -48/109, 4/109; -48/109, 116/109, -46/109; 4/109, -46/109, 131/109]

noncomputable def BT : Matrix (Fin 3) (Fin 3) ℝ := !![1, 0, 0; -1, 1, 0; 0, -1, 1]

theorem transpose_B : Bᵀ = BT := by
  ext i j; fin_cases i <;> fin_cases j <;> rfl

theorem lyapunov : B * S + S * Bᵀ = (2 : ℝ) • (1 : Matrix (Fin 3) (Fin 3) ℝ) := by
  rw [transpose_B]
  ext i j; fin_cases i <;> fin_cases j <;>
    simp [B, BT, S, Matrix.mul_apply, Fin.sum_univ_three, Matrix.one_apply] <;> norm_num

theorem inverse : S * P = 1 := by
  ext i j; fin_cases i <;> fin_cases j <;>
    simp [S, P, Matrix.mul_apply, Fin.sum_univ_three, Matrix.one_apply] <;> norm_num

theorem sparse : B 0 2 = 0 ∧ B 2 0 = 0 := by simp [B]

theorem coupled : P 0 2 ≠ 0 := by simp [P]

end Relay

/-- A map from the internal readings to the external readings exists exactly where the kernel of
the first lies in the kernel of the second. -/
theorem exists_factor_iff {K V W U : Type*} [Field K] [AddCommGroup V] [Module K V]
    [AddCommGroup W] [Module K W] [AddCommGroup U] [Module K U]
    (f : V →ₗ[K] W) (g : V →ₗ[K] U) :
    (∃ h : W →ₗ[K] U, h ∘ₗ f = g) ↔ LinearMap.ker f ≤ LinearMap.ker g := by
  constructor
  · rintro ⟨h, rfl⟩; exact LinearMap.ker_le_ker_comp f h
  · intro le
    let h0 : LinearMap.range f →ₗ[K] U :=
      (LinearMap.ker f).liftQ g le ∘ₗ (f.quotKerEquivRange.symm : LinearMap.range f →ₗ[K] _)
    obtain ⟨h, hh⟩ := LinearMap.exists_extend h0
    refine ⟨h, LinearMap.ext fun v => ?_⟩
    have : h (f v) = h0 ⟨f v, LinearMap.mem_range_self f v⟩ := by
      rw [← hh]; rfl
    rw [LinearMap.comp_apply, this]
    simp [h0, LinearMap.quotKerEquivRange_symm_apply_image]

end LinearBlanketsProbe
