import Becoming.Assurance
import Becoming.Segmentation
import Becoming.Readout
import Becoming.Gated
import WisdomResponseStructure
import RelationalReduction
import OrganizationalRuleInheritance
import AcquiredSegmentation
import Becoming.CrossSituational
import EncounterChoice
import RetrospectiveBinding
import GoalFormationRevision
import JointPracticeContinuation

/-!
# Constructed machines and histories as instances of the core's laws (periphery)

The definitions of these peripheral machines use standard axioms through their library instances
(membership tests, counting, `Option` binding), so their instances of the core's laws are stated
here (the pure bridge `Becoming.Instances` they once shared is in `lean/history/becoming/` since
the F3 sweep). The core does not import this module.

* **Reading acquired words.** For every lexicon whose transition record groups the two-word
  encoding (six local bond conditions, `Groups`), interpretation of every encoded sequence is the
  assembly of its atoms exactly when each word form resolves to its atom
  (`interprets_every_iff`, from `Segmentation.reads_every_iff`). The histories `learned 32`,
  `coordinated 37`, `acquired 51` and `retrospective 36` are instances; the fixed decoder of
  `experienced 28` is another (`experienced_parses_every`). The peripheral `bond` is the core's
  majority bond (`bond_eq`), so every transition record bonds each sound to at most one
  successor (`bond_functional`).
* **Readout.** The four-integer summary of the two-qubit fragment carries a law
  (`summary_carries_law`) and is exact after every course of moves (`summary_every_word`), from
  `RelationalReduction.summary_update_exact` and the core's `Readout` laws.
* **Formed goal revision.** For every condition with access loss and kept transition
  maintenance, after acquisition, revision and reform, `n` operations run exactly when `n ≤ 5`;
  each consumes the learning goal and adds no loss, so the earlier loss is retained
  (`revision_continues`). The run of the learning practice from any account `⟨w, q, z⟩` succeeds
  for `n` cycles exactly when `n = 0` or `2 ≤ w` and `2 * (n - q / 2) ≤ w`
  (`cycles_learning_iff`). The `harmful` headline is an instance (`harmful_instance`).
* **Gated change in the practice machine.** Its traces are exactly its completed runs
  (`practice_trace_iff_run`); only revision changes the recorded methods (`methods_kept`) and
  only an organizational adoption changes the rule (`practice_rule_kept`), so courses without
  them keep both (`methods_inherited`, `practice_rule_inherited`).
* **Cross-situational binding.** An acquired lexicon's candidates are the core's
  `CrossSituational.candidates` of its admitted records (`candidates_eq`), so, for every lexicon
  whose repertoire has no repeats, the word of `b` resolves to its atom exactly when its admitted
  records separate the atom (`Separated`, `resolve_iff`), and every encoded sequence is read
  exactly when every word is separated (`interprets_every_iff_separated`).
* **Every history of an enacted scene.** Every move keeps the transition record, repertoire and
  exclusions and adds exactly the records heard (`step_records`, `enact_records`), so after every
  history of moves and namings every sequence is read exactly when the earlier records and those
  heard, each offering what was accessible where the learner stood, separate every atom
  (`scene_interprets_every_iff`). `coordinated 37` is an instance (`coordinated_from_history`);
  `stationary 37` fails separation and `mistimed 37` coverage (`stationary_fails`,
  `mistimed_fails`).
* **Cooperative naming.** With support for one naming per accessible meaning, naming every
  accessible atom narrows the candidates of exactly the words whose atoms are accessible to those
  accessible (`naming_narrows`, `local_naming_narrows`); `acquired 51` is an instance of the
  separation law (`acquired_from_separation`).
* **Retrospective binding.** For every memory, fault envelope, form and target whose packets of
  the form are all produced by a learned world with that target, the binding view resolves the
  form to the target exactly when every other meaning is ruled out by a packet that no learned
  world with that meaning produces (`retrospective_resolves_iff`, from
  `CrossSituational.resolves_explained_iff`). The coverage theorem follows (`coverage_from_law`),
  `retrospective 36` is an instance (`retrospective_from_separation`), and after a real route
  change the earlier packet is produced by no learned world with its target
  (`changed_route_unproduced`).
* **Where revision is warranted.** Learning is better than attendance exactly under access loss
  with kept transition maintenance (`better_iff`), and acquisition, revision and reform complete
  exactly there (`completed_iff_better`).
* **A practice round.** From every state, a round of reviewer `r` and worker `w` completes exactly
  when `w` is present and `r` is a present roster member other than `w` whose recorded method
  answers as the context does, and then changes only the review record, the worker's method and
  the completed trials (`round_iff`); the worker is then trained (`round_trains`), a trained
  reviewer needs no further check (`trained_round_iff`), training is kept along every course
  without revision that returns to the context (`trained_along`), and the three rounds of the
  complete history are instances (`complete_history_rounds`).
-/

namespace Becoming.MachineInstances

open Generative Becoming.Assurance

/-! ## Grouping and adoption of the periphery machines

Stated here since the F3 sweep (19 October 2026), with their proofs, from the pure bridge
`Becoming.Instances` (now in `lean/history/becoming/`): the two-word grouping law of
`AcquiredSegmentation` from the core's `Segmentation.encode_iff`, and that only an adoption changes
the rule of `OrganizationalRuleInheritance` (`Gated.KeptBy`). The core states both on its own
machines (`LearnedGrouping.two_word_iff`, `RuleHandoff.rule_kept`). -/

section Grouping

open Generative.AcquiredSegmentation

/-- `AcquiredSegmentation.chunks` is the core's grouping. -/
theorem chunks_eq (r : Sound → Sound → Bool) :
    ∀ xs : List Sound, AcquiredSegmentation.chunks r xs = Segmentation.chunks r xs
  | [] => rfl
  | x :: xs => by
    show (match AcquiredSegmentation.chunks r xs with
      | [] => [[x]]
      | [] :: rest => [x] :: rest
      | (y :: ys) :: rest => if r x y then (x :: y :: ys) :: rest else [x] :: (y :: ys) :: rest) =
      Segmentation.glue r x (Segmentation.chunks r xs)
    rw [chunks_eq r xs]
    cases Segmentation.chunks r xs with
    | nil => rfl
    | cons g rest =>
      cases g with
      | nil => rfl
      | cons y ys => rfl

theorem flatten_eq_join {α : Type} : ∀ L : List (List α), L.flatten = Segmentation.join L
  | [] => rfl
  | g :: gs => congrArg (g ++ ·) (flatten_eq_join gs)

/-- The two-word encoding is the core's encoding. -/
theorem encode_eq (ws : List Bool) :
    AcquiredSegmentation.encode ws = Segmentation.encode AcquiredSegmentation.word ws :=
  flatten_eq_join (ws.map AcquiredSegmentation.word)

/-- The first sound of each word. -/
def wordFirst : Bool → Sound
  | false => .a
  | true => .c

/-- The rest of each word. -/
def wordRest : Bool → List Sound
  | false => [.b]
  | true => [.d]

theorem spelled : Segmentation.Spelled AcquiredSegmentation.word wordFirst wordRest
  | false => rfl
  | true => rfl

/-- **For every grouping relation, grouping recovers the words of every sequence in the two-word
encoding exactly when `a→b` and `c→d` are linked and `b→a`, `b→c`, `d→a`, `d→c` are not.** -/
theorem two_word_iff (r : Sound → Sound → Bool) :
    (∀ ws, AcquiredSegmentation.chunks r (AcquiredSegmentation.encode ws) =
        ws.map AcquiredSegmentation.word) ↔
      r .a .b = true ∧ r .c .d = true ∧ r .b .a = false ∧ r .b .c = false ∧
        r .d .a = false ∧ r .d .c = false :=
  have core := Segmentation.encode_iff r spelled
  ⟨fun every =>
    have every' : ∀ ws, Segmentation.chunks r (Segmentation.encode AcquiredSegmentation.word ws) =
        ws.map AcquiredSegmentation.word := fun ws =>
      (encode_eq ws ▸ chunks_eq r _ ▸ every ws)
    match core.mp every' with
    | ⟨inside, between⟩ =>
      ⟨(inside false).1, (inside true).1, between false false, between false true,
       between true false, between true true⟩,
   fun ⟨ab, cd, ba, bc, da, dc⟩ ws =>
    have inside : ∀ w, Segmentation.LinkedFrom r (wordFirst w) (wordRest w) := fun
      | false => ⟨ab, trivial⟩
      | true => ⟨cd, trivial⟩
    have between : ∀ w v, r (Segmentation.lastOf (wordFirst w) (wordRest w)) (wordFirst v) =
        false := fun
      | false, false => ba
      | false, true => bc
      | true, false => da
      | true, true => dc
    (chunks_eq r _).trans ((congrArg (Segmentation.chunks r) (encode_eq ws)).trans
      (core.mpr ⟨inside, between⟩ ws))⟩

end Grouping

section Governance

open OrganizationalRuleInheritance

/-- The gate: adoption. -/
def adopts : Event → Bool
  | .review _ _ => false
  | .enroll _ _ => false
  | .propose _ _ => false
  | .adopt _ => true
  | .integrate _ => false
  | .handoff _ => false

theorem ite_some {β : Type} {c : Prop} {d : Decidable c} {x t : β} :
    (@ite _ c d (some x) none) = some t → x = t :=
  match d with
  | isTrue _ => fun same => Option.some.inj same
  | isFalse _ => fun same => nomatch same

