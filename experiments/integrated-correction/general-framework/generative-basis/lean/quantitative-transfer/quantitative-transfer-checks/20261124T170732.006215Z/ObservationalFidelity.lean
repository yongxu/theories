import Mathlib.Algebra.BigOperators.Field
import Mathlib.Tactic
import FiniteProbKrylov
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

/-- Probability distribution on a finite carrier `U` with weights summing to `1` (re-exported from `FiniteProb`). -/
abbrev FinDist (U : Type*) [Fintype U] : Type _ := FiniteProb.FinDist U

theorem FinDist.ext {U : Type*} [Fintype U] {p q : FinDist U} (h : ∀ u, p.w u = q.w u) : p = q :=
  FiniteProb.FinDist.ext h

/-- Point-mass (Dirac) distribution at `u₀ : U`. -/
noncomputable abbrev diracDist {U : Type*} [Fintype U] [DecidableEq U] (u₀ : U) : FinDist U :=
  FiniteProb.diracDist u₀

/-- Pushforward distribution `f_* p` along any total map `f : U → Y`. -/
noncomputable abbrev pushforward {U Y : Type*} [Fintype U] [Fintype Y]
    (f : U → Y) (p : FinDist U) : FinDist Y :=
  FiniteProb.pushforward f p

theorem pushforward_comp {U Y Z : Type*} [Fintype U] [Fintype Y] [Fintype Z]
    (g : Y → Z) (f : U → Y) (p : FinDist U) :
    pushforward (g ∘ f) p = pushforward g (pushforward f p) :=
  FiniteProb.pushforward_comp g f p

/-- Normalized total variation distance `(1/2) * ∑ y, |μ y - ν y|` on finite `Y`. -/
noncomputable abbrev tvDist {Y : Type*} [Fintype Y] (μ ν : FinDist Y) : ℝ :=
  FiniteProb.tvDist μ ν

theorem tvDist_nonneg {Y : Type*} [Fintype Y] (μ ν : FinDist Y) : 0 ≤ tvDist μ ν :=
  FiniteProb.tvDist_nonneg μ ν

theorem tvDist_self {Y : Type*} [Fintype Y] (μ : FinDist Y) : tvDist μ μ = 0 :=
  FiniteProb.tvDist_self μ

theorem tvDist_symm {Y : Type*} [Fintype Y] (μ ν : FinDist Y) : tvDist μ ν = tvDist ν μ :=
  FiniteProb.tvDist_symm μ ν

theorem tvDist_triangle {Y : Type*} [Fintype Y] (μ ρ ν : FinDist Y) :
    tvDist μ ν ≤ tvDist μ ρ + tvDist ρ ν :=
  FiniteProb.tvDist_triangle μ ρ ν

/-- **Data-Processing Inequality:** post-composing by any total map `g : Y → Z` cannot increase TV distance. -/
theorem tvDist_pushforward_le {Y Z : Type*} [Fintype Y] [Fintype Z]
    (g : Y → Z) (μ ν : FinDist Y) :
    tvDist (pushforward g μ) (pushforward g ν) ≤ tvDist μ ν :=
  FiniteProb.tvDist_pushforward_le g μ ν

/-- Query mass of `lam0` lying outside the image `im(f)` of a total map `f : U → O`. -/
noncomputable abbrev massOutside {U O : Type*} [Fintype U] [Fintype O]
    (f : U → O) (lam0 : FinDist O) : ℝ :=
  FiniteProb.massOutside f lam0

theorem massOutside_nonneg {U O : Type*} [Fintype U] [Fintype O]
    (f : U → O) (lam0 : FinDist O) : 0 ≤ massOutside f lam0 :=
  FiniteProb.massOutside_nonneg f lam0

/-- **Exact Query-Image TV Blindness Floor (`O1` / `v7 G.1`):**
1. For ALL local distributions `ν : FinDist U`, `massOutside (q ∘ χ) (pushforward q μ) ≤ tvDist (pushforward (q ∘ χ) ν) (pushforward q μ)`.
2. Provided `U` is nonempty (`[Nonempty U]`), there exists an explicit witness `ν : FinDist U` achieving
   equality (`tvDist = massOutside`). -/
theorem optimal_query_tv_floor {U V O : Type*} [Fintype U] [Fintype V] [Fintype O]
    (χ : U → V) (q : V → O) (μ : FinDist V) :
    (∀ ν : FinDist U,
      massOutside (q ∘ χ) (pushforward q μ) ≤ tvDist (pushforward (q ∘ χ) ν) (pushforward q μ)) ∧
    (Nonempty U → ∃ ν : FinDist U,
      tvDist (pushforward (q ∘ χ) ν) (pushforward q μ) = massOutside (q ∘ χ) (pushforward q μ)) :=
  FiniteProb.optimal_query_tv_floor χ q μ

/-- **Explicit Empty-Source Trap (`v9 formal/61 §3`):**
`O1` requires `[Nonempty U]`; when `U` is empty, `FinDist U` is empty (no local probability law
exists to achieve or bound TV error). -/
theorem empty_source_infeasible {U : Type*} [Fintype U] (h : IsEmpty U) : IsEmpty (FinDist U) :=
  FiniteProb.empty_source_infeasible h

/-! ## Part 2: Coarsening, Macro-Refinement Monotonicity, & Zero-TV vs `FiberViabilitySplit` -/

