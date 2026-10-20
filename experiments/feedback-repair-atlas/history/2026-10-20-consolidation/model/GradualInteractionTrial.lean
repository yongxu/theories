import InteractionHistoryTrial
import Becoming.Copying

/-! A gradual, setback-sensitive extension. Scores count stipulated interpreted
experiences; they are neither measured trust nor probabilities or moral worth.
Thresholds, weights, response policies and evidence reliability remain assumptions.
-/
namespace GradualInteractionTrial
open Becoming

inductive Experience where
  | supporting
  | defensive
  | unresolved
  deriving DecidableEq

abbrev History := List Experience
abbrev Joint := History × History
abbrev View := Nat × Nat
abbrev Turn := InteractionHistoryTrial.Turn

structure Rules where
  conditions : InteractionHistoryTrial.Conditions
  alexThreshold : Nat
  mayaThreshold : Nat
  alexSetback : Nat
  mayaSetback : Nat

/-- Positive evidence adds one; defense subtracts a chosen penalty, floored at zero.
An unresolved experience is retained without changing the tally. -/
def revise (penalty score : Nat) : Experience → Nat
  | .supporting => score + 1
  | .defensive => score - penalty
  | .unresolved => score

/-- Histories are newest first; compute their cumulative interpretation oldest first. -/
def learned (penalty : Nat) : History → Nat
  | [] => 0
  | e :: rest => revise penalty (learned penalty rest) e

def view (r : Rules) (s : Joint) : View :=
  (learned r.alexSetback s.1, learned r.mayaSetback s.2)

inductive Control where
  | habitual
  | clarify
  | defend
  deriving DecidableEq

/-- Maya gives specifics after her threshold. Alex's habitual clarification is
available if either he reaches his threshold or her cue supplies specifics.
Explicit clarify/defend choices allow a deliberate repair or a defensive lapse. -/
def turn (r : Rules) (q : View) (control : Control) : Turn :=
  let specific := decide (r.mayaThreshold ≤ q.2)
  let humble := match control with
    | .habitual => specific || decide (r.alexThreshold ≤ q.1)
    | .clarify => true
    | .defend => false
  ⟨specific, humble⟩

def alexExperience (r : Rules) (t : Turn) : Experience :=
  if t.humble then
    if t.specific && r.conditions.credibleEngagement then .supporting else .unresolved
  else .defensive

def mayaExperience (r : Rules) (t : Turn) : Experience :=
  if t.humble then
    if r.conditions.receptive then .supporting else .unresolved
  else .defensive

def alexUpdate (r : Rules) (h : History) (t : Turn) : History := alexExperience r t :: h

def mayaUpdate (r : Rules) (h : History) (t : Turn) : History := mayaExperience r t :: h

/-- Reuse the core's coupled-whole composition with both people's retained histories. -/
def step (r : Rules) (s : Joint) (control : Control) : Joint :=
  wholeNext (alexUpdate r) (mayaUpdate r) (fun x => turn r (view r x) control) s

def reducedStep (r : Rules) (q : View) (control : Control) : View :=
  let t := turn r q control
  (revise r.alexSetback q.1 (alexExperience r t),
   revise r.mayaSetback q.2 (mayaExperience r t))

theorem step_commutes (r : Rules) (s : Joint) (control : Control) :
    view r (step r s control) = reducedStep r (view r s) control := rfl

/-- Import the core's exact abstraction theorem for all finite interaction plans. -/
theorem histories_and_scores_agree (r : Rules) (plan : List Control) (s : Joint) :
    view r (plan.foldl (step r) s) = plan.foldl (reducedStep r) (view r s) :=
  Readout.foldl_semiconj (step r) (view r) (reducedStep r) (step_commutes r) plan s

theorem both_pasts_retained (r : Rules) (s : Joint) (control : Control) :
    (step r s control).1.tail = s.1 ∧ (step r s control).2.tail = s.2 := ⟨rfl, rfl⟩

/-- Repeated supporting experiences accumulate, with no reset at each exchange. -/
theorem repeated_support (penalty : Nat) (h : History) : ∀ n,
    learned penalty (List.replicate n .supporting ++ h) = learned penalty h + n
  | 0 => rfl
  | n + 1 => by
      change learned penalty (List.replicate n .supporting ++ h) + 1 = learned penalty h + (n + 1)
      rw [repeated_support penalty h n]
      exact Nat.add_assoc _ _ _

/-- In this stipulated weighting, replacing the evidence lost in one lapse restores
its previous tally when there was enough evidence to absorb the penalty. -/
theorem support_can_restore_lapse (penalty : Nat) (h : History)
    (enough : penalty ≤ learned penalty h) :
    learned penalty (List.replicate penalty .supporting ++ (.defensive :: h)) = learned penalty h :=
  (repeated_support penalty (.defensive :: h) penalty).trans (ExchangeLaw.sub_add_back enough)

def DefensiveBasin (r : Rules) (q : View) : Prop :=
  q.1 < r.alexThreshold ∧ q.2 < r.mayaThreshold

/-- A refuted decidable proposition has a false Boolean decision, constructively. -/
theorem decision_false {p : Prop} (d : Decidable p) (refuted : ¬ p) : @decide p d = false := by
  cases d with
  | isTrue h => exact False.elim (refuted h)
  | isFalse _ => rfl

