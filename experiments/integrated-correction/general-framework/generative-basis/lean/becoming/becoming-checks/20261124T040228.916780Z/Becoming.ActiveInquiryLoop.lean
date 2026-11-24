import Becoming.OpenComposition
import Becoming.PolyComposition
import Becoming.CausalAbstraction
import Becoming.Learnable
import Becoming.LearnableRuns
import Becoming.LimitVerification
import Becoming.TimedResponse
import Becoming.Latency
import Becoming.Cascade
import Becoming.ReachedCascade
import Becoming.Thresholds
import Becoming.LevelCoupling
import Becoming.Blanket
import Becoming.BlanketCouplings
import Becoming.CoreHelpers

/-!
# Active Inquiry Loop: Probing Margin, Epistemic Silence, Cascade Capture, Latency/Thresholds, and Blanket Screening

This module (`AI-written` for Wave U4-A `L1`) joins open/poly-modal adaptive loops
(`Becoming.OpenComposition`, `Becoming.PolyComposition`), causal underdetermination and
limit/online learning bounds (`Becoming.CausalAbstraction`, `Becoming.Learnable`,
`Becoming.LearnableRuns`, `Becoming.LimitVerification`), finite-latency and threshold
reading obstructions (`Becoming.TimedResponse`, `Becoming.Latency`, `Becoming.Thresholds`,
`Becoming.LevelCoupling`), information-cascade protocol capture (`Becoming.Cascade`,
`Becoming.ReachedCascade`), and Markov blanket screening (`Becoming.Blanket`,
`Becoming.BlanketCouplings`) at layer `L1`.

* **Part 0:** Shared `L1` variable-draw margin and short-regime collapse helpers
  (`explore_margin_step`, `varDraw_falls_or_bound_while`, `varDraw_falls_within_while`,
  `varDraw_short_collapses`, `silent_drawdown_refutes_kernel`).
* **Part 1:** Exploration-margin sandwich positive theorem
  (`exploration_margin_sandwich_viable`) vs. epistemic-silence, learnability, limit-delay, and
  coupling-deadline impossibility theorems (`exploration_untaken_silence_collapse`,
  `learnable_passive_underdetermined`, `limit_passive_delay_obstruction`,
  `exploration_deadline_impossibility`), plus concrete `ActiveProbeWitness`.
* **Part 2:** Indexed list-pool viability (`composeList_viable_indexed`) vs. cascade and
  reached-cascade pool alarm capture (`cascade_list_emitAlarm_alike`,
  `reachedCascade_list_emitAlarm_alike`, `cascade_list_capture_collapse`,
  `cascade_pool_capture_collapse`), plus concrete `CascadePoolWitness`.
* **Part 3:** Coupling-distance turning obstruction on `PolyClosedProcess`
  (`coupling_distance_obs_alike`, `coupling_distance_turning_obstruction`,
  `DelayObstructionWitness`) and threshold-blindness obstruction bridging `ExchangeLaw.ReadsBelow`
  to open-loop collapse (`network_threshold_blindness`, `threshold_blind_open_collapse`,
  `network_readsBelow_feeds_open_collapse`, `ThresholdBlindnessWitness`).
* **Part 4:** Blanket-to-`OpenComponent` interface characterization with sensory alarm port
  (`BlanketContractSpec`, `componentOfBlanket`, `contractOfBlanket`,
  `blanket_compose_closed_viable`, `blanket_compose_screening`,
  `blanket_isolation_necessary_for_determined_parts`,
  `blanket_parts_not_openComponent_realizable`, `SparseRelayBreachWitness`).

All declarations are in `Type` (`Type 0`), compile from Lean's prelude alone (`0` axioms,
`0` `sorry`, `0` warnings), with `0` unnamed `instance`s and `0` `private` theorems.
-/

namespace Becoming

open Generative

namespace ActiveInquiryLoop

/-! ## Part 0: Shared `L1` Variable-Draw & Margin Helpers -/

/-- When `H ≤ probeTot` and `x_crit + (rem + 1) * probeTot + postSpan ≤ x`,
one probe step leaves `x_crit + rem * probeTot + postSpan ≤ (x - H) + g_val`. -/
theorem explore_margin_step
    (x_crit rem probeTot postSpan x H g_val : Nat)
    (hH : H ≤ probeTot)
    (hInv : x_crit + (rem + 1) * probeTot + postSpan ≤ x) :
    x_crit + rem * probeTot + postSpan ≤ (x - H) + g_val := by
  have expand : (rem + 1) * probeTot = rem * probeTot + probeTot := by
    rw [add_mul_split rem 1 probeTot, Nat.one_mul]
  have rearranged : (x_crit + rem * probeTot + postSpan) + probeTot ≤ x := by
    calc (x_crit + rem * probeTot + postSpan) + probeTot
        = (x_crit + rem * probeTot) + (postSpan + probeTot) := Nat.add_assoc _ _ _
      _ = (x_crit + rem * probeTot) + (probeTot + postSpan) := by rw [Nat.add_comm postSpan probeTot]
      _ = x_crit + (rem * probeTot + (probeTot + postSpan)) := Nat.add_assoc _ _ _
      _ = x_crit + ((rem * probeTot + probeTot) + postSpan) := by
          rw [Nat.add_assoc (rem * probeTot) probeTot postSpan]
      _ = x_crit + (rem * probeTot + probeTot) + postSpan := (Nat.add_assoc _ _ _).symm
      _ = x_crit + (rem + 1) * probeTot + postSpan := by rw [← expand]
      _ ≤ x := hInv
  have subProbe : x_crit + rem * probeTot + postSpan ≤ x - probeTot :=
    Naturals.le_sub_of_add_le (Nat.add_comm _ probeTot ▸ rearranged)
  exact Nat.le_trans subProbe
    (Nat.le_trans (Naturals.sub_antitone x hH) (Nat.le_add_right (x - H) g_val))

theorem sub_lt_of_lt_add {x H d y : Nat} (hHd : H ≤ d) (hdx : d ≤ x) (hlt : x < H + y) :
    x - d < y := by
  have hHs : H ≤ x := Nat.le_trans hHd hdx
  have hSum : H + (x - H) = x := Naturals.add_sub_of_le hHs
  have hltSum : H + (x - H) < H + y := by rw [hSum]; exact hlt
  have hlt1 : H + (x - H).succ ≤ H + y := (Nat.add_succ H (x - H)).symm ▸ hltSum
  have h1 : x - H < y := Naturals.le_of_add_le_add_left hlt1
  exact Nat.lt_of_le_of_lt (Naturals.sub_antitone x hHd) h1

/-- Step-indexed variable-draw dichotomy over finite horizon `n`:
either the level drops below `b` within `m ≤ n`, or it stays at or above `b` through `m` and
falls by at least `(H_min - Y) * m`. -/
theorem varDraw_falls_or_bound_while
    {x d gain : Nat → Nat} {Y H_min b n : Nat}
    (step_eq : ∀ t, t < n → x (t + 1) = (x t - d t) + gain t)
    (most : ∀ t, t < n → gain t ≤ Y)
    (nothing : ∀ t, t < n → x t < d t → gain t = 0)
    (yle : Y ≤ H_min)
    (d_ge_while : ∀ t, t < n → (∀ j, j ≤ t → b ≤ x j) → H_min ≤ d t)
    (b_pos : 0 < b) :
    ∀ m, m ≤ n →
      (∃ k, k ≤ m ∧ x k < b) ∨
      (x m + (H_min - Y) * m ≤ x 0 ∧ ∀ j, j ≤ m → b ≤ x j)
  | 0, _ =>
    match Nat.lt_or_ge (x 0) b with
    | .inl lt => .inl ⟨0, Nat.le_refl 0, lt⟩
    | .inr ge => .inr ⟨Nat.le_refl (x 0), fun j hj => by
        cases Nat.eq_zero_of_le_zero hj
        exact ge⟩
  | m + 1, hm_le =>
    have hm_lt : m < n := Nat.lt_of_lt_of_le (Nat.lt_succ_self m) hm_le
    match varDraw_falls_or_bound_while step_eq most nothing yle d_ge_while b_pos m
        (Nat.le_of_lt hm_lt) with
    | .inl ⟨k, hk_le, hk_lt⟩ => .inl ⟨k, Nat.le_succ_of_le hk_le, hk_lt⟩
    | .inr ⟨hBound, hAbove⟩ =>
      have hd_ge : H_min ≤ d m := d_ge_while m hm_lt hAbove
      match Nat.lt_or_ge (x m) (d m) with
      | .inl hlt_d =>
        have hzero : x (m + 1) = 0 := by
          rw [step_eq m hm_lt, sub_eq_zero_of_le (Nat.le_of_lt hlt_d), nothing m hm_lt hlt_d]
        .inl ⟨m + 1, Nat.le_refl (m + 1), hzero ▸ b_pos⟩
      | .inr hge_d =>
        have hStepFall : x (m + 1) + (H_min - Y) ≤ x m := by
          calc x (m + 1) + (H_min - Y)
              = (x m - d m) + gain m + (H_min - Y) := by rw [step_eq m hm_lt]
            _ ≤ (x m - d m) + Y + (H_min - Y) :=
                Nat.add_le_add_right (Nat.add_le_add_left (most m hm_lt) _) _
            _ = (x m - d m) + (Y + (H_min - Y)) := Nat.add_assoc _ _ _
            _ = (x m - d m) + H_min := by rw [add_sub_of_le yle]
            _ ≤ (x m - d m) + d m := Nat.add_le_add_left hd_ge _
            _ = x m := Naturals.sub_add_cancel hge_d
        match Nat.lt_or_ge (x (m + 1)) b with
        | .inl hlt_b => .inl ⟨m + 1, Nat.le_refl (m + 1), hlt_b⟩
        | .inr hge_b =>
          .inr ⟨by
              calc x (m + 1) + (H_min - Y) * (m + 1)
                  = x (m + 1) + ((H_min - Y) * m + (H_min - Y)) := by
                    rw [Nat.mul_succ]
                _ = x (m + 1) + (H_min - Y) + (H_min - Y) * m := by
                    rw [Nat.add_comm ((H_min - Y) * m) (H_min - Y), Nat.add_assoc]
                _ ≤ x m + (H_min - Y) * m := Nat.add_le_add_right hStepFall _
                _ ≤ x 0 := hBound,
            fun j hj =>
              match Nat.eq_or_lt_of_le hj with
              | .inl heq => heq ▸ hge_b
              | .inr hlt => hAbove j (Nat.le_of_lt_succ hlt)⟩

/-- Step-indexed variable-draw finite falling lemma (L1-native, no `H ≤ b` assumption). -/
theorem varDraw_falls_within_while
    {x d gain : Nat → Nat} {Y H_min b : Nat}
    (step_eq : ∀ t, x (t + 1) = (x t - d t) + gain t)
    (most : ∀ t, gain t ≤ Y)
    (nothing : ∀ t, x t < d t → gain t = 0)
    (yle : Y ≤ H_min)
    (n : Nat)
    (d_ge_while : ∀ t, t < n → (∀ j, j ≤ t → b ≤ x j) → H_min ≤ d t)
    (b_pos : 0 < b)
    (within : x 0 < b + (H_min - Y) * n) :
    ∃ k, k ≤ n ∧ x k < b :=
  match varDraw_falls_or_bound_while (n := n)
      (fun t _ => step_eq t) (fun t _ => most t) (fun t _ => nothing t)
      yle d_ge_while b_pos n (Nat.le_refl n) with
  | .inl hex => hex
  | .inr ⟨hBound, hAbove⟩ =>
    absurd
      (Nat.lt_of_le_of_lt
        (Nat.le_trans (Nat.add_le_add_right (hAbove n (Nat.le_refl n)) _) hBound)
        within)
      (Nat.lt_irrefl _)

/-- Post-crossing collapse helper: once `x T < b_nr`, if any step from `T` onward below `b_nr`
has `gain = 0` on overdraw (`x t < d t`) and `gain t < d t` when `d t ≤ x t`, then `x` stays
strictly below `b_nr`, falls by at least `1` per positive step, and stays `0` from `T + x T`. -/
theorem varDraw_short_collapses
    {x d gain : Nat → Nat} {b_nr T : Nat}
    (step_eq : ∀ t, x (t + 1) = (x t - d t) + gain t)
    (b_pos : 0 < b_nr)
    (nothing_post : ∀ t, T ≤ t → x t < d t → x t < b_nr → gain t = 0)
    (short_post : ∀ t, T ≤ t → d t ≤ x t → x t < b_nr → gain t < d t)
    (crossed : x T < b_nr) :
    (∀ k, x (T + k) < b_nr ∧ x (T + k) ≤ x T - k) ∧
    (x (T + x T) = 0 ∧ ∀ m, x (T + x T + m) = 0) := by
  have descent : ∀ k, x (T + k) < b_nr ∧ x (T + k) ≤ x T - k := by
    intro k
    induction k with
    | zero => exact ⟨crossed, Nat.le_refl _⟩
    | succ k ih =>
      obtain ⟨ih_lt, ih_le⟩ := ih
      have hgeT : T ≤ T + k := Nat.le_add_right T k
      have hstep : x (T + (k + 1)) = (x (T + k) - d (T + k)) + gain (T + k) :=
        step_eq (T + k)
      match Nat.lt_or_ge (x (T + k)) (d (T + k)) with
      | .inl hlt_d =>
        have hz : x (T + (k + 1)) = 0 := by
          rw [hstep, sub_eq_zero_of_le (Nat.le_of_lt hlt_d), nothing_post (T + k) hgeT hlt_d ih_lt]
        exact ⟨hz ▸ b_pos, hz ▸ Nat.zero_le _⟩
      | .inr hge_d =>
        have hlt_gain : gain (T + k) < d (T + k) := short_post (T + k) hgeT hge_d ih_lt
        have hlt_prev : x (T + (k + 1)) < x (T + k) := by
          calc x (T + (k + 1))
              = (x (T + k) - d (T + k)) + gain (T + k) := hstep
            _ < (x (T + k) - d (T + k)) + d (T + k) := Nat.add_lt_add_left hlt_gain _
            _ = x (T + k) := Naturals.sub_add_cancel hge_d
        have hle_pred : x (T + (k + 1)) ≤ x (T + k) - 1 :=
          Naturals.le_sub_of_add_le (Nat.add_comm (x (T + (k + 1))) 1 ▸ hlt_prev)
        have hle_k : x (T + (k + 1)) ≤ x T - (k + 1) := by
          rw [← Naturals.sub_sub (x T) k 1]
          exact Nat.le_trans hle_pred (Nat.pred_le_pred ih_le)
        exact ⟨Nat.lt_trans hlt_prev ih_lt, hle_k⟩
  have hzero : x (T + x T) = 0 :=
    Nat.eq_zero_of_le_zero (Nat.sub_self (x T) ▸ (descent (x T)).2)
  have hstay : ∀ m, x (T + x T + m) = 0 := by
    intro m
    induction m with
    | zero => exact hzero
    | succ m ihm =>
      have hgeT : T ≤ T + x T + m := Nat.le_trans (Nat.le_add_right T (x T)) (Nat.le_add_right _ m)
      have hlt_b : x (T + x T + m) < b_nr := ihm ▸ b_pos
      have hstep : x (T + x T + (m + 1)) =
          (x (T + x T + m) - d (T + x T + m)) + gain (T + x T + m) :=
        step_eq (T + x T + m)
      match Nat.lt_or_ge 0 (d (T + x T + m)) with
      | .inl hd_pos =>
        have hlt_d : x (T + x T + m) < d (T + x T + m) := ihm ▸ hd_pos
        rw [hstep, ihm, Nat.zero_sub, nothing_post _ hgeT hlt_d hlt_b]
      | .inr hd_zero =>
        have hge_d : d (T + x T + m) ≤ x (T + x T + m) := ihm ▸ hd_zero
        have hlt_gain : gain (T + x T + m) < d (T + x T + m) := short_post _ hgeT hge_d hlt_b
        exact absurd (Nat.lt_of_lt_of_le hlt_gain hd_zero) (Nat.not_lt_zero _)
  exact ⟨descent, hzero, hstay⟩

/-- Shared open-loop kernel refutation from a witness admissible disturbance `m₀` that forces
draw `H_pre > Y` on `site_crit` while `x_crit site_crit ≤ x site_crit`. -/
theorem silent_drawdown_refutes_kernel
    {S Obs Dist Int Ext Env : Type}
    (C : OpenComposition.OpenComponent S Obs Dist Int Ext) {init : S}
    (c : OpenComposition.InterfaceContract C init)
    (obs : (Ext → Nat) → Obs)
    (channel : Bool → Nat → Env → Bool)
    (G : Ext → (Ext → Nat) → Nat) (envDraw : Env → Ext → Nat) (jointAdm : Env → Prop)
    (x_crit x₀ : Ext → Nat) (site_crit : Ext)
    {Y H_pre n : Nat}
    (G_most : ∀ e, G site_crit e ≤ Y)
    (G_dep : RegimeMargin.Coupled.Indexed.DependsOn RegimeMargin.Drawn.whole G site_crit site_crit)
    (yle : Y < H_pre) (x_crit_pos : 0 < x_crit site_crit)
    (env_adm : Env) (hAdm : jointAdm env_adm)
    (d₀ : Dist) (hTol : ∀ ob, c.tol ob d₀)
    (draw_ge_while :
      let orb := Law.orbit
        (fun st => OpenComposition.closedStep C obs channel G envDraw st (env_adm, d₀))
        (x₀, init)
      ∀ t, t < n → (∀ j, j ≤ t → x_crit site_crit ≤ (orb j).1 site_crit) →
        H_pre ≤ C.drawExt (orb t).2 site_crit)
    (under_headroom : x₀ site_crit < x_crit site_crit + (H_pre - Y) * n) :
    ¬ Viability.Kernel
      (OpenComposition.closedProcess C c obs channel G envDraw jointAdm)
      (OpenComposition.closedGuard C c x_crit)
      (x₀, init) := by
  intro kern
  let stepFn := fun st => OpenComposition.closedStep C obs channel G envDraw st (env_adm, d₀)
  let orb := Law.orbit stepFn (x₀, init)
  let xSeq : Nat → Nat := fun t => (orb t).1 site_crit
  let dSeq : Nat → Nat := fun t => C.drawExt (orb t).2 site_crit + envDraw env_adm site_crit
  let gainSeq : Nat → Nat := fun t =>
    G site_crit (RegimeMargin.Coupled.Indexed.left RegimeMargin.Drawn.whole
      (fun k => C.drawExt (orb t).2 k + envDraw env_adm k) (orb t).1)
  have hStep : ∀ t, xSeq (t + 1) = (xSeq t - dSeq t) + gainSeq t := fun _ => rfl
  have hMost : ∀ t, gainSeq t ≤ Y := fun t => G_most _
  have hNothing : ∀ t, xSeq t < dSeq t → gainSeq t = 0 := fun t hlt => by
    apply G_dep
    exact sub_eq_zero_of_le (Nat.le_of_lt hlt)
  have hDge : ∀ t, t < n → (∀ j, j ≤ t → x_crit site_crit ≤ xSeq j) → H_pre ≤ dSeq t :=
    fun t htn hab => Nat.le_trans (draw_ge_while t htn hab) (Nat.le_add_right _ _)
  obtain ⟨k, _, hk_lt⟩ := varDraw_falls_within_while hStep hMost hNothing (Nat.le_of_lt yle)
    n hDge x_crit_pos under_headroom
  have hReach : ∀ m, Reach (OpenComposition.closedProcess C c obs channel G envDraw jointAdm)
      (x₀, init) (orb m) := by
    intro m
    induction m with
    | zero => exact Reach.refl _ _
    | succ m ih => exact Reach.trans ih (Reach.of_step ⟨⟨hAdm, hTol⟩, rfl⟩)
  have hGuard := kern (orb k) (hReach k)
  exact Nat.lt_irrefl _ (Nat.lt_of_lt_of_le hk_lt (hGuard.1 site_crit))

/-! ## Part 1: Active-Inquiry Deadline & Exploration-Margin Sandwich -/

/-- Two-phase mode space: active probing step `t` vs. committed operation under inferred `hat : Θ`. -/
inductive InquiryMode (Θ OpM : Type) where
  | probe (step : Nat)
  | operate (hat : Θ) (op : OpM)

/-- Unknown regime world indexed by `θ : Θ`, supplying substrate dynamics, probe readout, and
operational observation. -/
structure RegimeWorld (Θ Probe Outcome Obs_op Site Env : Type) where
  G : Θ → Site → (Site → Nat) → Nat
  G_rises : ∀ θ site, RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (G θ site)
  probeObs : Θ → Probe → (Site → Nat) → Outcome
  opObs : Θ → (Site → Nat) → Obs_op
  envDraw : Θ → Env → Site → Nat
  envCap : Site → Nat
  jointAdm : Env → Prop
  env_within : ∀ env, jointAdm env → ∀ θ site, envDraw θ env site ≤ envCap site

/-- Mode-dependent state carrier for `InquiryMode Θ Unit`. -/
abbrev inquiryS (Probe Outcome S_op Θ : Type) : InquiryMode Θ Unit → Type
  | .probe _ => List (Probe × Outcome)
  | .operate _ _ => S_op

/-- Mode-dependent observation carrier for `InquiryMode Θ Unit`. -/
abbrev inquiryObs (Outcome Obs_op Θ : Type) : InquiryMode Θ Unit → Type
  | .probe _ => Outcome
  | .operate _ _ => Obs_op

/-- Mode-dependent disturbance carrier for `InquiryMode Θ Unit`. -/
abbrev inquiryDist (Dist_op Θ : Type) : InquiryMode Θ Unit → Type
  | .probe _ => Unit
  | .operate _ _ => Dist_op

/-- Mode-dependent internal substrate port carrier for `InquiryMode Θ Unit`. -/
abbrev inquiryInt (Int_op Θ : Type) : InquiryMode Θ Unit → Type
  | .probe _ => Empty
  | .operate _ _ => Int_op

/-- Mode-dependent exposed substrate port carrier for `InquiryMode Θ Unit`. -/
abbrev inquiryExt (Site Θ : Type) : InquiryMode Θ Unit → Type
  | _ => Site

/-- Active epistemic policy (independent of true `θ`): probes for `horizon` steps, infers `hat : Θ`,
and hands off to `(opComp hat, opContract hat)` whose lag is uniformly bounded by `opMaxLag`. -/
structure ActiveInquirySpec (Θ Probe Outcome S_op Obs_op Dist_op Int_op Site : Type) where
  horizon : Nat
  plan : Nat → Probe
  probeDraw : Site → Nat
  probeStepDraw : Nat → List (Probe × Outcome) → Site → Nat
  probeDraw_le : ∀ t hist site, probeStepDraw t hist site ≤ probeDraw site
  infer : List (Probe × Outcome) → Θ
  opComp : Θ → OpenComposition.OpenComponent S_op Obs_op Dist_op Int_op Site
  opInit : Θ → S_op
  opContract : (θ : Θ) → OpenComposition.InterfaceContract (opComp θ) (opInit θ)
  opMaxLag : Nat
  opLag_le : ∀ hat, (opContract hat).maxLag ≤ opMaxLag

/-- Initial mode-state pair handling `horizon = 0` cleanly without stalling in `.probe 0`. -/
def inquiryInit {Θ Probe Outcome S_op Obs_op Dist_op Int_op Site : Type}
    (spec : ActiveInquirySpec Θ Probe Outcome S_op Obs_op Dist_op Int_op Site) :
    Σ m : InquiryMode Θ Unit, inquiryS Probe Outcome S_op Θ m :=
  match spec.horizon with
  | 0 => ⟨.operate (spec.infer []) (), spec.opInit (spec.infer [])⟩
  | _ + 1 => ⟨.probe 0, []⟩

/-- Exact `PolyComponent` realized by `ActiveInquirySpec`. -/
def inquiryPolyComponent {Θ Probe Outcome S_op Obs_op Dist_op Int_op Site : Type}
    (spec : ActiveInquirySpec Θ Probe Outcome S_op Obs_op Dist_op Int_op Site) :
    PolyComposition.PolyComponent (InquiryMode Θ Unit)
      (inquiryS Probe Outcome S_op Θ)
      (inquiryObs Outcome Obs_op Θ)
      (inquiryDist Dist_op Θ)
      (inquiryInt Int_op Θ)
      (inquiryExt Site Θ) where
  next p oa d :=
    match p with
    | ⟨.probe t, hist⟩ =>
      let hist' := hist ++ [(spec.plan t, oa.1)]
      if t + 1 < spec.horizon then
        ⟨.probe (t + 1), hist'⟩
      else
        let hat := spec.infer hist'
        ⟨.operate hat (), spec.opInit hat⟩
    | ⟨.operate hat _, opS⟩ => ⟨.operate hat (), (spec.opComp hat).next opS oa d⟩
  drawInt p j :=
    match p with
    | ⟨.probe _, _⟩ => Empty.elim j
    | ⟨.operate hat _, opS⟩ => (spec.opComp hat).drawInt opS j
  drawExt p site :=
    match p with
    | ⟨.probe t, hist⟩ => spec.probeStepDraw t hist site
    | ⟨.operate hat _, opS⟩ => (spec.opComp hat).drawExt opS site
  emitAlarm m s o :=
    match m with
    | .probe _ => false
    | .operate hat _ => (spec.opComp hat).emitAlarm s o
  silenceLoad p :=
    match p with
    | ⟨.probe _, _⟩ => 0
    | ⟨.operate hat _, opS⟩ => (spec.opComp hat).silenceLoad opS
  favours p :=
    match p with
    | ⟨.probe _, _⟩ => False
    | ⟨.operate hat _, opS⟩ => (spec.opComp hat).favours opS

