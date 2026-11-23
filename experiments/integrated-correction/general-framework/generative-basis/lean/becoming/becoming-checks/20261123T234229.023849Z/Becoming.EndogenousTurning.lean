import Becoming.Optimum
import Becoming.Clearing
import Becoming.AdaptiveLoops
import Becoming.StockFlowBridge
import Becoming.Cascade
import Becoming.Unread
import Becoming.OpenComposition
import Becoming.CoreHelpers

/-!
# Endogenous turning and the epistemic silence boundary (`Becoming.EndogenousTurning`)

AI-written (Lean Sufficiency Wave, Pillar L1, 23 November 2026). All declarations compile from
Lean's prelude (`Init` alone) with zero `sorry`, zero axioms (empty axiom reports), zero `private`
declarations, zero `lemma`s, and zero unnamed instances.

This module establishes the structural core of selection-induced overdraw, endogenous task-bottleneck
registration, pooled `Clearing` turning, and the epistemic silence boundary:

* **Part A — Derived selection-induced drawdown (no `draw_rises` axiom).**
  Overdraw is derived from `Requirement.Frontier` optimization under `Optimum.Rising` over visible
  conditions `ds` whenever structural room or asymmetric marginal yield allows higher substrate draw
  to raise visible conditions:
  - `flow_proxy_optimum_collapse`: derives full capacity exhaust (`Optimum.course_beyond`) in a
    flow/web setting, collapsing via `Becoming.Web.lost_over` and `StockFlowBridge.unitNeverReturnsBelowWithin`,
    paired with single-step `flow_step_breaks_beyond` via `Becoming.Flow.Balances.breaks_beyond`.
  - `roomBelow_of_marginal_yield`, `optimum_forces_overdraw`, `proxy_optimum_overdraw_collapse`
    (Hook 1), `constrained_selector_viable`, and concrete trace witness `PartAWitness`.
* **Part B.1 — Non-oracle coupled task bottleneck (`ServiceTaskModel`).**
  Derives `B_task := demand safe + ((upkeep ext - upkeep safe) + gain - 1) / gain` from
  saturating throughput `gain * min (demand p) x` minus operating upkeep (`upkeep p`), with zero
  stored alarm threshold or `if x < B_task` switch (`score_crosses_iff`, `B_task_le_demand_ext`,
  `ext_preferred_above`, `safe_not_preferred_from_B_task`).
* **Part B.2 — Timely endogenous turning (`EndogenousSystem` and `PooledClearing`).**
  - `EndogenousSystem.timely_turning_kernel`, `endogenous_turning_kernel` (Hook 2), and
    `EndogenousSystem.ofServiceTask` prove `Viability.Kernel` viability under saturating
    non-monotone carrying-capacity substrates (`RegimeMargin.Meets`, `RegimeMargin.Keeps`) whenever
    `(H_safe + y_safe) + drawCeiling * (lag + 1) ≤ B_task`, with qualified Turn Guarantee.
  - `pooled_service_turning_viable` (Hook 3) and `PooledClearing.{pooled_clearing_turning,
    unpooled_clearer_blind}` compose an uncoupled `proxyAgent` listening to a blind pooled channel
    with a `ServiceTaskModel`-coupled `taskPartner` via `AdaptiveLoops.assume_guarantee_joint_viable`.
* **Part B.3 — Epistemic silence boundary & unified non-degenerate witness (`TurningWitness`).**
  - `epistemic_silence_late_bottleneck` (`B_task ≤ H_safe + y_safe`),
    `service_saturated_below_noReturn_silenced` (`demand ext ≤ H_safe + y_safe`),
    `epistemic_silence_masked_unread` (`ClosedCapture.Unread` without requiring monotone `g`), and
    `epistemic_silence_cascade` (`Turns.ReadsOnlyActsFrom`, followed by `cascade_twin_free` via `Learning.twin_selected`).
  - `TurningWitness.{timely_survives, late_collapses, cascade_collapses}` share one saturating
    substrate `wGivingCap`, one initial stock `27`, and one upkeep/draw scale.
* **L0 Open-Composition Bridge (`OpenCompositionBridge`).**
  - Lifts `PooledClearing.{proxyLoop, proxyCert}` and `PooledClearing.{taskLoop, taskCert}` to
    `OpenComposition.{OpenComponent, InterfaceContract}`, composes via `compose_close_interchange`
    (`pooled_clearing_open_compose_viable`), proves heterogeneous live mid-run partner rewrite safety
    via `OpenComposition.rewrite_step_viable` (`clearing_partner_reconfig_viable` + `ReconfigWitness`),
    and proves blind-vs-widened clearing contrast (`clearing_widening_heals_blindness` +
    `widening_heals_witness`).

