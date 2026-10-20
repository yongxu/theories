import FeedbackReadingTrial
import Becoming.Coupling

/-! Two people with retained, different histories. The psychological update rules
below are supplied toy laws. The proved results are conditional on those laws.
False in Alex's history means less expectation of attack; false in Maya's history
means less expectation of dismissal. These are separate role-specific readings,
not quantities of character or a classification of actual people.
-/
namespace InteractionHistoryTrial
open Becoming

/-- Each entry records a learned expectation after an interpreted experience.
Newest first. Older entries are retained. This is not a verbatim life history. -/
abbrev History := List Bool
abbrev Joint := History × History
abbrev View := Bool × Bool

/-- The latest expectation controls this small model; an empty history defaults false.
Sufficiency of this summary is a modeling assumption, not a claim about humans. -/
def expectation : History → Bool
  | [] => false
  | b :: _ => b

def view (s : Joint) : View := (expectation s.1, expectation s.2)

structure Turn where
  specific : Bool
  humble : Bool

/-- Two independent conditions of the proposed repair mechanism.
credibleEngagement is evidence of nonpersonal, reciprocal engagement in this
exchange, not merely a verified task error or a guarantee about hidden motives. -/
structure Conditions where
  receptive : Bool
  credibleEngagement : Bool

/-- Maya is terse when she expects dismissal. Alex's habitual defensive reply
occurs when that terse cue meets his expectation of attack. A supplied deliberate
intervention overrides his reply once. It does not concede fault or deny attack. -/
def turn (deliberate : Bool) (q : View) : Turn :=
  ⟨!q.2, deliberate || !(q.1 && q.2)⟩

/-- Alex's supplied update: defense confirms his threat expectation; clarification
changes it only after specific, credible cooperative engagement. Otherwise he keeps it. -/
def alexAfter (c : Conditions) (old : Bool) (t : Turn) : Bool :=
  if t.humble then
    if t.specific && c.credibleEngagement then false else old
  else true

/-- Maya's supplied update: defense confirms dismissal; a clarifying response
changes her expectation only if she is receptive. Otherwise she keeps it. -/
def mayaAfter (c : Conditions) (old : Bool) (t : Turn) : Bool :=
  if t.humble then
    if c.receptive then false else old
  else true

/-- Both update functions append a new interpretation without deleting the past. -/
def alexUpdate (c : Conditions) (h : History) (t : Turn) : History :=
  alexAfter c (expectation h) t :: h

def mayaUpdate (c : Conditions) (h : History) (t : Turn) : History :=
  mayaAfter c (expectation h) t :: h

/-- Compose the two updates using the core's coupled-whole constructor. -/
def step (c : Conditions) (s : Joint) (deliberate : Bool) : Joint :=
  wholeNext (alexUpdate c) (mayaUpdate c) (fun x => turn deliberate (view x)) s

/-- The higher-level response pattern, abstracted from the retained histories. -/
def reducedStep (c : Conditions) (q : View) (deliberate : Bool) : View :=
  let t := turn deliberate q
  (alexAfter c q.1 t, mayaAfter c q.2 t)

/-- The proposed abstraction is exact for one exchange under these toy laws. -/
theorem step_commutes (c : Conditions) (s : Joint) (deliberate : Bool) :
    view (step c s deliberate) = reducedStep c (view s) deliberate := rfl

/-- Import the existing lifting theorem: the abstraction remains exact for every
finite sequence of deliberate/habitual responses, not just our example trace. -/
theorem histories_and_pattern_agree (c : Conditions) (plan : List Bool) (s : Joint) :
    view (plan.foldl (step c) s) = plan.foldl (reducedStep c) (view s) :=
  Readout.foldl_semiconj (step c) view (reducedStep c) (step_commutes c) plan s

/-- Past records are retained even when the current response pattern changes. -/
theorem both_pasts_retained (c : Conditions) (s : Joint) (deliberate : Bool) :
    (step c s deliberate).1.tail = s.1 ∧ (step c s deliberate).2.tail = s.2 :=
  ⟨rfl, rfl⟩

/-- Alex recalls blame; Maya recalls dismissal despite an earlier constructive
exchange. The Booleans summarize those interpretations in each person's role. -/
def initial : Joint := ([true], [true, false])

