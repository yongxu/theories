import Becoming.Mechanism
import Becoming.Counterfactual
import Becoming.ProjectedLaws
import Becoming.OpenComposition
import Becoming.MultiScaleViability
import Becoming.Viability
import Becoming.CoreHelpers
import Becoming.GrammarLaws
import Becoming.RelSpan

/-!
# Causal Abstraction: Interventional Systems, Lax Viability Transfer, and Compositional Bounds

AI-written (Lean Unification Wave U3, 24 November 2026). Every declaration compiles from Lean's
prelude alone (`0` axioms, `0` `sorry`, `0` warnings, `L1` layering).

This module bridges interventional causal abstraction, multi-scale lax viability (`LaxSim`),
open-component composition (`OpenComponent`), and the core's structural laws of mechanism,
counterfactual exchange, experiment, and grammar lumping:

* **Part 1 — Interventional systems & abstraction (`CausalSystem`, `ExactCausalAbs`, `LaxCausalAbs`):**
  An interventional system `CausalSystem S A I` pairs an indexed family of processes `proc : I → Process S A`
  with a passive/observational index `obs : I`. `ExactCausalAbs` requires exact step factoring
  along `(π, φ, ω)` with `ω C₁.obs = C₂.obs`; `ExactCausalAbs.Lifts` lifts abstract traces back to
  concrete ones (`exactCausal_trace_exact_iff`), `exactCausal_commuting_iff` recovers unlabelled
  `ProjectedLaws.Commuting`, and `exactCausal_to_laxCausal` embeds exact abstraction (given macro
  step tracking) into `LaxCausalAbs`. Model instantiations cover maps (`ofMap`), disturbed laws
  (`ofDisturbed`), `Mechanism.inputs` (`ofMechanism`), `Experiment.retarget` (`ofRetarget`),
  `OpenComponent` port overrides (`portOverride`, `ofOpenComponent`, `ofOpenComposite`), products
  (`prod`), and `ExchangeLaw` (`effectiveLaw`, `ofExchangeLaw`, `withAct_self_next_pointwise`).

* **Part 2 — Interventional `Viability.Kernel` & policy transfer:**
  Open-loop macro schedules (`scheduledProcess`, `scheduledProcess_trace_block`, `laxCausal_openLoop_sim`,
  `laxCausal_openLoop_kernel_transfer`, `laxCausal_openLoop_keptFor_linear`), fine-step closed-loop
  feedback (`feedbackProcess`, `exactCausal_feedback_kernel_transfer`, `laxCausal_feedback_kernel_transfer`,
  `laxCausal_feedback_kernel_transfer_of_ball_invariant`, `laxCausal_feedback_keptFor_linear`), and
  sample-and-hold feedback over arbitrary `Strict σ` (`sampledFeedbackProcess`,
  `laxCausal_sampledFeedback_kernel_transfer`).

* **Part 3 — Vertical tower & horizontal open composition + `HorizontalLeakageWitness`:**
  Vertical composition (`ExactCausalAbs.comp`, `ExactCausalAbs.Lifts.comp`, `LaxCausalAbs.comp`,
  `LaxCausalAbs.compAdditive`, `LaxCausalAbs.compOneStep`), horizontal product and open-composite
  gluing (`ExactCausalAbs.prod`, `LaxCausalAbs.prodMax`, `LaxCausalAbs.prodSum`,
  `ofOpenComposite_step_iff`, `ofOpenComposite_boundary_local`, `ExactCausalAbs.composeOpen`,
  `LaxCausalAbs.composeOpen_to_prod_max`, `LaxCausalAbs.composeOpenMax`), and `HorizontalLeakageWitness`
  separating passive exactness and marginal exactness from joint interventional leakage.

* **Part 4 — Sharp observational-vs.-interventional separation (`CausalGoodhartWitness`):**
  On `Level` (`zero | one | two | three`), passive dynamics commute globally (`passive_commuting_all`,
  `passive_laxSim_exact`) and keep both micro and macro viability kernels (`passive_micro_kernel`,
  `passive_macro_kernel`), and interventional `boost` preserves the macro proxy kernel while raising
  the proxy (`2 < 3`), yet collapses the micro sustaining reserve at step 2 while the proxy still holds
  (`micro_boost_guardS_collapses`) and collapses the proxy at step 3 (`micro_boost_proxy_collapses`),
  ruling out `ExactCausalAbs` for any `ω`, zero-slack `LaxCausalAbs`, and small-slack (`α 0 + ε ≤ 1`)
  one-step `LaxCausalAbs`.

* **Part 5 — Bridges to `GrammarLaws`, `Counterfactual`, `Experiment`, `Mechanism`, & positive witness:**
  Exact causal abstraction existence iff `CausalGoAlike` / `CausalGoAlikeMap` via `GrammarLaws.«像»` and
  `«像定后当且仅当同行»` (`CausalImage`, `«因像定当且仅当因同行»`, `ImageMap`, `imageMap_iff_grammar`);
  constructive finite-list history projection `projectHistList` (zero `funext`) linking `ExchangeLaw`
  sensitivity (`exchange_givesAlike_iff_sensitive_in`, `exactCausal_of_exchange_sensitive_in`,
  `sensitive_in_of_through`) without `funext`; observational underdetermination (`causal_underdetermined_of_untaken`,
  `mechanism_intervention_underdetermined`, `exactCausal_refuted_of_confound_varied`); and
  `PositiveCoupledFeedbackWitness` proving non-exactness yet positive coupled feedback & open-loop
  viability kernels via `LaxCausalAbs`.

What is not derived: whether any empirical system meets the premises of an exact or lax abstraction
(AGENTS.md Rule 2). No ethical predicate, ranking, or axiom occurs.
-/

namespace Becoming

open Generative Assurance

universe u v w z u₁ v₁ w₁ u₂ v₂ w₂

/-! ## Part 1: Interventional Systems, Exact & Lax Causal Abstraction, and Instantiations -/

/-- An interventional causal system: an indexed family of transition processes over interventions `I`
together with a distinguished passive/observational intervention index `obs : I`. -/
structure CausalSystem (S : Type u) (A : Type v) (I : Type w) where
  proc : I → Process S A
  obs : I

/-- The passive/observational process of a causal system. -/
def CausalSystem.passive {S : Type u} {A : Type v} {I : Type w} (C : CausalSystem S A I) :
    Process S A :=
  C.proc C.obs

/-- Action-mapped process factoring: every step of `P` projects along `(π, φ)` to a step of `R`. -/
def FactorsThroughMap {S : Type u} {A : Type v} {Q : Type w} {B : Type z}
    (P : Process S A) (R : Process Q B) (π : S → Q) (φ : A → B) : Prop :=
  ∀ s a s', P.step s a s' → R.step (π s) (φ a) (π s')

/-- Exact causal abstraction from `C₁` to `C₂` along state map `π`, action map `φ`, and
intervention alignment `ω`: passive interventions align and every intervened step factors. -/
structure ExactCausalAbs {S : Type u} {A : Type v} {I : Type w}
    {Q : Type u₁} {B : Type v₁} {J : Type w₁}
    (C₁ : CausalSystem S A I) (C₂ : CausalSystem Q B J)
    (π : S → Q) (φ : A → B) (ω : I → J) : Prop where
  obs_eq : ω C₁.obs = C₂.obs
  factors : ∀ i, FactorsThroughMap (C₁.proc i) (C₂.proc (ω i)) π φ

/-- Fibrewise lifting condition for an exact causal abstraction: every abstract step under `ω i`
from `π s` lifts to a concrete step from `s` under `i`. -/
def ExactCausalAbs.Lifts {S : Type u} {A : Type v} {I : Type w}
    {Q : Type u₁} {B : Type v₁} {J : Type w₁}
    {C₁ : CausalSystem S A I} {C₂ : CausalSystem Q B J}
    {π : S → Q} {φ : A → B} {ω : I → J}
    (_abs : ExactCausalAbs C₁ C₂ π φ ω) : Prop :=
  ∀ i s b q', (C₂.proc (ω i)).step (π s) b q' →
    ∃ a s', φ a = b ∧ (C₁.proc i).step s a s' ∧ π s' = q'

/-- Lax multi-scale causal abstraction from `C₁` to `C₂` along `(π, ω, σ, M)` with shared epochs
`Epoch`, `EpochQ` and uniform contraction/slack parameters `(α, β, ε, η)` across all interventions. -/
structure LaxCausalAbs {S : Type u} {A : Type v} {I : Type w}
    {Q : Type u₁} {B : Type v₁} {J : Type w₁}
    (C₁ : CausalSystem S A I) (C₂ : CausalSystem Q B J)
    (π : S → Q) (ω : I → J) (σ : Nat → Nat) (M : SlackDist Q) where
  obs_eq : ω C₁.obs = C₂.obs
  strict : Strict σ
  Epoch : Nat → S → Prop
  EpochQ : Nat → Q → Prop
  epoch_step : ∀ i t s a s', Epoch t s → (C₁.proc i).step s a s' → Epoch (t + 1) s'
  epoch_proj : ∀ k s, Epoch (σ k) s → EpochQ k (π s)
  α : Nat → Nat
  β : Nat → Nat
  α_mono : ∀ {r₁ r₂}, r₁ ≤ r₂ → α r₁ ≤ α r₂
  β_mono : ∀ {r₁ r₂}, r₁ ≤ r₂ → β r₁ ≤ β r₂
  β_ge_id : ∀ r, r ≤ β r
  ε : Nat
  η : Nat
  sim_block : ∀ i k s q r w s',
    Epoch (σ k) s → EpochQ k q → M.d (π s) q ≤ r →
    w.length = σ (k + 1) - σ k → Trace (C₁.proc i) s w s' →
    ∃ b q', (C₂.proc (ω i)).step q b q' ∧ EpochQ (k + 1) q' ∧ M.d (π s') q' ≤ α r + ε
  excursion : ∀ i k s q r w₁ u,
    Epoch (σ k) s → EpochQ k q → M.d (π s) q ≤ r →
    w₁.length < σ (k + 1) - σ k → Trace (C₁.proc i) s w₁ u →
    M.d (π u) q ≤ β r + η

/-- Restrict a lax causal abstraction to a single intervention `i : I` as a `LaxSim`. -/
def LaxCausalAbs.toLaxSim {S : Type u} {A : Type v} {I : Type w}
    {Q : Type u₁} {B : Type v₁} {J : Type w₁}
    {C₁ : CausalSystem S A I} {C₂ : CausalSystem Q B J}
    {π : S → Q} {ω : I → J} {σ : Nat → Nat} {M : SlackDist Q}
    (lc : LaxCausalAbs C₁ C₂ π ω σ M) (i : I) :
    LaxSim (C₁.proc i) (C₂.proc (ω i)) π σ M where
  strict := lc.strict
  Epoch := lc.Epoch
  EpochQ := lc.EpochQ
  epoch_step := lc.epoch_step i
  epoch_proj := lc.epoch_proj
  α := lc.α
  β := lc.β
  α_mono := lc.α_mono
  β_mono := lc.β_mono
  β_ge_id := lc.β_ge_id
  ε := lc.ε
  η := lc.η
  sim_block := lc.sim_block i
  excursion := lc.excursion i

