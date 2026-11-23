import Becoming.Continuation
import Becoming.WayUnderARule
import Becoming.Stock

/-!
# Unclamped Stock–Flow Bridge (`Becoming.StockFlowBridge`)

AI-written (Milestone 1C, 23 November 2026). Does NOT modify `LineOnAStock.lean` or
`WayUnderARule.lean`, and NEVER clamps overdraws with `min taken x`.

## What this module establishes

1. **Finite-horizon drawdown trap (`Becoming.Flow`)**:
   - `Flow.held_below_within` and `Flow.never_returns_below_within`: localized finite-horizon
     forms of `Flow.held_below` / `Flow.never_returns_below` requiring `below : W.level T c < m`
     and balance/non-restoration only over `[T, T + N)`.
2. **Pre-overdraw bound under rule feedback (`Becoming.WayUnderARule`)**:
   - `WayUnderARule.ReachUnit`, `WayUnderARule.Needing`, `WayUnderARule.reachUnit_course`,
     `WayUnderARule.taken_below`, and `WayUnderARule.unending_taken_below`: under `FromNothing giving`
     and positive needs on all rule-reachable units, `Goes need (course ... s (n + 1))` implies
     `LineOnAStock.taken use (course ... s n).1.1 < (course ... s n).2`.
3. **Unclamped `Web Unit Unit` + `Flow Unit Unit` embeddings (`Becoming.StockFlowBridge`)**:
   - Shared single-condition carrier (`unitWeb`, `unitFlow`, `unitBalancesOn_of_le`,
     `unitAccumulatesOn_of_balances`, `unitNeverReturnsBelowWithin`).
   - Exact embeddings `(lineWeb, lineFlow)` for `LineOnAStock` and `(wayWeb, wayFlow)` for
     `WayUnderARule`, proving:
     - `BalancesOn [()]` from explicit `within` bounds AND from `FromNothing` + `Needing` + `Goes`
       on `T ≤ t ≤ T + N` inclusive (`line_balancesOn_of_goes`, `way_balancesOn_of_goes`),
     - global `Flow.Balances` on unending courses (`line_balances_of_unending`, `way_balances_of_unending`),
     - stretch conservation recovering `LineOnAStock.account` and `LineOnAStock.account_unending`
       from `Flow.accumulates_on` / `Flow.Balances.accumulates`, and
     - finite-horizon drawdown traps via `Flow.never_returns_below_within`.
4. **Constant-draw correspondence with `RegimeMargin.Coupled.Indexed.step`**:
   - Under `Drawn.whole` on `ι := Unit` (`coupled_indexed_step_whole_eq`), where every met step keeps
     consumption constant (`even` for `LineOnAStock`, rule-evenness / `¬ favours` via
     `WayUnderARule.taken_kept` for `WayUnderARule`), the scalar stock trajectory agrees verbatim
     with `(Law.run (RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole ...) _).state k ()`.

Every declaration has an empty axiom report and zero `sorry`.
-/

namespace Becoming

/-! ## 1. Finite-horizon drawdown trap in `Becoming.Flow` -/

namespace Flow

/-- Finite-horizon localization of `Flow.held_below`: balance on `[c]` and `given ≤ taken` below
    `m` for `T ≤ t < T + N` hold the level at or below `W.level T c` for all `n ≤ N`. -/
theorem held_below_within {F C : Type} {L : Flow F C} {W : Web F C} {m T N : Nat} {c : C}
    (balances : ∀ t, T ≤ t → t < T + N → L.BalancesOn W [c] t)
    (noRaise : ∀ t, T ≤ t → t < T + N → W.level t c < m → L.given t c ≤ L.taken t c)
    (below : W.level T c < m) : ∀ n, n ≤ N → W.level (T + n) c ≤ W.level T c
  | 0, _ => Nat.le_refl _
  | n + 1, le =>
    have before : W.level (T + n) c ≤ W.level T c :=
      held_below_within balances noRaise below n (Nat.le_trans (Nat.le_succ n) le)
    have ht_ge : T ≤ T + n := Nat.le_add_right T n
    have ht_lt : T + n < T + N := Nat.add_lt_add_left le T
    Nat.le_trans
      (le_of_add_le_add_right (L.taken (T + n) c)
        (Nat.le_trans (Nat.le_of_eq (balances (T + n) ht_ge ht_lt c (.head [])))
          (Nat.add_le_add_left
            (noRaise (T + n) ht_ge ht_lt (Nat.lt_of_le_of_lt before below)) _)))
      before

/-- Finite-horizon localization of `Flow.never_returns_below`: once `below : W.level T c < m`,
    under `[T, T + N)` balance and no-raise below `m`, the level stays below `m` for all `n ≤ N`. -/
theorem never_returns_below_within {F C : Type} {L : Flow F C} {W : Web F C} {m T N : Nat} {c : C}
    (balances : ∀ t, T ≤ t → t < T + N → L.BalancesOn W [c] t)
    (noRaise : ∀ t, T ≤ t → t < T + N → W.level t c < m → L.given t c ≤ L.taken t c)
    (below : W.level T c < m) (n : Nat) (le : n ≤ N) : W.level (T + n) c < m :=
  Nat.lt_of_le_of_lt (held_below_within balances noRaise below n le) below

end Flow

/-! ## 2. Pre-overdraw strict bound in `Becoming.WayUnderARule` -/

namespace WayUnderARule

/-- Units reachable in `n` generations from initial way `w₀` under some sequence of rules in `R`. -/
inductive ReachUnit {U R : Type} (kids : R → U → List U) (w₀ : List U) : Nat → U → Prop
  | start {u : U} : u ∈ w₀ → ReachUnit kids w₀ 0 u
  | step {n : Nat} {g : R} {u v : U} :
      ReachUnit kids w₀ n u → v ∈ kids g u → ReachUnit kids w₀ (n + 1) v

/-- Every unit reachable along any sequence of rule generations from `w₀` needs something positive. -/
def Needing {U R : Type} (need : U → Nat) (kids : R → U → List U) (w₀ : List U) : Prop :=
  ∀ n u, ReachUnit kids w₀ n u → 0 < need u

/-- Every unit present in `(WayUnderARule.course ... s n).1.1` is reachable from `s.1.1` in `n` steps. -/
theorem reachUnit_course {U R : Type} {need : U → Nat} {kids : R → U → List U}
    {next : List U → R → R} {giving : Nat → Nat} {use : U → Nat} {s : (List U × R) × Nat} :
    ∀ (n : Nat) {u : U},
      u ∈ (course need kids next giving use s n).1.1 → ReachUnit kids s.1.1 n u
  | 0, _, mu => .start mu
  | n + 1, _, mu => by
    have hmem : _ ∈ LineOnAStock.after need (kids (course need kids next giving use s n).1.2)
        (course need kids next giving use s n).1.1 (course need kids next giving use s n).2 := mu
    match LineOnAStock.mem_after_iff.mp hmem with
    | ⟨p, mp, _, mk⟩ => exact .step (reachUnit_course n mp) mk

