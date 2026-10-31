import FormationRoot

/-!
# Consequence access, template selection and transmitted response structure

A finite next-event correspondence for the existing formation law. Event weights
are explicit local inputs, not derived biological rates. The selected event must
copy one response or leave the two counts unchanged; formation and loss cannot
silently be counted as either. No CTMC, fixation or long-run theorem is claimed.

The two response kinds are the existing repair-capable and alternative chemical
roles. Neither is named good, benevolent or morally correct. Transmission cells
extend the accounting to altered offspring structures; they are not mutations
implemented by the unchanged native law, whose copies retain template kind.
-/

namespace ConsequenceTransmission

/-- Finite integer weights; rational event laws with common denominator can be
represented by rescaling. These are weights of events, not intrinsic fitness. -/
structure Weights where
  copyA : Nat
  copyH : Nat
  unchanged : Nat
  deriving DecidableEq, Repr

def total (w : Weights) : Nat := w.copyA + w.copyH + w.unchanged

/-- Weighted mean A fraction, on the common positive denominator
(total weight) * (a+h) * (a+h+1). -/
def afterNumerator (a h : Nat) (w : Weights) : Nat :=
  (a + h) * (w.copyA * (a + 1) + w.copyH * a) +
    w.unchanged * a * (a + h + 1)

/-- Initial fraction expressed on that SAME denominator. -/
def beforeNumerator (a h : Nat) (w : Weights) : Nat :=
  total w * a * (a + h + 1)

def denominator (a h : Nat) (w : Weights) : Nat :=
  total w * (a + h) * (a + h + 1)

/-- Balanced numerator identity; no subtraction over naturals conceals losses. -/
theorem numerator_balance (a h : Nat) (w : Weights) :
    afterNumerator a h w + w.copyH * a =
      beforeNumerator a h w + w.copyA * h := by
  simp only [afterNumerator, beforeNumerator, total, Nat.mul_add,
    Nat.mul_one, Nat.mul_comm, Nat.mul_left_comm,
    Nat.add_assoc, Nat.add_comm, Nat.add_left_comm]

/-- Algebra holds also on boundaries; the fraction interpretation below needs
positive population and total weight. -/
theorem strict_increase_iff (a h : Nat) (w : Weights) :
    beforeNumerator a h w < afterNumerator a h w ↔ w.copyH * a < w.copyA * h := by
  have balance := numerator_balance a h w
  constructor
  · intro increase
    have h' := Nat.add_lt_add_right increase (w.copyH * a)
    rw [balance] at h'
    exact Nat.lt_of_add_lt_add_left h'
  · intro contrast
    have h' := Nat.add_lt_add_left contrast (beforeNumerator a h w)
    rw [← balance] at h'
    exact Nat.lt_of_add_lt_add_right h'

theorem neutral_iff (a h : Nat) (w : Weights) :
    beforeNumerator a h w = afterNumerator a h w ↔ w.copyH * a = w.copyA * h := by
  have balance := numerator_balance a h w
  constructor
  · intro neutral
    rw [neutral] at balance
    exact Nat.add_left_cancel balance
  · intro neutral
    rw [neutral] at balance
    exact (Nat.add_right_cancel balance).symm

theorem strict_decrease_iff (a h : Nat) (w : Weights) :
    afterNumerator a h w < beforeNumerator a h w ↔ w.copyA * h < w.copyH * a := by
  have balance := numerator_balance a h w
  constructor
  · intro decrease
    have h' := Nat.add_lt_add_right decrease (w.copyH * a)
    rw [balance] at h'
    exact Nat.lt_of_add_lt_add_left h'
  · intro contrast
    have h' := Nat.add_lt_add_left contrast (beforeNumerator a h w)
    rw [← balance] at h'
    exact Nat.lt_of_add_lt_add_right h'

theorem denominator_positive (a h : Nat) (w : Weights)
    (population : 0 < a + h) (events : 0 < total w) : 0 < denominator a h w :=
  Nat.mul_pos (Nat.mul_pos events population) (Nat.zero_lt_succ _)

