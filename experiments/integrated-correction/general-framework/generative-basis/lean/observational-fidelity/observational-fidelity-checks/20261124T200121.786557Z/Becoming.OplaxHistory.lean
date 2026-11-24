import Becoming.CausalAbstraction
import Becoming.OpenComposition
import Becoming.PolyComposition
import Becoming.CoreHelpers
import Becoming.GrammarLaws
import Becoming.RelSpan

/-!
# Oplax History Comparisons, Exact Beck–Chevalley Criteria, and Guarded Interchange (`Becoming.OplaxHistory`)

AI-written (`Wave U6`, 24 November 2026). Every declaration compiles from Lean's prelude alone with
an empty axiom report (`0` axioms, `0` `propext`, `0` `Classical.choice`, `0` `Quot.sound`, `0`
`sorry`, `0` `private` declarations, `0` unnamed `instance`s, and `0` economic metaphors).

This module formalizes the oplax span semantics and observational distortion bridges of
`WenHeHua v9.0` inside `Becoming`'s `0`-axiom core and connects them to closed-loop viability,
causal abstraction, guarded double interchange, and serialized concurrent reconfiguration:

* **Part 1 — General Functor Oplax Span Comparison (`S1`, `S2`, `S5`, `formal/67 D1`):**
  Constructive relational spans `RelSpan`, pullback composition `compSpan`, functor comparison
  `chi : F(W ×_D V) → FW ×_{FD} FV`, endpoint preservation, naturality, unit/associativity
  coherence, universal all-finite-`n` binary bracketing coherence (`bracketTree_coherence_all_n`),
  functoriality of continuous-block macro refinement (`macro_refinement_functorial`), and two-layer
  explanation factorization (`chi_comp_functor`).
* **Part 2 — Same-Square Beck–Chevalley Equivalence (`S4`) & Dual Distortion Witnesses:**
  Exact equivalence between `chi` bijectivity (`IsBijective`), `F`-image pullback preservation, and
  fiberwise Beck–Chevalley bijectivity over all set families (`chi_bijective_iff_bc_all`), with an
  explicit empty-family vacuity trap (`bc_empty_family_trivial_counterexample`), plus constructive
  non-surjective emergence (`EmergentCrossSeamWitness`: `0 → 1` and `2 → 4`) and non-injective
  `C₂`-orbit relational collapse (`C2RelativeLossWitness`: `2 → 1` and `powTwo n → 1`).
* **Part 3 — Bridges into `Becoming` Closed-Loop Dynamics & Guarded Interchange:**
  Identification of `n`-step `Process`/`Trace` histories with iterated pullback chains
  (`trace_equiv_flatChain`), elimination of spurious macro histories under `ExactCausalAbs.Lifts` vs
  breakdown on `CausalGoodhartWitness`, `FiberViabilitySplit` refutation of macro soundness realized
  on a coupled 2-agent alignment system (`C2CoupledAlignmentWitness`), symmetric-monoidal
  coproduct distribution (`coprod_pullback_iso`, strong on `⊕` vs oplax on `⋆`), `BC`-guarded
  interchange upgrading, 3D concurrent reconfiguration guards bridged to
  `PolyComposition.SerialReconfigProcess`, and a `GrammarLaws.«像定后当且仅当同行»` bridge.

What is not shown: whether any empirical system satisfies exact lifting, `BC`, or disjoint
resource invariants (`AGENTS.md` Rule 2). No ethical premise or ranking occurs.
-/

namespace Becoming

namespace OplaxHistory

open Generative Assurance


-- Parts 0–2 (Bij, RelSpan, SpanFunctor, chi coherence, BC iff, Emergent/C2 witnesses) moved to `Becoming.RelSpan` (Wave 3).

/-! ## Part 3: Bridges into `Becoming` Closed-Loop Dynamics, Causal Abstraction, & Guarded Interchange -/

/-- A single transition step of `P : Process S A` packaged as witness of a span `S ← StepSpan P → S`. -/
structure ProcessStepWitness {S A : Type} (P : Process S A) where
  src : S
  act : A
  dst : S
  step : P.step src act dst

/-- Transition relation of `P : Process S A` as a relational span `S ← W → S`. -/
def processStepSpan {S A : Type} (P : Process S A) : RelSpan S S where
  W := ProcessStepWitness P
  left w := w.src
  right w := w.dst

/-- Time-homogeneous `n`-fold pullback chain of an endorelational span `H : RelSpan S S`
(zero index casts, exact `Trace` correspondence). -/
def constFlatSpan {S : Type} (H : RelSpan S S) : Nat → RelSpan S S
  | 0 => idSpan S
  | n + 1 => compSpan H (constFlatSpan H n)

/-- Canonical `n`-step `chi` on `constFlatSpan` under an object projection `F : SpanFunctor`. -/
def chiConstFlat (F : SpanFunctor) {S : Type} (H : RelSpan S S) :
    ∀ n : Nat, SpanHom (F.onSpan (constFlatSpan H n)) (constFlatSpan (F.onSpan H) n)
  | 0 =>
    { map := fun x => x
      left_eq := fun x => (F.map_id x).symm
      right_eq := fun x => (F.map_id x).symm }
  | n + 1 =>
    SpanHom.comp (compSpanHom (SpanHom.id (F.onSpan H)) (chiConstFlat F H n))
      (chi F H (constFlatSpan H n))

/-- Extract a concrete `Trace P` witness (`Prop`-valued) from any witness in
`(constFlatSpan (processStepSpan P) n).W`. -/
theorem flatSpanToTrace {S A : Type} (P : Process S A) :
    ∀ {n : Nat} (x : (constFlatSpan (processStepSpan P) n).W),
      ∃ w : List A, w.length = n ∧
        Trace P
          ((constFlatSpan (processStepSpan P) n).left x)
          w
          ((constFlatSpan (processStepSpan P) n).right x)
  | 0, s => ⟨[], rfl, .nil s⟩
  | n + 1, p => by
    obtain ⟨w, hw, htr⟩ := flatSpanToTrace P p.snd
    exact ⟨p.fst.act :: w, congrArg Nat.succ hw, .cons (p.mid ▸ p.fst.step) htr⟩