/-- Pre-overdraw strict bound for `WayUnderARule`: under `FromNothing giving` and `Needing`,
    where some unit's need is met at step `n + 1`, the total taken at step `n` is strictly less
    than the level at step `n`. -/
theorem taken_below {U R : Type} {need : U → Nat} {kids : R → U → List U}
    {next : List U → R → R} {giving : Nat → Nat} {use : U → Nat}
    (nothing : RegimeMargin.FromNothing giving) {s : (List U × R) × Nat}
    (needs : Needing need kids s.1.1) {n : Nat}
    (goes : Goes need (course need kids next giving use s (n + 1))) :
    LineOnAStock.taken use (course need kids next giving use s n).1.1 <
      (course need kids next giving use s n).2 :=
  (Nat.lt_or_ge (LineOnAStock.taken use (course need kids next giving use s n).1.1)
      (course need kids next giving use s n).2).elim id fun ge =>
    match goes with
    | ⟨u, mu, le⟩ =>
      have hzero : (course need kids next giving use s (n + 1)).2 = 0 :=
        LineOnAStock.step_zero nothing ge
      absurd (Nat.le_trans le (Nat.le_of_eq hzero))
        (Nat.not_le_of_gt (needs (n + 1) u (reachUnit_course (n + 1) mu)))

/-- On an unending `WayUnderARule.net`, taken is strictly below level at every step. -/
theorem unending_taken_below {U R : Type} {need : U → Nat} {kids : R → U → List U}
    {next : List U → R → R} {giving : Nat → Nat} {use : U → Nat}
    (nothing : RegimeMargin.FromNothing giving) {s : (List U × R) × Nat}
    (needs : Needing need kids s.1.1)
    (never : «不穷» (net need kids next giving use) «一» s) (n : Nat) :
    LineOnAStock.taken use (course need kids next giving use s n).1.1 <
      (course need kids next giving use s n).2 :=
  taken_below nothing needs (Law.stepWhile_unending_iff.mp never (n + 1))

end WayUnderARule

/-! ## 3. Shared unclamped `Web Unit Unit` + `Flow Unit Unit` embedding and bridges -/

namespace StockFlowBridge

/-- Single-condition `Web Unit Unit` tracking a scalar stock trajectory `levelFn : Nat → Nat`. -/
def unitWeb (levelFn : Nat → Nat) : Web Unit Unit where
  level t _ := levelFn t
  active _ _ := True
  requires _ _ _ := True
  need _ _ _ := 1
  draws _ _ _ := True

/-- Single-condition `Flow Unit Unit` with exact unclamped extraction `takeFn` and return `giveFn`. -/
def unitFlow (takeFn giveFn : Nat → Nat) : Flow Unit Unit where
  present _ := [()]
  take t _ _ := takeFn t
  give t _ _ := giveFn t

theorem unitFlow_taken (takeFn giveFn : Nat → Nat) (t : Nat) :
    (unitFlow takeFn giveFn).taken t () = takeFn t :=
  Nat.add_zero (takeFn t)

theorem unitFlow_given (takeFn giveFn : Nat → Nat) (t : Nat) :
    (unitFlow takeFn giveFn).given t () = giveFn t :=
  Nat.add_zero (giveFn t)

theorem unitFlow_uptake (takeFn giveFn : Nat → Nat) (t : Nat) :
    (unitFlow takeFn giveFn).uptake [()] t = takeFn t :=
  (Nat.add_zero _).trans (unitFlow_taken takeFn giveFn t)

theorem unitFlow_replenishment (takeFn giveFn : Nat → Nat) (t : Nat) :
    (unitFlow takeFn giveFn).replenishment [()] t = giveFn t :=
  (Nat.add_zero _).trans (unitFlow_given takeFn giveFn t)

theorem unitWeb_stock (levelFn : Nat → Nat) (k : Nat) :
    (unitWeb levelFn).stock [()] k = levelFn k :=
  Nat.add_zero (levelFn k)

section StockUnification

universe u_s

/-- `Run.stockFlow` is definitionally `unitFlow` applied to the run's action-indexed draw/replenish. -/
theorem stockFlow_eq_unitFlow {S : Type u_s} {A : Type} {P : Generative.Process S A}
    (r : Run P) (draw replenish : A → Nat) :
    Run.stockFlow r draw replenish =
      unitFlow (fun t => draw (r.act t)) (fun t => replenish (r.act t)) :=
  rfl

/-- `Run.stockWeb` and `unitWeb` share identical levels at every step. -/
theorem stockWeb_level_eq_unitWeb {S : Type u_s} {A : Type} {P : Generative.Process S A}
    (r : Run P) (σ : S → Nat) (t : Nat) (c : Unit) :
    (Run.stockWeb r σ).level t c = (unitWeb (fun k => σ (r.state k))).level t c :=
  rfl

/-- Global flow balance of `Run.stockFlow` on `Run.stockWeb` is definitionally that of `unitFlow` on `unitWeb`. -/
theorem stockFlow_balances_iff_unitFlow_balances {S : Type u_s} {A : Type}
    {P : Generative.Process S A} (r : Run P) (σ : S → Nat) (draw replenish : A → Nat) :
    (Run.stockFlow r draw replenish).Balances (Run.stockWeb r σ) ↔
      (unitFlow (fun t => draw (r.act t)) (fun t => replenish (r.act t))).Balances
        (unitWeb (fun t => σ (r.state t))) :=
  Iff.rfl

/-- Pre-overdraw step embedding into `Becoming.Stock.process` (with `A := Nat`, `draw := takeFn`,
    `replenish t := giving (levelFn t - takeFn t)`). -/
theorem stockProcess_step_of_le {levelFn takeFn giving : Nat → Nat} {t : Nat}
    (step_eq : levelFn (t + 1) = RegimeMargin.step giving (takeFn t) (levelFn t))
    (within : takeFn t ≤ levelFn t) :
    (Stock.process takeFn (fun k => giving (levelFn k - takeFn k))).step
      (levelFn t) t (levelFn (t + 1)) :=
  step_eq.symm ▸ Stock.process_step (draw := takeFn)
    (replenish := fun k => giving (levelFn k - takeFn k)) within

/-- Exact unclamped boundary: at any overdraw step (`levelFn t < takeFn t`), `Stock.process` refuses every step. -/
theorem not_stockProcess_step_of_overdraw {levelFn takeFn giving : Nat → Nat} {t m : Nat}
    (over : levelFn t < takeFn t) :
    ¬ (Stock.process takeFn (fun k => giving (levelFn k - takeFn k))).step (levelFn t) t m :=
  fun h => Nat.not_le_of_gt over h.1

