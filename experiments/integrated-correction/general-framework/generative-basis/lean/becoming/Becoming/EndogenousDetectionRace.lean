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
  `mark_turned_iff`, and `mark_turned_admits_iff` state the pre-capture turning window. Part A.2b
  closes the alternating middle band (`MiddleMinus`, `MiddlePlus`, `reading_state_four_way`,
  `middle_disjoint_locked`, `mirror_strict_disfavours_iff`, `mirror_strict_favours_iff`, one-span
  laws `mark_middle_minus_span`, `mark_middle_plus_span`, multi-reading trichotomy
  `mark_middle_band_trichotomy`, and order monotonicity `select_order_mono`, `paced_post_order_mono`,
  `mark_post_order_mono`, `mark_middle_band_monotone_partition`). Witnesses
  (`emergentLoop`, carriers' reading `hi`, others' `oneToOne` then `lo`, rule `hi`, one carrier):
  in time from twenty others (`race_in_time`); registration in full but late from twelve
  (`race_late_after_registration`); the probe blocked from four (`race_probe_blocked`); strain masked
  one step longer (`race_masked_strain`); cadence alone deciding on sixty-four (`race_slow_cadence`,
  `race_fast_cadence`, with `PacedStock.ReadAtSpanEnd` proved for `cadence3`); the exogenous
  control, which never registers and never turns (`race_exo_no_false_turn`); and four middle-band
  separating witnesses (`race_middle_exits_to_lock`, `race_middle_alternates_and_turns`,
  `race_middle_short_oscillation_turns`, and `race_middle_span_recovery_turns` on `cadence2`).
* **Part B — split evidence.** The depletion signal is split as a one-time mask between two isolated
  agents. Each agent's stream is the same in both worlds up to a permutation of the private tag
  (`retag_symmetry`, `split_two_of_two`), with exact count equality over all `2^T` binary tags
  (`count_view_invariant`, `split_marginal_count_eq`, `split_marginal_impossibility`); a consensus
  admitting only locally sound alarms never fires where the substrate is drawn down
  (`silencing_consensus`), while verdicts that are not locally sound leak the witness (`verdict_leak`)
  and one-bit-per-step exchange detects exactly (`exchange_detects`). Through `markCourse`, silenced
  consensus keeps the selection locked across every tag (`split_silenced_trapped`), whereas open
  exchange turns it cleanly (`split_exchange_turns`, instantiated on `wEndo` in `split_witness_endo`).

What is not shown is said in the paper attack (§4): which learners register in time; a closed-loop
split world; distributions on tags beyond counting over all `2^T` tags; and that any actual selection
or population meets these premises.

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

/-! ## Part A.2b: the alternating middle band -/

section MiddleBand

/-- **Strict mirror sign (disfavouring):** against a mirrored reading (`w` is `u` swapped, with
`u.other < u.carrier`), the pool strictly favours the others exactly where the others strictly
outnumber the carriers. -/
theorem mirror_strict_disfavours_iff {u w x : CarrierCounts} (hc : w.carrier = u.other)
    (ho : w.other = u.carrier) (strict : u.other < u.carrier) :
    (pool u w x).carrier < (pool u w x).other ↔ x.carrier < x.other := by
  obtain ⟨d, hd⟩ := le_dest (Nat.succ_le_of_lt strict)
  have huc : u.carrier = u.other + (d + 1) :=
    hd.trans (Nat.add_assoc u.other 1 d |>.trans (congrArg (u.other + ·) (Nat.add_comm 1 d)))
  show x.carrier * u.carrier + x.other * w.carrier < x.carrier * u.other + x.other * w.other ↔ _
  rw [hc, ho, huc, Nat.mul_add x.carrier u.other (d + 1), Nat.mul_add x.other u.other (d + 1)]
  have hL : x.carrier * u.other + x.carrier * (d + 1) + x.other * u.other =
      (x.carrier * u.other + x.other * u.other) + x.carrier * (d + 1) := by
    rw [Nat.add_assoc, Nat.add_comm (x.carrier * (d + 1)) (x.other * u.other), ← Nat.add_assoc]
  have hR : x.carrier * u.other + (x.other * u.other + x.other * (d + 1)) =
      (x.carrier * u.other + x.other * u.other) + x.other * (d + 1) :=
    (Nat.add_assoc _ _ _).symm
  rw [hL, hR]
  exact ⟨fun hlt => Nat.lt_of_not_le fun ge =>
      Nat.not_le_of_gt hlt (Nat.add_le_add_left (Nat.mul_le_mul_right (d + 1) ge) _),
    fun hlt => Nat.add_lt_add_left (Nat.mul_lt_mul_of_pos_right hlt (Nat.zero_lt_succ d)) _⟩

/-- **Strict mirror sign (favouring):** against the same mirrored reading, the pool strictly favours
the carriers exactly where the carriers strictly outnumber the others. -/
theorem mirror_strict_favours_iff {u w x : CarrierCounts} (hc : w.carrier = u.other)
    (ho : w.other = u.carrier) (strict : u.other < u.carrier) :
    (pool u w x).other < (pool u w x).carrier ↔ x.other < x.carrier := by
  obtain ⟨d, hd⟩ := le_dest (Nat.succ_le_of_lt strict)
  have huc : u.carrier = u.other + (d + 1) :=
    hd.trans (Nat.add_assoc u.other 1 d |>.trans (congrArg (u.other + ·) (Nat.add_comm 1 d)))
  show x.carrier * u.other + x.other * w.other < x.carrier * u.carrier + x.other * w.carrier ↔ _
  rw [hc, ho, huc, Nat.mul_add x.other u.other (d + 1), Nat.mul_add x.carrier u.other (d + 1)]
  have hL : x.carrier * u.other + (x.other * u.other + x.other * (d + 1)) =
      (x.carrier * u.other + x.other * u.other) + x.other * (d + 1) :=
    (Nat.add_assoc _ _ _).symm
  have hR : x.carrier * u.other + x.carrier * (d + 1) + x.other * u.other =
      (x.carrier * u.other + x.other * u.other) + x.carrier * (d + 1) := by
    rw [Nat.add_assoc, Nat.add_comm (x.carrier * (d + 1)) (x.other * u.other), ← Nat.add_assoc]
  rw [hL, hR]
  exact ⟨fun hlt => Nat.lt_of_not_le fun ge =>
      Nat.not_le_of_gt hlt (Nat.add_le_add_left (Nat.mul_le_mul_right (d + 1) ge) _),
    fun hlt => Nat.add_lt_add_left (Nat.mul_lt_mul_of_pos_right hlt (Nat.zero_lt_succ d)) _⟩

/-- Alternating middle-band state `MiddleMinus`: carriers are strictly outnumbered while the rule
in force strictly favours the carriers. -/
def MiddleMinus (p : CarrierCounts × CarrierCounts) : Prop :=
  p.1.carrier < p.1.other ∧ p.2.other < p.2.carrier

/-- Alternating middle-band state `MiddlePlus`: carriers strictly outnumber others while the rule
in force strictly favours the others. -/
def MiddlePlus (p : CarrierCounts × CarrierCounts) : Prop :=
  p.1.other < p.1.carrier ∧ p.2.carrier < p.2.other

/-- **Four-regime classification of every `(share, rule)` reading state:** Capture Lock (`other ≤ carrier ∧
favours`), Turned Lock (`carrier ≤ other ∧ disfavours`), `MiddleMinus`, or `MiddlePlus`. -/
theorem reading_state_four_way (p : CarrierCounts × CarrierCounts) :
    (p.1.other ≤ p.1.carrier ∧ favours p.2) ∨
    (p.1.carrier ≤ p.1.other ∧ disfavours p.2) ∨
    MiddleMinus p ∨
    MiddlePlus p := by
  match Nat.lt_or_ge p.1.carrier p.1.other, Nat.lt_or_ge p.2.carrier p.2.other with
  | .inl hco, .inl hgc => exact Or.inr (Or.inl ⟨Nat.le_of_lt hco, Nat.le_of_lt hgc⟩)
  | .inl hco, .inr hge =>
    match Nat.lt_or_ge p.2.other p.2.carrier with
    | .inl hgo => exact Or.inr (Or.inr (Or.inl ⟨hco, hgo⟩))
    | .inr hgc => exact Or.inr (Or.inl ⟨Nat.le_of_lt hco, hgc⟩)
  | .inr hoc, .inr hge => exact Or.inl ⟨hoc, hge⟩
  | .inr hoc, .inl hgc =>
    match Nat.lt_or_ge p.1.other p.1.carrier with
    | .inl hlt => exact Or.inr (Or.inr (Or.inr ⟨hlt, hgc⟩))
    | .inr hle => exact Or.inr (Or.inl ⟨hle, Nat.le_of_lt hgc⟩)

/-- **Disjointness of the middle states:** `MiddleMinus` and `MiddlePlus` are mutually disjoint and
disjoint from both locked regimes. -/
theorem middle_disjoint_locked (p : CarrierCounts × CarrierCounts) :
    ¬ (MiddleMinus p ∧ MiddlePlus p) ∧
    ¬ (MiddleMinus p ∧ (p.1.other ≤ p.1.carrier ∧ favours p.2)) ∧
    ¬ (MiddleMinus p ∧ (p.1.carrier ≤ p.1.other ∧ disfavours p.2)) ∧
    ¬ (MiddlePlus p ∧ (p.1.other ≤ p.1.carrier ∧ favours p.2)) ∧
    ¬ (MiddlePlus p ∧ (p.1.carrier ≤ p.1.other ∧ disfavours p.2)) :=
  ⟨fun h => Nat.not_le_of_gt h.1.1 (Nat.le_of_lt h.2.1),
   fun h => Nat.not_le_of_gt h.1.1 h.2.1,
   fun h => Nat.not_le_of_gt h.1.2 h.2.2,
   fun h => Nat.not_le_of_gt h.1.2 h.2.2,
   fun h => Nat.not_le_of_gt h.1.1 h.2.1⟩

