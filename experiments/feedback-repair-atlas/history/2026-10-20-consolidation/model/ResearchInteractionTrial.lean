import GradualInteractionTrial

/-! A research-informed weighted-evidence candidate, not an empirically fitted
model. Expectation, prior evidence weight (confidence), and explanation credibility
are separate. Direct observations and unverified reports have different updates.
Exact fractions avoid floating-point error and imports outside the existing core.
-/
namespace ResearchInteractionTrial
open Becoming

/-- An exact bounded fraction; equality of values uses cross multiplication. -/
structure Share where
  num : Nat
  den : Nat
  bounded : num ≤ den
  positive : 0 < den

def Same (a b : Share) : Prop := a.num * b.den = b.num * a.den

instance (a b : Share) : Decidable (Same a b) :=
  inferInstanceAs (Decidable (a.num * b.den = b.num * a.den))

def zero : Share := ⟨0, 1, by decide, by decide⟩
def one : Share := ⟨1, 1, by decide, by decide⟩
def half : Share := ⟨1, 2, by decide, by decide⟩
def twoThirds : Share := ⟨2, 3, by decide, by decide⟩

/-- Constructive arithmetic versions, avoiding convenience lemmas with propext. -/
theorem distribute (a b c : Nat) : (a + b) * c = a * c + b * c :=
  (Nat.mul_comm (a + b) c).trans
    ((Nat.left_distrib c a b).trans
      ((congrArg (· + c * b) (Nat.mul_comm c a)).trans
        (congrArg (a * c + ·) (Nat.mul_comm c b))))

theorem swap_factors (a b c : Nat) : a * b * c = a * c * b :=
  (Copying.mul_regroup a b c).trans
    ((congrArg (a * ·) (Nat.mul_comm b c)).trans (Copying.mul_regroup a c b).symm)

/-- A weighted average of two bounded fractions is bounded. The old weight is
positive; the new weight can be zero. -/
theorem weighted_bound (w v : Nat) (p y : Share) :
    w * p.num * y.den + v * y.num * p.den ≤ (w + v) * p.den * y.den := by
  have bound := Nat.add_le_add
    (Nat.mul_le_mul_right y.den (Nat.mul_le_mul_left w p.bounded))
    (Nat.mul_le_mul_right p.den (Nat.mul_le_mul_left v y.bounded))
  have equality : w * p.den * y.den + v * y.den * p.den = (w + v) * p.den * y.den := by
    rw [swap_factors v y.den p.den, ← distribute, ← distribute]
  exact Nat.le_trans bound (Nat.le_of_eq equality)

def weighted (w v : Nat) (positive : 0 < w) (p y : Share) : Share where
  num := w * p.num * y.den + v * y.num * p.den
  den := (w + v) * p.den * y.den
  bounded := weighted_bound w v p y
  positive := Nat.mul_pos (Nat.mul_pos
    (Nat.lt_of_lt_of_le positive (Nat.le_add_right w v)) p.positive) y.positive

/-- Confidence is prior evidence weight for expected constructive behavior.
It is not a measured subjective feeling or an attachment diagnosis. Credibility
concerns the reliability of explanations, not competence or personal worth. -/
structure Belief where
  expectation : Share
  confidence : Nat
  confidencePositive : 0 < confidence
  credibility : Share

inductive Signal where
  | constructive
  | defensive
  | explanation (fresh : Bool)
  | verifiedReliable
  | verifiedMisleading
  | unresolved
  deriving DecidableEq

/-- The stable-environment observation rule is q'=(c*q+y)/(c+1).
A fresh favorable explanation uses weight r, its credibility: q'=(c*q+r)/(c+r).
Unverified explanations do not increase confidence or certify their own source.
Independent verification updates credibility under a separate illustrative rule.
-/
def learn (b : Belief) : Signal → Belief
  | .constructive =>
      ⟨weighted b.confidence 1 b.confidencePositive b.expectation one,
       b.confidence + 1, Nat.zero_lt_succ _, b.credibility⟩
  | .defensive =>
      ⟨weighted b.confidence 1 b.confidencePositive b.expectation zero,
       b.confidence + 1, Nat.zero_lt_succ _, b.credibility⟩
  | .explanation true =>
      ⟨weighted (b.confidence * b.credibility.den) b.credibility.num
        (Nat.mul_pos b.confidencePositive b.credibility.positive) b.expectation one,
       b.confidence, b.confidencePositive, b.credibility⟩
  | .explanation false => b
  | .verifiedReliable =>
      { b with credibility := weighted 1 1 (by decide) b.credibility one }
  | .verifiedMisleading =>
      { b with credibility := weighted 1 1 (by decide) b.credibility zero }
  | .unresolved => b

