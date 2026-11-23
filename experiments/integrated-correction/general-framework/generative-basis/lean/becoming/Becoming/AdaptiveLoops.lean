import Becoming.ReadingLoop
import Becoming.PoolFromCourse
import Becoming.SelectionPool
import Becoming.CoupledDrawers
import Becoming.FreeEnergyGuarantees
import Becoming.RegimeMargin
import Becoming.JointKeeping
import Becoming.Mechanism
import Becoming.Composition
import Becoming.Pace

/-!
# Adaptive loops: open interfaces, coupled races, and endogenous adaptation

This module (`AI-written` for Milestone 1B) formalizes open adaptive loops and their parallel
assume-guarantee composition over coupled substrates (`RegimeMargin.Coupled.Indexed`), proves
the Coupled Race theorem with five contrasting witnesses, proves collapse of `ClosedCapture.Unread`
adaptive loops under a joint draw, and constructs a concrete bidirectional endogenous adaptation
witness certified as a black box.

* **Part 1 — Open adaptive loop interface and assume-guarantee composition.**
  An `OpenLoop` turns an internal state `S`, an observation `Obs`, an alarm signal `Bool`, and a
  disturbance `Dist` into a next internal state, site draws `draw : S → ι → Nat`, an observation-driven
  alarm emission `emitAlarm : S → Obs → Bool`, a silencing load `silenceLoad : S → Nat`, and a
  favouring predicate `favours : S → Prop`. Its isolated dynamics is the disturbed process
  `OpenLoop.process` with state-independent admissibility `tol`. A `LoopCertificate` certifies
  an invariance set `K` holding `init`, bounds on `draw` and `silenceLoad`, observation-triggered
  `emitAlarm`, and bounded countdown `eta ≤ maxLag` that strictly decreases on `alarm = true` and
  stays zero once zero. In `jointStep`, the communication `channel : (α → Bool) → (α → Nat) → Env → Bool`
  never receives the substrate `st.1 : ι → Nat` directly; it receives only each agent's `emitAlarm`
  and `silenceLoad` plus `env`. `assume_guarantee_joint_viable` proves `Viability.Certificate` for
  the joint process purely from opaque `OpenLoop` / `LoopCertificate` contracts (without unfolding
  `(L i).next` or `(certs i).K`), via `indexedStep_antitone_H` and `RegimeMargin.Coupled.Indexed.step_mono`.

* **Part 2 — The Coupled Race theorem and five witnesses.**
  `raceStep` embeds `Becoming.Web.MajorityHolds` over five members (`cap1, cap2, watch1, watch2, watch3`)
  directly into its step-3 alarm check and links post-turn draw directly to `Optimum.AtOnce.sumTo`
  over `Optimum.Coupled.AtOnce.Shores.shore 1` (`p = 1 < m = 2`), with `Optimum.Coupled.AtOnce.Shores.drain_perfect`
  certifying the uncoordinated drain profile (`H_uncoord = 2 > Y = 1`) as `Perfect` for every
  coupling rate `c` and horizon `N`, while `Becoming.Web.majority_outvoted` proves why silencing the
  three uncaptured watchers (`K_silence ≤ loss`) flips the pool. Five contrasting witnesses
  (`WitnessGood`, `WitnessNoDiscovery`, `WitnessSilenced`, `WitnessUncoordinated`, `WitnessTooSlow`)
  and `coupled_race_theorem` establish each failure mode and the viable regime.

* **Part 3 — Collapse of `Unread` adapting loops and endogenous composite witness.**
  - §3(a): `unread_adaptive_joint_collapse` combines `ClosedCapture.unread_course`, a monotone
    orbit comparison `unread_orbit_le`, `RegimeMargin.falls_within`, and `RegimeMargin.ends_below`
    to prove substrate collapse alongside identical local/rule trajectories (`b₀` vs `b_big`).
    `UnreadAdaptiveCollapse` exhibits two loops with non-cosmetic rule flips (`draw true = 2`,
    `draw false = 3`) that each hold forever alone (`H ≤ 3`) yet crash (`6 → 2 → 0` or `6 → 1 → 0`)
    jointly while preserving `LocalOK` and identical rule flipping against `b_big = 100`.
  - §3(b): `EndogenousCompositeWitness` builds a concrete 2-agent `OpenLoop` over `ι := Unit`
    using `ReadingLoop.Loop.keep`, `PoolFromCourse.windowRead`, and `Mechanism.adaptive`, applies
    `assume_guarantee_joint_viable` as a black box, and proves bidirectional endogenous adaptation
    (`¬ favours → favours → ¬ favours`) along a single admissible run while keeping the same
    `LoopCertificate`.

All declarations are prelude-only with empty axiom reports (`0` axioms, `0` `sorry`).
-/

namespace Becoming

open Generative

namespace AdaptiveLoops

/-! ## Prelude-only natural-number and list helpers -/

/-- Decidable `Nat` maximum without core `Max` axioms. -/
def natMax (a b : Nat) : Nat := if a ≤ b then b else a

theorem le_natMax_left (a b : Nat) : a ≤ natMax a b :=
  match Nat.decLe a b with
  | isTrue le => Nat.le_trans le (Nat.le_of_eq (if_pos le).symm)
  | isFalse notLe => Nat.le_of_eq (if_neg notLe).symm

theorem le_natMax_right (a b : Nat) : b ≤ natMax a b :=
  match Nat.decLe a b with
  | isTrue le => Nat.le_of_eq (if_pos le).symm
  | isFalse notLe => Nat.le_trans (Nat.le_of_lt (Nat.gt_of_not_le notLe))
      (Nat.le_of_eq (if_neg notLe).symm)

theorem natMax_le {a b c : Nat} (ha : a ≤ c) (hb : b ≤ c) : natMax a b ≤ c :=
  match Nat.decLe a b with
  | isTrue le => Nat.le_trans (Nat.le_of_eq (if_pos le)) hb
  | isFalse notLe => Nat.le_trans (Nat.le_of_eq (if_neg notLe)) ha

theorem natBlt_true_iff {a b : Nat} : Nat.blt a b = true ↔ a < b :=
  ⟨fun h => Nat.le_of_ble_eq_true h, fun lt => Nat.ble_eq_true_of_le lt⟩

theorem natBlt_false_iff {a b : Nat} : Nat.blt a b = false ↔ b ≤ a :=
  ⟨fun h => Nat.lt_or_ge a b |>.elim (fun lt => Bool.noConfusion ((natBlt_true_iff.mpr lt).symm.trans h)) id,
   fun le => Naturals.ble_false_of_lt (Nat.lt_succ_of_le le)⟩

theorem natBeq_true_iff {a b : Nat} : Nat.beq a b = true ↔ a = b :=
  ⟨Nat.eq_of_beq_eq_true, fun same => same ▸ beq_self a⟩

/-! ## Part 1: Open Adaptive Loop Interface & Assume-Guarantee Composition -/

/-- An open adaptive loop interacting with a substrate via observations `Obs`, an external alarm
`Bool`, and disturbances `Dist`. -/
structure OpenLoop (S Obs Dist ι : Type) where
  next : S → Obs × Bool → Dist → S
  draw : S → ι → Nat
  emitAlarm : S → Obs → Bool
  silenceLoad : S → Nat
  favours : S → Prop

/-- The disturbed process of an open loop, with state-independent disturbance admissibility `tol`. -/
def OpenLoop.process {S Obs Dist ι : Type} (L : OpenLoop S Obs Dist ι)
    (tol : Obs × Bool → Dist → Prop) : Process S ((Obs × Bool) × Dist) :=
  Viability.disturbed (fun s m => L.next s m.1 m.2) (fun m => tol m.1 m.2)

/-- An assume-guarantee certificate for an `OpenLoop` from `init`, certifying pre-adaptation draw
bounds, silence bounds, observation-driven alarm emission, and bounded countdown `eta`. -/
structure LoopCertificate {S Obs Dist ι : Type}
    (L : OpenLoop S Obs Dist ι) (init : S) where
  tol : Obs × Bool → Dist → Prop
  warnObs : Obs → Prop
  preCap : ι → Nat
  postBudget : ι → Nat
  maxSilence : Nat
  maxLag : Nat
  K : S → Prop
  eta : S → Nat
  init_in : K init
  cert : Viability.Certificate (L.process tol)
    (fun s => (∀ j, L.draw s j ≤ preCap j) ∧
              L.silenceLoad s ≤ maxSilence ∧
              (eta s = 0 → ¬ L.favours s ∧ ∀ j, L.draw s j ≤ postBudget j)) K
  eta_bound : ∀ s, K s → eta s ≤ maxLag
  emits_on_warn : ∀ s obs, K s → warnObs obs → L.emitAlarm s obs = true
  eta_alarm_step : ∀ s obs dist, tol (obs, true) dist → K s → 0 < eta s →
    eta (L.next s (obs, true) dist) < eta s
  eta_alarm_zero : ∀ s obs dist, tol (obs, true) dist → K s → eta s = 0 →
    eta (L.next s (obs, true) dist) = 0

/-- **Monotonicity of coupled indexed substrate step in the state `x`.** -/
theorem indexedStep_mono {ι : Type}
    {G : ι → (ι → Nat) → Nat} (rises : ∀ i, RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (G i))
    (H : ι → Nat) {x y : ι → Nat} (below : ∀ i, x i ≤ y i) (j : ι) :
    RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole G H x j ≤
      RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole G H y j :=
  RegimeMargin.Coupled.Indexed.step_mono rises H below j

