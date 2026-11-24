import Becoming.StockFlowBridge
import Becoming.UnifiedDrawdown
import Becoming.OverExchange
import Becoming.Founding
import Becoming.OpenComposition
import Becoming.TurningInTime
import Becoming.LineOnAStock
import Becoming.CoreHelpers

/-!
# Evolutionary Drawdown: Derived Selection-to-Collapse, Multi-Site Exchange Bridges, and Compositional Transitions

AI-written (Wave U4-C Lean Builder, 24 November 2026), Pillar L2 of the Lean sufficiency map
(`Becoming.EvolutionaryDrawdown`). Pure Lean `4.29.1` (`Init` only: zero axioms, zero `sorry`,
zero private declarations, zero unnamed instances).

## What this module proves

1. **Derived Selection-to-Drawdown Link (`EmbodiedConversion`, Target 1):**
   Instead of postulating `use v = v.1 * u` or `grows : use u < taken use (kids u)` by hand,
   we derive cohort uptake floors (`derived_cohort_uptake_ge`), finite-horizon and global selection
   surpluses (`derived_surplus_of_selection_within`, `derived_surplus_of_selection`), step-by-step
   uptake floor growth (`derived_uptake_floor_rises`), generalized regime exhaustion
   (`derived_regime_exhausts_within`), derived `LineOnAStock` growth and termination
   (`derived_line_grows_and_ends`), bounded impossibility of persisting embodied selection surplus
   past the depletion horizon (`embodied_selection_surplus_impossible_past`), and non-vacuous
   finite-horizon drawdown collapse (`derived_surplus_drawdown_collapse`).
2. **Multi-Site `OpenComponent` ↔ `Flow.BalancesOn` / `World.ReadOffExchange` Bridge (`MultiSiteRelatum`, Target 2):**
   Constructively bridges multi-site `OpenComponent` dynamics over arbitrary `Ext : Type` (with no
   `DecidableEq Ext`) to `Flow.BalancesOn`, global `Flow.Balances`, `ExchangeRelation.Runs`,
   `World.ReadOffExchange` with substantive `requires` (`multiSite_run_readOffExchange`,
   `closedProcess_kernel_readOffExchange`), and localized `Nat`-clamping overdraw separation
   (`multiSite_overdraw_separation`).
3. **Compositional Evolutionary Transitions & Multi-Level Selection (Target 3):**
   Joins `Founding.Flow.ConfinedRise` and `Flow.family_excess_ends` (`unintegrated_confined_takeover_ends`),
   `OpenComposition.hide` / `hideContract` / `close_contract_viable` sealing internal hidden-site
   viability (`openComponent_hide_seals_internal_viability`), within-vs.-among selection shift
   (`compositional_transition_shifts_selection`), and nested sequestered whole-level selection
   (`nested_transition_raises_among`).
4. **Verified Concrete Finite Witnesses:**
   - `DerivedEmbodiedDrawWitness` (`SurplusRun` crashing `13 → 12 → 9 → 1 → 0` vs. `SteadyRun`
     persisting at `13`),
   - `MultiSiteBridgeWitness` (`UncheckedTwoSite` overdrawing at Site `true` while Site `false`
     stays balanced vs. `SafeTwoSite` certified via `Viability.Kernel`),
   - `MajorTransitionWitness` (`Unint` fast-drawer confined rise collapsing `9 → 8 → 3 → 0` vs.
     `Integ` `hideContract` holding `9 → 8 → 8 ...` above `6`, shifting selection in
     `SelectionLevels`; see `nested_transition_raises_among` for the general `Founding.Nested` law).

By `AGENTS.md` Rule 2, whether an actual evolving or learning system satisfies these hypotheses is
an empirical recognition outside Lean.
-/

namespace Becoming

open Generative

namespace EvolutionaryDrawdown

/-! ## Constructive Helpers -/

/-- Lower-bounding every member of a list by `m` lower-bounds the total by `xs.length * m`. -/
theorem length_mul_le_total {α : Type} {xs : List α} {m : Nat} {q : α → Nat}
    (bound : ∀ x, x ∈ xs → m ≤ q x) :
    xs.length * m ≤ total xs q :=
  Nat.le_trans (Nat.le_of_eq (total_const m xs).symm) (total_le xs bound)

/-- Every member of a list whose total is zero has value zero. -/
theorem eq_zero_of_total_eq_zero {α : Type} {q : α → Nat} :
    ∀ {xs : List α}, total xs q = 0 → ∀ x, x ∈ xs → q x = 0
  | [], _, _, mem => nomatch mem
  | _ :: _, hzero, x, mem =>
    match Nat.decEq (q x) 0 with
    | isTrue hz => hz
    | isFalse hne =>
      absurd (Nat.lt_of_lt_of_le (total_pos_of_mem mem (Nat.pos_of_ne_zero hne))
        (Nat.le_of_eq hzero)) (Nat.lt_irrefl 0)

/-! ## Target 1: Derived Selection-to-Drawdown Link -/

/-- Minimal physical transduction contract between a sustaining substrate pool `ds` and embodied
descendants `G`: each newly standing offspring starts at `0`, reaches embodiment mass `m > 0`,
is conserved across `L.BalancesOn` at `G.family (t + 1)`, and draws its construction from `ds`. -/
structure EmbodiedConversion {X : Type} (L : Flow X X) (W : Web X X)
    (G : SelectionTerm.Generations X) (ds : List X) (m : Nat) : Prop where
  pos_floor : 0 < m
  descended : SelectionTerm.Flow.Descended L W G
  embodied_floor : ∀ t p k, p ∈ G.family t → k ∈ G.kids t p → m ≤ W.level (t + 1) k
  balances_offspring : ∀ t, L.BalancesOn W (G.family (t + 1)) t
  conversion : ∀ t f, f ∈ L.present t →
    total (G.family (t + 1)) (L.give t f) ≤ total ds (L.take t f)

/-- Derives the conversion inequality directly from `Flow.DissipatesOn (ds ++ G.family (t + 1)) t`
when newborn offspring are not yet drawn from at their birth step. -/
theorem conversion_of_dissipatesOn {X : Type} {L : Flow X X}
    {G : SelectionTerm.Generations X} {ds : List X} {t : Nat}
    (dissipates : L.DissipatesOn (ds ++ G.family (t + 1)) t)
    (untaken_newborns : ∀ f k, f ∈ L.present t → k ∈ G.family (t + 1) → L.take t f k = 0) :
    ∀ f, f ∈ L.present t → total (G.family (t + 1)) (L.give t f) ≤ total ds (L.take t f) := by
  intro f hf
  have hd := dissipates f hf
  have hGive : total (ds ++ G.family (t + 1)) (L.give t f) =
      total ds (L.give t f) + total (G.family (t + 1)) (L.give t f) :=
    total_append (L.give t f) (G.family (t + 1)) ds
  have hTake : total (ds ++ G.family (t + 1)) (L.take t f) =
      total ds (L.take t f) + total (G.family (t + 1)) (L.take t f) :=
    total_append (L.take t f) (G.family (t + 1)) ds
  have hZero : total (G.family (t + 1)) (L.take t f) = 0 :=
    total_eq_zero fun k hk => untaken_newborns f k hf hk
  rw [hGive, hTake, hZero, Nat.add_zero] at hd
  exact Nat.le_trans (Nat.le_add_left _ _)
    (Nat.le_trans (Nat.le_add_right _ (sign _)) hd)

/-- **Derived Cohort Draw Floor.** Embodied descent (`Descended`, forcing `W.level t k = 0`),
offspring embodiment mass `m`, offspring conservation (`BalancesOn`), and `conversion` together
force total substrate uptake at step `t` to be at least `G.size (t + 1) * m`. -/
theorem derived_cohort_uptake_ge {X : Type} {L : Flow X X} {W : Web X X}
    {G : SelectionTerm.Generations X} {ds : List X} {m : Nat}
    (conv : EmbodiedConversion L W G ds m) (t : Nat) :
    G.size (t + 1) * m ≤ L.uptake ds t := by
  have hMember : ∀ k, k ∈ G.family (t + 1) → m ≤ L.given t k := by
    intro k hk
    obtain ⟨p, mp, mk⟩ := ListTests.mem_flatMap_iff.mp hk
    have hDesc := conv.descended t p k mp mk
    have hLvl0 : W.level t k = 0 := eq_zero_of_not_pos hDesc.2.2.1
    have hFloor : m ≤ W.level (t + 1) k := conv.embodied_floor t p k mp mk
    have hBal : W.level (t + 1) k + L.taken t k = W.level t k + L.given t k :=
      conv.balances_offspring t k hk
    rw [hLvl0, Nat.zero_add] at hBal
    exact Nat.le_trans hFloor (Nat.le_trans (Nat.le_add_right _ (L.taken t k)) (Nat.le_of_eq hBal))
  have hSum : G.size (t + 1) * m ≤ total (G.family (t + 1)) (L.given t) :=
    length_mul_le_total hMember
  have hSwap1 : total (G.family (t + 1)) (L.given t) =
      total (L.present t) (fun f => total (G.family (t + 1)) (L.give t f)) :=
    total_swap (fun k f => L.give t f k) (L.present t) (G.family (t + 1))
  have hConv : total (L.present t) (fun f => total (G.family (t + 1)) (L.give t f)) ≤
      total (L.present t) (fun f => total ds (L.take t f)) :=
    total_le (L.present t) (conv.conversion t)
  have hSwap2 : total (L.present t) (fun f => total ds (L.take t f)) = L.uptake ds t :=
    total_swap (fun f d => L.take t f d) ds (L.present t)
  exact Nat.le_trans hSum (Nat.le_trans (Nat.le_of_eq hSwap1) (Nat.le_trans hConv (Nat.le_of_eq hSwap2)))

/-- Helper: `ByNumber` on generation `t` equates `G.sum t` directly to `G.size (t + 1)`. -/
theorem sum_eq_next_size_on {α : Type} {G : SelectionTerm.Generations α} {t : Nat}
    (byNumAt : ∀ p, p ∈ G.family t → G.amount t p = G.offspringNumber t p) :
    G.sum t = G.size (t + 1) :=
  (total_congr_on byNumAt).trans (G.born_eq t)

/-- Helper: global `ByNumber` equates `G.sum t` directly to `G.size (t + 1)`. -/
theorem sum_eq_next_size_of_byNumber {α : Type} {G : SelectionTerm.Generations α}
    (byNum : Reproduction.Generations.ByNumber G) (t : Nat) :
    G.sum t = G.size (t + 1) :=
  Reproduction.Generations.ByNumber.sum_eq byNum t

/-- **Finite-Horizon Derived Reproduction Surplus from Selection.**
Scoped strictly to steps `t < K` with `T < K`: from initial replacement `G.size 0 ≤ G.size 1`,
`ByNumber`, support-topped amounts, and exact transmission up to `K`, together with a moved mean
at `T`, selection pushes the population strictly upward on `[T, K)`. -/
theorem derived_surplus_of_selection_within {X : Type} {L : Flow X X} {W : Web X X}
    (acting : L.Acting W) (dependent : W.Dependent)
    {G : SelectionTerm.Generations X} (descended : SelectionTerm.Flow.Descended L W G)
    {T K : Nat} (t_lt : T < K)
    (byNum : ∀ t, t < K → ∀ p, p ∈ G.family t → G.amount t p = G.offspringNumber t p)
    (top : ∀ t, t < K → ∀ p, p ∈ G.family t → W.Supported t p → ∀ q, q ∈ G.family t →
      G.amount t q ≤ G.amount t p)
    (exact : ∀ t, t < K → SelectionTerm.Exact (G.family t) (G.kids t) (G.amount t) (G.amount (t + 1)))
    (init_replace : G.size 0 ≤ G.size 1)
    (moved : G.size 0 * G.sum T ≠ G.size T * G.sum 0) :
    (∃ t, t < T ∧ G.discordAt t < G.concordAt t) ∧
    (0 < G.size T) ∧
    (∀ s, T ≤ s → s < K → G.size s < G.size (s + 1)) ∧
    (∀ k, T + k ≤ K → G.size T + k ≤ G.size (T + k)) := by
  have hDisc : ∀ t, t < K → G.discordAt t = 0 := fun t lt =>
    (SelectionTerm.Flow.support_not_against acting dependent (descended t) (top t lt)).1
  have hLow : ∀ t, t < K → G.loweredAt t = 0 := fun t lt =>
    SelectionTerm.lowered_exact (exact t lt)
  have hNotLower : G.size T * G.sum 0 ≤ G.size 0 * G.sum T :=
    G.not_lower T fun t lt =>
      G.not_lower_step (hDisc t (Nat.lt_trans lt t_lt)) (hLow t (Nat.lt_trans lt t_lt))
  have hMovedLt : G.size T * G.sum 0 < G.size 0 * G.sum T :=
    Nat.lt_of_le_of_ne hNotLower fun same => moved same.symm
  have hSelStep : ∃ t, t < T ∧ G.discordAt t < G.concordAt t :=
    match G.moved_by_selection (fun t lt => exact t (Nat.lt_trans lt t_lt)) moved with
    | ⟨t, lt, diff⟩ =>
      have d0 := hDisc t (Nat.lt_trans lt t_lt)
      ⟨t, lt, d0.symm ▸ Nat.pos_of_ne_zero fun c0 => diff (d0.trans c0.symm)⟩
  have hPosT : 0 < G.size T := match hT : G.size T with
    | 0 =>
      have hSumT : G.sum T = 0 := G.empty_sum hT
      absurd (by rw [hT, hSumT, Nat.zero_mul, Nat.mul_zero] at hMovedLt; exact hMovedLt)
        (Nat.lt_irrefl 0)
    | _ + 1 => Nat.succ_pos _
  have h0_lt : 0 < K := Nat.lt_of_le_of_lt (Nat.zero_le T) t_lt
  have hSum0 : G.sum 0 = G.size 1 := sum_eq_next_size_on (byNum 0 h0_lt)
  have hSumT : G.sum T = G.size (T + 1) := sum_eq_next_size_on (byNum T t_lt)
  have hBaseLt : G.size T < G.size (T + 1) := by
    have h1 : G.size T * G.size 0 ≤ G.size T * G.size 1 := Nat.mul_le_mul_left _ init_replace
    have h2 : G.size T * G.size 1 < G.size 0 * G.size (T + 1) := by
      rw [← hSum0, ← hSumT]
      exact hMovedLt
    have h3 : G.size 0 * G.size T < G.size 0 * G.size (T + 1) := by
      rw [Nat.mul_comm (G.size 0) (G.size T)]
      exact Nat.lt_of_le_of_lt h1 h2
    exact Naturals.lt_of_mul_lt_mul_left h3
  have hStepGrow : ∀ k, T + k < K → 0 < G.size (T + k) ∧ G.size (T + k) < G.size (T + k + 1) := by
    intro k
    induction k with
    | zero =>
      intro _
      exact ⟨hPosT, hBaseLt⟩
    | succ k ih =>
      intro hlt
      have hltPrev : T + k < K := Nat.lt_trans (Nat.lt_succ_self (T + k)) hlt
      obtain ⟨hPosPrev, hGrowPrev⟩ := ih hltPrev
      let s := T + k
      have hs : s < K := hltPrev
      have hs1 : s + 1 < K := hlt
      have hPosS1 : 0 < G.size (s + 1) := Nat.lt_trans hPosPrev hGrowPrev
      have hMean := G.mean_step s
      rw [hLow s hs, hDisc s hs, Nat.mul_zero, Nat.add_zero] at hMean
      rw [sum_eq_next_size_on (byNum s hs), sum_eq_next_size_on (byNum (s + 1) hs1)] at hMean
      have hProdLe : G.size (s + 1) * G.size (s + 1) ≤ G.size s * G.size (s + 2) :=
        Nat.le_trans (Nat.le_add_right _ _) (Nat.le_of_eq hMean.symm)
      have hProdLt : G.size s * G.size (s + 1) < G.size (s + 1) * G.size (s + 1) := by
        rw [Nat.mul_comm (G.size s) (G.size (s + 1)), Nat.mul_comm (G.size (s + 1)) (G.size (s + 1))]
        exact Naturals.mul_lt_mul_of_pos hPosS1 hGrowPrev
      have hGrowNext : G.size (s + 1) < G.size (s + 2) :=
        Naturals.lt_of_mul_lt_mul_left (Nat.lt_of_lt_of_le hProdLt hProdLe)
      exact ⟨hPosS1, hGrowNext⟩
  have hRange : ∀ s, T ≤ s → s < K → G.size s < G.size (s + 1) := by
    intro s hle hlt
    have hEq : T + (s - T) = s := Naturals.add_sub_of_le hle
    have hLtS : T + (s - T) < K := hEq.symm ▸ hlt
    have hk := (hStepGrow (s - T) hLtS).2
    rw [hEq] at hk
    exact hk
  have hCum : ∀ k, T + k ≤ K → G.size T + k ≤ G.size (T + k) := by
    intro k
    induction k with
    | zero =>
      intro _
      exact Nat.le_refl _
    | succ k ih =>
      intro hle
      have hlt : T + k < K := Nat.lt_of_succ_le hle
      have hPrev := ih (Nat.le_of_lt hlt)
      have hGrow := (hStepGrow k hlt).2
      exact Nat.le_trans (Nat.succ_le_succ hPrev) hGrow
  exact ⟨hSelStep, hPosT, hRange, hCum⟩

/-- **Derived Reproduction Surplus from Selection.**
Global specialization of `derived_surplus_of_selection_within`. -/
theorem derived_surplus_of_selection {X : Type} {L : Flow X X} {W : Web X X}
    (acting : L.Acting W) (dependent : W.Dependent)
    {G : SelectionTerm.Generations X} (descended : SelectionTerm.Flow.Descended L W G)
    (byNum : Reproduction.Generations.ByNumber G)
    (top : ∀ t p, p ∈ G.family t → W.Supported t p → ∀ q, q ∈ G.family t →
      G.amount t q ≤ G.amount t p)
    (exact : ∀ t, SelectionTerm.Exact (G.family t) (G.kids t) (G.amount t) (G.amount (t + 1)))
    (init_replace : G.size 0 ≤ G.size 1) {T : Nat}
    (moved : G.size 0 * G.sum T ≠ G.size T * G.sum 0) :
    (∃ t, t < T ∧ G.discordAt t < G.concordAt t) ∧
    (∀ s, T ≤ s → G.size s < G.size (s + 1)) ∧
    ∀ k, G.size T + k ≤ G.size (T + k) := by
  have wT := derived_surplus_of_selection_within acting dependent descended
    (Nat.lt_succ_self T) (fun t _ p mp => byNum t p) (fun t _ => top t) (fun t _ => exact t)
    init_replace moved
  refine ⟨wT.1, fun s hTs => ?_, fun k => ?_⟩
  · have ws := derived_surplus_of_selection_within acting dependent descended
      (Nat.lt_of_le_of_lt hTs (Nat.lt_succ_self s))
      (fun t _ p mp => byNum t p) (fun t _ => top t) (fun t _ => exact t)
      init_replace moved
    exact ws.2.2.1 s hTs (Nat.lt_succ_self s)
  · have wk := derived_surplus_of_selection_within acting dependent descended
      (Nat.lt_of_le_of_lt (Nat.le_add_right T k) (Nat.lt_succ_self (T + k)))
      (fun t _ p mp => byNum t p) (fun t _ => top t) (fun t _ => exact t)
      init_replace moved
    exact wk.2.2.2 k (Nat.le_succ (T + k))