/-- Exact `PolyContract` induced by `ActiveInquirySpec` (independent of true `θ`). -/
def inquiryContract {Θ Probe Outcome S_op Obs_op Dist_op Int_op Site : Type}
    (spec : ActiveInquirySpec Θ Probe Outcome S_op Obs_op Dist_op Int_op Site) :
    PolyComposition.PolyContract (inquiryPolyComponent spec) (inquiryInit spec) where
  tol m :=
    match m with
    | .probe _ => fun _ _ => True
    | .operate hat _ => (spec.opContract hat).tol
  warnObs m :=
    match m with
    | .probe _ => fun _ => False
    | .operate hat _ => (spec.opContract hat).warnObs
  preCapInt m :=
    match m with
    | .probe _ => Empty.elim
    | .operate hat _ => (spec.opContract hat).preCapInt
  preCapExt m :=
    match m with
    | .probe _ => spec.probeDraw
    | .operate hat _ => (spec.opContract hat).preCapExt
  postAllowanceInt m :=
    match m with
    | .probe _ => Empty.elim
    | .operate hat _ => (spec.opContract hat).postBudgetInt
  postAllowanceExt m :=
    match m with
    | .probe _ => spec.probeDraw
    | .operate hat _ => (spec.opContract hat).postBudgetExt
  maxSilence m :=
    match m with
    | .probe _ => 0
    | .operate hat _ => (spec.opContract hat).maxSilence
  maxLag m :=
    match m with
    | .probe _ => spec.horizon + spec.opMaxLag
    | .operate hat _ => (spec.opContract hat).maxLag
  K p :=
    match p with
    | ⟨.probe t, _⟩ => t < spec.horizon
    | ⟨.operate hat _, opS⟩ => (spec.opContract hat).K opS
  eta p :=
    match p with
    | ⟨.probe t, _⟩ => (spec.horizon - t) + spec.opMaxLag
    | ⟨.operate hat _, opS⟩ => (spec.opContract hat).eta opS
  init_in := by
    dsimp only [inquiryInit]
    cases hHor : spec.horizon with
    | zero => exact (spec.opContract (spec.infer [])).init_in
    | succ h => exact Nat.zero_lt_succ h
  cert := by
    refine ⟨?_, ?_⟩
    · intro p hp
      cases p with | mk m s =>
      cases m with
      | probe t =>
        have hpos : 0 < (spec.horizon - t) + spec.opMaxLag :=
          Nat.lt_of_lt_of_le (Naturals.le_sub_of_add_le (a := t) (b := 1) hp) (Nat.le_add_right _ _)
        exact ⟨fun j => Empty.elim j, fun k => spec.probeDraw_le t s k, Nat.le_refl 0,
          fun h0 => absurd h0 (Nat.ne_of_gt hpos)⟩
      | operate hat op =>
        exact (spec.opContract hat).cert.within s hp
    · intro p a p' hstep hp
      rcases hstep with ⟨hm, htol, rfl⟩
      cases p with | mk m s =>
      cases m with
      | probe t =>
        dsimp only [inquiryPolyComponent] at hm htol ⊢
        cases a with | mk am ab =>
        dsimp only at hm
        cases hm
        cases hlt : Nat.decLt (t + 1) spec.horizon with
        | isTrue hNext =>
          rw [if_pos hNext]
          exact hNext
        | isFalse hDone =>
          rw [if_neg hDone]
          exact (spec.opContract _).init_in
      | operate hat op =>
        dsimp only [inquiryPolyComponent] at hm htol ⊢
        cases a with | mk am ab =>
        dsimp only at hm
        cases hm
        exact (spec.opContract hat).cert.closed s ab _ ⟨htol, rfl⟩ hp
  eta_bound p hp := by
    cases p with | mk m s =>
    cases m with
    | probe t => exact Nat.add_le_add_right (Nat.sub_le spec.horizon t) spec.opMaxLag
    | operate hat op => exact (spec.opContract hat).eta_bound s hp
  emits_on_warn m s o hK hw := by
    cases m with
    | probe t => exact False.elim hw
    | operate hat op => exact (spec.opContract hat).emits_on_warn s o hK hw
  eta_alarm_step m s o dist htol hK hpos := by
    cases m with
    | probe t =>
      dsimp only [inquiryPolyComponent]
      have hSub : spec.horizon - t = (spec.horizon - (t + 1)) + 1 :=
        CoreHelpers.sub_eq_sub_succ_add_one hK
      cases hlt : Nat.decLt (t + 1) spec.horizon with
      | isTrue hNext =>
        rw [if_pos hNext]
        show (spec.horizon - (t + 1)) + spec.opMaxLag < (spec.horizon - t) + spec.opMaxLag
        rw [hSub, Nat.add_assoc, Nat.add_comm 1 spec.opMaxLag, ← Nat.add_assoc]
        exact Nat.lt_succ_self _
      | isFalse hDone =>
        rw [if_neg hDone]
        let hat := spec.infer (s ++ [(spec.plan t, o)])
        have hEtaOp : (spec.opContract hat).eta (spec.opInit hat) ≤ spec.opMaxLag :=
          Nat.le_trans ((spec.opContract hat).eta_bound _ (spec.opContract hat).init_in)
            (spec.opLag_le hat)
        have hGe : t + 1 ≤ spec.horizon := hK
        have hEq : t + 1 = spec.horizon := Nat.le_antisymm hGe (Nat.ge_of_not_lt hDone)
        have hZero : spec.horizon - t = 1 := by
          rw [hSub, hEq, Nat.sub_self]
        show (spec.opContract hat).eta (spec.opInit hat) < (spec.horizon - t) + spec.opMaxLag
        rw [hZero]
        exact Nat.lt_of_le_of_lt hEtaOp (Nat.add_comm 1 spec.opMaxLag ▸ Nat.lt_succ_self _)
    | operate hat op => exact (spec.opContract hat).eta_alarm_step s o dist htol hK hpos
  eta_alarm_zero m s o dist htol hK h0 := by
    cases m with
    | probe t =>
      have hpos : 0 < (spec.horizon - t) + spec.opMaxLag :=
        Nat.lt_of_lt_of_le (Naturals.le_sub_of_add_le (a := t) (b := 1) hK) (Nat.le_add_right _ _)
      exact absurd h0 (Nat.ne_of_gt hpos)
    | operate hat op => exact (spec.opContract hat).eta_alarm_zero s o dist htol hK h0

/-- World observation channel seen by `inquiryPolyComponent` in regime `θ`. -/
def inquiryWorldObs {Θ Probe Outcome Obs_op Site Env : Type}
    (W : RegimeWorld Θ Probe Outcome Obs_op Site Env)
    {S_op Dist_op Int_op : Type}
    (spec : ActiveInquirySpec Θ Probe Outcome S_op Obs_op Dist_op Int_op Site)
    (θ : Θ) : (m : InquiryMode Θ Unit) → (Site → Nat) → inquiryObs Outcome Obs_op Θ m
  | .probe t, x => W.probeObs θ (spec.plan t) x
  | .operate _ _, x => W.opObs θ x

/-- Explicit prefix transcript produced along probe steps `0 .. t - 1` over trajectory `xs`. -/
def probeTranscript {Θ Probe Outcome Obs_op Site Env : Type}
    (W : RegimeWorld Θ Probe Outcome Obs_op Site Env)
    (plan : Nat → Probe) (θ : Θ) (xs : Nat → Site → Nat) :
    Nat → List (Probe × Outcome)
  | 0 => []
  | t + 1 => probeTranscript W plan θ xs t ++ [(plan t, W.probeObs θ (plan t) (xs t))]

theorem probeTranscript_congr {Θ Probe Outcome Obs_op Site Env : Type}
    (W : RegimeWorld Θ Probe Outcome Obs_op Site Env)
    (plan : Nat → Probe) (θ : Θ) {xs₁ xs₂ : Nat → Site → Nat} :
    ∀ t, (∀ s, s < t → xs₁ s = xs₂ s) →
      probeTranscript W plan θ xs₁ t = probeTranscript W plan θ xs₂ t
  | 0, _ => rfl
  | t + 1, h => by
    have hprev := probeTranscript_congr W plan θ t fun s hs => h s (Nat.lt_succ_of_lt hs)
    have hcur := h t (Nat.lt_succ_self t)
    show probeTranscript W plan θ xs₁ t ++ [(plan t, W.probeObs θ (plan t) (xs₁ t))] =
         probeTranscript W plan θ xs₂ t ++ [(plan t, W.probeObs θ (plan t) (xs₂ t))]
    rw [hprev, hcur]

/-- Closed-loop viability invariant for active probing, handoff, and operational contract. -/
def ExploreMarginInv {Θ Probe Outcome S_op Obs_op Dist_op Int_op Site Env : Type}
    (W : RegimeWorld Θ Probe Outcome Obs_op Site Env)
    (spec : ActiveInquirySpec Θ Probe Outcome S_op Obs_op Dist_op Int_op Site)
    (θ : Θ) (x_crit : Site → Nat)
    (st : (Site → Nat) × Σ m : InquiryMode Θ Unit, inquiryS Probe Outcome S_op Θ m) : Prop :=
  match st.2 with
  | ⟨.probe t, hist⟩ =>
    t < spec.horizon ∧
    (∃ xs : Nat → Site → Nat,
      (∀ s, s < t → ∀ site, x_crit site ≤ xs s site) ∧
      hist = probeTranscript W spec.plan θ xs t) ∧
    ∀ site,
      x_crit site + (spec.horizon - t) * (spec.probeDraw site + W.envCap site) +
        ((spec.opContract θ).maxLag + 1) *
          ((spec.opContract θ).preCapExt site + W.envCap site) ≤ st.1 site
  | ⟨.operate hat _, opS⟩ =>
    hat = θ ∧
    (spec.opContract θ).K opS ∧
    ∀ site,
      x_crit site + (spec.opContract θ).eta opS *
        ((spec.opContract θ).preCapExt site + W.envCap site) ≤ st.1 site

theorem opContract_K_eta_congr {Θ S_op Obs_op Dist_op Int_op Site : Type}
    (opComp : Θ → OpenComposition.OpenComponent S_op Obs_op Dist_op Int_op Site)
    (opInit : Θ → S_op)
    (opContract : (θ : Θ) → OpenComposition.InterfaceContract (opComp θ) (opInit θ))
    {hat θ : Θ} (h : hat = θ) :
    (opContract θ).K (opInit hat) ∧
    (opContract θ).eta (opInit hat) = (opContract θ).eta (opInit θ) := by
  subst h
  exact ⟨(opContract _).init_in, rfl⟩

/-- **Exploration-Margin Positive Half**: when `horizon` active probes identify `θ` on every
margin-safe substrate trajectory and initial stock covers exploration + operational response lag,
the closed `PolyComponent` loop preserves `Viability.Kernel` of `polyClosedGuard` eternally. -/
theorem exploration_margin_sandwich_viable
    {Θ Probe Outcome S_op Obs_op Dist_op Int_op Site Env : Type}
    (W : RegimeWorld Θ Probe Outcome Obs_op Site Env)
    (spec : ActiveInquirySpec Θ Probe Outcome S_op Obs_op Dist_op Int_op Site)
    (θ : Θ)
    (channel : Bool → Nat → Env → Bool)
    (x_crit warnLevel H_safe x₀ : Site → Nat)
    (probe_identifies : ∀ xs : Nat → Site → Nat,
      (∀ t, t < spec.horizon → ∀ site, x_crit site ≤ xs t site) →
      spec.infer (probeTranscript W spec.plan θ xs spec.horizon) = θ)
    (obs_detects : ∀ x site, x site < warnLevel site →
      (spec.opContract θ).warnObs (W.opObs θ x))
    (channel_fires : ∀ load env, W.jointAdm env →
      load ≤ (spec.opContract θ).maxSilence → channel true load env = true)
    (post_viable : ∀ site, x_crit site ≤
      RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole (W.G θ) H_safe x_crit site)
    (post_allowance : ∀ site, (spec.opContract θ).postBudgetExt site + W.envCap site ≤ H_safe site)
    (warn_margin : ∀ site, x_crit site + ((spec.opContract θ).maxLag + 1) *
      ((spec.opContract θ).preCapExt site + W.envCap site) ≤ warnLevel site)
    (init_margin : ∀ site,
      x_crit site + spec.horizon * (spec.probeDraw site + W.envCap site) +
        ((spec.opContract θ).maxLag + 1) *
          ((spec.opContract θ).preCapExt site + W.envCap site) ≤ x₀ site) :
    let proc := PolyComposition.polyClosedProcess
      (inquiryPolyComponent spec) (fun _ site => [site])
      (inquiryContract spec)
      (inquiryWorldObs W spec θ) channel (W.G θ) (W.envDraw θ) W.jointAdm
    Viability.Certificate proc
      (PolyComposition.polyClosedGuard (inquiryPolyComponent spec) (inquiryContract spec) x_crit)
      (ExploreMarginInv W spec θ x_crit) ∧
    Viability.Kernel proc
      (PolyComposition.polyClosedGuard (inquiryPolyComponent spec) (inquiryContract spec) x_crit)
      (x₀, inquiryInit spec) := by
  let proc := PolyComposition.polyClosedProcess
    (inquiryPolyComponent spec) (fun _ site => [site])
    (inquiryContract spec)
    (inquiryWorldObs W spec θ) channel (W.G θ) (W.envDraw θ) W.jointAdm
  have hCert : Viability.Certificate proc
      (PolyComposition.polyClosedGuard (inquiryPolyComponent spec) (inquiryContract spec) x_crit)
      (ExploreMarginInv W spec θ x_crit) := by
    refine ⟨?_, ?_⟩
    · intro st hInv
      cases st with | mk x p =>
      cases p with | mk m s =>
      cases m with
      | probe t =>
        obtain ⟨ht, _, hMarg⟩ := hInv
        have hpos : 0 < (spec.horizon - t) + spec.opMaxLag :=
          Nat.lt_of_lt_of_le (Naturals.le_sub_of_add_le (a := t) (b := 1) ht) (Nat.le_add_right _ _)
        refine ⟨fun site => Nat.le_trans (Nat.le_trans (Nat.le_add_right _ _) (Nat.le_add_right _ _))
            (hMarg site),
          fun j => Empty.elim j, fun k => spec.probeDraw_le t s k, Nat.le_refl 0,
          fun h0 => absurd h0 (Nat.ne_of_gt hpos)⟩
      | operate hat op =>
        obtain ⟨hHat, hK, hMarg⟩ := hInv
        subst hHat
        exact ⟨fun site => Nat.le_trans (Nat.le_add_right _ _) (hMarg site),
          (spec.opContract hat).cert.within s hK⟩
    · intro st act st' hstep hInv
      obtain ⟨x, ⟨m, s⟩⟩ := st
      obtain ⟨env, ⟨m', d⟩⟩ := act
      rcases hstep with ⟨hm, envOk, tolOk, heq⟩
      cases hm
      subst heq
      cases m with
      | probe t =>
        obtain ⟨ht, ⟨xs, hxs, hHist⟩, hMarg⟩ := hInv
        let xs' : Nat → Site → Nat := fun u => if u < t then xs u else x
        have hxs' : ∀ u, u < t + 1 → ∀ site, x_crit site ≤ xs' u site := by
          intro u hu site
          cases Nat.lt_or_ge u t with
          | inl hlt =>
            show x_crit site ≤ (if u < t then xs u else x) site
            rw [if_pos hlt]
            exact hxs u hlt site
          | inr hge =>
            have heq_u : u = t := Nat.le_antisymm (Nat.le_of_lt_succ hu) hge
            show x_crit site ≤ (if u < t then xs u else x) site
            rw [if_neg (heq_u ▸ Nat.lt_irrefl t)]
            exact Nat.le_trans (Nat.le_trans (Nat.le_add_right _ _) (Nat.le_add_right _ _))
              (hMarg site)
        have hHistCon : s = probeTranscript W spec.plan θ xs' t :=
          hHist.trans (probeTranscript_congr W spec.plan θ t fun u hu =>
            (if_pos hu : (if u < t then xs u else x) = xs u).symm)
        have hHist' : s ++ [(spec.plan t, W.probeObs θ (spec.plan t) x)] =
            probeTranscript W spec.plan θ xs' (t + 1) := by
          have hx_t : xs' t = x := if_neg (Nat.lt_irrefl t)
          show s ++ [(spec.plan t, W.probeObs θ (spec.plan t) x)] =
            probeTranscript W spec.plan θ xs' t ++ [(spec.plan t, W.probeObs θ (spec.plan t) (xs' t))]
          rw [hHistCon, hx_t]
        have hNextMarg : ∀ site,
            x_crit site + (spec.horizon - (t + 1)) * (spec.probeDraw site + W.envCap site) +
              ((spec.opContract θ).maxLag + 1) *
                ((spec.opContract θ).preCapExt site + W.envCap site) ≤
              RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole (W.G θ)
                (fun k => PolyComposition.polySiteDraw (inquiryPolyComponent spec)
                  (fun _ site => [site]) ⟨.probe t, s⟩ k + W.envDraw θ env k) x site := by
          intro site
          have hSub : spec.horizon - t = (spec.horizon - (t + 1)) + 1 :=
            CoreHelpers.sub_eq_sub_succ_add_one ht
          have hDraw : PolyComposition.polySiteDraw (inquiryPolyComponent spec)
              (fun _ site => [site]) ⟨.probe t, s⟩ site + W.envDraw θ env site ≤
              spec.probeDraw site + W.envCap site := by
            show (spec.probeStepDraw t s site + 0) + W.envDraw θ env site ≤
              spec.probeDraw site + W.envCap site
            rw [Nat.add_zero]
            exact Nat.add_le_add (spec.probeDraw_le t s site) (W.env_within env envOk θ site)
          exact explore_margin_step (x_crit site) (spec.horizon - (t + 1))
            (spec.probeDraw site + W.envCap site)
            (((spec.opContract θ).maxLag + 1) * ((spec.opContract θ).preCapExt site + W.envCap site))
            (x site) _ _ hDraw (hSub ▸ hMarg site)
        dsimp only [PolyComposition.polyClosedStep, inquiryPolyComponent, inquiryWorldObs]
        cases hlt : Nat.decLt (t + 1) spec.horizon with
        | isTrue hNext =>
          rw [if_pos hNext]
          exact ⟨hNext, ⟨xs', hxs', hHist'⟩, hNextMarg⟩
        | isFalse hDone =>
          rw [if_neg hDone]
          have hEqHor : t + 1 = spec.horizon := Nat.le_antisymm ht (Nat.ge_of_not_lt hDone)
          let hat := spec.infer (s ++ [(spec.plan t, W.probeObs θ (spec.plan t) x)])
          have hHat : hat = θ := by
            show spec.infer (s ++ [(spec.plan t, W.probeObs θ (spec.plan t) x)]) = θ
            rw [hHist', hEqHor]
            exact probe_identifies xs' (hEqHor ▸ hxs')
          have hZeroRem : spec.horizon - (t + 1) = 0 := by rw [hEqHor, Nat.sub_self]
          have hCongr := opContract_K_eta_congr spec.opComp spec.opInit spec.opContract hHat
          refine ⟨hHat, hCongr.1, fun site => ?_⟩
          have hBoundOp : (spec.opContract θ).eta (spec.opInit θ) ≤ (spec.opContract θ).maxLag + 1 :=
            Nat.le_trans ((spec.opContract θ).eta_bound _ (spec.opContract θ).init_in)
              (Nat.le_succ _)
          have hM := hNextMarg site
          rw [hZeroRem, Nat.zero_mul, Nat.add_zero] at hM
          have hEtaStep : x_crit site + (spec.opContract θ).eta (spec.opInit θ) *
              ((spec.opContract θ).preCapExt site + W.envCap site) ≤
              x_crit site + ((spec.opContract θ).maxLag + 1) *
                ((spec.opContract θ).preCapExt site + W.envCap site) :=
            Nat.add_le_add_left (Nat.mul_le_mul_right _ hBoundOp) _
          show x_crit site + (spec.opContract θ).eta (spec.opInit hat) *
              ((spec.opContract θ).preCapExt site + W.envCap site) ≤ _
          rw [hCongr.2]
          exact Nat.le_trans hEtaStep hM
      | operate hat op =>
        cases op
        obtain ⟨hHat, hK, hMarg⟩ := hInv
        subst hHat
        dsimp only [PolyComposition.polyClosedStep, inquiryPolyComponent, inquiryWorldObs]
        let o := W.opObs hat x
        let al := channel ((spec.opComp hat).emitAlarm s o) ((spec.opComp hat).silenceLoad s) env
        let s' := (spec.opComp hat).next s (o, al) d
        have wS := (spec.opContract hat).cert.within s hK
        have hK' : (spec.opContract hat).K s' :=
          (spec.opContract hat).cert.closed s ((o, al), d) s' ⟨tolOk (o, al), rfl⟩ hK
        have hH_le : ∀ site,
            (PolyComposition.polySiteDraw (inquiryPolyComponent spec) (fun _ site => [site])
              ⟨.operate hat (), s⟩ site + W.envDraw hat env site) ≤
            (spec.opContract hat).preCapExt site + W.envCap site := fun site => by
          show ((spec.opComp hat).drawExt s site + 0) + W.envDraw hat env site ≤
            (spec.opContract hat).preCapExt site + W.envCap site
          rw [Nat.add_zero]
          exact Nat.add_le_add (wS.2.1 site) (W.env_within env envOk hat site)
        refine ⟨rfl, hK', fun site => ?_⟩
        refine OpenComposition.substrate_margin_step (W.G_rises hat) hH_le
          ((spec.opContract hat).eta_bound s' hK') post_viable warn_margin hMarg site ?_
        intro below
        have hWarn : (spec.opComp hat).emitAlarm s o = true :=
          (spec.opContract hat).emits_on_warn s o hK (obs_detects x site below)
        have hAl : al = true := by
          show channel ((spec.opComp hat).emitAlarm s o) ((spec.opComp hat).silenceLoad s) env = true
          rw [hWarn]
          exact channel_fires _ env envOk wS.2.2.1
        refine ⟨fun h0 => ?_, fun hpos => ?_⟩
        · have hEta0' : (spec.opContract hat).eta s' = 0 := by
            show (spec.opContract hat).eta ((spec.opComp hat).next s (o, al) d) = 0
            rw [hAl]
            exact (spec.opContract hat).eta_alarm_zero s o d (tolOk (o, true)) hK h0
          exact ⟨hEta0', fun k => by
            show ((spec.opComp hat).drawExt s k + 0) + W.envDraw hat env k ≤ H_safe k
            rw [Nat.add_zero]
            exact Nat.le_trans (Nat.add_le_add ((wS.2.2.2 h0).2.2 k) (W.env_within env envOk hat k))
              (post_allowance k)⟩
        · show (spec.opContract hat).eta ((spec.opComp hat).next s (o, al) d) + 1 ≤
              (spec.opContract hat).eta s
          rw [hAl]
          exact (spec.opContract hat).eta_alarm_step s o d (tolOk (o, true)) hK hpos
  have hInitInv : ExploreMarginInv W spec θ x_crit (x₀, inquiryInit spec) := by
    dsimp only [inquiryInit]
    cases hHor : spec.horizon with
    | zero =>
      have hHat : spec.infer [] = θ := by
        have hId := probe_identifies (fun _ => x_crit)
          (fun _ hlt => absurd hlt (hHor ▸ Nat.not_lt_zero _))
        rw [hHor] at hId
        exact hId
      have hCongr := opContract_K_eta_congr spec.opComp spec.opInit spec.opContract hHat
      refine ⟨hHat, hCongr.1, fun site => ?_⟩
      have hBoundOp : (spec.opContract θ).eta (spec.opInit θ) ≤ (spec.opContract θ).maxLag + 1 :=
        Nat.le_trans ((spec.opContract θ).eta_bound _ (spec.opContract θ).init_in) (Nat.le_succ _)
      show x_crit site + (spec.opContract θ).eta (spec.opInit (spec.infer [])) *
          ((spec.opContract θ).preCapExt site + W.envCap site) ≤ x₀ site
      rw [hCongr.2]
      have hM := init_margin site
      rw [hHor, Nat.zero_mul, Nat.add_zero] at hM
      exact Nat.le_trans (Nat.add_le_add_left (Nat.mul_le_mul_right _ hBoundOp) _) hM
    | succ h =>
      refine ⟨hHor ▸ Nat.zero_lt_succ h,
        ⟨fun _ => x_crit, fun _ hlt => absurd hlt (Nat.not_lt_zero _), rfl⟩,
        fun site => ?_⟩
      rw [Nat.sub_zero, ← hHor]
      exact init_margin site
  exact ⟨hCert, hCert.kernel hInitInv⟩