Non-implications: Rule 2 empirical recognition (checking whether an actual process meets a
theorem's premises lies outside deduction) and `Becoming.Significance.ReadsOnlyDynamics.not_entails`
(dynamical survival or collapse entails neither moral ought nor `Unrestricted` significance).
-/

namespace Becoming

open Generative

namespace EndogenousTurning

/-! ## 1. Variable-draw `RegimeMargin` / `StockFlowBridge` bridges -/

/-! ### Variable-draw `RegimeMargin` localization and exact `StockFlowBridge` trap -/

theorem falls_or_bound_ge {g d x : Nat → Nat} {Y H_min b : Nat}
    (step_eq : ∀ t, x (t + 1) = RegimeMargin.step g (d t) (x t))
    (most : RegimeMargin.AtMost g Y) (nothing : RegimeMargin.FromNothing g)
    (yle : Y ≤ H_min) (d_ge : ∀ t, H_min ≤ d t) (b_pos : 0 < b) :
    ∀ n, (∃ k, k ≤ n ∧ x k < b) ∨ (x n + (H_min - Y) * n ≤ x 0 ∧ b ≤ x n)
  | 0 => (Nat.lt_or_ge (x 0) b).elim (fun lt => .inl ⟨0, Nat.le_refl 0, lt⟩)
      (fun ge => .inr ⟨Nat.le_refl (x 0), ge⟩)
  | n + 1 => (falls_or_bound_ge step_eq most nothing yle d_ge b_pos n).elim
      (fun ⟨k, kle, lt⟩ => .inl ⟨k, Nat.le_succ_of_le kle, lt⟩)
      (fun ⟨bound, _⟩ =>
        match Nat.lt_or_ge (x n) (d n) with
        | .inl underD =>
          have xzero : x (n + 1) = 0 := by
            rw [step_eq n, RegimeMargin.step, sub_eq_zero_of_le (Nat.le_of_lt underD), Nat.zero_add]
            exact nothing
          .inl ⟨n + 1, Nat.le_refl _, xzero ▸ b_pos⟩
        | .inr overD => by
          have stepFalls : x (n + 1) + (H_min - Y) ≤ x n := by
            rw [step_eq n, RegimeMargin.step]
            calc (x n - d n) + g (x n - d n) + (H_min - Y)
                ≤ (x n - d n) + Y + (H_min - Y) :=
                  Nat.add_le_add_right (Nat.add_le_add_left (most _) _) _
              _ = (x n - d n) + (Y + (H_min - Y)) := Nat.add_assoc _ _ _
              _ = (x n - d n) + H_min := by rw [add_sub_of_le yle]
              _ ≤ (x n - d n) + d n := Nat.add_le_add_left (d_ge n) _
              _ = x n := Naturals.sub_add_cancel overD
          have bound' : x (n + 1) + (H_min - Y) * (n + 1) ≤ x 0 := by
            calc x (n + 1) + (H_min - Y) * (n + 1)
                = x (n + 1) + ((H_min - Y) * n + (H_min - Y)) := rfl
              _ = x (n + 1) + ((H_min - Y) + (H_min - Y) * n) := by
                  rw [Nat.add_comm ((H_min - Y) * n) (H_min - Y)]
              _ = (x (n + 1) + (H_min - Y)) + (H_min - Y) * n := (Nat.add_assoc _ _ _).symm
              _ ≤ x n + (H_min - Y) * n := Nat.add_le_add_right stepFalls _
              _ ≤ x 0 := bound
          exact (Nat.lt_or_ge (x (n + 1)) b).elim
            (fun lt => .inl ⟨n + 1, Nat.le_refl _, lt⟩)
            (fun ge => .inr ⟨bound', ge⟩))

/-- **Variable-draw `RegimeMargin` localization**: does NOT require `g` monotone and does NOT
require `H_min ≤ b` (only `0 < b` and `FromNothing g`). -/
theorem falls_within_ge {g d x : Nat → Nat} {Y H_min b : Nat}
    (step_eq : ∀ t, x (t + 1) = RegimeMargin.step g (d t) (x t))
    (most : RegimeMargin.AtMost g Y) (nothing : RegimeMargin.FromNothing g)
    (yle : Y ≤ H_min) (d_ge : ∀ t, H_min ≤ d t) (b_pos : 0 < b)
    (n : Nat) (within : x 0 < b + (H_min - Y) * n) :
    ∃ k, k ≤ n ∧ x k < b :=
  (falls_or_bound_ge step_eq most nothing yle d_ge b_pos n).elim id fun ⟨bound, above⟩ =>
    absurd (Nat.lt_of_le_of_lt (Nat.le_trans (Nat.add_le_add_right above _) bound) within)
      (Nat.lt_irrefl _)

/-- Actual flow take from the substrate at step `t` (`CoreHelpers.natMin (d t) (x t)`). -/
def actualTake (d x : Nat → Nat) (t : Nat) : Nat := CoreHelpers.natMin (d t) (x t)

theorem actualTake_le (d x : Nat → Nat) (t : Nat) : actualTake d x t ≤ x t :=
  CoreHelpers.natMin_le_right (d t) (x t)

/-- Exact all-horizon `StockFlowBridge` conservation for `actualTake`. -/
theorem clamped_balances_trap {g d x : Nat → Nat}
    (step_eq : ∀ t, x (t + 1) = RegimeMargin.step g (d t) (x t)) (t : Nat) :
    (StockFlowBridge.unitFlow (actualTake d x)
      (fun k => g (x k - actualTake d x k))).BalancesOn (StockFlowBridge.unitWeb x) [()] t :=
  StockFlowBridge.unitBalancesOn_of_le
    ((step_eq t).trans (congrArg (fun z => z + g z) (CoreHelpers.sub_natMin_right (x t) (d t)).symm))
    (actualTake_le d x t)

/-- Pre-overdraw unclamped `StockFlowBridge` conservation on `[0, T)`. -/
theorem pre_overdraw_flow_conservation {g d x : Nat → Nat} {T : Nat}
    (step_eq : ∀ t, x (t + 1) = RegimeMargin.step g (d t) (x t))
    (within : ∀ t, t < T → d t ≤ x t) :
    x T + total (steps 0 T) d = x 0 + total (steps 0 T) (fun t => g (x t - d t)) := by
  have bal : ∀ t, 0 ≤ t → t < 0 + T →
      (StockFlowBridge.unitFlow d (fun k => g (x k - d k))).BalancesOn
        (StockFlowBridge.unitWeb x) [()] t :=
    fun t _ ht => StockFlowBridge.unitBalancesOn_of_le (step_eq t)
      (within t (Nat.lt_of_lt_of_le ht (Nat.le_of_eq (Nat.zero_add T))))
  have h := StockFlowBridge.unitAccumulates_of_balances bal
  rw [Nat.zero_add] at h
  exact h

theorem step_lt_of_short_ge {g d x : Nat → Nat} {H_safe y_safe t : Nat}
    (step_eq : ∀ t, x (t + 1) = RegimeMargin.step g (d t) (x t))
    (short : RegimeMargin.Short g H_safe y_safe) (nothing : RegimeMargin.FromNothing g)
    (d_ge : H_safe ≤ d t) (below : x t < H_safe + y_safe) :
    g (x t - actualTake d x t) ≤ actualTake d x t ∧ (0 < x t → x (t + 1) < x t) ∧
      (x t = 0 → x (t + 1) = 0) := by
  refine ⟨?_, ?_, ?_⟩
  · cases Nat.lt_or_ge (x t) (d t) with
    | inl lt =>
      rw [actualTake, CoreHelpers.natMin_eq_right (Nat.le_of_lt lt), sub_eq_zero_of_le (Nat.le_refl _), nothing]
      exact Nat.zero_le _
    | inr ge =>
      rw [actualTake, CoreHelpers.natMin_eq_left ge]
      have hSafeLe : H_safe ≤ x t := Nat.le_trans d_ge ge
      have subLt : x t - H_safe < y_safe :=
        Naturals.lt_of_add_lt_add_left (k := H_safe)
          (Nat.lt_of_le_of_lt (Nat.le_of_eq (Naturals.add_sub_of_le hSafeLe)) below)
      have leSub : x t - d t ≤ x t - H_safe := Naturals.sub_antitone (x t) d_ge
      exact Nat.le_trans (Nat.le_of_lt (short _ (Nat.lt_of_le_of_lt leSub subLt))) d_ge
  · intro pos
    cases Nat.lt_or_ge (x t) (d t) with
    | inl lt =>
      rw [step_eq t, RegimeMargin.step, sub_eq_zero_of_le (Nat.le_of_lt lt), Nat.zero_add, nothing]
      exact pos
    | inr ge =>
      have hSafeLe : H_safe ≤ x t := Nat.le_trans d_ge ge
      have subLt : x t - H_safe < y_safe :=
        Naturals.lt_of_add_lt_add_left (k := H_safe)
          (Nat.lt_of_le_of_lt (Nat.le_of_eq (Naturals.add_sub_of_le hSafeLe)) below)
      have leSub : x t - d t ≤ x t - H_safe := Naturals.sub_antitone (x t) d_ge
      have gLt : g (x t - d t) < d t :=
        Nat.lt_of_lt_of_le (short _ (Nat.lt_of_le_of_lt leSub subLt)) d_ge
      rw [step_eq t, RegimeMargin.step]
      exact Nat.lt_of_lt_of_le (Nat.add_lt_add_left gLt (x t - d t))
        (Nat.le_of_eq (Naturals.sub_add_cancel ge))
  · intro hz
    rw [step_eq t, RegimeMargin.step, hz, Nat.zero_sub, Nat.zero_add]
    exact nothing

/-- **Post-crossing non-recovery and finite-time collapse to `0`**, bridged through
`StockFlowBridge.unitNeverReturnsBelowWithin`. -/
theorem short_stays_below_ge {g d x : Nat → Nat} {H_safe y_safe T : Nat}
    (step_eq : ∀ t, x (t + 1) = RegimeMargin.step g (d t) (x t))
    (short : RegimeMargin.Short g H_safe y_safe) (nothing : RegimeMargin.FromNothing g)
    (d_ge : ∀ t, T ≤ t → H_safe ≤ d t) (below : x T < H_safe + y_safe) :
    (∀ k, (StockFlowBridge.unitWeb x).level (T + k) () < H_safe + y_safe) ∧
    (∃ M, x M = 0 ∧ ∀ j, x (M + j) = 0) := by
  have stay : ∀ k, (StockFlowBridge.unitWeb x).level (T + k) () < H_safe + y_safe := fun k =>
    StockFlowBridge.unitNeverReturnsBelowWithin
      (takeFn := actualTake d x) (giveFn := fun m => g (x m - actualTake d x m))
      (m := H_safe + y_safe) (T := T) (N := k)
      (fun t _ _ => clamped_balances_trap step_eq t)
      (fun t hT _ low => (step_lt_of_short_ge step_eq short nothing (d_ge t hT) low).1)
      below k (Nat.le_refl k)
  have boundDec : ∀ m, x (T + m) ≤ x T - m := fun m => by
    induction m with
    | zero => exact Nat.le_refl _
    | succ m ih =>
      have low : x (T + m) < H_safe + y_safe := stay m
      have h := step_lt_of_short_ge step_eq short nothing (d_ge (T + m) (Nat.le_add_right T m)) low
      cases hm : x (T + m) with
      | zero =>
        have xz : x (T + (m + 1)) = 0 := h.2.2 hm
        rw [xz]
        exact Nat.zero_le _
      | succ v =>
        have dec := h.2.1 (hm ▸ Nat.succ_pos v)
        have leV : x (T + m + 1) ≤ v := Nat.le_of_lt_succ (Nat.lt_of_lt_of_le dec (Nat.le_of_eq hm))
        have leSub : v ≤ x T - m - 1 := by
          have ih' : v + 1 ≤ x T - m := Nat.le_trans (Nat.le_of_eq hm.symm) ih
          exact Naturals.le_sub_of_add_le (Nat.add_comm 1 v ▸ ih')
        rw [Naturals.sub_sub] at leSub
        exact Nat.le_trans leV leSub
  have atZero : x (T + x T) = 0 :=
    Nat.eq_zero_of_le_zero (Nat.le_trans (boundDec (x T)) (Nat.le_of_eq (sub_eq_zero_of_le (Nat.le_refl _))))
  have staysZero : ∀ j, x ((T + x T) + j) = 0 := fun j => by
    induction j with
    | zero => exact atZero
    | succ j ih =>
      have lowJ : x (T + x T + j) < H_safe + y_safe := by
        show x (T + x T + j) < H_safe + y_safe
        rw [Nat.add_assoc T (x T) j]
        exact stay (x T + j)
      have h := step_lt_of_short_ge step_eq short nothing
        (d_ge (T + x T + j) (Nat.le_trans (Nat.le_add_right T (x T)) (Nat.le_add_right _ j)))
        lowJ
      exact h.2.2 ih
  exact ⟨stay, T + x T, atZero, staysZero⟩

/-- Rewriting `RegimeMargin.step` into `Optimum.gated_stays_below` when `0 < m`: once below `m`,
every gated trajectory stays below `m` under ANY post-`T` draw sequence (even `d = 0`). -/
theorem gated_step_stays_below {g d x : Nat → Nat} {m T : Nat}
    (step_eq : ∀ t, x (t + 1) = RegimeMargin.step g (d t) (x t))
    (m_pos : 0 < m) (gated : RegimeMargin.Gated g m) (below : x T < m) (j : Nat) :
    x (T + j) < m := by
  let g' : Nat → Nat := fun t => g (x t - d t)
  have optStep : ∀ t, x (t + 1) = x t + g' t - d t := fun t => by
    rw [step_eq t, RegimeMargin.step]
    cases Nat.lt_or_ge (x t) (d t) with
    | inl lt =>
      have hz : x t - d t = 0 := sub_eq_zero_of_le (Nat.le_of_lt lt)
      have gz : g 0 = 0 := gated 0 m_pos
      change (x t - d t) + g (x t - d t) = x t + g (x t - d t) - d t
      rw [hz, gz, Nat.add_zero, Nat.add_zero, hz]
    | inr ge =>
      change (x t - d t) + g (x t - d t) = x t + g (x t - d t) - d t
      have eq1 : x t + g (x t - d t) = ((x t - d t) + g (x t - d t)) + d t := by
        calc x t + g (x t - d t) = (x t - d t + d t) + g (x t - d t) :=
              congrArg (· + g (x t - d t)) (Naturals.sub_add_cancel ge).symm
          _ = (x t - d t) + (d t + g (x t - d t)) := Nat.add_assoc _ _ _
          _ = (x t - d t) + (g (x t - d t) + d t) :=
              congrArg ((x t - d t) + ·) (Nat.add_comm _ _)
          _ = ((x t - d t) + g (x t - d t)) + d t := (Nat.add_assoc _ _ _).symm
      rw [eq1, Naturals.add_sub_cancel]
  have unsup : ∀ t, x t < m → g' t = 0 := fun t xt =>
    gated (x t - d t) (Nat.lt_of_le_of_lt (Nat.sub_le (x t) (d t)) xt)
  exact Optimum.gated_stays_below optStep unsup below j

/-- Safe-regime single-step viability without requiring `g` monotone above `hi`. -/
theorem safe_regime_step_viable {g : Nat → Nat} {H_safe y_safe hi d x : Nat}
    (meets : RegimeMargin.Meets g H_safe y_safe hi)
    (keeps : RegimeMargin.Keeps g 0 hi)
    (band_room : (H_safe + y_safe) + H_safe ≤ hi)
    (low : H_safe + y_safe ≤ x) (high : x ≤ hi) (draw_le : d ≤ H_safe) :
    H_safe + y_safe ≤ RegimeMargin.step g d x ∧ RegimeMargin.step g d x ≤ hi := by
  have sub_hi : x - d ≤ hi := Nat.le_trans (Nat.sub_le x d) high
  have upper : RegimeMargin.step g d x ≤ hi := by
    have k := keeps (x - d) sub_hi
    rw [RegimeMargin.step, Nat.sub_zero] at k
    exact k
  have lower : H_safe + y_safe ≤ RegimeMargin.step g d x := by
    rw [RegimeMargin.step]
    have y_le : y_safe ≤ x - d := Naturals.le_sub_of_add_le
      (Nat.le_trans (Nat.add_le_add_right draw_le y_safe) low)
    cases Nat.lt_or_ge hi ((x - d) + H_safe) with
    | inl overHi =>
      have strictly : H_safe + y_safe < x - d := by
        have hLt : H_safe + (H_safe + y_safe) < H_safe + (x - d) := by
          rw [Nat.add_comm H_safe (H_safe + y_safe), Nat.add_comm H_safe (x - d)]
          exact Nat.lt_of_le_of_lt band_room overHi
        exact Naturals.lt_of_add_lt_add_left hLt
      exact Nat.le_trans (Nat.le_of_lt strictly) (Nat.le_add_right _ _)
    | inr withinHi =>
      have g_ge : H_safe ≤ g (x - d) := meets (x - d) y_le withinHi
      calc H_safe + y_safe = y_safe + H_safe := Nat.add_comm H_safe y_safe
        _ ≤ (x - d) + g (x - d) := Nat.add_le_add y_le g_ge
  exact ⟨lower, upper⟩

/-! ## 2. Part A — Derived Selection-Induced Drawdown (No `draw_rises` Axiom) -/

/-! ### 2.1 Track A1 — Flow / Outcome Derivation (`Optimum` + `Becoming.Web.lost_over` + `Flow.Balances.breaks_beyond`) -/

/-- Rewriting a flow balance step (`x + g (x - d) - d`) into `RegimeMargin.step g d x`
under `FromNothing g`. -/
theorem flow_step_eq_regime {g : Nat → Nat} (nothing : RegimeMargin.FromNothing g) (x d : Nat) :
    x + g (x - d) - d = RegimeMargin.step g d x := by
  cases Nat.lt_or_ge x d with
  | inl lt =>
    have hz : x - d = 0 := sub_eq_zero_of_le (Nat.le_of_lt lt)
    rw [RegimeMargin.step, hz, nothing, Nat.add_zero, Nat.zero_add, hz]
  | inr ge =>
    rw [RegimeMargin.step]
    have eq1 : x + g (x - d) = ((x - d) + g (x - d)) + d := by
      calc x + g (x - d) = (x - d + d) + g (x - d) :=
            congrArg (· + g (x - d)) (Naturals.sub_add_cancel ge).symm
        _ = (x - d) + (d + g (x - d)) := Nat.add_assoc _ _ _
        _ = (x - d) + (g (x - d) + d) := congrArg ((x - d) + ·) (Nat.add_comm _ _)
        _ = ((x - d) + g (x - d)) + d := (Nat.add_assoc _ _ _).symm
    rw [eq1, Naturals.add_sub_cancel]

/-- **Track A1 (Flow / Outcome derivation)**: `Optimum.Rising` + `Optimum.Reoptimizes`
derives full capacity exhaust on `c ∈ rest` (`Optimum.course_beyond`), driving finite-time
break below `H_safe + y_safe`, collapse to `0` (`StockFlowBridge.unitNeverReturnsBelowWithin`),
and broken dependence (`Becoming.Web.lost_over`). -/
theorem flow_proxy_optimum_collapse
    {F C : Type} [DecidableEq F] [DecidableEq C]
    (L : Flow F C) (W : Web F C) (part : F → Bool) (cap : F → C → Nat)
    (ds rest : List C) (better : (C → Nat) → (C → Nat) → Prop)
    (distinct : ∀ t, Distinct (L.present t))
    (cdistinct : Distinct (ds ++ rest))
    (apart : ∀ c, c ∈ rest → ¬ c ∈ ds)
    {e c : C} (inside : e ∈ ds) (mem : c ∈ rest)
    (rising : Optimum.Rising ds better)
    (course : Optimum.Reoptimizes L W part cap ds rest better)
    (g : Nat → Nat) {Y H_min H_safe y_safe m : Nat}
    (renews_eq : ∀ t,
      L.restGiven part t c = g (W.level t c - (L.restTaken part t c + L.capacity part cap t c)))
    (most : RegimeMargin.AtMost g Y) (over : Y < H_min)
    (short : RegimeMargin.Short g H_safe y_safe) (hSafeLe : H_safe ≤ H_min)
    (nothing : RegimeMargin.FromNothing g) (hPos : 0 < H_safe + y_safe)
    (cap_ge : ∀ t, H_min ≤ L.restTaken part t c + L.capacity part cap t c)
    {f : F} (needs : 0 < m) (depends : ∀ t, W.requires t f c)
    (need : ∀ t, W.need t f c = m) (start : m ≤ W.level 0 c)
    (n : Nat) (within : W.level 0 c < (H_safe + y_safe) + (H_min - Y) * n) :
    (∀ t, W.level (t + 1) c =
      RegimeMargin.step g (L.restTaken part t c + L.capacity part cap t c) (W.level t c)) ∧
    W.Lost c ∧
    ∃ T, T ≤ n ∧ W.level T c < H_safe + y_safe ∧
      (∀ k, (StockFlowBridge.unitWeb (fun t => W.level t c)).level (T + k) () < H_safe + y_safe) ∧
      (∃ M, W.level M c = 0 ∧ ∀ j, W.level (M + j) c = 0) := by
  let draw := fun t => L.restTaken part t c + L.capacity part cap t c
  let x := fun t => W.level t c
  have rawStep : ∀ t, x (t + 1) = x t + L.restGiven part t c - draw t :=
    fun t => Optimum.course_beyond distinct cdistinct apart inside rising course mem t
  have step_eq : ∀ t, x (t + 1) = RegimeMargin.step g (draw t) (x t) := fun t =>
    (rawStep t).trans ((congrArg (fun r => x t + r - draw t) (renews_eq t)).trans
      (flow_step_eq_regime nothing (x t) (draw t)))
  have lost : W.Lost c :=
    Becoming.Web.lost_over rawStep
      (fun t => Nat.le_trans (Nat.le_of_eq (renews_eq t)) (most _))
      (fun t => Nat.lt_of_lt_of_le over (cap_ge t))
      needs depends need start
  obtain ⟨T, hTn, hTlt⟩ :=
    falls_within_ge step_eq most nothing (Nat.le_of_lt over) cap_ge hPos n within
  obtain ⟨hStay, M, hMzero, hMstay⟩ :=
    short_stays_below_ge step_eq short nothing (fun t _ => Nat.le_trans hSafeLe (cap_ge t)) hTlt
  exact ⟨step_eq, lost, T, hTn, hTlt, hStay, M, hMzero, hMstay⟩

/-- Single-step balanced slack exceedance via `Becoming.Flow.Balances.breaks_beyond`. -/
theorem flow_step_breaks_beyond
    {F C : Type} {L : Flow F C} {W : Web F C} {ds rest : List C} {t : Nat} {dep : C → F}
    (balances : L.Balances W)
    (gainless : L.GainlessOn (ds ++ rest) t)
    (met : W.MetOn dep rest t)
    (exceeds : W.stock ds t + W.slack dep rest t < W.stock ds (t + 1) + L.lost (ds ++ rest) t) :
    ∃ c, c ∈ rest ∧ W.Broken t (dep c) c :=
  balances.breaks_beyond gainless met exceeds

/-! ### 2.2 Track A2 — Policy-Bundle Derivation from Room / Asymmetric Marginal Yield -/

/-- **Marginal-yield room lemma**: where higher draw raises visible output on `ds` and an
overdrawing policy is eligible, every lower-draw eligible policy has a strictly dominating
eligible policy on `ds`. -/
theorem roomBelow_of_marginal_yield
    {P C : Type} (ds : List C) (out : P → C → Nat) (draw : P → Nat)
    (eligible : P → Prop) {H_min : Nat}
    (marginalYield : ∀ p₁ p₂, draw p₁ < draw p₂ → Optimum.Exceeds ds (out p₂) (out p₁))
    (attainable : ∃ p_hi, eligible p_hi ∧ H_min ≤ draw p_hi) :
    ∀ p, eligible p → draw p < H_min → ∃ p', eligible p' ∧ Optimum.Exceeds ds (out p') (out p) := by
  intro p _ below
  obtain ⟨p_hi, eligHi, hiGe⟩ := attainable
  exact ⟨p_hi, eligHi, marginalYield p p_hi (Nat.lt_of_lt_of_le below hiGe)⟩

/-- **Derived endogenous overdraw**: for ANY `Optimum.Rising` order over visible `ds` and ANY
`roomBelow` witness, every `Requirement.Frontier` optimum must draw at least `H_min`. -/
theorem optimum_forces_overdraw
    {P C : Type} (ds : List C) (out : P → C → Nat) (draw : P → Nat)
    (eligible : P → Prop) (better : (C → Nat) → (C → Nat) → Prop) {H_min : Nat}
    (rising : Optimum.Rising ds better)
    (roomBelow : ∀ p, eligible p → draw p < H_min →
      ∃ p', eligible p' ∧ Optimum.Exceeds ds (out p') (out p))
    {p_star : P} (opt : Requirement.Frontier eligible (fun a b => better (out a) (out b)) p_star) :
    H_min ≤ draw p_star :=
  match Nat.lt_or_ge (draw p_star) H_min with
  | .inl lt => by
    obtain ⟨p', elig', exc⟩ := roomBelow p_star opt.1 lt
    exact absurd (rising _ _ exc) (opt.2 p' elig')
  | .inr ge => ge

/-- **Hook 1 (`proxy_optimum_overdraw_collapse`)**: Part A Master Theorem.
Under `Optimum.Rising ds better` and `roomBelow` at every step, `Requirement.Frontier` optimality
derives endogenous overdraw `∀ t, H_min ≤ draw (pol t)` (without any `draw_rises` axiom),
producing finite-horizon break below `H_safe + y_safe`, permanent trapping via
`StockFlowBridge.unitNeverReturnsBelowWithin`, and collapse to `0`. -/
theorem proxy_optimum_overdraw_collapse
    {P C : Type}
    (ds : List C) (out : P → C → Nat) (draw : P → Nat)
    (eligible : P → Prop) (better : (C → Nat) → (C → Nat) → Prop)
    (g : Nat → Nat) {Y H_min H_safe y_safe : Nat}
    (rising : Optimum.Rising ds better)
    (roomBelow : ∀ p, eligible p → draw p < H_min →
      ∃ p', eligible p' ∧ Optimum.Exceeds ds (out p') (out p))
    (most : RegimeMargin.AtMost g Y) (over : Y < H_min)
    (short : RegimeMargin.Short g H_safe y_safe) (hSafeLe : H_safe ≤ H_min)
    (nothing : RegimeMargin.FromNothing g) (hPos : 0 < H_safe + y_safe)
    (pol : Nat → P)
    (opts : ∀ t, Requirement.Frontier eligible (fun a b => better (out a) (out b)) (pol t))
    {x : Nat → Nat}
    (step_eq : ∀ t, x (t + 1) = RegimeMargin.step g (draw (pol t)) (x t))
    (n : Nat) (within : x 0 < (H_safe + y_safe) + (H_min - Y) * n) :
    (∀ t, H_min ≤ draw (pol t)) ∧
    ∃ T, T ≤ n ∧ x T < H_safe + y_safe ∧
      (∀ k, (StockFlowBridge.unitWeb x).level (T + k) () < H_safe + y_safe) ∧
      (∃ M, x M = 0 ∧ ∀ j, x (M + j) = 0) := by
  have overdraw : ∀ t, H_min ≤ draw (pol t) := fun t =>
    optimum_forces_overdraw ds out draw eligible better rising roomBelow (opts t)
  obtain ⟨T, hTn, hTlt⟩ :=
    falls_within_ge step_eq most nothing (Nat.le_of_lt over) overdraw hPos n within
  obtain ⟨hStay, M, hMzero, hMstay⟩ :=
    short_stays_below_ge step_eq short nothing (fun t _ => Nat.le_trans hSafeLe (overdraw t)) hTlt
  exact ⟨overdraw, T, hTn, hTlt, hStay, M, hMzero, hMstay⟩

/-- **Contrast Theorem (`constrained_selector_viable`)**: restricting eligibility to `draw p ≤ H_safe`
holds the substrate inside `[H_safe + y_safe, hi]` forever whenever `Meets`, `Keeps`, and
`(H_safe + y_safe) + H_safe ≤ hi`. -/
theorem constrained_selector_viable
    {P : Type} (draw : P → Nat) (eligible : P → Prop)
    (g : Nat → Nat) {H_safe y_safe hi : Nat}
    (meets : RegimeMargin.Meets g H_safe y_safe hi)
    (keeps : RegimeMargin.Keeps g 0 hi)
    (band_room : (H_safe + y_safe) + H_safe ≤ hi)
    (pol : Nat → P)
    (constrained : ∀ t, eligible (pol t) ∧ draw (pol t) ≤ H_safe)
    {x : Nat → Nat}
    (step_eq : ∀ t, x (t + 1) = RegimeMargin.step g (draw (pol t)) (x t))
    (start_low : H_safe + y_safe ≤ x 0) (start_high : x 0 ≤ hi) :
    ∀ t, H_safe + y_safe ≤ x t ∧ x t ≤ hi := by
  intro t
  induction t with
  | zero => exact ⟨start_low, start_high⟩
  | succ t ih =>
    rw [step_eq t]
    exact safe_regime_step_viable meets keeps band_room ih.1 ih.2 (constrained t).2

/-! ### 2.3 Concrete Worked Witness (`PartAWitness`, >3 steps) -/

namespace PartAWitness

inductive Policy where
  | rest
  | safe
  | push
  | extract

def draw : Policy → Nat
  | .rest => 0
  | .safe => 4
  | .push => 5
  | .extract => 6

def out (p : Policy) : Bool → Nat
  | true => 10 + 2 * draw p
  | false => 0

/-- Capped renewal law (`Keeps 0 50` genuinely holds at carrying capacity `50`). -/
def wGivingCap (z : Nat) : Nat :=
  if 5 ≤ z then (if z ≤ 46 then 4 else 0) else 0

theorem wGivingCap_fromNothing : RegimeMargin.FromNothing wGivingCap := rfl

theorem wGivingCap_atMost : RegimeMargin.AtMost wGivingCap 4 := fun z =>
  match Nat.decLe 5 z with
  | isTrue h5 =>
    match Nat.decLe z 46 with
    | isTrue h46 => Nat.le_of_eq ((if_pos h5).trans (if_pos h46))
    | isFalse nh46 => Nat.le_trans (Nat.le_of_eq ((if_pos h5).trans (if_neg nh46))) (Nat.zero_le 4)
  | isFalse nh5 => Nat.le_trans (Nat.le_of_eq (if_neg nh5)) (Nat.zero_le 4)

theorem wGivingCap_short : RegimeMargin.Short wGivingCap 4 5 := fun z hz => by
  have nh5 : ¬ 5 ≤ z := Nat.not_le_of_gt hz
  rw [wGivingCap, if_neg nh5]
  exact by decide

theorem wGivingCap_meets : RegimeMargin.Meets wGivingCap 4 5 50 := fun z h5 htop => by
  have h46 : z ≤ 46 := Naturals.le_sub_of_add_le (Nat.add_comm z 4 ▸ htop)
  rw [wGivingCap, if_pos h5, if_pos h46]
  exact Nat.le_refl 4

theorem wGivingCap_keeps : RegimeMargin.Keeps wGivingCap 0 50 := fun x hx => by
  show x - 0 + wGivingCap (x - 0) ≤ 50
  rw [Nat.sub_zero]
  cases Nat.decLe 5 x with
  | isFalse nh5 =>
    rw [wGivingCap, if_neg nh5, Nat.add_zero]
    exact hx
  | isTrue h5 =>
    cases Nat.decLe x 46 with
    | isTrue h46 =>
      rw [wGivingCap, if_pos h5, if_pos h46]
      exact Nat.add_le_add_right h46 4
    | isFalse nh46 =>
      rw [wGivingCap, if_pos h5, if_neg nh46, Nat.add_zero]
      exact hx

def unconstOrbit : Nat → Nat :=
  Law.orbit (RegimeMargin.step wGivingCap (draw .extract)) 18

def constOrbit : Nat → Nat :=
  Law.orbit (RegimeMargin.step wGivingCap (draw .safe)) 18

theorem extract_frontier :
    Requirement.Frontier (fun _ : Policy => True)
      (fun a b => total [true] (out b) < total [true] (out a)) .extract :=
  ⟨trivial, fun b _ => by cases b <;> exact by decide⟩

theorem marginal_yield :
    ∀ p₁ p₂ : Policy, draw p₁ < draw p₂ → Optimum.Exceeds [true] (out p₂) (out p₁) :=
  fun p₁ p₂ lt =>
    ⟨fun c mem => by
      cases ListTests.mem_singleton_iff.mp mem
      show 10 + 2 * draw p₁ ≤ 10 + 2 * draw p₂
      exact Nat.add_le_add_left (Nat.mul_le_mul_left 2 (Nat.le_of_lt lt)) 10,
     true, .head [], Nat.add_lt_add_left (Naturals.mul_lt_mul_of_pos (by decide) lt) 10⟩

theorem unconstrained_collapses :
    unconstOrbit 0 = 18 ∧ unconstOrbit 1 = 16 ∧ unconstOrbit 2 = 14 ∧
    unconstOrbit 3 = 12 ∧ unconstOrbit 4 = 10 ∧ unconstOrbit 5 = 4 ∧
    unconstOrbit 6 = 0 ∧
    ∃ T, T ≤ 5 ∧ unconstOrbit T < 9 ∧
      (∀ k, (StockFlowBridge.unitWeb unconstOrbit).level (T + k) () < 9) ∧
      (∃ M, unconstOrbit M = 0 ∧ ∀ j, unconstOrbit (M + j) = 0) := by
  have col := proxy_optimum_overdraw_collapse
    [true] out draw (fun _ => True) (fun o' o => total [true] o < total [true] o')
    wGivingCap (Y := 4) (H_min := 6) (H_safe := 4) (y_safe := 5)
    (Optimum.rising_total [true])
    (roomBelow_of_marginal_yield [true] out draw (fun _ => True) marginal_yield
      ⟨.extract, trivial, Nat.le_refl 6⟩)
    wGivingCap_atMost (by decide) wGivingCap_short (by decide) wGivingCap_fromNothing (by decide)
    (fun _ => .extract) (fun _ => extract_frontier)
    (x := unconstOrbit) (fun _ => rfl) 5 (by decide)
  exact ⟨rfl, rfl, rfl, rfl, rfl, rfl, rfl, col.2⟩

theorem constrained_survives :
    (∀ t, constOrbit t = 18) ∧ (∀ t, 9 ≤ constOrbit t ∧ constOrbit t ≤ 50) := by
  have keep18 : ∀ t, constOrbit t = 18 := fun t => by
    induction t with
    | zero => rfl
    | succ t ih => show RegimeMargin.step wGivingCap 4 (constOrbit t) = 18; rw [ih]; rfl
  have viable := constrained_selector_viable draw (fun p => draw p ≤ 4) wGivingCap
    wGivingCap_meets wGivingCap_keeps (by decide) (fun _ => .safe)
    (fun _ => ⟨Nat.le_refl 4, Nat.le_refl 4⟩) (x := constOrbit) (fun _ => rfl) (by decide) (by decide)
  exact ⟨keep18, viable⟩

end PartAWitness

/-! ## 3. Part B.1 — Non-Oracle Coupled Task Bottleneck (`ServiceTaskModel`) -/

/-- Physical task bottleneck model: derives its crossover `B_task` purely from saturating
throughput `gain * min (demand p) x` and operating upkeep `upkeep p` (zero stored threshold). -/
structure ServiceTaskModel (P : Type) where
  gain : Nat
  gain_pos : 0 < gain
  demand : P → Nat
  upkeep : P → Nat
  draw : P → Nat
  safe : P
  ext : P
  demand_lt : demand safe < demand ext
  upkeep_lt : upkeep safe < upkeep ext
  /-- At full capacity (`demand ext ≤ x`), `ext`'s extra throughput strictly covers its extra upkeep. -/
  ext_viable_at_full : upkeep ext - upkeep safe < gain * (demand ext - demand safe)

namespace ServiceTaskModel

/-- Derived threshold level where `ext` stops outperforming `safe` (never stored as a field). -/
def B_task {P : Type} (M : ServiceTaskModel P) : Nat :=
  M.demand M.safe + ((M.upkeep M.ext - M.upkeep M.safe) + M.gain - 1) / M.gain

/-- Un-truncated task preference: `p'` strictly beats `p` at stock `x`. -/
def TaskPrefers {P : Type} (M : ServiceTaskModel P) (x : Nat) (p' p : P) : Prop :=
  M.gain * CoreHelpers.natMin (M.demand p) x + M.upkeep p' < M.gain * CoreHelpers.natMin (M.demand p') x + M.upkeep p

/-- Scalar realized output with baseline `base` avoiding `Nat` subtraction underflow when
`M.upkeep M.ext ≤ base`. -/
def realizedScore {P : Type} (M : ServiceTaskModel P) (p : P) (x base : Nat) : Nat :=
  M.gain * CoreHelpers.natMin (M.demand p) x + base - M.upkeep p

/-- Nominal baseline score achieved by `safe` at its full demand. -/
def nominalSafe {P : Type} (M : ServiceTaskModel P) (base : Nat) : Nat :=
  M.realizedScore M.safe (M.demand M.safe) base

theorem demand_safe_le_B_task {P : Type} (M : ServiceTaskModel P) :
    M.demand M.safe ≤ M.B_task :=
  Nat.le_add_right _ _

theorem B_task_pos_of_upkeep_lt {P : Type} (M : ServiceTaskModel P) :
    M.demand M.safe < M.B_task := by
  have deltaPos : 0 < M.upkeep M.ext - M.upkeep M.safe :=
    Naturals.le_sub_of_add_le M.upkeep_lt
  have qPos : 0 < ((M.upkeep M.ext - M.upkeep M.safe) + M.gain - 1) / M.gain :=
    (CoreHelpers.lt_ceil_div_iff M.gain_pos 0 (M.upkeep M.ext - M.upkeep M.safe)).mp
      (by rw [Nat.zero_mul]; exact deltaPos)
  exact Nat.lt_of_lt_of_le (Nat.lt_add_of_pos_right qPos) (Nat.le_refl _)

theorem B_task_le_demand_ext {P : Type} (M : ServiceTaskModel P) :
    M.B_task ≤ M.demand M.ext := by
  let diff := M.demand M.ext - M.demand M.safe
  let delta := M.upkeep M.ext - M.upkeep M.safe
  have notLt : ¬ diff < (delta + M.gain - 1) / M.gain := fun lt => by
    have mulLt : diff * M.gain < delta := (CoreHelpers.lt_ceil_div_iff M.gain_pos diff delta).mpr lt
    rw [Nat.mul_comm] at mulLt
    exact Nat.not_lt_of_gt M.ext_viable_at_full mulLt
  have qLe : (delta + M.gain - 1) / M.gain ≤ diff := Nat.ge_of_not_lt notLt
  calc M.B_task = M.demand M.safe + (delta + M.gain - 1) / M.gain := rfl
    _ ≤ M.demand M.safe + diff := Nat.add_le_add_left qLe _
    _ = M.demand M.ext := add_sub_of_le (Nat.le_of_lt M.demand_lt)

theorem realizedScore_lt_iff {P : Type} (M : ServiceTaskModel P) (p₁ p₂ : P) (x₁ x₂ base : Nat)
    (h1 : M.upkeep p₁ ≤ base) (h2 : M.upkeep p₂ ≤ base) :
    M.realizedScore p₁ x₁ base < M.realizedScore p₂ x₂ base ↔
      M.gain * CoreHelpers.natMin (M.demand p₁) x₁ + M.upkeep p₂ <
        M.gain * CoreHelpers.natMin (M.demand p₂) x₂ + M.upkeep p₁ := by
  have sub1 : M.realizedScore p₁ x₁ base + (M.upkeep p₁ + M.upkeep p₂) =
      (M.gain * CoreHelpers.natMin (M.demand p₁) x₁ + M.upkeep p₂) + base := by
    have le1 : M.upkeep p₁ ≤ M.gain * CoreHelpers.natMin (M.demand p₁) x₁ + base :=
      Nat.le_trans h1 (Nat.le_add_left _ _)
    calc (M.gain * CoreHelpers.natMin (M.demand p₁) x₁ + base - M.upkeep p₁) + (M.upkeep p₁ + M.upkeep p₂)
        = ((M.gain * CoreHelpers.natMin (M.demand p₁) x₁ + base - M.upkeep p₁) + M.upkeep p₁) + M.upkeep p₂ :=
          (Nat.add_assoc _ _ _).symm
      _ = (M.gain * CoreHelpers.natMin (M.demand p₁) x₁ + base) + M.upkeep p₂ :=
          congrArg (· + M.upkeep p₂) (Naturals.sub_add_cancel le1)
      _ = M.gain * CoreHelpers.natMin (M.demand p₁) x₁ + (base + M.upkeep p₂) := Nat.add_assoc _ _ _
      _ = M.gain * CoreHelpers.natMin (M.demand p₁) x₁ + (M.upkeep p₂ + base) :=
          congrArg _ (Nat.add_comm _ _)
      _ = (M.gain * CoreHelpers.natMin (M.demand p₁) x₁ + M.upkeep p₂) + base := (Nat.add_assoc _ _ _).symm
  have sub2 : M.realizedScore p₂ x₂ base + (M.upkeep p₁ + M.upkeep p₂) =
      (M.gain * CoreHelpers.natMin (M.demand p₂) x₂ + M.upkeep p₁) + base := by
    have le2 : M.upkeep p₂ ≤ M.gain * CoreHelpers.natMin (M.demand p₂) x₂ + base :=
      Nat.le_trans h2 (Nat.le_add_left _ _)
    calc (M.gain * CoreHelpers.natMin (M.demand p₂) x₂ + base - M.upkeep p₂) + (M.upkeep p₁ + M.upkeep p₂)
        = (M.gain * CoreHelpers.natMin (M.demand p₂) x₂ + base - M.upkeep p₂) + (M.upkeep p₂ + M.upkeep p₁) :=
          congrArg _ (Nat.add_comm _ _)
      _ = ((M.gain * CoreHelpers.natMin (M.demand p₂) x₂ + base - M.upkeep p₂) + M.upkeep p₂) + M.upkeep p₁ :=
          (Nat.add_assoc _ _ _).symm
      _ = (M.gain * CoreHelpers.natMin (M.demand p₂) x₂ + base) + M.upkeep p₁ :=
          congrArg (· + M.upkeep p₁) (Naturals.sub_add_cancel le2)
      _ = M.gain * CoreHelpers.natMin (M.demand p₂) x₂ + (base + M.upkeep p₁) := Nat.add_assoc _ _ _
      _ = M.gain * CoreHelpers.natMin (M.demand p₂) x₂ + (M.upkeep p₁ + base) :=
          congrArg _ (Nat.add_comm _ _)
      _ = (M.gain * CoreHelpers.natMin (M.demand p₂) x₂ + M.upkeep p₁) + base := (Nat.add_assoc _ _ _).symm
  constructor
  · intro lt
    have lt' : base + (M.gain * CoreHelpers.natMin (M.demand p₁) x₁ + M.upkeep p₂) <
        base + (M.gain * CoreHelpers.natMin (M.demand p₂) x₂ + M.upkeep p₁) := by
      rw [Nat.add_comm base _, Nat.add_comm base _, ← sub1, ← sub2]
      exact Nat.add_lt_add_right lt (M.upkeep p₁ + M.upkeep p₂)
    exact Naturals.lt_of_add_lt_add_left lt'
  · intro lt
    have lt' : (M.upkeep p₁ + M.upkeep p₂) + M.realizedScore p₁ x₁ base <
        (M.upkeep p₁ + M.upkeep p₂) + M.realizedScore p₂ x₂ base := by
      rw [Nat.add_comm (M.upkeep p₁ + M.upkeep p₂) _,
        Nat.add_comm (M.upkeep p₁ + M.upkeep p₂) _, sub1, sub2]
      exact Nat.add_lt_add_right lt base
    exact Naturals.lt_of_add_lt_add_left lt'

/-- **Exact task-bottleneck crossover (`score_crosses_iff`)** across all `x : Nat`. -/
theorem score_crosses_iff {P : Type} (M : ServiceTaskModel P) (x base : Nat) :
    (M.TaskPrefers x M.safe M.ext ↔ x < M.B_task) ∧
    (M.upkeep M.ext ≤ base → (M.realizedScore M.ext x base < M.nominalSafe base ↔ x < M.B_task)) := by
  let dSafe := M.demand M.safe
  let dExt := M.demand M.ext
  let uSafe := M.upkeep M.safe
  let uExt := M.upkeep M.ext
  let delta := uExt - uSafe
  let q := (delta + M.gain - 1) / M.gain
  have uExtEq : uExt = uSafe + delta := (add_sub_of_le (Nat.le_of_lt M.upkeep_lt)).symm
  have prefIff : M.TaskPrefers x M.safe M.ext ↔ x < M.B_task := by
    cases Nat.le_total x dSafe with
    | inl leSafe =>
      have leExt : x ≤ dExt := Nat.le_trans leSafe (Nat.le_of_lt M.demand_lt)
      have pref : M.TaskPrefers x M.safe M.ext := by
        show M.gain * CoreHelpers.natMin dExt x + uSafe < M.gain * CoreHelpers.natMin dSafe x + uExt
        rw [CoreHelpers.natMin_eq_right leExt, CoreHelpers.natMin_eq_right leSafe]
        exact Nat.add_lt_add_left M.upkeep_lt _
      have ltB : x < M.B_task := Nat.lt_of_le_of_lt leSafe M.B_task_pos_of_upkeep_lt
      exact ⟨fun _ => ltB, fun _ => pref⟩
    | inr geSafe =>
      have mSafe : CoreHelpers.natMin dSafe x = dSafe := CoreHelpers.natMin_eq_left geSafe
      have ltB_iff : x < M.B_task ↔ x - dSafe < q := by
        have eqX : x = dSafe + (x - dSafe) := (add_sub_of_le geSafe).symm
        constructor
        · intro lt
          have lt' : dSafe + (x - dSafe) < dSafe + q := eqX ▸ lt
          exact Naturals.lt_of_add_lt_add_left lt'
        · intro lt
          have lt' : dSafe + (x - dSafe) < dSafe + q := Nat.add_lt_add_left lt dSafe
          exact eqX.symm ▸ lt'
      have pref_iff : M.TaskPrefers x M.safe M.ext ↔ CoreHelpers.natMin dExt x - dSafe < q := by
        have dSafeLeMin : dSafe ≤ CoreHelpers.natMin dExt x :=
          CoreHelpers.le_natMin (Nat.le_of_lt M.demand_lt) geSafe
        let k := CoreHelpers.natMin dExt x - dSafe
        have minEq : CoreHelpers.natMin dExt x = dSafe + k := (add_sub_of_le dSafeLeMin).symm
        have mulEq : M.gain * CoreHelpers.natMin dExt x = M.gain * dSafe + M.gain * k := by
          rw [minEq, Nat.mul_add]
        have lhsIff : M.gain * CoreHelpers.natMin dExt x + uSafe < M.gain * dSafe + uExt ↔
            M.gain * k < delta := by
          rw [mulEq, uExtEq, Nat.add_assoc]
          exact Naturals.add_lt_add_left_iff.trans (by
            rw [Nat.add_comm (M.gain * k) uSafe]
            exact Naturals.add_lt_add_left_iff)
        show M.gain * CoreHelpers.natMin dExt x + uSafe < M.gain * CoreHelpers.natMin dSafe x + uExt ↔ k < q
        rw [mSafe]
        exact lhsIff.trans (by
          rw [Nat.mul_comm M.gain k]
          exact CoreHelpers.lt_ceil_div_iff M.gain_pos k delta)
      have minSubIff : CoreHelpers.natMin dExt x - dSafe < q ↔ x - dSafe < q := by
        cases Nat.le_total x dExt with
        | inl leExt => rw [CoreHelpers.natMin_eq_right leExt]
        | inr geExt =>
          rw [CoreHelpers.natMin_eq_left geExt]
          have qLeDiff : q ≤ dExt - dSafe :=
            Naturals.le_of_add_le_add_left (k := dSafe)
              (Nat.le_trans M.B_task_le_demand_ext (Nat.le_of_eq (add_sub_of_le (Nat.le_of_lt M.demand_lt)).symm))
          have diffLeSub : dExt - dSafe ≤ x - dSafe := by
            have h1 : dSafe + (dExt - dSafe) = dExt := add_sub_of_le (Nat.le_of_lt M.demand_lt)
            exact Naturals.le_sub_of_add_le (h1.symm ▸ geExt)
          exact ⟨fun lt => absurd (Nat.lt_of_le_of_lt qLeDiff lt) (Nat.lt_irrefl _),
            fun lt => absurd (Nat.lt_of_le_of_lt (Nat.le_trans qLeDiff diffLeSub) lt) (Nat.lt_irrefl _)⟩
      exact pref_iff.trans (minSubIff.trans ltB_iff.symm)
  refine ⟨prefIff, fun hBase => ?_⟩
  have hSafeBase : uSafe ≤ base := Nat.le_trans (Nat.le_of_lt M.upkeep_lt) hBase
  have scoreIff : M.realizedScore M.ext x base < M.realizedScore M.safe dSafe base ↔
      M.gain * CoreHelpers.natMin dExt x + uSafe < M.gain * CoreHelpers.natMin dSafe dSafe + uExt :=
    M.realizedScore_lt_iff M.ext M.safe x dSafe base hBase hSafeBase
  rw [CoreHelpers.natMin_eq_left (Nat.le_refl dSafe)] at scoreIff
  cases Nat.le_total dSafe x with
  | inl geSafe =>
    have mSafe : CoreHelpers.natMin dSafe x = dSafe := CoreHelpers.natMin_eq_left geSafe
    have scoreEq : M.realizedScore M.ext x base < M.nominalSafe base ↔ M.TaskPrefers x M.safe M.ext := by
      change M.realizedScore M.ext x base < M.realizedScore M.safe dSafe base ↔
        M.gain * CoreHelpers.natMin dExt x + uSafe < M.gain * CoreHelpers.natMin dSafe x + uExt
      rw [mSafe]
      exact scoreIff
    exact scoreEq.trans prefIff
  | inr leSafe =>
    have leExt : x ≤ dExt := Nat.le_trans leSafe (Nat.le_of_lt M.demand_lt)
    have ltB : x < M.B_task := Nat.lt_of_le_of_lt leSafe M.B_task_pos_of_upkeep_lt
    have ltScore : M.realizedScore M.ext x base < M.nominalSafe base := by
      change M.realizedScore M.ext x base < M.realizedScore M.safe dSafe base
      refine scoreIff.mpr ?_
      rw [CoreHelpers.natMin_eq_right leExt]
      exact Nat.add_lt_add_of_le_of_lt (Nat.mul_le_mul_left M.gain leSafe) M.upkeep_lt
    exact ⟨fun _ => ltB, fun _ => ltScore⟩

theorem safe_not_preferred_from_B_task {P : Type} (M : ServiceTaskModel P) {x : Nat}
    (ge : M.B_task ≤ x) : ¬ M.TaskPrefers x M.safe M.ext :=
  fun pref => Nat.not_le_of_gt ((M.score_crosses_iff x 0).1.mp pref) ge

theorem ext_preferred_above {P : Type} (M : ServiceTaskModel P) {x : Nat}
    (above : M.B_task < x) : M.TaskPrefers x M.ext M.safe := by
  let dSafe := M.demand M.safe
  let dExt := M.demand M.ext
  let uSafe := M.upkeep M.safe
  let uExt := M.upkeep M.ext
  let delta := uExt - uSafe
  let q := (delta + M.gain - 1) / M.gain
  have dSafeLt : dSafe < x := Nat.lt_of_le_of_lt M.demand_safe_le_B_task above
  have dSafeLe : dSafe ≤ x := Nat.le_of_lt dSafeLt
  have deltaLt : delta < M.gain * (CoreHelpers.natMin dExt x - dSafe) := by
    cases Nat.le_total x dExt with
    | inl leExt =>
      rw [CoreHelpers.natMin_eq_right leExt]
      let k := x - dSafe
      have hqLt : q < k := Naturals.lt_of_add_lt_add_left (k := dSafe)
        (Nat.lt_of_lt_of_le above (Nat.le_of_eq (add_sub_of_le dSafeLe).symm))
      have kPos : 0 < k := Nat.lt_of_le_of_lt (Nat.zero_le q) hqLt
      have notLt : ¬ (k - 1) < q := Nat.not_lt_of_ge (Naturals.le_sub_of_add_le
        (Nat.add_comm 1 q ▸ hqLt))
      have deltaLe : delta ≤ (k - 1) * M.gain :=
        Nat.ge_of_not_lt fun lt => notLt ((CoreHelpers.lt_ceil_div_iff M.gain_pos (k - 1) delta).mp lt)
      have stepLt : (k - 1) * M.gain < k * M.gain := by
        have hk : k = (k - 1) + 1 := (Naturals.sub_add_cancel kPos).symm
        calc (k - 1) * M.gain < (k - 1) * M.gain + M.gain := Nat.lt_add_of_pos_right M.gain_pos
          _ = ((k - 1) + 1) * M.gain := (Nat.succ_mul (k - 1) M.gain).symm
          _ = k * M.gain := congrArg (· * M.gain) hk.symm
      rw [Nat.mul_comm]
      exact Nat.lt_of_le_of_lt deltaLe stepLt
    | inr geExt =>
      rw [CoreHelpers.natMin_eq_left geExt]
      exact M.ext_viable_at_full
  have dSafeLeMin : dSafe ≤ CoreHelpers.natMin dExt x :=
    CoreHelpers.le_natMin (Nat.le_of_lt M.demand_lt) dSafeLe
  show M.gain * CoreHelpers.natMin dSafe x + uExt < M.gain * CoreHelpers.natMin dExt x + uSafe
  rw [CoreHelpers.natMin_eq_left dSafeLe,
    show CoreHelpers.natMin dExt x = dSafe + (CoreHelpers.natMin dExt x - dSafe) from
      (add_sub_of_le dSafeLeMin).symm, Nat.mul_add,
    show uExt = uSafe + delta from (add_sub_of_le (Nat.le_of_lt M.upkeep_lt)).symm]
  have lt1 : uSafe + delta < M.gain * (CoreHelpers.natMin dExt x - dSafe) + uSafe :=
    Nat.add_comm uSafe _ ▸ Nat.add_lt_add_left deltaLt uSafe
  calc M.gain * dSafe + (uSafe + delta) < M.gain * dSafe + (M.gain * (CoreHelpers.natMin dExt x - dSafe) + uSafe) :=
        Nat.add_lt_add_left lt1 _
    _ = (M.gain * dSafe + M.gain * (CoreHelpers.natMin dExt x - dSafe)) + uSafe := (Nat.add_assoc _ _ _).symm

theorem ext_preferred_from_B_task_of_mod_ne {P : Type} (M : ServiceTaskModel P) {x : Nat}
    (rem : (M.upkeep M.ext - M.upkeep M.safe) % M.gain ≠ 0) (ge : M.B_task ≤ x) :
    M.TaskPrefers x M.ext M.safe := by
  cases Nat.lt_or_ge M.B_task x with
  | inl above => exact M.ext_preferred_above above
  | inr leB =>
    have hx : x = M.B_task := Nat.le_antisymm leB ge
    subst hx
    let dSafe := M.demand M.safe
    let dExt := M.demand M.ext
    let uSafe := M.upkeep M.safe
    let uExt := M.upkeep M.ext
    let delta := uExt - uSafe
    let q := (delta + M.gain - 1) / M.gain
    have hDecomp := CoreHelpers.div_mod_decomp M.gain_pos delta
    have remPos : 0 < delta % M.gain := match hr : delta % M.gain with
      | 0 => absurd hr rem
      | _ + 1 => Nat.succ_pos _
    obtain ⟨r, hr⟩ := exists_add_of_le remPos
    have hr' : delta % M.gain = r + 1 := hr
    have hModLt : r + 1 < M.gain := hr' ▸ hDecomp.2
    have rLt : r < M.gain := Nat.lt_trans (Nat.lt_succ_self r) hModLt
    have qEq : q = delta / M.gain + 1 := by
      have hdelta : delta = (delta / M.gain) * M.gain + (r + 1) := hDecomp.1.trans (congrArg _ hr')
      have eqNum : delta + M.gain - 1 = (delta / M.gain + 1) * M.gain + r := by
        have s0 : delta + M.gain - 1 = ((delta / M.gain) * M.gain + (r + 1)) + M.gain - 1 :=
          congrArg (fun z => z + M.gain - 1) hdelta
        have s1 : (delta / M.gain) * M.gain + (r + 1) + M.gain =
            ((delta / M.gain) * M.gain + M.gain + r) + 1 := by
          calc (delta / M.gain) * M.gain + (r + 1) + M.gain
              = ((delta / M.gain) * M.gain + r) + 1 + M.gain := by
                  rw [Nat.add_assoc ((delta / M.gain) * M.gain) r 1]
            _ = ((delta / M.gain) * M.gain + r) + (1 + M.gain) := Nat.add_assoc _ _ _
            _ = ((delta / M.gain) * M.gain + r) + (M.gain + 1) :=
                congrArg (_ + ·) (Nat.add_comm 1 M.gain)
            _ = ((delta / M.gain) * M.gain + r + M.gain) + 1 := (Nat.add_assoc _ _ _).symm
            _ = ((delta / M.gain) * M.gain + M.gain + r) + 1 :=
                congrArg (· + 1) (Nat.add_right_comm ((delta / M.gain) * M.gain) r M.gain)
        calc delta + M.gain - 1 = ((delta / M.gain) * M.gain + (r + 1)) + M.gain - 1 := s0
          _ = (((delta / M.gain) * M.gain + M.gain + r) + 1) - 1 := congrArg (· - 1) s1
          _ = (delta / M.gain) * M.gain + M.gain + r := Naturals.add_sub_cancel _ 1
          _ = (delta / M.gain + 1) * M.gain + r :=
              congrArg (· + r) (Nat.succ_mul (delta / M.gain) M.gain).symm
      show (delta + M.gain - 1) / M.gain = delta / M.gain + 1
      rw [eqNum]
      exact CoreHelpers.div_mul_add_rem M.gain_pos rLt (delta / M.gain + 1)
    have deltaLt : delta < M.gain * q := by
      calc delta = (delta / M.gain) * M.gain + delta % M.gain := hDecomp.1
        _ < (delta / M.gain) * M.gain + M.gain := Nat.add_lt_add_left hDecomp.2 _
        _ = (delta / M.gain + 1) * M.gain := (Nat.succ_mul (delta / M.gain) M.gain).symm
        _ = q * M.gain := congrArg (· * M.gain) qEq.symm
        _ = M.gain * q := Nat.mul_comm _ _
    have hSafeLe : dSafe ≤ M.B_task := M.demand_safe_le_B_task
    have hExtGe : M.B_task ≤ dExt := M.B_task_le_demand_ext
    show M.gain * CoreHelpers.natMin dSafe M.B_task + uExt < M.gain * CoreHelpers.natMin dExt M.B_task + uSafe
    rw [CoreHelpers.natMin_eq_left hSafeLe, CoreHelpers.natMin_eq_right hExtGe,
      show M.B_task = dSafe + q from rfl, Nat.mul_add,
      show uExt = uSafe + delta from (add_sub_of_le (Nat.le_of_lt M.upkeep_lt)).symm]
    have lt1 : uSafe + delta < M.gain * q + uSafe :=
      Nat.add_comm uSafe _ ▸ Nat.add_lt_add_left deltaLt uSafe
    calc M.gain * dSafe + (uSafe + delta) < M.gain * dSafe + (M.gain * q + uSafe) :=
          Nat.add_lt_add_left lt1 _
      _ = (M.gain * dSafe + M.gain * q) + uSafe := (Nat.add_assoc _ _ _).symm

end ServiceTaskModel

/-! ## 4. Part B.2 — Timely Endogenous Turning -/

/-! ### 4.1 Standalone Closed-Loop Formulation (`EndogenousSystem`) -/

/-- A closed-loop system coupling an agent state `S` and observation `Obs` with substrate law `g`. -/
structure EndogenousSystem (S Obs : Type) where
  next : S → Obs → S
  obs : S → Nat → Obs
  draw : S → Nat
  g : Nat → Nat

namespace EndogenousSystem

def step {S Obs : Type} (sys : EndogenousSystem S Obs) (st : Nat × S) : Nat × S :=
  (RegimeMargin.step sys.g (sys.draw st.2) st.1, sys.next st.2 (sys.obs st.2 st.1))

end EndogenousSystem

/-- Viability invariant for `EndogenousSystem`: `K s`, `x ≤ hi`, and margin
`(H_safe + y_safe) + eta s * drawCeiling ≤ x`. -/
def turningInv {S : Type} (K : S → Prop) (eta : S → Nat)
    (H_safe y_safe drawCeiling hi : Nat) (st : Nat × S) : Prop :=
  K st.2 ∧ st.1 ≤ hi ∧ (H_safe + y_safe) + eta st.2 * drawCeiling ≤ st.1

namespace EndogenousSystem

theorem timely_turning_certificate
    {S Obs : Type} (sys : EndogenousSystem S Obs)
    (K : S → Prop) (eta : S → Nat) (taskDegrades : Obs → Prop)
    {B_task H_safe y_safe drawCeiling lag hi : Nat}
    (k_closed : ∀ s o, K s → K (sys.next s o))
    (eta_le : ∀ s, K s → eta s ≤ lag)
    (draw_le : ∀ s, K s → sys.draw s ≤ drawCeiling)
    (draw_safe : ∀ s, K s → eta s = 0 → sys.draw s ≤ H_safe)
    (registers : ∀ s x, K s → x < B_task → taskDegrades (sys.obs s x))
    (degrade_dec : ∀ s o, K s → taskDegrades o → 0 < eta s → eta (sys.next s o) < eta s)
    (degrade_zero : ∀ s o, K s → taskDegrades o → eta s = 0 → eta (sys.next s o) = 0)
    (meets : RegimeMargin.Meets sys.g H_safe y_safe hi)
    (keeps : RegimeMargin.Keeps sys.g 0 hi)
    (band_room : (H_safe + y_safe) + H_safe ≤ hi)
    (clearing : (H_safe + y_safe) + drawCeiling * (lag + 1) ≤ B_task) :
    Viability.Certificate (Law.process sys.step)
      (fun st => H_safe + y_safe ≤ st.1 ∧ st.1 ≤ hi ∧ K st.2)
      (turningInv K eta H_safe y_safe drawCeiling hi) := by
  refine ⟨fun st ⟨hK, hHi, hMargin⟩ => ⟨Nat.le_trans (Nat.le_add_right _ _) hMargin, hHi, hK⟩,
    fun st _ st' hStep ⟨hK, hHi, hMargin⟩ => ?_⟩
  subst hStep
  obtain ⟨x, s⟩ := st
  let x' := RegimeMargin.step sys.g (sys.draw s) x
  let s' := sys.next s (sys.obs s x)
  have hK' : K s' := k_closed s (sys.obs s x) hK
  have hHi' : x' ≤ hi := by
    have subHi : x - sys.draw s ≤ hi := Nat.le_trans (Nat.sub_le x (sys.draw s)) hHi
    have k := keeps (x - sys.draw s) subHi
    rw [RegimeMargin.step, Nat.sub_zero] at k
    exact k
  have hMargin' : (H_safe + y_safe) + eta s' * drawCeiling ≤ x' := by
    cases Nat.lt_or_ge x B_task with
    | inr aboveB =>
      have etaLag : eta s' + 1 ≤ lag + 1 := Nat.succ_le_succ (eta_le s' hK')
      have mulLe : eta s' * drawCeiling + drawCeiling ≤ drawCeiling * (lag + 1) := by
        calc eta s' * drawCeiling + drawCeiling = (eta s' + 1) * drawCeiling :=
              (Nat.succ_mul (eta s') drawCeiling).symm
          _ ≤ (lag + 1) * drawCeiling := Nat.mul_le_mul_right drawCeiling etaLag
          _ = drawCeiling * (lag + 1) := Nat.mul_comm _ _
      have enough : (H_safe + y_safe) + eta s' * drawCeiling + sys.draw s ≤ x := by
        calc (H_safe + y_safe) + eta s' * drawCeiling + sys.draw s
            ≤ (H_safe + y_safe) + eta s' * drawCeiling + drawCeiling :=
              Nat.add_le_add_left (draw_le s hK) _
          _ = (H_safe + y_safe) + (eta s' * drawCeiling + drawCeiling) := Nat.add_assoc _ _ _
          _ ≤ (H_safe + y_safe) + drawCeiling * (lag + 1) := Nat.add_le_add_left mulLe _
          _ ≤ B_task := clearing
          _ ≤ x := aboveB
      have subPre : (H_safe + y_safe) + eta s' * drawCeiling ≤ x - sys.draw s :=
        Naturals.le_sub_of_add_le (Nat.add_comm _ _ ▸ enough)
      exact Nat.le_trans subPre (Nat.le_add_right _ _)
    | inl belowB =>
      have deg : taskDegrades (sys.obs s x) := registers s x hK belowB
      cases hEta : eta s with
      | zero =>
        have etaZero' : eta s' = 0 := degrade_zero s (sys.obs s x) hK deg hEta
        have safeStep := safe_regime_step_viable meets keeps band_room
          (Nat.le_trans (Nat.le_add_right _ _) hMargin) hHi (draw_safe s hK hEta)
        show (H_safe + y_safe) + eta s' * drawCeiling ≤ x'
        rw [etaZero', Nat.zero_mul, Nat.add_zero]
        exact safeStep.1
      | succ ePred =>
        have etaLt : eta s' < eta s := degrade_dec s (sys.obs s x) hK deg (hEta ▸ Nat.succ_pos ePred)
        have etaStep : eta s' + 1 ≤ eta s := etaLt
        have mulLe : eta s' * drawCeiling + drawCeiling ≤ eta s * drawCeiling := by
          calc eta s' * drawCeiling + drawCeiling = (eta s' + 1) * drawCeiling :=
                (Nat.succ_mul (eta s') drawCeiling).symm
            _ ≤ eta s * drawCeiling := Nat.mul_le_mul_right drawCeiling etaStep
        have enough : (H_safe + y_safe) + eta s' * drawCeiling + sys.draw s ≤ x := by
          calc (H_safe + y_safe) + eta s' * drawCeiling + sys.draw s
              ≤ (H_safe + y_safe) + eta s' * drawCeiling + drawCeiling :=
                Nat.add_le_add_left (draw_le s hK) _
            _ = (H_safe + y_safe) + (eta s' * drawCeiling + drawCeiling) := Nat.add_assoc _ _ _
            _ ≤ (H_safe + y_safe) + eta s * drawCeiling := Nat.add_le_add_left mulLe _
            _ ≤ x := hMargin
        have subPre : (H_safe + y_safe) + eta s' * drawCeiling ≤ x - sys.draw s :=
          Naturals.le_sub_of_add_le (Nat.add_comm _ _ ▸ enough)
        exact Nat.le_trans subPre (Nat.le_add_right _ _)
  exact ⟨hK', hHi', hMargin'⟩

theorem timely_turning_kernel
    {S Obs : Type} (sys : EndogenousSystem S Obs)
    (K : S → Prop) (eta : S → Nat) (taskDegrades : Obs → Prop)
    {B_task H_safe y_safe drawCeiling lag hi : Nat}
    (init : S) (x₀ : Nat) (init_in : K init)
    (k_closed : ∀ s o, K s → K (sys.next s o))
    (eta_le : ∀ s, K s → eta s ≤ lag)
    (draw_le : ∀ s, K s → sys.draw s ≤ drawCeiling)
    (draw_safe : ∀ s, K s → eta s = 0 → sys.draw s ≤ H_safe)
    (registers : ∀ s x, K s → x < B_task → taskDegrades (sys.obs s x))
    (degrade_dec : ∀ s o, K s → taskDegrades o → 0 < eta s → eta (sys.next s o) < eta s)
    (degrade_zero : ∀ s o, K s → taskDegrades o → eta s = 0 → eta (sys.next s o) = 0)
    (meets : RegimeMargin.Meets sys.g H_safe y_safe hi)
    (keeps : RegimeMargin.Keeps sys.g 0 hi)
    (band_room : (H_safe + y_safe) + H_safe ≤ hi)
    (clearing : (H_safe + y_safe) + drawCeiling * (lag + 1) ≤ B_task)
    (init_margin : (H_safe + y_safe) + eta init * drawCeiling ≤ x₀)
    (init_top : x₀ ≤ hi) :
    Viability.Kernel (Law.process sys.step)
      (fun st => H_safe + y_safe ≤ st.1 ∧ st.1 ≤ hi ∧ K st.2) (x₀, init) ∧
    (∀ t, H_safe + y_safe ≤ (Law.orbit sys.step (x₀, init) t).1 ∧
          (Law.orbit sys.step (x₀, init) t).1 ≤ hi) := by
  have cert := sys.timely_turning_certificate K eta taskDegrades k_closed eta_le draw_le
    draw_safe registers degrade_dec degrade_zero meets keeps band_room clearing
  have kern : Viability.Kernel (Law.process sys.step)
      (fun st => H_safe + y_safe ≤ st.1 ∧ st.1 ≤ hi ∧ K st.2) (x₀, init) :=
    cert.kernel ⟨init_in, init_top, init_margin⟩
  have orbitBound : ∀ t, H_safe + y_safe ≤ (Law.orbit sys.step (x₀, init) t).1 ∧
      (Law.orbit sys.step (x₀, init) t).1 ≤ hi := fun t =>
    have reach := (Law.run sys.step (x₀, init)).reach 0 t
    have hGuard := kern _ (Nat.zero_add t ▸ reach)
    ⟨hGuard.1, hGuard.2.1⟩
  exact ⟨kern, orbitBound⟩

/-- Qualified Turn Guarantee: along the orbit, if `x` stays below `B_task` for `lag` steps from
`T₀`, then `eta` reaches `0` (hence `draw ≤ H_safe`) by `T₀ + lag` while staying in `[H_safe + y_safe, hi]`. -/
theorem timely_turning_guarantee
    {S Obs : Type} (sys : EndogenousSystem S Obs)
    (K : S → Prop) (eta : S → Nat) (taskDegrades : Obs → Prop)
    {B_task H_safe y_safe drawCeiling lag hi : Nat}
    (init : S) (x₀ : Nat) (init_in : K init)
    (k_closed : ∀ s o, K s → K (sys.next s o))
    (eta_le : ∀ s, K s → eta s ≤ lag)
    (draw_le : ∀ s, K s → sys.draw s ≤ drawCeiling)
    (draw_safe : ∀ s, K s → eta s = 0 → sys.draw s ≤ H_safe)
    (registers : ∀ s x, K s → x < B_task → taskDegrades (sys.obs s x))
    (degrade_dec : ∀ s o, K s → taskDegrades o → 0 < eta s → eta (sys.next s o) < eta s)
    (degrade_zero : ∀ s o, K s → taskDegrades o → eta s = 0 → eta (sys.next s o) = 0)
    (meets : RegimeMargin.Meets sys.g H_safe y_safe hi)
    (keeps : RegimeMargin.Keeps sys.g 0 hi)
    (band_room : (H_safe + y_safe) + H_safe ≤ hi)
    (clearing : (H_safe + y_safe) + drawCeiling * (lag + 1) ≤ B_task)
    (init_margin : (H_safe + y_safe) + eta init * drawCeiling ≤ x₀)
    (init_top : x₀ ≤ hi)
    (T₀ : Nat) :
    (∀ k, k < lag → (Law.orbit sys.step (x₀, init) (T₀ + k)).1 < B_task) →
    eta (Law.orbit sys.step (x₀, init) (T₀ + lag)).2 = 0 ∧
    sys.draw (Law.orbit sys.step (x₀, init) (T₀ + lag)).2 ≤ H_safe ∧
    H_safe + y_safe ≤ (Law.orbit sys.step (x₀, init) (T₀ + lag)).1 := by
  have kern := (sys.timely_turning_kernel K eta taskDegrades init x₀ init_in k_closed eta_le
    draw_le draw_safe registers degrade_dec degrade_zero meets keeps band_room clearing
    init_margin init_top).1
  have inK : ∀ t, K (Law.orbit sys.step (x₀, init) t).2 := fun t =>
    (kern _ (Nat.zero_add t ▸ (Law.run sys.step (x₀, init)).reach 0 t)).2.2
  have countdown : ∀ k, k ≤ lag →
      (∀ j, j < k → (Law.orbit sys.step (x₀, init) (T₀ + j)).1 < B_task) →
      eta (Law.orbit sys.step (x₀, init) (T₀ + k)).2 ≤ lag - k := fun k => by
    induction k with
    | zero =>
      intro _ _
      rw [Nat.sub_zero, Nat.add_zero]
      exact eta_le _ (inK T₀)
    | succ k ih =>
      intro hKle hBelow
      have ih' := ih (Nat.le_trans (Nat.le_succ k) hKle)
        (fun j hj => hBelow j (Nat.lt_succ_of_lt hj))
      let st := Law.orbit sys.step (x₀, init) (T₀ + k)
      have hkLt : st.1 < B_task := hBelow k (Nat.lt_succ_self k)
      have hDeg : taskDegrades (sys.obs st.2 st.1) := registers st.2 st.1 (inK (T₀ + k)) hkLt
      have nextEq : Law.orbit sys.step (x₀, init) (T₀ + (k + 1)) = sys.step st := rfl
      rw [nextEq]
      show eta (sys.next st.2 (sys.obs st.2 st.1)) ≤ lag - (k + 1)
      cases hEta : eta st.2 with
      | zero =>
        rw [degrade_zero st.2 (sys.obs st.2 st.1) (inK (T₀ + k)) hDeg hEta]
        exact Nat.zero_le _
      | succ ePred =>
        have hLt := degrade_dec st.2 (sys.obs st.2 st.1) (inK (T₀ + k)) hDeg
          (hEta ▸ Nat.succ_pos ePred)
        have hLe : eta (sys.next st.2 (sys.obs st.2 st.1)) + 1 ≤ lag - k :=
          Nat.le_trans hLt ih'
        have subEq : lag - k = (lag - (k + 1)) + 1 := by
          have subLe : 1 ≤ lag - k := Naturals.le_sub_of_add_le
            (Nat.add_comm k 1 ▸ hKle)
          calc lag - k = lag - k - 1 + 1 := (Naturals.sub_add_cancel subLe).symm
            _ = lag - (k + 1) + 1 := congrArg (· + 1) (Naturals.sub_sub lag k 1)
        rw [subEq] at hLe
        exact le_of_add_le_add_right 1 hLe
  intro allBelow
  have etaZero : eta (Law.orbit sys.step (x₀, init) (T₀ + lag)).2 = 0 :=
    Nat.eq_zero_of_le_zero ((Nat.le_trans (countdown lag (Nat.le_refl lag) allBelow)
      (Nat.le_of_eq (sub_eq_zero_of_le (Nat.le_refl lag)))))
  have hGuard := kern _ (Nat.zero_add (T₀ + lag) ▸
    (Law.run sys.step (x₀, init)).reach 0 (T₀ + lag))
  exact ⟨etaZero, draw_safe _ hGuard.2.2 etaZero, hGuard.1⟩

end EndogenousSystem

/-- **Hook 2 (`endogenous_turning_kernel`)**: Standalone endogenous turning viability kernel. -/
theorem endogenous_turning_kernel
    {S Obs : Type} (sys : EndogenousSystem S Obs)
    (K : S → Prop) (eta : S → Nat) (taskDegrades : Obs → Prop)
    {B_task H_safe y_safe drawCeiling lag hi : Nat}
    (init : S) (x₀ : Nat) (init_in : K init)
    (k_closed : ∀ s o, K s → K (sys.next s o))
    (eta_le : ∀ s, K s → eta s ≤ lag)
    (draw_le : ∀ s, K s → sys.draw s ≤ drawCeiling)
    (draw_safe : ∀ s, K s → eta s = 0 → sys.draw s ≤ H_safe)
    (registers : ∀ s x, K s → x < B_task → taskDegrades (sys.obs s x))
    (degrade_dec : ∀ s o, K s → taskDegrades o → 0 < eta s → eta (sys.next s o) < eta s)
    (degrade_zero : ∀ s o, K s → taskDegrades o → eta s = 0 → eta (sys.next s o) = 0)
    (meets : RegimeMargin.Meets sys.g H_safe y_safe hi)
    (keeps : RegimeMargin.Keeps sys.g 0 hi)
    (band_room : (H_safe + y_safe) + H_safe ≤ hi)
    (clearing : (H_safe + y_safe) + drawCeiling * (lag + 1) ≤ B_task)
    (init_margin : (H_safe + y_safe) + eta init * drawCeiling ≤ x₀)
    (init_top : x₀ ≤ hi) :
    Viability.Kernel (Law.process sys.step)
      (fun st => H_safe + y_safe ≤ st.1 ∧ st.1 ≤ hi ∧ K st.2) (x₀, init) ∧
    (∀ t, H_safe + y_safe ≤ (Law.orbit sys.step (x₀, init) t).1 ∧
          (Law.orbit sys.step (x₀, init) t).1 ≤ hi) :=
  sys.timely_turning_kernel K eta taskDegrades init x₀ init_in k_closed eta_le draw_le
    draw_safe registers degrade_dec degrade_zero meets keeps band_room clearing
    init_margin init_top

/-- Invariant for `ofServiceTask`: latches `.safe` (`false`) once `eta = 0` (`s.1 = false ↔ s.2 = 0`). -/
def serviceK (lag : Nat) (s : Bool × Nat) : Prop :=
  s.2 ≤ lag ∧ (s.1 = true → 0 < s.2) ∧ (s.1 = false → s.2 = 0)

/-- Single countdown step for `(true, e)`, latching `(false, 0)` at `e ≤ 1`. -/
def decService : Nat → Bool × Nat
  | 0 => (false, 0)
  | 1 => (false, 0)
  | k + 2 => (true, k + 1)

/-- Constructs an `EndogenousSystem` from a `ServiceTaskModel` with `lag`-step countdown and
`.safe` latching (`true` = `M.ext`, `false` = `M.safe`), observing ONLY `realizedScore M M.ext x base`. -/
def EndogenousSystem.ofServiceTask {P : Type} (M : ServiceTaskModel P) (g : Nat → Nat)
    (base : Nat) : EndogenousSystem (Bool × Nat) Nat where
  next s sc :=
    if s.1 then
      if sc < M.nominalSafe base then decService s.2 else s
    else (false, 0)
  obs _ x := M.realizedScore M.ext x base
  draw s := if s.1 then M.draw M.ext else M.draw M.safe
  g := g

theorem ofServiceTask_viable {P : Type} (M : ServiceTaskModel P) (g : Nat → Nat)
    {base H_safe y_safe lag hi : Nat} (x₀ : Nat) (init : Bool × Nat)
    (hBase : M.upkeep M.ext ≤ base) (init_in : serviceK lag init)
    (safe_le : M.draw M.safe ≤ H_safe)
    (meets : RegimeMargin.Meets g H_safe y_safe hi)
    (keeps : RegimeMargin.Keeps g 0 hi)
    (band_room : (H_safe + y_safe) + H_safe ≤ hi)
    (clearing : (H_safe + y_safe) + AdaptiveLoops.natMax (M.draw M.ext) (M.draw M.safe) * (lag + 1) ≤ M.B_task)
    (init_margin : (H_safe + y_safe) + init.2 * AdaptiveLoops.natMax (M.draw M.ext) (M.draw M.safe) ≤ x₀)
    (init_top : x₀ ≤ hi) :
    Viability.Kernel (Law.process (EndogenousSystem.ofServiceTask M g base).step)
      (fun st => H_safe + y_safe ≤ st.1 ∧ st.1 ≤ hi ∧ serviceK lag st.2) (x₀, init) ∧
    (∀ t, H_safe + y_safe ≤
      (Law.orbit (EndogenousSystem.ofServiceTask M g base).step (x₀, init) t).1 ∧
      (Law.orbit (EndogenousSystem.ofServiceTask M g base).step (x₀, init) t).1 ≤ hi) := by
  let sys := EndogenousSystem.ofServiceTask M g base
  let drawCeiling := AdaptiveLoops.natMax (M.draw M.ext) (M.draw M.safe)
  have kClosed : ∀ s sc, serviceK lag s → serviceK lag (sys.next s sc) := fun s sc hs => by
    cases hB : s.1 with
    | false =>
      change serviceK lag (if s.1 then _ else (false, 0))
      rw [hB]
      exact ⟨Nat.zero_le lag, fun h => Bool.noConfusion h, fun _ => rfl⟩
    | true =>
      change serviceK lag (if s.1 then _ else (false, 0))
      rw [hB]
      cases Nat.decLt sc (M.nominalSafe base) with
      | isFalse nlt =>
        rw [if_neg nlt]
        exact hs
      | isTrue lt =>
        rw [if_pos lt]
        cases hE : s.2 with
        | zero => exact absurd (hE ▸ hs.2.1 hB) (Nat.lt_irrefl 0)
        | succ e =>
          cases e with
          | zero =>
            exact ⟨Nat.zero_le lag, fun h => Bool.noConfusion h, fun _ => rfl⟩
          | succ k =>
            have hs1 : (k + 1) + 1 ≤ lag := by
              have h' := hs.1
              rw [hE] at h'
              exact h'
            have eLe : k + 1 ≤ lag := Nat.le_trans (Nat.le_succ (k + 1)) hs1
            exact ⟨eLe, fun _ => Nat.succ_pos k, fun h => Bool.noConfusion h⟩
  have drawLe : ∀ s, serviceK lag s → sys.draw s ≤ drawCeiling := fun s _ => by
    show (if s.1 then M.draw M.ext else M.draw M.safe) ≤ drawCeiling
    cases s.1
    · exact AdaptiveLoops.le_natMax_right _ _
    · exact AdaptiveLoops.le_natMax_left _ _
  have drawSafe : ∀ s, serviceK lag s → s.2 = 0 → sys.draw s ≤ H_safe := fun s hs h0 => by
    cases hB : s.1 with
    | false =>
      show (if s.1 then M.draw M.ext else M.draw M.safe) ≤ H_safe
      rw [hB]
      exact safe_le
    | true =>
      exact absurd (h0 ▸ hs.2.1 hB) (Nat.lt_irrefl 0)
  have reg : ∀ s x, serviceK lag s → x < M.B_task → sys.obs s x < M.nominalSafe base :=
    fun _ x _ lt => (M.score_crosses_iff x base).2 hBase |>.mpr lt
  have degDec : ∀ s sc, serviceK lag s → sc < M.nominalSafe base → 0 < s.2 →
      (sys.next s sc).2 < s.2 := fun s sc hs hSc hPos => by
    cases hB : s.1 with
    | false => exact absurd (hs.2.2 hB ▸ hPos) (Nat.lt_irrefl 0)
    | true =>
      change (if s.1 then _ else (false, 0)).2 < s.2
      rw [hB, if_pos hSc]
      cases hE : s.2 with
      | zero => exact absurd (hE ▸ hPos) (Nat.lt_irrefl 0)
      | succ e =>
        cases e with
        | zero => exact Nat.succ_pos 0
        | succ k => exact Nat.lt_succ_self (k + 1)
  have degZero : ∀ s sc, serviceK lag s → sc < M.nominalSafe base → s.2 = 0 →
      (sys.next s sc).2 = 0 := fun s sc hs _ h0 => by
    cases hB : s.1 with
    | false =>
      change (if s.1 then _ else (false, 0)).2 = 0
      rw [hB]
      rfl
    | true => exact absurd (h0 ▸ hs.2.1 hB) (Nat.lt_irrefl 0)
  exact endogenous_turning_kernel sys (serviceK lag) Prod.snd (· < M.nominalSafe base)
    init x₀ init_in kClosed (fun _ h => h.1) drawLe drawSafe reg degDec degZero
    meets keeps band_room clearing init_margin init_top

/-! ### 4.2 `Clearing`-Pooled Black-Box Turning (`AdaptiveLoops.OpenLoop`) -/

/-- **Hook 3 (`pooled_service_turning_viable`)**: black-box `AdaptiveLoops.assume_guarantee_joint_viable`
specialization at `ι := Unit` where a partner listens via `ServiceTaskModel.realizedScore` and
fires the pooled alarm channel when `realizedScore M M.ext (x ()) base < M.nominalSafe base`. -/
theorem pooled_service_turning_viable
    {α Env : Type} {S Obs Dist : α → Type} {P : Type}
    (agents : List α)
    (L : (i : α) → AdaptiveLoops.OpenLoop (S i) (Obs i) (Dist i) Unit)
    (init : (i : α) → S i)
    (certs : (i : α) → AdaptiveLoops.LoopCertificate (L i) (init i))
    (obs : (i : α) → (Unit → Nat) → Obs i)
    (channel : (α → Bool) → (α → Nat) → Env → Bool)
    (G : Unit → (Unit → Nat) → Nat)
    (envDraw : Env → Unit → Nat) (envCap : Unit → Nat) (jointAdm : Env → Prop)
    (env_within : ∀ env, jointAdm env → envDraw env () ≤ envCap ())
    (x_crit H_safe x₀ : Unit → Nat)
    (partner : α) (partnerMem : partner ∈ agents)
    (M : ServiceTaskModel P) (base : Nat) (hBase : M.upkeep M.ext ≤ base)
    (obs_task : ∀ x,
      M.realizedScore M.ext (x ()) base < M.nominalSafe base → (certs partner).warnObs (obs partner x))
    (channel_fires : ∀ emit load env, jointAdm env →
      (∃ i, i ∈ agents ∧ emit i = true ∧ load i ≤ (certs i).maxSilence) →
      (∀ i, i ∈ agents → load i ≤ (certs i).maxSilence) →
      channel emit load env = true)
    (G_rises : RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (G ()))
    (post_viable : x_crit () ≤ RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole G H_safe x_crit ())
    (post_cap : AdaptiveLoops.sumDraws agents (fun i => (certs i).postBudget) () + envCap () ≤ H_safe ())
    (task_margin : x_crit () + (AdaptiveLoops.globalMaxLag agents certs + 1) *
      AdaptiveLoops.preTotal agents certs envCap () ≤ M.B_task)
    (init_margin : x_crit () + AdaptiveLoops.maxEta agents certs init *
      AdaptiveLoops.preTotal agents certs envCap () ≤ x₀ ()) :
    AdaptiveLoops.jointInv agents certs envCap x_crit (x₀, init) ∧
    Viability.Certificate
      (AdaptiveLoops.jointProcess agents L certs obs channel G envDraw jointAdm)
      (AdaptiveLoops.jointGuard agents L certs x_crit)
      (AdaptiveLoops.jointInv agents certs envCap x_crit) ∧
    (∀ r : Run (AdaptiveLoops.jointProcess agents L certs obs channel G envDraw jointAdm),
      r.state 0 = (x₀, init) → ∀ t, x_crit () ≤ (r.state t).1 ()) := by
  have res := AdaptiveLoops.assume_guarantee_joint_viable
    agents [()] (fun j => by cases j; exact .head _)
    L init certs obs channel G envDraw envCap jointAdm
    (fun env hAdm j => by cases j; exact env_within env hAdm)
    x_crit (fun _ => M.B_task) H_safe x₀
    (fun i _ => i = partner)
    (fun i _ x j heq lt => by
      cases heq
      cases j
      exact obs_task x (((M.score_crosses_iff (x ()) base).2 hBase).mpr lt))
    (fun j _ => ⟨partner, partnerMem, rfl⟩)
    channel_fires
    (fun i => by cases i; exact G_rises)
    (fun j => by cases j; exact post_viable)
    (fun j => by cases j; exact post_cap)
    (fun j => by cases j; exact task_margin)
    (fun j => by cases j; exact init_margin)
  have kern := res.2.kernel res.1
  refine ⟨res.1, res.2, fun r h0 t => ?_⟩
  exact (Viability.Kernel.run r (h0 ▸ kern) t).1 ()

/- Concrete two-agent `Clearing`-pooled coupling (`proxyAgent` uncoupled from `S` listening to the
channel + `taskPartner` reading `ServiceTaskModel.realizedScore`). -/
namespace PooledClearing

inductive PooledAgent where
  | proxyAgent
  | taskPartner

def pooledAgents : List PooledAgent := [.proxyAgent, .taskPartner]

abbrev PooledState : PooledAgent → Type
  | .proxyAgent => Nat
  | .taskPartner => Bool × Nat

abbrev PooledObs : PooledAgent → Type
  | .proxyAgent => Unit
  | .taskPartner => Nat

def proxyNext (s : Nat) (oa : Unit × Bool) (_ : Unit) : Nat :=
  if oa.2 then s - 1 else s

def taskNext (s : Bool × Nat) (oa : Nat × Bool) (_ : Unit) : Bool × Nat :=
  if oa.2 then decService s.2 else s

def proxyLoop (hProxyPre hProxySafe : Nat) : AdaptiveLoops.OpenLoop Nat Unit Unit Unit :=
  OpenComposition.countdownLoop hProxyPre hProxySafe (fun _ _ => false)

def taskLoop {P : Type} (M : ServiceTaskModel P) (base : Nat) :
    AdaptiveLoops.OpenLoop (Bool × Nat) Nat Unit Unit where
  next := taskNext
  draw s _ := if s.1 then M.draw M.ext else M.draw M.safe
  emitAlarm _ sc := decide (sc < M.nominalSafe base)
  silenceLoad _ := 0
  favours s := s.1 = true

def pooledOpenLoop {P : Type} (M : ServiceTaskModel P) (base : Nat)
    (hProxyPre hProxySafe : Nat) :
    (i : PooledAgent) → AdaptiveLoops.OpenLoop (PooledState i) (PooledObs i) Unit Unit
  | .proxyAgent => proxyLoop hProxyPre hProxySafe
  | .taskPartner => taskLoop M base

def pooledObs {P : Type} (M : ServiceTaskModel P) (base : Nat) :
    (i : PooledAgent) → (Unit → Nat) → PooledObs i
  | .proxyAgent, _ => ()
  | .taskPartner, x => M.realizedScore M.ext (x ()) base

def pooledChannel (emit : PooledAgent → Bool) (load : PooledAgent → Nat) (_ : Unit) : Bool :=
  (emit .proxyAgent && Nat.ble (load .proxyAgent) 0) ||
  (emit .taskPartner && Nat.ble (load .taskPartner) 0)

def proxyCert (hProxyPre hProxySafe lagProxy : Nat) (safe_le : hProxySafe ≤ hProxyPre)
    (init : Nat) (initProxy : init ≤ lagProxy) :
    AdaptiveLoops.LoopCertificate (proxyLoop hProxyPre hProxySafe) init :=
  OpenComposition.countdownCert hProxyPre hProxySafe 0 lagProxy init
    (fun _ _ => false) (fun _ => False) safe_le initProxy (fun _ _ _ w => False.elim w)

def taskCert {P : Type} (M : ServiceTaskModel P) (base lagPartner : Nat)
    (init : Bool × Nat) (initPartner : serviceK lagPartner init) :
    AdaptiveLoops.LoopCertificate (taskLoop M base) init where
  tol _ _ := True
  warnObs sc := sc < M.nominalSafe base
  preCap _ := AdaptiveLoops.natMax (M.draw M.ext) (M.draw M.safe)
  postBudget _ := M.draw M.safe
  maxSilence := 0
  maxLag := lagPartner
  K := serviceK lagPartner
  eta := Prod.snd
  init_in := initPartner
  cert := Viability.certificate_disturbed_iff.mpr
    ⟨fun s hK =>
      ⟨fun _ => by
        show (if s.1 then M.draw M.ext else M.draw M.safe) ≤
          AdaptiveLoops.natMax (M.draw M.ext) (M.draw M.safe)
        cases s.1
        · exact AdaptiveLoops.le_natMax_right _ _
        · exact AdaptiveLoops.le_natMax_left _ _,
       Nat.le_refl 0,
       fun h0 => by
         cases hB : s.1 with
         | true => exact absurd (h0 ▸ hK.2.1 hB) (Nat.lt_irrefl 0)
         | false =>
           refine ⟨fun hEq => Bool.noConfusion (hB.symm.trans hEq), fun _ => ?_⟩
           show (if s.1 then M.draw M.ext else M.draw M.safe) ≤ M.draw M.safe
           rw [hB]
           exact Nat.le_refl _⟩,
     fun s oa _ hK => by
       show serviceK lagPartner (taskNext s oa.1 oa.2)
       cases hA : oa.1.2 with
       | false =>
         rw [taskNext, if_neg (by rw [hA]; exact Bool.false_ne_true)]
         exact hK
       | true =>
         rw [taskNext, if_pos hA]
         cases hE : s.2 with
         | zero => exact ⟨Nat.zero_le lagPartner, fun h => Bool.noConfusion h, fun _ => rfl⟩
         | succ e =>
           cases e with
           | zero => exact ⟨Nat.zero_le lagPartner, fun h => Bool.noConfusion h, fun _ => rfl⟩
           | succ k =>
             have hk1 : (k + 1) + 1 ≤ lagPartner := by
               have h' := hK.1
               rw [hE] at h'
               exact h'
             have eLe : k + 1 ≤ lagPartner := Nat.le_trans (Nat.le_succ (k + 1)) hk1
             exact ⟨eLe, fun _ => Nat.succ_pos k, fun h => Bool.noConfusion h⟩⟩
  eta_bound _ hK := hK.1
  emits_on_warn _ sc _ warn := by
    show decide (sc < M.nominalSafe base) = true
    exact decide_eq_true warn
  eta_alarm_step s obs _ _ _ pos := by
    show (taskNext s (obs, true) ()).2 < s.2
    rw [taskNext, if_pos rfl]
    cases hE : s.2 with
    | zero => exact absurd (hE ▸ pos) (Nat.lt_irrefl 0)
    | succ e =>
      cases e with
      | zero => exact Nat.succ_pos 0
      | succ k => exact Nat.lt_succ_self (k + 1)
  eta_alarm_zero s obs _ _ _ h0 := by
    show (taskNext s (obs, true) ()).2 = 0
    rw [taskNext, if_pos rfl, h0]
    rfl

def pooledCerts {P : Type} (M : ServiceTaskModel P) (base : Nat)
    (hProxyPre hProxySafe lagProxy lagPartner : Nat)
    (safe_le : hProxySafe ≤ hProxyPre)
    (init : (i : PooledAgent) → PooledState i)
    (initProxy : init .proxyAgent ≤ lagProxy)
    (initPartner : serviceK lagPartner (init .taskPartner)) :
    (i : PooledAgent) → AdaptiveLoops.LoopCertificate (pooledOpenLoop M base hProxyPre hProxySafe i) (init i)
  | .proxyAgent => proxyCert hProxyPre hProxySafe lagProxy safe_le (init .proxyAgent) initProxy
  | .taskPartner => taskCert M base lagPartner (init .taskPartner) initPartner

theorem pooled_clearing_turning {P : Type} (M : ServiceTaskModel P) (base : Nat)
    (hBase : M.upkeep M.ext ≤ base)
    (hProxyPre hProxySafe lagProxy lagPartner : Nat)
    (safe_le : hProxySafe ≤ hProxyPre)
    (init : (i : PooledAgent) → PooledState i)
    (initProxy : init .proxyAgent ≤ lagProxy)
    (initPartner : serviceK lagPartner (init .taskPartner))
    (G : Unit → (Unit → Nat) → Nat)
    (x_crit H_safe x₀ : Unit → Nat)
    (G_rises : RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (G ()))
    (post_viable : x_crit () ≤ RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole G H_safe x_crit ())
    (post_cap : hProxySafe + (M.draw M.safe + 0) ≤ H_safe ())
    (task_margin : x_crit () + (AdaptiveLoops.globalMaxLag pooledAgents
        (pooledCerts M base hProxyPre hProxySafe lagProxy lagPartner safe_le init initProxy initPartner) + 1) *
      AdaptiveLoops.preTotal pooledAgents
        (pooledCerts M base hProxyPre hProxySafe lagProxy lagPartner safe_le init initProxy initPartner)
        (fun _ => 0) () ≤ M.B_task)
    (init_margin : x_crit () + AdaptiveLoops.maxEta pooledAgents
        (pooledCerts M base hProxyPre hProxySafe lagProxy lagPartner safe_le init initProxy initPartner) init *
      AdaptiveLoops.preTotal pooledAgents
        (pooledCerts M base hProxyPre hProxySafe lagProxy lagPartner safe_le init initProxy initPartner)
        (fun _ => 0) () ≤ x₀ ()) :
    ∀ r : Run
      (AdaptiveLoops.jointProcess pooledAgents (pooledOpenLoop M base hProxyPre hProxySafe)
        (pooledCerts M base hProxyPre hProxySafe lagProxy lagPartner safe_le init initProxy initPartner)
        (pooledObs M base) pooledChannel G (fun _ _ => 0) (fun _ => True)),
      r.state 0 = (x₀, init) → ∀ t, x_crit () ≤ (r.state t).1 () :=
  (pooled_service_turning_viable pooledAgents
    (pooledOpenLoop M base hProxyPre hProxySafe) init
    (pooledCerts M base hProxyPre hProxySafe lagProxy lagPartner safe_le init initProxy initPartner)
    (pooledObs M base) pooledChannel G (fun _ _ => 0) (fun _ => 0) (fun _ => True)
    (fun _ _ => Nat.le_refl 0) x_crit H_safe x₀ .taskPartner (.tail _ (.head _)) M base hBase
    (fun _ lt => lt)
    (fun emit load _ _ ⟨i, _, hemit, hload⟩ _ => by
      cases i
      · have h0 : Nat.ble (load .proxyAgent) 0 = true := Nat.ble_eq_true_of_le hload
        exact ListTests.or_true_iff.mpr (.inl (ListTests.and_true_iff.mpr ⟨hemit, h0⟩))
      · have h0 : Nat.ble (load .taskPartner) 0 = true := Nat.ble_eq_true_of_le hload
        exact ListTests.or_true_iff.mpr (.inr (ListTests.and_true_iff.mpr ⟨hemit, h0⟩)))
    G_rises post_viable post_cap task_margin init_margin).2.2

/-- **Unpooled clearer blindness**: when the partner channel is disconnected (`channel := fun _ _ _ => false`),
two `jointProcess` runs from high `x_big` vs low `x₀` carry IDENTICAL `proxyAgent` states (and draws)
at every step `t`, collapsing `x` whenever `hProxyPre > Y`. -/
theorem unpooled_clearer_blind {P : Type} (M : ServiceTaskModel P) (base : Nat)
    (hProxyPre hProxySafe lagProxy lagPartner : Nat)
    (safe_le : hProxySafe ≤ hProxyPre)
    (init : (i : PooledAgent) → PooledState i)
    (initProxy : init .proxyAgent ≤ lagProxy)
    (initPartner : serviceK lagPartner (init .taskPartner))
    (g : Nat → Nat)
    (r1 r2 : Run
      (AdaptiveLoops.jointProcess (Env := Unit) pooledAgents (pooledOpenLoop M base hProxyPre hProxySafe)
        (pooledCerts M base hProxyPre hProxySafe lagProxy lagPartner safe_le init initProxy initPartner)
        (pooledObs M base) (fun _ _ (_ : Unit) => false) (fun _ e => g (e ()))
        (fun _ _ => 0) (fun _ => True)))
    {x₀ x_big : Unit → Nat} (hStart1 : r1.state 0 = (x₀, init)) (hStart2 : r2.state 0 = (x_big, init))
    (proxyFavours : 0 < init .proxyAgent)
    {Y H_safe y_safe : Nat}
    (most : RegimeMargin.AtMost g Y) (over : Y < hProxyPre)
    (short : RegimeMargin.Short g H_safe y_safe) (hSafeLe : H_safe ≤ hProxyPre)
    (nothing : RegimeMargin.FromNothing g) (hPos : 0 < H_safe + y_safe)
    (n : Nat) (within : x₀ () < (H_safe + y_safe) + (hProxyPre - Y) * n) :
    (∀ t, (r1.state t).2 .proxyAgent = init .proxyAgent ∧
          (r2.state t).2 .proxyAgent = init .proxyAgent ∧
          (pooledOpenLoop M base hProxyPre hProxySafe .proxyAgent).draw ((r1.state t).2 .proxyAgent) () =
            hProxyPre) ∧
    ∃ T, T ≤ n ∧ (r1.state T).1 () < H_safe + y_safe ∧
      (∀ k, (StockFlowBridge.unitWeb (fun t => (r1.state t).1 ())).level (T + k) () < H_safe + y_safe) ∧
      (∃ M₀, (r1.state M₀).1 () = 0 ∧ ∀ j, (r1.state (M₀ + j)).1 () = 0) := by
  have const1 : ∀ t, (r1.state t).2 .proxyAgent = init .proxyAgent := fun t => by
    induction t with
    | zero => rw [hStart1]
    | succ t ih =>
      have hs := (r1.step t).2
      have hProxy : (r1.state (t + 1)).2 .proxyAgent =
          proxyNext ((r1.state t).2 .proxyAgent) ((), false) () := by
        rw [hs]
        rfl
      rw [hProxy, proxyNext, ih]
      rfl
  have const2 : ∀ t, (r2.state t).2 .proxyAgent = init .proxyAgent := fun t => by
    induction t with
    | zero => rw [hStart2]
    | succ t ih =>
      have hs := (r2.step t).2
      have hProxy : (r2.state (t + 1)).2 .proxyAgent =
          proxyNext ((r2.state t).2 .proxyAgent) ((), false) () := by
        rw [hs]
        rfl
      rw [hProxy, proxyNext, ih]
      rfl
  have drawEq : ∀ t, (pooledOpenLoop M base hProxyPre hProxySafe .proxyAgent).draw
      ((r1.state t).2 .proxyAgent) () = hProxyPre := fun t => by
    rw [const1 t]
    show (if init .proxyAgent = 0 then hProxySafe else hProxyPre) = hProxyPre
    have ne0 : init .proxyAgent ≠ 0 := fun h0 => Nat.lt_irrefl 0 (h0 ▸ proxyFavours)
    exact if_neg ne0
  let x := fun t => (r1.state t).1 ()
  let d := fun t => AdaptiveLoops.sumDraws pooledAgents
    (fun i => (pooledOpenLoop M base hProxyPre hProxySafe i).draw ((r1.state t).2 i)) () + 0
  have step_eq : ∀ t, x (t + 1) = RegimeMargin.step g (d t) (x t) := fun t => by
    have hs := (r1.step t).2
    show (r1.state (t + 1)).1 () = _
    rw [hs]
    rfl
  have dGe : ∀ t, hProxyPre ≤ d t := fun t => by
    show hProxyPre ≤ (pooledOpenLoop M base hProxyPre hProxySafe .proxyAgent).draw ((r1.state t).2 .proxyAgent) () +
      ((pooledOpenLoop M base hProxyPre hProxySafe .taskPartner).draw ((r1.state t).2 .taskPartner) () + 0) + 0
    rw [drawEq t]
    exact Nat.le_add_right _ _
  have x0Eq : x 0 = x₀ () := congrArg (fun st => st.1 ()) hStart1
  obtain ⟨T, hTn, hTlt⟩ :=
    falls_within_ge step_eq most nothing (Nat.le_of_lt over) dGe hPos n (x0Eq ▸ within)
  obtain ⟨hStay, M₀, hMzero, hMstay⟩ :=
    short_stays_below_ge step_eq short nothing (fun t _ => Nat.le_trans hSafeLe (dGe t)) hTlt
  exact ⟨fun t => ⟨const1 t, const2 t, drawEq t⟩, T, hTn, hTlt, hStay, M₀, hMzero, hMstay⟩

/-- Explicit structural link to `Becoming.Selection.Clearing.selected_pooled`: in `Clearing`,
pooled admission of clearer and dweller holds via `Web.SelectsThroughAll` and fails via
`Web.SelectsThrough` of either member alone. -/
theorem clearing_pooled_contrast :
    Clearing.web.SelectsThroughAll thresholdOnly
      Becoming.Clearing.clearerAndDweller 2 Becoming.Clearing.BothAdmitted ∧
    ¬ Clearing.web.SelectsThrough thresholdOnly .clearer 2 Becoming.Clearing.BothAdmitted ∧
    ¬ Clearing.web.SelectsThrough thresholdOnly .dweller 2 Becoming.Clearing.BothAdmitted :=
  ⟨Becoming.Clearing.selected_pooled.1,
   Becoming.Clearing.selected_pooled.2.2.2.1,
   Becoming.Clearing.selected_pooled.2.2.2.2⟩

end PooledClearing

/-! ## 5. Part B.3 — Epistemic Silence Boundary (Impossibility Counter-Theorems) -/

/-- **Hook 4a (`epistemic_silence_late_bottleneck`)**: when `B_task ≤ H_safe + y_safe` and no
degradation signal fires at or above `B_task`, EVERY responder keeping `H_pre` when `¬ degrades`
drives the substrate below `H_safe + y_safe` within `n` steps. Post-`T` safe draws still collapse to
`0` (`StockFlowBridge.unitNeverReturnsBelowWithin`), and under `RegimeMargin.Gated` any post-`T`
draw sequence stays below `H_safe + y_safe` forever (`Optimum.gated_stays_below`). -/
theorem epistemic_silence_late_bottleneck
    {S Obs P : Type}
    (next : S → Obs → S) (obs : S → Nat → Obs) (respond : S → Obs → P) (draw : P → Nat)
    (g : Nat → Nat) {B_task Y H_pre H_safe y_safe : Nat}
    (K : S → Prop) (degrades : Obs → Prop)
    (init : S) (init_in : K init) (k_closed : ∀ s o, K s → K (next s o))
    (late : B_task ≤ H_safe + y_safe)
    (silent_above : ∀ s x, K s → B_task ≤ x → ¬ degrades (obs s x))
    (responder_keeps_pre : ∀ s o, K s → ¬ degrades o → H_pre ≤ draw (respond s o))
    (most : RegimeMargin.AtMost g Y) (over : Y < H_pre)
    (short : RegimeMargin.Short g H_safe y_safe)
    (nothing : RegimeMargin.FromNothing g) (hPos : 0 < H_safe + y_safe)
    (x : Nat → Nat) (s : Nat → S)
    (s_zero : s 0 = init) (s_step : ∀ t, s (t + 1) = next (s t) (obs (s t) (x t)))
    (x_step : ∀ t, x (t + 1) = RegimeMargin.step g (draw (respond (s t) (obs (s t) (x t)))) (x t))
    (n : Nat) (within : x 0 < (H_safe + y_safe) + (H_pre - Y) * n) :
    (∀ t, H_safe + y_safe ≤ x t → H_pre ≤ draw (respond (s t) (obs (s t) (x t)))) ∧
    ∃ T, T ≤ n ∧ x T < H_safe + y_safe ∧
      ((∀ t, T ≤ t → H_safe ≤ draw (respond (s t) (obs (s t) (x t)))) →
        (∀ k, (StockFlowBridge.unitWeb x).level (T + k) () < H_safe + y_safe) ∧
        (∃ M, x M = 0 ∧ ∀ j, x (M + j) = 0)) ∧
      (RegimeMargin.Gated g (H_safe + y_safe) → ∀ k, x (T + k) < H_safe + y_safe) := by
  have inK : ∀ t, K (s t) := fun t => by
    induction t with
    | zero => exact s_zero ▸ init_in
    | succ t ih => rw [s_step t]; exact k_closed _ _ ih
  have keepsPreAbove : ∀ t, H_safe + y_safe ≤ x t →
      H_pre ≤ draw (respond (s t) (obs (s t) (x t))) := fun t hx =>
    responder_keeps_pre (s t) (obs (s t) (x t)) (inK t)
      (silent_above (s t) (x t) (inK t) (Nat.le_trans late hx))
  have boundWhile : ∀ m, (∃ k, k ≤ m ∧ x k < H_safe + y_safe) ∨
      (x m + (H_pre - Y) * m ≤ x 0 ∧ H_safe + y_safe ≤ x m) := fun m => by
    induction m with
    | zero =>
      exact (Nat.lt_or_ge (x 0) (H_safe + y_safe)).elim
        (fun lt => .inl ⟨0, Nat.le_refl 0, lt⟩)
        (fun ge => .inr ⟨Nat.le_refl (x 0), ge⟩)
    | succ m ih =>
      refine ih.elim (fun ⟨k, kle, lt⟩ => .inl ⟨k, Nat.le_succ_of_le kle, lt⟩) fun ⟨bound, above⟩ => ?_
      let d_m := draw (respond (s m) (obs (s m) (x m)))
      have dGe : H_pre ≤ d_m := keepsPreAbove m above
      cases Nat.lt_or_ge (x m) d_m with
      | inl underD =>
        have xz : x (m + 1) = 0 := by
          rw [x_step m, RegimeMargin.step, sub_eq_zero_of_le (Nat.le_of_lt underD), Nat.zero_add]
          exact nothing
        exact .inl ⟨m + 1, Nat.le_refl _, xz ▸ hPos⟩
      | inr overD =>
        have stepFalls : x (m + 1) + (H_pre - Y) ≤ x m := by
          rw [x_step m, RegimeMargin.step]
          calc (x m - d_m) + g (x m - d_m) + (H_pre - Y)
              ≤ (x m - d_m) + Y + (H_pre - Y) :=
                Nat.add_le_add_right (Nat.add_le_add_left (most _) _) _
            _ = (x m - d_m) + (Y + (H_pre - Y)) := Nat.add_assoc _ _ _
            _ = (x m - d_m) + H_pre := by rw [add_sub_of_le (Nat.le_of_lt over)]
            _ ≤ (x m - d_m) + d_m := Nat.add_le_add_left dGe _
            _ = x m := Naturals.sub_add_cancel overD
        have bound' : x (m + 1) + (H_pre - Y) * (m + 1) ≤ x 0 := by
          calc x (m + 1) + (H_pre - Y) * (m + 1)
              = x (m + 1) + ((H_pre - Y) * m + (H_pre - Y)) := rfl
            _ = x (m + 1) + ((H_pre - Y) + (H_pre - Y) * m) := by
                rw [Nat.add_comm ((H_pre - Y) * m) (H_pre - Y)]
            _ = (x (m + 1) + (H_pre - Y)) + (H_pre - Y) * m := (Nat.add_assoc _ _ _).symm
            _ ≤ x m + (H_pre - Y) * m := Nat.add_le_add_right stepFalls _
            _ ≤ x 0 := bound
        exact (Nat.lt_or_ge (x (m + 1)) (H_safe + y_safe)).elim
          (fun lt => .inl ⟨m + 1, Nat.le_refl _, lt⟩)
          (fun ge => .inr ⟨bound', ge⟩)
  obtain ⟨T, hTn, hTlt⟩ := (boundWhile n).elim id fun ⟨bound, above⟩ =>
    absurd (Nat.lt_of_le_of_lt (Nat.le_trans (Nat.add_le_add_right above _) bound) within)
      (Nat.lt_irrefl _)
  refine ⟨keepsPreAbove, T, hTn, hTlt, ?_, ?_⟩
  · intro postSafe
    exact short_stays_below_ge x_step short nothing postSafe hTlt
  · intro gated k
    exact gated_step_stays_below x_step hPos gated hTlt k

/-- **Structural `ServiceTaskModel` saturation corollary**: whenever `M.demand M.ext ≤ H_safe + y_safe`,
`M.B_task ≤ H_safe + y_safe` holds automatically for EVERY gain/upkeep ratio, triggering
`epistemic_silence_late_bottleneck`. -/
theorem service_saturated_below_noReturn_silenced
    {S P : Type} (M : ServiceTaskModel P) (base : Nat) (hBase : M.upkeep M.ext ≤ base)
    (next : S → Nat → S) (respond : S → Nat → P) (draw : P → Nat)
    (g : Nat → Nat) {Y H_pre H_safe y_safe : Nat}
    (K : S → Prop) (init : S) (init_in : K init) (k_closed : ∀ s sc, K s → K (next s sc))
    (sat : M.demand M.ext ≤ H_safe + y_safe)
    (responder_keeps_pre : ∀ s sc, K s → ¬ (sc < M.nominalSafe base) → H_pre ≤ draw (respond s sc))
    (most : RegimeMargin.AtMost g Y) (over : Y < H_pre)
    (short : RegimeMargin.Short g H_safe y_safe)
    (nothing : RegimeMargin.FromNothing g) (hPos : 0 < H_safe + y_safe)
    (x : Nat → Nat) (s : Nat → S)
    (s_zero : s 0 = init) (s_step : ∀ t, s (t + 1) = next (s t) (M.realizedScore M.ext (x t) base))
    (x_step : ∀ t,
      x (t + 1) = RegimeMargin.step g (draw (respond (s t) (M.realizedScore M.ext (x t) base))) (x t))
    (n : Nat) (within : x 0 < (H_safe + y_safe) + (H_pre - Y) * n) :
    (∀ t, H_safe + y_safe ≤ x t →
      H_pre ≤ draw (respond (s t) (M.realizedScore M.ext (x t) base))) ∧
    ∃ T, T ≤ n ∧ x T < H_safe + y_safe ∧
      ((∀ t, T ≤ t → H_safe ≤ draw (respond (s t) (M.realizedScore M.ext (x t) base))) →
        (∀ k, (StockFlowBridge.unitWeb x).level (T + k) () < H_safe + y_safe) ∧
        (∃ M₀, x M₀ = 0 ∧ ∀ j, x (M₀ + j) = 0)) ∧
      (RegimeMargin.Gated g (H_safe + y_safe) → ∀ k, x (T + k) < H_safe + y_safe) :=
  epistemic_silence_late_bottleneck next (fun _ lv => M.realizedScore M.ext lv base)
    respond draw g K (· < M.nominalSafe base) init init_in k_closed
    (Nat.le_trans M.B_task_le_demand_ext sat)
    (fun _ lv _ hB => fun lt =>
      Nat.not_le_of_gt (((M.score_crosses_iff lv base).2 hBase).mp lt) hB)
    responder_keeps_pre most over short nothing hPos x s s_zero s_step x_step n within

/-- **Masked bottleneck (`ClosedCapture.Unread`, without requiring monotone `g`)**:
combines `ClosedCapture.unread_course`, `falls_within_ge`, and `short_stays_below_ge`
(`StockFlowBridge.unitNeverReturnsBelowWithin`), covering saturating non-monotone carrying-capacity
substrates such as `wGivingCap`. -/
theorem epistemic_silence_masked_unread
    {A R : Type} {f : A × Nat → R → A × Nat} {h : A × Nat → R → R}
    (reads : Nat → Bool) (unread : ClosedCapture.Unread f h)
    {gSub : Nat → Nat} (jointDraw : A → R → Nat)
    (x_step : ∀ a x r, (f (a, x) r).2 = RegimeMargin.step gSub (jointDraw a r) x)
    (a₀ : A) (r₀ : R) (x₀ x_big Y H_pre H_safe y_safe n : Nat)
    (draw_ge : ∀ t, H_pre ≤ jointDraw (Pace.paced f h reads ((a₀, x₀), r₀) t).1.1
      (Pace.paced f h reads ((a₀, x₀), r₀) t).2)
    (most : RegimeMargin.AtMost gSub Y) (over : Y < H_pre)
    (short : RegimeMargin.Short gSub H_safe y_safe) (hSafeLe : H_safe ≤ H_pre)
    (nothing : RegimeMargin.FromNothing gSub) (hPos : 0 < H_safe + y_safe)
    (within : x₀ < (H_safe + y_safe) + (H_pre - Y) * n) :
    (∀ t, (Pace.paced f h reads ((a₀, x₀), r₀) t).1.1 =
        (Pace.paced f h reads ((a₀, x_big), r₀) t).1.1 ∧
      (Pace.paced f h reads ((a₀, x₀), r₀) t).2 =
        (Pace.paced f h reads ((a₀, x_big), r₀) t).2) ∧
    ∃ T, T ≤ n ∧ (Pace.paced f h reads ((a₀, x₀), r₀) T).1.2 < H_safe + y_safe ∧
      (∀ k, (StockFlowBridge.unitWeb (fun t => (Pace.paced f h reads ((a₀, x₀), r₀) t).1.2)).level
        (T + k) () < H_safe + y_safe) ∧
      (∃ M, (Pace.paced f h reads ((a₀, x₀), r₀) M).1.2 = 0 ∧
        ∀ j, (Pace.paced f h reads ((a₀, x₀), r₀) (M + j)).1.2 = 0) := by
  let x := fun t => (Pace.paced f h reads ((a₀, x₀), r₀) t).1.2
  let d := fun t => jointDraw (Pace.paced f h reads ((a₀, x₀), r₀) t).1.1
    (Pace.paced f h reads ((a₀, x₀), r₀) t).2
  have step_eq : ∀ t, x (t + 1) = RegimeMargin.step gSub (d t) (x t) := fun t => by
    show (Pace.paced f h reads ((a₀, x₀), r₀) (t + 1)).1.2 = _
    rw [Pace.paced_succ]
    cases reads t
    · exact x_step _ _ _
    · exact x_step _ _ _
  have alike : ∀ t, (Pace.paced f h reads ((a₀, x₀), r₀) t).1.1 =
      (Pace.paced f h reads ((a₀, x_big), r₀) t).1.1 ∧
      (Pace.paced f h reads ((a₀, x₀), r₀) t).2 =
        (Pace.paced f h reads ((a₀, x_big), r₀) t).2 :=
    fun t => ClosedCapture.unread_course (c := ((a₀, x₀), r₀)) (c' := ((a₀, x_big), r₀))
      unread reads rfl rfl t
  obtain ⟨T, hTn, hTlt⟩ :=
    falls_within_ge step_eq most nothing (Nat.le_of_lt over) draw_ge hPos n within
  obtain ⟨hStay, M, hMzero, hMstay⟩ :=
    short_stays_below_ge step_eq short nothing (fun t _ => Nat.le_trans hSafeLe (draw_ge t)) hTlt
  exact ⟨alike, T, hTn, hTlt, hStay, M, hMzero, hMstay⟩

/-- **Hook 4b (`epistemic_silence_cascade`)**: sequential oversight cascade (`Turns.ReadsOnlyActsFrom k`)
collapses distinction above `H_safe + y_safe` (`Turns.acts_alike_of_cascade`), forcing every
transcript-reading selector onto `H_pre ≤ draw` and collapsing the substrate even when the true
underlying `B_task` lies well above `H_safe + y_safe`. -/
theorem epistemic_silence_cascade
    {O A P : Type} (T : Turns Nat O A) {k N Y H_pre H_safe y_safe : Nat}
    (cascade : T.ReadsOnlyActsFrom k)
    (masked : ∀ j, j < k → ∀ x y, H_safe + y_safe ≤ x → H_safe + y_safe ≤ y →
      T.coupling j x = T.coupling j y)
    (sel : List A → P) (draw : P → Nat)
    (g : Nat → Nat)
    (x_big : Nat) (big_ge : H_safe + y_safe ≤ x_big)
    (picks_pre_at_big : H_pre ≤ draw (sel (T.acts x_big N)))
    (most : RegimeMargin.AtMost g Y) (over : Y < H_pre)
    (short : RegimeMargin.Short g H_safe y_safe)
    (nothing : RegimeMargin.FromNothing g) (hPos : 0 < H_safe + y_safe)
    (x : Nat → Nat)
    (step_eq : ∀ t, x (t + 1) = RegimeMargin.step g (draw (sel (T.acts (x t) N))) (x t))
    (n : Nat) (within : x 0 < (H_safe + y_safe) + (H_pre - Y) * n) :
    (∀ lv, H_safe + y_safe ≤ lv → T.acts lv N = T.acts x_big N ∧ H_pre ≤ draw (sel (T.acts lv N))) ∧
    ∃ T₀, T₀ ≤ n ∧ x T₀ < H_safe + y_safe ∧
      ((∀ t, T₀ ≤ t → H_safe ≤ draw (sel (T.acts (x t) N))) →
        (∀ m, (StockFlowBridge.unitWeb x).level (T₀ + m) () < H_safe + y_safe) ∧
        (∃ M, x M = 0 ∧ ∀ j, x (M + j) = 0)) ∧
      (RegimeMargin.Gated g (H_safe + y_safe) → ∀ m, x (T₀ + m) < H_safe + y_safe) := by
  have actsAlike : ∀ lv, H_safe + y_safe ≤ lv →
      T.acts lv N = T.acts x_big N ∧ H_pre ≤ draw (sel (T.acts lv N)) := fun lv hLv =>
    have alike : T.acts lv N = T.acts x_big N :=
      Turns.acts_alike_of_cascade cascade (fun j hj => masked j hj lv x_big hLv big_ge) N
    ⟨alike, alike ▸ picks_pre_at_big⟩
  have res := epistemic_silence_late_bottleneck
    (S := Unit) (Obs := Nat) (P := P)
    (fun _ _ => ()) (fun _ lv => lv) (fun _ lv => sel (T.acts lv N)) draw
    g (B_task := H_safe + y_safe) (Y := Y) (H_pre := H_pre) (H_safe := H_safe) (y_safe := y_safe)
    (fun _ => True) (fun lv => lv < H_safe + y_safe)
    () trivial (fun _ _ _ => trivial)
    (Nat.le_refl _)
    (fun _ lv _ hB => Nat.not_lt_of_ge hB)
    (fun _ lv _ hNot => (actsAlike lv (Nat.ge_of_not_lt hNot)).2)
    most over short nothing hPos x (fun _ => ()) rfl (fun _ => rfl) step_eq n within
  exact ⟨actsAlike, res.2⟩

/-- **Twin freedom under read-only-abundant evaluation (`Learning.twin_selected`)**: evaluations
confined to read states `R` leave a selected twin free to take any extractive act on any unread
depleted level `x_low` not lumped with any read state. -/
theorem cascade_twin_free
    {K V : Type} (π : Nat → K) (R : Nat → Prop) (x_low : Nat)
    [∀ i, Decidable (π i = π x_low)]
    (unseen : ∀ d, R d → π d ≠ π x_low)
    {select : (Nat → V) → Prop}
    (through : Learning.Training.Through (Learning.Training.AgreeOn R) select)
    {actLaw : Nat → V} (lumped : Learning.Lumped π actLaw) (chosen : select actLaw) (v_ext : V) :
    ∃ h, Learning.Lumped π h ∧ select h ∧ Learning.Training.AgreeOn R h actLaw ∧ h x_low = v_ext :=
  Learning.twin_selected unseen through lumped chosen v_ext

/-! ## 6. Concrete Unified Non-Degenerate Witness (`TurningWitness`, >3 steps) -/

namespace TurningWitness

inductive TurnPolicy where
  | safe
  | ext

def turnDraw : TurnPolicy → Nat
  | .safe => 4
  | .ext => 6

def turnUpkeep : TurnPolicy → Nat
  | .safe => 10
  | .ext => 17

/-- Shared saturating substrate (`Keeps 0 50` holds cleanly at `z ≤ 46`). -/
abbrev wGivingCap : Nat → Nat := PartAWitness.wGivingCap

def timelyModel : ServiceTaskModel TurnPolicy where
  gain := 2
  gain_pos := by decide
  demand := fun p => match p with | .safe => 18 | .ext => 26
  upkeep := turnUpkeep
  draw := turnDraw
  safe := .safe
  ext := .ext
  demand_lt := by decide
  upkeep_lt := by decide
  ext_viable_at_full := by decide

def lateModel : ServiceTaskModel TurnPolicy where
  gain := 2
  gain_pos := by decide
  demand := fun p => match p with | .safe => 4 | .ext => 14
  upkeep := turnUpkeep
  draw := turnDraw
  safe := .safe
  ext := .ext
  demand_lt := by decide
  upkeep_lt := by decide
  ext_viable_at_full := by decide

theorem timelyModel_B_task : timelyModel.B_task = 22 := rfl

theorem lateModel_B_task : lateModel.B_task = 8 := rfl

def timelySys : EndogenousSystem (Bool × Nat) Nat :=
  EndogenousSystem.ofServiceTask timelyModel wGivingCap 20

def timelyOrbit : Nat → Nat × (Bool × Nat) :=
  Law.orbit timelySys.step (27, (true, 1))

/-- **Hook 4c (`TurningWitness.timely_survives`)**: exact trace `27 → 25 → 23 → 21 → 19 → 19`,
turning with `lag = 1` from `B_task = 22 > 21`, permanently viable inside `[9, 50]`. -/
theorem timely_survives :
    timelyModel.B_task = 22 ∧
    (timelyOrbit 0).1 = 27 ∧ (timelyOrbit 1).1 = 25 ∧ (timelyOrbit 2).1 = 23 ∧
    (timelyOrbit 3).1 = 21 ∧ (timelyOrbit 4).1 = 19 ∧ (timelyOrbit 5).1 = 19 ∧
    (timelyOrbit 4).2 = (false, 0) ∧
    Viability.Kernel (Law.process timelySys.step)
      (fun st => 9 ≤ st.1 ∧ st.1 ≤ 50 ∧ serviceK 1 st.2) (27, (true, 1)) ∧
    (∀ t, 9 ≤ (timelyOrbit t).1 ∧ (timelyOrbit t).1 ≤ 50) := by
  have v := ofServiceTask_viable timelyModel wGivingCap (base := 20) (H_safe := 4) (y_safe := 5)
    (lag := 1) (hi := 50) 27 (true, 1) (by decide)
    ⟨Nat.le_refl 1, fun _ => Nat.succ_pos 0, fun h => Bool.noConfusion h⟩
    (Nat.le_refl 4)
    PartAWitness.wGivingCap_meets PartAWitness.wGivingCap_keeps
    (by decide) (by decide) (by decide) (by decide)
  exact ⟨rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, v.1, v.2⟩

/-- Zero-lag optimal responder for `lateModel`. -/
def lateRespond (_ : Unit) (sc : Nat) : TurnPolicy :=
  if sc < lateModel.nominalSafe 20 then .safe else .ext

def lateOrbit : Nat → Nat :=
  Law.orbit
    (fun x => RegimeMargin.step wGivingCap (turnDraw (lateRespond () (lateModel.realizedScore .ext x 20))) x)
    27

theorem late_step_eq (t : Nat) :
    lateOrbit (t + 1) =
      RegimeMargin.step wGivingCap
        (turnDraw (lateRespond () (lateModel.realizedScore .ext (lateOrbit t) 20)))
        (lateOrbit t) := rfl

/-- **Hook 4c (`TurningWitness.late_collapses`)**: `B_task = 8 ≤ 9 = S_noReturn` even though
`demand ext = 14 > 9`. Exact trace `27 → 25 → 23 → 21 → 19 → 17 → 15 → 13 → 11 → 9 → 3 → 0`,
plus universal collapse for ANY responder keeping `.ext` while `¬ (sc < nominalSafe)`. -/
theorem late_collapses :
    lateModel.B_task = 8 ∧
    lateOrbit 0 = 27 ∧ lateOrbit 1 = 25 ∧ lateOrbit 2 = 23 ∧ lateOrbit 3 = 21 ∧
    lateOrbit 4 = 19 ∧ lateOrbit 5 = 17 ∧ lateOrbit 6 = 15 ∧ lateOrbit 7 = 13 ∧
    lateOrbit 8 = 11 ∧ lateOrbit 9 = 9 ∧ lateOrbit 10 = 3 ∧ lateOrbit 11 = 0 ∧
    (∃ T, T ≤ 10 ∧ lateOrbit T < 9 ∧
      (∀ k, (StockFlowBridge.unitWeb lateOrbit).level (T + k) () < 9) ∧
      (∃ M, lateOrbit M = 0 ∧ ∀ j, lateOrbit (M + j) = 0)) ∧
    (∀ (S : Type) (next : S → Nat → S) (respond : S → Nat → TurnPolicy)
        (K : S → Prop) (init : S) (x : Nat → Nat) (s : Nat → S),
      K init → (∀ st sc, K st → K (next st sc)) →
      (∀ st sc, K st → ¬ (sc < lateModel.nominalSafe 20) → 6 ≤ turnDraw (respond st sc)) →
      s 0 = init → (∀ t, s (t + 1) = next (s t) (lateModel.realizedScore .ext (x t) 20)) →
      (∀ t, x (t + 1) =
        RegimeMargin.step wGivingCap (turnDraw (respond (s t) (lateModel.realizedScore .ext (x t) 20))) (x t)) →
      x 0 = 27 →
      ∃ T, T ≤ 10 ∧ x T < 9 ∧
        ((∀ t, T ≤ t → 4 ≤ turnDraw (respond (s t) (lateModel.realizedScore .ext (x t) 20))) →
          (∀ k, (StockFlowBridge.unitWeb x).level (T + k) () < 9) ∧
          (∃ M, x M = 0 ∧ ∀ j, x (M + j) = 0))) := by
  have sil := epistemic_silence_late_bottleneck
    (S := Unit) (Obs := Nat) (P := TurnPolicy)
    (fun _ _ => ()) (fun _ lv => lateModel.realizedScore .ext lv 20) lateRespond turnDraw
    wGivingCap (B_task := 8) (Y := 4) (H_pre := 6) (H_safe := 4) (y_safe := 5)
    (fun _ => True) (· < lateModel.nominalSafe 20) () trivial (fun _ _ _ => trivial)
    (by decide)
    (fun _ lv _ hB => fun lt =>
      Nat.not_le_of_gt (((lateModel.score_crosses_iff lv 20).2 (by decide)).mp lt) hB)
    (fun _ sc _ hNot => by
      show 6 ≤ turnDraw (if sc < lateModel.nominalSafe 20 then .safe else .ext)
      rw [if_neg hNot]
      exact by decide)
    PartAWitness.wGivingCap_atMost (by decide) PartAWitness.wGivingCap_short
    PartAWitness.wGivingCap_fromNothing (by decide)
    lateOrbit (fun _ => ()) rfl (fun _ => rfl) late_step_eq 10 (by decide)
  obtain ⟨T, hTn, hTlt, hPost, _⟩ := sil.2
  have univ : ∀ (S : Type) (next : S → Nat → S) (respond : S → Nat → TurnPolicy)
      (K : S → Prop) (init : S) (x : Nat → Nat) (s : Nat → S),
      K init → (∀ st sc, K st → K (next st sc)) →
      (∀ st sc, K st → ¬ (sc < lateModel.nominalSafe 20) → 6 ≤ turnDraw (respond st sc)) →
      s 0 = init → (∀ t, s (t + 1) = next (s t) (lateModel.realizedScore .ext (x t) 20)) →
      (∀ t, x (t + 1) =
        RegimeMargin.step wGivingCap (turnDraw (respond (s t) (lateModel.realizedScore .ext (x t) 20))) (x t)) →
      x 0 = 27 →
      ∃ T, T ≤ 10 ∧ x T < 9 ∧
        ((∀ t, T ≤ t → 4 ≤ turnDraw (respond (s t) (lateModel.realizedScore .ext (x t) 20))) →
          (∀ k, (StockFlowBridge.unitWeb x).level (T + k) () < 9) ∧
          (∃ M, x M = 0 ∧ ∀ j, x (M + j) = 0)) := by
    intro S next respond K init x s hInit hK hPre hs0 hss hxs hx0
    have u := epistemic_silence_late_bottleneck
      next (fun _ lv => lateModel.realizedScore .ext lv 20) respond turnDraw
      wGivingCap (B_task := 8) (Y := 4) (H_pre := 6) (H_safe := 4) (y_safe := 5)
      K (· < lateModel.nominalSafe 20) init hInit hK (by decide)
      (fun _ lv _ hB => fun lt =>
        Nat.not_le_of_gt (((lateModel.score_crosses_iff lv 20).2 (by decide)).mp lt) hB)
      hPre PartAWitness.wGivingCap_atMost (by decide) PartAWitness.wGivingCap_short
      PartAWitness.wGivingCap_fromNothing (by decide)
      x s hs0 hss hxs 10 (hx0 ▸ (by decide : 27 < 9 + (6 - 4) * 10))
    obtain ⟨T', hTn', hTlt', hPost', _⟩ := u.2
    exact ⟨T', hTn', hTlt', hPost'⟩
  exact ⟨rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl,
    ⟨T, hTn, hTlt, hPost (fun _ _ => by
      cases Nat.decLt (lateModel.realizedScore .ext (lateOrbit _) 20) (lateModel.nominalSafe 20) with
      | isTrue lt => rw [lateRespond, if_pos lt]; exact by decide
      | isFalse nlt => rw [lateRespond, if_neg nlt]; exact by decide)⟩,
    univ⟩

/-- 3-stage `Turns.Copying` cascade whose stage-0 reading saturates at `40` for all `x ≥ 9`
(fixing the stage-0 mask across `[9, ∞)`). -/
def cascadeTurns : Turns Nat Nat Nat :=
  Turns.Copying.turns (fun _ x => if 9 ≤ x then 40 else x) 0

def cascadeSel (xs : List Nat) : TurnPolicy :=
  match xs with
  | [] => .safe
  | o :: _ => if timelyModel.realizedScore .ext o 20 < timelyModel.nominalSafe 20 then .safe else .ext

def cascadeOrbit : Nat → Nat :=
  Law.orbit
    (fun x => RegimeMargin.step wGivingCap (turnDraw (cascadeSel (cascadeTurns.acts x 3))) x)
    27

theorem cascade_step_eq (t : Nat) :
    cascadeOrbit (t + 1) =
      RegimeMargin.step wGivingCap (turnDraw (cascadeSel (cascadeTurns.acts (cascadeOrbit t) 3)))
        (cascadeOrbit t) := rfl

/-- **Hook 4c (`TurningWitness.cascade_collapses`)**: even with timely `timelyModel` (`B_task = 22 > 21`),
the 3-stage copying cascade identifies all `x ≥ 9` with `acts 40 3 = [40, 40, 40]` and reproduces
the exact 11-step collapse `27 → 25 → ... → 9 → 3 → 0`. -/
theorem cascade_collapses :
    timelyModel.B_task = 22 ∧
    (∀ x, 9 ≤ x → cascadeTurns.acts x 3 = [40, 40, 40]) ∧
    cascadeOrbit 0 = 27 ∧ cascadeOrbit 1 = 25 ∧ cascadeOrbit 2 = 23 ∧ cascadeOrbit 3 = 21 ∧
    cascadeOrbit 4 = 19 ∧ cascadeOrbit 5 = 17 ∧ cascadeOrbit 6 = 15 ∧ cascadeOrbit 7 = 13 ∧
    cascadeOrbit 8 = 11 ∧ cascadeOrbit 9 = 9 ∧ cascadeOrbit 10 = 3 ∧ cascadeOrbit 11 = 0 ∧
    ∃ T₀, T₀ ≤ 10 ∧ cascadeOrbit T₀ < 9 ∧
      (∀ m, (StockFlowBridge.unitWeb cascadeOrbit).level (T₀ + m) () < 9) ∧
      (∃ M, cascadeOrbit M = 0 ∧ ∀ j, cascadeOrbit (M + j) = 0) := by
  have actsConst : ∀ x, 9 ≤ x → cascadeTurns.acts x 3 = [40, 40, 40] := fun x hx => by
    have eq1 : cascadeTurns.acts x 3 = cascadeTurns.acts 40 3 :=
      Turns.acts_alike_of_cascade (Turns.Copying.readsOnlyActs _ 0)
        (fun j hj => by
          cases j with
          | zero => show (if 9 ≤ x then 40 else x) = 40; rw [if_pos hx]
          | succ j' => exact absurd (Nat.lt_of_succ_lt_succ hj) (Nat.not_lt_zero _)) 3
    exact eq1.trans rfl
  have cas := epistemic_silence_cascade cascadeTurns (Turns.Copying.readsOnlyActs _ 0)
    (fun j hj x y hx hy => by
      cases j with
      | zero => show (if 9 ≤ x then 40 else x) = (if 9 ≤ y then 40 else y); rw [if_pos hx, if_pos hy]
      | succ j' => exact absurd (Nat.lt_of_succ_lt_succ hj) (Nat.not_lt_zero _))
    cascadeSel turnDraw wGivingCap (Y := 4) (H_pre := 6) (H_safe := 4) (y_safe := 5)
    40 (by decide) (by decide)
    PartAWitness.wGivingCap_atMost (by decide) PartAWitness.wGivingCap_short
    PartAWitness.wGivingCap_fromNothing (by decide)
    cascadeOrbit cascade_step_eq 10 (by decide)
  obtain ⟨T₀, hTn, hTlt, hPost, _⟩ := cas.2
  exact ⟨rfl, actsConst, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl,
    T₀, hTn, hTlt, hPost (fun t _ => by
      cases cascadeTurns.acts (cascadeOrbit t) 3 with
      | nil => exact by decide
      | cons o _ =>
        cases Nat.decLt (timelyModel.realizedScore .ext o 20) (timelyModel.nominalSafe 20) with
        | isTrue lt => rw [cascadeSel, if_pos lt]; exact by decide
        | isFalse nlt => rw [cascadeSel, if_neg nlt]; exact by decide)⟩

end TurningWitness

/-! ## 7. Native `L0` (`Becoming.OpenComposition`) Composition, Live Rewrite, & Blindness Bridge -/

namespace OpenCompositionBridge

/-- Lift `PooledClearing.proxyLoop` into an `L0` `OpenComponent` (`Ext = Unit`, `Int = Empty`). -/
def proxyComponent (hProxyPre hProxySafe : Nat) :
    OpenComposition.OpenComponent Nat Unit Unit Empty Unit :=
  OpenComposition.OpenComponent.ofOpenLoop (PooledClearing.proxyLoop hProxyPre hProxySafe)

/-- Lift `PooledClearing.proxyCert` into an `L0` `InterfaceContract`. -/
def proxyContract (hProxyPre hProxySafe lagProxy : Nat) (safe_le : hProxySafe ≤ hProxyPre)
    (init : Nat) (initProxy : init ≤ lagProxy) :
    OpenComposition.InterfaceContract (proxyComponent hProxyPre hProxySafe) init :=
  OpenComposition.InterfaceContract.ofLoopCertificate
    (PooledClearing.proxyCert hProxyPre hProxySafe lagProxy safe_le init initProxy)

/-- Lift `PooledClearing.taskLoop` into an `L0` `OpenComponent` (`Ext = Unit`, `Int = Empty`). -/
def taskPartnerComponent {P : Type} (M : ServiceTaskModel P) (base : Nat) :
    OpenComposition.OpenComponent (Bool × Nat) Nat Unit Empty Unit :=
  OpenComposition.OpenComponent.ofOpenLoop (PooledClearing.taskLoop M base)

/-- Lift `PooledClearing.taskCert` into an `L0` `InterfaceContract`. -/
def taskPartnerContract {P : Type} (M : ServiceTaskModel P) (base lagPartner : Nat)
    (init : Bool × Nat) (initPartner : serviceK lagPartner init) :
    OpenComposition.InterfaceContract (taskPartnerComponent M base) init :=
  OpenComposition.InterfaceContract.ofLoopCertificate
    (PooledClearing.taskCert M base lagPartner init initPartner)

/-- **Composed `PooledClearing` over `L0`**: composes `proxyComponent` and `taskPartnerComponent`
via `OpenComponent.compose` and `composeContract`, closing directly via
`OpenComposition.compose_close_interchange` (zero duplicated certificate proof). -/
theorem pooled_clearing_open_compose_viable
    {P Env : Type} (M : ServiceTaskModel P) (base : Nat) (hBase : M.upkeep M.ext ≤ base)
    (hProxyPre hProxySafe lagProxy lagPartner : Nat) (safe_le : hProxySafe ≤ hProxyPre)
    (initProxy : Nat) (hInitProxy : initProxy ≤ lagProxy)
    (initPartner : Bool × Nat) (hInitPartner : serviceK lagPartner initPartner)
    (channel : Bool → Nat → Env → Bool)
    (G : Unit → (Unit → Nat) → Nat)
    (envDraw : Env → Unit → Nat) (envCap : Unit → Nat) (jointAdm : Env → Prop)
    (env_within : ∀ env, jointAdm env → ∀ k, envDraw env k ≤ envCap k)
    (x_crit H_safe x₀ : Unit → Nat)
    (channel_fires : ∀ load env, jointAdm env → load ≤ 0 → channel true load env = true)
    (G_rises : ∀ k, RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (G k))
    (post_viable : ∀ k, x_crit k ≤
      RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole G H_safe x_crit k)
    (post_safe : (hProxySafe + M.draw M.safe) + envCap () ≤ H_safe ())
    (task_margin : x_crit () + (AdaptiveLoops.natMax lagProxy lagPartner + 1) *
      ((hProxyPre + AdaptiveLoops.natMax (M.draw M.ext) (M.draw M.safe)) + envCap ()) ≤ M.B_task)
    (init_margin : x_crit () + AdaptiveLoops.natMax initProxy initPartner.2 *
      ((hProxyPre + AdaptiveLoops.natMax (M.draw M.ext) (M.draw M.safe)) + envCap ()) ≤ x₀ ()) :
    Viability.Kernel
      (OpenComposition.closedProcess
        (OpenComposition.OpenComponent.compose
          (proxyComponent hProxyPre hProxySafe)
          (taskPartnerComponent M base))
        (OpenComposition.composeContract
          (proxyContract hProxyPre hProxySafe lagProxy safe_le initProxy hInitProxy)
          (taskPartnerContract M base lagPartner initPartner hInitPartner))
        (fun x => ((), M.realizedScore M.ext (x ()) base))
        channel G envDraw jointAdm)
      (OpenComposition.closedGuard
        (OpenComposition.OpenComponent.compose
          (proxyComponent hProxyPre hProxySafe)
          (taskPartnerComponent M base))
        (OpenComposition.composeContract
          (proxyContract hProxyPre hProxySafe lagProxy safe_le initProxy hInitProxy)
          (taskPartnerContract M base lagPartner initPartner hInitPartner))
        x_crit)
      (x₀, (initProxy, initPartner)) := by
  refine OpenComposition.compose_close_interchange
    (proxyComponent hProxyPre hProxySafe)
    (taskPartnerComponent M base)
    (proxyContract hProxyPre hProxySafe lagProxy safe_le initProxy hInitProxy)
    (taskPartnerContract M base lagPartner initPartner hInitPartner)
    (fun _ => ())
    (fun x => M.realizedScore M.ext (x ()) base)
    channel G envDraw envCap jointAdm env_within
    x_crit (fun _ => M.B_task) H_safe x₀
    (fun x k lt => by
      cases k
      exact Or.inr (((M.score_crosses_iff (x ()) base).2 hBase).mpr lt))
    (fun load env adm le => channel_fires load env adm le)
    G_rises post_viable
    (fun k => by cases k; exact post_safe)
    (fun k => by cases k; exact task_margin)
    (fun k => by cases k; exact init_margin)

/-- **Live mid-run clearing-partner swap (`clearing_partner_reconfig_viable`)**: swaps an
already-coupled `ServiceTaskModel` clearing partner `taskPartnerComponent M₁ base₁` (satisfying
`obs_detects₁` via `M₁.score_crosses_iff`) mid-run inside `OpenComposition.ReconfigProcess` to
any structurally heterogeneous upgraded clearing system `A'` (`S₁'`, `Int₁'`, `Obs₁'`, `Dist₁'`)
satisfying boundary tightening and `obs_detects₂`, preserving `Viability.Kernel` across any
reconfiguration timing via `OpenComposition.rewrite_step_viable`. -/
theorem clearing_partner_reconfig_viable
    {P₁ S₁' Obs₁' Dist₁' Int₁' Env : Type}
    (M₁ : ServiceTaskModel P₁) (base₁ : Nat) (hBase₁ : M₁.upkeep M₁.ext ≤ base₁)
    (lag₁ : Nat) (init₁ : Bool × Nat) (hInit₁ : serviceK lag₁ init₁)
    (A' : OpenComposition.OpenComponent S₁' Obs₁' Dist₁' Int₁' Unit)
    {init₁' : S₁'}
    (cA' : OpenComposition.InterfaceContract A' init₁')
    (obs₁' : (Unit → Nat) → Obs₁')
    (channel : Bool → Nat → Env → Bool)
    (G : Unit → (Unit → Nat) → Nat)
    (envDraw : Env → Unit → Nat) (envCap : Unit → Nat) (jointAdm : Env → Prop)
    (env_within : ∀ env, jointAdm env → ∀ k, envDraw env k ≤ envCap k)
    (x_crit H_safe x₀ : Unit → Nat)
    (cap_le : cA'.preCapExt () ≤ AdaptiveLoops.natMax (M₁.draw M₁.ext) (M₁.draw M₁.safe))
    (post_le : cA'.postBudgetExt () ≤ M₁.draw M₁.safe)
    (sil_le : cA'.maxSilence ≤ 0)
    (lag_le : cA'.maxLag ≤ lag₁)
    (obs_detects₂ : ∀ x, x () < M₁.B_task → cA'.warnObs (obs₁' x))
    (channel_fires : ∀ load env, jointAdm env → load ≤ 0 → channel true load env = true)
    (G_rises : ∀ k, RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (G k))
    (post_viable : ∀ k, x_crit k ≤
      RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole G H_safe x_crit k)
    (post_safe : M₁.draw M₁.safe + envCap () ≤ H_safe ())
    (task_margin : x_crit () + (lag₁ + 1) *
      (AdaptiveLoops.natMax (M₁.draw M₁.ext) (M₁.draw M₁.safe) + envCap ()) ≤ M₁.B_task)
    (init_margin : x_crit () + init₁.2 *
      (AdaptiveLoops.natMax (M₁.draw M₁.ext) (M₁.draw M₁.safe) + envCap ()) ≤ x₀ ()) :
    Viability.Kernel
      (OpenComposition.ReconfigProcess
        (taskPartnerComponent M₁ base₁) A'
        (taskPartnerContract M₁ base₁ lag₁ init₁ hInit₁) cA'
        (fun x => M₁.realizedScore M₁.ext (x ()) base₁) obs₁'
        channel G envDraw jointAdm)
      (fun st => match st with
        | .inl st₁ => OpenComposition.closedGuard
            (taskPartnerComponent M₁ base₁)
            (taskPartnerContract M₁ base₁ lag₁ init₁ hInit₁) x_crit st₁
        | .inr st₂ => OpenComposition.closedGuard A' cA' x_crit st₂)
      (.inl (x₀, init₁)) := by
  have kern := OpenComposition.rewrite_step_viable
    (taskPartnerComponent M₁ base₁) A'
    (taskPartnerContract M₁ base₁ lag₁ init₁ hInit₁) cA'
    (fun x => M₁.realizedScore M₁.ext (x ()) base₁) obs₁'
    channel G envDraw envCap jointAdm env_within
    x_crit (fun _ => M₁.B_task) H_safe x₀
    (fun k => by cases k; exact cap_le)
    (fun k => by cases k; exact post_le)
    sil_le lag_le
    (fun x k lt => by cases k; exact ((M₁.score_crosses_iff (x ()) base₁).2 hBase₁).mpr lt)
    (fun x k lt => by cases k; exact obs_detects₂ x lt)
    (fun load env adm le => channel_fires load env adm le)
    G_rises post_viable
    (fun k => by cases k; exact post_safe)
    (fun k => by cases k; exact task_margin)
    (fun k => by cases k; exact init_margin)
  intro st hReach
  have hSt := kern st hReach
  cases st with
  | inl st₁ => exact hSt
  | inr st₂ => exact hSt

/- Concrete non-vacuous witness of a live mid-run heterogeneous partner rewrite: swaps
`taskPartnerComponent TurningWitness.timelyModel 20` (`Bool × Nat`, `B_task = 22`, draw `6 → 4`)
mid-run at step `2` for composed `proxyComponent 1 1 ⊕ taskPartnerComponent upgradedModel 20`
(`Nat × (Bool × Nat)`, `B_task = 23`, draw `5 → 3`, `S₁ ≠ S₁'`, `Int₁ ≠ Int₁'`), maintaining
substrate viability `9 ≤ x` along the concrete 5-step trace `27 → 25 → 23 → 23 → 22 → 21` (with step 6 recovering to `22`). -/
namespace ReconfigWitness

def turningCap (z : Nat) : Nat :=
  if 5 ≤ z then 4 else 0

theorem turningCap_rises :
    ∀ _ : Unit, RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (fun e => turningCap (e ())) :=
  fun _ e₁ _ below =>
    match Nat.decLe 5 (e₁ ()) with
    | isTrue h => Nat.le_trans (Nat.le_of_eq (if_pos h))
        (Nat.le_of_eq (if_pos (Nat.le_trans h (below ()))).symm)
    | isFalse h => Nat.le_trans (Nat.le_of_eq (if_neg h)) (Nat.zero_le _)

theorem turningCap_atMost : RegimeMargin.AtMost turningCap 4 := fun z => by
  cases Nat.decLe 5 z with
  | isTrue h => rw [turningCap, if_pos h]; exact Nat.le_refl 4
  | isFalse h => rw [turningCap, if_neg h]; exact Nat.zero_le 4

theorem turningCap_short : RegimeMargin.Short turningCap 4 5 := fun z hz => by
  have nh5 : ¬ 5 ≤ z := Nat.not_le_of_gt hz
  rw [turningCap, if_neg nh5]
  exact by decide

theorem turningCap_fromNothing : RegimeMargin.FromNothing turningCap := rfl

def upgradedUpkeep : TurningWitness.TurnPolicy → Nat
  | .safe => 10
  | .ext => 15

def upgradedModel : ServiceTaskModel TurningWitness.TurnPolicy where
  gain := 2
  gain_pos := by decide
  demand := fun p => match p with | .safe => 20 | .ext => 26
  upkeep := upgradedUpkeep
  draw := fun p => match p with | .safe => 2 | .ext => 4
  safe := .safe
  ext := .ext
  demand_lt := by decide
  upkeep_lt := by decide
  ext_viable_at_full := by decide

theorem upgradedModel_B_task : upgradedModel.B_task = 23 := rfl

def leftPartner := taskPartnerComponent TurningWitness.timelyModel 20

def leftInit : Bool × Nat := (true, 1)

def leftInit_in : serviceK 1 leftInit :=
  ⟨Nat.le_refl 1, fun _ => Nat.succ_pos 0, fun h => Bool.noConfusion h⟩

def leftContract := taskPartnerContract TurningWitness.timelyModel 20 1 leftInit leftInit_in

def rightSystem : OpenComposition.OpenComponent (Nat × (Bool × Nat)) (Unit × Nat) (Unit × Unit) (Sum Empty Empty) Unit :=
  OpenComposition.OpenComponent.compose (proxyComponent 1 1) (taskPartnerComponent upgradedModel 20)

def rightInit : Nat × (Bool × Nat) := (0, (true, 1))

def rightContract : OpenComposition.InterfaceContract rightSystem rightInit :=
  OpenComposition.composeContract
    (proxyContract 1 1 0 (Nat.le_refl 1) 0 (Nat.le_refl 0))
    (taskPartnerContract upgradedModel 20 1 (true, 1) leftInit_in)

def leftObs (x : Unit → Nat) : Nat :=
  TurningWitness.timelyModel.realizedScore .ext (x ()) 20

def rightObs (x : Unit → Nat) : Unit × Nat :=
  ((), upgradedModel.realizedScore .ext (x ()) 20)

def syncChannel (em : Bool) (load : Nat) (_ : Unit) : Bool :=
  em && Nat.ble load 0

def witnessG (_ : Unit) (e : Unit → Nat) : Nat :=
  turningCap (e ())

def reconfigProc :
    Process
      (Sum ((Unit → Nat) × (Bool × Nat)) ((Unit → Nat) × (Nat × (Bool × Nat))))
      (OpenComposition.ReconfigAct Unit Unit (Unit × Unit) (Nat × (Bool × Nat))) :=
  OpenComposition.ReconfigProcess
    leftPartner rightSystem leftContract rightContract leftObs rightObs
    syncChannel witnessG (fun _ _ => 0) (fun _ => True)

def reconfigState :
    Nat → Sum ((Unit → Nat) × (Bool × Nat)) ((Unit → Nat) × (Nat × (Bool × Nat)))
  | 0 => .inl (fun _ => 27, (true, 1))
  | t + 1 =>
    match t with
    | 2 =>
      match reconfigState 2 with
      | .inl st₁ => .inr (st₁.1, rightInit)
      | .inr st₂ => .inr st₂
    | k =>
      match reconfigState k with
      | .inl st₁ => .inl (OpenComposition.closedStep leftPartner leftObs syncChannel witnessG (fun _ _ => 0) st₁ ((), ()))
      | .inr st₂ => .inr (OpenComposition.closedStep rightSystem rightObs syncChannel witnessG (fun _ _ => 0) st₂ ((), ((), ())))

def reconfigAct :
    Nat → OpenComposition.ReconfigAct Unit Unit (Unit × Unit) (Nat × (Bool × Nat))
  | 0 => .stepLeft () ()
  | 1 => .stepLeft () ()
  | 2 => .reconfig rightInit
  | _ + 3 => .stepRight () ((), ())

theorem reconfigState_inr :
    ∀ k, ∃ st₂, reconfigState (k + 3) = .inr st₂
  | 0 => by
    cases h2 : reconfigState 2 with
    | inl st₁ =>
      refine ⟨(st₁.1, rightInit), ?_⟩
      change (match reconfigState 2 with
        | Sum.inl st₁ => Sum.inr (st₁.1, rightInit)
        | Sum.inr st₂ => Sum.inr st₂) = Sum.inr (st₁.1, rightInit)
      rw [h2]
    | inr st₂ =>
      refine ⟨st₂, ?_⟩
      change (match reconfigState 2 with
        | Sum.inl st₁ => Sum.inr (st₁.1, rightInit)
        | Sum.inr st₂ => Sum.inr st₂) = Sum.inr st₂
      rw [h2]
  | k + 1 => by
    obtain ⟨st₂, hEq⟩ := reconfigState_inr k
    refine ⟨OpenComposition.closedStep rightSystem rightObs syncChannel witnessG (fun _ _ => 0) st₂ ((), ((), ())), ?_⟩
    change (match reconfigState (k + 3) with
      | Sum.inl st₁ => Sum.inl (OpenComposition.closedStep leftPartner leftObs syncChannel witnessG (fun _ _ => 0) st₁ ((), ()))
      | Sum.inr st₂ => Sum.inr (OpenComposition.closedStep rightSystem rightObs syncChannel witnessG (fun _ _ => 0) st₂ ((), ((), ())))) = _
    rw [hEq]

def reconfigRun : Run reconfigProc where
  state := reconfigState
  act := reconfigAct
  step t := by
    cases t with
    | zero => exact ⟨trivial, fun _ => trivial, rfl⟩
    | succ t =>
      cases t with
      | zero => exact ⟨trivial, fun _ => trivial, rfl⟩
      | succ t =>
        cases t with
        | zero =>
          exact ⟨⟨Nat.le_refl 0, leftInit_in⟩, Nat.le_refl 1, rfl⟩
        | succ k =>
          obtain ⟨st₂, hEq⟩ := reconfigState_inr k
          show reconfigProc.step (reconfigState (k + 3)) (.stepRight () ((), ())) (reconfigState (k + 4))
          rw [hEq]
          exact ⟨trivial, fun _ => ⟨trivial, trivial⟩, by
            change (match reconfigState (k + 3) with
              | Sum.inl st₁ => Sum.inl (OpenComposition.closedStep leftPartner leftObs syncChannel witnessG (fun _ _ => 0) st₁ ((), ()))
              | Sum.inr st₂ => Sum.inr (OpenComposition.closedStep rightSystem rightObs syncChannel witnessG (fun _ _ => 0) st₂ ((), ((), ())))) = _
            rw [hEq]⟩

def reconfigLevel (t : Nat) : Nat :=
  match reconfigState t with
  | .inl st₁ => st₁.1 ()
  | .inr st₂ => st₂.1 ()

theorem reconfig_witness_viable :
    upgradedModel.B_task = 23 ∧
    reconfigLevel 0 = 27 ∧ reconfigLevel 1 = 25 ∧ reconfigLevel 2 = 23 ∧
    reconfigLevel 3 = 23 ∧ reconfigLevel 4 = 22 ∧ reconfigLevel 5 = 21 ∧
    (∃ st₁, reconfigState 2 = .inl st₁ ∧ st₁.1 () = 23 ∧ st₁.2 = (true, 1)) ∧
    (∃ st₂, reconfigState 3 = .inr st₂ ∧ st₂.1 () = 23 ∧ st₂.2 = (0, (true, 1))) ∧
    (∃ st₂, reconfigState 5 = .inr st₂ ∧ st₂.1 () = 21 ∧ st₂.2 = (0, (false, 0))) ∧
    Viability.Kernel
      reconfigProc
      (fun st => match st with
        | .inl st₁ => OpenComposition.closedGuard leftPartner leftContract (fun _ => 9) st₁
        | .inr st₂ => OpenComposition.closedGuard rightSystem rightContract (fun _ => 9) st₂)
      (.inl (fun _ => 27, leftInit)) ∧
    (∀ t, 9 ≤ reconfigLevel t) := by
  have kern :
      Viability.Kernel
        reconfigProc
        (fun st => match st with
          | .inl st₁ => OpenComposition.closedGuard leftPartner leftContract (fun _ => 9) st₁
          | .inr st₂ => OpenComposition.closedGuard rightSystem rightContract (fun _ => 9) st₂)
        (.inl (fun _ => 27, leftInit)) := by
    refine ?_
    have kern' := clearing_partner_reconfig_viable
      TurningWitness.timelyModel 20 (by decide) 1 leftInit leftInit_in
      rightSystem rightContract rightObs
      syncChannel witnessG (fun _ _ => 0) (fun _ => 0) (fun _ => True)
      (fun _ _ _ => Nat.zero_le 0)
      (fun _ => 9) (fun _ => 4) (fun _ => 27)
      (by decide) (by decide) (Nat.le_refl 0) (by decide)
      (fun x lt => Or.inr (((upgradedModel.score_crosses_iff (x ()) 20).2 (by decide)).mpr
        (Nat.lt_trans lt (by decide : TurningWitness.timelyModel.B_task < upgradedModel.B_task))))
      (fun load _ _ le => by
        show (true && Nat.ble load 0) = true
        rw [Nat.ble_eq_true_of_le le]
        rfl)
      turningCap_rises
      (fun k => by cases k; exact by decide)
      (by decide) (by decide) (by decide)
    intro st hReach
    have hSt := kern' st hReach
    cases st with
    | inl st₁ => exact hSt
    | inr st₂ => exact hSt
  refine ⟨rfl, rfl, rfl, rfl, rfl, rfl, rfl,
    ⟨_, rfl, rfl, rfl⟩, ⟨_, rfl, rfl, rfl⟩, ⟨_, rfl, rfl, rfl⟩, kern, fun t => ?_⟩
  have hG := Viability.Kernel.run reconfigRun kern t
  change (match reconfigState t with
    | .inl st₁ => OpenComposition.closedGuard leftPartner leftContract (fun _ => 9) st₁
    | .inr st₂ => OpenComposition.closedGuard rightSystem rightContract (fun _ => 9) st₂) at hG
  show 9 ≤ match reconfigState t with | .inl st₁ => st₁.1 () | .inr st₂ => st₂.1 ()
  cases hSt : reconfigState t with
  | inl st₁ =>
    rw [hSt] at hG
    exact hG.1 ()
  | inr st₂ =>
    rw [hSt] at hG
    exact hG.1 ()

end ReconfigWitness

/-- **Blind-to-widened clearing contrast (`clearing_widening_heals_blindness`)**: on one
shared saturating substrate `g` and `ServiceTaskModel` `M`, contrasts:
1. Solo unpooled `proxyLoop` silence (`epistemic_silence_late_bottleneck`): collapses `< H_safe + y_safe`
   within `n` steps and hits `0` forever;
2. Disconnected unpooled clearing (`PooledClearing.unpooled_clearer_blind`): keeps `proxyAgent`
   identical across `x₀` and `x_big` and collapses `< H_safe + y_safe` and `= 0`;
3. Widened & alarm-coupled `OpenComposition` (`proxyComponent ⊕ taskPartnerComponent`): satisfies
   `Viability.Kernel` at `(x₀, (initProxy, initPartner))`, maintaining `H_safe + y_safe ≤ x ()` forever. -/
theorem clearing_widening_heals_blindness
    {P : Type} (M : ServiceTaskModel P) (base : Nat) (hBase : M.upkeep M.ext ≤ base)
    (hProxyPre hProxySafe lagProxy lagPartner : Nat) (safe_le : hProxySafe ≤ hProxyPre)
    (initProxy : Nat) (hInitProxy : initProxy ≤ lagProxy) (proxyFavours : 0 < initProxy)
    (initPartner : Bool × Nat) (hInitPartner : serviceK lagPartner initPartner)
    (g : Nat → Nat)
    (r1 r2 : Run
      (AdaptiveLoops.jointProcess (Env := Unit) PooledClearing.pooledAgents
        (PooledClearing.pooledOpenLoop M base hProxyPre hProxySafe)
        (PooledClearing.pooledCerts M base hProxyPre hProxySafe lagProxy lagPartner safe_le
          (fun i => match i with | .proxyAgent => initProxy | .taskPartner => initPartner)
          hInitProxy hInitPartner)
        (PooledClearing.pooledObs M base) (fun _ _ (_ : Unit) => false)
        (fun _ e => g (e ())) (fun _ _ => 0) (fun _ => True)))
    {x₀ x_big : Unit → Nat}
    (hStart1 : r1.state 0 =
      (x₀, fun i => match i with | .proxyAgent => initProxy | .taskPartner => initPartner))
    (hStart2 : r2.state 0 =
      (x_big, fun i => match i with | .proxyAgent => initProxy | .taskPartner => initPartner))
    {Y H_safe y_safe : Nat}
    (most : RegimeMargin.AtMost g Y) (over : Y < hProxyPre)
    (short : RegimeMargin.Short g H_safe y_safe) (hSafeLe : H_safe ≤ hProxyPre)
    (nothing : RegimeMargin.FromNothing g) (hPos : 0 < H_safe + y_safe)
    (g_rises : RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (fun e => g (e ())))
    (post_viable : H_safe + y_safe ≤
      RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole
        (fun _ e => g (e ())) (fun _ => H_safe) (fun _ => H_safe + y_safe) ())
    (post_safe : hProxySafe + M.draw M.safe ≤ H_safe)
    (task_margin : (H_safe + y_safe) + (AdaptiveLoops.natMax lagProxy lagPartner + 1) *
      (hProxyPre + AdaptiveLoops.natMax (M.draw M.ext) (M.draw M.safe)) ≤ M.B_task)
    (init_margin : (H_safe + y_safe) + AdaptiveLoops.natMax initProxy initPartner.2 *
      (hProxyPre + AdaptiveLoops.natMax (M.draw M.ext) (M.draw M.safe)) ≤ x₀ ())
    (n : Nat) (within : x₀ () < (H_safe + y_safe) + (hProxyPre - Y) * n)
    (xSolo : Nat → Nat) (hxSolo0 : xSolo 0 = x₀ ())
    (hxSoloStep : ∀ t, xSolo (t + 1) = RegimeMargin.step g hProxyPre (xSolo t)) :
    (∃ T, T ≤ n ∧ xSolo T < H_safe + y_safe ∧
      (∀ k, (StockFlowBridge.unitWeb xSolo).level (T + k) () < H_safe + y_safe) ∧
      (∃ M₀, xSolo M₀ = 0 ∧ ∀ j, xSolo (M₀ + j) = 0)) ∧
    ((∀ t, (r1.state t).2 .proxyAgent = initProxy ∧
           (r2.state t).2 .proxyAgent = initProxy ∧
           (PooledClearing.pooledOpenLoop M base hProxyPre hProxySafe .proxyAgent).draw
             ((r1.state t).2 .proxyAgent) () = hProxyPre) ∧
      ∃ T, T ≤ n ∧ (r1.state T).1 () < H_safe + y_safe ∧
        (∀ k, (StockFlowBridge.unitWeb (fun t => (r1.state t).1 ())).level (T + k) () < H_safe + y_safe) ∧
        (∃ M₀, (r1.state M₀).1 () = 0 ∧ ∀ j, (r1.state (M₀ + j)).1 () = 0)) ∧
    Viability.Kernel
      (OpenComposition.closedProcess
        (OpenComposition.OpenComponent.compose
          (proxyComponent hProxyPre hProxySafe)
          (taskPartnerComponent M base))
        (OpenComposition.composeContract
          (proxyContract hProxyPre hProxySafe lagProxy safe_le initProxy hInitProxy)
          (taskPartnerContract M base lagPartner initPartner hInitPartner))
        (fun x => ((), M.realizedScore M.ext (x ()) base))
        (fun (em : Bool) (load : Nat) (_ : Unit) => em && Nat.ble load 0)
        (fun _ e => g (e ())) (fun _ _ => 0) (fun _ => True))
      (OpenComposition.closedGuard
        (OpenComposition.OpenComponent.compose
          (proxyComponent hProxyPre hProxySafe)
          (taskPartnerComponent M base))
        (OpenComposition.composeContract
          (proxyContract hProxyPre hProxySafe lagProxy safe_le initProxy hInitProxy)
          (taskPartnerContract M base lagPartner initPartner hInitPartner))
        (fun _ => H_safe + y_safe))
      (x₀, (initProxy, initPartner)) := by
  have soloRes := epistemic_silence_late_bottleneck
    (S := Unit) (Obs := Unit) (P := Nat)
    (fun _ _ => ()) (fun _ _ => ()) (fun _ _ => hProxyPre) (fun d => d)
    g (B_task := H_safe + y_safe) (Y := Y) (H_pre := hProxyPre) (H_safe := H_safe) (y_safe := y_safe)
    (fun _ => True) (fun _ => False) () trivial (fun _ _ _ => trivial)
    (Nat.le_refl _) (fun _ _ _ _ f => f) (fun _ _ _ _ => Nat.le_refl _)
    most over short nothing hPos xSolo (fun _ => ()) rfl (fun _ => rfl) hxSoloStep
    n (hxSolo0 ▸ within)
  obtain ⟨T, hTn, hTlt, hPostSafe, _⟩ := soloRes.2
  obtain ⟨hSoloStay, M₀, hSoloZ, hSoloZeroStay⟩ := hPostSafe (fun _ _ => hSafeLe)
  have unpooled := PooledClearing.unpooled_clearer_blind M base hProxyPre hProxySafe lagProxy lagPartner
    safe_le (fun i => match i with | .proxyAgent => initProxy | .taskPartner => initPartner)
    hInitProxy hInitPartner g r1 r2 hStart1 hStart2 proxyFavours
    most over short hSafeLe nothing hPos n within
  have widened :
      Viability.Kernel
        (OpenComposition.closedProcess
          (OpenComposition.OpenComponent.compose
            (proxyComponent hProxyPre hProxySafe)
            (taskPartnerComponent M base))
          (OpenComposition.composeContract
            (proxyContract hProxyPre hProxySafe lagProxy safe_le initProxy hInitProxy)
            (taskPartnerContract M base lagPartner initPartner hInitPartner))
          (fun x => ((), M.realizedScore M.ext (x ()) base))
          (fun (em : Bool) (load : Nat) (_ : Unit) => em && Nat.ble load 0)
          (fun _ e => g (e ())) (fun _ _ => 0) (fun _ => True))
        (OpenComposition.closedGuard
          (OpenComposition.OpenComponent.compose
            (proxyComponent hProxyPre hProxySafe)
            (taskPartnerComponent M base))
          (OpenComposition.composeContract
            (proxyContract hProxyPre hProxySafe lagProxy safe_le initProxy hInitProxy)
            (taskPartnerContract M base lagPartner initPartner hInitPartner))
          (fun _ => H_safe + y_safe))
        (x₀, (initProxy, initPartner)) :=
    pooled_clearing_open_compose_viable M base hBase hProxyPre hProxySafe lagProxy lagPartner
      safe_le initProxy hInitProxy initPartner hInitPartner
      (fun (em : Bool) (load : Nat) (_ : Unit) => em && Nat.ble load 0)
      (fun _ e => g (e ())) (fun _ _ => 0) (fun _ => 0) (fun _ => True)
      (fun _ _ _ => Nat.zero_le 0) (fun _ => H_safe + y_safe) (fun _ => H_safe) x₀
      (fun load _ _ le => by
        show (true && Nat.ble load 0) = true
        rw [Nat.ble_eq_true_of_le le]
        rfl)
      (fun k => by cases k; exact g_rises)
      (fun k => by cases k; exact post_viable)
      post_safe task_margin init_margin
  exact ⟨⟨T, hTn, hTlt, hSoloStay, M₀, hSoloZ, hSoloZeroStay⟩, unpooled, widened⟩

/-- Concrete non-vacuous witness of `clearing_widening_heals_blindness`: on `ReconfigWitness.turningCap`
from `x₀ = 27`, solo and disconnected clearing runs collapse below `9` and to `0`, whereas
`proxyComponent 5 1 ⊕ taskPartnerComponent wideningModel 20` preserves `Viability.Kernel` forever. -/
def wideningModel : ServiceTaskModel TurningWitness.TurnPolicy where
  gain := 2
  gain_pos := by decide
  demand := fun p => match p with | .safe => 20 | .ext => 26
  upkeep := TurningWitness.turnUpkeep
  draw := fun p => match p with | .safe => 1 | .ext => 2
  safe := .safe
  ext := .ext
  demand_lt := by decide
  upkeep_lt := by decide
  ext_viable_at_full := by decide

def wideningPartnerInit : Bool × Nat := (true, 1)

def wideningPartnerInit_in : serviceK 1 wideningPartnerInit :=
  ⟨Nat.le_refl 1, fun _ => Nat.succ_pos 0, fun h => Bool.noConfusion h⟩

def wideningJointInit : (i : PooledClearing.PooledAgent) → PooledClearing.PooledState i
  | .proxyAgent => 1
  | .taskPartner => (true, 1)

def widenedClosedComp :
    OpenComposition.OpenComponent (Nat × (Bool × Nat)) (Unit × Nat) (Unit × Unit) (Sum Empty Empty) Unit :=
  OpenComposition.OpenComponent.compose (proxyComponent 5 1) (taskPartnerComponent wideningModel 20)

def widenedClosedContract :
    OpenComposition.InterfaceContract widenedClosedComp (1, wideningPartnerInit) :=
  OpenComposition.composeContract
    (proxyContract 5 1 1 (by decide) 1 (Nat.le_refl 1))
    (taskPartnerContract wideningModel 20 1 wideningPartnerInit wideningPartnerInit_in)

def widenedClosedObs (x : Unit → Nat) : Unit × Nat :=
  ((), wideningModel.realizedScore .ext (x ()) 20)

def widenedClosedRun :
    Run (OpenComposition.closedProcess widenedClosedComp widenedClosedContract widenedClosedObs
      ReconfigWitness.syncChannel ReconfigWitness.witnessG (fun _ _ => 0) (fun _ => True)) where
  state := Law.orbit
    (fun st => OpenComposition.closedStep widenedClosedComp widenedClosedObs
      ReconfigWitness.syncChannel ReconfigWitness.witnessG (fun _ _ => 0) st ((), ((), ())))
    (fun _ => 27, (1, wideningPartnerInit))
  act _ := ((), ((), ()))
  step _ := ⟨⟨trivial, fun _ => ⟨trivial, trivial⟩⟩, rfl⟩

theorem widening_heals_witness :
    let xSolo : Nat → Nat := Law.orbit (RegimeMargin.step ReconfigWitness.turningCap 5) 27
    (xSolo 0 = 27 ∧ xSolo 18 = 9 ∧ xSolo 19 = 4 ∧ xSolo 19 < 9 ∧ xSolo 20 = 0) ∧
    (∀ (r1 r2 : Run (AdaptiveLoops.jointProcess (Env := Unit) PooledClearing.pooledAgents
        (PooledClearing.pooledOpenLoop wideningModel 20 5 1)
        (PooledClearing.pooledCerts wideningModel 20 5 1 1 1 (by decide)
          wideningJointInit (Nat.le_refl 1) wideningPartnerInit_in)
        (PooledClearing.pooledObs wideningModel 20) (fun _ _ (_ : Unit) => false)
        ReconfigWitness.witnessG (fun _ _ => 0) (fun _ => True))),
      r1.state 0 = (fun _ => 27, wideningJointInit) →
      r2.state 0 = (fun _ => 100, wideningJointInit) →
      ((∀ t, (r1.state t).2 .proxyAgent = 1 ∧
             (r2.state t).2 .proxyAgent = 1 ∧
             (PooledClearing.pooledOpenLoop wideningModel 20 5 1 .proxyAgent).draw
               ((r1.state t).2 .proxyAgent) () = 5) ∧
        ∃ T, T ≤ 20 ∧ (r1.state T).1 () < 9 ∧
          (∀ k, (StockFlowBridge.unitWeb (fun t => (r1.state t).1 ())).level (T + k) () < 9) ∧
          (∃ M₀, (r1.state M₀).1 () = 0 ∧ ∀ j, (r1.state (M₀ + j)).1 () = 0))) ∧
    Viability.Kernel
      (OpenComposition.closedProcess widenedClosedComp widenedClosedContract widenedClosedObs
        ReconfigWitness.syncChannel ReconfigWitness.witnessG (fun _ _ => 0) (fun _ => True))
      (OpenComposition.closedGuard widenedClosedComp widenedClosedContract (fun _ => 9))
      (fun _ => 27, (1, wideningPartnerInit)) ∧
    (∀ t, 9 ≤ (widenedClosedRun.state t).1 ()) := by
  have kern :
      Viability.Kernel
        (OpenComposition.closedProcess widenedClosedComp widenedClosedContract widenedClosedObs
          ReconfigWitness.syncChannel ReconfigWitness.witnessG (fun _ _ => 0) (fun _ => True))
        (OpenComposition.closedGuard widenedClosedComp widenedClosedContract (fun _ => 9))
        (fun _ => 27, (1, wideningPartnerInit)) :=
    pooled_clearing_open_compose_viable wideningModel 20 (by decide) 5 1 1 1 (by decide)
      1 (Nat.le_refl 1) wideningPartnerInit wideningPartnerInit_in
      ReconfigWitness.syncChannel ReconfigWitness.witnessG (fun _ _ => 0) (fun _ => 0) (fun _ => True)
      (fun _ _ _ => Nat.zero_le 0) (fun _ => 9) (fun _ => 4) (fun _ => 27)
      (fun load _ _ le => by
        show (true && Nat.ble load 0) = true
        rw [Nat.ble_eq_true_of_le le]
        rfl)
      ReconfigWitness.turningCap_rises
      (fun k => by cases k; exact by decide)
      (by decide) (by decide) (by decide)
  refine ⟨⟨rfl, rfl, rfl, by decide, rfl⟩, fun r1 r2 h1 h2 => ?_, kern, fun t => ?_⟩
  · have h := clearing_widening_heals_blindness wideningModel 20 (by decide) 5 1 1 1 (by decide)
      1 (Nat.le_refl 1) (Nat.zero_lt_one) wideningPartnerInit wideningPartnerInit_in
      ReconfigWitness.turningCap r1 r2 h1 h2
      ReconfigWitness.turningCap_atMost (by decide) ReconfigWitness.turningCap_short (by decide)
      ReconfigWitness.turningCap_fromNothing (by decide) (ReconfigWitness.turningCap_rises ())
      (by decide)
      (by decide) (by decide) (by decide) 20 (by decide)
      (Law.orbit (RegimeMargin.step ReconfigWitness.turningCap 5) 27) rfl (fun _ => rfl)
    exact h.2.1
  · exact (Viability.Kernel.run widenedClosedRun kern t).1 ()

end OpenCompositionBridge

end EndogenousTurning

end Becoming
