import Becoming.AdaptiveLoops
import Becoming.MultiScaleViability

/-!
# Open composition: boundary ports, interface gluing, structural replacement, and compositional laxity

This module (`AI-written` for Wave 2 Pillar `L0`) extends `Becoming.AdaptiveLoops` and
`Becoming.MultiScaleViability` with explicit internal vs. exposed boundary ports (`OpenComponent`,
`InterfaceContract`), horizontal gluing (`compose`) and boundary hiding (`hide`) with constructive
associativity (`ComponentEquiv`), composition-preserved closed substrate viability vs.
hidden-coupling collapse, heterogeneous sub-component replacement (`ContractRefines`,
`ReconfigProcess`, `widen_interface_heals_blindness`), and synchronous-product compositional lax
multi-scale simulation (`SlackDist.max`, `SlackDist.sum`, `compose_laxSim_max`, `compose_laxSim_sum`).

All declarations compile from Lean's prelude alone with empty axiom reports (`0` axioms, `0` `sorry`).
-/

namespace Becoming

open Generative

namespace OpenComposition

/-! ## Shared helpers (prelude-only, zero axioms) -/

theorem bool_or_true_right (a : Bool) : (a || true) = true := by
  cases a <;> rfl

theorem bool_or_assoc (a b c : Bool) : ((a || b) || c) = (a || (b || c)) := by
  cases a <;> cases b <;> cases c <;> rfl

theorem natMax_add_le (a b c d : Nat) :
    AdaptiveLoops.natMax a b + AdaptiveLoops.natMax c d ≥ AdaptiveLoops.natMax (a + c) (b + d) :=
  AdaptiveLoops.natMax_le
    (Nat.add_le_add (AdaptiveLoops.le_natMax_left a b) (AdaptiveLoops.le_natMax_left c d))
    (Nat.add_le_add (AdaptiveLoops.le_natMax_right a b) (AdaptiveLoops.le_natMax_right c d))

theorem natMax_add_max_le (a b c d : Nat) :
    AdaptiveLoops.natMax (a + c) (b + d) ≤ AdaptiveLoops.natMax a b + AdaptiveLoops.natMax c d :=
  natMax_add_le a b c d

theorem natMax_zero_zero : AdaptiveLoops.natMax 0 0 = 0 := rfl

theorem add_four_swap (a b c d : Nat) : (a + b) + (c + d) = (a + c) + (b + d) := by
  calc
    (a + b) + (c + d) = a + (b + (c + d)) := Nat.add_assoc a b (c + d)
    _ = a + ((b + c) + d) := by rw [Nat.add_assoc b c d]
    _ = a + ((c + b) + d) := by rw [Nat.add_comm b c]
    _ = a + (c + (b + d)) := by rw [Nat.add_assoc c b d]
    _ = (a + c) + (b + d) := (Nat.add_assoc a c (b + d)).symm

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
        (AdaptiveLoops.indexedStep_ge_sub G H x j))
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
          (Nat.le_trans (AdaptiveLoops.indexedStep_antitone_H G_rises H_le_safe x_crit j)
            (AdaptiveLoops.indexedStep_mono G_rises H xCritLe j))
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
          (AdaptiveLoops.indexedStep_ge_sub G H x j))

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

/-- Lift an `AdaptiveLoops.OpenLoop` into an `OpenComponent` with no private sites (`Empty`). -/
def OpenComponent.ofOpenLoop {S Obs Dist ι : Type}
    (L : AdaptiveLoops.OpenLoop S Obs Dist ι) :
    OpenComponent S Obs Dist Empty ι where
  next := L.next
  drawInt _ e := Empty.elim e
  drawExt := L.draw
  emitAlarm := L.emitAlarm
  silenceLoad := L.silenceLoad
  favours := L.favours

/-- Forget the internal/external split of an `OpenComponent` back to an `AdaptiveLoops.OpenLoop`
over `Sum Int Ext`. -/
def OpenComponent.toOpenLoop {S Obs Dist Int Ext : Type}
    (C : OpenComponent S Obs Dist Int Ext) :
    AdaptiveLoops.OpenLoop S Obs Dist (Sum Int Ext) where
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

