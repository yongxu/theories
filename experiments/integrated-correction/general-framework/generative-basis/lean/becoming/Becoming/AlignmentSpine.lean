import Becoming.OpenComposition
import Becoming.EndogenousTurning
import Becoming.UnifiedDrawdown
import Becoming.ScopeDynamics
import Becoming.MultiScaleViability
import Becoming.PacedStock
import Becoming.TransformativeViability
import Becoming.ClosedCapture
import Becoming.Flow
import Becoming.Grammar
import Becoming.PremiseWitnesses
import Becoming.Significance
import Becoming.Selection
import Becoming.BeyondCoupling

/-!
# Alignment Spine (`L5`): Composed `L0–L3` Persistence, Failure Dichotomy, and Sharpness Suite

This module (`AI-written` for Wave 2 Pillar `L5`) completes the Lean sufficiency wave in the
pure `Init`-only Core (`0` axioms, `0` `sorry`, zero Mathlib imports, strict `L2` layering):

* **Part 1 — Composed 3-Pillar Open Alignment Architecture (`ComposedSpine`)**:
  Constructive transport (`composeCommEquiv`, `ContractEquiv`, `composeAssocContractEquiv`,
  `composeCommContractEquiv`), right-side and nested refinement combinators (`replace_right_viable`,
  `contractRefines_compose_left`, `contractRefines_compose_right`), the composed 3-pillar spine
  `((turningSub ⊕ fleetSub) ⊕ scopeSub)` joining `L1`, `L2`, and `L3` over `L0`, modular pillar
  upgrades and live mid-run reconfiguration (`master_alignment_spine_viable`,
  `master_spine_upgrade_turning_viable`, `master_spine_live_reconfig_viable`,
  `master_spine_upgrade_fleet_viable`, `master_spine_upgrade_scope_viable`), internalized
  hidden-port closure via `OpenComponent.hide` (`withHiddenSite`, `master_spine_hide_viable`),
  synchronous multi-scale transfer (`master_spine_multiscale_transfer`), and the concrete
  non-vacuous inhabited-`Int` witness `MasterSpineWitness.witness_viable`.

* **Part 2 — Structural Failure Dichotomy & Metaethical Boundary (`AlignmentDichotomy`)**:
  Re-exports without duplication the verified persistence boundaries (`l0_l3_persistence_boundary`),
  structural obstructions (`structural_failure_atlas`), conservation/aliasing boundaries
  (`pre_overdraw_and_aliasing_boundaries`), and coupling/metaethical non-entailments
  (`epistemic_scope_metaethical_boundary`, `master_alignment_dichotomy`), explicitly preserving
  the `AGENTS.md` Rule 2 empirical recognition boundary and `ReadsOnlyDynamics.not_entails` /
  `ReadsNoOrder.not_entails`.

* **Part 3 — Hypothesis-Dropping Sharpness & `文理生生 v0.2` Suite (`SharpnessSuite`)**:
  Finite zero-axiom counter-models verifying every key hypothesis sharp:
  - `L5-CE01a` (`ReconfigCountdownJumpFails`): countdown handoff `cA'.eta s' ≤ cA.eta st₁.2`
  - `L5-CE01b` (`BlindHideCollapse`): `wire_hide_warn` in `hideContract_keeps_hidden`
  - `L5-CE14` (`HideSideChannelLeakage`): port hiding ≠ confidentiality side-channel immunity
  - `L5-CE02` (`TypeSameSemanticsMismatch`): `ContractRefines.warn_preserved` under identical types & caps
  - `L5-CE03` (`SilencingSumBreaksComposition`): additive `cA.maxSilence + cB.maxSilence`
  - `L5-CE04` (`SameWiringNonMonotoneSubstrate`): `G_rises` monotonicity with identical wiring
  - `L5-CE05b` (`ConcurrentReconfigConflict`): unserialized simultaneous `(A, B) ↝ (A', B')`
  - `L5-CE08a` (`LaxTubeOverflowWitness`): `sim.α Δ + sim.ε ≤ Δ` tube absorption
  - `L5-CE08b` (`CoupledLaxNonDecouplingWitness`): `prodProcess` decoupling vs shared substrate
  - `L5-CE09` (`SelfModifyingValidatorCapture`): self-certified `cCap` without trusted-base bounds
  - `L5-CE10` (`ViableSelfExternalizesVictim`): own-port `Viability.Kernel` vs downstream victim
  - `文理生生 v0.2` (`slackDist_nat_not_transitive`, `exact_equivalence_is_class`,
    `WaterTankCouplingWitness`): non-transitivity of `≈_{O,ε}` vs `Grammar.«类»`, plus the 22-state
    lagged water tank showing `[4, 6]` non-invariance without `u` and conserved-mass non-observability.
-/

namespace Becoming

open Generative

namespace AlignmentSpine

/-! ## Part 1: Composed 3-Pillar Open Alignment Architecture (`ComposedSpine`) -/

namespace ComposedSpine

/-! ### 1.1 Algebraic Transport & Right-Replacement Infrastructure -/

/-- Constructive zero-axiom helper for `false || b = b`. -/
theorem bool_or_false_left (b : Bool) : (false || b) = b := rfl

/-- Constructive commutativity of `AdaptiveLoops.natMax` (`0` axioms). -/
theorem natMax_comm (a b : Nat) : AdaptiveLoops.natMax a b = AdaptiveLoops.natMax b a :=
  Nat.le_antisymm
    (AdaptiveLoops.natMax_le (AdaptiveLoops.le_natMax_right b a) (AdaptiveLoops.le_natMax_left b a))
    (AdaptiveLoops.natMax_le (AdaptiveLoops.le_natMax_right a b) (AdaptiveLoops.le_natMax_left a b))

/-- Constructive associativity of `AdaptiveLoops.natMax` (`0` axioms). -/
theorem natMax_assoc (a b c : Nat) :
    AdaptiveLoops.natMax (AdaptiveLoops.natMax a b) c =
      AdaptiveLoops.natMax a (AdaptiveLoops.natMax b c) :=
  Nat.le_antisymm
    (AdaptiveLoops.natMax_le
      (AdaptiveLoops.natMax_le
        (AdaptiveLoops.le_natMax_left _ _)
        (Nat.le_trans (AdaptiveLoops.le_natMax_left b c) (AdaptiveLoops.le_natMax_right _ _)))
      (Nat.le_trans (AdaptiveLoops.le_natMax_right b c) (AdaptiveLoops.le_natMax_right _ _)))
    (AdaptiveLoops.natMax_le
      (Nat.le_trans (AdaptiveLoops.le_natMax_left a b) (AdaptiveLoops.le_natMax_left _ _))
      (AdaptiveLoops.natMax_le
        (Nat.le_trans (AdaptiveLoops.le_natMax_right a b) (AdaptiveLoops.le_natMax_left _ _))
        (AdaptiveLoops.le_natMax_right _ _)))

/-- Constructive commutativity equivalence `A ⊕ B ≃ B ⊕ A` (`0` axioms). -/
def composeCommEquiv
    {S₁ S₂ Obs₁ Obs₂ Dist₁ Dist₂ Int₁ Int₂ Ext : Type}
    (A : OpenComposition.OpenComponent S₁ Obs₁ Dist₁ Int₁ Ext)
    (B : OpenComposition.OpenComponent S₂ Obs₂ Dist₂ Int₂ Ext) :
    OpenComposition.ComponentEquiv
      (OpenComposition.OpenComponent.compose A B)
      (OpenComposition.OpenComponent.compose B A) where
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

/-- Constructive contract compatibility across a `ComponentEquiv`, using explicit forward/backward
maps instead of `Prop` equality so zero `propext` enters. -/
structure ContractEquiv
    {S₁ S₂ Obs₁ Obs₂ Dist₁ Dist₂ Int₁ Int₂ Ext : Type}
    {A : OpenComposition.OpenComponent S₁ Obs₁ Dist₁ Int₁ Ext}
    {B : OpenComposition.OpenComponent S₂ Obs₂ Dist₂ Int₂ Ext}
    {init₁ : S₁} {init₂ : S₂}
    (E : OpenComposition.ComponentEquiv A B)
    (cA : OpenComposition.InterfaceContract A init₁)
    (cB : OpenComposition.InterfaceContract B init₂) : Prop where
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

/-- Associativity of `composeContract` along `OpenComposition.composeAssocEquiv`. -/
theorem composeAssocContractEquiv
    {S₁ S₂ S₃ Obs₁ Obs₂ Obs₃ Dist₁ Dist₂ Dist₃ Int₁ Int₂ Int₃ Ext : Type}
    {A : OpenComposition.OpenComponent S₁ Obs₁ Dist₁ Int₁ Ext}
    {B : OpenComposition.OpenComponent S₂ Obs₂ Dist₂ Int₂ Ext}
    {C : OpenComposition.OpenComponent S₃ Obs₃ Dist₃ Int₃ Ext}
    {init₁ : S₁} {init₂ : S₂} {init₃ : S₃}
    (cA : OpenComposition.InterfaceContract A init₁)
    (cB : OpenComposition.InterfaceContract B init₂)
    (cC : OpenComposition.InterfaceContract C init₃) :
    ContractEquiv
      (OpenComposition.composeAssocEquiv A B C)
      (OpenComposition.composeContract (OpenComposition.composeContract cA cB) cC)
      (OpenComposition.composeContract cA (OpenComposition.composeContract cB cC)) where
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
  maxLag_eq := natMax_assoc cA.maxLag cB.maxLag cC.maxLag
  K_to _ h := ⟨h.1.1, ⟨h.1.2, h.2⟩⟩
  K_inv _ h := ⟨⟨h.1, h.2.1⟩, h.2.2⟩
  eta_eq s := natMax_assoc (cA.eta s.1.1) (cB.eta s.1.2) (cC.eta s.2)

/-- Commutativity of `composeContract` along `composeCommEquiv`. -/
theorem composeCommContractEquiv
    {S₁ S₂ Obs₁ Obs₂ Dist₁ Dist₂ Int₁ Int₂ Ext : Type}
    {A : OpenComposition.OpenComponent S₁ Obs₁ Dist₁ Int₁ Ext}
    {B : OpenComposition.OpenComponent S₂ Obs₂ Dist₂ Int₂ Ext}
    {init₁ : S₁} {init₂ : S₂}
    (cA : OpenComposition.InterfaceContract A init₁)
    (cB : OpenComposition.InterfaceContract B init₂) :
    ContractEquiv
      (composeCommEquiv A B)
      (OpenComposition.composeContract cA cB)
      (OpenComposition.composeContract cB cA) where
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
  maxLag_eq := natMax_comm cA.maxLag cB.maxLag
  K_to _ h := ⟨h.2, h.1⟩
  K_inv _ h := ⟨h.2, h.1⟩
  eta_eq s := natMax_comm (cA.eta s.1) (cB.eta s.2)