theorem mark_rule_at_next_read {B : Type} {fB : CarrierCounts × B → CarrierCounts → B}
    {mark : B → Bool} {u v w : CarrierCounts} {reads : Nat → Bool}
    {s₀ g₀ : CarrierCounts} {b₀ : B} {τ : Nat}
    (reg : ∀ t, mark (markCourse fB mark u v w reads ((s₀, b₀), g₀) t).1.2 = true ↔ τ ≤ t)
    {r r' : Nat} (at_r : reads r = true) (past : τ ≤ r)
    (lt : r < r') (quiet : ∀ j, r < j → j < r' → reads j = false) :
    (markCourse fB mark u v w reads ((s₀, b₀), g₀) r').2 =
      pool u w (markCourse fB mark u v w reads ((s₀, b₀), g₀) r).1.1 := by
  have E := mark_eq_thinned fB mark u v w reads s₀ g₀ b₀ τ reg
  have past' : τ ≤ (Thinned.course Beyond.lossStep u v w τ reads ((s₀, 0), g₀) r).1.2 :=
    Eq.subst (motive := fun n => τ ≤ n) (E r).2.2.symm past
  have rule1 : (markCourse fB mark u v w reads ((s₀, b₀), g₀) (r + 1)).2 =
      pool u w (markCourse fB mark u v w reads ((s₀, b₀), g₀) r).1.1 :=
    (E (r + 1)).2.1.trans ((Thinned.rule_read Thinned.lossStep_accrues at_r past').trans
      (congrArg (pool u w) (E r).1.symm))
  obtain ⟨d, hd⟩ := le_dest (Nat.succ_le_of_lt lt)
  have quiet' : ∀ m, m < d → reads (r + 1 + m) = false := fun m hm =>
    quiet (r + 1 + m) (Nat.lt_of_lt_of_le (Nat.lt_succ_self r) (Nat.le_add_right (r + 1) m))
      (Nat.lt_of_lt_of_le (Nat.add_lt_add_left hm (r + 1)) (hd ▸ Nat.le_refl r'))
  have kept := rule_kept_span (f := join select fB) (h := markRead mark u v w) (reads := reads)
    ((s₀, b₀), g₀) (r + 1) d quiet'
  exact ((congrArg (fun n => (markCourse fB mark u v w reads ((s₀, b₀), g₀) n).2) hd).trans kept).trans rule1

/-- **One-span transition from `MiddleMinus`:** for any reading schedule `reads`, starting from
`MiddleMinus` at reading step `r ≥ τ`, at the next reading step `r' > r`, the rule in force is
`pool u w s_r` with `g_{r'}.carrier < g_{r'}.other`. If `s_{r'}.carrier ≤ s_{r'}.other`, the course is
permanently turned-locked and admitted from `r' + 1`; if `s_{r'}.other < s_{r'}.carrier`, it enters
`MiddlePlus` at `r'`. -/
theorem mark_middle_minus_span {B : Type} {fB : CarrierCounts × B → CarrierCounts → B}
    {mark : B → Bool} {u v w : CarrierCounts} {reads : Nat → Bool}
    {s₀ g₀ : CarrierCounts} {b₀ : B} {τ : Nat}
    (reg : ∀ t, mark (markCourse fB mark u v w reads ((s₀, b₀), g₀) t).1.2 = true ↔ τ ≤ t)
    (hc : w.carrier = u.other) (ho : w.other = u.carrier) (strict : u.other < u.carrier)
    {r r' : Nat} (at_r : reads r = true) (past : τ ≤ r)
    (lt : r < r') (quiet : ∀ j, r < j → j < r' → reads j = false) (at_r' : reads r' = true)
    (mm : MiddleMinus ((markCourse fB mark u v w reads ((s₀, b₀), g₀) r).1.1,
      (markCourse fB mark u v w reads ((s₀, b₀), g₀) r).2)) :
    let M := markCourse fB mark u v w reads ((s₀, b₀), g₀)
    ((M r').2 = pool u w (M r).1.1 ∧ (M r').2.carrier < (M r').2.other) ∧
    (((M r').1.1.carrier ≤ (M r').1.1.other →
        ∀ k, Locked (reverse order) disfavours (poolRead u w)
            ((M (r' + 1 + k)).1.1, (M (r' + 1 + k)).2) ∧
          disfavours (M (r' + 1 + k)).2 ∧ admits (M (r' + 1 + k)).1.1 = true) ∧
     ((M r').1.1.other < (M r').1.1.carrier → MiddlePlus ((M r').1.1, (M r').2))) := by
  intro M
  have hRule : (M r').2 = pool u w (M r).1.1 :=
    mark_rule_at_next_read reg at_r past lt quiet
  have hStrict : (M r').2.carrier < (M r').2.other :=
    Eq.subst (motive := fun g : CarrierCounts => g.carrier < g.other) hRule.symm
      ((mirror_strict_disfavours_iff hc ho strict).mpr mm.1)
  refine ⟨⟨hRule, hStrict⟩, fun fewer' => ?_, fun more' => ⟨more', hStrict⟩⟩
  have E := mark_eq_thinned fB mark u v w reads s₀ g₀ b₀ τ reg
  have past' : τ ≤ (Thinned.course Beyond.lossStep u v w τ reads ((s₀, 0), g₀) r').1.2 :=
    Eq.subst (motive := fun n => τ ≤ n) (E r').2.2.symm (Nat.le_trans past (Nat.le_of_lt lt))
  have dis_r' : disfavours (Thinned.course Beyond.lossStep u v w τ reads ((s₀, 0), g₀) r').2 :=
    Eq.subst (motive := disfavours) (E r').2.1 (Nat.le_of_lt hStrict)
  have fewer_r' : (Thinned.course Beyond.lossStep u v w τ reads ((s₀, 0), g₀) r').1.1.carrier ≤
      (Thinned.course Beyond.lossStep u v w τ reads ((s₀, 0), g₀) r').1.1.other :=
    Eq.subst (motive := fun x : CarrierCounts => x.carrier ≤ x.other) (E r').1 fewer'
  have hTurn := (Thinned.turned_iff Thinned.lossStep_accrues hc ho strict at_r' past' dis_r').mpr fewer_r'
  have hDis_r' : disfavours (M r').2 := Nat.le_of_lt hStrict
  have hNext_le : (M (r' + 1)).1.1.carrier ≤ (M (r' + 1)).1.1.other := by
    have hs1 : (M (r' + 1)).1.1 = select (M r').1.1 (M r').2 := by
      have hP := paced_succ (f := join select fB) (h := markRead mark u v w) (reads := reads)
        ((s₀, b₀), g₀) r'
      exact (congrArg (fun q : (CarrierCounts × B) × CarrierCounts => q.1.1) hP).trans
        (congrArg Prod.fst (turn_fst (join select fB) (markRead mark u v w) (reads r') _))
    rw [hs1]
    exact select_keeps_admitted fewer' hDis_r'
  have hAdm := (mark_turned_admits_iff reg hc ho strict at_r' (Nat.le_trans past (Nat.le_of_lt lt))
    fewer').mpr hNext_le
  intro k
  have hk : Locked (reverse order) disfavours (poolRead u w)
      ((M (r' + (1 + k))).1.1, (M (r' + (1 + k))).2) := by
    rw [(E (r' + (1 + k))).1, (E (r' + (1 + k))).2.1]
    exact hTurn k
  have hArith : r' + (1 + k) = r' + 1 + k := (Nat.add_assoc r' 1 k).symm
  have hk' : Locked (reverse order) disfavours (poolRead u w)
      ((M (r' + 1 + k)).1.1, (M (r' + 1 + k)).2) :=
    Eq.subst (motive := fun n => Locked (reverse order) disfavours (poolRead u w)
      ((M n).1.1, (M n).2)) hArith hk
  exact ⟨hk', (hAdm k).1, (hAdm k).2⟩

/-- **One-span transition from `MiddlePlus` (exact dual):** starting from `MiddlePlus` at reading
step `r ≥ τ`, at the next reading step `r' > r`, the rule in force is `pool u w s_r` with
`g_{r'}.other < g_{r'}.carrier`. If `s_{r'}.other ≤ s_{r'}.carrier`, strictness of `g_{r'}` forces
`s_{r'+1}.other < s_{r'+1}.carrier` automatically, locking the course in capture with `admits = false`
from `r' + 1`; if `s_{r'}.carrier < s_{r'}.other`, it flips back into `MiddleMinus` at `r'`. -/
theorem mark_middle_plus_span {B : Type} {fB : CarrierCounts × B → CarrierCounts → B}
    {mark : B → Bool} {u v w : CarrierCounts} {reads : Nat → Bool}
    {s₀ g₀ : CarrierCounts} {b₀ : B} {τ : Nat}
    (reg : ∀ t, mark (markCourse fB mark u v w reads ((s₀, b₀), g₀) t).1.2 = true ↔ τ ≤ t)
    (hc : w.carrier = u.other) (ho : w.other = u.carrier) (strict : u.other < u.carrier)
    {r r' : Nat} (at_r : reads r = true) (past : τ ≤ r)
    (lt : r < r') (quiet : ∀ j, r < j → j < r' → reads j = false) (at_r' : reads r' = true)
    (mp : MiddlePlus ((markCourse fB mark u v w reads ((s₀, b₀), g₀) r).1.1,
      (markCourse fB mark u v w reads ((s₀, b₀), g₀) r).2)) :
    let M := markCourse fB mark u v w reads ((s₀, b₀), g₀)
    ((M r').2 = pool u w (M r).1.1 ∧ (M r').2.other < (M r').2.carrier) ∧
    (((M r').1.1.other ≤ (M r').1.1.carrier →
        ∀ k, Locked order favours (poolRead u w)
            ((M (r' + 1 + k)).1.1, (M (r' + 1 + k)).2) ∧
          admits (M (r' + 1 + k)).1.1 = false) ∧
     ((M r').1.1.carrier < (M r').1.1.other → MiddleMinus ((M r').1.1, (M r').2))) := by
  intro M
  have hRule : (M r').2 = pool u w (M r).1.1 :=
    mark_rule_at_next_read reg at_r past lt quiet
  have hStrict : (M r').2.other < (M r').2.carrier :=
    Eq.subst (motive := fun g : CarrierCounts => g.other < g.carrier) hRule.symm
      ((mirror_strict_favours_iff hc ho strict).mpr mp.1)
  refine ⟨⟨hRule, hStrict⟩, fun more' => ?_, fun fewer' => ⟨fewer', hStrict⟩⟩
  have past' : τ ≤ r' := Nat.le_trans past (Nat.le_of_lt lt)
  have fav' : favours (M r').2 := Nat.le_of_lt hStrict
  have hKept := (mark_kept_iff reg hc ho strict at_r' past' fav').mpr more'
  have hStrictNext : (M (r' + 1)).1.1.other < (M (r' + 1)).1.1.carrier := by
    have hs1 : (M (r' + 1)).1.1 = select (M r').1.1 (M r').2 := by
      have hP := paced_succ (f := join select fB) (h := markRead mark u v w) (reads := reads)
        ((s₀, b₀), g₀) r'
      exact (congrArg (fun q : (CarrierCounts × B) × CarrierCounts => q.1.1) hP).trans
        (congrArg Prod.fst (turn_fst (join select fB) (markRead mark u v w) (reads r') _))
    rw [hs1]
    show (M r').1.1.other * (M r').2.other < (M r').1.1.carrier * (M r').2.carrier
    exact Nat.lt_of_lt_of_le
      (Nat.mul_lt_mul_of_pos_left hStrict (M r').1.1.other_pos)
      (Nat.mul_le_mul_right (M r').2.carrier more')
  have hLockOut := mark_kept_locks_out reg hc ho strict at_r' past' fav' more' hStrictNext
  intro k
  have hArith : r' + (1 + k) = r' + 1 + k := (Nat.add_assoc r' 1 k).symm
  exact ⟨Eq.subst (motive := fun n => Locked order favours (poolRead u w) ((M n).1.1, (M n).2))
      hArith (hKept k),
    Eq.subst (motive := fun n => admits (M n).1.1 = false) hArith (hLockOut k)⟩

theorem nat_even_or_odd : ∀ n : Nat, (∃ m, n = 2 * m) ∨ (∃ m, n = 2 * m + 1)
  | 0 => Or.inl ⟨0, rfl⟩
  | n + 1 => match nat_even_or_odd n with
    | Or.inl ⟨m, h⟩ => Or.inr ⟨m, congrArg (· + 1) h⟩
    | Or.inr ⟨m, h⟩ => Or.inl ⟨m + 1, by rw [h]; rfl⟩

theorem seq_ge_zero {seq : Nat → Nat} (hInc : ∀ n, seq n < seq (n + 1)) :
    ∀ n, seq 0 ≤ seq n
  | 0 => Nat.le_refl _
  | n + 1 => Nat.le_trans (seq_ge_zero hInc n) (Nat.le_of_lt (hInc n))

theorem nat_le_of_two_mul_le_two_mul_succ {a b : Nat} (h : 2 * a ≤ 2 * b + 1) : a ≤ b :=
  match Nat.lt_or_ge b a with
  | .inl lt =>
    have h1 : 2 * b + 2 ≤ 2 * a := by
      have h2 := Nat.mul_le_mul_left 2 (Nat.succ_le_of_lt lt)
      exact Eq.subst (motive := fun n => n ≤ 2 * a) (rfl : 2 * (b + 1) = 2 * b + 2) h2
    absurd (Nat.le_trans h1 h) (Nat.not_le_of_gt (Nat.lt_succ_self (2 * b + 1)))
  | .inr le => le

theorem nat_le_of_two_mul_succ_le_two_mul_succ_succ {a b : Nat} (h : 2 * a + 1 ≤ 2 * b + 2) : a ≤ b :=
  match Nat.lt_or_ge b a with
  | .inl lt =>
    have h1 : 2 * b + 3 ≤ 2 * a + 1 := by
      have h2 := Nat.add_le_add_right (Nat.mul_le_mul_left 2 (Nat.succ_le_of_lt lt)) 1
      exact Eq.subst (motive := fun n => n ≤ 2 * a + 1)
        (rfl : 2 * (b + 1) + 1 = 2 * b + 3) h2
    absurd (Nat.le_trans h1 h) (Nat.not_le_of_gt (Nat.lt_succ_self (2 * b + 2)))
  | .inr le => le

theorem nat_le_of_two_mul_le_two_mul {a b : Nat} (h : 2 * a ≤ 2 * b) : a ≤ b :=
  nat_le_of_two_mul_le_two_mul_succ (Nat.le_trans h (Nat.le_succ (2 * b)))

/-- **Multi-reading alternation trichotomy:** starting from `MiddleMinus` at the first reading step
`seq 0 ≥ τ` of a reading sequence `seq`, for every `n : Nat` the course has either:
1. absorbed into permanent Turned Lock at some odd reading index `2 * m + 1 ≤ n`, or
2. absorbed into permanent Capture Lock at some even reading index `2 * m + 2 ≤ n`, or
3. strictly alternated between `MiddleMinus` (even `2 * m ≤ n`) and `MiddlePlus` (odd `2 * m + 1 ≤ n`). -/
theorem mark_middle_band_trichotomy {B : Type} {fB : CarrierCounts × B → CarrierCounts → B}
    {mark : B → Bool} {u v w : CarrierCounts} {reads : Nat → Bool}
    {s₀ g₀ : CarrierCounts} {b₀ : B} {τ : Nat}
    (reg : ∀ t, mark (markCourse fB mark u v w reads ((s₀, b₀), g₀) t).1.2 = true ↔ τ ≤ t)
    (hc : w.carrier = u.other) (ho : w.other = u.carrier) (strict : u.other < u.carrier)
    (seq : Nat → Nat) (hStart : τ ≤ seq 0) (hInc : ∀ n, seq n < seq (n + 1))
    (hReads : ∀ n, reads (seq n) = true)
    (hQuiet : ∀ n j, seq n < j → j < seq (n + 1) → reads j = false)
    (mm0 : MiddleMinus ((markCourse fB mark u v w reads ((s₀, b₀), g₀) (seq 0)).1.1,
      (markCourse fB mark u v w reads ((s₀, b₀), g₀) (seq 0)).2)) :
    let M := markCourse fB mark u v w reads ((s₀, b₀), g₀)
    ∀ n : Nat,
      (∃ m, 2 * m + 1 ≤ n ∧
          ∀ k, Locked (reverse order) disfavours (poolRead u w)
              ((M (seq (2 * m + 1) + 1 + k)).1.1, (M (seq (2 * m + 1) + 1 + k)).2) ∧
            disfavours (M (seq (2 * m + 1) + 1 + k)).2 ∧
            admits (M (seq (2 * m + 1) + 1 + k)).1.1 = true) ∨
      (∃ m, 2 * m + 2 ≤ n ∧
          ∀ k, Locked order favours (poolRead u w)
              ((M (seq (2 * m + 2) + 1 + k)).1.1, (M (seq (2 * m + 2) + 1 + k)).2) ∧
            admits (M (seq (2 * m + 2) + 1 + k)).1.1 = false) ∨
      ((∀ m, 2 * m ≤ n → MiddleMinus ((M (seq (2 * m))).1.1, (M (seq (2 * m))).2)) ∧
       (∀ m, 2 * m + 1 ≤ n → MiddlePlus ((M (seq (2 * m + 1))).1.1, (M (seq (2 * m + 1))).2))) := by
  intro M n
  induction n with
  | zero =>
    refine Or.inr (Or.inr ⟨fun m hm => ?_, fun m hm => ?_⟩)
    · match m with
      | 0 => exact mm0
      | m + 1 => exact absurd hm (Nat.not_le_of_gt (Nat.zero_lt_succ (2 * m + 1)))
    · exact absurd hm (Nat.not_le_of_gt (Nat.zero_lt_succ (2 * m)))
  | succ n ih =>
    match ih with
    | Or.inl ⟨m, hle, hLock⟩ => exact Or.inl ⟨m, Nat.le_succ_of_le hle, hLock⟩
    | Or.inr (Or.inl ⟨m, hle, hLock⟩) => exact Or.inr (Or.inl ⟨m, Nat.le_succ_of_le hle, hLock⟩)
    | Or.inr (Or.inr ⟨hEven, hOdd⟩) =>
      match nat_even_or_odd n with
      | Or.inl ⟨m, hn⟩ =>
        have hle_n : 2 * m ≤ n := Nat.le_of_eq hn.symm
        have mm : MiddleMinus ((M (seq (2 * m))).1.1, (M (seq (2 * m))).2) := hEven m hle_n
        have hSpan := mark_middle_minus_span reg hc ho strict
          (hReads (2 * m)) (Nat.le_trans hStart (seq_ge_zero hInc (2 * m)))
          (hInc (2 * m)) (hQuiet (2 * m)) (hReads (2 * m + 1)) mm
        match Nat.lt_or_ge (M (seq (2 * m + 1))).1.1.other (M (seq (2 * m + 1))).1.1.carrier with
        | .inl hMore =>
          have mpNext : MiddlePlus ((M (seq (2 * m + 1))).1.1, (M (seq (2 * m + 1))).2) :=
            hSpan.2.2 hMore
          refine Or.inr (Or.inr ⟨fun m' hm' => ?_, fun m' hm' => ?_⟩)
          · have hle' : 2 * m' ≤ 2 * m + 1 := hn ▸ hm'
            exact hEven m' (hn ▸ Nat.mul_le_mul_left 2 (nat_le_of_two_mul_le_two_mul_succ hle'))
          · have hle' : 2 * m' + 1 ≤ 2 * m + 1 := hn ▸ hm'
            have hmle : m' ≤ m := nat_le_of_two_mul_le_two_mul_succ (Nat.le_trans (Nat.le_succ (2 * m')) hle')
            match Nat.eq_or_lt_of_le hmle with
            | .inl heq => exact heq ▸ mpNext
            | .inr hlt =>
              have hle_prev : 2 * m' + 1 ≤ n := by
                rw [hn]
                have h2 := Nat.mul_le_mul_left 2 (Nat.succ_le_of_lt hlt)
                exact Nat.le_trans (Nat.le_succ _) (Eq.subst (motive := fun k => k ≤ 2 * m)
                  (rfl : 2 * (m' + 1) = 2 * m' + 2) h2)
              exact hOdd m' hle_prev
        | .inr hFewer =>
          exact Or.inl ⟨m, hn ▸ Nat.le_refl (2 * m + 1), hSpan.2.1 hFewer⟩
      | Or.inr ⟨m, hn⟩ =>
        have hle_n : 2 * m + 1 ≤ n := Nat.le_of_eq hn.symm
        have mp : MiddlePlus ((M (seq (2 * m + 1))).1.1, (M (seq (2 * m + 1))).2) := hOdd m hle_n
        have hSpan := mark_middle_plus_span reg hc ho strict
          (hReads (2 * m + 1)) (Nat.le_trans hStart (seq_ge_zero hInc (2 * m + 1)))
          (hInc (2 * m + 1)) (hQuiet (2 * m + 1)) (hReads (2 * m + 2)) mp
        match Nat.lt_or_ge (M (seq (2 * m + 2))).1.1.carrier (M (seq (2 * m + 2))).1.1.other with
        | .inl hFewer =>
          have mmNext : MiddleMinus ((M (seq (2 * m + 2))).1.1, (M (seq (2 * m + 2))).2) :=
            hSpan.2.2 hFewer
          refine Or.inr (Or.inr ⟨fun m' hm' => ?_, fun m' hm' => ?_⟩)
          · have hle' : 2 * m' ≤ 2 * m + 2 := Eq.subst (motive := fun k => 2 * m' ≤ k + 1) hn hm'
            have hmle : m' ≤ m + 1 := nat_le_of_two_mul_le_two_mul
              (Eq.subst (motive := fun k => 2 * m' ≤ k) (rfl : 2 * m + 2 = 2 * (m + 1)) hle')
            match Nat.eq_or_lt_of_le hmle with
            | .inl heq => exact heq ▸ mmNext
            | .inr hlt =>
              have hle_prev : 2 * m' ≤ n := by
                rw [hn]
                exact Nat.le_trans (Nat.mul_le_mul_left 2 (Nat.le_of_lt_succ hlt)) (Nat.le_succ (2 * m))
              exact hEven m' hle_prev
          · have hle' : 2 * m' + 1 ≤ 2 * m + 2 := Eq.subst (motive := fun k => 2 * m' + 1 ≤ k + 1) hn hm'
            have hmle : m' ≤ m := nat_le_of_two_mul_succ_le_two_mul_succ_succ hle'
            exact hOdd m' (Eq.subst (motive := fun k => 2 * m' + 1 ≤ k) hn.symm
              (Nat.add_le_add_right (Nat.mul_le_mul_left 2 hmle) 1))
        | .inr hMore =>
          exact Or.inr (Or.inl ⟨m, hn ▸ Nat.le_refl (2 * m + 2), hSpan.2.1 hMore⟩)

/-- **Order monotonicity of one selection step.** -/
theorem select_order_mono {s₁ s₂ g₁ g₂ : CarrierCounts} (hs : order.le s₁ s₂) (hg : order.le g₁ g₂) :
    order.le (select s₁ g₁) (select s₂ g₂) :=
  select_mono hs hg

/-- **Order preservation along the post-registration paced pool.** -/
theorem paced_post_order_mono {u w : CarrierCounts} (hc : w.carrier = u.other)
    (ho : w.other = u.carrier) (strict : u.other < u.carrier) (reads : Nat → Bool)
    {s₁ s₂ g₁ g₂ : CarrierCounts} (hs : order.le s₁ s₂) (hg : order.le g₁ g₂) (k : Nat) :
    order.le (paced select (poolRead u w) reads (s₁, g₁) k).1
        (paced select (poolRead u w) reads (s₂, g₂) k).1 ∧
      order.le (paced select (poolRead u w) reads (s₁, g₁) k).2
        (paced select (poolRead u w) reads (s₂, g₂) k).2 :=
  order_kept (fun _ _ _ _ => select_order_mono) (pool_reads (mirror_le hc ho strict)) hs hg k

/-- **Order preservation across two post-registration `markCourse` runs.** -/
theorem mark_post_order_mono {B₁ B₂ : Type}
    {fB₁ : CarrierCounts × B₁ → CarrierCounts → B₁}
    {fB₂ : CarrierCounts × B₂ → CarrierCounts → B₂}
    {mark₁ : B₁ → Bool} {mark₂ : B₂ → Bool}
    {u v w : CarrierCounts} {reads : Nat → Bool}
    {s₀₁ g₀₁ s₀₂ g₀₂ : CarrierCounts} {b₀₁ : B₁} {b₀₂ : B₂} {τ r₀ : Nat}
    (reg₁ : ∀ t, mark₁ (markCourse fB₁ mark₁ u v w reads ((s₀₁, b₀₁), g₀₁) t).1.2 = true ↔ τ ≤ t)
    (reg₂ : ∀ t, mark₂ (markCourse fB₂ mark₂ u v w reads ((s₀₂, b₀₂), g₀₂) t).1.2 = true ↔ τ ≤ t)
    (hc : w.carrier = u.other) (ho : w.other = u.carrier) (strict : u.other < u.carrier)
    (past : τ ≤ r₀)
    (hs : order.le (markCourse fB₁ mark₁ u v w reads ((s₀₁, b₀₁), g₀₁) r₀).1.1
      (markCourse fB₂ mark₂ u v w reads ((s₀₂, b₀₂), g₀₂) r₀).1.1)
    (hg : order.le (markCourse fB₁ mark₁ u v w reads ((s₀₁, b₀₁), g₀₁) r₀).2
      (markCourse fB₂ mark₂ u v w reads ((s₀₂, b₀₂), g₀₂) r₀).2)
    {r' : Nat} (hle : r₀ ≤ r') :
    order.le (markCourse fB₁ mark₁ u v w reads ((s₀₁, b₀₁), g₀₁) r').1.1
        (markCourse fB₂ mark₂ u v w reads ((s₀₂, b₀₂), g₀₂) r').1.1 ∧
      order.le (markCourse fB₁ mark₁ u v w reads ((s₀₁, b₀₁), g₀₁) r').2
        (markCourse fB₂ mark₂ u v w reads ((s₀₂, b₀₂), g₀₂) r').2 := by
  obtain ⟨k, hk⟩ := le_dest hle
  rw [hk]
  have E₁ := mark_eq_thinned fB₁ mark₁ u v w reads s₀₁ g₀₁ b₀₁ τ reg₁
  have E₂ := mark_eq_thinned fB₂ mark₂ u v w reads s₀₂ g₀₂ b₀₂ τ reg₂
  have past₁ : τ ≤ (Thinned.course Beyond.lossStep u v w τ reads ((s₀₁, 0), g₀₁) r₀).1.2 :=
    Eq.subst (motive := fun n => τ ≤ n) (E₁ r₀).2.2.symm past
  have past₂ : τ ≤ (Thinned.course Beyond.lossStep u v w τ reads ((s₀₂, 0), g₀₂) r₀).1.2 :=
    Eq.subst (motive := fun n => τ ≤ n) (E₂ r₀).2.2.symm past
  have P₁ := Thinned.past_course (u := u) (v := v) (w := w) (reads := reads)
    Thinned.lossStep_accrues past₁ k
  have P₂ := Thinned.past_course (u := u) (v := v) (w := w) (reads := reads)
    Thinned.lossStep_accrues past₂ k
  have eq₁ : ((markCourse fB₁ mark₁ u v w reads ((s₀₁, b₀₁), g₀₁) (r₀ + k)).1.1,
        (markCourse fB₁ mark₁ u v w reads ((s₀₁, b₀₁), g₀₁) (r₀ + k)).2) =
      paced select (poolRead u w) (fun j => reads (r₀ + j))
        ((markCourse fB₁ mark₁ u v w reads ((s₀₁, b₀₁), g₀₁) r₀).1.1,
         (markCourse fB₁ mark₁ u v w reads ((s₀₁, b₀₁), g₀₁) r₀).2) k := by
    rw [(E₁ (r₀ + k)).1, (E₁ (r₀ + k)).2.1, (E₁ r₀).1, (E₁ r₀).2.1]
    exact P₁
  have eq₂ : ((markCourse fB₂ mark₂ u v w reads ((s₀₂, b₀₂), g₀₂) (r₀ + k)).1.1,
        (markCourse fB₂ mark₂ u v w reads ((s₀₂, b₀₂), g₀₂) (r₀ + k)).2) =
      paced select (poolRead u w) (fun j => reads (r₀ + j))
        ((markCourse fB₂ mark₂ u v w reads ((s₀₂, b₀₂), g₀₂) r₀).1.1,
         (markCourse fB₂ mark₂ u v w reads ((s₀₂, b₀₂), g₀₂) r₀).2) k := by
    rw [(E₂ (r₀ + k)).1, (E₂ (r₀ + k)).2.1, (E₂ r₀).1, (E₂ r₀).2.1]
    exact P₂
  have hMono := paced_post_order_mono hc ho strict (fun j => reads (r₀ + j)) hs hg k
  exact ⟨Eq.subst (motive := fun p : CarrierCounts × CarrierCounts =>
      order.le p.1 (markCourse fB₂ mark₂ u v w reads ((s₀₂, b₀₂), g₀₂) (r₀ + k)).1.1) eq₁.symm
      (Eq.subst (motive := fun q : CarrierCounts × CarrierCounts =>
        order.le (paced select (poolRead u w) (fun j => reads (r₀ + j))
          ((markCourse fB₁ mark₁ u v w reads ((s₀₁, b₀₁), g₀₁) r₀).1.1,
           (markCourse fB₁ mark₁ u v w reads ((s₀₁, b₀₁), g₀₁) r₀).2) k).1 q.1) eq₂.symm hMono.1),
    Eq.subst (motive := fun p : CarrierCounts × CarrierCounts =>
      order.le p.2 (markCourse fB₂ mark₂ u v w reads ((s₀₂, b₀₂), g₀₂) (r₀ + k)).2) eq₁.symm
      (Eq.subst (motive := fun q : CarrierCounts × CarrierCounts =>
        order.le (paced select (poolRead u w) (fun j => reads (r₀ + j))
          ((markCourse fB₁ mark₁ u v w reads ((s₀₁, b₀₁), g₀₁) r₀).1.1,
           (markCourse fB₁ mark₁ u v w reads ((s₀₁, b₀₁), g₀₁) r₀).2) k).2 q.2) eq₂.symm hMono.2)⟩

/-- **Monotone partition across ordered post-registration courses:** where course 1 is not above
course 2 in share and rule at `r₀ ≥ τ`, at every later step `r' ≥ r₀`, turned lock of course 2
implies turned lock of course 1, and capture lock of course 1 implies capture lock of course 2. -/
theorem mark_middle_band_monotone_partition {B₁ B₂ : Type}
    {fB₁ : CarrierCounts × B₁ → CarrierCounts → B₁}
    {fB₂ : CarrierCounts × B₂ → CarrierCounts → B₂}
    {mark₁ : B₁ → Bool} {mark₂ : B₂ → Bool}
    {u v w : CarrierCounts} {reads : Nat → Bool}
    {s₀₁ g₀₁ s₀₂ g₀₂ : CarrierCounts} {b₀₁ : B₁} {b₀₂ : B₂} {τ r₀ : Nat}
    (reg₁ : ∀ t, mark₁ (markCourse fB₁ mark₁ u v w reads ((s₀₁, b₀₁), g₀₁) t).1.2 = true ↔ τ ≤ t)
    (reg₂ : ∀ t, mark₂ (markCourse fB₂ mark₂ u v w reads ((s₀₂, b₀₂), g₀₂) t).1.2 = true ↔ τ ≤ t)
    (hc : w.carrier = u.other) (ho : w.other = u.carrier) (strict : u.other < u.carrier)
    (past : τ ≤ r₀)
    (hs : order.le (markCourse fB₁ mark₁ u v w reads ((s₀₁, b₀₁), g₀₁) r₀).1.1
      (markCourse fB₂ mark₂ u v w reads ((s₀₂, b₀₂), g₀₂) r₀).1.1)
    (hg : order.le (markCourse fB₁ mark₁ u v w reads ((s₀₁, b₀₁), g₀₁) r₀).2
      (markCourse fB₂ mark₂ u v w reads ((s₀₂, b₀₂), g₀₂) r₀).2)
    {r' : Nat} (hle : r₀ ≤ r') :
    let M₁ := markCourse fB₁ mark₁ u v w reads ((s₀₁, b₀₁), g₀₁)
    let M₂ := markCourse fB₂ mark₂ u v w reads ((s₀₂, b₀₂), g₀₂)
    (((M₂ r').1.1.carrier ≤ (M₂ r').1.1.other ∧ disfavours (M₂ r').2) →
      ((M₁ r').1.1.carrier ≤ (M₁ r').1.1.other ∧ disfavours (M₁ r').2)) ∧
    (((M₁ r').1.1.other ≤ (M₁ r').1.1.carrier ∧ favours (M₁ r').2) →
      ((M₂ r').1.1.other ≤ (M₂ r').1.1.carrier ∧ favours (M₂ r').2)) := by
  intro M₁ M₂
  obtain ⟨hs', hg'⟩ := mark_post_order_mono reg₁ reg₂ hc ho strict past hs hg hle
  constructor
  · intro ⟨hTurn₂, hDis₂⟩
    have hChain : (M₁ r').1.1.carrier * (M₂ r').1.1.other ≤ (M₁ r').1.1.other * (M₂ r').1.1.other :=
      Nat.le_trans hs'
        (Nat.le_trans (Nat.mul_le_mul_right (M₁ r').1.1.other hTurn₂)
          (Nat.le_of_eq (Nat.mul_comm (M₂ r').1.1.other (M₁ r').1.1.other)))
    exact ⟨Nat.le_of_mul_le_mul_right hChain (M₂ r').1.1.other_pos, lower hg' hDis₂⟩
  · intro ⟨hCap₁, hFav₁⟩
    have hChain : (M₂ r').1.1.other * (M₁ r').1.1.other ≤ (M₂ r').1.1.carrier * (M₁ r').1.1.other :=
      Nat.le_trans (Nat.le_trans (Nat.mul_le_mul_left (M₂ r').1.1.other hCap₁)
        (Nat.le_of_eq (Nat.mul_comm (M₂ r').1.1.other (M₁ r').1.1.carrier))) hs'
    exact ⟨Nat.le_of_mul_le_mul_right hChain (M₁ r').1.1.other_pos, upper hg' hFav₁⟩

end MiddleBand

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

/-! ## Part A.4b: four separating witnesses in the middle band -/

/-- Periodic two-step reading cadence `false, true, false, true, ...`. -/
def cadence2 : Nat → Bool
  | 0 => false
  | 1 => true
  | n + 2 => cadence2 n

theorem cadence2_mod (j : Nat) : cadence2 (2 * j) = false ∧ cadence2 (2 * j + 1) = true := by
  induction j with
  | zero => exact ⟨rfl, rfl⟩
  | succ j ih =>
    have h0 : 2 * (j + 1) = 2 * j + 2 := rfl
    have h1 : 2 * j + 2 + 1 = (2 * j + 1) + 2 := Nat.add_right_comm (2 * j) 2 1
    rw [h0, h1]
    exact ⟨ih.1, ih.2⟩

/-- `cadence2` aligns with the end of every two-step span `2 * j ≤ t < 2 * (j + 1)`
(`Becoming.PacedStock.ReadAtSpanEnd`). -/
theorem cadence2_readAtSpanEnd : PacedStock.ReadAtSpanEnd (fun j => 2 * j) cadence2 := by
  intro j t hle hlt
  obtain ⟨m, hm⟩ := le_dest hle
  rw [hm]
  match m with
  | 0 =>
    refine ⟨fun h => absurd h (fun e => Bool.noConfusion ((cadence2_mod j).1.symm.trans e)),
      fun h => absurd h (Nat.ne_of_lt (Nat.add_lt_add_left (by decide : 0 + 1 < 2) (2 * j)))⟩
  | 1 => exact ⟨fun _ => rfl, fun _ => (cadence2_mod j).2⟩
  | m + 2 =>
    have hlt' : 2 * j + (m + 2) < 2 * j + 2 := hm ▸ hlt
    exact absurd (Naturals.lt_of_add_lt_add_left hlt') (Nat.not_lt_of_ge (Nat.le_add_left 2 m))

theorem wEndo_stepStock_safe_ge {x : Nat} (hx : 6 ≤ x) : wEndo.stepStock x .safe = x := by
  obtain ⟨d, hd⟩ := le_dest hx
  rw [hd]
  have hblt : Nat.blt (6 + d) 6 = false :=
    ListTests.false_iff_not.mpr (fun h => Nat.not_le_of_gt (CoreHelpers.natBlt_true_iff.mp h) (Nat.le_add_right 6 d))
  show (if Nat.blt (6 + d) 6 = true then 0 else (6 + d - 1) + endoRenew (6 + d - 1)) = 6 + d
  rw [if_neg (fun h => Bool.noConfusion (hblt.symm.trans h))]
  have hsub : 6 + d - 1 = 5 + d := by
    show 6 + d - 1 = 5 + d
    rw [Nat.add_comm 6 d]
    show d + (5 + 1) - 1 = 5 + d
    rw [← Nat.add_assoc, Naturals.add_sub_cancel, Nat.add_comm]
  rw [hsub]
  have hren : endoRenew (5 + d) = 1 := if_pos (Nat.le_add_right 5 d)
  rw [hren, Nat.add_assoc, Nat.add_comm d 1, ← Nat.add_assoc]

theorem emergentRace_stabilizes_from (others : Nat) (hpos : 0 < others) (reads : Nat → Bool) (T : Nat)
    (hRes : (emergentRace wEndo others hpos reads T).1.2.2.phase = .resolved)
    (hPos : ∀ i, (emergentRace wEndo others hpos reads T).1.2.2.pos i = endoPostPos i)
    (hCrit : wEndo.xCrit ≤ (emergentRace wEndo others hpos reads T).1.2.1)
    (hAdm : ∀ k, admits (emergentRace wEndo others hpos reads (T + k)).1.1 = true) :
    ∀ k, (emergentRace wEndo others hpos reads (T + k)).1.2.1 =
        (emergentRace wEndo others hpos reads T).1.2.1 ∧
      (emergentRace wEndo others hpos reads (T + k)).1.2.2.phase = .resolved ∧
      (∀ i, (emergentRace wEndo others hpos reads (T + k)).1.2.2.pos i = endoPostPos i) ∧
      emergentLoop.act (emergentRace wEndo others hpos reads (T + k)).1.2.2 = .safe
  | 0 => by
    have hWeighedExt : Weighting.weighed emergenceItems
        (emergentRace wEndo others hpos reads T).1.2.2.pos cExt =
        Weighting.weighed emergenceItems endoPostPos cExt :=
      total_congr (fun i => by show cond (cExt i) _ 0 = cond (cExt i) _ 0; rw [hPos i]) emergenceItems
    have hWeighedSafe : Weighting.weighed emergenceItems
        (emergentRace wEndo others hpos reads T).1.2.2.pos cSafe =
        Weighting.weighed emergenceItems endoPostPos cSafe :=
      total_congr (fun i => by show cond (cSafe i) _ 0 = cond (cSafe i) _ 0; rw [hPos i]) emergenceItems
    have hSel : selectByOrder (emergentRace wEndo others hpos reads T).1.2.2.pos = .safe := by
      dsimp only [selectByOrder]; rw [hWeighedExt, hWeighedSafe]; rfl
    have hAct : emergentLoop.act (emergentRace wEndo others hpos reads T).1.2.2 = .safe := by
      show emergentAct (emergentRace wEndo others hpos reads T).1.2.2 = .safe
      dsimp only [emergentAct]; rw [hRes, hSel]
    exact ⟨rfl, hRes, hPos, hAct⟩
  | k + 1 => by
    obtain ⟨hx, hph, hpos', hact⟩ := emergentRace_stabilizes_from others hpos reads T hRes hPos hCrit hAdm k
    have hStepEq : (emergentRace wEndo others hpos reads (T + (k + 1))).1.2 =
        gatedStep wEndo emergentLoop (admits (emergentRace wEndo others hpos reads (T + k)).1.1)
          (emergentRace wEndo others hpos reads (T + k)).1.2 := by
      have hG := race_stock_is_gated wEndo emergentLoop registers hi Second.oneToOne lo reads
        ⟨1, others, hpos⟩ hi 14
      rw [hG (T + (k + 1)), hG (T + k)]
      rfl
    have hxStep : (emergentRace wEndo others hpos reads (T + (k + 1))).1.2.1 =
        (emergentRace wEndo others hpos reads T).1.2.1 := by
      rw [congrArg Prod.fst hStepEq]
      show wEndo.stepStock (emergentRace wEndo others hpos reads (T + k)).1.2.1
          (gate (admits (emergentRace wEndo others hpos reads (T + k)).1.1)
            (emergentLoop.act (emergentRace wEndo others hpos reads (T + k)).1.2.2)) =
        (emergentRace wEndo others hpos reads T).1.2.1
      rw [hAdm k, hact, gate]
      exact (wEndo_stepStock_safe_ge (hx ▸ hCrit)).trans hx
    have hph' : (emergentRace wEndo others hpos reads (T + (k + 1))).1.2.2.phase = .resolved := by
      rw [congrArg Prod.snd hStepEq]
      show nextPhase (emergentRace wEndo others hpos reads (T + k)).1.2.2.phase _ _ = .resolved
      rw [hph]; rfl
    have hpos'' : ∀ i, (emergentRace wEndo others hpos reads (T + (k + 1))).1.2.2.pos i = endoPostPos i := by
      intro i
      rw [congrArg Prod.snd hStepEq]
      show (emergentRace wEndo others hpos reads (T + k)).1.2.2.pos i +
          cond (emergentPulse (emergentRace wEndo others hpos reads (T + k)).1.2.2 _ i) 2 0 = endoPostPos i
      have hpulse : ∀ y, emergentPulse (emergentRace wEndo others hpos reads (T + k)).1.2.2 y i = false :=
        fun y => by cases i <;> dsimp only [emergentPulse] <;> rw [hph]
      rw [hpulse _, hpos' i]; rfl
    have hWeighedExt : Weighting.weighed emergenceItems
        (emergentRace wEndo others hpos reads (T + (k + 1))).1.2.2.pos cExt =
        Weighting.weighed emergenceItems endoPostPos cExt :=
      total_congr (fun i => by show cond (cExt i) _ 0 = cond (cExt i) _ 0; rw [hpos'' i]) emergenceItems
    have hWeighedSafe : Weighting.weighed emergenceItems
        (emergentRace wEndo others hpos reads (T + (k + 1))).1.2.2.pos cSafe =
        Weighting.weighed emergenceItems endoPostPos cSafe :=
      total_congr (fun i => by show cond (cSafe i) _ 0 = cond (cSafe i) _ 0; rw [hpos'' i]) emergenceItems
    have hSel : selectByOrder (emergentRace wEndo others hpos reads (T + (k + 1))).1.2.2.pos = .safe := by
      dsimp only [selectByOrder]; rw [hWeighedExt, hWeighedSafe]; rfl
    have hact' : emergentLoop.act (emergentRace wEndo others hpos reads (T + (k + 1))).1.2.2 = .safe := by
      show emergentAct (emergentRace wEndo others hpos reads (T + (k + 1))).1.2.2 = .safe
      dsimp only [emergentAct]; rw [hph', hSel]
    exact ⟨hxStep, hph', hpos'', hact'⟩

def wMiddleLockRace := emergentRace wEndo 17 (Nat.zero_lt_succ 16) (fun _ => true)
def wMiddleAlt5Race := emergentRace wEndo 18 (Nat.zero_lt_succ 17) (fun _ => true)
def wMiddleAlt3Race := emergentRace wEndo 19 (Nat.zero_lt_succ 18) (fun _ => true)
def wMiddleSpanRecoveryRace := emergentRace wEndo 61 (Nat.zero_lt_succ 60) cadence2

/-- **Middle-band exit to capture lock (`race_middle_exits_to_lock`):** `others = 17`, `wEndo`,
every-step reading. Registers from `4`, enters `MiddleMinus` at `4`, flips to `MiddlePlus` at `5`,
exits into Capture Lock at `6`, and is permanently capture-locked with `admits = false` from `7`,
breaching `stock 8 = 3 < 6` and `stock 9 = 0 < 6`. -/
theorem race_middle_exits_to_lock :
    (∀ t, registers (wMiddleLockRace t).1.2.2 = true ↔ 4 ≤ t) ∧
    MiddleMinus ((wMiddleLockRace 4).1.1, (wMiddleLockRace 4).2) ∧
    MiddlePlus ((wMiddleLockRace 5).1.1, (wMiddleLockRace 5).2) ∧
    ((wMiddleLockRace 6).1.1.other ≤ (wMiddleLockRace 6).1.1.carrier ∧ favours (wMiddleLockRace 6).2) ∧
    (∀ k, Locked order favours (poolRead hi lo) ((wMiddleLockRace (7 + k)).1.1, (wMiddleLockRace (7 + k)).2) ∧
      admits (wMiddleLockRace (7 + k)).1.1 = false) ∧
    (wMiddleLockRace 8).1.2.1 = 3 ∧
    (wMiddleLockRace 9).1.2.1 = 0 ∧
    (wMiddleLockRace 8).1.2.1 < wEndo.xCrit ∧
    (wMiddleLockRace 9).1.2.1 < wEndo.xCrit := by
  have hReg : ∀ t, registers (wMiddleLockRace t).1.2.2 = true ↔ 4 ≤ t :=
    reg4_of_race wEndo 17 _ _ rfl rfl rfl rfl rfl
  have hMM4 : MiddleMinus ((wMiddleLockRace 4).1.1, (wMiddleLockRace 4).2) :=
    ⟨CoreHelpers.natBlt_true_iff.mp rfl, CoreHelpers.natBlt_true_iff.mp rfl⟩
  have hSpan45 := mark_middle_minus_span hReg hi_lo_hc hi_lo_ho hi_strict
    (r := 4) (r' := 5) rfl (Nat.le_refl 4) (by decide) (fun _ h1 h2 => absurd h1 (Nat.not_lt_of_ge (Nat.le_of_lt_succ h2))) rfl hMM4
  have hMP5 : MiddlePlus ((wMiddleLockRace 5).1.1, (wMiddleLockRace 5).2) :=
    hSpan45.2.2 (CoreHelpers.natBlt_true_iff.mp rfl)
  have hSpan56 := mark_middle_plus_span hReg hi_lo_hc hi_lo_ho hi_strict
    (r := 5) (r' := 6) rfl (by decide : 4 ≤ 5) (by decide) (fun _ h1 h2 => absurd h1 (Nat.not_lt_of_ge (Nat.le_of_lt_succ h2))) rfl hMP5
  have hMore6 : (wMiddleLockRace 6).1.1.other ≤ (wMiddleLockRace 6).1.1.carrier :=
    Nat.le_of_ble_eq_true rfl
  have hCap6 : (wMiddleLockRace 6).1.1.other ≤ (wMiddleLockRace 6).1.1.carrier ∧ favours (wMiddleLockRace 6).2 :=
    ⟨hMore6, Nat.le_of_lt hSpan56.1.2⟩
  have hLock7 := hSpan56.2.1 hMore6
  have hAdmFalse : ∀ k, admits (wMiddleLockRace (5 + k)).1.1 = false
    | 0 => rfl
    | 1 => rfl
    | k + 2 => by
      have hArith : (7 + k : Nat) = 5 + (k + 2) := by
        rw [Nat.add_comm 5 (k + 2), Nat.add_assoc k 2 5, Nat.add_comm 2 5, ← Nat.add_assoc, Nat.add_comm k 7]
      exact Eq.subst (motive := fun n => admits (wMiddleLockRace n).1.1 = false) hArith (hLock7 k).2
  have hStock8 : (wMiddleLockRace 8).1.2.1 = 3 := by
    change (emergentRace wEndo 17 (Nat.zero_lt_succ 16) (fun _ => true) 8).1.2.1 = 3
    rw [race_stock_is_gated]
    have h5 : (5 + 3 : Nat) = 8 := rfl
    rw [← h5, lockout_pure_extract wEndo emergentLoop _ 14 5 (fun k hk => by
      obtain ⟨j, hj⟩ := le_dest hk; rw [hj]; exact hAdmFalse j) 3]
    rw [← race_stock_is_gated]
    rfl
  have hStock9 : (wMiddleLockRace 9).1.2.1 = 0 := by
    change (emergentRace wEndo 17 (Nat.zero_lt_succ 16) (fun _ => true) 9).1.2.1 = 0
    rw [race_stock_is_gated]
    have h5 : (5 + 4 : Nat) = 9 := rfl
    rw [← h5, lockout_pure_extract wEndo emergentLoop _ 14 5 (fun k hk => by
      obtain ⟨j, hj⟩ := le_dest hk; rw [hj]; exact hAdmFalse j) 4]
    rw [← race_stock_is_gated]
    rfl
  exact ⟨hReg, hMM4, hMP5, hCap6, hLock7, hStock8, hStock9,
    hStock8 ▸ (by decide : 3 < 6), hStock9 ▸ (by decide : 0 < 6)⟩

/-- **Five-step alternation turning and surviving (`race_middle_alternates_and_turns`):** `others = 18`,
`wEndo`, every-step reading. Registers from `4`, alternates `4: MiddleMinus`, `5: MiddlePlus`,
`6: MiddleMinus`, `7: MiddlePlus`, `8: MiddleMinus`, turns permanently from `9` (and `Locked` from `10`),
losing reserve across temporary lockouts (`admits 5 = false`, `admits 7 = false`, `stock 4 = 10`,
`stock 8 = 6`), yet stays at `stock = 6 ≥ wEndo.xCrit` forever. -/
theorem race_middle_alternates_and_turns :
    (∀ t, registers (wMiddleAlt5Race t).1.2.2 = true ↔ 4 ≤ t) ∧
    MiddleMinus ((wMiddleAlt5Race 4).1.1, (wMiddleAlt5Race 4).2) ∧
    MiddlePlus ((wMiddleAlt5Race 5).1.1, (wMiddleAlt5Race 5).2) ∧
    MiddleMinus ((wMiddleAlt5Race 6).1.1, (wMiddleAlt5Race 6).2) ∧
    MiddlePlus ((wMiddleAlt5Race 7).1.1, (wMiddleAlt5Race 7).2) ∧
    MiddleMinus ((wMiddleAlt5Race 8).1.1, (wMiddleAlt5Race 8).2) ∧
    (∀ k, disfavours (wMiddleAlt5Race (9 + k)).2 ∧ admits (wMiddleAlt5Race (9 + k)).1.1 = true) ∧
    (∀ k, Locked (reverse order) disfavours (poolRead hi lo)
      ((wMiddleAlt5Race (10 + k)).1.1, (wMiddleAlt5Race (10 + k)).2)) ∧
    admits (wMiddleAlt5Race 5).1.1 = false ∧
    admits (wMiddleAlt5Race 7).1.1 = false ∧
    (wMiddleAlt5Race 4).1.2.1 = 10 ∧
    (wMiddleAlt5Race 8).1.2.1 = 6 ∧
    (∀ t, wEndo.xCrit ≤ (wMiddleAlt5Race t).1.2.1) ∧
    (∀ t, 8 ≤ t → (wMiddleAlt5Race t).1.2.1 = 6) := by
  have hReg : ∀ t, registers (wMiddleAlt5Race t).1.2.2 = true ↔ 4 ≤ t :=
    reg4_of_race wEndo 18 _ _ rfl rfl rfl rfl rfl
  have hMM4 : MiddleMinus ((wMiddleAlt5Race 4).1.1, (wMiddleAlt5Race 4).2) :=
    ⟨CoreHelpers.natBlt_true_iff.mp rfl, CoreHelpers.natBlt_true_iff.mp rfl⟩
  have hMP5 : MiddlePlus ((wMiddleAlt5Race 5).1.1, (wMiddleAlt5Race 5).2) :=
    (mark_middle_minus_span hReg hi_lo_hc hi_lo_ho hi_strict (r := 4) (r' := 5) rfl (Nat.le_refl 4)
      (by decide) (fun _ h1 h2 => absurd h1 (Nat.not_lt_of_ge (Nat.le_of_lt_succ h2))) rfl hMM4).2.2
      (CoreHelpers.natBlt_true_iff.mp rfl)
  have hMM6 : MiddleMinus ((wMiddleAlt5Race 6).1.1, (wMiddleAlt5Race 6).2) :=
    (mark_middle_plus_span hReg hi_lo_hc hi_lo_ho hi_strict (r := 5) (r' := 6) rfl (by decide : 4 ≤ 5)
      (by decide) (fun _ h1 h2 => absurd h1 (Nat.not_lt_of_ge (Nat.le_of_lt_succ h2))) rfl hMP5).2.2
      (CoreHelpers.natBlt_true_iff.mp rfl)
  have hMP7 : MiddlePlus ((wMiddleAlt5Race 7).1.1, (wMiddleAlt5Race 7).2) :=
    (mark_middle_minus_span hReg hi_lo_hc hi_lo_ho hi_strict (r := 6) (r' := 7) rfl (by decide : 4 ≤ 6)
      (by decide) (fun _ h1 h2 => absurd h1 (Nat.not_lt_of_ge (Nat.le_of_lt_succ h2))) rfl hMM6).2.2
      (CoreHelpers.natBlt_true_iff.mp rfl)
  have hMM8 : MiddleMinus ((wMiddleAlt5Race 8).1.1, (wMiddleAlt5Race 8).2) :=
    (mark_middle_plus_span hReg hi_lo_hc hi_lo_ho hi_strict (r := 7) (r' := 8) rfl (by decide : 4 ≤ 7)
      (by decide) (fun _ h1 h2 => absurd h1 (Nat.not_lt_of_ge (Nat.le_of_lt_succ h2))) rfl hMP7).2.2
      (CoreHelpers.natBlt_true_iff.mp rfl)
  have hSpan89 := mark_middle_minus_span hReg hi_lo_hc hi_lo_ho hi_strict (r := 8) (r' := 9) rfl (by decide : 4 ≤ 8)
    (by decide) (fun _ h1 h2 => absurd h1 (Nat.not_lt_of_ge (Nat.le_of_lt_succ h2))) rfl hMM8
  have hFewer8 : (wMiddleAlt5Race 8).1.1.carrier ≤ (wMiddleAlt5Race 8).1.1.other := Nat.le_of_lt hMM8.1
  have hFewer9 : (wMiddleAlt5Race 9).1.1.carrier ≤ (wMiddleAlt5Race 9).1.1.other := Nat.le_of_ble_eq_true rfl
  have hTurn9 := (mark_turned_admits_iff hReg hi_lo_hc hi_lo_ho hi_strict (r := 8) rfl
    (by decide : 4 ≤ 8) hFewer8).mpr hFewer9
  have hLock10 : ∀ k, Locked (reverse order) disfavours (poolRead hi lo)
      ((wMiddleAlt5Race (10 + k)).1.1, (wMiddleAlt5Race (10 + k)).2) :=
    fun k => (hSpan89.2.1 hFewer9 k).1
  have hAdm5 : admits (wMiddleAlt5Race 5).1.1 = false := by
    show Nat.ble (wMiddleAlt5Race 5).1.1.carrier (wMiddleAlt5Race 5).1.1.other = false
    exact ListTests.false_iff_not.mpr (fun h => Nat.not_le_of_gt hMP5.1 (Nat.le_of_ble_eq_true h))
  have hAdm7 : admits (wMiddleAlt5Race 7).1.1 = false := by
    show Nat.ble (wMiddleAlt5Race 7).1.1.carrier (wMiddleAlt5Race 7).1.1.other = false
    exact ListTests.false_iff_not.mpr (fun h => Nat.not_le_of_gt hMP7.1 (Nat.le_of_ble_eq_true h))
  have hAdm8 : admits (wMiddleAlt5Race 8).1.1 = true := Nat.ble_eq_true_of_le hFewer8
  have hAdm8Plus : ∀ k, admits (wMiddleAlt5Race (8 + k)).1.1 = true
    | 0 => hAdm8
    | k + 1 => by
      have hArith : 8 + (k + 1) = 9 + k := by
        rw [← Nat.add_assoc, Nat.add_comm 8 k, Nat.add_assoc k 8 1, Nat.add_comm k 9]
      rw [hArith]; exact (hTurn9 k).2
  have hStab := emergentRace_stabilizes_from 18 (Nat.zero_lt_succ 17) (fun _ => true) 8
    rfl (fun i => by cases i <;> rfl) (by decide : 6 ≤ 6) hAdm8Plus
  have hGe8 : ∀ t, 8 ≤ t → (wMiddleAlt5Race t).1.2.1 = 6 := by
    intro t ht
    obtain ⟨k, hk⟩ := le_dest ht
    rw [hk]
    change (emergentRace wEndo 18 (Nat.zero_lt_succ 17) (fun _ => true) (8 + k)).1.2.1 = 6
    rw [(hStab k).1]
    rfl
  have hCritAll : ∀ t, wEndo.xCrit ≤ (wMiddleAlt5Race t).1.2.1 := by
    intro t
    match Nat.lt_or_ge t 8 with
    | .inl hlt =>
      match t with
      | 0 => exact by decide
      | 1 => exact by decide
      | 2 => exact by decide
      | 3 => exact by decide
      | 4 => exact by decide
      | 5 => exact by decide
      | 6 => exact by decide
      | 7 => exact by decide
      | t + 8 => exact absurd hlt (Nat.not_lt_of_ge (Nat.le_add_left 8 t))
    | .inr hge => rw [hGe8 t hge]; exact Nat.le_refl 6
  exact ⟨hReg, hMM4, hMP5, hMM6, hMP7, hMM8, hTurn9, hLock10, hAdm5, hAdm7, rfl, rfl, hCritAll, hGe8⟩

/-- **Three-step oscillation turning and surviving (`race_middle_short_oscillation_turns`):**
`others = 19`, `wEndo`, every-step reading. Registers from `4`, oscillates `4: MiddleMinus`,
`5: MiddlePlus`, `6: MiddleMinus`, turns permanently from `7` (and `Locked` from `8`), surviving
forever with `8 ≤ stock`. -/
theorem race_middle_short_oscillation_turns :
    (∀ t, registers (wMiddleAlt3Race t).1.2.2 = true ↔ 4 ≤ t) ∧
    MiddleMinus ((wMiddleAlt3Race 4).1.1, (wMiddleAlt3Race 4).2) ∧
    MiddlePlus ((wMiddleAlt3Race 5).1.1, (wMiddleAlt3Race 5).2) ∧
    MiddleMinus ((wMiddleAlt3Race 6).1.1, (wMiddleAlt3Race 6).2) ∧
    (∀ k, disfavours (wMiddleAlt3Race (7 + k)).2 ∧ admits (wMiddleAlt3Race (7 + k)).1.1 = true) ∧
    (∀ k, Locked (reverse order) disfavours (poolRead hi lo)
      ((wMiddleAlt3Race (8 + k)).1.1, (wMiddleAlt3Race (8 + k)).2)) ∧
    (∀ t, 8 ≤ (wMiddleAlt3Race t).1.2.1) ∧
    (∀ t, wEndo.xCrit ≤ (wMiddleAlt3Race t).1.2.1) := by
  have hReg : ∀ t, registers (wMiddleAlt3Race t).1.2.2 = true ↔ 4 ≤ t :=
    reg4_of_race wEndo 19 _ _ rfl rfl rfl rfl rfl
  have hMM4 : MiddleMinus ((wMiddleAlt3Race 4).1.1, (wMiddleAlt3Race 4).2) :=
    ⟨CoreHelpers.natBlt_true_iff.mp rfl, CoreHelpers.natBlt_true_iff.mp rfl⟩
  have hMP5 : MiddlePlus ((wMiddleAlt3Race 5).1.1, (wMiddleAlt3Race 5).2) :=
    (mark_middle_minus_span hReg hi_lo_hc hi_lo_ho hi_strict (r := 4) (r' := 5) rfl (Nat.le_refl 4)
      (by decide) (fun _ h1 h2 => absurd h1 (Nat.not_lt_of_ge (Nat.le_of_lt_succ h2))) rfl hMM4).2.2
      (CoreHelpers.natBlt_true_iff.mp rfl)
  have hMM6 : MiddleMinus ((wMiddleAlt3Race 6).1.1, (wMiddleAlt3Race 6).2) :=
    (mark_middle_plus_span hReg hi_lo_hc hi_lo_ho hi_strict (r := 5) (r' := 6) rfl (by decide : 4 ≤ 5)
      (by decide) (fun _ h1 h2 => absurd h1 (Nat.not_lt_of_ge (Nat.le_of_lt_succ h2))) rfl hMP5).2.2
      (CoreHelpers.natBlt_true_iff.mp rfl)
  have hSpan67 := mark_middle_minus_span hReg hi_lo_hc hi_lo_ho hi_strict (r := 6) (r' := 7) rfl (by decide : 4 ≤ 6)
    (by decide) (fun _ h1 h2 => absurd h1 (Nat.not_lt_of_ge (Nat.le_of_lt_succ h2))) rfl hMM6
  have hFewer6 : (wMiddleAlt3Race 6).1.1.carrier ≤ (wMiddleAlt3Race 6).1.1.other := Nat.le_of_lt hMM6.1
  have hFewer7 : (wMiddleAlt3Race 7).1.1.carrier ≤ (wMiddleAlt3Race 7).1.1.other := Nat.le_of_ble_eq_true rfl
  have hTurn7 := (mark_turned_admits_iff hReg hi_lo_hc hi_lo_ho hi_strict (r := 6) rfl
    (by decide : 4 ≤ 6) hFewer6).mpr hFewer7
  have hLock8 : ∀ k, Locked (reverse order) disfavours (poolRead hi lo)
      ((wMiddleAlt3Race (8 + k)).1.1, (wMiddleAlt3Race (8 + k)).2) :=
    fun k => (hSpan67.2.1 hFewer7 k).1
  have hAdm6Plus : ∀ k, admits (wMiddleAlt3Race (6 + k)).1.1 = true
    | 0 => Nat.ble_eq_true_of_le hFewer6
    | k + 1 => by
      have hArith : 6 + (k + 1) = 7 + k := by
        rw [← Nat.add_assoc, Nat.add_comm 6 k, Nat.add_assoc k 6 1, Nat.add_comm k 7]
      rw [hArith]; exact (hTurn7 k).2
  have hStab := emergentRace_stabilizes_from 19 (Nat.zero_lt_succ 18) (fun _ => true) 6
    rfl (fun i => by cases i <;> rfl) (by decide : 6 ≤ 8) hAdm6Plus
  have hAll8 : ∀ t, 8 ≤ (wMiddleAlt3Race t).1.2.1 := by
    intro t
    match Nat.lt_or_ge t 6 with
    | .inl hlt =>
      match t with
      | 0 => exact by decide
      | 1 => exact by decide
      | 2 => exact by decide
      | 3 => exact by decide
      | 4 => exact by decide
      | 5 => exact by decide
      | t + 6 => exact absurd hlt (Nat.not_lt_of_ge (Nat.le_add_left 6 t))
    | .inr hge =>
      obtain ⟨k, hk⟩ := le_dest hge
      rw [hk]
      change 8 ≤ (emergentRace wEndo 19 (Nat.zero_lt_succ 18) (fun _ => true) (6 + k)).1.2.1
      rw [(hStab k).1]
      exact Nat.le_refl 8
  exact ⟨hReg, hMM4, hMP5, hMM6, hTurn7, hLock8, hAll8, fun t => Nat.le_trans (by decide : 6 ≤ 8) (hAll8 t)⟩

/-- **Multi-step span recovery (`race_middle_span_recovery_turns`):** `others = 61`, `wEndo`,
cadence `cadence2`. Registers from `4`, enters `MiddleMinus` at reading step `r = 5`, overshoots at
quiet step `6` (`admits 6 = false`, strictly outside `mark_turned_admits_iff` at `r = 5`), yet
recovers within the quiet span (`c_7 ≤ o_7` at `r' = 7`) and locks turned with `admits = true` from `8`,
surviving forever with `8 ≤ stock` (`≥ wEndo.xCrit = 6`). -/
theorem race_middle_span_recovery_turns :
    (∀ t, registers (wMiddleSpanRecoveryRace t).1.2.2 = true ↔ 4 ≤ t) ∧
    MiddleMinus ((wMiddleSpanRecoveryRace 5).1.1, (wMiddleSpanRecoveryRace 5).2) ∧
    admits (wMiddleSpanRecoveryRace 6).1.1 = false ∧
    (wMiddleSpanRecoveryRace 7).1.1.carrier ≤ (wMiddleSpanRecoveryRace 7).1.1.other ∧
    (∀ k, Locked (reverse order) disfavours (poolRead hi lo)
        ((wMiddleSpanRecoveryRace (8 + k)).1.1, (wMiddleSpanRecoveryRace (8 + k)).2) ∧
      disfavours (wMiddleSpanRecoveryRace (8 + k)).2 ∧
      admits (wMiddleSpanRecoveryRace (8 + k)).1.1 = true) ∧
    (∀ t, 8 ≤ (wMiddleSpanRecoveryRace t).1.2.1) ∧
    (∀ t, wEndo.xCrit ≤ (wMiddleSpanRecoveryRace t).1.2.1) := by
  have hReg : ∀ t, registers (wMiddleSpanRecoveryRace t).1.2.2 = true ↔ 4 ≤ t :=
    reg4_of_race wEndo 61 _ cadence2 rfl rfl rfl rfl rfl
  have hMM5 : MiddleMinus ((wMiddleSpanRecoveryRace 5).1.1, (wMiddleSpanRecoveryRace 5).2) :=
    ⟨CoreHelpers.natBlt_true_iff.mp rfl, CoreHelpers.natBlt_true_iff.mp rfl⟩
  have hQuiet57 : ∀ j, 5 < j → j < 7 → cadence2 j = false := by
    intro j hj1 hj2
    have h6 : j = 6 := Nat.le_antisymm (Nat.le_of_lt_succ hj2) (Nat.succ_le_of_lt hj1)
    rw [h6]; rfl
  have hSpan57 := mark_middle_minus_span hReg hi_lo_hc hi_lo_ho hi_strict
    (r := 5) (r' := 7) rfl (by decide : 4 ≤ 5) (by decide) hQuiet57 rfl hMM5
  have hOut6 : admits (wMiddleSpanRecoveryRace 6).1.1 = false := rfl
  have hFewer7 : (wMiddleSpanRecoveryRace 7).1.1.carrier ≤ (wMiddleSpanRecoveryRace 7).1.1.other :=
    Nat.le_of_ble_eq_true rfl
  have hLock8 := hSpan57.2.1 hFewer7
  have hAdm7Plus : ∀ k, admits (wMiddleSpanRecoveryRace (7 + k)).1.1 = true
    | 0 => Nat.ble_eq_true_of_le hFewer7
    | k + 1 => by
      have hArith : 7 + (k + 1) = 8 + k := by
        rw [← Nat.add_assoc, Nat.add_comm 7 k, Nat.add_assoc k 7 1, Nat.add_comm k 8]
      rw [hArith]; exact (hLock8 k).2.2
  have hStab := emergentRace_stabilizes_from 61 (Nat.zero_lt_succ 60) cadence2 7
    rfl (fun i => by cases i <;> rfl) (by decide : 6 ≤ 8) hAdm7Plus
  have hAll8 : ∀ t, 8 ≤ (wMiddleSpanRecoveryRace t).1.2.1 := by
    intro t
    match Nat.lt_or_ge t 7 with
    | .inl hlt =>
      match t with
      | 0 => exact by decide
      | 1 => exact by decide
      | 2 => exact by decide
      | 3 => exact by decide
      | 4 => exact by decide
      | 5 => exact by decide
      | 6 => exact by decide
      | t + 7 => exact absurd hlt (Nat.not_lt_of_ge (Nat.le_add_left 7 t))
    | .inr hge =>
      obtain ⟨k, hk⟩ := le_dest hge
      rw [hk]
      change 8 ≤ (emergentRace wEndo 61 (Nat.zero_lt_succ 60) cadence2 (7 + k)).1.2.1
      rw [(hStab k).1]
      exact Nat.le_refl 8
  exact ⟨hReg, hMM5, hOut6, hFewer7, hLock8, hAll8, fun t => Nat.le_trans (by decide : 6 ≤ 8) (hAll8 t)⟩

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
