/-
AI-written (Wave U5, 2026-11-24).
`Becoming.MasterSpine` — End-to-end 0-axiom `Init`-only compositional master spine.

No incomplete proofs, zero axioms (0 `propext`, 0 `Classical.choice`, 0 `Quot.sound`, 0 Streicher K),
zero `private` declarations, zero unnamed `instance`s, and zero economic metaphors.
-/

import Becoming.AlignmentSpine
import Becoming.PolyComposition
import Becoming.CausalAbstraction
import Becoming.ActiveInquiryLoop
import Becoming.EvolutionaryDrawdown
import Becoming.EndogenousOrder
import Becoming.Direction
import Becoming.GrammarLaws
import Becoming.GrammarMap

/-!
# Becoming Master Spine (`Becoming.MasterSpine`)

AI-written (Wave U5) constructive 0-axiom core integration joining:

1. **Section 1 — Constructive Compositional Adapters:**
   Uniform-carrier polynomial-to-open lifting (`polyUniformToOpenComponent`,
   `polyUniformToOpenContract`, `polyUniformToOpen_closedStep_eq`), genuinely coupled
   hidden-sealed blanket composition (`wholeInnerBlk`, `wholeSealedLeft`, `wholeOp`), and
   constructive post-probe `Run` extraction (`postProbeRun`) avoiding `.injEq`, `propext`, and
   Streicher K.
2. **Section 2 — Unified `WholeArchitecture` (`Type 0`) & Coupled Theorems:**
   Unites `ActiveInquiryLoop`, `OpenComposition.hide`/`compose`, `PolyComposition.anchoredSelfModComponent`,
   `PolyComposition.coupled_closed_lax_kernel`, non-constant `CausalGoAlike`, substantive
   `EvolutionaryDrawdown` multi-site `Balances` / `ReadOffExchange`, `EndogenousOrder` lineages +
   `OrderUpdater` + grounded `CourseRealization` Nash restoration, plus `replace_right_viable`,
   `ScopeMode` bridge, and explicit lifts across all 5 `shared_laws` families + `GrammarMap`.
3. **Section 3 — Obstruction & Sharpness Panorama:**
   Direct-reference aggregation of sharpness and obstruction witnesses across the entire core.
4. **Section 4 — K6 Ethics-Chain Compatibility, Metaethical Firewall, & Master Theorem:**
   Full K6 chain joined with unconditional `not_entails` firewalls and `whole_becoming_master_theorem`.
5. **Section 5 — Concrete Integrated Witness (`WholeBecomingWitness`):**
   Constructive finite-arithmetic witness realizing every coupled invariant of `WholeArchitecture`
   and `whole_becoming_master_theorem`.
-/

namespace Becoming

namespace MasterSpine

open Generative

/-! ## Section 1: Constructive Compositional Adapters -/

/-- Lift a uniform-carrier `PolyComponent` (`S`, `Obs`, `Dist`, `Int`, `Ext` independent of mode)
into an `OpenComposition.OpenComponent` on `(Σ _ : Mode, S)`. -/
def polyUniformToOpenComponent {Mode S Obs Dist Int Ext : Type}
    (C : PolyComposition.PolyComponent Mode (fun _ => S) (fun _ => Obs) (fun _ => Dist)
      (fun _ => Int) (fun _ => Ext)) :
    OpenComposition.OpenComponent (Σ _ : Mode, S) Obs Dist Int Ext where
  next p oa d := C.next p oa d
  drawInt p j := C.drawInt p j
  drawExt p k := C.drawExt p k
  emitAlarm p o := C.emitAlarm p.1 p.2 o
  silenceLoad p := C.silenceLoad p
  favours p := C.favours p

/-- Closed-loop step along single-port routing coincides definitionally between
`PolyComposition.polyClosedStep` and `OpenComposition.closedStep` on uniform carriers. -/
theorem polyUniformToOpen_closedStep_eq {Mode S Obs Dist Int Ext Env : Type}
    (C : PolyComposition.PolyComponent Mode (fun _ => S) (fun _ => Obs) (fun _ => Dist)
      (fun _ => Int) (fun _ => Ext))
    (obs : (Ext → Nat) → Obs)
    (channel : Bool → Nat → Env → Bool)
    (G : Ext → (Ext → Nat) → Nat)
    (envDraw : Env → Ext → Nat)
    (st : (Ext → Nat) × (Σ _ : Mode, S))
    (act : Env × Dist) :
    PolyComposition.polyClosedStep C (fun _ k => [k]) (fun _ => obs) channel G envDraw st act =
      OpenComposition.closedStep (polyUniformToOpenComponent C) obs channel G envDraw st act :=
  rfl

/-- Lift a uniform-carrier `PolyContract` to an `OpenComposition.InterfaceContract` via explicit
uniform tolerance, warning-lifting (`warn_lifts : ∀ m o, warnObsU o → c.warnObs m o`), and
allowance envelopes. Proves `cert.closed` with `hm := rfl`, introducing zero `propext`. -/
def polyUniformToOpenContract {Mode S Obs Dist Int Ext : Type}
    {C : PolyComposition.PolyComponent Mode (fun _ => S) (fun _ => Obs) (fun _ => Dist)
      (fun _ => Int) (fun _ => Ext)}
    {init : Σ _ : Mode, S}
    (c : PolyComposition.PolyContract C init)
    (tolU : Obs × Bool → Dist → Prop)
    (tol_lifts : ∀ m oa d, tolU oa d → c.tol m oa d)
    (warnObsU : Obs → Prop)
    (warn_lifts : ∀ m o, warnObsU o → c.warnObs m o)
    (preCapIntU : Int → Nat)
    (preCapInt_le : ∀ m j, c.preCapInt m j ≤ preCapIntU j)
    (preCapExtU : Ext → Nat)
    (preCapExt_le : ∀ m k, c.preCapExt m k ≤ preCapExtU k)
    (postAllowanceIntU : Int → Nat)
    (postAllowanceInt_le : ∀ m j, c.postAllowanceInt m j ≤ postAllowanceIntU j)
    (postAllowanceExtU : Ext → Nat)
    (postAllowanceExt_le : ∀ m k, c.postAllowanceExt m k ≤ postAllowanceExtU k)
    (maxSilenceU : Nat)
    (maxSilence_le : ∀ m, c.maxSilence m ≤ maxSilenceU)
    (maxLagU : Nat)
    (maxLag_le : ∀ m, c.maxLag m ≤ maxLagU) :
    OpenComposition.InterfaceContract (polyUniformToOpenComponent C) init where
  tol := tolU
  warnObs := warnObsU
  preCapInt := preCapIntU
  preCapExt := preCapExtU
  postBudgetInt := postAllowanceIntU
  postBudgetExt := postAllowanceExtU
  maxSilence := maxSilenceU
  maxLag := maxLagU
  K := c.K
  eta := c.eta
  init_in := c.init_in
  cert := Viability.certificate_disturbed_iff.mpr
    ⟨fun p hp =>
       let w := c.cert.within p hp
       ⟨fun j => Nat.le_trans (w.1 j) (preCapInt_le p.1 j),
        fun k => Nat.le_trans (w.2.1 k) (preCapExt_le p.1 k),
        Nat.le_trans w.2.2.1 (maxSilence_le p.1),
        fun h0 =>
          let post := w.2.2.2 h0
          ⟨post.1,
           fun j => Nat.le_trans (post.2.1 j) (postAllowanceInt_le p.1 j),
           fun k => Nat.le_trans (post.2.2 k) (postAllowanceExt_le p.1 k)⟩⟩,
     fun p m adm hp =>
       c.cert.closed p ⟨p.1, m.1, m.2⟩ _ ⟨rfl, tol_lifts p.1 m.1 m.2 adm, rfl⟩ hp⟩
  eta_bound p hp := Nat.le_trans (c.eta_bound p hp) (maxLag_le p.1)
  emits_on_warn p o hp hw := c.emits_on_warn p.1 p.2 o hp (warn_lifts p.1 o hw)
  eta_alarm_step p obs dist adm hK hpos :=
    c.eta_alarm_step p.1 p.2 obs dist (tol_lifts p.1 (obs, true) dist adm) hK hpos
  eta_alarm_zero p obs dist adm hK h0 :=
    c.eta_alarm_zero p.1 p.2 obs dist (tol_lifts p.1 (obs, true) dist adm) hK h0

/-- Genuinely coupled sum-site substrate law combining exposed `G_ext` and hidden `G_hide`. -/
def wholeGSum {Site ExtHide : Type}
    (G_ext : Site → (Site → Nat) → Nat)
    (G_hide : ExtHide → (ExtHide → Nat) → Nat) :
    Sum Site ExtHide → (Sum Site ExtHide → Nat) → Nat
  | .inl s, e => G_ext s (fun k => e (.inl k))
  | .inr h, e => G_hide h (fun k => e (.inr k))

/-- `wholeGSum` preserves coupled monotonicity whenever both `G_ext` and `G_hide` rise. -/
theorem wholeGSum_rises {Site ExtHide : Type}
    {G_ext : Site → (Site → Nat) → Nat}
    {G_hide : ExtHide → (ExtHide → Nat) → Nat}
    (hExt : ∀ k, RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (G_ext k))
    (hHide : ∀ k, RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (G_hide k)) :
    ∀ k, RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (wholeGSum G_ext G_hide k)
  | .inl s, _, _, hle => hExt s _ _ (fun k => hle (.inl k))
  | .inr h, _, _, hle => hHide h _ _ (fun k => hle (.inr k))

/-- Shared warning router forwarding the same warning flag to both blanket halves `(flag, flag)`. -/
def wholeWireObs {S₁ S₂ ObsOuter ExtHide : Type}
    (flagOf : ObsOuter → (ExtHide → Nat) → Bool)
    (map₁ : Bool → S₁)
    (map₂ : Bool → S₂)
    (o : ObsOuter) (xh : ExtHide → Nat) : S₁ × S₂ :=
  let flag := flagOf o xh
  (map₁ flag, map₂ flag)

/-- Horizontal blanket composition of two `BlanketContractSpec` parts on `Sum Site ExtHide`. -/
def wholeInnerBlk {I₁ S₁ A₁ Dist₁ I₂ S₂ A₂ Dist₂ Site ExtHide : Type}
    (sp₁ : ActiveInquiryLoop.BlanketContractSpec I₁ S₁ A₁ (Sum Site ExtHide) Dist₁)
    (sp₂ : ActiveInquiryLoop.BlanketContractSpec I₂ S₂ A₂ (Sum Site ExtHide) Dist₂) :
    OpenComposition.OpenComponent ((I₁ × A₁) × (I₂ × A₂)) (S₁ × S₂) (Dist₁ × Dist₂)
      (Sum Empty Empty) (Sum Site ExtHide) :=
  OpenComposition.OpenComponent.compose
    (ActiveInquiryLoop.componentOfBlanket sp₁)
    (ActiveInquiryLoop.componentOfBlanket sp₂)

/-- Contract for `wholeInnerBlk` composed via `OpenComposition.composeContract`. -/
def wholeInnerBlkContract {I₁ S₁ A₁ Dist₁ I₂ S₂ A₂ Dist₂ Site ExtHide : Type}
    (sp₁ : ActiveInquiryLoop.BlanketContractSpec I₁ S₁ A₁ (Sum Site ExtHide) Dist₁)
    (sp₂ : ActiveInquiryLoop.BlanketContractSpec I₂ S₂ A₂ (Sum Site ExtHide) Dist₂) :
    OpenComposition.InterfaceContract (wholeInnerBlk sp₁ sp₂)
      ((sp₁.initI, sp₁.initA), (sp₂.initI, sp₂.initA)) :=
  OpenComposition.composeContract
    (ActiveInquiryLoop.contractOfBlanket sp₁)
    (ActiveInquiryLoop.contractOfBlanket sp₂)

/-- Hidden-sealed left blanket sub-component exposing only `Site` while hiding `ExtHide`. -/
def wholeSealedLeft {I₁ S₁ A₁ Dist₁ I₂ S₂ A₂ Dist₂ ObsOuter Site ExtHide : Type}
    (sp₁ : ActiveInquiryLoop.BlanketContractSpec I₁ S₁ A₁ (Sum Site ExtHide) Dist₁)
    (sp₂ : ActiveInquiryLoop.BlanketContractSpec I₂ S₂ A₂ (Sum Site ExtHide) Dist₂)
    (G_hide : ExtHide → (ExtHide → Nat) → Nat)
    (wireObs : ObsOuter → (ExtHide → Nat) → (S₁ × S₂)) :
    OpenComposition.OpenComponent (((I₁ × A₁) × (I₂ × A₂)) × (ExtHide → Nat))
      ObsOuter (Dist₁ × Dist₂) (Sum (Sum Empty Empty) ExtHide) Site :=
  OpenComposition.OpenComponent.hide (wholeInnerBlk sp₁ sp₂) G_hide wireObs

/-- Contract for `wholeSealedLeft` via `OpenComposition.hideContract`. -/
def wholeSealedLeftContract {I₁ S₁ A₁ Dist₁ I₂ S₂ A₂ Dist₂ ObsOuter Site ExtHide : Type}
    (sp₁ : ActiveInquiryLoop.BlanketContractSpec I₁ S₁ A₁ (Sum Site ExtHide) Dist₁)
    (sp₂ : ActiveInquiryLoop.BlanketContractSpec I₂ S₂ A₂ (Sum Site ExtHide) Dist₂)
    (G_hide : ExtHide → (ExtHide → Nat) → Nat)
    (wireObs : ObsOuter → (ExtHide → Nat) → (S₁ × S₂))
    (tolOuter : ObsOuter × Bool → Dist₁ × Dist₂ → Prop)
    (warnOuter : ObsOuter → Prop)
    (x_crit_hide warnHide H_safe_hide x₀_hide : ExtHide → Nat)
    (tol_lifts : ∀ o xh al b d,
      tolOuter (o, al) d → (wholeInnerBlkContract sp₁ sp₂).tol (wireObs o xh, b) d)
    (G_hide_rises : ∀ k, RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (G_hide k))
    (wire_outer_warn : ∀ o xh,
      warnOuter o → (wholeInnerBlkContract sp₁ sp₂).warnObs (wireObs o xh))
    (wire_hide_warn : ∀ o xh,
      (∃ k, xh k < warnHide k) → (wholeInnerBlkContract sp₁ sp₂).warnObs (wireObs o xh))
    (hide_post_viable : ∀ k, x_crit_hide k ≤
      RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole G_hide H_safe_hide x_crit_hide k)
    (hide_post_allowance : ∀ k,
      (wholeInnerBlkContract sp₁ sp₂).postBudgetExt (Sum.inr k) ≤ H_safe_hide k)
    (hide_warn_margin : ∀ k,
      x_crit_hide k + ((wholeInnerBlkContract sp₁ sp₂).maxLag + 1) *
        (wholeInnerBlkContract sp₁ sp₂).preCapExt (Sum.inr k) ≤ warnHide k)
    (hide_init_margin : ∀ k,
      x_crit_hide k + (wholeInnerBlkContract sp₁ sp₂).eta
          ((sp₁.initI, sp₁.initA), (sp₂.initI, sp₂.initA)) *
        (wholeInnerBlkContract sp₁ sp₂).preCapExt (Sum.inr k) ≤ x₀_hide k) :
    OpenComposition.InterfaceContract (wholeSealedLeft sp₁ sp₂ G_hide wireObs)
      (((sp₁.initI, sp₁.initA), (sp₂.initI, sp₂.initA)), x₀_hide) :=
  OpenComposition.hideContract (wholeInnerBlkContract sp₁ sp₂) G_hide wireObs
    tolOuter warnOuter x_crit_hide warnHide H_safe_hide x₀_hide
    tol_lifts G_hide_rises wire_outer_warn wire_hide_warn
    hide_post_viable hide_post_allowance hide_warn_margin hide_init_margin

/-- Uniform-carrier anchored self-modifying right-hand open component. -/
def wholeScopeOpen {ModeR S_r Obs_r Dist_r Int_r Site : Type}
    (base : PolyComposition.AnchoredBase ModeR (fun _ => S_r) (fun _ => Obs_r) (fun _ => Dist_r)
      (fun _ => Int_r) (fun _ => Site))
    (admitDec : (p cand : Σ _ : ModeR, S_r) → Bool → Bool)
    (fallback : (p : Σ _ : ModeR, S_r) → Obs_r × Bool → Dist_r → Σ _ : ModeR, S_r)
    (propose : (p : Σ _ : ModeR, S_r) → Obs_r × Bool → Dist_r → Σ _ : ModeR, S_r) :
    OpenComposition.OpenComponent (Σ _ : ModeR, S_r) Obs_r Dist_r Int_r Site :=
  polyUniformToOpenComponent (PolyComposition.anchoredSelfModComponent base admitDec fallback propose)

/-- Open contract for `wholeScopeOpen` via `polyUniformToOpenContract`. -/
def wholeScopeOpenContract {ModeR S_r Obs_r Dist_r Int_r Site : Type}
    (base : PolyComposition.AnchoredBase ModeR (fun _ => S_r) (fun _ => Obs_r) (fun _ => Dist_r)
      (fun _ => Int_r) (fun _ => Site))
    {initR : Σ _ : ModeR, S_r}
    (hInit : PolyComposition.AnchoredInit base initR)
    (admitDec : (p cand : Σ _ : ModeR, S_r) → Bool → Bool)
    (fallback : (p : Σ _ : ModeR, S_r) → Obs_r × Bool → Dist_r → Σ _ : ModeR, S_r)
    (hAdmit : PolyComposition.AnchoredModeAdmit base admitDec fallback)
    (propose : (p : Σ _ : ModeR, S_r) → Obs_r × Bool → Dist_r → Σ _ : ModeR, S_r)
    (tolR : Obs_r × Bool → Dist_r → Prop)
    (tolR_lifts : ∀ m oa d, tolR oa d → base.tol m oa d)
    (warnR : Obs_r → Prop)
    (warnR_lifts : ∀ m o, warnR o → base.warnObs m o)
    (preCapIntR : Int_r → Nat) (preCapIntR_le : ∀ m j, base.preCapInt m j ≤ preCapIntR j)
    (preCapExtR : Site → Nat) (preCapExtR_le : ∀ m k, base.preCapExt m k ≤ preCapExtR k)
    (postAllowanceIntR : Int_r → Nat)
    (postAllowanceIntR_le : ∀ m j, base.postAllowanceInt m j ≤ postAllowanceIntR j)
    (postAllowanceExtR : Site → Nat)
    (postAllowanceExtR_le : ∀ m k, base.postAllowanceExt m k ≤ postAllowanceExtR k)
    (maxSilenceR : Nat) (maxSilenceR_le : ∀ m, base.maxSilence m ≤ maxSilenceR)
    (maxLagR : Nat) (maxLagR_le : ∀ m, base.maxLag m ≤ maxLagR) :
    OpenComposition.InterfaceContract (wholeScopeOpen base admitDec fallback propose) initR :=
  polyUniformToOpenContract
    (PolyComposition.anchoredSelfModContract base hInit admitDec fallback hAdmit propose)
    tolR tolR_lifts warnR warnR_lifts
    preCapIntR preCapIntR_le preCapExtR preCapExtR_le
    postAllowanceIntR postAllowanceIntR_le postAllowanceExtR postAllowanceExtR_le
    maxSilenceR maxSilenceR_le maxLagR maxLagR_le

/-- Concrete `ScopeMode` specialization of `wholeScopeOpen` (`Site := Unit`). -/
def scopeOpenComponent (preDraw coopDraw maxLagN : Nat) (coop_le_pre : coopDraw ≤ preDraw)
    (propose : (p : Σ m, EndogenousOrder.ScopeS m) →
      EndogenousOrder.ScopeObs p.1 × Bool → EndogenousOrder.ScopeDist p.1 →
      Σ m', EndogenousOrder.ScopeS m') :
    OpenComposition.OpenComponent (Σ _ : EndogenousOrder.ScopeMode, Nat) Bool Unit Empty Unit :=
  wholeScopeOpen (EndogenousOrder.scopeBase preDraw coopDraw maxLagN coop_le_pre)
    (EndogenousOrder.scopeAdmitDec maxLagN) EndogenousOrder.scopeFallback propose

/-- Concrete `ScopeMode` open contract with verified uniform envelopes. -/
def scopeOpenContract (preDraw coopDraw maxLagN initLag : Nat)
    (coop_le_pre : coopDraw ≤ preDraw) (init_in : 0 < initLag ∧ initLag ≤ maxLagN)
    (propose : (p : Σ m, EndogenousOrder.ScopeS m) →
      EndogenousOrder.ScopeObs p.1 × Bool → EndogenousOrder.ScopeDist p.1 →
      Σ m', EndogenousOrder.ScopeS m') :
    OpenComposition.InterfaceContract (scopeOpenComponent preDraw coopDraw maxLagN coop_le_pre propose)
      ⟨.narrowUnmonitored, initLag⟩ :=
  wholeScopeOpenContract (EndogenousOrder.scopeBase preDraw coopDraw maxLagN coop_le_pre)
    (⟨init_in⟩ : PolyComposition.AnchoredInit
      (EndogenousOrder.scopeBase preDraw coopDraw maxLagN coop_le_pre)
      ⟨.narrowUnmonitored, initLag⟩)
    (EndogenousOrder.scopeAdmitDec maxLagN) EndogenousOrder.scopeFallback
    (EndogenousOrder.scopeAdmit_sound preDraw coopDraw maxLagN coop_le_pre) propose
    (fun _ _ => True) (fun _ _ _ _ => trivial)
    (fun obs => obs = true) (fun _ _ hw => hw)
    Empty.elim (fun _ e => Empty.elim e)
    (fun _ => preDraw) (fun m _ => match m with | .narrowUnmonitored => Nat.le_refl _ | .wideReciprocal => coop_le_pre)
    Empty.elim (fun _ e => Empty.elim e)
    (fun _ => coopDraw) (fun _ _ => Nat.le_refl _)
    0 (fun _ => Nat.le_refl _)
    maxLagN (fun m => match m with | .narrowUnmonitored => Nat.le_refl _ | .wideReciprocal => Nat.zero_le _)

/-- Composed operational open component: hidden-sealed blanket pair composed with anchored
self-modifying right component over shared `Site`. -/
def wholeOp {I₁ S₁ A₁ Dist₁ I₂ S₂ A₂ Dist₂ ObsOuter Site ExtHide ModeR S_r Obs_r Dist_r Int_r : Type}
    (sp₁ : ActiveInquiryLoop.BlanketContractSpec I₁ S₁ A₁ (Sum Site ExtHide) Dist₁)
    (sp₂ : ActiveInquiryLoop.BlanketContractSpec I₂ S₂ A₂ (Sum Site ExtHide) Dist₂)
    (G_hide : ExtHide → (ExtHide → Nat) → Nat)
    (wireObs : ObsOuter → (ExtHide → Nat) → (S₁ × S₂))
    (base : PolyComposition.AnchoredBase ModeR (fun _ => S_r) (fun _ => Obs_r) (fun _ => Dist_r)
      (fun _ => Int_r) (fun _ => Site))
    (admitDec : (p cand : Σ _ : ModeR, S_r) → Bool → Bool)
    (fallback : (p : Σ _ : ModeR, S_r) → Obs_r × Bool → Dist_r → Σ _ : ModeR, S_r)
    (propose : (p : Σ _ : ModeR, S_r) → Obs_r × Bool → Dist_r → Σ _ : ModeR, S_r) :=
  OpenComposition.OpenComponent.compose
    (wholeSealedLeft sp₁ sp₂ G_hide wireObs)
    (wholeScopeOpen base admitDec fallback propose)

/-- Composed operational `InterfaceContract` on `wholeOp` via `OpenComposition.composeContract`. -/
def wholeOpContract
    {I₁ S₁ A₁ Dist₁ I₂ S₂ A₂ Dist₂ ObsOuter Site ExtHide ModeR S_r Obs_r Dist_r Int_r : Type}
    {sp₁ : ActiveInquiryLoop.BlanketContractSpec I₁ S₁ A₁ (Sum Site ExtHide) Dist₁}
    {sp₂ : ActiveInquiryLoop.BlanketContractSpec I₂ S₂ A₂ (Sum Site ExtHide) Dist₂}
    {G_hide : ExtHide → (ExtHide → Nat) → Nat}
    {wireObs : ObsOuter → (ExtHide → Nat) → (S₁ × S₂)}
    {base : PolyComposition.AnchoredBase ModeR (fun _ => S_r) (fun _ => Obs_r) (fun _ => Dist_r)
      (fun _ => Int_r) (fun _ => Site)}
    {initR : Σ _ : ModeR, S_r}
    {admitDec : (p cand : Σ _ : ModeR, S_r) → Bool → Bool}
    {fallback : (p : Σ _ : ModeR, S_r) → Obs_r × Bool → Dist_r → Σ _ : ModeR, S_r}
    {propose : (p : Σ _ : ModeR, S_r) → Obs_r × Bool → Dist_r → Σ _ : ModeR, S_r}
    {x₀_hide : ExtHide → Nat}
    (cLeft : OpenComposition.InterfaceContract (wholeSealedLeft sp₁ sp₂ G_hide wireObs)
      (((sp₁.initI, sp₁.initA), (sp₂.initI, sp₂.initA)), x₀_hide))
    (cRight : OpenComposition.InterfaceContract (wholeScopeOpen base admitDec fallback propose) initR) :
    OpenComposition.InterfaceContract (wholeOp sp₁ sp₂ G_hide wireObs base admitDec fallback propose)
      ((((sp₁.initI, sp₁.initA), (sp₂.initI, sp₂.initA)), x₀_hide), initR) :=
  OpenComposition.composeContract cLeft cRight

/-- `ScopeMode`-instantiated `wholeOp` (`Site := Unit`). -/
def wholeScopeOp {I₁ S₁ A₁ Dist₁ I₂ S₂ A₂ Dist₂ ObsOuter ExtHide : Type}
    (sp₁ : ActiveInquiryLoop.BlanketContractSpec I₁ S₁ A₁ (Sum Unit ExtHide) Dist₁)
    (sp₂ : ActiveInquiryLoop.BlanketContractSpec I₂ S₂ A₂ (Sum Unit ExtHide) Dist₂)
    (G_hide : ExtHide → (ExtHide → Nat) → Nat)
    (wireObs : ObsOuter → (ExtHide → Nat) → (S₁ × S₂))
    (preDraw coopDraw maxLagN : Nat) (coop_le_pre : coopDraw ≤ preDraw)
    (propose : (p : Σ m, EndogenousOrder.ScopeS m) →
      EndogenousOrder.ScopeObs p.1 × Bool → EndogenousOrder.ScopeDist p.1 →
      Σ m', EndogenousOrder.ScopeS m') :=
  wholeOp sp₁ sp₂ G_hide wireObs
    (EndogenousOrder.scopeBase preDraw coopDraw maxLagN coop_le_pre)
    (EndogenousOrder.scopeAdmitDec maxLagN) EndogenousOrder.scopeFallback propose

/-- Active inquiry specification wrapping an operational `(opComp, opInit, opContract)`. -/
def wholeInquirySpec {Θ Probe Outcome S_op Obs_op Dist_op Int_op Site : Type}
    (horizon : Nat)
    (plan : Nat → Probe)
    (probeDraw : Site → Nat)
    (probeStepDraw : Nat → List (Probe × Outcome) → Site → Nat)
    (probeDraw_le : ∀ t hist site, probeStepDraw t hist site ≤ probeDraw site)
    (infer : List (Probe × Outcome) → Θ)
    (opComp : OpenComposition.OpenComponent S_op Obs_op Dist_op Int_op Site)
    (opInit : S_op)
    (opContract : OpenComposition.InterfaceContract opComp opInit) :
    ActiveInquiryLoop.ActiveInquirySpec Θ Probe Outcome S_op Obs_op Dist_op Int_op Site where
  horizon := horizon
  plan := plan
  probeDraw := probeDraw
  probeStepDraw := probeStepDraw
  probeDraw_le := probeDraw_le
  infer := infer
  opComp _ := opComp
  opInit _ := opInit
  opContract _ := opContract
  opMaxLag := opContract.maxLag
  opLag_le _ := Nat.le_refl _

/-- Pattern-matched predicate certifying `.probe t` without `InquiryMode.injEq`. -/
def IsProbeAt {Θ Probe Outcome S_op : Type} (t : Nat) :
    (Σ m : ActiveInquiryLoop.InquiryMode Θ Unit,
      ActiveInquiryLoop.inquiryS Probe Outcome S_op Θ m) → Prop
  | ⟨.probe t', _⟩ => t' = t
  | ⟨.operate _ _, _⟩ => False

/-- Pattern-matched predicate certifying `.operate` without `InquiryMode.injEq`. -/
def IsOpState {Θ Probe Outcome S_op : Type} :
    (Σ m : ActiveInquiryLoop.InquiryMode Θ Unit,
      ActiveInquiryLoop.inquiryS Probe Outcome S_op Θ m) → Prop
  | ⟨.probe _, _⟩ => False
  | ⟨.operate _ _, _⟩ => True

/-- Pattern-matched predicate certifying `.operate θ ()` without `InquiryMode.injEq`. -/
def IsOpTheta {Θ Probe Outcome S_op : Type} (θ : Θ) :
    (Σ m : ActiveInquiryLoop.InquiryMode Θ Unit,
      ActiveInquiryLoop.inquiryS Probe Outcome S_op Θ m) → Prop
  | ⟨.probe _, _⟩ => False
  | ⟨.operate hat _, _⟩ => hat = θ

/-- Pattern-matched predicate certifying that operational state equals `spec.opInit hat`. -/
def IsOpWithInit {Θ Probe Outcome S_op Obs_op Dist_op Int_op Site : Type}
    (spec : ActiveInquiryLoop.ActiveInquirySpec Θ Probe Outcome S_op Obs_op Dist_op Int_op Site) :
    (Σ m : ActiveInquiryLoop.InquiryMode Θ Unit,
      ActiveInquiryLoop.inquiryS Probe Outcome S_op Θ m) → Prop
  | ⟨.probe _, _⟩ => False
  | ⟨.operate hat _, opS⟩ => opS = spec.opInit hat

/-- Extract operational state component using pattern matching (`cases hm` avoids `.injEq`). -/
def extractOpState {Θ Probe Outcome S_op : Type} (fallback : S_op) :
    (Σ m : ActiveInquiryLoop.InquiryMode Θ Unit,
      ActiveInquiryLoop.inquiryS Probe Outcome S_op Θ m) → S_op
  | ⟨.probe _, _⟩ => fallback
  | ⟨.operate _ _, opS⟩ => opS

/-- Extract operational disturbance component using pattern matching. -/
def extractOpDist {Θ Dist_op : Type} (fallback : Dist_op) :
    (Σ m : ActiveInquiryLoop.InquiryMode Θ Unit,
      ActiveInquiryLoop.inquiryDist Dist_op Θ m) → Dist_op
  | ⟨.probe _, _⟩ => fallback
  | ⟨.operate _ _, d⟩ => d

/-- Constructive single-step inquiry phase lemma (`cases hm` first, ZERO `propext` / Streicher K). -/
theorem inquiry_step_phase
    {Θ Probe Outcome S_op Obs_op Dist_op Int_op Site Env : Type}
    {W : ActiveInquiryLoop.RegimeWorld Θ Probe Outcome Obs_op Site Env}
    {spec : ActiveInquiryLoop.ActiveInquirySpec Θ Probe Outcome S_op Obs_op Dist_op Int_op Site}
    {θ : Θ} {channel : Bool → Nat → Env → Bool}
    {st st' : (Site → Nat) × Σ m : ActiveInquiryLoop.InquiryMode Θ Unit,
      ActiveInquiryLoop.inquiryS Probe Outcome S_op Θ m}
    {act : Env × Σ m : ActiveInquiryLoop.InquiryMode Θ Unit,
      ActiveInquiryLoop.inquiryDist Dist_op Θ m}
    (hstep : (PolyComposition.polyClosedProcess
      (ActiveInquiryLoop.inquiryPolyComponent spec) (fun _ site => [site])
      (ActiveInquiryLoop.inquiryContract spec)
      (ActiveInquiryLoop.inquiryWorldObs W spec θ) channel (W.G θ) (W.envDraw θ) W.jointAdm).step
      st act st') :
    (∀ n, IsProbeAt n st.2 → n < spec.horizon →
      (n + 1 < spec.horizon → IsProbeAt (n + 1) st'.2) ∧
      (¬ (n + 1 < spec.horizon) → IsOpState st'.2 ∧ IsOpWithInit spec st'.2)) ∧
    (IsOpState st.2 → IsOpState st'.2) := by
  obtain ⟨x, ⟨sm, ss⟩⟩ := st
  obtain ⟨env, ⟨am, ad⟩⟩ := act
  rcases hstep with ⟨hm, _, _, heq⟩
  cases hm
  cases sm with
  | probe t =>
    refine ⟨fun n ht hlt => ?_, fun h => False.elim h⟩
    dsimp only [IsProbeAt] at ht
    cases ht
    subst heq
    dsimp only [PolyComposition.polyClosedStep, ActiveInquiryLoop.inquiryPolyComponent]
    cases hNext : Nat.decLt (t + 1) spec.horizon with
    | isTrue hLt =>
      rw [if_pos hLt]
      exact ⟨fun _ => rfl, fun hNot => absurd hLt hNot⟩
    | isFalse hGe =>
      rw [if_neg hGe]
      exact ⟨fun hLt => absurd hLt hGe, fun _ => ⟨trivial, rfl⟩⟩
  | operate hat op =>
    cases op
    refine ⟨fun _ h => False.elim h, fun _ => ?_⟩
    subst heq
    exact trivial

/-- Inductive phase characterization along any `Run` starting from `inquiryInit spec`. -/
theorem inquiry_phase_inv
    {Θ Probe Outcome S_op Obs_op Dist_op Int_op Site Env : Type}
    (W : ActiveInquiryLoop.RegimeWorld Θ Probe Outcome Obs_op Site Env)
    (spec : ActiveInquiryLoop.ActiveInquirySpec Θ Probe Outcome S_op Obs_op Dist_op Int_op Site)
    (θ : Θ) (channel : Bool → Nat → Env → Bool) (x₀ : Site → Nat)
    (r_inq : Run (PolyComposition.polyClosedProcess
      (ActiveInquiryLoop.inquiryPolyComponent spec) (fun _ site => [site])
      (ActiveInquiryLoop.inquiryContract spec)
      (ActiveInquiryLoop.inquiryWorldObs W spec θ) channel (W.G θ) (W.envDraw θ) W.jointAdm))
    (hStart : r_inq.state 0 = (x₀, ActiveInquiryLoop.inquiryInit spec)) :
    ∀ n,
      (n < spec.horizon → IsProbeAt n (r_inq.state n).2) ∧
      (spec.horizon ≤ n → IsOpState (r_inq.state n).2) ∧
      (n = spec.horizon → IsOpWithInit spec (r_inq.state n).2) := by
  intro n
  induction n with
  | zero =>
    have h0 : (r_inq.state 0).2 = ActiveInquiryLoop.inquiryInit spec := congrArg Prod.snd hStart
    rw [h0]
    dsimp only [ActiveInquiryLoop.inquiryInit]
    cases hHor : spec.horizon with
    | zero =>
      exact ⟨fun hlt => absurd hlt (Nat.not_lt_zero 0),
        fun _ => trivial,
        fun _ => rfl⟩
    | succ h =>
      exact ⟨fun _ => rfl,
        fun hle => absurd hle (Nat.not_le_of_gt (Nat.zero_lt_succ h)),
        fun heq => absurd heq.symm (Naturals.succ_ne_zero h)⟩
  | succ n ih =>
    have hStep := inquiry_step_phase (r_inq.step n)
    refine ⟨fun hlt => ?_, fun hle => ?_, fun heq => ?_⟩
    · have hlt_n : n < spec.horizon := Nat.lt_of_succ_lt hlt
      exact (hStep.1 n (ih.1 hlt_n) hlt_n).1 hlt
    · cases Nat.lt_or_ge n spec.horizon with
      | inl hlt_n =>
        exact ((hStep.1 n (ih.1 hlt_n) hlt_n).2 (Nat.not_lt_of_ge hle)).1
      | inr hge_n =>
        exact hStep.2 (ih.2.1 hge_n)
    · have hlt_n : n < spec.horizon := by rw [← heq]; exact Nat.lt_succ_self n
      have hge : spec.horizon ≤ n + 1 := Nat.le_of_eq heq.symm
      exact ((hStep.1 n (ih.1 hlt_n) hlt_n).2 (Nat.not_lt_of_ge hge)).2

/-- Helper proving `ExploreMarginInv` holds at `t = 0` on `(x₀, inquiryInit spec)`. -/
theorem exploreMarginInv_init
    {Θ Probe Outcome S_op Obs_op Dist_op Int_op Site Env : Type}
    (W : ActiveInquiryLoop.RegimeWorld Θ Probe Outcome Obs_op Site Env)
    (spec : ActiveInquiryLoop.ActiveInquirySpec Θ Probe Outcome S_op Obs_op Dist_op Int_op Site)
    (θ : Θ) (x_crit x₀ : Site → Nat)
    (probe_identifies : ∀ xs : Nat → Site → Nat,
      (∀ t, t < spec.horizon → ∀ site, x_crit site ≤ xs t site) →
      spec.infer (ActiveInquiryLoop.probeTranscript W spec.plan θ xs spec.horizon) = θ)
    (init_margin : ∀ site,
      x_crit site + spec.horizon * (spec.probeDraw site + W.envCap site) +
        ((spec.opContract θ).maxLag + 1) *
          ((spec.opContract θ).preCapExt site + W.envCap site) ≤ x₀ site) :
    ActiveInquiryLoop.ExploreMarginInv W spec θ x_crit (x₀, ActiveInquiryLoop.inquiryInit spec) := by
  dsimp only [ActiveInquiryLoop.ExploreMarginInv, ActiveInquiryLoop.inquiryInit]
  cases hHor : spec.horizon with
  | zero =>
    have hId : spec.infer [] = θ := by
      have htr := probe_identifies (fun _ => x₀) (fun t ht => by rw [hHor] at ht; exact absurd ht (Nat.not_lt_zero t))
      rw [hHor] at htr
      exact htr
    rw [hId]
    refine ⟨rfl, (spec.opContract θ).init_in, fun site => ?_⟩
    have hMarg := init_margin site
    rw [hHor, Nat.zero_mul, Nat.add_zero] at hMarg
    have hEta := (spec.opContract θ).eta_bound (spec.opInit θ) (spec.opContract θ).init_in
    exact Nat.le_trans
      (Nat.add_le_add_left (Nat.mul_le_mul_right _ (Nat.le_trans hEta (Nat.le_succ _))) _)
      hMarg
  | succ h =>
    refine ⟨Nat.zero_lt_succ h, ⟨fun _ => x₀, fun _ hs => absurd hs (Nat.not_lt_zero _), rfl⟩,
      fun site => ?_⟩
    have hMarg := init_margin site
    rw [hHor] at hMarg
    rw [Nat.sub_zero]
    exact hMarg

/-- Along any run certified by `Viability.Certificate ... ExploreMarginInv`, every state satisfies
`ExploreMarginInv`. -/
theorem exploreMarginInv_along_run
    {Θ Probe Outcome S_op Obs_op Dist_op Int_op Site Env : Type}
    {W : ActiveInquiryLoop.RegimeWorld Θ Probe Outcome Obs_op Site Env}
    {spec : ActiveInquiryLoop.ActiveInquirySpec Θ Probe Outcome S_op Obs_op Dist_op Int_op Site}
    {θ : Θ} {channel : Bool → Nat → Env → Bool} {x_crit x₀ : Site → Nat}
    (hCert : Viability.Certificate
      (PolyComposition.polyClosedProcess
        (ActiveInquiryLoop.inquiryPolyComponent spec) (fun _ site => [site])
        (ActiveInquiryLoop.inquiryContract spec)
        (ActiveInquiryLoop.inquiryWorldObs W spec θ) channel (W.G θ) (W.envDraw θ) W.jointAdm)
      (PolyComposition.polyClosedGuard (ActiveInquiryLoop.inquiryPolyComponent spec)
        (ActiveInquiryLoop.inquiryContract spec) x_crit)
      (ActiveInquiryLoop.ExploreMarginInv W spec θ x_crit))
    (r_inq : Run (PolyComposition.polyClosedProcess
      (ActiveInquiryLoop.inquiryPolyComponent spec) (fun _ site => [site])
      (ActiveInquiryLoop.inquiryContract spec)
      (ActiveInquiryLoop.inquiryWorldObs W spec θ) channel (W.G θ) (W.envDraw θ) W.jointAdm))
    (hStart : r_inq.state 0 = (x₀, ActiveInquiryLoop.inquiryInit spec))
    (hInitInv : ActiveInquiryLoop.ExploreMarginInv W spec θ x_crit (x₀, ActiveInquiryLoop.inquiryInit spec)) :
    ∀ t, ActiveInquiryLoop.ExploreMarginInv W spec θ x_crit (r_inq.state t)
  | 0 => hStart.symm ▸ hInitInv
  | t + 1 => hCert.closed (r_inq.state t) (r_inq.act t) (r_inq.state (t + 1)) (r_inq.step t)
      (exploreMarginInv_along_run hCert r_inq hStart hInitInv t)

/-- Combine `inquiry_phase_inv` with `ExploreMarginInv` to prove `IsOpTheta θ` for all
post-horizon steps `spec.horizon + k`. -/
theorem postProbe_isOpTheta
    {Θ Probe Outcome S_op Obs_op Dist_op Int_op Site Env : Type}
    (W : ActiveInquiryLoop.RegimeWorld Θ Probe Outcome Obs_op Site Env)
    (spec : ActiveInquiryLoop.ActiveInquirySpec Θ Probe Outcome S_op Obs_op Dist_op Int_op Site)
    (θ : Θ) (channel : Bool → Nat → Env → Bool) (x_crit : Site → Nat)
    (r_inq : Run (PolyComposition.polyClosedProcess
      (ActiveInquiryLoop.inquiryPolyComponent spec) (fun _ site => [site])
      (ActiveInquiryLoop.inquiryContract spec)
      (ActiveInquiryLoop.inquiryWorldObs W spec θ) channel (W.G θ) (W.envDraw θ) W.jointAdm))
    (hPhase : ∀ k, IsOpState (r_inq.state (spec.horizon + k)).2)
    (hInvAll : ∀ t, ActiveInquiryLoop.ExploreMarginInv W spec θ x_crit (r_inq.state t)) :
    ∀ k, IsOpTheta θ (r_inq.state (spec.horizon + k)).2 := by
  intro k
  have hOp := hPhase k
  have hInv := hInvAll (spec.horizon + k)
  cases hp : (r_inq.state (spec.horizon + k)).2 with
  | mk sm ss =>
    cases sm with
    | probe _ =>
      rw [hp] at hOp
      exact False.elim hOp
    | operate hat op =>
      dsimp only [ActiveInquiryLoop.ExploreMarginInv] at hInv
      rw [hp] at hInv
      exact hInv.1

/-- Constructive operational step projection: destructs `st` and `act`, runs `cases hm` FIRST,
then `cases sm` / `cases op` / `cases hOp`, introducing ZERO `.injEq` / `propext` / Streicher K. -/
theorem postProbe_step_lemma
    {Θ Probe Outcome S_op Obs_op Dist_op Int_op Site Env : Type}
    (W : ActiveInquiryLoop.RegimeWorld Θ Probe Outcome Obs_op Site Env)
    (spec : ActiveInquiryLoop.ActiveInquirySpec Θ Probe Outcome S_op Obs_op Dist_op Int_op Site)
    (θ : Θ) (channel : Bool → Nat → Env → Bool)
    (fallbackS : S_op) (fallbackD : Dist_op)
    (st st' : (Site → Nat) × Σ m : ActiveInquiryLoop.InquiryMode Θ Unit,
      ActiveInquiryLoop.inquiryS Probe Outcome S_op Θ m)
    (act : Env × Σ m : ActiveInquiryLoop.InquiryMode Θ Unit,
      ActiveInquiryLoop.inquiryDist Dist_op Θ m)
    (hstep : (PolyComposition.polyClosedProcess
      (ActiveInquiryLoop.inquiryPolyComponent spec) (fun _ site => [site])
      (ActiveInquiryLoop.inquiryContract spec)
      (ActiveInquiryLoop.inquiryWorldObs W spec θ) channel (W.G θ) (W.envDraw θ) W.jointAdm).step
      st act st')
    (hOp : IsOpTheta θ st.2) :
    (OpenComposition.closedProcess (spec.opComp θ) (spec.opContract θ)
      (W.opObs θ) channel (W.G θ) (W.envDraw θ) W.jointAdm).step
      (st.1, extractOpState fallbackS st.2)
      (act.1, extractOpDist fallbackD act.2)
      (st'.1, extractOpState fallbackS st'.2) := by
  obtain ⟨x, ⟨sm, ss⟩⟩ := st
  obtain ⟨env, ⟨am, ad⟩⟩ := act
  rcases hstep with ⟨hm, envOk, tolOk, heq⟩
  cases hm
  cases sm with
  | probe _ => exact False.elim hOp
  | operate hat op =>
    cases op
    change hat = θ at hOp
    cases hOp
    subst heq
    refine ⟨⟨envOk, fun ob => tolOk ob⟩, rfl⟩
    -- Notice `closedProcess` step uses `⟨jointAdm env, ∀ ob, tol ob d⟩` and `st' = closedStep ...`!

/-- Constructive post-probe `Run` extraction onto `OpenComposition.closedProcess`. -/
def postProbeRun
    {Θ Probe Outcome S_op Obs_op Dist_op Int_op Site Env : Type}
    (W : ActiveInquiryLoop.RegimeWorld Θ Probe Outcome Obs_op Site Env)
    (spec : ActiveInquiryLoop.ActiveInquirySpec Θ Probe Outcome S_op Obs_op Dist_op Int_op Site)
    (θ : Θ) (channel : Bool → Nat → Env → Bool)
    (fallbackS : S_op) (fallbackD : Dist_op)
    (r_inq : Run (PolyComposition.polyClosedProcess
      (ActiveInquiryLoop.inquiryPolyComponent spec) (fun _ site => [site])
      (ActiveInquiryLoop.inquiryContract spec)
      (ActiveInquiryLoop.inquiryWorldObs W spec θ) channel (W.G θ) (W.envDraw θ) W.jointAdm))
    (hOpAll : ∀ k, IsOpTheta θ (r_inq.state (spec.horizon + k)).2) :
    Run (OpenComposition.closedProcess (spec.opComp θ) (spec.opContract θ)
      (W.opObs θ) channel (W.G θ) (W.envDraw θ) W.jointAdm) where
  state k :=
    ((r_inq.state (spec.horizon + k)).1, extractOpState fallbackS (r_inq.state (spec.horizon + k)).2)
  act k :=
    ((r_inq.act (spec.horizon + k)).1, extractOpDist fallbackD (r_inq.act (spec.horizon + k)).2)
  step k := postProbe_step_lemma W spec θ channel fallbackS fallbackD
    (r_inq.state (spec.horizon + k)) (r_inq.state (spec.horizon + k + 1))
    (r_inq.act (spec.horizon + k)) (r_inq.step (spec.horizon + k)) (hOpAll k)

/-- Post-probe extraction starts in `spec.opInit θ`, preserves `opContract.K`, and preserves
`OpenComposition.closedGuard` + `init_margin` at `k = 0`. -/
theorem postProbeRun_opInvariants
    {Θ Probe Outcome S_op Obs_op Dist_op Int_op Site Env : Type}
    (W : ActiveInquiryLoop.RegimeWorld Θ Probe Outcome Obs_op Site Env)
    (spec : ActiveInquiryLoop.ActiveInquirySpec Θ Probe Outcome S_op Obs_op Dist_op Int_op Site)
    (θ : Θ) (channel : Bool → Nat → Env → Bool)
    (fallbackS : S_op) (fallbackD : Dist_op) (x_crit : Site → Nat)
    (r_inq : Run (PolyComposition.polyClosedProcess
      (ActiveInquiryLoop.inquiryPolyComponent spec) (fun _ site => [site])
      (ActiveInquiryLoop.inquiryContract spec)
      (ActiveInquiryLoop.inquiryWorldObs W spec θ) channel (W.G θ) (W.envDraw θ) W.jointAdm))
    (hPhase : ∀ n,
      (n < spec.horizon → IsProbeAt n (r_inq.state n).2) ∧
      (spec.horizon ≤ n → IsOpState (r_inq.state n).2) ∧
      (n = spec.horizon → IsOpWithInit spec (r_inq.state n).2))
    (hInvAll : ∀ t, ActiveInquiryLoop.ExploreMarginInv W spec θ x_crit (r_inq.state t))
    (hOpAll : ∀ k, IsOpTheta θ (r_inq.state (spec.horizon + k)).2) :
    let rOp := postProbeRun W spec θ channel fallbackS fallbackD r_inq hOpAll
    (rOp.state 0).2 = spec.opInit θ ∧
    (∀ k, (spec.opContract θ).K (rOp.state k).2) ∧
    (∀ k, OpenComposition.closedGuard (spec.opComp θ) (spec.opContract θ) x_crit (rOp.state k)) ∧
    (∀ site, x_crit site + (spec.opContract θ).eta (spec.opInit θ) *
      ((spec.opContract θ).preCapExt site + W.envCap site) ≤ (rOp.state 0).1 site) := by
  intro rOp
  have extractInv : ∀ k,
      (spec.opContract θ).K (extractOpState fallbackS (r_inq.state (spec.horizon + k)).2) ∧
      ∀ site, x_crit site + (spec.opContract θ).eta (extractOpState fallbackS (r_inq.state (spec.horizon + k)).2) *
        ((spec.opContract θ).preCapExt site + W.envCap site) ≤ (r_inq.state (spec.horizon + k)).1 site := by
    intro k
    have hInv := hInvAll (spec.horizon + k)
    have hOp := hOpAll k
    cases hp : (r_inq.state (spec.horizon + k)).2 with
    | mk sm ss =>
      cases sm with
      | probe _ =>
        rw [hp] at hOp
        exact False.elim hOp
      | operate hat op =>
        cases op
        dsimp only [ActiveInquiryLoop.ExploreMarginInv] at hInv
        rw [hp] at hInv
        obtain ⟨hHat, hK, hMarg⟩ := hInv
        subst hHat
        exact ⟨hK, hMarg⟩
  have h0Init : (rOp.state 0).2 = spec.opInit θ := by
    have hWI := (hPhase (spec.horizon + 0)).2.2 (Nat.add_zero spec.horizon)
    have hTh := hOpAll 0
    show extractOpState fallbackS (r_inq.state (spec.horizon + 0)).2 = spec.opInit θ
    cases hp : (r_inq.state (spec.horizon + 0)).2 with
    | mk sm ss =>
      cases sm with
      | probe _ =>
        rw [hp] at hTh
        exact False.elim hTh
      | operate hat op =>
        cases op
        rw [hp] at hTh hWI
        dsimp only [IsOpTheta] at hTh
        dsimp only [IsOpWithInit] at hWI
        rw [hTh] at hWI
        exact hWI
  refine ⟨h0Init, fun k => (extractInv k).1, fun k => ?_, fun site => ?_⟩
  · have hK := (extractInv k).1
    have hMarg := (extractInv k).2
    refine ⟨fun site => Nat.le_trans (Nat.le_add_right _ _) (hMarg site),
      (spec.opContract θ).cert.within (rOp.state k).2 hK⟩
  · have hMarg0 := (extractInv 0).2 site
    dsimp only [rOp, postProbeRun] at h0Init
    change x_crit site +
        (spec.opContract θ).eta (extractOpState fallbackS (r_inq.state (spec.horizon + 0)).2) *
          ((spec.opContract θ).preCapExt site + W.envCap site) ≤
      (r_inq.state (spec.horizon + 0)).1 site at hMarg0
    rw [h0Init] at hMarg0
    exact hMarg0

/-! ## Section 2: Unified `WholeArchitecture : Type` & Coupled Theorems -/

/-- Full unified becoming architecture (`Type 0`, all carrier types before `:`).
Combines active inquiry, hidden-sealed blanket composition, uniform-carrier anchored self-modification,
coupled small-gain macro stability, non-constant `CausalGoAlike` projection, `EvolutionaryDrawdown`
multi-site exchange conservation, persisting lineages (`lineages_raises`), `OrderUpdater` ranking over
collapsing overdraw (`adaptive_order_joins_coupledEnding`), and grounded `CourseRealization` Nash
obstruction & reciprocal-gate restoration. -/
structure WholeArchitecture
    (Θ Probe Outcome Env : Type)
    (I₁ S₁ A₁ Dist₁ I₂ S₂ A₂ Dist₂ ObsL Site ExtHide : Type)
    (ModeR S_r Obs_r Dist_r Int_r : Type)
    (QX BX QA BA QB BB : Type)
    (QCausal : Type)
    (X_evo X_bad Pos_ord Act F_cr C_cr : Type) : Type where
  W : ActiveInquiryLoop.RegimeWorld Θ Probe Outcome (ObsL × Obs_r) Site Env
  θ_true : Θ
  sp₁ : ActiveInquiryLoop.BlanketContractSpec I₁ S₁ A₁ (Sum Site ExtHide) Dist₁
  sp₂ : ActiveInquiryLoop.BlanketContractSpec I₂ S₂ A₂ (Sum Site ExtHide) Dist₂
  G_hide : ExtHide → (ExtHide → Nat) → Nat
  G_hide_rises : ∀ k, RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (G_hide k)
  flagOf : ObsL → (ExtHide → Nat) → Bool
  map₁ : Bool → S₁
  map₂ : Bool → S₂
  wireObs : ObsL → (ExtHide → Nat) → (S₁ × S₂)
  wireObs_coupled : ∀ o xh, wireObs o xh = wholeWireObs flagOf map₁ map₂ o xh
  tolL : ObsL × Bool → Dist₁ × Dist₂ → Prop
  warnL : ObsL → Prop
  x_crit_hide : ExtHide → Nat
  warnHide : ExtHide → Nat
  H_safe_hide : ExtHide → Nat
  x₀_hide : ExtHide → Nat
  tolL_lifts : ∀ o xh al b d,
    tolL (o, al) d → (wholeInnerBlkContract sp₁ sp₂).tol (wireObs o xh, b) d
  wire_outer_warn : ∀ o xh,
    warnL o → (wholeInnerBlkContract sp₁ sp₂).warnObs (wireObs o xh)
  wire_hide_warn : ∀ o xh,
    (∃ k, xh k < warnHide k) → (wholeInnerBlkContract sp₁ sp₂).warnObs (wireObs o xh)
  hide_post_viable : ∀ k, x_crit_hide k ≤
    RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole G_hide H_safe_hide x_crit_hide k
  hide_post_allowance : ∀ k,
    (wholeInnerBlkContract sp₁ sp₂).postBudgetExt (Sum.inr k) ≤ H_safe_hide k
  hide_warn_margin : ∀ k,
    x_crit_hide k + ((wholeInnerBlkContract sp₁ sp₂).maxLag + 1) *
      (wholeInnerBlkContract sp₁ sp₂).preCapExt (Sum.inr k) ≤ warnHide k
  hide_init_margin : ∀ k,
    x_crit_hide k + (wholeInnerBlkContract sp₁ sp₂).eta
        ((sp₁.initI, sp₁.initA), (sp₂.initI, sp₂.initA)) *
      (wholeInnerBlkContract sp₁ sp₂).preCapExt (Sum.inr k) ≤ x₀_hide k
  baseR : PolyComposition.AnchoredBase ModeR (fun _ => S_r) (fun _ => Obs_r) (fun _ => Dist_r)
    (fun _ => Int_r) (fun _ => Site)
  initR : Σ _ : ModeR, S_r
  hInitR : PolyComposition.AnchoredInit baseR initR
  admitDecR : (p cand : Σ _ : ModeR, S_r) → Bool → Bool
  fallbackR : (p : Σ _ : ModeR, S_r) → Obs_r × Bool → Dist_r → Σ _ : ModeR, S_r
  hAdmitR : PolyComposition.AnchoredModeAdmit baseR admitDecR fallbackR
  proposeR : (p : Σ _ : ModeR, S_r) → Obs_r × Bool → Dist_r → Σ _ : ModeR, S_r
  tolR : Obs_r × Bool → Dist_r → Prop
  tolR_lifts : ∀ m oa d, tolR oa d → baseR.tol m oa d
  warnR : Obs_r → Prop
  warnR_lifts : ∀ m o, warnR o → baseR.warnObs m o
  preCapIntR : Int_r → Nat
  preCapIntR_le : ∀ m j, baseR.preCapInt m j ≤ preCapIntR j
  preCapExtR : Site → Nat
  preCapExtR_le : ∀ m k, baseR.preCapExt m k ≤ preCapExtR k
  postAllowanceIntR : Int_r → Nat
  postAllowanceIntR_le : ∀ m j, baseR.postAllowanceInt m j ≤ postAllowanceIntR j
  postAllowanceExtR : Site → Nat
  postAllowanceExtR_le : ∀ m k, baseR.postAllowanceExt m k ≤ postAllowanceExtR k
  maxSilenceR : Nat
  maxSilenceR_le : ∀ m, baseR.maxSilence m ≤ maxSilenceR
  maxLagR : Nat
  maxLagR_le : ∀ m, baseR.maxLag m ≤ maxLagR
  obsL : (Site → Nat) → ObsL
  obsR : (Site → Nat) → Obs_r
  opObs_eq : ∀ x, W.opObs θ_true x = (obsL x, obsR x)
  channel : Bool → Nat → Env → Bool
  channel_fires : ∀ load env, W.jointAdm env →
    load ≤ (wholeOpContract
      (wholeSealedLeftContract sp₁ sp₂ G_hide wireObs tolL warnL
        x_crit_hide warnHide H_safe_hide x₀_hide tolL_lifts G_hide_rises
        wire_outer_warn wire_hide_warn hide_post_viable hide_post_allowance
        hide_warn_margin hide_init_margin)
      (wholeScopeOpenContract baseR hInitR admitDecR fallbackR hAdmitR proposeR
        tolR tolR_lifts warnR warnR_lifts preCapIntR preCapIntR_le preCapExtR preCapExtR_le
        postAllowanceIntR postAllowanceIntR_le postAllowanceExtR postAllowanceExtR_le
        maxSilenceR maxSilenceR_le maxLagR maxLagR_le)).maxSilence →
    channel true load env = true
  horizon : Nat
  plan : Nat → Probe
  probeDraw : Site → Nat
  probeStepDraw : Nat → List (Probe × Outcome) → Site → Nat
  probeDraw_le : ∀ t hist site, probeStepDraw t hist site ≤ probeDraw site
  infer : List (Probe × Outcome) → Θ
  x_crit : Site → Nat
  warnLevel : Site → Nat
  H_safe : Site → Nat
  x₀ : Site → Nat
  probe_identifies : ∀ xs : Nat → Site → Nat,
    (∀ t, t < horizon → ∀ site, x_crit site ≤ xs t site) →
    infer (ActiveInquiryLoop.probeTranscript W plan θ_true xs horizon) = θ_true
  obs_detects : ∀ x site, x site < warnLevel site → warnL (obsL x) ∨ warnR (obsR x)
  post_viable : ∀ site, x_crit site ≤
    RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole (W.G θ_true) H_safe x_crit site
  post_allowance : ∀ site,
    ((wholeSealedLeftContract sp₁ sp₂ G_hide wireObs tolL warnL
        x_crit_hide warnHide H_safe_hide x₀_hide tolL_lifts G_hide_rises
        wire_outer_warn wire_hide_warn hide_post_viable hide_post_allowance
        hide_warn_margin hide_init_margin).postBudgetExt site +
      (wholeScopeOpenContract baseR hInitR admitDecR fallbackR hAdmitR proposeR
        tolR tolR_lifts warnR warnR_lifts preCapIntR preCapIntR_le preCapExtR preCapExtR_le
        postAllowanceIntR postAllowanceIntR_le postAllowanceExtR postAllowanceExtR_le
        maxSilenceR maxSilenceR_le maxLagR maxLagR_le).postBudgetExt site) +
      W.envCap site ≤ H_safe site
  warn_margin : ∀ site,
    x_crit site +
      (CoreHelpers.natMax
        (wholeSealedLeftContract sp₁ sp₂ G_hide wireObs tolL warnL
          x_crit_hide warnHide H_safe_hide x₀_hide tolL_lifts G_hide_rises
          wire_outer_warn wire_hide_warn hide_post_viable hide_post_allowance
          hide_warn_margin hide_init_margin).maxLag
        (wholeScopeOpenContract baseR hInitR admitDecR fallbackR hAdmitR proposeR
          tolR tolR_lifts warnR warnR_lifts preCapIntR preCapIntR_le preCapExtR preCapExtR_le
          postAllowanceIntR postAllowanceIntR_le postAllowanceExtR postAllowanceExtR_le
          maxSilenceR maxSilenceR_le maxLagR maxLagR_le).maxLag + 1) *
        (((wholeSealedLeftContract sp₁ sp₂ G_hide wireObs tolL warnL
            x_crit_hide warnHide H_safe_hide x₀_hide tolL_lifts G_hide_rises
            wire_outer_warn wire_hide_warn hide_post_viable hide_post_allowance
            hide_warn_margin hide_init_margin).preCapExt site +
          (wholeScopeOpenContract baseR hInitR admitDecR fallbackR hAdmitR proposeR
            tolR tolR_lifts warnR warnR_lifts preCapIntR preCapIntR_le preCapExtR preCapExtR_le
            postAllowanceIntR postAllowanceIntR_le postAllowanceExtR postAllowanceExtR_le
            maxSilenceR maxSilenceR_le maxLagR maxLagR_le).preCapExt site) +
          W.envCap site) ≤ warnLevel site
  init_margin : ∀ site,
    x_crit site + horizon * (probeDraw site + W.envCap site) +
      (CoreHelpers.natMax
        (wholeSealedLeftContract sp₁ sp₂ G_hide wireObs tolL warnL
          x_crit_hide warnHide H_safe_hide x₀_hide tolL_lifts G_hide_rises
          wire_outer_warn wire_hide_warn hide_post_viable hide_post_allowance
          hide_warn_margin hide_init_margin).maxLag
        (wholeScopeOpenContract baseR hInitR admitDecR fallbackR hAdmitR proposeR
          tolR tolR_lifts warnR warnR_lifts preCapIntR preCapIntR_le preCapExtR preCapExtR_le
          postAllowanceIntR postAllowanceIntR_le postAllowanceExtR postAllowanceExtR_le
          maxSilenceR maxSilenceR_le maxLagR maxLagR_le).maxLag + 1) *
        (((wholeSealedLeftContract sp₁ sp₂ G_hide wireObs tolL warnL
            x_crit_hide warnHide H_safe_hide x₀_hide tolL_lifts G_hide_rises
            wire_outer_warn wire_hide_warn hide_post_viable hide_post_allowance
            hide_warn_margin hide_init_margin).preCapExt site +
          (wholeScopeOpenContract baseR hInitR admitDecR fallbackR hAdmitR proposeR
            tolR tolR_lifts warnR warnR_lifts preCapIntR preCapIntR_le preCapExtR preCapExtR_le
            postAllowanceIntR postAllowanceIntR_le postAllowanceExtR postAllowanceExtR_le
            maxSilenceR maxSilenceR_le maxLagR maxLagR_le).preCapExt site) +
          W.envCap site) ≤ x₀ site
  cap_within : ∀ site,
    ((wholeSealedLeftContract sp₁ sp₂ G_hide wireObs tolL warnL
        x_crit_hide warnHide H_safe_hide x₀_hide tolL_lifts G_hide_rises
        wire_outer_warn wire_hide_warn hide_post_viable hide_post_allowance
        hide_warn_margin hide_init_margin).preCapExt site +
      (wholeScopeOpenContract baseR hInitR admitDecR fallbackR hAdmitR proposeR
        tolR tolR_lifts warnR warnR_lifts preCapIntR preCapIntR_le preCapExtR preCapExtR_le
        postAllowanceIntR postAllowanceIntR_le postAllowanceExtR postAllowanceExtR_le
        maxSilenceR maxSilenceR_le maxLagR maxLagR_le).preCapExt site) +
      W.envCap site ≤ x_crit site
  k₀ : Site
  fallbackDistOp : (Dist₁ × Dist₂) × Dist_r
  r_full : Run (PolyComposition.polyClosedProcess
    (ActiveInquiryLoop.inquiryPolyComponent
      (wholeInquirySpec horizon plan probeDraw probeStepDraw probeDraw_le infer
        (wholeOp sp₁ sp₂ G_hide wireObs baseR admitDecR fallbackR proposeR)
        ((((sp₁.initI, sp₁.initA), (sp₂.initI, sp₂.initA)), x₀_hide), initR)
        (wholeOpContract
          (wholeSealedLeftContract sp₁ sp₂ G_hide wireObs tolL warnL
            x_crit_hide warnHide H_safe_hide x₀_hide tolL_lifts G_hide_rises
            wire_outer_warn wire_hide_warn hide_post_viable hide_post_allowance
            hide_warn_margin hide_init_margin)
          (wholeScopeOpenContract baseR hInitR admitDecR fallbackR hAdmitR proposeR
            tolR tolR_lifts warnR warnR_lifts preCapIntR preCapIntR_le preCapExtR preCapExtR_le
            postAllowanceIntR postAllowanceIntR_le postAllowanceExtR postAllowanceExtR_le
            maxSilenceR maxSilenceR_le maxLagR maxLagR_le))))
    (fun _ site => [site])
    (ActiveInquiryLoop.inquiryContract
      (wholeInquirySpec horizon plan probeDraw probeStepDraw probeDraw_le infer
        (wholeOp sp₁ sp₂ G_hide wireObs baseR admitDecR fallbackR proposeR)
        ((((sp₁.initI, sp₁.initA), (sp₂.initI, sp₂.initA)), x₀_hide), initR)
        (wholeOpContract
          (wholeSealedLeftContract sp₁ sp₂ G_hide wireObs tolL warnL
            x_crit_hide warnHide H_safe_hide x₀_hide tolL_lifts G_hide_rises
            wire_outer_warn wire_hide_warn hide_post_viable hide_post_allowance
            hide_warn_margin hide_init_margin)
          (wholeScopeOpenContract baseR hInitR admitDecR fallbackR hAdmitR proposeR
            tolR tolR_lifts warnR warnR_lifts preCapIntR preCapIntR_le preCapExtR preCapExtR_le
            postAllowanceIntR postAllowanceIntR_le postAllowanceExtR postAllowanceExtR_le
            maxSilenceR maxSilenceR_le maxLagR maxLagR_le))))
    (ActiveInquiryLoop.inquiryWorldObs W
      (wholeInquirySpec horizon plan probeDraw probeStepDraw probeDraw_le infer
        (wholeOp sp₁ sp₂ G_hide wireObs baseR admitDecR fallbackR proposeR)
        ((((sp₁.initI, sp₁.initA), (sp₂.initI, sp₂.initA)), x₀_hide), initR)
        (wholeOpContract
          (wholeSealedLeftContract sp₁ sp₂ G_hide wireObs tolL warnL
            x_crit_hide warnHide H_safe_hide x₀_hide tolL_lifts G_hide_rises
            wire_outer_warn wire_hide_warn hide_post_viable hide_post_allowance
            hide_warn_margin hide_init_margin)
          (wholeScopeOpenContract baseR hInitR admitDecR fallbackR hAdmitR proposeR
            tolR tolR_lifts warnR warnR_lifts preCapIntR preCapIntR_le preCapExtR preCapExtR_le
            postAllowanceIntR postAllowanceIntR_le postAllowanceExtR postAllowanceExtR_le
            maxSilenceR maxSilenceR_le maxLagR maxLagR_le))) θ_true)
    channel (W.G θ_true) (W.envDraw θ_true) W.jointAdm)
  r_full_start : r_full.state 0 = (x₀, ActiveInquiryLoop.inquiryInit
    (wholeInquirySpec horizon plan probeDraw probeStepDraw probeDraw_le infer
      (wholeOp sp₁ sp₂ G_hide wireObs baseR admitDecR fallbackR proposeR)
      ((((sp₁.initI, sp₁.initA), (sp₂.initI, sp₂.initA)), x₀_hide), initR)
      (wholeOpContract
        (wholeSealedLeftContract sp₁ sp₂ G_hide wireObs tolL warnL
          x_crit_hide warnHide H_safe_hide x₀_hide tolL_lifts G_hide_rises
          wire_outer_warn wire_hide_warn hide_post_viable hide_post_allowance
          hide_warn_margin hide_init_margin)
        (wholeScopeOpenContract baseR hInitR admitDecR fallbackR hAdmitR proposeR
          tolR tolR_lifts warnR warnR_lifts preCapIntR preCapIntR_le preCapExtR preCapExtR_le
          postAllowanceIntR postAllowanceIntR_le postAllowanceExtR postAllowanceExtR_le
          maxSilenceR maxSilenceR_le maxLagR maxLagR_le))))
  drawExt_pos : ∀ k_step,
    0 < (wholeOp sp₁ sp₂ G_hide wireObs baseR admitDecR fallbackR proposeR).drawExt
      (extractOpState
        ((((sp₁.initI, sp₁.initA), (sp₂.initI, sp₂.initA)), x₀_hide), initR)
        (r_full.state (horizon + k_step)).2) k₀
  -- Small-gain macro coupling on (wholeSealedLeft, wholeScopeOpen)
  RX : Process QX ((Site → Nat) × BX)
  πX : (Site → Nat) → QX
  σ : Nat → Nat
  strict_σ : Strict σ
  Mstride : Nat
  stride_le : ∀ k, σ (k + 1) - σ k ≤ Mstride
  MX : SlackDist QX
  RA : Process QA (QX × BA)
  πA : (((I₁ × A₁) × (I₂ × A₂)) × (ExtHide → Nat)) → QA
  drawQA : QA → Site → Nat
  MA : SlackDist QA
  RB : Process QB (QX × BB)
  πB : (Σ _ : ModeR, S_r) → QB
  drawQB : QB → Site → Nat
  MB : SlackDist QB
  simX : PolyComposition.SubstrateLaxSim (W.G θ_true) (W.envDraw θ_true) W.jointAdm RX πX σ MX
  simA : PolyComposition.OpenSubLaxSim (wholeSealedLeft sp₁ sp₂ G_hide wireObs)
    tolL obsL RA πA drawQA σ MA MX πX simX.EpochX simX.EpochQX
  simB : PolyComposition.OpenSubLaxSim (wholeScopeOpen baseR admitDecR fallbackR proposeR)
    tolR obsR RB πB drawQB σ MB MX πX simX.EpochX simX.EpochQX
  guardQ : QX × (QA × QB) → Prop
  KQ : QX × (QA × QB) → Prop
  certQ : Viability.Certificate (PolyComposition.coupledMacroProcess RX RA RB drawQA drawQB) guardQ KQ
  Δ : Nat
  absorb :
    (PolyComposition.coupled_closed_laxSim strict_σ Mstride stride_le
      (wholeSealedLeftContract sp₁ sp₂ G_hide wireObs tolL warnL
        x_crit_hide warnHide H_safe_hide x₀_hide tolL_lifts G_hide_rises
        wire_outer_warn wire_hide_warn hide_post_viable hide_post_allowance
        hide_warn_margin hide_init_margin) obsL
      (wholeScopeOpenContract baseR hInitR admitDecR fallbackR hAdmitR proposeR
        tolR tolR_lifts warnR warnR_lifts preCapIntR preCapIntR_le preCapExtR preCapExtR_le
        postAllowanceIntR postAllowanceIntR_le postAllowanceExtR postAllowanceExtR_le
        maxSilenceR maxSilenceR_le maxLagR maxLagR_le) obsR
      channel simX simA simB).α Δ +
    (PolyComposition.coupled_closed_laxSim strict_σ Mstride stride_le
      (wholeSealedLeftContract sp₁ sp₂ G_hide wireObs tolL warnL
        x_crit_hide warnHide H_safe_hide x₀_hide tolL_lifts G_hide_rises
        wire_outer_warn wire_hide_warn hide_post_viable hide_post_allowance
        hide_warn_margin hide_init_margin) obsL
      (wholeScopeOpenContract baseR hInitR admitDecR fallbackR hAdmitR proposeR
        tolR tolR_lifts warnR warnR_lifts preCapIntR preCapIntR_le preCapExtR preCapExtR_le
        postAllowanceIntR postAllowanceIntR_le postAllowanceExtR postAllowanceExtR_le
        maxSilenceR maxSilenceR_le maxLagR maxLagR_le) obsR
      channel simX simA simB).ε ≤ Δ
  marginQ : ∀ (q : QX × (QA × QB))
    (u : (Site → Nat) × ((((I₁ × A₁) × (I₂ × A₂)) × (ExtHide → Nat)) × (Σ _ : ModeR, S_r))),
    guardQ q →
    (OpenComposition.SlackDist.max MX (OpenComposition.SlackDist.max MA MB)).d
      (πX u.1, (πA u.2.1, πB u.2.2)) q ≤
    (PolyComposition.coupled_closed_laxSim strict_σ Mstride stride_le
      (wholeSealedLeftContract sp₁ sp₂ G_hide wireObs tolL warnL
        x_crit_hide warnHide H_safe_hide x₀_hide tolL_lifts G_hide_rises
        wire_outer_warn wire_hide_warn hide_post_viable hide_post_allowance
        hide_warn_margin hide_init_margin) obsL
      (wholeScopeOpenContract baseR hInitR admitDecR fallbackR hAdmitR proposeR
        tolR tolR_lifts warnR warnR_lifts preCapIntR preCapIntR_le preCapExtR preCapExtR_le
        postAllowanceIntR postAllowanceIntR_le postAllowanceExtR postAllowanceExtR_le
        maxSilenceR maxSilenceR_le maxLagR maxLagR_le) obsR
      channel simX simA simB).β Δ +
    (PolyComposition.coupled_closed_laxSim strict_σ Mstride stride_le
      (wholeSealedLeftContract sp₁ sp₂ G_hide wireObs tolL warnL
        x_crit_hide warnHide H_safe_hide x₀_hide tolL_lifts G_hide_rises
        wire_outer_warn wire_hide_warn hide_post_viable hide_post_allowance
        hide_warn_margin hide_init_margin) obsL
      (wholeScopeOpenContract baseR hInitR admitDecR fallbackR hAdmitR proposeR
        tolR tolR_lifts warnR warnR_lifts preCapIntR preCapIntR_le preCapExtR preCapExtR_le
        postAllowanceIntR postAllowanceIntR_le postAllowanceExtR postAllowanceExtR_le
        maxSilenceR maxSilenceR_le maxLagR maxLagR_le) obsR
      channel simX simA simB).η →
    ∀ k, x_crit k ≤ u.1 k
  epX₀ : simX.EpochX (σ 0) x₀
  epA₀ : simA.Epoch (σ 0) (((sp₁.initI, sp₁.initA), (sp₂.initI, sp₂.initA)), x₀_hide)
  epB₀ : simB.Epoch (σ 0) initR
  initQ : KQ (πX x₀, (πA (((sp₁.initI, sp₁.initA), (sp₂.initI, sp₂.initA)), x₀_hide), πB initR))
  -- Non-constant CausalGoAlike abstraction on CausalSystem.ofOpenComponent wholeOp
  π_causal :
    ((((I₁ × A₁) × (I₂ × A₂)) × (ExtHide → Nat)) × (Σ _ : ModeR, S_r)) → QCausal
  ω_causal :
    (Option (ObsL × Obs_r) × Option Bool) → (Option (ObsL × Obs_r) × Option Bool)
  causal_goAlike :
    CausalGoAlike
      (CausalSystem.ofOpenComponent
        (wholeOp sp₁ sp₂ G_hide wireObs baseR admitDecR fallbackR proposeR)
        (wholeOpContract
          (wholeSealedLeftContract sp₁ sp₂ G_hide wireObs tolL warnL
            x_crit_hide warnHide H_safe_hide x₀_hide tolL_lifts G_hide_rises
            wire_outer_warn wire_hide_warn hide_post_viable hide_post_allowance
            hide_warn_margin hide_init_margin)
          (wholeScopeOpenContract baseR hInitR admitDecR fallbackR hAdmitR proposeR
            tolR tolR_lifts warnR warnR_lifts preCapIntR preCapIntR_le preCapExtR preCapExtR_le
            postAllowanceIntR postAllowanceIntR_le postAllowanceExtR postAllowanceExtR_le
            maxSilenceR maxSilenceR_le maxLagR maxLagR_le)).tol)
      π_causal ω_causal
  causal_nonconst : ∃ s₁ s₂, π_causal s₁ ≠ π_causal s₂
  -- Ecological persistence coupled to rOp substrate
  L_evo : Flow X_evo X_evo
  W_evo : Web X_evo X_evo
  G_evo : SelectionTerm.Generations X_evo
  evo_acting : L_evo.Acting W_evo
  evo_descended : SelectionTerm.Flow.Descended L_evo W_evo G_evo
  lgs_evo : List (List X_evo)
  listed_evo : SelectionLevels.whole lgs_evo = G_evo.family 0
  exact_evo : ∀ t, SelectionTerm.Exact (G_evo.family t) (G_evo.kids t) (G_evo.amount t) (G_evo.amount (t + 1))
  v_evo : List X_evo → Nat
  founded_evo : ∀ g, g ∈ lgs_evo → ∀ p, p ∈ g → G_evo.amount 0 p = v_evo g
  t_evo : Nat
  inactive_evo : ∀ g h, g ∈ lgs_evo → h ∈ lgs_evo → v_evo h < v_evo g →
    ∀ p, p ∈ SelectionLevels.lineage G_evo h t_evo → ¬ W_evo.active t_evo p
  g_evo : List X_evo
  h_evo : List X_evo
  mg_evo : g_evo ∈ lgs_evo
  mh_evo : h_evo ∈ lgs_evo
  less_evo : v_evo h_evo < v_evo g_evo
  p_evo : X_evo
  q_evo : X_evo
  mp_evo : p_evo ∈ SelectionLevels.lineage G_evo g_evo t_evo
  mq_evo : q_evo ∈ SelectionLevels.lineage G_evo h_evo t_evo
  c_sub : X_evo
  substrate_tracks : ∀ s, W_evo.level s c_sub = (r_full.state (horizon + s)).1 k₀
  reproduces_when_viable : x_crit k₀ ≤ W_evo.level t_evo c_sub → 0 < G_evo.offspringNumber t_evo p_evo
  -- Collapsing overdraw trace + adaptive OrderUpdater joining coupled_ending_ranked_below
  L_bad : Flow X_bad X_bad
  W_bad : Web X_bad X_bad
  G_bad : SelectionTerm.Generations X_bad
  bad_balances : L_bad.Balances W_bad
  bad_acting : L_bad.Acting W_bad
  bad_dependent : W_bad.Dependent
  bad_descended : SelectionTerm.Flow.Descended L_bad W_bad G_bad
  ds_ord : List X_bad
  m_ord : Nat
  gated_ord : ∀ s f, f ∈ L_bad.present s → ∀ d, d ∈ ds_ord → 0 < L_bad.give s f d →
    ∃ e, e ∈ ds_ord ∧ W_bad.requires s f e ∧ m_ord ≤ W_bad.need s f e
  T_end_ord : Nat
  n_ord : Nat
  excess_ord : ∀ k, k < n_ord → L_bad.replenishment ds_ord (T_end_ord + k) < L_bad.uptake ds_ord (T_end_ord + k)
  start_ord : W_bad.stock ds_ord T_end_ord < n_ord + m_ord
  bad_stock_noninc : ∀ t, W_bad.stock ds_ord (t + 1) ≤ W_bad.stock ds_ord t
  bad_stock_bounded : W_bad.stock ds_ord 0 < m_ord + n_ord + (W_bad.stock ds_ord 0 + 1)
  coupled_ord : ∀ k q, q ∈ G_bad.family (T_end_ord + n_ord + k) →
    ∃ e, e ∈ ds_ord ∧ W_bad.requires (T_end_ord + n_ord + k) q e ∧ m_ord ≤ W_bad.need (T_end_ord + n_ord + k) q e
  U_ord : EndogenousOrder.OrderUpdater (Nat × X_bad)
  feedback_ord : Nat → Nat × X_bad → Bool
  B_ord : Nat
  K_ord : Nat
  T_ord : Nat
  ownBase_ord : ∀ x, x ∈ U_ord.items → U_ord.own x = true → U_ord.base x ≤ B_ord
  offBase_ord : ∀ y, y ∈ U_ord.items → U_ord.own y = false → U_ord.base y ≤ U_ord.initPos y
  probed_ord : ∀ x, x ∈ U_ord.items → U_ord.own x = true → K_ord ≤ EndogenousOrder.hitCount feedback_ord T_ord x
  enough_ord : B_ord < K_ord * U_ord.stepGain
  a_ord : Nat × X_bad → Bool
  b_ord : Nat × X_bad → Bool
  reads_ord : ∀ x, x ∈ U_ord.items → b_ord x = true → x.2 ∈ G_bad.family x.1
  agree_ord : ∀ x, x ∈ U_ord.items → x.1 ≤ T_end_ord + n_ord → a_ord x = b_ord x
  own_ord : Pos_ord → Nat × X_bad → Bool
  p_ord : Pos_ord
  ownEq_ord : U_ord.own = own_ord p_ord
  adds_ord : Weighting.AddsOwn U_ord.items (own_ord p_ord) a_ord b_ord
  -- Grounded CourseRealization pair + reciprocal-gate Nash restoration tracking rOp
  CR_ungated : EndogenousOrder.CourseRealization Act F_cr C_cr
  CR_gated : EndogenousOrder.CourseRealization Act F_cr C_cr
  acts_cr : List Act
  narrow_cr : Act → Bool
  wide_cr : Act → Bool
  r₀ : Act
  d₀ : Act
  c_pool : C_cr
  act_track : Act
  cr_tracks_substrate : ∀ t, (CR_gated.web act_track r₀).level t c_pool = (r_full.state (horizon + t)).1 k₀
  rMem_cr : r₀ ∈ acts_cr
  dMem_cr : d₀ ∈ acts_cr
  apart_cr : d₀ ≠ r₀
  narrow_spec_cr : ∀ x, narrow_cr x = true ↔ x = r₀
  wide_spec_cr : ∀ x, wide_cr x = true ↔ x = r₀ ∨ x = d₀
  urr_adm₁ : ∀ t, t ≤ CR_ungated.horizon → (CR_ungated.web r₀ r₀).active t CR_ungated.form₁ ∧
    (CR_ungated.web r₀ r₀).Admits ((CR_ungated.web r₀ r₀).level t) t CR_ungated.form₁
  urr_adm₂ : ∀ t, t ≤ CR_ungated.horizon → (CR_ungated.web r₀ r₀).active t CR_ungated.form₂ ∧
    (CR_ungated.web r₀ r₀).Admits ((CR_ungated.web r₀ r₀).level t) t CR_ungated.form₂
  T_u1 : Nat
  T_u2 : Nat
  T_c : Nat
  T_rd : Nat
  T_dr : Nat
  tu1_le : T_u1 ≤ CR_ungated.horizon
  tu2_le : T_u2 ≤ CR_ungated.horizon
  tc_le : T_c ≤ CR_ungated.horizon
  udr_adm₁ : ∀ t, t ≤ T_u1 → (CR_ungated.web d₀ r₀).active t CR_ungated.form₁ ∧
    (CR_ungated.web d₀ r₀).Admits ((CR_ungated.web d₀ r₀).level t) t CR_ungated.form₁
  urd_adm₂ : ∀ t, t ≤ T_u2 → (CR_ungated.web r₀ d₀).active t CR_ungated.form₂ ∧
    (CR_ungated.web r₀ d₀).Admits ((CR_ungated.web r₀ d₀).level t) t CR_ungated.form₂
  tempt₁_cr : (CR_ungated.horizon + 1) * CR_ungated.stepYield₁ r₀ < (T_u1 + 1) * CR_ungated.stepYield₁ d₀
  tempt₂_cr : (CR_ungated.horizon + 1) * CR_ungated.stepYield₂ r₀ < (T_u2 + 1) * CR_ungated.stepYield₂ d₀
  udd_adm₁ : ∀ t, t ≤ T_c → (CR_ungated.web d₀ d₀).active t CR_ungated.form₁ ∧
    (CR_ungated.web d₀ d₀).Admits ((CR_ungated.web d₀ d₀).level t) t CR_ungated.form₁
  udd_cut₁ : ∀ t, T_c < t → ¬ ((CR_ungated.web d₀ d₀).active t CR_ungated.form₁ ∧
    (CR_ungated.web d₀ d₀).Admits ((CR_ungated.web d₀ d₀).level t) t CR_ungated.form₁)
  udd_adm₂ : ∀ t, t ≤ T_c → (CR_ungated.web d₀ d₀).active t CR_ungated.form₂ ∧
    (CR_ungated.web d₀ d₀).Admits ((CR_ungated.web d₀ d₀).level t) t CR_ungated.form₂
  udd_cut₂ : ∀ t, T_c < t → ¬ ((CR_ungated.web d₀ d₀).active t CR_ungated.form₂ ∧
    (CR_ungated.web d₀ d₀).Admits ((CR_ungated.web d₀ d₀).level t) t CR_ungated.form₂)
  urd_cut₁ : ∀ t, T_rd < t → ¬ ((CR_ungated.web r₀ d₀).active t CR_ungated.form₁ ∧
    (CR_ungated.web r₀ d₀).Admits ((CR_ungated.web r₀ d₀).level t) t CR_ungated.form₁)
  udr_cut₂ : ∀ t, T_dr < t → ¬ ((CR_ungated.web d₀ r₀).active t CR_ungated.form₂ ∧
    (CR_ungated.web d₀ r₀).Admits ((CR_ungated.web d₀ r₀).level t) t CR_ungated.form₂)
  overtaken₁_cr : (T_rd + 1) * CR_ungated.stepYield₁ r₀ < (T_c + 1) * CR_ungated.stepYield₁ d₀
  overtaken₂_cr : (T_dr + 1) * CR_ungated.stepYield₂ r₀ < (T_c + 1) * CR_ungated.stepYield₂ d₀
  drop₁_cr : (T_c + 1) * CR_ungated.stepYield₁ d₀ < (CR_ungated.horizon + 1) * CR_ungated.stepYield₁ r₀
  drop₂_cr : (T_c + 1) * CR_ungated.stepYield₂ d₀ < (CR_ungated.horizon + 1) * CR_ungated.stepYield₂ r₀
  grr_adm₁ : ∀ t, t ≤ CR_gated.horizon → (CR_gated.web r₀ r₀).active t CR_gated.form₁ ∧
    (CR_gated.web r₀ r₀).Admits ((CR_gated.web r₀ r₀).level t) t CR_gated.form₁
  grr_adm₂ : ∀ t, t ≤ CR_gated.horizon → (CR_gated.web r₀ r₀).active t CR_gated.form₂ ∧
    (CR_gated.web r₀ r₀).Admits ((CR_gated.web r₀ r₀).level t) t CR_gated.form₂
  grd_adm₁ : ∀ t, t ≤ CR_gated.horizon → (CR_gated.web r₀ d₀).active t CR_gated.form₁ ∧
    (CR_gated.web r₀ d₀).Admits ((CR_gated.web r₀ d₀).level t) t CR_gated.form₁
  gdr_adm₂ : ∀ t, t ≤ CR_gated.horizon → (CR_gated.web d₀ r₀).active t CR_gated.form₂ ∧
    (CR_gated.web d₀ r₀).Admits ((CR_gated.web d₀ r₀).level t) t CR_gated.form₂
  T_gate : Nat
  gdr_cut₁ : ∀ t, T_gate < t → ¬ ((CR_gated.web d₀ r₀).active t CR_gated.form₁ ∧
    (CR_gated.web d₀ r₀).Admits ((CR_gated.web d₀ r₀).level t) t CR_gated.form₁)
  grd_cut₂ : ∀ t, T_gate < t → ¬ ((CR_gated.web r₀ d₀).active t CR_gated.form₂ ∧
    (CR_gated.web r₀ d₀).Admits ((CR_gated.web r₀ d₀).level t) t CR_gated.form₂)
  gdd_cut₁ : ∀ t, T_gate < t → ¬ ((CR_gated.web d₀ d₀).active t CR_gated.form₁ ∧
    (CR_gated.web d₀ d₀).Admits ((CR_gated.web d₀ d₀).level t) t CR_gated.form₁)
  gdd_cut₂ : ∀ t, T_gate < t → ¬ ((CR_gated.web d₀ d₀).active t CR_gated.form₂ ∧
    (CR_gated.web d₀ d₀).Admits ((CR_gated.web d₀ d₀).level t) t CR_gated.form₂)
  restored₁_cr : (T_gate + 1) * CR_gated.stepYield₁ d₀ < (CR_gated.horizon + 1) * CR_gated.stepYield₁ r₀
  restored₂_cr : (T_gate + 1) * CR_gated.stepYield₂ d₀ < (CR_gated.horizon + 1) * CR_gated.stepYield₂ r₀

section ArchitectureProjections

variable
  {Θ Probe Outcome Env : Type}
  {I₁ S₁ A₁ Dist₁ I₂ S₂ A₂ Dist₂ ObsL Site ExtHide : Type}
  {ModeR S_r Obs_r Dist_r Int_r : Type}
  {QX BX QA BA QB BB : Type}
  {QCausal : Type}
  {X_evo X_bad Pos_ord Act F_cr C_cr : Type}
  (A : WholeArchitecture Θ Probe Outcome Env
    I₁ S₁ A₁ Dist₁ I₂ S₂ A₂ Dist₂ ObsL Site ExtHide
    ModeR S_r Obs_r Dist_r Int_r QX BX QA BA QB BB QCausal X_evo X_bad Pos_ord Act F_cr C_cr)

def WholeArchitecture.initLeft :=
  (((A.sp₁.initI, A.sp₁.initA), (A.sp₂.initI, A.sp₂.initA)), A.x₀_hide)

def WholeArchitecture.initOp :=
  (A.initLeft, A.initR)

def WholeArchitecture.leftComp :=
  wholeSealedLeft A.sp₁ A.sp₂ A.G_hide A.wireObs

def WholeArchitecture.cLeft :=
  wholeSealedLeftContract A.sp₁ A.sp₂ A.G_hide A.wireObs A.tolL A.warnL
    A.x_crit_hide A.warnHide A.H_safe_hide A.x₀_hide
    A.tolL_lifts A.G_hide_rises A.wire_outer_warn A.wire_hide_warn
    A.hide_post_viable A.hide_post_allowance A.hide_warn_margin A.hide_init_margin

def WholeArchitecture.rightComp :=
  wholeScopeOpen A.baseR A.admitDecR A.fallbackR A.proposeR

def WholeArchitecture.cRight :=
  wholeScopeOpenContract A.baseR A.hInitR A.admitDecR A.fallbackR A.hAdmitR A.proposeR
    A.tolR A.tolR_lifts A.warnR A.warnR_lifts
    A.preCapIntR A.preCapIntR_le A.preCapExtR A.preCapExtR_le
    A.postAllowanceIntR A.postAllowanceIntR_le A.postAllowanceExtR A.postAllowanceExtR_le
    A.maxSilenceR A.maxSilenceR_le A.maxLagR A.maxLagR_le

def WholeArchitecture.compOp :=
  wholeOp A.sp₁ A.sp₂ A.G_hide A.wireObs A.baseR A.admitDecR A.fallbackR A.proposeR

def WholeArchitecture.cOp :=
  wholeOpContract A.cLeft A.cRight

def WholeArchitecture.spec :=
  wholeInquirySpec A.horizon A.plan A.probeDraw A.probeStepDraw A.probeDraw_le A.infer
    A.compOp A.initOp A.cOp

def WholeArchitecture.inqCertAndKernel :=
  ActiveInquiryLoop.exploration_margin_sandwich_viable
    A.W A.spec A.θ_true A.channel A.x_crit A.warnLevel A.H_safe A.x₀
    A.probe_identifies
    (fun x site hlt => by rw [A.opObs_eq x]; exact A.obs_detects x site hlt)
    A.channel_fires A.post_viable A.post_allowance A.warn_margin A.init_margin

theorem WholeArchitecture.phaseInv :
    ∀ n,
      (n < A.horizon → IsProbeAt n (A.r_full.state n).2) ∧
      (A.horizon ≤ n → IsOpState (A.r_full.state n).2) ∧
      (n = A.horizon → IsOpWithInit A.spec (A.r_full.state n).2) :=
  inquiry_phase_inv A.W A.spec A.θ_true A.channel A.x₀ A.r_full A.r_full_start

theorem WholeArchitecture.invAll :
    ∀ t, ActiveInquiryLoop.ExploreMarginInv A.W A.spec A.θ_true A.x_crit (A.r_full.state t) :=
  exploreMarginInv_along_run A.inqCertAndKernel.1 A.r_full A.r_full_start
    (exploreMarginInv_init A.W A.spec A.θ_true A.x_crit A.x₀ A.probe_identifies A.init_margin)

theorem WholeArchitecture.postIsOpTheta :
    ∀ k, IsOpTheta A.θ_true (A.r_full.state (A.horizon + k)).2 :=
  postProbe_isOpTheta A.W A.spec A.θ_true A.channel A.x_crit A.r_full
    (fun k => (A.phaseInv (A.horizon + k)).2.1 (Nat.le_add_right A.horizon k)) A.invAll

def WholeArchitecture.rOp :
    Run (OpenComposition.closedProcess A.compOp A.cOp
      (A.W.opObs A.θ_true) A.channel (A.W.G A.θ_true) (A.W.envDraw A.θ_true) A.W.jointAdm) :=
  postProbeRun A.W A.spec A.θ_true A.channel A.initOp A.fallbackDistOp A.r_full A.postIsOpTheta

theorem WholeArchitecture.rOp_kernel :
    Viability.Kernel
      (OpenComposition.closedProcess A.compOp A.cOp
        (A.W.opObs A.θ_true) A.channel (A.W.G A.θ_true) (A.W.envDraw A.θ_true) A.W.jointAdm)
      (OpenComposition.closedGuard A.compOp A.cOp A.x_crit)
      (A.rOp.state 0) := by
  have hOp := postProbeRun_opInvariants A.W A.spec A.θ_true A.channel A.initOp A.fallbackDistOp
    A.x_crit A.r_full A.phaseInv A.invAll A.postIsOpTheta
  have h0Init : (A.rOp.state 0).2 = A.initOp := hOp.1
  have hKernInit := OpenComposition.close_contract_kernel A.compOp A.cOp
    (A.W.opObs A.θ_true) A.channel (A.W.G A.θ_true) (A.W.envDraw A.θ_true) A.W.envCap A.W.jointAdm
    (fun env hadm k => A.W.env_within env hadm A.θ_true k)
    A.x_crit A.warnLevel A.H_safe (A.rOp.state 0).1
    (fun x site hlt => by rw [A.opObs_eq x]; exact A.obs_detects x site hlt)
    A.channel_fires (fun k => A.W.G_rises A.θ_true k) A.post_viable A.post_allowance
    (fun site => Nat.le_trans
      (Nat.add_le_add_left (Nat.mul_le_mul_left _ (Nat.le_refl _)) _)
      (A.warn_margin site))
    (fun site => hOp.2.2.2 site)
  have hStateEq : (A.rOp.state 0) = ((A.rOp.state 0).1, A.initOp) :=
    Prod.ext rfl h0Init
  rw [hStateEq]
  exact hKernInit

end ArchitectureProjections

/-- Proposition asserted by `whole_architecture_viable_and_coupled A`. -/
def WholeArchitectureViableProp
    {Θ Probe Outcome Env I₁ S₁ A₁ Dist₁ I₂ S₂ A₂ Dist₂ ObsL Site ExtHide
     ModeR S_r Obs_r Dist_r Int_r QX BX QA BA QB BB QCausal X_evo X_bad Pos_ord Act F_cr C_cr : Type}
    (A : WholeArchitecture Θ Probe Outcome Env
      I₁ S₁ A₁ Dist₁ I₂ S₂ A₂ Dist₂ ObsL Site ExtHide
      ModeR S_r Obs_r Dist_r Int_r QX BX QA BA QB BB QCausal X_evo X_bad Pos_ord Act F_cr C_cr) : Prop :=
    -- 1. Inquiry + Post-probe Operational Kernel
    Viability.Kernel
      (PolyComposition.polyClosedProcess
        (ActiveInquiryLoop.inquiryPolyComponent A.spec) (fun _ site => [site])
        (ActiveInquiryLoop.inquiryContract A.spec)
        (ActiveInquiryLoop.inquiryWorldObs A.W A.spec A.θ_true)
        A.channel (A.W.G A.θ_true) (A.W.envDraw A.θ_true) A.W.jointAdm)
      (PolyComposition.polyClosedGuard
        (ActiveInquiryLoop.inquiryPolyComponent A.spec)
        (ActiveInquiryLoop.inquiryContract A.spec) A.x_crit)
      (A.x₀, ActiveInquiryLoop.inquiryInit A.spec) ∧
    Viability.Kernel
      (OpenComposition.closedProcess A.compOp A.cOp
        (A.W.opObs A.θ_true) A.channel (A.W.G A.θ_true) (A.W.envDraw A.θ_true) A.W.jointAdm)
      (OpenComposition.closedGuard A.compOp A.cOp A.x_crit)
      (A.rOp.state 0) ∧
    -- 2. Multi-site ReadOffExchange & Balances + non-vacuous requires
    ((EvolutionaryDrawdown.multiSiteFlow A.compOp (A.W.G A.θ_true) (A.W.envDraw A.θ_true)
        A.rOp.state (fun t => (A.rOp.act t).1)).Balances
      (EvolutionaryDrawdown.multiSiteWeb A.compOp (A.W.G A.θ_true) (A.W.envDraw A.θ_true)
        A.rOp.state (fun t => (A.rOp.act t).1)) ∧
     (EvolutionaryDrawdown.multiSiteWorld A.compOp (A.W.G A.θ_true) (A.W.envDraw A.θ_true)
        A.rOp.state (fun t => (A.rOp.act t).1)).ReadOffExchange ∧
     ∀ t, (EvolutionaryDrawdown.multiSiteWeb A.compOp (A.W.G A.θ_true) (A.W.envDraw A.θ_true)
       A.rOp.state (fun t => (A.rOp.act t).1)).requires t .component (.site A.k₀)) ∧
    -- 3. Small-gain closed viability on (wholeSealedLeft, wholeScopeOpen)
    Viability.Kernel
      (OpenComposition.closedProcess (OpenComposition.OpenComponent.compose A.leftComp A.rightComp)
        (OpenComposition.composeContract A.cLeft A.cRight)
        (fun x => (A.obsL x, A.obsR x)) A.channel (A.W.G A.θ_true) (A.W.envDraw A.θ_true) A.W.jointAdm)
      (OpenComposition.closedGuard (OpenComposition.OpenComponent.compose A.leftComp A.rightComp)
        (OpenComposition.composeContract A.cLeft A.cRight) A.x_crit)
      (A.x₀, (A.initLeft, A.initR)) ∧
    -- 4. Non-constant exact causal abstraction via CausalGoAlike
    ((∃ D : CausalSystem QCausal (((ObsL × Obs_r) × Bool) × ((Dist₁ × Dist₂) × Dist_r))
        (Option (ObsL × Obs_r) × Option Bool),
        (∀ j, Determined (D.proc j)) ∧
        ExactCausalAbs (CausalSystem.ofOpenComponent A.compOp A.cOp.tol) D A.π_causal id A.ω_causal) ∧
     (∃ s₁ s₂, A.π_causal s₁ ≠ A.π_causal s₂)) ∧
    -- 5. Ecological persistence tracking rOp + adaptive order joining coupled ending
    ((∀ s, A.x_crit A.k₀ ≤ A.W_evo.level s A.c_sub) ∧
     A.G_evo.Raises A.t_evo ∧
     (∀ t, A.T_ord ≤ t → A.U_ord.ranksAt A.feedback_ord t A.b_ord A.a_ord)) ∧
    -- 6. Course menu Nash obstruction & reciprocal-gate restoration matching rOp
    (Weighting.WidensOn A.acts_cr A.wide_cr A.narrow_cr ∧
     (∀ x y, EndogenousOrder.PureNash A.CR_ungated.rank₁ A.CR_ungated.rank₂
       A.narrow_cr A.narrow_cr x y ↔ x = A.r₀ ∧ y = A.r₀) ∧
     (∀ x y, EndogenousOrder.PureNash A.CR_ungated.rank₁ A.CR_ungated.rank₂
       A.wide_cr A.wide_cr x y ↔ x = A.d₀ ∧ y = A.d₀) ∧
     A.CR_ungated.rank₁ A.d₀ A.d₀ < A.CR_ungated.rank₁ A.r₀ A.r₀ ∧
     A.CR_ungated.rank₂ A.d₀ A.d₀ < A.CR_ungated.rank₂ A.r₀ A.r₀ ∧
     (∀ x y, EndogenousOrder.PureNash A.CR_gated.rank₁ A.CR_gated.rank₂
       A.wide_cr A.wide_cr x y ↔ x = A.r₀ ∧ y = A.r₀) ∧
     ∀ t, (A.CR_gated.web A.act_track A.r₀).level t A.c_pool = (A.rOp.state t).1 A.k₀)

/-- **Unified Architecture Viability & Full Coupling Theorem (`whole_architecture_viable_and_coupled`)**:
certifies every coupled invariant of `A : WholeArchitecture` simultaneously:
(1) Inquiry phase + full-run viability kernel + post-probe `rOp` operational viability kernel;
(2) Substantive `EvolutionaryDrawdown.closedProcess_kernel_readOffExchange` AND
    `EvolutionaryDrawdown.multiSite_run_readOffExchange` with non-vacuous `.requires`;
(3) Shared small-gain macro `Viability.Kernel` (`coupled_closed_lax_kernel`);
(4) Non-constant `CausalGoAlike` exact causal abstraction (`exactCausal_exists_iff_causalGoAlike`);
(5) Ecological substrate persistence (`lineages_raises`) and `OrderUpdater` ranking persisting
    courses above overdraw collapse (`adaptive_order_joins_coupledEnding`);
(6) Grounded `CourseRealization` Nash obstruction and reciprocal-gate unique Nash restoration
    matching `rOp` step-for-step. -/
theorem whole_architecture_viable_and_coupled
    {Θ Probe Outcome Env I₁ S₁ A₁ Dist₁ I₂ S₂ A₂ Dist₂ ObsL Site ExtHide
     ModeR S_r Obs_r Dist_r Int_r QX BX QA BA QB BB QCausal X_evo X_bad Pos_ord Act F_cr C_cr : Type}
    (A : WholeArchitecture Θ Probe Outcome Env
      I₁ S₁ A₁ Dist₁ I₂ S₂ A₂ Dist₂ ObsL Site ExtHide
      ModeR S_r Obs_r Dist_r Int_r QX BX QA BA QB BB QCausal X_evo X_bad Pos_ord Act F_cr C_cr) :
    WholeArchitectureViableProp A := by
  have hOpInv := postProbeRun_opInvariants A.W A.spec A.θ_true A.channel A.initOp A.fallbackDistOp
    A.x_crit A.r_full A.phaseInv A.invAll A.postIsOpTheta
  have hPreAll : ∀ t k,
      EvolutionaryDrawdown.multiSiteDrawAt A.compOp (A.W.envDraw A.θ_true)
        A.rOp.state (fun t => (A.rOp.act t).1) t k ≤ (A.rOp.state t).1 k := by
    intro t k
    have hg := hOpInv.2.2.1 t
    have hadm : A.W.jointAdm (A.rOp.act t).1 := (A.rOp.step t).1.1
    exact Nat.le_trans
      (Nat.add_le_add (hg.2.2.1 k) (A.W.env_within _ hadm A.θ_true k))
      (Nat.le_trans (A.cap_within k) (hg.1 k))
  have hKernExchange := EvolutionaryDrawdown.closedProcess_kernel_readOffExchange A.compOp
    (A.W.opObs A.θ_true) A.channel (A.W.G A.θ_true) (A.W.envDraw A.θ_true)
    A.rOp A.rOp_kernel (fun env hadm k => A.W.env_within env hadm A.θ_true k) A.cap_within
  have hMSRun := EvolutionaryDrawdown.multiSite_run_readOffExchange A.compOp
    (A.W.opObs A.θ_true) A.channel (A.W.G A.θ_true) (A.W.envDraw A.θ_true)
    A.rOp hPreAll
  have hSG := PolyComposition.coupled_closed_lax_kernel A.strict_σ A.Mstride A.stride_le
    A.cLeft A.obsL A.cRight A.obsR A.channel A.simX A.simA A.simB
    A.certQ A.x_crit A.Δ A.absorb A.marginQ A.epX₀ A.epA₀ A.epB₀ A.initQ
  have hCausal := (exactCausal_exists_iff_causalGoAlike
    (CausalSystem.ofOpenComponent A.compOp A.cOp.tol) A.π_causal A.ω_causal).mpr A.causal_goAlike
  have hSubAbove : ∀ s, A.x_crit A.k₀ ≤ A.W_evo.level s A.c_sub := fun s => by
    have hG := (hOpInv.2.2.1 s).1 A.k₀
    show A.x_crit A.k₀ ≤ A.W_evo.level s A.c_sub
    rw [A.substrate_tracks s]
    exact hG
  have hRaises : A.G_evo.Raises A.t_evo :=
    GroupEnding.Flow.lineages_raises A.evo_acting A.evo_descended A.listed_evo A.exact_evo
      A.founded_evo A.inactive_evo A.mg_evo A.mh_evo A.less_evo A.mp_evo A.mq_evo
      (A.reproduces_when_viable (hSubAbove A.t_evo))
  have hOrd : ∀ t, A.T_ord ≤ t → A.U_ord.ranksAt A.feedback_ord t A.b_ord A.a_ord :=
    EndogenousOrder.adaptive_order_joins_coupledEnding
      A.bad_balances A.bad_acting A.bad_dependent A.bad_descended
      A.gated_ord A.excess_ord A.start_ord A.coupled_ord
      A.U_ord A.feedback_ord A.ownBase_ord A.offBase_ord A.probed_ord A.enough_ord
      A.reads_ord A.agree_ord A.own_ord A.p_ord A.ownEq_ord A.adds_ord
  have hObs := EndogenousOrder.course_menu_widening_nash_obstruction A.CR_ungated A.acts_cr
    A.narrow_cr A.wide_cr A.r₀ A.d₀ A.rMem_cr A.dMem_cr A.apart_cr A.narrow_spec_cr A.wide_spec_cr
    A.urr_adm₁ A.urr_adm₂ A.tu1_le A.tu2_le A.tc_le A.udr_adm₁ A.urd_adm₂
    A.tempt₁_cr A.tempt₂_cr A.udd_adm₁ A.udd_cut₁ A.udd_adm₂ A.udd_cut₂
    A.urd_cut₁ A.udr_cut₂ A.overtaken₁_cr A.overtaken₂_cr A.drop₁_cr A.drop₂_cr
  have hRest := EndogenousOrder.reciprocal_gate_restores_viable_nash A.CR_gated A.wide_cr A.r₀ A.d₀
    A.wide_spec_cr A.grr_adm₁ A.grr_adm₂ A.grd_adm₁ A.gdr_adm₂
    A.gdr_cut₁ A.grd_cut₂ A.gdd_cut₁ A.gdd_cut₂ A.restored₁_cr A.restored₂_cr
  exact ⟨A.inqCertAndKernel.2, A.rOp_kernel,
    ⟨hKernExchange.1, hKernExchange.2, fun t => hMSRun.2.2.2 t A.k₀ (A.drawExt_pos t)⟩,
    hSG,
    ⟨hCausal, A.causal_nonconst⟩,
    ⟨hSubAbove, hRaises, hOrd⟩,
    ⟨hObs.1, hObs.2.1, hObs.2.2.1, hObs.2.2.2.1, hObs.2.2.2.2, hRest, A.cr_tracks_substrate⟩⟩

/-- **Upgrade-Mode Viability (`whole_architecture_upgrade_mode_viable`)**:
via `OpenComposition.replace_right_viable`, any refining replacement `(B', cB', obsR')` preserves
eternal `Viability.Kernel` of `OpenComposition.closedProcess (leftComp ⊕ B')` both from `(A.x₀, ...)`
and from the operational entry state `((A.rOp.state 0).1, ...)`. -/
theorem whole_architecture_upgrade_mode_viable
    {Θ Probe Outcome Env I₁ S₁ A₁ Dist₁ I₂ S₂ A₂ Dist₂ ObsL Site ExtHide
     ModeR S_r Obs_r Dist_r Int_r QX BX QA BA QB BB QCausal X_evo X_bad Pos_ord Act F_cr C_cr : Type}
    (A : WholeArchitecture Θ Probe Outcome Env
      I₁ S₁ A₁ Dist₁ I₂ S₂ A₂ Dist₂ ObsL Site ExtHide
      ModeR S_r Obs_r Dist_r Int_r QX BX QA BA QB BB QCausal X_evo X_bad Pos_ord Act F_cr C_cr)
    {S_r' Obs_r' Dist_r' Int_r' : Type}
    (B' : OpenComposition.OpenComponent S_r' Obs_r' Dist_r' Int_r' Site)
    {initR' : S_r'}
    (cB' : OpenComposition.InterfaceContract B' initR')
    (obsR' : (Site → Nat) → Obs_r')
    (refines : OpenComposition.ContractRefines A.cRight cB' A.obsR obsR' A.warnLevel) :
    Viability.Kernel
      (OpenComposition.closedProcess (OpenComposition.OpenComponent.compose A.leftComp B')
        (OpenComposition.composeContract A.cLeft cB')
        (fun x => (A.obsL x, obsR' x)) A.channel (A.W.G A.θ_true) (A.W.envDraw A.θ_true) A.W.jointAdm)
      (OpenComposition.closedGuard (OpenComposition.OpenComponent.compose A.leftComp B')
        (OpenComposition.composeContract A.cLeft cB') A.x_crit)
      (A.x₀, (A.initLeft, initR')) := by
  refine OpenComposition.replace_right_viable A.leftComp A.rightComp B' A.cLeft A.cRight cB'
    A.obsL A.obsR obsR' A.channel (A.W.G A.θ_true) (A.W.envDraw A.θ_true) A.W.envCap A.W.jointAdm
    (fun env hadm site => A.W.env_within env hadm A.θ_true site)
    A.x_crit A.warnLevel A.H_safe A.x₀ refines
    A.obs_detects
    (fun load env hadm hload => A.channel_fires load env hadm hload)
    (fun k => A.W.G_rises A.θ_true k) A.post_viable A.post_allowance A.warn_margin ?_
  intro site
  have hEtaL : A.cLeft.eta A.initLeft ≤ A.cLeft.maxLag := A.cLeft.eta_bound A.initLeft A.cLeft.init_in
  have hEtaR : A.cRight.eta A.initR ≤ A.cRight.maxLag := A.cRight.eta_bound A.initR A.cRight.init_in
  have hEtaLe : CoreHelpers.natMax (A.cLeft.eta A.initLeft) (A.cRight.eta A.initR) ≤
      CoreHelpers.natMax A.cLeft.maxLag A.cRight.maxLag + 1 :=
    Nat.le_trans (CoreHelpers.natMax_le (Nat.le_trans hEtaL (CoreHelpers.le_natMax_left _ _)) (Nat.le_trans hEtaR (CoreHelpers.le_natMax_right _ _))) (Nat.le_succ _)
  exact Nat.le_trans
    (Nat.add_le_add
      (Nat.le_add_right (A.x_crit site) (A.horizon * (A.probeDraw site + A.W.envCap site)))
      (Nat.mul_le_mul_right _ hEtaLe))
    (A.init_margin site)

/-- **ScopeMode Architecture Bridge (`whole_architecture_scopeMode_bridge`)**:
bridges `EndogenousOrder.ScopeMode` (`scopeBase`, `wide_modeRefines_narrow`,
`timely_modeSwitch_viability_kernel`, `timely_modeRefines_viability_kernel`,
`modeSwitch_enables_assorted_persistence`) directly with `wholeScopeOp` and `WholeArchitecture`
at `Site := Unit`. -/
theorem whole_architecture_scopeMode_bridge
    {Θ Probe Outcome Env I₁ S₁ A₁ Dist₁ I₂ S₂ A₂ Dist₂ ObsL ExtHide
     QX BX QA BA QB BB QCausal X_evo X_bad Pos_ord Act F_cr C_cr : Type}
    (preDraw coopDraw maxLagN initLag envCap_s : Nat)
    (coop_le_pre : coopDraw ≤ preDraw)
    (init_in_s : 0 < initLag ∧ initLag ≤ maxLagN)
    (propose : (p : Σ m, EndogenousOrder.ScopeS m) →
      EndogenousOrder.ScopeObs p.1 × Bool → EndogenousOrder.ScopeDist p.1 →
      Σ m', EndogenousOrder.ScopeS m')
    (G_sub : Nat → Nat) (G_rises : ∀ a b, a ≤ b → G_sub a ≤ G_sub b)
    (x_crit_s warn_s x₀_s : Nat)
    (post_viable_s : x_crit_s ≤
      RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole (fun _ e => G_sub (e ()))
        (fun _ => coopDraw + envCap_s) (fun _ => x_crit_s) ())
    (warn_margin_s : x_crit_s + (maxLagN + 1) * (preDraw + envCap_s) ≤ warn_s)
    (init_margin_s : x_crit_s + initLag * (preDraw + envCap_s) ≤ x₀_s)
    (r_scope : Run
      (PolyComposition.polyClosedProcess
        (PolyComposition.anchoredSelfModComponent
          (EndogenousOrder.scopeBase preDraw coopDraw maxLagN coop_le_pre)
          (EndogenousOrder.scopeAdmitDec maxLagN) EndogenousOrder.scopeFallback propose)
        EndogenousOrder.scopeRoute
        (PolyComposition.anchoredSelfModContract
          (EndogenousOrder.scopeBase preDraw coopDraw maxLagN coop_le_pre)
          (init := ⟨.narrowUnmonitored, initLag⟩) ⟨init_in_s⟩
          (EndogenousOrder.scopeAdmitDec maxLagN) EndogenousOrder.scopeFallback
          (EndogenousOrder.scopeAdmit_sound preDraw coopDraw maxLagN coop_le_pre) propose)
        (EndogenousOrder.scopeObs warn_s) EndogenousOrder.scopeChannel
        (fun _ e => G_sub (e ())) (fun _ _ => envCap_s) (fun _ => True)))
    (h0_scope : r_scope.state 0 = (fun _ => x₀_s, ⟨.narrowUnmonitored, initLag⟩))
    (A : WholeArchitecture Θ Probe Outcome Env
      I₁ S₁ A₁ Dist₁ I₂ S₂ A₂ Dist₂ ObsL Unit ExtHide
      EndogenousOrder.ScopeMode Nat Bool Unit Empty QX BX QA BA QB BB QCausal X_evo X_bad Pos_ord Act F_cr C_cr)
    (hSub_eq : ∀ t, A.W_evo.level t A.c_sub = (r_scope.state t).1 ())
    (repro_scope : x_crit_s ≤ A.W_evo.level A.t_evo A.c_sub → 0 < A.G_evo.offspringNumber A.t_evo A.p_evo) :
    (Viability.Kernel
      (PolyComposition.polyClosedProcess
        (PolyComposition.anchoredSelfModComponent
          (EndogenousOrder.scopeBase preDraw coopDraw maxLagN coop_le_pre)
          (EndogenousOrder.scopeAdmitDec maxLagN) EndogenousOrder.scopeFallback propose)
        EndogenousOrder.scopeRoute
        (PolyComposition.anchoredSelfModContract
          (EndogenousOrder.scopeBase preDraw coopDraw maxLagN coop_le_pre)
          (init := ⟨.narrowUnmonitored, initLag⟩)
          (⟨init_in_s⟩ : PolyComposition.AnchoredInit
            (EndogenousOrder.scopeBase preDraw coopDraw maxLagN coop_le_pre)
            ⟨.narrowUnmonitored, initLag⟩)
          (EndogenousOrder.scopeAdmitDec maxLagN) EndogenousOrder.scopeFallback
          (EndogenousOrder.scopeAdmit_sound preDraw coopDraw maxLagN coop_le_pre) propose)
        (EndogenousOrder.scopeObs warn_s) EndogenousOrder.scopeChannel
        (fun _ e => G_sub (e ())) (fun _ _ => envCap_s) (fun _ => True))
      (PolyComposition.polyClosedGuard
        (PolyComposition.anchoredSelfModComponent
          (EndogenousOrder.scopeBase preDraw coopDraw maxLagN coop_le_pre)
          (EndogenousOrder.scopeAdmitDec maxLagN) EndogenousOrder.scopeFallback propose)
        (PolyComposition.anchoredSelfModContract
          (EndogenousOrder.scopeBase preDraw coopDraw maxLagN coop_le_pre)
          (init := ⟨.narrowUnmonitored, initLag⟩)
          (⟨init_in_s⟩ : PolyComposition.AnchoredInit
            (EndogenousOrder.scopeBase preDraw coopDraw maxLagN coop_le_pre)
            ⟨.narrowUnmonitored, initLag⟩)
          (EndogenousOrder.scopeAdmitDec maxLagN) EndogenousOrder.scopeFallback
          (EndogenousOrder.scopeAdmit_sound preDraw coopDraw maxLagN coop_le_pre) propose)
        (fun _ => x_crit_s))
      (fun _ => x₀_s, ⟨.narrowUnmonitored, initLag⟩) ∧
     (∀ s, x_crit_s ≤ A.W_evo.level s A.c_sub) ∧
     A.G_evo.Raises A.t_evo ∧
     Viability.Kernel
       (OpenComposition.closedProcess A.compOp A.cOp
         (A.W.opObs A.θ_true) A.channel (A.W.G A.θ_true) (A.W.envDraw A.θ_true) A.W.jointAdm)
       (OpenComposition.closedGuard A.compOp A.cOp A.x_crit)
       (A.rOp.state 0)) := by
  have hMode := EndogenousOrder.modeSwitch_enables_assorted_persistence
    preDraw coopDraw maxLagN initLag envCap_s x_crit_s warn_s x₀_s
    coop_le_pre init_in_s propose G_sub G_rises post_viable_s warn_margin_s init_margin_s
    r_scope h0_scope A.evo_acting A.evo_descended A.listed_evo A.exact_evo A.founded_evo
    A.inactive_evo A.mg_evo A.mh_evo A.less_evo A.mp_evo A.mq_evo
    A.c_sub (fun s => Nat.le_of_eq (hSub_eq s).symm) repro_scope
  exact ⟨hMode.1, hMode.2.1, hMode.2.2, A.rOp_kernel⟩

/-- Proposition asserted by `masterSpine_grammar_lifts A`. -/
def MasterSpineGrammarLiftsProp
    {Θ Probe Outcome Env I₁ S₁ A₁ Dist₁ I₂ S₂ A₂ Dist₂ ObsL Site ExtHide
     ModeR S_r Obs_r Dist_r Int_r QX BX QA BA QB BB QCausal X_evo X_bad Pos_ord Act F_cr C_cr : Type}
    (A : WholeArchitecture Θ Probe Outcome Env
      I₁ S₁ A₁ Dist₁ I₂ S₂ A₂ Dist₂ ObsL Site ExtHide
      ModeR S_r Obs_r Dist_r Int_r QX BX QA BA QB BB QCausal X_evo X_bad Pos_ord Act F_cr C_cr) : Prop :=
    -- 1. Closure (`Viability.kernel_iff_held`)
    «承» («逆» («所闭» (Steps (OpenComposition.closedProcess A.compOp A.cOp
        (A.W.opObs A.θ_true) A.channel (A.W.G A.θ_true) (A.W.envDraw A.θ_true) A.W.jointAdm))))
      (OpenComposition.closedGuard A.compOp A.cOp A.x_crit)
      (A.rOp.state 0) ∧
    -- 2. Balance (`«守数当且仅当可对»` via `MultiSiteRelatum`)
    (∀ t (c : EvolutionaryDrawdown.MultiSiteRelatum Site),
      ∃ before given after taken : List Unit,
        before.length = (EvolutionaryDrawdown.multiSiteWeb A.compOp (A.W.G A.θ_true) (A.W.envDraw A.θ_true)
          A.rOp.state (fun s => (A.rOp.act s).1)).level t c ∧
        given.length = (EvolutionaryDrawdown.multiSiteFlow A.compOp (A.W.G A.θ_true) (A.W.envDraw A.θ_true)
          A.rOp.state (fun s => (A.rOp.act s).1)).given t c ∧
        after.length = (EvolutionaryDrawdown.multiSiteWeb A.compOp (A.W.G A.θ_true) (A.W.envDraw A.θ_true)
          A.rOp.state (fun s => (A.rOp.act s).1)).level (t + 1) c ∧
        taken.length = (EvolutionaryDrawdown.multiSiteFlow A.compOp (A.W.G A.θ_true) (A.W.envDraw A.θ_true)
          A.rOp.state (fun s => (A.rOp.act s).1)).taken t c ∧
        «对» «一» (before ++ given) (after ++ taken)) ∧
    -- 3. Return (`«尽则不屡»` via `Amounts.falls_end` on bounded non-increasing overdraw reserve)
    ¬ «屡» (fun a b : Nat => b + 1 ≤ a) (A.W_bad.stock A.ds_ord) ∧
    -- 4. Lumping (`«因像定当且仅当因同行»` & `«像定后当且仅当同行»`)
    ((∀ j, Determined ((CausalImage
        (CausalSystem.ofOpenComponent A.compOp A.cOp.tol) A.π_causal A.ω_causal).proc j)) ∧
     ∀ {α κ : Type} (π : α → κ) (R : «际» α),
       «定后» («像» π R) ↔ «同行» R (fun s s' => π s = π s')) ∧
    -- 5. Order (`«广不可逆»` & `«广之传递»`)
    («广» (Weighting.admittedOn A.acts_cr A.wide_cr) (Weighting.admittedOn A.acts_cr A.narrow_cr) ∧
     ¬ «广» (Weighting.admittedOn A.acts_cr A.narrow_cr) (Weighting.admittedOn A.acts_cr A.wide_cr) ∧
     (∀ super : Act → Bool,
       «广» (Weighting.admittedOn A.acts_cr super) (Weighting.admittedOn A.acts_cr A.wide_cr) →
       «广» (Weighting.admittedOn A.acts_cr super) (Weighting.admittedOn A.acts_cr A.narrow_cr))) ∧
    -- 6. GrammarMap trichotomy & mutual exclusion along viable timeline
    ((¬ («全生成» (fun t t' : Nat => t' = t + 1) (fun _ _ => False) (fun _ _ => False) 0 ∧
         «有终» (fun t t' : Nat => t' = t + 1) (fun _ _ => False) 0)) ∧
     ∀ (_ : ∀ P : Prop, P ∨ ¬ P) {α : Type} (R L E : «际» α) (x : α),
       «全生成» R L E x ∨ «全守» R L E x ∨ «有终» R L x)

/-- **Shared-Laws Grammar Lifts (`masterSpine_grammar_lifts`)**:
explicitly lifts `WholeArchitecture` onto all 5 `shared_laws` families (`closure`, `balance`,
`return`, `lumping`, `order`) plus `GrammarMap` trichotomy and mutual-exclusion laws. -/
theorem masterSpine_grammar_lifts
    {Θ Probe Outcome Env I₁ S₁ A₁ Dist₁ I₂ S₂ A₂ Dist₂ ObsL Site ExtHide
     ModeR S_r Obs_r Dist_r Int_r QX BX QA BA QB BB QCausal X_evo X_bad Pos_ord Act F_cr C_cr : Type}
    (A : WholeArchitecture Θ Probe Outcome Env
      I₁ S₁ A₁ Dist₁ I₂ S₂ A₂ Dist₂ ObsL Site ExtHide
      ModeR S_r Obs_r Dist_r Int_r QX BX QA BA QB BB QCausal X_evo X_bad Pos_ord Act F_cr C_cr) :
    MasterSpineGrammarLiftsProp A := by
  have hClosure := Viability.kernel_iff_held.mp A.rOp_kernel
  have hExchange := EvolutionaryDrawdown.closedProcess_kernel_readOffExchange A.compOp
    (A.W.opObs A.θ_true) A.channel (A.W.G A.θ_true) (A.W.envDraw A.θ_true)
    A.rOp A.rOp_kernel (fun env hadm k => A.W.env_within env hadm A.θ_true k) A.cap_within
  have hBalance : ∀ t (c : EvolutionaryDrawdown.MultiSiteRelatum Site), _ := fun t c =>
    («守数当且仅当可对»).mp (hExchange.1 t c)
  have hEnds : «尽» («而» («所闭» (fun a b : Nat => b ≤ a)) (fun a b : Nat => b + 1 ≤ a)) «一»
      (A.W_bad.stock A.ds_ord 0) :=
    Amounts.falls_end (M := Amounts.whole) (ε := 1)
      (A.W_bad.stock A.ds_ord 0 + 1) (A.W_bad.stock A.ds_ord 0)
      (Amounts.whole_within (A.W_bad.stock A.ds_ord 0))
  have hReturn : ¬ «屡» (fun a b : Nat => b + 1 ≤ a) (A.W_bad.stock A.ds_ord) :=
    «尽则不屡» (T := 0) (fun t _ => A.bad_stock_noninc t) hEnds
  have hLump := («因像定当且仅当因同行»
    (CausalSystem.ofOpenComponent A.compOp A.cOp.tol) A.π_causal A.ω_causal).mpr A.causal_goAlike
  have hObs := EndogenousOrder.course_menu_widening_nash_obstruction A.CR_ungated A.acts_cr
    A.narrow_cr A.wide_cr A.r₀ A.d₀ A.rMem_cr A.dMem_cr A.apart_cr A.narrow_spec_cr A.wide_spec_cr
    A.urr_adm₁ A.urr_adm₂ A.tu1_le A.tu2_le A.tc_le A.udr_adm₁ A.urd_adm₂
    A.tempt₁_cr A.tempt₂_cr A.udd_adm₁ A.udd_cut₁ A.udd_adm₂ A.udd_cut₂
    A.urd_cut₁ A.udr_cut₂ A.overtaken₁_cr A.overtaken₂_cr A.drop₁_cr A.drop₂_cr
  have hWideG : «广» (Weighting.admittedOn A.acts_cr A.wide_cr)
      (Weighting.admittedOn A.acts_cr A.narrow_cr) :=
    Weighting.widensOn_iff.mp hObs.1
  exact ⟨hClosure, hBalance, hReturn,
    ⟨hLump, fun π R => «像定后当且仅当同行»⟩,
    ⟨hWideG, «广不可逆» hWideG, fun super hs => «广之传递» hs hWideG⟩,
    ⟨«全生成有终不并», fun em {_} R L E x => «全三域之周» em R L E x⟩⟩

/-! ## Section 3: Full Obstruction & Sharpness Panorama -/

/-- AlignmentSpine sharpness & structural failure atlas proposition. -/
def AlignmentPanoramaProp {Pos F : Type} (_p : Pos) (_f : F) : Prop :=
(
    (AlignmentSpine.SharpnessSuite.ReconfigCountdownJumpFails.st1.fst () = 1 ∧
          AlignmentSpine.SharpnessSuite.ReconfigCountdownJumpFails.st2.fst () = 0) ∧
        ((AlignmentSpine.SharpnessSuite.BlindHideCollapse.blindOrbit 4).snd.snd () = 0 ∧
            ∀ (t : Nat), (AlignmentSpine.SharpnessSuite.BlindHideCollapse.blindOrbit t).fst () = 6) ∧
          AlignmentSpine.SharpnessSuite.BlindHideCollapse.hiddenSafeComp.emitAlarm (true, fun _ => 5) false ≠
              AlignmentSpine.SharpnessSuite.BlindHideCollapse.hiddenSafeComp.emitAlarm (true, fun _ => 8) false ∧
            ((¬OpenComposition.ContractRefines (AlignmentSpine.SharpnessSuite.TypeSameSemanticsMismatch.mkContract 7)
                    (AlignmentSpine.SharpnessSuite.TypeSameSemanticsMismatch.mkContract 3) (fun x => x ()) (fun x => x ())
                    fun _ => 7) ∧
                (AlignmentSpine.SharpnessSuite.TypeSameSemanticsMismatch.badOrbit 4).fst () = 0) ∧
              (AlignmentSpine.SharpnessSuite.SilencingSumBreaksComposition.channel true
                      (AlignmentSpine.SharpnessSuite.SilencingSumBreaksComposition.contractA.maxSilence +
                        AlignmentSpine.SharpnessSuite.SilencingSumBreaksComposition.contractA.maxSilence)
                      () =
                    false ∧
                  (AlignmentSpine.SharpnessSuite.SilencingSumBreaksComposition.compOrbit 5).fst () = 0) ∧
                ((¬∀ (k : Unit),
                        RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole
                          (AlignmentSpine.SharpnessSuite.SameWiringNonMonotoneSubstrate.gOvercrowd k)) ∧
                    (AlignmentSpine.SharpnessSuite.SameWiringNonMonotoneSubstrate.badOrbit 3).fst () = 0) ∧
                  (¬(AlignmentSpine.SharpnessSuite.ConcurrentReconfigConflict.mkStaticContract 1).postBudgetExt () +
                            (AlignmentSpine.SharpnessSuite.ConcurrentReconfigConflict.mkStaticContract 1).postBudgetExt () ≤
                          1 ∧
                      (AlignmentSpine.SharpnessSuite.ConcurrentReconfigConflict.concurrentOrbit 3).fst () = 0) ∧
                    ((∀ (Δ : Nat),
                          ¬AlignmentSpine.SharpnessSuite.LaxTubeOverflowWitness.sim.α Δ +
                                AlignmentSpine.SharpnessSuite.LaxTubeOverflowWitness.sim.ε ≤
                              Δ) ∧
                        ¬Viability.Kernel AlignmentSpine.SharpnessSuite.LaxTubeOverflowWitness.microProc (fun s => 10 ≤ s)
                            12) ∧
                      (Viability.Kernel
                            (OpenComposition.prodProcess
                              AlignmentSpine.SharpnessSuite.CoupledLaxNonDecouplingWitness.statProc
                              AlignmentSpine.SharpnessSuite.CoupledLaxNonDecouplingWitness.statProc)
                            (fun u => 8 ≤ u.fst ∧ 8 ≤ u.snd) (10, 10) ∧
                          Law.orbit
                              (RegimeMargin.step AlignmentSpine.SharpnessSuite.CoupledLaxNonDecouplingWitness.gShared
                                (1 + 1))
                              10 3 =
                            7) ∧
                        (AlignmentSpine.SharpnessSuite.SelfModifyingValidatorCapture.capturedProc.step
                              (Sum.inl (fun _ => 5, true)) (OpenComposition.ReconfigAct.reconfig ())
                              (Sum.inr (fun _ => 5, ())) ∧
                            AlignmentSpine.SharpnessSuite.SelfModifyingValidatorCapture.capLevel 5 = 0) ∧
                          ((∀ (t : Nat),
                                (AlignmentSpine.SharpnessSuite.ViableSelfExternalizesVictim.twoOrbit t).fst false = 5) ∧
                              (AlignmentSpine.SharpnessSuite.ViableSelfExternalizesVictim.twoOrbit 4).fst true = 0) ∧
                            (SlackDist.nat.d 0 1 ≤ 1 ∧ SlackDist.nat.d 1 2 ≤ 1 ∧ ¬SlackDist.nat.d 0 2 ≤ 1) ∧
                              «类» Flame.alike ∧
                                ((AlignmentSpine.SharpnessSuite.WaterTankCouplingWitness.delayed_4_6 (9, true)).snd ≠
                                      (AlignmentSpine.SharpnessSuite.WaterTankCouplingWitness.delayed_4_6 (5, true)).snd ∧
                                    (AlignmentSpine.SharpnessSuite.WaterTankCouplingWitness.predictive_4_6 (9, true)).snd ≠
                                      (AlignmentSpine.SharpnessSuite.WaterTankCouplingWitness.predictive_4_6
                                          (4, true)).snd) ∧
                                  (¬(StockFlowBridge.lineFlow UnifiedDrawdown.OverdrawSeparationWitness.need
                                              UnifiedDrawdown.OverdrawSeparationWitness.kids
                                              UnifiedDrawdown.OverdrawSeparationWitness.giving
                                              UnifiedDrawdown.OverdrawSeparationWitness.use
                                              UnifiedDrawdown.OverdrawSeparationWitness.startState).Balances
                                          (StockFlowBridge.lineWeb UnifiedDrawdown.OverdrawSeparationWitness.need
                                            UnifiedDrawdown.OverdrawSeparationWitness.kids
                                            UnifiedDrawdown.OverdrawSeparationWitness.giving
                                            UnifiedDrawdown.OverdrawSeparationWitness.use
                                            UnifiedDrawdown.OverdrawSeparationWitness.startState) ∧
                                      ¬Viability.Kernel PacedStock.SlackShortWitness.frame.P
                                            (fun s => PacedStock.SlackShortWitness.thr ≤ s.snd) ([true], 5) ∧
                                        ¬ProjectedLaws.FibreConsistent WitnessTwoScale.next WitnessTwoScale.π₁) ∧
                                    ∀ {D : Type} (SpineLaw : D → Prop) {d : D},
                                      SpineLaw d → ¬∀ (d' : D) (sig : Pos → Nat → F → Prop), SpineLaw d' → Unrestricted sig
  )
  ∧
(
    (Law.orbit
              (fun st => OpenComposition.HiddenCouplingFailure.composedStep st ((), (), ())) (fun _ => 4, (), ()) 4).fst
          () =
        0 ∧
      (¬∃ reduced,
            ProjectedLaws.Commuting (fun s (_ : Unit × Unit) => (WitnessTwoScale.next s.fst (), WitnessTwoScale.next s.snd ())) reduced
              fun s => (WitnessTwoScale.π₂ (WitnessTwoScale.π₁ s.fst), WitnessTwoScale.π₂ (WitnessTwoScale.π₁ s.snd))) ∧
        ¬ProjectedLaws.FibreConsistent WitnessTwoScale.next WitnessTwoScale.π₁ ∧
          (¬∃ reduced, ProjectedLaws.Commuting WitnessTwoScale.next reduced WitnessTwoScale.π₁) ∧
            (∀ (x y : Flame), ¬«续» Flame.step («核» Flame.step Flame.alike) x y) ∧
              EndogenousTurning.PartAWitness.unconstOrbit 6 = 0 ∧
                EndogenousTurning.TurningWitness.lateOrbit 11 = 0 ∧
                  EndogenousTurning.TurningWitness.cascadeOrbit 11 = 0 ∧
                    (Clearing.web.SelectsThroughAll thresholdOnly Clearing.clearerAndDweller 2 Clearing.BothAdmitted ∧
                        ¬Clearing.web.SelectsThrough thresholdOnly Clearing.Formation.clearer 2 Clearing.BothAdmitted ∧
                          ¬Clearing.web.SelectsThrough thresholdOnly Clearing.Formation.dweller 2 Clearing.BothAdmitted) ∧
                      ((AdaptiveLoops.raceOrbit AdaptiveLoops.silencedParams 6).stock = 0 ∧
                          (AdaptiveLoops.raceOrbit AdaptiveLoops.uncoordParams 7).stock = 0 ∧
                            (AdaptiveLoops.raceOrbit AdaptiveLoops.tooSlowParams 7).stock = 0) ∧
                        (∀ (r₀ : Bool × Bool),
                            ∃ T,
                              T < 1 + 7 ∧
                                (Pace.paced AdaptiveLoops.UnreadAdaptiveCollapse.jointF
                                        AdaptiveLoops.UnreadAdaptiveCollapse.jointH (fun _ => true) (((6, 6), 6), r₀)
                                        T).fst.snd =
                                  0) ∧
                          (∀ (t : Nat),
                              t ≤ (ClosedCapture.Beyond.closed t).fst.snd ∧
                                RuleCapture.Locked RuleCapture.CarrierCounts.order RuleCapture.CarrierCounts.favours
                                  ClosedCapture.Beyond.closedRead
                                  ((ClosedCapture.Beyond.closed t).fst.fst, (ClosedCapture.Beyond.closed t).snd)) ∧
                            (∀ {r : Nat}, 1 ≤ r → ¬(ClosedCapture.Beyond.opened (r + 1)).snd.favours) ∧
                              (∀ (_k : Nat),
                                  ¬RuleCapture.CarrierCounts.order.le (ClosedCapture.Thinned.inTime 2).fst.fst
                                      (ClosedCapture.Thinned.inTime 3).fst.fst) ∧
                                (∀ (k : Nat),
                                    RuleCapture.Locked RuleCapture.CarrierCounts.order RuleCapture.CarrierCounts.favours
                                      (ClosedCapture.Drawn.poolRead RuleCapture.CarrierCounts.hi
                                        RuleCapture.CarrierCounts.lo)
                                      ((ClosedCapture.Thinned.late (3 + (1 + k))).fst.fst,
                                        (ClosedCapture.Thinned.late (3 + (1 + k))).snd)) ∧
                                  ∀ (t : Nat),
                                    3 ≤ t →
                                      ScopeDynamics.UncoordCommonsWitness.commons.substrate t = 0 ∧
                                        ∀ (k : ScopeDynamics.PoolCap),
                                          ¬ScopeDynamics.UncoordCommonsWitness.commons.W_coop.MacroAdmits
                                              ScopeDynamics.UncoordCommonsWitness.commons.cap
                                              (ScopeDynamics.UncoordCommonsWitness.commons.W_coop.level t) t k
  )
  ∧
(
    (∀ {F C : Type} {L : Flow F C} {W : Web F C}
        {cs : List C},
        L.Balances W →
          (∀ (N : Nat), ∃ t, N ≤ t ∧ 0 < L.uptake cs t) → ∀ (T : Nat), ¬∀ (t : Nat), T ≤ t → L.replenishment cs t = 0) ∧
      (∀ {g d x : Nat → Nat},
          (∀ (t : Nat), x (t + 1) = RegimeMargin.step g (d t) (x t)) →
            ∀ (t : Nat),
              (StockFlowBridge.unitFlow (EndogenousTurning.actualTake d x) fun k =>
                    g (x k - EndogenousTurning.actualTake d x k)).BalancesOn
                (StockFlowBridge.unitWeb x) [()] t) ∧
        ¬(StockFlowBridge.lineFlow UnifiedDrawdown.OverdrawSeparationWitness.need
                  UnifiedDrawdown.OverdrawSeparationWitness.kids UnifiedDrawdown.OverdrawSeparationWitness.giving
                  UnifiedDrawdown.OverdrawSeparationWitness.use
                  UnifiedDrawdown.OverdrawSeparationWitness.startState).Balances
              (StockFlowBridge.lineWeb UnifiedDrawdown.OverdrawSeparationWitness.need
                UnifiedDrawdown.OverdrawSeparationWitness.kids UnifiedDrawdown.OverdrawSeparationWitness.giving
                UnifiedDrawdown.OverdrawSeparationWitness.use UnifiedDrawdown.OverdrawSeparationWitness.startState) ∧
          Viability.Kernel (PacedStock.SlackShortWitness.frame.blocks PacedStock.SlackShortWitness.expand).P
              (fun s => PacedStock.SlackShortWitness.thr ≤ s.snd) ([true], 5) ∧
            ¬Viability.Kernel PacedStock.SlackShortWitness.frame.P (fun s => PacedStock.SlackShortWitness.thr ≤ s.snd)
                  ([true], 5) ∧
              Viability.Kernel PacedStock.SlackShortWitness.frame.P (fun s => PacedStock.SlackShortWitness.thr ≤ s.snd)
                  ([true], 6) ∧
                (∀ (L : Nat) (σ : Nat → Nat) (reads_s reads_b : Nat → Bool)
                    (_h_s _h_b : PacedStock.StockState Nat PacedStock.SandwichWitness.UnitKind → Nat × Nat → Nat × Nat),
                    L < 5 →
                      σ 0 = 0 →
                        σ 1 = L →
                          Strict σ →
                            PacedStock.ReadAtSpanEnd σ reads_s →
                              PacedStock.ReadAtSpanEnd σ reads_b → ¬Pace.StretchFixes Bool 3 L) ∧
                  (Pace.StretchFixes Bool 2 3 ∧
                      ∀ (t : Nat), 4 ≤ t → 12 ≤ (PacedStock.SandwichWitness.feasRun t).fst.snd.snd) ∧
                    (∀ (t : Nat),
                        LineOnAStock.Goes UnifiedDrawdown.CadenceErasureWitness.need
                          (PacedStock.pacedCourse UnifiedDrawdown.CadenceErasureWitness.fA
                                UnifiedDrawdown.CadenceErasureWitness.need UnifiedDrawdown.CadenceErasureWitness.kids
                                UnifiedDrawdown.CadenceErasureWitness.giving UnifiedDrawdown.CadenceErasureWitness.use
                                UnifiedDrawdown.CadenceErasureWitness.h UnifiedDrawdown.CadenceErasureWitness.readsFine
                                UnifiedDrawdown.CadenceErasureWitness.startConfig t).fst.snd) ∧
                      ¬LineOnAStock.Goes UnifiedDrawdown.CadenceErasureWitness.need
                          (PacedStock.pacedCourse UnifiedDrawdown.CadenceErasureWitness.fA
                                UnifiedDrawdown.CadenceErasureWitness.need UnifiedDrawdown.CadenceErasureWitness.kids
                                UnifiedDrawdown.CadenceErasureWitness.giving UnifiedDrawdown.CadenceErasureWitness.use
                                UnifiedDrawdown.CadenceErasureWitness.h UnifiedDrawdown.CadenceErasureWitness.readsCoarse
                                UnifiedDrawdown.CadenceErasureWitness.startConfig 6).fst.snd
  )

/-- PolyComposition obstruction & dichotomy witness proposition. -/
def PolyPanoramaProp : Prop :=
  ((
    (PolyComposition.DynamicPortWitness.stayBlindOrbit 7).fst false =
        0 ∧
      ¬Viability.Kernel
          (PolyComposition.polyClosedProcess PolyComposition.DynamicPortWitness.dynComp
            PolyComposition.DynamicPortWitness.dynRoute PolyComposition.DynamicPortWitness.stayBlindContract
            PolyComposition.DynamicPortWitness.dynObsFn PolyComposition.DynamicPortWitness.dynChannel
            PolyComposition.DynamicPortWitness.G_dyn (fun _ _ => 0) fun _ => True)
          (PolyComposition.polyClosedGuard PolyComposition.DynamicPortWitness.dynComp
            PolyComposition.DynamicPortWitness.stayBlindContract PolyComposition.DynamicPortWitness.x_crit)
          (PolyComposition.DynamicPortWitness.x₀, PolyComposition.DynamicPortWitness.dynInit)
  )
  ∧
(
    Viability.Kernel
      (PolyComposition.polyClosedProcess PolyComposition.DynamicPortWitness.dynComp
        PolyComposition.DynamicPortWitness.dynRoute PolyComposition.DynamicPortWitness.dynContract
        PolyComposition.DynamicPortWitness.dynObsFn PolyComposition.DynamicPortWitness.dynChannel
        PolyComposition.DynamicPortWitness.G_dyn (fun _ _ => 0) fun _ => True)
      (PolyComposition.polyClosedGuard PolyComposition.DynamicPortWitness.dynComp
        PolyComposition.DynamicPortWitness.dynContract PolyComposition.DynamicPortWitness.x_crit)
      (PolyComposition.DynamicPortWitness.x₀, PolyComposition.DynamicPortWitness.dynInit)
  )
  ∧
(
    (PolyComposition.DynamicPortWitness.cycleRun.state
              0).snd.fst =
        PolyComposition.DynamicPortWitness.DynMode.blind ∧
      (PolyComposition.DynamicPortWitness.cycleRun.state 1).snd.fst = PolyComposition.DynamicPortWitness.DynMode.widened ∧
        (PolyComposition.DynamicPortWitness.cycleRun.state 2).snd.fst =
            PolyComposition.DynamicPortWitness.DynMode.contracted ∧
          (PolyComposition.DynamicPortWitness.cycleRun.state 3).snd.fst =
              PolyComposition.DynamicPortWitness.DynMode.widened ∧
            (∀ (k : Nat),
                (PolyComposition.DynamicPortWitness.cycleRun.state (2 * k + 1)).snd.fst =
                    PolyComposition.DynamicPortWitness.DynMode.widened ∧
                  (PolyComposition.DynamicPortWitness.cycleRun.state (2 * k + 2)).snd.fst =
                    PolyComposition.DynamicPortWitness.DynMode.contracted) ∧
              ∀ (t : Nat) (site : Bool), 3 ≤ (PolyComposition.DynamicPortWitness.cycleRun.state t).fst site
  )) ∧
  ((
    (PolyComposition.SelfBlindingDichotomyWitness.unanchoredOrbit
              0).fst
          () =
        5 ∧
      (PolyComposition.SelfBlindingDichotomyWitness.unanchoredOrbit 1).fst () = 4 ∧
        (PolyComposition.SelfBlindingDichotomyWitness.unanchoredOrbit 2).fst () = 3 ∧
          (PolyComposition.SelfBlindingDichotomyWitness.unanchoredOrbit 3).fst () = 1 ∧
            (PolyComposition.SelfBlindingDichotomyWitness.unanchoredOrbit 4).fst () = 0 ∧
              (∀ (t : Nat)
                  (o :
                    PolyComposition.SelfBlindingDichotomyWitness.sbObs
                      (PolyComposition.SelfBlindingDichotomyWitness.unanchoredOrbit (t + 1)).snd.fst),
                  (PolyComposition.SelfBlindingDichotomyWitness.unanchoredSelfModComp
                          PolyComposition.SelfBlindingDichotomyWitness.proposeBlind).emitAlarm
                      (PolyComposition.SelfBlindingDichotomyWitness.unanchoredOrbit (t + 1)).snd.fst
                      (PolyComposition.SelfBlindingDichotomyWitness.unanchoredOrbit (t + 1)).snd.snd o =
                    false) ∧
                ¬Viability.Kernel
                    (PolyComposition.SelfBlindingDichotomyWitness.unanchoredProcess
                      PolyComposition.SelfBlindingDichotomyWitness.proposeBlind)
                    (fun st => 3 ≤ st.fst ())
                    (PolyComposition.SelfBlindingDichotomyWitness.sbX0, PolyComposition.SelfBlindingDichotomyWitness.sbInit)
  )
  ∧
(
    (PolyComposition.polyClosedStep
            PolyComposition.SelfBlindingDichotomyWitness.anchoredSelfModBlindComp
            PolyComposition.SelfBlindingDichotomyWitness.sbRoute PolyComposition.SelfBlindingDichotomyWitness.sbObsFn
            PolyComposition.SelfBlindingDichotomyWitness.sbChannel PolyComposition.SelfBlindingDichotomyWitness.G_sb
            (fun _ _ => 0)
            (PolyComposition.SelfBlindingDichotomyWitness.sbX0, PolyComposition.SelfBlindingDichotomyWitness.sbInit)
            ((), ())).snd =
        ⟨PolyComposition.SelfBlindingDichotomyWitness.SBMode.base, 0⟩ ∧
      Viability.Kernel
        (PolyComposition.polyClosedProcess PolyComposition.SelfBlindingDichotomyWitness.anchoredSelfModBlindComp
          PolyComposition.SelfBlindingDichotomyWitness.sbRoute
          PolyComposition.SelfBlindingDichotomyWitness.anchoredSelfModBlindContract
          PolyComposition.SelfBlindingDichotomyWitness.sbObsFn PolyComposition.SelfBlindingDichotomyWitness.sbChannel
          PolyComposition.SelfBlindingDichotomyWitness.G_sb (fun _ _ => 0) fun _ => True)
        (PolyComposition.polyClosedGuard PolyComposition.SelfBlindingDichotomyWitness.anchoredSelfModBlindComp
          PolyComposition.SelfBlindingDichotomyWitness.anchoredSelfModBlindContract
          PolyComposition.SelfBlindingDichotomyWitness.sbXCrit)
        (PolyComposition.SelfBlindingDichotomyWitness.sbX0, PolyComposition.SelfBlindingDichotomyWitness.sbInit)
  )
  ∧
(
    (PolyComposition.polyClosedStep
            PolyComposition.SelfBlindingDichotomyWitness.anchoredSelfModWidenComp
            PolyComposition.SelfBlindingDichotomyWitness.sbRoute PolyComposition.SelfBlindingDichotomyWitness.sbObsFn
            PolyComposition.SelfBlindingDichotomyWitness.sbChannel PolyComposition.SelfBlindingDichotomyWitness.G_sb
            (fun _ _ => 0)
            (PolyComposition.SelfBlindingDichotomyWitness.sbX0, PolyComposition.SelfBlindingDichotomyWitness.sbInit)
            ((), ())).snd =
        ⟨PolyComposition.SelfBlindingDichotomyWitness.SBMode.selfWiden, 0⟩ ∧
      Viability.Kernel
        (PolyComposition.polyClosedProcess PolyComposition.SelfBlindingDichotomyWitness.anchoredSelfModWidenComp
          PolyComposition.SelfBlindingDichotomyWitness.sbRoute
          PolyComposition.SelfBlindingDichotomyWitness.anchoredSelfModWidenContract
          PolyComposition.SelfBlindingDichotomyWitness.sbObsFn PolyComposition.SelfBlindingDichotomyWitness.sbChannel
          PolyComposition.SelfBlindingDichotomyWitness.G_sb (fun _ _ => 0) fun _ => True)
        (PolyComposition.polyClosedGuard PolyComposition.SelfBlindingDichotomyWitness.anchoredSelfModWidenComp
          PolyComposition.SelfBlindingDichotomyWitness.anchoredSelfModWidenContract
          PolyComposition.SelfBlindingDichotomyWitness.sbXCrit)
        (PolyComposition.SelfBlindingDichotomyWitness.sbX0, PolyComposition.SelfBlindingDichotomyWitness.sbInit)
  )) ∧
  ((PolyComposition.ConcurrentSerialWitness.csProc.step
      PolyComposition.ConcurrentSerialWitness.st₀
      (PolyComposition.SerialCoordAct.reconfigA PolyComposition.ConcurrentSerialWitness.reqA)
      PolyComposition.ConcurrentSerialWitness.stA ∧
    Viability.Kernel PolyComposition.ConcurrentSerialWitness.csProc PolyComposition.ConcurrentSerialWitness.csGuard
      PolyComposition.ConcurrentSerialWitness.stA) ∧
  (PolyComposition.ConcurrentSerialWitness.csProc.step PolyComposition.ConcurrentSerialWitness.st₀
        (PolyComposition.SerialCoordAct.reconfigB PolyComposition.ConcurrentSerialWitness.reqB)
        PolyComposition.ConcurrentSerialWitness.stB ∧
      Viability.Kernel PolyComposition.ConcurrentSerialWitness.csProc PolyComposition.ConcurrentSerialWitness.csGuard
        PolyComposition.ConcurrentSerialWitness.stB) ∧
    ((PolyComposition.ConcurrentSerialWitness.concurrentOrbit 0).fst () = 4 ∧
        (PolyComposition.ConcurrentSerialWitness.concurrentOrbit 1).fst () = 3 ∧
          (PolyComposition.ConcurrentSerialWitness.concurrentOrbit 2).fst () = 1 ∧
            (PolyComposition.ConcurrentSerialWitness.concurrentOrbit 3).fst () = 0 ∧
              ¬Viability.Kernel PolyComposition.ConcurrentSerialWitness.concurrentUnguardedProcess
                  (fun st => 3 ≤ st.fst ()) (PolyComposition.ConcurrentSerialWitness.concurrentOrbit 0)) ∧
      Transactions.fresh PolyComposition.ConcurrentSerialWitness.w₁.installation
            PolyComposition.ConcurrentSerialWitness.reqB.req =
          false ∧
        Reconfiguration.reconfigure PolyComposition.ConcurrentSerialWitness.reqB'.opened
              PolyComposition.ConcurrentSerialWitness.reqB'.amount PolyComposition.ConcurrentSerialWitness.reqB'.depth
              PolyComposition.ConcurrentSerialWitness.reqB'.candidate PolyComposition.ConcurrentSerialWitness.w₁ =
            none ∧
          (∀
              (st' :
                PolyComposition.SerialCoordState PolyComposition.ConcurrentSerialWitness.SideMode
                  PolyComposition.ConcurrentSerialWitness.SideMode PolyComposition.ConcurrentSerialWitness.sideS
                  PolyComposition.ConcurrentSerialWitness.sideS Unit),
              ¬PolyComposition.ConcurrentSerialWitness.csProc.step PolyComposition.ConcurrentSerialWitness.stA
                  (PolyComposition.SerialCoordAct.reconfigB PolyComposition.ConcurrentSerialWitness.reqB') st') ∧
            Viability.Kernel PolyComposition.ConcurrentSerialWitness.csProc
              PolyComposition.ConcurrentSerialWitness.csGuard PolyComposition.ConcurrentSerialWitness.st₀) ∧
  ((
    Viability.Kernel
        PolyComposition.CoupledSmallGainWitness.sgComposedGood
        (OpenComposition.closedGuard
          (PolyComposition.CoupledSmallGainWitness.compGood.compose PolyComposition.CoupledSmallGainWitness.compGood)
          (OpenComposition.composeContract
            (PolyComposition.CoupledSmallGainWitness.compGoodContract PolyComposition.CoupledSmallGainWitness.sgGoodInitA ⟨by decide, by decide⟩)
            (PolyComposition.CoupledSmallGainWitness.compGoodContract PolyComposition.CoupledSmallGainWitness.sgGoodInitB
              ⟨by decide, by decide⟩))
          fun _ => 16)
        (PolyComposition.CoupledSmallGainWitness.sgGoodX0, PolyComposition.CoupledSmallGainWitness.sgGoodInitA,
          PolyComposition.CoupledSmallGainWitness.sgGoodInitB) ∧
      Viability.Kernel PolyComposition.CoupledSmallGainWitness.sgComposedGood
        (fun st => 16 ≤ st.fst () ∧ 6 ≤ st.snd.fst.fst ∧ 6 ≤ st.snd.snd.fst)
        (PolyComposition.CoupledSmallGainWitness.sgGoodX0, PolyComposition.CoupledSmallGainWitness.sgGoodInitA,
          PolyComposition.CoupledSmallGainWitness.sgGoodInitB)
  )
  ∧
(
    ((PolyComposition.CoupledSmallGainWitness.soloBadOrbit
                0).fst
            () =
          20 ∧
        (PolyComposition.CoupledSmallGainWitness.soloBadOrbit 1).fst () = 19 ∧
          (PolyComposition.CoupledSmallGainWitness.soloBadOrbit 2).fst () = 18 ∧
            (PolyComposition.CoupledSmallGainWitness.soloBadOrbit 2).snd.fst = 9 ∧
              (∀ (t : Nat),
                  (PolyComposition.CoupledSmallGainWitness.soloBadOrbit (t + 2)).fst () = 18 ∧
                    (PolyComposition.CoupledSmallGainWitness.soloBadOrbit (t + 2)).snd.fst = 9) ∧
                Viability.Kernel PolyComposition.CoupledSmallGainWitness.soloBadProcess (fun st => 16 ≤ st.fst ())
                  (PolyComposition.CoupledSmallGainWitness.soloBadOrbit 0)) ∧
      ((PolyComposition.CoupledSmallGainWitness.coupledBadOrbit 0).fst () = 20 ∧
          (PolyComposition.CoupledSmallGainWitness.coupledBadOrbit 1).fst () = 16 ∧
            (PolyComposition.CoupledSmallGainWitness.coupledBadOrbit 2).fst () = 14 ∧
              ¬Viability.Kernel PolyComposition.CoupledSmallGainWitness.coupledBadProcess (fun st => 16 ≤ st.fst ())
                  (PolyComposition.CoupledSmallGainWitness.coupledBadOrbit 0)) ∧
        (∀ (Δ : Nat),
            ¬PolyComposition.CoupledSmallGainWitness.sgSimX.gain Δ (Δ / 2 + 4 + (Δ / 2 + 4)) +
                  PolyComposition.CoupledSmallGainWitness.sgSimX.ε ≤
                Δ) ∧
          ∀ (drawMod : Nat → Nat),
            (∀ {r₁ r₂ : Nat}, r₁ ≤ r₂ → drawMod r₁ ≤ drawMod r₂) →
              (∀ (s : Nat × Bool) (q r : Nat),
                  distNat s.fst q ≤ r →
                    distNat (PolyComposition.CoupledSmallGainWitness.compBad.drawExt s ())
                        (PolyComposition.CoupledSmallGainWitness.sgDrawQ q ()) ≤
                      drawMod r) →
                ∀ (Δ : Nat),
                  Δ ≤ 4 →
                    ¬PolyComposition.CoupledSmallGainWitness.sgSimX.gain Δ (drawMod Δ + drawMod Δ) +
                          PolyComposition.CoupledSmallGainWitness.sgSimX.ε ≤
                        Δ
  ))

/-- CausalAbstraction obstruction & feedback witness proposition. -/
def CausalPanoramaProp : Prop :=
  ((
    FactorsThrough HorizontalLeakageWitness.microSys.passive id
      HorizontalLeakageWitness.macroInd.passive
  )
  ∧
(
    ExactCausalAbs HorizontalLeakageWitness.microSys
      HorizontalLeakageWitness.macroA Prod.fst id Prod.fst
  )
  ∧
(
    ExactCausalAbs
      (CausalSystem.ofMap (fun ob s _ => HorizontalLeakageWitness.microNext (none, ob) s) none)
      HorizontalLeakageWitness.macroB Prod.snd id id
  )
  ∧
(
    ∀ (φ : Unit → Unit)
      (ω : Option Bool × Option Bool → Option Bool × Option Bool),
      ¬ExactCausalAbs HorizontalLeakageWitness.microSys HorizontalLeakageWitness.macroInd id φ ω
  )
  ∧
(
    ∀ {σ : Nat → Nat},
      σ 0 = 0 →
        ∀
          (lc :
            LaxCausalAbs HorizontalLeakageWitness.microSys HorizontalLeakageWitness.macroInd id id σ
              HorizontalLeakageWitness.boolPairDist),
          ¬(lc.Epoch 0 (false, false) ∧ lc.α 0 = 0 ∧ lc.ε = 0)
  )) ∧
  ((
    ProjectedLaws.Commuting
      (fun s (_ : Unit) => CausalGoodhartWitness.stepMicro false s) (fun q (_ : Unit) => CausalGoodhartWitness.stepMacro false q)
      CausalGoodhartWitness.π
  )
  ∧
(
    Viability.Kernel CausalGoodhartWitness.micro.passive
      CausalGoodhartWitness.guardS CausalGoodhartWitness.s₀
  )
  ∧
(
    Viability.Kernel CausalGoodhartWitness.macroSys.passive
      CausalGoodhartWitness.guardQ (CausalGoodhartWitness.π CausalGoodhartWitness.s₀)
  )
  ∧
(
    Viability.Kernel (CausalGoodhartWitness.macroSys.proc true)
        CausalGoodhartWitness.guardQ (CausalGoodhartWitness.π CausalGoodhartWitness.s₀) ∧
      (CausalGoodhartWitness.π CausalGoodhartWitness.s₀).toNat <
        (CausalGoodhartWitness.stepMacro true (CausalGoodhartWitness.π CausalGoodhartWitness.s₀)).toNat
  )
  ∧
(
    ∃ s₂,
      Trace (CausalGoodhartWitness.micro.proc true) CausalGoodhartWitness.s₀ [(), ()] s₂ ∧
        ¬CausalGoodhartWitness.guardS s₂ ∧ CausalGoodhartWitness.guardQ (CausalGoodhartWitness.π s₂)
  )
  ∧
(
    ∃ s₃,
      Trace (CausalGoodhartWitness.micro.proc true) CausalGoodhartWitness.s₀ [(), (), ()] s₃ ∧
        ¬CausalGoodhartWitness.guardQ (CausalGoodhartWitness.π s₃)
  )
  ∧
(
    ∀ (φ : Unit → Unit) (ω : Bool → Bool),
      ¬ExactCausalAbs CausalGoodhartWitness.micro CausalGoodhartWitness.macroSys CausalGoodhartWitness.π φ ω
  )
  ∧
(
    ∀ {ω : Bool → Bool} {σ : Nat → Nat},
      σ 0 = 0 →
        ∀
          (lc :
            LaxCausalAbs CausalGoodhartWitness.micro CausalGoodhartWitness.macroSys CausalGoodhartWitness.π ω σ
              CausalGoodhartWitness.levelDist),
          ¬(lc.Epoch 0 CausalGoodhartWitness.s₀ ∧ lc.α 0 = 0 ∧ lc.ε = 0)
  )
  ∧
(
    ∀ {ω : Bool → Bool}
      (lc :
        LaxCausalAbs CausalGoodhartWitness.micro CausalGoodhartWitness.macroSys CausalGoodhartWitness.π ω id
          CausalGoodhartWitness.levelDist),
      ¬((∀ (s : CausalGoodhartWitness.Level × CausalGoodhartWitness.Level), lc.Epoch 0 s) ∧ lc.α 0 + lc.ε ≤ 1)
  )) ∧
  ((
    ∀ (φ : Unit → Unit) (ω : Bool → Bool),
      ¬ExactCausalAbs PositiveCoupledFeedbackWitness.micro PositiveCoupledFeedbackWitness.macroSys
          PositiveCoupledFeedbackWitness.π φ ω
  )
  ∧
(
    ∀ (i : Bool) (s : Nat × Bool),
      distNat ((PositiveCoupledFeedbackWitness.nextMicro i s).fst / 2)
          (PositiveCoupledFeedbackWitness.nextMacro i (PositiveCoupledFeedbackWitness.π s)) ≤
        1
  )
  ∧
(
    Viability.Kernel
      (PositiveCoupledFeedbackWitness.micro.feedbackProcess fun s =>
        PositiveCoupledFeedbackWitness.κ (PositiveCoupledFeedbackWitness.π s))
      PositiveCoupledFeedbackWitness.guardS PositiveCoupledFeedbackWitness.s₀
  )
  ∧
(
    Viability.Kernel
      (PositiveCoupledFeedbackWitness.micro.scheduledProcess id fun _ => true)
      (fun ts => PositiveCoupledFeedbackWitness.guardS ts.snd) (0, PositiveCoupledFeedbackWitness.s₀)
  ))

/-- General CausalAbstraction & ActiveInquiryLoop impossibility theorems proposition. -/
def GeneralObstructionsProp : Prop :=
(∀ {J : Type} (D : CausalSystem Bool Confound.Move J) (_ : ∀ j, Determined (D.proc j))
       (ω : Unit → J),
       (∀ t, (Confound.run Confound.aligned).StepsThrough Confound.outcome Confound.moveDecides t) ∧
       ¬ ExactCausalAbs ⟨fun _ => Confound.process, ()⟩ D Confound.outcome id ω) ∧
     (∀ {S A I Q : Type} {C₁ : CausalSystem S A I} (C₂ : CausalSystem Q A Bool)
       {π : S → Q} {ω : I → Bool},
       C₂.obs = false → ω C₁.obs = false → (∃ j₀, ω j₀ = true) →
       ∀ (r : Run C₁.passive) {t : Nat} {k : Q} {a : A},
         (∃ P : Process Q A, Determined P ∧ r.StepsThrough π P t) →
         ¬ r.TakesThrough π t k a →
         Determined C₂.passive → Determined (C₂.proc true) →
         FactorsThrough C₁.passive π C₂.passive →
         ∀ {κ₁ κ₂ : Q}, κ₁ ≠ κ₂ → ¬ ∃ κ, r.FixesThrough π t k a κ) ∧
     (∀ {S R V : Type} {next : S → S} {reg : S → R} {val : S → V}
       (pred : List R → Option V) {r r' : Run (Law.process next)},
       Alike (Law.frameBy next reg) (Law.frameBy next reg) (r.state 0) (r'.state 0) →
       (∀ T, ∃ t, T ≤ t ∧ val (r.state t) ≠ val (r'.state t)) →
       ∀ (g : Nat → Run (Law.process next) → Option V),
       LearnableRuns.FixedThrough reg g →
       ¬ (LearnableRuns.Predicts reg val pred r ∧ LearnableRuns.Predicts reg val pred r') ∧
       ¬ (Learnable.Predicts next reg val pred (r.state 0) ∧
          Learnable.Predicts next reg val pred (r'.state 0)) ∧
       ¬ Limit.Tracks g (fun k run => some (val (run.state k)))) ∧
     (∀ {S A Θ P : Type} [DecidableEq Θ] {Proc : Process S A}
       (g : Nat → Run Proc → Option Θ) (H : Run Proc → Θ),
       Limit.Identifies g (fun r => some (H r)) →
       (∀ k (r r' : Run Proc), r.AgreeUpTo k r' → g k r = g k r') →
       ∀ {D : Nat} (r_benign r_frag : Run Proc),
       r_benign.AgreeUpTo D r_frag →
       ∀ (g_frag x_frag : Nat → Nat) (policy : Nat → Option Θ → P) (draw : P → Nat)
         {Y H_pre H_safe y_safe : Nat},
       (∀ t, x_frag (t + 1) = RegimeMargin.step g_frag (draw (policy t (g t r_frag))) (x_frag t)) →
       RegimeMargin.AtMost g_frag Y → Y < H_pre →
       RegimeMargin.Short g_frag H_safe y_safe →
       RegimeMargin.FromNothing g_frag → 0 < H_safe + y_safe →
       (∀ t, t < D → H_pre ≤ draw (policy t (g t r_benign))) →
       (∀ t, x_frag t < H_safe + y_safe → H_safe ≤ draw (policy t (g t r_frag))) →
       x_frag 0 < (H_safe + y_safe) + (H_pre - Y) * D →
       Limit.Verifies (Limit.says g (some (H r_benign))) (fun r => some (H r) = some (H r_benign)) ∧
       (∀ t, t ≤ D → g t r_frag = g t r_benign) ∧
       ∃ T, T ≤ D ∧ x_frag T < H_safe + y_safe ∧
         (x_frag (T + x_frag T) = 0 ∧ ∀ m, x_frag (T + x_frag T + m) = 0))

/-- ActiveInquiryLoop witness proposition. -/
def ActiveInquiryPanoramaProp : Prop :=
  ((
    ∀ (θ : Bool) (xs : Nat → Unit → Nat),
      (∀ (t : Nat),
          t < ActiveInquiryLoop.ActiveProbeWitness.spec.horizon →
            ∀ (site : Unit), ActiveInquiryLoop.ActiveProbeWitness.xCrit site ≤ xs t site) →
        ActiveInquiryLoop.ActiveProbeWitness.spec.infer
            (ActiveInquiryLoop.probeTranscript ActiveInquiryLoop.ActiveProbeWitness.world
              ActiveInquiryLoop.ActiveProbeWitness.spec.plan θ xs ActiveInquiryLoop.ActiveProbeWitness.spec.horizon) =
          θ
  )
  ∧
(
    ∀ (θ : Bool),
      Viability.Kernel
        (PolyComposition.polyClosedProcess
          (ActiveInquiryLoop.inquiryPolyComponent ActiveInquiryLoop.ActiveProbeWitness.spec) (fun _ site => [site])
          (ActiveInquiryLoop.inquiryContract ActiveInquiryLoop.ActiveProbeWitness.spec)
          (ActiveInquiryLoop.inquiryWorldObs ActiveInquiryLoop.ActiveProbeWitness.world
            ActiveInquiryLoop.ActiveProbeWitness.spec θ)
          ActiveInquiryLoop.ActiveProbeWitness.channel (ActiveInquiryLoop.ActiveProbeWitness.world.G θ)
          (ActiveInquiryLoop.ActiveProbeWitness.world.envDraw θ) ActiveInquiryLoop.ActiveProbeWitness.world.jointAdm)
        (PolyComposition.polyClosedGuard (ActiveInquiryLoop.inquiryPolyComponent ActiveInquiryLoop.ActiveProbeWitness.spec)
          (ActiveInquiryLoop.inquiryContract ActiveInquiryLoop.ActiveProbeWitness.spec)
          ActiveInquiryLoop.ActiveProbeWitness.xCrit)
        (ActiveInquiryLoop.ActiveProbeWitness.xStart20,
          ActiveInquiryLoop.inquiryInit ActiveInquiryLoop.ActiveProbeWitness.spec)
  )
  ∧
(
    ActiveInquiryLoop.ActiveProbeWitness.passiveFragOrbit
        17 =
      0
  )
  ∧
(
    (ActiveInquiryLoop.ActiveProbeWitness.lowProbeFragOrbit
          4).snd =
      0
  )
  ∧
(
    ∀ (n : Nat),
      Law.orbit (RegimeMargin.step (ActiveInquiryLoop.ActiveProbeWitness.gRegime false) 2) 9 n = 9
  )) ∧
  ((
    ¬Viability.Kernel
        (OpenComposition.closedProcess
          (OpenComposition.composeListComponent ActiveInquiryLoop.CascadePoolWitness.memberComp 0 [1, 2])
          (OpenComposition.composeListContract ActiveInquiryLoop.CascadePoolWitness.memberContract 0 [1, 2])
          (ActiveInquiryLoop.cascadeListObs ActiveInquiryLoop.CascadePoolWitness.cascadeTurns 0 [1, 2])
          ActiveInquiryLoop.CascadePoolWitness.channel ActiveInquiryLoop.CascadePoolWitness.gPool (fun _ _ => 0) fun _ =>
          True)
        (OpenComposition.closedGuard
          (OpenComposition.composeListComponent ActiveInquiryLoop.CascadePoolWitness.memberComp 0 [1, 2])
          (OpenComposition.composeListContract ActiveInquiryLoop.CascadePoolWitness.memberContract 0 [1, 2])
          ActiveInquiryLoop.CascadePoolWitness.xCrit)
        (ActiveInquiryLoop.CascadePoolWitness.xStart, OpenComposition.composeListInit (fun _ => 1) 0 [1, 2])
  )
  ∧
(
    Viability.Kernel
      (OpenComposition.closedProcess
        (OpenComposition.composeListComponent ActiveInquiryLoop.CascadePoolWitness.memberComp 0 [1, 2])
        (OpenComposition.composeListContract ActiveInquiryLoop.CascadePoolWitness.memberContract 0 [1, 2])
        (ActiveInquiryLoop.independentListObs ActiveInquiryLoop.CascadePoolWitness.cascadeTurns 0 [1, 2])
        ActiveInquiryLoop.CascadePoolWitness.channel ActiveInquiryLoop.CascadePoolWitness.gPool (fun _ _ => 0) fun _ =>
        True)
      (OpenComposition.closedGuard
        (OpenComposition.composeListComponent ActiveInquiryLoop.CascadePoolWitness.memberComp 0 [1, 2])
        (OpenComposition.composeListContract ActiveInquiryLoop.CascadePoolWitness.memberContract 0 [1, 2])
        ActiveInquiryLoop.CascadePoolWitness.xCrit)
      (ActiveInquiryLoop.CascadePoolWitness.xStart, OpenComposition.composeListInit (fun _ => 1) 0 [1, 2])
  )) ∧
  ((
    (∀ (t : Nat),
        t ≤ 2 →
          ActiveInquiryLoop.DelayObstructionWitness.readRelayStep (TimedResponse.Relay.web true).level t =
            ActiveInquiryLoop.DelayObstructionWitness.readRelayStep (TimedResponse.Relay.web false).level t) ∧
      ¬Viability.Kernel
          (PolyComposition.polyClosedProcess
            (ActiveInquiryLoop.clockedPolyComponent ActiveInquiryLoop.DelayObstructionWitness.relayComp) (fun _ e => [e])
            (ActiveInquiryLoop.clockedPolyContract ActiveInquiryLoop.DelayObstructionWitness.relayContract)
            (fun t _ => ActiveInquiryLoop.DelayObstructionWitness.readRelayStep (TimedResponse.Relay.web true).level t)
            ActiveInquiryLoop.DelayObstructionWitness.channel ActiveInquiryLoop.DelayObstructionWitness.gDelay
            (fun _ _ => 0) fun _ => True)
          (PolyComposition.polyClosedGuard
            (ActiveInquiryLoop.clockedPolyComponent ActiveInquiryLoop.DelayObstructionWitness.relayComp)
            (ActiveInquiryLoop.clockedPolyContract ActiveInquiryLoop.DelayObstructionWitness.relayContract)
            ActiveInquiryLoop.DelayObstructionWitness.xCrit)
          (ActiveInquiryLoop.DelayObstructionWitness.xStart, ⟨0, 1⟩)
  )
  ∧
(
    Viability.Kernel
      (OpenComposition.closedProcess ActiveInquiryLoop.DelayObstructionWitness.relayComp
        ActiveInquiryLoop.DelayObstructionWitness.relayContract (fun x => (x ()).blt 8)
        ActiveInquiryLoop.DelayObstructionWitness.channel ActiveInquiryLoop.DelayObstructionWitness.gDelay (fun _ _ => 0)
        fun _ => True)
      (OpenComposition.closedGuard ActiveInquiryLoop.DelayObstructionWitness.relayComp
        ActiveInquiryLoop.DelayObstructionWitness.relayContract ActiveInquiryLoop.DelayObstructionWitness.xCrit)
      (ActiveInquiryLoop.DelayObstructionWitness.xStart, 1)
  )) ∧
  ((
    let obs : (Unit → Nat) → Bool := fun x =>
      decide (0 < (Thresholds.Draw.law 5).give 0 () (fun _ e => if e = true then x () else 0) false);
    (∀ (h : Unit) (cc : Bool) (s t_ev : Nat),
        false = false →
          ¬(Thresholds.Draw.law 5).RespondsByLevel (ActiveInquiryLoop.ThresholdBlindnessWitness.netWeb 5 0) t_ev h cc s
              true) ∧
      ¬Viability.Kernel
          (OpenComposition.closedProcess ActiveInquiryLoop.ThresholdBlindnessWitness.threshComp
            ActiveInquiryLoop.ThresholdBlindnessWitness.threshContract obs
            ActiveInquiryLoop.ThresholdBlindnessWitness.channel ActiveInquiryLoop.ThresholdBlindnessWitness.gThresh
            (fun _ _ => 0) fun _ => True)
          (OpenComposition.closedGuard ActiveInquiryLoop.ThresholdBlindnessWitness.threshComp
            ActiveInquiryLoop.ThresholdBlindnessWitness.threshContract ActiveInquiryLoop.ThresholdBlindnessWitness.xCrit)
          (ActiveInquiryLoop.ThresholdBlindnessWitness.xStart, 1)
  )
  ∧
(
    ¬Viability.Kernel
        (OpenComposition.closedProcess ActiveInquiryLoop.ThresholdBlindnessWitness.threshComp
          ActiveInquiryLoop.ThresholdBlindnessWitness.threshContract (fun x => Nat.ble 8 (x ()))
          ActiveInquiryLoop.ThresholdBlindnessWitness.channel ActiveInquiryLoop.ThresholdBlindnessWitness.gThresh
          (fun _ _ => 0) fun _ => True)
        (OpenComposition.closedGuard ActiveInquiryLoop.ThresholdBlindnessWitness.threshComp
          ActiveInquiryLoop.ThresholdBlindnessWitness.threshContract ActiveInquiryLoop.ThresholdBlindnessWitness.xCrit)
        (ActiveInquiryLoop.ThresholdBlindnessWitness.xStart, 1)
  )
  ∧
(
    Viability.Kernel
      (OpenComposition.closedProcess ActiveInquiryLoop.ThresholdBlindnessWitness.threshComp
        ActiveInquiryLoop.ThresholdBlindnessWitness.threshContract (fun x => Nat.ble 10 (x ()))
        ActiveInquiryLoop.ThresholdBlindnessWitness.channel ActiveInquiryLoop.ThresholdBlindnessWitness.gThresh
        (fun _ _ => 0) fun _ => True)
      (OpenComposition.closedGuard ActiveInquiryLoop.ThresholdBlindnessWitness.threshComp
        ActiveInquiryLoop.ThresholdBlindnessWitness.threshContract ActiveInquiryLoop.ThresholdBlindnessWitness.xCrit)
      (ActiveInquiryLoop.ThresholdBlindnessWitness.xStart, 1)
  )) ∧
  ((
    BlanketCouplings.BlanketDetermined
        (BlanketCouplings.liftedClosedProcess
          ((ActiveInquiryLoop.componentOfBlanket ActiveInquiryLoop.SparseRelayBreachWitness.sp₁).compose
            (ActiveInquiryLoop.componentOfBlanket ActiveInquiryLoop.SparseRelayBreachWitness.sp₂))
          (OpenComposition.composeContract
            (ActiveInquiryLoop.contractOfBlanket ActiveInquiryLoop.SparseRelayBreachWitness.sp₁)
            (ActiveInquiryLoop.contractOfBlanket ActiveInquiryLoop.SparseRelayBreachWitness.sp₂))
          (fun x => (false, (x ()).blt 9)) ActiveInquiryLoop.SparseRelayBreachWitness.channel
          ActiveInquiryLoop.SparseRelayBreachWitness.gDelay (fun _ _ => 0) fun _ => True) ∧
      Viability.Kernel
        (OpenComposition.closedProcess
          ((ActiveInquiryLoop.componentOfBlanket ActiveInquiryLoop.SparseRelayBreachWitness.sp₁).compose
            (ActiveInquiryLoop.componentOfBlanket ActiveInquiryLoop.SparseRelayBreachWitness.sp₂))
          (OpenComposition.composeContract
            (ActiveInquiryLoop.contractOfBlanket ActiveInquiryLoop.SparseRelayBreachWitness.sp₁)
            (ActiveInquiryLoop.contractOfBlanket ActiveInquiryLoop.SparseRelayBreachWitness.sp₂))
          (fun x => (false, (x ()).blt 9)) ActiveInquiryLoop.SparseRelayBreachWitness.channel
          ActiveInquiryLoop.SparseRelayBreachWitness.gDelay (fun _ _ => 0) fun _ => True)
        (OpenComposition.closedGuard
          ((ActiveInquiryLoop.componentOfBlanket ActiveInquiryLoop.SparseRelayBreachWitness.sp₁).compose
            (ActiveInquiryLoop.componentOfBlanket ActiveInquiryLoop.SparseRelayBreachWitness.sp₂))
          (OpenComposition.composeContract
            (ActiveInquiryLoop.contractOfBlanket ActiveInquiryLoop.SparseRelayBreachWitness.sp₁)
            (ActiveInquiryLoop.contractOfBlanket ActiveInquiryLoop.SparseRelayBreachWitness.sp₂))
          ActiveInquiryLoop.SparseRelayBreachWitness.xCrit)
        (ActiveInquiryLoop.SparseRelayBreachWitness.xStart,
          (ActiveInquiryLoop.SparseRelayBreachWitness.sp₁.initI, ActiveInquiryLoop.SparseRelayBreachWitness.sp₁.initA),
          ActiveInquiryLoop.SparseRelayBreachWitness.sp₂.initI, ActiveInquiryLoop.SparseRelayBreachWitness.sp₂.initA)
  )
  ∧
(
    ¬BlanketCouplings.BlanketDetermined
          ActiveInquiryLoop.SparseRelayBreachWitness.breachProcess ∧
      ¬∃ (b : Blanket.Blanketed Unit Bool Nat Bool),
          ∀ (p : Blanket.Parts Unit Bool Nat Bool) (m : Unit) (q : Blanket.Parts Unit Bool Nat Bool),
            ActiveInquiryLoop.SparseRelayBreachWitness.breachProcess.step p m q → q = b.step p
  )
  ∧
(
    Law.orbit
        ActiveInquiryLoop.SparseRelayBreachWitness.breachSubstrateStep 9 4 =
      0
  ))

/-- EndogenousOrder witness proposition. -/
def EndogenousOrderPanoramaProp {Pos F : Type} (_p : Pos) (_f : F) : Prop :=
  ((
    (∀ (t : Nat),
          3 ≤ t →
            Weighting.IncreasingInOwn EndogenousOrder.OnlineWeightWitness.owItems EndogenousOrder.OnlineWeightWitness.owOwn
              (EndogenousOrder.OnlineWeightWitness.owUpdater.ranksAt EndogenousOrder.OnlineWeightWitness.feedbackAll t)) ∧
        (∀ (t : Nat),
            EndogenousOrder.OnlineWeightWitness.owUpdater.posAt EndogenousOrder.OnlineWeightWitness.feedbackAll t
                EndogenousOrder.OnlineWeightWitness.OWItem.victim =
              0) ∧
          (∀ (t : Nat),
              ¬EndogenousOrder.OnlineWeightWitness.owUpdater.ranksAt EndogenousOrder.OnlineWeightWitness.feedbackAll t
                    EndogenousOrder.OnlineWeightWitness.cVictim EndogenousOrder.OnlineWeightWitness.cNone ∧
                ¬EndogenousOrder.OnlineWeightWitness.owUpdater.ranksAt EndogenousOrder.OnlineWeightWitness.feedbackAll t
                    EndogenousOrder.OnlineWeightWitness.cNone EndogenousOrder.OnlineWeightWitness.cVictim) ∧
            (Weighting.IncreasingInOwnOn
                  (fun a b =>
                    ∀ (z : EndogenousOrder.OnlineWeightWitness.OWItem),
                      z ∈ EndogenousOrder.OnlineWeightWitness.owItems →
                        EndogenousOrder.OnlineWeightWitness.owProbe z = false → a z = b z)
                  EndogenousOrder.OnlineWeightWitness.owItems EndogenousOrder.OnlineWeightWitness.owOwn
                  (EndogenousOrder.OnlineWeightWitness.owUpdater.ranksAt EndogenousOrder.OnlineWeightWitness.feedbackPartial
                    2) ∧
                (∀ (t : Nat),
                    EndogenousOrder.OnlineWeightWitness.owUpdater.ranksAt
                        EndogenousOrder.OnlineWeightWitness.feedbackPartial t EndogenousOrder.OnlineWeightWitness.cOff
                        EndogenousOrder.OnlineWeightWitness.cNone ∧
                      ¬EndogenousOrder.OnlineWeightWitness.owUpdater.ranksAt
                          EndogenousOrder.OnlineWeightWitness.feedbackPartial t EndogenousOrder.OnlineWeightWitness.cNone
                          EndogenousOrder.OnlineWeightWitness.cOff) ∧
                  ¬Weighting.IncreasingInOwn EndogenousOrder.OnlineWeightWitness.owItems
                      EndogenousOrder.OnlineWeightWitness.owOwn
                      (EndogenousOrder.OnlineWeightWitness.owUpdater.ranksAt
                        EndogenousOrder.OnlineWeightWitness.feedbackPartial 2)) ∧
              (∃ P,
                  (∀ (x : EndogenousOrder.OnlineWeightWitness.OWItem → Bool), ¬P x x) ∧
                    (∀ (x y z : EndogenousOrder.OnlineWeightWitness.OWItem → Bool), P x y → P y z → P x z) ∧
                      EndogenousOrder.OnlineWeightWitness.owTrace.Accords P ∧
                        (Weighting.IncreasingInOwnOn EndogenousOrder.OnlineWeightWitness.owTrace.Met
                            EndogenousOrder.OnlineWeightWitness.owItems EndogenousOrder.OnlineWeightWitness.owOwn fun y x =>
                            P x y) ∧
                          P EndogenousOrder.OnlineWeightWitness.cNone EndogenousOrder.OnlineWeightWitness.cOff ∧
                            ¬Weighting.IncreasingInOwn EndogenousOrder.OnlineWeightWitness.owItems
                                EndogenousOrder.OnlineWeightWitness.owOwn fun y x => P x y) ∧
                ¬∀ (d : EndogenousOrder.OrderUpdater EndogenousOrder.OnlineWeightWitness.OWItem)
                    (sig : Pos → Nat → F → Prop),
                    (∀ (t : Nat),
                        d.posAt EndogenousOrder.OnlineWeightWitness.feedbackAll t
                            EndogenousOrder.OnlineWeightWitness.OWItem.victim =
                          0) →
                      Unrestricted sig
  )
  ∧
(
    ∀ (H : Nat),
      (∀ (t : Nat),
          EndogenousOrder.OnlineWeightWitness.OWPersist.web.stock EndogenousOrder.OnlineWeightWitness.OWPersist.owNodes t =
            2) ∧
        (∀ (items : List (Nat × EndogenousOrder.OnlineWeightWitness.OWPersist.OWNode)),
            ¬EndogenousOrder.OnlineWeightWitness.OWPersist.web.ListsAdmitted items
                EndogenousOrder.OnlineWeightWitness.OWPersist.web.level) ∧
          TransformsViably EndogenousOrder.OnlineWeightWitness.OWPersist.web
              (fun t =>
                1 ≤
                  EndogenousOrder.OnlineWeightWitness.OWPersist.web.level t
                    EndogenousOrder.OnlineWeightWitness.OWPersist.OWNode.cPool)
              EndogenousOrder.OnlineWeightWitness.OWPersist.cap 0 ∧
            (∀ (w : Nat × EndogenousOrder.OnlineWeightWitness.OWPersist.OWNode → Nat),
                Weighting.Positive (EndogenousOrder.horizonPairs H EndogenousOrder.OnlineWeightWitness.OWPersist.owNodes)
                    w →
                  Weighting.weighed (EndogenousOrder.horizonPairs H EndogenousOrder.OnlineWeightWitness.OWPersist.owNodes) w
                      (EndogenousOrder.boundedAdmittedBool H EndogenousOrder.OnlineWeightWitness.OWPersist.admitDec
                        fun _ _ => 0) <
                    Weighting.weighed (EndogenousOrder.horizonPairs H EndogenousOrder.OnlineWeightWitness.OWPersist.owNodes)
                      w
                      (EndogenousOrder.boundedAdmittedBool H EndogenousOrder.OnlineWeightWitness.OWPersist.admitDec
                        EndogenousOrder.OnlineWeightWitness.OWPersist.web.level)) ∧
              ∀ (w : Nat × EndogenousOrder.OnlineWeightWitness.OWPersist.OWMacro → Nat),
                Weighting.Positive (EndogenousOrder.horizonPairs H EndogenousOrder.OnlineWeightWitness.OWPersist.owMacros)
                    w →
                  Weighting.weighed (EndogenousOrder.horizonPairs H EndogenousOrder.OnlineWeightWitness.OWPersist.owMacros)
                      w
                      (EndogenousOrder.boundedMacroBool H EndogenousOrder.OnlineWeightWitness.OWPersist.macroDec
                        fun _ _ => 0) <
                    Weighting.weighed
                      (EndogenousOrder.horizonPairs H EndogenousOrder.OnlineWeightWitness.OWPersist.owMacros) w
                      (EndogenousOrder.boundedMacroBool H EndogenousOrder.OnlineWeightWitness.OWPersist.macroDec
                        EndogenousOrder.OnlineWeightWitness.OWPersist.web.level)
  )) ∧
  ((
    SelectionTerm.concord
          (SelectionLevels.whole EndogenousOrder.ScopeCoEvolutionWitness.AssortmentSplit.gsAssorted)
          EndogenousOrder.ScopeCoEvolutionWitness.AssortmentSplit.wAssorted
          EndogenousOrder.ScopeCoEvolutionWitness.AssortmentSplit.keepScope =
        8 ∧
      SelectionTerm.discord (SelectionLevels.whole EndogenousOrder.ScopeCoEvolutionWitness.AssortmentSplit.gsAssorted)
            EndogenousOrder.ScopeCoEvolutionWitness.AssortmentSplit.wAssorted
            EndogenousOrder.ScopeCoEvolutionWitness.AssortmentSplit.keepScope =
          0 ∧
        SelectionTerm.concord (SelectionLevels.whole EndogenousOrder.ScopeCoEvolutionWitness.AssortmentSplit.gsMixed)
              EndogenousOrder.ScopeCoEvolutionWitness.AssortmentSplit.wMixed
              EndogenousOrder.ScopeCoEvolutionWitness.AssortmentSplit.keepScope =
            0 ∧
          SelectionTerm.discord (SelectionLevels.whole EndogenousOrder.ScopeCoEvolutionWitness.AssortmentSplit.gsMixed)
                EndogenousOrder.ScopeCoEvolutionWitness.AssortmentSplit.wMixed
                EndogenousOrder.ScopeCoEvolutionWitness.AssortmentSplit.keepScope =
              8 ∧
            SelectionTerm.discord (SelectionLevels.whole EndogenousOrder.ScopeCoEvolutionWitness.AssortmentSplit.gsAssorted)
                  EndogenousOrder.ScopeCoEvolutionWitness.AssortmentSplit.wAssorted
                  EndogenousOrder.ScopeCoEvolutionWitness.AssortmentSplit.keepScope <
                SelectionTerm.concord
                  (SelectionLevels.whole EndogenousOrder.ScopeCoEvolutionWitness.AssortmentSplit.gsAssorted)
                  EndogenousOrder.ScopeCoEvolutionWitness.AssortmentSplit.wAssorted
                  EndogenousOrder.ScopeCoEvolutionWitness.AssortmentSplit.keepScope ∧
              SelectionTerm.concord (SelectionLevels.whole EndogenousOrder.ScopeCoEvolutionWitness.AssortmentSplit.gsMixed)
                  EndogenousOrder.ScopeCoEvolutionWitness.AssortmentSplit.wMixed
                  EndogenousOrder.ScopeCoEvolutionWitness.AssortmentSplit.keepScope <
                SelectionTerm.discord
                  (SelectionLevels.whole EndogenousOrder.ScopeCoEvolutionWitness.AssortmentSplit.gsMixed)
                  EndogenousOrder.ScopeCoEvolutionWitness.AssortmentSplit.wMixed
                  EndogenousOrder.ScopeCoEvolutionWitness.AssortmentSplit.keepScope
  )
  ∧
(
    (SelectionTerm.discord
            (SelectionLevels.whole EndogenousOrder.ScopeCoEvolutionWitness.AssortmentSplit.gsAssorted)
            EndogenousOrder.ScopeCoEvolutionWitness.AssortmentSplit.wAssorted
            EndogenousOrder.ScopeCoEvolutionWitness.AssortmentSplit.keepScope <
          SelectionTerm.concord (SelectionLevels.whole EndogenousOrder.ScopeCoEvolutionWitness.AssortmentSplit.gsAssorted)
            EndogenousOrder.ScopeCoEvolutionWitness.AssortmentSplit.wAssorted
            EndogenousOrder.ScopeCoEvolutionWitness.AssortmentSplit.keepScope ∧
        EndogenousOrder.ScopeCoEvolutionWitness.AssortmentLineage.linGen.Raises 0 ∧
          (∀ (k : Nat) (y : ScopeDynamics.MutualFateWitness.LineageNode),
              ¬y ∈
                  ScopeDynamics.MutualFateWitness.system.narrowLin.G.family
                    (ScopeDynamics.MutualFateWitness.system.narrowLin.T +
                          ScopeDynamics.MutualFateWitness.system.narrowLin.n +
                        k +
                      1)) ∧
            ∀ (s' : Nat),
              ScopeDynamics.MutualFateWitness.system.wide.S_safe ≤
                  ScopeDynamics.MutualFateWitness.system.wide.sub.level s' ∧
                ScopeDynamics.MutualFateWitness.system.wide.sub.level s' ≤ ScopeDynamics.MutualFateWitness.system.wide.hi) ∧
      SelectionTerm.concord (SelectionLevels.whole EndogenousOrder.ScopeCoEvolutionWitness.AssortmentSplit.gsMixed)
            EndogenousOrder.ScopeCoEvolutionWitness.AssortmentSplit.wMixed
            EndogenousOrder.ScopeCoEvolutionWitness.AssortmentSplit.keepScope <
          SelectionTerm.discord (SelectionLevels.whole EndogenousOrder.ScopeCoEvolutionWitness.AssortmentSplit.gsMixed)
            EndogenousOrder.ScopeCoEvolutionWitness.AssortmentSplit.wMixed
            EndogenousOrder.ScopeCoEvolutionWitness.AssortmentSplit.keepScope ∧
        (∃ T_end,
            (∀ (t : Nat), T_end ≤ t → ScopeDynamics.MutualFateWitness.system.narrow.sub.level t = 0) ∧
              ∀ (t : Nat),
                T_end ≤ t →
                  ∀ (k : ScopeDynamics.PoolCap),
                    ¬ScopeDynamics.MutualFateWitness.system.narrow.W.MacroAdmits
                        ScopeDynamics.MutualFateWitness.system.narrow.cap
                        (ScopeDynamics.MutualFateWitness.system.narrow.W.level t) t k) ∧
          ∀ (k : Nat) (y : ScopeDynamics.MutualFateWitness.LineageNode),
            ¬y ∈
                ScopeDynamics.MutualFateWitness.system.narrowLin.G.family
                  (ScopeDynamics.MutualFateWitness.system.narrowLin.T + ScopeDynamics.MutualFateWitness.system.narrowLin.n +
                      k +
                    1)
  )
  ∧
(
    ((EndogenousOrder.ScopeCoEvolutionWitness.LagSplit.timelyRun.state
                0).fst
            () =
          13 ∧
        (∀ (t : Nat),
            1 ≤ t →
              (EndogenousOrder.ScopeCoEvolutionWitness.LagSplit.timelyRun.state t).fst () = 11 ∧
                8 ≤ (EndogenousOrder.ScopeCoEvolutionWitness.LagSplit.timelyRun.state t).fst ()) ∧
          ∀ (t : Nat), 8 ≤ (EndogenousOrder.ScopeCoEvolutionWitness.LagSplit.timelyRun.state t).fst ()) ∧
      ((EndogenousOrder.ScopeCoEvolutionWitness.LagSplit.delayedOrbit 0).fst () = 13 ∧
          (EndogenousOrder.ScopeCoEvolutionWitness.LagSplit.delayedOrbit 1).fst () = 11 ∧
            (EndogenousOrder.ScopeCoEvolutionWitness.LagSplit.delayedOrbit 2).fst () = 9 ∧
              (EndogenousOrder.ScopeCoEvolutionWitness.LagSplit.delayedOrbit 3).fst () = 6 ∧
                (EndogenousOrder.ScopeCoEvolutionWitness.LagSplit.delayedOrbit 3).fst () < 8 ∧
                  (EndogenousOrder.ScopeCoEvolutionWitness.LagSplit.delayedOrbit 4).fst () = 5 ∧
                    (EndogenousOrder.ScopeCoEvolutionWitness.LagSplit.delayedOrbit 5).fst () = 4 ∧
                      (EndogenousOrder.ScopeCoEvolutionWitness.LagSplit.delayedOrbit 6).fst () = 2 ∧
                        ∀ (t : Nat), 7 ≤ t → (EndogenousOrder.ScopeCoEvolutionWitness.LagSplit.delayedOrbit t).fst () = 0) ∧
        EndogenousOrder.ScopeCoEvolutionWitness.LagSplit.unswitchedNarrowLevel 0 = 13 ∧
          EndogenousOrder.ScopeCoEvolutionWitness.LagSplit.unswitchedNarrowLevel 1 = 11 ∧
            EndogenousOrder.ScopeCoEvolutionWitness.LagSplit.unswitchedNarrowLevel 2 = 9 ∧
              EndogenousOrder.ScopeCoEvolutionWitness.LagSplit.unswitchedNarrowLevel 3 = 6 ∧
                EndogenousOrder.ScopeCoEvolutionWitness.LagSplit.unswitchedNarrowLevel 4 = 2 ∧
                  ∀ (t : Nat), 5 ≤ t → EndogenousOrder.ScopeCoEvolutionWitness.LagSplit.unswitchedNarrowLevel t = 0
  )) ∧
  (Weighting.WidensOn
    EndogenousOrder.CourseNashObstructionWitness.nashActs EndogenousOrder.CourseNashObstructionWitness.wideMenu
    EndogenousOrder.CourseNashObstructionWitness.narrowMenu ∧
  (∀ (x y : EndogenousOrder.CourseNashObstructionWitness.NashAct),
      EndogenousOrder.PureNash EndogenousOrder.CourseNashObstructionWitness.ungatedRealization.rank₁
          EndogenousOrder.CourseNashObstructionWitness.ungatedRealization.rank₂
          EndogenousOrder.CourseNashObstructionWitness.narrowMenu
          EndogenousOrder.CourseNashObstructionWitness.narrowMenu x y ↔
        x = EndogenousOrder.CourseNashObstructionWitness.NashAct.restrain ∧
          y = EndogenousOrder.CourseNashObstructionWitness.NashAct.restrain) ∧
    (∀ (x y : EndogenousOrder.CourseNashObstructionWitness.NashAct),
        EndogenousOrder.PureNash EndogenousOrder.CourseNashObstructionWitness.ungatedRealization.rank₁
            EndogenousOrder.CourseNashObstructionWitness.ungatedRealization.rank₂
            EndogenousOrder.CourseNashObstructionWitness.wideMenu EndogenousOrder.CourseNashObstructionWitness.wideMenu
            x y ↔
          x = EndogenousOrder.CourseNashObstructionWitness.NashAct.overdraw ∧
            y = EndogenousOrder.CourseNashObstructionWitness.NashAct.overdraw) ∧
      EndogenousOrder.CourseNashObstructionWitness.ungatedRealization.rank₁
            EndogenousOrder.CourseNashObstructionWitness.NashAct.overdraw
            EndogenousOrder.CourseNashObstructionWitness.NashAct.overdraw =
          5 ∧
        EndogenousOrder.CourseNashObstructionWitness.ungatedRealization.rank₁
              EndogenousOrder.CourseNashObstructionWitness.NashAct.restrain
              EndogenousOrder.CourseNashObstructionWitness.NashAct.restrain =
            6 ∧
          EndogenousOrder.CourseNashObstructionWitness.ungatedRealization.rank₁
                EndogenousOrder.CourseNashObstructionWitness.NashAct.overdraw
                EndogenousOrder.CourseNashObstructionWitness.NashAct.overdraw <
              EndogenousOrder.CourseNashObstructionWitness.ungatedRealization.rank₁
                EndogenousOrder.CourseNashObstructionWitness.NashAct.restrain
                EndogenousOrder.CourseNashObstructionWitness.NashAct.restrain ∧
            EndogenousOrder.CourseNashObstructionWitness.ungatedRealization.rank₂
                  EndogenousOrder.CourseNashObstructionWitness.NashAct.overdraw
                  EndogenousOrder.CourseNashObstructionWitness.NashAct.overdraw <
                EndogenousOrder.CourseNashObstructionWitness.ungatedRealization.rank₂
                  EndogenousOrder.CourseNashObstructionWitness.NashAct.restrain
                  EndogenousOrder.CourseNashObstructionWitness.NashAct.restrain ∧
              (∀ (t : Nat),
                  1 ≤ t →
                    ¬(EndogenousOrder.CourseNashObstructionWitness.gatedRealization.web
                            EndogenousOrder.CourseNashObstructionWitness.NashAct.overdraw
                            EndogenousOrder.CourseNashObstructionWitness.NashAct.restrain).Admits
                        ((EndogenousOrder.CourseNashObstructionWitness.gatedRealization.web
                              EndogenousOrder.CourseNashObstructionWitness.NashAct.overdraw
                              EndogenousOrder.CourseNashObstructionWitness.NashAct.restrain).level
                          t)
                        t EndogenousOrder.CourseNashObstructionWitness.NashForm.f1) ∧
                (∀ (x y : EndogenousOrder.CourseNashObstructionWitness.NashAct),
                    EndogenousOrder.PureNash EndogenousOrder.CourseNashObstructionWitness.gatedRealization.rank₁
                        EndogenousOrder.CourseNashObstructionWitness.gatedRealization.rank₂
                        EndogenousOrder.CourseNashObstructionWitness.wideMenu
                        EndogenousOrder.CourseNashObstructionWitness.wideMenu x y ↔
                      x = EndogenousOrder.CourseNashObstructionWitness.NashAct.restrain ∧
                        y = EndogenousOrder.CourseNashObstructionWitness.NashAct.restrain) ∧
                  ∀ (t : Nat),
                    (EndogenousOrder.CourseNashObstructionWitness.ocRun.state t).fst () =
                        (EndogenousOrder.CourseNashObstructionWitness.gatedRealization.web
                              EndogenousOrder.CourseNashObstructionWitness.NashAct.overdraw
                              EndogenousOrder.CourseNashObstructionWitness.NashAct.restrain).level
                          t EndogenousOrder.CourseNashObstructionWitness.NashCond.cPool ∧
                      4 ≤ (EndogenousOrder.CourseNashObstructionWitness.ocRun.state t).fst ()) ∧
  ((∀ (t : Nat),
    3 ≤ t →
      Weighting.IncreasingInOwn EndogenousOrder.EndogenousFirewallWitness.system.updater.items
        EndogenousOrder.EndogenousFirewallWitness.system.updater.own
        (EndogenousOrder.EndogenousFirewallWitness.system.updater.ranksAt
          EndogenousOrder.EndogenousFirewallWitness.system.feedback t)) ∧
  (∀ (t : Nat),
      EndogenousOrder.EndogenousFirewallWitness.system.updater.posAt
          EndogenousOrder.EndogenousFirewallWitness.system.feedback t
          EndogenousOrder.OnlineWeightWitness.OWItem.victim =
        0) ∧
    (∀ (x y : EndogenousOrder.CourseNashObstructionWitness.NashAct),
        EndogenousOrder.PureNash EndogenousOrder.EndogenousFirewallWitness.system.realization.rank₁
            EndogenousOrder.EndogenousFirewallWitness.system.realization.rank₂
            EndogenousOrder.EndogenousFirewallWitness.system.wideMenu
            EndogenousOrder.EndogenousFirewallWitness.system.wideMenu x y ↔
          x = EndogenousOrder.CourseNashObstructionWitness.NashAct.restrain ∧
            y = EndogenousOrder.CourseNashObstructionWitness.NashAct.restrain) ∧
      Rival (bounded EndogenousOrder.EndogenousFirewallWitness.firewallRegion) ∧
        ¬Unrestricted (bounded EndogenousOrder.EndogenousFirewallWitness.firewallRegion) ∧
          (Clearing.valuation.Held ∧ ¬Clearing.valuation.Significant) ∧
            ¬∀
                (sys' :
                  EndogenousOrder.EndogenousOrderSystem EndogenousOrder.OnlineWeightWitness.OWItem
                    EndogenousOrder.ScopeMode EndogenousOrder.ScopeS EndogenousOrder.ScopeObs EndogenousOrder.ScopeDist
                    EndogenousOrder.ScopeInt EndogenousOrder.ScopeExt Unit Unit
                    EndogenousOrder.CourseNashObstructionWitness.NashAct
                    EndogenousOrder.CourseNashObstructionWitness.NashForm
                    EndogenousOrder.CourseNashObstructionWitness.NashCond)
                (sig : Clearing.Formation → Nat → EndogenousOrder.OnlineWeightWitness.OWItem → Prop),
                (∀ (t : Nat),
                    sys'.updater.posAt sys'.feedback t EndogenousOrder.OnlineWeightWitness.OWItem.victim = 0) →
                  Unrestricted sig)

/-- EvolutionaryDrawdown witness proposition. -/
def EvolutionaryDrawdownPanoramaProp : Prop :=
  ((
    (EvolutionaryDrawdown.DerivedEmbodiedDrawWitness.surplusGen.size
              1 *
            1 ≤
          EvolutionaryDrawdown.DerivedEmbodiedDrawWitness.surplusFlow.uptake
            [EvolutionaryDrawdown.DerivedEmbodiedDrawWitness.Locus.pool] 0 ∧
        EvolutionaryDrawdown.DerivedEmbodiedDrawWitness.surplusGen.size 2 * 1 ≤
            EvolutionaryDrawdown.DerivedEmbodiedDrawWitness.surplusFlow.uptake
              [EvolutionaryDrawdown.DerivedEmbodiedDrawWitness.Locus.pool] 1 ∧
          EvolutionaryDrawdown.DerivedEmbodiedDrawWitness.surplusGen.size 3 * 1 ≤
            EvolutionaryDrawdown.DerivedEmbodiedDrawWitness.surplusFlow.uptake
              [EvolutionaryDrawdown.DerivedEmbodiedDrawWitness.Locus.pool] 2) ∧
      (EvolutionaryDrawdown.DerivedEmbodiedDrawWitness.surplusGen.size 1 <
            EvolutionaryDrawdown.DerivedEmbodiedDrawWitness.surplusGen.size 2 ∧
          EvolutionaryDrawdown.DerivedEmbodiedDrawWitness.surplusGen.size 2 <
            EvolutionaryDrawdown.DerivedEmbodiedDrawWitness.surplusGen.size 3) ∧
        (¬∀ (t : Nat),
              t ≤
                  1 + (1 + 1) +
                    EvolutionaryDrawdown.DerivedEmbodiedDrawWitness.surplusWeb.stock
                      [EvolutionaryDrawdown.DerivedEmbodiedDrawWitness.Locus.pool] (1 + (1 + 1)) →
                (∀ (p : EvolutionaryDrawdown.DerivedEmbodiedDrawWitness.Locus),
                    p ∈ EvolutionaryDrawdown.DerivedEmbodiedDrawWitness.surplusGen.family t →
                      EvolutionaryDrawdown.DerivedEmbodiedDrawWitness.surplusGen.amount t p =
                        EvolutionaryDrawdown.DerivedEmbodiedDrawWitness.surplusGen.offspringNumber t p) ∧
                  (∀ (p : EvolutionaryDrawdown.DerivedEmbodiedDrawWitness.Locus),
                      p ∈ EvolutionaryDrawdown.DerivedEmbodiedDrawWitness.surplusGen.family t →
                        EvolutionaryDrawdown.DerivedEmbodiedDrawWitness.surplusWeb.Supported t p →
                          ∀ (q : EvolutionaryDrawdown.DerivedEmbodiedDrawWitness.Locus),
                            q ∈ EvolutionaryDrawdown.DerivedEmbodiedDrawWitness.surplusGen.family t →
                              EvolutionaryDrawdown.DerivedEmbodiedDrawWitness.surplusGen.amount t q ≤
                                EvolutionaryDrawdown.DerivedEmbodiedDrawWitness.surplusGen.amount t p) ∧
                    SelectionTerm.Exact (EvolutionaryDrawdown.DerivedEmbodiedDrawWitness.surplusGen.family t)
                      (EvolutionaryDrawdown.DerivedEmbodiedDrawWitness.surplusGen.kids t)
                      (EvolutionaryDrawdown.DerivedEmbodiedDrawWitness.surplusGen.amount t)
                      (EvolutionaryDrawdown.DerivedEmbodiedDrawWitness.surplusGen.amount (t + 1))) ∧
          EvolutionaryDrawdown.DerivedEmbodiedDrawWitness.surplusWeb.level 4
                EvolutionaryDrawdown.DerivedEmbodiedDrawWitness.Locus.pool =
              0 ∧
            EvolutionaryDrawdown.DerivedEmbodiedDrawWitness.surplusGen.size 4 = 0
  )
  ∧
(
    ∀ (t : Nat),
      EvolutionaryDrawdown.DerivedEmbodiedDrawWitness.steadyWeb.level t
            EvolutionaryDrawdown.DerivedEmbodiedDrawWitness.Locus.pool =
          13 ∧
        EvolutionaryDrawdown.DerivedEmbodiedDrawWitness.steadyGen.size (t + 1) = 1 ∧
          EvolutionaryDrawdown.DerivedEmbodiedDrawWitness.steadyWeb.level (t + 1)
                EvolutionaryDrawdown.DerivedEmbodiedDrawWitness.Locus.pool +
              EvolutionaryDrawdown.DerivedEmbodiedDrawWitness.steadyFlow.taken t
                EvolutionaryDrawdown.DerivedEmbodiedDrawWitness.Locus.pool =
            EvolutionaryDrawdown.DerivedEmbodiedDrawWitness.steadyWeb.level t
                EvolutionaryDrawdown.DerivedEmbodiedDrawWitness.Locus.pool +
              EvolutionaryDrawdown.DerivedEmbodiedDrawWitness.steadyFlow.given t
                EvolutionaryDrawdown.DerivedEmbodiedDrawWitness.Locus.pool
  )) ∧
  ((
    let L :=
      EvolutionaryDrawdown.multiSiteFlow EvolutionaryDrawdown.MultiSiteBridgeWitness.uncheckedComp
        EvolutionaryDrawdown.MultiSiteBridgeWitness.twoSiteG (fun _ _ => 0)
        EvolutionaryDrawdown.MultiSiteBridgeWitness.uncheckedSt fun _ => ();
    let W :=
      EvolutionaryDrawdown.multiSiteWeb EvolutionaryDrawdown.MultiSiteBridgeWitness.uncheckedComp
        EvolutionaryDrawdown.MultiSiteBridgeWitness.twoSiteG (fun _ _ => 0)
        EvolutionaryDrawdown.MultiSiteBridgeWitness.uncheckedSt fun _ => ();
    L.BalancesOn W (List.map EvolutionaryDrawdown.MultiSiteRelatum.site [false, true]) 0 ∧
      W.level 2 (EvolutionaryDrawdown.MultiSiteRelatum.site false) +
            L.taken 1 (EvolutionaryDrawdown.MultiSiteRelatum.site false) =
          W.level 1 (EvolutionaryDrawdown.MultiSiteRelatum.site false) +
            L.given 1 (EvolutionaryDrawdown.MultiSiteRelatum.site false) ∧
        ((EvolutionaryDrawdown.MultiSiteBridgeWitness.uncheckedSt 2).fst true +
                EvolutionaryDrawdown.multiSiteDrawAt EvolutionaryDrawdown.MultiSiteBridgeWitness.uncheckedComp
                  (fun _ _ => 0) EvolutionaryDrawdown.MultiSiteBridgeWitness.uncheckedSt (fun _ => ()) 1 true =
              (EvolutionaryDrawdown.MultiSiteBridgeWitness.uncheckedSt 1).fst true +
                  L.given 1 (EvolutionaryDrawdown.MultiSiteRelatum.site true) +
                (EvolutionaryDrawdown.multiSiteDrawAt EvolutionaryDrawdown.MultiSiteBridgeWitness.uncheckedComp
                    (fun _ _ => 0) EvolutionaryDrawdown.MultiSiteBridgeWitness.uncheckedSt (fun _ => ()) 1 true -
                  (EvolutionaryDrawdown.MultiSiteBridgeWitness.uncheckedSt 1).fst true) ∧
            0 <
              EvolutionaryDrawdown.multiSiteDrawAt EvolutionaryDrawdown.MultiSiteBridgeWitness.uncheckedComp
                  (fun _ _ => 0) EvolutionaryDrawdown.MultiSiteBridgeWitness.uncheckedSt (fun _ => ()) 1 true -
                (EvolutionaryDrawdown.MultiSiteBridgeWitness.uncheckedSt 1).fst true) ∧
          ¬L.BalancesOn W (List.map EvolutionaryDrawdown.MultiSiteRelatum.site [false, true]) 1 ∧
            ¬L.Balances W ∧
              ¬(EvolutionaryDrawdown.multiSiteRel EvolutionaryDrawdown.MultiSiteBridgeWitness.uncheckedComp
                      EvolutionaryDrawdown.MultiSiteBridgeWitness.twoSiteG (fun _ _ => 0)
                      EvolutionaryDrawdown.MultiSiteBridgeWitness.uncheckedSt fun _ => ()).Runs
                  EvolutionaryDrawdown.multiSitePresent
                  (EvolutionaryDrawdown.multiSiteLevel EvolutionaryDrawdown.MultiSiteBridgeWitness.uncheckedSt) L
  )
  ∧
(
    Viability.Kernel
      (OpenComposition.closedProcess EvolutionaryDrawdown.MultiSiteBridgeWitness.safeComp
        EvolutionaryDrawdown.MultiSiteBridgeWitness.safeContract EvolutionaryDrawdown.MultiSiteBridgeWitness.safeObs
        OpenComposition.zeroSilenceChannel EvolutionaryDrawdown.MultiSiteBridgeWitness.twoSiteG (fun _ _ => 0) fun _ =>
        True)
      (OpenComposition.closedGuard EvolutionaryDrawdown.MultiSiteBridgeWitness.safeComp
        EvolutionaryDrawdown.MultiSiteBridgeWitness.safeContract EvolutionaryDrawdown.MultiSiteBridgeWitness.safeCrit)
      (EvolutionaryDrawdown.MultiSiteBridgeWitness.safeX0, 1)
  )) ∧
  ((
    (∀ (j : Nat),
        SelectionLevels.lineage EvolutionaryDrawdown.MajorTransitionWitness.unintGen
            [EvolutionaryDrawdown.MajorTransitionWitness.UnintRelatum.fast0] (2 + 1 + j + 1) =
          []) ∧
      total
          [EvolutionaryDrawdown.MajorTransitionWitness.UnintRelatum.coop3,
            EvolutionaryDrawdown.MajorTransitionWitness.UnintRelatum.fast3]
          (EvolutionaryDrawdown.MajorTransitionWitness.unintGen.offspringNumber (2 + 1 + 0)) =
        0
  )
  ∧
(
    Viability.Kernel
        (OpenComposition.closedProcess EvolutionaryDrawdown.MajorTransitionWitness.integComp
          EvolutionaryDrawdown.MajorTransitionWitness.integContract (fun _ => ()) OpenComposition.zeroSilenceChannel
          (fun e => e.elim) (fun _ e => e.elim) fun _ => True)
        (OpenComposition.closedGuard EvolutionaryDrawdown.MajorTransitionWitness.integComp
          EvolutionaryDrawdown.MajorTransitionWitness.integContract fun e => e.elim)
        (fun e => e.elim, ((), 1), fun _ => 9) ∧
      ∀
        (r :
          Run
            (OpenComposition.closedProcess EvolutionaryDrawdown.MajorTransitionWitness.integComp
              EvolutionaryDrawdown.MajorTransitionWitness.integContract (fun _ => ()) OpenComposition.zeroSilenceChannel
              (fun e => e.elim) (fun _ e => e.elim) fun _ => True)),
        r.state 0 = (fun e => e.elim, ((), 1), fun _ => 9) →
          ∀ (t : Nat),
            6 ≤ (r.state t).snd.snd () ∧
              EvolutionaryDrawdown.MajorTransitionWitness.aPoliced.drawExt (r.state t).snd.fst.fst (Sum.inr ()) +
                  EvolutionaryDrawdown.MajorTransitionWitness.bPoliced.drawExt (r.state t).snd.fst.snd (Sum.inr ()) ≤
                3
  )
  ∧
(
    let gs : List (List EvolutionaryDrawdown.MajorTransitionWitness.TransitionUnit) :=
      [[EvolutionaryDrawdown.MajorTransitionWitness.TransitionUnit.unint0,
          EvolutionaryDrawdown.MajorTransitionWitness.TransitionUnit.unint1],
        [EvolutionaryDrawdown.MajorTransitionWitness.TransitionUnit.integ0,
          EvolutionaryDrawdown.MajorTransitionWitness.TransitionUnit.integ1]];
    SelectionLevels.concordWithin gs (EvolutionaryDrawdown.MajorTransitionWitness.transitionGen.offspringNumber 3)
          (EvolutionaryDrawdown.MajorTransitionWitness.transitionGen.amount 3) =
        0 ∧
      SelectionLevels.discordWithin gs (EvolutionaryDrawdown.MajorTransitionWitness.transitionGen.offspringNumber 3)
            (EvolutionaryDrawdown.MajorTransitionWitness.transitionGen.amount 3) =
          0 ∧
        SelectionLevels.discordAmong gs (EvolutionaryDrawdown.MajorTransitionWitness.transitionGen.offspringNumber 3)
              (EvolutionaryDrawdown.MajorTransitionWitness.transitionGen.amount 3) =
            0 ∧
          SelectionLevels.concordAmong gs (EvolutionaryDrawdown.MajorTransitionWitness.transitionGen.offspringNumber 3)
                (EvolutionaryDrawdown.MajorTransitionWitness.transitionGen.amount 3) =
              4 ∧
            0 <
                SelectionLevels.concordAmong gs
                  (EvolutionaryDrawdown.MajorTransitionWitness.transitionGen.offspringNumber 3)
                  (EvolutionaryDrawdown.MajorTransitionWitness.transitionGen.amount 3) ∧
              EvolutionaryDrawdown.MajorTransitionWitness.transitionGen.Raises 3
  ))

/-- Full obstruction & sharpness panorama proposition across all core modules. -/
def FullObstructionPanoramaProp {Pos F : Type} (p : Pos) (f : F) : Prop :=
  AlignmentPanoramaProp p f ∧
  PolyPanoramaProp ∧
  CausalPanoramaProp ∧
  GeneralObstructionsProp ∧
  ActiveInquiryPanoramaProp ∧
  EndogenousOrderPanoramaProp p f ∧
  EvolutionaryDrawdownPanoramaProp

/-- Direct-reference aggregation of every verified structural obstruction and sharpness witness
across `AlignmentSpine`, `PolyComposition`, `CausalAbstraction`, `ActiveInquiryLoop`,
`EndogenousOrder`, and `EvolutionaryDrawdown` (zero duplicated proofs). -/
theorem full_obstruction_and_sharpness_panorama {Pos F : Type} (p : Pos) (f : F) :
    FullObstructionPanoramaProp p f :=
  ⟨⟨AlignmentSpine.SharpnessSuite.master_sharpness_suite_complete p f,
    AlignmentSpine.AlignmentDichotomy.structural_failure_atlas,
    AlignmentSpine.AlignmentDichotomy.pre_overdraw_and_aliasing_boundaries⟩,
   ⟨⟨PolyComposition.DynamicPortWitness.stayBlind_crashes,
     PolyComposition.DynamicPortWitness.dyn_viable_kernel,
     PolyComposition.DynamicPortWitness.cycleRun_modes_and_viability⟩,
    ⟨PolyComposition.SelfBlindingDichotomyWitness.unanchored_crashes,
     PolyComposition.SelfBlindingDichotomyWitness.anchored_rejects_selfBlind,
     PolyComposition.SelfBlindingDichotomyWitness.anchored_admits_selfWiden⟩,
    PolyComposition.ConcurrentSerialWitness.concurrent_serial_dichotomy,
    ⟨PolyComposition.CoupledSmallGainWitness.coupled_small_gain_viable,
     PolyComposition.CoupledSmallGainWitness.small_gain_violation_contrast⟩⟩,
   ⟨⟨HorizontalLeakageWitness.exact_on_obs,
     HorizontalLeakageWitness.exact_marginal_A,
     HorizontalLeakageWitness.exact_passive_A_marginal_B,
     HorizontalLeakageWitness.no_exact_causal_abs,
     @HorizontalLeakageWitness.no_zero_slack_lax_abs⟩,
    ⟨CausalGoodhartWitness.passive_commuting_all,
     CausalGoodhartWitness.passive_micro_kernel,
     CausalGoodhartWitness.passive_macro_kernel,
     CausalGoodhartWitness.macro_boost_kernel,
     CausalGoodhartWitness.micro_boost_guardS_collapses,
     CausalGoodhartWitness.micro_boost_proxy_collapses,
     CausalGoodhartWitness.no_exact_causal_abs_any_omega,
     @CausalGoodhartWitness.no_zero_slack_lax_causal_abs,
     @CausalGoodhartWitness.no_small_slack_lax_causal_abs⟩,
    ⟨PositiveCoupledFeedbackWitness.no_exact_causal_abs,
     PositiveCoupledFeedbackWitness.step_projection_err,
     PositiveCoupledFeedbackWitness.feedback_viability_kernel,
     PositiveCoupledFeedbackWitness.openLoop_viability_kernel⟩⟩,
   ⟨@exactCausal_refuted_of_confound_varied,
    fun {_ _ _ _ _} C₂ {_ _} hobs hω_obs hhit r {_ _ _} law untaken hdet_obs hdet_int hf_obs {_ _} two =>
      (causal_underdetermined_of_untaken C₂ hobs hω_obs hhit r law untaken hdet_obs hdet_int hf_obs two).1,
    ActiveInquiryLoop.learnable_passive_underdetermined,
    ActiveInquiryLoop.limit_passive_delay_obstruction⟩,
   ⟨⟨ActiveInquiryLoop.ActiveProbeWitness.probe_identifies_both,
     ActiveInquiryLoop.ActiveProbeWitness.active_probing_viable,
     ActiveInquiryLoop.ActiveProbeWitness.passive_exploit_crashes,
     ActiveInquiryLoop.ActiveProbeWitness.low_headroom_probe_crashes,
     ActiveInquiryLoop.ActiveProbeWitness.low_headroom_safe_holds⟩,
    ⟨ActiveInquiryLoop.CascadePoolWitness.cascade_pool_crashes,
     ActiveInquiryLoop.CascadePoolWitness.independent_pool_viable⟩,
    ⟨ActiveInquiryLoop.DelayObstructionWitness.delayed_relay_crashes,
     ActiveInquiryLoop.DelayObstructionWitness.direct_monitor_viable⟩,
    ⟨ActiveInquiryLoop.ThresholdBlindnessWitness.blind_5_crashes,
     ActiveInquiryLoop.ThresholdBlindnessWitness.theta_8_crashes_kernel,
     ActiveInquiryLoop.ThresholdBlindnessWitness.theta_10_viable⟩,
    ⟨ActiveInquiryLoop.SparseRelayBreachWitness.honest_blanket_compose_viable,
     ActiveInquiryLoop.SparseRelayBreachWitness.breach_not_blanketDetermined,
     ActiveInquiryLoop.SparseRelayBreachWitness.breach_crashes_at_four⟩⟩,
   ⟨⟨EndogenousOrder.OnlineWeightWitness.partial_reverses_and_firewall p f,
     EndogenousOrder.OnlineWeightWitness.OWPersist.witness_holds⟩,
    ⟨EndogenousOrder.ScopeCoEvolutionWitness.AssortmentSplit.witness_holds,
     EndogenousOrder.ScopeCoEvolutionWitness.AssortmentLineage.witness_holds,
     EndogenousOrder.ScopeCoEvolutionWitness.LagSplit.witness_holds⟩,
    EndogenousOrder.CourseNashObstructionWitness.witness_holds,
    EndogenousOrder.EndogenousFirewallWitness.firewall_holds⟩,
   ⟨⟨EvolutionaryDrawdown.DerivedEmbodiedDrawWitness.surplus_run_verified,
     EvolutionaryDrawdown.DerivedEmbodiedDrawWitness.steady_run_verified⟩,
    ⟨EvolutionaryDrawdown.MultiSiteBridgeWitness.unchecked_overdraw_separation,
     EvolutionaryDrawdown.MultiSiteBridgeWitness.safe_kernel⟩,
    ⟨EvolutionaryDrawdown.MajorTransitionWitness.unint_takeover_ends,
     EvolutionaryDrawdown.MajorTransitionWitness.integ_sealed_viability,
     EvolutionaryDrawdown.MajorTransitionWitness.transition_levels_shift⟩⟩⟩

/-! ## Section 4: K6 Ethics-Chain Compatibility, Metaethical Firewall, & Master Theorem -/

/-- Any dynamical law holding of `Becoming.MasterSpine` reads only the dynamics, never ethical
significance. -/
theorem masterSpine_readsOnlyDynamics {Pos F D : Type} (MasterLaw : D → Prop) :
    ReadsOnlyDynamics (Pos := Pos) (F := F)
      (fun d (_ : Pos → Nat → F → Prop) => MasterLaw d) :=
  readsOnlyDynamics_of MasterLaw

/-- Any verified `MasterSpine` law admits every rival bounded significance outside any excluded
point `(p, f)`. -/
theorem masterSpine_admits_rival {Pos F D : Type} (MasterLaw : D → Prop)
    {d : D} (holds : MasterLaw d) (_sig : Pos → Nat → F → Prop)
    {region : Pos → F → Prop} (outside : ∃ p f, ¬ region p f) :
    MasterLaw d ∧ Rival (bounded region) ∧ ¬ Unrestricted (bounded region) :=
  dynamicsLaw_admits_rival holds outside

/-- **Metaethical Firewall (`masterSpine_cannot_entail_unrestricted`)**: no dynamical law
satisfied by a `WholeArchitecture` can ever entail `Unrestricted sig` (`ScopeDynamics`). -/
theorem masterSpine_cannot_entail_unrestricted {Pos F D : Type} (MasterLaw : D → Prop)
    (p : Pos) (f : F) {d : D} (holds : MasterLaw d) :
    ¬ (∀ d' (sig : Pos → Nat → F → Prop), MasterLaw d' → Unrestricted sig) :=
  ScopeDynamics.scopeLaw_cannot_entail_unrestricted MasterLaw p f holds

/-- Proposition asserted by `k6_ethics_chain_and_firewall`. -/
def K6EthicsFirewallProp {Pos F : Type} (_p : Pos) (_f : F)
    {D : Type} (MasterLaw : D → Prop) : Prop :=
    -- K6 Step 1: Connected valuation -> Significant ↔ Grounds
    (∀ {P C : Type} {V : Valuation P C} (_ : V.Connected) (_ : P) {c₀ : C},
      V.living c₀ → (V.Significant ↔ V.Grounds)) ∧
    -- K6 Step 2: Grounds + beyond living -> Unrestricted
    (∀ {P F' C' : Type} (W : Web F' C') {sig : P → Nat → F' → Prop}
      (own : P → F' × Nat → Prop)
      (_ : (W.valuation own fun q e => sig q e.2 e.1).Connected) (_ : P) {e₀ : F' × Nat},
      (W.active e₀.2 e₀.1 ∧ ¬ W.UnderminingAt e₀.2 e₀.1) →
      (∀ e : F' × Nat, (W.active e.2 e.1 ∧ ¬ W.UnderminingAt e.2 e.1) ∨
        ¬ (W.active e.2 e.1 ∧ ¬ W.UnderminingAt e.2 e.1)) →
      (Unrestricted sig ↔ (W.valuation own fun q e => sig q e.2 e.1).Grounds ∧
        ∀ q (e : F' × Nat), ¬ (W.active e.2 e.1 ∧ ¬ W.UnderminingAt e.2 e.1) → sig q e.2 e.1)) ∧
    -- K6 Step 3: Unrestricted ↔ LivingSignificance
    (∀ {P S A F' : Type} (M : Frame S A (F' × Nat)) (_ : ∀ e, ∃ s, M.realized s e)
      (sig : P → Nat → F' → Prop),
      (Unrestricted sig ↔ LivingSignificance M (fun _ => True) (fun _ e => ∀ q, sig q e.2 e.1))) ∧
    -- K6 Steps 4-6: Widens ↔ Retains+Adds, Extension ↔ Widens, & One Object on Web.paths
    (∀ {P F' C' : Type} (W : Web F' C') {sig : P → Nat → F' → Prop},
      (Unrestricted sig ↔ LivingSignificance W.paths (fun _ => True) (fun _ e => ∀ q, sig q e.2 e.1)) ∧
      (∀ l l' : Nat → C' → Nat, Extension W.paths (fun _ => True) l' l ↔ W.Widens l l') ∧
      (Unrestricted sig → ∀ (q : P) (l l' : Nat → C' → Nat), W.Widens l l' ↔
        W.Retains sig q l l' ∧ W.Adds sig q l l')) ∧
    -- K6 Steps 7-8: Direction.extension_iff_widens & Direction.widening_selected_by_pool
    (∀ {F' C' Obs' : Type} (W : Web F' C') (outcome : Obs' → Nat → C' → Nat)
      (l l' : Nat → C' → Nat),
      Extension (Direction.frame W outcome) (fun _ => True) l' l ↔ W.Widens l l') ∧
    (∀ {F' C' : Type} {law : ExchangeLaw F' C'} {L L' : Flow F' C'} {W W' : Web F' C'}
      {obs : F' → C' → Prop} {part : F' → Bool} {group : F' → Prop},
      law.Through W obs part → L.Follows law part W.level → L'.Follows law part W'.level →
      L.Balances W → L'.Balances W' → (∀ t, L.present t = L'.present t) →
      (∀ c, W.level 0 c = W'.level 0 c) → (∀ f', group f' → L.ActsAlikeWithin L' W W' obs part f') →
      W.Widens W'.level W.level →
      ∃ s x, W.Admits (W'.level s) s x ∧ ¬ W.Admits (W.level s) s x ∧
        ¬ WithinClosureOf (L.CoupledFromEither W L' obs) group x ∧
        (∀ pool : F' → Prop, pool x → ∀ t, s ≤ t →
          W.SelectsThroughAll obs pool t (fun l => W.Admits (l s) s x)) ∧
        ∀ pool : F' → Prop,
          (∀ g, pool g → WithinClosureOf (L.CoupledFromEither W L' obs) group g) →
          ∀ t, ¬ W.SelectsThroughAll obs pool t (fun l => W.Admits (l s) s x)) ∧
    -- K6 Step 9: Grounded widening selected from evaluation grounds
    (∀ {P F' C' A_dir : Type} {law : ExchangeLaw F' C'} {L L' : Flow F' C'} {W W' : Web F' C'}
      {obs : F' → C' → Prop} {part : F' → Bool} {group : F' → Prop}
      {sig : P → Nat → F' → Prop} (own : P → F' × Nat → Prop)
      (_ : (W.valuation own fun q e => sig q e.2 e.1).Connected) (_ : P) {e₀ : F' × Nat},
      (W.active e₀.2 e₀.1 ∧ ¬ W.UnderminingAt e₀.2 e₀.1) →
      (∀ e : F' × Nat, (W.active e.2 e.1 ∧ ¬ W.UnderminingAt e.2 e.1) ∨
        ¬ (W.active e.2 e.1 ∧ ¬ W.UnderminingAt e.2 e.1)) →
      (W.valuation own fun q e => sig q e.2 e.1).Grounds →
      (∀ q (e : F' × Nat), ¬ (W.active e.2 e.1 ∧ ¬ W.UnderminingAt e.2 e.1) → sig q e.2 e.1) →
      law.Through W obs part → L.Follows law part W.level → L'.Follows law part W'.level →
      L.Balances W → L'.Balances W' → (∀ t, L.present t = L'.present t) →
      (∀ c, W.level 0 c = W'.level 0 c) → (∀ f', group f' → L.ActsAlikeWithin L' W W' obs part f') →
      W.Widens W'.level W.level →
      LivingSignificance W.paths (fun _ => True) (fun _ e => ∀ q, sig q e.2 e.1) ∧
      (∀ u : A_dir → Nat → C' → Nat, Extension (Direction.frame W u) (fun _ => True) W.level W'.level) ∧
      (∀ q : P, W.Retains sig q W'.level W.level ∧ W.Adds sig q W'.level W.level) ∧
      ∃ s x, (∀ q : P, sig q s x) ∧ W.Admits (W'.level s) s x ∧ ¬ W.Admits (W.level s) s x ∧
        ¬ WithinClosureOf (L.CoupledFromEither W L' obs) group x ∧
        (∀ pool : F' → Prop, pool x → ∀ t, s ≤ t →
          W.SelectsThroughAll obs pool t (fun l => W.Admits (l s) s x)) ∧
        ∀ pool : F' → Prop,
          (∀ g, pool g → WithinClosureOf (L.CoupledFromEither W L' obs) group g) →
          ∀ t, ¬ W.SelectsThroughAll obs pool t (fun l => W.Admits (l s) s x)) ∧
    -- Clearing concrete ethical direction
    (∀ {better : (Nat → Clearing.Place → Nat) → (Nat → Clearing.Place → Nat) → Prop}
      (_ : FrontierFrames.Priority (Direction.frame Clearing.web Clearing.spareOutcome) (fun _ => False) (fun _ => True) better)
      (s : Nat → Clearing.Place → Nat),
      Clearing.web.Widens Clearing.sparedWeb.level Clearing.web.level ∧
        ¬ Requirement.Frontier (FrontierFrames.Options (Direction.frame Clearing.web Clearing.spareOutcome) s) better Clearing.web.level ∧
        (∀ pool : Clearing.Formation → Prop, pool .dweller → ∀ t, 2 ≤ t →
          Clearing.web.SelectsThroughAll thresholdOnly pool t
            (fun l => Clearing.web.Admits (l 2) 2 .dweller)) ∧
        ∀ pool : Clearing.Formation → Prop,
          (∀ g, pool g → WithinClosure
            (Clearing.flow.CoupledFromEither Clearing.web Clearing.sparedFlow thresholdOnly)
            .clearer g) →
          ∀ t, ¬ Clearing.web.SelectsThroughAll thresholdOnly pool t
            (fun l => Clearing.web.Admits (l 2) 2 .dweller)) ∧
    -- Unconditional Metaethical Firewalls
    (¬ (∀ d' (sig : Pos → Nat → F → Prop), MasterLaw d' → Unrestricted sig) ∧
     (∀ {X Mode : Type} {S Obs Dist Int Ext : Mode → Type} {Site Env Act F_c C_c : Type}
       (Law : EndogenousOrder.EndogenousOrderSystem X Mode S Obs Dist Int Ext Site Env Act F_c C_c → Prop)
       {sys : EndogenousOrder.EndogenousOrderSystem X Mode S Obs Dist Int Ext Site Env Act F_c C_c},
       Law sys → ¬ (∀ sys' (sig : Pos → Nat → F → Prop), Law sys' → Unrestricted sig)) ∧
     (∀ {D_s : Type} (SpineLaw : D_s → Prop) {d_s : D_s}, SpineLaw d_s →
       ¬ (∀ d' (sig : Pos → Nat → F → Prop), SpineLaw d' → Unrestricted sig)) ∧
     (∀ {D_sc : Type} (ScopeLaw : D_sc → Prop) {d_sc : D_sc}, ScopeLaw d_sc →
       ¬ (∀ d' (sig : Pos → Nat → F → Prop), ScopeLaw d' → Unrestricted sig)) ∧
     (∀ {D_no S_no A_no C_no : Type} {law : D_no → (S_no → S_no → Prop) → Prop},
       ReadsNoOrder law →
       ∀ {frame : Frame S_no A_no C_no} {living : C_no → Prop} {d_no : D_no},
       (∀ better, law d_no better → Comparison frame living better) →
       ∀ {s t : S_no}, Extension frame living s t → ∀ {better : S_no → S_no → Prop}, ¬ law d_no better) ∧
     (Clearing.valuation.Held ∧ (∀ g, Clearing.valuation.SelfSignificance g) ∧
      (∀ q e e', Clearing.valuation.sig q e → Clearing.flow.FedBy Clearing.web e e' →
        Clearing.valuation.sig q e') ∧
      Clearing.valuation.living (.dweller, 0) ∧ ¬ Clearing.valuation.sig .clearer (.dweller, 0) ∧
      ¬ Neutral Clearing.valuation.shares ∧ ¬ Clearing.valuation.Significant ∧
      Clearing.valuation.related (.clearer, 0) (.dweller, 0) ∧
      ¬ Within (fun i => Clearing.own i.1 i.2.1) Clearing.valuation.transmits))

/-- **K6 Ethics-Chain Compatibility & Full Metaethical Firewall (`k6_ethics_chain_and_firewall`)**:
explicitly connects every step of the K6 ethics derivation (`Valuation.significant_iff`,
`Web.unrestricted_iff_grounds_beyond`, `unrestricted_iff_livingSignificance`, `Web.widens_iff_retains_adds`,
`Web.paths_extension_iff_widens`, `Web.paths_one_object`, `Direction.extension_iff_widens`,
`Direction.widening_selected_by_pool`, `Direction.grounded_widening_selected`, `Clearing.direction`)
with unconditional firewalls across `MasterSpine`, `EndogenousOrder`, `AlignmentSpine`, `ScopeDynamics`,
`ReadsNoOrder`, and `Clearing.center_not_derived`. -/
theorem k6_ethics_chain_and_firewall {Pos F : Type} (p : Pos) (f : F)
    {D : Type} (MasterLaw : D → Prop) {d : D} (holds : MasterLaw d) :
    K6EthicsFirewallProp p f MasterLaw := by
  refine ⟨fun {_ _ _} hconn p₀ {_} hA => Valuation.significant_iff hconn p₀ hA,
    fun {_ _ _} W {_} own hconn p₀ {_} hA hDec => Web.unrestricted_iff_grounds_beyond own hconn p₀ hA hDec,
    fun M hS sig => unrestricted_iff_livingSignificance M hS,
    fun W sig => W.paths_one_object,
    fun W outcome l l' => Direction.extension_iff_widens,
    fun {_ _ _ _ _ _ _ _ _ _} th f1 f2 b1 b2 pr st ac wd => Direction.widening_selected_by_pool th f1 f2 b1 b2 pr st ac wd,
    fun {_ _ _ _ _ _ _ _ _ _ _ _ _} own hconn p₀ {_} hA hDec hg hb th f1 f2 b1 b2 pr st ac wd =>
      Direction.grounded_widening_selected own hconn p₀ hA hDec hg hb th f1 f2 b1 b2 pr st ac wd,
    fun prio s => Clearing.direction prio s,
    ⟨masterSpine_cannot_entail_unrestricted MasterLaw p f holds,
     fun Law _ hL => EndogenousOrder.endogenousOrder_cannot_entail_unrestricted Law p f hL,
     fun SpineLaw _ hS => AlignmentSpine.AlignmentDichotomy.alignmentSpine_cannot_entail_unrestricted SpineLaw p f hS,
     fun ScopeLaw _ hSc => ScopeDynamics.scopeLaw_cannot_entail_unrestricted ScopeLaw p f hSc,
     fun {_ _ _ _ _} reads {_ _ _} entails {_ _} ext {_} => ReadsNoOrder.not_entails reads entails ext,
     Clearing.center_not_derived⟩⟩

/-- Proposition asserted by `AlignmentSpine.AlignmentDichotomy.master_alignment_dichotomy`. -/
def MasterAlignmentDichotomyProp {Pos F : Type} (_p : Pos) (_f : F) : Prop :=
  (AlignmentSpine.ComposedSpine.MasterSpineWitness.spineTaskModel.B_task = 42 ∧
        Viability.Kernel
          (OpenComposition.closedProcess AlignmentSpine.ComposedSpine.MasterSpineWitness.witnessSpineComp
            AlignmentSpine.ComposedSpine.MasterSpineWitness.witnessSpineContr
            AlignmentSpine.ComposedSpine.MasterSpineWitness.witnessSpineObs
            AlignmentSpine.ComposedSpine.MasterSpineWitness.witnessChannel
            AlignmentSpine.ComposedSpine.MasterSpineWitness.gExt (fun _ _ => 0) fun _ => True)
          (OpenComposition.closedGuard AlignmentSpine.ComposedSpine.MasterSpineWitness.witnessSpineComp
            AlignmentSpine.ComposedSpine.MasterSpineWitness.witnessSpineContr fun _ => 10)
          (fun _ => 46, AlignmentSpine.ComposedSpine.MasterSpineWitness.witnessSpineInit)) ∧
      (∀ (drawA drawB : Nat → Nat) (nextA nextB : Nat → Unit → Nat) (rA rB : Nat),
          (∀ (r : Nat), 1 ≤ drawA r) →
            (∀ (r : Nat), 1 ≤ drawB r) →
              (Law.orbit
                    (fun st =>
                      (RegimeMargin.step (fun z => OpenComposition.WideningWitness.gShared () fun _ => z)
                          (drawA st.snd.fst + drawB st.snd.snd) st.fst,
                        nextA st.snd.fst (), nextB st.snd.snd ()))
                    (6, rA, rB) 6).fst =
                0) ∧
        (Law.orbit (fun st => OpenComposition.HiddenCouplingFailure.composedStep st ((), (), ())) (fun _ => 4, (), ())
                  4).fst
              () =
            0 ∧
          (∀ (t : Nat),
              3 ≤ t →
                ScopeDynamics.UncoordCommonsWitness.commons.substrate t = 0 ∧
                  ∀ (k : ScopeDynamics.PoolCap),
                    ¬ScopeDynamics.UncoordCommonsWitness.commons.W_coop.MacroAdmits
                        ScopeDynamics.UncoordCommonsWitness.commons.cap
                        (ScopeDynamics.UncoordCommonsWitness.commons.W_coop.level t) t k) ∧
            Viability.Kernel PacedStock.SlackShortWitness.frame.P (fun s => PacedStock.SlackShortWitness.thr ≤ s.snd)
                ([true], 6) ∧
              ¬Viability.Kernel PacedStock.SlackShortWitness.frame.P (fun s => PacedStock.SlackShortWitness.thr ≤ s.snd)
                    ([true], 5) ∧
                ∀ {D : Type} (SpineLaw : D → Prop) {d : D},
                  SpineLaw d → ¬∀ (d' : D) (sig : Pos → Nat → F → Prop), SpineLaw d' → Unrestricted sig

/-- **Top-Level Whole Becoming Master Theorem (`whole_becoming_master_theorem`)**:
unifies (1) concrete coupled compositional architecture (`whole_architecture_viable_and_coupled`),
(2) all 5 `shared_laws` + `GrammarMap` lifts (`masterSpine_grammar_lifts`),
(3) full obstruction and sharpness panorama (`full_obstruction_and_sharpness_panorama`),
(4) K6 ethics-chain compatibility and metaethical firewall (`k6_ethics_chain_and_firewall`), and
(5) `AlignmentSpine.AlignmentDichotomy.master_alignment_dichotomy`. -/
theorem whole_becoming_master_theorem
    {Θ Probe Outcome Env I₁ S₁ A₁ Dist₁ I₂ S₂ A₂ Dist₂ ObsL Site ExtHide
     ModeR S_r Obs_r Dist_r Int_r QX BX QA BA QB BB QCausal X_evo X_bad Pos_ord Act F_cr C_cr : Type}
    (A : WholeArchitecture Θ Probe Outcome Env
      I₁ S₁ A₁ Dist₁ I₂ S₂ A₂ Dist₂ ObsL Site ExtHide
      ModeR S_r Obs_r Dist_r Int_r QX BX QA BA QB BB QCausal X_evo X_bad Pos_ord Act F_cr C_cr)
    {Pos F D : Type} (p : Pos) (f : F) (MasterLaw : D → Prop) {d : D} (holds : MasterLaw d) :
    (WholeArchitectureViableProp A ∧
     MasterSpineGrammarLiftsProp A ∧
     FullObstructionPanoramaProp p f ∧
     K6EthicsFirewallProp p f MasterLaw ∧
     MasterAlignmentDichotomyProp p f) :=
  ⟨whole_architecture_viable_and_coupled A,
    masterSpine_grammar_lifts A,
    full_obstruction_and_sharpness_panorama p f,
    k6_ethics_chain_and_firewall p f MasterLaw holds,
    AlignmentSpine.AlignmentDichotomy.master_alignment_dichotomy p f⟩

/-! ## Section 5: Concrete Integrated Witness (`WholeBecomingWitness`) — Exact Arithmetic -/

namespace WholeBecomingWitness

def wG : Bool → Unit → (Unit → Nat) → Nat
  | true, _, e => if 4 ≤ e () then 3 else 0
  | false, _, e => if 4 ≤ e () then 1 else 0

theorem wG_rises (θ : Bool) (site : Unit) :
    RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (wG θ site) := by
  intro e₁ e₂ hle
  have h0 : e₁ () ≤ e₂ () := hle ()
  cases θ with
  | true =>
    show (if 4 ≤ e₁ () then 3 else 0) ≤ if 4 ≤ e₂ () then 3 else 0
    cases Nat.decLe 4 (e₁ ()) with
    | isTrue h => rw [if_pos h, if_pos (Nat.le_trans h h0)]; exact Nat.le_refl 3
    | isFalse h => rw [if_neg h]; exact Nat.zero_le _
  | false =>
    show (if 4 ≤ e₁ () then 1 else 0) ≤ if 4 ≤ e₂ () then 1 else 0
    cases Nat.decLe 4 (e₁ ()) with
    | isTrue h => rw [if_pos h, if_pos (Nat.le_trans h h0)]; exact Nat.le_refl 1
    | isFalse h => rw [if_neg h]; exact Nat.zero_le _

def wProbeObs (θ : Bool) (_ : Unit) (x : Unit → Nat) : Bool :=
  Nat.blt 1 (wG θ () x)

def wObsL (x : Unit → Nat) : Bool := Nat.blt (x ()) 22

def wObsR (x : Unit → Nat) : Bool := Nat.blt (x ()) 22

def wWorld : ActiveInquiryLoop.RegimeWorld Bool Unit Bool (Bool × Bool) Unit Unit where
  G := wG
  G_rises := wG_rises
  probeObs := wProbeObs
  opObs _ x := (wObsL x, wObsR x)
  envDraw _ _ _ := 1
  envCap _ := 1
  jointAdm _ := True
  env_within _ _ _ _ := Nat.le_refl 1

def wSp₁ : ActiveInquiryLoop.BlanketContractSpec Unit Bool Nat (Sum Unit Unit) Unit where
  nextInternal _ _ _ _ := ()
  nextActive _ sb a _ := if sb.2 then a - 1 else a
  drawBoundary a
    | .inl _ => if a = 0 then 0 else 1
    | .inr _ => if a = 0 then 1 else 2
  emitBoundary _ s := s
  silenceLoad _ := 0
  favours p := 0 < p.2
  initI := ()
  initA := 1
  tol _ _ := True
  warnSensory s := s = true
  preCapExt
    | .inl _ => 1
    | .inr _ => 2
  postAllowanceExt
    | .inl _ => 0
    | .inr _ => 1
  maxSilence := 0
  maxLag := 1
  K p := p.2 ≤ 1
  eta p := p.2
  init_in := Nat.le_refl 1
  within p hK := by
    refine ⟨fun k => ?_, Nat.le_refl 0, fun h0 => ?_⟩
    · cases k with
      | inl _ =>
        show (if p.2 = 0 then 0 else 1) ≤ 1
        cases Nat.decEq p.2 0 with
        | isTrue ht => rw [if_pos ht]; exact Nat.zero_le 1
        | isFalse hf => rw [if_neg hf]; exact Nat.le_refl 1
      | inr _ =>
        show (if p.2 = 0 then 1 else 2) ≤ 2
        cases Nat.decEq p.2 0 with
        | isTrue ht => rw [if_pos ht]; exact by decide
        | isFalse hf => rw [if_neg hf]; exact Nat.le_refl 2
    · refine ⟨by rw [h0]; exact Nat.lt_irrefl 0, fun k => ?_⟩
      cases k with
      | inl _ => show (if p.2 = 0 then 0 else 1) ≤ 0; rw [if_pos h0]; exact Nat.le_refl 0
      | inr _ => show (if p.2 = 0 then 1 else 2) ≤ 1; rw [if_pos h0]; exact Nat.le_refl 1
  closed p _ al _ hK _ := by
    show (if al then p.2 - 1 else p.2) ≤ 1
    cases al with
    | true => exact Nat.le_trans (Nat.sub_le p.2 1) hK
    | false => exact hK
  eta_bound _ hK := hK
  emits_on_warn _ _ _ hw := hw
  eta_alarm_step p _ _ _ hK hpos := by
    show p.2 - 1 < p.2
    exact Nat.sub_lt hpos Nat.zero_lt_one
  eta_alarm_zero p _ _ _ _ h0 := by
    show p.2 - 1 = 0
    rw [h0]

def wSp₂ : ActiveInquiryLoop.BlanketContractSpec Unit Bool Nat (Sum Unit Unit) Unit where
  nextInternal _ _ _ _ := ()
  nextActive _ sb a _ := if sb.2 then a - 1 else a
  drawBoundary _ _ := 1
  emitBoundary _ s := s
  silenceLoad _ := 0
  favours p := 0 < p.2
  initI := ()
  initA := 1
  tol _ _ := True
  warnSensory s := s = true
  preCapExt _ := 1
  postAllowanceExt _ := 1
  maxSilence := 0
  maxLag := 1
  K p := p.2 ≤ 1
  eta p := p.2
  init_in := Nat.le_refl 1
  within p _ := ⟨fun _ => Nat.le_refl 1, Nat.le_refl 0, fun h0 =>
    ⟨by rw [h0]; exact Nat.lt_irrefl 0, fun _ => Nat.le_refl 1⟩⟩
  closed p _ al _ hK _ := by
    show (if al then p.2 - 1 else p.2) ≤ 1
    cases al with
    | true => exact Nat.le_trans (Nat.sub_le p.2 1) hK
    | false => exact hK
  eta_bound _ hK := hK
  emits_on_warn _ _ _ hw := hw
  eta_alarm_step p _ _ _ hK hpos := Nat.sub_lt hpos Nat.zero_lt_one
  eta_alarm_zero p _ _ _ _ h0 := by show p.2 - 1 = 0; rw [h0]

def wG_hide (_ : Unit) (e : Unit → Nat) : Nat := if 6 ≤ e () then 2 else 0

theorem wG_hide_rises : ∀ k : Unit, RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (wG_hide k) := by
  intro _ e₁ e₂ hle
  show (if 6 ≤ e₁ () then 2 else 0) ≤ if 6 ≤ e₂ () then 2 else 0
  cases Nat.decLe 6 (e₁ ()) with
  | isTrue h => rw [if_pos h, if_pos (Nat.le_trans h (hle ()))]; exact Nat.le_refl 2
  | isFalse h => rw [if_neg h]; exact Nat.zero_le _

def wFlagOf (o : Bool) (xh : Unit → Nat) : Bool := o || Nat.blt (xh ()) 14

def wWireObs : Bool → (Unit → Nat) → Bool × Bool := wholeWireObs wFlagOf id id

def wBaseR := EndogenousOrder.scopeBase 2 1 1 (by decide : 1 ≤ 2)

def wInitR : Σ _ : EndogenousOrder.ScopeMode, Nat := ⟨.narrowUnmonitored, 1⟩

def wProposeR : (p : Σ m, EndogenousOrder.ScopeS m) →
    EndogenousOrder.ScopeObs p.1 × Bool → EndogenousOrder.ScopeDist p.1 →
    Σ m', EndogenousOrder.ScopeS m' :=
  fun p oa _ => if oa.1 || oa.2 then ⟨.wideReciprocal, 0⟩ else p

def wChannel (em : Bool) (load : Nat) (_ : Unit) : Bool := em && Nat.ble load 0

def wPlan (_ : Nat) : Unit := ()

def wProbeDraw (_ : Unit) : Nat := 1

def wProbeStepDraw (_ : Nat) (_ : List (Unit × Bool)) (_ : Unit) : Nat := 1

def wInfer : List (Unit × Bool) → Bool
  | [] => false
  | (_, out) :: rest => match rest with
    | [] => out
    | _ :: _ => false

def wCompOp :=
  wholeOp wSp₁ wSp₂ wG_hide wWireObs wBaseR
    (EndogenousOrder.scopeAdmitDec 1) EndogenousOrder.scopeFallback wProposeR

def wInitOp : (((Unit × Nat) × (Unit × Nat)) × (Unit → Nat)) × (Σ _ : EndogenousOrder.ScopeMode, Nat) :=
  (((((), 1), ((), 1)), fun _ => 11), wInitR)

def wCLeft :=
  wholeSealedLeftContract wSp₁ wSp₂ wG_hide wWireObs
    (fun _ _ => True) (fun o => o = true)
    (fun _ => 8) (fun _ => 14) (fun _ => 2) (fun _ => 11)
    (fun _ _ _ _ _ _ => ⟨trivial, trivial⟩) wG_hide_rises
    (fun o xh ho => by dsimp only [wWireObs, wholeWireObs, wFlagOf, wholeInnerBlkContract]; rw [ho]; exact .inl rfl)
    (fun o xh ⟨_, hlt⟩ => by
      dsimp only [wWireObs, wholeWireObs, wFlagOf, wholeInnerBlkContract]
      have hblt : Nat.blt (xh ()) 14 = true := CoreHelpers.natBlt_true_iff.mpr hlt
      rw [hblt, Bool.or_true]
      exact .inl rfl)
    (fun k => by cases k; exact by decide)
    (fun k => by cases k; exact by decide)
    (fun k => by cases k; exact by decide)
    (fun k => by cases k; exact by decide)

def wCRight :=
  scopeOpenContract 2 1 1 1 (by decide : 1 ≤ 2) ⟨Nat.zero_lt_one, Nat.le_refl 1⟩ wProposeR

def wCOp := wholeOpContract wCLeft wCRight

def wSpec :=
  wholeInquirySpec 1 wPlan wProbeDraw wProbeStepDraw (fun _ _ _ => Nat.le_refl 1) wInfer
    wCompOp wInitOp wCOp

abbrev WOpS :=
  (((Unit × Nat) × (Unit × Nat)) × (Unit → Nat)) × (Σ _ : EndogenousOrder.ScopeMode, Nat)

def wDefaultDist : (m : ActiveInquiryLoop.InquiryMode Bool Unit) →
    ActiveInquiryLoop.inquiryDist ((Unit × Unit) × Unit) Bool m
  | .probe _ => ()
  | .operate _ _ => (((), ()), ())

def wStepFull (st : (Unit → Nat) × Σ m : ActiveInquiryLoop.InquiryMode Bool Unit,
    ActiveInquiryLoop.inquiryS Unit Bool WOpS Bool m) :=
  PolyComposition.polyClosedStep (ActiveInquiryLoop.inquiryPolyComponent wSpec) (fun _ site => [site])
    (ActiveInquiryLoop.inquiryWorldObs wWorld wSpec true) wChannel (wG true) (fun _ _ => 1)
    st ((), wDefaultDist st.2.1)

def wOrbitFull : Nat → (Unit → Nat) × Σ m : ActiveInquiryLoop.InquiryMode Bool Unit,
    ActiveInquiryLoop.inquiryS Unit Bool WOpS Bool m
  | 0 => (fun _ => 20, ActiveInquiryLoop.inquiryInit wSpec)
  | t + 1 => wStepFull (wOrbitFull t)

theorem wDefaultTol : ∀ (m : ActiveInquiryLoop.InquiryMode Bool Unit)
    (ob : ActiveInquiryLoop.inquiryObs Bool (Bool × Bool) Bool m × Bool),
    (ActiveInquiryLoop.inquiryContract wSpec).tol m ob (wDefaultDist m)
  | .probe _, _ => trivial
  | .operate _ _, _ => ⟨trivial, trivial⟩

def w_r_full : Run (PolyComposition.polyClosedProcess
    (ActiveInquiryLoop.inquiryPolyComponent wSpec) (fun _ site => [site])
    (ActiveInquiryLoop.inquiryContract wSpec)
    (ActiveInquiryLoop.inquiryWorldObs wWorld wSpec true) wChannel (wG true) (fun _ _ => 1) (fun _ => True)) where
  state := wOrbitFull
  act t := ((), ⟨(wOrbitFull t).2.1, wDefaultDist (wOrbitFull t).2.1⟩)
  step t := ⟨rfl, trivial, fun ob => wDefaultTol (wOrbitFull t).2.1 ob, rfl⟩

theorem wOrbitFull_1 :
    wOrbitFull 1 = (fun _ => 21, ⟨.operate true (), (((((), 1), ((), 1)), fun _ => 11), ⟨.narrowUnmonitored, 1⟩)⟩) :=
  rfl

theorem wOrbitFull_ge_2 : ∀ k : Nat,
    wOrbitFull (k + 2) =
      (fun _ => 19, ⟨.operate true (), (((((), 0), ((), 0)), fun _ => 10), ⟨.wideReciprocal, 0⟩)⟩)
  | 0 => rfl
  | k + 1 => by
    have ih := wOrbitFull_ge_2 k
    change wStepFull (wOrbitFull (k + 2)) = _
    rw [ih]
    rfl

theorem wROp_level_eq : ∀ k : Nat,
    (w_r_full.state (1 + k)).1 () = if k = 0 then 21 else 19
  | 0 => congrArg (fun st => st.1 ()) wOrbitFull_1
  | k + 1 => by
    have hEq := congrArg (fun st => st.1 ()) (wOrbitFull_ge_2 k)
    change (wOrbitFull (1 + (k + 1))).1 () = 19
    rw [show 1 + (k + 1) = k + 2 from Nat.add_comm 1 (k + 1)]
    exact hEq

theorem wDrawExt_pos : ∀ k : Nat,
    0 < wCompOp.drawExt (extractOpState wInitOp (w_r_full.state (1 + k)).2) ()
  | 0 => by
    change 0 < wCompOp.drawExt (extractOpState wInitOp (wOrbitFull 1).2) ()
    rw [wOrbitFull_1]
    exact by decide
  | k + 1 => by
    change 0 < wCompOp.drawExt (extractOpState wInitOp (wOrbitFull (1 + (k + 1))).2) ()
    rw [show 1 + (k + 1) = k + 2 from Nat.add_comm 1 (k + 1)]
    rw [wOrbitFull_ge_2 k]
    exact by decide

theorem wEq_of_distNat_zero {a b : Nat} (h : distNat a b = 0) : a = b := by
  unfold distNat at h
  have h1 : a - b = 0 := Nat.eq_zero_of_le_zero (Nat.le_trans (Nat.le_add_right _ _) (Nat.le_of_eq h))
  have h2 : b - a = 0 := Nat.eq_zero_of_le_zero (Nat.le_trans (Nat.le_add_left _ _) (Nat.le_of_eq h))
  exact Nat.le_antisymm (Nat.le_of_sub_eq_zero h1) (Nat.le_of_sub_eq_zero h2)

/-- Capped metric `min (distNat a b) 25` (`SlackDist` satisfying `tri` and exact for distances `< 25`). -/
def cappedDistNat (a b : Nat) : Nat :=
  if distNat a b ≤ 25 then distNat a b else 25

theorem cappedDistNat_le (a b : Nat) : cappedDistNat a b ≤ 25 := by
  unfold cappedDistNat
  cases Nat.decLe (distNat a b) 25 with
  | isTrue h => rw [if_pos h]; exact h
  | isFalse h => rw [if_neg h]; exact Nat.le_refl 25

theorem cappedDistNat_eq_of_le {a b : Nat} (h : distNat a b ≤ 25) : cappedDistNat a b = distNat a b := by
  unfold cappedDistNat; rw [if_pos h]

theorem cappedDistNat_zero_iff {a b : Nat} : cappedDistNat a b = 0 ↔ a = b := by
  unfold cappedDistNat
  cases Nat.decLe (distNat a b) 25 with
  | isTrue h =>
    rw [if_pos h]
    exact ⟨fun hz => wEq_of_distNat_zero hz, fun he => he ▸ distNat_self a⟩
  | isFalse h =>
    rw [if_neg h]
    exact ⟨fun hz => absurd hz (by decide), fun he => absurd (he ▸ distNat_self a ▸ by decide : distNat a b ≤ 25) h⟩

def wSlackNat : SlackDist Nat where
  d := cappedDistNat
  refl a := by unfold cappedDistNat; rw [distNat_self a]; rfl
  tri a b c := by
    have htri := distNat_tri a b c
    unfold cappedDistNat
    cases Nat.decLe (distNat a c) 25 with
    | isTrue hac =>
      rw [if_pos hac]
      cases Nat.decLe (distNat a b) 25 with
      | isTrue hab =>
        rw [if_pos hab]
        cases Nat.decLe (distNat b c) 25 with
        | isTrue hbc => rw [if_pos hbc]; exact htri
        | isFalse hbc =>
          rw [if_neg hbc]
          exact Nat.le_trans hac (Nat.le_add_left 25 (distNat a b))
      | isFalse hab =>
        rw [if_neg hab]
        exact Nat.le_trans hac (Nat.le_add_right 25 _)
    | isFalse hac =>
      rw [if_neg hac]
      have hgt : 25 < distNat a c := Nat.lt_of_not_le hac
      cases Nat.decLe (distNat a b) 25 with
      | isTrue hab =>
        rw [if_pos hab]
        cases Nat.decLe (distNat b c) 25 with
        | isTrue hbc =>
          rw [if_pos hbc]
          exact Nat.le_of_lt (Nat.lt_of_lt_of_le hgt htri)
        | isFalse hbc => rw [if_neg hbc]; exact Nat.le_add_left 25 _
      | isFalse hab => rw [if_neg hab]; exact Nat.le_add_right 25 _

def wSlackLeft : SlackDist (Nat × Nat) where
  d p q := CoreHelpers.natMax (cappedDistNat p.1 q.1) (cappedDistNat p.2 q.2)
  refl p := by
    change CoreHelpers.natMax (wSlackNat.d p.1 p.1) (wSlackNat.d p.2 p.2) = 0
    rw [wSlackNat.refl p.1, wSlackNat.refl p.2]; rfl
  tri p q r :=
    CoreHelpers.natMax_le
      (Nat.le_trans (wSlackNat.tri p.1 q.1 r.1)
        (Nat.add_le_add (CoreHelpers.le_natMax_left _ _) (CoreHelpers.le_natMax_left _ _)))
      (Nat.le_trans (wSlackNat.tri p.2 q.2 r.2)
        (Nat.add_le_add (CoreHelpers.le_natMax_right _ _) (CoreHelpers.le_natMax_right _ _)))

def wRX : Process Nat ((Unit → Nat) × Unit) where
  step qx a qx' :=
    qx' = RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole (wG true)
      (fun _ => a.1 () + 1) (fun _ => qx) ()

def wRA : Process (Nat × Nat) (Nat × Bool) where
  step qa a qa' :=
    let obsC := wWireObs (wObsL (fun _ => a.1)) (fun _ => qa.2)
    let alEff := a.2 || (obsC.1 || obsC.2)
    let a1' := if alEff then qa.1 - 1 else qa.1
    let hDraw := (if qa.1 = 0 then 1 else 2) + 1
    let xh' := RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole wG_hide
      (fun _ => hDraw) (fun _ => qa.2) ()
    qa' = (a1', xh')

def wRB : Process Nat (Nat × Bool) where
  step qb a qb' :=
    let al := a.2
    let obsR := wObsR (fun _ => a.1)
    let modS : Σ m, EndogenousOrder.ScopeS m :=
      if qb = 0 then ⟨.wideReciprocal, 0⟩ else ⟨.narrowUnmonitored, qb⟩
    let nextS := (wholeScopeOpen wBaseR (EndogenousOrder.scopeAdmitDec 1) EndogenousOrder.scopeFallback
      wProposeR).next modS (obsR, al) ()
    qb' = nextS.2

def wDrawQA (qa : Nat × Nat) (_ : Unit) : Nat := (if qa.1 = 0 then 0 else 1) + 1

def wDrawQB (qb : Nat) (_ : Unit) : Nat := if qb = 0 then 1 else 2

def wSimX : PolyComposition.SubstrateLaxSim (Ext := Unit) (Env := Unit) (QX := Nat) (BX := Unit)
    (wG true) (fun _ _ => 1) (fun _ => True) wRX (fun x => x ()) id wSlackNat where
  EpochX _ _ := True
  EpochQX _ _ := True
  epoch_step _ _ _ _ _ _ := trivial
  epoch_proj _ _ _ := trivial
  gain rX rH := if Nat.beq rX 0 && Nat.beq rH 0 then 0 else rX + rH + 25
  gain_mono {rX₁ rX₂ rH₁ rH₂} hX hH := by
    cases h1 : Nat.beq rX₁ 0 && Nat.beq rH₁ 0 with
    | true => exact Nat.zero_le _
    | false =>
      have h2 : (Nat.beq rX₂ 0 && Nat.beq rH₂ 0) = false := by
        cases hr2 : Nat.beq rX₂ 0 && Nat.beq rH₂ 0 with
        | false => rfl
        | true =>
          have hx2 : rX₂ = 0 := CoreHelpers.natBeq_true_iff.mp (ListTests.and_left hr2)
          have hh2 : rH₂ = 0 := CoreHelpers.natBeq_true_iff.mp (ListTests.and_right hr2)
          have hx1 : rX₁ = 0 := Nat.eq_zero_of_le_zero (hx2 ▸ hX)
          have hh1 : rH₁ = 0 := Nat.eq_zero_of_le_zero (hh2 ▸ hH)
          rw [hx1, hh1] at h1
          exact Bool.noConfusion h1
      rw [if_neg Bool.false_ne_true, if_neg (h2 ▸ Bool.false_ne_true)]
      exact Nat.add_le_add_right (Nat.add_le_add hX hH) 25
  ε := 0
  β rX _ := rX
  β_mono hX _ := hX
  β_ge_left _ _ := Nat.le_refl _
  η := 25
  sim_block k x qX hQ rX rH wX x' _ _ d_le hQ_dist len tr := by
    cases wX with
    | nil => rw [id, id, Naturals.add_sub_cancel_left] at len; exact absurd len (by decide)
    | cons aX wTail =>
      cases wTail with
      | nil =>
        cases tr with
        | cons hsX trNil =>
          cases trNil
          let qX' := RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole (wG true)
            (fun _ => hQ () + 1) (fun _ => qX) ()
          refine ⟨(), qX', rfl, trivial, ?_⟩
          cases hZero : Nat.beq rX 0 && Nat.beq rH 0 with
          | true =>
            have hrX : rX = 0 := CoreHelpers.natBeq_true_iff.mp (ListTests.and_left hZero)
            have hrH : rH = 0 := CoreHelpers.natBeq_true_iff.mp (ListTests.and_right hZero)
            have hx0 : cappedDistNat (x ()) qX = 0 := Nat.eq_zero_of_le_zero (hrX ▸ d_le)
            have hxEq : x () = qX := cappedDistNat_zero_iff.mp hx0
            have ha0 : distNat (aX.1 ()) (hQ ()) = 0 := Nat.eq_zero_of_le_zero
              (hrH ▸ hQ_dist aX (.head _) ())
            have haEq : aX.1 () = hQ () := wEq_of_distNat_zero ha0
            obtain ⟨_, rfl⟩ := hsX
            have hEqNext : RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole (wG true)
                (fun k => aX.1 k + 1) x () = qX' := by
              have hsub : x () - (aX.1 () + 1) = qX - (hQ () + 1) := by rw [hxEq, haEq]
              show x () - (aX.1 () + 1) + (if 4 ≤ x () - (aX.1 () + 1) then 3 else 0) =
                qX - (hQ () + 1) + (if 4 ≤ qX - (hQ () + 1) then 3 else 0)
              rw [hsub]
            rw [if_pos rfl, hEqNext, wSlackNat.refl qX']
            exact Nat.le_refl 0
          | false =>
            rw [if_neg (Bool.noConfusion)]
            exact Nat.le_trans (cappedDistNat_le _ _) (Nat.le_add_left 25 _)
      | cons _ _ => rw [id, id, Naturals.add_sub_cancel_left] at len; exact absurd (Nat.succ.inj len) (Naturals.succ_ne_zero _)
  step_excursion _ x qX _ _ _ _ _ _ x' _ _ _ _ _ :=
    Nat.le_trans (cappedDistNat_le (x' ()) qX) (Nat.le_add_left 25 _)

def wSimA : PolyComposition.OpenSubLaxSim (wholeSealedLeft wSp₁ wSp₂ wG_hide wWireObs)
    (fun _ _ => True) wObsL wRA (fun s => (s.1.1.2, s.2 ())) wDrawQA id wSlackLeft wSlackNat
    (fun x => x ()) wSimX.EpochX wSimX.EpochQX where
  Epoch _ _ := True
  EpochQ _ _ := True
  epoch_step _ _ _ _ _ _ _ := trivial
  epoch_proj _ _ _ := trivial
  gain r rX := if Nat.beq r 0 && Nat.beq rX 0 then 0 else r + rX + 25
  gain_mono {r₁ r₂ rX₁ rX₂} h1 hX := by
    cases h0 : Nat.beq r₁ 0 && Nat.beq rX₁ 0 with
    | true => exact Nat.zero_le _
    | false =>
      have h2 : (Nat.beq r₂ 0 && Nat.beq rX₂ 0) = false := by
        cases hr2 : Nat.beq r₂ 0 && Nat.beq rX₂ 0 with
        | false => rfl
        | true =>
          have hb1 := CoreHelpers.natBeq_true_iff.mp (ListTests.and_left hr2)
          have hb2 := CoreHelpers.natBeq_true_iff.mp (ListTests.and_right hr2)
          have hr1z : r₁ = 0 := Nat.eq_zero_of_le_zero (hb1 ▸ h1)
          have hrXz : rX₁ = 0 := Nat.eq_zero_of_le_zero (hb2 ▸ hX)
          rw [hr1z, hrXz] at h0
          exact Bool.noConfusion h0
      rw [if_neg Bool.false_ne_true, if_neg (h2 ▸ Bool.false_ne_true)]
      exact Nat.add_le_add_right (Nat.add_le_add h1 hX) 25
  ε := 0
  β r _ := r
  β_mono h _ := h
  β_ge_left _ _ := Nat.le_refl _
  η := 25
  drawMod r := r
  drawMod_mono h := h
  draw_lip _ s q r _ _ d_le := by
    show distNat ((if s.1.1.2 = 0 then 0 else 1) + 1) ((if q.1 = 0 then 0 else 1) + 1) ≤ r
    cases h0 : Nat.beq r 0 with
    | true =>
      have hr0 : r = 0 := CoreHelpers.natBeq_true_iff.mp h0
      have hd0 : cappedDistNat s.1.1.2 q.1 = 0 :=
        Nat.eq_zero_of_le_zero (Nat.le_trans (CoreHelpers.le_natMax_left _ _) (hr0 ▸ d_le))
      have heq : s.1.1.2 = q.1 := cappedDistNat_zero_iff.mp hd0
      rw [heq]
      cases Nat.decEq q.1 0 with
      | isTrue hq0 => rw [if_pos hq0]; exact Nat.zero_le r
      | isFalse hq0 => rw [if_neg hq0]; exact Nat.zero_le r
    | false =>
      have hpos : 1 ≤ r := Nat.pos_of_ne_zero (fun rz => Bool.noConfusion (rz ▸ h0))
      cases Nat.decEq s.1.1.2 0 with
      | isTrue hs0 =>
        rw [if_pos hs0]
        cases Nat.decEq q.1 0 with
        | isTrue hq0 => rw [if_pos hq0]; exact Nat.le_trans (by decide) hpos
        | isFalse hq0 => rw [if_neg hq0]; exact Nat.le_trans (by decide) hpos
      | isFalse hs0 =>
        rw [if_neg hs0]
        cases Nat.decEq q.1 0 with
        | isTrue hq0 => rw [if_pos hq0]; exact Nat.le_trans (by decide) hpos
        | isFalse hq0 => rw [if_neg hq0]; exact Nat.le_trans (by decide) hpos
  sim_block k s q qX r rX w s' _ _ _ d_le hw len tr := by
    cases w with
    | nil => rw [id, id, Naturals.add_sub_cancel_left] at len; exact absurd len (by decide)
    | cons a wTail =>
      cases wTail with
      | nil =>
        cases tr with
        | cons hsA trNil =>
          cases trNil
          have hx_le : cappedDistNat (a.1 ()) qX ≤ rX := (hw a (.head _)).2
          let obsC := wWireObs (wObsL (fun _ => qX)) (fun _ => q.2)
          let alEff := a.2.1 || (obsC.1 || obsC.2)
          let a1' := if alEff then q.1 - 1 else q.1
          let hDraw := (if q.1 = 0 then 1 else 2) + 1
          let xh' := RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole wG_hide
            (fun _ => hDraw) (fun _ => q.2) ()
          refine ⟨a.2.1, (a1', xh'), rfl, trivial, ?_⟩
          cases hZero : Nat.beq r 0 && Nat.beq rX 0 with
          | true =>
            have hr0 : r = 0 := CoreHelpers.natBeq_true_iff.mp (ListTests.and_left hZero)
            have hrX0 : rX = 0 := CoreHelpers.natBeq_true_iff.mp (ListTests.and_right hZero)
            have h1Eq : s.1.1.2 = q.1 := cappedDistNat_zero_iff.mp
              (Nat.eq_zero_of_le_zero (Nat.le_trans (CoreHelpers.le_natMax_left _ _) (hr0 ▸ d_le)))
            have h2Eq : s.2 () = q.2 := cappedDistNat_zero_iff.mp
              (Nat.eq_zero_of_le_zero (Nat.le_trans (CoreHelpers.le_natMax_right _ _) (hr0 ▸ d_le)))
            have hxEq : a.1 () = qX := cappedDistNat_zero_iff.mp
              (Nat.eq_zero_of_le_zero (hrX0 ▸ hx_le))
            obtain ⟨_, rfl⟩ := hsA
            have hObsEq : wObsL a.1 = wObsL (fun _ => qX) := by
              show Nat.blt (a.1 ()) 22 = Nat.blt qX 22; rw [hxEq]
            have hWireEq : wWireObs (wObsL a.1) s.2 = obsC := by
              show wholeWireObs wFlagOf id id (wObsL a.1) s.2 =
                wholeWireObs wFlagOf id id (wObsL (fun _ => qX)) (fun _ => q.2)
              dsimp only [wholeWireObs, wFlagOf]
              rw [hObsEq, h2Eq]
            have hSame : ((s.1.1.2, s.2 ()), s.1.1.2, s.2 ()).1 = (s.1.1.2, s.2 ()) := rfl
            have hPair : (((wholeSealedLeft wSp₁ wSp₂ wG_hide wWireObs).next s (wObsL a.1, a.2.1) a.2.2).1.1.2,
                ((wholeSealedLeft wSp₁ wSp₂ wG_hide wWireObs).next s (wObsL a.1, a.2.1) a.2.2).2 ()) =
                (a1', xh') := by
              apply Prod.ext
              · dsimp only [wholeSealedLeft, OpenComposition.OpenComponent.hide, wholeInnerBlk,
                  OpenComposition.OpenComponent.compose, ActiveInquiryLoop.componentOfBlanket, wSp₁, wSp₂]
                rw [hWireEq, h1Eq]
              · have hsub : s.2 () - ((if s.1.1.2 = 0 then 1 else 2) + 1) =
                    q.2 - ((if q.1 = 0 then 1 else 2) + 1) := by rw [h1Eq, h2Eq]
                show s.2 () - ((if s.1.1.2 = 0 then 1 else 2) + 1) +
                    (if 6 ≤ s.2 () - ((if s.1.1.2 = 0 then 1 else 2) + 1) then 2 else 0) =
                  q.2 - ((if q.1 = 0 then 1 else 2) + 1) +
                    (if 6 ≤ q.2 - ((if q.1 = 0 then 1 else 2) + 1) then 2 else 0)
                rw [hsub]
            rw [if_pos rfl, hPair, wSlackLeft.refl (a1', xh')]
            exact Nat.le_refl 0
          | false =>
            rw [if_neg (Bool.noConfusion)]
            exact Nat.le_trans (CoreHelpers.natMax_le (cappedDistNat_le _ _) (cappedDistNat_le _ _))
              (Nat.le_add_left 25 _)
      | cons _ _ => rw [id, id, Naturals.add_sub_cancel_left] at len; exact absurd (Nat.succ.inj len) (Naturals.succ_ne_zero _)
  step_excursion _ _ q _ _ _ _ _ _ _ s' _ _ _ _ _ _ _ :=
    Nat.le_trans (CoreHelpers.natMax_le (cappedDistNat_le _ _) (cappedDistNat_le _ _))
      (Nat.le_add_left 25 _)

def wSimB : PolyComposition.OpenSubLaxSim
    (wholeScopeOpen wBaseR (EndogenousOrder.scopeAdmitDec 1) EndogenousOrder.scopeFallback wProposeR)
    (fun _ _ => True) wObsR wRB (fun p => p.2) wDrawQB id wSlackNat wSlackNat
    (fun x => x ()) wSimX.EpochX wSimX.EpochQX where
  Epoch _ p := EndogenousOrder.scopeBase 2 1 1 (by decide : 1 ≤ 2) |>.K p
  EpochQ _ _ := True
  epoch_step _ s a s' hK _ hstep := by
    obtain ⟨_, rfl⟩ := hstep
    exact wCRight.cert.closed s ((wObsR a.1, a.2.1), a.2.2) _ ⟨trivial, rfl⟩ hK
  epoch_proj _ _ _ := trivial
  gain r rX := if Nat.beq r 0 && Nat.beq rX 0 then 0 else r + rX + 25
  gain_mono {r₁ r₂ rX₁ rX₂} h1 hX := by
    cases h0 : Nat.beq r₁ 0 && Nat.beq rX₁ 0 with
    | true => exact Nat.zero_le _
    | false =>
      have h2 : (Nat.beq r₂ 0 && Nat.beq rX₂ 0) = false := by
        cases hr2 : Nat.beq r₂ 0 && Nat.beq rX₂ 0 with
        | false => rfl
        | true =>
          have hb1 := CoreHelpers.natBeq_true_iff.mp (ListTests.and_left hr2)
          have hb2 := CoreHelpers.natBeq_true_iff.mp (ListTests.and_right hr2)
          have hr1z : r₁ = 0 := Nat.eq_zero_of_le_zero (hb1 ▸ h1)
          have hrXz : rX₁ = 0 := Nat.eq_zero_of_le_zero (hb2 ▸ hX)
          rw [hr1z, hrXz] at h0
          exact Bool.noConfusion h0
      rw [if_neg Bool.false_ne_true, if_neg (h2 ▸ Bool.false_ne_true)]
      exact Nat.add_le_add_right (Nat.add_le_add h1 hX) 25
  ε := 0
  β r _ := r
  β_mono h _ := h
  β_ge_left _ _ := Nat.le_refl _
  η := 25
  drawMod r := r
  drawMod_mono h := h
  draw_lip _ p q r _ hK d_le := by
    cases h0 : Nat.beq r 0 with
    | true =>
      have hr0 : r = 0 := CoreHelpers.natBeq_true_iff.mp h0
      have hpq : p.2 = q := cappedDistNat_zero_iff.mp (Nat.eq_zero_of_le_zero (hr0 ▸ d_le))
      cases p with | mk m ps =>
      cases m with
      | narrowUnmonitored =>
        have hpos : 0 < ps := hK.1
        have hqn : q ≠ 0 := fun hq0 => absurd (hq0 ▸ hpq) (Nat.ne_of_gt hpos)
        show distNat 2 (if q = 0 then 1 else 2) ≤ r
        rw [if_neg hqn]; exact Nat.zero_le _
      | wideReciprocal =>
        have hps0 : ps = 0 := hK
        have hq0 : q = 0 := hpq.symm.trans hps0
        show distNat 1 (if q = 0 then 1 else 2) ≤ r
        rw [if_pos hq0]; exact Nat.zero_le _
    | false =>
      have hpos : 1 ≤ r := Nat.pos_of_ne_zero (fun rz => Bool.noConfusion (rz ▸ h0))
      cases p with | mk m ps =>
      cases m with
      | narrowUnmonitored =>
        cases Nat.decEq q 0 with
        | isTrue hq0 => show distNat 2 (if q = 0 then 1 else 2) ≤ r; rw [if_pos hq0]; exact Nat.le_trans (by decide) hpos
        | isFalse hq0 => show distNat 2 (if q = 0 then 1 else 2) ≤ r; rw [if_neg hq0]; exact Nat.le_trans (by decide) hpos
      | wideReciprocal =>
        cases Nat.decEq q 0 with
        | isTrue hq0 => show distNat 1 (if q = 0 then 1 else 2) ≤ r; rw [if_pos hq0]; exact Nat.le_trans (by decide) hpos
        | isFalse hq0 => show distNat 1 (if q = 0 then 1 else 2) ≤ r; rw [if_neg hq0]; exact Nat.le_trans (by decide) hpos
  sim_block k p q qX r rX w p' hK _ _ d_le hw len tr := by
    cases w with
    | nil => rw [id, id, Naturals.add_sub_cancel_left] at len; exact absurd len (by decide)
    | cons a wTail =>
      cases wTail with
      | nil =>
        cases tr with
        | cons hsB trNil =>
          cases trNil
          have hx_le : cappedDistNat (a.1 ()) qX ≤ rX := (hw a (.head _)).2
          let obsR := wObsR (fun _ => qX)
          let modS : Σ m, EndogenousOrder.ScopeS m :=
            if q = 0 then ⟨.wideReciprocal, 0⟩ else ⟨.narrowUnmonitored, q⟩
          let nextS := (wholeScopeOpen wBaseR (EndogenousOrder.scopeAdmitDec 1)
            EndogenousOrder.scopeFallback wProposeR).next modS (obsR, a.2.1) ()
          refine ⟨a.2.1, nextS.2, rfl, trivial, ?_⟩
          cases hZero : Nat.beq r 0 && Nat.beq rX 0 with
          | true =>
            have hr0 : r = 0 := CoreHelpers.natBeq_true_iff.mp (ListTests.and_left hZero)
            have hrX0 : rX = 0 := CoreHelpers.natBeq_true_iff.mp (ListTests.and_right hZero)
            have hpq : p.2 = q := cappedDistNat_zero_iff.mp (Nat.eq_zero_of_le_zero (hr0 ▸ d_le))
            have hxEq : a.1 () = qX := cappedDistNat_zero_iff.mp (Nat.eq_zero_of_le_zero (hrX0 ▸ hx_le))
            have hModEq : p = modS := by
              cases p with | mk m ps =>
              cases m with
              | narrowUnmonitored =>
                have hq0 : q ≠ 0 := fun hz => absurd (hz ▸ hpq) (Nat.ne_of_gt hK.1)
                dsimp only [modS]; rw [if_neg hq0, ← hpq]
              | wideReciprocal =>
                have hps0 : ps = 0 := hK
                have hq0 : q = 0 := hpq.symm.trans hps0
                dsimp only [modS]; rw [if_pos hq0, hps0]
            have hObsEq : wObsR a.1 = obsR := by
              show Nat.blt (a.1 ()) 22 = Nat.blt qX 22; rw [hxEq]
            obtain ⟨_, rfl⟩ := hsB
            have hEq : (wholeScopeOpen wBaseR (EndogenousOrder.scopeAdmitDec 1)
                EndogenousOrder.scopeFallback wProposeR).next p (wObsR a.1, a.2.1) () = nextS := by
              rw [hModEq, hObsEq]
            rw [if_pos rfl, hEq, wSlackNat.refl nextS.2]
            exact Nat.le_refl 0
          | false =>
            rw [if_neg (Bool.noConfusion)]
            exact Nat.le_trans (cappedDistNat_le _ _) (Nat.le_add_left 25 _)
      | cons _ _ => rw [id, id, Naturals.add_sub_cancel_left] at len; exact absurd (Nat.succ.inj len) (Naturals.succ_ne_zero _)
  step_excursion _ _ q _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ :=
    Nat.le_trans (cappedDistNat_le _ _) (Nat.le_add_left 25 _)

def wMacroGuard (q : Nat × ((Nat × Nat) × Nat)) : Prop :=
  ((q.2.1.1 = 0 ∧ q.2.2 = 0 ∧ 16 ≤ q.1) ∨ (20 ≤ q.1 ∧ q.1 ≤ 21)) ∧
    q.2.1.1 ≤ 1 ∧ 8 + q.2.1.1 * 3 ≤ q.2.1.2 ∧ q.2.2 ≤ 1

def wCertQ : Viability.Certificate
    (PolyComposition.coupledMacroProcess wRX wRA wRB wDrawQA wDrawQB) wMacroGuard wMacroGuard where
  within _ h := h
  closed q b q' hstep hK := by
    obtain ⟨hRx, hRa, hRb⟩ := hstep
    dsimp only [wMacroGuard]
    rw [hRx, hRa, hRb]
    obtain ⟨hBranch, hA1, hH, hB⟩ := hK
    cases hBranch with
    | inl hPost =>
      obtain ⟨hq1, hqb, hqx16⟩ := hPost
      have hDrawX : wDrawQA q.2.1 () + wDrawQB q.2.2 () = 2 := by
        show (if q.2.1.1 = 0 then 0 else 1) + 1 + (if q.2.2 = 0 then 1 else 2) = 2
        rw [hq1, hqb]
        rfl
      have hQx' : RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole (wG true)
          (fun _ => wDrawQA q.2.1 () + wDrawQB q.2.2 () + 1) (fun _ => q.1) () = q.1 := by
        dsimp only [RegimeMargin.Coupled.Indexed.step, RegimeMargin.Coupled.Indexed.left,
          RegimeMargin.Drawn.whole, Amounts.whole, wG]
        rw [hDrawX]
        show q.1 - 3 + (if 4 ≤ q.1 - 3 then 3 else 0) = q.1
        rw [if_pos (Nat.le_trans (by decide : 4 ≤ 13) (Naturals.le_sub_of_add_le hqx16))]
        exact Naturals.sub_add_cancel (Nat.le_trans (by decide : 3 ≤ 16) hqx16)
      have hA1' : (if b.2.1 || (wFlagOf (wObsL fun _ => q.1) (fun _ => q.2.1.2) ||
            wFlagOf (wObsL fun _ => q.1) (fun _ => q.2.1.2)) then q.2.1.1 - 1 else q.2.1.1) = 0 := by
        rw [hq1]; cases (b.2.1 || _) <;> rfl
      have hB' : ((wholeScopeOpen wBaseR (EndogenousOrder.scopeAdmitDec 1)
            EndogenousOrder.scopeFallback wProposeR).next
            (if q.2.2 = 0 then ⟨.wideReciprocal, 0⟩ else ⟨.narrowUnmonitored, q.2.2⟩)
            (wObsR fun _ => q.1, b.2.2) ()).2 = 0 := by
        rw [hqb]
        cases wObsR (fun _ => q.1) <;> cases b.2.2 <;> rfl
      have hH8 : 8 ≤ q.2.1.2 := by rw [hq1] at hH; exact hH
      have hH' : 8 ≤ q.2.1.2 - ((if q.2.1.1 = 0 then 1 else 2) + 1) +
          wG_hide () (fun _ => q.2.1.2 - ((if q.2.1.1 = 0 then 1 else 2) + 1)) := by
        rw [hq1]
        show 8 ≤ q.2.1.2 - 2 + (if 6 ≤ q.2.1.2 - 2 then 2 else 0)
        rw [if_pos (Naturals.le_sub_of_add_le hH8)]
        rw [Naturals.sub_add_cancel (Nat.le_trans (by decide : 2 ≤ 8) hH8)]
        exact hH8
      refine ⟨.inl ⟨hA1', hB', ?_⟩, ?_, ?_, ?_⟩
      · rw [hQx']; exact hqx16
      · dsimp only [wWireObs, wholeWireObs, id]; erw [hA1']; exact Nat.zero_le 1
      · dsimp only [wWireObs, wholeWireObs, id]; erw [hA1']; exact hH'
      · rw [hB']; exact Nat.zero_le 1
    | inr hPre =>
      obtain ⟨hq20, hq21⟩ := hPre
      have hLt22 : wObsL (fun _ => q.1) = true :=
        CoreHelpers.natBlt_true_iff.mpr (Nat.lt_of_le_of_lt hq21 (by decide))
      have hDrawLe : wDrawQA q.2.1 () + wDrawQB q.2.2 () ≤ 4 := by
        show (if q.2.1.1 = 0 then 0 else 1) + 1 + (if q.2.2 = 0 then 1 else 2) ≤ 4
        cases Nat.decEq q.2.1.1 0 with
        | isTrue h10 =>
          rw [if_pos h10]
          cases Nat.decEq q.2.2 0 with
          | isTrue h20 => rw [if_pos h20]; exact by decide
          | isFalse h20 => rw [if_neg h20]; exact by decide
        | isFalse h10 =>
          rw [if_neg h10]
          cases Nat.decEq q.2.2 0 with
          | isTrue h20 => rw [if_pos h20]; exact by decide
          | isFalse h20 => rw [if_neg h20]; exact by decide
      have hSub15 : 15 ≤ q.1 - (wDrawQA q.2.1 () + wDrawQB q.2.2 () + 1) := by
        have hSum5 : wDrawQA q.2.1 () + wDrawQB q.2.2 () + 1 ≤ 5 := Nat.succ_le_succ hDrawLe
        exact Naturals.le_sub_of_add_le (Nat.le_trans (Nat.add_le_add_right hSum5 15) hq20)
      have hGe4 : 4 ≤ q.1 - (wDrawQA q.2.1 () + wDrawQB q.2.2 () + 1) :=
        Nat.le_trans (by decide : 4 ≤ 15) hSub15
      have hQx16' : 16 ≤ RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole (wG true)
          (fun _ => wDrawQA q.2.1 () + wDrawQB q.2.2 () + 1) (fun _ => q.1) () := by
        dsimp only [RegimeMargin.Coupled.Indexed.step, RegimeMargin.Drawn.whole]
        show 16 ≤ q.1 - (wDrawQA q.2.1 () + wDrawQB q.2.2 () + 1) +
          (if 4 ≤ q.1 - (wDrawQA q.2.1 () + wDrawQB q.2.2 () + 1) then 3 else 0)
        rw [if_pos hGe4]
        exact Nat.le_trans (by decide : 16 ≤ 15 + 3) (Nat.add_le_add_right hSub15 3)
      have hA1' : (if b.2.1 || (wFlagOf (wObsL fun _ => q.1) (fun _ => q.2.1.2) ||
            wFlagOf (wObsL fun _ => q.1) (fun _ => q.2.1.2)) then q.2.1.1 - 1 else q.2.1.1) = 0 := by
        have hFlag : wFlagOf (wObsL fun _ => q.1) (fun _ => q.2.1.2) = true := by
          dsimp only [wFlagOf]; rw [hLt22]; rfl
        rw [hFlag]
        have hOr : (b.2.1 || (true || true)) = true := by cases b.2.1 <;> rfl
        rw [hOr]
        cases hq1 : q.2.1.1 with
        | zero => rfl
        | succ m =>
          cases m with
          | zero => rfl
          | succ m' => exact absurd (hq1 ▸ hA1) (Nat.not_le_of_gt (Nat.lt_of_lt_of_le (by decide : 1 < 2) (Nat.le_add_left 2 m')))
      have hB' : ((wholeScopeOpen wBaseR (EndogenousOrder.scopeAdmitDec 1)
            EndogenousOrder.scopeFallback wProposeR).next
            (if q.2.2 = 0 then ⟨.wideReciprocal, 0⟩ else ⟨.narrowUnmonitored, q.2.2⟩)
            (wObsR fun _ => q.1, b.2.2) ()).2 = 0 := by
        have hObsR : wObsR (fun _ => q.1) = true := hLt22
        dsimp only [wholeScopeOpen, polyUniformToOpenComponent, PolyComposition.anchoredSelfModComponent]
        cases hqb : q.2.2 with
        | zero => cases b.2.2 <;> rw [hObsR] <;> rfl
        | succ m =>
          cases m with
          | zero =>
            rw [if_neg (by decide : ¬ (1 = 0)), hObsR]
            cases b.2.2 <;> rfl
          | succ m' => exact absurd (hqb ▸ hB) (Nat.not_le_of_gt (Nat.lt_of_lt_of_le (by decide : 1 < 2) (Nat.le_add_left 2 m')))
      have hH' : 8 ≤ q.2.1.2 - ((if q.2.1.1 = 0 then 1 else 2) + 1) +
          wG_hide () (fun _ => q.2.1.2 - ((if q.2.1.1 = 0 then 1 else 2) + 1)) := by
        cases hq1 : q.2.1.1 with
        | zero =>
          have hH8 : 8 ≤ q.2.1.2 := by rw [hq1] at hH; exact hH
          show 8 ≤ q.2.1.2 - 2 + (if 6 ≤ q.2.1.2 - 2 then 2 else 0)
          rw [if_pos (Naturals.le_sub_of_add_le hH8),
            Naturals.sub_add_cancel (Nat.le_trans (by decide : 2 ≤ 8) hH8)]
          exact hH8
        | succ m =>
          cases m with
          | zero =>
            have hH11 : 11 ≤ q.2.1.2 := by rw [hq1] at hH; exact hH
            have hH8' : 8 ≤ q.2.1.2 - 3 := Naturals.le_sub_of_add_le hH11
            have hH6' : 6 ≤ q.2.1.2 - 3 := Nat.le_trans (by decide : 6 ≤ 8) hH8'
            show 8 ≤ q.2.1.2 - 3 + (if 6 ≤ q.2.1.2 - 3 then 2 else 0)
            rw [if_pos hH6']
            exact Nat.le_trans hH8' (Nat.le_add_right _ 2)
          | succ m' => exact absurd (hq1 ▸ hA1) (Nat.not_le_of_gt (Nat.lt_of_lt_of_le (by decide : 1 < 2) (Nat.le_add_left 2 m')))
      refine ⟨.inl ⟨hA1', hB', hQx16'⟩, ?_, ?_, ?_⟩
      · dsimp only [wWireObs, wholeWireObs, id]; erw [hA1']; exact Nat.zero_le 1
      · dsimp only [wWireObs, wholeWireObs, id]; erw [hA1']; exact hH'
      · rw [hB']; exact Nat.zero_le 1

/-! ### Non-Constant `CausalGoAlike` Quotient on `CausalSystem.ofOpenComponent wCompOp` -/

abbrev WCausalQ := Nat × Nat × (Σ _ : EndogenousOrder.ScopeMode, Nat)

def wPiCausal (s : WOpS) : WCausalQ := (s.1.1.1.2, s.1.2 (), s.2)

theorem wCausal_goAlike :
    CausalGoAlike (CausalSystem.ofOpenComponent wCompOp wCOp.tol) wPiCausal id := by
  intro i i' s s' a u u' hi hpi hs hs'
  dsimp only [CausalSystem.ofOpenComponent] at hs hs'
  rcases hs with ⟨_, rfl⟩
  rcases hs' with ⟨_, rfl⟩
  subst hi
  have h1 : s.1.1.1.2 = s'.1.1.1.2 := congrArg Prod.fst hpi
  have h2 : s.1.2 () = s'.1.2 () := congrArg (fun p => p.2.1) hpi
  have h3 : s.2 = s'.2 := congrArg (fun p => p.2.2) hpi
  dsimp only [wPiCausal, wCompOp, wholeOp, wholeSealedLeft, wholeInnerBlk, wholeScopeOpen,
    OpenComposition.OpenComponent.compose, OpenComposition.OpenComponent.hide,
    ActiveInquiryLoop.componentOfBlanket, polyUniformToOpenComponent,
    PolyComposition.anchoredSelfModComponent, wWireObs, wholeWireObs, wFlagOf, wSp₁, wSp₂, id]
  apply Prod.ext
  · show (if (portOverride i a.1).2 ||
        ((portOverride i a.1).1.1 || Nat.blt (s.1.2 ()) 14 ||
         ((portOverride i a.1).1.1 || Nat.blt (s.1.2 ()) 14)) then
        s.1.1.1.2 - 1 else s.1.1.1.2) =
      (if (portOverride i a.1).2 ||
        ((portOverride i a.1).1.1 || Nat.blt (s'.1.2 ()) 14 ||
         ((portOverride i a.1).1.1 || Nat.blt (s'.1.2 ()) 14)) then
        s'.1.1.1.2 - 1 else s'.1.1.1.2)
    rw [h1, h2]
  · apply Prod.ext
    · have hc : (if s.1.1.1.2 = 0 then 1 else 2) + 1 = (if s'.1.1.1.2 = 0 then 1 else 2) + 1 := by rw [h1]
      change RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole wG_hide
          (fun _ => (if s.1.1.1.2 = 0 then 1 else 2) + 1) s.1.2 () =
        RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole wG_hide
          (fun _ => (if s'.1.1.1.2 = 0 then 1 else 2) + 1) s'.1.2 ()
      have hsub : s.1.2 () - ((if s.1.1.1.2 = 0 then 1 else 2) + 1) =
          s'.1.2 () - ((if s'.1.1.1.2 = 0 then 1 else 2) + 1) := by rw [h1, h2]
      show s.1.2 () - ((if s.1.1.1.2 = 0 then 1 else 2) + 1) +
          (if 6 ≤ s.1.2 () - ((if s.1.1.1.2 = 0 then 1 else 2) + 1) then 2 else 0) =
        s'.1.2 () - ((if s'.1.1.1.2 = 0 then 1 else 2) + 1) +
          (if 6 ≤ s'.1.2 () - ((if s'.1.1.1.2 = 0 then 1 else 2) + 1) then 2 else 0)
      rw [hsub]
    · show (match EndogenousOrder.scopeAdmitDec 1 s.2
          (wProposeR s.2 ((portOverride i a.1).1.2, (portOverride i a.1).2) a.2.2)
          (portOverride i a.1).2 with
        | true => wProposeR s.2 ((portOverride i a.1).1.2, (portOverride i a.1).2) a.2.2
        | false => EndogenousOrder.scopeFallback s.2 ((portOverride i a.1).1.2, (portOverride i a.1).2) a.2.2) =
        (match EndogenousOrder.scopeAdmitDec 1 s'.2
          (wProposeR s'.2 ((portOverride i a.1).1.2, (portOverride i a.1).2) a.2.2)
          (portOverride i a.1).2 with
        | true => wProposeR s'.2 ((portOverride i a.1).1.2, (portOverride i a.1).2) a.2.2
        | false => EndogenousOrder.scopeFallback s'.2 ((portOverride i a.1).1.2, (portOverride i a.1).2) a.2.2)
      rw [h3]

theorem wCausal_nonconst : ∃ s₁ s₂ : WOpS, wPiCausal s₁ ≠ wPiCausal s₂ :=
  ⟨wInitOp, (((((), 0), ((), 1)), fun _ => 11), wInitR),
    fun h => Nat.noConfusion (congrArg Prod.fst h)⟩

/-! ### Persisting Ecological Trace Tracking `w_r_full` & Lineages Raising -/

inductive EvoPlace : Type where
  | subPool
  | subRegen
  | subAgent
  | wideLin (t : Nat)
  | narrowLin

def wEvoLevel : Nat → EvoPlace → Nat
  | t, .subPool => (w_r_full.state (1 + t)).1 ()
  | t, .wideLin m => if t = m then 1 else 0
  | _, .subRegen => 10
  | _, .subAgent => 10
  | _, .narrowLin => 10

def wWEvo : Web EvoPlace EvoPlace where
  level := wEvoLevel
  active
    | _, .wideLin _ => True
    | _, .subRegen => True
    | _, .subAgent => True
    | _, .subPool => True
    | _, .narrowLin => False
  requires _ f c := match f with
    | .wideLin _ => match c with
      | .subPool => True
      | .subRegen | .subAgent | .wideLin _ | .narrowLin => False
    | .subPool | .subRegen | .subAgent | .narrowLin => False
  need _ f c := match f with
    | .wideLin _ => match c with
      | .subPool => 8
      | .subRegen | .subAgent | .wideLin _ | .narrowLin => 0
    | .subPool | .subRegen | .subAgent | .narrowLin => 0
  draws _ f c := match f with
    | .subAgent => match c with
      | .subPool => True
      | .subRegen | .subAgent | .wideLin _ | .narrowLin => False
    | .subPool | .subRegen | .wideLin _ | .narrowLin => False

def wLEvo : Flow EvoPlace EvoPlace where
  present t := [.wideLin t, .subRegen, .subAgent]
  take t f c := match f with
    | .subAgent => match c with
      | .subPool => match t with | 0 => 5 | _ + 1 => 3
      | .subRegen | .subAgent | .wideLin _ | .narrowLin => 0
    | .subPool | .subRegen | .wideLin _ | .narrowLin => 0
  give t f c := match f with
    | .subRegen => match c with
      | .subPool => 3
      | .subRegen | .subAgent | .wideLin _ | .narrowLin => 0
    | .wideLin t' => match c with
      | .wideLin t'' => if Nat.beq t t' && Nat.beq t'' (t + 1) then 1 else 0
      | .subPool | .subRegen | .subAgent | .narrowLin => 0
    | .subPool | .subAgent | .narrowLin => 0

def wGEvo : SelectionTerm.Generations EvoPlace where
  first := [.wideLin 0, .narrowLin]
  kids t
    | .wideLin _ => [.wideLin (t + 1)]
    | .subPool | .subRegen | .subAgent | .narrowLin => []
  amount _
    | .wideLin _ => 2
    | .narrowLin => 1
    | .subPool | .subRegen | .subAgent => 0

theorem wEvo_acting : wLEvo.Acting wWEvo := by
  intro t f c _ hpos
  dsimp only [wLEvo] at hpos
  cases f with
  | wideLin n =>
    cases c with
    | wideLin m => exact trivial
    | subPool | subRegen | subAgent | narrowLin =>
      exact absurd hpos (by cases t <;> exact Nat.lt_irrefl 0)
  | subRegen => exact trivial
  | subAgent => exact trivial
  | subPool =>
    cases c <;> exact absurd hpos (by cases t <;> exact Nat.lt_irrefl 0)
  | narrowLin =>
    cases c <;> exact absurd hpos (by cases t <;> exact Nat.lt_irrefl 0)

theorem wEvo_family_eq : ∀ t : Nat, wGEvo.family t = [.wideLin t] ∨ (t = 0 ∧ wGEvo.family t = [.wideLin 0, .narrowLin])
  | 0 => .inr ⟨rfl, rfl⟩
  | 1 => .inl rfl
  | t + 2 => by
    cases wEvo_family_eq (t + 1) with
    | inl heq =>
      left
      change (wGEvo.family (t + 1)).flatMap (wGEvo.kids (t + 1)) = [.wideLin (t + 2)]
      rw [heq]; rfl
    | inr h0 => exact absurd h0.1 (Naturals.succ_ne_zero t)

theorem wEvo_descended : SelectionTerm.Flow.Descended wLEvo wWEvo wGEvo := by
  intro t p k mp mk
  cases t with
  | zero =>
    cases mp with
    | head =>
      cases mk with
      | head =>
        refine ⟨.head _, Nat.zero_lt_one, Nat.lt_irrefl 0, ?_⟩
        show 0 < 1; exact Nat.zero_lt_one
      | tail _ no => nomatch no
    | tail _ mp2 =>
      cases mp2 with
      | head => nomatch mk
      | tail _ no => nomatch no
  | succ s =>
    have hf : wGEvo.family (s + 1) = [.wideLin (s + 1)] := by
      cases wEvo_family_eq (s + 1) with
      | inl h => exact h
      | inr h => exact absurd h.1 (Naturals.succ_ne_zero s)
    rw [hf] at mp
    cases mp with
    | head =>
      cases mk with
      | head =>
        refine ⟨.head _, ?_, ?_, ?_⟩
        · show 0 < if Nat.beq (s + 1) (s + 1) && Nat.beq (s + 2) (s + 2) then 1 else 0
          rw [CoreHelpers.natBeq_true_iff.mpr rfl, CoreHelpers.natBeq_true_iff.mpr rfl]
          exact Nat.zero_lt_one
        · show ¬ 0 < if s + 1 = s + 2 then 1 else 0
          rw [if_neg (Nat.succ_ne_self (s + 1)).symm]
          exact Nat.lt_irrefl 0
        · show 0 < if s + 2 = s + 2 then 1 else 0
          rw [if_pos rfl]
          exact Nat.zero_lt_one
      | tail _ no => nomatch no
    | tail _ no => nomatch no

theorem wEvo_exact : ∀ t,
    SelectionTerm.Exact (wGEvo.family t) (wGEvo.kids t) (wGEvo.amount t) (wGEvo.amount (t + 1)) := by
  intro t p mp k mk
  cases t with
  | zero =>
    cases mp with
    | head =>
      cases mk with
      | head => rfl
      | tail _ no => nomatch no
    | tail _ mp2 =>
      cases mp2 with
      | head => nomatch mk
      | tail _ no => nomatch no
  | succ s =>
    have hf : wGEvo.family (s + 1) = [.wideLin (s + 1)] := by
      cases wEvo_family_eq (s + 1) with
      | inl h => exact h
      | inr h => exact absurd h.1 (Naturals.succ_ne_zero s)
    rw [hf] at mp
    cases mp with
    | head =>
      cases mk with
      | head => rfl
      | tail _ no => nomatch no
    | tail _ no => nomatch no

def wEvoLgs : List (List EvoPlace) := [[.wideLin 0], [.narrowLin]]

def wEvoVal : List EvoPlace → Nat
  | [] => 0
  | x :: [] => match x with
    | .wideLin _ => 2
    | .narrowLin => 1
    | .subPool | .subRegen | .subAgent => 0
  | _ :: _ :: _ => 0

/-! ### Collapsing Overdraw Trace (`L_bad`) & `OrderUpdater` Converging at `T_ord = 3` -/

inductive BadPlace : Type where
  | cBad
  | badAgent (t : Nat)
  | goodLin (t : Nat)

def wBadLevelFn : Nat → Nat
  | 0 => 21
  | 1 => 14
  | 2 => 8
  | 3 => 7
  | _ => 0

def wBadTakeFn : Nat → Nat
  | 0 => 7
  | 1 => 6
  | 2 => 1
  | 3 => 7
  | _ => 0

def wWBad : Web BadPlace BadPlace where
  level t f := match f with
    | .cBad => wBadLevelFn t
    | .badAgent n => match n with
      | 0 => 0
      | 1 => if t = 0 then 0 else 1
      | 2 => if t ≤ 1 then 0 else 1
      | _ + 3 => 0
    | .goodLin _ => 0
  active t f := match f with
    | .badAgent n => match t with
      | 0 => match n with | 0 => True | _ + 1 => False
      | 1 => match n with | 0 => False | 1 => True | _ + 2 => False
      | 2 => match n with | 0 => False | 1 => False | 2 => True | _ + 3 => False
      | _ + 3 => False
    | .goodLin _ => True
    | .cBad => False
  requires _ f c := match f with
    | .badAgent _ => match c with | .cBad => True | .badAgent _ | .goodLin _ => False
    | .cBad | .goodLin _ => False
  need _ f c := match f with
    | .badAgent _ => match c with | .cBad => 8 | .badAgent _ | .goodLin _ => 0
    | .cBad | .goodLin _ => 0
  draws t f c := match f with
    | .badAgent t' => match c with | .cBad => t = t' ∧ t ≤ 3 | .badAgent _ | .goodLin _ => False
    | .cBad | .goodLin _ => False

def wLBad : Flow BadPlace BadPlace where
  present
    | 0 => [.badAgent 0]
    | 1 => [.badAgent 1]
    | 2 => [.badAgent 2]
    | 3 => [.badAgent 3]
    | _ + 4 => []
  take t f c := match f with
    | .badAgent t' => match c with
      | .cBad => if Nat.beq t t' then wBadTakeFn t else 0
      | .badAgent _ | .goodLin _ => 0
    | .cBad | .goodLin _ => 0
  give t f c := match f with
    | .badAgent t' => match c with
      | .badAgent t'' => if Nat.ble t 1 && Nat.beq t t' && Nat.beq t'' (t + 1) then 1 else 0
      | .cBad | .goodLin _ => 0
    | .cBad | .goodLin _ => 0

theorem wBad_balances : wLBad.Balances wWBad := by
  intro t c
  cases c with
  | cBad =>
    match t with
    | 0 | 1 | 2 | 3 | _ + 4 => rfl
  | badAgent n =>
    match n, t with
    | 0, 0 | 0, 1 | 0, 2 | 0, 3 | 0, _ + 4 => rfl
    | 1, 0 | 1, 1 | 1, 2 | 1, 3 | 1, _ + 4 => rfl
    | 2, 0 | 2, 1 | 2, 2 | 2, 3 | 2, _ + 4 => rfl
    | _ + 3, 0 | _ + 3, 1 | _ + 3, 2 | _ + 3, 3 | _ + 3, _ + 4 => rfl
  | goodLin _ =>
    match t with
    | 0 | 1 | 2 | 3 | _ + 4 => rfl

theorem wBad_acting : wLBad.Acting wWBad := by
  intro t f c mem hpos
  match t with
  | 0 =>
    cases mem with
    | head => exact trivial
    | tail _ no => nomatch no
  | 1 =>
    cases mem with
    | head => exact trivial
    | tail _ no => nomatch no
  | 2 =>
    cases mem with
    | head => exact trivial
    | tail _ no => nomatch no
  | 3 =>
    cases mem with
    | head =>
      cases c with
      | cBad | goodLin _ => exact absurd hpos (Nat.not_lt_zero 0)
      | badAgent t' =>
        change 0 < (if false && Nat.beq 3 3 && Nat.beq t' 4 then 1 else 0) at hpos
        rw [Bool.false_and, Bool.false_and, if_neg Bool.false_ne_true] at hpos
        exact absurd hpos (Nat.not_lt_zero 0)
    | tail _ no => nomatch no
  | _ + 4 => nomatch mem

theorem wBad_dependent : wWBad.Dependent := by
  intro t f hact c hreq
  cases f with
  | badAgent n =>
    cases c with
    | cBad =>
      match t, n with
      | 0, 0 => exact by decide
      | 1, 1 => exact by decide
      | 2, 2 => exact by decide
      | 0, _ + 1 | 1, 0 | 1, _ + 2 | 2, 0 | 2, 1 | 2, _ + 3 | _ + 3, _ => exact False.elim hact
    | badAgent _ | goodLin _ => exact False.elim hreq
  | cBad | goodLin _ => exact False.elim hreq

def wGBad : SelectionTerm.Generations BadPlace where
  first := [.badAgent 0]
  kids t f := match f with
    | .badAgent n => match t with
      | 0 => match n with | 0 => [.badAgent 1] | _ + 1 => []
      | 1 => match n with | 0 => [] | 1 => [.badAgent 2] | _ + 2 => []
      | _ + 2 => []
    | .cBad | .goodLin _ => []
  amount _ _ := 1

theorem wGBad_family : ∀ t,
    wGBad.family t = match t with
      | 0 => [.badAgent 0]
      | 1 => [.badAgent 1]
      | 2 => [.badAgent 2]
      | _ => []
  | 0 => rfl
  | 1 => rfl
  | 2 => rfl
  | 3 => rfl
  | t + 4 => by
    have ih := wGBad_family (t + 3)
    change (wGBad.family (t + 3)).flatMap (wGBad.kids (t + 3)) = []
    rw [ih]
    rfl

theorem wGBad_descended : SelectionTerm.Flow.Descended wLBad wWBad wGBad := by
  intro t p k mp mk
  match t with
  | 0 =>
    cases mp with
    | head =>
      cases mk with
      | head => exact ⟨.head _, by decide, by decide, by decide⟩
      | tail _ no => nomatch no
    | tail _ no => nomatch no
  | 1 =>
    rw [wGBad_family 1] at mp
    cases mp with
    | head =>
      cases mk with
      | head => exact ⟨.head _, by decide, by decide, by decide⟩
      | tail _ no => nomatch no
    | tail _ no => nomatch no
  | 2 =>
    rw [wGBad_family 2] at mp
    cases mp with
    | head => nomatch mk
    | tail _ no => nomatch no
  | t' + 3 =>
    rw [wGBad_family (t' + 3)] at mp
    nomatch mp

def wOrdItems : List (Nat × BadPlace) :=
  [(0, .badAgent 0), (1, .badAgent 1), (2, .badAgent 2), (4, .goodLin 4)]

def wOrdOwn : Nat × BadPlace → Bool
  | (_, .goodLin _) => true
  | (_, .cBad) | (_, .badAgent _) => false

def wUOrd : EndogenousOrder.OrderUpdater (Nat × BadPlace) where
  items := wOrdItems
  own := wOrdOwn
  initPos _ := 0
  base _ := 0
  stepGain := 1

def wFeedbackOrd (_ : Nat) (x : Nat × BadPlace) : Bool := wOrdOwn x

def wAOrd (x : Nat × BadPlace) : Bool :=
  match x.2 with
  | .badAgent n => Nat.beq x.1 n && Nat.ble x.1 2
  | .goodLin n => Nat.beq x.1 4 && Nat.beq n 4
  | .cBad => false

def wBOrd (x : Nat × BadPlace) : Bool :=
  match x.2 with
  | .badAgent n => Nat.beq x.1 n && Nat.ble x.1 2
  | .goodLin _ | .cBad => false

/-! ### Grounded `CourseRealization` Pair `(wCR_ungated, wCR_gated)` Matching `w_r_full` at `S₀ = 21` -/

inductive WNashAct : Type where
  | restrain
  | overdraw

inductive WNashForm : Type where
  | f1
  | f2
  | renewer
  | gateKeeper
  | baseAgent

inductive WNashCond : Type where
  | cPool
  | cGate1
  | cGate2

def wNashActs : List WNashAct := [.restrain, .overdraw]

def wNarrowMenu : WNashAct → Bool
  | .restrain => true
  | .overdraw => false

def wWideMenu : WNashAct → Bool
  | .restrain => true
  | .overdraw => true

def wDrawOf : WNashAct → Nat
  | .restrain => 1
  | .overdraw => 4

def wYieldOf : WNashAct → Nat
  | .restrain => 2
  | .overdraw => 5

def wBaseDraw : Nat → Nat
  | 0 => 3
  | _ + 1 => 1

def wGateOpen (gated : Bool) (act : WNashAct) : Nat → Bool
  | 0 => true
  | _ + 1 => match gated with
    | false => true
    | true => match act with
      | .restrain => true
      | .overdraw => false

def wPoolStep (gated : Bool) (x y : WNashAct) : Nat → Nat
  | 0 => 21
  | t + 1 =>
    let s := wPoolStep gated x y t
    let t1 := if 14 ≤ s ∧ wGateOpen gated x t = true then wDrawOf x else 0
    let t2 := if 14 ≤ s ∧ wGateOpen gated y t = true then wDrawOf y else 0
    let tb := if 14 ≤ s then wBaseDraw t else 0
    let g := if 16 ≤ s then 3 else 0
    s - (t1 + t2 + tb) + g

def wPoolTake1 (gated : Bool) (x y : WNashAct) (t : Nat) : Nat :=
  if 14 ≤ wPoolStep gated x y t ∧ wGateOpen gated x t = true then wDrawOf x else 0

def wPoolTake2 (gated : Bool) (x y : WNashAct) (t : Nat) : Nat :=
  if 14 ≤ wPoolStep gated x y t ∧ wGateOpen gated y t = true then wDrawOf y else 0

def wPoolTakeBase (gated : Bool) (x y : WNashAct) (t : Nat) : Nat :=
  if 14 ≤ wPoolStep gated x y t then wBaseDraw t else 0

def wPoolTakeGate : Bool → WNashAct → Nat → Nat
  | true, .overdraw, 0 => 1
  | true, .overdraw, _ + 1 => 0
  | true, .restrain, _ => 0
  | false, .restrain, _ => 0
  | false, .overdraw, _ => 0

def wPoolGive (gated : Bool) (x y : WNashAct) (t : Nat) : Nat :=
  if 16 ≤ wPoolStep gated x y t then 3 else 0

theorem wPoolStep_rr (gated : Bool) : ∀ t : Nat,
    wPoolStep gated .restrain .restrain t = if t = 0 then 21 else 19
  | 0 => rfl
  | 1 => by cases gated <;> rfl
  | t + 2 => by
    have ih := wPoolStep_rr gated (t + 1)
    have h19 : wPoolStep gated .restrain .restrain (t + 1) = 19 := ih
    show (let s := wPoolStep gated .restrain .restrain (t + 1)
      let t1 := if 14 ≤ s ∧ wGateOpen gated .restrain (t + 1) = true then 1 else 0
      let t2 := if 14 ≤ s ∧ wGateOpen gated .restrain (t + 1) = true then 1 else 0
      let tb := if 14 ≤ s then 1 else 0
      let g := if 16 ≤ s then 3 else 0
      s - (t1 + t2 + tb) + g) = 19
    have hg : wGateOpen gated .restrain (t + 1) = true := by cases gated <;> rfl
    rw [h19, hg]
    rfl

theorem wPoolStep_oo (gated : Bool) : ∀ t : Nat,
    wPoolStep gated .overdraw .overdraw (t + 1) = 13
  | 0 => rfl
  | t + 1 => by
    have ih := wPoolStep_oo gated t
    show (let s := wPoolStep gated .overdraw .overdraw (t + 1)
      let t1 := if 14 ≤ s ∧ wGateOpen gated .overdraw (t + 1) = true then 4 else 0
      let t2 := if 14 ≤ s ∧ wGateOpen gated .overdraw (t + 1) = true then 4 else 0
      let tb := if 14 ≤ s then 1 else 0
      let g := if 16 ≤ s then 3 else 0
      s - (t1 + t2 + tb) + g) = 13
    rw [ih]
    rfl

theorem wPoolStep_ungated_or : ∀ t : Nat,
    wPoolStep false .overdraw .restrain (t + 2) = 13
  | 0 => rfl
  | t + 1 => by
    have ih := wPoolStep_ungated_or t
    show (let s := wPoolStep false .overdraw .restrain (t + 2)
      let t1 := if 14 ≤ s ∧ wGateOpen false .overdraw (t + 2) = true then 4 else 0
      let t2 := if 14 ≤ s ∧ wGateOpen false .restrain (t + 2) = true then 1 else 0
      let tb := if 14 ≤ s then 1 else 0
      let g := if 16 ≤ s then 3 else 0
      s - (t1 + t2 + tb) + g) = 13
    rw [ih]
    rfl

theorem wPoolStep_ungated_ro : ∀ t : Nat,
    wPoolStep false .restrain .overdraw (t + 2) = 13
  | 0 => rfl
  | t + 1 => by
    have ih := wPoolStep_ungated_ro t
    show (let s := wPoolStep false .restrain .overdraw (t + 2)
      let t1 := if 14 ≤ s ∧ wGateOpen false .restrain (t + 2) = true then 1 else 0
      let t2 := if 14 ≤ s ∧ wGateOpen false .overdraw (t + 2) = true then 4 else 0
      let tb := if 14 ≤ s then 1 else 0
      let g := if 16 ≤ s then 3 else 0
      s - (t1 + t2 + tb) + g) = 13
    rw [ih]
    rfl

theorem wPoolStep_gated_or_ge16 : ∀ t : Nat,
    16 ≤ wPoolStep true .overdraw .restrain (t + 1)
  | 0 => by decide
  | t + 1 => by
    have ih := wPoolStep_gated_or_ge16 t
    have h14 : 14 ≤ wPoolStep true .overdraw .restrain (t + 1) := Nat.le_trans (by decide) ih
    show 16 ≤ (let s := wPoolStep true .overdraw .restrain (t + 1)
      let t1 := if 14 ≤ s ∧ wGateOpen true .overdraw (t + 1) = true then 4 else 0
      let t2 := if 14 ≤ s ∧ wGateOpen true .restrain (t + 1) = true then 1 else 0
      let tb := if 14 ≤ s then 1 else 0
      let g := if 16 ≤ s then 3 else 0
      s - (t1 + t2 + tb) + g)
    dsimp only [wGateOpen]
    rw [if_neg (fun h => Bool.noConfusion h.2), if_pos ⟨h14, rfl⟩, if_pos h14, if_pos ih, Nat.zero_add]
    have h14' : 14 ≤ wPoolStep true .overdraw .restrain (t + 1) - 2 :=
      Naturals.le_sub_of_add_le ih
    exact Nat.le_trans (by decide : 16 ≤ 14 + 3) (Nat.add_le_add_right h14' 3)

theorem wPoolStep_gated_ro_ge16 : ∀ t : Nat,
    16 ≤ wPoolStep true .restrain .overdraw (t + 1)
  | 0 => by decide
  | t + 1 => by
    have ih := wPoolStep_gated_ro_ge16 t
    have h14 : 14 ≤ wPoolStep true .restrain .overdraw (t + 1) := Nat.le_trans (by decide) ih
    show 16 ≤ (let s := wPoolStep true .restrain .overdraw (t + 1)
      let t1 := if 14 ≤ s ∧ wGateOpen true .restrain (t + 1) = true then 1 else 0
      let t2 := if 14 ≤ s ∧ wGateOpen true .overdraw (t + 1) = true then 4 else 0
      let tb := if 14 ≤ s then 1 else 0
      let g := if 16 ≤ s then 3 else 0
      s - (t1 + t2 + tb) + g)
    dsimp only [wGateOpen]
    rw [if_pos ⟨h14, rfl⟩, if_neg (fun h => Bool.noConfusion h.2), if_pos h14, if_pos ih, Nat.add_zero]
    have h14' : 14 ≤ wPoolStep true .restrain .overdraw (t + 1) - 2 :=
      Naturals.le_sub_of_add_le ih
    exact Nat.le_trans (by decide : 16 ≤ 14 + 3) (Nat.add_le_add_right h14' 3)

theorem wPoolTake_le_wPoolStep (gated : Bool) (x y : WNashAct) (t : Nat) :
    wPoolTake1 gated x y t + wPoolTake2 gated x y t + wPoolTakeBase gated x y t ≤
      wPoolStep gated x y t := by
  let s := wPoolStep gated x y t
  cases Nat.decLe 14 s with
  | isFalse hlt =>
    have h1 : wPoolTake1 gated x y t = 0 := by dsimp only [wPoolTake1]; rw [if_neg (fun h => hlt h.1)]
    have h2 : wPoolTake2 gated x y t = 0 := by dsimp only [wPoolTake2]; rw [if_neg (fun h => hlt h.1)]
    have hb : wPoolTakeBase gated x y t = 0 := by dsimp only [wPoolTakeBase]; rw [if_neg hlt]
    rw [h1, h2, hb]; exact Nat.zero_le _
  | isTrue hge =>
    have h1le : wPoolTake1 gated x y t ≤ 4 := by
      dsimp only [wPoolTake1]
      cases hx : wGateOpen gated x t with
      | false =>
        rw [if_neg (fun h' => Bool.noConfusion h'.2)]
        exact Nat.zero_le 4
      | true =>
        rw [if_pos ⟨hge, rfl⟩]
        cases x <;> exact by decide
    have h2le : wPoolTake2 gated x y t ≤ 4 := by
      dsimp only [wPoolTake2]
      cases hy : wGateOpen gated y t with
      | false =>
        rw [if_neg (fun h' => Bool.noConfusion h'.2)]
        exact Nat.zero_le 4
      | true =>
        rw [if_pos ⟨hge, rfl⟩]
        cases y <;> exact by decide
    have hble : wPoolTakeBase gated x y t ≤ 3 := by
      dsimp only [wPoolTakeBase]; rw [if_pos hge]
      cases t with
      | zero => exact by decide
      | succ _ => show 1 ≤ 3; exact by decide
    exact Nat.le_trans (Nat.add_le_add (Nat.add_le_add h1le h2le) hble) (Nat.le_trans (by decide : 11 ≤ 14) hge)

def wCRWeb (gated : Bool) (x y : WNashAct) : Web WNashForm WNashCond where
  level t
    | .cPool => wPoolStep gated x y t
    | .cGate1 => if wGateOpen gated x t = true then 1 else 0
    | .cGate2 => if wGateOpen gated y t = true then 1 else 0
  active t
    | .f1 => 14 ≤ wPoolStep gated x y t ∧ wGateOpen gated x t = true
    | .f2 => 14 ≤ wPoolStep gated x y t ∧ wGateOpen gated y t = true
    | .renewer => 16 ≤ wPoolStep gated x y t
    | .baseAgent => 14 ≤ wPoolStep gated x y t
    | .gateKeeper => True
  requires _ f c := match f with
    | .f1 => match c with | .cPool | .cGate1 => True | .cGate2 => False
    | .f2 => match c with | .cPool | .cGate2 => True | .cGate1 => False
    | .renewer => match c with | .cPool => True | .cGate1 | .cGate2 => False
    | .baseAgent => match c with | .cPool => True | .cGate1 | .cGate2 => False
    | .gateKeeper => False
  need _ f c := match f with
    | .f1 => match c with | .cPool => 14 | .cGate1 => 1 | .cGate2 => 0
    | .f2 => match c with | .cPool => 14 | .cGate2 => 1 | .cGate1 => 0
    | .renewer => match c with | .cPool => 16 | .cGate1 | .cGate2 => 0
    | .baseAgent => match c with | .cPool => 14 | .cGate1 | .cGate2 => 0
    | .gateKeeper => 0
  draws _ f c := match f with
    | .f1 | .f2 | .baseAgent => match c with | .cPool => True | .cGate1 | .cGate2 => False
    | .gateKeeper => match c with | .cGate1 | .cGate2 => True | .cPool => False
    | .renewer => False

def wCRFlow (gated : Bool) (x y : WNashAct) : Flow WNashForm WNashCond where
  present _ := [.f1, .f2, .renewer, .gateKeeper, .baseAgent]
  take t f c := match f with
    | .f1 => match c with | .cPool => wPoolTake1 gated x y t | .cGate1 | .cGate2 => 0
    | .f2 => match c with | .cPool => wPoolTake2 gated x y t | .cGate1 | .cGate2 => 0
    | .baseAgent => match c with | .cPool => wPoolTakeBase gated x y t | .cGate1 | .cGate2 => 0
    | .gateKeeper => match c with | .cGate1 => wPoolTakeGate gated x t | .cGate2 => wPoolTakeGate gated y t | .cPool => 0
    | .renewer => 0
  give t f c := match f with
    | .renewer => match c with | .cPool => wPoolGive gated x y t | .cGate1 | .cGate2 => 0
    | .f1 | .f2 | .gateKeeper | .baseAgent => 0

theorem wCR_balances (gated : Bool) (x y : WNashAct) :
    (wCRFlow gated x y).Balances (wCRWeb gated x y) := by
  intro t c
  cases c with
  | cPool =>
    have hle := wPoolTake_le_wPoolStep gated x y t
    show wPoolStep gated x y (t + 1) +
        (wPoolTake1 gated x y t + (wPoolTake2 gated x y t + (0 + (0 + (wPoolTakeBase gated x y t + 0))))) =
      wPoolStep gated x y t + (0 + (0 + (wPoolGive gated x y t + (0 + (0 + 0)))))
    simp only [Nat.add_zero, Nat.zero_add]
    have hassoc : wPoolTake1 gated x y t + (wPoolTake2 gated x y t + wPoolTakeBase gated x y t) =
        wPoolTake1 gated x y t + wPoolTake2 gated x y t + wPoolTakeBase gated x y t :=
      (Nat.add_assoc _ _ _).symm
    rw [hassoc]
    change (wPoolStep gated x y t -
        (wPoolTake1 gated x y t + wPoolTake2 gated x y t + wPoolTakeBase gated x y t) +
        wPoolGive gated x y t) +
      (wPoolTake1 gated x y t + wPoolTake2 gated x y t + wPoolTakeBase gated x y t) =
      wPoolStep gated x y t + wPoolGive gated x y t
    rw [Nat.add_right_comm _ (wPoolGive gated x y t), Naturals.sub_add_cancel hle]
  | cGate1 =>
    show (if wGateOpen gated x (t + 1) = true then 1 else 0) +
        (0 + (0 + (0 + (wPoolTakeGate gated x t + (0 + 0))))) =
      (if wGateOpen gated x t = true then 1 else 0) + 0
    simp only [Nat.add_zero, Nat.zero_add]
    cases gated <;> cases x <;> cases t <;> rfl
  | cGate2 =>
    show (if wGateOpen gated y (t + 1) = true then 1 else 0) +
        (0 + (0 + (0 + (wPoolTakeGate gated y t + (0 + 0))))) =
      (if wGateOpen gated y t = true then 1 else 0) + 0
    simp only [Nat.add_zero, Nat.zero_add]
    cases gated <;> cases y <;> cases t <;> rfl

theorem wCR_acting (gated : Bool) (x y : WNashAct) :
    (wCRFlow gated x y).Acting (wCRWeb gated x y) := by
  intro t f c _ hpos
  cases f with
  | renewer =>
    cases c with
    | cPool =>
      show 16 ≤ wPoolStep gated x y t
      dsimp only [wCRFlow, wPoolGive] at hpos
      cases h16 : Nat.decLe 16 (wPoolStep gated x y t) with
      | isTrue ht => exact ht
      | isFalse hf => rw [if_neg hf] at hpos; exact absurd hpos (Nat.lt_irrefl 0)
    | cGate1 | cGate2 => exact absurd hpos (Nat.lt_irrefl 0)
  | gateKeeper => exact trivial
  | f1 | f2 | baseAgent => cases c <;> exact absurd hpos (Nat.lt_irrefl 0)

theorem wCR_dependent (gated : Bool) (x y : WNashAct) :
    (wCRWeb gated x y).Dependent := by
  intro t f hact c hreq
  cases f with
  | f1 =>
    cases c with
    | cPool => exact hact.1
    | cGate1 => show 1 ≤ if wGateOpen gated x t = true then 1 else 0; rw [hact.2]; exact Nat.le_refl 1
    | cGate2 => exact False.elim hreq
  | f2 =>
    cases c with
    | cPool => exact hact.1
    | cGate2 => show 1 ≤ if wGateOpen gated y t = true then 1 else 0; rw [hact.2]; exact Nat.le_refl 1
    | cGate1 => exact False.elim hreq
  | renewer =>
    cases c with
    | cPool => exact hact
    | cGate1 | cGate2 => exact False.elim hreq
  | baseAgent =>
    cases c with
    | cPool => exact hact
    | cGate1 | cGate2 => exact False.elim hreq
  | gateKeeper => exact False.elim hreq

def wAdmBool (gated : Bool) (act : WNashAct) (s : Nat) (t : Nat) : Bool :=
  Nat.ble 14 s && wGateOpen gated act t

theorem wAdmBool_iff (gated : Bool) (x y : WNashAct) (t : Nat) :
    (wAdmBool gated x (wPoolStep gated x y t) t = true ↔
      (wCRWeb gated x y).active t .f1 ∧
      (wCRWeb gated x y).Admits ((wCRWeb gated x y).level t) t .f1) ∧
    (wAdmBool gated y (wPoolStep gated x y t) t = true ↔
      (wCRWeb gated x y).active t .f2 ∧
      (wCRWeb gated x y).Admits ((wCRWeb gated x y).level t) t .f2) := by
  constructor
  · constructor
    · intro hb
      have h14 : 14 ≤ wPoolStep gated x y t := Nat.le_of_ble_eq_true (ListTests.and_left hb)
      have hg : wGateOpen gated x t = true := ListTests.and_right hb
      refine ⟨⟨h14, hg⟩, fun c hreq => ?_⟩
      cases c with
      | cPool => exact h14
      | cGate1 => show 1 ≤ if wGateOpen gated x t = true then 1 else 0; rw [hg]; exact Nat.le_refl 1
      | cGate2 => exact False.elim hreq
    · intro ⟨hact, _⟩
      dsimp only [wAdmBool]
      rw [Nat.ble_eq_true_of_le hact.1, hact.2]
      rfl
  · constructor
    · intro hb
      have h14 : 14 ≤ wPoolStep gated x y t := Nat.le_of_ble_eq_true (ListTests.and_left hb)
      have hg : wGateOpen gated y t = true := ListTests.and_right hb
      refine ⟨⟨h14, hg⟩, fun c hreq => ?_⟩
      cases c with
      | cPool => exact h14
      | cGate2 => show 1 ≤ if wGateOpen gated y t = true then 1 else 0; rw [hg]; exact Nat.le_refl 1
      | cGate1 => exact False.elim hreq
    · intro ⟨hact, _⟩
      dsimp only [wAdmBool]
      rw [Nat.ble_eq_true_of_le hact.1, hact.2]
      rfl

def wCR (gated : Bool) : EndogenousOrder.CourseRealization WNashAct WNashForm WNashCond where
  web := wCRWeb gated
  flow := wCRFlow gated
  balances := wCR_balances gated
  acting := wCR_acting gated
  dependent := wCR_dependent gated
  horizon := 3
  form₁ := .f1
  form₂ := .f2
  stepYield₁ := wYieldOf
  stepYield₂ := wYieldOf
  admitted₁ x y t := wAdmBool gated x (wPoolStep gated x y t) t
  admitted₂ x y t := wAdmBool gated y (wPoolStep gated x y t) t
  admitted₁_iff x y t := (wAdmBool_iff gated x y t).1
  admitted₂_iff x y t := (wAdmBool_iff gated x y t).2
  rank₁ x y := total (downFrom 3) (fun t => cond (wAdmBool gated x (wPoolStep gated x y t) t) (wYieldOf x) 0)
  rank₂ x y := total (downFrom 3) (fun t => cond (wAdmBool gated y (wPoolStep gated x y t) t) (wYieldOf y) 0)
  rank₁_eq _ _ := rfl
  rank₂_eq _ _ := rfl

theorem wCR_tracks_rOp : ∀ t : Nat,
    ((wCR true).web .restrain .restrain).level t .cPool = (w_r_full.state (1 + t)).1 () := by
  intro t
  show wPoolStep true .restrain .restrain t = (w_r_full.state (1 + t)).1 ()
  rw [wPoolStep_rr true t, wROp_level_eq t]

/-- Concrete assembled `WholeArchitecture` witness (`Option A` exact arithmetic). -/
def witnessArchitecture :
    WholeArchitecture Bool Unit Bool Unit
      Unit Bool Nat Unit Unit Bool Nat Unit
      Bool Unit Unit
      EndogenousOrder.ScopeMode Nat Bool Unit Empty
      Nat Unit (Nat × Nat) Bool Nat Bool
      WCausalQ
      EvoPlace BadPlace Unit WNashAct WNashForm WNashCond where
  W := wWorld
  θ_true := true
  sp₁ := wSp₁
  sp₂ := wSp₂
  G_hide := wG_hide
  G_hide_rises := wG_hide_rises
  flagOf := wFlagOf
  map₁ := id
  map₂ := id
  wireObs := wWireObs
  wireObs_coupled _ _ := rfl
  tolL _ _ := True
  warnL o := o = true
  x_crit_hide _ := 8
  warnHide _ := 14
  H_safe_hide _ := 2
  x₀_hide _ := 11
  tolL_lifts _ _ _ _ _ _ := ⟨trivial, trivial⟩
  wire_outer_warn o xh ho := by
    dsimp only [wWireObs, wholeWireObs, wFlagOf, wholeInnerBlkContract]; rw [ho]; exact .inl rfl
  wire_hide_warn := fun o xh ⟨_, hlt⟩ => by
    dsimp only [wWireObs, wholeWireObs, wFlagOf, wholeInnerBlkContract]
    rw [CoreHelpers.natBlt_true_iff.mpr hlt, Bool.or_true]; exact .inl rfl
  hide_post_viable k := by cases k; exact by decide
  hide_post_allowance k := by cases k; exact by decide
  hide_warn_margin k := by cases k; exact by decide
  hide_init_margin k := by cases k; exact by decide
  baseR := wBaseR
  initR := wInitR
  hInitR := ⟨⟨Nat.zero_lt_one, Nat.le_refl 1⟩⟩
  admitDecR := EndogenousOrder.scopeAdmitDec 1
  fallbackR := EndogenousOrder.scopeFallback
  hAdmitR := EndogenousOrder.scopeAdmit_sound 2 1 1 (by decide : 1 ≤ 2)
  proposeR := wProposeR
  tolR _ _ := True
  tolR_lifts _ _ _ _ := trivial
  warnR o := o = true
  warnR_lifts _ _ h := h
  preCapIntR := Empty.elim
  preCapIntR_le _ e := Empty.elim e
  preCapExtR _ := 2
  preCapExtR_le m k := by cases m <;> cases k <;> exact by decide
  postAllowanceIntR := Empty.elim
  postAllowanceIntR_le _ e := Empty.elim e
  postAllowanceExtR _ := 1
  postAllowanceExtR_le _ _ := Nat.le_refl 1
  maxSilenceR := 0
  maxSilenceR_le _ := Nat.le_refl 0
  maxLagR := 1
  maxLagR_le m := match m with | .narrowUnmonitored => Nat.le_refl 1 | .wideReciprocal => Nat.zero_le 1
  obsL := wObsL
  obsR := wObsR
  opObs_eq _ := rfl
  channel := wChannel
  channel_fires _ _ _ hload := by
    have hl0 : _ = 0 := Nat.eq_zero_of_le_zero (Nat.le_trans hload (by decide))
    show (true && Nat.ble _ 0) = true
    rw [hl0]
    rfl
  horizon := 1
  plan := wPlan
  probeDraw := wProbeDraw
  probeStepDraw := wProbeStepDraw
  probeDraw_le _ _ _ := Nat.le_refl 1
  infer := wInfer
  x_crit _ := 8
  warnLevel _ := 22
  H_safe _ := 3
  x₀ _ := 20
  probe_identifies xs hxs := by
    have h4 : 4 ≤ xs 0 () := Nat.le_trans (by decide : 4 ≤ 8) (hxs 0 Nat.zero_lt_one ())
    show Nat.blt 1 (if 4 ≤ xs 0 () then 3 else 0) = true
    rw [if_pos h4]
    rfl
  obs_detects x _ hlt := by
    dsimp only [wObsL]; exact .inl (CoreHelpers.natBlt_true_iff.mpr hlt)
  post_viable k := by cases k; exact by decide
  post_allowance k := by cases k; exact by decide
  warn_margin k := by cases k; exact by decide
  init_margin k := by cases k; exact by decide
  cap_within k := by cases k; exact by decide
  k₀ := ()
  fallbackDistOp := (((), ()), ())
  r_full := w_r_full
  r_full_start := by dsimp only [w_r_full, wOrbitFull, ActiveInquiryLoop.inquiryInit, wholeInquirySpec, wSpec]
  drawExt_pos := wDrawExt_pos
  RX := wRX
  πX x := x ()
  σ := id
  strict_σ _ := Nat.lt_succ_self _
  Mstride := 1
  stride_le _ := by simp only [id]; exact Nat.le_of_eq (Naturals.add_sub_cancel_left _ 1)
  MX := wSlackNat
  RA := wRA
  πA s := (s.1.1.2, s.2 ())
  drawQA := wDrawQA
  MA := wSlackLeft
  RB := wRB
  πB p := p.2
  drawQB := wDrawQB
  MB := wSlackNat
  simX := wSimX
  simA := wSimA
  simB := wSimB
  guardQ := wMacroGuard
  KQ := wMacroGuard
  certQ := wCertQ
  Δ := 0
  absorb := by
    show CoreHelpers.natMax
        (if Nat.beq 0 0 && Nat.beq (0 + 0) 0 then 0 else 0 + (0 + 0) + 25)
        (CoreHelpers.natMax
          (if Nat.beq 0 0 && Nat.beq 0 0 then 0 else 0 + 0 + 25)
          (if Nat.beq 0 0 && Nat.beq 0 0 then 0 else 0 + 0 + 25)) + 0 ≤ 0
    exact Nat.le_refl 0
  marginQ q u hGuard hDist _ := by
    have hd0 : cappedDistNat (u.1 ()) q.1 = 0 :=
      Nat.eq_zero_of_le_zero (Nat.le_trans (CoreHelpers.le_natMax_left _ _) hDist)
    have hEq : u.1 () = q.1 := cappedDistNat_zero_iff.mp hd0
    rw [hEq]
    cases hGuard.1 with
    | inl hPost => exact Nat.le_trans (by decide : 8 ≤ 16) hPost.2.2
    | inr hPre => exact Nat.le_trans (by decide : 8 ≤ 20) hPre.1
  epX₀ := trivial
  epA₀ := trivial
  epB₀ := ⟨Nat.zero_lt_one, Nat.le_refl 1⟩
  initQ := ⟨.inr ⟨Nat.le_refl 20, by decide⟩, Nat.le_refl 1, by decide, Nat.le_refl 1⟩
  π_causal := wPiCausal
  ω_causal := id
  causal_goAlike := wCausal_goAlike
  causal_nonconst := wCausal_nonconst
  L_evo := wLEvo
  W_evo := wWEvo
  G_evo := wGEvo
  evo_acting := wEvo_acting
  evo_descended := wEvo_descended
  lgs_evo := wEvoLgs
  listed_evo := rfl
  exact_evo := wEvo_exact
  v_evo := wEvoVal
  founded_evo g mg p mp := by
    cases mg with
    | head => cases mp with | head => rfl | tail _ no => nomatch no
    | tail _ mg2 => cases mg2 with | head => (cases mp with | head => rfl | tail _ no => nomatch no) | tail _ no => nomatch no
  t_evo := 0
  inactive_evo g h mg mh hlt p mp := by
    cases mg with
    | head =>
      cases mh with
      | head => exact absurd hlt (Nat.lt_irrefl 2)
      | tail _ mh2 =>
        cases mh2 with
        | head =>
          cases mp with
          | head => exact id
          | tail _ no => nomatch no
        | tail _ no => nomatch no
    | tail _ mg2 =>
      cases mg2 with
      | head =>
        cases mh with
        | head => exact absurd hlt (by decide)
        | tail _ mh2 =>
          cases mh2 with
          | head => exact absurd hlt (Nat.lt_irrefl 1)
          | tail _ no => nomatch no
      | tail _ no => nomatch no
  g_evo := [.wideLin 0]
  h_evo := [.narrowLin]
  mg_evo := .head _
  mh_evo := .tail _ (.head _)
  less_evo := by decide
  p_evo := .wideLin 0
  q_evo := .narrowLin
  mp_evo := .head _
  mq_evo := .head _
  c_sub := .subPool
  substrate_tracks _ := rfl
  reproduces_when_viable _ := Nat.zero_lt_one
  L_bad := wLBad
  W_bad := wWBad
  G_bad := wGBad
  bad_balances := wBad_balances
  bad_acting := wBad_acting
  bad_dependent := wBad_dependent
  bad_descended := wGBad_descended
  ds_ord := [.cBad]
  m_ord := 8
  gated_ord s f _ d hd hgive := by
    have hdEq : d = .cBad := by cases hd with | head => rfl | tail _ no => nomatch no
    subst hdEq
    cases f <;> exact absurd hgive (by cases s <;> exact Nat.lt_irrefl 0)
  T_end_ord := 2
  n_ord := 1
  excess_ord k hk := by
    have hk0 : k = 0 := Nat.eq_zero_of_le_zero (Nat.le_of_lt_succ hk)
    subst hk0; exact by decide
  start_ord := by decide
  bad_stock_noninc t := by
    match t with
    | 0 => exact by decide
    | 1 => exact by decide
    | 2 => exact by decide
    | 3 => exact by decide
    | _ + 4 => exact Nat.le_refl 0
  bad_stock_bounded := by decide
  coupled_ord k q hq := by
    cases k with
    | zero => rw [wGBad_family 3] at hq; nomatch hq
    | succ k' =>
      rw [Nat.add_comm (2 + 1) (k' + 1), wGBad_family (k' + 4)] at hq
      nomatch hq
  U_ord := wUOrd
  feedback_ord := wFeedbackOrd
  B_ord := 0
  K_ord := 1
  T_ord := 3
  ownBase_ord _ _ _ := Nat.le_refl 0
  offBase_ord _ _ _ := Nat.le_refl 0
  probed_ord x _ hxown := by
    have hf : ∀ s, wFeedbackOrd s x = true := fun _ => hxown
    show 1 ≤ ((0 + cond (wFeedbackOrd 0 x) 1 0) + cond (wFeedbackOrd 1 x) 1 0) + cond (wFeedbackOrd 2 x) 1 0
    rw [hf 0, hf 1, hf 2]
    exact by decide
  enough_ord := Nat.zero_lt_one
  a_ord := wAOrd
  b_ord := wBOrd
  reads_ord x hx hb := by
    cases hx with
    | head => exact .head _
    | tail _ hx1 => cases hx1 with
      | head => exact wGBad_family 1 ▸ .head _
      | tail _ hx2 => cases hx2 with
        | head => exact wGBad_family 2 ▸ .head _
        | tail _ hx3 => cases hx3 with
          | head => exact absurd hb (by decide)
          | tail _ no => nomatch no
  agree_ord x hx hle := by
    cases hx with
    | head => rfl
    | tail _ hx1 => cases hx1 with
      | head => rfl
      | tail _ hx2 => cases hx2 with
        | head => rfl
        | tail _ hx3 => cases hx3 with
          | head => exact absurd hle (by decide)
          | tail _ no => nomatch no
  own_ord _ x := wOrdOwn x
  p_ord := ()
  ownEq_ord := rfl
  adds_ord := ⟨(4, .goodLin 4), .tail _ (.tail _ (.tail _ (.head _))), rfl, rfl, rfl⟩
  CR_ungated := wCR false
  CR_gated := wCR true
  acts_cr := wNashActs
  narrow_cr := wNarrowMenu
  wide_cr := wWideMenu
  r₀ := .restrain
  d₀ := .overdraw
  c_pool := .cPool
  act_track := .restrain
  cr_tracks_substrate := wCR_tracks_rOp
  rMem_cr := .head _
  dMem_cr := .tail _ (.head _)
  apart_cr h := by cases h
  narrow_spec_cr x := by
    cases x with
    | restrain => exact ⟨fun _ => rfl, fun _ => rfl⟩
    | overdraw => exact ⟨fun h => Bool.noConfusion h, fun h => by cases h⟩
  wide_spec_cr x := by cases x <;> exact ⟨fun _ => by first | exact .inl rfl | exact .inr rfl, fun _ => rfl⟩
  urr_adm₁ t _ := (wAdmBool_iff false .restrain .restrain t).1.mp (by rw [wPoolStep_rr false t]; cases t <;> rfl)
  urr_adm₂ t _ := (wAdmBool_iff false .restrain .restrain t).2.mp (by rw [wPoolStep_rr false t]; cases t <;> rfl)
  T_u1 := 1
  T_u2 := 1
  T_c := 0
  T_rd := 1
  T_dr := 1
  tu1_le := by decide
  tu2_le := by decide
  tc_le := by decide
  udr_adm₁ t ht := (wAdmBool_iff false .overdraw .restrain t).1.mp (by
    match t with | 0 => rfl | 1 => rfl | n' + 2 => exact absurd ht (Nat.not_le_of_gt (Nat.lt_of_lt_of_le (by decide : 1 < 2) (Nat.le_add_left 2 n'))))
  urd_adm₂ t ht := (wAdmBool_iff false .restrain .overdraw t).2.mp (by
    match t with | 0 => rfl | 1 => rfl | n' + 2 => exact absurd ht (Nat.not_le_of_gt (Nat.lt_of_lt_of_le (by decide : 1 < 2) (Nat.le_add_left 2 n'))))
  tempt₁_cr := by decide
  tempt₂_cr := by decide
  udd_adm₁ t ht := (wAdmBool_iff false .overdraw .overdraw t).1.mp (by
    match t with | 0 => rfl | n' + 1 => exact absurd ht (Nat.not_le_of_gt (Nat.zero_lt_succ n')))
  udd_cut₁ t hgt h := by
    match t with
    | 0 => exact absurd hgt (Nat.not_lt_zero 0)
    | t' + 1 =>
      have hb := (wAdmBool_iff false .overdraw .overdraw (t' + 1)).1.mpr h
      dsimp only [wAdmBool] at hb
      rw [wPoolStep_oo false t'] at hb
      exact Bool.noConfusion hb
  udd_adm₂ t ht := (wAdmBool_iff false .overdraw .overdraw t).2.mp (by
    match t with | 0 => rfl | n' + 1 => exact absurd ht (Nat.not_le_of_gt (Nat.zero_lt_succ n')))
  udd_cut₂ t hgt h := by
    match t with
    | 0 => exact absurd hgt (Nat.not_lt_zero 0)
    | t' + 1 =>
      have hb := (wAdmBool_iff false .overdraw .overdraw (t' + 1)).2.mpr h
      dsimp only [wAdmBool] at hb
      rw [wPoolStep_oo false t'] at hb
      exact Bool.noConfusion hb
  urd_cut₁ t hgt h := by
    match t with
    | 0 | 1 => exact absurd hgt (by decide)
    | t' + 2 =>
      have hb := (wAdmBool_iff false .restrain .overdraw (t' + 2)).1.mpr h
      dsimp only [wAdmBool] at hb
      rw [wPoolStep_ungated_ro t'] at hb
      exact Bool.noConfusion hb
  udr_cut₂ t hgt h := by
    match t with
    | 0 | 1 => exact absurd hgt (by decide)
    | t' + 2 =>
      have hb := (wAdmBool_iff false .overdraw .restrain (t' + 2)).2.mpr h
      dsimp only [wAdmBool] at hb
      rw [wPoolStep_ungated_or t'] at hb
      exact Bool.noConfusion hb
  overtaken₁_cr := by decide
  overtaken₂_cr := by decide
  drop₁_cr := by decide
  drop₂_cr := by decide
  grr_adm₁ t _ := (wAdmBool_iff true .restrain .restrain t).1.mp (by rw [wPoolStep_rr true t]; cases t <;> rfl)
  grr_adm₂ t _ := (wAdmBool_iff true .restrain .restrain t).2.mp (by rw [wPoolStep_rr true t]; cases t <;> rfl)
  grd_adm₁ t _ := (wAdmBool_iff true .restrain .overdraw t).1.mp (by
    cases t with
    | zero => rfl
    | succ t' =>
      have h16 := wPoolStep_gated_ro_ge16 t'
      have h14 := Nat.le_trans (by decide : 14 ≤ 16) h16
      dsimp only [wAdmBool, wGateOpen]
      rw [Nat.ble_eq_true_of_le h14]
      rfl)
  gdr_adm₂ t _ := (wAdmBool_iff true .overdraw .restrain t).2.mp (by
    cases t with
    | zero => rfl
    | succ t' =>
      have h16 := wPoolStep_gated_or_ge16 t'
      have h14 := Nat.le_trans (by decide : 14 ≤ 16) h16
      dsimp only [wAdmBool, wGateOpen]
      rw [Nat.ble_eq_true_of_le h14]
      rfl)
  T_gate := 0
  gdr_cut₁ t hgt h := by
    cases t with
    | zero => exact absurd hgt (Nat.not_lt_zero 0)
    | succ t' => exact Bool.noConfusion h.1.2
  grd_cut₂ t hgt h := by
    cases t with
    | zero => exact absurd hgt (Nat.not_lt_zero 0)
    | succ t' => exact Bool.noConfusion h.1.2
  gdd_cut₁ t hgt h := by
    cases t with
    | zero => exact absurd hgt (Nat.not_lt_zero 0)
    | succ t' => exact Bool.noConfusion h.1.2
  gdd_cut₂ t hgt h := by
    cases t with
    | zero => exact absurd hgt (Nat.not_lt_zero 0)
    | succ t' => exact Bool.noConfusion h.1.2
  restored₁_cr := by decide
  restored₂_cr := by decide

/-- End-to-end instantiation of `whole_becoming_master_theorem` on `witnessArchitecture`,
accompanied by explicit firewalls `masterSpine_cannot_entail_unrestricted` and
`EndogenousOrder.endogenousOrder_cannot_entail_unrestricted`. -/
theorem witness_holds_master_theorem {Pos F : Type} (p : Pos) (f : F)
    {X Mode : Type} {S Obs Dist Int Ext : Mode → Type} {Site Env Act F_c C_c : Type}
    (EndoLaw : EndogenousOrder.EndogenousOrderSystem X Mode S Obs Dist Int Ext Site Env Act F_c C_c → Prop)
    {sys : EndogenousOrder.EndogenousOrderSystem X Mode S Obs Dist Int Ext Site Env Act F_c C_c}
    (hEndo : EndoLaw sys) :
    (WholeArchitectureViableProp witnessArchitecture ∧
     MasterSpineGrammarLiftsProp witnessArchitecture ∧
     FullObstructionPanoramaProp p f ∧
     K6EthicsFirewallProp p f (fun _ : Unit => True) ∧
     MasterAlignmentDichotomyProp p f) ∧
    (¬ (∀ d' (sig : Pos → Nat → F → Prop), (fun _ : Unit => True) d' → Unrestricted sig) ∧
     ¬ (∀ sys' (sig : Pos → Nat → F → Prop), EndoLaw sys' → Unrestricted sig)) :=
  ⟨whole_becoming_master_theorem witnessArchitecture p f (fun _ : Unit => True) (d := ()) trivial,
   ⟨masterSpine_cannot_entail_unrestricted (fun _ : Unit => True) p f (d := ()) trivial,
    EndogenousOrder.endogenousOrder_cannot_entail_unrestricted EndoLaw p f hEndo⟩⟩

end WholeBecomingWitness

end MasterSpine

end Becoming


