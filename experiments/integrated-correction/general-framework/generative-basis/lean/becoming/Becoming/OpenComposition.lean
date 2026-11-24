import Becoming.RegimeMargin
import Becoming.MultiScaleViability
import Becoming.CoreHelpers

/-!
# Open composition: boundary ports, interface gluing, structural replacement, and compositional laxity

This module (`AI-written` for Wave 2 Pillar `L0`) extends `Becoming.RegimeMargin`,
`Becoming.CoreHelpers`, and `Becoming.MultiScaleViability` with open-loop boundaries (`OpenLoop`,
`LoopCertificate`), explicit internal vs. exposed boundary ports (`OpenComponent`,
`InterfaceContract`), horizontal gluing (`compose`, `composeListComponent`, `familyComponent`) and
boundary hiding (`hide`, `withHiddenSite`) with constructive associativity/commutativity
(`ComponentEquiv`, `ContractEquiv`), composition-preserved closed substrate viability vs.
hidden-coupling collapse, heterogeneous sub-component replacement (`ContractRefines`,
`ReconfigProcess`, `widen_interface_heals_blindness`), and synchronous-product compositional lax
multi-scale simulation (`SlackDist.max`, `SlackDist.sum`, `compose_laxSim_max`, `compose_laxSim_sum`).

All declarations compile from Lean's prelude alone with empty axiom reports (`0` axioms, `0` `sorry`).
-/

namespace Becoming

open Generative

namespace OpenComposition

/-! ## Coupled indexed helpers and shared countdown margin step (prelude-only, zero axioms) -/

/-- **Monotonicity of coupled indexed substrate step in the state `x`.** -/
theorem indexedStep_mono {ι : Type}
    {G : ι → (ι → Nat) → Nat} (rises : ∀ i, RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (G i))
    (H : ι → Nat) {x y : ι → Nat} (below : ∀ i, x i ≤ y i) (j : ι) :
    RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole G H x j ≤
      RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole G H y j :=
  RegimeMargin.Coupled.Indexed.step_mono rises H below j