/-- Any finite pre-overdraw stretch `[T, T + N)` is a `Generative.Trace` of `Stock.process` along `steps T N`. -/
theorem stockProcess_trace_of_within {levelFn takeFn giving : Nat → Nat} :
    ∀ (N T : Nat),
      (∀ t, T ≤ t → t < T + N →
        levelFn (t + 1) = RegimeMargin.step giving (takeFn t) (levelFn t)) →
      (∀ t, T ≤ t → t < T + N → takeFn t ≤ levelFn t) →
      Generative.Trace
        (Stock.process takeFn (fun k => giving (levelFn k - takeFn k)))
        (levelFn T) (steps T N) (levelFn (T + N))
  | 0, T, _, _ => .nil (levelFn T)
  | N + 1, T, step_eq, within =>
    .cons
      (stockProcess_step_of_le
        (step_eq T (Nat.le_refl T) (Nat.lt_add_of_pos_right (Nat.succ_pos N)))
        (within T (Nat.le_refl T) (Nat.lt_add_of_pos_right (Nat.succ_pos N))))
      (Eq.subst
        (motive := fun m => Generative.Trace _ (levelFn (T + 1)) (steps (T + 1) N) (levelFn m))
        (Nat.add_right_comm T 1 N)
        (stockProcess_trace_of_within N (T + 1)
          (fun t hge hlt => step_eq t (Nat.le_trans (Nat.le_succ T) hge)
            (Nat.lt_of_lt_of_le hlt (Nat.le_of_eq (Nat.add_right_comm T 1 N))))
          (fun t hge hlt => within t (Nat.le_trans (Nat.le_succ T) hge)
            (Nat.lt_of_lt_of_le hlt (Nat.le_of_eq (Nat.add_right_comm T 1 N))))))

/-- Finite pre-overdraw coverage (`Stock.Covered`) via `Stock.feasible_iff_covered`. -/
theorem stockCovered_of_within {levelFn takeFn giving : Nat → Nat} {T N : Nat}
    (step_eq : ∀ t, T ≤ t → t < T + N →
      levelFn (t + 1) = RegimeMargin.step giving (takeFn t) (levelFn t))
    (within : ∀ t, T ≤ t → t < T + N → takeFn t ≤ levelFn t) :
    Stock.Covered takeFn (fun k => giving (levelFn k - takeFn k)) (levelFn T) (steps T N) :=
  (Stock.feasible_iff_covered (steps T N) (levelFn T)).mp
    ⟨levelFn (T + N), stockProcess_trace_of_within N T step_eq within⟩

/-- Closed-form prefix coverage on `[T, T + N)` via `Stock.covered_iff_prefix`. -/
theorem stockPrefix_covered_of_within {levelFn takeFn giving : Nat → Nat} {T N : Nat}
    (step_eq : ∀ t, T ≤ t → t < T + N →
      levelFn (t + 1) = RegimeMargin.step giving (takeFn t) (levelFn t))
    (within : ∀ t, T ≤ t → t < T + N → takeFn t ≤ levelFn t) :
    ∀ u a v, steps T N = u ++ a :: v →
      total u takeFn + takeFn a ≤
        levelFn T + total u (fun k => giving (levelFn k - takeFn k)) :=
  (Stock.covered_iff_prefix (steps T N) (levelFn T)).mp (stockCovered_of_within step_eq within)

/-- Global pre-overdraw trajectory packaged as a `Run (Stock.process ...)`. -/
def stockRun_of_within {levelFn takeFn giving : Nat → Nat}
    (step_eq : ∀ t, levelFn (t + 1) = RegimeMargin.step giving (takeFn t) (levelFn t))
    (within : ∀ t, takeFn t ≤ levelFn t) :
    Run (Stock.process takeFn (fun k => giving (levelFn k - takeFn k))) where
  state := levelFn
  act := id
  step t := stockProcess_step_of_le (step_eq t) (within t)

/-- Global `unitFlow` balance directly from `Run.stockFlow_balances (Stock.process_balanced _ _)`. -/
theorem unitBalances_of_stockRun {levelFn takeFn giving : Nat → Nat}
    (step_eq : ∀ t, levelFn (t + 1) = RegimeMargin.step giving (takeFn t) (levelFn t))
    (within : ∀ t, takeFn t ≤ levelFn t) :
    (unitFlow takeFn (fun k => giving (levelFn k - takeFn k))).Balances (unitWeb levelFn) :=
  (stockFlow_balances_iff_unitFlow_balances (stockRun_of_within step_eq within) id _ _).mp
    (Run.stockFlow_balances (Stock.process_balanced _ _) (stockRun_of_within step_eq within))

end StockUnification

/-- Unclamped single-step conservation lemma shared by both `LineOnAStock` and `WayUnderARule`. -/
theorem unitBalancesOn_of_le {levelFn takeFn giving : Nat → Nat} {t : Nat}
    (step_eq : levelFn (t + 1) = RegimeMargin.step giving (takeFn t) (levelFn t))
    (within : takeFn t ≤ levelFn t) :
    (unitFlow takeFn (fun k => giving (levelFn k - takeFn k))).BalancesOn (unitWeb levelFn) [()] t := by
  intro c _
  cases c
  exact Stock.process_balanced takeFn (fun k => giving (levelFn k - takeFn k))
    _ _ _ (stockProcess_step_of_le step_eq within)

/-- Unclamped finite-stretch accumulation from `Flow.accumulates_on` collapsed to scalar form. -/
theorem unitAccumulates_of_balances {levelFn takeFn giveFn : Nat → Nat} {T N : Nat}
    (bal : ∀ t, T ≤ t → t < T + N → (unitFlow takeFn giveFn).BalancesOn (unitWeb levelFn) [()] t) :
    levelFn (T + N) + total (steps T N) takeFn = levelFn T + total (steps T N) giveFn := by
  have hacc := Flow.accumulates_on (L := unitFlow takeFn giveFn) (W := unitWeb levelFn)
    (cs := [()]) T N bal
  rw [unitWeb_stock, unitWeb_stock] at hacc
  have hu : total (steps T N) ((unitFlow takeFn giveFn).uptake [()]) = total (steps T N) takeFn :=
    total_congr (fun t => unitFlow_uptake takeFn giveFn t) (steps T N)
  have hr : total (steps T N) ((unitFlow takeFn giveFn).replenishment [()]) = total (steps T N) giveFn :=
    total_congr (fun t => unitFlow_replenishment takeFn giveFn t) (steps T N)
  rw [hu, hr] at hacc
  exact hacc

/-- Unclamped finite-stretch accumulation from `Flow.Balances.accumulates` at `[0, N)`. -/
theorem unitAccumulates_of_global_balances {levelFn takeFn giveFn : Nat → Nat} {N : Nat}
    (bal : (unitFlow takeFn giveFn).Balances (unitWeb levelFn)) :
    levelFn N + total (steps 0 N) takeFn = levelFn 0 + total (steps 0 N) giveFn := by
  have hacc := bal.accumulates [()] 0 N
  rw [unitWeb_stock, unitWeb_stock, Nat.zero_add,
    total_congr (fun t => unitFlow_uptake takeFn giveFn t) (steps 0 N),
    total_congr (fun t => unitFlow_replenishment takeFn giveFn t) (steps 0 N)] at hacc
  exact hacc

