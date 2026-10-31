import Mathlib.LinearAlgebra.Matrix.NonsingularInverse
import Mathlib.LinearAlgebra.Matrix.ToLin
import Mathlib.LinearAlgebra.Basis.VectorSpace
import Mathlib.LinearAlgebra.Isomorphisms
import Mathlib.Tactic

namespace LinearBlanketsDraft

open Matrix

/-- Uniqueness of the Helmholtz parts. -/
theorem helmholtz_unique {n : Type*} [Fintype n] [DecidableEq n] (B S D' Q' : Matrix n n ℝ)
    (symmS : Sᵀ = S) (hS : IsUnit S.det) (symmD : D'ᵀ = D') (anti : Q'ᵀ = -Q')
    (helm : B = (D' - Q') * S⁻¹) :
    D' = (1 / 2 : ℝ) • (B * S + S * Bᵀ) ∧ Q' = (1 / 2 : ℝ) • (S * Bᵀ - B * S) := by
  have h1 : B * S = D' - Q' := by rw [helm, Matrix.mul_assoc, nonsing_inv_mul _ hS, Matrix.mul_one]
  have h2 : S * Bᵀ = D' + Q' := by
    have : (B * S)ᵀ = S * Bᵀ := by rw [transpose_mul, symmS]
    rw [← this, h1, transpose_sub, symmD, anti, sub_neg_eq_add]
  rw [h1, h2]
  constructor
  · rw [show D' - Q' + (D' + Q') = (2 : ℝ) • D' by rw [two_smul]; abel, smul_smul]; norm_num
  · rw [show D' + Q' - (D' - Q') = (2 : ℝ) • Q' by rw [two_smul]; abel, smul_smul]; norm_num

variable {m k l : Type*} [Fintype m] [Fintype k] [Fintype l] [DecidableEq m] [DecidableEq l]

/-- The internal mode given blanket and external states: the stationary point of the quadratic
form in the internal coordinates. -/
noncomputable def mode (Pmm : Matrix m m ℝ) (Pmk : Matrix m k ℝ) (Pml : Matrix m l ℝ)
    (b : k → ℝ) (η : l → ℝ) : m → ℝ :=
  -(Pmm⁻¹ *ᵥ (Pmk *ᵥ b + Pml *ᵥ η))

theorem mode_stationary (Pmm : Matrix m m ℝ) (Pmk : Matrix m k ℝ) (Pml : Matrix m l ℝ)
    (hP : IsUnit Pmm.det) (b : k → ℝ) (η : l → ℝ) :
    Pmm *ᵥ mode Pmm Pmk Pml b η + Pmk *ᵥ b + Pml *ᵥ η = 0 := by
  rw [mode, mulVec_neg, mulVec_mulVec, mul_nonsing_inv _ hP, one_mulVec]; abel

/-- **The internal mode reads no external state exactly at the zero block.** -/
theorem mode_unread_iff (Pmm : Matrix m m ℝ) (Pmk : Matrix m k ℝ) (Pml : Matrix m l ℝ)
    (hP : IsUnit Pmm.det) :
    (∀ b η η', mode Pmm Pmk Pml b η = mode Pmm Pmk Pml b η') ↔ Pml = 0 := by
  constructor
  · intro same
    have key : ∀ η, Pml *ᵥ η = 0 := by
      intro η
      have h := same 0 η 0
      have s1 := mode_stationary Pmm Pmk Pml hP 0 η
      have s0 := mode_stationary Pmm Pmk Pml hP 0 0
      rw [h] at s1
      simpa using (sub_eq_zero.mpr (s1.trans s0.symm))
    ext i j
    have := congrFun (key (Pi.single j 1)) i
    simpa [mulVec_single] using this
  · rintro rfl b η η'; simp [mode]

/-- A map from internal to external readings of the blanket exists exactly where the kernels nest. -/
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
    have : h (f v) = h0 ⟨f v, LinearMap.mem_range_self f v⟩ := by rw [← hh]; rfl
    rw [LinearMap.comp_apply, this]
    simp [h0, LinearMap.quotKerEquivRange_symm_apply_image]

/-- **The map from internal to external modes.** Under the blanket, with the internal and external
blocks invertible, a matrix `σ` carrying every internal mode given the blanket to the external
mode given it exists exactly where the kernel of the internal part's coupling to the blanket lies
in the external part's. -/
theorem ker_neg_inv_mul {r : Type*} [Fintype r] [DecidableEq r] (P : Matrix r r ℝ) (C : Matrix r k ℝ)
    (hP : IsUnit P.det) :
    LinearMap.ker (Matrix.mulVecLin (-(P⁻¹ * C))) = LinearMap.ker (Matrix.mulVecLin C) := by
  ext b; simp only [LinearMap.mem_ker, Matrix.mulVecLin_apply]
  constructor
  · intro h
    calc C *ᵥ b = (P * (P⁻¹ * C)) *ᵥ b := by rw [← Matrix.mul_assoc, mul_nonsing_inv _ hP, Matrix.one_mul]
      _ = P *ᵥ ((P⁻¹ * C) *ᵥ b) := (mulVec_mulVec _ _ _).symm
      _ = P *ᵥ (-((-(P⁻¹ * C)) *ᵥ b)) := by rw [neg_mulVec, neg_neg]
      _ = 0 := by rw [h, neg_zero, mulVec_zero]
  · intro h; rw [neg_mulVec, ← mulVec_mulVec, h, mulVec_zero, neg_zero]

theorem exists_sync_iff (Pmm : Matrix m m ℝ) (Pmk : Matrix m k ℝ) (Pll : Matrix l l ℝ)
    (Plk : Matrix l k ℝ) (hm : IsUnit Pmm.det) (hl : IsUnit Pll.det) :
    (∃ σ : Matrix l m ℝ, ∀ b, (-(Pll⁻¹ * Plk)) *ᵥ b = σ *ᵥ ((-(Pmm⁻¹ * Pmk)) *ᵥ b)) ↔
      LinearMap.ker (Matrix.mulVecLin Pmk) ≤ LinearMap.ker (Matrix.mulVecLin Plk) := by
  rw [← ker_neg_inv_mul Pmm Pmk hm, ← ker_neg_inv_mul Pll Plk hl, ← exists_factor_iff]
  constructor
  · rintro ⟨σ, hσ⟩
    exact ⟨Matrix.mulVecLin σ, LinearMap.ext fun b => (hσ b).symm⟩
  · rintro ⟨h, hh⟩
    exact ⟨LinearMap.toMatrix' h, fun b => by
      rw [LinearMap.toMatrix'_mulVec]; exact (congrArg (fun F => F b) hh).symm⟩

/-- A blanket whose internal states read nothing of the blanket, while the external states do,
has no map from internal to external modes. -/
theorem no_sync_witness :
    ¬ ∃ σ : Matrix (Fin 1) (Fin 1) ℝ, ∀ b : Fin 1 → ℝ,
      (-((1 : Matrix (Fin 1) (Fin 1) ℝ)⁻¹ * 1)) *ᵥ b =
        σ *ᵥ ((-((1 : Matrix (Fin 1) (Fin 1) ℝ)⁻¹ * 0)) *ᵥ b) := by
  rintro ⟨σ, hσ⟩
  have := congrFun (hσ fun _ => 1) 0
  simp [Matrix.neg_mulVec, Matrix.mulVec, dotProduct] at this

end LinearBlanketsDraft