/-- **Coarsening Monotonicity (`v7 G.2`):** post-composing observation `q` with `g : O → O'`
cannot increase the TV blindness floor. -/
theorem coarsening_tv_mono {U V O O' : Type*}
    [Fintype U] [Fintype V] [Fintype O] [Fintype O']
    (χ : U → V) (q : V → O) (g : O → O') (μ : FinDist V) :
    massOutside (g ∘ q ∘ χ) (pushforward (g ∘ q) μ) ≤
      massOutside (q ∘ χ) (pushforward q μ) := by
  rw [pushforward_comp]
  unfold massOutside pushforward FiniteProb.massOutside FiniteProb.pushforward
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
  unfold massOutside FiniteProb.massOutside
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
      simp [FiniteProb.pushforward, FiniteProb.diracDist]
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
  dsimp only [pushforward, FiniteProb.pushforward]
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
      cases b <;> simp [FiniteProb.pushforward, diagLift, Fintype.sum_prod_type]
    rw [hpf, tvDist_self]
  · have hpf : pushforward Prod.snd (diagLift oneFifthBool) = oneFifthBool := by
      refine FinDist.ext fun b => ?_
      cases b <;> simp [FiniteProb.pushforward, diagLift, Fintype.sum_prod_type]
    rw [hpf, tvDist_self]
  · intro ν hdiag
    have heq := diagSupport_fst_eq_snd hdiag
    have htri := tvDist_triangle fourFifthsBool (pushforward Prod.fst ν) oneFifthBool
    have h1 : tvDist fourFifthsBool (pushforward Prod.fst ν) =
        tvDist (pushforward Prod.fst ν) fourFifthsBool := tvDist_symm _ _
    have h2 : tvDist (pushforward Prod.fst ν) oneFifthBool =
        tvDist (pushforward Prod.snd ν) oneFifthBool := by rw [heq]
    have hdist : tvDist fourFifthsBool oneFifthBool = (3 / 5 : ℝ) := by
      unfold tvDist FiniteProb.tvDist fourFifthsBool oneFifthBool
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
    cases b <;> simp [FiniteProb.pushforward, uniformPairBool, fairBool, Fintype.sum_prod_type] <;> norm_num
  have hsnd : pushforward Prod.snd uniformPairBool = fairBool := by
    refine FinDist.ext fun b => ?_
    cases b <;> simp [FiniteProb.pushforward, uniformPairBool, fairBool, Fintype.sum_prod_type] <;> norm_num
  refine ⟨⟨diagLift fairBool, ⟨rfl, rfl⟩, ?_, ?_, ?_⟩, ?_⟩
  · have hpf : pushforward Prod.fst (diagLift fairBool) = fairBool := by
      refine FinDist.ext fun b => ?_
      cases b <;> simp [FiniteProb.pushforward, diagLift, fairBool, Fintype.sum_prod_type]
    rw [hpf, hfst, tvDist_self]
  · have hpf : pushforward Prod.snd (diagLift fairBool) = fairBool := by
      refine FinDist.ext fun b => ?_
      cases b <;> simp [FiniteProb.pushforward, diagLift, fairBool, Fintype.sum_prod_type]
    rw [hpf, hsnd, tvDist_self]
  · unfold tvDist FiniteProb.tvDist diagLift fairBool uniformPairBool
    simp [Fintype.sum_prod_type]
    norm_num
  · intro ν hdiag
    unfold tvDist FiniteProb.tvDist uniformPairBool
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
  unfold tvDist FiniteProb.tvDist pushKernel
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
    unfold tvDist FiniteProb.tvDist prodDist
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
    unfold tvDist FiniteProb.tvDist prodDist
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

/-! ## Part 5: Oplax Row Defect, Dobrushin Contraction, `MetricLaxSim`, Risk Transfer, & Controls -/

/-- One-step macro commutation defect at `u`: TV discrepancy between `f_*(K u)` and `L(f u)`. -/
noncomputable def rowDefect {U O : Type*} [Fintype U] [Fintype O]
    (f : U → O) (K : FinKernel U U) (L : FinKernel O O) (u : U) : ℝ :=
  tvDist (pushforward f (K u)) (L (f u))

theorem optimal_floor_le_rowDefect {U O : Type*} [Fintype U] [Fintype O]
    (f : U → O) (K : FinKernel U U) (L : FinKernel O O) (u : U) :
    massOutside f (L (f u)) ≤ rowDefect f K L u := by
  have hid : pushforward (id : O → O) (L (f u)) = L (f u) := FinDist.ext fun o => by
    dsimp only [pushforward, FiniteProb.pushforward, id]
    exact (Finset.sum_eq_single o (fun _ _ hx => if_neg hx)
      (fun h => absurd (Finset.mem_univ o) h)).trans (if_pos rfl)
  have h := (optimal_query_tv_floor f id (L (f u))).1 (K u)
  rwa [Function.id_comp, hid] at h

theorem sum_pushforward_mul {U O : Type*} [Fintype U] [Fintype O]
    (f : U → O) (p : FinDist U) (g : O → ℝ) :
    ∑ o : O, (pushforward f p).w o * g o = ∑ u : U, p.w u * g (f u) := by
  dsimp only [pushforward, FiniteProb.pushforward]; simp_rw [Finset.sum_mul, ite_mul, zero_mul]
  rw [Finset.sum_comm]; exact Finset.sum_congr rfl fun u _ => by simp

/-- **Dobrushin Kernel Contraction (`tvDist_pushKernel_dobrushin`):**
If every row pair of `L : FinKernel O O'` has `tvDist (L o) (L o') ≤ α`, `pushKernel L` contracts TV by `α`. -/
theorem tvDist_pushKernel_dobrushin {O O' : Type*} [Fintype O] [Fintype O']
    (L : FinKernel O O') {α : ℝ} (hα : ∀ o o', tvDist (L o) (L o') ≤ α) (μ ν : FinDist O) :
    tvDist (pushKernel L μ) (pushKernel L ν) ≤ α * tvDist μ ν := by
  by_cases hT0 : tvDist μ ν = 0
  · have heq : μ = ν := (FiniteProb.tvDist_eq_zero_iff μ ν).mp hT0
    rw [hT0, mul_zero, heq, tvDist_self]
  · have hT : 0 < tvDist μ ν := lt_of_le_of_ne (tvDist_nonneg μ ν) (Ne.symm hT0)
    let pos : O → ℝ := fun o => max (μ.w o - ν.w o) 0; let neg : O → ℝ := fun o => max (ν.w o - μ.w o) 0
    have hp0 : ∀ o, 0 ≤ pos o := fun _ => le_max_right _ _; have hn0 : ∀ o, 0 ≤ neg o := fun _ => le_max_right _ _
    have hdec : ∀ o, pos o - neg o = μ.w o - ν.w o ∧ pos o + neg o = |μ.w o - ν.w o| := fun o => by
      rcases le_total (μ.w o) (ν.w o) with h | h
      · rw [show pos o = 0 from max_eq_right (sub_nonpos.mpr h), show neg o = ν.w o - μ.w o from max_eq_left (sub_nonneg.mpr h),
            abs_of_nonpos (sub_nonpos.mpr h)]; constructor <;> ring
      · rw [show pos o = μ.w o - ν.w o from max_eq_left (sub_nonneg.mpr h), show neg o = 0 from max_eq_right (sub_nonpos.mpr h),
            abs_of_nonneg (sub_nonneg.mpr h)]; constructor <;> ring
    have hs_sub : ∑ o, pos o - ∑ o, neg o = 0 := by
      rw [← Finset.sum_sub_distrib, Finset.sum_congr rfl fun o _ => (hdec o).1, Finset.sum_sub_distrib, μ.sum_eq_one, ν.sum_eq_one, sub_self]
    have hs_add : ∑ o, pos o + ∑ o, neg o = 2 * tvDist μ ν := by
      rw [← Finset.sum_add_distrib, Finset.sum_congr rfl fun o _ => (hdec o).2]; unfold tvDist FiniteProb.tvDist; ring
    have hsp : ∑ o, pos o = tvDist μ ν := by linarith
    have hsn : ∑ o, neg o = tvDist μ ν := by linarith
    have hstep_y : ∀ y : O', tvDist μ ν * ((pushKernel L μ).w y - (pushKernel L ν).w y) =
        ∑ o : O, ∑ o' : O, pos o * neg o' * ((L o).w y - (L o').w y) := fun y => by
      have h1 : ∑ o : O, ∑ o' : O, pos o * neg o' * ((L o).w y - (L o').w y) =
          (∑ o : O, pos o * (L o).w y) * (∑ o' : O, neg o') - (∑ o : O, pos o) * (∑ o' : O, neg o' * (L o').w y) := by
        simp_rw [mul_sub, Finset.sum_sub_distrib, Finset.sum_mul, Finset.mul_sum]
        congr 1 <;> exact Finset.sum_congr rfl fun _ _ => Finset.sum_congr rfl fun _ _ => by ring
      have h2 : (pushKernel L μ).w y - (pushKernel L ν).w y = (∑ o : O, pos o * (L o).w y) - (∑ o' : O, neg o' * (L o').w y) := by
        dsimp only [pushKernel]; rw [← Finset.sum_sub_distrib, ← Finset.sum_sub_distrib]
        exact Finset.sum_congr rfl fun o _ => by
          have := (hdec o).1; calc μ.w o * (L o).w y - ν.w o * (L o).w y = (pos o - neg o) * (L o).w y := by rw [this]; ring
            _ = pos o * (L o).w y - neg o * (L o).w y := by ring
      rw [h1, hsp, hsn, h2]; ring
    have hbound : tvDist μ ν * tvDist (pushKernel L μ) (pushKernel L ν) ≤ tvDist μ ν * (α * tvDist μ ν) :=
      calc tvDist μ ν * tvDist (pushKernel L μ) (pushKernel L ν)
          = (1 / 2 : ℝ) * ∑ y : O', |tvDist μ ν * ((pushKernel L μ).w y - (pushKernel L ν).w y)| := by
            conv_lhs => rhs; unfold tvDist FiniteProb.tvDist
            rw [← mul_assoc, mul_comm (tvDist μ ν) (1 / 2 : ℝ), mul_assoc, Finset.mul_sum]
            congr 1; exact Finset.sum_congr rfl fun y _ => by rw [abs_mul, abs_of_pos hT]
        _ ≤ (1 / 2 : ℝ) * ∑ y : O', ∑ o : O, ∑ o' : O, pos o * neg o' * |(L o).w y - (L o').w y| := by
            refine mul_le_mul_of_nonneg_left (Finset.sum_le_sum fun y _ => ?_) (by norm_num); rw [hstep_y y]
            exact (Finset.abs_sum_le_sum_abs _ _).trans (Finset.sum_le_sum fun o _ =>
              (Finset.abs_sum_le_sum_abs _ _).trans (Finset.sum_le_sum fun o' _ => by rw [abs_mul, abs_of_nonneg (mul_nonneg (hp0 o) (hn0 o'))]))
        _ = ∑ o : O, ∑ o' : O, pos o * neg o' * tvDist (L o) (L o') := by
            rw [Finset.sum_comm, Finset.mul_sum]; refine Finset.sum_congr rfl fun o _ => ?_
            rw [Finset.sum_comm, Finset.mul_sum]; refine Finset.sum_congr rfl fun o' _ => ?_; unfold tvDist FiniteProb.tvDist; rw [← Finset.mul_sum]; ring
        _ ≤ ∑ o : O, ∑ o' : O, pos o * neg o' * α :=
            Finset.sum_le_sum fun o _ => Finset.sum_le_sum fun o' _ => mul_le_mul_of_nonneg_left (hα o o') (mul_nonneg (hp0 o) (hn0 o'))
        _ = tvDist μ ν * (α * tvDist μ ν) := by
            rw [show (∑ o : O, ∑ o' : O, pos o * neg o' * α) = (∑ o : O, pos o) * ((∑ o' : O, neg o') * α) by
              rw [Finset.sum_mul]; refine Finset.sum_congr rfl fun o _ => ?_
              rw [Finset.sum_mul, Finset.mul_sum]; exact Finset.sum_congr rfl fun o' _ => by ring, hsp, hsn]; ring
    exact le_of_mul_le_mul_left hbound hT

/-- **Oplax-Dobrushin One-Step Contraction (`tvDist_pushKernel_dobrushin_step`):**
Macro pushforward TV contracts by `α` plus expected one-step `rowDefect`. -/
theorem tvDist_pushKernel_dobrushin_step {U O : Type*} [Fintype U] [Fintype O]
    (f : U → O) (K : FinKernel U U) (L : FinKernel O O) {α : ℝ}
    (_hα0 : 0 ≤ α) (hL : ∀ o o', tvDist (L o) (L o') ≤ α) (p : FinDist U) (lam : FinDist O) :
    tvDist (pushforward f (pushKernel K p)) (pushKernel L lam) ≤
      (∑ u : U, p.w u * rowDefect f K L u) + α * tvDist (pushforward f p) lam := by
  have h1 : ∀ o', (pushforward f (pushKernel K p)).w o' = ∑ u : U, p.w u * (pushforward f (K u)).w o' := fun o' => by
    dsimp only [pushforward, FiniteProb.pushforward, pushKernel]
    calc ∑ v : U, (if f v = o' then ∑ u : U, p.w u * (K u).w v else 0)
        = ∑ v : U, ∑ u : U, p.w u * (if f v = o' then (K u).w v else 0) := Finset.sum_congr rfl fun v _ => by split_ifs <;> simp
      _ = ∑ u : U, p.w u * ∑ v : U, (if f v = o' then (K u).w v else 0) := by
          rw [Finset.sum_comm]; exact Finset.sum_congr rfl fun u _ => (Finset.mul_sum _ _ _).symm
  have h2 : ∀ o', (pushKernel L (pushforward f p)).w o' = ∑ u : U, p.w u * (L (f u)).w o' :=
    fun o' => sum_pushforward_mul f p (fun o => (L o).w o')
  refine (tvDist_triangle _ (pushKernel L (pushforward f p)) _).trans (add_le_add ?_ (tvDist_pushKernel_dobrushin L hL _ _))
  unfold tvDist FiniteProb.tvDist rowDefect
  calc (1 / 2 : ℝ) * ∑ o' : O, |(pushforward f (pushKernel K p)).w o' - (pushKernel L (pushforward f p)).w o'|
      = (1 / 2 : ℝ) * ∑ o' : O, |∑ u : U, p.w u * ((pushforward f (K u)).w o' - (L (f u)).w o')| := by
        congr 1; refine Finset.sum_congr rfl fun o' _ => ?_
        rw [h1 o', h2 o', ← Finset.sum_sub_distrib]; congr 1; exact Finset.sum_congr rfl fun u _ => by ring
    _ ≤ (1 / 2 : ℝ) * ∑ o' : O, ∑ u : U, p.w u * |(pushforward f (K u)).w o' - (L (f u)).w o'| := by
        refine mul_le_mul_of_nonneg_left (Finset.sum_le_sum fun o' _ => ?_) (by norm_num)
        exact (Finset.abs_sum_le_sum_abs _ _).trans (Finset.sum_le_sum fun u _ => by rw [abs_mul, abs_of_nonneg (p.nonneg u)])
    _ = ∑ u : U, p.w u * ((1 / 2 : ℝ) * ∑ o' : O, |(pushforward f (K u)).w o' - (L (f u)).w o'|) := by
        rw [Finset.sum_comm, Finset.mul_sum]; exact Finset.sum_congr rfl fun u _ => by rw [← Finset.mul_sum]; ring

/-- Scoped TV `PseudoMetricSpace` on `FinDist O` for instantiating `AlignmentReals.MetricLaxSim`. -/
noncomputable scoped instance finDistPseudoMetricSpace (O : Type*) [Fintype O] : PseudoMetricSpace (FinDist O) where
  dist := tvDist; dist_self := tvDist_self; dist_comm := tvDist_symm; dist_triangle := tvDist_triangle

theorem iterKernel_succ_comm {X : Type*} [Fintype X] (K : FinKernel X X) :
    ∀ (n : ℕ) (p : FinDist X), iterKernel K n (pushKernel K p) = iterKernel K (n + 1) p
  | 0, _ => rfl | n + 1, p => by simp only [iterKernel, iterKernel_succ_comm K n p]

theorem iterKernel_trace {X : Type*} [Fintype X] (K : FinKernel X X) :
    ∀ (n : ℕ) (p0 : FinDist X), Generative.Trace (Becoming.Assurance.ofMap (fun p (_ : Unit) => pushKernel K p))
      p0 (List.replicate n ()) (iterKernel K n p0)
  | 0, p0 => .nil p0 | n + 1, p0 => by rw [List.replicate_succ, ← iterKernel_succ_comm]; exact .cons rfl (iterKernel_trace K n _)

theorem trace_ofMap_eq_iterKernel {X : Type*} [Fintype X] (K : FinKernel X X) :
    ∀ (w : List Unit) (p0 p : FinDist X),
      Generative.Trace (Becoming.Assurance.ofMap (fun q (_ : Unit) => pushKernel K q)) p0 w p → p = iterKernel K w.length p0
  | [], _, _, .nil _ => rfl
  | () :: w, p0, p, .cons (m := m) hm hrest => by
    have hm' : m = pushKernel K p0 := hm; subst hm'
    exact (trace_ofMap_eq_iterKernel K w (pushKernel K p0) p hrest).trans (iterKernel_succ_comm K w.length p0)

/-- **Kernel `MetricLaxSim` Instantiation (`kernelMetricLaxSim`):**
Instantiates `Becoming.AlignmentReals.MetricLaxSim` on `(FinDist U, FinDist O, pushKernel K, pushKernel L, pushforward f, tvDist)`. -/
noncomputable def kernelMetricLaxSim {U O : Type*} [Fintype U] [Fintype O]
    (f : U → O) (K : FinKernel U U) (L : FinKernel O O) {α ε : ℝ} (hα0 : 0 ≤ α) (hα1 : α < 1) (hε0 : 0 ≤ ε)
    (hL : ∀ o o', tvDist (L o) (L o') ≤ α) (hrow : ∀ u, rowDefect f K L u ≤ ε) :
    Becoming.AlignmentReals.MetricLaxSim (Becoming.Assurance.ofMap (fun p (_ : Unit) => pushKernel K p))
      (Becoming.Assurance.ofMap (fun lam (_ : Unit) => pushKernel L lam)) (pushforward f) id where
  strict _ := Nat.lt_succ_self _; Epoch _ _ := True; EpochQ _ _ := True
  epoch_step _ _ _ _ _ _ := trivial; epoch_proj _ _ _ := trivial
  α := α; β := 1; ε := ε; η := 0
  α_nonneg := hα0; α_lt_one := hα1; β_ge_one := le_rfl; ε_nonneg := hε0; η_nonneg := le_rfl
  sim_block _ s q r w s' _ _ _ hdist hlen htr := by
    have hw : w.length = 1 := by simpa using hlen
    rcases w with _ | ⟨_, _ | _⟩ <;> simp at hw
    have hs' : s' = pushKernel K s := by rcases htr with _ | ⟨hs, hr⟩; cases hr; exact hs
    refine ⟨(), pushKernel L q, rfl, trivial, ?_⟩
    change tvDist (pushforward f s') (pushKernel L q) ≤ α * r + ε; rw [hs']
    have hstep := tvDist_pushKernel_dobrushin_step f K L hα0 hL s q
    have hsum : ∑ u : U, s.w u * rowDefect f K L u ≤ ε :=
      (Finset.sum_le_sum fun u _ => mul_le_mul_of_nonneg_left (hrow u) (s.nonneg u)).trans_eq (by rw [← Finset.sum_mul, s.sum_eq_one, one_mul])
    have hmul : α * tvDist (pushforward f s) q ≤ α * r := mul_le_mul_of_nonneg_left hdist hα0
    linarith
  excursion _ s q r w₁ _ _ _ _ hdist hlen htr := by
    dsimp only [id] at hlen; have hw : w₁ = [] := List.length_eq_zero_iff.mp (by omega)
    subst hw; cases htr; change tvDist (pushforward f s) q ≤ 1 * r + 0; linarith [show tvDist (pushforward f s) q ≤ r from hdist]

/-- **Iterated Oplax-Dobrushin Contraction Tube (`tvDist_pushKernel_iter_bound`):**
Derived from `kernelMetricLaxSim` via `MetricLaxSim.advance_blocks` and `metricSlack_eq`. -/
theorem tvDist_pushKernel_iter_bound {U O : Type*} [Fintype U] [Fintype O]
    (f : U → O) (K : FinKernel U U) (L : FinKernel O O) {α ε : ℝ} (hα0 : 0 ≤ α) (hα1 : α < 1) (hε0 : 0 ≤ ε)
    (hL : ∀ o o', tvDist (L o) (L o') ≤ α) (hrow : ∀ u, rowDefect f K L u ≤ ε) (n : ℕ) (p0 : FinDist U) (lam0 : FinDist O) :
    tvDist (pushforward f (iterKernel K n p0)) (iterKernel L n lam0) ≤ α ^ n * tvDist (pushforward f p0) lam0 + ε * (1 - α ^ n) / (1 - α) ∧
    tvDist (pushforward f (iterKernel K n p0)) (iterKernel L n lam0) ≤ α ^ n * tvDist (pushforward f p0) lam0 + ε / (1 - α) := by
  let sim := kernelMetricLaxSim f K L hα0 hα1 hε0 hL hrow
  obtain ⟨u, w_rem, wR, q_n, hrem, hwR, trR, tr_rem, _, _, hdist⟩ := Becoming.AlignmentReals.MetricLaxSim.advance_blocks sim n 0
    (tvDist_nonneg (pushforward f p0) lam0) trivial trivial le_rfl (by simp) (iterKernel_trace K n p0)
  have hwrem0 : w_rem = [] := by simpa using hrem
  subst hwrem0; have hu : iterKernel K n p0 = u := by cases tr_rem; rfl
  have hq : q_n = iterKernel L n lam0 := by simpa [hwR] using trace_ofMap_eq_iterKernel L wR lam0 q_n trR
  rw [hu, ← hq]; exact ⟨by simpa [mul_div_assoc] using hdist.trans_eq (Becoming.AlignmentReals.metricSlack_eq hα1.ne ε n _),
    hdist.trans (Becoming.AlignmentReals.metricSlack_le hα0 hα1 hε0 n _)⟩

/-- **Derived `Viability.Kernel` Transfer via `metric_laxSim_contraction_tube`:**
Upgrades macro viability certificates on `pushKernel L` to `Viability.Kernel` on `pushKernel K`. -/
theorem kernel_contraction_tube_via_metricLaxSim {U O : Type*} [Fintype U] [Fintype O]
    (f : U → O) (K : FinKernel U U) (L : FinKernel O O) {α ε : ℝ} (hα0 : 0 ≤ α) (hα1 : α < 1) (hε0 : 0 ≤ ε)
    (hL : ∀ o o', tvDist (L o) (L o') ≤ α) (hrow : ∀ u, rowDefect f K L u ≤ ε)
    {guardQ invQ : FinDist O → Prop} {guardS : FinDist U → Prop}
    (cert : Becoming.Viability.Certificate (Becoming.Assurance.ofMap (fun lam (_ : Unit) => pushKernel L lam)) guardQ invQ)
    (d0 : ℝ) (hd0 : 0 ≤ d0) (hguard : ∀ lam p, guardQ lam → tvDist (pushforward f p) lam ≤ max d0 (ε / (1 - α)) → guardS p)
    {p0 : FinDist U} (lam0 : FinDist O) (dist0 : tvDist (pushforward f p0) lam0 ≤ d0) (init : invQ lam0) :
    Becoming.Viability.Kernel (Becoming.Assurance.ofMap (fun p (_ : Unit) => pushKernel K p)) guardS p0 :=
  (Becoming.AlignmentReals.metric_laxSim_contraction_tube (kernelMetricLaxSim f K L hα0 hα1 hε0 hL hrow) cert d0 hd0
    (fun lam p gQ hd => hguard lam p gQ (by dsimp only [kernelMetricLaxSim, dist] at hd; linarith)) lam0 trivial trivial dist0 init).2

/-- **Viability Risk Transfer & Fiber Readout Floor (`viability_risk_transfer_bound`, `fiber_split_readout_floor`):**
For `[0, 1]`-bounded `b : O → ℝ` with `|h u - b (f u)| ≤ γ`, expectation gap ≤ `γ + tvDist`; a split `[0, 1]` fiber forces `1/2 ≤ γ`. -/
theorem viability_risk_transfer_bound {U O : Type*} [Fintype U] [Fintype O]
    (f : U → O) (K : FinKernel U U) (L : FinKernel O O) (h : U → ℝ) (b : O → ℝ) {γ : ℝ}
    (hγ : ∀ u, |h u - b (f u)| ≤ γ) (hb : ∀ o, 0 ≤ b o ∧ b o ≤ 1) (n : ℕ) (p0 : FinDist U) (lam0 : FinDist O) :
    |∑ u, (iterKernel K n p0).w u * h u - ∑ o, (iterKernel L n lam0).w o * b o| ≤
      γ + tvDist (pushforward f (iterKernel K n p0)) (iterKernel L n lam0) := by
  let p := iterKernel K n p0; let lam := iterKernel L n lam0
  have h1 : |∑ u, p.w u * (h u - b (f u))| ≤ γ :=
    calc |∑ u, p.w u * (h u - b (f u))| ≤ ∑ u, |p.w u * (h u - b (f u))| := Finset.abs_sum_le_sum_abs _ _
      _ = ∑ u, p.w u * |h u - b (f u)| := Finset.sum_congr rfl fun u _ => by rw [abs_mul, abs_of_nonneg (p.nonneg u)]
      _ ≤ ∑ u, p.w u * γ := Finset.sum_le_sum fun u _ => mul_le_mul_of_nonneg_left (hγ u) (p.nonneg u)
      _ = γ := by rw [← Finset.sum_mul, p.sum_eq_one, one_mul]
  have h0 : ∑ o : O, ((pushforward f p).w o - lam.w o) * (1 / 2 : ℝ) = 0 := by
    rw [← Finset.sum_mul, Finset.sum_sub_distrib, (pushforward f p).sum_eq_one, lam.sum_eq_one]; ring
  have h2 : |∑ o, (pushforward f p).w o * b o - ∑ o, lam.w o * b o| ≤ tvDist (pushforward f p) lam := by
    rw [show ∑ o, (pushforward f p).w o * b o - ∑ o, lam.w o * b o = ∑ o, ((pushforward f p).w o - lam.w o) * (b o - 1 / 2) by
      rw [← Finset.sum_sub_distrib, ← sub_zero (∑ o, _), ← h0, ← Finset.sum_sub_distrib]; exact Finset.sum_congr rfl fun o _ => by ring]
    calc |∑ o, ((pushforward f p).w o - lam.w o) * (b o - 1 / 2)|
        ≤ ∑ o, |((pushforward f p).w o - lam.w o) * (b o - 1 / 2)| := Finset.abs_sum_le_sum_abs _ _
      _ = ∑ o, |(pushforward f p).w o - lam.w o| * |b o - 1 / 2| := Finset.sum_congr rfl fun o _ => abs_mul _ _
      _ ≤ ∑ o, |(pushforward f p).w o - lam.w o| * (1 / 2 : ℝ) := Finset.sum_le_sum fun o _ =>
          mul_le_mul_of_nonneg_left (abs_le.mpr ⟨by linarith [(hb o).1], by linarith [(hb o).2]⟩) (abs_nonneg _)
      _ = tvDist (pushforward f p) lam := by unfold tvDist FiniteProb.tvDist; rw [← Finset.sum_mul]; ring
  have hsum_eq : ∑ u, p.w u * h u = (∑ u, p.w u * (h u - b (f u))) + ∑ u, p.w u * b (f u) := by
    rw [← Finset.sum_add_distrib]; exact Finset.sum_congr rfl fun u _ => by ring
  rw [hsum_eq, ← sum_pushforward_mul f p b, add_sub_assoc]; exact (abs_add_le _ _).trans (add_le_add h1 h2)

theorem fiber_split_readout_floor {U O : Type*} (f : U → O) (h : U → ℝ) (b : O → ℝ) {γ : ℝ}
    (u1 u2 : U) (hf : f u1 = f u2) (h1 : h u1 = 0) (h2 : h u2 = 1) (hγ : ∀ u, |h u - b (f u)| ≤ γ) : (1 / 2 : ℝ) ≤ γ := by
  have d1 := hγ u1; have d2 := hγ u2; rw [h1, hf] at d1; rw [h2] at d2
  have htri : (1 : ℝ) ≤ |0 - b (f u2)| + |1 - b (f u2)| :=
    calc (1 : ℝ) = |(1 - b (f u2)) - (0 - b (f u2))| := by norm_num
      _ ≤ |1 - b (f u2)| + |0 - b (f u2)| := abs_sub _ _
      _ = |0 - b (f u2)| + |1 - b (f u2)| := add_comm _ _
  linarith

/-- Explicit 2-tag macro kernel on `Bool` (`Bool ≃ Option Unit` via `false ↔ some ()`, `true ↔ none`). -/
noncomputable def sharpBoolKernel (ε α : ℝ) (hε0 : 0 < ε) (hα0 : 0 ≤ α) (hεα : ε + α ≤ 1) : FinKernel Bool Bool
  | false => ⟨fun b => if b then ε else 1 - ε, fun b => by cases b <;> dsimp <;> linarith, by simp⟩
  | true => ⟨fun b => if b then ε + α else 1 - (ε + α), fun b => by cases b <;> dsimp <;> linarith, by simp⟩

/-- **Sharp Oplax-Dobrushin Attainment (`sharp_oplax_dobrushin_attainment`):**
On `f : Unit → Bool := fun _ => false`, `sharpBoolKernel ε α` hits `d_n = ε * (1 - α ^ n) / (1 - α)` with equality for all `n`. -/
theorem sharp_oplax_dobrushin_attainment (ε α : ℝ) (hε0 : 0 < ε) (hα0 : 0 ≤ α) (hα1 : α < 1) (hεα : ε + α ≤ 1) :
    let f : Unit → Bool := fun _ => false; let K : FinKernel Unit Unit := fun _ => diracDist ()
    let L := sharpBoolKernel ε α hε0 hα0 hεα
    (∀ o o', tvDist (L o) (L o') ≤ α) ∧ tvDist (L false) (L true) = α ∧
    rowDefect f K L () = ε ∧ massOutside f (L (f ())) = ε ∧
    ∀ n : ℕ, tvDist (pushforward f (iterKernel K n (diracDist ()))) (iterKernel L n (diracDist false)) =
      ε * (1 - α ^ n) / (1 - α) := by
  intro f K L
  have hft : tvDist (L false) (L true) = α := by
    unfold tvDist FiniteProb.tvDist L sharpBoolKernel; simp [abs_of_nonneg hα0, abs_of_nonpos (neg_nonpos.mpr hα0)]; ring
  have hL : ∀ o o', tvDist (L o) (L o') ≤ α := fun o o' => by cases o <;> cases o' <;> simp [tvDist_self, hα0, hft.le, tvDist_symm]
  have hpf0 : pushforward f (K ()) = diracDist false := FinDist.ext fun b => by cases b <;> simp [FiniteProb.pushforward, f, K, FiniteProb.diracDist]
  have hd0 : (diracDist false).w true = 0 := by simp [FiniteProb.diracDist]
  have hd1 : (diracDist false).w false = 1 := by simp [FiniteProb.diracDist]
  have hrow : rowDefect f K L () = ε := by
    rw [rowDefect, hpf0]; change tvDist (diracDist false) (sharpBoolKernel ε α hε0 hα0 hεα false) = ε
    have hs0 : (sharpBoolKernel ε α hε0 hα0 hεα false).w true = ε := by simp [sharpBoolKernel]
    have hs1 : (sharpBoolKernel ε α hε0 hα0 hεα false).w false = 1 - ε := by simp [sharpBoolKernel]
    dsimp only [tvDist, FiniteProb.tvDist]; rw [Fintype.sum_bool, hd0, hd1, hs0, hs1, zero_sub, abs_neg, abs_of_pos hε0,
      show (1 : ℝ) - (1 - ε) = ε by ring, abs_of_pos hε0]; ring
  have hmass : massOutside f (L (f ())) = ε := by unfold massOutside FiniteProb.massOutside f L sharpBoolKernel; simp
  have hrec : ∀ n : ℕ, (iterKernel L n (diracDist false)).w true = ε * (1 - α ^ n) / (1 - α) := fun n => by
    induction n with
    | zero => simp [iterKernel, FiniteProb.diracDist]
    | succ n ih =>
      have htot := (iterKernel L n (diracDist false)).sum_eq_one
      have hfalse : (iterKernel L n (diracDist false)).w false = 1 - (iterKernel L n (diracDist false)).w true := by simp at htot; linarith
      simp only [iterKernel, pushKernel, Fintype.sum_bool, hfalse, ih]; dsimp only [L, sharpBoolKernel]
      simp only [ite_true]; field_simp [sub_ne_zero.mpr hα1.ne']; ring
  have hk_const : ∀ n : ℕ, iterKernel K n (diracDist ()) = diracDist () := fun n => by
    induction n with | zero => rfl | succ n ih => rw [iterKernel, ih]; exact FinDist.ext fun () => by simp [pushKernel, K, FiniteProb.diracDist]
  refine ⟨hL, hft, hrow, hmass, fun n => ?_⟩
  have hpf : pushforward f (iterKernel K n (diracDist ())) = diracDist false := by
    rw [hk_const n]; exact FinDist.ext fun b => by cases b <;> simp [FiniteProb.pushforward, f, FiniteProb.diracDist]
  rw [hpf]; have hsum := (iterKernel L n (diracDist false)).sum_eq_one; have hn := (iterKernel L n (diracDist false)).nonneg true
  have hfl : (iterKernel L n (diracDist false)).w false = 1 - (iterKernel L n (diracDist false)).w true := by simp at hsum; linarith
  dsimp only [tvDist, FiniteProb.tvDist]; rw [Fintype.sum_bool, hd0, hd1, hfl, zero_sub, abs_neg, abs_of_nonneg hn,
    show (1 : ℝ) - (1 - (iterKernel L n (diracDist false)).w true) = (iterKernel L n (diracDist false)).w true by ring,
    abs_of_nonneg hn, hrec n]; ring

/-- **Closed-Loop Feedback Destroys Open-Loop Contraction (`feedback_destroys_openloop_contraction`):**
Two constant kernels `K₀, K₁` have Dobrushin `0`, while state-dependent `s ↦ K_s s` is the identity (`tvDist = 1`). -/
theorem feedback_destroys_openloop_contraction :
    let K₀ : FinKernel Bool Bool := fun _ => diracDist false; let K₁ : FinKernel Bool Bool := fun _ => diracDist true
    let Kcl : FinKernel Bool Bool := fun s => (if s then K₁ else K₀) s
    (∀ x y, tvDist (K₀ x) (K₀ y) = 0) ∧ (∀ x y, tvDist (K₁ x) (K₁ y) = 0) ∧
    (∀ s, Kcl s = diracDist s) ∧ tvDist (Kcl false) (Kcl true) = 1 ∧ (∀ (n : ℕ) (p : FinDist Bool), iterKernel Kcl n p = p) := by
  intro K₀ K₁ Kcl; have hcl : ∀ s, Kcl s = diracDist s := fun s => by cases s <;> rfl
  have hstep : ∀ p : FinDist Bool, pushKernel Kcl p = p := fun p => FinDist.ext fun b => by cases b <;> simp [pushKernel, hcl, FiniteProb.diracDist]
  refine ⟨fun _ _ => tvDist_self _, fun _ _ => tvDist_self _, hcl, ?_, fun n p => by
    induction n with | zero => rfl | succ n ih => simp [iterKernel, ih, hstep]⟩
  unfold tvDist FiniteProb.tvDist; simp [hcl, FiniteProb.diracDist]; norm_num

/-- **Derived Three-Regime Kernel Error Contrast (`three_regime_kernel_contrast`):**
Joins open-loop linear drift, kernel-derived `MetricLaxSim` contraction tubes, and feedback/coupled breakdowns. -/
theorem three_regime_kernel_contrast :
    (∀ {X : Type} [Fintype X] (K L : FinKernel X X) {ε : ℝ},
      (∀ x, tvDist (K x) (L x) ≤ ε) → ∀ (n : ℕ) (p0 : FinDist X), tvDist (iterKernel K n p0) (iterKernel L n p0) ≤ (n : ℝ) * ε) ∧
    (∀ {U O : Type} [Fintype U] [Fintype O] (f : U → O) (K : FinKernel U U) (L : FinKernel O O) {α ε : ℝ},
      0 ≤ α → α < 1 → 0 ≤ ε → (∀ o o', tvDist (L o) (L o') ≤ α) → (∀ u, rowDefect f K L u ≤ ε) →
      ∀ (n : ℕ) (p0 : FinDist U) (lam0 : FinDist O),
        tvDist (pushforward f (iterKernel K n p0)) (iterKernel L n lam0) ≤ α ^ n * tvDist (pushforward f p0) lam0 + ε * (1 - α ^ n) / (1 - α)) ∧
    (tvDist ((fun s : Bool => (if s then (fun _ => diracDist true) else (fun _ => diracDist false)) s) false)
      ((fun s : Bool => (if s then (fun _ => diracDist true) else (fun _ => diracDist false)) s) true) = 1 ∧
     Becoming.OplaxHistory.FiberViabilitySplit Becoming.OplaxHistory.C2CoupledAlignmentWitness.c2ProjMicro
       (Becoming.Viability.Kernel Becoming.OplaxHistory.C2CoupledAlignmentWitness.proc Becoming.OplaxHistory.C2CoupledAlignmentWitness.guardS)) :=
  ⟨fun K L ε hε n p0 => by simpa [tvDist_self] using sequential_kernel_tv_bound K L hε n p0 p0,
   fun f K L α ε hα0 hα1 hε0 hL hrow n p0 lam0 => (tvDist_pushKernel_iter_bound f K L hα0 hα1 hε0 hL hrow n p0 lam0).1,
   ⟨feedback_destroys_openloop_contraction.2.2.2.1, Becoming.OplaxHistory.C2CoupledAlignmentWitness.c2_coupled_fiber_split⟩⟩

/-- Zero one-step `rowDefect` on prescribed `(K, L)` holds iff every pushed micro row matches `L (f u)`. -/
theorem rowDefect_eq_zero_iff_pushforward {U O : Type*} [Fintype U] [Fintype O]
    (f : U → O) (K : FinKernel U U) (L : FinKernel O O) :
    (∀ u, rowDefect f K L u = 0) ↔ ∀ u, pushforward f (K u) = L (f u) :=
  forall_congr' fun u => FiniteProb.tvDist_eq_zero_iff (pushforward f (K u)) (L (f u))

/-- Mode-indexed equivalence between zero `rowDefect` across all modes/states and pushforward commutation. -/
theorem modeRowDefect_eq_zero_iff_pushforward {Mode U O : Type*} [Fintype U] [Fintype O]
    (f : U → O) (K : Mode → FinKernel U U) (L : Mode → FinKernel O O) :
    (∀ a u, rowDefect f (K a) (L a) u = 0) ↔ ∀ a u, pushforward f (K a u) = L a (f u) :=
  forall_congr' fun a => rowDefect_eq_zero_iff_pushforward f (K a) (L a)

/-- Exact zero `rowDefect` across all modes and microstates characterizes `FiniteKrylov.FiberLumpable`
for Markov kernels `K : Mode → FinKernel U U` up to existence of a compatible macro kernel `L`. -/
theorem fiberLumpable_iff_exists_zero_rowDefect {Mode U O : Type*} [Fintype U] [Fintype O]
    (f : U → O) (K : Mode → FinKernel U U) :
    FiniteKrylov.FiberLumpable f (fun a u v => (K a u).w v) ↔
      ∃ L : Mode → FinKernel O O, ∀ a u, rowDefect f (K a) (L a) u = 0 := by
  constructor
  · intro hLump
    let L : Mode → FinKernel O O := fun a o =>
      if ho : ∃ u : U, f u = o then pushforward f (K a (Classical.choose ho)) else diracDist o
    refine ⟨L, fun a u => (FiniteProb.tvDist_eq_zero_iff _ _).mpr ?_⟩
    have ho : ∃ u' : U, f u' = f u := ⟨u, rfl⟩
    dsimp only [L]
    rw [dif_pos ho]
    refine FinDist.ext fun o => ?_
    dsimp only [pushforward, FiniteProb.pushforward]
    exact hLump a u (Classical.choose ho) (Classical.choose_spec ho).symm o
  · rintro ⟨L, hzero⟩ a s t hst o
    have hs := (FiniteProb.tvDist_eq_zero_iff (pushforward f (K a s)) (L a (f s))).mp (hzero a s)
    have ht := (FiniteProb.tvDist_eq_zero_iff (pushforward f (K a t)) (L a (f t))).mp (hzero a t)
    have hp : pushforward f (K a s) = pushforward f (K a t) := by
      rw [hs, ht, hst]
    exact congrArg (fun p => p.w o) hp

/-- Fixed-`L` negative control: singleton fibers on `Bool` are automatically `FiberLumpable`, yet
a mismatched macro kernel `L` (`id` vs `Bool.not`) produces `rowDefect = 1 ≠ 0`. -/
theorem fixed_macro_nonzero_rowDefect_witness :
    let f : Bool → Bool := id
    let K : Unit → FinKernel Bool Bool := fun _ b => diracDist b
    let L : FinKernel Bool Bool := fun b => diracDist (!b)
    FiniteKrylov.FiberLumpable f (fun a u v => (K a u).w v) ∧
      rowDefect f (K ()) L true = 1 ∧ rowDefect f (K ()) L true ≠ 0 := by
  intro f K L
  have hLump : FiniteKrylov.FiberLumpable f (fun a u v => (K a u).w v) := by
    intro () s t hst o
    have hst' : s = t := hst
    subst hst'
    rfl
  have hdef : rowDefect f (K ()) L true = 1 := by
    unfold rowDefect tvDist FiniteProb.tvDist
    have hpf : pushforward f (K () true) = diracDist true := FinDist.ext fun b => by
      cases b <;> simp [FiniteProb.pushforward, f, K, FiniteProb.diracDist]
    dsimp only [K, f] at hpf ⊢
    rw [hpf]
    dsimp only [L]
    simp [FiniteProb.diracDist]
    norm_num
  exact ⟨hLump, hdef, by rw [hdef]; norm_num⟩

end ObservationalFidelity