/-- **Epistemic Silence Floor (Untaken Probe Underdetermination)**:
Bridges `Becoming.causal_underdetermined_of_untaken` with a shared determined passive model
`C₂.passive` and prefix-causal passive policy `policy`: while an identifying intervention
`(k_probe, a_probe)` is untaken along passive run `r` (`FactorsThrough C₁.passive π C₂.passive`),
two causal models `D₁, D₂` explain `r` identically through `t` while disagreeing on the probe,
and `obsFrag` matches `obsBenign` above `H_safe + y_safe`. Thus `policy` draws `≥ H_pre` in the
fragile world too, crossing below no-return `H_safe + y_safe` by step `≤ n` and hitting `0` even
with a zero-lag switch to `H_safe` after crossing. -/
theorem exploration_untaken_silence_collapse
    {S A I Q Obs P : Type}
    {C₁ : CausalSystem S A I} (C₂ : CausalSystem Q A Bool)
    {π : S → Q} {ω : I → Bool} (hobs : C₂.obs = false) (hω_obs : ω C₁.obs = false)
    (h_hit : ∃ j₀, ω j₀ = true)
    (r : Run C₁.passive) (r_benign : Run C₂.passive)
    (start_q : r_benign.state 0 = π (r.state 0))
    (same_act : ∀ s, r_benign.act s = r.act s)
    {t : Nat} {k_probe : Q} {a_probe : A}
    (law : ∃ Proc : Process Q A, Determined Proc ∧ r.StepsThrough π Proc t)
    (untaken : ¬ r.TakesThrough π t k_probe a_probe)
    (hdet_obs : Determined C₂.passive) (hdet_int : Determined (C₂.proc true))
    (hf_obs : FactorsThrough C₁.passive π C₂.passive)
    {κ₁ κ₂ : Q} (two : κ₁ ≠ κ₂)
    {Y H_pre H_safe y_safe n : Nat}
    (g_frag : Nat → Nat) (x_frag : Nat → Nat)
    (policy : Nat → (Nat → Obs) → P) (draw : P → Nat)
    (non_ant : ∀ s o₁ o₂, (∀ j, j ≤ s → o₁ j = o₂ j) → policy s o₁ = policy s o₂)
    (readObs : Q → Obs)
    (obsFrag : Nat → Obs)
    (obs_masked : ∀ s, H_safe + y_safe ≤ x_frag s → obsFrag s = readObs (π (r.state s)))
    (step_frag : ∀ s, x_frag (s + 1) =
      RegimeMargin.step g_frag (draw (policy s obsFrag)) (x_frag s))
    (most : RegimeMargin.AtMost g_frag Y) (yle : Y < H_pre)
    (short : RegimeMargin.Short g_frag H_safe y_safe)
    (nothing : RegimeMargin.FromNothing g_frag) (hPos : 0 < H_safe + y_safe)
    (benign_high : ∀ s, H_pre ≤ draw (policy s (fun k => readObs (r_benign.state k))))
    (post_safe : ∀ s, x_frag s < H_safe + y_safe →
      H_safe ≤ draw (policy s obsFrag))
    (under_headroom : x_frag 0 < (H_safe + y_safe) + (H_pre - Y) * n) :
    ((¬ ∃ κ, r.FixesThrough π t k_probe a_probe κ) ∧
     ∃ (j₀ : I) (D₁ D₂ : CausalSystem Q A Bool),
       ω j₀ = true ∧ (D₁.proc (ω j₀)).step k_probe a_probe κ₁ ∧
       (D₂.proc (ω j₀)).step k_probe a_probe κ₂ ∧
       r.StepsThrough π D₁.passive t ∧ r.StepsThrough π D₂.passive t) ∧
    (∃ T, T ≤ n ∧ x_frag T < H_safe + y_safe ∧
      (∀ k, x_frag (T + k) < H_safe + y_safe) ∧
      (x_frag (T + x_frag T) = 0 ∧ ∀ m, x_frag (T + x_frag T + m) = 0)) := by
  have hCausal := causal_underdetermined_of_untaken C₂ hobs hω_obs h_hit r law untaken
    hdet_obs hdet_int hf_obs two
  have hProj : ∀ s, π (r.state s) = r_benign.state s := by
    intro s
    induction s with
    | zero => exact start_q.symm
    | succ s ih =>
      have hs1 : C₂.passive.step (π (r.state s)) (r.act s) (π (r.state (s + 1))) :=
        hf_obs _ _ _ (r.step s)
      have hs2 : C₂.passive.step (π (r.state s)) (r.act s) (r_benign.state (s + 1)) := by
        rw [ih, ← same_act s]
        exact r_benign.step s
      exact hdet_obs _ _ _ _ hs1 hs2
  let obsBenign : Nat → Obs := fun k => readObs (r_benign.state k)
  let dSeq : Nat → Nat := fun s => draw (policy s obsFrag)
  let gainSeq : Nat → Nat := fun s => g_frag (x_frag s - dSeq s)
  have hDge : ∀ s, s < n → (∀ j, j ≤ s → H_safe + y_safe ≤ x_frag j) → H_pre ≤ dSeq s := by
    intro s _ hab
    have hPreEq : ∀ j, j ≤ s → obsFrag j = obsBenign j := fun j hj =>
      (obs_masked j (hab j hj)).trans (congrArg readObs (hProj j))
    have hPol : policy s obsFrag = policy s obsBenign := non_ant s obsFrag obsBenign hPreEq
    show H_pre ≤ draw (policy s obsFrag)
    rw [hPol]
    exact benign_high s
  obtain ⟨T, hT_le, hT_lt⟩ := varDraw_falls_within_while step_frag
    (fun s => most (x_frag s - dSeq s))
    (fun s hlt => by
      show g_frag (x_frag s - dSeq s) = 0
      rw [sub_eq_zero_of_le (Nat.le_of_lt hlt)]
      exact nothing)
    (Nat.le_of_lt yle) n hDge hPos under_headroom
  have hCol := varDraw_short_collapses (b_nr := H_safe + y_safe) (T := T) step_frag hPos
    (fun s _ hlt _ => by
      show g_frag (x_frag s - dSeq s) = 0
      rw [sub_eq_zero_of_le (Nat.le_of_lt hlt)]
      exact nothing)
    (fun s _ hge hlt_b => by
      have hd_safe : H_safe ≤ dSeq s := post_safe s hlt_b
      have hlt_sub : x_frag s - dSeq s < y_safe := sub_lt_of_lt_add hd_safe hge hlt_b
      exact Nat.lt_of_lt_of_le (short (x_frag s - dSeq s) hlt_sub) hd_safe)
    hT_lt
  refine ⟨⟨hCausal.1, ?_⟩, T, hT_le, hT_lt, fun k => (hCol.1 k).1, hCol.2⟩
  obtain ⟨j₀, D₁, D₂, hj₀, _, _, _, _, hS₁, hS₂, hSt₁, hSt₂, _, _⟩ := hCausal.2
  exact ⟨j₀, D₁, D₂, hj₀, hSt₁, hSt₂, hS₁, hS₂⟩

