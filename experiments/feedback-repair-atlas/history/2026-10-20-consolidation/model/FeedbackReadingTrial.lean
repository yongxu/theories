import Becoming.Readout
import Becoming.Inquiry

/-! A finite human-interaction interpretation of imported structural laws.
A terse remark is compatible with four situations: task error/no error crossed
with personal attack/no attack. These are stipulated possibilities, not diagnoses.
The model concerns evidential permission, not psychological change or social safety.
-/
namespace FeedbackReadingTrial
open Becoming
open Becoming.Readout

/-- Two independent facts; criticism can be accurate and attacking at once. -/
structure Situation where
  taskError : Bool
  personalAttack : Bool
  deriving DecidableEq

/-- The four possibilities admitted in this demonstration. -/
def possibilities : List Situation :=
  [⟨false, false⟩, ⟨false, true⟩, ⟨true, false⟩, ⟨true, true⟩]

/-- Everyone hears the same terse remark: "This needs work." -/
def remark (_ : Situation) : Unit := ()

/-- A specific, correctly checked task finding; its reliability is assumed. -/
def taskEvidence (s : Situation) : Bool := s.taskError

/-- Context sufficient for this toy model; acquiring it is not proved. -/
def contextEvidence (s : Situation) : Bool × Bool := (s.taskError, s.personalAttack)

/-- Terse wording cannot support an everywhere-correct verdict about attack. -/
theorem no_attack_judge_from_remark :
    ¬ ∃ judge, Judges possibilities remark Situation.personalAttack judge :=
  no_judge_of_merged
    (s := ⟨false, false⟩) (s' := ⟨false, true⟩)
    (.head _) (.tail _ (.head _)) rfl (by decide)

/-- Even a real error does not settle whether the delivery was attacking. -/
theorem real_error_does_not_settle_attack :
    ¬ ∃ judge, Judges possibilities taskEvidence Situation.personalAttack judge :=
  no_judge_of_merged
    (s := ⟨true, false⟩) (s' := ⟨true, true⟩)
    (.tail _ (.tail _ (.head _))) (.tail _ (.tail _ (.tail _ (.head _)))) rfl (by decide)

/-- Sufficiently discriminating evidence permits a correct task judgment.
Uses the core's constructive finite-family decoder existence theorem. -/
theorem task_judge_exists :
    ∃ judge, Judges possibilities contextEvidence Situation.taskError judge := by
  apply (judges_iff_lumpedOn possibilities contextEvidence Situation.taskError false).mpr
  intro s s' _ _ same
  exact congrArg Prod.fst same

/-- The same evidence also permits an attack judgment, with no choice axiom. -/
theorem attack_judge_exists :
    ∃ judge, Judges possibilities contextEvidence Situation.personalAttack judge := by
  apply (judges_iff_lumpedOn possibilities contextEvidence Situation.personalAttack false).mpr
  intro s s' _ _ same
  exact congrArg Prod.snd same

/-- Earlier experience can supply opposed default interpretations of identical wording. -/
def learnedDefault (prior : Bool) (_ : Unit) : Bool := prior

/-- The fearful default errs in a non-attacking case. -/
theorem fearful_default_can_misread :
    learnedDefault true (remark ⟨true, false⟩) ≠ (⟨true, false⟩ : Situation).personalAttack := by decide

/-- The reassuring default errs in an attacking case; humility is not forced optimism. -/
theorem reassuring_default_can_misread :
    learnedDefault false (remark ⟨true, true⟩) ≠ (⟨true, true⟩ : Situation).personalAttack := by decide

inductive Response where
  | requestSpecifics
  | acknowledgeTaskError
  | identifyPersonalAttack
  deriving DecidableEq

/-- Stipulated rules of evidential permission. Asking makes no factual verdict;
acknowledging an error or identifying an attack requires the corresponding fact.
This definition makes no assertion that engagement is safe or morally obligatory. -/
def EvidencePermits (s : Situation) : Response → Prop
  | .requestSpecifics => True
  | .acknowledgeTaskError => s.taskError = true
  | .identifyPersonalAttack => s.personalAttack = true

/-- Reuse the existing one-step inquiry, rather than invent an inquiry semantics. -/
def Common (belief : Situation → Prop) (a : Response) : Prop :=
  Generative.InquirySufficiency.CommonResponse (judgeProcess EvidencePermits)
    (fun _ _ _ => True) (fun _ => True) (fun a => [a]) (sees belief) a

/-- Under these evidential rules, an inquiry can proceed without a personal verdict. -/
theorem request_without_verdict : Common (fun _ => True) .requestSpecifics :=
  commonResponse_judge_iff.mpr (fun _ _ => True.intro)

/-- Initial ambiguity does not justify accepting fault in every admitted situation. -/
theorem cannot_always_accept_fault : ¬ Common (fun _ => True) .acknowledgeTaskError := by
  intro common
  have impossible := commonResponse_judge_iff.mp common (⟨false, true⟩ : Situation) True.intro
  exact Bool.false_ne_true impossible

/-- Nor does it justify identifying an attack in every admitted situation. -/
theorem cannot_always_call_attack : ¬ Common (fun _ => True) .identifyPersonalAttack := by
  intro common
  have impossible := commonResponse_judge_iff.mp common (⟨true, false⟩ : Situation) True.intro
  exact Bool.false_ne_true impossible

/-- Evidence refines a prior belief; no candidate is created by the update. -/
def updated (prior : Situation → Prop) (observed : Bool) (s : Situation) : Prop :=
  prior s ∧ taskEvidence s = observed

theorem update_narrows (prior : Situation → Prop) (observed : Bool) :
    ∀ s, updated prior observed s → prior s := fun _ h => h.1

/-- Sound evidence retains the actual case, so this update is nonvacuous. -/
theorem sound_update_keeps_actual (prior : Situation → Prop) (actual : Situation)
    (included : prior actual) : updated prior (taskEvidence actual) actual :=
  ⟨included, rfl⟩

/-- A correctly checked error supports task accountability without settling motive. -/
theorem confirmed_error_supports_accountability (prior : Situation → Prop) :
    Common (updated prior true) .acknowledgeTaskError :=
  commonResponse_judge_iff.mpr (fun _ evidence => evidence.2)

/-- A previously common response remains common after a truthful refinement.
The imported antitone theorem composes evidence update with inquiry. -/
theorem common_survives_update (prior : Situation → Prop) (observed : Bool) (a : Response)
    (before : Common prior a) : Common (updated prior observed) a := by
  apply commonResponse_antitone (B := sees prior) (B' := sees (updated prior observed))
    (fun _ h => ?_) before
  obtain ⟨s, evidence, at_s⟩ := h
  exact ⟨s, evidence.1, at_s⟩

/-- True evidence may still leave motive unresolved. -/
theorem confirmed_error_still_not_attack :
    ¬ Common (updated (fun _ => True) true) .identifyPersonalAttack := by
  intro common
  have impossible := commonResponse_judge_iff.mp common (⟨true, false⟩ : Situation) ⟨True.intro, rfl⟩
  exact Bool.false_ne_true impossible

/-- Excluding reality in advance makes a later sound observation leave an empty belief. -/
theorem wrong_prior_can_empty_update :
    ¬ ∃ s, updated (fun s => s.taskError = false) true s := by
  intro ⟨s, denied, observed⟩
  exact Bool.false_ne_true (denied.symm.trans observed)

end FeedbackReadingTrial
