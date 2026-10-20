import Becoming.Readout
import Becoming.Inquiry
import Becoming.MoveFormation

/-! # One working exchange, read and learned from

The model has one relation: a working exchange between two positions. One position delivers a
terse remark about shared work ("This needs work."), the other replies, and each exchange changes
how each position reads the other. The module has three parts, each built on the one before:

* **§1 Reading one remark.** What the wording of a single remark can and cannot settle about the
  situation it comes from: whether the work has an error, and whether the delivery is personal.
* **§2 Learning across exchanges.** How each position's reading of the other (expectation,
  confidence, credibility) changes as exchanges form, under supplied update laws.
* **§3 The link.** The reply a reading produces to the remark is itself a verdict on §1's
  question "was it personal?". No reading that §2 can reach makes that verdict right in every
  situation §1 admits.

**Relational basis.** The joint state is the record of one exchange read from its two positions.
A position's `Reading` is not an attribute owned by an independent person: both readings are
changed by the same formed exchange (the core's `wholeNext`), and each changes only through what
passes between the positions. The split into two positions stands for the two ends of that one
relation. It omits everything else either end takes part in (other relations, bodies,
institutions, work outside the exchange), how the positions themselves came to be, and any change
not carried by an observed move.

**What is supplied, not derived.** The situations, the evidence functions, the update laws, the
decision probe and the example histories are modelling choices. The laws draw on the trust-learning
studies listed in `EVIDENCE.md`; none of their numbers is fitted to data. The proofs establish
consequences of these choices, not facts about people.

**What the core supplies.** `Readout.Judges`, `no_judge_of_merged` and `judges_iff_lumpedOn`
(what a reduction can decide), the one-step inquiry `judgeProcess` with `commonResponse_judge_iff`
and `commonResponse_antitone`, the coupled-whole constructor `wholeNext`, the fold-commutation
lemma `Readout.foldl_semiconj`, and `Naturals.mul_right_comm`. No law of the theory beyond these is
carried into the application.
-/
namespace FeedbackAtlas
open Becoming
open Becoming.Readout

/-! ## §1 Reading one remark -/

/-- Two independent facts about the situation behind a remark. Criticism can be accurate and
personal at once. -/
structure Situation where
  taskError : Bool
  personal : Bool
  deriving DecidableEq

/-- The four situations the model admits. -/
def possibilities : List Situation :=
  [⟨false, false⟩, ⟨false, true⟩, ⟨true, false⟩, ⟨true, true⟩]

/-- Every situation yields the same terse remark. -/
def remark (_ : Situation) : Unit := ()

/-- A specific, correctly checked finding about the work; its reliability is supplied. -/
def taskEvidence (s : Situation) : Bool := s.taskError

/-- Context that discriminates both facts; how such context is obtained is not modelled. -/
def contextEvidence (s : Situation) : Bool × Bool := (s.taskError, s.personal)

/-- The wording alone cannot be read correctly for "was it personal?" in every admitted case. -/
theorem no_personal_judge_from_remark :
    ¬ ∃ judge, Judges possibilities remark Situation.personal judge :=
  no_judge_of_merged
    (s := ⟨false, false⟩) (s' := ⟨false, true⟩)
    (.head _) (.tail _ (.head _)) rfl (by decide)

/-- A real error in the work does not settle whether the delivery was personal. -/
theorem task_error_does_not_settle_personal :
    ¬ ∃ judge, Judges possibilities taskEvidence Situation.personal judge :=
  no_judge_of_merged
    (s := ⟨true, false⟩) (s' := ⟨true, true⟩)
    (.tail _ (.tail _ (.head _))) (.tail _ (.tail _ (.tail _ (.head _)))) rfl (by decide)

/-- Discriminating context permits a correct reading of the task error, with no choice axiom. -/
theorem task_judge_exists :
    ∃ judge, Judges possibilities contextEvidence Situation.taskError judge := by
  apply (judges_iff_lumpedOn possibilities contextEvidence Situation.taskError false).mpr
  intro s s' _ _ same
  exact congrArg Prod.fst same

/-- The same context permits a correct reading of whether the delivery was personal. -/
theorem personal_judge_exists :
    ∃ judge, Judges possibilities contextEvidence Situation.personal judge := by
  apply (judges_iff_lumpedOn possibilities contextEvidence Situation.personal false).mpr
  intro s s' _ _ same
  exact congrArg Prod.snd same

inductive Response where
  | requestSpecifics
  | acknowledgeTaskError
  | nameAsPersonal
  deriving DecidableEq

/-- Supplied rules of evidential permission. Asking makes no factual verdict; acknowledging an
error or naming the delivery as personal requires the corresponding fact. The rules make no
assertion that replying is safe or required. -/
def EvidencePermits (s : Situation) : Response → Prop
  | .requestSpecifics => True
  | .acknowledgeTaskError => s.taskError = true
  | .nameAsPersonal => s.personal = true

/-- A response permitted in every situation the current belief admits, via the core's one-step
inquiry. -/
def Common (belief : Situation → Prop) (a : Response) : Prop :=
  Generative.InquirySufficiency.CommonResponse (judgeProcess EvidencePermits)
    (fun _ _ _ => True) (fun _ => True) (fun a => [a]) (sees belief) a

/-- Under full ambiguity, asking for specifics is permitted without a verdict. -/
theorem request_without_verdict : Common (fun _ => True) .requestSpecifics :=
  commonResponse_judge_iff.mpr (fun _ _ => True.intro)

/-- Under full ambiguity, acknowledging fault is not permitted in every admitted case. -/
theorem cannot_always_accept_fault : ¬ Common (fun _ => True) .acknowledgeTaskError := by
  intro common
  have impossible := commonResponse_judge_iff.mp common (⟨false, true⟩ : Situation) True.intro
  exact Bool.false_ne_true impossible

/-- Nor is naming the delivery as personal. -/
theorem cannot_always_name_personal : ¬ Common (fun _ => True) .nameAsPersonal := by
  intro common
  have impossible := commonResponse_judge_iff.mp common (⟨true, false⟩ : Situation) True.intro
  exact Bool.false_ne_true impossible

/-- Evidence narrows a belief; the update creates no candidate. -/
def updated (prior : Situation → Prop) (observed : Bool) (s : Situation) : Prop :=
  prior s ∧ taskEvidence s = observed

theorem update_narrows (prior : Situation → Prop) (observed : Bool) :
    ∀ s, updated prior observed s → prior s := fun _ h => h.1

/-- Sound evidence keeps the actual case. -/
theorem sound_update_keeps_actual (prior : Situation → Prop) (actual : Situation)
    (included : prior actual) : updated prior (taskEvidence actual) actual :=
  ⟨included, rfl⟩

/-- A checked error permits acknowledging the error without settling the delivery. -/
theorem confirmed_error_supports_accountability (prior : Situation → Prop) :
    Common (updated prior true) .acknowledgeTaskError :=
  commonResponse_judge_iff.mpr (fun _ evidence => evidence.2)

/-- A permitted response stays permitted after truthful narrowing (the core's antitone law). -/
theorem common_survives_update (prior : Situation → Prop) (observed : Bool) (a : Response)
    (before : Common prior a) : Common (updated prior observed) a := by
  apply commonResponse_antitone (B := sees prior) (B' := sees (updated prior observed))
    (fun _ h => ?_) before
  obtain ⟨s, evidence, at_s⟩ := h
  exact ⟨s, evidence.1, at_s⟩

/-- After a checked error, naming the delivery as personal is still not permitted everywhere. -/
theorem confirmed_error_still_not_personal :
    ¬ Common (updated (fun _ => True) true) .nameAsPersonal := by
  intro common
  have impossible := commonResponse_judge_iff.mp common (⟨true, false⟩ : Situation) ⟨True.intro, rfl⟩
  exact Bool.false_ne_true impossible

/-- Excluding the actual case in advance leaves an empty belief after sound evidence. -/
theorem wrong_prior_can_empty_update :
    ¬ ∃ s, updated (fun s => s.taskError = false) true s := by
  intro ⟨s, denied, observed⟩
  exact Bool.false_ne_true (denied.symm.trans observed)

/-! ## §2 Learning across exchanges -/

/-- An exact fraction between 0 and 1. Values compare by cross multiplication. -/
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

theorem distribute (a b c : Nat) : (a + b) * c = a * c + b * c :=
  (Nat.mul_comm (a + b) c).trans
    ((Nat.left_distrib c a b).trans
      ((congrArg (· + c * b) (Nat.mul_comm c a)).trans
        (congrArg (a * c + ·) (Nat.mul_comm c b))))

/-- A weighted average of two shares is a share: (w p + v y)/(w + v) ≤ 1. This is the only
bound the dynamics needs; every later expectation and credibility is a `Share` by type. -/
theorem weighted_bound (w v : Nat) (p y : Share) :
    w * p.num * y.den + v * y.num * p.den ≤ (w + v) * p.den * y.den := by
  have bound := Nat.add_le_add
    (Nat.mul_le_mul_right y.den (Nat.mul_le_mul_left w p.bounded))
    (Nat.mul_le_mul_right p.den (Nat.mul_le_mul_left v y.bounded))
  have equality : w * p.den * y.den + v * y.den * p.den = (w + v) * p.den * y.den := by
    rw [Naturals.mul_right_comm v y.den p.den, ← distribute, ← distribute]
  exact Nat.le_trans bound (Nat.le_of_eq equality)

/-- (w p + v y)/(w + v), with the old weight `w` positive and the new weight `v` any count. -/
def weighted (w v : Nat) (positive : 0 < w) (p y : Share) : Share where
  num := w * p.num * y.den + v * y.num * p.den
  den := (w + v) * p.den * y.den
  bounded := weighted_bound w v p y
  positive := Nat.mul_pos (Nat.mul_pos
    (Nat.lt_of_lt_of_le positive (Nat.le_add_right w v)) p.positive) y.positive

/-- Halving, rounded down, by structural recursion. -/
def halve : Nat → Nat
  | 0 => 0
  | 1 => 0
  | n + 2 => halve n + 1

theorem halve_le : ∀ n, halve n ≤ n
  | 0 => Nat.le_refl 0
  | 1 => Nat.zero_le 1
  | n + 2 => Nat.le_trans (Nat.succ_le_succ (halve_le n)) (Nat.le_succ _)

/-- How one position reads the other.
* `expectation`: the share of the other's moves it expects to be constructive.
* `confidence`: the evidence weight behind that expectation; a new observation moves the
  expectation by 1/(confidence + 1) of the gap.
* `credibility`: the weight a fresh favorable explanation from the other carries, between 0 and 1.
* `checks`: the evidence weight behind credibility, from independently checked explanations.
None of these is a measured feeling, a probability, or a judgment of worth. -/
structure Reading where
  expectation : Share
  confidence : Nat
  confidencePositive : 0 < confidence
  credibility : Share
  checks : Nat
  checksPositive : 0 < checks

/-- What one position observes of the other in an exchange. -/
inductive Signal where
  | constructive
  | defensive
  | explanation (fresh : Bool)
  | checkedReliable
  | checkedMisleading
  | pause
  deriving DecidableEq

/-- The supplied update laws.
* Constructive move: q′ = (c q + 1)/(c + 1), c′ = c + 1.
* Defensive move: q′ = (c q)/(c + 1), c′ = ⌊c/2⌋ + 1. A defensive move lowers confidence as well
  as expectation, so a reading built from defensive moves stays easy to revise (Siegel et al. 2018
  found beliefs about harmful agents more uncertain and more readily revised).
* Fresh favorable explanation: q′ = (c q + r)/(c + r), weighted by credibility r; confidence and
  credibility are unchanged, so an explanation neither adds behavioral evidence nor certifies itself.
  A stale explanation changes nothing.
* Checked explanation: r′ = (k r + v)/(k + 1), k′ = k + 1, with v = 1 if it proved reliable and
  0 if misleading; the same evidence-weighted form as expectation.
* Pause: no behavioral evidence, no change. -/
def learn (b : Reading) : Signal → Reading
  | .constructive =>
      { b with expectation := weighted b.confidence 1 b.confidencePositive b.expectation one,
               confidence := b.confidence + 1, confidencePositive := Nat.zero_lt_succ _ }
  | .defensive =>
      { b with expectation := weighted b.confidence 1 b.confidencePositive b.expectation zero,
               confidence := halve b.confidence + 1, confidencePositive := Nat.zero_lt_succ _ }
  | .explanation true =>
      { b with expectation := weighted (b.confidence * b.credibility.den) b.credibility.num
                 (Nat.mul_pos b.confidencePositive b.credibility.positive) b.expectation one }
  | .explanation false => b
  | .checkedReliable =>
      { b with credibility := weighted b.checks 1 b.checksPositive b.credibility one,
               checks := b.checks + 1, checksPositive := Nat.zero_lt_succ _ }
  | .checkedMisleading =>
      { b with credibility := weighted b.checks 1 b.checksPositive b.credibility zero,
               checks := b.checks + 1, checksPositive := Nat.zero_lt_succ _ }
  | .pause => b

theorem halve_add_one_le : ∀ c, 2 ≤ c → halve c + 1 ≤ c
  | n + 2, _ => show halve n + 1 + 1 ≤ n + 1 + 1 from Nat.succ_le_succ (Nat.succ_le_succ (halve_le n))

/-- A defensive move never raises confidence once it is at least 2. -/
theorem defense_does_not_consolidate (b : Reading) (atLeastTwo : 2 ≤ b.confidence) :
    (learn b .defensive).confidence ≤ b.confidence :=
  halve_add_one_le b.confidence atLeastTwo

/-- Confidence at most 3 stays at most 2 after a defensive move. -/
theorem halve_small : ∀ c, c ≤ 3 → halve c + 1 ≤ 2
  | 0, _ => by decide
  | 1, _ => by decide
  | 2, _ => by decide
  | 3, _ => by decide
  | n + 4, h => (Nat.not_succ_le_zero n
      (Nat.le_of_succ_le_succ (Nat.le_of_succ_le_succ (Nat.le_of_succ_le_succ h)))).elim

/-- However long a run of defensive moves, it never builds confidence above 2: a reading formed by
defense stays as revisable as a fresh one. -/
theorem defense_keeps_confidence_low (b : Reading) (low : b.confidence ≤ 2) :
    ∀ n, ((List.replicate n Signal.defensive).foldl learn b).confidence ≤ 2
  | 0 => low
  | n + 1 => by
      change ((List.replicate n Signal.defensive).foldl learn (learn b .defensive)).confidence ≤ 2
      exact defense_keeps_confidence_low (learn b .defensive)
        (halve_small b.confidence (Nat.le_trans low (Nat.le_succ 2))) n

/-- An observed defensive move does not depend on how credible the other's explanations are. -/
theorem direct_move_ignores_credibility (b : Reading) :
    (learn b .defensive).credibility = b.credibility := rfl

theorem explanation_adds_no_confidence (b : Reading) :
    (learn b (.explanation true)).confidence = b.confidence := rfl

theorem explanation_does_not_certify_itself (b : Reading) :
    (learn b (.explanation true)).credibility = b.credibility := rfl

theorem stale_explanation_changes_nothing (b : Reading) :
    learn b (.explanation false) = b := rfl

/-- Checking an explanation changes credibility only. -/
theorem checking_separate_from_behavior (b : Reading) :
    (learn b .checkedMisleading).expectation = b.expectation ∧
    (learn b .checkedMisleading).confidence = b.confidence := ⟨rfl, rfl⟩

/-- One end of the exchange: its reading of the other end and the record of what it observed,
newest first. The record is a trace of the relation, not a complete autobiography. -/
structure Position where
  reading : Reading
  record : List Signal

def observe (p : Position) (s : Signal) : Position := ⟨learn p.reading s, s :: p.record⟩

/-- The exchange read from both ends: the initiating end first, the responding end second. -/
abbrev Joint := Position × Position

def readings (s : Joint) : Reading × Reading := (s.1.reading, s.2.reading)

/-- What a guarded end does when its expectation is below its probe. -/
inductive Guard where
  | defend
  | pause
  deriving DecidableEq

/-- The supplied response rule: reply constructively when the expectation reaches the probe,
otherwise defend or pause. A probe drawn uniformly at random would give a probabilistic rule;
no sampling law is asserted. -/
def choose (guard : Guard) (probe : Share) (b : Reading) : Signal :=
  if probe.num * b.expectation.den ≤ b.expectation.num * probe.den then .constructive
  else match guard with
    | .defend => .defensive
    | .pause => .pause

inductive Initiative where
  | lapse
  | cooperate
  | explain (fresh : Bool)
  | habitual
  deriving DecidableEq

structure Input where
  initiative : Initiative
  initiatorProbe : Share
  responderProbe : Share
  initiatorGuard : Guard
  responderGuard : Guard

/-- The signals one exchange carries to each end. -/
structure Exchange where
  toInitiator : Signal
  toResponder : Signal

/-- How an exchange forms: the initiating end moves; the responding end reads that move, then
replies from its updated reading; the initiating end observes the reply. The initiator's own
move is not evidence to itself about the other end. -/
def form (q : Reading × Reading) (input : Input) : Exchange :=
  let first := match input.initiative with
    | .lapse => Signal.defensive
    | .cooperate => .constructive
    | .explain fresh => .explanation fresh
    | .habitual => choose input.initiatorGuard input.initiatorProbe q.1
  ⟨choose input.responderGuard input.responderProbe (learn q.2 first), first⟩

/-- One exchange, through the core's coupled-whole constructor: both ends change by the one move
the whole forms. -/
def step (s : Joint) (input : Input) : Joint :=
  wholeNext (fun p t => observe p t.toInitiator) (fun p t => observe p t.toResponder)
    (fun x => form (readings x) input) s

/-- The same law on readings alone. -/
def readingStep (q : Reading × Reading) (input : Input) : Reading × Reading :=
  wholeNext (fun b t => learn b t.toInitiator) (fun b t => learn b t.toResponder)
    (fun x => form x input) q

theorem step_commutes (s : Joint) (input : Input) :
    readings (step s input) = readingStep (readings s) input := rfl

/-- The readings evolve on their own: formation and update read only the readings, never the
records, so for every finite plan the readings of the full course equal the course of readings.
The records are kept as the relation's trace; in these laws they do no work. -/
theorem readings_evolve_without_record (plan : List Input) (s : Joint) :
    readings (plan.foldl step s) = plan.foldl readingStep (readings s) :=
  Readout.foldl_semiconj step readings readingStep step_commutes plan s

theorem records_retained (s : Joint) (input : Input) :
    (step s input).1.record.tail = s.1.record ∧
    (step s input).2.record.tail = s.2.record := ⟨rfl, rfl⟩

/-! ### Worked examples (synthetic, not fitted) -/

def seed : Position := ⟨⟨half, 2, by decide, half, 2, by decide⟩, []⟩

def fromRecord (events : List Signal) : Position := events.foldl observe seed

/-- Two constructive moves. -/
def short : Position := fromRecord [.constructive, .constructive]
/-- Ten constructive moves. -/
def long : Position := fromRecord (List.replicate 10 .constructive)
/-- Three defensive moves. -/
def guarded : Position := fromRecord (List.replicate 3 .defensive)

def lapse : Input := ⟨.lapse, twoThirds, twoThirds, .defend, .defend⟩
def habitual : Input := ⟨.habitual, twoThirds, twoThirds, .defend, .defend⟩

theorem example_readings :
    Same short.reading.expectation ⟨3, 4, by decide, by decide⟩ ∧ short.reading.confidence = 4 ∧
    Same long.reading.expectation ⟨11, 12, by decide, by decide⟩ ∧ long.reading.confidence = 12 ∧
    Same guarded.reading.expectation ⟨4, 27, by decide, by decide⟩ ∧
    guarded.reading.confidence = 2 := by decide

/-- The same lapse costs a short reading more, and lowers confidence in both. -/
theorem same_lapse_different_updates :
    Same (learn short.reading .defensive).expectation ⟨3, 5, by decide, by decide⟩ ∧
    (learn short.reading .defensive).confidence = 3 ∧
    Same (learn long.reading .defensive).expectation ⟨11, 13, by decide, by decide⟩ ∧
    (learn long.reading .defensive).confidence = 7 := by decide

/-- After three defensive moves, one constructive move lifts expectation from 4/27 to 35/81. -/
theorem guarded_reading_is_revisable :
    Same (learn guarded.reading .constructive).expectation ⟨35, 81, by decide, by decide⟩ := by
  decide

/-- Hold the initiator and the lapse fixed; vary only the responder's history. A short history
replies defensively, a long one constructively. -/
theorem responder_history_changes_reply :
    (form (short.reading, short.reading) lapse).toInitiator = .defensive ∧
    (form (short.reading, long.reading) lapse).toInitiator = .constructive := by decide

theorem responder_history_changes_initiator_reading :
    Same (step (short, short) lapse).1.reading.expectation ⟨3, 5, by decide, by decide⟩ ∧
    Same (step (short, long) lapse).1.reading.expectation ⟨4, 5, by decide, by decide⟩ := by
  decide

/-- A returned defense need not continue: the initiator's long history makes its next habitual
move constructive, and the responder replies constructively. -/
theorem initiator_history_interrupts_returned_defense :
    (form (readings (step (long, short) lapse)) habitual).toResponder = .constructive ∧
    (form (readings (step (long, short) lapse)) habitual).toInitiator = .constructive ∧
    Same (step (step (long, short) lapse) habitual).2.reading.expectation
      ⟨7, 10, by decide, by decide⟩ := by decide

/-- Guarded is not the same as defensive: a pausing responder gives the initiator no new
behavioral evidence, so the initiator's reading stays at 3/4. -/
theorem pause_alternative :
    (form (short.reading, short.reading) { lapse with responderGuard := .pause }).toInitiator =
      .pause ∧
    Same (step (short, short) { lapse with responderGuard := .pause }).1.reading.expectation
      ⟨3, 4, by decide, by decide⟩ := by decide

/-- Same behavioral record, different checked-explanation records. -/
def checkedReliable : Position := fromRecord
  [.constructive, .constructive, .checkedReliable, .checkedReliable]

def checkedMisleading : Position := fromRecord
  [.constructive, .constructive, .checkedMisleading, .checkedMisleading]

theorem credibility_is_separate :
    Same checkedReliable.reading.expectation ⟨3, 4, by decide, by decide⟩ ∧
    Same checkedMisleading.reading.expectation ⟨3, 4, by decide, by decide⟩ ∧
    Same checkedReliable.reading.credibility ⟨3, 4, by decide, by decide⟩ ∧
    Same checkedMisleading.reading.credibility ⟨1, 4, by decide, by decide⟩ := by decide

/-- An observed lapse counts the same at either credibility; the same fresh explanation
afterwards counts for more where explanations have checked out. -/
theorem same_explanation_different_effect :
    Same (learn checkedReliable.reading .defensive).expectation ⟨3, 5, by decide, by decide⟩ ∧
    Same (learn checkedMisleading.reading .defensive).expectation ⟨3, 5, by decide, by decide⟩ ∧
    Same (learn (learn checkedReliable.reading .defensive) (.explanation true)).expectation
      ⟨17, 25, by decide, by decide⟩ ∧
    Same (learn (learn checkedMisleading.reading .defensive) (.explanation true)).expectation
      ⟨41, 65, by decide, by decide⟩ := by decide

/-! ## §3 The link: a reply is a reading of the remark -/

/-- The reply a reading gives to the terse remark, taken as a verdict on §1's question: a guarded
reply (defense or pause) reads the remark as personal, a constructive reply as not personal. -/
def readsPersonal (guard : Guard) (probe : Share) (b : Reading) : Bool :=
  match choose guard probe b with
  | .constructive => false
  | .defensive => true
  | .explanation _ => true
  | .checkedReliable => true
  | .checkedMisleading => true
  | .pause => true

/-- Whatever a reading is, its verdict is wrong in some situation §1 admits: a guarded reply
misreads the non-personal case, a constructive reply the personal one. -/
theorem every_reading_misreads_some_case (guard : Guard) (probe : Share) (b : Reading) :
    ∃ s, s ∈ possibilities ∧ readsPersonal guard probe b ≠ s.personal := by
  cases verdict : readsPersonal guard probe b with
  | false => exact ⟨⟨false, true⟩, .tail _ (.head _), fun e => Bool.false_ne_true e⟩
  | true => exact ⟨⟨false, false⟩, .head _, fun e => Bool.false_ne_true e.symm⟩

/-- Hearing the remark through any reading cannot settle whether it was personal: the remark is
the same in every situation, so the reading adds nothing that discriminates them. This is §1's
`no_personal_judge_from_remark`, now for a listener carrying any history §2 can produce. -/
theorem no_reading_settles_personal (guard : Guard) (probe : Share) (b : Reading) :
    ¬ ∃ judge, Judges possibilities (fun s => (remark s, readsPersonal guard probe b))
      Situation.personal judge :=
  no_judge_of_merged
    (s := ⟨false, false⟩) (s' := ⟨false, true⟩)
    (.head _) (.tail _ (.head _)) rfl (by decide)

/-- For every course of exchanges from every start, the responding end's verdict on the next terse
remark still misreads some admitted situation. Learning changes which way a reading errs, not
whether the remark alone can be read correctly. -/
theorem every_course_misreads_some_case (guard : Guard) (probe : Share)
    (plan : List Input) (s : Joint) :
    ∃ c, c ∈ possibilities ∧
      readsPersonal guard probe (plan.foldl step s).2.reading ≠ c.personal :=
  every_reading_misreads_some_case guard probe _

/-- Where the reading is guarded, the verdict is personal; where it reaches the probe, not. The
worked examples give both: a short reading after a lapse, and a long one. -/
theorem examples_err_in_opposite_directions :
    readsPersonal .defend twoThirds (learn short.reading .defensive) = true ∧
    readsPersonal .defend twoThirds (learn long.reading .defensive) = false := by decide

end FeedbackAtlas