/-- Below both response thresholds, the habitual exchange is defensive. -/
theorem habitual_defense (r : Rules) (q : View) (below : DefensiveBasin r q) :
    reducedStep r q .habitual = (q.1 - r.alexSetback, q.2 - r.mayaSetback) := by
  have noAlex := Nat.not_le_of_lt below.1
  have noMaya := Nat.not_le_of_lt below.2
  have aFalse := decision_false (inferInstance : Decidable (r.alexThreshold ≤ q.1)) noAlex
  have mFalse := decision_false (inferInstance : Decidable (r.mayaThreshold ≤ q.2)) noMaya
  have chosen : turn r q .habitual = (⟨false, false⟩ : Turn) := by
    unfold turn
    rw [aFalse, mFalse]
    rfl
  unfold reducedStep
  rw [chosen]
  rfl

/-- Habit alone cannot leave this basin under the supplied response and update laws. -/
theorem defensive_basin_closed (r : Rules) (q : View) (below : DefensiveBasin r q) :
    DefensiveBasin r (reducedStep r q .habitual) := by
  rw [habitual_defense r q below]
  exact ⟨Nat.lt_of_le_of_lt (Nat.sub_le _ _) below.1,
    Nat.lt_of_le_of_lt (Nat.sub_le _ _) below.2⟩

/-- The basin conclusion holds for any number of habitual exchanges in the full
history model, not just in the reduced description. -/
theorem defensive_basin_forever (r : Rules) (s : Joint) (below : DefensiveBasin r (view r s)) :
    ∀ n, DefensiveBasin r (view r (Law.orbit (fun x => step r x .habitual) s n))
  | 0 => below
  | n + 1 => by
      change DefensiveBasin r (view r (step r (Law.orbit (fun x => step r x .habitual) s n) .habitual))
      rw [step_commutes]
      exact defensive_basin_closed r _ (defensive_basin_forever r s below n)

/-- A forced defensive lapse has the stated cost, whether or not either person
has previously crossed the threshold. -/
theorem lapse_cost (r : Rules) (q : View) :
    reducedStep r q .defend = (q.1 - r.alexSetback, q.2 - r.mayaSetback) := rfl

/-- Sufficient accumulated margins keep both people above their thresholds after
one lapse. This is a general conditional result for arbitrary thresholds/penalties. -/
theorem margins_absorb_lapse (r : Rules) (q : View)
    (alex : r.alexThreshold + r.alexSetback ≤ q.1)
    (maya : r.mayaThreshold + r.mayaSetback ≤ q.2) :
    r.alexThreshold ≤ (reducedStep r q .defend).1 ∧
    r.mayaThreshold ≤ (reducedStep r q .defend).2 :=
  ⟨Copying.le_sub_of_add (Nat.le_trans
      (Nat.le_of_eq (Nat.add_comm r.alexSetback r.alexThreshold)) alex),
   Copying.le_sub_of_add (Nat.le_trans
      (Nat.le_of_eq (Nat.add_comm r.mayaSetback r.mayaThreshold)) maya)⟩

/-- Illustrative weights, not empirically calibrated parameters. -/
def demoRules : Rules := ⟨⟨true, true⟩, 3, 2, 2, 2⟩

/-- Different interpreted histories, initially below both response thresholds. -/
def initial : Joint := ([.defensive], [.unresolved, .defensive])

def after (plan : List Control) : Joint := plan.foldl (step demoRules) initial

def scores (plan : List Control) : View := view demoRules (after plan)

theorem one_good_exchange_is_insufficient :
    scores [.clarify] = (0, 1) ∧
    (turn demoRules (scores [.clarify]) .habitual).humble = false := ⟨rfl, rfl⟩

theorem two_good_exchanges_change_maya : scores [.clarify, .clarify] = (0, 2) := rfl

theorem three_good_exchanges_start_alex_learning :
    scores [.clarify, .clarify, .clarify] = (1, 3) := rfl

theorem five_good_exchanges_cross_both_thresholds :
    scores [.clarify, .clarify, .clarify, .clarify, .clarify] = (3, 5) := rfl

/-- A lapse early in repair can put both people below threshold again. -/
theorem early_lapse : scores [.clarify, .clarify, .clarify, .defend] = (0, 1) := rfl

theorem early_lapse_enters_basin :
    DefensiveBasin demoRules (scores [.clarify, .clarify, .clarify, .defend]) := by
  change 0 < 3 ∧ 1 < 2
  decide

/-- The old loop can then reproduce itself, unless the policy/environment changes. -/
theorem early_lapse_habit_traps : ∀ n,
    DefensiveBasin demoRules (view demoRules (Law.orbit (fun x => step demoRules x .habitual)
      (after [.clarify, .clarify, .clarify, .defend]) n)) :=
  defensive_basin_forever demoRules _ early_lapse_enters_basin

/-- A deliberate repair can leave that basin again; it is not an immutable trait. -/
theorem early_lapse_repair :
    scores [.clarify, .clarify, .clarify, .defend, .clarify, .habitual, .habitual, .habitual] = (3, 5) := rfl

/-- After more shared experience, one lapse still leaves Maya above threshold. -/
theorem buffered_lapse :
    scores [.clarify, .clarify, .clarify, .clarify, .clarify, .defend] = (1, 3) := rfl

/-- Her next specific cue permits a habitual clarifying reply even though Alex's
own tally is below threshold. Two such exchanges restore the preceding scores. -/
theorem buffered_lapse_recovers :
    scores [.clarify, .clarify, .clarify, .clarify, .clarify, .defend, .habitual, .habitual] = (3, 5) := rfl

/-- Closely spaced lapses can undo the buffer. -/
theorem repeated_lapses_remove_buffer :
    scores [.clarify, .clarify, .clarify, .clarify, .clarify, .defend, .defend] = (0, 1) := rfl

/-- A single more damaging event can do so too, under a different assumed weight. -/
theorem larger_setback_counterexample :
    reducedStep { demoRules with alexSetback := 6, mayaSetback := 6 } (3, 5) .defend = (0, 0) := rfl

end GradualInteractionTrial