/-- Shared per-template access can raise actual copy weight while leaving the
expected fraction neutral. Unchanged-count events may have any weight. -/
theorem shared_access_is_neutral (a h k z : Nat) :
    beforeNumerator a h ⟨k * a, k * h, z⟩ =
      afterNumerator a h ⟨k * a, k * h, z⟩ := by
  apply (neutral_iff a h _).mpr
  show k * h * a = k * a * h
  rw [Nat.mul_assoc, Nat.mul_comm h a, ← Nat.mul_assoc]

/-! The native chemical correspondence. No new event law is introduced. -/
namespace Native
open FormedSelection

/-- Every weighted copy channel is guarded by the actual original reaction.
Bulk weight is per template; the equal local coefficient follows whichever
resident actually holds access. The two coefficients remain supplied. -/
def weights (material common localRate unchanged : Nat) (s : State) : Weights :=
  ⟨(if Enabled material s .bulkCopyA then common * aCount s else 0) +
       (if Enabled material s .localCopyA then localRate else 0),
   (if Enabled material s .bulkCopyH then common * hCount s else 0) +
       (if Enabled material s .localCopyH then localRate else 0),
   unchanged⟩

/-- Positive copy weight cannot install an impossible copy event. State validity
is separately required when constructing an actual Step. -/
theorem positive_a_weight_has_native_event (m b l z : Nat) (s : State)
    (positive : 0 < (weights m b l z s).copyA) :
    Enabled m s .bulkCopyA ∨ Enabled m s .localCopyA := by
  by_cases bulk : Enabled m s .bulkCopyA
  · exact Or.inl bulk
  · by_cases localCopy : Enabled m s .localCopyA
    · exact Or.inr localCopy
    · simp only [weights, bulk, localCopy, ↓reduceIte, Nat.add_zero] at positive
      exact False.elim (Nat.lt_irrefl 0 positive)

theorem positive_h_weight_has_native_event (m b l z : Nat) (s : State)
    (positive : 0 < (weights m b l z s).copyH) :
    Enabled m s .bulkCopyH ∨ Enabled m s .localCopyH := by
  by_cases bulk : Enabled m s .bulkCopyH
  · exact Or.inl bulk
  · by_cases localCopy : Enabled m s .localCopyH
    · exact Or.inr localCopy
    · simp only [weights, bulk, localCopy, ↓reduceIte, Nat.add_zero] at positive
      exact False.elim (Nat.lt_irrefl 0 positive)

/-- Original native transmission is faithful in the response structure that
these counts identify. It is not a claim about all offspring properties. -/
theorem native_copy_transmits_its_response_structure {m : Nat} {s t : State} {e : Event}
    (actual : Step m s e t) :
    ((e = .localCopyA ∨ e = .bulkCopyA) →
      0 < aCount s ∧ aCount t = aCount s + 1 ∧ hCount t = hCount s) ∧
    ((e = .localCopyH ∨ e = .bulkCopyH) →
      0 < hCount s ∧ hCount t = hCount s + 1 ∧ aCount t = aCount s) :=
  ⟨fun channel => a_copy_has_template channel actual,
   fun channel => h_copy_has_template channel actual⟩

/-- The already established consequence history supplies the states; this new
claim computes only the weights at its actually reached repair/capture boundary. -/
theorem actual_capture_changes_copy_access :
    Generative.Trace (rootProcess 3) initial witnessEvents copied ∧
    weights 3 1 1 1 repaired = ⟨0, 0, 1⟩ ∧
    weights 3 1 1 1 captured = ⟨1, 0, 1⟩ ∧
    beforeNumerator (aCount captured) (hCount captured) (weights 3 1 1 1 captured) <
      afterNumerator (aCount captured) (hCount captured) (weights 3 1 1 1 captured) := by
  refine ⟨root_formation_to_copy, ?_⟩
  decide

/-- A genuinely different full history from absence keeps another A present
when the repaired site passes to H. No reconstruction of an initially absent A
is inserted at the transfer boundary. -/
def transferInitial : State := ⟨0, 0, .empty, false, false, 6, 1⟩
def transferReady : State := ⟨1, 0, .alternative, true, true, 0, 0⟩
def transferCopied : State := ⟨1, 1, .alternative, true, false, 0, 0⟩
def transferWord : List Event :=
  [.formA, .formA, .formH, .associateA, .repair, .wearResident, .associateH, .capture]