/-- Unclamped finite-horizon drawdown trap via `Flow.never_returns_below_within`. -/
theorem unitNeverReturnsBelowWithin {levelFn takeFn giveFn : Nat → Nat} {m T N : Nat}
    (bal : ∀ t, T ≤ t → t < T + N → (unitFlow takeFn giveFn).BalancesOn (unitWeb levelFn) [()] t)
    (noRaise : ∀ t, T ≤ t → t < T + N → levelFn t < m → giveFn t ≤ takeFn t)
    (below : (unitWeb levelFn).level T () < m) :
    ∀ n, n ≤ N → (unitWeb levelFn).level (T + n) () < m :=
  Flow.never_returns_below_within bal
    (fun t hT hN low => by
      rw [unitFlow_given, unitFlow_taken]
      exact noRaise t hT hN low)
    below

/-! ### `LineOnAStock` unclamped embedding -/

section LineBridge

variable {U : Type} (need : U → Nat) (kids : U → List U) (giving : Nat → Nat) (use : U → Nat)
  (s : List U × Nat)

/-- Unclamped `Web Unit Unit` reading of a `LineOnAStock.course`. -/
def lineWeb : Web Unit Unit :=
  unitWeb fun t => (LineOnAStock.course need kids giving use s t).2

/-- Unclamped `Flow Unit Unit` reading of a `LineOnAStock.course`. -/
def lineFlow : Flow Unit Unit :=
  unitFlow
    (fun t => LineOnAStock.taken use (LineOnAStock.course need kids giving use s t).1)
    (fun t => giving ((LineOnAStock.course need kids giving use s t).2 -
      LineOnAStock.taken use (LineOnAStock.course need kids giving use s t).1))

variable {need kids giving use s}

theorem line_taken_lt_of_goes {T N : Nat} (nothing : RegimeMargin.FromNothing giving)
    (needs : LineOnAStock.Needing need kids s.1)
    (goes : ∀ t, T ≤ t → t ≤ T + N →
      LineOnAStock.Goes need (LineOnAStock.course need kids giving use s t))
    {t : Nat} (ht_ge : T ≤ t) (ht_lt : t < T + N) :
    LineOnAStock.taken use (LineOnAStock.course need kids giving use s t).1 <
      (LineOnAStock.course need kids giving use s t).2 :=
  LineOnAStock.taken_below nothing needs
    (goes (t + 1) (Nat.le_trans ht_ge (Nat.le_succ t)) ht_lt)

theorem line_balancesOn_of_within {T N : Nat}
    (within : ∀ t, T ≤ t → t < T + N →
      LineOnAStock.taken use (LineOnAStock.course need kids giving use s t).1 ≤
        (LineOnAStock.course need kids giving use s t).2) :
    ∀ t, T ≤ t → t < T + N →
      (lineFlow need kids giving use s).BalancesOn (lineWeb need kids giving use s) [()] t :=
  fun t ht_ge ht_lt => unitBalancesOn_of_le (t := t) rfl (within t ht_ge ht_lt)

theorem line_balancesOn_of_goes {T N : Nat} (nothing : RegimeMargin.FromNothing giving)
    (needs : LineOnAStock.Needing need kids s.1)
    (goes : ∀ t, T ≤ t → t ≤ T + N →
      LineOnAStock.Goes need (LineOnAStock.course need kids giving use s t)) :
    ∀ t, T ≤ t → t < T + N →
      (lineFlow need kids giving use s).BalancesOn (lineWeb need kids giving use s) [()] t :=
  line_balancesOn_of_within fun _ ht_ge ht_lt =>
    Nat.le_of_lt (line_taken_lt_of_goes nothing needs goes ht_ge ht_lt)

theorem line_balances_of_unending (nothing : RegimeMargin.FromNothing giving)
    (needs : LineOnAStock.Needing need kids s.1)
    (never : «不穷» (LineOnAStock.net need kids giving use) «一» s) :
    (lineFlow need kids giving use s).Balances (lineWeb need kids giving use s) :=
  unitBalances_of_stockRun (fun _ => rfl) fun t =>
    Nat.le_of_lt (LineOnAStock.unending_taken_below nothing needs never t)

theorem line_accumulates_of_within {T N : Nat}
    (within : ∀ t, T ≤ t → t < T + N →
      LineOnAStock.taken use (LineOnAStock.course need kids giving use s t).1 ≤
        (LineOnAStock.course need kids giving use s t).2) :
    (LineOnAStock.course need kids giving use s (T + N)).2 +
        total (steps T N) (fun t => LineOnAStock.taken use (LineOnAStock.course need kids giving use s t).1) =
      (LineOnAStock.course need kids giving use s T).2 +
        total (steps T N) (fun t => giving ((LineOnAStock.course need kids giving use s t).2 -
          LineOnAStock.taken use (LineOnAStock.course need kids giving use s t).1)) :=
  unitAccumulates_of_balances (line_balancesOn_of_within within)

theorem line_accumulates_of_goes {T N : Nat} (nothing : RegimeMargin.FromNothing giving)
    (needs : LineOnAStock.Needing need kids s.1)
    (goes : ∀ t, T ≤ t → t ≤ T + N →
      LineOnAStock.Goes need (LineOnAStock.course need kids giving use s t)) :
    (LineOnAStock.course need kids giving use s (T + N)).2 +
        total (steps T N) (fun t => LineOnAStock.taken use (LineOnAStock.course need kids giving use s t).1) =
      (LineOnAStock.course need kids giving use s T).2 +
        total (steps T N) (fun t => giving ((LineOnAStock.course need kids giving use s t).2 -
          LineOnAStock.taken use (LineOnAStock.course need kids giving use s t).1)) :=
  unitAccumulates_of_balances (line_balancesOn_of_goes nothing needs goes)

/-- Recovers `LineOnAStock.account` directly via `Flow.accumulates_on` at `T = 0`. -/
theorem line_account_of_goes (N : Nat) (nothing : RegimeMargin.FromNothing giving)
    (needs : LineOnAStock.Needing need kids s.1)
    (goes : ∀ t, 0 ≤ t → t ≤ N →
      LineOnAStock.Goes need (LineOnAStock.course need kids giving use s t)) :
    (LineOnAStock.course need kids giving use s N).2 +
        total (steps 0 N) (fun t => LineOnAStock.taken use (LineOnAStock.course need kids giving use s t).1) =
      s.2 + total (steps 0 N) (fun t => giving ((LineOnAStock.course need kids giving use s t).2 -
        LineOnAStock.taken use (LineOnAStock.course need kids giving use s t).1)) := by
  have hacc := line_accumulates_of_goes (T := 0) (N := N) nothing needs
    (fun t h0 hN => goes t h0 (Nat.le_trans hN (Nat.le_of_eq (Nat.zero_add N))))
  rw [Nat.zero_add] at hacc
  exact hacc

