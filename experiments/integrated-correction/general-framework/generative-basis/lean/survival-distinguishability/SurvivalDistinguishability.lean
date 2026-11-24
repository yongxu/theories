import Mathlib.Algebra.BigOperators.Field
import Mathlib.LinearAlgebra.Dimension.Constructions
import Mathlib.LinearAlgebra.FiniteDimensional.Lemmas
import Mathlib.Tactic
import Becoming.OplaxHistory

/-!
# Finite-Mode Survival Distinguishability (`SurvivalDistinguishability`)

AI-written (24 November 2026). Formalized with Lean 4.30.0-rc2 and Mathlib over `ℝ`,
importing `Becoming.OplaxHistory`. Uses only standard axioms (`propext`, `Classical.choice`,
`Quot.sound`), with `0` `sorryAx`, `0` `private`/`lemma`/`class`/unnamed `instance`, `0` market words.
-/

namespace SurvivalDistinguishability

open scoped BigOperators
open Classical

/-- Linear one-step transition operator induced by a matrix `M : S → S → ℝ`. -/
noncomputable def stepOp {S : Type*} [Fintype S] (M : S → S → ℝ) :
    (S → ℝ) →ₗ[ℝ] (S → ℝ) where
  toFun v s := ∑ s', M s s' * v s'
  map_add' u v := by ext s; simp [mul_add, Finset.sum_add_distrib]
  map_smul' c v := by ext s; simp [Finset.mul_sum, mul_left_comm]

/-- Mode-indexed survival vector over `S` starting from `ones := fun _ => (1 : ℝ)`
and stepping by `∑ s', K a s s' * survVec K w s'`. -/
noncomputable def survVec {S Mode : Type*} [Fintype S] (K : Mode → S → S → ℝ) :
    List Mode → S → ℝ
  | [] => fun _ => 1
  | a :: w => fun s => ∑ s', K a s s' * survVec K w s'

theorem survVec_cons {S Mode : Type*} [Fintype S] (K : Mode → S → S → ℝ)
    (a : Mode) (w : List Mode) :
    survVec K (a :: w) = stepOp (K a) (survVec K w) := rfl

/-- Krylov subspace spanned by survival vectors for words of length `≤ k`. -/
noncomputable def krylovSub {S Mode : Type*} [Fintype S]
    (K : Mode → S → S → ℝ) (k : ℕ) : Submodule ℝ (S → ℝ) :=
  Submodule.span ℝ { v | ∃ w : List Mode, w.length ≤ k ∧ v = survVec K w }

theorem krylovSub_mono {S Mode : Type*} [Fintype S] (K : Mode → S → S → ℝ)
    {k m : ℕ} (hkm : k ≤ m) : krylovSub K k ≤ krylovSub K m :=
  Submodule.span_mono fun _ ⟨w, hw, h⟩ => ⟨w, hw.trans hkm, h⟩

theorem one_le_finrank_krylov_zero {S Mode : Type*} [Fintype S] [Nonempty S]
    (K : Mode → S → S → ℝ) : 1 ≤ Module.finrank ℝ (krylovSub K 0) := by
  have hmem : survVec K [] ∈ krylovSub K 0 :=
    Submodule.subset_span ⟨[], Nat.zero_le 0, rfl⟩
  have hne : (survVec K [] : S → ℝ) ≠ 0 := by
    intro hzero
    obtain ⟨s₀⟩ := ‹Nonempty S›
    simpa [survVec] using congrFun hzero s₀
  exact Submodule.one_le_finrank_iff.mpr fun hbot =>
    hne ((Submodule.mem_bot ℝ).mp (hbot ▸ hmem))