/-- Lift an `AdaptiveLoops.LoopCertificate` onto `OpenComponent.ofOpenLoop`. -/
def InterfaceContract.ofLoopCertificate {S Obs Dist ι : Type}
    {L : AdaptiveLoops.OpenLoop S Obs Dist ι} {init : S}
    (cert : AdaptiveLoops.LoopCertificate L init) :
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
  maxLag := AdaptiveLoops.natMax cA.maxLag cB.maxLag
  K s := cA.K s.1 ∧ cB.K s.2
  eta s := AdaptiveLoops.natMax (cA.eta s.1) (cB.eta s.2)
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
             (Nat.le_trans (AdaptiveLoops.le_natMax_left _ _) (Nat.le_of_eq hEta))
         have hEtaB : cB.eta s.2 = 0 :=
           Nat.eq_zero_of_le_zero
             (Nat.le_trans (AdaptiveLoops.le_natMax_right _ _) (Nat.le_of_eq hEta))
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
    AdaptiveLoops.natMax_le
      (Nat.le_trans (cA.eta_bound s.1 hA) (AdaptiveLoops.le_natMax_left _ _))
      (Nat.le_trans (cB.eta_bound s.2 hB) (AdaptiveLoops.le_natMax_right _ _))
  emits_on_warn := fun s oa ⟨hA, hB⟩ warn => by
    change (A.emitAlarm s.1 oa.1 || B.emitAlarm s.2 oa.2) = true
    cases warn with
    | inl wA =>
      rw [cA.emits_on_warn s.1 oa.1 hA wA]
      rfl
    | inr wB =>
      rw [cB.emits_on_warn s.2 oa.2 hB wB]
      exact bool_or_true_right _
  eta_alarm_step := fun s oa d tol ⟨hA, hB⟩ pos => by
    have stepA : cA.eta (A.next s.1 (oa.1, true) d.1) <
        AdaptiveLoops.natMax (cA.eta s.1) (cB.eta s.2) := by
      cases Nat.eq_zero_or_pos (cA.eta s.1) with
      | inl hEA =>
        rw [cA.eta_alarm_zero s.1 oa.1 d.1 tol.1 hA hEA]
        exact pos
      | inr hposA =>
        exact Nat.lt_of_lt_of_le
          (cA.eta_alarm_step s.1 oa.1 d.1 tol.1 hA hposA)
          (AdaptiveLoops.le_natMax_left _ _)
    have stepB : cB.eta (B.next s.2 (oa.2, true) d.2) <
        AdaptiveLoops.natMax (cA.eta s.1) (cB.eta s.2) := by
      cases Nat.eq_zero_or_pos (cB.eta s.2) with
      | inl hEB =>
        rw [cB.eta_alarm_zero s.2 oa.2 d.2 tol.2 hB hEB]
        exact pos
      | inr hposB =>
        exact Nat.lt_of_lt_of_le
          (cB.eta_alarm_step s.2 oa.2 d.2 tol.2 hB hposB)
          (AdaptiveLoops.le_natMax_right _ _)
    change AdaptiveLoops.natMax (cA.eta (A.next s.1 (oa.1, true) d.1))
        (cB.eta (B.next s.2 (oa.2, true) d.2)) <
      AdaptiveLoops.natMax (cA.eta s.1) (cB.eta s.2)
    cases Nat.decLe (cA.eta (A.next s.1 (oa.1, true) d.1)) (cB.eta (B.next s.2 (oa.2, true) d.2)) with
    | isTrue le =>
      rw [show AdaptiveLoops.natMax (cA.eta (A.next s.1 (oa.1, true) d.1))
          (cB.eta (B.next s.2 (oa.2, true) d.2)) =
          cB.eta (B.next s.2 (oa.2, true) d.2) from if_pos le]
      exact stepB
    | isFalse notLe =>
      rw [show AdaptiveLoops.natMax (cA.eta (A.next s.1 (oa.1, true) d.1))
          (cB.eta (B.next s.2 (oa.2, true) d.2)) =
          cA.eta (A.next s.1 (oa.1, true) d.1) from if_neg notLe]
      exact stepA
  eta_alarm_zero := fun s oa d tol ⟨hA, hB⟩ hEta => by
    have hEtaA : cA.eta s.1 = 0 :=
      Nat.eq_zero_of_le_zero
        (Nat.le_trans (AdaptiveLoops.le_natMax_left _ _) (Nat.le_of_eq hEta))
    have hEtaB : cB.eta s.2 = 0 :=
      Nat.eq_zero_of_le_zero
        (Nat.le_trans (AdaptiveLoops.le_natMax_right _ _) (Nat.le_of_eq hEta))
    have zA := cA.eta_alarm_zero s.1 oa.1 d.1 tol.1 hA hEtaA
    have zB := cB.eta_alarm_zero s.2 oa.2 d.2 tol.2 hB hEtaB
    show AdaptiveLoops.natMax (cA.eta (A.next s.1 (oa.1, true) d.1))
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
  comm_emitAlarm s oa := bool_or_assoc (A.emitAlarm s.1.1 oa.1.1) (B.emitAlarm s.1.2 oa.1.2) (C.emitAlarm s.2 oa.2)
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
         exact bool_or_true_right al
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

