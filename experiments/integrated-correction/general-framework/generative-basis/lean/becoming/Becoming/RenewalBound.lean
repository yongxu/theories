import Becoming.Recurrence
import Becoming.Renewal

/-!
# Renewal recurs where activity without renewal descends

The configurations are those of one continuing process. `unrenewed` compares successive
configurations during activity without renewal; it does not split an agent from an independent
environment. Well-foundedness is an explicit certificate that such activity cannot continue
indefinitely; its realization is not proved here. A natural-number rank is one possible
certificate, not a universal stock, cost or ethical measure. `renewal n` concerns the step from
`n` to `n + 1`.

* **No tail without renewal.** At an accessible configuration no infinite unrenewed tail starts
  (`no_unrenewed_tail_of_accessible`); where every step without renewal descends a well-founded
  relation, no tail is free of renewal (`no_renewal_free_tail`). This needs no decision of the
  renewal event. The core's `Run.renewal_recurs` is its case of a natural-number rank.
* **Renewal recurs arbitrarily late** where each step is a renewal or descends
  (`renewal_after_of_accessible`, `renewal_arbitrarily_late`), in particular where the renewal
  event is decided (`renewal_arbitrarily_late_of_decidable`). With a rank, it comes within the
  rank: from `start`, within `bound + 1` steps where the rank there is at most `bound`
  (`renewal_within_rank_bound`, `renewal_within_rank_plus_one_steps`).
* **Along a run** renewal is the run's step belonging to a class of steps `renews`
  (`run_no_renewal_free_tail`, `run_renewal_arbitrarily_late`, `run_renewal_within_rank`).
* **The alternation**, the run of the negation law from `true`, has an actual unrenewed step and a
  restoring step, recurs with period two through one restoring form and passes through no
  configuration but its first two, so every score of configurations is bounded along it: renewal
  recurring arbitrarily late does not give unbounded novelty or complexity measured by any fixed
  score of configurations.

Ported from `ContinuationRenewal`, with the join `DescentRenewalRuns` (F3J, 18 October 2026): the
periphery's alternating sequence is the run of the negation law (`alternation`), so its theorems
and the join's are one set here. The decided cases take the decision as a hypothesis. No ethical
predicate, ranking or axiom occurs; every declaration has an empty axiom report.
-/

namespace Becoming

open Generative

universe u v

namespace RenewalBound

/-! ## Any sequence of configurations -/

/-- **An accessible configuration admits no infinite unrenewed tail.** -/
theorem no_unrenewed_tail_of_accessible {State : Type u} {unrenewed : State → State → Prop}
    {states : Nat → State} {a : State} (accessible : Acc unrenewed a) :
    ∀ start, states start = a → ¬ (∀ n, start ≤ n → unrenewed (states (n + 1)) (states n)) := by
  induction accessible with
  | intro a _ inductionHypothesis =>
      intro start atStart tail
      have next : unrenewed (states (start + 1)) a := atStart ▸ tail start (Nat.le_refl start)
      exact inductionHypothesis _ next (start + 1) rfl
        (fun n afterNext => tail n (Nat.le_trans (Nat.le_succ start) afterNext))

/-- **No tail is free of renewal** where every step without renewal descends a well-founded
relation. The renewal event is not decided. -/
theorem no_renewal_free_tail {State : Type u} {unrenewed : State → State → Prop}
    (wellFounded : WellFounded unrenewed) (states : Nat → State) (renewal : Nat → Prop)
    (decreases : ∀ n, ¬ renewal n → unrenewed (states (n + 1)) (states n)) (start : Nat) :
    ¬ (∀ n, start ≤ n → ¬ renewal n) :=
  fun absent => no_unrenewed_tail_of_accessible (wellFounded.apply (states start)) start rfl
    (fun n afterStart => decreases n (absent n afterStart))

/-- **Renewal comes after an accessible configuration** where each step is a renewal or
descends. -/
theorem renewal_after_of_accessible {State : Type u} {unrenewed : State → State → Prop}
    {states : Nat → State} {renewal : Nat → Prop}
    (step : ∀ n, renewal n ∨ unrenewed (states (n + 1)) (states n)) {a : State}
    (accessible : Acc unrenewed a) : ∀ start, states start = a → ∃ n, start ≤ n ∧ renewal n := by
  induction accessible with
  | intro a _ inductionHypothesis =>
      intro start atStart
      cases step start with
      | inl renewed => exact ⟨start, Nat.le_refl start, renewed⟩
      | inr descending =>
          have next : unrenewed (states (start + 1)) a := atStart ▸ descending
          match inductionHypothesis _ next (start + 1) rfl with
          | ⟨n, afterNext, renewed⟩ =>
            exact ⟨n, Nat.le_trans (Nat.le_succ start) afterNext, renewed⟩