/-- Different histories can produce different responses to the same terse cue. -/
theorem alex_history_changes_response :
    (turn false (view ([true], [true]))).humble = false ∧
    (turn false (view ([false], [true]))).humble = true := ⟨rfl, rfl⟩

/-- Maya's history changes the cue Alex receives and thereby his habitual response. -/
theorem maya_history_changes_next :
    (turn false (view ([true], [true]))).humble = false ∧
    (turn false (view ([true], [false]))).humble = true := ⟨rfl, rfl⟩

/-- The current defensive pattern reproduces itself under every setting of the two
repair conditions. The full histories still grow; it is the pattern that repeats. -/
theorem defensive_pattern_repeats (c : Conditions) :
    reducedStep c (true, true) false = (true, true) := rfl

/-- This recurrence persists for any number of habitual exchanges in the full
history model, using the core's orbit and the exact one-step projection. -/
theorem defensive_forever (c : Conditions) : ∀ n,
    view (Law.orbit (fun s => step c s false) initial n) = (true, true)
  | 0 => rfl
  | n + 1 => (step_commutes c _ false).trans
      ((congrArg (fun q => reducedStep c q false) (defensive_forever c n)).trans
        (defensive_pattern_repeats c))

/-- One clarifying reply does not immediately remove Alex's threat expectation:
Maya's initial cue is still terse, so specific credible engagement has not arrived. -/
theorem humility_is_not_instant_reassurance (c : Conditions) :
    (view (step c initial true)).1 = true := rfl

/-- If Maya is receptive, Alex's deliberate clarification changes her next cue. -/
theorem first_repair_changes_maya (c : Conditions) : c.receptive = true →
    view (step c initial true) = (true, false) := by
  cases c with
  | mk r v => cases r <;> cases v <;> decide

/-- In a receptive setting with credible cooperative engagement, the next habitual exchange
reaches the open pattern; continued deliberate override is not required. -/
theorem two_exchange_repair (c : Conditions) :
    c.receptive = true → c.credibleEngagement = true →
    view (step c (step c initial true) false) = (false, false) := by
  cases c with
  | mk r v => cases r <;> cases v <;> decide

/-- The open pattern persists under the supplied laws. No new shocks are modeled. -/
theorem open_pattern_repeats (c : Conditions) :
    reducedStep c (false, false) false = (false, false) := by
  cases c with
  | mk r v => cases r <;> cases v <;> decide

/-- A one-time deliberate reply followed by ordinary replies remains in the open
pattern, provided both stated repair conditions hold. -/
theorem repaired_forever (c : Conditions) (receptive : c.receptive = true)
    (credible : c.credibleEngagement = true) : ∀ n,
    view (Law.orbit (fun s => step c s false) (step c (step c initial true) false) n) =
      (false, false)
  | 0 => two_exchange_repair c receptive credible
  | n + 1 => (step_commutes c _ false).trans
      ((congrArg (fun q => reducedStep c q false) (repaired_forever c receptive credible n)).trans
        (open_pattern_repeats c))

/-- Without Maya's receptivity, even a deliberate clarifying reply can leave the
same defensive pattern. Her response is not under Alex's unilateral control. -/
theorem nonreceptive_counterexample :
    view (step ⟨false, true⟩ initial true) = (true, true) := rfl

/-- Receptivity alone can change the interaction before Alex's expectation changes. -/
theorem no_credible_engagement_counterexample :
    view (step ⟨true, false⟩ (step ⟨true, false⟩ initial true) false) = (true, false) ∧
    (turn false (true, false)).humble = true := ⟨rfl, rfl⟩

/-- Connect the temporal trial to the earlier epistemic proof: a change in this
response pattern supplies no inference that a personal attack did or did not occur. -/
theorem terse_remark_still_underdetermines_attack :
    ¬ ∃ judge, Readout.Judges FeedbackReadingTrial.possibilities
      FeedbackReadingTrial.remark FeedbackReadingTrial.Situation.personalAttack judge :=
  FeedbackReadingTrial.no_attack_judge_from_remark

end InteractionHistoryTrial
