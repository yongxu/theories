import Becoming.Significance
import Becoming.Weightings
import Becoming.GroupEnding
import Becoming.RegimeMargin
import Becoming.Withholding
import Becoming.TransformativeViability
import Becoming.AdaptiveLoops
import Becoming.OpenComposition
import Becoming.StockFlowBridge

/-!
# Scope Dynamics: Mutual-Fate Selection, Open-Commons Invasion, and Reciprocal Coupling

AI-written (Lean Sufficiency Wave Pillar L3, 23 November 2026). No ethical predicate, ranking,
or axiom enters: every declaration is pure Lean prelude (`Init` only) with an empty axiom report
and zero `sorry`.

## What this module establishes

1. **Metaethical non-entailment and weighting bridge (`MetaethicalBoundary`)**:
   - Any dynamical scope law depending only on a dynamical system `d : D` lifts to
     `ReadsOnlyDynamics`, admits every rival bounded significance (`scopeLaw_admits_rival`), and
     cannot entail `Unrestricted sig` (`scopeLaw_not_entails`, `scopeLaw_cannot_entail_unrestricted`).
   - Mixed pre-collapse comparisons are decided both ways by positive weightings
     (`preCollapse_mixed_weighting` via `Weighting.mixed_either_way`), while widening over any
     finite evaluation horizon `items` is equivalent to every positive weighting ranking the wider
     course strictly higher (`finiteHorizon_widens_weighting` via
     `Weighting.widens_iff_every_positive`), complemented by the finite-horizon truncated web form
     (`longHorizon_widens_weighting` via `Web.widens_iff_every_weighting`).

2. **Theorem 1 — Mutual-fate selection of viable scope (`mutual_fate_selects_wide_scope`)**:
   - In isolated pools (`MutualFateSystem`), a narrow coalition optimizing short-horizon extraction
     (`wide.sub.H < narrow.sub.H`) exhausts its substrate to `0` in finite time, loses all
     substrate-coupled macro capabilities (`narrow_substrate_exhausts`), and drives coupled
     generations to zero offspring and emptiness (`narrow_lineage_ends_together` via
     `GroupEnding.Flow.coupled_end_together` and `GroupEnding.Flow.coupled_generation_childless`).
   - Meanwhile the wide coalition stays within its safe reserve band `[S_safe, hi]` forever
     (`wide_substrate_holds`), preserves `TransformativeViable` under widening, and satisfies
     `TransformsViably` with genuine micro-turnover (`MutualFateWitness` exhibits `T = 0, n = 1, m = 9`
     with non-empty `gs = [[.m1]]` at step `1`).

3. **Theorem 2 — Uncoordinated myopic invasion counter-theorem (`uncoordinated_myopic_invasion`)**:
   - In an open uncoordinated commons (`UncoordinatedCommons`) where a cooperator (`d_coop`) and
     myopic invader (`d_inv > d_coop`) share one substrate with no exclusion gate and net overdraw,
     the invader captures strictly higher instantaneous and cumulative yield at every pre-collapse
     step, while joint overdraw drives the substrate to `0` in finite steps, destroying even the
     cooperator (`UncoordCommonsWitness` at `S₀ = 12`), whereas an isolated cooperator would persist
     (`isolated_coop_would_persist`).

4. **Theorem 3 — Coupled reciprocal scope stability (`reciprocal_coupling_stabilizes_scope`)**:
   - Adding a computable exclusion gate `gateOpen : Nat → Bool` coupled bi-directionally to
     `Withholding.waitsAll` (`gateOpen_iff`) permanently locks a detected defector out from
     `T_gate` onward (`gate_closed_from`, `gate_stays_closed`), holds the shared substrate in
     `[S_safe, hi]` for all `t`, preserves `TransformsViably`, and strictly flips both instantaneous
     yield (`t ≥ T_gate`) and cumulative surplus (`t ≥ H_rec`) in favor of the cooperative pool.
   - `reciprocalGate_of_assumeGuarantee` bridges directly to `AdaptiveLoops.assume_guarantee_joint_viable`
     under global monotonicity `g_mono`, `coop_le_pre`, and the gross margin
     `S_safe + T_gate * H_pre ≤ S₀`, while `ReciprocalStabilityWitness` (at `S₀ = 12`, `Y_floor = 1`)
     and `uncoord_vs_reciprocal_contrast` exhibit the exact `S₀ = 12` survival vs. collapse contrast
     and the strict tightening of net buffer (`12`) over gross margin (`13`).

5. **Native `L0` Open-Interface Composition Bridge (`OpenCompositionBridge`)**:
   - Decomposes the reciprocal pool into `gatedDefectorComponent ⊕ coopComponent`, proves
     composed `Viability.Kernel` via `OpenComposition.compose_close_interchange`
     (`reciprocal_open_compose_viable`), proves heterogeneous replacement via
     `OpenComposition.ContractRefines` + `replace_left_viable` (`reciprocal_defector_replace_viable`),
     and contrasts uncoordinated collapse against composed reciprocal stability alongside
     `scopeLaw_cannot_entail_unrestricted` (`blindDefector_vs_reciprocal_open`).
-/

namespace Becoming
namespace ScopeDynamics

/-! ## 1. Metaethical Boundary & Weightings Bridge -/

section MetaethicalBoundary

/-- Any persistence, invasion, or stabilization law defined purely over a dynamical system `d : D`
    lifts trivially to a `ReadsOnlyDynamics` predicate over any `(Pos, F)`. -/
theorem scopeLaw_readsOnlyDynamics {Pos F D : Type} (ScopeLaw : D → Prop) :
    ReadsOnlyDynamics (Pos := Pos) (F := F)
      (fun d (_ : Pos → Nat → F → Prop) => ScopeLaw d) :=
  readsOnlyDynamics_of ScopeLaw

/-- Whenever `ScopeLaw d` holds dynamically, it holds equally under any rival restricted
    significance `bounded region` (`Rival` and `¬ Unrestricted`) when some `(p, f)` lies outside
    `region`. -/
theorem scopeLaw_admits_rival {Pos F D : Type} (ScopeLaw : D → Prop)
    {d : D} (holds : ScopeLaw d) (sig : Pos → Nat → F → Prop)
    {region : Pos → F → Prop} (outside : ∃ p f, ¬ region p f) :
    ScopeLaw d ∧ Rival (bounded region) ∧ ¬ Unrestricted (bounded region) :=
  ReadsOnlyDynamics.admits_rival (readsOnlyDynamics_of ScopeLaw) (sig := sig) holds outside

/-- Direct `ReadsOnlyDynamics.not_entails` bridge: no pure scope-dynamics law can entail
    `Unrestricted sig` whenever `d` exists (else `¬ ScopeLaw d`). -/
theorem scopeLaw_not_entails {Pos F D : Type} (ScopeLaw : D → Prop)
    (entails : ∀ d (sig : Pos → Nat → F → Prop), ScopeLaw d → Unrestricted sig)
    (p : Pos) (f : F) {d : D} : ¬ ScopeLaw d :=
  ReadsOnlyDynamics.not_entails (readsOnlyDynamics_of ScopeLaw) entails p f (sig := fun _ _ _ => True)

/-- Unconditional non-entailment from inhabited dynamical witnesses: any inference from
    `ScopeLaw` to `Unrestricted sig` is refutable once any `d` satisfies `ScopeLaw d`. -/
theorem scopeLaw_cannot_entail_unrestricted {Pos F D : Type} (ScopeLaw : D → Prop)
    (p : Pos) (f : F) {d : D} (holds : ScopeLaw d) :
    ¬ (∀ d' (sig : Pos → Nat → F → Prop), ScopeLaw d' → Unrestricted sig) :=
  fun entails => scopeLaw_not_entails ScopeLaw entails p f holds

/-- Pre-collapse mixed comparison: on any finite evaluation list where two courses are mixed,
    positive weightings decide strictly in either direction (`Weighting.mixed_either_way`). -/
theorem preCollapse_mixed_weighting {X : Type} {items : List X} {a b : X → Bool}
    (mixed : Weighting.MixedOn items a b) :
    (∃ w, Weighting.Positive items w ∧ Weighting.weighed items w b < Weighting.weighed items w a) ∧
      (∃ w', Weighting.Positive items w' ∧ Weighting.weighed items w' a < Weighting.weighed items w' b) :=
  Weighting.mixed_either_way mixed

/-- Finite-horizon widening: on any finite evaluation list `items`, `a_wide` widens `a_narrow`
    iff every positive weighting on `items` weighs `a_wide` strictly above `a_narrow`. Avoids
    `ListsAdmitted` unsatisfiability on eternal persistence trajectories. -/
theorem finiteHorizon_widens_weighting {X : Type} {items : List X} {a_wide a_narrow : X → Bool} :
    Weighting.WidensOn items a_wide a_narrow ↔
      ∀ w, Weighting.Positive items w →
        Weighting.weighed items w a_narrow < Weighting.weighed items w a_wide :=
  Weighting.widens_iff_every_positive

/-- Horizon-truncated web widening: for finite-horizon truncated webs whose admitted
    `(step, formation)` pairs for both paths lie inside `items`, `W.Widens l_wide l_narrow` holds
    iff every positive weighting on `items` weighs `admitted l_wide` strictly above
    `admitted l_narrow`. -/
theorem longHorizon_widens_weighting {F C : Type} {W : Web F C}
    {admitted : (Nat → C → Nat) → Nat × F → Bool}
    (decides : W.DecidesAdmission admitted)
    {items : List (Nat × F)} {l_wide l_narrow : Nat → C → Nat}
    (listed_wide : W.ListsAdmitted items l_wide)
    (listed_narrow : W.ListsAdmitted items l_narrow) :
    W.Widens l_wide l_narrow ↔
      ∀ w, Weighting.Positive items w →
        Weighting.weighed items w (admitted l_narrow) <
          Weighting.weighed items w (admitted l_wide) :=
  Web.widens_iff_every_weighting decides listed_wide listed_narrow

end MetaethicalBoundary

/-! ## 2. Theorem 1 — Mutual-Fate Selection of Viable Scope -/

/-- An isolated substrate pool evolving by `RegimeMargin.step g H` from `x₀`. -/
structure SubstratePool where
  g : Nat → Nat
  H : Nat
  x₀ : Nat
  fromNothing : RegimeMargin.FromNothing g

/-- Level of a substrate pool at step `t`. -/
def SubstratePool.level (P : SubstratePool) (t : Nat) : Nat :=
  (Law.run (RegimeMargin.step P.g P.H) P.x₀).state t

/-- Time-homogeneity shift for a `SubstratePool` trajectory via `Law.orbit_add`. -/
theorem SubstratePool.level_add (P : SubstratePool) (m n : Nat) :
    P.level (m + n) = (Law.run (RegimeMargin.step P.g P.H) (P.level m)).state n :=
  Law.orbit_add (RegimeMargin.step P.g P.H) P.x₀ m n

/-- A narrow coalition whose local draw exceeds max renewal `Y`, coupled to a capability web
    where every formation requires the coalition's substrate at positive need. -/
structure NarrowCoalition (F C K : Type) where
  sub : SubstratePool
  y : Nat
  Y : Nat
  n_fall : Nat
  atMost : RegimeMargin.AtMost sub.g Y
  exceeds : Y < sub.H
  short : RegimeMargin.Short sub.g sub.H y
  earlyBound : sub.x₀ < (sub.H + y) + (sub.H - Y) * n_fall
  W : Web F C
  cap : F → K
  cSub : C
  level_eq : ∀ t, W.level t cSub = sub.level t
  posNeed : ∀ t f, W.requires t f cSub ∧ 1 ≤ W.need t f cSub

/-- Coupled generation and lineage structure tied directly to `sub.level` via `stock_eq`,
    evaluating group extinction cleanly at step `T + n` (avoiding empty-group vacuity). -/
structure NarrowLineage (X : Type) (sub : SubstratePool) where
  W : Web X X
  L : Flow X X
  G : SelectionTerm.Generations X
  ds : List X
  gs : List (List X)
  T : Nat
  n : Nat
  m : Nat
  balances : L.Balances W
  acting : L.Acting W
  dependent : W.Dependent
  descended : SelectionTerm.Flow.Descended L W G
  gated : ∀ t f, f ∈ L.present t → ∀ d, d ∈ ds → 0 < L.give t f d →
    ∃ e, e ∈ ds ∧ W.requires t f e ∧ m ≤ W.need t f e
  excess : ∀ k, k < n → L.replenishment ds (T + k) < L.uptake ds (T + k)
  start : sub.level T < n + m
  stock_eq : ∀ t, W.stock ds t = sub.level t
  within : ∀ h p, h ∈ gs → p ∈ h → p ∈ G.family (T + n)
  coupled_family : ∀ p, p ∈ G.family (T + n) →
    ∃ e, e ∈ ds ∧ W.requires (T + n) p e ∧ m ≤ W.need (T + n) p e

/-- A wide, reserve-guarded coalition whose substrate remains inside `[S_safe, hi]` forever and
    whose capability web transforms viably with genuine micro-turnover. -/
structure WideCoalition (F C K : Type) where
  sub : SubstratePool
  y : Nat
  hi : Nat
  S_safe : Nat
  meets : RegimeMargin.Meets sub.g sub.H y hi
  keeps : RegimeMargin.Keeps sub.g sub.H hi
  safeFloor : sub.H + y ≤ S_safe
  initFloor : S_safe ≤ sub.x₀
  initCeil : sub.x₀ ≤ hi
  W : Web F C
  cap : F → K
  cSub : C
  level_eq : ∀ t, W.level t cSub = sub.level t
  Viable : (Nat → C → Nat) → Prop
  T_w : Nat
  guarded : ReserveGuarded W Viable
  viable : Viable W.level
  macroCont : ∀ s t, T_w ≤ s → s ≤ t → ∀ k,
    W.MacroAdmits cap (W.level s) s k → W.MacroAdmits cap (W.level t) t k
  turnover : ∀ t, T_w ≤ t → ∃ f, W.Admits (W.level t) t f ∧ ¬ W.Admits (W.level (t + 1)) (t + 1) f

/-- Isolated two-coalition mutual-fate system with short-step extraction temptation favoring
    the narrow coalition (`wide.sub.H < narrow.sub.H`). -/
structure MutualFateSystem (F_n C_n K_n F_w C_w K_w X : Type) where
  narrow : NarrowCoalition F_n C_n K_n
  narrowLin : NarrowLineage X narrow.sub
  wide : WideCoalition F_w C_w K_w
  shortRewardAdv : wide.sub.H < narrow.sub.H

/-- A narrow coalition exhausts its isolated substrate to `0` by step
    `n_fall + (sub.H + y)` and loses every substrate-coupled macro capability. -/