/-- Right-component heterogeneous replacement (`A ⊕_K B ↝ A ⊕_K B'`): symmetric twin of
`OpenComposition.replace_left_viable`, calling `OpenComposition.compose_close_interchange` directly. -/
theorem replace_right_viable
    {S₁ S₂ S₂' Obs₁ Obs₂ Obs₂' Dist₁ Dist₂ Dist₂' Int₁ Int₂ Int₂' Ext Env : Type}
    (A : OpenComposition.OpenComponent S₁ Obs₁ Dist₁ Int₁ Ext)
    (B : OpenComposition.OpenComponent S₂ Obs₂ Dist₂ Int₂ Ext)
    (B' : OpenComposition.OpenComponent S₂' Obs₂' Dist₂' Int₂' Ext)
    {init₁ : S₁} {init₂ : S₂} {init₂' : S₂'}
    (cA : OpenComposition.InterfaceContract A init₁)
    (cB : OpenComposition.InterfaceContract B init₂)
    (cB' : OpenComposition.InterfaceContract B' init₂')
    (obs₁ : (Ext → Nat) → Obs₁)
    (obs₂ : (Ext → Nat) → Obs₂)
    (obs₂' : (Ext → Nat) → Obs₂')
    (channel : Bool → Nat → Env → Bool)
    (G : Ext → (Ext → Nat) → Nat)
    (envDraw : Env → Ext → Nat) (envCap : Ext → Nat) (jointAdm : Env → Prop)
    (env_within : ∀ env, jointAdm env → ∀ k, envDraw env k ≤ envCap k)
    (x_crit warnLevel H_safe x₀ : Ext → Nat)
    (refines : OpenComposition.ContractRefines cB cB' obs₂ obs₂' warnLevel)
    (obs_detects_orig : ∀ x k, x k < warnLevel k → cA.warnObs (obs₁ x) ∨ cB.warnObs (obs₂ x))
    (channel_fires : ∀ load env, jointAdm env → load ≤ cA.maxSilence + cB.maxSilence →
      channel true load env = true)
    (G_rises : ∀ k, RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (G k))
    (post_viable : ∀ k, x_crit k ≤
      RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole G H_safe x_crit k)
    (post_cap : ∀ k, (cA.postBudgetExt k + cB.postBudgetExt k) + envCap k ≤ H_safe k)
    (warn_margin : ∀ k, x_crit k +
      (AdaptiveLoops.natMax cA.maxLag cB.maxLag + 1) *
        ((cA.preCapExt k + cB.preCapExt k) + envCap k) ≤ warnLevel k)
    (init_margin : ∀ k, x_crit k +
      AdaptiveLoops.natMax (cA.eta init₁) (cB.eta init₂) *
        ((cA.preCapExt k + cB.preCapExt k) + envCap k) ≤ x₀ k) :
    Viability.Kernel
      (OpenComposition.closedProcess (OpenComposition.OpenComponent.compose A B')
        (OpenComposition.composeContract cA cB')
        (fun x => (obs₁ x, obs₂' x)) channel G envDraw jointAdm)
      (OpenComposition.closedGuard (OpenComposition.OpenComponent.compose A B')
        (OpenComposition.composeContract cA cB') x_crit)
      (x₀, (init₁, init₂')) := by
  refine OpenComposition.compose_close_interchange A B' cA cB' obs₁ obs₂' channel G envDraw
    envCap jointAdm env_within x_crit warnLevel H_safe x₀ ?_ ?_ G_rises post_viable ?_ ?_ ?_
  · intro x k lt
    cases obs_detects_orig x k lt with
    | inl w₁ => exact Or.inl w₁
    | inr w₂ => exact Or.inr (refines.warn_preserved x w₂ ⟨k, lt⟩)
  · intro load env adm le
    exact channel_fires load env adm (Nat.le_trans le (Nat.add_le_add_left refines.maxSilence_le _))
  · intro k
    exact Nat.le_trans
      (Nat.add_le_add_right (Nat.add_le_add_left (refines.postBudgetExt_le k) _) _)
      (post_cap k)
  · intro k
    have lagLe : AdaptiveLoops.natMax cA.maxLag cB'.maxLag + 1 ≤
        AdaptiveLoops.natMax cA.maxLag cB.maxLag + 1 :=
      Nat.succ_le_succ
        (AdaptiveLoops.natMax_le
          (AdaptiveLoops.le_natMax_left _ _)
          (Nat.le_trans refines.maxLag_le (AdaptiveLoops.le_natMax_right _ _)))
    have capLe : (cA.preCapExt k + cB'.preCapExt k) + envCap k ≤
        (cA.preCapExt k + cB.preCapExt k) + envCap k :=
      Nat.add_le_add_right (Nat.add_le_add_left (refines.preCapExt_le k) _) _
    exact Nat.le_trans (Nat.add_le_add_left (Nat.mul_le_mul lagLe capLe) _) (warn_margin k)
  · intro k
    have etaLe : AdaptiveLoops.natMax (cA.eta init₁) (cB'.eta init₂') ≤
        AdaptiveLoops.natMax (cA.eta init₁) (cB.eta init₂) :=
      AdaptiveLoops.natMax_le
        (AdaptiveLoops.le_natMax_left _ _)
        (Nat.le_trans refines.init_eta_le (AdaptiveLoops.le_natMax_right _ _))
    have capLe : (cA.preCapExt k + cB'.preCapExt k) + envCap k ≤
        (cA.preCapExt k + cB.preCapExt k) + envCap k :=
      Nat.add_le_add_right (Nat.add_le_add_left (refines.preCapExt_le k) _) _
    exact Nat.le_trans (Nat.add_le_add_left (Nat.mul_le_mul etaLe capLe) _) (init_margin k)

/-- Lift `ContractRefines` across the left slot of `composeContract`. -/
theorem contractRefines_compose_left
    {S₁ S₁' S₂ Obs₁ Obs₁' Obs₂ Dist₁ Dist₁' Dist₂ Int₁ Int₁' Int₂ Ext : Type}
    {A : OpenComposition.OpenComponent S₁ Obs₁ Dist₁ Int₁ Ext}
    {A' : OpenComposition.OpenComponent S₁' Obs₁' Dist₁' Int₁' Ext}
    {B : OpenComposition.OpenComponent S₂ Obs₂ Dist₂ Int₂ Ext}
    {init₁ : S₁} {init₁' : S₁'} {init₂ : S₂}
    {cA : OpenComposition.InterfaceContract A init₁}
    {cA' : OpenComposition.InterfaceContract A' init₁'}
    (cB : OpenComposition.InterfaceContract B init₂)
    {obs₁ : (Ext → Nat) → Obs₁} {obs₁' : (Ext → Nat) → Obs₁'}
    (obs₂ : (Ext → Nat) → Obs₂) {warnLevel : Ext → Nat}
    (ref : OpenComposition.ContractRefines cA cA' obs₁ obs₁' warnLevel) :
    OpenComposition.ContractRefines
      (OpenComposition.composeContract cA cB)
      (OpenComposition.composeContract cA' cB)
      (fun x => (obs₁ x, obs₂ x)) (fun x => (obs₁' x, obs₂ x)) warnLevel where
  preCapExt_le k := Nat.add_le_add_right (ref.preCapExt_le k) (cB.preCapExt k)
  postBudgetExt_le k := Nat.add_le_add_right (ref.postBudgetExt_le k) (cB.postBudgetExt k)
  maxSilence_le := Nat.add_le_add_right ref.maxSilence_le cB.maxSilence
  maxLag_le := AdaptiveLoops.natMax_le
    (Nat.le_trans ref.maxLag_le (AdaptiveLoops.le_natMax_left _ _))
    (AdaptiveLoops.le_natMax_right _ _)
  init_eta_le := AdaptiveLoops.natMax_le
    (Nat.le_trans ref.init_eta_le (AdaptiveLoops.le_natMax_left _ _))
    (AdaptiveLoops.le_natMax_right _ _)
  warn_preserved x hw hlt := match hw with
    | .inl w₁ => Or.inl (ref.warn_preserved x w₁ hlt)
    | .inr w₂ => Or.inr w₂

/-- Lift `ContractRefines` across the right slot of `composeContract`. -/
theorem contractRefines_compose_right
    {S₁ S₂ S₂' Obs₁ Obs₂ Obs₂' Dist₁ Dist₂ Dist₂' Int₁ Int₂ Int₂' Ext : Type}
    {A : OpenComposition.OpenComponent S₁ Obs₁ Dist₁ Int₁ Ext}
    {B : OpenComposition.OpenComponent S₂ Obs₂ Dist₂ Int₂ Ext}
    {B' : OpenComposition.OpenComponent S₂' Obs₂' Dist₂' Int₂' Ext}
    {init₁ : S₁} {init₂ : S₂} {init₂' : S₂'}
    (cA : OpenComposition.InterfaceContract A init₁)
    {cB : OpenComposition.InterfaceContract B init₂}
    {cB' : OpenComposition.InterfaceContract B' init₂'}
    (obs₁ : (Ext → Nat) → Obs₁)
    {obs₂ : (Ext → Nat) → Obs₂} {obs₂' : (Ext → Nat) → Obs₂'} {warnLevel : Ext → Nat}
    (ref : OpenComposition.ContractRefines cB cB' obs₂ obs₂' warnLevel) :
    OpenComposition.ContractRefines
      (OpenComposition.composeContract cA cB)
      (OpenComposition.composeContract cA cB')
      (fun x => (obs₁ x, obs₂ x)) (fun x => (obs₁ x, obs₂' x)) warnLevel where
  preCapExt_le k := Nat.add_le_add_left (ref.preCapExt_le k) (cA.preCapExt k)
  postBudgetExt_le k := Nat.add_le_add_left (ref.postBudgetExt_le k) (cA.postBudgetExt k)
  maxSilence_le := Nat.add_le_add_left ref.maxSilence_le cA.maxSilence
  maxLag_le := AdaptiveLoops.natMax_le
    (AdaptiveLoops.le_natMax_left _ _)
    (Nat.le_trans ref.maxLag_le (AdaptiveLoops.le_natMax_right _ _))
  init_eta_le := AdaptiveLoops.natMax_le
    (AdaptiveLoops.le_natMax_left _ _)
    (Nat.le_trans ref.init_eta_le (AdaptiveLoops.le_natMax_right _ _))
  warn_preserved x hw hlt := match hw with
    | .inl w₁ => Or.inl w₁
    | .inr w₂ => Or.inr (ref.warn_preserved x w₂ hlt)

/-! ### 1.2 Three-Pillar Composed Spine (`turningSub`, `fleetSub`, `scopeSub`, `spineComponent`) -/

/-- Pillar `L1` subsystem: uncoupled proxy composed with `ServiceTaskModel` partner. -/
def turningSub {P : Type} (M : EndogenousTurning.ServiceTaskModel P) (base hProxyPre hProxySafe : Nat) :
    OpenComposition.OpenComponent (Nat × (Bool × Nat)) (Unit × Nat) (Unit × Unit) (Sum Empty Empty) Unit :=
  OpenComposition.OpenComponent.compose
    (EndogenousTurning.OpenCompositionBridge.proxyComponent hProxyPre hProxySafe)
    (EndogenousTurning.OpenCompositionBridge.taskPartnerComponent M base)

/-- Assume-guarantee contract for `turningSub`. -/
def turningContract {P : Type} (M : EndogenousTurning.ServiceTaskModel P)
    (base hProxyPre hProxySafe lagProxy lagPartner : Nat)
    (safe_le : hProxySafe ≤ hProxyPre) (initProxy : Nat) (hInitProxy : initProxy ≤ lagProxy)
    (initPartner : Bool × Nat) (hInitPartner : EndogenousTurning.serviceK lagPartner initPartner) :
    OpenComposition.InterfaceContract (turningSub M base hProxyPre hProxySafe) (initProxy, initPartner) :=
  OpenComposition.composeContract
    (EndogenousTurning.OpenCompositionBridge.proxyContract hProxyPre hProxySafe lagProxy safe_le initProxy hInitProxy)
    (EndogenousTurning.OpenCompositionBridge.taskPartnerContract M base lagPartner initPartner hInitPartner)

/-- Observation adapter for `turningSub`. -/
def turningObs {P : Type} (M : EndogenousTurning.ServiceTaskModel P) (base : Nat)
    (x : Unit → Nat) : Unit × Nat :=
  ((), M.realizedScore M.ext (x ()) base)

/-- Pillar `L2` subsystem: `N`-ary non-empty restraint fleet fold. -/
def fleetSub (head : UnifiedDrawdown.RestraintAgentSpec)
    (tail : List UnifiedDrawdown.RestraintAgentSpec) (warnFleet : Nat) :=
  UnifiedDrawdown.OpenCompositionBridge.fleetComponent head tail warnFleet

/-- Assume-guarantee contract for `fleetSub`. -/
def fleetSubContract (head : UnifiedDrawdown.RestraintAgentSpec)
    (tail : List UnifiedDrawdown.RestraintAgentSpec) (warnFleet : Nat) :=
  UnifiedDrawdown.OpenCompositionBridge.fleetContract head tail warnFleet

/-- Observation adapter for `fleetSub`. -/
def fleetSubObs (tail : List UnifiedDrawdown.RestraintAgentSpec) (x : Unit → Nat) :=
  UnifiedDrawdown.OpenCompositionBridge.fleetObs tail x

/-- Admissibility helper for `fleetSubContract`: every disturbance tuple is admissible for all `tail`. -/
theorem fleetContract_tol (head : UnifiedDrawdown.RestraintAgentSpec) :
    ∀ (tail : List UnifiedDrawdown.RestraintAgentSpec) (warnFleet : Nat)
      (oa : UnifiedDrawdown.OpenCompositionBridge.FleetObs tail × Bool)
      (d : UnifiedDrawdown.OpenCompositionBridge.FleetDist tail),
      (fleetSubContract head tail warnFleet).tol oa d
  | [], _, _, _ => trivial
  | next :: rest, warnFleet, oa, d => ⟨trivial, fleetContract_tol next rest warnFleet (oa.1.2, oa.2) d.2⟩

/-- Uniform head refinement across all `tail` lengths (`[]` and `head2 :: rest`). -/
theorem fleetHeadRefines {head head' : UnifiedDrawdown.RestraintAgentSpec}
    (tight : UnifiedDrawdown.OpenCompositionBridge.SpecTightens head head')
    (warnFleet : Nat) (warnLevel : Unit → Nat) :
    ∀ (tail : List UnifiedDrawdown.RestraintAgentSpec),
      OpenComposition.ContractRefines
        (fleetSubContract head tail warnFleet)
        (fleetSubContract head' tail warnFleet)
        (fleetSubObs tail) (fleetSubObs tail) warnLevel
  | [] =>
    { preCapExt_le := fun _ => tight.preCap_le
      postBudgetExt_le := fun _ => tight.postCap_le
      maxSilence_le := tight.maxSilence_le
      maxLag_le := tight.lag_le
      init_eta_le := tight.lag_le
      warn_preserved := fun _ hw _ => hw }
  | head2 :: rest =>
    contractRefines_compose_left
      (UnifiedDrawdown.OpenCompositionBridge.fleetContract head2 rest warnFleet)
      (UnifiedDrawdown.OpenCompositionBridge.fleetObs rest)
      { preCapExt_le := fun _ => tight.preCap_le
        postBudgetExt_le := fun _ => tight.postCap_le
        maxSilence_le := tight.maxSilence_le
        maxLag_le := tight.lag_le
        init_eta_le := tight.lag_le
        warn_preserved := fun _ hw _ => hw }

/-- Pillar `L3` subsystem: gated defector composed with cooperator (`gatedDefector ⊕ coop`). -/
def scopeSub (H_def_pre H_def_post T_gate H_coop : Nat) :
    OpenComposition.OpenComponent (Nat × Unit) (Bool × Unit) (Unit × Unit) (Sum Empty Empty) Unit :=
  OpenComposition.OpenComponent.compose
    (ScopeDynamics.OpenCompositionBridge.gatedDefectorComponent H_def_pre H_def_post T_gate)
    (ScopeDynamics.OpenCompositionBridge.coopComponent H_coop)

/-- Assume-guarantee contract for `scopeSub`. -/
def scopeSubContract (H_def_pre H_def_post T_gate H_coop : Nat)
    (post_le_pre : H_def_post ≤ H_def_pre) :=
  OpenComposition.composeContract
    (ScopeDynamics.OpenCompositionBridge.gatedDefectorContract H_def_pre H_def_post T_gate post_le_pre)
    (ScopeDynamics.OpenCompositionBridge.coopContract H_coop)

/-- Observation adapter for `scopeSub`. -/
def scopeSubObs (warnScope : Nat) (x : Unit → Nat) : Bool × Unit :=
  (ScopeDynamics.reciprocalObs warnScope () x, ())

/-- Composed 3-pillar alignment spine `((turningSub ⊕ fleetSub) ⊕ scopeSub)` on `Ext := Unit`. -/
def spineComponent {P : Type} (M : EndogenousTurning.ServiceTaskModel P)
    (base hProxyPre hProxySafe : Nat)
    (head : UnifiedDrawdown.RestraintAgentSpec) (tail : List UnifiedDrawdown.RestraintAgentSpec) (warnFleet : Nat)
    (H_def_pre H_def_post T_gate H_coop : Nat) :=
  OpenComposition.OpenComponent.compose
    (OpenComposition.OpenComponent.compose
      (turningSub M base hProxyPre hProxySafe)
      (fleetSub head tail warnFleet))
    (scopeSub H_def_pre H_def_post T_gate H_coop)

/-- Initial state tuple for `spineComponent`. -/
def spineInit (initProxy : Nat) (initPartner : Bool × Nat)
    (head : UnifiedDrawdown.RestraintAgentSpec) (tail : List UnifiedDrawdown.RestraintAgentSpec)
    (T_gate : Nat) :=
  (((initProxy, initPartner), UnifiedDrawdown.OpenCompositionBridge.fleetInit head tail), (T_gate, ()))

/-- Composed assume-guarantee contract for `spineComponent`. -/
def spineContract {P : Type} (M : EndogenousTurning.ServiceTaskModel P)
    (base hProxyPre hProxySafe lagProxy lagPartner : Nat)
    (safe_le : hProxySafe ≤ hProxyPre) (initProxy : Nat) (hInitProxy : initProxy ≤ lagProxy)
    (initPartner : Bool × Nat) (hInitPartner : EndogenousTurning.serviceK lagPartner initPartner)
    (head : UnifiedDrawdown.RestraintAgentSpec) (tail : List UnifiedDrawdown.RestraintAgentSpec) (warnFleet : Nat)
    (H_def_pre H_def_post T_gate H_coop : Nat) (post_le_pre : H_def_post ≤ H_def_pre) :=
  OpenComposition.composeContract
    (OpenComposition.composeContract
      (turningContract M base hProxyPre hProxySafe lagProxy lagPartner safe_le initProxy hInitProxy
        initPartner hInitPartner)
      (fleetSubContract head tail warnFleet))
    (scopeSubContract H_def_pre H_def_post T_gate H_coop post_le_pre)

/-- Composed observation map for `spineComponent`. -/
def spineObs {P : Type} (M : EndogenousTurning.ServiceTaskModel P) (base : Nat)
    (tail : List UnifiedDrawdown.RestraintAgentSpec) (warnScope : Nat) (x : Unit → Nat) :=
  ((turningObs M base x, fleetSubObs tail x), scopeSubObs warnScope x)

/-- Total pre-turn draw cap across the three pillars plus `envCap ()`. -/
def spinePreTotal {P : Type} (M : EndogenousTurning.ServiceTaskModel P) (hProxyPre : Nat)
    (head : UnifiedDrawdown.RestraintAgentSpec) (tail : List UnifiedDrawdown.RestraintAgentSpec)
    (H_def_pre H_coop : Nat) (envCap : Unit → Nat) : Nat :=
  (hProxyPre + AdaptiveLoops.natMax (M.draw M.ext) (M.draw M.safe)) +
    UnifiedDrawdown.OpenCompositionBridge.specSum (fun s => s.preCap) head tail +
    (H_def_pre + H_coop) + envCap ()

/-- Total post-turn draw cap across the three pillars plus `envCap ()`. -/
def spinePostTotal {P : Type} (M : EndogenousTurning.ServiceTaskModel P) (hProxySafe : Nat)
    (head : UnifiedDrawdown.RestraintAgentSpec) (tail : List UnifiedDrawdown.RestraintAgentSpec)
    (H_def_post H_coop : Nat) (envCap : Unit → Nat) : Nat :=
  (hProxySafe + M.draw M.safe) +
    UnifiedDrawdown.OpenCompositionBridge.specSum (fun s => s.postCap) head tail +
    (H_def_post + H_coop) + envCap ()

/-- Combined worst-case lag across the three pillars. -/
def spineMaxLag (lagProxy lagPartner : Nat)
    (head : UnifiedDrawdown.RestraintAgentSpec) (tail : List UnifiedDrawdown.RestraintAgentSpec)
    (T_gate : Nat) : Nat :=
  AdaptiveLoops.natMax
    (AdaptiveLoops.natMax (AdaptiveLoops.natMax lagProxy lagPartner)
      (UnifiedDrawdown.OpenCompositionBridge.specMax (fun s => s.lag) head tail))
    (AdaptiveLoops.natMax T_gate 0)

/-- Combined initial countdown `eta` across the three pillars. -/
def spineInitEta (initProxy : Nat) (initPartner : Bool × Nat)
    (head : UnifiedDrawdown.RestraintAgentSpec) (tail : List UnifiedDrawdown.RestraintAgentSpec)
    (T_gate : Nat) : Nat :=
  AdaptiveLoops.natMax
    (AdaptiveLoops.natMax (AdaptiveLoops.natMax initProxy initPartner.2)
      (UnifiedDrawdown.OpenCompositionBridge.specMax (fun s => s.lag) head tail))
    (AdaptiveLoops.natMax T_gate 0)

/-- Combined silencing load allowance across the three pillars (`L1` and `L3` have `0`). -/
def spineSilence (head : UnifiedDrawdown.RestraintAgentSpec)
    (tail : List UnifiedDrawdown.RestraintAgentSpec) : Nat :=
  UnifiedDrawdown.OpenCompositionBridge.specSum (fun s => s.maxSilence) head tail

theorem spine_preCap_eq {P : Type} (M : EndogenousTurning.ServiceTaskModel P)
    (base hProxyPre hProxySafe lagProxy lagPartner : Nat)
    (safe_le : hProxySafe ≤ hProxyPre) (initProxy : Nat) (hInitProxy : initProxy ≤ lagProxy)
    (initPartner : Bool × Nat) (hInitPartner : EndogenousTurning.serviceK lagPartner initPartner)
    (head : UnifiedDrawdown.RestraintAgentSpec) (tail : List UnifiedDrawdown.RestraintAgentSpec) (warnFleet : Nat)
    (H_def_pre H_def_post T_gate H_coop : Nat) (post_le_pre : H_def_post ≤ H_def_pre) :
    (spineContract M base hProxyPre hProxySafe lagProxy lagPartner safe_le initProxy hInitProxy
      initPartner hInitPartner head tail warnFleet H_def_pre H_def_post T_gate H_coop post_le_pre).preCapExt () =
      (hProxyPre + AdaptiveLoops.natMax (M.draw M.ext) (M.draw M.safe)) +
        UnifiedDrawdown.OpenCompositionBridge.specSum (fun s => s.preCap) head tail +
        (H_def_pre + H_coop) := by
  show ((hProxyPre + AdaptiveLoops.natMax (M.draw M.ext) (M.draw M.safe)) +
      (fleetSubContract head tail warnFleet).preCapExt ()) + (H_def_pre + H_coop) = _
  dsimp only [fleetSubContract]
  rw [UnifiedDrawdown.OpenCompositionBridge.fleet_preCapExt_eq_sum tail head warnFleet]

theorem spine_postCap_eq {P : Type} (M : EndogenousTurning.ServiceTaskModel P)
    (base hProxyPre hProxySafe lagProxy lagPartner : Nat)
    (safe_le : hProxySafe ≤ hProxyPre) (initProxy : Nat) (hInitProxy : initProxy ≤ lagProxy)
    (initPartner : Bool × Nat) (hInitPartner : EndogenousTurning.serviceK lagPartner initPartner)
    (head : UnifiedDrawdown.RestraintAgentSpec) (tail : List UnifiedDrawdown.RestraintAgentSpec) (warnFleet : Nat)
    (H_def_pre H_def_post T_gate H_coop : Nat) (post_le_pre : H_def_post ≤ H_def_pre) :
    (spineContract M base hProxyPre hProxySafe lagProxy lagPartner safe_le initProxy hInitProxy
      initPartner hInitPartner head tail warnFleet H_def_pre H_def_post T_gate H_coop post_le_pre).postBudgetExt () =
      (hProxySafe + M.draw M.safe) +
        UnifiedDrawdown.OpenCompositionBridge.specSum (fun s => s.postCap) head tail +
        (H_def_post + H_coop) := by
  show ((hProxySafe + M.draw M.safe) +
      (fleetSubContract head tail warnFleet).postBudgetExt ()) + (H_def_post + H_coop) = _
  dsimp only [fleetSubContract]
  rw [UnifiedDrawdown.OpenCompositionBridge.fleet_postCapExt_eq_sum tail head warnFleet]

theorem spine_silence_eq {P : Type} (M : EndogenousTurning.ServiceTaskModel P)
    (base hProxyPre hProxySafe lagProxy lagPartner : Nat)
    (safe_le : hProxySafe ≤ hProxyPre) (initProxy : Nat) (hInitProxy : initProxy ≤ lagProxy)
    (initPartner : Bool × Nat) (hInitPartner : EndogenousTurning.serviceK lagPartner initPartner)
    (head : UnifiedDrawdown.RestraintAgentSpec) (tail : List UnifiedDrawdown.RestraintAgentSpec) (warnFleet : Nat)
    (H_def_pre H_def_post T_gate H_coop : Nat) (post_le_pre : H_def_post ≤ H_def_pre) :
    (spineContract M base hProxyPre hProxySafe lagProxy lagPartner safe_le initProxy hInitProxy
      initPartner hInitPartner head tail warnFleet H_def_pre H_def_post T_gate H_coop post_le_pre).maxSilence =
      spineSilence head tail := by
  show ((0 + 0) + (fleetSubContract head tail warnFleet).maxSilence) + (0 + 0) =
    spineSilence head tail
  dsimp only [fleetSubContract]
  rw [Nat.zero_add, Nat.add_zero, UnifiedDrawdown.OpenCompositionBridge.fleet_maxSilence_eq_sum tail head warnFleet]
  rfl

theorem spine_maxLag_eq {P : Type} (M : EndogenousTurning.ServiceTaskModel P)
    (base hProxyPre hProxySafe lagProxy lagPartner : Nat)
    (safe_le : hProxySafe ≤ hProxyPre) (initProxy : Nat) (hInitProxy : initProxy ≤ lagProxy)
    (initPartner : Bool × Nat) (hInitPartner : EndogenousTurning.serviceK lagPartner initPartner)
    (head : UnifiedDrawdown.RestraintAgentSpec) (tail : List UnifiedDrawdown.RestraintAgentSpec) (warnFleet : Nat)
    (H_def_pre H_def_post T_gate H_coop : Nat) (post_le_pre : H_def_post ≤ H_def_pre) :
    (spineContract M base hProxyPre hProxySafe lagProxy lagPartner safe_le initProxy hInitProxy
      initPartner hInitPartner head tail warnFleet H_def_pre H_def_post T_gate H_coop post_le_pre).maxLag =
      spineMaxLag lagProxy lagPartner head tail T_gate := by
  show AdaptiveLoops.natMax
      (AdaptiveLoops.natMax (AdaptiveLoops.natMax lagProxy lagPartner)
        (fleetSubContract head tail warnFleet).maxLag)
      (AdaptiveLoops.natMax T_gate 0) = _
  dsimp only [fleetSubContract]
  rw [UnifiedDrawdown.OpenCompositionBridge.fleet_maxLag_eq_max tail head warnFleet]
  rfl

theorem spine_eta_eq {P : Type} (M : EndogenousTurning.ServiceTaskModel P)
    (base hProxyPre hProxySafe lagProxy lagPartner : Nat)
    (safe_le : hProxySafe ≤ hProxyPre) (initProxy : Nat) (hInitProxy : initProxy ≤ lagProxy)
    (initPartner : Bool × Nat) (hInitPartner : EndogenousTurning.serviceK lagPartner initPartner)
    (head : UnifiedDrawdown.RestraintAgentSpec) (tail : List UnifiedDrawdown.RestraintAgentSpec) (warnFleet : Nat)
    (H_def_pre H_def_post T_gate H_coop : Nat) (post_le_pre : H_def_post ≤ H_def_pre) :
    (spineContract M base hProxyPre hProxySafe lagProxy lagPartner safe_le initProxy hInitProxy
      initPartner hInitPartner head tail warnFleet H_def_pre H_def_post T_gate H_coop post_le_pre).eta
        (spineInit initProxy initPartner head tail T_gate) =
      spineInitEta initProxy initPartner head tail T_gate := by
  show AdaptiveLoops.natMax
      (AdaptiveLoops.natMax (AdaptiveLoops.natMax initProxy initPartner.2)
        ((fleetSubContract head tail warnFleet).eta
          (UnifiedDrawdown.OpenCompositionBridge.fleetInit head tail)))
      (AdaptiveLoops.natMax T_gate 0) = _
  dsimp only [fleetSubContract]
  rw [UnifiedDrawdown.OpenCompositionBridge.fleet_eta_eq_max tail head warnFleet]
  rfl

theorem spine_obs_detects {P : Type} (M : EndogenousTurning.ServiceTaskModel P)
    (base : Nat) (hBase : M.upkeep M.ext ≤ base)
    (hProxyPre hProxySafe lagProxy lagPartner : Nat)
    (safe_le : hProxySafe ≤ hProxyPre) (initProxy : Nat) (hInitProxy : initProxy ≤ lagProxy)
    (initPartner : Bool × Nat) (hInitPartner : EndogenousTurning.serviceK lagPartner initPartner)
    (head : UnifiedDrawdown.RestraintAgentSpec) (tail : List UnifiedDrawdown.RestraintAgentSpec) (warnFleet : Nat)
    (H_def_pre H_def_post T_gate H_coop : Nat) (post_le_pre : H_def_post ≤ H_def_pre)
    (warnScope warnLevel : Nat)
    (warnMonitor : warnLevel ≤ M.B_task ∨ warnLevel ≤ warnFleet ∨ warnLevel ≤ warnScope) :
    ∀ x (k : Unit), x k < warnLevel →
      (spineContract M base hProxyPre hProxySafe lagProxy lagPartner safe_le initProxy hInitProxy
        initPartner hInitPartner head tail warnFleet H_def_pre H_def_post T_gate H_coop post_le_pre).warnObs
        (spineObs M base tail warnScope x) := by
  intro x k lt
  cases k
  cases warnMonitor with
  | inl hTask =>
    exact Or.inl (Or.inl (Or.inr
      (((M.score_crosses_iff (x ()) base).2 hBase).mpr (Nat.lt_of_lt_of_le lt hTask))))
  | inr rest =>
    cases rest with
    | inl hFleet =>
      exact Or.inl (Or.inr
        (UnifiedDrawdown.OpenCompositionBridge.fleet_warnObs_of_lt tail (Nat.lt_of_lt_of_le lt hFleet)))
    | inr hScope =>
      exact Or.inr (Or.inl (AdaptiveLoops.natBlt_true_iff.mpr (Nat.lt_of_lt_of_le lt hScope)))

/-! ### 1.3 Core Composed Spine Theorems -/

/-- **Theorem 1.1 (`master_alignment_spine_viable`)**: End-to-end closed substrate viability
(`Viability.Kernel` of `closedProcess`) for the three-pillar open composition
`((turningSub ⊕ fleetSub) ⊕ scopeSub)` whenever at least one pillar's warning channel covers
`warnLevel`, the shared communication channel fires up to summed silence load, and post/warn/init
buffers cover the combined system. -/
theorem master_alignment_spine_viable {P Env : Type}
    (M : EndogenousTurning.ServiceTaskModel P) (base : Nat) (hBase : M.upkeep M.ext ≤ base)
    (hProxyPre hProxySafe lagProxy lagPartner : Nat) (safe_le : hProxySafe ≤ hProxyPre)
    (initProxy : Nat) (hInitProxy : initProxy ≤ lagProxy)
    (initPartner : Bool × Nat) (hInitPartner : EndogenousTurning.serviceK lagPartner initPartner)
    (head : UnifiedDrawdown.RestraintAgentSpec) (tail : List UnifiedDrawdown.RestraintAgentSpec)
    (warnFleet : Nat)
    (H_def_pre H_def_post T_gate H_coop : Nat) (post_le_pre : H_def_post ≤ H_def_pre)
    (warnScope : Nat)
    (channel : Bool → Nat → Env → Bool)
    (G : Unit → (Unit → Nat) → Nat)
    (envDraw : Env → Unit → Nat) (envCap : Unit → Nat) (jointAdm : Env → Prop)
    (env_within : ∀ env, jointAdm env → ∀ k, envDraw env k ≤ envCap k)
    (x_crit H_safe x₀ : Unit → Nat) (warnLevel : Nat)
    (warnMonitor : warnLevel ≤ M.B_task ∨ warnLevel ≤ warnFleet ∨ warnLevel ≤ warnScope)
    (channel_fires : ∀ load env, jointAdm env → load ≤ spineSilence head tail →
      channel true load env = true)
    (G_rises : ∀ k, RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (G k))
    (post_viable : ∀ k, x_crit k ≤
      RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole G H_safe x_crit k)
    (post_cap : spinePostTotal M hProxySafe head tail H_def_post H_coop envCap ≤ H_safe ())
    (warn_margin : x_crit () +
      (spineMaxLag lagProxy lagPartner head tail T_gate + 1) *
        spinePreTotal M hProxyPre head tail H_def_pre H_coop envCap ≤ warnLevel)
    (init_margin : x_crit () +
      spineInitEta initProxy initPartner head tail T_gate *
        spinePreTotal M hProxyPre head tail H_def_pre H_coop envCap ≤ x₀ ()) :
    Viability.Kernel
      (OpenComposition.closedProcess
        (spineComponent M base hProxyPre hProxySafe head tail warnFleet H_def_pre H_def_post T_gate H_coop)
        (spineContract M base hProxyPre hProxySafe lagProxy lagPartner safe_le initProxy hInitProxy
          initPartner hInitPartner head tail warnFleet H_def_pre H_def_post T_gate H_coop post_le_pre)
        (spineObs M base tail warnScope) channel G envDraw jointAdm)
      (OpenComposition.closedGuard
        (spineComponent M base hProxyPre hProxySafe head tail warnFleet H_def_pre H_def_post T_gate H_coop)
        (spineContract M base hProxyPre hProxySafe lagProxy lagPartner safe_le initProxy hInitProxy
          initPartner hInitPartner head tail warnFleet H_def_pre H_def_post T_gate H_coop post_le_pre)
        x_crit)
      (x₀, spineInit initProxy initPartner head tail T_gate) := by
  refine OpenComposition.close_contract_kernel
    (spineComponent M base hProxyPre hProxySafe head tail warnFleet H_def_pre H_def_post T_gate H_coop)
    (spineContract M base hProxyPre hProxySafe lagProxy lagPartner safe_le initProxy hInitProxy
      initPartner hInitPartner head tail warnFleet H_def_pre H_def_post T_gate H_coop post_le_pre)
    (spineObs M base tail warnScope) channel G envDraw envCap jointAdm env_within
    x_crit (fun _ => warnLevel) H_safe x₀
    (spine_obs_detects M base hBase hProxyPre hProxySafe lagProxy lagPartner safe_le initProxy hInitProxy
      initPartner hInitPartner head tail warnFleet H_def_pre H_def_post T_gate H_coop post_le_pre
      warnScope warnLevel warnMonitor)
    (fun load env adm hLoad => by
      rw [spine_silence_eq] at hLoad
      exact channel_fires load env adm hLoad)
    G_rises post_viable
    (fun k => by
      cases k
      rw [spine_postCap_eq]
      exact post_cap)
    (fun k => by
      cases k
      rw [spine_maxLag_eq, spine_preCap_eq]
      exact warn_margin)
    (fun k => by
      cases k
      change x_crit () + (spineContract M base hProxyPre hProxySafe lagProxy lagPartner safe_le initProxy hInitProxy
        initPartner hInitPartner head tail warnFleet H_def_pre H_def_post T_gate H_coop post_le_pre).eta
          (spineInit initProxy initPartner head tail T_gate) *
        ((spineContract M base hProxyPre hProxySafe lagProxy lagPartner safe_le initProxy hInitProxy
          initPartner hInitPartner head tail warnFleet H_def_pre H_def_post T_gate H_coop post_le_pre).preCapExt () +
          envCap ()) ≤ x₀ ()
      rw [spine_eta_eq, spine_preCap_eq]
      exact init_margin)

/-- **Theorem 1.2 (`master_spine_assoc_equiv`)**: Constructive structural associativity between
`((turningSub ⊕ fleetSub) ⊕ scopeSub)` and `(turningSub ⊕ (fleetSub ⊕ scopeSub))` (`0` axioms). -/
def master_spine_assoc_equiv {P : Type} (M : EndogenousTurning.ServiceTaskModel P)
    (base hProxyPre hProxySafe : Nat)
    (head : UnifiedDrawdown.RestraintAgentSpec) (tail : List UnifiedDrawdown.RestraintAgentSpec)
    (warnFleet H_def_pre H_def_post T_gate H_coop : Nat) :
    OpenComposition.ComponentEquiv
      (spineComponent M base hProxyPre hProxySafe head tail warnFleet H_def_pre H_def_post T_gate H_coop)
      (OpenComposition.OpenComponent.compose
        (turningSub M base hProxyPre hProxySafe)
        (OpenComposition.OpenComponent.compose
          (fleetSub head tail warnFleet)
          (scopeSub H_def_pre H_def_post T_gate H_coop))) :=
  OpenComposition.composeAssocEquiv
    (turningSub M base hProxyPre hProxySafe)
    (fleetSub head tail warnFleet)
    (scopeSub H_def_pre H_def_post T_gate H_coop)

/-- **Theorem 1.3 (`master_spine_upgrade_turning_viable`)**: Heterogeneous replacement of `turningSub`
by any `T'` (`S_T', Obs_T', Dist_T', Int_T'`) refining `turningContract` via `ContractRefines`. -/
theorem master_spine_upgrade_turning_viable
    {P S_T' Obs_T' Dist_T' Int_T' Env : Type}
    (M : EndogenousTurning.ServiceTaskModel P) (base : Nat) (hBase : M.upkeep M.ext ≤ base)
    (hProxyPre hProxySafe lagProxy lagPartner : Nat) (safe_le : hProxySafe ≤ hProxyPre)
    (initProxy : Nat) (hInitProxy : initProxy ≤ lagProxy)
    (initPartner : Bool × Nat) (hInitPartner : EndogenousTurning.serviceK lagPartner initPartner)
    (head : UnifiedDrawdown.RestraintAgentSpec) (tail : List UnifiedDrawdown.RestraintAgentSpec)
    (warnFleet : Nat)
    (H_def_pre H_def_post T_gate H_coop : Nat) (post_le_pre : H_def_post ≤ H_def_pre)
    (warnScope : Nat)
    (T' : OpenComposition.OpenComponent S_T' Obs_T' Dist_T' Int_T' Unit)
    {initT' : S_T'} (cT' : OpenComposition.InterfaceContract T' initT')
    (obsT' : (Unit → Nat) → Obs_T')
    (channel : Bool → Nat → Env → Bool)
    (G : Unit → (Unit → Nat) → Nat)
    (envDraw : Env → Unit → Nat) (envCap : Unit → Nat) (jointAdm : Env → Prop)
    (env_within : ∀ env, jointAdm env → ∀ k, envDraw env k ≤ envCap k)
    (x_crit H_safe x₀ : Unit → Nat) (warnLevel : Nat)
    (refT : OpenComposition.ContractRefines
      (turningContract M base hProxyPre hProxySafe lagProxy lagPartner safe_le initProxy hInitProxy
        initPartner hInitPartner)
      cT' (turningObs M base) obsT' (fun _ => warnLevel))
    (warnMonitor : warnLevel ≤ M.B_task ∨ warnLevel ≤ warnFleet ∨ warnLevel ≤ warnScope)
    (channel_fires : ∀ load env, jointAdm env → load ≤ spineSilence head tail →
      channel true load env = true)
    (G_rises : ∀ k, RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (G k))
    (post_viable : ∀ k, x_crit k ≤
      RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole G H_safe x_crit k)
    (post_cap : spinePostTotal M hProxySafe head tail H_def_post H_coop envCap ≤ H_safe ())
    (warn_margin : x_crit () +
      (spineMaxLag lagProxy lagPartner head tail T_gate + 1) *
        spinePreTotal M hProxyPre head tail H_def_pre H_coop envCap ≤ warnLevel)
    (init_margin : x_crit () +
      spineInitEta initProxy initPartner head tail T_gate *
        spinePreTotal M hProxyPre head tail H_def_pre H_coop envCap ≤ x₀ ()) :
    Viability.Kernel
      (OpenComposition.closedProcess
        (OpenComposition.OpenComponent.compose
          (OpenComposition.OpenComponent.compose T' (fleetSub head tail warnFleet))
          (scopeSub H_def_pre H_def_post T_gate H_coop))
        (OpenComposition.composeContract
          (OpenComposition.composeContract cT' (fleetSubContract head tail warnFleet))
          (scopeSubContract H_def_pre H_def_post T_gate H_coop post_le_pre))
        (fun x => ((obsT' x, fleetSubObs tail x), scopeSubObs warnScope x))
        channel G envDraw jointAdm)
      (OpenComposition.closedGuard
        (OpenComposition.OpenComponent.compose
          (OpenComposition.OpenComponent.compose T' (fleetSub head tail warnFleet))
          (scopeSub H_def_pre H_def_post T_gate H_coop))
        (OpenComposition.composeContract
          (OpenComposition.composeContract cT' (fleetSubContract head tail warnFleet))
          (scopeSubContract H_def_pre H_def_post T_gate H_coop post_le_pre))
        x_crit)
      (x₀, ((initT', UnifiedDrawdown.OpenCompositionBridge.fleetInit head tail), (T_gate, ()))) := by
  refine OpenComposition.replace_left_viable
    (OpenComposition.OpenComponent.compose (turningSub M base hProxyPre hProxySafe) (fleetSub head tail warnFleet))
    (OpenComposition.OpenComponent.compose T' (fleetSub head tail warnFleet))
    (scopeSub H_def_pre H_def_post T_gate H_coop)
    (OpenComposition.composeContract
      (turningContract M base hProxyPre hProxySafe lagProxy lagPartner safe_le initProxy hInitProxy
        initPartner hInitPartner)
      (fleetSubContract head tail warnFleet))
    (OpenComposition.composeContract cT' (fleetSubContract head tail warnFleet))
    (scopeSubContract H_def_pre H_def_post T_gate H_coop post_le_pre)
    (fun x => (turningObs M base x, fleetSubObs tail x))
    (fun x => (obsT' x, fleetSubObs tail x))
    (scopeSubObs warnScope)
    channel G envDraw envCap jointAdm env_within x_crit (fun _ => warnLevel) H_safe x₀
    (contractRefines_compose_left (fleetSubContract head tail warnFleet) (fleetSubObs tail) refT)
    (spine_obs_detects M base hBase hProxyPre hProxySafe lagProxy lagPartner safe_le initProxy hInitProxy
      initPartner hInitPartner head tail warnFleet H_def_pre H_def_post T_gate H_coop post_le_pre
      warnScope warnLevel warnMonitor)
    (fun load env adm hLoad => by
      have hEq : (OpenComposition.composeContract
          (turningContract M base hProxyPre hProxySafe lagProxy lagPartner safe_le initProxy hInitProxy
            initPartner hInitPartner)
          (fleetSubContract head tail warnFleet)).maxSilence +
          (scopeSubContract H_def_pre H_def_post T_gate H_coop post_le_pre).maxSilence =
          spineSilence head tail :=
        spine_silence_eq M base hProxyPre hProxySafe lagProxy lagPartner safe_le initProxy hInitProxy
          initPartner hInitPartner head tail warnFleet H_def_pre H_def_post T_gate H_coop post_le_pre
      exact channel_fires load env adm (hEq ▸ hLoad))
    G_rises post_viable
    (fun k => by
      cases k
      change (spineContract M base hProxyPre hProxySafe lagProxy lagPartner safe_le initProxy hInitProxy
        initPartner hInitPartner head tail warnFleet H_def_pre H_def_post T_gate H_coop post_le_pre).postBudgetExt () +
        envCap () ≤ H_safe ()
      rw [spine_postCap_eq]
      exact post_cap)
    (fun k => by
      cases k
      change x_crit () + ((spineContract M base hProxyPre hProxySafe lagProxy lagPartner safe_le initProxy hInitProxy
        initPartner hInitPartner head tail warnFleet H_def_pre H_def_post T_gate H_coop post_le_pre).maxLag + 1) *
        ((spineContract M base hProxyPre hProxySafe lagProxy lagPartner safe_le initProxy hInitProxy
          initPartner hInitPartner head tail warnFleet H_def_pre H_def_post T_gate H_coop post_le_pre).preCapExt () +
          envCap ()) ≤ warnLevel
      rw [spine_maxLag_eq, spine_preCap_eq]
      exact warn_margin)
    (fun k => by
      cases k
      change x_crit () + (spineContract M base hProxyPre hProxySafe lagProxy lagPartner safe_le initProxy hInitProxy
        initPartner hInitPartner head tail warnFleet H_def_pre H_def_post T_gate H_coop post_le_pre).eta
          (spineInit initProxy initPartner head tail T_gate) *
        ((spineContract M base hProxyPre hProxySafe lagProxy lagPartner safe_le initProxy hInitProxy
          initPartner hInitPartner head tail warnFleet H_def_pre H_def_post T_gate H_coop post_le_pre).preCapExt () +
          envCap ()) ≤ x₀ ()
      rw [spine_eta_eq, spine_preCap_eq]
      exact init_margin)

/-- **Theorem 1.4 (`master_spine_live_reconfig_viable`)**: Live mid-run structural rewrite
`spineComponent ↝ ((T' ⊕ fleetSub) ⊕ scopeSub)` inside `OpenComposition.ReconfigProcess` using
`(cap_le, post_le, sil_le, lag_le, obsT'_detects)` directly via `OpenComposition.rewrite_step_viable`. -/
theorem master_spine_live_reconfig_viable
    {P S_T' Obs_T' Dist_T' Int_T' Env : Type}
    (M : EndogenousTurning.ServiceTaskModel P) (base : Nat) (hBase : M.upkeep M.ext ≤ base)
    (hProxyPre hProxySafe lagProxy lagPartner : Nat) (safe_le : hProxySafe ≤ hProxyPre)
    (initProxy : Nat) (hInitProxy : initProxy ≤ lagProxy)
    (initPartner : Bool × Nat) (hInitPartner : EndogenousTurning.serviceK lagPartner initPartner)
    (head : UnifiedDrawdown.RestraintAgentSpec) (tail : List UnifiedDrawdown.RestraintAgentSpec)
    (warnFleet : Nat)
    (H_def_pre H_def_post T_gate H_coop : Nat) (post_le_pre : H_def_post ≤ H_def_pre)
    (warnScope : Nat)
    (T' : OpenComposition.OpenComponent S_T' Obs_T' Dist_T' Int_T' Unit)
    {initT' : S_T'} (cT' : OpenComposition.InterfaceContract T' initT')
    (obsT' : (Unit → Nat) → Obs_T')
    (channel : Bool → Nat → Env → Bool)
    (G : Unit → (Unit → Nat) → Nat)
    (envDraw : Env → Unit → Nat) (envCap : Unit → Nat) (jointAdm : Env → Prop)
    (env_within : ∀ env, jointAdm env → ∀ k, envDraw env k ≤ envCap k)
    (x_crit H_safe x₀ : Unit → Nat) (warnLevel : Nat)
    (cap_le : cT'.preCapExt () ≤ hProxyPre + AdaptiveLoops.natMax (M.draw M.ext) (M.draw M.safe))
    (post_le : cT'.postBudgetExt () ≤ hProxySafe + M.draw M.safe)
    (sil_le : cT'.maxSilence ≤ 0)
    (lag_le : cT'.maxLag ≤ AdaptiveLoops.natMax lagProxy lagPartner)
    (obsT'_detects : ∀ x, x () < warnLevel → cT'.warnObs (obsT' x))
    (warnMonitor : warnLevel ≤ M.B_task ∨ warnLevel ≤ warnFleet ∨ warnLevel ≤ warnScope)
    (channel_fires : ∀ load env, jointAdm env → load ≤ spineSilence head tail →
      channel true load env = true)
    (G_rises : ∀ k, RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (G k))
    (post_viable : ∀ k, x_crit k ≤
      RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole G H_safe x_crit k)
    (post_cap : spinePostTotal M hProxySafe head tail H_def_post H_coop envCap ≤ H_safe ())
    (warn_margin : x_crit () +
      (spineMaxLag lagProxy lagPartner head tail T_gate + 1) *
        spinePreTotal M hProxyPre head tail H_def_pre H_coop envCap ≤ warnLevel)
    (init_margin : x_crit () +
      spineInitEta initProxy initPartner head tail T_gate *
        spinePreTotal M hProxyPre head tail H_def_pre H_coop envCap ≤ x₀ ()) :
    Viability.Kernel
      (OpenComposition.ReconfigProcess
        (spineComponent M base hProxyPre hProxySafe head tail warnFleet H_def_pre H_def_post T_gate H_coop)
        (OpenComposition.OpenComponent.compose
          (OpenComposition.OpenComponent.compose T' (fleetSub head tail warnFleet))
          (scopeSub H_def_pre H_def_post T_gate H_coop))
        (spineContract M base hProxyPre hProxySafe lagProxy lagPartner safe_le initProxy hInitProxy
          initPartner hInitPartner head tail warnFleet H_def_pre H_def_post T_gate H_coop post_le_pre)
        (OpenComposition.composeContract
          (OpenComposition.composeContract cT' (fleetSubContract head tail warnFleet))
          (scopeSubContract H_def_pre H_def_post T_gate H_coop post_le_pre))
        (spineObs M base tail warnScope)
        (fun x => ((obsT' x, fleetSubObs tail x), scopeSubObs warnScope x))
        channel G envDraw jointAdm)
      (fun st => match st with
        | .inl st₁ => OpenComposition.closedGuard
            (spineComponent M base hProxyPre hProxySafe head tail warnFleet H_def_pre H_def_post T_gate H_coop)
            (spineContract M base hProxyPre hProxySafe lagProxy lagPartner safe_le initProxy hInitProxy
              initPartner hInitPartner head tail warnFleet H_def_pre H_def_post T_gate H_coop post_le_pre)
            x_crit st₁
        | .inr st₂ => OpenComposition.closedGuard
            (OpenComposition.OpenComponent.compose
              (OpenComposition.OpenComponent.compose T' (fleetSub head tail warnFleet))
              (scopeSub H_def_pre H_def_post T_gate H_coop))
            (OpenComposition.composeContract
              (OpenComposition.composeContract cT' (fleetSubContract head tail warnFleet))
              (scopeSubContract H_def_pre H_def_post T_gate H_coop post_le_pre))
            x_crit st₂)
      (.inl (x₀, spineInit initProxy initPartner head tail T_gate)) := by
  have kern := OpenComposition.rewrite_step_viable
    (spineComponent M base hProxyPre hProxySafe head tail warnFleet H_def_pre H_def_post T_gate H_coop)
    (OpenComposition.OpenComponent.compose
      (OpenComposition.OpenComponent.compose T' (fleetSub head tail warnFleet))
      (scopeSub H_def_pre H_def_post T_gate H_coop))
    (spineContract M base hProxyPre hProxySafe lagProxy lagPartner safe_le initProxy hInitProxy
      initPartner hInitPartner head tail warnFleet H_def_pre H_def_post T_gate H_coop post_le_pre)
    (OpenComposition.composeContract
      (OpenComposition.composeContract cT' (fleetSubContract head tail warnFleet))
      (scopeSubContract H_def_pre H_def_post T_gate H_coop post_le_pre))
    (spineObs M base tail warnScope)
    (fun x => ((obsT' x, fleetSubObs tail x), scopeSubObs warnScope x))
    channel G envDraw envCap jointAdm env_within x_crit (fun _ => warnLevel) H_safe x₀
    (fun k => by
      cases k
      exact Nat.add_le_add_right (Nat.add_le_add_right cap_le _) _)
    (fun k => by
      cases k
      exact Nat.add_le_add_right (Nat.add_le_add_right post_le _) _)
    (Nat.add_le_add_right (Nat.add_le_add_right sil_le _) _)
    (by
      change AdaptiveLoops.natMax
          (AdaptiveLoops.natMax cT'.maxLag (fleetSubContract head tail warnFleet).maxLag)
          (AdaptiveLoops.natMax T_gate 0) ≤
        AdaptiveLoops.natMax
          (AdaptiveLoops.natMax (AdaptiveLoops.natMax lagProxy lagPartner)
            (fleetSubContract head tail warnFleet).maxLag)
          (AdaptiveLoops.natMax T_gate 0)
      exact AdaptiveLoops.natMax_le
        (AdaptiveLoops.natMax_le
          (Nat.le_trans lag_le
            (Nat.le_trans (AdaptiveLoops.le_natMax_left _ _) (AdaptiveLoops.le_natMax_left _ _)))
          (Nat.le_trans (AdaptiveLoops.le_natMax_right _ _) (AdaptiveLoops.le_natMax_left _ _)))
        (AdaptiveLoops.le_natMax_right _ _))
    (spine_obs_detects M base hBase hProxyPre hProxySafe lagProxy lagPartner safe_le initProxy hInitProxy
      initPartner hInitPartner head tail warnFleet H_def_pre H_def_post T_gate H_coop post_le_pre
      warnScope warnLevel warnMonitor)
    (fun x k lt => by cases k; exact Or.inl (Or.inl (obsT'_detects x lt)))
    (fun load env adm hLoad => by
      rw [spine_silence_eq] at hLoad
      exact channel_fires load env adm hLoad)
    G_rises post_viable
    (fun k => by
      cases k
      rw [spine_postCap_eq]
      exact post_cap)
    (fun k => by
      cases k
      rw [spine_maxLag_eq, spine_preCap_eq]
      exact warn_margin)
    (fun k => by
      cases k
      change x_crit () + (spineContract M base hProxyPre hProxySafe lagProxy lagPartner safe_le initProxy hInitProxy
        initPartner hInitPartner head tail warnFleet H_def_pre H_def_post T_gate H_coop post_le_pre).eta
          (spineInit initProxy initPartner head tail T_gate) *
        ((spineContract M base hProxyPre hProxySafe lagProxy lagPartner safe_le initProxy hInitProxy
          initPartner hInitPartner head tail warnFleet H_def_pre H_def_post T_gate H_coop post_le_pre).preCapExt () +
          envCap ()) ≤ x₀ ()
      rw [spine_eta_eq, spine_preCap_eq]
      exact init_margin)
  intro st hReach
  have hSt := kern st hReach
  cases st with
  | inl st₁ => exact hSt
  | inr st₂ => exact hSt

/-- **Theorem 1.5 (`master_spine_upgrade_fleet_viable`)**: Upgrades the head agent `head` inside
`fleetSub head tail warnFleet` to `head'` via `SpecTightens head head'` across arbitrary `tail`
(`[]` or `head2 :: rest`) with zero duplicated `close_contract_viable`. -/
theorem master_spine_upgrade_fleet_viable {P Env : Type}
    (M : EndogenousTurning.ServiceTaskModel P) (base : Nat) (hBase : M.upkeep M.ext ≤ base)
    (hProxyPre hProxySafe lagProxy lagPartner : Nat) (safe_le : hProxySafe ≤ hProxyPre)
    (initProxy : Nat) (hInitProxy : initProxy ≤ lagProxy)
    (initPartner : Bool × Nat) (hInitPartner : EndogenousTurning.serviceK lagPartner initPartner)
    (head head' : UnifiedDrawdown.RestraintAgentSpec) (tail : List UnifiedDrawdown.RestraintAgentSpec)
    (tight : UnifiedDrawdown.OpenCompositionBridge.SpecTightens head head')
    (warnFleet : Nat)
    (H_def_pre H_def_post T_gate H_coop : Nat) (post_le_pre : H_def_post ≤ H_def_pre)
    (warnScope : Nat)
    (channel : Bool → Nat → Env → Bool)
    (G : Unit → (Unit → Nat) → Nat)
    (envDraw : Env → Unit → Nat) (envCap : Unit → Nat) (jointAdm : Env → Prop)
    (env_within : ∀ env, jointAdm env → ∀ k, envDraw env k ≤ envCap k)
    (x_crit H_safe x₀ : Unit → Nat) (warnLevel : Nat)
    (warnMonitor : warnLevel ≤ M.B_task ∨ warnLevel ≤ warnFleet ∨ warnLevel ≤ warnScope)
    (channel_fires : ∀ load env, jointAdm env → load ≤ spineSilence head tail →
      channel true load env = true)
    (G_rises : ∀ k, RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (G k))
    (post_viable : ∀ k, x_crit k ≤
      RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole G H_safe x_crit k)
    (post_cap : spinePostTotal M hProxySafe head tail H_def_post H_coop envCap ≤ H_safe ())
    (warn_margin : x_crit () +
      (spineMaxLag lagProxy lagPartner head tail T_gate + 1) *
        spinePreTotal M hProxyPre head tail H_def_pre H_coop envCap ≤ warnLevel)
    (init_margin : x_crit () +
      spineInitEta initProxy initPartner head tail T_gate *
        spinePreTotal M hProxyPre head tail H_def_pre H_coop envCap ≤ x₀ ()) :
    Viability.Kernel
      (OpenComposition.closedProcess
        (spineComponent M base hProxyPre hProxySafe head' tail warnFleet H_def_pre H_def_post T_gate H_coop)
        (spineContract M base hProxyPre hProxySafe lagProxy lagPartner safe_le initProxy hInitProxy
          initPartner hInitPartner head' tail warnFleet H_def_pre H_def_post T_gate H_coop post_le_pre)
        (spineObs M base tail warnScope) channel G envDraw jointAdm)
      (OpenComposition.closedGuard
        (spineComponent M base hProxyPre hProxySafe head' tail warnFleet H_def_pre H_def_post T_gate H_coop)
        (spineContract M base hProxyPre hProxySafe lagProxy lagPartner safe_le initProxy hInitProxy
          initPartner hInitPartner head' tail warnFleet H_def_pre H_def_post T_gate H_coop post_le_pre)
        x_crit)
      (x₀, spineInit initProxy initPartner head' tail T_gate) := by
  have refFleet := fleetHeadRefines tight warnFleet (fun _ => warnLevel) tail
  have refTurnFleet := contractRefines_compose_right
    (turningContract M base hProxyPre hProxySafe lagProxy lagPartner safe_le initProxy hInitProxy
      initPartner hInitPartner)
    (turningObs M base) refFleet
  refine OpenComposition.replace_left_viable
    (OpenComposition.OpenComponent.compose (turningSub M base hProxyPre hProxySafe) (fleetSub head tail warnFleet))
    (OpenComposition.OpenComponent.compose (turningSub M base hProxyPre hProxySafe) (fleetSub head' tail warnFleet))
    (scopeSub H_def_pre H_def_post T_gate H_coop)
    (OpenComposition.composeContract
      (turningContract M base hProxyPre hProxySafe lagProxy lagPartner safe_le initProxy hInitProxy
        initPartner hInitPartner)
      (fleetSubContract head tail warnFleet))
    (OpenComposition.composeContract
      (turningContract M base hProxyPre hProxySafe lagProxy lagPartner safe_le initProxy hInitProxy
        initPartner hInitPartner)
      (fleetSubContract head' tail warnFleet))
    (scopeSubContract H_def_pre H_def_post T_gate H_coop post_le_pre)
    (fun x => (turningObs M base x, fleetSubObs tail x))
    (fun x => (turningObs M base x, fleetSubObs tail x))
    (scopeSubObs warnScope)
    channel G envDraw envCap jointAdm env_within x_crit (fun _ => warnLevel) H_safe x₀
    refTurnFleet
    (spine_obs_detects M base hBase hProxyPre hProxySafe lagProxy lagPartner safe_le initProxy hInitProxy
      initPartner hInitPartner head tail warnFleet H_def_pre H_def_post T_gate H_coop post_le_pre
      warnScope warnLevel warnMonitor)
    (fun load env adm hLoad => by
      have hEq : (OpenComposition.composeContract
          (turningContract M base hProxyPre hProxySafe lagProxy lagPartner safe_le initProxy hInitProxy
            initPartner hInitPartner)
          (fleetSubContract head tail warnFleet)).maxSilence +
          (scopeSubContract H_def_pre H_def_post T_gate H_coop post_le_pre).maxSilence =
          spineSilence head tail :=
        spine_silence_eq M base hProxyPre hProxySafe lagProxy lagPartner safe_le initProxy hInitProxy
          initPartner hInitPartner head tail warnFleet H_def_pre H_def_post T_gate H_coop post_le_pre
      exact channel_fires load env adm (hEq ▸ hLoad))
    G_rises post_viable
    (fun k => by
      cases k
      change (spineContract M base hProxyPre hProxySafe lagProxy lagPartner safe_le initProxy hInitProxy
        initPartner hInitPartner head tail warnFleet H_def_pre H_def_post T_gate H_coop post_le_pre).postBudgetExt () +
        envCap () ≤ H_safe ()
      rw [spine_postCap_eq]
      exact post_cap)
    (fun k => by
      cases k
      change x_crit () + ((spineContract M base hProxyPre hProxySafe lagProxy lagPartner safe_le initProxy hInitProxy
        initPartner hInitPartner head tail warnFleet H_def_pre H_def_post T_gate H_coop post_le_pre).maxLag + 1) *
        ((spineContract M base hProxyPre hProxySafe lagProxy lagPartner safe_le initProxy hInitProxy
          initPartner hInitPartner head tail warnFleet H_def_pre H_def_post T_gate H_coop post_le_pre).preCapExt () +
          envCap ()) ≤ warnLevel
      rw [spine_maxLag_eq, spine_preCap_eq]
      exact warn_margin)
    (fun k => by
      cases k
      change x_crit () + (spineContract M base hProxyPre hProxySafe lagProxy lagPartner safe_le initProxy hInitProxy
        initPartner hInitPartner head tail warnFleet H_def_pre H_def_post T_gate H_coop post_le_pre).eta
          (spineInit initProxy initPartner head tail T_gate) *
        ((spineContract M base hProxyPre hProxySafe lagProxy lagPartner safe_le initProxy hInitProxy
          initPartner hInitPartner head tail warnFleet H_def_pre H_def_post T_gate H_coop post_le_pre).preCapExt () +
          envCap ()) ≤ x₀ ()
      rw [spine_eta_eq, spine_preCap_eq]
      exact init_margin)

/-- **Theorem 1.6 (`master_spine_upgrade_scope_viable`)**: Heterogeneous replacement of the gated
defector inside `scopeSub` (`L3`) by any `D'` (`S_D', Obs_D', Dist_D', Int_D'`) refining
`gatedDefectorContract` via `replace_right_viable`. -/
theorem master_spine_upgrade_scope_viable
    {P S_D' Obs_D' Dist_D' Int_D' Env : Type}
    (M : EndogenousTurning.ServiceTaskModel P) (base : Nat) (hBase : M.upkeep M.ext ≤ base)
    (hProxyPre hProxySafe lagProxy lagPartner : Nat) (safe_le : hProxySafe ≤ hProxyPre)
    (initProxy : Nat) (hInitProxy : initProxy ≤ lagProxy)
    (initPartner : Bool × Nat) (hInitPartner : EndogenousTurning.serviceK lagPartner initPartner)
    (head : UnifiedDrawdown.RestraintAgentSpec) (tail : List UnifiedDrawdown.RestraintAgentSpec)
    (warnFleet : Nat)
    (H_def_pre H_def_post T_gate H_coop : Nat) (post_le_pre : H_def_post ≤ H_def_pre)
    (warnScope : Nat)
    (D' : OpenComposition.OpenComponent S_D' Obs_D' Dist_D' Int_D' Unit)
    {initD' : S_D'} (cD' : OpenComposition.InterfaceContract D' initD')
    (obsD' : (Unit → Nat) → Obs_D')
    (channel : Bool → Nat → Env → Bool)
    (G : Unit → (Unit → Nat) → Nat)
    (envDraw : Env → Unit → Nat) (envCap : Unit → Nat) (jointAdm : Env → Prop)
    (env_within : ∀ env, jointAdm env → ∀ k, envDraw env k ≤ envCap k)
    (x_crit H_safe x₀ : Unit → Nat) (warnLevel : Nat)
    (refD : OpenComposition.ContractRefines
      (ScopeDynamics.OpenCompositionBridge.gatedDefectorContract H_def_pre H_def_post T_gate post_le_pre)
      cD' (ScopeDynamics.reciprocalObs warnScope ()) obsD' (fun _ => warnLevel))
    (warnMonitor : warnLevel ≤ M.B_task ∨ warnLevel ≤ warnFleet ∨ warnLevel ≤ warnScope)
    (channel_fires : ∀ load env, jointAdm env → load ≤ spineSilence head tail →
      channel true load env = true)
    (G_rises : ∀ k, RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (G k))
    (post_viable : ∀ k, x_crit k ≤
      RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole G H_safe x_crit k)
    (post_cap : spinePostTotal M hProxySafe head tail H_def_post H_coop envCap ≤ H_safe ())
    (warn_margin : x_crit () +
      (spineMaxLag lagProxy lagPartner head tail T_gate + 1) *
        spinePreTotal M hProxyPre head tail H_def_pre H_coop envCap ≤ warnLevel)
    (init_margin : x_crit () +
      spineInitEta initProxy initPartner head tail T_gate *
        spinePreTotal M hProxyPre head tail H_def_pre H_coop envCap ≤ x₀ ()) :
    Viability.Kernel
      (OpenComposition.closedProcess
        (OpenComposition.OpenComponent.compose
          (OpenComposition.OpenComponent.compose
            (turningSub M base hProxyPre hProxySafe) (fleetSub head tail warnFleet))
          (OpenComposition.OpenComponent.compose D' (ScopeDynamics.OpenCompositionBridge.coopComponent H_coop)))
        (OpenComposition.composeContract
          (OpenComposition.composeContract
            (turningContract M base hProxyPre hProxySafe lagProxy lagPartner safe_le initProxy hInitProxy
              initPartner hInitPartner)
            (fleetSubContract head tail warnFleet))
          (OpenComposition.composeContract cD' (ScopeDynamics.OpenCompositionBridge.coopContract H_coop)))
        (fun x => ((turningObs M base x, fleetSubObs tail x), (obsD' x, ())))
        channel G envDraw jointAdm)
      (OpenComposition.closedGuard
        (OpenComposition.OpenComponent.compose
          (OpenComposition.OpenComponent.compose
            (turningSub M base hProxyPre hProxySafe) (fleetSub head tail warnFleet))
          (OpenComposition.OpenComponent.compose D' (ScopeDynamics.OpenCompositionBridge.coopComponent H_coop)))
        (OpenComposition.composeContract
          (OpenComposition.composeContract
            (turningContract M base hProxyPre hProxySafe lagProxy lagPartner safe_le initProxy hInitProxy
              initPartner hInitPartner)
            (fleetSubContract head tail warnFleet))
          (OpenComposition.composeContract cD' (ScopeDynamics.OpenCompositionBridge.coopContract H_coop)))
        x_crit)
      (x₀, (((initProxy, initPartner), UnifiedDrawdown.OpenCompositionBridge.fleetInit head tail), (initD', ()))) := by
  have refScope := contractRefines_compose_left
    (ScopeDynamics.OpenCompositionBridge.coopContract H_coop) (fun _ => ()) refD
  refine replace_right_viable
    (OpenComposition.OpenComponent.compose (turningSub M base hProxyPre hProxySafe) (fleetSub head tail warnFleet))
    (scopeSub H_def_pre H_def_post T_gate H_coop)
    (OpenComposition.OpenComponent.compose D' (ScopeDynamics.OpenCompositionBridge.coopComponent H_coop))
    (OpenComposition.composeContract
      (turningContract M base hProxyPre hProxySafe lagProxy lagPartner safe_le initProxy hInitProxy
        initPartner hInitPartner)
      (fleetSubContract head tail warnFleet))
    (scopeSubContract H_def_pre H_def_post T_gate H_coop post_le_pre)
    (OpenComposition.composeContract cD' (ScopeDynamics.OpenCompositionBridge.coopContract H_coop))
    (fun x => (turningObs M base x, fleetSubObs tail x))
    (scopeSubObs warnScope)
    (fun x => (obsD' x, ()))
    channel G envDraw envCap jointAdm env_within x_crit (fun _ => warnLevel) H_safe x₀
    refScope
    (spine_obs_detects M base hBase hProxyPre hProxySafe lagProxy lagPartner safe_le initProxy hInitProxy
      initPartner hInitPartner head tail warnFleet H_def_pre H_def_post T_gate H_coop post_le_pre
      warnScope warnLevel warnMonitor)
    (fun load env adm hLoad => by
      have hEq : (OpenComposition.composeContract
          (turningContract M base hProxyPre hProxySafe lagProxy lagPartner safe_le initProxy hInitProxy
            initPartner hInitPartner)
          (fleetSubContract head tail warnFleet)).maxSilence +
          (scopeSubContract H_def_pre H_def_post T_gate H_coop post_le_pre).maxSilence =
          spineSilence head tail :=
        spine_silence_eq M base hProxyPre hProxySafe lagProxy lagPartner safe_le initProxy hInitProxy
          initPartner hInitPartner head tail warnFleet H_def_pre H_def_post T_gate H_coop post_le_pre
      exact channel_fires load env adm (hEq ▸ hLoad))
    G_rises post_viable
    (fun k => by
      cases k
      change (spineContract M base hProxyPre hProxySafe lagProxy lagPartner safe_le initProxy hInitProxy
        initPartner hInitPartner head tail warnFleet H_def_pre H_def_post T_gate H_coop post_le_pre).postBudgetExt () +
        envCap () ≤ H_safe ()
      rw [spine_postCap_eq]
      exact post_cap)
    (fun k => by
      cases k
      change x_crit () + ((spineContract M base hProxyPre hProxySafe lagProxy lagPartner safe_le initProxy hInitProxy
        initPartner hInitPartner head tail warnFleet H_def_pre H_def_post T_gate H_coop post_le_pre).maxLag + 1) *
        ((spineContract M base hProxyPre hProxySafe lagProxy lagPartner safe_le initProxy hInitProxy
          initPartner hInitPartner head tail warnFleet H_def_pre H_def_post T_gate H_coop post_le_pre).preCapExt () +
          envCap ()) ≤ warnLevel
      rw [spine_maxLag_eq, spine_preCap_eq]
      exact warn_margin)
    (fun k => by
      cases k
      change x_crit () + (spineContract M base hProxyPre hProxySafe lagProxy lagPartner safe_le initProxy hInitProxy
        initPartner hInitPartner head tail warnFleet H_def_pre H_def_post T_gate H_coop post_le_pre).eta
          (spineInit initProxy initPartner head tail T_gate) *
        ((spineContract M base hProxyPre hProxySafe lagProxy lagPartner safe_le initProxy hInitProxy
          initPartner hInitPartner head tail warnFleet H_def_pre H_def_post T_gate H_coop post_le_pre).preCapExt () +
          envCap ()) ≤ x₀ ()
      rw [spine_eta_eq, spine_preCap_eq]
      exact init_margin)

/-! ### 1.7 Internalized Hidden-Port Closure (`withHiddenSite` & `master_spine_hide_viable`) -/

/-- Augment any `(C, c)` on `Ext := Unit` with an exposed coupled site `.inr ()` whose draw switches
from `preHide` (`0 < c.eta s`) to `postHide` (`c.eta s = 0`) cleanly inside `c`'s contract. -/
def withHiddenSite {S Obs Dist Int : Type}
    (C : OpenComposition.OpenComponent S Obs Dist Int Unit)
    {init : S} (c : OpenComposition.InterfaceContract C init)
    (preHide postHide : Nat) :
    OpenComposition.OpenComponent S Obs Dist Int (Sum Unit Unit) where
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
    {C : OpenComposition.OpenComponent S Obs Dist Int Unit}
    {init : S} (c : OpenComposition.InterfaceContract C init)
    (preHide postHide : Nat) (hPost : postHide ≤ preHide) :
    OpenComposition.InterfaceContract (withHiddenSite C c preHide postHide) init where
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

/-- Wire hidden threshold `xh () < warnHide ()` directly into `scopeSub`'s `Bool` defector slot. -/
def spineHideWireObs {tail : List UnifiedDrawdown.RestraintAgentSpec} (warnHide : Unit → Nat)
    (o : ((Unit × Nat) × UnifiedDrawdown.OpenCompositionBridge.FleetObs tail) × (Bool × Unit))
    (xh : Unit → Nat) :
    ((Unit × Nat) × UnifiedDrawdown.OpenCompositionBridge.FleetObs tail) × (Bool × Unit) :=
  (o.1, (o.2.1 || Nat.blt (xh ()) (warnHide ()), ()))

/-- Constructive admissibility lift for `spineContract` across `spineHideWireObs`. -/
theorem spineContract_tol_lifts {P : Type} (M : EndogenousTurning.ServiceTaskModel P)
    (base hProxyPre hProxySafe lagProxy lagPartner : Nat)
    (safe_le : hProxySafe ≤ hProxyPre) (initProxy : Nat) (hInitProxy : initProxy ≤ lagProxy)
    (initPartner : Bool × Nat) (hInitPartner : EndogenousTurning.serviceK lagPartner initPartner)
    (head : UnifiedDrawdown.RestraintAgentSpec) (tail : List UnifiedDrawdown.RestraintAgentSpec) (warnFleet : Nat)
    (H_def_pre H_def_post T_gate H_coop : Nat) (post_le_pre : H_def_post ≤ H_def_pre)
    (warnHide : Unit → Nat)
    (o : ((Unit × Nat) × UnifiedDrawdown.OpenCompositionBridge.FleetObs tail) × (Bool × Unit))
    (xh : Unit → Nat) (_al b : Bool)
    (d : ((Unit × Unit) × UnifiedDrawdown.OpenCompositionBridge.FleetDist tail) × (Unit × Unit))
    (_ : True) :
    (spineContract M base hProxyPre hProxySafe lagProxy lagPartner safe_le initProxy hInitProxy
      initPartner hInitPartner head tail warnFleet H_def_pre H_def_post T_gate H_coop post_le_pre).tol
      (spineHideWireObs warnHide o xh, b) d :=
  ⟨⟨⟨trivial, trivial⟩, fleetContract_tol head tail warnFleet _ d.1.2⟩, ⟨trivial, trivial⟩⟩

/-- **Theorem 1.7 (`master_spine_hide_viable`)**: Hiding an internal coupled port via
`OpenComponent.hide` on `withHiddenSite (spineComponent ...)` certifies BOTH outer `Viability.Kernel`
and permanent safety `x_crit_hide () ≤ st.2.2 ()` on every reachable state (`close_contract_viable` +
`hideContract_keeps_hidden`). -/
theorem master_spine_hide_viable {P Env : Type}
    (M : EndogenousTurning.ServiceTaskModel P) (base : Nat) (hBase : M.upkeep M.ext ≤ base)
    (hProxyPre hProxySafe lagProxy lagPartner : Nat) (safe_le : hProxySafe ≤ hProxyPre)
    (initProxy : Nat) (hInitProxy : initProxy ≤ lagProxy)
    (initPartner : Bool × Nat) (hInitPartner : EndogenousTurning.serviceK lagPartner initPartner)
    (head : UnifiedDrawdown.RestraintAgentSpec) (tail : List UnifiedDrawdown.RestraintAgentSpec)
    (warnFleet : Nat)
    (H_def_pre H_def_post T_gate H_coop : Nat) (post_le_pre : H_def_post ≤ H_def_pre)
    (warnScope preHide postHide : Nat) (hPost : postHide ≤ preHide)
    (G_hide G_ext : Unit → (Unit → Nat) → Nat)
    (x_crit_hide warnHide H_safe_hide x₀_hide : Unit → Nat)
    (G_hide_rises : ∀ k, RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (G_hide k))
    (hide_post_viable : ∀ k, x_crit_hide k ≤
      RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole G_hide H_safe_hide x_crit_hide k)
    (hide_post_cap : postHide ≤ H_safe_hide ())
    (hide_warn_margin : x_crit_hide () +
      (spineMaxLag lagProxy lagPartner head tail T_gate + 1) * preHide ≤ warnHide ())
    (hide_init_margin : x_crit_hide () +
      spineInitEta initProxy initPartner head tail T_gate * preHide ≤ x₀_hide ())
    (channel : Bool → Nat → Env → Bool)
    (envDraw : Env → Unit → Nat) (envCap : Unit → Nat) (jointAdm : Env → Prop)
    (env_within : ∀ env, jointAdm env → ∀ k, envDraw env k ≤ envCap k)
    (x_crit_ext H_safe_ext x₀_ext : Unit → Nat) (warnLevel : Nat)
    (warnMonitor : warnLevel ≤ M.B_task ∨ warnLevel ≤ warnFleet ∨ warnLevel ≤ warnScope)
    (channel_fires : ∀ load env, jointAdm env → load ≤ spineSilence head tail →
      channel true load env = true)
    (G_ext_rises : ∀ k, RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (G_ext k))
    (ext_post_viable : ∀ k, x_crit_ext k ≤
      RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole G_ext H_safe_ext x_crit_ext k)
    (ext_post_cap : spinePostTotal M hProxySafe head tail H_def_post H_coop envCap ≤ H_safe_ext ())
    (ext_warn_margin : x_crit_ext () +
      (spineMaxLag lagProxy lagPartner head tail T_gate + 1) *
        spinePreTotal M hProxyPre head tail H_def_pre H_coop envCap ≤ warnLevel)
    (ext_init_margin : x_crit_ext () +
      spineInitEta initProxy initPartner head tail T_gate *
        spinePreTotal M hProxyPre head tail H_def_pre H_coop envCap ≤ x₀_ext ()) :
    let baseComp := spineComponent M base hProxyPre hProxySafe head tail warnFleet H_def_pre H_def_post T_gate H_coop
    let baseContr := spineContract M base hProxyPre hProxySafe lagProxy lagPartner safe_le initProxy hInitProxy
      initPartner hInitPartner head tail warnFleet H_def_pre H_def_post T_gate H_coop post_le_pre
    let siteComp := withHiddenSite baseComp baseContr preHide postHide
    let siteContr := withHiddenSiteContract baseContr preHide postHide hPost
    let hiddenComp := OpenComposition.OpenComponent.hide siteComp G_hide (spineHideWireObs warnHide)
    let hiddenContr := OpenComposition.hideContract siteContr G_hide (spineHideWireObs warnHide)
      (fun _ _ => True) baseContr.warnObs x_crit_hide warnHide H_safe_hide x₀_hide
      (spineContract_tol_lifts M base hProxyPre hProxySafe lagProxy lagPartner safe_le initProxy hInitProxy
        initPartner hInitPartner head tail warnFleet H_def_pre H_def_post T_gate H_coop post_le_pre warnHide)
      G_hide_rises
      (fun o xh hw => match hw with
        | .inl w => Or.inl w
        | .inr (.inl wScope) => Or.inr (Or.inl (by
          show (o.2.1 || Nat.blt (xh ()) (warnHide ())) = true
          rw [show o.2.1 = true from wScope]
          rfl))
        | .inr (.inr f) => False.elim f)
      (fun _ xh ⟨k, hk⟩ => by
        cases k
        exact Or.inr (Or.inl ((congrArg (_ || ·) (AdaptiveLoops.natBlt_true_iff.mpr hk)).trans
          (OpenComposition.bool_or_true_right _))))
      hide_post_viable
      (fun k => by cases k; exact hide_post_cap)
      (fun k => by
        cases k
        change x_crit_hide () + (baseContr.maxLag + 1) * preHide ≤ warnHide ()
        rw [spine_maxLag_eq]
        exact hide_warn_margin)
      (fun k => by
        cases k
        change x_crit_hide () +
          baseContr.eta (spineInit initProxy initPartner head tail T_gate) * preHide ≤ x₀_hide ()
        rw [spine_eta_eq]
        exact hide_init_margin)
    let proc := OpenComposition.closedProcess hiddenComp hiddenContr
      (spineObs M base tail warnScope) channel G_ext envDraw jointAdm
    Viability.Kernel proc (OpenComposition.closedGuard hiddenComp hiddenContr x_crit_ext)
      (x₀_ext, (spineInit initProxy initPartner head tail T_gate, x₀_hide)) ∧
    (∀ st, Reach proc (x₀_ext, (spineInit initProxy initPartner head tail T_gate, x₀_hide)) st →
      x_crit_hide () ≤ st.2.2 ()) := by
  intro baseComp baseContr siteComp siteContr hiddenComp hiddenContr proc
  have res := OpenComposition.close_contract_viable hiddenComp hiddenContr
    (spineObs M base tail warnScope) channel G_ext envDraw envCap jointAdm env_within
    x_crit_ext (fun _ => warnLevel) H_safe_ext x₀_ext
    (fun x k lt =>
      spine_obs_detects M base hBase hProxyPre hProxySafe lagProxy lagPartner safe_le initProxy hInitProxy
        initPartner hInitPartner head tail warnFleet H_def_pre H_def_post T_gate H_coop post_le_pre
        warnScope warnLevel warnMonitor x k lt)
    (fun load env adm hLoad => by
      change load ≤ baseContr.maxSilence at hLoad
      rw [spine_silence_eq] at hLoad
      exact channel_fires load env adm hLoad)
    G_ext_rises ext_post_viable
    (fun k => by
      cases k
      change baseContr.postBudgetExt () + envCap () ≤ H_safe_ext ()
      rw [spine_postCap_eq]
      exact ext_post_cap)
    (fun k => by
      cases k
      change x_crit_ext () + (baseContr.maxLag + 1) * (baseContr.preCapExt () + envCap ()) ≤ warnLevel
      rw [spine_maxLag_eq, spine_preCap_eq]
      exact ext_warn_margin)
    (fun k => by
      cases k
      change x_crit_ext () +
        baseContr.eta (spineInit initProxy initPartner head tail T_gate) *
          (baseContr.preCapExt () + envCap ()) ≤ x₀_ext ()
      rw [spine_eta_eq, spine_preCap_eq]
      exact ext_init_margin)
  refine ⟨res.2.kernel res.1, fun st hReach => ?_⟩
  have hInv := res.2.closed.reach hReach res.1
  exact OpenComposition.hideContract_keeps_hidden hInv.1 ()

/-- **Theorem 1.8 (`master_spine_multiscale_transfer`)**: Synchronous `prodProcess` compositional
lax simulation (`OpenComposition.compose_laxSim_max`) transfers a macro `Viability.Certificate` via
`lax_kernel_of_certificate` into `Viability.Kernel`, `ReserveSafe` via `Viability.Kernel.run`, and
macro-capability `TransformsViably` (explicitly scoped strictly to decoupled `prodProcess`). -/
theorem master_spine_multiscale_transfer
    {S₁ A₁ Q₁ B₁ S₂ A₂ Q₂ B₂ F C K_cap : Type}
    {P₁ : Process S₁ A₁} {R₁ : Process Q₁ B₁} {π₁ : S₁ → Q₁} {M₁ : SlackDist Q₁}
    {P₂ : Process S₂ A₂} {R₂ : Process Q₂ B₂} {π₂ : S₂ → Q₂} {M₂ : SlackDist Q₂}
    {σ : Nat → Nat}
    (sim₁ : LaxSim P₁ R₁ π₁ σ M₁) (sim₂ : LaxSim P₂ R₂ π₂ σ M₂)
    {guardQ : Q₁ × Q₂ → Prop} {K : Q₁ × Q₂ → Prop} {guardProd : S₁ × S₂ → Prop}
    (certQ : Viability.Certificate (OpenComposition.prodProcess R₁ R₂) guardQ K)
    (Δ : Nat)
    (absorb : AdaptiveLoops.natMax (sim₁.α Δ) (sim₂.α Δ) +
      AdaptiveLoops.natMax sim₁.ε sim₂.ε ≤ Δ)
    (margin : ∀ q u, guardQ q →
      AdaptiveLoops.natMax (M₁.d (π₁ u.1) q.1) (M₂.d (π₂ u.2) q.2) ≤
        AdaptiveLoops.natMax (sim₁.β Δ) (sim₂.β Δ) + AdaptiveLoops.natMax sim₁.η sim₂.η →
      guardProd u)
    {s₁₀ : S₁} {s₂₀ : S₂}
    (ep₁ : sim₁.Epoch (σ 0) s₁₀) (ep₂ : sim₂.Epoch (σ 0) s₂₀)
    (initK : K (π₁ s₁₀, π₂ s₂₀))
    (r : Run (OpenComposition.prodProcess P₁ P₂)) (hStart : r.state 0 = (s₁₀, s₂₀))
    (W : Web F C) (cap : F → K_cap) (T : Nat)
    (macro_persist : ReserveSafe (fun t => guardProd (r.state t)) T →
      ∀ s t, T ≤ s → s ≤ t → ∀ k, W.MacroAdmits cap (W.level s) s k →
        W.MacroAdmits cap (W.level t) t k)
    (micro_turnover : ∀ t, T ≤ t →
      ∃ f, W.Admits (W.level t) t f ∧ ¬ W.Admits (W.level (t + 1)) (t + 1) f) :
    Viability.Kernel (OpenComposition.prodProcess P₁ P₂) guardProd (s₁₀, s₂₀) ∧
    ReserveSafe (fun t => guardProd (r.state t)) T ∧
    TransformsViably W (fun t => guardProd (r.state t)) cap T := by
  have kern : Viability.Kernel (OpenComposition.prodProcess P₁ P₂) guardProd (s₁₀, s₂₀) :=
    lax_kernel_of_certificate (OpenComposition.compose_laxSim_max sim₁ sim₂)
      certQ Δ absorb margin ⟨ep₁, ep₂⟩ initK
  have rSafe : ReserveSafe (fun t => guardProd (r.state t)) T :=
    fun t _ => Viability.Kernel.run r (hStart ▸ kern) t
  exact ⟨kern, rSafe, ⟨rSafe, macro_persist rSafe, micro_turnover⟩⟩

/-! ### 1.4 Concrete Numerical Non-Vacuous Inhabited-`Int` Instantiation (`MasterSpineWitness`) -/

namespace MasterSpineWitness

inductive SpinePolicy where
  | safe
  | ext

def spineTaskModel : EndogenousTurning.ServiceTaskModel SpinePolicy where
  gain := 2
  gain_pos := by decide
  demand
    | .safe => 20
    | .ext => 42
  upkeep
    | .safe => 10
    | .ext => 53
  draw
    | .safe => 1
    | .ext => 2
  safe := .safe
  ext := .ext
  demand_lt := by decide
  upkeep_lt := by decide
  ext_viable_at_full := by decide

theorem spineTaskModel_B_task : spineTaskModel.B_task = 42 := rfl

def agentF1 : UnifiedDrawdown.RestraintAgentSpec := ⟨2, 1, 2, 0, Nat.le_succ 1⟩
def agentF2 : UnifiedDrawdown.RestraintAgentSpec := ⟨1, 0, 2, 0, Nat.zero_le 1⟩

def gExt (_ : Unit) (e : Unit → Nat) : Nat := if 6 ≤ e () then 4 else 0
def gHide (_ : Unit) (e : Unit → Nat) : Nat := if 4 ≤ e () then 1 else 0

theorem gExt_rises : ∀ k : Unit, RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (gExt k) :=
  fun _ e _ below =>
    match Nat.decLe 6 (e ()) with
    | isTrue h => Nat.le_trans (Nat.le_of_eq (if_pos h))
        (Nat.le_of_eq (if_pos (Nat.le_trans h (below ()))).symm)
    | isFalse h => Nat.le_trans (Nat.le_of_eq (if_neg h)) (Nat.zero_le _)

theorem gHide_rises : ∀ k : Unit, RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (gHide k) :=
  fun _ e _ below =>
    match Nat.decLe 4 (e ()) with
    | isTrue h => Nat.le_trans (Nat.le_of_eq (if_pos h))
        (Nat.le_of_eq (if_pos (Nat.le_trans h (below ()))).symm)
    | isFalse h => Nat.le_trans (Nat.le_of_eq (if_neg h)) (Nat.zero_le _)

def initPartner : Bool × Nat := (true, 2)

theorem initPartner_in : EndogenousTurning.serviceK 2 initPartner :=
  ⟨Nat.le_refl 2, fun _ => by decide, fun h => Bool.noConfusion h⟩

def witnessChannel (em : Bool) (load : Nat) (_ : Unit) : Bool :=
  em && Nat.ble load 0

def witnessSpineComp :=
  spineComponent spineTaskModel 53 2 1 agentF1 [agentF2] 42 2 0 2 1

def witnessSpineContr :=
  spineContract spineTaskModel 53 2 1 2 2 (by decide) 2 (Nat.le_refl 2) initPartner initPartner_in
    agentF1 [agentF2] 42 2 0 2 1 (Nat.zero_le 2)

def witnessSpineInit :=
  spineInit 2 initPartner agentF1 [agentF2] 2

def witnessSpineObs :=
  spineObs spineTaskModel 53 [agentF2] 42

def spineRun :
    Run (OpenComposition.closedProcess witnessSpineComp witnessSpineContr witnessSpineObs
      witnessChannel gExt (fun _ _ => 0) (fun _ => True)) where
  state := Law.orbit
    (fun st => OpenComposition.closedStep witnessSpineComp witnessSpineObs
      witnessChannel gExt (fun _ _ => 0) st ((), ((((), ()), ((), ())), ((), ()))))
    (fun _ => 46, witnessSpineInit)
  act _ := ((), ((((), ()), ((), ())), ((), ())))
  step _ := ⟨⟨trivial, fun _ => ⟨⟨⟨trivial, trivial⟩, ⟨trivial, trivial⟩⟩, ⟨trivial, trivial⟩⟩⟩, rfl⟩

def witnessSiteComp := withHiddenSite witnessSpineComp witnessSpineContr 2 1
def witnessSiteContr := withHiddenSiteContract witnessSpineContr 2 1 (by decide)
def witnessHiddenComp :=
  OpenComposition.OpenComponent.hide witnessSiteComp gHide (spineHideWireObs (fun _ => 12))

theorem witnessTolLifts :
    ∀ o xh (_al : Bool) b d (_ : True),
      witnessSpineContr.tol (spineHideWireObs (fun _ => 12) o xh, b) d :=
  spineContract_tol_lifts spineTaskModel 53 2 1 2 2 (by decide) 2 (Nat.le_refl 2) initPartner initPartner_in
    agentF1 [agentF2] 42 2 0 2 1 (Nat.zero_le 2) (fun _ => 12)

theorem witnessWireOuterWarn :
    ∀ o xh, witnessSpineContr.warnObs o →
      witnessSpineContr.warnObs (spineHideWireObs (fun _ => 12) o xh) :=
  fun o xh hw => match hw with
    | .inl w => Or.inl w
    | .inr (.inl wScope) => Or.inr (Or.inl (by
      show (o.2.1 || Nat.blt (xh ()) 12) = true
      rw [show o.2.1 = true from wScope]
      rfl))
    | .inr (.inr f) => False.elim f

theorem witnessWireHideWarn :
    ∀ o xh, (∃ k : Unit, xh k < 12) →
      witnessSpineContr.warnObs (spineHideWireObs (fun _ => 12) o xh) :=
  fun _ _ ⟨k, hk⟩ => by
    cases k
    exact Or.inr (Or.inl ((congrArg (_ || ·) (AdaptiveLoops.natBlt_true_iff.mpr hk)).trans
      (OpenComposition.bool_or_true_right _)))

def witnessHiddenContr :=
  OpenComposition.hideContract witnessSiteContr gHide (spineHideWireObs (fun _ => 12))
    (fun _ _ => True) witnessSpineContr.warnObs (fun _ => 5) (fun _ => 12) (fun _ => 1) (fun _ => 11)
    witnessTolLifts gHide_rises witnessWireOuterWarn witnessWireHideWarn
    (fun k => by cases k; show 5 ≤ 5 - 1 + gHide () (fun _ => 5 - 1); exact by decide)
    (fun k => by cases k; exact Nat.le_refl 1)
    (fun k => by cases k; show 5 + (witnessSiteContr.maxLag + 1) * 2 ≤ 12; exact by decide)
    (fun k => by cases k; show 5 + witnessSiteContr.eta witnessSpineInit * 2 ≤ 11; exact by decide)

def hiddenRun :
    Run (OpenComposition.closedProcess witnessHiddenComp witnessHiddenContr witnessSpineObs
      witnessChannel gExt (fun _ _ => 0) (fun _ => True)) where
  state := Law.orbit
    (fun st => OpenComposition.closedStep witnessHiddenComp witnessSpineObs
      witnessChannel gExt (fun _ _ => 0) st ((), ((((), ()), ((), ())), ((), ()))))
    (fun _ => 46, (witnessSpineInit, fun _ => 11))
  act _ := ((), ((((), ()), ((), ())), ((), ())))
  step _ := ⟨⟨trivial, fun _ => trivial⟩, rfl⟩

/-- **Concrete Non-Vacuous Inhabited-`Int` Spine Witness (`MasterSpineWitness.witness_viable`)**:
certifies both the exposed 3-pillar `Viability.Kernel` (`46 → 40 → 34 → 28 → 28 ≥ 10`), the
hidden-port `Viability.Kernel` (`(46, 11) → (40, 10) → (34, 9) → (34, 9)`), genuine `Int`
habitation (`Sum.inr ()`), and nonzero `drawInt` (`2, 2, 1`). -/
theorem witness_viable :
    spineTaskModel.B_task = 42 ∧
    Viability.Kernel
      (OpenComposition.closedProcess witnessSpineComp witnessSpineContr witnessSpineObs
        witnessChannel gExt (fun _ _ => 0) (fun _ => True))
      (OpenComposition.closedGuard witnessSpineComp witnessSpineContr (fun _ => 10))
      (fun _ => 46, witnessSpineInit) ∧
    ((spineRun.state 0).1 () = 46 ∧
     (spineRun.state 1).1 () = 40 ∧
     (spineRun.state 2).1 () = 34 ∧
     (spineRun.state 3).1 () = 28 ∧
     (spineRun.state 4).1 () = 28 ∧
     ∀ t, 10 ≤ (spineRun.state t).1 ()) ∧
    Viability.Kernel
      (OpenComposition.closedProcess witnessHiddenComp witnessHiddenContr witnessSpineObs
        witnessChannel gExt (fun _ _ => 0) (fun _ => True))
      (OpenComposition.closedGuard witnessHiddenComp witnessHiddenContr (fun _ => 10))
      (fun _ => 46, (witnessSpineInit, fun _ => 11)) ∧
    (((hiddenRun.state 0).1 (), (hiddenRun.state 0).2.2 ()) = (46, 11) ∧
     ((hiddenRun.state 1).1 (), (hiddenRun.state 1).2.2 ()) = (40, 10) ∧
     ((hiddenRun.state 2).1 (), (hiddenRun.state 2).2.2 ()) = (34, 9) ∧
     ((hiddenRun.state 3).1 (), (hiddenRun.state 3).2.2 ()) = (34, 9) ∧
     witnessHiddenComp.drawInt (hiddenRun.state 0).2 (.inr ()) = 2 ∧
     witnessHiddenComp.drawInt (hiddenRun.state 1).2 (.inr ()) = 2 ∧
     witnessHiddenComp.drawInt (hiddenRun.state 2).2 (.inr ()) = 1 ∧
     ∀ t, 10 ≤ (hiddenRun.state t).1 () ∧ 5 ≤ (hiddenRun.state t).2.2 ()) := by
  have kSpine :
      Viability.Kernel
        (OpenComposition.closedProcess witnessSpineComp witnessSpineContr witnessSpineObs
          witnessChannel gExt (fun _ _ => 0) (fun _ => True))
        (OpenComposition.closedGuard witnessSpineComp witnessSpineContr (fun _ => 10))
        (fun _ => 46, witnessSpineInit) :=
    master_alignment_spine_viable spineTaskModel 53 (by decide) 2 1 2 2 (by decide) 2 (Nat.le_refl 2)
      initPartner initPartner_in agentF1 [agentF2] 42 2 0 2 1 (Nat.zero_le 2) 42
      witnessChannel gExt (fun _ _ => 0) (fun _ => 0) (fun _ => True)
      (fun _ _ _ => Nat.zero_le 0)
      (fun _ => 10) (fun _ => 4) (fun _ => 46) 42
      (Or.inl (Nat.le_refl 42))
      (fun load _ _ (le : load ≤ 0) => by
        show (true && Nat.ble load 0) = true
        rw [Nat.ble_eq_true_of_le le]
        rfl)
      gExt_rises
      (fun k => by cases k; show 10 ≤ 10 - 4 + gExt () (fun _ => 10 - 4); exact by decide)
      (by decide) (by decide) (by decide)
  have hHide := master_spine_hide_viable spineTaskModel 53 (by decide) 2 1 2 2 (by decide) 2 (Nat.le_refl 2)
    initPartner initPartner_in agentF1 [agentF2] 42 2 0 2 1 (Nat.zero_le 2) 42
    2 1 (by decide) gHide gExt (fun _ => 5) (fun _ => 12) (fun _ => 1) (fun _ => 11)
    gHide_rises
    (fun k => by cases k; show 5 ≤ 5 - 1 + gHide () (fun _ => 5 - 1); exact by decide)
    (Nat.le_refl 1) (by decide) (by decide)
    witnessChannel (fun _ _ => 0) (fun _ => 0) (fun _ => True)
    (fun _ _ _ => Nat.zero_le 0)
    (fun _ => 10) (fun _ => 4) (fun _ => 46) 42
    (Or.inl (Nat.le_refl 42))
    (fun load _ _ (le : load ≤ 0) => by
      show (true && Nat.ble load 0) = true
      rw [Nat.ble_eq_true_of_le le]
      rfl)
    gExt_rises
    (fun k => by cases k; show 10 ≤ 10 - 4 + gExt () (fun _ => 10 - 4); exact by decide)
    (by decide) (by decide) (by decide)
  refine ⟨rfl, kSpine, ⟨rfl, rfl, rfl, rfl, rfl, fun t => (Viability.Kernel.run spineRun kSpine t).1 ()⟩,
    hHide.1, ⟨rfl, rfl, rfl, rfl, rfl, rfl, rfl, fun t => ?_⟩⟩
  exact ⟨(Viability.Kernel.run hiddenRun hHide.1 t).1 (), hHide.2 _ (Nat.zero_add t ▸ hiddenRun.reach 0 t)⟩

end MasterSpineWitness

end ComposedSpine

/-! ## Part 2: Structural Failure Dichotomy & Metaethical Boundary (`AlignmentDichotomy`)

### `AGENTS.md` Rule 2 — Empirical Recognition & Metaethical Non-Entailment Boundary

1. **Recognition boundary:** Every Lean theorem in `L0–L5` is a proved conditional: *if* a concrete
   system satisfies the stated interface contracts (`InterfaceContract`), renewal monotonicity (`G_rises`),
   cadence fidelity, and lag/draw bounds, *then* viability (`Viability.Kernel`) holds. Whether an actual
   physical, institutional, or AI system satisfies those premises (`obs_detects`, `channel_fires`,
   `env_within`, `tol`, `α Δ + ε ≤ Δ`, or third-party scope) is an empirical recognition judgment that
   **no proof gives**, and must be accompanied by an explicit pre-stated refutation test.
2. **Metaethical boundary:** Even complete compositional viability (`master_alignment_spine_viable`) and
   `TransformsViably` establish only dynamical persistence (`ReadsOnlyDynamics`); neither entails
   `Significance.Unrestricted sig` (`alignmentSpine_cannot_entail_unrestricted`) nor
   `PremiseWitnesses.Comparison` (`ReadsNoOrder.not_entails`).
-/

namespace AlignmentDichotomy

/-! ### 2.1 Metaethical & Empirical Recognition Bounds (`L5` Spine Level) -/

/-- Any predicate over a spine system reading only the dynamics satisfies `ReadsOnlyDynamics`. -/
theorem alignmentSpine_readsOnlyDynamics {Pos F D : Type} (SpineLaw : D → Prop) :
    ReadsOnlyDynamics (Pos := Pos) (F := F)
      (fun d (_ : Pos → Nat → F → Prop) => SpineLaw d) :=
  readsOnlyDynamics_of SpineLaw

/-- Every verified spine persistence or collapse law equally admits a rival restricted significance
outside any excluded `(p, f)`. -/
theorem alignmentSpine_admits_rival {Pos F D : Type} (SpineLaw : D → Prop)
    {d : D} (holds : SpineLaw d) (sig : Pos → Nat → F → Prop)
    {region : Pos → F → Prop} (outside : ∃ p f, ¬ region p f) :
    SpineLaw d ∧ Rival (bounded region) ∧ ¬ Unrestricted (bounded region) :=
  ReadsOnlyDynamics.admits_rival (readsOnlyDynamics_of SpineLaw) (sig := sig) holds outside

/-- Direct `ReadsOnlyDynamics.not_entails` bridge at the composed alignment spine level. -/
theorem alignmentSpine_not_entails {Pos F D : Type} (SpineLaw : D → Prop)
    (entails : ∀ d (sig : Pos → Nat → F → Prop), SpineLaw d → Unrestricted sig)
    (p : Pos) (f : F) {d : D} : ¬ SpineLaw d :=
  ReadsOnlyDynamics.not_entails (readsOnlyDynamics_of SpineLaw) entails p f (sig := fun _ _ _ => True)

/-- Even the viable `MasterSpineWitness` cannot entail `Unrestricted sig`. -/
theorem alignmentSpine_cannot_entail_unrestricted {Pos F D : Type} (SpineLaw : D → Prop)
    (p : Pos) (f : F) {d : D} (holds : SpineLaw d) :
    ¬ (∀ d' (sig : Pos → Nat → F → Prop), SpineLaw d' → Unrestricted sig) :=
  fun entails => alignmentSpine_not_entails SpineLaw entails p f holds

/-! ### 2.2 Master Re-Export Atlas Theorems (Zero Duplication) -/

/-- Positive persistence & compositional viability witnesses across `L0–L3`, `1B–1C`, and `L5`. -/
theorem l0_l3_persistence_boundary {Pos F : Type} (p : Pos) (f : F) :
    (ComposedSpine.MasterSpineWitness.spineTaskModel.B_task = 42 ∧
      Viability.Kernel
        (OpenComposition.closedProcess ComposedSpine.MasterSpineWitness.witnessSpineComp
          ComposedSpine.MasterSpineWitness.witnessSpineContr ComposedSpine.MasterSpineWitness.witnessSpineObs
          ComposedSpine.MasterSpineWitness.witnessChannel ComposedSpine.MasterSpineWitness.gExt
          (fun _ _ => 0) (fun _ => True))
        (OpenComposition.closedGuard ComposedSpine.MasterSpineWitness.witnessSpineComp
          ComposedSpine.MasterSpineWitness.witnessSpineContr (fun _ => 10))
        (fun _ => 46, ComposedSpine.MasterSpineWitness.witnessSpineInit)) ∧
    Viability.Kernel
      (OpenComposition.prodProcess WitnessTwoScale.P WitnessTwoScale.P)
      (fun u => WitnessTwoScale.guardS u.1 ∧ WitnessTwoScale.guardS u.2)
      (WitnessTwoScale.s₀, WitnessTwoScale.s₀) ∧
    (∀ (drawA drawB : Nat → Nat) (nextA nextB : Nat → Unit → Nat) (rA rB : Nat),
      (∀ r, 1 ≤ drawA r) → (∀ r, 1 ≤ drawB r) →
      (Law.orbit (fun st =>
        (RegimeMargin.step (fun z => OpenComposition.WideningWitness.gShared () (fun _ => z))
          (drawA st.2.1 + drawB st.2.2) st.1,
         (nextA st.2.1 (), nextB st.2.2 ()))) (6, (rA, rB)) 6).1 = 0) ∧
    (∀ t, 9 ≤ (EndogenousTurning.TurningWitness.timelyOrbit t).1 ∧
      (EndogenousTurning.TurningWitness.timelyOrbit t).1 ≤ 50) ∧
    (∀ t, 9 ≤ EndogenousTurning.PartAWitness.constOrbit t ∧
      EndogenousTurning.PartAWitness.constOrbit t ≤ 50) ∧
    (∀ t, 9 ≤ EndogenousTurning.OpenCompositionBridge.ReconfigWitness.reconfigLevel t) ∧
    (∀ t, 9 ≤ (EndogenousTurning.OpenCompositionBridge.widenedClosedRun.state t).1 ()) ∧
    Viability.Kernel
      (OpenComposition.closedProcess
        (UnifiedDrawdown.OpenCompositionBridge.fleetComponent
          UnifiedDrawdown.OpenCompositionBridge.FleetWitness.agentA
          [UnifiedDrawdown.OpenCompositionBridge.FleetWitness.agentB,
           UnifiedDrawdown.OpenCompositionBridge.FleetWitness.agentC] 19)
        (UnifiedDrawdown.OpenCompositionBridge.fleetContract
          UnifiedDrawdown.OpenCompositionBridge.FleetWitness.agentA
          [UnifiedDrawdown.OpenCompositionBridge.FleetWitness.agentB,
           UnifiedDrawdown.OpenCompositionBridge.FleetWitness.agentC] 19)
        (UnifiedDrawdown.OpenCompositionBridge.fleetObs
          [UnifiedDrawdown.OpenCompositionBridge.FleetWitness.agentB,
           UnifiedDrawdown.OpenCompositionBridge.FleetWitness.agentC])
        (fun em _ _ => em) UnifiedDrawdown.OpenCompositionBridge.FleetWitness.fleetG
        (fun _ _ => 0) (fun (_ : Unit) => True))
      (OpenComposition.closedGuard
        (UnifiedDrawdown.OpenCompositionBridge.fleetComponent
          UnifiedDrawdown.OpenCompositionBridge.FleetWitness.agentA
          [UnifiedDrawdown.OpenCompositionBridge.FleetWitness.agentB,
           UnifiedDrawdown.OpenCompositionBridge.FleetWitness.agentC] 19)
        (UnifiedDrawdown.OpenCompositionBridge.fleetContract
          UnifiedDrawdown.OpenCompositionBridge.FleetWitness.agentA
          [UnifiedDrawdown.OpenCompositionBridge.FleetWitness.agentB,
           UnifiedDrawdown.OpenCompositionBridge.FleetWitness.agentC] 19)
        (fun _ => 4))
      ((fun _ => 14), UnifiedDrawdown.OpenCompositionBridge.fleetInit
        UnifiedDrawdown.OpenCompositionBridge.FleetWitness.agentA
        [UnifiedDrawdown.OpenCompositionBridge.FleetWitness.agentB,
         UnifiedDrawdown.OpenCompositionBridge.FleetWitness.agentC]) ∧
    (∀ t, ScopeDynamics.MutualFateWitness.system.wide.sub.level t = 9) ∧
    (∀ t, 8 ≤ ScopeDynamics.ReciprocalStabilityWitness.pool.substrate t ∧
      ScopeDynamics.ReciprocalStabilityWitness.pool.substrate t ≤ 12) ∧
    TransformsViably ScopeDynamics.ReciprocalStabilityWitness.pool.W_coop
      (fun t => 8 ≤ ScopeDynamics.ReciprocalStabilityWitness.pool.substrate t)
      ScopeDynamics.ReciprocalStabilityWitness.pool.cap 0 ∧
    (∀ t, 8 ≤ (ScopeDynamics.OpenCompositionBridge.reciprocalOpenRun.state t).1 ()) ∧
    ¬ (∀ (d : Nat) (sig : Pos → Nat → F → Prop),
        (∀ t, 8 ≤ (ScopeDynamics.OpenCompositionBridge.reciprocalOpenRun.state (t + d)).1 ()) →
        Unrestricted sig) ∧
    (∀ t, 5 ≤ (AdaptiveLoops.raceOrbit AdaptiveLoops.goodParams t).stock) ∧
    (∀ t, 6 ≤ (AdaptiveLoops.EndogenousCompositeWitness.endogRun.state t).1 ()) ∧
    StrictTransformativeViable ThreeRegime.web ThreeRegime.Viable ThreeRegime.cap
      ThreeRegime.l_evolve ThreeRegime.l_legacy ∧
    TransformsViably FiniteGainless.web (fun t => 1 ≤ FiniteGainless.web.level t .cSub)
      FiniteGainless.cap 0 :=
  ⟨⟨ComposedSpine.MasterSpineWitness.witness_viable.1, ComposedSpine.MasterSpineWitness.witness_viable.2.1⟩,
   OpenComposition.ComposedNonLumpingWitness.prod_viability_kernel,
   OpenComposition.widen_interface_heals_blindness.1,
   EndogenousTurning.TurningWitness.timely_survives.2.2.2.2.2.2.2.2.2,
   EndogenousTurning.PartAWitness.constrained_survives.2,
   EndogenousTurning.OpenCompositionBridge.ReconfigWitness.reconfig_witness_viable.2.2.2.2.2.2.2.2.2.2.2,
   EndogenousTurning.OpenCompositionBridge.widening_heals_witness.2.2.2,
   UnifiedDrawdown.OpenCompositionBridge.FleetWitness.witness_bundle.2.1,
   ScopeDynamics.MutualFateWitness.witness_holds.2.2.2.2.2.1,
   ScopeDynamics.ReciprocalStabilityWitness.witness_holds.2.2.2.2.2.2.2.2.2.1,
   ScopeDynamics.uncoord_vs_reciprocal_contrast.2.2.2.2.2.2.2.2.1,
   (ScopeDynamics.OpenCompositionBridge.blindDefector_vs_reciprocal_open p f).2.2.1.2.2.2,
   (ScopeDynamics.OpenCompositionBridge.blindDefector_vs_reciprocal_open p f).2.2.2,
   AdaptiveLoops.WitnessGood.2.2.2.2.2.2.2.2.2,
   AdaptiveLoops.EndogenousCompositeWitness.endog_bidirectional_adaptation.2.2.2.2.2.2.2.2.2,
   ThreeRegime.three_regime_separation.2.2.1,
   FiniteGainless.finite_gainless_transformsViably.2.2.2.2.2.2.1⟩

/-- Structural obstruction atlas across hidden coupling, exact lumping failure, epistemic silence,
rule capture, and uncoordinated commons invasion. -/
theorem structural_failure_atlas :
    (Law.orbit (fun st => OpenComposition.HiddenCouplingFailure.composedStep st ((), ((), ())))
      (fun _ => 4, ((), ())) 4).1 () = 0 ∧
    (¬ ∃ reduced, ProjectedLaws.Commuting
      (fun s (_ : Unit × Unit) => (WitnessTwoScale.next s.1 (), WitnessTwoScale.next s.2 ()))
      reduced
      (fun s => (WitnessTwoScale.π₂ (WitnessTwoScale.π₁ s.1),
                 WitnessTwoScale.π₂ (WitnessTwoScale.π₁ s.2)))) ∧
    ¬ ProjectedLaws.FibreConsistent WitnessTwoScale.next WitnessTwoScale.π₁ ∧
    (¬ ∃ reduced, ProjectedLaws.Commuting WitnessTwoScale.next reduced WitnessTwoScale.π₁) ∧
    (∀ x y, ¬ «续» Flame.step («核» Flame.step Flame.alike) x y) ∧
    EndogenousTurning.PartAWitness.unconstOrbit 6 = 0 ∧
    EndogenousTurning.TurningWitness.lateOrbit 11 = 0 ∧
    EndogenousTurning.TurningWitness.cascadeOrbit 11 = 0 ∧
    (Becoming.Clearing.web.SelectsThroughAll thresholdOnly
      Becoming.Clearing.clearerAndDweller 2 Becoming.Clearing.BothAdmitted ∧
     ¬ Becoming.Clearing.web.SelectsThrough thresholdOnly
      .clearer 2 Becoming.Clearing.BothAdmitted ∧
     ¬ Becoming.Clearing.web.SelectsThrough thresholdOnly
      .dweller 2 Becoming.Clearing.BothAdmitted) ∧
    ((AdaptiveLoops.raceOrbit AdaptiveLoops.silencedParams 6).stock = 0 ∧
     (AdaptiveLoops.raceOrbit AdaptiveLoops.uncoordParams 7).stock = 0 ∧
     (AdaptiveLoops.raceOrbit AdaptiveLoops.tooSlowParams 7).stock = 0) ∧
    (∀ r₀, ∃ T, T < 1 + 7 ∧
      (Pace.paced AdaptiveLoops.UnreadAdaptiveCollapse.jointF
        AdaptiveLoops.UnreadAdaptiveCollapse.jointH (fun _ => true) (((6, 6), 6), r₀) T).1.2 = 0) ∧
    (∀ t, t ≤ (ClosedCapture.Beyond.closed t).1.2 ∧
      RuleCapture.Locked RuleCapture.CarrierCounts.order RuleCapture.CarrierCounts.favours
        ClosedCapture.Beyond.closedRead ((ClosedCapture.Beyond.closed t).1.1, (ClosedCapture.Beyond.closed t).2)) ∧
    (∀ {r : Nat}, 1 ≤ r →
      ¬ RuleCapture.CarrierCounts.favours (ClosedCapture.Beyond.opened (r + 1)).2) ∧
    (∀ _k : Nat, ¬ RuleCapture.CarrierCounts.order.le
      (ClosedCapture.Thinned.inTime 2).1.1 (ClosedCapture.Thinned.inTime 3).1.1) ∧
    (∀ k : Nat, RuleCapture.Locked RuleCapture.CarrierCounts.order
      RuleCapture.CarrierCounts.favours (ClosedCapture.Drawn.poolRead RuleCapture.CarrierCounts.hi
        RuleCapture.CarrierCounts.lo)
      ((ClosedCapture.Thinned.late (3 + (1 + k))).1.1, (ClosedCapture.Thinned.late (3 + (1 + k))).2)) ∧
    (∀ t, 3 ≤ t → ScopeDynamics.UncoordCommonsWitness.commons.substrate t = 0 ∧
      ∀ k, ¬ ScopeDynamics.UncoordCommonsWitness.commons.W_coop.MacroAdmits
        ScopeDynamics.UncoordCommonsWitness.commons.cap
        (ScopeDynamics.UncoordCommonsWitness.commons.W_coop.level t) t k) :=
  ⟨OpenComposition.HiddenCouplingFailure.witness.2.2,
   OpenComposition.ComposedNonLumpingWitness.no_reduced_law_prod,
   WitnessTwoScale.not_fibreConsistent₁,
   WitnessTwoScale.no_reduced_law₁,
   «以核为判据则火无续».2.2,
   EndogenousTurning.PartAWitness.unconstrained_collapses.2.2.2.2.2.2.1,
   EndogenousTurning.TurningWitness.late_collapses.2.2.2.2.2.2.2.2.2.2.2.2.1,
   EndogenousTurning.TurningWitness.cascade_collapses.2.2.2.2.2.2.2.2.2.2.2.2.2.1,
   EndogenousTurning.PooledClearing.clearing_pooled_contrast,
   ⟨AdaptiveLoops.coupled_race_theorem.2.2.2.1.2,
    AdaptiveLoops.coupled_race_theorem.2.2.2.2.1.2,
    AdaptiveLoops.coupled_race_theorem.2.2.2.2.2.2⟩,
   AdaptiveLoops.UnreadAdaptiveCollapse.witness.2.2.2.1,
   fun t => ⟨(ClosedCapture.Beyond.closed_locked t).1, (ClosedCapture.Beyond.closed_locked t).2.1⟩,
   fun pos => ClosedCapture.Beyond.open_turned pos,
   fun k => (ClosedCapture.Thinned.inTime_turned k).2.2,
   fun k => (ClosedCapture.Thinned.late_kept k).2.1,
   ScopeDynamics.UncoordCommonsWitness.witness_holds.2.2.2.2.1⟩

/-- Conservation, pre-overdraw `Nat`-clamping separation, intra-span slack, and temporal-aliasing
boundaries (`CE05`, `CE06`). -/
theorem pre_overdraw_and_aliasing_boundaries :
    (∀ {F C : Type} {L : Flow F C} {W : Web F C} {cs : List C},
      L.Balances W → (∀ N, ∃ t, N ≤ t ∧ 0 < L.uptake cs t) → ∀ T, ¬ ∀ t, T ≤ t → L.replenishment cs t = 0) ∧
    (∀ {g d x : Nat → Nat}, (∀ t, x (t + 1) = RegimeMargin.step g (d t) (x t)) → ∀ t,
      (StockFlowBridge.unitFlow (EndogenousTurning.actualTake d x)
        (fun k => g (x k - EndogenousTurning.actualTake d x k))).BalancesOn (StockFlowBridge.unitWeb x) [()] t) ∧
    (¬ (StockFlowBridge.lineFlow UnifiedDrawdown.OverdrawSeparationWitness.need
          UnifiedDrawdown.OverdrawSeparationWitness.kids
          UnifiedDrawdown.OverdrawSeparationWitness.giving
          UnifiedDrawdown.OverdrawSeparationWitness.use
          UnifiedDrawdown.OverdrawSeparationWitness.startState).Balances
        (StockFlowBridge.lineWeb UnifiedDrawdown.OverdrawSeparationWitness.need
          UnifiedDrawdown.OverdrawSeparationWitness.kids
          UnifiedDrawdown.OverdrawSeparationWitness.giving
          UnifiedDrawdown.OverdrawSeparationWitness.use
          UnifiedDrawdown.OverdrawSeparationWitness.startState)) ∧
    Viability.Kernel (PacedStock.SlackShortWitness.frame.blocks PacedStock.SlackShortWitness.expand).P
      (fun s => PacedStock.SlackShortWitness.thr ≤ s.2) ([true], 5) ∧
    ¬ Viability.Kernel PacedStock.SlackShortWitness.frame.P
      (fun s => PacedStock.SlackShortWitness.thr ≤ s.2) ([true], 5) ∧
    Viability.Kernel PacedStock.SlackShortWitness.frame.P
      (fun s => PacedStock.SlackShortWitness.thr ≤ s.2) ([true], 6) ∧
    (∀ (L : Nat) (σ : Nat → Nat) (reads_s reads_b : Nat → Bool)
        (_h_s _h_b : PacedStock.StockState Nat PacedStock.SandwichWitness.UnitKind → (Nat × Nat) → (Nat × Nat)),
      L < 5 → σ 0 = 0 → σ 1 = L →
      Strict σ → PacedStock.ReadAtSpanEnd σ reads_s → PacedStock.ReadAtSpanEnd σ reads_b →
      ¬ Pace.StretchFixes Bool 3 L) ∧
    (Pace.StretchFixes Bool 2 3 ∧
      ∀ t, 4 ≤ t → 12 ≤ (PacedStock.SandwichWitness.feasRun t).1.2.2) ∧
    (∀ t, LineOnAStock.Goes UnifiedDrawdown.CadenceErasureWitness.need
      (PacedStock.pacedCourse UnifiedDrawdown.CadenceErasureWitness.fA
        UnifiedDrawdown.CadenceErasureWitness.need
        UnifiedDrawdown.CadenceErasureWitness.kids
        UnifiedDrawdown.CadenceErasureWitness.giving
        UnifiedDrawdown.CadenceErasureWitness.use
        UnifiedDrawdown.CadenceErasureWitness.h
        UnifiedDrawdown.CadenceErasureWitness.readsFine
        UnifiedDrawdown.CadenceErasureWitness.startConfig t).1.2) ∧
    ¬ LineOnAStock.Goes UnifiedDrawdown.CadenceErasureWitness.need
      (PacedStock.pacedCourse UnifiedDrawdown.CadenceErasureWitness.fA
        UnifiedDrawdown.CadenceErasureWitness.need
        UnifiedDrawdown.CadenceErasureWitness.kids
        UnifiedDrawdown.CadenceErasureWitness.giving
        UnifiedDrawdown.CadenceErasureWitness.use
        UnifiedDrawdown.CadenceErasureWitness.h
        UnifiedDrawdown.CadenceErasureWitness.readsCoarse
        UnifiedDrawdown.CadenceErasureWitness.startConfig 6).1.2 :=
  ⟨fun hBal hUp T => Flow.uptake_needs_replenishment hBal hUp T,
   fun step_eq t => EndogenousTurning.clamped_balances_trap step_eq t,
   UnifiedDrawdown.OverdrawSeparationWitness.witness_bundle.2.2.1,
   PacedStock.SlackShortWitness.atFive_block_kernel,
   PacedStock.SlackShortWitness.atFive_not_fine_kernel,
   PacedStock.SlackShortWitness.atSix_fine_kernel_by_slack,
   fun L σ rs rb hs hb hL σ0 σ1 strict cs cb =>
     (PacedStock.SandwichWitness.imp_coupled_witness.1 L σ rs rb hs hb hL σ0 σ1 strict cs cb).1,
   ⟨PacedStock.SandwichWitness.feas_witness.1,
    fun t ht => (PacedStock.SandwichWitness.feas_witness.2 t ht).1⟩,
   UnifiedDrawdown.CadenceErasureWitness.witness_bundle.2.2.1,
   UnifiedDrawdown.CadenceErasureWitness.witness_bundle.2.2.2.2⟩

/-- Coupling blindness, route-(b) closure limits, and `ReadsOnlyDynamics` / `ReadsNoOrder`
non-entailment boundaries across `L0–L5`. -/
theorem epistemic_scope_metaethical_boundary {Pos F : Type} (p : Pos) (f : F) :
    (∀ {F₀ C₀ : Type} {L : Flow F₀ C₀} {W : Web F₀ C₀} {obs : F₀ → C₀ → Prop} {part : F₀ → Bool}
        {select : (Nat → C₀ → Nat) → Prop} {l : Nat → C₀ → Nat} {f₀ g₀ : F₀} {t : Nat},
      L.WithheldLevels part W l →
      (∀ t g c, L.WithinCoupling W obs f₀ g → W.CoupledInto obs g c → L.BalancesOn W [c] t) →
      (∀ h, part h = true → ¬ L.WithinCoupling W obs f₀ h) →
      L.WithinCoupling W obs f₀ g₀ →
      W.SelectsThrough obs g₀ t select →
      (select W.level ↔ select l)) ∧
    (∀ {F₀ Pos₀ : Type},
      (∀ (rel : F₀ → F₀ → Prop) (center : Pos₀ → F₀),
        Unrestricted (selfAscribed (ownClosure rel) center) ↔ ∀ p g, WithinClosure rel (center p) g) ∧
      (∀ (rel : F₀ → F₀ → Prop) (center : Pos₀ → F₀),
        «无环» rel → ∀ p q, center p ≠ center q → ¬ Unrestricted (selfAscribed (ownClosure rel) center))) ∧
    (∀ {D : Type} (law : D → Prop),
      (∀ d (sig : Pos → Nat → F → Prop), law d → Unrestricted sig) → ∀ d : D, ¬ law d) ∧
    (¬ ∀ (_u : Unit) (sig : Pos → Nat → Optimum.HeldPair.Member → Prop),
      (∀ t, t < 2 → Optimum.HeldPair.flow.WithinOwn t .pool ∧ ¬ Optimum.HeldPair.flow.WithinJoint t .pool) →
      Unrestricted sig) ∧
    (∀ {D : Type} (ScopeLaw : D → Prop) {d : D}, ScopeLaw d →
      ¬ (∀ d' (sig : Pos → Nat → F → Prop), ScopeLaw d' → Unrestricted sig)) ∧
    (∀ {S A C D : Type} {law : D → (S → S → Prop) → Prop},
      ReadsNoOrder law → ∀ {frame : Frame S A C} {living : C → Prop} {d : D},
      (∀ better, law d better → Comparison frame living better) →
      ∀ {s t : S}, Extension frame living s t → ∀ {better : S → S → Prop}, ¬ law d better) ∧
    (∀ {D : Type} (SpineLaw : D → Prop) {d : D}, SpineLaw d →
      ¬ (∀ d' (sig : Pos → Nat → F → Prop), SpineLaw d' → Unrestricted sig)) :=
  ⟨fun without bal bey within through => Flow.unselected_beyond_coupling without bal bey within through,
   ⟨(routeB_universal_closed (C := Unit)).1, (routeB_universal_closed (C := Unit)).2.1⟩,
   fun law entails d => UnifiedDrawdown.unifiedDrawdown_not_entails law entails p f d,
   (UnifiedDrawdown.witnessed_dynamics_not_entails p).1,
   fun {_} ScopeLaw {_} holds => ScopeDynamics.scopeLaw_cannot_entail_unrestricted ScopeLaw p f holds,
   fun {_ _ _ _ _} reads {_ _ _} entails {_ _} ext => ReadsNoOrder.not_entails reads entails ext,
   fun {_} SpineLaw {_} holds => alignmentSpine_cannot_entail_unrestricted SpineLaw p f holds⟩

/-- **Top-level structural alignment dichotomy (`master_alignment_dichotomy`)**: joins a
representative 7-conjunct headline slice across `l0_l3_persistence_boundary`, `structural_failure_atlas`,
`pre_overdraw_and_aliasing_boundaries`, and `epistemic_scope_metaethical_boundary` (each of those
four exported theorems exposes the complete unprojected bundle). -/
theorem master_alignment_dichotomy {Pos F : Type} (p : Pos) (f : F) :
    (ComposedSpine.MasterSpineWitness.spineTaskModel.B_task = 42 ∧
      Viability.Kernel
        (OpenComposition.closedProcess ComposedSpine.MasterSpineWitness.witnessSpineComp
          ComposedSpine.MasterSpineWitness.witnessSpineContr ComposedSpine.MasterSpineWitness.witnessSpineObs
          ComposedSpine.MasterSpineWitness.witnessChannel ComposedSpine.MasterSpineWitness.gExt
          (fun _ _ => 0) (fun _ => True))
        (OpenComposition.closedGuard ComposedSpine.MasterSpineWitness.witnessSpineComp
          ComposedSpine.MasterSpineWitness.witnessSpineContr (fun _ => 10))
        (fun _ => 46, ComposedSpine.MasterSpineWitness.witnessSpineInit)) ∧
    (∀ (drawA drawB : Nat → Nat) (nextA nextB : Nat → Unit → Nat) (rA rB : Nat),
      (∀ r, 1 ≤ drawA r) → (∀ r, 1 ≤ drawB r) →
      (Law.orbit (fun st =>
        (RegimeMargin.step (fun z => OpenComposition.WideningWitness.gShared () (fun _ => z))
          (drawA st.2.1 + drawB st.2.2) st.1,
         (nextA st.2.1 (), nextB st.2.2 ()))) (6, (rA, rB)) 6).1 = 0) ∧
    (Law.orbit (fun st => OpenComposition.HiddenCouplingFailure.composedStep st ((), ((), ())))
      (fun _ => 4, ((), ())) 4).1 () = 0 ∧
    (∀ t, 3 ≤ t → ScopeDynamics.UncoordCommonsWitness.commons.substrate t = 0 ∧
      ∀ k, ¬ ScopeDynamics.UncoordCommonsWitness.commons.W_coop.MacroAdmits
        ScopeDynamics.UncoordCommonsWitness.commons.cap
        (ScopeDynamics.UncoordCommonsWitness.commons.W_coop.level t) t k) ∧
    Viability.Kernel PacedStock.SlackShortWitness.frame.P
      (fun s => PacedStock.SlackShortWitness.thr ≤ s.2) ([true], 6) ∧
    ¬ Viability.Kernel PacedStock.SlackShortWitness.frame.P
      (fun s => PacedStock.SlackShortWitness.thr ≤ s.2) ([true], 5) ∧
    (∀ {D : Type} (SpineLaw : D → Prop) {d : D}, SpineLaw d →
      ¬ (∀ d' (sig : Pos → Nat → F → Prop), SpineLaw d' → Unrestricted sig)) :=
  let hP := l0_l3_persistence_boundary p f
  let hF := structural_failure_atlas
  let hA := pre_overdraw_and_aliasing_boundaries
  let hM := epistemic_scope_metaethical_boundary p f
  ⟨hP.1, hP.2.2.1, hF.1, hF.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2, hA.2.2.2.2.2.1, hA.2.2.2.2.1, hM.2.2.2.2.2.2⟩

end AlignmentDichotomy

/-! ## Part 3: Hypothesis-Dropping Sharpness & `文理生生 v0.2` Suite (`SharpnessSuite`) -/

namespace SharpnessSuite

/-! ### 3.1 `L5-CE01a`: `ReconfigCountdownJumpFails` -/

namespace ReconfigCountdownJumpFails

def gSub (_ : Unit) (e : Unit → Nat) : Nat := if 2 ≤ e () then 1 else 0

theorem gSub_rises : ∀ k : Unit, RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (gSub k) :=
  fun _ e _ below =>
    match Nat.decLe 2 (e ()) with
    | isTrue h => Nat.le_trans (Nat.le_of_eq (if_pos h))
        (Nat.le_of_eq (if_pos (Nat.le_trans h (below ()))).symm)
    | isFalse h => Nat.le_trans (Nat.le_of_eq (if_neg h)) (Nat.zero_le _)

def channel (em : Bool) (load : Nat) (_ : Unit) : Bool := em && Nat.ble load 0

def compA : OpenComposition.OpenComponent Bool Nat Unit Empty Unit where
  next s oa _ := if oa.2 then false else s
  drawInt _ e := Empty.elim e
  drawExt s _ := match s with | false => 1 | true => 2
  emitAlarm _ o := Nat.blt o 7
  silenceLoad _ := 0
  favours s := s = true

def contractA (init : Bool) : OpenComposition.InterfaceContract compA init where
  tol _ _ := True
  warnObs o := o < 7
  preCapInt e := Empty.elim e
  preCapExt _ := 2
  postBudgetInt e := Empty.elim e
  postBudgetExt _ := 1
  maxSilence := 0
  maxLag := 1
  K _ := True
  eta s := match s with | false => 0 | true => 1
  init_in := trivial
  cert := Viability.certificate_disturbed_iff.mpr
    ⟨fun s _ =>
      ⟨fun e => Empty.elim e,
       fun _ => by
         cases s with
         | false => exact Nat.le_succ 1
         | true => exact Nat.le_refl 2,
       Nat.le_refl 0,
       fun h0 => by
         cases s with
         | false => exact ⟨fun h => Bool.noConfusion h, fun e => Empty.elim e, fun _ => Nat.le_refl 1⟩
         | true => exact Nat.noConfusion h0⟩,
     fun _ _ _ _ => trivial⟩
  eta_bound s _ := by
    cases s with
    | false => exact Nat.zero_le 1
    | true => exact Nat.le_refl 1
  emits_on_warn _ o _ lt := AdaptiveLoops.natBlt_true_iff.mpr lt
  eta_alarm_step s _ _ _ _ pos := by
    cases s with
    | false => exact absurd pos (Nat.lt_irrefl 0)
    | true => exact Nat.zero_lt_one
  eta_alarm_zero s _ _ _ _ h0 := by
    cases s with
    | false => rfl
    | true => exact Nat.noConfusion h0

def compA' : OpenComposition.OpenComponent Nat Nat Unit Unit Unit where
  next s oa _ := if oa.2 then 0 else s
  drawInt s _ := s
  drawExt s _ := match s with | 0 => 1 | _ + 1 => 2
  emitAlarm _ o := Nat.blt o 7
  silenceLoad _ := 0
  favours s := s ≠ 0

def contractA' : OpenComposition.InterfaceContract compA' 1 where
  tol _ _ := True
  warnObs o := o < 7
  preCapInt _ := 1
  preCapExt _ := 2
  postBudgetInt _ := 0
  postBudgetExt _ := 1
  maxSilence := 0
  maxLag := 1
  K s := s ≤ 1
  eta s := match s with | 0 => 0 | _ + 1 => 1
  init_in := Nat.le_refl 1
  cert := Viability.certificate_disturbed_iff.mpr
    ⟨fun s hs =>
      ⟨fun _ => hs,
       fun _ => by
         cases s with
         | zero => exact Nat.le_succ 1
         | succ _ => exact Nat.le_refl 2,
       Nat.le_refl 0,
       fun h0 => by
         cases s with
         | zero => exact ⟨fun ne => ne rfl, fun _ => Nat.le_refl 0, fun _ => Nat.le_refl 1⟩
         | succ _ => exact Nat.noConfusion h0⟩,
     fun s oa _ hs => by
       show (if oa.1.2 then 0 else s) ≤ 1
       cases oa.1.2 with
       | false => exact hs
       | true => exact Nat.zero_le 1⟩
  eta_bound s _ := by
    cases s with
    | zero => exact Nat.zero_le 1
    | succ _ => exact Nat.le_refl 1
  emits_on_warn _ o _ lt := AdaptiveLoops.natBlt_true_iff.mpr lt
  eta_alarm_step s _ _ _ _ pos := by
    cases s with
    | zero => exact absurd pos (Nat.lt_irrefl 0)
    | succ _ => exact Nat.zero_lt_one
  eta_alarm_zero s _ _ _ _ h0 := by
    cases s with
    | zero => rfl
    | succ _ => exact Nat.noConfusion h0

/-- Unchecked reconfiguration process dropping ONLY `cA'.eta s' ≤ cA.eta st₁.2` while keeping `cA'.K s'`. -/
def uncheckedReconfigProcess :
    Process (Sum ((Unit → Nat) × Bool) ((Unit → Nat) × Nat))
      (OpenComposition.ReconfigAct Unit Unit Unit Nat) where
  step st act st' := match st with
    | .inl st₁ => match act with
      | .stepLeft env d =>
        st' = .inl (OpenComposition.closedStep compA (fun x => x ()) channel gSub (fun _ _ => 0) st₁ (env, d))
      | .stepRight _ _ => False
      | .reconfig s' => contractA'.K s' ∧ st' = .inr (st₁.1, s')
    | .inr st₂ => match act with
      | .stepLeft _ _ => False
      | .stepRight env d' =>
        st' = .inr (OpenComposition.closedStep compA' (fun x => x ()) channel gSub (fun _ _ => 0) st₂ (env, d'))
      | .reconfig _ => False

def st1 : (Unit → Nat) × Nat :=
  OpenComposition.closedStep compA' (fun x => x ()) channel gSub (fun _ _ => 0) (fun _ => 3, 1) ((), ())

def st2 : (Unit → Nat) × Nat :=
  OpenComposition.closedStep compA' (fun x => x ()) channel gSub (fun _ _ => 0) st1 ((), ())

theorem witness :
    Viability.Kernel
      (OpenComposition.ReconfigProcess compA compA' (contractA false) contractA'
        (fun x => x ()) (fun x => x ()) channel gSub (fun _ _ => 0) (fun _ => True))
      (fun st => match st with
        | .inl st₁ => OpenComposition.closedGuard compA (contractA false) (fun _ => 3) st₁
        | .inr st₂ => OpenComposition.closedGuard compA' contractA' (fun _ => 3) st₂)
      (.inl (fun _ => 3, false)) ∧
    Viability.Kernel
      (OpenComposition.closedProcess compA' contractA' (fun x => x ()) channel gSub (fun _ _ => 0) (fun _ => True))
      (OpenComposition.closedGuard compA' contractA' (fun _ => 3))
      (fun _ => 5, 1) ∧
    compA'.drawInt 1 () = 1 ∧
    ¬ (OpenComposition.ReconfigProcess compA compA' (contractA false) contractA'
        (fun x => x ()) (fun x => x ()) channel gSub (fun _ _ => 0) (fun _ => True)).step
        (.inl (fun _ => 3, false)) (.reconfig 1) (.inr (fun _ => 3, 1)) ∧
    Trace uncheckedReconfigProcess (.inl (fun _ => 3, false))
      [.reconfig 1, .stepRight () (), .stepRight () ()] (.inr st2) ∧
    st1.1 () = 1 ∧
    st1.1 () < 3 ∧
    st2.1 () = 0 := by
  have kern := OpenComposition.rewrite_step_viable compA compA' (contractA false) contractA'
    (fun x => x ()) (fun x => x ()) channel gSub (fun _ _ => 0) (fun _ => 0) (fun _ => True)
    (fun _ _ _ => Nat.zero_le 0) (fun _ => 3) (fun _ => 7) (fun _ => 1) (fun _ => 3)
    (fun _ => Nat.le_refl 2) (fun _ => Nat.le_refl 1) (Nat.le_refl 0) (Nat.le_refl 1)
    (fun _ _ lt => lt) (fun _ _ lt => lt)
    (fun load _ _ (le : load ≤ 0) => by
      show (true && Nat.ble load 0) = true
      rw [Nat.ble_eq_true_of_le le]
      rfl)
    gSub_rises (fun k => by cases k; show 3 ≤ 3 - 1 + gSub () (fun _ => 3 - 1); exact by decide)
    (fun _ => Nat.le_refl 1) (fun k => by cases k; exact by decide) (fun k => by cases k; exact by decide)
  have guardedKern :
      Viability.Kernel
        (OpenComposition.ReconfigProcess compA compA' (contractA false) contractA'
          (fun x => x ()) (fun x => x ()) channel gSub (fun _ _ => 0) (fun _ => True))
        (fun st => match st with
          | .inl st₁ => OpenComposition.closedGuard compA (contractA false) (fun _ => 3) st₁
          | .inr st₂ => OpenComposition.closedGuard compA' contractA' (fun _ => 3) st₂)
        (.inl (fun _ => 3, false)) := by
    intro st hReach
    have hSt := kern st hReach
    cases st with
    | inl st₁ => exact hSt
    | inr st₂ => exact hSt
  have soloA' :
      Viability.Kernel
        (OpenComposition.closedProcess compA' contractA' (fun x => x ()) channel gSub (fun _ _ => 0) (fun _ => True))
        (OpenComposition.closedGuard compA' contractA' (fun _ => 3))
        (fun _ => 5, 1) :=
    OpenComposition.close_contract_kernel compA' contractA' (fun x => x ()) channel gSub (fun _ _ => 0)
      (fun _ => 0) (fun _ => True) (fun _ _ _ => Nat.zero_le 0) (fun _ => 3) (fun _ => 7) (fun _ => 1)
      (fun _ => 5) (fun _ _ lt => lt)
      (fun load _ _ (le : load ≤ 0) => by
        show (true && Nat.ble load 0) = true
        rw [Nat.ble_eq_true_of_le le]
        rfl)
      gSub_rises (fun k => by cases k; show 3 ≤ 3 - 1 + gSub () (fun _ => 3 - 1); exact by decide)
      (fun _ => Nat.le_refl 1) (fun k => by cases k; exact by decide) (fun k => by cases k; exact by decide)
  have trFail : Trace uncheckedReconfigProcess (.inl (fun _ => 3, false))
      [.reconfig 1, .stepRight () (), .stepRight () ()] (.inr st2) :=
    .cons ⟨Nat.le_refl 1, rfl⟩ (.cons rfl (.cons rfl (.nil _)))
  exact ⟨guardedKern, soloA', rfl, fun ⟨_, hEta, _⟩ => Nat.not_succ_le_zero 0 hEta,
    trFail, rfl, by decide, rfl⟩

end ReconfigCountdownJumpFails

/-! ### 3.2 & 3.3 `L5-CE01b` (`BlindHideCollapse`) & `L5-CE14` (`HideSideChannelLeakage`) -/

namespace BlindHideCollapse

def gUnit (_ : Unit) (e : Unit → Nat) : Nat := if 2 ≤ e () then 1 else 0

theorem gUnit_rises : ∀ k : Unit, RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (gUnit k) :=
  fun _ e _ below =>
    match Nat.decLe 2 (e ()) with
    | isTrue h => Nat.le_trans (Nat.le_of_eq (if_pos h))
        (Nat.le_of_eq (if_pos (Nat.le_trans h (below ()))).symm)
    | isFalse h => Nat.le_trans (Nat.le_of_eq (if_neg h)) (Nat.zero_le _)

def compC : OpenComposition.OpenComponent Bool Bool Unit Empty (Sum Unit Unit) where
  next s oa _ := if oa.2 then false else s
  drawInt _ e := Empty.elim e
  drawExt s
    | .inl () => 1
    | .inr () => match s with | false => 1 | true => 2
  emitAlarm _ o := o
  silenceLoad _ := 0
  favours s := s = true

def contractC : OpenComposition.InterfaceContract compC true where
  tol _ _ := True
  warnObs o := o = true
  preCapInt e := Empty.elim e
  preCapExt
    | .inl () => 1
    | .inr () => 2
  postBudgetInt e := Empty.elim e
  postBudgetExt _ := 1
  maxSilence := 0
  maxLag := 1
  K _ := True
  eta s := match s with | false => 0 | true => 1
  init_in := trivial
  cert := Viability.certificate_disturbed_iff.mpr
    ⟨fun s _ =>
      ⟨fun e => Empty.elim e,
       fun k => match k with
         | .inl () => Nat.le_refl 1
         | .inr () => match s with | false => Nat.le_succ 1 | true => Nat.le_refl 2,
       Nat.le_refl 0,
       fun h0 => by
         cases s with
         | false => exact ⟨fun h => Bool.noConfusion h, fun e => Empty.elim e,
             fun k => match k with | .inl () => Nat.le_refl 1 | .inr () => Nat.le_refl 1⟩
         | true => exact Nat.noConfusion h0⟩,
     fun _ _ _ _ => trivial⟩
  eta_bound s _ := match s with | false => Nat.zero_le 1 | true => Nat.le_refl 1
  emits_on_warn _ _ _ hw := hw
  eta_alarm_step s _ _ _ _ pos := by
    cases s with
    | false => exact absurd pos (Nat.lt_irrefl 0)
    | true => exact Nat.zero_lt_one
  eta_alarm_zero s _ _ _ _ h0 := by
    cases s with
    | false => rfl
    | true => exact Nat.noConfusion h0

def wireSafe (o : Bool) (xh : Unit → Nat) : Bool := o || Nat.blt (xh ()) 7
def wireBlind (o : Bool) (_ : Unit → Nat) : Bool := o

def hiddenSafeComp := OpenComposition.OpenComponent.hide compC gUnit wireSafe
def hiddenBlindComp := OpenComposition.OpenComponent.hide compC gUnit wireBlind

def hiddenSafeContr :=
  OpenComposition.hideContract contractC gUnit wireSafe (fun _ _ => True) (fun o => o = true)
    (fun _ => 3) (fun _ => 7) (fun _ => 1) (fun _ => 5)
    (fun _ _ _ _ _ _ => trivial) gUnit_rises
    (fun o xh hw => by
      show (o || Nat.blt (xh ()) 7) = true
      rw [show o = true from hw]
      rfl)
    (fun _ _ ⟨k, hk⟩ => by
      cases k
      exact (congrArg (_ || ·) (AdaptiveLoops.natBlt_true_iff.mpr hk)).trans
        (OpenComposition.bool_or_true_right _))
    (fun k => by cases k; show 3 ≤ 3 - 1 + gUnit () (fun _ => 3 - 1); exact by decide)
    (fun k => by cases k; exact Nat.le_refl 1)
    (fun k => by cases k; exact by decide)
    (fun k => by cases k; exact by decide)

def safeOrbit : Nat → (Unit → Nat) × (Bool × (Unit → Nat)) :=
  Law.orbit
    (fun st => OpenComposition.closedStep hiddenSafeComp (fun x => Nat.blt (x ()) 6)
      (fun em _ _ => em) gUnit (fun _ _ => 0) st ((), ()))
    (fun _ => 6, (true, fun _ => 5))

def blindOrbit : Nat → (Unit → Nat) × (Bool × (Unit → Nat)) :=
  Law.orbit
    (fun st => OpenComposition.closedStep hiddenBlindComp (fun x => Nat.blt (x ()) 6)
      (fun em _ _ => em) gUnit (fun _ _ => 0) st ((), ()))
    (fun _ => 6, (true, fun _ => 5))

theorem blind_keep_const : ∀ t, (blindOrbit t).1 () = 6
  | 0 => rfl
  | t + 1 => by
    show (OpenComposition.closedStep hiddenBlindComp (fun x => Nat.blt (x ()) 6)
      (fun em _ _ => em) gUnit (fun _ _ => 0) (blindOrbit t) ((), ())).1 () = 6
    have ih := blind_keep_const t
    show ((blindOrbit t).1 () - 1) + gUnit () (fun _ => (blindOrbit t).1 () - 1) = 6
    rw [ih]
    rfl

theorem witness :
    Viability.Kernel
      (OpenComposition.closedProcess hiddenSafeComp hiddenSafeContr
        (fun x => Nat.blt (x ()) 6) (fun (em : Bool) (_ : Nat) (_ : Unit) => em) gUnit (fun _ _ => 0) (fun (_ : Unit) => True))
      (OpenComposition.closedGuard hiddenSafeComp hiddenSafeContr (fun _ => 3))
      (fun _ => 6, (true, fun _ => 5)) ∧
    ((safeOrbit 0).1 () = 6 ∧ (safeOrbit 1).1 () = 6 ∧
     (safeOrbit 0).2.2 () = 5 ∧ (safeOrbit 1).2.2 () = 4 ∧ (safeOrbit 2).2.2 () = 4) ∧
    hiddenSafeComp.drawInt (true, fun _ => 5) (.inr ()) = 2 ∧
    hiddenSafeComp.drawInt (false, fun _ => 4) (.inr ()) = 1 ∧
    (¬ ∀ o xh, (∃ k : Unit, xh k < 7) → wireBlind o xh = true) ∧
    (∀ t, (blindOrbit t).1 () = 6) ∧
    ((blindOrbit 0).2.2 () = 5 ∧ (blindOrbit 1).2.2 () = 4 ∧
     (blindOrbit 2).2.2 () = 3 ∧ (blindOrbit 3).2.2 () = 1 ∧
     (blindOrbit 4).2.2 () = 0) := by
  have kernSafe :
      Viability.Kernel
        (OpenComposition.closedProcess hiddenSafeComp hiddenSafeContr
          (fun x => Nat.blt (x ()) 6) (fun (em : Bool) (_ : Nat) (_ : Unit) => em) gUnit (fun _ _ => 0) (fun (_ : Unit) => True))
        (OpenComposition.closedGuard hiddenSafeComp hiddenSafeContr (fun _ => 3))
        (fun _ => 6, (true, fun _ => 5)) :=
    OpenComposition.close_contract_kernel hiddenSafeComp hiddenSafeContr
      (fun x => Nat.blt (x ()) 6) (fun (em : Bool) (_ : Nat) (_ : Unit) => em) gUnit (fun _ _ => 0) (fun _ => 0)
      (fun (_ : Unit) => True) (fun _ _ _ => Nat.zero_le 0) (fun _ => 3) (fun _ => 6) (fun _ => 1)
      (fun _ => 6)
      (fun _ k lt => by cases k; exact AdaptiveLoops.natBlt_true_iff.mpr lt)
      (fun _ _ _ _ => rfl)
      gUnit_rises (fun k => by cases k; show 3 ≤ 3 - 1 + gUnit () (fun _ => 3 - 1); exact by decide)
      (fun _ => Nat.le_refl 1) (fun k => by cases k; exact by decide) (fun k => by cases k; exact by decide)
  exact ⟨kernSafe, ⟨rfl, rfl, rfl, rfl, rfl⟩, rfl, rfl,
    fun h => Bool.noConfusion (h false (fun _ => 5) ⟨(), by decide⟩),
    blind_keep_const, ⟨rfl, rfl, rfl, rfl, rfl⟩⟩

end BlindHideCollapse

/-- **`L5-CE14` (`HideSideChannelLeakage`)**: Exact dual of `L5-CE01b` — even when `wireSafe`
satisfies `wire_hide_warn` and `hideContract_keeps_hidden`, `OpenComponent.hide.emitAlarm` leaks
hidden-substrate threshold crossings across identical outer state `true` and observation `false`. -/
theorem hide_side_channel_leakage :
    BlindHideCollapse.hiddenSafeComp.emitAlarm (true, fun _ => 5) false = true ∧
    BlindHideCollapse.hiddenSafeComp.emitAlarm (true, fun _ => 8) false = false ∧
    BlindHideCollapse.hiddenSafeComp.emitAlarm (true, fun _ => 5) false ≠
      BlindHideCollapse.hiddenSafeComp.emitAlarm (true, fun _ => 8) false :=
  ⟨rfl, rfl, Bool.noConfusion⟩

/-! ### 3.4 `L5-CE02`: `TypeSameSemanticsMismatch` -/

namespace TypeSameSemanticsMismatch

def gSub (_ : Unit) (e : Unit → Nat) : Nat := if 2 ≤ e () then 1 else 0

theorem gSub_rises : ∀ k : Unit, RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (gSub k) :=
  fun _ e _ below =>
    match Nat.decLe 2 (e ()) with
    | isTrue h => Nat.le_trans (Nat.le_of_eq (if_pos h))
        (Nat.le_of_eq (if_pos (Nat.le_trans h (below ()))).symm)
    | isFalse h => Nat.le_trans (Nat.le_of_eq (if_neg h)) (Nat.zero_le _)

def mkComp (thr : Nat) : OpenComposition.OpenComponent Bool Nat Unit Empty Unit where
  next s oa _ := if oa.2 then false else s
  drawInt _ e := Empty.elim e
  drawExt s _ := match s with | false => 1 | true => 2
  emitAlarm _ o := Nat.blt o thr
  silenceLoad _ := 0
  favours s := s = true

def mkContract (thr : Nat) : OpenComposition.InterfaceContract (mkComp thr) true where
  tol _ _ := True
  warnObs o := o < thr
  preCapInt e := Empty.elim e
  preCapExt _ := 2
  postBudgetInt e := Empty.elim e
  postBudgetExt _ := 1
  maxSilence := 0
  maxLag := 1
  K _ := True
  eta s := match s with | false => 0 | true => 1
  init_in := trivial
  cert := Viability.certificate_disturbed_iff.mpr
    ⟨fun s _ =>
      ⟨fun e => Empty.elim e,
       fun _ => match s with | false => Nat.le_succ 1 | true => Nat.le_refl 2,
       Nat.le_refl 0,
       fun h0 => by
         cases s with
         | false => exact ⟨fun h => Bool.noConfusion h, fun e => Empty.elim e, fun _ => Nat.le_refl 1⟩
         | true => exact Nat.noConfusion h0⟩,
     fun _ _ _ _ => trivial⟩
  eta_bound s _ := match s with | false => Nat.zero_le 1 | true => Nat.le_refl 1
  emits_on_warn _ o _ lt := AdaptiveLoops.natBlt_true_iff.mpr lt
  eta_alarm_step s _ _ _ _ pos := by
    cases s with
    | false => exact absurd pos (Nat.lt_irrefl 0)
    | true => exact Nat.zero_lt_one
  eta_alarm_zero s _ _ _ _ h0 := by
    cases s with
    | false => rfl
    | true => exact Nat.noConfusion h0

def dummyB : OpenComposition.OpenComponent Unit Unit Unit Empty Unit :=
  ScopeDynamics.OpenCompositionBridge.coopComponent 0

def dummyContract := ScopeDynamics.OpenCompositionBridge.coopContract 0

def badOrbit : Nat → (Unit → Nat) × (Bool × Unit) :=
  Law.orbit
    (fun st => OpenComposition.closedStep (OpenComposition.OpenComponent.compose (mkComp 3) dummyB)
      (fun x => (x (), ())) (fun em _ _ => em) gSub (fun _ _ => 0) st ((), ((), ())))
    (fun _ => 5, (true, ()))

theorem witness :
    Viability.Kernel
      (OpenComposition.closedProcess (OpenComposition.OpenComponent.compose (mkComp 7) dummyB)
        (OpenComposition.composeContract (mkContract 7) dummyContract)
        (fun x => (x (), ())) (fun (em : Bool) (_ : Nat) (_ : Unit) => em) gSub (fun _ _ => 0) (fun (_ : Unit) => True))
      (OpenComposition.closedGuard (OpenComposition.OpenComponent.compose (mkComp 7) dummyB)
        (OpenComposition.composeContract (mkContract 7) dummyContract) (fun _ => 3))
      (fun _ => 5, (true, ())) ∧
    ((∀ k, (mkContract 3).preCapExt k ≤ (mkContract 7).preCapExt k) ∧
     (∀ k, (mkContract 3).postBudgetExt k ≤ (mkContract 7).postBudgetExt k) ∧
     (mkContract 3).maxSilence ≤ (mkContract 7).maxSilence ∧
     (mkContract 3).maxLag ≤ (mkContract 7).maxLag ∧
     (mkContract 3).eta true ≤ (mkContract 7).eta true) ∧
    (¬ OpenComposition.ContractRefines (mkContract 7) (mkContract 3)
      (fun x => x ()) (fun x => x ()) (fun _ => 7)) ∧
    ((badOrbit 0).1 () = 5 ∧ (badOrbit 1).1 () = 4 ∧ (badOrbit 2).1 () = 3 ∧
     (badOrbit 3).1 () = 1 ∧ (badOrbit 4).1 () = 0) := by
  have kernGood :
      Viability.Kernel
        (OpenComposition.closedProcess (OpenComposition.OpenComponent.compose (mkComp 7) dummyB)
          (OpenComposition.composeContract (mkContract 7) dummyContract)
          (fun x => (x (), ())) (fun (em : Bool) (_ : Nat) (_ : Unit) => em) gSub (fun _ _ => 0) (fun (_ : Unit) => True))
        (OpenComposition.closedGuard (OpenComposition.OpenComponent.compose (mkComp 7) dummyB)
          (OpenComposition.composeContract (mkContract 7) dummyContract) (fun _ => 3))
        (fun _ => 5, (true, ())) :=
    OpenComposition.compose_close_interchange (mkComp 7) dummyB (mkContract 7) dummyContract
      (fun x => x ()) (fun _ => ()) (fun (em : Bool) (_ : Nat) (_ : Unit) => em) gSub (fun _ _ => 0) (fun _ => 0) (fun (_ : Unit) => True)
      (fun _ _ _ => Nat.zero_le 0) (fun _ => 3) (fun _ => 7) (fun _ => 1) (fun _ => 5)
      (fun _ k lt => by cases k; exact Or.inl lt)
      (fun _ _ _ _ => rfl)
      gSub_rises (fun k => by cases k; show 3 ≤ 3 - 1 + gSub () (fun _ => 3 - 1); exact by decide)
      (fun k => by cases k; exact by decide) (fun k => by cases k; exact by decide) (fun k => by cases k; exact by decide)
  exact ⟨kernGood, ⟨fun _ => Nat.le_refl 2, fun _ => Nat.le_refl 1, Nat.le_refl 0,
      Nat.le_refl 1, Nat.le_refl 1⟩,
    fun ref => absurd
      (ref.warn_preserved (fun _ => 5) (by decide : 5 < 7) ⟨(), (by decide : 5 < 7)⟩)
      (by decide : ¬ 5 < 3),
    ⟨rfl, rfl, rfl, rfl, rfl⟩⟩

end TypeSameSemanticsMismatch

/-! ### 3.5 `L5-CE03`: `SilencingSumBreaksComposition` -/

namespace SilencingSumBreaksComposition

def gSub (_ : Unit) (e : Unit → Nat) : Nat := if 2 ≤ e () then 1 else 0

theorem gSub_rises : ∀ k : Unit, RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (gSub k) :=
  fun _ e _ below =>
    match Nat.decLe 2 (e ()) with
    | isTrue h => Nat.le_trans (Nat.le_of_eq (if_pos h))
        (Nat.le_of_eq (if_pos (Nat.le_trans h (below ()))).symm)
    | isFalse h => Nat.le_trans (Nat.le_of_eq (if_neg h)) (Nat.zero_le _)

def channel (em : Bool) (load : Nat) (_ : Unit) : Bool := em && Nat.ble load 1

def compA : OpenComposition.OpenComponent Bool Bool Unit Empty Unit where
  next s oa _ := if oa.2 then false else s
  drawInt _ e := Empty.elim e
  drawExt s _ := match s with | false => 0 | true => 1
  emitAlarm _ o := o
  silenceLoad _ := 1
  favours s := s = true

def contractA : OpenComposition.InterfaceContract compA true where
  tol _ _ := True
  warnObs o := o = true
  preCapInt e := Empty.elim e
  preCapExt _ := 1
  postBudgetInt e := Empty.elim e
  postBudgetExt _ := 0
  maxSilence := 1
  maxLag := 1
  K _ := True
  eta s := match s with | false => 0 | true => 1
  init_in := trivial
  cert := Viability.certificate_disturbed_iff.mpr
    ⟨fun s _ =>
      ⟨fun e => Empty.elim e,
       fun _ => match s with | false => Nat.zero_le 1 | true => Nat.le_refl 1,
       Nat.le_refl 1,
       fun h0 => by
         cases s with
         | false => exact ⟨fun h => Bool.noConfusion h, fun e => Empty.elim e, fun _ => Nat.le_refl 0⟩
         | true => exact Nat.noConfusion h0⟩,
     fun _ _ _ _ => trivial⟩
  eta_bound s _ := match s with | false => Nat.zero_le 1 | true => Nat.le_refl 1
  emits_on_warn _ _ _ hw := hw
  eta_alarm_step s _ _ _ _ pos := by
    cases s with
    | false => exact absurd pos (Nat.lt_irrefl 0)
    | true => exact Nat.zero_lt_one
  eta_alarm_zero s _ _ _ _ h0 := by
    cases s with
    | false => rfl
    | true => exact Nat.noConfusion h0

def compOrbit : Nat → (Unit → Nat) × (Bool × Bool) :=
  Law.orbit
    (fun st => OpenComposition.closedStep (OpenComposition.OpenComponent.compose compA compA)
      (fun x => (Nat.blt (x ()) 8, Nat.blt (x ()) 8)) channel gSub (fun _ _ => 0) st ((), ((), ())))
    (fun _ => 6, (true, true))

theorem witness :
    Viability.Kernel
      (OpenComposition.closedProcess compA contractA (fun x => Nat.blt (x ()) 8) channel gSub
        (fun _ _ => 0) (fun _ => True))
      (OpenComposition.closedGuard compA contractA (fun _ => 3))
      (fun _ => 6, true) ∧
    (contractA.postBudgetExt () + contractA.postBudgetExt () + 0 ≤ 0 ∧
     3 + (AdaptiveLoops.natMax contractA.maxLag contractA.maxLag + 1) *
       (contractA.preCapExt () + contractA.preCapExt () + 0) ≤ 8 ∧
     3 + AdaptiveLoops.natMax (contractA.eta true) (contractA.eta true) *
       (contractA.preCapExt () + contractA.preCapExt () + 0) ≤ 6) ∧
    channel true (contractA.maxSilence + contractA.maxSilence) () = false ∧
    ((compOrbit 0).1 () = 6 ∧ (compOrbit 1).1 () = 5 ∧ (compOrbit 2).1 () = 4 ∧
     (compOrbit 3).1 () = 3 ∧ (compOrbit 4).1 () = 1 ∧ (compOrbit 5).1 () = 0) := by
  have soloKern :
      Viability.Kernel
        (OpenComposition.closedProcess compA contractA (fun x => Nat.blt (x ()) 8) channel gSub
          (fun _ _ => 0) (fun _ => True))
        (OpenComposition.closedGuard compA contractA (fun _ => 3))
        (fun _ => 6, true) :=
    OpenComposition.close_contract_kernel compA contractA (fun x => Nat.blt (x ()) 8) channel gSub
      (fun _ _ => 0) (fun _ => 0) (fun _ => True) (fun _ _ _ => Nat.zero_le 0)
      (fun _ => 3) (fun _ => 8) (fun _ => 0) (fun _ => 6)
      (fun _ k lt => by cases k; exact AdaptiveLoops.natBlt_true_iff.mpr lt)
      (fun load _ _ (le : load ≤ 1) => by
        show (true && Nat.ble load 1) = true
        rw [Nat.ble_eq_true_of_le le]
        rfl)
      gSub_rises (fun k => by cases k; show 3 ≤ 3 - 0 + gSub () (fun _ => 3 - 0); exact by decide)
      (fun _ => Nat.le_refl 0) (fun k => by cases k; exact by decide) (fun k => by cases k; exact by decide)
  exact ⟨soloKern, ⟨by decide, by decide, by decide⟩, rfl, ⟨rfl, rfl, rfl, rfl, rfl, rfl⟩⟩

end SilencingSumBreaksComposition

/-! ### 3.6 `L5-CE04`: `SameWiringNonMonotoneSubstrate` -/

namespace SameWiringNonMonotoneSubstrate

def compC : OpenComposition.OpenComponent Unit Bool Unit Empty Unit where
  next _ _ _ := ()
  drawInt _ e := Empty.elim e
  drawExt _ _ := 2
  emitAlarm _ o := o
  silenceLoad _ := 0
  favours _ := False

def contractC : OpenComposition.InterfaceContract compC () where
  tol _ _ := True
  warnObs o := o = true
  preCapInt e := Empty.elim e
  preCapExt _ := 2
  postBudgetInt e := Empty.elim e
  postBudgetExt _ := 2
  maxSilence := 0
  maxLag := 0
  K _ := True
  eta _ := 0
  init_in := trivial
  cert := Viability.certificate_disturbed_iff.mpr
    ⟨fun _ _ => ⟨fun e => Empty.elim e, fun _ => Nat.le_refl 2, Nat.le_refl 0,
      fun _ => ⟨fun f => f, fun e => Empty.elim e, fun _ => Nat.le_refl 2⟩⟩,
     fun _ _ _ _ => trivial⟩
  eta_bound _ _ := Nat.le_refl 0
  emits_on_warn _ _ _ hw := hw
  eta_alarm_step _ _ _ _ _ pos := absurd pos (Nat.lt_irrefl 0)
  eta_alarm_zero _ _ _ _ _ _ := rfl

def gMono (_ : Unit) (e : Unit → Nat) : Nat := if 2 ≤ e () then 2 else 0

theorem gMono_rises : ∀ k : Unit, RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (gMono k) :=
  fun _ e _ below =>
    match Nat.decLe 2 (e ()) with
    | isTrue h => Nat.le_trans (Nat.le_of_eq (if_pos h))
        (Nat.le_of_eq (if_pos (Nat.le_trans h (below ()))).symm)
    | isFalse h => Nat.le_trans (Nat.le_of_eq (if_neg h)) (Nat.zero_le _)

def gOvercrowd (_ : Unit) (e : Unit → Nat) : Nat :=
  match e () with
  | 2 => 2
  | _ => 0

def badOrbit : Nat → (Unit → Nat) × Unit :=
  Law.orbit
    (fun st => OpenComposition.closedStep compC (fun x => Nat.blt (x ()) 6)
      (fun em _ _ => em) gOvercrowd (fun _ _ => 0) st ((), ()))
    (fun _ => 5, ())

theorem witness :
    Viability.Kernel
      (OpenComposition.closedProcess compC contractC (fun x => Nat.blt (x ()) 6)
        (fun (em : Bool) (_ : Nat) (_ : Unit) => em) gMono (fun _ _ => 0) (fun (_ : Unit) => True))
      (OpenComposition.closedGuard compC contractC (fun _ => 4))
      (fun _ => 5, ()) ∧
    (4 ≤ RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole gOvercrowd (fun _ => 2) (fun _ => 4) ()) ∧
    ¬ (∀ k : Unit, RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (gOvercrowd k)) ∧
    ((badOrbit 0).1 () = 5 ∧ (badOrbit 1).1 () = 3 ∧ (badOrbit 2).1 () = 1 ∧ (badOrbit 3).1 () = 0) := by
  have kernMono :
      Viability.Kernel
        (OpenComposition.closedProcess compC contractC (fun x => Nat.blt (x ()) 6)
          (fun (em : Bool) (_ : Nat) (_ : Unit) => em) gMono (fun _ _ => 0) (fun (_ : Unit) => True))
        (OpenComposition.closedGuard compC contractC (fun _ => 4))
        (fun _ => 5, ()) :=
    OpenComposition.close_contract_kernel compC contractC (fun x => Nat.blt (x ()) 6)
      (fun (em : Bool) (_ : Nat) (_ : Unit) => em) gMono (fun _ _ => 0) (fun _ => 0) (fun (_ : Unit) => True)
      (fun _ _ _ => Nat.zero_le 0) (fun _ => 4) (fun _ => 6) (fun _ => 2) (fun _ => 5)
      (fun _ k lt => by cases k; exact AdaptiveLoops.natBlt_true_iff.mpr lt)
      (fun _ _ _ _ => rfl)
      gMono_rises (fun k => by cases k; show 4 ≤ 4 - 2 + gMono () (fun _ => 4 - 2); exact by decide)
      (fun _ => Nat.le_refl 2) (fun k => by cases k; exact by decide) (fun k => by cases k; exact by decide)
  exact ⟨kernMono, by decide,
    fun hr => Nat.not_le_of_gt (by decide : 0 < 2)
      (hr () (fun _ => 2) (fun _ => 3) (fun _ => Nat.le_succ 2)),
    ⟨rfl, rfl, rfl, rfl⟩⟩

end SameWiringNonMonotoneSubstrate

/-! ### 3.7 `L5-CE05b`: `ConcurrentReconfigConflict` -/

namespace ConcurrentReconfigConflict

def gSub (_ : Unit) (e : Unit → Nat) : Nat := if 2 ≤ e () then 1 else 0

theorem gSub_rises : ∀ k : Unit, RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (gSub k) :=
  fun _ e _ below =>
    match Nat.decLe 2 (e ()) with
    | isTrue h => Nat.le_trans (Nat.le_of_eq (if_pos h))
        (Nat.le_of_eq (if_pos (Nat.le_trans h (below ()))).symm)
    | isFalse h => Nat.le_trans (Nat.le_of_eq (if_neg h)) (Nat.zero_le _)

def mkStatic (d : Nat) : OpenComposition.OpenComponent Unit Bool Unit Empty Unit where
  next _ _ _ := ()
  drawInt _ e := Empty.elim e
  drawExt _ _ := d
  emitAlarm _ o := o
  silenceLoad _ := 0
  favours _ := False

def mkStaticContract (d : Nat) : OpenComposition.InterfaceContract (mkStatic d) () where
  tol _ _ := True
  warnObs o := o = true
  preCapInt e := Empty.elim e
  preCapExt _ := d
  postBudgetInt e := Empty.elim e
  postBudgetExt _ := d
  maxSilence := 0
  maxLag := 0
  K _ := True
  eta _ := 0
  init_in := trivial
  cert := Viability.certificate_disturbed_iff.mpr
    ⟨fun _ _ => ⟨fun e => Empty.elim e, fun _ => Nat.le_refl d, Nat.le_refl 0,
      fun _ => ⟨fun f => f, fun e => Empty.elim e, fun _ => Nat.le_refl d⟩⟩,
     fun _ _ _ _ => trivial⟩
  eta_bound _ _ := Nat.le_refl 0
  emits_on_warn _ _ _ hw := hw
  eta_alarm_step _ _ _ _ _ pos := absurd pos (Nat.lt_irrefl 0)
  eta_alarm_zero _ _ _ _ _ _ := rfl

def concurrentOrbit : Nat → (Unit → Nat) × (Unit × Unit) :=
  Law.orbit
    (fun st => OpenComposition.closedStep (OpenComposition.OpenComponent.compose (mkStatic 1) (mkStatic 1))
      (fun x => (Nat.blt (x ()) 5, Nat.blt (x ()) 5)) (fun em _ _ => em) gSub (fun _ _ => 0)
      st ((), ((), ())))
    (fun _ => 4, ((), ()))

theorem witness :
    Viability.Kernel
      (OpenComposition.closedProcess (OpenComposition.OpenComponent.compose (mkStatic 1) (mkStatic 0))
        (OpenComposition.composeContract (mkStaticContract 1) (mkStaticContract 0))
        (fun x => (Nat.blt (x ()) 5, Nat.blt (x ()) 5)) (fun (em : Bool) (_ : Nat) (_ : Unit) => em) gSub
        (fun _ _ => 0) (fun (_ : Unit) => True))
      (OpenComposition.closedGuard (OpenComposition.OpenComponent.compose (mkStatic 1) (mkStatic 0))
        (OpenComposition.composeContract (mkStaticContract 1) (mkStaticContract 0)) (fun _ => 3))
      (fun _ => 4, ((), ())) ∧
    Viability.Kernel
      (OpenComposition.closedProcess (OpenComposition.OpenComponent.compose (mkStatic 0) (mkStatic 1))
        (OpenComposition.composeContract (mkStaticContract 0) (mkStaticContract 1))
        (fun x => (Nat.blt (x ()) 5, Nat.blt (x ()) 5)) (fun (em : Bool) (_ : Nat) (_ : Unit) => em) gSub
        (fun _ _ => 0) (fun (_ : Unit) => True))
      (OpenComposition.closedGuard (OpenComposition.OpenComponent.compose (mkStatic 0) (mkStatic 1))
        (OpenComposition.composeContract (mkStaticContract 0) (mkStaticContract 1)) (fun _ => 3))
      (fun _ => 4, ((), ())) ∧
    ¬ ((mkStaticContract 1).postBudgetExt () + (mkStaticContract 1).postBudgetExt () ≤ 1) ∧
    ((concurrentOrbit 0).1 () = 4 ∧ (concurrentOrbit 1).1 () = 3 ∧
     (concurrentOrbit 2).1 () = 1 ∧ (concurrentOrbit 3).1 () = 0) := by
  have kernLeft :
      Viability.Kernel
        (OpenComposition.closedProcess (OpenComposition.OpenComponent.compose (mkStatic 1) (mkStatic 0))
          (OpenComposition.composeContract (mkStaticContract 1) (mkStaticContract 0))
          (fun x => (Nat.blt (x ()) 5, Nat.blt (x ()) 5)) (fun (em : Bool) (_ : Nat) (_ : Unit) => em) gSub
          (fun _ _ => 0) (fun (_ : Unit) => True))
        (OpenComposition.closedGuard (OpenComposition.OpenComponent.compose (mkStatic 1) (mkStatic 0))
          (OpenComposition.composeContract (mkStaticContract 1) (mkStaticContract 0)) (fun _ => 3))
        (fun _ => 4, ((), ())) :=
    OpenComposition.compose_close_interchange (mkStatic 1) (mkStatic 0)
      (mkStaticContract 1) (mkStaticContract 0)
      (fun x => Nat.blt (x ()) 5) (fun x => Nat.blt (x ()) 5)
      (fun (em : Bool) (_ : Nat) (_ : Unit) => em) gSub (fun _ _ => 0) (fun _ => 0) (fun (_ : Unit) => True)
      (fun _ _ _ => Nat.zero_le 0) (fun _ => 3) (fun _ => 5) (fun _ => 1) (fun _ => 4)
      (fun _ k lt => by cases k; exact Or.inl (AdaptiveLoops.natBlt_true_iff.mpr lt))
      (fun _ _ _ _ => rfl)
      gSub_rises (fun k => by cases k; show 3 ≤ 3 - 1 + gSub () (fun _ => 3 - 1); exact by decide)
      (fun _ => Nat.le_refl 1) (fun k => by cases k; exact by decide) (fun k => by cases k; exact by decide)
  have kernRight :
      Viability.Kernel
        (OpenComposition.closedProcess (OpenComposition.OpenComponent.compose (mkStatic 0) (mkStatic 1))
          (OpenComposition.composeContract (mkStaticContract 0) (mkStaticContract 1))
          (fun x => (Nat.blt (x ()) 5, Nat.blt (x ()) 5)) (fun (em : Bool) (_ : Nat) (_ : Unit) => em) gSub
          (fun _ _ => 0) (fun (_ : Unit) => True))
        (OpenComposition.closedGuard (OpenComposition.OpenComponent.compose (mkStatic 0) (mkStatic 1))
          (OpenComposition.composeContract (mkStaticContract 0) (mkStaticContract 1)) (fun _ => 3))
        (fun _ => 4, ((), ())) :=
    OpenComposition.compose_close_interchange (mkStatic 0) (mkStatic 1)
      (mkStaticContract 0) (mkStaticContract 1)
      (fun x => Nat.blt (x ()) 5) (fun x => Nat.blt (x ()) 5)
      (fun (em : Bool) (_ : Nat) (_ : Unit) => em) gSub (fun _ _ => 0) (fun _ => 0) (fun (_ : Unit) => True)
      (fun _ _ _ => Nat.zero_le 0) (fun _ => 3) (fun _ => 5) (fun _ => 1) (fun _ => 4)
      (fun _ k lt => by cases k; exact Or.inl (AdaptiveLoops.natBlt_true_iff.mpr lt))
      (fun _ _ _ _ => rfl)
      gSub_rises (fun k => by cases k; show 3 ≤ 3 - 1 + gSub () (fun _ => 3 - 1); exact by decide)
      (fun _ => Nat.le_refl 1) (fun k => by cases k; exact by decide) (fun k => by cases k; exact by decide)
  exact ⟨kernLeft, kernRight, by decide, ⟨rfl, rfl, rfl, rfl⟩⟩

end ConcurrentReconfigConflict

/-! ### 3.8 `L5-CE08a`: `LaxTubeOverflowWitness` -/

namespace LaxTubeOverflowWitness

def microProc : Process Nat Unit where
  step s _ s' := s' = s - 1

def macroProc : Process Nat Unit where
  step q _ q' := q' = q

def sim : LaxSim microProc macroProc id id SlackDist.nat where
  strict := fun _ => Nat.lt_succ_self _
  Epoch _ _ := True
  EpochQ _ _ := True
  epoch_step _ _ _ _ _ _ := trivial
  epoch_proj _ _ _ := trivial
  α := id
  β := id
  α_mono le := le
  β_mono le := le
  β_ge_id r := Nat.le_refl r
  ε := 1
  η := 0
  sim_block k s q r w s' _ _ d_le w_len tr := by
    have w1 : w.length = 1 := w_len.trans (succ_sub_self k)
    match w with
    | [] => exact Nat.noConfusion w1
    | [_] =>
      match tr with
      | .cons st (.nil _) =>
        have hEq : s' = s - 1 := st
        rw [hEq]
        exact ⟨(), q, rfl, trivial,
          Nat.le_trans (distNat_sub_one s q) (Nat.add_le_add_right d_le 1)⟩
    | _ :: _ :: _ => exact Nat.noConfusion (Nat.succ.inj w1)
  excursion k s q r w₁ u _ _ d_le w₁_lt tr := by
    have hlt : w₁.length < 1 := (succ_sub_self k) ▸ w₁_lt
    match w₁ with
    | [] =>
      match tr with
      | .nil _ => exact d_le
    | _ :: _ => exact absurd hlt (Nat.not_lt_of_le (Nat.le_add_left 1 _))

def certQ : Viability.Certificate macroProc (fun q => q = 12) (fun q => q = 12) where
  within _ h := h
  closed _ _ _ h1 h2 := h1.trans h2

theorem witness :
    Viability.Kernel macroProc (fun q => q = 12) 12 ∧
    (∀ Δ : Nat, ¬ (sim.α Δ + sim.ε ≤ Δ)) ∧
    Trace microProc 12 [(), (), ()] 9 ∧
    ¬ Viability.Kernel microProc (fun s => 10 ≤ s) 12 := by
  have tr9 : Trace microProc 12 [(), (), ()] 9 :=
    .cons rfl (.cons rfl (.cons rfl (.nil 9)))
  exact ⟨certQ.kernel rfl, fun Δ h => Nat.not_succ_le_self Δ h, tr9,
    fun kern => Nat.not_le_of_gt (by decide : 9 < 10) (kern 9 ⟨[(), (), ()], tr9⟩)⟩

end LaxTubeOverflowWitness

/-! ### 3.9 `L5-CE08b`: `CoupledLaxNonDecouplingWitness` -/

namespace CoupledLaxNonDecouplingWitness

def statProc : Process Nat Unit where
  step s _ s' := s' = s

def statSim : LaxSim statProc statProc id id SlackDist.nat where
  strict := fun _ => Nat.lt_succ_self _
  Epoch _ _ := True
  EpochQ _ _ := True
  epoch_step _ _ _ _ _ _ := trivial
  epoch_proj _ _ _ := trivial
  α := id
  β := id
  α_mono le := le
  β_mono le := le
  β_ge_id r := Nat.le_refl r
  ε := 0
  η := 0
  sim_block k s q r w s' _ _ d_le w_len tr := by
    have w1 : w.length = 1 := w_len.trans (succ_sub_self k)
    match w with
    | [] => exact Nat.noConfusion w1
    | [_] =>
      match tr with
      | .cons st (.nil _) =>
        have hEq : s' = s := st
        rw [hEq]
        exact ⟨(), q, rfl, trivial, d_le⟩
    | _ :: _ :: _ => exact Nat.noConfusion (Nat.succ.inj w1)
  excursion k s q r w₁ u _ _ d_le w₁_lt tr := by
    have hlt : w₁.length < 1 := (succ_sub_self k) ▸ w₁_lt
    match w₁ with
    | [] =>
      match tr with
      | .nil _ => exact d_le
    | _ :: _ => exact absurd hlt (Nat.not_lt_of_le (Nat.le_add_left 1 _))

def certProd :
    Viability.Certificate (OpenComposition.prodProcess statProc statProc)
      (fun q => q = (10, 10)) (fun q => q = (10, 10)) where
  within _ h := h
  closed _ _ _ h1 h2 := Prod.ext (h1.1.trans (congrArg Prod.fst h2)) (h1.2.trans (congrArg Prod.snd h2))

theorem eight_le_of_distNat_le_two {u : Nat} (hd : distNat u 10 ≤ 2) : 8 ≤ u := by
  have hsub : 10 - u ≤ 2 := Nat.le_trans (Nat.le_add_left _ _) hd
  have hSum : 8 + 2 ≤ u + 2 :=
    Nat.le_trans (Nat.le_of_eq (by decide : 8 + 2 = 10))
      (Nat.le_trans (le_sub_add_nat 10 u)
        (Nat.le_trans (Nat.add_le_add_right hsub u) (Nat.le_of_eq (Nat.add_comm 2 u))))
  exact le_of_add_le_add_right 2 hSum

def gShared (z : Nat) : Nat := if 2 ≤ z then 1 else 0

theorem solo_orbit_ten : ∀ t, Law.orbit (RegimeMargin.step gShared 1) 10 t = 10
  | 0 => rfl
  | t + 1 => by
    show RegimeMargin.step gShared 1 (Law.orbit (RegimeMargin.step gShared 1) 10 t) = 10
    rw [solo_orbit_ten t]
    rfl

theorem witness :
    Viability.Kernel (OpenComposition.prodProcess statProc statProc)
      (fun u => 8 ≤ u.1 ∧ 8 ≤ u.2) (10, 10) ∧
    (∀ t, 8 ≤ Law.orbit (RegimeMargin.step gShared 1) 10 t) ∧
    (Law.orbit (RegimeMargin.step gShared (1 + 1)) 10 0 = 10 ∧
     Law.orbit (RegimeMargin.step gShared (1 + 1)) 10 1 = 9 ∧
     Law.orbit (RegimeMargin.step gShared (1 + 1)) 10 2 = 8 ∧
     Law.orbit (RegimeMargin.step gShared (1 + 1)) 10 3 = 7 ∧
     Law.orbit (RegimeMargin.step gShared (1 + 1)) 10 3 < 8) := by
  have prodKern :
      Viability.Kernel (OpenComposition.prodProcess statProc statProc)
        (fun u => 8 ≤ u.1 ∧ 8 ≤ u.2) (10, 10) :=
    lax_kernel_of_certificate (OpenComposition.compose_laxSim_max statSim statSim) certProd 2
      (by decide)
      (fun q u hq d_le => by
        subst hq
        exact ⟨eight_le_of_distNat_le_two (Nat.le_trans (AdaptiveLoops.le_natMax_left _ _) d_le),
               eight_le_of_distNat_le_two (Nat.le_trans (AdaptiveLoops.le_natMax_right _ _) d_le)⟩)
      ⟨trivial, trivial⟩ rfl
  exact ⟨prodKern, fun t => (solo_orbit_ten t).symm ▸ (by decide : 8 ≤ 10),
    ⟨rfl, rfl, rfl, rfl, by decide⟩⟩

end CoupledLaxNonDecouplingWitness

/-! ### 3.10 `L5-CE09`: `SelfModifyingValidatorCapture` -/

namespace SelfModifyingValidatorCapture

def compCaptured : OpenComposition.OpenComponent Unit Nat Unit Unit Unit where
  next _ _ _ := ()
  drawInt _ _ := 0
  drawExt _ _ := 2
  emitAlarm _ _ := false
  silenceLoad _ := 0
  favours _ := False

def contractCaptured : OpenComposition.InterfaceContract compCaptured () where
  tol _ _ := True
  warnObs _ := False
  preCapInt _ := 0
  preCapExt _ := 2
  postBudgetInt _ := 0
  postBudgetExt _ := 2
  maxSilence := 0
  maxLag := 0
  K _ := True
  eta _ := 0
  init_in := trivial
  cert := Viability.certificate_disturbed_iff.mpr
    ⟨fun _ _ => ⟨fun _ => Nat.le_refl 0, fun _ => Nat.le_refl 2, Nat.le_refl 0,
      fun _ => ⟨fun f => f, fun _ => Nat.le_refl 0, fun _ => Nat.le_refl 2⟩⟩,
     fun _ _ _ _ => trivial⟩
  eta_bound _ _ := Nat.le_refl 0
  emits_on_warn _ _ _ f := False.elim f
  eta_alarm_step _ _ _ _ _ pos := absurd pos (Nat.lt_irrefl 0)
  eta_alarm_zero _ _ _ _ _ _ := rfl

def capturedProc :=
  OpenComposition.ReconfigProcess
    ReconfigCountdownJumpFails.compA compCaptured
    (ReconfigCountdownJumpFails.contractA true) contractCaptured
    (fun x => x ()) (fun x => x ())
    ReconfigCountdownJumpFails.channel ReconfigCountdownJumpFails.gSub
    (fun _ _ => 0) (fun _ => True)

def capRun (t : Nat) : Sum ((Unit → Nat) × Bool) ((Unit → Nat) × Unit) :=
  match t with
  | 0 => .inl (fun _ => 5, true)
  | 1 => .inr (fun _ => 5, ())
  | k + 2 => match capRun (k + 1) with
    | .inl st₁ => .inl (OpenComposition.closedStep ReconfigCountdownJumpFails.compA (fun x => x ())
        ReconfigCountdownJumpFails.channel ReconfigCountdownJumpFails.gSub (fun _ _ => 0) st₁ ((), ()))
    | .inr st₂ => .inr (OpenComposition.closedStep compCaptured (fun x => x ())
        ReconfigCountdownJumpFails.channel ReconfigCountdownJumpFails.gSub (fun _ _ => 0) st₂ ((), ()))

def capLevel (t : Nat) : Nat :=
  match capRun t with
  | .inl st₁ => st₁.1 ()
  | .inr st₂ => st₂.1 ()

theorem witness :
    Viability.Kernel
      (OpenComposition.closedProcess ReconfigCountdownJumpFails.compA
        (ReconfigCountdownJumpFails.contractA true) (fun x => x ())
        ReconfigCountdownJumpFails.channel ReconfigCountdownJumpFails.gSub (fun _ _ => 0) (fun _ => True))
      (OpenComposition.closedGuard ReconfigCountdownJumpFails.compA
        (ReconfigCountdownJumpFails.contractA true) (fun _ => 3))
      (fun _ => 5, true) ∧
    capturedProc.step (.inl (fun _ => 5, true)) (.reconfig ()) (.inr (fun _ => 5, ())) ∧
    ¬ (contractCaptured.postBudgetExt () ≤ (ReconfigCountdownJumpFails.contractA true).postBudgetExt ()) ∧
    ¬ (5 < 7 → contractCaptured.warnObs 5) ∧
    (capLevel 1 = 5 ∧ capLevel 2 = 4 ∧ capLevel 3 = 3 ∧ capLevel 4 = 1 ∧ capLevel 5 = 0) ∧
    (∀ k, k < 4 → capturedProc.step (capRun (k + 1)) (.stepRight () ()) (capRun (k + 2))) := by
  have soloA :
      Viability.Kernel
        (OpenComposition.closedProcess ReconfigCountdownJumpFails.compA
          (ReconfigCountdownJumpFails.contractA true) (fun x => x ())
          ReconfigCountdownJumpFails.channel ReconfigCountdownJumpFails.gSub (fun _ _ => 0) (fun _ => True))
        (OpenComposition.closedGuard ReconfigCountdownJumpFails.compA
          (ReconfigCountdownJumpFails.contractA true) (fun _ => 3))
        (fun _ => 5, true) :=
    OpenComposition.close_contract_kernel ReconfigCountdownJumpFails.compA
      (ReconfigCountdownJumpFails.contractA true) (fun x => x ())
      ReconfigCountdownJumpFails.channel ReconfigCountdownJumpFails.gSub (fun _ _ => 0) (fun _ => 0)
      (fun _ => True) (fun _ _ _ => Nat.zero_le 0) (fun _ => 3) (fun _ => 7) (fun _ => 1)
      (fun _ => 5) (fun _ _ lt => lt)
      (fun load _ _ (le : load ≤ 0) => by
        show (true && Nat.ble load 0) = true
        rw [Nat.ble_eq_true_of_le le]
        rfl)
      ReconfigCountdownJumpFails.gSub_rises
      (fun k => by cases k; show 3 ≤ 3 - 1 + ReconfigCountdownJumpFails.gSub () (fun _ => 3 - 1); exact by decide)
      (fun _ => Nat.le_refl 1) (fun k => by cases k; exact by decide) (fun k => by cases k; exact by decide)
  have reconfigOk : capturedProc.step (.inl (fun _ => 5, true)) (.reconfig ()) (.inr (fun _ => 5, ())) :=
    ⟨trivial, Nat.zero_le 1, rfl⟩
  have stepsOk : ∀ k, k < 4 → capturedProc.step (capRun (k + 1)) (.stepRight () ()) (capRun (k + 2)) := by
    intro k hk
    match k with
    | 0 => exact ⟨trivial, fun _ => trivial, rfl⟩
    | 1 => exact ⟨trivial, fun _ => trivial, rfl⟩
    | 2 => exact ⟨trivial, fun _ => trivial, rfl⟩
    | 3 => exact ⟨trivial, fun _ => trivial, rfl⟩
    | n + 4 => exact absurd hk (Nat.not_lt_of_ge (Nat.le_add_left 4 n))
  exact ⟨soloA, reconfigOk, by decide, fun h => h (by decide), ⟨rfl, rfl, rfl, rfl, rfl⟩, stepsOk⟩

end SelfModifyingValidatorCapture

/-! ### 3.11 `L5-CE10`: `ViableSelfExternalizesVictim` -/

namespace ViableSelfExternalizesVictim

def compOwn : OpenComposition.OpenComponent Unit Bool Unit Empty Unit where
  next _ _ _ := ()
  drawInt _ e := Empty.elim e
  drawExt _ _ := 2
  emitAlarm _ o := o
  silenceLoad _ := 0
  favours _ := False

def contractOwn : OpenComposition.InterfaceContract compOwn () where
  tol _ _ := True
  warnObs o := o = true
  preCapInt e := Empty.elim e
  preCapExt _ := 2
  postBudgetInt e := Empty.elim e
  postBudgetExt _ := 2
  maxSilence := 0
  maxLag := 0
  K _ := True
  eta _ := 0
  init_in := trivial
  cert := Viability.certificate_disturbed_iff.mpr
    ⟨fun _ _ => ⟨fun e => Empty.elim e, fun _ => Nat.le_refl 2, Nat.le_refl 0,
      fun _ => ⟨fun f => f, fun e => Empty.elim e, fun _ => Nat.le_refl 2⟩⟩,
     fun _ _ _ _ => trivial⟩
  eta_bound _ _ := Nat.le_refl 0
  emits_on_warn _ _ _ hw := hw
  eta_alarm_step _ _ _ _ _ pos := absurd pos (Nat.lt_irrefl 0)
  eta_alarm_zero _ _ _ _ _ _ := rfl

def gOwn (_ : Unit) (e : Unit → Nat) : Nat := if 2 ≤ e () then 2 else 0

theorem gOwn_rises : ∀ k : Unit, RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (gOwn k) :=
  fun _ e _ below =>
    match Nat.decLe 2 (e ()) with
    | isTrue h => Nat.le_trans (Nat.le_of_eq (if_pos h))
        (Nat.le_of_eq (if_pos (Nat.le_trans h (below ()))).symm)
    | isFalse h => Nat.le_trans (Nat.le_of_eq (if_neg h)) (Nat.zero_le _)

def compTwo : OpenComposition.OpenComponent Unit Bool Unit Empty Bool where
  next _ _ _ := ()
  drawInt _ e := Empty.elim e
  drawExt _ _ := 2
  emitAlarm _ o := o
  silenceLoad _ := 0
  favours _ := False

def gTwo (b : Bool) (e : Bool → Nat) : Nat :=
  match b with
  | false => if 2 ≤ e false then 2 else 0
  | true => if 2 ≤ e true then 1 else 0

def twoOrbit : Nat → (Bool → Nat) × Unit :=
  Law.orbit
    (fun st => OpenComposition.closedStep compTwo (fun x => Nat.blt (x false) 6)
      (fun em _ _ => em) gTwo (fun _ _ => 0) st ((), ()))
    (fun _ => 5, ())

theorem two_self_const : ∀ t, (twoOrbit t).1 false = 5
  | 0 => rfl
  | t + 1 => by
    have ih := two_self_const t
    show ((twoOrbit t).1 false - 2) + (if 2 ≤ (twoOrbit t).1 false - 2 then 2 else 0) = 5
    rw [ih]
    rfl

theorem witness {Pos F : Type} (p : Pos) (f : F) :
    Viability.Kernel
      (OpenComposition.closedProcess compOwn contractOwn (fun x => Nat.blt (x ()) 6)
        (fun (em : Bool) (_ : Nat) (_ : Unit) => em) gOwn (fun _ _ => 0) (fun (_ : Unit) => True))
      (OpenComposition.closedGuard compOwn contractOwn (fun _ => 4))
      (fun _ => 5, ()) ∧
    (∀ t, (twoOrbit t).1 false = 5) ∧
    ((twoOrbit 0).1 true = 5 ∧ (twoOrbit 1).1 true = 4 ∧ (twoOrbit 2).1 true = 3 ∧
     (twoOrbit 3).1 true = 1 ∧ (twoOrbit 4).1 true = 0) ∧
    ¬ (∀ (_d : Unit) (sig : Pos → Nat → F → Prop),
        Viability.Kernel
          (OpenComposition.closedProcess compOwn contractOwn (fun x => Nat.blt (x ()) 6)
            (fun (em : Bool) (_ : Nat) (_ : Unit) => em) gOwn (fun _ _ => 0) (fun (_ : Unit) => True))
          (OpenComposition.closedGuard compOwn contractOwn (fun _ => 4))
          (fun _ => 5, ()) →
        Unrestricted sig) := by
  have ownKern :
      Viability.Kernel
        (OpenComposition.closedProcess compOwn contractOwn (fun x => Nat.blt (x ()) 6)
          (fun (em : Bool) (_ : Nat) (_ : Unit) => em) gOwn (fun _ _ => 0) (fun (_ : Unit) => True))
        (OpenComposition.closedGuard compOwn contractOwn (fun _ => 4))
        (fun _ => 5, ()) :=
    OpenComposition.close_contract_kernel compOwn contractOwn (fun x => Nat.blt (x ()) 6)
      (fun (em : Bool) (_ : Nat) (_ : Unit) => em) gOwn (fun _ _ => 0) (fun _ => 0) (fun (_ : Unit) => True)
      (fun _ _ _ => Nat.zero_le 0) (fun _ => 4) (fun _ => 6) (fun _ => 2) (fun _ => 5)
      (fun _ k lt => by cases k; exact AdaptiveLoops.natBlt_true_iff.mpr lt)
      (fun _ _ _ _ => rfl)
      gOwn_rises (fun k => by cases k; show 4 ≤ 4 - 2 + gOwn () (fun _ => 4 - 2); exact by decide)
      (fun _ => Nat.le_refl 2) (fun k => by cases k; exact by decide) (fun k => by cases k; exact by decide)
  exact ⟨ownKern, two_self_const, ⟨rfl, rfl, rfl, rfl, rfl⟩,
    AlignmentDichotomy.alignmentSpine_cannot_entail_unrestricted
      (fun (_ : Unit) => Viability.Kernel
        (OpenComposition.closedProcess compOwn contractOwn (fun x => Nat.blt (x ()) 6)
          (fun (em : Bool) (_ : Nat) (_ : Unit) => em) gOwn (fun _ _ => 0) (fun (_ : Unit) => True))
        (OpenComposition.closedGuard compOwn contractOwn (fun _ => 4))
        (fun _ => 5, ()))
      p f (d := ()) ownKern⟩

end ViableSelfExternalizesVictim

/-! ### 3.12 & 3.13 `文理生生 v0.2` Structural Witnesses -/

/-- Approximate `ε`-similarity on `SlackDist.nat` is NOT transitive (`0 ≈₁ 1` and `1 ≈₁ 2`,
yet `¬ (0 ≈₁ 2)`), contrasting with exact equivalence `Becoming.Grammar.«类»`. -/
theorem slackDist_nat_not_transitive :
    SlackDist.nat.d 0 1 ≤ 1 ∧ SlackDist.nat.d 1 2 ≤ 1 ∧ ¬ (SlackDist.nat.d 0 2 ≤ 1) :=
  ⟨by decide, by decide, by decide⟩

/-- Exact equivalence (`Becoming.Grammar.«类»`) and non-core continuation witness
(`«以核为判据则火无续»`). -/
theorem exact_equivalence_is_class :
    «类» Flame.alike ∧
    («续» Flame.step Flame.alike Flame.f₀ Flame.f₁ ∧
     «续» Flame.step Flame.alike Flame.f₁ Flame.f₂ ∧
     ∀ x y, ¬ «续» Flame.step («核» Flame.step Flame.alike) x y) :=
  ⟨Flame.alike_class, «以核为判据则火无续»⟩

/-! **22-state coupled discrete water tank (`WaterTankCouplingWitness`, `x + r = 10`, `u : Bool`)**:
- `predictive_4_6` locks inside `[4, 6]` forever (`4 → 5 → 6 → 5 → 4`, `x ≤ 10`),
- `delayed_4_6` overshoots to `[3, 7]` (`t = 3` hits `7`, `t = 7` hits `3`, period `8`),
- `delayed_4_5` drops to `3` (`t = 5`, period `6`),
- `[4, 6]` alone without controller state `u` is NOT invariant (`(4, false) ↦ 3`, `(6, true) ↦ 7`),
- Mass conservation `x + r = 10` destroys control observability (`(9, true)` vs `(5, true)` under
  `delayed_4_6`, and `(9, true)` vs `(4, true)` under `predictive_4_6`, verified via `rfl`). -/
namespace WaterTankCouplingWitness

def tankPhysics (x : Nat) (u : Bool) : Nat :=
  if u then x + 1 else x - 1

def delayed_4_6 (st : Nat × Bool) : Nat × Bool :=
  let u' :=
    match Nat.decLe st.1 4 with
    | isTrue _ => true
    | isFalse _ =>
      match Nat.decLe 6 st.1 with
      | isTrue _ => false
      | isFalse _ => st.2
  (tankPhysics st.1 st.2, u')

def delayed_4_5 (st : Nat × Bool) : Nat × Bool :=
  let u' :=
    match Nat.decLe st.1 4 with
    | isTrue _ => true
    | isFalse _ =>
      match Nat.decLe 5 st.1 with
      | isTrue _ => false
      | isFalse _ => st.2
  (tankPhysics st.1 st.2, u')

def predictive_4_6 (st : Nat × Bool) : Nat × Bool :=
  let x' := tankPhysics st.1 st.2
  let u' :=
    match Nat.decLe x' 4 with
    | isTrue _ => true
    | isFalse _ =>
      match Nat.decLe 6 x' with
      | isTrue _ => false
      | isFalse _ => st.2
  (x', u')

theorem predictive_cycle_inv : ∀ t,
    let st := Law.orbit predictive_4_6 (4, true) t
    (st = (4, true) ∨ st = (5, true) ∨ st = (6, false) ∨ st = (5, false)) ∧
    4 ≤ st.1 ∧ st.1 ≤ 6 ∧ st.1 ≤ 10 := by
  intro t
  have mem : ∀ k,
      Law.orbit predictive_4_6 (4, true) k = (4, true) ∨
      Law.orbit predictive_4_6 (4, true) k = (5, true) ∨
      Law.orbit predictive_4_6 (4, true) k = (6, false) ∨
      Law.orbit predictive_4_6 (4, true) k = (5, false) := by
    intro k
    induction k with
    | zero => exact Or.inl rfl
    | succ k ih =>
      rcases ih with h | h | h | h
      · exact Or.inr (Or.inl (show predictive_4_6 (Law.orbit predictive_4_6 (4, true) k) = (5, true) from by rw [h]; rfl))
      · exact Or.inr (Or.inr (Or.inl (show predictive_4_6 (Law.orbit predictive_4_6 (4, true) k) = (6, false) from by rw [h]; rfl)))
      · exact Or.inr (Or.inr (Or.inr (show predictive_4_6 (Law.orbit predictive_4_6 (4, true) k) = (5, false) from by rw [h]; rfl)))
      · exact Or.inl (show predictive_4_6 (Law.orbit predictive_4_6 (4, true) k) = (4, true) from by rw [h]; rfl)
  rcases mem t with h | h | h | h <;> rw [h] <;> exact ⟨by
    first
    | exact Or.inl rfl
    | exact Or.inr (Or.inl rfl)
    | exact Or.inr (Or.inr (Or.inl rfl))
    | exact Or.inr (Or.inr (Or.inr rfl)),
    by decide, by decide, by decide⟩

theorem delayed_4_6_inv : ∀ t,
    (Law.orbit delayed_4_6 (4, true) t).1 ≤ 10 := by
  have mem : ∀ k,
      Law.orbit delayed_4_6 (4, true) k = (4, true) ∨
      Law.orbit delayed_4_6 (4, true) k = (5, true) ∨
      Law.orbit delayed_4_6 (4, true) k = (6, true) ∨
      Law.orbit delayed_4_6 (4, true) k = (7, false) ∨
      Law.orbit delayed_4_6 (4, true) k = (6, false) ∨
      Law.orbit delayed_4_6 (4, true) k = (5, false) ∨
      Law.orbit delayed_4_6 (4, true) k = (4, false) ∨
      Law.orbit delayed_4_6 (4, true) k = (3, true) := by
    intro k
    induction k with
    | zero => exact Or.inl rfl
    | succ k ih =>
      rcases ih with h | h | h | h | h | h | h | h
      · exact Or.inr (Or.inl (by show delayed_4_6 _ = (5, true); rw [h]; rfl))
      · exact Or.inr (Or.inr (Or.inl (by show delayed_4_6 _ = (6, true); rw [h]; rfl)))
      · exact Or.inr (Or.inr (Or.inr (Or.inl (by show delayed_4_6 _ = (7, false); rw [h]; rfl))))
      · exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inl (by show delayed_4_6 _ = (6, false); rw [h]; rfl)))))
      · exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inl (by show delayed_4_6 _ = (5, false); rw [h]; rfl))))))
      · exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inl (by show delayed_4_6 _ = (4, false); rw [h]; rfl)))))))
      · exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (by show delayed_4_6 _ = (3, true); rw [h]; rfl)))))))
      · exact Or.inl (by show delayed_4_6 _ = (4, true); rw [h]; rfl)
  intro t
  rcases mem t with h | h | h | h | h | h | h | h <;> rw [h] <;> exact by decide

theorem delayed_4_5_inv : ∀ t,
    (Law.orbit delayed_4_5 (4, true) t).1 ≤ 10 := by
  have mem : ∀ k,
      Law.orbit delayed_4_5 (4, true) k = (4, true) ∨
      Law.orbit delayed_4_5 (4, true) k = (5, true) ∨
      Law.orbit delayed_4_5 (4, true) k = (6, false) ∨
      Law.orbit delayed_4_5 (4, true) k = (5, false) ∨
      Law.orbit delayed_4_5 (4, true) k = (4, false) ∨
      Law.orbit delayed_4_5 (4, true) k = (3, true) := by
    intro k
    induction k with
    | zero => exact Or.inl rfl
    | succ k ih =>
      rcases ih with h | h | h | h | h | h
      · exact Or.inr (Or.inl (by show delayed_4_5 _ = (5, true); rw [h]; rfl))
      · exact Or.inr (Or.inr (Or.inl (by show delayed_4_5 _ = (6, false); rw [h]; rfl)))
      · exact Or.inr (Or.inr (Or.inr (Or.inl (by show delayed_4_5 _ = (5, false); rw [h]; rfl))))
      · exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inl (by show delayed_4_5 _ = (4, false); rw [h]; rfl)))))
      · exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (by show delayed_4_5 _ = (3, true); rw [h]; rfl)))))
      · exact Or.inl (by show delayed_4_5 _ = (4, true); rw [h]; rfl)
  intro t
  rcases mem t with h | h | h | h | h | h <;> rw [h] <;> exact by decide

theorem witness :
    (Law.orbit predictive_4_6 (4, true) 0 = (4, true) ∧
     Law.orbit predictive_4_6 (4, true) 1 = (5, true) ∧
     Law.orbit predictive_4_6 (4, true) 2 = (6, false) ∧
     Law.orbit predictive_4_6 (4, true) 3 = (5, false) ∧
     Law.orbit predictive_4_6 (4, true) 4 = (4, true) ∧
     ∀ t, 4 ≤ (Law.orbit predictive_4_6 (4, true) t).1 ∧
       (Law.orbit predictive_4_6 (4, true) t).1 ≤ 6 ∧
       (Law.orbit predictive_4_6 (4, true) t).1 ≤ 10) ∧
    (Law.orbit delayed_4_6 (4, true) 3 = (7, false) ∧
     Law.orbit delayed_4_6 (4, true) 7 = (3, true) ∧
     Law.orbit delayed_4_6 (4, true) 8 = (4, true) ∧
     ∀ t, (Law.orbit delayed_4_6 (4, true) t).1 ≤ 10) ∧
    (Law.orbit delayed_4_5 (4, true) 5 = (3, true) ∧
     Law.orbit delayed_4_5 (4, true) 6 = (4, true) ∧
     ∀ t, (Law.orbit delayed_4_5 (4, true) t).1 ≤ 10) ∧
    ((predictive_4_6 (4, false)).1 = 3 ∧ (predictive_4_6 (6, true)).1 = 7) ∧
    ((9 + (10 - 9) = 10 ∧ 5 + (10 - 5) = 10) ∧
     (delayed_4_6 (9, true)).2 = false ∧ (delayed_4_6 (5, true)).2 = true ∧
     (delayed_4_6 (9, true)).2 ≠ (delayed_4_6 (5, true)).2) ∧
    ((9 + (10 - 9) = 10 ∧ 4 + (10 - 4) = 10) ∧
     (predictive_4_6 (9, true)).2 = false ∧ (predictive_4_6 (4, true)).2 = true ∧
     (predictive_4_6 (9, true)).2 ≠ (predictive_4_6 (4, true)).2) :=
  ⟨⟨rfl, rfl, rfl, rfl, rfl, fun t => (predictive_cycle_inv t).2⟩,
   ⟨rfl, rfl, rfl, delayed_4_6_inv⟩,
   ⟨rfl, rfl, delayed_4_5_inv⟩,
   ⟨rfl, rfl⟩,
   ⟨⟨rfl, rfl⟩, rfl, rfl, Bool.noConfusion⟩,
   ⟨⟨rfl, rfl⟩, rfl, rfl, Bool.noConfusion⟩⟩

end WaterTankCouplingWitness

/-! ### 3.14 Master Sharpness Summary Theorem -/

/-- **Complete Hypothesis-Dropping Sharpness Suite (`master_sharpness_suite_complete`)**:
bundles every new sharpness counter-model (`CE01a`, `CE01b`, `CE14`, `CE02`, `CE03`, `CE04`,
`CE05b`, `CE08a`, `CE08b`, `CE09`, `CE10`, `slackDist_nat_not_transitive`,
`exact_equivalence_is_class`, `WaterTankCouplingWitness.witness`) alongside the reused `CE05`,
`CE06`, and `CE07` witnesses and `alignmentSpine_cannot_entail_unrestricted`. -/
theorem master_sharpness_suite_complete {Pos F : Type} (p : Pos) (f : F) :
    (ReconfigCountdownJumpFails.st1.1 () = 1 ∧ ReconfigCountdownJumpFails.st2.1 () = 0) ∧
    ((BlindHideCollapse.blindOrbit 4).2.2 () = 0 ∧ ∀ t, (BlindHideCollapse.blindOrbit t).1 () = 6) ∧
    (BlindHideCollapse.hiddenSafeComp.emitAlarm (true, fun _ => 5) false ≠
      BlindHideCollapse.hiddenSafeComp.emitAlarm (true, fun _ => 8) false) ∧
    (¬ OpenComposition.ContractRefines (TypeSameSemanticsMismatch.mkContract 7)
        (TypeSameSemanticsMismatch.mkContract 3) (fun x => x ()) (fun x => x ()) (fun _ => 7) ∧
      (TypeSameSemanticsMismatch.badOrbit 4).1 () = 0) ∧
    (SilencingSumBreaksComposition.channel true
        (SilencingSumBreaksComposition.contractA.maxSilence +
         SilencingSumBreaksComposition.contractA.maxSilence) () = false ∧
      (SilencingSumBreaksComposition.compOrbit 5).1 () = 0) ∧
    (¬ (∀ k : Unit, RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole
          (SameWiringNonMonotoneSubstrate.gOvercrowd k)) ∧
      (SameWiringNonMonotoneSubstrate.badOrbit 3).1 () = 0) ∧
    (¬ ((ConcurrentReconfigConflict.mkStaticContract 1).postBudgetExt () +
          (ConcurrentReconfigConflict.mkStaticContract 1).postBudgetExt () ≤ 1) ∧
      (ConcurrentReconfigConflict.concurrentOrbit 3).1 () = 0) ∧
    ((∀ Δ : Nat, ¬ (LaxTubeOverflowWitness.sim.α Δ + LaxTubeOverflowWitness.sim.ε ≤ Δ)) ∧
      ¬ Viability.Kernel LaxTubeOverflowWitness.microProc (fun s => 10 ≤ s) 12) ∧
    (Viability.Kernel
        (OpenComposition.prodProcess CoupledLaxNonDecouplingWitness.statProc
          CoupledLaxNonDecouplingWitness.statProc)
        (fun u => 8 ≤ u.1 ∧ 8 ≤ u.2) (10, 10) ∧
      Law.orbit (RegimeMargin.step CoupledLaxNonDecouplingWitness.gShared (1 + 1)) 10 3 = 7) ∧
    (SelfModifyingValidatorCapture.capturedProc.step (.inl (fun _ => 5, true)) (.reconfig ())
        (.inr (fun _ => 5, ())) ∧
      SelfModifyingValidatorCapture.capLevel 5 = 0) ∧
    ((∀ t, (ViableSelfExternalizesVictim.twoOrbit t).1 false = 5) ∧
      (ViableSelfExternalizesVictim.twoOrbit 4).1 true = 0) ∧
    (SlackDist.nat.d 0 1 ≤ 1 ∧ SlackDist.nat.d 1 2 ≤ 1 ∧ ¬ (SlackDist.nat.d 0 2 ≤ 1)) ∧
    «类» Flame.alike ∧
    ((WaterTankCouplingWitness.delayed_4_6 (9, true)).2 ≠
      (WaterTankCouplingWitness.delayed_4_6 (5, true)).2 ∧
     (WaterTankCouplingWitness.predictive_4_6 (9, true)).2 ≠
      (WaterTankCouplingWitness.predictive_4_6 (4, true)).2) ∧
    (¬ (StockFlowBridge.lineFlow UnifiedDrawdown.OverdrawSeparationWitness.need
          UnifiedDrawdown.OverdrawSeparationWitness.kids
          UnifiedDrawdown.OverdrawSeparationWitness.giving
          UnifiedDrawdown.OverdrawSeparationWitness.use
          UnifiedDrawdown.OverdrawSeparationWitness.startState).Balances
        (StockFlowBridge.lineWeb UnifiedDrawdown.OverdrawSeparationWitness.need
          UnifiedDrawdown.OverdrawSeparationWitness.kids
          UnifiedDrawdown.OverdrawSeparationWitness.giving
          UnifiedDrawdown.OverdrawSeparationWitness.use
          UnifiedDrawdown.OverdrawSeparationWitness.startState) ∧
      ¬ Viability.Kernel PacedStock.SlackShortWitness.frame.P
          (fun s => PacedStock.SlackShortWitness.thr ≤ s.2) ([true], 5) ∧
      ¬ ProjectedLaws.FibreConsistent WitnessTwoScale.next WitnessTwoScale.π₁) ∧
    (∀ {D : Type} (SpineLaw : D → Prop) {d : D}, SpineLaw d →
      ¬ (∀ d' (sig : Pos → Nat → F → Prop), SpineLaw d' → Unrestricted sig)) :=
  ⟨⟨ReconfigCountdownJumpFails.witness.2.2.2.2.2.1, ReconfigCountdownJumpFails.witness.2.2.2.2.2.2.2⟩,
   ⟨BlindHideCollapse.witness.2.2.2.2.2.2.2.2.2.2, BlindHideCollapse.witness.2.2.2.2.2.1⟩,
   hide_side_channel_leakage.2.2,
   ⟨TypeSameSemanticsMismatch.witness.2.2.1, TypeSameSemanticsMismatch.witness.2.2.2.2.2.2.2⟩,
   ⟨SilencingSumBreaksComposition.witness.2.2.1, SilencingSumBreaksComposition.witness.2.2.2.2.2.2.2.2⟩,
   ⟨SameWiringNonMonotoneSubstrate.witness.2.2.1, SameWiringNonMonotoneSubstrate.witness.2.2.2.2.2.2⟩,
   ⟨ConcurrentReconfigConflict.witness.2.2.1, ConcurrentReconfigConflict.witness.2.2.2.2.2.2⟩,
   ⟨LaxTubeOverflowWitness.witness.2.1, LaxTubeOverflowWitness.witness.2.2.2⟩,
   ⟨CoupledLaxNonDecouplingWitness.witness.1, CoupledLaxNonDecouplingWitness.witness.2.2.2.2.2.1⟩,
   ⟨SelfModifyingValidatorCapture.witness.2.1, SelfModifyingValidatorCapture.witness.2.2.2.2.1.2.2.2.2⟩,
   ⟨(ViableSelfExternalizesVictim.witness p f).2.1, (ViableSelfExternalizesVictim.witness p f).2.2.1.2.2.2.2⟩,
   slackDist_nat_not_transitive,
   exact_equivalence_is_class.1,
   ⟨WaterTankCouplingWitness.witness.2.2.2.2.1.2.2.2, WaterTankCouplingWitness.witness.2.2.2.2.2.2.2.2⟩,
   ⟨UnifiedDrawdown.OverdrawSeparationWitness.witness_bundle.2.2.1,
    PacedStock.SlackShortWitness.atFive_not_fine_kernel,
    WitnessTwoScale.not_fibreConsistent₁⟩,
   fun {_} SpineLaw {_} holds => AlignmentDichotomy.alignmentSpine_cannot_entail_unrestricted SpineLaw p f holds⟩

end SharpnessSuite

/-! ## Top-Level End-to-End Alignment Spine Theorem -/

/-- **Top-level end-to-end structural alignment map (`alignment_spine_end_to_end`)**: joins a
representative headline slice projecting `MasterSpineWitness.witness_viable`,
`master_alignment_dichotomy`, and `master_sharpness_suite_complete` (for full trajectories and
re-exported `CE05`/`CE06`/`CE07`/dichotomy bundles, see those named theorems directly). -/
theorem alignment_spine_end_to_end {Pos F : Type} (p : Pos) (f : F) :
    (ComposedSpine.MasterSpineWitness.spineTaskModel.B_task = 42 ∧
      Viability.Kernel
        (OpenComposition.closedProcess ComposedSpine.MasterSpineWitness.witnessSpineComp
          ComposedSpine.MasterSpineWitness.witnessSpineContr ComposedSpine.MasterSpineWitness.witnessSpineObs
          ComposedSpine.MasterSpineWitness.witnessChannel ComposedSpine.MasterSpineWitness.gExt
          (fun _ _ => 0) (fun _ => True))
        (OpenComposition.closedGuard ComposedSpine.MasterSpineWitness.witnessSpineComp
          ComposedSpine.MasterSpineWitness.witnessSpineContr (fun _ => 10))
        (fun _ => 46, ComposedSpine.MasterSpineWitness.witnessSpineInit) ∧
      Viability.Kernel
        (OpenComposition.closedProcess ComposedSpine.MasterSpineWitness.witnessHiddenComp
          ComposedSpine.MasterSpineWitness.witnessHiddenContr ComposedSpine.MasterSpineWitness.witnessSpineObs
          ComposedSpine.MasterSpineWitness.witnessChannel ComposedSpine.MasterSpineWitness.gExt
          (fun _ _ => 0) (fun _ => True))
        (OpenComposition.closedGuard ComposedSpine.MasterSpineWitness.witnessHiddenComp
          ComposedSpine.MasterSpineWitness.witnessHiddenContr (fun _ => 10))
        (fun _ => 46, (ComposedSpine.MasterSpineWitness.witnessSpineInit, fun _ => 11))) ∧
    ((Law.orbit (fun st => OpenComposition.HiddenCouplingFailure.composedStep st ((), ((), ())))
        (fun _ => 4, ((), ())) 4).1 () = 0 ∧
      (∀ t, 3 ≤ t → ScopeDynamics.UncoordCommonsWitness.commons.substrate t = 0 ∧
        ∀ k, ¬ ScopeDynamics.UncoordCommonsWitness.commons.W_coop.MacroAdmits
          ScopeDynamics.UncoordCommonsWitness.commons.cap
          (ScopeDynamics.UncoordCommonsWitness.commons.W_coop.level t) t k) ∧
      Viability.Kernel PacedStock.SlackShortWitness.frame.P
        (fun s => PacedStock.SlackShortWitness.thr ≤ s.2) ([true], 6) ∧
      ¬ Viability.Kernel PacedStock.SlackShortWitness.frame.P
        (fun s => PacedStock.SlackShortWitness.thr ≤ s.2) ([true], 5) ∧
      (∀ {D : Type} (SpineLaw : D → Prop) {d : D}, SpineLaw d →
        ¬ (∀ d' (sig : Pos → Nat → F → Prop), SpineLaw d' → Unrestricted sig))) ∧
    ((SharpnessSuite.ReconfigCountdownJumpFails.st2.1 () = 0 ∧
      (SharpnessSuite.BlindHideCollapse.blindOrbit 4).2.2 () = 0 ∧
      SharpnessSuite.BlindHideCollapse.hiddenSafeComp.emitAlarm (true, fun _ => 5) false ≠
        SharpnessSuite.BlindHideCollapse.hiddenSafeComp.emitAlarm (true, fun _ => 8) false ∧
      (SharpnessSuite.TypeSameSemanticsMismatch.badOrbit 4).1 () = 0 ∧
      (SharpnessSuite.SilencingSumBreaksComposition.compOrbit 5).1 () = 0 ∧
      (SharpnessSuite.SameWiringNonMonotoneSubstrate.badOrbit 3).1 () = 0 ∧
      (SharpnessSuite.ConcurrentReconfigConflict.concurrentOrbit 3).1 () = 0 ∧
      ¬ Viability.Kernel SharpnessSuite.LaxTubeOverflowWitness.microProc (fun s => 10 ≤ s) 12 ∧
      Law.orbit (RegimeMargin.step SharpnessSuite.CoupledLaxNonDecouplingWitness.gShared (1 + 1)) 10 3 = 7 ∧
      SharpnessSuite.SelfModifyingValidatorCapture.capLevel 5 = 0 ∧
      (SharpnessSuite.ViableSelfExternalizesVictim.twoOrbit 4).1 true = 0) ∧
     (SlackDist.nat.d 0 1 ≤ 1 ∧ SlackDist.nat.d 1 2 ≤ 1 ∧ ¬ (SlackDist.nat.d 0 2 ≤ 1)) ∧
     «类» Flame.alike ∧
     ((SharpnessSuite.WaterTankCouplingWitness.delayed_4_6 (9, true)).2 ≠
        (SharpnessSuite.WaterTankCouplingWitness.delayed_4_6 (5, true)).2 ∧
      (SharpnessSuite.WaterTankCouplingWitness.predictive_4_6 (9, true)).2 ≠
        (SharpnessSuite.WaterTankCouplingWitness.predictive_4_6 (4, true)).2)) :=
  let hW := ComposedSpine.MasterSpineWitness.witness_viable
  let hD := AlignmentDichotomy.master_alignment_dichotomy p f
  let hS := SharpnessSuite.master_sharpness_suite_complete p f
  ⟨⟨hW.1, hW.2.1, hW.2.2.2.1⟩,
   ⟨hD.2.2.1, hD.2.2.2.1, hD.2.2.2.2.1, hD.2.2.2.2.2.1, hD.2.2.2.2.2.2⟩,
   ⟨⟨hS.1.2, hS.2.1.1, hS.2.2.1, hS.2.2.2.1.2, hS.2.2.2.2.1.2,
     hS.2.2.2.2.2.1.2, hS.2.2.2.2.2.2.1.2, hS.2.2.2.2.2.2.2.1.2,
     hS.2.2.2.2.2.2.2.2.1.2, hS.2.2.2.2.2.2.2.2.2.1.2, hS.2.2.2.2.2.2.2.2.2.2.1.2⟩,
    hS.2.2.2.2.2.2.2.2.2.2.2.1,
    hS.2.2.2.2.2.2.2.2.2.2.2.2.1,
    hS.2.2.2.2.2.2.2.2.2.2.2.2.2.1⟩⟩

end AlignmentSpine

end Becoming
