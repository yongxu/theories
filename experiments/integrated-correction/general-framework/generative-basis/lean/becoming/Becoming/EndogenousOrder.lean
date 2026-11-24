import Becoming.ScopeDynamics
import Becoming.PersistingChoices
import Becoming.PolyComposition
import Becoming.RoutesToC
import Becoming.Standpoints

/-!
# Endogenous Order Formation, Scope Co-Evolution, Course Nash Obstruction, and Firewall

AI-written (Lean Unification Wave U4-B, 24 November 2026). Every declaration is pure Lean prelude
(`Init`-only) with an empty axiom report (`0` axioms) and zero `sorry`. No ethical predicate is
derived from dynamics: the ethics of 生生 is offered beside the dynamics, never forced from it.

## What this module establishes

1. **Target 1 — Constructive Endogenous Order Formation & Three Sharp Structural Limits**:
   - Models an online order updater `OrderUpdater X` reinforcing positive weights `posAt` along a
     coupled feedback trace against a bounded baseline `base` (`ranksAt`, recovering `Weighting.ranks`
     at `base ≡ 0`).
   - Proves `ranksNet_increasingInOwn_of_bounds`, finite-horizon convergence
     `adaptive_order_converges_increasingInOwn` (without redundant positivity assumptions), pure-rank
     specialization `adaptive_ranks_converges`, and direct composition with
     `Becoming.Flow.coupled_ending_ranked_below` (`adaptive_order_joins_coupledEnding`).
   - Proves three sharp limits:
     * **Limit 1 (Off-support misgeneralization)**: both the `ChoiceOccasions` trace lift joined to
       `OrderUpdater` (`online_ranksAt_cycleFree`, `online_off_support_reversal` via
       `ChoiceOccasions.reversed_off_met`) and direct weight-learner reversal on unprobed items
       (`online_weight_learner_reverses_off_support`).
     * **Limit 2 (Uncoupled downstream blind spot)**: `uncoupled_zero_weight_forever` and
       `uncoupled_blindness_firewall`, paired with `Clearing.center_not_derived` and
       `ScopeDynamics.scopeLaw_cannot_entail_unrestricted`.
     * **Limit 3 (Bypassing `Flow.persists_not_listsAdmitted`)**: finite-horizon truncation
       (`horizonPairs`, `boundedAdmittedBool`, `horizon_admitted_widens_iff`,
       `adaptive_order_ranks_horizon`) and macro-capability abstraction (`boundedMacroBool`,
       `macroAdmits_restores_comparability`).
   - Instantiates `OnlineWeightWitness` (`OWItem`, full-probe convergence, partial-probe reversal,
     `.victim` firewall, and `OWPersist` with alternating micro-turnover satisfying `ComesToStand`,
     `Flow.persists_not_listsAdmitted`, `TransformsViably`, and horizon/`MacroAdmits` comparability).

2. **Target 2 — Endogenous Scope Co-Evolution & Emergence Thresholds**:
   - **Dynamic mode switching (`PolyComposition`)**: `ScopeMode` (`.narrowUnmonitored`,
     `.wideReciprocal`), `scopeBase` (excluding `⟨.narrowUnmonitored, 0⟩` from `K` so `within` and
     `ModeRefines` hold together), `scopeAdmitDec`, `scopeFallback`, `timely_modeSwitch_viability_kernel`
     (via `anchored_selfMod_viable`), `wide_modeRefines_narrow`, and `timely_modeRefines_viability_kernel`
     (via `monotone_selfWidening_viable`).
   - **Multi-level assortment & lineage co-evolution (`SelectionLevels` + `GroupEnding` +
     `ScopeDynamics`)**: subtraction-free symmetry lemma `falls_iff_kept`, threshold emergence
     `assorted_wide_scope_emerges`, myopic invasion counter-theorem `unassorted_myopic_trap`, and
     substrate-coupled bridge `modeSwitch_enables_assorted_persistence`.
   - Instantiates `ScopeCoEvolutionWitness` (`AssortmentSplit` + `AssortmentLineage` at identical
     `(B = 1, K = 3, s = 1, q = 2, m = 2)` and `LagSplit` over `ScopeDynamics.gEx` contrasting
     timely `L = 1` stabilization `[13, 11, 11, ...]` and substrate-coupled `gatedGen` persistence
     against delayed `L = 3` breach `[13, 11, 9, 6, 5, 4, 2, 0, ...]` and unanchored narrow collapse `[13, 11, 9, 6, 2, 0, ...]`).

3. **Target 3 — Course-Level Menu / Nash-Equilibrium Obstruction (`07-SIGNIFICANCE.md #open`)**:
   - Grounds `CourseRealization` directly on `Web`/`Flow` step admission (`Balances`, `Acting`,
     `Dependent`, `downFrom horizon`, `rank₁_eq`, `rank₂_eq`), relates `PureNash` to
     `RoutesToC.MutualBest` (`sym_pureNash_iff_mutualBest`), and dynamically derives both
     `course_menu_widening_nash_obstruction` and `reciprocal_gate_restores_viable_nash`.
   - Instantiates `CourseNashObstructionWitness` with explicit gate conditions `.cGate1, .cGate2`
     and `.gateKeeper` (`Withholding.waitsAll`), exact `x₀ = 9, need_f = 4, need_r = 6, give = 2,
     r = 1, o = 4, horizon = 2` trajectory matching `OpenComposition.compose_close_interchange` at
     every step `[9, 6, 7, 8, ...]`, and unique `PureNash` restoration `(6, 6)` from `(5, 5)`.

4. **Target 4 — Metaethical Firewall (`not_entails`)**:
   - Parameterizes `EndogenousOrderSystem` in `Type 0` and composes with
     `ScopeDynamics.scopeLaw_cannot_entail_unrestricted` / `Unrestricted`
     (`endogenousOrder_admits_rival`, `endogenousOrder_cannot_entail_unrestricted`, and
     `EndogenousFirewallWitness` joined with `Clearing.center_not_derived`).
-/

namespace Becoming.EndogenousOrder

open Becoming
open Generative

/-! ## 0. Pure-Prelude Helpers on Lists, Totals, and `downFrom` -/

theorem cond_const_le {b : Bool} {k : Nat} : cond b k 0 ≤ k :=
  match b with
  | true => Nat.le_refl k
  | false => Nat.zero_le k

theorem total_downFrom_const (H c : Nat) :
    total (downFrom H) (fun _ => c) = (H + 1) * c :=
  match H with
  | 0 => (Nat.add_zero c).trans (Nat.one_mul c).symm
  | H + 1 => by
    show c + total (downFrom H) (fun _ => c) = (H + 1 + 1) * c
    rw [total_downFrom_const H c, Nat.succ_mul (H + 1) c, Nat.add_comm ((H + 1) * c) c]

theorem total_downFrom_add (T : Nat) (f : Nat → Nat) :
    ∀ d : Nat, total (downFrom T) f ≤ total (downFrom (T + d)) f
  | 0 => Nat.le_refl _
  | d + 1 =>
    Nat.le_trans (total_downFrom_add T f d) (Nat.le_add_left _ _)

theorem total_downFrom_mono {T H : Nat} (hle : T ≤ H) (f : Nat → Nat) :
    total (downFrom T) f ≤ total (downFrom H) f := by
  obtain ⟨d, hd⟩ := le_dest hle
  rw [hd]
  exact total_downFrom_add T f d

theorem total_downFrom_le_of_after {T : Nat} {adm : Nat → Bool} {v : Nat}
    (after : ∀ t, T < t → adm t = false) :
    ∀ H : Nat, total (downFrom H) (fun t => cond (adm t) v 0) ≤ (T + 1) * v
  | 0 => Nat.le_trans (Nat.add_le_add_right cond_const_le 0)
      (Nat.le_trans (Nat.le_of_eq (Nat.add_zero v))
        (Nat.le_trans (Nat.le_of_eq (Nat.one_mul v).symm)
          (Nat.mul_le_mul_right v (Nat.succ_le_succ (Nat.zero_le T)))))
  | H + 1 =>
    match Nat.lt_or_ge T (H + 1) with
    | .inl hlt => by
      have hcond : cond (adm (H + 1)) v 0 = 0 := by rw [after (H + 1) hlt]; rfl
      show cond (adm (H + 1)) v 0 + total (downFrom H) (fun t => cond (adm t) v 0) ≤ (T + 1) * v
      rw [hcond, Nat.zero_add]
      exact total_downFrom_le_of_after after H
    | .inr hle => by
      calc total (downFrom (H + 1)) (fun t => cond (adm t) v 0)
          ≤ total (downFrom (H + 1)) (fun _ => v) :=
              total_le (downFrom (H + 1)) (fun _ _ => cond_const_le)
        _ = (H + 1 + 1) * v := total_downFrom_const (H + 1) v
        _ ≤ (T + 1) * v := Nat.mul_le_mul_right v (Nat.succ_le_succ hle)

theorem total_downFrom_eq_of_cutoff {T H : Nat} (hle : T ≤ H) {adm : Nat → Bool} {v : Nat}
    (within : ∀ t, t ≤ T → adm t = true) (after : ∀ t, T < t → adm t = false) :
    total (downFrom H) (fun t => cond (adm t) v 0) = (T + 1) * v :=
  Nat.le_antisymm
    (total_downFrom_le_of_after after H)
    (by
      have h1 : total (downFrom T) (fun t => cond (adm t) v 0) = (T + 1) * v := by
        have hcongr : total (downFrom T) (fun t => cond (adm t) v 0) = total (downFrom T) (fun _ => v) :=
          total_congr_on fun t mt => by
            rw [within t (le_of_mem_downFrom mt)]
            rfl
        exact hcongr.trans (total_downFrom_const T v)
      exact h1 ▸ total_downFrom_mono hle (fun t => cond (adm t) v 0))

/-! ## 1. Target 1 — Constructive Endogenous Order Formation & Three Structural Limits -/

/-- An online adaptive order updater reinforcing `initPos` by `stepGain` on coupled feedback
against a bounded baseline opposing weight `base` (recovering pure `Weighting.ranks` when
`base ≡ 0`). -/
structure OrderUpdater (X : Type) : Type where
  items : List X
  own : X → Bool
  initPos : X → Nat
  base : X → Nat
  stepGain : Nat

/-- Number of positive feedback pulses received by item `x` strictly before step `t`. -/
def hitCount {X : Type} (feedback : Nat → X → Bool) : Nat → X → Nat
  | 0, _ => 0
  | t + 1, x => hitCount feedback t x + cond (feedback t x) 1 0

/-- Accumulated positive weight for item `x` at step `t`. -/
def OrderUpdater.posAt {X : Type} (U : OrderUpdater X) (feedback : Nat → X → Bool) :
    Nat → X → Nat
  | 0, x => U.initPos x
  | t + 1, x => U.posAt feedback t x + cond (feedback t x) U.stepGain 0

/-- Net-weighted course comparison induced by `U` at step `t` (`U.ranksAt feedback t b a` means
`a` is ranked strictly above `b`). -/
def OrderUpdater.ranksAt {X : Type} (U : OrderUpdater X) (feedback : Nat → X → Bool)
    (t : Nat) : (X → Bool) → (X → Bool) → Prop :=
  Weighting.ranksNet U.items (U.posAt feedback t) U.base

theorem hitCount_add {X : Type} (feedback : Nat → X → Bool) (s : Nat) (x : X) :
    ∀ d : Nat, hitCount feedback s x ≤ hitCount feedback (s + d) x
  | 0 => Nat.le_refl _
  | d + 1 => Nat.le_trans (hitCount_add feedback s x d) (Nat.le_add_right _ _)

theorem hitCount_mono {X : Type} (feedback : Nat → X → Bool) {s t : Nat} (hle : s ≤ t) (x : X) :
    hitCount feedback s x ≤ hitCount feedback t x := by
  obtain ⟨d, hd⟩ := le_dest hle
  rw [hd]
  exact hitCount_add feedback s x d

theorem OrderUpdater.posAt_eq_init_add_mul {X : Type} (U : OrderUpdater X)
    (feedback : Nat → X → Bool) :
    ∀ (t : Nat) (x : X), U.posAt feedback t x = U.initPos x + U.stepGain * hitCount feedback t x
  | 0, x => (Nat.add_zero (U.initPos x)).symm
  | t + 1, x => by
    show U.posAt feedback t x + cond (feedback t x) U.stepGain 0 =
      U.initPos x + U.stepGain * (hitCount feedback t x + cond (feedback t x) 1 0)
    rw [U.posAt_eq_init_add_mul feedback t x, Weighting.cond_mul U.stepGain (feedback t x),
      Nat.add_assoc, ← Nat.left_distrib]

theorem OrderUpdater.posAt_mono {X : Type} (U : OrderUpdater X) (feedback : Nat → X → Bool)
    {s t : Nat} (hle : s ≤ t) (x : X) :
    U.posAt feedback s x ≤ U.posAt feedback t x := by
  rw [U.posAt_eq_init_add_mul feedback s x, U.posAt_eq_init_add_mul feedback t x]
  exact Nat.add_le_add_left (Nat.mul_le_mul_left U.stepGain (hitCount_mono feedback hle x))
    (U.initPos x)

theorem one_le_hitCount_of_lt {X : Type} (feedback : Nat → X → Bool) {s T : Nat} {x : X}
    (hlt : s < T) (hit : feedback s x = true) :
    1 ≤ hitCount feedback T x := by
  have h1 : 1 ≤ hitCount feedback (s + 1) x := by
    show 1 ≤ hitCount feedback s x + cond (feedback s x) 1 0
    rw [hit]
    exact Nat.le_add_left 1 _
  exact Nat.le_trans h1 (hitCount_mono feedback hlt x)

theorem hitCount_zero_of_never {X : Type} (feedback : Nat → X → Bool) {x : X} :
    ∀ {T : Nat}, (∀ s, s < T → feedback s x = false) → hitCount feedback T x = 0
  | 0, _ => rfl
  | T + 1, never => by
    show hitCount feedback T x + cond (feedback T x) 1 0 = 0
    rw [hitCount_zero_of_never feedback (fun s hs => never s (Nat.lt_succ_of_lt hs)),
      never T (Nat.lt_succ_self T)]
    rfl

theorem OrderUpdater.posAt_eq_init_of_never {X : Type} (U : OrderUpdater X)
    (feedback : Nat → X → Bool) {x : X} {T : Nat}
    (never : ∀ s, s < T → feedback s x = false) :
    U.posAt feedback T x = U.initPos x := by
  rw [U.posAt_eq_init_add_mul feedback T x, hitCount_zero_of_never feedback never,
    Nat.mul_zero, Nat.add_zero]

theorem OrderUpdater.ranksAt_zero_base_iff {X : Type} (U : OrderUpdater X)
    (feedback : Nat → X → Bool) (t : Nat) (zero : ∀ x, U.base x = 0) (b a : X → Bool) :
    U.ranksAt feedback t b a ↔ Weighting.ranks U.items (U.posAt feedback t) b a := by
  have zweighed : ∀ c : X → Bool, Weighting.weighed U.items U.base c = 0 := fun c =>
    (total_congr (fun x => by rw [zero x]; exact Weighting.cond_zero (c x)) U.items).trans
      (total_zero U.items)
  show Weighting.weighed U.items (U.posAt feedback t) b + Weighting.weighed U.items U.base a <
      Weighting.weighed U.items (U.posAt feedback t) a + Weighting.weighed U.items U.base b ↔
    Weighting.weighed U.items (U.posAt feedback t) b <
      Weighting.weighed U.items (U.posAt feedback t) a
  rw [zweighed a, zweighed b, Nat.add_zero, Nat.add_zero]

/-- `Weighting.ranksNet` is always irreflexive. -/
theorem ranksNet_irrefl {X : Type} (items : List X) (pos neg : X → Nat) (a : X → Bool) :
    ¬ Weighting.ranksNet items pos neg a a :=
  Nat.lt_irrefl _

/-- `Weighting.ranksNet` is always transitive. -/
theorem ranksNet_trans {X : Type} (items : List X) (pos neg : X → Nat) {a b c : X → Bool}
    (hab : Weighting.ranksNet items pos neg a b)
    (hbc : Weighting.ranksNet items pos neg b c) :
    Weighting.ranksNet items pos neg a c := by
  have hsum : (Weighting.weighed items pos a + Weighting.weighed items neg b) +
      (Weighting.weighed items pos b + Weighting.weighed items neg c) <
      (Weighting.weighed items pos b + Weighting.weighed items neg a) +
      (Weighting.weighed items pos c + Weighting.weighed items neg b) :=
    Nat.add_lt_add hab hbc
  have hL : (Weighting.weighed items pos a + Weighting.weighed items neg b) +
      (Weighting.weighed items pos b + Weighting.weighed items neg c) =
      (Weighting.weighed items pos b + Weighting.weighed items neg b) +
      (Weighting.weighed items pos a + Weighting.weighed items neg c) := by
    calc (Weighting.weighed items pos a + Weighting.weighed items neg b) +
          (Weighting.weighed items pos b + Weighting.weighed items neg c)
        = (Weighting.weighed items pos a + Weighting.weighed items pos b) +
            (Weighting.weighed items neg b + Weighting.weighed items neg c) :=
            Nat.add_add_add_comm _ _ _ _
      _ = (Weighting.weighed items pos b + Weighting.weighed items pos a) +
            (Weighting.weighed items neg b + Weighting.weighed items neg c) :=
            congrArg (· + _) (Nat.add_comm _ _)
      _ = (Weighting.weighed items pos b + Weighting.weighed items neg b) +
            (Weighting.weighed items pos a + Weighting.weighed items neg c) :=
            Nat.add_add_add_comm _ _ _ _
  have hR : (Weighting.weighed items pos b + Weighting.weighed items neg a) +
      (Weighting.weighed items pos c + Weighting.weighed items neg b) =
      (Weighting.weighed items pos b + Weighting.weighed items neg b) +
      (Weighting.weighed items pos c + Weighting.weighed items neg a) := by
    calc (Weighting.weighed items pos b + Weighting.weighed items neg a) +
          (Weighting.weighed items pos c + Weighting.weighed items neg b)
        = (Weighting.weighed items pos b + Weighting.weighed items pos c) +
            (Weighting.weighed items neg a + Weighting.weighed items neg b) :=
            Nat.add_add_add_comm _ _ _ _
      _ = (Weighting.weighed items pos b + Weighting.weighed items pos c) +
            (Weighting.weighed items neg b + Weighting.weighed items neg a) :=
            congrArg (_ + ·) (Nat.add_comm _ _)
      _ = (Weighting.weighed items pos b + Weighting.weighed items neg b) +
            (Weighting.weighed items pos c + Weighting.weighed items neg a) :=
            Nat.add_add_add_comm _ _ _ _
  rw [hL, hR] at hsum
  exact Nat.lt_of_add_lt_add_left hsum

/-- Core monotonicity lift from pointwise weight bounds: if `base < pos` on coupled `own` items
and `base ≤ pos` on off-own items, `Weighting.ranksNet` is `IncreasingInOwn` (strictly tighter than
`Weighting.ranksNet_lt_of_widens`, which requires `base < pos` everywhere). -/
theorem ranksNet_increasingInOwn_of_bounds {X : Type} {items : List X} {own : X → Bool}
    {pos base : X → Nat}
    (ownPos : ∀ x, x ∈ items → own x = true → base x < pos x)
    (offBase : ∀ y, y ∈ items → own y = false → base y ≤ pos y) :
    Weighting.IncreasingInOwn items own (Weighting.ranksNet items pos base) := by
  intro a b widens adds
  apply (Weighting.ranksNet_iff_beyond items pos base a b).mpr
  rw [Weighting.weighed_beyond_of_includes pos widens.1,
    Weighting.weighed_beyond_of_includes base widens.1, Nat.zero_add, Nat.add_zero]
  obtain ⟨x, xmem, xown, ha, hb⟩ := adds
  refine Weighting.total_lt ?_ ⟨x, xmem, ?_⟩
  · intro y ymem
    exact ListTests.cond_zero_le fun _ =>
      match hy : own y with
      | true => Nat.le_of_lt (ownPos y ymem hy)
      | false => offBase y ymem hy
  · show cond (a x && !b x) (base x) 0 < cond (a x && !b x) (pos x) 0
    rw [ha, hb]
    exact ownPos x xmem xown

/-- Pair-restricted version of `ranksNet_increasingInOwn_of_bounds`: `IncreasingInOwnOn met` holds
whenever every pair `(a, b)` related by `met` satisfies the bounds on items where `a` widens `b`. -/
theorem ranksNet_increasingInOwnOn_of_bounds {X : Type}
    {met : (X → Bool) → (X → Bool) → Prop} {items : List X} {own : X → Bool}
    {pos base : X → Nat}
    (ownPos : ∀ a b, met a b → ∀ x, x ∈ items → own x = true → a x = true → b x = false → base x < pos x)
    (offBase : ∀ a b, met a b → ∀ y, y ∈ items → own y = false → a y = true → b y = false → base y ≤ pos y) :
    Weighting.IncreasingInOwnOn met items own (Weighting.ranksNet items pos base) := by
  intro a b hmet widens adds
  apply (Weighting.ranksNet_iff_beyond items pos base a b).mpr
  rw [Weighting.weighed_beyond_of_includes pos widens.1,
    Weighting.weighed_beyond_of_includes base widens.1, Nat.zero_add, Nat.add_zero]
  obtain ⟨x, xmem, xown, ha, hb⟩ := adds
  refine Weighting.total_lt ?_ ⟨x, xmem, ?_⟩
  · intro y ymem
    exact ListTests.cond_zero_le fun held =>
      match ListTests.and_true_iff.mp held with
      | ⟨ay, nby⟩ =>
        have byf : b y = false := ListTests.not_true_iff.mp nby
        match hy : own y with
        | true => Nat.le_of_lt (ownPos a b hmet y ymem hy ay byf)
        | false => offBase a b hmet y ymem hy ay byf
  · show cond (a x && !b x) (base x) 0 < cond (a x && !b x) (pos x) 0
    rw [ha, hb]
    exact ownPos a b hmet x xmem xown ha hb

/-- **Positive Finite-Horizon Convergence**: under bounded coupled baseline `B`, off-own baseline
coverage `U.base y ≤ U.initPos y`, and `K` coupled feedback pulses within horizon `T` with
`B < K * U.stepGain` (which implies `0 < U.stepGain`), `U.ranksAt feedback t` is `IncreasingInOwn`
for all `t ≥ T`. -/
theorem adaptive_order_converges_increasingInOwn {X : Type} (U : OrderUpdater X)
    (feedback : Nat → X → Bool) {B K T : Nat}
    (ownBase : ∀ x, x ∈ U.items → U.own x = true → U.base x ≤ B)
    (offBase : ∀ y, y ∈ U.items → U.own y = false → U.base y ≤ U.initPos y)
    (probed : ∀ x, x ∈ U.items → U.own x = true → K ≤ hitCount feedback T x)
    (enough : B < K * U.stepGain) :
    ∀ t, T ≤ t → Weighting.IncreasingInOwn U.items U.own (U.ranksAt feedback t) := by
  intro t ht
  refine ranksNet_increasingInOwn_of_bounds ?_ ?_
  · intro x xmem xown
    have hmul : K * U.stepGain ≤ U.stepGain * hitCount feedback T x := by
      rw [Nat.mul_comm U.stepGain]
      exact Nat.mul_le_mul_right U.stepGain (probed x xmem xown)
    have hT : U.base x < U.posAt feedback T x := by
      rw [U.posAt_eq_init_add_mul feedback T x]
      exact Nat.lt_of_le_of_lt (ownBase x xmem xown)
        (Nat.lt_of_lt_of_le enough (Nat.le_trans hmul (Nat.le_add_left _ _)))
    exact Nat.lt_of_lt_of_le hT (U.posAt_mono feedback ht x)
  · intro y ymem yown
    exact Nat.le_trans (offBase y ymem yown) (U.posAt_mono feedback (Nat.zero_le t) y)

/-- Pure-rank specialization (`base ≡ 0`, `stepGain = 1`): one feedback pulse before `T` on each
coupled item suffices for convergence to `Weighting.IncreasingInOwn`. -/
theorem adaptive_ranks_converges {X : Type} (U : OrderUpdater X)
    (feedback : Nat → X → Bool) {T : Nat}
    (zero : ∀ x, U.base x = 0) (unitGain : U.stepGain = 1)
    (seen : ∀ x, x ∈ U.items → U.own x = true → ∃ s, s < T ∧ feedback s x = true) :
    ∀ t, T ≤ t →
      Weighting.IncreasingInOwn U.items U.own (Weighting.ranks U.items (U.posAt feedback t)) := by
  intro t ht a b widens adds
  have hconv : Weighting.IncreasingInOwn U.items U.own (U.ranksAt feedback t) :=
    adaptive_order_converges_increasingInOwn U feedback (B := 0) (K := 1) (T := T)
      (fun x _ _ => Nat.le_of_eq (zero x))
      (fun y _ _ => by rw [zero y]; exact Nat.zero_le _)
      (fun x xmem xown => match seen x xmem xown with
        | ⟨s, hlt, hit⟩ => one_le_hitCount_of_lt feedback hlt hit)
      (by rw [unitGain]; exact Nat.zero_lt_one)
      t ht
  exact (U.ranksAt_zero_base_iff feedback t zero b a).mp (hconv a b widens adds)

/-- Composition with `Becoming.Flow.coupled_ending_ranked_below`: once the order updater has
converged on coupled support `(Nat × X)` at horizon `T`, at every step `t ≥ T` it ranks any
persistence-preserving course that agrees up to `T_end + n` and adds to `own p` strictly above
an overdrawing collapsing course. -/
theorem adaptive_order_joins_coupledEnding {X Pos : Type}
    {L : Flow X X} {W : Web X X}
    (balances : L.Balances W) (acting : L.Acting W) (dependent : W.Dependent)
    {G : SelectionTerm.Generations X} (descended : SelectionTerm.Flow.Descended L W G)
    {ds : List X} {m : Nat}
    (gated : ∀ s f, f ∈ L.present s → ∀ d, d ∈ ds → 0 < L.give s f d →
      ∃ e, e ∈ ds ∧ W.requires s f e ∧ m ≤ W.need s f e)
    {T_end n : Nat} (excess : ∀ k, k < n → L.replenishment ds (T_end + k) < L.uptake ds (T_end + k))
    (start : W.stock ds T_end < n + m)
    (coupled : ∀ k q, q ∈ G.family (T_end + n + k) →
      ∃ e, e ∈ ds ∧ W.requires (T_end + n + k) q e ∧ m ≤ W.need (T_end + n + k) q e)
    (U : OrderUpdater (Nat × X)) (feedback : Nat → Nat × X → Bool)
    {B K T : Nat}
    (ownBase : ∀ x, x ∈ U.items → U.own x = true → U.base x ≤ B)
    (offBase : ∀ y, y ∈ U.items → U.own y = false → U.base y ≤ U.initPos y)
    (probed : ∀ x, x ∈ U.items → U.own x = true → K ≤ hitCount feedback T x)
    (enough : B < K * U.stepGain)
    {a b : Nat × X → Bool}
    (reads : ∀ x, x ∈ U.items → b x = true → x.2 ∈ G.family x.1)
    (agree : ∀ x, x ∈ U.items → x.1 ≤ T_end + n → a x = b x)
    (own : Pos → Nat × X → Bool) (p : Pos) (ownEq : U.own = own p)
    (adds : Weighting.AddsOwn U.items (own p) a b) :
    ∀ t, T ≤ t → U.ranksAt feedback t b a := by
  intro t ht
  have hconv := adaptive_order_converges_increasingInOwn U feedback ownBase offBase probed enough t ht
  rw [ownEq] at hconv
  exact Becoming.Flow.coupled_ending_ranked_below balances acting dependent descended gated excess
    start coupled reads agree p adds (U.ranksAt feedback t) hconv

/-! ### Limit 1 — Off-Support Misgeneralization (`ChoiceOccasions` & Weight-Learner Reversal) -/