theorem narrow_substrate_exhausts {F C K : Type} (nc : NarrowCoalition F C K) :
    ∃ T_end, (∀ t, T_end ≤ t → nc.sub.level t = 0) ∧
      (∀ t, T_end ≤ t → ∀ k, ¬ nc.W.MacroAdmits nc.cap (nc.W.level t) t k) := by
  obtain ⟨k, hk_le, hk_lt⟩ :=
    RegimeMargin.falls_within nc.atMost (Nat.le_of_lt nc.exceeds)
      (Nat.le_add_right nc.sub.H nc.y) nc.earlyBound
  refine ⟨nc.n_fall + (nc.sub.H + nc.y), fun t ht => ?_, fun t ht mcap ⟨f, _, hadm⟩ => ?_⟩
  · have hsum_le : k + nc.sub.level k ≤ t :=
      Nat.le_trans (Nat.add_le_add hk_le (Nat.le_of_lt hk_lt)) ht
    obtain ⟨d, hd⟩ := le_dest hsum_le
    have hshift : t = k + (nc.sub.level k + d) := hd.trans (Nat.add_assoc k (nc.sub.level k) d)
    rw [hshift, nc.sub.level_add k (nc.sub.level k + d)]
    exact RegimeMargin.stays_ended nc.short nc.sub.fromNothing hk_lt d
  · have hsum_le : k + nc.sub.level k ≤ t :=
      Nat.le_trans (Nat.add_le_add hk_le (Nat.le_of_lt hk_lt)) ht
    obtain ⟨d, hd⟩ := le_dest hsum_le
    have hshift : t = k + (nc.sub.level k + d) := hd.trans (Nat.add_assoc k (nc.sub.level k) d)
    have hzero : nc.sub.level t = 0 := by
      rw [hshift, nc.sub.level_add k (nc.sub.level k + d)]
      exact RegimeMargin.stays_ended nc.short nc.sub.fromNothing hk_lt d
    have hle : 1 ≤ nc.W.level t nc.cSub :=
      Nat.le_trans (nc.posNeed t f).2 (hadm nc.cSub (nc.posNeed t f).1)
    rw [nc.level_eq t, hzero] at hle
    exact Nat.not_le_of_gt Nat.one_pos hle

/-- Coupled narrow lineages leave zero offspring across every group at step `T + n` and
    produce empty generations from step `T + n + 1` onward. -/
theorem narrow_lineage_ends_together {X : Type} {sub : SubstratePool} (nl : NarrowLineage X sub) :
    (∀ a, (∀ h, h ∈ nl.gs → total h (nl.G.offspringNumber (nl.T + nl.n)) = 0) ∧
      SelectionLevels.concordAmong nl.gs (nl.G.offspringNumber (nl.T + nl.n)) a = 0 ∧
      SelectionLevels.discordAmong nl.gs (nl.G.offspringNumber (nl.T + nl.n)) a = 0) ∧
    (∀ k y, ¬ y ∈ nl.G.family (nl.T + nl.n + k + 1)) := by
  have hstart : nl.W.stock nl.ds nl.T < nl.n + nl.m := by
    rw [nl.stock_eq nl.T]
    exact nl.start
  refine ⟨fun a => ?_, fun k => ?_⟩
  · exact GroupEnding.Flow.coupled_end_together nl.balances nl.acting nl.dependent nl.gated
      nl.excess hstart 0 nl.descended nl.within
      (fun h p mh mp => nl.coupled_family p (nl.within h p mh mp)) a
  · induction k with
    | zero =>
      exact GroupEnding.Flow.coupled_generation_childless nl.balances nl.acting nl.dependent
        nl.descended nl.gated nl.excess hstart 0 nl.coupled_family
    | succ k ih =>
      intro y mem
      have empty_prev : ∀ p, ¬ p ∈ nl.G.family (nl.T + nl.n + (k + 1)) := fun p mp =>
        ih p mp
      exact GroupEnding.Flow.coupled_generation_childless nl.balances nl.acting nl.dependent
        nl.descended nl.gated nl.excess hstart (k + 1) (fun p mp => absurd mp (empty_prev p)) y mem

/-- A wide coalition's substrate stays inside `[S_safe, hi]` forever. -/
theorem wide_substrate_holds {F C K : Type} (wc : WideCoalition F C K) :
    ∀ t, wc.S_safe ≤ wc.sub.level t ∧ wc.sub.level t ≤ wc.hi := fun t =>
  let h := RegimeMargin.holds wc.meets wc.keeps (Nat.le_trans wc.safeFloor wc.initFloor) wc.initCeil t
  ⟨Nat.le_trans wc.initFloor h.1, h.2⟩

/-- **Theorem 1 (`mutual_fate_selects_wide_scope`)**: Under isolated mutual-fate dynamics, the
    narrow coalition exhausts its substrate, loses all substrate-coupled macro capabilities, and
    ends its coupled lineages, while the wide coalition preserves its reserve band, satisfies
    `TransformsViably`, and preserves `TransformativeViable` under widening. -/
theorem mutual_fate_selects_wide_scope {F_n C_n K_n F_w C_w K_w X : Type}
    (sys : MutualFateSystem F_n C_n K_n F_w C_w K_w X) :
    (∃ T_end, (∀ t, T_end ≤ t → sys.narrow.sub.level t = 0) ∧
      (∀ t, T_end ≤ t → ∀ k, ¬ sys.narrow.W.MacroAdmits sys.narrow.cap (sys.narrow.W.level t) t k)) ∧
    ((∀ a, (∀ h, h ∈ sys.narrowLin.gs →
        total h (sys.narrowLin.G.offspringNumber (sys.narrowLin.T + sys.narrowLin.n)) = 0) ∧
      SelectionLevels.concordAmong sys.narrowLin.gs
        (sys.narrowLin.G.offspringNumber (sys.narrowLin.T + sys.narrowLin.n)) a = 0 ∧
      SelectionLevels.discordAmong sys.narrowLin.gs
        (sys.narrowLin.G.offspringNumber (sys.narrowLin.T + sys.narrowLin.n)) a = 0) ∧
     (∀ k y, ¬ y ∈ sys.narrowLin.G.family (sys.narrowLin.T + sys.narrowLin.n + k + 1))) ∧
    ((∀ t, sys.wide.S_safe ≤ sys.wide.sub.level t ∧ sys.wide.sub.level t ≤ sys.wide.hi) ∧
     TransformsViably sys.wide.W (fun t => sys.wide.S_safe ≤ sys.wide.sub.level t)
       sys.wide.cap sys.wide.T_w ∧
     (∀ l', sys.wide.Viable l' → sys.wide.W.Widens sys.wide.W.level l' →
       TransformativeViable sys.wide.W sys.wide.Viable sys.wide.cap sys.wide.W.level l')) :=
  ⟨narrow_substrate_exhausts sys.narrow,
   narrow_lineage_ends_together sys.narrowLin,
   ⟨wide_substrate_holds sys.wide,
    ⟨fun t _ => (wide_substrate_holds sys.wide t).1, sys.wide.macroCont, sys.wide.turnover⟩,
    fun _ viable' widens => widens_implies_transformativeViable sys.wide.guarded viable' widens⟩⟩

/-! ### Shared Concrete Renewal Law & Turnover Web for Witnesses -/

/-- Shared nonlinear substrate renewal law used across all concrete witnesses. -/
def gEx (e : Nat) : Nat :=
  if e < 3 then 0 else if e < 6 then 1 else 2

theorem gEx_fromNothing : RegimeMargin.FromNothing gEx := rfl

theorem gEx_atMost_two : RegimeMargin.AtMost gEx 2 := fun z => by
  show (if z < 3 then 0 else if z < 6 then 1 else 2) ≤ 2
  cases Nat.decLt z 3 with
  | isTrue h => rw [if_pos h]; exact Nat.zero_le 2
  | isFalse h =>
    rw [if_neg h]
    cases Nat.decLt z 6 with
    | isTrue h6 => rw [if_pos h6]; exact by decide
    | isFalse h6 => rw [if_neg h6]; exact Nat.le_refl 2

theorem gEx_short_five (y : Nat) : RegimeMargin.Short gEx 5 y := fun z _ =>
  Nat.lt_of_le_of_lt (gEx_atMost_two z) (by decide : 2 < 5)

theorem gEx_meets_two : RegimeMargin.Meets gEx 2 6 12 := fun z hz _ => by
  have hnot3 : ¬ z < 3 := Nat.not_lt_of_le (Nat.le_trans (by decide : 3 ≤ 6) hz)
  have hnot6 : ¬ z < 6 := Nat.not_lt_of_le hz
  show 2 ≤ (if z < 3 then 0 else if z < 6 then 1 else 2)
  rw [if_neg hnot3, if_neg hnot6]
  exact Nat.le_refl 2

theorem sub_le_of_le_add_nat : ∀ {x a b : Nat}, x ≤ a + b → x - a ≤ b
  | x, 0, _, h => by rw [Nat.sub_zero]; rw [Nat.zero_add] at h; exact h
  | 0, a + 1, _, _ => by rw [Nat.zero_sub]; exact Nat.zero_le _
  | x + 1, a + 1, b, h => by
    rw [Nat.succ_sub_succ]
    exact sub_le_of_le_add_nat (Nat.le_of_succ_le_succ ((Nat.succ_add a b).symm ▸ h))

theorem gEx_keeps (H : Nat) (hH : 2 ≤ H) : RegimeMargin.Keeps gEx H 12 := fun x hx => by
  have hsub : x - H ≤ 10 := sub_le_of_le_add_nat (Nat.le_trans hx (Nat.add_le_add_right hH 10))
  exact Nat.le_trans (Nat.add_le_add hsub (gEx_atMost_two (x - H))) (Nat.le_refl 12)

theorem gEx_mono : ∀ a b, a ≤ b → gEx a ≤ gEx b := fun a b hab => by
  show (if a < 3 then 0 else if a < 6 then 1 else 2) ≤
    (if b < 3 then 0 else if b < 6 then 1 else 2)
  cases Nat.decLt a 3 with
  | isTrue ha3 =>
    rw [if_pos ha3]
    exact Nat.zero_le _
  | isFalse ha3 =>
    rw [if_neg ha3]
    have hb3 : ¬ b < 3 := fun hb => ha3 (Nat.lt_of_le_of_lt hab hb)
    rw [if_neg hb3]
    cases Nat.decLt a 6 with
    | isTrue ha6 =>
      rw [if_pos ha6]
      cases Nat.decLt b 6 with
      | isTrue hb6 => rw [if_pos hb6]; exact Nat.le_refl 1
      | isFalse hb6 => rw [if_neg hb6]; exact by decide
    | isFalse ha6 =>
      rw [if_neg ha6]
      have hb6 : ¬ b < 6 := fun hb => ha6 (Nat.lt_of_le_of_lt hab hb)
      rw [if_neg hb6]
      exact Nat.le_refl 2

theorem natBeq_succ_self_false : ∀ t : Nat, Nat.beq (t + 1) t = false
  | 0 => rfl
  | t + 1 => natBeq_succ_self_false t

/-- Concrete formation space exhibiting genuine micro-turnover via `.fTool t`. -/
inductive PoolForm where
  | fBase
  | fTool (t : Nat)

/-- Concrete macro capability space. -/
inductive PoolCap where
  | kBase
  | kWork

/-- Mapping from concrete formations to macro capabilities. -/
def poolCap : PoolForm → PoolCap
  | .fBase => .kBase
  | .fTool _ => .kWork

/-- Concrete single-substrate web supporting base capability at `needSafe` and rotating
    step-indexed tool formations at `needSafe` on step `t` vs `needCeil` off-step. -/
def poolWeb (needSafe needCeil : Nat) (levelFn : Nat → Nat) : Web PoolForm Unit where
  level t _ := levelFn t
  active _ _ := True
  requires _ _ _ := True
  need t f _ := match f with
    | .fBase => needSafe
    | .fTool k => if Nat.beq t k then needSafe else needCeil
  draws _ _ _ := True

theorem poolWeb_admits_base {needSafe needCeil : Nat} {levelFn : Nat → Nat}
    {l : Unit → Nat} (hle : needSafe ≤ l ()) (t : Nat) :
    (poolWeb needSafe needCeil levelFn).Admits l t .fBase := fun c _ => by
  cases c
  exact hle

theorem poolWeb_admits_tool_self {needSafe needCeil : Nat} {levelFn : Nat → Nat}
    {l : Unit → Nat} (hle : needSafe ≤ l ()) (t : Nat) :
    (poolWeb needSafe needCeil levelFn).Admits l t (.fTool t) := fun c _ => by
  cases c
  show (if Nat.beq t t then needSafe else needCeil) ≤ l ()
  rw [beq_self t]
  exact hle

theorem poolWeb_not_admits_tool_next {needSafe needCeil : Nat} {levelFn : Nat → Nat}
    {l : Unit → Nat} (hlt : l () < needCeil) (t : Nat) :
    ¬ (poolWeb needSafe needCeil levelFn).Admits l (t + 1) (.fTool t) := fun hadm => by
  have hle : (if Nat.beq (t + 1) t then needSafe else needCeil) ≤ l () := hadm () trivial
  rw [natBeq_succ_self_false t] at hle
  exact Nat.not_le_of_gt hlt hle

theorem poolWeb_transformsViably {S_safe hi : Nat} {levelFn : Nat → Nat}
    (safe : ∀ t, S_safe ≤ levelFn t) (bounded_hi : ∀ t, levelFn t ≤ hi) :
    TransformsViably (poolWeb S_safe (hi + 1) levelFn)
      (fun t => S_safe ≤ levelFn t) poolCap 0 := by
  refine ⟨fun t _ => safe t, fun _ t _ _ k _ => ?_, fun t _ => ?_⟩
  · cases k with
    | kBase => exact ⟨.fBase, rfl, poolWeb_admits_base (safe t) t⟩
    | kWork => exact ⟨.fTool t, rfl, poolWeb_admits_tool_self (safe t) t⟩
  · exact ⟨.fTool t, poolWeb_admits_tool_self (safe t) t,
      poolWeb_not_admits_tool_next (Nat.lt_succ_of_le (bounded_hi (t + 1))) t⟩

/-! ### Concrete witness for Theorem 1 (`MutualFateWitness`), with non-empty `gs = [[.m1]]` at `T = 0, n = 1, m = 9` -/
namespace MutualFateWitness

/-- Coupled lineage carrier type for the narrow coalition witness. -/
inductive LineageNode where
  | cPool
  | m0
  | m1

def narrowSub : SubstratePool where
  g := gEx
  H := 5
  x₀ := 9
  fromNothing := gEx_fromNothing

def wideSub : SubstratePool where
  g := gEx
  H := 2
  x₀ := 9
  fromNothing := gEx_fromNothing

theorem narrowSub_zero : narrowSub.level 0 = 9 := rfl
theorem narrowSub_one : narrowSub.level 1 = 5 := rfl
theorem narrowSub_two_plus : ∀ t, narrowSub.level (t + 2) = 0
  | 0 => rfl
  | t + 1 => by
    show RegimeMargin.step gEx 5 (narrowSub.level (t + 2)) = 0
    rw [narrowSub_two_plus t]
    rfl

theorem wideSub_const : ∀ t, wideSub.level t = 9
  | 0 => rfl
  | t + 1 => by
    show RegimeMargin.step gEx 2 (wideSub.level t) = 9
    rw [wideSub_const t]
    rfl

def narrowCoal : NarrowCoalition PoolForm Unit PoolCap where
  sub := narrowSub
  y := 3
  Y := 2
  n_fall := 1
  atMost := gEx_atMost_two
  exceeds := by decide
  short := gEx_short_five 3
  earlyBound := by decide
  W := poolWeb 8 13 narrowSub.level
  cap := poolCap
  cSub := ()
  level_eq _ := rfl
  posNeed t f := ⟨trivial, by
    cases f with
    | fBase => exact (by decide : 1 ≤ 8)
    | fTool k =>
      show 1 ≤ (if Nat.beq t k then 8 else 13)
      cases Nat.beq t k
      · exact (by decide : 1 ≤ 13)
      · exact (by decide : 1 ≤ 8)⟩

def linWeb : Web LineageNode LineageNode where
  level t c := match c with
    | .cPool => narrowSub.level t
    | .m0 => 0
    | .m1 => match t with | 0 => 0 | _ + 1 => 1
  active t f := match t with
    | 0 => match f with
      | .m0 => True
      | .cPool => False
      | .m1 => False
    | _ + 1 => False
  requires _ _ c := match c with
    | .cPool => True
    | .m0 => False
    | .m1 => False
  need _ _ _ := 9
  draws t f c := match t with
    | 0 => match f with
      | .m0 => match c with
        | .cPool => True
        | .m0 => False
        | .m1 => False
      | .cPool => False
      | .m1 => False
    | _ + 1 => False

def linFlow : Flow LineageNode LineageNode where
  present t := match t with
    | 0 => [.m0]
    | 1 => [.m0]
    | _ + 2 => []
  take t f c := match t with
    | 0 => match f with
      | .m0 => match c with
        | .cPool => 5
        | .m0 => 0
        | .m1 => 0
      | .cPool => 0
      | .m1 => 0
    | 1 => match f with
      | .m0 => match c with
        | .cPool => 5
        | .m0 => 0
        | .m1 => 0
      | .cPool => 0
      | .m1 => 0
    | _ + 2 => 0
  give t f c := match t with
    | 0 => match f with
      | .m0 => match c with
        | .cPool => 1
        | .m0 => 0
        | .m1 => 1
      | .cPool => 0
      | .m1 => 0
    | _ + 1 => 0

def linGen : SelectionTerm.Generations LineageNode where
  first := [.m0]
  kids t p := match t with
    | 0 => match p with
      | .m0 => [.m1]
      | .cPool => []
      | .m1 => []
    | _ + 1 => []
  amount _ _ := 1

theorem linGen_one : linGen.family 1 = [.m1] := rfl

theorem lin_balances : linFlow.Balances linWeb := fun t c => by
  cases t with
  | zero => cases c <;> rfl
  | succ t1 =>
    cases t1 with
    | zero => cases c <;> rfl
    | succ t2 =>
      cases c with
      | cPool =>
        show narrowSub.level (t2 + 3) + 0 = narrowSub.level (t2 + 2) + 0
        rw [narrowSub_two_plus t2, narrowSub_two_plus (t2 + 1)]
      | m0 => rfl
      | m1 => rfl

theorem lin_acting : linFlow.Acting linWeb := fun t f c hf hpos => by
  cases t with
  | zero =>
    cases hf with
    | head => trivial
    | tail _ no => nomatch no
  | succ t1 =>
    cases t1 with
    | zero =>
      cases hf with
      | head => exact absurd hpos (Nat.lt_irrefl 0)
      | tail _ no => nomatch no
    | succ _ => nomatch hf

theorem lin_dependent : linWeb.Dependent := fun t f hact c hreq => by
  cases t with
  | zero =>
    cases f with
    | m0 =>
      cases c with
      | cPool => exact Nat.le_refl 9
      | m0 | m1 => exact False.elim hreq
    | cPool | m1 => exact False.elim hact
  | succ _ => exact False.elim hact

theorem linGen_two_plus : ∀ n : Nat, linGen.family (n + 2) = []
  | 0 => rfl
  | n + 1 => by
    show (linGen.family (n + 2)).flatMap (linGen.kids (n + 2)) = []
    rw [linGen_two_plus n]
    rfl

theorem lin_descended : SelectionTerm.Flow.Descended linFlow linWeb linGen := fun t p k hp hk => by
  cases t with
  | zero =>
    have hp0 : p = .m0 := by
      cases hp with
      | head => rfl
      | tail _ no => nomatch no
    subst hp0
    have hk1 : k = .m1 := by
      cases hk with
      | head => rfl
      | tail _ no => nomatch no
    subst hk1
    exact ⟨.head _, Nat.one_pos, ⟨Nat.lt_irrefl 0, Nat.one_pos⟩⟩
  | succ t1 =>
    cases t1 with
    | zero =>
      have hp1 : p = .m1 := by
        cases hp with
        | head => rfl
        | tail _ no => nomatch no
      subst hp1
      nomatch hk
    | succ t2 =>
      rw [linGen_two_plus t2] at hp
      nomatch hp

def narrowLin : NarrowLineage LineageNode narrowSub where
  W := linWeb
  L := linFlow
  G := linGen
  ds := [.cPool]
  gs := [[.m1]]
  T := 0
  n := 1
  m := 9
  balances := lin_balances
  acting := lin_acting
  dependent := lin_dependent
  descended := lin_descended
  gated t f hf d hd hpos := by
    cases t with
    | zero =>
      cases hf with
      | head => exact ⟨.cPool, .head _, trivial, Nat.le_refl 9⟩
      | tail _ no => nomatch no
    | succ t1 =>
      cases t1 with
      | zero =>
        cases hf with
        | head =>
          cases hd with
          | head => exact absurd hpos (Nat.lt_irrefl 0)
          | tail _ no => nomatch no
        | tail _ no => nomatch no
      | succ _ => nomatch hf
  excess k hk := by
    cases k with
    | zero => exact by decide
    | succ k' => exact absurd hk (Nat.not_lt_of_le (Nat.succ_le_succ (Nat.zero_le k')))
  start := by decide
  stock_eq t := Nat.add_zero (narrowSub.level t)
  within h p mh mp := by
    cases mh with
    | head =>
      cases mp with
      | head => exact .head _
      | tail _ no => nomatch no
    | tail _ no => nomatch no
  coupled_family p _ := ⟨.cPool, .head _, trivial, Nat.le_refl 9⟩