/-! ## Part 3: Closing onto Coupled Substrates & Conditional Double-Category Interchange -/

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
  let o := obs st.1
  let al := channel (C.emitAlarm st.2 o) (C.silenceLoad st.2) m.1
  let H := fun k => C.drawExt st.2 k + envDraw m.1 k
  (RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole G H st.1,
   C.next st.2 (o, al) m.2)

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
      (closedGuard C c x_crit) (closedInv c envCap x_crit) := by
  refine ⟨⟨c.init_in, init_margin⟩, Viability.certificate_disturbed_iff.mpr ⟨?_, ?_⟩⟩
  · intro st ⟨hK, margin⟩
    exact ⟨fun k => Nat.le_trans (Nat.le_add_right _ _) (margin k), c.cert.within st.2 hK⟩
  · intro st m adm ⟨hK, margin⟩
    obtain ⟨x, s⟩ := st
    obtain ⟨env, dist⟩ := m
    obtain ⟨envOk, tolOk⟩ := adm
    let o := obs x
    let al := channel (C.emitAlarm s o) (C.silenceLoad s) env
    let H := fun k => C.drawExt s k + envDraw env k
    let s' := C.next s (o, al) dist
    have wS := c.cert.within s hK
    have hK' : c.K s' := c.cert.closed s ((o, al), dist) s' ⟨tolOk (o, al), rfl⟩ hK
    have H_le_pre : ∀ k, H k ≤ c.preCapExt k + envCap k := fun k =>
      Nat.add_le_add (wS.2.1 k) (env_within env envOk k)
    refine ⟨hK', fun k => ?_⟩
    refine substrate_margin_step G_rises H_le_pre (c.eta_bound s' hK') post_viable warn_margin margin k ?_
    intro below
    have emitTrue : C.emitAlarm s o = true := c.emits_on_warn s o hK (obs_detects x k below)
    have alTrue : al = true := by
      show channel (C.emitAlarm s o) (C.silenceLoad s) env = true
      rw [emitTrue]
      exact channel_fires (C.silenceLoad s) env envOk wS.2.2.1
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
      (AdaptiveLoops.natMax cA.maxLag cB.maxLag + 1) *
        ((cA.preCapExt k + cB.preCapExt k) + envCap k) ≤ warnLevel k)
    (init_margin : ∀ k, x_crit k +
      AdaptiveLoops.natMax (cA.eta init₁) (cB.eta init₂) *
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
def blindDrawer : OpenComponent Unit Unit Unit Empty Unit where
  next _ _ _ := ()
  drawInt _ e := Empty.elim e
  drawExt _ _ := 1
  emitAlarm _ _ := false
  silenceLoad _ := 0
  favours _ := False

def blindContract : InterfaceContract blindDrawer () where
  tol _ _ := True
  warnObs _ := False
  preCapInt e := Empty.elim e
  preCapExt _ := 1
  postBudgetInt e := Empty.elim e
  postBudgetExt _ := 1
  maxSilence := 0
  maxLag := 0
  K _ := True
  eta _ := 0
  init_in := trivial
  cert := Viability.certificate_disturbed_iff.mpr
    ⟨fun _ _ => ⟨fun e => Empty.elim e, fun _ => Nat.le_refl 1, Nat.le_refl 0,
      fun _ => ⟨fun f => f, fun e => Empty.elim e, fun _ => Nat.le_refl 1⟩⟩,
     fun _ _ _ _ => trivial⟩
  eta_bound _ _ := Nat.le_refl 0
  emits_on_warn _ _ _ f := False.elim f
  eta_alarm_step _ _ _ _ _ pos := absurd pos (Nat.lt_irrefl 0)
  eta_alarm_zero _ _ _ _ _ _ := rfl

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
      (AdaptiveLoops.natMax cA.maxLag cB.maxLag + 1) *
        ((cA.preCapExt k + cB.preCapExt k) + envCap k) ≤ warnLevel k)
    (init_margin : ∀ k, x_crit k +
      AdaptiveLoops.natMax (cA.eta init₁) (cB.eta init₂) *
        ((cA.preCapExt k + cB.preCapExt k) + envCap k) ≤ x₀ k) :
    Viability.Kernel
      (closedProcess (OpenComponent.compose A' B) (composeContract cA' cB)
        (fun x => (obs₁' x, obs₂ x)) channel G envDraw jointAdm)
      (closedGuard (OpenComponent.compose A' B) (composeContract cA' cB) x_crit)
      (x₀, (init₁', init₂)) := by
  refine compose_close_interchange A' B cA' cB obs₁' obs₂ channel G envDraw envCap jointAdm
    env_within x_crit warnLevel H_safe x₀ ?_ ?_ G_rises post_viable ?_ ?_ ?_
  · intro x k lt
    cases obs_detects_orig x k lt with
    | inl w1 => exact Or.inl (refines.warn_preserved x w1 ⟨k, lt⟩)
    | inr w2 => exact Or.inr w2
  · intro load env adm le
    exact channel_fires load env adm (Nat.le_trans le (Nat.add_le_add_right refines.maxSilence_le _))
  · intro k
    exact Nat.le_trans
      (Nat.add_le_add_right (Nat.add_le_add_right (refines.postBudgetExt_le k) _) _)
      (post_budget k)
  · intro k
    have lagLe : AdaptiveLoops.natMax cA'.maxLag cB.maxLag + 1 ≤
        AdaptiveLoops.natMax cA.maxLag cB.maxLag + 1 :=
      Nat.succ_le_succ
        (AdaptiveLoops.natMax_le
          (Nat.le_trans refines.maxLag_le (AdaptiveLoops.le_natMax_left _ _))
          (AdaptiveLoops.le_natMax_right _ _))
    have capLe : (cA'.preCapExt k + cB.preCapExt k) + envCap k ≤
        (cA.preCapExt k + cB.preCapExt k) + envCap k :=
      Nat.add_le_add_right (Nat.add_le_add_right (refines.preCapExt_le k) _) _
    exact Nat.le_trans (Nat.add_le_add_left (Nat.mul_le_mul lagLe capLe) _) (warn_margin k)
  · intro k
    have etaLe : AdaptiveLoops.natMax (cA'.eta init₁') (cB.eta init₂) ≤
        AdaptiveLoops.natMax (cA.eta init₁) (cB.eta init₂) :=
      AdaptiveLoops.natMax_le
        (Nat.le_trans refines.init_eta_le (AdaptiveLoops.le_natMax_left _ _))
        (AdaptiveLoops.le_natMax_right _ _)
    have capLe : (cA'.preCapExt k + cB.preCapExt k) + envCap k ≤
        (cA.preCapExt k + cB.preCapExt k) + envCap k :=
      Nat.add_le_add_right (Nat.add_le_add_right (refines.preCapExt_le k) _) _
    exact Nat.le_trans (Nat.add_le_add_left (Nat.mul_le_mul etaLe capLe) _) (init_margin k)

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
    (fun x k lt => by cases k; exact Or.inl (AdaptiveLoops.natBlt_true_iff.mpr lt))
    (fun _ _ _ _ => rfl)
    gShared_rises
    (fun k => by cases k; show 3 ≤ 3 - 0 + gShared () (fun _ => 3 - 0); exact by decide)
    (fun k => by cases k; exact Nat.le_refl 0)
    (fun k => by cases k; show 3 + (AdaptiveLoops.natMax 1 1 + 1) * (1 + 1 + 0) ≤ 8; exact by decide)
    (fun k => by cases k; show 3 + AdaptiveLoops.natMax 1 1 * (1 + 1 + 0) ≤ 6; exact by decide)

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
      (Nat.le_of_eq (add_four_swap (M₁.d a.1 b.1) (M₁.d b.1 c.1) (M₂.d a.2 b.2) (M₂.d b.2 c.2)))

/-- Non-inflating ($\ell_\infty$) product slack distance via `natMax`. -/
def SlackDist.max {Q₁ Q₂ : Type} (M₁ : SlackDist Q₁) (M₂ : SlackDist Q₂) :
    SlackDist (Q₁ × Q₂) where
  d a b := AdaptiveLoops.natMax (M₁.d a.1 b.1) (M₂.d a.2 b.2)
  refl q := by show AdaptiveLoops.natMax (M₁.d q.1 q.1) (M₂.d q.2 q.2) = 0; rw [M₁.refl, M₂.refl]; rfl
  tri a b c :=
    AdaptiveLoops.natMax_le
      (Nat.le_trans (M₁.tri a.1 b.1 c.1)
        (Nat.add_le_add (AdaptiveLoops.le_natMax_left _ _) (AdaptiveLoops.le_natMax_left _ _)))
      (Nat.le_trans (M₂.tri a.2 b.2 c.2)
        (Nat.add_le_add (AdaptiveLoops.le_natMax_right _ _) (AdaptiveLoops.le_natMax_right _ _)))

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
  α r := AdaptiveLoops.natMax (sim₁.α r) (sim₂.α r)
  β r := AdaptiveLoops.natMax (sim₁.β r) (sim₂.β r)
  α_mono le := AdaptiveLoops.natMax_le
    (Nat.le_trans (sim₁.α_mono le) (AdaptiveLoops.le_natMax_left _ _))
    (Nat.le_trans (sim₂.α_mono le) (AdaptiveLoops.le_natMax_right _ _))
  β_mono le := AdaptiveLoops.natMax_le
    (Nat.le_trans (sim₁.β_mono le) (AdaptiveLoops.le_natMax_left _ _))
    (Nat.le_trans (sim₂.β_mono le) (AdaptiveLoops.le_natMax_right _ _))
  β_ge_id r := Nat.le_trans (sim₁.β_ge_id r) (AdaptiveLoops.le_natMax_left _ _)
  ε := AdaptiveLoops.natMax sim₁.ε sim₂.ε
  η := AdaptiveLoops.natMax sim₁.η sim₂.η
  sim_block k s q r w s' epS epQ d_le w_len tr :=
    let r1_le : M₁.d (π₁ s.1) q.1 ≤ r :=
      Nat.le_trans (AdaptiveLoops.le_natMax_left _ _) d_le
    let r2_le : M₂.d (π₂ s.2) q.2 ≤ r :=
      Nat.le_trans (AdaptiveLoops.le_natMax_right _ _) d_le
    let len1 : (w.map Prod.fst).length = σ (k + 1) - σ k := (length_map Prod.fst w).trans w_len
    let len2 : (w.map Prod.snd).length = σ (k + 1) - σ k := (length_map Prod.snd w).trans w_len
    match sim₁.sim_block k s.1 q.1 r (w.map Prod.fst) s'.1 epS.1 epQ.1 r1_le len1
        (prodProcess_trace_left tr),
      sim₂.sim_block k s.2 q.2 r (w.map Prod.snd) s'.2 epS.2 epQ.2 r2_le len2
        (prodProcess_trace_right tr) with
    | ⟨b₁, q₁', step₁, epQ₁', d₁'⟩, ⟨b₂, q₂', step₂, epQ₂', d₂'⟩ =>
      ⟨(b₁, b₂), (q₁', q₂'), ⟨step₁, step₂⟩, ⟨epQ₁', epQ₂'⟩,
       AdaptiveLoops.natMax_le
         (Nat.le_trans d₁' (Nat.add_le_add (AdaptiveLoops.le_natMax_left _ _)
           (AdaptiveLoops.le_natMax_left _ _)))
         (Nat.le_trans d₂' (Nat.add_le_add (AdaptiveLoops.le_natMax_right _ _)
           (AdaptiveLoops.le_natMax_right _ _)))⟩
  excursion k s q r w₁ u epS epQ d_le w₁_lt tr :=
    let r1_le : M₁.d (π₁ s.1) q.1 ≤ r :=
      Nat.le_trans (AdaptiveLoops.le_natMax_left _ _) d_le
    let r2_le : M₂.d (π₂ s.2) q.2 ≤ r :=
      Nat.le_trans (AdaptiveLoops.le_natMax_right _ _) d_le
    let lt1 : (w₁.map Prod.fst).length < σ (k + 1) - σ k :=
      Nat.lt_of_le_of_lt (Nat.le_of_eq (length_map Prod.fst w₁)) w₁_lt
    let lt2 : (w₁.map Prod.snd).length < σ (k + 1) - σ k :=
      Nat.lt_of_le_of_lt (Nat.le_of_eq (length_map Prod.snd w₁)) w₁_lt
    let d₁ := sim₁.excursion k s.1 q.1 r (w₁.map Prod.fst) u.1 epS.1 epQ.1 r1_le lt1
      (prodProcess_trace_left tr)
    let d₂ := sim₂.excursion k s.2 q.2 r (w₁.map Prod.snd) u.2 epS.2 epQ.2 r2_le lt2
      (prodProcess_trace_right tr)
    AdaptiveLoops.natMax_le
      (Nat.le_trans d₁ (Nat.add_le_add (AdaptiveLoops.le_natMax_left _ _)
        (AdaptiveLoops.le_natMax_left _ _)))
      (Nat.le_trans d₂ (Nat.add_le_add (AdaptiveLoops.le_natMax_right _ _)
        (AdaptiveLoops.le_natMax_right _ _)))

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
         (Nat.le_trans (Nat.le_of_eq (add_four_swap (sim₁.α r₁) sim₁.ε (sim₂.α r₂) sim₂.ε))
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
      (Nat.le_trans (Nat.le_of_eq (add_four_swap (sim₁.β r₁) sim₁.η (sim₂.β r₂) sim₂.η))
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
        (Nat.le_trans (le_sub_add_nat 20 (u.1 / 2))
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
  · show AdaptiveLoops.natMax ((6 + 1) / 2) ((6 + 1) / 2) + AdaptiveLoops.natMax 3 3 ≤ 6
    exact by decide
  · intro q u ⟨gq₁, gq₂⟩ d_le
    have d₁ : distNat (WitnessTwoScale.π₂ (WitnessTwoScale.π₁ u.1)) q.1 ≤
        WitnessTwoScale.sim₁₂.β 6 + WitnessTwoScale.sim₁₂.η :=
      Nat.le_trans (AdaptiveLoops.le_natMax_left _ _) d_le
    have d₂ : distNat (WitnessTwoScale.π₂ (WitnessTwoScale.π₁ u.2)) q.2 ≤
        WitnessTwoScale.sim₁₂.β 6 + WitnessTwoScale.sim₁₂.η :=
      Nat.le_trans (AdaptiveLoops.le_natMax_right _ _) d_le
    exact ⟨local_margin_two_scale q.1 u.1 gq₁ d₁,
      local_margin_two_scale q.2 u.2 gq₂ d₂⟩

end ComposedNonLumpingWitness

end OpenComposition

end Becoming
