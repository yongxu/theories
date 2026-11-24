import Mathlib.Algebra.BigOperators.Field
import Mathlib.LinearAlgebra.Dimension.Constructions
import Mathlib.LinearAlgebra.FiniteDimensional.Lemmas
import Mathlib.Tactic

/-!
# Shared Finite Probability Laws & Krylov Rank Stabilization (`FiniteProbKrylov`)

AI-written (Wave 1, 24 November 2026). Self-contained Mathlib v4.30.0-rc2 periphery foundation
for `ObservationalFidelity`, `SurvivalDistinguishability`, `ConsequenceDuality`, and
`DualityBridges`. Uses only Lean's three standard axioms (`propext`, `Classical.choice`,
`Quot.sound`), with `0` `sorryAx`, `0` `private`/`lemma`/`class`/unnamed `instance`, and `0`
forbidden market words in declaration names.

## Contents

1. **`namespace FiniteProb`:** finite probability laws `FinDist`, `diracDist`, `pushforward`,
   total-variation metric `tvDist` (`tvDist_eq_zero_iff`, triangle inequality, data processing),
   query-image mass outside `massOutside`, `optimal_query_tv_floor`, and `empty_source_infeasible`.
2. **`namespace FiniteKrylov`:** arbitrary-seed transition operator `stepOp` / `stepLinearMap`,
   action-word vectors `wordVec` / `survVec`, subspace stabilization in rank form
   `krylovSub_stabilizes_before_rank`, `Fintype.card S - 1` specialization, exact fiber-lumpability
   predicate `FiberLumpable`, and observable-horizon reduction
   `survival_indistinguishable_iff_le_obs_pred` (non-trivial for substochastic weights; normalized
   kernels always yield `survVec = 1`).
-/

namespace FiniteProb

open scoped BigOperators
open Classical

/-- Probability distribution on a finite carrier `U` with weights summing to `1`. -/
structure FinDist (U : Type*) [Fintype U] where
  w : U → ℝ
  nonneg : ∀ u, 0 ≤ w u
  sum_eq_one : ∑ u, w u = 1

theorem FinDist.ext {U : Type*} [Fintype U] {p q : FinDist U} (h : ∀ u, p.w u = q.w u) :
    p = q := by
  cases p
  cases q
  congr 1
  exact funext h

/-- Point-mass (Dirac) distribution at `u₀ : U`. -/
noncomputable def diracDist {U : Type*} [Fintype U] [DecidableEq U] (u₀ : U) : FinDist U where
  w u := if u = u₀ then 1 else 0
  nonneg u := by split_ifs <;> norm_num
  sum_eq_one := by simp

/-- Pushforward distribution `f_* p` along any total map `f : U → Y`. -/
noncomputable def pushforward {U Y : Type*} [Fintype U] [Fintype Y]
    (f : U → Y) (p : FinDist U) : FinDist Y where
  w y := ∑ u, if f u = y then p.w u else 0
  nonneg y := Finset.sum_nonneg fun u _ => by
    split_ifs
    · exact p.nonneg u
    · exact le_rfl
  sum_eq_one := by
    rw [Finset.sum_comm]
    calc ∑ u : U, ∑ y : Y, (if f u = y then p.w u else 0)
        = ∑ u : U, p.w u := Finset.sum_congr rfl fun u _ => by simp
      _ = 1 := p.sum_eq_one

theorem pushforward_comp {U Y Z : Type*} [Fintype U] [Fintype Y] [Fintype Z]
    (g : Y → Z) (f : U → Y) (p : FinDist U) :
    pushforward (g ∘ f) p = pushforward g (pushforward f p) := by
  refine FinDist.ext fun z => ?_
  dsimp only [pushforward, Function.comp]
  calc ∑ u : U, (if g (f u) = z then p.w u else 0)
      = ∑ u : U, ∑ y : Y, (if f u = y then (if g y = z then p.w u else 0) else 0) :=
        Finset.sum_congr rfl fun u _ => by
          have h1 : (∑ y : Y, if f u = y then (if g y = z then p.w u else 0) else 0) =
              if g (f u) = z then p.w u else 0 := by simp
          exact h1.symm
    _ = ∑ y : Y, ∑ u : U, (if f u = y then (if g y = z then p.w u else 0) else 0) :=
        Finset.sum_comm
    _ = ∑ y : Y, if g y = z then (∑ u : U, if f u = y then p.w u else 0) else 0 :=
        Finset.sum_congr rfl fun y _ => by
          split_ifs with hg
          · rfl
          · simp

/-- Normalized total variation distance `(1/2) * ∑ y, |μ.w y - ν.w y|` on finite `Y`. -/
noncomputable def tvDist {Y : Type*} [Fintype Y] (μ ν : FinDist Y) : ℝ :=
  (1 / 2 : ℝ) * ∑ y, |μ.w y - ν.w y|

theorem tvDist_nonneg {Y : Type*} [Fintype Y] (μ ν : FinDist Y) : 0 ≤ tvDist μ ν := by
  unfold tvDist
  exact mul_nonneg (by norm_num) (Finset.sum_nonneg fun y _ => abs_nonneg _)

