import Becoming.Flow
import Becoming.Frame

/-!
# Stock: what a course draws, what replenishes it, and how long it can go on

General laws of drawing on what is held and replenishing it, for every `Process`, `Trace` and
`Run`. The stocks of `Becoming.Revision` (`Revising`), `Becoming.ReferencePlan` and
`Becoming.ContinuingRevision` are instances. Nothing is assumed of a process beyond the local
condition each law names.

* **Balance at every step is balance along every course.** A stock observable `σ` is balanced
  across a step when what stands after it and what the step draws equal what stood before and
  what the step replenishes (`Balanced`). Every trace then balances its totals
  (`trace_balance`), and conversely (`balanced_iff`).
* **Drawing before replenishing.** Where a step draws only from what is held before it
  (`DrawsHeld`), the observable is exactly a map into the stock process (`process`,
  `process_map_iff`). A course of that process is executable exactly when each step's draw is
  within the stock then standing (`Covered`, `feasible_iff_covered`): at each step, the initial
  stock and everything replenished before the step cover everything drawn up to and including
  it (`covered_iff_prefix`). So every course of every such process is covered
  (`covered_of_trace`); the converse fails, since other relations of the process can block a
  covered step (`Revising.covered_not_enacted`). For a process run jointly with
  its stock, a course is executable exactly when that process admits it and the stock
  covers it (`product_feasible_iff`).
* **Repetition.** A course repeated without end needs what it replenishes to cover what it
  draws, in every balanced process (`cycles_need`, `repeat_needs`). For the stock process, and
  for any cycle of a process run jointly with it, repetition without end holds exactly where
  the first pass is covered and the return covers the draw (`repeat_covered_iff`,
  `product_repeat_iff`).
* **Recurrence along runs.** Along every run of every balanced process, drawing at arbitrarily
  late steps needs replenishment at arbitrarily late steps (`Run.replenishes_of_draws`); where
  the stock is bounded the two recur together (`Run.draws_iff_replenishes`). Without the bound
  the converse fails (`accumulating`). An unending course of a process is carried
  by the stock exactly where each step's draw is within the stock then standing
  (`carried_iff`).
* **A level drawn on and not replenished.** Where what stands after each step and what it draws
  are at most what stood before (`FallsBy`), everything drawn along a course and what stands at
  its end are at most what stood at its start (`trace_falls`, `falls_iff`). Where moreover every
  step from a positive level draws something, every course as long as the level ends at nothing
  (`exhausted_within`), and from nothing a step draws nothing (`draws_nothing_from_empty`).
* **One model.** The stock along a run is a flow on one condition, balanced exactly where the
  process is balanced along the run (`Run.stockFlow_balances_iff`), so every law of balanced
  flows (renewal, dissipation, the kept history) applies to it.

No ethical predicate, ranking or axiom occurs. Which observable represents an actual condition,
and which steps draw on it, are application duties; nothing here makes drawing universal.
-/

namespace Becoming

open Generative

universe u

namespace Stock

variable {S : Type u} {A : Type}

/-! ## Totals -/

theorem total_append (q : A → Nat) : ∀ xs ys : List A, total (xs ++ ys) q = total xs q + total ys q
  | [], ys => (Nat.zero_add (total ys q)).symm
  | x :: xs, ys =>
    (congrArg (q x + ·) (total_append q xs ys)).trans (Nat.add_assoc _ _ _).symm

/-! ## Balance -/

/-- Across every step, what stands after it and what it draws equal what stood before it and
what it replenishes. -/
def Balanced (P : Process S A) (σ : S → Nat) (draw replenish : A → Nat) : Prop :=
  ∀ s a t, P.step s a t → σ t + draw a = σ s + replenish a

/-- A step draws only from what is held before it. -/
def DrawsHeld (P : Process S A) (σ : S → Nat) (draw : A → Nat) : Prop :=
  ∀ s a t, P.step s a t → draw a ≤ σ s

theorem trace_balance {P : Process S A} {σ : S → Nat} {draw replenish : A → Nat}
    (bal : Balanced P σ draw replenish) {s t : S} {as : List A} (h : Trace P s as t) :
    σ t + total as draw = σ s + total as replenish := by
  induction h with
  | nil s => rfl
  | @cons s m t a as step _ ih =>
    calc σ t + (draw a + total as draw)
        = draw a + (σ t + total as draw) := Nat.add_left_comm _ _ _
      _ = draw a + (σ m + total as replenish) := congrArg (draw a + ·) ih
      _ = (σ m + draw a) + total as replenish :=
          (Nat.add_left_comm _ _ _).trans (Nat.add_assoc _ _ _).symm
      _ = (σ s + replenish a) + total as replenish :=
          congrArg (· + total as replenish) (bal s a m step)
      _ = σ s + (replenish a + total as replenish) := Nat.add_assoc _ _ _

/-- **Balance at every step is balance along every course.** -/
theorem balanced_iff {P : Process S A} {σ : S → Nat} {draw replenish : A → Nat} :
    Balanced P σ draw replenish ↔
      ∀ s as t, Trace P s as t → σ t + total as draw = σ s + total as replenish :=
  ⟨fun bal _ _ _ h => trace_balance bal h,
   fun all s a t step => all s [a] t (.cons step (.nil t))⟩