/-- **Only an adoption changes the rule.** -/
theorem rule_kept : Gated.KeptBy OrganizationalRuleInheritance.process adopts State.rule
  | s, .review r c, t, step, _ =>
    have same : { s with reviews := (r, c) :: s.reviews } = t := ite_some step
    (congrArg State.rule same).symm
  | s, .enroll c _, t, step, _ =>
    have same : { s with roster := s.roster ++ [c] } = t := ite_some step
    (congrArg State.rule same).symm
  | s, .propose _ p, t, step, _ =>
    have same : { s with proposal := some p } = t := ite_some step
    (congrArg State.rule same).symm
  | _, .adopt _, _, _, gated => nomatch gated
  | s, .integrate _, t, step, _ =>
    have same : { s with accepted := s.accepted + 1 } = t := ite_some step
    (congrArg State.rule same).symm
  | s, .handoff cs, t, step, _ =>
    have same : handoff s cs = t := Option.some.inj step
    (congrArg State.rule same).symm

end Governance

/-! ## Reading acquired words -/

section Reading

open Generative.CompositionalAcquisition Generative.AcquiredSegmentation Generative.AcquiredBinding

/-- The record groups the two-word encoding: `a→b`, `c→d` bonded; `b→a`, `b→c`, `d→a`, `d→c` not. -/
def Groups (log : List (Option Sound)) : Prop :=
  bond log .a .b = true ∧ bond log .c .d = true ∧ bond log .b .a = false ∧
    bond log .b .c = false ∧ bond log .d .a = false ∧ bond log .d .c = false

theorem segments_of_groups {log : List (Option Sound)} (groups : Groups log) (ws : List Bool) :
    chunks (bond log) (encode ws) = ws.map word :=
  (two_word_iff (bond log)).mpr groups ws

theorem readForms_eq (s : Lexicon) :
    ∀ fs, readForms s fs = Segmentation.readAll (resolve s) fs
  | [] => rfl
  | f :: fs => by
    show (resolve s f).bind (fun e => (readForms s fs).bind fun es => some (e :: es)) = _
    rw [readForms_eq s fs]
    rfl

/-- **Reading acquired words.** For every lexicon whose record groups the two-word encoding,
every encoded sequence is interpreted as the assembly of its atoms exactly when each word form
resolves to its atom. -/
theorem interprets_every_iff (s : Lexicon) (groups : Groups s.percept.log) :
    (∀ ws, interpret s (encode ws) = assembleMessage (ws.map Expr.atom)) ↔
      ∀ b, resolve s (word b) = some (Expr.atom b) := by
  constructor
  · intro every b
    have once := every [b]
    simp only [interpret, segments_of_groups groups, List.map, readForms] at once
    cases hr : resolve s (word b) with
    | none => simp [hr, assembleMessage] at once
    | some e =>
      simp [hr, assembleMessage] at once
      rw [once]
  · intro each ws
    show (readForms s (chunks (bond s.percept.log) (encode ws))).bind assembleMessage = _
    rw [segments_of_groups groups, readForms_eq,
      (Segmentation.readAll_map_iff (resolve s) word Expr.atom ws).mpr (fun w _ => each w)]
    rfl

theorem learned_groups : Groups (learned 32).percept.log := by unfold Groups; decide

/-- `learned 32` as an instance. -/
theorem learned_interprets_every (ws : List Bool) :
    interpret (learned 32) (encode ws) = assembleMessage (ws.map Expr.atom) :=
  (interprets_every_iff _ learned_groups).mpr actual_encounters_acquire_both_bindings ws

theorem coordinated_groups : Groups (EnactedScene.coordinated 37).lexicon.percept.log := by unfold Groups; decide

theorem coordinated_resolves (b : Bool) :
    resolve (EnactedScene.coordinated 37).lexicon (word b) = some (Expr.atom b) := by
  cases b <;> decide

/-- `coordinated 37` as an instance. -/
theorem coordinated_interprets_every (ws : List Bool) :
    interpret (EnactedScene.coordinated 37).lexicon (encode ws) =
      assembleMessage (ws.map Expr.atom) :=
  (interprets_every_iff _ coordinated_groups).mpr coordinated_resolves ws

theorem acquired_groups :
    Groups (EncounterChoice.acquired 51).situation.lexicon.percept.log := by unfold Groups; decide

theorem acquired_resolves (b : Bool) :
    resolve (EncounterChoice.acquired 51).situation.lexicon (word b) = some (Expr.atom b) := by
  cases b <;> decide

/-- `acquired 51` as an instance. -/
theorem acquired_interprets_every (ws : List Bool) :
    interpret (EncounterChoice.acquired 51).situation.lexicon (encode ws) =
      assembleMessage (ws.map Expr.atom) :=
  (interprets_every_iff _ acquired_groups).mpr acquired_resolves ws

theorem retrospective_groups :
    Groups (RetrospectiveBinding.bindingView (RetrospectiveBinding.retrospective 36)
      SourceReliance.allFaults).percept.log := by unfold Groups; decide

/-- `retrospective 36` as an instance. -/
theorem retrospective_interprets_every (ws : List Bool) :
    interpret (RetrospectiveBinding.bindingView (RetrospectiveBinding.retrospective 36)
        SourceReliance.allFaults) (encode ws) = assembleMessage (ws.map Expr.atom) :=
  (interprets_every_iff _ retrospective_groups).mpr
    RetrospectiveBinding.late_calibration_changes_both_bindings ws

theorem experienced_groups : Groups (experienced 28).log := by unfold Groups; decide

/-- The fixed decoder after `experienced 28` as an instance of grouping. -/
theorem experienced_parses_every (ws : List Bool) :
    parse (experienced 28) (encode ws) = assembleMessage (ws.map Expr.atom) := by
  show (decodeChunks (chunks (bond (experienced 28).log) (encode ws))).bind assembleMessage = _
  rw [segments_of_groups experienced_groups, decoded_word_sequence]
  rfl

/-! ### The peripheral bond is the core's majority bond -/

theorem edges_eq : ∀ (x : Option Sound) (rest : List (Option Sound)),
    AcquiredSegmentation.edges (x :: rest) = Segmentation.edges.edgesFrom x rest
  | _, [] => by simp [AcquiredSegmentation.edges, Segmentation.edges.edgesFrom]
  | none, y :: rest => by
    simp [AcquiredSegmentation.edges, Segmentation.edges.edgesFrom, edges_eq y rest]
  | some u, none :: rest => by
    simp [AcquiredSegmentation.edges, Segmentation.edges.edgesFrom, edges_eq none rest]
  | some u, some v :: rest => by
    simp [AcquiredSegmentation.edges, Segmentation.edges.edgesFrom, edges_eq (some v) rest]

theorem edges_all_eq : ∀ log : List (Option Sound),
    AcquiredSegmentation.edges log = Segmentation.edges log
  | [] => by simp [AcquiredSegmentation.edges, Segmentation.edges]
  | x :: rest => (edges_eq x rest).trans rfl

theorem countP_eq {β : Type} (p q : β → Bool) (same : ∀ b, p b = q b) :
    ∀ l : List β, l.countP p = Segmentation.countIf q l
  | [] => rfl
  | b :: bs => by
    rw [List.countP_cons, countP_eq p q same bs, same b]
    simp only [Segmentation.countIf]
    cases q b <;> simp

theorem beq_sound (x y : Sound) : (x == y) = decide (x = y) := by
  cases x <;> cases y <;> rfl

theorem beq_pair (e : Sound × Sound) (x y : Sound) : (e == (x, y)) = decide (e = (x, y)) := by
  obtain ⟨e₁, e₂⟩ := e
  cases e₁ <;> cases e₂ <;> cases x <;> cases y <;> rfl

/-- **The peripheral bond is the core's majority bond.** -/
theorem bond_eq (log : List (Option Sound)) (x y : Sound) :
    AcquiredSegmentation.bond log x y = Segmentation.bond log x y := by
  have departing : AcquiredSegmentation.departures log x = Segmentation.departures log x := by
    unfold AcquiredSegmentation.departures Segmentation.departures
    rw [edges_all_eq]
    exact countP_eq _ _ (fun (e : Sound × Sound) => beq_sound e.1 x) _
  have moving : AcquiredSegmentation.edgeCount log x y = Segmentation.transitions log x y := by
    unfold AcquiredSegmentation.edgeCount List.count Segmentation.transitions
    rw [edges_all_eq]
    exact countP_eq _ _ (fun (e : Sound × Sound) => beq_pair e x y) _
  unfold AcquiredSegmentation.bond Segmentation.bond
  rw [departing, moving]

/-- **Every transition record bonds each sound to at most one successor.** -/
theorem bond_functional (log : List (Option Sound)) {x y z : Sound}
    (toY : AcquiredSegmentation.bond log x y = true)
    (toZ : AcquiredSegmentation.bond log x z = true) : y = z :=
  Segmentation.bond_unique log ((bond_eq log x y) ▸ toY) ((bond_eq log x z) ▸ toZ)

end Reading

/-! ## Readout -/

section Quantum

open Generative.OperativeCoherence Generative.RelationalReduction