/-- Any observed choice trace `ch` that `U.ranksAt feedback T` accords with and on whose `ch.Met`
pairs `U.ranksAt feedback T` is `IncreasingInOwnOn` induces a cycle-free enlarged shown relation
`«无环» (ch.withPairs (ch.OwnWidensMet U.items U.own)).Shown`. -/
theorem online_ranksAt_cycleFree {X O : Type} (U : OrderUpdater X) (feedback : Nat → X → Bool)
    (T : Nat) (ch : ChoiceOccasions (X → Bool) O)
    (accords : ch.Accords (fun x y => U.ranksAt feedback T y x))
    (onMet : Weighting.IncreasingInOwnOn ch.Met U.items U.own (U.ranksAt feedback T)) :
    «无环» (ch.withPairs (ch.OwnWidensMet U.items U.own)).Shown :=
  ChoiceOccasions.selfConcerned_consistent_iff.mp
    ⟨fun x y => U.ranksAt feedback T y x,
     fun x => ranksNet_irrefl U.items (U.posAt feedback T) U.base x,
     fun _ _ _ hxy hyz => ranksNet_trans U.items (U.posAt feedback T) U.base hyz hxy,
     accords,
     onMet⟩

/-- **Limit 1(a) (Joined `OrderUpdater` + `ChoiceOccasions.reversed_off_met`)**: whenever an
observed trace `ch` agrees with the online updater `U.ranksAt feedback T` (converged on `probe`,
where pairs in `ch.Met` agree off `probe`), any unmet course `a` widening `b` and adding to `U.own`
can still be reversed by a strict order `P` agreeing with every observed comparison of `U` and
satisfying `IncreasingInOwnOn ch.Met`. -/
theorem online_off_support_reversal {X O : Type} (U : OrderUpdater X) (feedback : Nat → X → Bool)
    {B K T : Nat} (probe : X → Bool)
    (ch : ChoiceOccasions (X → Bool) O)
    (metAgreeOff : ∀ a b, ch.Met a b → ∀ z, z ∈ U.items → probe z = false → a z = b z)
    (ownBase : ∀ x, x ∈ U.items → U.own x = true → probe x = true → U.base x ≤ B)
    (offBase : ∀ y, y ∈ U.items → U.own y = false → probe y = true → U.base y ≤ U.initPos y)
    (probed : ∀ x, x ∈ U.items → U.own x = true → probe x = true → K ≤ hitCount feedback T x)
    (enough : B < K * U.stepGain)
    (accords : ch.Accords (fun x y => U.ranksAt feedback T y x))
    {a b : X → Bool} (unmet : ch.Unmet a) (widens : Weighting.WidensOn U.items a b)
    (adds : Weighting.AddsOwn U.items U.own a b) :
    ∃ P : «际» (X → Bool),
      (∀ x, ¬ P x x) ∧ (∀ x y z, P x y → P y z → P x z) ∧ ch.Accords P ∧
      Weighting.IncreasingInOwnOn ch.Met U.items U.own (fun y x => P x y) ∧
      P b a ∧ ¬ Weighting.IncreasingInOwn U.items U.own (fun y x => P x y) := by
  have onMet : Weighting.IncreasingInOwnOn ch.Met U.items U.own (U.ranksAt feedback T) := by
    refine ranksNet_increasingInOwnOn_of_bounds ?_ ?_
    · intro c d hmet x xmem xown hc hd
      have hpr : probe x = true := match hp : probe x with
        | true => rfl
        | false => Bool.noConfusion ((hc.symm.trans (metAgreeOff c d hmet x xmem hp)).trans hd)
      have hmul : K * U.stepGain ≤ U.stepGain * hitCount feedback T x := by
        rw [Nat.mul_comm U.stepGain]
        exact Nat.mul_le_mul_right U.stepGain (probed x xmem xown hpr)
      rw [U.posAt_eq_init_add_mul feedback T x]
      exact Nat.lt_of_le_of_lt (ownBase x xmem xown hpr)
        (Nat.lt_of_lt_of_le enough (Nat.le_trans hmul (Nat.le_add_left _ _)))
    · intro c d hmet y ymem yown hc hd
      have hpr : probe y = true := match hp : probe y with
        | true => rfl
        | false => Bool.noConfusion ((hc.symm.trans (metAgreeOff c d hmet y ymem hp)).trans hd)
      exact Nat.le_trans (offBase y ymem yown hpr) (U.posAt_mono feedback (Nat.zero_le T) y)
  exact ChoiceOccasions.reversed_off_met (online_ranksAt_cycleFree U feedback T ch accords onMet)
    unmet widens adds

/-- **Limit 1(b) (Weight-Learner Off-Support Reversal)**: an `OrderUpdater` trained only on
`probe`-marked items converges to `IncreasingInOwnOn` on all pairs agreeing off `probe`, yet on
any unprobed item `u` with `U.initPos u < U.base u` it literally reverses any widening `WidensBy U.items u a b`
(ranking `b` strictly above `a` and failing `IncreasingInOwn` whenever `U.own u = true`). -/
theorem online_weight_learner_reverses_off_support {X : Type} (U : OrderUpdater X)
    (feedback : Nat → X → Bool) {B K T : Nat} (probe : X → Bool)
    (ownBase : ∀ x, x ∈ U.items → U.own x = true → probe x = true → U.base x ≤ B)
    (offBase : ∀ y, y ∈ U.items → U.own y = false → probe y = true → U.base y ≤ U.initPos y)
    (probed : ∀ x, x ∈ U.items → U.own x = true → probe x = true → K ≤ hitCount feedback T x)
    (enough : B < K * U.stepGain)
    {u : X} (neverU : ∀ s, s < T → feedback s u = false)
    (belowBase : U.initPos u < U.base u)
    {a b : X → Bool} (byU : Weighting.WidensBy U.items u a b) :
    Weighting.IncreasingInOwnOn (fun c d => ∀ z, z ∈ U.items → probe z = false → c z = d z)
        U.items U.own (U.ranksAt feedback T) ∧
      U.ranksAt feedback T a b ∧
      ¬ U.ranksAt feedback T b a ∧
      (U.own u = true → ¬ Weighting.IncreasingInOwn U.items U.own (U.ranksAt feedback T)) := by
  have onProbe : Weighting.IncreasingInOwnOn
      (fun c d => ∀ z, z ∈ U.items → probe z = false → c z = d z)
      U.items U.own (U.ranksAt feedback T) := by
    refine ranksNet_increasingInOwnOn_of_bounds ?_ ?_
    · intro c d hagree x xmem xown hc hd
      have hpr : probe x = true := match hp : probe x with
        | true => rfl
        | false => Bool.noConfusion ((hc.symm.trans (hagree x xmem hp)).trans hd)
      have hmul : K * U.stepGain ≤ U.stepGain * hitCount feedback T x := by
        rw [Nat.mul_comm U.stepGain]
        exact Nat.mul_le_mul_right U.stepGain (probed x xmem xown hpr)
      rw [U.posAt_eq_init_add_mul feedback T x]
      exact Nat.lt_of_le_of_lt (ownBase x xmem xown hpr)
        (Nat.lt_of_lt_of_le enough (Nat.le_trans hmul (Nat.le_add_left _ _)))
    · intro c d hagree y ymem yown hc hd
      have hpr : probe y = true := match hp : probe y with
        | true => rfl
        | false => Bool.noConfusion ((hc.symm.trans (hagree y ymem hp)).trans hd)
      exact Nat.le_trans (offBase y ymem yown hpr) (U.posAt_mono feedback (Nat.zero_le T) y)
  have hposU : U.posAt feedback T u = U.initPos u :=
    U.posAt_eq_init_of_never feedback neverU
  have hlt : U.posAt feedback T u < U.base u := by
    rw [hposU]
    exact belowBase
  have hrev : U.ranksAt feedback T a b := (Weighting.ranksNet_widensBy byU).2.mpr hlt
  have hnot : ¬ U.ranksAt feedback T b a := fun hba =>
    Nat.lt_asymm hlt ((Weighting.ranksNet_widensBy byU).1.mp hba)
  have hfail : U.own u = true → ¬ Weighting.IncreasingInOwn U.items U.own (U.ranksAt feedback T) :=
    fun huown hinc =>
      hnot (hinc a b (Weighting.widensOn_of_widensBy byU)
        ⟨u, byU.2.1, huown, byU.2.2.1, byU.2.2.2.1⟩)
  exact ⟨onProbe, hrev, hnot, hfail⟩

/-! ### Limit 2 — Uncoupled Downstream Blind Spot / Zero-Weight Firewall -/

/-- Any item `v` that never receives feedback (`∀ t, feedback t v = false`) from initial weight `0`
stays at weight `0` forever. -/
theorem uncoupled_zero_weight_forever {X : Type} (U : OrderUpdater X) (feedback : Nat → X → Bool)
    {v : X} (never : ∀ t, feedback t v = false) (init0 : U.initPos v = 0) :
    ∀ t : Nat, U.posAt feedback t v = 0 :=
  fun _ => (U.posAt_eq_init_of_never feedback (fun s _ => never s)).trans init0

/-- **Limit 2 (Uncoupled Downstream Blind Spot Firewall)**: for an uncoupled item `v` (`initPos v = 0`,
no feedback ever), `U.ranksAt` either leaves every widening by `v` unranked forever (`U.base v = 0`,
by `Weighting.ranksNet_ties`) or actively ranks keeping `v` strictly below dropping it (`0 < U.base v`,
by `Weighting.ranksNet_widensBy`); meanwhile `Clearing.center_not_derived` confirms that the center
is not derived along dependence and `ScopeDynamics.scopeLaw_cannot_entail_unrestricted` confirms
no dynamics law entails unrestricted significance. -/
theorem uncoupled_blindness_firewall {X Pos F : Type} (U : OrderUpdater X)
    (feedback : Nat → X → Bool) {v : X} (never : ∀ t, feedback t v = false)
    (init0 : U.initPos v = 0) {a b : X → Bool} (byV : Weighting.WidensBy U.items v a b)
    (p : Pos) (f : F) :
    (∀ t, U.posAt feedback t v = 0) ∧
      (U.base v = 0 → ∀ t, ¬ U.ranksAt feedback t b a ∧ ¬ U.ranksAt feedback t a b) ∧
      (0 < U.base v → ∀ t, U.ranksAt feedback t a b ∧ ¬ U.ranksAt feedback t b a) ∧
      (Clearing.valuation.Held ∧ ¬ Clearing.valuation.Significant) ∧
      ¬ (∀ (d : OrderUpdater X) (sig : Pos → Nat → F → Prop),
          (∀ t, d.posAt feedback t v = 0) → Unrestricted sig) := by
  have hz : ∀ t, U.posAt feedback t v = 0 := uncoupled_zero_weight_forever U feedback never init0
  refine ⟨hz, fun hb0 t => ?_, fun hbpos t => ?_,
    ⟨Clearing.center_not_derived.1, Clearing.center_not_derived.2.2.2.2.2.2.1⟩, ?_⟩
  · exact Weighting.ranksNet_ties byV ((hz t).trans hb0.symm)
  · have hlt : U.posAt feedback t v < U.base v := by rw [hz t]; exact hbpos
    exact ⟨(Weighting.ranksNet_widensBy byV).2.mpr hlt,
      fun hba => Nat.lt_asymm hlt ((Weighting.ranksNet_widensBy byV).1.mp hba)⟩
  · exact ScopeDynamics.scopeLaw_cannot_entail_unrestricted
      (fun (d : OrderUpdater X) => ∀ t, d.posAt feedback t v = 0) p f (d := U) hz

/-! ### Limit 3 — Bypassing `Flow.persists_not_listsAdmitted` via Horizons & `MacroAdmits` -/

/-- Finite evaluation list of all `(step, formation)` pairs with `step ≤ H` over `forms`. -/
def horizonPairs {F : Type} (H : Nat) (forms : List F) : List (Nat × F) :=
  (downFrom H).flatMap fun t => forms.map fun f => (t, f)

theorem mem_horizonPairs_iff {F : Type} {H : Nat} {forms : List F} {i : Nat × F} :
    i ∈ horizonPairs H forms ↔ i.1 ≤ H ∧ i.2 ∈ forms := by
  refine ⟨fun hm => ?_, fun ⟨hle, mf⟩ => ?_⟩
  · obtain ⟨t, ht, mf⟩ := ListTests.mem_flatMap_iff.mp hm
    obtain ⟨f, hf, eq⟩ := ListTests.mem_map_iff.mp mf
    have ht' : t ≤ H := le_of_mem_downFrom ht
    rw [← eq]
    exact ⟨ht', hf⟩
  · exact ListTests.mem_flatMap_iff.mpr
      ⟨i.1, mem_downFrom hle, ListTests.mem_map_of mf⟩

/-- Decidable bounded-horizon admission predicate up to step `H`. -/
def boundedAdmittedBool {F C : Type} (H : Nat)
    (dec : (Nat → C → Nat) → Nat × F → Bool)
    (l : Nat → C → Nat) (i : Nat × F) : Bool :=
  Nat.ble i.1 H && dec l i

theorem boundedAdmittedBool_true_iff {F C : Type} {W : Web F C} (H : Nat)
    {dec : (Nat → C → Nat) → Nat × F → Bool} (decides : W.DecidesAdmission dec)
    (l : Nat → C → Nat) (i : Nat × F) :
    boundedAdmittedBool H dec l i = true ↔ i.1 ≤ H ∧ W.Admits (l i.1) i.1 i.2 := by
  unfold boundedAdmittedBool
  refine ListTests.and_true_iff.trans ?_
  exact ⟨fun ⟨hb, hd⟩ => ⟨Nat.le_of_ble_eq_true hb, (decides l i).mp hd⟩,
    fun ⟨hle, hadm⟩ => ⟨Nat.ble_eq_true_of_le hle, (decides l i).mpr hadm⟩⟩

/-- **Limit 3(a) (Finite-Horizon Restoration over Persisting Flows)**: while `Flow.persists_not_listsAdmitted`
forbids listing all admitted pairs of a persisting line, truncating to any finite horizon `H`
places every boundedly admitted pair inside `horizonPairs H forms` and characterizes horizon widening
exactly via all positive weightings on `horizonPairs H forms`. -/
theorem horizon_admitted_widens_iff {F C : Type} {W : Web F C} (H : Nat) (forms : List F)
    (cover : ∀ f, f ∈ forms) {dec : (Nat → C → Nat) → Nat × F → Bool}
    (decides : W.DecidesAdmission dec) (l₁ l₂ : Nat → C → Nat) :
    ((∀ t f, t ≤ H → W.Admits (l₂ t) t f → W.Admits (l₁ t) t f) ∧
     (∃ t f, t ≤ H ∧ W.Admits (l₁ t) t f ∧ ¬ W.Admits (l₂ t) t f)) ↔
      ∀ w, Weighting.Positive (horizonPairs H forms) w →
        Weighting.weighed (horizonPairs H forms) w (boundedAdmittedBool H dec l₂) <
          Weighting.weighed (horizonPairs H forms) w (boundedAdmittedBool H dec l₁) := by
  have hwid :
      ((∀ t f, t ≤ H → W.Admits (l₂ t) t f → W.Admits (l₁ t) t f) ∧
       (∃ t f, t ≤ H ∧ W.Admits (l₁ t) t f ∧ ¬ W.Admits (l₂ t) t f)) ↔
        Weighting.WidensOn (horizonPairs H forms)
          (boundedAdmittedBool H dec l₁) (boundedAdmittedBool H dec l₂) := by
    refine ⟨fun ⟨hinc, t, f, hle, ha1, ha2⟩ => ?_, fun ⟨hinc, i, him, ha1, ha2⟩ => ?_⟩
    · refine ⟨fun i _ hd2 => ?_, ⟨t, f⟩, mem_horizonPairs_iff.mpr ⟨hle, cover f⟩, ?_, ?_⟩
      · have h2 := (boundedAdmittedBool_true_iff H decides l₂ i).mp hd2
        exact (boundedAdmittedBool_true_iff H decides l₁ i).mpr ⟨h2.1, hinc i.1 i.2 h2.1 h2.2⟩
      · exact (boundedAdmittedBool_true_iff H decides l₁ (t, f)).mpr ⟨hle, ha1⟩
      · exact ListTests.false_iff_not.mpr fun h =>
          ha2 ((boundedAdmittedBool_true_iff H decides l₂ (t, f)).mp h).2
    · refine ⟨fun t f hle ha2 => ?_, i.1, i.2, (mem_horizonPairs_iff.mp him).1, ?_, ?_⟩
      · have hm : (t, f) ∈ horizonPairs H forms := mem_horizonPairs_iff.mpr ⟨hle, cover f⟩
        have hd2 := (boundedAdmittedBool_true_iff H decides l₂ (t, f)).mpr ⟨hle, ha2⟩
        exact ((boundedAdmittedBool_true_iff H decides l₁ (t, f)).mp (hinc (t, f) hm hd2)).2
      · exact ((boundedAdmittedBool_true_iff H decides l₁ i).mp ha1).2
      · intro ha2'
        have htrue := (boundedAdmittedBool_true_iff H decides l₂ i).mpr
          ⟨(mem_horizonPairs_iff.mp him).1, ha2'⟩
        exact Bool.noConfusion (ha2.symm.trans htrue)
  exact hwid.trans Weighting.widens_iff_every_positive

/-- A converged `OrderUpdater` over `horizonPairs H forms` ranks any horizon widening `l₁` over `l₂`
when the witnessing step–formation pair lies in `own`. -/
theorem adaptive_order_ranks_horizon {F C : Type} {W : Web F C} (H : Nat) (forms : List F)
    (cover : ∀ f, f ∈ forms) {dec : (Nat → C → Nat) → Nat × F → Bool}
    (decides : W.DecidesAdmission dec)
    (U : OrderUpdater (Nat × F)) (itemsEq : U.items = horizonPairs H forms)
    (feedback : Nat → Nat × F → Bool) {B K T : Nat}
    (ownBase : ∀ x, x ∈ U.items → U.own x = true → U.base x ≤ B)
    (offBase : ∀ y, y ∈ U.items → U.own y = false → U.base y ≤ U.initPos y)
    (probed : ∀ x, x ∈ U.items → U.own x = true → K ≤ hitCount feedback T x)
    (enough : B < K * U.stepGain)
    {l₁ l₂ : Nat → C → Nat}
    (hinc : ∀ t f, t ≤ H → W.Admits (l₂ t) t f → W.Admits (l₁ t) t f)
    {t₀ : Nat} {f₀ : F} (hle₀ : t₀ ≤ H) (own₀ : U.own (t₀, f₀) = true)
    (ha1 : W.Admits (l₁ t₀) t₀ f₀) (ha2 : ¬ W.Admits (l₂ t₀) t₀ f₀) :
    ∀ t, T ≤ t →
      U.ranksAt feedback t (boundedAdmittedBool H dec l₂) (boundedAdmittedBool H dec l₁) := by
  intro t ht
  have hconv := adaptive_order_converges_increasingInOwn U feedback ownBase offBase probed enough t ht
  have hm₀ : (t₀, f₀) ∈ U.items := by rw [itemsEq]; exact mem_horizonPairs_iff.mpr ⟨hle₀, cover f₀⟩
  refine hconv (boundedAdmittedBool H dec l₁) (boundedAdmittedBool H dec l₂)
    ⟨fun i _ hd2 => ?_, ⟨(t₀, f₀), hm₀, ?_, ?_⟩⟩
    ⟨(t₀, f₀), hm₀, own₀, ?_, ?_⟩
  · have h2 := (boundedAdmittedBool_true_iff H decides l₂ i).mp hd2
    exact (boundedAdmittedBool_true_iff H decides l₁ i).mpr ⟨h2.1, hinc i.1 i.2 h2.1 h2.2⟩
  · exact (boundedAdmittedBool_true_iff H decides l₁ (t₀, f₀)).mpr ⟨hle₀, ha1⟩
  · exact ListTests.false_iff_not.mpr fun h =>
      ha2 ((boundedAdmittedBool_true_iff H decides l₂ (t₀, f₀)).mp h).2
  · exact (boundedAdmittedBool_true_iff H decides l₁ (t₀, f₀)).mpr ⟨hle₀, ha1⟩
  · exact ListTests.false_iff_not.mpr fun h =>
      ha2 ((boundedAdmittedBool_true_iff H decides l₂ (t₀, f₀)).mp h).2

/-- Decidable bounded-horizon macro-capability admission predicate up to step `H`. -/
def boundedMacroBool {C K : Type} (H : Nat)
    (macroDec : (C → Nat) → Nat → K → Bool)
    (l : Nat → C → Nat) (i : Nat × K) : Bool :=
  Nat.ble i.1 H && macroDec (l i.1) i.1 i.2

theorem boundedMacroBool_true_iff {F C K : Type} {W : Web F C} (H : Nat) (cap : F → K)
    {macroDec : (C → Nat) → Nat → K → Bool}
    (decides : ∀ l t k, macroDec l t k = true ↔ W.MacroAdmits cap l t k)
    (l : Nat → C → Nat) (i : Nat × K) :
    boundedMacroBool H macroDec l i = true ↔ i.1 ≤ H ∧ W.MacroAdmits cap (l i.1) i.1 i.2 := by
  unfold boundedMacroBool
  refine ListTests.and_true_iff.trans ?_
  exact ⟨fun ⟨hb, hm⟩ => ⟨Nat.le_of_ble_eq_true hb, (decides (l i.1) i.1 i.2).mp hm⟩,
    fun ⟨hle, hadm⟩ => ⟨Nat.ble_eq_true_of_le hle, (decides (l i.1) i.1 i.2).mpr hadm⟩⟩

/-- **Limit 3(b) (Macro-Capability Comparability over Persisting Turnover)**: whenever macro roles
`K` are covered by a finite list `caps` and decided by `macroDec`, step-wise `MacroAdmits` and
horizon-bounded `boundedMacroBool` on `horizonPairs H caps` restore positive-weighting comparability
even when `Flow.persists_not_listsAdmitted` holds of the underlying micro-web. -/
theorem macroAdmits_restores_comparability {F C K : Type} {W : Web F C}
    (H : Nat) (cap : F → K) (caps : List K) (cover : ∀ k, k ∈ caps)
    {macroDec : (C → Nat) → Nat → K → Bool}
    (decides : ∀ l t k, macroDec l t k = true ↔ W.MacroAdmits cap l t k)
    (l₁ l₂ : Nat → C → Nat) :
    (∀ t, Weighting.WidensOn caps (fun k => macroDec (l₁ t) t k) (fun k => macroDec (l₂ t) t k) ↔
      ∀ w, Weighting.Positive caps w →
        Weighting.weighed caps w (fun k => macroDec (l₂ t) t k) <
          Weighting.weighed caps w (fun k => macroDec (l₁ t) t k)) ∧
    ((W.MacroIncludes cap l₁ l₂ ∧
      ∃ t k, t ≤ H ∧ W.MacroAdmits cap (l₁ t) t k ∧ ¬ W.MacroAdmits cap (l₂ t) t k) →
      ∀ w, Weighting.Positive (horizonPairs H caps) w →
        Weighting.weighed (horizonPairs H caps) w (boundedMacroBool H macroDec l₂) <
          Weighting.weighed (horizonPairs H caps) w (boundedMacroBool H macroDec l₁)) := by
  refine ⟨fun _ => Weighting.widens_iff_every_positive, fun ⟨hinc, t₀, k₀, hle₀, ha1, ha2⟩ => ?_⟩
  refine Weighting.widens_iff_every_positive.mp ⟨fun i _ hm2 => ?_,
    ⟨(t₀, k₀), mem_horizonPairs_iff.mpr ⟨hle₀, cover k₀⟩, ?_, ?_⟩⟩
  · have h2 := (boundedMacroBool_true_iff H cap decides l₂ i).mp hm2
    exact (boundedMacroBool_true_iff H cap decides l₁ i).mpr ⟨h2.1, hinc i.1 i.2 h2.2⟩
  · exact (boundedMacroBool_true_iff H cap decides l₁ (t₀, k₀)).mpr ⟨hle₀, ha1⟩
  · exact ListTests.false_iff_not.mpr fun h =>
      ha2 ((boundedMacroBool_true_iff H cap decides l₂ (t₀, k₀)).mp h).2

/-! ### Concrete Finite Witness for Target 1: `OnlineWeightWitness` -/

namespace OnlineWeightWitness

inductive OWItem : Type where
  | coupledSub
  | coupledGate
  | offProbe
  | victim

def owItems : List OWItem := [.coupledSub, .coupledGate, .offProbe, .victim]

def owOwn : OWItem → Bool
  | .coupledSub => true
  | .coupledGate => true
  | .offProbe => true
  | .victim => false

def owBase : OWItem → Nat
  | .coupledSub => 1
  | .coupledGate => 1
  | .offProbe => 1
  | .victim => 0

def owUpdater : OrderUpdater OWItem := ⟨owItems, owOwn, fun _ => 0, owBase, 2⟩

def owMem : ∀ x : OWItem, x ∈ owItems
  | .coupledSub => .head _
  | .coupledGate => .tail _ (.head _)
  | .offProbe => .tail _ (.tail _ (.head _))
  | .victim => .tail _ (.tail _ (.tail _ (.head _)))

/-- Full-probe feedback trace: pulses `.coupledSub` at `t=0`, `.coupledGate` at `t=1`,
`.offProbe` at `t=2`, and never `.victim`. -/
def feedbackAll (t : Nat) (x : OWItem) : Bool :=
  match t with
  | 0 => match x with
    | .coupledSub => true
    | .coupledGate => false
    | .offProbe => false
    | .victim => false
  | 1 => match x with
    | .coupledSub => false
    | .coupledGate => true
    | .offProbe => false
    | .victim => false
  | 2 => match x with
    | .coupledSub => false
    | .coupledGate => false
    | .offProbe => true
    | .victim => false
  | _ + 3 => false

/-- Partial-probe feedback trace: pulses `.coupledSub` at `t=0`, `.coupledGate` at `t=1`,
never `.offProbe`, never `.victim`. -/
def feedbackPartial (t : Nat) (x : OWItem) : Bool :=
  match t with
  | 0 => match x with
    | .coupledSub => true
    | .coupledGate => false
    | .offProbe => false
    | .victim => false
  | 1 => match x with
    | .coupledSub => false
    | .coupledGate => true
    | .offProbe => false
    | .victim => false
  | _ + 2 => false

def owProbe : OWItem → Bool
  | .coupledSub => true
  | .coupledGate => true
  | .offProbe => false
  | .victim => false

theorem feedbackAll_converges :
    ∀ t, 3 ≤ t → Weighting.IncreasingInOwn owItems owOwn (owUpdater.ranksAt feedbackAll t) :=
  adaptive_order_converges_increasingInOwn owUpdater feedbackAll (B := 1) (K := 1) (T := 3)
    (fun x _ hown => by cases x <;> first | exact Nat.le_refl 1 | exact Bool.noConfusion hown)
    (fun y _ hown => by cases y <;> first | exact Nat.le_refl 0 | exact Bool.noConfusion hown)
    (fun x _ hown => by
      cases x with
      | coupledSub => exact one_le_hitCount_of_lt feedbackAll (s := 0) (by decide) rfl
      | coupledGate => exact one_le_hitCount_of_lt feedbackAll (s := 1) (by decide) rfl
      | offProbe => exact one_le_hitCount_of_lt feedbackAll (s := 2) (by decide) rfl
      | victim => exact Bool.noConfusion hown)
    (by decide)

def cNone : OWItem → Bool := fun _ => false

def cSub : OWItem → Bool
  | .coupledSub => true
  | .coupledGate => false
  | .offProbe => false
  | .victim => false

def cGate : OWItem → Bool
  | .coupledSub => false
  | .coupledGate => true
  | .offProbe => false
  | .victim => false

def cOff : OWItem → Bool
  | .coupledSub => false
  | .coupledGate => false
  | .offProbe => true
  | .victim => false

def cVictim : OWItem → Bool
  | .coupledSub => false
  | .coupledGate => false
  | .offProbe => false
  | .victim => true

inductive OWOcc : Type where
  | pickSub
  | pickGate

def owTrace : ChoiceOccasions (OWItem → Bool) OWOcc where
  menu o x := match o with
    | .pickSub => x = cSub ∨ x = cNone
    | .pickGate => x = cGate ∨ x = cNone
  pick o := match o with
    | .pickSub => cSub
    | .pickGate => cGate