/-- **Derived Step-by-Step Draw Lower-Bound Growth.**
Under `EmbodiedConversion` + derived surplus (`G.size (t + 1) < G.size (t + 2)`), the derived
uptake lower bound strictly climbs at every generation while reproduction continues. -/
theorem derived_uptake_floor_rises {X : Type} {L : Flow X X} {W : Web X X}
    {G : SelectionTerm.Generations X} {ds : List X} {m : Nat}
    (conv : EmbodiedConversion L W G ds m)
    {t : Nat} (grows : G.size (t + 1) < G.size (t + 2)) :
    G.size (t + 1) * m < G.size (t + 2) * m ∧ G.size (t + 2) * m ≤ L.uptake ds (t + 1) :=
  ⟨by
     rw [Nat.mul_comm (G.size (t + 1)) m, Nat.mul_comm (G.size (t + 2)) m]
     exact Naturals.mul_lt_mul_of_pos conv.pos_floor grows,
   derived_cohort_uptake_ge conv (t + 1)⟩

/-- **Generalization of `TurningInTime.rising_takes_all` to Lower-Bounded Derived Uptake.**
Does NOT assume `L.BalancesOn W ds` (since `RegimeMargin.step` clamps when `x < L.uptake`, which
is incompatible with `L.BalancesOn W ds` at `x ≤ L.uptake`), `use v = v.1 * u`, or strict
monotonicity of actual `L.uptake ds`: merely `EmbodiedConversion` and cohort growth `j ≤ hi` under
a bounded `RegimeMargin` (`FromNothing giving`, `Keeps giving 0 hi`, `x T ≤ hi`) forces
`x (T + hi + 1) = 0`. -/
theorem derived_regime_exhausts_within {X : Type} {L : Flow X X} {W : Web X X}
    {G : SelectionTerm.Generations X} {ds : List X} {m hi T : Nat}
    (conv : EmbodiedConversion L W G ds m)
    {giving : Nat → Nat} {x : Nat → Nat}
    (step_eq : ∀ t, x (t + 1) = RegimeMargin.step giving (L.uptake ds t) (x t))
    (nothing : RegimeMargin.FromNothing giving) (keeps : RegimeMargin.Keeps giving 0 hi)
    (high : x T ≤ hi)
    (grows : ∀ j, j ≤ hi → G.size (T + j) < G.size (T + j + 1)) :
    x (T + hi + 1) = 0 ∧ ∃ j, j ≤ hi ∧ x (T + j) ≤ L.uptake ds (T + j) := by
  have hBound : ∀ j, j ≤ hi → x (T + j) ≤ hi := by
    intro j
    induction j with
    | zero => intro _; exact high
    | succ j ih =>
      intro hle
      have hj : j ≤ hi := Nat.le_trans (Nat.le_succ j) hle
      rw [← Nat.add_assoc T j 1, step_eq (T + j)]
      exact TurningInTime.kept_within keeps (L.uptake ds (T + j)) (ih hj)
  have hSize : ∀ j, j ≤ hi → j + 1 ≤ G.size (T + j + 1) := by
    intro j
    induction j with
    | zero =>
      intro hle
      exact Nat.lt_of_le_of_lt (Nat.zero_le _) (grows 0 hle)
    | succ j ih =>
      intro hle
      have hj : j ≤ hi := Nat.le_trans (Nat.le_succ j) hle
      exact Nat.lt_of_le_of_lt (ih hj) (grows (j + 1) hle)
  have hUptake : x (T + hi) ≤ L.uptake ds (T + hi) :=
    Nat.le_trans (hBound hi (Nat.le_refl hi))
      (Nat.le_trans (Nat.le_succ hi)
        (Nat.le_trans (Nat.le_of_eq (Nat.mul_one (hi + 1)).symm)
          (Nat.le_trans (Nat.mul_le_mul (hSize hi (Nat.le_refl hi)) conv.pos_floor)
            (derived_cohort_uptake_ge conv (T + hi)))))
  have hZero : x (T + hi + 1) = 0 := by
    rw [step_eq (T + hi)]
    change (x (T + hi) - L.uptake ds (T + hi)) + giving (x (T + hi) - L.uptake ds (T + hi)) = 0
    rw [sub_eq_zero_of_le hUptake, Nat.zero_add, nothing]
  exact ⟨hZero, hi, Nat.le_refl hi, hUptake⟩

/-- **Derived `LineOnAStock.grows` & `LineOnAStock.way_ends` Bridge.**
When a `LineOnAStock` unit system has kid uptake lower-bounded by `m` and `use u < (kids u).length * m`,
`LineOnAStock.grows` (`use u < taken use (kids u)`) is derived and `LineOnAStock.way_ends` fires. -/
theorem derived_line_grows_and_ends {U : Type} {need : U → Nat} {kids : U → List U}
    {giving : Nat → Nat} {use : U → Nat} {m hi : Nat}
    (kid_use_ge : ∀ u v, v ∈ kids u → m ≤ use v)
    (surplus : ∀ u, use u < (kids u).length * m)
    (nothing : RegimeMargin.FromNothing giving) (keeps : RegimeMargin.Keeps giving 0 hi)
    (needs : ∀ u, 0 < need u) (down : ∀ u v, v ∈ kids u → need v ≤ need u)
    {w : List U} {x : Nat} (high : x ≤ hi) :
    (∀ u, use u < LineOnAStock.taken use (kids u)) ∧
    (∃ n, ¬ LineOnAStock.Goes need (LineOnAStock.course need kids giving use (w, x) n)) ∧
    ¬ «不穷» (LineOnAStock.net need kids giving use) «一» (w, x) :=
  have grows : ∀ u, use u < LineOnAStock.taken use (kids u) := fun u =>
    Nat.lt_of_lt_of_le (surplus u) (length_mul_le_total (kid_use_ge u))
  ⟨grows, LineOnAStock.way_ends nothing keeps grows needs down high⟩

/-- **Bounded Impossibility of Persisting Embodied Selection Surplus Past Depletion Horizon.**
On any balanced, acting, dependent world whose pool replenishment is capped by `R`, `EmbodiedConversion`,
`ByNumber`, support-topped amounts, and `Exact` transmission with initial replacement and moved mean at
`T` cannot simultaneously persist through step `T_ex + W.stock ds T_ex` (where `T_ex := T + (R + 1)`):
forced cohort growth yields deficit ≥ 2 at every step `T_ex + k`, contradicting `Flow.deficit_bounded_prefix`. -/
theorem embodied_selection_surplus_impossible_past {X : Type} {L : Flow X X} {W : Web X X}
    (balances : L.Balances W) (acting : L.Acting W) (dependent : W.Dependent)
    {G : SelectionTerm.Generations X} {ds : List X} {m R T : Nat}
    (conv : EmbodiedConversion L W G ds m)
    (rep_cap : ∀ t, L.replenishment ds t ≤ R)
    (init_replace : G.size 0 ≤ G.size 1)
    (moved : G.size 0 * G.sum T ≠ G.size T * G.sum 0) :
    let T_ex := T + (R + 1)
    ¬ (∀ t, t ≤ T_ex + W.stock ds T_ex →
        (∀ p, p ∈ G.family t → G.amount t p = G.offspringNumber t p) ∧
        (∀ p, p ∈ G.family t → W.Supported t p → ∀ q, q ∈ G.family t → G.amount t q ≤ G.amount t p) ∧
        SelectionTerm.Exact (G.family t) (G.kids t) (G.amount t) (G.amount (t + 1))) := by
  intro T_ex hAll
  let n := W.stock ds T_ex
  let K := T_ex + n + 1
  have hLtK : T < K :=
    Nat.lt_of_le_of_lt (Nat.le_add_right T (R + 1))
      (Nat.lt_of_le_of_lt (Nat.le_add_right T_ex n) (Nat.lt_succ_self (T_ex + n)))
  have hSurplus := derived_surplus_of_selection_within acting dependent conv.descended hLtK
    (fun t ht => (hAll t (Nat.le_of_lt_succ ht)).1)
    (fun t ht => (hAll t (Nat.le_of_lt_succ ht)).2.1)
    (fun t ht => (hAll t (Nat.le_of_lt_succ ht)).2.2)
    init_replace moved
  have hDeficit : ∀ k, k < n + 1 → L.replenishment ds (T_ex + k) + 2 ≤ L.uptake ds (T_ex + k) := by
    intro k hk
    have hEq : T + ((R + 1) + k + 1) = T_ex + k + 1 :=
      congrArg (· + 1) (Nat.add_assoc T (R + 1) k).symm
    have hBoundK : T + ((R + 1) + k + 1) ≤ K := by
      rw [hEq]
      exact Nat.succ_le_succ (Nat.add_le_add_left (Nat.le_of_lt_succ hk) T_ex)
    have hGrowK := hSurplus.2.2.2 ((R + 1) + k + 1) hBoundK
    rw [hEq] at hGrowK
    have hSizeGe : R + 2 ≤ G.size (T_ex + k + 1) := by
      have h1 : 1 + ((R + 1) + k + 1) ≤ G.size T + ((R + 1) + k + 1) :=
        Nat.add_le_add_right hSurplus.2.1 _
      have h2 : R + 2 ≤ 1 + ((R + 1) + k + 1) := by
        rw [Nat.add_comm 1 ((R + 1) + k + 1)]
        have hBase : R + 2 ≤ R + 1 + 1 + 1 := Nat.le_succ _
        have hK : R + 1 + 1 + 1 ≤ (R + 1) + k + 1 + 1 := by
          apply Nat.succ_le_succ
          apply Nat.succ_le_succ
          exact Nat.le_add_right (R + 1) k
        exact Nat.le_trans hBase hK
      exact Nat.le_trans h2 (Nat.le_trans h1 hGrowK)
    have hUptakeGe : R + 2 ≤ L.uptake ds (T_ex + k) :=
      Nat.le_trans hSizeGe
        (Nat.le_trans (Nat.le_of_eq (Nat.mul_one _).symm)
          (Nat.le_trans (Nat.mul_le_mul_left _ conv.pos_floor)
            (derived_cohort_uptake_ge conv (T_ex + k))))
    exact Nat.le_trans (Nat.add_le_add_right (rep_cap (T_ex + k)) 2) hUptakeGe
  have hPrefix := Flow.deficit_bounded_prefix (ds := ds) (T := T_ex) (d := 2) (n + 1)
    (fun k _ => balances.on ds (T_ex + k)) hDeficit
  have hMul : (n + 1) * 2 ≤ n :=
    Nat.le_trans (Nat.le_add_left ((n + 1) * 2) (W.stock ds (T_ex + (n + 1)))) hPrefix
  have hEqMul : (n + 1) * 2 = n + (n + 2) := by
    rw [Nat.succ_mul, Nat.mul_comm n 2, Naturals.two_mul n, Nat.add_assoc]
  rw [hEqMul] at hMul
  have hAbs := Naturals.le_of_add_le_add_left (k := n) (Nat.le_trans hMul (Nat.le_of_eq (Nat.add_zero n).symm))
  exact Nat.not_succ_le_zero (n + 1) hAbs

/-- **Non-Vacuous Finite-Horizon Derived Selection-to-Collapse Loop.**
Scopes `ByNumber`, `top`, and `Exact` to `[0, T_ex)` (`T_ex := T + (R + 1)`), proving selection
already lifts the cohort size to `R + 2 ≤ G.size T_ex`, and under bounded surplus
`R + 1 ≤ G.size (T_ex + k + 1)` for `k < n` with `W.stock ds T_ex < n + m_need`, proves strict
excess on `[T_ex, T_ex + n)`, exhaustion `W.stock ds (T_ex + n) < m_need`, total inactivity at
`T_ex + n`, and cohort vanishing `G.size (T_ex + n + 1) = 0`. -/
theorem derived_surplus_drawdown_collapse {X : Type} {L : Flow X X} {W : Web X X}
    (balances : L.Balances W) (acting : L.Acting W) (dependent : W.Dependent)
    {G : SelectionTerm.Generations X} {ds : List X} {m R m_need T n : Nat}
    (rep_cap : ∀ t, L.replenishment ds t ≤ R)
    (depends_ds : ∀ p, p ∈ G.family (T + (R + 1) + n) →
      W.active (T + (R + 1) + n) p →
      ∃ e, e ∈ ds ∧ W.requires (T + (R + 1) + n) p e ∧ m_need ≤ W.need (T + (R + 1) + n) p e)
    (conv : EmbodiedConversion L W G ds m)
    (byNum : ∀ t, t < T + (R + 1) → ∀ p, p ∈ G.family t → G.amount t p = G.offspringNumber t p)
    (top : ∀ t, t < T + (R + 1) → ∀ p, p ∈ G.family t → W.Supported t p →
      ∀ q, q ∈ G.family t → G.amount t q ≤ G.amount t p)
    (exact : ∀ t, t < T + (R + 1) →
      SelectionTerm.Exact (G.family t) (G.kids t) (G.amount t) (G.amount (t + 1)))
    (init_replace : G.size 0 ≤ G.size 1)
    (moved : G.size 0 * G.sum T ≠ G.size T * G.sum 0)
    (plateau : ∀ k, k < n → R + 1 ≤ G.size (T + (R + 1) + k + 1))
    (start : W.stock ds (T + (R + 1)) < n + m_need) :
    let T_ex := T + (R + 1)
    (∃ t, t < T ∧ G.discordAt t < G.concordAt t) ∧
    R + 2 ≤ G.size T_ex ∧
    (∀ k, k < n → L.replenishment ds (T_ex + k) < L.uptake ds (T_ex + k)) ∧
    W.stock ds (T_ex + n) < m_need ∧
    (∀ p, p ∈ G.family (T_ex + n) → ¬ W.active (T_ex + n) p) ∧
    G.size (T_ex + n + 1) = 0 := by
  intro T_ex
  have hLtTex : T < T_ex := Nat.lt_add_of_pos_right (Nat.succ_pos R)
  have hSurplus := derived_surplus_of_selection_within acting dependent conv.descended hLtTex
    byNum top exact init_replace moved
  have hSizeTex : R + 2 ≤ G.size T_ex := by
    have h1 : 1 + (R + 1) ≤ G.size T + (R + 1) := Nat.add_le_add_right hSurplus.2.1 (R + 1)
    have h2 : G.size T + (R + 1) ≤ G.size T_ex := hSurplus.2.2.2 (R + 1) (Nat.le_refl T_ex)
    rw [Nat.add_comm 1 (R + 1)] at h1
    exact Nat.le_trans h1 h2
  have hExcess : ∀ k, k < n → L.replenishment ds (T_ex + k) < L.uptake ds (T_ex + k) := by
    intro k hk
    have hUptake : R + 1 ≤ L.uptake ds (T_ex + k) :=
      Nat.le_trans (plateau k hk)
        (Nat.le_trans (Nat.le_of_eq (Nat.mul_one _).symm)
          (Nat.le_trans (Nat.mul_le_mul_left _ conv.pos_floor)
            (derived_cohort_uptake_ge conv (T_ex + k))))
    exact Nat.lt_of_le_of_lt (rep_cap (T_ex + k)) hUptake
  have hBelow : W.stock ds (T_ex + n) < m_need :=
    Flow.below_of_excess_within (fun k _ => balances.on ds (T_ex + k)) hExcess start
  have hInactive : ∀ p, p ∈ G.family (T_ex + n) → ¬ W.active (T_ex + n) p := by
    intro p mp act
    obtain ⟨e, inside, req, need_ge⟩ := depends_ds p mp act
    have hNeedLe : W.need (T_ex + n) p e ≤ W.level (T_ex + n) e :=
      dependent (T_ex + n) p act e req
    have hStockGe : m_need ≤ W.stock ds (T_ex + n) :=
      Nat.le_trans need_ge (Nat.le_trans hNeedLe (le_total_of_mem inside))
    exact Nat.not_le_of_gt hBelow hStockGe
  have hEnd : G.size (T_ex + n + 1) = 0 :=
    GroupEnding.Flow.all_end acting conv.descended hInactive
  exact ⟨hSurplus.1, hSizeTex, hExcess, hBelow, hInactive, hEnd⟩

/-! ## Target 2: Multi-Site `OpenComponent` ↔ `Flow.BalancesOn` / `World.ReadOffExchange` Bridge -/

/-- Homogeneous relatum type unifying boundary conditions (`site k`) and active exchangers
(`component`, `environment`, `renewer`) into one `World`. -/
inductive MultiSiteRelatum (Ext : Type) where
  | site : Ext → MultiSiteRelatum Ext
  | component : MultiSiteRelatum Ext
  | environment : MultiSiteRelatum Ext
  | renewer : MultiSiteRelatum Ext

section MultiSiteBridge

variable {S Obs Dist Int Ext Env : Type}
  (C : OpenComposition.OpenComponent S Obs Dist Int Ext)
  (obs : (Ext → Nat) → Obs)
  (channel : Bool → Nat → Env → Bool)
  (G : Ext → (Ext → Nat) → Nat)
  (envDraw : Env → Ext → Nat)

/-- Total boundary draw on site `k` at step `t` along `(st, env)`. -/
def multiSiteDrawAt (st : Nat → (Ext → Nat) × S) (env : Nat → Env) (t : Nat) (k : Ext) : Nat :=
  C.drawExt (st t).2 k + envDraw (env t) k

/-- Active exchanger list at every step. -/
def multiSitePresent (_ : Nat) : List (MultiSiteRelatum Ext) :=
  [.component, .environment, .renewer]

/-- Levels along trajectory `st`: site `k` carries `(st t).1 k`, exchangers stand at `0`. -/
def multiSiteLevel (st : Nat → (Ext → Nat) × S) (t : Nat) : MultiSiteRelatum Ext → Nat
  | .site k => (st t).1 k
  | .component => 0
  | .environment => 0
  | .renewer => 0

/-- Unclamped multi-site `Flow` using nested single-argument exhaustive matches. -/
def multiSiteFlow (st : Nat → (Ext → Nat) × S) (env : Nat → Env) :
    Flow (MultiSiteRelatum Ext) (MultiSiteRelatum Ext) where
  present := multiSitePresent
  take t f c := match f with
    | .component => match c with
      | .site k => C.drawExt (st t).2 k
      | .component => 0
      | .environment => 0
      | .renewer => 0
    | .environment => match c with
      | .site k => envDraw (env t) k
      | .component => 0
      | .environment => 0
      | .renewer => 0
    | .site _ => 0
    | .renewer => 0
  give t f c := match f with
    | .renewer => match c with
      | .site k =>
        G k (RegimeMargin.Coupled.Indexed.left RegimeMargin.Drawn.whole
          (multiSiteDrawAt C envDraw st env t) (st t).1)
      | .component => 0
      | .environment => 0
      | .renewer => 0
    | .site _ => 0
    | .component => 0
    | .environment => 0

/-- Exact open exchange relation admitting unclamped extraction only when each site stands at or
above its total draw, using nested single-argument exhaustive matches. -/
def multiSiteRel (st : Nat → (Ext → Nat) × S) (env : Nat → Env) :
    ExchangeRelation (MultiSiteRelatum Ext) (MultiSiteRelatum Ext) where
  admits t l take give :=
    (∀ f c, take f c = (multiSiteFlow C G envDraw st env).take t f c) ∧
    (∀ f c, give f c = match f with
      | .renewer => match c with
        | .site k => G k (fun j => l t (.site j) - multiSiteDrawAt C envDraw st env t j)
        | .component => 0
        | .environment => 0
        | .renewer => 0
      | .site _ => 0
      | .component => 0
      | .environment => 0) ∧
    (∀ k, multiSiteDrawAt C envDraw st env t k ≤ l t (.site k))