/-- **The summary with the joint cross term carries a law of the fragment.** -/
theorem summary_carries_law :
    ∃ Q : Process Summary Event, Determined Q ∧
      FactorsThrough (ofMap RelationalReduction.next) summarize Q :=
  (Readout.law_through_iff RelationalReduction.next summarize).mpr fun s s' a same =>
    (summary_update_exact s a).trans
      ((congrArg (reducedNext · a) same).trans (summary_update_exact s' a).symm)

/-- **After every course of moves, the summary is the reduced law's course.** -/
theorem summary_every_word (v : Joint) (word : List Event) :
    summarize (word.foldl RelationalReduction.next v) = word.foldl reducedNext (summarize v) :=
  Readout.foldl_semiconj RelationalReduction.next summarize reducedNext summary_update_exact word v

end Quantum

/-! ## Formed goal revision -/

section Revision

open GoalFormationRevision

/-- One cycle of a practice under a selector, from an account. -/
theorem cycle_eq (r : Selection) (p : Practice) (w q z : Nat) :
    cycle r p ⟨w, q, z⟩ =
      if 2 ≤ w then
        some (if feedback r p = 2 ∧ 2 ≤ q then ⟨w, q - 2, z + 2⟩ else ⟨w - 2, q, z + 2⟩)
      else none := by
  unfold cycle charge
  by_cases hw : 2 ≤ w
  · by_cases hf : feedback r p = 2 ∧ 2 ≤ q
    · simp [hw, hf]
    · rw [if_pos hw, if_pos hw, if_neg hf]
      show (if feedback r p = 2 ∧ 2 ≤ q then _ else _) = _
      rw [if_neg hf]
      rfl
  · rw [if_neg hw, if_neg hw]
    rfl

/-- **A practice runs `n` cycles from `⟨w, q, z⟩` exactly when `n = 0`, or `2 ≤ w` and the work
covers the cycles the reserve does not support**: twice `n` less the supported cycles (`q / 2`
where the selector feeds the practice back, none otherwise) is at most `w`. -/
theorem cycles_iff (r : Selection) (p : Practice) : ∀ (n w q z : Nat),
    (cycles r p n ⟨w, q, z⟩).isSome = true ↔
      n = 0 ∨ (2 ≤ w ∧ 2 * (n - (if feedback r p = 2 then q / 2 else 0)) ≤ w)
  | 0, _, _, _ => ⟨fun _ => Or.inl rfl, fun _ => rfl⟩
  | n + 1, w, q, z => by
    have unfolds : cycles r p (n + 1) ⟨w, q, z⟩ = (cycle r p ⟨w, q, z⟩).bind (cycles r p n) := rfl
    rw [unfolds, cycle_eq]
    by_cases hw : 2 ≤ w
    · rw [if_pos hw]
      by_cases hf : feedback r p = 2 ∧ 2 ≤ q
      · rw [if_pos hf]
        change (cycles r p n ⟨w, q - 2, z + 2⟩).isSome = true ↔ _
        rw [cycles_iff r p n w (q - 2) (z + 2)]
        simp only [if_pos hf.1]
        have := hf.2
        constructor <;> intro h <;> omega
      · rw [if_neg hf]
        change (cycles r p n ⟨w - 2, q, z + 2⟩).isSome = true ↔ _
        rw [cycles_iff r p n (w - 2) q (z + 2)]
        by_cases hfb : feedback r p = 2
        · have hq : q < 2 := Nat.lt_of_not_le fun hq => hf ⟨hfb, hq⟩
          simp only [if_pos hfb]
          constructor <;> intro h <;> omega
        · simp only [if_neg hfb]
          constructor <;> intro h <;> omega
    · rw [if_neg hw]
      constructor
      · intro h
        exact nomatch h
      · intro h
        exfalso
        omega

/-- The learning practice under the learning selector. -/
theorem cycles_learning_iff (n w q z : Nat) :
    (cycles .learning .learning n ⟨w, q, z⟩).isSome = true ↔
      n = 0 ∨ (2 ≤ w ∧ 2 * (n - q / 2) ≤ w) := by
  have fed : feedback .learning .learning = 2 := rfl
  rw [cycles_iff, if_pos fed]

/-- The learning practice under the attendance selector: no reserve support. -/
theorem cycles_unselected_iff (n w q z : Nat) :
    (cycles .attendance .learning n ⟨w, q, z⟩).isSome = true ↔ 2 * n ≤ w := by
  have unfed : feedback .attendance .learning ≠ 2 := fun same => nomatch same
  rw [cycles_iff, if_neg unfed]
  constructor <;> intro h <;> omega

/-- The loss a learning operation adds: one where transition maintenance is lost. -/
def lossPer (c : GoalFormationRevision.Conditions) : Nat := if c.transitionLoss = true then 1 else 0

theorem learning_loss (c : GoalFormationRevision.Conditions) :
    (if ((perform c .learning).access && (perform c .learning).maintenance) = true then 0 else 1) =
      lossPer c := by
  obtain ⟨a, t, r⟩ := c
  cases t <;> rfl

/-- The record a learning operation appends. -/
def learningRecord (c : GoalFormationRevision.Conditions) (r : Selection) : Record :=
  ⟨.learning, perform c .learning, feedback r .learning⟩

/-- **Operating the learning goal**, for every condition, state and number of operations: every
operation consumes the learning goal, keeps the selector, adds the transition loss if any and
appends one record; the operations run exactly as the account's cycles. -/
theorem operateMany_learning (c : GoalFormationRevision.Conditions) :
    ∀ (n : Nat) (s : State), s.goal = some .learning →
      ((operateMany c n s).isSome = (cycles s.selector .learning n s.account).isSome) ∧
      ∀ t, operateMany c n s = some t →
        t.goal = s.goal ∧ t.selector = s.selector ∧ t.losses = s.losses + n * lossPer c ∧
          t.archive.length = s.archive.length + n
  | 0, s, _ => by
    refine ⟨rfl, fun t ran => ?_⟩
    have same : s = t := Option.some.inj ran
    subst same
    exact ⟨rfl, rfl, by rw [Nat.zero_mul, Nat.add_zero], (Nat.add_zero _).symm⟩
  | n + 1, s, goal => by
    have step : operate c s = (cycle s.selector .learning s.account).bind (fun a => some
        { s with account := a, archive := s.archive ++ [learningRecord c s.selector],
                 losses := s.losses + (if ((perform c .learning).access &&
                   (perform c .learning).maintenance) = true then 0 else 1) }) := by
      unfold operate
      rw [goal]
      rfl
    have unfoldOps : operateMany c (n + 1) s = (operate c s).bind (operateMany c n) := rfl
    have unfoldCycles : cycles s.selector .learning (n + 1) s.account =
        (cycle s.selector .learning s.account).bind (cycles s.selector .learning n) := rfl
    rw [unfoldOps, unfoldCycles, step]
    cases hc : cycle s.selector .learning s.account with
    | none => exact ⟨rfl, fun t ran => absurd ran (fun h => nomatch h)⟩
    | some a =>
      have ih := operateMany_learning c n
        { s with account := a, archive := s.archive ++ [learningRecord c s.selector],
                 losses := s.losses + (if ((perform c .learning).access &&
                   (perform c .learning).maintenance) = true then 0 else 1) } goal
      refine ⟨ih.1, fun t ran => ?_⟩
      obtain ⟨g, sel, los, len⟩ := ih.2 t ran
      refine ⟨g, sel, ?_, ?_⟩
      · rw [los]
        show s.losses + (if ((perform c .learning).access &&
          (perform c .learning).maintenance) = true then 0 else 1) + n * lossPer c = _
        rw [learning_loss, Nat.succ_mul]
        omega
      · rw [len]
        show (s.archive ++ [learningRecord c s.selector]).length + n = _
        rw [List.length_append]
        show s.archive.length + 1 + n = _
        omega

/-- **Revision happens exactly under access loss with kept transition maintenance**: acquisition,
revision and reform complete for exactly these conditions. -/
theorem completed_isSome_iff (c : GoalFormationRevision.Conditions) :
    (completed c).isSome = true ↔ c.accessLoss = true ∧ c.transitionLoss = false := by
  obtain ⟨a, t, r⟩ := c
  cases a <;> cases t <;> cases r <;> decide

/-- After revision, every condition with access loss and kept maintenance holds the learning goal
under the attendance selector with one loss, the account `⟨5, 8, 5⟩` and two records; reform
moves the selector to learning at the account `⟨3, 8, 7⟩`. -/
theorem revised_class (c : GoalFormationRevision.Conditions) :
    c.accessLoss = true → c.transitionLoss = false →
      (revised c).map (fun s => (s.goal, s.selector, s.losses, s.account, s.archive.length)) =
        some (some .learning, .attendance, 1, ⟨5, 8, 5⟩, 2) ∧
      (completed c).map (fun s => (s.goal, s.selector, s.losses, s.account, s.archive.length)) =
        some (some .learning, .learning, 1, ⟨3, 8, 7⟩, 2) := by
  obtain ⟨a, t, r⟩ := c
  cases a <;> cases t <;> cases r <;> decide

/-- The fields of a state read off a class equation. -/
theorem fields_of {o : Option State} {g : Option Goal} {r : Selection} {l : Nat} {acc : Account}
    {k : Nat}
    (known : o.map (fun s => (s.goal, s.selector, s.losses, s.account, s.archive.length)) =
      some (g, r, l, acc, k)) :
    ∃ s, o = some s ∧ s.goal = g ∧ s.selector = r ∧ s.losses = l ∧ s.account = acc ∧
      s.archive.length = k := by
  cases o with
  | none => exact absurd known (fun h => nomatch h)
  | some s =>
    have fields := Option.some.inj known
    simp only [Prod.mk.injEq] at fields
    obtain ⟨g', r', l', a', k'⟩ := fields
    exact ⟨s, rfl, g', r', l', a', k'⟩

/-- **Formed goal revision continues, for every condition with access loss and kept transition
maintenance and every number of operations.** After acquisition, revision and reform, `n`
operations run exactly when `n ≤ 5`; each consumes the learning goal and adds no loss, so the
earlier loss is retained. Without reform, the unchanged selector supports none of them, and `n`
operations run exactly when `n ≤ 2`. -/
theorem revision_continues (c : GoalFormationRevision.Conditions) (harm : c.accessLoss = true)
    (retain : c.transitionLoss = false) (n : Nat) :
    ((completed c >>= operateMany c n).isSome = true ↔ n ≤ 5) ∧
      (∀ t, (completed c >>= operateMany c n) = some t →
        t.goal = some .learning ∧ t.losses = 1 ∧ t.archive.length = 2 + n) ∧
      ((revised c >>= operateMany c n).isSome = true ↔ n ≤ 2) := by
  have none_lost : lossPer c = 0 := by
    unfold lossPer
    rw [retain]
    rfl
  obtain ⟨s, hs, goal, sel, los, acc, len⟩ := fields_of (revised_class c harm retain).2
  obtain ⟨u, hu, goalU, selU, _, accU, _⟩ := fields_of (revised_class c harm retain).1
  rw [hs, hu]
  have laws := operateMany_learning c n s goal
  have lawsU := operateMany_learning c n u goalU
  refine ⟨?_, fun t ran => ?_, ?_⟩
  · show (operateMany c n s).isSome = true ↔ _
    rw [laws.1, sel, acc, cycles_learning_iff]
    constructor <;> intro h <;> omega
  · obtain ⟨g, _, l, a⟩ := laws.2 t ran
    refine ⟨g.trans goal, ?_, ?_⟩
    · rw [l, los, none_lost, Nat.mul_zero]
    · rw [a, len, Nat.add_comm]
  · show (operateMany c n u).isSome = true ↔ _
    rw [lawsU.1, selU, accU, cycles_unselected_iff]
    constructor <;> intro h <;> omega

/-- **The `harmful` headline as an instance** (`joined_revision_has_warrant_and_actual_continuation`). -/
theorem harmful_instance :
    PracticalJudgment.Better (protects harmful) (gains harmful) .learning .attendance ∧
    (acquire harmful .attendance).map State.goal = some (some .attendance) ∧
    (completed harmful >>= operateMany harmful 5).map State.goal = some (some .learning) ∧
    (completed harmful >>= operateMany harmful 5).map State.losses = some 1 := by
  have law := revision_continues harmful rfl rfl 5
  have runs := law.1.mpr (Nat.le_refl 5)
  cases hr : (completed harmful >>= operateMany harmful 5) with
  | none => rw [hr] at runs; exact absurd runs (fun h => nomatch h)
  | some t =>
    obtain ⟨g, l, _⟩ := law.2.1 t hr
    exact ⟨warranted_revision harmful rfl rfl,
      (goal_depends_on_actual_formative_rule harmful).1,
      congrArg some g, congrArg some l⟩

/-- `reform_does_not_make_support_infinite` and `unchanged_selection_exhausts_revised_practice`
as instances. -/
theorem harmful_bounds :
    (completed harmful >>= operateMany harmful 6) = none ∧
      (revised harmful >>= operateMany harmful 3) = none := by
  have law6 := revision_continues harmful rfl rfl 6
  have law3 := revision_continues harmful rfl rfl 3
  constructor
  · cases h : (completed harmful >>= operateMany harmful 6) with
    | none => rfl
    | some t => exact absurd (law6.1.mp (by rw [h]; rfl)) (by decide)
  · cases h : (revised harmful >>= operateMany harmful 3) with
    | none => rfl
    | some t => exact absurd (law3.2.2.mp (by rw [h]; rfl)) (by decide)

end Revision

/-! ## Gated change in the practice machine -/

section Practice

open JointPracticeContinuation

/-- The gate on methods: revision. -/
def revises : Event → Bool
  | .revise => true
  | _ => false

/-- The gate on the rule: an organizational adoption. -/
def adoptsRule : Event → Bool
  | .organizational (.adopt _) => true
  | _ => false

theorem practice_process_eq : JointPracticeContinuation.process = ofPartial step := rfl

theorem practice_run_eq : ∀ (s : State) (es : List Event), run s es = runPartial step s es
  | _, [] => rfl
  | s, e :: es => by
    show (step s e).bind (fun t => run t es) = (step s e).bind (fun t => runPartial step t es)
    cases step s e with
    | none => rfl
    | some t => exact practice_run_eq t es

/-- **The traces of the practice machine are exactly its completed runs.** -/
theorem practice_trace_iff_run {s t : State} {es : List Event} :
    Trace JointPracticeContinuation.process s es t ↔ run s es = some t :=
  (trace_ofPartial_iff step).trans
    ⟨fun ran => (practice_run_eq s es).trans ran, fun ran => (practice_run_eq s es).symm.trans ran⟩

/-- **Only revision changes the recorded methods.** -/
theorem methods_kept : Gated.KeptBy JointPracticeContinuation.process revises State.methods := by
  intro s e t step gated
  change JointPracticeContinuation.step s e = some t at step
  cases e with
  | attempt w x =>
    simp only [JointPracticeContinuation.step] at step
    split at step <;> simp_all
    subst step; rfl
  | respond r =>
    simp only [JointPracticeContinuation.step] at step
    split at step
    · simp at step
    · split at step <;> simp_all
      subst step; rfl
  | revise => simp [revises] at gated
  | retry =>
    simp only [JointPracticeContinuation.step] at step
    split at step
    · simp at step
    · split at step
      · obtain ⟨org, _, rfl⟩ := Option.map_eq_some_iff.mp step
        rfl
      · simp at step
  | organizational e =>
    cases e with
    | review _ _ => simp [JointPracticeContinuation.step] at step
    | _ =>
      simp only [JointPracticeContinuation.step] at step
      obtain ⟨org, _, rfl⟩ := Option.map_eq_some_iff.mp step
      rfl
  | changeContext c =>
    simp only [JointPracticeContinuation.step, Option.some.injEq] at step
    subst step; rfl

/-- **Every course without revision keeps the recorded methods.** -/
theorem methods_inherited {s t : State} {es : List Event}
    (path : Trace JointPracticeContinuation.process s es t)
    (none_revise : ∀ e, e ∈ es → revises e = false) : t.methods = s.methods :=
  Gated.kept_along methods_kept path none_revise

/-- **Only an organizational adoption changes the rule.** -/
theorem practice_rule_kept :
    Gated.KeptBy JointPracticeContinuation.process adoptsRule (fun s => s.org.rule) := by
  intro s e t step gated
  change JointPracticeContinuation.step s e = some t at step
  cases e with
  | attempt w x =>
    simp only [JointPracticeContinuation.step] at step
    split at step <;> simp_all
    subst step; rfl
  | respond r =>
    simp only [JointPracticeContinuation.step] at step
    split at step
    · simp at step
    · split at step <;> simp_all
      subst step; rfl
  | revise =>
    simp only [JointPracticeContinuation.step] at step
    split at step
    · simp at step
    · split at step <;> simp_all
      subst step; rfl
  | retry =>
    simp only [JointPracticeContinuation.step] at step
    split at step
    · simp at step
    · split at step
      · obtain ⟨org, moved, rfl⟩ := Option.map_eq_some_iff.mp step
        exact rule_kept _ _ _ moved rfl
      · simp at step
  | organizational e =>
    cases e with
    | review _ _ => simp [JointPracticeContinuation.step] at step
    | adopt _ => simp [adoptsRule] at gated
    | enroll c b =>
      simp only [JointPracticeContinuation.step] at step
      obtain ⟨org, moved, rfl⟩ := Option.map_eq_some_iff.mp step
      exact rule_kept _ _ _ moved rfl
    | propose c p =>
      simp only [JointPracticeContinuation.step] at step
      obtain ⟨org, moved, rfl⟩ := Option.map_eq_some_iff.mp step
      exact rule_kept _ _ _ moved rfl
    | integrate b =>
      simp only [JointPracticeContinuation.step] at step
      obtain ⟨org, moved, rfl⟩ := Option.map_eq_some_iff.mp step
      exact rule_kept _ _ _ moved rfl
    | handoff cs =>
      simp only [JointPracticeContinuation.step] at step
      obtain ⟨org, moved, rfl⟩ := Option.map_eq_some_iff.mp step
      exact rule_kept _ _ _ moved rfl
  | changeContext c =>
    simp only [JointPracticeContinuation.step, Option.some.injEq] at step
    subst step; rfl

/-- **Every course without an organizational adoption keeps the rule.** -/
theorem practice_rule_inherited {s t : State} {es : List Event}
    (path : Trace JointPracticeContinuation.process s es t)
    (none_adopt : ∀ e, e ∈ es → adoptsRule e = false) : t.org.rule = s.org.rule :=
  Gated.kept_along practice_rule_kept path none_adopt

/-- The complete practice history as an instance: one trace, and the run it completes. -/
theorem complete_history_instance :
    Trace JointPracticeContinuation.process initial
      (firstHistory ++ secondHistory ++ continuationHistory) continued :=
  practice_trace_iff_run.mpr (by decide)

end Practice

/-! ## Cross-situational binding -/

section Binding

open Generative.CompositionalAcquisition Generative.AcquiredSegmentation Generative.AcquiredBinding

/-- A record bears on a form where its source is admitted and its form is that form. -/
def bearsOn (excluded : List Nat) (form : List Sound) (r : Encounter) : Bool :=
  decide (r.origin ∉ excluded ∧ r.form = form)

/-- A record offers the meanings accessible on its occasion. -/
def offersOf (r : Encounter) (e : Expr) : Bool := decide (e ∈ r.offered)

theorem compatible_eq (s : Lexicon) (form : List Sound) (e : Expr) :
    compatible s form e =
      CrossSituational.stands (bearsOn s.excluded form) offersOf s.records e := by
  unfold compatible CrossSituational.stands
  congr 1
  funext r
  by_cases h1 : r.origin ∈ s.excluded <;> by_cases h2 : r.form = form <;>
    by_cases h3 : e ∈ r.offered <;> simp [bearsOn, offersOf, h1, h2, h3]

theorem candidates_eq (s : Lexicon) (form : List Sound) :
    AcquiredBinding.candidates s form =
      CrossSituational.candidates (bearsOn s.excluded form) offersOf s.repertoire s.records := by
  unfold AcquiredBinding.candidates CrossSituational.candidates
  congr 1
  funext e
  exact compatible_eq s form e

theorem resolve_eq (s : Lexicon) (form : List Sound) :
    resolve s form = CrossSituational.unique (AcquiredBinding.candidates s form) := by
  unfold resolve
  cases h : AcquiredBinding.candidates s form with
  | nil => rfl
  | cons x xs => cases xs <;> rfl

/-- The records separate the atom of `b` for its word: the atom is in the repertoire, every
admitted record of the word offers it, and every other meaning of the repertoire is missing from
some admitted record of the word. -/
def Separated (rep : List Expr) (excluded : List Nat) (records : List Encounter) (b : Bool) : Prop :=
  Expr.atom b ∈ rep ∧
    (∀ r, r ∈ records → r.origin ∉ excluded → r.form = word b → Expr.atom b ∈ r.offered) ∧
    ∀ m, m ∈ rep → m ≠ Expr.atom b →
      ∃ r, r ∈ records ∧ r.origin ∉ excluded ∧ r.form = word b ∧ m ∉ r.offered

/-- **Cross-situational binding of an acquired lexicon.** For every lexicon whose repertoire has
no repeats, the word of `b` resolves to its atom exactly when its admitted records separate the
atom. -/
theorem resolve_iff (s : Lexicon) (distinct : Becoming.Distinct s.repertoire) (b : Bool) :
    resolve s (word b) = some (Expr.atom b) ↔ Separated s.repertoire s.excluded s.records b := by
  rw [resolve_eq, candidates_eq, CrossSituational.resolves_iff distinct]
  constructor
  · rintro ⟨mem, cover, separate⟩
    refine ⟨mem, fun r rm ad fm => ?_, fun m mm ne => ?_⟩
    · have offered := cover r rm (by simp [bearsOn, ad, fm])
      simpa [offersOf] using offered
    · obtain ⟨r, rm, br, om⟩ := separate m mm ne
      simp only [bearsOn, decide_eq_true_eq] at br
      exact ⟨r, rm, br.1, br.2, by simpa [offersOf] using om⟩
  · rintro ⟨mem, cover, separate⟩
    refine ⟨mem, fun r rm br => ?_, fun m mm ne => ?_⟩
    · simp only [bearsOn, decide_eq_true_eq] at br
      simpa [offersOf] using cover r rm br.1 br.2
    · obtain ⟨r, rm, ad, fm, om⟩ := separate m mm ne
      exact ⟨r, rm, by simp [bearsOn, ad, fm], by simp [offersOf, om]⟩

/-- **Reading acquired words, exactly.** For every lexicon whose record groups the two-word
encoding and whose repertoire has no repeats, every encoded sequence is interpreted as the
assembly of its atoms exactly when, for each word, its admitted records separate its atom. -/
theorem interprets_every_iff_separated (s : Lexicon) (groups : Groups s.percept.log)
    (distinct : Becoming.Distinct s.repertoire) :
    (∀ ws, interpret s (encode ws) = assembleMessage (ws.map Expr.atom)) ↔
      ∀ b, Separated s.repertoire s.excluded s.records b :=
  (interprets_every_iff s groups).trans
    ⟨fun each b => (resolve_iff s distinct b).mp (each b),
     fun each b => (resolve_iff s distinct b).mpr (each b)⟩

end Binding

/-! ## Every history of an enacted scene -/

section Scene

open Generative.CompositionalAcquisition Generative.AcquiredSegmentation Generative.AcquiredBinding
open Generative.EnactedScene

/-- A move of an enacted scene: going to a place, or naming a site. -/
inductive SceneMove where
  | go (p : Place)
  | name (site : Nat)

/-- One move of the scene. -/
def sceneStep (s : Situation) : SceneMove → Situation
  | .go p => move p s
  | .name i => naming i s

/-- A history of moves. -/
def enact : Situation → List SceneMove → Situation
  | s, [] => s
  | s, a :: as => enact (sceneStep s a) as

/-- The record a move adds: naming the site of an atom, with support, records its word offering
the alternatives accessible from where the learner stands. -/
def heard (s : Situation) : SceneMove → List Encounter
  | .go _ => []
  | .name i =>
    match s.sites[i]? with
    | some (_, .atom b) =>
      if 1 ≤ s.lexicon.percept.machine.support then [⟨word b, visible s, 0⟩] else []
    | _ => []

/-- The records heard along a history. -/
def heardAlong : Situation → List SceneMove → List Encounter
  | _, [] => []
  | s, a :: as => heard s a ++ heardAlong (sceneStep s a) as

theorem encounter_inputs (raw : List Sound) (offered : List Expr) (origin : Nat) (s : Lexicon) :
    (encounter raw offered origin s).percept.log = s.percept.log ∧
      (encounter raw offered origin s).repertoire = s.repertoire ∧
      (encounter raw offered origin s).excluded = s.excluded := by
  unfold encounter
  split <;> exact ⟨rfl, rfl, rfl⟩

theorem single_word {log : List (Option Sound)} (groups : Groups log) (b : Bool) :
    chunks (bond log) (word b) = [word b] := by
  have once := segments_of_groups groups [b]
  simpa [encode] using once

theorem encounter_records {s : Lexicon} (groups : Groups s.percept.log) (b : Bool)
    (offered : List Expr) (origin : Nat) :
    (encounter (word b) offered origin s).records =
      if 1 ≤ s.percept.machine.support then s.records ++ [⟨word b, offered, origin⟩] else s.records := by
  unfold encounter
  by_cases hs : 1 ≤ s.percept.machine.support
  · simp [hs, single_word groups b]
  · simp [hs]

/-- **Every move keeps the record of transitions, the repertoire and the exclusions.** -/
theorem step_inputs (s : Situation) (a : SceneMove) :
    (sceneStep s a).lexicon.percept.log = s.lexicon.percept.log ∧
      (sceneStep s a).lexicon.repertoire = s.lexicon.repertoire ∧
      (sceneStep s a).lexicon.excluded = s.lexicon.excluded := by
  cases a with
  | go p =>
    show (move p s).lexicon.percept.log = _ ∧ (move p s).lexicon.repertoire = _ ∧
      (move p s).lexicon.excluded = _
    unfold move
    dsimp only
    split <;> exact ⟨rfl, rfl, rfl⟩
  | name i =>
    show (naming i s).lexicon.percept.log = _ ∧ (naming i s).lexicon.repertoire = _ ∧
      (naming i s).lexicon.excluded = _
    unfold naming
    cases s.sites[i]? with
    | none => exact ⟨rfl, rfl, rfl⟩
    | some item =>
      dsimp only
      cases nameForm item.2 with
      | none => exact ⟨rfl, rfl, rfl⟩
      | some raw => exact encounter_inputs raw (visible s) 0 s.lexicon

/-- **Naming records what was accessible.** Where the record of transitions groups the two-word
encoding, every move adds exactly the record `heard`: naming the site of an atom, with support,
records its word offering the alternatives accessible from where the learner stands. -/
theorem step_records (s : Situation) (groups : Groups s.lexicon.percept.log) (a : SceneMove) :
    (sceneStep s a).lexicon.records = s.lexicon.records ++ heard s a := by
  cases a with
  | go p =>
    show (move p s).lexicon.records = s.lexicon.records ++ []
    rw [moving_preserves_binding_records, List.append_nil]
  | name i =>
    show (naming i s).lexicon.records = _
    unfold naming heard
    cases h : s.sites[i]? with
    | none => simp [h]
    | some item =>
      obtain ⟨place, e⟩ := item
      cases e with
      | atom b =>
        simp only [nameForm, if_true]
        rw [encounter_records groups b]
        by_cases hs : 1 ≤ s.lexicon.percept.machine.support <;> simp [hs, h]
      | join _ _ => simp [nameForm, h]
      | twice _ => simp [nameForm, h]

theorem enact_inputs : ∀ (h : List SceneMove) (s : Situation),
    (enact s h).lexicon.percept.log = s.lexicon.percept.log ∧
      (enact s h).lexicon.repertoire = s.lexicon.repertoire ∧
      (enact s h).lexicon.excluded = s.lexicon.excluded
  | [], _ => ⟨rfl, rfl, rfl⟩
  | a :: as, s => by
    obtain ⟨l, r, e⟩ := enact_inputs as (sceneStep s a)
    obtain ⟨l', r', e'⟩ := step_inputs s a
    exact ⟨l.trans l', r.trans r', e.trans e'⟩

/-- **Along every history, the records are the earlier ones and those heard.** -/
theorem enact_records : ∀ (h : List SceneMove) (s : Situation), Groups s.lexicon.percept.log →
    (enact s h).lexicon.records = s.lexicon.records ++ heardAlong s h
  | [], _, _ => (List.append_nil _).symm
  | a :: as, s, groups => by
    have kept : Groups (sceneStep s a).lexicon.percept.log := (step_inputs s a).1 ▸ groups
    show (enact (sceneStep s a) as).lexicon.records = _
    rw [enact_records as (sceneStep s a) kept, step_records s groups a]
    show s.lexicon.records ++ heard s a ++ heardAlong (sceneStep s a) as =
      s.lexicon.records ++ (heard s a ++ heardAlong (sceneStep s a) as)
    rw [List.append_assoc]

/-- **Every history of an enacted scene.** From every situation whose record of transitions
groups the two-word encoding and whose repertoire has no repeats, after every history of moves
and namings, every encoded sequence is interpreted as the assembly of its atoms exactly when,
for each word, the earlier records and the namings heard along the history, each offering the
alternatives accessible where the learner stood, separate its atom. -/
theorem scene_interprets_every_iff (s : Situation) (groups : Groups s.lexicon.percept.log)
    (distinct : Becoming.Distinct s.lexicon.repertoire) (h : List SceneMove) :
    (∀ ws, interpret (enact s h).lexicon (encode ws) = assembleMessage (ws.map Expr.atom)) ↔
      ∀ b, Separated s.lexicon.repertoire s.lexicon.excluded
        (s.lexicon.records ++ heardAlong s h) b := by
  obtain ⟨log, rep, ex⟩ := enact_inputs h s
  rw [interprets_every_iff_separated _ (log ▸ groups) (rep ▸ distinct), enact_records h s groups,
    rep, ex]

/-- The coordinated history: name both sites, go to `(0, 1)`, name the first, go to `(2, 2)`,
name the second. -/
def coordinatedMoves : List SceneMove :=
  [.name 0, .name 1, .go (0, 1), .name 0, .go (2, 2), .name 1]

theorem coordinated_enacts (n : Nat) : coordinated n = enact (start n) coordinatedMoves := rfl

theorem start_groups : Groups (start 37).lexicon.percept.log := by unfold Groups; decide

theorem start_distinct (n : Nat) : Becoming.Distinct (start n).lexicon.repertoire := by
  show Becoming.Distinct [p0, p1, extra]
  unfold Becoming.Distinct Becoming.Distinct Becoming.Distinct
    Becoming.Distinct
  decide

/-- The four namings of the coordinated history and the alternatives accessible at each. -/
theorem coordinated_heard : heardAlong (start 37) coordinatedMoves =
    [⟨word false, [p0, p1], 0⟩, ⟨word true, [p0, p1], 0⟩, ⟨word false, [p0, extra], 0⟩,
      ⟨word true, [p1, extra], 0⟩] := by decide

theorem coordinated_separated (b : Bool) :
    Separated (start 37).lexicon.repertoire (start 37).lexicon.excluded
      ((start 37).lexicon.records ++ heardAlong (start 37) coordinatedMoves) b := by
  rw [coordinated_heard]
  unfold Separated
  cases b <;> decide

/-- **`coordinated 37` as an instance of the scene law**: each atom was accessible whenever its
name was heard, and each other meaning was inaccessible at one of those namings. -/
theorem coordinated_from_history (ws : List Bool) :
    interpret (coordinated 37).lexicon (encode ws) = assembleMessage (ws.map Expr.atom) := by
  rw [coordinated_enacts]
  exact (scene_interprets_every_iff (start 37) start_groups (start_distinct 37)
    coordinatedMoves).mpr coordinated_separated ws

/-- The stationary history names both sites twice from one place. -/
def stationaryMoves : List SceneMove := [.name 0, .name 1, .name 0, .name 1]

theorem stationary_enacts (n : Nat) : stationary n = enact (start n) stationaryMoves := rfl

/-- **The failing side, separation**: from one place the other atom is accessible at every
naming, so the sequence-wide interpretation fails. -/
theorem stationary_fails :
    ¬ ∀ ws, interpret (stationary 37).lexicon (encode ws) = assembleMessage (ws.map Expr.atom) := by
  rw [stationary_enacts, scene_interprets_every_iff (start 37) start_groups (start_distinct 37)]
  intro every
  have unseparated : ¬ Separated (start 37).lexicon.repertoire (start 37).lexicon.excluded
      ((start 37).lexicon.records ++ heardAlong (start 37) stationaryMoves) false := by
    unfold Separated
    decide
  exact unseparated (every false)

/-- The mistimed history names each site after going where it is not accessible. -/
def mistimedMoves : List SceneMove :=
  [.name 0, .name 1, .go (0, 1), .name 1, .go (2, 2), .name 0]

theorem mistimed_enacts (n : Nat) : mistimed n = enact (start n) mistimedMoves := rfl

/-- **The failing side, coverage**: each later naming is heard where its atom is not accessible,
so its record omits the target. -/
theorem mistimed_fails :
    ¬ ∀ ws, interpret (mistimed 37).lexicon (encode ws) = assembleMessage (ws.map Expr.atom) := by
  rw [mistimed_enacts, scene_interprets_every_iff (start 37) start_groups (start_distinct 37)]
  intro every
  have uncovered : ¬ Separated (start 37).lexicon.repertoire (start 37).lexicon.excluded
      ((start 37).lexicon.records ++ heardAlong (start 37) mistimedMoves) true := by
    unfold Separated
    decide
  exact uncovered (every true)

end Scene

/-! ## Cooperative naming -/

section Encounter

open Generative.CompositionalAcquisition Generative.AcquiredSegmentation Generative.AcquiredBinding
open Generative.EnactedScene Generative.EncounterChoice

/-- The records cooperative naming adds: one for each accessible atom, offering the accessible
alternatives. -/
def namedRecords (offered : List Expr) : List Expr → List Encounter
  | [] => []
  | .atom b :: es => ⟨word b, offered, 0⟩ :: namedRecords offered es
  | .join _ _ :: es => namedRecords offered es
  | .twice _ :: es => namedRecords offered es

theorem encounter_support (raw : List Sound) (offered : List Expr) (origin : Nat) (s : Lexicon) :
    (encounter raw offered origin s).percept.machine.support = s.percept.machine.support - 1 := by
  unfold encounter
  split
  · rfl
  · omega

/-- **Cooperative naming records each accessible atom.** Where the record of transitions groups
the two-word encoding and the support covers one naming per meaning named, naming the meanings
`es` while `offered` is accessible appends one record per atom among them, each offering
`offered`, and keeps the record of transitions, the repertoire and the exclusions. -/
theorem speak_records (offered : List Expr) : ∀ (es : List Expr) (s : Lexicon),
    Groups s.percept.log → es.length ≤ s.percept.machine.support →
      (speak es offered s).records = s.records ++ namedRecords offered es ∧
        (speak es offered s).percept.log = s.percept.log ∧
        (speak es offered s).repertoire = s.repertoire ∧
        (speak es offered s).excluded = s.excluded
  | [], s, _, _ => ⟨(List.append_nil _).symm, rfl, rfl, rfl⟩
  | e :: es, s, groups, support => by
    cases e with
    | atom b =>
      have enough : 1 ≤ s.percept.machine.support := by
        simp only [List.length_cons] at support
        omega
      have heard := encounter_records groups b offered 0 (s := s)
      rw [if_pos enough] at heard
      obtain ⟨log, rep, ex⟩ := encounter_inputs (word b) offered 0 s
      have rest : es.length ≤ (encounter (word b) offered 0 s).percept.machine.support := by
        rw [encounter_support]
        simp only [List.length_cons] at support
        omega
      obtain ⟨r, l, p, x⟩ := speak_records offered es (encounter (word b) offered 0 s)
        (log ▸ groups) rest
      show (speak es offered (encounter (word b) offered 0 s)).records = _ ∧
        (speak es offered (encounter (word b) offered 0 s)).percept.log = _ ∧
        (speak es offered (encounter (word b) offered 0 s)).repertoire = _ ∧
        (speak es offered (encounter (word b) offered 0 s)).excluded = _
      refine ⟨?_, l.trans log, p.trans rep, x.trans ex⟩
      rw [r, heard]
      simp [namedRecords]
    | join _ _ =>
      have rest : es.length ≤ s.percept.machine.support := by
        simp only [List.length_cons] at support
        omega
      exact speak_records offered es s groups rest
    | twice _ =>
      have rest : es.length ≤ s.percept.machine.support := by
        simp only [List.length_cons] at support
        omega
      exact speak_records offered es s groups rest

theorem word_eq_iff (c b : Bool) : word c = word b ↔ c = b := by
  cases c <;> cases b <;> decide

theorem stands_named (excluded : List Nat) (admitted : 0 ∉ excluded) (b : Bool)
    (offered : List Expr) (e : Expr) : ∀ es : List Expr,
    CrossSituational.stands (bearsOn excluded (word b)) offersOf (namedRecords offered es) e =
      (!(decide (Expr.atom b ∈ es)) || decide (e ∈ offered))
  | [] => by simp [CrossSituational.stands, namedRecords]
  | .atom c :: es => by
    rw [show namedRecords offered (.atom c :: es) = ⟨word c, offered, 0⟩ :: namedRecords offered es
      from rfl, CrossSituational.stands_cons, stands_named excluded admitted b offered e es]
    by_cases hc : c = b
    · subst hc
      by_cases ho : e ∈ offered <;> simp [bearsOn, offersOf, admitted, ho]
    · have hc' : ¬ b = c := fun h => hc h.symm
      by_cases ho : e ∈ offered <;> by_cases hm : Expr.atom b ∈ es <;>
        simp [bearsOn, offersOf, admitted, word_eq_iff, hc, hc', ho, hm]
  | .join x y :: es => by
    rw [show namedRecords offered (.join x y :: es) = namedRecords offered es from rfl,
      stands_named excluded admitted b offered e es]
    simp
  | .twice x :: es => by
    rw [show namedRecords offered (.twice x :: es) = namedRecords offered es from rfl,
      stands_named excluded admitted b offered e es]
    simp

/-- **Cooperative naming narrows exactly the words whose atoms are accessible.** For every
lexicon whose record of transitions groups the two-word encoding, with the naming source admitted
and support for one naming per accessible meaning: after naming every accessible atom, each
record offering the accessible alternatives, the candidates of the word of `b` are its earlier
candidates that are accessible where its atom is accessible, and its earlier candidates
otherwise. -/
theorem naming_narrows {s : Lexicon} (groups : Groups s.percept.log) (admitted : 0 ∉ s.excluded)
    {offered : List Expr} (support : offered.length ≤ s.percept.machine.support) (b : Bool) :
    AcquiredBinding.candidates (speak offered offered s) (word b) =
      if Expr.atom b ∈ offered then
        (AcquiredBinding.candidates s (word b)).filter (fun e => decide (e ∈ offered))
      else AcquiredBinding.candidates s (word b) := by
  obtain ⟨recs, _, rep, ex⟩ := speak_records offered offered s groups support
  rw [candidates_eq, candidates_eq, recs, rep, ex, CrossSituational.candidates_append]
  by_cases accessible : Expr.atom b ∈ offered
  · rw [if_pos accessible]
    exact CrossSituational.filter_congr (fun e => by
      rw [stands_named s.excluded admitted b offered e offered]
      simp [accessible]) _
  · rw [if_neg accessible]
    exact CrossSituational.filter_all_true (fun e => by
      rw [stands_named s.excluded admitted b offered e offered]
      simp [accessible]) _

/-- A visit's naming is cooperative naming of what is accessible there. -/
theorem local_naming_narrows (a : Activity) (groups : Groups a.situation.lexicon.percept.log)
    (admitted : 0 ∉ a.situation.lexicon.excluded)
    (support : (visible a.situation).length ≤ a.situation.lexicon.percept.machine.support)
    (b : Bool) :
    AcquiredBinding.candidates (localNaming a).situation.lexicon (word b) =
      if Expr.atom b ∈ visible a.situation then
        (AcquiredBinding.candidates a.situation.lexicon (word b)).filter
          (fun e => decide (e ∈ visible a.situation))
      else AcquiredBinding.candidates a.situation.lexicon (word b) :=
  naming_narrows groups admitted support b

theorem acquired_repertoire : (acquired 51).situation.lexicon.repertoire = [p0, p1, extra] := by
  decide

theorem acquired_distinct : Becoming.Distinct (acquired 51).situation.lexicon.repertoire := by
  rw [acquired_repertoire]
  exact start_distinct 0

/-- The records of the selected history separate both atoms. -/
theorem acquired_separated (b : Bool) :
    Separated (acquired 51).situation.lexicon.repertoire (acquired 51).situation.lexicon.excluded
      (acquired 51).situation.lexicon.records b := by
  unfold Separated
  cases b <;> decide

/-- **`acquired 51` as an instance of the separation law.** -/
theorem acquired_from_separation (ws : List Bool) :
    interpret (acquired 51).situation.lexicon (encode ws) = assembleMessage (ws.map Expr.atom) :=
  (interprets_every_iff_separated _ acquired_groups acquired_distinct).mpr acquired_separated ws

end Encounter

/-! ## Retrospective binding -/

section Retrospective

open Generative.CompositionalAcquisition Generative.AcquiredSegmentation Generative.AcquiredBinding
open Generative.RetrospectiveBinding

/-- **A retained packet's record offers exactly the atoms of the worlds that produce its
reports**: a learned route under an admitted fault. -/
theorem mem_alternatives (rs : List SourceReliance.Route) (faults : List SourceReliance.Faults)
    (reports : SourceReliance.Reports) (e : Expr) :
    e ∈ alternatives rs faults reports ↔
      ∃ w : SourceReliance.World, (w.route ∈ rs ∧ w.faults ∈ faults) ∧ Expr.atom w.target = e ∧
        SourceReliance.view w = reports := by
  unfold alternatives SourceReliance.compatible
  simp only [List.mem_map, List.mem_filter, SourceReliance.mem_enumerate, beq_iff_eq]
  constructor
  · rintro ⟨w, ⟨family, produced⟩, rfl⟩
    exact ⟨w, family, rfl, produced⟩
  · rintro ⟨w, family, rfl, produced⟩
    exact ⟨w, ⟨family, produced⟩, rfl⟩

/-- The binding view's candidates are those of its packets, read as records. -/
theorem view_candidates (s : Memory) (faults : List SourceReliance.Faults) (form : List Sound) :
    AcquiredBinding.candidates (bindingView s faults) form =
      CrossSituational.candidates (fun p : Packet => decide (p.form = form))
        (fun p e => decide (e ∈ alternatives (routes s) faults p.reports)) s.base.repertoire
        s.packets := by
  rw [candidates_eq]
  show List.filter _ s.base.repertoire = List.filter _ s.base.repertoire
  congr 1
  funext e
  simp [CrossSituational.stands, List.all_map, bearsOn, offersOf, bindingView, Function.comp_def]

/-- **Retrospective binding, exactly.** For every memory, fault envelope, form and target `b`:
where the repertoire has no repeats and holds the atom of `b`, and every packet of the form was
produced by some world (a learned route under an admitted fault) with target `b`, the binding
view resolves the form to that atom exactly when every other meaning of the repertoire is ruled
out by some packet of the form that no world with that meaning as its atom produces. -/
theorem retrospective_resolves_iff (s : Memory) (faults : List SourceReliance.Faults)
    (distinct : Becoming.Distinct s.base.repertoire) (form : List Sound) (b : Bool)
    (available : Expr.atom b ∈ s.base.repertoire)
    (produced : ∀ p, p ∈ s.packets → p.form = form → ∃ w : SourceReliance.World,
      (w.route ∈ routes s ∧ w.faults ∈ faults) ∧ w.target = b ∧ SourceReliance.view w = p.reports) :
    resolve (bindingView s faults) form = some (Expr.atom b) ↔
      ∀ m, m ∈ s.base.repertoire → m ≠ Expr.atom b → ∃ p, p ∈ s.packets ∧ p.form = form ∧
        ∀ w : SourceReliance.World, w.route ∈ routes s ∧ w.faults ∈ faults →
          Expr.atom w.target = m → SourceReliance.view w ≠ p.reports := by
  rw [resolve_eq, view_candidates, CrossSituational.unique_eq_some_iff,
    CrossSituational.resolves_explained_iff (fun w : SourceReliance.World =>
        w.route ∈ routes s ∧ w.faults ∈ faults) (fun w => Expr.atom w.target)
      (fun (p : Packet) w => SourceReliance.view w = p.reports)
      (fun p e => by simp only [decide_eq_true_eq]; exact mem_alternatives _ _ _ e)
      distinct available
      (fun p mem bears => by
        obtain ⟨w, family, target, view⟩ := produced p mem (by simpa using bears)
        exact ⟨w, family, congrArg Expr.atom target, view⟩)]
  constructor
  · intro ruled m mm ne
    obtain ⟨p, pm, bears, none⟩ := ruled m mm ne
    exact ⟨p, pm, by simpa using bears, none⟩
  · intro ruled m mm ne
    obtain ⟨p, pm, form', none⟩ := ruled m mm ne
    exact ⟨p, pm, by simpa using form', none⟩

/-- The old coverage premises (calibration by the actual route, every packet of the form realized
by it under an admitted fault) give the production premise. -/
theorem produced_of_calibration (s : Memory) (r : SourceReliance.Route) (reversed : Bool)
    (ps : List SourceReliance.Probe) (faults : List SourceReliance.Faults) (form : List Sound)
    (target : Bool) (calibration : s.calibration = SourceReliance.acquire r reversed ps)
    (realized : ∀ p ∈ s.packets, p.form = form →
      ∃ f ∈ faults, p.reports = SourceReliance.emit r ⟨target, f.1, f.2⟩) :
    ∀ p, p ∈ s.packets → p.form = form → ∃ w : SourceReliance.World,
      (w.route ∈ routes s ∧ w.faults ∈ faults) ∧ w.target = target ∧
        SourceReliance.view w = p.reports := by
  have rin : r ∈ SourceReliance.repertoire := by
    rcases r with ⟨a, b⟩
    cases a <;> cases b <;> decide
  have learned : r ∈ routes s := by
    rw [routes, calibration]
    exact SourceReliance.actual_route_retained r _ reversed ps rin
  intro p mem matching
  obtain ⟨f, hf, view⟩ := realized p mem matching
  exact ⟨⟨r, target, f⟩, ⟨learned, hf⟩, rfl, view.symm⟩

/-- **`acquired_routes_supply_binding_coverage` from the law**: under its premises every unique
resolution is the target (`CrossSituational.resolved_is_target`). -/
theorem coverage_from_law (s : Memory) (r : SourceReliance.Route) (reversed : Bool)
    (ps : List SourceReliance.Probe) (faults : List SourceReliance.Faults) (form : List Sound)
    (target : Bool) (answer : Expr) (calibration : s.calibration = SourceReliance.acquire r reversed ps)
    (available : Expr.atom target ∈ s.base.repertoire)
    (realized : ∀ p ∈ s.packets, p.form = form →
      ∃ f ∈ faults, p.reports = SourceReliance.emit r ⟨target, f.1, f.2⟩)
    (resolved : resolve (bindingView s faults) form = some answer) :
    answer = .atom target := by
  rw [resolve_eq, view_candidates, CrossSituational.unique_eq_some_iff] at resolved
  refine CrossSituational.resolved_is_target available (fun p mem bears => ?_) resolved
  obtain ⟨w, family, tw, view⟩ :=
    produced_of_calibration s r reversed ps faults form target calibration realized p mem
      (by simpa using bears)
  simp only [decide_eq_true_eq]
  exact (mem_alternatives _ _ _ _).mpr ⟨w, family, congrArg Expr.atom tw, view⟩

theorem retrospective_repertoire :
    (bindingView (retrospective 36) SourceReliance.allFaults).repertoire = [p0, p1, extra] := by
  decide

theorem retrospective_distinct :
    Becoming.Distinct (bindingView (retrospective 36) SourceReliance.allFaults).repertoire := by
  rw [retrospective_repertoire]
  exact start_distinct 0

/-- The two retained packets, reread through the learned route, separate both atoms. -/
theorem retrospective_separated (b : Bool) :
    Separated (bindingView (retrospective 36) SourceReliance.allFaults).repertoire
      (bindingView (retrospective 36) SourceReliance.allFaults).excluded
      (bindingView (retrospective 36) SourceReliance.allFaults).records b := by
  unfold Separated
  cases b <;> decide

/-- **`retrospective 36` as an instance of the separation law.** -/
theorem retrospective_from_separation (ws : List Bool) :
    interpret (bindingView (retrospective 36) SourceReliance.allFaults) (encode ws) =
      assembleMessage (ws.map Expr.atom) :=
  (interprets_every_iff_separated _ retrospective_groups retrospective_distinct).mpr
    retrospective_separated ws

/-- **The failing side, production**: after a real route change the earlier packet of the word
of `true` is produced by no learned world with that target, so its record omits the target
(`backward_transfer_can_fail_after_a_real_route_change`). -/
theorem changed_route_unproduced :
    Expr.atom true ∉ alternatives (routes changedRouteHistory) SourceReliance.allFaults
      (SourceReliance.emit ⟨false, true⟩ ⟨true, false, true⟩) := by decide

end Retrospective

/-! ## Where revision is warranted -/

section Warrant

open GoalFormationRevision

/-- **The comparison warrants learning over attendance exactly under access loss with kept
transition maintenance**, for every condition of the construction. -/
theorem better_iff (c : GoalFormationRevision.Conditions) :
    PracticalJudgment.Better (protects c) (gains c) .learning .attendance ↔
      c.accessLoss = true ∧ c.transitionLoss = false := by
  obtain ⟨a, t, r⟩ := c
  constructor
  · intro better
    cases a <;> cases t
    · exact absurd better (harmless_practices_incomparable ⟨false, false, r⟩ rfl rfl).2
    · exact absurd better (PracticalJudgment.no_protection_trade_by_count true
        (by simp [protects, perform]) (by simp [protects, perform]))
    · exact ⟨rfl, rfl⟩
    · exact absurd better (crossed_losses_incomparable ⟨true, true, r⟩ rfl rfl).1
  · rintro ⟨access, kept⟩
    exact warranted_revision _ access kept

/-- **The construction revises exactly where the comparison warrants it**: acquisition, revision
and reform complete for a condition exactly when learning is better than attendance there. -/
theorem completed_iff_better (c : GoalFormationRevision.Conditions) :
    (completed c).isSome = true ↔
      PracticalJudgment.Better (protects c) (gains c) .learning .attendance :=
  (completed_isSome_iff c).trans (better_iff c).symm

end Warrant

/-! ## A practice round -/

section Round

open JointPracticeContinuation

/-- The state after a practice round of reviewer `r` and worker `w`: the review recorded, the
context's method installed in the worker, the trial completed, nothing pending. -/
def afterRound (s : State) (r w : Nat) : State :=
  { s with
    org := { s.org with reviews := (r, w) :: s.org.reviews }
    methods := (w, s.context) :: s.methods
    trial := none
    response := none
    completed := ⟨w, false, s.context, s.context⟩ :: s.completed }

theorem apply_false (m : Bool) : applyMethod m false = m := by cases m <;> rfl

theorem infer_false (m : Bool) : inferMethod false m = m := by cases m <;> rfl

/-- **A practice round, exactly.** From every state, the round of attempt, response, revision and
tested retry by reviewer `r` and worker `w` completes exactly when the worker is present and the
reviewer is a present roster member other than the worker whose recorded method answers as the
current context does; it then records the review, installs the context's method in the worker,
completes the trial, and changes nothing else. -/
theorem round_iff (s t : State) (r w : Nat) :
    run s (practice r w) = some t ↔
      (w ∈ s.org.present ∧ r ∈ s.org.roster ∧ r ∈ s.org.present ∧ r ≠ w ∧
        methodAt s r = s.context) ∧ t = afterRound s r w := by
  by_cases hw : w ∈ s.org.present
  case neg => simp [practice, run, step, hw]
  by_cases hr : r ∈ s.org.roster
  case neg => simp [practice, run, step, hw, hr]
  by_cases hrp : r ∈ s.org.present
  case neg => simp [practice, run, step, hw, hr, hrp]
  by_cases hne : r = w
  case pos => simp [practice, run, step, hw, hne]
  by_cases hm : methodAt s r = s.context
  case neg =>
    have hm' := hm
    simp only [methodAt] at hm'
    simp [practice, run, step, hw, hr, hrp, hne, hm', apply_false, methodAt]
  have hm' := hm
  simp only [methodAt] at hm'
  simp [practice, run, step, hw, hr, hrp, hne, hm', apply_false, methodAt,
    result_revision_eq_inference, infer_false, OrganizationalRuleInheritance.step, afterRound]
  exact eq_comm

/-- **A round trains its worker**: after it, the worker's recorded method is the context's. -/
theorem round_trains {s t : State} {r w : Nat} (ran : run s (practice r w) = some t) :
    methodAt t w = t.context := by
  obtain ⟨_, rfl⟩ := (round_iff s t r w).mp ran
  simp [methodAt, afterRound]

/-- **A trained worker reviews without a further check.** From every state in which the reviewer's
recorded method is the context's, a round of reviewer `w` and worker `v` completes exactly when
`v` is present and `w` is a present roster member other than `v`. -/
theorem trained_round_iff (u x : State) (w v : Nat) (trained : methodAt u w = u.context) :
    run u (practice w v) = some x ↔
      (v ∈ u.org.present ∧ w ∈ u.org.roster ∧ w ∈ u.org.present ∧ w ≠ v) ∧
        x = afterRound u w v :=
  (round_iff u x w v).trans
    ⟨fun ⟨⟨hv, hw, hwp, ne, _⟩, eq⟩ => ⟨⟨hv, hw, hwp, ne⟩, eq⟩,
     fun ⟨⟨hv, hw, hwp, ne⟩, eq⟩ => ⟨⟨hv, hw, hwp, ne, trained⟩, eq⟩⟩

/-- **Training is kept along every course without revision that returns to the context**: the
recorded methods change only by revision (`methods_kept`). -/
theorem trained_along {s t : State} {es : List Event} {w : Nat}
    (path : Generative.Trace JointPracticeContinuation.process s es t)
    (none_revise : ∀ e, e ∈ es → revises e = false) (same : t.context = s.context)
    (trained : methodAt s w = s.context) : methodAt t w = t.context := by
  have kept : t.methods = s.methods := methods_inherited path none_revise
  rw [same]
  unfold methodAt
  rw [kept]
  exact trained

/-- **The three rounds of the complete history are instances of the round law**; the
enrollments and the handoff between them are the organization's own steps. -/
theorem complete_history_rounds :
    run initial (practice 0 1) = some (afterRound initial 0 1) ∧
      run first (practice 1 2) = some (afterRound first 1 2) ∧
      run (after second [.organizational (.handoff [1, 2, 3, 4, 5])]) (practice 1 3) =
        some (afterRound (after second [.organizational (.handoff [1, 2, 3, 4, 5])]) 1 3) :=
  ⟨(round_iff _ _ 0 1).mpr ⟨by decide, rfl⟩, (round_iff _ _ 1 2).mpr ⟨by decide, rfl⟩,
   (round_iff _ _ 1 3).mpr ⟨by decide, rfl⟩⟩

end Round

end Becoming.MachineInstances