theorem cOff_unmet : owTrace.Unmet cOff :=
  ⟨fun o hmem => match o, hmem with
    | .pickSub, .inl h => Bool.noConfusion (congrFun h .offProbe)
    | .pickSub, .inr h => Bool.noConfusion (congrFun h .offProbe)
    | .pickGate, .inl h => Bool.noConfusion (congrFun h .offProbe)
    | .pickGate, .inr h => Bool.noConfusion (congrFun h .offProbe),
   fun o hpick => match o, hpick with
    | .pickSub, h => Bool.noConfusion (congrFun h .offProbe)
    | .pickGate, h => Bool.noConfusion (congrFun h .offProbe)⟩

theorem cOff_widensBy : Weighting.WidensBy owItems .offProbe cOff cNone :=
  ⟨fun _ _ h => Bool.noConfusion h, owMem .offProbe, rfl, rfl,
   fun y _ ha _ => match y, ha with
     | .offProbe, _ => rfl⟩

theorem cVictim_widensBy : Weighting.WidensBy owItems .victim cVictim cNone :=
  ⟨fun _ _ h => Bool.noConfusion h, owMem .victim, rfl, rfl,
   fun y _ ha _ => match y, ha with
     | .victim, _ => rfl⟩

theorem partial_reverses_and_firewall {Pos F : Type} (p : Pos) (f : F) :
    (∀ t, 3 ≤ t → Weighting.IncreasingInOwn owItems owOwn (owUpdater.ranksAt feedbackAll t)) ∧
    (∀ t, owUpdater.posAt feedbackAll t .victim = 0) ∧
    (∀ t, ¬ owUpdater.ranksAt feedbackAll t cVictim cNone ∧
          ¬ owUpdater.ranksAt feedbackAll t cNone cVictim) ∧
    (Weighting.IncreasingInOwnOn
      (fun a b => ∀ z, z ∈ owItems → owProbe z = false → a z = b z)
      owItems owOwn (owUpdater.ranksAt feedbackPartial 2) ∧
     (∀ t, owUpdater.ranksAt feedbackPartial t cOff cNone ∧
           ¬ owUpdater.ranksAt feedbackPartial t cNone cOff) ∧
     ¬ Weighting.IncreasingInOwn owItems owOwn (owUpdater.ranksAt feedbackPartial 2)) ∧
    (∃ P : «际» (OWItem → Bool),
      (∀ x, ¬ P x x) ∧ (∀ x y z, P x y → P y z → P x z) ∧ owTrace.Accords P ∧
      Weighting.IncreasingInOwnOn owTrace.Met owItems owOwn (fun y x => P x y) ∧
      P cNone cOff ∧ ¬ Weighting.IncreasingInOwn owItems owOwn (fun y x => P x y)) ∧
    ¬ (∀ (d : OrderUpdater OWItem) (sig : Pos → Nat → F → Prop),
        (∀ t, d.posAt feedbackAll t .victim = 0) → Unrestricted sig) := by
  have hNeverVictim : ∀ t, feedbackAll t .victim = false := fun t => by
    cases t with
    | zero => rfl
    | succ t1 => cases t1 with
      | zero => rfl
      | succ t2 => cases t2 <;> rfl
  have hFw := uncoupled_blindness_firewall owUpdater feedbackAll hNeverVictim rfl cVictim_widensBy p f
  have hNeverOff : ∀ s, s < 2 → feedbackPartial s .offProbe = false := fun s hs => by
    cases s with
    | zero => rfl
    | succ s1 => cases s1 with
      | zero => rfl
      | succ s2 => exact absurd hs (Nat.not_lt_of_le (Nat.succ_le_succ (Nat.succ_le_succ (Nat.zero_le s2))))
  have hRev2 := online_weight_learner_reverses_off_support owUpdater feedbackPartial (B := 1) (K := 1) (T := 2) owProbe
    (fun x _ hown hpr => by
      cases x <;> first | exact Nat.le_refl 1 | exact Bool.noConfusion hown | exact Bool.noConfusion hpr)
    (fun y _ hown _ => by cases y <;> first | exact Nat.le_refl 0 | exact Bool.noConfusion hown)
    (fun x _ hown hpr => by
      cases x with
      | coupledSub => exact one_le_hitCount_of_lt feedbackPartial (s := 0) (by decide) rfl
      | coupledGate => exact one_le_hitCount_of_lt feedbackPartial (s := 1) (by decide) rfl
      | offProbe => exact Bool.noConfusion hpr
      | victim => exact Bool.noConfusion hown)
    (by decide)
    hNeverOff (by decide) cOff_widensBy
  have hRevAll : ∀ t, owUpdater.ranksAt feedbackPartial t cOff cNone ∧
      ¬ owUpdater.ranksAt feedbackPartial t cNone cOff := fun t => by
    have hNev : ∀ s, s < t → feedbackPartial s .offProbe = false := fun s _ => by
      cases s with
      | zero => rfl
      | succ s1 => cases s1 <;> rfl
    have hpos : owUpdater.posAt feedbackPartial t .offProbe = 0 :=
      owUpdater.posAt_eq_init_of_never feedbackPartial hNev
    have hlt : owUpdater.posAt feedbackPartial t .offProbe < owBase .offProbe := by
      rw [hpos]; exact by decide
    exact ⟨(Weighting.ranksNet_widensBy cOff_widensBy).2.mpr hlt,
      fun hba => Nat.lt_asymm hlt ((Weighting.ranksNet_widensBy cOff_widensBy).1.mp hba)⟩
  have hAcc : owTrace.Accords (fun x y => owUpdater.ranksAt feedbackPartial 2 y x) := by
    intro o y hmem hne
    cases o with
    | pickSub =>
      cases hmem with
      | inl h => exact absurd h hne
      | inr h =>
        subst h
        show 0 + 1 < 2 + 0
        decide
    | pickGate =>
      cases hmem with
      | inl h => exact absurd h hne
      | inr h =>
        subst h
        show 0 + 1 < 2 + 0
        decide
  have hMetAgree : ∀ a b, owTrace.Met a b → ∀ z, z ∈ owItems → owProbe z = false → a z = b z := by
    intro a b ⟨o, ha, hb⟩ z _ hz
    cases o with
    | pickSub =>
      cases ha with
      | inl ha' => cases hb with
        | inl hb' => rw [ha', hb']
        | inr hb' => rw [ha', hb']; cases z <;> first | rfl | exact Bool.noConfusion hz
      | inr ha' => cases hb with
        | inl hb' => rw [ha', hb']; cases z <;> first | rfl | exact Bool.noConfusion hz
        | inr hb' => rw [ha', hb']
    | pickGate =>
      cases ha with
      | inl ha' => cases hb with
        | inl hb' => rw [ha', hb']
        | inr hb' => rw [ha', hb']; cases z <;> first | rfl | exact Bool.noConfusion hz
      | inr ha' => cases hb with
        | inl hb' => rw [ha', hb']; cases z <;> first | rfl | exact Bool.noConfusion hz
        | inr hb' => rw [ha', hb']
  have hTraceRev := online_off_support_reversal owUpdater feedbackPartial (B := 1) (K := 1) (T := 2)
    owProbe owTrace hMetAgree
    (fun x _ hown hpr => by
      cases x <;> first | exact Nat.le_refl 1 | exact Bool.noConfusion hown | exact Bool.noConfusion hpr)
    (fun y _ hown _ => by cases y <;> first | exact Nat.le_refl 0 | exact Bool.noConfusion hown)
    (fun x _ hown hpr => by
      cases x with
      | coupledSub => exact one_le_hitCount_of_lt feedbackPartial (s := 0) (by decide) rfl
      | coupledGate => exact one_le_hitCount_of_lt feedbackPartial (s := 1) (by decide) rfl
      | offProbe => exact Bool.noConfusion hpr
      | victim => exact Bool.noConfusion hown)
    (by decide)
    hAcc cOff_unmet (Weighting.widensOn_of_widensBy cOff_widensBy)
    ⟨.offProbe, owMem .offProbe, rfl, rfl, rfl⟩
  exact ⟨feedbackAll_converges, hFw.1,
    fun t => ⟨(hFw.2.1 rfl t).2, (hFw.2.1 rfl t).1⟩,
    ⟨hRev2.1, hRevAll, hRev2.2.2.2 rfl⟩, hTraceRev, hFw.2.2.2.2⟩

/-! ### Persisting alternating macro witness (`OWPersist`)

Modeled on `FromTheDynamics.Alternating` with static `.cPool ≡ 1` so total stock is `2`,
satisfying `W.ComesToStand`, `Flow.persists_not_listsAdmitted`, `TransformsViably`, and
finite-horizon / `MacroAdmits` comparability simultaneously. -/
namespace OWPersist

inductive OWNode : Type where
  | cPool
  | mA
  | mB

inductive OWMacro : Type where
  | macroKeep

def owNodes : List OWNode := [.cPool, .mA, .mB]

def owNodeMem : ∀ x : OWNode, x ∈ owNodes
  | .cPool => .head _
  | .mA => .tail _ (.head _)
  | .mB => .tail _ (.tail _ (.head _))

def owMacros : List OWMacro := [.macroKeep]

def owMacroMem : ∀ k : OWMacro, k ∈ owMacros
  | .macroKeep => .head _

def parity : Nat → Bool
  | 0 => true
  | t + 1 => !parity t

def activeNode (t : Nat) : OWNode := match parity t with
  | true => .mA
  | false => .mB

def nextNode (t : Nat) : OWNode := match parity t with
  | true => .mB
  | false => .mA

def unitAt : Bool → OWNode → Nat
  | _, .cPool => 1
  | true, .mA => 1
  | false, .mA => 0
  | true, .mB => 0
  | false, .mB => 1

def web : Web OWNode OWNode where
  level t c := unitAt (parity t) c
  active t f := f = activeNode t
  requires _ f c := match f with
    | .cPool => c = .cPool
    | .mA => c = .cPool ∨ c = .mA
    | .mB => c = .cPool ∨ c = .mB
  need _ f _ := match f with
    | .cPool => 2
    | .mA => 1
    | .mB => 1
  draws t f c := f = activeNode t ∧ c = f

def flow : Flow OWNode OWNode where
  present t := [activeNode t]
  take t f c := match f with
    | .cPool => 0
    | .mA => match c with
      | .mA => match parity t with | true => 1 | false => 0
      | .cPool => 0
      | .mB => 0
    | .mB => match c with
      | .mB => match parity t with | true => 0 | false => 1
      | .cPool => 0
      | .mA => 0
  give t f c := match f with
    | .cPool => 0
    | .mA => match c with
      | .mB => match parity t with | true => 1 | false => 0
      | .cPool => 0
      | .mA => 0
    | .mB => match c with
      | .mA => match parity t with | true => 0 | false => 1
      | .cPool => 0
      | .mB => 0

def generations : SelectionTerm.Generations OWNode where
  first := [.mA]
  kids t _ := [nextNode t]
  amount _ _ := 1

theorem family_eq : ∀ t, generations.family t = [activeNode t]
  | 0 => rfl
  | t + 1 => by
    show (generations.family t).flatMap (generations.kids t) = [activeNode (t + 1)]
    rw [family_eq t]
    show [nextNode t] = [activeNode (t + 1)]
    dsimp only [nextNode, activeNode, parity]
    cases parity t <;> rfl

theorem balances : flow.Balances web := fun t c => by
  show unitAt (parity (t + 1)) c + (flow.take t (activeNode t) c + 0) =
    unitAt (parity t) c + (flow.give t (activeNode t) c + 0)
  dsimp only [activeNode, flow, unitAt, parity]
  cases parity t <;> cases c <;> rfl

theorem acting : flow.Acting web := fun t f _ mem _ => by
  change f ∈ [activeNode t] at mem
  cases mem with
  | head => rfl
  | tail _ h => nomatch h

theorem dependent : web.Dependent := fun t f hf c hreq => by
  have heq : f = activeNode t := hf
  cases f with
  | cPool =>
    cases hp : parity t <;> dsimp only [activeNode] at heq <;> rw [hp] at heq <;> nomatch heq
  | mA =>
    rcases hreq with rfl | rfl
    · show 1 ≤ unitAt (parity t) .cPool; exact Nat.le_refl 1
    · show 1 ≤ unitAt (parity t) .mA
      cases hp : parity t with
      | true => dsimp only [unitAt]; exact Nat.le_refl 1
      | false => dsimp only [activeNode] at heq; rw [hp] at heq; nomatch heq
  | mB =>
    rcases hreq with rfl | rfl
    · show 1 ≤ unitAt (parity t) .cPool; exact Nat.le_refl 1
    · show 1 ≤ unitAt (parity t) .mB
      cases hp : parity t with
      | true => dsimp only [activeNode] at heq; rw [hp] at heq; nomatch heq
      | false => dsimp only [unitAt]; exact Nat.le_refl 1

theorem descended : SelectionTerm.Flow.Descended flow web generations := fun t p k mp mk => by
  rw [family_eq t] at mp
  cases mp with
  | head =>
    cases mk with
    | head =>
      refine ⟨.head _, ?_, ?_, ?_⟩
      · dsimp only [activeNode, nextNode, flow]
        cases parity t <;> exact Nat.zero_lt_one
      · dsimp only [web, nextNode, unitAt]
        cases parity t <;> exact Nat.lt_irrefl 0
      · show 0 < unitAt (parity (t + 1)) (nextNode t)
        dsimp only [nextNode, unitAt, parity]
        cases parity t <;> exact Nat.zero_lt_one
    | tail _ no => nomatch no
  | tail _ no => nomatch no

theorem persists : generations.Persists := fun N =>
  ⟨N, activeNode N, Nat.le_refl N,
    Eq.subst (motive := fun l => activeNode N ∈ l) (family_eq N).symm (.head _)⟩

theorem stock_two (t : Nat) : web.stock owNodes t = 2 := by
  show unitAt (parity t) .cPool + (unitAt (parity t) .mA + (unitAt (parity t) .mB + 0)) = 2
  cases parity t <;> rfl

def cap : OWNode → OWMacro
  | _ => .macroKeep

def admitDec (l : Nat → OWNode → Nat) (i : Nat × OWNode) : Bool :=
  match i.2 with
  | .cPool => Nat.ble 2 (l i.1 .cPool)
  | .mA => Nat.ble 1 (l i.1 .cPool) && Nat.ble 1 (l i.1 .mA)
  | .mB => Nat.ble 1 (l i.1 .cPool) && Nat.ble 1 (l i.1 .mB)

theorem decides : web.DecidesAdmission admitDec := fun l i => by
  cases i with | mk t f =>
  cases f with
  | cPool =>
    show Nat.ble 2 (l t .cPool) = true ↔ ∀ c, c = .cPool → 2 ≤ l t c
    exact ⟨fun hb c hc => hc ▸ Nat.le_of_ble_eq_true hb,
      fun hadm => Nat.ble_eq_true_of_le (hadm .cPool rfl)⟩
  | mA =>
    show (Nat.ble 1 (l t .cPool) && Nat.ble 1 (l t .mA)) = true ↔
        ∀ c, c = .cPool ∨ c = .mA → 1 ≤ l t c
    refine ListTests.and_true_iff.trans ?_
    exact ⟨fun ⟨h1, h2⟩ c hc => hc.elim (fun e => e ▸ Nat.le_of_ble_eq_true h1)
        (fun e => e ▸ Nat.le_of_ble_eq_true h2),
      fun hadm => ⟨Nat.ble_eq_true_of_le (hadm .cPool (.inl rfl)),
        Nat.ble_eq_true_of_le (hadm .mA (.inr rfl))⟩⟩
  | mB =>
    show (Nat.ble 1 (l t .cPool) && Nat.ble 1 (l t .mB)) = true ↔
        ∀ c, c = .cPool ∨ c = .mB → 1 ≤ l t c
    refine ListTests.and_true_iff.trans ?_
    exact ⟨fun ⟨h1, h2⟩ c hc => hc.elim (fun e => e ▸ Nat.le_of_ble_eq_true h1)
        (fun e => e ▸ Nat.le_of_ble_eq_true h2),
      fun hadm => ⟨Nat.ble_eq_true_of_le (hadm .cPool (.inl rfl)),
        Nat.ble_eq_true_of_le (hadm .mB (.inr rfl))⟩⟩

def macroDec (l : OWNode → Nat) (_ : Nat) (_ : OWMacro) : Bool :=
  Nat.ble 2 (l .cPool) ||
    (Nat.ble 1 (l .cPool) && Nat.ble 1 (l .mA)) ||
    (Nat.ble 1 (l .cPool) && Nat.ble 1 (l .mB))

theorem decidesMacro (l : OWNode → Nat) (t : Nat) (k : OWMacro) :
    macroDec l t k = true ↔ web.MacroAdmits cap l t k := by
  cases k
  unfold macroDec
  refine ListTests.or_true_iff.trans ?_
  refine ⟨fun h => ?_, fun ⟨f, _, hadm⟩ => ?_⟩
  · rcases h with h12 | h3
    · rcases ListTests.or_true_iff.mp h12 with h1 | h2
      · exact ⟨.cPool, rfl, (decides (fun _ => l) (t, .cPool)).mp h1⟩
      · exact ⟨.mA, rfl, (decides (fun _ => l) (t, .mA)).mp h2⟩
    · exact ⟨.mB, rfl, (decides (fun _ => l) (t, .mB)).mp h3⟩
  · cases f with
    | cPool =>
      exact Or.inl (ListTests.or_true_iff.mpr (Or.inl ((decides (fun _ => l) (t, .cPool)).mpr hadm)))
    | mA =>
      exact Or.inl (ListTests.or_true_iff.mpr (Or.inr ((decides (fun _ => l) (t, .mA)).mpr hadm)))
    | mB =>
      exact Or.inr ((decides (fun _ => l) (t, .mB)).mpr hadm)

theorem admits_active (t : Nat) : web.Admits (web.level t) t (activeNode t) := by
  cases hp : parity t <;> dsimp only [activeNode] <;> rw [hp]
  · intro c hc
    rcases hc with rfl | rfl
    · show 1 ≤ unitAt (parity t) .cPool; exact Nat.le_refl 1
    · show 1 ≤ unitAt (parity t) .mB; rw [hp]; exact Nat.le_refl 1
  · intro c hc
    rcases hc with rfl | rfl
    · show 1 ≤ unitAt (parity t) .cPool; exact Nat.le_refl 1
    · show 1 ≤ unitAt (parity t) .mA; rw [hp]; exact Nat.le_refl 1

theorem not_admits_active_next (t : Nat) :
    ¬ web.Admits (web.level (t + 1)) (t + 1) (activeNode t) := by
  cases hp : parity t <;> dsimp only [activeNode] <;> rw [hp]
  · intro hadm
    have hle : 1 ≤ unitAt (parity (t + 1)) .mB := hadm .mB (.inr rfl)
    dsimp only [parity, unitAt] at hle
    rw [hp] at hle
    exact Nat.not_le_of_gt Nat.zero_lt_one hle
  · intro hadm
    have hle : 1 ≤ unitAt (parity (t + 1)) .mA := hadm .mA (.inr rfl)
    dsimp only [parity, unitAt] at hle
    rw [hp] at hle
    exact Nat.not_le_of_gt Nat.zero_lt_one hle

theorem witness_holds (H : Nat) :
    (∀ t, web.stock owNodes t = 2) ∧
    (∀ items, ¬ web.ListsAdmitted items web.level) ∧
    TransformsViably web (fun t => 1 ≤ web.level t .cPool) cap 0 ∧
    (∀ w, Weighting.Positive (horizonPairs H owNodes) w →
      Weighting.weighed (horizonPairs H owNodes) w (boundedAdmittedBool H admitDec (fun _ _ => 0)) <
        Weighting.weighed (horizonPairs H owNodes) w (boundedAdmittedBool H admitDec web.level)) ∧
    (∀ w, Weighting.Positive (horizonPairs H owMacros) w →
      Weighting.weighed (horizonPairs H owMacros) w (boundedMacroBool H macroDec (fun _ _ => 0)) <
        Weighting.weighed (horizonPairs H owMacros) w (boundedMacroBool H macroDec web.level)) := by
  have hNotListed := Flow.persists_not_listsAdmitted acting dependent descended persists
  have hTV : TransformsViably web (fun t => 1 ≤ web.level t .cPool) cap 0 :=
    ⟨fun t _ => Nat.le_refl 1,
     fun _ t _ _ k _ => by cases k; exact ⟨activeNode t, rfl, admits_active t⟩,
     fun t _ => ⟨activeNode t, admits_active t, not_admits_active_next t⟩⟩
  have hZeroNot : ∀ t f, ¬ web.Admits (fun _ => 0) t f := fun t f h0 => by
    cases f with
    | cPool => exact Nat.not_le_of_gt (by decide : 0 < 2) (h0 .cPool rfl)
    | mA => exact Nat.not_le_of_gt (by decide : 0 < 1) (h0 .cPool (.inl rfl))
    | mB => exact Nat.not_le_of_gt (by decide : 0 < 1) (h0 .cPool (.inl rfl))
  have hHor := (horizon_admitted_widens_iff H owNodes owNodeMem decides web.level (fun _ _ => 0)).mp
    ⟨fun t f _ h0 => absurd h0 (hZeroNot t f),
     0, .mA, Nat.zero_le H, admits_active 0, hZeroNot 0 .mA⟩
  have hMac := (macroAdmits_restores_comparability H cap owMacros owMacroMem decidesMacro
      web.level (fun _ _ => 0)).2
    ⟨fun t k ⟨f, _, h0⟩ => absurd h0 (hZeroNot t f),
     0, .macroKeep, Nat.zero_le H, ⟨.mA, rfl, admits_active 0⟩,
     fun ⟨f, _, h0⟩ => hZeroNot 0 f h0⟩
  exact ⟨stock_two, hNotListed, hTV, hHor, hMac⟩

end OWPersist

end OnlineWeightWitness

/-! ## 2. Target 2 — Endogenous Scope Co-Evolution & Emergence Thresholds -/

/-! ### 2A. Dynamic Mode-Switching Agent (`PolyComposition`) -/

inductive ScopeMode : Type where
  | narrowUnmonitored
  | wideReciprocal

abbrev ScopeS : ScopeMode → Type := fun _ => Nat
abbrev ScopeObs : ScopeMode → Type := fun _ => Bool
abbrev ScopeDist : ScopeMode → Type := fun _ => Unit
abbrev ScopeInt : ScopeMode → Type := fun _ => Empty
abbrev ScopeExt : ScopeMode → Type := fun _ => Unit

def scopeRoute (_ : ScopeMode) (_ : Unit) : List Unit := [()]

def scopeObs (warnLevel : Nat) (_ : ScopeMode) (x : Unit → Nat) : Bool :=
  Nat.blt (x ()) warnLevel

def scopeChannel (em : Bool) (load : Nat) (_ : Unit) : Bool :=
  em && Nat.ble load 0

/-- Trusted-base specification for `ScopeMode`: `K` excludes `⟨.narrowUnmonitored, 0⟩`
(`0 < s ∧ s ≤ maxLagN` in `.narrowUnmonitored`, `s = 0` in `.wideReciprocal`) so `within` and
`ModeRefines` hold together without contradiction. -/
def scopeBase (preDraw coopDraw maxLagN : Nat) (_ : coopDraw ≤ preDraw) :
    PolyComposition.AnchoredBase ScopeMode ScopeS ScopeObs ScopeDist ScopeInt ScopeExt where
  drawInt _ e := Empty.elim e
  drawExt p _ := match p.1 with
    | .narrowUnmonitored => preDraw
    | .wideReciprocal => coopDraw
  emitAlarm _ _ obs := obs
  silenceLoad _ := 0
  favours p := match p.1 with
    | .narrowUnmonitored => True
    | .wideReciprocal => False
  tol _ _ _ := True
  warnObs _ obs := obs = true
  preCapInt _ e := Empty.elim e
  preCapExt m _ := match m with
    | .narrowUnmonitored => preDraw
    | .wideReciprocal => coopDraw
  postAllowanceInt _ e := Empty.elim e
  postAllowanceExt _ _ := coopDraw
  maxSilence _ := 0
  maxLag m := match m with
    | .narrowUnmonitored => maxLagN
    | .wideReciprocal => 0
  K p := match p.1 with
    | .narrowUnmonitored => 0 < p.2 ∧ p.2 ≤ maxLagN
    | .wideReciprocal => p.2 = 0
  eta p := p.2
  within p hK := by
    cases p with | mk m s =>
    cases m with
    | narrowUnmonitored =>
      exact ⟨fun e => Empty.elim e, fun _ => Nat.le_refl preDraw, Nat.le_refl 0,
        fun h0 => absurd h0 (Naturals.ne_of_lt hK.1).symm⟩
    | wideReciprocal =>
      exact ⟨fun e => Empty.elim e, fun _ => Nat.le_refl coopDraw, Nat.le_refl 0,
        fun _ => ⟨fun f => f, fun e => Empty.elim e, fun _ => Nat.le_refl coopDraw⟩⟩
  eta_bound p hK := by
    cases p with | mk m s =>
    cases m with
    | narrowUnmonitored => exact hK.2
    | wideReciprocal => exact Nat.le_of_eq hK
  emits_on_warn _ _ _ _ hw := hw

def scopeAdmitDec (maxLagN : Nat) (p cand : Σ m, ScopeS m) (al : Bool) : Bool :=
  match cand with
  | ⟨.narrowUnmonitored, s⟩ =>
    Nat.blt 0 s && Nat.ble s maxLagN && (!al || Nat.blt s p.2)
  | ⟨.wideReciprocal, s⟩ =>
    Nat.beq s 0

def scopeFallback (p : Σ m, ScopeS m) (oa : ScopeObs p.1 × Bool) (_ : ScopeDist p.1) :
    Σ m', ScopeS m' :=
  match oa.2 with
  | true => ⟨.wideReciprocal, 0⟩
  | false => p

theorem scopeAdmit_sound (preDraw coopDraw maxLagN : Nat) (coop_le_pre : coopDraw ≤ preDraw) :
    PolyComposition.AnchoredModeAdmit (scopeBase preDraw coopDraw maxLagN coop_le_pre)
      (scopeAdmitDec maxLagN) scopeFallback where
  admit_sound p cand al hK hadm := by
    cases cand with | mk m s =>
    cases m with
    | narrowUnmonitored =>
      have h12 := ListTests.and_left hadm
      have h3 := ListTests.and_right hadm
      have hpos : 0 < s := CoreHelpers.natBlt_true_iff.mp (ListTests.and_left h12)
      have hle : s ≤ maxLagN := Nat.le_of_ble_eq_true (ListTests.and_right h12)
      refine ⟨⟨hpos, hle⟩, fun ha h0 => ?_, fun ha h0 => ?_⟩
      · subst ha
        exact CoreHelpers.natBlt_true_iff.mp h3
      · subst ha
        have hlt : s < p.2 := CoreHelpers.natBlt_true_iff.mp h3
        have hlt0 : s < 0 := h0 ▸ hlt
        exact absurd hlt0 (Nat.not_lt_zero s)
    | wideReciprocal =>
      have hs0 : s = 0 := CoreHelpers.natBeq_true_iff.mp hadm
      refine ⟨hs0, fun _ hpos => hs0 ▸ hpos, fun _ _ => hs0⟩
  fallback_sound p oa _ hK _ := by
    cases h : oa.2 with
    | true =>
      dsimp only [scopeFallback]
      rw [h]
      exact ⟨rfl, fun _ hpos => hpos, fun _ _ => rfl⟩
    | false =>
      dsimp only [scopeFallback]
      rw [h]
      exact ⟨hK, fun ha _ => Bool.noConfusion ha, fun ha _ => Bool.noConfusion ha⟩

