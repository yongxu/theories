import Mathlib.LinearAlgebra.Matrix.NonsingularInverse
import Mathlib.Tactic

/-! Review probe: Friston et al. 2023 eq. 9 (term-by-term sparse coupling), linear case `J = (Q - Γ) H`,
on the three-state relay (internal 0, blanket 1, external 2). Applied at the relay's absent influences
(1 not reading 0, 2 not reading 0), together with `Γ₀ H₀₂ = 0` (0 not reading 2), it forces the
internal state's reading of the blanket, `J₀₁`, to vanish: the relay's directed edge 1 → 0 cannot
exist under the paper's own definition. -/

open Matrix

theorem relay_eq9 (Q G H : Matrix (Fin 3) (Fin 3) ℝ) (anti : Qᵀ = -Q)
    (diag : ∀ i k, i ≠ k → G i k = 0) (gpos : ∀ i, 0 < G i i) (symm : Hᵀ = H) (hpos : ∀ i, 0 < H i i)
    -- eq. 9 at (u, v) = (1, 0): Γ₁ H₁₀ = 0 and the i = 0 term Q₁₀ H₀₀ = 0
    (g10 : G 1 1 * H 1 0 = 0) (q10 : Q 1 0 * H 0 0 = 0)
    -- eq. 9 at (u, v) = (2, 0): the i = 0 term Q₂₀ H₀₀ = 0
    (q20 : Q 2 0 * H 0 0 = 0) :
    ((Q - G) * H) 0 1 = 0 := by
  have hQ : ∀ i j, Q j i = - Q i j := fun i j => by
    have := congrFun (congrFun anti i) j; simpa [transpose_apply] using this
  have hH : ∀ i j, H j i = H i j := fun i j => by
    have := congrFun (congrFun symm i) j; simpa [transpose_apply] using this
  have Q10 : Q 1 0 = 0 := (mul_eq_zero.mp q10).resolve_right (hpos 0).ne'
  have Q20 : Q 2 0 = 0 := (mul_eq_zero.mp q20).resolve_right (hpos 0).ne'
  have H10 : H 1 0 = 0 := (mul_eq_zero.mp g10).resolve_left (gpos 1).ne'
  have Q00 : Q 0 0 = 0 := by have := hQ 0 0; linarith
  have Q01 : Q 0 1 = 0 := by rw [hQ 0 1] at Q10; linarith
  have Q02 : Q 0 2 = 0 := by rw [hQ 0 2] at Q20; linarith
  have H01 : H 0 1 = 0 := by rw [hH 0 1] at H10; exact H10
  rw [mul_apply, Fin.sum_univ_three]
  simp [sub_apply, Q00, Q01, Q02, H01, diag 0 1 (by decide), diag 0 2 (by decide)]

#print axioms relay_eq9