/-- Need table: any exchanger drawing positively from `.site k` needs `multiSiteDrawAt ... t k` at
`.site k`, using nested single-argument exhaustive matches. -/
def multiSiteNeed (st : Nat → (Ext → Nat) × S) (env : Nat → Env)
    (t : Nat) (f c : MultiSiteRelatum Ext) : Nat :=
  match f with
  | .component => match c with
    | .site k => if Nat.ble 1 (C.drawExt (st t).2 k) then multiSiteDrawAt C envDraw st env t k else 0
    | .component => 0
    | .environment => 0
    | .renewer => 0
  | .environment => match c with
    | .site k => if Nat.ble 1 (envDraw (env t) k) then multiSiteDrawAt C envDraw st env t k else 0
    | .component => 0
    | .environment => 0
    | .renewer => 0
  | .site _ => 0
  | .renewer => 0

/-- Multi-site `Web` read off `multiSiteRel`. -/
def multiSiteWeb (st : Nat → (Ext → Nat) × S) (env : Nat → Env) :
    Web (MultiSiteRelatum Ext) (MultiSiteRelatum Ext) :=
  (multiSiteRel C G envDraw st env).readWeb multiSitePresent
    (multiSiteFlow C G envDraw st env)
    (multiSiteLevel st)
    (multiSiteNeed C envDraw st env)

/-- Multi-site `World`. -/
def multiSiteWorld (st : Nat → (Ext → Nat) × S) (env : Nat → Env) : World :=
  World.of (MultiSiteRelatum Ext) (multiSiteFlow C G envDraw st env) (multiSiteWeb C G envDraw st env)

theorem multiSiteFlow_taken_site (st : Nat → (Ext → Nat) × S) (env : Nat → Env) (t : Nat) (k : Ext) :
    (multiSiteFlow C G envDraw st env).taken t (.site k) = multiSiteDrawAt C envDraw st env t k :=
  Nat.add_zero _

theorem multiSiteFlow_given_site (st : Nat → (Ext → Nat) × S) (env : Nat → Env) (t : Nat) (k : Ext) :
    (multiSiteFlow C G envDraw st env).given t (.site k) =
      G k (RegimeMargin.Coupled.Indexed.left RegimeMargin.Drawn.whole
        (multiSiteDrawAt C envDraw st env t) (st t).1) :=
  (Nat.zero_add _).trans ((Nat.zero_add _).trans (Nat.add_zero _))

theorem multiSiteFlow_taken_nonSite (st : Nat → (Ext → Nat) × S) (env : Nat → Env) (t : Nat) :
    (multiSiteFlow C G envDraw st env).taken t .component = 0 ∧
    (multiSiteFlow C G envDraw st env).taken t .environment = 0 ∧
    (multiSiteFlow C G envDraw st env).taken t .renewer = 0 :=
  ⟨rfl, rfl, rfl⟩

theorem multiSiteFlow_given_nonSite (st : Nat → (Ext → Nat) × S) (env : Nat → Env) (t : Nat) :
    (multiSiteFlow C G envDraw st env).given t .component = 0 ∧
    (multiSiteFlow C G envDraw st env).given t .environment = 0 ∧
    (multiSiteFlow C G envDraw st env).given t .renewer = 0 :=
  ⟨rfl, rfl, rfl⟩

/-- **Pointwise Multi-Site Conservation Iff Pre-Overdraw.** -/
theorem multiSite_balance_site_iff {st : Nat → (Ext → Nat) × S} {env : Nat → Env} {dist : Nat → Dist}
    (step_eq : ∀ t, st (t + 1) = OpenComposition.closedStep C obs channel G envDraw (st t) (env t, dist t))
    (t : Nat) (k : Ext) :
    ((multiSiteWeb C G envDraw st env).level (t + 1) (.site k) +
        (multiSiteFlow C G envDraw st env).taken t (.site k) =
      (multiSiteWeb C G envDraw st env).level t (.site k) +
        (multiSiteFlow C G envDraw st env).given t (.site k)) ↔
      multiSiteDrawAt C envDraw st env t k ≤ (st t).1 k := by
  have hStep : (multiSiteWeb C G envDraw st env).level (t + 1) (.site k) =
      ((st t).1 k - multiSiteDrawAt C envDraw st env t k) +
        (multiSiteFlow C G envDraw st env).given t (.site k) := by
    change (st (t + 1)).1 k = _
    rw [step_eq t]
    exact congrArg ((((st t).1 k - multiSiteDrawAt C envDraw st env t k) + ·))
      (multiSiteFlow_given_site C G envDraw st env t k).symm
  rw [multiSiteFlow_taken_site C G envDraw st env t k]
  exact StockFlowBridge.clampedStep_balance_iff_le hStep

/-- **Exact Multi-Site `BalancesOn` Equivalence.** -/
theorem multiSite_balancesOn_iff {st : Nat → (Ext → Nat) × S} {env : Nat → Env} {dist : Nat → Dist}
    (step_eq : ∀ t, st (t + 1) = OpenComposition.closedStep C obs channel G envDraw (st t) (env t, dist t))
    (sites : List Ext) (t : Nat) :
    (multiSiteFlow C G envDraw st env).BalancesOn
        (multiSiteWeb C G envDraw st env) (sites.map MultiSiteRelatum.site) t ↔
      ∀ k, k ∈ sites → multiSiteDrawAt C envDraw st env t k ≤ (st t).1 k := by
  constructor
  · intro hBal k hk
    exact (multiSite_balance_site_iff C obs channel G envDraw step_eq t k).mp
      (hBal (.site k) (ListTests.mem_map_of hk))
  · intro hPre c hc
    obtain ⟨k, hk, hSame⟩ := preimage_of_mem_map hc
    rw [← hSame]
    exact (multiSite_balance_site_iff C obs channel G envDraw step_eq t k).mpr (hPre k hk)

/-- **Pre-Overdraw Multi-Site Conservation (`BalancesOn`).** -/
theorem multiSite_balancesOn_of_preOverdraw {st : Nat → (Ext → Nat) × S} {env : Nat → Env}
    {dist : Nat → Dist}
    (step_eq : ∀ t, st (t + 1) = OpenComposition.closedStep C obs channel G envDraw (st t) (env t, dist t))
    {sites : List Ext} {t : Nat}
    (pre : ∀ k, k ∈ sites → multiSiteDrawAt C envDraw st env t k ≤ (st t).1 k) :
    (multiSiteFlow C G envDraw st env).BalancesOn
      (multiSiteWeb C G envDraw st env) (sites.map MultiSiteRelatum.site) t :=
  (multiSite_balancesOn_iff C obs channel G envDraw step_eq sites t).mpr pre

/-- **Global Pre-Overdraw Multi-Site Conservation (`Flow.Balances`).** -/
theorem multiSite_balances_of_global_preOverdraw {st : Nat → (Ext → Nat) × S} {env : Nat → Env}
    {dist : Nat → Dist}
    (step_eq : ∀ t, st (t + 1) = OpenComposition.closedStep C obs channel G envDraw (st t) (env t, dist t))
    (pre_all : ∀ t k, multiSiteDrawAt C envDraw st env t k ≤ (st t).1 k) :
    (multiSiteFlow C G envDraw st env).Balances (multiSiteWeb C G envDraw st env) := by
  intro t c
  cases c with
  | site k => exact (multiSite_balance_site_iff C obs channel G envDraw step_eq t k).mpr (pre_all t k)
  | component => rfl
  | environment => rfl
  | renewer => rfl

/-- **Run-level `World.ReadOffExchange` Correspondence + Non-Vacuous Needs.** -/
theorem multiSite_run_readOffExchange {init : S} {c : OpenComposition.InterfaceContract C init}
    {jointAdm : Env → Prop}
    (r : Run (OpenComposition.closedProcess C c obs channel G envDraw jointAdm))
    (pre_all : ∀ t k, multiSiteDrawAt C envDraw r.state (fun t => (r.act t).1) t k ≤ (r.state t).1 k) :
    let st := r.state
    let env := fun t => (r.act t).1
    (multiSiteRel C G envDraw st env).Runs multiSitePresent (multiSiteLevel st)
      (multiSiteFlow C G envDraw st env) ∧
    (multiSiteWorld C G envDraw st env).ReadOffExchange ∧
    (multiSiteFlow C G envDraw st env).Balances (multiSiteWeb C G envDraw st env) ∧
    (∀ t k, 0 < C.drawExt (st t).2 k →
      (multiSiteWeb C G envDraw st env).requires t .component (.site k)) := by
  intro st env
  have hRuns : (multiSiteRel C G envDraw st env).Runs multiSitePresent (multiSiteLevel st)
      (multiSiteFlow C G envDraw st env) := fun t =>
    ⟨rfl, fun _ _ => rfl, fun f' c' => rfl, pre_all t⟩
  have hRead : (multiSiteWorld C G envDraw st env).ReadOffExchange :=
    ExchangeRelation.Runs.readOffExchange hRuns (multiSiteNeed C envDraw st env)
  have hBal : (multiSiteFlow C G envDraw st env).Balances (multiSiteWeb C G envDraw st env) :=
    multiSite_balances_of_global_preOverdraw C obs channel G envDraw
      (fun t => (r.step t).2) pre_all
  have hReq : ∀ t k, 0 < C.drawExt (st t).2 k →
      (multiSiteWeb C G envDraw st env).requires t .component (.site k) := by
    intro t k hPos l' _ hLt take give hAdm _
    have hBle : Nat.ble 1 (C.drawExt (st t).2 k) = true := Nat.ble_eq_true_of_le hPos
    change l' t (.site k) <
        (if Nat.ble 1 (C.drawExt (st t).2 k) then multiSiteDrawAt C envDraw st env t k else 0) at hLt
    rw [hBle] at hLt
    exact Nat.not_le_of_gt hLt (hAdm.2.2 k)
  exact ⟨hRuns, hRead, hBal, hReq⟩

/-- **Guard-Based Multi-Site `Balances` & `ReadOffExchange`.**
Uses `(r.step t).1.1 : jointAdm (r.act t).1` directly from the `Run`. -/
theorem closedProcess_guard_readOffExchange {init : S}
    {c : OpenComposition.InterfaceContract C init} {jointAdm : Env → Prop}
    {envCap x_crit : Ext → Nat}
    (r : Run (OpenComposition.closedProcess C c obs channel G envDraw jointAdm))
    (guard : ∀ t, OpenComposition.closedGuard C c x_crit (r.state t))
    (env_within : ∀ env, jointAdm env → ∀ k, envDraw env k ≤ envCap k)
    (cap_within : ∀ k, c.preCapExt k + envCap k ≤ x_crit k) :
    let st := r.state
    let env := fun t => (r.act t).1
    (multiSiteFlow C G envDraw st env).Balances (multiSiteWeb C G envDraw st env) ∧
    (multiSiteWorld C G envDraw st env).ReadOffExchange := by
  have hPre : ∀ t k, multiSiteDrawAt C envDraw r.state (fun t => (r.act t).1) t k ≤ (r.state t).1 k := by
    intro t k
    have hg := guard t
    have hadm : jointAdm (r.act t).1 := (r.step t).1.1
    exact Nat.le_trans
      (Nat.add_le_add (hg.2.2.1 k) (env_within _ hadm k))
      (Nat.le_trans (cap_within k) (hg.1 k))
  have hRun := multiSite_run_readOffExchange C obs channel G envDraw r hPre
  exact ⟨hRun.2.2.1, hRun.2.1⟩

/-- **`Viability.Kernel`-Based Multi-Site `Balances` & `ReadOffExchange`.**
Derives permanent `closedGuard` along any run from `Viability.Kernel` via `Viability.Kernel.run`. -/
theorem closedProcess_kernel_readOffExchange {init : S}
    {c : OpenComposition.InterfaceContract C init} {jointAdm : Env → Prop}
    {envCap x_crit : Ext → Nat}
    (r : Run (OpenComposition.closedProcess C c obs channel G envDraw jointAdm))
    (kern : Viability.Kernel (OpenComposition.closedProcess C c obs channel G envDraw jointAdm)
      (OpenComposition.closedGuard C c x_crit) (r.state 0))
    (env_within : ∀ env, jointAdm env → ∀ k, envDraw env k ≤ envCap k)
    (cap_within : ∀ k, c.preCapExt k + envCap k ≤ x_crit k) :
    let st := r.state
    let env := fun t => (r.act t).1
    (multiSiteFlow C G envDraw st env).Balances (multiSiteWeb C G envDraw st env) ∧
    (multiSiteWorld C G envDraw st env).ReadOffExchange :=
  closedProcess_guard_readOffExchange C obs channel G envDraw r
    (Viability.Kernel.run r kern) env_within cap_within

/-- **Multi-Site Overdraw Separation.**
Generalizes `UnifiedDrawdown.OverdrawSeparationWitness` to `sites : List Ext`: when `kStar ∈ sites`
clamps at `tStar` while earlier steps and all `k ≠ kStar` stay pre-overdraw, other sites remain
balanced while `kStar` exhibits exact clamping discrepancy `H tStar kStar - x tStar kStar > 0`
and breaks `BalancesOn`, global `Balances`, and `multiSiteRel.Runs`. -/
theorem multiSite_overdraw_separation {st : Nat → (Ext → Nat) × S} {env : Nat → Env} {dist : Nat → Dist}
    (step_eq : ∀ t, st (t + 1) = OpenComposition.closedStep C obs channel G envDraw (st t) (env t, dist t))
    {sites : List Ext} {tStar : Nat} {kStar : Ext}
    (mem_kStar : kStar ∈ sites)
    (earlier : ∀ t, t < tStar → ∀ k, k ∈ sites → multiSiteDrawAt C envDraw st env t k ≤ (st t).1 k)
    (over : (st tStar).1 kStar < multiSiteDrawAt C envDraw st env tStar kStar)
    (others_ok : ∀ k, k ∈ sites → k ≠ kStar → multiSiteDrawAt C envDraw st env tStar k ≤ (st tStar).1 k) :
    let H := multiSiteDrawAt C envDraw st env
    let L := multiSiteFlow C G envDraw st env
    let W := multiSiteWeb C G envDraw st env
    (∀ t, t < tStar → L.BalancesOn W (sites.map MultiSiteRelatum.site) t) ∧
    (∀ k, k ∈ sites → k ≠ kStar →
      W.level (tStar + 1) (.site k) + L.taken tStar (.site k) =
        W.level tStar (.site k) + L.given tStar (.site k)) ∧
    ((st (tStar + 1)).1 kStar + H tStar kStar =
      ((st tStar).1 kStar + L.given tStar (.site kStar)) + (H tStar kStar - (st tStar).1 kStar) ∧
      0 < H tStar kStar - (st tStar).1 kStar) ∧
    W.level tStar (.site kStar) + L.given tStar (.site kStar) <
      W.level (tStar + 1) (.site kStar) + L.taken tStar (.site kStar) ∧
    W.level (tStar + 1) (.site kStar) + L.taken tStar (.site kStar) =
      (W.level tStar (.site kStar) + L.given tStar (.site kStar)) + (H tStar kStar - (st tStar).1 kStar) ∧
    ¬ L.BalancesOn W (sites.map MultiSiteRelatum.site) tStar ∧
    ¬ L.Balances W ∧
    ¬ (multiSiteRel C G envDraw st env).Runs multiSitePresent (multiSiteLevel st) L := by
  intro H L W
  have hStepStar : (st (tStar + 1)).1 kStar =
      ((st tStar).1 kStar - H tStar kStar) + L.given tStar (.site kStar) := by
    rw [step_eq tStar]
    exact congrArg ((((st tStar).1 kStar - H tStar kStar) + ·))
      (multiSiteFlow_given_site C G envDraw st env tStar kStar).symm
  have hDiscrepEq := StockFlowBridge.clampedStep_balance_discrepancy hStepStar
  have hDiscrepPos : 0 < H tStar kStar - (st tStar).1 kStar := SupportGated.sub_pos_of_lt over
  have hWebDiscrep : W.level (tStar + 1) (.site kStar) + L.taken tStar (.site kStar) =
      (W.level tStar (.site kStar) + L.given tStar (.site kStar)) + (H tStar kStar - (st tStar).1 kStar) := by
    change (st (tStar + 1)).1 kStar + L.taken tStar (.site kStar) = _
    rw [multiSiteFlow_taken_site C G envDraw st env tStar kStar]
    exact hDiscrepEq
  have hStrictLt : W.level tStar (.site kStar) + L.given tStar (.site kStar) <
      W.level (tStar + 1) (.site kStar) + L.taken tStar (.site kStar) :=
    hWebDiscrep ▸ Nat.lt_add_of_pos_right hDiscrepPos
  have hNotBalOn : ¬ L.BalancesOn W (sites.map MultiSiteRelatum.site) tStar := fun hBal =>
    Nat.lt_irrefl _ (Nat.lt_of_lt_of_le hStrictLt
      (Nat.le_of_eq (hBal (.site kStar) (ListTests.mem_map_of mem_kStar))))
  exact ⟨fun t ht => multiSite_balancesOn_of_preOverdraw C obs channel G envDraw step_eq (earlier t ht),
    fun k hk hne => (multiSite_balance_site_iff C obs channel G envDraw step_eq tStar k).mpr (others_ok k hk hne),
    ⟨hDiscrepEq, hDiscrepPos⟩, hStrictLt, hWebDiscrep, hNotBalOn,
    fun hBal => hNotBalOn (hBal.on (sites.map MultiSiteRelatum.site) tStar),
    fun hRuns => Nat.not_le_of_gt over ((hRuns tStar).2.2.2 kStar)⟩

end MultiSiteBridge

/-! ## Target 3: Compositional Evolutionary Transitions & Multi-Level Selection -/

/-- **Pre-Transition Confined Takeover Trap.**
For an unpoliced group `h` drawing on a coupled shared condition family `ds_h`:
(a) any fast-drawing confined sub-lineage (`Founding.Flow.ConfinedRise`) vanishes
    (`lineage G h_fast (T + n + j + 1) = []`), and
(b) every member of `h` depending on `ds_h` ceases to be active and leaves zero offspring
    (`total h (G.offspringNumber (T + n + k)) = 0`). -/
theorem unintegrated_confined_takeover_ends {X : Type} {L : Flow X X} {W : Web X X}
    (balances : L.Balances W) (acting : L.Acting W) (dependent : W.Dependent)
    {G : SelectionTerm.Generations X} {h h_fast ds_h : List X} {m T n : Nat}
    (rise : Founding.Flow.ConfinedRise L W G h_fast ds_h m T n)
    (descended : SelectionTerm.Flow.Descended L W G)
    (k : Nat)
    (within_h : ∀ p, p ∈ h → p ∈ G.family (T + n + k))
    (coupled_h : ∀ p, p ∈ h → ∃ e, e ∈ ds_h ∧ W.requires (T + n + k) p e ∧ m ≤ W.need (T + n + k) p e) :
    (∀ j, SelectionLevels.lineage G h_fast (T + n + j + 1) = []) ∧
    total h (G.offspringNumber (T + n + k)) = 0 :=
  ⟨fun j => Founding.Flow.ConfinedRise.ends balances acting dependent descended rise j,
   GroupEnding.Flow.group_childless acting descended within_h fun p mp =>
     match coupled_h p mp with
     | ⟨e, inside, req, high⟩ =>
       Becoming.Flow.family_excess_ends balances acting dependent rise.gated rise.excess rise.start
         k p e inside req high⟩