/-- Recovers `LineOnAStock.account_unending` directly via `Flow.Balances.accumulates`. -/
theorem line_account_unending_via_flow (nothing : RegimeMargin.FromNothing giving)
    (needs : LineOnAStock.Needing need kids s.1)
    (never : «不穷» (LineOnAStock.net need kids giving use) «一» s) (N : Nat) :
    (LineOnAStock.course need kids giving use s N).2 +
        total (steps 0 N) (fun t => LineOnAStock.taken use (LineOnAStock.course need kids giving use s t).1) =
      s.2 + total (steps 0 N) (fun t => giving ((LineOnAStock.course need kids giving use s t).2 -
        LineOnAStock.taken use (LineOnAStock.course need kids giving use s t).1)) :=
  unitAccumulates_of_global_balances (line_balances_of_unending nothing needs never)

theorem line_never_returns_below_within_of_within {m T N : Nat}
    (within : ∀ t, T ≤ t → t < T + N →
      LineOnAStock.taken use (LineOnAStock.course need kids giving use s t).1 ≤
        (LineOnAStock.course need kids giving use s t).2)
    (noRaise : ∀ t, T ≤ t → t < T + N →
      (lineWeb need kids giving use s).level t () < m →
      (lineFlow need kids giving use s).given t () ≤
        (lineFlow need kids giving use s).taken t ())
    (below : (lineWeb need kids giving use s).level T () < m) :
    ∀ n, n ≤ N → (lineWeb need kids giving use s).level (T + n) () < m :=
  Flow.never_returns_below_within (line_balancesOn_of_within within) noRaise below

theorem line_never_returns_below_within {m T N : Nat}
    (nothing : RegimeMargin.FromNothing giving)
    (needs : LineOnAStock.Needing need kids s.1)
    (goes : ∀ t, T ≤ t → t ≤ T + N →
      LineOnAStock.Goes need (LineOnAStock.course need kids giving use s t))
    (noRaise : ∀ t, T ≤ t → t < T + N →
      (lineWeb need kids giving use s).level t () < m →
      (lineFlow need kids giving use s).given t () ≤
        (lineFlow need kids giving use s).taken t ())
    (below : (lineWeb need kids giving use s).level T () < m) :
    ∀ n, n ≤ N → (lineWeb need kids giving use s).level (T + n) () < m :=
  Flow.never_returns_below_within (line_balancesOn_of_goes nothing needs goes) noRaise below

end LineBridge

/-! ### `WayUnderARule` unclamped embedding -/

section WayBridge

variable {U R : Type} (need : U → Nat) (kids : R → U → List U) (next : List U → R → R)
  (giving : Nat → Nat) (use : U → Nat) (s : (List U × R) × Nat)

/-- Unclamped `Web Unit Unit` reading of a `WayUnderARule.course`. -/
def wayWeb : Web Unit Unit :=
  unitWeb fun t => (WayUnderARule.course need kids next giving use s t).2

/-- Unclamped `Flow Unit Unit` reading of a `WayUnderARule.course`. -/
def wayFlow : Flow Unit Unit :=
  unitFlow
    (fun t => LineOnAStock.taken use (WayUnderARule.course need kids next giving use s t).1.1)
    (fun t => giving ((WayUnderARule.course need kids next giving use s t).2 -
      LineOnAStock.taken use (WayUnderARule.course need kids next giving use s t).1.1))

variable {need kids next giving use s}

theorem way_taken_lt_of_goes {T N : Nat} (nothing : RegimeMargin.FromNothing giving)
    (needs : WayUnderARule.Needing need kids s.1.1)
    (goes : ∀ t, T ≤ t → t ≤ T + N →
      WayUnderARule.Goes need (WayUnderARule.course need kids next giving use s t))
    {t : Nat} (ht_ge : T ≤ t) (ht_lt : t < T + N) :
    LineOnAStock.taken use (WayUnderARule.course need kids next giving use s t).1.1 <
      (WayUnderARule.course need kids next giving use s t).2 :=
  WayUnderARule.taken_below nothing needs
    (goes (t + 1) (Nat.le_trans ht_ge (Nat.le_succ t)) ht_lt)

theorem way_balancesOn_of_within {T N : Nat}
    (within : ∀ t, T ≤ t → t < T + N →
      LineOnAStock.taken use (WayUnderARule.course need kids next giving use s t).1.1 ≤
        (WayUnderARule.course need kids next giving use s t).2) :
    ∀ t, T ≤ t → t < T + N →
      (wayFlow need kids next giving use s).BalancesOn (wayWeb need kids next giving use s) [()] t :=
  fun t ht_ge ht_lt => unitBalancesOn_of_le (t := t) rfl (within t ht_ge ht_lt)

theorem way_balancesOn_of_goes {T N : Nat} (nothing : RegimeMargin.FromNothing giving)
    (needs : WayUnderARule.Needing need kids s.1.1)
    (goes : ∀ t, T ≤ t → t ≤ T + N →
      WayUnderARule.Goes need (WayUnderARule.course need kids next giving use s t)) :
    ∀ t, T ≤ t → t < T + N →
      (wayFlow need kids next giving use s).BalancesOn (wayWeb need kids next giving use s) [()] t :=
  way_balancesOn_of_within fun _ ht_ge ht_lt =>
    Nat.le_of_lt (way_taken_lt_of_goes nothing needs goes ht_ge ht_lt)

theorem way_balances_of_unending (nothing : RegimeMargin.FromNothing giving)
    (needs : WayUnderARule.Needing need kids s.1.1)
    (never : «不穷» (WayUnderARule.net need kids next giving use) «一» s) :
    (wayFlow need kids next giving use s).Balances (wayWeb need kids next giving use s) :=
  unitBalances_of_stockRun (fun _ => rfl) fun t =>
    Nat.le_of_lt (WayUnderARule.unending_taken_below nothing needs never t)

theorem way_accumulates_of_within {T N : Nat}
    (within : ∀ t, T ≤ t → t < T + N →
      LineOnAStock.taken use (WayUnderARule.course need kids next giving use s t).1.1 ≤
        (WayUnderARule.course need kids next giving use s t).2) :
    (WayUnderARule.course need kids next giving use s (T + N)).2 +
        total (steps T N) (fun t => LineOnAStock.taken use
          (WayUnderARule.course need kids next giving use s t).1.1) =
      (WayUnderARule.course need kids next giving use s T).2 +
        total (steps T N) (fun t => giving ((WayUnderARule.course need kids next giving use s t).2 -
          LineOnAStock.taken use (WayUnderARule.course need kids next giving use s t).1.1)) :=
  unitAccumulates_of_balances (way_balancesOn_of_within within)

theorem way_accumulates_of_goes {T N : Nat} (nothing : RegimeMargin.FromNothing giving)
    (needs : WayUnderARule.Needing need kids s.1.1)
    (goes : ∀ t, T ≤ t → t ≤ T + N →
      WayUnderARule.Goes need (WayUnderARule.course need kids next giving use s t)) :
    (WayUnderARule.course need kids next giving use s (T + N)).2 +
        total (steps T N) (fun t => LineOnAStock.taken use
          (WayUnderARule.course need kids next giving use s t).1.1) =
      (WayUnderARule.course need kids next giving use s T).2 +
        total (steps T N) (fun t => giving ((WayUnderARule.course need kids next giving use s t).2 -
          LineOnAStock.taken use (WayUnderARule.course need kids next giving use s t).1.1)) :=
  unitAccumulates_of_balances (way_balancesOn_of_goes nothing needs goes)

