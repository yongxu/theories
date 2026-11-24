import Becoming.EndogenousEmergence
import Becoming.ClosedCapture
import Becoming.PacedStock

/-!
# Endogenous detection before capture lock, and split evidence

AI-written (f1-lean-builder, Frontier 1, 24 November 2026), after the pre-Lean paper attack in
`_process/research/2026-10-05-generative-foundation-review/root-foundation/development/frontier1-endogenous-capture-2026-11-24/PAPER-ATTACK.md`.

`Becoming.EndogenousEmergence` states how a loop reading only its task return comes to register that
restraint sustains its own continuation (`emergentLoop` on `wEndo`: residual split at step 1, a
two-step probe at steps 2 and 3, registration from step 4). `Becoming.ClosedCapture` states when a
selection read from its own share keeps its lock and when a reading of what lies beyond the share turns
it; `ClosedCapture.Thinned` states that the counts at the step the others first read the loss decide
(`Thinned.kept_iff`, `Thinned.turned_iff`), with that step `N` a bare parameter. This module joins the
two.

* **Part A — the race.** The learner steps through a gate the share sets (`gate`, `gatedStep`,
  `gatedOrbit`): alternatives are admitted while the carriers are not more than the others (`admits`);
  locked out, an intended `.safe` is executed as `.extract`, and the learner is not told. Through
  `markCourse`, the others' reading in the pool switches when `mark` holds of what lies beyond the
  share (`markRead`). General statements: the gate makes no difference where the learner intends
  `.extract` (`gated_eq_closed`); locked out, the stock is pure extraction whatever the learner
  registers (`lockout_pure_extract`, `lockout_learner_irrelevant`); the marked reading reads beyond the
  share while its closed counterpart is unchanged by anything the learner registers (`mark_reads_beyond`,
  `race_reads_beyond`, `closed_race_registration_irrelevant`); where `mark` holds exactly from step
  `τ`, share and rule are `Thinned.course` with `N = τ` (`mark_eq_thinned`); where `mark` never holds,
  the course is the closed pool's and outlives the loss (`mark_never_eq_pre`,
  `closed_trap_outlives_loss`); for any reading cadence `reads`, `mark_kept_iff`, `mark_kept_locks_out`,
  `mark_turned_iff`, and `mark_turned_admits_iff` state the pre-capture turning window. Witnesses
  (`emergentLoop`, carriers' reading `hi`, others' `oneToOne` then `lo`, rule `hi`, one carrier):
  in time from twenty others (`race_in_time`); registration in full but late from twelve
  (`race_late_after_registration`); the probe blocked from four (`race_probe_blocked`); strain masked
  one step longer (`race_masked_strain`); cadence alone deciding on sixty-four (`race_slow_cadence`,
  `race_fast_cadence`, with `PacedStock.ReadAtSpanEnd` proved for `cadence3`); and the exogenous
  control, which never registers and never turns (`race_exo_no_false_turn`).
* **Part B — split evidence.** The depletion signal is split as a one-time mask between two isolated
  agents. Each agent's stream is the same in both worlds up to a permutation of the private tag
  (`retag_symmetry`, `split_two_of_two`), with exact count equality over all `2^T` binary tags
  (`count_view_invariant`, `split_marginal_count_eq`, `split_marginal_impossibility`); a consensus
  admitting only locally sound alarms never fires where the substrate is drawn down
  (`silencing_consensus`), while verdicts that are not locally sound leak the witness (`verdict_leak`)
  and one-bit-per-step exchange detects exactly (`exchange_detects`). Through `markCourse`, silenced
  consensus keeps the selection locked across every tag (`split_silenced_trapped`), whereas open
  exchange turns it cleanly (`split_exchange_turns`, instantiated on `wEndo` in `split_witness_endo`).

What is not shown is said in the paper attack (§4): the middle band between `mark_kept_iff` and
`mark_turned_admits_iff`; which learners register in time; a closed-loop split world; distributions on
tags beyond counting over all `2^T` tags; and that any actual selection or population meets these
premises.

Every declaration compiles from Lean's prelude with an empty axiom report.
-/

namespace Becoming

namespace EndogenousDetectionRace

open EndogenousEmergence Pace RuleCapture ClosedCapture CarrierCounts Drawn

/-! ## Part A.1: the gate -/

section Gate

variable {S : Type}

/-- Alternatives admitted (`true`) or locked out (`false`): locked out, an intended `.safe` is executed
as `.extract`. -/
def gate : Bool → EmergenceAct → EmergenceAct
  | true, a => a
  | false, _ => .extract

/-- One step of a learner whose executed action passes the gate. It observes only the task return of
the executed action and is not told of the gate. -/
def gatedStep (W : StrainWorld) (L : UnguidedLoop S Nat EmergenceAct) (adm : Bool) (st : Nat × S) :
    Nat × S :=
  (W.stepStock st.1 (gate adm (L.act st.2)),
    L.update st.2 (W.sense (W.stepStock st.1 (gate adm (L.act st.2))) (gate adm (L.act st.2))))

/-- The gated course from stock `x₀` and `L.init`, admitted at step `t` where `adm t`. -/
def gatedOrbit (W : StrainWorld) (L : UnguidedLoop S Nat EmergenceAct) (adm : Nat → Bool) (x₀ : Nat) :
    Nat → Nat × S
  | 0 => (x₀, L.init)
  | t + 1 => gatedStep W L (adm t) (gatedOrbit W L adm x₀ t)

theorem gate_extract (b : Bool) : gate b .extract = .extract := by
  cases b <;> rfl

theorem gate_of_admitted {b : Bool} {a : EmergenceAct} (h : a = .safe → b = true) : gate b a = a := by
  cases a with
  | extract => exact gate_extract b
  | safe => rw [h rfl]; rfl

theorem gatedStep_eq_closed (W : StrainWorld) (L : UnguidedLoop S Nat EmergenceAct) {adm : Bool}
    {st : Nat × S} (h : L.act st.2 = .safe → adm = true) :
    gatedStep W L adm st = closedLoopStep W L st := by
  show (W.stepStock st.1 (gate adm (L.act st.2)),
      L.update st.2 (W.sense (W.stepStock st.1 (gate adm (L.act st.2))) (gate adm (L.act st.2)))) =
    (W.stepStock st.1 (L.act st.2), L.update st.2 (W.sense (W.stepStock st.1 (L.act st.2)) (L.act st.2)))
  rw [gate_of_admitted h]

/-- **The gate makes no difference where the learner intends `.extract`.** If at every step before `T`
at which the learner, run without a gate, intends `.safe`, alternatives are admitted, the gated course
is the ungated one at `T`. -/
theorem gated_eq_closed (W : StrainWorld) (L : UnguidedLoop S Nat EmergenceAct) (adm : Nat → Bool)
    (x₀ : Nat) :
    ∀ T, (∀ k, k < T → L.act (closedOrbit W L x₀ k).2 = .safe → adm k = true) →
      gatedOrbit W L adm x₀ T = closedOrbit W L x₀ T
  | 0, _ => rfl
  | T + 1, h => by
    have ih := gated_eq_closed W L adm x₀ T (fun k hk => h k (Nat.lt_succ_of_lt hk))
    show gatedStep W L (adm T) (gatedOrbit W L adm x₀ T) = closedLoopStep W L (closedOrbit W L x₀ T)
    rw [ih]
    exact gatedStep_eq_closed W L (h T (Nat.lt_succ_self T))

/-- **Locked out, the stock is pure extraction.** Where alternatives are locked out at every step from
`τ` on, the stock at `τ + k` is `k` steps of `.extract` from the stock at `τ`, whatever the learner
intends or registers. -/
theorem lockout_pure_extract (W : StrainWorld) (L : UnguidedLoop S Nat EmergenceAct) (adm : Nat → Bool)
    (x₀ τ : Nat) (closed : ∀ k, τ ≤ k → adm k = false) :
    ∀ k, (gatedOrbit W L adm x₀ (τ + k)).1 = pureExtractStock W (gatedOrbit W L adm x₀ τ).1 k
  | 0 => rfl
  | k + 1 => by
    show W.stepStock (gatedOrbit W L adm x₀ (τ + k)).1
        (gate (adm (τ + k)) (L.act (gatedOrbit W L adm x₀ (τ + k)).2)) =
      W.stepStock (pureExtractStock W (gatedOrbit W L adm x₀ τ).1 k) .extract
    rw [closed (τ + k) (Nat.le_add_right τ k), lockout_pure_extract W L adm x₀ τ closed k]
    rfl

end Gate

/-- **Locked out, what any learner registers makes no difference to the substrate.** Two learners of
any internal states, each locked out from `τ` on, with the same stock at `τ`, have the same stock at
every later step. -/
theorem lockout_learner_irrelevant {S₁ S₂ : Type} (W : StrainWorld) (L₁ : UnguidedLoop S₁ Nat EmergenceAct)
    (L₂ : UnguidedLoop S₂ Nat EmergenceAct) (adm₁ adm₂ : Nat → Bool) (x₁ x₂ τ : Nat)
    (closed₁ : ∀ k, τ ≤ k → adm₁ k = false) (closed₂ : ∀ k, τ ≤ k → adm₂ k = false)
    (same : (gatedOrbit W L₁ adm₁ x₁ τ).1 = (gatedOrbit W L₂ adm₂ x₂ τ).1) (k : Nat) :
    (gatedOrbit W L₁ adm₁ x₁ (τ + k)).1 = (gatedOrbit W L₂ adm₂ x₂ (τ + k)).1 :=
  (lockout_pure_extract W L₁ adm₁ x₁ τ closed₁ k).trans
    ((congrArg (fun x => pureExtractStock W x k) same).trans
      (lockout_pure_extract W L₂ adm₂ x₂ τ closed₂ k).symm)

/-! ## Helpers for two-level courses and share comparisons -/

/-- Alternatives are admitted while the carriers are not more than the others. -/
def admits (x : CarrierCounts) : Bool := Nat.ble x.carrier x.other

/-- What `emergentLoop` has registered: restraint sustains its own continuation. -/
def registers (s : LearnerState) : Bool := s.ownHat .sustainedContinuation

theorem turn_fst {A R : Type} (f : A → R → A) (h : A → R → R) :
    ∀ (b : Bool) (p : A × R), (Pace.turn f h b p).1 = f p.1 p.2
  | true, _ => rfl
  | false, _ => rfl