/-- **Compositional Sealing via `OpenComponent.hide` Preserves Hidden-Site Kernel & Multi-Site Balance.**
Calls `OpenComposition.close_contract_viable` so `closedInv` yields both `Viability.Kernel` and
`hideContract_keeps_hidden` (`x_crit_hide k ≤ (r.state t).2.2 k`), plus kept-site safety and
hidden-site pre-cap adherence along every run. -/
theorem openComponent_hide_seals_internal_viability
    {S₁ S₂ Obs₁ Obs₂ ObsOuter Dist₁ Dist₂ Int₁ Int₂ ExtKeep ExtHide Env : Type}
    (A : OpenComposition.OpenComponent S₁ Obs₁ Dist₁ Int₁ (Sum ExtKeep ExtHide))
    (B : OpenComposition.OpenComponent S₂ Obs₂ Dist₂ Int₂ (Sum ExtKeep ExtHide))
    {init₁ : S₁} {init₂ : S₂}
    (cA : OpenComposition.InterfaceContract A init₁)
    (cB : OpenComposition.InterfaceContract B init₂)
    (G_hide : ExtHide → (ExtHide → Nat) → Nat)
    (wireObs : ObsOuter → (ExtHide → Nat) → (Obs₁ × Obs₂))
    (tolOuter : ObsOuter × Bool → (Dist₁ × Dist₂) → Prop)
    (warnOuter : ObsOuter → Prop)
    (x_crit_hide warnHide H_safe_hide x₀_hide : ExtHide → Nat)
    (tol_lifts : ∀ o xh al b d, tolOuter (o, al) d →
      (OpenComposition.composeContract cA cB).tol (wireObs o xh, b) d)
    (G_hide_rises : ∀ k, RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (G_hide k))
    (wire_outer_warn : ∀ o xh, warnOuter o →
      (OpenComposition.composeContract cA cB).warnObs (wireObs o xh))
    (wire_hide_warn : ∀ o xh, (∃ k, xh k < warnHide k) →
      (OpenComposition.composeContract cA cB).warnObs (wireObs o xh))
    (hide_post_viable : ∀ k, x_crit_hide k ≤
      RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole G_hide H_safe_hide x_crit_hide k)
    (hide_post_allowance : ∀ k, (OpenComposition.composeContract cA cB).postBudgetExt (Sum.inr k) ≤ H_safe_hide k)
    (hide_warn_margin : ∀ k,
      x_crit_hide k + ((OpenComposition.composeContract cA cB).maxLag + 1) *
        (OpenComposition.composeContract cA cB).preCapExt (Sum.inr k) ≤ warnHide k)
    (hide_init_margin : ∀ k,
      x_crit_hide k + (OpenComposition.composeContract cA cB).eta (init₁, init₂) *
        (OpenComposition.composeContract cA cB).preCapExt (Sum.inr k) ≤ x₀_hide k)
    (obsOuter : (ExtKeep → Nat) → ObsOuter)
    (channel : Bool → Nat → Env → Bool)
    (G_keep : ExtKeep → (ExtKeep → Nat) → Nat)
    (envDraw : Env → ExtKeep → Nat) (envCap : ExtKeep → Nat) (jointAdm : Env → Prop)
    (env_within : ∀ env, jointAdm env → ∀ k, envDraw env k ≤ envCap k)
    (x_crit_keep warnKeep H_safe_keep x₀_keep : ExtKeep → Nat)
    (obs_detects : ∀ x k, x k < warnKeep k → warnOuter (obsOuter x))
    (channel_fires : ∀ load env, jointAdm env → load ≤ (OpenComposition.composeContract cA cB).maxSilence →
      channel true load env = true)
    (G_keep_rises : ∀ k, RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (G_keep k))
    (keep_post_viable : ∀ k, x_crit_keep k ≤
      RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole G_keep H_safe_keep x_crit_keep k)
    (keep_post_allowance : ∀ k, (cA.postBudgetExt (Sum.inl k) + cB.postBudgetExt (Sum.inl k)) + envCap k ≤ H_safe_keep k)
    (keep_warn_margin : ∀ k,
      x_crit_keep k + (CoreHelpers.natMax cA.maxLag cB.maxLag + 1) *
        ((cA.preCapExt (Sum.inl k) + cB.preCapExt (Sum.inl k)) + envCap k) ≤ warnKeep k)
    (keep_init_margin : ∀ k,
      x_crit_keep k + CoreHelpers.natMax (cA.eta init₁) (cB.eta init₂) *
        ((cA.preCapExt (Sum.inl k) + cB.preCapExt (Sum.inl k)) + envCap k) ≤ x₀_keep k) :
    let AB := OpenComposition.OpenComponent.compose A B
    let cAB := OpenComposition.composeContract cA cB
    let H := OpenComposition.OpenComponent.hide AB G_hide wireObs
    let hC := OpenComposition.hideContract cAB G_hide wireObs tolOuter warnOuter
      x_crit_hide warnHide H_safe_hide x₀_hide tol_lifts G_hide_rises wire_outer_warn
      wire_hide_warn hide_post_viable hide_post_allowance hide_warn_margin hide_init_margin
    Viability.Kernel (OpenComposition.closedProcess H hC obsOuter channel G_keep envDraw jointAdm)
      (OpenComposition.closedGuard H hC x_crit_keep) (x₀_keep, ((init₁, init₂), x₀_hide)) ∧
    ∀ (r : Run (OpenComposition.closedProcess H hC obsOuter channel G_keep envDraw jointAdm)),
      r.state 0 = (x₀_keep, ((init₁, init₂), x₀_hide)) →
      ∀ t, (∀ j, x_crit_keep j ≤ (r.state t).1 j) ∧
           (∀ k, x_crit_hide k ≤ (r.state t).2.2 k) ∧
           (∀ k, A.drawExt (r.state t).2.1.1 (Sum.inr k) + B.drawExt (r.state t).2.1.2 (Sum.inr k) ≤
             cA.preCapExt (Sum.inr k) + cB.preCapExt (Sum.inr k)) := by
  intro AB cAB H hC
  have hViable := OpenComposition.close_contract_viable H hC obsOuter channel G_keep envDraw
    envCap jointAdm env_within x_crit_keep warnKeep H_safe_keep x₀_keep obs_detects
    channel_fires G_keep_rises keep_post_viable keep_post_allowance keep_warn_margin keep_init_margin
  refine ⟨hViable.2.kernel hViable.1, fun r hStart t => ?_⟩
  have hInv : ∀ s, OpenComposition.closedInv hC envCap x_crit_keep (r.state s) := by
    intro s
    induction s with
    | zero => rw [hStart]; exact hViable.1
    | succ s ih => exact hViable.2.closed (r.state s) (r.act s) (r.state (s + 1)) (r.step s) ih
  have hInvT := hInv t
  have hGuardT := hViable.2.within (r.state t) hInvT
  exact ⟨hGuardT.1,
    fun k => OpenComposition.hideContract_keeps_hidden hInvT.1 k,
    fun k => hGuardT.2.1 (Sum.inr k)⟩

/-- **Within-vs.-Between Selection Shift Theorem.**
Over equal-size groups `gs` (`whole gs = G.family t`, exact transmission): when lower-trait
groups leave zero offspring (`unintegrated_ends`) while surviving groups are trait-uniform
(`surviving_uniform`) and at least one gap pair reproduces (`some_gap`), within-group selection
is zero, among-group discordance is zero, among-group concordance is strictly positive, and
`G.Raises t` holds strictly via between-group selection. -/
theorem compositional_transition_shifts_selection {α : Type}
    (G : SelectionTerm.Generations α) {t m : Nat} (gs : List (List α))
    (listed : SelectionLevels.whole gs = G.family t)
    (equal : ∀ g, g ∈ gs → g.length = m)
    (exact : SelectionTerm.Exact (G.family t) (G.kids t) (G.amount t) (G.amount (t + 1)))
    (unintegrated_ends : ∀ g h, g ∈ gs → h ∈ gs →
      total h (G.amount t) < total g (G.amount t) → total h (G.offspringNumber t) = 0)
    (surviving_uniform : ∀ g, g ∈ gs → 0 < total g (G.offspringNumber t) →
      ∃ v, ∀ p, p ∈ g → G.amount t p = v)
    (some_gap : ∃ g h, g ∈ gs ∧ h ∈ gs ∧
      total h (G.amount t) < total g (G.amount t) ∧ 0 < total g (G.offspringNumber t)) :
    SelectionLevels.concordWithin gs (G.offspringNumber t) (G.amount t) = 0 ∧
    SelectionLevels.discordWithin gs (G.offspringNumber t) (G.amount t) = 0 ∧
    SelectionLevels.discordAmong gs (G.offspringNumber t) (G.amount t) = 0 ∧
    0 < SelectionLevels.concordAmong gs (G.offspringNumber t) (G.amount t) ∧
    G.Raises t := by
  have hConcordWithin : SelectionLevels.concordWithin gs (G.offspringNumber t) (G.amount t) = 0 := by
    refine total_eq_zero fun g mg => ?_
    match Nat.decEq (total g (G.offspringNumber t)) 0 with
    | isTrue hz =>
      exact SelectionTerm.concord_uniform
        (fun p mp => eq_zero_of_total_eq_zero hz p mp) (G.amount t)
    | isFalse hne =>
      obtain ⟨v, hSame⟩ := surviving_uniform g mg (Nat.pos_of_ne_zero hne)
      exact SelectionTerm.concord_alike hSame (G.offspringNumber t)
  have hDiscordWithin : SelectionLevels.discordWithin gs (G.offspringNumber t) (G.amount t) = 0 := by
    refine total_eq_zero fun g mg => ?_
    match Nat.decEq (total g (G.offspringNumber t)) 0 with
    | isTrue hz =>
      exact SelectionTerm.discord_uniform
        (fun p mp => eq_zero_of_total_eq_zero hz p mp) (G.amount t)
    | isFalse hne =>
      obtain ⟨v, hSame⟩ := surviving_uniform g mg (Nat.pos_of_ne_zero hne)
      exact SelectionTerm.discord_alike hSame (G.offspringNumber t)
  have hDiscordAmong : SelectionLevels.discordAmong gs (G.offspringNumber t) (G.amount t) = 0 :=
    GroupEnding.among_not_against unintegrated_ends
  have hConcordAmong : 0 < SelectionLevels.concordAmong gs (G.offspringNumber t) (G.amount t) := by
    obtain ⟨g, h, mg, mh, hLess, hPos⟩ := some_gap
    have hZero : total h (G.offspringNumber t) = 0 := unintegrated_ends g h mg mh hLess
    have hWLess : total h (G.offspringNumber t) < total g (G.offspringNumber t) :=
      hZero.symm ▸ hPos
    exact GroupEnding.pairs_pos mg mh
      (Nat.mul_pos (GroupEnding.excess_pos_of_lt hWLess) (GroupEnding.excess_pos_of_lt hLess))
  have hRaises : G.Raises t := by
    refine (SelectionLevels.rises_exact_iff_levels G gs listed equal exact).mpr ?_
    rw [hDiscordWithin, hConcordWithin, hDiscordAmong, Nat.mul_zero, Nat.zero_add, Nat.zero_add]
    exact hConcordAmong
  exact ⟨hConcordWithin, hDiscordWithin, hDiscordAmong, hConcordAmong, hRaises⟩

/-- **World-Level + Nested Sequestered Transition Theorem.**
Joins `Flow.family_excess_ends` + `GroupEnding.Flow.offspring_zero` with `Founding.Nested.raises_iff_among`:
when unintegrated wholes depend on an exhausted shared condition `ds` while at least one higher-trait
whole reproduces, and founding propagules are sequestered (`C.Sequestered`), selection across wholes
reduces strictly to among-group concordance (`C.wholes.Raises (T + n + k)`). -/
theorem nested_transition_raises_among {X : Type} {L : Flow X X} {W : Web X X}
    (balances : L.Balances W) (acting : L.Acting W) (dependent : W.Dependent)
    (C : Founding.Nested X) (founded : C.Founded) (sequestered : C.Sequestered)
    (descended : SelectionTerm.Flow.Descended L W C.wholes)
    {ds : List X} {m T n k : Nat}
    (gated : ∀ t f, f ∈ L.present t → ∀ d, d ∈ ds → 0 < L.give t f d →
      ∃ e, e ∈ ds ∧ W.requires t f e ∧ m ≤ W.need t f e)
    (excess : ∀ j, j < n → L.replenishment ds (T + j) < L.uptake ds (T + j))
    (start : W.stock ds T < n + m)
    (unintegrated_coupled : ∀ g h, g ∈ C.wholes.family (T + n + k) → h ∈ C.wholes.family (T + n + k) →
      C.wholes.amount (T + n + k) h < C.wholes.amount (T + n + k) g →
      ∃ e, e ∈ ds ∧ W.requires (T + n + k) h e ∧ m ≤ W.need (T + n + k) h e)
    (some_integrated_reproduces : ∃ g h, g ∈ C.wholes.family (T + n + k) ∧
      h ∈ C.wholes.family (T + n + k) ∧
      C.wholes.amount (T + n + k) h < C.wholes.amount (T + n + k) g ∧
      0 < C.wholes.offspringNumber (T + n + k) g) :
    C.wholes.discordAt (T + n + k) = 0 ∧
    0 < C.wholes.concordAt (T + n + k) ∧
    (C.wholes.Raises (T + n + k) ↔ C.wholes.discordAt (T + n + k) < C.wholes.concordAt (T + n + k)) ∧
    C.wholes.Raises (T + n + k) := by
  have hUnintZero : ∀ g h, g ∈ C.wholes.family (T + n + k) → h ∈ C.wholes.family (T + n + k) →
      C.wholes.amount (T + n + k) h < C.wholes.amount (T + n + k) g →
      C.wholes.offspringNumber (T + n + k) h = 0 := by
    intro g h mg mh hLess
    obtain ⟨e, inside, req, high⟩ := unintegrated_coupled g h mg mh hLess
    have hInact := Becoming.Flow.family_excess_ends balances acting dependent gated excess start k h e
      inside req high
    exact GroupEnding.Flow.offspring_zero acting descended mh hInact
  have hDisc : C.wholes.discordAt (T + n + k) = 0 :=
    SelectionTerm.discord_zero_of_below fun h g mh mg hLess =>
      Nat.le_trans (Nat.le_of_eq (hUnintZero g h mg mh hLess)) (Nat.zero_le _)
  have hConc : 0 < C.wholes.concordAt (T + n + k) := by
    obtain ⟨g, h, mg, mh, hLess, hPos⟩ := some_integrated_reproduces
    have hZero := hUnintZero g h mg mh hLess
    have hWLess : C.wholes.offspringNumber (T + n + k) h < C.wholes.offspringNumber (T + n + k) g :=
      hZero.symm ▸ hPos
    exact GroupEnding.pairs_pos mg mh
      (Nat.mul_pos (GroupEnding.excess_pos_of_lt hWLess) (GroupEnding.excess_pos_of_lt hLess))
  have hIff : C.wholes.Raises (T + n + k) ↔
      C.wholes.discordAt (T + n + k) < C.wholes.concordAt (T + n + k) :=
    Founding.Nested.raises_iff_among founded sequestered (T + n + k)
  have hRaises : C.wholes.Raises (T + n + k) := hIff.mpr (hDisc.symm ▸ hConc)
  exact ⟨hDisc, hConc, hIff, hRaises⟩

/-! ## Witness 1: `DerivedEmbodiedDrawWitness` -/

namespace DerivedEmbodiedDrawWitness

/-- Shared substrate and cohort locus for both `SurplusRun` and `SteadyRun`. -/
inductive Locus where
  | pool
  | poolRegen
  | member : Nat → Nat → Locus

/-- Shared bounded replenishment law (`FromNothing`, `Keeps giving 0 14`, capped at `R = 1`). -/
def giving (rem : Nat) : Nat :=
  if Nat.ble 2 rem && Nat.ble rem 13 then 1 else 0

theorem giving_from_nothing : RegimeMargin.FromNothing giving := rfl

theorem giving_cap (rem : Nat) : giving rem ≤ 1 := by
  unfold giving
  cases Nat.ble 2 rem && Nat.ble rem 13
  · exact Nat.zero_le 1
  · exact Nat.le_refl 1

theorem giving_keeps : RegimeMargin.Keeps giving 0 14 := by
  intro x hx
  change x - 0 + giving (x - 0) ≤ 14
  rw [Nat.sub_zero]
  match Nat.decEq x 14 with
  | isTrue h14 =>
    rw [h14]
    exact Nat.le_refl 14
  | isFalse hne =>
    have hle13 : x ≤ 13 :=
      Nat.le_of_lt_succ (Nat.lt_of_le_of_ne hx hne)
    exact Nat.le_trans (Nat.add_le_add_left (giving_cap x) x) (Nat.succ_le_succ hle13)

/-- Surplus pool stock trajectory: `13 → 12 → 9 → 1 → 0 → 0 ...`. -/
def surplusPoolLevel : Nat → Nat
  | 0 => 13
  | 1 => 12
  | 2 => 9
  | 3 => 1
  | _ + 4 => 0

/-- Surplus cohort kids: `.member 0 1` leaves 2 kids, each `.member 1 i` and `.member 2 i` leaves 2
distinct kids; `.member 0 0` and step ≥ 3 leave none. -/
def surplusKids (t : Nat) (p : Locus) : List Locus :=
  match p with
  | .member s i =>
    match t with
    | 0 => match s, i with
      | 0, 1 => [.member 1 0, .member 1 1]
      | _, _ => []
    | 1 => match s with
      | 1 => if Nat.ble i 1 then [.member 2 (2 * i), .member 2 (2 * i + 1)] else []
      | _ => []
    | 2 => match s with
      | 2 => if Nat.ble i 3 then [.member 3 (2 * i), .member 3 (2 * i + 1)] else []
      | _ => []
    | _ + 3 => []
  | .pool => []
  | .poolRegen => []

/-- Trait amount on `SurplusRun`: `.member 0 0` carries `0`, active members at `0, 1, 2` carry `2`,
and `t = 3` carries `2` (for exact transmission across step 2) with zero offspring at `t = 3`. -/
def surplusAmount (t : Nat) (x : Locus) : Nat :=
  match x with
  | .member s i =>
    match t with
    | 0 => match s, i with
      | 0, 0 => 0
      | _, _ => 2
    | _ + 1 => 2
  | .pool => 0
  | .poolRegen => 0

def surplusGen : SelectionTerm.Generations Locus where
  first := [.member 0 0, .member 0 1]
  kids := surplusKids
  amount := surplusAmount

/-- Active exchanger list on `SurplusRun` at each step. -/
def surplusPresent : Nat → List Locus
  | 0 => [.poolRegen, .member 0 1]
  | 1 => [.poolRegen, .member 1 0, .member 1 1]
  | 2 => [.poolRegen, .member 2 0, .member 2 1, .member 2 2, .member 2 3]
  | 3 => [.member 3 0, .member 3 1, .member 3 2, .member 3 3,
          .member 3 4, .member 3 5, .member 3 6, .member 3 7]
  | _ + 4 => []

def surplusLevel (t : Nat) (x : Locus) : Nat :=
  match x with
  | .pool => surplusPoolLevel t
  | .poolRegen => 0
  | .member s i =>
    match t with
    | 0 => match s, i with
      | 0, 1 => 1
      | _, _ => 0
    | 1 => match s with
      | 1 => if Nat.ble i 1 then 1 else 0
      | _ => 0
    | 2 => match s with
      | 2 => if Nat.ble i 3 then 1 else 0
      | _ => 0
    | 3 => match s with
      | 3 => if Nat.ble i 7 then 1 else 0
      | _ => 0
    | _ + 4 => 0

