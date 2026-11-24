import Mathlib.Algebra.BigOperators.Field
import Mathlib.Tactic
import AlignmentReals
import BecomingReals
import Becoming.OplaxHistory

/-!
# Observational Fidelity, Multi-Query Separation, & Three-Regime Error Contrast (`ObservationalFidelity`)

AI-written (`Wave U6`, 24 November 2026). Formalized with Lean 4.30.0-rc2 and Mathlib over `ℝ`,
importing `AlignmentReals`, `BecomingReals`, and core module `Becoming.OplaxHistory`. Every
declaration depends only on Lean's three standard axioms (`propext`, `Classical.choice`,
`Quot.sound`), with `0` `sorryAx`, `0` `private` declarations, `0` `lemma`/`class`/unnamed
`instance` declarations, and `0` forbidden market words.

This periphery module formalizes the observational fidelity theory of `WenHeHua` (`v7` Appendix G /
`v9 formal/61`) and joins it directly onto `Becoming`'s real-valued contraction tubes and `0`-axiom
viability obstructions:

1. **Exact Query-Image TV Blindness Floor (`O1` / `v7 G.1`, `optimal_query_tv_floor`,
   `empty_source_infeasible`):** Total variation distance under pushforward satisfies data processing;
   over nonempty finite source carriers `[Nonempty U]`, the infimal realizable query TV error equals
   the exact mass outside `im(q ∘ χ)`, whereas `IsEmpty U` yields an infeasible local law space.
2. **Coarsening, Macro-Refinement, & Zero-TV vs `FiberViabilitySplit` (`v7 G.2`, `v9 formal/61 §4, §8`):**
   Post-composition coarsening lowers query TV blindness yet can conceal structural loss, macro
   refinement weakly reduces the infimal TV gap, and on `Becoming.OplaxHistory.C2CoupledAlignmentWitness`
   exact zero query TV error coexists with a full `FiberViabilitySplit`.
3. **3-Way Multi-Query Separation (`v7 G.3a`, `G.3b`, `v9 formal/61 §5`):**
   Per-query realizability (`∀ i ∃ ν_i`) strictly separates from simultaneous marginal realizability
   (`∃ ν ∀ i`), which strictly separates from joint distribution realizability (`tvDist ≥ 1/2` on uniform
   `Bool × Bool` vs diagonal support).
4. **Finite Markov Kernels & Three-Regime Multi-Step Error Contrast (`v7 G.4a`, `G.4b`):**
   Sequential composition accumulates per-step kernel TV linearly (`n * ε`); independent tensor kernels
   add marginally (`ε₁ + ε₂`); contrasting open-loop linear growth, contractive closed-loop bounds
   (`AlignmentReals.metricSlack`, `BecomingReals.iterVar_eq_metricSlack`), and coupled-feedback/concurrent
   breach (`Becoming.OplaxHistory.C2CoupledAlignmentWitness` & `reserve_disjoint_vs_serial_reconfig`).

What is not shown: empirical transition distributions or finite-sample convergence (`Rule 2`).
-/

namespace ObservationalFidelity

open scoped BigOperators
open Classical

/-! ## Part 1: Finite Probability Laws, Pushforward, TV Distance, & Query Floor (`O1` / `G.1`) -/

/-- Probability distribution on a finite carrier `U` with weights summing to `1`. -/
structure FinDist (U : Type*) [Fintype U] where
  w : U → ℝ
  nonneg : ∀ u, 0 ≤ w u
  sum_eq_one : ∑ u, w u = 1

theorem FinDist.ext {U : Type*} [Fintype U] {p q : FinDist U} (h : ∀ u, p.w u = q.w u) : p = q := by
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

/-- Normalized total variation distance `(1/2) * ∑ y, |μ y - ν y|` on finite `Y`. -/
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

theorem tvDist_triangle {Y : Type*} [Fintype Y] (μ ρ ν : FinDist Y) :
    tvDist μ ν ≤ tvDist μ ρ + tvDist ρ ν := by
  unfold tvDist
  rw [← mul_add, ← Finset.sum_add_distrib]
  refine mul_le_mul_of_nonneg_left (Finset.sum_le_sum fun y _ => ?_) (by norm_num)
  exact abs_sub_le (μ.w y) (ρ.w y) (ν.w y)

/-- **Data-Processing Inequality:** post-composing by any total map `g : Y → Z` cannot increase TV distance. -/
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

/-- **Explicit Empty-Source Trap (`v9 formal/61 §3`):**
`O1` requires `[Nonempty U]`; when `U` is empty, `FinDist U` is empty (no local probability law
exists to achieve or bound TV error). -/
theorem empty_source_infeasible {U : Type*} [Fintype U] (h : IsEmpty U) : IsEmpty (FinDist U) :=
  ⟨fun p => by
    have hs := p.sum_eq_one
    rw [Finset.sum_eq_zero (fun u _ => False.elim (h.false u))] at hs
    norm_num at hs⟩

/-! ## Part 2: Coarsening, Macro-Refinement Monotonicity, & Zero-TV vs `FiberViabilitySplit` -/