/-- Embed any `Trace P s w s'` with `w.length = n` into `(constFlatSpan (processStepSpan P) n).W`. -/
theorem traceToFlatSpan {S A : Type} {P : Process S A} :
    ∀ {n : Nat} {s s' : S} {w : List A}, w.length = n →
      Trace P s w s' →
      ∃ x : (constFlatSpan (processStepSpan P) n).W,
        (constFlatSpan (processStepSpan P) n).left x = s ∧
        (constFlatSpan (processStepSpan P) n).right x = s'
  | 0, s, _, [], _, tr =>
    ⟨s, rfl, trace_nil_iff.mp tr⟩
  | 0, _, _, _ :: _, hw, _ => absurd hw Nat.noConfusion
  | n + 1, s, s', a :: ws, hw, tr => by
    obtain ⟨m, hst, htail⟩ := trace_cons_iff.mp tr
    obtain ⟨rest, hl, hr⟩ := traceToFlatSpan (Nat.succ.inj hw) htail
    exact ⟨⟨⟨s, a, m, hst⟩, rest, hl.symm⟩, rfl, hr⟩

/-- **Exact `Trace`–`PullbackChain` Identification (`trace_equiv_flatChain`):**
Finite closed-loop trajectories of length `n` on `P : Process S A` correspond constructively to
iterated pullback witnesses in `constFlatSpan (processStepSpan P) n`. -/
theorem trace_equiv_flatChain {S A : Type} (P : Process S A) (n : Nat) (s s' : S) :
    (∃ x : (constFlatSpan (processStepSpan P) n).W,
      (constFlatSpan (processStepSpan P) n).left x = s ∧
      (constFlatSpan (processStepSpan P) n).right x = s') ↔
    (∃ w : List A, w.length = n ∧ Trace P s w s') := by
  constructor
  · intro ⟨x, hl, hr⟩
    obtain ⟨w, hw, tr⟩ := flatSpanToTrace P x
    exact ⟨w, hw, hl ▸ hr ▸ tr⟩
  · intro ⟨w, hw, tr⟩
    obtain ⟨x, hl, hr⟩ := traceToFlatSpan hw tr
    exact ⟨x, hl, hr⟩

/-- Constructive chain projection paired with its exact left/right endpoint invariants. -/
def exactAbsChainWithEnds {S A I Q B J : Type}
    {C₁ : CausalSystem S A I} {C₂ : CausalSystem Q B J}
    {π : S → Q} {φ : A → B} {ω : I → J}
    (abs : ExactCausalAbs C₁ C₂ π φ ω) (i : I) :
    ∀ (n : Nat) (x : (constFlatSpan (processStepSpan (C₁.proc i)) n).W),
      { y : (constFlatSpan (processStepSpan (C₂.proc (ω i))) n).W //
        (constFlatSpan (processStepSpan (C₂.proc (ω i))) n).left y =
          π ((constFlatSpan (processStepSpan (C₁.proc i)) n).left x) ∧
        (constFlatSpan (processStepSpan (C₂.proc (ω i))) n).right y =
          π ((constFlatSpan (processStepSpan (C₁.proc i)) n).right x) }
  | 0, x => ⟨π x, rfl, rfl⟩
  | n + 1, p =>
    let tail := exactAbsChainWithEnds abs i n p.snd
    ⟨⟨⟨π p.fst.src, φ p.fst.act, π p.fst.dst, abs.factors i _ _ _ p.fst.step⟩,
      tail.1, (congrArg π p.mid).trans tail.2.1.symm⟩,
     rfl, tail.2.2⟩

/-- Trace-level state-projection comparison induced by `ExactCausalAbs`: projects concrete
`n`-step trajectories to macro `n`-step trajectories. -/
def exactAbsChainMap {S A I Q B J : Type}
    {C₁ : CausalSystem S A I} {C₂ : CausalSystem Q B J}
    {π : S → Q} {φ : A → B} {ω : I → J}
    (abs : ExactCausalAbs C₁ C₂ π φ ω) (i : I) (n : Nat)
    (x : (constFlatSpan (processStepSpan (C₁.proc i)) n).W) :
    (constFlatSpan (processStepSpan (C₂.proc (ω i))) n).W :=
  (exactAbsChainWithEnds abs i n x).1

theorem exactAbsChainMap_endpoints {S A I Q B J : Type}
    {C₁ : CausalSystem S A I} {C₂ : CausalSystem Q B J}
    {π : S → Q} {φ : A → B} {ω : I → J}
    (abs : ExactCausalAbs C₁ C₂ π φ ω) (i : I) (n : Nat)
    (x : (constFlatSpan (processStepSpan (C₁.proc i)) n).W) :
    (constFlatSpan (processStepSpan (C₂.proc (ω i))) n).left (exactAbsChainMap abs i n x) =
      π ((constFlatSpan (processStepSpan (C₁.proc i)) n).left x) ∧
    (constFlatSpan (processStepSpan (C₂.proc (ω i))) n).right (exactAbsChainMap abs i n x) =
      π ((constFlatSpan (processStepSpan (C₁.proc i)) n).right x) :=
  (exactAbsChainWithEnds abs i n x).2

/-- Zero-axiom equality of `ProcessStepWitness`es from equal source, action, and target
(kernel proof irrelevance on `P.step : Prop`). -/
theorem ProcessStepWitness.ext {S A : Type} {P : Process S A}
    {w₁ w₂ : ProcessStepWitness P}
    (hs : w₁.src = w₂.src) (ha : w₁.act = w₂.act) (hd : w₁.dst = w₂.dst) :
    w₁ = w₂ := by
  cases w₁ with
  | mk s₁ a₁ d₁ st₁ =>
    cases w₂ with
    | mk s₂ a₂ d₂ st₂ =>
      change s₁ = s₂ at hs
      change a₁ = a₂ at ha
      change d₁ = d₂ at hd
      subst hs
      subst ha
      subst hd
      rfl

/-- **Full-Chain Lifting under `ExactCausalAbs.Lifts` (`exactCausal_lifts_implies_chain_lift`):**
Under the same hypotheses as `exactCausal_lifts_implies_chi_surjective`, every macro `n`-step
trajectory `y` rooted at `π s` lifts to a concrete `n`-step trajectory `x` rooted at `s` whose
projection `exactAbsChainMap abs i n x` equals `y` itself (matching every intermediate state and
action, not only endpoints). -/
theorem exactCausal_lifts_implies_chain_lift {S A I Q B J : Type}
    {C₁ : CausalSystem S A I} {C₂ : CausalSystem Q B J}
    {π : S → Q} {φ : A → B} {ω : I → J}
    (abs : ExactCausalAbs C₁ C₂ π φ ω) (lifts : abs.Lifts) (i : I) (n : Nat) :
    ∀ (s : S) (y : (constFlatSpan (processStepSpan (C₂.proc (ω i))) n).W),
      (constFlatSpan (processStepSpan (C₂.proc (ω i))) n).left y = π s →
      ∃ x : (constFlatSpan (processStepSpan (C₁.proc i)) n).W,
        (constFlatSpan (processStepSpan (C₁.proc i)) n).left x = s ∧
        exactAbsChainMap abs i n x = y := by
  induction n with
  | zero =>
    intro s y hy
    exact ⟨s, rfl, hy.symm⟩
  | succ m ih =>
    intro s y hy
    let hy0 : y.fst.src = π s := hy
    obtain ⟨a, m₁, hact, hstep₁, hm₁⟩ := lifts i s y.fst.act y.fst.dst (hy0 ▸ y.fst.step)
    have hySnd : (constFlatSpan (processStepSpan (C₂.proc (ω i))) m).left y.snd = π m₁ :=
      y.mid.symm.trans hm₁.symm
    obtain ⟨xTail, hxLeft, hxChain⟩ := ih m₁ y.snd hySnd
    refine ⟨⟨⟨s, a, m₁, hstep₁⟩, xTail, hxLeft.symm⟩, rfl, ?_⟩
    exact PullbackElem.ext (ProcessStepWitness.ext hy0.symm hact hm₁) hxChain

/-- **Endpoint Lifting Corollary (`exactCausal_lifts_implies_chi_surjective`):**
Corollary of `exactCausal_lifts_implies_chain_lift`: every rooted macro `n`-step trajectory from
`π s` lifts to a concrete trajectory with matching right-endpoint projection. -/
theorem exactCausal_lifts_implies_chi_surjective {S A I Q B J : Type}
    {C₁ : CausalSystem S A I} {C₂ : CausalSystem Q B J}
    {π : S → Q} {φ : A → B} {ω : I → J}
    (abs : ExactCausalAbs C₁ C₂ π φ ω) (lifts : abs.Lifts) (i : I) (n : Nat) :
    ∀ (s : S) (y : (constFlatSpan (processStepSpan (C₂.proc (ω i))) n).W),
      (constFlatSpan (processStepSpan (C₂.proc (ω i))) n).left y = π s →
      ∃ x : (constFlatSpan (processStepSpan (C₁.proc i)) n).W,
        (constFlatSpan (processStepSpan (C₁.proc i)) n).left x = s ∧
        (constFlatSpan (processStepSpan (C₂.proc (ω i))) n).right
          (exactAbsChainMap abs i n x) =
        (constFlatSpan (processStepSpan (C₂.proc (ω i))) n).right y := by
  intro s y hy
  obtain ⟨x, hxLeft, hxEq⟩ := exactCausal_lifts_implies_chain_lift abs lifts i n s y hy
  exact ⟨x, hxLeft, congrArg (constFlatSpan (processStepSpan (C₂.proc (ω i))) n).right hxEq⟩

/-- **Non-Surjective Macro History Counterexample on `CausalGoodhartWitness`:**
Under interventional `boost` (`true`), the macro proxy sustains `guardQ` forever from `π s₀ = .two`,
yielding a 3-step viable macro trace; yet NO concrete 3-step `micro` boost trace from `s₀` stays
viable (`micro_boost_proxy_collapses`), refuting surjectivity of viable-history abstraction. -/
theorem causalGoodhart_chi_non_surjective :
    ∃ (w : List Unit) (q₃ : CausalGoodhartWitness.Level),
      Trace (CausalGoodhartWitness.macroSys.proc true)
        (CausalGoodhartWitness.π CausalGoodhartWitness.s₀) w q₃ ∧
      CausalGoodhartWitness.guardQ q₃ ∧
      ¬ ∃ s₃, Trace (CausalGoodhartWitness.micro.proc true) CausalGoodhartWitness.s₀ w s₃ ∧
        CausalGoodhartWitness.guardQ (CausalGoodhartWitness.π s₃) := by
  obtain ⟨s₃, tr₃, hbadQ⟩ := CausalGoodhartWitness.micro_boost_proxy_collapses
  have hdet : ∀ s s', Trace (CausalGoodhartWitness.micro.proc true) CausalGoodhartWitness.s₀
      [(), (), ()] s → Trace (CausalGoodhartWitness.micro.proc true) CausalGoodhartWitness.s₀
      [(), (), ()] s' → s = s' := by
    intro s s' t₁ t₂
    match t₁, t₂ with
    | .cons h1 (.cons h2 (.cons h3 (.nil _))),
      .cons g1 (.cons g2 (.cons g3 (.nil _))) =>
      have h1' : _ = CausalGoodhartWitness.stepMicro true CausalGoodhartWitness.s₀ := h1
      have g1' : _ = CausalGoodhartWitness.stepMicro true CausalGoodhartWitness.s₀ := g1
      have e1 : _ = _ := h1'.trans g1'.symm
      rw [e1] at h2
      have h2' : _ = _ := h2
      have g2' : _ = _ := g2
      have e2 : _ = _ := h2'.trans g2'.symm
      rw [e2] at h3
      have h3' : _ = _ := h3
      have g3' : _ = _ := g3
      exact h3'.trans g3'.symm
  have hk := CausalGoodhartWitness.macro_boost_kernel.1
  have hq3 : CausalGoodhartWitness.guardQ .three := fun e => CausalGoodhartWitness.Level.noConfusion e
  have trQ : Trace (CausalGoodhartWitness.macroSys.proc true)
      (CausalGoodhartWitness.π CausalGoodhartWitness.s₀) [(), (), ()] .three :=
    .cons rfl (.cons rfl (.cons rfl (.nil _)))
  refine ⟨[(), (), ()], .three, trQ, hq3, ?_⟩
  intro ⟨s', tr', hgood'⟩
  have hseq := hdet s' s₃ tr' tr₃
  rw [hseq] at hgood'
  exact hbadQ hgood'

/-! ### Non-Injective `FiberViabilitySplit` & Coupled 2-Agent Alignment Witness -/

/-- **Fiber Viability Split:** Two microscopic histories collapse under `chi : U → V` yet disagree on
a viability kernel `K : U → Prop`. -/
def FiberViabilitySplit {U V : Type} (chiMap : U → V) (K : U → Prop) : Prop :=
  ∃ u₁ u₂ : U, chiMap u₁ = chiMap u₂ ∧ K u₁ ∧ ¬ K u₂

/-- Any macro viability predicate `Kq : V → Prop` over a `FiberViabilitySplit` either misses the
viable history `u₁` (`¬ (K u₁ → Kq (chi u₁))`) or certifies the collapsing one `u₂` (`¬ (Kq (chi u₂) → K u₂)`). -/
theorem fiberSplit_refutes_macro_viability_soundness {U V : Type}
    {chiMap : U → V} {K : U → Prop}
    (hsplit : FiberViabilitySplit chiMap K) (Kq : V → Prop) :
    ¬ ((∀ u, K u → Kq (chiMap u)) ∧ (∀ u, Kq (chiMap u) → K u)) := by
  intro ⟨hcomp, hsound⟩
  obtain ⟨u₁, u₂, heq, hk1, hnk2⟩ := hsplit
  exact hnk2 (hsound u₂ (heq ▸ hcomp u₁ hk1))

/- **Coupled 2-Agent `C₂` Alignment Witness (`C2CoupledAlignmentWitness`):**
Two boolean agents share a substrate stock `z : Nat` (`State := (Bool × Bool) × Nat`).
In-phase policies (`b₁ == b₂`) match substrate renewal (`z ↦ z`), keeping `1 ≤ z` eternally in
`Viability.Kernel`; anti-phase policies (`b₁ != b₂`) overdraw (`z ↦ z - 1`), crashing at step 1!
Component-wise `C₂` symmetry (`(b₁, b₂) ↦ ()`) erases relative phase (`FiberViabilitySplit` holds). -/
namespace C2CoupledAlignmentWitness

def CoupledState : Type := (Bool × Bool) × Nat

def stepFn (s : CoupledState) (_ : Unit) : CoupledState :=
  ((s.1.1, s.1.2), if s.1.1 == s.1.2 then s.2 else s.2 - 1)

def proc : Process CoupledState Unit :=
  Assurance.ofMap stepFn

def guardS (s : CoupledState) : Prop :=
  1 ≤ s.2

/-- Component-wise `C₂`-orbit projection erases individual flip orientation, keeping only `stock`. -/
def c2ProjMicro (s : CoupledState) : Nat :=
  s.2

def uInPhase : CoupledState := ((true, true), 1)
def uAntiPhase : CoupledState := ((true, false), 1)

theorem uInPhase_kernel : Viability.Kernel proc guardS uInPhase := by
  let cert : Viability.Certificate proc guardS (fun s => s = uInPhase) :=
    ⟨fun s hs => hs ▸ Nat.le_refl 1,
     fun s _ s' hstep hs => by
       have heq : s' = stepFn s () := hstep
       rw [hs] at heq
       exact heq⟩
  exact cert.kernel rfl

theorem uAntiPhase_not_kernel : ¬ Viability.Kernel proc guardS uAntiPhase := by
  intro hk
  have hr : Reach proc uAntiPhase ((true, false), 0) := ⟨[()], .cons rfl (.nil _)⟩
  exact Nat.not_succ_le_zero 0 (hk ((true, false), 0) hr)

/-- **Witnessed `FiberViabilitySplit` on Coupled 2-Agent System (`2 → 1` alignment collapse):**
`(true, true, 1)` and `(true, false, 1)` have identical component-wise projections `c2ProjMicro = 1`,
yet one stays eternally viable while the other immediately depletes! -/
theorem c2_coupled_fiber_split :
    FiberViabilitySplit c2ProjMicro (Viability.Kernel proc guardS) :=
  ⟨uInPhase, uAntiPhase, rfl, uInPhase_kernel, uAntiPhase_not_kernel⟩

theorem c2_coupled_no_macro_soundness (Kq : Nat → Prop) :
    ¬ ((∀ s, Viability.Kernel proc guardS s → Kq (c2ProjMicro s)) ∧
       (∀ s, Kq (c2ProjMicro s) → Viability.Kernel proc guardS s)) :=
  fiberSplit_refutes_macro_viability_soundness c2_coupled_fiber_split Kq

end C2CoupledAlignmentWitness

/-! ### Symmetric Monoidal Coproduct Distribution (`⊕`) & `BC`-Guarded Interchange (`v9 formal/66 §B1–B4`) -/

/-- Labeled disjoint union of two relational spans (`H ⊕ H'`). -/
def coprodSpan {A A' B B' : Type} (H : RelSpan A B) (H' : RelSpan A' B') :
    RelSpan (Sum A A') (Sum B B') where
  W := Sum H.W H'.W
  left := Sum.elim (fun w => .inl (H.left w)) (fun w => .inr (H'.left w))
  right := Sum.elim (fun w => .inl (H.right w)) (fun w => .inr (H'.right w))

/-- Constructive distributivity isomorphism (`v9 formal/66 B1–B2`):
`(H ⋆ K) ⊕ (H' ⋆ K') ≃ (H ⊕ H') ⋆ (K ⊕ K')`. -/
def coprod_pullback_iso {A D C A' D' C' : Type}
    (H : RelSpan A D) (K : RelSpan D C) (H' : RelSpan A' D') (K' : RelSpan D' C') :
    Bij (Sum (PullbackElem H.right K.left) (PullbackElem H'.right K'.left))
      (PullbackElem (coprodSpan H H').right (coprodSpan K K').left) where
  toFun
    | .inl p => ⟨.inl p.fst, .inl p.snd, congrArg Sum.inl p.mid⟩
    | .inr q => ⟨.inr q.fst, .inr q.snd, congrArg Sum.inr q.mid⟩
  invFun
    | ⟨.inl w, .inl v, hm⟩ => .inl ⟨w, v, Sum.inl.inj hm⟩
    | ⟨.inr w, .inr v, hm⟩ => .inr ⟨w, v, Sum.inr.inj hm⟩
    | ⟨.inl _, .inr _, hm⟩ => False.elim (by cases hm)
    | ⟨.inr _, .inl _, hm⟩ => False.elim (by cases hm)
  left_inv
    | .inl _ => rfl
    | .inr _ => rfl
  right_inv p := by
    obtain ⟨a, b, m⟩ := p
    cases a <;> cases b
    · rfl
    · exact False.elim (by cases m)
    · exact False.elim (by cases m)
    · rfl

/-- Functorial `⊕`-compatibility (`v9 formal/66 B3–B4`):
For any functor `F` preserving finite `Sum` via `qSum : F(X ⊕ Y) ≃ FX ⊕ FY` respecting injections,
`F` is **strong on disjoint parallel `⊕`** while **oplax on sequential time `⋆`**, and the two
comparisons agree on `(W ⊕ W') ×_{D ⊕ D'} (V ⊕ V')`. -/
structure SumPreservingFunctor where
  toFunctor : SpanFunctor
  sumBij : ∀ (X Y : Type), Bij (toFunctor.obj (Sum X Y)) (Sum (toFunctor.obj X) (toFunctor.obj Y))
  sum_inl : ∀ {X Y : Type} (u : toFunctor.obj X),
    (sumBij X Y).toFun (toFunctor.map Sum.inl u) = Sum.inl u
  sum_inr : ∀ {X Y : Type} (v : toFunctor.obj Y),
    (sumBij X Y).toFun (toFunctor.map Sum.inr v) = Sum.inr v

/-- **Strong-`⊕` vs Oplax-`⋆` Compatibility Theorem (`v9 formal/66 B4`):**
Evaluating `chi` on a copair `(H ⊕ H') ⋆ (K ⊕ K')` after canonical injection agrees projectionwise
across `sumBij` with injecting each component's `chi` on `(H ⋆ K)` and `(H' ⋆ K')`. -/
theorem coprod_strong_vs_time_oplax (S : SumPreservingFunctor)
    {A D C A' D' C' : Type}
    (H : RelSpan A D) (K : RelSpan D C) (H' : RelSpan A' D') (K' : RelSpan D' C') :
    (∀ u : S.toFunctor.obj (PullbackElem H.right K.left),
      (S.sumBij H.W H'.W).toFun
        ((chi S.toFunctor (coprodSpan H H') (coprodSpan K K')).map
          (S.toFunctor.map (coprod_pullback_iso H K H' K').toFun
            (S.toFunctor.map Sum.inl u))).fst =
        Sum.inl ((chi S.toFunctor H K).map u).fst ∧
      (S.sumBij K.W K'.W).toFun
        ((chi S.toFunctor (coprodSpan H H') (coprodSpan K K')).map
          (S.toFunctor.map (coprod_pullback_iso H K H' K').toFun
            (S.toFunctor.map Sum.inl u))).snd =
        Sum.inl ((chi S.toFunctor H K).map u).snd) ∧
    (∀ v : S.toFunctor.obj (PullbackElem H'.right K'.left),
      (S.sumBij H.W H'.W).toFun
        ((chi S.toFunctor (coprodSpan H H') (coprodSpan K K')).map
          (S.toFunctor.map (coprod_pullback_iso H K H' K').toFun
            (S.toFunctor.map Sum.inr v))).fst =
        Sum.inr ((chi S.toFunctor H' K').map v).fst ∧
      (S.sumBij K.W K'.W).toFun
        ((chi S.toFunctor (coprodSpan H H') (coprodSpan K K')).map
          (S.toFunctor.map (coprod_pullback_iso H K H' K').toFun
            (S.toFunctor.map Sum.inr v))).snd =
        Sum.inr ((chi S.toFunctor H' K').map v).snd) := by
  let iso := (coprod_pullback_iso H K H' K').toFun
  let F := S.toFunctor
  constructor
  · intro u
    constructor
    · have h1 : F.map (@PullbackElem.fst _ _ _ (coprodSpan H H').right (coprodSpan K K').left)
          (F.map iso (F.map (@Sum.inl _ (PullbackElem H'.right K'.left)) u)) =
          F.map (fun z => (iso (Sum.inl z)).fst) u :=
        (F.map_comp _ iso _).symm.trans (F.map_comp _ Sum.inl u).symm
      have h2 : F.map (fun z : PullbackElem H.right K.left => (iso (Sum.inl z)).fst) u =
          F.map (fun z : PullbackElem H.right K.left => (Sum.inl z.fst : Sum H.W H'.W)) u :=
        F.map_congr (fun _ => rfl) u
      have h3 : F.map (fun z : PullbackElem H.right K.left => (Sum.inl z.fst : Sum H.W H'.W)) u =
          F.map (@Sum.inl H.W H'.W) (F.map PullbackElem.fst u) :=
        F.map_comp (@Sum.inl H.W H'.W) PullbackElem.fst u
      exact (congrArg (S.sumBij H.W H'.W).toFun (h1.trans (h2.trans h3))).trans
        (S.sum_inl (F.map PullbackElem.fst u))
    · have h1 : F.map (@PullbackElem.snd _ _ _ (coprodSpan H H').right (coprodSpan K K').left)
          (F.map iso (F.map (@Sum.inl _ (PullbackElem H'.right K'.left)) u)) =
          F.map (fun z => (iso (Sum.inl z)).snd) u :=
        (F.map_comp _ iso _).symm.trans (F.map_comp _ Sum.inl u).symm
      have h2 : F.map (fun z : PullbackElem H.right K.left => (iso (Sum.inl z)).snd) u =
          F.map (fun z : PullbackElem H.right K.left => (Sum.inl z.snd : Sum K.W K'.W)) u :=
        F.map_congr (fun _ => rfl) u
      have h3 : F.map (fun z : PullbackElem H.right K.left => (Sum.inl z.snd : Sum K.W K'.W)) u =
          F.map (@Sum.inl K.W K'.W) (F.map PullbackElem.snd u) :=
        F.map_comp (@Sum.inl K.W K'.W) PullbackElem.snd u
      exact (congrArg (S.sumBij K.W K'.W).toFun (h1.trans (h2.trans h3))).trans
        (S.sum_inl (F.map PullbackElem.snd u))
  · intro v
    constructor
    · have h1 : F.map (@PullbackElem.fst _ _ _ (coprodSpan H H').right (coprodSpan K K').left)
          (F.map iso (F.map (@Sum.inr (PullbackElem H.right K.left) _) v)) =
          F.map (fun z => (iso (Sum.inr z)).fst) v :=
        (F.map_comp _ iso _).symm.trans (F.map_comp _ Sum.inr v).symm
      have h2 : F.map (fun z : PullbackElem H'.right K'.left => (iso (Sum.inr z)).fst) v =
          F.map (fun z : PullbackElem H'.right K'.left => (Sum.inr z.fst : Sum H.W H'.W)) v :=
        F.map_congr (fun _ => rfl) v
      have h3 : F.map (fun z : PullbackElem H'.right K'.left => (Sum.inr z.fst : Sum H.W H'.W)) v =
          F.map (@Sum.inr H.W H'.W) (F.map PullbackElem.fst v) :=
        F.map_comp (@Sum.inr H.W H'.W) PullbackElem.fst v
      exact (congrArg (S.sumBij H.W H'.W).toFun (h1.trans (h2.trans h3))).trans
        (S.sum_inr (F.map PullbackElem.fst v))
    · have h1 : F.map (@PullbackElem.snd _ _ _ (coprodSpan H H').right (coprodSpan K K').left)
          (F.map iso (F.map (@Sum.inr (PullbackElem H.right K.left) _) v)) =
          F.map (fun z => (iso (Sum.inr z)).snd) v :=
        (F.map_comp _ iso _).symm.trans (F.map_comp _ Sum.inr v).symm
      have h2 : F.map (fun z : PullbackElem H'.right K'.left => (iso (Sum.inr z)).snd) v =
          F.map (fun z : PullbackElem H'.right K'.left => (Sum.inr z.snd : Sum K.W K'.W)) v :=
        F.map_congr (fun _ => rfl) v
      have h3 : F.map (fun z : PullbackElem H'.right K'.left => (Sum.inr z.snd : Sum K.W K'.W)) v =
          F.map (@Sum.inr K.W K'.W) (F.map PullbackElem.snd v) :=
        F.map_comp (@Sum.inr K.W K'.W) PullbackElem.snd v
      exact (congrArg (S.sumBij K.W K'.W).toFun (h1.trans (h2.trans h3))).trans
        (S.sum_inr (F.map PullbackElem.snd v))

/-! ### Finite-Presentation Rigidity for `SumPreservingFunctor` & Non-Sum `SpanFunctor` Witness -/

/-- Constructive finite presentation of a small carrier `X : Type`. -/
inductive FinPres : Type → Type 1 where
  | empty : FinPres Empty
  | unit : FinPres Unit
  | sum {X Y : Type} : FinPres X → FinPres Y → FinPres (Sum X Y)
  | bij {X Y : Type} : Bij X Y → FinPres X → FinPres Y

/-- Any `SumPreservingFunctor` maps `Empty` to an empty type (`0` axioms). -/
theorem sumPreserving_empty_isEmpty (S : SumPreservingFunctor) (u : S.toFunctor.obj Empty) : False := by
  have hmap : S.toFunctor.map (@Sum.inl Empty Empty) u = S.toFunctor.map (@Sum.inr Empty Empty) u :=
    S.toFunctor.map_congr (fun e => Empty.elim e) u
  have hinl := S.sum_inl (X := Empty) (Y := Empty) u
  have hinr := S.sum_inr (X := Empty) (Y := Empty) u
  have hsum : (Sum.inl u : Sum (S.toFunctor.obj Empty) (S.toFunctor.obj Empty)) = Sum.inr u :=
    hinl.symm.trans ((congrArg (S.sumBij Empty Empty).toFun hmap).trans hinr)
  nomatch hsum

/-- Canonical natural map `X × F(Unit) → F(X)` sending `(x, t)` to `F(fun _ => x)(t)`. -/
def prodUnitToF (F : SpanFunctor) (X : Type) : X × F.obj Unit → F.obj X :=
  fun p => F.map (fun _ => p.1) p.2

/-- Naturality of `prodUnitToF` along every `g : X → Y`. -/
theorem prodUnitToF_natural (F : SpanFunctor) {X Y : Type} (g : X → Y) (x : X) (t : F.obj Unit) :
    F.map g (prodUnitToF F X (x, t)) = prodUnitToF F Y (g x, t) :=
  (F.map_comp g (fun _ => x) t).symm

/-- Constructive bijection `X × S.toFunctor.obj Unit ≃ S.toFunctor.obj X` on any `FinPres X`
whose forward map is pointwise equal to `prodUnitToF S.toFunctor X`. -/
def prodUnitBijOfFinPres (S : SumPreservingFunctor) :
    {X : Type} → FinPres X →
      { b : Bij (X × S.toFunctor.obj Unit) (S.toFunctor.obj X) //
        ∀ p, b.toFun p = prodUnitToF S.toFunctor X p }
  | _, .empty =>
    ⟨{ toFun := fun p => Empty.elim p.1
       invFun := fun u => False.elim (sumPreserving_empty_isEmpty S u)
       left_inv := fun p => Empty.elim p.1
       right_inv := fun u => False.elim (sumPreserving_empty_isEmpty S u) },
     fun p => Empty.elim p.1⟩
  | _, .unit =>
    ⟨{ toFun := prodUnitToF S.toFunctor Unit
       invFun := fun t => ((), t)
       left_inv := fun (u, t) => by
         cases u
         show ((), S.toFunctor.map (fun _ : Unit => ()) t) = ((), t)
         exact congrArg ((), ·)
           ((S.toFunctor.map_congr (fun a => by cases a; rfl) t).trans (S.toFunctor.map_id t))
       right_inv := fun t =>
         (S.toFunctor.map_congr (fun a => by cases a; rfl) t).trans (S.toFunctor.map_id t) },
     fun _ => rfl⟩
  | _, .sum (X := X) (Y := Y) px py => by
    let ihX := prodUnitBijOfFinPres S px
    let ihY := prodUnitBijOfFinPres S py
    let T := S.toFunctor.obj Unit
    let dist : Bij (Sum X Y × T) (Sum (X × T) (Y × T)) :=
      { toFun := fun
          | (.inl x, t) => .inl (x, t)
          | (.inr y, t) => .inr (y, t)
        invFun := fun
          | .inl (x, t) => (.inl x, t)
          | .inr (y, t) => (.inr y, t)
        left_inv := fun
          | (.inl _, _) => rfl
          | (.inr _, _) => rfl
        right_inv := fun
          | .inl (_, _) => rfl
          | .inr (_, _) => rfl }
    let sumMap : Bij (Sum (X × T) (Y × T)) (Sum (S.toFunctor.obj X) (S.toFunctor.obj Y)) :=
      { toFun := fun
          | .inl p => .inl (ihX.1.toFun p)
          | .inr q => .inr (ihY.1.toFun q)
        invFun := fun
          | .inl u => .inl (ihX.1.invFun u)
          | .inr v => .inr (ihY.1.invFun v)
        left_inv := fun
          | .inl p => congrArg Sum.inl (ihX.1.left_inv p)
          | .inr q => congrArg Sum.inr (ihY.1.left_inv q)
        right_inv := fun
          | .inl u => congrArg Sum.inl (ihX.1.right_inv u)
          | .inr v => congrArg Sum.inr (ihY.1.right_inv v) }
    let b := Bij.trans dist (Bij.trans sumMap (S.sumBij X Y).symm)
    refine ⟨b, fun p => ?_⟩
    rcases p with ⟨x | y, t⟩
    · change (S.sumBij X Y).invFun (Sum.inl (ihX.1.toFun (x, t))) =
        S.toFunctor.map (fun _ => Sum.inl x) t
      have hx : ihX.1.toFun (x, t) = S.toFunctor.map (fun _ => x) t := ihX.2 (x, t)
      rw [hx]
      have hleft := (S.sumBij X Y).left_inv (S.toFunctor.map Sum.inl (S.toFunctor.map (fun _ => x) t))
      have hinl := congrArg (S.sumBij X Y).invFun (S.sum_inl (X := X) (Y := Y) (S.toFunctor.map (fun _ => x) t))
      have hcomp := (S.toFunctor.map_comp (Sum.inl : X → X ⊕ Y) (fun _ : Unit => x) t).symm
      exact (hinl.symm.trans hleft).trans hcomp
    · change (S.sumBij X Y).invFun (Sum.inr (ihY.1.toFun (y, t))) =
        S.toFunctor.map (fun _ => Sum.inr y) t
      have hy : ihY.1.toFun (y, t) = S.toFunctor.map (fun _ => y) t := ihY.2 (y, t)
      rw [hy]
      have hleft := (S.sumBij X Y).left_inv (S.toFunctor.map Sum.inr (S.toFunctor.map (fun _ => y) t))
      have hinr := congrArg (S.sumBij X Y).invFun (S.sum_inr (X := X) (Y := Y) (S.toFunctor.map (fun _ => y) t))
      have hcomp := (S.toFunctor.map_comp (Sum.inr : Y → X ⊕ Y) (fun _ : Unit => y) t).symm
      exact (hinr.symm.trans hleft).trans hcomp
  | _, .bij (X := X) (Y := Y) e px => by
    let ihX := prodUnitBijOfFinPres S px
    let T := S.toFunctor.obj Unit
    let onProd : Bij (Y × T) (X × T) :=
      { toFun := fun p => (e.invFun p.1, p.2)
        invFun := fun q => (e.toFun q.1, q.2)
        left_inv := fun (y, t) => congrArg (·, t) (e.right_inv y)
        right_inv := fun (x, t) => congrArg (·, t) (e.left_inv x) }
    let onObj : Bij (S.toFunctor.obj X) (S.toFunctor.obj Y) :=
      { toFun := S.toFunctor.map e.toFun
        invFun := S.toFunctor.map e.invFun
        left_inv := fun u =>
          ((S.toFunctor.map_comp e.invFun e.toFun u).symm).trans
            ((S.toFunctor.map_congr e.left_inv u).trans (S.toFunctor.map_id u))
        right_inv := fun v =>
          ((S.toFunctor.map_comp e.toFun e.invFun v).symm).trans
            ((S.toFunctor.map_congr e.right_inv v).trans (S.toFunctor.map_id v)) }
    let b := Bij.trans onProd (Bij.trans ihX.1 onObj)
    refine ⟨b, fun (y, t) => ?_⟩
    change S.toFunctor.map e.toFun (ihX.1.toFun (e.invFun y, t)) = S.toFunctor.map (fun _ => y) t
    rw [ihX.2 (e.invFun y, t)]
    exact (S.toFunctor.map_comp e.toFun (fun _ => e.invFun y) t).symm.trans
      (S.toFunctor.map_congr (fun _ => e.right_inv y) t)

/-- Pointwise bijectivity of `prodUnitToF` for any `SumPreservingFunctor` on a `FinPres` carrier. -/
theorem prodUnitToF_isBijective (S : SumPreservingFunctor) {X : Type} (px : FinPres X) :
    IsBijective (prodUnitToF S.toFunctor X) := by
  let b := prodUnitBijOfFinPres S px
  have hb := isBijective_of_bij b.1
  refine ⟨fun p₁ p₂ eq => hb.1 p₁ p₂ ((b.2 p₁).trans (eq.trans (b.2 p₂).symm)),
          fun u => ?_⟩
  obtain ⟨p, hp⟩ := hb.2 u
  exact ⟨p, (b.2 p).symm.trans hp⟩

/-- **Finite-Presentation Rigidity (`sumPreserving_finPres_chi_bijective`):**
Any `SumPreservingFunctor` forces canonical `chi` bijectivity whenever `H.W`, `K.W`, the middle
carrier `D`, and `PullbackElem H.right K.left` admit explicit finite presentations `FinPres`,
explaining why guarded oplax assembly must accept arbitrary `SpanFunctor`s rather than
`SumPreservingFunctor`s. -/
theorem sumPreserving_finPres_chi_bijective (S : SumPreservingFunctor)
    {A D C : Type} (H : RelSpan A D) (K : RelSpan D C)
    (pW : FinPres H.W) (pV : FinPres K.W) (pD : FinPres D)
    (pPB : FinPres (PullbackElem H.right K.left)) :
    IsBijective (chi S.toFunctor H K).map := by
  let F := S.toFunctor
  have bW := prodUnitToF_isBijective S pW
  have bV := prodUnitToF_isBijective S pV
  have bD := prodUnitToF_isBijective S pD
  have bPB := prodUnitToF_isBijective S pPB
  constructor
  · intro u₁ u₂ heq
    obtain ⟨⟨p₁, t₁⟩, hu₁⟩ := bPB.2 u₁
    obtain ⟨⟨p₂, t₂⟩, hu₂⟩ := bPB.2 u₂
    have hFst : F.map PullbackElem.fst u₁ = F.map PullbackElem.fst u₂ := congrArg PullbackElem.fst heq
    have hSnd : F.map PullbackElem.snd u₁ = F.map PullbackElem.snd u₂ := congrArg PullbackElem.snd heq
    have hFst' : prodUnitToF F H.W (p₁.fst, t₁) = prodUnitToF F H.W (p₂.fst, t₂) := by
      have e1 : F.map PullbackElem.fst u₁ = prodUnitToF F H.W (p₁.fst, t₁) :=
        (congrArg (F.map PullbackElem.fst) hu₁.symm).trans (prodUnitToF_natural F PullbackElem.fst p₁ t₁)
      have e2 : F.map PullbackElem.fst u₂ = prodUnitToF F H.W (p₂.fst, t₂) :=
        (congrArg (F.map PullbackElem.fst) hu₂.symm).trans (prodUnitToF_natural F PullbackElem.fst p₂ t₂)
      exact e1.symm.trans (hFst.trans e2)
    have hSnd' : prodUnitToF F K.W (p₁.snd, t₁) = prodUnitToF F K.W (p₂.snd, t₂) := by
      have e1 : F.map PullbackElem.snd u₁ = prodUnitToF F K.W (p₁.snd, t₁) :=
        (congrArg (F.map PullbackElem.snd) hu₁.symm).trans (prodUnitToF_natural F PullbackElem.snd p₁ t₁)
      have e2 : F.map PullbackElem.snd u₂ = prodUnitToF F K.W (p₂.snd, t₂) :=
        (congrArg (F.map PullbackElem.snd) hu₂.symm).trans (prodUnitToF_natural F PullbackElem.snd p₂ t₂)
      exact e1.symm.trans (hSnd.trans e2)
    have hEqW := bW.1 (p₁.fst, t₁) (p₂.fst, t₂) hFst'
    have hEqV := bV.1 (p₁.snd, t₁) (p₂.snd, t₂) hSnd'
    have hp : p₁ = p₂ := PullbackElem.ext (congrArg Prod.fst hEqW) (congrArg Prod.fst hEqV)
    have ht : t₁ = t₂ := congrArg Prod.snd hEqW
    subst hp
    subst ht
    exact hu₁.symm.trans hu₂
  · intro q
    obtain ⟨⟨w, t₁⟩, hw⟩ := bW.2 q.fst
    obtain ⟨⟨v, t₂⟩, hv⟩ := bV.2 q.snd
    have hMidD : prodUnitToF F D (H.right w, t₁) = prodUnitToF F D (K.left v, t₂) := by
      have lhs := (prodUnitToF_natural F H.right w t₁).symm.trans (congrArg (F.map H.right) hw)
      have rhs := (prodUnitToF_natural F K.left v t₂).symm.trans (congrArg (F.map K.left) hv)
      exact lhs.trans (q.mid.trans rhs.symm)
    have hPairD := bD.1 (H.right w, t₁) (K.left v, t₂) hMidD
    have hMid : H.right w = K.left v := congrArg Prod.fst hPairD
    have ht : t₁ = t₂ := congrArg Prod.snd hPairD
    let pb : PullbackElem H.right K.left := ⟨w, v, hMid⟩
    refine ⟨prodUnitToF F (PullbackElem H.right K.left) (pb, t₁), ?_⟩
    apply PullbackElem.ext
    · exact (prodUnitToF_natural F PullbackElem.fst pb t₁).trans hw
    · exact (prodUnitToF_natural F PullbackElem.snd pb t₁).trans
        ((congrArg (fun t => prodUnitToF F K.W (v, t)) ht).trans hv)

/-- Concrete non-sum-preserving `SpanFunctor` (`X ↦ 1 + ‖X‖` using `Option (PLift (Nonempty X))`)
witnessing finite Beck–Chevalley surjectivity failure with a nonempty source (`0` axioms). -/
def inhabitedOptionFunctor : SpanFunctor where
  obj X := Option (PLift (Nonempty X))
  map f
    | none => none
    | some ⟨h⟩ => some ⟨match h with | ⟨x⟩ => ⟨f x⟩⟩
  map_id
    | none => rfl
    | some ⟨_⟩ => rfl
  map_comp _ _
    | none => rfl
    | some ⟨_⟩ => rfl
  map_congr _
    | none => rfl
    | some ⟨_⟩ => rfl

/-- Left and right finite spans over `Bool` with empty local pullback `false = true` yet two
macro pullback witnesses `(none, none)` and `(some _, some _)` under `inhabitedOptionFunctor`. -/
def inhabitedOptionLeftSpan : RelSpan Unit Bool where
  W := Unit
  left _ := ()
  right _ := false

def inhabitedOptionRightSpan : RelSpan Bool Unit where
  W := Unit
  left _ := true
  right _ := ()

/-- `inhabitedOptionFunctor` has a genuine `1 → 2` Beck–Chevalley defect on finite spans with a
nonempty source (`none`), refuting surjectivity of `(chi inhabitedOptionFunctor ...).map`. -/
theorem inhabitedOptionFunctor_chi_not_surjective :
    ¬ Surj (chi inhabitedOptionFunctor inhabitedOptionLeftSpan inhabitedOptionRightSpan).map := by
  intro hsurj
  let target : PullbackElem
      (inhabitedOptionFunctor.map inhabitedOptionLeftSpan.right)
      (inhabitedOptionFunctor.map inhabitedOptionRightSpan.left) :=
    ⟨some ⟨⟨()⟩⟩, some ⟨⟨()⟩⟩, rfl⟩
  obtain ⟨u, hu⟩ := hsurj target
  cases u with
  | none =>
    have hFst : (none : Option (PLift (Nonempty Unit))) = some ⟨⟨()⟩⟩ :=
      congrArg PullbackElem.fst hu
    exact (by cases hFst)
  | some p =>
    match p.down with
    | ⟨q⟩ => exact Bool.noConfusion q.mid

/-! ### BC-Guarded Interchange & 3D Concurrent Reconfiguration Guards (`PolyComposition.SerialReconfigProcess`) -/

/-- **Guarded Interchange Theorem (`guarded_interchange_upgrades_iff_bc`):**
Assembly/aggregation `F` upgrades its lax time comparison `chi F H K` to a two-sided isomorphism
(`HasInverse` / `IsBijective`) iff `FImageIsPullback F H K` iff `β_E` is bijective for ALL families `E`. -/
theorem guarded_interchange_upgrades_iff_bc (F : SpanFunctor) {A D C : Type}
    (H : RelSpan A D) (K : RelSpan D C) :
    (IsBijective (chi F H K).map ↔ FImageIsPullback F H K) ∧
    (IsBijective (chi F H K).map ↔ ∀ (E : F.obj H.W → Type) (v : F.obj K.W),
      IsBijective (bcMap F H K E v)) :=
  ⟨chi_bijective_iff_pullback F H K, chi_bijective_iff_bc_all F H K⟩

/-- **Shared-Reserve Breakdown vs Serialized Concurrent 3D Reconfiguration (`reserve_disjoint_vs_serial_reconfig`):**
1. When two concurrent mode transitions do NOT share coupled substrate limits (disjoint independent
   coproduct `⊕`), concurrent reconfiguration distributes cleanly across time (`coprod_pullback_iso`);
2. Under shared coupled substrate draw (`PolyComposition.ConcurrentSerialWitness`), unserialized
   concurrent updates crash `4 -> 3 -> 1 -> 0` violating `Viability.Kernel`, whereas `csProc`
   (`SerialReconfigProcess`) rejects stale-epoch concurrent proposals (`reconfigure_stales_epoch`)
   and certifies closed-loop `Viability.Kernel` persistence. -/
theorem reserve_disjoint_vs_serial_reconfig :
    (∀ {A D C A' D' C' : Type}
      (H : RelSpan A D) (K : RelSpan D C) (H' : RelSpan A' D') (K' : RelSpan D' C'),
      IsBijective (coprod_pullback_iso H K H' K').toFun) ∧
    (PolyComposition.ConcurrentSerialWitness.csProc.step
      PolyComposition.ConcurrentSerialWitness.st₀
      (.reconfigA PolyComposition.ConcurrentSerialWitness.reqA)
      PolyComposition.ConcurrentSerialWitness.stA ∧
     Viability.Kernel PolyComposition.ConcurrentSerialWitness.csProc
       PolyComposition.ConcurrentSerialWitness.csGuard
       PolyComposition.ConcurrentSerialWitness.stA) ∧
    (PolyComposition.ConcurrentSerialWitness.csProc.step
      PolyComposition.ConcurrentSerialWitness.st₀
      (.reconfigB PolyComposition.ConcurrentSerialWitness.reqB)
      PolyComposition.ConcurrentSerialWitness.stB ∧
     Viability.Kernel PolyComposition.ConcurrentSerialWitness.csProc
       PolyComposition.ConcurrentSerialWitness.csGuard
       PolyComposition.ConcurrentSerialWitness.stB) ∧
    ((PolyComposition.ConcurrentSerialWitness.concurrentOrbit 0).1 () = 4 ∧
     (PolyComposition.ConcurrentSerialWitness.concurrentOrbit 1).1 () = 3 ∧
     (PolyComposition.ConcurrentSerialWitness.concurrentOrbit 2).1 () = 1 ∧
     (PolyComposition.ConcurrentSerialWitness.concurrentOrbit 3).1 () = 0 ∧
     ¬ Viability.Kernel PolyComposition.ConcurrentSerialWitness.concurrentUnguardedProcess
       (fun st => 3 ≤ st.1 ())
       (PolyComposition.ConcurrentSerialWitness.concurrentOrbit 0)) ∧
    (Transactions.fresh PolyComposition.ConcurrentSerialWitness.w₁.installation
      PolyComposition.ConcurrentSerialWitness.reqB.req = false ∧
     Reconfiguration.reconfigure
       PolyComposition.ConcurrentSerialWitness.reqB'.opened
       PolyComposition.ConcurrentSerialWitness.reqB'.amount
       PolyComposition.ConcurrentSerialWitness.reqB'.depth
       PolyComposition.ConcurrentSerialWitness.reqB'.candidate
       PolyComposition.ConcurrentSerialWitness.w₁ = none ∧
     (∀ st', ¬ PolyComposition.ConcurrentSerialWitness.csProc.step
       PolyComposition.ConcurrentSerialWitness.stA
       (.reconfigB PolyComposition.ConcurrentSerialWitness.reqB') st') ∧
     Viability.Kernel PolyComposition.ConcurrentSerialWitness.csProc
       PolyComposition.ConcurrentSerialWitness.csGuard
       PolyComposition.ConcurrentSerialWitness.st₀) :=
  ⟨fun H K H' K' => isBijective_of_bij (coprod_pullback_iso H K H' K'),
   PolyComposition.ConcurrentSerialWitness.concurrent_serial_dichotomy⟩

/-- **Grammar Bridge (`span_step_grammar_lumping`, via `Becoming.«像定后当且仅当同行»`):**
For any process `P : Process S A` whose step relation is `R s s' := ∃ a, P.step s a s'`,
the projected step image `«像» π R` is right-deterministic (`«定后» («像» π R)`) IF AND ONLY IF
`R` goes alike with projection equivalence `fun s s' => π s = π s'` (`«同行»`). -/
theorem span_step_grammar_lumping {S Q A : Type} (P : Process S A) (π : S → Q) :
    «定后» («像» π (fun s s' => ∃ a, P.step s a s')) ↔
      «同行» (fun s s' => ∃ a, P.step s a s') (fun s s' : S => π s = π s') :=
  «像定后当且仅当同行»

end OplaxHistory

end Becoming