def surplusActive (t : Nat) (x : Locus) : Prop :=
  match x with
  | .pool => False
  | .poolRegen => match t with | 0 => True | 1 => True | _ => False
  | .member _ _ => 0 < surplusLevel t x

def surplusRequires (t : Nat) (f c : Locus) : Prop :=
  match f with
  | .poolRegen => match c with
    | .pool => match t with | 0 => True | 1 => True | _ => False
    | .poolRegen => False
    | .member _ _ => False
  | .member s i => match c with
    | .pool =>
      match t with
      | 0 => match s, i with | 0, 0 => False | 0, 1 => True | _, _ => False
      | 1 => s = 1 ∧ i ≤ 1
      | 2 => s = 2 ∧ i ≤ 3
      | 3 => s = 3 ∧ i ≤ 7
      | _ + 4 => False
    | .poolRegen =>
      match t, s, i with
      | 0, 0, 0 => True
      | _, _, _ => False
    | .member _ _ => False
  | .pool => False

def surplusNeed (_ : Nat) (_ _ : Locus) : Nat := 1

def surplusDraws (t : Nat) (f c : Locus) : Prop :=
  match f with
  | .member s i => match c with
    | .pool => surplusRequires t (.member s i) .pool ∧ 0 < surplusLevel t (.member s i)
    | .member s' i' => s = s' ∧ i = i' ∧ 0 < surplusLevel t (.member s i)
    | .poolRegen => False
  | .pool => False
  | .poolRegen => False

def surplusWeb : Web Locus Locus where
  level := surplusLevel
  active := surplusActive
  requires := surplusRequires
  need := surplusNeed
  draws := surplusDraws

/-- Unclamped `Flow` for `SurplusRun` using single-argument exhaustive matches on `Locus`. -/
def surplusFlow : Flow Locus Locus where
  present := surplusPresent
  take t f c :=
    match f with
    | .member s i =>
      match c with
      | .pool =>
        match t with
        | 0 => match s, i with | 0, 1 => 2 | _, _ => 0
        | 1 => match s with | 1 => if Nat.ble i 1 then 2 else 0 | _ => 0
        | 2 => match s with | 2 => if Nat.ble i 3 then 2 else 0 | _ => 0
        | 3 => match s, i with | 3, 0 => 1 | _, _ => 0
        | _ + 4 => 0
      | .member s' i' =>
        if Nat.beq s s' && Nat.beq i i' && Nat.ble 1 (surplusLevel t (.member s i)) then 1 else 0
      | .poolRegen => 0
    | .pool => 0
    | .poolRegen => 0
  give t f c :=
    match f with
    | .poolRegen =>
      match c with
      | .pool =>
        match t with
        | 0 => giving 11
        | 1 => giving 8
        | _ + 2 => 0
      | .poolRegen => 0
      | .member _ _ => 0
    | .member s i =>
      match c with
      | .member s' i' =>
        match t with
        | 0 => match s, i, s' with
          | 0, 1, 1 => if Nat.ble i' 1 then 1 else 0
          | _, _, _ => 0
        | 1 => match s, s' with
          | 1, 2 => if Nat.ble i 1 && (Nat.beq i' (2 * i) || Nat.beq i' (2 * i + 1)) then 1 else 0
          | _, _ => 0
        | 2 => match s, s' with
          | 2, 3 => if Nat.ble i 3 && (Nat.beq i' (2 * i) || Nat.beq i' (2 * i + 1)) then 1 else 0
          | _, _ => 0
        | _ + 3 => 0
      | .pool => 0
      | .poolRegen => 0
    | .pool => 0

theorem surplus_pool_balance (t : Nat) :
    surplusWeb.level (t + 1) .pool + surplusFlow.taken t .pool =
      surplusWeb.level t .pool + surplusFlow.given t .pool :=
  match t with
  | 0 => rfl
  | 1 => rfl
  | 2 => rfl
  | 3 => rfl
  | _ + 4 => rfl

theorem surplus_member_balance (t s i : Nat) :
    surplusWeb.level (t + 1) (.member s i) + surplusFlow.taken t (.member s i) =
      surplusWeb.level t (.member s i) + surplusFlow.given t (.member s i) := by
  match t with
  | 0 =>
    match s with
    | 0 =>
      match i with
      | 0 => rfl
      | 1 => rfl
      | _ + 2 => rfl
    | 1 =>
      match i with
      | 0 => rfl
      | 1 => rfl
      | _ + 2 => rfl
    | _ + 2 => rfl
  | 1 =>
    match s with
    | 0 => rfl
    | 1 =>
      match i with
      | 0 => rfl
      | 1 => rfl
      | _ + 2 => rfl
    | 2 =>
      match i with
      | 0 => rfl | 1 => rfl | 2 => rfl | 3 => rfl | _ + 4 => rfl
    | _ + 3 => rfl
  | 2 =>
    match s with
    | 0 => rfl
    | 1 => rfl
    | 2 =>
      match i with
      | 0 => rfl | 1 => rfl | 2 => rfl | 3 => rfl | _ + 4 => rfl
    | 3 =>
      match i with
      | 0 => rfl | 1 => rfl | 2 => rfl | 3 => rfl
      | 4 => rfl | 5 => rfl | 6 => rfl | 7 => rfl | _ + 8 => rfl
    | _ + 4 => rfl
  | 3 =>
    match s with
    | 0 => rfl | 1 => rfl | 2 => rfl
    | 3 =>
      match i with
      | 0 => rfl | 1 => rfl | 2 => rfl | 3 => rfl
      | 4 => rfl | 5 => rfl | 6 => rfl | 7 => rfl | _ + 8 => rfl
    | _ + 4 => rfl
  | _ + 4 => rfl

theorem surplus_balances : surplusFlow.Balances surplusWeb := by
  intro t c
  cases c with
  | pool => exact surplus_pool_balance t
  | poolRegen => match t with | 0 => rfl | 1 => rfl | 2 => rfl | 3 => rfl | _ + 4 => rfl
  | member s i => exact surplus_member_balance t s i

theorem surplus_acting : surplusFlow.Acting surplusWeb := by
  intro t f c hf hpos
  match t with
  | 0 =>
    match mem_cons_cases hf with
    | .inl h => rw [h]; trivial
    | .inr hf' => match mem_cons_cases hf' with
      | .inl h => rw [h]; exact Nat.zero_lt_one
      | .inr no => nomatch no
  | 1 =>
    match mem_cons_cases hf with
    | .inl h => rw [h]; trivial
    | .inr hf' => match mem_cons_cases hf' with
      | .inl h => rw [h]; exact Nat.zero_lt_one
      | .inr hf'' => match mem_cons_cases hf'' with
        | .inl h => rw [h]; exact Nat.zero_lt_one
        | .inr no => nomatch no
  | 2 =>
    match mem_cons_cases hf with
    | .inl h =>
      rw [h] at hpos
      cases c with
      | pool => exact absurd hpos (Nat.lt_irrefl 0)
      | poolRegen => exact absurd hpos (Nat.lt_irrefl 0)
      | member _ _ => exact absurd hpos (Nat.lt_irrefl 0)
    | .inr hf1 => match mem_cons_cases hf1 with
      | .inl h => rw [h]; exact Nat.zero_lt_one
      | .inr hf2 => match mem_cons_cases hf2 with
        | .inl h => rw [h]; exact Nat.zero_lt_one
        | .inr hf3 => match mem_cons_cases hf3 with
          | .inl h => rw [h]; exact Nat.zero_lt_one
          | .inr hf4 => match mem_cons_cases hf4 with
            | .inl h => rw [h]; exact Nat.zero_lt_one
            | .inr no => nomatch no
  | 3 =>
    cases c with
    | pool =>
      match mem_cons_cases hf with
      | .inl h => rw [h] at hpos; exact absurd hpos (Nat.lt_irrefl 0)
      | .inr hf1 => match mem_cons_cases hf1 with
        | .inl h => rw [h] at hpos; exact absurd hpos (Nat.lt_irrefl 0)
        | .inr hf2 => match mem_cons_cases hf2 with
          | .inl h => rw [h] at hpos; exact absurd hpos (Nat.lt_irrefl 0)
          | .inr hf3 => match mem_cons_cases hf3 with
            | .inl h => rw [h] at hpos; exact absurd hpos (Nat.lt_irrefl 0)
            | .inr hf4 => match mem_cons_cases hf4 with
              | .inl h => rw [h] at hpos; exact absurd hpos (Nat.lt_irrefl 0)
              | .inr hf5 => match mem_cons_cases hf5 with
                | .inl h => rw [h] at hpos; exact absurd hpos (Nat.lt_irrefl 0)
                | .inr hf6 => match mem_cons_cases hf6 with
                  | .inl h => rw [h] at hpos; exact absurd hpos (Nat.lt_irrefl 0)
                  | .inr hf7 => match mem_cons_cases hf7 with
                    | .inl h => rw [h] at hpos; exact absurd hpos (Nat.lt_irrefl 0)
                    | .inr no => nomatch no
    | poolRegen =>
      match mem_cons_cases hf with
      | .inl h => rw [h] at hpos; exact absurd hpos (Nat.lt_irrefl 0)
      | .inr hf1 => match mem_cons_cases hf1 with
        | .inl h => rw [h] at hpos; exact absurd hpos (Nat.lt_irrefl 0)
        | .inr hf2 => match mem_cons_cases hf2 with
          | .inl h => rw [h] at hpos; exact absurd hpos (Nat.lt_irrefl 0)
          | .inr hf3 => match mem_cons_cases hf3 with
            | .inl h => rw [h] at hpos; exact absurd hpos (Nat.lt_irrefl 0)
            | .inr hf4 => match mem_cons_cases hf4 with
              | .inl h => rw [h] at hpos; exact absurd hpos (Nat.lt_irrefl 0)
              | .inr hf5 => match mem_cons_cases hf5 with
                | .inl h => rw [h] at hpos; exact absurd hpos (Nat.lt_irrefl 0)
                | .inr hf6 => match mem_cons_cases hf6 with
                  | .inl h => rw [h] at hpos; exact absurd hpos (Nat.lt_irrefl 0)
                  | .inr hf7 => match mem_cons_cases hf7 with
                    | .inl h => rw [h] at hpos; exact absurd hpos (Nat.lt_irrefl 0)
                    | .inr no => nomatch no
    | member _ _ =>
      match mem_cons_cases hf with
      | .inl h => rw [h] at hpos; exact absurd hpos (Nat.lt_irrefl 0)
      | .inr hf1 => match mem_cons_cases hf1 with
        | .inl h => rw [h] at hpos; exact absurd hpos (Nat.lt_irrefl 0)
        | .inr hf2 => match mem_cons_cases hf2 with
          | .inl h => rw [h] at hpos; exact absurd hpos (Nat.lt_irrefl 0)
          | .inr hf3 => match mem_cons_cases hf3 with
            | .inl h => rw [h] at hpos; exact absurd hpos (Nat.lt_irrefl 0)
            | .inr hf4 => match mem_cons_cases hf4 with
              | .inl h => rw [h] at hpos; exact absurd hpos (Nat.lt_irrefl 0)
              | .inr hf5 => match mem_cons_cases hf5 with
                | .inl h => rw [h] at hpos; exact absurd hpos (Nat.lt_irrefl 0)
                | .inr hf6 => match mem_cons_cases hf6 with
                  | .inl h => rw [h] at hpos; exact absurd hpos (Nat.lt_irrefl 0)
                  | .inr hf7 => match mem_cons_cases hf7 with
                    | .inl h => rw [h] at hpos; exact absurd hpos (Nat.lt_irrefl 0)
                    | .inr no => nomatch no
  | _ + 4 => nomatch hf

theorem surplus_dependent : surplusWeb.Dependent := by
  intro t f hAct c hReq
  cases f with
  | pool => exact False.elim hAct
  | poolRegen =>
    cases c with
    | pool =>
      match t with
      | 0 => exact by decide
      | 1 => exact by decide
      | _ + 2 => exact False.elim hReq
    | poolRegen => exact False.elim hReq
    | member _ _ => exact False.elim hReq
  | member s i =>
    cases c with
    | poolRegen =>
      match t, s, i with
      | 0, 0, 0 => exact absurd hAct (Nat.lt_irrefl 0)
      | 0, 0, _ + 1 => exact False.elim hReq
      | 0, _ + 1, _ => exact False.elim hReq
      | _ + 1, _, _ => exact False.elim hReq
    | member _ _ => exact False.elim hReq
    | pool =>
      match t with
      | 0 =>
        match s, i with
        | 0, 1 => exact by decide
        | 0, 0 => exact False.elim hReq
        | 0, _ + 2 => exact False.elim hReq
        | _ + 1, _ => exact False.elim hReq
      | 1 =>
        obtain ⟨_, _⟩ := hReq
        exact (by decide : 1 ≤ 12)
      | 2 =>
        obtain ⟨_, _⟩ := hReq
        exact (by decide : 1 ≤ 9)
      | 3 =>
        obtain ⟨_, _⟩ := hReq
        exact Nat.le_refl 1
      | _ + 4 => exact False.elim hReq

theorem surplus_family_0 : surplusGen.family 0 = [.member 0 0, .member 0 1] := rfl
theorem surplus_family_1 : surplusGen.family 1 = [.member 1 0, .member 1 1] := rfl
theorem surplus_family_2 : surplusGen.family 2 = [.member 2 0, .member 2 1, .member 2 2, .member 2 3] := rfl
theorem surplus_family_3 : surplusGen.family 3 =
    [.member 3 0, .member 3 1, .member 3 2, .member 3 3,
     .member 3 4, .member 3 5, .member 3 6, .member 3 7] := rfl
theorem surplus_family_4 : surplusGen.family 4 = [] := rfl

theorem surplus_family_later : ∀ n, surplusGen.family (4 + n) = []
  | 0 => surplus_family_4
  | n + 1 => by
    change (surplusGen.family (4 + n)).flatMap (surplusKids (4 + n)) = []
    rw [surplus_family_later n]
    rfl