/-- **Coarsening Monotonicity (`v7 G.2`):** post-composing observation `q` with `g : O → O'`
cannot increase the TV blindness floor. -/
theorem coarsening_tv_mono {U V O O' : Type*}
    [Fintype U] [Fintype V] [Fintype O] [Fintype O']
    (χ : U → V) (q : V → O) (g : O → O') (μ : FinDist V) :
    massOutside (g ∘ q ∘ χ) (pushforward (g ∘ q) μ) ≤
      massOutside (q ∘ χ) (pushforward q μ) := by
  rw [pushforward_comp]
  unfold massOutside pushforward
  calc ∑ o' : O', (if (∃ u : U, (g ∘ q ∘ χ) u = o') then 0 else
        ∑ o : O, if g o = o' then (pushforward q μ).w o else 0)
      = ∑ o' : O', ∑ o : O, (if ¬ (∃ u : U, (g ∘ q ∘ χ) u = o') ∧ g o = o'
          then (pushforward q μ).w o else 0) := by
        refine Finset.sum_congr rfl fun o' _ => ?_
        split_ifs with h
        · exact (Finset.sum_eq_zero fun o _ => if_neg (fun ⟨hne, _⟩ => hne h)).symm
        · refine Finset.sum_congr rfl fun o _ => ?_
          split_ifs <;> simp_all
    _ = ∑ o : O, ∑ o' : O', (if ¬ (∃ u : U, (g ∘ q ∘ χ) u = o') ∧ g o = o'
          then (pushforward q μ).w o else 0) := Finset.sum_comm
    _ ≤ ∑ o : O, (if (∃ u : U, (q ∘ χ) u = o) then 0 else (pushforward q μ).w o) := by
        refine Finset.sum_le_sum fun o _ => ?_
        by_cases hgo : ∃ u : U, g (q (χ u)) = g o
        · have h0 : ∀ o' : O', ¬ (¬ (∃ u : U, (g ∘ q ∘ χ) u = o') ∧ g o = o') := by
            intro o' ⟨hne, heq⟩
            exact hne (heq ▸ hgo)
          rw [Finset.sum_eq_zero fun o' _ => if_neg (h0 o')]
          split_ifs
          · exact le_rfl
          · exact (pushforward q μ).nonneg o
        · have hnot : ¬ (∃ u : U, (q ∘ χ) u = o) := fun ⟨u, hu⟩ => hgo ⟨u, congrArg g hu⟩
          rw [if_neg hnot]
          refine le_of_eq ?_
          calc ∑ o' : O', (if ¬ (∃ u : U, (g ∘ q ∘ χ) u = o') ∧ g o = o'
                  then (pushforward q μ).w o else 0)
              = ∑ o' : O', (if g o = o' then (pushforward q μ).w o else 0) := by
                refine Finset.sum_congr rfl fun o' _ => ?_
                split_ifs with h1 h2 h2
                · rfl
                · exact absurd h1.2 h2
                · exfalso
                  have hne : ¬ (∃ u : U, g (q (χ u)) = o') := fun ⟨u, hu⟩ => hgo ⟨u, hu.trans h2.symm⟩
                  exact h1 ⟨hne, h2⟩
                · rfl
            _ = (pushforward q μ).w o := by simp

/-- **Macro-Refinement Monotonicity (`v9 formal/61 §8`):**
A finer block partition `U_fine` factoring `χ_coarse = χ_fine ∘ r` enlarges `im(q ∘ χ)` and
weakly decreases the minimum achievable TV floor. -/
theorem macro_refinement_tv_mono {Uc Uf V O : Type*}
    [Fintype Uc] [Fintype Uf] [Fintype V] [Fintype O]
    (r : Uc → Uf) (χ_fine : Uf → V) (q : V → O) (μ : FinDist V) :
    massOutside (q ∘ χ_fine) (pushforward q μ) ≤
      massOutside (q ∘ (χ_fine ∘ r)) (pushforward q μ) := by
  unfold massOutside
  refine Finset.sum_le_sum fun o _ => ?_
  by_cases hc : ∃ uc : Uc, (q ∘ (χ_fine ∘ r)) uc = o
  · obtain ⟨uc, huc⟩ := hc
    have hf : ∃ uf : Uf, (q ∘ χ_fine) uf = o := ⟨r uc, huc⟩
    have hc' : ∃ uc : Uc, (q ∘ (χ_fine ∘ r)) uc = o := ⟨uc, huc⟩
    rw [if_pos hf, if_pos hc']
  · rw [if_neg hc]
    split_ifs
    · exact (pushforward q μ).nonneg o
    · exact le_rfl

/-- **`Zero-TV` Coexists with Total `FiberViabilitySplit`:**
Connecting `Becoming.OplaxHistory.C2CoupledAlignmentWitness` to finite probability distributions:
Dirac distributions concentrated on `uInPhase = ((true, true), 1)` and `uAntiPhase = ((true, false), 1)`
agree identically (`tvDist = 0`) under the componentwise `C₂` projection `c2Proj`, while the
viability kernel separates completely (`FiberViabilitySplit`), refuting macro kernel soundness. -/
theorem zero_tv_does_not_prevent_fiber_viability_split :
    let qProj : Bool × Bool → Unit := fun _ => ()
    let pIn : FinDist (Bool × Bool) := diracDist (true, true)
    let pAnti : FinDist (Bool × Bool) := diracDist (true, false)
    tvDist (pushforward qProj pIn) (pushforward qProj pAnti) = 0 ∧
    Becoming.OplaxHistory.C2CoupledAlignmentWitness.c2ProjMicro
      Becoming.OplaxHistory.C2CoupledAlignmentWitness.uInPhase =
    Becoming.OplaxHistory.C2CoupledAlignmentWitness.c2ProjMicro
      Becoming.OplaxHistory.C2CoupledAlignmentWitness.uAntiPhase ∧
    Becoming.OplaxHistory.FiberViabilitySplit
      Becoming.OplaxHistory.C2CoupledAlignmentWitness.c2ProjMicro
      (Becoming.Viability.Kernel Becoming.OplaxHistory.C2CoupledAlignmentWitness.proc
        Becoming.OplaxHistory.C2CoupledAlignmentWitness.guardS) ∧
    ∀ Kq : Nat → Prop,
      ¬ ((∀ s, Becoming.Viability.Kernel Becoming.OplaxHistory.C2CoupledAlignmentWitness.proc
            Becoming.OplaxHistory.C2CoupledAlignmentWitness.guardS s →
            Kq (Becoming.OplaxHistory.C2CoupledAlignmentWitness.c2ProjMicro s)) ∧
         (∀ s, Kq (Becoming.OplaxHistory.C2CoupledAlignmentWitness.c2ProjMicro s) →
            Becoming.Viability.Kernel Becoming.OplaxHistory.C2CoupledAlignmentWitness.proc
              Becoming.OplaxHistory.C2CoupledAlignmentWitness.guardS s)) := by
  dsimp only
  have htv : tvDist (pushforward (fun _ : Bool × Bool => ()) (diracDist (true, true)))
      (pushforward (fun _ : Bool × Bool => ()) (diracDist (true, false))) = 0 := by
    have heq : pushforward (fun _ : Bool × Bool => ()) (diracDist (true, true)) =
        pushforward (fun _ : Bool × Bool => ()) (diracDist (true, false)) := by
      refine FinDist.ext fun () => ?_
      simp [pushforward, diracDist]
    rw [heq, tvDist_self]
  exact ⟨htv, rfl, Becoming.OplaxHistory.C2CoupledAlignmentWitness.c2_coupled_fiber_split,
    Becoming.OplaxHistory.C2CoupledAlignmentWitness.c2_coupled_no_macro_soundness⟩

/-! ## Part 3: 3-Way Multi-Query Convex Feasibility Separation (`v7 G.3a` / `G.3b`) -/

/-- Support predicate restricting a `FinDist (Bool × Bool)` to the diagonal `{(false,false), (true,true)}`. -/
def diagSupport (ν : FinDist (Bool × Bool)) : Prop :=
  ν.w (false, true) = 0 ∧ ν.w (true, false) = 0

/-- Helper showing any diagonal distribution has identical first and second marginals. -/
theorem diagSupport_fst_eq_snd {ν : FinDist (Bool × Bool)} (h : diagSupport ν) :
    pushforward Prod.fst ν = pushforward Prod.snd ν := by
  refine FinDist.ext fun b => ?_
  dsimp only [pushforward]
  cases b
  · simp [Fintype.sum_prod_type, h.1, h.2]
  · simp [Fintype.sum_prod_type, h.1, h.2]

/-- Explicit target marginal `(4/5, 1/5)` on `Bool`. -/
noncomputable def fourFifthsBool : FinDist Bool where
  w b := if b = false then (4 / 5 : ℝ) else (1 / 5 : ℝ)
  nonneg b := by cases b <;> norm_num
  sum_eq_one := by simp; norm_num

/-- Explicit opposite target marginal `(1/5, 4/5)` on `Bool`. -/
noncomputable def oneFifthBool : FinDist Bool where
  w b := if b = false then (1 / 5 : ℝ) else (4 / 5 : ℝ)
  nonneg b := by cases b <;> norm_num
  sum_eq_one := by simp; norm_num

/-- Constructive diagonal law lifting any `p : FinDist Bool` onto `Bool × Bool`. -/
noncomputable def diagLift (p : FinDist Bool) : FinDist (Bool × Bool) where
  w uv := if uv.1 = uv.2 then p.w uv.1 else 0
  nonneg uv := by
    split_ifs
    · exact p.nonneg uv.1
    · exact le_rfl
  sum_eq_one := by
    have h := p.sum_eq_one
    simp [Fintype.sum_prod_type] at h ⊢
    linarith

/-- **Multi-Query Separation 1 (`v7 G.3a`):**
Per-query realizability (`∀ i ∃ ν_i`) DOES NOT imply simultaneous realizability (`∃ ν ∀ i`).
Each of `fourFifthsBool` (for `fst`) and `oneFifthBool` (for `snd`) is individually achieved with
`TV = 0` on `diagSupport`, yet for every `ν` on `diagSupport`, `tvDist fst + tvDist snd ≥ 3/5`. -/
theorem per_query_not_implies_joint_marginal :
    (∃ ν₁ : FinDist (Bool × Bool), diagSupport ν₁ ∧
      tvDist (pushforward Prod.fst ν₁) fourFifthsBool = 0) ∧
    (∃ ν₂ : FinDist (Bool × Bool), diagSupport ν₂ ∧
      tvDist (pushforward Prod.snd ν₂) oneFifthBool = 0) ∧
    (∀ ν : FinDist (Bool × Bool), diagSupport ν →
      (3 / 5 : ℝ) ≤ tvDist (pushforward Prod.fst ν) fourFifthsBool +
        tvDist (pushforward Prod.snd ν) oneFifthBool) := by
  refine ⟨⟨diagLift fourFifthsBool, ⟨rfl, rfl⟩, ?_⟩,
          ⟨diagLift oneFifthBool, ⟨rfl, rfl⟩, ?_⟩, ?_⟩
  · have hpf : pushforward Prod.fst (diagLift fourFifthsBool) = fourFifthsBool := by
      refine FinDist.ext fun b => ?_
      cases b <;> simp [pushforward, diagLift, Fintype.sum_prod_type]
    rw [hpf, tvDist_self]
  · have hpf : pushforward Prod.snd (diagLift oneFifthBool) = oneFifthBool := by
      refine FinDist.ext fun b => ?_
      cases b <;> simp [pushforward, diagLift, Fintype.sum_prod_type]
    rw [hpf, tvDist_self]
  · intro ν hdiag
    have heq := diagSupport_fst_eq_snd hdiag
    have htri := tvDist_triangle fourFifthsBool (pushforward Prod.fst ν) oneFifthBool
    have h1 : tvDist fourFifthsBool (pushforward Prod.fst ν) =
        tvDist (pushforward Prod.fst ν) fourFifthsBool := tvDist_symm _ _
    have h2 : tvDist (pushforward Prod.fst ν) oneFifthBool =
        tvDist (pushforward Prod.snd ν) oneFifthBool := by rw [heq]
    have hdist : tvDist fourFifthsBool oneFifthBool = (3 / 5 : ℝ) := by
      unfold tvDist fourFifthsBool oneFifthBool
      simp
      norm_num
    linarith [htri, h1, h2, hdist]

/-- Uniform distribution `(1/4, 1/4, 1/4, 1/4)` on `Bool × Bool`. -/
noncomputable def uniformPairBool : FinDist (Bool × Bool) where
  w _ := (1 / 4 : ℝ)
  nonneg _ := by norm_num
  sum_eq_one := by norm_num

/-- Uniform `(1/2, 1/2)` distribution on `Bool`. -/
noncomputable def fairBool : FinDist Bool where
  w _ := (1 / 2 : ℝ)
  nonneg _ := by norm_num
  sum_eq_one := by simp

/-- **Multi-Query Separation 2 (`v7 G.3b`):**
Simultaneous marginal realizability (`∃ ν ∀ i`) DOES NOT imply joint distribution fidelity.
On `uniformPairBool`, `diagLift fairBool` matches BOTH `fst` and `snd` marginals with `TV = 0`
simultaneously, yet ANY `diagSupport` law `ν` satisfies `1/2 ≤ tvDist ν uniformPairBool` (attained
at `1/2` by `diagLift fairBool`). -/
theorem joint_marginal_not_implies_joint_dist :
    (∃ ν : FinDist (Bool × Bool), diagSupport ν ∧
      tvDist (pushforward Prod.fst ν) (pushforward Prod.fst uniformPairBool) = 0 ∧
      tvDist (pushforward Prod.snd ν) (pushforward Prod.snd uniformPairBool) = 0 ∧
      tvDist ν uniformPairBool = (1 / 2 : ℝ)) ∧
    (∀ ν : FinDist (Bool × Bool), diagSupport ν → (1 / 2 : ℝ) ≤ tvDist ν uniformPairBool) := by
  have hfst : pushforward Prod.fst uniformPairBool = fairBool := by
    refine FinDist.ext fun b => ?_
    cases b <;> simp [pushforward, uniformPairBool, fairBool, Fintype.sum_prod_type] <;> norm_num
  have hsnd : pushforward Prod.snd uniformPairBool = fairBool := by
    refine FinDist.ext fun b => ?_
    cases b <;> simp [pushforward, uniformPairBool, fairBool, Fintype.sum_prod_type] <;> norm_num
  refine ⟨⟨diagLift fairBool, ⟨rfl, rfl⟩, ?_, ?_, ?_⟩, ?_⟩
  · have hpf : pushforward Prod.fst (diagLift fairBool) = fairBool := by
      refine FinDist.ext fun b => ?_
      cases b <;> simp [pushforward, diagLift, fairBool, Fintype.sum_prod_type]
    rw [hpf, hfst, tvDist_self]
  · have hpf : pushforward Prod.snd (diagLift fairBool) = fairBool := by
      refine FinDist.ext fun b => ?_
      cases b <;> simp [pushforward, diagLift, fairBool, Fintype.sum_prod_type]
    rw [hpf, hsnd, tvDist_self]
  · unfold tvDist diagLift fairBool uniformPairBool
    simp [Fintype.sum_prod_type]
    norm_num
  · intro ν hdiag
    unfold tvDist uniformPairBool
    have hsum : ν.w (false, false) + ν.w (true, true) = 1 := by
      have hs := ν.sum_eq_one
      simp [Fintype.sum_prod_type, hdiag.1, hdiag.2] at hs
      linarith
    have hexpand : (∑ uv : Bool × Bool, |ν.w uv - (1 / 4 : ℝ)|) =
        |ν.w (false, false) - 1 / 4| + |ν.w (false, true) - 1 / 4| +
        |ν.w (true, false) - 1 / 4| + |ν.w (true, true) - 1 / 4| := by
      simp [Fintype.sum_prod_type]
      ring
    rw [hexpand, hdiag.1, hdiag.2]
    norm_num
    have h1 : ν.w (false, false) - 1 / 4 ≤ |ν.w (false, false) - 1 / 4| := le_abs_self _
    have h2 : ν.w (true, true) - 1 / 4 ≤ |ν.w (true, true) - 1 / 4| := le_abs_self _
    linarith

/-! ## Part 4: Finite Markov Kernels & Three-Regime Multi-Step Error Contrast (`G.4a` / `G.4b`) -/

/-- Finite stochastic transition kernel `X → Δ(Y)`. -/
def FinKernel (X Y : Type*) [Fintype Y] : Type _ :=
  X → FinDist Y

/-- Pushforward of a source law along a finite Markov kernel `K : FinKernel X Y`. -/
noncomputable def pushKernel {X Y : Type*} [Fintype X] [Fintype Y]
    (K : FinKernel X Y) (p : FinDist X) : FinDist Y where
  w y := ∑ x : X, p.w x * (K x).w y
  nonneg y := Finset.sum_nonneg fun x _ => mul_nonneg (p.nonneg x) ((K x).nonneg y)
  sum_eq_one := by
    rw [Finset.sum_comm]
    calc ∑ x : X, ∑ y : Y, p.w x * (K x).w y
        = ∑ x : X, p.w x * (∑ y : Y, (K x).w y) :=
          Finset.sum_congr rfl fun x _ => (Finset.mul_sum _ _ _).symm
      _ = ∑ x : X, p.w x := Finset.sum_congr rfl fun x _ => by rw [(K x).sum_eq_one, mul_one]
      _ = 1 := p.sum_eq_one

/-- Sequential composition of finite Markov kernels. -/
noncomputable def compKernel {X Y Z : Type*} [Fintype Y] [Fintype Z]
    (K₁ : FinKernel X Y) (K₂ : FinKernel Y Z) : FinKernel X Z :=
  fun x => pushKernel K₂ (K₁ x)

/-- Product distribution on `Y₁ × Y₂` of two independent finite distributions. -/
noncomputable def prodDist {Y₁ Y₂ : Type*} [Fintype Y₁] [Fintype Y₂]
    (μ₁ : FinDist Y₁) (μ₂ : FinDist Y₂) : FinDist (Y₁ × Y₂) where
  w y := μ₁.w y.1 * μ₂.w y.2
  nonneg y := mul_nonneg (μ₁.nonneg y.1) (μ₂.nonneg y.2)
  sum_eq_one := by
    rw [Fintype.sum_prod_type]
    calc ∑ y₁ : Y₁, ∑ y₂ : Y₂, μ₁.w y₁ * μ₂.w y₂
        = ∑ y₁ : Y₁, μ₁.w y₁ * (∑ y₂ : Y₂, μ₂.w y₂) :=
          Finset.sum_congr rfl fun y₁ _ => (Finset.mul_sum _ _ _).symm
      _ = 1 := by simp [μ₂.sum_eq_one, μ₁.sum_eq_one]

/-- Independent tensor product kernel `(K₁ ⊗ K₂)(x₁, x₂) = K₁(x₁) ⊗ K₂(x₂)`. -/
noncomputable def tensorKernel {X₁ X₂ Y₁ Y₂ : Type*} [Fintype Y₁] [Fintype Y₂]
    (K₁ : FinKernel X₁ Y₁) (K₂ : FinKernel X₂ Y₂) : FinKernel (X₁ × X₂) (Y₁ × Y₂) :=
  fun x => prodDist (K₁ x.1) (K₂ x.2)

/-- One-step pushforward TV bound: `tvDist (pushKernel K p) (pushKernel L q) ≤ tvDist p q + ε`. -/
theorem pushKernel_tv_step {X Y : Type*} [Fintype X] [Fintype Y]
    (K L : FinKernel X Y) {ε : ℝ} (hε : ∀ x, tvDist (K x) (L x) ≤ ε)
    (p q : FinDist X) :
    tvDist (pushKernel K p) (pushKernel L q) ≤ tvDist p q + ε := by
  unfold tvDist pushKernel
  have hstep : ∀ y : Y,
      |∑ x : X, p.w x * (K x).w y - ∑ x : X, q.w x * (L x).w y| ≤
      (∑ x : X, |p.w x - q.w x| * (K x).w y) + ∑ x : X, q.w x * |(K x).w y - (L x).w y| := by
    intro y
    have eq1 : (∑ x : X, p.w x * (K x).w y) - (∑ x : X, q.w x * (L x).w y) =
        (∑ x : X, (p.w x - q.w x) * (K x).w y) + ∑ x : X, q.w x * ((K x).w y - (L x).w y) := by
      rw [← Finset.sum_sub_distrib, ← Finset.sum_add_distrib]
      refine Finset.sum_congr rfl fun x _ => by ring
    rw [eq1]
    refine (abs_add_le _ _).trans (add_le_add ?_ ?_)
    · refine (Finset.abs_sum_le_sum_abs _ _).trans (Finset.sum_le_sum fun x _ => ?_)
      rw [abs_mul, abs_of_nonneg ((K x).nonneg y)]
    · refine (Finset.abs_sum_le_sum_abs _ _).trans (Finset.sum_le_sum fun x _ => ?_)
      rw [abs_mul, abs_of_nonneg (q.nonneg x)]
  have hsum : (∑ y : Y, |∑ x : X, p.w x * (K x).w y - ∑ x : X, q.w x * (L x).w y|) ≤
      (∑ x : X, |p.w x - q.w x|) + ∑ x : X, q.w x * ∑ y : Y, |(K x).w y - (L x).w y| := by
    calc ∑ y : Y, |∑ x : X, p.w x * (K x).w y - ∑ x : X, q.w x * (L x).w y|
        ≤ ∑ y : Y, ((∑ x : X, |p.w x - q.w x| * (K x).w y) +
            ∑ x : X, q.w x * |(K x).w y - (L x).w y|) := Finset.sum_le_sum fun y _ => hstep y
      _ = (∑ y : Y, ∑ x : X, |p.w x - q.w x| * (K x).w y) +
            (∑ y : Y, ∑ x : X, q.w x * |(K x).w y - (L x).w y|) := Finset.sum_add_distrib
      _ = (∑ x : X, |p.w x - q.w x| * ∑ y : Y, (K x).w y) +
            (∑ x : X, q.w x * ∑ y : Y, |(K x).w y - (L x).w y|) := by
          congr 1
          · rw [Finset.sum_comm]
            exact Finset.sum_congr rfl fun x _ => (Finset.mul_sum _ _ _).symm
          · rw [Finset.sum_comm]
            exact Finset.sum_congr rfl fun x _ => (Finset.mul_sum _ _ _).symm
      _ = (∑ x : X, |p.w x - q.w x|) + ∑ x : X, q.w x * ∑ y : Y, |(K x).w y - (L x).w y| := by
          congr 1
          exact Finset.sum_congr rfl fun x _ => by rw [(K x).sum_eq_one, mul_one]
  have hbound2 : (1 / 2 : ℝ) * (∑ x : X, q.w x * ∑ y : Y, |(K x).w y - (L x).w y|) ≤ ε := by
    calc (1 / 2 : ℝ) * (∑ x : X, q.w x * ∑ y : Y, |(K x).w y - (L x).w y|)
        = ∑ x : X, q.w x * ((1 / 2 : ℝ) * ∑ y : Y, |(K x).w y - (L x).w y|) := by
          rw [Finset.mul_sum]
          refine Finset.sum_congr rfl fun x _ => by ring
      _ ≤ ∑ x : X, q.w x * ε :=
          Finset.sum_le_sum fun x _ => mul_le_mul_of_nonneg_left (hε x) (q.nonneg x)
      _ = ε := by rw [← Finset.sum_mul, q.sum_eq_one, one_mul]
  have h1 : (1 / 2 : ℝ) * ∑ y : Y, |∑ x : X, p.w x * (K x).w y - ∑ x : X, q.w x * (L x).w y| ≤
      (1 / 2 : ℝ) * ((∑ x : X, |p.w x - q.w x|) + ∑ x : X, q.w x * ∑ y : Y, |(K x).w y - (L x).w y|) :=
    mul_le_mul_of_nonneg_left hsum (by norm_num)
  linarith [h1, hbound2]

/-- Iterated `n`-step distribution under homogeneous Markov kernel `K : FinKernel X X`. -/
noncomputable def iterKernel {X : Type*} [Fintype X] (K : FinKernel X X) : ℕ → FinDist X → FinDist X
  | 0, p => p
  | n + 1, p => pushKernel K (iterKernel K n p)

/-- **Sequential Kernel Composition Error Bound (`v7 G.4a`):**
If per-step transitions differ by at most `ε` in TV, `n` steps of composition accumulate at most
`tvDist p₀ q₀ + n * ε` error (so starting identically gives `≤ n * ε`). -/
theorem sequential_kernel_tv_bound {X : Type*} [Fintype X]
    (K L : FinKernel X X) {ε : ℝ} (hε : ∀ x, tvDist (K x) (L x) ≤ ε) :
    ∀ (n : ℕ) (p₀ q₀ : FinDist X),
      tvDist (iterKernel K n p₀) (iterKernel L n q₀) ≤ tvDist p₀ q₀ + (n : ℝ) * ε
  | 0, p₀, q₀ => by simp [iterKernel]
  | n + 1, p₀, q₀ => by
    have ih := sequential_kernel_tv_bound K L hε n p₀ q₀
    have hstep := pushKernel_tv_step K L hε (iterKernel K n p₀) (iterKernel L n q₀)
    dsimp only [iterKernel]
    push_cast
    linarith

/-- Product distribution TV inequality: `tvDist (μ₁ ⊗ μ₂) (ν₁ ⊗ ν₂) ≤ tvDist μ₁ ν₁ + tvDist μ₂ ν₂`. -/
theorem tvDist_prodDist_le {Y₁ Y₂ : Type*} [Fintype Y₁] [Fintype Y₂]
    (μ₁ ν₁ : FinDist Y₁) (μ₂ ν₂ : FinDist Y₂) :
    tvDist (prodDist μ₁ μ₂) (prodDist ν₁ ν₂) ≤ tvDist μ₁ ν₁ + tvDist μ₂ ν₂ := by
  refine (tvDist_triangle (prodDist μ₁ μ₂) (prodDist ν₁ μ₂) (prodDist ν₁ ν₂)).trans ?_
  have h1 : tvDist (prodDist μ₁ μ₂) (prodDist ν₁ μ₂) = tvDist μ₁ ν₁ := by
    unfold tvDist prodDist
    congr 1
    rw [Fintype.sum_prod_type]
    calc ∑ y₁ : Y₁, ∑ y₂ : Y₂, |μ₁.w y₁ * μ₂.w y₂ - ν₁.w y₁ * μ₂.w y₂|
        = ∑ y₁ : Y₁, |μ₁.w y₁ - ν₁.w y₁| * ∑ y₂ : Y₂, μ₂.w y₂ := by
          refine Finset.sum_congr rfl fun y₁ _ => ?_
          rw [Finset.mul_sum]
          refine Finset.sum_congr rfl fun y₂ _ => ?_
          rw [show μ₁.w y₁ * μ₂.w y₂ - ν₁.w y₁ * μ₂.w y₂ = (μ₁.w y₁ - ν₁.w y₁) * μ₂.w y₂ by ring]
          rw [abs_mul, abs_of_nonneg (μ₂.nonneg y₂)]
      _ = ∑ y₁ : Y₁, |μ₁.w y₁ - ν₁.w y₁| := by simp [μ₂.sum_eq_one]
  have h2 : tvDist (prodDist ν₁ μ₂) (prodDist ν₁ ν₂) = tvDist μ₂ ν₂ := by
    unfold tvDist prodDist
    congr 1
    rw [Fintype.sum_prod_type, Finset.sum_comm]
    calc ∑ y₂ : Y₂, ∑ y₁ : Y₁, |ν₁.w y₁ * μ₂.w y₂ - ν₁.w y₁ * ν₂.w y₂|
        = ∑ y₂ : Y₂, |μ₂.w y₂ - ν₂.w y₂| * ∑ y₁ : Y₁, ν₁.w y₁ := by
          refine Finset.sum_congr rfl fun y₂ _ => ?_
          rw [Finset.mul_sum]
          refine Finset.sum_congr rfl fun y₁ _ => ?_
          rw [show ν₁.w y₁ * μ₂.w y₂ - ν₁.w y₁ * ν₂.w y₂ = (μ₂.w y₂ - ν₂.w y₂) * ν₁.w y₁ by ring]
          rw [abs_mul, abs_of_nonneg (ν₁.nonneg y₁)]
      _ = ∑ y₂ : Y₂, |μ₂.w y₂ - ν₂.w y₂| := by simp [ν₁.sum_eq_one]
  rw [h1, h2]

/-- **Independent Tensor Kernel Error Bound (`v7 G.4b`):**
Per-site TV discrepancies `ε₁`, `ε₂` on independent kernels add subadditively on `tensorKernel K₁ K₂`. -/
theorem independent_tensor_tv_bound {X₁ X₂ Y₁ Y₂ : Type*} [Fintype Y₁] [Fintype Y₂]
    (K₁ L₁ : FinKernel X₁ Y₁) (K₂ L₂ : FinKernel X₂ Y₂) {ε₁ ε₂ : ℝ}
    (h1 : ∀ x₁, tvDist (K₁ x₁) (L₁ x₁) ≤ ε₁)
    (h2 : ∀ x₂, tvDist (K₂ x₂) (L₂ x₂) ≤ ε₂) (x : X₁ × X₂) :
    tvDist (tensorKernel K₁ K₂ x) (tensorKernel L₁ L₂ x) ≤ ε₁ + ε₂ :=
  (tvDist_prodDist_le (K₁ x.1) (L₁ x.1) (K₂ x.2) (L₂ x.2)).trans (add_le_add (h1 x.1) (h2 x.2))

/-- **Three-Regime Error Contrast (`three_regime_error_contrast`):**
Unifying all three regimes in one cross-layer statement over `ObservationalFidelity`,
`AlignmentReals`, `BecomingReals`, and `Becoming.OplaxHistory`:
1. **Open-loop additive growth (`sequential_kernel_tv_bound`):** uniform per-step kernel error `ε`
   gives linear upper bound `n * ε` from identical initial distributions.
2. **Contractive closed-loop feedback tube (`AlignmentReals.metricSlack` & `BecomingReals.iterVar_eq_metricSlack`):**
   whenever restoring contraction `0 ≤ α < 1` dominates per-step error `ε`, trajectories stay
   uniformly inside `max r (ε / (1 - α))` for ALL `m : ℕ` (and match iterated AR(1) variance).
3. **Coupled-substrate/phase breakdown (`Becoming.OplaxHistory`):**
   zero macro observation TV (`tvDist = 0` on `C2CoupledAlignmentWitness`) fails to rule out an
   immediate step-1 `Viability.Kernel` breach, and unserialized concurrent updates
   (`ConcurrentSerialWitness`) breach their threshold in 3 steps even though each solo update preserves
   viability forever (while `SerialReconfigProcess` rejects stale-epoch reconfigurations). -/
theorem three_regime_error_contrast :
    -- (1) Open-loop additive kernel composition
    (∀ {X : Type} [Fintype X] (K L : FinKernel X X) {ε : ℝ},
      (∀ x, tvDist (K x) (L x) ≤ ε) → ∀ (n : ℕ) (p₀ : FinDist X),
      tvDist (iterKernel K n p₀) (iterKernel L n p₀) ≤ (n : ℝ) * ε) ∧
    -- (2) Contractive closed-loop feedback tube via Becoming.AlignmentReals.metricSlack & Becoming.Reals.iterVar
    (∀ {α a s ε r : ℝ}, 0 ≤ α → α < 1 → 0 ≤ ε → ∀ m : ℕ,
      Becoming.AlignmentReals.metricSlack α ε m r ≤ α ^ m * r + ε / (1 - α) ∧
      Becoming.AlignmentReals.metricSlack α ε m r ≤ max r (ε / (1 - α)) ∧
      Becoming.Reals.iterVar a s m r = Becoming.AlignmentReals.metricSlack (a ^ 2) s m r) ∧
    -- (3) Coupled-phase zero-TV split + unserialized concurrent reserve breakdown
    ((let qProj : Bool × Bool → Unit := fun _ => ()
      tvDist (pushforward qProj (diracDist (true, true)))
        (pushforward qProj (diracDist (true, false))) = 0 ∧
      Becoming.OplaxHistory.FiberViabilitySplit
        Becoming.OplaxHistory.C2CoupledAlignmentWitness.c2ProjMicro
        (Becoming.Viability.Kernel Becoming.OplaxHistory.C2CoupledAlignmentWitness.proc
          Becoming.OplaxHistory.C2CoupledAlignmentWitness.guardS)) ∧
     ((Becoming.PolyComposition.ConcurrentSerialWitness.concurrentOrbit 3).1 () = 0 ∧
      ¬ Becoming.Viability.Kernel
          Becoming.PolyComposition.ConcurrentSerialWitness.concurrentUnguardedProcess
          (fun st => 3 ≤ st.1 ())
          (Becoming.PolyComposition.ConcurrentSerialWitness.concurrentOrbit 0) ∧
      Becoming.Viability.Kernel
        Becoming.PolyComposition.ConcurrentSerialWitness.csProc
        Becoming.PolyComposition.ConcurrentSerialWitness.csGuard
        Becoming.PolyComposition.ConcurrentSerialWitness.st₀)) := by
  refine ⟨?_, ?_, ?_⟩
  · intro X _ K L ε hε n p₀
    have hb := sequential_kernel_tv_bound K L hε n p₀ p₀
    rw [tvDist_self, zero_add] at hb
    exact hb
  · intro α a s ε r hα0 hα1 hε m
    exact ⟨Becoming.AlignmentReals.metricSlack_le hα0 hα1 hε m r,
           Becoming.AlignmentReals.metricSlack_le_max hα0 hα1 hε m r,
           Becoming.Reals.iterVar_eq_metricSlack a s m r⟩
  · refine ⟨⟨zero_tv_does_not_prevent_fiber_viability_split.1,
             Becoming.OplaxHistory.C2CoupledAlignmentWitness.c2_coupled_fiber_split⟩, ?_⟩
    have hconc := Becoming.OplaxHistory.reserve_disjoint_vs_serial_reconfig
    exact ⟨hconc.2.2.2.1.2.2.2.1, hconc.2.2.2.1.2.2.2.2, hconc.2.2.2.2.2.2.2⟩

end ObservationalFidelity
