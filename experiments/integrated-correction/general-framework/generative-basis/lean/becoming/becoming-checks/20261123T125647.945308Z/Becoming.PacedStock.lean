import Becoming.Pace
import Becoming.Sampling
import Becoming.Granularity
import Becoming.Viability
import Becoming.JointKeeping
import Becoming.RegimeMargin
import Becoming.TurningInTime
import Becoming.LineOnAStock
import Becoming.WayUnderARule

/-!
# PacedStock: fine-step stock/unit dynamics under coarse rule cadences

AI-written (Milestone 1A), 23 November 2026.

This module joins fine-step unit/stock dynamics (`Becoming.LineOnAStock`, `Becoming.RegimeMargin`)
with coarse rule-update cadences (`Becoming.Pace`, `Becoming.Sampling`) and intra-span block
guards (`Becoming.Granularity.Frame.blocks`, `Becoming.Viability`, `Becoming.JointKeeping`),
proving the Pace–Margin Sandwich.

* **Pillar 1 (`StockState`, `fineStep`, `ReadAtSpanEnd`, `pacedCourse`, `paced_held_on_span`,
  `paced_block_transition`).** Between reading steps at span ends `σ (j + 1) - 1`, the rule stays
  fixed at `(pacedCourse ... c (σ j)).2`, and the stock/unit state evolves as the `LineOnAStock`
  orbit under that held rule. At `σ (j + 1)` the state advances by `σ (j + 1) - σ j` fine steps
  and the rule updates by `h` from the pre-boundary state at `σ (j + 1) - 1`.
* **Pillar 2 (`CoveredByBlocks`, `SpanGuard`, `blocks_kernel_iff_fine_kernel`,
  `blocks_certificate_to_fine_kernel`, `blocks_keepable_to_fine_*`,
  `slack_certifies_fine_kernel`, `slack_iff_of_drop_realized`, `SlackShortWitness`).**
  Intra-span viability of a fine guard matches block-level viability of `SpanGuard` under
  `CoveredByBlocks`. Because `Trace` is in `Prop` while `Run` carries `Type`-level state trajectories,
  constructive transport of `Keepable` without `Classical.choice` is stated for deterministic step
  laws (`blocks_keepable_to_fine_of_map`), singleton blocks (`blocks_keepable_to_fine_of_singleton`),
  and general processes under an explicit countable/dependent choice premise
  (`blocks_keepable_to_fine_of_choice`, `blocks_keepable_to_fine_of_dc`). Under a per-step drop
  bound along reachable fine transitions, an intra-span slack `stepDrop * (L - 1)` above `thr` at
  block boundaries certifies `Kernel` of `thr ≤ stock` everywhere; `SlackShortWitness` demonstrates
  that block-boundary `Kernel` and `Keepable` at `([true], 5)` both fail on the fine process,
  while `([true], 6)` is certified by `slack_certifies_fine_kernel`.
* **Pillar 3 (`UpperDraw`, `LowerDrawWhileMet`, `line_envelope`,
  `pace_margin_feasibility_window`, `pace_margin_feasibility_window_exact`,
  `unrecoverable_cadence_impossibility`, `coupled_two_rule_impossibility`, `SandwichWitness`).**
  `line_envelope` bounds `LineOnAStock` stock levels from below (under `UpperDraw`, needing no
  monotonicity of `giving`) and from above (under `AtMost` and `LowerDrawWhileMet`). For
  `2N - 1 ≤ L` and initial buffer `H₂ + y₂ + H₁ * (L + 1) ≤ x₀ ≤ hi` (plus either
  `H₂ + H₂ + y₂ ≤ hi` when safe draw closure gives `taken ≤ H₂`, or exact draw `taken = H₂`),
  `pace_margin_feasibility_window` guarantees survival for all `t ≥ L + 1`. Conversely, when
  `x₀ < (H₂ + y₂) + (H₁ - Y) * (2N - 1)`, `unrecoverable_cadence_impossibility` and
  `coupled_two_rule_impossibility` prove the Pace–Margin Sandwich: short cadences `L < 2N - 1`
  cannot distinguish the two `N`-state `lassoStep` rules across `span σ 0`, while long cadences
  `2N - 1 ≤ L` cannot rescue the bad start by switching to `g_safe` at `σ 1 = L`.

Every declaration compiles from Lean's prelude alone with an empty axiom report (`0` axioms,
`0` `sorry`).
-/

namespace Becoming
namespace PacedStock

open Generative

universe u v v' w

/-! ## Arithmetic helpers (prelude-only, empty axiom report) -/

section Arith

private theorem sub_le_sub_right_nat : ∀ {a b : Nat} (c : Nat), a ≤ b → a - c ≤ b - c
  | _, _, 0, h => h
  | _, _, c + 1, h => Nat.pred_le_pred (sub_le_sub_right_nat c h)

private theorem sub_le_sub_left_nat : ∀ (a b c : Nat), a ≤ b → c - b ≤ c - a
  | 0, b, c, _ => Nat.sub_le c b
  | _ + 1, 0, _, h => absurd h (Nat.not_succ_le_zero _)
  | a + 1, b + 1, 0, _ =>
    Nat.le_trans (Nat.le_of_eq (Nat.zero_sub (b + 1))) (Nat.zero_le (0 - (a + 1)))
  | a + 1, b + 1, c + 1, h =>
    Nat.le_trans (Nat.le_of_eq (Nat.succ_sub_succ c b))
      (Nat.le_trans (sub_le_sub_left_nat a b c (Nat.le_of_succ_le_succ h))
        (Nat.le_of_eq (Nat.succ_sub_succ c a).symm))

private theorem le_pred_of_succ_le {a b : Nat} (h : a + 1 ≤ b) : a ≤ b - 1 :=
  match b, h with
  | _ + 1, h => Nat.le_of_succ_le_succ h

private theorem lt_of_add_lt_add_left_nat {a b c : Nat} (h : a + b < a + c) : b < c :=
  Naturals.le_of_add_le_add_left (k := a)
    (Nat.le_trans (Nat.le_of_eq (Nat.add_succ a b).symm) h)

private theorem two_mul_pred_eq (N : Nat) : 2 * N - 1 = N + N - 1 :=
  congrArg (· - 1) (Naturals.two_mul N)

end Arith

/-! ## Pillar 1: Fine-step stock/unit evolution under coarse rule cadence -/

/-- State of a fast subsystem coupled with a `LineOnAStock` way-and-level configuration. -/
abbrev StockState (A U : Type) : Type := A × (List U × Nat)

/-- One fine step of the coupled state under rule `g`: the subsystem `A` steps by `fA` and
the stock/unit state steps by `LineOnAStock.step` under `kids g`. -/
def fineStep {A U R : Type}
    (fA : A → R → A) (need : U → Nat) (kids : R → U → List U)
    (giving : Nat → Nat) (use : U → Nat)
    (s : StockState A U) (g : R) : StockState A U :=
  (fA s.1 g, LineOnAStock.step need (kids g) giving use s.2)

/-- Reading cadence aligned with the end of every sampling span `span σ j`:
within `σ j ≤ t < σ (j + 1)`, `reads t = true` holds iff `t + 1 = σ (j + 1)`. -/
def ReadAtSpanEnd (σ : Nat → Nat) (reads : Nat → Bool) : Prop :=
  ∀ j t, σ j ≤ t → t < σ (j + 1) → (reads t = true ↔ t + 1 = σ (j + 1))

/-- The paced coupled course under `fineStep`, rule update `h`, and reading schedule `reads`. -/
abbrev pacedCourse {A U R : Type}
    (fA : A → R → A) (need : U → Nat) (kids : R → U → List U)
    (giving : Nat → Nat) (use : U → Nat)
    (h : StockState A U → R → R) (reads : Nat → Bool)
    (c : StockState A U × R) (t : Nat) : StockState A U × R :=
  Pace.paced (fineStep fA need kids giving use) h reads c t

section Pillar1

variable {A U R : Type}
  {fA : A → R → A} {need : U → Nat} {kids : R → U → List U}
  {giving : Nat → Nat} {use : U → Nat}

theorem fineStep_orbit_fst (s : StockState A U) (g : R) :
    ∀ k, (Law.orbit (fun y => fineStep fA need kids giving use y g) s k).1 =
      Law.orbit (fun a => fA a g) s.1 k
  | 0 => rfl
  | k + 1 => congrArg (fun a => fA a g) (fineStep_orbit_fst s g k)

theorem fineStep_orbit_snd (s : StockState A U) (g : R) :
    ∀ k, (Law.orbit (fun y => fineStep fA need kids giving use y g) s k).2 =
      Law.orbit (LineOnAStock.step need (kids g) giving use) s.2 k
  | 0 => rfl
  | k + 1 => congrArg (LineOnAStock.step need (kids g) giving use) (fineStep_orbit_snd s g k)

private theorem span_end_decomp {σ : Nat → Nat} (strict : Becoming.Strict σ) (j : Nat) :
    ∃ m, σ (j + 1) = σ j + m + 1 :=
  match le_dest (Nat.succ_le_of_lt (strict j)) with
  | ⟨m, same⟩ => ⟨m, same.trans ((Nat.add_assoc (σ j) 1 m).trans
      ((congrArg (σ j + ·) (Nat.add_comm 1 m)).trans (Nat.add_assoc (σ j) m 1).symm))⟩

private theorem reads_false_on_span_prefix {σ : Nat → Nat} {reads : Nat → Bool}
    (cadence : ReadAtSpanEnd σ reads) {j m : Nat} (atEnd : σ (j + 1) = σ j + m + 1)
    {i : Nat} (lt : i < m) : reads (σ j + i) = false :=
  have inSpan : σ j + i < σ (j + 1) :=
    Eq.subst (motive := fun x => σ j + i < x) atEnd.symm
      (Nat.lt_succ_of_le (Nat.add_le_add_left (Nat.le_of_lt lt) (σ j)))
  have notEnd : σ j + i + 1 ≠ σ (j + 1) :=
    Naturals.ne_of_lt (Eq.subst (motive := fun x => σ j + i + 1 < x) atEnd.symm
      (Nat.add_lt_add_right (Nat.add_lt_add_left lt (σ j)) 1))
  ListTests.false_of_not_true fun yes =>
    notEnd ((cadence j (σ j + i) (Nat.le_add_right _ _) inSpan).mp yes)

/-- Auxiliary span characterization: on any `t ∈ span σ j`, `pacedCourse` equals the held-rule
orbit of `fineStep` for `t - σ j` steps. -/
theorem paced_held_on_span_state
    {h : StockState A U → R → R} {reads : Nat → Bool} {σ : Nat → Nat}
    (strict : Becoming.Strict σ) (cadence : ReadAtSpanEnd σ reads)
    (c : StockState A U × R) {j t : Nat} (mem : t ∈ Becoming.span σ j) :
    pacedCourse fA need kids giving use h reads c t =
      (Law.orbit (fun y => fineStep fA need kids giving use y
          (pacedCourse fA need kids giving use h reads c (σ j)).2)
        (pacedCourse fA need kids giving use h reads c (σ j)).1 (t - σ j),
       (pacedCourse fA need kids giving use h reads c (σ j)).2) :=
  match Becoming.mem_span strict mem, span_end_decomp strict j with
  | ⟨hle, hlt⟩, ⟨m, atEnd⟩ =>
    have below : t - σ j ≤ m :=
      Nat.le_of_lt_succ (lt_of_add_lt_add_left_nat (a := σ j)
        (Eq.subst (motive := fun x => x < σ j + (m + 1)) (add_sub_of_le hle).symm
          (Eq.subst (motive := fun x => t < x) (atEnd.trans (Nat.add_assoc (σ j) m 1)) hlt)))
    have stretched := Pace.paced_stretch (f := fineStep fA need kids giving use) (h := h)
      (reads := reads) (c := c) (a := σ j) (k := m)
      (fun _ lt => reads_false_on_span_prefix cadence atEnd lt) (t - σ j) below
    Eq.subst (motive := fun n =>
      pacedCourse fA need kids giving use h reads c n =
        (Law.orbit (fun y => fineStep fA need kids giving use y
            (pacedCourse fA need kids giving use h reads c (σ j)).2)
          (pacedCourse fA need kids giving use h reads c (σ j)).1 (t - σ j),
         (pacedCourse fA need kids giving use h reads c (σ j)).2))
      (add_sub_of_le hle) stretched

/-- **Theorem 1A (`paced_held_on_span`).** Under `Strict σ` and `ReadAtSpanEnd σ reads`, for every
span `j` and fine step `t ∈ span σ j`:
1. the active rule equals the rule at the start of the span `(pacedCourse ... c (σ j)).2`;
2. the stock/unit component equals the `LineOnAStock` orbit under that held rule for `t - σ j` steps. -/
theorem paced_held_on_span
    {h : StockState A U → R → R} {reads : Nat → Bool} {σ : Nat → Nat}
    (strict : Becoming.Strict σ) (cadence : ReadAtSpanEnd σ reads)
    (c : StockState A U × R) {j t : Nat} (mem : t ∈ Becoming.span σ j) :
    (pacedCourse fA need kids giving use h reads c t).2 =
        (pacedCourse fA need kids giving use h reads c (σ j)).2 ∧
      (pacedCourse fA need kids giving use h reads c t).1.2 =
        Law.orbit (LineOnAStock.step need
            (kids (pacedCourse fA need kids giving use h reads c (σ j)).2) giving use)
          (pacedCourse fA need kids giving use h reads c (σ j)).1.2 (t - σ j) :=
  have eqState := paced_held_on_span_state strict cadence c mem
  have eq2 := congrArg Prod.snd eqState
  ⟨eq2,
   (congrArg (fun p : StockState A U × R => p.1.2) eqState).trans
     (fineStep_orbit_snd _ _ (t - σ j))⟩

/-- **Theorem 1B (`paced_block_transition`).** Under `Strict σ` and `ReadAtSpanEnd σ reads`, at the
next sampling boundary `σ (j + 1)`:
1. the fast coupled state equals the `fineStep` orbit for `σ (j + 1) - σ j` steps under the rule
   held across span `j`;
2. the rule updates via `h` applied to the fast state at `σ (j + 1) - 1` and the held rule. -/
theorem paced_block_transition
    {h : StockState A U → R → R} {reads : Nat → Bool} {σ : Nat → Nat}
    (strict : Becoming.Strict σ) (cadence : ReadAtSpanEnd σ reads)
    (c : StockState A U × R) (j : Nat) :
    (pacedCourse fA need kids giving use h reads c (σ (j + 1))).1 =
        Law.orbit (fun y => fineStep fA need kids giving use y
            (pacedCourse fA need kids giving use h reads c (σ j)).2)
          (pacedCourse fA need kids giving use h reads c (σ j)).1 (σ (j + 1) - σ j) ∧
      (pacedCourse fA need kids giving use h reads c (σ (j + 1))).2 =
        h (pacedCourse fA need kids giving use h reads c (σ (j + 1) - 1)).1
          (pacedCourse fA need kids giving use h reads c (σ j)).2 :=
  match span_end_decomp strict j with
  | ⟨m, atEnd⟩ =>
    have predEq : σ (j + 1) - 1 = σ j + m :=
      (congrArg (· - 1) atEnd).trans (Naturals.add_sub_cancel (σ j + m) 1)
    have spanLen : σ (j + 1) - σ j = m + 1 :=
      (congrArg (· - σ j) (atEnd.trans (Nat.add_assoc (σ j) m 1))).trans
        (Naturals.add_sub_cancel_left (σ j) (m + 1))
    have atPre := Pace.paced_stretch (f := fineStep fA need kids giving use) (h := h)
      (reads := reads) (c := c) (a := σ j) (k := m)
      (fun _ lt => reads_false_on_span_prefix cadence atEnd lt) m (Nat.le_refl m)
    have readsEnd : reads (σ j + m) = true :=
      (cadence j (σ j + m) (Nat.le_add_right _ _)
        (Eq.subst (motive := fun x => σ j + m < x) atEnd.symm (Nat.lt_succ_self _))).mpr
        atEnd.symm
    have stepEnd : pacedCourse fA need kids giving use h reads c (σ (j + 1)) =
        Pace.turn (fineStep fA need kids giving use) h true
          (pacedCourse fA need kids giving use h reads c (σ j + m)) :=
      (congrArg (pacedCourse fA need kids giving use h reads c) atEnd).trans
        ((Pace.paced_succ (f := fineStep fA need kids giving use) (h := h) (reads := reads) c
          (σ j + m)).trans
          (congrArg (fun b => Pace.turn (fineStep fA need kids giving use) h b
              (pacedCourse fA need kids giving use h reads c (σ j + m))) readsEnd))
    ⟨(congrArg Prod.fst stepEnd).trans
       ((congrArg (fun p : StockState A U × R =>
           fineStep fA need kids giving use p.1 p.2) atPre).trans
         (congrArg (Law.orbit (fun y => fineStep fA need kids giving use y
             (pacedCourse fA need kids giving use h reads c (σ j)).2)
           (pacedCourse fA need kids giving use h reads c (σ j)).1) spanLen.symm)),
     (congrArg Prod.snd stepEnd).trans
       ((congrArg (fun n => h (pacedCourse fA need kids giving use h reads c n).1
           (pacedCourse fA need kids giving use h reads c (σ j + m)).2) predEq.symm).trans
         (congrArg (h (pacedCourse fA need kids giving use h reads c (σ (j + 1) - 1)).1)
           (have atPre2 := congrArg Prod.snd atPre; atPre2)))⟩

end Pillar1

/-! ## Pillar 2: Intra-span slack & block guards (`Frame.blocks` × `Viability`) -/

section Pillar2