structure Person where
  belief : Belief
  history : List Signal

/-- The histories retain interpreted evidence, not a complete autobiography. -/
def observe (p : Person) (s : Signal) : Person := ⟨learn p.belief s, s :: p.history⟩

abbrev Joint := Person × Person
abbrev Summary := Belief × Belief

def summary (s : Joint) : Summary := (s.1.belief, s.2.belief)

/-- A policy probe supplies an explicit choice variable. With uniform draws it
could implement a probabilistic policy, but no sampling law or empirical choice
parameter is asserted here. A guarded alternative can be pause rather than attack.
-/
def choose (retaliate : Bool) (probe : Share) (b : Belief) : Signal :=
  if probe.num * b.expectation.den ≤ b.expectation.num * probe.den then .constructive
  else if retaliate then .defensive else .unresolved

inductive Initiative where
  | lapse
  | cooperate
  | explain (fresh : Bool)
  | habitual
  deriving DecidableEq

structure Input where
  initiative : Initiative
  alexProbe : Share
  mayaProbe : Share
  alexRetaliates : Bool
  mayaRetaliates : Bool

structure Turn where
  toAlex : Signal
  toMaya : Signal

/-- Alex acts; Maya updates about Alex, then responds; Alex learns from that
response. His own lapse is not automatically evidence about Maya's behavior. -/
def form (q : Summary) (input : Input) : Turn :=
  let first := match input.initiative with
    | .lapse => Signal.defensive
    | .cooperate => .constructive
    | .explain fresh => .explanation fresh
    | .habitual => choose input.alexRetaliates input.alexProbe q.1
  ⟨choose input.mayaRetaliates input.mayaProbe (learn q.2 first), first⟩

/-- Reuse the core's coupled-whole constructor with a shared exchange. -/
def step (s : Joint) (input : Input) : Joint :=
  wholeNext (fun p t => observe p t.toAlex) (fun p t => observe p t.toMaya)
    (fun x => form (summary x) input) s

def reducedStep (q : Summary) (input : Input) : Summary :=
  wholeNext (fun b t => learn b t.toAlex) (fun b t => learn b t.toMaya)
    (fun x => form x input) q

theorem step_commutes (s : Joint) (input : Input) :
    summary (step s input) = reducedStep (summary s) input := rfl

/-- The richer summary preserves the entire modeled finite interaction sequence. -/
theorem histories_and_summary_agree (plan : List Input) (s : Joint) :
    summary (plan.foldl step s) = plan.foldl reducedStep (summary s) :=
  Readout.foldl_semiconj step summary reducedStep step_commutes plan s

theorem both_histories_retained (s : Joint) (input : Input) :
    (step s input).1.history.tail = s.1.history ∧
    (step s input).2.history.tail = s.2.history := ⟨rfl, rfl⟩

/-- Bound preservation holds for all supplied inputs and histories, not just samples. -/
theorem all_future_expectations_bounded (plan : List Input) (s : Joint) :
    let result := plan.foldl step s
    result.1.belief.expectation.num ≤ result.1.belief.expectation.den ∧
    result.2.belief.expectation.num ≤ result.2.belief.expectation.den :=
  ⟨(plan.foldl step s).1.belief.expectation.bounded,
   (plan.foldl step s).2.belief.expectation.bounded⟩

/-- Directly observed behavior is not discounted because the speaker is unreliable
at explanations. Conversely, it does not automatically certify explanations. -/
theorem direct_lapse_preserves_credibility (b : Belief) :
    (learn b .defensive).credibility = b.credibility := rfl

theorem unverified_explanation_preserves_confidence (b : Belief) :
    (learn b (.explanation true)).confidence = b.confidence := rfl

theorem unverified_explanation_does_not_self_certify (b : Belief) :
    (learn b (.explanation true)).credibility = b.credibility := rfl

/-- A repeated, non-new explanation adds no evidence; the event is still recorded. -/
theorem stale_explanation_no_update (p : Person) :
    (observe p (.explanation false)).belief = p.belief := rfl

/-- Verification of a report need not alter the behavioral expectation. -/
theorem verification_separate_from_behavior (b : Belief) :
    (learn b .verifiedMisleading).expectation = b.expectation ∧
    (learn b .verifiedMisleading).confidence = b.confidence := ⟨rfl, rfl⟩

/-- A synthetic seed, not fitted from any participant or paper. -/
def seed : Person := ⟨⟨half, 2, by decide, half⟩, []⟩

def fromHistory (events : List Signal) : Person := events.foldl observe seed