theorem renewal_arbitrarily_late {State : Type u} {unrenewed : State → State → Prop}
    (wellFounded : WellFounded unrenewed) (states : Nat → State) (renewal : Nat → Prop)
    (step : ∀ n, renewal n ∨ unrenewed (states (n + 1)) (states n)) :
    ∀ start, ∃ n, start ≤ n ∧ renewal n :=
  fun start => renewal_after_of_accessible step (wellFounded.apply (states start)) start rfl

/-- **Renewal recurs arbitrarily late where the renewal event is decided.** -/
theorem renewal_arbitrarily_late_of_decidable {State : Type u} {unrenewed : State → State → Prop}
    (wellFounded : WellFounded unrenewed) (states : Nat → State) (renewal : Nat → Prop)
    (decision : ∀ n, Decidable (renewal n))
    (decreases : ∀ n, ¬ renewal n → unrenewed (states (n + 1)) (states n)) :
    ∀ start, ∃ n, start ≤ n ∧ renewal n :=
  renewal_arbitrarily_late wellFounded states renewal fun n => match decision n with
    | .isTrue renewed => .inl renewed
    | .isFalse absent => .inr (decreases n absent)

/-- **Renewal within the rank bound**: the interval includes `start` and `start + bound`, so
`bound + 1` steps. -/
theorem renewal_within_rank_bound (rank : Nat → Nat) (renewal : Nat → Prop)
    (decision : ∀ n, Decidable (renewal n)) (decreases : ∀ n, ¬ renewal n → rank (n + 1) < rank n) :
    ∀ bound start, rank start ≤ bound → ∃ n, start ≤ n ∧ n ≤ start + bound ∧ renewal n
  | 0, start, rankBound => match decision start with
    | .isTrue renewed => ⟨start, Nat.le_refl start, Nat.le_refl start, renewed⟩
    | .isFalse absent =>
      absurd (Nat.lt_of_lt_of_le (decreases start absent) rankBound) (Nat.not_lt_zero _)
  | bound + 1, start, rankBound => match decision start with
    | .isTrue renewed => ⟨start, Nat.le_refl start, Nat.le_add_right start (bound + 1), renewed⟩
    | .isFalse absent =>
      match renewal_within_rank_bound rank renewal decision decreases bound (start + 1)
          (Nat.le_of_lt_succ (Nat.lt_of_lt_of_le (decreases start absent) rankBound)) with
      | ⟨n, afterNext, within, event⟩ =>
        ⟨n, Nat.le_trans (Nat.le_succ start) afterNext, (Nat.add_right_comm start 1 bound) ▸ within,
          event⟩

theorem renewal_within_rank_plus_one_steps (rank : Nat → Nat) (renewal : Nat → Prop)
    (decision : ∀ n, Decidable (renewal n)) (decreases : ∀ n, ¬ renewal n → rank (n + 1) < rank n)
    (start : Nat) : ∃ n, start ≤ n ∧ n ≤ start + rank start ∧ renewal n :=
  renewal_within_rank_bound rank renewal decision decreases (rank start) start (Nat.le_refl _)

theorem rank_renewal_arbitrarily_late (rank : Nat → Nat) (renewal : Nat → Prop)
    (decision : ∀ n, Decidable (renewal n)) (decreases : ∀ n, ¬ renewal n → rank (n + 1) < rank n) :
    ∀ start, ∃ n, start ≤ n ∧ renewal n :=
  fun start => match renewal_within_rank_plus_one_steps rank renewal decision decreases start with
  | ⟨n, afterStart, _, renewed⟩ => ⟨n, afterStart, renewed⟩

/-! ## Along a run -/

section AnyProcess

variable {S : Type u} {A : Type v} {P : Process S A}

/-- **No run has a tail without renewal, where every step without renewal descends a
well-founded relation.** Renewal is the run's step belonging to the class `renews`. -/
theorem run_no_renewal_free_tail (r : Run P) {renews : S → A → S → Prop}
    {unrenewed : S → S → Prop} (wellFounded : WellFounded unrenewed)
    (decreases : ∀ n, ¬ renews (r.state n) (r.act n) (r.state (n + 1)) →
      unrenewed (r.state (n + 1)) (r.state n)) (start : Nat) :
    ¬ ∀ n, start ≤ n → ¬ renews (r.state n) (r.act n) (r.state (n + 1)) :=
  no_renewal_free_tail wellFounded r.state (fun n => renews (r.state n) (r.act n) (r.state (n + 1)))
    decreases start

/-- **Renewal recurs arbitrarily late along a run** where membership of a step in the class is
decided and every step outside it descends a well-founded relation. -/
theorem run_renewal_arbitrarily_late (r : Run P) {renews : S → A → S → Prop}
    (decision : ∀ s a t, Decidable (renews s a t)) {unrenewed : S → S → Prop}
    (wellFounded : WellFounded unrenewed)
    (decreases : ∀ n, ¬ renews (r.state n) (r.act n) (r.state (n + 1)) →
      unrenewed (r.state (n + 1)) (r.state n)) :
    ∀ start, ∃ n, start ≤ n ∧ renews (r.state n) (r.act n) (r.state (n + 1)) :=
  renewal_arbitrarily_late_of_decidable wellFounded r.state
    (fun n => renews (r.state n) (r.act n) (r.state (n + 1)))
    (fun n => decision (r.state n) (r.act n) (r.state (n + 1))) decreases