theorem nat_chain_stabilizes (d : ℕ → ℕ) {n : ℕ} (hn : 1 ≤ n) (hd0 : 1 ≤ d 0)
    (hmono : ∀ k, d k ≤ d (k + 1)) (hbound : ∀ k, d k ≤ n) :
    ∃ k ≤ n - 1, d (k + 1) = d k := by
  by_contra hnone
  have hstep : ∀ k ≤ n - 1, d k + 1 ≤ d (k + 1) := fun k hk =>
    Nat.lt_of_le_of_ne (hmono k) fun heq => hnone ⟨k, hk, heq.symm⟩
  have hgrowth : ∀ j, j ≤ n → 1 + j ≤ d j := by
    intro j hj
    induction j with
    | zero => simpa using hd0
    | succ j ih =>
      have h1 := ih (by omega)
      have h2 := hstep j (by omega)
      omega
  have htop := hgrowth n le_rfl
  have hcap := hbound n
  omega

theorem krylovSub_map_step_le {S Mode : Type*} [Fintype S] (K : Mode → S → S → ℝ)
    (a : Mode) (k : ℕ) :
    (krylovSub K k).map (stepOp (K a)) ≤ krylovSub K (k + 1) := by
  rw [krylovSub, Submodule.map_span_le]
  rintro v ⟨w, hw, rfl⟩
  exact Submodule.subset_span ⟨a :: w, by simp; omega, rfl⟩

theorem survVec_mem_krylov_stabilized {S Mode : Type*} [Fintype S] (K : Mode → S → S → ℝ)
    {k : ℕ} (hstab : krylovSub K (k + 1) = krylovSub K k) :
    ∀ w : List Mode, survVec K w ∈ krylovSub K k
  | [] => krylovSub_mono K (Nat.zero_le k) (Submodule.subset_span ⟨[], Nat.zero_le 0, rfl⟩)
  | a :: w => by
    have hle := krylovSub_map_step_le K a k
    rw [hstab] at hle
    exact hle (Submodule.mem_map_of_mem (survVec_mem_krylov_stabilized K hstab w))

/-- **Headline Theorem (`survival_indistinguishable_iff_le_card_pred`):**
For `[Fintype S]` `[Nonempty S]` (`Fintype.card S ≥ 1`), two states `x y : S` agree on all
mode sequences `w : List Mode` iff they agree on all sequences of length `≤ Fintype.card S - 1`. -/
theorem survival_indistinguishable_iff_le_card_pred {S Mode : Type*}
    [Fintype S] [Nonempty S] (K : Mode → S → S → ℝ) (x y : S) :
    (∀ w : List Mode, survVec K w x = survVec K w y) ↔
      (∀ w : List Mode, w.length ≤ Fintype.card S - 1 → survVec K w x = survVec K w y) := by
  refine ⟨fun h w _ => h w, fun hshort w => ?_⟩
  obtain ⟨k, hk_le, hk_dim⟩ := nat_chain_stabilizes
    (fun k => Module.finrank ℝ (krylovSub K k)) Fintype.card_pos
    (one_le_finrank_krylov_zero K)
    (fun k => Submodule.finrank_mono (krylovSub_mono K (Nat.le_succ k)))
    (fun k => (krylovSub K k).finrank_le.trans_eq (Module.finrank_fintype_fun_eq_card ℝ))
  have hstab : krylovSub K (k + 1) = krylovSub K k :=
    (Submodule.eq_of_le_of_finrank_eq (krylovSub_mono K (Nat.le_succ k)) hk_dim.symm).symm
  have hmem : survVec K w ∈ krylovSub K (Fintype.card S - 1) :=
    krylovSub_mono K hk_le (survVec_mem_krylov_stabilized K hstab w)
  refine Submodule.span_induction (p := fun v _ => v x = v y) ?_ rfl ?_ ?_ hmem
  · rintro _ ⟨u, hu, rfl⟩; exact hshort u hu
  · intro u v _ _ hu hv; simp [hu, hv]
  · intro c u _ hu; simp [hu]

/-- One-mode countdown operator on `Fin (n + 1)`: `i < n` steps to `i + 1`, while `n` exits. -/
noncomputable def countdownK (n : ℕ) : Unit → Fin (n + 1) → Fin (n + 1) → ℝ :=
  fun _ s s' => if s.val < n ∧ s'.val = s.val + 1 then 1 else 0