def shortHistory : Person := fromHistory [.constructive, .constructive]

/-- Longer history: 11 constructive and 3 defensive observations. Both this
history and the short one imply 3/4, but carry different evidence weights. -/
def longHistory : Person := fromHistory
  (List.replicate 11 .constructive ++ List.replicate 3 .defensive)

def lapse : Input := ⟨.lapse, twoThirds, twoThirds, true, true⟩
def habitual : Input := ⟨.habitual, twoThirds, twoThirds, true, true⟩

theorem same_expectation_different_confidence :
    Same shortHistory.belief.expectation ⟨3, 4, by decide, by decide⟩ ∧
    Same longHistory.belief.expectation ⟨3, 4, by decide, by decide⟩ ∧
    shortHistory.belief.confidence = 4 ∧ longHistory.belief.confidence = 16 := by decide

theorem same_lapse_different_updates :
    Same (learn shortHistory.belief .defensive).expectation ⟨3, 5, by decide, by decide⟩ ∧
    Same (learn longHistory.belief .defensive).expectation ⟨12, 17, by decide, by decide⟩ := by decide

/-- Hold Alex and the decision probe fixed; vary only Maya's prior history. -/
theorem maya_history_changes_reply :
    (form (shortHistory.belief, longHistory.belief) lapse).toAlex = .constructive ∧
    (form (shortHistory.belief, shortHistory.belief) lapse).toAlex = .defensive := by decide

theorem maya_history_changes_alex_next_expectation :
    Same (step (shortHistory, longHistory) lapse).1.belief.expectation
      ⟨4, 5, by decide, by decide⟩ ∧
    Same (step (shortHistory, shortHistory) lapse).1.belief.expectation
      ⟨3, 5, by decide, by decide⟩ := by decide

/-- Maya's retaliation need not determine Alex's next response. His own history
can support a constructive next move and a different subsequent exchange. -/
theorem alex_history_can_interrupt_returned_defense :
    (form (summary (step (longHistory, shortHistory) lapse)) habitual).toMaya = .constructive ∧
    Same (step (step (longHistory, shortHistory) lapse) habitual).2.belief.expectation
      twoThirds ∧
    Same (step (step (longHistory, shortHistory) lapse) habitual).1.belief.expectation
      ⟨13, 18, by decide, by decide⟩ := by decide

/-- Guardedness does not logically imply retaliation. The pause gives Alex no new
behavioral evidence, so his expectation stays unchanged in this model. -/
theorem pause_alternative :
    (form (shortHistory.belief, shortHistory.belief) { lapse with mayaRetaliates := false }).toAlex =
      .unresolved ∧
    Same (step (shortHistory, shortHistory) { lapse with mayaRetaliates := false }).1.belief.expectation
      ⟨3, 4, by decide, by decide⟩ := by decide

theorem lower_expectation_can_still_clarify :
    choose true half (learn shortHistory.belief .defensive) = .constructive := by decide

/-- Same behavioral observations, different independently checked report histories. -/
def credibleHistory : Person := fromHistory
  [.constructive, .constructive, .verifiedReliable, .verifiedReliable]

def misleadingHistory : Person := fromHistory
  [.constructive, .constructive, .verifiedMisleading, .verifiedMisleading]

theorem credibility_is_a_separate_dimension :
    Same credibleHistory.belief.expectation ⟨3, 4, by decide, by decide⟩ ∧
    Same misleadingHistory.belief.expectation ⟨3, 4, by decide, by decide⟩ ∧
    credibleHistory.belief.confidence = misleadingHistory.belief.confidence ∧
    Same credibleHistory.belief.credibility ⟨7, 8, by decide, by decide⟩ ∧
    Same misleadingHistory.belief.credibility ⟨1, 8, by decide, by decide⟩ := by decide

theorem direct_lapse_equal_despite_different_credibility :
    Same (learn credibleHistory.belief .defensive).expectation ⟨3, 5, by decide, by decide⟩ ∧
    Same (learn misleadingHistory.belief .defensive).expectation ⟨3, 5, by decide, by decide⟩ := by decide

/-- The identical fresh favorable explanation has a different evidential effect
because prior source credibility differs. Neither explanation independently
establishes honesty, repair, or an absence of personal attack. -/
theorem same_explanation_different_effect :
    Same (learn (learn credibleHistory.belief .defensive) (.explanation true)).expectation
      ⟨31, 47, by decide, by decide⟩ ∧
    Same (learn (learn misleadingHistory.belief .defensive) (.explanation true)).expectation
      ⟨25, 41, by decide, by decide⟩ := by decide

end ResearchInteractionTrial