/-- **Renewal comes within the rank of the configuration** along a run. -/
theorem run_renewal_within_rank (r : Run P) {renews : S → A → S → Prop}
    (decision : ∀ s a t, Decidable (renews s a t)) (rank : S → Nat)
    (decreases : ∀ n, ¬ renews (r.state n) (r.act n) (r.state (n + 1)) →
      rank (r.state (n + 1)) < rank (r.state n)) (start : Nat) :
    ∃ n, start ≤ n ∧ n ≤ start + rank (r.state start) ∧
      renews (r.state n) (r.act n) (r.state (n + 1)) :=
  renewal_within_rank_plus_one_steps (fun n => rank (r.state n))
    (fun n => renews (r.state n) (r.act n) (r.state (n + 1)))
    (fun n => decision (r.state n) (r.act n) (r.state (n + 1))) decreases start

end AnyProcess

/-! ## The alternation -/

/-- The run of the negation law from `true`: `true` has one available activity step, `false`
requires restoration. -/
def alternation : Run (Law.process Bool.not) := Law.run Bool.not true

/-- The rank of a configuration: one available step at `true`. -/
def rank (b : Bool) : Nat := if b then 1 else 0

/-- Restoration at step `n`: the configuration requiring it. -/
def Restoring (n : Nat) : Prop := alternation.state n = false

/-- Consumption and restoration, the two edges of one process. -/
def AlternatingStep (before after : Bool) : Prop :=
  (before = true ∧ after = false) ∨ (before = false ∧ after = true)

theorem state_succ (n : Nat) : alternation.state (n + 1) = !(alternation.state n) := rfl

/-- **Every step of the alternation is a consuming or a restoring step.** -/
theorem actual_steps (n : Nat) :
    AlternatingStep (alternation.state n) (alternation.state (n + 1)) := by
  show AlternatingStep (alternation.state n) (!(alternation.state n))
  cases alternation.state n
  · exact .inr ⟨rfl, rfl⟩
  · exact .inl ⟨rfl, rfl⟩

/-- **A step without restoration lowers the rank.** -/
theorem nonrestoring_decreases (n : Nat) (absent : ¬ Restoring n) :
    rank (alternation.state (n + 1)) < rank (alternation.state n) := by
  show rank (!(alternation.state n)) < rank (alternation.state n)
  cases state : alternation.state n
  · exact absurd state absent
  · exact Nat.zero_lt_succ 0

/-- **The alternation restores arbitrarily late.** -/
theorem restores_arbitrarily_late : ∀ start, ∃ n, start ≤ n ∧ Restoring n :=
  rank_renewal_arbitrarily_late (fun n => rank (alternation.state n)) Restoring
    (fun n => instDecidableEqBool (alternation.state n) false) nonrestoring_decreases

/-- **The alternation has period two.** -/
theorem period_two (n : Nat) : alternation.state (n + 2) = alternation.state n := by
  show (!(!(alternation.state n))) = alternation.state n
  cases alternation.state n <;> rfl

/-- **Every restoration has the same before and after form.** -/
theorem one_restoring_form (n : Nat) (restoring : Restoring n) :
    alternation.state n = false ∧ alternation.state (n + 1) = true :=
  ⟨restoring, congrArg Bool.not restoring⟩

/-- **Every restoration raises the rank from 0 to 1.** -/
theorem restoration_raises_rank (n : Nat) (restoring : Restoring n) :
    rank (alternation.state n) = 0 ∧ rank (alternation.state (n + 1)) = 1 :=
  match one_restoring_form n restoring with
  | ⟨before, after⟩ => ⟨congrArg rank before, congrArg rank after⟩

/-- **The first step is an actual step without restoration, and it lowers the rank**: the
descent condition is used on an actual edge, not made vacuous by declaring every step a
renewal. -/
theorem unrenewed_first_step :
    ¬ Restoring 0 ∧ rank (alternation.state 1) < rank (alternation.state 0) :=
  ⟨fun impossible => Bool.noConfusion impossible, Nat.zero_lt_succ 0⟩

/-- **The alternation passes through no configuration but its first two.** -/
theorem no_new_configurations (n : Nat) :
    alternation.state n = alternation.state 0 ∨ alternation.state n = alternation.state 1 := by
  cases state : alternation.state n
  · exact .inr rfl
  · exact .inl rfl

/-- **Every score of configurations is bounded along the alternation.** The score is arbitrary;
no measure of life's worth is introduced. -/
theorem every_score_bounded (score : Bool → Nat) :
    ∃ bound, ∀ n, score (alternation.state n) ≤ bound :=
  ⟨score false + score true, fun n => by
    cases alternation.state n
    · exact Nat.le_add_right _ _
    · exact Nat.le_add_left _ _⟩

end RenewalBound

end Becoming