theorem tvDist_self {Y : Type*} [Fintype Y] (μ : FinDist Y) : tvDist μ μ = 0 := by
  unfold tvDist
  simp

theorem tvDist_symm {Y : Type*} [Fintype Y] (μ ν : FinDist Y) : tvDist μ ν = tvDist ν μ := by
  unfold tvDist
  congr 1
  exact Finset.sum_congr rfl fun y _ => abs_sub_comm (μ.w y) (ν.w y)

theorem tvDist_eq_zero_iff {Y : Type*} [Fintype Y] (μ ν : FinDist Y) :
    tvDist μ ν = 0 ↔ μ = ν := by
  constructor
  · intro hT0
    have hsum0 : ∑ y : Y, |μ.w y - ν.w y| = 0 := by
      unfold tvDist at hT0
      linarith
    exact FinDist.ext fun y => sub_eq_zero.mp (abs_eq_zero.mp
      ((Finset.sum_eq_zero_iff_of_nonneg fun _ _ => abs_nonneg _).mp hsum0 y (Finset.mem_univ y)))
  · rintro rfl
    exact tvDist_self μ

theorem tvDist_triangle {Y : Type*} [Fintype Y] (μ ρ ν : FinDist Y) :
    tvDist μ ν ≤ tvDist μ ρ + tvDist ρ ν := by
  unfold tvDist
  rw [← mul_add, ← Finset.sum_add_distrib]
  refine mul_le_mul_of_nonneg_left (Finset.sum_le_sum fun y _ => ?_) (by norm_num)
  exact abs_sub_le (μ.w y) (ρ.w y) (ν.w y)

/-- Data-processing inequality: post-composing by any total map `g : Y → Z` cannot increase TV distance. -/
theorem tvDist_pushforward_le {Y Z : Type*} [Fintype Y] [Fintype Z]
    (g : Y → Z) (μ ν : FinDist Y) :
    tvDist (pushforward g μ) (pushforward g ν) ≤ tvDist μ ν := by
  unfold tvDist pushforward
  refine mul_le_mul_of_nonneg_left ?_ (by norm_num)
  calc ∑ z : Z, |(∑ y : Y, if g y = z then μ.w y else 0) - (∑ y : Y, if g y = z then ν.w y else 0)|
      = ∑ z : Z, |∑ y : Y, (if g y = z then μ.w y - ν.w y else 0)| := by
        refine Finset.sum_congr rfl fun z _ => ?_
        rw [← Finset.sum_sub_distrib]
        congr 1
        refine Finset.sum_congr rfl fun y _ => ?_
        split_ifs <;> ring
    _ ≤ ∑ z : Z, ∑ y : Y, |if g y = z then μ.w y - ν.w y else 0| :=
        Finset.sum_le_sum fun z _ => Finset.abs_sum_le_sum_abs _ _
    _ = ∑ y : Y, ∑ z : Z, (if g y = z then |μ.w y - ν.w y| else 0) := by
        rw [Finset.sum_comm]
        refine Finset.sum_congr rfl fun y _ => Finset.sum_congr rfl fun z _ => ?_
        split_ifs <;> simp
    _ = ∑ y : Y, |μ.w y - ν.w y| :=
        Finset.sum_congr rfl fun y _ => by simp

/-- Query mass of `lam0` lying outside the image `im(f)` of a total map `f : U → O`. -/
noncomputable def massOutside {U O : Type*} [Fintype U] [Fintype O]
    (f : U → O) (lam0 : FinDist O) : ℝ :=
  ∑ o : O, if (∃ u : U, f u = o) then 0 else lam0.w o

theorem massOutside_nonneg {U O : Type*} [Fintype U] [Fintype O]
    (f : U → O) (lam0 : FinDist O) : 0 ≤ massOutside f lam0 :=
  Finset.sum_nonneg fun o _ => by
    split_ifs
    · exact le_rfl
    · exact lam0.nonneg o

/-- **Exact Query-Image TV Blindness Floor (`O1` / `v7 G.1`):**
1. For ALL local distributions `ν : FinDist U`, `massOutside (q ∘ χ) (pushforward q μ) ≤ tvDist (pushforward (q ∘ χ) ν) (pushforward q μ)`.
2. Provided `U` is nonempty (`[Nonempty U]`), there exists an explicit witness `ν : FinDist U` achieving
   equality (`tvDist = massOutside`). -/
