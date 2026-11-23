import Becoming.OpenComposition
import Becoming.AdaptiveLoops
import Becoming.FreeEnergyGuarantees
import Becoming.SetPointOptimum
import Becoming.Optimum
import Becoming.Continuation
import Becoming.SelectionPool
import Becoming.StockFlowBridge
import Becoming.PacedStock
import Becoming.SampledSelection
import Becoming.ReadOffInTime
import Becoming.ReadingSchedule
import Becoming.CoreHelpers

/-!
# Unified Drawdown: Local Accounts, Pre-Overdraw Bridges, and Temporal Aliasing

AI-written (23 November 2026), Pillar L2 of the Lean sufficiency map (`Becoming.UnifiedDrawdown`).
Pure Lean `4.29.1` (`Init` only: zero `Std`, zero `Mathlib`, zero axioms, zero `sorry`).

## Architecture

1. **Localized Finite-Horizon Extensions (`namespace Becoming.Flow`)**:
   - `deficit_lowers_at`, `deficit_bounded_within`, `below_of_deficit_within`,
     `below_of_excess_within`, `family_deficit_ends_within`, and `held_excess_ends_within`:
     generalize `Continuation` and `SetPointOptimum` from global `Balances` / step-1 drop to
     finite pre-collapse prefixes `[T, T + n + k)` and explicit per-step deficit `d`.

2. **Part A — Parametric Accurate-Local-Accounts Joint Depletion & Pooled Recovery**:
   - `localError` and `parametric_local_accounts_depletion`: for any list of distinct agents
     holding private stores `fam i`, **proves** (never assumes) local store dynamics `storeEq`,
     identically zero prediction error `localError = 0`, zero choice risk `risk = 0`,
     `WithinOwn ∧ ¬ WithinJoint`, substrate unreadability (`¬ CoupledInto obs _ cSub` and
     `AlikeThroughAll` indistinguishability against safe counterfactuals agreeing on `fam i`),
     monotonic drain `(j₂ - j₁) * d`, and finite-horizon collapse `¬ active (n + k) g`.
   - `heldPair_as_parametric_instance`: recovers `Optimum.HeldPair.held_end` and
     `FreeEnergyGuarantees.SharedModels.held_not_one` as a `n = 2, d = 1` specialization.
   - `pooled_detects_before_collapse`, `RestraintAgentSpec`, `pooled_restraint_restores_viability`,
     and `restraint_adapter_restores_viability`: cleanly separates `obs`-pooling
     (`SelectionPool.Web.member_separates_all`) from structural monitor admission
     (`ReadOffInTime.Web.FirstApart`, `ReadableInTime`, `NoReturnAt.recoverable_iff`), and
     bridges multi-agent finite-lag restraint into `AdaptiveLoops.assume_guarantee_joint_viable`.

3. **Part B — Localized Pre-Overdraw Bridge & Exact Overdraw Separation**:
   - `activeUnitWeb`, `lineActiveWeb`, `wayActiveWeb` with `RegimeMargin.Gated giving m`
     (and `m = 1` corollaries from `RegimeMargin.FromNothing giving`).
   - `line_below_of_excess_of_within`, `line_below_of_excess_of_goes`,
     `way_below_of_excess_of_within`, `way_below_of_excess_of_goes`,
     `line_family_excess_ends`, `way_family_excess_ends`,
     `line_excess_terminates_goes`, and `way_excess_terminates_goes`.
   - `FirstOverdraw`, `exists_firstOverdraw`, `unit_balancesOn_iff_le`,
     `unit_overdraw_separation`, `line_overdraw_separation`, `way_overdraw_separation`,
     and concrete `OverdrawSeparationWitness` proving global `Balances` fails at `t* → t* + 1`.

4. **Part C — Non-Trivial Temporal-Aliasing & Sampling Obstructions**:
   - **C1 (Transient-Break Concealment & Fragility):** `sampled_break_concealment`,
     `logistic_sampled_break_concealment` (any optimum `x` on `σ 0 = 0, σ 1 = n + 2`),
     `logistic_periodic_sampled_break_concealment` (explicit cyclic `x (t % (n + 2))` for `∀ s`),
     and `sampled_recovery_hides_fragility` (multi-epoch break-plus-regrowth draining an
     uncoupled reserve `cFrag`).
   - **C2 (Strobe / Cadence Erasure):** `ReadsAt`, `sigmaOdd`, `strobe_readAtSpanEnd`,
     `cadence_erases_timely_recovery`, `strobe_schedule_erases_window`, and the concrete 6-step
     `CadenceErasureWitness`.
   - **C3 (Coupling-Depth Sampled Deadline):** `PacedLowerDrawWhileMet`,
     `lagDraw_one_of_lower`, `sampled_deadline_impossibility_at`,
     `sampled_deadline_impossibility_lag1`, `sampled_deadline_impossibility` (universal `pacedCourse`
     collapse + arbitrary span `σ j` + `ReadOffInTime` `NoReturnAt.recoverable_iff` /
     `too_late_of_alike`), and `unrecoverable_cadence_bridge`.

5. **Empirical Recognition & Non-Implications (`Significance.ReadsOnlyDynamics.not_entails`)**:
   - `unifiedDrawdown_readsOnlyDynamics`, `unifiedDrawdown_not_entails`,
     `witnessed_dynamics_not_entails`, and `SpineHooks` bundles for `L5` (`AlignmentSpine`).

6. **Native `L0` Open-Interface Composition Bridge (`namespace OpenCompositionBridge`)**:
   - Lifts `restraintLoop` / `restraintCert` into `OpenComposition.OpenComponent` and
     `OpenComposition.InterfaceContract`, folds non-empty finite agent families inductively via
     `OpenComponent.compose` and `composeContract`, proves exact `specSum` / `specMax` and global
     `close_contract_kernel` viability, and certifies single-member upgrades via `ContractRefines`
     and `replace_left_viable` without re-checking the rest of the fleet.

By `AGENTS.md` Rule 2 and `Significance.ReadsOnlyDynamics.not_entails`, whether any actual system
meets these premises is an empirical recognition outside Lean; no theorem here implies an "ought".
-/

namespace Becoming

/-! ## 1. Localized Finite-Horizon Extensions (`Becoming.Flow`) -/

namespace Flow

theorem deficit_lowers_at {F C : Type} {L : Flow F C} {W : Web F C} {ds : List C} {t d : Nat}
    (balances : L.BalancesOn W ds t)
    (deficit : L.replenishment ds t + d ≤ L.uptake ds t) :
    W.stock ds (t + 1) + d ≤ W.stock ds t :=
  le_of_add_le_add_right (L.replenishment ds t)
    (Nat.le_trans
      (Nat.le_of_eq ((Nat.add_assoc (W.stock ds (t + 1)) d (L.replenishment ds t)).trans
        (congrArg (W.stock ds (t + 1) + ·) (Nat.add_comm d (L.replenishment ds t)))))
      (Nat.le_trans (Nat.add_le_add_left deficit (W.stock ds (t + 1)))
        (Nat.le_of_eq balances.over)))

theorem deficit_bounded_prefix {F C : Type} {L : Flow F C} {W : Web F C} {ds : List C} {T d : Nat} :
    ∀ n, (∀ k, k < n → L.BalancesOn W ds (T + k)) →
      (∀ k, k < n → L.replenishment ds (T + k) + d ≤ L.uptake ds (T + k)) →
      W.stock ds (T + n) + n * d ≤ W.stock ds T
  | 0, _, _ => by
    rw [Nat.zero_mul, Nat.add_zero, Nat.add_zero]
    exact Nat.le_refl _
  | n + 1, balances, deficit => by
    have stepAt := deficit_lowers_at (balances n (Nat.lt_succ_self n)) (deficit n (Nat.lt_succ_self n))
    have earlier := deficit_bounded_prefix n (fun k lt => balances k (Nat.lt_succ_of_lt lt))
      (fun k lt => deficit k (Nat.lt_succ_of_lt lt))
    rw [Nat.succ_mul, Nat.add_comm (n * d) d, ← Nat.add_assoc, ← Nat.add_assoc T n 1]
    exact Nat.le_trans (Nat.add_le_add_right stepAt (n * d)) earlier

theorem deficit_bounded_within {F C : Type} {L : Flow F C} {W : Web F C} {ds : List C}
    {T n d : Nat}
    (balances : ∀ k, k < n → L.BalancesOn W ds (T + k))
    (deficit : ∀ k, k < n → L.replenishment ds (T + k) + d ≤ L.uptake ds (T + k)) :
    W.stock ds (T + n) + n * d ≤ W.stock ds T ∧
      ∀ j₁ j₂, j₁ ≤ j₂ → j₂ ≤ n → W.stock ds (T + j₂) + (j₂ - j₁) * d ≤ W.stock ds (T + j₁) :=
  ⟨deficit_bounded_prefix n balances deficit, fun j₁ j₂ le12 le2n =>
    match le_dest le12 with
    | ⟨delta, eqJ2⟩ => by
      have subEq : j₂ - j₁ = delta := by
        rw [eqJ2, Naturals.add_sub_cancel_left]
      rw [subEq, eqJ2, ← Nat.add_assoc T j₁ delta]
      exact deficit_bounded_prefix delta
        (fun k lt => by
          rw [Nat.add_assoc T j₁ k]
          exact balances (j₁ + k) (Nat.lt_of_lt_of_le (Nat.add_lt_add_left lt j₁) (eqJ2 ▸ le2n)))
        (fun k lt => by
          rw [Nat.add_assoc T j₁ k]
          exact deficit (j₁ + k) (Nat.lt_of_lt_of_le (Nat.add_lt_add_left lt j₁) (eqJ2 ▸ le2n)))⟩

theorem below_of_deficit_within {F C : Type} {L : Flow F C} {W : Web F C} {ds : List C}
    {m T n d : Nat}
    (balances : ∀ k, k < n → L.BalancesOn W ds (T + k))
    (deficit : ∀ k, k < n → L.replenishment ds (T + k) + d ≤ L.uptake ds (T + k))
    (start : W.stock ds T < n * d + m) :
    W.stock ds (T + n) < m :=
  Naturals.lt_of_add_lt_add_left (k := n * d)
    (Nat.lt_of_le_of_lt
      (Nat.le_trans (Nat.le_of_eq (Nat.add_comm (n * d) (W.stock ds (T + n))))
        (deficit_bounded_prefix n balances deficit))
      start)

theorem below_of_excess_within {F C : Type} {L : Flow F C} {W : Web F C} {ds : List C}
    {m T n : Nat}
    (balances : ∀ k, k < n → L.BalancesOn W ds (T + k))
    (excess : ∀ k, k < n → L.replenishment ds (T + k) < L.uptake ds (T + k))
    (start : W.stock ds T < n + m) :
    W.stock ds (T + n) < m :=
  below_of_deficit_within (d := 1) balances (fun k lt => excess k lt)
    (Nat.lt_of_lt_of_le start (Nat.le_of_eq (congrArg (· + m) (Nat.mul_one n).symm)))