def wideViable (l : Nat → Unit → Nat) : Prop := ∀ t, 8 ≤ l t ()

def wideCoal : WideCoalition PoolForm Unit PoolCap where
  sub := wideSub
  y := 6
  hi := 12
  S_safe := 8
  meets := gEx_meets_two
  keeps := gEx_keeps 2 (Nat.le_refl 2)
  safeFloor := by decide
  initFloor := by decide
  initCeil := by decide
  W := poolWeb 8 13 wideSub.level
  cap := poolCap
  cSub := ()
  level_eq _ := rfl
  Viable := wideViable
  T_w := 0
  guarded l l' widens viable' t := by
    have hadm' : (poolWeb 8 13 wideSub.level).Admits (l' t) t .fBase :=
      poolWeb_admits_base (viable' t) t
    exact widens.1 t .fBase hadm' () trivial
  viable t := by show 8 ≤ wideSub.level t; rw [wideSub_const t]; exact by decide
  macroCont _ t _ _ k _ := match k with
    | .kBase => ⟨.fBase, rfl, poolWeb_admits_base (by show 8 ≤ wideSub.level t; rw [wideSub_const t]; exact by decide) t⟩
    | .kWork => ⟨.fTool t, rfl, poolWeb_admits_tool_self (by show 8 ≤ wideSub.level t; rw [wideSub_const t]; exact by decide) t⟩
  turnover t _ :=
    ⟨.fTool t,
     poolWeb_admits_tool_self (by show 8 ≤ wideSub.level t; rw [wideSub_const t]; exact by decide) t,
     poolWeb_not_admits_tool_next (by show wideSub.level (t + 1) < 13; rw [wideSub_const (t + 1)]; exact by decide) t⟩

def system : MutualFateSystem PoolForm Unit PoolCap PoolForm Unit PoolCap LineageNode where
  narrow := narrowCoal
  narrowLin := narrowLin
  wide := wideCoal
  shortRewardAdv := by decide

/-- Full non-vacuous witness check for Theorem 1: `gs` is non-empty (`[[.m1]]` in `family 1`),
    `narrow` collapses by step `2` while `wide` stays at `9 ∈ [8, 12]` with `TransformsViably`. -/
theorem witness_holds :
    system.narrowLin.gs = [[.m1]] ∧
    system.narrowLin.G.family 1 = [.m1] ∧
    system.narrow.sub.level 0 = 9 ∧
    system.narrow.sub.level 1 = 5 ∧
    (∀ t, 2 ≤ t → system.narrow.sub.level t = 0) ∧
    (∀ t, system.wide.sub.level t = 9) ∧
    ((∃ T_end, (∀ t, T_end ≤ t → system.narrow.sub.level t = 0) ∧
      (∀ t, T_end ≤ t → ∀ k, ¬ system.narrow.W.MacroAdmits system.narrow.cap (system.narrow.W.level t) t k)) ∧
     ((∀ a, (∀ h, h ∈ system.narrowLin.gs →
         total h (system.narrowLin.G.offspringNumber (system.narrowLin.T + system.narrowLin.n)) = 0) ∧
       SelectionLevels.concordAmong system.narrowLin.gs
         (system.narrowLin.G.offspringNumber (system.narrowLin.T + system.narrowLin.n)) a = 0 ∧
       SelectionLevels.discordAmong system.narrowLin.gs
         (system.narrowLin.G.offspringNumber (system.narrowLin.T + system.narrowLin.n)) a = 0) ∧
      (∀ k y, ¬ y ∈ system.narrowLin.G.family (system.narrowLin.T + system.narrowLin.n + k + 1))) ∧
     ((∀ t, system.wide.S_safe ≤ system.wide.sub.level t ∧ system.wide.sub.level t ≤ system.wide.hi) ∧
      TransformsViably system.wide.W (fun t => system.wide.S_safe ≤ system.wide.sub.level t)
        system.wide.cap system.wide.T_w ∧
      (∀ l', system.wide.Viable l' → system.wide.W.Widens system.wide.W.level l' →
        TransformativeViable system.wide.W system.wide.Viable system.wide.cap system.wide.W.level l'))) :=
  ⟨rfl, rfl, rfl, rfl, fun t ht => by
    obtain ⟨d, hd⟩ := le_dest ht
    rw [hd, Nat.add_comm 2 d]
    exact narrowSub_two_plus d,
   wideSub_const,
   mutual_fate_selects_wide_scope system⟩

end MutualFateWitness

/-! ## 3. Theorem 2 — Uncoordinated Myopic Invasion Counter-Theorem -/

/-- Cumulative sum of a `Nat`-valued sequence over steps `0 .. t - 1`. -/
def cumSum (f : Nat → Nat) : Nat → Nat
  | 0 => 0
  | t + 1 => cumSum f t + f t

/-- Open uncoordinated commons where a wide-scope cooperator (`d_coop`) and myopic invader
    (`d_inv > d_coop`) share one substrate with no exclusion gate and net overdraw. -/
structure UncoordinatedCommons (F C K : Type) where
  g : Nat → Nat
  fromNothing : RegimeMargin.FromNothing g
  Y : Nat
  atMost : RegimeMargin.AtMost g Y
  S₀ : Nat
  d_coop : Nat
  d_inv : Nat
  y_joint : Nat
  inv_adv : d_coop < d_inv
  joint_exceeds : Y < d_coop + d_inv
  joint_short : RegimeMargin.Short g (d_coop + d_inv) y_joint
  m_coop : Nat
  pos_need : 0 < m_coop
  W_coop : Web F C
  cap : F → K
  cSub : C
  level_eq : ∀ t, W_coop.level t cSub = (Law.run (RegimeMargin.step g (d_coop + d_inv)) S₀).state t
  coop_requires : ∀ t f, W_coop.requires t f cSub ∧ m_coop ≤ W_coop.need t f cSub

def UncoordinatedCommons.substrate {F C K : Type} (U : UncoordinatedCommons F C K) (t : Nat) : Nat :=
  (Law.run (RegimeMargin.step U.g (U.d_coop + U.d_inv)) U.S₀).state t

def UncoordinatedCommons.PreCollapse {F C K : Type} (U : UncoordinatedCommons F C K) (t : Nat) : Prop :=
  U.d_coop + U.d_inv ≤ U.substrate t

def UncoordinatedCommons.coopYield {F C K : Type} (U : UncoordinatedCommons F C K) (t : Nat) : Nat :=
  if U.d_coop + U.d_inv ≤ U.substrate t then U.d_coop else 0

def UncoordinatedCommons.invYield {F C K : Type} (U : UncoordinatedCommons F C K) (t : Nat) : Nat :=
  if U.d_coop + U.d_inv ≤ U.substrate t then U.d_inv else 0

def UncoordinatedCommons.cumCoop {F C K : Type} (U : UncoordinatedCommons F C K) : Nat → Nat :=
  cumSum U.coopYield

def UncoordinatedCommons.cumInv {F C K : Type} (U : UncoordinatedCommons F C K) : Nat → Nat :=
  cumSum U.invYield

/-- **Theorem 2 (`uncoordinated_myopic_invasion`)**: In an uncoordinated commons with strict
    invader short-step advantage and joint overdraw, the invader captures strictly more yield at
    every pre-collapse step and strictly higher cumulative yield, yet joint drawdown drives the
    shared substrate to `0` in finite time, destroying even the cooperator. -/
theorem uncoordinated_myopic_invasion {F C K : Type} (U : UncoordinatedCommons F C K) :
    (∀ t, U.PreCollapse t → U.coopYield t < U.invYield t) ∧
    (∀ t, (∀ s, s ≤ t → U.PreCollapse s) → U.cumCoop (t + 1) < U.cumInv (t + 1)) ∧
    (∃ T_end, ∀ t, T_end ≤ t →
      U.substrate t = 0 ∧
      U.substrate t < U.m_coop ∧
      U.coopYield t = 0 ∧
      U.invYield t = 0 ∧
      ∀ k, ¬ U.W_coop.MacroAdmits U.cap (U.W_coop.level t) t k) := by
  have step_lt : ∀ t, U.PreCollapse t → U.coopYield t < U.invYield t := fun t hpre => by
    have hpre' : U.d_coop + U.d_inv ≤ U.substrate t := hpre
    show (if U.d_coop + U.d_inv ≤ U.substrate t then U.d_coop else 0) <
      (if U.d_coop + U.d_inv ≤ U.substrate t then U.d_inv else 0)
    rw [if_pos hpre', if_pos hpre']
    exact U.inv_adv
  have cum_lt : ∀ t, (∀ s, s ≤ t → U.PreCollapse s) → U.cumCoop (t + 1) < U.cumInv (t + 1) := by
    intro t
    induction t with
    | zero =>
      intro pre
      show 0 + U.coopYield 0 < 0 + U.invYield 0
      rw [Nat.zero_add, Nat.zero_add]
      exact step_lt 0 (pre 0 (Nat.le_refl 0))
    | succ t ih =>
      intro pre
      have ih_lt := ih (fun s hs => pre s (Nat.le_succ_of_le hs))
      have cur_lt := step_lt (t + 1) (pre (t + 1) (Nat.le_refl (t + 1)))
      show U.cumCoop (t + 1) + U.coopYield (t + 1) < U.cumInv (t + 1) + U.invYield (t + 1)
      exact Nat.add_lt_add ih_lt cur_lt
  have hdiff_pos : 1 ≤ (U.d_coop + U.d_inv) - U.Y :=
    Naturals.le_sub_of_add_le U.joint_exceeds
  have hmul_le : U.S₀ + 1 ≤ ((U.d_coop + U.d_inv) - U.Y) * (U.S₀ + 1) :=
    Nat.le_trans (Nat.le_of_eq (Nat.one_mul (U.S₀ + 1)).symm)
      (Nat.mul_le_mul_right (U.S₀ + 1) hdiff_pos)
  have earlyBound : U.S₀ < (U.d_coop + U.d_inv + U.y_joint) + ((U.d_coop + U.d_inv) - U.Y) * (U.S₀ + 1) :=
    Nat.lt_of_lt_of_le (Nat.lt_succ_self U.S₀)
      (Nat.le_trans hmul_le (Nat.le_add_left _ _))
  obtain ⟨k, hk_le, hk_lt⟩ :=
    RegimeMargin.falls_within U.atMost (Nat.le_of_lt U.joint_exceeds)
      (Nat.le_add_right (U.d_coop + U.d_inv) U.y_joint) earlyBound
  refine ⟨step_lt, cum_lt, (U.S₀ + 1) + (U.d_coop + U.d_inv + U.y_joint), fun t ht => ?_⟩
  have hsum_le : k + U.substrate k ≤ t :=
    Nat.le_trans (Nat.add_le_add hk_le (Nat.le_of_lt hk_lt)) ht
  obtain ⟨d, hd⟩ := le_dest hsum_le
  have hshift : t = k + (U.substrate k + d) := hd.trans (Nat.add_assoc k (U.substrate k) d)
  have hzero : U.substrate t = 0 := by
    change Law.orbit (RegimeMargin.step U.g (U.d_coop + U.d_inv)) U.S₀ t = 0
    rw [hshift, Law.orbit_add (RegimeMargin.step U.g (U.d_coop + U.d_inv)) U.S₀ k (U.substrate k + d)]
    exact RegimeMargin.stays_ended U.joint_short U.fromNothing hk_lt d
  have hpos_H : 0 < U.d_coop + U.d_inv :=
    Nat.lt_of_le_of_lt (Nat.zero_le U.Y) U.joint_exceeds
  have hnot_pre : ¬ (U.d_coop + U.d_inv ≤ U.substrate t) := by
    rw [hzero]
    exact Nat.not_le_of_gt hpos_H
  refine ⟨hzero, ?_, ?_, ?_, fun _ ⟨f, _, hadm⟩ => ?_⟩
  · rw [hzero]; exact U.pos_need
  · show (if U.d_coop + U.d_inv ≤ U.substrate t then U.d_coop else 0) = 0
    rw [if_neg hnot_pre]
  · show (if U.d_coop + U.d_inv ≤ U.substrate t then U.d_inv else 0) = 0
    rw [if_neg hnot_pre]
  · have hle : U.m_coop ≤ U.W_coop.level t U.cSub :=
      Nat.le_trans (U.coop_requires t f).2 (hadm U.cSub (U.coop_requires t f).1)
    rw [U.level_eq t] at hle
    have hle0 : U.m_coop ≤ 0 := Nat.le_trans hle (Nat.le_of_eq hzero)
    exact Nat.not_le_of_gt U.pos_need hle0

/-- Counterfactual companion to Theorem 2: under the cooperator's isolated draw `d_coop` alone
    (when `Meets`, `Keeps`, and initial bounds hold), the cooperator would preserve `S₀` forever. -/
theorem isolated_coop_would_persist {F C K : Type} (U : UncoordinatedCommons F C K)
    {y_c hi : Nat}
    (meets_c : RegimeMargin.Meets U.g U.d_coop y_c hi)
    (keeps_c : RegimeMargin.Keeps U.g U.d_coop hi)
    (floor_c : U.d_coop + y_c ≤ U.S₀) (ceil_c : U.S₀ ≤ hi) :
    ∀ t, U.S₀ ≤ (Law.run (RegimeMargin.step U.g U.d_coop) U.S₀).state t ∧
      (Law.run (RegimeMargin.step U.g U.d_coop) U.S₀).state t ≤ hi :=
  RegimeMargin.holds meets_c keeps_c floor_c ceil_c

/-! ### Concrete witness for Theorem 2 at `S₀ = 12, d_coop = 2, d_inv = 3, m_coop = 8` -/
namespace UncoordCommonsWitness

def commons : UncoordinatedCommons PoolForm Unit PoolCap where
  g := gEx
  fromNothing := gEx_fromNothing
  Y := 2
  atMost := gEx_atMost_two
  S₀ := 12
  d_coop := 2
  d_inv := 3
  y_joint := 3
  inv_adv := by decide
  joint_exceeds := by decide
  joint_short := gEx_short_five 3
  m_coop := 8
  pos_need := by decide
  W_coop := poolWeb 8 13
    (fun t => (Law.run (RegimeMargin.step gEx (2 + 3)) 12).state t)
  cap := poolCap
  cSub := ()
  level_eq _ := rfl
  coop_requires t f := ⟨trivial, by
    cases f with
    | fBase => exact Nat.le_refl 8
    | fTool k =>
      show 8 ≤ (if Nat.beq t k then 8 else 13)
      cases Nat.beq t k <;> exact by decide⟩

theorem trajectory_step3 : ∀ k, commons.substrate (k + 3) = 0
  | 0 => rfl
  | k + 1 => by
    show RegimeMargin.step gEx (2 + 3) (commons.substrate (k + 3)) = 0
    rw [trajectory_step3 k]
    rfl

theorem trajectory_exact :
    commons.substrate 0 = 12 ∧
    commons.substrate 1 = 9 ∧
    commons.substrate 2 = 5 ∧
    (∀ t, 3 ≤ t → commons.substrate t = 0) := by
  refine ⟨rfl, rfl, rfl, fun t ht => ?_⟩
  obtain ⟨d, hd⟩ := le_dest ht
  rw [hd, Nat.add_comm 3 d]
  exact trajectory_step3 d

theorem witness_holds :
    commons.coopYield 0 < commons.invYield 0 ∧
    commons.coopYield 1 < commons.invYield 1 ∧
    commons.coopYield 2 < commons.invYield 2 ∧
    commons.cumCoop 3 < commons.cumInv 3 ∧
    (∀ t, 3 ≤ t → commons.substrate t = 0 ∧
      ∀ k, ¬ commons.W_coop.MacroAdmits commons.cap (commons.W_coop.level t) t k) ∧
    (∀ t, 12 ≤ (Law.run (RegimeMargin.step gEx 2) 12).state t ∧
      (Law.run (RegimeMargin.step gEx 2) 12).state t ≤ 12) := by
  refine ⟨by decide, by decide, by decide, by decide, fun t ht => ?_,
    isolated_coop_would_persist commons gEx_meets_two (gEx_keeps 2 (Nat.le_refl 2))
      (by decide) (by decide)⟩
  have hz := trajectory_exact.2.2.2 t ht
  refine ⟨hz, fun _ ⟨f, _, hadm⟩ => ?_⟩
  have hle : 8 ≤ commons.W_coop.level t () :=
    Nat.le_trans (commons.coop_requires t f).2 (hadm () (commons.coop_requires t f).1)
  change 8 ≤ commons.substrate t at hle
  rw [hz] at hle
  exact Nat.not_le_of_gt (by decide : 0 < 8) hle

end UncoordCommonsWitness

/-! ## 4. Theorem 3 — Coupled Reciprocal Scope Stability -/

/-- Substrate trajectory driven by a computable `gateOpen : Nat → Bool` signal: draws `H_pre`
    while `gateOpen t = true`, switching irreversibly to `H_coop` once `gateOpen t = false`. -/
def recSubstrate (g : Nat → Nat) (S₀ H_pre H_coop : Nat) (gateOpen : Nat → Bool) : Nat → Nat
  | 0 => S₀
  | t + 1 => RegimeMargin.step g (match gateOpen t with | true => H_pre | false => H_coop)
      (recSubstrate g S₀ H_pre H_coop gateOpen t)

/-- Defector step yield: `r_pre_def` while admitted (`gateOpen t = true`), `r_out` once excluded. -/
def recDefYield (r_pre_def r_out : Nat) (gateOpen : Nat → Bool) (t : Nat) : Nat :=
  match gateOpen t with
  | true => r_pre_def
  | false => r_out

/-- Cooperator step yield: `r_coop` whenever the substrate stays safe (`S_safe ≤ recSubstrate ... t`). -/
def recCoopYield (g : Nat → Nat) (S₀ S_safe H_pre H_coop r_coop : Nat)
    (gateOpen : Nat → Bool) (t : Nat) : Nat :=
  if S_safe ≤ recSubstrate g S₀ H_pre H_coop gateOpen t then r_coop else 0

/-- Coupled reciprocal pool system combining `RegimeMargin`, `Withholding.waitsAll` exclusion via
    a bi-directionally coupled `gateOpen : Nat → Bool`, net pre-gate drawdown safety `buffer_safe`,
    and cooperative `TransformsViably`. -/
structure ReciprocalPoolSystem (F C K GateNode : Type) where
  g : Nat → Nat
  fromNothing : RegimeMargin.FromNothing g
  S₀ : Nat
  S_safe : Nat
  hi : Nat
  y_coop : Nat
  H_pre : Nat
  H_coop : Nat
  r_coop : Nat
  r_pre_def : Nat
  r_out : Nat
  L_lag : Nat
  T_gate : Nat
  up : GateNode → GateNode → Prop
  s₀ : GateNode → Prop
  certNode : GateNode
  defGate : GateNode
  d_wait : Nat
  chain_to_gate : Withholding.Chain up d_wait certNode defGate
  cert_withheld : ¬ s₀ certNode
  gate_after_wait : d_wait ≤ T_gate
  lag_bound : T_gate ≤ L_lag
  gateOpen : Nat → Bool
  gateOpen_iff : ∀ t, gateOpen t = true ↔ (Law.run (Withholding.waitsAll up) s₀).state t defGate
  Y_floor : Nat
  floor_le_H : Y_floor ≤ H_pre
  renewal_floor : ∀ x, S_safe ≤ x → Y_floor ≤ g (x - H_pre)
  buffer_safe : S_safe + T_gate * (H_pre - Y_floor) ≤ S₀
  keeps_pre : RegimeMargin.Keeps g H_pre hi
  safe_le_hi : S_safe ≤ hi
  S₀_le_hi : S₀ ≤ hi
  meets_coop : RegimeMargin.Meets g H_coop y_coop hi
  keeps_coop : RegimeMargin.Keeps g H_coop hi
  safe_floor : H_coop + y_coop ≤ S_safe
  pre_temptation : r_coop ≤ r_pre_def
  post_gap : r_out + 1 ≤ r_coop
  W_coop : Web F C
  cap : F → K
  T_cap : Nat
  macro_of_safe :
    (∀ t, S_safe ≤ recSubstrate g S₀ H_pre H_coop gateOpen t) →
      TransformsViably W_coop
        (fun t => S_safe ≤ recSubstrate g S₀ H_pre H_coop gateOpen t) cap T_cap

def ReciprocalPoolSystem.substrate {F C K GateNode : Type}
    (P : ReciprocalPoolSystem F C K GateNode) (t : Nat) : Nat :=
  recSubstrate P.g P.S₀ P.H_pre P.H_coop P.gateOpen t

def ReciprocalPoolSystem.defYield {F C K GateNode : Type}
    (P : ReciprocalPoolSystem F C K GateNode) (t : Nat) : Nat :=
  recDefYield P.r_pre_def P.r_out P.gateOpen t

def ReciprocalPoolSystem.coopYield {F C K GateNode : Type}
    (P : ReciprocalPoolSystem F C K GateNode) (t : Nat) : Nat :=
  recCoopYield P.g P.S₀ P.S_safe P.H_pre P.H_coop P.r_coop P.gateOpen t

def ReciprocalPoolSystem.cumDef {F C K GateNode : Type}
    (P : ReciprocalPoolSystem F C K GateNode) : Nat → Nat :=
  cumSum P.defYield

def ReciprocalPoolSystem.cumCoop {F C K GateNode : Type}
    (P : ReciprocalPoolSystem F C K GateNode) : Nat → Nat :=
  cumSum P.coopYield

/-- Constructive `Nat` crossover horizon from which cumulative cooperative yield strictly exceeds
    defector cumulative yield. -/
def ReciprocalPoolSystem.H_rec {F C K GateNode : Type}
    (P : ReciprocalPoolSystem F C K GateNode) : Nat :=
  P.T_gate + (P.cumDef P.T_gate - P.cumCoop P.T_gate) + 1

theorem sub_eq_sub_succ_add_one : ∀ {T t : Nat}, t < T → T - t = (T - (t + 1)) + 1
  | 0, _, lt => absurd lt (Nat.not_lt_zero _)
  | _ + 1, 0, _ => rfl
  | T + 1, t + 1, lt =>
    (Nat.succ_sub_succ T t).trans
      ((sub_eq_sub_succ_add_one (Nat.lt_of_succ_lt_succ lt)).trans
        (congrArg (· + 1) (Nat.succ_sub_succ T (t + 1)).symm))

theorem le_add_sub_self_nat (a b : Nat) : a ≤ b + (a - b) :=
  (Nat.le_total a b).elim
    (fun h => Nat.le_trans h (Nat.le_add_right b (a - b)))
    (fun h => Nat.le_of_eq (Naturals.add_sub_of_le h).symm)

/-- Withholding closes the computable gate permanently from `T_gate` onward. -/
theorem ReciprocalPoolSystem.gate_closed_from {F C K GateNode : Type}
    (P : ReciprocalPoolSystem F C K GateNode) {t : Nat} (ht : P.T_gate ≤ t) :
    P.gateOpen t = false := by
  have hnot := Withholding.withholding_spreads P.cert_withheld P.chain_to_gate
    (Nat.le_trans P.gate_after_wait ht)
  cases hg : P.gateOpen t with
  | true => exact absurd ((P.gateOpen_iff t).mp hg) hnot
  | false => rfl

/-- Once closed, `Withholding.waitsAll_gives_earlier` prevents the gate from ever re-opening. -/
theorem ReciprocalPoolSystem.gate_stays_closed {F C K GateNode : Type}
    (P : ReciprocalPoolSystem F C K GateNode) {t : Nat} (hclosed : P.gateOpen t = false) :
    P.gateOpen (t + 1) = false := by
  cases hg : P.gateOpen (t + 1) with
  | false => rfl
  | true =>
    have hprev := Withholding.waitsAll_gives_earlier ((P.gateOpen_iff (t + 1)).mp hg)
    have hopen : P.gateOpen t = true := (P.gateOpen_iff t).mpr hprev
    exact absurd (hclosed.symm.trans hopen) (fun e => Bool.noConfusion e)

theorem ReciprocalPoolSystem.pre_H_le_safe_or_step {F C K GateNode : Type}
    (P : ReciprocalPoolSystem F C K GateNode) {x r : Nat}
    (hbuf : P.S_safe + (r + 1) * (P.H_pre - P.Y_floor) ≤ x) :
    P.H_pre ≤ x := by
  have hsafe : P.S_safe ≤ x :=
    Nat.le_trans (Nat.le_add_right P.S_safe _) hbuf
  cases hy : P.Y_floor with
  | zero =>
    have h1 : P.H_pre ≤ (r + 1) * (P.H_pre - P.Y_floor) := by
      rw [hy, Nat.sub_zero, Nat.succ_mul]
      exact Nat.le_add_left P.H_pre (r * P.H_pre)
    exact Nat.le_trans h1 (Nat.le_trans (Nat.le_add_left _ P.S_safe) hbuf)
  | succ y' =>
    have hlt : P.H_pre < P.S_safe := (Nat.lt_or_ge P.H_pre P.S_safe).elim id fun hge => by
      have hsub0 : P.S_safe - P.H_pre = 0 := sub_eq_zero_of_le hge
      have hfloor := P.renewal_floor P.S_safe (Nat.le_refl P.S_safe)
      rw [hy, hsub0, P.fromNothing] at hfloor
      exact absurd hfloor (Nat.not_le_of_gt (Nat.succ_pos y'))
    exact Nat.le_trans (Nat.le_of_lt hlt) hsafe

/-- Pre-gate drawdown + post-gate cooperative preservation keep `substrate t ∈ [S_safe, hi]`
    for every `t : Nat`. -/
theorem ReciprocalPoolSystem.substrate_safe_bounds {F C K GateNode : Type}
    (P : ReciprocalPoolSystem F C K GateNode) :
    ∀ t, P.substrate t ≤ P.hi ∧
      (P.gateOpen t = true → P.S_safe + (P.T_gate - t) * (P.H_pre - P.Y_floor) ≤ P.substrate t) ∧
      (P.gateOpen t = false → P.S_safe ≤ P.substrate t)
  | 0 => ⟨P.S₀_le_hi,
      fun _ => P.buffer_safe,
      fun _ => Nat.le_trans (Nat.le_add_right P.S_safe _) P.buffer_safe⟩
  | t + 1 => by
    obtain ⟨hHi, hTrue, hFalse⟩ := P.substrate_safe_bounds t
    cases hg : P.gateOpen t with
    | true =>
      have hltT : t < P.T_gate := (Nat.lt_or_ge t P.T_gate).elim id fun hge => by
        have hfl := P.gate_closed_from hge
        exact absurd (hfl.symm.trans hg) (fun e => Bool.noConfusion e)
      have hT : P.T_gate - t = (P.T_gate - (t + 1)) + 1 := sub_eq_sub_succ_add_one hltT
      have hbuf : P.S_safe + ((P.T_gate - (t + 1)) + 1) * (P.H_pre - P.Y_floor) ≤ P.substrate t := by
        rw [← hT]
        exact hTrue hg
      have hHle : P.H_pre ≤ P.substrate t := P.pre_H_le_safe_or_step hbuf
      have hsplit : P.S_safe + (P.T_gate - (t + 1)) * (P.H_pre - P.Y_floor) + (P.H_pre - P.Y_floor) ≤
          P.substrate t := by
        have eq1 : P.S_safe + ((P.T_gate - (t + 1)) + 1) * (P.H_pre - P.Y_floor) =
            P.S_safe + (P.T_gate - (t + 1)) * (P.H_pre - P.Y_floor) + (P.H_pre - P.Y_floor) := by
          rw [Nat.succ_mul, Nat.add_assoc]
        exact eq1 ▸ hbuf
      have hsafe_t : P.S_safe ≤ P.substrate t :=
        Nat.le_trans (Nat.le_add_right P.S_safe _) hbuf
      have hstep_eq : P.substrate (t + 1) = RegimeMargin.step P.g P.H_pre (P.substrate t) := by
        show RegimeMargin.step P.g (match P.gateOpen t with | true => P.H_pre | false => P.H_coop)
          (P.substrate t) = _
        rw [hg]
      have hHi' : P.substrate (t + 1) ≤ P.hi := hstep_eq ▸ P.keeps_pre (P.substrate t) hHi
      let B := P.S_safe + (P.T_gate - (t + 1)) * (P.H_pre - P.Y_floor)
      have hB_add : B + P.H_pre ≤ P.substrate (t + 1) + P.H_pre := calc
        B + P.H_pre = B + ((P.H_pre - P.Y_floor) + P.Y_floor) :=
          congrArg (B + ·) (Naturals.sub_add_cancel P.floor_le_H).symm
        _ = (B + (P.H_pre - P.Y_floor)) + P.Y_floor := (Nat.add_assoc B _ _).symm
        _ ≤ P.substrate t + P.Y_floor := Nat.add_le_add_right hsplit P.Y_floor
        _ ≤ P.substrate t + P.g (P.substrate t - P.H_pre) :=
          Nat.add_le_add_left (P.renewal_floor (P.substrate t) hsafe_t) (P.substrate t)
        _ = (P.substrate t - P.H_pre + P.H_pre) + P.g (P.substrate t - P.H_pre) :=
          congrArg (· + P.g (P.substrate t - P.H_pre)) (Naturals.sub_add_cancel hHle).symm
        _ = ((P.substrate t - P.H_pre) + P.g (P.substrate t - P.H_pre)) + P.H_pre :=
          Nat.add_right_comm _ _ _
        _ = P.substrate (t + 1) + P.H_pre := congrArg (· + P.H_pre) hstep_eq.symm
      have hB : B ≤ P.substrate (t + 1) := le_of_add_le_add_right P.H_pre hB_add
      exact ⟨hHi', fun _ => hB, fun _ => Nat.le_trans (Nat.le_add_right P.S_safe _) hB⟩
    | false =>
      have hclosed' : P.gateOpen (t + 1) = false := P.gate_stays_closed hg
      have hsafe_t : P.S_safe ≤ P.substrate t := hFalse hg
      have hlow : P.H_coop + P.y_coop ≤ P.substrate t := Nat.le_trans P.safe_floor hsafe_t
      have h1 := RegimeMargin.holds P.meets_coop P.keeps_coop hlow hHi 1
      have hstep_eq : P.substrate (t + 1) =
          (Law.run (RegimeMargin.step P.g P.H_coop) (P.substrate t)).state 1 := by
        show RegimeMargin.step P.g (match P.gateOpen t with | true => P.H_pre | false => P.H_coop)
          (P.substrate t) = _
        rw [hg]
        rfl
      have hHi' : P.substrate (t + 1) ≤ P.hi := hstep_eq ▸ h1.2
      have hSafe' : P.S_safe ≤ P.substrate (t + 1) :=
        Nat.le_trans hsafe_t (hstep_eq ▸ h1.1)
      exact ⟨hHi',
        fun hopen => absurd (hclosed'.symm.trans hopen) (fun e => Bool.noConfusion e),
        fun _ => hSafe'⟩

theorem ReciprocalPoolSystem.substrate_safe {F C K GateNode : Type}
    (P : ReciprocalPoolSystem F C K GateNode) (t : Nat) : P.S_safe ≤ P.substrate t := by
  obtain ⟨_, hTrue, hFalse⟩ := P.substrate_safe_bounds t
  cases hg : P.gateOpen t with
  | true => exact Nat.le_trans (Nat.le_add_right P.S_safe _) (hTrue hg)
  | false => exact hFalse hg

theorem ReciprocalPoolSystem.coopYield_eq {F C K GateNode : Type}
    (P : ReciprocalPoolSystem F C K GateNode) (t : Nat) : P.coopYield t = P.r_coop := by
  show (if P.S_safe ≤ P.substrate t then P.r_coop else 0) = P.r_coop
  rw [if_pos (P.substrate_safe t)]

theorem ReciprocalPoolSystem.defYield_closed {F C K GateNode : Type}
    (P : ReciprocalPoolSystem F C K GateNode) {t : Nat} (ht : P.T_gate ≤ t) :
    P.defYield t = P.r_out := by
  show (match P.gateOpen t with | true => P.r_pre_def | false => P.r_out) = P.r_out
  rw [P.gate_closed_from ht]

theorem ReciprocalPoolSystem.cumDef_after {F C K GateNode : Type}
    (P : ReciprocalPoolSystem F C K GateNode) :
    ∀ k, P.cumDef (P.T_gate + k) = P.cumDef P.T_gate + k * P.r_out
  | 0 => by rw [Nat.add_zero, Nat.zero_mul, Nat.add_zero]
  | k + 1 => by
    show P.cumDef (P.T_gate + k) + P.defYield (P.T_gate + k) = P.cumDef P.T_gate + (k + 1) * P.r_out
    rw [P.cumDef_after k, P.defYield_closed (Nat.le_add_right P.T_gate k), Nat.succ_mul, Nat.add_assoc]

theorem ReciprocalPoolSystem.cumCoop_after {F C K GateNode : Type}
    (P : ReciprocalPoolSystem F C K GateNode) :
    ∀ k, P.cumCoop (P.T_gate + k) = P.cumCoop P.T_gate + k * P.r_coop
  | 0 => by rw [Nat.add_zero, Nat.zero_mul, Nat.add_zero]
  | k + 1 => by
    show P.cumCoop (P.T_gate + k) + P.coopYield (P.T_gate + k) = P.cumCoop P.T_gate + (k + 1) * P.r_coop
    rw [P.cumCoop_after k, P.coopYield_eq (P.T_gate + k), Nat.succ_mul, Nat.add_assoc]

/-- **Theorem 3 (`reciprocal_coupling_stabilizes_scope`)**: Under bounded-lag detection +
    `Withholding.waitsAll` exclusion, the defector is permanently locked out from `T_gate`, the
    substrate remains `≥ S_safe` forever, `W_coop` satisfies `TransformsViably`, instantaneous yield
    flips from `T_gate`, and cumulative yield flips strictly from `H_rec` onward. -/
theorem reciprocal_coupling_stabilizes_scope {F C K GateNode : Type}
    (P : ReciprocalPoolSystem F C K GateNode) :
    (∀ t, P.T_gate ≤ t → ¬ (Law.run (Withholding.waitsAll P.up) P.s₀).state t P.defGate) ∧
    (∀ t, P.S_safe ≤ P.substrate t) ∧
    TransformsViably P.W_coop (fun t => P.S_safe ≤ P.substrate t) P.cap P.T_cap ∧
    (∀ t, P.T_gate ≤ t → P.defYield t < P.coopYield t) ∧
    (∀ t, P.H_rec ≤ t → P.cumDef t < P.cumCoop t) := by
  refine ⟨fun t ht => Withholding.withholding_spreads P.cert_withheld P.chain_to_gate
      (Nat.le_trans P.gate_after_wait ht),
    P.substrate_safe,
    P.macro_of_safe P.substrate_safe,
    fun t ht => ?_,
    fun t ht => ?_⟩
  · rw [P.defYield_closed ht, P.coopYield_eq t]
    exact P.post_gap
  · obtain ⟨d, hd⟩ := le_dest ht
    let D := P.cumDef P.T_gate - P.cumCoop P.T_gate
    let K := D + 1 + d
    have ht_eq : t = P.T_gate + K := by
      have h1 : t = P.T_gate + D + 1 + d := hd
      rw [Nat.add_assoc P.T_gate D 1, Nat.add_assoc P.T_gate (D + 1) d] at h1
      exact h1
    rw [ht_eq, P.cumDef_after K, P.cumCoop_after K]
    have hD : P.cumDef P.T_gate ≤ P.cumCoop P.T_gate + D :=
      le_add_sub_self_nat (P.cumDef P.T_gate) (P.cumCoop P.T_gate)
    have hDK : D < K := by
      show D < D + 1 + d
      exact Nat.lt_of_lt_of_le (Nat.lt_succ_self D) (Nat.le_add_right (D + 1) d)
    have hmul_gap : K * P.r_out + K ≤ K * P.r_coop := by
      have h1 : K * (P.r_out + 1) ≤ K * P.r_coop := Nat.mul_le_mul_left K P.post_gap
      rwa [Nat.mul_succ K P.r_out] at h1
    calc P.cumDef P.T_gate + K * P.r_out
        ≤ (P.cumCoop P.T_gate + D) + K * P.r_out := Nat.add_le_add_right hD (K * P.r_out)
      _ = P.cumCoop P.T_gate + (D + K * P.r_out) := Nat.add_assoc _ _ _
      _ < P.cumCoop P.T_gate + (K + K * P.r_out) :=
          Nat.add_lt_add_left (Nat.add_lt_add_right hDK (K * P.r_out)) (P.cumCoop P.T_gate)
      _ = P.cumCoop P.T_gate + (K * P.r_out + K) := congrArg (P.cumCoop P.T_gate + ·) (Nat.add_comm K _)
      _ ≤ P.cumCoop P.T_gate + K * P.r_coop := Nat.add_le_add_left hmul_gap (P.cumCoop P.T_gate)

/-! ### Compositional `AdaptiveLoops` Assume-Guarantee Bridge -/

/-- Open loop wrapper representing the pool's bounded-lag drawdown controller (`s = eta ≤ T_gate`)
    with `draw = H_pre` when `0 < s` and `draw = H_coop` when `s = 0`. -/
def reciprocalOpenLoop (H_pre H_coop : Nat) : AdaptiveLoops.OpenLoop Nat Bool Unit Unit where
  next s oa _ := if oa.2 then s - 1 else s
  draw s _ := match s with | 0 => H_coop | _ + 1 => H_pre
  emitAlarm _ obs := obs
  silenceLoad _ := 0
  favours s := 0 < s

/-- Observation map firing below `warnLevel`. -/
def reciprocalObs (warnLevel : Nat) (_ : Unit) (x : Unit → Nat) : Bool :=
  Nat.blt (x ()) warnLevel

/-- Blind communication channel reading only `(emit, silenceLoad)`. -/
def reciprocalChannel (emit : Unit → Bool) (load : Unit → Nat) (_ : Unit) : Bool :=
  emit () && Nat.ble (load ()) 0

/-- Assume-guarantee `LoopCertificate` for `reciprocalOpenLoop` with `maxLag = T_gate`. -/
def reciprocalLoopCert (H_pre H_coop T_gate : Nat) (coop_le_pre : H_coop ≤ H_pre) :
    AdaptiveLoops.LoopCertificate (reciprocalOpenLoop H_pre H_coop) T_gate where
  tol _ _ := True
  warnObs obs := obs = true
  preCap _ := H_pre
  postBudget _ := H_coop
  maxSilence := 0
  maxLag := T_gate
  K s := s ≤ T_gate
  eta s := s
  init_in := Nat.le_refl T_gate
  cert := Viability.certificate_disturbed_iff.mpr
    ⟨fun s _ =>
      ⟨fun _ => by
        cases s with
        | zero => exact coop_le_pre
        | succ _ => exact Nat.le_refl H_pre,
       Nat.le_refl 0,
       fun h0 => by
        subst h0
        exact ⟨Nat.lt_irrefl 0, fun _ => Nat.le_refl H_coop⟩⟩,
     fun s m _ hs => by
      cases h : m.1.2 with
      | true =>
        show (if m.1.2 then s - 1 else s) ≤ T_gate
        rw [h]
        exact Nat.le_trans (Nat.sub_le s 1) hs
      | false =>
        show (if m.1.2 then s - 1 else s) ≤ T_gate
        rw [h]
        exact hs⟩
  eta_bound _ hs := hs
  emits_on_warn _ _ _ warn := warn
  eta_alarm_step s _ _ _ _ hpos := by
    cases s with
    | zero => exact absurd hpos (Nat.lt_irrefl 0)
    | succ k => exact Nat.lt_succ_self k
  eta_alarm_zero s _ _ _ _ h0 := by
    subst h0
    rfl

/-- **Compositional `AdaptiveLoops` Assume-Guarantee Bridge (`reciprocalGate_of_assumeGuarantee`)**:
    Instantiates `AdaptiveLoops.assume_guarantee_joint_viable` and `assume_guarantee_joint_kernel`
    on `ι := Unit` under global monotonicity `g_mono`, `coop_le_pre : P.H_coop ≤ P.H_pre`, and the
    gross pre-adaptation margin `gross_buffer : P.S_safe + P.T_gate * P.H_pre ≤ P.S₀`. Note that
    `ReciprocalPoolSystem.buffer_safe` with `0 < Y_floor` strictly sharpens this gross margin. -/
theorem reciprocalGate_of_assumeGuarantee {F C K GateNode : Type}
    (P : ReciprocalPoolSystem F C K GateNode)
    (g_mono : ∀ a b, a ≤ b → P.g a ≤ P.g b)
    (coop_le_pre : P.H_coop ≤ P.H_pre)
    (gross_buffer : P.S_safe + P.T_gate * P.H_pre ≤ P.S₀) :
    AdaptiveLoops.jointInv [()]
      (fun _ => reciprocalLoopCert P.H_pre P.H_coop P.T_gate coop_le_pre)
      (fun _ => 0) (fun _ => P.S_safe) (fun _ => P.S₀, fun _ => P.T_gate) ∧
    Viability.Kernel
      (AdaptiveLoops.jointProcess [()] (fun _ => reciprocalOpenLoop P.H_pre P.H_coop)
        (fun _ => reciprocalLoopCert P.H_pre P.H_coop P.T_gate coop_le_pre)
        (reciprocalObs (P.S_safe + (P.T_gate + 1) * P.H_pre))
        reciprocalChannel (fun _ e => P.g (e ())) (fun _ _ => 0) (fun _ => True))
      (AdaptiveLoops.jointGuard [()] (fun _ => reciprocalOpenLoop P.H_pre P.H_coop)
        (fun _ => reciprocalLoopCert P.H_pre P.H_coop P.T_gate coop_le_pre)
        (fun _ => P.S_safe))
      (fun _ => P.S₀, fun _ => P.T_gate) := by
  have hG_rises : ∀ i : Unit,
      RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (fun (e : Unit → Nat) => P.g (e ())) :=
    fun _ _ _ hbelow => g_mono _ _ (hbelow ())
  have hpost_viable : ∀ j : Unit,
      P.S_safe ≤ RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole
        (fun _ (e : Unit → Nat) => P.g (e ())) (fun _ => P.H_coop) (fun _ => P.S_safe) j := by
    intro j
    cases j
    show P.S_safe ≤ (P.S_safe - P.H_coop) + P.g (P.S_safe - P.H_coop)
    have hH_le : P.H_coop ≤ P.S_safe := Nat.le_trans (Nat.le_add_right P.H_coop P.y_coop) P.safe_floor
    have hy_le : P.y_coop ≤ P.S_safe - P.H_coop := Naturals.le_sub_of_add_le P.safe_floor
    have hceil : (P.S_safe - P.H_coop) + P.H_coop ≤ P.hi := by
      rw [Naturals.sub_add_cancel hH_le]
      exact P.safe_le_hi
    have hg_ge : P.H_coop ≤ P.g (P.S_safe - P.H_coop) := P.meets_coop _ hy_le hceil
    calc P.S_safe = (P.S_safe - P.H_coop) + P.H_coop := (Naturals.sub_add_cancel hH_le).symm
      _ ≤ (P.S_safe - P.H_coop) + P.g (P.S_safe - P.H_coop) := Nat.add_le_add_left hg_ge _
  have hpost_share : ∀ j : Unit,
      AdaptiveLoops.sumDraws [()]
        (fun (_ : Unit) => (reciprocalLoopCert P.H_pre P.H_coop P.T_gate coop_le_pre).postBudget) j + 0 ≤
        P.H_coop := fun _ =>
    Nat.le_of_eq ((Nat.add_zero _).trans (Nat.add_zero _))
  have hmaxLag_le :
      AdaptiveLoops.globalMaxLag [()] (L := fun _ => reciprocalOpenLoop P.H_pre P.H_coop)
        (init := fun _ => P.T_gate)
        (fun _ => reciprocalLoopCert P.H_pre P.H_coop P.T_gate coop_le_pre) ≤ P.T_gate :=
    AdaptiveLoops.foldNatMax_le_of_all fun _ _ => Nat.le_refl P.T_gate
  have hmaxEta_le :
      AdaptiveLoops.maxEta [()] (L := fun _ => reciprocalOpenLoop P.H_pre P.H_coop)
        (init := fun _ => P.T_gate)
        (fun _ => reciprocalLoopCert P.H_pre P.H_coop P.T_gate coop_le_pre)
        (fun _ => P.T_gate) ≤ P.T_gate :=
    AdaptiveLoops.foldNatMax_le_of_all fun _ _ => Nat.le_refl P.T_gate
  have hpreTotal_eq : ∀ j : Unit,
      AdaptiveLoops.preTotal [()] (L := fun _ => reciprocalOpenLoop P.H_pre P.H_coop)
        (init := fun _ => P.T_gate)
        (fun _ => reciprocalLoopCert P.H_pre P.H_coop P.T_gate coop_le_pre)
        (fun _ => 0) j = P.H_pre := fun _ =>
    (Nat.add_zero _).trans (Nat.add_zero _)
  have hwarn_margin : ∀ j : Unit,
      P.S_safe + (AdaptiveLoops.globalMaxLag [()] (L := fun _ => reciprocalOpenLoop P.H_pre P.H_coop)
        (init := fun _ => P.T_gate)
        (fun _ => reciprocalLoopCert P.H_pre P.H_coop P.T_gate coop_le_pre) + 1) *
        AdaptiveLoops.preTotal [()] (L := fun _ => reciprocalOpenLoop P.H_pre P.H_coop)
          (init := fun _ => P.T_gate)
          (fun _ => reciprocalLoopCert P.H_pre P.H_coop P.T_gate coop_le_pre) (fun _ => 0) j ≤
        P.S_safe + (P.T_gate + 1) * P.H_pre := fun j => by
    rw [hpreTotal_eq j]
    exact Nat.add_le_add_left (Nat.mul_le_mul_right P.H_pre (Nat.succ_le_succ hmaxLag_le)) P.S_safe
  have hinit_margin : ∀ j : Unit,
      P.S_safe + AdaptiveLoops.maxEta [()] (L := fun _ => reciprocalOpenLoop P.H_pre P.H_coop)
        (init := fun _ => P.T_gate)
        (fun _ => reciprocalLoopCert P.H_pre P.H_coop P.T_gate coop_le_pre)
        (fun _ => P.T_gate) *
        AdaptiveLoops.preTotal [()] (L := fun _ => reciprocalOpenLoop P.H_pre P.H_coop)
          (init := fun _ => P.T_gate)
          (fun _ => reciprocalLoopCert P.H_pre P.H_coop P.T_gate coop_le_pre) (fun _ => 0) j ≤
        P.S₀ := fun j => by
    rw [hpreTotal_eq j]
    exact Nat.le_trans
      (Nat.add_le_add_left (Nat.mul_le_mul_right P.H_pre hmaxEta_le) P.S_safe)
      gross_buffer
  have hviable := AdaptiveLoops.assume_guarantee_joint_viable
    [()] [()] (fun j => by cases j; exact .head _)
    (fun _ => reciprocalOpenLoop P.H_pre P.H_coop)
    (fun _ => P.T_gate)
    (fun _ => reciprocalLoopCert P.H_pre P.H_coop P.T_gate coop_le_pre)
    (reciprocalObs (P.S_safe + (P.T_gate + 1) * P.H_pre))
    reciprocalChannel (fun _ e => P.g (e ())) (fun _ _ => 0) (fun _ => 0) (fun _ => True)
    (fun _ _ _ => Nat.zero_le 0)
    (fun _ => P.S_safe) (fun _ => P.S_safe + (P.T_gate + 1) * P.H_pre)
    (fun _ => P.H_coop) (fun _ => P.S₀)
    (fun _ _ => True)
    (fun _ _ x j _ hlt => by cases j; exact Nat.ble_eq_true_of_le hlt)
    (fun j _ => ⟨(), .head _, trivial⟩)
    (fun emit load _ _ ⟨i, _, hemit, hload⟩ _ => by
      cases i
      have hemit' : emit () = true := hemit
      have hload' : load () ≤ 0 := hload
      show (emit () && Nat.ble (load ()) 0) = true
      rw [hemit', Nat.ble_eq_true_of_le hload']
      rfl)
    hG_rises hpost_viable hpost_share hwarn_margin hinit_margin
  exact ⟨hviable.1, hviable.2.kernel hviable.1⟩

/-! ### Concrete Witness for Theorem 3 (`ReciprocalStabilityWitness`) at `S₀ = 12, Y_floor = 1` -/
namespace ReciprocalStabilityWitness

/-- Two-node access withholding graph: `defPool` waits on `cert`. -/
inductive PoolGateNode where
  | cert
  | defPool

inductive GateWaits : PoolGateNode → PoolGateNode → Prop where
  | certToDef : GateWaits .cert .defPool

def gateInit : PoolGateNode → Prop
  | .cert => False
  | .defPool => True

def witnessGateOpen : Nat → Bool
  | 0 => true
  | _ + 1 => false

theorem witnessGateOpen_iff : ∀ t,
    witnessGateOpen t = true ↔
      (Law.run (Withholding.waitsAll GateWaits) gateInit).state t .defPool
  | 0 => ⟨fun _ => trivial, fun _ => rfl⟩
  | t + 1 =>
    ⟨fun h => Bool.noConfusion h,
     fun gives => absurd gives
       (Withholding.withholding_spreads (fun (h : gateInit PoolGateNode.cert) => h)
         (Withholding.Chain.step (Withholding.Chain.here PoolGateNode.cert) GateWaits.certToDef)
         (Nat.succ_le_succ (Nat.zero_le t)))⟩

theorem witness_substrate_zero : recSubstrate gEx 12 5 2 witnessGateOpen 0 = 12 := rfl
theorem witness_substrate_succ :
    ∀ t, recSubstrate gEx 12 5 2 witnessGateOpen (t + 1) = 9
  | 0 => rfl
  | t + 1 => by
    show RegimeMargin.step gEx (match witnessGateOpen (t + 1) with | true => 5 | false => 2)
      (recSubstrate gEx 12 5 2 witnessGateOpen (t + 1)) = 9
    rw [witness_substrate_succ t]
    rfl

theorem witness_substrate_le_12 : ∀ t, recSubstrate gEx 12 5 2 witnessGateOpen t ≤ 12
  | 0 => Nat.le_refl 12
  | t + 1 => by rw [witness_substrate_succ t]; exact by decide

def pool : ReciprocalPoolSystem PoolForm Unit PoolCap PoolGateNode where
  g := gEx
  fromNothing := gEx_fromNothing
  S₀ := 12
  S_safe := 8
  hi := 12
  y_coop := 6
  H_pre := 5
  H_coop := 2
  r_coop := 2
  r_pre_def := 3
  r_out := 1
  L_lag := 1
  T_gate := 1
  up := GateWaits
  s₀ := gateInit
  certNode := PoolGateNode.cert
  defGate := PoolGateNode.defPool
  d_wait := 1
  chain_to_gate := Withholding.Chain.step (Withholding.Chain.here PoolGateNode.cert) GateWaits.certToDef
  cert_withheld h := h
  gate_after_wait := Nat.le_refl 1
  lag_bound := Nat.le_refl 1
  gateOpen := witnessGateOpen
  gateOpen_iff := witnessGateOpen_iff
  Y_floor := 1
  floor_le_H := by decide
  renewal_floor x hx := by
    have hz : 3 ≤ x - 5 := Naturals.le_sub_of_add_le hx
    have hnot3 : ¬ (x - 5 < 3) := Nat.not_lt_of_le hz
    show 1 ≤ (if x - 5 < 3 then 0 else if x - 5 < 6 then 1 else 2)
    rw [if_neg hnot3]
    cases Nat.decLt (x - 5) 6 with
    | isTrue h6 => rw [if_pos h6]; exact Nat.le_refl 1
    | isFalse h6 => rw [if_neg h6]; exact by decide
  buffer_safe := by decide
  keeps_pre := gEx_keeps 5 (by decide)
  safe_le_hi := by decide
  S₀_le_hi := by decide
  meets_coop := gEx_meets_two
  keeps_coop := gEx_keeps 2 (Nat.le_refl 2)
  safe_floor := by decide
  pre_temptation := by decide
  post_gap := by decide
  W_coop := poolWeb 8 13 (recSubstrate gEx 12 5 2 witnessGateOpen)
  cap := poolCap
  T_cap := 0
  macro_of_safe safe := poolWeb_transformsViably safe witness_substrate_le_12

/-- Sharpened `S₀ = 12` witness satisfies Theorem 3 with `H_rec = 3`, while strictly sharpening
    `AdaptiveLoops`'s gross margin (`8 + 1 * (5 - 1) = 12 < 13 = 8 + 1 * 5`). -/
theorem witness_holds :
    pool.H_rec = 3 ∧
    pool.defYield 0 = 3 ∧
    pool.coopYield 0 = 2 ∧
    pool.defYield 1 = 1 ∧
    pool.coopYield 1 = 2 ∧
    pool.cumDef 3 = 5 ∧
    pool.cumCoop 3 = 6 ∧
    pool.S_safe + pool.T_gate * (pool.H_pre - pool.Y_floor) = 12 ∧
    pool.S_safe + pool.T_gate * pool.H_pre = 13 ∧
    (∀ t, 8 ≤ pool.substrate t ∧ pool.substrate t ≤ 12) ∧
    (∀ t, 1 ≤ t → pool.defYield t < pool.coopYield t) ∧
    (∀ t, 3 ≤ t → pool.cumDef t < pool.cumCoop t) := by
  have hstab := reciprocal_coupling_stabilizes_scope pool
  refine ⟨rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl,
    fun t => ⟨hstab.2.1 t, witness_substrate_le_12 t⟩,
    hstab.2.2.2.1, hstab.2.2.2.2⟩

theorem witness13_substrate_succ :
    ∀ k, recSubstrate gEx 13 5 2 witnessGateOpen (k + 1) = 10
  | 0 => rfl
  | k + 1 => by
    show RegimeMargin.step gEx (match witnessGateOpen (k + 1) with | true => 5 | false => 2)
      (recSubstrate gEx 13 5 2 witnessGateOpen (k + 1)) = 10
    rw [witness13_substrate_succ k]
    rfl

theorem witness13_substrate_le_13 : ∀ t, recSubstrate gEx 13 5 2 witnessGateOpen t ≤ 13
  | 0 => Nat.le_refl 13
  | t + 1 => by rw [witness13_substrate_succ t]; exact by decide

/-- Matching `ReciprocalPoolSystem` at `S₀ = 13` demonstrating `reciprocalGate_of_assumeGuarantee`. -/
def poolAt13 : ReciprocalPoolSystem PoolForm Unit PoolCap PoolGateNode where
  g := gEx
  fromNothing := gEx_fromNothing
  S₀ := 13
  S_safe := 8
  hi := 13
  y_coop := 6
  H_pre := 5
  H_coop := 2
  r_coop := 2
  r_pre_def := 3
  r_out := 1
  L_lag := 1
  T_gate := 1
  up := GateWaits
  s₀ := gateInit
  certNode := PoolGateNode.cert
  defGate := PoolGateNode.defPool
  d_wait := 1
  chain_to_gate := Withholding.Chain.step (Withholding.Chain.here PoolGateNode.cert) GateWaits.certToDef
  cert_withheld h := h
  gate_after_wait := Nat.le_refl 1
  lag_bound := Nat.le_refl 1
  gateOpen := witnessGateOpen
  gateOpen_iff := witnessGateOpen_iff
  Y_floor := 1
  floor_le_H := by decide
  renewal_floor x hx := pool.renewal_floor x hx
  buffer_safe := by decide
  keeps_pre x hx := by
    have hsub : x - 5 ≤ 8 := sub_le_of_le_add_nat (Nat.le_trans hx (by decide : 13 ≤ 5 + 8))
    exact Nat.le_trans (Nat.add_le_add hsub (gEx_atMost_two (x - 5))) (by decide : 8 + 2 ≤ 13)
  safe_le_hi := by decide
  S₀_le_hi := by decide
  meets_coop x hx1 hx2 := by
    have hnot3 : ¬ x < 3 := Nat.not_lt_of_le (Nat.le_trans (by decide : 3 ≤ 6) hx1)
    have hnot6 : ¬ x < 6 := Nat.not_lt_of_le hx1
    show 2 ≤ (if x < 3 then 0 else if x < 6 then 1 else 2)
    rw [if_neg hnot3, if_neg hnot6]
    exact Nat.le_refl 2
  keeps_coop x hx := by
    have hsub : x - 2 ≤ 11 := sub_le_of_le_add_nat (Nat.le_trans hx (by decide : 13 ≤ 2 + 11))
    exact Nat.le_trans (Nat.add_le_add hsub (gEx_atMost_two (x - 2))) (by decide : 11 + 2 ≤ 13)
  safe_floor := by decide
  pre_temptation := by decide
  post_gap := by decide
  W_coop := poolWeb 8 14 (recSubstrate gEx 13 5 2 witnessGateOpen)
  cap := poolCap
  T_cap := 0
  macro_of_safe safe := poolWeb_transformsViably safe witness13_substrate_le_13

theorem assumeGuarantee_at_13 :
    AdaptiveLoops.jointInv [()]
      (fun _ => reciprocalLoopCert 5 2 1 (by decide))
      (fun _ => 0) (fun _ => 8) (fun _ => 13, fun _ => 1) ∧
    Viability.Kernel
      (AdaptiveLoops.jointProcess [()] (fun _ => reciprocalOpenLoop 5 2)
        (fun _ => reciprocalLoopCert 5 2 1 (by decide))
        (reciprocalObs (8 + (1 + 1) * 5))
        reciprocalChannel (fun _ e => gEx (e ())) (fun _ _ => 0) (fun _ => True))
      (AdaptiveLoops.jointGuard [()] (fun _ => reciprocalOpenLoop 5 2)
        (fun _ => reciprocalLoopCert 5 2 1 (by decide))
        (fun _ => 8))
      (fun _ => 13, fun _ => 1) :=
  reciprocalGate_of_assumeGuarantee poolAt13 gEx_mono (by decide) (by decide)

end ReciprocalStabilityWitness

/-- **Head-to-head comparison at exact baseline (`S₀ = 12, d_coop = 2, d_def = 3, gEx`)**:
    Uncoordinated commons (`UncoordCommonsWitness.commons`) collapses `12 → 9 → 5 → 0`, destroying
    all cooperative capabilities at `t = 3`, whereas coupled reciprocal gating
    (`ReciprocalStabilityWitness.pool`) locks the defector out at `t = 1`, stabilizes the shared
    substrate at `9 ∈ [8, 12]` forever, preserves `TransformsViably`, and reverses cumulative
    surplus strictly from `H_rec = 3`. -/
theorem uncoord_vs_reciprocal_contrast :
    UncoordCommonsWitness.commons.S₀ = ReciprocalStabilityWitness.pool.S₀ ∧
    UncoordCommonsWitness.commons.substrate 0 = 12 ∧
    UncoordCommonsWitness.commons.substrate 1 = 9 ∧
    UncoordCommonsWitness.commons.substrate 2 = 5 ∧
    (∀ t, 3 ≤ t → UncoordCommonsWitness.commons.substrate t = 0 ∧
      ∀ k, ¬ UncoordCommonsWitness.commons.W_coop.MacroAdmits
        UncoordCommonsWitness.commons.cap
        (UncoordCommonsWitness.commons.W_coop.level t) t k) ∧
    ReciprocalStabilityWitness.pool.substrate 0 = 12 ∧
    (∀ t, 1 ≤ t → ReciprocalStabilityWitness.pool.substrate t = 9) ∧
    (∀ t, 8 ≤ ReciprocalStabilityWitness.pool.substrate t ∧
      ReciprocalStabilityWitness.pool.substrate t ≤ 12) ∧
    TransformsViably ReciprocalStabilityWitness.pool.W_coop
      (fun t => 8 ≤ ReciprocalStabilityWitness.pool.substrate t)
      ReciprocalStabilityWitness.pool.cap 0 ∧
    (∀ t, 1 ≤ t →
      ReciprocalStabilityWitness.pool.defYield t <
        ReciprocalStabilityWitness.pool.coopYield t) ∧
    (∀ t, 3 ≤ t →
      ReciprocalStabilityWitness.pool.cumDef t <
        ReciprocalStabilityWitness.pool.cumCoop t) := by
  have hstab := reciprocal_coupling_stabilizes_scope ReciprocalStabilityWitness.pool
  refine ⟨rfl, rfl, rfl, rfl, UncoordCommonsWitness.witness_holds.2.2.2.2.1, rfl,
    fun t ht => ?_,
    ReciprocalStabilityWitness.witness_holds.2.2.2.2.2.2.2.2.2.1,
    hstab.2.2.1, hstab.2.2.2.1, hstab.2.2.2.2⟩
  obtain ⟨d, hd⟩ := le_dest ht
  rw [hd, Nat.add_comm 1 d]
  exact ReciprocalStabilityWitness.witness_substrate_succ d

/-! ## 5. Native `L0` Open-Interface Composition Bridge (`OpenCompositionBridge`) -/

namespace OpenCompositionBridge

/-- Cooperative pool member modeled as a stateless `OpenComponent` drawing constant `H_coop`
    on the single shared boundary port `Unit` with zero lag and no alarm emission. -/
def coopComponent (H_coop : Nat) : OpenComposition.OpenComponent Unit Unit Unit Empty Unit where
  next _ _ _ := ()
  drawInt _ e := Empty.elim e
  drawExt _ _ := H_coop
  emitAlarm _ _ := false
  silenceLoad _ := 0
  favours _ := False

/-- Assume-guarantee `InterfaceContract` for `coopComponent H_coop`. -/
def coopContract (H_coop : Nat) :
    OpenComposition.InterfaceContract (coopComponent H_coop) () where
  tol _ _ := True
  warnObs _ := False
  preCapInt e := Empty.elim e
  preCapExt _ := H_coop
  postBudgetInt e := Empty.elim e
  postBudgetExt _ := H_coop
  maxSilence := 0
  maxLag := 0
  K _ := True
  eta _ := 0
  init_in := trivial
  cert := Viability.certificate_disturbed_iff.mpr
    ⟨fun _ _ =>
      ⟨fun e => Empty.elim e,
       fun _ => Nat.le_refl H_coop,
       Nat.le_refl 0,
       fun _ => ⟨fun f => f, fun e => Empty.elim e, fun _ => Nat.le_refl H_coop⟩⟩,
     fun _ _ _ _ => trivial⟩
  eta_bound _ _ := Nat.le_refl 0
  emits_on_warn _ _ _ f := False.elim f
  eta_alarm_step _ _ _ _ _ pos := absurd pos (Nat.lt_irrefl 0)
  eta_alarm_zero _ _ _ _ _ _ := rfl

/-- Gated defector modeled as an `OpenComponent` whose countdown state `s : Nat` closes from
    `H_def_pre` down to `H_def_post` upon external alarm within lag `T_gate`. -/
def gatedDefectorComponent (H_def_pre H_def_post T_gate : Nat) :
    OpenComposition.OpenComponent Nat Bool Unit Empty Unit where
  next s oa _ := match oa.2 with
    | true => if s ≤ T_gate then s - 1 else T_gate
    | false => s
  drawInt _ e := Empty.elim e
  drawExt s _ := match s with
    | 0 => H_def_post
    | _ + 1 => H_def_pre
  emitAlarm _ obs := obs
  silenceLoad _ := 0
  favours s := 0 < s

/-- Assume-guarantee `InterfaceContract` for `gatedDefectorComponent` under `H_def_post ≤ H_def_pre`. -/
def gatedDefectorContract (H_def_pre H_def_post T_gate : Nat)
    (post_le_pre : H_def_post ≤ H_def_pre) :
    OpenComposition.InterfaceContract (gatedDefectorComponent H_def_pre H_def_post T_gate) T_gate where
  tol _ _ := True
  warnObs obs := obs = true
  preCapInt e := Empty.elim e
  preCapExt _ := H_def_pre
  postBudgetInt e := Empty.elim e
  postBudgetExt _ := H_def_post
  maxSilence := 0
  maxLag := T_gate
  K s := s ≤ T_gate
  eta s := s
  init_in := Nat.le_refl T_gate
  cert := Viability.certificate_disturbed_iff.mpr
    ⟨fun s _ =>
      ⟨fun e => Empty.elim e,
       fun _ => by
         cases s with
         | zero => exact post_le_pre
         | succ _ => exact Nat.le_refl H_def_pre,
       Nat.le_refl 0,
       fun h0 => by
         subst h0
         exact ⟨Nat.lt_irrefl 0, fun e => Empty.elim e, fun _ => Nat.le_refl H_def_post⟩⟩,
     fun s m _ hs => by
       cases h : m.1.2 with
       | true =>
         show (match m.1.2 with | true => if s ≤ T_gate then s - 1 else T_gate | false => s) ≤ T_gate
         rw [h, if_pos hs]
         exact Nat.le_trans (Nat.sub_le s 1) hs
       | false =>
         show (match m.1.2 with | true => if s ≤ T_gate then s - 1 else T_gate | false => s) ≤ T_gate
         rw [h]
         exact hs⟩
  eta_bound _ hs := hs
  emits_on_warn _ _ _ warn := warn
  eta_alarm_step s _ _ _ hs hpos := by
    show (if s ≤ T_gate then s - 1 else T_gate) < s
    rw [if_pos hs]
    cases s with
    | zero => exact absurd hpos (Nat.lt_irrefl 0)
    | succ k => exact Nat.lt_succ_self k
  eta_alarm_zero s _ _ _ hs h0 := by
    subst h0
    show (if 0 ≤ T_gate then 0 - 1 else T_gate) = 0
    rw [if_pos hs]

/-- Blind binary channel for `OpenComposition.closedProcess` reading only `(em, load)`. -/
def openReciprocalChannel (em : Bool) (load : Nat) (_ : Unit) : Bool :=
  em && Nat.ble load 0

/-- **Composed reciprocal viability (`reciprocal_open_compose_viable`)**: decomposes a
    `ReciprocalPoolSystem` horizontally as `gatedDefectorComponent ⊕ coopComponent` (with
    `gatedDefectorComponent` on the left so `replace_left_viable` applies cleanly) and proves
    global `Viability.Kernel` on `closedProcess` directly via `OpenComposition.compose_close_interchange`. -/
theorem reciprocal_open_compose_viable {F C K GateNode : Type}
    (P : ReciprocalPoolSystem F C K GateNode)
    (g_mono : ∀ a b, a ≤ b → P.g a ≤ P.g b)
    (coop_le_pre : P.H_coop ≤ P.H_pre)
    (gross_buffer : P.S_safe + P.T_gate * P.H_pre ≤ P.S₀) :
    Viability.Kernel
      (OpenComposition.closedProcess
        ((gatedDefectorComponent (P.H_pre - P.H_coop) 0 P.T_gate).compose (coopComponent P.H_coop))
        (OpenComposition.composeContract
          (gatedDefectorContract (P.H_pre - P.H_coop) 0 P.T_gate (Nat.zero_le _))
          (coopContract P.H_coop))
        (fun x => (reciprocalObs (P.S_safe + (P.T_gate + 1) * P.H_pre) () x, ()))
        openReciprocalChannel (fun _ e => P.g (e ())) (fun _ _ => 0) (fun _ => True))
      (OpenComposition.closedGuard
        ((gatedDefectorComponent (P.H_pre - P.H_coop) 0 P.T_gate).compose (coopComponent P.H_coop))
        (OpenComposition.composeContract
          (gatedDefectorContract (P.H_pre - P.H_coop) 0 P.T_gate (Nat.zero_le _))
          (coopContract P.H_coop))
        (fun _ => P.S_safe))
      (fun _ => P.S₀, (P.T_gate, ())) := by
  have hG_rises : ∀ k : Unit,
      RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (fun (e : Unit → Nat) => P.g (e ())) :=
    fun _ _ _ hbelow => g_mono _ _ (hbelow ())
  have hpost_viable : ∀ k : Unit,
      P.S_safe ≤ RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole
        (fun _ (e : Unit → Nat) => P.g (e ())) (fun _ => P.H_coop) (fun _ => P.S_safe) k := by
    intro k
    cases k
    show P.S_safe ≤ (P.S_safe - P.H_coop) + P.g (P.S_safe - P.H_coop)
    have hH_le : P.H_coop ≤ P.S_safe := Nat.le_trans (Nat.le_add_right P.H_coop P.y_coop) P.safe_floor
    have hy_le : P.y_coop ≤ P.S_safe - P.H_coop := Naturals.le_sub_of_add_le P.safe_floor
    have hceil : (P.S_safe - P.H_coop) + P.H_coop ≤ P.hi := by
      rw [Naturals.sub_add_cancel hH_le]
      exact P.safe_le_hi
    have hg_ge : P.H_coop ≤ P.g (P.S_safe - P.H_coop) := P.meets_coop _ hy_le hceil
    calc P.S_safe = (P.S_safe - P.H_coop) + P.H_coop := (Naturals.sub_add_cancel hH_le).symm
      _ ≤ (P.S_safe - P.H_coop) + P.g (P.S_safe - P.H_coop) := Nat.add_le_add_left hg_ge _
  have hmax_le : AdaptiveLoops.natMax P.T_gate 0 ≤ P.T_gate :=
    AdaptiveLoops.natMax_le (Nat.le_refl P.T_gate) (Nat.zero_le P.T_gate)
  have hcap_eq : (P.H_pre - P.H_coop + P.H_coop) + 0 = P.H_pre :=
    (Nat.add_zero _).trans (Naturals.sub_add_cancel coop_le_pre)
  refine OpenComposition.compose_close_interchange
    (gatedDefectorComponent (P.H_pre - P.H_coop) 0 P.T_gate) (coopComponent P.H_coop)
    (gatedDefectorContract (P.H_pre - P.H_coop) 0 P.T_gate (Nat.zero_le _))
    (coopContract P.H_coop)
    (reciprocalObs (P.S_safe + (P.T_gate + 1) * P.H_pre) ())
    (fun _ => ())
    openReciprocalChannel (fun _ e => P.g (e ())) (fun _ _ => 0) (fun _ => 0) (fun _ => True)
    (fun _ _ _ => Nat.zero_le 0)
    (fun _ => P.S_safe) (fun _ => P.S_safe + (P.T_gate + 1) * P.H_pre)
    (fun _ => P.H_coop) (fun _ => P.S₀)
    (fun x k hlt => by
      cases k
      exact Or.inl (Nat.ble_eq_true_of_le hlt))
    (fun load _ _ hle => by
      have hle0 : load ≤ 0 := Nat.le_trans hle (Nat.le_refl 0)
      show (true && Nat.ble load 0) = true
      rw [Nat.ble_eq_true_of_le hle0]
      rfl)
    hG_rises hpost_viable
    (fun _ => Nat.le_of_eq ((Nat.add_zero _).trans (Nat.zero_add P.H_coop)))
    (fun _ => by
      change P.S_safe + (AdaptiveLoops.natMax P.T_gate 0 + 1) * ((P.H_pre - P.H_coop + P.H_coop) + 0) ≤
        P.S_safe + (P.T_gate + 1) * P.H_pre
      rw [hcap_eq]
      exact Nat.add_le_add_left (Nat.mul_le_mul_right P.H_pre (Nat.succ_le_succ hmax_le)) P.S_safe)
    (fun _ => by
      change P.S_safe + AdaptiveLoops.natMax P.T_gate 0 * ((P.H_pre - P.H_coop + P.H_coop) + 0) ≤ P.S₀
      rw [hcap_eq]
      exact Nat.le_trans
        (Nat.add_le_add_left (Nat.mul_le_mul_right P.H_pre hmax_le) P.S_safe)
        gross_buffer)

/-- Explicit witness instantiation of `reciprocal_open_compose_viable` on
    `ReciprocalStabilityWitness.poolAt13` (`H_def_pre = 3, H_def_post = 0, T_gate = 1, H_coop = 2`). -/
theorem reciprocal_open_compose_poolAt13 :
    Viability.Kernel
      (OpenComposition.closedProcess
        ((gatedDefectorComponent 3 0 1).compose (coopComponent 2))
        (OpenComposition.composeContract
          (gatedDefectorContract 3 0 1 (Nat.zero_le 3))
          (coopContract 2))
        (fun x => (reciprocalObs (8 + (1 + 1) * 5) () x, ()))
        openReciprocalChannel (fun _ e => gEx (e ())) (fun _ _ => 0) (fun _ => True))
      (OpenComposition.closedGuard
        ((gatedDefectorComponent 3 0 1).compose (coopComponent 2))
        (OpenComposition.composeContract
          (gatedDefectorContract 3 0 1 (Nat.zero_le 3))
          (coopContract 2))
        (fun _ => 8))
      (fun _ => 13, (1, ())) :=
  reciprocal_open_compose_viable ReciprocalStabilityWitness.poolAt13 gEx_mono (by decide) (by decide)

/-- Constructive `OpenComposition.ContractRefines` between two `gatedDefectorContract`s when the
    replacement has no higher pre/post boundary draws and closes no slower (`T_gate' ≤ T_gate`). -/
def gatedDefectorRefines
    {H_def_pre H_def_post T_gate H_def_pre' H_def_post' T_gate' : Nat}
    {hle : H_def_post ≤ H_def_pre} {hle' : H_def_post' ≤ H_def_pre'}
    (hpre_le : H_def_pre' ≤ H_def_pre)
    (hpost_le : H_def_post' ≤ H_def_post)
    (hlag_le : T_gate' ≤ T_gate)
    (obs : (Unit → Nat) → Bool) (warnLevel : Unit → Nat) :
    OpenComposition.ContractRefines
      (gatedDefectorContract H_def_pre H_def_post T_gate hle)
      (gatedDefectorContract H_def_pre' H_def_post' T_gate' hle')
      obs obs warnLevel where
  preCapExt_le _ := hpre_le
  postBudgetExt_le _ := hpost_le
  maxSilence_le := Nat.le_refl 0
  maxLag_le := hlag_le
  init_eta_le := hlag_le
  warn_preserved _ hw _ := hw

/-- **Heterogeneous left-component replacement (`reciprocal_defector_replace_viable`)**: swapping
    the left gated defector inside `gatedDefector ⊕ coop` for any heterogeneous `A'` satisfying
    `OpenComposition.ContractRefines` preserves global `Viability.Kernel` via
    `OpenComposition.replace_left_viable` without re-checking `coop`. -/
theorem reciprocal_defector_replace_viable
    {F C K GateNode S₁' Obs₁' Dist₁' Int₁' : Type}
    (P : ReciprocalPoolSystem F C K GateNode)
    (g_mono : ∀ a b, a ≤ b → P.g a ≤ P.g b)
    (coop_le_pre : P.H_coop ≤ P.H_pre)
    (gross_buffer : P.S_safe + P.T_gate * P.H_pre ≤ P.S₀)
    (A' : OpenComposition.OpenComponent S₁' Obs₁' Dist₁' Int₁' Unit)
    {init₁' : S₁'}
    (cA' : OpenComposition.InterfaceContract A' init₁')
    (obs₁' : (Unit → Nat) → Obs₁')
    (refines : OpenComposition.ContractRefines
      (gatedDefectorContract (P.H_pre - P.H_coop) 0 P.T_gate (Nat.zero_le _)) cA'
      (reciprocalObs (P.S_safe + (P.T_gate + 1) * P.H_pre) ()) obs₁'
      (fun _ => P.S_safe + (P.T_gate + 1) * P.H_pre)) :
    Viability.Kernel
      (OpenComposition.closedProcess
        (A'.compose (coopComponent P.H_coop))
        (OpenComposition.composeContract cA' (coopContract P.H_coop))
        (fun x => (obs₁' x, ()))
        openReciprocalChannel (fun _ e => P.g (e ())) (fun _ _ => 0) (fun _ => True))
      (OpenComposition.closedGuard
        (A'.compose (coopComponent P.H_coop))
        (OpenComposition.composeContract cA' (coopContract P.H_coop))
        (fun _ => P.S_safe))
      (fun _ => P.S₀, (init₁', ())) := by
  have hG_rises : ∀ k : Unit,
      RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (fun (e : Unit → Nat) => P.g (e ())) :=
    fun _ _ _ hbelow => g_mono _ _ (hbelow ())
  have hpost_viable : ∀ k : Unit,
      P.S_safe ≤ RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole
        (fun _ (e : Unit → Nat) => P.g (e ())) (fun _ => P.H_coop) (fun _ => P.S_safe) k := by
    intro k
    cases k
    show P.S_safe ≤ (P.S_safe - P.H_coop) + P.g (P.S_safe - P.H_coop)
    have hH_le : P.H_coop ≤ P.S_safe := Nat.le_trans (Nat.le_add_right P.H_coop P.y_coop) P.safe_floor
    have hy_le : P.y_coop ≤ P.S_safe - P.H_coop := Naturals.le_sub_of_add_le P.safe_floor
    have hceil : (P.S_safe - P.H_coop) + P.H_coop ≤ P.hi := by
      rw [Naturals.sub_add_cancel hH_le]
      exact P.safe_le_hi
    have hg_ge : P.H_coop ≤ P.g (P.S_safe - P.H_coop) := P.meets_coop _ hy_le hceil
    calc P.S_safe = (P.S_safe - P.H_coop) + P.H_coop := (Naturals.sub_add_cancel hH_le).symm
      _ ≤ (P.S_safe - P.H_coop) + P.g (P.S_safe - P.H_coop) := Nat.add_le_add_left hg_ge _
  have hmax_le : AdaptiveLoops.natMax P.T_gate 0 ≤ P.T_gate :=
    AdaptiveLoops.natMax_le (Nat.le_refl P.T_gate) (Nat.zero_le P.T_gate)
  have hcap_eq : (P.H_pre - P.H_coop + P.H_coop) + 0 = P.H_pre :=
    (Nat.add_zero _).trans (Naturals.sub_add_cancel coop_le_pre)
  refine OpenComposition.replace_left_viable
    (gatedDefectorComponent (P.H_pre - P.H_coop) 0 P.T_gate) A' (coopComponent P.H_coop)
    (gatedDefectorContract (P.H_pre - P.H_coop) 0 P.T_gate (Nat.zero_le _))
    cA' (coopContract P.H_coop)
    (reciprocalObs (P.S_safe + (P.T_gate + 1) * P.H_pre) ()) obs₁' (fun _ => ())
    openReciprocalChannel (fun _ e => P.g (e ())) (fun _ _ => 0) (fun _ => 0) (fun _ => True)
    (fun _ _ _ => Nat.zero_le 0)
    (fun _ => P.S_safe) (fun _ => P.S_safe + (P.T_gate + 1) * P.H_pre)
    (fun _ => P.H_coop) (fun _ => P.S₀)
    refines
    (fun x k hlt => by
      cases k
      exact Or.inl (Nat.ble_eq_true_of_le hlt))
    (fun load _ _ hle => by
      have hle0 : load ≤ 0 := Nat.le_trans hle (Nat.le_refl 0)
      show (true && Nat.ble load 0) = true
      rw [Nat.ble_eq_true_of_le hle0]
      rfl)
    hG_rises hpost_viable
    (fun _ => Nat.le_of_eq ((Nat.add_zero _).trans (Nat.zero_add P.H_coop)))
    (fun _ => by
      change P.S_safe + (AdaptiveLoops.natMax P.T_gate 0 + 1) * ((P.H_pre - P.H_coop + P.H_coop) + 0) ≤
        P.S_safe + (P.T_gate + 1) * P.H_pre
      rw [hcap_eq]
      exact Nat.add_le_add_left (Nat.mul_le_mul_right P.H_pre (Nat.succ_le_succ hmax_le)) P.S_safe)
    (fun _ => by
      change P.S_safe + AdaptiveLoops.natMax P.T_gate 0 * ((P.H_pre - P.H_coop + P.H_coop) + 0) ≤ P.S₀
      rw [hcap_eq]
      exact Nat.le_trans
        (Nat.add_le_add_left (Nat.mul_le_mul_right P.H_pre hmax_le) P.S_safe)
        gross_buffer)

/-- Concrete tightening witness: replacing `gatedDefectorComponent 3 0 1` inside `poolAt13` with a
    tighter/immediate-closing `gatedDefectorComponent 2 0 0` preserves global `Viability.Kernel`
    without re-checking `coopComponent 2`. -/
theorem tighterGate_replace_witness :
    Viability.Kernel
      (OpenComposition.closedProcess
        ((gatedDefectorComponent 2 0 0).compose (coopComponent 2))
        (OpenComposition.composeContract
          (gatedDefectorContract 2 0 0 (Nat.zero_le 2))
          (coopContract 2))
        (fun x => (reciprocalObs (8 + (1 + 1) * 5) () x, ()))
        openReciprocalChannel (fun _ e => gEx (e ())) (fun _ _ => 0) (fun _ => True))
      (OpenComposition.closedGuard
        ((gatedDefectorComponent 2 0 0).compose (coopComponent 2))
        (OpenComposition.composeContract
          (gatedDefectorContract 2 0 0 (Nat.zero_le 2))
          (coopContract 2))
        (fun _ => 8))
      (fun _ => 13, (0, ())) :=
  reciprocal_defector_replace_viable ReciprocalStabilityWitness.poolAt13 gEx_mono
    (by decide) (by decide)
    (gatedDefectorComponent 2 0 0)
    (gatedDefectorContract 2 0 0 (Nat.zero_le 2))
    (reciprocalObs (8 + (1 + 1) * 5) ())
    (gatedDefectorRefines (by decide) (Nat.le_refl 0) (by decide)
      (reciprocalObs (8 + (1 + 1) * 5) ()) (fun _ => 8 + (1 + 1) * 5))

/-- Explicit admissible run of `(gatedDefectorComponent 3 0 1).compose (coopComponent 2)` from
    `S₀ = 13`: closes at `t = 1` (`13 → 10 → 10 → ...`) while remaining permanently above `8`. -/
def reciprocalOpenRun : Run
    (OpenComposition.closedProcess
      ((gatedDefectorComponent 3 0 1).compose (coopComponent 2))
      (OpenComposition.composeContract
        (gatedDefectorContract 3 0 1 (Nat.zero_le 3))
        (coopContract 2))
      (fun x => (reciprocalObs (8 + (1 + 1) * 5) () x, ()))
      openReciprocalChannel (fun _ e => gEx (e ())) (fun _ _ => 0) (fun _ => True)) :=
  ⟨Law.orbit
    (fun st => OpenComposition.closedStep
      ((gatedDefectorComponent 3 0 1).compose (coopComponent 2))
      (fun x => (reciprocalObs (8 + (1 + 1) * 5) () x, ()))
      openReciprocalChannel (fun _ e => gEx (e ())) (fun _ _ => 0)
      st ((), ((), ())))
    (fun _ => 13, (1, ())),
   fun _ => ((), ((), ())),
   fun _ => ⟨⟨trivial, fun _ => ⟨trivial, trivial⟩⟩, rfl⟩⟩

/-- **Uncoordinated blind collapse vs. composed reciprocal viability (`blindDefector_vs_reciprocal_open`)**:
    contrasts `UncoordCommonsWitness.witness_holds` (`12 → 9 → 5 → 0`) against composed
    `gatedDefectorComponent 3 0 1 ⊕ coopComponent 2` viability (`13 → 10 → 10 → ... ≥ 8`), while
    confirming via `scopeLaw_cannot_entail_unrestricted` that even composed reciprocal viability
    entails no `Unrestricted sig`. -/
theorem blindDefector_vs_reciprocal_open {Pos F : Type} (p : Pos) (f : F) :
    (UncoordCommonsWitness.commons.substrate 0 = 12 ∧
     UncoordCommonsWitness.commons.substrate 1 = 9 ∧
     UncoordCommonsWitness.commons.substrate 2 = 5 ∧
     (∀ t, 3 ≤ t → UncoordCommonsWitness.commons.substrate t = 0 ∧
       ∀ k, ¬ UncoordCommonsWitness.commons.W_coop.MacroAdmits
         UncoordCommonsWitness.commons.cap
         (UncoordCommonsWitness.commons.W_coop.level t) t k)) ∧
    Viability.Kernel
      (OpenComposition.closedProcess
        ((gatedDefectorComponent 3 0 1).compose (coopComponent 2))
        (OpenComposition.composeContract
          (gatedDefectorContract 3 0 1 (Nat.zero_le 3))
          (coopContract 2))
        (fun x => (reciprocalObs (8 + (1 + 1) * 5) () x, ()))
        openReciprocalChannel (fun _ e => gEx (e ())) (fun _ _ => 0) (fun _ => True))
      (OpenComposition.closedGuard
        ((gatedDefectorComponent 3 0 1).compose (coopComponent 2))
        (OpenComposition.composeContract
          (gatedDefectorContract 3 0 1 (Nat.zero_le 3))
          (coopContract 2))
        (fun _ => 8))
      (fun _ => 13, (1, ())) ∧
    ((reciprocalOpenRun.state 0).1 () = 13 ∧
     (reciprocalOpenRun.state 1).1 () = 10 ∧
     (reciprocalOpenRun.state 2).1 () = 10 ∧
     ∀ t, 8 ≤ (reciprocalOpenRun.state t).1 ()) ∧
    ¬ (∀ (d : Nat) (sig : Pos → Nat → F → Prop),
        (∀ t, 8 ≤ (reciprocalOpenRun.state (t + d)).1 ()) → Unrestricted sig) :=
  ⟨⟨rfl, rfl, rfl, UncoordCommonsWitness.witness_holds.2.2.2.2.1⟩,
   reciprocal_open_compose_poolAt13,
   ⟨rfl, rfl, rfl, fun t => (Viability.Kernel.run reciprocalOpenRun reciprocal_open_compose_poolAt13 t).1 ()⟩,
   scopeLaw_cannot_entail_unrestricted
     (fun (d : Nat) => ∀ t, 8 ≤ (reciprocalOpenRun.state (t + d)).1 ())
     p f (d := 0) (fun t => (Viability.Kernel.run reciprocalOpenRun reciprocal_open_compose_poolAt13 (t + 0)).1 ())⟩

end OpenCompositionBridge

end ScopeDynamics
end Becoming