/-- **Antitonicity of coupled indexed substrate step in the draw `H`.** -/
theorem indexedStep_antitone_H {ι : Type}
    {G : ι → (ι → Nat) → Nat} (rises : ∀ i, RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (G i))
    {H H' : ι → Nat} (hle : ∀ j, H j ≤ H' j) (x : ι → Nat) (j : ι) :
    RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole G H' x j ≤
      RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole G H x j := by
  have leftBelow : RegimeMargin.Coupled.Indexed.Below RegimeMargin.Drawn.whole
      (RegimeMargin.Coupled.Indexed.left RegimeMargin.Drawn.whole H' x)
      (RegimeMargin.Coupled.Indexed.left RegimeMargin.Drawn.whole H x) :=
    fun k => Naturals.sub_antitone (x k) (hle k)
  exact Nat.add_le_add (leftBelow j) (rises j _ _ leftBelow)

/-- Each coupled indexed substrate step is at least what remains after the draw `H`. -/
theorem indexedStep_ge_sub {ι : Type}
    (G : ι → (ι → Nat) → Nat) (H x : ι → Nat) (j : ι) :
    x j - H j ≤ RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole G H x j :=
  Nat.le_add_right _ _

theorem substrate_margin_step {ι : Type}
    {G : ι → (ι → Nat) → Nat}
    (G_rises : ∀ j, RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (G j))
    {H preTotal H_safe x_crit warnLevel x : ι → Nat}
    {curLag nextEta maxLag : Nat}
    (H_le_pre : ∀ j, H j ≤ preTotal j)
    (nextEta_le_max : nextEta ≤ maxLag)
    (post_viable : ∀ j, x_crit j ≤
      RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole G H_safe x_crit j)
    (warn_margin : ∀ j, x_crit j + (maxLag + 1) * preTotal j ≤ warnLevel j)
    (margin : ∀ j, x_crit j + curLag * preTotal j ≤ x j)
    (j : ι)
    (onWarn : x j < warnLevel j →
      (curLag = 0 → nextEta = 0 ∧ ∀ k, H k ≤ H_safe k) ∧
      (0 < curLag → nextEta + 1 ≤ curLag)) :
    x_crit j + nextEta * preTotal j ≤
      RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole G H x j := by
  cases Nat.lt_or_ge (x j) (warnLevel j) with
  | inr aboveWarn =>
    have lagMul : nextEta * preTotal j + preTotal j ≤ (maxLag + 1) * preTotal j := by
      rw [add_mul_split maxLag 1 (preTotal j), Nat.one_mul]
      exact Nat.add_le_add_right (Nat.mul_le_mul_right _ nextEta_le_max) _
    have enough : x_crit j + nextEta * preTotal j + preTotal j ≤ x j :=
      Nat.le_trans
        (Nat.le_trans
          (Nat.add_assoc (x_crit j) _ _ ▸ Nat.add_le_add_left lagMul (x_crit j))
          (warn_margin j))
        aboveWarn
    have subPre : x_crit j + nextEta * preTotal j ≤ x j - preTotal j :=
      Naturals.le_sub_of_add_le (Nat.add_comm _ _ ▸ enough)
    exact Nat.le_trans subPre
      (Nat.le_trans (Naturals.sub_antitone (x j) (H_le_pre j))
        (indexedStep_ge_sub G H x j))
  | inl belowWarn =>
    have hWarn := onWarn belowWarn
    cases hCur : curLag with
    | zero =>
      obtain ⟨hNext0, H_le_safe⟩ := hWarn.1 hCur
      have xCritLe : ∀ k, x_crit k ≤ x k := fun k =>
        Nat.le_trans (Nat.le_add_right _ _) (margin k)
      have stepSafe : x_crit j ≤
          RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole G H x j :=
        Nat.le_trans (post_viable j)
          (Nat.le_trans (indexedStep_antitone_H G_rises H_le_safe x_crit j)
            (indexedStep_mono G_rises H xCritLe j))
      rw [hNext0, Nat.zero_mul, Nat.add_zero]
      exact stepSafe
    | succ pred =>
      have nextDown : nextEta + 1 ≤ curLag := hWarn.2 (hCur ▸ Nat.succ_pos pred)
      have mulDown : nextEta * preTotal j + preTotal j ≤ curLag * preTotal j := by
        have expand : nextEta * preTotal j + preTotal j = (nextEta + 1) * preTotal j := by
          rw [add_mul_split, Nat.one_mul]
        rw [expand]
        exact Nat.mul_le_mul_right _ nextDown
      have enough : x_crit j + nextEta * preTotal j + preTotal j ≤ x j :=
        Nat.le_trans
          (Nat.add_assoc (x_crit j) _ _ ▸ Nat.add_le_add_left mulDown (x_crit j))
          (margin j)
      have subPre : x_crit j + nextEta * preTotal j ≤ x j - preTotal j :=
        Naturals.le_sub_of_add_le (Nat.add_comm _ _ ▸ enough)
      exact Nat.le_trans subPre
        (Nat.le_trans (Naturals.sub_antitone (x j) (H_le_pre j))
          (indexedStep_ge_sub G H x j))

/-! ## Part 1: Open Components, Port Split (`Int` / `Ext`), & Interface Contracts -/

/-- An open adaptive component separating private/internal substrate ports `Int` from exposed
boundary ports `Ext` along which components glue and compose. -/
structure OpenComponent (S Obs Dist Int Ext : Type) where
  next : S → Obs × Bool → Dist → S
  drawInt : S → Int → Nat
  drawExt : S → Ext → Nat
  emitAlarm : S → Obs → Bool
  silenceLoad : S → Nat
  favours : S → Prop

/-- The disturbed transition process of an `OpenComponent`. -/
def OpenComponent.process {S Obs Dist Int Ext : Type}
    (C : OpenComponent S Obs Dist Int Ext) (tol : Obs × Bool → Dist → Prop) :
    Process S ((Obs × Bool) × Dist) :=
  Viability.disturbed (fun s m => C.next s m.1 m.2) (fun m => tol m.1 m.2)

/-- An open adaptive loop interacting with a substrate via observations `Obs`, an external alarm
`Bool`, and disturbances `Dist` (canonical home below `AdaptiveLoops`). -/
structure OpenLoop (S Obs Dist ι : Type) where
  next : S → Obs × Bool → Dist → S
  draw : S → ι → Nat
  emitAlarm : S → Obs → Bool
  silenceLoad : S → Nat
  favours : S → Prop

/-- The disturbed process of an open loop, with state-independent disturbance admissibility `tol`. -/
def OpenLoop.process {S Obs Dist ι : Type} (L : OpenLoop S Obs Dist ι)
    (tol : Obs × Bool → Dist → Prop) : Process S ((Obs × Bool) × Dist) :=
  Viability.disturbed (fun s m => L.next s m.1 m.2) (fun m => tol m.1 m.2)

/-- An assume-guarantee certificate for an `OpenLoop` from `init`, certifying pre-adaptation draw
bounds, silence bounds, observation-driven alarm emission, and bounded countdown `eta`. -/
structure LoopCertificate {S Obs Dist ι : Type}
    (L : OpenLoop S Obs Dist ι) (init : S) where
  tol : Obs × Bool → Dist → Prop
  warnObs : Obs → Prop
  preCap : ι → Nat
  postBudget : ι → Nat
  maxSilence : Nat
  maxLag : Nat
  K : S → Prop
  eta : S → Nat
  init_in : K init
  cert : Viability.Certificate (L.process tol)
    (fun s => (∀ j, L.draw s j ≤ preCap j) ∧
              L.silenceLoad s ≤ maxSilence ∧
              (eta s = 0 → ¬ L.favours s ∧ ∀ j, L.draw s j ≤ postBudget j)) K
  eta_bound : ∀ s, K s → eta s ≤ maxLag
  emits_on_warn : ∀ s obs, K s → warnObs obs → L.emitAlarm s obs = true
  eta_alarm_step : ∀ s obs dist, tol (obs, true) dist → K s → 0 < eta s →
    eta (L.next s (obs, true) dist) < eta s
  eta_alarm_zero : ∀ s obs dist, tol (obs, true) dist → K s → eta s = 0 →
    eta (L.next s (obs, true) dist) = 0

/-- Lift an `OpenLoop` into an `OpenComponent` with no private sites (`Empty`). -/
def OpenComponent.ofOpenLoop {S Obs Dist ι : Type}
    (L : OpenLoop S Obs Dist ι) :
    OpenComponent S Obs Dist Empty ι where
  next := L.next
  drawInt _ e := Empty.elim e
  drawExt := L.draw
  emitAlarm := L.emitAlarm
  silenceLoad := L.silenceLoad
  favours := L.favours

/-- Forget the internal/external split of an `OpenComponent` back to an `OpenLoop`
over `Sum Int Ext`. -/
def OpenComponent.toOpenLoop {S Obs Dist Int Ext : Type}
    (C : OpenComponent S Obs Dist Int Ext) :
    OpenLoop S Obs Dist (Sum Int Ext) where
  next := C.next
  draw s
    | .inl j => C.drawInt s j
    | .inr k => C.drawExt s k
  emitAlarm := C.emitAlarm
  silenceLoad := C.silenceLoad
  favours := C.favours

/-- Opaque assume-guarantee contract over an `OpenComponent` starting from `init`. -/
structure InterfaceContract {S Obs Dist Int Ext : Type}
    (C : OpenComponent S Obs Dist Int Ext) (init : S) where
  tol : Obs × Bool → Dist → Prop
  warnObs : Obs → Prop
  preCapInt : Int → Nat
  preCapExt : Ext → Nat
  postBudgetInt : Int → Nat
  postBudgetExt : Ext → Nat
  maxSilence : Nat
  maxLag : Nat
  K : S → Prop
  eta : S → Nat
  init_in : K init
  cert : Viability.Certificate (C.process tol)
    (fun s => (∀ j, C.drawInt s j ≤ preCapInt j) ∧
              (∀ k, C.drawExt s k ≤ preCapExt k) ∧
              C.silenceLoad s ≤ maxSilence ∧
              (eta s = 0 → ¬ C.favours s ∧
                (∀ j, C.drawInt s j ≤ postBudgetInt j) ∧
                (∀ k, C.drawExt s k ≤ postBudgetExt k))) K
  eta_bound : ∀ s, K s → eta s ≤ maxLag
  emits_on_warn : ∀ s obs, K s → warnObs obs → C.emitAlarm s obs = true
  eta_alarm_step : ∀ s obs dist, tol (obs, true) dist → K s → 0 < eta s →
    eta (C.next s (obs, true) dist) < eta s
  eta_alarm_zero : ∀ s obs dist, tol (obs, true) dist → K s → eta s = 0 →
    eta (C.next s (obs, true) dist) = 0

/-- Lift a `LoopCertificate` onto `OpenComponent.ofOpenLoop`. -/
def InterfaceContract.ofLoopCertificate {S Obs Dist ι : Type}
    {L : OpenLoop S Obs Dist ι} {init : S}
    (cert : LoopCertificate L init) :
    InterfaceContract (OpenComponent.ofOpenLoop L) init where
  tol := cert.tol
  warnObs := cert.warnObs
  preCapInt e := Empty.elim e
  preCapExt := cert.preCap
  postBudgetInt e := Empty.elim e
  postBudgetExt := cert.postBudget
  maxSilence := cert.maxSilence
  maxLag := cert.maxLag
  K := cert.K
  eta := cert.eta
  init_in := cert.init_in
  cert := Viability.certificate_disturbed_iff.mpr
    ⟨fun s hs =>
      let w := cert.cert.within s hs
      ⟨fun e => Empty.elim e, w.1, w.2.1, fun h0 =>
        let p := w.2.2 h0
        ⟨p.1, fun e => Empty.elim e, p.2⟩⟩,
     fun s m adm hs => cert.cert.closed s m _ ⟨adm, rfl⟩ hs⟩
  eta_bound := cert.eta_bound
  emits_on_warn := cert.emits_on_warn
  eta_alarm_step := cert.eta_alarm_step
  eta_alarm_zero := cert.eta_alarm_zero

/-! ## Part 2: Interface Gluing (`compose`), Boundary Hiding (`hide`), & Associativity -/

/-- Horizontal gluing `A ⊕_K B` along shared exposed interface `Ext`, preserving distinct internal
states `S₁ × S₂` and separated private ports `Sum Int₁ Int₂`. -/
def OpenComponent.compose {S₁ S₂ Obs₁ Obs₂ Dist₁ Dist₂ Int₁ Int₂ Ext : Type}
    (A : OpenComponent S₁ Obs₁ Dist₁ Int₁ Ext)
    (B : OpenComponent S₂ Obs₂ Dist₂ Int₂ Ext) :
    OpenComponent (S₁ × S₂) (Obs₁ × Obs₂) (Dist₁ × Dist₂) (Sum Int₁ Int₂) Ext where
  next s oa d := (A.next s.1 (oa.1.1, oa.2) d.1, B.next s.2 (oa.1.2, oa.2) d.2)
  drawInt s
    | .inl j₁ => A.drawInt s.1 j₁
    | .inr j₂ => B.drawInt s.2 j₂
  drawExt s k := A.drawExt s.1 k + B.drawExt s.2 k
  emitAlarm s oa := A.emitAlarm s.1 oa.1 || B.emitAlarm s.2 oa.2
  silenceLoad s := A.silenceLoad s.1 + B.silenceLoad s.2
  favours s := A.favours s.1 ∨ B.favours s.2

/-- Opaque horizontal contract composition on `OpenComponent.compose` without unfolding `A.next`,
`B.next`, `cA.K`, or `cB.K`. -/
def composeContract {S₁ S₂ Obs₁ Obs₂ Dist₁ Dist₂ Int₁ Int₂ Ext : Type}
    {A : OpenComponent S₁ Obs₁ Dist₁ Int₁ Ext}
    {B : OpenComponent S₂ Obs₂ Dist₂ Int₂ Ext}
    {init₁ : S₁} {init₂ : S₂}
    (cA : InterfaceContract A init₁)
    (cB : InterfaceContract B init₂) :
    InterfaceContract (OpenComponent.compose A B) (init₁, init₂) where
  tol oa d := cA.tol (oa.1.1, oa.2) d.1 ∧ cB.tol (oa.1.2, oa.2) d.2
  warnObs oa := cA.warnObs oa.1 ∨ cB.warnObs oa.2
  preCapInt
    | .inl j₁ => cA.preCapInt j₁
    | .inr j₂ => cB.preCapInt j₂
  preCapExt k := cA.preCapExt k + cB.preCapExt k
  postBudgetInt
    | .inl j₁ => cA.postBudgetInt j₁
    | .inr j₂ => cB.postBudgetInt j₂
  postBudgetExt k := cA.postBudgetExt k + cB.postBudgetExt k
  maxSilence := cA.maxSilence + cB.maxSilence
  maxLag := CoreHelpers.natMax cA.maxLag cB.maxLag
  K s := cA.K s.1 ∧ cB.K s.2
  eta s := CoreHelpers.natMax (cA.eta s.1) (cB.eta s.2)
  init_in := ⟨cA.init_in, cB.init_in⟩
  cert := Viability.certificate_disturbed_iff.mpr
    ⟨fun s ⟨hA, hB⟩ =>
      let wA := cA.cert.within s.1 hA
      let wB := cB.cert.within s.2 hB
      ⟨fun j => match j with
         | .inl j₁ => wA.1 j₁
         | .inr j₂ => wB.1 j₂,
       fun k => Nat.add_le_add (wA.2.1 k) (wB.2.1 k),
       Nat.add_le_add wA.2.2.1 wB.2.2.1,
       fun hEta =>
         have hEtaA : cA.eta s.1 = 0 :=
           Nat.eq_zero_of_le_zero
             (Nat.le_trans (CoreHelpers.le_natMax_left _ _) (Nat.le_of_eq hEta))
         have hEtaB : cB.eta s.2 = 0 :=
           Nat.eq_zero_of_le_zero
             (Nat.le_trans (CoreHelpers.le_natMax_right _ _) (Nat.le_of_eq hEta))
         let pA := wA.2.2.2 hEtaA
         let pB := wB.2.2.2 hEtaB
         ⟨fun fav => match fav with
            | .inl fA => pA.1 fA
            | .inr fB => pB.1 fB,
          fun j => match j with
            | .inl j₁ => pA.2.1 j₁
            | .inr j₂ => pB.2.1 j₂,
          fun k => Nat.add_le_add (pA.2.2 k) (pB.2.2 k)⟩⟩,
     fun s m adm ⟨hA, hB⟩ =>
       ⟨cA.cert.closed s.1 ((m.1.1.1, m.1.2), m.2.1) _ ⟨adm.1, rfl⟩ hA,
        cB.cert.closed s.2 ((m.1.1.2, m.1.2), m.2.2) _ ⟨adm.2, rfl⟩ hB⟩⟩
  eta_bound := fun s ⟨hA, hB⟩ =>
    CoreHelpers.natMax_le
      (Nat.le_trans (cA.eta_bound s.1 hA) (CoreHelpers.le_natMax_left _ _))
      (Nat.le_trans (cB.eta_bound s.2 hB) (CoreHelpers.le_natMax_right _ _))
  emits_on_warn := fun s oa ⟨hA, hB⟩ warn => by
    change (A.emitAlarm s.1 oa.1 || B.emitAlarm s.2 oa.2) = true
    cases warn with
    | inl wA =>
      rw [cA.emits_on_warn s.1 oa.1 hA wA]
      rfl
    | inr wB =>
      rw [cB.emits_on_warn s.2 oa.2 hB wB]
      exact CoreHelpers.bool_or_true_right _
  eta_alarm_step := fun s oa d tol ⟨hA, hB⟩ pos => by
    have stepA : cA.eta (A.next s.1 (oa.1, true) d.1) <
        CoreHelpers.natMax (cA.eta s.1) (cB.eta s.2) := by
      cases Nat.eq_zero_or_pos (cA.eta s.1) with
      | inl hEA =>
        rw [cA.eta_alarm_zero s.1 oa.1 d.1 tol.1 hA hEA]
        exact pos
      | inr hposA =>
        exact Nat.lt_of_lt_of_le
          (cA.eta_alarm_step s.1 oa.1 d.1 tol.1 hA hposA)
          (CoreHelpers.le_natMax_left _ _)
    have stepB : cB.eta (B.next s.2 (oa.2, true) d.2) <
        CoreHelpers.natMax (cA.eta s.1) (cB.eta s.2) := by
      cases Nat.eq_zero_or_pos (cB.eta s.2) with
      | inl hEB =>
        rw [cB.eta_alarm_zero s.2 oa.2 d.2 tol.2 hB hEB]
        exact pos
      | inr hposB =>
        exact Nat.lt_of_lt_of_le
          (cB.eta_alarm_step s.2 oa.2 d.2 tol.2 hB hposB)
          (CoreHelpers.le_natMax_right _ _)
    change CoreHelpers.natMax (cA.eta (A.next s.1 (oa.1, true) d.1))
        (cB.eta (B.next s.2 (oa.2, true) d.2)) <
      CoreHelpers.natMax (cA.eta s.1) (cB.eta s.2)
    cases Nat.decLe (cA.eta (A.next s.1 (oa.1, true) d.1)) (cB.eta (B.next s.2 (oa.2, true) d.2)) with
    | isTrue le =>
      rw [show CoreHelpers.natMax (cA.eta (A.next s.1 (oa.1, true) d.1))
          (cB.eta (B.next s.2 (oa.2, true) d.2)) =
          cB.eta (B.next s.2 (oa.2, true) d.2) from if_pos le]
      exact stepB
    | isFalse notLe =>
      rw [show CoreHelpers.natMax (cA.eta (A.next s.1 (oa.1, true) d.1))
          (cB.eta (B.next s.2 (oa.2, true) d.2)) =
          cA.eta (A.next s.1 (oa.1, true) d.1) from if_neg notLe]
      exact stepA
  eta_alarm_zero := fun s oa d tol ⟨hA, hB⟩ hEta => by
    have hEtaA : cA.eta s.1 = 0 :=
      Nat.eq_zero_of_le_zero
        (Nat.le_trans (CoreHelpers.le_natMax_left _ _) (Nat.le_of_eq hEta))
    have hEtaB : cB.eta s.2 = 0 :=
      Nat.eq_zero_of_le_zero
        (Nat.le_trans (CoreHelpers.le_natMax_right _ _) (Nat.le_of_eq hEta))
    have zA := cA.eta_alarm_zero s.1 oa.1 d.1 tol.1 hA hEtaA
    have zB := cB.eta_alarm_zero s.2 oa.2 d.2 tol.2 hB hEtaB
    show CoreHelpers.natMax (cA.eta (A.next s.1 (oa.1, true) d.1))
        (cB.eta (B.next s.2 (oa.2, true) d.2)) = 0
    rw [zA, zB]
    rfl

/-- Constructive structural equivalence between two `OpenComponent`s without axioms or `funext`. -/
structure ComponentEquiv {S₁ S₂ Obs₁ Obs₂ Dist₁ Dist₂ Int₁ Int₂ Ext : Type}
    (A : OpenComponent S₁ Obs₁ Dist₁ Int₁ Ext)
    (B : OpenComponent S₂ Obs₂ Dist₂ Int₂ Ext) where
  toS : S₁ → S₂
  invS : S₂ → S₁
  leftS : ∀ s, invS (toS s) = s
  rightS : ∀ s, toS (invS s) = s
  toObs : Obs₁ → Obs₂
  invObs : Obs₂ → Obs₁
  leftObs : ∀ o, invObs (toObs o) = o
  rightObs : ∀ o, toObs (invObs o) = o
  toDist : Dist₁ → Dist₂
  invDist : Dist₂ → Dist₁
  leftDist : ∀ d, invDist (toDist d) = d
  rightDist : ∀ d, toDist (invDist d) = d
  toInt : Int₁ → Int₂
  invInt : Int₂ → Int₁
  leftInt : ∀ j, invInt (toInt j) = j
  rightInt : ∀ j, toInt (invInt j) = j
  comm_next : ∀ s o al d,
    toS (A.next s (o, al) d) = B.next (toS s) (toObs o, al) (toDist d)
  comm_drawInt : ∀ s j, A.drawInt s j = B.drawInt (toS s) (toInt j)
  comm_drawExt : ∀ s k, A.drawExt s k = B.drawExt (toS s) k
  comm_emitAlarm : ∀ s o, A.emitAlarm s o = B.emitAlarm (toS s) (toObs o)
  comm_silenceLoad : ∀ s, A.silenceLoad s = B.silenceLoad (toS s)
  comm_favours : ∀ s, A.favours s ↔ B.favours (toS s)

/-- Constructive associativity of `OpenComponent.compose` (`(A ⊕ B) ⊕ C ≃ A ⊕ (B ⊕ C)`). -/
def composeAssocEquiv
    {S₁ S₂ S₃ Obs₁ Obs₂ Obs₃ Dist₁ Dist₂ Dist₃ Int₁ Int₂ Int₃ Ext : Type}
    (A : OpenComponent S₁ Obs₁ Dist₁ Int₁ Ext)
    (B : OpenComponent S₂ Obs₂ Dist₂ Int₂ Ext)
    (C : OpenComponent S₃ Obs₃ Dist₃ Int₃ Ext) :
    ComponentEquiv
      (OpenComponent.compose (OpenComponent.compose A B) C)
      (OpenComponent.compose A (OpenComponent.compose B C)) where
  toS p := (p.1.1, (p.1.2, p.2))
  invS p := ((p.1, p.2.1), p.2.2)
  leftS _ := rfl
  rightS _ := rfl
  toObs o := (o.1.1, (o.1.2, o.2))
  invObs o := ((o.1, o.2.1), o.2.2)
  leftObs _ := rfl
  rightObs _ := rfl
  toDist d := (d.1.1, (d.1.2, d.2))
  invDist d := ((d.1, d.2.1), d.2.2)
  leftDist _ := rfl
  rightDist _ := rfl
  toInt
    | .inl (.inl j₁) => .inl j₁
    | .inl (.inr j₂) => .inr (.inl j₂)
    | .inr j₃ => .inr (.inr j₃)
  invInt
    | .inl j₁ => .inl (.inl j₁)
    | .inr (.inl j₂) => .inl (.inr j₂)
    | .inr (.inr j₃) => .inr j₃
  leftInt
    | .inl (.inl _) => rfl
    | .inl (.inr _) => rfl
    | .inr _ => rfl
  rightInt
    | .inl _ => rfl
    | .inr (.inl _) => rfl
    | .inr (.inr _) => rfl
  comm_next _ _ _ _ := rfl
  comm_drawInt _
    | .inl (.inl _) => rfl
    | .inl (.inr _) => rfl
    | .inr _ => rfl
  comm_drawExt s k := Nat.add_assoc (A.drawExt s.1.1 k) (B.drawExt s.1.2 k) (C.drawExt s.2 k)
  comm_emitAlarm s oa := CoreHelpers.bool_or_assoc (A.emitAlarm s.1.1 oa.1.1) (B.emitAlarm s.1.2 oa.1.2) (C.emitAlarm s.2 oa.2)
  comm_silenceLoad s := Nat.add_assoc (A.silenceLoad s.1.1) (B.silenceLoad s.1.2) (C.silenceLoad s.2)
  comm_favours _ :=
    ⟨fun h => match h with
       | .inl (.inl a) => .inl a
       | .inl (.inr b) => .inr (.inl b)
       | .inr c => .inr (.inr c),
     fun h => match h with
       | .inl a => .inl (.inl a)
       | .inr (.inl b) => .inl (.inr b)
       | .inr (.inr c) => .inr c⟩

/-- Boundary hiding (`hide`): encapsulates a slice `ExtHide` of the exposed boundary ports inside
private state `S × (ExtHide → Nat)` evolving under coupled internal dynamics `G_hide`, wiring
internal self-alerts back into `C`'s alarm channel while leaving only `ExtKeep` exposed. -/
def OpenComponent.hide {S Obs ObsOuter Dist Int ExtKeep ExtHide : Type}
    (C : OpenComponent S Obs Dist Int (Sum ExtKeep ExtHide))
    (G_hide : ExtHide → (ExtHide → Nat) → Nat)
    (wireObs : ObsOuter → (ExtHide → Nat) → Obs) :
    OpenComponent (S × (ExtHide → Nat)) ObsOuter Dist (Sum Int ExtHide) ExtKeep where
  next p oa d :=
    let obsC := wireObs oa.1 p.2
    let alEff := oa.2 || C.emitAlarm p.1 obsC
    let s' := C.next p.1 (obsC, alEff) d
    let x' := RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole
      G_hide (fun k => C.drawExt p.1 (Sum.inr k)) p.2
    (s', x')
  drawInt p
    | .inl j => C.drawInt p.1 j
    | .inr k => C.drawExt p.1 (Sum.inr k)
  drawExt p k := C.drawExt p.1 (Sum.inl k)
  emitAlarm p o := C.emitAlarm p.1 (wireObs o p.2)
  silenceLoad p := C.silenceLoad p.1
  favours p := C.favours p.1

/-- Hiding a boundary slice `ExtHide` yields an outer `InterfaceContract` whose invariant
guarantees permanent safety `x_crit_hide ≤ xHide` on every hidden site whenever internal monitoring
wires warning thresholds through `wireObs` with sufficient lag buffer. -/
def hideContract {S Obs ObsOuter Dist Int ExtKeep ExtHide : Type}
    {C : OpenComponent S Obs Dist Int (Sum ExtKeep ExtHide)}
    {init : S}
    (c : InterfaceContract C init)
    (G_hide : ExtHide → (ExtHide → Nat) → Nat)
    (wireObs : ObsOuter → (ExtHide → Nat) → Obs)
    (tolOuter : ObsOuter × Bool → Dist → Prop)
    (warnOuter : ObsOuter → Prop)
    (x_crit_hide warnHide H_safe_hide x₀_hide : ExtHide → Nat)
    (tol_lifts : ∀ o xh al b d, tolOuter (o, al) d → c.tol (wireObs o xh, b) d)
    (G_hide_rises : ∀ k, RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (G_hide k))
    (wire_outer_warn : ∀ o xh, warnOuter o → c.warnObs (wireObs o xh))
    (wire_hide_warn : ∀ o xh, (∃ k, xh k < warnHide k) → c.warnObs (wireObs o xh))
    (hide_post_viable : ∀ k, x_crit_hide k ≤
      RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole G_hide H_safe_hide x_crit_hide k)
    (hide_post_budget : ∀ k, c.postBudgetExt (Sum.inr k) ≤ H_safe_hide k)
    (hide_warn_margin : ∀ k,
      x_crit_hide k + (c.maxLag + 1) * c.preCapExt (Sum.inr k) ≤ warnHide k)
    (hide_init_margin : ∀ k,
      x_crit_hide k + c.eta init * c.preCapExt (Sum.inr k) ≤ x₀_hide k) :
    InterfaceContract (OpenComponent.hide C G_hide wireObs) (init, x₀_hide) where
  tol := tolOuter
  warnObs := warnOuter
  preCapInt
    | .inl j => c.preCapInt j
    | .inr k => c.preCapExt (Sum.inr k)
  preCapExt k := c.preCapExt (Sum.inl k)
  postBudgetInt
    | .inl j => c.postBudgetInt j
    | .inr k => c.postBudgetExt (Sum.inr k)
  postBudgetExt k := c.postBudgetExt (Sum.inl k)
  maxSilence := c.maxSilence
  maxLag := c.maxLag
  K p := c.K p.1 ∧ ∀ k, x_crit_hide k + c.eta p.1 * c.preCapExt (Sum.inr k) ≤ p.2 k
  eta p := c.eta p.1
  init_in := ⟨c.init_in, hide_init_margin⟩
  cert := Viability.certificate_disturbed_iff.mpr
    ⟨fun p ⟨hK, _⟩ =>
      let w := c.cert.within p.1 hK
      ⟨fun j => match j with
         | .inl j₁ => w.1 j₁
         | .inr k => w.2.1 (Sum.inr k),
       fun k => w.2.1 (Sum.inl k),
       w.2.2.1,
       fun h0 =>
         let q := w.2.2.2 h0
         ⟨q.1,
          fun j => match j with
            | .inl j₁ => q.2.1 j₁
            | .inr k => q.2.2 (Sum.inr k),
          fun k => q.2.2 (Sum.inl k)⟩⟩,
     fun p m adm ⟨hK, margin⟩ => by
       obtain ⟨⟨o, al⟩, d⟩ := m
       let obsC := wireObs o p.2
       let alEff := al || C.emitAlarm p.1 obsC
       let s' := C.next p.1 (obsC, alEff) d
       have tolC : c.tol (obsC, alEff) d := tol_lifts o p.2 al alEff d adm
       have hK' : c.K s' := c.cert.closed p.1 ((obsC, alEff), d) s' ⟨tolC, rfl⟩ hK
       have wP := c.cert.within p.1 hK
       refine ⟨hK', fun k => ?_⟩
       refine substrate_margin_step G_hide_rises
         (fun j => wP.2.1 (Sum.inr j))
         (c.eta_bound s' hK') hide_post_viable hide_warn_margin margin k ?_
       intro below
       have warnC : c.warnObs obsC := wire_hide_warn o p.2 ⟨k, below⟩
       have emitTrue : C.emitAlarm p.1 obsC = true := c.emits_on_warn p.1 obsC hK warnC
       have alTrue : alEff = true := by
         dsimp only [alEff]
         rw [emitTrue]
         exact CoreHelpers.bool_or_true_right al
       have tolTrue : c.tol (obsC, true) d := alTrue ▸ tolC
       refine ⟨fun h0 => ?_, fun pos => ?_⟩
       · have hEta0' : c.eta s' = 0 := by
           show c.eta (C.next p.1 (obsC, alEff) d) = 0
           rw [alTrue]
           exact c.eta_alarm_zero p.1 obsC d tolTrue hK h0
         have hPost := wP.2.2.2 h0
         exact ⟨hEta0', fun j => Nat.le_trans (hPost.2.2 (Sum.inr j)) (hide_post_budget j)⟩
       · show c.eta (C.next p.1 (obsC, alEff) d) + 1 ≤ c.eta p.1
         rw [alTrue]
         exact c.eta_alarm_step p.1 obsC d tolTrue hK pos⟩
  eta_bound p hp := c.eta_bound p.1 hp.1
  emits_on_warn p o hp w := c.emits_on_warn p.1 (wireObs o p.2) hp.1 (wire_outer_warn o p.2 w)
  eta_alarm_step p o d adm hp pos := by
    have alTrue : (true || C.emitAlarm p.1 (wireObs o p.2)) = true := rfl
    show c.eta (C.next p.1 (wireObs o p.2, true || C.emitAlarm p.1 (wireObs o p.2)) d) < c.eta p.1
    rw [alTrue]
    exact c.eta_alarm_step p.1 (wireObs o p.2) d (tol_lifts o p.2 true true d adm) hp.1 pos
  eta_alarm_zero p o d adm hp h0 := by
    have alTrue : (true || C.emitAlarm p.1 (wireObs o p.2)) = true := rfl
    show c.eta (C.next p.1 (wireObs o p.2, true || C.emitAlarm p.1 (wireObs o p.2)) d) = 0
    rw [alTrue]
    exact c.eta_alarm_zero p.1 (wireObs o p.2) d (tol_lifts o p.2 true true d adm) hp.1 h0

/-- Any state satisfying `hideContract`'s invariant keeps all hidden sites at or above `x_crit_hide`. -/
theorem hideContract_keeps_hidden {S Obs ObsOuter Dist Int ExtKeep ExtHide : Type}
    {C : OpenComponent S Obs Dist Int (Sum ExtKeep ExtHide)}
    {init : S} {c : InterfaceContract C init}
    {G_hide : ExtHide → (ExtHide → Nat) → Nat}
    {wireObs : ObsOuter → (ExtHide → Nat) → Obs}
    {tolOuter : ObsOuter × Bool → Dist → Prop} {warnOuter : ObsOuter → Prop}
    {x_crit_hide warnHide H_safe_hide x₀_hide : ExtHide → Nat}
    {tol_lifts G_hide_rises wire_outer_warn wire_hide_warn hide_post_viable hide_post_budget
     hide_warn_margin hide_init_margin}
    {p : S × (ExtHide → Nat)}
    (hp : (hideContract c G_hide wireObs tolOuter warnOuter x_crit_hide warnHide H_safe_hide x₀_hide
      tol_lifts G_hide_rises wire_outer_warn wire_hide_warn hide_post_viable hide_post_budget
      hide_warn_margin hide_init_margin).K p)
    (k : ExtHide) : x_crit_hide k ≤ p.2 k :=
  Nat.le_trans (Nat.le_add_right _ _) (hp.2 k)

/-! ## Part 2b: Multi-agent family composition & reusable open-loop factories -/

/-- Total draw across a list of agents at site `j`. -/
def sumDraws {α ι : Type} (agents : List α) (f : α → ι → Nat) (j : ι) : Nat :=
  match agents with
  | [] => 0
  | i :: rest => f i j + sumDraws rest f j

theorem sumDraws_le {α ι : Type} {f g : α → ι → Nat} (j : ι) :
    ∀ {agents : List α}, (∀ i, i ∈ agents → f i j ≤ g i j) →
      sumDraws agents f j ≤ sumDraws agents g j
  | [], _ => Nat.le_refl 0
  | _ :: _, bound => Nat.add_le_add (bound _ (.head _))
      (sumDraws_le j fun i mem => bound i (.tail _ mem))

private theorem foldr_or_true_of_mem {α : Type} {p : α → Bool} :
    ∀ {agents : List α} {i : α}, i ∈ agents → p i = true →
      agents.foldr (fun k acc => p k || acc) false = true
  | _ :: _, _, .head _, htrue => by
    show (p _ || _) = true
    rw [htrue]
    rfl
  | _ :: _, _, .tail _ mem, htrue => by
    show (p _ || List.foldr _ false _) = true
    rw [foldr_or_true_of_mem mem htrue]
    exact CoreHelpers.bool_or_true_right _

/-- Package a list of dependent `OpenLoop`s into a single `OpenComponent` (`Int = Empty`). -/
def familyComponent {α ι : Type} {S Obs Dist : α → Type}
    (agents : List α)
    (L : (i : α) → OpenLoop (S i) (Obs i) (Dist i) ι) :
    OpenComponent ((i : α) → S i) ((i : α) → Obs i) ((i : α) → Dist i) Empty ι where
  next s oa d i := (L i).next (s i) (oa.1 i, oa.2) (d i)
  drawInt _ e := Empty.elim e
  drawExt s j := sumDraws agents (fun i => (L i).draw (s i)) j
  emitAlarm s obs := agents.foldr (fun i acc => (L i).emitAlarm (s i) (obs i) || acc) false
  silenceLoad s := sumDraws agents (fun i _ => (L i).silenceLoad (s i)) ()
  favours s := ∃ i, i ∈ agents ∧ (L i).favours (s i)

/-- Package per-agent `LoopCertificate`s into a joint `InterfaceContract` over `familyComponent`. -/
def familyContract {α ι : Type} {S Obs Dist : α → Type}
    (agents : List α)
    (L : (i : α) → OpenLoop (S i) (Obs i) (Dist i) ι)
    (init : (i : α) → S i)
    (certs : (i : α) → LoopCertificate (L i) (init i)) :
    InterfaceContract (familyComponent agents L) init where
  tol oa d := ∀ i, i ∈ agents → (certs i).tol (oa.1 i, oa.2) (d i)
  warnObs o := ∃ i, i ∈ agents ∧ (certs i).warnObs (o i)
  preCapInt e := Empty.elim e
  preCapExt j := sumDraws agents (fun i => (certs i).preCap) j
  postBudgetInt e := Empty.elim e
  postBudgetExt j := sumDraws agents (fun i => (certs i).postBudget) j
  maxSilence := sumDraws agents (fun i _ => (certs i).maxSilence) ()
  maxLag := CoreHelpers.foldNatMax agents (fun i => (certs i).maxLag)
  K s := ∀ i, i ∈ agents → (certs i).K (s i)
  eta s := CoreHelpers.foldNatMax agents (fun i => (certs i).eta (s i))
  init_in i _ := (certs i).init_in
  cert := Viability.certificate_disturbed_iff.mpr
    ⟨fun s hK =>
      ⟨fun e => Empty.elim e,
       fun j => sumDraws_le j fun i mem => ((certs i).cert.within _ (hK i mem)).1 j,
       sumDraws_le () fun i mem => ((certs i).cert.within _ (hK i mem)).2.1,
       fun hEta0 =>
         have eachZero : ∀ i, i ∈ agents → (certs i).eta (s i) = 0 := fun i mem =>
           Nat.eq_zero_of_le_zero
             (Nat.le_trans (CoreHelpers.le_foldNatMax_of_mem (f := fun k => (certs k).eta (s k)) mem)
               (Nat.le_of_eq hEta0))
         ⟨fun ⟨i, mem, fav⟩ => (((certs i).cert.within _ (hK i mem)).2.2 (eachZero i mem)).1 fav,
          fun e => Empty.elim e,
          fun j => sumDraws_le j fun i mem =>
            (((certs i).cert.within _ (hK i mem)).2.2 (eachZero i mem)).2 j⟩⟩,
     fun s m tolOk hK i mem =>
       (certs i).cert.closed (s i) ((m.1.1 i, m.1.2), m.2 i) _ ⟨tolOk i mem, rfl⟩ (hK i mem)⟩
  eta_bound s hK :=
    CoreHelpers.foldNatMax_le_of_all fun i mem =>
      Nat.le_trans ((certs i).eta_bound (s i) (hK i mem))
        (CoreHelpers.le_foldNatMax_of_mem (f := fun k => (certs k).maxLag) mem)
  emits_on_warn s o hK := fun ⟨i, mem, warn⟩ =>
    foldr_or_true_of_mem mem ((certs i).emits_on_warn (s i) (o i) (hK i mem) warn)
  eta_alarm_step s o d tolOk hK pos :=
    CoreHelpers.foldNatMax_succ_le pos fun i mem => by
      show (certs i).eta ((L i).next (s i) (o i, true) (d i)) + 1 ≤
        CoreHelpers.foldNatMax agents fun m => (certs m).eta (s m)
      cases hI : (certs i).eta (s i) with
      | zero =>
        rw [(certs i).eta_alarm_zero (s i) (o i) (d i) (tolOk i mem) (hK i mem) hI]
        exact pos
      | succ k =>
        exact Nat.le_trans
          ((certs i).eta_alarm_step (s i) (o i) (d i) (tolOk i mem) (hK i mem) (hI ▸ Nat.succ_pos k))
          (CoreHelpers.le_foldNatMax_of_mem (f := fun m => (certs m).eta (s m)) mem)
  eta_alarm_zero s o d tolOk hK h0 :=
    CoreHelpers.foldNatMax_eq_zero fun i mem =>
      have hi0 : (certs i).eta (s i) = 0 :=
        Nat.eq_zero_of_le_zero
          (Nat.le_trans (CoreHelpers.le_foldNatMax_of_mem (f := fun m => (certs m).eta (s m)) mem)
            (Nat.le_of_eq h0))
      (certs i).eta_alarm_zero (s i) (o i) (d i) (tolOk i mem) (hK i mem) hi0

/-- Canonical synchronous zero-silence-budget alarm channel. -/
def zeroSilenceChannel (em : Bool) (load : Nat) (_ : Unit) : Bool :=
  em && Nat.ble load 0

/-- Stateless open component drawing constant `H` on a scalar `Unit` boundary. -/
def constDrawerComponent (H : Nat) : OpenComponent Unit Unit Unit Empty Unit where
  next _ _ _ := ()
  drawInt _ e := Empty.elim e
  drawExt _ _ := H
  emitAlarm _ _ := false
  silenceLoad _ := 0
  favours _ := False

/-- Assume-guarantee `InterfaceContract` for `constDrawerComponent H`. -/
def constDrawerContract (H : Nat) : InterfaceContract (constDrawerComponent H) () where
  tol _ _ := True
  warnObs _ := False
  preCapInt e := Empty.elim e
  preCapExt _ := H
  postBudgetInt e := Empty.elim e
  postBudgetExt _ := H
  maxSilence := 0
  maxLag := 0
  K _ := True
  eta _ := 0
  init_in := trivial
  cert := Viability.certificate_disturbed_iff.mpr
    ⟨fun _ _ => ⟨fun e => Empty.elim e, fun _ => Nat.le_refl H, Nat.le_refl 0,
      fun _ => ⟨fun f => f, fun e => Empty.elim e, fun _ => Nat.le_refl H⟩⟩,
     fun _ _ _ _ => trivial⟩
  eta_bound _ _ := Nat.le_refl 0
  emits_on_warn _ _ _ f := False.elim f
  eta_alarm_step _ _ _ _ _ pos := absurd pos (Nat.lt_irrefl 0)
  eta_alarm_zero _ _ _ _ _ _ := rfl

/-- Generic countdown `OpenLoop` dropping draw from `preCap` to `postCap` within `maxLag` alarms. -/
def countdownLoop (preCap postCap : Nat) {Obs : Type} (emitAlarm : Nat → Obs → Bool) :
    OpenLoop Nat Obs Unit Unit where
  next s obsAlarm _ := if obsAlarm.2 then s - 1 else s
  draw s _ := if s = 0 then postCap else preCap
  emitAlarm := emitAlarm
  silenceLoad _ := 0
  favours s := 0 < s

/-- Generic assume-guarantee `LoopCertificate` for `countdownLoop`. -/
def countdownCert (preCap postCap maxSilence maxLag init : Nat) {Obs : Type}
    (emitAlarm : Nat → Obs → Bool) (warnObs : Obs → Prop)
    (post_le : postCap ≤ preCap) (init_le : init ≤ maxLag)
    (emits : ∀ s obs, s ≤ maxLag → warnObs obs → emitAlarm s obs = true) :
    LoopCertificate (countdownLoop preCap postCap emitAlarm) init where
  tol _ _ := True
  warnObs := warnObs
  preCap _ := preCap
  postBudget _ := postCap
  maxSilence := maxSilence
  maxLag := maxLag
  K s := s ≤ maxLag
  eta s := s
  init_in := init_le
  cert := Viability.certificate_disturbed_iff.mpr
    ⟨fun s _ =>
      ⟨fun _ => by
        show (if s = 0 then postCap else preCap) ≤ preCap
        cases Nat.decEq s 0 with
        | isTrue h0 => rw [if_pos h0]; exact post_le
        | isFalse hn => rw [if_neg hn]; exact Nat.le_refl _,
       Nat.zero_le maxSilence,
       fun h0 => ⟨by rw [h0]; exact Nat.lt_irrefl 0, fun _ => by
         show (if s = 0 then postCap else preCap) ≤ postCap
         rw [if_pos h0]; exact Nat.le_refl _⟩⟩,
     fun s m _ hs => by
       show (if m.1.2 then s - 1 else s) ≤ maxLag
       cases m.1.2
       · exact hs
       · exact Nat.le_trans (Nat.sub_le s 1) hs⟩
  eta_bound _ hs := hs
  emits_on_warn := emits
  eta_alarm_step s _ _ _ _ pos := match s, pos with
    | s' + 1, _ => Nat.lt_succ_self s'
  eta_alarm_zero s _ _ _ _ h0 := by
    show s - 1 = 0
    rw [h0]

/-- Lifted `OpenComponent` of `countdownLoop`. -/
def countdownComponent (preCap postCap : Nat) {Obs : Type} (emitAlarm : Nat → Obs → Bool) :
    OpenComponent Nat Obs Unit Empty Unit :=
  OpenComponent.ofOpenLoop (countdownLoop preCap postCap emitAlarm)

/-- Lifted `InterfaceContract` of `countdownCert`. -/
def countdownContract (preCap postCap maxSilence maxLag init : Nat) {Obs : Type}
    (emitAlarm : Nat → Obs → Bool) (warnObs : Obs → Prop)
    (post_le : postCap ≤ preCap) (init_le : init ≤ maxLag)
    (emits : ∀ s obs, s ≤ maxLag → warnObs obs → emitAlarm s obs = true) :
    InterfaceContract (countdownComponent preCap postCap emitAlarm) init :=
  InterfaceContract.ofLoopCertificate
    (countdownCert preCap postCap maxSilence maxLag init emitAlarm warnObs post_le init_le emits)

/-! ## Part 3: Closing onto Coupled Substrates & Conditional Double-Category Interchange -/

/-- Closed step parameterized by an arbitrary alarm rule `alarmOf : S → Obs → Env → Bool`. -/
def closedStepWith {S Obs Dist Int Ext Env : Type}
    (C : OpenComponent S Obs Dist Int Ext)
    (obs : (Ext → Nat) → Obs)
    (alarmOf : S → Obs → Env → Bool)
    (G : Ext → (Ext → Nat) → Nat)
    (envDraw : Env → Ext → Nat)
    (st : (Ext → Nat) × S)
    (m : Env × Dist) :
    (Ext → Nat) × S :=
  let o := obs st.1
  let al := alarmOf st.2 o m.1
  let H := fun k => C.drawExt st.2 k + envDraw m.1 k
  (RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole G H st.1,
   C.next st.2 (o, al) m.2)

/-- Closed step of an `OpenComponent` interacting with an exposed boundary substrate `G`, an
observation channel `channel` blind to raw substrate `x`, and environment draw `envDraw`. -/
def closedStep {S Obs Dist Int Ext Env : Type}
    (C : OpenComponent S Obs Dist Int Ext)
    (obs : (Ext → Nat) → Obs)
    (channel : Bool → Nat → Env → Bool)
    (G : Ext → (Ext → Nat) → Nat)
    (envDraw : Env → Ext → Nat)
    (st : (Ext → Nat) × S)
    (m : Env × Dist) :
    (Ext → Nat) × S :=
  closedStepWith C obs (fun s o env => channel (C.emitAlarm s o) (C.silenceLoad s) env) G envDraw st m

def closedAdm {S Obs Dist Int Ext Env : Type}
    {C : OpenComponent S Obs Dist Int Ext} {init : S}
    (c : InterfaceContract C init)
    (jointAdm : Env → Prop)
    (m : Env × Dist) : Prop :=
  jointAdm m.1 ∧ ∀ ob, c.tol ob m.2

def closedProcess {S Obs Dist Int Ext Env : Type}
    (C : OpenComponent S Obs Dist Int Ext) {init : S}
    (c : InterfaceContract C init)
    (obs : (Ext → Nat) → Obs)
    (channel : Bool → Nat → Env → Bool)
    (G : Ext → (Ext → Nat) → Nat)
    (envDraw : Env → Ext → Nat)
    (jointAdm : Env → Prop) :
    Process ((Ext → Nat) × S) (Env × Dist) :=
  Viability.disturbed (closedStep C obs channel G envDraw) (closedAdm c jointAdm)

def closedGuard {S Obs Dist Int Ext : Type}
    (C : OpenComponent S Obs Dist Int Ext) {init : S}
    (c : InterfaceContract C init)
    (x_crit : Ext → Nat)
    (st : (Ext → Nat) × S) : Prop :=
  (∀ k, x_crit k ≤ st.1 k) ∧
  (∀ j, C.drawInt st.2 j ≤ c.preCapInt j) ∧
  (∀ k, C.drawExt st.2 k ≤ c.preCapExt k) ∧
  C.silenceLoad st.2 ≤ c.maxSilence ∧
  (c.eta st.2 = 0 → ¬ C.favours st.2 ∧
    (∀ j, C.drawInt st.2 j ≤ c.postBudgetInt j) ∧
    (∀ k, C.drawExt st.2 k ≤ c.postBudgetExt k))

def closedInv {S Obs Dist Int Ext : Type}
    {C : OpenComponent S Obs Dist Int Ext} {init : S}
    (c : InterfaceContract C init)
    (envCap x_crit : Ext → Nat)
    (st : (Ext → Nat) × S) : Prop :=
  c.K st.2 ∧ ∀ k, x_crit k + c.eta st.2 * (c.preCapExt k + envCap k) ≤ st.1 k

/-- Closing any `OpenComponent` carrying an `InterfaceContract` onto a coupled boundary substrate
with an arbitrary alarm-firing rule `alarmOf` certifies permanent `Viability.Certificate`. -/
theorem close_contract_with_viable {S Obs Dist Int Ext Env : Type}
    (C : OpenComponent S Obs Dist Int Ext) {init : S}
    (c : InterfaceContract C init)
    (obs : (Ext → Nat) → Obs)
    (alarmOf : S → Obs → Env → Bool)
    (G : Ext → (Ext → Nat) → Nat)
    (envDraw : Env → Ext → Nat) (envCap : Ext → Nat) (jointAdm : Env → Prop)
    (env_within : ∀ env, jointAdm env → ∀ k, envDraw env k ≤ envCap k)
    (x_crit warnLevel H_safe x₀ : Ext → Nat)
    (obs_detects : ∀ x k, x k < warnLevel k → c.warnObs (obs x))
    (alarm_fires : ∀ s o env, jointAdm env → c.K s → c.warnObs o → alarmOf s o env = true)
    (G_rises : ∀ k, RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (G k))
    (post_viable : ∀ k, x_crit k ≤
      RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole G H_safe x_crit k)
    (post_budget : ∀ k, c.postBudgetExt k + envCap k ≤ H_safe k)
    (warn_margin : ∀ k, x_crit k + (c.maxLag + 1) * (c.preCapExt k + envCap k) ≤ warnLevel k)
    (init_margin : ∀ k, x_crit k + c.eta init * (c.preCapExt k + envCap k) ≤ x₀ k) :
    closedInv c envCap x_crit (x₀, init) ∧
    Viability.Certificate (Viability.disturbed (closedStepWith C obs alarmOf G envDraw) (closedAdm c jointAdm))
      (closedGuard C c x_crit) (closedInv c envCap x_crit) := by
  refine ⟨⟨c.init_in, init_margin⟩, Viability.certificate_disturbed_iff.mpr ⟨?_, ?_⟩⟩
  · intro st ⟨hK, margin⟩
    exact ⟨fun k => Nat.le_trans (Nat.le_add_right _ _) (margin k), c.cert.within st.2 hK⟩
  · intro st m adm ⟨hK, margin⟩
    obtain ⟨x, s⟩ := st
    obtain ⟨env, dist⟩ := m
    obtain ⟨envOk, tolOk⟩ := adm
    let o := obs x
    let al := alarmOf s o env
    let H := fun k => C.drawExt s k + envDraw env k
    let s' := C.next s (o, al) dist
    have wS := c.cert.within s hK
    have hK' : c.K s' := c.cert.closed s ((o, al), dist) s' ⟨tolOk (o, al), rfl⟩ hK
    have H_le_pre : ∀ k, H k ≤ c.preCapExt k + envCap k := fun k =>
      Nat.add_le_add (wS.2.1 k) (env_within env envOk k)
    refine ⟨hK', fun k => ?_⟩
    refine substrate_margin_step G_rises H_le_pre (c.eta_bound s' hK') post_viable warn_margin margin k ?_
    intro below
    have alTrue : al = true := alarm_fires s o env envOk hK (obs_detects x k below)
    refine ⟨fun h0 => ?_, fun pos => ?_⟩
    · have hEta0' : c.eta s' = 0 := by
        show c.eta (C.next s (o, al) dist) = 0
        rw [alTrue]
        exact c.eta_alarm_zero s o dist (tolOk (o, true)) hK h0
      exact ⟨hEta0', fun k' =>
        Nat.le_trans (Nat.add_le_add ((wS.2.2.2 h0).2.2 k') (env_within env envOk k')) (post_budget k')⟩
    · show c.eta (C.next s (o, al) dist) + 1 ≤ c.eta s
      rw [alTrue]
      exact c.eta_alarm_step s o dist (tolOk (o, true)) hK pos

/-- Closing any `OpenComponent` carrying an `InterfaceContract` onto a coupled boundary substrate
certifies permanent `Viability.Certificate` and `Viability.Kernel` above `x_crit`. -/
theorem close_contract_viable {S Obs Dist Int Ext Env : Type}
    (C : OpenComponent S Obs Dist Int Ext) {init : S}
    (c : InterfaceContract C init)
    (obs : (Ext → Nat) → Obs)
    (channel : Bool → Nat → Env → Bool)
    (G : Ext → (Ext → Nat) → Nat)
    (envDraw : Env → Ext → Nat) (envCap : Ext → Nat) (jointAdm : Env → Prop)
    (env_within : ∀ env, jointAdm env → ∀ k, envDraw env k ≤ envCap k)
    (x_crit warnLevel H_safe x₀ : Ext → Nat)
    (obs_detects : ∀ x k, x k < warnLevel k → c.warnObs (obs x))
    (channel_fires : ∀ load env, jointAdm env → load ≤ c.maxSilence →
      channel true load env = true)
    (G_rises : ∀ k, RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (G k))
    (post_viable : ∀ k, x_crit k ≤
      RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole G H_safe x_crit k)
    (post_budget : ∀ k, c.postBudgetExt k + envCap k ≤ H_safe k)
    (warn_margin : ∀ k, x_crit k + (c.maxLag + 1) * (c.preCapExt k + envCap k) ≤ warnLevel k)
    (init_margin : ∀ k, x_crit k + c.eta init * (c.preCapExt k + envCap k) ≤ x₀ k) :
    closedInv c envCap x_crit (x₀, init) ∧
    Viability.Certificate (closedProcess C c obs channel G envDraw jointAdm)
      (closedGuard C c x_crit) (closedInv c envCap x_crit) :=
  close_contract_with_viable C c obs
    (fun s o env => channel (C.emitAlarm s o) (C.silenceLoad s) env) G envDraw envCap jointAdm
    env_within x_crit warnLevel H_safe x₀ obs_detects
    (fun s o env envOk hK hWarn => by
      show channel (C.emitAlarm s o) (C.silenceLoad s) env = true
      rw [c.emits_on_warn s o hK hWarn]
      exact channel_fires (C.silenceLoad s) env envOk (c.cert.within s hK).2.2.1)
    G_rises post_viable post_budget warn_margin init_margin

theorem close_contract_kernel {S Obs Dist Int Ext Env : Type}
    (C : OpenComponent S Obs Dist Int Ext) {init : S}
    (c : InterfaceContract C init)
    (obs : (Ext → Nat) → Obs)
    (channel : Bool → Nat → Env → Bool)
    (G : Ext → (Ext → Nat) → Nat)
    (envDraw : Env → Ext → Nat) (envCap : Ext → Nat) (jointAdm : Env → Prop)
    (env_within : ∀ env, jointAdm env → ∀ k, envDraw env k ≤ envCap k)
    (x_crit warnLevel H_safe x₀ : Ext → Nat)
    (obs_detects : ∀ x k, x k < warnLevel k → c.warnObs (obs x))
    (channel_fires : ∀ load env, jointAdm env → load ≤ c.maxSilence →
      channel true load env = true)
    (G_rises : ∀ k, RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (G k))
    (post_viable : ∀ k, x_crit k ≤
      RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole G H_safe x_crit k)
    (post_budget : ∀ k, c.postBudgetExt k + envCap k ≤ H_safe k)
    (warn_margin : ∀ k, x_crit k + (c.maxLag + 1) * (c.preCapExt k + envCap k) ≤ warnLevel k)
    (init_margin : ∀ k, x_crit k + c.eta init * (c.preCapExt k + envCap k) ≤ x₀ k) :
    Viability.Kernel (closedProcess C c obs channel G envDraw jointAdm)
      (closedGuard C c x_crit) (x₀, init) :=
  let res := close_contract_viable C c obs channel G envDraw envCap jointAdm env_within
    x_crit warnLevel H_safe x₀ obs_detects channel_fires G_rises post_viable post_budget
    warn_margin init_margin
  res.2.kernel res.1

/-- **Composition-preserved closed substrate viability (`compose_close_interchange`)**: horizontal
composition `A ⊕_K B` preserves closed substrate viability (`Viability.Kernel` of `closedProcess`)
whenever boundary warnings from either component trigger the shared channel and boundary buffers
cover combined lag and draw. -/
theorem compose_close_interchange
    {S₁ S₂ Obs₁ Obs₂ Dist₁ Dist₂ Int₁ Int₂ Ext Env : Type}
    (A : OpenComponent S₁ Obs₁ Dist₁ Int₁ Ext)
    (B : OpenComponent S₂ Obs₂ Dist₂ Int₂ Ext)
    {init₁ : S₁} {init₂ : S₂}
    (cA : InterfaceContract A init₁)
    (cB : InterfaceContract B init₂)
    (obs₁ : (Ext → Nat) → Obs₁)
    (obs₂ : (Ext → Nat) → Obs₂)
    (channel : Bool → Nat → Env → Bool)
    (G : Ext → (Ext → Nat) → Nat)
    (envDraw : Env → Ext → Nat) (envCap : Ext → Nat) (jointAdm : Env → Prop)
    (env_within : ∀ env, jointAdm env → ∀ k, envDraw env k ≤ envCap k)
    (x_crit warnLevel H_safe x₀ : Ext → Nat)
    (obs_detects : ∀ x k, x k < warnLevel k →
      cA.warnObs (obs₁ x) ∨ cB.warnObs (obs₂ x))
    (channel_fires : ∀ load env, jointAdm env → load ≤ cA.maxSilence + cB.maxSilence →
      channel true load env = true)
    (G_rises : ∀ k, RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (G k))
    (post_viable : ∀ k, x_crit k ≤
      RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole G H_safe x_crit k)
    (post_budget : ∀ k, (cA.postBudgetExt k + cB.postBudgetExt k) + envCap k ≤ H_safe k)
    (warn_margin : ∀ k, x_crit k +
      (CoreHelpers.natMax cA.maxLag cB.maxLag + 1) *
        ((cA.preCapExt k + cB.preCapExt k) + envCap k) ≤ warnLevel k)
    (init_margin : ∀ k, x_crit k +
      CoreHelpers.natMax (cA.eta init₁) (cB.eta init₂) *
        ((cA.preCapExt k + cB.preCapExt k) + envCap k) ≤ x₀ k) :
    Viability.Kernel
      (closedProcess (OpenComponent.compose A B) (composeContract cA cB)
        (fun x => (obs₁ x, obs₂ x)) channel G envDraw jointAdm)
      (closedGuard (OpenComponent.compose A B) (composeContract cA cB) x_crit)
      (x₀, (init₁, init₂)) :=
  close_contract_kernel (OpenComponent.compose A B) (composeContract cA cB)
    (fun x => (obs₁ x, obs₂ x)) channel G envDraw envCap jointAdm env_within
    x_crit warnLevel H_safe x₀ obs_detects channel_fires G_rises post_viable post_budget
    warn_margin init_margin

/-! ### Sharp Counter-Model: Hidden Shared Substrate Breaks Unmonitored Composition -/

namespace HiddenCouplingFailure

def sharedG (_ : Unit) (e : Unit → Nat) : Nat := if 2 ≤ e () then 1 else 0

theorem sharedG_rises :
    ∀ k : Unit, RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (sharedG k) :=
  fun _ e _ below =>
    match Nat.decLe 2 (e ()) with
    | isTrue h => Nat.le_trans (Nat.le_of_eq (if_pos h))
        (Nat.le_of_eq (if_pos (Nat.le_trans h (below ()))).symm)
    | isFalse h => Nat.le_trans (Nat.le_of_eq (if_neg h)) (Nat.zero_le _)

/-- A simple open component that ignores external alarms when blind to the shared site and always
draws `1` unit (`postBudgetExt = 1` solo-viable against renewal `1`). -/
def blindDrawer : OpenComponent Unit Unit Unit Empty Unit := constDrawerComponent 1

def blindContract : InterfaceContract blindDrawer () := constDrawerContract 1

def blindStep :=
  closedStep blindDrawer (fun _ => ()) (fun (_ : Bool) (_ : Nat) (_ : Unit) => false) sharedG
    (fun (_ : Unit) (_ : Unit) => 0)

def composedStep :=
  closedStep (OpenComponent.compose blindDrawer blindDrawer)
    (fun _ => ((), ())) (fun (_ : Bool) (_ : Nat) (_ : Unit) => false) sharedG
    (fun (_ : Unit) (_ : Unit) => 0)

/-- **Hidden-coupling interchange failure witness (`witness`)**:
Each `blindDrawer` is certified solo-viable forever above `x_crit = 3` from `x₀ = 4` (`4 → 4 → ...`),
yet their composition `blindDrawer ⊕ blindDrawer` over the unmonitored shared substrate `sharedG`
draws `2` against renewal `1` and collapses `4 → 3 → 2 → 0` by step 4. -/
theorem witness :
    (∀ t, 3 ≤ (Law.orbit (fun st => blindStep st ((), ())) (fun _ => 4, ()) t).1 ()) ∧
    Viability.Kernel
      (closedProcess blindDrawer blindContract (fun _ => ())
        (fun (_ : Bool) (_ : Nat) (_ : Unit) => false) sharedG
        (fun (_ : Unit) (_ : Unit) => 0) (fun (_ : Unit) => True))
      (closedGuard blindDrawer blindContract (fun _ => 3))
      (fun _ => 4, ()) ∧
    (Law.orbit (fun st => composedStep st ((), ((), ()))) (fun _ => 4, ((), ())) 4).1 () = 0 := by
  have soloKern : Viability.Kernel
      (closedProcess blindDrawer blindContract (fun _ => ())
        (fun (_ : Bool) (_ : Nat) (_ : Unit) => false) sharedG
        (fun (_ : Unit) (_ : Unit) => 0) (fun (_ : Unit) => True))
      (closedGuard blindDrawer blindContract (fun _ => 3))
      (fun _ => 4, ()) := by
    have certSolo : Viability.Certificate
        (closedProcess blindDrawer blindContract (fun _ => ())
          (fun (_ : Bool) (_ : Nat) (_ : Unit) => false) sharedG
          (fun (_ : Unit) (_ : Unit) => 0) (fun (_ : Unit) => True))
        (closedGuard blindDrawer blindContract (fun _ => 3))
        (fun st => 3 ≤ st.1 ()) := by
      refine Viability.certificate_disturbed_iff.mpr ⟨?_, ?_⟩
      · intro st h3
        exact ⟨fun k => by cases k; exact h3,
          fun e => Empty.elim e, fun _ => Nat.le_refl 1, Nat.le_refl 0,
          fun _ => ⟨fun f => f, fun e => Empty.elim e, fun _ => Nat.le_refl 1⟩⟩
      · intro st _ _ h3
        obtain ⟨x, _⟩ := st
        have hx : 3 ≤ x () := h3
        have sub2 : 2 ≤ x () - 1 := Naturals.le_sub_of_add_le hx
        have g1 : sharedG () (fun _ => x () - 1) = 1 := if_pos sub2
        show 3 ≤ (x () - 1) + sharedG () (fun _ => x () - 1)
        rw [g1]
        exact Nat.add_le_add_right sub2 1
    exact certSolo.kernel (by decide : 3 ≤ 4)
  refine ⟨fun t => ?_, soloKern, rfl⟩
  let run : Run (closedProcess blindDrawer blindContract (fun _ => ())
      (fun (_ : Bool) (_ : Nat) (_ : Unit) => false) sharedG
      (fun (_ : Unit) (_ : Unit) => 0) (fun (_ : Unit) => True)) :=
    ⟨Law.orbit (fun st => blindStep st ((), ())) (fun _ => 4, ()),
     fun _ => ((), ()),
     fun _ => ⟨⟨trivial, fun _ => trivial⟩, rfl⟩⟩
  exact (Viability.Kernel.run run soloKern t).1 ()

end HiddenCouplingFailure

theorem hidden_coupling_interchange_failure :
    (∀ t, 3 ≤ (Law.orbit (fun st => HiddenCouplingFailure.blindStep st ((), ())) (fun _ => 4, ()) t).1 ()) ∧
    Viability.Kernel
      (closedProcess HiddenCouplingFailure.blindDrawer HiddenCouplingFailure.blindContract (fun _ => ())
        (fun (_ : Bool) (_ : Nat) (_ : Unit) => false) HiddenCouplingFailure.sharedG
        (fun (_ : Unit) (_ : Unit) => 0) (fun (_ : Unit) => True))
      (closedGuard HiddenCouplingFailure.blindDrawer HiddenCouplingFailure.blindContract (fun _ => 3))
      (fun _ => 4, ()) ∧
    (Law.orbit (fun st => HiddenCouplingFailure.composedStep st ((), ((), ()))) (fun _ => 4, ((), ())) 4).1 () = 0 :=
  HiddenCouplingFailure.witness

/-! ## Part 4: Heterogeneous Structural Replacement, Live Rewrite, & Interface Widening -/

/-- Contract refinement `L ↝ R` across potentially heterogeneous internal state types `S₁ ≠ S₂` and
private port types `Int₁ ≠ Int₂`, preserving boundary resource and lag commitments on `Ext`. -/
structure ContractRefines
    {S₁ S₂ Obs₁ Obs₂ Dist₁ Dist₂ Int₁ Int₂ Ext : Type}
    {A : OpenComponent S₁ Obs₁ Dist₁ Int₁ Ext}
    {A' : OpenComponent S₂ Obs₂ Dist₂ Int₂ Ext}
    {init₁ : S₁} {init₂ : S₂}
    (cA : InterfaceContract A init₁)
    (cA' : InterfaceContract A' init₂)
    (obs₁ : (Ext → Nat) → Obs₁)
    (obs₂ : (Ext → Nat) → Obs₂)
    (warnLevel : Ext → Nat) : Prop where
  preCapExt_le : ∀ k, cA'.preCapExt k ≤ cA.preCapExt k
  postBudgetExt_le : ∀ k, cA'.postBudgetExt k ≤ cA.postBudgetExt k
  maxSilence_le : cA'.maxSilence ≤ cA.maxSilence
  maxLag_le : cA'.maxLag ≤ cA.maxLag
  init_eta_le : cA'.eta init₂ ≤ cA.eta init₁
  warn_preserved : ∀ x, cA.warnObs (obs₁ x) →
    (∃ k, x k < warnLevel k) → cA'.warnObs (obs₂ x)

/-- Generic contract-refinement viability transport (`replace_contract_viable`):
replacing any `(C, cC, obs)` with a refining `(C', cC', obs')` preserves `close_contract_kernel`. -/
theorem replace_contract_viable
    {S S' Obs Obs' Dist Dist' Int Int' Ext Env : Type}
    (C : OpenComponent S Obs Dist Int Ext)
    (C' : OpenComponent S' Obs' Dist' Int' Ext)
    {init : S} {init' : S'}
    (cC : InterfaceContract C init)
    (cC' : InterfaceContract C' init')
    (obs : (Ext → Nat) → Obs)
    (obs' : (Ext → Nat) → Obs')
    (channel : Bool → Nat → Env → Bool)
    (G : Ext → (Ext → Nat) → Nat)
    (envDraw : Env → Ext → Nat) (envCap : Ext → Nat) (jointAdm : Env → Prop)
    (env_within : ∀ env, jointAdm env → ∀ k, envDraw env k ≤ envCap k)
    (x_crit warnLevel H_safe x₀ : Ext → Nat)
    (refines : ContractRefines cC cC' obs obs' warnLevel)
    (obs_detects : ∀ x k, x k < warnLevel k → cC.warnObs (obs x))
    (channel_fires : ∀ load env, jointAdm env → load ≤ cC.maxSilence →
      channel true load env = true)
    (G_rises : ∀ k, RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (G k))
    (post_viable : ∀ k, x_crit k ≤
      RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole G H_safe x_crit k)
    (post_allow : ∀ k, cC.postBudgetExt k + envCap k ≤ H_safe k)
    (warn_margin : ∀ k, x_crit k + (cC.maxLag + 1) * (cC.preCapExt k + envCap k) ≤ warnLevel k)
    (init_margin : ∀ k, x_crit k + cC.eta init * (cC.preCapExt k + envCap k) ≤ x₀ k) :
    Viability.Kernel (closedProcess C' cC' obs' channel G envDraw jointAdm)
      (closedGuard C' cC' x_crit) (x₀, init') :=
  close_contract_kernel C' cC' obs' channel G envDraw envCap jointAdm env_within
    x_crit warnLevel H_safe x₀
    (fun x k lt => refines.warn_preserved x (obs_detects x k lt) ⟨k, lt⟩)
    (fun load env adm le => channel_fires load env adm (Nat.le_trans le refines.maxSilence_le))
    G_rises post_viable
    (fun k => Nat.le_trans (Nat.add_le_add_right (refines.postBudgetExt_le k) _) (post_allow k))
    (fun k => Nat.le_trans (Nat.add_le_add_left (Nat.mul_le_mul
      (Nat.succ_le_succ refines.maxLag_le) (Nat.add_le_add_right (refines.preCapExt_le k) _)) _)
      (warn_margin k))
    (fun k => Nat.le_trans (Nat.add_le_add_left (Nat.mul_le_mul
      refines.init_eta_le (Nat.add_le_add_right (refines.preCapExt_le k) _)) _)
      (init_margin k))

/-- Lift `ContractRefines` across the left slot of `composeContract`. -/
theorem contractRefines_compose_left
    {S₁ S₁' S₂ Obs₁ Obs₁' Obs₂ Dist₁ Dist₁' Dist₂ Int₁ Int₁' Int₂ Ext : Type}
    {A : OpenComponent S₁ Obs₁ Dist₁ Int₁ Ext}
    {A' : OpenComponent S₁' Obs₁' Dist₁' Int₁' Ext}
    {B : OpenComponent S₂ Obs₂ Dist₂ Int₂ Ext}
    {init₁ : S₁} {init₁' : S₁'} {init₂ : S₂}
    {cA : InterfaceContract A init₁}
    {cA' : InterfaceContract A' init₁'}
    (cB : InterfaceContract B init₂)
    {obs₁ : (Ext → Nat) → Obs₁} {obs₁' : (Ext → Nat) → Obs₁'}
    (obs₂ : (Ext → Nat) → Obs₂) {warnLevel : Ext → Nat}
    (ref : ContractRefines cA cA' obs₁ obs₁' warnLevel) :
    ContractRefines
      (composeContract cA cB)
      (composeContract cA' cB)
      (fun x => (obs₁ x, obs₂ x)) (fun x => (obs₁' x, obs₂ x)) warnLevel where
  preCapExt_le k := Nat.add_le_add_right (ref.preCapExt_le k) (cB.preCapExt k)
  postBudgetExt_le k := Nat.add_le_add_right (ref.postBudgetExt_le k) (cB.postBudgetExt k)
  maxSilence_le := Nat.add_le_add_right ref.maxSilence_le cB.maxSilence
  maxLag_le := CoreHelpers.natMax_le
    (Nat.le_trans ref.maxLag_le (CoreHelpers.le_natMax_left _ _))
    (CoreHelpers.le_natMax_right _ _)
  init_eta_le := CoreHelpers.natMax_le
    (Nat.le_trans ref.init_eta_le (CoreHelpers.le_natMax_left _ _))
    (CoreHelpers.le_natMax_right _ _)
  warn_preserved x hw hlt := match hw with
    | .inl w₁ => Or.inl (ref.warn_preserved x w₁ hlt)
    | .inr w₂ => Or.inr w₂

/-- Lift `ContractRefines` across the right slot of `composeContract`. -/
theorem contractRefines_compose_right
    {S₁ S₂ S₂' Obs₁ Obs₂ Obs₂' Dist₁ Dist₂ Dist₂' Int₁ Int₂ Int₂' Ext : Type}
    {A : OpenComponent S₁ Obs₁ Dist₁ Int₁ Ext}
    {B : OpenComponent S₂ Obs₂ Dist₂ Int₂ Ext}
    {B' : OpenComponent S₂' Obs₂' Dist₂' Int₂' Ext}
    {init₁ : S₁} {init₂ : S₂} {init₂' : S₂'}
    (cA : InterfaceContract A init₁)
    {cB : InterfaceContract B init₂}
    {cB' : InterfaceContract B' init₂'}
    (obs₁ : (Ext → Nat) → Obs₁)
    {obs₂ : (Ext → Nat) → Obs₂} {obs₂' : (Ext → Nat) → Obs₂'} {warnLevel : Ext → Nat}
    (ref : ContractRefines cB cB' obs₂ obs₂' warnLevel) :
    ContractRefines
      (composeContract cA cB)
      (composeContract cA cB')
      (fun x => (obs₁ x, obs₂ x)) (fun x => (obs₁ x, obs₂' x)) warnLevel where
  preCapExt_le k := Nat.add_le_add_left (ref.preCapExt_le k) (cA.preCapExt k)
  postBudgetExt_le k := Nat.add_le_add_left (ref.postBudgetExt_le k) (cA.postBudgetExt k)
  maxSilence_le := Nat.add_le_add_left ref.maxSilence_le cA.maxSilence
  maxLag_le := CoreHelpers.natMax_le
    (CoreHelpers.le_natMax_left _ _)
    (Nat.le_trans ref.maxLag_le (CoreHelpers.le_natMax_right _ _))
  init_eta_le := CoreHelpers.natMax_le
    (CoreHelpers.le_natMax_left _ _)
    (Nat.le_trans ref.init_eta_le (CoreHelpers.le_natMax_right _ _))
  warn_preserved x hw hlt := match hw with
    | .inl w₁ => Or.inl w₁
    | .inr w₂ => Or.inr (ref.warn_preserved x w₂ hlt)

/-- **Heterogeneous left-component replacement (`replace_left_viable`)**: replacing `A` inside
`A ⊕_K B` with any structurally different `A'` (`S₁ ≠ S₂`, `Int₁ ≠ Int₂`) satisfying
`ContractRefines` preserves global `compose_close_interchange` `Viability.Kernel` without
re-checking `B`. -/
theorem replace_left_viable
    {S₁ S₁' S₂ Obs₁ Obs₁' Obs₂ Dist₁ Dist₁' Dist₂ Int₁ Int₁' Int₂ Ext Env : Type}
    (A : OpenComponent S₁ Obs₁ Dist₁ Int₁ Ext)
    (A' : OpenComponent S₁' Obs₁' Dist₁' Int₁' Ext)
    (B : OpenComponent S₂ Obs₂ Dist₂ Int₂ Ext)
    {init₁ : S₁} {init₁' : S₁'} {init₂ : S₂}
    (cA : InterfaceContract A init₁)
    (cA' : InterfaceContract A' init₁')
    (cB : InterfaceContract B init₂)
    (obs₁ : (Ext → Nat) → Obs₁)
    (obs₁' : (Ext → Nat) → Obs₁')
    (obs₂ : (Ext → Nat) → Obs₂)
    (channel : Bool → Nat → Env → Bool)
    (G : Ext → (Ext → Nat) → Nat)
    (envDraw : Env → Ext → Nat) (envCap : Ext → Nat) (jointAdm : Env → Prop)
    (env_within : ∀ env, jointAdm env → ∀ k, envDraw env k ≤ envCap k)
    (x_crit warnLevel H_safe x₀ : Ext → Nat)
    (refines : ContractRefines cA cA' obs₁ obs₁' warnLevel)
    (obs_detects_orig : ∀ x k, x k < warnLevel k → cA.warnObs (obs₁ x) ∨ cB.warnObs (obs₂ x))
    (channel_fires : ∀ load env, jointAdm env → load ≤ cA.maxSilence + cB.maxSilence →
      channel true load env = true)
    (G_rises : ∀ k, RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (G k))
    (post_viable : ∀ k, x_crit k ≤
      RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole G H_safe x_crit k)
    (post_budget : ∀ k, (cA.postBudgetExt k + cB.postBudgetExt k) + envCap k ≤ H_safe k)
    (warn_margin : ∀ k, x_crit k +
      (CoreHelpers.natMax cA.maxLag cB.maxLag + 1) *
        ((cA.preCapExt k + cB.preCapExt k) + envCap k) ≤ warnLevel k)
    (init_margin : ∀ k, x_crit k +
      CoreHelpers.natMax (cA.eta init₁) (cB.eta init₂) *
        ((cA.preCapExt k + cB.preCapExt k) + envCap k) ≤ x₀ k) :
    Viability.Kernel
      (closedProcess (OpenComponent.compose A' B) (composeContract cA' cB)
        (fun x => (obs₁' x, obs₂ x)) channel G envDraw jointAdm)
      (closedGuard (OpenComponent.compose A' B) (composeContract cA' cB) x_crit)
      (x₀, (init₁', init₂)) :=
  replace_contract_viable
    (OpenComponent.compose A B) (OpenComponent.compose A' B)
    (composeContract cA cB) (composeContract cA' cB)
    (fun x => (obs₁ x, obs₂ x)) (fun x => (obs₁' x, obs₂ x))
    channel G envDraw envCap jointAdm env_within x_crit warnLevel H_safe x₀
    (contractRefines_compose_left cB obs₂ refines)
    obs_detects_orig channel_fires G_rises post_viable post_budget warn_margin init_margin

/-! ### Algebraic Transport, Right Replacement, Boundary Hiding & Right-Associated List Composition -/

/-- Constructive commutativity equivalence `A ⊕ B ≃ B ⊕ A` (`0` axioms). -/
def composeCommEquiv
    {S₁ S₂ Obs₁ Obs₂ Dist₁ Dist₂ Int₁ Int₂ Ext : Type}
    (A : OpenComponent S₁ Obs₁ Dist₁ Int₁ Ext)
    (B : OpenComponent S₂ Obs₂ Dist₂ Int₂ Ext) :
    ComponentEquiv (OpenComponent.compose A B) (OpenComponent.compose B A) where
  toS p := (p.2, p.1)
  invS p := (p.2, p.1)
  leftS _ := rfl
  rightS _ := rfl
  toObs o := (o.2, o.1)
  invObs o := (o.2, o.1)
  leftObs _ := rfl
  rightObs _ := rfl
  toDist d := (d.2, d.1)
  invDist d := (d.2, d.1)
  leftDist _ := rfl
  rightDist _ := rfl
  toInt
    | .inl j₁ => .inr j₁
    | .inr j₂ => .inl j₂
  invInt
    | .inl j₂ => .inr j₂
    | .inr j₁ => .inl j₁
  leftInt
    | .inl _ => rfl
    | .inr _ => rfl
  rightInt
    | .inl _ => rfl
    | .inr _ => rfl
  comm_next _ _ _ _ := rfl
  comm_drawInt _
    | .inl _ => rfl
    | .inr _ => rfl
  comm_drawExt s k := Nat.add_comm (A.drawExt s.1 k) (B.drawExt s.2 k)
  comm_emitAlarm s oa := by
    show (A.emitAlarm s.1 oa.1 || B.emitAlarm s.2 oa.2) =
      (B.emitAlarm s.2 oa.2 || A.emitAlarm s.1 oa.1)
    cases A.emitAlarm s.1 oa.1 <;> cases B.emitAlarm s.2 oa.2 <;> rfl
  comm_silenceLoad s := Nat.add_comm (A.silenceLoad s.1) (B.silenceLoad s.2)
  comm_favours _ :=
    ⟨fun h => match h with
       | .inl a => .inr a
       | .inr b => .inl b,
     fun h => match h with
       | .inl b => .inr b
       | .inr a => .inl a⟩

/-- Constructive contract compatibility across a `ComponentEquiv` (`0` `propext`). -/
structure ContractEquiv
    {S₁ S₂ Obs₁ Obs₂ Dist₁ Dist₂ Int₁ Int₂ Ext : Type}
    {A : OpenComponent S₁ Obs₁ Dist₁ Int₁ Ext}
    {B : OpenComponent S₂ Obs₂ Dist₂ Int₂ Ext}
    {init₁ : S₁} {init₂ : S₂}
    (E : ComponentEquiv A B)
    (cA : InterfaceContract A init₁)
    (cB : InterfaceContract B init₂) : Prop where
  init_eq : E.toS init₁ = init₂
  tol_to : ∀ o al d, cA.tol (o, al) d → cB.tol (E.toObs o, al) (E.toDist d)
  tol_inv : ∀ o al d, cB.tol (o, al) d → cA.tol (E.invObs o, al) (E.invDist d)
  warn_to : ∀ o, cA.warnObs o → cB.warnObs (E.toObs o)
  warn_inv : ∀ o, cB.warnObs o → cA.warnObs (E.invObs o)
  preCapInt_eq : ∀ j, cA.preCapInt j = cB.preCapInt (E.toInt j)
  preCapExt_eq : ∀ k, cA.preCapExt k = cB.preCapExt k
  postCapInt_eq : ∀ j, cA.postBudgetInt j = cB.postBudgetInt (E.toInt j)
  postCapExt_eq : ∀ k, cA.postBudgetExt k = cB.postBudgetExt k
  maxSilence_eq : cA.maxSilence = cB.maxSilence
  maxLag_eq : cA.maxLag = cB.maxLag
  K_to : ∀ s, cA.K s → cB.K (E.toS s)
  K_inv : ∀ s, cB.K s → cA.K (E.invS s)
  eta_eq : ∀ s, cA.eta s = cB.eta (E.toS s)

/-- Associativity of `composeContract` along `composeAssocEquiv`. -/
theorem composeAssocContractEquiv
    {S₁ S₂ S₃ Obs₁ Obs₂ Obs₃ Dist₁ Dist₂ Dist₃ Int₁ Int₂ Int₃ Ext : Type}
    {A : OpenComponent S₁ Obs₁ Dist₁ Int₁ Ext}
    {B : OpenComponent S₂ Obs₂ Dist₂ Int₂ Ext}
    {C : OpenComponent S₃ Obs₃ Dist₃ Int₃ Ext}
    {init₁ : S₁} {init₂ : S₂} {init₃ : S₃}
    (cA : InterfaceContract A init₁)
    (cB : InterfaceContract B init₂)
    (cC : InterfaceContract C init₃) :
    ContractEquiv
      (composeAssocEquiv A B C)
      (composeContract (composeContract cA cB) cC)
      (composeContract cA (composeContract cB cC)) where
  init_eq := rfl
  tol_to _ _ _ h := ⟨h.1.1, ⟨h.1.2, h.2⟩⟩
  tol_inv _ _ _ h := ⟨⟨h.1, h.2.1⟩, h.2.2⟩
  warn_to _
    | .inl (.inl w₁) => .inl w₁
    | .inl (.inr w₂) => .inr (.inl w₂)
    | .inr w₃ => .inr (.inr w₃)
  warn_inv _
    | .inl w₁ => .inl (.inl w₁)
    | .inr (.inl w₂) => .inl (.inr w₂)
    | .inr (.inr w₃) => .inr w₃
  preCapInt_eq
    | .inl (.inl _) => rfl
    | .inl (.inr _) => rfl
    | .inr _ => rfl
  preCapExt_eq k := Nat.add_assoc (cA.preCapExt k) (cB.preCapExt k) (cC.preCapExt k)
  postCapInt_eq
    | .inl (.inl _) => rfl
    | .inl (.inr _) => rfl
    | .inr _ => rfl
  postCapExt_eq k := Nat.add_assoc (cA.postBudgetExt k) (cB.postBudgetExt k) (cC.postBudgetExt k)
  maxSilence_eq := Nat.add_assoc cA.maxSilence cB.maxSilence cC.maxSilence
  maxLag_eq := CoreHelpers.natMax_assoc cA.maxLag cB.maxLag cC.maxLag
  K_to _ h := ⟨h.1.1, ⟨h.1.2, h.2⟩⟩
  K_inv _ h := ⟨⟨h.1, h.2.1⟩, h.2.2⟩
  eta_eq s := CoreHelpers.natMax_assoc (cA.eta s.1.1) (cB.eta s.1.2) (cC.eta s.2)

/-- Commutativity of `composeContract` along `composeCommEquiv`. -/
theorem composeCommContractEquiv
    {S₁ S₂ Obs₁ Obs₂ Dist₁ Dist₂ Int₁ Int₂ Ext : Type}
    {A : OpenComponent S₁ Obs₁ Dist₁ Int₁ Ext}
    {B : OpenComponent S₂ Obs₂ Dist₂ Int₂ Ext}
    {init₁ : S₁} {init₂ : S₂}
    (cA : InterfaceContract A init₁)
    (cB : InterfaceContract B init₂) :
    ContractEquiv
      (composeCommEquiv A B)
      (composeContract cA cB)
      (composeContract cB cA) where
  init_eq := rfl
  tol_to _ _ _ h := ⟨h.2, h.1⟩
  tol_inv _ _ _ h := ⟨h.2, h.1⟩
  warn_to _
    | .inl w₁ => .inr w₁
    | .inr w₂ => .inl w₂
  warn_inv _
    | .inl w₂ => .inr w₂
    | .inr w₁ => .inl w₁
  preCapInt_eq
    | .inl _ => rfl
    | .inr _ => rfl
  preCapExt_eq k := Nat.add_comm (cA.preCapExt k) (cB.preCapExt k)
  postCapInt_eq
    | .inl _ => rfl
    | .inr _ => rfl
  postCapExt_eq k := Nat.add_comm (cA.postBudgetExt k) (cB.postBudgetExt k)
  maxSilence_eq := Nat.add_comm cA.maxSilence cB.maxSilence
  maxLag_eq := CoreHelpers.natMax_comm cA.maxLag cB.maxLag
  K_to _ h := ⟨h.2, h.1⟩
  K_inv _ h := ⟨h.2, h.1⟩
  eta_eq s := CoreHelpers.natMax_comm (cA.eta s.1) (cB.eta s.2)

/-- Right-component heterogeneous replacement (`A ⊕_K B ↝ A ⊕_K B'`). -/
theorem replace_right_viable
    {S₁ S₂ S₂' Obs₁ Obs₂ Obs₂' Dist₁ Dist₂ Dist₂' Int₁ Int₂ Int₂' Ext Env : Type}
    (A : OpenComponent S₁ Obs₁ Dist₁ Int₁ Ext)
    (B : OpenComponent S₂ Obs₂ Dist₂ Int₂ Ext)
    (B' : OpenComponent S₂' Obs₂' Dist₂' Int₂' Ext)
    {init₁ : S₁} {init₂ : S₂} {init₂' : S₂'}
    (cA : InterfaceContract A init₁)
    (cB : InterfaceContract B init₂)
    (cB' : InterfaceContract B' init₂')
    (obs₁ : (Ext → Nat) → Obs₁)
    (obs₂ : (Ext → Nat) → Obs₂)
    (obs₂' : (Ext → Nat) → Obs₂')
    (channel : Bool → Nat → Env → Bool)
    (G : Ext → (Ext → Nat) → Nat)
    (envDraw : Env → Ext → Nat) (envCap : Ext → Nat) (jointAdm : Env → Prop)
    (env_within : ∀ env, jointAdm env → ∀ k, envDraw env k ≤ envCap k)
    (x_crit warnLevel H_safe x₀ : Ext → Nat)
    (refines : ContractRefines cB cB' obs₂ obs₂' warnLevel)
    (obs_detects_orig : ∀ x k, x k < warnLevel k → cA.warnObs (obs₁ x) ∨ cB.warnObs (obs₂ x))
    (channel_fires : ∀ load env, jointAdm env → load ≤ cA.maxSilence + cB.maxSilence →
      channel true load env = true)
    (G_rises : ∀ k, RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (G k))
    (post_viable : ∀ k, x_crit k ≤
      RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole G H_safe x_crit k)
    (post_cap : ∀ k, (cA.postBudgetExt k + cB.postBudgetExt k) + envCap k ≤ H_safe k)
    (warn_margin : ∀ k, x_crit k +
      (CoreHelpers.natMax cA.maxLag cB.maxLag + 1) *
        ((cA.preCapExt k + cB.preCapExt k) + envCap k) ≤ warnLevel k)
    (init_margin : ∀ k, x_crit k +
      CoreHelpers.natMax (cA.eta init₁) (cB.eta init₂) *
        ((cA.preCapExt k + cB.preCapExt k) + envCap k) ≤ x₀ k) :
    Viability.Kernel
      (closedProcess (OpenComponent.compose A B') (composeContract cA cB')
        (fun x => (obs₁ x, obs₂' x)) channel G envDraw jointAdm)
      (closedGuard (OpenComponent.compose A B') (composeContract cA cB') x_crit)
      (x₀, (init₁, init₂')) :=
  replace_contract_viable
    (OpenComponent.compose A B) (OpenComponent.compose A B')
    (composeContract cA cB) (composeContract cA cB')
    (fun x => (obs₁ x, obs₂ x)) (fun x => (obs₁ x, obs₂' x))
    channel G envDraw envCap jointAdm env_within x_crit warnLevel H_safe x₀
    (contractRefines_compose_right cA obs₁ refines)
    obs_detects_orig channel_fires G_rises post_viable post_cap warn_margin init_margin

/-- Augment any `(C, c)` on `Ext := Unit` with an exposed coupled site `.inr ()` whose draw switches
from `preHide` (`0 < c.eta s`) to `postHide` (`c.eta s = 0`) cleanly inside `c`'s contract. -/
def withHiddenSite {S Obs Dist Int : Type}
    (C : OpenComponent S Obs Dist Int Unit)
    {init : S} (c : InterfaceContract C init)
    (preHide postHide : Nat) :
    OpenComponent S Obs Dist Int (Sum Unit Unit) where
  next := C.next
  drawInt := C.drawInt
  drawExt s
    | .inl () => C.drawExt s ()
    | .inr () => match c.eta s with
      | 0 => postHide
      | _ + 1 => preHide
  emitAlarm := C.emitAlarm
  silenceLoad := C.silenceLoad
  favours := C.favours

/-- Assume-guarantee `InterfaceContract` for `withHiddenSite` (`0` axioms). -/
def withHiddenSiteContract {S Obs Dist Int : Type}
    {C : OpenComponent S Obs Dist Int Unit}
    {init : S} (c : InterfaceContract C init)
    (preHide postHide : Nat) (hPost : postHide ≤ preHide) :
    InterfaceContract (withHiddenSite C c preHide postHide) init where
  tol := c.tol
  warnObs := c.warnObs
  preCapInt := c.preCapInt
  preCapExt
    | .inl () => c.preCapExt ()
    | .inr () => preHide
  postBudgetInt := c.postBudgetInt
  postBudgetExt
    | .inl () => c.postBudgetExt ()
    | .inr () => postHide
  maxSilence := c.maxSilence
  maxLag := c.maxLag
  K := c.K
  eta := c.eta
  init_in := c.init_in
  cert := Viability.certificate_disturbed_iff.mpr
    ⟨fun s hs =>
      let w := c.cert.within s hs
      ⟨w.1,
       fun k => match k with
         | .inl () => w.2.1 ()
         | .inr () => by
           show (match c.eta s with | 0 => postHide | _ + 1 => preHide) ≤ preHide
           cases c.eta s with
           | zero => exact hPost
           | succ _ => exact Nat.le_refl preHide,
       w.2.2.1,
       fun h0 =>
         let p := w.2.2.2 h0
         ⟨p.1, p.2.1,
          fun k => match k with
            | .inl () => p.2.2 ()
            | .inr () => by
              show (match c.eta s with | 0 => postHide | _ + 1 => preHide) ≤ postHide
              rw [h0]
              exact Nat.le_refl postHide⟩⟩,
     fun s m adm hs => c.cert.closed s m _ ⟨adm, rfl⟩ hs⟩
  eta_bound := c.eta_bound
  emits_on_warn := c.emits_on_warn
  eta_alarm_step := c.eta_alarm_step
  eta_alarm_zero := c.eta_alarm_zero

/-- Indexed carrier for right-associated list composition over uniform agent types. -/
def ListCarrier {α : Type} (T : Type) : List α → Type
  | [] => T
  | _ :: rest => T × ListCarrier T rest

/-- Indexed private-port carrier for right-associated list composition over uniform `Int`. -/
def ListIntCarrier {α : Type} (I : Type) : List α → Type
  | [] => I
  | _ :: rest => Sum I (ListIntCarrier I rest)

/-- Right-associated initial state tuple over a non-empty agent list `head :: tail`. -/
def composeListInit {α S : Type} (init : α → S) (head : α) :
    (tail : List α) → ListCarrier S tail
  | [] => init head
  | next :: rest => (init head, composeListInit init next rest)

/-- Right-associated broadcast observation map over `tail`. -/
def composeListObs {α Obs Ext : Type} (obsFn : (Ext → Nat) → Obs) :
    (tail : List α) → (Ext → Nat) → ListCarrier Obs tail
  | [], x => obsFn x
  | _ :: rest, x => (obsFn x, composeListObs obsFn rest x)

/-- Right-associated `OpenComponent` fold over a non-empty agent list `head :: tail`. -/
def composeListComponent {α S Obs Dist Int Ext : Type}
    (comp : α → OpenComponent S Obs Dist Int Ext) (head : α) :
    (tail : List α) →
    OpenComponent (ListCarrier S tail) (ListCarrier Obs tail) (ListCarrier Dist tail)
      (ListIntCarrier Int tail) Ext
  | [] => comp head
  | next :: rest => OpenComponent.compose (comp head) (composeListComponent comp next rest)

/-- Right-associated `InterfaceContract` fold over a non-empty agent list `head :: tail`. -/
def composeListContract {α S Obs Dist Int Ext : Type}
    {comp : α → OpenComponent S Obs Dist Int Ext} {init : α → S}
    (contract : (i : α) → InterfaceContract (comp i) (init i)) (head : α) :
    (tail : List α) →
    InterfaceContract (composeListComponent comp head tail) (composeListInit init head tail)
  | [] => contract head
  | next :: rest => composeContract (contract head) (composeListContract contract next rest)

/-- Recursive sum of a scalar projection over a non-empty list `head :: tail`. -/
def listSum {α : Type} (proj : α → Nat) (head : α) : List α → Nat
  | [] => proj head
  | next :: rest => proj head + listSum proj next rest

/-- Recursive maximum of a scalar projection over a non-empty list `head :: tail`. -/
def listMax {α : Type} (proj : α → Nat) (head : α) : List α → Nat
  | [] => proj head
  | next :: rest => CoreHelpers.natMax (proj head) (listMax proj next rest)

theorem composeList_preCapExt_eq_sum {α S Obs Dist Int Ext : Type}
    {comp : α → OpenComponent S Obs Dist Int Ext} {init : α → S}
    (contract : (i : α) → InterfaceContract (comp i) (init i))
    (k : Ext) :
    ∀ (tail : List α) (head : α),
      (composeListContract contract head tail).preCapExt k =
        listSum (fun i => (contract i).preCapExt k) head tail
  | [], _ => rfl
  | next :: rest, head => by
    show (contract head).preCapExt k + (composeListContract contract next rest).preCapExt k =
      (contract head).preCapExt k + listSum (fun i => (contract i).preCapExt k) next rest
    rw [composeList_preCapExt_eq_sum contract k rest next]

theorem composeList_postBudgetExt_eq_sum {α S Obs Dist Int Ext : Type}
    {comp : α → OpenComponent S Obs Dist Int Ext} {init : α → S}
    (contract : (i : α) → InterfaceContract (comp i) (init i))
    (k : Ext) :
    ∀ (tail : List α) (head : α),
      (composeListContract contract head tail).postBudgetExt k =
        listSum (fun i => (contract i).postBudgetExt k) head tail
  | [], _ => rfl
  | next :: rest, head => by
    show (contract head).postBudgetExt k + (composeListContract contract next rest).postBudgetExt k =
      (contract head).postBudgetExt k + listSum (fun i => (contract i).postBudgetExt k) next rest
    rw [composeList_postBudgetExt_eq_sum contract k rest next]

theorem composeList_maxSilence_eq_sum {α S Obs Dist Int Ext : Type}
    {comp : α → OpenComponent S Obs Dist Int Ext} {init : α → S}
    (contract : (i : α) → InterfaceContract (comp i) (init i)) :
    ∀ (tail : List α) (head : α),
      (composeListContract contract head tail).maxSilence =
        listSum (fun i => (contract i).maxSilence) head tail
  | [], _ => rfl
  | next :: rest, head => by
    show (contract head).maxSilence + (composeListContract contract next rest).maxSilence =
      (contract head).maxSilence + listSum (fun i => (contract i).maxSilence) next rest
    rw [composeList_maxSilence_eq_sum contract rest next]

theorem composeList_maxLag_eq_max {α S Obs Dist Int Ext : Type}
    {comp : α → OpenComponent S Obs Dist Int Ext} {init : α → S}
    (contract : (i : α) → InterfaceContract (comp i) (init i)) :
    ∀ (tail : List α) (head : α),
      (composeListContract contract head tail).maxLag =
        listMax (fun i => (contract i).maxLag) head tail
  | [], _ => rfl
  | next :: rest, head => by
    show CoreHelpers.natMax (contract head).maxLag (composeListContract contract next rest).maxLag =
      CoreHelpers.natMax (contract head).maxLag (listMax (fun i => (contract i).maxLag) next rest)
    rw [composeList_maxLag_eq_max contract rest next]

theorem composeList_eta_eq_max {α S Obs Dist Int Ext : Type}
    {comp : α → OpenComponent S Obs Dist Int Ext} {init : α → S}
    (contract : (i : α) → InterfaceContract (comp i) (init i)) :
    ∀ (tail : List α) (head : α),
      (composeListContract contract head tail).eta (composeListInit init head tail) =
        listMax (fun i => (contract i).eta (init i)) head tail
  | [], _ => rfl
  | next :: rest, head => by
    show CoreHelpers.natMax ((contract head).eta (init head))
        ((composeListContract contract next rest).eta (composeListInit init next rest)) =
      CoreHelpers.natMax ((contract head).eta (init head))
        (listMax (fun i => (contract i).eta (init i)) next rest)
    rw [composeList_eta_eq_max contract rest next]

theorem composeList_warnObs_of_head {α S Obs Dist Int Ext : Type}
    {comp : α → OpenComponent S Obs Dist Int Ext} {init : α → S}
    (contract : (i : α) → InterfaceContract (comp i) (init i))
    {obsFn : (Ext → Nat) → Obs} {x : Ext → Nat} {head : α} :
    ∀ (tail : List α), (contract head).warnObs (obsFn x) →
      (composeListContract contract head tail).warnObs (composeListObs obsFn tail x)
  | [], hw => hw
  | _ :: _, hw => Or.inl hw

/-- Generic closed-loop viability for right-associated list composition over `head :: tail`. -/
theorem composeList_viable {α S Obs Dist Int Ext Env : Type}
    (comp : α → OpenComponent S Obs Dist Int Ext) (init : α → S)
    (contract : (i : α) → InterfaceContract (comp i) (init i))
    (head : α) (tail : List α)
    (obsFn : (Ext → Nat) → Obs)
    (channel : Bool → Nat → Env → Bool)
    (G : Ext → (Ext → Nat) → Nat)
    (envDraw : Env → Ext → Nat) (envCap : Ext → Nat) (jointAdm : Env → Prop)
    (env_within : ∀ env, jointAdm env → ∀ k, envDraw env k ≤ envCap k)
    (x_crit warnLevel H_safe x₀ : Ext → Nat)
    (obs_detects : ∀ x k, x k < warnLevel k → (contract head).warnObs (obsFn x))
    (channel_fires : ∀ load env, jointAdm env →
      load ≤ listSum (fun i => (contract i).maxSilence) head tail →
      channel true load env = true)
    (G_rises : ∀ k, RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (G k))
    (post_viable : ∀ k, x_crit k ≤
      RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole G H_safe x_crit k)
    (post_cap : ∀ k,
      listSum (fun i => (contract i).postBudgetExt k) head tail + envCap k ≤ H_safe k)
    (warn_margin : ∀ k, x_crit k +
      (listMax (fun i => (contract i).maxLag) head tail + 1) *
        (listSum (fun i => (contract i).preCapExt k) head tail + envCap k) ≤ warnLevel k)
    (init_margin : ∀ k, x_crit k +
      listMax (fun i => (contract i).eta (init i)) head tail *
        (listSum (fun i => (contract i).preCapExt k) head tail + envCap k) ≤ x₀ k) :
    Viability.Kernel
      (closedProcess (composeListComponent comp head tail) (composeListContract contract head tail)
        (composeListObs obsFn tail) channel G envDraw jointAdm)
      (closedGuard (composeListComponent comp head tail) (composeListContract contract head tail) x_crit)
      (x₀, composeListInit init head tail) :=
  close_contract_kernel
    (composeListComponent comp head tail) (composeListContract contract head tail)
    (composeListObs obsFn tail) channel G envDraw envCap jointAdm env_within
    x_crit warnLevel H_safe x₀
    (fun x k lt => composeList_warnObs_of_head contract tail (obs_detects x k lt))
    (fun load env adm hLoad =>
      channel_fires load env adm (composeList_maxSilence_eq_sum contract tail head ▸ hLoad))
    G_rises post_viable
    (fun k => composeList_postBudgetExt_eq_sum contract k tail head ▸ post_cap k)
    (fun k =>
      (composeList_maxLag_eq_max contract tail head).symm ▸
        ((composeList_preCapExt_eq_sum contract k tail head).symm ▸ warn_margin k))
    (fun k =>
      (composeList_eta_eq_max contract tail head).symm ▸
        ((composeList_preCapExt_eq_sum contract k tail head).symm ▸ init_margin k))

/-- Heterogeneous head-agent upgrade across `composeListComponent` via `ContractRefines`. -/
theorem composeList_replace_head_viable {α S Obs Dist Int Ext Env : Type}
    (comp : α → OpenComponent S Obs Dist Int Ext) (init : α → S)
    (contract : (i : α) → InterfaceContract (comp i) (init i))
    (head head' : α) (tail : List α)
    (obsFn : (Ext → Nat) → Obs)
    (channel : Bool → Nat → Env → Bool)
    (G : Ext → (Ext → Nat) → Nat)
    (envDraw : Env → Ext → Nat) (envCap : Ext → Nat) (jointAdm : Env → Prop)
    (env_within : ∀ env, jointAdm env → ∀ k, envDraw env k ≤ envCap k)
    (x_crit warnLevel H_safe x₀ : Ext → Nat)
    (refines : ContractRefines (contract head) (contract head') obsFn obsFn warnLevel)
    (obs_detects : ∀ x k, x k < warnLevel k → (contract head).warnObs (obsFn x))
    (channel_fires : ∀ load env, jointAdm env →
      load ≤ listSum (fun i => (contract i).maxSilence) head tail →
      channel true load env = true)
    (G_rises : ∀ k, RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (G k))
    (post_viable : ∀ k, x_crit k ≤
      RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole G H_safe x_crit k)
    (post_cap : ∀ k,
      listSum (fun i => (contract i).postBudgetExt k) head tail + envCap k ≤ H_safe k)
    (warn_margin : ∀ k, x_crit k +
      (listMax (fun i => (contract i).maxLag) head tail + 1) *
        (listSum (fun i => (contract i).preCapExt k) head tail + envCap k) ≤ warnLevel k)
    (init_margin : ∀ k, x_crit k +
      listMax (fun i => (contract i).eta (init i)) head tail *
        (listSum (fun i => (contract i).preCapExt k) head tail + envCap k) ≤ x₀ k) :
    Viability.Kernel
      (closedProcess (composeListComponent comp head' tail) (composeListContract contract head' tail)
        (composeListObs obsFn tail) channel G envDraw jointAdm)
      (closedGuard (composeListComponent comp head' tail) (composeListContract contract head' tail) x_crit)
      (x₀, composeListInit init head' tail) := by
  cases tail with
  | nil =>
    exact replace_contract_viable (comp head) (comp head') (contract head) (contract head')
      obsFn obsFn channel G envDraw envCap jointAdm env_within x_crit warnLevel H_safe x₀
      refines obs_detects channel_fires G_rises post_viable post_cap warn_margin init_margin
  | cons next rest =>
    exact replace_left_viable
      (comp head) (comp head') (composeListComponent comp next rest)
      (contract head) (contract head') (composeListContract contract next rest)
      obsFn obsFn (composeListObs obsFn rest) channel G envDraw envCap jointAdm env_within
      x_crit warnLevel H_safe x₀ refines
      (fun x k lt => Or.inl (obs_detects x k lt))
      (fun load env adm hLoad => by
        show channel true load env = true
        exact channel_fires load env adm (by
          change load ≤ (composeListContract contract head (next :: rest)).maxSilence at hLoad
          rwa [← composeList_maxSilence_eq_sum contract (next :: rest) head]))
      G_rises post_viable
      (fun k => by
        change (composeListContract contract head (next :: rest)).postBudgetExt k + envCap k ≤ H_safe k
        rw [composeList_postBudgetExt_eq_sum contract k (next :: rest) head]
        exact post_cap k)
      (fun k => by
        change x_crit k +
          ((composeListContract contract head (next :: rest)).maxLag + 1) *
            ((composeListContract contract head (next :: rest)).preCapExt k + envCap k) ≤ warnLevel k
        rw [composeList_maxLag_eq_max contract (next :: rest) head,
            composeList_preCapExt_eq_sum contract k (next :: rest) head]
        exact warn_margin k)
      (fun k => by
        change x_crit k +
          (composeListContract contract head (next :: rest)).eta
              (composeListInit init head (next :: rest)) *
            ((composeListContract contract head (next :: rest)).preCapExt k + envCap k) ≤ x₀ k
        rw [composeList_eta_eq_max contract (next :: rest) head,
            composeList_preCapExt_eq_sum contract k (next :: rest) head]
        exact init_margin k)

/-- **Dynamic mid-run structural rewrite process (`ReconfigProcess`)**: runs `A` on the left until
an arbitrary live reconfiguration event `reconfig s₁'` swaps `A` out for heterogeneous `A'` while
preserving substrate `x` verbatim. -/
inductive ReconfigAct (Env Dist₁ Dist₁' S₁' : Type) where
  | stepLeft : Env → Dist₁ → ReconfigAct Env Dist₁ Dist₁' S₁'
  | stepRight : Env → Dist₁' → ReconfigAct Env Dist₁ Dist₁' S₁'
  | reconfig : S₁' → ReconfigAct Env Dist₁ Dist₁' S₁'

def ReconfigProcess
    {S₁ S₁' Obs₁ Obs₁' Dist₁ Dist₁' Int₁ Int₁' Ext Env : Type}
    (A : OpenComponent S₁ Obs₁ Dist₁ Int₁ Ext)
    (A' : OpenComponent S₁' Obs₁' Dist₁' Int₁' Ext)
    {init₁ : S₁} {init₁' : S₁'}
    (cA : InterfaceContract A init₁)
    (cA' : InterfaceContract A' init₁')
    (obs₁ : (Ext → Nat) → Obs₁)
    (obs₁' : (Ext → Nat) → Obs₁')
    (channel : Bool → Nat → Env → Bool)
    (G : Ext → (Ext → Nat) → Nat)
    (envDraw : Env → Ext → Nat)
    (jointAdm : Env → Prop) :
    Process (Sum ((Ext → Nat) × S₁) ((Ext → Nat) × S₁'))
      (ReconfigAct Env Dist₁ Dist₁' S₁') where
  step st act st' := match st with
    | .inl st₁ => match act with
      | .stepLeft env d =>
        jointAdm env ∧ (∀ ob, cA.tol ob d) ∧
        st' = .inl (closedStep A obs₁ channel G envDraw st₁ (env, d))
      | .stepRight _ _ => False
      | .reconfig s' =>
        cA'.K s' ∧ cA'.eta s' ≤ cA.eta st₁.2 ∧ st' = .inr (st₁.1, s')
    | .inr st₂ => match act with
      | .stepLeft _ _ => False
      | .stepRight env d' =>
        jointAdm env ∧ (∀ ob, cA'.tol ob d') ∧
        st' = .inr (closedStep A' obs₁' channel G envDraw st₂ (env, d'))
      | .reconfig _ => False

/-- **Live mid-run rewrite safety (`rewrite_step_viable`)**: across arbitrarily timed structural
rewrites `A ↝ A'` with `S₁ ≠ S₁'` and `Int₁ ≠ Int₁'`, `ReconfigProcess` preserves global substrate
viability `x_crit ≤ x` and both phase contracts forever. -/
theorem rewrite_step_viable
    {S₁ S₁' Obs₁ Obs₁' Dist₁ Dist₁' Int₁ Int₁' Ext Env : Type}
    (A : OpenComponent S₁ Obs₁ Dist₁ Int₁ Ext)
    (A' : OpenComponent S₁' Obs₁' Dist₁' Int₁' Ext)
    {init₁ : S₁} {init₁' : S₁'}
    (cA : InterfaceContract A init₁)
    (cA' : InterfaceContract A' init₁')
    (obs₁ : (Ext → Nat) → Obs₁)
    (obs₁' : (Ext → Nat) → Obs₁')
    (channel : Bool → Nat → Env → Bool)
    (G : Ext → (Ext → Nat) → Nat)
    (envDraw : Env → Ext → Nat) (envCap : Ext → Nat) (jointAdm : Env → Prop)
    (env_within : ∀ env, jointAdm env → ∀ k, envDraw env k ≤ envCap k)
    (x_crit warnLevel H_safe x₀ : Ext → Nat)
    (cap_le : ∀ k, cA'.preCapExt k ≤ cA.preCapExt k)
    (post_le : ∀ k, cA'.postBudgetExt k ≤ cA.postBudgetExt k)
    (sil_le : cA'.maxSilence ≤ cA.maxSilence)
    (lag_le : cA'.maxLag ≤ cA.maxLag)
    (obs_detects₁ : ∀ x k, x k < warnLevel k → cA.warnObs (obs₁ x))
    (obs_detects₂ : ∀ x k, x k < warnLevel k → cA'.warnObs (obs₁' x))
    (channel_fires : ∀ load env, jointAdm env → load ≤ cA.maxSilence →
      channel true load env = true)
    (G_rises : ∀ k, RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (G k))
    (post_viable : ∀ k, x_crit k ≤
      RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole G H_safe x_crit k)
    (post_budget : ∀ k, cA.postBudgetExt k + envCap k ≤ H_safe k)
    (warn_margin : ∀ k, x_crit k + (cA.maxLag + 1) * (cA.preCapExt k + envCap k) ≤ warnLevel k)
    (init_margin : ∀ k, x_crit k + cA.eta init₁ * (cA.preCapExt k + envCap k) ≤ x₀ k) :
    Viability.Kernel
      (ReconfigProcess A A' cA cA' obs₁ obs₁' channel G envDraw jointAdm)
      (fun st => match st with
        | .inl st₁ => closedGuard A cA x_crit st₁
        | .inr st₂ => closedGuard A' cA' x_crit st₂)
      (.inl (x₀, init₁)) := by
  let Inv : Sum ((Ext → Nat) × S₁) ((Ext → Nat) × S₁') → Prop
    | .inl st₁ => closedInv cA envCap x_crit st₁
    | .inr st₂ => closedInv cA' envCap x_crit st₂
  have v₁ := close_contract_viable A cA obs₁ channel G envDraw envCap jointAdm env_within
    x_crit warnLevel H_safe x₀ obs_detects₁ channel_fires G_rises post_viable post_budget
    warn_margin init_margin
  have cert₂ := (close_contract_viable A' cA' obs₁' channel G envDraw envCap jointAdm env_within
    x_crit warnLevel H_safe
    (fun k => x_crit k + cA'.eta init₁' * (cA'.preCapExt k + envCap k))
    obs_detects₂
    (fun load env adm le => channel_fires load env adm (Nat.le_trans le sil_le))
    G_rises post_viable
    (fun k => Nat.le_trans (Nat.add_le_add_right (post_le k) _) (post_budget k))
    (fun k => Nat.le_trans
      (Nat.add_le_add_left (Nat.mul_le_mul (Nat.succ_le_succ lag_le)
        (Nat.add_le_add_right (cap_le k) _)) _)
      (warn_margin k))
    (fun _ => Nat.le_refl _)).2
  have fullCert : Viability.Certificate
      (ReconfigProcess A A' cA cA' obs₁ obs₁' channel G envDraw jointAdm)
      (fun st => match st with
        | .inl st₁ => closedGuard A cA x_crit st₁
        | .inr st₂ => closedGuard A' cA' x_crit st₂)
      Inv := by
    refine ⟨?_, ?_⟩
    · intro st hInv
      cases st with
      | inl st₁ => exact v₁.2.within st₁ hInv
      | inr st₂ => exact cert₂.within st₂ hInv
    · intro st act st' hstep hInv
      cases st with
      | inl st₁ =>
        cases act with
        | stepLeft env d =>
          obtain ⟨envOk, tolOk, hEq⟩ := hstep
          subst hEq
          exact v₁.2.closed st₁ (env, d) _ ⟨⟨envOk, tolOk⟩, rfl⟩ hInv
        | stepRight _ _ => exact False.elim hstep
        | reconfig s' =>
          obtain ⟨hK', hEta', hEq⟩ := hstep
          subst hEq
          refine ⟨hK', fun k => ?_⟩
          have etaMul : cA'.eta s' * (cA'.preCapExt k + envCap k) ≤
              cA.eta st₁.2 * (cA.preCapExt k + envCap k) :=
            Nat.mul_le_mul hEta' (Nat.add_le_add_right (cap_le k) _)
          exact Nat.le_trans (Nat.add_le_add_left etaMul (x_crit k)) (hInv.2 k)
      | inr st₂ =>
        cases act with
        | stepLeft _ _ => exact False.elim hstep
        | stepRight env d' =>
          obtain ⟨envOk, tolOk, hEq⟩ := hstep
          subst hEq
          exact cert₂.closed st₂ (env, d') _ ⟨⟨envOk, tolOk⟩, rfl⟩ hInv
        | reconfig _ => exact False.elim hstep
  exact fullCert.kernel v₁.1

/-! ### Interface-Widening Escapes Blindness (`widen_interface_heals_blindness`) -/

namespace WideningWitness

def gShared (_ : Unit) (e : Unit → Nat) : Nat := if 3 ≤ e () then 1 else 0

theorem gShared_rises :
    ∀ k : Unit, RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (gShared k) :=
  fun _ e _ below =>
    match Nat.decLe 3 (e ()) with
    | isTrue h => Nat.le_trans (Nat.le_of_eq (if_pos h))
        (Nat.le_of_eq (if_pos (Nat.le_trans h (below ()))).symm)
    | isFalse h => Nat.le_trans (Nat.le_of_eq (if_neg h)) (Nat.zero_le _)

/-- Under narrow interface `Unit` blind to shared substrate `x ()`, ANY pair of adaptive rules
drawing at least `1` unit (`1 + 1 = 2` total) drives `x` from `6` to `0` in 6 steps. -/
theorem narrow_blind_crashes
    (drawRuleA drawRuleB : Nat → Nat)
    (floorA : ∀ r, 1 ≤ drawRuleA r)
    (floorB : ∀ r, 1 ≤ drawRuleB r)
    (nextRuleA nextRuleB : Nat → Unit → Nat) :
    ∀ r₀A r₀B,
      let stepFn : Nat × (Nat × Nat) → Nat × (Nat × Nat) := fun st =>
        (RegimeMargin.step (fun z => gShared () (fun _ => z))
          (drawRuleA st.2.1 + drawRuleB st.2.2) st.1,
         (nextRuleA st.2.1 (), nextRuleB st.2.2 ()))
      (Law.orbit stepFn (6, (r₀A, r₀B)) 6).1 = 0 := by
  intro r₀A r₀B
  let stepFn : Nat × (Nat × Nat) → Nat × (Nat × Nat) := fun st =>
    (RegimeMargin.step (fun z => gShared () (fun _ => z))
      (drawRuleA st.2.1 + drawRuleB st.2.2) st.1,
     (nextRuleA st.2.1 (), nextRuleB st.2.2 ()))
  have leTwo : ∀ t, (Law.orbit stepFn (6, (r₀A, r₀B)) t).1 ≤
      (Law.run (RegimeMargin.step (fun z => gShared () (fun _ => z)) 2) 6).state t := by
    intro t
    induction t with
    | zero => exact Nat.le_refl 6
    | succ t ih =>
      have dGe : 2 ≤ drawRuleA (Law.orbit stepFn (6, (r₀A, r₀B)) t).2.1 +
          drawRuleB (Law.orbit stepFn (6, (r₀A, r₀B)) t).2.2 :=
        Nat.add_le_add (floorA _) (floorB _)
      have subAnti := Naturals.sub_antitone (Law.orbit stepFn (6, (r₀A, r₀B)) t).1 dGe
      have stepMono : RegimeMargin.step (fun z => gShared () (fun _ => z))
          (drawRuleA (Law.orbit stepFn (6, (r₀A, r₀B)) t).2.1 +
            drawRuleB (Law.orbit stepFn (6, (r₀A, r₀B)) t).2.2)
          (Law.orbit stepFn (6, (r₀A, r₀B)) t).1 ≤
          RegimeMargin.step (fun z => gShared () (fun _ => z)) 2
            (Law.orbit stepFn (6, (r₀A, r₀B)) t).1 :=
        Nat.add_le_add subAnti (gShared_rises () _ _ fun _ => subAnti)
      exact Nat.le_trans stepMono (RegimeMargin.step_mono (fun a b hab => gShared_rises () _ _ fun _ => hab) 2 ih)
  have run6zero : (Law.run (RegimeMargin.step (fun z => gShared () (fun _ => z)) 2) 6).state 6 = 0 := rfl
  exact Nat.eq_zero_of_le_zero (Nat.le_trans (leTwo 6) (Nat.le_of_eq run6zero))

/-- Widened component (`Obs = Bool`, exposing substrate drop below `warn = 8`): starts with `rule = true`
(`draw = 1`, `eta = 1`), drops to `rule = false` (`draw = 0` or conservative `0`) on alarm so joint
composed draw drops from `2` to `1 ≤ gShared = 1`! -/
def widenedAgent : OpenComponent Bool Bool Unit Empty Unit where
  next r oa _ := if oa.2 then false else r
  drawInt _ e := Empty.elim e
  drawExt r _ := if r then 1 else 0
  emitAlarm _ obs := obs
  silenceLoad _ := 0
  favours r := r = true

def widenedContract (init : Bool) : InterfaceContract widenedAgent init where
  tol _ _ := True
  warnObs o := o = true
  preCapInt e := Empty.elim e
  preCapExt _ := 1
  postBudgetInt e := Empty.elim e
  postBudgetExt _ := 0
  maxSilence := 0
  maxLag := 1
  K _ := True
  eta r := if r then 1 else 0
  init_in := trivial
  cert := Viability.certificate_disturbed_iff.mpr
    ⟨fun r _ =>
      ⟨fun e => Empty.elim e,
       fun _ => by
         cases r
         · exact Nat.zero_le 1
         · exact Nat.le_refl 1,
       Nat.le_refl 0,
       fun h0 => by
         cases r
         · exact ⟨fun h => Bool.noConfusion h, fun e => Empty.elim e, fun _ => Nat.le_refl 0⟩
         · exact Nat.noConfusion h0⟩,
     fun _ _ _ _ => trivial⟩
  eta_bound r _ := by
    cases r
    · exact Nat.zero_le 1
    · exact Nat.le_refl 1
  emits_on_warn _ _ _ h := h
  eta_alarm_step r _ _ _ _ pos := by
    show (if false then 1 else 0) < (if r then 1 else 0)
    cases r
    · exact absurd pos (Nat.lt_irrefl 0)
    · exact Nat.zero_lt_one
  eta_alarm_zero _ _ _ _ _ _ := rfl

theorem widened_heals_kernel :
    Viability.Kernel
      (closedProcess (OpenComponent.compose widenedAgent widenedAgent)
        (composeContract (widenedContract true) (widenedContract true))
        (fun x => (Nat.blt (x ()) 8, Nat.blt (x ()) 8))
        (fun (em : Bool) (_ : Nat) (_ : Unit) => em) gShared
        (fun (_ : Unit) (_ : Unit) => 0) (fun (_ : Unit) => True))
      (closedGuard (OpenComponent.compose widenedAgent widenedAgent)
        (composeContract (widenedContract true) (widenedContract true))
        (fun _ => 3))
      (fun _ => 6, (true, true)) := by
  refine compose_close_interchange widenedAgent widenedAgent
    (widenedContract true) (widenedContract true)
    (fun x => Nat.blt (x ()) 8) (fun x => Nat.blt (x ()) 8)
    (fun (em : Bool) (_ : Nat) (_ : Unit) => em) gShared
    (fun (_ : Unit) (_ : Unit) => 0) (fun _ => 0) (fun (_ : Unit) => True)
    (fun _ _ _ => Nat.zero_le 0)
    (fun _ => 3) (fun _ => 8) (fun _ => 0) (fun _ => 6)
    (fun x k lt => by cases k; exact Or.inl (CoreHelpers.natBlt_true_iff.mpr lt))
    (fun _ _ _ _ => rfl)
    gShared_rises
    (fun k => by cases k; show 3 ≤ 3 - 0 + gShared () (fun _ => 3 - 0); exact by decide)
    (fun k => by cases k; exact Nat.le_refl 0)
    (fun k => by cases k; show 3 + (CoreHelpers.natMax 1 1 + 1) * (1 + 1 + 0) ≤ 8; exact by decide)
    (fun k => by cases k; show 3 + CoreHelpers.natMax 1 1 * (1 + 1 + 0) ≤ 6; exact by decide)

end WideningWitness

theorem widen_interface_heals_blindness :
    (∀ (drawA drawB : Nat → Nat) (nextA nextB : Nat → Unit → Nat) (rA rB : Nat),
      (∀ r, 1 ≤ drawA r) → (∀ r, 1 ≤ drawB r) →
      (Law.orbit (fun st =>
        (RegimeMargin.step (fun z => WideningWitness.gShared () (fun _ => z))
          (drawA st.2.1 + drawB st.2.2) st.1,
         (nextA st.2.1 (), nextB st.2.2 ()))) (6, (rA, rB)) 6).1 = 0) ∧
    Viability.Kernel
      (closedProcess (OpenComponent.compose WideningWitness.widenedAgent WideningWitness.widenedAgent)
        (composeContract (WideningWitness.widenedContract true) (WideningWitness.widenedContract true))
        (fun x => (Nat.blt (x ()) 8, Nat.blt (x ()) 8))
        (fun (em : Bool) (_ : Nat) (_ : Unit) => em) WideningWitness.gShared
        (fun (_ : Unit) (_ : Unit) => 0) (fun (_ : Unit) => True))
      (closedGuard (OpenComponent.compose WideningWitness.widenedAgent WideningWitness.widenedAgent)
        (composeContract (WideningWitness.widenedContract true) (WideningWitness.widenedContract true))
        (fun _ => 3))
      (fun _ => 6, (true, true)) :=
  ⟨fun dA dB nA nB rA rB fA fB => WideningWitness.narrow_blind_crashes dA dB fA fB nA nB rA rB,
   WideningWitness.widened_heals_kernel⟩

/-! ## Part 5: Compositional Lax Multi-Scale Simulation (`SlackDist.max`, `SlackDist.sum`, `compose_laxSim`) -/

/-- Additive ($\ell_1$) product slack distance. -/
def SlackDist.sum {Q₁ Q₂ : Type} (M₁ : SlackDist Q₁) (M₂ : SlackDist Q₂) :
    SlackDist (Q₁ × Q₂) where
  d a b := M₁.d a.1 b.1 + M₂.d a.2 b.2
  refl q := by show M₁.d q.1 q.1 + M₂.d q.2 q.2 = 0; rw [M₁.refl, M₂.refl]
  tri a b c :=
    Nat.le_trans (Nat.add_le_add (M₁.tri a.1 b.1 c.1) (M₂.tri a.2 b.2 c.2))
      (Nat.le_of_eq (Nat.add_add_add_comm (M₁.d a.1 b.1) (M₁.d b.1 c.1) (M₂.d a.2 b.2) (M₂.d b.2 c.2)))

/-- Non-inflating ($\ell_\infty$) product slack distance via `natMax`. -/
def SlackDist.max {Q₁ Q₂ : Type} (M₁ : SlackDist Q₁) (M₂ : SlackDist Q₂) :
    SlackDist (Q₁ × Q₂) where
  d a b := CoreHelpers.natMax (M₁.d a.1 b.1) (M₂.d a.2 b.2)
  refl q := by show CoreHelpers.natMax (M₁.d q.1 q.1) (M₂.d q.2 q.2) = 0; rw [M₁.refl, M₂.refl]; rfl
  tri a b c :=
    CoreHelpers.natMax_le
      (Nat.le_trans (M₁.tri a.1 b.1 c.1)
        (Nat.add_le_add (CoreHelpers.le_natMax_left _ _) (CoreHelpers.le_natMax_left _ _)))
      (Nat.le_trans (M₂.tri a.2 b.2 c.2)
        (Nat.add_le_add (CoreHelpers.le_natMax_right _ _) (CoreHelpers.le_natMax_right _ _)))

/-- Synchronous product process `P₁ ⊗ P₂`. -/
def prodProcess {S₁ A₁ S₂ A₂ : Type}
    (P₁ : Process S₁ A₁) (P₂ : Process S₂ A₂) :
    Process (S₁ × S₂) (A₁ × A₂) where
  step s a s' := P₁.step s.1 a.1 s'.1 ∧ P₂.step s.2 a.2 s'.2

theorem prodProcess_trace_left {S₁ A₁ S₂ A₂ : Type}
    {P₁ : Process S₁ A₁} {P₂ : Process S₂ A₂} :
    ∀ {s : S₁ × S₂} {w : List (A₁ × A₂)} {t : S₁ × S₂},
      Trace (prodProcess P₁ P₂) s w t → Trace P₁ s.1 (w.map Prod.fst) t.1
  | _, [], _, .nil _ => .nil _
  | _, _ :: _, _, .cons st tr => .cons st.1 (prodProcess_trace_left tr)

theorem prodProcess_trace_right {S₁ A₁ S₂ A₂ : Type}
    {P₁ : Process S₁ A₁} {P₂ : Process S₂ A₂} :
    ∀ {s : S₁ × S₂} {w : List (A₁ × A₂)} {t : S₁ × S₂},
      Trace (prodProcess P₁ P₂) s w t → Trace P₂ s.2 (w.map Prod.snd) t.2
  | _, [], _, .nil _ => .nil _
  | _, _ :: _, _, .cons st tr => .cons st.2 (prodProcess_trace_right tr)

/-- **Compositional $\ell_\infty$ `LaxSim` on independent synchronous products**: horizontally
composes two synchronous `LaxSim`s over `prodProcess P₁ P₂` sharing strict schedule `σ` with NO
growth in contraction rate (`natMax (sim₁.α r) (sim₂.α r)`) or slack (`natMax sim₁.ε sim₂.ε`,
`natMax sim₁.η sim₂.η`). Note: bridging to a coupled `closedProcess` requires an explicit
trace-decoupling step. -/
def compose_laxSim_max
    {S₁ A₁ Q₁ B₁ S₂ A₂ Q₂ B₂ : Type}
    {P₁ : Process S₁ A₁} {R₁ : Process Q₁ B₁} {π₁ : S₁ → Q₁} {M₁ : SlackDist Q₁}
    {P₂ : Process S₂ A₂} {R₂ : Process Q₂ B₂} {π₂ : S₂ → Q₂} {M₂ : SlackDist Q₂}
    {σ : Nat → Nat}
    (sim₁ : LaxSim P₁ R₁ π₁ σ M₁)
    (sim₂ : LaxSim P₂ R₂ π₂ σ M₂) :
    LaxSim (prodProcess P₁ P₂) (prodProcess R₁ R₂) (fun s => (π₁ s.1, π₂ s.2)) σ
      (SlackDist.max M₁ M₂) where
  strict := sim₁.strict
  Epoch t s := sim₁.Epoch t s.1 ∧ sim₂.Epoch t s.2
  EpochQ k q := sim₁.EpochQ k q.1 ∧ sim₂.EpochQ k q.2
  epoch_step t s a s' ep st := ⟨sim₁.epoch_step t s.1 a.1 s'.1 ep.1 st.1,
    sim₂.epoch_step t s.2 a.2 s'.2 ep.2 st.2⟩
  epoch_proj k s ep := ⟨sim₁.epoch_proj k s.1 ep.1, sim₂.epoch_proj k s.2 ep.2⟩
  α r := CoreHelpers.natMax (sim₁.α r) (sim₂.α r)
  β r := CoreHelpers.natMax (sim₁.β r) (sim₂.β r)
  α_mono le := CoreHelpers.natMax_le
    (Nat.le_trans (sim₁.α_mono le) (CoreHelpers.le_natMax_left _ _))
    (Nat.le_trans (sim₂.α_mono le) (CoreHelpers.le_natMax_right _ _))
  β_mono le := CoreHelpers.natMax_le
    (Nat.le_trans (sim₁.β_mono le) (CoreHelpers.le_natMax_left _ _))
    (Nat.le_trans (sim₂.β_mono le) (CoreHelpers.le_natMax_right _ _))
  β_ge_id r := Nat.le_trans (sim₁.β_ge_id r) (CoreHelpers.le_natMax_left _ _)
  ε := CoreHelpers.natMax sim₁.ε sim₂.ε
  η := CoreHelpers.natMax sim₁.η sim₂.η
  sim_block k s q r w s' epS epQ d_le w_len tr :=
    let r1_le : M₁.d (π₁ s.1) q.1 ≤ r :=
      Nat.le_trans (CoreHelpers.le_natMax_left _ _) d_le
    let r2_le : M₂.d (π₂ s.2) q.2 ≤ r :=
      Nat.le_trans (CoreHelpers.le_natMax_right _ _) d_le
    let len1 : (w.map Prod.fst).length = σ (k + 1) - σ k := (length_map Prod.fst w).trans w_len
    let len2 : (w.map Prod.snd).length = σ (k + 1) - σ k := (length_map Prod.snd w).trans w_len
    match sim₁.sim_block k s.1 q.1 r (w.map Prod.fst) s'.1 epS.1 epQ.1 r1_le len1
        (prodProcess_trace_left tr),
      sim₂.sim_block k s.2 q.2 r (w.map Prod.snd) s'.2 epS.2 epQ.2 r2_le len2
        (prodProcess_trace_right tr) with
    | ⟨b₁, q₁', step₁, epQ₁', d₁'⟩, ⟨b₂, q₂', step₂, epQ₂', d₂'⟩ =>
      ⟨(b₁, b₂), (q₁', q₂'), ⟨step₁, step₂⟩, ⟨epQ₁', epQ₂'⟩,
       CoreHelpers.natMax_le
         (Nat.le_trans d₁' (Nat.add_le_add (CoreHelpers.le_natMax_left _ _)
           (CoreHelpers.le_natMax_left _ _)))
         (Nat.le_trans d₂' (Nat.add_le_add (CoreHelpers.le_natMax_right _ _)
           (CoreHelpers.le_natMax_right _ _)))⟩
  excursion k s q r w₁ u epS epQ d_le w₁_lt tr :=
    let r1_le : M₁.d (π₁ s.1) q.1 ≤ r :=
      Nat.le_trans (CoreHelpers.le_natMax_left _ _) d_le
    let r2_le : M₂.d (π₂ s.2) q.2 ≤ r :=
      Nat.le_trans (CoreHelpers.le_natMax_right _ _) d_le
    let lt1 : (w₁.map Prod.fst).length < σ (k + 1) - σ k :=
      Nat.lt_of_le_of_lt (Nat.le_of_eq (length_map Prod.fst w₁)) w₁_lt
    let lt2 : (w₁.map Prod.snd).length < σ (k + 1) - σ k :=
      Nat.lt_of_le_of_lt (Nat.le_of_eq (length_map Prod.snd w₁)) w₁_lt
    let d₁ := sim₁.excursion k s.1 q.1 r (w₁.map Prod.fst) u.1 epS.1 epQ.1 r1_le lt1
      (prodProcess_trace_left tr)
    let d₂ := sim₂.excursion k s.2 q.2 r (w₁.map Prod.snd) u.2 epS.2 epQ.2 r2_le lt2
      (prodProcess_trace_right tr)
    CoreHelpers.natMax_le
      (Nat.le_trans d₁ (Nat.add_le_add (CoreHelpers.le_natMax_left _ _)
        (CoreHelpers.le_natMax_left _ _)))
      (Nat.le_trans d₂ (Nat.add_le_add (CoreHelpers.le_natMax_right _ _)
        (CoreHelpers.le_natMax_right _ _)))

/-- **Additive ($\ell_1$) compositional `LaxSim` on independent synchronous products** (`prodProcess`),
parameterized by joint bounds `α_comb`, `β_comb`. Note: bridging to a coupled `closedProcess`
requires an explicit trace-decoupling step. -/
def compose_laxSim_sum
    {S₁ A₁ Q₁ B₁ S₂ A₂ Q₂ B₂ : Type}
    {P₁ : Process S₁ A₁} {R₁ : Process Q₁ B₁} {π₁ : S₁ → Q₁} {M₁ : SlackDist Q₁}
    {P₂ : Process S₂ A₂} {R₂ : Process Q₂ B₂} {π₂ : S₂ → Q₂} {M₂ : SlackDist Q₂}
    {σ : Nat → Nat}
    (sim₁ : LaxSim P₁ R₁ π₁ σ M₁)
    (sim₂ : LaxSim P₂ R₂ π₂ σ M₂)
    (α_comb β_comb : Nat → Nat)
    (α_mono : ∀ {a b}, a ≤ b → α_comb a ≤ α_comb b)
    (β_mono : ∀ {a b}, a ≤ b → β_comb a ≤ β_comb b)
    (β_ge_id : ∀ r, r ≤ β_comb r)
    (α_bound : ∀ r₁ r₂, sim₁.α r₁ + sim₂.α r₂ ≤ α_comb (r₁ + r₂))
    (β_bound : ∀ r₁ r₂, sim₁.β r₁ + sim₂.β r₂ ≤ β_comb (r₁ + r₂)) :
    LaxSim (prodProcess P₁ P₂) (prodProcess R₁ R₂) (fun s => (π₁ s.1, π₂ s.2)) σ
      (SlackDist.sum M₁ M₂) where
  strict := sim₁.strict
  Epoch t s := sim₁.Epoch t s.1 ∧ sim₂.Epoch t s.2
  EpochQ k q := sim₁.EpochQ k q.1 ∧ sim₂.EpochQ k q.2
  epoch_step t s a s' ep st := ⟨sim₁.epoch_step t s.1 a.1 s'.1 ep.1 st.1,
    sim₂.epoch_step t s.2 a.2 s'.2 ep.2 st.2⟩
  epoch_proj k s ep := ⟨sim₁.epoch_proj k s.1 ep.1, sim₂.epoch_proj k s.2 ep.2⟩
  α := α_comb
  β := β_comb
  α_mono := α_mono
  β_mono := β_mono
  β_ge_id := β_ge_id
  ε := sim₁.ε + sim₂.ε
  η := sim₁.η + sim₂.η
  sim_block k s q _ w s' epS epQ d_le w_len tr :=
    let r₁ := M₁.d (π₁ s.1) q.1
    let r₂ := M₂.d (π₂ s.2) q.2
    let len1 : (w.map Prod.fst).length = σ (k + 1) - σ k := (length_map Prod.fst w).trans w_len
    let len2 : (w.map Prod.snd).length = σ (k + 1) - σ k := (length_map Prod.snd w).trans w_len
    match sim₁.sim_block k s.1 q.1 r₁ (w.map Prod.fst) s'.1 epS.1 epQ.1 (Nat.le_refl r₁) len1
        (prodProcess_trace_left tr),
      sim₂.sim_block k s.2 q.2 r₂ (w.map Prod.snd) s'.2 epS.2 epQ.2 (Nat.le_refl r₂) len2
        (prodProcess_trace_right tr) with
    | ⟨b₁, q₁', step₁, epQ₁', d₁'⟩, ⟨b₂, q₂', step₂, epQ₂', d₂'⟩ =>
      ⟨(b₁, b₂), (q₁', q₂'), ⟨step₁, step₂⟩, ⟨epQ₁', epQ₂'⟩,
       Nat.le_trans (Nat.add_le_add d₁' d₂')
         (Nat.le_trans (Nat.le_of_eq (Nat.add_add_add_comm (sim₁.α r₁) sim₁.ε (sim₂.α r₂) sim₂.ε))
           (Nat.add_le_add_right (Nat.le_trans (α_bound r₁ r₂) (α_mono d_le)) (sim₁.ε + sim₂.ε)))⟩
  excursion k s q _ w₁ u epS epQ d_le w₁_lt tr :=
    let r₁ := M₁.d (π₁ s.1) q.1
    let r₂ := M₂.d (π₂ s.2) q.2
    let lt1 : (w₁.map Prod.fst).length < σ (k + 1) - σ k :=
      Nat.lt_of_le_of_lt (Nat.le_of_eq (length_map Prod.fst w₁)) w₁_lt
    let lt2 : (w₁.map Prod.snd).length < σ (k + 1) - σ k :=
      Nat.lt_of_le_of_lt (Nat.le_of_eq (length_map Prod.snd w₁)) w₁_lt
    let d₁ := sim₁.excursion k s.1 q.1 r₁ (w₁.map Prod.fst) u.1 epS.1 epQ.1 (Nat.le_refl r₁) lt1
      (prodProcess_trace_left tr)
    let d₂ := sim₂.excursion k s.2 q.2 r₂ (w₁.map Prod.snd) u.2 epS.2 epQ.2 (Nat.le_refl r₂) lt2
      (prodProcess_trace_right tr)
    Nat.le_trans (Nat.add_le_add d₁ d₂)
      (Nat.le_trans (Nat.le_of_eq (Nat.add_add_add_comm (sim₁.β r₁) sim₁.η (sim₂.β r₂) sim₂.η))
        (Nat.add_le_add_right (Nat.le_trans (β_bound r₁ r₂) (β_mono d_le)) (sim₁.η + sim₂.η)))

/-! **Worked composed non-lumping witness (`ComposedNonLumpingWitness`)**: horizontally composes
`WitnessTwoScale.sim₁₂` with itself via `compose_laxSim_max`, refutes exact `ProjectedLaws`
commuting lumping on the product, and certifies `Viability.Kernel` of `(22 ≤ u₁.1 ∧ 22 ≤ u₂.1)` at
`(WitnessTwoScale.s₀, WitnessTwoScale.s₀)`! -/
namespace ComposedNonLumpingWitness

def prodSim :
    LaxSim (prodProcess WitnessTwoScale.P WitnessTwoScale.P)
      (prodProcess WitnessTwoScale.R₂ WitnessTwoScale.R₂)
      (fun s => (WitnessTwoScale.π₂ (WitnessTwoScale.π₁ s.1),
                 WitnessTwoScale.π₂ (WitnessTwoScale.π₁ s.2)))
      (fun k => WitnessTwoScale.σ₁ (WitnessTwoScale.σ₂ k))
      (SlackDist.max SlackDist.nat SlackDist.nat) :=
  compose_laxSim_max WitnessTwoScale.sim₁₂ WitnessTwoScale.sim₁₂

theorem no_reduced_law_prod :
    ¬ ∃ reduced, ProjectedLaws.Commuting
      (fun s (_ : Unit × Unit) => (WitnessTwoScale.next s.1 (), WitnessTwoScale.next s.2 ()))
      reduced
      (fun s => (WitnessTwoScale.π₂ (WitnessTwoScale.π₁ s.1),
                 WitnessTwoScale.π₂ (WitnessTwoScale.π₁ s.2))) := by
  intro ⟨reduced, commutes⟩
  -- `(40, 0)` and `(40, 1)` project identically yet diverge on `s.1`
  have eq1 := commutes ((40, 0), (40, 0)) ((), ())
  have eq2 := commutes ((40, 1), (40, 0)) ((), ())
  have same := eq1.trans eq2.symm
  have fstEq := congrArg Prod.fst same
  exact absurd fstEq (by decide)

theorem div2_lt_12_of_lt_22 : ∀ n, n < 22 → n / 2 < 12
  | 0, _ => by decide
  | 1, _ => by decide
  | 2, _ => by decide
  | 3, _ => by decide
  | 4, _ => by decide
  | 5, _ => by decide
  | 6, _ => by decide
  | 7, _ => by decide
  | 8, _ => by decide
  | 9, _ => by decide
  | 10, _ => by decide
  | 11, _ => by decide
  | 12, _ => by decide
  | 13, _ => by decide
  | 14, _ => by decide
  | 15, _ => by decide
  | 16, _ => by decide
  | 17, _ => by decide
  | 18, _ => by decide
  | 19, _ => by decide
  | 20, _ => by decide
  | 21, _ => by decide
  | n + 22, h => absurd h (Nat.not_lt_of_ge (Nat.le_add_left 22 n))

theorem local_margin_two_scale (q : Nat) (u : Nat × Nat)
    (gq : WitnessTwoScale.guardQ₂ q)
    (hd : distNat (WitnessTwoScale.π₂ (WitnessTwoScale.π₁ u)) q ≤
      WitnessTwoScale.sim₁₂.β 6 + WitnessTwoScale.sim₁₂.η) :
    WitnessTwoScale.guardS u := by
  have hq : q = 20 := gq
  subst hq
  have hd8 : (u.1 / 2 - 20) + (20 - u.1 / 2) ≤ 8 := hd
  have hsub : 20 - u.1 / 2 ≤ 8 := Nat.le_trans (Nat.le_add_left _ _) hd8
  have h12 : 12 ≤ u.1 / 2 :=
    le_of_add_le_add_right 8
      (Nat.le_trans (Nat.le_of_eq (by decide : 12 + 8 = 20))
        (Nat.le_trans (CoreHelpers.le_sub_add_nat 20 (u.1 / 2))
          (Nat.le_trans (Nat.add_le_add_right hsub (u.1 / 2))
            (Nat.le_of_eq (Nat.add_comm 8 (u.1 / 2))))))
  cases Nat.lt_or_ge u.1 22 with
  | inl hlt => exact absurd (div2_lt_12_of_lt_22 u.1 hlt) (Nat.not_lt_of_ge h12)
  | inr hge => exact hge

theorem prod_viability_kernel :
    Viability.Kernel (prodProcess WitnessTwoScale.P WitnessTwoScale.P)
      (fun u => WitnessTwoScale.guardS u.1 ∧ WitnessTwoScale.guardS u.2)
      (WitnessTwoScale.s₀, WitnessTwoScale.s₀) := by
  let Kprod : Nat × Nat → Prop := fun q => WitnessTwoScale.K q.1 ∧ WitnessTwoScale.K q.2
  let guardQ : Nat × Nat → Prop := fun q => WitnessTwoScale.guardQ₂ q.1 ∧ WitnessTwoScale.guardQ₂ q.2
  have certQ : Viability.Certificate (prodProcess WitnessTwoScale.R₂ WitnessTwoScale.R₂) guardQ Kprod :=
    ⟨fun q hq => hq,
     fun q a q' st hq =>
       ⟨WitnessTwoScale.kernel_cert.closed q.1 a.1 q'.1 st.1 hq.1,
        WitnessTwoScale.kernel_cert.closed q.2 a.2 q'.2 st.2 hq.2⟩⟩
  refine lax_kernel_of_certificate prodSim certQ 6 ?_ ?_ ⟨rfl, rfl⟩ ⟨rfl, rfl⟩
  · show CoreHelpers.natMax ((6 + 1) / 2) ((6 + 1) / 2) + CoreHelpers.natMax 3 3 ≤ 6
    exact by decide
  · intro q u ⟨gq₁, gq₂⟩ d_le
    have d₁ : distNat (WitnessTwoScale.π₂ (WitnessTwoScale.π₁ u.1)) q.1 ≤
        WitnessTwoScale.sim₁₂.β 6 + WitnessTwoScale.sim₁₂.η :=
      Nat.le_trans (CoreHelpers.le_natMax_left _ _) d_le
    have d₂ : distNat (WitnessTwoScale.π₂ (WitnessTwoScale.π₁ u.2)) q.2 ≤
        WitnessTwoScale.sim₁₂.β 6 + WitnessTwoScale.sim₁₂.η :=
      Nat.le_trans (CoreHelpers.le_natMax_right _ _) d_le
    exact ⟨local_margin_two_scale q.1 u.1 gq₁ d₁,
      local_margin_two_scale q.2 u.2 gq₂ d₂⟩

end ComposedNonLumpingWitness

end OpenComposition

end Becoming