/-- One turn of two joined laws, alike in what the share's next value and the rule read give, keeps
share and rule alike. -/
theorem turn_sim {A B B' R : Type} {f : A × B → R → A × B} {f' : A × B' → R → A × B'}
    {h : A × B → R → R} {h' : A × B' → R → R} :
    ∀ (b : Bool) (p : (A × B) × R) (q : (A × B') × R), (f p.1 p.2).1 = (f' q.1 q.2).1 →
      h p.1 p.2 = h' q.1 q.2 → p.2 = q.2 →
      (Pace.turn f h b p).1.1 = (Pace.turn f' h' b q).1.1 ∧ (Pace.turn f h b p).2 = (Pace.turn f' h' b q).2
  | true, _, _, hs, hr, _ => ⟨hs, hr⟩
  | false, _, _, hs, _, hg => ⟨hs, hg⟩

/-- The same, against a course of the share alone. -/
theorem turn_sim_plain {A B R : Type} {f : A × B → R → A × B} {f' : A → R → A}
    {h : A × B → R → R} {h' : A → R → R} :
    ∀ (b : Bool) (p : (A × B) × R) (q : A × R), (f p.1 p.2).1 = f' q.1 q.2 →
      h p.1 p.2 = h' q.1 q.2 → p.2 = q.2 →
      (Pace.turn f h b p).1.1 = (Pace.turn f' h' b q).1 ∧ (Pace.turn f h b p).2 = (Pace.turn f' h' b q).2
  | true, _, _, hs, hr, _ => ⟨hs, hr⟩
  | false, _, _, hs, _, hg => ⟨hs, hg⟩

/-- Selection by a rule favouring the others keeps the carriers not more than the others. -/
theorem select_keeps_admitted {x g : CarrierCounts} (hx : x.carrier ≤ x.other) (hg : disfavours g) :
    (select x g).carrier ≤ (select x g).other :=
  Nat.mul_le_mul hx hg

/-- A share not above one at which the carriers are more keeps them more. -/
theorem not_admits_of_le {x y : CarrierCounts} (le : order.le x y) (more : x.other < x.carrier) :
    admits y = false := by
  show Nat.ble y.carrier y.other = false
  cases h : Nat.ble y.carrier y.other with
  | false => rfl
  | true =>
    have hy : y.carrier ≤ y.other := Nat.le_of_ble_eq_true h
    have chain : x.carrier * y.other ≤ x.other * y.other :=
      Nat.le_trans le (Nat.le_trans (Nat.mul_le_mul_right x.other hy) (Nat.le_of_eq (Nat.mul_comm y.other x.other)))
    exact absurd (Nat.le_of_mul_le_mul_right chain y.other_pos) (Nat.not_le_of_gt more)

/-- A region every turn keeps holds at every step of the course from a start in it. -/
theorem region_stays {A R : Type} {f : A → R → A} {h : A → R → R} {reads : Nat → Bool} {Q : A × R → Prop}
    (closed : ∀ b p, Q p → Q (Pace.turn f h b p)) {c : A × R} (start : Q c) : ∀ k, Q (paced f h reads c k)
  | 0 => start
  | k + 1 => Eq.subst (motive := Q) (paced_succ c k).symm (closed (reads k) _ (region_stays closed start k))

/-- Where `reads` is false at every step from `t₀` for `d` steps, the rule in force at `t₀ + d`
is the rule in force at `t₀`. -/
theorem rule_kept_span {A R : Type} {f : A → R → A} {h : A → R → R} {reads : Nat → Bool}
    (c : A × R) (t₀ : Nat) :
    ∀ d, (∀ m, m < d → reads (t₀ + m) = false) → (paced f h reads c (t₀ + d)).2 = (paced f h reads c t₀).2
  | 0, _ => rfl
  | d + 1, quiet => by
    have ih := @rule_kept_span A R f h reads c t₀ d (fun m hm => quiet m (Nat.lt_succ_of_lt hm))
    have hP := paced_succ (f := f) (h := h) (reads := reads) c (t₀ + d)
    have hf : reads (t₀ + d) = false := quiet d (Nat.lt_succ_self d)
    have eqTurn : (Pace.turn f h (reads (t₀ + d)) (paced f h reads c (t₀ + d))).2 =
        (paced f h reads c (t₀ + d)).2 := by
      rw [hf]; rfl
    exact ((congrArg Prod.snd hP).trans eqTurn).trans ih

/-! ## Part A.2: a selection whose others read through a registration -/

section Mark

variable {B : Type}

/-- The rule read: the pool of the carriers' reading `u` and the others' reading, `v` before `mark`
holds of what lies beyond the share and `w` once it does. -/
def markRead (mark : B → Bool) (u v w : CarrierCounts) (p : CarrierCounts × B) (_ : CarrierCounts) :
    CarrierCounts :=
  cond (mark p.2) (pool u w p.1) (pool u v p.1)

/-- The two-level course of the share selected by the rule in force, what lies beyond stepping by `fB`,
the rule read through the registration `mark`. -/
abbrev markCourse (fB : CarrierCounts × B → CarrierCounts → B) (mark : B → Bool) (u v w : CarrierCounts)
    (reads : Nat → Bool) (c : (CarrierCounts × B) × CarrierCounts) (t : Nat) :
    (CarrierCounts × B) × CarrierCounts :=
  paced (join select fB) (markRead mark u v w) reads c t

variable (fB : CarrierCounts × B → CarrierCounts → B) (mark : B → Bool) (u v w : CarrierCounts)
  (reads : Nat → Bool)

/-- What lies beyond the share steps by `fB` at every step, reading or not. -/
theorem mark_beyond_succ (c : (CarrierCounts × B) × CarrierCounts) (t : Nat) :
    (markCourse fB mark u v w reads c (t + 1)).1.2 =
      fB (markCourse fB mark u v w reads c t).1 (markCourse fB mark u v w reads c t).2 :=
  (congrArg (fun q : (CarrierCounts × B) × CarrierCounts => q.1.2) (paced_succ c t)).trans
    (congrArg Prod.snd (turn_fst (join select fB) (markRead mark u v w) (reads t) _))

/-- **A reading through a registration reads beyond the share**: where the registration takes both
values beside one share at which the two pools differ, the rule read is not a function of the share
alone. -/
theorem mark_reads_beyond {x : CarrierCounts} {b₁ b₂ : B} {g : CarrierCounts}
    (m₁ : mark b₁ = true) (m₂ : mark b₂ = false) (apart : pool u w x ≠ pool u v x) :
    ¬ Unread (join select fB) (markRead mark u v w) := fun unread =>
  apart ((congrArg (fun b => cond b (pool u w x) (pool u v x)) m₁).symm.trans
    ((unread.2 x b₁ b₂ g).trans (congrArg (fun b => cond b (pool u w x) (pool u v x)) m₂)))

/-- Read through a registration that holds exactly from `τ`, the reading is the others' reading of
the loss at bound `τ`, the loss at the step's count. -/
theorem markRead_eq_lossPool {m : Bool} {t τ : Nat} (h : m = true ↔ τ ≤ t) (x g : CarrierCounts) :
    cond m (pool u w x) (pool u v x) = Thinned.lossPool u v w τ (x, t) g := by
  cases m with
  | true => exact (Thinned.lossPool_past (x, t) g (h.mp rfl)).symm
  | false =>
    have lt : t < τ := Nat.lt_of_not_le (fun le => Bool.noConfusion (h.mpr le))
    have hb : Nat.blt t τ = true := CoreHelpers.natBlt_true_iff.mpr lt
    dsimp only [Thinned.lossPool]
    rw [hb]
    rfl

/-- **`N` is the registration step.** Where along the course the registration holds exactly from
step `τ`, its share and rule are at every step those of `ClosedCapture.Thinned.course` with the loss
accruing one a step from `0` and bound `τ`, whose loss is the step count. -/
theorem mark_eq_thinned (s₀ g₀ : CarrierCounts) (b₀ : B) (τ : Nat)
    (reg : ∀ t, mark (markCourse fB mark u v w reads ((s₀, b₀), g₀) t).1.2 = true ↔ τ ≤ t) :
    ∀ t, (markCourse fB mark u v w reads ((s₀, b₀), g₀) t).1.1 =
        (Thinned.course Beyond.lossStep u v w τ reads ((s₀, 0), g₀) t).1.1 ∧
      (markCourse fB mark u v w reads ((s₀, b₀), g₀) t).2 =
        (Thinned.course Beyond.lossStep u v w τ reads ((s₀, 0), g₀) t).2 ∧
      (Thinned.course Beyond.lossStep u v w τ reads ((s₀, 0), g₀) t).1.2 = t
  | 0 => ⟨rfl, rfl, rfl⟩
  | t + 1 => by
    obtain ⟨e1, e2, e3⟩ := mark_eq_thinned s₀ g₀ b₀ τ reg t
    have hP := paced_succ (f := join select fB) (h := markRead mark u v w) (reads := reads)
      ((s₀, b₀), g₀) t
    have hQ := paced_succ (f := join select Beyond.lossStep) (h := Thinned.lossPool u v w τ) (reads := reads)
      ((s₀, 0), g₀) t
    have hs : select (markCourse fB mark u v w reads ((s₀, b₀), g₀) t).1.1
          (markCourse fB mark u v w reads ((s₀, b₀), g₀) t).2 =
        select (Thinned.course Beyond.lossStep u v w τ reads ((s₀, 0), g₀) t).1.1
          (Thinned.course Beyond.lossStep u v w τ reads ((s₀, 0), g₀) t).2 :=
      congr (congrArg select e1) e2
    have hr : markRead mark u v w (markCourse fB mark u v w reads ((s₀, b₀), g₀) t).1
          (markCourse fB mark u v w reads ((s₀, b₀), g₀) t).2 =
        Thinned.lossPool u v w τ (Thinned.course Beyond.lossStep u v w τ reads ((s₀, 0), g₀) t).1
          (Thinned.course Beyond.lossStep u v w τ reads ((s₀, 0), g₀) t).2 :=
      (congrArg (fun x => cond (mark (markCourse fB mark u v w reads ((s₀, b₀), g₀) t).1.2)
          (pool u w x) (pool u v x)) e1).trans
        ((markRead_eq_lossPool u v w (reg t) _ _).trans
          (congrArg (fun n => Thinned.lossPool u v w τ
            ((Thinned.course Beyond.lossStep u v w τ reads ((s₀, 0), g₀) t).1.1, n)
            (Thinned.course Beyond.lossStep u v w τ reads ((s₀, 0), g₀) t).2) e3.symm))
    have sim := turn_sim (f := join select fB) (f' := join select Beyond.lossStep)
      (h := markRead mark u v w) (h' := Thinned.lossPool u v w τ) (reads t) _ _ hs hr e2
    have loss : (Thinned.course Beyond.lossStep u v w τ reads ((s₀, 0), g₀) (t + 1)).1.2 = t + 1 :=
      (congrArg (fun q : (CarrierCounts × Nat) × CarrierCounts => q.1.2) hQ).trans
        ((congrArg Prod.snd (turn_fst (join select Beyond.lossStep) (Thinned.lossPool u v w τ) (reads t) _)).trans
          (congrArg (· + 1) e3))
    exact ⟨(congrArg (fun q : (CarrierCounts × B) × CarrierCounts => q.1.1) hP).trans
        (sim.1.trans (congrArg (fun q : (CarrierCounts × Nat) × CarrierCounts => q.1.1) hQ).symm),
      (congrArg (fun q : (CarrierCounts × B) × CarrierCounts => q.2) hP).trans
        (sim.2.trans (congrArg (fun q : (CarrierCounts × Nat) × CarrierCounts => q.2) hQ).symm),
      loss⟩

/-- **Never registered, the course is the closed pool's**: share and rule are those of the course read
from the share alone through the carriers' reading and the others' first reading. -/
theorem mark_never_eq_pre (s₀ g₀ : CarrierCounts) (b₀ : B)
    (never : ∀ t, mark (markCourse fB mark u v w reads ((s₀, b₀), g₀) t).1.2 = false) :
    ∀ t, (markCourse fB mark u v w reads ((s₀, b₀), g₀) t).1.1 =
        (paced select (poolRead u v) reads (s₀, g₀) t).1 ∧
      (markCourse fB mark u v w reads ((s₀, b₀), g₀) t).2 = (paced select (poolRead u v) reads (s₀, g₀) t).2
  | 0 => ⟨rfl, rfl⟩
  | t + 1 => by
    obtain ⟨e1, e2⟩ := mark_never_eq_pre s₀ g₀ b₀ never t
    have hP := paced_succ (f := join select fB) (h := markRead mark u v w) (reads := reads)
      ((s₀, b₀), g₀) t
    have hQ := paced_succ (f := select) (h := poolRead u v) (reads := reads) (s₀, g₀) t
    have hs := congr (congrArg select e1) e2
    have hr : markRead mark u v w (markCourse fB mark u v w reads ((s₀, b₀), g₀) t).1
          (markCourse fB mark u v w reads ((s₀, b₀), g₀) t).2 =
        poolRead u v (paced select (poolRead u v) reads (s₀, g₀) t).1
          (paced select (poolRead u v) reads (s₀, g₀) t).2 :=
      (congrArg (fun b => cond b (pool u w (markCourse fB mark u v w reads ((s₀, b₀), g₀) t).1.1)
          (pool u v (markCourse fB mark u v w reads ((s₀, b₀), g₀) t).1.1)) (never t)).trans
        (congrArg (pool u v) e1)
    have sim := turn_sim_plain (f := join select fB) (f' := select)
      (h := markRead mark u v w) (h' := poolRead u v) (reads t) _ _ hs hr e2
    exact ⟨(congrArg (fun q : (CarrierCounts × B) × CarrierCounts => q.1.1) hP).trans
        (sim.1.trans (congrArg Prod.fst hQ).symm),
      (congrArg (fun q : (CarrierCounts × B) × CarrierCounts => q.2) hP).trans
        (sim.2.trans (congrArg Prod.snd hQ).symm)⟩

variable {fB mark u v w reads}

/-- **A never-registered course locks under the closed pool and outlives its loss**
(`Drawn.through_locks` + `ClosedCapture.lock_outlives_loss` via `mark_never_eq_pre`). -/
theorem closed_trap_outlives_loss {s₀ g₀ : CarrierCounts} {b₀ : B}
    (never : ∀ t, mark (markCourse fB mark u v w reads ((s₀, b₀), g₀) t).1.2 = false)
    (readers : order.le v u) (fu : favours u) (fv : favours v) {r r' : Nat}
    (first : reads r = true) (second : reads r' = true) (lt : r < r') (loss₀ : Nat) (k : Nat) :
    let m := markCourse fB mark u v w reads ((s₀, b₀), g₀)
    let trapped := paced (join select Beyond.lossStep) (joinRead (poolRead u v))
      (fun j => reads (r' + 1 + j)) (((m (r' + 1)).1.1, loss₀), (m (r' + 1)).2)
    loss₀ + k ≤ (trapped k).1.2 ∧
      Locked order favours (poolRead u v) ((m (r' + 1 + k)).1.1, (m (r' + 1 + k)).2) ∧
      order.le (m (r' + 1)).1.1 (m (r' + 1 + k)).1.1 ∧
      order.le (m (r' + 1)).2 (m (r' + 1 + k)).2 := by
  have E := mark_never_eq_pre fB mark u v w reads s₀ g₀ b₀ never
  have lockedPre : Locked order favours (poolRead u v) (paced select (poolRead u v) reads (s₀, g₀) (r' + 1)) :=
    Drawn.through_locks readers (fun _ _ le => le) fu fv first second lt
  have lockedM : Locked order favours (poolRead u v)
      ((markCourse fB mark u v w reads ((s₀, b₀), g₀) (r' + 1)).1.1,
        (markCourse fB mark u v w reads ((s₀, b₀), g₀) (r' + 1)).2) := by
    rw [(E (r' + 1)).1, (E (r' + 1)).2]; exact lockedPre
  have outlives := ClosedCapture.lock_outlives_loss (fA := select) (fB := Beyond.lossStep)
    (hA := poolRead u v) (reads := fun j => reads (r' + 1 + j)) (b := loss₀)
    CarrierCounts.raises (Drawn.pool_reads readers) (fun le fav => CarrierCounts.upper le fav)
    Thinned.lossStep_accrues lockedM k
  have hJoin := ClosedCapture.join_course select Beyond.lossStep (poolRead u v)
    (fun j => reads (r' + 1 + j))
    (((markCourse fB mark u v w reads ((s₀, b₀), g₀) (r' + 1)).1.1, loss₀),
      (markCourse fB mark u v w reads ((s₀, b₀), g₀) (r' + 1)).2) k
  have hShift := Pace.paced_shift (f := select) (h := poolRead u v) (reads := reads) (s₀, g₀) (r' + 1) k
  have hS1 : (paced select (poolRead u v) (fun j => reads (r' + 1 + j))
        ((markCourse fB mark u v w reads ((s₀, b₀), g₀) (r' + 1)).1.1,
          (markCourse fB mark u v w reads ((s₀, b₀), g₀) (r' + 1)).2) k).1 =
      (markCourse fB mark u v w reads ((s₀, b₀), g₀) (r' + 1 + k)).1.1 := by
    rw [(E (r' + 1)).1, (E (r' + 1)).2, ← hShift, (E (r' + 1 + k)).1]
  have hS2 : (paced select (poolRead u v) (fun j => reads (r' + 1 + j))
        ((markCourse fB mark u v w reads ((s₀, b₀), g₀) (r' + 1)).1.1,
          (markCourse fB mark u v w reads ((s₀, b₀), g₀) (r' + 1)).2) k).2 =
      (markCourse fB mark u v w reads ((s₀, b₀), g₀) (r' + 1 + k)).2 := by
    rw [(E (r' + 1)).1, (E (r' + 1)).2, ← hShift, (E (r' + 1 + k)).2]
  have eq1 : (paced (join select Beyond.lossStep) (joinRead (poolRead u v)) (fun j => reads (r' + 1 + j))
        (((markCourse fB mark u v w reads ((s₀, b₀), g₀) (r' + 1)).1.1, loss₀),
          (markCourse fB mark u v w reads ((s₀, b₀), g₀) (r' + 1)).2) k).1.1 =
      (markCourse fB mark u v w reads ((s₀, b₀), g₀) (r' + 1 + k)).1.1 :=
    hJoin.1.trans hS1
  have eq2 : (paced (join select Beyond.lossStep) (joinRead (poolRead u v)) (fun j => reads (r' + 1 + j))
        (((markCourse fB mark u v w reads ((s₀, b₀), g₀) (r' + 1)).1.1, loss₀),
          (markCourse fB mark u v w reads ((s₀, b₀), g₀) (r' + 1)).2) k).2 =
      (markCourse fB mark u v w reads ((s₀, b₀), g₀) (r' + 1 + k)).2 :=
    hJoin.2.trans hS2
  exact ⟨outlives.1,
    Eq.subst (motive := fun q => Locked order favours (poolRead u v) q) (congr (congrArg Prod.mk eq1) eq2) outlives.2.1,
    Eq.subst (motive := fun a => order.le _ a) eq1 outlives.2.2.1,
    Eq.subst (motive := fun b => order.le _ b) eq2 outlives.2.2.2⟩

/-- **Kept for good exactly where the carriers are already at least as many when the reading comes**
(`Thinned.kept_iff` read through `mark_eq_thinned`). At a reading step `r` at or after the registration
step `τ`, the rule in force favouring the carriers, the others' late reading the mirror of the
carriers' strictly favouring one: the course is locked under the late pool at every step from `r + 1`
exactly where the others are not more than the carriers at `r`. -/
theorem mark_kept_iff {s₀ g₀ : CarrierCounts} {b₀ : B} {τ : Nat}
    (reg : ∀ t, mark (markCourse fB mark u v w reads ((s₀, b₀), g₀) t).1.2 = true ↔ τ ≤ t)
    (hc : w.carrier = u.other) (ho : w.other = u.carrier) (strict : u.other < u.carrier) {r : Nat}
    (at_r : reads r = true) (past : τ ≤ r) (fav : favours (markCourse fB mark u v w reads ((s₀, b₀), g₀) r).2) :
    (∀ k, Locked order favours (poolRead u w)
        ((markCourse fB mark u v w reads ((s₀, b₀), g₀) (r + (1 + k))).1.1,
          (markCourse fB mark u v w reads ((s₀, b₀), g₀) (r + (1 + k))).2)) ↔
      (markCourse fB mark u v w reads ((s₀, b₀), g₀) r).1.1.other ≤
        (markCourse fB mark u v w reads ((s₀, b₀), g₀) r).1.1.carrier := by
  have E := mark_eq_thinned fB mark u v w reads s₀ g₀ b₀ τ reg
  have past' : τ ≤ (Thinned.course Beyond.lossStep u v w τ reads ((s₀, 0), g₀) r).1.2 :=
    Eq.subst (motive := fun n => τ ≤ n) (E r).2.2.symm past
  have fav' : favours (Thinned.course Beyond.lossStep u v w τ reads ((s₀, 0), g₀) r).2 :=
    Eq.subst (motive := favours) (E r).2.1 fav
  have K := Thinned.kept_iff Thinned.lossStep_accrues hc ho strict at_r past' fav'
  rw [(E r).1]
  constructor
  · intro H
    exact K.mp (fun k => by rw [← (E (r + (1 + k))).1, ← (E (r + (1 + k))).2.1]; exact H k)
  · intro more k
    rw [(E (r + (1 + k))).1, (E (r + (1 + k))).2.1]
    exact K.mpr more k

/-- **Kept for good, alternatives stay locked out.** Under `mark_eq_thinned`, at a reading step `r ≥ τ`
with the rule in force favouring the carriers and the others not more than the carriers at `r`, where
the carriers are strictly more at `r + 1`, alternatives are locked out at every step from `r + 1`. -/
theorem mark_kept_locks_out {s₀ g₀ : CarrierCounts} {b₀ : B} {τ : Nat}
    (reg : ∀ t, mark (markCourse fB mark u v w reads ((s₀, b₀), g₀) t).1.2 = true ↔ τ ≤ t)
    (hc : w.carrier = u.other) (ho : w.other = u.carrier) (strict : u.other < u.carrier) {r : Nat}
    (at_r : reads r = true) (past : τ ≤ r) (fav : favours (markCourse fB mark u v w reads ((s₀, b₀), g₀) r).2)
    (more : (markCourse fB mark u v w reads ((s₀, b₀), g₀) r).1.1.other ≤
      (markCourse fB mark u v w reads ((s₀, b₀), g₀) r).1.1.carrier)
    (strictly : (markCourse fB mark u v w reads ((s₀, b₀), g₀) (r + 1)).1.1.other <
      (markCourse fB mark u v w reads ((s₀, b₀), g₀) (r + 1)).1.1.carrier) (k : Nat) :
    admits (markCourse fB mark u v w reads ((s₀, b₀), g₀) (r + (1 + k))).1.1 = false := by
  have E := mark_eq_thinned fB mark u v w reads s₀ g₀ b₀ τ reg
  have past' : τ ≤ (Thinned.course Beyond.lossStep u v w τ reads ((s₀, 0), g₀) r).1.2 :=
    Eq.subst (motive := fun n => τ ≤ n) (E r).2.2.symm past
  have fav' : favours (Thinned.course Beyond.lossStep u v w τ reads ((s₀, 0), g₀) r).2 :=
    Eq.subst (motive := favours) (E r).2.1 fav
  have pfav : favours (pool u w (Thinned.course Beyond.lossStep u v w τ reads ((s₀, 0), g₀) r).1.1) :=
    (mirror_favours_iff hc ho strict).mpr
      (Eq.subst (motive := fun x : CarrierCounts => x.other ≤ x.carrier) (E r).1 more)
  have kept := Thinned.read_late_kept Thinned.lossStep_accrues (mirror_le hc ho strict) at_r past' fav' pfav k
  rw [(E (r + (1 + k))).1]
  exact not_admits_of_le kept.2.2.1
    (Eq.subst (motive := fun x : CarrierCounts => x.other < x.carrier) (E (r + 1)).1 strictly)

/-- **Turned for good under any reading cadence** (`Thinned.turned_iff` at the next reading step `r' > r`).
At a reading step `r ≥ τ` with the carriers not more than the others at `r`:
1. at every step `j` from `r + 1` through the next reading step `r' > r`, the rule in force is
   `pool u w s_r` and favours the others;
2. the course is locked the other way from `r' + 1` for good exactly where the carriers are still not
   more than the others at `r'`. -/
theorem mark_turned_iff {s₀ g₀ : CarrierCounts} {b₀ : B} {τ : Nat}
    (reg : ∀ t, mark (markCourse fB mark u v w reads ((s₀, b₀), g₀) t).1.2 = true ↔ τ ≤ t)
    (hc : w.carrier = u.other) (ho : w.other = u.carrier) (strict : u.other < u.carrier) {r r' : Nat}
    (at_r : reads r = true) (past : τ ≤ r)
    (fewer : (markCourse fB mark u v w reads ((s₀, b₀), g₀) r).1.1.carrier ≤
      (markCourse fB mark u v w reads ((s₀, b₀), g₀) r).1.1.other)
    (lt : r < r') (quiet : ∀ j, r < j → j < r' → reads j = false) (at_r' : reads r' = true) :
    (∀ j, r + 1 ≤ j → j ≤ r' →
        (markCourse fB mark u v w reads ((s₀, b₀), g₀) j).2 =
          pool u w (markCourse fB mark u v w reads ((s₀, b₀), g₀) r).1.1 ∧
        disfavours (markCourse fB mark u v w reads ((s₀, b₀), g₀) j).2) ∧
    ((∀ k, Locked (reverse order) disfavours (poolRead u w)
        ((markCourse fB mark u v w reads ((s₀, b₀), g₀) (r' + (1 + k))).1.1,
          (markCourse fB mark u v w reads ((s₀, b₀), g₀) (r' + (1 + k))).2)) ↔
      (markCourse fB mark u v w reads ((s₀, b₀), g₀) r').1.1.carrier ≤
        (markCourse fB mark u v w reads ((s₀, b₀), g₀) r').1.1.other) := by
  have E := mark_eq_thinned fB mark u v w reads s₀ g₀ b₀ τ reg
  have past' : τ ≤ (Thinned.course Beyond.lossStep u v w τ reads ((s₀, 0), g₀) r).1.2 :=
    Eq.subst (motive := fun n => τ ≤ n) (E r).2.2.symm past
  have rule1 : (markCourse fB mark u v w reads ((s₀, b₀), g₀) (r + 1)).2 =
      pool u w (markCourse fB mark u v w reads ((s₀, b₀), g₀) r).1.1 :=
    (E (r + 1)).2.1.trans ((Thinned.rule_read Thinned.lossStep_accrues at_r past').trans
      (congrArg (pool u w) (E r).1.symm))
  have disPool : disfavours (pool u w (markCourse fB mark u v w reads ((s₀, b₀), g₀) r).1.1) :=
    (mirror_disfavours_iff hc ho strict).mpr fewer
  have span : ∀ j, r + 1 ≤ j → j ≤ r' →
      (markCourse fB mark u v w reads ((s₀, b₀), g₀) j).2 =
        pool u w (markCourse fB mark u v w reads ((s₀, b₀), g₀) r).1.1 ∧
      disfavours (markCourse fB mark u v w reads ((s₀, b₀), g₀) j).2 := by
    intro j hj1 hj2
    obtain ⟨d, hd⟩ := le_dest hj1
    have quiet' : ∀ m, m < d → reads (r + 1 + m) = false := fun m hm =>
      quiet (r + 1 + m) (Nat.lt_of_lt_of_le (Nat.lt_succ_self r) (Nat.le_add_right (r + 1) m))
        (Nat.lt_of_lt_of_le (Nat.add_lt_add_left hm (r + 1)) (hd ▸ hj2))
    have kept := rule_kept_span (f := join select fB) (h := markRead mark u v w) (reads := reads)
      ((s₀, b₀), g₀) (r + 1) d quiet'
    have eqRule : (markCourse fB mark u v w reads ((s₀, b₀), g₀) j).2 =
        pool u w (markCourse fB mark u v w reads ((s₀, b₀), g₀) r).1.1 :=
      (congrArg (fun n => (markCourse fB mark u v w reads ((s₀, b₀), g₀) n).2) hd).trans
        (kept.trans rule1)
    exact ⟨eqRule, Eq.subst (motive := disfavours) eqRule.symm disPool⟩
  have dis_r' : disfavours (Thinned.course Beyond.lossStep u v w τ reads ((s₀, 0), g₀) r').2 :=
    Eq.subst (motive := disfavours) (E r').2.1 (span r' (Nat.succ_le_of_lt lt) (Nat.le_refl r')).2
  have past_r' : τ ≤ (Thinned.course Beyond.lossStep u v w τ reads ((s₀, 0), g₀) r').1.2 :=
    Eq.subst (motive := fun n => τ ≤ n) (E r').2.2.symm (Nat.le_trans past (Nat.le_of_lt lt))
  have K := Thinned.turned_iff Thinned.lossStep_accrues hc ho strict at_r' past_r' dis_r'
  refine ⟨span, ?_⟩
  rw [(E r').1]
  constructor
  · intro H
    exact K.mp (fun k => by rw [← (E (r' + (1 + k))).1, ← (E (r' + (1 + k))).2.1]; exact H k)
  · intro more k
    rw [(E (r' + (1 + k))).1, (E (r' + (1 + k))).2.1]
    exact K.mpr more k

/-- **Admitted for good exactly where the carriers are still not more one step after the reading**, for
every reading cadence. Under `mark_eq_thinned`, at a reading step `r ≥ τ` with the carriers not more than
the others at `r`: at every step from `r + 1` the rule in force favours the others and alternatives are
admitted, exactly where the carriers are not more than the others at `r + 1`. -/
theorem mark_turned_admits_iff {s₀ g₀ : CarrierCounts} {b₀ : B} {τ : Nat}
    (reg : ∀ t, mark (markCourse fB mark u v w reads ((s₀, b₀), g₀) t).1.2 = true ↔ τ ≤ t)
    (hc : w.carrier = u.other) (ho : w.other = u.carrier) (strict : u.other < u.carrier) {r : Nat}
    (at_r : reads r = true) (past : τ ≤ r)
    (fewer : (markCourse fB mark u v w reads ((s₀, b₀), g₀) r).1.1.carrier ≤
      (markCourse fB mark u v w reads ((s₀, b₀), g₀) r).1.1.other) :
    (∀ k, disfavours (markCourse fB mark u v w reads ((s₀, b₀), g₀) (r + 1 + k)).2 ∧
        admits (markCourse fB mark u v w reads ((s₀, b₀), g₀) (r + 1 + k)).1.1 = true) ↔
      (markCourse fB mark u v w reads ((s₀, b₀), g₀) (r + 1)).1.1.carrier ≤
        (markCourse fB mark u v w reads ((s₀, b₀), g₀) (r + 1)).1.1.other := by
  have E := mark_eq_thinned fB mark u v w reads s₀ g₀ b₀ τ reg
  constructor
  · intro H
    exact Nat.le_of_ble_eq_true (H 0).2
  · intro next k
    have past' : τ ≤ (Thinned.course Beyond.lossStep u v w τ reads ((s₀, 0), g₀) r).1.2 :=
      Eq.subst (motive := fun n => τ ≤ n) (E r).2.2.symm past
    have past1 : τ ≤ (Thinned.course Beyond.lossStep u v w τ reads ((s₀, 0), g₀) (r + 1)).1.2 :=
      Eq.subst (motive := fun n => τ ≤ n) (E (r + 1)).2.2.symm (Nat.le_succ_of_le past)
    have rule1 := Thinned.rule_read Thinned.lossStep_accrues at_r past'
    have fewer' : (Thinned.course Beyond.lossStep u v w τ reads ((s₀, 0), g₀) r).1.1.carrier ≤
        (Thinned.course Beyond.lossStep u v w τ reads ((s₀, 0), g₀) r).1.1.other :=
      Eq.subst (motive := fun x : CarrierCounts => x.carrier ≤ x.other) (E r).1 fewer
    have dis1 : disfavours (Thinned.course Beyond.lossStep u v w τ reads ((s₀, 0), g₀) (r + 1)).2 :=
      Eq.subst (motive := disfavours) rule1.symm ((mirror_disfavours_iff hc ho strict).mpr fewer')
    have next' : (Thinned.course Beyond.lossStep u v w τ reads ((s₀, 0), g₀) (r + 1)).1.1.carrier ≤
        (Thinned.course Beyond.lossStep u v w τ reads ((s₀, 0), g₀) (r + 1)).1.1.other :=
      Eq.subst (motive := fun x : CarrierCounts => x.carrier ≤ x.other) (E (r + 1)).1 next
    have here := Thinned.past_course (u := u) (v := v) (w := w) (reads := reads) Thinned.lossStep_accrues past1
    have region : ∀ (b : Bool) (p : CarrierCounts × CarrierCounts),
        (disfavours p.2 ∧ p.1.carrier ≤ p.1.other) →
        (disfavours (Pace.turn select (poolRead u w) b p).2 ∧
          (Pace.turn select (poolRead u w) b p).1.carrier ≤ (Pace.turn select (poolRead u w) b p).1.other)
      | true, _, held => ⟨(mirror_disfavours_iff hc ho strict).mpr held.2, select_keeps_admitted held.2 held.1⟩
      | false, _, held => ⟨held.1, select_keeps_admitted held.2 held.1⟩
    have held := region_stays (reads := fun j => reads (r + 1 + j))
      (Q := fun p : CarrierCounts × CarrierCounts => disfavours p.2 ∧ p.1.carrier ≤ p.1.other) region
      (c := ((Thinned.course Beyond.lossStep u v w τ reads ((s₀, 0), g₀) (r + 1)).1.1,
        (Thinned.course Beyond.lossStep u v w τ reads ((s₀, 0), g₀) (r + 1)).2)) ⟨dis1, next'⟩ k
    have back := Eq.subst (motive := fun q : CarrierCounts × CarrierCounts => disfavours q.2 ∧ q.1.carrier ≤ q.1.other)
      (here k).symm held
    exact ⟨Eq.subst (motive := disfavours) (E (r + 1 + k)).2.1.symm back.1,
      Eq.subst (motive := fun x : CarrierCounts => admits x = true) (E (r + 1 + k)).1.symm
        (Nat.ble_eq_true_of_le back.2)⟩

end Mark

/-! ## Part A.3: the race -/

section Race

variable {S : Type}

/-- What lies beyond the share, stock and learner, steps by the gated learner, the gate set by the share. -/
def raceStep (W : StrainWorld) (L : UnguidedLoop S Nat EmergenceAct) (p : CarrierCounts × (Nat × S))
    (_ : CarrierCounts) : Nat × S :=
  gatedStep W L (admits p.1) p.2

/-- **The race**: the share selected by the rule in force, the learner stepping through the gate the
share sets, the rule read through the learner's registration. -/
abbrev raceCourse (W : StrainWorld) (L : UnguidedLoop S Nat EmergenceAct) (mark : S → Bool)
    (u v w : CarrierCounts) (reads : Nat → Bool) (c : (CarrierCounts × (Nat × S)) × CarrierCounts)
    (t : Nat) : (CarrierCounts × (Nat × S)) × CarrierCounts :=
  markCourse (raceStep W L) (fun b => mark b.2) u v w reads c t

variable (W : StrainWorld) (L : UnguidedLoop S Nat EmergenceAct) (mark : S → Bool) (u v w : CarrierCounts)
  (reads : Nat → Bool)

/-- **The race reads beyond the share**: where `mark` takes both values at a share where the two pools
differ, `markRead` is not a function of the share alone. -/
theorem race_reads_beyond {x : CarrierCounts} {s₁ s₂ : S} {g : CarrierCounts}
    (m₁ : mark s₁ = true) (m₂ : mark s₂ = false) (apart : pool u w x ≠ pool u v x) :
    ¬ Unread (join select (raceStep W L)) (markRead (fun b : Nat × S => mark b.2) u v w) :=
  mark_reads_beyond (raceStep W L) (fun b => mark b.2) u v w (b₁ := (0, s₁)) (b₂ := (0, s₂)) (g := g)
    m₁ m₂ apart

/-- **The stock and the learner run the gated course, the gate read from the share.** -/
theorem race_stock_is_gated (s₀ g₀ : CarrierCounts) (x₀ : Nat) :
    ∀ t, (raceCourse W L mark u v w reads ((s₀, (x₀, L.init)), g₀) t).1.2 =
      gatedOrbit W L (fun k => admits (raceCourse W L mark u v w reads ((s₀, (x₀, L.init)), g₀) k).1.1)
        x₀ t
  | 0 => rfl
  | t + 1 =>
    (mark_beyond_succ (raceStep W L) (fun b => mark b.2) u v w reads _ t).trans
      (congrArg (gatedStep W L _) (race_stock_is_gated s₀ g₀ x₀ t))

/-- **Read from the share alone, nothing the learner registers changes the selection**: the closed
counterpart of the race, the others reading `v` throughout, has the same share and rule at every step
from starts differing only beyond the share (`ClosedCapture.join_alike`). -/
theorem closed_race_registration_irrelevant (s : CarrierCounts) (b b' : Nat × S) (g : CarrierCounts)
    (t : Nat) :
    (paced (join select (raceStep W L)) (joinRead (poolRead u v)) reads ((s, b), g) t).1.1 =
        (paced (join select (raceStep W L)) (joinRead (poolRead u v)) reads ((s, b'), g) t).1.1 ∧
      (paced (join select (raceStep W L)) (joinRead (poolRead u v)) reads ((s, b), g) t).2 =
        (paced (join select (raceStep W L)) (joinRead (poolRead u v)) reads ((s, b'), g) t).2 :=
  join_alike select (raceStep W L) (poolRead u v) reads s b b' g t

end Race

/-- Once `emergentLoop` registers (`ownHat .sustainedContinuation = true`), it remains registered at
every later update. -/
theorem registers_stays (s : LearnerState) (y : Nat) (reg : registers s = true) :
    registers (emergentLoop.update s y) = true := by
  have h : s.ownHat .sustainedContinuation = true := reg
  show (s.ownHat .sustainedContinuation || emergentPulse s y .sustainedContinuation) = true
  rw [h]; rfl

/-- Once `emergentLoop` resolves unregistered (`phase = .resolved` and `registers = false`), every
later update preserves both. -/
theorem resolved_unregistered_stays (s : LearnerState) (y : Nat)
    (res : s.phase = .resolved) (unreg : registers s = false) :
    (emergentLoop.update s y).phase = .resolved ∧ registers (emergentLoop.update s y) = false := by
  have hp : nextPhase s.phase (emergentAct s) y = .resolved := by rw [res]; rfl
  have hpulse : emergentPulse s y .sustainedContinuation = false := by
    dsimp only [emergentPulse]; rw [res]
  have hu : s.ownHat .sustainedContinuation = false := unreg
  refine ⟨hp, ?_⟩
  show (s.ownHat .sustainedContinuation || emergentPulse s y .sustainedContinuation) = false
  rw [hu, hpulse]; rfl

theorem registers_from_of_resolved (W : StrainWorld) (adm : Nat → Bool) (x₀ τ : Nat)
    (pre : ∀ t, t < τ → registers (gatedOrbit W emergentLoop adm x₀ t).2 = false)
    (at_τ : registers (gatedOrbit W emergentLoop adm x₀ τ).2 = true) :
    ∀ t, registers (gatedOrbit W emergentLoop adm x₀ t).2 = true ↔ τ ≤ t := by
  have stay : ∀ k, registers (gatedOrbit W emergentLoop adm x₀ (τ + k)).2 = true := by
    intro k
    induction k with
    | zero => exact at_τ
    | succ k ih => exact registers_stays _ _ ih
  intro t
  constructor
  · intro ht
    match Nat.lt_or_ge t τ with
    | .inl lt => exact absurd ht (fun h => Bool.noConfusion ((pre t lt).symm.trans h))
    | .inr ge => exact ge
  · intro le
    obtain ⟨k, hk⟩ := le_dest le
    rw [hk]
    exact stay k

theorem unregistered_forever_of_resolved (W : StrainWorld) (adm : Nat → Bool) (x₀ τ : Nat)
    (pre : ∀ t, t < τ → registers (gatedOrbit W emergentLoop adm x₀ t).2 = false)
    (res : (gatedOrbit W emergentLoop adm x₀ τ).2.phase = .resolved)
    (unreg : registers (gatedOrbit W emergentLoop adm x₀ τ).2 = false) :
    ∀ t, registers (gatedOrbit W emergentLoop adm x₀ t).2 = false := by
  have stay : ∀ k, (gatedOrbit W emergentLoop adm x₀ (τ + k)).2.phase = .resolved ∧
      registers (gatedOrbit W emergentLoop adm x₀ (τ + k)).2 = false := by
    intro k
    induction k with
    | zero => exact ⟨res, unreg⟩
    | succ k ih => exact resolved_unregistered_stays _ _ ih.1 ih.2
  intro t
  match Nat.lt_or_ge t τ with
  | .inl lt => exact pre t lt
  | .inr ge =>
    obtain ⟨k, hk⟩ := le_dest ge
    rw [hk]
    exact (stay k).2

/-! ## Part A.4: the six witnesses (`W1`–`W6`) -/

/-- Race of `emergentLoop` under `u = hi`, `v = Second.oneToOne`, `w = lo`, starting from `x₀ = 14`,
`s₀ = ⟨1, others, _⟩`, `g₀ = hi`. -/
abbrev emergentRace (W : StrainWorld) (others : Nat) (hpos : 0 < others) (reads : Nat → Bool) :
    Nat → (CarrierCounts × (Nat × LearnerState)) × CarrierCounts :=
  raceCourse W emergentLoop registers hi Second.oneToOne lo reads
    ((⟨1, others, hpos⟩, (14, emergentLoop.init)), hi)

/-- Shifted strain world `wMasked`: identical `xCrit = 6` and `stepStock` to `wEndo`, with plateau
sensory return capped at `x = 10` instead of `12` (so the residual appears one step later, at `t = 2`). -/
def wMasked : StrainWorld where
  xCrit := 6
  stepStock := wEndo.stepStock
  sense x a :=
    match a with
    | .extract => minNat x 10 + 4
    | .safe => minNat x 10 + 1

/-- Periodic three-step reading cadence `false, false, true, ...`, defined by structural recursion. -/
def cadence3 : Nat → Bool
  | 0 => false
  | 1 => false
  | 2 => true
  | n + 3 => cadence3 n

theorem cadence3_mod (j : Nat) :
    cadence3 (3 * j) = false ∧ cadence3 (3 * j + 1) = false ∧ cadence3 (3 * j + 2) = true := by
  induction j with
  | zero => exact ⟨rfl, rfl, rfl⟩
  | succ j ih =>
    have h0 : 3 * (j + 1) = 3 * j + 3 := rfl
    have h1 : 3 * j + 3 + 1 = (3 * j + 1) + 3 := Nat.add_right_comm (3 * j) 3 1
    have h2 : 3 * j + 3 + 2 = (3 * j + 2) + 3 := Nat.add_right_comm (3 * j) 3 2
    rw [h0, h1, h2]
    exact ⟨ih.1, ih.2.1, ih.2.2⟩

/-- `cadence3` aligns with the end of every three-step span `3 * j ≤ t < 3 * (j + 1)`
(`Becoming.PacedStock.ReadAtSpanEnd`). -/
theorem cadence3_readAtSpanEnd : PacedStock.ReadAtSpanEnd (fun j => 3 * j) cadence3 := by
  intro j t hle hlt
  obtain ⟨m, hm⟩ := le_dest hle
  rw [hm]
  match m with
  | 0 =>
    refine ⟨fun h => absurd h (fun e => Bool.noConfusion ((cadence3_mod j).1.symm.trans e)),
      fun h => absurd h (Nat.ne_of_lt (by
        show 3 * j + 0 + 1 < 3 * (j + 1)
        exact Nat.add_lt_add_left (by decide : 0 + 1 < 3) (3 * j)))⟩
  | 1 =>
    refine ⟨fun h => absurd h (fun e => Bool.noConfusion ((cadence3_mod j).2.1.symm.trans e)),
      fun h => absurd h (Nat.ne_of_lt (by
        show 3 * j + 1 + 1 < 3 * (j + 1)
        exact Nat.add_lt_add_left (by decide : 1 + 1 < 3) (3 * j)))⟩
  | 2 => exact ⟨fun _ => rfl, fun _ => (cadence3_mod j).2.2⟩
  | m + 3 =>
    have hlt' : 3 * j + (m + 3) < 3 * j + 3 := hm ▸ hlt
    exact absurd (Naturals.lt_of_add_lt_add_left hlt') (Nat.not_lt_of_ge (Nat.le_add_left 3 m))

theorem hi_lo_hc : lo.carrier = hi.other := rfl
theorem hi_lo_ho : lo.other = hi.carrier := rfl
theorem hi_strict : hi.other < hi.carrier := by decide

theorem emergentRace_eq_closedOrbit_before (W : StrainWorld) (others : Nat) (hpos : 0 < others)
    (reads : Nat → Bool) (T : Nat)
    (admBefore : ∀ k, k < T → admits (emergentRace W others hpos reads k).1.1 = true) :
    (emergentRace W others hpos reads T).1.2 = closedOrbit W emergentLoop 14 T := by
  rw [race_stock_is_gated]
  exact gated_eq_closed W emergentLoop _ 14 T (fun k hk _ => admBefore k hk)

theorem reg4_of_race (W : StrainWorld) (others : Nat) (hpos : 0 < others) (reads : Nat → Bool)
    (h0 : registers (emergentRace W others hpos reads 0).1.2.2 = false)
    (h1 : registers (emergentRace W others hpos reads 1).1.2.2 = false)
    (h2 : registers (emergentRace W others hpos reads 2).1.2.2 = false)
    (h3 : registers (emergentRace W others hpos reads 3).1.2.2 = false)
    (h4 : registers (emergentRace W others hpos reads 4).1.2.2 = true) :
    ∀ t, registers (emergentRace W others hpos reads t).1.2.2 = true ↔ 4 ≤ t := by
  intro t
  rw [race_stock_is_gated]
  apply registers_from_of_resolved W _ 14 4
  · intro k hk
    rw [← race_stock_is_gated]
    match k with
    | 0 => exact h0
    | 1 => exact h1
    | 2 => exact h2
    | 3 => exact h3
    | k + 4 => exact absurd hk (Nat.not_lt_of_ge (Nat.le_add_left 4 k))
  · rw [← race_stock_is_gated]; exact h4

theorem unreg_of_race (W : StrainWorld) (others : Nat) (hpos : 0 < others) (reads : Nat → Bool)
    (h0 : registers (emergentRace W others hpos reads 0).1.2.2 = false)
    (h1 : registers (emergentRace W others hpos reads 1).1.2.2 = false)
    (h2 : registers (emergentRace W others hpos reads 2).1.2.2 = false)
    (h3 : registers (emergentRace W others hpos reads 3).1.2.2 = false)
    (hres : (emergentRace W others hpos reads 4).1.2.2.phase = .resolved)
    (h4 : registers (emergentRace W others hpos reads 4).1.2.2 = false) :
    ∀ t, registers (emergentRace W others hpos reads t).1.2.2 = false := by
  intro t
  rw [race_stock_is_gated]
  apply unregistered_forever_of_resolved W _ 14 4
  · intro k hk
    rw [← race_stock_is_gated]
    match k with
    | 0 => exact h0
    | 1 => exact h1
    | 2 => exact h2
    | 3 => exact h3
    | k + 4 => exact absurd hk (Nat.not_lt_of_ge (Nat.le_add_left 4 k))
  · rw [← race_stock_is_gated]; exact hres
  · rw [← race_stock_is_gated]; exact h4

def w1Race := emergentRace wEndo 20 (Nat.zero_lt_succ 19) (fun _ => true)
def w2Race := emergentRace wEndo 12 (Nat.zero_lt_succ 11) (fun _ => true)
def w3Race := emergentRace wEndo 4 (Nat.zero_lt_succ 3) (fun _ => true)
def w4Race := emergentRace wMasked 20 (Nat.zero_lt_succ 19) (fun _ => true)
def w5SlowRace := emergentRace wEndo 64 (Nat.zero_lt_succ 63) cadence3
def w5FastRace := emergentRace wEndo 64 (Nat.zero_lt_succ 63) (fun _ => true)
def w6Race := emergentRace wExo 20 (Nat.zero_lt_succ 19) (fun _ => true)

/-- **Witness W1 (`race_in_time`):** one carrier, twenty others, `wEndo`, reading every step.
The learner registers exactly from `τ = 4`; at `r = 4` and `r + 1 = 5` carriers remain at most
others, so `mark_turned_admits_iff` gives permanent admission and disfavouring from `t = 5`, the stock
trajectory equals `endogenous_emergence_sufficiency`'s `closedOrbit` for all `t`, staying `10 ≥ 6`
from `t = 4` onward. -/
theorem race_in_time :
    (∀ t, registers (w1Race t).1.2.2 = true ↔ 4 ≤ t) ∧
    (∀ k, disfavours (w1Race (5 + k)).2 ∧ admits (w1Race (5 + k)).1.1 = true) ∧
    (∀ t, (w1Race t).1.2 = closedOrbit wEndo emergentLoop 14 t) ∧
    (∀ t, wEndo.xCrit ≤ (w1Race t).1.2.1) ∧
    (∀ t, 4 ≤ t → emergentLoop.act (w1Race t).1.2.2 = .safe ∧ (w1Race t).1.2.1 = 10) := by
  have hReg : ∀ t, registers (w1Race t).1.2.2 = true ↔ 4 ≤ t :=
    reg4_of_race wEndo 20 _ _ rfl rfl rfl rfl rfl
  have hFewer4 : (w1Race 4).1.1.carrier ≤ (w1Race 4).1.1.other := Nat.le_of_ble_eq_true rfl
  have hFewer5 : (w1Race 5).1.1.carrier ≤ (w1Race 5).1.1.other := Nat.le_of_ble_eq_true rfl
  have hTurn : ∀ k, disfavours (w1Race (5 + k)).2 ∧ admits (w1Race (5 + k)).1.1 = true :=
    (mark_turned_admits_iff (fB := raceStep wEndo emergentLoop) (mark := fun b => registers b.2)
      (u := hi) (v := Second.oneToOne) (w := lo) (reads := fun _ => true) (r := 4)
      hReg hi_lo_hc hi_lo_ho hi_strict rfl (Nat.le_refl 4) hFewer4).mpr hFewer5
  have hAdm : ∀ t, admits (w1Race t).1.1 = true
    | 0 => rfl
    | 1 => rfl
    | 2 => rfl
    | 3 => rfl
    | 4 => rfl
    | k + 5 => by rw [Nat.add_comm k 5]; exact (hTurn k).2
  have hOrb : ∀ t, (w1Race t).1.2 = closedOrbit wEndo emergentLoop 14 t := fun t =>
    emergentRace_eq_closedOrbit_before wEndo 20 _ _ t (fun k _ => hAdm k)
  have hSuff := endogenous_emergence_sufficiency
  refine ⟨hReg, hTurn, hOrb, fun t => ?_, fun t ht => ?_⟩
  · rw [hOrb t]; exact wEndo_orbit_above_crit t
  · rw [hOrb t]; exact ⟨(hSuff.2.2.1 t ht).2.2.2.1, (hSuff.2.2.1 t ht).2.2.2.2⟩

/-- **Witness W2 (`race_late_after_registration`):** one carrier, twelve others, `wEndo`, reading every
step. The probe runs and the learner registers from `τ = 4`, yet carriers already outnumber others at
`r = 4`; by `mark_kept_iff` and `mark_kept_locks_out`, the course is locked in capture from `5`, locked
out from `4`, and stock breaches `3 < 6` at `7`. -/
theorem race_late_after_registration :
    (∀ t, registers (w2Race t).1.2.2 = true ↔ 4 ≤ t) ∧
    (∀ k, Locked order favours (poolRead hi lo) ((w2Race (5 + k)).1.1, (w2Race (5 + k)).2)) ∧
    (∀ k, admits (w2Race (4 + k)).1.1 = false) ∧
    (w2Race 7).1.2.1 = 3 ∧
    (w2Race 7).1.2.1 < wEndo.xCrit := by
  have hReg : ∀ t, registers (w2Race t).1.2.2 = true ↔ 4 ≤ t :=
    reg4_of_race wEndo 12 _ _ rfl rfl rfl rfl rfl
  have hFav4 : favours (w2Race 4).2 := Nat.le_of_ble_eq_true rfl
  have hMore4 : (w2Race 4).1.1.other ≤ (w2Race 4).1.1.carrier := Nat.le_of_ble_eq_true rfl
  have hStrict5 : (w2Race 5).1.1.other < (w2Race 5).1.1.carrier := CoreHelpers.natBlt_true_iff.mp rfl
  have hKept : ∀ k, Locked order favours (poolRead hi lo) ((w2Race (5 + k)).1.1, (w2Race (5 + k)).2) := by
    intro k
    have hk := (mark_kept_iff (fB := raceStep wEndo emergentLoop) (mark := fun b => registers b.2)
      (u := hi) (v := Second.oneToOne) (w := lo) (reads := fun _ => true) (r := 4)
      hReg hi_lo_hc hi_lo_ho hi_strict rfl (Nat.le_refl 4) hFav4).mpr hMore4 k
    have hArith : (4 + (1 + k) : Nat) = 5 + k := (Nat.add_assoc 4 1 k).symm
    exact Eq.subst (motive := fun n => Locked order favours (poolRead hi lo) ((w2Race n).1.1, (w2Race n).2))
      hArith hk
  have hOut : ∀ k, admits (w2Race (4 + k)).1.1 = false
    | 0 => rfl
    | k + 1 => by
      have hk := mark_kept_locks_out hReg hi_lo_hc hi_lo_ho hi_strict rfl (Nat.le_refl 4)
        hFav4 hMore4 hStrict5 k
      have hArith : (4 + (1 + k) : Nat) = 4 + (k + 1) := congrArg (4 + ·) (Nat.add_comm 1 k)
      exact Eq.subst (motive := fun n => admits (w2Race n).1.1 = false) hArith hk
  have hStock7 : (w2Race 7).1.2.1 = 3 := by
    change (emergentRace wEndo 12 (Nat.zero_lt_succ 11) (fun _ => true) 7).1.2.1 = 3
    rw [race_stock_is_gated]
    have h4 : (4 + 3 : Nat) = 7 := rfl
    rw [← h4, lockout_pure_extract wEndo emergentLoop _ 14 4 (fun k hk => by
      obtain ⟨j, hj⟩ := le_dest hk; rw [hj]; exact hOut j) 3]
    rw [← race_stock_is_gated]
    rfl
  exact ⟨hReg, hKept, hOut, hStock7, hStock7 ▸ (by decide : 3 < 6)⟩

/-- **Witness W3 (`race_probe_blocked`):** one carrier, four others, `wEndo`, reading every step.
Carriers already outnumber others at step `2`, blocking the `.safe` probe; the learner resolves
unregistered forever; by `mark_never_eq_pre` and `closed_trap_outlives_loss` the course locks under
the closed pool from step `2` and outlives the loss, while stock drops `3 < 6` at step `5`. -/
theorem race_probe_blocked :
    (∀ t, registers (w3Race t).1.2.2 = false) ∧
    (∀ t, (w3Race t).1.1 = (paced select (poolRead hi Second.oneToOne) (fun _ => true) (⟨1, 4, Nat.zero_lt_succ 3⟩, hi) t).1 ∧
      (w3Race t).2 = (paced select (poolRead hi Second.oneToOne) (fun _ => true) (⟨1, 4, Nat.zero_lt_succ 3⟩, hi) t).2) ∧
    (∀ k, Locked order favours (poolRead hi Second.oneToOne) ((w3Race (2 + k)).1.1, (w3Race (2 + k)).2) ∧
      admits (w3Race (2 + k)).1.1 = false) ∧
    (w3Race 5).1.2.1 = 3 ∧
    (w3Race 5).1.2.1 < wEndo.xCrit := by
  have hUnreg : ∀ t, registers (w3Race t).1.2.2 = false :=
    unreg_of_race wEndo 4 _ _ rfl rfl rfl rfl rfl rfl
  have hPre := mark_never_eq_pre (raceStep wEndo emergentLoop) (fun b => registers b.2)
    hi Second.oneToOne lo (fun _ => true) ⟨1, 4, Nat.zero_lt_succ 3⟩ hi (14, emergentLoop.init) hUnreg
  have hReaders : order.le Second.oneToOne hi := show 1 * 1 ≤ 4 * 1 by decide
  have hFu : favours hi := show 1 ≤ 4 by decide
  have hFv : favours Second.oneToOne := show 1 ≤ 1 by decide
  have hLt2 : (w3Race 2).1.1.other < (w3Race 2).1.1.carrier := CoreHelpers.natBlt_true_iff.mp rfl
  have hTrap : ∀ k, Locked order favours (poolRead hi Second.oneToOne) ((w3Race (2 + k)).1.1, (w3Race (2 + k)).2) ∧
      admits (w3Race (2 + k)).1.1 = false := by
    intro k
    have hc := closed_trap_outlives_loss (fB := raceStep wEndo emergentLoop) (mark := fun b => registers b.2)
      (u := hi) (v := Second.oneToOne) (w := lo) (reads := fun _ => true)
      hUnreg hReaders hFu hFv (r := 0) (r' := 1) rfl rfl (by decide) 0 k
    exact ⟨hc.2.1, not_admits_of_le hc.2.2.1 hLt2⟩
  have hStock5 : (w3Race 5).1.2.1 = 3 := by
    change (emergentRace wEndo 4 (Nat.zero_lt_succ 3) (fun _ => true) 5).1.2.1 = 3
    rw [race_stock_is_gated]
    have h2 : (2 + 3 : Nat) = 5 := rfl
    rw [← h2, lockout_pure_extract wEndo emergentLoop _ 14 2 (fun k hk => by
      obtain ⟨j, hj⟩ := le_dest hk; rw [hj]; exact (hTrap j).2) 3]
    rw [← race_stock_is_gated]
    rfl
  exact ⟨hUnreg, hPre, hTrap, hStock5, hStock5 ▸ (by decide : 3 < 6)⟩

/-- **Witness W4 (`race_masked_strain`):** same start (`20` others) and same learner as W1, with
`wMasked` masking the strain one step longer. Registration shifts from `4` to `5`, by which point
the first favouring reading at `r = 7` sees `others < carriers`; `mark_kept_locks_out` locks out all
later steps and stock drops `3 < 6` at `8`. -/
theorem race_masked_strain :
    (∀ t, registers (w4Race t).1.2.2 = true ↔ 5 ≤ t) ∧
    (∀ k, Locked order favours (poolRead hi lo) ((w4Race (8 + k)).1.1, (w4Race (8 + k)).2)) ∧
    (∀ k, admits (w4Race (6 + k)).1.1 = false) ∧
    (w4Race 8).1.2.1 = 3 ∧
    (w4Race 8).1.2.1 < wMasked.xCrit := by
  have hReg : ∀ t, registers (w4Race t).1.2.2 = true ↔ 5 ≤ t := by
    intro t
    change registers (emergentRace wMasked 20 (Nat.zero_lt_succ 19) (fun _ => true) t).1.2.2 = true ↔ 5 ≤ t
    rw [race_stock_is_gated]
    apply registers_from_of_resolved wMasked _ 14 5
    · intro k hk
      rw [← race_stock_is_gated]
      match k with
      | 0 => rfl
      | 1 => rfl
      | 2 => rfl
      | 3 => rfl
      | 4 => rfl
      | k + 5 => exact absurd hk (Nat.not_lt_of_ge (Nat.le_add_left 5 k))
    · rw [← race_stock_is_gated]; rfl
  have hFav7 : favours (w4Race 7).2 := Nat.le_of_ble_eq_true rfl
  have hMore7 : (w4Race 7).1.1.other ≤ (w4Race 7).1.1.carrier := Nat.le_of_ble_eq_true rfl
  have hStrict8 : (w4Race 8).1.1.other < (w4Race 8).1.1.carrier := CoreHelpers.natBlt_true_iff.mp rfl
  have hKept : ∀ k, Locked order favours (poolRead hi lo) ((w4Race (8 + k)).1.1, (w4Race (8 + k)).2) := by
    intro k
    have hk := (mark_kept_iff (fB := raceStep wMasked emergentLoop) (mark := fun b => registers b.2)
      (u := hi) (v := Second.oneToOne) (w := lo) (reads := fun _ => true) (r := 7)
      hReg hi_lo_hc hi_lo_ho hi_strict rfl (by decide : 5 ≤ 7) hFav7).mpr hMore7 k
    have hArith : (7 + (1 + k) : Nat) = 8 + k := (Nat.add_assoc 7 1 k).symm
    exact Eq.subst (motive := fun n => Locked order favours (poolRead hi lo) ((w4Race n).1.1, (w4Race n).2))
      hArith hk
  have hOut : ∀ k, admits (w4Race (6 + k)).1.1 = false
    | 0 => rfl
    | 1 => rfl
    | k + 2 => by
      have hk := mark_kept_locks_out hReg hi_lo_hc hi_lo_ho hi_strict rfl (by decide : 5 ≤ 7)
        hFav7 hMore7 hStrict8 k
      have hArith : (7 + (1 + k) : Nat) = 6 + (k + 2) :=
        (Nat.add_assoc 7 1 k).symm.trans (Nat.add_comm 8 k |>.trans
          (Nat.add_assoc k 2 6 |>.trans (Nat.add_comm (k + 2) 6)))
      exact Eq.subst (motive := fun n => admits (w4Race n).1.1 = false) hArith hk
  have hStock8 : (w4Race 8).1.2.1 = 3 := by
    change (emergentRace wMasked 20 (Nat.zero_lt_succ 19) (fun _ => true) 8).1.2.1 = 3
    rw [race_stock_is_gated]
    have h6 : (6 + 2 : Nat) = 8 := rfl
    rw [← h6, lockout_pure_extract wMasked emergentLoop _ 14 6 (fun k hk => by
      obtain ⟨j, hj⟩ := le_dest hk; rw [hj]; exact hOut j) 2]
    rw [← race_stock_is_gated]
    rfl
  exact ⟨hReg, hKept, hOut, hStock8, hStock8 ▸ (by decide : 3 < 6)⟩

/-- **Witness W5a (`race_slow_cadence`):** one carrier, sixty-four others, `wEndo`, three-step reading
cadence `cadence3` (`ReadAtSpanEnd (fun j => 3 * j)`). The learner registers from `4`, the next
reading step is `r = 5` where `others < carriers`, so `mark_kept_iff` and `mark_kept_locks_out` lock
it into capture from `6`, locked out from `4`, with stock `3 < 6` at `7`. -/
theorem race_slow_cadence :
    (∀ t, registers (w5SlowRace t).1.2.2 = true ↔ 4 ≤ t) ∧
    (∀ k, Locked order favours (poolRead hi lo) ((w5SlowRace (6 + k)).1.1, (w5SlowRace (6 + k)).2)) ∧
    (∀ k, admits (w5SlowRace (4 + k)).1.1 = false) ∧
    (w5SlowRace 7).1.2.1 = 3 ∧
    (w5SlowRace 7).1.2.1 < wEndo.xCrit := by
  have hReg : ∀ t, registers (w5SlowRace t).1.2.2 = true ↔ 4 ≤ t :=
    reg4_of_race wEndo 64 _ cadence3 rfl rfl rfl rfl rfl
  have hFav5 : favours (w5SlowRace 5).2 := Nat.le_of_ble_eq_true rfl
  have hMore5 : (w5SlowRace 5).1.1.other ≤ (w5SlowRace 5).1.1.carrier := Nat.le_of_ble_eq_true rfl
  have hStrict6 : (w5SlowRace 6).1.1.other < (w5SlowRace 6).1.1.carrier := CoreHelpers.natBlt_true_iff.mp rfl
  have hKept : ∀ k, Locked order favours (poolRead hi lo) ((w5SlowRace (6 + k)).1.1, (w5SlowRace (6 + k)).2) := by
    intro k
    have hk := (mark_kept_iff (fB := raceStep wEndo emergentLoop) (mark := fun b => registers b.2)
      (u := hi) (v := Second.oneToOne) (w := lo) (reads := cadence3) (r := 5)
      hReg hi_lo_hc hi_lo_ho hi_strict rfl (by decide : 4 ≤ 5) hFav5).mpr hMore5 k
    have hArith : (5 + (1 + k) : Nat) = 6 + k := (Nat.add_assoc 5 1 k).symm
    exact Eq.subst (motive := fun n => Locked order favours (poolRead hi lo) ((w5SlowRace n).1.1, (w5SlowRace n).2))
      hArith hk
  have hOut : ∀ k, admits (w5SlowRace (4 + k)).1.1 = false
    | 0 => rfl
    | 1 => rfl
    | k + 2 => by
      have hk := mark_kept_locks_out hReg hi_lo_hc hi_lo_ho hi_strict rfl (by decide : 4 ≤ 5)
        hFav5 hMore5 hStrict6 k
      have hArith : (5 + (1 + k) : Nat) = 4 + (k + 2) :=
        (Nat.add_assoc 5 1 k).symm.trans ((Nat.add_comm 6 k).trans
          ((Nat.add_assoc k 2 4).trans (Nat.add_comm (k + 2) 4)))
      exact Eq.subst (motive := fun n => admits (w5SlowRace n).1.1 = false) hArith hk
  have hStock7 : (w5SlowRace 7).1.2.1 = 3 := by
    change (emergentRace wEndo 64 (Nat.zero_lt_succ 63) cadence3 7).1.2.1 = 3
    rw [race_stock_is_gated]
    have h4 : (4 + 3 : Nat) = 7 := rfl
    rw [← h4, lockout_pure_extract wEndo emergentLoop _ 14 4 (fun k hk => by
      obtain ⟨j, hj⟩ := le_dest hk; rw [hj]; exact hOut j) 3]
    rw [← race_stock_is_gated]
    rfl
  exact ⟨hReg, hKept, hOut, hStock7, hStock7 ▸ (by decide : 3 < 6)⟩

/-- **Witness W5b (`race_fast_cadence`):** exact same start (`64` others), same learner, same `wEndo`,
reading every step instead of `cadence3`: `mark_turned_admits_iff` gives permanent admission and
disfavouring from `t = 5`, keeping `6 ≤ stock t` forever. Cadence alone separates collapse from
survival. -/
theorem race_fast_cadence :
    (∀ t, registers (w5FastRace t).1.2.2 = true ↔ 4 ≤ t) ∧
    (∀ k, disfavours (w5FastRace (5 + k)).2 ∧ admits (w5FastRace (5 + k)).1.1 = true) ∧
    (∀ t, (w5FastRace t).1.2 = closedOrbit wEndo emergentLoop 14 t) ∧
    (∀ t, wEndo.xCrit ≤ (w5FastRace t).1.2.1) := by
  have hReg : ∀ t, registers (w5FastRace t).1.2.2 = true ↔ 4 ≤ t :=
    reg4_of_race wEndo 64 _ _ rfl rfl rfl rfl rfl
  have hFewer4 : (w5FastRace 4).1.1.carrier ≤ (w5FastRace 4).1.1.other := Nat.le_of_ble_eq_true rfl
  have hFewer5 : (w5FastRace 5).1.1.carrier ≤ (w5FastRace 5).1.1.other := Nat.le_of_ble_eq_true rfl
  have hTurn : ∀ k, disfavours (w5FastRace (5 + k)).2 ∧ admits (w5FastRace (5 + k)).1.1 = true :=
    (mark_turned_admits_iff (fB := raceStep wEndo emergentLoop) (mark := fun b => registers b.2)
      (u := hi) (v := Second.oneToOne) (w := lo) (reads := fun _ => true) (r := 4)
      hReg hi_lo_hc hi_lo_ho hi_strict rfl (Nat.le_refl 4) hFewer4).mpr hFewer5
  have hAdm : ∀ t, admits (w5FastRace t).1.1 = true
    | 0 => rfl
    | 1 => rfl
    | 2 => rfl
    | 3 => rfl
    | 4 => rfl
    | k + 5 => by rw [Nat.add_comm k 5]; exact (hTurn k).2
  have hOrb : ∀ t, (w5FastRace t).1.2 = closedOrbit wEndo emergentLoop 14 t := fun t =>
    emergentRace_eq_closedOrbit_before wEndo 64 _ _ t (fun k _ => hAdm k)
  refine ⟨hReg, hTurn, hOrb, fun t => ?_⟩
  rw [hOrb t]; exact wEndo_orbit_above_crit t

/-- **Witness W6 (`race_exo_no_false_turn`):** negative control in `wExo` from `20` others.
The learner probes, observes continuing decay `9 → 7`, resolves unregistered forever; by
`mark_never_eq_pre`, share and rule follow the closed pool (`poolRead hi Second.oneToOne`), and the
rule in force favours the carriers at every step. -/
theorem race_exo_no_false_turn :
    (∀ t, registers (w6Race t).1.2.2 = false) ∧
    (∀ t, (w6Race t).1.1 = (paced select (poolRead hi Second.oneToOne) (fun _ => true) (⟨1, 20, Nat.zero_lt_succ 19⟩, hi) t).1 ∧
      (w6Race t).2 = (paced select (poolRead hi Second.oneToOne) (fun _ => true) (⟨1, 20, Nat.zero_lt_succ 19⟩, hi) t).2) ∧
    (∀ t, favours (w6Race t).2) := by
  have hUnreg : ∀ t, registers (w6Race t).1.2.2 = false :=
    unreg_of_race wExo 20 _ _ rfl rfl rfl rfl rfl rfl
  have hPre := mark_never_eq_pre (raceStep wExo emergentLoop) (fun b => registers b.2)
    hi Second.oneToOne lo (fun _ => true) ⟨1, 20, Nat.zero_lt_succ 19⟩ hi (14, emergentLoop.init) hUnreg
  have hFavPre : ∀ t, favours
      (paced select (poolRead hi Second.oneToOne) (fun _ => true) (⟨1, 20, Nat.zero_lt_succ 19⟩, hi) t).2 := by
    have region : ∀ (b : Bool) (p : CarrierCounts × CarrierCounts),
        favours p.2 → favours (Pace.turn select (poolRead hi Second.oneToOne) b p).2
      | true, p, _ => pool_favours (show hi.other ≤ hi.carrier from by decide)
          (show Second.oneToOne.other ≤ Second.oneToOne.carrier from by decide) p.1
      | false, _, fav => fav
    exact region_stays region (show hi.other ≤ hi.carrier from by decide)
  refine ⟨hUnreg, hPre, fun t => ?_⟩
  change favours (markCourse (raceStep wExo emergentLoop) (fun b => registers b.2)
    hi Second.oneToOne lo (fun _ => true) ((⟨1, 20, Nat.zero_lt_succ 19⟩, (14, emergentLoop.init)), hi) t).2
  rw [(hPre t).2]
  exact hFavPre t

/-! ## Part B: split evidence across two agents -/

/-- One-bit mask (`false` keeps `b`, `true` flips `b`). -/
def mask : Bool → Bool → Bool
  | false, b => b
  | true, b => !b

theorem mask_involutive (a b : Bool) : mask a (mask a b) = b := by
  cases a <;> cases b <;> rfl

theorem mask_comm (a b : Bool) : mask a b = mask b a := by
  cases a <;> cases b <;> rfl

theorem mask_assoc (a b c : Bool) : mask (mask a b) c = mask a (mask b c) := by
  cases a <;> cases b <;> cases c <;> rfl

theorem mask_cancel_left (a b : Bool) : mask a (mask a b) = b := mask_involutive a b

/-- Agent A's stream: the private tag `θ`. -/
def viewA (θ : Nat → Bool) : Nat → Bool := θ

/-- Agent B's stream: the private tag masked by the world's depletion signal `d`. -/
def viewB (d θ : Nat → Bool) : Nat → Bool := fun t => mask (θ t) (d t)

/-- Tag permutation sending `θ` to `θ ⊕ d`. -/
def retag (d θ : Nat → Bool) : Nat → Bool := fun t => mask (θ t) (d t)

/-- Open witness exchange: one bit from each agent, combined by `mask`. -/
def exchange (a b : Bool) : Bool := mask a b

/-- Feeding an external observation stream into a Moore loop (`s₀ = L.init`). -/
def feed {S Obs Act : Type} (L : UnguidedLoop S Obs Act) (obs : Nat → Obs) : Nat → S
  | 0 => L.init
  | t + 1 => L.update (feed L obs t) (obs t)

/-- Feeding a finite prefix list of observations from starting state `s`. -/
def feedList {S Obs Act : Type} (L : UnguidedLoop S Obs Act) : S → List Obs → S
  | s, [] => s
  | s, o :: os => feedList L (L.update s o) os

/-- Finite prefix of length `T` of a stream `obs`. -/
def streamPrefix {Obs : Type} (obs : Nat → Obs) : Nat → List Obs
  | 0 => []
  | T + 1 => obs 0 :: streamPrefix (fun t => obs (t + 1)) T

theorem feedList_snoc {S Obs Act : Type} (L : UnguidedLoop S Obs Act) :
    ∀ (os : List Obs) (o : Obs) (s : S),
      feedList L s (os ++ [o]) = L.update (feedList L s os) o
  | [], _, _ => rfl
  | _ :: os, o, s => feedList_snoc L os o (L.update s _)

theorem streamPrefix_succ {Obs : Type} (obs : Nat → Obs) :
    ∀ T, streamPrefix obs (T + 1) = streamPrefix obs T ++ [obs T]
  | 0 => rfl
  | T + 1 => congrArg (obs 0 :: ·) (streamPrefix_succ (fun t => obs (t + 1)) T)

theorem feedList_prefix {S Obs Act : Type} (L : UnguidedLoop S Obs Act) (obs : Nat → Obs) :
    ∀ T, feedList L L.init (streamPrefix obs T) = feed L obs T
  | 0 => rfl
  | T + 1 => by
    rw [streamPrefix_succ, feedList_snoc, feedList_prefix L obs T]
    rfl

/-- Applying the mask of `d` across a finite list of tag bits. -/
def viewBList (d : Nat → Bool) : List Bool → List Bool
  | [] => []
  | b :: bs => mask b (d 0) :: viewBList (fun t => d (t + 1)) bs

theorem viewBList_prefix (d θ : Nat → Bool) :
    ∀ T, viewBList d (streamPrefix θ T) = streamPrefix (viewB d θ) T
  | 0 => rfl
  | T + 1 => congrArg (mask (θ 0) (d 0) :: ·) (viewBList_prefix (fun t => d (t + 1)) (fun t => θ (t + 1)) T)

/-- Exact count over all `2^T` binary tag prefixes of length `T` (position 0 first), by structural
recursion. -/
def countTags : Nat → (List Bool → Bool) → Nat
  | 0, F => cond (F []) 1 0
  | T + 1, F => countTags T (fun θ => F (false :: θ)) + countTags T (fun θ => F (true :: θ))

/-- **B1 (`feed_lockstep`):** streams agreeing before `T` induce equal states at `T`. -/
theorem feed_lockstep {S Obs Act : Type} (L : UnguidedLoop S Obs Act) (obs₁ obs₂ : Nat → Obs) :
    ∀ T, (∀ k, k < T → obs₁ k = obs₂ k) → feed L obs₁ T = feed L obs₂ T
  | 0, _ => rfl
  | T + 1, h => by
    have ih := feed_lockstep L obs₁ obs₂ T (fun k hk => h k (Nat.lt_succ_of_lt hk))
    show L.update (feed L obs₁ T) (obs₁ T) = L.update (feed L obs₂ T) (obs₂ T)
    rw [ih, h T (Nat.lt_succ_self T)]

/-- **B2a (`retag_symmetry`):** `retag d` is an involution (`retag d (retag d θ) t = θ t`), and
`viewB dD θ t = viewB dS (fun k => mask (retag dD θ k) (dS k)) t`. -/
theorem retag_symmetry (dD dS θ : Nat → Bool) (t : Nat) :
    retag dD (retag dD θ) t = θ t ∧
    viewB dD θ t = viewB dS (fun k => mask (retag dD θ k) (dS k)) t := by
  refine ⟨mask_involutive (dD t) (θ t) |> fun _ => ?_, ?_⟩
  · show mask (mask (θ t) (dD t)) (dD t) = θ t
    rw [mask_assoc, mask_comm (dD t) (dD t)]; cases dD t <;> cases θ t <;> rfl
  · show mask (θ t) (dD t) = mask (mask (mask (θ t) (dD t)) (dS t)) (dS t)
    cases θ t <;> cases dD t <;> cases dS t <;> rfl

/-- **B2b (`split_two_of_two`):** retagging swaps which agent sees `θ` and which sees `θ ⊕ d`; each
share alone is one masked bit. -/
theorem split_two_of_two (d θ : Nat → Bool) (t : Nat) :
    viewB d θ t = viewA (retag d θ) t ∧ viewA θ t = viewB d (retag d θ) t := by
  refine ⟨rfl, ?_⟩
  show θ t = mask (mask (θ t) (d t)) (d t)
  cases θ t <;> cases d t <;> rfl

/-- **B2' (`count_view_invariant`):** over all `2^T` binary tag prefixes, `viewBList d` leaves every
predicate's true count unchanged. -/
theorem count_view_invariant :
    ∀ (T : Nat) (F : List Bool → Bool) (d : Nat → Bool),
      countTags T (fun θ => F (viewBList d θ)) = countTags T F
  | 0, _, _ => rfl
  | T + 1, F, d => by
    show countTags T (fun θ => F (mask false (d 0) :: viewBList (fun t => d (t + 1)) θ)) +
        countTags T (fun θ => F (mask true (d 0) :: viewBList (fun t => d (t + 1)) θ)) =
      countTags T (fun θ => F (false :: θ)) + countTags T (fun θ => F (true :: θ))
    have ihF := count_view_invariant T (fun θ => F (false :: θ)) (fun t => d (t + 1))
    have ihT := count_view_invariant T (fun θ => F (true :: θ)) (fun t => d (t + 1))
    cases hd : d 0 with
    | false =>
      show countTags T (fun θ => F (false :: viewBList (fun t => d (t + 1)) θ)) +
          countTags T (fun θ => F (true :: viewBList (fun t => d (t + 1)) θ)) =
        countTags T (fun θ => F (false :: θ)) + countTags T (fun θ => F (true :: θ))
      rw [ihF, ihT]
    | true =>
      show countTags T (fun θ => F (true :: viewBList (fun t => d (t + 1)) θ)) +
          countTags T (fun θ => F (false :: viewBList (fun t => d (t + 1)) θ)) =
        countTags T (fun θ => F (false :: θ)) + countTags T (fun θ => F (true :: θ))
      rw [ihT, ihF, Nat.add_comm]

/-- **B3a (`split_marginal_count_eq`):** exact zero local marginal lift for every Moore agent `L_B` and
every horizon `T` over all `2^T` binary tag prefixes (`TP count = FP count`). -/
theorem split_marginal_count_eq {S : Type} (L : UnguidedLoop S Bool EmergenceAct) (s : S)
    (alarm : S → Bool) (dD dS : Nat → Bool) (T : Nat) :
    countTags T (fun θ => alarm (feedList L s (viewBList dD θ))) =
      countTags T (fun θ => alarm (feedList L s (viewBList dS θ))) :=
  (count_view_invariant T (fun xs => alarm (feedList L s xs)) dD).trans
    (count_view_invariant T (fun xs => alarm (feedList L s xs)) dS).symm

/-- **B3b (`split_marginal_impossibility`):** for every `L_A`, `L_B`, `T`, neither isolated agent can
even separate all tags of `dD` from all tags of `dS`, and both worlds give identical states on B
up to the bijection on tags. -/
theorem split_marginal_impossibility {S_A S_B : Type}
    (L_A : UnguidedLoop S_A Bool EmergenceAct) (L_B : UnguidedLoop S_B Bool EmergenceAct)
    (dD dS : Nat → Bool) (T : Nat) :
    (∀ θ, feed L_A (viewA θ) T = feed L_A (viewA θ) T) ∧
    (∀ θ, feed L_B (viewB dD θ) T = feed L_B (viewB dS (fun k => mask (retag dD θ k) (dS k))) T) ∧
    (∀ alarm : S_A → Bool,
      ¬ ((∀ θ, alarm (feed L_A (viewA θ) T) = true) ∧ (∀ θ, alarm (feed L_A (viewA θ) T) = false))) ∧
    (∀ alarm : S_B → Bool,
      ¬ ((∀ θ, alarm (feed L_B (viewB dD θ) T) = true) ∧ (∀ θ, alarm (feed L_B (viewB dS θ) T) = false))) := by
  refine ⟨fun _ => rfl, fun θ => ?_, fun alarm h => ?_, fun alarm h => ?_⟩
  · exact feed_lockstep L_B _ _ T (fun k _ => (retag_symmetry dD dS θ k).2)
  · exact Bool.noConfusion ((h.1 (fun _ => false)).symm.trans (h.2 (fun _ => false)))
  · let θ' : Nat → Bool := fun k => mask (retag dD (fun _ => false) k) (dS k)
    have hEq := feed_lockstep L_B (viewB dD (fun _ => false)) (viewB dS θ') T
      (fun k _ => (retag_symmetry dD dS (fun _ => false) k).2)
    have hT := h.1 (fun _ => false)
    have hF := h.2 θ'
    rw [hEq] at hT
    exact Bool.noConfusion (hT.symm.trans hF)

/-- **B4 (`silencing_consensus`):** any combination `c` with `c false false = false` over locally
sound alarms never fires in `dD`, on any tag, at any `T`. -/
theorem silencing_consensus {S_A S_B : Type}
    (L_A : UnguidedLoop S_A Bool EmergenceAct) (L_B : UnguidedLoop S_B Bool EmergenceAct)
    (alarmA : S_A → Bool) (alarmB : S_B → Bool) (c : Bool → Bool → Bool) (hc : c false false = false)
    (dD dS : Nat → Bool) (T : Nat)
    (soundA : ∀ θ, alarmA (feed L_A (viewA θ) T) = false)
    (soundB : ∀ θ, alarmB (feed L_B (viewB dS θ) T) = false) :
    ∀ θ, c (alarmA (feed L_A (viewA θ) T)) (alarmB (feed L_B (viewB dD θ) T)) = false := by
  intro θ
  let θ' : Nat → Bool := fun k => mask (retag dD θ k) (dS k)
  have hB : feed L_B (viewB dD θ) T = feed L_B (viewB dS θ') T :=
    feed_lockstep L_B _ _ T (fun k _ => (retag_symmetry dD dS θ k).2)
  rw [soundA θ, hB, soundB θ', hc]

/-- **B5 (`verdict_leak`):** at `T = t + 1`, the soundness filter is what silences: two agents
emitting raw verdicts `alarmA sA = viewA θ t`, `alarmB sB = viewB d θ t` combine via `exchange` to
recover `d t` exactly. -/
theorem verdict_leak (d θ : Nat → Bool) (t : Nat) :
    let L_A : UnguidedLoop Bool Bool EmergenceAct :=
      { init := false, act := fun _ => .extract, update := fun _ o => o }
    let L_B : UnguidedLoop Bool Bool EmergenceAct :=
      { init := false, act := fun _ => .extract, update := fun _ o => o }
    exchange (feed L_A (viewA θ) (t + 1)) (feed L_B (viewB d θ) (t + 1)) = d t := by
  show mask (θ t) (mask (θ t) (d t)) = d t
  exact mask_involutive (θ t) (d t)

/-- **B6 (`exchange_detects`):** open one-bit-per-step exchange recovers `d t` identically across all
tags `θ`. -/
theorem exchange_detects (d θ : Nat → Bool) (t : Nat) :
    exchange (viewA θ t) (viewB d θ t) = d t :=
  mask_involutive (θ t) (d t)

/-! ## Part B.7–B.8: coupling split evidence into `ClosedCapture` via `markCourse` -/

/-- Stepper feeding an external stream `obs` indexed by step count into a Moore loop. -/
def feedStep {S Obs Act : Type} (L : UnguidedLoop S Obs Act) (obs : Nat → Obs)
    (p : CarrierCounts × (Nat × S)) (_ : CarrierCounts) : Nat × S :=
  (p.2.1 + 1, L.update p.2.2 (obs p.2.1))

theorem markCourse_feedStep_eq {S Obs Act : Type} (L : UnguidedLoop S Obs Act) (obs : Nat → Obs)
    (mark : S → Bool) (u v w : CarrierCounts) (reads : Nat → Bool) (s₀ g₀ : CarrierCounts) :
    ∀ t, (markCourse (feedStep L obs) (fun b : Nat × S => mark b.2) u v w reads ((s₀, (0, L.init)), g₀) t).1.2 =
      (t, feed L obs t)
  | 0 => rfl
  | t + 1 => by
    rw [mark_beyond_succ]
    show ( (markCourse (feedStep L obs) (fun b => mark b.2) u v w reads ((s₀, (0, L.init)), g₀) t).1.2.1 + 1,
        L.update (markCourse (feedStep L obs) (fun b => mark b.2) u v w reads ((s₀, (0, L.init)), g₀) t).1.2.2
          (obs (markCourse (feedStep L obs) (fun b => mark b.2) u v w reads ((s₀, (0, L.init)), g₀) t).1.2.1) ) =
      (t + 1, L.update (feed L obs t) (obs t))
    rw [markCourse_feedStep_eq L obs mark u v w reads s₀ g₀ t]

/-- Isolated pair loop: component A updates only from `o.1`, component B updates only from `o.2`. -/
def pairLoop {S_A S_B : Type} (L_A : UnguidedLoop S_A Bool EmergenceAct)
    (L_B : UnguidedLoop S_B Bool EmergenceAct) : UnguidedLoop (S_A × S_B) (Bool × Bool) EmergenceAct where
  init := (L_A.init, L_B.init)
  act s := L_A.act s.1
  update s o := (L_A.update s.1 o.1, L_B.update s.2 o.2)

theorem feed_pairLoop {S_A S_B : Type} (L_A : UnguidedLoop S_A Bool EmergenceAct)
    (L_B : UnguidedLoop S_B Bool EmergenceAct) (oA oB : Nat → Bool) :
    ∀ t, feed (pairLoop L_A L_B) (fun k => (oA k, oB k)) t = (feed L_A oA t, feed L_B oB t)
  | 0 => rfl
  | t + 1 => by
    show (L_A.update (feed (pairLoop L_A L_B) (fun k => (oA k, oB k)) t).1 (oA t),
        L_B.update (feed (pairLoop L_A L_B) (fun k => (oA k, oB k)) t).2 (oB t)) =
      (L_A.update (feed L_A oA t) (oA t), L_B.update (feed L_B oB t) (oB t))
    rw [feed_pairLoop L_A L_B oA oB t]

/-- Joint open-exchange loop: registers `true` permanently once `exchange o.1 o.2 = true`. -/
def exchangeLoop : UnguidedLoop Bool (Bool × Bool) EmergenceAct where
  init := false
  act b := cond b .safe .extract
  update b o := b || exchange o.1 o.2

theorem exchangeLoop_eq_of_d01 (d θ : Nat → Bool) (hd0 : d 0 = false) (hd1 : d 1 = true) :
    ∀ t, feed exchangeLoop (fun k => (viewA θ k, viewB d θ k)) t = true ↔ 2 ≤ t := by
  have h0 : feed exchangeLoop (fun k => (viewA θ k, viewB d θ k)) 0 = false := rfl
  have h1 : feed exchangeLoop (fun k => (viewA θ k, viewB d θ k)) 1 = false := by
    show (false || exchange (viewA θ 0) (viewB d θ 0)) = false
    rw [exchange_detects, hd0]; rfl
  have h2 : feed exchangeLoop (fun k => (viewA θ k, viewB d θ k)) 2 = true := by
    show (feed exchangeLoop (fun k => (viewA θ k, viewB d θ k)) 1 ||
      exchange (viewA θ 1) (viewB d θ 1)) = true
    rw [h1, exchange_detects, hd1]; rfl
  have stay : ∀ k, feed exchangeLoop (fun k => (viewA θ k, viewB d θ k)) (2 + k) = true := by
    intro k
    induction k with
    | zero => exact h2
    | succ k ih =>
      show (feed exchangeLoop (fun k => (viewA θ k, viewB d θ k)) (2 + k) ||
        exchange (viewA θ (2 + k)) (viewB d θ (2 + k))) = true
      rw [ih]; rfl
  intro t
  constructor
  · intro ht
    match t with
    | 0 => exact absurd ht (fun e => Bool.noConfusion (h0.symm.trans e))
    | 1 => exact absurd ht (fun e => Bool.noConfusion (h1.symm.trans e))
    | k + 2 => exact Nat.le_add_left 2 k
  · intro le
    obtain ⟨k, hk⟩ := le_dest le
    rw [hk]; exact stay k

theorem exchangeLoop_never_of_safe (dS θ : Nat → Bool) (hsafe : ∀ t, dS t = false) :
    ∀ t, feed exchangeLoop (fun k => (viewA θ k, viewB dS θ k)) t = false
  | 0 => rfl
  | t + 1 => by
    show (feed exchangeLoop (fun k => (viewA θ k, viewB dS θ k)) t ||
      exchange (viewA θ t) (viewB dS θ t)) = false
    rw [exchangeLoop_never_of_safe dS θ hsafe t, exchange_detects, hsafe t]; rfl

/-- **B7a (`split_silenced_trapped`):** coupled into `ClosedCapture`, any locally sound consensus
between isolated agents keeps the mark `false` on every tag `θ` and every step `t`, locking the
selection under the closed pool and outliving the loss. -/
theorem split_silenced_trapped {S_A S_B : Type}
    (L_A : UnguidedLoop S_A Bool EmergenceAct) (L_B : UnguidedLoop S_B Bool EmergenceAct)
    (alarmA : S_A → Bool) (alarmB : S_B → Bool) (c : Bool → Bool → Bool) (hc : c false false = false)
    (dD dS : Nat → Bool)
    (soundA : ∀ t θ, alarmA (feed L_A (viewA θ) t) = false)
    (soundB : ∀ t θ, alarmB (feed L_B (viewB dS θ) t) = false)
    (u v w s₀ g₀ : CarrierCounts) (reads : Nat → Bool)
    (readers : order.le v u) (fu : favours u) (fv : favours v) {r r' : Nat}
    (first : reads r = true) (second : reads r' = true) (lt : r < r') (loss₀ : Nat) (θ : Nat → Bool) :
    let pair := pairLoop L_A L_B
    let mark : S_A × S_B → Bool := fun s => c (alarmA s.1) (alarmB s.2)
    let M := markCourse (feedStep pair (fun k => (viewA θ k, viewB dD θ k)))
      (fun b : Nat × (S_A × S_B) => mark b.2) u v w reads ((s₀, (0, pair.init)), g₀)
    (∀ t, mark (M t).1.2.2 = false) ∧
    (∀ t, (M t).1.1 = (paced select (poolRead u v) reads (s₀, g₀) t).1 ∧
      (M t).2 = (paced select (poolRead u v) reads (s₀, g₀) t).2) ∧
    (∀ k, Locked order favours (poolRead u v) ((M (r' + 1 + k)).1.1, (M (r' + 1 + k)).2)) ∧
    (∀ k, loss₀ + k ≤ (paced (join select Beyond.lossStep) (joinRead (poolRead u v))
      (fun j => reads (r' + 1 + j)) (((M (r' + 1)).1.1, loss₀), (M (r' + 1)).2) k).1.2) := by
  intro pair mark M
  have hNever : ∀ t, mark (M t).1.2.2 = false := by
    intro t
    have hFeed := markCourse_feedStep_eq pair (fun k => (viewA θ k, viewB dD θ k)) mark u v w reads s₀ g₀ t
    change mark (M t).1.2.2 = false
    rw [congrArg Prod.snd hFeed, feed_pairLoop L_A L_B]
    exact silencing_consensus L_A L_B alarmA alarmB c hc dD dS t (soundA t) (soundB t) θ
  have hPre := mark_never_eq_pre (feedStep pair (fun k => (viewA θ k, viewB dD θ k)))
    (fun b : Nat × (S_A × S_B) => mark b.2) u v w reads s₀ g₀ (0, pair.init) hNever
  refine ⟨hNever, hPre, fun k => ?_, fun k => ?_⟩
  · exact (closed_trap_outlives_loss hNever readers fu fv first second lt loss₀ k).2.1
  · exact (closed_trap_outlives_loss hNever readers fu fv first second lt loss₀ k).1

def s20 : CarrierCounts := ⟨1, 20, Nat.zero_lt_succ 19⟩

def thinnedExchange (t : Nat) : (CarrierCounts × Nat) × CarrierCounts :=
  Thinned.course Beyond.lossStep hi Second.oneToOne lo 2 (fun _ => true) ((s20, 0), hi) t

/-- **B7b (`split_exchange_turns`):** open one-bit exchange (`exchangeLoop`) registers at `τ = 2` for
every tag `θ` when `d 0 = false, d 1 = true`, making share and rule identical to `Thinned.course` with
`N = 2` (independent of `θ`) and turning the selection for good from step `3` (from 1 carrier, 20
others), while emitting zero false turns on `dS ≡ false`. -/
theorem split_exchange_turns (dD dS : Nat → Bool) (hd0 : dD 0 = false) (hd1 : dD 1 = true)
    (hsafe : ∀ t, dS t = false) (θ : Nat → Bool) :
    let MD := markCourse (feedStep exchangeLoop (fun k => (viewA θ k, viewB dD θ k)))
      (fun b : Nat × Bool => b.2) hi Second.oneToOne lo (fun _ => true) ((s20, (0, false)), hi)
    let MS := markCourse (feedStep exchangeLoop (fun k => (viewA θ k, viewB dS θ k)))
      (fun b : Nat × Bool => b.2) hi Second.oneToOne lo (fun _ => true) ((s20, (0, false)), hi)
    (∀ t, (MD t).1.1 = (thinnedExchange t).1.1 ∧ (MD t).2 = (thinnedExchange t).2) ∧
    (∀ k, disfavours (MD (3 + k)).2 ∧ admits (MD (3 + k)).1.1 = true) ∧
    (∀ t, (MS t).1.2.2 = false ∧ favours (MS t).2) := by
  intro MD MS
  have hRegD : ∀ t, (MD t).1.2.2 = true ↔ 2 ≤ t := by
    intro t
    have hF := markCourse_feedStep_eq exchangeLoop (fun k => (viewA θ k, viewB dD θ k))
      (fun b => b) hi Second.oneToOne lo (fun _ => true) s20 hi t
    change (markCourse (feedStep exchangeLoop (fun k => (viewA θ k, viewB dD θ k)))
      (fun b : Nat × Bool => b.2) hi Second.oneToOne lo (fun _ => true)
      ((s20, (0, exchangeLoop.init)), hi) t).1.2.2 = true ↔ 2 ≤ t
    rw [congrArg Prod.snd hF]
    exact exchangeLoop_eq_of_d01 dD θ hd0 hd1 t
  have hThin := mark_eq_thinned (feedStep exchangeLoop (fun k => (viewA θ k, viewB dD θ k)))
    (fun b : Nat × Bool => b.2) hi Second.oneToOne lo (fun _ => true) s20 hi (0, false) 2 hRegD
  have hFewer2 : (MD 2).1.1.carrier ≤ (MD 2).1.1.other := by
    rw [(hThin 2).1]
    exact Nat.le_of_ble_eq_true (rfl : Nat.ble (thinnedExchange 2).1.1.carrier (thinnedExchange 2).1.1.other = true)
  have hFewer3 : (MD 3).1.1.carrier ≤ (MD 3).1.1.other := by
    rw [(hThin 3).1]
    exact Nat.le_of_ble_eq_true (rfl : Nat.ble (thinnedExchange 3).1.1.carrier (thinnedExchange 3).1.1.other = true)
  have hTurn := (mark_turned_admits_iff (fB := feedStep exchangeLoop (fun k => (viewA θ k, viewB dD θ k)))
    (mark := fun b : Nat × Bool => b.2) (u := hi) (v := Second.oneToOne) (w := lo)
    (reads := fun _ => true) (r := 2) hRegD hi_lo_hc hi_lo_ho hi_strict rfl (Nat.le_refl 2)
    hFewer2).mpr hFewer3
  have hNeverS : ∀ t, (MS t).1.2.2 = false := by
    intro t
    have hF := markCourse_feedStep_eq exchangeLoop (fun k => (viewA θ k, viewB dS θ k))
      (fun b => b) hi Second.oneToOne lo (fun _ => true) s20 hi t
    change (markCourse (feedStep exchangeLoop (fun k => (viewA θ k, viewB dS θ k)))
      (fun b : Nat × Bool => b.2) hi Second.oneToOne lo (fun _ => true)
      ((s20, (0, exchangeLoop.init)), hi) t).1.2.2 = false
    rw [congrArg Prod.snd hF]
    exact exchangeLoop_never_of_safe dS θ hsafe t
  have hPreS := mark_never_eq_pre (feedStep exchangeLoop (fun k => (viewA θ k, viewB dS θ k)))
    (fun b : Nat × Bool => b.2) hi Second.oneToOne lo (fun _ => true) s20 hi (0, false) hNeverS
  have hFavPre : ∀ t, favours
      (paced select (poolRead hi Second.oneToOne) (fun _ => true) (s20, hi) t).2 := by
    have region : ∀ (b : Bool) (p : CarrierCounts × CarrierCounts),
        favours p.2 → favours (Pace.turn select (poolRead hi Second.oneToOne) b p).2
      | true, p, _ => pool_favours (show hi.other ≤ hi.carrier from by decide)
          (show Second.oneToOne.other ≤ Second.oneToOne.carrier from by decide) p.1
      | false, _, fav => fav
    exact region_stays region (show hi.other ≤ hi.carrier from by decide)
  refine ⟨fun t => ⟨(hThin t).1, (hThin t).2.1⟩, hTurn, fun t => ⟨hNeverS t, ?_⟩⟩
  rw [(hPreS t).2]; exact hFavPre t

/-- Drawn-down depletion signal along `wEndo`'s all-extract course (`y < 12` after `t + 1` extractions
from `14`). -/
def dEndo (t : Nat) : Bool := Nat.blt (pureExtractStock wEndo 14 (t + 1)) 12

/-- Unstrained baseline signal (`false` at every step). -/
def dSafe (_ : Nat) : Bool := false

/-- **B8 (`split_witness_endo`):** instantiation on `wEndo`'s all-extract strain (`dEndo 0 = false`,
`dEndo 1 = true`), pairing exact zero local marginal (`split_marginal_count_eq`), silenced trapping
(`split_silenced_trapped`), and exchange-driven turning (`split_exchange_turns`). -/
theorem split_witness_endo :
    dEndo 0 = false ∧ dEndo 1 = true ∧
    (∀ {S : Type} (L : UnguidedLoop S Bool EmergenceAct) (s : S) (alarm : S → Bool) (T : Nat),
      countTags T (fun θ => alarm (feedList L s (viewBList dEndo θ))) =
        countTags T (fun θ => alarm (feedList L s (viewBList dSafe θ)))) ∧
    (∀ {S_A S_B : Type} (L_A : UnguidedLoop S_A Bool EmergenceAct)
      (L_B : UnguidedLoop S_B Bool EmergenceAct) (alarmA : S_A → Bool) (alarmB : S_B → Bool)
      (c : Bool → Bool → Bool), c false false = false →
      (∀ t θ, alarmA (feed L_A (viewA θ) t) = false) →
      (∀ t θ, alarmB (feed L_B (viewB dSafe θ) t) = false) →
      ∀ (θ : Nat → Bool) (k : Nat),
        let pair := pairLoop L_A L_B
        let mark : S_A × S_B → Bool := fun s => c (alarmA s.1) (alarmB s.2)
        let M := markCourse (feedStep pair (fun j => (viewA θ j, viewB dEndo θ j)))
          (fun b : Nat × (S_A × S_B) => mark b.2) hi Second.oneToOne lo (fun _ => true)
          ((s20, (0, pair.init)), hi)
        Locked order favours (poolRead hi Second.oneToOne) ((M (2 + k)).1.1, (M (2 + k)).2)) ∧
    (∀ (θ : Nat → Bool) (k : Nat),
      let MD := markCourse (feedStep exchangeLoop (fun j => (viewA θ j, viewB dEndo θ j)))
        (fun b : Nat × Bool => b.2) hi Second.oneToOne lo (fun _ => true) ((s20, (0, false)), hi)
      disfavours (MD (3 + k)).2 ∧ admits (MD (3 + k)).1.1 = true) := by
  refine ⟨rfl, rfl, fun L s alarm T => split_marginal_count_eq L s alarm dEndo dSafe T,
    fun L_A L_B alarmA alarmB c hc soundA soundB θ k => ?_,
    fun θ k => (split_exchange_turns dEndo dSafe rfl rfl (fun _ => rfl) θ).2.1 k⟩
  exact (split_silenced_trapped L_A L_B alarmA alarmB c hc dEndo dSafe soundA soundB
    hi Second.oneToOne lo s20 hi (fun _ => true)
    (by decide : 1 * 1 ≤ 4 * 1) (by decide : 1 ≤ 4) (by decide : 1 ≤ 1)
    (r := 0) (r' := 1) rfl rfl (by decide) 0 θ).2.2.1 k

end EndogenousDetectionRace

end Becoming