/-- Balance alone keeps every draw within what is held and replenished at the step; the
substantive order condition is `DrawsHeld`. -/
theorem Balanced.within {P : Process S A} {σ : S → Nat} {draw replenish : A → Nat}
    (bal : Balanced P σ draw replenish) {s t : S} {a : A} (step : P.step s a t) :
    draw a ≤ σ s + replenish a :=
  Nat.le_trans (Nat.le_add_left (draw a) (σ t)) (Nat.le_of_eq (bal s a t step))

/-! ## The stock process and coverage -/

/-- Stock `n` covers a course where each step's draw is within the stock then standing. -/
def Covered (draw replenish : A → Nat) : Nat → List A → Prop
  | _, [] => True
  | n, a :: as => draw a ≤ n ∧ Covered draw replenish (n - draw a + replenish a) as

/-- What stands after a course, each step drawing then replenishing. -/
def after (draw replenish : A → Nat) : Nat → List A → Nat
  | n, [] => n
  | n, a :: as => after draw replenish (n - draw a + replenish a) as

/-- The stock process: a step draws what it draws from what is held, then replenishes. -/
def process (draw replenish : A → Nat) : Process Nat A :=
  ⟨fun n a m => draw a ≤ n ∧ m + draw a = n + replenish a⟩

theorem process_next {draw replenish : A → Nat} {n m : Nat} {a : A}
    (step : (process draw replenish).step n a m) : m = n - draw a + replenish a :=
  add_right_cancel (draw a) (step.2.trans (Naturals.sub_add_refill (replenish a) step.1).symm)

theorem process_step {draw replenish : A → Nat} {n : Nat} {a : A} (le : draw a ≤ n) :
    (process draw replenish).step n a (n - draw a + replenish a) :=
  ⟨le, Naturals.sub_add_refill (replenish a) le⟩

theorem process_balanced (draw replenish : A → Nat) :
    Balanced (process draw replenish) (fun n => n) draw replenish :=
  fun _ _ _ step => step.2

/-- **A course of the stock process is executable exactly where it is covered.** -/
theorem feasible_iff_covered {draw replenish : A → Nat} :
    ∀ (as : List A) (n : Nat), Feasible (process draw replenish) n as ↔ Covered draw replenish n as
  | [], n => ⟨fun _ => trivial, fun _ => ⟨n, .nil n⟩⟩
  | _ :: as, _ =>
    ⟨fun ⟨t, h⟩ => match h with
      | .cons step tail =>
        ⟨step.1, (feasible_iff_covered as _).mp ⟨t, (process_next step) ▸ tail⟩⟩,
     fun ⟨le, cov⟩ => match (feasible_iff_covered as _).mpr cov with
      | ⟨t, tail⟩ => ⟨t, .cons (process_step le) tail⟩⟩

theorem draw_turn {n d r : Nat} (R : Nat) (le : d ≤ n) :
    d + ((n - d + r) + R) = n + (r + R) :=
  (Nat.add_left_comm _ _ _).trans ((Nat.add_assoc _ _ _).symm.trans
    ((congrArg (· + R) (Naturals.sub_add_refill r le)).trans (Nat.add_assoc _ _ _)))

theorem nil_ne_split : ∀ (u : List A) (a : A) (v : List A), [] ≠ u ++ a :: v
  | [], _, _, h => nomatch h
  | _ :: _, _, _, h => nomatch h