theorem actual_transfer_with_both_structures_present :
    Generative.Trace (rootProcess 3) transferInitial transferWord transferReady ∧
    Step 3 transferReady .localCopyH transferCopied ∧
    aCount transferReady = 1 ∧ hCount transferReady = 1 ∧
    weights 3 1 1 1 transferReady = ⟨0, 1, 1⟩ ∧
    afterNumerator (aCount transferReady) (hCount transferReady)
        (weights 3 1 1 1 transferReady) <
      beforeNumerator (aCount transferReady) (hCount transferReady)
        (weights 3 1 1 1 transferReady) := by
  refine ⟨?_, by decide⟩
  apply trace_to_root
  apply Trace.cons (u := ⟨1, 0, .empty, false, false, 5, 1⟩) (by decide)
  apply Trace.cons (u := ⟨2, 0, .empty, false, false, 4, 1⟩) (by decide)
  apply Trace.cons (u := ⟨2, 1, .empty, false, false, 3, 1⟩) (by decide)
  apply Trace.cons (u := ⟨1, 1, .active, false, false, 2, 1⟩) (by decide)
  apply Trace.cons (u := ⟨1, 1, .active, true, false, 1, 1⟩) (by decide)
  apply Trace.cons (u := ⟨1, 1, .empty, true, false, 1, 1⟩) (by decide)
  apply Trace.cons (u := ⟨1, 0, .alternative, true, false, 0, 1⟩) (by decide)
  apply Trace.cons (u := transferReady) (by decide)
  exact Trace.nil _

/-- This changed access gives different selection of faithfully copied response
structures although both current compositions are exactly one of each. It is
not a controlled pair with identical ancestry, nor evidence of natural rates. -/
theorem same_composition_opposite_access :
    aCount captured = aCount transferReady ∧ hCount captured = hCount transferReady ∧
    (weights 3 1 1 1 captured).copyA > (weights 3 1 1 1 captured).copyH ∧
    (weights 3 1 1 1 transferReady).copyA < (weights 3 1 1 1 transferReady).copyH := by
  decide

/-- The positive unchanged-count weight in both reached comparison states
can be assigned to this actually enabled damage event. Omitting wear/loss from
the selected-event law is still an explicit scope restriction. -/
theorem reached_neutral_event_is_native :
    Step 3 captured .damage (advance captured .damage) ∧
    Step 3 transferReady .damage (advance transferReady .damage) ∧
    aCount (advance captured .damage) = aCount captured ∧
    hCount (advance captured .damage) = hCount captured ∧
    aCount (advance transferReady .damage) = aCount transferReady ∧
    hCount (advance transferReady .damage) = hCount transferReady := by
  decide

end Native

/-! Transmitted structure need not follow template abundance under altered
transmission. These cells are an explicit EXTENSION of the summary interface,
not a claim that mutation is implemented in the unchanged native chemistry. -/
structure Transmission where
  aa : Nat
  ah : Nat
  ha : Nat
  hh : Nat
  unchanged : Nat
  deriving DecidableEq, Repr

def templateWeights (t : Transmission) : Weights :=
  ⟨t.aa + t.ah, t.ha + t.hh, t.unchanged⟩

def transmittedWeights (t : Transmission) : Weights :=
  ⟨t.aa + t.ha, t.ah + t.hh, t.unchanged⟩

def Faithful (t : Transmission) : Prop := t.ah = 0 ∧ t.ha = 0

/-- Parent opportunities count rows; newborn response structures count columns. -/
theorem transmission_preserves_total_event_weight (t : Transmission) :
    total (templateWeights t) = total (transmittedWeights t) := by
  change (t.aa + t.ah + (t.ha + t.hh)) + t.unchanged =
    (t.aa + t.ha + (t.ah + t.hh)) + t.unchanged
  apply congrArg (fun n => n + t.unchanged)
  calc
    t.aa + t.ah + (t.ha + t.hh) = t.aa + (t.ah + (t.ha + t.hh)) := Nat.add_assoc _ _ _
    _ = t.aa + (t.ha + (t.ah + t.hh)) := congrArg (fun n => t.aa + n) (Nat.add_left_comm _ _ _)
    _ = t.aa + t.ha + (t.ah + t.hh) := (Nat.add_assoc _ _ _).symm