theorem surplus_conv : EmbodiedConversion surplusFlow surplusWeb surplusGen [.pool] 1 where
  pos_floor := Nat.zero_lt_one
  descended := by
    intro t p k mp mk
    match t with
    | 0 =>
      match mem_cons_cases mp with
      | .inl hp => subst hp; nomatch mk
      | .inr mp' => match mem_cons_cases mp' with
        | .inl hp =>
          subst hp
          match mem_cons_cases mk with
          | .inl hk => subst hk; exact ⟨.tail _ (.head _), Nat.zero_lt_one, Nat.lt_irrefl 0, Nat.zero_lt_one⟩
          | .inr mk' => match mem_cons_cases mk' with
            | .inl hk => subst hk; exact ⟨.tail _ (.head _), Nat.zero_lt_one, Nat.lt_irrefl 0, Nat.zero_lt_one⟩
            | .inr no => nomatch no
        | .inr no => nomatch no
    | 1 =>
      rw [surplus_family_1] at mp
      match mem_cons_cases mp with
      | .inl hp =>
        subst hp
        match mem_cons_cases mk with
        | .inl hk => subst hk; exact ⟨.tail _ (.head _), Nat.zero_lt_one, Nat.lt_irrefl 0, Nat.zero_lt_one⟩
        | .inr mk' => match mem_cons_cases mk' with
          | .inl hk => subst hk; exact ⟨.tail _ (.head _), Nat.zero_lt_one, Nat.lt_irrefl 0, Nat.zero_lt_one⟩
          | .inr no => nomatch no
      | .inr mp' => match mem_cons_cases mp' with
        | .inl hp =>
          subst hp
          match mem_cons_cases mk with
          | .inl hk => subst hk; exact ⟨.tail _ (.tail _ (.head _)), Nat.zero_lt_one, Nat.lt_irrefl 0, Nat.zero_lt_one⟩
          | .inr mk' => match mem_cons_cases mk' with
            | .inl hk => subst hk; exact ⟨.tail _ (.tail _ (.head _)), Nat.zero_lt_one, Nat.lt_irrefl 0, Nat.zero_lt_one⟩
            | .inr no => nomatch no
        | .inr no => nomatch no
    | 2 =>
      rw [surplus_family_2] at mp
      match mem_cons_cases mp with
      | .inl hp =>
        subst hp
        match mem_cons_cases mk with
        | .inl hk => subst hk; exact ⟨.tail _ (.head _), Nat.zero_lt_one, Nat.lt_irrefl 0, Nat.zero_lt_one⟩
        | .inr mk' => match mem_cons_cases mk' with
          | .inl hk => subst hk; exact ⟨.tail _ (.head _), Nat.zero_lt_one, Nat.lt_irrefl 0, Nat.zero_lt_one⟩
          | .inr no => nomatch no
      | .inr mp1 => match mem_cons_cases mp1 with
        | .inl hp =>
          subst hp
          match mem_cons_cases mk with
          | .inl hk => subst hk; exact ⟨.tail _ (.tail _ (.head _)), Nat.zero_lt_one, Nat.lt_irrefl 0, Nat.zero_lt_one⟩
          | .inr mk' => match mem_cons_cases mk' with
            | .inl hk => subst hk; exact ⟨.tail _ (.tail _ (.head _)), Nat.zero_lt_one, Nat.lt_irrefl 0, Nat.zero_lt_one⟩
            | .inr no => nomatch no
        | .inr mp2 => match mem_cons_cases mp2 with
          | .inl hp =>
            subst hp
            match mem_cons_cases mk with
            | .inl hk => subst hk; exact ⟨.tail _ (.tail _ (.tail _ (.head _))), Nat.zero_lt_one, Nat.lt_irrefl 0, Nat.zero_lt_one⟩
            | .inr mk' => match mem_cons_cases mk' with
              | .inl hk => subst hk; exact ⟨.tail _ (.tail _ (.tail _ (.head _))), Nat.zero_lt_one, Nat.lt_irrefl 0, Nat.zero_lt_one⟩
              | .inr no => nomatch no
          | .inr mp3 => match mem_cons_cases mp3 with
            | .inl hp =>
              subst hp
              match mem_cons_cases mk with
              | .inl hk => subst hk; exact ⟨.tail _ (.tail _ (.tail _ (.tail _ (.head _)))), Nat.zero_lt_one, Nat.lt_irrefl 0, Nat.zero_lt_one⟩
              | .inr mk' => match mem_cons_cases mk' with
                | .inl hk => subst hk; exact ⟨.tail _ (.tail _ (.tail _ (.tail _ (.head _)))), Nat.zero_lt_one, Nat.lt_irrefl 0, Nat.zero_lt_one⟩
                | .inr no => nomatch no
            | .inr no => nomatch no
    | 3 =>
      rw [surplus_family_3] at mp
      match mem_cons_cases mp with
      | .inl hp => subst hp; nomatch mk
      | .inr mp1 => match mem_cons_cases mp1 with
        | .inl hp => subst hp; nomatch mk
        | .inr mp2 => match mem_cons_cases mp2 with
          | .inl hp => subst hp; nomatch mk
          | .inr mp3 => match mem_cons_cases mp3 with
            | .inl hp => subst hp; nomatch mk
            | .inr mp4 => match mem_cons_cases mp4 with
              | .inl hp => subst hp; nomatch mk
              | .inr mp5 => match mem_cons_cases mp5 with
                | .inl hp => subst hp; nomatch mk
                | .inr mp6 => match mem_cons_cases mp6 with
                  | .inl hp => subst hp; nomatch mk
                  | .inr mp7 => match mem_cons_cases mp7 with
                    | .inl hp => subst hp; nomatch mk
                    | .inr no => nomatch no
    | n + 4 =>
      rw [Nat.add_comm n 4, surplus_family_later n] at mp
      nomatch mp
  embodied_floor := by
    intro t p k mp mk
    match t with
    | 0 =>
      match mem_cons_cases mp with
      | .inl hp => subst hp; nomatch mk
      | .inr mp' => match mem_cons_cases mp' with
        | .inl hp =>
          subst hp
          match mem_cons_cases mk with
          | .inl hk => subst hk; exact Nat.le_refl 1
          | .inr mk' => match mem_cons_cases mk' with
            | .inl hk => subst hk; exact Nat.le_refl 1
            | .inr no => nomatch no
        | .inr no => nomatch no
    | 1 =>
      rw [surplus_family_1] at mp
      match mem_cons_cases mp with
      | .inl hp =>
        subst hp
        match mem_cons_cases mk with
        | .inl hk => subst hk; exact Nat.le_refl 1
        | .inr mk' => match mem_cons_cases mk' with
          | .inl hk => subst hk; exact Nat.le_refl 1
          | .inr no => nomatch no
      | .inr mp' => match mem_cons_cases mp' with
        | .inl hp =>
          subst hp
          match mem_cons_cases mk with
          | .inl hk => subst hk; exact Nat.le_refl 1
          | .inr mk' => match mem_cons_cases mk' with
            | .inl hk => subst hk; exact Nat.le_refl 1
            | .inr no => nomatch no
        | .inr no => nomatch no
    | 2 =>
      rw [surplus_family_2] at mp
      match mem_cons_cases mp with
      | .inl hp =>
        subst hp
        match mem_cons_cases mk with
        | .inl hk => subst hk; exact Nat.le_refl 1
        | .inr mk' => match mem_cons_cases mk' with
          | .inl hk => subst hk; exact Nat.le_refl 1
          | .inr no => nomatch no
      | .inr mp1 => match mem_cons_cases mp1 with
        | .inl hp =>
          subst hp
          match mem_cons_cases mk with
          | .inl hk => subst hk; exact Nat.le_refl 1
          | .inr mk' => match mem_cons_cases mk' with
            | .inl hk => subst hk; exact Nat.le_refl 1
            | .inr no => nomatch no
        | .inr mp2 => match mem_cons_cases mp2 with
          | .inl hp =>
            subst hp
            match mem_cons_cases mk with
            | .inl hk => subst hk; exact Nat.le_refl 1
            | .inr mk' => match mem_cons_cases mk' with
              | .inl hk => subst hk; exact Nat.le_refl 1
              | .inr no => nomatch no
          | .inr mp3 => match mem_cons_cases mp3 with
            | .inl hp =>
              subst hp
              match mem_cons_cases mk with
              | .inl hk => subst hk; exact Nat.le_refl 1
              | .inr mk' => match mem_cons_cases mk' with
                | .inl hk => subst hk; exact Nat.le_refl 1
                | .inr no => nomatch no
            | .inr no => nomatch no
    | 3 =>
      rw [surplus_family_3] at mp
      match mem_cons_cases mp with
      | .inl hp => subst hp; nomatch mk
      | .inr mp1 => match mem_cons_cases mp1 with
        | .inl hp => subst hp; nomatch mk
        | .inr mp2 => match mem_cons_cases mp2 with
          | .inl hp => subst hp; nomatch mk
          | .inr mp3 => match mem_cons_cases mp3 with
            | .inl hp => subst hp; nomatch mk
            | .inr mp4 => match mem_cons_cases mp4 with
              | .inl hp => subst hp; nomatch mk
              | .inr mp5 => match mem_cons_cases mp5 with
                | .inl hp => subst hp; nomatch mk
                | .inr mp6 => match mem_cons_cases mp6 with
                  | .inl hp => subst hp; nomatch mk
                  | .inr mp7 => match mem_cons_cases mp7 with
                    | .inl hp => subst hp; nomatch mk
                    | .inr no => nomatch no
    | n + 4 =>
      rw [Nat.add_comm n 4, surplus_family_later n] at mp
      nomatch mp
  balances_offspring := fun t => surplus_balances.on (surplusGen.family (t + 1)) t
  conversion := by
    intro t f hf
    match t with
    | 0 =>
      match mem_cons_cases hf with
      | .inl h => rw [h]; exact Nat.zero_le _
      | .inr hf' => match mem_cons_cases hf' with
        | .inl h => rw [h]; exact Nat.le_refl 2
        | .inr no => nomatch no
    | 1 =>
      match mem_cons_cases hf with
      | .inl h => rw [h]; exact Nat.zero_le _
      | .inr hf' => match mem_cons_cases hf' with
        | .inl h => rw [h]; exact Nat.le_refl 2
        | .inr hf'' => match mem_cons_cases hf'' with
          | .inl h => rw [h]; exact Nat.le_refl 2
          | .inr no => nomatch no
    | 2 =>
      match mem_cons_cases hf with
      | .inl h => rw [h]; exact Nat.zero_le _
      | .inr hf1 => match mem_cons_cases hf1 with
        | .inl h => rw [h]; exact Nat.le_refl 2
        | .inr hf2 => match mem_cons_cases hf2 with
          | .inl h => rw [h]; exact Nat.le_refl 2
          | .inr hf3 => match mem_cons_cases hf3 with
            | .inl h => rw [h]; exact Nat.le_refl 2
            | .inr hf4 => match mem_cons_cases hf4 with
              | .inl h => rw [h]; exact Nat.le_refl 2
              | .inr no => nomatch no
    | 3 =>
      rw [surplus_family_4]
      exact Nat.zero_le _
    | _ + 4 => nomatch hf

theorem surplus_rep_cap (t : Nat) : surplusFlow.replenishment [.pool] t ≤ 1 := by
  match t with
  | 0 => exact giving_cap 11
  | 1 => exact giving_cap 8
  | 2 => exact Nat.zero_le 1
  | 3 => exact Nat.zero_le 1
  | _ + 4 => exact Nat.zero_le 1

/-- Verified properties of `SurplusRun`:
- derived cohort uptake (`2 ≤ 2 → 4 ≤ 4 → 8 ≤ 8`),
- selection surplus (`2 < 4 < 8`),
- impossibility of persisting past `T_ex + x₃ = 4` (`embodied_selection_surplus_impossible_past`),
- concrete crash `x₄ = 0`, `size 4 = 0`. -/
theorem surplus_run_verified :
    (surplusGen.size 1 * 1 ≤ surplusFlow.uptake [.pool] 0 ∧
     surplusGen.size 2 * 1 ≤ surplusFlow.uptake [.pool] 1 ∧
     surplusGen.size 3 * 1 ≤ surplusFlow.uptake [.pool] 2) ∧
    (surplusGen.size 1 < surplusGen.size 2 ∧ surplusGen.size 2 < surplusGen.size 3) ∧
    (¬ (∀ t, t ≤ 1 + (1 + 1) + surplusWeb.stock [.pool] (1 + (1 + 1)) →
        (∀ p, p ∈ surplusGen.family t → surplusGen.amount t p = surplusGen.offspringNumber t p) ∧
        (∀ p, p ∈ surplusGen.family t → surplusWeb.Supported t p →
          ∀ q, q ∈ surplusGen.family t → surplusGen.amount t q ≤ surplusGen.amount t p) ∧
        SelectionTerm.Exact (surplusGen.family t) (surplusGen.kids t) (surplusGen.amount t)
          (surplusGen.amount (t + 1)))) ∧
    surplusWeb.level 4 .pool = 0 ∧ surplusGen.size 4 = 0 := by
  have hImp := embodied_selection_surplus_impossible_past surplus_balances surplus_acting
    surplus_dependent surplus_conv surplus_rep_cap (Nat.le_refl 2) (T := 1)
    (by decide : 2 * 4 ≠ 2 * 2)
  exact ⟨⟨derived_cohort_uptake_ge surplus_conv 0,
      derived_cohort_uptake_ge surplus_conv 1,
      derived_cohort_uptake_ge surplus_conv 2⟩,
    ⟨by decide, by decide⟩,
    hImp,
    rfl, rfl⟩

/-- Branch B (`SteadyRun`): self-limiting replacement (`1` kid per step) persists at `level = 13`. -/
def steadyKids (t : Nat) (p : Locus) : List Locus :=
  match p with
  | .member s i =>
    match t with
    | 0 => match s, i with
      | 0, 1 => [.member 1 0]
      | _, _ => []
    | t' + 1 =>
      if Nat.beq s (t' + 1) && Nat.beq i 0 then [.member (t' + 2) 0] else []
  | .pool => []
  | .poolRegen => []

def steadyGen : SelectionTerm.Generations Locus where
  first := [.member 0 0, .member 0 1]
  kids := steadyKids
  amount _ p := match p with
    | .pool => 1
    | .poolRegen => 1
    | .member s i => match s with
      | 0 => match i with | 0 => 0 | _ + 1 => 1
      | _ + 1 => 1

def steadyPresent (t : Nat) : List Locus :=
  [.poolRegen, .member t (if Nat.ble t 0 then 1 else 0)]

def steadyLevel (t : Nat) (x : Locus) : Nat :=
  match x with
  | .pool => 13
  | .poolRegen => 0
  | .member s i =>
    match t with
    | 0 => match s with
      | 0 => match i with | 1 => 1 | 0 => 0 | _ + 2 => 0
      | _ + 1 => 0
    | t' + 1 => if Nat.beq s (t' + 1) && Nat.beq i 0 then 1 else 0

def steadyWeb : Web Locus Locus where
  level := steadyLevel
  active t x := match x with
    | .pool => False
    | .poolRegen => True
    | .member s i => 0 < steadyLevel t (.member s i)
  requires t f c := match f with
    | .poolRegen => match c with
      | .pool => True
      | .poolRegen => False
      | .member _ _ => False
    | .member s i => match c with
      | .pool => match t with
        | 0 => match s with
          | 0 => match i with | 1 => True | 0 => False | _ + 2 => False
          | _ + 1 => False
        | t' + 1 => s = t' + 1 ∧ i = 0
      | .poolRegen => match t with
        | 0 => match s with
          | 0 => match i with | 0 => True | _ + 1 => False
          | _ + 1 => False
        | _ + 1 => False
      | .member _ _ => False
    | .pool => False
  need _ _ _ := 1
  draws t f c := match f with
    | .member s i => match c with
      | .pool => 0 < steadyLevel t (.member s i)
      | .member s' i' => s = s' ∧ i = i' ∧ 0 < steadyLevel t (.member s i)
      | .poolRegen => False
    | .pool => False
    | .poolRegen => False