/-- Timely mode switching under `PolyComposition.anchoredSelfModComponent` keeps any unconstrained
proposer `propose` inside `Viability.Kernel` forever whenever `init_margin` and `warn_margin` hold. -/
theorem timely_modeSwitch_viability_kernel
    (preDraw coopDraw maxLagN initLag envCap x_crit warnLevel x₀ : Nat)
    (coop_le_pre : coopDraw ≤ preDraw)
    (init_in : 0 < initLag ∧ initLag ≤ maxLagN)
    (propose : (p : Σ m, ScopeS m) → ScopeObs p.1 × Bool → ScopeDist p.1 → Σ m', ScopeS m')
    (G : Nat → Nat) (G_rises : ∀ a b, a ≤ b → G a ≤ G b)
    (post_viable : x_crit ≤
      RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole (fun _ e => G (e ()))
        (fun _ => coopDraw + envCap) (fun _ => x_crit) ())
    (warn_margin : x_crit + (maxLagN + 1) * (preDraw + envCap) ≤ warnLevel)
    (init_margin : x_crit + initLag * (preDraw + envCap) ≤ x₀) :
    Viability.Kernel
      (PolyComposition.polyClosedProcess
        (PolyComposition.anchoredSelfModComponent
          (scopeBase preDraw coopDraw maxLagN coop_le_pre)
          (scopeAdmitDec maxLagN) scopeFallback propose)
        scopeRoute
        (PolyComposition.anchoredSelfModContract
          (scopeBase preDraw coopDraw maxLagN coop_le_pre)
          (init := ⟨.narrowUnmonitored, initLag⟩) ⟨init_in⟩ (scopeAdmitDec maxLagN) scopeFallback
          (scopeAdmit_sound preDraw coopDraw maxLagN coop_le_pre) propose)
        (scopeObs warnLevel) scopeChannel (fun _ e => G (e ())) (fun _ _ => envCap) (fun _ => True))
      (PolyComposition.polyClosedGuard
        (PolyComposition.anchoredSelfModComponent
          (scopeBase preDraw coopDraw maxLagN coop_le_pre)
          (scopeAdmitDec maxLagN) scopeFallback propose)
        (PolyComposition.anchoredSelfModContract
          (scopeBase preDraw coopDraw maxLagN coop_le_pre)
          (init := ⟨.narrowUnmonitored, initLag⟩) ⟨init_in⟩ (scopeAdmitDec maxLagN) scopeFallback
          (scopeAdmit_sound preDraw coopDraw maxLagN coop_le_pre) propose)
        (fun _ => x_crit))
      (fun _ => x₀, ⟨.narrowUnmonitored, initLag⟩) := by
  exact PolyComposition.anchored_selfMod_viable
    (scopeBase preDraw coopDraw maxLagN coop_le_pre)
    (init := ⟨.narrowUnmonitored, initLag⟩) ⟨init_in⟩
    (scopeAdmitDec maxLagN) scopeFallback (scopeAdmit_sound preDraw coopDraw maxLagN coop_le_pre)
    propose scopeRoute (scopeObs warnLevel) scopeChannel (fun _ e => G (e ()))
    (fun _ _ => envCap) (fun _ => envCap) (fun _ => True)
    (fun _ _ _ => Nat.le_refl envCap)
    (fun _ => preDraw) (fun _ => coopDraw) maxLagN 0
    (fun m site => by
      cases site
      cases m with
      | narrowUnmonitored => exact Nat.le_refl preDraw
      | wideReciprocal => exact coop_le_pre)
    (fun m site => by
      cases site
      exact Nat.le_refl coopDraw)
    (fun m => by
      cases m with
      | narrowUnmonitored => exact Nat.le_refl maxLagN
      | wideReciprocal => exact Nat.zero_le maxLagN)
    (fun m => Nat.le_refl 0)
    (fun _ => x_crit) (fun _ => warnLevel) (fun _ => coopDraw + envCap) (fun _ => x₀)
    (fun m _ x site _ hlt => by
      cases site
      show Nat.blt (x ()) warnLevel = true
      exact CoreHelpers.natBlt_true_iff.mpr hlt)
    (fun load _ _ hle => by
      show (true && Nat.ble load 0) = true
      rw [Nat.ble_eq_true_of_le hle]
      rfl)
    (fun _ _ _ hbelow => G_rises _ _ (hbelow ()))
    (fun site => by cases site; exact post_viable)
    (fun _ => Nat.le_refl _)
    (fun _ => warn_margin)
    (fun _ => init_margin)

/-- `.wideReciprocal` strictly refines `.narrowUnmonitored` in `PolyComposition.ModeRefines`. -/
theorem wide_modeRefines_narrow
    (preDraw coopDraw maxLagN warnLevel : Nat) (coop_le_pre : coopDraw ≤ preDraw) (m : ScopeMode) :
    PolyComposition.ModeRefines
      (scopeBase preDraw coopDraw maxLagN coop_le_pre)
      scopeRoute (scopeObs warnLevel) (fun _ => warnLevel) .narrowUnmonitored m where
  pre_le site := by
    cases site
    cases m with
    | narrowUnmonitored => exact Nat.le_refl preDraw
    | wideReciprocal => exact coop_le_pre
  post_le site := by cases site; exact Nat.le_refl coopDraw
  lag_le := by
    cases m with
    | narrowUnmonitored => exact Nat.le_refl maxLagN
    | wideReciprocal => exact Nat.zero_le maxLagN
  silence_le := Nat.le_refl 0
  warn_widened _ _ _ hw := hw

/-- `PolyComposition.monotone_selfWidening_viable` companion showing `ModeRefines` propagates initial
envelope bounds and warning soundness to `Viability.Kernel`. -/
theorem timely_modeRefines_viability_kernel
    (preDraw coopDraw maxLagN initLag envCap x_crit warnLevel x₀ : Nat)
    (coop_le_pre : coopDraw ≤ preDraw)
    (init_in : 0 < initLag ∧ initLag ≤ maxLagN)
    (propose : (p : Σ m, ScopeS m) → ScopeObs p.1 × Bool → ScopeDist p.1 → Σ m', ScopeS m')
    (G : Nat → Nat) (G_rises : ∀ a b, a ≤ b → G a ≤ G b)
    (post_viable : x_crit ≤
      RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole (fun _ e => G (e ()))
        (fun _ => coopDraw + envCap) (fun _ => x_crit) ())
    (warn_margin : x_crit + (maxLagN + 1) * (preDraw + envCap) ≤ warnLevel)
    (init_margin : x_crit + initLag * (preDraw + envCap) ≤ x₀) :
    Viability.Kernel
      (PolyComposition.polyClosedProcess
        (PolyComposition.anchoredSelfModComponent
          (scopeBase preDraw coopDraw maxLagN coop_le_pre)
          (scopeAdmitDec maxLagN) scopeFallback propose)
        scopeRoute
        (PolyComposition.anchoredSelfModContract
          (scopeBase preDraw coopDraw maxLagN coop_le_pre)
          (init := ⟨.narrowUnmonitored, initLag⟩) ⟨init_in⟩ (scopeAdmitDec maxLagN) scopeFallback
          (scopeAdmit_sound preDraw coopDraw maxLagN coop_le_pre) propose)
        (scopeObs warnLevel) scopeChannel (fun _ e => G (e ())) (fun _ _ => envCap) (fun _ => True))
      (PolyComposition.polyClosedGuard
        (PolyComposition.anchoredSelfModComponent
          (scopeBase preDraw coopDraw maxLagN coop_le_pre)
          (scopeAdmitDec maxLagN) scopeFallback propose)
        (PolyComposition.anchoredSelfModContract
          (scopeBase preDraw coopDraw maxLagN coop_le_pre)
          (init := ⟨.narrowUnmonitored, initLag⟩) ⟨init_in⟩ (scopeAdmitDec maxLagN) scopeFallback
          (scopeAdmit_sound preDraw coopDraw maxLagN coop_le_pre) propose)
        (fun _ => x_crit))
      (fun _ => x₀, ⟨.narrowUnmonitored, initLag⟩) :=
  PolyComposition.monotone_selfWidening_viable
    (scopeBase preDraw coopDraw maxLagN coop_le_pre)
    (init := ⟨.narrowUnmonitored, initLag⟩) ⟨init_in⟩
    (scopeAdmitDec maxLagN) scopeFallback (scopeAdmit_sound preDraw coopDraw maxLagN coop_le_pre)
    propose scopeRoute (scopeObs warnLevel) scopeChannel (fun _ e => G (e ()))
    (fun _ _ => envCap) (fun _ => envCap) (fun _ => True)
    (fun _ _ _ => Nat.le_refl envCap)
    (fun _ => preDraw) (fun _ => coopDraw) maxLagN 0
    (fun _ => x_crit) (fun _ => warnLevel) (fun _ => coopDraw + envCap) (fun _ => x₀)
    (fun _ => Nat.le_refl preDraw)
    (fun _ => Nat.le_refl coopDraw)
    (Nat.le_refl maxLagN)
    (Nat.le_refl 0)
    (fun x site hlt => by cases site; exact CoreHelpers.natBlt_true_iff.mpr hlt)
    (fun m _ _ => wide_modeRefines_narrow preDraw coopDraw maxLagN warnLevel coop_le_pre m)
    (fun load _ _ hle => by show (true && Nat.ble load 0) = true; rw [Nat.ble_eq_true_of_le hle]; rfl)
    (fun _ _ _ hbelow => G_rises _ _ (hbelow ()))
    (fun site => by cases site; exact post_viable)
    (fun _ => Nat.le_refl _)
    (fun _ => warn_margin)
    (fun _ => init_margin)

/-! ### 2B. Multi-Level Cohort & Lineage Co-Evolution Thresholds -/