theorem transmitted_structure_increase_iff (a h : Nat) (t : Transmission) :
    beforeNumerator a h (transmittedWeights t) < afterNumerator a h (transmittedWeights t) ↔
      (t.ah + t.hh) * a < (t.aa + t.ha) * h :=
  strict_increase_iff a h (transmittedWeights t)

theorem faithful_transmission_matches_template (t : Transmission) (faithful : Faithful t) :
    transmittedWeights t = templateWeights t := by
  obtain ⟨left, right⟩ := faithful
  unfold transmittedWeights templateWeights
  rw [left, right, Nat.add_zero, Nat.zero_add]

/-- Equal off-diagonal transfers suffice even with altered descendants in both
  directions. Fidelity is stronger than the needed net-balance condition. -/
theorem balanced_transfer_matches_template (t : Transmission) (balanced : t.ah = t.ha) :
    transmittedWeights t = templateWeights t := by
  unfold transmittedWeights templateWeights
  rw [balanced]

/-- Faithful transmission is sufficient for matching contrasts; it is not
necessary for increase or for equality of the two contrasts. -/
theorem faithful_increase_iff_template_increase (a h : Nat) (t : Transmission)
    (faithful : Faithful t) :
    (beforeNumerator a h (transmittedWeights t) < afterNumerator a h (transmittedWeights t)) ↔
      (beforeNumerator a h (templateWeights t) < afterNumerator a h (templateWeights t)) := by
  rw [faithful_transmission_matches_template t faithful]

/-- All four transmission channels have positive weight; both initial kinds
are present. A has more template opportunities (6 vs 4), while only three of
the ten newborn structures are A. Nothing disappears by an empty-population
convention: the mean fraction moves from 1/2 to 13/30. -/
def altered : Transmission := ⟨1, 5, 2, 2, 0⟩

theorem positive_template_advantage_can_reverse_in_transmission :
    0 < altered.aa ∧ 0 < altered.ah ∧ 0 < altered.ha ∧ 0 < altered.hh ∧
    total (templateWeights altered) = 10 ∧
    beforeNumerator 1 1 (templateWeights altered) < afterNumerator 1 1 (templateWeights altered) ∧
    afterNumerator 1 1 (transmittedWeights altered) < beforeNumerator 1 1 (transmittedWeights altered) ∧
    afterNumerator 1 1 (transmittedWeights altered) = 26 ∧
    denominator 1 1 (transmittedWeights altered) = 60 := by
  decide

end ConsequenceTransmission

#print axioms ConsequenceTransmission.numerator_balance
#print axioms ConsequenceTransmission.strict_increase_iff
#print axioms ConsequenceTransmission.neutral_iff
#print axioms ConsequenceTransmission.strict_decrease_iff
#print axioms ConsequenceTransmission.denominator_positive
#print axioms ConsequenceTransmission.shared_access_is_neutral
#print axioms ConsequenceTransmission.Native.positive_a_weight_has_native_event
#print axioms ConsequenceTransmission.Native.positive_h_weight_has_native_event
#print axioms ConsequenceTransmission.Native.native_copy_transmits_its_response_structure
#print axioms ConsequenceTransmission.Native.actual_capture_changes_copy_access
#print axioms ConsequenceTransmission.Native.actual_transfer_with_both_structures_present
#print axioms ConsequenceTransmission.Native.same_composition_opposite_access
#print axioms ConsequenceTransmission.transmission_preserves_total_event_weight
#print axioms ConsequenceTransmission.transmitted_structure_increase_iff
#print axioms ConsequenceTransmission.faithful_transmission_matches_template
#print axioms ConsequenceTransmission.faithful_increase_iff_template_increase
#print axioms ConsequenceTransmission.positive_template_advantage_can_reverse_in_transmission

#print axioms ConsequenceTransmission.Native.reached_neutral_event_is_native
#print axioms ConsequenceTransmission.balanced_transfer_matches_template