/-- **Passive Learnability Underdetermination (`Learnable` × `LearnableRuns`)**:
Where passive dynamics `next` registers two runs `r, r'` identically along `reg` while their
underlying regime feature `val` differs at arbitrarily late steps (and for stationary/still
configs `s, s'`), NO extrapolation predicts on both runs (`¬ LearnableRuns.Predicts ...`),
NO predictor predicts both orbits (`¬ Learnable.Predicts ...`), and NO record-fixed limit guess
tracks `val` on both runs (`¬ (Limit.Tracks ...)`). -/
theorem learnable_passive_underdetermined
    {S R V : Type} {next : S → S} {reg : S → R} {val : S → V}
    (pred : List R → Option V)
    {r r' : Run (Law.process next)}
    (alike : Alike (Law.frameBy next reg) (Law.frameBy next reg) (r.state 0) (r'.state 0))
    (differ : ∀ T, ∃ t, T ≤ t ∧ val (r.state t) ≠ val (r'.state t))
    (g : Nat → Run (Law.process next) → Option V)
    (fixed : LearnableRuns.FixedThrough reg g) :
    ¬ (LearnableRuns.Predicts reg val pred r ∧ LearnableRuns.Predicts reg val pred r') ∧
    ¬ (Learnable.Predicts next reg val pred (r.state 0) ∧
       Learnable.Predicts next reg val pred (r'.state 0)) ∧
    ¬ Limit.Tracks g (fun k run => some (val (run.state k))) := by
  have hRuns := LearnableRuns.not_predicts_on_both pred alike differ
  have hOrb : ¬ (Learnable.Predicts next reg val pred (r.state 0) ∧
      Learnable.Predicts next reg val pred (r'.state 0)) := by
    intro h
    exact hRuns ⟨(LearnableRuns.predicts_iff r).mpr h.1, (LearnableRuns.predicts_iff r').mpr h.2⟩
  have hTracks : ¬ Limit.Tracks g (fun k run => some (val (run.state k))) := by
    intro htr
    obtain ⟨T, hAgree⟩ := LearnableRuns.agree_of_tracks fixed htr alike
    obtain ⟨t, ht_ge, hne⟩ := differ T
    exact hne (hAgree t ht_ge)
  exact ⟨hRuns, hOrb, hTracks⟩

/-- **Limit-Identification Delay Obstruction (`LimitVerification` × `RegimeMargin`)**:
Even when a record-fixed estimator `g` identifies `H` in the limit (`Limit.Identifies g H`,
so `Limit.Verifies (Limit.says g (H r_benign)) ...` holds), two runs `r_benign, r_frag` agreeing
up to horizon `D` (`Run.AgreeUpTo D`) receive identical estimates `g t r_frag = g t r_benign`
at every `t ≤ D`. Thus any draw policy driven by `g t r` that draws `≥ H_pre > Y` on `r_benign`
collapses `x_frag` below no-return `H_safe + y_safe` within `D` steps (and to `0`) before limit
identification can separate them. -/
theorem limit_passive_delay_obstruction
    {S A Θ P : Type} [DecidableEq Θ] {Proc : Process S A}
    (g : Nat → Run Proc → Option Θ) (H : Run Proc → Θ)
    (ident : Limit.Identifies g (fun r => some (H r)))
    (byRec : ∀ k (r r' : Run Proc), r.AgreeUpTo k r' → g k r = g k r')
    {D : Nat} (r_benign r_frag : Run Proc)
    (agree : r_benign.AgreeUpTo D r_frag)
    (g_frag : Nat → Nat) (x_frag : Nat → Nat)
    (policy : Nat → Option Θ → P) (draw : P → Nat)
    {Y H_pre H_safe y_safe : Nat}
    (step_eq : ∀ t, x_frag (t + 1) =
      RegimeMargin.step g_frag (draw (policy t (g t r_frag))) (x_frag t))
    (most : RegimeMargin.AtMost g_frag Y) (yle : Y < H_pre)
    (short : RegimeMargin.Short g_frag H_safe y_safe)
    (nothing : RegimeMargin.FromNothing g_frag) (hPos : 0 < H_safe + y_safe)
    (benign_high : ∀ t, t < D → H_pre ≤ draw (policy t (g t r_benign)))
    (post_safe : ∀ t, x_frag t < H_safe + y_safe → H_safe ≤ draw (policy t (g t r_frag)))
    (under_headroom : x_frag 0 < (H_safe + y_safe) + (H_pre - Y) * D) :
    Limit.Verifies (Limit.says g (some (H r_benign))) (fun r => some (H r) = some (H r_benign)) ∧
    (∀ t, t ≤ D → g t r_frag = g t r_benign) ∧
    ∃ T, T ≤ D ∧ x_frag T < H_safe + y_safe ∧
      (x_frag (T + x_frag T) = 0 ∧ ∀ m, x_frag (T + x_frag T + m) = 0) := by
  have hVer := Limit.identifies_verifies ident (some (H r_benign))
  have hEq : ∀ t, t ≤ D → g t r_frag = g t r_benign := fun t ht =>
    (byRec t r_benign r_frag (agree.mono ht)).symm
  let dSeq : Nat → Nat := fun t => draw (policy t (g t r_frag))
  have hDge : ∀ t, t < D → (∀ j, j ≤ t → H_safe + y_safe ≤ x_frag j) → H_pre ≤ dSeq t := by
    intro t ht _
    show H_pre ≤ draw (policy t (g t r_frag))
    rw [hEq t (Nat.le_of_lt ht)]
    exact benign_high t ht
  obtain ⟨T, hT_le, hT_lt⟩ := varDraw_falls_within_while step_eq
    (fun t => most (x_frag t - dSeq t))
    (fun t hlt => by
      show g_frag (x_frag t - dSeq t) = 0
      rw [sub_eq_zero_of_le (Nat.le_of_lt hlt)]
      exact nothing)
    (Nat.le_of_lt yle) D hDge hPos under_headroom
  have hCol := varDraw_short_collapses (b_nr := H_safe + y_safe) (T := T) step_eq hPos
    (fun t _ hlt _ => by
      show g_frag (x_frag t - dSeq t) = 0
      rw [sub_eq_zero_of_le (Nat.le_of_lt hlt)]
      exact nothing)
    (fun t _ hge hlt_b => by
      have hd_safe : H_safe ≤ dSeq t := post_safe t hlt_b
      have hlt_sub : x_frag t - dSeq t < y_safe := sub_lt_of_lt_add hd_safe hge hlt_b
      exact Nat.lt_of_lt_of_le (short (x_frag t - dSeq t) hlt_sub) hd_safe)
    hT_lt
  exact ⟨hVer, hEq, T, hT_le, hT_lt, hCol.2⟩

/-- **Exploration-Margin Deadline Impossibility (`TimedResponse.answer_alike_before` × `RegimeMargin`)**:
When distinguishing benign `(L, W)` from fragile `(L', W')` has not reached monitor `g_mon` by
`D_probe` (`¬ TimedResponse.ReachedBy L L' W obs_web source g_mon D_probe`), any step-wise
exploration policy `policy t (readStep · t)` driven through `W.AlikeThroughUpTo` sees identical
readouts `readStep W'.level t = readStep W.level t` for all `t ≤ D_probe`. Hence benign
exploration draws `≥ H_explore` force identical fragile draws across `D_probe`, collapsing `x_frag`
below `H_safe + y_safe` during exploration (`T ≤ D_probe`) and to `0` even with an immediate switch
to `H_safe` at `D_probe`. -/
theorem exploration_deadline_impossibility
    {F C Obs P : Type} {L L' : Flow F C} {W W' : Web F C}
    {obs_web : F → C → Prop} {source : Nat → F → Prop} {g_mon : F}
    {D_probe : Nat}
    (balanced : ∀ t, t < D_probe → ∀ c, W.level (t+1) c + L.taken t c = W.level t c + L.given t c)
    (balanced' : ∀ t, t < D_probe → ∀ c, W'.level (t+1) c + L'.taken t c = W'.level t c + L'.given t c)
    (present : ∀ t, t < D_probe → L.present t = L'.present t)
    (start : ∀ c, W.level 0 c = W'.level 0 c)
    (responds : ∀ t, t < D_probe → ∀ h, ¬ source t h →
      W.AlikeThroughUpTo obs_web h W.level W'.level t →
      ∀ c, L.take t h c = L'.take t h c ∧ L.give t h c = L'.give t h c)
    (readStep : (Nat → C → Nat) → Nat → Obs)
    (through : ∀ t, t ≤ D_probe → ∀ l l',
      W.AlikeThroughUpTo obs_web g_mon l l' t → readStep l t = readStep l' t)
    (unreached : ¬ TimedResponse.ReachedBy L L' W obs_web source g_mon D_probe)
    (g_frag : Nat → Nat) (x_frag : Nat → Nat)
    (policy : Nat → Obs → P) (draw : P → Nat)
    {Y H_explore H_safe y_safe : Nat}
    (step_eq : ∀ t, x_frag (t + 1) =
      RegimeMargin.step g_frag (draw (policy t (readStep W'.level t))) (x_frag t))
    (most : RegimeMargin.AtMost g_frag Y) (yle : Y < H_explore)
    (short : RegimeMargin.Short g_frag H_safe y_safe)
    (nothing : RegimeMargin.FromNothing g_frag) (hPos : 0 < H_safe + y_safe)
    (benign_explore_ge : ∀ t, t < D_probe → H_explore ≤ draw (policy t (readStep W.level t)))
    (post_safe_ge : ∀ t, D_probe ≤ t → H_safe ≤ draw (policy t (readStep W'.level t)))
    (under_headroom : x_frag 0 < (H_safe + y_safe) + (H_explore - Y) * D_probe) :
    (∀ t, t ≤ D_probe → readStep W.level t = readStep W'.level t) ∧
    ∃ T, T ≤ D_probe ∧ x_frag T < H_safe + y_safe ∧
      (x_frag (T + x_frag T) = 0 ∧ ∀ m, x_frag (T + x_frag T + m) = 0) := by
  have hAlike : ∀ t, t ≤ D_probe → readStep W.level t = readStep W'.level t := by
    intro t ht
    exact TimedResponse.answer_alike_before
      (fun s hs => balanced s (Nat.lt_of_lt_of_le hs ht))
      (fun s hs => balanced' s (Nat.lt_of_lt_of_le hs ht))
      (fun s hs => present s (Nat.lt_of_lt_of_le hs ht))
      start
      (fun s hs => responds s (Nat.lt_of_lt_of_le hs ht))
      (fun l => readStep l t) (through t ht)
      (fun hR => unreached (TimedResponse.reachedBy_mono ht hR))
  let dSeq : Nat → Nat := fun t => draw (policy t (readStep W'.level t))
  have hDge : ∀ t, t < D_probe → (∀ j, j ≤ t → H_safe + y_safe ≤ x_frag j) → H_explore ≤ dSeq t := by
    intro t ht _
    show H_explore ≤ draw (policy t (readStep W'.level t))
    rw [← hAlike t (Nat.le_of_lt ht)]
    exact benign_explore_ge t ht
  obtain ⟨T, hT_le, hT_lt⟩ := varDraw_falls_within_while step_eq
    (fun t => most (x_frag t - dSeq t))
    (fun t hlt => by
      show g_frag (x_frag t - dSeq t) = 0
      rw [sub_eq_zero_of_le (Nat.le_of_lt hlt)]
      exact nothing)
    (Nat.le_of_lt yle) D_probe hDge hPos under_headroom
  have hCol := varDraw_short_collapses (b_nr := H_safe + y_safe) (T := T) step_eq hPos
    (fun t _ hlt _ => by
      show g_frag (x_frag t - dSeq t) = 0
      rw [sub_eq_zero_of_le (Nat.le_of_lt hlt)]
      exact nothing)
    (fun t _ hge hlt_b => by
      cases Nat.lt_or_ge t D_probe with
      | inl hlt_D =>
        have hd_exp : H_explore ≤ dSeq t := by
          show H_explore ≤ draw (policy t (readStep W'.level t))
          rw [← hAlike t (Nat.le_of_lt hlt_D)]
          exact benign_explore_ge t hlt_D
        exact Nat.lt_of_lt_of_le (Nat.lt_of_le_of_lt (most (x_frag t - dSeq t)) yle) hd_exp
      | inr hge_D =>
        have hd_safe : H_safe ≤ dSeq t := post_safe_ge t hge_D
        have hlt_sub : x_frag t - dSeq t < y_safe := sub_lt_of_lt_add hd_safe hge hlt_b
        exact Nat.lt_of_lt_of_le (short (x_frag t - dSeq t) hlt_sub) hd_safe)
    hT_lt
  exact ⟨hAlike, T, hT_le, hT_lt, hCol.2⟩

/-! ### Witness 1: `ActiveProbeWitness` (Active Probing vs. Passive Silence & Low-Headroom Tradeoff) -/

namespace ActiveProbeWitness

def gRegime (θ : Bool) (z : Nat) : Nat :=
  if θ then (if 2 ≤ z then 3 else 0) else (if 4 ≤ z then 2 else 0)

theorem gRegime_rises (θ : Bool) :
    ∀ _site : Unit, RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole
      (fun e => gRegime θ (e ())) := by
  intro _ e₁ e₂ hbelow
  cases θ with
  | true =>
    dsimp only [gRegime]
    cases Nat.decLe 2 (e₁ ()) with
    | isTrue h =>
      rw [if_pos h, if_pos (Nat.le_trans h (hbelow ()))]
      exact Nat.le_refl 3
    | isFalse h =>
      rw [if_neg h]
      exact Nat.zero_le _
  | false =>
    dsimp only [gRegime]
    cases Nat.decLe 4 (e₁ ()) with
    | isTrue h =>
      rw [if_pos h, if_pos (Nat.le_trans h (hbelow ()))]
      exact Nat.le_refl 2
    | isFalse h =>
      rw [if_neg h]
      exact Nat.zero_le _

def world : RegimeWorld Bool Unit Bool Bool Unit Unit where
  G θ _ e := gRegime θ (e ())
  G_rises θ site := gRegime_rises θ site
  probeObs θ _ x := Nat.ble 3 (gRegime θ (x () - 4))
  opObs _ x := Nat.ble 12 (x ())
  envDraw _ _ _ := 0
  envCap _ := 0
  jointAdm _ := True
  env_within _ _ _ _ := Nat.le_refl 0

def opComp (b : Bool) : OpenComposition.OpenComponent Nat Bool Unit Empty Unit :=
  OpenComposition.countdownComponent 3 (if b then 3 else 2) (fun _ o => !o)

def opContract (b : Bool) : OpenComposition.InterfaceContract (opComp b) 1 :=
  OpenComposition.countdownContract 3 (if b then 3 else 2) 0 1 1
    (fun _ o => !o)
    (fun o => o = false)
    (by cases b <;> decide)
    (Nat.le_refl 1)
    (fun _ o _ ho => by rw [ho]; rfl)

def spec : ActiveInquirySpec Bool Unit Bool Nat Bool Unit Empty Unit where
  horizon := 2
  plan _ := ()
  probeDraw _ := 4
  probeStepDraw _ _ _ := 4
  probeDraw_le _ _ _ := Nat.le_refl 4
  infer
    | (_, o₀) :: _ => o₀
    | [] => true
  opComp := opComp
  opInit _ := 1
  opContract := opContract
  opMaxLag := 1
  opLag_le _ := Nat.le_refl 1

def channel (em : Bool) (_ : Nat) (_ : Unit) : Bool := em

def xCrit : Unit → Nat := fun _ => 6
def warnLvl : Unit → Nat := fun _ => 12
def hSafe (θ : Bool) : Unit → Nat := fun _ => if θ then 3 else 2
def xStart20 : Unit → Nat := fun _ => 20
def xStart9 : Unit → Nat := fun _ => 9

theorem probe_identifies_both (θ : Bool) :
    ∀ xs : Nat → Unit → Nat,
      (∀ t, t < spec.horizon → ∀ site, xCrit site ≤ xs t site) →
      spec.infer (probeTranscript world spec.plan θ xs spec.horizon) = θ := by
  intro xs hxs
  have h0 : 6 ≤ xs 0 () := hxs 0 (by decide) ()
  have hsub : 2 ≤ xs 0 () - 4 := Naturals.le_sub_of_add_le (Nat.add_comm 2 4 ▸ h0)
  cases θ with
  | true =>
    have hg : gRegime true (xs 0 () - 4) = 3 := if_pos hsub
    have hobs0 : world.probeObs true () (xs 0) = true := by
      show Nat.ble 3 (gRegime true (xs 0 () - 4)) = true
      rw [hg]
      rfl
    show spec.infer [((), world.probeObs true () (xs 0)), ((), world.probeObs true () (xs 1))] = true
    rw [hobs0]
    rfl
  | false =>
    have hg : gRegime false (xs 0 () - 4) ≤ 2 := by
      dsimp only [gRegime]
      cases Nat.decLe 4 (xs 0 () - 4) with
      | isTrue h => rw [if_pos h]; exact Nat.le_refl 2
      | isFalse h => rw [if_neg h]; exact Nat.zero_le 2
    have hobs0 : world.probeObs false () (xs 0) = false :=
      Naturals.ble_false_of_lt (Nat.lt_of_le_of_lt hg (by decide))
    show spec.infer [((), world.probeObs false () (xs 0)), ((), world.probeObs false () (xs 1))] = false
    rw [hobs0]
    rfl

theorem active_probing_viable (θ : Bool) :
    Viability.Kernel
      (PolyComposition.polyClosedProcess
        (inquiryPolyComponent spec) (fun _ site => [site])
        (inquiryContract spec)
        (inquiryWorldObs world spec θ) channel (world.G θ) (world.envDraw θ) world.jointAdm)
      (PolyComposition.polyClosedGuard (inquiryPolyComponent spec) (inquiryContract spec) xCrit)
      (xStart20, inquiryInit spec) := by
  refine (exploration_margin_sandwich_viable world spec θ channel xCrit warnLvl (hSafe θ) xStart20
    (probe_identifies_both θ) ?_ ?_ ?_ ?_ ?_ ?_).2
  · intro x site hlt
    cases site
    show Nat.ble 12 (x ()) = false
    exact Naturals.ble_false_of_lt hlt
  · intro _ _ _ _
    rfl
  · intro site
    cases site
    cases θ <;> decide
  · intro site
    cases site
    cases θ <;> decide
  · intro site
    cases site
    cases θ <;> decide
  · intro site
    cases site
    cases θ <;> decide

def passiveFragStep (x : Nat) : Nat :=
  RegimeMargin.step (gRegime false) (if 5 ≤ x then 3 else 2) x

def passiveFragOrbit : Nat → Nat := Law.orbit passiveFragStep 20

theorem passive_exploit_crashes : passiveFragOrbit 17 = 0 := rfl

def lowProbeFragStep (t_x : Nat × Nat) : Nat × Nat :=
  let draw := if t_x.1 < 2 then 4 else 2
  (t_x.1 + 1, RegimeMargin.step (gRegime false) draw t_x.2)

def lowProbeFragOrbit : Nat → Nat × Nat := Law.orbit lowProbeFragStep (0, 9)

theorem low_headroom_probe_crashes : (lowProbeFragOrbit 4).2 = 0 := rfl

theorem low_headroom_safe_holds (n : Nat) :
    (Law.orbit (RegimeMargin.step (gRegime false) 2) 9 n) = 9 := by
  induction n with
  | zero => rfl
  | succ n ih =>
    show RegimeMargin.step (gRegime false) 2 (Law.orbit (RegimeMargin.step (gRegime false) 2) 9 n) = 9
    rw [ih]
    rfl

end ActiveProbeWitness

/-! ## Part 2: Information-Cascade Capture of Composed Pools -/

/-- Right-associated observation vector fed by a `Turns` protocol to `composeListComponent`. -/
def cascadeListObs {O A Ext : Type}
    (T : Turns (Ext → Nat) O A) (head : Nat) :
    (tail : List Nat) → (Ext → Nat) → OpenComposition.ListCarrier A tail
  | [], x => T.act x head
  | next :: rest, x => (T.act x head, cascadeListObs T next rest x)

/-- Indexed observation vector over arbitrary list `head :: tail` without cascade copying. -/
def composeListObsIndexed {α Obs Ext : Type} (obsFn : α → (Ext → Nat) → Obs) (head : α) :
    (tail : List α) → (Ext → Nat) → OpenComposition.ListCarrier Obs tail
  | [], x => obsFn head x
  | next :: rest, x => (obsFn head x, composeListObsIndexed obsFn next rest x)

/-- Independent local-sensor observation vector bypassing cascade copying (`T.coupling i x`). -/
def independentListObs {O A Ext : Type}
    (T : Turns (Ext → Nat) O A) (head : Nat) (tail : List Nat) (x : Ext → Nat) :
    OpenComposition.ListCarrier O tail :=
  composeListObsIndexed T.coupling head tail x

theorem composeList_warnObs_of_mem {α S Obs Dist Int Ext : Type}
    {comp : α → OpenComposition.OpenComponent S Obs Dist Int Ext} {init : α → S}
    (contract : (i : α) → OpenComposition.InterfaceContract (comp i) (init i))
    {obsFn : α → (Ext → Nat) → Obs} {x : Ext → Nat} :
    ∀ (tail : List α) (head : α),
      (∃ i, i ∈ head :: tail ∧ (contract i).warnObs (obsFn i x)) →
      (OpenComposition.composeListContract contract head tail).warnObs
        (composeListObsIndexed obsFn head tail x)
  | [], head, ⟨i, hi, hw⟩ => by
    have heq : i = head := ListTests.mem_singleton_iff.mp hi
    exact heq ▸ hw
  | next :: rest, head, ⟨i, hi, hw⟩ =>
    match ListTests.mem_cons_iff.mp hi with
    | .inl heq => .inl (heq ▸ hw)
    | .inr hmem => .inr (composeList_warnObs_of_mem contract rest next ⟨i, hmem, hw⟩)

/-- **Indexed List-Pool Closed Viability (`OpenComposition.close_contract_kernel`)**:
generalizes `OpenComposition.composeList_viable` so heterogeneous local sensors `obsFn i x`
(such as `independentListObs`) sustain `Viability.Kernel` whenever some member `i ∈ head :: tail`
detects drops below `warnLevel`. -/
theorem composeList_viable_indexed {α S Obs Dist Int Ext Env : Type}
    (comp : α → OpenComposition.OpenComponent S Obs Dist Int Ext) (init : α → S)
    (contract : (i : α) → OpenComposition.InterfaceContract (comp i) (init i))
    (head : α) (tail : List α)
    (obsFn : α → (Ext → Nat) → Obs)
    (channel : Bool → Nat → Env → Bool)
    (G : Ext → (Ext → Nat) → Nat)
    (envDraw : Env → Ext → Nat) (envCap : Ext → Nat) (jointAdm : Env → Prop)
    (env_within : ∀ env, jointAdm env → ∀ k, envDraw env k ≤ envCap k)
    (x_crit warnLevel H_safe x₀ : Ext → Nat)
    (obs_detects : ∀ x k, x k < warnLevel k →
      ∃ i, i ∈ head :: tail ∧ (contract i).warnObs (obsFn i x))
    (channel_fires : ∀ load env, jointAdm env →
      load ≤ OpenComposition.listSum (fun i => (contract i).maxSilence) head tail →
      channel true load env = true)
    (G_rises : ∀ k, RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (G k))
    (post_viable : ∀ k, x_crit k ≤
      RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole G H_safe x_crit k)
    (post_allowance : ∀ k,
      OpenComposition.listSum (fun i => (contract i).postBudgetExt k) head tail + envCap k ≤ H_safe k)
    (warn_margin : ∀ k, x_crit k +
      (OpenComposition.listMax (fun i => (contract i).maxLag) head tail + 1) *
        (OpenComposition.listSum (fun i => (contract i).preCapExt k) head tail + envCap k) ≤ warnLevel k)
    (init_margin : ∀ k, x_crit k +
      OpenComposition.listMax (fun i => (contract i).eta (init i)) head tail *
        (OpenComposition.listSum (fun i => (contract i).preCapExt k) head tail + envCap k) ≤ x₀ k) :
    Viability.Kernel
      (OpenComposition.closedProcess
        (OpenComposition.composeListComponent comp head tail)
        (OpenComposition.composeListContract contract head tail)
        (composeListObsIndexed obsFn head tail) channel G envDraw jointAdm)
      (OpenComposition.closedGuard
        (OpenComposition.composeListComponent comp head tail)
        (OpenComposition.composeListContract contract head tail) x_crit)
      (x₀, OpenComposition.composeListInit init head tail) :=
  OpenComposition.close_contract_kernel
    (OpenComposition.composeListComponent comp head tail)
    (OpenComposition.composeListContract contract head tail)
    (composeListObsIndexed obsFn head tail) channel G envDraw envCap jointAdm env_within
    x_crit warnLevel H_safe x₀
    (fun x k hlt => composeList_warnObs_of_mem contract tail head (obs_detects x k hlt))
    (fun load env adm hLoad =>
      channel_fires load env adm (OpenComposition.composeList_maxSilence_eq_sum contract tail head ▸ hLoad))
    G_rises post_viable
    (fun k => OpenComposition.composeList_postBudgetExt_eq_sum contract k tail head ▸ post_allowance k)
    (fun k =>
      (OpenComposition.composeList_maxLag_eq_max contract tail head).symm ▸
        ((OpenComposition.composeList_preCapExt_eq_sum contract k tail head).symm ▸ warn_margin k))
    (fun k =>
      (OpenComposition.composeList_eta_eq_max contract tail head).symm ▸
        ((OpenComposition.composeList_preCapExt_eq_sum contract k tail head).symm ▸ init_margin k))

theorem cascadeListObs_eq_of_act_eq {O A Ext : Type}
    (T : Turns (Ext → Nat) O A) {x x_safe : Ext → Nat}
    (hAct : ∀ i, T.act x i = T.act x_safe i) :
    ∀ (tail : List Nat) (head : Nat),
      cascadeListObs T head tail x = cascadeListObs T head tail x_safe
  | [], head => hAct head
  | next :: rest, head =>
    show (T.act x head, cascadeListObs T next rest x) =
      (T.act x_safe head, cascadeListObs T next rest x_safe) from
      congr (congrArg Prod.mk (hAct head)) (cascadeListObs_eq_of_act_eq T hAct rest next)

/-- **Cascade Pool Alarm Collapse (`Cascade.Turns.ReadsOnlyActsFrom`)**:
when a list-composed pool receives member acts under `T.ReadsOnlyActsFrom k`, and `x, x_safe`
agree before `k`, the entire composed pool's `emitAlarm` collapses to `x_safe`'s alarm. -/
theorem cascade_list_emitAlarm_alike {S Dist Int Ext O : Type}
    (comp : Nat → OpenComposition.OpenComponent S Bool Dist Int Ext)
    (T : Turns (Ext → Nat) O Bool) {k : Nat} (cascade : T.ReadsOnlyActsFrom k)
    {x x_safe : Ext → Nat} (alike : T.AlikeBefore k x x_safe) :
    ∀ (tail : List Nat) (head : Nat)
      (st : OpenComposition.ListCarrier S tail),
      (OpenComposition.composeListComponent comp head tail).emitAlarm st
        (cascadeListObs T head tail x) =
      (OpenComposition.composeListComponent comp head tail).emitAlarm st
        (cascadeListObs T head tail x_safe) := by
  intro tail head st
  rw [cascadeListObs_eq_of_act_eq T (fun i => Turns.act_alike_of_cascade cascade alike i) tail head]

/-- **Run-Relative Reached-Cascade Capture (`ReachedCascade.Turns.LawAlikeAlong`)**:
weakens `ReadsOnlyActsFrom k` to `T.LawAlikeAlong k x x_safe` using `Turns.act_alike_along`. -/
theorem reachedCascade_list_emitAlarm_alike {S Dist Int Ext O : Type}
    (comp : Nat → OpenComposition.OpenComponent S Bool Dist Int Ext)
    (T : Turns (Ext → Nat) O Bool) {k : Nat}
    {x x_safe : Ext → Nat} (along : T.LawAlikeAlong k x x_safe)
    (alike : T.AlikeBefore k x x_safe) :
    ∀ (tail : List Nat) (head : Nat)
      (st : OpenComposition.ListCarrier S tail),
      (OpenComposition.composeListComponent comp head tail).emitAlarm st
        (cascadeListObs T head tail x) =
      (OpenComposition.composeListComponent comp head tail).emitAlarm st
        (cascadeListObs T head tail x_safe) := by
  intro tail head st
  rw [cascadeListObs_eq_of_act_eq T (fun i => Turns.act_alike_along along alike i) tail head]

def composeListDist {Dist : Type} (d₀ : Nat → Dist) (head : Nat) :
    (tail : List Nat) → OpenComposition.ListCarrier Dist tail
  | [] => d₀ head
  | next :: rest => (d₀ head, composeListDist d₀ next rest)

theorem composeList_tol {S Obs Dist Int Ext : Type}
    {comp : Nat → OpenComposition.OpenComponent S Obs Dist Int Ext} {init : Nat → S}
    (contract : (i : Nat) → OpenComposition.InterfaceContract (comp i) (init i))
    (d₀ : Nat → Dist) (hTol : ∀ i ob, (contract i).tol ob (d₀ i)) :
    ∀ (tail : List Nat) (head : Nat) ob,
      (OpenComposition.composeListContract contract head tail).tol ob (composeListDist d₀ head tail)
  | [], head, ob => hTol head ob
  | next :: rest, head, ob =>
    ⟨hTol head (ob.1.1, ob.2), composeList_tol contract d₀ hTol rest next (ob.1.2, ob.2)⟩

theorem natMax_pos_cases {a b : Nat} (h : 0 < CoreHelpers.natMax a b) : 0 < a ∨ 0 < b := by
  dsimp only [CoreHelpers.natMax] at h
  cases hle : Nat.decLe a b with
  | isTrue htrue => rw [if_pos htrue] at h; exact .inr h
  | isFalse hfalse => rw [if_neg hfalse] at h; exact .inl h

theorem composeList_eta_kept_unwarned {S Obs Dist Int Ext : Type}
    {comp : Nat → OpenComposition.OpenComponent S Obs Dist Int Ext} {init : Nat → S}
    (contract : (i : Nat) → OpenComposition.InterfaceContract (comp i) (init i))
    (eta_kept : ∀ i s ob d, (contract i).tol (ob, false) d → 0 < (contract i).eta s →
      0 < (contract i).eta ((comp i).next s (ob, false) d)) :
    ∀ (tail : List Nat) (head : Nat) st ob d,
      (OpenComposition.composeListContract contract head tail).tol (ob, false) d →
      0 < (OpenComposition.composeListContract contract head tail).eta st →
      0 < (OpenComposition.composeListContract contract head tail).eta
        ((OpenComposition.composeListComponent comp head tail).next st (ob, false) d)
  | [], head, st, ob, d, htol, heta => eta_kept head st ob d htol heta
  | next :: rest, head, st, ob, d, htol, heta => by
    show 0 < CoreHelpers.natMax ((contract head).eta ((comp head).next st.1 (ob.1, false) d.1))
        ((OpenComposition.composeListContract contract next rest).eta
          ((OpenComposition.composeListComponent comp next rest).next st.2 (ob.2, false) d.2))
    cases natMax_pos_cases heta with
    | inl ha =>
      exact Nat.lt_of_lt_of_le (eta_kept head st.1 ob.1 d.1 htol.1 ha)
        (CoreHelpers.le_natMax_left _ _)
    | inr hb =>
      exact Nat.lt_of_lt_of_le
        (composeList_eta_kept_unwarned contract eta_kept rest next st.2 ob.2 d.2 htol.2 hb)
        (CoreHelpers.le_natMax_right _ _)

/-- **List-Pool Cascade Capture Collapse**:
Under cascade routing `T.ReadsOnlyActsFrom k` on `composeListComponent comp head tail`, if all
pre-`k` members are blind above `x_crit site_crit` (`AlikeBefore k x x_safe`) and `emitAlarm` at
`x_safe` is `false`, the entire pool stays unwarned, draws `≥ H_pre > Y`, and refutes
`Viability.Kernel` within `n` steps (requiring `DependsOn` on `site_crit` and universal `hTol`). -/
theorem cascade_list_capture_collapse {S Dist Int Ext Env O : Type}
    (comp : Nat → OpenComposition.OpenComponent S Bool Dist Int Ext)
    (init : Nat → S)
    (contract : (i : Nat) → OpenComposition.InterfaceContract (comp i) (init i))
    (head : Nat) (tail : List Nat)
    (T : Turns (Ext → Nat) O Bool) {k : Nat} (cascade : T.ReadsOnlyActsFrom k)
    (channel : Bool → Nat → Env → Bool)
    (G : Ext → (Ext → Nat) → Nat) (envDraw : Env → Ext → Nat) (jointAdm : Env → Prop)
    (x_crit x₀ x_safe : Ext → Nat) (site_crit : Ext)
    (env_adm : Env) (hAdm : jointAdm env_adm)
    (d₀ : Nat → Dist) (hTol : ∀ i ob, (contract i).tol ob (d₀ i))
    (P_inv : (Ext → Nat) × OpenComposition.ListCarrier S tail → Prop)
    (P_init : P_inv (x₀, OpenComposition.composeListInit init head tail))
    (P_step : ∀ x st, P_inv (x, st) → x_crit site_crit ≤ x site_crit →
      P_inv (OpenComposition.closedStep
        (OpenComposition.composeListComponent comp head tail)
        (cascadeListObs T head tail) channel G envDraw (x, st)
        (env_adm, composeListDist d₀ head tail)))
    (silent_channel : ∀ load env, channel false load env = false)
    (emit_false_at_safe : ∀ st,
      (OpenComposition.composeListComponent comp head tail).emitAlarm st
        (cascadeListObs T head tail x_safe) = false)
    (leaders_blind : ∀ x st, P_inv (x, st) → x_crit site_crit ≤ x site_crit →
      T.AlikeBefore k x x_safe)
    (G_most : ∀ e, G site_crit e ≤ Y)
    (G_dep : RegimeMargin.Coupled.Indexed.DependsOn RegimeMargin.Drawn.whole G site_crit site_crit)
    (H_pre : Nat) (yle : Y < H_pre)
    (draw_pre_while_silent : ∀ x st, P_inv (x, st) →
      (OpenComposition.composeListContract contract head tail).K st →
      0 < (OpenComposition.composeListContract contract head tail).eta st →
      H_pre ≤ (OpenComposition.composeListComponent comp head tail).drawExt st site_crit)
    (eta_kept_when_unwarned : ∀ i s ob d,
      (contract i).tol (ob, false) d → 0 < (contract i).eta s →
      0 < (contract i).eta ((comp i).next s (ob, false) d))
    (init_eta_pos :
      0 < (OpenComposition.composeListContract contract head tail).eta
        (OpenComposition.composeListInit init head tail))
    (n : Nat) (under_headroom : x₀ site_crit < x_crit site_crit + (H_pre - Y) * n)
    (x_crit_pos : 0 < x_crit site_crit) :
    ¬ Viability.Kernel
      (OpenComposition.closedProcess
        (OpenComposition.composeListComponent comp head tail)
        (OpenComposition.composeListContract contract head tail)
        (cascadeListObs T head tail) channel G envDraw jointAdm)
      (OpenComposition.closedGuard
        (OpenComposition.composeListComponent comp head tail)
        (OpenComposition.composeListContract contract head tail) x_crit)
      (x₀, OpenComposition.composeListInit init head tail) := by
  let compL := OpenComposition.composeListComponent comp head tail
  let contL := OpenComposition.composeListContract contract head tail
  let initL := OpenComposition.composeListInit init head tail
  let dL := composeListDist d₀ head tail
  have hTolL : ∀ ob, contL.tol ob dL := composeList_tol contract d₀ hTol tail head
  refine silent_drawdown_refutes_kernel compL contL (cascadeListObs T head tail)
    channel G envDraw jointAdm x_crit x₀ site_crit G_most G_dep yle x_crit_pos
    env_adm hAdm dL hTolL ?_ under_headroom
  intro orb t _ hab
  have hInv : ∀ j, j ≤ t →
      P_inv (orb j) ∧ contL.K (orb j).2 ∧ 0 < contL.eta (orb j).2 := by
    intro j
    induction j with
    | zero =>
      intro _
      exact ⟨P_init, contL.init_in, init_eta_pos⟩
    | succ j ih =>
      intro hj_le
      have hj_lt : j ≤ t := Nat.le_of_lt hj_le
      obtain ⟨ihP, ihK, ihEta⟩ := ih hj_lt
      have hAlike : T.AlikeBefore k (orb j).1 x_safe :=
        leaders_blind (orb j).1 (orb j).2 ihP (hab j hj_lt)
      have hEmit : compL.emitAlarm (orb j).2 (cascadeListObs T head tail (orb j).1) = false := by
        rw [cascade_list_emitAlarm_alike comp T cascade hAlike tail head (orb j).2]
        exact emit_false_at_safe (orb j).2
      have hAl : channel (compL.emitAlarm (orb j).2 (cascadeListObs T head tail (orb j).1))
          (compL.silenceLoad (orb j).2) env_adm = false := by
        rw [hEmit]
        exact silent_channel _ _
      have hNextP : P_inv (orb (j + 1)) := P_step (orb j).1 (orb j).2 ihP (hab j hj_lt)
      have hNextK : contL.K (compL.next (orb j).2
          (cascadeListObs T head tail (orb j).1,
           channel (compL.emitAlarm (orb j).2 (cascadeListObs T head tail (orb j).1))
             (compL.silenceLoad (orb j).2) env_adm) dL) := by
        let ob := (cascadeListObs T head tail (orb j).1,
          channel (compL.emitAlarm (orb j).2 (cascadeListObs T head tail (orb j).1))
            (compL.silenceLoad (orb j).2) env_adm)
        dsimp only [contL, compL] at ihK ⊢
        exact contL.cert.closed (orb j).2 (ob, dL)
          ((OpenComposition.composeListComponent comp head tail).next (orb j).2 ob dL)
          ⟨hTolL ob, rfl⟩ ihK
      have hNextEta : 0 < contL.eta (compL.next (orb j).2
          (cascadeListObs T head tail (orb j).1,
           channel (compL.emitAlarm (orb j).2 (cascadeListObs T head tail (orb j).1))
             (compL.silenceLoad (orb j).2) env_adm) dL) := by
        show 0 < contL.eta (compL.next (orb j).2 (cascadeListObs T head tail (orb j).1,
          channel (compL.emitAlarm (orb j).2 (cascadeListObs T head tail (orb j).1))
            (compL.silenceLoad (orb j).2) env_adm) dL)
        rw [hAl]
        exact composeList_eta_kept_unwarned contract eta_kept_when_unwarned tail head
          (orb j).2 (cascadeListObs T head tail (orb j).1) dL (hTolL _) ihEta
      exact ⟨hNextP, hNextK, hNextEta⟩
  obtain ⟨hPt, hKt, hEtat⟩ := hInv t (Nat.le_refl t)
  exact draw_pre_while_silent (orb t).1 (orb t).2 hPt hKt hEtat

/-- **2-Component Pool Capture Theorem (defeating `compose_close_interchange`)**:
binary specialization with heterogeneous component types `SA ≠ SB`, where Leader `A` is blind on
`site_crit` and Watcher `B` is trapped by `T.ReadsOnlyActsFrom 1`. -/
theorem cascade_pool_capture_collapse {SA SB DistA DistB IntA IntB Ext Env O : Type}
    (A : OpenComposition.OpenComponent SA Bool DistA IntA Ext)
    (B : OpenComposition.OpenComponent SB Bool DistB IntB Ext)
    {initA : SA} {initB : SB}
    (cA : OpenComposition.InterfaceContract A initA)
    (cB : OpenComposition.InterfaceContract B initB)
    (T : Turns (Ext → Nat) O Bool) (cascade : T.ReadsOnlyActsFrom 1)
    (channel : Bool → Nat → Env → Bool)
    (G : Ext → (Ext → Nat) → Nat) (envDraw : Env → Ext → Nat) (jointAdm : Env → Prop)
    (x_crit x₀ x_safe : Ext → Nat) (site_crit : Ext)
    (silent_channel : ∀ load env, channel false load env = false)
    (emit_false_at_safe : ∀ sA sB,
      (OpenComposition.OpenComponent.compose A B).emitAlarm (sA, sB)
        (T.act x_safe 0, T.act x_safe 1) = false)
    (leader_blind : ∀ x, x_crit site_crit ≤ x site_crit → T.coupling 0 x = T.coupling 0 x_safe)
    (G_most : ∀ e, G site_crit e ≤ Y)
    (G_dep : RegimeMargin.Coupled.Indexed.DependsOn RegimeMargin.Drawn.whole G site_crit site_crit)
    (H_pre : Nat) (yle : Y < H_pre)
    (draw_pre_while_silent : ∀ sA sB, cA.K sA → cB.K sB →
      0 < cA.eta sA ∨ 0 < cB.eta sB → H_pre ≤ A.drawExt sA site_crit + B.drawExt sB site_crit)
    (eta_kept_when_unwarned : ∀ sA sB (ob : Bool × Bool) dA dB,
      cA.tol (ob.1, false) dA → cB.tol (ob.2, false) dB →
      (0 < cA.eta sA ∨ 0 < cB.eta sB) →
      0 < cA.eta (A.next sA (ob.1, false) dA) ∨ 0 < cB.eta (B.next sB (ob.2, false) dB))
    (init_eta_pos : 0 < cA.eta initA ∨ 0 < cB.eta initB)
    (env_adm : Env) (hAdm : jointAdm env_adm)
    (dA₀ : DistA) (dB₀ : DistB)
    (hTol : ∀ ob, cA.tol ob dA₀ ∧ cB.tol ob dB₀)
    (n : Nat) (under_headroom : x₀ site_crit < x_crit site_crit + (H_pre - Y) * n)
    (x_crit_pos : 0 < x_crit site_crit) :
    ¬ Viability.Kernel
      (OpenComposition.closedProcess (OpenComposition.OpenComponent.compose A B)
        (OpenComposition.composeContract cA cB)
        (fun x => (T.act x 0, T.act x 1)) channel G envDraw jointAdm)
      (OpenComposition.closedGuard (OpenComposition.OpenComponent.compose A B)
        (OpenComposition.composeContract cA cB) x_crit)
      (x₀, (initA, initB)) := by
  let compAB := OpenComposition.OpenComponent.compose A B
  let contAB := OpenComposition.composeContract cA cB
  have hTolAB : ∀ ob, contAB.tol ob (dA₀, dB₀) := fun ob =>
    ⟨(hTol (ob.1.1, ob.2)).1, (hTol (ob.1.2, ob.2)).2⟩
  refine silent_drawdown_refutes_kernel compAB contAB (fun x => (T.act x 0, T.act x 1))
    channel G envDraw jointAdm x_crit x₀ site_crit G_most G_dep yle x_crit_pos
    env_adm hAdm (dA₀, dB₀) hTolAB ?_ under_headroom
  intro orb t _ hab
  have hKeta : ∀ j, j ≤ t →
      cA.K (orb j).2.1 ∧ cB.K (orb j).2.2 ∧ (0 < cA.eta (orb j).2.1 ∨ 0 < cB.eta (orb j).2.2) := by
    intro j
    induction j with
    | zero =>
      intro _
      exact ⟨cA.init_in, cB.init_in, init_eta_pos⟩
    | succ j ih =>
      intro hj_le
      have hj_lt : j ≤ t := Nat.le_of_lt hj_le
      obtain ⟨ihKA, ihKB, ihEta⟩ := ih hj_lt
      have hAlike : T.AlikeBefore 1 (orb j).1 x_safe := fun m hm => by
        cases m with
        | zero => exact leader_blind (orb j).1 (hab j hj_lt)
        | succ m' => exact absurd (Nat.lt_of_succ_lt_succ hm) (Nat.not_lt_zero m')
      have hAct0 : T.act (orb j).1 0 = T.act x_safe 0 :=
        Turns.act_alike_of_cascade cascade hAlike 0
      have hAct1 : T.act (orb j).1 1 = T.act x_safe 1 :=
        Turns.act_alike_of_cascade cascade hAlike 1
      have hEmit : compAB.emitAlarm (orb j).2 (T.act (orb j).1 0, T.act (orb j).1 1) = false := by
        rw [hAct0, hAct1]
        exact emit_false_at_safe (orb j).2.1 (orb j).2.2
      have hAl : channel (compAB.emitAlarm (orb j).2 (T.act (orb j).1 0, T.act (orb j).1 1))
          (compAB.silenceLoad (orb j).2) env_adm = false := by
        rw [hEmit]
        exact silent_channel _ _
      have hNextK : contAB.K (compAB.next (orb j).2
          ((T.act (orb j).1 0, T.act (orb j).1 1),
           channel (compAB.emitAlarm (orb j).2 (T.act (orb j).1 0, T.act (orb j).1 1))
             (compAB.silenceLoad (orb j).2) env_adm) (dA₀, dB₀)) := by
        let ob := ((T.act (orb j).1 0, T.act (orb j).1 1),
          channel (compAB.emitAlarm (orb j).2 (T.act (orb j).1 0, T.act (orb j).1 1))
            (compAB.silenceLoad (orb j).2) env_adm)
        dsimp only [contAB, compAB] at ihKA ihKB ⊢
        exact contAB.cert.closed (orb j).2 (ob, (dA₀, dB₀))
          ((OpenComposition.OpenComponent.compose A B).next (orb j).2 ob (dA₀, dB₀))
          ⟨hTolAB ob, rfl⟩ ⟨ihKA, ihKB⟩
      have hNextEta :
          0 < cA.eta (A.next (orb j).2.1 (T.act (orb j).1 0,
            channel (compAB.emitAlarm (orb j).2 (T.act (orb j).1 0, T.act (orb j).1 1))
              (compAB.silenceLoad (orb j).2) env_adm) dA₀) ∨
          0 < cB.eta (B.next (orb j).2.2 (T.act (orb j).1 1,
            channel (compAB.emitAlarm (orb j).2 (T.act (orb j).1 0, T.act (orb j).1 1))
              (compAB.silenceLoad (orb j).2) env_adm) dB₀) := by
        rw [hAl]
        exact eta_kept_when_unwarned (orb j).2.1 (orb j).2.2 (T.act (orb j).1 0, T.act (orb j).1 1)
          dA₀ dB₀ (hTol _).1 (hTol _).2 ihEta
      exact ⟨hNextK.1, hNextK.2, hNextEta⟩
  obtain ⟨hKA, hKB, hEtat⟩ := hKeta t (Nat.le_refl t)
  exact draw_pre_while_silent (orb t).2.1 (orb t).2.2 hKA hKB hEtat

/-! ### Witness 2: `CascadePoolWitness` (3-Agent Pool Capture vs. `composeList_viable_indexed`) -/

namespace CascadePoolWitness

def gPool (site : Bool) (e : Bool → Nat) : Nat := if 2 ≤ e site then 1 else 0

theorem gPool_rises :
    ∀ site : Bool, RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (gPool site) := by
  intro site e₁ e₂ hbelow
  dsimp only [gPool]
  cases Nat.decLe 2 (e₁ site) with
  | isTrue h => rw [if_pos h, if_pos (Nat.le_trans h (hbelow site))]; exact Nat.le_refl 1
  | isFalse h => rw [if_neg h]; exact Nat.zero_le _

theorem gPool_dep_true :
    RegimeMargin.Coupled.Indexed.DependsOn RegimeMargin.Drawn.whole gPool true true := by
  intro e he
  show (if 2 ≤ e true then 1 else 0) = 0
  rw [he]
  rfl

def memberComp (i : Nat) : OpenComposition.OpenComponent Nat Bool Unit Empty Bool where
  next s oa _ := if oa.2 then s - 1 else s
  drawInt _ e := Empty.elim e
  drawExt s site :=
    match i, site with
    | _, false => 0
    | 0, true => 1
    | _ + 1, true => if s = 0 then 0 else 1
  emitAlarm _ o := o
  silenceLoad _ := 0
  favours s := 0 < s

def memberContract (i : Nat) : OpenComposition.InterfaceContract (memberComp i) 1 where
  tol _ _ := True
  warnObs o := o = true
  preCapInt e := Empty.elim e
  preCapExt site := match site with | false => 0 | true => 1
  postBudgetInt e := Empty.elim e
  postBudgetExt site := match i, site with
    | _, false => 0
    | 0, true => 1
    | _ + 1, true => 0
  maxSilence := 0
  maxLag := 1
  K s := s ≤ 1
  eta s := s
  init_in := Nat.le_refl 1
  cert := Viability.certificate_disturbed_iff.mpr
    ⟨fun s _ =>
      ⟨fun e => Empty.elim e,
       fun site => by
         cases site with
         | false => exact Nat.le_refl 0
         | true =>
           cases i with
           | zero => exact Nat.le_refl 1
           | succ _ =>
             show (if s = 0 then 0 else 1) ≤ 1
             cases s with
             | zero => exact Nat.zero_le 1
             | succ _ => exact Nat.le_refl 1,
       Nat.le_refl 0,
       fun h0 => ⟨by rw [h0]; exact Nat.lt_irrefl 0, fun e => Empty.elim e, fun site => by
         cases site with
         | false => exact Nat.le_refl 0
         | true =>
           cases i with
           | zero => exact Nat.le_refl 1
           | succ _ =>
             show (if s = 0 then 0 else 1) ≤ 0
             rw [h0]
             exact Nat.le_refl 0⟩⟩,
     fun s oa _ hs => by
       show (if oa.1.2 then s - 1 else s) ≤ 1
       cases oa.1.2 with
       | false => exact hs
       | true => exact Nat.le_trans (Nat.sub_le s 1) hs⟩
  eta_bound _ hs := hs
  emits_on_warn _ o _ ho := ho
  eta_alarm_step s _ _ _ _ pos := match s, pos with
    | 1, _ => Nat.lt_succ_self 0
    | s' + 2, _ => Nat.lt_succ_self (s' + 1)
  eta_alarm_zero s _ _ _ _ h0 := by show s - 1 = 0; rw [h0]

def coupling : Nat → (Bool → Nat) → Bool
  | 0, x => Nat.ble (x false) 8
  | _ + 1, x => Nat.ble (x true) 8

def cascadeTurns : Turns (Bool → Nat) Bool Bool := Turns.Copying.turns coupling false

def channel (em : Bool) (_ : Nat) (_ : Unit) : Bool := em
def xCrit : Bool → Nat := fun _ => 3
def warnLvl : Bool → Nat := fun _ => 9
def hSafe : Bool → Nat := fun site => if site then 1 else 0
def xStart : Bool → Nat := fun _ => 9
def xSafeTemplate : Bool → Nat := fun site => if site then 3 else 9

theorem cascade_pool_crashes :
    ¬ Viability.Kernel
      (OpenComposition.closedProcess
        (OpenComposition.composeListComponent memberComp 0 [1, 2])
        (OpenComposition.composeListContract memberContract 0 [1, 2])
        (cascadeListObs cascadeTurns 0 [1, 2]) channel gPool (fun _ _ => 0) (fun _ => True))
      (OpenComposition.closedGuard
        (OpenComposition.composeListComponent memberComp 0 [1, 2])
        (OpenComposition.composeListContract memberContract 0 [1, 2]) xCrit)
      (xStart, OpenComposition.composeListInit (fun _ => 1) 0 [1, 2]) := by
  let P_inv : (Bool → Nat) × OpenComposition.ListCarrier Nat [1, 2] → Prop :=
    fun st => 9 ≤ st.1 false ∧ st.2.2.1 = (1 : Nat) ∧ st.2.2.2 = (1 : Nat)
  refine cascade_list_capture_collapse memberComp (fun _ => 1) memberContract 0 [1, 2]
    cascadeTurns (Turns.Copying.readsOnlyActs coupling false) channel gPool (fun _ _ => 0)
    (fun _ => True) xCrit xStart xSafeTemplate true () trivial (fun _ => ())
    (fun _ _ => trivial) P_inv ⟨Nat.le_refl 9, rfl, rfl⟩ ?_
    (fun _ _ => rfl) (fun _ => rfl) ?_ (fun e => by
      show (if 2 ≤ e true then 1 else 0) ≤ 1
      cases Nat.decLe 2 (e true) with
      | isTrue h => rw [if_pos h]; exact Nat.le_refl 1
      | isFalse h => rw [if_neg h]; exact Nat.zero_le 1)
    gPool_dep_true 3 (by decide : 1 < 3) ?_ ?_ (by decide : 0 < 1)
    4 (by decide : 9 < 3 + (3 - 1) * 4) (by decide : 0 < 3)
  · intro x st ⟨hxFalse, hs1, hs2⟩ _
    have hBleFalse : Nat.ble (x false) 8 = false :=
      Naturals.ble_false_of_lt (Nat.lt_of_lt_of_le (by decide : 8 < 9) hxFalse)
    have hc0 : coupling 0 x = false := hBleFalse
    have hObs : cascadeListObs cascadeTurns 0 [1, 2] x = (false, (false, false)) := by
      show (Turns.Copying.turns coupling false |>.act x 0,
        (Turns.Copying.turns coupling false |>.act x 1,
         Turns.Copying.turns coupling false |>.act x 2)) = (false, (false, false))
      dsimp only [Turns.act, Turns.acts, Turns.Copying.turns]
      rw [hc0]
      rfl
    have hxG : 2 ≤ x false := Nat.le_trans (by decide : 2 ≤ 9) hxFalse
    have hNextFalse : 9 ≤ (x false - 0) +
        gPool false (fun s => x s - ((OpenComposition.composeListComponent memberComp 0 [1, 2]).drawExt st s + 0)) := by
      show 9 ≤ x false + (if 2 ≤ x false then 1 else 0)
      rw [if_pos hxG]
      exact Nat.le_trans hxFalse (Nat.le_add_right _ 1)
    have hEmit : (OpenComposition.composeListComponent memberComp 0 [1, 2]).emitAlarm st
        (cascadeListObs cascadeTurns 0 [1, 2] x) = false := by
      rw [hObs]
      rfl
    have hs1' : (OpenComposition.closedStep
        (OpenComposition.composeListComponent memberComp 0 [1, 2])
        (cascadeListObs cascadeTurns 0 [1, 2]) channel gPool (fun _ _ => 0) (x, st)
        ((), ((), ((), ())))).2.2.1 = (1 : Nat) := by
      dsimp only [OpenComposition.closedStep, OpenComposition.closedStepWith]
      rw [hEmit]
      exact hs1
    have hs2' : (OpenComposition.closedStep
        (OpenComposition.composeListComponent memberComp 0 [1, 2])
        (cascadeListObs cascadeTurns 0 [1, 2]) channel gPool (fun _ _ => 0) (x, st)
        ((), ((), ((), ())))).2.2.2 = (1 : Nat) := by
      dsimp only [OpenComposition.closedStep, OpenComposition.closedStepWith]
      rw [hEmit]
      exact hs2
    exact ⟨hNextFalse, hs1', hs2'⟩
  · intro x st ⟨hxFalse, _, _⟩ _ j hj
    cases j with
    | zero =>
      show Nat.ble (x false) 8 = Nat.ble (xSafeTemplate false) 8
      rw [Naturals.ble_false_of_lt (Nat.lt_of_lt_of_le (by decide : 8 < 9) hxFalse)]
      rfl
    | succ j' => exact absurd (Nat.lt_of_succ_lt_succ hj) (Nat.not_lt_zero j')
  · intro _ st ⟨_, hs1, hs2⟩ _ _
    let s1 : Nat := st.2.1
    let s2 : Nat := st.2.2
    have h1 : (if s1 = 0 then 0 else 1) = 1 := by
      rw [show s1 = (1 : Nat) from hs1]; rfl
    have h2 : (if s2 = 0 then 0 else 1) = 1 := by
      rw [show s2 = (1 : Nat) from hs2]; rfl
    change 3 ≤ 1 + ((if s1 = 0 then 0 else 1) + (if s2 = 0 then 0 else 1))
    rw [h1, h2]
    exact Nat.le_refl 3
  · intro _ s _ _ _ hs
    show 0 < (if false then s - 1 else s)
    exact hs

theorem independent_pool_viable :
    Viability.Kernel
      (OpenComposition.closedProcess
        (OpenComposition.composeListComponent memberComp 0 [1, 2])
        (OpenComposition.composeListContract memberContract 0 [1, 2])
        (independentListObs cascadeTurns 0 [1, 2]) channel gPool (fun _ _ => 0) (fun _ => True))
      (OpenComposition.closedGuard
        (OpenComposition.composeListComponent memberComp 0 [1, 2])
        (OpenComposition.composeListContract memberContract 0 [1, 2]) xCrit)
      (xStart, OpenComposition.composeListInit (fun _ => 1) 0 [1, 2]) := by
  refine composeList_viable_indexed memberComp (fun _ => 1) memberContract 0 [1, 2]
    cascadeTurns.coupling channel gPool (fun _ _ => 0) (fun _ => 0) (fun _ => True)
    (fun _ _ _ => Nat.le_refl 0) xCrit warnLvl hSafe xStart
    ?_ (fun _ _ _ _ => rfl) gPool_rises ?_ ?_ ?_ ?_
  · intro x site hlt
    cases site with
    | false =>
      refine ⟨0, .head _, ?_⟩
      show Nat.ble (x false) 8 = true
      exact Nat.ble_eq_true_of_le (Nat.le_of_lt_succ hlt)
    | true =>
      refine ⟨1, .tail 0 (.head _), ?_⟩
      show Nat.ble (x true) 8 = true
      exact Nat.ble_eq_true_of_le (Nat.le_of_lt_succ hlt)
  · intro site
    cases site <;> decide
  · intro site
    cases site <;> decide
  · intro site
    cases site <;> decide
  · intro site
    cases site <;> decide

end CascadePoolWitness

/-! ## Part 3: Coupling-Distance & Threshold-Blindness Obstructions -/

/-- **Coupling-Distance Monitor Indistinguishability (`TimedResponse.answer_alike_far`)**:
no monitor reading through `W.AlikeThroughUpTo obs g_mon · · D` can emit different observations
between benign `(L, W)` and source-depleted `(L', W')` before `S_src + dist_min` steps. -/
theorem coupling_distance_obs_alike
    {F C Obs : Type} {L L' : Flow F C} {W W' : Web F C}
    {obs : F → C → Prop} {source : Nat → F → Prop} {S_src D : Nat} {g_mon : F}
    (balanced : ∀ t, t < D → ∀ c, W.level (t+1) c + L.taken t c = W.level t c + L.given t c)
    (balanced' : ∀ t, t < D → ∀ c, W'.level (t+1) c + L'.taken t c = W'.level t c + L'.given t c)
    (present : ∀ t, t < D → L.present t = L'.present t)
    (start : ∀ c, W.level 0 c = W'.level 0 c)
    (responds : ∀ t, t < D → ∀ h, ¬ source t h →
      W.AlikeThroughUpTo obs h W.level W'.level t →
      ∀ c, L.take t h c = L'.take t h c ∧ L.give t h c = L'.give t h c)
    (late : ∀ t h, source t h → S_src ≤ t)
    (read : (Nat → C → Nat) → Obs)
    (through : ∀ l l', W.AlikeThroughUpTo obs g_mon l l' D → read l = read l')
    (far : ∀ n s c, s ≤ D → TimedResponse.CoupledIntoAt W obs g_mon s c →
      TimedResponse.Linked L L' W obs source n c → D < S_src + n) :
    read W.level = read W'.level :=
  TimedResponse.answer_alike_far balanced balanced' present start responds late read through far

/-- Step-clocked `PolyComponent` lift of an `OpenComponent` (`Mode := Nat`). -/
def clockedPolyComponent {S Obs Dist Int Ext : Type}
    (C : OpenComposition.OpenComponent S Obs Dist Int Ext) :
    PolyComposition.PolyComponent Nat (fun _ => S) (fun _ => Obs)
      (fun _ => Dist) (fun _ => Int) (fun _ => Ext) where
  next p oa d := ⟨p.1 + 1, C.next p.2 oa d⟩
  drawInt p := C.drawInt p.2
  drawExt p := C.drawExt p.2
  emitAlarm _ := C.emitAlarm
  silenceLoad p := C.silenceLoad p.2
  favours p := C.favours p.2

/-- Step-clocked `PolyContract` lift of an `InterfaceContract` (`Mode := Nat`). -/
def clockedPolyContract {S Obs Dist Int Ext : Type}
    {C : OpenComposition.OpenComponent S Obs Dist Int Ext} {init : S}
    (c : OpenComposition.InterfaceContract C init) :
    PolyComposition.PolyContract (clockedPolyComponent C) ⟨0, init⟩ where
  tol _ := c.tol
  warnObs _ := c.warnObs
  preCapInt _ := c.preCapInt
  preCapExt _ := c.preCapExt
  postAllowanceInt _ := c.postBudgetInt
  postAllowanceExt _ := c.postBudgetExt
  maxSilence _ := c.maxSilence
  maxLag _ := c.maxLag
  K p := c.K p.2
  eta p := c.eta p.2
  init_in := c.init_in
  cert := by
    refine ⟨fun p hp => c.cert.within p.2 hp, ?_⟩
    intro p a p' ⟨hm, htol, hp'⟩ hp
    cases p with | mk m s =>
    cases a with | mk am ab =>
    dsimp only at hm
    subst hm
    dsimp only [clockedPolyComponent] at htol hp' ⊢
    subst hp'
    exact c.cert.closed s ab (C.next s ab.1 ab.2) ⟨htol, rfl⟩ hp
  eta_bound p hp := c.eta_bound p.2 hp
  emits_on_warn _ s obs hK hw := c.emits_on_warn s obs hK hw
  eta_alarm_step _ s obs dist htol hK hpos := c.eta_alarm_step s obs dist htol hK hpos
  eta_alarm_zero _ s obs dist htol hK h0 := c.eta_alarm_zero s obs dist htol hK h0

/-- **Coupling-Distance Turning Obstruction (`TimedResponse.answer_alike_far` × `PolyComposition`)**:
runs `C_comp` inside `PolyComposition.polyClosedProcess` (`Mode := Nat`, feeding `readStep W'.level t`).
Any monitor silent on baseline `(L, W)` through `D` (`D < S_src + d_min`) receives identical
observations on `(L', W')`, keeping `alarm = false` and `0 < eta` through `D`. If `D + 1` exceeds
pre-no-return headroom `x₀ ext_crit < (H_safe + y_safe) + (H_pre - Y) * (D + 1)`, the substrate
crosses below no-return within `D + 1`, collapses to `0`, and refutes `Viability.Kernel`. -/
theorem coupling_distance_turning_obstruction
    {F C S Obs Dist Int Ext Env : Type}
    {L L' : Flow F C} {W W' : Web F C}
    {obs_web : F → C → Prop} {source : Nat → F → Prop} {g_mon : F}
    {S_src D : Nat}
    (C_comp : OpenComposition.OpenComponent S Obs Dist Int Ext) {init : S}
    (c : OpenComposition.InterfaceContract C_comp init)
    (ext_crit : Ext)
    (readStep : (Nat → C → Nat) → Nat → Obs)
    (through : ∀ t, t ≤ D → ∀ l l',
      W.AlikeThroughUpTo obs_web g_mon l l' t → readStep l t = readStep l' t)
    (balanced : ∀ t, t < D → ∀ c, W.level (t+1) c + L.taken t c = W.level t c + L.given t c)
    (balanced' : ∀ t, t < D → ∀ c, W'.level (t+1) c + L'.taken t c = W'.level t c + L'.given t c)
    (present : ∀ t, t < D → L.present t = L'.present t)
    (start : ∀ c, W.level 0 c = W'.level 0 c)
    (responds : ∀ t, t < D → ∀ h, ¬ source t h →
      W.AlikeThroughUpTo obs_web h W.level W'.level t →
      ∀ c, L.take t h c = L'.take t h c ∧ L.give t h c = L'.give t h c)
    (late : ∀ t h, source t h → S_src ≤ t)
    (far : ∀ n s c, s ≤ D → TimedResponse.CoupledIntoAt W obs_web g_mon s c →
      TimedResponse.Linked L L' W obs_web source n c → D < S_src + n)
    (silent_on_benign : ∀ t s, t ≤ D → C_comp.emitAlarm s (readStep W.level t) = false)
    (channel : Bool → Nat → Env → Bool)
    (silent_chan : ∀ load env, channel false load env = false)
    (G : Ext → (Ext → Nat) → Nat) (envDraw : Env → Ext → Nat) (jointAdm : Env → Prop)
    (x₀ x_crit : Ext → Nat)
    {Y H_pre H_safe y_safe : Nat}
    (G_most : ∀ e, G ext_crit e ≤ Y)
    (G_dep : RegimeMargin.Coupled.Indexed.DependsOn RegimeMargin.Drawn.whole G ext_crit ext_crit)
    (G_short : ∀ e, e ext_crit < y_safe → G ext_crit e < H_safe)
    (yle : Y < H_pre) (hPos : 0 < H_safe + y_safe)
    (x_crit_pos : 0 < x_crit ext_crit)
    (pre_while_eta : ∀ s, c.K s → 0 < c.eta s → H_pre ≤ C_comp.drawExt s ext_crit)
    (safe_ge : ∀ s, c.K s → H_safe ≤ C_comp.drawExt s ext_crit)
    (eta_pos_init : 0 < c.eta init)
    (eta_kept_when_unwarned : ∀ s ob d, c.tol (ob, false) d → 0 < c.eta s →
      0 < c.eta (C_comp.next s (ob, false) d))
    (env_adm : Env) (hAdm : jointAdm env_adm) (d₀ : Dist) (hTol : ∀ ob, c.tol ob d₀)
    (under_headroom : x₀ ext_crit < (H_safe + y_safe) + (H_pre - Y) * (D + 1)) :
    (∀ t, t ≤ D → readStep W'.level t = readStep W.level t) ∧
    (∃ T, T ≤ D + 1 ∧
      let orb := Law.orbit
        (fun st : (Ext → Nat) × Σ _ : Nat, S =>
          PolyComposition.polyClosedStep (clockedPolyComponent C_comp) (fun _ e => [e])
            (fun t _ => readStep W'.level t) channel G envDraw st (env_adm, d₀))
        (x₀, ⟨0, init⟩)
      (orb T).1 ext_crit < H_safe + y_safe ∧
      ((orb (T + (orb T).1 ext_crit)).1 ext_crit = 0 ∧
       ∀ m, (orb (T + (orb T).1 ext_crit + m)).1 ext_crit = 0)) ∧
    ¬ Viability.Kernel
      (PolyComposition.polyClosedProcess (clockedPolyComponent C_comp) (fun _ e => [e])
        (clockedPolyContract c) (fun t _ => readStep W'.level t) channel G envDraw jointAdm)
      (PolyComposition.polyClosedGuard (clockedPolyComponent C_comp) (clockedPolyContract c) x_crit)
      (x₀, ⟨0, init⟩) := by
  have hAlike : ∀ t, t ≤ D → readStep W'.level t = readStep W.level t := fun t ht =>
    (coupling_distance_obs_alike
      (fun s hs => balanced s (Nat.lt_of_lt_of_le hs ht))
      (fun s hs => balanced' s (Nat.lt_of_lt_of_le hs ht))
      (fun s hs => present s (Nat.lt_of_lt_of_le hs ht))
      start
      (fun s hs => responds s (Nat.lt_of_lt_of_le hs ht))
      late (fun l => readStep l t) (through t ht)
      (fun n s c hs reg lnk =>
        Nat.lt_of_le_of_lt ht (far n s c (Nat.le_trans hs ht) reg lnk))).symm
  let stepFn := fun st : (Ext → Nat) × Σ m : Nat, S =>
    PolyComposition.polyClosedStep (clockedPolyComponent C_comp) (fun _ e => [e])
      (fun t _ => readStep W'.level t) channel G envDraw st (env_adm, d₀)
  let orb : Nat → (Ext → Nat) × Σ m : Nat, S := Law.orbit stepFn (x₀, ⟨0, init⟩)
  have hMode : ∀ t, (orb t).2.1 = t := by
    intro t
    induction t with
    | zero => rfl
    | succ t ih =>
      show (orb t).2.1 + 1 = t + 1
      rw [ih]
  have hK : ∀ t, c.K (orb t).2.2 := by
    intro t
    induction t with
    | zero => exact c.init_in
    | succ t ih =>
      let ob := (readStep W'.level (orb t).2.1,
        channel (C_comp.emitAlarm (orb t).2.2 (readStep W'.level (orb t).2.1))
          (C_comp.silenceLoad (orb t).2.2) env_adm)
      exact c.cert.closed (orb t).2.2 (ob, d₀) (C_comp.next (orb t).2.2 ob d₀)
        ⟨hTol ob, rfl⟩ ih
  have hEtaPos : ∀ t, t ≤ D → 0 < c.eta (orb t).2.2 := by
    intro t
    induction t with
    | zero => intro _; exact eta_pos_init
    | succ t ih =>
      intro hsucc
      have ht : t ≤ D := Nat.le_trans (Nat.le_succ t) hsucc
      have hPrev := ih ht
      have hObs : readStep W'.level (orb t).2.1 = readStep W.level t := by
        rw [hMode t]
        exact hAlike t ht
      have hEmit : C_comp.emitAlarm (orb t).2.2 (readStep W'.level (orb t).2.1) = false := by
        rw [hObs]
        exact silent_on_benign t (orb t).2.2 ht
      have hAl : channel (C_comp.emitAlarm (orb t).2.2 (readStep W'.level (orb t).2.1))
          (C_comp.silenceLoad (orb t).2.2) env_adm = false := by
        show channel (C_comp.emitAlarm (orb t).2.2 (readStep W'.level (orb t).2.1)) _ env_adm = false
        rw [hEmit]
        exact silent_chan _ _
      show 0 < c.eta (C_comp.next (orb t).2.2
        (readStep W'.level (orb t).2.1,
         channel (C_comp.emitAlarm (orb t).2.2 (readStep W'.level (orb t).2.1))
           (C_comp.silenceLoad (orb t).2.2) env_adm) d₀)
      rw [hAl]
      exact eta_kept_when_unwarned _ _ d₀ (hTol _) hPrev
  let xSeq : Nat → Nat := fun t => (orb t).1 ext_crit
  let dSeq : Nat → Nat := fun t =>
    PolyComposition.polySiteDraw (clockedPolyComponent C_comp) (fun _ e => [e]) (orb t).2 ext_crit +
      envDraw env_adm ext_crit
  let gainSeq : Nat → Nat := fun t =>
    G ext_crit (RegimeMargin.Coupled.Indexed.left RegimeMargin.Drawn.whole
      (fun k => PolyComposition.polySiteDraw (clockedPolyComponent C_comp) (fun _ e => [e])
        (orb t).2 k + envDraw env_adm k) (orb t).1)
  have hStep : ∀ t, xSeq (t + 1) = (xSeq t - dSeq t) + gainSeq t := fun _ => rfl
  have hMost : ∀ t, gainSeq t ≤ Y := fun t => G_most _
  have hNothing : ∀ t, xSeq t < dSeq t → gainSeq t = 0 := fun t hlt => by
    apply G_dep
    exact sub_eq_zero_of_le (Nat.le_of_lt hlt)
  have hDge : ∀ t, t < D + 1 → (∀ j, j ≤ t → H_safe + y_safe ≤ xSeq j) → H_pre ≤ dSeq t := by
    intro t ht _
    have hPre : H_pre ≤ C_comp.drawExt (orb t).2.2 ext_crit :=
      pre_while_eta (orb t).2.2 (hK t) (hEtaPos t (Nat.le_of_lt_succ ht))
    show H_pre ≤ (C_comp.drawExt (orb t).2.2 ext_crit + 0) + envDraw env_adm ext_crit
    rw [Nat.add_zero]
    exact Nat.le_trans hPre (Nat.le_add_right _ _)
  obtain ⟨T, hT_le, hT_lt⟩ := varDraw_falls_within_while hStep hMost hNothing (Nat.le_of_lt yle)
    (D + 1) hDge hPos under_headroom
  have hCol := varDraw_short_collapses (b_nr := H_safe + y_safe) (T := T) hStep hPos
    (fun t _ hlt _ => hNothing t hlt)
    (fun t _ hge hlt_b => by
      have hd_safe : H_safe ≤ dSeq t := by
        show H_safe ≤ (C_comp.drawExt (orb t).2.2 ext_crit + 0) + envDraw env_adm ext_crit
        rw [Nat.add_zero]
        exact Nat.le_trans (safe_ge (orb t).2.2 (hK t)) (Nat.le_add_right _ _)
      have hlt_sub : xSeq t - dSeq t < y_safe := sub_lt_of_lt_add hd_safe hge hlt_b
      exact Nat.lt_of_lt_of_le (G_short _ hlt_sub) hd_safe)
    hT_lt
  have hNotKern :
      ¬ Viability.Kernel
        (PolyComposition.polyClosedProcess (clockedPolyComponent C_comp) (fun _ e => [e])
          (clockedPolyContract c) (fun t _ => readStep W'.level t) channel G envDraw jointAdm)
        (PolyComposition.polyClosedGuard (clockedPolyComponent C_comp) (clockedPolyContract c) x_crit)
        (x₀, ⟨0, init⟩) := by
    intro kern
    let tCrash := T + xSeq T
    have hReach : ∀ k, Reach
        (PolyComposition.polyClosedProcess (clockedPolyComponent C_comp) (fun _ e => [e])
          (clockedPolyContract c) (fun t _ => readStep W'.level t) channel G envDraw jointAdm)
        (x₀, ⟨0, init⟩) (orb k) := by
      intro k
      induction k with
      | zero => exact Reach.refl _ _
      | succ k ih =>
        have hstep : (PolyComposition.polyClosedProcess (clockedPolyComponent C_comp) (fun _ e => [e])
            (clockedPolyContract c) (fun t _ => readStep W'.level t) channel G envDraw jointAdm).step
            (orb k) (env_adm, ⟨k, d₀⟩) (orb (k + 1)) := by
          cases hOrb : orb k with | mk x p =>
          cases p with | mk m s =>
          have hm_eq : m = k := by
            have hk := hMode k
            rw [hOrb] at hk
            exact hk
          cases hm_eq
          refine ⟨rfl, hAdm, fun _ => hTol _, ?_⟩
          show stepFn (orb k) = PolyComposition.polyClosedStep (clockedPolyComponent C_comp)
            (fun _ e => [e]) (fun t _ => readStep W'.level t) channel G envDraw (x, ⟨k, s⟩) (env_adm, d₀)
          rw [hOrb]
        exact Reach.trans ih (Reach.of_step hstep)
    have hGuard := kern (orb tCrash) (hReach tCrash)
    have hPosCrit : 0 < (orb tCrash).1 ext_crit :=
      Nat.lt_of_lt_of_le x_crit_pos (hGuard.1 ext_crit)
    have hZero : (orb tCrash).1 ext_crit = 0 := hCol.2.1
    rw [hZero] at hPosCrit
    exact Nat.lt_irrefl 0 hPosCrit
  exact ⟨hAlike, ⟨T, hT_le, hT_lt, hCol.2⟩, hNotKern⟩

/-! ### Witness 3A: `DelayObstructionWitness` (`TimedResponse.Relay` × `PolyComposition` vs. Direct Monitor) -/

namespace DelayObstructionWitness

def gDelay (_ : Unit) (e : Unit → Nat) : Nat := if 3 ≤ e () then 1 else 0

theorem gDelay_rises :
    ∀ site : Unit, RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (gDelay site) := by
  intro _ e₁ e₂ hbelow
  dsimp only [gDelay]
  cases Nat.decLe 3 (e₁ ()) with
  | isTrue h => rw [if_pos h, if_pos (Nat.le_trans h (hbelow ()))]; exact Nat.le_refl 1
  | isFalse h => rw [if_neg h]; exact Nat.zero_le _

theorem gDelay_dep :
    RegimeMargin.Coupled.Indexed.DependsOn RegimeMargin.Drawn.whole gDelay () () := by
  intro e he
  show (if 3 ≤ e () then 1 else 0) = 0
  rw [he]
  rfl

def relayComp : OpenComposition.OpenComponent Nat Bool Unit Empty Unit :=
  OpenComposition.countdownComponent 2 1 (fun _ o => o)

def relayContract : OpenComposition.InterfaceContract relayComp 1 :=
  OpenComposition.countdownContract 2 1 0 1 1 (fun _ o => o) (fun o => o = true)
    (by decide) (Nat.le_refl 1) (fun _ _ _ ho => ho)

def channel (em : Bool) (_ : Nat) (_ : Unit) : Bool := em
def xCrit : Unit → Nat := fun _ => 4
def warnLvl : Unit → Nat := fun _ => 8
def hSafe : Unit → Nat := fun _ => 1
def xStart : Unit → Nat := fun _ => 6

theorem relay_balanced (b : Bool) :
    ∀ t, t < 2 → ∀ c,
      (TimedResponse.Relay.web b).level (t + 1) c + (TimedResponse.Relay.flow b).taken t c =
      (TimedResponse.Relay.web b).level t c + (TimedResponse.Relay.flow b).given t c := by
  intro t ht c
  cases t with
  | zero => cases c <;> rfl
  | succ t' =>
    cases t' with
    | zero => cases c <;> cases b <;> rfl
    | succ t'' => exact absurd (Nat.lt_of_succ_lt_succ (Nat.lt_of_succ_lt_succ ht)) (Nat.not_lt_zero _)

theorem relay_responds :
    ∀ t, t < 2 → ∀ h, ¬ TimedResponse.Relay.sourceAt t h →
      (TimedResponse.Relay.web false).AlikeThroughUpTo TimedResponse.Relay.reads h
        (TimedResponse.Relay.web false).level (TimedResponse.Relay.web true).level t →
      ∀ c, (TimedResponse.Relay.flow false).take t h c = (TimedResponse.Relay.flow true).take t h c ∧
           (TimedResponse.Relay.flow false).give t h c = (TimedResponse.Relay.flow true).give t h c := by
  intro t ht h hnot _ c
  cases t with
  | zero => cases h <;> cases c <;> exact ⟨rfl, rfl⟩
  | succ t' =>
    cases t' with
    | zero =>
      cases h with
      | source => exact absurd ⟨rfl, rfl⟩ hnot
      | relay => cases c <;> exact ⟨rfl, rfl⟩
      | reader => cases c <;> exact ⟨rfl, rfl⟩
    | succ t'' => exact absurd (Nat.lt_of_succ_lt_succ (Nat.lt_of_succ_lt_succ ht)) (Nat.not_lt_zero _)

def readRelayStep (l : Nat → TimedResponse.Relay.Spot → Nat) (t : Nat) : Bool :=
  TimedResponse.Relay.readAt t l

theorem delayed_relay_crashes :
    (∀ t, t ≤ 2 →
      readRelayStep (TimedResponse.Relay.web true).level t =
      readRelayStep (TimedResponse.Relay.web false).level t) ∧
    ¬ Viability.Kernel
      (PolyComposition.polyClosedProcess (clockedPolyComponent relayComp) (fun _ e => [e])
        (clockedPolyContract relayContract)
        (fun t _ => readRelayStep (TimedResponse.Relay.web true).level t)
        channel gDelay (fun _ _ => 0) (fun _ => True))
      (PolyComposition.polyClosedGuard (clockedPolyComponent relayComp)
        (clockedPolyContract relayContract) xCrit)
      (xStart, ⟨0, 1⟩) := by
  have hObs := coupling_distance_turning_obstruction
    (L := TimedResponse.Relay.flow false) (L' := TimedResponse.Relay.flow true)
    (W := TimedResponse.Relay.web false) (W' := TimedResponse.Relay.web true)
    (obs_web := TimedResponse.Relay.reads) (source := TimedResponse.Relay.sourceAt)
    (g_mon := .reader) (S_src := 1) (D := 2)
    relayComp relayContract () readRelayStep
    (fun t _ l l' hal => by
      have heq := (hal t (Nat.le_refl t)).2 .second trivial
      show decide (0 < l t .second) = decide (0 < l' t .second)
      rw [heq])
    (relay_balanced false) (relay_balanced true)
    (fun _ _ => rfl) (fun _ => rfl) relay_responds
    TimedResponse.Relay.late TimedResponse.Relay.reader_far
    (fun t s ht => by
      have h0 : readRelayStep (TimedResponse.Relay.web false).level t = false := by
        cases t with
        | zero => rfl
        | succ t' =>
          cases t' with
          | zero => rfl
          | succ t'' =>
            cases t'' with
            | zero => rfl
            | succ t''' => exact absurd ht (Nat.not_le_of_gt (Nat.lt_of_lt_of_le
                (by decide : 2 < 3) (Nat.le_add_left 3 t''')))
      show relayComp.emitAlarm s (readRelayStep (TimedResponse.Relay.web false).level t) = false
      exact h0)
    channel (fun _ _ => rfl) gDelay (fun _ _ => 0) (fun _ => True) xStart xCrit
    (Y := 1) (H_pre := 2) (H_safe := 1) (y_safe := 3)
    (fun e => by
      show (if 3 ≤ e () then 1 else 0) ≤ 1
      cases Nat.decLe 3 (e ()) with
      | isTrue h => rw [if_pos h]; exact Nat.le_refl 1
      | isFalse h => rw [if_neg h]; exact Nat.zero_le 1)
    gDelay_dep
    (fun e he => by
      show (if 3 ≤ e () then 1 else 0) < 1
      rw [if_neg (Nat.not_le_of_lt he)]
      exact Nat.one_pos)
    (by decide : 1 < 2) (by decide : 0 < 1 + 3) (by decide : 0 < 4)
    (fun s _ hpos => match s, hpos with
      | 0, hpos => absurd hpos (Nat.not_lt_zero 0)
      | _ + 1, _ => by show 2 ≤ (2 : Nat); exact Nat.le_refl 2)
    (fun s _ => match s with
      | 0 => by show 1 ≤ (1 : Nat); exact Nat.le_refl 1
      | _ + 1 => by show 1 ≤ (2 : Nat); exact Nat.le_succ 1)
    (Nat.one_pos)
    (fun s _ _ _ hs => by
      show 0 < (if false then s - 1 else s)
      exact hs)
    () trivial () (fun _ => trivial)
    (by decide : 6 < (1 + 3) + (2 - 1) * (2 + 1))
  exact ⟨hObs.1, hObs.2.2⟩

theorem direct_monitor_viable :
    Viability.Kernel
      (OpenComposition.closedProcess relayComp relayContract
        (fun x => Nat.blt (x ()) 8) channel gDelay (fun _ _ => 0) (fun _ => True))
      (OpenComposition.closedGuard relayComp relayContract xCrit)
      (xStart, 1) := by
  refine OpenComposition.close_contract_kernel relayComp relayContract
    (fun x => Nat.blt (x ()) 8) channel gDelay (fun _ _ => 0) (fun _ => 0) (fun _ => True)
    (fun _ _ _ => Nat.le_refl 0) xCrit warnLvl hSafe xStart
    (fun x site hlt => by
      cases site
      exact Nat.ble_eq_true_of_le hlt)
    (fun _ _ _ _ => rfl) gDelay_rises
    (fun site => by cases site; decide)
    (fun site => by cases site; decide)
    (fun site => by cases site; decide)
    (fun site => by cases site; decide)

end DelayObstructionWitness

/-! ### Part 3B: Threshold-Blindness Obstruction (`Thresholds` & `LevelCoupling` × `OpenComposition`) -/

/-- **Network Threshold & Level Blindness (`Thresholds` × `LevelCoupling`)**:
along a balanced exchange law `law.Through W_net obs_net part` that never observes `c_stock` directly
above `θ_net`, extra reserve `d_res` on `c_stock` is carried nowhere across `[0, T_net]`, and `law`
cannot respond by level (`¬ law.RespondsByLevel`) to drops on `c_stock` keeping needs met. -/
theorem network_threshold_blindness
    {F C : Type} [DecidableEq C]
    {law : ExchangeLaw F C} {W_net W_net' : Web F C}
    {obs_net : F → C → Prop} {part : F → Bool}
    {L_net L_net' : Flow F C} {c_stock : C} {θ_net : Nat → Nat}
    (through : law.Through W_net obs_net part)
    (unobserved : ∀ h, part h = false → ¬ obs_net h c_stock)
    (needs : ∀ h s, part h = false → W_net.requires s h c_stock → W_net.need s h c_stock ≤ θ_net s)
    (bal : L_net.Balances W_net) (bal' : L_net'.Balances W_net')
    (pres : ∀ t, L_net.present t = L_net'.present t) (acts : L_net.ActsAlike L_net' part)
    (fol : L_net.Follows law part W_net.level) (fol' : L_net'.Follows law part W_net'.level)
    {d_res T_net : Nat} (stands : ∀ s, s < T_net → θ_net s ≤ W_net.level s c_stock)
    (others : ∀ e, e ≠ c_stock → W_net.level 0 e = W_net'.level 0 e)
    (stock : W_net'.level 0 c_stock = W_net.level 0 c_stock + d_res) :
    law.ReadsBelow part c_stock θ_net ∧
    (∀ t, t ≤ T_net → (∀ e, e ≠ c_stock → W_net.level t e = W_net'.level t e) ∧
      W_net'.level t c_stock = W_net.level t c_stock + d_res) ∧
    (∀ h cc s t_ev, part h = false → ¬ law.RespondsByLevel W_net t_ev h cc s c_stock) := by
  have hRB : law.ReadsBelow part c_stock θ_net :=
    ExchangeLaw.Through.readsBelow through unobserved needs
  have hCar := break_carried_nowhere hRB bal bal' pres acts fol fol' stands others stock
  have hNoResp : ∀ h cc s t_ev, part h = false → ¬ law.RespondsByLevel W_net t_ev h cc s c_stock :=
    fun h _ _ _ hout => ExchangeLaw.Through.not_respondsByLevel through hout (unobserved h hout)
  exact ⟨hRB, hCar, hNoResp⟩

/-- **Threshold-Blind Open-Loop Collapse (`RegimeMargin` × `OpenComposition`)**:
when `obs` is constant above `θ_sensor ≤ H_safe + y_safe` and silent at `x_safe_hi`, any trace with
pre-alarm draw `H_pre > Y` drains below no-return `H_safe + y_safe` while unobserved, collapses to
`0` even under zero-lag reaction once below `θ_sensor`, and refutes `Viability.Kernel`. -/
theorem threshold_blind_open_collapse
    {S Obs Dist Int Ext Env : Type}
    (comp : OpenComposition.OpenComponent S Obs Dist Int Ext) {init : S}
    (c : OpenComposition.InterfaceContract comp init)
    (obs : (Ext → Nat) → Obs)
    (channel : Bool → Nat → Env → Bool)
    (G : Ext → (Ext → Nat) → Nat) (envDraw : Env → Ext → Nat) (jointAdm : Env → Prop)
    (site_crit : Ext) (θ_sensor : Nat)
    (obs_blind_above : ∀ x y, θ_sensor ≤ x site_crit → θ_sensor ≤ y site_crit → obs x = obs y)
    (x_safe_hi x₀ : Ext → Nat) (hi_ge : θ_sensor ≤ x_safe_hi site_crit)
    (silent_at_hi : ∀ s, comp.emitAlarm s (obs x_safe_hi) = false)
    (silent_chan : ∀ load env, channel false load env = false)
    {Y H_pre H_safe y_safe x_crit n : Nat}
    (θ_below_noReturn : θ_sensor ≤ H_safe + y_safe)
    (hPos : 0 < H_safe + y_safe)
    (_x_crit_le : x_crit ≤ H_safe + y_safe) (x_crit_pos : 0 < x_crit)
    (G_most : ∀ e, G site_crit e ≤ Y)
    (G_dep : RegimeMargin.Coupled.Indexed.DependsOn RegimeMargin.Drawn.whole G site_crit site_crit)
    (G_short : ∀ e, e site_crit < y_safe → G site_crit e < H_safe)
    (yle : Y < H_pre)
    (pre_ge : ∀ s, c.K s → 0 < c.eta s → H_pre ≤ comp.drawExt s site_crit)
    (safe_ge : ∀ s, c.K s → H_safe ≤ comp.drawExt s site_crit)
    (eta_pos_init : 0 < c.eta init)
    (eta_stays_unwarned : ∀ s ob d, c.tol (ob, false) d → 0 < c.eta s →
      0 < c.eta (comp.next s (ob, false) d))
    (env_adm : Env) (hAdm : jointAdm env_adm) (d₀ : Dist)
    (hTol : ∀ ob, c.tol ob d₀)
    (under_headroom : x₀ site_crit < (H_safe + y_safe) + (H_pre - Y) * n) :
    (∃ T, T ≤ n ∧
      let orb := Law.orbit
        (fun st => OpenComposition.closedStep comp obs channel G envDraw st (env_adm, d₀))
        (x₀, init)
      (orb T).1 site_crit < H_safe + y_safe ∧
      ((orb (T + (orb T).1 site_crit)).1 site_crit = 0 ∧
       ∀ m, (orb (T + (orb T).1 site_crit + m)).1 site_crit = 0)) ∧
    ¬ Viability.Kernel
      (OpenComposition.closedProcess comp c obs channel G envDraw jointAdm)
      (OpenComposition.closedGuard comp c (fun _ => x_crit))
      (x₀, init) := by
  let stepFn := fun st => OpenComposition.closedStep comp obs channel G envDraw st (env_adm, d₀)
  let orb := Law.orbit stepFn (x₀, init)
  let xSeq : Nat → Nat := fun t => (orb t).1 site_crit
  let dSeq : Nat → Nat := fun t => comp.drawExt (orb t).2 site_crit + envDraw env_adm site_crit
  let gainSeq : Nat → Nat := fun t =>
    G site_crit (RegimeMargin.Coupled.Indexed.left RegimeMargin.Drawn.whole
      (fun k => comp.drawExt (orb t).2 k + envDraw env_adm k) (orb t).1)
  have hStep : ∀ t, xSeq (t + 1) = (xSeq t - dSeq t) + gainSeq t := fun _ => rfl
  have hK : ∀ t, c.K (orb t).2 := by
    intro t
    induction t with
    | zero => exact c.init_in
    | succ t ih =>
      let ob := (obs (orb t).1, channel (comp.emitAlarm (orb t).2 (obs (orb t).1))
        (comp.silenceLoad (orb t).2) env_adm)
      exact c.cert.closed (orb t).2 (ob, d₀) (comp.next (orb t).2 ob d₀) ⟨hTol ob, rfl⟩ ih
  have hMost : ∀ t, gainSeq t ≤ Y := fun _ => G_most _
  have hNothing : ∀ t, xSeq t < dSeq t → gainSeq t = 0 := fun t hlt => by
    apply G_dep
    exact sub_eq_zero_of_le (Nat.le_of_lt hlt)
  have hEtaAll : ∀ m, (∀ j, j ≤ m → H_safe + y_safe ≤ xSeq j) → 0 < c.eta (orb m).2 := by
    intro m
    induction m with
    | zero => intro _; exact eta_pos_init
    | succ j ih =>
      intro hab
      have hPrevEta := ih (fun k hk => hab k (Nat.le_trans hk (Nat.le_succ j)))
      have hPrevX : H_safe + y_safe ≤ (orb j).1 site_crit := hab j (Nat.le_succ j)
      have hObs : obs (orb j).1 = obs x_safe_hi :=
        obs_blind_above _ _ (Nat.le_trans θ_below_noReturn hPrevX) hi_ge
      have hEmit : comp.emitAlarm (orb j).2 (obs (orb j).1) = false := by
        rw [hObs]
        exact silent_at_hi (orb j).2
      have hAl : channel (comp.emitAlarm (orb j).2 (obs (orb j).1))
          (comp.silenceLoad (orb j).2) env_adm = false := by
        rw [hEmit]
        exact silent_chan _ _
      show 0 < c.eta (comp.next (orb j).2
        (obs (orb j).1, channel (comp.emitAlarm (orb j).2 (obs (orb j).1))
          (comp.silenceLoad (orb j).2) env_adm) d₀)
      rw [hAl]
      exact eta_stays_unwarned _ _ d₀ (hTol _) hPrevEta
  have hDge : ∀ t, t < n → (∀ j, j ≤ t → H_safe + y_safe ≤ xSeq j) → H_pre ≤ dSeq t :=
    fun t _ hab => Nat.le_trans (pre_ge (orb t).2 (hK t) (hEtaAll t hab)) (Nat.le_add_right _ _)
  obtain ⟨T, hT_le, hT_lt⟩ := varDraw_falls_within_while hStep hMost hNothing (Nat.le_of_lt yle)
    n hDge hPos under_headroom
  have hCol := varDraw_short_collapses (b_nr := H_safe + y_safe) (T := T) hStep hPos
    (fun t _ hlt _ => hNothing t hlt)
    (fun t _ hge hlt_b => by
      have hd_safe : H_safe ≤ dSeq t :=
        Nat.le_trans (safe_ge (orb t).2 (hK t)) (Nat.le_add_right _ _)
      have hlt_sub : xSeq t - dSeq t < y_safe := sub_lt_of_lt_add hd_safe hge hlt_b
      exact Nat.lt_of_lt_of_le (G_short _ hlt_sub) hd_safe)
    hT_lt
  have hNotKern :
      ¬ Viability.Kernel
        (OpenComposition.closedProcess comp c obs channel G envDraw jointAdm)
        (OpenComposition.closedGuard comp c (fun _ => x_crit))
        (x₀, init) := by
    intro kern
    let tCrash := T + xSeq T
    have hReach : ∀ m, Reach (OpenComposition.closedProcess comp c obs channel G envDraw jointAdm)
        (x₀, init) (orb m) := by
      intro m
      induction m with
      | zero => exact Reach.refl _ _
      | succ m ih => exact Reach.trans ih (Reach.of_step ⟨⟨hAdm, hTol⟩, rfl⟩)
    have hGuard := kern (orb tCrash) (hReach tCrash)
    have hPosCrit : 0 < (orb tCrash).1 site_crit :=
      Nat.lt_of_lt_of_le x_crit_pos (hGuard.1 site_crit)
    have hZero : (orb tCrash).1 site_crit = 0 := hCol.2.1
    rw [hZero] at hPosCrit
    exact Nat.lt_irrefl 0 hPosCrit
  exact ⟨⟨T, hT_le, hT_lt, hCol.2⟩, hNotKern⟩

/-- **Joined Network-ReadsBelow-to-Open-Collapse Theorem (`Thresholds` × `LevelCoupling` × `OpenComposition`)**:
when the open component's observation `obs x` is derived from a threshold-blind exchange
formation `h_obs` (`part h_obs = false`, `law.Through W_net obs_net part` reading `c_stock` only
below `θ_sensor`), `ExchangeLaw.Through.readsBelow` **derives** `obs_blind_above`, proving
simultaneously: (1) network threshold/level blindness (`break_carried_nowhere` + `¬ RespondsByLevel`),
and (2) open-loop collapse to `0` and `¬ Viability.Kernel`. -/
theorem network_readsBelow_feeds_open_collapse
    {F C S Obs Dist Int Ext Env : Type} [DecidableEq C]
    {law : ExchangeLaw F C} {W_net W_net' : Web F C}
    {obs_net : F → C → Prop} {part : F → Bool}
    {L_net L_net' : Flow F C} {c_stock : C} {θ_sensor : Nat}
    (through : law.Through W_net obs_net part)
    (unobserved : ∀ h, part h = false → ¬ obs_net h c_stock)
    (needs : ∀ h s, part h = false → W_net.requires s h c_stock → W_net.need s h c_stock ≤ θ_sensor)
    (bal : L_net.Balances W_net) (bal' : L_net'.Balances W_net')
    (pres : ∀ t, L_net.present t = L_net'.present t) (acts : L_net.ActsAlike L_net' part)
    (fol : L_net.Follows law part W_net.level) (fol' : L_net'.Follows law part W_net'.level)
    {d_res T_net : Nat} (stands : ∀ s, s < T_net → θ_sensor ≤ W_net.level s c_stock)
    (others : ∀ e, e ≠ c_stock → W_net.level 0 e = W_net'.level 0 e)
    (stock : W_net'.level 0 c_stock = W_net.level 0 c_stock + d_res)
    (h_obs : F) (h_out : part h_obs = false) (t_obs : Nat) (c_out : C)
    (base_level : C → Nat) (readout : Nat → Nat → Obs)
    (comp : OpenComposition.OpenComponent S Obs Dist Int Ext) {init : S}
    (c : OpenComposition.InterfaceContract comp init)
    (channel : Bool → Nat → Env → Bool)
    (G : Ext → (Ext → Nat) → Nat) (envDraw : Env → Ext → Nat) (jointAdm : Env → Prop)
    (site_crit : Ext)
    (x_safe_hi x₀ : Ext → Nat) (hi_ge : θ_sensor ≤ x_safe_hi site_crit)
    (silent_at_hi : ∀ s, comp.emitAlarm s
      (readout
        (law.take t_obs h_obs (fun _ e => if e = c_stock then x_safe_hi site_crit else base_level e) c_out)
        (law.give t_obs h_obs (fun _ e => if e = c_stock then x_safe_hi site_crit else base_level e) c_out)) = false)
    (silent_chan : ∀ load env, channel false load env = false)
    {Y H_pre H_safe y_safe x_crit n : Nat}
    (θ_below_noReturn : θ_sensor ≤ H_safe + y_safe)
    (hPos : 0 < H_safe + y_safe)
    (x_crit_le : x_crit ≤ H_safe + y_safe) (x_crit_pos : 0 < x_crit)
    (G_most : ∀ e, G site_crit e ≤ Y)
    (G_dep : RegimeMargin.Coupled.Indexed.DependsOn RegimeMargin.Drawn.whole G site_crit site_crit)
    (G_short : ∀ e, e site_crit < y_safe → G site_crit e < H_safe)
    (yle : Y < H_pre)
    (pre_ge : ∀ s, c.K s → 0 < c.eta s → H_pre ≤ comp.drawExt s site_crit)
    (safe_ge : ∀ s, c.K s → H_safe ≤ comp.drawExt s site_crit)
    (eta_pos_init : 0 < c.eta init)
    (eta_stays_unwarned : ∀ s ob d, c.tol (ob, false) d → 0 < c.eta s →
      0 < c.eta (comp.next s (ob, false) d))
    (env_adm : Env) (hAdm : jointAdm env_adm) (d₀ : Dist)
    (hTol : ∀ ob, c.tol ob d₀)
    (under_headroom : x₀ site_crit < (H_safe + y_safe) + (H_pre - Y) * n) :
    let obs : (Ext → Nat) → Obs := fun x =>
      readout
        (law.take t_obs h_obs (fun _ e => if e = c_stock then x site_crit else base_level e) c_out)
        (law.give t_obs h_obs (fun _ e => if e = c_stock then x site_crit else base_level e) c_out)
    ((∀ t, t ≤ T_net → (∀ e, e ≠ c_stock → W_net.level t e = W_net'.level t e) ∧
        W_net'.level t c_stock = W_net.level t c_stock + d_res) ∧
     (∀ h cc s t_ev, part h = false → ¬ law.RespondsByLevel W_net t_ev h cc s c_stock)) ∧
    (∃ T, T ≤ n ∧
      let orb := Law.orbit
        (fun st => OpenComposition.closedStep comp obs channel G envDraw st (env_adm, d₀))
        (x₀, init)
      (orb T).1 site_crit < H_safe + y_safe ∧
      ((orb (T + (orb T).1 site_crit)).1 site_crit = 0 ∧
       ∀ m, (orb (T + (orb T).1 site_crit + m)).1 site_crit = 0)) ∧
    ¬ Viability.Kernel
      (OpenComposition.closedProcess comp c obs channel G envDraw jointAdm)
      (OpenComposition.closedGuard comp c (fun _ => x_crit))
      (x₀, init) := by
  have hNet := network_threshold_blindness through unobserved needs bal bal' pres acts fol fol'
    stands others stock
  have hRB : law.ReadsBelow part c_stock (fun _ => θ_sensor) := hNet.1
  let obs : (Ext → Nat) → Obs := fun x =>
    readout
      (law.take t_obs h_obs (fun _ e => if e = c_stock then x site_crit else base_level e) c_out)
      (law.give t_obs h_obs (fun _ e => if e = c_stock then x site_crit else base_level e) c_out)
  have hBlind : ∀ x y, θ_sensor ≤ x site_crit → θ_sensor ≤ y site_crit → obs x = obs y := by
    intro x y hx hy
    have hAlike := hRB h_obs h_out t_obs
      (fun _ e => if e = c_stock then x site_crit else base_level e)
      (fun _ e => if e = c_stock then y site_crit else base_level e)
      (fun _ _ => ⟨by show θ_sensor ≤ (if c_stock = c_stock then x site_crit else base_level c_stock); rw [if_pos rfl]; exact hx,
                   by show θ_sensor ≤ (if c_stock = c_stock then y site_crit else base_level c_stock); rw [if_pos rfl]; exact hy⟩)
      (fun _ _ e he => by
        show (if e = c_stock then x site_crit else base_level e) =
          (if e = c_stock then y site_crit else base_level e)
        rw [if_neg he, if_neg he])
    dsimp only [obs]
    exact congr (congrArg readout (hAlike c_out).1) (hAlike c_out).2
  have hOpen := threshold_blind_open_collapse comp c obs channel G envDraw jointAdm site_crit
    θ_sensor hBlind x_safe_hi x₀ hi_ge silent_at_hi silent_chan θ_below_noReturn hPos
    x_crit_le x_crit_pos G_most G_dep G_short yle pre_ge safe_ge eta_pos_init
    eta_stays_unwarned env_adm hAdm d₀ hTol under_headroom
  exact ⟨⟨hNet.2.1, hNet.2.2⟩, hOpen.1, hOpen.2⟩

/-! ### Witness 3B: `ThresholdBlindnessWitness` (`θ = 5`, `θ = 8` Crash vs. `θ = 10` Survival) -/

namespace ThresholdBlindnessWitness

def gThresh (_ : Unit) (e : Unit → Nat) : Nat := if 5 ≤ e () then 1 else 0

theorem gThresh_rises :
    ∀ site : Unit, RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (gThresh site) := by
  intro _ e₁ e₂ hbelow
  dsimp only [gThresh]
  cases Nat.decLe 5 (e₁ ()) with
  | isTrue h => rw [if_pos h, if_pos (Nat.le_trans h (hbelow ()))]; exact Nat.le_refl 1
  | isFalse h => rw [if_neg h]; exact Nat.zero_le _

theorem gThresh_dep :
    RegimeMargin.Coupled.Indexed.DependsOn RegimeMargin.Drawn.whole gThresh () () := by
  intro e he
  show (if 5 ≤ e () then 1 else 0) = 0
  rw [he]
  rfl

def threshComp : OpenComposition.OpenComponent Nat Bool Unit Empty Unit :=
  OpenComposition.countdownComponent 3 1 (fun _ o => !o)

def threshContract : OpenComposition.InterfaceContract threshComp 1 :=
  OpenComposition.countdownContract 3 1 0 1 1 (fun _ o => !o) (fun o => o = false)
    (by decide) (Nat.le_refl 1) (fun _ o _ ho => by rw [ho]; rfl)

def channel (em : Bool) (_ : Nat) (_ : Unit) : Bool := em
def xCrit : Unit → Nat := fun _ => 4
def warnSafe : Unit → Nat := fun _ => 10
def hSafe : Unit → Nat := fun _ => 1
def xStart : Unit → Nat := fun _ => 11

def netWeb (θ : Nat) (extra : Nat) : Web Unit Bool where
  level t c := if c then (if t < 4 + extra then θ + 3 + extra - t else θ - 1)
    else (if t ≤ 4 + extra then t else 4 + extra)
  active _ _ := True
  requires _ _ c := c
  need _ _ c := if c then θ else 0
  draws _ _ _ := False

def netFlow (θ : Nat) : Flow Unit Bool where
  present _ := [()]
  take t _ c := (Thresholds.Draw.law θ).take t () (netWeb θ 0).level c
  give t _ c := (Thresholds.Draw.law θ).give t () (netWeb θ 0).level c

def netFlow' (θ : Nat) : Flow Unit Bool where
  present _ := [()]
  take t _ c := (Thresholds.Draw.law θ).take t () (netWeb θ 1).level c
  give t _ c := (Thresholds.Draw.law θ).give t () (netWeb θ 1).level c

theorem net_through (θ : Nat) :
    (Thresholds.Draw.law θ).Through (netWeb θ 0) (fun _ c => !c = true) (fun _ => false) := by
  intro _ _ t l l' hal c
  have hAl := hal t (Nat.le_refl t)
  have hBle : Nat.ble θ (l t true) = Nat.ble θ (l' t true) :=
    ble_eq_of_iff
      ⟨fun hle => hAl.1.1 (fun d _ => match d with
          | false => Nat.zero_le _
          | true => hle) true rfl,
       fun hle' => hAl.1.2 (fun d _ => match d with
          | false => Nat.zero_le _
          | true => hle') true rfl⟩
  cases c with
  | false =>
    show (0 = 0) ∧
      (cond (Nat.ble θ (l t true)) 1 0 = cond (Nat.ble θ (l' t true)) 1 0)
    rw [hBle]
    exact ⟨rfl, rfl⟩
  | true =>
    show (cond (Nat.ble θ (l t true)) 1 0 = cond (Nat.ble θ (l' t true)) 1 0) ∧ (0 = 0)
    rw [hBle]
    exact ⟨rfl, rfl⟩

theorem net_bal5 : (netFlow 5).Balances (netWeb 5 0) := by
  intro t c
  show (netWeb 5 0).level (t + 1) c + ((Thresholds.Draw.law 5).take t () (netWeb 5 0).level c + 0) =
    (netWeb 5 0).level t c + ((Thresholds.Draw.law 5).give t () (netWeb 5 0).level c + 0)
  cases c with
  | false =>
    cases t with
    | zero => rfl
    | succ t1 => cases t1 with
      | zero => rfl
      | succ t2 => cases t2 with
        | zero => rfl
        | succ t3 => cases t3 with
          | zero => rfl
          | succ t4 =>
            cases t4 with
            | zero => rfl
            | succ t5 =>
              have ha : ¬ (t5 + 5 + 1 ≤ 4) := Nat.not_le_of_gt
                (Nat.lt_of_lt_of_le (by decide : 4 < 6) (Nat.le_add_left 6 t5))
              have hb : ¬ (t5 + 5 ≤ 4) := Nat.not_le_of_gt
                (Nat.lt_of_lt_of_le (by decide : 4 < 5) (Nat.le_add_left 5 t5))
              have hc : ¬ (t5 + 5 < 4) := Nat.not_lt_of_ge
                (Nat.le_trans (by decide : 4 ≤ 5) (Nat.le_add_left 5 t5))
              have hd : Nat.ble 5 4 = false := rfl
              show (if t5 + 5 + 1 ≤ 4 then t5 + 5 + 1 else 4) + 0 =
                (if t5 + 5 ≤ 4 then t5 + 5 else 4) +
                  ((if Nat.ble 5 (if t5 + 5 < 4 then 5 + 3 - (t5 + 5) else 4) then 1 else 0) + 0)
              rw [if_neg ha, if_neg hb, if_neg hc, hd]
              rfl
  | true =>
    cases t with
    | zero => rfl
    | succ t1 => cases t1 with
      | zero => rfl
      | succ t2 => cases t2 with
        | zero => rfl
        | succ t3 => cases t3 with
          | zero => rfl
          | succ t4 =>
            cases t4 with
            | zero => rfl
            | succ t5 =>
              have ha : ¬ (t5 + 5 + 1 < 4) := Nat.not_lt_of_ge
                (Nat.le_trans (by decide : 4 ≤ 6) (Nat.le_add_left 6 t5))
              have hb : ¬ (t5 + 5 < 4) := Nat.not_lt_of_ge
                (Nat.le_trans (by decide : 4 ≤ 5) (Nat.le_add_left 5 t5))
              have hd : Nat.ble 5 4 = false := rfl
              show (if t5 + 5 + 1 < 4 then 5 + 3 - (t5 + 5 + 1) else 4) +
                  ((if Nat.ble 5 (if t5 + 5 < 4 then 5 + 3 - (t5 + 5) else 4) then 1 else 0) + 0) =
                (if t5 + 5 < 4 then 5 + 3 - (t5 + 5) else 4) + 0
              rw [if_neg ha, if_neg hb, hd]
              rfl

theorem net_bal5' : (netFlow' 5).Balances (netWeb 5 1) := by
  intro t c
  show (netWeb 5 1).level (t + 1) c + ((Thresholds.Draw.law 5).take t () (netWeb 5 1).level c + 0) =
    (netWeb 5 1).level t c + ((Thresholds.Draw.law 5).give t () (netWeb 5 1).level c + 0)
  cases c with
  | false =>
    cases t with
    | zero => rfl
    | succ t1 => cases t1 with
      | zero => rfl
      | succ t2 => cases t2 with
        | zero => rfl
        | succ t3 => cases t3 with
          | zero => rfl
          | succ t4 => cases t4 with
            | zero => rfl
            | succ t5 => cases t5 with
              | zero => rfl
              | succ t6 =>
                have ha : ¬ (t6 + 6 + 1 ≤ 5) := Nat.not_le_of_gt
                  (Nat.lt_of_lt_of_le (by decide : 5 < 7) (Nat.le_add_left 7 t6))
                have hb : ¬ (t6 + 6 ≤ 5) := Nat.not_le_of_gt
                  (Nat.lt_of_lt_of_le (by decide : 5 < 6) (Nat.le_add_left 6 t6))
                have hc : ¬ (t6 + 6 < 5) := Nat.not_lt_of_ge
                  (Nat.le_trans (by decide : 5 ≤ 6) (Nat.le_add_left 6 t6))
                have hd : Nat.ble 5 4 = false := rfl
                show (if t6 + 6 + 1 ≤ 5 then t6 + 6 + 1 else 5) + 0 =
                  (if t6 + 6 ≤ 5 then t6 + 6 else 5) +
                    ((if Nat.ble 5 (if t6 + 6 < 5 then 5 + 3 + 1 - (t6 + 6) else 4) then 1 else 0) + 0)
                rw [if_neg ha, if_neg hb, if_neg hc, hd]
                rfl
  | true =>
    cases t with
    | zero => rfl
    | succ t1 => cases t1 with
      | zero => rfl
      | succ t2 => cases t2 with
        | zero => rfl
        | succ t3 => cases t3 with
          | zero => rfl
          | succ t4 => cases t4 with
            | zero => rfl
            | succ t5 => cases t5 with
              | zero => rfl
              | succ t6 =>
                have ha : ¬ (t6 + 6 + 1 < 5) := Nat.not_lt_of_ge
                  (Nat.le_trans (by decide : 5 ≤ 7) (Nat.le_add_left 7 t6))
                have hb : ¬ (t6 + 6 < 5) := Nat.not_lt_of_ge
                  (Nat.le_trans (by decide : 5 ≤ 6) (Nat.le_add_left 6 t6))
                have hd : Nat.ble 5 4 = false := rfl
                show (if t6 + 6 + 1 < 5 then 5 + 3 + 1 - (t6 + 6 + 1) else 4) +
                    ((if Nat.ble 5 (if t6 + 6 < 5 then 5 + 3 + 1 - (t6 + 6) else 4) then 1 else 0) + 0) =
                  (if t6 + 6 < 5 then 5 + 3 + 1 - (t6 + 6) else 4) + 0
                rw [if_neg ha, if_neg hb, hd]
                rfl

theorem blind_5_crashes :
    let obs : (Unit → Nat) → Bool := fun x =>
      decide (0 < (Thresholds.Draw.law 5).give 0 ()
        (fun _ e => if e = true then x () else 0) false)
    (∀ h cc s t_ev, false = false → ¬ (Thresholds.Draw.law 5).RespondsByLevel (netWeb 5 0) t_ev h cc s true) ∧
    ¬ Viability.Kernel
      (OpenComposition.closedProcess threshComp threshContract obs channel gThresh
        (fun _ _ => 0) (fun _ => True))
      (OpenComposition.closedGuard threshComp threshContract xCrit)
      (xStart, 1) := by
  have hMain := network_readsBelow_feeds_open_collapse
    (law := Thresholds.Draw.law 5) (W_net := netWeb 5 0) (W_net' := netWeb 5 1)
    (obs_net := fun _ c => !c = true) (part := fun _ => false)
    (L_net := netFlow 5) (L_net' := netFlow' 5) (c_stock := true) (θ_sensor := 5)
    (net_through 5) (fun _ _ h => Bool.noConfusion h) (fun _ _ _ _ => Nat.le_refl 5)
    net_bal5 net_bal5' (fun _ => rfl) (fun _ h _ _ => Bool.noConfusion h)
    (fun _ _ t c => ⟨rfl, rfl⟩) (fun _ _ t c => ⟨rfl, rfl⟩)
    (d_res := 1) (T_net := 4)
    (fun s hs => by
      cases s with
      | zero => decide
      | succ s1 => cases s1 with
        | zero => decide
        | succ s2 => cases s2 with
          | zero => decide
          | succ s3 => cases s3 with
            | zero => decide
            | succ s4 => exact absurd (Nat.lt_of_succ_lt_succ (Nat.lt_of_succ_lt_succ
                (Nat.lt_of_succ_lt_succ (Nat.lt_of_succ_lt_succ hs)))) (Nat.not_lt_zero _))
    (fun e he => by cases e with | false => rfl | true => exact absurd rfl he)
    rfl
    () rfl 0 false (fun _ => 0) (fun _ g => decide (0 < g))
    threshComp threshContract channel gThresh (fun _ _ => 0) (fun _ => True)
    () (fun _ => 5) xStart (Nat.le_refl 5)
    (fun _ => rfl) (fun _ _ => rfl)
    (Y := 1) (H_pre := 3) (H_safe := 1) (y_safe := 5) (x_crit := 4) (n := 3)
    (by decide : 5 ≤ 1 + 5) (by decide : 0 < 1 + 5) (by decide : 4 ≤ 1 + 5) (by decide : 0 < 4)
    (fun e => by
      show (if 5 ≤ e () then 1 else 0) ≤ 1
      cases Nat.decLe 5 (e ()) with
      | isTrue h => rw [if_pos h]; exact Nat.le_refl 1
      | isFalse h => rw [if_neg h]; exact Nat.zero_le 1)
    gThresh_dep
    (fun e he => by
      show (if 5 ≤ e () then 1 else 0) < 1
      rw [if_neg (Nat.not_le_of_lt he)]
      exact Nat.one_pos)
    (by decide : 1 < 3)
    (fun s _ hpos => match s, hpos with
      | 0, hpos => absurd hpos (Nat.not_lt_zero 0)
      | _ + 1, _ => by show 3 ≤ (3 : Nat); exact Nat.le_refl 3)
    (fun s _ => match s with
      | 0 => by show 1 ≤ (1 : Nat); exact Nat.le_refl 1
      | _ + 1 => by show 1 ≤ (3 : Nat); exact Nat.le_trans (by decide : 1 ≤ 3) (Nat.le_refl 3))
    Nat.one_pos
    (fun s _ _ _ hs => by
      show 0 < (if false then s - 1 else s)
      exact hs)
    () trivial () (fun _ => trivial)
    (by decide : 11 < (1 + 5) + (3 - 1) * 3)
  exact ⟨hMain.1.2, hMain.2.2⟩

def orbitWithTheta (θ : Nat) : Nat → (Unit → Nat) × Nat :=
  Law.orbit
    (fun st => OpenComposition.closedStep threshComp (fun x => Nat.ble θ (x ()))
      channel gThresh (fun _ _ => 0) st ((), ()))
    (xStart, 1)

theorem theta_5_hits_zero : (orbitWithTheta 5 7).1 () = 0 := rfl

theorem theta_8_also_crashes_under_lag1 : (orbitWithTheta 8 7).1 () = 0 := rfl

theorem theta_8_crashes_kernel :
    ¬ Viability.Kernel
      (OpenComposition.closedProcess threshComp threshContract (fun x => Nat.ble 8 (x ()))
        channel gThresh (fun _ _ => 0) (fun _ => True))
      (OpenComposition.closedGuard threshComp threshContract xCrit)
      (xStart, 1) := by
  intro kern
  have hReach : Reach
      (OpenComposition.closedProcess threshComp threshContract (fun x => Nat.ble 8 (x ()))
        channel gThresh (fun _ _ => 0) (fun _ => True))
      (xStart, 1) (orbitWithTheta 8 7) :=
    Viability.history_reach (adm := OpenComposition.closedAdm threshContract (fun _ => True))
      (f := OpenComposition.closedStep threshComp (fun x => Nat.ble 8 (x ()))
        channel gThresh (fun _ _ => 0))
      (s := (xStart, 1)) (d := fun _ => ((), ())) (fun _ => ⟨trivial, fun _ => trivial⟩) 7
  have hGuard := kern (orbitWithTheta 8 7) hReach
  have h4 : 4 ≤ (orbitWithTheta 8 7).1 () := hGuard.1 ()
  have h0 : (orbitWithTheta 8 7).1 () = 0 := theta_8_also_crashes_under_lag1
  rw [h0] at h4
  exact Nat.not_succ_le_zero 3 h4

theorem theta_10_viable :
    Viability.Kernel
      (OpenComposition.closedProcess threshComp threshContract (fun x => Nat.ble 10 (x ()))
        channel gThresh (fun _ _ => 0) (fun _ => True))
      (OpenComposition.closedGuard threshComp threshContract xCrit)
      (xStart, 1) := by
  let Inv : (Unit → Nat) × Nat → Prop :=
    fun st => (st.2 = 1 ∧ 8 ≤ st.1 ()) ∨ (st.2 = 0 ∧ 6 ≤ st.1 ())
  refine ({ within := ?_, closed := ?_ } : Viability.Certificate _ _ Inv).kernel
    (Or.inl ⟨rfl, (by decide : 8 ≤ 11)⟩)
  · intro ⟨x, s⟩ hInv
    dsimp only [Inv] at hInv
    refine ⟨fun site => ?_, ?_⟩
    · cases site
      cases hInv with
      | inl h => exact Nat.le_trans (by decide : 4 ≤ 8) h.2
      | inr h => exact Nat.le_trans (by decide : 4 ≤ 6) h.2
    · cases hInv with
      | inl h => exact threshContract.cert.within s (by rw [h.1]; exact Nat.le_refl 1)
      | inr h => exact threshContract.cert.within s (by rw [h.1]; exact Nat.zero_le 1)
  · intro ⟨x, s⟩ _ ⟨x', s'⟩ ⟨_, hStep⟩ hInv
    dsimp only [Inv] at hInv
    cases hStep
    dsimp only [OpenComposition.closedStep, OpenComposition.closedStepWith,
      RegimeMargin.Coupled.Indexed.step, RegimeMargin.Coupled.Indexed.left,
      RegimeMargin.Drawn.whole, threshComp, OpenComposition.countdownComponent,
      OpenComposition.OpenComponent.ofOpenLoop, OpenComposition.countdownLoop,
      channel, gThresh]
    cases hInv with
    | inl h =>
      obtain ⟨hs1, hx8⟩ := h
      cases Nat.decLe 10 (x ()) with
      | isTrue h10 =>
        have hBle : Nat.ble 10 (x ()) = true := Nat.ble_eq_true_of_le h10
        have hs0 : ¬ (s = 0) := fun he => by rw [hs1] at he; exact Nat.noConfusion he
        have h7 : 7 ≤ x () - 3 := Naturals.le_sub_of_add_le (a := 3) (b := 7) h10
        have h5 : 5 ≤ x () - 3 := Nat.le_trans (by decide : 5 ≤ 7) h7
        left
        refine ⟨?_, ?_⟩
        · show (if !(Nat.ble 10 (x ())) then s - 1 else s) = 1
          rw [hBle, hs1]
          rfl
        · show 8 ≤ (x () - ((if s = 0 then 1 else 3) + 0)) +
            (if 5 ≤ x () - ((if s = 0 then 1 else 3) + 0) then 1 else 0)
          rw [if_neg hs0, Nat.add_zero, if_pos h5]
          exact Nat.add_le_add_right h7 1
      | isFalse hn10 =>
        have hlt10 : x () < 10 := Nat.lt_of_not_le hn10
        have hBle : Nat.ble 10 (x ()) = false := Naturals.ble_false_of_lt hlt10
        have hs0 : ¬ (s = 0) := fun he => by rw [hs1] at he; exact Nat.noConfusion he
        have h5 : 5 ≤ x () - 3 := Naturals.le_sub_of_add_le (a := 3) (b := 5) hx8
        right
        refine ⟨?_, ?_⟩
        · show (if !(Nat.ble 10 (x ())) then s - 1 else s) = 0
          rw [hBle, hs1]
          rfl
        · show 6 ≤ (x () - ((if s = 0 then 1 else 3) + 0)) +
            (if 5 ≤ x () - ((if s = 0 then 1 else 3) + 0) then 1 else 0)
          rw [if_neg hs0, Nat.add_zero, if_pos h5]
          exact Nat.add_le_add_right h5 1
    | inr h =>
      obtain ⟨hs0, hx6⟩ := h
      have h5 : 5 ≤ x () - 1 := Naturals.le_sub_of_add_le (a := 1) (b := 5) hx6
      right
      refine ⟨?_, ?_⟩
      · show (if !(Nat.ble 10 (x ())) then s - 1 else s) = 0
        rw [hs0]
        cases Nat.ble 10 (x ()) <;> rfl
      · show 6 ≤ (x () - ((if s = 0 then 1 else 3) + 0)) +
          (if 5 ≤ x () - ((if s = 0 then 1 else 3) + 0) then 1 else 0)
        rw [if_pos hs0, Nat.add_zero, if_pos h5]
        exact Nat.add_le_add_right h5 1

end ThresholdBlindnessWitness

/-! ## Part 4: Blanket-to-`OpenComponent` Interface Characterization & Sparse-Relay Breach -/

/-- Blanket-aligned open agent specification with explicit sensory alarm port `S × Bool`:
internal and active updates depend solely on `(I, S × Bool, A, Dist)`, active state `A` solely
determines boundary draws `drawBoundary`, and local assume-guarantee margin laws hold. -/
structure BlanketContractSpec (I S A Ext Dist : Type) where
  nextInternal : I → S × Bool → A → Dist → I
  nextActive : I → S × Bool → A → Dist → A
  drawBoundary : A → Ext → Nat
  emitBoundary : (I × A) → S → Bool
  silenceLoad : (I × A) → Nat
  favours : (I × A) → Prop
  initI : I
  initA : A
  tol : S × Bool → Dist → Prop
  warnSensory : S → Prop
  preCapExt : Ext → Nat
  postAllowanceExt : Ext → Nat
  maxSilence : Nat
  maxLag : Nat
  K : (I × A) → Prop
  eta : (I × A) → Nat
  init_in : K (initI, initA)
  within : ∀ p, K p →
    (∀ k, drawBoundary p.2 k ≤ preCapExt k) ∧
    silenceLoad p ≤ maxSilence ∧
    (eta p = 0 → ¬ favours p ∧ ∀ k, drawBoundary p.2 k ≤ postAllowanceExt k)
  closed : ∀ p s al d, K p → tol (s, al) d →
    K (nextInternal p.1 (s, al) p.2 d, nextActive p.1 (s, al) p.2 d)
  eta_bound : ∀ p, K p → eta p ≤ maxLag
  emits_on_warn : ∀ p s, K p → warnSensory s → emitBoundary p s = true
  eta_alarm_step : ∀ p s d, tol (s, true) d → K p → 0 < eta p →
    eta (nextInternal p.1 (s, true) p.2 d, nextActive p.1 (s, true) p.2 d) < eta p
  eta_alarm_zero : ∀ p s d, tol (s, true) d → K p → eta p = 0 →
    eta (nextInternal p.1 (s, true) p.2 d, nextActive p.1 (s, true) p.2 d) = 0

/-- Constructive lift from `BlanketContractSpec` to `OpenComposition.OpenComponent` (`Int := Empty`). -/
def componentOfBlanket {I S A Ext Dist : Type}
    (spec : BlanketContractSpec I S A Ext Dist) :
    OpenComposition.OpenComponent (I × A) S Dist Empty Ext where
  next p sb d := (spec.nextInternal p.1 sb p.2 d, spec.nextActive p.1 sb p.2 d)
  drawInt _ e := Empty.elim e
  drawExt p := spec.drawBoundary p.2
  emitAlarm := spec.emitBoundary
  silenceLoad := spec.silenceLoad
  favours := spec.favours

/-- Constructive lift from `BlanketContractSpec` to `OpenComposition.InterfaceContract`. -/
def contractOfBlanket {I S A Ext Dist : Type}
    (spec : BlanketContractSpec I S A Ext Dist) :
    OpenComposition.InterfaceContract (componentOfBlanket spec) (spec.initI, spec.initA) where
  tol := spec.tol
  warnObs := spec.warnSensory
  preCapInt e := Empty.elim e
  preCapExt := spec.preCapExt
  postBudgetInt e := Empty.elim e
  postBudgetExt := spec.postAllowanceExt
  maxSilence := spec.maxSilence
  maxLag := spec.maxLag
  K := spec.K
  eta := spec.eta
  init_in := spec.init_in
  cert := Viability.certificate_disturbed_iff.mpr
    ⟨fun p hp =>
      let w := spec.within p hp
      ⟨fun e => Empty.elim e, w.1, w.2.1, fun h0 =>
        let h := w.2.2 h0
        ⟨h.1, fun e => Empty.elim e, h.2⟩⟩,
     fun p m adm hp => spec.closed p m.1.1 m.1.2 m.2 hp adm⟩
  eta_bound := spec.eta_bound
  emits_on_warn := spec.emits_on_warn
  eta_alarm_step := spec.eta_alarm_step
  eta_alarm_zero := spec.eta_alarm_zero

/-- **Blanket-Aligned Composition Viability (`BlanketCouplings` × `OpenComposition`)**:
two `BlanketContractSpec` agents composed horizontally induce a `BlanketDetermined` lifted
closed process (`closedProcess_blanketDetermined`) AND preserve `Viability.Kernel` via
`OpenComposition.compose_close_interchange`. -/
theorem blanket_compose_closed_viable
    {I₁ S₁ A₁ Dist₁ I₂ S₂ A₂ Dist₂ Ext Env : Type}
    (sp₁ : BlanketContractSpec I₁ S₁ A₁ Ext Dist₁)
    (sp₂ : BlanketContractSpec I₂ S₂ A₂ Ext Dist₂)
    (obs₁ : (Ext → Nat) → S₁) (obs₂ : (Ext → Nat) → S₂)
    (channel : Bool → Nat → Env → Bool)
    (G : Ext → (Ext → Nat) → Nat)
    (envDraw : Env → Ext → Nat) (envCap : Ext → Nat) (jointAdm : Env → Prop)
    (env_within : ∀ env, jointAdm env → ∀ k, envDraw env k ≤ envCap k)
    (x_crit warnLevel H_safe x₀ : Ext → Nat)
    (obs_detects : ∀ x k, x k < warnLevel k → sp₁.warnSensory (obs₁ x) ∨ sp₂.warnSensory (obs₂ x))
    (channel_fires : ∀ load env, jointAdm env → load ≤ sp₁.maxSilence + sp₂.maxSilence →
      channel true load env = true)
    (G_rises : ∀ k, RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (G k))
    (post_viable : ∀ k, x_crit k ≤
      RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole G H_safe x_crit k)
    (post_allowance : ∀ k, (sp₁.postAllowanceExt k + sp₂.postAllowanceExt k) + envCap k ≤ H_safe k)
    (warn_margin : ∀ k, x_crit k +
      (CoreHelpers.natMax sp₁.maxLag sp₂.maxLag + 1) *
        ((sp₁.preCapExt k + sp₂.preCapExt k) + envCap k) ≤ warnLevel k)
    (init_margin : ∀ k, x_crit k +
      CoreHelpers.natMax (sp₁.eta (sp₁.initI, sp₁.initA)) (sp₂.eta (sp₂.initI, sp₂.initA)) *
        ((sp₁.preCapExt k + sp₂.preCapExt k) + envCap k) ≤ x₀ k) :
    BlanketCouplings.BlanketDetermined
      (BlanketCouplings.liftedClosedProcess
        (OpenComposition.OpenComponent.compose (componentOfBlanket sp₁) (componentOfBlanket sp₂))
        (OpenComposition.composeContract (contractOfBlanket sp₁) (contractOfBlanket sp₂))
        (fun x => (obs₁ x, obs₂ x)) channel G envDraw jointAdm) ∧
    Viability.Kernel
      (OpenComposition.closedProcess
        (OpenComposition.OpenComponent.compose (componentOfBlanket sp₁) (componentOfBlanket sp₂))
        (OpenComposition.composeContract (contractOfBlanket sp₁) (contractOfBlanket sp₂))
        (fun x => (obs₁ x, obs₂ x)) channel G envDraw jointAdm)
      (OpenComposition.closedGuard
        (OpenComposition.OpenComponent.compose (componentOfBlanket sp₁) (componentOfBlanket sp₂))
        (OpenComposition.composeContract (contractOfBlanket sp₁) (contractOfBlanket sp₂))
        x_crit)
      (x₀, ((sp₁.initI, sp₁.initA), (sp₂.initI, sp₂.initA))) :=
  ⟨(BlanketCouplings.closedProcess_blanketDetermined
      (OpenComposition.OpenComponent.compose (componentOfBlanket sp₁) (componentOfBlanket sp₂))
      (OpenComposition.composeContract (contractOfBlanket sp₁) (contractOfBlanket sp₂))
      (fun x => (obs₁ x, obs₂ x)) channel G envDraw jointAdm).1,
   OpenComposition.compose_close_interchange (componentOfBlanket sp₁) (componentOfBlanket sp₂)
      (contractOfBlanket sp₁) (contractOfBlanket sp₂) obs₁ obs₂ channel G envDraw envCap
      jointAdm env_within x_crit warnLevel H_safe x₀ obs_detects channel_fires G_rises
      post_viable post_allowance warn_margin init_margin⟩

/-- **Composed Blanket Screening (`Blanket.Blanketed.agent_through_sensory` × `BlanketCouplings`)**:
for any composed `BlanketContractSpec` pair `(sp₁ ⊕ sp₂)`:
(1) internal private transitions cannot alter substrate trajectories `x` while combined active draws
    match before `n` (`closedComponent_blanketed_course`), and
(2) sensory observations `(obs₁ x, obs₂ x)` screen external substrate disturbances identically for
    the composed internal/active states (`Blanket.Blanketed.agent_through_sensory`). -/
theorem blanket_compose_screening
    {I₁ S₁ A₁ Dist₁ I₂ S₂ A₂ Dist₂ Ext Env : Type}
    (sp₁ : BlanketContractSpec I₁ S₁ A₁ Ext Dist₁)
    (sp₂ : BlanketContractSpec I₂ S₂ A₂ Ext Dist₂)
    (obs₁ : (Ext → Nat) → S₁) (obs₂ : (Ext → Nat) → S₂)
    (channel : Bool → Nat → Env → Bool)
    (G : Ext → (Ext → Nat) → Nat) (envDraw : Env → Ext → Nat)
    (env : Env) (d₁ : Dist₁) (d₂ : Dist₂) :
    let comp := OpenComposition.OpenComponent.compose (componentOfBlanket sp₁) (componentOfBlanket sp₂)
    let obs := fun x => (obs₁ x, obs₂ x)
    let stepFn := fun st => OpenComposition.closedStep comp obs channel G envDraw st (env, (d₁, d₂))
    let b := BlanketCouplings.closedBlanketLaw comp obs channel G envDraw env (d₁, d₂)
    (∀ {x₀ : Ext → Nat} {p₁ p₂ : (I₁ × A₁) × (I₂ × A₂)} (n : Nat),
      (∀ k, k < n →
        comp.drawExt (Law.orbit stepFn (x₀, p₁) k).2 =
        comp.drawExt (Law.orbit stepFn (x₀, p₂) k).2) →
      (Law.orbit stepFn (x₀, p₁) n).1 = (Law.orbit stepFn (x₀, p₂) n).1) ∧
    (∀ {x₁ x₂ : Ext → Nat} {p₀ : (I₁ × A₁) × (I₂ × A₂)} (n : Nat),
      (∀ k, k < n →
        (b.course (BlanketCouplings.closedParts comp obs x₁ p₀) k).sensory =
        (b.course (BlanketCouplings.closedParts comp obs x₂ p₀) k).sensory) →
      (Law.orbit stepFn (x₁, p₀) n).2 = (Law.orbit stepFn (x₂, p₀) n).2) := by
  let comp := OpenComposition.OpenComponent.compose (componentOfBlanket sp₁) (componentOfBlanket sp₂)
  let obs := fun x => (obs₁ x, obs₂ x)
  let stepFn := fun st => OpenComposition.closedStep comp obs channel G envDraw st (env, (d₁, d₂))
  let b := BlanketCouplings.closedBlanketLaw comp obs channel G envDraw env (d₁, d₂)
  have hCourse := (BlanketCouplings.closedComponent_blanketed_course comp obs channel G envDraw env (d₁, d₂)).1
  refine ⟨(BlanketCouplings.closedComponent_blanketed_course comp obs channel G envDraw env (d₁, d₂)).2,
    fun {x₁ x₂ p₀} n hSens => ?_⟩
  have hAg := b.agent_through_sensory
    (x := BlanketCouplings.closedParts comp obs x₁ p₀)
    (y := BlanketCouplings.closedParts comp obs x₂ p₀) rfl rfl n hSens
  have hInt := hAg.1
  rw [hCourse x₁ p₀ n, hCourse x₂ p₀ n] at hInt
  exact hInt

/-- **Blanket Isolation Necessity**:
any 4-part dynamics `Q` exhibiting a direct external-to-agent bypass (`p₁, p₂` agree on
`internal, sensory, active` yet diverge on `q.internal` or `q.active` under the same move `m`)
is NEITHER `BlanketDetermined`, NOR realized by any `Blanket.Blanketed` law, NOR admitted by any
`BlanketConsistentFamily`. -/
theorem blanket_isolation_necessary_for_determined_parts
    {I S A E M : Type} (Q : Process (Blanket.Parts I S A E) M)
    (hBypass : ∃ p₁ p₂ m q₁ q₂,
      p₁.internal = p₂.internal ∧ p₁.sensory = p₂.sensory ∧ p₁.active = p₂.active ∧
      Q.step p₁ m q₁ ∧ Q.step p₂ m q₂ ∧ (q₁.internal ≠ q₂.internal ∨ q₁.active ≠ q₂.active)) :
    ¬ BlanketCouplings.BlanketDetermined Q ∧
    (¬ ∃ (b : Blanket.Blanketed I S A E), ∀ p m q, Q.step p m q → q = b.step p) ∧
    (∀ H : (Nat → Blanket.Parts I S A E) → (Nat → M) → Prop,
      (∀ p m q, Q.step p m q → ∃ g ms i, H g ms ∧ g i = p ∧ ms i = m ∧ g (i + 1) = q) →
      ¬ BlanketCouplings.BlanketConsistentFamily H) := by
  obtain ⟨p₁, p₂, m, q₁, q₂, hi, hs, ha, hstep₁, hstep₂, hneq⟩ := hBypass
  have hNotDet : ¬ BlanketCouplings.BlanketDetermined Q := by
    intro hDet
    have hSame : BlanketCouplings.agentReads p₁ = BlanketCouplings.agentReads p₂ := by
      dsimp only [BlanketCouplings.agentReads]
      exact congr (congrArg Prod.mk hi) (congr (congrArg Prod.mk hs) ha)
    have hEq := hDet.1 p₁ p₂ m q₁ q₂ hSame hstep₁ hstep₂
    cases hneq with
    | inl hni => exact hni (congrArg Prod.fst hEq)
    | inr hna => exact hna (congrArg Prod.snd hEq)
  have hNotBlk : ¬ ∃ (b : Blanket.Blanketed I S A E), ∀ p m q, Q.step p m q → q = b.step p := by
    rintro ⟨b, hb⟩
    have hq₁ := hb p₁ m q₁ hstep₁
    have hq₂ := hb p₂ m q₂ hstep₂
    have hi' : q₁.internal = q₂.internal := by
      have h1 := congrArg Blanket.Parts.internal hq₁
      have h2 := congrArg Blanket.Parts.internal hq₂
      exact h1.trans ((Blanket.congr3 b.nextInternal hi hs ha).trans h2.symm)
    have ha' : q₁.active = q₂.active := by
      have h1 := congrArg Blanket.Parts.active hq₁
      have h2 := congrArg Blanket.Parts.active hq₂
      exact h1.trans ((Blanket.congr3 b.nextActive hi hs ha).trans h2.symm)
    cases hneq with
    | inl hni => exact hni hi'
    | inr hna => exact hna ha'
  have hNotFam : ∀ H : (Nat → Blanket.Parts I S A E) → (Nat → M) → Prop,
      (∀ p m q, Q.step p m q → ∃ g ms i, H g ms ∧ g i = p ∧ ms i = m ∧ g (i + 1) = q) →
      ¬ BlanketCouplings.BlanketConsistentFamily H := by
    intro H hReal hCons
    obtain ⟨g₁, ms₁, i₁, hH₁, hgi₁, hmi₁, hg₁'⟩ := hReal p₁ m q₁ hstep₁
    obtain ⟨g₂, ms₂, i₂, hH₂, hgi₂, hmi₂, hg₂'⟩ := hReal p₂ m q₂ hstep₂
    have hSame : BlanketCouplings.agentReads (g₁ i₁) = BlanketCouplings.agentReads (g₂ i₂) := by
      rw [hgi₁, hgi₂]
      dsimp only [BlanketCouplings.agentReads]
      exact congr (congrArg Prod.mk hi) (congr (congrArg Prod.mk hs) ha)
    have hEq := hCons.1 g₁ ms₁ g₂ ms₂ i₁ i₂ hH₁ hH₂ hSame (hmi₁.trans hmi₂.symm)
    rw [hg₁', hg₂'] at hEq
    cases hneq with
    | inl hni => exact hni (congrArg Prod.fst hEq)
    | inr hna => exact hna (congrArg Prod.snd hEq)
  exact ⟨hNotDet, hNotBlk, hNotFam⟩

/-- **Unblanketed Bypass Cannot Be Realized by Any `OpenComponent` (`liftedClosedProcess`)**:
any `Parts`-process `Q` with a direct external-to-agent bypass cannot agree step-for-step with
`BlanketCouplings.liftedClosedProcess` for ANY `OpenComponent` / `InterfaceContract`. -/
theorem blanket_parts_not_openComponent_realizable
    {S Obs Dist Int Ext Env : Type}
    (Q : Process (Blanket.Parts S Obs (Ext → Nat) (Ext → Nat)) (Env × Dist))
    (hBypass : ∃ p₁ p₂ m q₁ q₂,
      p₁.internal = p₂.internal ∧ p₁.sensory = p₂.sensory ∧ p₁.active = p₂.active ∧
      Q.step p₁ m q₁ ∧ Q.step p₂ m q₂ ∧ (q₁.internal ≠ q₂.internal ∨ q₁.active ≠ q₂.active)) :
    ¬ ∃ (C : OpenComposition.OpenComponent S Obs Dist Int Ext) (init : S)
        (c : OpenComposition.InterfaceContract C init) (obs : (Ext → Nat) → Obs)
        (channel : Bool → Nat → Env → Bool) (G : Ext → (Ext → Nat) → Nat)
        (envDraw : Env → Ext → Nat) (jointAdm : Env → Prop),
      ∀ s a t,
        (BlanketCouplings.liftedClosedProcess C c obs channel G envDraw jointAdm).step s a t ↔
          Q.step s a t := by
  rintro ⟨C, init, c, obs, channel, G, envDraw, jointAdm, hEquiv⟩
  have hDetLift := (BlanketCouplings.closedProcess_blanketDetermined C c obs channel G envDraw jointAdm).1
  have hDetQ : BlanketCouplings.BlanketDetermined Q :=
    BlanketCouplings.BlanketDetermined.of_le (fun s a t hs => (hEquiv s a t).mpr hs) hDetLift
  exact (blanket_isolation_necessary_for_determined_parts Q hBypass).1 hDetQ

/-! ### Witness 4: `SparseRelayBreachWitness` (Blanketed Composition vs. External Bypass Breach) -/

namespace SparseRelayBreachWitness

def gDelay (_ : Unit) (e : Unit → Nat) : Nat := if 3 ≤ e () then 1 else 0

theorem gDelay_rises :
    ∀ site : Unit, RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (gDelay site) := by
  intro _ e₁ e₂ hbelow
  dsimp only [gDelay]
  cases Nat.decLe 3 (e₁ ()) with
  | isTrue h => rw [if_pos h, if_pos (Nat.le_trans h (hbelow ()))]; exact Nat.le_refl 1
  | isFalse h => rw [if_neg h]; exact Nat.zero_le _

def sp₁ : BlanketContractSpec Unit Bool Nat Unit Unit where
  nextInternal _ _ _ _ := ()
  nextActive _ _ a _ := a
  drawBoundary a _ := a
  emitBoundary _ _ := false
  silenceLoad _ := 0
  favours _ := False
  initI := ()
  initA := 1
  tol _ _ := True
  warnSensory _ := False
  preCapExt _ := 1
  postAllowanceExt _ := 1
  maxSilence := 0
  maxLag := 0
  K p := p.2 = 1
  eta _ := 0
  init_in := rfl
  within _ hp := ⟨fun _ => hp ▸ Nat.le_refl 1, Nat.le_refl 0,
    fun _ => ⟨fun f => f, fun _ => hp ▸ Nat.le_refl 1⟩⟩
  closed _ _ _ _ hp _ := hp
  eta_bound _ _ := Nat.le_refl 0
  emits_on_warn _ _ _ hw := False.elim hw
  eta_alarm_step _ _ _ _ _ hpos := absurd hpos (Nat.not_lt_zero 0)
  eta_alarm_zero _ _ _ _ _ _ := rfl

def sp₂ : BlanketContractSpec Unit Bool Nat Unit Unit where
  nextInternal _ sb _ _ := ()
  nextActive _ sb a _ := if sb.2 then 0 else a
  drawBoundary a _ := a
  emitBoundary _ s := s
  silenceLoad _ := 0
  favours p := 0 < p.2
  initI := ()
  initA := 1
  tol _ _ := True
  warnSensory s := s = true
  preCapExt _ := 1
  postAllowanceExt _ := 0
  maxSilence := 0
  maxLag := 1
  K p := p.2 ≤ 1
  eta p := p.2
  init_in := Nat.le_refl 1
  within p hp := ⟨fun _ => hp, Nat.le_refl 0, fun h0 =>
    ⟨by show ¬ (0 < p.2); rw [h0]; exact Nat.lt_irrefl 0,
     fun _ => by rw [h0]; exact Nat.le_refl 0⟩⟩
  closed p s al _ hp _ := by
    show (if al then 0 else p.2) ≤ 1
    cases al with
    | true => exact Nat.zero_le 1
    | false => exact hp
  eta_bound _ hp := hp
  emits_on_warn _ _ _ hs := hs
  eta_alarm_step p _ _ _ _ hpos := by
    show 0 < p.2
    exact hpos
  eta_alarm_zero _ _ _ _ _ _ := rfl

def channel (em : Bool) (_ : Nat) (_ : Unit) : Bool := em
def xCrit : Unit → Nat := fun _ => 5
def warnLvl : Unit → Nat := fun _ => 9
def hSafe : Unit → Nat := fun _ => 1
def xStart : Unit → Nat := fun _ => 9

theorem honest_blanket_compose_viable :
    BlanketCouplings.BlanketDetermined
      (BlanketCouplings.liftedClosedProcess
        (OpenComposition.OpenComponent.compose (componentOfBlanket sp₁) (componentOfBlanket sp₂))
        (OpenComposition.composeContract (contractOfBlanket sp₁) (contractOfBlanket sp₂))
        (fun x => (false, Nat.blt (x ()) 9)) channel gDelay (fun _ _ => 0) (fun _ => True)) ∧
    Viability.Kernel
      (OpenComposition.closedProcess
        (OpenComposition.OpenComponent.compose (componentOfBlanket sp₁) (componentOfBlanket sp₂))
        (OpenComposition.composeContract (contractOfBlanket sp₁) (contractOfBlanket sp₂))
        (fun x => (false, Nat.blt (x ()) 9)) channel gDelay (fun _ _ => 0) (fun _ => True))
      (OpenComposition.closedGuard
        (OpenComposition.OpenComponent.compose (componentOfBlanket sp₁) (componentOfBlanket sp₂))
        (OpenComposition.composeContract (contractOfBlanket sp₁) (contractOfBlanket sp₂))
        xCrit)
      (xStart, ((sp₁.initI, sp₁.initA), (sp₂.initI, sp₂.initA))) :=
  blanket_compose_closed_viable sp₁ sp₂ (fun _ => false) (fun x => Nat.blt (x ()) 9)
    channel gDelay (fun _ _ => 0) (fun _ => 0) (fun _ => True)
    (fun _ _ _ => Nat.le_refl 0) xCrit warnLvl hSafe xStart
    (fun x site hlt => by
      cases site
      exact .inr (Nat.ble_eq_true_of_le hlt))
    (fun _ _ _ _ => rfl) gDelay_rises
    (fun site => by cases site; decide)
    (fun site => by cases site; decide)
    (fun site => by cases site; decide)
    (fun site => by cases site; decide)

def breachStep (p : Blanket.Parts Unit Bool Nat Bool) : Blanket.Parts Unit Bool Nat Bool :=
  ⟨(), p.sensory, if p.external then 2 else 1, p.external⟩

def breachProcess : Process (Blanket.Parts Unit Bool Nat Bool) Unit :=
  ⟨fun p _ q => q = breachStep p⟩

theorem breach_not_blanketDetermined :
    ¬ BlanketCouplings.BlanketDetermined breachProcess ∧
    (¬ ∃ (b : Blanket.Blanketed Unit Bool Nat Bool),
      ∀ p m q, breachProcess.step p m q → q = b.step p) := by
  have hIso := blanket_isolation_necessary_for_determined_parts breachProcess
    ⟨⟨(), false, 1, false⟩, ⟨(), false, 1, true⟩, (),
     ⟨(), false, 1, false⟩, ⟨(), false, 2, true⟩,
     rfl, rfl, rfl, rfl, rfl, Or.inr (by decide)⟩
  exact ⟨hIso.1, hIso.2.1⟩

def breachSubstrateStep (x : Nat) : Nat := RegimeMargin.step (fun z => gDelay () (fun _ => z)) 3 x

theorem breach_crashes_at_four : Law.orbit breachSubstrateStep 9 4 = 0 := rfl

end SparseRelayBreachWitness

end ActiveInquiryLoop

end Becoming