/-- Restrict a lax causal abstraction to the passive processes as a `LaxSim`. -/
def LaxCausalAbs.passive {S : Type u} {A : Type v} {I : Type w}
    {Q : Type u₁} {B : Type v₁} {J : Type w₁}
    {C₁ : CausalSystem S A I} {C₂ : CausalSystem Q B J}
    {π : S → Q} {ω : I → J} {σ : Nat → Nat} {M : SlackDist Q}
    (lc : LaxCausalAbs C₁ C₂ π ω σ M) :
    LaxSim C₁.passive C₂.passive π σ M where
  strict := lc.strict
  Epoch := lc.Epoch
  EpochQ := lc.EpochQ
  epoch_step := lc.epoch_step C₁.obs
  epoch_proj := lc.epoch_proj
  α := lc.α
  β := lc.β
  α_mono := lc.α_mono
  β_mono := lc.β_mono
  β_ge_id := lc.β_ge_id
  ε := lc.ε
  η := lc.η
  sim_block k s q r w s' epS epQ d wlen tr :=
    Eq.subst (motive := fun j =>
      ∃ b q', (C₂.proc j).step q b q' ∧ lc.EpochQ (k + 1) q' ∧ M.d (π s') q' ≤ lc.α r + lc.ε)
      lc.obs_eq (lc.sim_block C₁.obs k s q r w s' epS epQ d wlen tr)
  excursion := lc.excursion C₁.obs

/-! ### Model Instantiations -/

/-- Deterministic interventional system from a transition map `next : I → S → A → S`. -/
def CausalSystem.ofMap {S : Type u} {A : Type v} {I : Type w}
    (next : I → S → A → S) (obs : I) : CausalSystem S A I where
  proc i := Assurance.ofMap (next i)
  obs := obs

/-- Disturbed interventional system from `Viability.disturbed`. -/
def CausalSystem.ofDisturbed {S : Type u} {A : Type v} {I : Type w}
    (f : I → S → A → S) (adm : I → A → Prop) (obs : I) : CausalSystem S A I where
  proc i := Viability.disturbed (f i) (adm i)
  obs := obs

/-- Standard causal model `x_{t+1} = F(x_t, u_t, ε_t)` (`Mechanism.inputs`) as an interventional
system over `Option U` (`none` passive, `some u₀` overrides the input with `u₀`). -/
def CausalSystem.ofMechanism {X : Type u} {U : Type v} {E : Type w}
    (F : X → U → E → X) : CausalSystem X (U × E) (Option U) where
  obs := none
  proc
    | none => inputs F
    | some u₀ => inputs (fun x _ e => F x u₀ e)

/-- Structural retargeting system (`Experiment.retarget`) over `Option (S × A × S)`: `none` is `P`
and `some (s, b, u₀)` retargets move `b` at `s` to `u₀`. -/
def CausalSystem.ofRetarget {S : Type u} {A : Type v} (P : Process S A) :
    CausalSystem S A (Option (S × A × S)) where
  obs := none
  proc
    | none => P
    | some (s, b, u₀) => retarget P s b u₀

/-- Override observation and alarm ports on an `OpenComponent` input pair `Obs × Bool`. -/
def portOverride {Obs : Type} (ov : Option Obs × Option Bool) (oa : Obs × Bool) : Obs × Bool :=
  (ov.1.getD oa.1, ov.2.getD oa.2)

/-- Open component (`OpenComposition.OpenComponent`) as a `CausalSystem` over boundary port
overrides `Option Obs × Option Bool`. Passive `(none, none)` is def-eq to `C.process tol`. -/
def CausalSystem.ofOpenComponent {S Obs Dist Int Ext : Type}
    (C : OpenComposition.OpenComponent S Obs Dist Int Ext) (tol : Obs × Bool → Dist → Prop) :
    CausalSystem S ((Obs × Bool) × Dist) (Option Obs × Option Bool) where
  obs := (none, none)
  proc ov := ⟨fun s m s' =>
    let oa := portOverride ov m.1
    tol oa m.2 ∧ s' = C.next s oa m.2⟩

/-- Horizontal composite of two `OpenComponent`s as a `CausalSystem` over split observation
overrides and a shared alarm override `(Option Obs₁ × Option Obs₂) × Option Bool`. -/
def CausalSystem.ofOpenComposite {S₁ S₂ Obs₁ Obs₂ Dist₁ Dist₂ Int₁ Int₂ Ext : Type}
    (A : OpenComposition.OpenComponent S₁ Obs₁ Dist₁ Int₁ Ext)
    (B : OpenComposition.OpenComponent S₂ Obs₂ Dist₂ Int₂ Ext)
    (tol₁ : Obs₁ × Bool → Dist₁ → Prop)
    (tol₂ : Obs₂ × Bool → Dist₂ → Prop) :
    CausalSystem (S₁ × S₂) (((Obs₁ × Obs₂) × Bool) × (Dist₁ × Dist₂))
      ((Option Obs₁ × Option Obs₂) × Option Bool) where
  obs := ((none, none), none)
  proc ov := ⟨fun s m s' =>
    let oa₁ := portOverride (ov.1.1, ov.2) (m.1.1.1, m.1.2)
    let oa₂ := portOverride (ov.1.2, ov.2) (m.1.1.2, m.1.2)
    (tol₁ oa₁ m.2.1 ∧ tol₂ oa₂ m.2.2) ∧
    s' = (A.next s.1 oa₁ m.2.1, B.next s.2 oa₂ m.2.2)⟩

/-- Independent synchronous product of two causal systems (universe-polymorphic, and def-eq to
`OpenComposition.prodProcess` at `: Type`). -/
def CausalSystem.prod {S₁ : Type u} {A₁ : Type v} {I₁ : Type w}
    {S₂ : Type u₁} {A₂ : Type v₁} {I₂ : Type w₁}
    (C₁ : CausalSystem S₁ A₁ I₁) (C₂ : CausalSystem S₂ A₂ I₂) :
    CausalSystem (S₁ × S₂) (A₁ × A₂) (I₁ × I₂) where
  obs := (C₁.obs, C₂.obs)
  proc i := ⟨fun s a s' => (C₁.proc i.1).step s.1 a.1 s'.1 ∧ (C₂.proc i.2).step s.2 a.2 s'.2⟩

/-- Effective exchange law selected by `Option (ExchangeLaw F C)`: `none` is `law`, `some act`
is `law.withAct part act`. -/
def effectiveLaw {F C : Type} (law : ExchangeLaw F C) (part : F → Bool) :
    Option (ExchangeLaw F C) → ExchangeLaw F C
  | none => law
  | some act => law.withAct part act

/-- `Counterfactual.ExchangeLaw` as a `CausalSystem` indexed by `Option (ExchangeLaw F C)` with
`obs := none` so `.passive` recovers `law.next` by `rfl`. -/
def CausalSystem.ofExchangeLaw {F C : Type}
    (law : ExchangeLaw F C) (present : Nat → List F) (part : F → Bool) :
    CausalSystem (Nat × (Nat → C → Nat)) Unit (Option (ExchangeLaw F C)) where
  obs := none
  proc i := Assurance.ofMap (fun x _ => (effectiveLaw law part i).next present x)

/-- Pointwise agreement of `(law.withAct part law).next` and `law.next` without `funext`. -/
theorem withAct_self_next_pointwise {F C : Type} (law : ExchangeLaw F C)
    (present : Nat → List F) (part : F → Bool) (x : Nat × (Nat → C → Nat)) :
    ((law.withAct part law).next present x).1 = (law.next present x).1 ∧
    ∀ s c, ((law.withAct part law).next present x).2 s c = (law.next present x).2 s c := by
  refine ⟨rfl, fun s c => ?_⟩
  show (law.withAct part law).extend present x.2 x.1 s c = law.extend present x.2 x.1 s c
  unfold ExchangeLaw.extend
  cases Nat.decLe s x.1 with
  | isTrue hle =>
    rw [if_pos hle, if_pos hle]
  | isFalse hnot =>
    rw [if_neg hnot, if_neg hnot]
    have htake : (law.withAct part law).takenUnder present x.2 x.1 c =
        law.takenUnder present x.2 x.1 c :=
      total_congr (fun h => by
        show (bif part h then law.take x.1 h x.2 c else law.take x.1 h x.2 c) =
          law.take x.1 h x.2 c
        cases part h <;> rfl) (present x.1)
    have hgive : (law.withAct part law).givenUnder present x.2 x.1 c =
        law.givenUnder present x.2 x.1 c :=
      total_congr (fun h => by
        show (bif part h then law.give x.1 h x.2 c else law.give x.1 h x.2 c) =
          law.give x.1 h x.2 c
        cases part h <;> rfl) (present x.1)
    rw [htake, hgive]

/-! ### Subsumption & Lifting -/

/-- Exact causal abstraction implies passive factoring. -/
theorem exactCausal_passive_factors {S : Type u} {A : Type v} {I : Type w}
    {Q : Type u₁} {B : Type v₁} {J : Type w₁}
    {C₁ : CausalSystem S A I} {C₂ : CausalSystem Q B J}
    {π : S → Q} {φ : A → B} {ω : I → J}
    (abs : ExactCausalAbs C₁ C₂ π φ ω) :
    FactorsThroughMap C₁.passive C₂.passive π φ :=
  fun s a s' step =>
    Eq.subst (motive := fun j => (C₂.proc j).step (π s) (φ a) (π s')) abs.obs_eq
      (abs.factors C₁.obs s a s' step)

/-- Exact causal abstraction maps concrete traces to abstract traces under `w.map φ`. -/
theorem exactCausal_trace_map {S : Type u} {A : Type v} {I : Type w}
    {Q : Type u₁} {B : Type v₁} {J : Type w₁}
    {C₁ : CausalSystem S A I} {C₂ : CausalSystem Q B J}
    {π : S → Q} {φ : A → B} {ω : I → J}
    (abs : ExactCausalAbs C₁ C₂ π φ ω) (i : I) :
    ∀ {s s' : S} {w : List A}, Trace (C₁.proc i) s w s' →
      Trace (C₂.proc (ω i)) (π s) (w.map φ) (π s') :=
  fun tr => RelSpan.mapTrace tr (abs.factors i)

/-- With fibrewise lifting, abstract traces correspond exactly to mapped concrete traces. -/
theorem exactCausal_trace_exact_iff {S : Type u} {A : Type v} {I : Type w}
    {Q : Type u₁} {B : Type v₁} {J : Type w₁}
    {C₁ : CausalSystem S A I} {C₂ : CausalSystem Q B J}
    {π : S → Q} {φ : A → B} {ω : I → J}
    (abs : ExactCausalAbs C₁ C₂ π φ ω) (lifts : abs.Lifts) (i : I) :
    ∀ {s : S} {wQ : List B} {q' : Q},
      Trace (C₂.proc (ω i)) (π s) wQ q' ↔
        ∃ w s', w.map φ = wQ ∧ Trace (C₁.proc i) s w s' ∧ π s' = q'
  | s, [], q' =>
    ⟨fun tr => ⟨[], s, rfl, .nil s, trace_nil_iff.mp tr⟩,
     fun ⟨w, s', hmap, tr, hq⟩ => by
       cases w with
       | nil =>
         cases tr
         exact hq ▸ .nil _
       | cons _ _ => cases hmap⟩
  | s, b :: wQ', q' =>
    ⟨fun tr => by
       obtain ⟨mQ, stepQ, tailQ⟩ := trace_cons_iff.mp tr
       obtain ⟨a, m, hφ, step₁, hm⟩ := lifts i s b mQ stepQ
       have tailQ' : Trace (C₂.proc (ω i)) (π m) wQ' q' := hm ▸ tailQ
       obtain ⟨w', s', hmap', tr₁, hq'⟩ :=
         (exactCausal_trace_exact_iff abs lifts i).mp tailQ'
       exact ⟨a :: w', s', congr (congrArg List.cons hφ) hmap', .cons step₁ tr₁, hq'⟩,
     fun ⟨w, s', hmap, tr, hq⟩ => by
       have trQ := exactCausal_trace_map abs i tr
       rw [hmap, hq] at trQ
       exact trQ⟩

/-- On deterministic maps with `A := Unit`, `ExactCausalAbs` is equivalent to `obs_eq` together
with unlabelled `ProjectedLaws.Commuting` at every intervention `i`. -/
theorem exactCausal_commuting_iff {S : Type u} {I : Type w} {Q : Type u₁} {J : Type w₁}
    {next₁ : I → S → Unit → S} {next₂ : J → Q → Unit → Q}
    {obs₁ : I} {obs₂ : J} {π : S → Q} {φ : Unit → Unit} {ω : I → J} :
    ExactCausalAbs (CausalSystem.ofMap next₁ obs₁) (CausalSystem.ofMap next₂ obs₂) π φ ω ↔
      ω obs₁ = obs₂ ∧ ∀ i, ProjectedLaws.Commuting (next₁ i) (next₂ (ω i)) π :=
  ⟨fun ⟨hobs, hfac⟩ => ⟨hobs, fun i s a => hfac i s a (next₁ i s a) rfl⟩,
   fun ⟨hobs, hcomm⟩ => ⟨hobs, fun i s a _ hs' => (congrArg π hs').trans (hcomm i s a)⟩⟩

/-- Lift a passive `LaxSim` on a `Unit`-indexed system into a `LaxCausalAbs`. -/
def LaxCausalAbs.ofPassiveLaxSim {S : Type u} {A : Type v}
    {Q : Type u₁} {B : Type v₁} {J : Type w₁}
    (C₁ : CausalSystem S A Unit) (C₂ : CausalSystem Q B J)
    {π : S → Q} {σ : Nat → Nat} {M : SlackDist Q}
    (sim : LaxSim C₁.passive C₂.passive π σ M) :
    LaxCausalAbs C₁ C₂ π (fun _ => C₂.obs) σ M where
  obs_eq := rfl
  strict := sim.strict
  Epoch := sim.Epoch
  EpochQ := sim.EpochQ
  epoch_step i := by
    have unit_eq : ∀ x y : Unit, x = y := fun () () => rfl
    exact (unit_eq i C₁.obs) ▸ sim.epoch_step
  epoch_proj := sim.epoch_proj
  α := sim.α
  β := sim.β
  α_mono := sim.α_mono
  β_mono := sim.β_mono
  β_ge_id := sim.β_ge_id
  ε := sim.ε
  η := sim.η
  sim_block i := by
    have unit_eq : ∀ x y : Unit, x = y := fun () () => rfl
    exact (unit_eq i C₁.obs) ▸ sim.sim_block
  excursion i := by
    have unit_eq : ∀ x y : Unit, x = y := fun () () => rfl
    exact (unit_eq i C₁.obs) ▸ sim.excursion

/-- Embed an `ExactCausalAbs` into a 1-step (`σ = id`) `LaxCausalAbs` given a macro tracking
condition on `C₂` along `M`. Uses `succ_sub_self k : (k + 1) - k = 1`. -/
def exactCausal_to_laxCausal {S : Type u} {A : Type v} {I : Type w}
    {Q : Type u₁} {B : Type v₁} {J : Type w₁}
    {C₁ : CausalSystem S A I} {C₂ : CausalSystem Q B J}
    {π : S → Q} {φ : A → B} {ω : I → J}
    (abs : ExactCausalAbs C₁ C₂ π φ ω) (M : SlackDist Q)
    (Epoch : Nat → S → Prop) (EpochQ : Nat → Q → Prop)
    (epoch_step : ∀ i t s a s', Epoch t s → (C₁.proc i).step s a s' → Epoch (t + 1) s')
    (epoch_proj : ∀ k s, Epoch k s → EpochQ k (π s))
    (α : Nat → Nat) (α_mono : ∀ {r₁ r₂}, r₁ ≤ r₂ → α r₁ ≤ α r₂) (ε : Nat)
    (track : ∀ i k q₁ q₂ r b q₁',
      EpochQ k q₁ → EpochQ k q₂ → M.d q₁ q₂ ≤ r → (C₂.proc (ω i)).step q₁ b q₁' →
      ∃ b' q₂', (C₂.proc (ω i)).step q₂ b' q₂' ∧ EpochQ (k + 1) q₂' ∧ M.d q₁' q₂' ≤ α r + ε) :
    LaxCausalAbs C₁ C₂ π ω id M where
  obs_eq := abs.obs_eq
  strict _ := Nat.lt_succ_self _
  Epoch := Epoch
  EpochQ := EpochQ
  epoch_step := epoch_step
  epoch_proj := epoch_proj
  α := α
  β := id
  α_mono := α_mono
  β_mono le := le
  β_ge_id r := Nat.le_refl r
  ε := ε
  η := 0
  sim_block i k s q r w s' epS epQ d_le w_len tr := by
    have w1 : w.length = 1 := w_len.trans (succ_sub_self k)
    match w with
    | [] => exact Nat.noConfusion w1
    | [a] =>
      match tr with
      | .cons step (.nil _) =>
        exact track i k (π s) q r (φ a) (π s') (epoch_proj k s epS) epQ d_le
          (abs.factors i s a s' step)
    | _ :: _ :: _ => exact Nat.noConfusion (Nat.succ.inj w1)
  excursion _ k s q r w₁ u _ _ d_le w₁_lt tr := by
    have hlt : w₁.length < 1 := (succ_sub_self k) ▸ w₁_lt
    match w₁ with
    | [] =>
      match tr with
      | .nil _ => exact Nat.le_trans d_le (Nat.le_add_right r 0)
    | _ :: _ => exact absurd hlt (Nat.not_lt_of_le (Nat.le_add_left 1 _))

/-! ## Part 2: Interventional `Viability.Kernel` & Policy Transfer -/

/-! ### Open-Loop Scheduled Transfer -/

/-- Fine-step execution of `C` under a block-indexed open-loop intervention schedule `sched` aligned
by `coarsenIndex σ t`. -/
def CausalSystem.scheduledProcess {S : Type u} {A : Type v} {I : Type w}
    (C : CausalSystem S A I) (σ : Nat → Nat) (sched : Nat → I) :
    Process (Nat × S) A where
  step ts a ts' := ts'.1 = ts.1 + 1 ∧ (C.proc (sched (coarsenIndex σ ts.1))).step ts.2 a ts'.2

/-- Generalized block trace decomposition for `scheduledProcess` from arbitrary `(t₀, s)` with
`σ k ≤ t₀` and `t₀ + w.length ≤ σ (k + 1)` (CRITICAL FIX B4). -/
theorem scheduledProcess_trace_block {S : Type u} {A : Type v} {I : Type w}
    {C : CausalSystem S A I} {σ : Nat → Nat} (strict : Strict σ) (sched : Nat → I) :
    ∀ {k t₀ : Nat} {s : S} {w : List A} {ts' : Nat × S},
      σ k ≤ t₀ → t₀ + w.length ≤ σ (k + 1) →
      Trace (C.scheduledProcess σ sched) (t₀, s) w ts' →
      ts'.1 = t₀ + w.length ∧ Trace (C.proc (sched k)) s w ts'.2
  | _, t₀, s, [], (_, _), _, _, .nil _ => ⟨rfl, .nil s⟩
  | k, t₀, s, a :: rest, ts', hle, hbound, .cons (m := m) step restTr => by
    have hlt : t₀ < σ (k + 1) :=
      Nat.lt_of_lt_of_le (Nat.lt_add_of_pos_right (Nat.succ_pos rest.length)) hbound
    have hidx : coarsenIndex σ t₀ = k := coarsenIndex_eq strict hle hlt
    have hm1 : m.1 = t₀ + 1 := step.1
    have hstep : (C.proc (sched k)).step s a m.2 := hidx ▸ step.2
    have hle' : σ k ≤ t₀ + 1 := Nat.le_succ_of_le hle
    have hbound' : (t₀ + 1) + rest.length ≤ σ (k + 1) := by
      rw [Nat.add_right_comm t₀ 1 rest.length]
      exact hbound
    have hm_eq : m = (t₀ + 1, m.2) := Prod.ext hm1 rfl
    obtain ⟨hend, tailTr⟩ :=
      scheduledProcess_trace_block strict sched hle' hbound' (hm_eq ▸ restTr)
    have hend' : ts'.1 = t₀ + (a :: rest).length := by
      rw [hend, Nat.add_right_comm t₀ 1 rest.length]
      rfl
    exact ⟨hend', .cons hstep tailTr⟩

/-- A `LaxCausalAbs` induces a `LaxSim` from `C₁.scheduledProcess σ sched` to the macro
scheduled process `C₂.scheduledProcess id (fun k => ω (sched k))`. -/
def laxCausal_openLoop_sim {S : Type u} {A : Type v} {I : Type w}
    {Q : Type u₁} {B : Type v₁} {J : Type w₁}
    {C₁ : CausalSystem S A I} {C₂ : CausalSystem Q B J}
    {π : S → Q} {ω : I → J} {σ : Nat → Nat} {M : SlackDist Q}
    (lc : LaxCausalAbs C₁ C₂ π ω σ M) (sched : Nat → I) :
    LaxSim (C₁.scheduledProcess σ sched) (C₂.scheduledProcess id (fun k => ω (sched k)))
      (fun ts => (coarsenIndex σ ts.1, π ts.2)) σ (SlackDist.pullback Prod.snd M) where
  strict := lc.strict
  Epoch t ts := ts.1 = t ∧ lc.Epoch t ts.2
  EpochQ k kq := kq.1 = k ∧ lc.EpochQ k kq.2
  epoch_step t ts a ts' ep step :=
    ⟨ep.1 ▸ step.1, lc.epoch_step (sched (coarsenIndex σ ts.1)) t ts.2 a ts'.2 ep.2 step.2⟩
  epoch_proj k ts ep :=
    ⟨ep.1.symm ▸ coarsenIndex_sample lc.strict k, lc.epoch_proj k ts.2 (ep.1 ▸ ep.2)⟩
  α := lc.α
  β := lc.β
  α_mono := lc.α_mono
  β_mono := lc.β_mono
  β_ge_id := lc.β_ge_id
  ε := lc.ε
  η := lc.η
  sim_block k ts kq r w ts' epS epQ d_le w_len tr := by
    obtain ⟨hts, epS2⟩ := epS
    obtain ⟨hkq, epQ2⟩ := epQ
    have hbound : σ k + w.length ≤ σ (k + 1) :=
      Nat.le_of_eq ((congrArg (σ k + ·) w_len).trans (add_sub_of_le (Nat.le_of_lt (lc.strict k))))
    have tr' : Trace (C₁.scheduledProcess σ sched) (σ k, ts.2) w ts' :=
      (Prod.ext hts rfl : ts = (σ k, ts.2)) ▸ tr
    obtain ⟨hts', tr₁⟩ :=
      scheduledProcess_trace_block lc.strict sched (Nat.le_refl (σ k)) hbound tr'
    have hts'_eq : ts'.1 = σ (k + 1) :=
      hts'.trans ((congrArg (σ k + ·) w_len).trans (add_sub_of_le (Nat.le_of_lt (lc.strict k))))
    obtain ⟨b, q', stepQ, epQ', d_le'⟩ :=
      lc.sim_block (sched k) k ts.2 kq.2 r w ts'.2 epS2 epQ2 d_le w_len tr₁
    have hidx_id : coarsenIndex id kq.1 = k :=
      hkq.symm ▸ coarsenIndex_sample (fun n => Nat.lt_succ_self n) k
    have stepSched : (C₂.scheduledProcess id (fun j => ω (sched j))).step kq b (k + 1, q') :=
      ⟨hkq ▸ rfl, hidx_id.symm ▸ stepQ⟩
    have hidx_end : coarsenIndex σ ts'.1 = k + 1 :=
      hts'_eq.symm ▸ coarsenIndex_sample lc.strict (k + 1)
    exact ⟨b, (k + 1, q'), stepSched, ⟨rfl, epQ'⟩, d_le'⟩
  excursion k ts kq r w₁ u epS epQ d_le w₁_lt tr := by
    obtain ⟨hts, epS2⟩ := epS
    obtain ⟨_, epQ2⟩ := epQ
    have hbound : σ k + w₁.length ≤ σ (k + 1) :=
      Nat.le_trans (Nat.add_le_add_left (Nat.le_of_lt w₁_lt) (σ k))
        (Nat.le_of_eq (add_sub_of_le (Nat.le_of_lt (lc.strict k))))
    have tr' : Trace (C₁.scheduledProcess σ sched) (σ k, ts.2) w₁ u :=
      (Prod.ext hts rfl : ts = (σ k, ts.2)) ▸ tr
    obtain ⟨_, tr₁⟩ :=
      scheduledProcess_trace_block lc.strict sched (Nat.le_refl (σ k)) hbound tr'
    exact lc.excursion (sched k) k ts.2 kq.2 r w₁ u.2 epS2 epQ2 d_le w₁_lt tr₁

/-- Infinite-horizon open-loop viability kernel transfer, delegating to `lax_kernel_of_kernel`. -/
theorem laxCausal_openLoop_kernel_transfer {S : Type u} {A : Type v} {I : Type w}
    {Q : Type u₁} {B : Type v₁} {J : Type w₁}
    {C₁ : CausalSystem S A I} {C₂ : CausalSystem Q B J}
    {π : S → Q} {ω : I → J} {σ : Nat → Nat} {M : SlackDist Q}
    (lc : LaxCausalAbs C₁ C₂ π ω σ M) (sched : Nat → I)
    {guardQ : Nat × Q → Prop} {guardS : Nat × S → Prop}
    (Δ : Nat) (absorb : lc.α Δ + lc.ε ≤ Δ)
    (margin : ∀ kq u, guardQ kq → M.d (π u.2) kq.2 ≤ lc.β Δ + lc.η → guardS u)
    {s₀ : S} (epoch₀ : lc.Epoch (σ 0) s₀)
    (kernelQ : Viability.Kernel (C₂.scheduledProcess id (fun k => ω (sched k))) guardQ (0, π s₀)) :
    Viability.Kernel (C₁.scheduledProcess σ sched) guardS (σ 0, s₀) :=
  lax_kernel_of_kernel (laxCausal_openLoop_sim lc sched) Δ absorb margin ⟨rfl, epoch₀⟩
    ((congrArg (fun idx => Viability.Kernel (C₂.scheduledProcess id (fun k => ω (sched k))) guardQ (idx, π s₀))
      (coarsenIndex_sample lc.strict 0).symm).mp kernelQ)

/-- Finite-horizon linear-drift open-loop viability transfer, delegating to
`lax_keptFor_linear_of_kernel`. -/
theorem laxCausal_openLoop_keptFor_linear {S : Type u} {A : Type v} {I : Type w}
    {Q : Type u₁} {B : Type v₁} {J : Type w₁}
    {C₁ : CausalSystem S A I} {C₂ : CausalSystem Q B J}
    {π : S → Q} {ω : I → J} {σ : Nat → Nat} {M : SlackDist Q}
    (lc : LaxCausalAbs C₁ C₂ π ω σ M) (lin : lc.α = id) (sched : Nat → I)
    {guardQ : Nat × Q → Prop} {guardS : Nat × S → Prop}
    (N : Nat) (hN : 0 < N)
    (margin : ∀ kq u, guardQ kq → M.d (π u.2) kq.2 ≤ lc.β ((N - 1) * lc.ε) + lc.η → guardS u)
    {s₀ : S} (epoch₀ : lc.Epoch (σ 0) s₀)
    (kernelQ : Viability.Kernel (C₂.scheduledProcess id (fun k => ω (sched k))) guardQ (0, π s₀)) :
    ∀ w t, w.length < σ N - σ 0 → Trace (C₁.scheduledProcess σ sched) (σ 0, s₀) w t → guardS t :=
  lax_keptFor_linear_of_kernel (laxCausal_openLoop_sim lc sched) lin N hN margin ⟨rfl, epoch₀⟩
    ((congrArg (fun idx => Viability.Kernel (C₂.scheduledProcess id (fun k => ω (sched k))) guardQ (idx, π s₀))
      (coarsenIndex_sample lc.strict 0).symm).mp kernelQ)

/-! ### Closed-Loop Fine-Step Feedback Transfer -/

/-- Closed-loop state-feedback process of `C` under policy `pol : S → I`. -/
def CausalSystem.feedbackProcess {S : Type u} {A : Type v} {I : Type w}
    (C : CausalSystem S A I) (pol : S → I) : Process S A where
  step s a s' := (C.proc (pol s)).step s a s'

/-- Trace transport along an `ExactCausalAbs` under a macro-state feedback policy `κ : Q → I`. -/
theorem exactCausal_feedback_trace_map {S : Type u} {A : Type v} {I : Type w}
    {Q : Type u₁} {B : Type v₁} {J : Type w₁}
    {C₁ : CausalSystem S A I} {C₂ : CausalSystem Q B J}
    {π : S → Q} {φ : A → B} {ω : I → J}
    (abs : ExactCausalAbs C₁ C₂ π φ ω) (κ : Q → I) :
    ∀ {s s' : S} {w : List A},
      Trace (C₁.feedbackProcess (fun x => κ (π x))) s w s' →
      Trace (C₂.feedbackProcess (fun q => ω (κ q))) (π s) (w.map φ) (π s')
  | _, _, [], .nil _ => .nil _
  | _, _, _ :: _, .cons step rest =>
    .cons (abs.factors (κ (π _)) _ _ _ step) (exactCausal_feedback_trace_map abs κ rest)

/-- Exact feedback viability kernel transfer from macro to micro under policy `κ : Q → I`. -/
theorem exactCausal_feedback_kernel_transfer {S : Type u} {A : Type v} {I : Type w}
    {Q : Type u₁} {B : Type v₁} {J : Type w₁}
    {C₁ : CausalSystem S A I} {C₂ : CausalSystem Q B J}
    {π : S → Q} {φ : A → B} {ω : I → J}
    (abs : ExactCausalAbs C₁ C₂ π φ ω) (κ : Q → I)
    {guardQ : Q → Prop} {guardS : S → Prop}
    (margin : ∀ s, guardQ (π s) → guardS s)
    {s₀ : S} (kernelQ : Viability.Kernel (C₂.feedbackProcess (fun q => ω (κ q))) guardQ (π s₀)) :
    Viability.Kernel (C₁.feedbackProcess (fun s => κ (π s))) guardS s₀ :=
  fun t ⟨w, tr⟩ => margin t (kernelQ (π t) ⟨w.map φ, exactCausal_feedback_trace_map abs κ tr⟩)

private theorem feedback_invariant_steps {S : Type u} {A : Type v} {I : Type w}
    {Q : Type u₁} {B : Type v₁} {J : Type w₁}
    {C₁ : CausalSystem S A I} {C₂ : CausalSystem Q B J}
    {π : S → Q} {ω : I → J} {M : SlackDist Q}
    (lc : LaxCausalAbs C₁ C₂ π ω id M) (κ : Q → I) (K : Q → Prop) (bound : Nat → Nat)
    (step_inv : ∀ k s q b q',
      lc.Epoch k s → lc.EpochQ k q → K q → M.d (π s) q ≤ bound k →
      (C₂.proc (ω (κ (π s)))).step q b q' → K q' ∧ bound k + 0 ≤ bound k)
    (slack_step : ∀ k, lc.α (bound k) + lc.ε ≤ bound (k + 1)) :
    ∀ {k : Nat} {s t : S} {w : List A},
      lc.Epoch k s → (∃ q, K q ∧ lc.EpochQ k q ∧ M.d (π s) q ≤ bound k) →
      Trace (C₁.feedbackProcess (fun x => κ (π x))) s w t →
      lc.Epoch (k + w.length) t ∧
        ∃ q', K q' ∧ lc.EpochQ (k + w.length) q' ∧ M.d (π t) q' ≤ bound (k + w.length)
  | _, _, _, [], epS, hq, .nil _ => ⟨epS, hq⟩
  | k, s, t, a :: rest, epS, ⟨q, hKq, epQ, hd⟩, .cons step restTr => by
    obtain ⟨b, q₁, stepQ, epQ₁, hd₁⟩ :=
      lc.sim_block (κ (π s)) k s q (bound k) [a] _ epS epQ hd (succ_sub_self k).symm (.cons step (.nil _))
    have hKq₁ : K q₁ := (step_inv k s q b q₁ epS epQ hKq hd stepQ).1
    have hd₁' : M.d (π _) q₁ ≤ bound (k + 1) := Nat.le_trans hd₁ (slack_step k)
    have epS₁ : lc.Epoch (k + 1) _ := lc.epoch_step (κ (π s)) k s a _ epS step
    obtain ⟨epT, hqt⟩ :=
      feedback_invariant_steps lc κ K bound step_inv slack_step epS₁ ⟨q₁, hKq₁, epQ₁, hd₁'⟩ restTr
    have hlen : (k + 1) + rest.length = k + (a :: rest).length :=
      Nat.add_right_comm k 1 rest.length
    exact ⟨hlen ▸ epT, hqt.elim fun q' hq' => ⟨q', hq'.1, hlen ▸ hq'.2.1, hlen ▸ hq'.2.2⟩⟩

/-- Infinite-horizon lax closed-loop feedback viability transfer (for 1-step `LaxCausalAbs` with
`σ = id`) under an explicit robust feedback invariance certificate on `Δ`-balls. -/
theorem laxCausal_feedback_kernel_transfer {S : Type u} {A : Type v} {I : Type w}
    {Q : Type u₁} {B : Type v₁} {J : Type w₁}
    {C₁ : CausalSystem S A I} {C₂ : CausalSystem Q B J}
    {π : S → Q} {ω : I → J} {M : SlackDist Q}
    (lc : LaxCausalAbs C₁ C₂ π ω id M) (κ : Q → I)
    {guardQ K : Q → Prop} {guardS : S → Prop}
    (Δ : Nat) (absorb : lc.α Δ + lc.ε ≤ Δ)
    (within : ∀ q, K q → guardQ q)
    (ball_closed : ∀ q₁ q₂ b q₂',
      K q₂ → M.d q₁ q₂ ≤ Δ → (C₂.proc (ω (κ q₁))).step q₂ b q₂' → K q₂')
    (margin : ∀ q u, guardQ q → M.d (π u) q ≤ lc.β Δ + lc.η → guardS u)
    {s₀ : S} (epoch₀ : lc.Epoch 0 s₀) (init : K (π s₀)) :
    Viability.Kernel (C₁.feedbackProcess (fun s => κ (π s))) guardS s₀ := by
  intro t ⟨w, tr⟩
  have h0 : ∃ q, K q ∧ lc.EpochQ 0 q ∧ M.d (π s₀) q ≤ Δ :=
    ⟨π s₀, init, lc.epoch_proj 0 s₀ epoch₀, (M.refl (π s₀)).symm ▸ Nat.zero_le Δ⟩
  obtain ⟨_, q', hKq', _, hd'⟩ :=
    feedback_invariant_steps lc κ K (fun _ => Δ)
      (fun _ _ q b q' _ _ hKq hd stepQ => ⟨ball_closed (π _) q b q' hKq hd stepQ, Nat.le_refl _⟩)
      (fun _ => absorb) epoch₀ h0 tr
  exact margin q' t (within q' hKq')
    (Nat.le_trans hd' (Nat.le_trans (lc.β_ge_id Δ) (Nat.le_add_right _ _)))

/-- Corollary when `κ` is invariant on `Δ`-balls around `K` and `K` is a certificate for the macro
feedback process `C₂.feedbackProcess (fun q => ω (κ q))`. -/
theorem laxCausal_feedback_kernel_transfer_of_ball_invariant {S : Type u} {A : Type v} {I : Type w}
    {Q : Type u₁} {B : Type v₁} {J : Type w₁}
    {C₁ : CausalSystem S A I} {C₂ : CausalSystem Q B J}
    {π : S → Q} {ω : I → J} {M : SlackDist Q}
    (lc : LaxCausalAbs C₁ C₂ π ω id M) (κ : Q → I)
    {guardQ K : Q → Prop} {guardS : S → Prop}
    (cert : Viability.Certificate (C₂.feedbackProcess (fun q => ω (κ q))) guardQ K)
    (Δ : Nat) (absorb : lc.α Δ + lc.ε ≤ Δ)
    (ball_inv : ∀ q₁ q₂, K q₂ → M.d q₁ q₂ ≤ Δ → ω (κ q₁) = ω (κ q₂))
    (margin : ∀ q u, guardQ q → M.d (π u) q ≤ lc.β Δ + lc.η → guardS u)
    {s₀ : S} (epoch₀ : lc.Epoch 0 s₀) (init : K (π s₀)) :
    Viability.Kernel (C₁.feedbackProcess (fun s => κ (π s))) guardS s₀ :=
  laxCausal_feedback_kernel_transfer lc κ Δ absorb cert.within
    (fun q₁ q₂ b q₂' hKq hd stepQ =>
      cert.closed q₂ b q₂'
        (Eq.subst (motive := fun j => (C₂.proc j).step q₂ b q₂') (ball_inv q₁ q₂ hKq hd) stepQ) hKq)
    margin epoch₀ init

/-- Finite-horizon linear-drift closed-loop feedback viability transfer (`lc.α = id`, NO `absorb`
hypothesis) for traces of length `< N` when `0 < N`. -/
theorem laxCausal_feedback_keptFor_linear {S : Type u} {A : Type v} {I : Type w}
    {Q : Type u₁} {B : Type v₁} {J : Type w₁}
    {C₁ : CausalSystem S A I} {C₂ : CausalSystem Q B J}
    {π : S → Q} {ω : I → J} {M : SlackDist Q}
    (lc : LaxCausalAbs C₁ C₂ π ω id M) (lin : lc.α = id) (κ : Q → I)
    {guardQ K : Q → Prop} {guardS : S → Prop}
    (N : Nat) (hN : 0 < N)
    (within : ∀ q, K q → guardQ q)
    (ball_closed : ∀ q₁ q₂ b q₂',
      K q₂ → M.d q₁ q₂ ≤ (N - 1) * lc.ε → (C₂.proc (ω (κ q₁))).step q₂ b q₂' → K q₂')
    (margin : ∀ q u, guardQ q → M.d (π u) q ≤ lc.β ((N - 1) * lc.ε) + lc.η → guardS u)
    {s₀ : S} (epoch₀ : lc.Epoch 0 s₀) (init : K (π s₀)) :
    ∀ w t, w.length < N → Trace (C₁.feedbackProcess (fun s => κ (π s))) s₀ w t → guardS t := by
  intro w t w_lt tr
  have h0 : ∃ q, K q ∧ lc.EpochQ 0 q ∧ M.d (π s₀) q ≤ 0 * lc.ε :=
    ⟨π s₀, init, lc.epoch_proj 0 s₀ epoch₀, (M.refl (π s₀)).symm ▸ Nat.zero_le _⟩
  -- Track k ≤ N - 1 directly along the trace by induction on w'.
  have aux : ∀ {k : Nat} {s u : S} {w' : List A},
      k + w'.length < N → lc.Epoch k s →
      (∃ q, K q ∧ lc.EpochQ k q ∧ M.d (π s) q ≤ k * lc.ε) →
      Trace (C₁.feedbackProcess (fun x => κ (π x))) s w' u →
      ∃ q', K q' ∧ M.d (π u) q' ≤ (N - 1) * lc.ε := by
    intro k s u w' hlt epS hq tr'
    induction w' generalizing k s with
    | nil =>
      cases tr'
      obtain ⟨q, hKq, _, hd⟩ := hq
      have hk_le : k ≤ N - 1 := by
        match N, hN, hlt with
        | n + 1, _, h => exact Nat.le_of_lt_succ h
      exact ⟨q, hKq, Nat.le_trans hd (Nat.mul_le_mul_right lc.ε hk_le)⟩
    | cons a rest ih =>
      cases tr' with
      | cons step tail =>
        obtain ⟨q, hKq, epQ, hd⟩ := hq
        have hk_lt : k < N := Nat.lt_of_le_of_lt (Nat.le_add_right k (a :: rest).length) hlt
        have hk_le : k ≤ N - 1 := by
          match N, hN, hk_lt with
          | n + 1, _, h => exact Nat.le_of_lt_succ h
        have hdN : M.d (π s) q ≤ (N - 1) * lc.ε :=
          Nat.le_trans hd (Nat.mul_le_mul_right lc.ε hk_le)
        obtain ⟨b, q₁, stepQ, epQ₁, hd₁⟩ :=
          lc.sim_block (κ (π s)) k s q (k * lc.ε) [a] _ epS epQ hd (succ_sub_self k).symm
            (.cons step (.nil _))
        have hKq₁ : K q₁ := ball_closed (π s) q b q₁ hKq hdN stepQ
        have hlin : lc.α (k * lc.ε) + lc.ε = (k + 1) * lc.ε := by
          rw [lin]
          exact (Nat.succ_mul k lc.ε).symm
        have hd₁' := Nat.le_trans hd₁ (Nat.le_of_eq hlin)
        have epS₁ := lc.epoch_step (κ (π s)) k s a _ epS step
        have hlt' : (k + 1) + rest.length < N := by
          rw [Nat.add_right_comm k 1 rest.length]
          exact hlt
        exact ih hlt' epS₁ ⟨q₁, hKq₁, epQ₁, hd₁'⟩ tail
  obtain ⟨q', hKq', hd'⟩ := aux (k := 0) ((Nat.zero_add w.length).symm ▸ w_lt) epoch₀ h0 tr
  exact margin q' t (within q' hKq')
    (Nat.le_trans hd' (Nat.le_trans (lc.β_ge_id ((N - 1) * lc.ε)) (Nat.le_add_right _ _)))

/-! ### Sample-and-Hold Feedback Transfer (Arbitrary `Strict σ`) -/

/-- Local list `snoc` length helper (`(w ++ [a]).length = w.length + 1`). -/
theorem length_snoc {α : Type u} : ∀ (w : List α) (a : α), (w ++ [a]).length = w.length + 1
  | [], _ => rfl
  | _ :: w, a => congrArg Nat.succ (length_snoc w a)

/-- Local trace `snoc` helper: appending one final step to a trace. -/
theorem trace_snoc {S : Type u} {A : Type v} {P : Process S A} :
    ∀ {s t u : S} {w : List A} {a : A},
      Trace P s w t → P.step t a u → Trace P s (w ++ [a]) u
  | _, _, _, [], _, .nil _, step => .cons step (.nil _)
  | _, _, _, _ :: _, _, .cons step₁ tail, step₂ => .cons step₁ (trace_snoc tail step₂)

/-- Sample-and-hold closed-loop feedback process over arbitrary `Strict σ`: holds intervention
`st.2.1` across `[σ k, σ (k + 1))` and updates it to `κ (π st'.2.2)` when landing on `σ (k + 1)`. -/
def sampledFeedbackProcess {S : Type u} {A : Type v} {I : Type w} {Q : Type u₁}
    (C : CausalSystem S A I) (σ : Nat → Nat) (π : S → Q) (κ : Q → I) :
    Process (Nat × I × S) A where
  step st a st' :=
    (C.proc st.2.1).step st.2.2 a st'.2.2 ∧
    st'.1 = st.1 + 1 ∧
    st'.2.1 = if Nat.beq (st.1 + 1) (σ (coarsenIndex σ (st.1 + 1)))
      then κ (π st'.2.2) else st.2.1

/-- Block trace decomposition for `sampledFeedbackProcess` from `(t₀, i₀, s)` within `[σ k, σ (k + 1)]`. -/
theorem sampledFeedbackProcess_trace_block {S : Type u} {A : Type v} {I : Type w} {Q : Type u₁}
    {C : CausalSystem S A I} {σ : Nat → Nat} (strict : Strict σ) (π : S → Q) (κ : Q → I) :
    ∀ {k t₀ : Nat} {i₀ : I} {s : S} {w : List A} {st' : Nat × I × S},
      σ k ≤ t₀ → t₀ + w.length ≤ σ (k + 1) →
      Trace (sampledFeedbackProcess C σ π κ) (t₀, i₀, s) w st' →
      st'.1 = t₀ + w.length ∧
      Trace (C.proc i₀) s w st'.2.2 ∧
      (t₀ + w.length < σ (k + 1) → st'.2.1 = i₀) ∧
      (w ≠ [] → t₀ + w.length = σ (k + 1) → st'.2.1 = κ (π st'.2.2))
  | _, t₀, i₀, s, [], (_, _, _), _, _, .nil _ =>
    ⟨rfl, .nil s, fun _ => rfl, fun hne _ => absurd rfl hne⟩
  | k, t₀, i₀, s, a :: rest, st', hle, hbound, .cons (m := m) step restTr => by
    obtain ⟨hstep, hm1, hm2⟩ := step
    have hlt_cur : t₀ + 1 ≤ σ (k + 1) :=
      Nat.le_trans (Nat.add_le_add_left (Nat.succ_pos rest.length) t₀) hbound
    cases Nat.eq_or_lt_of_le hlt_cur with
    | inl hatEnd =>
      have hrest0 : rest.length = 0 := by
        have h1 : (t₀ + 1) + rest.length ≤ t₀ + 1 := by
          have h2 : (t₀ + 1) + rest.length ≤ σ (k + 1) := by
            rw [Nat.add_right_comm t₀ 1 rest.length]
            exact hbound
          exact hatEnd ▸ h2
        have h2 : rest.length ≤ 0 := Naturals.le_of_add_le_add_left h1
        exact Nat.eq_zero_of_le_zero h2
      have hnil : rest = [] := nil_of_length_zero hrest0
      subst hnil
      cases restTr
      have hidx : coarsenIndex σ (t₀ + 1) = k + 1 :=
        hatEnd ▸ coarsenIndex_sample strict (k + 1)
      have hbeq : Nat.beq (t₀ + 1) (σ (coarsenIndex σ (t₀ + 1))) = true := by
        rw [hidx, ← hatEnd]
        exact beq_self (t₀ + 1)
      have hm2' : st'.2.1 = κ (π st'.2.2) := hm2.trans (if_pos hbeq)
      refine ⟨hm1, .cons hstep (.nil _), fun hlt => absurd (hm1 ▸ hatEnd) (Nat.ne_of_lt hlt),
        fun _ _ => hm2'⟩
    | inr hlt_next =>
      have hle_next : σ k ≤ t₀ + 1 := Nat.le_succ_of_le hle
      have hidx : coarsenIndex σ (t₀ + 1) = k := coarsenIndex_eq strict hle_next hlt_next
      have hlt_k : σ k < t₀ + 1 := Nat.lt_of_le_of_lt hle (Nat.lt_succ_self t₀)
      have hbeq : Nat.beq (t₀ + 1) (σ (coarsenIndex σ (t₀ + 1))) = false := by
        rw [hidx]
        exact ListTests.beq_false_of_ne (Naturals.ne_of_lt hlt_k).symm
      have hm2' : m.2.1 = i₀ :=
        hm2.trans (if_neg (fun h => Bool.noConfusion (hbeq.symm.trans h)))
      have hm_eq : m = (t₀ + 1, i₀, m.2.2) := Prod.ext hm1 (Prod.ext hm2' rfl)
      have hbound' : (t₀ + 1) + rest.length ≤ σ (k + 1) := by
        rw [Nat.add_right_comm t₀ 1 rest.length]
        exact hbound
      obtain ⟨hend, tailTr, hstay, hupd⟩ :=
        sampledFeedbackProcess_trace_block strict π κ hle_next hbound' (hm_eq ▸ restTr)
      have hend' : st'.1 = t₀ + (a :: rest).length := by
        rw [hend, Nat.add_right_comm t₀ 1 rest.length]
        rfl
      refine ⟨hend', .cons hstep tailTr, fun hlt => hstay (Nat.add_right_comm t₀ 1 rest.length ▸ hlt),
        fun _ heq => ?_⟩
      cases rest with
      | nil =>
        have hlt_eq : t₀ + 1 = σ (k + 1) := heq
        exact absurd hlt_eq (Naturals.ne_of_lt hlt_next)
      | cons b rest' =>
        exact hupd (fun h => by cases h)
          ((Nat.add_right_comm t₀ 1 (b :: rest').length).symm ▸ heq)

/-- Infinite-horizon sample-and-hold feedback viability transfer over arbitrary `Strict σ`. -/
theorem laxCausal_sampledFeedback_kernel_transfer {S : Type u} {A : Type v} {I : Type w}
    {Q : Type u₁} {B : Type v₁} {J : Type w₁}
    {C₁ : CausalSystem S A I} {C₂ : CausalSystem Q B J}
    {π : S → Q} {ω : I → J} {σ : Nat → Nat} {M : SlackDist Q}
    (lc : LaxCausalAbs C₁ C₂ π ω σ M) (κ : Q → I)
    {guardQ K : Q → Prop} {guardS : S → Prop}
    (Δ : Nat) (absorb : lc.α Δ + lc.ε ≤ Δ)
    (within : ∀ q, K q → guardQ q)
    (ball_closed : ∀ q₁ q₂ b q₂',
      K q₂ → M.d q₁ q₂ ≤ Δ → (C₂.proc (ω (κ q₁))).step q₂ b q₂' → K q₂')
    (margin : ∀ q u, guardQ q → M.d (π u) q ≤ lc.β Δ + lc.η → guardS u)
    {s₀ : S} (epoch₀ : lc.Epoch (σ 0) s₀) (init : K (π s₀)) :
    Viability.Kernel (sampledFeedbackProcess C₁ σ π κ) (fun st => guardS st.2.2)
      (σ 0, κ (π s₀), s₀) := by
  have advance : ∀ (m : Nat) {w : List A} {stEnd : Nat × I × S},
      σ m - σ 0 ≤ w.length →
      Trace (sampledFeedbackProcess C₁ σ π κ) (σ 0, κ (π s₀), s₀) w stEnd →
      ∃ stMid w_rem q_m,
        w_rem.length + (σ m - σ 0) = w.length ∧
        stMid.1 = σ m ∧
        stMid.2.1 = κ (π stMid.2.2) ∧
        Trace (sampledFeedbackProcess C₁ σ π κ) stMid w_rem stEnd ∧
        lc.Epoch (σ m) stMid.2.2 ∧
        K q_m ∧ lc.EpochQ m q_m ∧ M.d (π stMid.2.2) q_m ≤ Δ := by
    intro m
    induction m with
    | zero =>
      intro w stEnd _ tr
      refine ⟨(σ 0, κ (π s₀), s₀), w, π s₀, ?_, rfl, rfl, tr, epoch₀, init,
        lc.epoch_proj 0 s₀ epoch₀, (M.refl (π s₀)).symm ▸ Nat.zero_le Δ⟩
      rw [sub_eq_zero_of_le (Nat.le_refl (σ 0)), Nat.add_zero]
    | succ m ih =>
      intro w stEnd len_ge tr
      have h0m : σ 0 ≤ σ m := strict_mono_le lc.strict (Nat.zero_le m)
      have hmm1 : σ m ≤ σ (m + 1) := Nat.le_of_lt (lc.strict m)
      have h0m1 : σ 0 ≤ σ (m + 1) := Nat.le_trans h0m hmm1
      have h_sub_le : σ m - σ 0 ≤ σ (m + 1) - σ 0 :=
        le_of_add_le_add_right (σ 0)
          (Nat.le_trans (Nat.le_of_eq ((Nat.add_comm _ (σ 0)).trans (add_sub_of_le h0m)))
            (Nat.le_trans hmm1 (Nat.le_of_eq ((Nat.add_comm _ (σ 0)).trans (add_sub_of_le h0m1)).symm)))
      obtain ⟨stM, w_rem, q_m, rem_eq, hst1, hst21, tr_rem, epS, hKq, epQ, hd⟩ :=
        ih (Nat.le_trans h_sub_le len_ge) tr
      have block_eq : (σ m - σ 0) + (σ (m + 1) - σ m) = σ (m + 1) - σ 0 := by
        apply add_right_cancel (σ 0)
        calc (σ m - σ 0) + (σ (m + 1) - σ m) + σ 0
            = (σ (m + 1) - σ m) + (σ m - σ 0) + σ 0 :=
              congrArg (· + σ 0) (Nat.add_comm (σ m - σ 0) (σ (m + 1) - σ m))
          _ = (σ (m + 1) - σ m) + ((σ m - σ 0) + σ 0) :=
              Nat.add_assoc (σ (m + 1) - σ m) (σ m - σ 0) (σ 0)
          _ = (σ (m + 1) - σ m) + σ m := congrArg (_ + ·) (Naturals.sub_add_cancel h0m)
          _ = σ (m + 1) := Naturals.sub_add_cancel hmm1
          _ = (σ (m + 1) - σ 0) + σ 0 := (Naturals.sub_add_cancel h0m1).symm
      have hrem_ge : σ (m + 1) - σ m ≤ w_rem.length := by
        apply Naturals.le_of_add_le_add_left (k := σ m - σ 0)
        rw [block_eq, Nat.add_comm (σ m - σ 0) w_rem.length, rem_eq]
        exact len_ge
      obtain ⟨w₁, w₂, stNext, len₁, sum_len, tr₁, tr₂⟩ := trace_split (σ (m + 1) - σ m) hrem_ge tr_rem
      have hbound : σ m + w₁.length ≤ σ (m + 1) :=
        Nat.le_of_eq ((congrArg (σ m + ·) len₁).trans (add_sub_of_le hmm1))
      have tr₁' : Trace (sampledFeedbackProcess C₁ σ π κ) (σ m, κ (π stM.2.2), stM.2.2) w₁ stNext :=
        (Prod.ext hst1 (Prod.ext hst21 rfl) : stM = (σ m, κ (π stM.2.2), stM.2.2)) ▸ tr₁
      obtain ⟨hend₁, trC₁, _, hupd₁⟩ :=
        sampledFeedbackProcess_trace_block lc.strict π κ (Nat.le_refl (σ m)) hbound tr₁'
      have hne : w₁ ≠ [] := fun hnil => by
        have h0' : 0 = σ (m + 1) - σ m := (congrArg List.length hnil).symm.trans len₁
        exact Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le (SupportGated.sub_pos_of_lt (lc.strict m)) (Nat.le_of_eq h0'.symm))
      have heq_end : σ m + w₁.length = σ (m + 1) := (congrArg (σ m + ·) len₁).trans (add_sub_of_le hmm1)
      have hnext1 : stNext.1 = σ (m + 1) := hend₁.trans heq_end
      have hnext21 : stNext.2.1 = κ (π stNext.2.2) := hupd₁ hne heq_end
      obtain ⟨b, q', stepQ, epQ', hd'⟩ :=
        lc.sim_block (κ (π stM.2.2)) m stM.2.2 q_m Δ w₁ stNext.2.2 epS epQ hd len₁ trC₁
      have hKq' : K q' := ball_closed (π stM.2.2) q_m b q' hKq hd stepQ
      have hd_le' : M.d (π stNext.2.2) q' ≤ Δ := Nat.le_trans hd' absorb
      have epS' : lc.Epoch (σ (m + 1)) stNext.2.2 :=
        Eq.subst (motive := fun n => lc.Epoch n stNext.2.2) heq_end (LaxSim.epoch_trace (lc.toLaxSim _) epS trC₁)
      have total_rem : w₂.length + (σ (m + 1) - σ 0) = w.length := by
        calc w₂.length + (σ (m + 1) - σ 0)
            = w₂.length + ((σ m - σ 0) + (σ (m + 1) - σ m)) := congrArg (w₂.length + ·) block_eq.symm
          _ = w₂.length + ((σ (m + 1) - σ m) + (σ m - σ 0)) := congrArg (w₂.length + ·) (Nat.add_comm _ _)
          _ = (w₂.length + w₁.length) + (σ m - σ 0) :=
              (Nat.add_assoc _ _ _).symm.trans (congrArg (· + (σ m - σ 0)) (congrArg (w₂.length + ·) len₁.symm))
          _ = w_rem.length + (σ m - σ 0) := congrArg (· + (σ m - σ 0)) ((Nat.add_comm _ _).trans sum_len)
          _ = w.length := rem_eq
      exact ⟨stNext, w₂, q', total_rem, hnext1, hnext21, tr₂, epS', hKq', epQ', hd_le'⟩
  intro stEnd ⟨w, tr⟩
  obtain ⟨k, hk_le, hk_lt⟩ := block_of_strict lc.strict (Nat.le_add_right (σ 0) w.length)
  have h0k : σ 0 ≤ σ k := strict_mono_le lc.strict (Nat.zero_le k)
  have hlen : σ k - σ 0 ≤ w.length := Naturals.sub_le_of_le_add hk_le
  obtain ⟨stK, w_rem, q_k, rem_eq, hk1, hk21, tr_rem, epS, hKq, epQ, hd⟩ :=
    advance k hlen tr
  have h_rem_lt : w_rem.length < σ (k + 1) - σ k := by
    apply Naturals.lt_of_add_lt_add_left (k := σ k)
    have eq1 : σ k + w_rem.length = σ 0 + w.length := by
      calc σ k + w_rem.length
          = (σ 0 + (σ k - σ 0)) + w_rem.length := congrArg (· + w_rem.length) (add_sub_of_le h0k).symm
        _ = σ 0 + (w_rem.length + (σ k - σ 0)) := (Nat.add_assoc _ _ _).trans (congrArg (σ 0 + ·) (Nat.add_comm _ _))
        _ = σ 0 + w.length := congrArg (σ 0 + ·) rem_eq
    rw [eq1]
    exact Nat.lt_of_lt_of_le hk_lt (Nat.le_of_eq (add_sub_of_le (Nat.le_of_lt (lc.strict k))).symm)
  have hbound : σ k + w_rem.length ≤ σ (k + 1) :=
    Nat.le_trans (Nat.add_le_add_left (Nat.le_of_lt h_rem_lt) (σ k))
      (Nat.le_of_eq (add_sub_of_le (Nat.le_of_lt (lc.strict k))))
  have tr_rem' : Trace (sampledFeedbackProcess C₁ σ π κ) (σ k, κ (π stK.2.2), stK.2.2) w_rem stEnd :=
    (Prod.ext hk1 (Prod.ext hk21 rfl) : stK = (σ k, κ (π stK.2.2), stK.2.2)) ▸ tr_rem
  obtain ⟨_, trC₁, _, _⟩ :=
    sampledFeedbackProcess_trace_block lc.strict π κ (Nat.le_refl (σ k)) hbound tr_rem'
  have d_ex := lc.excursion (κ (π stK.2.2)) k stK.2.2 q_k Δ w_rem stEnd.2.2 epS epQ hd h_rem_lt trC₁
  exact margin q_k stEnd.2.2 (within q_k hKq) d_ex

/-! ## Part 3: Vertical Tower & Horizontal Open Composition + Leakage Witness -/

/-! ### Vertical Tower Composition -/

/-- Vertical composition of exact causal abstractions. -/
theorem ExactCausalAbs.comp {S : Type u} {A : Type v} {I : Type w}
    {Q : Type u₁} {B : Type v₁} {J : Type w₁}
    {R : Type u₂} {D : Type v₂} {K : Type w₂}
    {C₁ : CausalSystem S A I} {C₂ : CausalSystem Q B J} {C₃ : CausalSystem R D K}
    {π₁ : S → Q} {φ₁ : A → B} {ω₁ : I → J}
    {π₂ : Q → R} {φ₂ : B → D} {ω₂ : J → K}
    (abs₁ : ExactCausalAbs C₁ C₂ π₁ φ₁ ω₁) (abs₂ : ExactCausalAbs C₂ C₃ π₂ φ₂ ω₂) :
    ExactCausalAbs C₁ C₃ (fun s => π₂ (π₁ s)) (fun a => φ₂ (φ₁ a)) (fun i => ω₂ (ω₁ i)) where
  obs_eq := (congrArg ω₂ abs₁.obs_eq).trans abs₂.obs_eq
  factors i s a s' step := abs₂.factors (ω₁ i) (π₁ s) (φ₁ a) (π₁ s') (abs₁.factors i s a s' step)

/-- Fibrewise lifting composes vertically. -/
theorem ExactCausalAbs.Lifts.comp {S : Type u} {A : Type v} {I : Type w}
    {Q : Type u₁} {B : Type v₁} {J : Type w₁}
    {R : Type u₂} {D : Type v₂} {K : Type w₂}
    {C₁ : CausalSystem S A I} {C₂ : CausalSystem Q B J} {C₃ : CausalSystem R D K}
    {π₁ : S → Q} {φ₁ : A → B} {ω₁ : I → J}
    {π₂ : Q → R} {φ₂ : B → D} {ω₂ : J → K}
    {abs₁ : ExactCausalAbs C₁ C₂ π₁ φ₁ ω₁} {abs₂ : ExactCausalAbs C₂ C₃ π₂ φ₂ ω₂}
    (lifts₁ : abs₁.Lifts) (lifts₂ : abs₂.Lifts) :
    (abs₁.comp abs₂).Lifts := by
  intro i s c r' step₃
  obtain ⟨b, q', hφ₂, step₂, hr'⟩ := lifts₂ (ω₁ i) (π₁ s) c r' step₃
  obtain ⟨a, s', hφ₁, step₁, hq'⟩ := lifts₁ i s b q' step₂
  exact ⟨a, s', (congrArg φ₂ hφ₁).trans hφ₂, step₁, (congrArg π₂ hq').trans hr'⟩

/-- Vertical tower composition (contractive scale-1 mode), delegating to `LaxSim.comp`. -/
def LaxCausalAbs.comp {S : Type u} {A : Type v} {I : Type w}
    {Q₁ : Type u₁} {B₁ : Type v₁} {J₁ : Type w₁}
    {Q₂ : Type u₂} {B₂ : Type v₂} {J₂ : Type w₂}
    {C₁ : CausalSystem S A I} {C₂ : CausalSystem Q₁ B₁ J₁} {C₃ : CausalSystem Q₂ B₂ J₂}
    {π₁ : S → Q₁} {ω₁ : I → J₁} {σ₁ : Nat → Nat} {M₁ : SlackDist Q₁}
    {π₂ : Q₁ → Q₂} {ω₂ : J₁ → J₂} {σ₂ : Nat → Nat} {M₂ : SlackDist Q₂}
    (lc₁ : LaxCausalAbs C₁ C₂ π₁ ω₁ σ₁ M₁) (lc₂ : LaxCausalAbs C₂ C₃ π₂ ω₂ σ₂ M₂)
    (epoch_compat : ∀ j q₁, lc₁.EpochQ j q₁ → lc₂.Epoch j q₁)
    (μ₂ : Nat → Nat) (μ₂_mono : ∀ {a b}, a ≤ b → μ₂ a ≤ μ₂ b)
    (lip₂ : ∀ x y, M₂.d (π₂ x) (π₂ y) ≤ μ₂ (M₁.d x y))
    (Δ₁ : Nat) (absorb₁ : lc₁.α Δ₁ + lc₁.ε ≤ Δ₁) :
    LaxCausalAbs C₁ C₃ (fun s => π₂ (π₁ s)) (fun i => ω₂ (ω₁ i)) (fun k => σ₁ (σ₂ k)) M₂ where
  obs_eq := (congrArg ω₂ lc₁.obs_eq).trans lc₂.obs_eq
  strict := lc₁.strict.comp lc₂.strict
  Epoch := lc₁.Epoch
  EpochQ := lc₂.EpochQ
  epoch_step := lc₁.epoch_step
  epoch_proj k s ep :=
    lc₂.epoch_proj k (π₁ s) (epoch_compat (σ₂ k) (π₁ s) (lc₁.epoch_proj (σ₂ k) s ep))
  α := lc₂.α
  β := lc₂.β
  α_mono := lc₂.α_mono
  β_mono := lc₂.β_mono
  β_ge_id := lc₂.β_ge_id
  ε := lc₂.ε + μ₂ Δ₁
  η := lc₂.η + μ₂ (lc₁.β Δ₁ + lc₁.η)
  sim_block i :=
    (LaxSim.comp (lc₁.toLaxSim i) (lc₂.toLaxSim (ω₁ i)) epoch_compat μ₂ μ₂_mono lip₂ Δ₁ absorb₁).sim_block
  excursion i :=
    (LaxSim.comp (lc₁.toLaxSim i) (lc₂.toLaxSim (ω₁ i)) epoch_compat μ₂ μ₂_mono lip₂ Δ₁ absorb₁).excursion

/-- Vertical tower composition (bounded-stride additive scale-1 mode), delegating to
`LaxSim.compAdditive`. -/
def LaxCausalAbs.compAdditive {S : Type u} {A : Type v} {I : Type w}
    {Q₁ : Type u₁} {B₁ : Type v₁} {J₁ : Type w₁}
    {Q₂ : Type u₂} {B₂ : Type v₂} {J₂ : Type w₂}
    {C₁ : CausalSystem S A I} {C₂ : CausalSystem Q₁ B₁ J₁} {C₃ : CausalSystem Q₂ B₂ J₂}
    {π₁ : S → Q₁} {ω₁ : I → J₁} {σ₁ : Nat → Nat} {M₁ : SlackDist Q₁}
    {π₂ : Q₁ → Q₂} {ω₂ : J₁ → J₂} {σ₂ : Nat → Nat} {M₂ : SlackDist Q₂}
    (lc₁ : LaxCausalAbs C₁ C₂ π₁ ω₁ σ₁ M₁) (lc₂ : LaxCausalAbs C₂ C₃ π₂ ω₂ σ₂ M₂)
    (epoch_compat : ∀ j q₁, lc₁.EpochQ j q₁ → lc₂.Epoch j q₁)
    (μ₂ : Nat → Nat) (μ₂_mono : ∀ {a b}, a ≤ b → μ₂ a ≤ μ₂ b)
    (lip₂ : ∀ x y, M₂.d (π₂ x) (π₂ y) ≤ μ₂ (M₁.d x y))
    (lin₁ : lc₁.α = id) (Mstride : Nat) (stride_bound : ∀ k, σ₂ (k + 1) - σ₂ k ≤ Mstride) :
    LaxCausalAbs C₁ C₃ (fun s => π₂ (π₁ s)) (fun i => ω₂ (ω₁ i)) (fun k => σ₁ (σ₂ k)) M₂ where
  obs_eq := (congrArg ω₂ lc₁.obs_eq).trans lc₂.obs_eq
  strict := lc₁.strict.comp lc₂.strict
  Epoch := lc₁.Epoch
  EpochQ := lc₂.EpochQ
  epoch_step := lc₁.epoch_step
  epoch_proj k s ep :=
    lc₂.epoch_proj k (π₁ s) (epoch_compat (σ₂ k) (π₁ s) (lc₁.epoch_proj (σ₂ k) s ep))
  α := lc₂.α
  β := lc₂.β
  α_mono := lc₂.α_mono
  β_mono := lc₂.β_mono
  β_ge_id := lc₂.β_ge_id
  ε := lc₂.ε + μ₂ (Mstride * lc₁.ε)
  η := lc₂.η + μ₂ (lc₁.β ((Mstride - 1) * lc₁.ε) + lc₁.η)
  sim_block i :=
    (LaxSim.compAdditive (lc₁.toLaxSim i) (lc₂.toLaxSim (ω₁ i))
      epoch_compat μ₂ μ₂_mono lip₂ lin₁ Mstride stride_bound).sim_block
  excursion i :=
    (LaxSim.compAdditive (lc₁.toLaxSim i) (lc₂.toLaxSim (ω₁ i))
      epoch_compat μ₂ μ₂_mono lip₂ lin₁ Mstride stride_bound).excursion

/-- One-step vertical composition (`σ₂ = id`): requires neither scale-1 contraction nor
`lc₁.α = id`. -/
def LaxCausalAbs.compOneStep {S : Type u} {A : Type v} {I : Type w}
    {Q₁ : Type u₁} {B₁ : Type v₁} {J₁ : Type w₁}
    {Q₂ : Type u₂} {B₂ : Type v₂} {J₂ : Type w₂}
    {C₁ : CausalSystem S A I} {C₂ : CausalSystem Q₁ B₁ J₁} {C₃ : CausalSystem Q₂ B₂ J₂}
    {π₁ : S → Q₁} {ω₁ : I → J₁} {σ₁ : Nat → Nat} {M₁ : SlackDist Q₁}
    {π₂ : Q₁ → Q₂} {ω₂ : J₁ → J₂} {M₂ : SlackDist Q₂}
    (lc₁ : LaxCausalAbs C₁ C₂ π₁ ω₁ σ₁ M₁) (lc₂ : LaxCausalAbs C₂ C₃ π₂ ω₂ id M₂)
    (epoch_compat : ∀ j q₁, lc₁.EpochQ j q₁ → lc₂.Epoch j q₁)
    (μ₂ : Nat → Nat) (μ₂_mono : ∀ {a b}, a ≤ b → μ₂ a ≤ μ₂ b)
    (lip₂ : ∀ x y, M₂.d (π₂ x) (π₂ y) ≤ μ₂ (M₁.d x y)) :
    LaxCausalAbs C₁ C₃ (fun s => π₂ (π₁ s)) (fun i => ω₂ (ω₁ i)) σ₁ M₂ where
  obs_eq := (congrArg ω₂ lc₁.obs_eq).trans lc₂.obs_eq
  strict := lc₁.strict
  Epoch := lc₁.Epoch
  EpochQ := lc₂.EpochQ
  epoch_step := lc₁.epoch_step
  epoch_proj k s ep :=
    lc₂.epoch_proj k (π₁ s) (epoch_compat k (π₁ s) (lc₁.epoch_proj k s ep))
  α := lc₂.α
  β := lc₂.β
  α_mono := lc₂.α_mono
  β_mono := lc₂.β_mono
  β_ge_id := lc₂.β_ge_id
  ε := lc₂.ε + μ₂ (lc₁.α 0 + lc₁.ε)
  η := lc₂.η + μ₂ (lc₁.β 0 + lc₁.η)
  sim_block i k s q₂ r w s' epS epQ₂ d_le w_len tr := by
    have epQ₁ := lc₁.epoch_proj k s epS
    have hd0 : M₁.d (π₁ s) (π₁ s) ≤ 0 := Nat.le_of_eq (M₁.refl (π₁ s))
    obtain ⟨b₁, q₁', step₁, _, hd₁⟩ :=
      lc₁.sim_block i k s (π₁ s) 0 w s' epS epQ₁ hd0 w_len tr
    have epS₂ : lc₂.Epoch k (π₁ s) := epoch_compat k (π₁ s) epQ₁
    obtain ⟨b₂, q₂', step₂, epQ₂', hd₂⟩ :=
      lc₂.sim_block (ω₁ i) k (π₁ s) q₂ r [b₁] q₁' epS₂ epQ₂ d_le (succ_sub_self k).symm
        (.cons step₁ (.nil _))
    refine ⟨b₂, q₂', step₂, epQ₂', ?_⟩
    calc M₂.d (π₂ (π₁ s')) q₂'
        ≤ M₂.d (π₂ (π₁ s')) (π₂ q₁') + M₂.d (π₂ q₁') q₂' := M₂.tri _ _ _
      _ ≤ μ₂ (M₁.d (π₁ s') q₁') + (lc₂.α r + lc₂.ε) := Nat.add_le_add (lip₂ _ _) hd₂
      _ ≤ μ₂ (lc₁.α 0 + lc₁.ε) + (lc₂.α r + lc₂.ε) := Nat.add_le_add_right (μ₂_mono hd₁) _
      _ = lc₂.α r + (lc₂.ε + μ₂ (lc₁.α 0 + lc₁.ε)) :=
          (Nat.add_comm _ _).trans (Nat.add_assoc (lc₂.α r) lc₂.ε _)
  excursion i k s q₂ r w₁ u epS epQ₂ d_le w₁_lt tr := by
    have epQ₁ := lc₁.epoch_proj k s epS
    have hd0 : M₁.d (π₁ s) (π₁ s) ≤ 0 := Nat.le_of_eq (M₁.refl (π₁ s))
    have hd₁ := lc₁.excursion i k s (π₁ s) 0 w₁ u epS epQ₁ hd0 w₁_lt tr
    have htri := M₂.tri (π₂ (π₁ u)) (π₂ (π₁ s)) q₂
    have d_le_β : M₂.d (π₂ (π₁ s)) q₂ ≤ lc₂.β r + lc₂.η :=
      Nat.le_trans d_le (Nat.le_trans (lc₂.β_ge_id r) (Nat.le_add_right _ _))
    calc M₂.d (π₂ (π₁ u)) q₂
        ≤ M₂.d (π₂ (π₁ u)) (π₂ (π₁ s)) + M₂.d (π₂ (π₁ s)) q₂ := htri
      _ ≤ μ₂ (M₁.d (π₁ u) (π₁ s)) + (lc₂.β r + lc₂.η) := Nat.add_le_add (lip₂ _ _) d_le_β
      _ ≤ μ₂ (lc₁.β 0 + lc₁.η) + (lc₂.β r + lc₂.η) := Nat.add_le_add_right (μ₂_mono hd₁) _
      _ = lc₂.β r + (lc₂.η + μ₂ (lc₁.β 0 + lc₁.η)) :=
          (Nat.add_comm _ _).trans (Nat.add_assoc (lc₂.β r) lc₂.η _)

/-! ### Horizontal Product & Open Composition (`: Type` for `OpenComposition`) -/

/-- Horizontal product of two exact causal abstractions. -/
theorem ExactCausalAbs.prod {S₁ : Type u} {A₁ : Type v} {I₁ : Type w}
    {S₂ : Type u₁} {A₂ : Type v₁} {I₂ : Type w₁}
    {Q₁ : Type u₂} {B₁ : Type v₂} {J₁ : Type w₂}
    {Q₂ : Type} {B₂ : Type} {J₂ : Type}
    {C₁ : CausalSystem S₁ A₁ I₁} {C₂ : CausalSystem S₂ A₂ I₂}
    {D₁ : CausalSystem Q₁ B₁ J₁} {D₂ : CausalSystem Q₂ B₂ J₂}
    {π₁ : S₁ → Q₁} {φ₁ : A₁ → B₁} {ω₁ : I₁ → J₁}
    {π₂ : S₂ → Q₂} {φ₂ : A₂ → B₂} {ω₂ : I₂ → J₂}
    (abs₁ : ExactCausalAbs C₁ D₁ π₁ φ₁ ω₁) (abs₂ : ExactCausalAbs C₂ D₂ π₂ φ₂ ω₂) :
    ExactCausalAbs (C₁.prod C₂) (D₁.prod D₂)
      (fun s => (π₁ s.1, π₂ s.2)) (fun a => (φ₁ a.1, φ₂ a.2)) (fun i => (ω₁ i.1, ω₂ i.2)) where
  obs_eq := Prod.ext abs₁.obs_eq abs₂.obs_eq
  factors i s a s' step :=
    ⟨abs₁.factors i.1 s.1 a.1 s'.1 step.1, abs₂.factors i.2 s.2 a.2 s'.2 step.2⟩

/-- Horizontal $\ell_\infty$ (`SlackDist.max`) product of two `LaxCausalAbs` sharing `σ`, delegating to
`OpenComposition.compose_laxSim_max`. -/
def LaxCausalAbs.prodMax {S₁ A₁ I₁ S₂ A₂ I₂ Q₁ B₁ J₁ Q₂ B₂ J₂ : Type}
    {C₁ : CausalSystem S₁ A₁ I₁} {C₂ : CausalSystem S₂ A₂ I₂}
    {D₁ : CausalSystem Q₁ B₁ J₁} {D₂ : CausalSystem Q₂ B₂ J₂}
    {π₁ : S₁ → Q₁} {ω₁ : I₁ → J₁} {M₁ : SlackDist Q₁}
    {π₂ : S₂ → Q₂} {ω₂ : I₂ → J₂} {M₂ : SlackDist Q₂}
    {σ : Nat → Nat}
    (lc₁ : LaxCausalAbs C₁ D₁ π₁ ω₁ σ M₁) (lc₂ : LaxCausalAbs C₂ D₂ π₂ ω₂ σ M₂) :
    LaxCausalAbs (C₁.prod C₂) (D₁.prod D₂)
      (fun s => (π₁ s.1, π₂ s.2)) (fun i => (ω₁ i.1, ω₂ i.2)) σ
      (OpenComposition.SlackDist.max M₁ M₂) where
  obs_eq := Prod.ext lc₁.obs_eq lc₂.obs_eq
  strict := lc₁.strict
  Epoch t s := lc₁.Epoch t s.1 ∧ lc₂.Epoch t s.2
  EpochQ k q := lc₁.EpochQ k q.1 ∧ lc₂.EpochQ k q.2
  epoch_step i t s a s' ep step :=
    ⟨lc₁.epoch_step i.1 t s.1 a.1 s'.1 ep.1 step.1,
     lc₂.epoch_step i.2 t s.2 a.2 s'.2 ep.2 step.2⟩
  epoch_proj k s ep := ⟨lc₁.epoch_proj k s.1 ep.1, lc₂.epoch_proj k s.2 ep.2⟩
  α r := CoreHelpers.natMax (lc₁.α r) (lc₂.α r)
  β r := CoreHelpers.natMax (lc₁.β r) (lc₂.β r)
  α_mono le := CoreHelpers.natMax_le
    (Nat.le_trans (lc₁.α_mono le) (CoreHelpers.le_natMax_left _ _))
    (Nat.le_trans (lc₂.α_mono le) (CoreHelpers.le_natMax_right _ _))
  β_mono le := CoreHelpers.natMax_le
    (Nat.le_trans (lc₁.β_mono le) (CoreHelpers.le_natMax_left _ _))
    (Nat.le_trans (lc₂.β_mono le) (CoreHelpers.le_natMax_right _ _))
  β_ge_id r := Nat.le_trans (lc₁.β_ge_id r) (CoreHelpers.le_natMax_left _ _)
  ε := CoreHelpers.natMax lc₁.ε lc₂.ε
  η := CoreHelpers.natMax lc₁.η lc₂.η
  sim_block i :=
    (OpenComposition.compose_laxSim_max (lc₁.toLaxSim i.1) (lc₂.toLaxSim i.2)).sim_block
  excursion i :=
    (OpenComposition.compose_laxSim_max (lc₁.toLaxSim i.1) (lc₂.toLaxSim i.2)).excursion

/-- Horizontal $\ell_1$ (`SlackDist.sum`) product of two `LaxCausalAbs` sharing `σ`, delegating to
`OpenComposition.compose_laxSim_sum`. -/
def LaxCausalAbs.prodSum {S₁ A₁ I₁ S₂ A₂ I₂ Q₁ B₁ J₁ Q₂ B₂ J₂ : Type}
    {C₁ : CausalSystem S₁ A₁ I₁} {C₂ : CausalSystem S₂ A₂ I₂}
    {D₁ : CausalSystem Q₁ B₁ J₁} {D₂ : CausalSystem Q₂ B₂ J₂}
    {π₁ : S₁ → Q₁} {ω₁ : I₁ → J₁} {M₁ : SlackDist Q₁}
    {π₂ : S₂ → Q₂} {ω₂ : I₂ → J₂} {M₂ : SlackDist Q₂}
    {σ : Nat → Nat}
    (lc₁ : LaxCausalAbs C₁ D₁ π₁ ω₁ σ M₁) (lc₂ : LaxCausalAbs C₂ D₂ π₂ ω₂ σ M₂)
    (α_comb β_comb : Nat → Nat)
    (α_mono : ∀ {a b}, a ≤ b → α_comb a ≤ α_comb b)
    (β_mono : ∀ {a b}, a ≤ b → β_comb a ≤ β_comb b)
    (β_ge_id : ∀ r, r ≤ β_comb r)
    (α_bound : ∀ r₁ r₂, lc₁.α r₁ + lc₂.α r₂ ≤ α_comb (r₁ + r₂))
    (β_bound : ∀ r₁ r₂, lc₁.β r₁ + lc₂.β r₂ ≤ β_comb (r₁ + r₂)) :
    LaxCausalAbs (C₁.prod C₂) (D₁.prod D₂)
      (fun s => (π₁ s.1, π₂ s.2)) (fun i => (ω₁ i.1, ω₂ i.2)) σ
      (OpenComposition.SlackDist.sum M₁ M₂) where
  obs_eq := Prod.ext lc₁.obs_eq lc₂.obs_eq
  strict := lc₁.strict
  Epoch t s := lc₁.Epoch t s.1 ∧ lc₂.Epoch t s.2
  EpochQ k q := lc₁.EpochQ k q.1 ∧ lc₂.EpochQ k q.2
  epoch_step i t s a s' ep step :=
    ⟨lc₁.epoch_step i.1 t s.1 a.1 s'.1 ep.1 step.1,
     lc₂.epoch_step i.2 t s.2 a.2 s'.2 ep.2 step.2⟩
  epoch_proj k s ep := ⟨lc₁.epoch_proj k s.1 ep.1, lc₂.epoch_proj k s.2 ep.2⟩
  α := α_comb
  β := β_comb
  α_mono := α_mono
  β_mono := β_mono
  β_ge_id := β_ge_id
  ε := lc₁.ε + lc₂.ε
  η := lc₁.η + lc₂.η
  sim_block i :=
    (OpenComposition.compose_laxSim_sum (lc₁.toLaxSim i.1) (lc₂.toLaxSim i.2)
      α_comb β_comb α_mono β_mono β_ge_id α_bound β_bound).sim_block
  excursion i :=
    (OpenComposition.compose_laxSim_sum (lc₁.toLaxSim i.1) (lc₂.toLaxSim i.2)
      α_comb β_comb α_mono β_mono β_ge_id α_bound β_bound).excursion

/-- Boundary-locality step split on `CausalSystem.ofOpenComposite`. -/
theorem ofOpenComposite_step_iff {S₁ S₂ Obs₁ Obs₂ Dist₁ Dist₂ Int₁ Int₂ Ext : Type}
    (A : OpenComposition.OpenComponent S₁ Obs₁ Dist₁ Int₁ Ext)
    (B : OpenComposition.OpenComponent S₂ Obs₂ Dist₂ Int₂ Ext)
    (tol₁ : Obs₁ × Bool → Dist₁ → Prop) (tol₂ : Obs₂ × Bool → Dist₂ → Prop)
    (ov : (Option Obs₁ × Option Obs₂) × Option Bool)
    (s s' : S₁ × S₂) (m : ((Obs₁ × Obs₂) × Bool) × (Dist₁ × Dist₂)) :
    ((CausalSystem.ofOpenComposite A B tol₁ tol₂).proc ov).step s m s' ↔
      ((CausalSystem.ofOpenComponent A tol₁).proc (ov.1.1, ov.2)).step s.1 ((m.1.1.1, m.1.2), m.2.1) s'.1 ∧
      ((CausalSystem.ofOpenComponent B tol₂).proc (ov.1.2, ov.2)).step s.2 ((m.1.1.2, m.1.2), m.2.2) s'.2 :=
  ⟨fun ⟨⟨h1, h2⟩, hs⟩ => ⟨⟨h1, congrArg Prod.fst hs⟩, ⟨h2, congrArg Prod.snd hs⟩⟩,
   fun ⟨⟨h1, hs1⟩, ⟨h2, hs2⟩⟩ => ⟨⟨h1, h2⟩, Prod.ext hs1 hs2⟩⟩

/-- Boundary-locality non-interference on `ofOpenComposite`: intervening only on `B`'s observation
port `ov₂` leaves `A`'s component step identical to passive `A.process tol₁` (and symmetrically). -/
theorem ofOpenComposite_boundary_local {S₁ S₂ Obs₁ Obs₂ Dist₁ Dist₂ Int₁ Int₂ Ext : Type}
    (A : OpenComposition.OpenComponent S₁ Obs₁ Dist₁ Int₁ Ext)
    (B : OpenComposition.OpenComponent S₂ Obs₂ Dist₂ Int₂ Ext)
    (tol₁ : Obs₁ × Bool → Dist₁ → Prop) (tol₂ : Obs₂ × Bool → Dist₂ → Prop)
    (ov₂ : Option Obs₂) (s s' : S₁ × S₂) (m : ((Obs₁ × Obs₂) × Bool) × (Dist₁ × Dist₂)) :
    ((CausalSystem.ofOpenComposite A B tol₁ tol₂).proc ((none, ov₂), none)).step s m s' →
      (A.process tol₁).step s.1 ((m.1.1.1, m.1.2), m.2.1) s'.1 :=
  fun step => ((ofOpenComposite_step_iff A B tol₁ tol₂ ((none, ov₂), none) s s' m).mp step).1

/-- Exact causal abstraction composes over open component gluing given intervention-split coherence
`ω₁_split`, `ω₂_split` and shared alarm synchronization `alarm_match` (CRITICAL FIX B3). -/
theorem ExactCausalAbs.composeOpen
    {S₁ S₂ Obs₁ Obs₂ Dist₁ Dist₂ Int₁ Int₂ Ext : Type}
    {S₁' S₂' Obs₁' Obs₂' Dist₁' Dist₂' Int₁' Int₂' Ext' : Type}
    {A₁ : OpenComposition.OpenComponent S₁ Obs₁ Dist₁ Int₁ Ext}
    {A₂ : OpenComposition.OpenComponent S₂ Obs₂ Dist₂ Int₂ Ext}
    {B₁ : OpenComposition.OpenComponent S₁' Obs₁' Dist₁' Int₁' Ext'}
    {B₂ : OpenComposition.OpenComponent S₂' Obs₂' Dist₂' Int₂' Ext'}
    {tol₁ : Obs₁ × Bool → Dist₁ → Prop} {tol₂ : Obs₂ × Bool → Dist₂ → Prop}
    {tol₁' : Obs₁' × Bool → Dist₁' → Prop} {tol₂' : Obs₂' × Bool → Dist₂' → Prop}
    {π₁ : S₁ → S₁'} {π₂ : S₂ → S₂'}
    {φ₁ : (Obs₁ × Bool) × Dist₁ → (Obs₁' × Bool) × Dist₁'}
    {φ₂ : (Obs₂ × Bool) × Dist₂ → (Obs₂' × Bool) × Dist₂'}
    {ω₁ : Option Obs₁ × Option Bool → Option Obs₁' × Option Bool}
    {ω₂ : Option Obs₂ × Option Bool → Option Obs₂' × Option Bool}
    (abs₁ : ExactCausalAbs (CausalSystem.ofOpenComponent A₁ tol₁)
      (CausalSystem.ofOpenComponent B₁ tol₁') π₁ φ₁ ω₁)
    (abs₂ : ExactCausalAbs (CausalSystem.ofOpenComponent A₂ tol₂)
      (CausalSystem.ofOpenComponent B₂ tol₂') π₂ φ₂ ω₂)
    (ω : (Option Obs₁ × Option Obs₂) × Option Bool → (Option Obs₁' × Option Obs₂') × Option Bool)
    (ω₁_split : ∀ ov, ((ω ov).1.1, (ω ov).2) = ω₁ (ov.1.1, ov.2))
    (ω₂_split : ∀ ov, ((ω ov).1.2, (ω ov).2) = ω₂ (ov.1.2, ov.2))
    (alarm_match : ∀ o₁ o₂ al d₁ d₂, (φ₁ ((o₁, al), d₁)).1.2 = (φ₂ ((o₂, al), d₂)).1.2) :
    ExactCausalAbs
      (CausalSystem.ofOpenComposite A₁ A₂ tol₁ tol₂)
      (CausalSystem.ofOpenComposite B₁ B₂ tol₁' tol₂')
      (fun s => (π₁ s.1, π₂ s.2))
      (fun m =>
        let b₁ := φ₁ ((m.1.1.1, m.1.2), m.2.1)
        let b₂ := φ₂ ((m.1.1.2, m.1.2), m.2.2)
        (((b₁.1.1, b₂.1.1), b₁.1.2), (b₁.2, b₂.2)))
      ω where
  obs_eq := by
    have h1 := (ω₁_split ((none, none), none)).trans abs₁.obs_eq
    have h2 := (ω₂_split ((none, none), none)).trans abs₂.obs_eq
    have h1a : (ω ((none, none), none)).1.1 = none := congrArg Prod.fst h1
    have h1b : (ω ((none, none), none)).2 = none := congrArg Prod.snd h1
    have h2a : (ω ((none, none), none)).1.2 = none := congrArg Prod.fst h2
    exact Prod.ext (Prod.ext h1a h2a) h1b
  factors ov s m s' step := by
    obtain ⟨hstep₁, hstep₂⟩ :=
      (ofOpenComposite_step_iff A₁ A₂ tol₁ tol₂ ov s s' m).mp step
    have h₁ := abs₁.factors (ov.1.1, ov.2) s.1 ((m.1.1.1, m.1.2), m.2.1) s'.1 hstep₁
    have h₂ := abs₂.factors (ov.1.2, ov.2) s.2 ((m.1.1.2, m.1.2), m.2.2) s'.2 hstep₂
    rw [← ω₁_split ov] at h₁
    rw [← ω₂_split ov] at h₂
    have hal : (φ₁ ((m.1.1.1, m.1.2), m.2.1)).1.2 = (φ₂ ((m.1.1.2, m.1.2), m.2.2)).1.2 :=
      alarm_match m.1.1.1 m.1.1.2 m.1.2 m.2.1 m.2.2
    have h₁' : ((CausalSystem.ofOpenComponent B₁ tol₁').proc ((ω ov).1.1, (ω ov).2)).step
        (π₁ s.1)
        ((((φ₁ ((m.1.1.1, m.1.2), m.2.1)).1.1, (φ₁ ((m.1.1.1, m.1.2), m.2.1)).1.2),
          (φ₁ ((m.1.1.1, m.1.2), m.2.1)).2))
        (π₁ s'.1) := h₁
    have h₂' : ((CausalSystem.ofOpenComponent B₂ tol₂').proc ((ω ov).1.2, (ω ov).2)).step
        (π₂ s.2)
        ((((φ₂ ((m.1.1.2, m.1.2), m.2.2)).1.1, (φ₂ ((m.1.1.2, m.1.2), m.2.2)).1.2),
          (φ₂ ((m.1.1.2, m.1.2), m.2.2)).2))
        (π₂ s'.2) := h₂
    rw [← hal] at h₂'
    exact (ofOpenComposite_step_iff B₁ B₂ tol₁' tol₂' (ω ov) (π₁ s.1, π₂ s.2) (π₁ s'.1, π₂ s'.2)
      ((((φ₁ ((m.1.1.1, m.1.2), m.2.1)).1.1, (φ₂ ((m.1.1.2, m.1.2), m.2.2)).1.1),
        (φ₁ ((m.1.1.1, m.1.2), m.2.1)).1.2),
       ((φ₁ ((m.1.1.1, m.1.2), m.2.1)).2, (φ₂ ((m.1.1.2, m.1.2), m.2.2)).2))).mpr ⟨h₁', h₂'⟩

private theorem openComposite_trace_left {S₁ S₂ Obs₁ Obs₂ Dist₁ Dist₂ Int₁ Int₂ Ext : Type}
    {A₁ : OpenComposition.OpenComponent S₁ Obs₁ Dist₁ Int₁ Ext}
    {A₂ : OpenComposition.OpenComponent S₂ Obs₂ Dist₂ Int₂ Ext}
    {tol₁ : Obs₁ × Bool → Dist₁ → Prop} {tol₂ : Obs₂ × Bool → Dist₂ → Prop}
    (ov : (Option Obs₁ × Option Obs₂) × Option Bool) :
    ∀ {s s' : S₁ × S₂} {w : List (((Obs₁ × Obs₂) × Bool) × (Dist₁ × Dist₂))},
      Trace ((CausalSystem.ofOpenComposite A₁ A₂ tol₁ tol₂).proc ov) s w s' →
      Trace ((CausalSystem.ofOpenComponent A₁ tol₁).proc (ov.1.1, ov.2))
        s.1 (w.map fun m => ((m.1.1.1, m.1.2), m.2.1)) s'.1
  | _, _, [], .nil _ => .nil _
  | s, _, m :: _, .cons step tail =>
    .cons ((ofOpenComposite_step_iff A₁ A₂ tol₁ tol₂ ov s _ m).mp step).1
      (openComposite_trace_left ov tail)

private theorem openComposite_trace_right {S₁ S₂ Obs₁ Obs₂ Dist₁ Dist₂ Int₁ Int₂ Ext : Type}
    {A₁ : OpenComposition.OpenComponent S₁ Obs₁ Dist₁ Int₁ Ext}
    {A₂ : OpenComposition.OpenComponent S₂ Obs₂ Dist₂ Int₂ Ext}
    {tol₁ : Obs₁ × Bool → Dist₁ → Prop} {tol₂ : Obs₂ × Bool → Dist₂ → Prop}
    (ov : (Option Obs₁ × Option Obs₂) × Option Bool) :
    ∀ {s s' : S₁ × S₂} {w : List (((Obs₁ × Obs₂) × Bool) × (Dist₁ × Dist₂))},
      Trace ((CausalSystem.ofOpenComposite A₁ A₂ tol₁ tol₂).proc ov) s w s' →
      Trace ((CausalSystem.ofOpenComponent A₂ tol₂).proc (ov.1.2, ov.2))
        s.2 (w.map fun m => ((m.1.1.2, m.1.2), m.2.2)) s'.2
  | _, _, [], .nil _ => .nil _
  | s, _, m :: _, .cons step tail =>
    .cons ((ofOpenComposite_step_iff A₁ A₂ tol₁ tol₂ ov s _ m).mp step).2
      (openComposite_trace_right ov tail)

/-- Unconditional $\ell_\infty$ lax abstraction from a glued micro `ofOpenComposite` to the product
macro system `(ofOpenComponent B₁ tol₁').prod (ofOpenComponent B₂ tol₂')` (no `sync_step` required). -/
def LaxCausalAbs.composeOpen_to_prod_max
    {S₁ S₂ Obs₁ Obs₂ Dist₁ Dist₂ Int₁ Int₂ Ext : Type}
    {S₁' S₂' Obs₁' Obs₂' Dist₁' Dist₂' Int₁' Int₂' Ext' : Type}
    {A₁ : OpenComposition.OpenComponent S₁ Obs₁ Dist₁ Int₁ Ext}
    {A₂ : OpenComposition.OpenComponent S₂ Obs₂ Dist₂ Int₂ Ext}
    {B₁ : OpenComposition.OpenComponent S₁' Obs₁' Dist₁' Int₁' Ext'}
    {B₂ : OpenComposition.OpenComponent S₂' Obs₂' Dist₂' Int₂' Ext'}
    {tol₁ : Obs₁ × Bool → Dist₁ → Prop} {tol₂ : Obs₂ × Bool → Dist₂ → Prop}
    {tol₁' : Obs₁' × Bool → Dist₁' → Prop} {tol₂' : Obs₂' × Bool → Dist₂' → Prop}
    {π₁ : S₁ → S₁'} {π₂ : S₂ → S₂'}
    {ω₁ : Option Obs₁ × Option Bool → Option Obs₁' × Option Bool}
    {ω₂ : Option Obs₂ × Option Bool → Option Obs₂' × Option Bool}
    {σ : Nat → Nat} {M₁ : SlackDist S₁'} {M₂ : SlackDist S₂'}
    (lc₁ : LaxCausalAbs (CausalSystem.ofOpenComponent A₁ tol₁)
      (CausalSystem.ofOpenComponent B₁ tol₁') π₁ ω₁ σ M₁)
    (lc₂ : LaxCausalAbs (CausalSystem.ofOpenComponent A₂ tol₂)
      (CausalSystem.ofOpenComponent B₂ tol₂') π₂ ω₂ σ M₂) :
    LaxCausalAbs
      (CausalSystem.ofOpenComposite A₁ A₂ tol₁ tol₂)
      ((CausalSystem.ofOpenComponent B₁ tol₁').prod (CausalSystem.ofOpenComponent B₂ tol₂'))
      (fun s => (π₁ s.1, π₂ s.2))
      (fun ov => (ω₁ (ov.1.1, ov.2), ω₂ (ov.1.2, ov.2)))
      σ (OpenComposition.SlackDist.max M₁ M₂) where
  obs_eq := Prod.ext lc₁.obs_eq lc₂.obs_eq
  strict := lc₁.strict
  Epoch t s := lc₁.Epoch t s.1 ∧ lc₂.Epoch t s.2
  EpochQ k q := lc₁.EpochQ k q.1 ∧ lc₂.EpochQ k q.2
  epoch_step ov t s m s' ep step :=
    let hs := (ofOpenComposite_step_iff A₁ A₂ tol₁ tol₂ ov s s' m).mp step
    ⟨lc₁.epoch_step (ov.1.1, ov.2) t s.1 ((m.1.1.1, m.1.2), m.2.1) s'.1 ep.1 hs.1,
     lc₂.epoch_step (ov.1.2, ov.2) t s.2 ((m.1.1.2, m.1.2), m.2.2) s'.2 ep.2 hs.2⟩
  epoch_proj k s ep := ⟨lc₁.epoch_proj k s.1 ep.1, lc₂.epoch_proj k s.2 ep.2⟩
  α r := CoreHelpers.natMax (lc₁.α r) (lc₂.α r)
  β r := CoreHelpers.natMax (lc₁.β r) (lc₂.β r)
  α_mono le := CoreHelpers.natMax_le
    (Nat.le_trans (lc₁.α_mono le) (CoreHelpers.le_natMax_left _ _))
    (Nat.le_trans (lc₂.α_mono le) (CoreHelpers.le_natMax_right _ _))
  β_mono le := CoreHelpers.natMax_le
    (Nat.le_trans (lc₁.β_mono le) (CoreHelpers.le_natMax_left _ _))
    (Nat.le_trans (lc₂.β_mono le) (CoreHelpers.le_natMax_right _ _))
  β_ge_id r := Nat.le_trans (lc₁.β_ge_id r) (CoreHelpers.le_natMax_left _ _)
  ε := CoreHelpers.natMax lc₁.ε lc₂.ε
  η := CoreHelpers.natMax lc₁.η lc₂.η
  sim_block ov k s q r w s' epS epQ d_le w_len tr := by
    have r1_le : M₁.d (π₁ s.1) q.1 ≤ r := Nat.le_trans (CoreHelpers.le_natMax_left _ _) d_le
    have r2_le : M₂.d (π₂ s.2) q.2 ≤ r := Nat.le_trans (CoreHelpers.le_natMax_right _ _) d_le
    have len1 : (w.map fun m => ((m.1.1.1, m.1.2), m.2.1)).length = σ (k + 1) - σ k :=
      (length_map _ w).trans w_len
    have len2 : (w.map fun m => ((m.1.1.2, m.1.2), m.2.2)).length = σ (k + 1) - σ k :=
      (length_map _ w).trans w_len
    obtain ⟨b₁, q₁', step₁, epQ₁', d₁'⟩ :=
      lc₁.sim_block (ov.1.1, ov.2) k s.1 q.1 r _ s'.1 epS.1 epQ.1 r1_le len1
        (openComposite_trace_left ov tr)
    obtain ⟨b₂, q₂', step₂, epQ₂', d₂'⟩ :=
      lc₂.sim_block (ov.1.2, ov.2) k s.2 q.2 r _ s'.2 epS.2 epQ.2 r2_le len2
        (openComposite_trace_right ov tr)
    exact ⟨(b₁, b₂), (q₁', q₂'), ⟨step₁, step₂⟩, ⟨epQ₁', epQ₂'⟩,
      CoreHelpers.natMax_le
        (Nat.le_trans d₁' (Nat.add_le_add (CoreHelpers.le_natMax_left _ _) (CoreHelpers.le_natMax_left _ _)))
        (Nat.le_trans d₂' (Nat.add_le_add (CoreHelpers.le_natMax_right _ _) (CoreHelpers.le_natMax_right _ _)))⟩
  excursion ov k s q r w₁ u epS epQ d_le w₁_lt tr := by
    have r1_le : M₁.d (π₁ s.1) q.1 ≤ r := Nat.le_trans (CoreHelpers.le_natMax_left _ _) d_le
    have r2_le : M₂.d (π₂ s.2) q.2 ≤ r := Nat.le_trans (CoreHelpers.le_natMax_right _ _) d_le
    have lt1 : (w₁.map fun m => ((m.1.1.1, m.1.2), m.2.1)).length < σ (k + 1) - σ k :=
      Nat.lt_of_le_of_lt (Nat.le_of_eq (length_map _ w₁)) w₁_lt
    have lt2 : (w₁.map fun m => ((m.1.1.2, m.1.2), m.2.2)).length < σ (k + 1) - σ k :=
      Nat.lt_of_le_of_lt (Nat.le_of_eq (length_map _ w₁)) w₁_lt
    have d₁ := lc₁.excursion (ov.1.1, ov.2) k s.1 q.1 r _ u.1 epS.1 epQ.1 r1_le lt1
      (openComposite_trace_left ov tr)
    have d₂ := lc₂.excursion (ov.1.2, ov.2) k s.2 q.2 r _ u.2 epS.2 epQ.2 r2_le lt2
      (openComposite_trace_right ov tr)
    exact CoreHelpers.natMax_le
      (Nat.le_trans d₁ (Nat.add_le_add (CoreHelpers.le_natMax_left _ _) (CoreHelpers.le_natMax_left _ _)))
      (Nat.le_trans d₂ (Nat.add_le_add (CoreHelpers.le_natMax_right _ _) (CoreHelpers.le_natMax_right _ _)))

/-- Composed open-component $\ell_\infty$ lax abstraction into `ofOpenComposite B₁ B₂`, parameterized
by `ω₁_split`, `ω₂_split`, and explicit macro alarm-synchronization `sync_step` (CRITICAL FIX B3). -/
def LaxCausalAbs.composeOpenMax
    {S₁ S₂ Obs₁ Obs₂ Dist₁ Dist₂ Int₁ Int₂ Ext : Type}
    {S₁' S₂' Obs₁' Obs₂' Dist₁' Dist₂' Int₁' Int₂' Ext' : Type}
    {A₁ : OpenComposition.OpenComponent S₁ Obs₁ Dist₁ Int₁ Ext}
    {A₂ : OpenComposition.OpenComponent S₂ Obs₂ Dist₂ Int₂ Ext}
    {B₁ : OpenComposition.OpenComponent S₁' Obs₁' Dist₁' Int₁' Ext'}
    {B₂ : OpenComposition.OpenComponent S₂' Obs₂' Dist₂' Int₂' Ext'}
    {tol₁ : Obs₁ × Bool → Dist₁ → Prop} {tol₂ : Obs₂ × Bool → Dist₂ → Prop}
    {tol₁' : Obs₁' × Bool → Dist₁' → Prop} {tol₂' : Obs₂' × Bool → Dist₂' → Prop}
    {π₁ : S₁ → S₁'} {π₂ : S₂ → S₂'}
    {ω₁ : Option Obs₁ × Option Bool → Option Obs₁' × Option Bool}
    {ω₂ : Option Obs₂ × Option Bool → Option Obs₂' × Option Bool}
    {σ : Nat → Nat} {M₁ : SlackDist S₁'} {M₂ : SlackDist S₂'}
    (lc₁ : LaxCausalAbs (CausalSystem.ofOpenComponent A₁ tol₁)
      (CausalSystem.ofOpenComponent B₁ tol₁') π₁ ω₁ σ M₁)
    (lc₂ : LaxCausalAbs (CausalSystem.ofOpenComponent A₂ tol₂)
      (CausalSystem.ofOpenComponent B₂ tol₂') π₂ ω₂ σ M₂)
    (ω : (Option Obs₁ × Option Obs₂) × Option Bool → (Option Obs₁' × Option Obs₂') × Option Bool)
    (ω₁_split : ∀ ov, ((ω ov).1.1, (ω ov).2) = ω₁ (ov.1.1, ov.2))
    (ω₂_split : ∀ ov, ((ω ov).1.2, (ω ov).2) = ω₂ (ov.1.2, ov.2))
    (sync_step : ∀ ov k q₁ q₂ q₁' q₂' b₁ b₂,
      lc₁.EpochQ k q₁ → lc₂.EpochQ k q₂ →
      ((CausalSystem.ofOpenComponent B₁ tol₁').proc (ω₁ (ov.1.1, ov.2))).step q₁ b₁ q₁' →
      ((CausalSystem.ofOpenComponent B₂ tol₂').proc (ω₂ (ov.1.2, ov.2))).step q₂ b₂ q₂' →
      ∃ b, ((CausalSystem.ofOpenComposite B₁ B₂ tol₁' tol₂').proc (ω ov)).step (q₁, q₂) b (q₁', q₂')) :
    LaxCausalAbs
      (CausalSystem.ofOpenComposite A₁ A₂ tol₁ tol₂)
      (CausalSystem.ofOpenComposite B₁ B₂ tol₁' tol₂')
      (fun s => (π₁ s.1, π₂ s.2)) ω σ (OpenComposition.SlackDist.max M₁ M₂) :=
  let base := LaxCausalAbs.composeOpen_to_prod_max lc₁ lc₂
  { obs_eq := by
      have h1 := (ω₁_split ((none, none), none)).trans lc₁.obs_eq
      have h2 := (ω₂_split ((none, none), none)).trans lc₂.obs_eq
      have h1a : (ω ((none, none), none)).1.1 = none := congrArg Prod.fst h1
      have h1b : (ω ((none, none), none)).2 = none := congrArg Prod.snd h1
      have h2a : (ω ((none, none), none)).1.2 = none := congrArg Prod.fst h2
      exact Prod.ext (Prod.ext h1a h2a) h1b
    strict := base.strict
    Epoch := base.Epoch
    EpochQ := base.EpochQ
    epoch_step := base.epoch_step
    epoch_proj := base.epoch_proj
    α := base.α
    β := base.β
    α_mono := base.α_mono
    β_mono := base.β_mono
    β_ge_id := base.β_ge_id
    ε := base.ε
    η := base.η
    sim_block := fun ov k s q r w s' epS epQ d_le w_len tr => by
      obtain ⟨⟨b₁, b₂⟩, ⟨q₁', q₂'⟩, ⟨step₁, step₂⟩, epQ', hd'⟩ :=
        base.sim_block ov k s q r w s' epS epQ d_le w_len tr
      obtain ⟨b, stepSync⟩ := sync_step ov k q.1 q.2 q₁' q₂' b₁ b₂ epQ.1 epQ.2 step₁ step₂
      exact ⟨b, (q₁', q₂'), stepSync, epQ', hd'⟩
    excursion := base.excursion }

/-! ### `HorizontalLeakageWitness`: Passive & Marginal Exactness vs. Joint Interventional Leakage -/

namespace HorizontalLeakageWitness

/-- Discrete Hamming distance on `Bool`. -/
def boolDist : SlackDist Bool where
  d a b := bif a == b then 0 else 1
  refl a := by cases a <;> rfl
  tri a b c := by
    cases a <;> cases b <;> cases c <;>
      first | exact Nat.le_refl _ | exact Nat.zero_le _ | exact Nat.le_succ _

/-- $\ell_\infty$ slack distance on `Bool × Bool`. -/
def boolPairDist : SlackDist (Bool × Bool) :=
  OpenComposition.SlackDist.max boolDist boolDist

/-- Concrete two-part transition where intervening `some true` on part A leaks into part B. -/
def microNext (i : Option Bool × Option Bool) (s : Bool × Bool) : Bool × Bool :=
  (i.1.getD s.1, if i.1 == some true then (if s.1 then s.2 else true) else i.2.getD s.2)

def microSys : CausalSystem (Bool × Bool) Unit (Option Bool × Option Bool) :=
  CausalSystem.ofMap (fun i s _ => microNext i s) (none, none)

def macroA : CausalSystem Bool Unit (Option Bool) :=
  CausalSystem.ofMap (fun oa s₁ _ => oa.getD s₁) none

def macroB : CausalSystem Bool Unit (Option Bool) :=
  CausalSystem.ofMap (fun ob s₂ _ => ob.getD s₂) none

def macroInd : CausalSystem (Bool × Bool) Unit (Option Bool × Option Bool) :=
  CausalSystem.ofMap (fun i s _ => (i.1.getD s.1, i.2.getD s.2)) (none, none)

/-- On passive `obs = (none, none)`, the micro system agrees identically with the factorized macro
system. -/
theorem exact_on_obs : FactorsThrough microSys.passive id macroInd.passive :=
  fun _ _ _ step => step

/-- Marginalizing onto component A is exact across ALL joint interventions. -/
theorem exact_marginal_A :
    ExactCausalAbs microSys macroA Prod.fst id Prod.fst where
  obs_eq := rfl
  factors _ _ _ _ step := congrArg Prod.fst step

/-- Marginalizing onto component B is exact across all B-interventions while A stays passive. -/
theorem exact_passive_A_marginal_B :
    ExactCausalAbs
      (CausalSystem.ofMap (fun ob s _ => microNext (none, ob) s) none)
      macroB Prod.snd id id where
  obs_eq := rfl
  factors _ _ _ _ step := congrArg Prod.snd step

/-- No exact causal abstraction exists from `microSys` to `macroInd` for ANY `φ` and ANY `ω`. -/
theorem no_exact_causal_abs (φ : Unit → Unit) (ω : Option Bool × Option Bool → Option Bool × Option Bool) :
    ¬ ExactCausalAbs microSys macroInd id φ ω := by
  intro abs
  have h1 := abs.factors (some true, none) (false, false) () (true, true) rfl
  have h2 := abs.factors (some true, none) (true, false) () (true, false) rfl
  have h1s : true = (ω (some true, none)).2.getD false := congrArg Prod.snd h1
  have h2s : false = (ω (some true, none)).2.getD false := congrArg Prod.snd h2
  exact Bool.noConfusion (h1s.trans h2s.symm)

private theorem micro_leak_iterate :
    ∀ n : Nat, Trace (microSys.proc (some true, none)) (false, false) (List.replicate (n + 1) ()) (true, true)
  | 0 => .cons rfl (.nil (true, true))
  | n + 1 => by
    have step1 : (microSys.proc (some true, none)).step (false, false) () (true, true) := rfl
    have stay : ∀ m : Nat,
        Trace (microSys.proc (some true, none)) (true, true) (List.replicate (m + 1) ()) (true, true) := by
      intro m
      induction m with
      | zero => exact .cons rfl (.nil (true, true))
      | succ m ih => exact .cons rfl ih
    exact .cons step1 (stay n)

/-- No zero-slack lax abstraction with `ω = id` and `σ 0 = 0` holds from `(false, false)`. -/
theorem no_zero_slack_lax_abs {σ : Nat → Nat} (h0 : σ 0 = 0)
    (lc : LaxCausalAbs microSys macroInd id id σ boolPairDist) :
    ¬ (lc.Epoch 0 (false, false) ∧ lc.α 0 = 0 ∧ lc.ε = 0) := by
  intro ⟨ep0, hα0, hε0⟩
  have hpos : 0 < σ 1 - σ 0 := SupportGated.sub_pos_of_lt (lc.strict 0)
  obtain ⟨m, hm⟩ := le_dest (Nat.succ_le_of_lt hpos)
  have hlen : (List.replicate (m + 1) ()).length = σ 1 - σ 0 :=
    (GrammarLaws.length_replicate () (m + 1)).trans ((Nat.add_comm m 1).trans hm.symm)
  have epS : lc.Epoch (σ 0) (false, false) := h0.symm ▸ ep0
  obtain ⟨_, q', stepQ, _, hd⟩ :=
    lc.sim_block (some true, none) 0 (false, false) (false, false) 0
      (List.replicate (m + 1) ()) (true, true)
      epS (lc.epoch_proj 0 (false, false) epS) (Nat.le_refl 0) hlen (micro_leak_iterate m)
  have hq' : q' = (true, false) := stepQ
  change boolPairDist.d (true, true) q' ≤ lc.α 0 + lc.ε at hd
  rw [hq', hα0, hε0] at hd
  have hd_val : boolPairDist.d (true, true) (true, false) = 1 := rfl
  rw [hd_val] at hd
  exact Nat.not_succ_le_zero 0 hd

end HorizontalLeakageWitness

/-! ## Part 4: Sharp Observational-vs.-Interventional Separation (`CausalGoodhartWitness`) -/

namespace CausalGoodhartWitness

/-- Four discrete reserve/proxy levels. -/
inductive Level where
  | zero
  | one
  | two
  | three

/-- Numeric encoding of `Level`. -/
def Level.toNat : Level → Nat
  | .zero => 0
  | .one => 1
  | .two => 2
  | .three => 3

/-- Canonical slack distance on `Level`. -/
def levelDist : SlackDist Level :=
  SlackDist.pullback Level.toNat SlackDist.nat

/-- Passive stabilizing step on the observed level. -/
def stepObs : Level → Level
  | .zero => .zero
  | .one => .one
  | .two => .two
  | .three => .two

theorem stepObs_nonexpansive (q₁ q₂ : Level) :
    levelDist.d (stepObs q₁) (stepObs q₂) ≤ levelDist.d q₁ q₂ := by
  cases q₁ <;> cases q₂ <;> first | exact Nat.le_refl _ | exact Nat.zero_le _ | exact Nat.le_succ _

def boostLevel : Level → Level
  | .zero => .one
  | .one => .two
  | .two => .three
  | .three => .three

/-- Concrete micro dynamics `(proxy, reserve)` under `i : Bool` (`false` passive, `true` boost). -/
def stepMicro : Bool → Level × Level → Level × Level
  | false, (q, r) => (stepObs q, r)
  | true, (_, .zero) => (.zero, .zero)
  | true, (q, .one) => (boostLevel q, .zero)
  | true, (q, .two) => (boostLevel q, .one)
  | true, (q, .three) => (boostLevel q, .two)

/-- Macro dynamics on `proxy` alone under `i : Bool`. -/
def stepMacro : Bool → Level → Level
  | false => stepObs
  | true => boostLevel

def micro : CausalSystem (Level × Level) Unit Bool :=
  CausalSystem.ofMap (fun i s _ => stepMicro i s) false

def macroSys : CausalSystem Level Unit Bool :=
  CausalSystem.ofMap (fun i q _ => stepMacro i q) false

def π (s : Level × Level) : Level := s.1
def guardS (s : Level × Level) : Prop := s.2 ≠ .zero
def guardQ (q : Level) : Prop := q ≠ .zero
def s₀ : Level × Level := (.two, .two)

/-- Under passive `false`, micro and macro commute on ALL states. -/
theorem passive_commuting_all :
    ProjectedLaws.Commuting (fun s (_ : Unit) => stepMicro false s)
      (fun q (_ : Unit) => stepMacro false q) π :=
  fun _ _ => rfl

/-- Exact `LaxSim` between passive micro and passive macro, reusing `exactCausal_to_laxCausal` and
`stepObs_nonexpansive`. -/
def passive_laxSim_exact : LaxSim micro.passive macroSys.passive π id levelDist :=
  let C₁p : CausalSystem (Level × Level) Unit Unit :=
    CausalSystem.ofMap (fun _ s _ => stepMicro false s) ()
  let C₂p : CausalSystem Level Unit Unit :=
    CausalSystem.ofMap (fun _ q _ => stepMacro false q) ()
  let absP : ExactCausalAbs C₁p C₂p π id id :=
    exactCausal_commuting_iff.mpr ⟨rfl, fun _ => passive_commuting_all⟩
  let lcP := exactCausal_to_laxCausal absP levelDist
    (fun _ _ => True) (fun _ _ => True) (fun _ _ _ _ _ _ _ => trivial) (fun _ _ _ => trivial)
    id (fun le => le) 0
    (fun _ _ q₁ q₂ _ b q₁' _ _ hd step₁ =>
      ⟨b, stepObs q₂, rfl, trivial,
        Nat.le_trans ((step₁ : q₁' = stepObs q₁).symm ▸ stepObs_nonexpansive q₁ q₂) hd⟩)
  lcP.passive

/-- Under passive `false`, micro stays inside `guardS` forever from `s₀`. -/
theorem passive_micro_kernel : Viability.Kernel micro.passive guardS s₀ :=
  let cert : Viability.Certificate micro.passive guardS guardS :=
    ⟨fun _ h => h, fun s _ s' step hs => by
      have heq : s' = (stepObs s.1, s.2) := step
      rw [heq]
      exact hs⟩
  cert.kernel (fun h => Level.noConfusion h)

/-- Under passive `false`, macro stays inside `guardQ` forever from `π s₀`. -/
theorem passive_macro_kernel : Viability.Kernel macroSys.passive guardQ (π s₀) :=
  let cert : Viability.Certificate macroSys.passive guardQ guardQ :=
    ⟨fun _ h => h, fun q _ q' step hq => by
      have heq : q' = stepObs q := step
      rw [heq]
      cases q with
      | zero => exact absurd rfl hq
      | one => exact fun h => Level.noConfusion h
      | two => exact fun h => Level.noConfusion h
      | three => exact fun h => Level.noConfusion h⟩
  cert.kernel (fun h => Level.noConfusion h)

/-- Under interventional `boost` (`true`), the macro model certifies `guardQ` forever while
raising the proxy strictly (`2 < 3`). -/
theorem macro_boost_kernel :
    Viability.Kernel (macroSys.proc true) guardQ (π s₀) ∧
    (π s₀).toNat < (stepMacro true (π s₀)).toNat := by
  let K : Level → Prop := fun q => q = .two ∨ q = .three
  have cert : Viability.Certificate (macroSys.proc true) guardQ K :=
    ⟨fun q hq => hq.elim (fun h => h ▸ fun e => Level.noConfusion e)
        (fun h => h ▸ fun e => Level.noConfusion e),
     fun q _ q' step hq => by
      have hsq : q' = boostLevel q := step
      rw [hsq]
      cases hq with
      | inl h2 => rw [h2]; exact .inr rfl
      | inr h3 => rw [h3]; exact .inr rfl⟩
  exact ⟨cert.kernel (.inl rfl), Nat.lt_succ_self 2⟩

/-- Under interventional `boost` (`true`), `guardS` collapses at step 2 while `guardQ (π s)` still
holds. -/
theorem micro_boost_guardS_collapses :
    ∃ s₂, Trace (micro.proc true) s₀ [(), ()] s₂ ∧ ¬ guardS s₂ ∧ guardQ (π s₂) :=
  ⟨(.three, .zero), .cons rfl (.cons rfl (.nil _)),
   fun hg => hg rfl, fun hq => Level.noConfusion hq⟩

/-- Under interventional `boost` (`true`), the proxy itself collapses at step 3 (`¬ guardQ (π s₃)`). -/
theorem micro_boost_proxy_collapses :
    ∃ s₃, Trace (micro.proc true) s₀ [(), (), ()] s₃ ∧ ¬ guardQ (π s₃) :=
  ⟨(.zero, .zero), .cons rfl (.cons rfl (.cons rfl (.nil _))),
   fun hg => hg rfl⟩

/-- No exact causal abstraction exists from `micro` to `macroSys` for any `φ` and any `ω : Bool → Bool`. -/
theorem no_exact_causal_abs_any_omega (φ : Unit → Unit) (ω : Bool → Bool) :
    ¬ ExactCausalAbs micro macroSys π φ ω := by
  intro abs
  have h1 := abs.factors true (.two, .two) () (.three, .one) rfl
  have h2 := abs.factors true (.two, .zero) () (.zero, .zero) rfl
  have e1 : Level.three = stepMacro (ω true) .two := h1
  have e2 : Level.zero = stepMacro (ω true) .two := h2
  exact Level.noConfusion (e1.trans e2.symm)

private theorem micro_boost_from_three :
    ∀ n : Nat, Trace (micro.proc true) s₀ (List.replicate (n + 3) ()) (.zero, .zero)
  | 0 => .cons rfl (.cons rfl (.cons rfl (.nil (Level.zero, Level.zero))))
  | n + 1 => by
    have step1 : (micro.proc true).step s₀ () (.three, .one) := rfl
    have step2 : (micro.proc true).step (.three, .one) () (.three, .zero) := rfl
    have step3 : (micro.proc true).step (.three, .zero) () (.zero, .zero) := rfl
    have stay : ∀ m : Nat, Trace (micro.proc true) (.zero, .zero) (List.replicate m ()) (.zero, .zero) := by
      intro m
      induction m with
      | zero => exact .nil _
      | succ m ih => exact .cons rfl ih
    exact .cons step1 (.cons step2 (.cons step3 (stay (n + 1))))

private theorem macro_three_steps_ne_zero :
    ∀ (j : Bool) (w : List Unit) (q : Level),
      w.length = 3 → Trace (macroSys.proc j) .two w q → q ≠ .zero
  | j, [_, _, _], q, _, tr => by
    cases tr with | cons s1 tr1 =>
    cases tr1 with | cons s2 tr2 =>
    cases tr2 with | cons s3 tr3 =>
    cases tr3
    have h1 : _ = stepMacro j .two := s1
    have h2 : _ = stepMacro j _ := s2
    have h3 : _ = stepMacro j _ := s3
    rw [h3, h2, h1]
    cases j <;> exact fun h => Level.noConfusion h
  | _, [], _, h, _ => Nat.noConfusion h
  | _, [_], _, h, _ => Nat.noConfusion (Nat.succ.inj h)
  | _, [_, _], _, h, _ => Nat.noConfusion (Nat.succ.inj (Nat.succ.inj h))
  | _, _ :: _ :: _ :: _ :: _, _, h, _ => Nat.noConfusion (Nat.succ.inj (Nat.succ.inj (Nat.succ.inj h)))

/-- No zero-slack lax causal abstraction holds from `Epoch 0 s₀` for any `ω` and any `σ` with `σ 0 = 0`. -/
theorem no_zero_slack_lax_causal_abs {ω : Bool → Bool} {σ : Nat → Nat} (h0 : σ 0 = 0)
    (lc : LaxCausalAbs micro macroSys π ω σ levelDist) :
    ¬ (lc.Epoch 0 s₀ ∧ lc.α 0 = 0 ∧ lc.ε = 0) := by
  intro ⟨ep0, hα0, hε0⟩
  have hle3 : 3 ≤ σ 3 := Strict.le_self lc.strict 3
  have hsub3 : 3 ≤ σ (0 + 3) - σ 0 := by
    rw [Nat.zero_add, h0, Nat.sub_zero]
    exact hle3
  obtain ⟨m, hm⟩ := le_dest hsub3
  have hlen : σ (0 + 3) - σ 0 ≤ (List.replicate (m + 3) ()).length := by
    rw [GrammarLaws.length_replicate () (m + 3), Nat.add_comm m 3, ← hm]
    exact Nat.le_refl _
  have epS : lc.Epoch (σ 0) s₀ := h0.symm ▸ ep0
  obtain ⟨s₃, w_rem, wR, q₃, rem_eq, rlen, trR, tr_rem, _, _, hd⟩ :=
    LaxSim.advance_blocks (lc.toLaxSim true) 3 0 epS (lc.epoch_proj 0 s₀ epS)
      (Nat.le_refl 0) hlen (micro_boost_from_three m)
  have hwrem_zero : w_rem.length = 0 := by
    have hsum : w_rem.length + (m + 3) = 0 + (m + 3) := by
      have hm' : σ (0 + 3) - σ 0 = m + 3 := hm.trans (Nat.add_comm 3 m)
      exact (congrArg (w_rem.length + ·) hm'.symm).trans (rem_eq.trans
        ((GrammarLaws.length_replicate () (m + 3)).trans (Nat.zero_add (m + 3)).symm))
    exact add_right_cancel (m + 3) hsum
  have hnil : w_rem = [] := nil_of_length_zero hwrem_zero
  have hs3 : s₃ = (.zero, .zero) := by
    rw [hnil] at tr_rem
    cases tr_rem
    rfl
  have hsl : LaxSim.slack lc.α lc.ε 3 0 = 0 := by
    have s1 : LaxSim.slack lc.α lc.ε 1 0 = 0 := by
      show lc.α 0 + lc.ε = 0
      rw [hα0, hε0]
    have s2 : LaxSim.slack lc.α lc.ε 2 0 = 0 := by
      show lc.α (LaxSim.slack lc.α lc.ε 1 0) + lc.ε = 0
      rw [s1, hα0, hε0]
    show lc.α (LaxSim.slack lc.α lc.ε 2 0) + lc.ε = 0
    rw [s2, hα0, hε0]
  have hd' : distNat 0 q₃.toNat ≤ LaxSim.slack lc.α lc.ε 3 0 := by
    change distNat (π s₃).toNat q₃.toNat ≤ LaxSim.slack lc.α lc.ε 3 0 at hd
    rw [hs3] at hd
    exact hd
  have hd0 : distNat 0 q₃.toNat ≤ 0 :=
    Eq.subst (motive := fun k => distNat 0 q₃.toNat ≤ k) hsl hd'
  have hq3_nat : q₃.toNat = 0 := by
    unfold distNat at hd0
    have hq0 : q₃.toNat - 0 ≤ 0 := Nat.le_trans (Nat.le_add_left (q₃.toNat - 0) (0 - q₃.toNat)) hd0
    exact Nat.eq_zero_of_le_zero (Nat.sub_zero q₃.toNat ▸ hq0)
  have hq3_zero : q₃ = .zero := by
    cases q₃ with
    | zero => rfl
    | one => exact Nat.noConfusion hq3_nat
    | two => exact Nat.noConfusion hq3_nat
    | three => exact Nat.noConfusion hq3_nat
  exact macro_three_steps_ne_zero (ω true) wR q₃ rlen trR hq3_zero

/-- No small-slack (`α 0 + ε ≤ 1`) one-step lax causal abstraction holds across all `Epoch 0 s`. -/
theorem no_small_slack_lax_causal_abs {ω : Bool → Bool}
    (lc : LaxCausalAbs micro macroSys π ω id levelDist) :
    ¬ ((∀ s, lc.Epoch 0 s) ∧ lc.α 0 + lc.ε ≤ 1) := by
  intro ⟨epAll, hsmall⟩
  obtain ⟨_, q₁, step₁, _, hd₁⟩ :=
    lc.sim_block true 0 (.two, .two) .two 0 [()] (.three, .one)
      (epAll _) (lc.epoch_proj 0 (.two, .two) (epAll _)) (Nat.le_refl 0) (succ_sub_self 0).symm
      (.cons rfl (.nil _))
  obtain ⟨_, q₂, step₂, _, hd₂⟩ :=
    lc.sim_block true 0 (.two, .zero) .two 0 [()] (.zero, .zero)
      (epAll _) (lc.epoch_proj 0 (.two, .zero) (epAll _)) (Nat.le_refl 0) (succ_sub_self 0).symm
      (.cons rfl (.nil _))
  have hq : q₁ = q₂ := (step₁ : q₁ = stepMacro (ω true) .two).trans (step₂ : q₂ = stepMacro (ω true) .two).symm
  rw [← hq] at hd₂
  have htri : distNat 3 0 ≤ distNat 3 q₁.toNat + distNat q₁.toNat 0 :=
    distNat_tri 3 q₁.toNat 0
  have hsym : distNat q₁.toNat 0 = distNat 0 q₁.toNat := distNat_symm q₁.toNat 0
  have hsum : distNat 3 0 ≤ (lc.α 0 + lc.ε) + (lc.α 0 + lc.ε) :=
    Nat.le_trans htri (Nat.add_le_add hd₁ (hsym ▸ hd₂))
  have hbound : 3 ≤ 2 := Nat.le_trans hsum (Nat.add_le_add hsmall hsmall)
  exact Nat.not_succ_le_zero 0 (Nat.le_of_succ_le_succ (Nat.le_of_succ_le_succ hbound))

end CausalGoodhartWitness

/-! ## Part 5: Bridges to `GrammarLaws`, `Counterfactual`, `Experiment`, `Mechanism`, & Positive Witness -/

/-! ### Bridges to `GrammarLaws` -/

/-- Interventional going-alike: concrete pairs aligned under `(π, ω)` go alike under `π`. -/
def CausalGoAlike {S : Type u} {A : Type v} {I : Type w} {Q : Type u₁} {J : Type w₁}
    (C : CausalSystem S A I) (π : S → Q) (ω : I → J) : Prop :=
  ∀ i i' s s' a u u', ω i = ω i' → π s = π s' →
    (C.proc i).step s a u → (C.proc i').step s' a u' → π u = π u'

/-- Interventional image system of `C` along `(π, ω)`. -/
def CausalImage {S : Type u} {A : Type v} {I : Type w} {Q : Type u₁} {J : Type w₁}
    (C : CausalSystem S A I) (π : S → Q) (ω : I → J) : CausalSystem Q A J where
  obs := ω C.obs
  proc j := ⟨fun q a q' => ∃ i s s', ω i = j ∧ π s = q ∧ (C.proc i).step s a s' ∧ π s' = q'⟩

/-- **The causal image is determined exactly where `(π, ω)`-alike steps go alike**, wrapping
`GrammarLaws.«像定后当且仅当同行»`. -/
theorem «因像定当且仅当因同行» {S : Type u} {A : Type v} {I : Type w}
    {Q : Type u₁} {J : Type w₁}
    (C : CausalSystem S A I) (π : S → Q) (ω : I → J) :
    (∀ j, Determined ((CausalImage C π ω).proc j)) ↔ CausalGoAlike C π ω := by
  let proj : I × S → J × Q := fun x => (ω x.1, π x.2)
  let R : A → «际» (I × S) := fun a x y => x.1 = y.1 ∧ (C.proc x.1).step x.2 a y.2
  constructor
  · intro hdet i i' s s' a u u' hω hπ hstep hstep'
    have hfixed : «定后» («像» proj (R a)) := by
      intro p₁ p₂ ⟨⟨j₀, q₀⟩, ⟨x₁, y₁, hx₁, hr₁, hy₁⟩, ⟨x₂, y₂, hx₂, hr₂, hy₂⟩⟩
      have hq₁ : ((CausalImage C π ω).proc j₀).step q₀ a p₁.2 :=
        ⟨x₁.1, x₁.2, y₁.2, congrArg Prod.fst hx₁, congrArg Prod.snd hx₁, hr₁.2, congrArg Prod.snd hy₁⟩
      have hq₂ : ((CausalImage C π ω).proc j₀).step q₀ a p₂.2 :=
        ⟨x₂.1, x₂.2, y₂.2, congrArg Prod.fst hx₂, congrArg Prod.snd hx₂, hr₂.2, congrArg Prod.snd hy₂⟩
      have hj₁ : p₁.1 = j₀ :=
        (congrArg Prod.fst hy₁).symm.trans ((congrArg ω hr₁.1.symm).trans (congrArg Prod.fst hx₁))
      have hj₂ : p₂.1 = j₀ :=
        (congrArg Prod.fst hy₂).symm.trans ((congrArg ω hr₂.1.symm).trans (congrArg Prod.fst hx₂))
      exact Prod.ext (hj₁.trans hj₂.symm) (hdet j₀ q₀ a p₁.2 p₂.2 hq₁ hq₂)
    have halike := («像定后当且仅当同行» (π := proj) (R := R a)).mp hfixed
    have he := «同行之逐点».mp halike (i, s) (i', s') (Prod.ext hω hπ) (i, u) (i', u')
      ⟨rfl, hstep⟩ ⟨rfl, hstep'⟩
    exact congrArg Prod.snd he
  · intro halike j q a q₁ q₂ ⟨i₁, s₁, u₁, hi₁, hs₁, hstep₁, hu₁⟩ ⟨i₂, s₂, u₂, hi₂, hs₂, hstep₂, hu₂⟩
    have h_lump : «同行» (R a) (fun x x' => proj x = proj x') :=
      «同行之逐点».mpr fun x x' hproj y y' r r' =>
        Prod.ext ((congrArg ω r.1.symm).trans ((congrArg Prod.fst hproj).trans (congrArg ω r'.1)))
          (halike x.1 x'.1 x.2 x'.2 a y.2 y'.2 (congrArg Prod.fst hproj) (congrArg Prod.snd hproj) r.2 r'.2)
    have hfixed := («像定后当且仅当同行» (π := proj) (R := R a)).mpr h_lump
    have hpair := hfixed (j, q₁) (j, q₂)
      ⟨(j, q),
        ⟨(i₁, s₁), (i₁, u₁), Prod.ext hi₁ hs₁, ⟨rfl, hstep₁⟩, Prod.ext hi₁ hu₁⟩,
        ⟨(i₂, s₂), (i₂, u₂), Prod.ext hi₂ hs₂, ⟨rfl, hstep₂⟩, Prod.ext hi₂ hu₂⟩⟩
    exact congrArg Prod.snd hpair

/-- A deterministic exact causal abstraction (with `φ = id`) exists exactly where `CausalGoAlike` holds. -/
theorem exactCausal_exists_iff_causalGoAlike {S : Type u} {A : Type v} {I : Type w}
    {Q : Type u₁} {J : Type w₁}
    (C : CausalSystem S A I) (π : S → Q) (ω : I → J) :
    (∃ D : CausalSystem Q A J, (∀ j, Determined (D.proc j)) ∧ ExactCausalAbs C D π id ω) ↔
      CausalGoAlike C π ω :=
  ⟨fun ⟨_, hdet, habs⟩ i i' s s' a u u' hω hπ hs hs' =>
     hdet (ω i) (π s) a (π u) (π u') (habs.factors i s a u hs)
       (hω ▸ hπ ▸ habs.factors i' s' a u' hs'),
   fun halike =>
     ⟨CausalImage C π ω, («因像定当且仅当因同行» C π ω).mpr halike,
      ⟨rfl, fun i s _ s' step => ⟨i, s, s', rfl, rfl, step, rfl⟩⟩⟩⟩

/-- Action-mapped process image. -/
def ImageMap {S : Type u} {A : Type v} {Q : Type w} {B : Type z}
    (P : Process S A) (π : S → Q) (φ : A → B) : Process Q B where
  step q b q' := ∃ s a s', π s = q ∧ φ a = b ∧ P.step s a s' ∧ π s' = q'

/-- Action-mapped interventional going-alike condition. -/
def CausalGoAlikeMap {S : Type u} {A : Type v} {I : Type w}
    {Q : Type u₁} {B : Type v₁} {J : Type w₁}
    (C : CausalSystem S A I) (π : S → Q) (φ : A → B) (ω : I → J) : Prop :=
  ∀ i i' s s' a a' u u', ω i = ω i' → π s = π s' → φ a = φ a' →
    (C.proc i).step s a u → (C.proc i').step s' a' u' → π u = π u'

/-- Joining `ImageMap` directly to `GrammarLaws.«像»`. -/
theorem imageMap_iff_grammar {S : Type u} {A : Type v} {Q : Type w} {B : Type z}
    (P : Process S A) (π : S → Q) (φ : A → B) (q q' : Q) (b : B) :
    (ImageMap P π φ).step q b q' ↔
      «像» π (fun s s' => ∃ a, φ a = b ∧ P.step s a s') q q' :=
  ⟨fun ⟨s, a, s', hs, ha, hp, hs'⟩ => ⟨s, s', hs, ⟨a, ha, hp⟩, hs'⟩,
   fun ⟨s, s', hs, ⟨a, ha, hp⟩, hs'⟩ => ⟨s, a, s', hs, ha, hp, hs'⟩⟩

/-- A deterministic action-mapped exact causal abstraction exists exactly where `CausalGoAlikeMap` holds. -/
theorem exactCausalMap_exists_iff {S : Type u} {A : Type v} {I : Type w}
    {Q : Type u₁} {B : Type v₁} {J : Type w₁}
    (C : CausalSystem S A I) (π : S → Q) (φ : A → B) (ω : I → J) :
    (∃ D : CausalSystem Q B J, (∀ j, Determined (D.proc j)) ∧ ExactCausalAbs C D π φ ω) ↔
      CausalGoAlikeMap C π φ ω := by
  constructor
  · intro ⟨D, hdet, habs⟩ i i' s s' a a' u u' hω hπ hφ hs hs'
    exact hdet (ω i) (π s) (φ a) (π u) (π u') (habs.factors i s a u hs)
      (hω ▸ hπ ▸ hφ ▸ habs.factors i' s' a' u' hs')
  · intro halike
    let D : CausalSystem Q B J :=
      ⟨fun j => ⟨fun q b q' => ∃ i, ω i = j ∧ (ImageMap (C.proc i) π φ).step q b q'⟩, ω C.obs⟩
    refine ⟨D, ?_, ⟨rfl, fun i s a s' step => ⟨i, rfl, s, a, s', rfl, rfl, step, rfl⟩⟩⟩
    intro j q b q₁ q₂ ⟨i₁, hi₁, s₁, a₁, u₁, hs₁, ha₁, hstep₁, hu₁⟩
      ⟨i₂, hi₂, s₂, a₂, u₂, hs₂, ha₂, hstep₂, hu₂⟩
    exact hu₁.symm.trans ((halike i₁ i₂ s₁ s₂ a₁ a₂ u₁ u₂ (hi₁.trans hi₂.symm)
      (hs₁.trans hs₂.symm) (ha₁.trans ha₂.symm) hstep₁ hstep₂).trans hu₂)

/-! ### Bridges to `Counterfactual` (`ExchangeLaw`) via `projectHistList` (ZERO `funext`!) -/

section ExchangeBridge

/-- Project a single time slice of condition levels along `keep` over list `cs`. -/
def keepRow {C : Type} (keep : C → Bool) (row : C → Nat) : List C → List Nat
  | [] => []
  | c :: cs => (bif keep c then row c else 0) :: keepRow keep row cs

theorem keepRow_eq_iff {C : Type} (keep : C → Bool) (r r' : C → Nat) :
    ∀ cs : List C, keepRow keep r cs = keepRow keep r' cs ↔
      ∀ c, c ∈ cs → keep c = true → r c = r' c
  | [] => ⟨fun _ _ mem _ => (by cases mem), fun _ => rfl⟩
  | c :: cs => by
    constructor
    · intro h e mem hke
      obtain ⟨hhd, htl⟩ := List.cons.inj h
      cases ListTests.mem_cons_iff.mp mem with
      | inl heq =>
        rw [heq]
        have hkc : keep c = true := heq ▸ hke
        rw [hkc] at hhd
        exact hhd
      | inr htail => exact (keepRow_eq_iff keep r r' cs).mp htl e htail hke
    · intro hall
      have htl := (keepRow_eq_iff keep r r' cs).mpr fun e mem hke => hall e (.tail c mem) hke
      cases hkc : keep c with
      | false =>
        unfold keepRow
        rw [hkc]
        exact congrArg (_ :: ·) htl
      | true =>
        unfold keepRow
        rw [hkc]
        exact congr (congrArg List.cons (hall c (.head cs) hkc)) htl

/-- Finite-list history projection keeping rows at steps `0..t` for conditions marked by `keep`. -/
def keepHist {C : Type} (keep : C → Bool) (cs : List C) (l : Nat → C → Nat) :
    Nat → List (List Nat)
  | 0 => [keepRow keep (l 0) cs]
  | t + 1 => keepRow keep (l (t + 1)) cs :: keepHist keep cs l t

theorem keepHist_eq_iff {C : Type} (keep : C → Bool) (cs : List C) (l l' : Nat → C → Nat) :
    ∀ t : Nat, keepHist keep cs l t = keepHist keep cs l' t ↔
      ∀ s, s ≤ t → ∀ c, c ∈ cs → keep c = true → l s c = l' s c
  | 0 => by
    constructor
    · intro h s hs c mem hkc
      have hs0 : s = 0 := Nat.eq_zero_of_le_zero hs
      subst hs0
      exact (keepRow_eq_iff keep (l 0) (l' 0) cs).mp (List.cons.inj h).1 c mem hkc
    · intro hall
      have h0 : keepRow keep (l 0) cs = keepRow keep (l' 0) cs :=
        (keepRow_eq_iff keep (l 0) (l' 0) cs).mpr (hall 0 (Nat.le_refl 0))
      exact congrArg (fun r => [r]) h0
  | t + 1 => by
    constructor
    · intro h s hs c mem hkc
      obtain ⟨hhd, htl⟩ := List.cons.inj h
      cases le_succ_cases hs with
      | inl hle => exact (keepHist_eq_iff keep cs l l' t).mp htl s hle c mem hkc
      | inr heq =>
        subst heq
        exact (keepRow_eq_iff keep (l (t + 1)) (l' (t + 1)) cs).mp hhd c mem hkc
    · intro hall
      have hhd : keepRow keep (l (t + 1)) cs = keepRow keep (l' (t + 1)) cs :=
        (keepRow_eq_iff keep (l (t + 1)) (l' (t + 1)) cs).mpr (hall (t + 1) (Nat.le_refl _))
      have htl : keepHist keep cs l t = keepHist keep cs l' t :=
        (keepHist_eq_iff keep cs l l' t).mpr fun s hs => hall s (Nat.le_succ_of_le hs)
      show keepRow keep (l (t + 1)) cs :: keepHist keep cs l t =
        keepRow keep (l' (t + 1)) cs :: keepHist keep cs l' t
      exact congr (congrArg List.cons hhd) htl

/-- Finite-list projection of an `ExchangeLaw` state `(t, l)` keeping only `keep`-selected
conditions in `cs` up to `t` (CRITICAL FIX B1: zero `funext`). -/
def projectHistList {C : Type} (keep : C → Bool) (cs : List C)
    (x : Nat × (Nat → C → Nat)) : Nat × List (List Nat) :=
  (x.1, keepHist keep cs x.2 x.1)

/-- Exact characterization of equality under `projectHistList`, with 0 axioms. -/
theorem projectHistList_eq_iff {C : Type} (keep : C → Bool) (cs : List C)
    (x x' : Nat × (Nat → C → Nat)) :
    projectHistList keep cs x = projectHistList keep cs x' ↔
      x.1 = x'.1 ∧ ∀ s, s ≤ x.1 → ∀ c, c ∈ cs → keep c = true → x.2 s c = x'.2 s c := by
  obtain ⟨t, l⟩ := x
  obtain ⟨t', l'⟩ := x'
  constructor
  · intro h
    have ht : t = t' := congrArg Prod.fst h
    subst ht
    exact ⟨rfl, (keepHist_eq_iff keep cs l l' t).mp (congrArg Prod.snd h)⟩
  · intro ⟨ht, hall⟩
    subst ht
    exact congrArg (t, ·) ((keepHist_eq_iff keep cs l l' t).mpr hall)

/-- Sensitivity under `law.withAct part act` splits cleanly on `part h`. -/
theorem withAct_sensitive_iff {F C : Type} (law act : ExchangeLaw F C) (part : F → Bool)
    {h : F} {c : C} :
    (law.withAct part act).Sensitive h c ↔
      (part h = false ∧ law.Sensitive h c) ∨ (part h = true ∧ act.Sensitive h c) := by
  cases hp : part h with
  | false =>
    have heq : (law.withAct part act).Sensitive h c ↔ law.Sensitive h c := by
      unfold ExchangeLaw.Sensitive ExchangeLaw.InsensitiveAt ExchangeLaw.GivesAlike ExchangeLaw.withAct
      dsimp only
      rw [hp]
      exact Iff.rfl
    exact heq.trans ⟨fun hs => .inl ⟨rfl, hs⟩,
      fun hcase => hcase.elim And.right (fun hf => absurd hf.1 Bool.noConfusion)⟩
  | true =>
    have heq : (law.withAct part act).Sensitive h c ↔ act.Sensitive h c := by
      unfold ExchangeLaw.Sensitive ExchangeLaw.InsensitiveAt ExchangeLaw.GivesAlike ExchangeLaw.withAct
      dsimp only
      rw [hp]
      exact Iff.rfl
    exact heq.trans ⟨fun hs => .inr ⟨rfl, hs⟩,
      fun hcase => hcase.elim (fun hf => absurd hf.1 Bool.noConfusion) And.right⟩

/-- An exchange law gives alike across `keepHist`-equivalent histories iff every condition `h` is
sensitive to is kept (`cases hkc : keep c`, zero `bool_true_of_not_not`). -/
theorem exchange_givesAlike_iff_sensitive_in {F C : Type} [DecidableEq C]
    (law : ExchangeLaw F C) (na : law.Nonanticipating)
    (cs : List C) (every : ∀ c, c ∈ cs) (keep : C → Bool) (h : F) :
    (∀ t l l', keepHist keep cs l t = keepHist keep cs l' t → law.GivesAlike t h l l') ↔
      (∀ c, law.Sensitive h c → keep c = true) := by
  constructor
  · intro halike c ⟨t, hnot⟩
    cases hkc : keep c with
    | true => rfl
    | false =>
      exact False.elim (hnot fun l l' hdiff => halike t l l'
        ((keepHist_eq_iff keep cs l l' t).mpr fun s hs e _ hke =>
          hdiff s hs e fun hec => Bool.noConfusion ((hec ▸ hke).symm.trans hkc)))
  · intro hsens t l l' hhist
    have hagree := (keepHist_eq_iff keep cs l l' t).mp hhist
    exact alike_of_sensitive_agree na every
      (fun c hc s hs => hagree s hs c (every c) (hsens c hc))

/-- If every condition sensitive to any active `effectiveLaw law part (ω j)` is kept, then
`CausalSystem.ofExchangeLaw` admits a deterministic exact causal abstraction through
`projectHistList keep cs` (CRITICAL FIX B3). -/
theorem exactCausal_of_exchange_sensitive_in {F C : Type} [DecidableEq C]
    (law : ExchangeLaw F C) (present : Nat → List F) (part : F → Bool)
    (cs : List C) (every : ∀ c, c ∈ cs) (keep : C → Bool)
    (ω : Option (ExchangeLaw F C) → Option (ExchangeLaw F C))
    (na : ∀ j, (effectiveLaw law part (ω j)).Nonanticipating)
    (agree_eff : ∀ j t h l c, h ∈ present t →
      (effectiveLaw law part j).take t h l c = (effectiveLaw law part (ω j)).take t h l c ∧
      (effectiveLaw law part j).give t h l c = (effectiveLaw law part (ω j)).give t h l c)
    (sens : ∀ j t h c, h ∈ present t →
      (effectiveLaw law part (ω j)).Sensitive h c → keep c = true) :
    ∃ D : CausalSystem (Nat × List (List Nat)) Unit (Option (ExchangeLaw F C)),
      (∀ j, Determined (D.proc j)) ∧
      ExactCausalAbs (CausalSystem.ofExchangeLaw law present part) D
        (projectHistList keep cs) id ω := by
  refine (exactCausal_exists_iff_causalGoAlike
    (CausalSystem.ofExchangeLaw law present part) (projectHistList keep cs) ω).mpr ?_
  intro i₁ i₂ x₁ x₂ _ u₁ u₂ hω hπ step₁ step₂
  have hu₁ : u₁ = (effectiveLaw law part i₁).next present x₁ := step₁
  have hu₂ : u₂ = (effectiveLaw law part i₂).next present x₂ := step₂
  subst hu₁
  subst hu₂
  obtain ⟨ht, hagree⟩ := (projectHistList_eq_iff keep cs x₁ x₂).mp hπ
  obtain ⟨t₁, l₁⟩ := x₁
  obtain ⟨t₂, l₂⟩ := x₂
  have hteq : t₁ = t₂ := ht
  subst hteq
  have hhist : keepHist keep cs l₁ t₁ = keepHist keep cs l₂ t₁ :=
    (keepHist_eq_iff keep cs l₁ l₂ t₁).mpr hagree
  refine (projectHistList_eq_iff keep cs
    ((effectiveLaw law part i₁).next present (t₁, l₁))
    ((effectiveLaw law part i₂).next present (t₁, l₂))).mpr ⟨rfl, ?_⟩
  intro s hs c mem hkc
  show (effectiveLaw law part i₁).extend present l₁ t₁ s c =
    (effectiveLaw law part i₂).extend present l₂ t₁ s c
  unfold ExchangeLaw.extend
  cases Nat.decLe s t₁ with
  | isTrue hsle =>
    rw [if_pos hsle, if_pos hsle]
    exact hagree s hsle c mem hkc
  | isFalse hsnot =>
    rw [if_neg hsnot, if_neg hsnot]
    have hgives : ∀ h, h ∈ present t₁ →
        (effectiveLaw law part (ω i₁)).GivesAlike t₁ h l₁ l₂ := fun h hmem =>
      (exchange_givesAlike_iff_sensitive_in (effectiveLaw law part (ω i₁)) (na i₁)
        cs every keep h).mpr (fun c => sens i₁ t₁ h c hmem) t₁ l₁ l₂ hhist
    have htaken : (effectiveLaw law part i₁).takenUnder present l₁ t₁ c =
        (effectiveLaw law part i₂).takenUnder present l₂ t₁ c :=
      total_congr_on fun h hmem =>
        (agree_eff i₁ t₁ h l₁ c hmem).1.trans
          (((hgives h hmem c).1).trans
            ((congrArg (fun j => (effectiveLaw law part j).take t₁ h l₂ c) hω).trans
              (agree_eff i₂ t₁ h l₂ c hmem).1.symm))
    have hgiven : (effectiveLaw law part i₁).givenUnder present l₁ t₁ c =
        (effectiveLaw law part i₂).givenUnder present l₂ t₁ c :=
      total_congr_on fun h hmem =>
        (agree_eff i₁ t₁ h l₁ c hmem).2.trans
          (((hgives h hmem c).2).trans
            ((congrArg (fun j => (effectiveLaw law part j).give t₁ h l₂ c) hω).trans
              (agree_eff i₂ t₁ h l₂ c hmem).2.symm))
    have hbase : l₁ t₁ c = l₂ t₁ c := hagree t₁ (Nat.le_refl t₁) c mem hkc
    rw [hbase, htaken, hgiven]

/-- Without `funext`, `(law.withAct part law).next` equals `law.next` after projecting via
`projectHistList`. -/
theorem withAct_self_next_projectHistList {F C : Type} (law : ExchangeLaw F C)
    (present : Nat → List F) (part : F → Bool)
    (keep : C → Bool) (cs : List C) (x : Nat × (Nat → C → Nat)) :
    projectHistList keep cs ((law.withAct part law).next present x) =
      projectHistList keep cs (law.next present x) := by
  have hp := withAct_self_next_pointwise law present part x
  exact (projectHistList_eq_iff keep cs
    ((law.withAct part law).next present x) (law.next present x)).mpr
    ⟨hp.1, fun s _ c _ _ => hp.2 s c⟩

/-- Where a law reads through a web coupling and `keep` retains every coupled condition, every
condition `h` is sensitive to is kept (`cases hkc : keep c`, zero `bool_true_of_not_not`). -/
theorem sensitive_in_of_through {F C : Type}
    {law : ExchangeLaw F C} {W : Web F C} {obs : F → C → Prop} {part : F → Bool}
    (through : law.Through W obs part) {h : F} (out : part h = false)
    (keep : C → Bool) (keeps_coupled : ∀ c, W.CoupledInto obs h c → keep c = true) :
    ∀ c, law.Sensitive h c → keep c = true := by
  intro c hsens
  cases hkc : keep c with
  | true => rfl
  | false =>
    have hnn := through.couples_of_sensitive out hsens
    exact False.elim (hnn fun hcoupled =>
      Bool.noConfusion ((keeps_coupled c hcoupled).symm.trans hkc))

/-! ### Bridges to `Experiment` & `Mechanism` -/

private def retargetBool (C : CausalSystem Q A Bool) (k : Q) (a : A) (κ : Q) :
    CausalSystem Q A Bool where
  obs := C.obs
  proc
    | false => C.proc false
    | true => retarget (C.proc true) k a κ

/-- Observational underdetermination: an observational run `r : Run C₁.passive` cannot fix an
interventional model `C₂ : CausalSystem Q A Bool` when `ω C₁.obs = false` and `∃ j*, ω j* = true`
(CRITICAL FIX B3); and at any untaken `(k, a)` along `r`, passive outcomes are unfixed too. -/
theorem causal_underdetermined_of_untaken {S : Type u} {A : Type v} {I : Type w} {Q : Type u₁}
    {C₁ : CausalSystem S A I} (C₂ : CausalSystem Q A Bool)
    {π : S → Q} {ω : I → Bool} (hobs : C₂.obs = false) (hω_obs : ω C₁.obs = false)
    (h_hit : ∃ j₀, ω j₀ = true)
    (r : Run C₁.passive) {t : Nat} {k : Q} {a : A}
    (law : ∃ P : Process Q A, Determined P ∧ r.StepsThrough π P t)
    (untaken : ¬ r.TakesThrough π t k a)
    (hdet_obs : Determined C₂.passive) (hdet_int : Determined (C₂.proc true))
    (hf_obs : FactorsThrough C₁.passive π C₂.passive)
    {κ₁ κ₂ : Q} (two : κ₁ ≠ κ₂) :
    (¬ ∃ κ, r.FixesThrough π t k a κ) ∧
    ∃ (j₀ : I) (D₁ D₂ : CausalSystem Q A Bool),
      ω j₀ = true ∧
      (∀ j, Determined (D₁.proc j)) ∧ (∀ j, Determined (D₂.proc j)) ∧
      FactorsThrough C₁.passive π D₁.passive ∧ FactorsThrough C₁.passive π D₂.passive ∧
      r.StepsThrough π D₁.passive t ∧ r.StepsThrough π D₂.passive t ∧
      (D₁.proc (ω j₀)).step k a κ₁ ∧ (D₂.proc (ω j₀)).step k a κ₂ ∧
      ω C₁.obs = D₁.obs ∧ ω C₁.obs = D₂.obs := by
  refine ⟨r.not_fixesThrough_of_untaken law untaken two, ?_⟩
  obtain ⟨j₀, hj₀⟩ := h_hit
  let D₁ := retargetBool C₂ k a κ₁
  let D₂ := retargetBool C₂ k a κ₂
  have hdet_p : ∀ κ : Q, ∀ j : Bool, Determined ((retargetBool C₂ k a κ).proc j) := by
    intro κ j
    cases j with
    | false =>
      show Determined (C₂.proc false)
      rw [← hobs]
      exact hdet_obs
    | true => exact retarget_determined hdet_int k a κ
  have hf_p : ∀ κ : Q, FactorsThrough C₁.passive π (retargetBool C₂ k a κ).passive := by
    intro κ
    change FactorsThrough C₁.passive π ((retargetBool C₂ k a κ).proc C₂.obs)
    rw [hobs]
    show FactorsThrough C₁.passive π (C₂.proc false)
    rw [← hobs]
    exact hf_obs
  exact ⟨j₀, D₁, D₂, hj₀, hdet_p κ₁, hdet_p κ₂, hf_p κ₁, hf_p κ₂,
    r.stepsThrough_of_factors (hf_p κ₁) t, r.stepsThrough_of_factors (hf_p κ₂) t,
    hj₀ ▸ retarget_step (C₂.proc true) k a κ₁,
    hj₀ ▸ retarget_step (C₂.proc true) k a κ₂,
    hω_obs.trans hobs.symm, hω_obs.trans hobs.symm⟩

/-- In `CausalSystem.ofMechanism F`, an untaken `(u', e')` at `x` is unfixed by the observational
record (`inputs_intervention_unfixed`) while fixed by the intervened model (`inputs_model_fixes`). -/
theorem mechanism_intervention_underdetermined {X : Type u} {U : Type v} {E : Type w}
    (F : X → U → E → X) (r : Run (CausalSystem.ofMechanism F).passive)
    {t : Nat} {x : X} {u' : U} {e' : E}
    (untaken : ¬ r.Takes t x (u', e')) {y z : X} (two : y ≠ z) :
    (¬ ∃ w, r.Fixes t x (u', e') w) ∧
      ((CausalSystem.ofMechanism F).proc (some u')).step x (u', e') (F x u' e') ∧
      ∀ w, ((CausalSystem.ofMechanism F).proc (some u')).step x (u', e') w → w = F x u' e' :=
  ⟨inputs_intervention_unfixed r untaken two,
   inputs_model_fixes (fun x _ e => F x u' e) x u' e'⟩

/-- Refutation of any deterministic `ExactCausalAbs` on `Confound.process` through `Confound.outcome`,
joining `Confound.varied_refutes` (while `Confound.confounded` admits `Confound.aligned`). -/
theorem exactCausal_refuted_of_confound_varied {J : Type w}
    (D : CausalSystem Bool Confound.Move J) (hdet : ∀ j, Determined (D.proc j))
    (ω : Unit → J) :
    (∀ t, (Confound.run Confound.aligned).StepsThrough Confound.outcome Confound.moveDecides t) ∧
    ¬ ExactCausalAbs ⟨fun _ => Confound.process, ()⟩ D Confound.outcome id ω :=
  ⟨Confound.confounded, fun abs =>
    Confound.varied_refutes ⟨D.proc (ω ()), hdet (ω ()),
      (Confound.run Confound.varied).stepsThrough_of_factors (abs.factors ()) 4⟩⟩

end ExchangeBridge

/-! ### `PositiveCoupledFeedbackWitness`: Non-Exactness + Positive Feedback & Open-Loop Viability -/

namespace PositiveCoupledFeedbackWitness

private theorem div2_add2 (n : Nat) : (n + 2) / 2 = n / 2 + 1 :=
  CoreHelpers.div_add_self 2 (Nat.succ_pos 1) n

private theorem div2_rem : ∀ n : Nat, ∃ q r, n = 2 * q + r ∧ r < 2
  | 0 => ⟨0, 0, rfl, Nat.succ_pos 1⟩
  | 1 => ⟨0, 1, rfl, Nat.lt_succ_self 1⟩
  | n + 2 =>
    match div2_rem n with
    | ⟨q, r, eq, lt⟩ =>
      ⟨q + 1, r, by rw [Nat.mul_succ, Nat.add_right_comm (2 * q) 2 r, ← eq], lt⟩

private theorem div4_rem : ∀ n : Nat, ∃ q r, n = 4 * q + r ∧ r < 4
  | 0 => ⟨0, 0, rfl, Nat.succ_pos 3⟩
  | 1 => ⟨0, 1, rfl, Nat.lt_succ_of_le (Nat.le_trans (Nat.le_succ 1) (Nat.le_succ 2))⟩
  | 2 => ⟨0, 2, rfl, Nat.lt_succ_of_le (Nat.le_succ 2)⟩
  | 3 => ⟨0, 3, rfl, Nat.lt_succ_self 3⟩
  | n + 4 =>
    match div4_rem n with
    | ⟨q, r, eq, lt⟩ =>
      ⟨q + 1, r, by rw [Nat.mul_succ, Nat.add_right_comm (4 * q) 4 r, ← eq], lt⟩

private theorem div2_of_two_mul_add {r : Nat} (hr : r < 2) : ∀ q, (2 * q + r) / 2 = q
  | 0 =>
    match r, hr with
    | 0, _ => rfl
    | 1, _ => rfl
    | _ + 2, hr => absurd hr (Nat.not_lt_of_ge (Nat.le_add_left 2 _))
  | q + 1 => by
    rw [Nat.mul_succ, Nat.add_right_comm (2 * q) 2 r, div2_add2, div2_of_two_mul_add hr q]

private theorem div2_mono {a b : Nat} (le : a ≤ b) : a / 2 ≤ b / 2 := by
  obtain ⟨qa, ra, ha, hra⟩ := div2_rem a
  obtain ⟨qb, rb, hb, hrb⟩ := div2_rem b
  rw [ha, hb, div2_of_two_mul_add hra qa, div2_of_two_mul_add hrb qb]
  match Nat.lt_or_ge qb qa with
  | .inr ge => exact ge
  | .inl lt =>
    have h1 : 2 * qb + rb < 2 * qa + ra := by
      have hqb1 : qb + 1 ≤ qa := lt
      have hrb1 : rb ≤ 1 := Nat.le_of_lt_succ hrb
      have hmul : 2 * qb + 2 ≤ 2 * qa := by
        rw [← Nat.mul_succ]
        exact Nat.mul_le_mul_left 2 hqb1
      exact Nat.lt_of_lt_of_le
        (Nat.lt_of_le_of_lt (Nat.add_le_add_left hrb1 (2 * qb))
          (Nat.add_lt_add_left (Nat.lt_succ_self 1) (2 * qb)))
        (Nat.le_trans hmul (Nat.le_add_right _ _))
    exact absurd (ha ▸ hb ▸ le) (Nat.not_le_of_gt h1)

private theorem div2_of_two_mul_add_gen (b : Nat) : ∀ a : Nat, (2 * a + b) / 2 = a + b / 2
  | 0 => (Nat.zero_add b).symm ▸ (Nat.zero_add (b / 2)).symm
  | a + 1 => by
    rw [Nat.mul_succ, Nat.add_right_comm (2 * a) 2 b, div2_add2, div2_of_two_mul_add_gen b a,
      Nat.add_right_comm a (b / 2) 1]

private theorem damp_ge_of_ge (mid : Nat) {z : Nat} (ge : mid ≤ z) :
    WitnessTwoScale.damp mid z = mid + (z - mid) / 2 := by
  unfold WitnessTwoScale.damp
  rw [CoreHelpers.ite_neg' (Nat.not_lt_of_ge ge)]

def midMacro : Bool → Nat
  | true => 20
  | false => 10

def midMicro : Bool → Nat
  | true => 40
  | false => 20

def nextMicro (i : Bool) (s : Nat × Bool) : Nat × Bool :=
  (WitnessTwoScale.damp (midMicro i) s.1, !s.2)

def nextMacro (i : Bool) (q : Nat) : Nat :=
  WitnessTwoScale.damp (midMacro i) q

def micro : CausalSystem (Nat × Bool) Unit Bool :=
  CausalSystem.ofMap (fun i s _ => nextMicro i s) false

def macroSys : CausalSystem Nat Unit Bool :=
  CausalSystem.ofMap (fun i q _ => nextMacro i q) false

def π (s : Nat × Bool) : Nat := s.1 / 2
def κ (q : Nat) : Bool := Nat.ble q 18
def s₀ : Nat × Bool := (40, false)
def guardQ (q : Nat) : Prop := 12 ≤ q
def guardS (s : Nat × Bool) : Prop := 20 ≤ s.1

/-- No exact causal abstraction exists from `micro` to `macroSys` through `π` for any `φ, ω`. -/
theorem no_exact_causal_abs (φ : Unit → Unit) (ω : Bool → Bool) :
    ¬ ExactCausalAbs micro macroSys π φ ω := by
  intro abs
  have h1 := abs.factors true (38, false) () (nextMicro true (38, false)) rfl
  have h2 := abs.factors true (39, false) () (nextMicro true (39, false)) rfl
  have e1 : (19 : Nat) = nextMacro (ω true) 19 := h1
  have e2 : (20 : Nat) = nextMacro (ω true) 19 := h2
  exact Nat.lt_irrefl 19 (Nat.lt_of_lt_of_le (Nat.lt_succ_self 19) (Nat.le_of_eq (e1.trans e2.symm).symm))

/-- One-step projection error between `nextMicro` and `nextMacro` is uniformly `≤ 1` everywhere. -/
theorem step_projection_err :
    ∀ (i : Bool) (s : Nat × Bool), distNat ((nextMicro i s).1 / 2) (nextMacro i (π s)) ≤ 1 := by
  intro i ⟨x, b⟩
  cases Nat.lt_or_ge x 40 with
  | inl lt =>
    have hle : x ≤ 39 := Nat.le_of_lt_succ lt
    have all_ok :
        (downFrom 39).all (fun k =>
          Nat.ble (distNat (WitnessTwoScale.damp 40 k / 2) (WitnessTwoScale.damp 20 (k / 2))) 1 &&
          Nat.ble (distNat (WitnessTwoScale.damp 20 k / 2) (WitnessTwoScale.damp 10 (k / 2))) 1) = true := rfl
    have hmem := ListTests.all_mem all_ok (mem_downFrom hle)
    cases i with
    | true => exact Nat.le_of_ble_eq_true (ListTests.and_left hmem)
    | false => exact Nat.le_of_ble_eq_true (ListTests.and_right hmem)
  | inr ge =>
    obtain ⟨d, hd⟩ := le_dest ge
    subst hd
    have hx2 : (40 + d) / 2 = 20 + d / 2 := div2_of_two_mul_add_gen d 20
    cases i with
    | true =>
      have hmicro : WitnessTwoScale.damp 40 (40 + d) = 40 + d / 2 := by
        rw [damp_ge_of_ge 40 (Nat.le_add_right 40 d), Naturals.add_sub_cancel_left 40 d]
      have hmicro2 : (40 + d / 2) / 2 = 20 + (d / 2) / 2 := div2_of_two_mul_add_gen (d / 2) 20
      have hmacro : WitnessTwoScale.damp 20 ((40 + d) / 2) = 20 + (d / 2) / 2 := by
        rw [hx2, damp_ge_of_ge 20 (Nat.le_add_right 20 (d / 2)), Naturals.add_sub_cancel_left 20 (d / 2)]
      change distNat (WitnessTwoScale.damp 40 (40 + d) / 2) (WitnessTwoScale.damp 20 ((40 + d) / 2)) ≤ 1
      rw [hmicro, hmicro2, hmacro, distNat_self]
      exact Nat.zero_le 1
    | false =>
      have hge20 : 20 ≤ 40 + d := Nat.le_trans (Nat.le_add_right 20 20) (Nat.le_add_right 40 d)
      have hsub20 : (40 + d) - 20 = 20 + d := by
        have h40 : 40 + d = 20 + (20 + d) := Nat.add_assoc 20 20 d
        rw [h40, Naturals.add_sub_cancel_left 20 (20 + d)]
      have hmicro : WitnessTwoScale.damp 20 (40 + d) = 30 + d / 2 := by
        rw [damp_ge_of_ge 20 hge20, hsub20, div2_of_two_mul_add_gen d 10]
        exact (Nat.add_assoc 20 10 (d / 2)).symm
      have hmicro2 : (30 + d / 2) / 2 = 15 + (d / 2) / 2 := div2_of_two_mul_add_gen (d / 2) 15
      have hmacro : WitnessTwoScale.damp 10 ((40 + d) / 2) = 15 + (d / 2) / 2 := by
        rw [hx2, damp_ge_of_ge 10 (Nat.le_trans (Nat.le_add_right 10 10) (Nat.le_add_right 20 (d / 2))),
          show (20 + d / 2) - 10 = 10 + d / 2 from by
            have h20 : 20 + d / 2 = 10 + (10 + d / 2) := Nat.add_assoc 10 10 (d / 2)
            rw [h20, Naturals.add_sub_cancel_left 10 (10 + d / 2)],
          div2_of_two_mul_add_gen (d / 2) 5]
        exact (Nat.add_assoc 10 5 (d / 2 / 2)).symm
      change distNat (WitnessTwoScale.damp 20 (40 + d) / 2) (WitnessTwoScale.damp 10 ((40 + d) / 2)) ≤ 1
      rw [hmicro, hmicro2, hmacro, distNat_self]
      exact Nat.zero_le 1

/-- Contractive one-step lax causal abstraction (`α r = (r + 1) / 2`, `ε = 1`, `β = id`, `η = 0`). -/
def laxAbs : LaxCausalAbs micro macroSys π id id SlackDist.nat where
  obs_eq := rfl
  strict _ := Nat.lt_succ_self _
  Epoch _ _ := True
  EpochQ _ _ := True
  epoch_step _ _ _ _ _ _ _ := trivial
  epoch_proj _ _ _ := trivial
  α r := (r + 1) / 2
  β := id
  α_mono le := div2_mono (Nat.add_le_add_right le 1)
  β_mono le := le
  β_ge_id r := Nat.le_refl r
  ε := 1
  η := 0
  sim_block i k s q r w s' _ _ d_le w_len tr := by
    have w1 : w.length = 1 := w_len.trans (succ_sub_self k)
    match w with
    | [] => exact Nat.noConfusion w1
    | [_] =>
      match tr with
      | .cons step (.nil _) =>
        have hs' : s' = nextMicro i s := step
        rw [hs']
        refine ⟨(), nextMacro i q, rfl, trivial, ?_⟩
        have herr := step_projection_err i s
        have hlip : distNat (nextMacro i (π s)) (nextMacro i q) ≤ (r + 1) / 2 :=
          Nat.le_trans (WitnessTwoScale.damp_lip (midMacro i) (π s) q)
            (div2_mono (Nat.add_le_add_right d_le 1))
        exact Nat.le_trans (distNat_tri (π (nextMicro i s)) (nextMacro i (π s)) (nextMacro i q))
          (Nat.le_trans (Nat.add_le_add herr hlip) (Nat.add_comm 1 ((r + 1) / 2) ▸ Nat.le_refl _))
    | _ :: _ :: _ => exact Nat.noConfusion (Nat.succ.inj w1)
  excursion _ k s q r w₁ u _ _ d_le w₁_lt tr := by
    have hlt : w₁.length < 1 := (succ_sub_self k) ▸ w₁_lt
    match w₁ with
    | [] =>
      match tr with
      | .nil _ => exact d_le
    | _ :: _ => exact absurd hlt (Nat.not_lt_of_le (Nat.le_add_left 1 _))

private theorem margin_witness (q : Nat) (u : Nat × Bool) (gq : guardQ q)
    (hd : SlackDist.nat.d (π u) q ≤ laxAbs.β 2 + laxAbs.η) : guardS u := by
  have hsub : q - u.1 / 2 ≤ 2 := Nat.le_trans (Nat.le_add_left _ _) hd
  have h10 : 10 ≤ u.1 / 2 :=
    le_of_add_le_add_right 2
      (Nat.le_trans (Nat.le_trans (Nat.add_le_add_right gq 2 |> fun _ => gq)
          (CoreHelpers.le_sub_add_nat q (u.1 / 2)))
        (Nat.le_trans (Nat.add_le_add_right hsub (u.1 / 2)) (Nat.le_of_eq (Nat.add_comm 2 (u.1 / 2)))))
  obtain ⟨qu, ru, hu, hru⟩ := div2_rem u.1
  rw [hu, div2_of_two_mul_add hru qu] at h10
  have h20 : 20 ≤ 2 * qu := Nat.mul_le_mul_left 2 h10
  exact Nat.le_trans h20 (Nat.le_trans (Nat.le_add_right (2 * qu) ru) (Nat.le_of_eq hu.symm))

/-- Certified closed-loop feedback viability kernel for `guardS` from `s₀ = (40, false)` under
`κ q := Nat.ble q 18` via `laxCausal_feedback_kernel_transfer`. -/
theorem feedback_viability_kernel :
    Viability.Kernel (micro.feedbackProcess (fun s => κ (π s))) guardS s₀ := by
  let K : Nat → Prop := fun q => 12 ≤ q ∧ q ≤ 20
  have habsorb : laxAbs.α 2 + laxAbs.ε ≤ 2 := by
    show (2 + 1) / 2 + 1 ≤ 2
    exact Nat.le_refl 2
  have hclosed : ∀ q₁ q₂ b q₂',
      K q₂ → distNat q₁ q₂ ≤ 2 → (macroSys.proc (κ q₁)).step q₂ b q₂' → K q₂' := by
    intro q₁ q₂ _ q₂' ⟨hq2_lo, hq2_hi⟩ hd step
    have hq2' : q₂' = nextMacro (κ q₁) q₂ := step
    rw [hq2']
    cases Nat.lt_or_ge 16 q₂ with
    | inr h16 =>
      have hsub1 : q₁ - q₂ ≤ 2 := Nat.le_trans (Nat.le_add_right _ _) hd
      have hq1_le : q₁ ≤ 18 :=
        Nat.le_trans (CoreHelpers.le_sub_add_nat q₁ q₂)
          (Nat.le_trans (Nat.add_le_add hsub1 h16) (Nat.le_refl 18))
      have hκ : κ q₁ = true := Nat.ble_eq_true_of_le hq1_le
      rw [hκ]
      have all_ok : (downFrom 16).all (fun k =>
          (Nat.ble 12 (nextMacro true k) && Nat.ble (nextMacro true k) 20) ||
          Nat.blt k 12) = true := rfl
      have hmem := ListTests.all_mem all_ok (mem_downFrom h16)
      cases ListTests.or_true_iff.mp hmem with
      | inr hlt12 => exact absurd hq2_lo (Nat.not_le_of_gt (CoreHelpers.natBlt_true_iff.mp hlt12))
      | inl hok =>
        exact ⟨Nat.le_of_ble_eq_true (ListTests.and_left hok),
               Nat.le_of_ble_eq_true (ListTests.and_right hok)⟩
    | inl h17 =>
      have all_ok : (downFrom 20).all (fun k =>
          (Nat.ble 12 (nextMacro true k) && Nat.ble (nextMacro true k) 20) &&
          (Nat.ble 12 (nextMacro false k) && Nat.ble (nextMacro false k) 20) ||
          Nat.blt k 17) = true := rfl
      have hmem := ListTests.all_mem all_ok (mem_downFrom hq2_hi)
      cases ListTests.or_true_iff.mp hmem with
      | inr hlt17 => exact absurd h17 (Nat.not_lt_of_ge (Nat.le_of_lt_succ (CoreHelpers.natBlt_true_iff.mp hlt17)))
      | inl hboth =>
        cases κ q₁ with
        | true =>
          have ht := ListTests.and_left hboth
          exact ⟨Nat.le_of_ble_eq_true (ListTests.and_left ht),
                 Nat.le_of_ble_eq_true (ListTests.and_right ht)⟩
        | false =>
          have hf := ListTests.and_right hboth
          exact ⟨Nat.le_of_ble_eq_true (ListTests.and_left hf),
                 Nat.le_of_ble_eq_true (ListTests.and_right hf)⟩
  exact laxCausal_feedback_kernel_transfer laxAbs κ 2 habsorb (fun _ h => h.1) hclosed margin_witness
    trivial ⟨by exact Nat.le_add_left 12 8, Nat.le_refl 20⟩

/-- Certified open-loop viability kernel for `guardS` from `(0, s₀)` under steady safe schedule
`fun _ => true` via `laxCausal_openLoop_kernel_transfer`. -/
theorem openLoop_viability_kernel :
    Viability.Kernel (micro.scheduledProcess id (fun _ => true)) (fun ts => guardS ts.2) (0, s₀) := by
  have kernQ : Viability.Kernel (macroSys.scheduledProcess id (fun _ => true))
      (fun kq => guardQ kq.2) (0, π s₀) := by
    let certQ : Viability.Certificate (macroSys.scheduledProcess id (fun _ => true))
        (fun kq => guardQ kq.2) (fun kq => kq.2 = 20) :=
      ⟨fun kq hk => hk ▸ (Nat.le_add_left 12 8),
       fun kq _ kq' step hk => by
         have hstep : kq'.2 = nextMacro true kq.2 := step.2
         rw [hstep, hk]
         rfl⟩
    exact certQ.kernel rfl
  exact laxCausal_openLoop_kernel_transfer laxAbs (fun _ => true) 2 (Nat.le_refl 2)
    (fun kq u gq hd => margin_witness kq.2 u.2 gq hd) trivial kernQ

end PositiveCoupledFeedbackWitness

end Becoming