theorem way_account_of_goes (N : Nat) (nothing : RegimeMargin.FromNothing giving)
    (needs : WayUnderARule.Needing need kids s.1.1)
    (goes : ∀ t, 0 ≤ t → t ≤ N →
      WayUnderARule.Goes need (WayUnderARule.course need kids next giving use s t)) :
    (WayUnderARule.course need kids next giving use s N).2 +
        total (steps 0 N) (fun t => LineOnAStock.taken use
          (WayUnderARule.course need kids next giving use s t).1.1) =
      s.2 + total (steps 0 N) (fun t => giving ((WayUnderARule.course need kids next giving use s t).2 -
        LineOnAStock.taken use (WayUnderARule.course need kids next giving use s t).1.1)) := by
  have hacc := way_accumulates_of_goes (T := 0) (N := N) nothing needs
    (fun t h0 hN => goes t h0 (Nat.le_trans hN (Nat.le_of_eq (Nat.zero_add N))))
  rw [Nat.zero_add] at hacc
  exact hacc

theorem way_account_unending (nothing : RegimeMargin.FromNothing giving)
    (needs : WayUnderARule.Needing need kids s.1.1)
    (never : «不穷» (WayUnderARule.net need kids next giving use) «一» s) (N : Nat) :
    (WayUnderARule.course need kids next giving use s N).2 +
        total (steps 0 N) (fun t => LineOnAStock.taken use
          (WayUnderARule.course need kids next giving use s t).1.1) =
      s.2 + total (steps 0 N) (fun t => giving ((WayUnderARule.course need kids next giving use s t).2 -
        LineOnAStock.taken use (WayUnderARule.course need kids next giving use s t).1.1)) :=
  unitAccumulates_of_global_balances (way_balances_of_unending nothing needs never)

theorem way_never_returns_below_within_of_within {m T N : Nat}
    (within : ∀ t, T ≤ t → t < T + N →
      LineOnAStock.taken use (WayUnderARule.course need kids next giving use s t).1.1 ≤
        (WayUnderARule.course need kids next giving use s t).2)
    (noRaise : ∀ t, T ≤ t → t < T + N →
      (wayWeb need kids next giving use s).level t () < m →
      (wayFlow need kids next giving use s).given t () ≤
        (wayFlow need kids next giving use s).taken t ())
    (below : (wayWeb need kids next giving use s).level T () < m) :
    ∀ n, n ≤ N → (wayWeb need kids next giving use s).level (T + n) () < m :=
  Flow.never_returns_below_within (way_balancesOn_of_within within) noRaise below

theorem way_never_returns_below_within {m T N : Nat}
    (nothing : RegimeMargin.FromNothing giving)
    (needs : WayUnderARule.Needing need kids s.1.1)
    (goes : ∀ t, T ≤ t → t ≤ T + N →
      WayUnderARule.Goes need (WayUnderARule.course need kids next giving use s t))
    (noRaise : ∀ t, T ≤ t → t < T + N →
      (wayWeb need kids next giving use s).level t () < m →
      (wayFlow need kids next giving use s).given t () ≤
        (wayFlow need kids next giving use s).taken t ())
    (below : (wayWeb need kids next giving use s).level T () < m) :
    ∀ n, n ≤ N → (wayWeb need kids next giving use s).level (T + n) () < m :=
  Flow.never_returns_below_within (way_balancesOn_of_goes nothing needs goes) noRaise below

end WayBridge

section StockUnificationRuns

/-- Unending `LineOnAStock.net` as a `Run (Stock.process ...)`. -/
def lineStockRun_of_unending {U : Type} {need : U → Nat} {kids : U → List U}
    {giving : Nat → Nat} {use : U → Nat} {s : List U × Nat}
    (nothing : RegimeMargin.FromNothing giving) (needs : LineOnAStock.Needing need kids s.1)
    (never : «不穷» (LineOnAStock.net need kids giving use) «一» s) :
    Run (Stock.process
      (fun t => LineOnAStock.taken use (LineOnAStock.course need kids giving use s t).1)
      (fun t => giving ((LineOnAStock.course need kids giving use s t).2 -
        LineOnAStock.taken use (LineOnAStock.course need kids giving use s t).1))) :=
  stockRun_of_within (fun _ => rfl) fun t =>
    Nat.le_of_lt (LineOnAStock.unending_taken_below nothing needs never t)

/-- Unending `WayUnderARule.net` as a `Run (Stock.process ...)`. -/
def wayStockRun_of_unending {U R : Type} {need : U → Nat} {kids : R → U → List U}
    {next : List U → R → R} {giving : Nat → Nat} {use : U → Nat} {s : (List U × R) × Nat}
    (nothing : RegimeMargin.FromNothing giving) (needs : WayUnderARule.Needing need kids s.1.1)
    (never : «不穷» (WayUnderARule.net need kids next giving use) «一» s) :
    Run (Stock.process
      (fun t => LineOnAStock.taken use (WayUnderARule.course need kids next giving use s t).1.1)
      (fun t => giving ((WayUnderARule.course need kids next giving use s t).2 -
        LineOnAStock.taken use (WayUnderARule.course need kids next giving use s t).1.1))) :=
  stockRun_of_within (fun _ => rfl) fun t =>
    Nat.le_of_lt (WayUnderARule.unending_taken_below nothing needs never t)

/-- Recurrence of replenishment from recurring drawing on unending `LineOnAStock` (`Run.replenishes_of_draws`). -/
theorem line_replenishes_of_draws {U : Type} {need : U → Nat} {kids : U → List U}
    {giving : Nat → Nat} {use : U → Nat} {s : List U × Nat}
    (nothing : RegimeMargin.FromNothing giving) (needs : LineOnAStock.Needing need kids s.1)
    (never : «不穷» (LineOnAStock.net need kids giving use) «一» s)
    (draws : ∀ N, ∃ n, N ≤ n ∧ 0 < LineOnAStock.taken use (LineOnAStock.course need kids giving use s n).1) :
    ∀ N, ∃ n, N ≤ n ∧ 0 < giving ((LineOnAStock.course need kids giving use s n).2 -
      LineOnAStock.taken use (LineOnAStock.course need kids giving use s n).1) :=
  Run.replenishes_of_draws (Stock.process_balanced _ _) (lineStockRun_of_unending nothing needs never) draws