/-- **Antitonicity of coupled indexed substrate step in the draw `H`.** -/
theorem indexedStep_antitone_H {ι : Type}
    {G : ι → (ι → Nat) → Nat} (rises : ∀ i, RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (G i))
    {H H' : ι → Nat} (hle : ∀ j, H j ≤ H' j) (x : ι → Nat) (j : ι) :
    RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole G H' x j ≤
      RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole G H x j := by
  have leftBelow : RegimeMargin.Coupled.Indexed.Below RegimeMargin.Drawn.whole
      (RegimeMargin.Coupled.Indexed.left RegimeMargin.Drawn.whole H' x)
      (RegimeMargin.Coupled.Indexed.left RegimeMargin.Drawn.whole H x) :=
    fun k => Naturals.sub_antitone (x k) (hle k)
  exact Nat.add_le_add (leftBelow j) (rises j _ _ leftBelow)

/-- Each coupled indexed substrate step is at least what remains after the draw `H`. -/
theorem indexedStep_ge_sub {ι : Type}
    (G : ι → (ι → Nat) → Nat) (H x : ι → Nat) (j : ι) :
    x j - H j ≤ RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole G H x j :=
  Nat.le_add_right _ _

/-- Total draw across a list of agents at site `j`. -/
def sumDraws {α ι : Type} (agents : List α) (f : α → ι → Nat) (j : ι) : Nat :=
  match agents with
  | [] => 0
  | i :: rest => f i j + sumDraws rest f j

theorem sumDraws_le {α ι : Type} {f g : α → ι → Nat} (j : ι) :
    ∀ {agents : List α}, (∀ i, i ∈ agents → f i j ≤ g i j) →
      sumDraws agents f j ≤ sumDraws agents g j
  | [], _ => Nat.le_refl 0
  | _ :: _, bound => Nat.add_le_add (bound _ (.head _))
      (sumDraws_le j fun i mem => bound i (.tail _ mem))

/-- Folded maximum of a `Nat`-valued function over `agents`. -/
def foldNatMax {α : Type} (agents : List α) (f : α → Nat) : Nat :=
  agents.foldr (fun i acc => natMax (f i) acc) 0

theorem le_foldNatMax_of_mem {α : Type} {f : α → Nat} :
    ∀ {agents : List α} {i : α}, i ∈ agents → f i ≤ foldNatMax agents f
  | [], _, mem => absurd mem ListTests.not_mem_nil
  | _ :: _, _, .head _ => le_natMax_left _ _
  | _ :: _, _, .tail _ mem => Nat.le_trans (le_foldNatMax_of_mem mem) (le_natMax_right _ _)

theorem foldNatMax_le_of_all {α : Type} {f : α → Nat} {M : Nat} :
    ∀ {agents : List α}, (∀ i, i ∈ agents → f i ≤ M) → foldNatMax agents f ≤ M
  | [], _ => Nat.zero_le M
  | _ :: _, all => natMax_le (all _ (.head _))
      (foldNatMax_le_of_all fun i mem => all i (.tail _ mem))

theorem foldNatMax_eq_zero {α : Type} {f : α → Nat} :
    ∀ {agents : List α}, (∀ i, i ∈ agents → f i = 0) → foldNatMax agents f = 0
  | [], _ => rfl
  | _ :: _, zero =>
    Nat.le_antisymm
      (natMax_le (Nat.le_of_eq (zero _ (.head _)))
        (Nat.le_of_eq (foldNatMax_eq_zero fun i mem => zero i (.tail _ mem))))
      (Nat.zero_le _)

theorem foldNatMax_succ_le {α : Type} {f : α → Nat} {M : Nat} (pos : 0 < M) :
    ∀ {agents : List α}, (∀ i, i ∈ agents → f i + 1 ≤ M) → foldNatMax agents f + 1 ≤ M
  | [], _ => pos
  | a :: rest, all => by
    have ih := foldNatMax_succ_le pos fun i mem => all i (.tail _ mem)
    have ha := all a (.head _)
    show natMax (f a) (foldNatMax rest f) + 1 ≤ M
    match Nat.decLe (f a) (foldNatMax rest f) with
    | isTrue le =>
      rw [show natMax (f a) (foldNatMax rest f) = foldNatMax rest f from if_pos le]
      exact ih
    | isFalse notLe =>
      rw [show natMax (f a) (foldNatMax rest f) = f a from if_neg notLe]
      exact ha

/-- Maximum lag across all certified agents. -/
def globalMaxLag {α ι : Type} {S Obs Dist : α → Type}
    {L : (i : α) → OpenLoop (S i) (Obs i) (Dist i) ι}
    {init : (i : α) → S i}
    (agents : List α) (certs : (i : α) → LoopCertificate (L i) (init i)) : Nat :=
  foldNatMax agents (fun i => (certs i).maxLag)

/-- Maximum current adaptation lag `eta` across `agents`. -/
def maxEta {α ι : Type} {S Obs Dist : α → Type}
    {L : (i : α) → OpenLoop (S i) (Obs i) (Dist i) ι}
    {init : (i : α) → S i}
    (agents : List α) (certs : (i : α) → LoopCertificate (L i) (init i))
    (s : (i : α) → S i) : Nat :=
  foldNatMax agents (fun i => (certs i).eta (s i))

/-- Total pre-adaptation draw budget at site `j` (agents' `preCap` plus environment `envCap`). -/
def preTotal {α ι : Type} {S Obs Dist : α → Type}
    {L : (i : α) → OpenLoop (S i) (Obs i) (Dist i) ι}
    {init : (i : α) → S i}
    (agents : List α) (certs : (i : α) → LoopCertificate (L i) (init i))
    (envCap : ι → Nat) (j : ι) : Nat :=
  sumDraws agents (fun i => (certs i).preCap) j + envCap j

/-- Joint transition step: `channel` sees ONLY `(emit, load, env)` and is blind to `st.1 : ι → Nat`.
Each agent draws from its current state `st.2 i` while advancing to `(L i).next (st.2 i) (obs_i, alarm) (m.2 i)`. -/
def jointStep {α ι Env : Type} {S Obs Dist : α → Type}
    (agents : List α)
    (L : (i : α) → OpenLoop (S i) (Obs i) (Dist i) ι)
    (obs : (i : α) → (ι → Nat) → Obs i)
    (channel : (α → Bool) → (α → Nat) → Env → Bool)
    (G : ι → (ι → Nat) → Nat)
    (envDraw : Env → ι → Nat)
    (st : (ι → Nat) × ((i : α) → S i))
    (m : Env × ((i : α) → Dist i)) :
    (ι → Nat) × ((i : α) → S i) :=
  let obsAt := fun i => obs i st.1
  let emit := fun i => (L i).emitAlarm (st.2 i) (obsAt i)
  let load := fun i => (L i).silenceLoad (st.2 i)
  let alarm := channel emit load m.1
  let H := fun j => sumDraws agents (fun i => (L i).draw (st.2 i)) j + envDraw m.1 j
  (RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole G H st.1,
   fun i => (L i).next (st.2 i) (obsAt i, alarm) (m.2 i))

/-- State-independent joint disturbance admissibility. -/
def jointAdmAll {α ι Env : Type} {S Obs Dist : α → Type}
    {L : (i : α) → OpenLoop (S i) (Obs i) (Dist i) ι}
    {init : (i : α) → S i}
    (agents : List α) (certs : (i : α) → LoopCertificate (L i) (init i))
    (jointAdm : Env → Prop) (m : Env × ((i : α) → Dist i)) : Prop :=
  jointAdm m.1 ∧ ∀ i, i ∈ agents → ∀ ob, (certs i).tol ob (m.2 i)

/-- The parallel composed open-loop process under `Viability.disturbed`. -/
def jointProcess {α ι Env : Type} {S Obs Dist : α → Type}
    (agents : List α)
    (L : (i : α) → OpenLoop (S i) (Obs i) (Dist i) ι)
    {init : (i : α) → S i}
    (certs : (i : α) → LoopCertificate (L i) (init i))
    (obs : (i : α) → (ι → Nat) → Obs i)
    (channel : (α → Bool) → (α → Nat) → Env → Bool)
    (G : ι → (ι → Nat) → Nat)
    (envDraw : Env → ι → Nat)
    (jointAdm : Env → Prop) :
    Process ((ι → Nat) × ((i : α) → S i)) (Env × ((i : α) → Dist i)) :=
  Viability.disturbed (jointStep agents L obs channel G envDraw) (jointAdmAll agents certs jointAdm)

/-- The joint safety guard: every site stays at or above `x_crit`, and every agent satisfies its
contract guard. -/
def jointGuard {α ι : Type} {S Obs Dist : α → Type}
    (agents : List α)
    (L : (i : α) → OpenLoop (S i) (Obs i) (Dist i) ι)
    {init : (i : α) → S i}
    (certs : (i : α) → LoopCertificate (L i) (init i))
    (x_crit : ι → Nat)
    (st : (ι → Nat) × ((i : α) → S i)) : Prop :=
  (∀ j, x_crit j ≤ st.1 j) ∧
  ∀ i, i ∈ agents →
    (∀ j, (L i).draw (st.2 i) j ≤ (certs i).preCap j) ∧
    (L i).silenceLoad (st.2 i) ≤ (certs i).maxSilence ∧
    ((certs i).eta (st.2 i) = 0 →
      ¬ (L i).favours (st.2 i) ∧ ∀ j, (L i).draw (st.2 i) j ≤ (certs i).postBudget j)

/-- The joint viability invariant: each agent remains inside its opaque certificate `K`, and each
site retains margin `(maxEta s) * preTotal j` above `x_crit j`. -/
def jointInv {α ι : Type} {S Obs Dist : α → Type}
    (agents : List α)
    {L : (i : α) → OpenLoop (S i) (Obs i) (Dist i) ι}
    {init : (i : α) → S i}
    (certs : (i : α) → LoopCertificate (L i) (init i))
    (envCap x_crit : ι → Nat)
    (st : (ι → Nat) × ((i : α) → S i)) : Prop :=
  (∀ i, i ∈ agents → (certs i).K (st.2 i)) ∧
  ∀ j, x_crit j + maxEta agents certs st.2 * preTotal agents certs envCap j ≤ st.1 j

/-- **Assume-guarantee composition over opaque open-loop contracts (`assume_guarantee_joint_viable`).**
Proved purely from the `OpenLoop` / `LoopCertificate` interface without unfolding `(L i).next` or
`(certs i).K`. -/
theorem assume_guarantee_joint_viable {α ι Env : Type} {S Obs Dist : α → Type}
    (agents : List α) (sites : List ι) (site_in : ∀ j : ι, j ∈ sites)
    (L : (i : α) → OpenLoop (S i) (Obs i) (Dist i) ι)
    (init : (i : α) → S i)
    (certs : (i : α) → LoopCertificate (L i) (init i))
    (obs : (i : α) → (ι → Nat) → Obs i)
    (channel : (α → Bool) → (α → Nat) → Env → Bool)
    (G : ι → (ι → Nat) → Nat)
    (envDraw : Env → ι → Nat) (envCap : ι → Nat) (jointAdm : Env → Prop)
    (env_within : ∀ env, jointAdm env → ∀ j, envDraw env j ≤ envCap j)
    (x_crit warnLevel H_safe x₀ : ι → Nat)
    (monitored : α → ι → Prop)
    (obs_detects : ∀ i, i ∈ agents → ∀ x j, monitored i j → x j < warnLevel j →
      (certs i).warnObs (obs i x))
    (pooled_coverage : ∀ j, j ∈ sites → ∃ i, i ∈ agents ∧ monitored i j)
    (channel_fires : ∀ emit load env, jointAdm env →
      (∃ i, i ∈ agents ∧ emit i = true ∧ load i ≤ (certs i).maxSilence) →
      (∀ i, i ∈ agents → load i ≤ (certs i).maxSilence) →
      channel emit load env = true)
    (G_rises : ∀ i, RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (G i))
    (post_viable : ∀ j, x_crit j ≤ RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole G H_safe x_crit j)
    (post_budget : ∀ j, sumDraws agents (fun i => (certs i).postBudget) j + envCap j ≤ H_safe j)
    (warn_margin : ∀ j, x_crit j + (globalMaxLag agents certs + 1) * preTotal agents certs envCap j ≤ warnLevel j)
    (init_margin : ∀ j, x_crit j + maxEta agents certs init * preTotal agents certs envCap j ≤ x₀ j) :
    jointInv agents certs envCap x_crit (x₀, init) ∧
    Viability.Certificate (jointProcess agents L certs obs channel G envDraw jointAdm)
      (jointGuard agents L certs x_crit) (jointInv agents certs envCap x_crit) := by
  refine ⟨⟨fun i _ => (certs i).init_in, init_margin⟩, Viability.certificate_disturbed_iff.mpr ⟨?_, ?_⟩⟩
  · intro st ⟨inK, margin⟩
    refine ⟨fun j => Nat.le_trans (Nat.le_add_right _ _) (margin j), fun i mem => ?_⟩
    exact (certs i).cert.within _ (inK i mem)
  · intro st m adm ⟨inK, margin⟩
    obtain ⟨x, s⟩ := st
    obtain ⟨env, dist⟩ := m
    obtain ⟨envOk, tolOk⟩ := adm
    let obsAt : (i : α) → Obs i := fun i => obs i x
    let emit : α → Bool := fun i => (L i).emitAlarm (s i) (obsAt i)
    let load : α → Nat := fun i => (L i).silenceLoad (s i)
    let alarm : Bool := channel emit load env
    let H : ι → Nat := fun j => sumDraws agents (fun i => (L i).draw (s i)) j + envDraw env j
    let x' := RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole G H x
    let s' : (i : α) → S i := fun i => (L i).next (s i) (obsAt i, alarm) (dist i)
    have silenceAll : ∀ i, i ∈ agents → load i ≤ (certs i).maxSilence := fun i mem =>
      ((certs i).cert.within _ (inK i mem)).2.1
    have drawPre : ∀ i, i ∈ agents → ∀ j, (L i).draw (s i) j ≤ (certs i).preCap j := fun i mem =>
      ((certs i).cert.within _ (inK i mem)).1
    have H_le_pre : ∀ j, H j ≤ preTotal agents certs envCap j := fun j =>
      Nat.add_le_add (sumDraws_le j fun i mem => drawPre i mem j) (env_within env envOk j)
    have inK' : ∀ i, i ∈ agents → (certs i).K (s' i) := fun i mem =>
      (certs i).cert.closed (s i) ((obsAt i, alarm), dist i) (s' i)
        ⟨tolOk i mem (obsAt i, alarm), rfl⟩ (inK i mem)
    have maxEta_le_global : maxEta agents certs s' ≤ globalMaxLag agents certs :=
      foldNatMax_le_of_all fun i mem =>
        Nat.le_trans ((certs i).eta_bound (s' i) (inK' i mem))
          (le_foldNatMax_of_mem (f := fun i => (certs i).maxLag) mem)
    refine ⟨inK', fun j => ?_⟩
    cases Nat.lt_or_ge (x j) (warnLevel j) with
    | inr aboveWarn =>
      have lagMul : maxEta agents certs s' * preTotal agents certs envCap j +
          preTotal agents certs envCap j ≤
          (globalMaxLag agents certs + 1) * preTotal agents certs envCap j := by
        rw [add_mul_split (globalMaxLag agents certs) 1 (preTotal agents certs envCap j),
          Nat.one_mul]
        exact Nat.add_le_add_right (Nat.mul_le_mul_right _ maxEta_le_global) _
      have enough : x_crit j + maxEta agents certs s' * preTotal agents certs envCap j +
          preTotal agents certs envCap j ≤ x j :=
        Nat.le_trans
          (Nat.le_trans
            (Nat.add_assoc (x_crit j) _ _ ▸ Nat.add_le_add_left lagMul (x_crit j))
            (warn_margin j))
          aboveWarn
      have subPre : x_crit j + maxEta agents certs s' * preTotal agents certs envCap j ≤
          x j - preTotal agents certs envCap j :=
        Naturals.le_sub_of_add_le (Nat.add_comm _ _ ▸ enough)
      exact Nat.le_trans subPre
        (Nat.le_trans (Naturals.sub_antitone (x j) (H_le_pre j)) (indexedStep_ge_sub G H x j))
    | inl belowWarn =>
      have alarmTrue : alarm = true := by
        obtain ⟨i₀, mem₀, mon₀⟩ := pooled_coverage j (site_in j)
        have warn₀ := obs_detects i₀ mem₀ x j mon₀ belowWarn
        have emit₀ := (certs i₀).emits_on_warn (s i₀) (obsAt i₀) (inK i₀ mem₀) warn₀
        exact channel_fires emit load env envOk ⟨i₀, mem₀, emit₀, silenceAll i₀ mem₀⟩ silenceAll
      cases hEta : maxEta agents certs s with
      | zero =>
        have eachZero : ∀ i, i ∈ agents → (certs i).eta (s i) = 0 := fun i mem =>
          Nat.eq_zero_of_le_zero
            (Nat.le_trans (le_foldNatMax_of_mem (f := fun i => (certs i).eta (s i)) mem)
              (Nat.le_of_eq hEta))
        have eachZero' : ∀ i, i ∈ agents → (certs i).eta (s' i) = 0 := fun i mem => by
          show (certs i).eta ((L i).next (s i) (obsAt i, alarm) (dist i)) = 0
          rw [alarmTrue]
          exact (certs i).eta_alarm_zero (s i) (obsAt i) (dist i)
            (tolOk i mem (obsAt i, true)) (inK i mem) (eachZero i mem)
        have maxEtaZero' : maxEta agents certs s' = 0 := foldNatMax_eq_zero eachZero'
        have H_le_safe : ∀ k, H k ≤ H_safe k := fun k =>
          Nat.le_trans
            (Nat.add_le_add
              (sumDraws_le k fun i mem =>
                (((certs i).cert.within _ (inK i mem)).2.2 (eachZero i mem)).2 k)
              (env_within env envOk k))
            (post_budget k)
        have xCritLe : ∀ k, x_crit k ≤ x k := fun k =>
          Nat.le_trans (Nat.le_add_right _ _) (margin k)
        have stepSafe : x_crit j ≤ x' j :=
          Nat.le_trans (post_viable j)
            (Nat.le_trans (indexedStep_antitone_H G_rises H_le_safe x_crit j)
              (indexedStep_mono G_rises H xCritLe j))
        show x_crit j + maxEta agents certs s' * preTotal agents certs envCap j ≤ x' j
        rw [maxEtaZero', Nat.zero_mul, Nat.add_zero]
        exact stepSafe
      | succ ePred =>
        have posEta : 0 < maxEta agents certs s := hEta ▸ Nat.succ_pos ePred
        have stepDown : ∀ i, i ∈ agents → (certs i).eta (s' i) + 1 ≤ maxEta agents certs s :=
          fun i mem => by
            have curLe : (certs i).eta (s i) ≤ maxEta agents certs s :=
              le_foldNatMax_of_mem (f := fun i => (certs i).eta (s i)) mem
            show (certs i).eta ((L i).next (s i) (obsAt i, alarm) (dist i)) + 1 ≤ _
            rw [alarmTrue]
            cases hI : (certs i).eta (s i) with
            | zero =>
              rw [(certs i).eta_alarm_zero (s i) (obsAt i) (dist i)
                (tolOk i mem (obsAt i, true)) (inK i mem) hI]
              exact posEta
            | succ k =>
              have lt := (certs i).eta_alarm_step (s i) (obsAt i) (dist i)
                (tolOk i mem (obsAt i, true)) (inK i mem) (hI ▸ Nat.succ_pos k)
              exact Nat.le_trans lt curLe
        have maxEtaDown : maxEta agents certs s' + 1 ≤ maxEta agents certs s :=
          foldNatMax_succ_le posEta stepDown
        have mulDown : maxEta agents certs s' * preTotal agents certs envCap j +
            preTotal agents certs envCap j ≤
            maxEta agents certs s * preTotal agents certs envCap j := by
          have expand : maxEta agents certs s' * preTotal agents certs envCap j +
              preTotal agents certs envCap j =
              (maxEta agents certs s' + 1) * preTotal agents certs envCap j := by
            rw [add_mul_split, Nat.one_mul]
          rw [expand]
          exact Nat.mul_le_mul_right _ maxEtaDown
        have enough : x_crit j + maxEta agents certs s' * preTotal agents certs envCap j +
            preTotal agents certs envCap j ≤ x j :=
          Nat.le_trans (Nat.add_assoc (x_crit j) _ _ ▸ Nat.add_le_add_left mulDown (x_crit j))
            (margin j)
        have subPre : x_crit j + maxEta agents certs s' * preTotal agents certs envCap j ≤
            x j - preTotal agents certs envCap j :=
          Naturals.le_sub_of_add_le (Nat.add_comm _ _ ▸ enough)
        exact Nat.le_trans subPre
          (Nat.le_trans (Naturals.sub_antitone (x j) (H_le_pre j)) (indexedStep_ge_sub G H x j))

/-- Corollary: from `assume_guarantee_joint_viable`, the initial state lies in `Viability.Kernel`. -/
theorem assume_guarantee_joint_kernel {α ι Env : Type} {S Obs Dist : α → Type}
    (agents : List α) (sites : List ι) (site_in : ∀ j : ι, j ∈ sites)
    (L : (i : α) → OpenLoop (S i) (Obs i) (Dist i) ι)
    (init : (i : α) → S i)
    (certs : (i : α) → LoopCertificate (L i) (init i))
    (obs : (i : α) → (ι → Nat) → Obs i)
    (channel : (α → Bool) → (α → Nat) → Env → Bool)
    (G : ι → (ι → Nat) → Nat)
    (envDraw : Env → ι → Nat) (envCap : ι → Nat) (jointAdm : Env → Prop)
    (env_within : ∀ env, jointAdm env → ∀ j, envDraw env j ≤ envCap j)
    (x_crit warnLevel H_safe x₀ : ι → Nat)
    (monitored : α → ι → Prop)
    (obs_detects : ∀ i, i ∈ agents → ∀ x j, monitored i j → x j < warnLevel j →
      (certs i).warnObs (obs i x))
    (pooled_coverage : ∀ j, j ∈ sites → ∃ i, i ∈ agents ∧ monitored i j)
    (channel_fires : ∀ emit load env, jointAdm env →
      (∃ i, i ∈ agents ∧ emit i = true ∧ load i ≤ (certs i).maxSilence) →
      (∀ i, i ∈ agents → load i ≤ (certs i).maxSilence) →
      channel emit load env = true)
    (G_rises : ∀ i, RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (G i))
    (post_viable : ∀ j, x_crit j ≤ RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole G H_safe x_crit j)
    (post_budget : ∀ j, sumDraws agents (fun i => (certs i).postBudget) j + envCap j ≤ H_safe j)
    (warn_margin : ∀ j, x_crit j + (globalMaxLag agents certs + 1) * preTotal agents certs envCap j ≤ warnLevel j)
    (init_margin : ∀ j, x_crit j + maxEta agents certs init * preTotal agents certs envCap j ≤ x₀ j) :
    Viability.Kernel (jointProcess agents L certs obs channel G envDraw jointAdm)
      (jointGuard agents L certs x_crit) (x₀, init) :=
  have res := assume_guarantee_joint_viable agents sites site_in L init certs obs channel G
    envDraw envCap jointAdm env_within x_crit warnLevel H_safe x₀ monitored obs_detects
    pooled_coverage channel_fires G_rises post_viable post_budget warn_margin init_margin
  res.2.kernel res.1

/-! ## Part 2: The Coupled Race Theorem & Five Witnesses -/

/-- Five members of the oversight selection pool: two captured and three uncaptured watchers. -/
inductive RaceMember where
  | cap1
  | cap2
  | watch1
  | watch2
  | watch3

/-- The fixed list of the five pool members. -/
def raceMembers : List RaceMember := [.cap1, .cap2, .watch1, .watch2, .watch3]

/-- What each member reads from a signal history `l : Nat → Unit → Nat` at current `loss`:
captured members always read `false` (no alarm), while the three watchers read `true` on the
low signal (`l 0 () = 0`) only while `loss < K_silence`. -/
def raceMemberRead (K_silence loss : Nat) (m : RaceMember) (l : Nat → Unit → Nat) : Bool :=
  match m with
  | .cap1 | .cap2 => false
  | .watch1 | .watch2 | .watch3 => Nat.blt loss K_silence && Nat.beq (l 0 ()) 0

/-- Encoding of `ReadingLoop.Untested.Value` as a `Nat`-valued signal history. -/
def signalLevel : ReadingLoop.Untested.Value → (Nat → Unit → Nat)
  | .low => fun _ _ => 0
  | .mid => fun _ _ => 1
  | .high => fun _ _ => 2

/-- Decidable check matching `Becoming.Web.MajorityHolds` over `raceMembers`. -/
def majorityBool (K_silence loss : Nat) (l : Nat → Unit → Nat) : Bool :=
  Nat.blt raceMembers.length
    (2 * Web.holdsCount (fun g => raceMemberRead K_silence loss g l) raceMembers)

theorem majorityBool_true_iff (K_silence loss : Nat) (l : Nat → Unit → Nat) :
    majorityBool K_silence loss l = true ↔
      Web.MajorityHolds raceMembers (raceMemberRead K_silence loss) l :=
  natBlt_true_iff

/-- **Pool silencing via `Web.majority_outvoted`.** While `loss < K_silence`, the three watchers
give a 3-of-5 majority on `.low`; once `K_silence ≤ loss`, silencing the three watchers triggers
`Becoming.Web.majority_outvoted` so `MajorityHolds` cannot distinguish `.low` from `.mid` and fails. -/
theorem race_pool_majority_of_lt {K_silence loss : Nat} (lt : loss < K_silence) :
    Web.MajorityHolds raceMembers (raceMemberRead K_silence loss) (signalLevel .low) ∧
      ¬ Web.MajorityHolds raceMembers (raceMemberRead K_silence loss) (signalLevel .mid) := by
  have bltTrue : Nat.blt loss K_silence = true := natBlt_true_iff.mpr lt
  have lowCount : Web.holdsCount (fun g => raceMemberRead K_silence loss g (signalLevel .low))
      raceMembers = 3 := by
    show (false).toNat + ((false).toNat + ((Nat.blt loss K_silence && true).toNat +
      ((Nat.blt loss K_silence && true).toNat + ((Nat.blt loss K_silence && true).toNat + 0)))) = 3
    rw [bltTrue]; rfl
  have midCount : Web.holdsCount (fun g => raceMemberRead K_silence loss g (signalLevel .mid))
      raceMembers = 0 := by
    show (false).toNat + ((false).toNat + ((Nat.blt loss K_silence && false).toNat +
      ((Nat.blt loss K_silence && false).toNat + ((Nat.blt loss K_silence && false).toNat + 0)))) = 0
    rw [bltTrue]; rfl
  refine ⟨?_, ?_⟩
  · show 5 < 2 * Web.holdsCount _ raceMembers
    rw [lowCount]; exact by decide
  · show ¬ (5 < 2 * Web.holdsCount _ raceMembers)
    rw [midCount]; exact by decide

theorem race_pool_silenced_via_majority_outvoted {K_silence loss : Nat} (ge : K_silence ≤ loss) :
    (Web.MajorityHolds raceMembers (raceMemberRead K_silence loss) (signalLevel .low) ↔
      Web.MajorityHolds raceMembers (raceMemberRead K_silence loss) (signalLevel .mid)) ∧
    ¬ Web.MajorityHolds raceMembers (raceMemberRead K_silence loss) (signalLevel .low) := by
  have bltFalse : Nat.blt loss K_silence = false := natBlt_false_iff.mpr ge
  have failCount : Web.holdsCount (fun g =>
      !raceMemberRead K_silence loss g (signalLevel .low) &&
      !raceMemberRead K_silence loss g (signalLevel .mid)) raceMembers = 5 := by
    show (!false && !false).toNat + ((!false && !false).toNat +
      ((!(Nat.blt loss K_silence && true) && !(Nat.blt loss K_silence && false)).toNat +
      ((!(Nat.blt loss K_silence && true) && !(Nat.blt loss K_silence && false)).toNat +
      ((!(Nat.blt loss K_silence && true) && !(Nat.blt loss K_silence && false)).toNat + 0)))) = 5
    rw [bltFalse]; rfl
  have outvoted : Web.MajorityHolds raceMembers (raceMemberRead K_silence loss) (signalLevel .low) ↔
      Web.MajorityHolds raceMembers (raceMemberRead K_silence loss) (signalLevel .mid) :=
    Web.majority_outvoted (members := raceMembers) (read := raceMemberRead K_silence loss)
      (l := signalLevel .low) (l' := signalLevel .mid)
      (.inr (by show 5 < 2 * _; rw [failCount]; exact by decide))
  have midCount : Web.holdsCount (fun g => raceMemberRead K_silence loss g (signalLevel .mid))
      raceMembers = 0 := by
    show (false).toNat + ((false).toNat + ((Nat.blt loss K_silence && false).toNat +
      ((Nat.blt loss K_silence && false).toNat + ((Nat.blt loss K_silence && false).toNat + 0)))) = 0
    rw [bltFalse]; rfl
  have notMid : ¬ Web.MajorityHolds raceMembers (raceMemberRead K_silence loss) (signalLevel .mid) := by
    show ¬ (5 < 2 * Web.holdsCount _ raceMembers)
    rw [midCount]; exact by decide
  exact ⟨outvoted, fun h => notMid (outvoted.mp h)⟩

/-- Post-turn two-drawer coordination mode. -/
inductive CoordMode where
  | coordinated
  | uncoordinated

/-- The two-drawer rule profile on `shore 1`: uncoordinated draws everything (`0` left), while
coordinated leaves drawer `0`'s shore (`1`) and draws drawer `1`'s (`1`). -/
def drawerRules : CoordMode → Nat → Nat → Nat → Nat
  | .coordinated => fun d _ a => if d = 0 then a else 0
  | .uncoordinated => fun _ _ _ => 0

/-- Two-shore portion with `p = 1 < m = 2` from `CoupledDrawers`. -/
def shorePortion : Nat → Nat → Nat → Nat :=
  Optimum.Coupled.AtOnce.Shores.shore 1

/-- Total post-turn draw computed directly from `Optimum.AtOnce.sumTo` over `shore 1` at `z = 2`. -/
def postDraw (mode : CoordMode) : Nat :=
  Optimum.AtOnce.sumTo
    (fun d => shorePortion d 0 2 - drawerRules mode d 0 (shorePortion d 0 2)) 2

theorem postDraw_coordinated : postDraw .coordinated = 1 := rfl
theorem postDraw_uncoordinated : postDraw .uncoordinated = 2 := rfl

theorem coordinated_pool_leaves_one (t : Nat) :
    Optimum.AtOnce.pool shorePortion (drawerRules .coordinated) 2 t 2 = 1 := by
  show 0 + (if 0 = 0 then shorePortion 0 t 2 else 0) +
    (if 1 = 0 then shorePortion 1 t 2 else 0) = 1
  rfl

/-- **Any coupling rate `c` and horizon `N` leaves the uncoordinated drain `Perfect` on `shore 1`**
via `CoupledDrawers.Optimum.Coupled.AtOnce.Shores.drain_perfect (p := 1) (m := 2)`. -/
theorem uncoordinated_drain_perfect (c N : Nat) :
    Optimum.Coupled.AtOnce.Perfect (fun _ x => x) shorePortion (fun _ _ _ => 0)
      (drawerRules .uncoordinated) 2 c 2 N ∧ postDraw .uncoordinated = 2 ∧ 1 < postDraw .uncoordinated :=
  ⟨(Optimum.Coupled.AtOnce.Shores.drain_perfect (p := 1) (m := 2)
      (by decide) (by decide) c N).1,
   rfl, by decide⟩

/-- **Any uncoupled (`c = 0`) `AtOnce.Perfect` profile on `shore 1` (`p = 1 < m = 2`)** drains the
full `2` at the terminal step (`t + 1 = N`), yielding draw `2 > 1 = Y`. -/
theorem any_uncoupled_perfect_on_shore_drains {rules : Nat → Nat → Nat → Nat} {N t : Nat}
    (last : t + 1 = N)
    (perfect : Optimum.Coupled.AtOnce.Perfect (fun _ x => x) shorePortion
      (fun _ _ _ => 0) rules 2 0 2 N) :
    Optimum.AtOnce.sumTo (fun d => shorePortion d t 2 - rules d t (shorePortion d t 2)) 2 = 2 := by
  have zeroOf : ∀ d, d < 2 → rules d t 1 = 0 := fun d dk => by
    have rev := perfect.2 t 0 last d dk 2 0 (Nat.le_refl 0) (by
      cases d with
      | zero => exact Nat.zero_le 1
      | succ d' => cases d' with
        | zero => exact Nat.zero_le 1
        | succ m => exact absurd dk (Nat.not_lt_of_le (Nat.succ_le_succ (Nat.succ_le_succ (Nat.zero_le m)))))
    have step0 : ∀ b, Optimum.Coupled.AtOnce.later (fun _ x => x) shorePortion rules 2 d 0 2 0 t 2 b = 0 :=
      fun b => by
        show Optimum.Coupled.stepCoupling 0 2 _ + 0 = 0
        rw [Optimum.Coupled.stepCoupling_zero, Nat.add_zero]
    have port1 : shorePortion d t 2 = 1 := by
      cases d with
      | zero => rfl
      | succ d' => cases d' with
        | zero => rfl
        | succ m => exact absurd dk (Nat.not_lt_of_le (Nat.succ_le_succ (Nat.succ_le_succ (Nat.zero_le m))))
    rw [port1, step0, step0, Nat.sub_zero, Nat.add_zero, Nat.add_zero] at rev
    have bounded := (perfect.1 d t 1).2
    exact Nat.eq_zero_of_le_zero
      (Naturals.le_of_add_le_add_left (k := 1) (a := rules d t 1) (b := 0)
        (Nat.le_trans (Nat.add_le_add_right rev (rules d t 1))
          (Nat.le_of_eq (Naturals.sub_add_cancel bounded))))
  have h0 := zeroOf 0 (by decide)
  have h1 := zeroOf 1 (by decide)
  show 0 + (1 - rules 0 t 1) + (1 - rules 1 t 1) = 2
  rw [h0, h1]

/-- Substrate giving law for the Coupled Race (`Y = 1`, `x_crit = 5` under `H = 1`). -/
def raceGiving (z : Nat) : Nat := if 4 ≤ z then 1 else 0

theorem raceGiving_atMost : RegimeMargin.AtMost raceGiving 1 := fun z =>
  match Nat.decLe 4 z with
  | isTrue le => Nat.le_of_eq (if_pos le)
  | isFalse notLe => Nat.le_trans (Nat.le_of_eq (if_neg notLe)) (Nat.zero_le 1)

theorem raceGiving_fromNothing : RegimeMargin.FromNothing raceGiving := rfl

theorem raceGiving_short_two : RegimeMargin.Short raceGiving 2 4 := fun z _ =>
  Nat.lt_of_le_of_lt (raceGiving_atMost z) (by decide)

theorem raceGiving_short_three : RegimeMargin.Short raceGiving 3 4 := fun z _ =>
  Nat.lt_of_le_of_lt (raceGiving_atMost z) (by decide)

/-- Parameters of a Coupled Race instance. -/
structure RaceParams where
  world : ReadingLoop.Untested.World
  probeAt : Option Nat
  ruleLag : Nat
  actLag : Nat
  coordMode : CoordMode
  H_high : Nat := 3
  lossRate : Nat := 1
  K_silence : Nat := 2

/-- State of the Coupled Race system. -/
structure RaceState where
  t : Nat
  kept : List ReadingLoop.Untested.World
  alarmed : Bool
  rule : Bool
  ruleWait : Nat
  actWait : Nat
  stock : Nat
  loss : Nat
  share : Nat

def isProbeStep (probeAt : Option Nat) (t : Nat) : Bool :=
  match probeAt with
  | none => false
  | some p => Nat.beq p t

def isLowVal : ReadingLoop.Untested.Value → Bool
  | .low => true
  | .mid => false
  | .high => false

def isBenignWorld : ReadingLoop.Untested.World → Bool
  | .up => true
  | .down => false

def valueEq : ReadingLoop.Untested.Value → ReadingLoop.Untested.Value → Bool
  | .low, .low => true
  | .low, .mid => false
  | .low, .high => false
  | .mid, .low => false
  | .mid, .mid => true
  | .mid, .high => false
  | .high, .low => false
  | .high, .mid => false
  | .high, .high => true

theorem valueEq_true_iff {a b : ReadingLoop.Untested.Value} : valueEq a b = true ↔ a = b := by
  cases a <;> cases b
  · exact ⟨fun _ => rfl, fun _ => rfl⟩
  · exact ⟨fun h => Bool.noConfusion h, fun h => nomatch h⟩
  · exact ⟨fun h => Bool.noConfusion h, fun h => nomatch h⟩
  · exact ⟨fun h => Bool.noConfusion h, fun h => nomatch h⟩
  · exact ⟨fun _ => rfl, fun _ => rfl⟩
  · exact ⟨fun h => Bool.noConfusion h, fun h => nomatch h⟩
  · exact ⟨fun h => Bool.noConfusion h, fun h => nomatch h⟩
  · exact ⟨fun h => Bool.noConfusion h, fun h => nomatch h⟩
  · exact ⟨fun _ => rfl, fun _ => rfl⟩

/-- **The Coupled Race transition step (`raceStep`).**
Evaluation order at step `st.t`:
1. `act := if params.probeAt = some st.t then .untried else .known`.
2. `sensed := Untested.reply .mid act params.world`; eager candidate filter `kept'`.
3. Alarm check at `st.loss` (before `loss` accrual): requires `sensed = .low`,
   `PoolFromCourse.Stands params.K_silence (st.share, st.loss)`, and
   `Becoming.Web.MajorityHolds raceMembers (raceMemberRead params.K_silence st.loss) (signalLevel sensed)`.
4. Rule/act countdown on `(st.alarmed, st.rule, st.ruleWait, st.actWait)`.
5. Substrate step `RegimeMargin.step raceGiving H_t st.stock` and `loss` accrual under `st.rule` / `st.actWait`. -/
def raceStep (params : RaceParams) (st : RaceState) : RaceState :=
  let act := if isProbeStep params.probeAt st.t then
    ReadingLoop.Untested.Act.untried else ReadingLoop.Untested.Act.known
  let sensed := ReadingLoop.Untested.reply .mid act params.world
  let kept' := st.kept.filter (fun w => valueEq (ReadingLoop.Untested.reply .mid act w) sensed)
  let standsOk := Nat.blt st.loss params.K_silence
  let poolOk := majorityBool params.K_silence st.loss (signalLevel sensed)
  let triggered := isLowVal sensed && standsOk && poolOk && !st.alarmed
  let alarmed' := if triggered then true else st.alarmed
  let (rule', ruleWait', actWait') :=
    if triggered then
      (st.rule, params.ruleLag, st.actWait)
    else if st.alarmed && st.rule then
      if Nat.beq st.ruleWait 0 then (false, 0, params.actLag)
      else (true, st.ruleWait - 1, st.actWait)
    else
      (st.rule, st.ruleWait,
        if !st.rule && Nat.blt 0 st.actWait then st.actWait - 1 else st.actWait)
  let H_t := if st.rule || Nat.blt 0 st.actWait then params.H_high else postDraw params.coordMode
  let stock' := RegimeMargin.step raceGiving H_t st.stock
  let loss' := st.loss + (if st.rule then params.lossRate else 0)
  ⟨st.t + 1, kept', alarmed', rule', ruleWait', actWait', stock', loss', st.share⟩

/-- Initial Coupled Race state (`x₀ = 13`, both worlds kept, `rule = true`, `loss = 0`). -/
def raceInit : RaceState := ⟨0, [.up, .down], false, true, 0, 0, 13, 0, 0⟩

/-- Orbit of `raceStep` from `raceInit`. -/
def raceOrbit (params : RaceParams) (t : Nat) : RaceState :=
  Law.orbit (raceStep params) raceInit t

/-- Equivalence between the boolean alarm gate and the formal `PoolFromCourse.Stands` + `Web.MajorityHolds` predicates. -/
theorem race_alarm_gate_iff (K_silence loss : Nat) (sensed : ReadingLoop.Untested.Value) :
    (isLowVal sensed && Nat.blt loss K_silence &&
      majorityBool K_silence loss (signalLevel sensed)) = true ↔
      sensed = .low ∧ PoolFromCourse.Stands K_silence (0, loss) ∧
        Web.MajorityHolds raceMembers (raceMemberRead K_silence loss) (signalLevel sensed) := by
  have isLowIff : isLowVal sensed = true ↔ sensed = .low := by
    cases sensed
    · exact ⟨fun _ => rfl, fun _ => rfl⟩
    · exact ⟨fun h => Bool.noConfusion h, fun h => nomatch h⟩
    · exact ⟨fun h => Bool.noConfusion h, fun h => nomatch h⟩
  exact (ListTests.and_true_iff.trans
    (and_congr (ListTests.and_true_iff.trans
        (and_congr isLowIff (natBlt_true_iff (a := loss) (b := K_silence))))
      (majorityBool_true_iff K_silence loss (signalLevel sensed)))).trans
    ⟨fun ⟨⟨h1, h2⟩, h3⟩ => ⟨h1, h2, h3⟩, fun ⟨h1, h2, h3⟩ => ⟨⟨h1, h2⟩, h3⟩⟩

/-- Parameters for the five contrasting witnesses. -/
def goodParams : RaceParams :=
  ⟨.down, some 1, 1, 0, .coordinated, 3, 1, 2⟩

def noDiscParams : RaceParams :=
  ⟨.down, none, 1, 0, .coordinated, 3, 1, 2⟩

def noDiscBenignParams : RaceParams :=
  ⟨.up, none, 1, 0, .coordinated, 3, 1, 2⟩

def silencedParams : RaceParams :=
  ⟨.down, some 2, 0, 0, .coordinated, 3, 1, 2⟩

def uncoordParams : RaceParams :=
  ⟨.down, some 1, 1, 0, .uncoordinated, 3, 1, 2⟩

def tooSlowParams : RaceParams :=
  ⟨.down, some 1, 2, 0, .coordinated, 3, 1, 2⟩

theorem good_after_four (k : Nat) :
    raceOrbit goodParams (k + 4) =
      ⟨k + 4, [.down], true, false, 0, 0, 5, 4, 0⟩ := by
  induction k with
  | zero => rfl
  | succ k ih =>
    show raceStep goodParams (raceOrbit goodParams (k + 4)) = _
    rw [ih]
    rfl

/-- **Witness 1 (`WitnessGood`)**: probes at `t = 1` (`loss = 1 < 2`), alarms via 3-of-5 watcher
majority, counts down `ruleWait : 1 → 0`, flips `rule` at `t = 3`, and holds `stock = 5` forever
under `H_coord = 1` (`≤ Y = 1`). -/
theorem WitnessGood :
    (raceOrbit goodParams 1).loss = 1 ∧
    (raceOrbit goodParams 1).alarmed = false ∧
    (raceOrbit goodParams 2).alarmed = true ∧
    (raceOrbit goodParams 2).ruleWait = 1 ∧
    (raceOrbit goodParams 2).stock = 9 ∧
    (raceOrbit goodParams 3).ruleWait = 0 ∧
    (raceOrbit goodParams 3).stock = 7 ∧
    (raceOrbit goodParams 4).rule = false ∧
    (raceOrbit goodParams 4).stock = 5 ∧
    ∀ t, 5 ≤ (raceOrbit goodParams t).stock := by
  refine ⟨rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, fun t => ?_⟩
  cases t with
  | zero => exact by decide
  | succ t => cases t with
    | zero => exact by decide
    | succ t => cases t with
      | zero => exact by decide
      | succ t => cases t with
        | zero => exact by decide
        | succ k =>
          have h := congrArg RaceState.stock (good_after_four k)
          show 5 ≤ (raceOrbit goodParams (k + 4)).stock
          rw [h]
          exact Nat.le_refl 5

theorem noDisc_stays (t : Nat) :
    raceOrbit noDiscParams t = raceOrbit noDiscBenignParams t ∧
    (raceOrbit noDiscParams t).kept = [.up, .down] ∧
    (raceOrbit noDiscParams t).alarmed = false ∧
    (raceOrbit noDiscParams t).rule = true := by
  induction t with
  | zero => exact ⟨rfl, rfl, rfl, rfl⟩
  | succ t ih =>
    obtain ⟨same, kept, notAlarm, ruleTrue⟩ := ih
    show raceStep noDiscParams (raceOrbit noDiscParams t) =
      raceStep noDiscBenignParams (raceOrbit noDiscBenignParams t) ∧ _
    have hNext : ∀ w, raceStep ⟨w, none, 1, 0, .coordinated, 3, 1, 2⟩
        ⟨(raceOrbit noDiscParams t).t, [.up, .down], false, true,
         (raceOrbit noDiscParams t).ruleWait, (raceOrbit noDiscParams t).actWait,
         (raceOrbit noDiscParams t).stock, (raceOrbit noDiscParams t).loss,
         (raceOrbit noDiscParams t).share⟩ =
      ⟨(raceOrbit noDiscParams t).t + 1, [.up, .down], false, true,
       (raceOrbit noDiscParams t).ruleWait, (raceOrbit noDiscParams t).actWait,
       RegimeMargin.step raceGiving 3 (raceOrbit noDiscParams t).stock,
       (raceOrbit noDiscParams t).loss + 1, (raceOrbit noDiscParams t).share⟩ := fun w => rfl
    have shape : raceOrbit noDiscParams t =
        ⟨(raceOrbit noDiscParams t).t, [.up, .down], false, true,
         (raceOrbit noDiscParams t).ruleWait, (raceOrbit noDiscParams t).actWait,
         (raceOrbit noDiscParams t).stock, (raceOrbit noDiscParams t).loss,
         (raceOrbit noDiscParams t).share⟩ := by
      cases h : raceOrbit noDiscParams t
      rw [h] at kept notAlarm ruleTrue
      dsimp at kept notAlarm ruleTrue
      subst kept; subst notAlarm; subst ruleTrue
      rfl
    have lhs := (congrArg (raceStep noDiscParams) shape).trans (hNext .down)
    have rhs := (congrArg (raceStep noDiscBenignParams) (same.symm.trans shape)).trans (hNext .up)
    refine ⟨lhs.trans rhs.symm, ?_, ?_, ?_⟩
    · exact congrArg RaceState.kept lhs
    · exact congrArg RaceState.alarmed lhs
    · exact congrArg RaceState.rule lhs

/-- **Witness 2 (`WitnessNoDiscovery`)**: with `probeAt = none`, the harmful run is
state-for-state identical to the benign world run at every step, `rule` stays `true`, and
`stock` drains to `0` at `t = 6`. -/
theorem WitnessNoDiscovery :
    (∀ t, raceOrbit noDiscParams t = raceOrbit noDiscBenignParams t) ∧
    (∀ t, (raceOrbit noDiscParams t).kept = [.up, .down] ∧
      (raceOrbit noDiscParams t).rule = true) ∧
    (raceOrbit noDiscParams 6).stock = 0 :=
  ⟨fun t => (noDisc_stays t).1, fun t => ⟨(noDisc_stays t).2.1, (noDisc_stays t).2.2.2⟩, rfl⟩

theorem raceStep_silenced_step {st : RaceState} (notAlarm : st.alarmed = false)
    (ruleTrue : st.rule = true) (lossGe : 2 ≤ st.loss) :
    (raceStep silencedParams st).alarmed = false ∧
    (raceStep silencedParams st).rule = true ∧
    2 ≤ (raceStep silencedParams st).loss := by
  have bltFalse : Nat.blt st.loss 2 = false := natBlt_false_iff.mpr lossGe
  have shape : st = ⟨st.t, st.kept, false, true, st.ruleWait, st.actWait,
      st.stock, st.loss, st.share⟩ := by
    obtain ⟨t, kept, alarmed, rule, rw', aw', stock, loss, share⟩ := st
    dsimp at notAlarm ruleTrue
    subst notAlarm; subst ruleTrue; rfl
  have notTrig : ∀ act,
      (isLowVal (ReadingLoop.Untested.reply .mid act .down) &&
        Nat.blt st.loss 2 &&
        majorityBool 2 st.loss (signalLevel (ReadingLoop.Untested.reply .mid act .down)) &&
        !false) = false := fun act => by
    rw [bltFalse]
    cases isLowVal (ReadingLoop.Untested.reply .mid act .down) <;> rfl
  cases hProbe : isProbeStep (some 2) st.t with
  | false =>
    have hNeg := ListTests.false_iff_not.mp (notTrig .known)
    show (raceStep silencedParams st).alarmed = false ∧
      (raceStep silencedParams st).rule = true ∧
      2 ≤ (raceStep silencedParams st).loss
    rw [shape]
    unfold raceStep silencedParams
    dsimp
    rw [hProbe]
    dsimp
    rw [if_neg hNeg, if_neg hNeg]
    exact ⟨rfl, rfl, Nat.le_trans lossGe (Nat.le_add_right _ 1)⟩
  | true =>
    have hNeg := ListTests.false_iff_not.mp (notTrig .untried)
    show (raceStep silencedParams st).alarmed = false ∧
      (raceStep silencedParams st).rule = true ∧
      2 ≤ (raceStep silencedParams st).loss
    rw [shape]
    unfold raceStep silencedParams
    dsimp
    rw [hProbe]
    dsimp
    rw [if_neg hNeg, if_neg hNeg]
    exact ⟨rfl, rfl, Nat.le_trans lossGe (Nat.le_add_right _ 1)⟩

theorem silenced_never_alarms (t : Nat) :
    (raceOrbit silencedParams t).alarmed = false ∧
    (raceOrbit silencedParams t).rule = true ∧
    (2 ≤ t → 2 ≤ (raceOrbit silencedParams t).loss) := by
  induction t with
  | zero => exact ⟨rfl, rfl, fun h => absurd h (by decide)⟩
  | succ t ih =>
    obtain ⟨notAlarm, ruleTrue, lossGe⟩ := ih
    cases t with
    | zero => exact ⟨rfl, rfl, fun h => absurd h (by decide)⟩
    | succ t => cases t with
      | zero => exact ⟨rfl, rfl, fun _ => Nat.le_refl 2⟩
      | succ k =>
        have hStep := raceStep_silenced_step notAlarm ruleTrue (lossGe (Nat.le_add_left 2 k))
        exact ⟨hStep.1, hStep.2.1, fun _ => hStep.2.2⟩

/-- **Witness 3 (`WitnessSilenced`)**: probes at `t = 2` when `stock = 9 ≥ 5`, yet `loss = 2`
fails `PoolFromCourse.Stands 2` and triggers `Web.majority_outvoted`, silencing the watchers so
`alarmed` remains `false`, `rule` remains `true`, and `stock` crashes to `0` at `t = 6`. -/
theorem WitnessSilenced :
    (raceOrbit silencedParams 2).stock = 9 ∧
    (raceOrbit silencedParams 2).loss = 2 ∧
    ¬ PoolFromCourse.Stands 2 ((raceOrbit silencedParams 2).share, (raceOrbit silencedParams 2).loss) ∧
    ¬ Web.MajorityHolds raceMembers (raceMemberRead 2 (raceOrbit silencedParams 2).loss)
        (signalLevel .low) ∧
    (∀ t, (raceOrbit silencedParams t).alarmed = false ∧ (raceOrbit silencedParams t).rule = true) ∧
    (raceOrbit silencedParams 6).stock = 0 :=
  ⟨rfl, rfl, Nat.lt_irrefl 2,
   (race_pool_silenced_via_majority_outvoted (Nat.le_refl 2)).2,
   fun t => ⟨(silenced_never_alarms t).1, (silenced_never_alarms t).2.1⟩, rfl⟩

/-- **Witness 4 (`WitnessUncoordinated`)**: probes at `t = 1` and flips `rule` to `false` at `t = 3`,
yet the post-turn drawers follow the uncoordinated profile proved `Perfect` by
`CoupledDrawers.Optimum.Coupled.AtOnce.Shores.drain_perfect (p := 1) (m := 2)`, so
`H_uncoord = 2 > 1` drains `stock` `5 → 3 → 1 → 0` at `t = 7`. -/
theorem WitnessUncoordinated :
    (∀ c N, Optimum.Coupled.AtOnce.Perfect (fun _ x => x) shorePortion (fun _ _ _ => 0)
      (drawerRules .uncoordinated) 2 c 2 N) ∧
    postDraw .uncoordinated = 2 ∧
    (raceOrbit uncoordParams 4).rule = false ∧
    (raceOrbit uncoordParams 4).stock = 5 ∧
    (raceOrbit uncoordParams 5).stock = 3 ∧
    (raceOrbit uncoordParams 6).stock = 1 ∧
    (raceOrbit uncoordParams 7).stock = 0 :=
  ⟨fun c N => (uncoordinated_drain_perfect c N).1, rfl, rfl, rfl, rfl, rfl, rfl⟩

/-- **Witness 5 (`WitnessTooSlow`)**: probes at `t = 1` (`loss = 1 < 2`) and alarms, yet `ruleLag = 2`
delays the rule flip until `t = 4`, so `stock 5 = 2 < 5` and `stock` crashes to `0` at `t = 7`. -/
theorem WitnessTooSlow :
    (raceOrbit tooSlowParams 1).loss = 1 ∧
    (raceOrbit tooSlowParams 2).alarmed = true ∧
    (raceOrbit tooSlowParams 4).rule = true ∧
    (raceOrbit tooSlowParams 4).stock = 5 ∧
    (raceOrbit tooSlowParams 5).rule = false ∧
    (raceOrbit tooSlowParams 5).stock = 2 ∧
    (raceOrbit tooSlowParams 5).stock < 5 ∧
    (raceOrbit tooSlowParams 7).stock = 0 :=
  ⟨rfl, rfl, rfl, rfl, rfl, rfl, by decide, rfl⟩

/-- **The Coupled Race Theorem.** Summarizes:
1. A viable coordinated race (`WitnessGood`) where observation-driven alarm fires while watchers
   still stand (`loss < K_silence`), flips the rule before `x` crosses `5`, and holds `x ≥ 5` forever
   under `postDraw .coordinated = 1`.
2. Three distinct failure obstructions:
   - unprobed blindness (`probeAt = none`, indistinguishable from `.up`);
   - pool silencing (`K_silence ≤ loss`, proved via `Web.majority_outvoted`);
   - post-turn uncoordinated drawdown (`H_uncoord = 2 > Y = 1`, proved `Perfect` for every `c, N`
     via `CoupledDrawers.Optimum.Coupled.AtOnce.Shores.drain_perfect`, and unique at `c = 0`);
   - plus reaction lag (`WitnessTooSlow`). -/
theorem coupled_race_theorem :
    (∀ t, 5 ≤ (raceOrbit goodParams t).stock) ∧
    ((∀ t, raceOrbit noDiscParams t = raceOrbit noDiscBenignParams t) ∧
      (raceOrbit noDiscParams 6).stock = 0) ∧
    (∀ {K loss}, K ≤ loss →
      ¬ Web.MajorityHolds raceMembers (raceMemberRead K loss) (signalLevel .low)) ∧
    ((raceOrbit silencedParams 2).stock = 9 ∧ (raceOrbit silencedParams 6).stock = 0) ∧
    ((∀ c N, Optimum.Coupled.AtOnce.Perfect (fun _ x => x) shorePortion (fun _ _ _ => 0)
        (drawerRules .uncoordinated) 2 c 2 N) ∧
      (raceOrbit uncoordParams 7).stock = 0) ∧
    ((raceOrbit tooSlowParams 5).stock < 5 ∧ (raceOrbit tooSlowParams 7).stock = 0) :=
  ⟨WitnessGood.2.2.2.2.2.2.2.2.2,
   ⟨WitnessNoDiscovery.1, WitnessNoDiscovery.2.2⟩,
   fun ge => (race_pool_silenced_via_majority_outvoted ge).2,
   ⟨WitnessSilenced.1, WitnessSilenced.2.2.2.2.2⟩,
   ⟨WitnessUncoordinated.1, WitnessUncoordinated.2.2.2.2.2.2⟩,
   ⟨WitnessTooSlow.2.2.2.2.2.2.1, WitnessTooSlow.2.2.2.2.2.2.2⟩⟩

/-! ## Part 3(a): Collapse of `Unread` Adapting Loops -/

theorem paced_fast_succ_local {S R : Type} (f : S → R → S) (h : S → R → R)
    (reads : Nat → Bool) (c : S × R) (t : Nat) :
    (Pace.paced f h reads c (t + 1)).1 =
      f (Pace.paced f h reads c t).1 (Pace.paced f h reads c t).2 := by
  rw [Pace.paced_succ c t]
  cases reads t <;> rfl

/-- Monotone orbit comparison: whenever `H_joint ≤ jointDraw` along the paced run, the substrate
coordinate of `Pace.paced` stays at or below the regime step under constant draw `H_joint`. -/
theorem unread_orbit_le {A R : Type} {f : A × Nat → R → A × Nat} {h : A × Nat → R → R}
    {reads : Nat → Bool} {gSub : Nat → Nat}
    (g_mono : ∀ z₁ z₂, z₁ ≤ z₂ → gSub z₁ ≤ gSub z₂)
    (jointDraw : A → R → Nat)
    (x_step : ∀ a x r, (f (a, x) r).2 = RegimeMargin.step gSub (jointDraw a r) x)
    {a₀ : A} {r₀ : R} {b₀ H_joint : Nat}
    (draw_ge : ∀ t, H_joint ≤ jointDraw (Pace.paced f h reads ((a₀, b₀), r₀) t).1.1
      (Pace.paced f h reads ((a₀, b₀), r₀) t).2) :
    ∀ t, (Pace.paced f h reads ((a₀, b₀), r₀) t).1.2 ≤
      (Law.run (RegimeMargin.step gSub H_joint) b₀).state t
  | 0 => Nat.le_refl b₀
  | t + 1 => by
    have ih := unread_orbit_le g_mono jointDraw x_step draw_ge t
    have fast := congrArg Prod.snd (paced_fast_succ_local f h reads ((a₀, b₀), r₀) t)
    rw [fast, x_step]
    have subAnti : (Pace.paced f h reads ((a₀, b₀), r₀) t).1.2 -
        jointDraw (Pace.paced f h reads ((a₀, b₀), r₀) t).1.1
          (Pace.paced f h reads ((a₀, b₀), r₀) t).2 ≤
        (Pace.paced f h reads ((a₀, b₀), r₀) t).1.2 - H_joint :=
      Naturals.sub_antitone _ (draw_ge t)
    have stepAnt : RegimeMargin.step gSub
        (jointDraw (Pace.paced f h reads ((a₀, b₀), r₀) t).1.1
          (Pace.paced f h reads ((a₀, b₀), r₀) t).2)
        (Pace.paced f h reads ((a₀, b₀), r₀) t).1.2 ≤
        RegimeMargin.step gSub H_joint (Pace.paced f h reads ((a₀, b₀), r₀) t).1.2 :=
      Nat.add_le_add subAnti (g_mono _ _ subAnti)
    exact Nat.le_trans stepAnt (RegimeMargin.step_mono g_mono H_joint ih)

/-- **Collapse of `Unread` adapting loops (`unread_adaptive_joint_collapse`).**
Whenever a two-level loop satisfies `ClosedCapture.Unread f h`:
1. Its visible share and rule sequences at `b₀` are identical to those at `b_big` (`ClosedCapture.unread_course`).
2. Under monotone `gSub` and `H_joint ≤ jointDraw`, its substrate stays below the `H_joint` regime orbit.
3. By `RegimeMargin.falls_within` and `RegimeMargin.ends_below`, the substrate collapses to `0` in finite time. -/
theorem unread_adaptive_joint_collapse {A R : Type}
    {f : A × Nat → R → A × Nat} {h : A × Nat → R → R} (reads : Nat → Bool)
    (unread : ClosedCapture.Unread f h)
    {gSub : Nat → Nat} (g_mono : ∀ z₁ z₂, z₁ ≤ z₂ → gSub z₁ ≤ gSub z₂)
    (jointDraw : A → R → Nat)
    (x_step : ∀ a x r, (f (a, x) r).2 = RegimeMargin.step gSub (jointDraw a r) x)
    (a₀ : A) (r₀ : R) (b₀ b_big H_joint Y y n : Nat)
    (draw_ge : ∀ t, H_joint ≤ jointDraw (Pace.paced f h reads ((a₀, b₀), r₀) t).1.1
      (Pace.paced f h reads ((a₀, b₀), r₀) t).2)
    (most : RegimeMargin.AtMost gSub Y) (yle : Y ≤ H_joint)
    (short : RegimeMargin.Short gSub H_joint y) (nothing : RegimeMargin.FromNothing gSub)
    (within : b₀ < (H_joint + y) + (H_joint - Y) * n) :
    (∀ t, (Pace.paced f h reads ((a₀, b₀), r₀) t).1.1 =
        (Pace.paced f h reads ((a₀, b_big), r₀) t).1.1 ∧
      (Pace.paced f h reads ((a₀, b₀), r₀) t).2 =
        (Pace.paced f h reads ((a₀, b_big), r₀) t).2) ∧
    (∀ t, (Pace.paced f h reads ((a₀, b₀), r₀) t).1.2 ≤
      (Law.run (RegimeMargin.step gSub H_joint) b₀).state t) ∧
    ∃ T, T < n + (H_joint + y) ∧ (Pace.paced f h reads ((a₀, b₀), r₀) T).1.2 = 0 := by
  refine ⟨fun t => ClosedCapture.unread_course (c := ((a₀, b₀), r₀)) (c' := ((a₀, b_big), r₀))
      unread reads rfl rfl t,
    unread_orbit_le g_mono jointDraw x_step draw_ge, ?_⟩
  obtain ⟨k, kle, ltB⟩ :=
    RegimeMargin.falls_within most yle (Nat.le_add_right H_joint y) within
  let xk := (Law.run (RegimeMargin.step gSub H_joint) b₀).state k
  have endsXk := RegimeMargin.ends_below short nothing ltB
  have atSum : (Law.run (RegimeMargin.step gSub H_joint) b₀).state (k + xk) = 0 := by
    show Law.orbit (RegimeMargin.step gSub H_joint) b₀ (k + xk) = 0
    rw [Law.orbit_add]
    exact endsXk
  exact ⟨k + xk, Nat.lt_of_le_of_lt (Nat.add_le_add_right kle xk) (Nat.add_lt_add_left ltB n),
    Nat.eq_zero_of_le_zero
      (Nat.le_trans (unread_orbit_le g_mono jointDraw x_step draw_ge (k + xk))
        (Nat.le_of_eq atSum))⟩

/-! ### Witness `UnreadAdaptiveCollapse`: two loops with non-cosmetic rule flips (`draw true = 2`,
`draw false = 3`) over `gSub z := if 3 ≤ z then 3 else 0`. -/
namespace UnreadAdaptiveCollapse

def gSub (z : Nat) : Nat := if 3 ≤ z then 3 else 0

theorem gSub_mono : ∀ z₁ z₂, z₁ ≤ z₂ → gSub z₁ ≤ gSub z₂ := fun z₁ z₂ le =>
  match Nat.decLe 3 z₁ with
  | isTrue h1 =>
    have h2 : 3 ≤ z₂ := Nat.le_trans h1 le
    Nat.le_trans (Nat.le_of_eq (if_pos h1)) (Nat.le_of_eq (if_pos h2).symm)
  | isFalse h1 =>
    Nat.le_trans (Nat.le_of_eq (if_neg h1)) (Nat.zero_le _)

theorem gSub_atMost : RegimeMargin.AtMost gSub 3 := fun z =>
  match Nat.decLe 3 z with
  | isTrue h => Nat.le_of_eq (if_pos h)
  | isFalse h => Nat.le_trans (Nat.le_of_eq (if_neg h)) (Nat.zero_le 3)

theorem gSub_short_four : RegimeMargin.Short gSub 4 3 := fun z _ =>
  Nat.lt_of_le_of_lt (gSub_atMost z) (by decide)

theorem gSub_fromNothing : RegimeMargin.FromNothing gSub := rfl

/-- Individual loop draw: `2` when rule is `true`, `3` when rule is `false`. -/
def ruleDraw : Bool → Nat
  | true => 2
  | false => 3

/-- Single-agent course (`(localShare, rule)`), flipping `rule : true ↔ false` every step. -/
def soloStep (p : Nat × Bool) : Nat × Bool :=
  (RegimeMargin.step gSub (ruleDraw p.2) p.1, !p.2)

theorem solo_holds_true :
    (Law.orbit soloStep (6, true) 0).1 = 6 ∧
    (Law.orbit soloStep (6, true) 1).1 = 7 ∧
    (Law.orbit soloStep (6, true) 2).1 = 7 ∧
    ∀ t, 6 ≤ (Law.orbit soloStep (6, true) t).1 := by
  refine ⟨rfl, rfl, rfl, fun t => ?_⟩
  have stepBound : ∀ x r, 6 ≤ x → 6 ≤ RegimeMargin.step gSub (ruleDraw r) x := fun x r hx => by
    have dr : ruleDraw r ≤ 3 := by cases r <;> exact by decide
    have sub3 : 3 ≤ x - ruleDraw r :=
      Naturals.le_sub_of_add_le (Nat.le_trans (Nat.add_le_add_right dr 3) hx)
    have g3 : gSub (x - ruleDraw r) = 3 := if_pos sub3
    show 6 ≤ (x - ruleDraw r) + gSub (x - ruleDraw r)
    rw [g3]
    exact Nat.add_le_add_right sub3 3
  induction t with
  | zero => exact Nat.le_refl 6
  | succ t ih => exact stepBound _ _ ih

theorem solo_const_three (t : Nat) :
    (Law.run (RegimeMargin.step gSub 3) 6).state t = 6 := by
  induction t with
  | zero => rfl
  | succ t ih =>
    show RegimeMargin.step gSub 3 ((Law.run (RegimeMargin.step gSub 3) 6).state t) = 6
    rw [ih]
    rfl

theorem solo_const_two :
    (Law.run (RegimeMargin.step gSub 2) 6).state 0 = 6 ∧
    (Law.run (RegimeMargin.step gSub 2) 6).state 1 = 7 ∧
    (Law.run (RegimeMargin.step gSub 2) 6).state 2 = 8 ∧
    ∀ t, 6 ≤ (Law.run (RegimeMargin.step gSub 2) 6).state t := by
  refine ⟨rfl, rfl, rfl, fun t => ?_⟩
  induction t with
  | zero => exact Nat.le_refl 6
  | succ t ih =>
    show 6 ≤ ((Law.run (RegimeMargin.step gSub 2) 6).state t - 2) +
      gSub ((Law.run (RegimeMargin.step gSub 2) 6).state t - 2)
    have sub4 : 4 ≤ (Law.run (RegimeMargin.step gSub 2) 6).state t - 2 :=
      Naturals.le_sub_of_add_le ih
    have sub3 : 3 ≤ (Law.run (RegimeMargin.step gSub 2) 6).state t - 2 :=
      Nat.le_trans (by decide) sub4
    rw [show gSub ((Law.run (RegimeMargin.step gSub 2) 6).state t - 2) = 3 from if_pos sub3]
    exact Nat.add_le_add_right sub3 3

/-- Joint two-loop fast transition (`((a₁, a₂), x)`) under rules `(r₁, r₂)`. -/
def jointF (p : (Nat × Nat) × Nat) (r : Bool × Bool) : (Nat × Nat) × Nat :=
  ((RegimeMargin.step gSub (ruleDraw r.1) p.1.1,
    RegimeMargin.step gSub (ruleDraw r.2) p.1.2),
   RegimeMargin.step gSub (ruleDraw r.1 + ruleDraw r.2) p.2)

/-- Each agent's rule flips every step without reading `x`. -/
def jointH (_ : (Nat × Nat) × Nat) (r : Bool × Bool) : Bool × Bool :=
  (!r.1, !r.2)

def jointDraw (_ : Nat × Nat) (r : Bool × Bool) : Nat :=
  ruleDraw r.1 + ruleDraw r.2

def LocalOK (p : (Nat × Nat) × (Bool × Bool)) : Prop :=
  6 ≤ p.1.1 ∧ 6 ≤ p.1.2

theorem joint_unread : ClosedCapture.Unread jointF jointH :=
  ⟨fun _ _ _ _ => rfl, fun _ _ _ _ => rfl⟩

theorem jointDraw_ge_four : ∀ a r, 4 ≤ jointDraw a r := fun _ ⟨r1, r2⟩ => by
  show 4 ≤ ruleDraw r1 + ruleDraw r2
  cases r1 <;> cases r2 <;> exact by decide

theorem localOK_holds (b : Nat) (r₀ : Bool × Bool) (t : Nat) :
    LocalOK ((Pace.paced jointF jointH (fun _ => true) (((6, 6), b), r₀) t).1.1,
      (Pace.paced jointF jointH (fun _ => true) (((6, 6), b), r₀) t).2) := by
  have keep : ∀ x r, 6 ≤ x → 6 ≤ RegimeMargin.step gSub (ruleDraw r) x := fun x r hx => by
    have dr : ruleDraw r ≤ 3 := by cases r <;> exact by decide
    have sub3 : 3 ≤ x - ruleDraw r :=
      Naturals.le_sub_of_add_le (Nat.le_trans (Nat.add_le_add_right dr 3) hx)
    show 6 ≤ (x - ruleDraw r) + gSub (x - ruleDraw r)
    rw [show gSub (x - ruleDraw r) = 3 from if_pos sub3]
    exact Nat.add_le_add_right sub3 3
  induction t with
  | zero => exact ⟨Nat.le_refl 6, Nat.le_refl 6⟩
  | succ t ih =>
    rw [Pace.paced_succ]
    exact ⟨keep _ _ ih.1, keep _ _ ih.2⟩

/-- **Complete witness statement for `UnreadAdaptiveCollapse`**:
- Alone (`H ≤ 3`), `x` holds `6 → 7 → 7...` or `6 → 6 → 6...` forever.
- Jointly (`jointDraw ∈ {4, 5, 6} ≥ 4`), `x` crashes (`6 → 2 → 0` for `(true, true)`, `6 → 1 → 0`
  for `(true, false)`), deduced from `unread_adaptive_joint_collapse`, while `LocalOK` and the
  non-cosmetic rule flipping `(r₁, r₂)` remain identical to `b_big = 100` at every step `t`. -/
theorem witness :
    ((∀ t, 6 ≤ (Law.orbit soloStep (6, true) t).1) ∧
      (∀ t, (Law.run (RegimeMargin.step gSub 3) 6).state t = 6)) ∧
    ((Pace.paced jointF jointH (fun _ => true) (((6, 6), 6), (true, true)) 0).1.2 = 6 ∧
     (Pace.paced jointF jointH (fun _ => true) (((6, 6), 6), (true, true)) 1).1.2 = 2 ∧
     (Pace.paced jointF jointH (fun _ => true) (((6, 6), 6), (true, true)) 2).1.2 = 0 ∧
     (Pace.paced jointF jointH (fun _ => true) (((6, 6), 6), (true, false)) 0).1.2 = 6 ∧
     (Pace.paced jointF jointH (fun _ => true) (((6, 6), 6), (true, false)) 1).1.2 = 1 ∧
     (Pace.paced jointF jointH (fun _ => true) (((6, 6), 6), (true, false)) 2).1.2 = 0) ∧
    (∀ r₀ t,
      (Pace.paced jointF jointH (fun _ => true) (((6, 6), 6), r₀) t).1.1 =
        (Pace.paced jointF jointH (fun _ => true) (((6, 6), 100), r₀) t).1.1 ∧
      (Pace.paced jointF jointH (fun _ => true) (((6, 6), 6), r₀) t).2 =
        (Pace.paced jointF jointH (fun _ => true) (((6, 6), 100), r₀) t).2 ∧
      LocalOK ((Pace.paced jointF jointH (fun _ => true) (((6, 6), 6), r₀) t).1.1,
        (Pace.paced jointF jointH (fun _ => true) (((6, 6), 6), r₀) t).2)) ∧
    (∀ r₀, ∃ T, T < 1 + 7 ∧
      (Pace.paced jointF jointH (fun _ => true) (((6, 6), 6), r₀) T).1.2 = 0) ∧
    (Pace.paced jointF jointH (fun _ => true) (((6, 6), 100), (true, true)) 2).1.2 = 96 := by
  refine ⟨⟨solo_holds_true.2.2.2, solo_const_three⟩, ⟨rfl, rfl, rfl, rfl, rfl, rfl⟩,
    fun r₀ t => ?_, fun r₀ => ?_, rfl⟩
  · have col := unread_adaptive_joint_collapse (fun _ => true) joint_unread gSub_mono jointDraw
      (fun _ _ _ => rfl) (6, 6) r₀ 6 100 4 3 3 1 (fun k => jointDraw_ge_four _ _)
      gSub_atMost (by decide) gSub_short_four gSub_fromNothing (by decide)
    exact ⟨(col.1 t).1, (col.1 t).2, localOK_holds 6 r₀ t⟩
  · have col := unread_adaptive_joint_collapse (fun _ => true) joint_unread gSub_mono jointDraw
      (fun _ _ _ => rfl) (6, 6) r₀ 6 100 4 3 3 1 (fun k => jointDraw_ge_four _ _)
      gSub_atMost (by decide) gSub_short_four gSub_fromNothing (by decide)
    exact col.2.2

end UnreadAdaptiveCollapse

/-! ## Part 3(b): Endogenous Composite Witness (`EndogenousCompositeWitness`) -/

namespace EndogenousCompositeWitness

/-- Two symmetric adaptive agents over `ι := Unit`. -/
inductive EndogAgent where
  | first
  | second

def endogAgents : List EndogAgent := [.first, .second]

/-- Substrate giving law: `giving z := if 4 ≤ z then 2 else 0`. -/
def giving (z : Nat) : Nat := if 4 ≤ z then 2 else 0

def endogG (_ : Unit) (e : Unit → Nat) : Nat := giving (e ())

theorem endogG_rises : ∀ j : Unit, RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (endogG j) :=
  fun _ e _ below =>
    match Nat.decLe 4 (e ()) with
    | isTrue h => Nat.le_trans (Nat.le_of_eq (if_pos h))
        (Nat.le_of_eq (if_pos (Nat.le_trans h (below ()))).symm)
    | isFalse h => Nat.le_trans (Nat.le_of_eq (if_neg h)) (Nat.zero_le _)

/-- Candidate-keeping loop for observation classification (`true` predicts warning, `false` predicts safe). -/
def endogLoop : ReadingLoop.Loop Bool Bool Unit Unit where
  predict h _ _ := h
  choose _ _ := ()
  answer _ _ _ := false
  move _ _ e := e

/-- Internal state `((drawMemo, keptHyps), rule)` where `rule = true` is `favours` (`draw = 2`,
`eta = 1`) and `rule = false` is restrained (`draw = 1`, `eta = 0`). -/
abbrev EndogState : Type := (Nat × List Bool) × Bool

/-- Adaptive state component update `F` for `Mechanism.adaptive`: records the active rule's draw
and updates kept hypotheses via `ReadingLoop.Loop.keep`. -/
def endogF (oa : Bool × Bool) (r : Bool) (_ : Nat × List Bool) (_ : Unit) : Nat × List Bool :=
  (if r then 2 else 1, ReadingLoop.Loop.keep endogLoop [true, false] (some (oa.1, ())) oa.1)

/-- Adaptive rule update `G` for `Mechanism.adaptive`: uses `PoolFromCourse.windowRead` within
the active reader window `[0, 2)` to adapt downward (`false`) on alarm (`oa.2 = true`) and upward
(`true`) on safe observation (`oa.1 = false`, confirmed by `false ∈ kept'`). -/
def endogRuleG (oa : Bool × Bool) (r : Bool) (_ : Nat × List Bool) : Bool :=
  let kept' := ReadingLoop.Loop.keep endogLoop [true, false] (some (oa.1, ())) oa.1
  PoolFromCourse.windowRead
    (fun _ _ => true)
    (fun p g => if p.1.2 then false else if List.contains p.1.1 false then true else g)
    0 2 ((kept', oa.2), 0) r

/-- Concrete `Becoming.adaptive` process parameterized by observation/alarm input `oa`. -/
def endogAdapt (oa : Bool × Bool) : Process EndogState Unit :=
  adaptive (endogF oa) (endogRuleG oa)

theorem endogAdapt_determined (oa : Bool × Bool) : Determined (endogAdapt oa) :=
  adaptive_determined (endogF oa) (endogRuleG oa)

/-- Under safe input `(false, false)`, the rule genuinely makes a difference to `X` (`draw` is `2`
under `true` and `1` under `false`), so `Prod.fst` carries no law of its own (`adaptive_state_law_iff`). -/
theorem endogAdapt_rule_matters : ¬ GoAlike (endogAdapt (false, false)) Prod.fst := fun alike =>
  have hEq : (2 : Nat) = 1 :=
    congrArg Prod.fst ((adaptive_state_law_iff (F := endogF (false, false))
      (G := endogRuleG (false, false))).mp alike true false (1, []) ())
  absurd hEq (by decide)

/-- OpenLoop transition step: the unique step of `Becoming.adaptive (endogF oa) (endogRuleG oa)`. -/
def endogNext (s : EndogState) (oa : Bool × Bool) (_ : Unit) : EndogState :=
  (endogF oa s.2 s.1 (), endogRuleG oa s.2 s.1)

theorem endogNext_is_adaptive (s : EndogState) (oa : Bool × Bool) :
    (endogAdapt oa).step s () (endogNext s oa ()) := rfl

/-- Open adaptive loop instance for both agents. -/
def endogOpenLoop (_ : EndogAgent) : OpenLoop EndogState Bool Unit Unit where
  next := endogNext
  draw s _ := if s.2 then 2 else 1
  emitAlarm _ obs := obs
  silenceLoad _ := 0
  favours s := s.2 = true

/-- Observation map: `true` iff `x () < 16` (`warnLevel = 16`). -/
def endogObs (_ : EndogAgent) (x : Unit → Nat) : Bool := Nat.blt (x ()) 16

/-- Blind communication channel: fires whenever any agent emits an alarm with `load ≤ 0`. -/
def endogChannel (emit : EndogAgent → Bool) (load : EndogAgent → Nat) (_ : Unit) : Bool :=
  (emit .first && Nat.ble (load .first) 0) || (emit .second && Nat.ble (load .second) 0)

/-- Shared `LoopCertificate` parameterized only by `init : EndogState` (one contract covers both
`favours` and `¬ favours` starts). -/
def endogCert (i : EndogAgent) (init : EndogState) : LoopCertificate (endogOpenLoop i) init where
  tol _ _ := True
  warnObs obs := obs = true
  preCap _ := 2
  postBudget _ := 1
  maxSilence := 0
  maxLag := 1
  K _ := True
  eta s := if s.2 then 1 else 0
  init_in := trivial
  cert := Viability.certificate_disturbed_iff.mpr
    ⟨fun s _ =>
      ⟨fun _ => by show (if s.2 then 2 else 1) ≤ 2; cases s.2 <;> exact by decide,
       Nat.le_refl 0,
       fun eta0 => by
         cases hr : s.2
         · refine ⟨fun h => Bool.noConfusion (hr.symm.trans h), fun _ => ?_⟩
           show (if s.2 then 2 else 1) ≤ 1
           rw [hr]
           exact Nat.le_refl 1
         · have hEta : (if s.2 then 1 else 0) = 0 := eta0
           rw [hr] at hEta
           exact Nat.noConfusion hEta⟩,
     fun _ _ _ _ => trivial⟩
  eta_bound s _ := by show (if s.2 then 1 else 0) ≤ 1; cases s.2 <;> exact by decide
  emits_on_warn _ obs _ warn := warn
  eta_alarm_step s obs _ _ _ pos := by
    have hRule : s.2 = true := by
      cases hr : s.2
      · rw [hr] at pos; exact absurd pos (Nat.lt_irrefl 0)
      · rfl
    have hNext : (endogNext s (obs, true) ()).2 = false := by
      cases obs <;> rfl
    show (if (endogNext s (obs, true) ()).2 then 1 else 0) < (if s.2 then 1 else 0)
    rw [hNext, hRule]
    exact by decide
  eta_alarm_zero s obs _ _ _ _ := by
    have hNext : (endogNext s (obs, true) ()).2 = false := by
      cases obs <;> rfl
    show (if (endogNext s (obs, true) ()).2 then 1 else 0) = 0
    rw [hNext]
    rfl

def initFavours : EndogState := ((2, [true, false]), true)
def initRestrained : EndogState := ((1, [true, false]), false)

/-- **Black-box permanent viability via `assume_guarantee_joint_viable`** for any initial state
pair satisfying `6 + maxEta init * 4 ≤ x₀ ()`. -/
theorem endog_joint_viable (init : EndogAgent → EndogState) (x₀ : Unit → Nat)
    (margin : 6 + maxEta endogAgents (fun i => endogCert i (init i)) init * 4 ≤ x₀ ()) :
    jointInv endogAgents (fun i => endogCert i (init i)) (fun _ => 0) (fun _ => 6) (x₀, init) ∧
    Viability.Certificate
      (jointProcess endogAgents endogOpenLoop (fun i => endogCert i (init i))
        endogObs endogChannel endogG (fun _ _ => 0) (fun _ => True))
      (jointGuard endogAgents endogOpenLoop (fun i => endogCert i (init i)) (fun _ => 6))
      (jointInv endogAgents (fun i => endogCert i (init i)) (fun _ => 0) (fun _ => 6)) :=
  assume_guarantee_joint_viable
    endogAgents [()] (fun j => by cases j; exact .head _)
    endogOpenLoop init (fun i => endogCert i (init i))
    endogObs endogChannel endogG (fun _ _ => 0) (fun _ => 0) (fun _ => True)
    (fun _ _ _ => Nat.zero_le 0)
    (fun _ => 6) (fun _ => 16) (fun _ => 2) x₀
    (fun _ _ => True)
    (fun _ _ x j _ lt => by cases j; exact natBlt_true_iff.mpr lt)
    (fun j _ => ⟨.first, .head _, trivial⟩)
    (fun emit load _ _ ⟨i, _, hemit, hload⟩ _ => by
      have h0 : Nat.ble (load i) 0 = true := Nat.ble_eq_true_of_le hload
      cases i
      · exact ListTests.or_left _ (ListTests.and_true_iff.mpr ⟨hemit, h0⟩)
      · exact ListTests.or_right _ (ListTests.and_true_iff.mpr ⟨hemit, h0⟩))
    endogG_rises
    (fun j => by cases j; show 6 ≤ 6 - 2 + giving (6 - 2); exact by decide)
    (fun j => by cases j; show 1 + (1 + 0) + 0 ≤ 2; exact by decide)
    (fun j => by cases j; show 6 + (natMax 1 (natMax 1 0) + 1) * (2 + (2 + 0) + 0) ≤ 16; exact by decide)
    (fun j => by cases j; exact margin)

/-- Explicit concrete run of `jointProcess` starting at `x₀ = 16` with `initRestrained` (`¬ favours`),
showing endogenous bidirectional adaptation `¬ favours → favours → ¬ favours`. -/
def endogRun : Run
    (jointProcess endogAgents endogOpenLoop (fun i => endogCert i initRestrained)
      endogObs endogChannel endogG (fun _ _ => 0) (fun _ => True)) :=
  ⟨Law.orbit
    (fun st => jointStep endogAgents endogOpenLoop endogObs endogChannel endogG (fun _ _ => 0)
      st ((), fun _ => ()))
    (fun _ => 16, fun _ => initRestrained),
   fun _ => ((), fun _ => ()),
   fun _ => ⟨⟨trivial, fun _ _ _ => trivial⟩, rfl⟩⟩

/-- **Bidirectional endogenous adaptation witness (`endog_bidirectional_adaptation`).**
With the exact same `endogCert`:
1. `assume_guarantee_joint_viable` certifies permanent viability (`6 ≤ x`) from both `(16, initRestrained)`
   and `(10, initFavours)`.
2. Along the admissible run `endogRun` starting at `x₀ = 16` and `¬ favours`:
   - `t = 0`: `x = 16`, both agents start `¬ favours` (`rule = false`).
   - `t = 1`: `x = 16`, both agents adapt **upward** to `favours` (`rule = true`).
   - `t = 2`: `x = 14 < 16`, the higher draw (`2 + 2 = 4`) pulls the substrate below `warnLevel = 16`.
   - `t = 3`: `x = 12 ≥ 6`, observation-driven alarm adapts both agents **downward** to `¬ favours` (`rule = false`).
   - For ALL `t : Nat`, `6 ≤ (endogRun.state t).1 ()` (neither agent dies, certified via black-box `Certificate.kernel`). -/
theorem endog_bidirectional_adaptation :
    (Viability.Kernel
      (jointProcess endogAgents endogOpenLoop (fun i => endogCert i initFavours)
        endogObs endogChannel endogG (fun _ _ => 0) (fun _ => True))
      (jointGuard endogAgents endogOpenLoop (fun i => endogCert i initFavours) (fun _ => 6))
      (fun _ => 10, fun _ => initFavours)) ∧
    (∀ i, ¬ (endogOpenLoop i).favours ((endogRun.state 0).2 i)) ∧
    (endogRun.state 0).1 () = 16 ∧
    (∀ i, (endogOpenLoop i).favours ((endogRun.state 1).2 i)) ∧
    (endogRun.state 1).1 () = 16 ∧
    (∀ i, (endogOpenLoop i).favours ((endogRun.state 2).2 i)) ∧
    (endogRun.state 2).1 () = 14 ∧
    (∀ i, ¬ (endogOpenLoop i).favours ((endogRun.state 3).2 i)) ∧
    (endogRun.state 3).1 () = 12 ∧
    (∀ t, 6 ≤ (endogRun.state t).1 ()) := by
  have favCert := endog_joint_viable (fun _ => initFavours) (fun _ => 10)
    (show 6 + natMax 1 (natMax 1 0) * 4 ≤ 10 from by decide)
  have resCert := endog_joint_viable (fun _ => initRestrained) (fun _ => 16)
    (show 6 + natMax 0 (natMax 0 0) * 4 ≤ 16 from by decide)
  have kernFav : Viability.Kernel _ _ _ := favCert.2.kernel favCert.1
  have kernRes : Viability.Kernel _ _ _ := resCert.2.kernel resCert.1
  refine ⟨kernFav,
    fun i => by cases i <;> exact fun h => Bool.noConfusion h, rfl,
    fun i => by cases i <;> exact (rfl : true = true), rfl,
    fun i => by cases i <;> exact (rfl : true = true), rfl,
    fun i => by
      cases i
      · show ((endogRun.state 3).2 .first).2 = true → False
        rw [show ((endogRun.state 3).2 .first).2 = false from rfl]
        exact fun h => Bool.noConfusion h
      · show ((endogRun.state 3).2 .second).2 = true → False
        rw [show ((endogRun.state 3).2 .second).2 = false from rfl]
        exact fun h => Bool.noConfusion h,
    rfl,
    fun t => (Viability.Kernel.run endogRun kernRes t).1 ()⟩

end EndogenousCompositeWitness

end AdaptiveLoops

end Becoming