variable {S : Type u} {A : Type v} {B : Type v'} {C : Type w}

/-- Every fine configuration reachable from `s` lies along some prefix `pre` of a block
`expand b` starting from a block-reachable configuration `v`. -/
def CoveredByBlocks (F : Frame S A C) (expand : B → List A) (s : S) : Prop :=
  ∀ t, Reach F.P s t →
    ∃ v, Reach (F.blocks expand).P s v ∧
      ∃ b pre post, expand b = pre ++ post ∧ Trace F.P v pre t

/-- Intra-span block guard: `guard` holds at `v` and at every intermediate state reached along
any prefix `pre` of any block `expand b` from `v`. -/
def SpanGuard (F : Frame S A C) (expand : B → List A) (guard : S → Prop) (v : S) : Prop :=
  guard v ∧ ∀ b pre post m, expand b = pre ++ post → Trace F.P v pre m → guard m

theorem blocks_reach_to_fine (F : Frame S A C) (expand : B → List A) {s v : S}
    (reach : Reach (F.blocks expand).P s v) : Reach F.P s v :=
  match reach with
  | ⟨word, path⟩ => ⟨Segmentation.encode expand word, (F.blocks_trace_iff expand word).mp path⟩

/-- **Theorem 2A (Kernel equivalence).** Under `CoveredByBlocks F expand s`, fine-grained
invariance of `guard` from `s` holds iff block-grained invariance of `SpanGuard F expand guard`
from `s` holds. -/
theorem blocks_kernel_iff_fine_kernel (F : Frame S A C) (expand : B → List A)
    (guard : S → Prop) {s : S} (covered : CoveredByBlocks F expand s) :
    Viability.Kernel F.P guard s ↔
      Viability.Kernel (F.blocks expand).P (SpanGuard F expand guard) s :=
  ⟨fun fineKernel v reachB =>
     have reachF := blocks_reach_to_fine F expand reachB
     ⟨fineKernel v reachF,
      fun _ _ _ _ _ path => fineKernel _ (reachF.trans ⟨_, path⟩)⟩,
   fun blockKernel t reachF =>
     match covered t reachF with
     | ⟨v, reachB, b, pre, post, eq, path⟩ =>
       (blockKernel v reachB).2 b pre post t eq path⟩

/-- **Theorem 2A (Certificate transport).** A block-level `Certificate` for `SpanGuard F expand guard`
containing `s` certifies fine-level `Viability.Kernel F.P guard s` under `CoveredByBlocks`. -/
theorem blocks_certificate_to_fine_kernel (F : Frame S A C) (expand : B → List A)
    (guard : S → Prop) {s : S} (covered : CoveredByBlocks F expand s)
    {K : S → Prop} (cert : Viability.Certificate (F.blocks expand).P (SpanGuard F expand guard) K)
    (held : K s) : Viability.Kernel F.P guard s :=
  (blocks_kernel_iff_fine_kernel F expand guard covered).mpr (cert.kernel held)

section KeepableTransport

private def consumeWord {S : Type u} {A : Type v}
    (next : S → A → S) (k : Nat) (curr : S) : List A → Nat × List A × S
  | [] => (k + 1, [], curr)
  | [a] => (k + 1, [], next curr a)
  | a :: b :: rest => (k, b :: rest, next curr a)

private def flattenStep {S : Type u} {A : Type v} {B : Type v'}
    (next : S → A → S) (act : Nat → B) (expand : B → List A) :
    Nat × List A × S → Nat × List A × S
  | (k, [], curr) => consumeWord next k curr (expand (act k))
  | (k, a :: rest, curr) => consumeWord next k curr (a :: rest)

private def flattenAct {S : Type u} {A : Type v} {B : Type v'}
    (act : Nat → B) (expand : B → List A) (dflt : A) : Nat × List A × S → A
  | (k, [], _) => match expand (act k) with
    | [] => dflt
    | a :: _ => a
  | (_, a :: _, _) => a

private def FlattenInv {S : Type u} {A : Type v} {B : Type v'} {C : Type w}
    (F : Frame S A C) (expand : B → List A) (r : Run (F.blocks expand).P)
    (p : Nat × List A × S) : Prop :=
  (p.2.1 = [] ∧ p.2.2 = r.state p.1) ∨
    ∃ pre, expand (r.act p.1) = pre ++ p.2.1 ∧ p.2.1 ≠ [] ∧
      Trace F.P (r.state p.1) pre p.2.2 ∧ Trace F.P p.2.2 p.2.1 (r.state (p.1 + 1))

private theorem flatten_step_inv
    {F : Frame S A C} {expand : B → List A}
    (next : S → A → S) (law : ∀ x a y, F.P.step x a y → y = next x a)
    (nonempty : ∀ b, expand b ≠ [])
    (r : Run (F.blocks expand).P) (dflt : A)
    {p : Nat × List A × S} (inv : FlattenInv F expand r p) :
    FlattenInv F expand r (flattenStep next r.act expand p) ∧
      F.P.step p.2.2 (flattenAct r.act expand dflt p)
        (flattenStep next r.act expand p).2.2 := by
  rcases p with ⟨k, rest, curr⟩
  dsimp [FlattenInv] at inv
  cases rest with
  | nil =>
    rcases inv with ⟨_, eqCurr⟩ | ⟨_, _, neNil, _, _⟩
    · subst eqCurr
      cases hw : expand (r.act k) with
      | nil => exact absurd hw (nonempty (r.act k))
      | cons a ws =>
        have trace0 : Trace F.P (r.state k) (a :: ws) (r.state (k + 1)) := by
          have hs := r.step k
          change Trace F.P (r.state k) (expand (r.act k)) (r.state (k + 1)) at hs
          rw [hw] at hs
          exact hs
        rcases trace_cons_iff.mp trace0 with ⟨m, stepA, tail⟩
        have eqM : m = next (r.state k) a := law _ _ _ stepA
        subst eqM
        cases ws with
        | nil =>
          have eqEnd : next (r.state k) a = r.state (k + 1) := trace_nil_iff.mp tail
          have stepEq : flattenStep next r.act expand (k, [], r.state k) =
              (k + 1, [], next (r.state k) a) := by
            show consumeWord next k (r.state k) (expand (r.act k)) = _
            rw [hw]
            rfl
          have actEq : flattenAct r.act expand dflt (k, [], r.state k) = a := by
            show (match expand (r.act k) with | [] => dflt | x :: _ => x) = a
            rw [hw]
          rw [stepEq, actEq]
          exact ⟨Or.inl ⟨rfl, eqEnd⟩, stepA⟩
        | cons b ws' =>
          have stepEq : flattenStep next r.act expand (k, [], r.state k) =
              (k, b :: ws', next (r.state k) a) := by
            show consumeWord next k (r.state k) (expand (r.act k)) = _
            rw [hw]
            rfl
          have actEq : flattenAct r.act expand dflt (k, [], r.state k) = a := by
            show (match expand (r.act k) with | [] => dflt | x :: _ => x) = a
            rw [hw]
          rw [stepEq, actEq]
          exact ⟨Or.inr ⟨[a], hw, List.cons_ne_nil b ws',
            trace_singleton_iff.mpr stepA, tail⟩, stepA⟩
    · exact absurd rfl neNil
  | cons a ws =>
    rcases inv with ⟨eqNil, _⟩ | ⟨pre, eqWord, _, tracePre, traceRest⟩
    · exact absurd eqNil (List.cons_ne_nil a ws)
    · rcases trace_cons_iff.mp traceRest with ⟨m, stepA, tail⟩
      have eqM : m = next curr a := law _ _ _ stepA
      subst eqM
      cases ws with
      | nil =>
        have eqEnd : next curr a = r.state (k + 1) := trace_nil_iff.mp tail
        exact ⟨Or.inl ⟨rfl, eqEnd⟩, stepA⟩
      | cons b ws' =>
        have eqAssoc : expand (r.act k) = (pre ++ [a]) ++ (b :: ws') :=
          eqWord.trans (ListTests.append_assoc pre [a] (b :: ws')).symm
        have tracePre' : Trace F.P (r.state k) (pre ++ [a]) (next curr a) :=
          trace_append_iff.mpr ⟨curr, tracePre, trace_singleton_iff.mpr stepA⟩
        exact ⟨Or.inr ⟨pre ++ [a], eqAssoc, List.cons_ne_nil b ws', tracePre', tail⟩, stepA⟩

private theorem flatten_orbit_inv
    {F : Frame S A C} {expand : B → List A}
    (next : S → A → S) (law : ∀ x a y, F.P.step x a y → y = next x a)
    (nonempty : ∀ b, expand b ≠ [])
    (r : Run (F.blocks expand).P) (dflt : A) :
    ∀ n, FlattenInv F expand r
      (Law.orbit (flattenStep next r.act expand) (0, [], r.state 0) n)
  | 0 => Or.inl ⟨rfl, rfl⟩
  | n + 1 => (flatten_step_inv next law nonempty r dflt (flatten_orbit_inv next law nonempty r dflt n)).1

/-- **Theorem 2A (Sound one-way `Keepable`, deterministic fine step).** If every block is
non-empty and `F.P` follows a deterministic step map `next`, block-level `Keepable` of
`SpanGuard F expand guard` implies fine-level `Keepable F.P guard`. -/
theorem blocks_keepable_to_fine_of_map (F : Frame S A C) (expand : B → List A)
    (guard : S → Prop) {s : S}
    (next : S → A → S) (law : ∀ x a y, F.P.step x a y → y = next x a)
    (nonempty : ∀ b, expand b ≠ [])
    (kept : Viability.Keepable (F.blocks expand).P (SpanGuard F expand guard) s) :
    Viability.Keepable F.P guard s := by
  rcases kept with ⟨r, r0, spanHeld⟩
  cases h0 : expand (r.act 0) with
  | nil => exact absurd h0 (nonempty (r.act 0))
  | cons dflt _ =>
    let orb := Law.orbit (flattenStep next r.act expand) (0, [], r.state 0)
    refine ⟨⟨fun n => (orb n).2.2,
             fun n => flattenAct r.act expand dflt (orb n),
             fun n => (flatten_step_inv next law nonempty r dflt
               (flatten_orbit_inv next law nonempty r dflt n)).2⟩,
            r0, fun n => ?_⟩
    rcases flatten_orbit_inv next law nonempty r dflt n with ⟨_, eqSt⟩ | ⟨pre, eqWord, _, tracePre, _⟩
    · exact Eq.subst (motive := guard) eqSt.symm (spanHeld (orb n).1).1
    · exact (spanHeld (orb n).1).2 (r.act (orb n).1) pre (orb n).2.1 (orb n).2.2 eqWord tracePre

private def headOfNeNil {α : Type v} : ∀ l : List α, l ≠ [] → α
  | a :: _, _ => a
  | [], h => False.elim (h rfl)

private theorem headOfNeNil_singleton {α : Type v} :
    ∀ (l : List α) (h : l ≠ []) (a : α), l = [a] → headOfNeNil l h = a
  | [_], _, _, rfl => rfl
  | [], h, _, _ => absurd rfl h
  | _ :: _ :: _, _, _, eq => nomatch eq

/-- **Theorem 2A (Sound one-way `Keepable`, singleton blocks).** When every block has length 1,
no intermediate fine states exist and block-level `Keepable` transports directly for any `F`. -/
theorem blocks_keepable_to_fine_of_singleton (F : Frame S A C) (expand : B → List A)
    (guard : S → Prop) {s : S}
    (single : ∀ b, ∃ a, expand b = [a])
    (kept : Viability.Keepable (F.blocks expand).P (SpanGuard F expand guard) s) :
    Viability.Keepable F.P guard s := by
  rcases kept with ⟨r, r0, spanHeld⟩
  have neNil : ∀ b, expand b ≠ [] := fun b e =>
    match single b with
    | ⟨_, eq⟩ => nomatch (e.symm.trans eq)
  let pick : B → A := fun b => headOfNeNil (expand b) (neNil b)
  have pickEq : ∀ b, expand b = [pick b] := fun b =>
    match single b with
    | ⟨a, eq⟩ => eq.trans (congrArg (fun x => [x]) (headOfNeNil_singleton (expand b) (neNil b) a eq).symm)
  refine ⟨⟨r.state, fun n => pick (r.act n), fun n => ?_⟩, r0, fun n => (spanHeld n).1⟩
  have stepN := r.step n
  change Trace F.P (r.state n) (expand (r.act n)) (r.state (n + 1)) at stepN
  rw [pickEq (r.act n)] at stepN
  exact trace_singleton_iff.mp stepN

private inductive PathStates (P : Process S A) : S → List A → S → List S → Prop where
  | nil (s : S) : PathStates P s [] s []
  | cons {s m t : S} {a : A} {as : List A} {rest : List S} :
      P.step s a m → PathStates P m as t rest → PathStates P s (a :: as) t (m :: rest)

private theorem pathStates_nil {P : Process S A} {s t : S} {ms : List S} :
    PathStates P s [] t ms → s = t
  | .nil _ => rfl

private theorem pathStates_cons {P : Process S A} {s t : S} {a : A} {as : List A} {ms : List S} :
    PathStates P s (a :: as) t ms →
      ∃ m rest, ms = m :: rest ∧ P.step s a m ∧ PathStates P m as t rest
  | .cons h tail => ⟨_, _, rfl, h, tail⟩

private theorem trace_exists_pathStates {P : Process S A} :
    ∀ {s : S} {word : List A} {t : S}, Trace P s word t → ∃ ms, PathStates P s word t ms
  | _, [], _, .nil s => ⟨[], .nil s⟩
  | _, _ :: _, _, .cons step tail =>
    match trace_exists_pathStates tail with
    | ⟨rest, ps⟩ => ⟨_ :: rest, .cons step ps⟩

private def consumeChoiceWord {S : Type u} {A : Type v}
    (k : Nat) (curr : S) : List A → List S → Nat × List A × List S × S
  | [], _ => (k + 1, [], [], curr)
  | _ :: ws, ms =>
    match ms with
    | [] => (k + 1, [], [], curr)
    | m :: ms' =>
      match ws with
      | [] => (k + 1, [], [], m)
      | b :: ws' => (k, b :: ws', ms', m)

private def flattenChoiceStep {S : Type u} {A : Type v} {B : Type v'}
    (act : Nat → B) (expand : B → List A) (mids : Nat → List S) :
    Nat × List A × List S × S → Nat × List A × List S × S
  | (k, [], _, curr) => consumeChoiceWord k curr (expand (act k)) (mids k)
  | (k, a :: ws, ms, curr) => consumeChoiceWord k curr (a :: ws) ms

private def flattenChoiceAct {S : Type u} {A : Type v} {B : Type v'}
    (act : Nat → B) (expand : B → List A) (dflt : A) : Nat × List A × List S × S → A
  | (k, [], _, _) => match expand (act k) with
    | [] => dflt
    | a :: _ => a
  | (_, a :: _, _, _) => a

private def FlattenChoiceInv {S : Type u} {A : Type v} {B : Type v'} {C : Type w}
    (F : Frame S A C) (expand : B → List A) (r : Run (F.blocks expand).P)
    (p : Nat × List A × List S × S) : Prop :=
  (p.2.1 = [] ∧ p.2.2.2 = r.state p.1) ∨
    ∃ pre, expand (r.act p.1) = pre ++ p.2.1 ∧ p.2.1 ≠ [] ∧
      Trace F.P (r.state p.1) pre p.2.2.2 ∧
      PathStates F.P p.2.2.2 p.2.1 (r.state (p.1 + 1)) p.2.2.1

private theorem flattenChoice_step_inv
    {F : Frame S A C} {expand : B → List A}
    (nonempty : ∀ b, expand b ≠ [])
    (r : Run (F.blocks expand).P) (mids : Nat → List S)
    (valid : ∀ k, PathStates F.P (r.state k) (expand (r.act k)) (r.state (k + 1)) (mids k))
    (dflt : A) {p : Nat × List A × List S × S}
    (inv : FlattenChoiceInv F expand r p) :
    FlattenChoiceInv F expand r (flattenChoiceStep r.act expand mids p) ∧
      F.P.step p.2.2.2 (flattenChoiceAct r.act expand dflt p)
        (flattenChoiceStep r.act expand mids p).2.2.2 := by
  rcases p with ⟨k, rest, ms, curr⟩
  dsimp [FlattenChoiceInv] at inv
  cases rest with
  | nil =>
    rcases inv with ⟨_, eqCurr⟩ | ⟨_, _, neNil, _, _⟩
    · subst eqCurr
      cases hw : expand (r.act k) with
      | nil => exact absurd hw (nonempty (r.act k))
      | cons a ws =>
        have ps0 := valid k
        rw [hw] at ps0
        rcases pathStates_cons ps0 with ⟨m, restMs, eqMids, stepA, tailPs⟩
        have actEq : flattenChoiceAct r.act expand dflt (k, [], ms, r.state k) = a := by
          show (match expand (r.act k) with | [] => dflt | x :: _ => x) = a
          rw [hw]
        cases ws with
        | nil =>
          have eqEnd : m = r.state (k + 1) := pathStates_nil tailPs
          have stepEq : flattenChoiceStep r.act expand mids (k, [], ms, r.state k) =
              (k + 1, [], [], m) := by
            show consumeChoiceWord k (r.state k) (expand (r.act k)) (mids k) = _
            rw [hw, eqMids]
            rfl
          rw [stepEq, actEq]
          exact ⟨Or.inl ⟨rfl, eqEnd⟩, stepA⟩
        | cons b ws' =>
          have stepEq : flattenChoiceStep r.act expand mids (k, [], ms, r.state k) =
              (k, b :: ws', restMs, m) := by
            show consumeChoiceWord k (r.state k) (expand (r.act k)) (mids k) = _
            rw [hw, eqMids]
            rfl
          rw [stepEq, actEq]
          exact ⟨Or.inr ⟨[a], hw, List.cons_ne_nil b ws', trace_singleton_iff.mpr stepA, tailPs⟩,
            stepA⟩
    · exact absurd rfl neNil
  | cons a ws =>
    rcases inv with ⟨eqNil, _⟩ | ⟨pre, eqWord, _, tracePre, psRest⟩
    · exact absurd eqNil (List.cons_ne_nil a ws)
    · rcases pathStates_cons psRest with ⟨m, restMs, eqMs, stepA, tailPs⟩
      subst eqMs
      cases ws with
      | nil =>
        have eqEnd : m = r.state (k + 1) := pathStates_nil tailPs
        exact ⟨Or.inl ⟨rfl, eqEnd⟩, stepA⟩
      | cons b ws' =>
        have eqAssoc : expand (r.act k) = (pre ++ [a]) ++ (b :: ws') :=
          eqWord.trans (ListTests.append_assoc pre [a] (b :: ws')).symm
        have tracePre' : Trace F.P (r.state k) (pre ++ [a]) m :=
          trace_append_iff.mpr ⟨curr, tracePre, trace_singleton_iff.mpr stepA⟩
        exact ⟨Or.inr ⟨pre ++ [a], eqAssoc, List.cons_ne_nil b ws', tracePre', tailPs⟩, stepA⟩

private theorem flattenChoice_orbit_inv
    {F : Frame S A C} {expand : B → List A}
    (nonempty : ∀ b, expand b ≠ [])
    (r : Run (F.blocks expand).P) (mids : Nat → List S)
    (valid : ∀ k, PathStates F.P (r.state k) (expand (r.act k)) (r.state (k + 1)) (mids k))
    (dflt : A) :
    ∀ n, FlattenChoiceInv F expand r
      (Law.orbit (flattenChoiceStep r.act expand mids) (0, [], [], r.state 0) n)
  | 0 => Or.inl ⟨rfl, rfl⟩
  | n + 1 => (flattenChoice_step_inv nonempty r mids valid dflt
      (flattenChoice_orbit_inv nonempty r mids valid dflt n)).1

/-- **Theorem 2A (Sound one-way `Keepable`, general process under countable choice).**
For any (possibly non-deterministic) frame `F`, given an explicit countable-choice witness for
sequences of intermediate `List S` paths, block-level `Keepable` of `SpanGuard F expand guard`
implies fine-level `Keepable F.P guard`. -/
theorem blocks_keepable_to_fine_of_choice (F : Frame S A C) (expand : B → List A)
    (guard : S → Prop) {s : S}
    (cc : ∀ R : Nat → List S → Prop, (∀ n, ∃ xs, R n xs) → ∃ f : Nat → List S, ∀ n, R n (f n))
    (nonempty : ∀ b, expand b ≠ [])
    (kept : Viability.Keepable (F.blocks expand).P (SpanGuard F expand guard) s) :
    Viability.Keepable F.P guard s := by
  rcases kept with ⟨r, r0, spanHeld⟩
  rcases cc (fun k ms => PathStates F.P (r.state k) (expand (r.act k)) (r.state (k + 1)) ms)
      (fun k => trace_exists_pathStates (r.step k)) with ⟨mids, valid⟩
  cases h0 : expand (r.act 0) with
  | nil => exact absurd h0 (nonempty (r.act 0))
  | cons dflt _ =>
    let orb := Law.orbit (flattenChoiceStep r.act expand mids) (0, [], [], r.state 0)
    refine ⟨⟨fun n => (orb n).2.2.2,
             fun n => flattenChoiceAct r.act expand dflt (orb n),
             fun n => (flattenChoice_step_inv nonempty r mids valid dflt
               (flattenChoice_orbit_inv nonempty r mids valid dflt n)).2⟩,
            r0, fun n => ?_⟩
    rcases flattenChoice_orbit_inv nonempty r mids valid dflt n with
      ⟨_, eqSt⟩ | ⟨pre, eqWord, _, tracePre, _⟩
    · exact Eq.subst (motive := guard) eqSt.symm (spanHeld (orb n).1).1
    · exact (spanHeld (orb n).1).2 (r.act (orb n).1) pre (orb n).2.1 (orb n).2.2.2 eqWord tracePre

/-- **Theorem 2A (Sound one-way `Keepable`, general process under `DependentChoice`).** -/
theorem blocks_keepable_to_fine_of_dc (F : Frame S A C) (expand : B → List A)
    (guard : S → Prop) {s : S}
    (dc : ∀ (α : Type u) (R : α → α → Prop), (∀ x, ∃ y, R x y) →
      ∀ x, ∃ f : Nat → α, f 0 = x ∧ ∀ n, R (f n) (f (n + 1)))
    (nonempty : ∀ b, expand b ≠ [])
    (kept : Viability.Keepable (F.blocks expand).P (SpanGuard F expand guard) s) :
    Viability.Keepable F.P guard s := by
  refine blocks_keepable_to_fine_of_choice F expand guard (fun R hex => ?_) nonempty kept
  rcases hex 0 with ⟨xs0, h0⟩
  rcases dc (Nat × List S) (fun p q => q.1 = p.1 + 1 ∧ R q.1 q.2)
      (fun p => match hex (p.1 + 1) with | ⟨xs, hxs⟩ => ⟨(p.1 + 1, xs), rfl, hxs⟩)
      (0, xs0) with ⟨f, f0, hstep⟩
  have fstEq : ∀ n, (f n).1 = n := fun n => by
    induction n with
    | zero => exact congrArg Prod.fst f0
    | succ k ih => exact (hstep k).1.trans (congrArg Nat.succ ih)
  refine ⟨fun n => (f n).2, fun n => ?_⟩
  cases n with
  | zero =>
    have eq2 : (f 0).2 = xs0 := congrArg Prod.snd f0
    show R 0 (f 0).2
    rw [eq2]
    exact h0
  | succ k =>
    have hk := (hstep k).2
    have h1 : (f (k + 1)).1 = k + 1 := fstEq (k + 1)
    rw [h1] at hk
    exact hk

end KeepableTransport

private theorem trace_drop {P : Process S A} {stock : S → Nat} {stepDrop : Nat} {s : S}
    (drop : ∀ {u a w}, Reach P s u → P.step u a w → stock u ≤ stock w + stepDrop) :
    ∀ {v : S} {word : List A} {t : S},
      Reach P s v → Trace P v word t → stock v ≤ stock t + stepDrop * word.length
  | v, [], _, _, .nil _ => Nat.le_trans (Nat.le_refl _) (Nat.le_add_right (stock v) 0)
  | _, _ :: word, t, reachV, .cons step tail =>
    have reachM := reachV.trans (Reach.of_step step)
    have ih := trace_drop drop reachM tail
    have hStep := drop reachV step
    Nat.le_trans hStep
      (Nat.le_trans (Nat.add_le_add_right ih stepDrop)
        (Nat.le_of_eq ((Nat.add_assoc (stock t) (stepDrop * word.length) stepDrop).trans
          (congrArg (stock t + ·) (Nat.mul_succ stepDrop word.length).symm))))

/-- **Theorem 2B (`slack_certifies_fine_kernel`).** Under `CoveredByBlocks F expand s`, a per-step
stock drop bound `stepDrop` along reachable fine steps from `s`, and block length bound `L`,
maintaining the buffered guard `thr + stepDrop * (L - 1) ≤ stock v` at block boundaries
certifies `Viability.Kernel F.P (fun v => thr ≤ stock v) s`. -/
theorem slack_certifies_fine_kernel (F : Frame S A C) (expand : B → List A)
    (stock : S → Nat) (thr stepDrop L : Nat) {s : S}
    (covered : CoveredByBlocks F expand s)
    (drop : ∀ {u a w}, Reach F.P s u → F.P.step u a w → stock u ≤ stock w + stepDrop)
    (lenBound : ∀ blk, (expand blk).length ≤ L)
    (blockKernel : Viability.Kernel (F.blocks expand).P
      (fun v => thr + stepDrop * (L - 1) ≤ stock v) s) :
    Viability.Kernel F.P (fun v => thr ≤ stock v) s := by
  intro t reachT
  rcases covered t reachT with ⟨v, reachB, blk, pre, post, eqWord, tracePre⟩
  cases post with
  | nil =>
    have eqPre : expand blk = pre := eqWord.trans (ListTests.append_nil pre)
    have stepB : (F.blocks expand).P.step v blk t :=
      Eq.subst (motive := fun w => Trace F.P v w t) eqPre.symm tracePre
    have reachBt : Reach (F.blocks expand).P s t := reachB.trans (Reach.of_step stepB)
    exact Naturals.le_of_add_le_right (blockKernel t reachBt)
  | cons a rest =>
    have lenEq : (expand blk).length = pre.length + (rest.length + 1) :=
      (congrArg List.length eqWord).trans (ListTests.length_append pre (a :: rest))
    have preSucc : pre.length + 1 ≤ L :=
      Nat.le_trans
        (Nat.le_trans (Nat.add_le_add_left (Nat.succ_le_succ (Nat.zero_le rest.length)) pre.length)
          (Nat.le_of_eq lenEq.symm))
        (lenBound blk)
    have preLe : pre.length ≤ L - 1 := le_pred_of_succ_le preSucc
    have mulLe : stepDrop * pre.length ≤ stepDrop * (L - 1) := Nat.mul_le_mul_left stepDrop preLe
    have hV : thr + stepDrop * (L - 1) ≤ stock v := blockKernel v reachB
    have hDrop := trace_drop drop (blocks_reach_to_fine F expand reachB) tracePre
    have hSum : thr + stepDrop * (L - 1) ≤ stock t + stepDrop * (L - 1) :=
      Nat.le_trans hV (Nat.le_trans hDrop (Nat.add_le_add_left mulLe (stock t)))
    exact le_of_add_le_add_right (stepDrop * (L - 1)) hSum

/-- Global-drop corollary of `slack_certifies_fine_kernel` when the drop bound holds at all states. -/
theorem slack_certifies_fine_kernel_global (F : Frame S A C) (expand : B → List A)
    (stock : S → Nat) (thr stepDrop L : Nat) {s : S}
    (covered : CoveredByBlocks F expand s)
    (drop : ∀ {u a w}, F.P.step u a w → stock u ≤ stock w + stepDrop)
    (lenBound : ∀ blk, (expand blk).length ≤ L)
    (blockKernel : Viability.Kernel (F.blocks expand).P
      (fun v => thr + stepDrop * (L - 1) ≤ stock v) s) :
    Viability.Kernel F.P (fun v => thr ≤ stock v) s :=
  slack_certifies_fine_kernel F expand stock thr stepDrop L covered
    (fun _ h => drop h) lenBound blockKernel

/-- **Theorem 2B (`slack_iff_of_drop_realized`).** The buffered block kernel and fine kernel
are equivalent when every reachable above-threshold block boundary can realize the worst-case
intra-span drop `stepDrop * (L - 1)`. -/
theorem slack_iff_of_drop_realized (F : Frame S A C) (expand : B → List A)
    (stock : S → Nat) (thr stepDrop L : Nat) {s : S}
    (covered : CoveredByBlocks F expand s)
    (drop : ∀ {u a w}, Reach F.P s u → F.P.step u a w → stock u ≤ stock w + stepDrop)
    (lenBound : ∀ blk, (expand blk).length ≤ L)
    (realizesDrop : ∀ v, thr ≤ stock v → Reach (F.blocks expand).P s v →
      ∃ blk pre post, expand blk = pre ++ post ∧
        ∃ m, Trace F.P v pre m ∧ stock m + stepDrop * (L - 1) ≤ stock v) :
    Viability.Kernel (F.blocks expand).P (fun v => thr + stepDrop * (L - 1) ≤ stock v) s ↔
      Viability.Kernel F.P (fun v => thr ≤ stock v) s :=
  ⟨slack_certifies_fine_kernel F expand stock thr stepDrop L covered drop lenBound,
   fun fineKernel v reachB =>
     have reachFv := blocks_reach_to_fine F expand reachB
     match realizesDrop v (fineKernel v reachFv) reachB with
     | ⟨_, _, _, _, m, tracePre, dropM⟩ =>
       have reachFm : Reach F.P s m := reachFv.trans ⟨_, tracePre⟩
       Nat.le_trans (Nat.add_le_add_right (fineKernel m reachFm) (stepDrop * (L - 1))) dropM⟩

end Pillar2

/-! ## Witness: `SlackShortWitness` -/

namespace SlackShortWitness

def need (_ : Bool) : Nat := 1

def use : Bool → Nat
  | true => 4
  | false => 2

def kids (_ : Unit) (b : Bool) : List Bool := [!b]

def giving (z : Nat) : Nat := cond (decide (1 ≤ z)) 3 0

def fineStep : List Bool × Nat → List Bool × Nat :=
  LineOnAStock.step need (kids ()) giving use

def frame : Frame (List Bool × Nat) Unit Unit :=
  ⟨Law.process fineStep, fun _ _ => True⟩

def expand (_ : Unit) : List Unit := [(), ()]

def thr : Nat := 5

theorem step_five_true : fineStep ([true], 5) = ([false], 4) := rfl
theorem step_four_false : fineStep ([false], 4) = ([true], 5) := rfl
theorem step_six_true : fineStep ([true], 6) = ([false], 5) := rfl
theorem step_five_false : fineStep ([false], 5) = ([true], 6) := rfl

private theorem blocks_step_iff {s t : List Bool × Nat} :
    (frame.blocks expand).P.step s () t ↔ t = fineStep (fineStep s) :=
  ⟨fun tr => match trace_cons_iff.mp tr with
    | ⟨m, s1, tail⟩ =>
      have s2 : t = fineStep m := trace_singleton_iff.mp tail
      s2.trans (congrArg fineStep s1),
   fun eq => eq ▸ .cons rfl (.cons rfl (.nil _))⟩

private theorem atFive_block_trace :
    ∀ {word : List Unit} {t : List Bool × Nat},
      Trace (frame.blocks expand).P ([true], 5) word t → t = ([true], 5)
  | [], _, .nil _ => rfl
  | () :: _, _, .cons step tail =>
    have eq1 : _ = ([true], 5) := (blocks_step_iff.mp step).trans rfl
    atFive_block_trace (eq1 ▸ tail)

private theorem atSix_block_trace :
    ∀ {word : List Unit} {t : List Bool × Nat},
      Trace (frame.blocks expand).P ([true], 6) word t → t = ([true], 6)
  | [], _, .nil _ => rfl
  | () :: _, _, .cons step tail =>
    have eq1 : _ = ([true], 6) := (blocks_step_iff.mp step).trans rfl
    atSix_block_trace (eq1 ▸ tail)

private theorem covered_pair_blocks {S : Type} (next : S → S) :
    ∀ (as : List Unit) (s t : S),
      Trace (Law.process next) s as t →
      ∃ v, Reach (Frame.blocks (Frame.mk (C := Unit) (Law.process next) (fun _ _ => True)) expand).P s v ∧
        ∃ b pre post, expand b = pre ++ post ∧ Trace (Law.process next) v pre t
  | [], s, _, tr =>
    ⟨s, Reach.refl _ s, (), [], [(), ()], rfl, tr⟩
  | [()], s, _, tr =>
    ⟨s, Reach.refl _ s, (), [()], [()], rfl, tr⟩
  | () :: () :: rest, s, t, tr =>
    match trace_cons_iff.mp tr with
    | ⟨_, s1, tail1⟩ => match trace_cons_iff.mp tail1 with
      | ⟨m2, s2, tail2⟩ =>
        have stepB : (Frame.blocks (Frame.mk (C := Unit) (Law.process next) (fun _ _ => True)) expand).P.step s () m2 :=
          .cons s1 (.cons s2 (.nil m2))
        match covered_pair_blocks next rest m2 t tail2 with
        | ⟨v, reachV, b, pre, post, eqWord, tracePre⟩ =>
          ⟨v, (Reach.of_step stepB).trans reachV, b, pre, post, eqWord, tracePre⟩

theorem atFive_block_kernel :
    Viability.Kernel (frame.blocks expand).P (fun s => thr ≤ s.2) ([true], 5) :=
  fun _ ⟨_, path⟩ => (atFive_block_trace path).symm ▸ Nat.le_refl 5

theorem atFive_block_keepable :
    Viability.Keepable (frame.blocks expand).P (fun s => thr ≤ s.2) ([true], 5) :=
  ⟨⟨fun _ => ([true], 5), fun _ => (), fun _ => blocks_step_iff.mpr rfl⟩,
   rfl, fun _ => Nat.le_refl 5⟩

theorem atFive_not_fine_kernel :
    ¬ Viability.Kernel frame.P (fun s => thr ≤ s.2) ([true], 5) :=
  fun k => absurd (k ([false], 4) (Reach.of_step (a := ()) step_five_true)) (by decide)

theorem atFive_not_fine_keepable :
    ¬ Viability.Keepable frame.P (fun s => thr ≤ s.2) ([true], 5) :=
  fun ⟨r, r0, held⟩ =>
    have eq1 : r.state 1 = ([false], 4) := (r.step 0).trans (congrArg fineStep r0)
    have h54 : 5 ≤ 4 := Eq.subst (motive := fun s => 5 ≤ s.2) eq1 (held 1)
    absurd h54 (by decide)

private theorem atSix_fine_reach_cases :
    ∀ {as : List Unit} {t : List Bool × Nat},
      Trace frame.P ([true], 6) as t → t = ([true], 6) ∨ t = ([false], 5) := by
  have closed : ∀ u t, u = ([true], 6) ∨ u = ([false], 5) →
      frame.P.step u () t → t = ([true], 6) ∨ t = ([false], 5) := by
    intro u t hu step
    rcases hu with rfl | rfl
    · exact Or.inr (step.trans step_six_true)
    · exact Or.inl (step.trans step_five_false)
  intro as t path
  have inv : ∀ {u t : List Bool × Nat} {ws : List Unit},
      Trace frame.P u ws t → (u = ([true], 6) ∨ u = ([false], 5)) →
      t = ([true], 6) ∨ t = ([false], 5) := by
    intro u t ws tr hu
    induction tr with
    | nil => exact hu
    | cons step _ ih => exact ih (closed _ _ hu step)
  exact inv path (Or.inl rfl)

theorem atSix_fine_kernel_by_slack :
    Viability.Kernel frame.P (fun s => thr ≤ s.2) ([true], 6) :=
  slack_certifies_fine_kernel frame expand Prod.snd thr 1 2
    (fun t ⟨as, path⟩ => covered_pair_blocks fineStep as ([true], 6) t path)
    (fun {u _ w} reachU step =>
      match reachU with
      | ⟨_, tr⟩ =>
        match atSix_fine_reach_cases tr with
        | .inl hu => by
          subst hu
          have hw : w = ([false], 5) := step.trans step_six_true
          rw [hw]
          exact Nat.le_refl 6
        | .inr hu => by
          subst hu
          have hw : w = ([true], 6) := step.trans step_five_false
          rw [hw]
          exact Nat.le_succ_of_le (Nat.le_succ 5))
    (fun _ => Nat.le_refl 2)
    (fun _ ⟨_, path⟩ => (atSix_block_trace path).symm ▸ Nat.le_refl 6)

/-- Combined `SlackShortWitness` summary: at `([true], 5)` both `Kernel` and `Keepable` hold on
`(frame.blocks expand).P` while both fail on `frame.P`; at `([true], 6)` `Kernel` holds on
`frame.P` via `slack_certifies_fine_kernel`. -/
theorem witness_summary :
    Viability.Kernel (frame.blocks expand).P (fun s => thr ≤ s.2) ([true], 5) ∧
      Viability.Keepable (frame.blocks expand).P (fun s => thr ≤ s.2) ([true], 5) ∧
      ¬ Viability.Kernel frame.P (fun s => thr ≤ s.2) ([true], 5) ∧
      ¬ Viability.Keepable frame.P (fun s => thr ≤ s.2) ([true], 5) ∧
      Viability.Kernel frame.P (fun s => thr ≤ s.2) ([true], 6) :=
  ⟨atFive_block_kernel, atFive_block_keepable,
   atFive_not_fine_kernel, atFive_not_fine_keepable,
   atSix_fine_kernel_by_slack⟩

end SlackShortWitness

/-! ## Pillar 3: The Pace–Margin Sandwich -/

section Pillar3

/-- Every step `t < k` along the `LineOnAStock` course under `kids g` draws at most `H`. -/
def UpperDraw {U R : Type} (need use : U → Nat) (kids : R → U → List U)
    (giving : Nat → Nat) (H : Nat) (g : R) (w : List U) (x k : Nat) : Prop :=
  ∀ t, t < k →
    LineOnAStock.taken use (LineOnAStock.course need (kids g) giving use (w, x) t).1 ≤ H

/-- While all needs along the course up to step `t < k` are met, the draw at step `t` is at
least `H₁`. -/
def LowerDrawWhileMet {U R : Type} (H₁ : Nat) (need : U → Nat) (kids : R → U → List U)
    (giving : Nat → Nat) (use : U → Nat) (g : R) (w : List U) (x k : Nat) : Prop :=
  ∀ t, t < k →
    (∀ j, j ≤ t → ∀ u, u ∈ (LineOnAStock.course need (kids g) giving use (w, x) j).1 →
      need u ≤ (LineOnAStock.course need (kids g) giving use (w, x) j).2) →
    H₁ ≤ LineOnAStock.taken use (LineOnAStock.course need (kids g) giving use (w, x) t).1

/-- Lower envelope of `line_envelope`: under `UpperDraw H g w x k` (with NO monotonicity of
`giving` assumed), the stock level at step `j ≤ k` is at least the zero-giving `RegimeMargin`
orbit under draw `H`. -/
theorem line_envelope_lower {U R : Type}
    {need use : U → Nat} {kids : R → U → List U} {giving : Nat → Nat}
    {H : Nat} {g : R} {w : List U} {x k : Nat}
    (upper : UpperDraw need use kids giving H g w x k) :
    ∀ j, j ≤ k →
      Law.orbit (RegimeMargin.step (fun _ => 0) H) x j ≤
        (LineOnAStock.course need (kids g) giving use (w, x) j).2
  | 0, _ => Nat.le_refl x
  | j + 1, le =>
    have jLt : j < k := Nat.lt_of_succ_le le
    have ih := line_envelope_lower upper j (Nat.le_of_lt jLt)
    have hDraw := upper j jLt
    have hSub : Law.orbit (RegimeMargin.step (fun _ => 0) H) x j - H ≤
        (LineOnAStock.course need (kids g) giving use (w, x) j).2 -
          LineOnAStock.taken use (LineOnAStock.course need (kids g) giving use (w, x) j).1 :=
      Nat.le_trans (sub_le_sub_right_nat H ih)
        (sub_le_sub_left_nat _ H _ hDraw)
    Nat.le_trans hSub (Nat.le_add_right _ _)

/-- Upper envelope of `line_envelope`: under `FromNothing giving`, `AtMost giving Y`,
`LowerDrawWhileMet H₁ need g w x k`, and all steps `t < k` met, the stock level at step
`j ≤ k` is bounded above by the constant-`Y` `RegimeMargin` orbit under draw `H₁`. -/
theorem line_envelope_upper {U R : Type}
    {need use : U → Nat} {kids : R → U → List U} {giving : Nat → Nat}
    {Y H₁ : Nat} {g : R} {w : List U} {x k : Nat}
    (_nothing : RegimeMargin.FromNothing giving)
    (most : RegimeMargin.AtMost giving Y)
    (lower : LowerDrawWhileMet H₁ need kids giving use g w x k)
    (met : ∀ t, t < k → ∀ u,
      u ∈ (LineOnAStock.course need (kids g) giving use (w, x) t).1 →
      need u ≤ (LineOnAStock.course need (kids g) giving use (w, x) t).2) :
    ∀ j, j ≤ k →
      (LineOnAStock.course need (kids g) giving use (w, x) j).2 ≤
        Law.orbit (RegimeMargin.step (fun _ => Y) H₁) x j
  | 0, _ => Nat.le_refl x
  | j + 1, le =>
    have jLt : j < k := Nat.lt_of_succ_le le
    have ih := line_envelope_upper _nothing most lower met j (Nat.le_of_lt jLt)
    have hDraw := lower j jLt (fun i ile => met i (Nat.lt_of_le_of_lt ile jLt))
    have hSub :
        (LineOnAStock.course need (kids g) giving use (w, x) j).2 -
          LineOnAStock.taken use (LineOnAStock.course need (kids g) giving use (w, x) j).1 ≤
          Law.orbit (RegimeMargin.step (fun _ => Y) H₁) x j - H₁ :=
      Nat.le_trans (sub_le_sub_left_nat H₁ _ _ hDraw) (sub_le_sub_right_nat H₁ ih)
    Nat.add_le_add hSub
      (most ((LineOnAStock.course need (kids g) giving use (w, x) j).2 -
        LineOnAStock.taken use (LineOnAStock.course need (kids g) giving use (w, x) j).1))

/-- **Line envelope (`line_envelope`)**: combines the lower envelope (with buffer consequence
`b + H * k ≤ x → b ≤ (orbit k).2`) and upper envelope. -/
theorem line_envelope {U R : Type}
    {need use : U → Nat} {kids : R → U → List U} {giving : Nat → Nat}
    {H Y H₁ : Nat} {g : R} {w : List U} {x k : Nat} :
    (UpperDraw need use kids giving H g w x k →
      Law.orbit (RegimeMargin.step (fun _ => 0) H) x k ≤
        (LineOnAStock.course need (kids g) giving use (w, x) k).2 ∧
      ∀ b, b + H * k ≤ x → b ≤ (LineOnAStock.course need (kids g) giving use (w, x) k).2) ∧
    (RegimeMargin.FromNothing giving → RegimeMargin.AtMost giving Y →
      LowerDrawWhileMet H₁ need kids giving use g w x k →
      (∀ t, t < k → ∀ u,
        u ∈ (LineOnAStock.course need (kids g) giving use (w, x) t).1 →
        need u ≤ (LineOnAStock.course need (kids g) giving use (w, x) t).2) →
      (LineOnAStock.course need (kids g) giving use (w, x) k).2 ≤
        Law.orbit (RegimeMargin.step (fun _ => Y) H₁) x k) :=
  ⟨fun upper =>
     ⟨line_envelope_lower upper k (Nat.le_refl k),
      fun _ early =>
        Nat.le_trans (RegimeMargin.not_before (fun _ => 0) early)
          (line_envelope_lower upper k (Nat.le_refl k))⟩,
   fun nothing most lower met =>
     line_envelope_upper nothing most lower met k (Nat.le_refl k)⟩

private theorem pacedCourse_cap_inv {A U R : Type}
    {fA : A → R → A} {need : U → Nat} {kids : R → U → List U}
    {giving : Nat → Nat} {use : U → Nat}
    {h : StockState A U → R → R} {reads : Nat → Bool}
    {hi : Nat} (keeps0 : RegimeMargin.Keeps giving 0 hi)
    (c : StockState A U × R) (high0 : c.1.2.2 ≤ hi) :
    ∀ t, (pacedCourse fA need kids giving use h reads c t).1.2.2 ≤ hi
  | 0 => high0
  | t + 1 =>
    have ih := pacedCourse_cap_inv keeps0 c high0 t
    have succEq := Pace.paced_succ (f := fineStep fA need kids giving use)
      (h := h) (reads := reads) c t
    have stepLevel : (pacedCourse fA need kids giving use h reads c (t + 1)).1.2.2 =
        RegimeMargin.step giving
          (LineOnAStock.taken use (pacedCourse fA need kids giving use h reads c t).1.2.1)
          (pacedCourse fA need kids giving use h reads c t).1.2.2 := by
      dsimp only [pacedCourse]
      rw [succEq]
      cases reads t <;> rfl
    Eq.subst (motive := (· ≤ hi)) stepLevel.symm
      (TurningInTime.kept_within keeps0 _ ih)

private theorem pacedCourse_rule_persists {A U R : Type}
    {fA : A → R → A} {need : U → Nat} {kids : R → U → List U}
    {giving : Nat → Nat} {use : U → Nat}
    {h : StockState A U → R → R} {reads : Nat → Bool}
    {c : StockState A U × R} {g_safe : R}
    (persists : ∀ s, h s g_safe = g_safe) {t0 : Nat}
    (atT0 : (pacedCourse fA need kids giving use h reads c t0).2 = g_safe) :
    ∀ m, (pacedCourse fA need kids giving use h reads c (t0 + m)).2 = g_safe
  | 0 => atT0
  | m + 1 => by
    have ih := pacedCourse_rule_persists persists atT0 m
    have succEq := Pace.paced_succ (f := fineStep fA need kids giving use)
      (h := h) (reads := reads) c (t0 + m)
    show (pacedCourse fA need kids giving use h reads c (t0 + m + 1)).2 = g_safe
    dsimp only [pacedCourse]
    rw [succEq]
    cases reads (t0 + m) with
    | false => exact ih
    | true =>
      show h (pacedCourse fA need kids giving use h reads c (t0 + m)).1
        (pacedCourse fA need kids giving use h reads c (t0 + m)).2 = g_safe
      rw [ih]
      exact persists _

private theorem safe_step_maintains_bounds {giving : Nat → Nat} {H₂ y₂ hi D x : Nat}
    (keeps0 : RegimeMargin.Keeps giving 0 hi)
    (meets2 : RegimeMargin.Meets giving H₂ y₂ hi)
    (room : H₂ + H₂ + y₂ ≤ hi)
    (dLe : D ≤ H₂) (low : H₂ + y₂ ≤ x) (high : x ≤ hi) :
    H₂ + y₂ ≤ RegimeMargin.step giving D x ∧ RegimeMargin.step giving D x ≤ hi := by
  refine ⟨?_, TurningInTime.kept_within keeps0 D high⟩
  rcases Nat.lt_or_ge hi ((x - D) + H₂) with over | within
  · have hRoom : H₂ + y₂ + H₂ ≤ (x - D) + H₂ :=
      Nat.le_trans
        (Nat.le_of_eq ((Nat.add_assoc H₂ y₂ H₂).trans
          ((congrArg (H₂ + ·) (Nat.add_comm y₂ H₂)).trans (Nat.add_assoc H₂ H₂ y₂).symm)))
        (Nat.le_trans room (Nat.le_of_lt over))
    exact Nat.le_trans (le_of_add_le_add_right H₂ hRoom) (Nat.le_add_right (x - D) _)
  · have hH2 : H₂ ≤ x := Nat.le_trans (Nat.le_add_right H₂ y₂) low
    have yLe : y₂ ≤ x - D :=
      Nat.le_trans
        (Naturals.le_of_add_le_add_left (k := H₂)
          (Nat.le_trans low (Nat.le_of_eq (Naturals.add_sub_of_le hH2).symm)))
        (sub_le_sub_left_nat D H₂ x dLe)
    have hGive : H₂ ≤ giving (x - D) := meets2 (x - D) yLe within
    have hDLeX : D ≤ x := Nat.le_trans dLe hH2
    calc H₂ + y₂ ≤ x := low
      _ = (x - D) + D := (Naturals.sub_add_cancel hDLeX).symm
      _ ≤ (x - D) + H₂ := Nat.add_le_add_left dLe (x - D)
      _ ≤ (x - D) + giving (x - D) := Nat.add_le_add_left hGive (x - D)

private theorem safe_step_maintains_bounds_exact {giving : Nat → Nat} {H₂ y₂ hi x : Nat}
    (meets2 : RegimeMargin.Meets giving H₂ y₂ hi)
    (keeps2 : RegimeMargin.Keeps giving H₂ hi)
    (low : H₂ + y₂ ≤ x) (high : x ≤ hi) :
    H₂ + y₂ ≤ RegimeMargin.step giving H₂ x ∧ RegimeMargin.step giving H₂ x ≤ hi :=
  have h1 := RegimeMargin.holds meets2 keeps2 low high 1
  ⟨Nat.le_trans low h1.1, h1.2⟩

private theorem course_prefix_all_met {U R : Type}
    {need use : U → Nat} {kids : R → U → List U} {giving : Nat → Nat}
    {H₁ H₂ y₂ L : Nat} {g : R} {w₀ : List U} {x₀ : Nat}
    (upper : UpperDraw need use kids giving H₁ g w₀ x₀ (L + 1))
    (budget : H₂ + y₂ + H₁ * (L + 1) ≤ x₀)
    (needsPos : ∀ u, 0 < need u ∧ need u ≤ H₂ + y₂) :
    ∀ t, t ≤ L →
      H₂ + y₂ ≤ (LineOnAStock.course need (kids g) giving use (w₀, x₀) t).2 ∧
      ∀ u, u ∈ (LineOnAStock.course need (kids g) giving use (w₀, x₀) t).1 →
        need u ≤ (LineOnAStock.course need (kids g) giving use (w₀, x₀) t).2 := by
  intro t tLe
  have hMul : H₁ * t ≤ H₁ * (L + 1) := Nat.mul_le_mul_left H₁ (Nat.le_succ_of_le tLe)
  have hEarly : H₂ + y₂ + H₁ * t ≤ x₀ := Nat.le_trans (Nat.add_le_add_left hMul (H₂ + y₂)) budget
  have hLvl : H₂ + y₂ ≤ (LineOnAStock.course need (kids g) giving use (w₀, x₀) t).2 :=
    Nat.le_trans (RegimeMargin.not_before (fun _ => 0) hEarly)
      (line_envelope_lower upper t (Nat.le_succ_of_le tLe))
  exact ⟨hLvl, fun u _ => Nat.le_trans (needsPos u).2 hLvl⟩

/-- **Theorem 3A (`pace_margin_feasibility_window`).** When the reading cadence satisfies
`2 * N - 1 ≤ L` (`Pace.StretchFixes O N L`), the initial level carries the lag-buffered margin
`H₂ + y₂ + H₁ * (L + 1) ≤ x₀ ≤ hi` with `H₂ + H₂ + y₂ ≤ hi`, the rule switches to `g_safe` at
`σ 1 = L` and persists, and the safe phase keeps `taken ≤ H₂` closed under `allKids (kids g_safe)`,
every fine step `t ≥ L + 1` stays in `[H₂ + y₂, hi]` and `LineOnAStock.Goes need (w_t, x_t)`. -/
theorem pace_margin_feasibility_window {A U R O : Type}
    {fA : A → R → A} {need : U → Nat} {kids : R → U → List U}
    {giving : Nat → Nat} {use : U → Nat}
    {h : StockState A U → R → R} {reads : Nat → Bool} {σ : Nat → Nat}
    {N L H₁ H₂ y₂ hi : Nat} {x_o y_o : O} (two : x_o ≠ y_o)
    (σ0 : σ 0 = 0) (σ1 : σ 1 = L)
    (strict : Becoming.Strict σ) (cadence : ReadAtSpanEnd σ reads)
    (paceOK : 2 * N - 1 ≤ L)
    {a₀ : A} {w₀ : List U} {x₀ : Nat} {g_bad g_safe : R}
    (high0 : x₀ ≤ hi)
    (keeps0 : RegimeMargin.Keeps giving 0 hi)
    (_short2 : RegimeMargin.Short giving H₂ y₂)
    (meets2 : RegimeMargin.Meets giving H₂ y₂ hi)
    (_keeps2 : RegimeMargin.Keeps giving H₂ hi)
    (room : H₂ + H₂ + y₂ ≤ hi)
    (needsPos : ∀ u, 0 < need u ∧ need u ≤ H₂ + y₂)
    (ne0 : w₀ ≠ [])
    (hasKids : ∀ g u, kids g u ≠ [])
    (safeEntry : LineOnAStock.taken use
      (LineOnAStock.allKids (kids g_safe) (LineOnAStock.generation (kids g_bad) L w₀)) ≤ H₂)
    (safeClose : ∀ w, LineOnAStock.taken use w ≤ H₂ →
      LineOnAStock.taken use (LineOnAStock.allKids (kids g_safe) w) ≤ H₂)
    (upperBad : UpperDraw need use kids giving H₁ g_bad w₀ x₀ (L + 1))
    (budget : H₂ + y₂ + H₁ * (L + 1) ≤ x₀)
    (switches : (pacedCourse fA need kids giving use h reads ((a₀, (w₀, x₀)), g_bad) (σ 1)).2 =
      g_safe)
    (persists : ∀ s, h s g_safe = g_safe) :
    Pace.StretchFixes O N L ∧
      ∀ t, L + 1 ≤ t →
        H₂ + y₂ ≤ (pacedCourse fA need kids giving use h reads ((a₀, (w₀, x₀)), g_bad) t).1.2.2 ∧
        (pacedCourse fA need kids giving use h reads ((a₀, (w₀, x₀)), g_bad) t).1.2.2 ≤ hi ∧
        LineOnAStock.Goes need
          (pacedCourse fA need kids giving use h reads ((a₀, (w₀, x₀)), g_bad) t).1.2 := by
  let c : StockState A U × R := ((a₀, (w₀, x₀)), g_bad)
  have stretchFixes : Pace.StretchFixes O N L :=
    (Pace.pace_law two N L).mpr ((two_mul_pred_eq N).symm ▸ paceOK)
  have trans0 := paced_block_transition (fA := fA) (need := need) (kids := kids)
    (giving := giving) (use := use) (h := h) strict cadence c 0
  have at0 : (pacedCourse fA need kids giving use h reads c (σ 0)).2 = g_bad := by
    rw [σ0]; rfl
  have at0st : (pacedCourse fA need kids giving use h reads c (σ 0)).1 = (a₀, (w₀, x₀)) := by
    rw [σ0]; rfl
  have atL_stock : (pacedCourse fA need kids giving use h reads c L).1.2 =
      LineOnAStock.course need (kids g_bad) giving use (w₀, x₀) L := by
    have h1 := trans0.1
    rw [at0, at0st, σ1, σ0, Nat.sub_zero] at h1
    change (pacedCourse fA need kids giving use h reads c L).1.2 = _
    rw [h1]
    exact fineStep_orbit_snd (a₀, (w₀, x₀)) g_bad L
  have badMet : ∀ t, t ≤ L →
      H₂ + y₂ ≤ (LineOnAStock.course need (kids g_bad) giving use (w₀, x₀) t).2 ∧
      ∀ u, u ∈ (LineOnAStock.course need (kids g_bad) giving use (w₀, x₀) t).1 →
        need u ≤ (LineOnAStock.course need (kids g_bad) giving use (w₀, x₀) t).2 :=
    course_prefix_all_met upperBad budget needsPos
  have wL_eq : (pacedCourse fA need kids giving use h reads c L).1.2.1 =
      LineOnAStock.generation (kids g_bad) L w₀ :=
    (congrArg Prod.fst atL_stock).trans
      (LineOnAStock.way_while_met fun j lt => (badMet j (Nat.le_of_lt lt)).2)
  have wL_ne : (pacedCourse fA need kids giving use h reads c L).1.2.1 ≠ [] := by
    rw [wL_eq]
    rcases LineOnAStock.mem_of_ne_nil ne0 with ⟨v0, mv0⟩
    rcases LineOnAStock.generation_mem (hasKids g_bad) mv0 L with ⟨u, mu⟩
    exact fun e => nomatch (e ▸ mu)
  have xL_low : H₂ + y₂ ≤ (pacedCourse fA need kids giving use h reads c L).1.2.2 := by
    rw [atL_stock]
    exact (badMet L (Nat.le_refl L)).1
  have atL_rule : (pacedCourse fA need kids giving use h reads c L).2 = g_safe :=
    σ1 ▸ switches
  have succL : pacedCourse fA need kids giving use h reads c (L + 1) =
      Pace.turn (fineStep fA need kids giving use) h (reads L)
        (pacedCourse fA need kids giving use h reads c L) :=
    Pace.paced_succ c L
  have stepL_stock : (pacedCourse fA need kids giving use h reads c (L + 1)).1.2 =
      LineOnAStock.step need (kids g_safe) giving use
        (pacedCourse fA need kids giving use h reads c L).1.2 := by
    rw [succL]
    cases reads L with
    | false => show (fineStep fA need kids giving use _ _).2 = _; rw [atL_rule]; rfl
    | true => show (fineStep fA need kids giving use _ _).2 = _; rw [atL_rule]; rfl
  have xL1_eq : (pacedCourse fA need kids giving use h reads c (L + 1)).1.2.2 =
      (LineOnAStock.course need (kids g_bad) giving use (w₀, x₀) (L + 1)).2 := by
    rw [stepL_stock, atL_stock]
    rfl
  have xL1_low : H₂ + y₂ ≤ (pacedCourse fA need kids giving use h reads c (L + 1)).1.2.2 := by
    rw [xL1_eq]
    exact Nat.le_trans (RegimeMargin.not_before (fun _ => 0) budget)
      (line_envelope_lower upperBad (L + 1) (Nat.le_refl (L + 1)))
  have wL1_eq : (pacedCourse fA need kids giving use h reads c (L + 1)).1.2.1 =
      LineOnAStock.allKids (kids g_safe) (LineOnAStock.generation (kids g_bad) L w₀) := by
    rw [stepL_stock]
    show LineOnAStock.after need (kids g_safe)
      (pacedCourse fA need kids giving use h reads c L).1.2.1
      (pacedCourse fA need kids giving use h reads c L).1.2.2 = _
    rw [LineOnAStock.after_of_met (fun u mu => Nat.le_trans (needsPos u).2 xL_low), wL_eq]
  have wL1_ne : (pacedCourse fA need kids giving use h reads c (L + 1)).1.2.1 ≠ [] := by
    rcases LineOnAStock.mem_of_ne_nil wL_ne with ⟨u, mu⟩
    rcases LineOnAStock.mem_of_ne_nil (hasKids g_safe u) with ⟨k, mk⟩
    rw [wL1_eq, ← wL_eq]
    have memAll : k ∈ LineOnAStock.allKids (kids g_safe)
        (pacedCourse fA need kids giving use h reads c L).1.2.1 :=
      LineOnAStock.mem_allKids_iff.mpr ⟨u, mu, mk⟩
    exact fun e => nomatch (e ▸ memAll)
  have wL1_draw : LineOnAStock.taken use
      (pacedCourse fA need kids giving use h reads c (L + 1)).1.2.1 ≤ H₂ := by
    rw [wL1_eq]
    exact safeEntry
  have invSafe : ∀ m,
      (pacedCourse fA need kids giving use h reads c (L + 1 + m)).2 = g_safe ∧
      H₂ + y₂ ≤ (pacedCourse fA need kids giving use h reads c (L + 1 + m)).1.2.2 ∧
      (pacedCourse fA need kids giving use h reads c (L + 1 + m)).1.2.2 ≤ hi ∧
      (pacedCourse fA need kids giving use h reads c (L + 1 + m)).1.2.1 ≠ [] ∧
      LineOnAStock.taken use
        (pacedCourse fA need kids giving use h reads c (L + 1 + m)).1.2.1 ≤ H₂ := by
    intro m
    induction m with
    | zero =>
      exact ⟨pacedCourse_rule_persists persists atL_rule 1,
             xL1_low,
             pacedCourse_cap_inv keeps0 c high0 (L + 1),
             wL1_ne,
             wL1_draw⟩
    | succ m ih =>
      rcases ih with ⟨rEq, xLow, xHigh, wNe, wDraw⟩
      have ruleNext : (pacedCourse fA need kids giving use h reads c (L + 1 + (m + 1))).2 =
          g_safe :=
        Eq.subst (motive := fun n => (pacedCourse fA need kids giving use h reads c n).2 = g_safe)
          (Nat.add_assoc L 1 (m + 1)).symm
          (pacedCourse_rule_persists persists atL_rule (1 + (m + 1)))
      have succM := Pace.paced_succ (f := fineStep fA need kids giving use)
        (h := h) (reads := reads) c (L + 1 + m)
      have stepM : (pacedCourse fA need kids giving use h reads c (L + 1 + (m + 1))).1.2 =
          LineOnAStock.step need (kids g_safe) giving use
            (pacedCourse fA need kids giving use h reads c (L + 1 + m)).1.2 := by
        show (pacedCourse fA need kids giving use h reads c (L + 1 + m + 1)).1.2 = _
        dsimp only [pacedCourse]
        rw [succM]
        cases reads (L + 1 + m) <;>
          (show (fineStep fA need kids giving use _ _).2 = _; rw [rEq]; rfl)
      have bounds := safe_step_maintains_bounds keeps0 meets2 room wDraw xLow xHigh
      have wNextEq : (pacedCourse fA need kids giving use h reads c (L + 1 + (m + 1))).1.2.1 =
          LineOnAStock.allKids (kids g_safe)
            (pacedCourse fA need kids giving use h reads c (L + 1 + m)).1.2.1 := by
        rw [stepM]
        exact LineOnAStock.after_of_met (fun u _ => Nat.le_trans (needsPos u).2 xLow)
      have wNextNe : (pacedCourse fA need kids giving use h reads c (L + 1 + (m + 1))).1.2.1 ≠ [] := by
        rcases LineOnAStock.mem_of_ne_nil wNe with ⟨u, mu⟩
        rcases LineOnAStock.mem_of_ne_nil (hasKids g_safe u) with ⟨k, mk⟩
        rw [wNextEq]
        have mkAll := LineOnAStock.mem_allKids_iff.mpr ⟨u, mu, mk⟩
        exact fun e => nomatch (e ▸ mkAll)
      have wNextDraw : LineOnAStock.taken use
          (pacedCourse fA need kids giving use h reads c (L + 1 + (m + 1))).1.2.1 ≤ H₂ := by
        rw [wNextEq]
        exact safeClose _ wDraw
      have xNextLow : H₂ + y₂ ≤
          (pacedCourse fA need kids giving use h reads c (L + 1 + (m + 1))).1.2.2 := by
        rw [stepM]
        exact bounds.1
      have xNextHigh :
          (pacedCourse fA need kids giving use h reads c (L + 1 + (m + 1))).1.2.2 ≤ hi := by
        rw [stepM]
        exact bounds.2
      exact ⟨ruleNext, xNextLow, xNextHigh, wNextNe, wNextDraw⟩
  refine ⟨stretchFixes, fun t tGe => ?_⟩
  rcases le_dest tGe with ⟨m, ht⟩
  rw [ht]
  rcases invSafe m with ⟨_, xLow, xHigh, wNe, _⟩
  rcases LineOnAStock.mem_of_ne_nil wNe with ⟨u, mu⟩
  exact ⟨xLow, xHigh, ⟨u, mu, Nat.le_trans (needsPos u).2 xLow⟩⟩

/-- Exact-draw variant of `pace_margin_feasibility_window` (without `H₂ + H₂ + y₂ ≤ hi`):
when the safe phase maintains exact draw `taken = H₂`, `RegimeMargin.Meets giving H₂ y₂ hi` and
`RegimeMargin.Keeps giving H₂ hi` directly preserve `[H₂ + y₂, hi]`. -/
theorem pace_margin_feasibility_window_exact {A U R O : Type}
    {fA : A → R → A} {need : U → Nat} {kids : R → U → List U}
    {giving : Nat → Nat} {use : U → Nat}
    {h : StockState A U → R → R} {reads : Nat → Bool} {σ : Nat → Nat}
    {N L H₁ H₂ y₂ hi : Nat} {x_o y_o : O} (two : x_o ≠ y_o)
    (σ0 : σ 0 = 0) (σ1 : σ 1 = L)
    (strict : Becoming.Strict σ) (cadence : ReadAtSpanEnd σ reads)
    (paceOK : 2 * N - 1 ≤ L)
    {a₀ : A} {w₀ : List U} {x₀ : Nat} {g_bad g_safe : R}
    (high0 : x₀ ≤ hi)
    (keeps0 : RegimeMargin.Keeps giving 0 hi)
    (_short2 : RegimeMargin.Short giving H₂ y₂)
    (meets2 : RegimeMargin.Meets giving H₂ y₂ hi)
    (keeps2 : RegimeMargin.Keeps giving H₂ hi)
    (needsPos : ∀ u, 0 < need u ∧ need u ≤ H₂ + y₂)
    (ne0 : w₀ ≠ [])
    (hasKids : ∀ g u, kids g u ≠ [])
    (safeEntry : LineOnAStock.taken use
      (LineOnAStock.allKids (kids g_safe) (LineOnAStock.generation (kids g_bad) L w₀)) = H₂)
    (safeClose : ∀ w, LineOnAStock.taken use w = H₂ →
      LineOnAStock.taken use (LineOnAStock.allKids (kids g_safe) w) = H₂)
    (upperBad : UpperDraw need use kids giving H₁ g_bad w₀ x₀ (L + 1))
    (budget : H₂ + y₂ + H₁ * (L + 1) ≤ x₀)
    (switches : (pacedCourse fA need kids giving use h reads ((a₀, (w₀, x₀)), g_bad) (σ 1)).2 =
      g_safe)
    (persists : ∀ s, h s g_safe = g_safe) :
    Pace.StretchFixes O N L ∧
      ∀ t, L + 1 ≤ t →
        H₂ + y₂ ≤ (pacedCourse fA need kids giving use h reads ((a₀, (w₀, x₀)), g_bad) t).1.2.2 ∧
        (pacedCourse fA need kids giving use h reads ((a₀, (w₀, x₀)), g_bad) t).1.2.2 ≤ hi ∧
        LineOnAStock.Goes need
          (pacedCourse fA need kids giving use h reads ((a₀, (w₀, x₀)), g_bad) t).1.2 := by
  let c : StockState A U × R := ((a₀, (w₀, x₀)), g_bad)
  have stretchFixes : Pace.StretchFixes O N L :=
    (Pace.pace_law two N L).mpr ((two_mul_pred_eq N).symm ▸ paceOK)
  have trans0 := paced_block_transition (fA := fA) (need := need) (kids := kids)
    (giving := giving) (use := use) (h := h) strict cadence c 0
  have at0 : (pacedCourse fA need kids giving use h reads c (σ 0)).2 = g_bad := by
    rw [σ0]; rfl
  have at0st : (pacedCourse fA need kids giving use h reads c (σ 0)).1 = (a₀, (w₀, x₀)) := by
    rw [σ0]; rfl
  have atL_stock : (pacedCourse fA need kids giving use h reads c L).1.2 =
      LineOnAStock.course need (kids g_bad) giving use (w₀, x₀) L := by
    have h1 := trans0.1
    rw [at0, at0st, σ1, σ0, Nat.sub_zero] at h1
    change (pacedCourse fA need kids giving use h reads c L).1.2 = _
    rw [h1]
    exact fineStep_orbit_snd (a₀, (w₀, x₀)) g_bad L
  have badMet := course_prefix_all_met upperBad budget needsPos
  have wL_eq : (pacedCourse fA need kids giving use h reads c L).1.2.1 =
      LineOnAStock.generation (kids g_bad) L w₀ :=
    (congrArg Prod.fst atL_stock).trans
      (LineOnAStock.way_while_met fun j lt => (badMet j (Nat.le_of_lt lt)).2)
  have wL_ne : (pacedCourse fA need kids giving use h reads c L).1.2.1 ≠ [] := by
    rw [wL_eq]
    rcases LineOnAStock.mem_of_ne_nil ne0 with ⟨v0, mv0⟩
    rcases LineOnAStock.generation_mem (hasKids g_bad) mv0 L with ⟨u, mu⟩
    exact fun e => nomatch (e ▸ mu)
  have xL_low : H₂ + y₂ ≤ (pacedCourse fA need kids giving use h reads c L).1.2.2 := by
    rw [atL_stock]
    exact (badMet L (Nat.le_refl L)).1
  have atL_rule : (pacedCourse fA need kids giving use h reads c L).2 = g_safe :=
    σ1 ▸ switches
  have succL := Pace.paced_succ (f := fineStep fA need kids giving use) (h := h) (reads := reads) c L
  have stepL_stock : (pacedCourse fA need kids giving use h reads c (L + 1)).1.2 =
      LineOnAStock.step need (kids g_safe) giving use
        (pacedCourse fA need kids giving use h reads c L).1.2 := by
    dsimp only [pacedCourse]
    rw [succL]
    cases reads L <;> (show (fineStep fA need kids giving use _ _).2 = _; rw [atL_rule]; rfl)
  have xL1_low : H₂ + y₂ ≤ (pacedCourse fA need kids giving use h reads c (L + 1)).1.2.2 := by
    have xL1_eq : (pacedCourse fA need kids giving use h reads c (L + 1)).1.2.2 =
        (LineOnAStock.course need (kids g_bad) giving use (w₀, x₀) (L + 1)).2 := by
      rw [stepL_stock, atL_stock]; rfl
    rw [xL1_eq]
    exact Nat.le_trans (RegimeMargin.not_before (fun _ => 0) budget)
      (line_envelope_lower upperBad (L + 1) (Nat.le_refl (L + 1)))
  have wL1_eq : (pacedCourse fA need kids giving use h reads c (L + 1)).1.2.1 =
      LineOnAStock.allKids (kids g_safe) (LineOnAStock.generation (kids g_bad) L w₀) := by
    rw [stepL_stock]
    show LineOnAStock.after need (kids g_safe)
      (pacedCourse fA need kids giving use h reads c L).1.2.1
      (pacedCourse fA need kids giving use h reads c L).1.2.2 = _
    rw [LineOnAStock.after_of_met (fun u mu => Nat.le_trans (needsPos u).2 xL_low), wL_eq]
  have wL1_ne : (pacedCourse fA need kids giving use h reads c (L + 1)).1.2.1 ≠ [] := by
    rcases LineOnAStock.mem_of_ne_nil wL_ne with ⟨u, mu⟩
    rcases LineOnAStock.mem_of_ne_nil (hasKids g_safe u) with ⟨k, mk⟩
    rw [wL1_eq, ← wL_eq]
    have memAll := LineOnAStock.mem_allKids_iff.mpr ⟨u, mu, mk⟩
    exact fun e => nomatch (e ▸ memAll)
  have wL1_draw : LineOnAStock.taken use
      (pacedCourse fA need kids giving use h reads c (L + 1)).1.2.1 = H₂ := by
    rw [wL1_eq]
    exact safeEntry
  have invSafe : ∀ m,
      (pacedCourse fA need kids giving use h reads c (L + 1 + m)).2 = g_safe ∧
      H₂ + y₂ ≤ (pacedCourse fA need kids giving use h reads c (L + 1 + m)).1.2.2 ∧
      (pacedCourse fA need kids giving use h reads c (L + 1 + m)).1.2.2 ≤ hi ∧
      (pacedCourse fA need kids giving use h reads c (L + 1 + m)).1.2.1 ≠ [] ∧
      LineOnAStock.taken use
        (pacedCourse fA need kids giving use h reads c (L + 1 + m)).1.2.1 = H₂ := by
    intro m
    induction m with
    | zero =>
      exact ⟨pacedCourse_rule_persists persists atL_rule 1,
             xL1_low,
             pacedCourse_cap_inv keeps0 c high0 (L + 1),
             wL1_ne,
             wL1_draw⟩
    | succ m ih =>
      rcases ih with ⟨rEq, xLow, xHigh, wNe, wDraw⟩
      have ruleNext : (pacedCourse fA need kids giving use h reads c (L + 1 + (m + 1))).2 =
          g_safe :=
        Eq.subst (motive := fun n => (pacedCourse fA need kids giving use h reads c n).2 = g_safe)
          (Nat.add_assoc L 1 (m + 1)).symm
          (pacedCourse_rule_persists persists atL_rule (1 + (m + 1)))
      have succM := Pace.paced_succ (f := fineStep fA need kids giving use)
        (h := h) (reads := reads) c (L + 1 + m)
      have stepM : (pacedCourse fA need kids giving use h reads c (L + 1 + (m + 1))).1.2 =
          LineOnAStock.step need (kids g_safe) giving use
            (pacedCourse fA need kids giving use h reads c (L + 1 + m)).1.2 := by
        show (pacedCourse fA need kids giving use h reads c (L + 1 + m + 1)).1.2 = _
        dsimp only [pacedCourse]
        rw [succM]
        cases reads (L + 1 + m) <;>
          (show (fineStep fA need kids giving use _ _).2 = _; rw [rEq]; rfl)
      have xStepEq : (LineOnAStock.step need (kids g_safe) giving use
          (pacedCourse fA need kids giving use h reads c (L + 1 + m)).1.2).2 =
          RegimeMargin.step giving H₂
            (pacedCourse fA need kids giving use h reads c (L + 1 + m)).1.2.2 := by
        show RegimeMargin.step giving (LineOnAStock.taken use _) _ = _
        rw [wDraw]
      have bounds := safe_step_maintains_bounds_exact meets2 keeps2 xLow xHigh
      have wNextEq : (pacedCourse fA need kids giving use h reads c (L + 1 + (m + 1))).1.2.1 =
          LineOnAStock.allKids (kids g_safe)
            (pacedCourse fA need kids giving use h reads c (L + 1 + m)).1.2.1 := by
        rw [stepM]
        exact LineOnAStock.after_of_met (fun u _ => Nat.le_trans (needsPos u).2 xLow)
      have wNextNe : (pacedCourse fA need kids giving use h reads c (L + 1 + (m + 1))).1.2.1 ≠ [] := by
        rcases LineOnAStock.mem_of_ne_nil wNe with ⟨u, mu⟩
        rcases LineOnAStock.mem_of_ne_nil (hasKids g_safe u) with ⟨k, mk⟩
        rw [wNextEq]
        have mkAll := LineOnAStock.mem_allKids_iff.mpr ⟨u, mu, mk⟩
        exact fun e => nomatch (e ▸ mkAll)
      have wNextDraw : LineOnAStock.taken use
          (pacedCourse fA need kids giving use h reads c (L + 1 + (m + 1))).1.2.1 = H₂ := by
        rw [wNextEq]
        exact safeClose _ wDraw
      exact ⟨ruleNext, by rw [stepM, xStepEq]; exact bounds.1,
             by rw [stepM, xStepEq]; exact bounds.2, wNextNe, wNextDraw⟩
  refine ⟨stretchFixes, fun t tGe => ?_⟩
  rcases le_dest tGe with ⟨m, ht⟩
  rw [ht]
  rcases invSafe m with ⟨_, xLow, xHigh, wNe, _⟩
  rcases LineOnAStock.mem_of_ne_nil wNe with ⟨u, mu⟩
  exact ⟨xLow, xHigh, ⟨u, mu, Nat.le_trans (needsPos u).2 xLow⟩⟩

private theorem not_goes_of_zero {U : Type} {need : U → Nat}
    (needsPos : ∀ u, 0 < need u) (w : List U) :
    ¬ LineOnAStock.Goes need (w, 0) :=
  fun ⟨u, _, le⟩ => Nat.not_le_of_gt (needsPos u) le

private theorem pacedCourse_ends_step {A U R : Type}
    {fA : A → R → A} {need : U → Nat} {kids : R → U → List U}
    {giving : Nat → Nat} {use : U → Nat}
    {h : StockState A U → R → R} {reads : Nat → Bool}
    {H₂ y₂ : Nat}
    (nothing : RegimeMargin.FromNothing giving)
    (short2 : RegimeMargin.Short giving H₂ y₂)
    (needsPos : ∀ u, 0 < need u)
    (floorDraw : ∀ w, w ≠ [] → H₂ ≤ LineOnAStock.taken use w)
    (c : StockState A U × R) (t : Nat)
    (under : (pacedCourse fA need kids giving use h reads c t).1.2.2 < H₂ + y₂) :
    (∃ n, ¬ LineOnAStock.Goes need (pacedCourse fA need kids giving use h reads c n).1.2) ∨
      ((pacedCourse fA need kids giving use h reads c (t + 1)).1.2.2 <
        (pacedCourse fA need kids giving use h reads c t).1.2.2 ∧
      (pacedCourse fA need kids giving use h reads c (t + 1)).1.2.2 < H₂ + y₂) :=
  match LineOnAStock.goesDecidable need (pacedCourse fA need kids giving use h reads c t).1.2 with
  | .isFalse noGoes => Or.inl ⟨t, noGoes⟩
  | .isTrue ⟨_, mu, _⟩ =>
    have wNe : (pacedCourse fA need kids giving use h reads c t).1.2.1 ≠ [] :=
      fun e => nomatch (e ▸ mu)
    have dGe : H₂ ≤ LineOnAStock.taken use
        (pacedCourse fA need kids giving use h reads c t).1.2.1 :=
      floorDraw _ wNe
    have succT := Pace.paced_succ (f := fineStep fA need kids giving use)
      (h := h) (reads := reads) c t
    have xNextEq : (pacedCourse fA need kids giving use h reads c (t + 1)).1.2.2 =
        RegimeMargin.step giving
          (LineOnAStock.taken use (pacedCourse fA need kids giving use h reads c t).1.2.1)
          (pacedCourse fA need kids giving use h reads c t).1.2.2 := by
      dsimp only [pacedCourse]
      rw [succT]
      cases reads t <;> rfl
    match LineOnAStock.step_lowers short2 nothing dGe under with
    | .inl zero =>
      Or.inl ⟨t + 1, fun ⟨v, _, le⟩ =>
        absurd (Nat.le_trans le (Nat.le_of_eq (xNextEq.trans zero)))
          (Nat.not_le_of_gt (needsPos v))⟩
    | .inr lower =>
      have ltNext : (pacedCourse fA need kids giving use h reads c (t + 1)).1.2.2 <
          (pacedCourse fA need kids giving use h reads c t).1.2.2 :=
        Eq.subst (motive := (· < _)) xNextEq.symm lower
      Or.inr ⟨ltNext, Nat.lt_trans ltNext under⟩

private theorem pacedCourse_ends_below_point {A U R : Type}
    {fA : A → R → A} {need : U → Nat} {kids : R → U → List U}
    {giving : Nat → Nat} {use : U → Nat}
    {h : StockState A U → R → R} {reads : Nat → Bool}
    {H₂ y₂ : Nat}
    (nothing : RegimeMargin.FromNothing giving)
    (short2 : RegimeMargin.Short giving H₂ y₂)
    (needsPos : ∀ u, 0 < need u)
    (floorDraw : ∀ w, w ≠ [] → H₂ ≤ LineOnAStock.taken use w)
    (c : StockState A U × R) :
    ∀ f t,
      (pacedCourse fA need kids giving use h reads c t).1.2.2 ≤ f →
      (pacedCourse fA need kids giving use h reads c t).1.2.2 < H₂ + y₂ →
      ∃ n, ¬ LineOnAStock.Goes need
        (pacedCourse fA need kids giving use h reads c n).1.2
  | 0, t, bound, under =>
    match pacedCourse_ends_step nothing short2 needsPos floorDraw c t under with
    | .inl found => found
    | .inr ⟨lower, _⟩ => absurd (Nat.lt_of_lt_of_le lower bound) (Nat.not_lt_zero _)
  | f + 1, t, bound, under =>
    match pacedCourse_ends_step nothing short2 needsPos floorDraw c t under with
    | .inl found => found
    | .inr ⟨lower, underNext⟩ =>
      pacedCourse_ends_below_point nothing short2 needsPos floorDraw c f (t + 1)
        (Nat.le_of_lt_succ (Nat.lt_of_lt_of_le lower bound)) underNext

private theorem course_bad_stays_below_aux {U : Type}
    {need use : U → Nat} {kids : U → List U} {giving : Nat → Nat}
    {H₂ y₂ : Nat}
    (nothing : RegimeMargin.FromNothing giving)
    (short2 : RegimeMargin.Short giving H₂ y₂)
    (floorDraw : ∀ w, w ≠ [] → H₂ ≤ LineOnAStock.taken use w)
    {w₀ : List U} {x₀ L : Nat}
    (allGoes : ∀ t, t < L →
      LineOnAStock.Goes need (LineOnAStock.course need kids giving use (w₀, x₀) t)) :
    ∀ d k, k + d ≤ L →
      (LineOnAStock.course need kids giving use (w₀, x₀) k).2 < H₂ + y₂ →
      (LineOnAStock.course need kids giving use (w₀, x₀) (k + d)).2 < H₂ + y₂
  | 0, _, _, under => under
  | d + 1, k, bound, under =>
    have kLt : k < L :=
      Nat.lt_of_lt_of_le (Nat.lt_add_of_pos_right (Nat.succ_pos d)) bound
    have wNe : (LineOnAStock.course need kids giving use (w₀, x₀) k).1 ≠ [] :=
      match allGoes k kLt with
      | ⟨_, mu, _⟩ => fun e => nomatch (e ▸ mu)
    have dGe : H₂ ≤ LineOnAStock.taken use
        (LineOnAStock.course need kids giving use (w₀, x₀) k).1 :=
      floorDraw _ wNe
    have underSucc : (LineOnAStock.course need kids giving use (w₀, x₀) (k + 1)).2 < H₂ + y₂ :=
      match LineOnAStock.step_lowers short2 nothing dGe under with
      | .inl zero => Nat.lt_of_le_of_lt (Nat.le_of_eq zero) (Nat.lt_of_le_of_lt (Nat.zero_le _) under)
      | .inr lt => Nat.lt_trans lt under
    have eqAdd : k + (d + 1) = (k + 1) + d :=
      ((Nat.add_assoc k 1 d).trans (congrArg (k + ·) (Nat.add_comm 1 d))).symm
    have k1Le : (k + 1) + d ≤ L :=
      Nat.le_trans (Nat.le_of_eq eqAdd.symm) bound
    eqAdd ▸ course_bad_stays_below_aux nothing short2 floorDraw allGoes d (k + 1) k1Le underSucc

private theorem course_bad_stays_below_while_goes {U : Type}
    {need use : U → Nat} {kids : U → List U} {giving : Nat → Nat}
    {H₂ y₂ : Nat}
    (nothing : RegimeMargin.FromNothing giving)
    (short2 : RegimeMargin.Short giving H₂ y₂)
    (floorDraw : ∀ w, w ≠ [] → H₂ ≤ LineOnAStock.taken use w)
    {w₀ : List U} {x₀ L : Nat}
    (allGoes : ∀ t, t < L →
      LineOnAStock.Goes need (LineOnAStock.course need kids giving use (w₀, x₀) t)) :
    ∀ k, k ≤ L →
      (LineOnAStock.course need kids giving use (w₀, x₀) k).2 < H₂ + y₂ →
      (LineOnAStock.course need kids giving use (w₀, x₀) L).2 < H₂ + y₂
  | k, le, under =>
    match le_dest le with
    | ⟨d, eq⟩ =>
      eq.symm ▸ course_bad_stays_below_aux nothing short2 floorDraw allGoes d k (Nat.le_of_eq eq.symm) under

private theorem dec_all_met_or_first_unmet {U : Type}
    (need : U → Nat) (kids : U → List U) (giving : Nat → Nat) (use : U → Nat)
    (w₀ : List U) (x₀ : Nat) :
    ∀ k, (∀ t, t < k → ∀ u, u ∈ (LineOnAStock.course need kids giving use (w₀, x₀) t).1 →
        need u ≤ (LineOnAStock.course need kids giving use (w₀, x₀) t).2) ∨
      ∃ t, t < k ∧ ∃ u, u ∈ (LineOnAStock.course need kids giving use (w₀, x₀) t).1 ∧
        (LineOnAStock.course need kids giving use (w₀, x₀) t).2 < need u
  | 0 => Or.inl fun _ lt => absurd lt (Nat.not_lt_zero _)
  | k + 1 =>
    match dec_all_met_or_first_unmet need kids giving use w₀ x₀ k with
    | .inr ⟨t, lt, u, mu, unmet⟩ => Or.inr ⟨t, Nat.lt_succ_of_lt lt, u, mu, unmet⟩
    | .inl before =>
      match LineOnAStock.met_or_unmet need
          (LineOnAStock.course need kids giving use (w₀, x₀) k).2
          (LineOnAStock.course need kids giving use (w₀, x₀) k).1 with
      | .inl atK => Or.inl fun t lt =>
          (Nat.lt_or_eq_of_le (Nat.le_of_lt_succ lt)).elim (before t) fun eq => eq ▸ atK
      | .inr ⟨u, mu, unmet⟩ => Or.inr ⟨k, Nat.lt_succ_self k, u, mu, unmet⟩

/-- **Theorem 3B (`unrecoverable_cadence_impossibility`, general interface).**
Given `2 ≤ N`, two distinct observation values `x_o ≠ y_o : O`, `FromNothing giving`,
`AtMost giving Y`, `Y < H₁ ≤ H₂ + y₂`, `Short giving H₂ y₂`, `∀ u, 0 < need u ∧ need u ≤ H₂ + y₂`,
`LowerDrawWhileMet H₁ need g_bad w₀ x₀ (2 * N - 1)`, `∀ w, w ≠ [] → H₂ ≤ taken use w`, and
`x₀ < (H₂ + y₂) + (H₁ - Y) * (2 * N - 1)`:
1. If `L < 2 * N - 1`, `¬ Pace.StretchFixes O N L` and two `N`-state `lassoStep` held courses
   agree on `< L` (in fact `< 2 * N - 2`) and part at `2 * N - 2`.
2. If `2 * N - 1 ≤ L` (for any `σ 0 = 0`, `σ 1 = L`, `Strict σ`, `ReadAtSpanEnd σ reads`, and any
   update law `h`, e.g. switching unconditionally to `g_safe` at `σ 1 = L`), if the `g_bad`
   `pacedCourse` does not already break `LineOnAStock.Goes` before `L`, it arrives at `x_L < H₂ + y₂`;
   and in all cases `∃ t, ¬ LineOnAStock.Goes need (w_t, x_t)`. -/
theorem unrecoverable_cadence_impossibility {A U R O : Type}
    {fA : A → R → A} {need : U → Nat} {kids : R → U → List U}
    {giving : Nat → Nat} {use : U → Nat}
    {N Y H₁ H₂ y₂ : Nat} {x_o y_o : O}
    (nGe2 : 2 ≤ N) (two : x_o ≠ y_o)
    (nothing : RegimeMargin.FromNothing giving)
    (most : RegimeMargin.AtMost giving Y)
    (yLtH1 : Y < H₁)
    (h1Le : H₁ ≤ H₂ + y₂)
    (short2 : RegimeMargin.Short giving H₂ y₂)
    (needsPos : ∀ u, 0 < need u ∧ need u ≤ H₂ + y₂)
    {g_bad : R} {w₀ : List U} {x₀ : Nat}
    (lower : LowerDrawWhileMet H₁ need kids giving use g_bad w₀ x₀ (2 * N - 1))
    (floorDraw : ∀ w, w ≠ [] → H₂ ≤ LineOnAStock.taken use w)
    (underBudget : x₀ < (H₂ + y₂) + (H₁ - Y) * (2 * N - 1)) :
    (∀ L, L < 2 * N - 1 →
      ¬ Pace.StretchFixes O N L ∧
        StatesBelow (Pace.heldCourse Pace.lassoStep (0, (N - 2) + 1)
          (fun p => if p = (N - 2) + 1 then y_o else x_o) 0) N ∧
        StatesBelow (Pace.heldCourse Pace.lassoStep (1, N - 2)
          (fun p => if p = (N - 2) + 1 then y_o else x_o) 0) N ∧
        (∀ t, t < L →
          Pace.heldCourse Pace.lassoStep (0, (N - 2) + 1)
            (fun p => if p = (N - 2) + 1 then y_o else x_o) 0 t =
          Pace.heldCourse Pace.lassoStep (1, N - 2)
            (fun p => if p = (N - 2) + 1 then y_o else x_o) 0 t) ∧
        Pace.heldCourse Pace.lassoStep (0, (N - 2) + 1)
          (fun p => if p = (N - 2) + 1 then y_o else x_o) 0 (2 * N - 2) ≠
        Pace.heldCourse Pace.lassoStep (1, N - 2)
          (fun p => if p = (N - 2) + 1 then y_o else x_o) 0 (2 * N - 2)) ∧
    (∀ (L : Nat) (σ : Nat → Nat) (reads : Nat → Bool)
        (h : StockState A U → R → R) (a₀ : A),
      2 * N - 1 ≤ L → σ 0 = 0 → σ 1 = L →
      Becoming.Strict σ → ReadAtSpanEnd σ reads →
      let c : StockState A U × R := ((a₀, (w₀, x₀)), g_bad)
      ((∀ t, t < L →
          LineOnAStock.Goes need (pacedCourse fA need kids giving use h reads c t).1.2) →
        (pacedCourse fA need kids giving use h reads c L).1.2.2 < H₂ + y₂) ∧
      ∃ t, ¬ LineOnAStock.Goes need (pacedCourse fA need kids giving use h reads c t).1.2) := by
  refine ⟨fun L hL => ?_, fun L σ reads h a₀ hL σ0 σ1 strict cadence => ?_⟩
  · have notFixes : ¬ Pace.StretchFixes O N L := fun fixes =>
      Nat.not_le_of_gt hL
        (Eq.subst (motive := (· ≤ L)) (two_mul_pred_eq N).symm ((Pace.pace_law two N L).mp fixes))
    have eqN : (N - 2) + 2 = N := Naturals.sub_add_cancel nGe2
    have eq2N2 : (N - 2) + (N - 2) + 2 = 2 * N - 2 := by
      have h2N : 2 * N = (N - 2) + (N - 2) + 4 := by
        rw [Naturals.two_mul, ← eqN]
        calc (N - 2 + 2) + (N - 2 + 2) = (N - 2) + (2 + (N - 2 + 2)) := Nat.add_assoc _ _ _
          _ = (N - 2) + ((N - 2 + 2) + 2) := congrArg ((N - 2) + ·) (Nat.add_comm 2 _)
          _ = (N - 2) + ((N - 2) + 4) := congrArg ((N - 2) + ·) (Nat.add_assoc (N - 2) 2 2)
          _ = (N - 2) + (N - 2) + 4 := (Nat.add_assoc _ _ _).symm
      rw [h2N]
      exact Naturals.add_sub_cancel ((N - 2) + (N - 2) + 2) 2
    have hL2 : L ≤ (N - 2) + (N - 2) + 2 := by
      have h2N1 : 2 * N - 1 = (N - 2) + (N - 2) + 3 := by
        rw [Naturals.two_mul, ← eqN]
        have hsum : (N - 2 + 2) + (N - 2 + 2) = (N - 2) + (N - 2) + 4 := by
          calc (N - 2 + 2) + (N - 2 + 2) = (N - 2) + (2 + (N - 2 + 2)) := Nat.add_assoc _ _ _
            _ = (N - 2) + ((N - 2 + 2) + 2) := congrArg ((N - 2) + ·) (Nat.add_comm 2 _)
            _ = (N - 2) + ((N - 2) + 4) := congrArg ((N - 2) + ·) (Nat.add_assoc (N - 2) 2 2)
            _ = (N - 2) + (N - 2) + 4 := (Nat.add_assoc _ _ _).symm
        rw [hsum]
        rfl
      rw [h2N1] at hL
      exact Nat.le_of_lt_succ hL
    have dis := Pace.dissolving two (N - 2)
    refine ⟨notFixes,
      eqN ▸ dis.1,
      eqN ▸ dis.2.1,
      fun t ht => dis.2.2.1 t (Nat.lt_of_lt_of_le ht hL2),
      eq2N2 ▸ dis.2.2.2⟩
  · let c : StockState A U × R := ((a₀, (w₀, x₀)), g_bad)
    have atSpan : ∀ t, t < L →
        (pacedCourse fA need kids giving use h reads c t).1.2 =
          LineOnAStock.course need (kids g_bad) giving use (w₀, x₀) t := by
      intro t ht
      have memSpan : t ∈ Becoming.span σ 0 :=
        Becoming.span_mem strict
          (Eq.subst (motive := (· ≤ t)) σ0.symm (Nat.zero_le t))
          (Eq.subst (motive := (t < ·)) σ1.symm ht)
      have hheld := (paced_held_on_span (fA := fA) (need := need) (kids := kids)
        (giving := giving) (use := use) (h := h) strict cadence c memSpan).2
      rw [σ0, Nat.sub_zero] at hheld
      exact hheld
    have atL : (pacedCourse fA need kids giving use h reads c L).1.2 =
        LineOnAStock.course need (kids g_bad) giving use (w₀, x₀) L := by
      have trans0 := paced_block_transition (fA := fA) (need := need) (kids := kids)
        (giving := giving) (use := use) (h := h) strict cadence c 0
      have h1 := trans0.1
      rw [σ1, σ0, Nat.sub_zero] at h1
      change (pacedCourse fA need kids giving use h reads c L).1.2 = _
      rw [h1]
      exact fineStep_orbit_snd (a₀, (w₀, x₀)) g_bad L
    have belowAtL :
        (∀ t, t < L →
          LineOnAStock.Goes need (pacedCourse fA need kids giving use h reads c t).1.2) →
        (pacedCourse fA need kids giving use h reads c L).1.2.2 < H₂ + y₂ := by
      intro allPacedGoes
      have allCourseGoes : ∀ t, t < L →
          LineOnAStock.Goes need (LineOnAStock.course need (kids g_bad) giving use (w₀, x₀) t) :=
        fun t ht => atSpan t ht ▸ allPacedGoes t ht
      rw [atL]
      rcases dec_all_met_or_first_unmet need (kids g_bad) giving use w₀ x₀ (2 * N - 1) with
        allMet | ⟨t, tLt, u, _, unmet⟩
      · have falls := RegimeMargin.falls_within (g := fun _ => Y) (H := H₁) (Y := Y)
          (b := H₂ + y₂) (x := x₀) (n := 2 * N - 1)
          (fun _ => Nat.le_refl Y) (Nat.le_of_lt yLtH1) h1Le underBudget
        rcases falls with ⟨k, kLe, kLt⟩
        have kLtCourse : (LineOnAStock.course need (kids g_bad) giving use (w₀, x₀) k).2 < H₂ + y₂ :=
          Nat.lt_of_le_of_lt
            (line_envelope_upper nothing most lower allMet k kLe) kLt
        exact course_bad_stays_below_while_goes nothing short2 floorDraw allCourseGoes
          k (Nat.le_trans kLe hL) kLtCourse
      · have tLtCourse : (LineOnAStock.course need (kids g_bad) giving use (w₀, x₀) t).2 < H₂ + y₂ :=
          Nat.lt_of_lt_of_le unmet (needsPos u).2
        exact course_bad_stays_below_while_goes nothing short2 floorDraw allCourseGoes
          t (Nat.le_trans (Nat.le_of_lt tLt) hL) tLtCourse
    refine ⟨belowAtL, ?_⟩
    have decL : (∀ t, t < L →
        LineOnAStock.Goes need (pacedCourse fA need kids giving use h reads c t).1.2) ∨
        ∃ t, t < L ∧ ¬ LineOnAStock.Goes need (pacedCourse fA need kids giving use h reads c t).1.2 := by
      have aux : ∀ m : Nat,
          (∀ t, t < m →
            LineOnAStock.Goes need (pacedCourse fA need kids giving use h reads c t).1.2) ∨
          ∃ t, t < m ∧ ¬ LineOnAStock.Goes need (pacedCourse fA need kids giving use h reads c t).1.2 := by
        intro m
        induction m with
        | zero => exact Or.inl fun _ lt => absurd lt (Nat.not_lt_zero _)
        | succ m ih =>
          rcases ih with allM | ⟨t, tLt, noM⟩
          · match (inferInstance : Decidable (LineOnAStock.Goes need
                (pacedCourse fA need kids giving use h reads c m).1.2)) with
            | .isTrue goM =>
              exact Or.inl fun t lt =>
                (Nat.lt_or_eq_of_le (Nat.le_of_lt_succ lt)).elim (allM t) fun eq => eq ▸ goM
            | .isFalse noM => exact Or.inr ⟨m, Nat.lt_succ_self m, noM⟩
          · exact Or.inr ⟨t, Nat.lt_succ_of_lt tLt, noM⟩
      exact aux L
    rcases decL with allL | ⟨t, _, noT⟩
    · have xL_under := belowAtL allL
      exact pacedCourse_ends_below_point nothing short2 (fun u => (needsPos u).1) floorDraw c
        (pacedCourse fA need kids giving use h reads c L).1.2.2 L (Nat.le_refl _) xL_under
    · exact ⟨t, noT⟩

/-- **Theorem 3B (Coupled two-rule theorem on ONE `fineStep`).**
Specializing `fA := Pace.lassoStep`, `g_safe := (0, M + 1)`, `g_bad := (1, M)`, `N := M + 2`,
and observation map `o_M s := decide (s.1 = M + 1)` on the **exact same pair `(g_safe, g_bad)`**
embedded in `pacedCourse`:
1. For `L < 2 * (M + 2) - 1`: `¬ Pace.StretchFixes Bool (M + 2) L`, both actual `pacedCourse`s
   from `((0, (w₀, x₀)), g_safe)` and `((0, (w₀, x₀)), g_bad)` emit identical `o_M` observations
   across the entire first span `span σ 0`, while their held courses have at most `M + 2` states
   and separate at `2 * (M + 2) - 2 = M + M + 2`.
2. For `2 * (M + 2) - 1 ≤ L`: under the stock/draw hypotheses on `g_bad`, switching to `g_safe`
   at `σ 1 = L` (or any rule update `h`) cannot rescue the `g_bad` `pacedCourse`, which hits
   `¬ LineOnAStock.Goes`. -/
theorem coupled_two_rule_impossibility {U : Type}
    {need : U → Nat} {kids : (Nat × Nat) → U → List U}
    {giving : Nat → Nat} {use : U → Nat}
    (M : Nat)
    {Y H₁ H₂ y₂ : Nat}
    (nothing : RegimeMargin.FromNothing giving)
    (most : RegimeMargin.AtMost giving Y)
    (yLtH1 : Y < H₁)
    (h1Le : H₁ ≤ H₂ + y₂)
    (short2 : RegimeMargin.Short giving H₂ y₂)
    (needsPos : ∀ u, 0 < need u ∧ need u ≤ H₂ + y₂)
    {w₀ : List U} {x₀ : Nat}
    (lower : LowerDrawWhileMet H₁ need kids giving use (1, M) w₀ x₀ (2 * (M + 2) - 1))
    (floorDraw : ∀ w, w ≠ [] → H₂ ≤ LineOnAStock.taken use w)
    (underBudget : x₀ < (H₂ + y₂) + (H₁ - Y) * (2 * (M + 2) - 1)) :
    let g_safe : Nat × Nat := (0, M + 1)
    let g_bad : Nat × Nat := (1, M)
    let o_M : StockState Nat U → Bool := fun s => decide (s.1 = M + 1)
    let c_safe : StockState Nat U × (Nat × Nat) := ((0, (w₀, x₀)), g_safe)
    let c_bad : StockState Nat U × (Nat × Nat) := ((0, (w₀, x₀)), g_bad)
    (∀ (L : Nat) (σ : Nat → Nat) (reads_s reads_b : Nat → Bool)
        (h_s h_b : StockState Nat U → (Nat × Nat) → (Nat × Nat)),
      L < 2 * (M + 2) - 1 → σ 0 = 0 → σ 1 = L →
      Becoming.Strict σ → ReadAtSpanEnd σ reads_s → ReadAtSpanEnd σ reads_b →
      ¬ Pace.StretchFixes Bool (M + 2) L ∧
        (∀ t, t ∈ Becoming.span σ 0 →
          o_M (pacedCourse Pace.lassoStep need kids giving use h_s reads_s c_safe t).1 =
            o_M (pacedCourse Pace.lassoStep need kids giving use h_b reads_b c_bad t).1) ∧
        StatesBelow (Pace.heldCourse Pace.lassoStep g_safe (fun p => decide (p = M + 1)) 0) (M + 2) ∧
        StatesBelow (Pace.heldCourse Pace.lassoStep g_bad (fun p => decide (p = M + 1)) 0) (M + 2) ∧
        Pace.heldCourse Pace.lassoStep g_safe (fun p => decide (p = M + 1)) 0 (2 * (M + 2) - 2) ≠
          Pace.heldCourse Pace.lassoStep g_bad (fun p => decide (p = M + 1)) 0 (2 * (M + 2) - 2)) ∧
    (∀ (L : Nat) (σ : Nat → Nat) (reads : Nat → Bool)
        (h : StockState Nat U → (Nat × Nat) → (Nat × Nat)),
      2 * (M + 2) - 1 ≤ L → σ 0 = 0 → σ 1 = L →
      Becoming.Strict σ → ReadAtSpanEnd σ reads →
      ((∀ t, t < L →
          LineOnAStock.Goes need
            (pacedCourse Pace.lassoStep need kids giving use h reads c_bad t).1.2) →
        (pacedCourse Pace.lassoStep need kids giving use h reads c_bad L).1.2.2 < H₂ + y₂) ∧
      ∃ t, ¬ LineOnAStock.Goes need
        (pacedCourse Pace.lassoStep need kids giving use h reads c_bad t).1.2) := by
  have gen := unrecoverable_cadence_impossibility (A := Nat) (U := U) (R := Nat × Nat) (O := Bool)
    (fA := Pace.lassoStep) (need := need) (kids := kids) (giving := giving) (use := use)
    (N := M + 2) (Y := Y) (H₁ := H₁) (H₂ := H₂) (y₂ := y₂)
    (x_o := false) (y_o := true)
    (Nat.le_add_left 2 M) Bool.false_ne_true nothing most yLtH1 h1Le short2 needsPos
    lower floorDraw underBudget
  have mkEq : ∀ p, (if p = M + 1 then true else false) = decide (p = M + 1) := fun p => by
    cases hdec : decide (p = M + 1) with
    | false => exact if_neg (of_decide_eq_false hdec)
    | true => exact if_pos (of_decide_eq_true hdec)
  have dis := Pace.dissolving Bool.false_ne_true M
  have eq2N2 : M + M + 2 = 2 * (M + 2) - 2 := by
    have h1 : 2 * (M + 2) = M + M + 4 := by
      rw [Naturals.two_mul]
      calc (M + 2) + (M + 2) = M + (2 + (M + 2)) := Nat.add_assoc _ _ _
        _ = M + ((M + 2) + 2) := congrArg (M + ·) (Nat.add_comm 2 _)
        _ = M + (M + 4) := congrArg (M + ·) (Nat.add_assoc M 2 2)
        _ = M + M + 4 := (Nat.add_assoc M M 4).symm
    rw [h1]
    exact (Naturals.add_sub_cancel (M + M + 2) 2).symm
  refine ⟨fun L σ reads_s reads_b h_s h_b hL σ0 σ1 strict cad_s cad_b => ?_,
          fun L σ reads h hL σ0 σ1 strict cad =>
            gen.2 L σ reads h 0 hL σ0 σ1 strict cad⟩
  have hnotFixes := (gen.1 L hL).1
  have hObs : ∀ t, t ∈ Becoming.span σ 0 →
      decide ((pacedCourse Pace.lassoStep need kids giving use h_s reads_s
          ((0, (w₀, x₀)), (0, M + 1)) t).1.1 = M + 1) =
        decide ((pacedCourse Pace.lassoStep need kids giving use h_b reads_b
          ((0, (w₀, x₀)), (1, M)) t).1.1 = M + 1) := by
    intro t mem
    have hs := paced_held_on_span_state (fA := Pace.lassoStep) (need := need) (kids := kids)
      (giving := giving) (use := use) (h := h_s) (reads := reads_s) strict cad_s
      ((0, (w₀, x₀)), (0, M + 1)) mem
    have hb := paced_held_on_span_state (fA := Pace.lassoStep) (need := need) (kids := kids)
      (giving := giving) (use := use) (h := h_b) (reads := reads_b) strict cad_b
      ((0, (w₀, x₀)), (1, M)) mem
    have hs1 : (pacedCourse Pace.lassoStep need kids giving use h_s reads_s
        ((0, (w₀, x₀)), (0, M + 1)) t).1.1 =
        Law.orbit (fun p => Pace.lassoStep p (0, M + 1)) 0 t := by
      have e1 := congrArg (fun p => p.1.1) hs
      rw [σ0, Nat.sub_zero] at e1
      exact e1.trans (fineStep_orbit_fst (0, (w₀, x₀)) (0, M + 1) t)
    have hb1 : (pacedCourse Pace.lassoStep need kids giving use h_b reads_b
        ((0, (w₀, x₀)), (1, M)) t).1.1 =
        Law.orbit (fun p => Pace.lassoStep p (1, M)) 0 t := by
      have e1 := congrArg (fun p => p.1.1) hb
      rw [σ0, Nat.sub_zero] at e1
      exact e1.trans (fineStep_orbit_fst (0, (w₀, x₀)) (1, M) t)
    have tLtL : t < L := σ1 ▸ (Becoming.mem_span strict mem).2
    have h2N1 : 2 * (M + 2) - 1 = M + M + 3 := by
      rw [Naturals.two_mul]
      have hsum : (M + 2) + (M + 2) = M + M + 4 := by
        calc (M + 2) + (M + 2) = M + (2 + (M + 2)) := Nat.add_assoc _ _ _
          _ = M + ((M + 2) + 2) := congrArg (M + ·) (Nat.add_comm 2 _)
          _ = M + (M + 4) := congrArg (M + ·) (Nat.add_assoc M 2 2)
          _ = M + M + 4 := (Nat.add_assoc M M 4).symm
      rw [hsum]; rfl
    have tLtMM2 : t < M + M + 2 :=
      Nat.lt_of_lt_of_le tLtL (Nat.le_of_lt_succ (Eq.subst (motive := (L < ·)) h2N1 hL))
    rw [hs1, hb1]
    exact (mkEq _).symm.trans ((dis.2.2.1 t tLtMM2).trans (mkEq _))
  refine ⟨hnotFixes, hObs, ?_, ?_, ?_⟩
  · have sb := dis.1
    exact IdentificationRuns.statesBelow_congr (fun n => mkEq _) sb
  · have sb := dis.2.1
    exact IdentificationRuns.statesBelow_congr (fun n => mkEq _) sb
  · intro same
    apply dis.2.2.2
    rw [eq2N2]
    exact (mkEq _).trans (same.trans (mkEq _).symm)

end Pillar3

/-! ## Concrete `SandwichWitness` -/

namespace SandwichWitness

inductive UnitKind where
  | init
  | bad
  | safe

open UnitKind

def need (_ : UnitKind) : Nat := 1

def use : UnitKind → Nat
  | .init => 10
  | .bad => 10
  | .safe => 6

def kids (M : Nat) (g : Nat × Nat) (_ : UnitKind) : List UnitKind :=
  cond (decide (g.1 = 0) && decide (g.2 = M + 1)) [.safe] [.bad]

private def min2 (a b : Nat) : Nat := cond (decide (a ≤ b)) a b

private theorem min2_le_left (a b : Nat) : min2 a b ≤ a :=
  match Nat.lt_or_ge b a with
  | .inl lt =>
    Eq.subst (motive := fun c => cond c a b ≤ a) (decide_eq_false (Nat.not_le_of_gt lt)).symm
      (Nat.le_of_lt lt)
  | .inr le =>
    Eq.subst (motive := fun c => cond c a b ≤ a) (decide_eq_true le).symm (Nat.le_refl a)

private theorem min2_le_right (a b : Nat) : min2 a b ≤ b :=
  match Nat.lt_or_ge b a with
  | .inl lt =>
    Eq.subst (motive := fun c => cond c a b ≤ b) (decide_eq_false (Nat.not_le_of_gt lt)).symm
      (Nat.le_refl b)
  | .inr le =>
    Eq.subst (motive := fun c => cond c a b ≤ b) (decide_eq_true le).symm le

private theorem le_min2 {c a b : Nat} (ha : c ≤ a) (hb : c ≤ b) : c ≤ min2 a b :=
  match Nat.lt_or_ge b a with
  | .inl lt =>
    Eq.subst (motive := fun d => c ≤ cond d a b) (decide_eq_false (Nat.not_le_of_gt lt)).symm hb
  | .inr le =>
    Eq.subst (motive := fun d => c ≤ cond d a b) (decide_eq_true le).symm ha

def giving (z : Nat) : Nat := min2 z (min2 8 (60 - z))

def obs (M : Nat) (s : StockState Nat UnitKind) : Bool := decide (s.1 = M + 1)

theorem giving_fromNothing : RegimeMargin.FromNothing giving := rfl

theorem giving_atMost8 : RegimeMargin.AtMost giving 8 := fun z =>
  Nat.le_trans (min2_le_right z (min2 8 (60 - z))) (min2_le_left 8 (60 - z))

theorem giving_short6 : RegimeMargin.Short giving 6 6 := fun z lt =>
  Nat.lt_of_le_of_lt (min2_le_left z _) lt

theorem giving_meets6 : RegimeMargin.Meets giving 6 6 60 := fun z h6 htop => by
  have h1 : 6 ≤ min2 8 (60 - z) := by
    have h60 : 6 ≤ 60 - z :=
      Naturals.le_of_add_le_add_left (k := z)
        (Nat.le_trans htop (Nat.le_of_eq (Naturals.add_sub_of_le
          (Nat.le_trans (Nat.le_add_right z 6) htop)).symm))
    exact le_min2 (by decide) h60
  exact le_min2 h6 h1

theorem giving_keeps0 : RegimeMargin.Keeps giving 0 60 := fun x hx => by
  show (x - 0) + giving (x - 0) ≤ 60
  have hgiv : giving x ≤ 60 - x :=
    Nat.le_trans (min2_le_right x _) (min2_le_right 8 (60 - x))
  exact Nat.le_trans (Nat.add_le_add_left hgiv x) (Nat.le_of_eq (Naturals.add_sub_of_le hx))

theorem giving_keeps6 : RegimeMargin.Keeps giving 6 60 := fun _ =>
  TurningInTime.kept_within giving_keeps0 6

private theorem floor6 : ∀ w : List UnitKind, w ≠ [] → 6 ≤ LineOnAStock.taken use w
  | [], ne => absurd rfl ne
  | u :: _, _ =>
    have hu : 6 ≤ use u := match u with | .init => by decide | .bad => by decide | .safe => by decide
    Nat.le_trans hu (Nat.le_add_right (use u) _)

private theorem bad_gen_form (M : Nat) :
    ∀ n, LineOnAStock.generation (kids M (1, M)) n [.init] = [.init] ∨
      LineOnAStock.generation (kids M (1, M)) n [.init] = [.bad]
  | 0 => Or.inl rfl
  | n + 1 =>
    match bad_gen_form M n with
    | .inl eqI => Or.inr (congrArg (LineOnAStock.allKids (kids M (1, M))) eqI)
    | .inr eqB => Or.inr (congrArg (LineOnAStock.allKids (kids M (1, M))) eqB)

private theorem bad_lower_draw_imp (M : Nat) (x₀ k : Nat) :
    LowerDrawWhileMet 10 need (kids M) giving use (1, M) [.init] x₀ k := by
  intro t _ allMet
  have wayEq : (LineOnAStock.course need (kids M (1, M)) giving use ([.init], x₀) t).1 =
      LineOnAStock.generation (kids M (1, M)) t [.init] :=
    LineOnAStock.way_while_met fun j lt => allMet j (Nat.le_of_lt lt)
  rw [wayEq]
  rcases bad_gen_form M t with eqI | eqB
  · rw [eqI]; exact Nat.le_refl 10
  · rw [eqB]; exact Nat.le_refl 10

private theorem len_le_one_taken_le_10 :
    ∀ w : List UnitKind, w.length ≤ 1 → LineOnAStock.taken use w ≤ 10
  | [], _ => Nat.zero_le 10
  | [u], _ => match u with
    | .init => Nat.le_refl 10
    | .bad => Nat.le_refl 10
    | .safe => Nat.le_succ_of_le (Nat.le_succ_of_le (Nat.le_succ_of_le (Nat.le_succ 6)))
  | _ :: _ :: _, h => absurd (Nat.le_of_succ_le_succ h) (Nat.not_succ_le_zero _)

private theorem kids_len_one (M : Nat) (g : Nat × Nat) (u : UnitKind) :
    (kids M g u).length = 1 := by
  show (cond (decide (g.1 = 0) && decide (g.2 = M + 1)) [UnitKind.safe] [UnitKind.bad]).length = 1
  cases decide (g.1 = 0) && decide (g.2 = M + 1) <;> rfl

private theorem after_len_le_one (M : Nat) (g : Nat × Nat) (x : Nat) :
    ∀ w : List UnitKind, w.length ≤ 1 →
      (LineOnAStock.after need (kids M g) w x).length ≤ 1
  | [], _ => Nat.zero_le 1
  | [u], _ => by
    show (cond (decide (need u ≤ x)) (kids M g u) [] ++ []).length ≤ 1
    rw [ListTests.append_nil]
    cases decide (need u ≤ x)
    · exact Nat.zero_le 1
    · exact Nat.le_of_eq (kids_len_one M g u)
  | _ :: _ :: _, h => absurd (Nat.le_of_succ_le_succ h) (Nat.not_succ_le_zero _)

private theorem course_len_le_one (M : Nat) (g : Nat × Nat) (x₀ : Nat) :
    ∀ t, (LineOnAStock.course need (kids M g) giving use ([.init], x₀) t).1.length ≤ 1
  | 0 => Nat.le_refl 1
  | t + 1 => after_len_le_one M g _ _ (course_len_le_one M g x₀ t)

private theorem upper_draw_10 (M : Nat) (g : Nat × Nat) (x₀ k : Nat) :
    UpperDraw need use (kids M) giving 10 g [.init] x₀ k :=
  fun t _ => len_le_one_taken_le_10 _ (course_len_le_one M g x₀ t)

/-! ### Periodic span-end cadence (for any block length `p + 1`) -/

def cycleStep (p r : Nat) : Nat :=
  cond (decide (r = p)) 0 (r + 1)

def cycleMod (p : Nat) : Nat → Nat
  | 0 => 0
  | n + 1 => cycleStep p (cycleMod p n)

private theorem cycleMod_mul_add (p : Nat) :
    ∀ j, cycleMod p ((p + 1) * j) = 0 ∧
      ∀ r, r ≤ p → cycleMod p ((p + 1) * j + r) = r
  | 0 =>
    ⟨rfl, fun r hr => by
      induction r with
      | zero => rfl
      | succ r ih =>
        have hrp : r ≤ p := Nat.le_of_lt hr
        have neq : r ≠ p := Naturals.ne_of_lt hr
        show cycleStep p (cycleMod p ((p + 1) * 0 + r)) = r + 1
        rw [ih hrp]
        show cond (decide (r = p)) 0 (r + 1) = r + 1
        rw [decide_eq_false neq]
        rfl⟩
  | j + 1 =>
    have ih := cycleMod_mul_add p j
    have stepBase : cycleMod p ((p + 1) * (j + 1)) = 0 := by
      have eq1 : (p + 1) * (j + 1) = ((p + 1) * j + p) + 1 :=
        (Nat.mul_succ (p + 1) j).trans (Nat.add_assoc ((p + 1) * j) p 1).symm
      rw [eq1]
      show cycleStep p (cycleMod p ((p + 1) * j + p)) = 0
      rw [ih.2 p (Nat.le_refl p)]
      show cond (decide (p = p)) 0 (p + 1) = 0
      rw [decide_eq_true rfl]
      rfl
    ⟨stepBase, fun r hr => by
      induction r with
      | zero => exact stepBase
      | succ r ihr =>
        have hrp : r ≤ p := Nat.le_of_lt hr
        have neq : r ≠ p := Naturals.ne_of_lt hr
        show cycleStep p (cycleMod p ((p + 1) * (j + 1) + r)) = r + 1
        rw [ihr hrp]
        show cond (decide (r = p)) 0 (r + 1) = r + 1
        rw [decide_eq_false neq]
        rfl⟩

def periodSigma (p j : Nat) : Nat := (p + 1) * j

def periodReads (p t : Nat) : Bool := decide (cycleMod p t = p)

theorem periodSigma_strict (p : Nat) : Becoming.Strict (periodSigma p) := fun j =>
  Nat.lt_of_lt_of_le (Nat.lt_add_of_pos_right (Nat.succ_pos p))
    (Nat.le_of_eq (Nat.mul_succ (p + 1) j).symm)

theorem periodReads_cadence (p : Nat) : ReadAtSpanEnd (periodSigma p) (periodReads p) :=
  fun j t hle hlt => by
    let r := t - (p + 1) * j
    have eqT : (p + 1) * j + r = t := add_sub_of_le hle
    have hlt' : (p + 1) * j + r < (p + 1) * j + (p + 1) :=
      Eq.subst (motive := (· < (p + 1) * j + (p + 1))) eqT.symm
        (Eq.subst (motive := (t < ·)) (Nat.mul_succ (p + 1) j) hlt)
    have hrLe : r ≤ p := Nat.le_of_lt_succ (lt_of_add_lt_add_left_nat hlt')
    have hmod : cycleMod p t = r := eqT ▸ (cycleMod_mul_add p j).2 r hrLe
    show decide (cycleMod p t = p) = true ↔ t + 1 = (p + 1) * (j + 1)
    rw [hmod]
    constructor
    · intro hp
      have rEq : r = p := of_decide_eq_true hp
      calc t + 1 = (p + 1) * j + r + 1 := congrArg (· + 1) eqT.symm
        _ = (p + 1) * j + p + 1 := by rw [rEq]
        _ = (p + 1) * j + (p + 1) := Nat.add_assoc _ p 1
        _ = (p + 1) * (j + 1) := (Nat.mul_succ (p + 1) j).symm
    · intro hend
      have sumEq : (p + 1) * j + (r + 1) = (p + 1) * j + (p + 1) :=
        (Nat.add_assoc _ r 1).symm.trans
          ((congrArg (· + 1) eqT).trans (hend.trans (Nat.mul_succ (p + 1) j)))
      have r1 : r + 1 = p + 1 := Naturals.add_left_cancel sumEq
      exact decide_eq_true (Nat.succ.inj r1)

/-! ### Impossibility witness (`N = 3`, `M = 1`, `x₀ = 20`) -/

def impBadStart : StockState Nat UnitKind × (Nat × Nat) := ((0, ([.init], 20)), (1, 1))
def impSafeStart : StockState Nat UnitKind × (Nat × Nat) := ((0, ([.safe], 20)), (0, 2))

def switchTo (g_safe : Nat × Nat) (_ : StockState Nat UnitKind) (_ : Nat × Nat) : Nat × Nat :=
  g_safe

theorem imp_trace_levels :
    (LineOnAStock.course need (kids 1 (1, 1)) giving use ([.init], 20) 0).2 = 20 ∧
    (LineOnAStock.course need (kids 1 (1, 1)) giving use ([.init], 20) 1).2 = 18 ∧
    (LineOnAStock.course need (kids 1 (1, 1)) giving use ([.init], 20) 2).2 = 16 ∧
    (LineOnAStock.course need (kids 1 (1, 1)) giving use ([.init], 20) 3).2 = 12 ∧
    (LineOnAStock.course need (kids 1 (1, 1)) giving use ([.init], 20) 4).2 = 4 ∧
    (LineOnAStock.course need (kids 1 (1, 1)) giving use ([.init], 20) 5).2 = 0 ∧
    ¬ LineOnAStock.Goes need (LineOnAStock.course need (kids 1 (1, 1)) giving use ([.init], 20) 5) :=
  ⟨rfl, rfl, rfl, rfl, rfl, rfl, fun ⟨_, _, le⟩ => Nat.not_le_of_gt (Nat.succ_pos 0) le⟩

theorem imp_coupled_witness :
    (∀ (L : Nat) (σ : Nat → Nat) (reads_s reads_b : Nat → Bool)
        (h_s h_b : StockState Nat UnitKind → (Nat × Nat) → (Nat × Nat)),
      L < 5 → σ 0 = 0 → σ 1 = L →
      Becoming.Strict σ → ReadAtSpanEnd σ reads_s → ReadAtSpanEnd σ reads_b →
      ¬ Pace.StretchFixes Bool 3 L ∧
        (∀ t, t ∈ Becoming.span σ 0 →
          obs 1 (pacedCourse Pace.lassoStep need (kids 1) giving use h_s reads_s
              ((0, ([.init], 20)), (0, 2)) t).1 =
            obs 1 (pacedCourse Pace.lassoStep need (kids 1) giving use h_b reads_b
              impBadStart t).1) ∧
        Pace.heldCourse Pace.lassoStep (0, 2) (fun p => decide (p = 2)) 0 4 ≠
          Pace.heldCourse Pace.lassoStep (1, 1) (fun p => decide (p = 2)) 0 4) ∧
    (∀ (L : Nat) (σ : Nat → Nat) (reads : Nat → Bool)
        (h : StockState Nat UnitKind → (Nat × Nat) → (Nat × Nat)),
      5 ≤ L → σ 0 = 0 → σ 1 = L →
      Becoming.Strict σ → ReadAtSpanEnd σ reads →
      ((∀ t, t < L →
          LineOnAStock.Goes need
            (pacedCourse Pace.lassoStep need (kids 1) giving use h reads impBadStart t).1.2) →
        (pacedCourse Pace.lassoStep need (kids 1) giving use h reads impBadStart L).1.2.2 < 12) ∧
      ∃ t, ¬ LineOnAStock.Goes need
        (pacedCourse Pace.lassoStep need (kids 1) giving use h reads impBadStart t).1.2) := by
  have hCoupled := coupled_two_rule_impossibility 1 (need := need) (kids := kids 1)
    (giving := giving) (use := use) (Y := 8) (H₁ := 10) (H₂ := 6) (y₂ := 6)
    giving_fromNothing giving_atMost8 (by decide) (by decide) giving_short6
    (fun _ => ⟨Nat.succ_pos 0, (by decide : 1 ≤ 6 + 6)⟩)
    (bad_lower_draw_imp 1 20 5) floor6 (by decide : 20 < (6 + 6) + (10 - 8) * 5)
  exact ⟨fun L σ rs rb hs hb hL σ0 σ1 strict cs cb =>
      let r := hCoupled.1 L σ rs rb hs hb hL σ0 σ1 strict cs cb
      ⟨r.1, r.2.1, r.2.2.2.2⟩,
    hCoupled.2⟩

theorem imp_safe_counterpart_lasts :
    ∀ t, 20 ≤ (pacedCourse Pace.lassoStep need (kids 1) giving use (switchTo (0, 2))
        (fun _ => false) impSafeStart t).1.2.2 ∧
      (pacedCourse Pace.lassoStep need (kids 1) giving use (switchTo (0, 2))
        (fun _ => false) impSafeStart t).1.2.2 ≤ 60 ∧
      LineOnAStock.Goes need (pacedCourse Pace.lassoStep need (kids 1) giving use (switchTo (0, 2))
        (fun _ => false) impSafeStart t).1.2 := by
  have inv : ∀ t,
      (pacedCourse Pace.lassoStep need (kids 1) giving use (switchTo (0, 2))
        (fun _ => false) impSafeStart t).2 = (0, 2) ∧
      (pacedCourse Pace.lassoStep need (kids 1) giving use (switchTo (0, 2))
        (fun _ => false) impSafeStart t).1.2.1 = [.safe] ∧
      20 ≤ (pacedCourse Pace.lassoStep need (kids 1) giving use (switchTo (0, 2))
        (fun _ => false) impSafeStart t).1.2.2 ∧
      (pacedCourse Pace.lassoStep need (kids 1) giving use (switchTo (0, 2))
        (fun _ => false) impSafeStart t).1.2.2 ≤ 60 := by
    intro t
    induction t with
    | zero => exact ⟨rfl, rfl, Nat.le_refl 20, by decide⟩
    | succ t ih =>
      rcases ih with ⟨rEq, wEq, xLow, xHigh⟩
      have succT := Pace.paced_succ (f := fineStep Pace.lassoStep need (kids 1) giving use)
        (h := switchTo (0, 2)) (reads := fun _ => false) impSafeStart t
      have rNext : (pacedCourse Pace.lassoStep need (kids 1) giving use (switchTo (0, 2))
          (fun _ => false) impSafeStart (t + 1)).2 = (0, 2) := by
        dsimp only [pacedCourse]
        rw [succT]; exact rEq
      have stNext : (pacedCourse Pace.lassoStep need (kids 1) giving use (switchTo (0, 2))
          (fun _ => false) impSafeStart (t + 1)).1.2 =
          LineOnAStock.step need (kids 1 (0, 2)) giving use
            (pacedCourse Pace.lassoStep need (kids 1) giving use (switchTo (0, 2))
              (fun _ => false) impSafeStart t).1.2 := by
        dsimp only [pacedCourse]
        rw [succT]; show (fineStep _ _ _ _ _ _ _).2 = _; rw [rEq]; rfl
      have wNext : (pacedCourse Pace.lassoStep need (kids 1) giving use (switchTo (0, 2))
          (fun _ => false) impSafeStart (t + 1)).1.2.1 = [.safe] := by
        rw [stNext]
        show LineOnAStock.after need (kids 1 (0, 2)) _ _ = [.safe]
        rw [wEq]
        have h1 : need .safe ≤
            (pacedCourse Pace.lassoStep need (kids 1) giving use (switchTo (0, 2))
              (fun _ => false) impSafeStart t).1.2.2 :=
          Nat.le_trans (by decide) xLow
        show cond (decide (need .safe ≤ _)) (kids 1 (0, 2) .safe) [] ++ [] = [.safe]
        rw [decide_eq_true h1]
        rfl
      have bounds := RegimeMargin.holds giving_meets6 giving_keeps6
        (Nat.le_trans (by decide : 12 ≤ 20) xLow) xHigh 1
      have xEq : (pacedCourse Pace.lassoStep need (kids 1) giving use (switchTo (0, 2))
          (fun _ => false) impSafeStart (t + 1)).1.2.2 =
          RegimeMargin.step giving 6
            (pacedCourse Pace.lassoStep need (kids 1) giving use (switchTo (0, 2))
              (fun _ => false) impSafeStart t).1.2.2 := by
        rw [stNext]
        show RegimeMargin.step giving (LineOnAStock.taken use _) _ = _
        rw [wEq]
        rfl
      have xLow' : 20 ≤ (pacedCourse Pace.lassoStep need (kids 1) giving use (switchTo (0, 2))
          (fun _ => false) impSafeStart (t + 1)).1.2.2 := by
        rw [xEq]
        exact Nat.le_trans xLow bounds.1
      have xHigh' : (pacedCourse Pace.lassoStep need (kids 1) giving use (switchTo (0, 2))
          (fun _ => false) impSafeStart (t + 1)).1.2.2 ≤ 60 := by
        rw [xEq]
        exact bounds.2
      exact ⟨rNext, wNext, xLow', xHigh'⟩
  intro t
  rcases inv t with ⟨_, wEq, xLow, xHigh⟩
  refine ⟨xLow, xHigh, ⟨.safe, ?_, Nat.le_trans (by decide) xLow⟩⟩
  rw [wEq]
  exact .head _

/-! ### Feasibility witness (`N = 2`, `M = 0`, `L = 3`, `x₀ = 52`) -/

def feasH (s : StockState Nat UnitKind) (g : Nat × Nat) : Nat × Nat :=
  cond (decide (g.1 = 0) && decide (g.2 = 1)) (0, 1)
    (cond (decide (s.1 = 1)) (0, 1) g)

def feasStart : StockState Nat UnitKind × (Nat × Nat) := ((0, ([.init], 52)), (1, 0))

def feasRun (t : Nat) : StockState Nat UnitKind × (Nat × Nat) :=
  pacedCourse Pace.lassoStep need (kids 0) giving use feasH (periodReads 2) feasStart t

theorem feas_trace_values :
    (feasRun 0).1.2.2 = 52 ∧
    (feasRun 1).1.2.2 = 50 ∧
    (feasRun 2).1.2.2 = 48 ∧
    (feasRun 3).1.2 = ([.bad], 46) ∧
    (feasRun 3).2 = (0, 1) ∧
    (feasRun 4).1.2 = ([.safe], 44) ∧
    (feasRun 5).1.2.2 = 46 ∧
    (feasRun 6).1.2.2 = 48 :=
  ⟨rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl⟩

private theorem feas_safeEntry :
    LineOnAStock.taken use
      (LineOnAStock.allKids (kids 0 (0, 1)) (LineOnAStock.generation (kids 0 (1, 0)) 3 [.init])) = 6 := rfl

private theorem feas_safeClose_eq : ∀ w : List UnitKind, LineOnAStock.taken use w = 6 →
    LineOnAStock.taken use (LineOnAStock.allKids (kids 0 (0, 1)) w) = 6
  | [], h => absurd h (by decide)
  | [u], h => match u with
    | .init => absurd h (by decide)
    | .bad => absurd h (by decide)
    | .safe => rfl
  | u :: v :: ws, h => by
    have hu : 6 ≤ use u := match u with | .init => by decide | .bad => by decide | .safe => by decide
    have hv : 6 ≤ use v := match v with | .init => by decide | .bad => by decide | .safe => by decide
    have hGe12 : 12 ≤ LineOnAStock.taken use (u :: v :: ws) :=
      Nat.add_le_add hu (Nat.le_trans hv (Nat.le_add_right (use v) _))
    exact absurd (Nat.le_trans hGe12 (Nat.le_of_eq h)) (by decide)

private theorem feas_safeClose_le : ∀ w : List UnitKind, LineOnAStock.taken use w ≤ 6 →
    LineOnAStock.taken use (LineOnAStock.allKids (kids 0 (0, 1)) w) ≤ 6
  | [], _ => Nat.zero_le 6
  | [u], _ => match u with
    | .init => Nat.le_refl 6
    | .bad => Nat.le_refl 6
    | .safe => Nat.le_refl 6
  | u :: v :: ws, h => by
    have hu : 6 ≤ use u := match u with | .init => by decide | .bad => by decide | .safe => by decide
    have hv : 6 ≤ use v := match v with | .init => by decide | .bad => by decide | .safe => by decide
    have hGe12 : 12 ≤ LineOnAStock.taken use (u :: v :: ws) :=
      Nat.add_le_add hu (Nat.le_trans hv (Nat.le_add_right (use v) _))
    exact absurd (Nat.le_trans hGe12 h) (by decide)

theorem feas_witness :
    Pace.StretchFixes Bool 2 3 ∧
      ∀ t, 4 ≤ t →
        12 ≤ (feasRun t).1.2.2 ∧
        (feasRun t).1.2.2 ≤ 60 ∧
        LineOnAStock.Goes need (feasRun t).1.2 :=
  pace_margin_feasibility_window (N := 2) (L := 3) (H₁ := 10) (H₂ := 6) (y₂ := 6) (hi := 60)
    (σ := periodSigma 2) (reads := periodReads 2) (h := feasH)
    Bool.false_ne_true rfl rfl (periodSigma_strict 2) (periodReads_cadence 2) (by decide)
    (by decide) giving_keeps0 giving_short6 giving_meets6 giving_keeps6 (by decide)
    (fun _ => ⟨Nat.succ_pos 0, (by decide : 1 ≤ 6 + 6)⟩) (List.cons_ne_nil _ _)
    (fun g _ => by
      show cond (decide (g.1 = 0) && decide (g.2 = 1)) [UnitKind.safe] [UnitKind.bad] ≠ []
      cases decide (g.1 = 0) && decide (g.2 = 1) <;> exact List.cons_ne_nil _ _)
    (Nat.le_of_eq feas_safeEntry) feas_safeClose_le
    (upper_draw_10 0 (1, 0) 52 4) (by decide) rfl (fun _ => rfl)

end SandwichWitness

end PacedStock
end Becoming