def steadyFlow : Flow Locus Locus where
  present := steadyPresent
  take t f c :=
    match f with
    | .member s i =>
      match c with
      | .pool =>
        match t with
        | 0 => match s with
          | 0 => match i with | 1 => 1 | 0 => 0 | _ + 2 => 0
          | _ + 1 => 0
        | t' + 1 => if Nat.beq s (t' + 1) && Nat.beq i 0 then 1 else 0
      | .member s' i' =>
        if Nat.beq s s' && Nat.beq i i' && Nat.ble 1 (steadyLevel t (.member s i)) then 1 else 0
      | .poolRegen => 0
    | .pool => 0
    | .poolRegen => 0
  give t f c :=
    match f with
    | .poolRegen => match c with
      | .pool => giving 12
      | .poolRegen => 0
      | .member _ _ => 0
    | .member s i =>
      match c with
      | .member s' i' =>
        match t with
        | 0 =>
          if Nat.beq s 0 && Nat.beq i 1 && Nat.beq s' 1 && Nat.beq i' 0 then 1 else 0
        | t' + 1 =>
          if Nat.beq s (t' + 1) && Nat.beq i 0 && Nat.beq s' (t' + 2) && Nat.beq i' 0 then 1 else 0
      | .pool => 0
      | .poolRegen => 0
    | .pool => 0

theorem steady_family_succ : ∀ t, steadyGen.family (t + 1) = [.member (t + 1) 0]
  | 0 => rfl
  | t + 1 => by
    change (steadyGen.family (t + 1)).flatMap (steadyKids (t + 1)) = [.member (t + 2) 0]
    rw [steady_family_succ t]
    show ([.member (t + 1) 0]).flatMap (steadyKids (t + 1)) = [.member (t + 2) 0]
    have hb : (Nat.beq (t + 1) (t + 1) && Nat.beq 0 0) = true := by
      rw [beq_self (t + 1)]; rfl
    show (if Nat.beq (t + 1) (t + 1) && Nat.beq 0 0 then [Locus.member (t + 2) 0] else []) ++ [] =
      [Locus.member (t + 2) 0]
    rw [hb]
    rfl

theorem steady_balances_pool (t : Nat) :
    steadyWeb.level (t + 1) .pool + steadyFlow.taken t .pool =
      steadyWeb.level t .pool + steadyFlow.given t .pool := by
  match t with
  | 0 => rfl
  | t' + 1 =>
    have hb : (Nat.beq (t' + 1) (t' + 1) && Nat.beq 0 0) = true := by
      rw [beq_self (t' + 1)]; rfl
    show 13 + (0 + ((if Nat.beq (t' + 1) (t' + 1) && Nat.beq 0 0 then 1 else 0) + 0)) =
        13 + (giving 12 + (0 + 0))
    rw [hb]
    rfl

theorem steady_run_verified : ∀ t,
    steadyWeb.level t .pool = 13 ∧ steadyGen.size (t + 1) = 1 ∧
    steadyWeb.level (t + 1) .pool + steadyFlow.taken t .pool =
      steadyWeb.level t .pool + steadyFlow.given t .pool := by
  intro t
  exact ⟨rfl, congrArg List.length (steady_family_succ t), steady_balances_pool t⟩

end DerivedEmbodiedDrawWitness

/-! ## Witness 2: `MultiSiteBridgeWitness` -/

namespace MultiSiteBridgeWitness

/-- Coupled 2-site substrate `G`: both sites regenerate `1` when at least `1` unit remains after draw. -/
def twoSiteG (k : Bool) (e : Bool → Nat) : Nat :=
  if Nat.ble 1 (e k) then 1 else 0

theorem twoSiteG_rises : ∀ k, RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (twoSiteG k) := by
  intro k e e' hle
  show (if Nat.ble 1 (e k) then 1 else 0) ≤ (if Nat.ble 1 (e' k) then 1 else 0)
  cases h1 : Nat.ble 1 (e k)
  · exact Nat.zero_le _
  · have h2 : Nat.ble 1 (e' k) = true :=
      Nat.ble_eq_true_of_le (Nat.le_trans (Nat.le_of_ble_eq_true h1) (hle k))
    rw [h2]
    exact Nat.le_refl 1

/-- Unchecked component that surges at Site `true` from step 1 (`2 → 4`). -/
def uncheckedComp : OpenComposition.OpenComponent Nat Unit Unit Empty Bool where
  next s _ _ := s + 1
  drawInt _ e := Empty.elim e
  drawExt s k := match k with | false => 1 | true => match s with | 0 => 2 | _ + 1 => 4
  emitAlarm _ _ := false
  silenceLoad _ := 0
  favours _ := False

def uncheckedSt : Nat → (Bool → Nat) × Nat
  | 0 => (fun k => match k with | false => 3 | true => 4, 0)
  | t + 1 => OpenComposition.closedStep uncheckedComp (fun _ => ()) (fun _ _ _ => false)
      twoSiteG (fun _ _ => 0) (uncheckedSt t) ((), ())

/-- Verified `OverdrawSite` separation: step `0` balances on `[false, true]`, while at `tStar = 1`
Site `false` stays balanced (`3 + 1 = 3 + 1`) and Site `true` clamps (`3 < 4`, discrepancy `1 > 0`). -/
theorem unchecked_overdraw_separation :
    let L := multiSiteFlow uncheckedComp twoSiteG (fun _ _ => 0) uncheckedSt (fun _ => ())
    let W := multiSiteWeb uncheckedComp twoSiteG (fun _ _ => 0) uncheckedSt (fun _ => ())
    (L.BalancesOn W ([false, true].map MultiSiteRelatum.site) 0) ∧
    (W.level 2 (.site false) + L.taken 1 (.site false) =
      W.level 1 (.site false) + L.given 1 (.site false)) ∧
    ((uncheckedSt 2).1 true + multiSiteDrawAt uncheckedComp (fun _ _ => 0) uncheckedSt (fun _ => ()) 1 true =
      ((uncheckedSt 1).1 true + L.given 1 (.site true)) +
        (multiSiteDrawAt uncheckedComp (fun _ _ => 0) uncheckedSt (fun _ => ()) 1 true -
          (uncheckedSt 1).1 true) ∧
      0 < multiSiteDrawAt uncheckedComp (fun _ _ => 0) uncheckedSt (fun _ => ()) 1 true -
          (uncheckedSt 1).1 true) ∧
    ¬ L.BalancesOn W ([false, true].map MultiSiteRelatum.site) 1 ∧
    ¬ L.Balances W ∧
    ¬ (multiSiteRel uncheckedComp twoSiteG (fun _ _ => 0) uncheckedSt (fun _ => ())).Runs
        multiSitePresent (multiSiteLevel uncheckedSt) L := by
  have hSep := multiSite_overdraw_separation uncheckedComp (fun _ => ()) (fun _ _ _ => false)
    twoSiteG (fun _ _ => 0) (fun _ => rfl) (sites := [false, true]) (tStar := 1) (kStar := true)
    (.tail false (.head []))
    (fun t ht k hk => by
      match t with
      | 0 =>
        match mem_cons_cases hk with
        | .inl h => rw [h]; exact by decide
        | .inr hk' => match mem_cons_cases hk' with
          | .inl h => rw [h]; exact by decide
          | .inr no => nomatch no
      | _ + 1 => exact absurd ht (Nat.not_lt_of_le (Nat.succ_le_succ (Nat.zero_le _))))
    (by decide : (uncheckedSt 1).1 true < 4)
    (fun k hk hne => by
      match mem_cons_cases hk with
      | .inl h => rw [h]; exact by decide
      | .inr hk' => match mem_cons_cases hk' with
        | .inl h => exact absurd h hne
        | .inr no => nomatch no)
  exact ⟨hSep.1 0 Nat.zero_lt_one,
    hSep.2.1 false (.head _) (fun e => Bool.noConfusion e),
    hSep.2.2.1, hSep.2.2.2.2.2.1, hSep.2.2.2.2.2.2.1, hSep.2.2.2.2.2.2.2⟩

/-- Safe throttled two-site component (`preCapExt = (1, 2)`, `postAllowance = (1, 1)`). -/
def safeWarn (k : Bool) : Nat := match k with | false => 4 | true => 6
def safeCrit (_ : Bool) : Nat := 2
def safeHSafe (_ : Bool) : Nat := 1
def safeX0 (k : Bool) : Nat := match k with | false => 3 | true => 4

def safeComp : OpenComposition.OpenComponent Nat (Bool → Bool) Unit Empty Bool where
  next s oa _ := if oa.2 then s - 1 else s
  drawInt _ e := Empty.elim e
  drawExt s k := match k with | false => 1 | true => if Nat.beq s 0 then 1 else 2
  emitAlarm _ o := o false || o true
  silenceLoad _ := 0
  favours s := 0 < s

def safeContract : OpenComposition.InterfaceContract safeComp 1 where
  tol _ _ := True
  warnObs o := o false = true ∨ o true = true
  preCapInt e := Empty.elim e
  preCapExt k := match k with | false => 1 | true => 2
  postBudgetInt e := Empty.elim e
  postBudgetExt _ := 1
  maxSilence := 0
  maxLag := 1
  K s := s ≤ 1
  eta s := s
  init_in := Nat.le_refl 1
  cert := Viability.certificate_disturbed_iff.mpr
    ⟨fun s hs =>
      ⟨fun e => Empty.elim e,
       fun k => match k with
         | false => Nat.le_refl 1
         | true => by
           show (if Nat.beq s 0 then 1 else 2) ≤ 2
           cases Nat.beq s 0 <;> decide,
       Nat.le_refl 0,
       fun h0 => ⟨by rw [h0]; exact Nat.lt_irrefl 0, fun e => Empty.elim e,
         fun k => match k with
           | false => Nat.le_refl 1
           | true => by
             show (if Nat.beq s 0 then 1 else 2) ≤ 1
             rw [h0]
             exact Nat.le_refl 1⟩⟩,
     fun s m _ hs => by
       show (if m.1.2 then s - 1 else s) ≤ 1
       cases m.1.2
       · exact hs
       · exact Nat.le_trans (Nat.sub_le s 1) hs⟩
  eta_bound _ hs := hs
  emits_on_warn _ o _ hw := by
    show (o false || o true) = true
    cases hw with
    | inl h => rw [h]; rfl
    | inr h => rw [h]; exact ChanceFloors.or_true (o false)
  eta_alarm_step s _ _ _ _ hPos := by
    show s - 1 < s
    match s, hPos with
    | s' + 1, _ => exact Nat.lt_succ_self s'
  eta_alarm_zero s _ _ _ _ h0 := by
    show s - 1 = 0
    rw [h0]

def safeObs (x : Bool → Nat) : Bool → Bool :=
  fun k => Nat.ble (x k + 1) (safeWarn k)

theorem safe_kernel :
    Viability.Kernel
      (OpenComposition.closedProcess safeComp safeContract safeObs OpenComposition.zeroSilenceChannel
        twoSiteG (fun _ _ => 0) (fun _ => True))
      (OpenComposition.closedGuard safeComp safeContract safeCrit) (safeX0, 1) := by
  refine OpenComposition.close_contract_kernel safeComp safeContract safeObs
    OpenComposition.zeroSilenceChannel twoSiteG (fun _ _ => 0) (fun _ => 0) (fun _ => True)
    (fun _ _ _ => Nat.le_refl 0) safeCrit safeWarn safeHSafe safeX0
    (fun x k hk => match k with
      | false => .inl (Nat.ble_eq_true_of_le hk)
      | true => .inr (Nat.ble_eq_true_of_le hk))
    (fun load _ _ hload => by
      have h0 : load = 0 := Nat.eq_zero_of_le_zero hload
      rw [h0]; rfl)
    twoSiteG_rises
    (fun k => by
      cases k <;> exact Nat.le_refl 2)
    (fun _ => Nat.le_refl 1)
    (fun k => by cases k <;> exact Nat.le_refl _)
    (fun k => by cases k <;> exact Nat.le_refl _)

theorem safe_run_certified
    (r : Run (OpenComposition.closedProcess safeComp safeContract safeObs
      OpenComposition.zeroSilenceChannel twoSiteG (fun _ _ => 0) (fun _ => True)))
    (h0 : r.state 0 = (safeX0, 1)) :
    let L := multiSiteFlow safeComp twoSiteG (fun _ _ => 0) r.state (fun t => (r.act t).1)
    let W := multiSiteWeb safeComp twoSiteG (fun _ _ => 0) r.state (fun t => (r.act t).1)
    L.Balances W ∧
    (multiSiteWorld safeComp twoSiteG (fun _ _ => 0) r.state (fun t => (r.act t).1)).ReadOffExchange ∧
    (∀ t k, W.requires t .component (.site k)) := by
  have hGuard : ∀ t, OpenComposition.closedGuard safeComp safeContract safeCrit (r.state t) :=
    Viability.Kernel.run r (h0 ▸ safe_kernel)
  have hPre : ∀ t k,
      multiSiteDrawAt safeComp (fun _ _ => 0) r.state (fun t => (r.act t).1) t k ≤
        (r.state t).1 k := by
    intro t k
    have hg := hGuard t
    have hCap : safeContract.preCapExt k + 0 ≤ safeCrit k := by
      cases k <;> exact by decide
    exact Nat.le_trans (Nat.add_le_add (hg.2.2.1 k) (Nat.le_refl 0))
      (Nat.le_trans hCap (hg.1 k))
  have hRun := multiSite_run_readOffExchange safeComp safeObs OpenComposition.zeroSilenceChannel
    twoSiteG (fun _ _ => 0) r hPre
  refine ⟨hRun.2.2.1, hRun.2.1, fun t k => hRun.2.2.2 t k ?_⟩
  cases k with
  | false => exact Nat.zero_lt_one
  | true =>
    show 0 < if Nat.beq (r.state t).2 0 then 1 else 2
    cases Nat.beq (r.state t).2 0
    · exact by decide
    · exact Nat.zero_lt_one

end MultiSiteBridgeWitness

/-! ## Witness 3: `MajorTransitionWitness` -/

namespace MajorTransitionWitness

/-- Shared substrate law `G_shared`: replenishes `2` whenever at least `4` remains after draw. -/
def sharedG (_ : Unit) (e : Unit → Nat) : Nat :=
  if Nat.ble 4 (e ()) then 2 else 0

theorem sharedG_rises : ∀ k, RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (sharedG k) := by
  intro k e e' hle
  show (if Nat.ble 4 (e ()) then 2 else 0) ≤ (if Nat.ble 4 (e' ()) then 2 else 0)
  cases h1 : Nat.ble 4 (e ())
  · exact Nat.zero_le _
  · have h2 : Nat.ble 4 (e' ()) = true :=
      Nat.ble_eq_true_of_le (Nat.le_trans (Nat.le_of_ble_eq_true h1) (hle ()))
    rw [h2]
    exact Nat.le_refl 2

/-- Finite relatum enum for the unintegrated group `Unint` (`9 → 8 → 3 → 0`). -/
inductive UnintRelatum where
  | shared
  | regen
  | coop0
  | coop1
  | coop2
  | coop3
  | fast0
  | fast1a
  | fast1b
  | fast2a
  | fast2b
  | fast3

def unintKids (t : Nat) (p : UnintRelatum) : List UnintRelatum :=
  match t with
  | 0 => match p with
    | .coop0 => [.coop1]
    | .fast0 => [.fast1a, .fast1b]
    | .shared => [] | .regen => [] | .coop1 => [] | .coop2 => [] | .coop3 => []
    | .fast1a => [] | .fast1b => [] | .fast2a => [] | .fast2b => [] | .fast3 => []
  | 1 => match p with
    | .coop1 => [.coop2]
    | .fast1a => [.fast2a]
    | .fast1b => [.fast2b]
    | .shared => [] | .regen => [] | .coop0 => [] | .coop2 => [] | .coop3 => []
    | .fast0 => [] | .fast2a => [] | .fast2b => [] | .fast3 => []
  | 2 => match p with
    | .coop2 => [.coop3]
    | .fast2a => [.fast3]
    | .shared => [] | .regen => [] | .coop0 => [] | .coop1 => [] | .coop3 => []
    | .fast0 => [] | .fast1a => [] | .fast1b => [] | .fast2b => [] | .fast3 => []
  | _ + 3 => []

def unintGen : SelectionTerm.Generations UnintRelatum where
  first := [.coop0, .fast0]
  kids := unintKids
  amount _ p := match p with
    | .fast0 => 1 | .fast1a => 1 | .fast1b => 1
    | .fast2a => 1 | .fast2b => 1 | .fast3 => 1
    | .shared => 0 | .regen => 0 | .coop0 => 0 | .coop1 => 0 | .coop2 => 0 | .coop3 => 0

def unintSharedLevel : Nat → Nat
  | 0 => 9
  | 1 => 8
  | 2 => 3
  | _ + 3 => 0

def unintPresent : Nat → List UnintRelatum
  | 0 => [.regen, .coop0, .fast0]
  | 1 => [.regen, .coop1, .fast1a, .fast1b]
  | 2 => [.coop2, .fast2a, .fast2b]
  | _ + 3 => []

def unintWeb : Web UnintRelatum UnintRelatum where
  level t x := match x with
    | .shared => unintSharedLevel t
    | .regen => 0
    | .coop0 => match t with | 0 => 1 | _ + 1 => 0
    | .coop1 => match t with | 1 => 1 | 0 => 0 | _ + 2 => 0
    | .coop2 => match t with | 2 => 1 | 0 => 0 | 1 => 0 | _ + 3 => 0
    | .coop3 => match t with | 0 => 0 | 1 => 0 | 2 => 0 | _ + 3 => 1
    | .fast0 => match t with | 0 => 1 | _ + 1 => 0
    | .fast1a => match t with | 1 => 1 | 0 => 0 | _ + 2 => 0
    | .fast1b => match t with | 1 => 1 | 0 => 0 | _ + 2 => 0
    | .fast2a => match t with | 2 => 1 | 0 => 0 | 1 => 0 | _ + 3 => 0
    | .fast2b => match t with | 2 => 1 | 0 => 0 | 1 => 0 | _ + 3 => 0
    | .fast3 => match t with | 0 => 0 | 1 => 0 | 2 => 0 | _ + 3 => 1
  active t x := match t with
    | 0 => match x with
      | .regen => True | .coop0 => True | .fast0 => True
      | .shared => False | .coop1 => False | .coop2 => False | .coop3 => False
      | .fast1a => False | .fast1b => False | .fast2a => False | .fast2b => False | .fast3 => False
    | 1 => match x with
      | .regen => True | .coop1 => True | .fast1a => True | .fast1b => True
      | .shared => False | .coop0 => False | .coop2 => False | .coop3 => False
      | .fast0 => False | .fast2a => False | .fast2b => False | .fast3 => False
    | 2 => match x with
      | .coop2 => True | .fast2a => True | .fast2b => True
      | .shared => False | .regen => False | .coop0 => False | .coop1 => False | .coop3 => False
      | .fast0 => False | .fast1a => False | .fast1b => False | .fast3 => False
    | _ + 3 => False
  requires t f c := match c with
    | .shared => match f with
      | .regen => match t with | 0 => True | 1 => True | _ + 2 => False
      | .coop0 => True | .coop1 => True | .coop2 => True | .coop3 => True
      | .fast0 => True | .fast1a => True | .fast1b => True
      | .fast2a => True | .fast2b => True | .fast3 => True
      | .shared => False
    | .regen => False | .coop0 => False | .coop1 => False | .coop2 => False | .coop3 => False
    | .fast0 => False | .fast1a => False | .fast1b => False
    | .fast2a => False | .fast2b => False | .fast3 => False
  need _ _ _ := 3
  draws t f c := match c with
    | .shared => match f with
      | .coop0 => t = 0 | .coop1 => t = 1 | .coop2 => t = 2
      | .fast0 => t = 0 | .fast1a => t = 1 | .fast1b => t = 1
      | .fast2a => t = 2 | .fast2b => t = 2
      | .shared => False | .regen => False | .coop3 => False | .fast3 => False
    | .regen => False | .coop0 => False | .coop1 => False | .coop2 => False | .coop3 => False
    | .fast0 => False | .fast1a => False | .fast1b => False
    | .fast2a => False | .fast2b => False | .fast3 => False

def unintFlow : Flow UnintRelatum UnintRelatum where
  present := unintPresent
  take t f c := match t with
    | 0 => match f with
      | .coop0 => match c with
        | .shared => 1 | .coop0 => 1
        | .regen => 0 | .coop1 => 0 | .coop2 => 0 | .coop3 => 0
        | .fast0 => 0 | .fast1a => 0 | .fast1b => 0 | .fast2a => 0 | .fast2b => 0 | .fast3 => 0
      | .fast0 => match c with
        | .shared => 2 | .fast0 => 1
        | .regen => 0 | .coop0 => 0 | .coop1 => 0 | .coop2 => 0 | .coop3 => 0
        | .fast1a => 0 | .fast1b => 0 | .fast2a => 0 | .fast2b => 0 | .fast3 => 0
      | .shared => 0 | .regen => 0 | .coop1 => 0 | .coop2 => 0 | .coop3 => 0
      | .fast1a => 0 | .fast1b => 0 | .fast2a => 0 | .fast2b => 0 | .fast3 => 0
    | 1 => match f with
      | .coop1 => match c with
        | .shared => 1 | .coop1 => 1
        | .regen => 0 | .coop0 => 0 | .coop2 => 0 | .coop3 => 0
        | .fast0 => 0 | .fast1a => 0 | .fast1b => 0 | .fast2a => 0 | .fast2b => 0 | .fast3 => 0
      | .fast1a => match c with
        | .shared => 2 | .fast1a => 1
        | .regen => 0 | .coop0 => 0 | .coop1 => 0 | .coop2 => 0 | .coop3 => 0
        | .fast0 => 0 | .fast1b => 0 | .fast2a => 0 | .fast2b => 0 | .fast3 => 0
      | .fast1b => match c with
        | .shared => 2 | .fast1b => 1
        | .regen => 0 | .coop0 => 0 | .coop1 => 0 | .coop2 => 0 | .coop3 => 0
        | .fast0 => 0 | .fast1a => 0 | .fast2a => 0 | .fast2b => 0 | .fast3 => 0
      | .shared => 0 | .regen => 0 | .coop0 => 0 | .coop2 => 0 | .coop3 => 0
      | .fast0 => 0 | .fast2a => 0 | .fast2b => 0 | .fast3 => 0
    | 2 => match f with
      | .coop2 => match c with
        | .shared => 1 | .coop2 => 1
        | .regen => 0 | .coop0 => 0 | .coop1 => 0 | .coop3 => 0
        | .fast0 => 0 | .fast1a => 0 | .fast1b => 0 | .fast2a => 0 | .fast2b => 0 | .fast3 => 0
      | .fast2a => match c with
        | .shared => 1 | .fast2a => 1
        | .regen => 0 | .coop0 => 0 | .coop1 => 0 | .coop2 => 0 | .coop3 => 0
        | .fast0 => 0 | .fast1a => 0 | .fast1b => 0 | .fast2b => 0 | .fast3 => 0
      | .fast2b => match c with
        | .shared => 1 | .fast2b => 1
        | .regen => 0 | .coop0 => 0 | .coop1 => 0 | .coop2 => 0 | .coop3 => 0
        | .fast0 => 0 | .fast1a => 0 | .fast1b => 0 | .fast2a => 0 | .fast3 => 0
      | .shared => 0 | .regen => 0 | .coop0 => 0 | .coop1 => 0 | .coop3 => 0
      | .fast0 => 0 | .fast1a => 0 | .fast1b => 0 | .fast3 => 0
    | _ + 3 => 0
  give t f c := match t with
    | 0 => match f with
      | .regen => match c with
        | .shared => 2 | .regen => 0 | .coop0 => 0 | .coop1 => 0 | .coop2 => 0 | .coop3 => 0
        | .fast0 => 0 | .fast1a => 0 | .fast1b => 0 | .fast2a => 0 | .fast2b => 0 | .fast3 => 0
      | .coop0 => match c with
        | .coop1 => 1 | .shared => 0 | .regen => 0 | .coop0 => 0 | .coop2 => 0 | .coop3 => 0
        | .fast0 => 0 | .fast1a => 0 | .fast1b => 0 | .fast2a => 0 | .fast2b => 0 | .fast3 => 0
      | .fast0 => match c with
        | .fast1a => 1 | .fast1b => 1
        | .shared => 0 | .regen => 0 | .coop0 => 0 | .coop1 => 0 | .coop2 => 0 | .coop3 => 0
        | .fast0 => 0 | .fast2a => 0 | .fast2b => 0 | .fast3 => 0
      | .shared => 0 | .coop1 => 0 | .coop2 => 0 | .coop3 => 0
      | .fast1a => 0 | .fast1b => 0 | .fast2a => 0 | .fast2b => 0 | .fast3 => 0
    | 1 => match f with
      | .coop1 => match c with
        | .coop2 => 1 | .shared => 0 | .regen => 0 | .coop0 => 0 | .coop1 => 0 | .coop3 => 0
        | .fast0 => 0 | .fast1a => 0 | .fast1b => 0 | .fast2a => 0 | .fast2b => 0 | .fast3 => 0
      | .fast1a => match c with
        | .fast2a => 1 | .shared => 0 | .regen => 0 | .coop0 => 0 | .coop1 => 0 | .coop2 => 0 | .coop3 => 0
        | .fast0 => 0 | .fast1a => 0 | .fast1b => 0 | .fast2b => 0 | .fast3 => 0
      | .fast1b => match c with
        | .fast2b => 1 | .shared => 0 | .regen => 0 | .coop0 => 0 | .coop1 => 0 | .coop2 => 0 | .coop3 => 0
        | .fast0 => 0 | .fast1a => 0 | .fast1b => 0 | .fast2a => 0 | .fast3 => 0
      | .shared => 0 | .regen => 0 | .coop0 => 0 | .coop2 => 0 | .coop3 => 0
      | .fast0 => 0 | .fast2a => 0 | .fast2b => 0 | .fast3 => 0
    | 2 => match f with
      | .coop2 => match c with
        | .coop3 => 1 | .shared => 0 | .regen => 0 | .coop0 => 0 | .coop1 => 0 | .coop2 => 0
        | .fast0 => 0 | .fast1a => 0 | .fast1b => 0 | .fast2a => 0 | .fast2b => 0 | .fast3 => 0
      | .fast2a => match c with
        | .fast3 => 1 | .shared => 0 | .regen => 0 | .coop0 => 0 | .coop1 => 0 | .coop2 => 0 | .coop3 => 0
        | .fast0 => 0 | .fast1a => 0 | .fast1b => 0 | .fast2a => 0 | .fast2b => 0
      | .shared => 0 | .regen => 0 | .coop0 => 0 | .coop1 => 0 | .coop3 => 0
      | .fast0 => 0 | .fast1a => 0 | .fast1b => 0 | .fast2b => 0 | .fast3 => 0
    | _ + 3 => 0

theorem unint_balances : unintFlow.Balances unintWeb := by
  intro t c
  cases c <;> match t with | 0 => rfl | 1 => rfl | 2 => rfl | _ + 3 => rfl

theorem unint_acting : unintFlow.Acting unintWeb := by
  intro t f c _ hpos
  match t with
  | 0 =>
    cases f <;> cases c <;>
      first | exact trivial | exact absurd hpos (Nat.lt_irrefl 0)
  | 1 =>
    cases f <;> cases c <;>
      first | exact trivial | exact absurd hpos (Nat.lt_irrefl 0)
  | 2 =>
    cases f <;> cases c <;>
      first | exact trivial | exact absurd hpos (Nat.lt_irrefl 0)
  | _ + 3 => exact absurd hpos (Nat.lt_irrefl 0)

theorem unint_dependent : unintWeb.Dependent := by
  intro t f hAct c hReq
  match t with
  | 0 =>
    cases f <;> cases c <;>
      first | exact False.elim hAct | exact False.elim hReq | exact (by decide : 3 ≤ 9)
  | 1 =>
    cases f <;> cases c <;>
      first | exact False.elim hAct | exact False.elim hReq | exact (by decide : 3 ≤ 8)
  | 2 =>
    cases f <;> cases c <;>
      first | exact False.elim hAct | exact False.elim hReq | exact Nat.le_refl 3
  | _ + 3 => exact False.elim hAct

theorem unint_descended : SelectionTerm.Flow.Descended unintFlow unintWeb unintGen := by
  intro t p k _ mk
  match t with
  | 0 =>
    cases p with
    | coop0 =>
      match mem_cons_cases mk with
      | .inl hk => subst hk; exact ⟨.tail _ (.head _), Nat.zero_lt_one, Nat.lt_irrefl 0, Nat.zero_lt_one⟩
      | .inr no => nomatch no
    | fast0 =>
      match mem_cons_cases mk with
      | .inl hk => subst hk; exact ⟨.tail _ (.tail _ (.head _)), Nat.zero_lt_one, Nat.lt_irrefl 0, Nat.zero_lt_one⟩
      | .inr mk' => match mem_cons_cases mk' with
        | .inl hk => subst hk; exact ⟨.tail _ (.tail _ (.head _)), Nat.zero_lt_one, Nat.lt_irrefl 0, Nat.zero_lt_one⟩
        | .inr no => nomatch no
    | shared => nomatch mk
    | regen => nomatch mk
    | coop1 => nomatch mk
    | coop2 => nomatch mk
    | coop3 => nomatch mk
    | fast1a => nomatch mk
    | fast1b => nomatch mk
    | fast2a => nomatch mk
    | fast2b => nomatch mk
    | fast3 => nomatch mk
  | 1 =>
    cases p with
    | coop1 =>
      match mem_cons_cases mk with
      | .inl hk => subst hk; exact ⟨.tail _ (.head _), Nat.zero_lt_one, Nat.lt_irrefl 0, Nat.zero_lt_one⟩
      | .inr no => nomatch no
    | fast1a =>
      match mem_cons_cases mk with
      | .inl hk => subst hk; exact ⟨.tail _ (.tail _ (.head _)), Nat.zero_lt_one, Nat.lt_irrefl 0, Nat.zero_lt_one⟩
      | .inr no => nomatch no
    | fast1b =>
      match mem_cons_cases mk with
      | .inl hk => subst hk; exact ⟨.tail _ (.tail _ (.tail _ (.head _))), Nat.zero_lt_one, Nat.lt_irrefl 0, Nat.zero_lt_one⟩
      | .inr no => nomatch no
    | shared => nomatch mk
    | regen => nomatch mk
    | coop0 => nomatch mk
    | coop2 => nomatch mk
    | coop3 => nomatch mk
    | fast0 => nomatch mk
    | fast2a => nomatch mk
    | fast2b => nomatch mk
    | fast3 => nomatch mk
  | 2 =>
    cases p with
    | coop2 =>
      match mem_cons_cases mk with
      | .inl hk => subst hk; exact ⟨.head _, Nat.zero_lt_one, Nat.lt_irrefl 0, Nat.zero_lt_one⟩
      | .inr no => nomatch no
    | fast2a =>
      match mem_cons_cases mk with
      | .inl hk => subst hk; exact ⟨.tail _ (.head _), Nat.zero_lt_one, Nat.lt_irrefl 0, Nat.zero_lt_one⟩
      | .inr no => nomatch no
    | shared => nomatch mk
    | regen => nomatch mk
    | coop0 => nomatch mk
    | coop1 => nomatch mk
    | coop3 => nomatch mk
    | fast0 => nomatch mk
    | fast1a => nomatch mk
    | fast1b => nomatch mk
    | fast2b => nomatch mk
    | fast3 => nomatch mk
  | _ + 3 => nomatch mk

theorem unint_lineage_3 : SelectionLevels.lineage unintGen [.fast0] 3 = [.fast3] := rfl

theorem unint_lineage_later (k : Nat) :
    SelectionLevels.lineage unintGen [.fast0] (3 + k + 1) = [] := by
  induction k with
  | zero => rfl
  | succ k ih =>
    change (SelectionLevels.lineage unintGen [.fast0] (3 + k + 1)).flatMap (unintKids (3 + k + 1)) = []
    rw [ih]
    rfl

/-- `ConfinedRise` with exact parameters `m = 3, T = 2, n = 1` on `Unint`. -/
def unintConfinedRise : Founding.Flow.ConfinedRise unintFlow unintWeb unintGen [.fast0] [.shared] 3 2 1 where
  founded := fun _ mp => match mem_cons_cases mp with | .inl h => h ▸ .tail _ (.head _) | .inr no => nomatch no
  selected := ⟨0, by decide, (fun p hp => by
    change p ∈ [UnintRelatum.coop0, UnintRelatum.fast0] at hp
    match mem_cons_cases hp with
    | .inl h =>
      subst h
      exact ⟨fun h0 => absurd h0 (Nat.lt_irrefl 0), fun h0 => nomatch h0⟩
    | .inr hp' => match mem_cons_cases hp' with
      | .inl h =>
        subst h
        exact ⟨fun _ => .head _, fun _ => Nat.zero_lt_one⟩
      | .inr no => nomatch no),
    by decide⟩
  draws := ⟨2, .fast2a, .shared, Nat.le_refl 2, by decide, .head _, .head _, Nat.zero_lt_one⟩
  gated := fun t f _ d hd hpos => by
    have hd' : d = .shared := match hd with | .head _ => rfl | .tail _ no => nomatch no
    subst hd'
    match t with
    | 0 =>
      cases f with
      | regen => exact ⟨.shared, .head _, trivial, Nat.le_refl 3⟩
      | shared => exact absurd hpos (Nat.lt_irrefl 0)
      | coop0 => exact absurd hpos (Nat.lt_irrefl 0)
      | coop1 => exact absurd hpos (Nat.lt_irrefl 0)
      | coop2 => exact absurd hpos (Nat.lt_irrefl 0)
      | coop3 => exact absurd hpos (Nat.lt_irrefl 0)
      | fast0 => exact absurd hpos (Nat.lt_irrefl 0)
      | fast1a => exact absurd hpos (Nat.lt_irrefl 0)
      | fast1b => exact absurd hpos (Nat.lt_irrefl 0)
      | fast2a => exact absurd hpos (Nat.lt_irrefl 0)
      | fast2b => exact absurd hpos (Nat.lt_irrefl 0)
      | fast3 => exact absurd hpos (Nat.lt_irrefl 0)
    | 1 => cases f <;> exact absurd hpos (Nat.lt_irrefl 0)
    | 2 => cases f <;> exact absurd hpos (Nat.lt_irrefl 0)
    | _ + 3 => cases f <;> exact absurd hpos (Nat.lt_irrefl 0)
  excess := fun k hk => match k with
    | 0 => by decide
    | k' + 1 => absurd hk (Nat.not_lt_of_le (Nat.succ_le_succ (Nat.zero_le k')))
  start := by decide
  confined := fun k p hp => by
    match k with
    | 0 =>
      rw [unint_lineage_3] at hp
      match mem_cons_cases hp with
      | .inl h => subst h; exact ⟨.shared, .head _, trivial, Nat.le_refl 3⟩
      | .inr no => nomatch no
    | k' + 1 =>
      have hLin := unint_lineage_later k'
      rw [Nat.add_assoc 3 k' 1] at hLin
      rw [hLin] at hp
      nomatch hp

theorem unint_takeover_ends :
    (∀ j, SelectionLevels.lineage unintGen [.fast0] (2 + 1 + j + 1) = []) ∧
    total [.coop3, .fast3] (unintGen.offspringNumber (2 + 1 + 0)) = 0 :=
  unintegrated_confined_takeover_ends unint_balances unint_acting unint_dependent unintConfinedRise
    unint_descended 0
    (fun _ hp => by
      match mem_cons_cases hp with
      | .inl h => subst h; exact .head _
      | .inr hp' => match mem_cons_cases hp' with
        | .inl h => subst h; exact .tail _ (.head _)
        | .inr no => nomatch no)
    (fun _ hp => by
      match mem_cons_cases hp with
      | .inl h => subst h; exact ⟨.shared, .head _, trivial, Nat.le_refl 3⟩
      | .inr hp' => match mem_cons_cases hp' with
        | .inl h => subst h; exact ⟨.shared, .head _, trivial, Nat.le_refl 3⟩
        | .inr no => nomatch no)

/-- Integrated group `Integ = OpenComponent.hide (A_policed.compose B_policed) sharedG wireObs`. -/
def aPoliced : OpenComposition.OpenComponent Unit Unit Unit Empty (Sum Empty Unit) where
  next _ _ _ := ()
  drawInt _ e := Empty.elim e
  drawExt _ _ := 1
  emitAlarm _ _ := false
  silenceLoad _ := 0
  favours _ := False

def cAPoliced : OpenComposition.InterfaceContract aPoliced () where
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

def bPoliced : OpenComposition.OpenComponent Nat Bool Unit Empty (Sum Empty Unit) where
  next s oa _ := if oa.2 then s - 1 else s
  drawInt _ e := Empty.elim e
  drawExt s k := match k with | .inl e => Empty.elim e | .inr () => if Nat.beq s 0 then 1 else 2
  emitAlarm _ o := o
  silenceLoad _ := 0
  favours s := 0 < s

def cBPoliced : OpenComposition.InterfaceContract bPoliced 1 where
  tol _ _ := True
  warnObs o := o = true
  preCapInt e := Empty.elim e
  preCapExt | .inl e => Empty.elim e | .inr () => 2
  postBudgetInt e := Empty.elim e
  postBudgetExt | .inl e => Empty.elim e | .inr () => 1
  maxSilence := 0
  maxLag := 1
  K s := s ≤ 1
  eta s := s
  init_in := Nat.le_refl 1
  cert := Viability.certificate_disturbed_iff.mpr
    ⟨fun s hs =>
      ⟨fun e => Empty.elim e,
       fun k => match k with
         | .inl e => Empty.elim e
         | .inr () => by
           show (if Nat.beq s 0 then 1 else 2) ≤ 2
           cases Nat.beq s 0 <;> decide,
       Nat.le_refl 0,
       fun h0 => ⟨by rw [h0]; exact Nat.lt_irrefl 0, fun e => Empty.elim e,
         fun k => match k with
           | .inl e => Empty.elim e
           | .inr () => by
             show (if Nat.beq s 0 then 1 else 2) ≤ 1
             rw [h0]; exact Nat.le_refl 1⟩⟩,
     fun s m _ hs => by
       show (if m.1.2 then s - 1 else s) ≤ 1
       cases m.1.2
       · exact hs
       · exact Nat.le_trans (Nat.sub_le s 1) hs⟩
  eta_bound _ hs := hs
  emits_on_warn _ o _ hw := hw
  eta_alarm_step s _ _ _ _ hPos := match s, hPos with | s' + 1, _ => Nat.lt_succ_self s'
  eta_alarm_zero s _ _ _ _ h0 := by show s - 1 = 0; rw [h0]

def wireHideObs (_ : Unit) (xh : Unit → Nat) : Unit × Bool :=
  ((), Nat.ble (xh () + 1) 12)

def integComp :=
  OpenComposition.OpenComponent.hide (OpenComposition.OpenComponent.compose aPoliced bPoliced)
    sharedG wireHideObs

def integContract : OpenComposition.InterfaceContract integComp (((), 1), fun _ => 9) :=
  OpenComposition.hideContract (OpenComposition.composeContract cAPoliced cBPoliced)
    sharedG wireHideObs (fun _ _ => True) (fun _ => False)
    (fun _ => 6) (fun _ => 12) (fun _ => 2) (fun _ => 9)
    (fun _ _ _ _ _ _ => ⟨trivial, trivial⟩)
    sharedG_rises
    (fun _ _ hf => False.elim hf)
    (fun _ _ ⟨(), hlt⟩ => .inr (Nat.ble_eq_true_of_le hlt))
    (fun _ => Nat.le_refl 6)
    (fun _ => Nat.le_refl 2)
    (fun _ => Nat.le_refl 12)
    (fun _ => Nat.le_refl 9)

theorem integ_sealed_viability :
    Viability.Kernel
      (OpenComposition.closedProcess integComp integContract (fun _ => ())
        OpenComposition.zeroSilenceChannel (fun e => Empty.elim e) (fun _ e => Empty.elim e) (fun _ => True))
      (OpenComposition.closedGuard integComp integContract (fun e => Empty.elim e))
      (fun e => Empty.elim e, (((), 1), fun _ => 9)) ∧
    ∀ (r : Run (OpenComposition.closedProcess integComp integContract (fun _ => ())
        OpenComposition.zeroSilenceChannel (fun e => Empty.elim e) (fun _ e => Empty.elim e) (fun _ => True))),
      r.state 0 = (fun e => Empty.elim e, (((), 1), fun _ => 9)) →
      ∀ t, 6 ≤ (r.state t).2.2 () ∧
        aPoliced.drawExt (r.state t).2.1.1 (Sum.inr ()) +
          bPoliced.drawExt (r.state t).2.1.2 (Sum.inr ()) ≤ 3 := by
  have hSeal := openComponent_hide_seals_internal_viability aPoliced bPoliced cAPoliced cBPoliced
    sharedG wireHideObs (fun _ _ => True) (fun _ => False)
    (fun _ => 6) (fun _ => 12) (fun _ => 2) (fun _ => 9)
    (fun _ _ _ _ _ _ => ⟨trivial, trivial⟩)
    sharedG_rises
    (fun _ _ hf => False.elim hf)
    (fun _ _ ⟨(), hlt⟩ => .inr (Nat.ble_eq_true_of_le hlt))
    (fun _ => Nat.le_refl 6)
    (fun _ => Nat.le_refl 2)
    (fun _ => Nat.le_refl 12)
    (fun _ => Nat.le_refl 9)
    (fun _ => ()) OpenComposition.zeroSilenceChannel
    (fun e => Empty.elim e) (fun _ e => Empty.elim e) (fun e => Empty.elim e) (fun _ => True)
    (fun _ _ e => Empty.elim e)
    (fun e => Empty.elim e) (fun e => Empty.elim e) (fun e => Empty.elim e) (fun e => Empty.elim e)
    (fun _ e _ => Empty.elim e)
    (fun load _ _ hload => by rw [Nat.eq_zero_of_le_zero hload]; rfl)
    (fun e => Empty.elim e) (fun e => Empty.elim e) (fun e => Empty.elim e)
    (fun e => Empty.elim e) (fun e => Empty.elim e)
  refine ⟨hSeal.1, fun r h0 t => ?_⟩
  have ht := hSeal.2 r h0 t
  exact ⟨ht.2.1 (), ht.2.2 ()⟩

/-- Concrete trajectory of `Integ` (`9 → 8 → 8 ...`). -/
def integState : Nat → (Empty → Nat) × ((Unit × Nat) × (Unit → Nat))
  | 0 => (fun e => Empty.elim e, (((), 1), fun _ => 9))
  | t + 1 => OpenComposition.closedStep integComp (fun _ => ()) OpenComposition.zeroSilenceChannel
      (fun e => Empty.elim e) (fun _ e => Empty.elim e) (integState t) ((), ((), ()))

theorem integ_steps_check :
    (integState 0).2.2 () = 9 ∧ (integState 1).2.2 () = 8 ∧
    (integState 2).2.2 () = 8 ∧ (integState 3).2.2 () = 8 :=
  ⟨rfl, rfl, rfl, rfl⟩

/-- Part 3: Multi-level selection shift across `[g_unint, g_integ]` at `t = 3`. -/
inductive TransitionUnit where
  | unint0
  | unint1
  | integ0
  | integ1

def transitionGen : SelectionTerm.Generations TransitionUnit where
  first := [.unint0, .unint1, .integ0, .integ1]
  kids t u := match t with
    | 3 => match u with
      | .integ0 => [.integ0]
      | .integ1 => [.integ1]
      | .unint0 => []
      | .unint1 => []
    | _ => [u]
  amount _ u := match u with
    | .unint0 => 0
    | .unint1 => 0
    | .integ0 => 1
    | .integ1 => 1

theorem transition_levels_shift :
    let gs : List (List TransitionUnit) := [[.unint0, .unint1], [.integ0, .integ1]]
    SelectionLevels.concordWithin gs (transitionGen.offspringNumber 3) (transitionGen.amount 3) = 0 ∧
    SelectionLevels.discordWithin gs (transitionGen.offspringNumber 3) (transitionGen.amount 3) = 0 ∧
    SelectionLevels.discordAmong gs (transitionGen.offspringNumber 3) (transitionGen.amount 3) = 0 ∧
    SelectionLevels.concordAmong gs (transitionGen.offspringNumber 3) (transitionGen.amount 3) = 4 ∧
    0 < SelectionLevels.concordAmong gs (transitionGen.offspringNumber 3) (transitionGen.amount 3) ∧
    transitionGen.Raises 3 := by
  intro gs
  have hFam3 : transitionGen.family 3 = [.unint0, .unint1, .integ0, .integ1] := rfl
  have hShift := compositional_transition_shifts_selection transitionGen (m := 2)
    [[.unint0, .unint1], [.integ0, .integ1]] hFam3.symm
    (fun g mg => by
      match mem_cons_cases mg with
      | .inl h => subst h; rfl
      | .inr mg' => match mem_cons_cases mg' with
        | .inl h => subst h; rfl
        | .inr no => nomatch no)
    (fun p _ k mk => by
      match p with
      | .unint0 => nomatch mk
      | .unint1 => nomatch mk
      | .integ0 => match mem_cons_cases mk with | .inl h => subst h; rfl | .inr no => nomatch no
      | .integ1 => match mem_cons_cases mk with | .inl h => subst h; rfl | .inr no => nomatch no)
    (fun g h mg mh hLess => by
      match mem_cons_cases mg with
      | .inl hg =>
        subst hg
        match mem_cons_cases mh with
        | .inl hh => subst hh; exact absurd hLess (Nat.lt_irrefl 0)
        | .inr mh' => match mem_cons_cases mh' with
          | .inl hh => subst hh; exact absurd hLess (Nat.not_lt_of_le (Nat.zero_le 2))
          | .inr no => nomatch no
      | .inr mg' => match mem_cons_cases mg' with
        | .inl hg =>
          subst hg
          match mem_cons_cases mh with
          | .inl hh => subst hh; rfl
          | .inr mh' => match mem_cons_cases mh' with
            | .inl hh => subst hh; exact absurd hLess (Nat.lt_irrefl 2)
            | .inr no => nomatch no
        | .inr no => nomatch no)
    (fun g mg _ => match mem_cons_cases mg with
      | .inl h => ⟨0, fun p mp => by subst h; match mem_cons_cases mp with
        | .inl hp => subst hp; rfl
        | .inr mp' => match mem_cons_cases mp' with | .inl hp => subst hp; rfl | .inr no => nomatch no⟩
      | .inr mg' => match mem_cons_cases mg' with
        | .inl h => ⟨1, fun p mp => by subst h; match mem_cons_cases mp with
          | .inl hp => subst hp; rfl
          | .inr mp' => match mem_cons_cases mp' with | .inl hp => subst hp; rfl | .inr no => nomatch no⟩
        | .inr no => nomatch no)
    ⟨[.integ0, .integ1], [.unint0, .unint1], .tail _ (.head []), .head _, by decide, by decide⟩
  exact ⟨hShift.1, hShift.2.1, hShift.2.2.1, rfl, hShift.2.2.2.1, hShift.2.2.2.2⟩

end MajorTransitionWitness

end EvolutionaryDrawdown

end Becoming