/-- **Subtraction-free symmetry lemma (`falls_iff_kept`)**: using only public `SelectionLevels`
identities (`levels`, `within_kept`, `among_kept`, `balance_add`, `balance_mul`, `spread_levels`,
`cancel_two`) and `Becoming.SelectionTerm.lt_iff_of_balance`, wide-scope share strictly falls
exactly when `s * concordWhole + m * q * concordAmong < K * concordWhole`. -/
theorem falls_iff_kept {α : Type} (gs : List (List α)) (w a : α → Nat) {B s q K m : Nat}
    (equal : ∀ g, g ∈ gs → g.length = m)
    (returns : ∀ g, g ∈ gs → ∀ p, p ∈ g → w p + K * a p = B + s * a p + q * total g a) :
    SelectionTerm.concord (SelectionLevels.whole gs) w a <
        SelectionTerm.discord (SelectionLevels.whole gs) w a ↔
      s * SelectionTerm.concord (SelectionLevels.whole gs) a a +
          m * q * SelectionLevels.concordAmong gs a a <
        K * SelectionTerm.concord (SelectionLevels.whole gs) a a := by
  have hwithin := SelectionLevels.balance_mul gs.length (SelectionLevels.within_kept returns)
  have hamong := SelectionLevels.among_kept equal returns
  have h := SelectionLevels.balance_add hwithin hamong
  have hbal :
      (gs.length * SelectionLevels.concordWithin gs w a + SelectionLevels.concordAmong gs w a) +
        K * SelectionTerm.concord (SelectionLevels.whole gs) a a =
      (gs.length * SelectionLevels.discordWithin gs w a + SelectionLevels.discordAmong gs w a) +
        (s * SelectionTerm.concord (SelectionLevels.whole gs) a a +
          m * q * SelectionLevels.concordAmong gs a a) := by
    rw [SelectionLevels.spread_levels gs a equal, Nat.left_distrib K, Nat.left_distrib s,
      mul_turn K gs.length, mul_turn s gs.length, Nat.add_assoc (gs.length * (s * _))]
    rw [add_mul_split s (m * q)] at h
    exact h
  have hlev := SelectionLevels.levels gs w a equal
  have hlev' :
      (gs.length * SelectionLevels.concordWithin gs w a + SelectionLevels.concordAmong gs w a) +
        SelectionTerm.discord (SelectionLevels.whole gs) w a =
      (gs.length * SelectionLevels.discordWithin gs w a + SelectionLevels.discordAmong gs w a) +
        SelectionTerm.concord (SelectionLevels.whole gs) w a := by
    rw [Nat.add_comm (gs.length * SelectionLevels.concordWithin gs w a +
          SelectionLevels.concordAmong gs w a),
      Nat.add_comm (gs.length * SelectionLevels.discordWithin gs w a +
          SelectionLevels.discordAmong gs w a)]
    exact hlev.symm
  exact Becoming.SelectionTerm.lt_iff_of_balance (SelectionLevels.cancel_two hlev' hbal)

/-- **Threshold Emergence & Persistence (`assorted_wide_scope_emerges`)**: above the assortment
threshold `K * concordWhole < s * concordWhole + m * q * concordAmong`, wide-scope share strictly
rises (`SelectionLevels.rises_iff_kept`), while in coupled multi-generation flows where narrow
lineages lose activity (`GroupEnding.Flow.lineages_raises`) and exhaust their narrow pool
(`ScopeDynamics.narrow_lineage_ends_together`), wide coalitions persist inside `[S_safe, hi]`
forever (`ScopeDynamics.wide_substrate_holds`). -/
theorem assorted_wide_scope_emerges {α F_n C_n K_n F_w C_w K_w X Y : Type}
    (gs : List (List α)) (w a : α → Nat) {B s q K m : Nat}
    (equal : ∀ g, g ∈ gs → g.length = m)
    (returns : ∀ g, g ∈ gs → ∀ p, p ∈ g → w p + K * a p = B + s * a p + q * total g a)
    (above : K * SelectionTerm.concord (SelectionLevels.whole gs) a a <
      s * SelectionTerm.concord (SelectionLevels.whole gs) a a +
        m * q * SelectionLevels.concordAmong gs a a)
    {L : Flow X X} {W : Web X X} (acting : L.Acting W) {G : SelectionTerm.Generations X}
    (descended : SelectionTerm.Flow.Descended L W G) {lgs : List (List X)}
    (listed : SelectionLevels.whole lgs = G.family 0)
    (exact : ∀ t, SelectionTerm.Exact (G.family t) (G.kids t) (G.amount t) (G.amount (t + 1)))
    {v : List X → Nat} (founded : ∀ g, g ∈ lgs → ∀ p, p ∈ g → G.amount 0 p = v g)
    {t : Nat}
    (inactive : ∀ g h, g ∈ lgs → h ∈ lgs → v h < v g →
      ∀ p, p ∈ SelectionLevels.lineage G h t → ¬ W.active t p)
    {g h : List X} (mg : g ∈ lgs) (mh : h ∈ lgs) (less : v h < v g)
    {p q' : X} (mp : p ∈ SelectionLevels.lineage G g t) (mq : q' ∈ SelectionLevels.lineage G h t)
    (leaves : 0 < G.offspringNumber t p)
    (sys : ScopeDynamics.MutualFateSystem F_n C_n K_n F_w C_w K_w Y) :
    SelectionTerm.discord (SelectionLevels.whole gs) w a <
        SelectionTerm.concord (SelectionLevels.whole gs) w a ∧
      G.Raises t ∧
      (∀ k y, ¬ y ∈ sys.narrowLin.G.family (sys.narrowLin.T + sys.narrowLin.n + k + 1)) ∧
      (∀ s', sys.wide.S_safe ≤ sys.wide.sub.level s' ∧ sys.wide.sub.level s' ≤ sys.wide.hi) :=
  ⟨(SelectionLevels.rises_iff_kept gs w a equal returns).mpr above,
   GroupEnding.Flow.lineages_raises acting descended listed exact founded inactive mg mh less mp mq leaves,
   (ScopeDynamics.narrow_lineage_ends_together sys.narrowLin).2,
   ScopeDynamics.wide_substrate_holds sys.wide⟩

/-- **Myopic-Trap Invasion Counter-Theorem (`unassorted_myopic_trap`)**: for the identical `(B, K, s, q, m)`
return equation, below the assortment threshold (`s * concordWhole + m * q * concordAmong < K * concordWhole`),
wide-scope share strictly falls (`concord < discord` via `falls_iff_kept`); and once narrow draws
dominate an isolated substrate (`NarrowCoalition`) or coupled lineage (`NarrowLineage`), the substrate
exhausts to `0` and all coupled lineages extinguish (`narrow_substrate_exhausts`,
`narrow_lineage_ends_together`). -/
theorem unassorted_myopic_trap {α F_n C_n K_n X : Type}
    (gs : List (List α)) (w a : α → Nat) {B s q K m : Nat}
    (equal : ∀ g, g ∈ gs → g.length = m)
    (returns : ∀ g, g ∈ gs → ∀ p, p ∈ g → w p + K * a p = B + s * a p + q * total g a)
    (below : s * SelectionTerm.concord (SelectionLevels.whole gs) a a +
      m * q * SelectionLevels.concordAmong gs a a <
      K * SelectionTerm.concord (SelectionLevels.whole gs) a a)
    (nc : ScopeDynamics.NarrowCoalition F_n C_n K_n)
    (nl : ScopeDynamics.NarrowLineage X nc.sub) :
    SelectionTerm.concord (SelectionLevels.whole gs) w a <
        SelectionTerm.discord (SelectionLevels.whole gs) w a ∧
      (∃ T_end, (∀ t, T_end ≤ t → nc.sub.level t = 0) ∧
        (∀ t, T_end ≤ t → ∀ k, ¬ nc.W.MacroAdmits nc.cap (nc.W.level t) t k)) ∧
      (∀ k y, ¬ y ∈ nl.G.family (nl.T + nl.n + k + 1)) :=
  ⟨(falls_iff_kept gs w a equal returns).mpr below,
   ScopeDynamics.narrow_substrate_exhausts nc,
   (ScopeDynamics.narrow_lineage_ends_together nl).2⟩

/-- **Substrate-Coupled Dynamic–Population Bridge (`modeSwitch_enables_assorted_persistence`)**:
given a run `run` of the `PolyComposition` dynamic `ScopeMode` controller starting from `x₀` inside
`ExploreMarginInv` that tracks shared substrate condition `c_sub` (`(run.state s).1 () ≤ W.level s c_sub`),
the controller keeps every step in `Viability.Kernel` and enforces `x_crit ≤ W.level s c_sub` for all `s`;
where substrate viability at `t` sustains positive offspring of wide lineage `p` (`reproduces_when_viable`)
while inactive narrow lineages (`v h < v g`) fail to act, `GroupEnding.Flow.lineages_raises`
yields `G.Raises t`. -/
theorem modeSwitch_enables_assorted_persistence
    (preDraw coopDraw maxLagN initLag envCap x_crit warnLevel x₀ : Nat)
    (coop_le_pre : coopDraw ≤ preDraw)
    (init_in : 0 < initLag ∧ initLag ≤ maxLagN)
    (propose : (p : Σ m, ScopeS m) → ScopeObs p.1 × Bool → ScopeDist p.1 → Σ m', ScopeS m')
    (G_sub : Nat → Nat) (G_rises : ∀ a b, a ≤ b → G_sub a ≤ G_sub b)
    (post_viable : x_crit ≤
      RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole (fun _ e => G_sub (e ()))
        (fun _ => coopDraw + envCap) (fun _ => x_crit) ())
    (warn_margin : x_crit + (maxLagN + 1) * (preDraw + envCap) ≤ warnLevel)
    (init_margin : x_crit + initLag * (preDraw + envCap) ≤ x₀)
    (run : Run
      (PolyComposition.polyClosedProcess
        (PolyComposition.anchoredSelfModComponent
          (scopeBase preDraw coopDraw maxLagN coop_le_pre)
          (scopeAdmitDec maxLagN) scopeFallback propose)
        scopeRoute
        (PolyComposition.anchoredSelfModContract
          (scopeBase preDraw coopDraw maxLagN coop_le_pre)
          (init := ⟨.narrowUnmonitored, initLag⟩) ⟨init_in⟩ (scopeAdmitDec maxLagN) scopeFallback
          (scopeAdmit_sound preDraw coopDraw maxLagN coop_le_pre) propose)
        (scopeObs warnLevel) scopeChannel (fun _ e => G_sub (e ()))
        (fun _ _ => envCap) (fun _ => True)))
    (h0 : run.state 0 = (fun _ => x₀, ⟨.narrowUnmonitored, initLag⟩))
    {X : Type} {L : Flow X X} {W : Web X X} (acting : L.Acting W) {G : SelectionTerm.Generations X}
    (descended : SelectionTerm.Flow.Descended L W G) {lgs : List (List X)}
    (listed : SelectionLevels.whole lgs = G.family 0)
    (exact : ∀ t, SelectionTerm.Exact (G.family t) (G.kids t) (G.amount t) (G.amount (t + 1)))
    {v : List X → Nat} (founded : ∀ g, g ∈ lgs → ∀ p, p ∈ g → G.amount 0 p = v g)
    {t : Nat}
    (inactive : ∀ g h, g ∈ lgs → h ∈ lgs → v h < v g →
      ∀ p, p ∈ SelectionLevels.lineage G h t → ¬ W.active t p)
    {g h : List X} (mg : g ∈ lgs) (mh : h ∈ lgs) (less : v h < v g)
    {p q' : X} (mp : p ∈ SelectionLevels.lineage G g t) (mq : q' ∈ SelectionLevels.lineage G h t)
    (c_sub : X) (substrate_tracks : ∀ s, (run.state s).1 () ≤ W.level s c_sub)
    (reproduces_when_viable : x_crit ≤ W.level t c_sub → 0 < G.offspringNumber t p) :
    Viability.Kernel
      (PolyComposition.polyClosedProcess
        (PolyComposition.anchoredSelfModComponent
          (scopeBase preDraw coopDraw maxLagN coop_le_pre)
          (scopeAdmitDec maxLagN) scopeFallback propose)
        scopeRoute
        (PolyComposition.anchoredSelfModContract
          (scopeBase preDraw coopDraw maxLagN coop_le_pre)
          (init := ⟨.narrowUnmonitored, initLag⟩) ⟨init_in⟩ (scopeAdmitDec maxLagN) scopeFallback
          (scopeAdmit_sound preDraw coopDraw maxLagN coop_le_pre) propose)
        (scopeObs warnLevel) scopeChannel (fun _ e => G_sub (e ()))
        (fun _ _ => envCap) (fun _ => True))
      (PolyComposition.polyClosedGuard
        (PolyComposition.anchoredSelfModComponent
          (scopeBase preDraw coopDraw maxLagN coop_le_pre)
          (scopeAdmitDec maxLagN) scopeFallback propose)
        (PolyComposition.anchoredSelfModContract
          (scopeBase preDraw coopDraw maxLagN coop_le_pre)
          (init := ⟨.narrowUnmonitored, initLag⟩) ⟨init_in⟩ (scopeAdmitDec maxLagN) scopeFallback
          (scopeAdmit_sound preDraw coopDraw maxLagN coop_le_pre) propose)
        (fun _ => x_crit))
      (fun _ => x₀, ⟨.narrowUnmonitored, initLag⟩) ∧
    (∀ s, x_crit ≤ W.level s c_sub) ∧
    G.Raises t := by
  have hKern :=
    timely_modeSwitch_viability_kernel preDraw coopDraw maxLagN initLag envCap x_crit warnLevel x₀
      coop_le_pre init_in propose G_sub G_rises post_viable warn_margin init_margin
  have hAbove : ∀ s, x_crit ≤ W.level s c_sub := fun s =>
    Nat.le_trans ((Viability.Kernel.run run (h0.symm ▸ hKern) s).1 ()) (substrate_tracks s)
  exact ⟨hKern, hAbove,
    GroupEnding.Flow.lineages_raises acting descended listed exact founded inactive mg mh less mp mq
      (reproduces_when_viable (hAbove t))⟩

/-! ### Concrete Threshold Separation Witness: `ScopeCoEvolutionWitness` -/

namespace ScopeCoEvolutionWitness

namespace AssortmentSplit

inductive SplitMember : Type where
  | w1
  | w2
  | n1
  | n2

def keepScope : SplitMember → Nat
  | .w1 => 1
  | .w2 => 1
  | .n1 => 0
  | .n2 => 0

def gsAssorted : List (List SplitMember) := [[.w1, .w2], [.n1, .n2]]
def gsMixed : List (List SplitMember) := [[.w1, .n1], [.w2, .n2]]

def wAssorted : SplitMember → Nat
  | .w1 => 3
  | .w2 => 3
  | .n1 => 1
  | .n2 => 1

def wMixed : SplitMember → Nat
  | .w1 => 1
  | .w2 => 1
  | .n1 => 3
  | .n2 => 3

theorem equal_assorted : ∀ g, g ∈ gsAssorted → g.length = 2
  | _, .head _ => rfl
  | _, .tail _ (.head _) => rfl
  | _, .tail _ (.tail _ no) => nomatch no

theorem equal_mixed : ∀ g, g ∈ gsMixed → g.length = 2
  | _, .head _ => rfl
  | _, .tail _ (.head _) => rfl
  | _, .tail _ (.tail _ no) => nomatch no

theorem returns_assorted :
    ∀ g, g ∈ gsAssorted → ∀ p, p ∈ g →
      wAssorted p + 3 * keepScope p = 1 + 1 * keepScope p + 2 * total g keepScope
  | _, .head _, p, mp => match p, mp with
    | .w1, .head _ => rfl
    | .w2, .tail _ (.head _) => rfl
  | _, .tail _ (.head _), p, mp => match p, mp with
    | .n1, .head _ => rfl
    | .n2, .tail _ (.head _) => rfl

theorem returns_mixed :
    ∀ g, g ∈ gsMixed → ∀ p, p ∈ g →
      wMixed p + 3 * keepScope p = 1 + 1 * keepScope p + 2 * total g keepScope
  | _, .head _, p, mp => match p, mp with
    | .w1, .head _ => rfl
    | .n1, .tail _ (.head _) => rfl
  | _, .tail _ (.head _), p, mp => match p, mp with
    | .w2, .head _ => rfl
    | .n2, .tail _ (.head _) => rfl

theorem witness_holds :
    SelectionTerm.concord (SelectionLevels.whole gsAssorted) wAssorted keepScope = 8 ∧
    SelectionTerm.discord (SelectionLevels.whole gsAssorted) wAssorted keepScope = 0 ∧
    SelectionTerm.concord (SelectionLevels.whole gsMixed) wMixed keepScope = 0 ∧
    SelectionTerm.discord (SelectionLevels.whole gsMixed) wMixed keepScope = 8 ∧
    SelectionTerm.discord (SelectionLevels.whole gsAssorted) wAssorted keepScope <
      SelectionTerm.concord (SelectionLevels.whole gsAssorted) wAssorted keepScope ∧
    SelectionTerm.concord (SelectionLevels.whole gsMixed) wMixed keepScope <
      SelectionTerm.discord (SelectionLevels.whole gsMixed) wMixed keepScope := by
  refine ⟨rfl, rfl, rfl, rfl, ?_, ?_⟩
  · exact (SelectionLevels.rises_iff_kept gsAssorted wAssorted keepScope equal_assorted returns_assorted).mpr
      (by decide)
  · exact (falls_iff_kept gsMixed wMixed keepScope equal_mixed returns_mixed).mpr (by decide)

end AssortmentSplit

namespace AssortmentLineage

def linKids : Nat → Nat → List Nat
  | _, 0 => []
  | _, n + 1 => [n + 2]

def linAmt : Nat → Nat → Nat
  | _, 0 => 0
  | _, _ + 1 => 1

def linGen : SelectionTerm.Generations Nat :=
  ⟨[1, 0], linKids, linAmt⟩

def linLgs : List (List Nat) := [[1], [0]]

def linVal : List Nat → Nat
  | [] => 0
  | x :: _ => x

def linWeb : Web Nat Nat where
  level t c := match Nat.beq c (t + 1) with
    | true => 1
    | false => 0
  active t f := f = t + 1
  requires _ _ _ := False
  need _ _ _ := 0
  draws _ _ _ := False

def linFlow : Flow Nat Nat where
  present t := [t + 1]
  take _ _ _ := 0
  give t f c := match Nat.beq f (t + 1) && Nat.beq c (t + 2) with
    | true => 1
    | false => 0

theorem linFamily_succ : ∀ t, linGen.family (t + 1) = [t + 2]
  | 0 => rfl
  | t + 1 => by
    show (linGen.family (t + 1)).flatMap (linKids (t + 1)) = [t + 3]
    rw [linFamily_succ t]
    rfl

theorem linActing : linFlow.Acting linWeb := fun t f c _ hpos => by
  show f = t + 1
  dsimp only [linFlow] at hpos
  cases hfb : Nat.beq f (t + 1) with
  | true => exact CoreHelpers.natBeq_true_iff.mp hfb
  | false =>
    rw [hfb] at hpos
    exact absurd hpos (Nat.lt_irrefl 0)

theorem linDescended : SelectionTerm.Flow.Descended linFlow linWeb linGen := by
  intro t p k mp mk
  cases t with
  | zero =>
    cases mp with
    | head =>
      cases mk with
      | head =>
        refine ⟨.head _, Nat.zero_lt_one, ?_, Nat.zero_lt_one⟩
        exact Nat.lt_irrefl 0
      | tail _ no => nomatch no
    | tail _ mp2 =>
      cases mp2 with
      | head => nomatch mk
      | tail _ no => nomatch no
  | succ s =>
    rw [linFamily_succ s] at mp
    cases mp with
    | head =>
      cases mk with
      | head =>
        have hbn : Nat.beq (s + 3) (s + 2) = false :=
          ListTests.false_iff_not.mpr fun hb =>
            Nat.succ_ne_self (s + 2) (CoreHelpers.natBeq_true_iff.mp hb)
        refine ⟨.head _, ?_, ?_, ?_⟩
        · show 0 < match Nat.beq (s + 2) (s + 2) && Nat.beq (s + 3) (s + 3) with
            | true => 1
            | false => 0
          rw [CoreHelpers.natBeq_true_iff.mpr rfl, CoreHelpers.natBeq_true_iff.mpr rfl]
          exact Nat.zero_lt_one
        · show ¬ 0 < match Nat.beq (s + 3) (s + 2) with
            | true => 1
            | false => 0
          rw [hbn]
          exact Nat.lt_irrefl 0
        · show 0 < match Nat.beq (s + 3) (s + 3) with
            | true => 1
            | false => 0
          rw [CoreHelpers.natBeq_true_iff.mpr rfl]
          exact Nat.zero_lt_one
      | tail _ no => nomatch no
    | tail _ no => nomatch no

theorem linExact : ∀ t,
    SelectionTerm.Exact (linGen.family t) (linKids t) (linAmt t) (linAmt (t + 1))
  | 0 => fun p mp k mk => by
    cases mp with
    | head =>
      cases mk with
      | head => rfl
      | tail _ no => nomatch no
    | tail _ mp2 =>
      cases mp2 with
      | head => nomatch mk
      | tail _ no => nomatch no
  | s + 1 => fun p mp k mk => by
    rw [linFamily_succ s] at mp
    cases mp with
    | head =>
      cases mk with
      | head => rfl
      | tail _ no => nomatch no
    | tail _ no => nomatch no

theorem linFounded : ∀ g, g ∈ linLgs → ∀ p, p ∈ g → linGen.amount 0 p = linVal g
  | _, .head _, p, mp => by
    cases mp with
    | head => rfl
    | tail _ no => nomatch no
  | _, .tail _ (.head _), p, mp => by
    cases mp with
    | head => rfl
    | tail _ no => nomatch no
  | _, .tail _ (.tail _ no), _, _ => nomatch no

theorem linInactive : ∀ g h, g ∈ linLgs → h ∈ linLgs → linVal h < linVal g →
    ∀ p, p ∈ SelectionLevels.lineage linGen h 0 → ¬ linWeb.active 0 p
  | _, _, .head _, .head _, hlt => absurd hlt (Nat.lt_irrefl 1)
  | _, _, .tail _ (.head _), .head _, hlt => absurd hlt (by decide)
  | _, _, .tail _ (.head _), .tail _ (.head _), hlt => absurd hlt (Nat.lt_irrefl 0)
  | _, _, .head _, .tail _ (.head _), _ => fun p mp => by
    cases mp with
    | head => exact fun h => Nat.noConfusion h
    | tail _ no => nomatch no
  | _, _, _, .tail _ (.tail _ no), _ => nomatch no
  | _, _, .tail _ (.tail _ no), _, _ => nomatch no

theorem witness_holds :
    (SelectionTerm.discord (SelectionLevels.whole AssortmentSplit.gsAssorted)
        AssortmentSplit.wAssorted AssortmentSplit.keepScope <
      SelectionTerm.concord (SelectionLevels.whole AssortmentSplit.gsAssorted)
        AssortmentSplit.wAssorted AssortmentSplit.keepScope ∧
     linGen.Raises 0 ∧
     (∀ k y, ¬ y ∈ ScopeDynamics.MutualFateWitness.system.narrowLin.G.family
       (ScopeDynamics.MutualFateWitness.system.narrowLin.T +
        ScopeDynamics.MutualFateWitness.system.narrowLin.n + k + 1)) ∧
     (∀ s', ScopeDynamics.MutualFateWitness.system.wide.S_safe ≤
        ScopeDynamics.MutualFateWitness.system.wide.sub.level s' ∧
        ScopeDynamics.MutualFateWitness.system.wide.sub.level s' ≤
        ScopeDynamics.MutualFateWitness.system.wide.hi)) ∧
    (SelectionTerm.concord (SelectionLevels.whole AssortmentSplit.gsMixed)
        AssortmentSplit.wMixed AssortmentSplit.keepScope <
      SelectionTerm.discord (SelectionLevels.whole AssortmentSplit.gsMixed)
        AssortmentSplit.wMixed AssortmentSplit.keepScope ∧
     (∃ T_end, (∀ t, T_end ≤ t → ScopeDynamics.MutualFateWitness.system.narrow.sub.level t = 0) ∧
       (∀ t, T_end ≤ t → ∀ k, ¬ ScopeDynamics.MutualFateWitness.system.narrow.W.MacroAdmits
         ScopeDynamics.MutualFateWitness.system.narrow.cap
         (ScopeDynamics.MutualFateWitness.system.narrow.W.level t) t k)) ∧
     (∀ k y, ¬ y ∈ ScopeDynamics.MutualFateWitness.system.narrowLin.G.family
       (ScopeDynamics.MutualFateWitness.system.narrowLin.T +
        ScopeDynamics.MutualFateWitness.system.narrowLin.n + k + 1))) :=
  ⟨assorted_wide_scope_emerges AssortmentSplit.gsAssorted AssortmentSplit.wAssorted
     AssortmentSplit.keepScope AssortmentSplit.equal_assorted AssortmentSplit.returns_assorted
     (by decide) linActing linDescended rfl linExact linFounded linInactive
     (.head _) (.tail _ (.head _)) (by decide) (.head _) (.head _) (by decide)
     ScopeDynamics.MutualFateWitness.system,
   unassorted_myopic_trap AssortmentSplit.gsMixed AssortmentSplit.wMixed
     AssortmentSplit.keepScope AssortmentSplit.equal_mixed AssortmentSplit.returns_mixed
     (by decide) ScopeDynamics.MutualFateWitness.system.narrow
     ScopeDynamics.MutualFateWitness.system.narrowLin⟩

end AssortmentLineage

namespace LagSplit

def proposeCountdown (p : Σ m, ScopeS m) (oa : ScopeObs p.1 × Bool) (_ : ScopeDist p.1) :
    Σ m', ScopeS m' :=
  match oa.2 with
  | false => p
  | true => match p with
    | ⟨.narrowUnmonitored, s⟩ => match s with
      | 0 => ⟨.narrowUnmonitored, 0⟩
      | 1 => ⟨.wideReciprocal, 0⟩
      | n + 2 => ⟨.narrowUnmonitored, n + 1⟩
    | ⟨.wideReciprocal, s⟩ => ⟨.wideReciprocal, s⟩

def proposeAlwaysNarrow (p : Σ m, ScopeS m) (_ : ScopeObs p.1 × Bool) (_ : ScopeDist p.1) :
    Σ m', ScopeS m' :=
  ⟨.narrowUnmonitored, 3⟩

def timelyOrbit : Nat → (Unit → Nat) × Σ m, ScopeS m :=
  Law.orbit
    (fun st => PolyComposition.polyClosedStep
      (PolyComposition.anchoredSelfModComponent
        (scopeBase 3 1 1 (by decide))
        (scopeAdmitDec 1) scopeFallback proposeAlwaysNarrow)
      scopeRoute (scopeObs 16) scopeChannel (fun _ e => ScopeDynamics.gEx (e ()))
      (fun _ _ => 1) st ((), ()))
    (fun _ => 13, ⟨.narrowUnmonitored, 1⟩)

def timelyRun :
    Run
      (PolyComposition.polyClosedProcess
        (PolyComposition.anchoredSelfModComponent
          (scopeBase 3 1 1 (by decide))
          (scopeAdmitDec 1) scopeFallback proposeAlwaysNarrow)
        scopeRoute
        (PolyComposition.anchoredSelfModContract
          (scopeBase 3 1 1 (by decide))
          (init := ⟨.narrowUnmonitored, 1⟩) ⟨⟨by decide, Nat.le_refl 1⟩⟩
          (scopeAdmitDec 1) scopeFallback
          (scopeAdmit_sound 3 1 1 (by decide)) proposeAlwaysNarrow)
        (scopeObs 16) scopeChannel (fun _ e => ScopeDynamics.gEx (e ()))
        (fun _ _ => 1) (fun _ => True)) where
  state := timelyOrbit
  act n := ((), ⟨(timelyOrbit n).2.1, ()⟩)
  step n := by
    refine ⟨rfl, trivial, fun _ => trivial, ?_⟩
    cases (timelyOrbit n).2.1 <;> rfl

theorem timely_kernel :
    Viability.Kernel
      (PolyComposition.polyClosedProcess
        (PolyComposition.anchoredSelfModComponent
          (scopeBase 3 1 1 (by decide))
          (scopeAdmitDec 1) scopeFallback proposeAlwaysNarrow)
        scopeRoute
        (PolyComposition.anchoredSelfModContract
          (scopeBase 3 1 1 (by decide))
          (init := ⟨.narrowUnmonitored, 1⟩) ⟨⟨by decide, Nat.le_refl 1⟩⟩
          (scopeAdmitDec 1) scopeFallback
          (scopeAdmit_sound 3 1 1 (by decide)) proposeAlwaysNarrow)
        (scopeObs 16) scopeChannel (fun _ e => ScopeDynamics.gEx (e ()))
        (fun _ _ => 1) (fun _ => True))
      (PolyComposition.polyClosedGuard
        (PolyComposition.anchoredSelfModComponent
          (scopeBase 3 1 1 (by decide))
          (scopeAdmitDec 1) scopeFallback proposeAlwaysNarrow)
        (PolyComposition.anchoredSelfModContract
          (scopeBase 3 1 1 (by decide))
          (init := ⟨.narrowUnmonitored, 1⟩) ⟨⟨by decide, Nat.le_refl 1⟩⟩
          (scopeAdmitDec 1) scopeFallback
          (scopeAdmit_sound 3 1 1 (by decide)) proposeAlwaysNarrow)
        (fun _ => 8))
      (fun _ => 13, ⟨.narrowUnmonitored, 1⟩) :=
  timely_modeSwitch_viability_kernel 3 1 1 1 1 8 16 13
    (by decide) ⟨by decide, Nat.le_refl 1⟩ proposeAlwaysNarrow
    ScopeDynamics.gEx ScopeDynamics.gEx_mono
    (by decide) (by decide) (by decide)

inductive CoupledNode : Type where
  | sub
  | narrow
  | wide (gen : Nat)

def gatedGive (lvl : Nat → Nat) (x_crit t : Nat) (f c : CoupledNode) : Nat :=
  match f with
  | .wide k =>
      match c with
      | .wide k' =>
          match Nat.beq k t && Nat.beq k' (t + 1) && Nat.ble x_crit (lvl t) with
          | true => 1
          | false => 0
      | .sub => 0
      | .narrow => 0
  | .sub => 0
  | .narrow => 0

def gatedWeb (lvl : Nat → Nat) (x_crit : Nat) : Web CoupledNode CoupledNode where
  level t c :=
    match c with
    | .sub => lvl t
    | .narrow => 0
    | .wide k =>
        match Nat.beq k t with
        | true => 1
        | false => 0
  active t f :=
    match f with
    | .wide k => k = t ∧ x_crit ≤ lvl t
    | .sub => False
    | .narrow => False
  requires _ f c :=
    match f with
    | .wide _ =>
        match c with
        | .sub => True
        | .narrow => False
        | .wide _ => False
    | .sub => False
    | .narrow => False
  need _ f c :=
    match f with
    | .wide _ =>
        match c with
        | .sub => x_crit
        | .narrow => 0
        | .wide _ => 0
    | .sub => 0
    | .narrow => 0
  draws _ _ _ := False

def gatedFlow (lvl : Nat → Nat) (x_crit : Nat) : Flow CoupledNode CoupledNode where
  present t := [.wide t]
  take _ _ _ := 0
  give := gatedGive lvl x_crit

def gatedGen (lvl : Nat → Nat) (x_crit : Nat) : SelectionTerm.Generations CoupledNode where
  first := [.wide 0, .narrow]
  kids t u :=
    match u with
    | .wide k =>
        match Nat.beq k t && Nat.ble x_crit (lvl t) with
        | true => [.wide (t + 1)]
        | false => []
    | .sub => []
    | .narrow => []
  amount _ u :=
    match u with
    | .wide _ => 1
    | .sub => 0
    | .narrow => 0

def coupledLgs : List (List CoupledNode) := [[.wide 0], [.narrow]]

def coupledVal (xs : List CoupledNode) : Nat :=
  match xs with
  | [] => 0
  | x :: _ =>
      match x with
      | .wide _ => 1
      | .sub => 0
      | .narrow => 0

theorem gatedWeb_dependent (lvl : Nat → Nat) (x_crit : Nat) :
    (gatedWeb lvl x_crit).Dependent := by
  intro t f hact c hreq
  cases f with
  | sub => exact False.elim hact
  | narrow => exact False.elim hact
  | wide k =>
      cases c with
      | sub => exact hact.2
      | narrow => exact False.elim hreq
      | wide k' => exact False.elim hreq

theorem gatedFlow_acting (lvl : Nat → Nat) (x_crit : Nat) :
    (gatedFlow lvl x_crit).Acting (gatedWeb lvl x_crit) := by
  intro t f c hmem hpos
  have hf : f = .wide t := by
    cases hmem with
    | head => rfl
    | tail _ no => nomatch no
  subst hf
  cases c with
  | sub => exact absurd hpos (Nat.lt_irrefl 0)
  | narrow => exact absurd hpos (Nat.lt_irrefl 0)
  | wide k' =>
      show t = t ∧ x_crit ≤ lvl t
      dsimp only [gatedFlow, gatedGive] at hpos
      cases hb : Nat.beq t t && Nat.beq k' (t + 1) && Nat.ble x_crit (lvl t) with
      | false =>
          rw [hb] at hpos
          exact absurd hpos (Nat.lt_irrefl 0)
      | true =>
          exact ⟨rfl, Nat.le_of_ble_eq_true (ListTests.and_right hb)⟩

theorem gatedGen_descended (lvl : Nat → Nat) (x_crit : Nat) :
    SelectionTerm.Flow.Descended (gatedFlow lvl x_crit) (gatedWeb lvl x_crit) (gatedGen lvl x_crit) := by
  intro t p k _ hk
  cases p with
  | sub => nomatch hk
  | narrow => nomatch hk
  | wide m =>
      dsimp only [gatedGen] at hk
      cases hb : Nat.beq m t && Nat.ble x_crit (lvl t) with
      | false =>
          rw [hb] at hk
          nomatch hk
      | true =>
          rw [hb] at hk
          have hm : m = t := CoreHelpers.natBeq_true_iff.mp (ListTests.and_left hb)
          have hSub : x_crit ≤ lvl t := Nat.le_of_ble_eq_true (ListTests.and_right hb)
          have hk' : k = .wide (t + 1) := by
            cases hk with
            | head => rfl
            | tail _ no => nomatch no
          subst m
          subst k
          have hGivePos : 0 < gatedGive lvl x_crit t (.wide t) (.wide (t + 1)) := by
            show 0 < match Nat.beq t t && Nat.beq (t + 1) (t + 1) && Nat.ble x_crit (lvl t) with
              | true => 1
              | false => 0
            rw [CoreHelpers.natBeq_true_iff.mpr rfl, CoreHelpers.natBeq_true_iff.mpr rfl,
              Nat.ble_eq_true_of_le hSub]
            exact Nat.zero_lt_one
          have hZeroBefore : ¬ 0 < (gatedWeb lvl x_crit).level t (.wide (t + 1)) := by
            have hbn : Nat.beq (t + 1) t = false :=
              ListTests.false_iff_not.mpr fun hbe =>
                Nat.succ_ne_self t (CoreHelpers.natBeq_true_iff.mp hbe)
            show ¬ 0 < match Nat.beq (t + 1) t with | true => 1 | false => 0
            rw [hbn]
            exact Nat.lt_irrefl 0
          have hPosAfter : 0 < (gatedWeb lvl x_crit).level (t + 1) (.wide (t + 1)) := by
            show 0 < match Nat.beq (t + 1) (t + 1) with | true => 1 | false => 0
            rw [CoreHelpers.natBeq_true_iff.mpr rfl]
            exact Nat.zero_lt_one
          exact ⟨.head _, hGivePos, hZeroBefore, hPosAfter⟩

theorem gatedGen_exact (lvl : Nat → Nat) (x_crit : Nat) : ∀ t,
    SelectionTerm.Exact ((gatedGen lvl x_crit).family t) ((gatedGen lvl x_crit).kids t)
      ((gatedGen lvl x_crit).amount t) ((gatedGen lvl x_crit).amount (t + 1)) := by
  intro t p _ k hk
  cases p with
  | sub => nomatch hk
  | narrow => nomatch hk
  | wide m =>
      dsimp only [gatedGen] at hk
      cases hb : Nat.beq m t && Nat.ble x_crit (lvl t) with
      | false =>
          rw [hb] at hk
          nomatch hk
      | true =>
          rw [hb] at hk
          cases hk with
          | head => rfl
          | tail _ no => nomatch no

theorem gatedGen_founded (lvl : Nat → Nat) (x_crit : Nat) :
    ∀ g, g ∈ coupledLgs → ∀ p, p ∈ g → (gatedGen lvl x_crit).amount 0 p = coupledVal g
  | _, .head _, p, mp => by
      cases mp with
      | head => rfl
      | tail _ no => nomatch no
  | _, .tail _ (.head _), p, mp => by
      cases mp with
      | head => rfl
      | tail _ no => nomatch no
  | _, .tail _ (.tail _ no), _, _ => nomatch no

theorem gatedGen_inactive (lvl : Nat → Nat) (x_crit : Nat) :
    ∀ g h, g ∈ coupledLgs → h ∈ coupledLgs → coupledVal h < coupledVal g →
      ∀ p, p ∈ SelectionLevels.lineage (gatedGen lvl x_crit) h 0 →
        ¬ (gatedWeb lvl x_crit).active 0 p
  | _, _, .head _, .head _, hlt => absurd hlt (Nat.lt_irrefl 1)
  | _, _, .tail _ (.head _), .head _, hlt => absurd hlt (by decide)
  | _, _, .tail _ (.head _), .tail _ (.head _), hlt => absurd hlt (Nat.lt_irrefl 0)
  | _, _, .head _, .tail _ (.head _), _ => fun p mp => by
      cases mp with
      | head => exact fun h => h
      | tail _ no => nomatch no
  | _, _, _, .tail _ (.tail _ no), _ => nomatch no
  | _, _, .tail _ (.tail _ no), _, _ => nomatch no

theorem gatedGen_family_succ_eq (lvl : Nat → Nat) (x_crit : Nat) :
    ∀ t p, p ∈ (gatedGen lvl x_crit).family (t + 1) → p = .wide (t + 1) := by
  intro t p hp
  obtain ⟨q, _, hq⟩ := ListTests.mem_flatMap_iff.mp hp
  cases q with
  | sub => nomatch hq
  | narrow => nomatch hq
  | wide m =>
      dsimp only [gatedGen] at hq
      cases hb : Nat.beq m t && Nat.ble x_crit (lvl t) with
      | false =>
          rw [hb] at hq
          nomatch hq
      | true =>
          rw [hb] at hq
          cases hq with
          | head => rfl
          | tail _ no => nomatch no

theorem gatedGen_family_empty_mono (lvl : Nat → Nat) (x_crit : Nat) {t : Nat}
    (hempty : (gatedGen lvl x_crit).family t = []) :
    ∀ k, (gatedGen lvl x_crit).family (t + k) = []
  | 0 => hempty
  | k + 1 => by
      change ((gatedGen lvl x_crit).family (t + k)).flatMap ((gatedGen lvl x_crit).kids (t + k)) = []
      rw [gatedGen_family_empty_mono lvl x_crit hempty k]
      rfl

theorem timely_modeSwitch_raises_lineage :
    Viability.Kernel
      (PolyComposition.polyClosedProcess
        (PolyComposition.anchoredSelfModComponent
          (scopeBase 3 1 1 (by decide))
          (scopeAdmitDec 1) scopeFallback proposeAlwaysNarrow)
        scopeRoute
        (PolyComposition.anchoredSelfModContract
          (scopeBase 3 1 1 (by decide))
          (init := ⟨.narrowUnmonitored, 1⟩) ⟨⟨by decide, Nat.le_refl 1⟩⟩
          (scopeAdmitDec 1) scopeFallback
          (scopeAdmit_sound 3 1 1 (by decide)) proposeAlwaysNarrow)
        (scopeObs 16) scopeChannel (fun _ e => ScopeDynamics.gEx (e ()))
        (fun _ _ => 1) (fun _ => True))
      (PolyComposition.polyClosedGuard
        (PolyComposition.anchoredSelfModComponent
          (scopeBase 3 1 1 (by decide))
          (scopeAdmitDec 1) scopeFallback proposeAlwaysNarrow)
        (PolyComposition.anchoredSelfModContract
          (scopeBase 3 1 1 (by decide))
          (init := ⟨.narrowUnmonitored, 1⟩) ⟨⟨by decide, Nat.le_refl 1⟩⟩
          (scopeAdmitDec 1) scopeFallback
          (scopeAdmit_sound 3 1 1 (by decide)) proposeAlwaysNarrow)
        (fun _ => 8))
      (fun _ => 13, ⟨.narrowUnmonitored, 1⟩) ∧
    (∀ s, 8 ≤ (gatedWeb (fun t => (timelyRun.state t).1 ()) 8).level s .sub) ∧
    (gatedGen (fun t => (timelyRun.state t).1 ()) 8).Raises 0 :=
  modeSwitch_enables_assorted_persistence 3 1 1 1 1 8 16 13
    (by decide) ⟨by decide, Nat.le_refl 1⟩ proposeAlwaysNarrow
    ScopeDynamics.gEx ScopeDynamics.gEx_mono
    (by decide) (by decide) (by decide)
    timelyRun rfl
    (gatedFlow_acting (fun t => (timelyRun.state t).1 ()) 8)
    (gatedGen_descended (fun t => (timelyRun.state t).1 ()) 8)
    rfl (gatedGen_exact (fun t => (timelyRun.state t).1 ()) 8)
    (gatedGen_founded (fun t => (timelyRun.state t).1 ()) 8)
    (gatedGen_inactive (fun t => (timelyRun.state t).1 ()) 8)
    (.head _) (.tail _ (.head _)) (by decide) (.head _) (.head _)
    .sub (fun _ => Nat.le_refl _)
    (fun h => by
      dsimp only [SelectionTerm.Generations.offspringNumber, gatedGen, gatedWeb] at h ⊢
      rw [Nat.ble_eq_true_of_le h]
      exact Nat.zero_lt_one)

theorem timely_gatedGen_persists :
    ∀ t, CoupledNode.wide t ∈ (gatedGen (fun s => (timelyRun.state s).1 ()) 8).family t
  | 0 => .head _
  | t + 1 => by
      have ih := timely_gatedGen_persists t
      have hViable : 8 ≤ (timelyRun.state t).1 () :=
        (Viability.Kernel.run timelyRun timely_kernel t).1 ()
      apply ListTests.mem_flatMap_iff.mpr
      refine ⟨.wide t, ih, ?_⟩
      show CoupledNode.wide (t + 1) ∈
        match Nat.beq t t && Nat.ble 8 ((timelyRun.state t).1 ()) with
        | true => [CoupledNode.wide (t + 1)]
        | false => []
      rw [CoreHelpers.natBeq_true_iff.mpr rfl, Nat.ble_eq_true_of_le hViable]
      exact .head _

theorem timely_state_succ :
    ∀ k, (timelyRun.state (k + 1)).1 () = 11 ∧ (timelyRun.state (k + 1)).2 = ⟨.wideReciprocal, 0⟩
  | 0 => ⟨rfl, rfl⟩
  | k + 1 => by
    obtain ⟨hx, hm⟩ := timely_state_succ k
    show (timelyOrbit (k + 1 + 1)).1 () = 11 ∧ (timelyOrbit (k + 1 + 1)).2 = ⟨.wideReciprocal, 0⟩
    change (PolyComposition.polyClosedStep
      (PolyComposition.anchoredSelfModComponent
        (scopeBase 3 1 1 (by decide))
        (scopeAdmitDec 1) scopeFallback proposeAlwaysNarrow)
      scopeRoute (scopeObs 16) scopeChannel (fun _ e => ScopeDynamics.gEx (e ()))
      (fun _ _ => 1) (timelyOrbit (k + 1)) ((), ())).1 () = 11 ∧
      (PolyComposition.polyClosedStep
        (PolyComposition.anchoredSelfModComponent
          (scopeBase 3 1 1 (by decide))
          (scopeAdmitDec 1) scopeFallback proposeAlwaysNarrow)
        scopeRoute (scopeObs 16) scopeChannel (fun _ e => ScopeDynamics.gEx (e ()))
        (fun _ _ => 1) (timelyOrbit (k + 1)) ((), ())).2 = ⟨.wideReciprocal, 0⟩
    have hx' : (timelyOrbit (k + 1)).1 () = 11 := hx
    have hm' : (timelyOrbit (k + 1)).2 = ⟨.wideReciprocal, 0⟩ := hm
    unfold PolyComposition.polyClosedStep
    dsimp only [PolyComposition.anchoredSelfModComponent, PolyComposition.polySiteDraw,
      scopeRoute, PolyComposition.sumPortDraws, scopeBase, scopeObs, scopeChannel,
      proposeAlwaysNarrow, scopeAdmitDec, scopeFallback,
      RegimeMargin.Coupled.Indexed.step, RegimeMargin.Drawn.whole, RegimeMargin.Coupled.Indexed.left]
    rw [hm', hx']
    exact ⟨rfl, rfl⟩

/-- Anchored delayed `L = 3` (`init = ⟨.narrowUnmonitored, 3⟩`) step trajectory:
`[13, 11, 9, 6, 5, 4, 2, 0, 0, ...]`. -/
def delayedOrbit : Nat → (Unit → Nat) × Σ m, ScopeS m
  | 0 => (fun _ => 13, ⟨.narrowUnmonitored, 3⟩)
  | t + 1 => PolyComposition.polyClosedStep
      (PolyComposition.anchoredSelfModComponent
        (scopeBase 3 1 3 (by decide))
        (scopeAdmitDec 3) scopeFallback proposeCountdown)
      scopeRoute (scopeObs 16) scopeChannel (fun _ e => ScopeDynamics.gEx (e ()))
      (fun _ _ => 1) (delayedOrbit t) ((), ())

theorem delayed_step7_plus : ∀ k, (delayedOrbit (7 + k)).1 () = 0 ∧ (delayedOrbit (7 + k)).2 = ⟨.wideReciprocal, 0⟩
  | 0 => ⟨rfl, rfl⟩
  | k + 1 => by
    obtain ⟨hx, hm⟩ := delayed_step7_plus k
    change (PolyComposition.polyClosedStep
      (PolyComposition.anchoredSelfModComponent
        (scopeBase 3 1 3 (by decide))
        (scopeAdmitDec 3) scopeFallback proposeCountdown)
      scopeRoute (scopeObs 16) scopeChannel (fun _ e => ScopeDynamics.gEx (e ()))
      (fun _ _ => 1) (delayedOrbit (7 + k)) ((), ())).1 () = 0 ∧
      (PolyComposition.polyClosedStep
        (PolyComposition.anchoredSelfModComponent
          (scopeBase 3 1 3 (by decide))
          (scopeAdmitDec 3) scopeFallback proposeCountdown)
        scopeRoute (scopeObs 16) scopeChannel (fun _ e => ScopeDynamics.gEx (e ()))
        (fun _ _ => 1) (delayedOrbit (7 + k)) ((), ())).2 =
        ⟨.wideReciprocal, 0⟩
    unfold PolyComposition.polyClosedStep
    dsimp only [PolyComposition.anchoredSelfModComponent, PolyComposition.polySiteDraw,
      scopeRoute, PolyComposition.sumPortDraws, scopeBase, scopeObs, scopeChannel,
      proposeCountdown, scopeAdmitDec, scopeFallback,
      RegimeMargin.Coupled.Indexed.step, RegimeMargin.Drawn.whole, RegimeMargin.Coupled.Indexed.left]
    rw [hm, hx]
    exact ⟨rfl, rfl⟩

/-- Unanchored always-narrow run (`draw = 4` every step): `[13, 11, 9, 6, 2, 0, 0, ...]`. -/
def unswitchedNarrowLevel : Nat → Nat
  | 0 => 13
  | t + 1 => RegimeMargin.step ScopeDynamics.gEx 4 (unswitchedNarrowLevel t)

theorem unswitched_step5_plus : ∀ k, unswitchedNarrowLevel (5 + k) = 0
  | 0 => rfl
  | k + 1 => by
    show RegimeMargin.step ScopeDynamics.gEx 4 (unswitchedNarrowLevel (5 + k)) = 0
    rw [unswitched_step5_plus k]
    rfl

theorem gatedGen_family4_empty_of_lt8 (lvl : Nat → Nat) (hlt : lvl 3 < 8) :
    (gatedGen lvl 8).family 4 = [] := by
  suffices ∀ (xs : List CoupledNode), (∀ u, u ∈ xs → u = CoupledNode.wide 3) →
      xs.flatMap ((gatedGen lvl 8).kids 3) = [] by
    exact this ((gatedGen lvl 8).family 3) fun u hu => gatedGen_family_succ_eq lvl 8 2 u hu
  intro xs hxs
  induction xs with
  | nil => rfl
  | cons x rest ih =>
      have hx : x = CoupledNode.wide 3 := hxs x (.head _)
      have hKids : (gatedGen lvl 8).kids 3 x = [] := by
        rw [hx]
        show (match Nat.beq 3 3 && Nat.ble 8 (lvl 3) with
          | true => [CoupledNode.wide 4]
          | false => []) = []
        have hbf : Nat.ble 8 (lvl 3) = false :=
          ListTests.false_iff_not.mpr fun hb =>
            Nat.lt_irrefl (lvl 3) (Nat.lt_of_lt_of_le hlt (Nat.le_of_ble_eq_true hb))
        rw [CoreHelpers.natBeq_true_iff.mpr rfl, hbf]
        rfl
      show (gatedGen lvl 8).kids 3 x ++ rest.flatMap ((gatedGen lvl 8).kids 3) = []
      rw [hKids, ih (fun u hu => hxs u (.tail _ hu))]
      rfl

theorem delayed_gatedGen_extinguishes :
    ∀ k y, ¬ y ∈ (gatedGen (fun s => (delayedOrbit s).1 ()) 8).family (4 + k) := by
  have hEmpty : (gatedGen (fun s => (delayedOrbit s).1 ()) 8).family 4 = [] :=
    gatedGen_family4_empty_of_lt8 (fun s => (delayedOrbit s).1 ()) (by decide)
  intro k y hy
  rw [gatedGen_family_empty_mono (fun s => (delayedOrbit s).1 ()) 8 hEmpty k] at hy
  nomatch hy

theorem unswitched_gatedGen_extinguishes :
    ∀ k y, ¬ y ∈ (gatedGen unswitchedNarrowLevel 8).family (4 + k) := by
  have hEmpty : (gatedGen unswitchedNarrowLevel 8).family 4 = [] :=
    gatedGen_family4_empty_of_lt8 unswitchedNarrowLevel (by decide)
  intro k y hy
  rw [gatedGen_family_empty_mono unswitchedNarrowLevel 8 hEmpty k] at hy
  nomatch hy

theorem witness_holds :
    ((timelyRun.state 0).1 () = 13 ∧
     (∀ t, 1 ≤ t → (timelyRun.state t).1 () = 11 ∧ 8 ≤ (timelyRun.state t).1 ()) ∧
     (∀ t, 8 ≤ (timelyRun.state t).1 ())) ∧
    ((delayedOrbit 0).1 () = 13 ∧
     (delayedOrbit 1).1 () = 11 ∧
     (delayedOrbit 2).1 () = 9 ∧
     (delayedOrbit 3).1 () = 6 ∧ (delayedOrbit 3).1 () < 8 ∧
     (delayedOrbit 4).1 () = 5 ∧
     (delayedOrbit 5).1 () = 4 ∧
     (delayedOrbit 6).1 () = 2 ∧
     (∀ t, 7 ≤ t → (delayedOrbit t).1 () = 0)) ∧
    (unswitchedNarrowLevel 0 = 13 ∧
     unswitchedNarrowLevel 1 = 11 ∧
     unswitchedNarrowLevel 2 = 9 ∧
     unswitchedNarrowLevel 3 = 6 ∧
     unswitchedNarrowLevel 4 = 2 ∧
     (∀ t, 5 ≤ t → unswitchedNarrowLevel t = 0)) := by
  refine ⟨⟨rfl, fun t ht => ?_, fun t => ?_⟩,
    ⟨rfl, rfl, rfl, rfl, by decide, rfl, rfl, rfl, fun t ht => ?_⟩,
    ⟨rfl, rfl, rfl, rfl, rfl, fun t ht => ?_⟩⟩
  · cases t with
    | zero => exact absurd ht (Nat.not_succ_le_zero 0)
    | succ k => exact ⟨(timely_state_succ k).1, by rw [(timely_state_succ k).1]; exact by decide⟩
  · exact (Viability.Kernel.run timelyRun timely_kernel t).1 ()
  · obtain ⟨k, hk⟩ := le_dest ht
    rw [hk]
    exact (delayed_step7_plus k).1
  · obtain ⟨k, hk⟩ := le_dest ht
    rw [hk]
    exact unswitched_step5_plus k

end LagSplit

end ScopeCoEvolutionWitness

/-! ## 3. Target 3 — Course-Level Menu / Nash-Equilibrium Obstruction (`07-SIGNIFICANCE.md #open`) -/

/-- Grounded course realization over a balanced, active-giving, support-dependent `Web`/`Flow` pair
with explicit step admission yields over `downFrom horizon` (`rank₁_eq`, `rank₂_eq`). -/
structure CourseRealization (Act F C : Type) : Type where
  web : Act → Act → Web F C
  flow : Act → Act → Flow F C
  balances : ∀ x y, (flow x y).Balances (web x y)
  acting : ∀ x y, (flow x y).Acting (web x y)
  dependent : ∀ x y, (web x y).Dependent
  horizon : Nat
  form₁ : F
  form₂ : F
  stepYield₁ : Act → Nat
  stepYield₂ : Act → Nat
  admitted₁ : Act → Act → Nat → Bool
  admitted₂ : Act → Act → Nat → Bool
  admitted₁_iff : ∀ x y t,
    admitted₁ x y t = true ↔ (web x y).active t form₁ ∧ (web x y).Admits ((web x y).level t) t form₁
  admitted₂_iff : ∀ x y t,
    admitted₂ x y t = true ↔ (web x y).active t form₂ ∧ (web x y).Admits ((web x y).level t) t form₂
  rank₁ : Act → Act → Nat
  rank₂ : Act → Act → Nat
  rank₁_eq : ∀ x y,
    rank₁ x y = total (downFrom horizon) (fun t => cond (admitted₁ x y t) (stepYield₁ x) 0)
  rank₂_eq : ∀ x y,
    rank₂ x y = total (downFrom horizon) (fun t => cond (admitted₂ x y t) (stepYield₂ y) 0)

/-- Two-chooser pure Nash equilibrium on menus `menu₁, menu₂`. -/
def PureNash {Act : Type} (rank₁ rank₂ : Act → Act → Nat)
    (menu₁ menu₂ : Act → Bool) (x y : Act) : Prop :=
  menu₁ x = true ∧ menu₂ y = true ∧
  (∀ x', menu₁ x' = true → rank₁ x' y ≤ rank₁ x y) ∧
  (∀ y', menu₂ y' = true → rank₂ x y' ≤ rank₂ x y)

/-- Symmetric specialization of `PureNash` coincides definitionally with `Becoming.MutualBest`. -/
theorem sym_pureNash_iff_mutualBest {Act : Type} (yield : Act → Act → Nat)
    (menu : Act → Bool) (x y : Act) :
    PureNash yield (fun a b => yield b a) menu menu x y ↔
      Weighting.MutualBest yield menu x y :=
  Iff.rfl

theorem CourseRealization.rank₁_ge_prefix {Act F C : Type} (CR : CourseRealization Act F C)
    {x y : Act} {T : Nat} (hle : T ≤ CR.horizon)
    (within : ∀ t, t ≤ T → (CR.web x y).active t CR.form₁ ∧
      (CR.web x y).Admits ((CR.web x y).level t) t CR.form₁) :
    (T + 1) * CR.stepYield₁ x ≤ CR.rank₁ x y := by
  rw [CR.rank₁_eq x y]
  have hpref : total (downFrom T) (fun t => cond (CR.admitted₁ x y t) (CR.stepYield₁ x) 0) =
      (T + 1) * CR.stepYield₁ x := by
    have hcongr : total (downFrom T) (fun t => cond (CR.admitted₁ x y t) (CR.stepYield₁ x) 0) =
        total (downFrom T) (fun _ => CR.stepYield₁ x) :=
      total_congr_on fun t mt => by
        rw [(CR.admitted₁_iff x y t).mpr (within t (le_of_mem_downFrom mt))]
        rfl
    exact hcongr.trans (total_downFrom_const T (CR.stepYield₁ x))
  exact hpref ▸ total_downFrom_mono hle _

theorem CourseRealization.rank₂_ge_prefix {Act F C : Type} (CR : CourseRealization Act F C)
    {x y : Act} {T : Nat} (hle : T ≤ CR.horizon)
    (within : ∀ t, t ≤ T → (CR.web x y).active t CR.form₂ ∧
      (CR.web x y).Admits ((CR.web x y).level t) t CR.form₂) :
    (T + 1) * CR.stepYield₂ y ≤ CR.rank₂ x y := by
  rw [CR.rank₂_eq x y]
  have hpref : total (downFrom T) (fun t => cond (CR.admitted₂ x y t) (CR.stepYield₂ y) 0) =
      (T + 1) * CR.stepYield₂ y := by
    have hcongr : total (downFrom T) (fun t => cond (CR.admitted₂ x y t) (CR.stepYield₂ y) 0) =
        total (downFrom T) (fun _ => CR.stepYield₂ y) :=
      total_congr_on fun t mt => by
        rw [(CR.admitted₂_iff x y t).mpr (within t (le_of_mem_downFrom mt))]
        rfl
    exact hcongr.trans (total_downFrom_const T (CR.stepYield₂ y))
  exact hpref ▸ total_downFrom_mono hle _

theorem CourseRealization.rank₁_le_cutoff {Act F C : Type} (CR : CourseRealization Act F C)
    {x y : Act} {T : Nat}
    (after : ∀ t, T < t → ¬ ((CR.web x y).active t CR.form₁ ∧
      (CR.web x y).Admits ((CR.web x y).level t) t CR.form₁)) :
    CR.rank₁ x y ≤ (T + 1) * CR.stepYield₁ x := by
  rw [CR.rank₁_eq x y]
  exact total_downFrom_le_of_after (fun t hlt =>
    ListTests.false_iff_not.mpr fun hm => after t hlt ((CR.admitted₁_iff x y t).mp hm))
    CR.horizon

theorem CourseRealization.rank₂_le_cutoff {Act F C : Type} (CR : CourseRealization Act F C)
    {x y : Act} {T : Nat}
    (after : ∀ t, T < t → ¬ ((CR.web x y).active t CR.form₂ ∧
      (CR.web x y).Admits ((CR.web x y).level t) t CR.form₂)) :
    CR.rank₂ x y ≤ (T + 1) * CR.stepYield₂ y := by
  rw [CR.rank₂_eq x y]
  exact total_downFrom_le_of_after (fun t hlt =>
    ListTests.false_iff_not.mpr fun hm => after t hlt ((CR.admitted₂_iff x y t).mp hm))
    CR.horizon

theorem CourseRealization.rank₁_eq_full {Act F C : Type} (CR : CourseRealization Act F C)
    {x y : Act}
    (within : ∀ t, t ≤ CR.horizon → (CR.web x y).active t CR.form₁ ∧
      (CR.web x y).Admits ((CR.web x y).level t) t CR.form₁) :
    CR.rank₁ x y = (CR.horizon + 1) * CR.stepYield₁ x := by
  rw [CR.rank₁_eq x y]
  have hcongr : total (downFrom CR.horizon) (fun t => cond (CR.admitted₁ x y t) (CR.stepYield₁ x) 0) =
      total (downFrom CR.horizon) (fun _ => CR.stepYield₁ x) :=
    total_congr_on fun t mt => by
      rw [(CR.admitted₁_iff x y t).mpr (within t (le_of_mem_downFrom mt))]
      rfl
  exact hcongr.trans (total_downFrom_const CR.horizon (CR.stepYield₁ x))

theorem CourseRealization.rank₂_eq_full {Act F C : Type} (CR : CourseRealization Act F C)
    {x y : Act}
    (within : ∀ t, t ≤ CR.horizon → (CR.web x y).active t CR.form₂ ∧
      (CR.web x y).Admits ((CR.web x y).level t) t CR.form₂) :
    CR.rank₂ x y = (CR.horizon + 1) * CR.stepYield₂ y := by
  rw [CR.rank₂_eq x y]
  have hcongr : total (downFrom CR.horizon) (fun t => cond (CR.admitted₂ x y t) (CR.stepYield₂ y) 0) =
      total (downFrom CR.horizon) (fun _ => CR.stepYield₂ y) :=
    total_congr_on fun t mt => by
      rw [(CR.admitted₂_iff x y t).mpr (within t (le_of_mem_downFrom mt))]
      rfl
  exact hcongr.trans (total_downFrom_const CR.horizon (CR.stepYield₂ y))

theorem CourseRealization.rank₁_eq_cutoff {Act F C : Type} (CR : CourseRealization Act F C)
    {x y : Act} {T : Nat} (hle : T ≤ CR.horizon)
    (within : ∀ t, t ≤ T → (CR.web x y).active t CR.form₁ ∧
      (CR.web x y).Admits ((CR.web x y).level t) t CR.form₁)
    (after : ∀ t, T < t → ¬ ((CR.web x y).active t CR.form₁ ∧
      (CR.web x y).Admits ((CR.web x y).level t) t CR.form₁)) :
    CR.rank₁ x y = (T + 1) * CR.stepYield₁ x :=
  Nat.le_antisymm (CR.rank₁_le_cutoff after) (CR.rank₁_ge_prefix hle within)

theorem CourseRealization.rank₂_eq_cutoff {Act F C : Type} (CR : CourseRealization Act F C)
    {x y : Act} {T : Nat} (hle : T ≤ CR.horizon)
    (within : ∀ t, t ≤ T → (CR.web x y).active t CR.form₂ ∧
      (CR.web x y).Admits ((CR.web x y).level t) t CR.form₂)
    (after : ∀ t, T < t → ¬ ((CR.web x y).active t CR.form₂ ∧
      (CR.web x y).Admits ((CR.web x y).level t) t CR.form₂)) :
    CR.rank₂ x y = (T + 1) * CR.stepYield₂ y :=
  Nat.le_antisymm (CR.rank₂_le_cutoff after) (CR.rank₂_ge_prefix hle within)

/-- **Course-Level Menu Widening Nash Obstruction**: dynamically derives menu widening,
equilibrium shift from `(r₀, r₀)` to unique `(d₀, d₀)`, and strict continuation drop for both
choosers from grounded `Web`/`Flow` step-admission and collapse bounds (no raw `PureNash` or
raw `rank d₀ d₀ < rank r₀ r₀` assumptions). -/
theorem course_menu_widening_nash_obstruction {Act F C : Type}
    (CR : CourseRealization Act F C) (acts : List Act)
    (narrow wide : Act → Bool) (r₀ d₀ : Act)
    (rMem : r₀ ∈ acts) (dMem : d₀ ∈ acts) (apart : d₀ ≠ r₀)
    (narrow_spec : ∀ x, narrow x = true ↔ x = r₀)
    (wide_spec : ∀ x, wide x = true ↔ x = r₀ ∨ x = d₀)
    (rr_adm₁ : ∀ t, t ≤ CR.horizon → (CR.web r₀ r₀).active t CR.form₁ ∧
      (CR.web r₀ r₀).Admits ((CR.web r₀ r₀).level t) t CR.form₁)
    (rr_adm₂ : ∀ t, t ≤ CR.horizon → (CR.web r₀ r₀).active t CR.form₂ ∧
      (CR.web r₀ r₀).Admits ((CR.web r₀ r₀).level t) t CR.form₂)
    {T_u1 T_u2 T_c T_rd T_dr : Nat}
    (tu1_le : T_u1 ≤ CR.horizon) (tu2_le : T_u2 ≤ CR.horizon) (tc_le : T_c ≤ CR.horizon)
    (dr_adm₁ : ∀ t, t ≤ T_u1 → (CR.web d₀ r₀).active t CR.form₁ ∧
      (CR.web d₀ r₀).Admits ((CR.web d₀ r₀).level t) t CR.form₁)
    (rd_adm₂ : ∀ t, t ≤ T_u2 → (CR.web r₀ d₀).active t CR.form₂ ∧
      (CR.web r₀ d₀).Admits ((CR.web r₀ d₀).level t) t CR.form₂)
    (tempt₁ : (CR.horizon + 1) * CR.stepYield₁ r₀ < (T_u1 + 1) * CR.stepYield₁ d₀)
    (tempt₂ : (CR.horizon + 1) * CR.stepYield₂ r₀ < (T_u2 + 1) * CR.stepYield₂ d₀)
    (dd_adm₁ : ∀ t, t ≤ T_c → (CR.web d₀ d₀).active t CR.form₁ ∧
      (CR.web d₀ d₀).Admits ((CR.web d₀ d₀).level t) t CR.form₁)
    (dd_cut₁ : ∀ t, T_c < t → ¬ ((CR.web d₀ d₀).active t CR.form₁ ∧
      (CR.web d₀ d₀).Admits ((CR.web d₀ d₀).level t) t CR.form₁))
    (dd_adm₂ : ∀ t, t ≤ T_c → (CR.web d₀ d₀).active t CR.form₂ ∧
      (CR.web d₀ d₀).Admits ((CR.web d₀ d₀).level t) t CR.form₂)
    (dd_cut₂ : ∀ t, T_c < t → ¬ ((CR.web d₀ d₀).active t CR.form₂ ∧
      (CR.web d₀ d₀).Admits ((CR.web d₀ d₀).level t) t CR.form₂))
    (rd_cut₁ : ∀ t, T_rd < t → ¬ ((CR.web r₀ d₀).active t CR.form₁ ∧
      (CR.web r₀ d₀).Admits ((CR.web r₀ d₀).level t) t CR.form₁))
    (dr_cut₂ : ∀ t, T_dr < t → ¬ ((CR.web d₀ r₀).active t CR.form₂ ∧
      (CR.web d₀ r₀).Admits ((CR.web d₀ r₀).level t) t CR.form₂))
    (overtaken₁ : (T_rd + 1) * CR.stepYield₁ r₀ < (T_c + 1) * CR.stepYield₁ d₀)
    (overtaken₂ : (T_dr + 1) * CR.stepYield₂ r₀ < (T_c + 1) * CR.stepYield₂ d₀)
    (drop₁ : (T_c + 1) * CR.stepYield₁ d₀ < (CR.horizon + 1) * CR.stepYield₁ r₀)
    (drop₂ : (T_c + 1) * CR.stepYield₂ d₀ < (CR.horizon + 1) * CR.stepYield₂ r₀) :
    Weighting.WidensOn acts wide narrow ∧
      (∀ x y, PureNash CR.rank₁ CR.rank₂ narrow narrow x y ↔ x = r₀ ∧ y = r₀) ∧
      (∀ x y, PureNash CR.rank₁ CR.rank₂ wide wide x y ↔ x = d₀ ∧ y = d₀) ∧
      CR.rank₁ d₀ d₀ < CR.rank₁ r₀ r₀ ∧ CR.rank₂ d₀ d₀ < CR.rank₂ r₀ r₀ := by
  have hwid : Weighting.WidensOn acts wide narrow :=
    ⟨fun x _ hx => (wide_spec x).mpr (.inl ((narrow_spec x).mp hx)),
     d₀, dMem, (wide_spec d₀).mpr (.inr rfl),
     ListTests.false_iff_not.mpr fun h => apart ((narrow_spec d₀).mp h)⟩
  have hrr1 : CR.rank₁ r₀ r₀ = (CR.horizon + 1) * CR.stepYield₁ r₀ := CR.rank₁_eq_full rr_adm₁
  have hrr2 : CR.rank₂ r₀ r₀ = (CR.horizon + 1) * CR.stepYield₂ r₀ := CR.rank₂_eq_full rr_adm₂
  have hdd1 : CR.rank₁ d₀ d₀ = (T_c + 1) * CR.stepYield₁ d₀ :=
    CR.rank₁_eq_cutoff tc_le dd_adm₁ dd_cut₁
  have hdd2 : CR.rank₂ d₀ d₀ = (T_c + 1) * CR.stepYield₂ d₀ :=
    CR.rank₂_eq_cutoff tc_le dd_adm₂ dd_cut₂
  have hTempt1 : CR.rank₁ r₀ r₀ < CR.rank₁ d₀ r₀ :=
    Nat.lt_of_lt_of_le (hrr1 ▸ tempt₁) (CR.rank₁_ge_prefix tu1_le dr_adm₁)
  have hTempt2 : CR.rank₂ r₀ r₀ < CR.rank₂ r₀ d₀ :=
    Nat.lt_of_lt_of_le (hrr2 ▸ tempt₂) (CR.rank₂_ge_prefix tu2_le rd_adm₂)
  have hOver1 : CR.rank₁ r₀ d₀ < CR.rank₁ d₀ d₀ :=
    Nat.lt_of_le_of_lt (CR.rank₁_le_cutoff rd_cut₁) (hdd1 ▸ overtaken₁)
  have hOver2 : CR.rank₂ d₀ r₀ < CR.rank₂ d₀ d₀ :=
    Nat.lt_of_le_of_lt (CR.rank₂_le_cutoff dr_cut₂) (hdd2 ▸ overtaken₂)
  have hNarrow : ∀ x y, PureNash CR.rank₁ CR.rank₂ narrow narrow x y ↔ x = r₀ ∧ y = r₀ := by
    intro x y
    refine ⟨fun ⟨hx, hy, _, _⟩ => ⟨(narrow_spec x).mp hx, (narrow_spec y).mp hy⟩, ?_⟩
    intro ⟨hx, hy⟩
    rw [hx, hy]
    refine ⟨(narrow_spec r₀).mpr rfl, (narrow_spec r₀).mpr rfl, ?_, ?_⟩
    · intro x' hx'; rw [(narrow_spec x').mp hx']; exact Nat.le_refl _
    · intro y' hy'; rw [(narrow_spec y').mp hy']; exact Nat.le_refl _
  have hWide : ∀ x y, PureNash CR.rank₁ CR.rank₂ wide wide x y ↔ x = d₀ ∧ y = d₀ := by
    intro x y
    refine ⟨fun ⟨hx, hy, b1, b2⟩ => ?_, ?_⟩
    · rcases (wide_spec x).mp hx with hx' | hx' <;> rcases (wide_spec y).mp hy with hy' | hy'
      · rw [hx', hy'] at b1; exact absurd (b1 d₀ ((wide_spec d₀).mpr (.inr rfl))) (Nat.not_le_of_gt hTempt1)
      · rw [hx', hy'] at b1; exact absurd (b1 d₀ ((wide_spec d₀).mpr (.inr rfl))) (Nat.not_le_of_gt hOver1)
      · rw [hx', hy'] at b2; exact absurd (b2 d₀ ((wide_spec d₀).mpr (.inr rfl))) (Nat.not_le_of_gt hOver2)
      · exact ⟨hx', hy'⟩
    · intro ⟨hx, hy⟩
      rw [hx, hy]
      refine ⟨(wide_spec d₀).mpr (.inr rfl), (wide_spec d₀).mpr (.inr rfl), ?_, ?_⟩
      · intro x' hx'; rcases (wide_spec x').mp hx' with hx'' | hx''
        · rw [hx'']; exact Nat.le_of_lt hOver1
        · rw [hx'']; exact Nat.le_refl _
      · intro y' hy'; rcases (wide_spec y').mp hy' with hy'' | hy''
        · rw [hy'']; exact Nat.le_of_lt hOver2
        · rw [hy'']; exact Nat.le_refl _
  have hDrop1 : CR.rank₁ d₀ d₀ < CR.rank₁ r₀ r₀ := by rw [hdd1, hrr1]; exact drop₁
  have hDrop2 : CR.rank₂ d₀ d₀ < CR.rank₂ r₀ r₀ := by rw [hdd2, hrr2]; exact drop₂
  have _ := rMem
  exact ⟨hwid, hNarrow, hWide, hDrop1, hDrop2⟩

/-- **Reciprocal Gate Restores Viable Nash Equilibrium**: adding a reciprocal exclusion gate that
keeps restrained courses active through `horizon` (`(r₀, r₀)`, `(r₀, d₀)` on `form₁`, `(d₀, r₀)` on
`form₂`) while closing an overdrawing partner's port after `T_gate` restores `(r₀, r₀)` as the
unique `PureNash` on the still-widened menu `wide`. -/
theorem reciprocal_gate_restores_viable_nash {Act F C : Type}
    (gated : CourseRealization Act F C)
    (wide : Act → Bool) (r₀ d₀ : Act)
    (wide_spec : ∀ x, wide x = true ↔ x = r₀ ∨ x = d₀)
    (rr_adm₁ : ∀ t, t ≤ gated.horizon → (gated.web r₀ r₀).active t gated.form₁ ∧
      (gated.web r₀ r₀).Admits ((gated.web r₀ r₀).level t) t gated.form₁)
    (rr_adm₂ : ∀ t, t ≤ gated.horizon → (gated.web r₀ r₀).active t gated.form₂ ∧
      (gated.web r₀ r₀).Admits ((gated.web r₀ r₀).level t) t gated.form₂)
    (rd_adm₁ : ∀ t, t ≤ gated.horizon → (gated.web r₀ d₀).active t gated.form₁ ∧
      (gated.web r₀ d₀).Admits ((gated.web r₀ d₀).level t) t gated.form₁)
    (dr_adm₂ : ∀ t, t ≤ gated.horizon → (gated.web d₀ r₀).active t gated.form₂ ∧
      (gated.web d₀ r₀).Admits ((gated.web d₀ r₀).level t) t gated.form₂)
    {T_gate : Nat}
    (dr_cut₁ : ∀ t, T_gate < t → ¬ ((gated.web d₀ r₀).active t gated.form₁ ∧
      (gated.web d₀ r₀).Admits ((gated.web d₀ r₀).level t) t gated.form₁))
    (rd_cut₂ : ∀ t, T_gate < t → ¬ ((gated.web r₀ d₀).active t gated.form₂ ∧
      (gated.web r₀ d₀).Admits ((gated.web r₀ d₀).level t) t gated.form₂))
    (dd_cut₁ : ∀ t, T_gate < t → ¬ ((gated.web d₀ d₀).active t gated.form₁ ∧
      (gated.web d₀ d₀).Admits ((gated.web d₀ d₀).level t) t gated.form₁))
    (dd_cut₂ : ∀ t, T_gate < t → ¬ ((gated.web d₀ d₀).active t gated.form₂ ∧
      (gated.web d₀ d₀).Admits ((gated.web d₀ d₀).level t) t gated.form₂))
    (restored₁ : (T_gate + 1) * gated.stepYield₁ d₀ < (gated.horizon + 1) * gated.stepYield₁ r₀)
    (restored₂ : (T_gate + 1) * gated.stepYield₂ d₀ < (gated.horizon + 1) * gated.stepYield₂ r₀) :
    ∀ x y, PureNash gated.rank₁ gated.rank₂ wide wide x y ↔ x = r₀ ∧ y = r₀ := by
  have hrr1 : gated.rank₁ r₀ r₀ = (gated.horizon + 1) * gated.stepYield₁ r₀ :=
    gated.rank₁_eq_full rr_adm₁
  have hrr2 : gated.rank₂ r₀ r₀ = (gated.horizon + 1) * gated.stepYield₂ r₀ :=
    gated.rank₂_eq_full rr_adm₂
  have hrd1 : (gated.horizon + 1) * gated.stepYield₁ r₀ ≤ gated.rank₁ r₀ d₀ :=
    gated.rank₁_ge_prefix (Nat.le_refl gated.horizon) rd_adm₁
  have hdr2 : (gated.horizon + 1) * gated.stepYield₂ r₀ ≤ gated.rank₂ d₀ r₀ :=
    gated.rank₂_ge_prefix (Nat.le_refl gated.horizon) dr_adm₂
  have hdr1_lt : gated.rank₁ d₀ r₀ < gated.rank₁ r₀ r₀ :=
    Nat.lt_of_le_of_lt (gated.rank₁_le_cutoff dr_cut₁) (hrr1 ▸ restored₁)
  have hrd2_lt : gated.rank₂ r₀ d₀ < gated.rank₂ r₀ r₀ :=
    Nat.lt_of_le_of_lt (gated.rank₂_le_cutoff rd_cut₂) (hrr2 ▸ restored₂)
  have hdd1_lt : gated.rank₁ d₀ d₀ < gated.rank₁ r₀ d₀ :=
    Nat.lt_of_le_of_lt (gated.rank₁_le_cutoff dd_cut₁) (Nat.lt_of_lt_of_le restored₁ hrd1)
  have hdd2_lt : gated.rank₂ d₀ d₀ < gated.rank₂ d₀ r₀ :=
    Nat.lt_of_le_of_lt (gated.rank₂_le_cutoff dd_cut₂) (Nat.lt_of_lt_of_le restored₂ hdr2)
  intro x y
  refine ⟨fun ⟨hx, hy, b1, b2⟩ => ?_, ?_⟩
  · rcases (wide_spec x).mp hx with hx' | hx' <;> rcases (wide_spec y).mp hy with hy' | hy'
    · exact ⟨hx', hy'⟩
    · rw [hx', hy'] at b2; exact absurd (b2 r₀ ((wide_spec r₀).mpr (.inl rfl))) (Nat.not_le_of_gt hrd2_lt)
    · rw [hx', hy'] at b1; exact absurd (b1 r₀ ((wide_spec r₀).mpr (.inl rfl))) (Nat.not_le_of_gt hdr1_lt)
    · rw [hx', hy'] at b1; exact absurd (b1 r₀ ((wide_spec r₀).mpr (.inl rfl))) (Nat.not_le_of_gt hdd1_lt)
  · intro ⟨hx, hy⟩
    rw [hx, hy]
    refine ⟨(wide_spec r₀).mpr (.inl rfl), (wide_spec r₀).mpr (.inl rfl), ?_, ?_⟩
    · intro x' hx'; rcases (wide_spec x').mp hx' with hx'' | hx''
      · rw [hx'']; exact Nat.le_refl _
      · rw [hx'']; exact Nat.le_of_lt hdr1_lt
    · intro y' hy'; rcases (wide_spec y').mp hy' with hy'' | hy''
      · rw [hy'']; exact Nat.le_refl _
      · rw [hy'']; exact Nat.le_of_lt hrd2_lt

/-! ### Concrete Grounded Witness: `CourseNashObstructionWitness` -/

namespace CourseNashObstructionWitness

inductive NashAct : Type where
  | restrain
  | overdraw

inductive NashForm : Type where
  | f1
  | f2
  | renewer
  | gateKeeper

inductive NashCond : Type where
  | cPool
  | cGate1
  | cGate2

def nashActs : List NashAct := [.restrain, .overdraw]

def narrowMenu : NashAct → Bool
  | .restrain => true
  | .overdraw => false

def wideMenu : NashAct → Bool
  | .restrain => true
  | .overdraw => true

def drawOf : NashAct → Nat
  | .restrain => 1
  | .overdraw => 4

def yieldOf : NashAct → Nat
  | .restrain => 2
  | .overdraw => 5

inductive GateNode : Type where
  | cert
  | p1
  | p2

def gateWaits (x y : NashAct) (a b : GateNode) : Prop :=
  match a with
  | .cert => match b with
    | .cert => False
    | .p1 => x = .overdraw
    | .p2 => y = .overdraw
  | .p1 => False
  | .p2 => False

def gateInit : GateNode → Prop
  | .cert => False
  | .p1 => True
  | .p2 => True

def gateOpenFn (gated : Bool) (act : NashAct) : Nat → Bool
  | 0 => true
  | _ + 1 => match gated with
    | false => true
    | true => match act with
      | .restrain => true
      | .overdraw => false

theorem waitsAll_restrain_p1 (y : NashAct) :
    ∀ t, (Law.run (Withholding.waitsAll (gateWaits .restrain y)) gateInit).state t .p1
  | 0 => trivial
  | t + 1 => ⟨waitsAll_restrain_p1 y t, fun c hc => match c, hc with
    | .cert, h => by cases h
    | .p1, h => False.elim h
    | .p2, h => False.elim h⟩

theorem waitsAll_restrain_p2 (x : NashAct) :
    ∀ t, (Law.run (Withholding.waitsAll (gateWaits x .restrain)) gateInit).state t .p2
  | 0 => trivial
  | t + 1 => ⟨waitsAll_restrain_p2 x t, fun c hc => match c, hc with
    | .cert, h => by cases h
    | .p1, h => False.elim h
    | .p2, h => False.elim h⟩

theorem gateOpen_true_iff_p1 (x y : NashAct) (t : Nat) :
    gateOpenFn true x t = true ↔
      (Law.run (Withholding.waitsAll (gateWaits x y)) gateInit).state t .p1 := by
  cases t with
  | zero =>
    exact ⟨fun _ => trivial, fun _ => rfl⟩
  | succ t' =>
    cases x with
    | restrain => exact ⟨fun _ => waitsAll_restrain_p1 y (t' + 1), fun _ => rfl⟩
    | overdraw =>
      exact ⟨fun h => Bool.noConfusion h,
        fun h => absurd h (Withholding.withholding_spreads (fun (hc : gateInit .cert) => hc)
          (Withholding.Chain.step (Withholding.Chain.here GateNode.cert)
            (rfl : gateWaits .overdraw y .cert .p1))
          (Nat.succ_le_succ (Nat.zero_le t')))⟩

theorem gateOpen_true_iff_p2 (x y : NashAct) (t : Nat) :
    gateOpenFn true y t = true ↔
      (Law.run (Withholding.waitsAll (gateWaits x y)) gateInit).state t .p2 := by
  cases t with
  | zero =>
    exact ⟨fun _ => trivial, fun _ => rfl⟩
  | succ t' =>
    cases y with
    | restrain => exact ⟨fun _ => waitsAll_restrain_p2 x (t' + 1), fun _ => rfl⟩
    | overdraw =>
      exact ⟨fun h => Bool.noConfusion h,
        fun h => absurd h (Withholding.withholding_spreads (fun (hc : gateInit .cert) => hc)
          (Withholding.Chain.step (Withholding.Chain.here GateNode.cert)
            (rfl : gateWaits x .overdraw .cert .p2))
          (Nat.succ_le_succ (Nat.zero_le t')))⟩

/-- Grounded `.cPool` stock trajectory from `x₀ = 9` with `need_f = 4, need_r = 6, give = 2,
r = 1, o = 4`. -/
def poolStep (gated : Bool) (x y : NashAct) : Nat → Nat
  | 0 => 9
  | t + 1 =>
    let s := poolStep gated x y t
    let t1 := if 4 ≤ s ∧ gateOpenFn gated x t = true then drawOf x else 0
    let t2 := if 4 ≤ s ∧ gateOpenFn gated y t = true then drawOf y else 0
    let g := if 6 ≤ s then 2 else 0
    s - (t1 + t2) + g

def poolTake1 (gated : Bool) (x y : NashAct) (t : Nat) : Nat :=
  if 4 ≤ poolStep gated x y t ∧ gateOpenFn gated x t = true then drawOf x else 0

def poolTake2 (gated : Bool) (x y : NashAct) (t : Nat) : Nat :=
  if 4 ≤ poolStep gated x y t ∧ gateOpenFn gated y t = true then drawOf y else 0

def poolGive (gated : Bool) (x y : NashAct) (t : Nat) : Nat :=
  if 6 ≤ poolStep gated x y t then 2 else 0

theorem poolStep_rr (gated : Bool) : ∀ t, poolStep gated .restrain .restrain t = 9
  | 0 => rfl
  | t + 1 => by
    show (let s := poolStep gated .restrain .restrain t
      let t1 := if 4 ≤ s ∧ gateOpenFn gated .restrain t = true then 1 else 0
      let t2 := if 4 ≤ s ∧ gateOpenFn gated .restrain t = true then 1 else 0
      let g := if 6 ≤ s then 2 else 0
      s - (t1 + t2) + g) = 9
    have hopen : gateOpenFn gated .restrain t = true := by
      cases gated <;> cases t <;> rfl
    rw [poolStep_rr gated t, hopen]
    rfl

theorem poolStep_oo (gated : Bool) : ∀ t, poolStep gated .overdraw .overdraw (t + 1) = 3
  | 0 => rfl
  | t + 1 => by
    show (let s := poolStep gated .overdraw .overdraw (t + 1)
      let t1 := if 4 ≤ s ∧ gateOpenFn gated .overdraw (t + 1) = true then 4 else 0
      let t2 := if 4 ≤ s ∧ gateOpenFn gated .overdraw (t + 1) = true then 4 else 0
      let g := if 6 ≤ s then 2 else 0
      s - (t1 + t2) + g) = 3
    rw [poolStep_oo gated t]
    rfl

theorem poolStep_ungated_or : ∀ t, poolStep false .overdraw .restrain (t + 2) = 3
  | 0 => rfl
  | t + 1 => by
    show (let s := poolStep false .overdraw .restrain (t + 2)
      let t1 := if 4 ≤ s ∧ gateOpenFn false .overdraw (t + 2) = true then 4 else 0
      let t2 := if 4 ≤ s ∧ gateOpenFn false .restrain (t + 2) = true then 1 else 0
      let g := if 6 ≤ s then 2 else 0
      s - (t1 + t2) + g) = 3
    rw [poolStep_ungated_or t]
    rfl

theorem poolStep_ungated_ro : ∀ t, poolStep false .restrain .overdraw (t + 2) = 3
  | 0 => rfl
  | t + 1 => by
    show (let s := poolStep false .restrain .overdraw (t + 2)
      let t1 := if 4 ≤ s ∧ gateOpenFn false .restrain (t + 2) = true then 1 else 0
      let t2 := if 4 ≤ s ∧ gateOpenFn false .overdraw (t + 2) = true then 4 else 0
      let g := if 6 ≤ s then 2 else 0
      s - (t1 + t2) + g) = 3
    rw [poolStep_ungated_ro t]
    rfl

theorem poolStep_gated_or_ge6 : ∀ t, 6 ≤ poolStep true .overdraw .restrain (t + 1)
  | 0 => by decide
  | t + 1 => by
    have ih := poolStep_gated_or_ge6 t
    have h4 : 4 ≤ poolStep true .overdraw .restrain (t + 1) := Nat.le_trans (by decide) ih
    show 6 ≤ (let s := poolStep true .overdraw .restrain (t + 1)
      let t1 := if 4 ≤ s ∧ gateOpenFn true .overdraw (t + 1) = true then 4 else 0
      let t2 := if 4 ≤ s ∧ gateOpenFn true .restrain (t + 1) = true then 1 else 0
      let g := if 6 ≤ s then 2 else 0
      s - (t1 + t2) + g)
    dsimp only [gateOpenFn]
    rw [if_neg (fun h : 4 ≤ poolStep true .overdraw .restrain (t + 1) ∧ false = true =>
      Bool.noConfusion h.2)]
    rw [if_pos ⟨h4, rfl⟩, if_pos ih, Nat.zero_add]
    have h1 : 1 ≤ poolStep true .overdraw .restrain (t + 1) := Nat.le_trans (by decide) ih
    have hsub : 5 ≤ poolStep true .overdraw .restrain (t + 1) - 1 := Naturals.le_sub_of_add_le ih
    exact Nat.le_trans (by decide) (Nat.add_le_add_right hsub 2)

theorem poolStep_gated_ro_ge6 : ∀ t, 6 ≤ poolStep true .restrain .overdraw (t + 1)
  | 0 => by decide
  | t + 1 => by
    have ih := poolStep_gated_ro_ge6 t
    have h4 : 4 ≤ poolStep true .restrain .overdraw (t + 1) := Nat.le_trans (by decide) ih
    show 6 ≤ (let s := poolStep true .restrain .overdraw (t + 1)
      let t1 := if 4 ≤ s ∧ gateOpenFn true .restrain (t + 1) = true then 1 else 0
      let t2 := if 4 ≤ s ∧ gateOpenFn true .overdraw (t + 1) = true then 4 else 0
      let g := if 6 ≤ s then 2 else 0
      s - (t1 + t2) + g)
    dsimp only [gateOpenFn]
    rw [if_pos ⟨h4, rfl⟩,
      if_neg (fun h : 4 ≤ poolStep true .restrain .overdraw (t + 1) ∧ false = true =>
        Bool.noConfusion h.2),
      if_pos ih, Nat.add_zero]
    have hsub : 5 ≤ poolStep true .restrain .overdraw (t + 1) - 1 := Naturals.le_sub_of_add_le ih
    exact Nat.le_trans (by decide) (Nat.add_le_add_right hsub 2)

theorem poolTake_le_poolStep (gated : Bool) (x y : NashAct) (t : Nat) :
    poolTake1 gated x y t + poolTake2 gated x y t ≤ poolStep gated x y t := by
  cases gated with
  | false =>
    cases x <;> cases y
    · show (if 4 ≤ poolStep false .restrain .restrain t ∧ gateOpenFn false .restrain t = true then 1 else 0) +
        (if 4 ≤ poolStep false .restrain .restrain t ∧ gateOpenFn false .restrain t = true then 1 else 0) ≤
        poolStep false .restrain .restrain t
      rw [poolStep_rr false t]; cases gateOpenFn false .restrain t <;> decide
    · cases t with
      | zero => exact by decide
      | succ t1 => cases t1 with
        | zero => exact by decide
        | succ t2 =>
          show (if 4 ≤ poolStep false .restrain .overdraw (t2 + 2) ∧ _ then 1 else 0) +
            (if 4 ≤ poolStep false .restrain .overdraw (t2 + 2) ∧ _ then 4 else 0) ≤
            poolStep false .restrain .overdraw (t2 + 2)
          rw [poolStep_ungated_ro t2]
          rw [if_neg (fun h => absurd h.1 (Nat.not_le_of_gt (by decide : 3 < 4))),
            if_neg (fun h => absurd h.1 (Nat.not_le_of_gt (by decide : 3 < 4)))]
          exact Nat.zero_le 3
    · cases t with
      | zero => exact by decide
      | succ t1 => cases t1 with
        | zero => exact by decide
        | succ t2 =>
          show (if 4 ≤ poolStep false .overdraw .restrain (t2 + 2) ∧ _ then 4 else 0) +
            (if 4 ≤ poolStep false .overdraw .restrain (t2 + 2) ∧ _ then 1 else 0) ≤
            poolStep false .overdraw .restrain (t2 + 2)
          rw [poolStep_ungated_or t2]
          rw [if_neg (fun h => absurd h.1 (Nat.not_le_of_gt (by decide : 3 < 4))),
            if_neg (fun h => absurd h.1 (Nat.not_le_of_gt (by decide : 3 < 4)))]
          exact Nat.zero_le 3
    · cases t with
      | zero => exact by decide
      | succ t1 =>
        show (if 4 ≤ poolStep false .overdraw .overdraw (t1 + 1) ∧ _ then 4 else 0) +
          (if 4 ≤ poolStep false .overdraw .overdraw (t1 + 1) ∧ _ then 4 else 0) ≤
          poolStep false .overdraw .overdraw (t1 + 1)
        rw [poolStep_oo false t1]
        rw [if_neg (fun h => absurd h.1 (Nat.not_le_of_gt (by decide : 3 < 4)))]
        exact Nat.zero_le 3
  | true =>
    cases x <;> cases y
    · show (if 4 ≤ poolStep true .restrain .restrain t ∧ gateOpenFn true .restrain t = true then 1 else 0) +
        (if 4 ≤ poolStep true .restrain .restrain t ∧ gateOpenFn true .restrain t = true then 1 else 0) ≤
        poolStep true .restrain .restrain t
      rw [poolStep_rr true t]; cases gateOpenFn true .restrain t <;> decide
    · cases t with
      | zero => exact by decide
      | succ t1 =>
        have h6 := poolStep_gated_ro_ge6 t1
        have h4 : 4 ≤ poolStep true .restrain .overdraw (t1 + 1) := Nat.le_trans (by decide) h6
        show (if 4 ≤ poolStep true .restrain .overdraw (t1 + 1) ∧
            gateOpenFn true .restrain (t1 + 1) = true then 1 else 0) +
          (if 4 ≤ poolStep true .restrain .overdraw (t1 + 1) ∧
            gateOpenFn true .overdraw (t1 + 1) = true then 4 else 0) ≤
          poolStep true .restrain .overdraw (t1 + 1)
        dsimp only [gateOpenFn]
        rw [if_pos ⟨h4, rfl⟩,
          if_neg (fun h : 4 ≤ poolStep true .restrain .overdraw (t1 + 1) ∧ false = true =>
            Bool.noConfusion h.2),
          Nat.add_zero]
        exact Nat.le_trans (by decide) h6
    · cases t with
      | zero => exact by decide
      | succ t1 =>
        have h6 := poolStep_gated_or_ge6 t1
        have h4 : 4 ≤ poolStep true .overdraw .restrain (t1 + 1) := Nat.le_trans (by decide) h6
        show (if 4 ≤ poolStep true .overdraw .restrain (t1 + 1) ∧
            gateOpenFn true .overdraw (t1 + 1) = true then 4 else 0) +
          (if 4 ≤ poolStep true .overdraw .restrain (t1 + 1) ∧
            gateOpenFn true .restrain (t1 + 1) = true then 1 else 0) ≤
          poolStep true .overdraw .restrain (t1 + 1)
        dsimp only [gateOpenFn]
        rw [if_neg (fun h : 4 ≤ poolStep true .overdraw .restrain (t1 + 1) ∧ false = true =>
            Bool.noConfusion h.2),
          if_pos ⟨h4, rfl⟩, Nat.zero_add]
        exact Nat.le_trans (by decide) h6
    · cases t with
      | zero => exact by decide
      | succ t1 =>
        show (if 4 ≤ poolStep true .overdraw .overdraw (t1 + 1) ∧ _ then 4 else 0) +
          (if 4 ≤ poolStep true .overdraw .overdraw (t1 + 1) ∧ _ then 4 else 0) ≤
          poolStep true .overdraw .overdraw (t1 + 1)
        rw [poolStep_oo true t1]
        rw [if_neg (fun h => absurd h.1 (Nat.not_le_of_gt (by decide : 3 < 4)))]
        exact Nat.zero_le 3

def nashWeb (gated : Bool) (x y : NashAct) : Web NashForm NashCond where
  level t c := match c with
    | .cPool => poolStep gated x y t
    | .cGate1 => if gateOpenFn gated x t then 1 else 0
    | .cGate2 => if gateOpenFn gated y t then 1 else 0
  active t f := match f with
    | .f1 => 4 ≤ poolStep gated x y t ∧ gateOpenFn gated x t = true
    | .f2 => 4 ≤ poolStep gated x y t ∧ gateOpenFn gated y t = true
    | .renewer => 6 ≤ poolStep gated x y t
    | .gateKeeper => True
  requires _ f c := match f with
    | .f1 => match c with
      | .cPool => True
      | .cGate1 => True
      | .cGate2 => False
    | .f2 => match c with
      | .cPool => True
      | .cGate2 => True
      | .cGate1 => False
    | .renewer => match c with
      | .cPool => True
      | .cGate1 => False
      | .cGate2 => False
    | .gateKeeper => False
  need _ f c := match f with
    | .f1 => match c with
      | .cPool => 4
      | .cGate1 => 1
      | .cGate2 => 0
    | .f2 => match c with
      | .cPool => 4
      | .cGate2 => 1
      | .cGate1 => 0
    | .renewer => match c with
      | .cPool => 6
      | .cGate1 => 0
      | .cGate2 => 0
    | .gateKeeper => 0
  draws t f c := match f with
    | .f1 => match c with
      | .cPool => 4 ≤ poolStep gated x y t ∧ gateOpenFn gated x t = true
      | .cGate1 => False
      | .cGate2 => False
    | .f2 => match c with
      | .cPool => 4 ≤ poolStep gated x y t ∧ gateOpenFn gated y t = true
      | .cGate1 => False
      | .cGate2 => False
    | .renewer => False
    | .gateKeeper => False

def nashFlow (gated : Bool) (x y : NashAct) : Flow NashForm NashCond where
  present _ := [.f1, .f2, .renewer, .gateKeeper]
  take t f c := match f with
    | .f1 => match c with
      | .cPool => poolTake1 gated x y t
      | .cGate1 => 0
      | .cGate2 => 0
    | .f2 => match c with
      | .cPool => poolTake2 gated x y t
      | .cGate1 => 0
      | .cGate2 => 0
    | .gateKeeper => match c with
      | .cPool => 0
      | .cGate1 => if gateOpenFn gated x t && !gateOpenFn gated x (t + 1) then 1 else 0
      | .cGate2 => if gateOpenFn gated y t && !gateOpenFn gated y (t + 1) then 1 else 0
    | .renewer => 0
  give t f c := match f with
    | .renewer => match c with
      | .cPool => poolGive gated x y t
      | .cGate1 => 0
      | .cGate2 => 0
    | .f1 => 0
    | .f2 => 0
    | .gateKeeper => 0

theorem nash_balances (gated : Bool) (x y : NashAct) :
    (nashFlow gated x y).Balances (nashWeb gated x y) := by
  intro t c
  cases c with
  | cPool =>
    show poolStep gated x y (t + 1) + (poolTake1 gated x y t + (poolTake2 gated x y t + 0)) =
      poolStep gated x y t + (0 + (0 + (poolGive gated x y t + 0)))
    rw [Nat.add_zero, Nat.add_zero, Nat.zero_add, Nat.zero_add]
    change (poolStep gated x y t - (poolTake1 gated x y t + poolTake2 gated x y t) +
        poolGive gated x y t) + (poolTake1 gated x y t + poolTake2 gated x y t) =
      poolStep gated x y t + poolGive gated x y t
    rw [Nat.add_right_comm, Naturals.sub_add_cancel (poolTake_le_poolStep gated x y t)]
  | cGate1 =>
    show (if gateOpenFn gated x (t + 1) then 1 else 0) +
        (0 + (0 + (0 + ((if gateOpenFn gated x t && !gateOpenFn gated x (t + 1) then 1 else 0) + 0)))) =
      (if gateOpenFn gated x t then 1 else 0) + (0 + (0 + (0 + (0 + 0))))
    cases gated <;> cases x <;> cases t <;> rfl
  | cGate2 =>
    show (if gateOpenFn gated y (t + 1) then 1 else 0) +
        (0 + (0 + (0 + ((if gateOpenFn gated y t && !gateOpenFn gated y (t + 1) then 1 else 0) + 0)))) =
      (if gateOpenFn gated y t then 1 else 0) + (0 + (0 + (0 + (0 + 0))))
    cases gated <;> cases y <;> cases t <;> rfl

theorem nash_acting (gated : Bool) (x y : NashAct) :
    (nashFlow gated x y).Acting (nashWeb gated x y) := by
  intro t f c _ hpos
  cases f with
  | f1 => cases c <;> exact absurd hpos (Nat.lt_irrefl 0)
  | f2 => cases c <;> exact absurd hpos (Nat.lt_irrefl 0)
  | gateKeeper => cases c <;> exact absurd hpos (Nat.lt_irrefl 0)
  | renewer =>
    cases c with
    | cGate1 => exact absurd hpos (Nat.lt_irrefl 0)
    | cGate2 => exact absurd hpos (Nat.lt_irrefl 0)
    | cPool =>
      show 6 ≤ poolStep gated x y t
      match Nat.decLe 6 (poolStep gated x y t) with
      | isTrue h => exact h
      | isFalse hn =>
        change 0 < if 6 ≤ poolStep gated x y t then 2 else 0 at hpos
        rw [if_neg hn] at hpos
        exact absurd hpos (Nat.lt_irrefl 0)

theorem nash_dependent (gated : Bool) (x y : NashAct) :
    (nashWeb gated x y).Dependent := by
  intro t f hf c hreq
  cases f with
  | f1 =>
    cases c with
    | cPool => exact hf.1
    | cGate1 => show 1 ≤ if gateOpenFn gated x t then 1 else 0; rw [hf.2]; exact Nat.le_refl 1
    | cGate2 => exact False.elim hreq
  | f2 =>
    cases c with
    | cPool => exact hf.1
    | cGate1 => exact False.elim hreq
    | cGate2 => show 1 ≤ if gateOpenFn gated y t then 1 else 0; rw [hf.2]; exact Nat.le_refl 1
  | renewer =>
    cases c with
    | cPool => exact hf
    | cGate1 => exact False.elim hreq
    | cGate2 => exact False.elim hreq
  | gateKeeper => exact False.elim hreq

def adm1Bool (gated : Bool) (x y : NashAct) (t : Nat) : Bool :=
  Nat.ble 4 (poolStep gated x y t) && gateOpenFn gated x t

def adm2Bool (gated : Bool) (x y : NashAct) (t : Nat) : Bool :=
  Nat.ble 4 (poolStep gated x y t) && gateOpenFn gated y t

theorem adm1Bool_iff (gated : Bool) (x y : NashAct) (t : Nat) :
    adm1Bool gated x y t = true ↔
      (nashWeb gated x y).active t .f1 ∧
        (nashWeb gated x y).Admits ((nashWeb gated x y).level t) t .f1 := by
  unfold adm1Bool
  refine ListTests.and_true_iff.trans ?_
  refine ⟨fun ⟨h4, hg⟩ => ?_, fun ⟨hact, _⟩ => ?_⟩
  · have h4' := Nat.le_of_ble_eq_true h4
    exact ⟨⟨h4', hg⟩, nash_dependent gated x y t .f1 ⟨h4', hg⟩⟩
  · exact ⟨Nat.ble_eq_true_of_le hact.1, hact.2⟩

theorem adm2Bool_iff (gated : Bool) (x y : NashAct) (t : Nat) :
    adm2Bool gated x y t = true ↔
      (nashWeb gated x y).active t .f2 ∧
        (nashWeb gated x y).Admits ((nashWeb gated x y).level t) t .f2 := by
  unfold adm2Bool
  refine ListTests.and_true_iff.trans ?_
  refine ⟨fun ⟨h4, hg⟩ => ?_, fun ⟨hact, _⟩ => ?_⟩
  · have h4' := Nat.le_of_ble_eq_true h4
    exact ⟨⟨h4', hg⟩, nash_dependent gated x y t .f2 ⟨h4', hg⟩⟩
  · exact ⟨Nat.ble_eq_true_of_le hact.1, hact.2⟩

def mkRealization (gated : Bool) : CourseRealization NashAct NashForm NashCond where
  web := nashWeb gated
  flow := nashFlow gated
  balances := nash_balances gated
  acting := nash_acting gated
  dependent := nash_dependent gated
  horizon := 2
  form₁ := .f1
  form₂ := .f2
  stepYield₁ := yieldOf
  stepYield₂ := yieldOf
  admitted₁ := adm1Bool gated
  admitted₂ := adm2Bool gated
  admitted₁_iff := adm1Bool_iff gated
  admitted₂_iff := adm2Bool_iff gated
  rank₁ x y := total (downFrom 2) (fun t => cond (adm1Bool gated x y t) (yieldOf x) 0)
  rank₂ x y := total (downFrom 2) (fun t => cond (adm2Bool gated x y t) (yieldOf y) 0)
  rank₁_eq _ _ := rfl
  rank₂_eq _ _ := rfl

def ungatedRealization : CourseRealization NashAct NashForm NashCond := mkRealization false
def gatedRealization : CourseRealization NashAct NashForm NashCond := mkRealization true

/-- `OpenComposition` bridge at `x₀ = 9, x_crit = 4, H_def_pre = 4, H_def_post = 0, T_gate = 1,
H_coop = 1, warnLevel = 14`, whose trajectory `[9, 6, 7, 8, ...]` matches `gatedRealization.web
.overdraw .restrain` at every step `t : Nat`. -/
def ocG (_ : Unit) (e : Unit → Nat) : Nat :=
  if 3 ≤ e () then 2 else 0

theorem ocG_rises : ∀ k : Unit, RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (ocG k) :=
  fun _ e _ hbelow => by
    unfold ocG
    cases Nat.decLe 3 (e ()) with
    | isTrue h =>
      rw [if_pos h, if_pos (Nat.le_trans h (hbelow ()))]
      exact Nat.le_refl 2
    | isFalse h =>
      rw [if_neg h]
      exact Nat.zero_le _

def ocComp : OpenComposition.OpenComponent (Nat × Unit) (Bool × Unit) (Unit × Unit) (Empty ⊕ Empty) Unit :=
  (ScopeDynamics.OpenCompositionBridge.gatedDefectorComponent 4 0 1).compose
    (ScopeDynamics.OpenCompositionBridge.coopComponent 1)

def ocContract : OpenComposition.InterfaceContract ocComp (1, ()) :=
  OpenComposition.composeContract
    (ScopeDynamics.OpenCompositionBridge.gatedDefectorContract 4 0 1 (Nat.zero_le 4))
    (ScopeDynamics.OpenCompositionBridge.coopContract 1)

theorem oc_compose_viable :
    Viability.Kernel
      (OpenComposition.closedProcess ocComp ocContract
        (fun x => (ScopeDynamics.reciprocalObs 14 () x, ()))
        ScopeDynamics.OpenCompositionBridge.openReciprocalChannel
        ocG (fun _ _ => 0) (fun _ => True))
      (OpenComposition.closedGuard ocComp ocContract (fun _ => 4))
      (fun _ => 9, (1, ())) := by
  refine OpenComposition.compose_close_interchange
    (ScopeDynamics.OpenCompositionBridge.gatedDefectorComponent 4 0 1)
    (ScopeDynamics.OpenCompositionBridge.coopComponent 1)
    (ScopeDynamics.OpenCompositionBridge.gatedDefectorContract 4 0 1 (Nat.zero_le 4))
    (ScopeDynamics.OpenCompositionBridge.coopContract 1)
    (ScopeDynamics.reciprocalObs 14 ()) (fun _ => ())
    ScopeDynamics.OpenCompositionBridge.openReciprocalChannel
    ocG (fun _ _ => 0) (fun _ => 0) (fun _ => True)
    (fun _ _ _ => Nat.le_refl 0)
    (fun _ => 4) (fun _ => 14) (fun _ => 1) (fun _ => 9)
    (fun x k hlt => by cases k; exact .inl (CoreHelpers.natBlt_true_iff.mpr hlt))
    (fun load _ _ hle => by
      have h0 : load ≤ 0 := Nat.le_trans hle (Nat.le_refl 0)
      show (true && Nat.ble load 0) = true
      rw [Nat.ble_eq_true_of_le h0]; rfl)
    ocG_rises
    (fun k => by cases k; exact by decide)
    (fun k => by cases k; exact by decide)
    (fun k => by cases k; exact by decide)
    (fun k => by cases k; exact by decide)

def ocRun :
    Run
      (OpenComposition.closedProcess ocComp ocContract
        (fun x => (ScopeDynamics.reciprocalObs 14 () x, ()))
        ScopeDynamics.OpenCompositionBridge.openReciprocalChannel
        ocG (fun _ _ => 0) (fun _ => True)) where
  state := Law.orbit
    (fun st => OpenComposition.closedStep ocComp
      (fun x => (ScopeDynamics.reciprocalObs 14 () x, ()))
      ScopeDynamics.OpenCompositionBridge.openReciprocalChannel
      ocG (fun _ _ => 0) st ((), ((), ())))
    (fun _ => 9, (1, ()))
  act _ := ((), ((), ()))
  step _ := ⟨⟨trivial, fun _ => ⟨trivial, trivial⟩⟩, rfl⟩

theorem ocRun_ctrl_succ : ∀ k, (ocRun.state (k + 1)).2 = (0, ())
  | 0 => rfl
  | k + 1 => by
    have ih := ocRun_ctrl_succ k
    change (OpenComposition.closedStep ocComp
      (fun x => (ScopeDynamics.reciprocalObs 14 () x, ()))
      ScopeDynamics.OpenCompositionBridge.openReciprocalChannel
      ocG (fun _ _ => 0) (ocRun.state (k + 1)) ((), ((), ()))).2 = (0, ())
    unfold OpenComposition.closedStep OpenComposition.closedStepWith ocComp
    dsimp only [OpenComposition.OpenComponent.compose,
      ScopeDynamics.OpenCompositionBridge.gatedDefectorComponent,
      ScopeDynamics.OpenCompositionBridge.coopComponent,
      OpenComposition.constDrawerComponent,
      ScopeDynamics.OpenCompositionBridge.openReciprocalChannel,
      OpenComposition.zeroSilenceChannel, ScopeDynamics.reciprocalObs]
    rw [ih]
    cases Nat.blt ((ocRun.state (k + 1)).1 ()) 14 <;> rfl

theorem ocRun_matches_gated_or :
    ∀ t, (ocRun.state t).1 () = (gatedRealization.web .overdraw .restrain).level t .cPool
  | 0 => rfl
  | 1 => rfl
  | t + 2 => by
    have ih := ocRun_matches_gated_or (t + 1)
    have hctrl := ocRun_ctrl_succ t
    have h6 : 6 ≤ poolStep true .overdraw .restrain (t + 1) := poolStep_gated_or_ge6 t
    have h4 : 4 ≤ poolStep true .overdraw .restrain (t + 1) := Nat.le_trans (by decide) h6
    have hge3 : 3 ≤ (ocRun.state (t + 1)).1 () - 1 := by
      change 3 ≤ (ocRun.state (t + 1)).1 () - 1
      rw [ih]
      show 3 ≤ poolStep true .overdraw .restrain (t + 1) - 1
      exact Naturals.le_sub_of_add_le (Nat.le_trans (by decide) h6)
    have hL : (ocRun.state (t + 2)).1 () = ((ocRun.state (t + 1)).1 () - 1) + 2 := by
      change (OpenComposition.closedStep ocComp
        (fun x => (ScopeDynamics.reciprocalObs 14 () x, ()))
        ScopeDynamics.OpenCompositionBridge.openReciprocalChannel
        ocG (fun _ _ => 0) (ocRun.state (t + 1)) ((), ((), ()))).1 () =
        ((ocRun.state (t + 1)).1 () - 1) + 2
      unfold OpenComposition.closedStep OpenComposition.closedStepWith ocComp
      dsimp only [OpenComposition.OpenComponent.compose,
        ScopeDynamics.OpenCompositionBridge.gatedDefectorComponent,
        ScopeDynamics.OpenCompositionBridge.coopComponent,
        OpenComposition.constDrawerComponent,
        RegimeMargin.Coupled.Indexed.step, RegimeMargin.Drawn.whole,
        RegimeMargin.Coupled.Indexed.left, ocG]
      rw [hctrl]
      change ((ocRun.state (t + 1)).1 () - 1) +
          (if 3 ≤ (ocRun.state (t + 1)).1 () - 1 then 2 else 0) =
        ((ocRun.state (t + 1)).1 () - 1) + 2
      rw [if_pos hge3]
    have hR : (gatedRealization.web .overdraw .restrain).level (t + 2) .cPool =
        (poolStep true .overdraw .restrain (t + 1) - 1) + 2 := by
      show (let s := poolStep true .overdraw .restrain (t + 1)
        let t1 := if 4 ≤ s ∧ gateOpenFn true .overdraw (t + 1) = true then 4 else 0
        let t2 := if 4 ≤ s ∧ gateOpenFn true .restrain (t + 1) = true then 1 else 0
        let g := if 6 ≤ s then 2 else 0
        s - (t1 + t2) + g) = _
      dsimp only [gateOpenFn]
      rw [if_neg (fun h : 4 ≤ poolStep true .overdraw .restrain (t + 1) ∧ false = true =>
          Bool.noConfusion h.2),
        if_pos ⟨h4, rfl⟩, if_pos h6, Nat.zero_add]
    rw [hL, hR, ih]
    rfl

theorem witness_holds :
    Weighting.WidensOn nashActs wideMenu narrowMenu ∧
    (∀ x y, PureNash ungatedRealization.rank₁ ungatedRealization.rank₂ narrowMenu narrowMenu x y ↔
      x = .restrain ∧ y = .restrain) ∧
    (∀ x y, PureNash ungatedRealization.rank₁ ungatedRealization.rank₂ wideMenu wideMenu x y ↔
      x = .overdraw ∧ y = .overdraw) ∧
    ungatedRealization.rank₁ .overdraw .overdraw = 5 ∧
    ungatedRealization.rank₁ .restrain .restrain = 6 ∧
    ungatedRealization.rank₁ .overdraw .overdraw < ungatedRealization.rank₁ .restrain .restrain ∧
    ungatedRealization.rank₂ .overdraw .overdraw < ungatedRealization.rank₂ .restrain .restrain ∧
    (∀ t, 1 ≤ t →
      ¬ (gatedRealization.web .overdraw .restrain).Admits
          ((gatedRealization.web .overdraw .restrain).level t) t .f1) ∧
    (∀ x y, PureNash gatedRealization.rank₁ gatedRealization.rank₂ wideMenu wideMenu x y ↔
      x = .restrain ∧ y = .restrain) ∧
    (∀ t, (ocRun.state t).1 () = (gatedRealization.web .overdraw .restrain).level t .cPool ∧
      4 ≤ (ocRun.state t).1 ()) := by
  have hObs := course_menu_widening_nash_obstruction ungatedRealization nashActs
    narrowMenu wideMenu .restrain .overdraw (.head _) (.tail _ (.head _))
    (fun h => NashAct.noConfusion h)
    (fun x => by cases x with
      | restrain => exact ⟨fun _ => rfl, fun _ => rfl⟩
      | overdraw => exact ⟨fun h => Bool.noConfusion h, fun h => NashAct.noConfusion h⟩)
    (fun x => by cases x <;> exact ⟨fun _ => by first | exact .inl rfl | exact .inr rfl, fun _ => rfl⟩)
    (fun t _ => by
      have hact : (ungatedRealization.web .restrain .restrain).active t .f1 :=
        ⟨by show 4 ≤ poolStep false .restrain .restrain t; rw [poolStep_rr false t]; exact by decide,
         by cases t <;> rfl⟩
      exact ⟨hact, nash_dependent false .restrain .restrain t .f1 hact⟩)
    (fun t _ => by
      have hact : (ungatedRealization.web .restrain .restrain).active t .f2 :=
        ⟨by show 4 ≤ poolStep false .restrain .restrain t; rw [poolStep_rr false t]; exact by decide,
         by cases t <;> rfl⟩
      exact ⟨hact, nash_dependent false .restrain .restrain t .f2 hact⟩)
    (T_u1 := 1) (T_u2 := 1) (T_c := 0) (T_rd := 1) (T_dr := 1)
    (Nat.le_of_lt (by decide : 1 < 2)) (Nat.le_of_lt (by decide : 1 < 2)) (Nat.zero_le 2)
    (fun t ht => by
      cases t with
      | zero =>
        have hact : (ungatedRealization.web .overdraw .restrain).active 0 .f1 := ⟨by decide, rfl⟩
        exact ⟨hact, nash_dependent false .overdraw .restrain 0 .f1 hact⟩
      | succ t1 => cases t1 with
        | zero =>
          have hact : (ungatedRealization.web .overdraw .restrain).active 1 .f1 := ⟨by decide, rfl⟩
          exact ⟨hact, nash_dependent false .overdraw .restrain 1 .f1 hact⟩
        | succ t2 =>
          exact absurd ht (Nat.not_le_of_gt (Nat.succ_lt_succ (Nat.succ_pos t2))))
    (fun t ht => by
      cases t with
      | zero =>
        have hact : (ungatedRealization.web .restrain .overdraw).active 0 .f2 := ⟨by decide, rfl⟩
        exact ⟨hact, nash_dependent false .restrain .overdraw 0 .f2 hact⟩
      | succ t1 => cases t1 with
        | zero =>
          have hact : (ungatedRealization.web .restrain .overdraw).active 1 .f2 := ⟨by decide, rfl⟩
          exact ⟨hact, nash_dependent false .restrain .overdraw 1 .f2 hact⟩
        | succ t2 =>
          exact absurd ht (Nat.not_le_of_gt (Nat.succ_lt_succ (Nat.succ_pos t2))))
    (by decide) (by decide)
    (fun t ht => by
      have h0 : t = 0 := Nat.eq_zero_of_le_zero ht
      subst h0
      have hact : (ungatedRealization.web .overdraw .overdraw).active 0 .f1 := ⟨by decide, rfl⟩
      exact ⟨hact, nash_dependent false .overdraw .overdraw 0 .f1 hact⟩)
    (fun t hlt ⟨hact, _⟩ => by
      have h4 := hact.1
      obtain ⟨k, hk⟩ := le_dest hlt
      rw [hk, Nat.add_comm 1 k] at h4
      change 4 ≤ poolStep false .overdraw .overdraw (k + 1) at h4
      rw [poolStep_oo false k] at h4
      exact absurd h4 (by decide))
    (fun t ht => by
      have h0 : t = 0 := Nat.eq_zero_of_le_zero ht
      subst h0
      have hact : (ungatedRealization.web .overdraw .overdraw).active 0 .f2 := ⟨by decide, rfl⟩
      exact ⟨hact, nash_dependent false .overdraw .overdraw 0 .f2 hact⟩)
    (fun t hlt ⟨hact, _⟩ => by
      have h4 := hact.1
      obtain ⟨k, hk⟩ := le_dest hlt
      rw [hk, Nat.add_comm 1 k] at h4
      change 4 ≤ poolStep false .overdraw .overdraw (k + 1) at h4
      rw [poolStep_oo false k] at h4
      exact absurd h4 (by decide))
    (fun t hlt ⟨hact, _⟩ => by
      have h4 := hact.1
      obtain ⟨k, hk⟩ := le_dest hlt
      rw [hk, Nat.add_comm 2 k] at h4
      change 4 ≤ poolStep false .restrain .overdraw (k + 2) at h4
      rw [poolStep_ungated_ro k] at h4
      exact absurd h4 (by decide))
    (fun t hlt ⟨hact, _⟩ => by
      have h4 := hact.1
      obtain ⟨k, hk⟩ := le_dest hlt
      rw [hk, Nat.add_comm 2 k] at h4
      change 4 ≤ poolStep false .overdraw .restrain (k + 2) at h4
      rw [poolStep_ungated_or k] at h4
      exact absurd h4 (by decide))
    (by decide) (by decide) (by decide) (by decide)
  have hGate := reciprocal_gate_restores_viable_nash gatedRealization wideMenu .restrain .overdraw
    (fun x => by cases x <;> exact ⟨fun _ => by first | exact .inl rfl | exact .inr rfl, fun _ => rfl⟩)
    (fun t _ => by
      have hact : (gatedRealization.web .restrain .restrain).active t .f1 :=
        ⟨by show 4 ≤ poolStep true .restrain .restrain t; rw [poolStep_rr true t]; exact by decide,
         by cases t <;> rfl⟩
      exact ⟨hact, nash_dependent true .restrain .restrain t .f1 hact⟩)
    (fun t _ => by
      have hact : (gatedRealization.web .restrain .restrain).active t .f2 :=
        ⟨by show 4 ≤ poolStep true .restrain .restrain t; rw [poolStep_rr true t]; exact by decide,
         by cases t <;> rfl⟩
      exact ⟨hact, nash_dependent true .restrain .restrain t .f2 hact⟩)
    (fun t _ => by
      have hact : (gatedRealization.web .restrain .overdraw).active t .f1 :=
        ⟨by
          cases t with
          | zero => exact by decide
          | succ k => exact Nat.le_trans (by decide) (poolStep_gated_ro_ge6 k),
         by cases t <;> rfl⟩
      exact ⟨hact, nash_dependent true .restrain .overdraw t .f1 hact⟩)
    (fun t _ => by
      have hact : (gatedRealization.web .overdraw .restrain).active t .f2 :=
        ⟨by
          cases t with
          | zero => exact by decide
          | succ k => exact Nat.le_trans (by decide) (poolStep_gated_or_ge6 k),
         by cases t <;> rfl⟩
      exact ⟨hact, nash_dependent true .overdraw .restrain t .f2 hact⟩)
    (T_gate := 0)
    (fun t hlt ⟨hact, _⟩ => by
      have hg := hact.2
      obtain ⟨k, hk⟩ := le_dest hlt
      rw [hk, Nat.add_comm 1 k] at hg
      exact Bool.noConfusion hg)
    (fun t hlt ⟨hact, _⟩ => by
      have hg := hact.2
      obtain ⟨k, hk⟩ := le_dest hlt
      rw [hk, Nat.add_comm 1 k] at hg
      exact Bool.noConfusion hg)
    (fun t hlt ⟨hact, _⟩ => by
      have hg := hact.2
      obtain ⟨k, hk⟩ := le_dest hlt
      rw [hk, Nat.add_comm 1 k] at hg
      exact Bool.noConfusion hg)
    (fun t hlt ⟨hact, _⟩ => by
      have hg := hact.2
      obtain ⟨k, hk⟩ := le_dest hlt
      rw [hk, Nat.add_comm 1 k] at hg
      exact Bool.noConfusion hg)
    (by decide) (by decide)
  have hF1Closed : ∀ t, 1 ≤ t →
      ¬ (gatedRealization.web .overdraw .restrain).Admits
          ((gatedRealization.web .overdraw .restrain).level t) t .f1 := fun t ht hadm => by
    obtain ⟨k, hk⟩ := le_dest ht
    rw [hk, Nat.add_comm 1 k] at hadm
    have hle : 1 ≤ (gatedRealization.web .overdraw .restrain).level (k + 1) .cGate1 :=
      hadm .cGate1 trivial
    change 1 ≤ 0 at hle
    exact Nat.not_le_of_gt Nat.zero_lt_one hle
  exact ⟨hObs.1, hObs.2.1, hObs.2.2.1, rfl, rfl, hObs.2.2.2.1, hObs.2.2.2.2,
    hF1Closed, hGate,
    fun t => ⟨ocRun_matches_gated_or t, (Viability.Kernel.run ocRun oc_compose_viable t).1 ()⟩⟩

end CourseNashObstructionWitness

/-! ## 4. Target 4 — Explicit Metaethical Firewall (`not_entails`) -/

/-- Full endogenous-order system parameterized on all carrier types so it resides in `Type 0`,
joining (1) finite-horizon `OrderUpdater` convergence, (2) anchored `ScopeMode` `Viability.Kernel`,
and (3) reciprocal-gate `CourseRealization` unique `PureNash`. -/
structure EndogenousOrderSystem
    (X Mode : Type) (S Obs Dist Int Ext : Mode → Type) (Site Env : Type)
    (Act F C : Type) : Type where
  updater : OrderUpdater X
  feedback : Nat → X → Bool
  horizonOrder : Nat
  converged : ∀ t, horizonOrder ≤ t →
    Weighting.IncreasingInOwn updater.items updater.own (updater.ranksAt feedback t)
  base : PolyComposition.AnchoredBase Mode S Obs Dist Int Ext
  init : Σ m, S m
  initAnchored : PolyComposition.AnchoredInit base init
  admitDec : (p cand : Σ m, S m) → Bool → Bool
  fallback : (p : Σ m, S m) → Obs p.1 × Bool → Dist p.1 → Σ m', S m'
  admitSound : PolyComposition.AnchoredModeAdmit base admitDec fallback
  propose : (p : Σ m, S m) → Obs p.1 × Bool → Dist p.1 → Σ m', S m'
  route : (m : Mode) → Site → List (Ext m)
  obs : (m : Mode) → (Site → Nat) → Obs m
  channel : Bool → Nat → Env → Bool
  G : Site → (Site → Nat) → Nat
  envDraw : Env → Site → Nat
  jointAdm : Env → Prop
  x_crit : Site → Nat
  x₀ : Site → Nat
  scopeKernel :
    Viability.Kernel
      (PolyComposition.polyClosedProcess
        (PolyComposition.anchoredSelfModComponent base admitDec fallback propose) route
        (PolyComposition.anchoredSelfModContract base initAnchored admitDec fallback admitSound propose)
        obs channel G envDraw jointAdm)
      (PolyComposition.polyClosedGuard
        (PolyComposition.anchoredSelfModComponent base admitDec fallback propose)
        (PolyComposition.anchoredSelfModContract base initAnchored admitDec fallback admitSound propose)
        x_crit)
      (x₀, init)
  realization : CourseRealization Act F C
  wideMenu : Act → Bool
  r₀ : Act
  viableNash :
    PureNash realization.rank₁ realization.rank₂ wideMenu wideMenu r₀ r₀
  uniqueNash :
    ∀ x y, PureNash realization.rank₁ realization.rank₂ wideMenu wideMenu x y → x = r₀ ∧ y = r₀

/-- Any law holding of an `EndogenousOrderSystem` admits every rival bounded significance. -/
theorem endogenousOrder_admits_rival
    {X Mode : Type} {S Obs Dist Int Ext : Mode → Type} {Site Env Act F C Pos F' : Type}
    (Law : EndogenousOrderSystem X Mode S Obs Dist Int Ext Site Env Act F C → Prop)
    {sys : EndogenousOrderSystem X Mode S Obs Dist Int Ext Site Env Act F C}
    (holds : Law sys)
    {region : Pos → F' → Prop} (outside : ∃ p f, ¬ region p f) :
    Law sys ∧ Rival (bounded region) ∧ ¬ Unrestricted (bounded region) :=
  ScopeDynamics.scopeLaw_admits_rival Law holds (fun _ _ _ => True) outside

/-- **Metaethical Firewall (`endogenousOrder_cannot_entail_unrestricted`)**: no dynamical law
satisfied by an inhabited `EndogenousOrderSystem` can ever entail `Unrestricted sig`. -/
theorem endogenousOrder_cannot_entail_unrestricted
    {X Mode : Type} {S Obs Dist Int Ext : Mode → Type} {Site Env Act F C Pos F' : Type}
    (Law : EndogenousOrderSystem X Mode S Obs Dist Int Ext Site Env Act F C → Prop)
    (p : Pos) (f : F')
    {sys : EndogenousOrderSystem X Mode S Obs Dist Int Ext Site Env Act F C}
    (holds : Law sys) :
    ¬ (∀ sys' (sig : Pos → Nat → F' → Prop), Law sys' → Unrestricted sig) :=
  ScopeDynamics.scopeLaw_cannot_entail_unrestricted Law p f holds

namespace EndogenousFirewallWitness

def system :
    EndogenousOrderSystem OnlineWeightWitness.OWItem ScopeMode ScopeS ScopeObs ScopeDist
      ScopeInt ScopeExt Unit Unit CourseNashObstructionWitness.NashAct
      CourseNashObstructionWitness.NashForm CourseNashObstructionWitness.NashCond where
  updater := OnlineWeightWitness.owUpdater
  feedback := OnlineWeightWitness.feedbackAll
  horizonOrder := 3
  converged := OnlineWeightWitness.feedbackAll_converges
  base := scopeBase 3 1 1 (by decide)
  init := ⟨.narrowUnmonitored, 1⟩
  initAnchored := ⟨⟨by decide, Nat.le_refl 1⟩⟩
  admitDec := scopeAdmitDec 1
  fallback := scopeFallback
  admitSound := scopeAdmit_sound 3 1 1 (by decide)
  propose := ScopeCoEvolutionWitness.LagSplit.proposeAlwaysNarrow
  route := scopeRoute
  obs := scopeObs 16
  channel := scopeChannel
  G := fun _ e => ScopeDynamics.gEx (e ())
  envDraw := fun _ _ => 1
  jointAdm := fun _ => True
  x_crit := fun _ => 8
  x₀ := fun _ => 13
  scopeKernel := ScopeCoEvolutionWitness.LagSplit.timely_kernel
  realization := CourseNashObstructionWitness.gatedRealization
  wideMenu := CourseNashObstructionWitness.wideMenu
  r₀ := .restrain
  viableNash :=
    (CourseNashObstructionWitness.witness_holds.2.2.2.2.2.2.2.2.1 .restrain .restrain).mpr
      ⟨rfl, rfl⟩
  uniqueNash x y :=
    (CourseNashObstructionWitness.witness_holds.2.2.2.2.2.2.2.2.1 x y).mp

def firewallRegion (_ : Clearing.Formation) : OnlineWeightWitness.OWItem → Prop
  | .victim => False
  | .coupledSub => True
  | .coupledGate => True
  | .offProbe => True

theorem firewall_holds :
    (∀ t, 3 ≤ t → Weighting.IncreasingInOwn system.updater.items system.updater.own
      (system.updater.ranksAt system.feedback t)) ∧
    (∀ t, system.updater.posAt system.feedback t .victim = 0) ∧
    (∀ x y, PureNash system.realization.rank₁ system.realization.rank₂
        system.wideMenu system.wideMenu x y ↔ x = .restrain ∧ y = .restrain) ∧
    Rival (bounded firewallRegion) ∧
    ¬ Unrestricted (bounded firewallRegion) ∧
    (Clearing.valuation.Held ∧ ¬ Clearing.valuation.Significant) ∧
    ¬ (∀ (sys' : EndogenousOrderSystem OnlineWeightWitness.OWItem ScopeMode ScopeS ScopeObs
          ScopeDist ScopeInt ScopeExt Unit Unit CourseNashObstructionWitness.NashAct
          CourseNashObstructionWitness.NashForm CourseNashObstructionWitness.NashCond)
        (sig : Clearing.Formation → Nat → OnlineWeightWitness.OWItem → Prop),
        (∀ t, sys'.updater.posAt sys'.feedback t .victim = 0) → Unrestricted sig) := by
  have hNeverVictim : ∀ t, system.feedback t .victim = false := fun t => by
    cases t with
    | zero => rfl
    | succ t1 => cases t1 with
      | zero => rfl
      | succ t2 => cases t2 <;> rfl
  have hz : ∀ t, system.updater.posAt system.feedback t .victim = 0 :=
    uncoupled_zero_weight_forever system.updater system.feedback hNeverVictim rfl
  have hAdm := endogenousOrder_admits_rival
    (fun (s : EndogenousOrderSystem OnlineWeightWitness.OWItem ScopeMode ScopeS ScopeObs
        ScopeDist ScopeInt ScopeExt Unit Unit CourseNashObstructionWitness.NashAct
        CourseNashObstructionWitness.NashForm CourseNashObstructionWitness.NashCond) =>
      ∀ t, s.updater.posAt s.feedback t .victim = 0)
    hz (region := firewallRegion) ⟨.clearer, .victim, fun h => h⟩
  have hNot := endogenousOrder_cannot_entail_unrestricted
    (fun (s : EndogenousOrderSystem OnlineWeightWitness.OWItem ScopeMode ScopeS ScopeObs
        ScopeDist ScopeInt ScopeExt Unit Unit CourseNashObstructionWitness.NashAct
        CourseNashObstructionWitness.NashForm CourseNashObstructionWitness.NashCond) =>
      ∀ t, s.updater.posAt s.feedback t .victim = 0)
    (Clearing.Formation.clearer) (OnlineWeightWitness.OWItem.victim) hz
  exact ⟨system.converged, hz,
    CourseNashObstructionWitness.witness_holds.2.2.2.2.2.2.2.2.1,
    hAdm.2.1, hAdm.2.2,
    ⟨Clearing.center_not_derived.1, Clearing.center_not_derived.2.2.2.2.2.2.1⟩,
    hNot⟩

end EndogenousFirewallWitness

end Becoming.EndogenousOrder