theorem optimal_query_tv_floor {U V O : Type*} [Fintype U] [Fintype V] [Fintype O]
    (χ : U → V) (q : V → O) (μ : FinDist V) :
    (∀ ν : FinDist U,
      massOutside (q ∘ χ) (pushforward q μ) ≤ tvDist (pushforward (q ∘ χ) ν) (pushforward q μ)) ∧
    (Nonempty U → ∃ ν : FinDist U,
      tvDist (pushforward (q ∘ χ) ν) (pushforward q μ) = massOutside (q ∘ χ) (pushforward q μ)) := by
  let f : U → O := q ∘ χ
  let lam0 : FinDist O := pushforward q μ
  constructor
  · intro ν
    let p : FinDist O := pushforward f ν
    have hp_zero : ∀ o : O, ¬ (∃ u : U, f u = o) → p.w o = 0 := by
      intro o ho
      dsimp only [p, pushforward]
      refine Finset.sum_eq_zero fun u _ => ?_
      rw [if_neg (fun eq => ho ⟨u, eq⟩)]
    have hsum_in : (∑ o : O, if (∃ u : U, f u = o) then p.w o else 0) = 1 := by
      have hsplit : (∑ o : O, p.w o) =
          (∑ o : O, if (∃ u : U, f u = o) then p.w o else 0) +
          (∑ o : O, if (∃ u : U, f u = o) then 0 else p.w o) := by
        rw [← Finset.sum_add_distrib]
        refine Finset.sum_congr rfl fun o _ => by split_ifs <;> ring
      have hout : (∑ o : O, if (∃ u : U, f u = o) then 0 else p.w o) = 0 :=
        Finset.sum_eq_zero fun o _ => by
          split_ifs with h
          · rfl
          · exact hp_zero o h
      linarith [p.sum_eq_one]
    have hlam_split : (∑ o : O, if (∃ u : U, f u = o) then lam0.w o else 0) + massOutside f lam0 = 1 := by
      unfold massOutside
      rw [← Finset.sum_add_distrib]
      calc ∑ o : O, ((if ∃ u, f u = o then lam0.w o else 0) + (if ∃ u, f u = o then 0 else lam0.w o))
          = ∑ o : O, lam0.w o := Finset.sum_congr rfl fun o _ => by split_ifs <;> ring
        _ = 1 := lam0.sum_eq_one
    have hdiff_in :
        massOutside f lam0 ≤ ∑ o : O, if (∃ u : U, f u = o) then |p.w o - lam0.w o| else 0 := by
      have h1 : massOutside f lam0 =
          ∑ o : O, if (∃ u : U, f u = o) then (p.w o - lam0.w o) else 0 := by
        have hsplit : (∑ o : O, if (∃ u : U, f u = o) then (p.w o - lam0.w o) else 0) =
            (∑ o : O, if (∃ u : U, f u = o) then p.w o else 0) -
            (∑ o : O, if (∃ u : U, f u = o) then lam0.w o else 0) := by
          rw [← Finset.sum_sub_distrib]
          refine Finset.sum_congr rfl fun o _ => by split_ifs <;> ring
        linarith
      rw [h1]
      refine Finset.sum_le_sum fun o _ => ?_
      split_ifs
      · exact le_abs_self _
      · exact le_rfl
    have hdiff_out :
        massOutside f lam0 = ∑ o : O, if (∃ u : U, f u = o) then 0 else |p.w o - lam0.w o| := by
      unfold massOutside
      refine Finset.sum_congr rfl fun o _ => ?_
      split_ifs with h
      · rfl
      · rw [hp_zero o h, zero_sub, abs_neg, abs_of_nonneg (lam0.nonneg o)]
    unfold tvDist
    have htot : (∑ o : O, |p.w o - lam0.w o|) =
        (∑ o : O, if (∃ u : U, f u = o) then |p.w o - lam0.w o| else 0) +
        (∑ o : O, if (∃ u : U, f u = o) then 0 else |p.w o - lam0.w o|) := by
      rw [← Finset.sum_add_distrib]
      refine Finset.sum_congr rfl fun o _ => by split_ifs <;> ring
    change massOutside f lam0 ≤ (1 / 2 : ℝ) * ∑ o : O, |p.w o - lam0.w o|
    linarith
  · intro ⟨u₀⟩
    let b : ℝ := massOutside f lam0
    let pickU : O → U := fun o => if h : ∃ u : U, f u = o then Classical.choose h else u₀
    have hpickU : ∀ o (h : ∃ u : U, f u = o), f (pickU o) = o := by
      intro o h
      dsimp only [pickU]
      rw [dif_pos h]
      exact Classical.choose_spec h
    let wν : U → ℝ := fun u =>
      (if u = u₀ then b else 0) + ∑ o : O, if (∃ u', f u' = o) ∧ pickU o = u then lam0.w o else 0
    have hw_nonneg : ∀ u, 0 ≤ wν u := fun u => by
      refine add_nonneg (by split_ifs <;> [exact massOutside_nonneg f lam0; exact le_rfl]) ?_
      refine Finset.sum_nonneg fun o _ => by
        split_ifs
        · exact lam0.nonneg o
        · exact le_rfl
    have hw_sum : ∑ u : U, wν u = 1 := by
      dsimp only [wν]
      rw [Finset.sum_add_distrib, Finset.sum_comm]
      have h1 : (∑ u : U, if u = u₀ then b else 0) = b := by simp
      have h2 : (∑ o : O, ∑ u : U, if (∃ u', f u' = o) ∧ pickU o = u then lam0.w o else 0) =
          ∑ o : O, if (∃ u', f u' = o) then lam0.w o else 0 := by
        refine Finset.sum_congr rfl fun o _ => ?_
        split_ifs with ho
        · calc ∑ u : U, (if (∃ u', f u' = o) ∧ pickU o = u then lam0.w o else 0)
              = ∑ u : U, if pickU o = u then lam0.w o else 0 :=
                Finset.sum_congr rfl fun u _ => by simp [ho]
            _ = lam0.w o := by simp
        · exact Finset.sum_eq_zero fun u _ => by simp [ho]
      rw [h1, h2]
      have hfull : b + (∑ o : O, if (∃ u', f u' = o) then lam0.w o else 0) = ∑ o : O, lam0.w o := by
        dsimp only [b, massOutside]
        rw [← Finset.sum_add_distrib]
        exact Finset.sum_congr rfl fun o _ => by split_ifs <;> ring
      linarith [lam0.sum_eq_one]
    let ν : FinDist U := ⟨wν, hw_nonneg, hw_sum⟩
    refine ⟨ν, ?_⟩
    have hpf : ∀ o : O, (pushforward f ν).w o =
        (if o = f u₀ then b else 0) + (if (∃ u', f u' = o) then lam0.w o else 0) := by
      intro o
      dsimp only [pushforward, ν, wν]
      rw [Finset.sum_congr rfl (fun u _ => by
        have hsplit : (if f u = o then ((if u = u₀ then b else 0) +
            ∑ o' : O, if (∃ u', f u' = o') ∧ pickU o' = u then lam0.w o' else 0) else 0) =
            (if f u = o ∧ u = u₀ then b else 0) +
            ∑ o' : O, if f u = o ∧ (∃ u', f u' = o') ∧ pickU o' = u then lam0.w o' else 0 := by
          by_cases hfu : f u = o
          · rw [if_pos hfu]
            congr 1
            · by_cases hu0 : u = u₀
              · rw [if_pos hu0, if_pos ⟨hfu, hu0⟩]
              · rw [if_neg hu0, if_neg (fun h => hu0 h.2)]
            · refine Finset.sum_congr rfl fun o' _ => ?_
              by_cases hc : (∃ u', f u' = o') ∧ pickU o' = u
              · rw [if_pos hc, if_pos ⟨hfu, hc⟩]
              · rw [if_neg hc, if_neg (fun h => hc h.2)]
          · rw [if_neg hfu, if_neg (fun h => hfu h.1), zero_add]
            exact (Finset.sum_eq_zero fun o' _ => if_neg (fun h => hfu h.1)).symm
        exact hsplit)]
      rw [Finset.sum_add_distrib]
      have ha : (∑ u : U, if f u = o ∧ u = u₀ then b else 0) = if o = f u₀ then b else 0 := by
        have hb : (∑ u : U, if f u = o ∧ u = u₀ then b else 0) =
            ∑ u : U, if u = u₀ then (if o = f u₀ then b else 0) else 0 := by
          refine Finset.sum_congr rfl fun u _ => ?_
          split_ifs <;> simp_all
        rw [hb]
        simp
      have hc : (∑ u : U, ∑ o' : O, if f u = o ∧ (∃ u', f u' = o') ∧ pickU o' = u then lam0.w o' else 0) =
          if (∃ u', f u' = o) then lam0.w o else 0 := by
        rw [Finset.sum_comm]
        have hd : ∀ o' : O, (∑ u : U, if f u = o ∧ (∃ u', f u' = o') ∧ pickU o' = u then lam0.w o' else 0) =
            if o' = o ∧ (∃ u', f u' = o') then lam0.w o' else 0 := by
          intro o'
          by_cases hex : ∃ u', f u' = o'
          · have hfu := hpickU o' hex
            have heq : (∑ u : U, if f u = o ∧ (∃ u', f u' = o') ∧ pickU o' = u then lam0.w o' else 0) =
                ∑ u : U, if pickU o' = u then (if o' = o then lam0.w o' else 0) else 0 := by
              refine Finset.sum_congr rfl fun u _ => ?_
              split_ifs with h1 h2 h3 <;> simp_all
            rw [heq]
            simp [hex]
          · simp [hex]
        rw [Finset.sum_congr rfl fun o' _ => hd o']
        split_ifs with ho
        · have hcongr : ∀ o' : O,
              (if o' = o ∧ (∃ u', f u' = o') then lam0.w o' else 0) =
              (if o' = o then lam0.w o' else 0) := fun o' => by
            by_cases hoeq : o' = o
            · subst hoeq; simp [ho]
            · simp [hoeq]
          rw [Finset.sum_congr rfl fun o' _ => hcongr o']
          simp
        · exact Finset.sum_eq_zero fun o' _ => by
            split_ifs with h1
            · exact absurd (h1.1 ▸ h1.2) ho
            · rfl
      rw [ha, hc]
    unfold tvDist
    have hterms : ∀ o : O, |(pushforward f ν).w o - lam0.w o| =
        (if o = f u₀ then b else 0) + (if (∃ u', f u' = o) then 0 else lam0.w o) := by
      intro o
      rw [hpf o]
      by_cases hbase : o = f u₀
      · have hex : ∃ u', f u' = o := ⟨u₀, hbase.symm⟩
        rw [if_pos hbase, if_pos hex, if_pos hex]
        have eq1 : b + lam0.w o - lam0.w o = b := by ring
        rw [eq1, add_zero, abs_of_nonneg (massOutside_nonneg f lam0)]
      · rw [if_neg hbase, zero_add]
        by_cases hex : ∃ u', f u' = o
        · rw [if_pos hex, if_pos hex, sub_self, abs_zero, zero_add]
        · rw [if_neg hex, if_neg hex, zero_sub, abs_neg, abs_of_nonneg (lam0.nonneg o), zero_add]
    calc (1 / 2 : ℝ) * ∑ o : O, |(pushforward f ν).w o - lam0.w o|
        = (1 / 2 : ℝ) * ∑ o : O, ((if o = f u₀ then b else 0) + (if (∃ u', f u' = o) then 0 else lam0.w o)) :=
          congrArg (fun x => (1 / 2 : ℝ) * x) (Finset.sum_congr rfl fun o _ => hterms o)
      _ = (1 / 2 : ℝ) * (b + b) := by
          rw [Finset.sum_add_distrib]
          simp [b, massOutside]
      _ = b := by ring

/-- When `U` is empty, `FinDist U` is empty (no local probability law exists). -/
theorem empty_source_infeasible {U : Type*} [Fintype U] (h : IsEmpty U) : IsEmpty (FinDist U) :=
  ⟨fun p => by
    have hs := p.sum_eq_one
    rw [Finset.sum_eq_zero (fun u _ => False.elim (h.false u))] at hs
    norm_num at hs⟩

end FiniteProb

namespace FiniteKrylov

open scoped BigOperators
open Classical

/-- One-step linear transfer operator for transition matrix `M : S → S → ℝ`. -/
noncomputable def stepOp {S : Type*} [Fintype S] (M : S → S → ℝ) (v : S → ℝ) : S → ℝ :=
  fun s => ∑ s' : S, M s s' * v s'

/-- `stepOp` as a linear map on `S → ℝ`. -/
noncomputable def stepLinearMap {S : Type*} [Fintype S] (M : S → S → ℝ) :
    (S → ℝ) →ₗ[ℝ] (S → ℝ) where
  toFun := stepOp M
  map_add' x y := by
    ext s
    simp only [stepOp, Pi.add_apply, mul_add, Finset.sum_add_distrib]
  map_smul' r x := by
    ext s
    simp only [stepOp, Pi.smul_apply, smul_eq_mul, RingHom.id_apply, Finset.mul_sum]
    refine Finset.sum_congr rfl fun s' _ => by ring

/-- Action-word transfer applied to initial potential `v₀ : S → ℝ`. -/
noncomputable def wordVec {S Act : Type*} [Fintype S] (K : Act → S → S → ℝ) (v₀ : S → ℝ) :
    List Act → S → ℝ
  | [] => v₀
  | a :: w => stepOp (K a) (wordVec K v₀ w)

/-- Finite-horizon survival vector `wordVec K (fun _ => 1) w`. -/
noncomputable def survVec {S Act : Type*} [Fintype S] (K : Act → S → S → ℝ) : List Act → S → ℝ :=
  wordVec K (fun _ => 1)

/-- Subspace spanned by all `wordVec K v₀ w` of word length at most `k`. -/
noncomputable def krylovSub {S Act : Type*} [Fintype S] (K : Act → S → S → ℝ) (v₀ : S → ℝ)
    (k : ℕ) : Submodule ℝ (S → ℝ) :=
  Submodule.span ℝ {v : S → ℝ | ∃ w : List Act, w.length ≤ k ∧ v = wordVec K v₀ w}

theorem krylovSub_mono {S Act : Type*} [Fintype S] (K : Act → S → S → ℝ) (v₀ : S → ℝ)
    {j k : ℕ} (hjk : j ≤ k) :
    krylovSub K v₀ j ≤ krylovSub K v₀ k := by
  refine Submodule.span_mono ?_
  rintro v ⟨w, hw, rfl⟩
  exact ⟨w, hw.trans hjk, rfl⟩

theorem stepLinearMap_mem_krylovSub_succ {S Act : Type*} [Fintype S]
    (K : Act → S → S → ℝ) (v₀ : S → ℝ) (k : ℕ) (a : Act) :
    Submodule.map (stepLinearMap (K a)) (krylovSub K v₀ k) ≤ krylovSub K v₀ (k + 1) := by
  rw [Submodule.map_le_iff_le_comap, krylovSub, Submodule.span_le]
  rintro v ⟨w, hw, rfl⟩
  refine Submodule.subset_span ⟨a :: w, by simp [hw], ?_⟩
  rfl

theorem krylovSub_step_eq_of_eq {S Act : Type*} [Fintype S]
    (K : Act → S → S → ℝ) (v₀ : S → ℝ) {k : ℕ}
    (hk : krylovSub K v₀ k = krylovSub K v₀ (k + 1)) :
    krylovSub K v₀ (k + 1) = krylovSub K v₀ (k + 2) := by
  refine le_antisymm (krylovSub_mono K v₀ (Nat.le_succ (k + 1))) ?_
  rw [krylovSub, Submodule.span_le]
  rintro v ⟨w, hw, rfl⟩
  cases w with
  | nil =>
      exact krylovSub_mono K v₀ (Nat.zero_le (k + 1))
        (Submodule.subset_span ⟨[], by simp, rfl⟩)
  | cons a w' =>
      have hw' : w'.length ≤ k + 1 := by
        simpa [List.length_cons, Nat.add_assoc] using hw
      have hmem' : wordVec K v₀ w' ∈ krylovSub K v₀ (k + 1) :=
        Submodule.subset_span ⟨w', hw', rfl⟩
      rw [← hk] at hmem'
      exact stepLinearMap_mem_krylovSub_succ K v₀ k a ⟨wordVec K v₀ w', hmem', rfl⟩

theorem krylovSub_stabilizes_from {S Act : Type*} [Fintype S]
    (K : Act → S → S → ℝ) (v₀ : S → ℝ) {k : ℕ}
    (hk : krylovSub K v₀ k = krylovSub K v₀ (k + 1)) :
    ∀ m : ℕ, k ≤ m → krylovSub K v₀ m = krylovSub K v₀ k := by
  intro m hm
  obtain ⟨d, rfl⟩ := Nat.exists_eq_add_of_le hm
  induction d with
  | zero => simp
  | succ d ih =>
      have hsucc : krylovSub K v₀ (k + d) = krylovSub K v₀ (k + d + 1) := by
        clear hm ih
        induction d with
        | zero => simpa using hk
        | succ d ihd => exact krylovSub_step_eq_of_eq K v₀ ihd
      rw [← Nat.add_assoc, ← hsucc]
      exact ih (Nat.le_add_right k d)

/-- Rank-form Krylov stabilization: any `K`-invariant finite-dimensional subspace `W` containing `v₀`
stabilizes `krylovSub K v₀` by horizon `Module.finrank ℝ W - 1` (including `v₀ = 0`). -/
theorem krylovSub_stabilizes_before_rank
    {S Mode : Type*} [Fintype S]
    (K : Mode → S → S → ℝ) (v₀ : S → ℝ)
    (W : Submodule ℝ (S → ℝ)) (hv : v₀ ∈ W)
    (hW : ∀ a, ∀ v ∈ W, stepLinearMap (K a) v ∈ W) :
    ∃ k ≤ Module.finrank ℝ W - 1,
      krylovSub K v₀ k = krylovSub K v₀ (k + 1) := by
  by_cases hv0 : v₀ = 0
  · subst hv0
    refine ⟨0, Nat.zero_le _, ?_⟩
    have hword : ∀ u : List Mode, wordVec K (0 : S → ℝ) u = 0 := by
      intro u
      induction u with
      | nil => rfl
      | cons a u' ih =>
          ext s
          simp [wordVec, stepOp, ih]
    have hzero : ∀ (m : ℕ), krylovSub K (0 : S → ℝ) m = ⊥ := by
      intro m
      rw [krylovSub, eq_bot_iff, Submodule.span_le]
      rintro v ⟨w, _, rfl⟩
      simp [hword w]
    rw [hzero 0, hzero 1]
  · have hwordW : ∀ w : List Mode, wordVec K v₀ w ∈ W := by
      intro w
      induction w with
      | nil => exact hv
      | cons a w' ih =>
          change stepLinearMap (K a) (wordVec K v₀ w') ∈ W
          exact hW a _ ih
    have hleW : ∀ m : ℕ, krylovSub K v₀ m ≤ W := fun m => by
      rw [krylovSub, Submodule.span_le]
      rintro v ⟨w, _, rfl⟩
      exact hwordW w
    have hW_pos : 0 < Module.finrank ℝ W := by
      have hneW : W ≠ ⊥ := fun hbot => hv0 ((Submodule.mem_bot ℝ).mp (hbot ▸ hv))
      simpa using Submodule.finrank_lt_finrank_of_lt (bot_lt_iff_ne_bot.mpr hneW)
    by_contra hno
    push Not at hno
    have hstrict : ∀ k ≤ Module.finrank ℝ W - 1,
        krylovSub K v₀ k < krylovSub K v₀ (k + 1) :=
      fun k hk => lt_of_le_of_ne (krylovSub_mono K v₀ (Nat.le_succ k)) (hno k hk)
    have hrank_bound : ∀ k ≤ Module.finrank ℝ W,
        k + 1 ≤ Module.finrank ℝ (krylovSub K v₀ k) := by
      intro k hk
      induction k with
      | zero =>
          have hmem0 : v₀ ∈ krylovSub K v₀ 0 :=
            Submodule.subset_span ⟨[], by simp, rfl⟩
          have hne_bot : krylovSub K v₀ 0 ≠ ⊥ := fun hbot =>
            hv0 ((Submodule.mem_bot ℝ).mp (hbot ▸ hmem0))
          have hlt0 : 0 < Module.finrank ℝ (krylovSub K v₀ 0) := by
            simpa using Submodule.finrank_lt_finrank_of_lt (bot_lt_iff_ne_bot.mpr hne_bot)
          omega
      | succ k ih =>
          have hk_pred : k ≤ Module.finrank ℝ W - 1 := by omega
          have hprev := ih (Nat.le_of_lt hk)
          have hlt := Submodule.finrank_lt_finrank_of_lt (hstrict k hk_pred)
          omega
    have htop := hrank_bound (Module.finrank ℝ W) le_rfl
    have hle_space : Module.finrank ℝ (krylovSub K v₀ (Module.finrank ℝ W)) ≤
        Module.finrank ℝ W := Submodule.finrank_mono (hleW _)
    omega

theorem krylovSub_stabilizes_before_card {S Act : Type*} [Fintype S] [Nonempty S]
    (K : Act → S → S → ℝ) (v₀ : S → ℝ) :
    ∃ k ≤ Fintype.card S - 1, krylovSub K v₀ k = krylovSub K v₀ (k + 1) := by
  have hrank : Module.finrank ℝ (⊤ : Submodule ℝ (S → ℝ)) = Fintype.card S := by
    rw [finrank_top, Module.finrank_fintype_fun_eq_card ℝ]
  obtain ⟨k, hk, heq⟩ :=
    krylovSub_stabilizes_before_rank K v₀ ⊤ trivial (fun _ _ _ => trivial)
  rw [hrank] at hk
  exact ⟨k, hk, heq⟩

theorem wordVec_mem_krylovSub_pred {S Act : Type*} [Fintype S] [Nonempty S]
    (K : Act → S → S → ℝ) (v₀ : S → ℝ) (w : List Act) :
    wordVec K v₀ w ∈ krylovSub K v₀ (Fintype.card S - 1) := by
  obtain ⟨k, hk_le, hk_eq⟩ := krylovSub_stabilizes_before_card K v₀
  have hmem_len : wordVec K v₀ w ∈ krylovSub K v₀ w.length :=
    Submodule.subset_span ⟨w, le_rfl, rfl⟩
  by_cases hle : w.length ≤ k
  · exact krylovSub_mono K v₀ hk_le (krylovSub_mono K v₀ hle hmem_len)
  · have hge : k ≤ w.length := Nat.le_of_not_ge hle
    have hstab_w := krylovSub_stabilizes_from K v₀ hk_eq w.length hge
    have hstab_pred := krylovSub_stabilizes_from K v₀ hk_eq (Fintype.card S - 1) hk_le
    rw [hstab_w] at hmem_len
    rw [hstab_pred]
    exact hmem_len

/-- Exact observable fiber lumpability of real matrix family `K` along `f : S → O`.
Informative primarily for substochastic survival matrices (normalized Markov kernels always give
`survVec K w = 1`). -/
def FiberLumpable {S O Mode : Type*} [Fintype S]
    (f : S → O) (K : Mode → S → S → ℝ) : Prop :=
  ∀ a s t, f s = f t → ∀ o : O,
    (∑ u, if f u = o then K a s u else 0) =
    (∑ u, if f u = o then K a t u else 0)

/-- Pullback linear map `(O → ℝ) →ₗ[ℝ] (S → ℝ)` along `f : S → O`. -/
noncomputable def pullbackLinear {S O : Type*} (f : S → O) :
    (O → ℝ) →ₗ[ℝ] (S → ℝ) where
  toFun g s := g (f s)
  map_add' _ _ := rfl
  map_smul' _ _ := rfl

theorem mem_range_pullbackLinear_iff {S O : Type*} (f : S → O) (v : S → ℝ) :
    v ∈ LinearMap.range (pullbackLinear f) ↔ ∀ s t, f s = f t → v s = v t := by
  constructor
  · rintro ⟨g, rfl⟩ s t hst
    simp [pullbackLinear, hst]
  · intro h
    let g : O → ℝ := fun o => if ho : ∃ s : S, f s = o then v (Classical.choose ho) else 0
    refine ⟨g, funext fun s => ?_⟩
    have ho : ∃ s' : S, f s' = f s := ⟨s, rfl⟩
    dsimp only [pullbackLinear, LinearMap.coe_mk, AddHom.coe_mk, g]
    rw [dif_pos ho]
    exact h _ _ (Classical.choose_spec ho)

/-- **B1 + B2 Observable-Horizon Reduction (`survival_indistinguishable_iff_le_obs_pred`):**
When `K : Mode → S → S → ℝ` is `FiberLumpable` along `f : S → O`, all-word agreement on
`survVec K` reduces to horizon `≤ Fintype.card O - 1` (bypassing `Fintype.card S - 1`). -/
theorem survival_indistinguishable_iff_le_obs_pred
    {S O Mode : Type*} [Fintype S] [Fintype O]
    (f : S → O) (K : Mode → S → S → ℝ)
    (hK : FiberLumpable f K) (x y : S) :
    (∀ w : List Mode, survVec K w x = survVec K w y) ↔
      (∀ w : List Mode, w.length ≤ Fintype.card O - 1 → survVec K w x = survVec K w y) := by
  refine ⟨fun h w _ => h w, fun hshort w => ?_⟩
  let W := LinearMap.range (pullbackLinear f)
  have hv0 : (fun _ : S => (1 : ℝ)) ∈ W :=
    (mem_range_pullbackLinear_iff f _).mpr fun _ _ _ => rfl
  have hsum_regroup : ∀ (a : Mode) (s : S) (g : O → ℝ),
      (∑ u : S, K a s u * g (f u)) =
        ∑ o : O, (∑ u : S, if f u = o then K a s u else 0) * g o := by
    intro a s g
    calc ∑ u : S, K a s u * g (f u)
        = ∑ u : S, ∑ o : O, (if f u = o then K a s u * g o else 0) :=
          Finset.sum_congr rfl fun u _ => by simp
      _ = ∑ o : O, ∑ u : S, (if f u = o then K a s u else 0) * g o := by
          rw [Finset.sum_comm]
          refine Finset.sum_congr rfl fun o _ => Finset.sum_congr rfl fun u _ => ?_
          split_ifs <;> ring
      _ = ∑ o : O, (∑ u : S, if f u = o then K a s u else 0) * g o :=
          Finset.sum_congr rfl fun o _ => (Finset.sum_mul _ _ _).symm
  have hW : ∀ a, ∀ v ∈ W, stepLinearMap (K a) v ∈ W := by
    intro a v hv
    obtain ⟨g, rfl⟩ := hv
    rw [mem_range_pullbackLinear_iff]
    intro s t hst
    change stepOp (K a) (pullbackLinear f g) s = stepOp (K a) (pullbackLinear f g) t
    dsimp only [stepOp, pullbackLinear, LinearMap.coe_mk, AddHom.coe_mk]
    rw [hsum_regroup a s g, hsum_regroup a t g]
    refine Finset.sum_congr rfl fun o _ => ?_
    rw [hK a s t hst o]
  obtain ⟨k, hk_rank, hk_eq⟩ := krylovSub_stabilizes_before_rank K (fun _ => 1) W hv0 hW
  have hW_card : Module.finrank ℝ W ≤ Fintype.card O := by
    have h1 := LinearMap.finrank_range_le (pullbackLinear f)
    rwa [Module.finrank_fintype_fun_eq_card ℝ] at h1
  have hk_obs : k ≤ Fintype.card O - 1 := le_trans hk_rank (Nat.sub_le_sub_right hW_card 1)
  have hmem_len : survVec K w ∈ krylovSub K (fun _ => 1) w.length :=
    Submodule.subset_span ⟨w, le_rfl, rfl⟩
  have hmem : survVec K w ∈ krylovSub K (fun _ => 1) (Fintype.card O - 1) := by
    by_cases hle : w.length ≤ k
    · exact krylovSub_mono K _ hk_obs (krylovSub_mono K _ hle hmem_len)
    · have hge : k ≤ w.length := Nat.le_of_not_ge hle
      have hsw := krylovSub_stabilizes_from K (fun _ => 1) hk_eq w.length hge
      have hsp := krylovSub_stabilizes_from K (fun _ => 1) hk_eq (Fintype.card O - 1) hk_obs
      rw [hsw] at hmem_len
      rw [hsp]
      exact hmem_len
  refine Submodule.span_induction (p := fun v _ => v x = v y) ?_ rfl ?_ ?_ hmem
  · rintro _ ⟨u, hu, rfl⟩; exact hshort u hu
  · intro u v _ _ hu hv; simp [hu, hv]
  · intro c u _ hu; simp [hu]

/-- Substochastic 3-state, 2-observation witness where `{0, 1}` step to `2` with weight `1` and `2`
exits with zero row: `FiberLumpable` holds, `survVec []` agrees everywhere, and length `1 = card Bool - 1 < card (Fin 3) - 1 = 2` separates fibers `{0, 1}` vs `{2}`. -/
theorem lumpable_obs_horizon_one_witness :
    let f : Fin 3 → Bool := fun s => s.val < 2
    let K : Unit → Fin 3 → Fin 3 → ℝ := fun _ s s' =>
      if s.val < 2 ∧ s'.val = 2 then 1 else 0
    FiberLumpable f K ∧
    Fintype.card Bool - 1 < Fintype.card (Fin 3) - 1 ∧
    survVec K [] 0 = survVec K [] 2 ∧
    survVec K [()] 0 = 1 ∧
    survVec K [()] 2 = 0 ∧
    ¬ (∀ w : List Unit, survVec K w 0 = survVec K w 2) := by
  intro f K
  have hLump : FiberLumpable f K := by
    intro () s t hst o
    fin_cases s <;> fin_cases t <;> fin_cases o <;>
      simp [f, K, Fin.sum_univ_three] at hst ⊢
  have hstep0 : survVec K [()] 0 = 1 := by
    simp only [survVec, wordVec, stepOp, K, Fin.sum_univ_three]
    norm_num
  have hstep2 : survVec K [()] 2 = 0 := by
    simp only [survVec, wordVec, stepOp, K, Fin.sum_univ_three]
    norm_num
  have hcard : Fintype.card Bool - 1 < Fintype.card (Fin 3) - 1 := by decide
  refine ⟨hLump, hcard, rfl, hstep0, hstep2, ?_⟩
  intro hall
  have heq := hall [()]
  rw [hstep0, hstep2] at heq
  norm_num at heq

end FiniteKrylov