/-- Bounded-stock equivalence of recurring draw & replenishment on unending `LineOnAStock` (`Run.draws_iff_replenishes`). -/
theorem line_draws_iff_replenishes {U : Type} {need : U → Nat} {kids : U → List U}
    {giving : Nat → Nat} {use : U → Nat} {s : List U × Nat}
    (nothing : RegimeMargin.FromNothing giving) (needs : LineOnAStock.Needing need kids s.1)
    (never : «不穷» (LineOnAStock.net need kids giving use) «一» s) {B : Nat}
    (bound : ∀ n, (LineOnAStock.course need kids giving use s n).2 ≤ B) :
    (∀ N, ∃ n, N ≤ n ∧ 0 < LineOnAStock.taken use (LineOnAStock.course need kids giving use s n).1) ↔
      (∀ N, ∃ n, N ≤ n ∧ 0 < giving ((LineOnAStock.course need kids giving use s n).2 -
        LineOnAStock.taken use (LineOnAStock.course need kids giving use s n).1)) :=
  Run.draws_iff_replenishes (Stock.process_balanced _ _) (lineStockRun_of_unending nothing needs never) bound

/-- Recurrence of replenishment from recurring drawing on unending `WayUnderARule` (`Run.replenishes_of_draws`). -/
theorem way_replenishes_of_draws {U R : Type} {need : U → Nat} {kids : R → U → List U}
    {next : List U → R → R} {giving : Nat → Nat} {use : U → Nat} {s : (List U × R) × Nat}
    (nothing : RegimeMargin.FromNothing giving) (needs : WayUnderARule.Needing need kids s.1.1)
    (never : «不穷» (WayUnderARule.net need kids next giving use) «一» s)
    (draws : ∀ N, ∃ n, N ≤ n ∧ 0 < LineOnAStock.taken use (WayUnderARule.course need kids next giving use s n).1.1) :
    ∀ N, ∃ n, N ≤ n ∧ 0 < giving ((WayUnderARule.course need kids next giving use s n).2 -
      LineOnAStock.taken use (WayUnderARule.course need kids next giving use s n).1.1) :=
  Run.replenishes_of_draws (Stock.process_balanced _ _) (wayStockRun_of_unending nothing needs never) draws

/-- Bounded-stock equivalence of recurring draw & replenishment on unending `WayUnderARule` (`Run.draws_iff_replenishes`). -/
theorem way_draws_iff_replenishes {U R : Type} {need : U → Nat} {kids : R → U → List U}
    {next : List U → R → R} {giving : Nat → Nat} {use : U → Nat} {s : (List U × R) × Nat}
    (nothing : RegimeMargin.FromNothing giving) (needs : WayUnderARule.Needing need kids s.1.1)
    (never : «不穷» (WayUnderARule.net need kids next giving use) «一» s) {B : Nat}
    (bound : ∀ n, (WayUnderARule.course need kids next giving use s n).2 ≤ B) :
    (∀ N, ∃ n, N ≤ n ∧ 0 < LineOnAStock.taken use (WayUnderARule.course need kids next giving use s n).1.1) ↔
      (∀ N, ∃ n, N ≤ n ∧ 0 < giving ((WayUnderARule.course need kids next giving use s n).2 -
        LineOnAStock.taken use (WayUnderARule.course need kids next giving use s n).1.1)) :=
  Run.draws_iff_replenishes (Stock.process_balanced _ _) (wayStockRun_of_unending nothing needs never) bound

/-- Reverse bridge: every `Stock.Balanced` `Run P` inherits the finite-horizon drawdown trap. -/
theorem stockRun_never_returns_below_within {S : Type _} {A : Type} {P : Generative.Process S A}
    {σ : S → Nat} {draw replenish : A → Nat}
    (bal : Stock.Balanced P σ draw replenish) (r : Run P) {m T N : Nat}
    (noRaise : ∀ t, T ≤ t → t < T + N → σ (r.state t) < m → replenish (r.act t) ≤ draw (r.act t))
    (below : σ (r.state T) < m) :
    ∀ n, n ≤ N → σ (r.state (T + n)) < m :=
  unitNeverReturnsBelowWithin
    (fun t _ _ => ((stockFlow_balances_iff_unitFlow_balances r σ draw replenish).mp
      (Run.stockFlow_balances bal r)).on [()] t)
    noRaise below

end StockUnificationRuns

/-! ## 4. Constant-draw correspondence with `Becoming.RegimeMargin.Coupled.Indexed.step` -/

section CoupledCorrespondence

/-- Exact one-step identity between `RegimeMargin.Coupled.Indexed.step Drawn.whole` on `Unit`
    and `RegimeMargin.step`. -/
theorem coupled_indexed_step_whole_eq (giving : Nat → Nat) (h z : Nat) :
    RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole
      (fun _ e => giving (e ())) (fun _ => h) (fun _ => z) () =
      RegimeMargin.step giving h z :=
  rfl

/-- Under `even`, while every met step preserves all needs, `LineOnAStock.taken` stays constant. -/
theorem line_taken_const_of_even_met {U : Type} {need : U → Nat} {kids : U → List U}
    {giving : Nat → Nat} {use : U → Nat} {w₀ : List U} {z₀ : Nat}
    (even : ∀ u, LineOnAStock.taken use (kids u) = use u) :
    ∀ k, (∀ j, j < k → ∀ u, u ∈ (LineOnAStock.course need kids giving use (w₀, z₀) j).1 →
        need u ≤ (LineOnAStock.course need kids giving use (w₀, z₀) j).2) →
      LineOnAStock.taken use (LineOnAStock.course need kids giving use (w₀, z₀) k).1 =
        LineOnAStock.taken use w₀
  | 0, _ => rfl
  | k + 1, met => by
    have hprev := line_taken_const_of_even_met even k (fun j lt => met j (Nat.lt_succ_of_lt lt))
    have hafter : (LineOnAStock.course need kids giving use (w₀, z₀) (k + 1)).1 =
        LineOnAStock.allKids kids (LineOnAStock.course need kids giving use (w₀, z₀) k).1 :=
      LineOnAStock.after_of_met (met k (Nat.lt_succ_self k))
    exact (congrArg (LineOnAStock.taken use) hafter).trans
      ((LineOnAStock.taken_allKids even _).trans hprev)

/-- Constant-draw correspondence between `LineOnAStock.course` and `RegimeMargin.Coupled.Indexed.step`
    under `Drawn.whole`. -/