theorem survVec_countdownK (n : ℕ) :
    ∀ (w : List Unit) (s : Fin (n + 1)),
      survVec (countdownK n) w s = if s.val + w.length ≤ n then 1 else 0
  | [], s => by simp [survVec, Nat.lt_succ_iff.mp s.isLt]
  | _ :: w, s => by
    rw [survVec_cons]
    dsimp only [stepOp, LinearMap.coe_mk, AddHom.coe_mk, countdownK]
    by_cases hs : s.val < n
    · let next : Fin (n + 1) := ⟨s.val + 1, Nat.succ_lt_succ hs⟩
      have hsum : (∑ s' : Fin (n + 1),
          (if s.val < n ∧ s'.val = s.val + 1 then (1 : ℝ) else 0) * survVec (countdownK n) w s') =
          survVec (countdownK n) w next := by
        rw [Finset.sum_eq_single next]
        · simp [next, hs]
        · intro b _ hne
          simp [show b.val ≠ s.val + 1 from fun heq => hne (Fin.ext heq)]
        · intro hmem; exact False.elim (hmem (Finset.mem_univ next))
      rw [hsum, survVec_countdownK n w next]
      simp [next, Nat.add_assoc, Nat.add_comm 1 w.length]
    · have hsum : (∑ s' : Fin (n + 1),
          (if s.val < n ∧ s'.val = s.val + 1 then (1 : ℝ) else 0) * survVec (countdownK n) w s') = 0 :=
        Finset.sum_eq_zero fun s' _ => by simp [hs]
      have hs_eq : s.val = n := by omega
      rw [hsum]
      simp [hs_eq]

/-- **Sharpness Witness (`countdown_attains_card_pred`):**
For every `n ≥ 1` on `Fin (n + 1)` (`Fintype.card (Fin (n + 1)) - 1 = n`), states `0` and `1`
agree on all sequences of length `< n` and separate at exact length `n = card - 1`. -/
theorem countdown_attains_card_pred (n : ℕ) (hn : 1 ≤ n) :
    let x₀ : Fin (n + 1) := ⟨0, Nat.zero_lt_succ n⟩
    let x₁ : Fin (n + 1) := ⟨1, Nat.lt_succ_of_le hn⟩
    (∀ w : List Unit, w.length < Fintype.card (Fin (n + 1)) - 1 →
      survVec (countdownK n) w x₀ = survVec (countdownK n) w x₁) ∧
    (∃ w : List Unit, w.length = Fintype.card (Fin (n + 1)) - 1 ∧
      survVec (countdownK n) w x₀ = 1 ∧ survVec (countdownK n) w x₁ = 0 ∧
      survVec (countdownK n) w x₀ ≠ survVec (countdownK n) w x₁) := by
  intro x₀ x₁
  have hcard : Fintype.card (Fin (n + 1)) - 1 = n := by simp
  have h0 : survVec (countdownK n) (List.replicate n ()) x₀ = 1 := by
    rw [survVec_countdownK]; simp [x₀]
  have h1 : survVec (countdownK n) (List.replicate n ()) x₁ = 0 := by
    rw [survVec_countdownK]
    have hnot : ¬ (x₁.val + (List.replicate n ()).length ≤ n) := by dsimp [x₁]; simp
    rw [if_neg hnot]
  refine ⟨fun w hw => ?_, ⟨List.replicate n (), by simp, h0, h1, by rw [h0, h1]; norm_num⟩⟩
  rw [hcard] at hw
  rw [survVec_countdownK, survVec_countdownK]
  have ha : x₀.val + w.length ≤ n := by dsimp [x₀]; omega
  have hb : x₁.val + w.length ≤ n := by dsimp [x₁]; omega
  simp [ha, hb]

/-- Three-state two-mode operator on `Fin 3`: `false` (`A`) fixes `0, 2` and sends `1 ↦ 2`;
`true` (`B`) fixes `0, 1` and kills `2`. -/
noncomputable def switchK : Bool → Fin 3 → Fin 3 → ℝ
  | false, s, s' => if s = 0 then (if s' = 0 then 1 else 0) else (if s' = 2 then 1 else 0)
  | true, s, s' => if s = 2 then 0 else (if s' = s then 1 else 0)

theorem survVec_switchK_false (k : ℕ) (s : Fin 3) :
    survVec switchK (List.replicate k false) s = 1 := by
  induction k generalizing s with
  | zero => simp [survVec]
  | succ k ih =>
    rw [List.replicate_succ, survVec_cons]
    dsimp only [stepOp, LinearMap.coe_mk, AddHom.coe_mk]
    fin_cases s <;> simp [switchK, ih]

theorem survVec_switchK_true (k : ℕ) :
    survVec switchK (List.replicate k true) 0 = 1 ∧
      survVec switchK (List.replicate k true) 1 = 1 := by
  induction k with
  | zero => simp [survVec]
  | succ k ih =>
    rw [List.replicate_succ, survVec_cons]
    dsimp only [stepOp, LinearMap.coe_mk, AddHom.coe_mk]
    refine ⟨?_, ?_⟩ <;> simp [switchK, ih.1, ih.2]

/-- **Negative Control (`three_state_mode_switch_counterexample`):**
All constant `[false]*k` and `[true]*k` give survival `1` at `0` and `1`, yet `[false, true]`
gives `1` at `0` and `0` at `1`. -/
theorem three_state_mode_switch_counterexample :
    (∀ k : ℕ, survVec switchK (List.replicate k false) 0 = 1 ∧
        survVec switchK (List.replicate k false) 1 = 1) ∧
    (∀ k : ℕ, survVec switchK (List.replicate k true) 0 = 1 ∧
        survVec switchK (List.replicate k true) 1 = 1) ∧
    survVec switchK [false, true] 0 = 1 ∧
    survVec switchK [false, true] 1 = 0 := by
  refine ⟨fun k => ⟨survVec_switchK_false k 0, survVec_switchK_false k 1⟩,
    survVec_switchK_true, ?_, ?_⟩ <;> simp [survVec, switchK, Fin.sum_univ_three]

/-- Finite state slice `(Bool × Bool) × Bool` of `C2CoupledAlignmentWitness` (`z ∈ {0, 1}`). -/
abbrev C2FinState : Type := (Bool × Bool) × Bool

/-- Embedding of `C2FinState` into `Becoming.OplaxHistory.C2CoupledAlignmentWitness.CoupledState`. -/
def c2Embed (s : C2FinState) : Becoming.OplaxHistory.C2CoupledAlignmentWitness.CoupledState :=
  (s.1, if s.2 then 1 else 0)

/-- Finite sub-stochastic operator induced on `C2FinState` by `C2CoupledAlignmentWitness.stepFn`
on live states (`s.2 = true`). -/
noncomputable def c2Op : Unit → C2FinState → C2FinState → ℝ :=
  fun _ s s' =>
    if s.2 = true ∧ s'.2 = true ∧
        c2Embed s' = Becoming.OplaxHistory.C2CoupledAlignmentWitness.stepFn (c2Embed s) ()
    then 1 else 0

/-- **Existing-Model Client (`c2_coupled_survival_separation`):**
On `C2CoupledAlignmentWitness`, `finInPhase` and `finAntiPhase` share `c2ProjMicro = 1`, yet
`survival_indistinguishable_iff_le_card_pred` separates them at `1 ≤ Fintype.card C2FinState - 1`. -/
theorem c2_coupled_survival_separation :
    let finInPhase : C2FinState := ((true, true), true)
    let finAntiPhase : C2FinState := ((true, false), true)
    c2Embed finInPhase = Becoming.OplaxHistory.C2CoupledAlignmentWitness.uInPhase ∧
    c2Embed finAntiPhase = Becoming.OplaxHistory.C2CoupledAlignmentWitness.uAntiPhase ∧
    Becoming.OplaxHistory.C2CoupledAlignmentWitness.c2ProjMicro (c2Embed finInPhase) =
      Becoming.OplaxHistory.C2CoupledAlignmentWitness.c2ProjMicro (c2Embed finAntiPhase) ∧
    ([()] : List Unit).length ≤ Fintype.card C2FinState - 1 ∧
    survVec c2Op [()] finInPhase = 1 ∧ survVec c2Op [()] finAntiPhase = 0 ∧
    ¬ (∀ w : List Unit, survVec c2Op w finInPhase = survVec c2Op w finAntiPhase) ∧
    Becoming.Viability.Kernel Becoming.OplaxHistory.C2CoupledAlignmentWitness.proc
      Becoming.OplaxHistory.C2CoupledAlignmentWitness.guardS (c2Embed finInPhase) ∧
    ¬ Becoming.Viability.Kernel Becoming.OplaxHistory.C2CoupledAlignmentWitness.proc
      Becoming.OplaxHistory.C2CoupledAlignmentWitness.guardS (c2Embed finAntiPhase) := by
  intro finInPhase finAntiPhase
  have h1 : survVec c2Op [()] finInPhase = 1 := by
    rw [survVec_cons]
    dsimp only [stepOp, LinearMap.coe_mk, AddHom.coe_mk, survVec]
    rw [Finset.sum_eq_single finInPhase]
    · simp [c2Op, c2Embed, finInPhase, Becoming.OplaxHistory.C2CoupledAlignmentWitness.stepFn]
    · intro b _ hne
      have h0 : ¬ (finInPhase.2 = true ∧ b.2 = true ∧
          c2Embed b = Becoming.OplaxHistory.C2CoupledAlignmentWitness.stepFn
            (c2Embed finInPhase) ()) := by
        rintro ⟨_, hb2, hstep⟩
        apply hne
        cases b with | mk p b2 => cases p with | mk b1 b3 =>
          simp [c2Embed, finInPhase, Becoming.OplaxHistory.C2CoupledAlignmentWitness.stepFn] at hstep hb2
          subst hb2; rcases hstep with ⟨rfl, rfl⟩; rfl
      simp [c2Op, h0]
    · intro hmem; exact False.elim (hmem (Finset.mem_univ finInPhase))
  have h0 : survVec c2Op [()] finAntiPhase = 0 := by
    rw [survVec_cons]
    dsimp only [stepOp, LinearMap.coe_mk, AddHom.coe_mk, survVec]
    refine Finset.sum_eq_zero fun b _ => ?_
    have hfalse : ¬ (finAntiPhase.2 = true ∧ b.2 = true ∧
        c2Embed b = Becoming.OplaxHistory.C2CoupledAlignmentWitness.stepFn
          (c2Embed finAntiPhase) ()) := by
      rintro ⟨_, hb2, hstep⟩
      simp [c2Embed, finAntiPhase, Becoming.OplaxHistory.C2CoupledAlignmentWitness.stepFn, hb2] at hstep
      exact Nat.one_ne_zero (congrArg Prod.snd hstep)
    simp [c2Op, hfalse]
  have hcard : ([()] : List Unit).length ≤ Fintype.card C2FinState - 1 := by decide
  have hnot : ¬ (∀ w : List Unit, survVec c2Op w finInPhase = survVec c2Op w finAntiPhase) := by
    rw [survival_indistinguishable_iff_le_card_pred]
    intro hall
    have heq := hall [()] hcard
    rw [h1, h0] at heq
    norm_num at heq
  exact ⟨rfl, rfl, rfl, hcard, h1, h0, hnot,
    Becoming.OplaxHistory.C2CoupledAlignmentWitness.uInPhase_kernel,
    Becoming.OplaxHistory.C2CoupledAlignmentWitness.uAntiPhase_not_kernel⟩

end SurvivalDistinguishability