theorem family_deficit_ends_within {F C : Type} {L : Flow F C} {W : Web F C} {ds : List C}
    {m T n k d : Nat} {g : F} {e : C}
    (balances : ∀ j, j < n + k → L.BalancesOn W ds (T + j))
    (gated : ∀ j f, j < n + k → f ∈ L.present (T + j) → ∀ d', d' ∈ ds → 0 < L.give (T + j) f d' →
      ∃ e', e' ∈ ds ∧ W.requires (T + j) f e' ∧ m ≤ W.need (T + j) f e')
    (givers : ∀ j, j < n + k → ∀ d', d' ∈ ds → L.GiversSupported W (T + j) d')
    (deficit : ∀ j, j < n → L.replenishment ds (T + j) + d ≤ L.uptake ds (T + j))
    (start : W.stock ds T < n * d + m)
    (dependent : W.active (T + n + k) g → W.Supported (T + n + k) g) (inside : e ∈ ds) :
    W.requires (T + n + k) g e → m ≤ W.need (T + n + k) g e → ¬ W.active (T + n + k) g :=
  have early : ∀ j, j < n → j < n + k := fun _ lt => Nat.lt_of_lt_of_le lt (Nat.le_add_right n k)
  have shift : ∀ j, j < k → n + j < n + k := fun _ lt => Nat.add_lt_add_left lt n
  have low : W.stock ds (T + n) < m :=
    below_of_deficit_within (fun j lt => balances j (early j lt)) deficit start
  family_ends_below_at dependent (family_stays_below_at (T := T + n) low k
    (fun j lt => Eq.subst (motive := fun s => L.BalancesOn W ds s) (Nat.add_assoc T n j).symm
      (balances (n + j) (shift j lt)))
    (fun j f lt => Eq.subst (motive := fun s => f ∈ L.present s → ∀ d', d' ∈ ds →
        0 < L.give s f d' → ∃ e', e' ∈ ds ∧ W.requires s f e' ∧ m ≤ W.need s f e')
      (Nat.add_assoc T n j).symm (gated (n + j) f (shift j lt)))
    (fun j lt => Eq.subst (motive := fun s => ∀ d', d' ∈ ds → L.GiversSupported W s d')
      (Nat.add_assoc T n j).symm (givers (n + j) (shift j lt)))) inside

theorem held_excess_ends_within {F C : Type} [DecidableEq F] {L : Flow F C} {W : Web F C}
    {c : C} {m T n k d : Nat} {g : F} (dPos : 0 < d)
    {holders : F → Bool} {fam : F → List C} {lose : Nat → F → Nat}
    (balancesC : ∀ j, j < n + k → L.BalancesOn W [c] (T + j))
    (balancesFam : ∀ j, j < n → ∀ h, h ∈ L.present (T + j) → holders h = true →
      L.BalancesOn W (fam h) (T + j))
    (gated : ∀ j f, j < n + k → f ∈ L.present (T + j) → 0 < L.give (T + j) f c →
      W.requires (T + j) f c ∧ m ≤ W.need (T + j) f c)
    (givers : ∀ j, j < n + k → L.GiversSupported W (T + j) c)
    (distinct : ∀ j, j < n → Distinct (L.present (T + j)))
    (alone : ∀ j, j < n → ∀ h, h ∈ L.present (T + j) → holders h = true →
      ∀ q, q ∈ L.present (T + j) → ¬ q = h → ∀ x, x ∈ fam h →
        L.take (T + j) q x = 0 ∧ L.give (T + j) q x = 0)
    (held : ∀ j, j < n → ∀ h, h ∈ L.present (T + j) → holders h = true →
      W.stock (fam h) (T + j + 1) = W.stock (fam h) (T + j))
    (loses : ∀ j, j < n → ∀ h, h ∈ L.present (T + j) → holders h = true →
      lose (T + j) h + total (fam h) (L.give (T + j) h) + L.give (T + j) h c ≤
        total (fam h) (L.take (T + j) h) + L.take (T + j) h c)
    (exceeds : ∀ j, j < n → L.restGiven holders (T + j) c + d ≤
      total (L.present (T + j)) fun h => bif holders h then lose (T + j) h else 0)
    (start : W.level T c < n * d + m)
    (dependent : W.active (T + n + k) g → W.Supported (T + n + k) g)
    (req : W.requires (T + n + k) g c) (needGe : m ≤ W.need (T + n + k) g c)
    {obs : F → C → Prop}
    (listed : ∀ h x, holders h = true → W.CoupledInto obs h x → x ∈ fam h)
    (apart : ∀ h, holders h = true → ¬ c ∈ fam h) :
    ¬ W.active (T + n + k) g ∧
      W.level (T + n) c < m ∧
      (∀ j₁ j₂, j₁ ≤ j₂ → j₂ ≤ n → W.level (T + j₂) c + (j₂ - j₁) * d ≤ W.level (T + j₁) c) ∧
      (∀ j₁ j₂, j₁ < j₂ → j₂ ≤ n → W.level (T + j₂) c < W.level (T + j₁) c) ∧
      ∀ h, holders h = true → ¬ W.CoupledInto obs h c := by
  have deficitStep : ∀ j, j < n → L.replenishment [c] (T + j) + d ≤ L.uptake [c] (T + j) := by
    intro j below
    have draws : ∀ h, h ∈ L.present (T + j) →
        (bif holders h then lose (T + j) h + L.give (T + j) h c else 0) ≤
          (bif holders h then L.take (T + j) h c else 0) := fun h mem => by
      cases holds : holders h
      · exact Nat.le_refl 0
      · exact held_draws (balancesFam j below h mem holds) (distinct j below) mem
          (alone j below h mem holds) (held j below h mem holds) (loses j below h mem holds)
    have split : (total (L.present (T + j)) fun h =>
        bif holders h then lose (T + j) h + L.give (T + j) h c else 0) =
        (total (L.present (T + j)) fun h => bif holders h then lose (T + j) h else 0) +
          total (L.present (T + j)) fun h => bif holders h then L.give (T + j) h c else 0 :=
      (total_congr (fun h => by cases holders h <;> rfl) _).trans (total_add _ _ _)
    have takenEq := total_split holders (fun h => L.take (T + j) h c) (L.present (T + j))
    have givenEq := total_split holders (fun h => L.give (T + j) h c) (L.present (T + j))
    have hGiven : L.given (T + j) c + d ≤ L.taken (T + j) c := by
      have step1 : L.given (T + j) c + d =
          L.restGiven holders (T + j) c +
            total (L.present (T + j)) (fun h => bif holders h then L.give (T + j) h c else 0) + d :=
        congrArg (· + d) givenEq
      have step2 : L.restGiven holders (T + j) c +
            total (L.present (T + j)) (fun h => bif holders h then L.give (T + j) h c else 0) + d =
          L.restGiven holders (T + j) c + d +
            total (L.present (T + j)) (fun h => bif holders h then L.give (T + j) h c else 0) :=
        Nat.add_right_comm _ _ _
      have step3 : L.restGiven holders (T + j) c + d +
            total (L.present (T + j)) (fun h => bif holders h then L.give (T + j) h c else 0) ≤
          (total (L.present (T + j)) fun h => bif holders h then lose (T + j) h else 0) +
            total (L.present (T + j)) (fun h => bif holders h then L.give (T + j) h c else 0) :=
        Nat.add_le_add_right (exceeds j below) _
      have step4 : (total (L.present (T + j)) fun h =>
            bif holders h then lose (T + j) h + L.give (T + j) h c else 0) ≤
          L.taken (T + j) c :=
        Nat.le_trans (total_le _ draws) (Nat.le_trans (Nat.le_add_left _ _) (Nat.le_of_eq takenEq.symm))
      exact Nat.le_trans (Nat.le_of_eq (step1.trans step2))
        (Nat.le_trans step3 (Nat.le_trans (Nat.le_of_eq split.symm) step4))
    show L.given (T + j) c + 0 + d ≤ L.taken (T + j) c + 0
    rw [Nat.add_zero, Nat.add_zero]
    exact hGiven
  have early : ∀ j, j < n → j < n + k := fun _ lt => Nat.lt_of_lt_of_le lt (Nat.le_add_right n k)
  have hBounded := deficit_bounded_within (fun j lt => balancesC j (early j lt)) deficitStep
  have hLow : W.level (T + n) c < m :=
    below_of_deficit_within (ds := [c]) (fun j lt => balancesC j (early j lt)) deficitStep start
  have hEnds : ¬ W.active (T + n + k) g :=
    family_deficit_ends_within balancesC
      (fun j f lt mem => gate_single (gated j f lt mem))
      (fun j lt => of_single (givers j lt))
      deficitStep start dependent (.head []) req needGe
  refine ⟨hEnds, hLow, ?_, ?_, fun h holds couples => apart h holds (listed h c holds couples)⟩
  · intro j₁ j₂ le12 le2n
    exact hBounded.2 j₁ j₂ le12 le2n
  · intro j₁ j₂ lt12 le2n
    have hDiffPos : 0 < j₂ - j₁ := SupportGated.sub_pos_of_lt lt12
    have hMulPos : 0 < (j₂ - j₁) * d := by
      have h1 : 1 * d ≤ (j₂ - j₁) * d := Nat.mul_le_mul_right d hDiffPos
      rw [Nat.one_mul] at h1
      exact Nat.lt_of_lt_of_le dPos h1
    have hBound := hBounded.2 j₁ j₂ (Nat.le_of_lt lt12) le2n
    have hLe : W.level (T + j₂) c + (j₂ - j₁) * d ≤ W.level (T + j₁) c := hBound
    exact Nat.lt_of_lt_of_le
      (Nat.lt_of_lt_of_le (Nat.add_lt_add_left hMulPos (W.level (T + j₂) c))
        (Nat.le_of_eq (Nat.add_zero _)))
      hLe

end Flow

/-! ## 2. Main Namespace: `Becoming.UnifiedDrawdown` -/

namespace UnifiedDrawdown

/-! ### Pure Prelude List, Lookup, and Decision Helpers -/

def eraseOne {F : Type} [DecidableEq F] (x : F) : List F → List F
  | [] => []
  | y :: ys => if y = x then ys else y :: eraseOne x ys

theorem mem_eraseOne_of_ne {F : Type} [DecidableEq F] {a x : F} (ne : a ≠ x) :
    ∀ {l : List F}, a ∈ l → a ∈ eraseOne x l
  | [], m => nomatch m
  | y :: ys, m => by
    show a ∈ (if y = x then ys else y :: eraseOne x ys)
    cases h : decEq y x with
    | isTrue same =>
      rw [if_pos same]
      cases m with
      | head => exact absurd same ne
      | tail _ m' => exact m'
    | isFalse other =>
      rw [if_neg other]
      cases m with
      | head => exact .head _
      | tail _ m' => exact .tail y (mem_eraseOne_of_ne ne m')

theorem total_eraseOne {F : Type} [DecidableEq F] (q : F → Nat) {x : F} :
    ∀ {l : List F}, x ∈ l → total (eraseOne x l) q + q x = total l q
  | [], m => nomatch m
  | y :: ys, m => by
    show total (if y = x then ys else y :: eraseOne x ys) q + q x = q y + total ys q
    cases h : decEq y x with
    | isTrue same =>
      rw [if_pos same, same, Nat.add_comm]
    | isFalse other =>
      rw [if_neg other]
      cases m with
      | head => exact absurd rfl other
      | tail _ m' =>
        have ih := total_eraseOne q m'
        show q y + total (eraseOne x ys) q + q x = q y + total ys q
        rw [Nat.add_assoc, ih]

theorem total_map_le {α F : Type} [DecidableEq F] :
    ∀ {agents : List α}, Distinct agents →
      ∀ {P : List F} {toF : α → F},
      (∀ i j, i ∈ agents → j ∈ agents → toF i = toF j → i = j) →
      (∀ i, i ∈ agents → toF i ∈ P) → (q : F → Nat) →
      total agents (fun i => q (toF i)) ≤ total P q
  | [], _, _, _, _, _, _ => Nat.zero_le _
  | a :: rest, ⟨fresh, dist⟩, P, toF, injOn, memP, q => by
    have memA : toF a ∈ P := memP a (.head rest)
    have memRest : ∀ i, i ∈ rest → toF i ∈ eraseOne (toF a) P := fun i mi =>
      have neq : toF i ≠ toF a := fun same =>
        fresh (injOn i a (.tail a mi) (.head rest) same ▸ mi)
      mem_eraseOne_of_ne neq (memP i (.tail a mi))
    have ih := total_map_le dist
      (fun i j mi mj => injOn i j (.tail a mi) (.tail a mj)) memRest q
    have hSplit : total (eraseOne (toF a) P) q + q (toF a) = total P q := total_eraseOne q memA
    show q (toF a) + total rest (fun i => q (toF i)) ≤ total P q
    rw [← hSplit, Nat.add_comm (q (toF a))]
    exact Nat.add_le_add_right ih (q (toF a))

theorem total_only_eq {α : Type} [DecidableEq α] {q : α → Nat} {a : α} {l : List α}
    (distinct : Distinct l) (mem : a ∈ l) (only : ∀ b, b ∈ l → ¬ b = a → q b = 0) :
    total l q = q a :=
  Nat.le_antisymm (Optimum.total_le_of_only distinct only) (le_total_of_mem mem)

def lookupBy {α F : Type} [DecidableEq F] (toF : α → F) (val : α → Nat) : List α → F → Nat
  | [], _ => 0
  | a :: rest, f => if toF a = f then val a else lookupBy toF val rest f

theorem lookupBy_eq_of_mem {α F : Type} [DecidableEq F] {toF : α → F} (val : α → Nat) :
    ∀ {agents : List α},
      (∀ i j, i ∈ agents → j ∈ agents → toF i = toF j → i = j) →
      ∀ {i : α}, i ∈ agents → lookupBy toF val agents (toF i) = val i
  | [], _, _, mi => nomatch mi
  | a :: rest, injOn, i, mi => by
    show (if toF a = toF i then val a else lookupBy toF val rest (toF i)) = val i
    cases h : decEq (toF a) (toF i) with
    | isTrue same =>
      rw [if_pos same]
      exact congrArg val (injOn a i (.head rest) mi same)
    | isFalse other =>
      rw [if_neg other]
      cases mi with
      | head => exact absurd rfl other
      | tail _ mi' =>
        exact lookupBy_eq_of_mem val (fun x y mx my => injOn x y (.tail a mx) (.tail a my)) mi'

theorem sumDraws_eq_total {α : Type} (agents : List α) (f : α → Nat) :
    AdaptiveLoops.sumDraws agents (fun i _ => f i) () = total agents f := by
  induction agents with
  | nil => rfl
  | cons _ _ ih => exact congrArg (_ + ·) ih

def holdersOf {α F : Type} [DecidableEq F] (agents : List α) (toF : α → F) (f : F) : Bool :=
  agents.any (fun i => decide (toF i = f))

theorem holdersOf_true_iff {α F : Type} [DecidableEq F]
    {agents : List α} {toF : α → F} {f : F} :
    holdersOf agents toF f = true ↔ ∃ i, i ∈ agents ∧ toF i = f :=
  ListTests.any_true_iff.trans
    ⟨fun ⟨i, mi, hd⟩ => ⟨i, mi, of_decide_eq_true hd⟩,
     fun ⟨i, mi, eq⟩ => ⟨i, mi, decide_eq_true eq⟩⟩

theorem holdersOf_mem {α F : Type} [DecidableEq F]
    {agents : List α} {toF : α → F} {i : α} (mem : i ∈ agents) :
    holdersOf agents toF (toF i) = true :=
  holdersOf_true_iff.mpr ⟨i, mem, rfl⟩

theorem dec_all_or_exists {P : Nat → Prop} (dec : ∀ t, P t ∨ ¬ P t) :
    ∀ n, (∀ t, t < n → P t) ∨ ∃ t, t < n ∧ ¬ P t
  | 0 => Or.inl fun _ lt => absurd lt (Nat.not_lt_zero _)
  | n + 1 =>
    match dec_all_or_exists dec n with
    | .inr ⟨t, lt, hnt⟩ => Or.inr ⟨t, Nat.lt_succ_of_lt lt, hnt⟩
    | .inl allN =>
      match dec n with
      | .inl hn => Or.inl fun t lt =>
        (Nat.lt_or_eq_of_le (Nat.le_of_lt_succ lt)).elim (allN t) fun eq => eq ▸ hn
      | .inr hnn => Or.inr ⟨n, Nat.lt_succ_self n, hnn⟩

/-! ### Part A: Parametric Local Accounts, Zero Error/Risk, Depletion, and Pooled Recovery -/

/-- Local predictive discrepancy between a chooser's prediction and the next local view. -/
def localError (ch : FreeEnergyGuarantees.RiskAndNeeds.Chooser Nat)
    (view draw : Nat → Nat) (t : Nat) : Nat :=
  gap (ch.predict (view t) (draw t)) (view (t + 1))

/-- **Part A1 (`parametric_local_accounts_depletion`).**
For an arbitrary finite list of distinct agents `agents` holding private stores `fam i` away from a
shared substrate `cSub`:
- **Derives** (without assuming `storeEq`) local store transition conservation `storeEq`, exact
  draw equality `L.take t (toF i) cSub = lose i`, identically zero local prediction error
  `localError = 0`, and zero choice risk `risk = 0` from local exchange conservation `exchangeEq`,
  `BalancesOn (fam i)`, `alone`, `held`, `prefEq`, and `menuMem`.
- **Proves** individual headroom `L.WithinOwn` alongside joint overdraw `¬ L.WithinJoint`,
  uncoupled substrate blindness (`¬ W.CoupledInto obs (toF i) cSub` and `AlikeThroughAll`
  indistinguishability against safe counterfactuals agreeing on `fam i`), monotonic substrate
  drain at rate `d`, `W.level n cSub < m`, and finite-horizon collapse `¬ W.active (n + k) g`. -/
theorem parametric_local_accounts_depletion {α F C : Type} [DecidableEq F]
    {L : Flow F C} {W : Web F C} {obs : F → C → Prop}
    {agents : List α} (distinctA : Distinct agents)
    (toF : α → F) (injOn : ∀ i j, i ∈ agents → j ∈ agents → toF i = toF j → i = j)
    (fam : α → List C) (cSub : C) (lose : α → Nat)
    (model : (i : α) → FreeEnergyGuarantees.RiskAndNeeds.Chooser Nat)
    {n k m d : Nat} {g : F} (dPos : 0 < d)
    (present : ∀ t, t < n → ∀ i, i ∈ agents → toF i ∈ L.present t)
    (distinctP : ∀ t, t < n → Distinct (L.present t))
    (balancesC : ∀ j, j < n + k → L.BalancesOn W [cSub] j)
    (balancesFam : ∀ t, t < n → ∀ i, i ∈ agents → L.BalancesOn W (fam i) t)
    (gated : ∀ j f, j < n + k → f ∈ L.present j → 0 < L.give j f cSub →
      W.requires j f cSub ∧ m ≤ W.need j f cSub)
    (givers : ∀ j, j < n + k → L.GiversSupported W j cSub)
    (alone : ∀ t, t < n → ∀ i, i ∈ agents → ∀ q, q ∈ L.present t → ¬ q = toF i →
      ∀ x, x ∈ fam i → L.take t q x = 0 ∧ L.give t q x = 0)
    (held : ∀ t, t < n → ∀ i, i ∈ agents → W.stock (fam i) (t + 1) = W.stock (fam i) t)
    (giveZero : ∀ t, t < n → ∀ i, i ∈ agents → L.give t (toF i) cSub = 0)
    (exchangeEq : ∀ t, t < n → ∀ i, i ∈ agents →
      lose i + total (fam i) (L.give t (toF i)) + L.give t (toF i) cSub =
        total (fam i) (L.take t (toF i)) + L.take t (toF i) cSub)
    (predictEq : ∀ i s a, (model i).predict s a = s + a - lose i)
    (choiceEq : ∀ t, t < n → ∀ i, i ∈ agents →
      L.take t (toF i) cSub = (model i).chosen (W.stock (fam i) t))
    (prefEq : ∀ t, t < n → ∀ i, i ∈ agents → (model i).preferred = W.stock (fam i) t)
    (menuMem : ∀ i, i ∈ agents → lose i = (model i).first ∨ lose i ∈ (model i).others)
    (ownHeadroom : ∀ t, t < n → ∀ i, i ∈ agents → L.take t (toF i) cSub ≤ L.given t cSub)
    (otherHeadroom : ∀ t, t < n → ∀ q, q ∈ L.present t →
      (∀ i, i ∈ agents → q ≠ toF i) → L.take t q cSub ≤ L.given t cSub)
    (exceeds : ∀ t, t < n →
      L.restGiven (holdersOf agents toF) t cSub + d ≤
        AdaptiveLoops.sumDraws agents (fun i _ => lose i) ())
    (start : W.level 0 cSub < n * d + m)
    (dependent : W.active (n + k) g → W.Supported (n + k) g)
    (req : W.requires (n + k) g cSub) (needGe : m ≤ W.need (n + k) g cSub)
    (listed : ∀ i x, i ∈ agents → W.CoupledInto obs (toF i) x → x ∈ fam i)
    (apart : ∀ i, i ∈ agents → ¬ cSub ∈ fam i) :
    (∀ t, t < n → ∀ i, i ∈ agents →
      W.stock (fam i) (t + 1) = W.stock (fam i) t + L.take t (toF i) cSub - lose i ∧
      L.take t (toF i) cSub = lose i ∧
      localError (model i) (fun u => W.stock (fam i) u) (fun u => L.take u (toF i) cSub) t = 0 ∧
      (model i).risk (W.stock (fam i) t) (L.take t (toF i) cSub) = 0) ∧
    (∀ t, t < n → L.WithinOwn t cSub ∧ ¬ L.WithinJoint t cSub) ∧
    (∀ i, i ∈ agents → ¬ W.CoupledInto obs (toF i) cSub) ∧
    (∀ l_safe : Nat → C → Nat,
      (∀ s, s ≤ n → ∀ i, i ∈ agents → ∀ x, x ∈ fam i → l_safe s x = W.level s x) →
      W.AlikeThroughAll obs (fun f => holdersOf agents toF f = true) W.level l_safe n ∧
      ∀ select, W.SelectsThroughAll obs (fun f => holdersOf agents toF f = true) n select →
        (select W.level ↔ select l_safe)) ∧
    W.level n cSub < m ∧
    (∀ t₁ t₂, t₁ ≤ t₂ → t₂ ≤ n → W.level t₂ cSub + (t₂ - t₁) * d ≤ W.level t₁ cSub) ∧
    (∀ t₁ t₂, t₁ < t₂ → t₂ ≤ n → W.level t₂ cSub < W.level t₁ cSub) ∧
    ¬ W.active (n + k) g := by
  let holders : F → Bool := holdersOf agents toF
  let famOf : F → List C := fun f =>
    match agents.find? (fun i => decide (toF i = f)) with
    | some i => fam i
    | none => []
  let loseOf : Nat → F → Nat := fun _ f => lookupBy toF lose agents f
  have famOf_eq : ∀ {i : α}, i ∈ agents → famOf (toF i) = fam i := fun {i} mi => by
    dsimp only [famOf]
    cases hfind : agents.find? (fun j => decide (toF j = toF i)) with
    | none =>
      have hNone := ListTests.find_none_iff.mp hfind i mi
      exact absurd (decide_eq_true rfl) (Bool.noConfusion ∘ hNone.symm.trans)
    | some j =>
      have mj := ListTests.mem_of_find_some hfind
      have eqF := of_decide_eq_true (ListTests.find_some (p := fun k => decide (toF k = toF i)) hfind)
      exact congrArg fam (injOn j i mj mi eqF)
  have storeDerived : ∀ t, t < n → ∀ i, i ∈ agents →
      W.stock (fam i) (t + 1) + lose i = W.stock (fam i) t + L.take t (toF i) cSub := by
    intro t ht i mi
    have hBal := (balancesFam t ht i mi).over
    have hUptake : L.uptake (fam i) t = total (fam i) (L.take t (toF i)) := by
      refine total_congr_on fun x mx => ?_
      exact total_only_eq (distinctP t ht) (present t ht i mi)
        fun q mq nq => (alone t ht i mi q mq nq x mx).1
    have hRepl : L.replenishment (fam i) t = total (fam i) (L.give t (toF i)) := by
      refine total_congr_on fun x mx => ?_
      exact total_only_eq (distinctP t ht) (present t ht i mi)
        fun q mq nq => (alone t ht i mi q mq nq x mx).2
    rw [hUptake, hRepl] at hBal
    have hEx := exchangeEq t ht i mi
    rw [giveZero t ht i mi, Nat.add_zero] at hEx
    have hSum : W.stock (fam i) (t + 1) + lose i + total (fam i) (L.take t (toF i)) =
        W.stock (fam i) t + L.take t (toF i) cSub + total (fam i) (L.take t (toF i)) := by
      calc W.stock (fam i) (t + 1) + lose i + total (fam i) (L.take t (toF i))
          = W.stock (fam i) (t + 1) + total (fam i) (L.take t (toF i)) + lose i :=
            Nat.add_right_comm _ _ _
        _ = W.stock (fam i) t + total (fam i) (L.give t (toF i)) + lose i :=
            congrArg (· + lose i) hBal
        _ = W.stock (fam i) t + (lose i + total (fam i) (L.give t (toF i))) := by
            rw [Nat.add_assoc, Nat.add_comm (total (fam i) (L.give t (toF i))) (lose i)]
        _ = W.stock (fam i) t + (total (fam i) (L.take t (toF i)) + L.take t (toF i) cSub) :=
            congrArg (W.stock (fam i) t + ·) hEx
        _ = W.stock (fam i) t + L.take t (toF i) cSub + total (fam i) (L.take t (toF i)) := by
            rw [Nat.add_comm (total (fam i) (L.take t (toF i))) (L.take t (toF i) cSub),
                ← Nat.add_assoc]
    exact add_right_cancel (total (fam i) (L.take t (toF i))) hSum
  have localProps : ∀ t, t < n → ∀ i, i ∈ agents →
      W.stock (fam i) (t + 1) = W.stock (fam i) t + L.take t (toF i) cSub - lose i ∧
      L.take t (toF i) cSub = lose i ∧
      localError (model i) (fun u => W.stock (fam i) u) (fun u => L.take u (toF i) cSub) t = 0 ∧
      (model i).risk (W.stock (fam i) t) (L.take t (toF i) cSub) = 0 := by
    intro t ht i mi
    have hEq := storeDerived t ht i mi
    have hHeld := held t ht i mi
    have hTakeEq : L.take t (toF i) cSub = lose i := by
      have hSub : W.stock (fam i) t + lose i = W.stock (fam i) t + L.take t (toF i) cSub :=
        (congrArg (· + lose i) hHeld.symm).trans hEq
      exact (Naturals.add_left_cancel hSub).symm
    have hStoreEq : W.stock (fam i) (t + 1) = W.stock (fam i) t + L.take t (toF i) cSub - lose i := by
      rw [← hEq, Naturals.add_sub_cancel]
    have hPred : (model i).predict (W.stock (fam i) t) (L.take t (toF i) cSub) =
        W.stock (fam i) (t + 1) := by
      rw [predictEq i (W.stock (fam i) t) (L.take t (toF i) cSub), hStoreEq]
    have hErr : localError (model i) (fun u => W.stock (fam i) u)
        (fun u => L.take u (toF i) cSub) t = 0 := by
      dsimp only [localError]
      rw [hPred]
      exact gap_self _
    have hRiskAtLose : (model i).risk (W.stock (fam i) t) (lose i) = 0 := by
      dsimp only [FreeEnergyGuarantees.RiskAndNeeds.Chooser.risk]
      rw [predictEq i (W.stock (fam i) t) (lose i), Naturals.add_sub_cancel, prefEq t ht i mi]
      exact gap_self _
    have hMin := (model i).chosen_minimizes (W.stock (fam i) t)
    have hLeRisk : (model i).risk (W.stock (fam i) t) ((model i).chosen (W.stock (fam i) t)) ≤
        (model i).risk (W.stock (fam i) t) (lose i) :=
      match menuMem i mi with
      | .inl eqFirst => eqFirst ▸ hMin.1
      | .inr memOthers => hMin.2 (lose i) memOthers
    have hRiskZero : (model i).risk (W.stock (fam i) t) (L.take t (toF i) cSub) = 0 := by
      rw [choiceEq t ht i mi]
      exact Nat.eq_zero_of_le_zero (Nat.le_trans hLeRisk (Nat.le_of_eq hRiskAtLose))
    exact ⟨hStoreEq, hTakeEq, hErr, hRiskZero⟩
  have exceedsHolders : ∀ j, j < n → L.restGiven holders (0 + j) cSub + d ≤
      total (L.present (0 + j)) fun h => bif holders h then loseOf (0 + j) h else 0 := by
    intro j hj
    rw [Nat.zero_add]
    have hMapLe : total agents (fun i =>
        (fun h => bif holders h then loseOf j h else 0) (toF i)) ≤
        total (L.present j) (fun h => bif holders h then loseOf j h else 0) :=
      total_map_le distinctA injOn (fun i mi => present j hj i mi)
        (fun h => bif holders h then loseOf j h else 0)
    have hCongr : total agents (fun i =>
        (fun h => bif holders h then loseOf j h else 0) (toF i)) = total agents lose := by
      refine total_congr_on fun i mi => ?_
      have hh : holders (toF i) = true := holdersOf_mem mi
      show (bif holders (toF i) then lookupBy toF lose agents (toF i) else 0) = lose i
      rw [hh]
      exact lookupBy_eq_of_mem lose injOn mi
    have hSum : AdaptiveLoops.sumDraws agents (fun i _ => lose i) () = total agents lose :=
      sumDraws_eq_total agents lose
    exact Nat.le_trans (exceeds j hj) (Nat.le_trans (Nat.le_of_eq (hSum.trans hCongr.symm)) hMapLe)
  have hHeldEnds := Flow.held_excess_ends_within (L := L) (W := W) (c := cSub) (m := m)
    (T := 0) (n := n) (k := k) (d := d) dPos (holders := holders) (fam := famOf)
    (lose := loseOf)
    (fun j lt => by rw [Nat.zero_add]; exact balancesC j lt)
    (fun j lt h _ mh => by
      rw [Nat.zero_add]
      rcases holdersOf_true_iff.mp mh with ⟨i, mi, eqF⟩
      rw [← eqF, famOf_eq mi]
      exact balancesFam j lt i mi)
    (fun j f lt => by rw [Nat.zero_add]; exact gated j f lt)
    (fun j lt => by rw [Nat.zero_add]; exact givers j lt)
    (fun j lt => by rw [Nat.zero_add]; exact distinctP j lt)
    (fun j lt h _ mh q mq nq x mx => by
      rw [Nat.zero_add] at mq ⊢
      rcases holdersOf_true_iff.mp mh with ⟨i, mi, eqF⟩
      rw [← eqF] at nq mx
      rw [famOf_eq mi] at mx
      exact alone j lt i mi q mq nq x mx)
    (fun j lt h _ mh => by
      rw [Nat.zero_add]
      rcases holdersOf_true_iff.mp mh with ⟨i, mi, eqF⟩
      rw [← eqF, famOf_eq mi]
      exact held j lt i mi)
    (fun j lt h _ mh => by
      rw [Nat.zero_add]
      rcases holdersOf_true_iff.mp mh with ⟨i, mi, eqF⟩
      have eqLose : loseOf (0 + j) h = lose i := by
        dsimp only [loseOf]
        rw [← eqF]
        exact lookupBy_eq_of_mem lose injOn mi
      rw [eqLose, ← eqF, famOf_eq mi]
      exact Nat.le_of_eq (exchangeEq j lt i mi))
    exceedsHolders
    start
    (by rw [Nat.zero_add]; exact dependent)
    (by rw [Nat.zero_add]; exact req)
    (by rw [Nat.zero_add]; exact needGe)
    (obs := obs)
    (fun h x mh couples => by
      rcases holdersOf_true_iff.mp mh with ⟨i, mi, eqF⟩
      rw [← eqF] at couples ⊢
      rw [famOf_eq mi]
      exact listed i x mi couples)
    (fun h mh mem => by
      rcases holdersOf_true_iff.mp mh with ⟨i, mi, eqF⟩
      rw [← eqF, famOf_eq mi] at mem
      exact apart i mi mem)
  have hWithinAndNotJoint : ∀ t, t < n → L.WithinOwn t cSub ∧ ¬ L.WithinJoint t cSub := by
    intro t ht
    refine ⟨fun f mf => ?_, fun joint => ?_⟩
    · by_cases hHold : holders f = true
      · rcases holdersOf_true_iff.mp hHold with ⟨i, mi, eqF⟩
        rw [← eqF]
        exact ownHeadroom t ht i mi
      · exact otherHeadroom t ht f mf fun i mi eqF =>
          hHold (eqF ▸ holdersOf_mem mi)
    · have hDraws : ∀ h, h ∈ L.present t →
          (bif holders h then loseOf t h + L.give t h cSub else 0) ≤
            (bif holders h then L.take t h cSub else 0) := fun h mh => by
        cases hh : holders h
        · exact Nat.le_refl 0
        · rcases holdersOf_true_iff.mp hh with ⟨i, mi, eqF⟩
          have eqLose : loseOf t h = lose i := by
            dsimp only [loseOf]; rw [← eqF]; exact lookupBy_eq_of_mem lose injOn mi
          have bFam : L.BalancesOn W (famOf h) t := by
            rw [← eqF, famOf_eq mi]; exact balancesFam t ht i mi
          have aFam : ∀ q, q ∈ L.present t → ¬ q = h → ∀ x, x ∈ famOf h →
              L.take t q x = 0 ∧ L.give t q x = 0 := fun q mq nq x mx => by
            rw [← eqF] at nq mx; rw [famOf_eq mi] at mx
            exact alone t ht i mi q mq nq x mx
          have hFam : W.stock (famOf h) (t + 1) = W.stock (famOf h) t := by
            rw [← eqF, famOf_eq mi]; exact held t ht i mi
          have lFam : loseOf t h + total (famOf h) (L.give t h) + L.give t h cSub ≤
              total (famOf h) (L.take t h) + L.take t h cSub := by
            rw [eqLose, ← eqF, famOf_eq mi]
            exact Nat.le_of_eq (exchangeEq t ht i mi)
          exact Flow.held_draws bFam (distinctP t ht) mh aFam hFam lFam
      have split : (total (L.present t) fun h =>
          bif holders h then loseOf t h + L.give t h cSub else 0) =
          (total (L.present t) fun h => bif holders h then loseOf t h else 0) +
            total (L.present t) fun h => bif holders h then L.give t h cSub else 0 :=
        (total_congr (fun h => Bool.casesOn
          (motive := fun b => (bif b then loseOf t h + L.give t h cSub else 0) =
            (bif b then loseOf t h else 0) + (bif b then L.give t h cSub else 0))
          (holders h) rfl rfl) (L.present t)).trans (total_add _ _ _)
      have takenEq := total_split holders (fun h => L.take t h cSub) (L.present t)
      have givenEq := total_split holders (fun h => L.give t h cSub) (L.present t)
      have hExc := exceedsHolders t ht
      rw [Nat.zero_add] at hExc
      have hGt : L.given t cSub + d ≤ L.taken t cSub := by
        have s1 : L.given t cSub + d =
            L.restGiven holders t cSub + d +
              total (L.present t) (fun h => bif holders h then L.give t h cSub else 0) :=
          (congrArg (· + d) givenEq).trans (Nat.add_right_comm _ _ _)
        have s2 : L.restGiven holders t cSub + d +
              total (L.present t) (fun h => bif holders h then L.give t h cSub else 0) ≤
            total (L.present t) (fun h => bif holders h then loseOf t h + L.give t h cSub else 0) :=
          Nat.le_trans (Nat.add_le_add_right hExc _) (Nat.le_of_eq split.symm)
        have s3 : total (L.present t) (fun h => bif holders h then loseOf t h + L.give t h cSub else 0) ≤
            L.taken t cSub :=
          Nat.le_trans (total_le _ hDraws) (Nat.le_trans (Nat.le_add_left _ _) (Nat.le_of_eq takenEq.symm))
        exact Nat.le_trans (Nat.le_of_eq s1) (Nat.le_trans s2 s3)
      have hLt : L.given t cSub < L.taken t cSub :=
        Nat.lt_of_lt_of_le (Nat.add_lt_add_left dPos (L.given t cSub))
          (Nat.le_trans (Nat.le_of_eq (Nat.add_zero _)) hGt)
      exact Nat.not_le_of_gt hLt joint
  have hNotCoupled : ∀ i, i ∈ agents → ¬ W.CoupledInto obs (toF i) cSub := fun i mi =>
    hHeldEnds.2.2.2.2 (toF i) (holdersOf_mem mi)
  have hAlike : ∀ l_safe : Nat → C → Nat,
      (∀ s, s ≤ n → ∀ i, i ∈ agents → ∀ x, x ∈ fam i → l_safe s x = W.level s x) →
      W.AlikeThroughAll obs (fun f => holdersOf agents toF f = true) W.level l_safe n ∧
      ∀ select, W.SelectsThroughAll obs (fun f => holdersOf agents toF f = true) n select →
        (select W.level ↔ select l_safe) := by
    intro l_safe hSafeEq
    have hAll : W.AlikeThroughAll obs (fun f => holdersOf agents toF f = true) W.level l_safe n := by
      intro f hf s hs
      rcases holdersOf_true_iff.mp hf with ⟨i, mi, eqF⟩
      rw [← eqF]
      refine ⟨⟨fun admits c hreq => ?_, fun admits c hreq => ?_⟩, fun c hobs => ?_⟩
      · have hcMem : c ∈ fam i := listed i c mi (.inl ⟨s, hreq⟩)
        rw [hSafeEq s hs i mi c hcMem]
        exact admits c hreq
      · have hcMem : c ∈ fam i := listed i c mi (.inl ⟨s, hreq⟩)
        rw [← hSafeEq s hs i mi c hcMem]
        exact admits c hreq
      · have hcMem : c ∈ fam i := listed i c mi (.inr hobs)
        exact (hSafeEq s hs i mi c hcMem).symm
    refine ⟨hAll, fun select hSel => hSel W.level l_safe hAll⟩
  refine ⟨localProps, hWithinAndNotJoint, hNotCoupled, hAlike, ?_, ?_, ?_, ?_⟩
  · have h := hHeldEnds.2.1; rw [Nat.zero_add] at h; exact h
  · intro t₁ t₂ h12 h2n
    have h := hHeldEnds.2.2.1 t₁ t₂ h12 h2n
    rw [Nat.zero_add, Nat.zero_add] at h
    exact h
  · intro t₁ t₂ h12 h2n
    have h := hHeldEnds.2.2.2.1 t₁ t₂ h12 h2n
    rw [Nat.zero_add, Nat.zero_add] at h
    exact h
  · have h := hHeldEnds.1; rw [Nat.zero_add] at h; exact h

/-- **Part A2 (`heldPair_as_parametric_instance`).**
Instantiates `parametric_local_accounts_depletion` at `Optimum.HeldPair` and
`FreeEnergyGuarantees.SharedModels.holder` (`agents := [.first, .second]`, `d := 1`, `n := 2`,
`m := 1`), directly recovering `Optimum.HeldPair.held_end` and the core properties of
`FreeEnergyGuarantees.SharedModels.held_not_one` from one parametric theorem. -/
theorem heldPair_as_parametric_instance :
    (∀ t, t < 2 →
      Optimum.HeldPair.flow.WithinOwn t .pool ∧
      ¬ Optimum.HeldPair.flow.WithinJoint t .pool ∧
      localError FreeEnergyGuarantees.SharedModels.holder
        (fun u => Optimum.HeldPair.web.stock (Optimum.HeldPair.store .first) u)
        (fun u => Optimum.HeldPair.flow.take u .first .pool) t = 0 ∧
      localError FreeEnergyGuarantees.SharedModels.holder
        (fun u => Optimum.HeldPair.web.stock (Optimum.HeldPair.store .second) u)
        (fun u => Optimum.HeldPair.flow.take u .second .pool) t = 0 ∧
      FreeEnergyGuarantees.SharedModels.holder.risk
        (Optimum.HeldPair.web.stock (Optimum.HeldPair.store .first) t)
        (Optimum.HeldPair.flow.take t .first .pool) = 0 ∧
      FreeEnergyGuarantees.SharedModels.holder.risk
        (Optimum.HeldPair.web.stock (Optimum.HeldPair.store .second) t)
        (Optimum.HeldPair.flow.take t .second .pool) = 0) ∧
    (∀ k g, Optimum.HeldPair.web.requires (0 + 2 + k) g .pool →
      1 ≤ Optimum.HeldPair.web.need (0 + 2 + k) g .pool →
      ¬ Optimum.HeldPair.web.active (0 + 2 + k) g) ∧
    (∀ h, Optimum.HeldPair.holders h = true →
      ¬ Optimum.HeldPair.web.CoupledInto Optimum.HeldPair.observes h .pool) := by
  let agents : List Optimum.HeldPair.Member := [.first, .second]
  have notRenewer : Witnesses.Member.renewer ∈ agents → False := fun m => by
    change Witnesses.Member.renewer ∈ [Witnesses.Member.first, Witnesses.Member.second] at m
    cases m with
    | tail _ no => cases no with
      | tail _ no2 => cases no2
  have distA : Distinct agents :=
    And.intro (fun m => by cases m with | tail _ no => cases no)
      (And.intro (fun m => by cases m) trivial)
  have injId : ∀ i j : Optimum.HeldPair.Member,
      i ∈ agents → j ∈ agents → id i = id j → i = j := fun _ _ _ _ eq => eq
  have holdersEq : ∀ h, holdersOf agents id h = Optimum.HeldPair.holders h := fun h => by
    cases h <;> rfl
  have instAt := fun (k : Nat) (g : Optimum.HeldPair.Member)
      (req : Optimum.HeldPair.web.requires (2 + k) g .pool)
      (needGe : 1 ≤ Optimum.HeldPair.web.need (2 + k) g .pool) =>
    parametric_local_accounts_depletion
      (L := Optimum.HeldPair.flow) (W := Optimum.HeldPair.web)
      (obs := Optimum.HeldPair.observes) (agents := agents) distA id injId
      Optimum.HeldPair.store .pool (fun _ => 1)
      (fun _ => FreeEnergyGuarantees.SharedModels.holder)
      (n := 2) (k := k) (m := 1) (d := 1) (g := g) Nat.zero_lt_one
      (fun t ht i mi => match t, i with
        | 0, .first => .tail _ (.head _)
        | 0, .second => .tail _ (.tail _ (.head _))
        | 1, .first => .tail _ (.head _)
        | 1, .second => .tail _ (.tail _ (.head _))
        | _ + 2, _ => absurd ht (Nat.not_lt_of_le (Nat.le_add_left 2 _))
        | _, .renewer => absurd mi notRenewer)
      (fun t ht => match t with
        | 0 => Optimum.HeldPair.distinct 0
        | 1 => Optimum.HeldPair.distinct 1
        | k + 2 => absurd ht (Nat.not_lt_of_le (Nat.le_add_left 2 k)))
      (fun j _ => Optimum.HeldPair.balances.on [.pool] j)
      (fun t _ i _ => Optimum.HeldPair.balances.on (Optimum.HeldPair.store i) t)
      (fun j f _ => Optimum.HeldPair.gated j f)
      (fun j _ => Optimum.HeldPair.acting.giversSupported Optimum.HeldPair.dependent j .pool)
      (fun t _ i mi q _ nq x mx => Optimum.HeldPair.alone t i (by
        rw [← holdersEq i]; exact holdersOf_mem mi) q nq x mx)
      (fun t _ i _ =>
        Optimum.stock_eq_of_atSetPoint (Optimum.HeldPair.held t i) (Optimum.HeldPair.held (t + 1) i))
      (fun _ _ i mi => match i with
        | .first => rfl
        | .second => rfl
        | .renewer => absurd mi notRenewer)
      (fun _ _ i mi => match i with
        | .first => rfl
        | .second => rfl
        | .renewer => absurd mi notRenewer)
      (fun _ _ _ => rfl)
      (fun t ht i mi => match t, i with
        | 0, .first => rfl
        | 0, .second => rfl
        | 1, .first => rfl
        | 1, .second => rfl
        | _ + 2, _ => absurd ht (Nat.not_lt_of_le (Nat.le_add_left 2 _))
        | _, .renewer => absurd mi notRenewer)
      (fun _ _ i mi => match i with
        | .first => rfl
        | .second => rfl
        | .renewer => absurd mi notRenewer)
      (fun i mi => match i with
        | .first => Or.inr (.head _)
        | .second => Or.inr (.head _)
        | .renewer => absurd mi notRenewer)
      (fun t ht i mi => match t, i with
        | 0, .first => Nat.le_refl 1
        | 0, .second => Nat.le_refl 1
        | 1, .first => Nat.le_refl 1
        | 1, .second => Nat.le_refl 1
        | _ + 2, _ => absurd ht (Nat.not_lt_of_le (Nat.le_add_left 2 _))
        | _, .renewer => absurd mi notRenewer)
      (fun t ht q mq notAg => match t, q with
        | 0, .renewer => Nat.zero_le 1
        | 0, .first => absurd rfl (notAg .first (.head _))
        | 0, .second => absurd rfl (notAg .second (.tail _ (.head _)))
        | 1, .renewer => Nat.zero_le 1
        | 1, .first => absurd rfl (notAg .first (.head _))
        | 1, .second => absurd rfl (notAg .second (.tail _ (.head _)))
        | k + 2, _ => absurd ht (Nat.not_lt_of_le (Nat.le_add_left 2 k)))
      (fun t ht => match t with
        | 0 => by
          show Optimum.HeldPair.flow.restGiven (holdersOf agents id) 0 .pool + 1 ≤ 2
          have hRest : Optimum.HeldPair.flow.restGiven (holdersOf agents id) 0 .pool = 1 := rfl
          rw [hRest]
          exact Nat.le_refl 2
        | 1 => by
          show Optimum.HeldPair.flow.restGiven (holdersOf agents id) 1 .pool + 1 ≤ 2
          have hRest : Optimum.HeldPair.flow.restGiven (holdersOf agents id) 1 .pool = 1 := rfl
          rw [hRest]
          exact Nat.le_refl 2
        | k + 2 => absurd ht (Nat.not_lt_of_le (Nat.le_add_left 2 k)))
      (Nat.lt_succ_self 2)
      (Optimum.HeldPair.dependent (2 + k) g)
      req needGe
      (fun i x mi couples => by
        have hh : Optimum.HeldPair.holders i = true := by
          rw [← holdersEq i]; exact holdersOf_mem mi
        exact Optimum.HeldPair.listed i x hh couples)
      (fun i mi => by
        have hh : Optimum.HeldPair.holders i = true := by
          rw [← holdersEq i]; exact holdersOf_mem mi
        exact Optimum.HeldPair.apart i hh)
  have hBase := instAt 0 .renewer trivial (Nat.le_refl 1)
  refine ⟨fun t ht => ?_, fun k g req needGe => ?_, fun h hh => ?_⟩
  · have hOwnJoint := hBase.2.1 t ht
    have hFirst := hBase.1 t ht .first (.head _)
    have hSecond := hBase.1 t ht .second (.tail _ (.head _))
    exact ⟨hOwnJoint.1, hOwnJoint.2, hFirst.2.2.1, hSecond.2.2.1, hFirst.2.2.2, hSecond.2.2.2⟩
  · rw [Nat.zero_add] at req needGe ⊢
    exact (instAt k g req needGe).2.2.2.2.2.2.2
  · cases h
    · nomatch hh
    · exact hBase.2.2.1 .first (.head _)
    · exact hBase.2.2.1 .second (.tail _ (.head _))

/-- Helper: construct `Web.FirstApart` directly from a monitor member `mon` that first differs
at `T_warn`. -/
theorem firstApart_of_monitor {F C : Type} {W : Web F C} {group : F → Prop}
    {l_drain l_safe : Nat → C → Nat} {mon : F} {T_warn : Nat}
    (monMem : group mon)
    (diffAt : ¬ (W.Admits (l_drain T_warn) T_warn mon ↔ W.Admits (l_safe T_warn) T_warn mon))
    (alikeBefore : ∀ g, group g → ∀ t, t < T_warn →
      (W.Admits (l_drain t) t g ↔ W.Admits (l_safe t) t g)) :
    W.FirstApart group l_drain l_safe T_warn :=
  ⟨⟨mon, monMem, diffAt⟩, alikeBefore⟩

/-- **Part A3 (`pooled_detects_before_collapse`).**
Cleanly splits:
1. Unpooled failure (`too_late_of_alike` & `separates_all_iff`): under unpooled `obs`, neither
   threshold continuations (`¬ W.ReadableInTime`) nor any `SelectsThroughAll obs isAgent` reads
   the substrate collapse before `N_ret`.
2. `obs`-pooling separation (`SelectionPool.Web.member_separates_all`): coupling a monitor `mon`
   via `pooledObs` (`¬ W.AlikeThroughUpTo pooledObs mon l_drain l_safe T_warn`) creates a pool
   selector separating `l_drain` and `l_safe` at `T_warn < N_ret` (`Recoverable` holds at `T_warn`).
3. Structural monitor (`FirstApart`, `ReadableInTime`, `NoReturnAt.recoverable_iff`): when a
   pooled monitor's structural admission `requires`/`need` yields `W.FirstApart pooledGroup
   l_drain l_safe T_warn` with `T_warn < N_ret`, `W.ReadableInTime pooledGroup feasible keeps
   l_drain l_safe` and `Recoverable feasible keeps l_drain T_warn` both hold. -/
theorem pooled_detects_before_collapse {F C : Type} {W : Web F C}
    {obs pooledObs : F → C → Prop} {isAgent pooledGroup : F → Prop}
    {feasible keeps : (Nat → C → Nat) → Prop}
    {l_drain l_safe : Nat → C → Nat} {N_ret T_warn : Nat} {mon : F}
    (noRet : NoReturnAt feasible keeps l_drain N_ret)
    (unpooled_alike : W.AlikeThroughAll obs isAgent l_drain l_safe N_ret)
    (early : T_warn < N_ret)
    (monMem : pooledGroup mon)
    (obs_differ : ¬ W.AlikeThroughUpTo pooledObs mon l_drain l_safe T_warn)
    (firstApart : W.FirstApart pooledGroup l_drain l_safe T_warn) :
    (¬ W.ReadableInTime isAgent feasible keeps l_drain l_safe ∧
      (∀ sel, (∀ s, W.SelectsThroughAll thresholdOnly isAgent s (sel s)) →
        ¬ Web.ReadsInTime sel feasible keeps l_drain l_safe) ∧
      ∀ select, W.SelectsThroughAll obs isAgent N_ret select →
        (select l_drain ↔ select l_safe)) ∧
    (∃ select, W.SelectsThrough pooledObs mon T_warn select ∧
      W.SelectsThroughAll pooledObs pooledGroup T_warn select ∧
      select l_drain ∧ ¬ select l_safe) ∧
    (W.ReadableInTime pooledGroup feasible keeps l_drain l_safe ∧
      Recoverable feasible keeps l_drain T_warn) := by
  have unpooledAlikeAdmit : ∀ g, isAgent g → ∀ t, t ≤ N_ret →
      (W.Admits (l_drain t) t g ↔ W.Admits (l_safe t) t g) :=
    fun g hg t ht => (unpooled_alike g hg t ht).1
  have hTooLate := Web.too_late_of_alike unpooledAlikeAdmit noRet.1
  have hNoSelect : ∀ select, W.SelectsThroughAll obs isAgent N_ret select →
      (select l_drain ↔ select l_safe) :=
    fun select hSel => hSel l_drain l_safe unpooled_alike
  have hMemberSep := Web.member_separates_all monMem obs_differ
  have hReadable : W.ReadableInTime pooledGroup feasible keeps l_drain l_safe :=
    (Web.readableInTime_iff firstApart noRet).mpr early
  have hRec : Recoverable feasible keeps l_drain T_warn :=
    noRet.recoverable_iff.mpr early
  exact ⟨⟨hTooLate.1, hTooLate.2, hNoSelect⟩, hMemberSep, ⟨hReadable, hRec⟩⟩

/-- Multi-agent finite-lag restraint adapter specification (avoids all market terminology). -/
structure RestraintAgentSpec where
  preCap : Nat
  postCap : Nat
  lag : Nat
  maxSilence : Nat
  postLePre : postCap ≤ preCap

/-- Explicit `AdaptiveLoops.OpenLoop` constructor for a finite-lag restraint agent observing a
scalar substrate level (`Nat`). -/
def restraintLoop (spec : RestraintAgentSpec) (warnLevel : Nat) :
    AdaptiveLoops.OpenLoop Nat Nat Unit Unit :=
  OpenComposition.countdownLoop spec.preCap spec.postCap (fun _ obs => decide (obs < warnLevel))

/-- Explicit `AdaptiveLoops.LoopCertificate` for `restraintLoop spec warnLevel`, certifying
post-alarm draw drop to `spec.postCap` within `spec.lag` steps. -/
def restraintCert (spec : RestraintAgentSpec) (warnLevel : Nat) :
    AdaptiveLoops.LoopCertificate (restraintLoop spec warnLevel) spec.lag :=
  OpenComposition.countdownCert spec.preCap spec.postCap spec.maxSilence spec.lag spec.lag
    (fun _ obs => decide (obs < warnLevel)) (fun obs => obs < warnLevel)
    spec.postLePre (Nat.le_refl spec.lag) (fun _ _ _ hWarn => decide_eq_true hWarn)

/-- **Part A3(iii) (`pooled_restraint_restores_viability`).**
General closed-loop restoration theorem via `AdaptiveLoops.assume_guarantee_joint_viable` and
`Viability.Certificate.kernel`: once pooled warnings fire with sufficient margin before `x_crit`
and post-alarm draws respect `H_safe`, every admissible run stays above `x_crit ()` forever. -/
theorem pooled_restraint_restores_viability {α Env : Type} {S Obs Dist : α → Type}
    (agents : List α)
    (L : (i : α) → AdaptiveLoops.OpenLoop (S i) (Obs i) (Dist i) Unit)
    (init : (i : α) → S i)
    (certs : (i : α) → AdaptiveLoops.LoopCertificate (L i) (init i))
    (obs : (i : α) → (Unit → Nat) → Obs i)
    (channel : (α → Bool) → (α → Nat) → Env → Bool)
    (G : Unit → (Unit → Nat) → Nat)
    (envDraw : Env → Unit → Nat) (envCap : Unit → Nat) (jointAdm : Env → Prop)
    (env_within : ∀ env, jointAdm env → ∀ j, envDraw env j ≤ envCap j)
    (x_crit warnLevel H_safe x₀ : Unit → Nat)
    (monitored : α → Unit → Prop)
    (obs_detects : ∀ i, i ∈ agents → ∀ x j, monitored i j → x j < warnLevel j →
      (certs i).warnObs (obs i x))
    (pooled_coverage : ∃ i, i ∈ agents ∧ monitored i ())
    (channel_fires : ∀ emit load env, jointAdm env →
      (∃ i, i ∈ agents ∧ emit i = true ∧ load i ≤ (certs i).maxSilence) →
      (∀ i, i ∈ agents → load i ≤ (certs i).maxSilence) →
      channel emit load env = true)
    (G_rises : RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (G ()))
    (post_viable : x_crit () ≤
      RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole G H_safe x_crit ())
    (post_cap : AdaptiveLoops.sumDraws agents (fun i => (certs i).postBudget) () + envCap () ≤
      H_safe ())
    (warn_margin : x_crit () +
      (AdaptiveLoops.globalMaxLag agents certs + 1) *
        AdaptiveLoops.preTotal agents certs envCap () ≤ warnLevel ())
    (init_margin : x_crit () +
      AdaptiveLoops.maxEta agents certs init *
        AdaptiveLoops.preTotal agents certs envCap () ≤ x₀ ()) :
    AdaptiveLoops.jointInv agents certs envCap x_crit (x₀, init) ∧
    Viability.Certificate (AdaptiveLoops.jointProcess agents L certs obs channel G envDraw jointAdm)
      (AdaptiveLoops.jointGuard agents L certs x_crit)
      (AdaptiveLoops.jointInv agents certs envCap x_crit) ∧
    ∀ (r : Run
        (AdaptiveLoops.jointProcess agents L certs obs channel G envDraw jointAdm)),
      r.state 0 = (x₀, init) → ∀ t, x_crit () ≤ (r.state t).1 () := by
  have hViable := AdaptiveLoops.assume_guarantee_joint_viable agents [()] (fun u => by cases u; exact .head [])
    L init certs obs channel G envDraw envCap jointAdm env_within x_crit warnLevel H_safe x₀
    monitored obs_detects (fun _ _ => pooled_coverage) channel_fires
    (fun i => by cases i; exact G_rises) (fun j => by cases j; exact post_viable)
    (fun j => by cases j; exact post_cap) (fun j => by cases j; exact warn_margin)
    (fun j => by cases j; exact init_margin)
  refine ⟨hViable.1, hViable.2, fun r hStart t => ?_⟩
  have hKernel : Viability.Kernel
      (AdaptiveLoops.jointProcess agents L certs obs channel G envDraw jointAdm)
      (AdaptiveLoops.jointGuard agents L certs x_crit) (r.state 0) :=
    hViable.2.kernel (hStart ▸ hViable.1)
  exact (hKernel.run r t).1 ()

/-- **End-to-end restraint adapter theorem (`restraint_adapter_restores_viability`).**
Instantiates `pooled_restraint_restores_viability` on concrete `RestraintAgentSpec` agents. -/
theorem restraint_adapter_restores_viability {α Env : Type}
    (agents : List α) (specs : α → RestraintAgentSpec)
    (channel : (α → Bool) → (α → Nat) → Env → Bool)
    (G : Unit → (Unit → Nat) → Nat)
    (envDraw : Env → Unit → Nat) (envCap : Unit → Nat) (jointAdm : Env → Prop)
    (env_within : ∀ env, jointAdm env → ∀ j, envDraw env j ≤ envCap j)
    (x_crit warnLevel H_safe x₀ : Nat)
    (monitored : α → Prop)
    (pooled_coverage : ∃ i, i ∈ agents ∧ monitored i)
    (channel_fires : ∀ emit load env, jointAdm env →
      (∃ i, i ∈ agents ∧ emit i = true ∧ load i ≤ (specs i).maxSilence) →
      (∀ i, i ∈ agents → load i ≤ (specs i).maxSilence) →
      channel emit load env = true)
    (G_rises : RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (G ()))
    (post_viable : x_crit ≤
      RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole G (fun _ => H_safe)
        (fun _ => x_crit) ())
    (post_cap : AdaptiveLoops.sumDraws agents (fun i _ => (specs i).postCap) () + envCap () ≤ H_safe)
    (warn_margin : x_crit +
      (AdaptiveLoops.foldNatMax agents (fun i => (specs i).lag) + 1) *
        (AdaptiveLoops.sumDraws agents (fun i _ => (specs i).preCap) () + envCap ()) ≤ warnLevel)
    (init_margin : x_crit +
      AdaptiveLoops.foldNatMax agents (fun i => (specs i).lag) *
        (AdaptiveLoops.sumDraws agents (fun i _ => (specs i).preCap) () + envCap ()) ≤ x₀) :
    ∀ (r : Run
        (AdaptiveLoops.jointProcess agents
          (fun i => restraintLoop (specs i) warnLevel)
          (fun i => restraintCert (specs i) warnLevel)
          (fun _ x => x ()) channel G envDraw jointAdm)),
      r.state 0 = ((fun _ => x₀), (fun i => (specs i).lag)) →
      ∀ t, x_crit ≤ (r.state t).1 () :=
  (pooled_restraint_restores_viability agents
    (fun i => restraintLoop (specs i) warnLevel)
    (fun i => (specs i).lag)
    (fun i => restraintCert (specs i) warnLevel)
    (fun _ x => x ())
    channel G envDraw envCap jointAdm env_within
    (fun _ => x_crit) (fun _ => warnLevel) (fun _ => H_safe) (fun _ => x₀)
    (fun i _ => monitored i)
    (fun _ _ _ _ _ lt => lt)
    pooled_coverage
    channel_fires G_rises post_viable post_cap warn_margin init_margin).2.2

/-! ### Part B: Needs-Faithful Active Web, Pre-Overdraw Bridge, and Overdraw Separation -/

/-- Needs-faithful `Web Unit Unit` tracking scalar level `levelFn` and activity `activeFn`
with need threshold `m`. -/
def activeUnitWeb (levelFn : Nat → Nat) (activeFn : Nat → Prop) (m : Nat) : Web Unit Unit where
  level t _ := levelFn t
  active t _ := activeFn t
  requires _ _ _ := True
  need _ _ _ := m
  draws _ _ _ := True

theorem activeUnitWeb_dependent {levelFn : Nat → Nat} {activeFn : Nat → Prop} {m : Nat}
    (sup : ∀ t, activeFn t → m ≤ levelFn t) :
    (activeUnitWeb levelFn activeFn m).Dependent :=
  fun t _ act c _ => match c with
  | () => sup t act

abbrev lineActiveWeb {U : Type} (need : U → Nat) (kids : U → List U) (giving : Nat → Nat)
    (use : U → Nat) (s : List U × Nat) (m : Nat) : Web Unit Unit :=
  activeUnitWeb
    (fun t => (LineOnAStock.course need kids giving use s t).2)
    (fun t => LineOnAStock.Goes need (LineOnAStock.course need kids giving use s t)) m

abbrev wayActiveWeb {U R : Type} (need : U → Nat) (kids : R → U → List U)
    (next : List U → R → R) (giving : Nat → Nat) (use : U → Nat)
    (s : (List U × R) × Nat) (m : Nat) : Web Unit Unit :=
  activeUnitWeb
    (fun t => (WayUnderARule.course need kids next giving use s t).2)
    (fun t => WayUnderARule.Goes need (WayUnderARule.course need kids next giving use s t)) m

theorem lineActiveWeb_dependent {U : Type} {need : U → Nat} {kids : U → List U}
    {giving : Nat → Nat} {use : U → Nat} {s : List U × Nat} {m : Nat}
    (atLeast : ∀ t u, u ∈ (LineOnAStock.course need kids giving use s t).1 → m ≤ need u) :
    (lineActiveWeb need kids giving use s m).Dependent :=
  activeUnitWeb_dependent fun t ⟨u, mu, le⟩ => Nat.le_trans (atLeast t u mu) le

theorem wayActiveWeb_dependent {U R : Type} {need : U → Nat} {kids : R → U → List U}
    {next : List U → R → R} {giving : Nat → Nat} {use : U → Nat} {s : (List U × R) × Nat}
    {m : Nat}
    (atLeast : ∀ t u, u ∈ (WayUnderARule.course need kids next giving use s t).1.1 → m ≤ need u) :
    (wayActiveWeb need kids next giving use s m).Dependent :=
  activeUnitWeb_dependent fun t ⟨u, mu, le⟩ => Nat.le_trans (atLeast t u mu) le

theorem gated_one_of_fromNothing {giving : Nat → Nat} (nothing : RegimeMargin.FromNothing giving) :
    RegimeMargin.Gated giving 1
  | 0, _ => nothing
  | z + 1, lt => absurd lt (Nat.not_lt_of_le (Nat.le_add_left 1 z))

theorem unit_giversSupported_of_gated {levelFn takeFn giving : Nat → Nat}
    {activeFn : Nat → Prop} {m : Nat}
    (gatedG : RegimeMargin.Gated giving m) (t : Nat) :
    (StockFlowBridge.unitFlow takeFn (fun k => giving (levelFn k - takeFn k))).GiversSupported
      (activeUnitWeb levelFn activeFn m) t () := by
  intro f _ pos e _
  cases e
  show m ≤ levelFn t
  have hGe : m ≤ levelFn t - takeFn t :=
    (Nat.lt_or_ge (levelFn t - takeFn t) m).elim
      (fun lt => absurd (gatedG _ lt ▸ pos) (Nat.lt_irrefl 0)) id
  exact Nat.le_trans hGe (Nat.sub_le (levelFn t) (takeFn t))

theorem line_below_of_excess_of_within {U : Type} {need : U → Nat} {kids : U → List U}
    {giving : Nat → Nat} {use : U → Nat} {s : List U × Nat} {m T N : Nat}
    (within : ∀ t, T ≤ t → t < T + N →
      LineOnAStock.taken use (LineOnAStock.course need kids giving use s t).1 ≤
        (LineOnAStock.course need kids giving use s t).2)
    (excess : ∀ k, k < N →
      giving ((LineOnAStock.course need kids giving use s (T + k)).2 -
        LineOnAStock.taken use (LineOnAStock.course need kids giving use s (T + k)).1) <
        LineOnAStock.taken use (LineOnAStock.course need kids giving use s (T + k)).1)
    (start : (LineOnAStock.course need kids giving use s T).2 < N + m) :
    (LineOnAStock.course need kids giving use s (T + N)).2 < m :=
  Flow.below_of_excess_within
    (L := StockFlowBridge.lineFlow need kids giving use s)
    (W := StockFlowBridge.lineWeb need kids giving use s)
    (ds := [()])
    (fun k lt => StockFlowBridge.line_balancesOn_of_within within (T + k)
      (Nat.le_add_right T k) (Nat.add_lt_add_left lt T))
    (fun k lt => by
      show giving ((LineOnAStock.course need kids giving use s (T + k)).2 -
          LineOnAStock.taken use (LineOnAStock.course need kids giving use s (T + k)).1) + 0 <
        LineOnAStock.taken use (LineOnAStock.course need kids giving use s (T + k)).1 + 0
      rw [Nat.add_zero, Nat.add_zero]
      exact excess k lt)
    (by
      show (LineOnAStock.course need kids giving use s T).2 + 0 < N + m
      rw [Nat.add_zero]
      exact start)

theorem line_below_of_excess_of_goes {U : Type} {need : U → Nat} {kids : U → List U}
    {giving : Nat → Nat} {use : U → Nat} {s : List U × Nat} {m T N : Nat}
    (nothing : RegimeMargin.FromNothing giving) (needs : LineOnAStock.Needing need kids s.1)
    (goes : ∀ t, T ≤ t → t ≤ T + N →
      LineOnAStock.Goes need (LineOnAStock.course need kids giving use s t))
    (excess : ∀ k, k < N →
      giving ((LineOnAStock.course need kids giving use s (T + k)).2 -
        LineOnAStock.taken use (LineOnAStock.course need kids giving use s (T + k)).1) <
        LineOnAStock.taken use (LineOnAStock.course need kids giving use s (T + k)).1)
    (start : (LineOnAStock.course need kids giving use s T).2 < N + m) :
    (LineOnAStock.course need kids giving use s (T + N)).2 < m :=
  line_below_of_excess_of_within
    (fun _ ht_ge ht_lt => Nat.le_of_lt (StockFlowBridge.line_taken_lt_of_goes nothing needs goes ht_ge ht_lt))
    excess start

theorem way_below_of_excess_of_within {U R : Type} {need : U → Nat} {kids : R → U → List U}
    {next : List U → R → R} {giving : Nat → Nat} {use : U → Nat} {s : (List U × R) × Nat}
    {m T N : Nat}
    (within : ∀ t, T ≤ t → t < T + N →
      LineOnAStock.taken use (WayUnderARule.course need kids next giving use s t).1.1 ≤
        (WayUnderARule.course need kids next giving use s t).2)
    (excess : ∀ k, k < N →
      giving ((WayUnderARule.course need kids next giving use s (T + k)).2 -
        LineOnAStock.taken use (WayUnderARule.course need kids next giving use s (T + k)).1.1) <
        LineOnAStock.taken use (WayUnderARule.course need kids next giving use s (T + k)).1.1)
    (start : (WayUnderARule.course need kids next giving use s T).2 < N + m) :
    (WayUnderARule.course need kids next giving use s (T + N)).2 < m :=
  Flow.below_of_excess_within
    (L := StockFlowBridge.wayFlow need kids next giving use s)
    (W := StockFlowBridge.wayWeb need kids next giving use s)
    (ds := [()])
    (fun k lt => StockFlowBridge.way_balancesOn_of_within within (T + k)
      (Nat.le_add_right T k) (Nat.add_lt_add_left lt T))
    (fun k lt => by
      show giving ((WayUnderARule.course need kids next giving use s (T + k)).2 -
          LineOnAStock.taken use (WayUnderARule.course need kids next giving use s (T + k)).1.1) + 0 <
        LineOnAStock.taken use (WayUnderARule.course need kids next giving use s (T + k)).1.1 + 0
      rw [Nat.add_zero, Nat.add_zero]
      exact excess k lt)
    (by
      show (WayUnderARule.course need kids next giving use s T).2 + 0 < N + m
      rw [Nat.add_zero]
      exact start)

theorem way_below_of_excess_of_goes {U R : Type} {need : U → Nat} {kids : R → U → List U}
    {next : List U → R → R} {giving : Nat → Nat} {use : U → Nat} {s : (List U × R) × Nat}
    {m T N : Nat}
    (nothing : RegimeMargin.FromNothing giving) (needs : WayUnderARule.Needing need kids s.1.1)
    (goes : ∀ t, T ≤ t → t ≤ T + N →
      WayUnderARule.Goes need (WayUnderARule.course need kids next giving use s t))
    (excess : ∀ k, k < N →
      giving ((WayUnderARule.course need kids next giving use s (T + k)).2 -
        LineOnAStock.taken use (WayUnderARule.course need kids next giving use s (T + k)).1.1) <
        LineOnAStock.taken use (WayUnderARule.course need kids next giving use s (T + k)).1.1)
    (start : (WayUnderARule.course need kids next giving use s T).2 < N + m) :
    (WayUnderARule.course need kids next giving use s (T + N)).2 < m :=
  way_below_of_excess_of_within
    (fun _ ht_ge ht_lt => Nat.le_of_lt (StockFlowBridge.way_taken_lt_of_goes nothing needs goes ht_ge ht_lt))
    excess start

/-- **Part B1 (`line_family_excess_ends`).**
Pre-overdraw transfer of `Flow.family_excess_ends_at` onto `LineOnAStock` using `lineActiveWeb`,
requiring `RegimeMargin.Gated giving m` and unclamped `within` on `[T, T + n + k)`. -/
theorem line_family_excess_ends {U : Type} {need : U → Nat} {kids : U → List U}
    {giving : Nat → Nat} {use : U → Nat} {s : List U × Nat} {m T n k : Nat}
    (gatedG : RegimeMargin.Gated giving m)
    (within : ∀ t, T ≤ t → t < T + (n + k) →
      LineOnAStock.taken use (LineOnAStock.course need kids giving use s t).1 ≤
        (LineOnAStock.course need kids giving use s t).2)
    (excess : ∀ j, j < n →
      giving ((LineOnAStock.course need kids giving use s (T + j)).2 -
        LineOnAStock.taken use (LineOnAStock.course need kids giving use s (T + j)).1) <
        LineOnAStock.taken use (LineOnAStock.course need kids giving use s (T + j)).1)
    (start : (LineOnAStock.course need kids giving use s T).2 < n + m)
    (atLeast : ∀ u, u ∈ (LineOnAStock.course need kids giving use s (T + n + k)).1 → m ≤ need u) :
    ¬ LineOnAStock.Goes need (LineOnAStock.course need kids giving use s (T + n + k)) :=
  Flow.family_excess_ends_at
    (L := StockFlowBridge.lineFlow need kids giving use s)
    (W := lineActiveWeb need kids giving use s m)
    (ds := [()]) (m := m) (T := T) (n := n) (k := k) (g := ()) (e := ())
    (fun j lt => StockFlowBridge.line_balancesOn_of_within within (T + j)
      (Nat.le_add_right T j) (Nat.add_lt_add_left lt T))
    (fun _ _ _ _ d _ _ => match d with | () => ⟨(), .head [], trivial, Nat.le_refl m⟩)
    (fun j _ d _ => match d with | () => unit_giversSupported_of_gated gatedG (T + j))
    (fun j lt => by
      show giving ((LineOnAStock.course need kids giving use s (T + j)).2 -
          LineOnAStock.taken use (LineOnAStock.course need kids giving use s (T + j)).1) + 0 <
        LineOnAStock.taken use (LineOnAStock.course need kids giving use s (T + j)).1 + 0
      rw [Nat.add_zero, Nat.add_zero]
      exact excess j lt)
    (by
      show (LineOnAStock.course need kids giving use s T).2 + 0 < n + m
      rw [Nat.add_zero]
      exact start)
    (fun act _ _ => match act with | ⟨u, mu, le⟩ => Nat.le_trans (atLeast u mu) le)
    (.head []) trivial (Nat.le_refl m)

theorem line_family_excess_ends_one {U : Type} {need : U → Nat} {kids : U → List U}
    {giving : Nat → Nat} {use : U → Nat} {s : List U × Nat} {T n k : Nat}
    (nothing : RegimeMargin.FromNothing giving)
    (needs : LineOnAStock.Needing need kids s.1)
    (within : ∀ t, T ≤ t → t < T + (n + k) →
      LineOnAStock.taken use (LineOnAStock.course need kids giving use s t).1 ≤
        (LineOnAStock.course need kids giving use s t).2)
    (excess : ∀ j, j < n →
      giving ((LineOnAStock.course need kids giving use s (T + j)).2 -
        LineOnAStock.taken use (LineOnAStock.course need kids giving use s (T + j)).1) <
        LineOnAStock.taken use (LineOnAStock.course need kids giving use s (T + j)).1)
    (start : (LineOnAStock.course need kids giving use s T).2 < n + 1) :
    ¬ LineOnAStock.Goes need (LineOnAStock.course need kids giving use s (T + n + k)) :=
  line_family_excess_ends (gated_one_of_fromNothing nothing) within excess start
    fun u mu => needs (T + n + k) u (LineOnAStock.mem_generation s (T + n + k) u mu)

theorem line_excess_terminates_goes {U : Type} {need : U → Nat} {kids : U → List U}
    {giving : Nat → Nat} {use : U → Nat} {s : List U × Nat} {T n : Nat}
    (nothing : RegimeMargin.FromNothing giving)
    (needs : LineOnAStock.Needing need kids s.1)
    (excess : ∀ k, k < n →
      LineOnAStock.Goes need (LineOnAStock.course need kids giving use s (T + k)) →
      giving ((LineOnAStock.course need kids giving use s (T + k)).2 -
        LineOnAStock.taken use (LineOnAStock.course need kids giving use s (T + k)).1) <
        LineOnAStock.taken use (LineOnAStock.course need kids giving use s (T + k)).1)
    (start : (LineOnAStock.course need kids giving use s T).2 < n + 1) :
    ∃ t, T ≤ t ∧ t ≤ T + n ∧ ¬ LineOnAStock.Goes need (LineOnAStock.course need kids giving use s t) := by
  have dec : ∀ k, (∀ j, j ≤ k →
      LineOnAStock.Goes need (LineOnAStock.course need kids giving use s (T + j))) ∨
      ∃ j, j ≤ k ∧ ¬ LineOnAStock.Goes need (LineOnAStock.course need kids giving use s (T + j)) := by
    intro k
    induction k with
    | zero =>
      match LineOnAStock.goesDecidable need (LineOnAStock.course need kids giving use s (T + 0)) with
      | .isTrue h0 =>
        exact Or.inl fun j hj => match j, hj with
          | 0, _ => h0
          | _ + 1, le => absurd le (Nat.not_succ_le_zero _)
      | .isFalse hn0 => exact Or.inr ⟨0, Nat.le_refl 0, hn0⟩
    | succ k ih =>
      rcases ih with allK | ⟨j, leJ, notJ⟩
      · match LineOnAStock.goesDecidable need
            (LineOnAStock.course need kids giving use s (T + (k + 1))) with
        | .isTrue hk1 =>
          exact Or.inl fun j hj =>
            (Nat.lt_or_eq_of_le hj).elim (fun lt => allK j (Nat.le_of_lt_succ lt))
              (fun eq => eq ▸ hk1)
        | .isFalse hnk1 => exact Or.inr ⟨k + 1, Nat.le_refl _, hnk1⟩
      · exact Or.inr ⟨j, Nat.le_succ_of_le leJ, notJ⟩
  rcases dec n with allN | ⟨j, leJ, notJ⟩
  · have allGoes : ∀ t, T ≤ t → t ≤ T + n →
        LineOnAStock.Goes need (LineOnAStock.course need kids giving use s t) := by
      intro t ht1 ht2
      rcases le_dest ht1 with ⟨j, eqT⟩
      have jLe : j ≤ n := Naturals.le_of_add_le_add_left (k := T) (eqT ▸ ht2)
      exact eqT ▸ allN j jLe
    have hLt1 : (LineOnAStock.course need kids giving use s (T + n)).2 < 1 :=
      line_below_of_excess_of_goes nothing needs allGoes
        (fun k hk => excess k hk (allN k (Nat.le_of_lt hk))) start
    rcases allN n (Nat.le_refl n) with ⟨u, mu, leU⟩
    have hPos : 0 < need u := needs (T + n) u (LineOnAStock.mem_generation s (T + n) u mu)
    exact absurd (Nat.lt_of_lt_of_le (Nat.lt_of_lt_of_le hPos leU) (Nat.le_of_lt_succ hLt1))
      (Nat.lt_irrefl 0)
  · exact ⟨T + j, Nat.le_add_right T j, Nat.add_le_add_left leJ T, notJ⟩

/-- **Part B2 (`way_family_excess_ends`).**
Pre-overdraw transfer of `Flow.family_excess_ends_at` onto `WayUnderARule` using `wayActiveWeb`,
requiring `RegimeMargin.Gated giving m` and unclamped `within` on `[T, T + n + k)`. -/
theorem way_family_excess_ends {U R : Type} {need : U → Nat} {kids : R → U → List U}
    {next : List U → R → R} {giving : Nat → Nat} {use : U → Nat} {s : (List U × R) × Nat}
    {m T n k : Nat}
    (gatedG : RegimeMargin.Gated giving m)
    (within : ∀ t, T ≤ t → t < T + (n + k) →
      LineOnAStock.taken use (WayUnderARule.course need kids next giving use s t).1.1 ≤
        (WayUnderARule.course need kids next giving use s t).2)
    (excess : ∀ j, j < n →
      giving ((WayUnderARule.course need kids next giving use s (T + j)).2 -
        LineOnAStock.taken use (WayUnderARule.course need kids next giving use s (T + j)).1.1) <
        LineOnAStock.taken use (WayUnderARule.course need kids next giving use s (T + j)).1.1)
    (start : (WayUnderARule.course need kids next giving use s T).2 < n + m)
    (atLeast : ∀ u, u ∈ (WayUnderARule.course need kids next giving use s (T + n + k)).1.1 → m ≤ need u) :
    ¬ WayUnderARule.Goes need (WayUnderARule.course need kids next giving use s (T + n + k)) :=
  Flow.family_excess_ends_at
    (L := StockFlowBridge.wayFlow need kids next giving use s)
    (W := wayActiveWeb need kids next giving use s m)
    (ds := [()]) (m := m) (T := T) (n := n) (k := k) (g := ()) (e := ())
    (fun j lt => StockFlowBridge.way_balancesOn_of_within within (T + j)
      (Nat.le_add_right T j) (Nat.add_lt_add_left lt T))
    (fun _ _ _ _ d _ _ => match d with | () => ⟨(), .head [], trivial, Nat.le_refl m⟩)
    (fun j _ d _ => match d with | () => unit_giversSupported_of_gated gatedG (T + j))
    (fun j lt => by
      show giving ((WayUnderARule.course need kids next giving use s (T + j)).2 -
          LineOnAStock.taken use (WayUnderARule.course need kids next giving use s (T + j)).1.1) + 0 <
        LineOnAStock.taken use (WayUnderARule.course need kids next giving use s (T + j)).1.1 + 0
      rw [Nat.add_zero, Nat.add_zero]
      exact excess j lt)
    (by
      show (WayUnderARule.course need kids next giving use s T).2 + 0 < n + m
      rw [Nat.add_zero]
      exact start)
    (fun act _ _ => match act with | ⟨u, mu, le⟩ => Nat.le_trans (atLeast u mu) le)
    (.head []) trivial (Nat.le_refl m)

theorem way_family_excess_ends_one {U R : Type} {need : U → Nat} {kids : R → U → List U}
    {next : List U → R → R} {giving : Nat → Nat} {use : U → Nat} {s : (List U × R) × Nat}
    {T n k : Nat}
    (nothing : RegimeMargin.FromNothing giving)
    (needs : WayUnderARule.Needing need kids s.1.1)
    (within : ∀ t, T ≤ t → t < T + (n + k) →
      LineOnAStock.taken use (WayUnderARule.course need kids next giving use s t).1.1 ≤
        (WayUnderARule.course need kids next giving use s t).2)
    (excess : ∀ j, j < n →
      giving ((WayUnderARule.course need kids next giving use s (T + j)).2 -
        LineOnAStock.taken use (WayUnderARule.course need kids next giving use s (T + j)).1.1) <
        LineOnAStock.taken use (WayUnderARule.course need kids next giving use s (T + j)).1.1)
    (start : (WayUnderARule.course need kids next giving use s T).2 < n + 1) :
    ¬ WayUnderARule.Goes need (WayUnderARule.course need kids next giving use s (T + n + k)) :=
  way_family_excess_ends (gated_one_of_fromNothing nothing) within excess start
    fun u mu => needs (T + n + k) u (WayUnderARule.reachUnit_course (T + n + k) mu)

theorem way_excess_terminates_goes {U R : Type} {need : U → Nat} {kids : R → U → List U}
    {next : List U → R → R} {giving : Nat → Nat} {use : U → Nat} {s : (List U × R) × Nat}
    {T n : Nat}
    (nothing : RegimeMargin.FromNothing giving)
    (needs : WayUnderARule.Needing need kids s.1.1)
    (excess : ∀ k, k < n →
      WayUnderARule.Goes need (WayUnderARule.course need kids next giving use s (T + k)) →
      giving ((WayUnderARule.course need kids next giving use s (T + k)).2 -
        LineOnAStock.taken use (WayUnderARule.course need kids next giving use s (T + k)).1.1) <
        LineOnAStock.taken use (WayUnderARule.course need kids next giving use s (T + k)).1.1)
    (start : (WayUnderARule.course need kids next giving use s T).2 < n + 1) :
    ∃ t, T ≤ t ∧ t ≤ T + n ∧
      ¬ WayUnderARule.Goes need (WayUnderARule.course need kids next giving use s t) := by
  have dec : ∀ k, (∀ j, j ≤ k →
      WayUnderARule.Goes need (WayUnderARule.course need kids next giving use s (T + j))) ∨
      ∃ j, j ≤ k ∧ ¬ WayUnderARule.Goes need (WayUnderARule.course need kids next giving use s (T + j)) := by
    intro k
    induction k with
    | zero =>
      match WayUnderARule.goesDecidable need (WayUnderARule.course need kids next giving use s (T + 0)) with
      | .isTrue h0 =>
        exact Or.inl fun j hj => match j, hj with
          | 0, _ => h0
          | _ + 1, le => absurd le (Nat.not_succ_le_zero _)
      | .isFalse hn0 => exact Or.inr ⟨0, Nat.le_refl 0, hn0⟩
    | succ k ih =>
      rcases ih with allK | ⟨j, leJ, notJ⟩
      · match WayUnderARule.goesDecidable need
            (WayUnderARule.course need kids next giving use s (T + (k + 1))) with
        | .isTrue hk1 =>
          exact Or.inl fun j hj =>
            (Nat.lt_or_eq_of_le hj).elim (fun lt => allK j (Nat.le_of_lt_succ lt))
              (fun eq => eq ▸ hk1)
        | .isFalse hnk1 => exact Or.inr ⟨k + 1, Nat.le_refl _, hnk1⟩
      · exact Or.inr ⟨j, Nat.le_succ_of_le leJ, notJ⟩
  rcases dec n with allN | ⟨j, leJ, notJ⟩
  · have allGoes : ∀ t, T ≤ t → t ≤ T + n →
        WayUnderARule.Goes need (WayUnderARule.course need kids next giving use s t) := by
      intro t ht1 ht2
      rcases le_dest ht1 with ⟨j, eqT⟩
      have jLe : j ≤ n := Naturals.le_of_add_le_add_left (k := T) (eqT ▸ ht2)
      exact eqT ▸ allN j jLe
    have hLt1 : (WayUnderARule.course need kids next giving use s (T + n)).2 < 1 :=
      way_below_of_excess_of_goes nothing needs allGoes
        (fun k hk => excess k hk (allN k (Nat.le_of_lt hk))) start
    rcases allN n (Nat.le_refl n) with ⟨u, mu, leU⟩
    have hPos : 0 < need u := needs (T + n) u (WayUnderARule.reachUnit_course (T + n) mu)
    exact absurd (Nat.lt_of_lt_of_le (Nat.lt_of_lt_of_le hPos leU) (Nat.le_of_lt_succ hLt1))
      (Nat.lt_irrefl 0)
  · exact ⟨T + j, Nat.le_add_right T j, Nat.add_le_add_left leJ T, notJ⟩

/-! ### Exact Overdraw Separation & Truncation Witness -/

def FirstOverdraw (takeFn levelFn : Nat → Nat) (tStar : Nat) : Prop :=
  levelFn tStar < takeFn tStar ∧ ∀ t, t < tStar → takeFn t ≤ levelFn t

theorem exists_firstOverdraw {takeFn levelFn : Nat → Nat}
    (hit : ∃ t, levelFn t < takeFn t) :
    ∃ tStar, FirstOverdraw takeFn levelFn tStar := by
  rcases hit with ⟨t, ht⟩
  have hDec : ∀ k, (∀ j, j ≤ k → takeFn j ≤ levelFn j) ∨
      ∃ m, m ≤ k ∧ levelFn m < takeFn m ∧ ∀ j, j < m → takeFn j ≤ levelFn j :=
    first_of_decided (P := fun j => takeFn j ≤ levelFn j)
      (Q := fun j => levelFn j < takeFn j)
      (fun j => (Nat.lt_or_ge (levelFn j) (takeFn j)).elim Or.inr Or.inl)
  rcases hDec t with allLe | ⟨tStar, _, hLt, hBefore⟩
  · exact absurd (allLe t (Nat.le_refl t)) (Nat.not_le_of_gt ht)
  · exact ⟨tStar, hLt, hBefore⟩

theorem unit_balancesOn_iff_le {levelFn takeFn giving : Nat → Nat} {t : Nat}
    (step_eq : levelFn (t + 1) = RegimeMargin.step giving (takeFn t) (levelFn t)) :
    (StockFlowBridge.unitFlow takeFn (fun k => giving (levelFn k - takeFn k))).BalancesOn
      (StockFlowBridge.unitWeb levelFn) [()] t ↔ takeFn t ≤ levelFn t := by
  refine ⟨fun bal => ?_, StockFlowBridge.unitBalancesOn_of_le step_eq⟩
  have hEq : levelFn (t + 1) + takeFn t = levelFn t + giving (levelFn t - takeFn t) := by
    have b := bal () (.head [])
    rw [StockFlowBridge.unitFlow_taken, StockFlowBridge.unitFlow_given] at b
    exact b
  rw [step_eq] at hEq
  have hStep : (levelFn t - takeFn t) + takeFn t + giving (levelFn t - takeFn t) =
      levelFn t + giving (levelFn t - takeFn t) := by
    change (levelFn t - takeFn t) + giving (levelFn t - takeFn t) + takeFn t =
        levelFn t + giving (levelFn t - takeFn t) at hEq
    rw [Nat.add_right_comm] at hEq
    exact hEq
  have hCancel : (levelFn t - takeFn t) + takeFn t = levelFn t :=
    add_right_cancel (giving (levelFn t - takeFn t)) hStep
  exact Nat.le_trans (Nat.le_add_left (takeFn t) (levelFn t - takeFn t)) (Nat.le_of_eq hCancel)

/-- **Exact `Nat`-clamping overdraw separation (`unit_overdraw_separation`).** -/
theorem unit_overdraw_separation {levelFn takeFn giving : Nat → Nat} {tStar : Nat}
    (step_eq : ∀ t, levelFn (t + 1) = RegimeMargin.step giving (takeFn t) (levelFn t))
    (first : FirstOverdraw takeFn levelFn tStar) :
    (∀ t, t < tStar →
      (StockFlowBridge.unitFlow takeFn (fun k => giving (levelFn k - takeFn k))).BalancesOn
        (StockFlowBridge.unitWeb levelFn) [()] t) ∧
    levelFn (tStar + 1) = giving 0 ∧
    (levelFn (tStar + 1) + takeFn tStar =
      (levelFn tStar + giving (levelFn tStar - takeFn tStar)) + (takeFn tStar - levelFn tStar) ∧
      0 < takeFn tStar - levelFn tStar) ∧
    levelFn tStar +
        (StockFlowBridge.unitFlow takeFn (fun k => giving (levelFn k - takeFn k))).given tStar () <
      levelFn (tStar + 1) +
        (StockFlowBridge.unitFlow takeFn (fun k => giving (levelFn k - takeFn k))).taken tStar () ∧
    ¬ (StockFlowBridge.unitFlow takeFn (fun k => giving (levelFn k - takeFn k))).BalancesOn
        (StockFlowBridge.unitWeb levelFn) [()] tStar ∧
    ¬ (StockFlowBridge.unitFlow takeFn (fun k => giving (levelFn k - takeFn k))).Balances
        (StockFlowBridge.unitWeb levelFn) := by
  have hZeroSub : levelFn tStar - takeFn tStar = 0 := sub_eq_zero_of_le (Nat.le_of_lt first.1)
  have hClamp : levelFn (tStar + 1) = giving 0 := by
    rw [step_eq tStar]
    show (levelFn tStar - takeFn tStar) + giving (levelFn tStar - takeFn tStar) = giving 0
    rw [hZeroSub, Nat.zero_add]
  have hPosDiff : 0 < takeFn tStar - levelFn tStar := SupportGated.sub_pos_of_lt first.1
  have hDiscrep : levelFn (tStar + 1) + takeFn tStar =
      (levelFn tStar + giving (levelFn tStar - takeFn tStar)) + (takeFn tStar - levelFn tStar) := by
    rw [hClamp, hZeroSub]
    calc giving 0 + takeFn tStar
        = giving 0 + (levelFn tStar + (takeFn tStar - levelFn tStar)) :=
          congrArg (giving 0 + ·) (add_sub_of_le (Nat.le_of_lt first.1)).symm
      _ = levelFn tStar + ((takeFn tStar - levelFn tStar) + giving 0) := by
          rw [Nat.add_comm (giving 0), Nat.add_assoc]
      _ = levelFn tStar + giving 0 + (takeFn tStar - levelFn tStar) := by
          rw [Nat.add_comm (takeFn tStar - levelFn tStar) (giving 0), ← Nat.add_assoc]
  have hStrict : levelFn tStar +
        (StockFlowBridge.unitFlow takeFn (fun k => giving (levelFn k - takeFn k))).given tStar () <
      levelFn (tStar + 1) +
        (StockFlowBridge.unitFlow takeFn (fun k => giving (levelFn k - takeFn k))).taken tStar () := by
    rw [StockFlowBridge.unitFlow_given, StockFlowBridge.unitFlow_taken, hDiscrep]
    exact Nat.lt_of_lt_of_le
      (Nat.add_lt_add_left hPosDiff (levelFn tStar + giving (levelFn tStar - takeFn tStar)))
      (Nat.le_refl _)
  have hNotBalOn : ¬ (StockFlowBridge.unitFlow takeFn
      (fun k => giving (levelFn k - takeFn k))).BalancesOn (StockFlowBridge.unitWeb levelFn) [()] tStar :=
    fun bal => Nat.not_le_of_gt first.1 ((unit_balancesOn_iff_le (step_eq tStar)).mp bal)
  have hNotBal : ¬ (StockFlowBridge.unitFlow takeFn
      (fun k => giving (levelFn k - takeFn k))).Balances (StockFlowBridge.unitWeb levelFn) :=
    fun bal => hNotBalOn (bal.on [()] tStar)
  exact ⟨fun t ht => (unit_balancesOn_iff_le (step_eq t)).mpr (first.2 t ht),
    hClamp, ⟨hDiscrep, hPosDiff⟩, hStrict, hNotBalOn, hNotBal⟩

theorem line_overdraw_separation {U : Type} {need : U → Nat} {kids : U → List U}
    {giving : Nat → Nat} {use : U → Nat} {s : List U × Nat} {tStar : Nat}
    (first : FirstOverdraw
      (fun t => LineOnAStock.taken use (LineOnAStock.course need kids giving use s t).1)
      (fun t => (LineOnAStock.course need kids giving use s t).2) tStar) :
    (∀ t, t < tStar →
      (StockFlowBridge.lineFlow need kids giving use s).BalancesOn
        (StockFlowBridge.lineWeb need kids giving use s) [()] t) ∧
    (LineOnAStock.course need kids giving use s (tStar + 1)).2 = giving 0 ∧
    (LineOnAStock.course need kids giving use s tStar).2 +
        (StockFlowBridge.lineFlow need kids giving use s).given tStar () <
      (LineOnAStock.course need kids giving use s (tStar + 1)).2 +
        (StockFlowBridge.lineFlow need kids giving use s).taken tStar () ∧
    ¬ (StockFlowBridge.lineFlow need kids giving use s).BalancesOn
        (StockFlowBridge.lineWeb need kids giving use s) [()] tStar ∧
    ¬ (StockFlowBridge.lineFlow need kids giving use s).Balances
        (StockFlowBridge.lineWeb need kids giving use s) :=
  have hSep := unit_overdraw_separation (giving := giving) (fun _ => rfl) first
  ⟨hSep.1, hSep.2.1, hSep.2.2.2.1, hSep.2.2.2.2.1, hSep.2.2.2.2.2⟩

theorem way_overdraw_separation {U R : Type} {need : U → Nat} {kids : R → U → List U}
    {next : List U → R → R} {giving : Nat → Nat} {use : U → Nat} {s : (List U × R) × Nat}
    {tStar : Nat}
    (first : FirstOverdraw
      (fun t => LineOnAStock.taken use (WayUnderARule.course need kids next giving use s t).1.1)
      (fun t => (WayUnderARule.course need kids next giving use s t).2) tStar) :
    (∀ t, t < tStar →
      (StockFlowBridge.wayFlow need kids next giving use s).BalancesOn
        (StockFlowBridge.wayWeb need kids next giving use s) [()] t) ∧
    (WayUnderARule.course need kids next giving use s (tStar + 1)).2 = giving 0 ∧
    (WayUnderARule.course need kids next giving use s tStar).2 +
        (StockFlowBridge.wayFlow need kids next giving use s).given tStar () <
      (WayUnderARule.course need kids next giving use s (tStar + 1)).2 +
        (StockFlowBridge.wayFlow need kids next giving use s).taken tStar () ∧
    ¬ (StockFlowBridge.wayFlow need kids next giving use s).BalancesOn
        (StockFlowBridge.wayWeb need kids next giving use s) [()] tStar ∧
    ¬ (StockFlowBridge.wayFlow need kids next giving use s).Balances
        (StockFlowBridge.wayWeb need kids next giving use s) :=
  have hSep := unit_overdraw_separation (giving := giving) (fun _ => rfl) first
  ⟨hSep.1, hSep.2.1, hSep.2.2.2.1, hSep.2.2.2.2.1, hSep.2.2.2.2.2⟩

/- Concrete verified counter-model certifying why global `Flow.Balances` breaks at `t* = 1`:
- `t = 0`: `level 0 = 4`, `taken 0 = 3 ≤ 4`, `level 1 = (4 - 3) + 1 = 2`, `BalancesOn [()] 0` holds.
- `t* = 1`: `level 1 = 2 < 3 = taken 1` (`FirstOverdraw`), `level 2 = 0`, `BalancesOn [()] 1` fails
  (`2 + 0 = 2 < 3 = 0 + 3`), `¬ Goes` at `t = 2`, and `¬ lineFlow.Balances lineWeb`. -/
namespace OverdrawSeparationWitness

def need (_ : Unit) : Nat := 1
def use (_ : Unit) : Nat := 3
def kids (_ : Unit) : List Unit := [()]
def giving (z : Nat) : Nat := if 1 ≤ z then 1 else 0
def startState : List Unit × Nat := ([()], 4)

theorem giving_fromNothing : RegimeMargin.FromNothing giving := rfl

theorem needs : LineOnAStock.Needing need kids startState.1 :=
  fun _ _ _ => Nat.zero_lt_one

theorem firstOverdraw_at_one :
    FirstOverdraw
      (fun t => LineOnAStock.taken use (LineOnAStock.course need kids giving use startState t).1)
      (fun t => (LineOnAStock.course need kids giving use startState t).2) 1 :=
  ⟨Nat.lt_succ_self 2, fun t lt => match t, lt with
    | 0, _ => Nat.le_succ 3
    | _ + 1, lt => absurd lt (Nat.not_lt_of_le (Nat.le_add_left 1 _))⟩

theorem witness_bundle :
    (StockFlowBridge.lineFlow need kids giving use startState).BalancesOn
      (StockFlowBridge.lineWeb need kids giving use startState) [()] 0 ∧
    ¬ (StockFlowBridge.lineFlow need kids giving use startState).BalancesOn
      (StockFlowBridge.lineWeb need kids giving use startState) [()] 1 ∧
    ¬ (StockFlowBridge.lineFlow need kids giving use startState).Balances
      (StockFlowBridge.lineWeb need kids giving use startState) ∧
    (LineOnAStock.course need kids giving use startState 2).2 = 0 ∧
    ¬ LineOnAStock.Goes need (LineOnAStock.course need kids giving use startState 2) :=
  have hSep := line_overdraw_separation firstOverdraw_at_one
  ⟨hSep.1 0 Nat.zero_lt_one, hSep.2.2.2.1, hSep.2.2.2.2, hSep.2.1,
   fun ⟨_, _, le⟩ => absurd (Nat.le_trans (Nat.le_refl 1) (Nat.le_trans le (Nat.le_of_eq hSep.2.1)))
     (Nat.not_succ_le_zero 0)⟩

end OverdrawSeparationWitness

/-! ### Part C: Temporal-Aliasing, Strobe/Cadence Erasure, and Sampled Deadline Impossibility -/

/-! #### C1. Sampled Transient-Break Concealment & Hidden Cumulative Fragility -/

theorem sampled_break_concealment {F C : Type}
    {W : Web F C} {obs : F → C → Prop} {g f_dep : F} {c : C}
    {σ : Nat → Nat} (strict : Becoming.Strict σ) {j J m : Nat}
    {l_break l_safe : Nat → C → Nat}
    (constNeed : ∀ t, W.need t f_dep c = m)
    (safe_keeps : ∀ t, m ≤ l_safe t c)
    (span2 : σ j + 2 ≤ σ (j + 1))
    (break_inside : W.requires (σ j) f_dep c ∧ m ≤ l_break (σ j) c ∧ l_break (σ j + 1) c < m)
    (regrowth_met : m ≤ l_break (σ (j + 1)) c)
    (regrows_at_samples : ∀ s, s ≤ J → W.AlikeThrough obs g l_break l_safe (σ s)) :
    (σ j < σ j + 1 ∧ σ j + 1 < σ (j + 1)) ∧
    (W.withLevel l_break).Broken (σ j) f_dep c ∧
    (∀ t, ¬ (W.withLevel l_safe).Broken t f_dep c) ∧
    ¬ ((W.withLevel l_break).sample σ).Broken j f_dep c ∧
    ∀ select, (W.sample σ).SelectsThrough obs g J select →
      (select (atTimes σ l_break) ↔ select (atTimes σ l_safe)) := by
  have _strict := strict
  refine ⟨⟨Nat.lt_succ_self (σ j), Nat.lt_of_lt_of_le (Nat.lt_succ_self (σ j + 1)) span2⟩,
    ⟨break_inside.1, Nat.le_trans (Nat.le_of_eq (constNeed (σ j))) break_inside.2.1,
      Nat.lt_of_lt_of_le break_inside.2.2 (Nat.le_of_eq (constNeed (σ j)).symm)⟩,
    fun t brk => Nat.lt_irrefl m (Nat.lt_of_le_of_lt (safe_keeps (t + 1))
      (Nat.lt_of_lt_of_le brk.2.2 (Nat.le_of_eq (constNeed t)))),
    fun brk => Nat.lt_irrefl m (Nat.lt_of_le_of_lt regrowth_met
      (Nat.lt_of_lt_of_le brk.2.2 (Nat.le_of_eq (constNeed (σ j))))),
    Web.sample_selects_alike_iff.mpr regrows_at_samples⟩

theorem logistic_sampled_break_concealment (n v : Nat) (more : 1 < v)
    {x : Nat → Nat}
    (front : Requirement.Frontier (Optimum.OpenCourse Optimum.Holding.logistic 2 2)
      (Optimum.byDrawnLeftAt Optimum.Holding.logistic v (n + 1)) x)
    (σ : Nat → Nat) (strict : Becoming.Strict σ) (σ0 : σ 0 = 0) (σ1 : σ 1 = n + 2) :
    let l_break := Optimum.Holding.onSource x
    let l_safe := Optimum.Holding.onSource (fun _ => 2)
    (σ 0 < 1 ∧ 1 < σ 1) ∧
    (Diversion.web l_break).Broken 0 .dweller .source ∧
    (∀ t, t < n + 1 → (Diversion.web l_break).level (t + 1) .source < 2) ∧
    (∀ t, ¬ (Diversion.web l_safe).Broken t .dweller .source) ∧
    ¬ ((Diversion.web l_break).sample σ).Broken 0 .dweller .source ∧
    ∀ (obs : Diversion.Formation → Diversion.Place → Prop) (g : Diversion.Formation)
      (select : (Nat → Diversion.Place → Nat) → Prop),
      ((Diversion.web l_break).sample σ).SelectsThrough obs g 1 select →
      (select (atTimes σ l_break) ↔ select (atTimes σ l_safe)) := by
  have _strict := strict
  have hVal := Optimum.Holding.logistic_valued n v 0 (Nat.lt_trans Nat.zero_lt_one more)
  have hOpt := hVal.2.2.1 more x front
  have hX0 : x 0 = 2 := front.1.1
  have hXEnd : x (n + 2) = 2 := hOpt.2.2
  have hPointEq : ∀ s, s ≤ 1 → ∀ c,
      Optimum.Holding.onSource x (σ s) c = Optimum.Holding.onSource (fun _ => 2) (σ s) c := by
    intro s hs c
    cases c
    · cases s with
      | zero => rw [σ0]; exact hX0
      | succ s' =>
        cases s' with
        | zero => rw [σ1]; exact hXEnd
        | succ s'' => exact absurd (Nat.le_of_succ_le_succ hs) (Nat.not_succ_le_zero s'')
    · rfl
  refine ⟨⟨by rw [σ0]; exact Nat.zero_lt_one, by rw [σ1]; exact Nat.lt_of_lt_of_le (Nat.lt_succ_self 1) (Nat.le_add_left 2 n)⟩,
    hOpt.1, hOpt.2.1,
    fun _ brk => Nat.lt_irrefl 2 brk.2.2,
    fun brk => by
      have hL1 : Optimum.Holding.onSource x (σ 1) .source = 2 := by rw [σ1]; exact hXEnd
      exact Nat.lt_irrefl 2 (Eq.subst (motive := (· < 2)) hL1 brk.2.2),
    fun obs g select hSel => ?_⟩
  exact Web.sample_selects_alike_iff.mpr (fun s hs =>
    ⟨⟨fun adm c req => by rw [← hPointEq s hs c]; exact adm c req,
      fun adm c req => by rw [hPointEq s hs c]; exact adm c req⟩,
     fun c _ => hPointEq s hs c⟩) select hSel

/-- Axiom-free Euclidean `(quotient, remainder)` state for periodic cycle length `m`. -/
def cyclePair (m : Nat) : Nat → Nat × Nat
  | 0 => (0, 0)
  | t + 1 =>
    let qr := cyclePair m t
    match Nat.blt (qr.2 + 1) m with
    | true => (qr.1, qr.2 + 1)
    | false => (qr.1 + 1, 0)

def cycleRem (m t : Nat) : Nat :=
  (cyclePair m t).2

theorem cyclePair_spec (m : Nat) (hm : 0 < m) :
    ∀ t, m * (cyclePair m t).1 + (cyclePair m t).2 = t ∧ (cyclePair m t).2 < m
  | 0 => ⟨by show m * 0 + 0 = 0; rw [Nat.mul_zero, Nat.add_zero], hm⟩
  | t + 1 => by
    have ih := cyclePair_spec m hm t
    dsimp only [cyclePair]
    cases hb : Nat.blt ((cyclePair m t).2 + 1) m with
    | true =>
      dsimp only
      refine ⟨?_, CoreHelpers.natBlt_true_iff.mp hb⟩
      rw [← Nat.add_assoc, ih.1]
    | false =>
      dsimp only
      have hEq : (cyclePair m t).2 + 1 = m := Nat.le_antisymm ih.2 (CoreHelpers.natBlt_false_iff.mp hb)
      refine ⟨?_, hm⟩
      have hAdd : m * ((cyclePair m t).1 + 1) + 0 =
          m * (cyclePair m t).1 + ((cyclePair m t).2 + 1) := by
        rw [Nat.add_zero, Nat.mul_succ, hEq]
      rw [hAdd, ← Nat.add_assoc, ih.1]

theorem cycle_euclid_unique {m q₁ r₁ q₂ r₂ : Nat}
    (hr₁ : r₁ < m) (hr₂ : r₂ < m)
    (heq : m * q₁ + r₁ = m * q₂ + r₂) : q₁ = q₂ ∧ r₁ = r₂ := by
  have mulMono : ∀ {a b : Nat}, a ≤ b → m * a ≤ m * b := by
    intro a b hle
    rcases le_dest hle with ⟨k, hk⟩
    have hMulK : ∀ j, m * a ≤ m * (a + j) := by
      intro j
      induction j with
      | zero => rw [Nat.add_zero]; exact Nat.le_refl _
      | succ j ih =>
        rw [← Nat.add_assoc, Nat.mul_succ]
        exact Nat.le_trans ih (Nat.le_add_right _ m)
    rw [hk]
    exact hMulK k
  have noLess : ∀ a b ra rb, ra < m → m * a + ra = m * b + rb → a < b → False := by
    intro a b ra rb hra eqSum hlt
    have hBound : m * a + m ≤ m * b := by
      rw [← Nat.mul_succ]
      exact mulMono hlt
    have hLt1 : m * a + ra < m * a + m := Nat.add_lt_add_left hra (m * a)
    have hLe2 : m * b ≤ m * b + rb := Nat.le_add_right (m * b) rb
    have hStrict : m * a + ra < m * a + ra := by
      have h12 := Nat.lt_of_lt_of_le hLt1 (Nat.le_trans hBound hLe2)
      rw [← eqSum] at h12
      exact h12
    exact Nat.lt_irrefl _ hStrict
  cases Nat.lt_or_ge q₁ q₂ with
  | inl h12 => exact absurd h12 (noLess q₁ q₂ r₁ r₂ hr₁ heq)
  | inr h21 =>
    cases Nat.lt_or_ge q₂ q₁ with
    | inl h21' => exact absurd h21' (noLess q₂ q₁ r₂ r₁ hr₂ heq.symm)
    | inr h12' =>
      have eqQ : q₁ = q₂ := Nat.le_antisymm h12' h21
      have eqR : r₁ = r₂ := by
        have h' : r₁ + m * q₁ = r₂ + m * q₁ := by
          rw [Nat.add_comm r₁ (m * q₁), Nat.add_comm r₂ (m * q₁), heq, eqQ]
        exact add_right_cancel (m * q₁) h'
      exact ⟨eqQ, eqR⟩

theorem cycleRem_mul_add (m q r : Nat) (hr : r < m) : cycleRem m (m * q + r) = r := by
  have hm : 0 < m := Nat.lt_of_le_of_lt (Nat.zero_le r) hr
  have hSpec := cyclePair_spec m hm (m * q + r)
  exact (cycle_euclid_unique hSpec.2 hr hSpec.1).2

theorem cycleRem_mul (m q : Nat) (hm : 0 < m) : cycleRem m (m * q) = 0 := by
  have h := cycleRem_mul_add m q 0 hm
  rw [Nat.add_zero] at h
  exact h

theorem cycleRem_of_lt {m r : Nat} (hr : r < m) : cycleRem m r = r := by
  have h := cycleRem_mul_add m 0 r hr
  rw [Nat.mul_zero, Nat.zero_add] at h
  exact h

theorem cycleRem_self (m : Nat) (hm : 0 < m) : cycleRem m m = 0 := by
  have h := cycleRem_mul m 1 hm
  rw [Nat.mul_succ, Nat.mul_zero, Nat.zero_add] at h
  exact h

/-- Explicit cyclic periodic extension of an optimum `x` of `logistic_valued` with period `n + 2`. -/
def cyclicCourse (x : Nat → Nat) (n t : Nat) : Nat :=
  x (cycleRem (n + 2) t)

theorem cyclicCourse_openCourse (n v : Nat) (more : 1 < v)
    {x : Nat → Nat}
    (front : Requirement.Frontier (Optimum.OpenCourse Optimum.Holding.logistic 2 2)
      (Optimum.byDrawnLeftAt Optimum.Holding.logistic v (n + 1)) x) :
    Optimum.OpenCourse Optimum.Holding.logistic 2 2 (cyclicCourse x n) := by
  have hVal := Optimum.Holding.logistic_valued n v 0 (Nat.lt_trans Nat.zero_lt_one more)
  have hOpt := hVal.2.2.1 more x front
  have hX0 : x 0 = 2 := front.1.1
  have hXEnd : x (n + 2) = 2 := hOpt.2.2
  have hPos : 0 < n + 2 := Nat.succ_pos (n + 1)
  refine ⟨by show x 0 = 2; exact hX0, fun t => ?_⟩
  let r := cycleRem (n + 2) t
  have hrLt : r < n + 2 := (cyclePair_spec (n + 2) hPos t).2
  have hStepX := front.1.2 r
  cases hb : Nat.blt ((cyclePair (n + 2) t).2 + 1) (n + 2) with
  | true =>
    have hMod : cycleRem (n + 2) (t + 1) = r + 1 := by
      dsimp only [cycleRem, cyclePair]
      rw [hb]
      rfl
    dsimp only [Optimum.drawnAt, cyclicCourse] at hStepX ⊢
    rw [hMod]
    exact hStepX
  | false =>
    have hEq : r + 1 = n + 2 := Nat.le_antisymm hrLt (CoreHelpers.natBlt_false_iff.mp hb)
    have hMod : cycleRem (n + 2) (t + 1) = 0 := by
      dsimp only [cycleRem, cyclePair]
      rw [hb]
    have hXSucc : x (cycleRem (n + 2) (t + 1)) = x (r + 1) := by
      rw [hMod, hEq, hX0, hXEnd]
    dsimp only [Optimum.drawnAt, cyclicCourse] at hStepX ⊢
    rw [hXSucc]
    exact hStepX

theorem cyclicCourse_frontier (n v : Nat) (more : 1 < v)
    {x : Nat → Nat}
    (front : Requirement.Frontier (Optimum.OpenCourse Optimum.Holding.logistic 2 2)
      (Optimum.byDrawnLeftAt Optimum.Holding.logistic v (n + 1)) x) :
    Requirement.Frontier (Optimum.OpenCourse Optimum.Holding.logistic 2 2)
      (Optimum.byDrawnLeftAt Optimum.Holding.logistic v (n + 1)) (cyclicCourse x n) := by
  have hVal := Optimum.Holding.logistic_valued n v 0 (Nat.lt_trans Nat.zero_lt_one more)
  have hIff := hVal.2.1 more
  have hOrig := (hIff x).mp front
  refine (hIff (cyclicCourse x n)).mpr ⟨cyclicCourse_openCourse n v more front, fun t ht => ?_, ?_⟩
  · have hLt : t + 1 < n + 2 := Nat.succ_lt_succ ht
    show Optimum.Holding.logistic (x (cycleRem (n + 2) (t + 1))) = 1
    rw [cycleRem_of_lt hLt]
    exact hOrig.2.1 t ht
  · show x (cycleRem (n + 2) (n + 2)) = 2
    rw [cycleRem_self (n + 2) (Nat.succ_pos (n + 1))]
    exact front.1.1

/-- **Periodic logistic concealment (`logistic_periodic_sampled_break_concealment`).**
The cyclic extension `cyclicCourse x n` remains in `Frontier`, breaks at the start of EVERY
epoch `σ j = (n + 2) * j` and stays below `2` throughout the interior `(σ j, σ (j + 1))`, while
being completely invisible to ANY selector on `(Diversion.web l_per).sample σ` for ALL `K : Nat`. -/
theorem logistic_periodic_sampled_break_concealment (n v : Nat) (more : 1 < v)
    {x : Nat → Nat}
    (front : Requirement.Frontier (Optimum.OpenCourse Optimum.Holding.logistic 2 2)
      (Optimum.byDrawnLeftAt Optimum.Holding.logistic v (n + 1)) x) :
    let σ : Nat → Nat := fun j => (n + 2) * j
    let l_per := Optimum.Holding.onSource (cyclicCourse x n)
    let l_safe := Optimum.Holding.onSource (fun _ => 2)
    Becoming.Strict σ ∧
    Requirement.Frontier (Optimum.OpenCourse Optimum.Holding.logistic 2 2)
      (Optimum.byDrawnLeftAt Optimum.Holding.logistic v (n + 1)) (cyclicCourse x n) ∧
    (∀ j, (Diversion.web l_per).Broken (σ j) .dweller .source ∧
      (∀ k, k < n + 1 → (Diversion.web l_per).level (σ j + k + 1) .source < 2) ∧
      ¬ ((Diversion.web l_per).sample σ).Broken j .dweller .source) ∧
    ∀ (K : Nat) (obs : Diversion.Formation → Diversion.Place → Prop)
      (g : Diversion.Formation) (select : (Nat → Diversion.Place → Nat) → Prop),
      ((Diversion.web l_per).sample σ).SelectsThrough obs g K select →
      (select (atTimes σ l_per) ↔ select (atTimes σ l_safe)) := by
  have hVal := Optimum.Holding.logistic_valued n v 0 (Nat.lt_trans Nat.zero_lt_one more)
  have hOpt := hVal.2.2.1 more x front
  have hX0 : x 0 = 2 := front.1.1
  have hStrict : Becoming.Strict (fun j => (n + 2) * j) := fun s => by
    dsimp only
    rw [Nat.mul_succ]
    exact Nat.lt_add_of_pos_right (Nat.succ_pos (n + 1))
  have hAtSample : ∀ j, cyclicCourse x n ((n + 2) * j) = 2 := fun j => by
    show x (cycleRem (n + 2) ((n + 2) * j)) = 2
    rw [cycleRem_mul (n + 2) j (Nat.succ_pos (n + 1))]
    exact hX0
  refine ⟨hStrict, cyclicCourse_frontier n v more front, fun j => ?_, fun K obs g select hSel => ?_⟩
  · have hInterior : ∀ k, k < n + 1 →
        (Diversion.web (Optimum.Holding.onSource (cyclicCourse x n))).level
          ((n + 2) * j + k + 1) .source < 2 := fun k hk => by
      have hkLt : k + 1 < n + 2 := Nat.succ_lt_succ hk
      show x (cycleRem (n + 2) ((n + 2) * j + k + 1)) < 2
      have eqAdd : (n + 2) * j + k + 1 = (n + 2) * j + (k + 1) := Nat.add_assoc _ _ _
      rw [eqAdd, cycleRem_mul_add (n + 2) j (k + 1) hkLt]
      exact hOpt.2.1 k hk
    have hBroken : (Diversion.web (Optimum.Holding.onSource (cyclicCourse x n))).Broken
        ((n + 2) * j) .dweller .source := by
      refine ⟨trivial, Nat.le_of_eq (hAtSample j).symm, ?_⟩
      exact hInterior 0 (Nat.succ_pos n)
    have hNotSampleBroken :
        ¬ ((Diversion.web (Optimum.Holding.onSource (cyclicCourse x n))).sample
          (fun j => (n + 2) * j)).Broken j .dweller .source := fun brk => by
      have hNext : Optimum.Holding.onSource (cyclicCourse x n) ((n + 2) * (j + 1)) .source = 2 :=
        hAtSample (j + 1)
      have hBrkLt :
          Optimum.Holding.onSource (cyclicCourse x n) ((n + 2) * (j + 1)) .source < 2 := brk.2.2
      rw [hNext] at hBrkLt
      exact Nat.lt_irrefl 2 hBrkLt
    exact ⟨hBroken, hInterior, hNotSampleBroken⟩
  · have hPointEq : ∀ s c,
        Optimum.Holding.onSource (cyclicCourse x n) ((n + 2) * s) c =
          Optimum.Holding.onSource (fun _ => 2) ((n + 2) * s) c := fun s c => by
      cases c
      · exact hAtSample s
      · rfl
    exact Web.sample_selects_alike_iff.mpr (fun s _ =>
      ⟨⟨fun adm c req => by rw [← hPointEq s c]; exact adm c req,
        fun adm c req => by rw [hPointEq s c]; exact adm c req⟩,
       fun c _ => hPointEq s c⟩) select hSel

/-- **Sampled recovery hides cumulative fragility (`sampled_recovery_hides_fragility`).** -/
theorem sampled_recovery_hides_fragility {F C : Type}
    {W : Web F C} {obs : F → C → Prop} {g f_dep : F} {c cFrag : C}
    {σ : Nat → Nat} (strict : Becoming.Strict σ) {K dmg F₀ m_frag m : Nat}
    {l_break l_safe : Nat → C → Nat}
    (_uncoupled_frag : ¬ W.CoupledInto obs g cFrag)
    (constNeed : ∀ t, W.need t f_dep c = m)
    (breaks_each : ∀ j, j < K →
      σ j + 2 ≤ σ (j + 1) ∧ W.requires (σ j) f_dep c ∧ m ≤ l_break (σ j) c ∧ l_break (σ j + 1) c < m)
    (regrows_others : ∀ s, s ≤ K → ∀ d, W.CoupledInto obs g d → l_break (σ s) d = l_safe (σ s) d)
    (frag_drains : ∀ j, j < K → l_break (σ (j + 1)) cFrag + dmg ≤ l_break (σ j) cFrag)
    (frag_start : l_break (σ 0) cFrag ≤ F₀)
    (frag_limit : F₀ < K * dmg + m_frag) :
    (∀ j, j < K → (W.withLevel l_break).Broken (σ j) f_dep c ∧ σ j + 1 < σ (j + 1)) ∧
    (∀ select, (W.sample σ).SelectsThrough obs g K select →
      (select (atTimes σ l_break) ↔ select (atTimes σ l_safe))) ∧
    (∀ j₁ j₂, j₁ ≤ j₂ → j₂ ≤ K →
      l_break (σ j₂) cFrag + (j₂ - j₁) * dmg ≤ l_break (σ j₁) cFrag) ∧
    l_break (σ K) cFrag + K * dmg ≤ F₀ ∧
    l_break (σ K) cFrag < m_frag := by
  have _strict := strict
  have hAlike : ∀ s, s ≤ K → W.AlikeThrough obs g l_break l_safe (σ s) := fun s hs =>
    ⟨⟨fun adm d hreq => by
        rw [← regrows_others s hs d (.inl ⟨σ s, hreq⟩)]; exact adm d hreq,
      fun adm d hreq => by
        rw [regrows_others s hs d (.inl ⟨σ s, hreq⟩)]; exact adm d hreq⟩,
     fun d hobs => regrows_others s hs d (.inr hobs)⟩
  have hDrainPrefix : ∀ n, n ≤ K → l_break (σ n) cFrag + n * dmg ≤ l_break (σ 0) cFrag := by
    intro n hn
    induction n with
    | zero => rw [Nat.zero_mul, Nat.add_zero]; exact Nat.le_refl _
    | succ n ih =>
      have hStep := frag_drains n hn
      have hPrev := ih (Nat.le_of_lt hn)
      have hAssoc : l_break (σ (n + 1)) cFrag + (n + 1) * dmg =
          l_break (σ (n + 1)) cFrag + dmg + n * dmg := by
        rw [Nat.succ_mul, Nat.add_comm (n * dmg) dmg, Nat.add_assoc]
      rw [hAssoc]
      exact Nat.le_trans (Nat.add_le_add_right hStep (n * dmg)) hPrev
  have hDrainInterval : ∀ j₁ j₂, j₁ ≤ j₂ → j₂ ≤ K →
      l_break (σ j₂) cFrag + (j₂ - j₁) * dmg ≤ l_break (σ j₁) cFrag := by
    intro j₁ j₂ h12 h2K
    rcases le_dest h12 with ⟨delta, hEq⟩
    have hSub : j₂ - j₁ = delta := by rw [hEq, Naturals.add_sub_cancel_left]
    rw [hSub, hEq]
    have h2K' : j₁ + delta ≤ K := hEq ▸ h2K
    have hAux : ∀ d, j₁ + d ≤ K →
        l_break (σ (j₁ + d)) cFrag + d * dmg ≤ l_break (σ j₁) cFrag := by
      intro d
      induction d with
      | zero => intro _; rw [Nat.add_zero, Nat.zero_mul, Nat.add_zero]; exact Nat.le_refl _
      | succ d' ih =>
        intro hd
        have hLtK : j₁ + d' < K := Nat.lt_of_lt_of_le (Nat.lt_succ_self (j₁ + d')) hd
        have hStep := frag_drains (j₁ + d') hLtK
        have hPrev := ih (Nat.le_of_lt hLtK)
        have hAssoc : l_break (σ (j₁ + (d' + 1))) cFrag + (d' + 1) * dmg =
            l_break (σ (j₁ + d' + 1)) cFrag + dmg + d' * dmg := by
          rw [Nat.add_assoc j₁ d' 1, Nat.succ_mul, Nat.add_comm (d' * dmg) dmg, Nat.add_assoc]
        rw [hAssoc]
        exact Nat.le_trans (Nat.add_le_add_right hStep (d' * dmg)) hPrev
    exact hAux delta h2K'
  have hEndBound : l_break (σ K) cFrag + K * dmg ≤ F₀ :=
    Nat.le_trans (hDrainPrefix K (Nat.le_refl K)) frag_start
  have hLow : l_break (σ K) cFrag < m_frag :=
    Naturals.lt_of_add_lt_add_left (k := K * dmg)
      (Nat.lt_of_le_of_lt (Nat.le_trans (Nat.le_of_eq (Nat.add_comm (K * dmg) _)) hEndBound)
        frag_limit)
  refine ⟨fun j hj => ?_, Web.sample_selects_alike_iff.mpr hAlike, hDrainInterval, hEndBound, hLow⟩
  have hb := breaks_each j hj
  exact ⟨⟨hb.2.1, Nat.le_trans (Nat.le_of_eq (constNeed (σ j))) hb.2.2.1,
    Nat.lt_of_lt_of_le hb.2.2.2 (Nat.le_of_eq (constNeed (σ j)).symm)⟩,
    Nat.lt_of_lt_of_le (Nat.lt_succ_self (σ j + 1)) hb.1⟩

/-! #### C2. Strobe / Cadence Erasure -/

def ReadsAt (σ : Nat → Nat) (reads : Nat → Bool) : Prop :=
  ∀ t, reads t = true ↔ ∃ j, t = σ j

def sigmaOdd : Nat → Nat
  | 0 => 0
  | j + 1 => 2 * j + 1

theorem sigmaOdd_strict : Becoming.Strict sigmaOdd
  | 0 => Nat.zero_lt_one
  | j + 1 => by
    show 2 * j + 1 < 2 * (j + 1) + 1
    rw [Nat.mul_succ]
    exact Nat.lt_of_lt_of_le (Nat.lt_succ_self (2 * j + 1)) (Nat.le_add_right _ 1)

theorem flick_eq_true_odd : ∀ j, Strobe.flick (2 * j + 1) = true :=
  fun j => Strobe.flick_odd j

theorem flick_eq_false_even : ∀ j, Strobe.flick (2 * j) = false :=
  fun j => Strobe.flick_even j

theorem mod2_cases (t : Nat) : (∃ j, t = Strobe.twice j) ∨ (∃ j, t = Strobe.twice j + 1) := by
  induction t with
  | zero => exact Or.inl ⟨0, rfl⟩
  | succ t ih =>
    rcases ih with ⟨j, eq⟩ | ⟨j, eq⟩
    · exact Or.inr ⟨j, eq ▸ rfl⟩
    · exact Or.inl ⟨j + 1, by rw [eq]; show 2 * j + 1 + 1 = 2 * (j + 1); rw [Nat.mul_succ]⟩

theorem strobe_readsAt : ReadsAt Strobe.twice (fun t => !Strobe.flick t) := by
  intro t
  refine ⟨fun h => ?_, fun ⟨j, eq⟩ => ?_⟩
  · rcases mod2_cases t with ⟨j, eq⟩ | ⟨j, eq⟩
    · exact ⟨j, eq⟩
    · dsimp only at h
      rw [eq, Strobe.flick_odd j] at h
      exact absurd h Bool.false_ne_true
  · dsimp only
    rw [eq, Strobe.flick_even j]
    rfl

theorem strobe_readAtSpanEnd : PacedStock.ReadAtSpanEnd sigmaOdd (fun t => !Strobe.flick t) := by
  intro j t hle hlt
  cases j with
  | zero =>
    have ht0 : t = 0 := Nat.eq_zero_of_le_zero (Nat.le_of_lt_succ hlt)
    rw [ht0]
    exact ⟨fun _ => rfl, fun _ => rfl⟩
  | succ j =>
    have hLo : 2 * j + 1 ≤ t := hle
    have hHi : t < 2 * (j + 1) + 1 := hlt
    have hHiLe : t ≤ 2 * (j + 1) := Nat.le_of_lt_succ hHi
    have hTwo : 2 * (j + 1) = 2 * j + 2 := Nat.mul_succ 2 j
    rw [hTwo] at hHiLe
    rcases Nat.lt_or_eq_of_le hLo with hLt | hEq
    · have htEq : t = 2 * j + 2 := Nat.le_antisymm hHiLe hLt
      rw [htEq]
      refine ⟨fun _ => rfl, fun _ => ?_⟩
      change (!Strobe.flick (2 * (j + 1))) = true
      change (!Strobe.flick (Strobe.twice (j + 1))) = true
      rw [Strobe.flick_even (j + 1)]
      rfl
    · rw [← hEq]
      refine ⟨fun h => ?_, fun heq => ?_⟩
      · have hOdd := Strobe.flick_odd j
        dsimp only at h
        change Strobe.flick (2 * j + 1) = true at hOdd
        rw [hOdd] at h
        exact absurd h Bool.false_ne_true
      · change 2 * j + 1 + 1 = 2 * (j + 1) + 1 at heq
        rw [hTwo] at heq
        exact absurd (Nat.add_assoc (2 * j) 1 1 ▸ heq)
          (Naturals.ne_of_lt (Nat.lt_succ_self (2 * j + 2)))

/-- **General strobe/cadence erasure (`cadence_erases_timely_recovery`).**
Starting from the exact same `c₀ = ((a₀, (w₀, x₀)), r_bad)`:
- If `reads_fine` samples an active signal `sig` at `t_sig` entering an invariant `Inv` under
  `r_safe`, `pacedCourse` preserves `LineOnAStock.Goes` for ALL `t : Nat`.
- If `reads_coarse` evaluates `sig = false` at every read step before `T_end` while `r_bad`
  overdraws renewal (`giving (x - taken) < taken` and `x₀ < T_end + 1`), then `pacedCourse`
  collapses (`∃ T ≤ T_end, ¬ LineOnAStock.Goes`). -/
theorem cadence_erases_timely_recovery {A U R : Type}
    {fA : A → R → A} {need : U → Nat} {kids : R → U → List U}
    {giving : Nat → Nat} {use : U → Nat}
    {h : PacedStock.StockState A U → R → R}
    {reads_fine reads_coarse : Nat → Bool}
    {sig : PacedStock.StockState A U → Bool}
    {r_bad r_safe : R} {a₀ : A} {w₀ : List U} {x₀ T_end : Nat}
    (nothing : RegimeMargin.FromNothing giving)
    (needs : LineOnAStock.Needing need (kids r_bad) w₀)
    (h_safe_of_sig : ∀ s, sig s = true → h s r_bad = r_safe)
    (h_safe_stays : ∀ s, h s r_safe = r_safe)
    (h_noop_of_false : ∀ s r, sig s = false → h s r = r)
    (Inv : PacedStock.StockState A U → Prop)
    (inv_goes : ∀ s, Inv s → LineOnAStock.Goes need s.2)
    (inv_step : ∀ s, Inv s → Inv (PacedStock.fineStep fA need kids giving use s r_safe))
    (fine_hits : ∃ t_sig,
      reads_fine t_sig = true ∧
      sig (PacedStock.pacedCourse fA need kids giving use h reads_fine ((a₀, (w₀, x₀)), r_bad) t_sig).1 = true ∧
      (∀ t, t < t_sig → reads_fine t = true →
        sig (PacedStock.pacedCourse fA need kids giving use h reads_fine ((a₀, (w₀, x₀)), r_bad) t).1 = false) ∧
      (∀ t, t ≤ t_sig →
        LineOnAStock.Goes need
          (PacedStock.pacedCourse fA need kids giving use h reads_fine ((a₀, (w₀, x₀)), r_bad) t).1.2) ∧
      Inv (PacedStock.fineStep fA need kids giving use
        (PacedStock.pacedCourse fA need kids giving use h reads_fine ((a₀, (w₀, x₀)), r_bad) t_sig).1 r_bad))
    (coarse_misses : ∀ t, t < T_end → reads_coarse t = true →
      sig (PacedStock.pacedCourse fA need kids giving use h reads_coarse ((a₀, (w₀, x₀)), r_bad) t).1 = false)
    (bad_excess : ∀ k, k < T_end →
      LineOnAStock.Goes need (LineOnAStock.course need (kids r_bad) giving use (w₀, x₀) k) →
      giving ((LineOnAStock.course need (kids r_bad) giving use (w₀, x₀) k).2 -
        LineOnAStock.taken use (LineOnAStock.course need (kids r_bad) giving use (w₀, x₀) k).1) <
        LineOnAStock.taken use (LineOnAStock.course need (kids r_bad) giving use (w₀, x₀) k).1)
    (x0_bound : x₀ < T_end + 1) :
    let c₀ : PacedStock.StockState A U × R := ((a₀, (w₀, x₀)), r_bad)
    (∀ t, LineOnAStock.Goes need
      (PacedStock.pacedCourse fA need kids giving use h reads_fine c₀ t).1.2) ∧
    ∃ T, T ≤ T_end ∧ ¬ LineOnAStock.Goes need
      (PacedStock.pacedCourse fA need kids giving use h reads_coarse c₀ T).1.2 := by
  let c₀ : PacedStock.StockState A U × R := ((a₀, (w₀, x₀)), r_bad)
  rcases fine_hits with ⟨t_sig, hRF, hSig, hEarlierFalse, hGoesBefore, hEnterInv⟩
  have hRuleBadFine : ∀ t, t ≤ t_sig →
      (PacedStock.pacedCourse fA need kids giving use h reads_fine c₀ t).2 = r_bad := by
    intro t ht
    induction t with
    | zero => rfl
    | succ t ih =>
      have hPrev := ih (Nat.le_of_lt ht)
      have hSucc := Pace.paced_succ (f := PacedStock.fineStep fA need kids giving use)
        (h := h) (reads := reads_fine) c₀ t
      change PacedStock.pacedCourse fA need kids giving use h reads_fine c₀ (t + 1) = _ at hSucc
      rw [hSucc]
      cases hr : reads_fine t with
      | false => exact hPrev
      | true =>
        show h _ (PacedStock.pacedCourse fA need kids giving use h reads_fine c₀ t).2 = r_bad
        rw [hPrev, h_noop_of_false _ r_bad (hEarlierFalse t ht hr)]
  have hAtSucc : Inv (PacedStock.pacedCourse fA need kids giving use h reads_fine c₀ (t_sig + 1)).1 ∧
      (PacedStock.pacedCourse fA need kids giving use h reads_fine c₀ (t_sig + 1)).2 = r_safe := by
    have hSucc := Pace.paced_succ (f := PacedStock.fineStep fA need kids giving use)
      (h := h) (reads := reads_fine) c₀ t_sig
    change PacedStock.pacedCourse fA need kids giving use h reads_fine c₀ (t_sig + 1) = _ at hSucc
    have hAtSig := hRuleBadFine t_sig (Nat.le_refl t_sig)
    rw [hSucc, hRF]
    refine ⟨?_, ?_⟩
    · show Inv (PacedStock.fineStep fA need kids giving use _ _)
      rw [hAtSig]
      exact hEnterInv
    · show h _ _ = r_safe
      rw [hAtSig]
      exact h_safe_of_sig _ hSig
  have hInvFrom : ∀ k,
      Inv (PacedStock.pacedCourse fA need kids giving use h reads_fine c₀ (t_sig + 1 + k)).1 ∧
      (PacedStock.pacedCourse fA need kids giving use h reads_fine c₀ (t_sig + 1 + k)).2 = r_safe := by
    intro k
    exact Pace.stays_turned (f := PacedStock.fineStep fA need kids giving use) (h := h)
      (reads := reads_fine)
      (Q := fun p => Inv p.1 ∧ p.2 = r_safe)
      (fun b p hp => by
        cases b
        · exact ⟨Eq.subst (motive := fun r => Inv (PacedStock.fineStep fA need kids giving use p.1 r))
            hp.2.symm (inv_step p.1 hp.1), hp.2⟩
        · exact ⟨Eq.subst (motive := fun r => Inv (PacedStock.fineStep fA need kids giving use p.1 r))
            hp.2.symm (inv_step p.1 hp.1), hp.2 ▸ h_safe_stays p.1⟩)
      c₀ (t := t_sig + 1) hAtSucc k
  have hFineGoes : ∀ t, LineOnAStock.Goes need
      (PacedStock.pacedCourse fA need kids giving use h reads_fine c₀ t).1.2 := by
    intro t
    cases Nat.lt_or_ge t (t_sig + 1) with
    | inl hlt => exact hGoesBefore t (Nat.le_of_lt_succ hlt)
    | inr hge =>
      rcases le_dest hge with ⟨k, eq⟩
      rw [eq]
      exact inv_goes _ (hInvFrom k).1
  have hCoarseEq : ∀ t, t ≤ T_end →
      (PacedStock.pacedCourse fA need kids giving use h reads_coarse c₀ t).2 = r_bad ∧
      (PacedStock.pacedCourse fA need kids giving use h reads_coarse c₀ t).1.2 =
        LineOnAStock.course need (kids r_bad) giving use (w₀, x₀) t := by
    intro t ht
    induction t with
    | zero => exact ⟨rfl, rfl⟩
    | succ t ih =>
      have hPrev := ih (Nat.le_of_lt ht)
      have hSucc := Pace.paced_succ (f := PacedStock.fineStep fA need kids giving use)
        (h := h) (reads := reads_coarse) c₀ t
      change PacedStock.pacedCourse fA need kids giving use h reads_coarse c₀ (t + 1) = _ at hSucc
      have hRule : (PacedStock.pacedCourse fA need kids giving use h reads_coarse c₀ (t + 1)).2 = r_bad := by
        rw [hSucc]
        cases hr : reads_coarse t with
        | false => exact hPrev.1
        | true =>
          show h _ (PacedStock.pacedCourse fA need kids giving use h reads_coarse c₀ t).2 = r_bad
          rw [hPrev.1, h_noop_of_false _ r_bad (coarse_misses t ht hr)]
      have hStock : (PacedStock.pacedCourse fA need kids giving use h reads_coarse c₀ (t + 1)).1.2 =
          LineOnAStock.course need (kids r_bad) giving use (w₀, x₀) (t + 1) := by
        rw [hSucc]
        cases reads_coarse t <;>
          (show LineOnAStock.step need (kids (PacedStock.pacedCourse fA need kids giving use h reads_coarse c₀ t).2)
              giving use (PacedStock.pacedCourse fA need kids giving use h reads_coarse c₀ t).1.2 =
            LineOnAStock.step need (kids r_bad) giving use
              (LineOnAStock.course need (kids r_bad) giving use (w₀, x₀) t)
           rw [hPrev.1, hPrev.2])
      exact ⟨hRule, hStock⟩
  rcases line_excess_terminates_goes (kids := kids r_bad) (s := (w₀, x₀)) (T := 0) (n := T_end)
    nothing needs
    (fun k hk hG => by rw [Nat.zero_add] at hG ⊢; exact bad_excess k hk hG)
    x0_bound with ⟨T, _, hTLe, hNotGoes⟩
  rw [Nat.zero_add] at hTLe
  exact ⟨hFineGoes, T, hTLe, fun hG => hNotGoes ((hCoarseEq T hTLe).2 ▸ hG)⟩

/-- **Strobe schedule erases window (`strobe_schedule_erases_window`).**
Against a condition with margin `(1 + ℓ) * d ≤ m < (2 + ℓ) * d`, reading at every step
keeps the condition (`ReadingSchedule.Keeps`), while reading only on `Strobe.twice` (missing odd
steps where `other ≠ name c`) fails `Within _ _ 1` and therefore fails `Keeps`. -/
theorem strobe_schedule_erases_window {X C : Type} [DecidableEq X] [DecidableEq C]
    {name : C → X} {c : C} {other : X} (ne : other ≠ name c)
    {ℓ d m : Nat} (fits : (1 + ℓ) * d ≤ m) (exceeds : m < (2 + ℓ) * d) :
    let s_fine : Nat → X := fun _ => name c
    let s_coarse : Nat → X := fun t => if Strobe.flick t then other else name c
    ReadingSchedule.Keeps s_fine name c ℓ d m ∧
    ¬ ReadingSchedule.Keeps s_coarse name c ℓ d m ∧
    (∀ t, s_coarse t = name c ↔ ∃ s, t = Strobe.twice s) := by
  let s_fine : Nat → X := fun _ => name c
  let s_coarse : Nat → X := fun t => if Strobe.flick t then other else name c
  have hFineWithin : ReadingSchedule.Within s_fine (name c) 1 :=
    fun _ => ⟨0, Nat.zero_lt_one, rfl⟩
  have hFineKeeps : ReadingSchedule.Keeps s_fine name c ℓ d m :=
    ReadingSchedule.keeps_of_within hFineWithin fits
  have hCoarseNotWithin : ¬ ReadingSchedule.Within s_coarse (name c) 1 := fun hWithin => by
    rcases hWithin 1 with ⟨j, hj, hRead⟩
    have hj0 : j = 0 := Nat.eq_zero_of_le_zero (Nat.le_of_lt_succ hj)
    rw [hj0, Nat.add_zero] at hRead
    have hFlick1 : Strobe.flick 1 = true := Strobe.flick_odd 0
    dsimp only [s_coarse] at hRead
    rw [hFlick1] at hRead
    exact ne hRead
  have hCoarseNotKeeps : ¬ ReadingSchedule.Keeps s_coarse name c ℓ d m := fun hKeeps =>
    hCoarseNotWithin ((ReadingSchedule.keeps_iff_within (X := X) (C := C) fits exceeds).mp hKeeps)
  have hReadAtTwice : ∀ t, s_coarse t = name c ↔ ∃ s, t = Strobe.twice s := fun t => by
    dsimp only [s_coarse]
    refine ⟨fun h => ?_, fun ⟨s, eq⟩ => ?_⟩
    · cases hf : Strobe.flick t with
      | true => rw [hf] at h; exact absurd h ne
      | false =>
        have hb : (!Strobe.flick t) = true := by rw [hf]; rfl
        exact strobe_readsAt t |>.mp hb
    · rw [eq, Strobe.flick_even s]; rfl
  exact ⟨hFineKeeps, hCoarseNotKeeps, hReadAtTwice⟩

/- **Concrete verified 6-step witness (`CadenceErasureWitness`).**
From identical start `((false, ([.agg], 7)), false)`:
- Fine reading (`readsFine _ := true`) detects `b_1 = true` at `t = 1`, switches to `.safe` by
  `t = 3`, stabilizes at `x = 4`, and keeps `LineOnAStock.Goes` for ALL `t : Nat`.
- Coarse strobe reading (`readsCoarse t := !Strobe.flick t`) satisfies `ReadsAt Strobe.twice` and
  `ReadAtSpanEnd sigmaOdd`, misses every odd step `b_{2j+1} = true`, drains `7 → 6 → 5 → 4 → 3
  → 2 → 0`, and hits `¬ LineOnAStock.Goes` at exact step `t = 6`. -/
namespace CadenceErasureWitness

inductive UnitKind where
  | safe
  | agg

def need (_ : UnitKind) : Nat := 1
def use : UnitKind → Nat
  | .safe => 1
  | .agg => 2
def giving (z : Nat) : Nat := if 1 ≤ z then 1 else 0
def kids : Bool → UnitKind → List UnitKind
  | false, _ => [.agg]
  | true, _ => [.safe]
def fA (b : Bool) (_ : Bool) : Bool := !b
def h (s : PacedStock.StockState Bool UnitKind) (r : Bool) : Bool := r || s.1
def sig (s : PacedStock.StockState Bool UnitKind) : Bool := s.1
def startConfig : PacedStock.StockState Bool UnitKind × Bool := ((false, ([.agg], 7)), false)
def readsFine (_ : Nat) : Bool := true
def readsCoarse (t : Nat) : Bool := !Strobe.flick t

theorem witness_giving_fromNothing : RegimeMargin.FromNothing giving := rfl

theorem witness_needs : LineOnAStock.Needing need (kids false) [.agg] :=
  fun _ _ _ => Nat.zero_lt_one

def safeInv (s : PacedStock.StockState Bool UnitKind) : Prop :=
  (s.2.1 = [.safe] ∧ 2 ≤ s.2.2) ∨ (s.2.1 = [.agg] ∧ 3 ≤ s.2.2)

theorem witness_inv_goes (s : PacedStock.StockState Bool UnitKind) (hs : safeInv s) :
    LineOnAStock.Goes need s.2 := by
  rcases s with ⟨b, ⟨w, x⟩⟩
  rcases hs with ⟨hw, hx⟩ | ⟨hw, hx⟩
  · dsimp only at hw hx; rw [hw]
    exact ⟨.safe, .head [], Nat.le_trans (Nat.le_succ 1) hx⟩
  · dsimp only at hw hx; rw [hw]
    exact ⟨.agg, .head [], Nat.le_trans (Nat.le_succ 1) (Nat.le_trans (Nat.le_succ 2) hx)⟩

theorem witness_inv_step (s : PacedStock.StockState Bool UnitKind) (hs : safeInv s) :
    safeInv (PacedStock.fineStep fA need kids giving use s true) := by
  rcases s with ⟨b, ⟨w, x⟩⟩
  rcases hs with ⟨hw, hx⟩ | ⟨hw, hx⟩
  · dsimp only at hw hx
    rw [hw]
    refine Or.inl ⟨?_, ?_⟩
    · show cond (decide (1 ≤ x)) (kids true .safe) [] ++ [] = [.safe]
      rw [decide_eq_true (Nat.le_trans (Nat.le_succ 1) hx)]
      rfl
    · show (x - 1) + giving (x - 1) ≥ 2
      have hSub : 1 ≤ x - 1 := Naturals.le_sub_of_add_le hx
      have hG : giving (x - 1) = 1 := if_pos hSub
      rw [hG, Naturals.sub_add_cancel (Nat.le_trans (Nat.le_succ 1) hx)]
      exact hx
  · dsimp only at hw hx
    rw [hw]
    refine Or.inl ⟨?_, ?_⟩
    · show cond (decide (1 ≤ x)) (kids true .agg) [] ++ [] = [.safe]
      rw [decide_eq_true (Nat.le_trans (Nat.le_succ 1) (Nat.le_trans (Nat.le_succ 2) hx))]
      rfl
    · show (x - 2) + giving (x - 2) ≥ 2
      have hSub : 1 ≤ x - 2 := Naturals.le_sub_of_add_le hx
      have hG : giving (x - 2) = 1 := if_pos hSub
      rw [hG]
      rcases le_dest hx with ⟨k, eq⟩
      rw [eq]
      show (3 + k - 2) + 1 ≥ 2
      have eq3 : 3 + k = k + 1 + 2 := by
        rw [Nat.add_comm 3 k, ← Nat.add_assoc k 1 2]
      rw [eq3, Naturals.add_sub_cancel]
      exact Nat.le_add_left 2 k

theorem witness_coarse_b_parity : ∀ t,
    (PacedStock.pacedCourse fA need kids giving use h readsCoarse startConfig t).1.1 =
      Strobe.flick t ∧
    (PacedStock.pacedCourse fA need kids giving use h readsCoarse startConfig t).2 = false := by
  intro t
  induction t with
  | zero => exact ⟨rfl, rfl⟩
  | succ t ih =>
    have hSucc := Pace.paced_succ (f := PacedStock.fineStep fA need kids giving use)
      (h := h) (reads := readsCoarse) startConfig t
    change PacedStock.pacedCourse fA need kids giving use h readsCoarse startConfig (t + 1) = _ at hSucc
    rw [hSucc]
    have hb := ih.1
    have hr := ih.2
    cases hFlick : Strobe.flick t with
    | false =>
      have hReads : readsCoarse t = true := by dsimp only [readsCoarse]; rw [hFlick]; rfl
      rw [hReads]
      dsimp only [Pace.turn, PacedStock.fineStep, fA, h, Strobe.flick]
      refine ⟨?_, ?_⟩
      · rw [hb, hFlick]
      · rw [hr, hb, hFlick]; rfl
    | true =>
      have hReads : readsCoarse t = false := by dsimp only [readsCoarse]; rw [hFlick]; rfl
      rw [hReads]
      dsimp only [Pace.turn, PacedStock.fineStep, fA, Strobe.flick]
      refine ⟨?_, hr⟩
      rw [hb, hFlick]

theorem witness_bundle :
    ReadsAt Strobe.twice readsCoarse ∧
    PacedStock.ReadAtSpanEnd sigmaOdd readsCoarse ∧
    (∀ t, LineOnAStock.Goes need
      (PacedStock.pacedCourse fA need kids giving use h readsFine startConfig t).1.2) ∧
    (PacedStock.pacedCourse fA need kids giving use h readsCoarse startConfig 6).1.2.2 = 0 ∧
    ¬ LineOnAStock.Goes need
      (PacedStock.pacedCourse fA need kids giving use h readsCoarse startConfig 6).1.2 := by
  have hMain := cadence_erases_timely_recovery
    (fA := fA) (need := need) (kids := kids) (giving := giving) (use := use)
    (h := h) (reads_fine := readsFine) (reads_coarse := readsCoarse) (sig := sig)
    (r_bad := false) (r_safe := true) (a₀ := false) (w₀ := [.agg]) (x₀ := 7) (T_end := 7)
    witness_giving_fromNothing witness_needs
    (fun _ hs => by dsimp only [h, sig] at hs ⊢; rw [hs]; rfl)
    (fun _ => rfl)
    (fun _ r hs => by dsimp only [h, sig] at hs ⊢; rw [hs]; cases r <;> rfl)
    safeInv witness_inv_goes witness_inv_step
    ⟨1, rfl, rfl,
      fun t ht _ => by
        cases t with
        | zero => rfl
        | succ t' => exact absurd ht (Nat.not_lt_of_le (Nat.le_add_left 1 t')),
      fun t ht => match t, ht with
        | 0, _ => ⟨.agg, .head [], by decide⟩
        | 1, _ => ⟨.agg, .head [], by decide⟩
        | _ + 2, lt => absurd lt (Nat.not_lt_of_le (Nat.le_add_left 1 _)),
      Or.inr ⟨rfl, by decide⟩⟩
    (fun t _ hr => by
      dsimp only [readsCoarse] at hr
      have hf : Strobe.flick t = false := by
        cases hft : Strobe.flick t with
        | false => rfl
        | true => rw [hft] at hr; exact absurd hr Bool.false_ne_true
      show (PacedStock.pacedCourse fA need kids giving use h readsCoarse startConfig t).1.1 = false
      rw [(witness_coarse_b_parity t).1, hf])
    (fun k _ hG => by
      have hIsAgg : ∀ j,
          (LineOnAStock.course need (kids false) giving use ([.agg], 7) j).1 = [.agg] ∨
          (LineOnAStock.course need (kids false) giving use ([.agg], 7) j).1 = [] := by
        intro j
        induction j with
        | zero => exact Or.inl rfl
        | succ j ih =>
          rcases ih with hw | hw
          · have hNext :
                (LineOnAStock.course need (kids false) giving use ([.agg], 7) (j + 1)).1 =
                  LineOnAStock.after need (kids false)
                    (LineOnAStock.course need (kids false) giving use ([.agg], 7) j).1
                    (LineOnAStock.course need (kids false) giving use ([.agg], 7) j).2 := rfl
            rw [hNext, hw]
            dsimp only [LineOnAStock.after]
            cases decide (need .agg ≤ (LineOnAStock.course need (kids false) giving use ([.agg], 7) j).2)
            · exact Or.inr rfl
            · exact Or.inl rfl
          · have hNext :
                (LineOnAStock.course need (kids false) giving use ([.agg], 7) (j + 1)).1 =
                  LineOnAStock.after need (kids false)
                    (LineOnAStock.course need (kids false) giving use ([.agg], 7) j).1
                    (LineOnAStock.course need (kids false) giving use ([.agg], 7) j).2 := rfl
            rw [hNext, hw]
            exact Or.inr rfl
      rcases hIsAgg k with hw | hw
      · rw [hw]
        show giving ((LineOnAStock.course need (kids false) giving use ([.agg], 7) k).2 - 2) < 2
        dsimp only [giving]
        split
        · exact Nat.lt_succ_self 1
        · exact Nat.zero_lt_succ 1
      · exfalso
        rcases hG with ⟨_, mu, _⟩
        rw [hw] at mu
        nomatch mu)
    (Nat.lt_succ_self 7)
  have hAt6 : (PacedStock.pacedCourse fA need kids giving use h readsCoarse startConfig 6).1.2 = ([.agg], 0) :=
    rfl
  refine ⟨strobe_readsAt, strobe_readAtSpanEnd, hMain.1, congrArg Prod.snd hAt6, fun ⟨_, _, hLe⟩ => ?_⟩
  rw [congrArg Prod.snd hAt6] at hLe
  exact Nat.not_lt_of_le hLe Nat.zero_lt_one

end CadenceErasureWitness

/-! #### C3. Coupling-Depth Sampled Deadline -/

/-- Explicit actuation-lag draw invariant on `PacedStock.pacedCourse` over `[T, T + N)`:
while all needs along `[T, t]` are met, the draw at step `t` is at least `H_bad`. -/
def PacedLowerDrawWhileMet {A U R : Type} (H_bad : Nat)
    (fA : A → R → A) (need : U → Nat) (kids : R → U → List U)
    (giving : Nat → Nat) (use : U → Nat) (h : PacedStock.StockState A U → R → R)
    (reads : Nat → Bool) (c₀ : PacedStock.StockState A U × R) (T N : Nat) : Prop :=
  ∀ t, T ≤ t → t < T + N →
    (∀ j, T ≤ j → j ≤ t → ∀ u,
      u ∈ (PacedStock.pacedCourse fA need kids giving use h reads c₀ j).1.2.1 →
      need u ≤ (PacedStock.pacedCourse fA need kids giving use h reads c₀ j).1.2.2) →
    H_bad ≤ LineOnAStock.taken use
      (PacedStock.pacedCourse fA need kids giving use h reads c₀ t).1.2.1

theorem pacedCourse_span0_matches {A U R : Type}
    {fA : A → R → A} {need : U → Nat} {kids : R → U → List U}
    {giving : Nat → Nat} {use : U → Nat}
    {h : PacedStock.StockState A U → R → R} {reads : Nat → Bool} {σ : Nat → Nat}
    {L : Nat} (σ0 : σ 0 = 0) (σ1 : σ 1 = L) (strict : Becoming.Strict σ)
    (cadence : PacedStock.ReadAtSpanEnd σ reads) {a₀ : A} {w₀ : List U} {x₀ : Nat} {r_bad : R} :
    ∀ t, t ≤ L →
      (PacedStock.pacedCourse fA need kids giving use h reads ((a₀, (w₀, x₀)), r_bad) t).1.2 =
        LineOnAStock.course need (kids r_bad) giving use (w₀, x₀) t := by
  let c₀ : PacedStock.StockState A U × R := ((a₀, (w₀, x₀)), r_bad)
  intro t ht
  cases Nat.lt_or_eq_of_le ht with
  | inl hlt =>
    have memSpan : t ∈ Becoming.span σ 0 :=
      Becoming.span_mem strict
        (Eq.subst (motive := (· ≤ t)) σ0.symm (Nat.zero_le t))
        (Eq.subst (motive := (t < ·)) σ1.symm hlt)
    have hHeld := (PacedStock.paced_held_on_span
      (fA := fA) (need := need) (kids := kids) (giving := giving) (use := use) (h := h)
      strict cadence c₀ memSpan).2
    rw [σ0, Nat.sub_zero] at hHeld
    exact hHeld
  | inr heq =>
    have hTrans := (PacedStock.paced_block_transition
      (fA := fA) (need := need) (kids := kids) (giving := giving) (use := use) (h := h)
      strict cadence c₀ 0).1
    rw [σ1, σ0, Nat.sub_zero] at hTrans
    change (PacedStock.pacedCourse fA need kids giving use h reads c₀ t).1.2 = _
    rw [heq, hTrans]
    exact PacedStock.fineStep_orbit_snd (a₀, (w₀, x₀)) r_bad L

/-- For `δ = 1` (one step past `σ 1`), `PacedLowerDrawWhileMet` follows unconditionally for EVERY
`h` directly from `PacedStock.LowerDrawWhileMet` on the `r_bad` course. -/
theorem lagDraw_one_of_lower {A U R : Type}
    {fA : A → R → A} {need : U → Nat} {kids : R → U → List U}
    {giving : Nat → Nat} {use : U → Nat}
    {H_bad L : Nat} {r_bad : R} {a₀ : A} {w₀ : List U} {x₀ : Nat}
    (σ : Nat → Nat) (σ0 : σ 0 = 0) (σ1 : σ 1 = L) (strict : Becoming.Strict σ)
    (reads : Nat → Bool) (cadence : PacedStock.ReadAtSpanEnd σ reads)
    (lower : PacedStock.LowerDrawWhileMet H_bad need kids giving use r_bad w₀ x₀ (L + 1))
    (h : PacedStock.StockState A U → R → R) :
    PacedLowerDrawWhileMet H_bad fA need kids giving use h reads ((a₀, (w₀, x₀)), r_bad) 0 (L + 1) := by
  intro t _ ht hMet
  rw [Nat.zero_add] at ht
  have hEqT := pacedCourse_span0_matches (fA := fA) (need := need) (kids := kids)
    (giving := giving) (use := use) (h := h) (a₀ := a₀) (w₀ := w₀) (x₀ := x₀) (r_bad := r_bad)
    σ0 σ1 strict cadence t (Nat.le_of_lt_succ ht)
  rw [hEqT]
  refine lower t ht fun j hj u mu => ?_
  have hEqJ := pacedCourse_span0_matches (fA := fA) (need := need) (kids := kids)
    (giving := giving) (use := use) (h := h) (a₀ := a₀) (w₀ := w₀) (x₀ := x₀) (r_bad := r_bad)
    σ0 σ1 strict cadence j (Nat.le_trans hj (Nat.le_of_lt_succ ht))
  rw [← hEqJ]
  exact hMet j (Nat.zero_le j) hj u (hEqJ ▸ mu)

theorem pacedCourse_step_level {A U R : Type}
    {fA : A → R → A} {need : U → Nat} {kids : R → U → List U}
    {giving : Nat → Nat} {use : U → Nat}
    {h : PacedStock.StockState A U → R → R} {reads : Nat → Bool}
    (c₀ : PacedStock.StockState A U × R) (t : Nat) :
    (PacedStock.pacedCourse fA need kids giving use h reads c₀ (t + 1)).1.2.2 =
      RegimeMargin.step giving
        (LineOnAStock.taken use (PacedStock.pacedCourse fA need kids giving use h reads c₀ t).1.2.1)
        (PacedStock.pacedCourse fA need kids giving use h reads c₀ t).1.2.2 := by
  have hSucc := Pace.paced_succ (f := PacedStock.fineStep fA need kids giving use)
    (h := h) (reads := reads) c₀ t
  change PacedStock.pacedCourse fA need kids giving use h reads c₀ (t + 1) = _ at hSucc
  rw [hSucc]
  cases reads t <;> rfl

theorem pacedCourse_envelope_upper {A U R : Type}
    {fA : A → R → A} {need : U → Nat} {kids : R → U → List U}
    {giving : Nat → Nat} {use : U → Nat}
    {h : PacedStock.StockState A U → R → R} {reads : Nat → Bool}
    {c₀ : PacedStock.StockState A U × R} {Y H_bad T N : Nat}
    (most : RegimeMargin.AtMost giving Y)
    (lower : PacedLowerDrawWhileMet H_bad fA need kids giving use h reads c₀ T N)
    (met : ∀ t, T ≤ t → t < T + N → ∀ u,
      u ∈ (PacedStock.pacedCourse fA need kids giving use h reads c₀ t).1.2.1 →
      need u ≤ (PacedStock.pacedCourse fA need kids giving use h reads c₀ t).1.2.2) :
    ∀ k, k ≤ N →
      (PacedStock.pacedCourse fA need kids giving use h reads c₀ (T + k)).1.2.2 ≤
        Law.orbit (RegimeMargin.step (fun _ => Y) H_bad)
          (PacedStock.pacedCourse fA need kids giving use h reads c₀ T).1.2.2 k
  | 0, _ => Nat.le_refl _
  | k + 1, le =>
    have kLt : k < N := Nat.lt_of_succ_le le
    have ih := pacedCourse_envelope_upper most lower met k (Nat.le_of_lt kLt)
    have hDraw : H_bad ≤ LineOnAStock.taken use
        (PacedStock.pacedCourse fA need kids giving use h reads c₀ (T + k)).1.2.1 :=
      lower (T + k) (Nat.le_add_right T k) (Nat.add_lt_add_left kLt T)
        (fun j hj1 hj2 => met j hj1 (Nat.lt_of_le_of_lt hj2 (Nat.add_lt_add_left kLt T)))
    have hSub :
        (PacedStock.pacedCourse fA need kids giving use h reads c₀ (T + k)).1.2.2 -
          LineOnAStock.taken use
            (PacedStock.pacedCourse fA need kids giving use h reads c₀ (T + k)).1.2.1 ≤
          Law.orbit (RegimeMargin.step (fun _ => Y) H_bad)
            (PacedStock.pacedCourse fA need kids giving use h reads c₀ T).1.2.2 k - H_bad :=
      Nat.le_trans (Naturals.sub_antitone _ hDraw) (Nat.sub_le_sub_right ih H_bad)
    have hStepEq :
        (PacedStock.pacedCourse fA need kids giving use h reads c₀ (T + (k + 1))).1.2.2 =
          RegimeMargin.step giving
            (LineOnAStock.taken use
              (PacedStock.pacedCourse fA need kids giving use h reads c₀ (T + k)).1.2.1)
            (PacedStock.pacedCourse fA need kids giving use h reads c₀ (T + k)).1.2.2 := by
      rw [← Nat.add_assoc T k 1]
      exact pacedCourse_step_level c₀ (T + k)
    Nat.le_trans (Nat.le_of_eq hStepEq)
      (Nat.add_le_add hSub (most _))

theorem pacedCourse_stays_below_aux {A U R : Type}
    {fA : A → R → A} {need : U → Nat} {kids : R → U → List U}
    {giving : Nat → Nat} {use : U → Nat}
    {h : PacedStock.StockState A U → R → R} {reads : Nat → Bool}
    {c₀ : PacedStock.StockState A U × R} {H_min y₂ T N : Nat}
    (nothing : RegimeMargin.FromNothing giving)
    (short2 : RegimeMargin.Short giving H_min y₂)
    (floorDraw : ∀ w, w ≠ [] → H_min ≤ LineOnAStock.taken use w)
    (allGoes : ∀ t, T ≤ t → t < T + N →
      LineOnAStock.Goes need (PacedStock.pacedCourse fA need kids giving use h reads c₀ t).1.2) :
    ∀ d k, k + d ≤ N →
      (PacedStock.pacedCourse fA need kids giving use h reads c₀ (T + k)).1.2.2 < H_min + y₂ →
      (PacedStock.pacedCourse fA need kids giving use h reads c₀ (T + (k + d))).1.2.2 < H_min + y₂
  | 0, _, _, under => under
  | d + 1, k, bound, under =>
    have kLt : k < N := Nat.lt_of_lt_of_le (Nat.lt_add_of_pos_right (Nat.succ_pos d)) bound
    have wNe : (PacedStock.pacedCourse fA need kids giving use h reads c₀ (T + k)).1.2.1 ≠ [] :=
      match allGoes (T + k) (Nat.le_add_right T k) (Nat.add_lt_add_left kLt T) with
      | ⟨_, mu, _⟩ => fun e => nomatch (e ▸ mu)
    have dGe : H_min ≤ LineOnAStock.taken use
        (PacedStock.pacedCourse fA need kids giving use h reads c₀ (T + k)).1.2.1 :=
      floorDraw _ wNe
    have hStepEq : (PacedStock.pacedCourse fA need kids giving use h reads c₀ (T + (k + 1))).1.2.2 =
        RegimeMargin.step giving
          (LineOnAStock.taken use
            (PacedStock.pacedCourse fA need kids giving use h reads c₀ (T + k)).1.2.1)
          (PacedStock.pacedCourse fA need kids giving use h reads c₀ (T + k)).1.2.2 := by
      rw [← Nat.add_assoc T k 1]
      exact pacedCourse_step_level c₀ (T + k)
    have underSucc :
        (PacedStock.pacedCourse fA need kids giving use h reads c₀ (T + (k + 1))).1.2.2 < H_min + y₂ := by
      rw [hStepEq]
      match LineOnAStock.step_lowers short2 nothing dGe under with
      | .inl zero => exact Nat.lt_of_le_of_lt (Nat.le_of_eq zero) (Nat.lt_of_le_of_lt (Nat.zero_le _) under)
      | .inr lt => exact Nat.lt_trans lt under
    have eqAdd : k + (d + 1) = (k + 1) + d :=
      ((Nat.add_assoc k 1 d).trans (congrArg (k + ·) (Nat.add_comm 1 d))).symm
    have k1Le : (k + 1) + d ≤ N := Nat.le_trans (Nat.le_of_eq eqAdd.symm) bound
    eqAdd ▸ pacedCourse_stays_below_aux nothing short2 floorDraw allGoes d (k + 1) k1Le underSucc

theorem pacedCourse_stays_below_while_goes {A U R : Type}
    {fA : A → R → A} {need : U → Nat} {kids : R → U → List U}
    {giving : Nat → Nat} {use : U → Nat}
    {h : PacedStock.StockState A U → R → R} {reads : Nat → Bool}
    {c₀ : PacedStock.StockState A U × R} {H_min y₂ T N : Nat}
    (nothing : RegimeMargin.FromNothing giving)
    (short2 : RegimeMargin.Short giving H_min y₂)
    (floorDraw : ∀ w, w ≠ [] → H_min ≤ LineOnAStock.taken use w)
    (allGoes : ∀ t, T ≤ t → t < T + N →
      LineOnAStock.Goes need (PacedStock.pacedCourse fA need kids giving use h reads c₀ t).1.2) :
    ∀ k, k ≤ N →
      (PacedStock.pacedCourse fA need kids giving use h reads c₀ (T + k)).1.2.2 < H_min + y₂ →
      (PacedStock.pacedCourse fA need kids giving use h reads c₀ (T + N)).1.2.2 < H_min + y₂
  | k, le, under =>
    match le_dest le with
    | ⟨d, eq⟩ =>
      eq.symm ▸ pacedCourse_stays_below_aux nothing short2 floorDraw allGoes d k
        (Nat.le_of_eq eq.symm) under

theorem pacedCourse_ends_step_pub {A U R : Type}
    {fA : A → R → A} {need : U → Nat} {kids : R → U → List U}
    {giving : Nat → Nat} {use : U → Nat}
    {h : PacedStock.StockState A U → R → R} {reads : Nat → Bool}
    {H_min y₂ : Nat}
    (nothing : RegimeMargin.FromNothing giving)
    (short2 : RegimeMargin.Short giving H_min y₂)
    (needsPos : ∀ u, 0 < need u)
    (floorDraw : ∀ w, w ≠ [] → H_min ≤ LineOnAStock.taken use w)
    (c : PacedStock.StockState A U × R) (t : Nat)
    (under : (PacedStock.pacedCourse fA need kids giving use h reads c t).1.2.2 < H_min + y₂) :
    (∃ n, ¬ LineOnAStock.Goes need (PacedStock.pacedCourse fA need kids giving use h reads c n).1.2) ∨
      ((PacedStock.pacedCourse fA need kids giving use h reads c (t + 1)).1.2.2 <
        (PacedStock.pacedCourse fA need kids giving use h reads c t).1.2.2 ∧
      (PacedStock.pacedCourse fA need kids giving use h reads c (t + 1)).1.2.2 < H_min + y₂) :=
  match LineOnAStock.goesDecidable need (PacedStock.pacedCourse fA need kids giving use h reads c t).1.2 with
  | .isFalse noGoes => Or.inl ⟨t, noGoes⟩
  | .isTrue ⟨_, mu, _⟩ =>
    have wNe : (PacedStock.pacedCourse fA need kids giving use h reads c t).1.2.1 ≠ [] :=
      fun e => nomatch (e ▸ mu)
    have dGe : H_min ≤ LineOnAStock.taken use
        (PacedStock.pacedCourse fA need kids giving use h reads c t).1.2.1 :=
      floorDraw _ wNe
    have xNextEq := pacedCourse_step_level (fA := fA) (need := need) (kids := kids)
      (giving := giving) (use := use) (h := h) (reads := reads) c t
    match LineOnAStock.step_lowers short2 nothing dGe under with
    | .inl zero =>
      Or.inl ⟨t + 1, fun ⟨v, _, le⟩ =>
        absurd (Nat.le_trans le (Nat.le_of_eq (xNextEq.trans zero)))
          (Nat.not_le_of_gt (needsPos v))⟩
    | .inr lower =>
      have ltNext : (PacedStock.pacedCourse fA need kids giving use h reads c (t + 1)).1.2.2 <
          (PacedStock.pacedCourse fA need kids giving use h reads c t).1.2.2 :=
        Eq.subst (motive := (· < _)) xNextEq.symm lower
      Or.inr ⟨ltNext, Nat.lt_trans ltNext under⟩

theorem pacedCourse_ends_below_point_pub {A U R : Type}
    {fA : A → R → A} {need : U → Nat} {kids : R → U → List U}
    {giving : Nat → Nat} {use : U → Nat}
    {h : PacedStock.StockState A U → R → R} {reads : Nat → Bool}
    {H_min y₂ : Nat}
    (nothing : RegimeMargin.FromNothing giving)
    (short2 : RegimeMargin.Short giving H_min y₂)
    (needsPos : ∀ u, 0 < need u)
    (floorDraw : ∀ w, w ≠ [] → H_min ≤ LineOnAStock.taken use w)
    (c : PacedStock.StockState A U × R) :
    ∀ f t,
      (PacedStock.pacedCourse fA need kids giving use h reads c t).1.2.2 ≤ f →
      (PacedStock.pacedCourse fA need kids giving use h reads c t).1.2.2 < H_min + y₂ →
      ∃ n, ¬ LineOnAStock.Goes need
        (PacedStock.pacedCourse fA need kids giving use h reads c n).1.2
  | 0, t, bound, under =>
    match pacedCourse_ends_step_pub nothing short2 needsPos floorDraw c t under with
    | .inl found => found
    | .inr ⟨lower, _⟩ => absurd (Nat.lt_of_lt_of_le lower bound) (Nat.not_lt_zero _)
  | f + 1, t, bound, under =>
    match pacedCourse_ends_step_pub nothing short2 needsPos floorDraw c t under with
    | .inl found => found
    | .inr ⟨lower, underNext⟩ =>
      pacedCourse_ends_below_point_pub nothing short2 needsPos floorDraw c f (t + 1)
        (Nat.le_of_lt_succ (Nat.lt_of_lt_of_le lower bound)) underNext

/-- **Arbitrary-offset `pacedCourse` deadline impossibility (`sampled_deadline_impossibility_at`).**
Via `RegimeMargin.falls_within`, `pacedCourse_envelope_upper`, and `LineOnAStock.step_lowers`
(never assuming `taken ≤ level` past early overdraw). -/
theorem sampled_deadline_impossibility_at {A U R : Type}
    {fA : A → R → A} {need : U → Nat} {kids : R → U → List U}
    {giving : Nat → Nat} {use : U → Nat}
    {h : PacedStock.StockState A U → R → R} {reads : Nat → Bool}
    {c₀ : PacedStock.StockState A U × R}
    {Y H_bad H_min y₂ T M : Nat}
    (nothing : RegimeMargin.FromNothing giving)
    (most : RegimeMargin.AtMost giving Y)
    (yLtH : Y < H_bad)
    (hLe : H_bad ≤ H_min + y₂)
    (short2 : RegimeMargin.Short giving H_min y₂)
    (needsPos : ∀ u, 0 < need u ∧ need u ≤ H_min + y₂)
    (floorDraw : ∀ w, w ≠ [] → H_min ≤ LineOnAStock.taken use w)
    (lagDraw : PacedLowerDrawWhileMet H_bad fA need kids giving use h reads c₀ T M)
    (underThreshold :
      (PacedStock.pacedCourse fA need kids giving use h reads c₀ T).1.2.2 <
        (H_min + y₂) + (H_bad - Y) * M) :
    ((∀ t, T ≤ t → t < T + M →
        LineOnAStock.Goes need (PacedStock.pacedCourse fA need kids giving use h reads c₀ t).1.2) →
      (PacedStock.pacedCourse fA need kids giving use h reads c₀ (T + M)).1.2.2 < H_min + y₂) ∧
    ∃ t, ¬ LineOnAStock.Goes need (PacedStock.pacedCourse fA need kids giving use h reads c₀ t).1.2 := by
  have decMet :
      (∀ k, k < M → ∀ u,
        u ∈ (PacedStock.pacedCourse fA need kids giving use h reads c₀ (T + k)).1.2.1 →
        need u ≤ (PacedStock.pacedCourse fA need kids giving use h reads c₀ (T + k)).1.2.2) ∨
      ∃ k, k < M ∧ ∃ u,
        u ∈ (PacedStock.pacedCourse fA need kids giving use h reads c₀ (T + k)).1.2.1 ∧
        (PacedStock.pacedCourse fA need kids giving use h reads c₀ (T + k)).1.2.2 < need u := by
    have aux : ∀ m,
        (∀ k, k < m → ∀ u,
          u ∈ (PacedStock.pacedCourse fA need kids giving use h reads c₀ (T + k)).1.2.1 →
          need u ≤ (PacedStock.pacedCourse fA need kids giving use h reads c₀ (T + k)).1.2.2) ∨
        ∃ k, k < m ∧ ∃ u,
          u ∈ (PacedStock.pacedCourse fA need kids giving use h reads c₀ (T + k)).1.2.1 ∧
          (PacedStock.pacedCourse fA need kids giving use h reads c₀ (T + k)).1.2.2 < need u := by
      intro m
      induction m with
      | zero => exact Or.inl fun _ lt => absurd lt (Nat.not_lt_zero _)
      | succ m ih =>
        rcases ih with allM | ⟨k, kLt, u, mu, unmet⟩
        · match LineOnAStock.met_or_unmet need
              (PacedStock.pacedCourse fA need kids giving use h reads c₀ (T + m)).1.2.2
              (PacedStock.pacedCourse fA need kids giving use h reads c₀ (T + m)).1.2.1 with
          | .inl atM =>
            exact Or.inl fun k lt =>
              (Nat.lt_or_eq_of_le (Nat.le_of_lt_succ lt)).elim (allM k) fun eq => eq ▸ atM
          | .inr ⟨u, mu, unmet⟩ => exact Or.inr ⟨m, Nat.lt_succ_self m, u, mu, unmet⟩
        · exact Or.inr ⟨k, Nat.lt_succ_of_lt kLt, u, mu, unmet⟩
    exact aux M
  have belowAtEnd :
      (∀ t, T ≤ t → t < T + M →
        LineOnAStock.Goes need (PacedStock.pacedCourse fA need kids giving use h reads c₀ t).1.2) →
      (PacedStock.pacedCourse fA need kids giving use h reads c₀ (T + M)).1.2.2 < H_min + y₂ := by
    intro allGoes
    rcases decMet with allMet | ⟨k, kLt, u, _, unmet⟩
    · have metT : ∀ t, T ≤ t → t < T + M → ∀ u,
          u ∈ (PacedStock.pacedCourse fA need kids giving use h reads c₀ t).1.2.1 →
          need u ≤ (PacedStock.pacedCourse fA need kids giving use h reads c₀ t).1.2.2 := by
        intro t ht1 ht2
        rcases le_dest ht1 with ⟨k, eqT⟩
        have kLt : k < M := Naturals.lt_of_add_lt_add_left (k := T) (eqT ▸ ht2)
        exact eqT ▸ allMet k kLt
      have falls := RegimeMargin.falls_within (g := fun _ => Y) (H := H_bad) (Y := Y)
        (b := H_min + y₂)
        (x := (PacedStock.pacedCourse fA need kids giving use h reads c₀ T).1.2.2)
        (n := M) (fun _ => Nat.le_refl Y) (Nat.le_of_lt yLtH) hLe underThreshold
      rcases falls with ⟨k, kLe, kLt⟩
      have kLtCourse :
          (PacedStock.pacedCourse fA need kids giving use h reads c₀ (T + k)).1.2.2 < H_min + y₂ :=
        Nat.lt_of_le_of_lt (pacedCourse_envelope_upper most lagDraw metT k kLe) kLt
      exact pacedCourse_stays_below_while_goes nothing short2 floorDraw allGoes k kLe kLtCourse
    · have kLtCourse :
          (PacedStock.pacedCourse fA need kids giving use h reads c₀ (T + k)).1.2.2 < H_min + y₂ :=
        Nat.lt_of_lt_of_le unmet (needsPos u).2
      exact pacedCourse_stays_below_while_goes nothing short2 floorDraw allGoes
        k (Nat.le_of_lt kLt) kLtCourse
  refine ⟨belowAtEnd, ?_⟩
  have decGoes :
      (∀ k, k < M →
        LineOnAStock.Goes need (PacedStock.pacedCourse fA need kids giving use h reads c₀ (T + k)).1.2) ∨
      ∃ k, k < M ∧
        ¬ LineOnAStock.Goes need (PacedStock.pacedCourse fA need kids giving use h reads c₀ (T + k)).1.2 :=
    dec_all_or_exists (fun k =>
      match LineOnAStock.goesDecidable need
          (PacedStock.pacedCourse fA need kids giving use h reads c₀ (T + k)).1.2 with
      | .isTrue yes => Or.inl yes
      | .isFalse no => Or.inr no) M
  rcases decGoes with allK | ⟨k, _, noK⟩
  · have allT : ∀ t, T ≤ t → t < T + M →
        LineOnAStock.Goes need (PacedStock.pacedCourse fA need kids giving use h reads c₀ t).1.2 := by
      intro t ht1 ht2
      rcases le_dest ht1 with ⟨k, eqT⟩
      have kLt : k < M := Naturals.lt_of_add_lt_add_left (k := T) (eqT ▸ ht2)
      exact eqT ▸ allK k kLt
    have xEnd := belowAtEnd allT
    exact pacedCourse_ends_below_point_pub nothing short2 (fun u => (needsPos u).1) floorDraw c₀
      (PacedStock.pacedCourse fA need kids giving use h reads c₀ (T + M)).1.2.2 (T + M)
      (Nat.le_refl _) xEnd
  · exact ⟨T + k, noK⟩

/-- **Unconditional `δ = 1` impossibility (`sampled_deadline_impossibility_lag1`).**
For EVERY rule update `h` (even omniscient at `σ 1`), one post-sample step (`δ = 1`) still draws
under `w_L` built at `L - 1`, collapsing whenever `x₀ < (H_min + y₂) + (H_bad - Y) * (L + 1)`. -/
theorem sampled_deadline_impossibility_lag1 {A U R : Type}
    {fA : A → R → A} {need : U → Nat} {kids : R → U → List U}
    {giving : Nat → Nat} {use : U → Nat}
    {Y H_bad H_min y₂ L : Nat} {r_bad : R} {a₀ : A} {w₀ : List U} {x₀ : Nat}
    (nothing : RegimeMargin.FromNothing giving)
    (most : RegimeMargin.AtMost giving Y)
    (yLtH : Y < H_bad)
    (hLe : H_bad ≤ H_min + y₂)
    (short2 : RegimeMargin.Short giving H_min y₂)
    (needsPos : ∀ u, 0 < need u ∧ need u ≤ H_min + y₂)
    (lower : PacedStock.LowerDrawWhileMet H_bad need kids giving use r_bad w₀ x₀ (L + 1))
    (floorDraw : ∀ w, w ≠ [] → H_min ≤ LineOnAStock.taken use w)
    (underThreshold : x₀ < (H_min + y₂) + (H_bad - Y) * (L + 1)) :
    ∀ (σ : Nat → Nat) (reads : Nat → Bool) (h : PacedStock.StockState A U → R → R),
      σ 0 = 0 → σ 1 = L → Becoming.Strict σ → PacedStock.ReadAtSpanEnd σ reads →
      let c₀ : PacedStock.StockState A U × R := ((a₀, (w₀, x₀)), r_bad)
      ((∀ t, t < L + 1 →
          LineOnAStock.Goes need (PacedStock.pacedCourse fA need kids giving use h reads c₀ t).1.2) →
        (PacedStock.pacedCourse fA need kids giving use h reads c₀ (L + 1)).1.2.2 < H_min + y₂) ∧
      ∃ t, ¬ LineOnAStock.Goes need (PacedStock.pacedCourse fA need kids giving use h reads c₀ t).1.2 := by
  intro σ reads h σ0 σ1 strict cadence
  have hAt := sampled_deadline_impossibility_at (fA := fA) (c₀ := ((a₀, (w₀, x₀)), r_bad))
    (T := 0) (M := L + 1) nothing most yLtH hLe short2
    needsPos floorDraw
    (lagDraw_one_of_lower (fA := fA) (a₀ := a₀) σ σ0 σ1 strict reads cadence lower h)
    (by show x₀ < (H_min + y₂) + (H_bad - Y) * (L + 1); exact underThreshold)
  refine ⟨fun hG => ?_, hAt.2⟩
  rw [← Nat.zero_add (L + 1)]
  exact hAt.1 fun t _ ht => by rw [Nat.zero_add] at ht; exact hG t ht

/-- **Part C3a (`sampled_deadline_impossibility`).**
Bundles:
1. Span-0 collapse under explicit actuation-lag draw hypothesis `lagDraw` on `[0, L + δ)` (`σ 0 = 0`,
   `L = σ 1 - σ 0 = σ 1`);
2. Arbitrary-span generalization at `T = σ j` (`L_j = σ (j + 1) - σ j`) whenever the sampled stock
   at `σ j` falls below `(H_min + y₂) + (H_bad - Y) * (L_j + δ)` under `PacedLowerDrawWhileMet` on
   `[σ j, σ j + (L_j + δ))`;
3. Exact `ReadOffInTime` timing impossibility (`NoReturnAt`):
   - `N_ret ≤ L + δ → ¬ Recoverable feasible keeps l_bad (L + δ)`;
   - `N_ret ≤ σ 1 → ¬ Recoverable feasible keeps l_bad (σ 1)` AND (when alike up to `σ 1`)
     `¬ W.ReadableInTime group feasible keeps l_bad l_safe`. -/
theorem sampled_deadline_impossibility {A U R F C : Type}
    {fA : A → R → A} {need : U → Nat} {kids : R → U → List U}
    {giving : Nat → Nat} {use : U → Nat}
    {σ : Nat → Nat} (_strict : Becoming.Strict σ) (_σ0 : σ 0 = 0)
    {δ Y H_bad H_min y₂ : Nat}
    {r_bad : R} {a₀ : A} {w₀ : List U} {x₀ : Nat}
    (nothing : RegimeMargin.FromNothing giving)
    (most : RegimeMargin.AtMost giving Y)
    (yLtH : Y < H_bad)
    (hLe : H_bad ≤ H_min + y₂)
    (short2 : RegimeMargin.Short giving H_min y₂)
    (needsPos : ∀ u, 0 < need u ∧ need u ≤ H_min + y₂)
    (floorDraw : ∀ w, w ≠ [] → H_min ≤ LineOnAStock.taken use w)
    (underThreshold0 : x₀ < (H_min + y₂) + (H_bad - Y) * ((σ 1 - σ 0) + δ))
    {W : Web F C} {group : F → Prop} {feasible keeps : (Nat → C → Nat) → Prop}
    {l_bad l_safe : Nat → C → Nat} {N_ret : Nat}
    (noRet : NoReturnAt feasible keeps l_bad N_ret) :
    let L := σ 1 - σ 0
    let c₀ : PacedStock.StockState A U × R := ((a₀, (w₀, x₀)), r_bad)
    (∀ (reads : Nat → Bool) (h : PacedStock.StockState A U → R → R),
      PacedLowerDrawWhileMet H_bad fA need kids giving use h reads c₀ 0 (L + δ) →
      ((∀ t, t < L + δ →
          LineOnAStock.Goes need (PacedStock.pacedCourse fA need kids giving use h reads c₀ t).1.2) →
        (PacedStock.pacedCourse fA need kids giving use h reads c₀ (L + δ)).1.2.2 < H_min + y₂) ∧
      ∃ t, ¬ LineOnAStock.Goes need (PacedStock.pacedCourse fA need kids giving use h reads c₀ t).1.2) ∧
    (∀ (j : Nat) (reads : Nat → Bool) (h : PacedStock.StockState A U → R → R),
      let L_j := σ (j + 1) - σ j
      PacedLowerDrawWhileMet H_bad fA need kids giving use h reads c₀ (σ j) (L_j + δ) →
      (PacedStock.pacedCourse fA need kids giving use h reads c₀ (σ j)).1.2.2 <
        (H_min + y₂) + (H_bad - Y) * (L_j + δ) →
      ((∀ t, σ j ≤ t → t < σ j + (L_j + δ) →
          LineOnAStock.Goes need (PacedStock.pacedCourse fA need kids giving use h reads c₀ t).1.2) →
        (PacedStock.pacedCourse fA need kids giving use h reads c₀ (σ j + (L_j + δ))).1.2.2 < H_min + y₂) ∧
      ∃ t, ¬ LineOnAStock.Goes need (PacedStock.pacedCourse fA need kids giving use h reads c₀ t).1.2) ∧
    (N_ret ≤ L + δ → ¬ Recoverable feasible keeps l_bad (L + δ)) ∧
    (N_ret ≤ σ 1 → ¬ Recoverable feasible keeps l_bad (σ 1) ∧
      ((∀ g, group g → ∀ t, t ≤ σ 1 → (W.Admits (l_bad t) t g ↔ W.Admits (l_safe t) t g)) →
        ¬ W.ReadableInTime group feasible keeps l_bad l_safe ∧
        ∀ sel, (∀ s, W.SelectsThroughAll thresholdOnly group s (sel s)) →
          ¬ Web.ReadsInTime sel feasible keeps l_bad l_safe)) := by
  let L := σ 1 - σ 0
  let c₀ : PacedStock.StockState A U × R := ((a₀, (w₀, x₀)), r_bad)
  refine ⟨fun reads h lagDraw0 => ?_, fun j reads h lagDrawJ underJ => ?_, fun hN => ?_, fun hN => ?_⟩
  · have hAt0 := sampled_deadline_impossibility_at (c₀ := c₀) (T := 0) (M := L + δ) nothing most yLtH hLe
      short2 needsPos floorDraw lagDraw0 underThreshold0
    refine ⟨fun hG => ?_, hAt0.2⟩
    rw [← Nat.zero_add (L + δ)]
    exact hAt0.1 fun t _ ht => by rw [Nat.zero_add] at ht; exact hG t ht
  · exact sampled_deadline_impossibility_at (c₀ := c₀) (T := σ j) (M := (σ (j + 1) - σ j) + δ)
      nothing most yLtH hLe short2 needsPos floorDraw lagDrawJ underJ
  · intro hRec
    have hLt := noRet.recoverable_iff.mp hRec
    exact Nat.not_le_of_gt hLt hN
  · have hNotRec : ¬ Recoverable feasible keeps l_bad (σ 1) := fun hRec =>
      Nat.not_le_of_gt (noRet.recoverable_iff.mp hRec) hN
    exact ⟨hNotRec, fun hAlike => Web.too_late_of_alike hAlike hNotRec⟩

/-- **Corollary C3b (`unrecoverable_cadence_bridge`).**
Composes `PacedStock.unrecoverable_cadence_impossibility` (`LassoStep` state-aliasing lower bound
`2 * N - 1 ≤ L`) with `NoReturnAt.recoverable_iff` and `too_late_of_alike` recovery failure. -/
theorem unrecoverable_cadence_bridge {A U R O F C : Type}
    {fA : A → R → A} {need : U → Nat} {kids : R → U → List U}
    {giving : Nat → Nat} {use : U → Nat}
    {N Y H_bad H_min y₂ : Nat} {x_o y_o : O}
    (nGe2 : 2 ≤ N) (two : x_o ≠ y_o)
    (nothing : RegimeMargin.FromNothing giving)
    (most : RegimeMargin.AtMost giving Y)
    (yLtH : Y < H_bad)
    (hLe : H_bad ≤ H_min + y₂)
    (short2 : RegimeMargin.Short giving H_min y₂)
    (needsPos : ∀ u, 0 < need u ∧ need u ≤ H_min + y₂)
    {r_bad : R} {w₀ : List U} {x₀ : Nat}
    (lower : PacedStock.LowerDrawWhileMet H_bad need kids giving use r_bad w₀ x₀ (2 * N - 1))
    (floorDraw : ∀ w, w ≠ [] → H_min ≤ LineOnAStock.taken use w)
    (underThreshold : x₀ < (H_min + y₂) + (H_bad - Y) * (2 * N - 1)) :
    (∀ L, L < 2 * N - 1 → ¬ Pace.StretchFixes O N L) ∧
    (∀ (L : Nat) (σ : Nat → Nat) (reads : Nat → Bool)
        (h : PacedStock.StockState A U → R → R) (a₀ : A),
      2 * N - 1 ≤ L → σ 0 = 0 → σ 1 = L →
      Becoming.Strict σ → PacedStock.ReadAtSpanEnd σ reads →
      let c₀ : PacedStock.StockState A U × R := ((a₀, (w₀, x₀)), r_bad)
      ((∀ t, t < L →
          LineOnAStock.Goes need (PacedStock.pacedCourse fA need kids giving use h reads c₀ t).1.2) →
        (PacedStock.pacedCourse fA need kids giving use h reads c₀ L).1.2.2 < H_min + y₂) ∧
      ∃ t, ¬ LineOnAStock.Goes need (PacedStock.pacedCourse fA need kids giving use h reads c₀ t).1.2) ∧
    (∀ (L δ N_ret : Nat) {feasible keeps : (Nat → C → Nat) → Prop} {l_bad : Nat → C → Nat}
        {W : Web F C} {group : F → Prop} {l_safe : Nat → C → Nat},
      NoReturnAt feasible keeps l_bad N_ret →
      N_ret ≤ L + δ →
      ¬ Recoverable feasible keeps l_bad (L + δ) ∧
      (N_ret ≤ L →
        (∀ g, group g → ∀ t, t ≤ L → (W.Admits (l_bad t) t g ↔ W.Admits (l_safe t) t g)) →
        ¬ W.ReadableInTime group feasible keeps l_bad l_safe)) := by
  have hUnrec := PacedStock.unrecoverable_cadence_impossibility (A := A) (fA := fA) nGe2 two
    nothing most yLtH hLe short2 needsPos lower floorDraw underThreshold
  refine ⟨fun L hL => (hUnrec.1 L hL).1, hUnrec.2, fun L δ N_ret {_ _ _ _ _ _} noRet hN => ?_⟩
  have hNotRec : ¬ Recoverable _ _ _ (L + δ) := fun hRec =>
    Nat.not_le_of_gt (noRet.recoverable_iff.mp hRec) hN
  refine ⟨hNotRec, fun hNL hAlike => ?_⟩
  have hNotRecL : ¬ Recoverable _ _ _ L := fun hRec =>
    Nat.not_le_of_gt (noRet.recoverable_iff.mp hRec) hNL
  exact (Web.too_late_of_alike hAlike hNotRecL).1

/-! ## 3. Non-Implications (`ReadsOnlyDynamics.not_entails`) and `L5` Spine Hooks -/

/-- Any dynamical statement in `UnifiedDrawdown` that reads only dynamics (ignoring significance
`sig : Pos → Nat → F → Prop`) satisfies `ReadsOnlyDynamics`. -/
theorem unifiedDrawdown_readsOnlyDynamics {D : Type} {Pos F : Type} (law : D → Prop) :
    ReadsOnlyDynamics (Pos := Pos) (F := F) (fun d _ => law d) :=
  readsOnlyDynamics_of law

/-- By `ReadsOnlyDynamics.not_entails`, no dynamics-only statement entails
`Unrestricted sig` on any inhabited dynamics. -/
theorem unifiedDrawdown_not_entails {D Pos F : Type} (law : D → Prop)
    (entails : ∀ d (sig : Pos → Nat → F → Prop), law d → Unrestricted sig)
    (p : Pos) (f : F) (d : D) : ¬ law d :=
  dynamicsLaw_not_entails (fun d h sig => entails d sig h) p f

/-- Applied to our three verified witness classes (`HeldPair`, `OverdrawSeparationWitness`,
`CadenceErasureWitness`), `ReadsOnlyDynamics.not_entails` proves no proof of `Unrestricted sig`
can be extracted from the dynamics alone. -/
theorem witnessed_dynamics_not_entails {Pos : Type} (p : Pos) :
    (¬ ∀ (_u : Unit) (sig : Pos → Nat → Optimum.HeldPair.Member → Prop),
      (∀ t, t < 2 → Optimum.HeldPair.flow.WithinOwn t .pool ∧ ¬ Optimum.HeldPair.flow.WithinJoint t .pool) →
      Unrestricted sig) ∧
    (¬ ∀ (_u : Unit) (sig : Pos → Nat → Unit → Prop),
      (¬ (StockFlowBridge.lineFlow OverdrawSeparationWitness.need OverdrawSeparationWitness.kids
            OverdrawSeparationWitness.giving OverdrawSeparationWitness.use
            OverdrawSeparationWitness.startState).Balances
          (StockFlowBridge.lineWeb OverdrawSeparationWitness.need OverdrawSeparationWitness.kids
            OverdrawSeparationWitness.giving OverdrawSeparationWitness.use
            OverdrawSeparationWitness.startState)) →
      Unrestricted sig) ∧
    (¬ ∀ (_u : Unit) (sig : Pos → Nat → Unit → Prop),
      (¬ LineOnAStock.Goes CadenceErasureWitness.need
          (PacedStock.pacedCourse CadenceErasureWitness.fA CadenceErasureWitness.need
            CadenceErasureWitness.kids CadenceErasureWitness.giving CadenceErasureWitness.use
            CadenceErasureWitness.h CadenceErasureWitness.readsCoarse
            CadenceErasureWitness.startConfig 6).1.2) →
      Unrestricted sig) :=
  ⟨fun hEnt => unifiedDrawdown_not_entails
      (fun (_ : Unit) => ∀ t, t < 2 →
        Optimum.HeldPair.flow.WithinOwn t .pool ∧ ¬ Optimum.HeldPair.flow.WithinJoint t .pool)
      hEnt p .renewer () Optimum.HeldPair.within,
   fun hEnt => unifiedDrawdown_not_entails
      (fun (_ : Unit) =>
        ¬ (StockFlowBridge.lineFlow OverdrawSeparationWitness.need OverdrawSeparationWitness.kids
              OverdrawSeparationWitness.giving OverdrawSeparationWitness.use
              OverdrawSeparationWitness.startState).Balances
            (StockFlowBridge.lineWeb OverdrawSeparationWitness.need OverdrawSeparationWitness.kids
              OverdrawSeparationWitness.giving OverdrawSeparationWitness.use
              OverdrawSeparationWitness.startState))
      hEnt p () () OverdrawSeparationWitness.witness_bundle.2.2.1,
   fun hEnt => unifiedDrawdown_not_entails
      (fun (_ : Unit) =>
        ¬ LineOnAStock.Goes CadenceErasureWitness.need
            (PacedStock.pacedCourse CadenceErasureWitness.fA CadenceErasureWitness.need
              CadenceErasureWitness.kids CadenceErasureWitness.giving CadenceErasureWitness.use
              CadenceErasureWitness.h CadenceErasureWitness.readsCoarse
              CadenceErasureWitness.startConfig 6).1.2)
      hEnt p () () CadenceErasureWitness.witness_bundle.2.2.2.2⟩

/- Compositional export packages for Pillar L5 (`Becoming.AlignmentSpine`). -/
namespace SpineHooks

/-- Hook 1 (`L1` + `L2` → `L5`): parametric joint depletion summary bundle over `agents`. -/
structure JointDepletionBridge (α F C : Type) (L : Flow F C) (W : Web F C)
    (obs : F → C → Prop) (agents : List α) (toF : α → F) (fam : α → List C)
    (cSub : C) (lose : α → Nat)
    (model : (i : α) → FreeEnergyGuarantees.RiskAndNeeds.Chooser Nat)
    (n k m d : Nat) (g : F) : Prop where
  local_zero : ∀ t, t < n → ∀ i, i ∈ agents →
    W.stock (fam i) (t + 1) = W.stock (fam i) t + L.take t (toF i) cSub - lose i ∧
    L.take t (toF i) cSub = lose i ∧
    localError (model i) (fun u => W.stock (fam i) u) (fun u => L.take u (toF i) cSub) t = 0 ∧
    (model i).risk (W.stock (fam i) t) (L.take t (toF i) cSub) = 0
  own_not_joint : ∀ t, t < n → L.WithinOwn t cSub ∧ ¬ L.WithinJoint t cSub
  uncoupled : ∀ i, i ∈ agents → ¬ W.CoupledInto obs (toF i) cSub
  level_below : W.level n cSub < m
  monotone_drain : ∀ t₁ t₂, t₁ ≤ t₂ → t₂ ≤ n →
    W.level t₂ cSub + (t₂ - t₁) * d ≤ W.level t₁ cSub
  collapsed : ¬ W.active (n + k) g

/-- Hook 2 (`L2` Part B → `L5`): localized pre-overdraw & counter-model sharpness package. -/
structure PreOverdrawBridge : Prop where
  witness_step0_balanced :
    (StockFlowBridge.lineFlow OverdrawSeparationWitness.need OverdrawSeparationWitness.kids
      OverdrawSeparationWitness.giving OverdrawSeparationWitness.use
      OverdrawSeparationWitness.startState).BalancesOn
      (StockFlowBridge.lineWeb OverdrawSeparationWitness.need OverdrawSeparationWitness.kids
        OverdrawSeparationWitness.giving OverdrawSeparationWitness.use
        OverdrawSeparationWitness.startState) [()] 0
  witness_step1_unbalanced :
    ¬ (StockFlowBridge.lineFlow OverdrawSeparationWitness.need OverdrawSeparationWitness.kids
        OverdrawSeparationWitness.giving OverdrawSeparationWitness.use
        OverdrawSeparationWitness.startState).BalancesOn
      (StockFlowBridge.lineWeb OverdrawSeparationWitness.need OverdrawSeparationWitness.kids
        OverdrawSeparationWitness.giving OverdrawSeparationWitness.use
        OverdrawSeparationWitness.startState) [()] 1
  witness_no_global_balances :
    ¬ (StockFlowBridge.lineFlow OverdrawSeparationWitness.need OverdrawSeparationWitness.kids
        OverdrawSeparationWitness.giving OverdrawSeparationWitness.use
        OverdrawSeparationWitness.startState).Balances
      (StockFlowBridge.lineWeb OverdrawSeparationWitness.need OverdrawSeparationWitness.kids
        OverdrawSeparationWitness.giving OverdrawSeparationWitness.use
        OverdrawSeparationWitness.startState)
  witness_stops :
    ¬ LineOnAStock.Goes OverdrawSeparationWitness.need
      (LineOnAStock.course OverdrawSeparationWitness.need OverdrawSeparationWitness.kids
        OverdrawSeparationWitness.giving OverdrawSeparationWitness.use
        OverdrawSeparationWitness.startState 2)

/-- Hook 3 (`L2` Part C → `L5`): temporal-aliasing, strobe erasure, and deadline sharpness suite. -/
structure TemporalAliasingSuite : Prop where
  cadence_fine_viable :
    ∀ t, LineOnAStock.Goes CadenceErasureWitness.need
      (PacedStock.pacedCourse CadenceErasureWitness.fA CadenceErasureWitness.need
        CadenceErasureWitness.kids CadenceErasureWitness.giving CadenceErasureWitness.use
        CadenceErasureWitness.h CadenceErasureWitness.readsFine
        CadenceErasureWitness.startConfig t).1.2
  cadence_coarse_collapses :
    ¬ LineOnAStock.Goes CadenceErasureWitness.need
      (PacedStock.pacedCourse CadenceErasureWitness.fA CadenceErasureWitness.need
        CadenceErasureWitness.kids CadenceErasureWitness.giving CadenceErasureWitness.use
        CadenceErasureWitness.h CadenceErasureWitness.readsCoarse
        CadenceErasureWitness.startConfig 6).1.2
  strobe_span_end :
    PacedStock.ReadAtSpanEnd sigmaOdd CadenceErasureWitness.readsCoarse

theorem preOverdrawSummary : PreOverdrawBridge :=
  ⟨OverdrawSeparationWitness.witness_bundle.1,
   OverdrawSeparationWitness.witness_bundle.2.1,
   OverdrawSeparationWitness.witness_bundle.2.2.1,
   OverdrawSeparationWitness.witness_bundle.2.2.2.2⟩

theorem temporalAliasingSummary : TemporalAliasingSuite :=
  ⟨CadenceErasureWitness.witness_bundle.2.2.1,
   CadenceErasureWitness.witness_bundle.2.2.2.2,
   CadenceErasureWitness.witness_bundle.2.1⟩

end SpineHooks

/- Native `L0` (`Becoming.OpenComposition`) compositional bridges for finite-lag restraint fleets. -/
namespace OpenCompositionBridge

/-- Lift a single `RestraintAgentSpec` loop into an `OpenComposition.OpenComponent` with `Empty`
private substrate ports and scalar external substrate port `Unit`. -/
def restraintComponent (spec : RestraintAgentSpec) (warnLevel : Nat) :
    OpenComposition.OpenComponent Nat Nat Unit Empty Unit :=
  OpenComposition.OpenComponent.ofOpenLoop (restraintLoop spec warnLevel)

/-- Lift the `restraintCert` into an `OpenComposition.InterfaceContract` for `restraintComponent`. -/
def restraintContract (spec : RestraintAgentSpec) (warnLevel : Nat) :
    OpenComposition.InterfaceContract (restraintComponent spec warnLevel) spec.lag :=
  OpenComposition.InterfaceContract.ofLoopCertificate (restraintCert spec warnLevel)

/-- Indexed component-state carrier for the right-associated fleet fold over a non-empty list
`(head :: tail : List RestraintAgentSpec)`. -/
abbrev FleetState : List RestraintAgentSpec → Type := OpenComposition.ListCarrier Nat

/-- Indexed observation carrier for the right-associated fleet fold. -/
abbrev FleetObs : List RestraintAgentSpec → Type := OpenComposition.ListCarrier Nat

/-- Indexed disturbance carrier for the right-associated fleet fold. -/
abbrev FleetDist : List RestraintAgentSpec → Type := OpenComposition.ListCarrier Unit

/-- Indexed private-port carrier for the right-associated fleet fold. -/
abbrev FleetInt : List RestraintAgentSpec → Type := OpenComposition.ListIntCarrier Empty

/-- Initial internal lag-counter tuple `(head.lag, ...)` across the non-empty fleet. -/
abbrev fleetInit (head : RestraintAgentSpec) (tail : List RestraintAgentSpec) : FleetState tail :=
  OpenComposition.composeListInit (fun s => s.lag) head tail

/-- Broadcast scalar observation channel `(x (), ...)` across the non-empty fleet. -/
abbrev fleetObs (tail : List RestraintAgentSpec) (x : Unit → Nat) : FleetObs tail :=
  OpenComposition.composeListObs (fun x => x ()) tail x

/-- Inductive right-associated `OpenComponent` fold over a non-empty agent list via
`OpenComposition.OpenComponent.compose`. -/
abbrev fleetComponent (head : RestraintAgentSpec) (tail : List RestraintAgentSpec) (warnLevel : Nat) :
    OpenComposition.OpenComponent (FleetState tail) (FleetObs tail) (FleetDist tail) (FleetInt tail) Unit :=
  OpenComposition.composeListComponent (fun s => restraintComponent s warnLevel) head tail

/-- Inductive right-associated `InterfaceContract` fold over a non-empty agent list via
`OpenComposition.composeContract`. -/
abbrev fleetContract (head : RestraintAgentSpec) (tail : List RestraintAgentSpec) (warnLevel : Nat) :
    OpenComposition.InterfaceContract (fleetComponent head tail warnLevel) (fleetInit head tail) :=
  OpenComposition.composeListContract (fun s => restraintContract s warnLevel) head tail

/-- Recursive sum of a scalar projection over a non-empty list `(head :: tail)`. -/
abbrev specSum (proj : RestraintAgentSpec → Nat) (head : RestraintAgentSpec) :
    List RestraintAgentSpec → Nat :=
  OpenComposition.listSum proj head

/-- Recursive maximum of a scalar projection over a non-empty list `(head :: tail)`. -/
abbrev specMax (proj : RestraintAgentSpec → Nat) (head : RestraintAgentSpec) :
    List RestraintAgentSpec → Nat :=
  OpenComposition.listMax proj head

theorem fleet_preCapExt_eq_sum :
    ∀ (tail : List RestraintAgentSpec) (head : RestraintAgentSpec) (warnLevel : Nat),
      (fleetContract head tail warnLevel).preCapExt () = specSum (fun s => s.preCap) head tail
  | tail, head, warnLevel =>
    OpenComposition.composeList_preCapExt_eq_sum (fun s => restraintContract s warnLevel) () tail head

theorem fleet_postCapExt_eq_sum :
    ∀ (tail : List RestraintAgentSpec) (head : RestraintAgentSpec) (warnLevel : Nat),
      (fleetContract head tail warnLevel).postBudgetExt () = specSum (fun s => s.postCap) head tail
  | tail, head, warnLevel =>
    OpenComposition.composeList_postBudgetExt_eq_sum (fun s => restraintContract s warnLevel) () tail head

theorem fleet_maxSilence_eq_sum :
    ∀ (tail : List RestraintAgentSpec) (head : RestraintAgentSpec) (warnLevel : Nat),
      (fleetContract head tail warnLevel).maxSilence = specSum (fun s => s.maxSilence) head tail
  | tail, head, warnLevel =>
    OpenComposition.composeList_maxSilence_eq_sum (fun s => restraintContract s warnLevel) tail head

theorem fleet_maxLag_eq_max :
    ∀ (tail : List RestraintAgentSpec) (head : RestraintAgentSpec) (warnLevel : Nat),
      (fleetContract head tail warnLevel).maxLag = specMax (fun s => s.lag) head tail
  | tail, head, warnLevel =>
    OpenComposition.composeList_maxLag_eq_max (fun s => restraintContract s warnLevel) tail head

theorem fleet_eta_eq_max :
    ∀ (tail : List RestraintAgentSpec) (head : RestraintAgentSpec) (warnLevel : Nat),
      (fleetContract head tail warnLevel).eta (fleetInit head tail) = specMax (fun s => s.lag) head tail
  | tail, head, warnLevel =>
    OpenComposition.composeList_eta_eq_max (fun s => restraintContract s warnLevel) tail head

theorem fleet_warnObs_of_lt {head : RestraintAgentSpec} :
    ∀ (tail : List RestraintAgentSpec) {warnLevel : Nat} {x : Unit → Nat},
      x () < warnLevel →
      (fleetContract head tail warnLevel).warnObs (fleetObs tail x)
  | tail, _, _, lt =>
    OpenComposition.composeList_warnObs_of_head (fun s => restraintContract s _) tail lt

/-- **Global closed-loop viability for any non-empty `RestraintAgentSpec` fleet via
`OpenComposition.close_contract_kernel`.** Certifies `Viability.Kernel` on the inductively glued
`fleetComponent` and guarantees `x_crit ≤ (r.state t).1 ()` on every admissible run. -/
theorem fleet_restraint_open_viable {Env : Type}
    (head : RestraintAgentSpec) (tail : List RestraintAgentSpec)
    (channel : Bool → Nat → Env → Bool)
    (G : Unit → (Unit → Nat) → Nat)
    (envDraw : Env → Unit → Nat) (envCap : Unit → Nat) (jointAdm : Env → Prop)
    (env_within : ∀ env, jointAdm env → ∀ k, envDraw env k ≤ envCap k)
    (x_crit warnLevel H_safe x₀ : Nat)
    (channel_fires : ∀ load env, jointAdm env →
      load ≤ specSum (fun s => s.maxSilence) head tail →
      channel true load env = true)
    (G_rises : RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (G ()))
    (post_viable : x_crit ≤
      RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole G (fun _ => H_safe)
        (fun _ => x_crit) ())
    (post_cap : specSum (fun s => s.postCap) head tail + envCap () ≤ H_safe)
    (warn_margin : x_crit +
      (specMax (fun s => s.lag) head tail + 1) *
        (specSum (fun s => s.preCap) head tail + envCap ()) ≤ warnLevel)
    (init_margin : x_crit +
      specMax (fun s => s.lag) head tail *
        (specSum (fun s => s.preCap) head tail + envCap ()) ≤ x₀) :
    Viability.Kernel
      (OpenComposition.closedProcess (fleetComponent head tail warnLevel)
        (fleetContract head tail warnLevel) (fleetObs tail) channel G envDraw jointAdm)
      (OpenComposition.closedGuard (fleetComponent head tail warnLevel)
        (fleetContract head tail warnLevel) (fun _ => x_crit))
      ((fun _ => x₀), fleetInit head tail) ∧
    ∀ (r : Run
        (OpenComposition.closedProcess (fleetComponent head tail warnLevel)
          (fleetContract head tail warnLevel) (fleetObs tail) channel G envDraw jointAdm)),
      r.state 0 = ((fun _ => x₀), fleetInit head tail) →
      ∀ t, x_crit ≤ (r.state t).1 () := by
  have hKern : Viability.Kernel
      (OpenComposition.closedProcess (fleetComponent head tail warnLevel)
        (fleetContract head tail warnLevel) (fleetObs tail) channel G envDraw jointAdm)
      (OpenComposition.closedGuard (fleetComponent head tail warnLevel)
        (fleetContract head tail warnLevel) (fun _ => x_crit))
      ((fun _ => x₀), fleetInit head tail) :=
    OpenComposition.composeList_viable
      (fun s => restraintComponent s warnLevel) (fun s => s.lag) (fun s => restraintContract s warnLevel)
      head tail (fun x => x ()) channel G envDraw envCap jointAdm env_within
      (fun _ => x_crit) (fun _ => warnLevel) (fun _ => H_safe) (fun _ => x₀)
      (fun _ _ lt => lt) channel_fires
      (fun k => by cases k; exact G_rises) (fun k => by cases k; exact post_viable)
      (fun _ => post_cap) (fun _ => warn_margin) (fun _ => init_margin)
  exact ⟨hKern, fun r hStart t => (Viability.Kernel.run r (hStart ▸ hKern) t).1 ()⟩

/-- Componentwise contract tightening order on `RestraintAgentSpec`. -/
structure SpecTightens (spec spec' : RestraintAgentSpec) : Prop where
  preCap_le : spec'.preCap ≤ spec.preCap
  postCap_le : spec'.postCap ≤ spec.postCap
  maxSilence_le : spec'.maxSilence ≤ spec.maxSilence
  lag_le : spec'.lag ≤ spec.lag

/-- Any `SpecTightens spec spec'` yields `OpenComposition.ContractRefines` between their
`restraintContract` interfaces. -/
theorem restraintContract_refines {spec spec' : RestraintAgentSpec} {warnLevel : Nat}
    (tight : SpecTightens spec spec') :
    OpenComposition.ContractRefines
      (restraintContract spec warnLevel)
      (restraintContract spec' warnLevel)
      (fun x => x ()) (fun x => x ()) (fun _ => warnLevel) where
  preCapExt_le _ := tight.preCap_le
  postBudgetExt_le _ := tight.postCap_le
  maxSilence_le := tight.maxSilence_le
  maxLag_le := tight.lag_le
  init_eta_le := tight.lag_le
  warn_preserved _ hWarn _ := hWarn

/-- **Single-member fleet upgrade (`fleet_upgrade_head_viable`).** Swapping the head member `head`
for any tightened `head'` (`SpecTightens head head'`) inside `(restraintComponent head warnLevel).compose
(fleetComponent head2 tail warnLevel)` preserves global `Viability.Kernel` via
`OpenComposition.replace_left_viable` without re-checking the tail fleet. -/
theorem fleet_upgrade_head_viable {Env : Type}
    (head head' head2 : RestraintAgentSpec) (tail : List RestraintAgentSpec)
    (tight : SpecTightens head head')
    (channel : Bool → Nat → Env → Bool)
    (G : Unit → (Unit → Nat) → Nat)
    (envDraw : Env → Unit → Nat) (envCap : Unit → Nat) (jointAdm : Env → Prop)
    (env_within : ∀ env, jointAdm env → ∀ k, envDraw env k ≤ envCap k)
    (x_crit warnLevel H_safe x₀ : Nat)
    (channel_fires : ∀ load env, jointAdm env →
      load ≤ specSum (fun s => s.maxSilence) head (head2 :: tail) →
      channel true load env = true)
    (G_rises : RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (G ()))
    (post_viable : x_crit ≤
      RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole G (fun _ => H_safe)
        (fun _ => x_crit) ())
    (post_cap : specSum (fun s => s.postCap) head (head2 :: tail) + envCap () ≤ H_safe)
    (warn_margin : x_crit +
      (specMax (fun s => s.lag) head (head2 :: tail) + 1) *
        (specSum (fun s => s.preCap) head (head2 :: tail) + envCap ()) ≤ warnLevel)
    (init_margin : x_crit +
      specMax (fun s => s.lag) head (head2 :: tail) *
        (specSum (fun s => s.preCap) head (head2 :: tail) + envCap ()) ≤ x₀) :
    Viability.Kernel
      (OpenComposition.closedProcess
        ((restraintComponent head' warnLevel).compose (fleetComponent head2 tail warnLevel))
        (OpenComposition.composeContract
          (restraintContract head' warnLevel) (fleetContract head2 tail warnLevel))
        (fun x => (x (), fleetObs tail x)) channel G envDraw jointAdm)
      (OpenComposition.closedGuard
        ((restraintComponent head' warnLevel).compose (fleetComponent head2 tail warnLevel))
        (OpenComposition.composeContract
          (restraintContract head' warnLevel) (fleetContract head2 tail warnLevel))
        (fun _ => x_crit))
      ((fun _ => x₀), (head'.lag, fleetInit head2 tail)) :=
  OpenComposition.composeList_replace_head_viable
    (fun s => restraintComponent s warnLevel) (fun s => s.lag) (fun s => restraintContract s warnLevel)
    head head' (head2 :: tail) (fun x => x ()) channel G envDraw envCap jointAdm env_within
    (fun _ => x_crit) (fun _ => warnLevel) (fun _ => H_safe) (fun _ => x₀)
    (restraintContract_refines tight) (fun _ _ lt => lt) channel_fires
    (fun k => by cases k; exact G_rises) (fun k => by cases k; exact post_viable)
    (fun _ => post_cap) (fun _ => warn_margin) (fun _ => init_margin)

/- Concrete verified 2-agent / 3-agent / head-upgraded fleet witness on `fleetG`. -/
namespace FleetWitness

def fleetG (_ : Unit) (e : Unit → Nat) : Nat :=
  match Nat.blt 0 (e ()) with
  | true => 3
  | false => 0

theorem fleetG_rises :
    RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (fleetG ()) := by
  intro e e' below
  dsimp only [fleetG]
  cases h1 : Nat.blt 0 (e ()) with
  | false => exact Nat.zero_le _
  | true =>
    have hPos : 0 < e () := CoreHelpers.natBlt_true_iff.mp h1
    have hPos' : 0 < e' () := Nat.lt_of_lt_of_le hPos (below ())
    cases h2 : Nat.blt 0 (e' ()) with
    | true => exact Nat.le_refl 3
    | false => exact absurd hPos' (Nat.not_lt_of_le (CoreHelpers.natBlt_false_iff.mp h2))

def agentA : RestraintAgentSpec := ⟨2, 1, 2, 0, Nat.le_succ 1⟩
def agentA' : RestraintAgentSpec := ⟨1, 0, 1, 0, Nat.zero_le 1⟩
def agentB : RestraintAgentSpec := ⟨2, 1, 1, 0, Nat.le_succ 1⟩
def agentC : RestraintAgentSpec := ⟨1, 1, 1, 0, Nat.le_refl 1⟩

theorem tightenA : SpecTightens agentA agentA' :=
  ⟨Nat.le_succ 1, Nat.zero_le 1, Nat.le_refl 0, Nat.le_succ 1⟩

theorem twoAgentFleet_viable :
    Viability.Kernel
      (OpenComposition.closedProcess (fleetComponent agentB [agentC] 10)
        (fleetContract agentB [agentC] 10) (fleetObs [agentC])
        (fun em _ _ => em) fleetG (fun _ _ => 0) (fun (_ : Unit) => True))
      (OpenComposition.closedGuard (fleetComponent agentB [agentC] 10)
        (fleetContract agentB [agentC] 10) (fun _ => 4))
      ((fun _ => 7), fleetInit agentB [agentC]) :=
  (fleet_restraint_open_viable agentB [agentC]
    (fun em _ _ => em) fleetG (fun _ _ => 0) (fun _ => 0) (fun (_ : Unit) => True)
    (fun _ _ _ => Nat.zero_le 0) 4 10 3 7
    (fun _ _ _ _ => rfl)
    fleetG_rises
    (Nat.le_refl 4)
    (Nat.le_succ 2)
    (Nat.le_refl 10)
    (Nat.le_refl 7)).1

theorem threeAgentFleet_viable :
    Viability.Kernel
      (OpenComposition.closedProcess (fleetComponent agentA [agentB, agentC] 19)
        (fleetContract agentA [agentB, agentC] 19) (fleetObs [agentB, agentC])
        (fun em _ _ => em) fleetG (fun _ _ => 0) (fun (_ : Unit) => True))
      (OpenComposition.closedGuard (fleetComponent agentA [agentB, agentC] 19)
        (fleetContract agentA [agentB, agentC] 19) (fun _ => 4))
      ((fun _ => 14), fleetInit agentA [agentB, agentC]) :=
  (fleet_restraint_open_viable agentA [agentB, agentC]
    (fun em _ _ => em) fleetG (fun _ _ => 0) (fun _ => 0) (fun (_ : Unit) => True)
    (fun _ _ _ => Nat.zero_le 0) 4 19 3 14
    (fun _ _ _ _ => rfl)
    fleetG_rises
    (Nat.le_refl 4)
    (Nat.le_refl 3)
    (Nat.le_refl 19)
    (Nat.le_refl 14)).1

theorem threeAgentFleet_upgrade_viable :
    Viability.Kernel
      (OpenComposition.closedProcess
        ((restraintComponent agentA' 19).compose (fleetComponent agentB [agentC] 19))
        (OpenComposition.composeContract
          (restraintContract agentA' 19) (fleetContract agentB [agentC] 19))
        (fun x => (x (), fleetObs [agentC] x))
        (fun em _ _ => em) fleetG (fun _ _ => 0) (fun (_ : Unit) => True))
      (OpenComposition.closedGuard
        ((restraintComponent agentA' 19).compose (fleetComponent agentB [agentC] 19))
        (OpenComposition.composeContract
          (restraintContract agentA' 19) (fleetContract agentB [agentC] 19))
        (fun _ => 4))
      ((fun _ => 14), (agentA'.lag, fleetInit agentB [agentC])) :=
  fleet_upgrade_head_viable agentA agentA' agentB [agentC] tightenA
    (fun em _ _ => em) fleetG (fun _ _ => 0) (fun _ => 0) (fun (_ : Unit) => True)
    (fun _ _ _ => Nat.zero_le 0) 4 19 3 14
    (fun _ _ _ _ => rfl)
    fleetG_rises
    (Nat.le_refl 4)
    (Nat.le_refl 3)
    (Nat.le_refl 19)
    (Nat.le_refl 14)

theorem witness_bundle :
    Viability.Kernel
      (OpenComposition.closedProcess (fleetComponent agentB [agentC] 10)
        (fleetContract agentB [agentC] 10) (fleetObs [agentC])
        (fun em _ _ => em) fleetG (fun _ _ => 0) (fun (_ : Unit) => True))
      (OpenComposition.closedGuard (fleetComponent agentB [agentC] 10)
        (fleetContract agentB [agentC] 10) (fun _ => 4))
      ((fun _ => 7), fleetInit agentB [agentC]) ∧
    Viability.Kernel
      (OpenComposition.closedProcess (fleetComponent agentA [agentB, agentC] 19)
        (fleetContract agentA [agentB, agentC] 19) (fleetObs [agentB, agentC])
        (fun em _ _ => em) fleetG (fun _ _ => 0) (fun (_ : Unit) => True))
      (OpenComposition.closedGuard (fleetComponent agentA [agentB, agentC] 19)
        (fleetContract agentA [agentB, agentC] 19) (fun _ => 4))
      ((fun _ => 14), fleetInit agentA [agentB, agentC]) ∧
    Viability.Kernel
      (OpenComposition.closedProcess
        ((restraintComponent agentA' 19).compose (fleetComponent agentB [agentC] 19))
        (OpenComposition.composeContract
          (restraintContract agentA' 19) (fleetContract agentB [agentC] 19))
        (fun x => (x (), fleetObs [agentC] x))
        (fun em _ _ => em) fleetG (fun _ _ => 0) (fun (_ : Unit) => True))
      (OpenComposition.closedGuard
        ((restraintComponent agentA' 19).compose (fleetComponent agentB [agentC] 19))
        (OpenComposition.composeContract
          (restraintContract agentA' 19) (fleetContract agentB [agentC] 19))
        (fun _ => 4))
      ((fun _ => 14), (agentA'.lag, fleetInit agentB [agentC])) :=
  ⟨twoAgentFleet_viable, threeAgentFleet_viable, threeAgentFleet_upgrade_viable⟩

end FleetWitness

end OpenCompositionBridge

namespace SpineHooks

/-- Hook 4 (`L0` + `L2` → `L5`): verified 2-agent, 3-agent, and single-member upgraded open
composition fleet kernels from `OpenCompositionBridge`. -/
theorem openFleetSummary :
    Viability.Kernel
      (OpenComposition.closedProcess
        (OpenCompositionBridge.fleetComponent OpenCompositionBridge.FleetWitness.agentB
          [OpenCompositionBridge.FleetWitness.agentC] 10)
        (OpenCompositionBridge.fleetContract OpenCompositionBridge.FleetWitness.agentB
          [OpenCompositionBridge.FleetWitness.agentC] 10)
        (OpenCompositionBridge.fleetObs [OpenCompositionBridge.FleetWitness.agentC])
        (fun em _ _ => em) OpenCompositionBridge.FleetWitness.fleetG
        (fun _ _ => 0) (fun (_ : Unit) => True))
      (OpenComposition.closedGuard
        (OpenCompositionBridge.fleetComponent OpenCompositionBridge.FleetWitness.agentB
          [OpenCompositionBridge.FleetWitness.agentC] 10)
        (OpenCompositionBridge.fleetContract OpenCompositionBridge.FleetWitness.agentB
          [OpenCompositionBridge.FleetWitness.agentC] 10)
        (fun _ => 4))
      ((fun _ => 7),
        OpenCompositionBridge.fleetInit OpenCompositionBridge.FleetWitness.agentB
          [OpenCompositionBridge.FleetWitness.agentC]) ∧
    Viability.Kernel
      (OpenComposition.closedProcess
        ((OpenCompositionBridge.restraintComponent OpenCompositionBridge.FleetWitness.agentA' 19).compose
          (OpenCompositionBridge.fleetComponent OpenCompositionBridge.FleetWitness.agentB
            [OpenCompositionBridge.FleetWitness.agentC] 19))
        (OpenComposition.composeContract
          (OpenCompositionBridge.restraintContract OpenCompositionBridge.FleetWitness.agentA' 19)
          (OpenCompositionBridge.fleetContract OpenCompositionBridge.FleetWitness.agentB
            [OpenCompositionBridge.FleetWitness.agentC] 19))
        (fun x => (x (), OpenCompositionBridge.fleetObs [OpenCompositionBridge.FleetWitness.agentC] x))
        (fun em _ _ => em) OpenCompositionBridge.FleetWitness.fleetG
        (fun _ _ => 0) (fun (_ : Unit) => True))
      (OpenComposition.closedGuard
        ((OpenCompositionBridge.restraintComponent OpenCompositionBridge.FleetWitness.agentA' 19).compose
          (OpenCompositionBridge.fleetComponent OpenCompositionBridge.FleetWitness.agentB
            [OpenCompositionBridge.FleetWitness.agentC] 19))
        (OpenComposition.composeContract
          (OpenCompositionBridge.restraintContract OpenCompositionBridge.FleetWitness.agentA' 19)
          (OpenCompositionBridge.fleetContract OpenCompositionBridge.FleetWitness.agentB
            [OpenCompositionBridge.FleetWitness.agentC] 19))
        (fun _ => 4))
      ((fun _ => 14),
        (OpenCompositionBridge.FleetWitness.agentA'.lag,
          OpenCompositionBridge.fleetInit OpenCompositionBridge.FleetWitness.agentB
            [OpenCompositionBridge.FleetWitness.agentC])) :=
  ⟨OpenCompositionBridge.FleetWitness.witness_bundle.1,
   OpenCompositionBridge.FleetWitness.witness_bundle.2.2⟩

end SpineHooks

end UnifiedDrawdown

end Becoming