/-- **Coverage, closed form.** Stock `n` covers a course exactly where, at each step, `n`
and everything replenished before the step cover everything drawn up to and including it. -/
theorem covered_iff_prefix {draw replenish : A → Nat} :
    ∀ (as : List A) (n : Nat), Covered draw replenish n as ↔
      ∀ u a v, as = u ++ a :: v → total u draw + draw a ≤ n + total u replenish
  | [], _ => ⟨fun _ u a v h => absurd h (nil_ne_split u a v), fun _ => trivial⟩
  | b :: bs, n =>
    ⟨fun ⟨le, cov⟩ u a v h => match u, h with
      | [], h =>
        Nat.le_trans (Nat.le_of_eq ((Nat.zero_add _).trans
          (congrArg draw (List.cons.inj h).1).symm)) le
      | c :: u', h => by
        have hb : b = c := (List.cons.inj h).1
        subst hb
        exact Nat.le_trans (Nat.le_of_eq (Nat.add_assoc _ _ _))
          (Nat.le_trans (Nat.add_le_add_left
            ((covered_iff_prefix bs _).mp cov u' a v (List.cons.inj h).2) (draw b))
            (Nat.le_of_eq (draw_turn _ le))),
     fun all =>
      have le : draw b ≤ n :=
        Nat.le_trans (Nat.le_of_eq (Nat.zero_add _).symm) (all [] b bs rfl)
      ⟨le, (covered_iff_prefix bs _).mpr fun u' a v h =>
        le_of_add_le_add_right (draw b)
          (Nat.le_trans (Nat.le_of_eq ((Nat.add_comm _ _).trans (Nat.add_assoc _ _ _).symm))
            (Nat.le_trans (all (b :: u') a v (congrArg (b :: ·) h))
              (Nat.le_of_eq ((draw_turn _ le).symm.trans (Nat.add_comm _ _)))))⟩⟩

/-- Balanced and drawing from what is held is exactly a map into the stock process. -/
theorem process_map_iff {P : Process S A} {σ : S → Nat} {draw replenish : A → Nat} :
    (Balanced P σ draw replenish ∧ DrawsHeld P σ draw) ↔
      ∀ s a t, P.step s a t → (process draw replenish).step (σ s) a (σ t) :=
  ⟨fun ⟨bal, held⟩ s a t step => ⟨held s a t step, bal s a t step⟩,
   fun m => ⟨fun s a t step => (m s a t step).2, fun s a t step => (m s a t step).1⟩⟩

/-- **Every course of every process whose balanced stock draws from what is held is covered by
the stock it starts from.** -/
theorem covered_of_trace {P : Process S A} {σ : S → Nat} {draw replenish : A → Nat}
    (bal : Balanced P σ draw replenish) (held : DrawsHeld P σ draw)
    {s t : S} {as : List A} (h : Trace P s as t) : Covered draw replenish (σ s) as :=
  (feasible_iff_covered as (σ s)).mp
    ⟨σ t, trace_map (process_map_iff.mp ⟨bal, held⟩) h⟩

/-- **A process and stock, run jointly.** A course is executable exactly where the
process `R` admits it and the stock covers it. -/
theorem product_feasible_iff {S' : Type u} {R : Process S' A} {draw replenish : A → Nat}
    {n : Nat} {x : S'} {as : List A} :
    Feasible (productProcess (process draw replenish) R) (n, x) as ↔
      Covered draw replenish n as ∧ Feasible R x as :=
  feasible_product_iff.trans
    ⟨fun ⟨c, f⟩ => ⟨(feasible_iff_covered as n).mp c, f⟩,
     fun ⟨c, f⟩ => ⟨(feasible_iff_covered as n).mpr c, f⟩⟩

/-! ## Coverage over stretches -/

theorem Covered.mono {draw replenish : A → Nat} :
    ∀ {as : List A} {n m : Nat}, n ≤ m → Covered draw replenish n as → Covered draw replenish m as
  | [], _, _, _, _ => trivial
  | a :: _, _, _, le, ⟨held, rest⟩ =>
    ⟨Nat.le_trans held le,
     Covered.mono (Nat.add_le_add_right (Nat.sub_le_sub_right le (draw a)) (replenish a)) rest⟩

theorem covered_append {draw replenish : A → Nat} :
    ∀ {xs ys : List A} {n : Nat},
      Covered draw replenish n (xs ++ ys) ↔
        Covered draw replenish n xs ∧ Covered draw replenish (after draw replenish n xs) ys
  | [], _, _ => ⟨fun c => ⟨trivial, c⟩, fun ⟨_, c⟩ => c⟩
  | _ :: xs, _, _ =>
    ⟨fun ⟨h, c⟩ => match (covered_append (xs := xs)).mp c with
      | ⟨c₁, c₂⟩ => ⟨⟨h, c₁⟩, c₂⟩,
     fun ⟨⟨h, c₁⟩, c₂⟩ => ⟨h, (covered_append (xs := xs)).mpr ⟨c₁, c₂⟩⟩⟩

theorem after_append {draw replenish : A → Nat} :
    ∀ (xs ys : List A) (n : Nat),
      after draw replenish n (xs ++ ys) = after draw replenish (after draw replenish n xs) ys
  | [], _, _ => rfl
  | _ :: xs, ys, _ => after_append xs ys _

theorem after_balance {draw replenish : A → Nat} :
    ∀ {as : List A} {n : Nat}, Covered draw replenish n as →
      after draw replenish n as + total as draw = n + total as replenish
  | [], _, _ => rfl
  | a :: as, n, ⟨h, c⟩ =>
    calc after draw replenish (n - draw a + replenish a) as + (draw a + total as draw)
        = draw a + (after draw replenish (n - draw a + replenish a) as + total as draw) :=
          Nat.add_left_comm _ _ _
      _ = draw a + ((n - draw a + replenish a) + total as replenish) :=
          congrArg (draw a + ·) (after_balance c)
      _ = (n - draw a + replenish a + draw a) + total as replenish :=
          (Nat.add_left_comm _ _ _).trans (Nat.add_assoc _ _ _).symm
      _ = (n + replenish a) + total as replenish :=
          congrArg (· + total as replenish) (Naturals.sub_add_refill (replenish a) h)
      _ = n + (replenish a + total as replenish) := Nat.add_assoc _ _ _

/-- A covered course ends at no less than it began exactly where it replenishes at least what
it draws. -/
theorem le_after_of_net {draw replenish : A → Nat} {as : List A} {n : Nat}
    (c : Covered draw replenish n as) (net : total as draw ≤ total as replenish) :
    n ≤ after draw replenish n as :=
  le_of_add_le_add_right (total as draw)
    (Nat.le_trans (Nat.add_le_add_left net n) (Nat.le_of_eq (after_balance c).symm))

/-! ## Repetition -/

/-- The first `k` cycles of a course, in order. -/
def cycles (w : Nat → List A) : Nat → List A
  | 0 => []
  | k + 1 => cycles w k ++ w k

/-- One course repeated `k` times. -/
abbrev repeatCourse (w : List A) : Nat → List A := cycles (fun _ => w)

theorem total_cycles (q : A → Nat) {w : Nat → List A} {D : Nat} (each : ∀ k, total (w k) q = D) :
    ∀ k, total (cycles w k) q = k * D
  | 0 => (Nat.zero_mul D).symm
  | k + 1 => (total_append q (cycles w k) (w k)).trans
      ((congrArg (· + total (w k) q) (total_cycles q each k)).trans
        ((congrArg (k * D + ·) (each k)).trans (Nat.succ_mul k D).symm))

/-- **A course repeated without end needs its return to cover its draw**, in every balanced
process: where every cycle draws `D` and replenishes `R`, and every finite number of cycles
is executable from one configuration, `D ≤ R`. -/
theorem cycles_need {P : Process S A} {σ : S → Nat} {draw replenish : A → Nat}
    (bal : Balanced P σ draw replenish) {s : S} {w : Nat → List A} {D R : Nat}
    (drawn : ∀ k, total (w k) draw = D) (renewed : ∀ k, total (w k) replenish = R)
    (each : ∀ k, Feasible P s (cycles w k)) : D ≤ R := by
  have bound : ∀ k, k * D ≤ σ s + k * R := fun k =>
    match each k with
    | ⟨t, h⟩ =>
      Nat.le_trans (Nat.le_add_left _ (σ t))
        (Nat.le_of_eq ((congrArg (σ t + ·) (total_cycles draw drawn k).symm).trans
          ((trace_balance bal h).trans (congrArg (σ s + ·) (total_cycles replenish renewed k)))))
  match Nat.lt_or_ge R D with
  | .inr ge => exact ge
  | .inl lt =>
    have more : (σ s + 1) * R + (σ s + 1) ≤ σ s + (σ s + 1) * R :=
      Nat.le_trans (Nat.le_of_eq (Nat.mul_succ (σ s + 1) R).symm)
        (Nat.le_trans (Nat.mul_le_mul_left (σ s + 1) lt) (bound (σ s + 1)))
    have swapped : (σ s + 1) + (σ s + 1) * R ≤ σ s + (σ s + 1) * R :=
      Nat.le_trans (Nat.le_of_eq (Nat.add_comm _ _)) more
    exact absurd (le_of_add_le_add_right _ swapped) (Nat.not_succ_le_self (σ s))

theorem repeat_needs {P : Process S A} {σ : S → Nat} {draw replenish : A → Nat}
    (bal : Balanced P σ draw replenish) {s : S} {w : List A}
    (each : ∀ k, Feasible P s (repeatCourse w k)) : total w draw ≤ total w replenish :=
  cycles_need bal (fun _ => rfl) (fun _ => rfl) each

/-- Cycles each covered from `n` and each returning at least what they draw are all covered
together from `n`, ending at no less than `n`. -/
theorem cycles_covered {draw replenish : A → Nat} {w : Nat → List A} {n : Nat}
    (each : ∀ k, Covered draw replenish n (w k))
    (net : ∀ k, total (w k) draw ≤ total (w k) replenish) :
    ∀ k, Covered draw replenish n (cycles w k) ∧ n ≤ after draw replenish n (cycles w k)
  | 0 => ⟨trivial, Nat.le_refl n⟩
  | k + 1 =>
    match cycles_covered each net k with
    | ⟨c, le⟩ =>
      have next : Covered draw replenish (after draw replenish n (cycles w k)) (w k) :=
        Covered.mono le (each k)
      ⟨covered_append.mpr ⟨c, next⟩,
       Nat.le_trans le (Nat.le_trans (le_after_of_net next (net k))
         (Nat.le_of_eq (after_append (cycles w k) (w k) n).symm))⟩

/-- **Repetition without end, exactly.** One course can be repeated any number of times from
stock `n` exactly where its first pass is covered and its return covers its draw. -/
theorem repeat_covered_iff {draw replenish : A → Nat} {w : List A} {n : Nat} :
    (∀ k, Covered draw replenish n (repeatCourse w k)) ↔
      Covered draw replenish n w ∧ total w draw ≤ total w replenish :=
  ⟨fun all => ⟨all 1,
     repeat_needs (process_balanced draw replenish) (s := n)
       (fun k => (feasible_iff_covered _ n).mpr (all k))⟩,
   fun ⟨c, net⟩ k => (cycles_covered (w := fun _ => w) (fun _ => c) (fun _ => net) k).1⟩

theorem trace_repeat {S' : Type u} {R : Process S' A} {x : S'} {w : List A}
    (cycle : Trace R x w x) : ∀ k, Trace R x (repeatCourse w k) x
  | 0 => .nil x
  | k + 1 => trace_append_iff.mpr ⟨x, trace_repeat cycle k, cycle⟩

/-- **A cycle carried by stock.** Where a course returns the process `R` to where it
began, running it jointly with the stock process from `n`, it can be
repeated any number of times exactly where its first pass is covered and its return covers its
draw. -/
theorem product_repeat_iff {S' : Type u} {R : Process S' A} {draw replenish : A → Nat}
    {x : S'} {w : List A} {n : Nat} (cycle : Trace R x w x) :
    (∀ k, Feasible (productProcess (process draw replenish) R) (n, x) (repeatCourse w k)) ↔
      Covered draw replenish n w ∧ total w draw ≤ total w replenish :=
  ⟨fun all => repeat_covered_iff.mp fun k => (product_feasible_iff.mp (all k)).1,
   fun both k => product_feasible_iff.mpr
     ⟨repeat_covered_iff.mpr both k, ⟨x, trace_repeat cycle k⟩⟩⟩

/-! ## Recurrence along a sequence -/

/-- Either some step of `[N, N + L)` has `0 < g n`, or quiet does. Decided with no premise. -/
theorem search (g : Nat → Nat) (N : Nat) :
    ∀ L, (∃ n, N ≤ n ∧ n < N + L ∧ 0 < g n) ∨ (∀ n, N ≤ n → n < N + L → g n = 0)
  | 0 => .inr fun _ le lt => absurd lt (Nat.not_lt_of_le le)
  | L + 1 =>
    match search g N L with
    | .inl ⟨n, le, lt, pos⟩ => .inl ⟨n, le, Nat.lt_trans lt (Nat.lt_succ_self _), pos⟩
    | .inr quiet =>
      match h : g (N + L) with
      | 0 => .inr fun n le lt =>
          match Nat.lt_or_ge n (N + L) with
          | .inl lt' => quiet n le lt'
          | .inr ge => (congrArg g (Nat.le_antisymm (Nat.le_of_lt_succ lt) ge)).trans h
      | k + 1 => .inl ⟨N + L, Nat.le_add_right N L, Nat.lt_succ_self _,
          Nat.lt_of_lt_of_le (Nat.succ_pos k) (Nat.le_of_eq h.symm)⟩

/-- With no replenishment across a stretch, a balanced amount does not rise across it. -/
theorem flat_of_none {x d g : Nat → Nat} (bal : ∀ n, x (n + 1) + d n = x n + g n) {N j : Nat}
    (quiet : ∀ n, N ≤ n → n < N + (j + 1) → g n = 0) :
    ∀ i, i ≤ j → x (N + i) ≤ x N
  | 0, _ => Nat.le_refl _
  | i + 1, le =>
    Nat.le_trans (Nat.le_add_right (x (N + i + 1)) (d (N + i)))
      (Nat.le_trans (Nat.le_of_eq ((bal (N + i)).trans
        (congrArg (x (N + i) + ·) (quiet (N + i) (Nat.le_add_right N i)
          (Nat.add_lt_add_left (Nat.lt_succ_of_le (Nat.le_of_succ_le le)) N)))))
        (flat_of_none bal quiet i (Nat.le_of_succ_le le)))

/-- **Drawing at arbitrarily late steps needs replenishment at arbitrarily late steps.** -/
theorem replenishes_of_draws {x d g : Nat → Nat} (bal : ∀ n, x (n + 1) + d n = x n + g n)
    (draws : ∀ N, ∃ n, N ≤ n ∧ 0 < d n) : ∀ N, ∃ n, N ≤ n ∧ 0 < g n := by
  have key : ∀ k N, x N ≤ k → ∃ n, N ≤ n ∧ 0 < g n := by
    intro k
    induction k with
    | zero =>
      intro N held
      match draws N with
      | ⟨m, later, pos⟩ =>
        match le_dest later with
        | ⟨j, same⟩ =>
          match search g N (j + 1) with
          | .inl ⟨n, le, _, gain⟩ => exact ⟨n, le, gain⟩
          | .inr quiet =>
            have flat := flat_of_none bal quiet j (Nat.le_refl j)
            have drop : x (N + j + 1) + d (N + j) = x (N + j) :=
              (bal (N + j)).trans (congrArg (x (N + j) + ·)
                (quiet (N + j) (Nat.le_add_right N j) (Nat.lt_succ_self _)))
            have dpos : 0 < d (N + j) := same ▸ pos
            exact absurd (Nat.le_trans (Nat.le_trans (Nat.add_le_add_left dpos _)
              (Nat.le_of_eq drop)) (Nat.le_trans flat held)) (Nat.not_succ_le_zero _)
    | succ k ih =>
      intro N held
      match draws N with
      | ⟨m, later, pos⟩ =>
        match le_dest later with
        | ⟨j, same⟩ =>
          match search g N (j + 1) with
          | .inl ⟨n, le, _, gain⟩ => exact ⟨n, le, gain⟩
          | .inr quiet =>
            have flat := flat_of_none bal quiet j (Nat.le_refl j)
            have drop : x (N + j + 1) + d (N + j) = x (N + j) :=
              (bal (N + j)).trans (congrArg (x (N + j) + ·)
                (quiet (N + j) (Nat.le_add_right N j) (Nat.lt_succ_self _)))
            have dpos : 0 < d (N + j) := same ▸ pos
            have lower : x (N + j + 1) + 1 ≤ k + 1 :=
              Nat.le_trans (Nat.le_trans (Nat.add_le_add_left dpos _) (Nat.le_of_eq drop))
                (Nat.le_trans flat held)
            match ih (N + j + 1) (Nat.le_of_succ_le_succ lower) with
            | ⟨n, le, gain⟩ =>
              exact ⟨n, Nat.le_trans (Nat.le_trans (Nat.le_add_right N j) (Nat.le_succ _)) le, gain⟩
  exact fun N => key (x N) N (Nat.le_refl _)

/-- The room left below a bound is balanced with draw and replenishment exchanged. -/
theorem room_balanced {x d g : Nat → Nat} (bal : ∀ n, x (n + 1) + d n = x n + g n) {B : Nat}
    (bound : ∀ n, x n ≤ B) : ∀ n, (B - x (n + 1)) + g n = (B - x n) + d n := fun n =>
  add_right_cancel (x (n + 1)) (calc
    (B - x (n + 1)) + g n + x (n + 1) = (x (n + 1) + (B - x (n + 1))) + g n :=
        (Nat.add_right_comm _ _ _).trans (congrArg (· + g n) (Nat.add_comm _ _))
    _ = B + g n := congrArg (· + g n) (add_sub_of_le (bound (n + 1)))
    _ = (x n + (B - x n)) + g n := congrArg (· + g n) (add_sub_of_le (bound n)).symm
    _ = (B - x n) + (x n + g n) :=
        (congrArg (· + g n) (Nat.add_comm _ _)).trans (Nat.add_assoc _ _ _)
    _ = (B - x n) + (x (n + 1) + d n) := congrArg ((B - x n) + ·) (bal n).symm
    _ = (B - x n) + d n + x (n + 1) :=
        (congrArg ((B - x n) + ·) (Nat.add_comm _ _)).trans (Nat.add_assoc _ _ _).symm)

/-- With a bound, replenishment at arbitrarily late steps needs drawing at arbitrarily late
steps. -/
theorem draws_of_replenishes {x d g : Nat → Nat} (bal : ∀ n, x (n + 1) + d n = x n + g n)
    {B : Nat} (bound : ∀ n, x n ≤ B) (gains : ∀ N, ∃ n, N ≤ n ∧ 0 < g n) :
    ∀ N, ∃ n, N ≤ n ∧ 0 < d n :=
  replenishes_of_draws (x := fun n => B - x n) (d := g) (g := d) (room_balanced bal bound) gains

end Stock

/-! ## Recurrence along runs -/

namespace Run

variable {S : Type u} {A : Type}

/-- **Along every run of every balanced process, drawing at arbitrarily late steps needs
replenishment at arbitrarily late steps.** -/
theorem replenishes_of_draws {P : Process S A} {σ : S → Nat} {draw replenish : A → Nat}
    (bal : Stock.Balanced P σ draw replenish) (r : Run P)
    (draws : ∀ N, ∃ n, N ≤ n ∧ 0 < draw (r.act n)) :
    ∀ N, ∃ n, N ≤ n ∧ 0 < replenish (r.act n) :=
  Stock.replenishes_of_draws (x := fun n => σ (r.state n)) (fun n => bal _ _ _ (r.step n)) draws

/-- **Where the stock is bounded along the run, drawing and replenishment recur together.** -/
theorem draws_iff_replenishes {P : Process S A} {σ : S → Nat} {draw replenish : A → Nat}
    (bal : Stock.Balanced P σ draw replenish) (r : Run P) {B : Nat}
    (bound : ∀ n, σ (r.state n) ≤ B) :
    (∀ N, ∃ n, N ≤ n ∧ 0 < draw (r.act n)) ↔ (∀ N, ∃ n, N ≤ n ∧ 0 < replenish (r.act n)) :=
  ⟨replenishes_of_draws bal r,
   Stock.draws_of_replenishes (x := fun n => σ (r.state n)) (fun n => bal _ _ _ (r.step n)) bound⟩

/-- The stock along a run read as a flow: one condition, one formation taking part at
every step, taking what the step draws and giving what it replenishes. -/
def stockFlow {P : Process S A} (r : Run P) (draw replenish : A → Nat) : Flow Unit Unit :=
  ⟨fun _ => [()], fun t _ _ => draw (r.act t), fun t _ _ => replenish (r.act t)⟩

/-- The stock along a run read as the level of the one condition. -/
def stockWeb {P : Process S A} (r : Run P) (σ : S → Nat) : Web Unit Unit :=
  ⟨fun t _ => σ (r.state t), fun _ _ => True, fun _ _ _ => False, fun _ _ _ => 0,
    fun _ _ _ => True⟩

/-- **The bridge to flows.** The stock along a run balances as a flow exactly where it
balances at each step of the run; so every law of balanced flows applies to it. -/
theorem stockFlow_balances_iff {P : Process S A} (r : Run P) (σ : S → Nat)
    (draw replenish : A → Nat) :
    (stockFlow r draw replenish).Balances (stockWeb r σ) ↔
      ∀ n, σ (r.state (n + 1)) + draw (r.act n) = σ (r.state n) + replenish (r.act n) :=
  ⟨fun h n => h n (), fun h t c => match c with | () => h t⟩

/-- Every run of a balanced process balances as a flow. -/
theorem stockFlow_balances {P : Process S A} {σ : S → Nat} {draw replenish : A → Nat}
    (bal : Stock.Balanced P σ draw replenish) (r : Run P) :
    (stockFlow r draw replenish).Balances (stockWeb r σ) :=
  (stockFlow_balances_iff r σ draw replenish).mpr fun n => bal _ _ _ (r.step n)

end Run

namespace Stock

/-- The stock standing after the first `k` actions of a sequence, from `n`. -/
def along (draw replenish : A → Nat) (n : Nat) (acts : Nat → A) : Nat → Nat
  | 0 => n
  | k + 1 => along draw replenish n acts k - draw (acts k) + replenish (acts k)

/-- **An unending course carried by stock.** A run of a process `R` can be run
jointly with the stock process from `n`, taking the same actions, exactly where at every
step the draw is within the stock then standing. -/
theorem carried_iff {S' : Type u} {R : Process S' A} {draw replenish : A → Nat}
    (r : Run R) (n : Nat) :
    (∃ q : Run (productProcess (process draw replenish) R),
        (q.state 0).1 = n ∧ (∀ k, (q.state k).2 = r.state k) ∧ ∀ k, q.act k = r.act k) ↔
      ∀ k, draw (r.act k) ≤ along draw replenish n r.act k :=
  ⟨fun ⟨q, start, _, acts⟩ =>
    have stands : ∀ k, (q.state k).1 = along draw replenish n r.act k := fun k => by
      induction k with
      | zero => exact start
      | succ k ih =>
        exact (process_next (q.step k).1).trans
          ((congrArg (fun a => (q.state k).1 - draw a + replenish a) (acts k)).trans
            (congrArg (fun m => m - draw (r.act k) + replenish (r.act k)) ih))
    fun k => Nat.le_trans (Nat.le_of_eq (congrArg draw (acts k)).symm)
      (Nat.le_trans (q.step k).1.1 (Nat.le_of_eq (stands k))),
   fun within =>
    ⟨⟨fun k => (along draw replenish n r.act k, r.state k), r.act,
      fun k => ⟨process_step (within k), r.step k⟩⟩, rfl, fun _ => rfl, fun _ => rfl⟩⟩

/-- Without a bound the converse fails: stock that only accumulates replenishes at every
step and never draws. -/
def accumulating : Run (process (fun _ : Unit => 0) (fun _ => 1)) :=
  ⟨fun n => n, fun _ => (), fun n => ⟨Nat.zero_le n, rfl⟩⟩

theorem accumulating_never_draws :
    (∀ N, ∃ n, N ≤ n ∧ 0 < (fun _ : Unit => 1) (accumulating.act n)) ∧
      ∀ n, ¬ 0 < (fun _ : Unit => 0) (accumulating.act n) :=
  ⟨fun N => ⟨N, Nat.le_refl N, Nat.zero_lt_one⟩, fun _ h => Nat.lt_irrefl 0 h⟩

/-! ## A level drawn on and not replenished -/

/-- Across every step, what stands after it and what it draws are at most what stood before it:
nothing is replenished, and more than the draw may be lost. -/
def FallsBy {S : Type u} {A : Type} (P : Process S A) (σ : S → Nat) (draw : A → Nat) : Prop :=
  ∀ s a t, P.step s a t → σ t + draw a ≤ σ s

/-- **A level falling by at least each draw bounds every course's total draw.** Along every
course, what stands at its end and everything drawn on it are at most what stood at its start. -/
theorem trace_falls {S : Type u} {A : Type} {P : Process S A} {σ : S → Nat} {draw : A → Nat}
    (falls : FallsBy P σ draw) {s t : S} {as : List A} (h : Trace P s as t) :
    σ t + total as draw ≤ σ s := by
  induction h with
  | nil s => exact Nat.le_refl _
  | @cons s m t a as step _ ih =>
    calc σ t + (draw a + total as draw)
        = draw a + (σ t + total as draw) := Nat.add_left_comm _ _ _
      _ ≤ draw a + σ m := Nat.add_le_add_left ih _
      _ = σ m + draw a := Nat.add_comm _ _
      _ ≤ σ s := falls s a m step

/-- **Falling at every step is falling along every course.** -/
theorem falls_iff {S : Type u} {A : Type} {P : Process S A} {σ : S → Nat} {draw : A → Nat} :
    FallsBy P σ draw ↔ ∀ s as t, Trace P s as t → σ t + total as draw ≤ σ s :=
  ⟨fun falls _ _ _ h => trace_falls falls h,
   fun all s a t step => all s [a] t (.cons step (.nil t))⟩

/-- Along every course, the level ends at nothing or lower than it started by the course's length,
where every step from a positive level draws something. -/
theorem trace_exhausts {S : Type u} {A : Type} {P : Process S A} {σ : S → Nat} {draw : A → Nat}
    (falls : FallsBy P σ draw) (draws : ∀ s a t, P.step s a t → 0 < σ s → 0 < draw a)
    {s t : S} {as : List A} (h : Trace P s as t) : σ t = 0 ∨ σ t + as.length ≤ σ s := by
  induction h with
  | nil s => exact .inr (Nat.le_refl _)
  | @cons s m t a as step _ ih =>
    match ih, Nat.eq_zero_or_pos (σ s) with
    | .inl ended, _ => exact .inl ended
    | .inr lower, .inl empty =>
      have none : σ m + draw a ≤ 0 := Nat.le_trans (falls s a m step) (Nat.le_of_eq empty)
      have m_empty : σ m ≤ 0 := Nat.le_trans (Nat.le_add_right _ _) none
      exact .inl (Nat.eq_zero_of_le_zero
        (Nat.le_trans (Nat.le_add_right _ _) (Nat.le_trans lower m_empty)))
    | .inr lower, .inr positive =>
      have one : σ m + 1 ≤ σ s :=
        Nat.le_trans (Nat.add_le_add_left (draws s a m step positive) _) (falls s a m step)
      exact .inr (Nat.le_trans (Nat.add_le_add_right lower 1) one)

theorem zero_of_add_le : ∀ {a : Nat} (n : Nat), a + n ≤ n → a = 0
  | _, 0, h => Nat.eq_zero_of_le_zero h
  | _, n + 1, h => zero_of_add_le n (Nat.le_of_succ_le_succ h)

/-- **A level falling by each draw, where anything positive draws, is exhausted within as many
steps as it holds**: every course at least that long ends at nothing, and every step from nothing
draws nothing. -/
theorem exhausted_within {S : Type u} {A : Type} {P : Process S A} {σ : S → Nat}
    {draw : A → Nat} (falls : FallsBy P σ draw)
    (draws : ∀ s a t, P.step s a t → 0 < σ s → 0 < draw a)
    {s t : S} {as : List A} (h : Trace P s as t) (long : σ s ≤ as.length) : σ t = 0 :=
  match trace_exhausts falls draws h with
  | .inl ended => ended
  | .inr lower => zero_of_add_le as.length (Nat.le_trans lower long)

/-- From nothing, a step draws nothing. -/
theorem draws_nothing_from_empty {S : Type u} {A : Type} {P : Process S A} {σ : S → Nat}
    {draw : A → Nat} (falls : FallsBy P σ draw) {s t : S} {a : A} (step : P.step s a t)
    (empty : σ s = 0) : draw a = 0 :=
  Nat.eq_zero_of_le_zero
    (Nat.le_trans (Nat.le_add_left _ _) (Nat.le_trans (falls s a t step) (Nat.le_of_eq empty)))

end Stock

end Becoming

section StockTraces

/-!
## Stock traces: when a course is executable on a stock, in closed form

`Becoming.Stock` states that a course of the stock process, each step drawing from what is held
then replenishing, is executable exactly where each step's draw is within the stock then standing
(`Stock.feasible_iff_covered`), and that coverage has a closed form: at each step the initial
stock and everything replenished before the step cover everything drawn up to and including it
(`Stock.covered_iff_prefix`). This section states the closed form of the traces themselves.

* **Executable exactly in closed form.** A course of the stock process is executable from `n`
  exactly where, at each step, `n` and everything replenished before the step cover everything
  drawn up to and including it (`feasible_iff_prefix`).
* **Every trace, in closed form.** Along every course of every process whose stock is balanced and
  drawn from what is held, at each step the stock at the start and everything replenished before
  the step cover everything drawn up to and including it (`trace_prefix`).

No ethical predicate, ranking or axiom occurs.
-/

namespace Becoming

open Generative

universe u

namespace StockTraces

variable {S : Type u} {A : Type}

/-- **A course of the stock process is executable exactly where every prefix is covered.** -/
theorem feasible_iff_prefix {draw replenish : A → Nat} (as : List A) (n : Nat) :
    Feasible (Stock.process draw replenish) n as ↔
      ∀ u a v, as = u ++ a :: v → total u draw + draw a ≤ n + total u replenish :=
  (Stock.feasible_iff_covered as n).trans (Stock.covered_iff_prefix as n)

/-- **Every trace of a balanced stock drawn from what is held covers every prefix.** -/
theorem trace_prefix {P : Process S A} {σ : S → Nat} {draw replenish : A → Nat}
    (bal : Stock.Balanced P σ draw replenish) (held : Stock.DrawsHeld P σ draw)
    {s t : S} {as : List A} (trace : Trace P s as t) :
    ∀ u a v, as = u ++ a :: v → total u draw + draw a ≤ σ s + total u replenish :=
  (Stock.covered_iff_prefix as (σ s)).mp (Stock.covered_of_trace bal held trace)

end StockTraces

end Becoming

end StockTraces