theorem line_coupled_indexed_correspondence {U : Type} {need : U → Nat} {kids : U → List U}
    {giving : Nat → Nat} {use : U → Nat} {w₀ : List U} {z₀ : Nat}
    (even : ∀ u, LineOnAStock.taken use (kids u) = use u) :
    ∀ k, (∀ j, j < k → ∀ u, u ∈ (LineOnAStock.course need kids giving use (w₀, z₀) j).1 →
        need u ≤ (LineOnAStock.course need kids giving use (w₀, z₀) j).2) →
      (LineOnAStock.course need kids giving use (w₀, z₀) k).2 =
        (Law.run (RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole
          (fun _ e => giving (e ())) (fun _ => LineOnAStock.taken use w₀))
          (fun _ => z₀)).state k ()
  | 0, _ => rfl
  | k + 1, met => by
    have ih := line_coupled_indexed_correspondence even k (fun j lt => met j (Nat.lt_succ_of_lt lt))
    have htake := line_taken_const_of_even_met even k (fun j lt => met j (Nat.lt_succ_of_lt lt))
    have hstep : (LineOnAStock.course need kids giving use (w₀, z₀) (k + 1)).2 =
        RegimeMargin.step giving (LineOnAStock.taken use w₀)
          (LineOnAStock.course need kids giving use (w₀, z₀) k).2 :=
      congrArg (fun h => RegimeMargin.step giving h _) htake
    have hrun : (Law.run (RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole
          (fun _ e => giving (e ())) (fun _ => LineOnAStock.taken use w₀))
          (fun _ => z₀)).state (k + 1) () =
        RegimeMargin.step giving (LineOnAStock.taken use w₀)
          ((Law.run (RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole
            (fun _ e => giving (e ())) (fun _ => LineOnAStock.taken use w₀))
            (fun _ => z₀)).state k ()) := rfl
    exact hstep.trans ((congrArg (RegimeMargin.step giving (LineOnAStock.taken use w₀)) ih).trans hrun.symm)

/-- Under per-step rule-evenness and met needs, `WayUnderARule` keeps `taken` constant. -/
theorem way_taken_const_of_met {U R : Type} {need : U → Nat} {kids : R → U → List U}
    {next : List U → R → R} {giving : Nat → Nat} {use : U → Nat}
    {w₀ : List U} {g₀ : R} {z₀ : Nat} :
    ∀ k, (∀ j, j < k → ∀ u, u ∈ (WayUnderARule.course need kids next giving use ((w₀, g₀), z₀) j).1.1 →
        need u ≤ (WayUnderARule.course need kids next giving use ((w₀, g₀), z₀) j).2) →
      (∀ j, j < k → ∀ u,
        LineOnAStock.taken use (kids (WayUnderARule.course need kids next giving use ((w₀, g₀), z₀) j).1.2 u) =
          use u) →
      LineOnAStock.taken use (WayUnderARule.course need kids next giving use ((w₀, g₀), z₀) k).1.1 =
        LineOnAStock.taken use w₀
  | 0, _, _ => rfl
  | k + 1, met, evenStep => by
    have hprev := way_taken_const_of_met k (fun j lt => met j (Nat.lt_succ_of_lt lt))
      (fun j lt => evenStep j (Nat.lt_succ_of_lt lt))
    have hafter : (WayUnderARule.course need kids next giving use ((w₀, g₀), z₀) (k + 1)).1.1 =
        LineOnAStock.allKids (kids (WayUnderARule.course need kids next giving use ((w₀, g₀), z₀) k).1.2)
          (WayUnderARule.course need kids next giving use ((w₀, g₀), z₀) k).1.1 :=
      LineOnAStock.after_of_met (met k (Nat.lt_succ_self k))
    exact (congrArg (LineOnAStock.taken use) hafter).trans
      ((LineOnAStock.taken_allKids (evenStep k (Nat.lt_succ_self k)) _).trans hprev)

/-- Constant-draw correspondence between `WayUnderARule.course` and `RegimeMargin.Coupled.Indexed.step`
    under `Drawn.whole`. -/
theorem way_coupled_indexed_correspondence {U R : Type} {need : U → Nat} {kids : R → U → List U}
    {next : List U → R → R} {giving : Nat → Nat} {use : U → Nat}
    {w₀ : List U} {g₀ : R} {z₀ : Nat} :
    ∀ k, (∀ j, j < k → ∀ u, u ∈ (WayUnderARule.course need kids next giving use ((w₀, g₀), z₀) j).1.1 →
        need u ≤ (WayUnderARule.course need kids next giving use ((w₀, g₀), z₀) j).2) →
      (∀ j, j < k → ∀ u,
        LineOnAStock.taken use (kids (WayUnderARule.course need kids next giving use ((w₀, g₀), z₀) j).1.2 u) =
          use u) →
      (WayUnderARule.course need kids next giving use ((w₀, g₀), z₀) k).2 =
        (Law.run (RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole
          (fun _ e => giving (e ())) (fun _ => LineOnAStock.taken use w₀))
          (fun _ => z₀)).state k ()
  | 0, _, _ => rfl
  | k + 1, met, evenStep => by
    have ih := way_coupled_indexed_correspondence k (fun j lt => met j (Nat.lt_succ_of_lt lt))
      (fun j lt => evenStep j (Nat.lt_succ_of_lt lt))
    have htake := way_taken_const_of_met k (fun j lt => met j (Nat.lt_succ_of_lt lt))
      (fun j lt => evenStep j (Nat.lt_succ_of_lt lt))
    have hstep : (WayUnderARule.course need kids next giving use ((w₀, g₀), z₀) (k + 1)).2 =
        RegimeMargin.step giving (LineOnAStock.taken use w₀)
          (WayUnderARule.course need kids next giving use ((w₀, g₀), z₀) k).2 :=
      congrArg (fun h => RegimeMargin.step giving h _) htake
    have hrun : (Law.run (RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole
          (fun _ e => giving (e ())) (fun _ => LineOnAStock.taken use w₀))
          (fun _ => z₀)).state (k + 1) () =
        RegimeMargin.step giving (LineOnAStock.taken use w₀)
          ((Law.run (RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole
            (fun _ e => giving (e ())) (fun _ => LineOnAStock.taken use w₀))
            (fun _ => z₀)).state k ()) := rfl
    exact hstep.trans ((congrArg (RegimeMargin.step giving (LineOnAStock.taken use w₀)) ih).trans hrun.symm)

/-- Specialization of `way_coupled_indexed_correspondence` to an unfavoured `WayUnderARule`
    regime via `WayUnderARule.taken_kept`'s `even` hypothesis. -/
theorem way_coupled_indexed_of_unfavoured {U R : Type} {need : U → Nat} {kids : R → U → List U}
    {next : List U → R → R} {giving : Nat → Nat} {use : U → Nat} {favours : R → Prop}
    {w₀ : List U} {g₀ : R} {z₀ : Nat}
    (even : ∀ g, ¬ favours g → ∀ u, LineOnAStock.taken use (kids g u) = use u)
    (k : Nat)
    (unfav : ∀ j, j < k →
      ¬ favours (WayUnderARule.course need kids next giving use ((w₀, g₀), z₀) j).1.2)
    (met : ∀ j, j < k → ∀ u, u ∈ (WayUnderARule.course need kids next giving use ((w₀, g₀), z₀) j).1.1 →
      need u ≤ (WayUnderARule.course need kids next giving use ((w₀, g₀), z₀) j).2) :
    (WayUnderARule.course need kids next giving use ((w₀, g₀), z₀) k).2 =
      (Law.run (RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole
        (fun _ e => giving (e ())) (fun _ => LineOnAStock.taken use w₀))
        (fun _ => z₀)).state k () :=
  way_coupled_indexed_correspondence k met fun j lt => even _ (unfav j lt)

end CoupledCorrespondence

end StockFlowBridge

end Becoming
