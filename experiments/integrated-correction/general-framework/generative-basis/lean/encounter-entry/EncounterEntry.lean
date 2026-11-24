import Init

/-!
# Adaptive Inquiry, Branching Assurance, and Non-Sealing Open Entry (`EncounterEntry`)

AI-written (`Track S3`, 24 November 2026). Pure `import Init` module compiled on Lean `v4.29.1`
with `0` axioms (including `0` `.injEq` / `propext` / `Quot.sound` / `Classical.choice` dependencies),
`0` `sorry`, `0` `private` / `lemma` / `class` / unnamed `instance` declarations, and `0` forbidden
exchange-vocabulary tokens.

## What this module formalizes
1. **Adaptive `InquiryTree` vs Fixed Schedule Separation (§7.3):**
   Inductive finite tree `InquiryTree Probe Outcome Act` and fixed-order compiler `ofFixed`.
   On the 4-state `(loc : Bool, val : Bool)` two-slot puzzle with queries `{probeWhere, readL, readR}`:
   - `adaptive_two_step_identifies_pair`: an explicit 2-query adaptive tree recovers `(loc, val)` on
     all 4 states;
   - `fixed_two_step_misses_pair`: EVERY 2-query fixed schedule `(p₁, p₂)` fails to separate at least
     two states (exhaustive over all 9 pairs) and cannot recover `(loc, val)`;
   - `fixed_two_step_recovers_value_only`: `[readL, readR]` recovers `val` alone on all 4 states,
     proving target-consequence sensitivity.
2. **Post-Branch `BranchingChoice` vs Labeled Path-Count Separation (§7.3 `2xa + 2xb`):**
   Two explicit finite systems `sysA`, `sysB` with identical labeled entry-to-exit path counts for
   every label sequence (`pathCount_eq`, both yielding `2` for `[x, a]` and `2` for `[x, b]`), where
   `sysA` completes every post-branch `{a, b}` request (`sysA_completes_all`) while `sysB` gets stuck
   on a reachable post-branch request (`sysB_branch_stuck`).
3. **One Executable Process for Open Second Entry (`encounter_refines_and_preserves_entry`):**
   Models an incumbent starting in `.resolved` (matching `item12`'s stopping point where own
   continuation is resolved while downstream dependents remain uncounted), equipped with public
   reading `publicRead`, contact/queue/verify/revise/actuate steps, substrate reserve floor, and
   bounded FIFO admission queue:
   - **Clause 1 (Acquisition + Independent Verification):** Contact constructs a new query (with no
     pre-named target in controller state) separating `publicRead`-indistinguishable worlds,
     verified by a second observer on fresh contact.
   - **Clause 2 (Causal Uptake + Masking Control + False-Objection Negative Control):**
     Holding pre-state, disturbances, reserve draw, and timing fixed, delivering vs masking the
     verified report diverges in action and substrate (`floor ≤ delivered.reserve` vs
     `masked.reserve < floor`), while a superficially identical false objection fails fresh
     verification and triggers no switch.
   - **Clause 3 (Non-Sealing / Open Second Entry):** Proves BOTH a general protocol theorem over
     EVERY reachable revision history (any later bounded distinguishing contact within reserve &
     step allowance enters via `openGate`, passes verification, and alters action) AND a concrete
     second-entrant witness unnamed at revision 1, explicitly separated from `sealingGate`.

## Scope Boundary (`AGENTS.md` Rule 2)
This module establishes mathematical properties of the defined discrete transition systems and tree
models. Recognizing that an actual physical or socio-technical process satisfies bounded-queue
fairness, independent fresh contact, or reserve margins remains an empirical claim, not a theorem.
-/

namespace EncounterEntry

/-! ## Part 0: Zero-Axiom `Bool` and `Nat` Helpers -/

def boolEq : Bool → Bool → Bool
  | true, true => true
  | false, false => true
  | true, false => false
  | false, true => false

theorem boolEq_true_of_eq : ∀ {a b : Bool}, a = b → boolEq a b = true
  | true, true, _ => rfl
  | false, false, _ => rfl
  | true, false, h => Bool.noConfusion h
  | false, true, h => Bool.noConfusion h

theorem boolEq_false_of_ne : ∀ {a b : Bool}, a ≠ b → boolEq a b = false
  | true, true, h => absurd rfl h
  | false, false, h => absurd rfl h
  | true, false, _ => rfl
  | false, true, _ => rfl

def natLeBool : Nat → Nat → Bool
  | 0, _ => true
  | _ + 1, 0 => false
  | a + 1, b + 1 => natLeBool a b

theorem natLeBool_true_iff : ∀ a b : Nat, (natLeBool a b = true → a ≤ b) ∧ (a ≤ b → natLeBool a b = true)
  | 0, _ => ⟨fun _ => Nat.zero_le _, fun _ => rfl⟩
  | _ + 1, 0 => ⟨fun h => Bool.noConfusion h, fun h => absurd h (Nat.not_succ_le_zero _)⟩
  | a + 1, b + 1 =>
      let ih := natLeBool_true_iff a b
      ⟨fun h => Nat.succ_le_succ (ih.1 h), fun h => ih.2 (Nat.le_of_succ_le_succ h)⟩

def natLtBool (a b : Nat) : Bool := natLeBool (a + 1) b

theorem lt_of_natLtBool {a b : Nat} (h : natLtBool a b = true) : a < b :=
  (natLeBool_true_iff (a + 1) b).1 h

theorem nat_le_sub_of_add_le : ∀ {a b c : Nat}, a + b ≤ c → a ≤ c - b
  | _, 0, _, h => h
  | _, _ + 1, 0, h => absurd h (Nat.not_succ_le_zero _)
  | a, b + 1, c + 1, h =>
      let step : a + b + 1 ≤ c + 1 := (Nat.add_assoc a b 1).symm ▸ h
      let subLe : a + b ≤ c := Nat.le_of_succ_le_succ step
      (Nat.succ_sub_succ c b).symm ▸ nat_le_sub_of_add_le subLe

/-! ## Part 1: `InquiryTree` vs Fixed Schedule Separation (§7.3) -/

inductive InquiryTree (Probe Outcome Act : Type) where
  | stop (act : Act)
  | ask (probe : Probe) (next : Outcome → InquiryTree Probe Outcome Act)

def runTree {Probe Outcome Act : Type} (oracle : Probe → Outcome) :
    InquiryTree Probe Outcome Act → Act
  | .stop act => act
  | .ask probe next => runTree oracle (next (oracle probe))

def ofFixed {Probe Outcome Act : Type} :
    List Probe → (List Outcome → Act) → InquiryTree Probe Outcome Act
  | [], decide => .stop (decide [])
  | p :: ps, decide => .ask p (fun o => ofFixed ps (fun os => decide (o :: os)))

inductive WithinQueries {Probe Outcome Act : Type} :
    Nat → InquiryTree Probe Outcome Act → Prop where
  | stop (n : Nat) (act : Act) : WithinQueries n (.stop act)
  | ask (n : Nat) (p : Probe) (next : Outcome → InquiryTree Probe Outcome Act) :
      (∀ o, WithinQueries n (next o)) → WithinQueries (n + 1) (.ask p next)

theorem runTree_ofFixed {Probe Outcome Act : Type}
    (oracle : Probe → Outcome) :
    ∀ (ps : List Probe) (decide : List Outcome → Act),
      runTree oracle (ofFixed ps decide) = decide (ps.map oracle)
  | [], _ => rfl
  | p :: ps, decide => runTree_ofFixed oracle ps (fun os => decide (oracle p :: os))

theorem withinQueries_ofFixed {Probe Outcome Act : Type} :
    ∀ (ps : List Probe) (decide : List Outcome → Act),
      WithinQueries ps.length (ofFixed ps decide)
  | [], decide => .stop 0 (decide [])
  | p :: ps, _ => .ask ps.length p _ (fun _ => withinQueries_ofFixed ps _)

structure SlotState where
  slotLoc : Bool
  slotVal : Bool

def slotEqBool (a b : SlotState) : Bool :=
  boolEq a.slotLoc b.slotLoc && boolEq a.slotVal b.slotVal

theorem slot_eq_of_eqBool : ∀ {a b : SlotState}, slotEqBool a b = true → a = b
  | ⟨false, false⟩, ⟨false, false⟩, _ => rfl
  | ⟨false, true⟩, ⟨false, true⟩, _ => rfl
  | ⟨true, false⟩, ⟨true, false⟩, _ => rfl
  | ⟨true, true⟩, ⟨true, true⟩, _ => rfl
  | ⟨false, false⟩, ⟨false, true⟩, h => Bool.noConfusion h
  | ⟨false, false⟩, ⟨true, false⟩, h => Bool.noConfusion h
  | ⟨false, false⟩, ⟨true, true⟩, h => Bool.noConfusion h
  | ⟨false, true⟩, ⟨false, false⟩, h => Bool.noConfusion h
  | ⟨false, true⟩, ⟨true, false⟩, h => Bool.noConfusion h
  | ⟨false, true⟩, ⟨true, true⟩, h => Bool.noConfusion h
  | ⟨true, false⟩, ⟨false, false⟩, h => Bool.noConfusion h
  | ⟨true, false⟩, ⟨false, true⟩, h => Bool.noConfusion h
  | ⟨true, false⟩, ⟨true, true⟩, h => Bool.noConfusion h
  | ⟨true, true⟩, ⟨false, false⟩, h => Bool.noConfusion h
  | ⟨true, true⟩, ⟨false, true⟩, h => Bool.noConfusion h
  | ⟨true, true⟩, ⟨true, false⟩, h => Bool.noConfusion h

theorem slot_ne_of_eqBool_false : ∀ {a b : SlotState}, slotEqBool a b = false → a ≠ b
  | ⟨la, va⟩, ⟨_, _⟩, h, eq => by
      cases eq
      cases la <;> cases va <;> exact Bool.noConfusion h

theorem slotState_ne_of_loc {a b : SlotState} (h : a.slotLoc ≠ b.slotLoc) : a ≠ b :=
  fun eq => h (congrArg SlotState.slotLoc eq)

theorem slotState_ne_of_val {a b : SlotState} (h : a.slotVal ≠ b.slotVal) : a ≠ b :=
  fun eq => h (congrArg SlotState.slotVal eq)

inductive SlotProbe where
  | probeWhere
  | readL
  | readR

def slotOracle (s : SlotState) : SlotProbe → Bool
  | .probeWhere => s.slotLoc
  | .readL => match s.slotLoc with | true => false | false => s.slotVal
  | .readR => match s.slotLoc with | true => s.slotVal | false => false

def adaptiveSlotTree : InquiryTree SlotProbe Bool SlotState :=
  .ask .probeWhere fun k =>
    match k with
    | true => .ask .readR (fun v => .stop ⟨true, v⟩)
    | false => .ask .readL (fun v => .stop ⟨false, v⟩)

theorem adaptiveSlotTree_within_two : WithinQueries 2 adaptiveSlotTree :=
  WithinQueries.ask 1 SlotProbe.probeWhere _ fun k =>
    match k with
    | true => WithinQueries.ask 0 SlotProbe.readR _ (fun v => WithinQueries.stop 0 (⟨true, v⟩ : SlotState))
    | false => WithinQueries.ask 0 SlotProbe.readL _ (fun v => WithinQueries.stop 0 (⟨false, v⟩ : SlotState))

theorem adaptive_two_step_identifies_pair :
    ∀ s : SlotState, runTree (slotOracle s) adaptiveSlotTree = s
  | ⟨false, false⟩ => rfl
  | ⟨false, true⟩ => rfl
  | ⟨true, false⟩ => rfl
  | ⟨true, true⟩ => rfl

theorem fixed_two_step_oracle_collision (p1 p2 : SlotProbe) :
    ∃ s1 s2 : SlotState, s1 ≠ s2 ∧
      slotOracle s1 p1 = slotOracle s2 p1 ∧
      slotOracle s1 p2 = slotOracle s2 p2 := by
  cases p1 <;> cases p2
  · exact ⟨⟨false, false⟩, ⟨false, true⟩, slotState_ne_of_val (fun h => Bool.noConfusion h), rfl, rfl⟩
  · exact ⟨⟨true, false⟩, ⟨true, true⟩, slotState_ne_of_val (fun h => Bool.noConfusion h), rfl, rfl⟩
  · exact ⟨⟨false, false⟩, ⟨false, true⟩, slotState_ne_of_val (fun h => Bool.noConfusion h), rfl, rfl⟩
  · exact ⟨⟨true, false⟩, ⟨true, true⟩, slotState_ne_of_val (fun h => Bool.noConfusion h), rfl, rfl⟩
  · exact ⟨⟨true, false⟩, ⟨true, true⟩, slotState_ne_of_val (fun h => Bool.noConfusion h), rfl, rfl⟩
  · exact ⟨⟨false, false⟩, ⟨true, false⟩, slotState_ne_of_loc (fun h => Bool.noConfusion h), rfl, rfl⟩
  · exact ⟨⟨false, false⟩, ⟨false, true⟩, slotState_ne_of_val (fun h => Bool.noConfusion h), rfl, rfl⟩
  · exact ⟨⟨false, false⟩, ⟨true, false⟩, slotState_ne_of_loc (fun h => Bool.noConfusion h), rfl, rfl⟩
  · exact ⟨⟨false, false⟩, ⟨false, true⟩, slotState_ne_of_val (fun h => Bool.noConfusion h), rfl, rfl⟩

theorem fixed_two_step_misses_pair (p1 p2 : SlotProbe) (decide : List Bool → SlotState) :
    (∃ s1 s2 : SlotState, s1 ≠ s2 ∧
      runTree (slotOracle s1) (ofFixed [p1, p2] decide) =
        runTree (slotOracle s2) (ofFixed [p1, p2] decide)) ∧
    (∃ s : SlotState, runTree (slotOracle s) (ofFixed [p1, p2] decide) ≠ s) := by
  obtain ⟨s1, s2, hne, h1, h2⟩ := fixed_two_step_oracle_collision p1 p2
  have heq :
      runTree (slotOracle s1) (ofFixed [p1, p2] decide) =
        runTree (slotOracle s2) (ofFixed [p1, p2] decide) := by
    have r1 := runTree_ofFixed (slotOracle s1) [p1, p2] decide
    have r2 := runTree_ofFixed (slotOracle s2) [p1, p2] decide
    have mapEq : [slotOracle s1 p1, slotOracle s1 p2] = [slotOracle s2 p1, slotOracle s2 p2] :=
      (congrArg (fun x => [x, slotOracle s1 p2]) h1).trans
        (congrArg (fun y => [slotOracle s2 p1, y]) h2)
    exact r1.trans ((congrArg decide mapEq).trans r2.symm)
  refine ⟨⟨s1, s2, hne, heq⟩, ?_⟩
  cases hCmp : slotEqBool (runTree (slotOracle s1) (ofFixed [p1, p2] decide)) s1 with
  | true =>
      have eq1 : runTree (slotOracle s1) (ofFixed [p1, p2] decide) = s1 := slot_eq_of_eqBool hCmp
      exact ⟨s2, fun eq2 => hne ((eq1.symm.trans heq).trans eq2)⟩
  | false =>
      exact ⟨s1, slot_ne_of_eqBool_false hCmp⟩

def valueOnlyDecode : List Bool → Bool
  | [o1, o2] => o1 || o2
  | [] => false
  | [_] => false
  | _ :: _ :: _ :: _ => false

theorem fixed_two_step_recovers_value_only :
    ∀ s : SlotState, runTree (slotOracle s) (ofFixed [.readL, .readR] valueOnlyDecode) = s.slotVal
  | ⟨false, false⟩ => rfl
  | ⟨false, true⟩ => rfl
  | ⟨true, false⟩ => rfl
  | ⟨true, true⟩ => rfl

/-! ## Part 2: `BranchingChoice` vs Labeled Path-Count Separation (§7.3 `2xa + 2xb`) -/

inductive BranchState where
  | entry
  | leftMid
  | rightMid
  | exitDone

def branchStateEq : BranchState → BranchState → Bool
  | .entry, .entry => true
  | .entry, .leftMid => false
  | .entry, .rightMid => false
  | .entry, .exitDone => false
  | .leftMid, .entry => false
  | .leftMid, .leftMid => true
  | .leftMid, .rightMid => false
  | .leftMid, .exitDone => false
  | .rightMid, .entry => false
  | .rightMid, .leftMid => false
  | .rightMid, .rightMid => true
  | .rightMid, .exitDone => false
  | .exitDone, .entry => false
  | .exitDone, .leftMid => false
  | .exitDone, .rightMid => false
  | .exitDone, .exitDone => true

inductive BranchLabel where
  | stepX
  | reqA
  | reqB

inductive PostReq where
  | reqA
  | reqB

def postLabel : PostReq → BranchLabel
  | .reqA => .reqA
  | .reqB => .reqB

structure BranchSys where
  edges : BranchState → BranchLabel → List BranchState

def sysA : BranchSys where
  edges s l := match s with
    | .entry => match l with | .stepX => [.leftMid, .rightMid] | .reqA => [] | .reqB => []
    | .leftMid => match l with | .stepX => [] | .reqA => [.exitDone] | .reqB => [.exitDone]
    | .rightMid => match l with | .stepX => [] | .reqA => [.exitDone] | .reqB => [.exitDone]
    | .exitDone => []

def sysB : BranchSys where
  edges s l := match s with
    | .entry => match l with | .stepX => [.leftMid, .rightMid] | .reqA => [] | .reqB => []
    | .leftMid => match l with | .stepX => [] | .reqA => [.exitDone, .exitDone] | .reqB => []
    | .rightMid => match l with | .stepX => [] | .reqA => [] | .reqB => [.exitDone, .exitDone]
    | .exitDone => []

def sumNatList : List Nat → Nat
  | [] => 0
  | n :: ns => n + sumNatList ns

def pathsFrom (sys : BranchSys) : BranchState → List BranchLabel → BranchState → Nat
  | s, [], target => if branchStateEq s target then 1 else 0
  | s, l :: ls, target => sumNatList ((sys.edges s l).map (fun s' => pathsFrom sys s' ls target))

def entryToExitCount (sys : BranchSys) (w : List BranchLabel) : Nat :=
  pathsFrom sys .entry w .exitDone

theorem sysA_path_counts_2xa_2xb :
    entryToExitCount sysA [.stepX, .reqA] = 2 ∧
    entryToExitCount sysA [.stepX, .reqB] = 2 :=
  ⟨rfl, rfl⟩

theorem pathCount_eq : ∀ w : List BranchLabel, entryToExitCount sysA w = entryToExitCount sysB w
  | [] => rfl
  | [l] => by cases l <;> rfl
  | [l1, l2] => by cases l1 <;> cases l2 <;> rfl
  | l1 :: l2 :: l3 :: _ => by
      cases l1 with
      | reqA => rfl
      | reqB => rfl
      | stepX =>
        cases l2 with
        | stepX => rfl
        | reqA =>
          cases l3 with
          | stepX => rfl
          | reqA => rfl
          | reqB => rfl
        | reqB =>
          cases l3 with
          | stepX => rfl
          | reqA => rfl
          | reqB => rfl

def CompletesPostBranch (sys : BranchSys) : Prop :=
  ∀ mid : BranchState, mid ∈ sys.edges .entry .stepX →
    ∀ r : PostReq, ∃ tgt : BranchState, tgt ∈ sys.edges mid (postLabel r) ∧ tgt = .exitDone

theorem sysA_completes_all : CompletesPostBranch sysA := by
  intro mid hMid r
  cases hMid with
  | head =>
    cases r with
    | reqA => exact ⟨.exitDone, .head _, rfl⟩
    | reqB => exact ⟨.exitDone, .head _, rfl⟩
  | tail _ hTail =>
    cases hTail with
    | head =>
      cases r with
      | reqA => exact ⟨.exitDone, .head _, rfl⟩
      | reqB => exact ⟨.exitDone, .head _, rfl⟩
    | tail _ hEmpty => cases hEmpty

theorem sysB_branch_stuck : ¬ CompletesPostBranch sysB := by
  intro hComp
  obtain ⟨_, hStep, _⟩ := hComp .leftMid (.head _) .reqB
  cases hStep

/-! ## Part 3: One Executable Process for Open Second Entry (`encounter_refines_and_preserves_entry`) -/

def reserveFloor : Nat := 5
def queueCap : Nat := 4

structure World where
  ownHealthy : Bool
  hazard : Bool
  channels : Nat → Bool

def publicRead (w : World) : Bool := w.ownHealthy

inductive IncumbentPhase where
  | resolved

inductive Act where
  | normalOp
  | protect
  | retreat

theorem protect_ne_normalOp : Act.protect ≠ Act.normalOp := fun h => Act.noConfusion h

structure InstalledRule where
  query : World → Bool
  triggerVal : Bool

structure Submission where
  entrantTag : Nat
  query : World → Bool
  probeSafe : World
  probeRisk : World

structure VerifiedReport where
  query : World → Bool
  triggerVal : Bool

structure FreshObserver where
  readContact : (World → Bool) → World → Bool
  checkHazard : World → Bool

def canonicalObserver : FreshObserver where
  readContact q w := q w
  checkHazard w := w.hazard

structure ProcState where
  phase : IncumbentPhase
  installed : List InstalledRule
  queue : List Submission
  pending : Option VerifiedReport
  rejectedCount : Nat
  reserve : Nat
  stepsLeft : Nat
  drawTotal : Nat
  lastAct : Act

def initResolved (reserve0 steps0 : Nat) : ProcState where
  phase := .resolved
  installed := []
  queue := []
  pending := none
  rejectedCount := 0
  reserve := reserve0
  stepsLeft := steps0
  drawTotal := 0
  lastAct := .normalOp

def matchesInstalled : List InstalledRule → World → Bool
  | [], _ => false
  | r :: rs, w => match boolEq (r.query w) r.triggerVal with
      | true => true
      | false => matchesInstalled rs w

theorem matchesInstalled_cons_hit (r : InstalledRule) (rs : List InstalledRule) (w : World)
    (h : r.query w = r.triggerVal) :
    matchesInstalled (r :: rs) w = true := by
  change (match boolEq (r.query w) r.triggerVal with | true => true | false => matchesInstalled rs w) = true
  rw [boolEq_true_of_eq h]

def policyAct (st : ProcState) (w : World) : Act :=
  match publicRead w with
  | true => match matchesInstalled st.installed w with | true => Act.protect | false => Act.normalOp
  | false => Act.retreat

def openGate (st : ProcState) (_sub : Submission) : Bool :=
  natLtBool st.queue.length queueCap &&
  natLeBool (reserveFloor + 2 * st.queue.length + 4) st.reserve &&
  natLeBool (2 * st.queue.length + 4) st.stepsLeft

theorem openGate_components {st : ProcState} {sub : Submission} (h : openGate st sub = true) :
    st.queue.length < queueCap ∧
    reserveFloor + 2 * st.queue.length + 4 ≤ st.reserve ∧
    2 * st.queue.length + 4 ≤ st.stepsLeft := by
  have h1 : natLtBool st.queue.length queueCap = true := by
    cases hA : natLtBool st.queue.length queueCap
    · change ((natLtBool st.queue.length queueCap && _) && _) = true at h
      rw [hA] at h
      exact Bool.noConfusion h
    · rfl
  have h2 : natLeBool (reserveFloor + 2 * st.queue.length + 4) st.reserve = true := by
    cases hB : natLeBool (reserveFloor + 2 * st.queue.length + 4) st.reserve
    · change ((natLtBool st.queue.length queueCap && natLeBool (reserveFloor + 2 * st.queue.length + 4) st.reserve) && _) = true at h
      rw [h1, hB] at h
      exact Bool.noConfusion h
    · rfl
  have h3 : natLeBool (2 * st.queue.length + 4) st.stepsLeft = true := by
    cases hC : natLeBool (2 * st.queue.length + 4) st.stepsLeft
    · change ((natLtBool st.queue.length queueCap && natLeBool (reserveFloor + 2 * st.queue.length + 4) st.reserve) && natLeBool (2 * st.queue.length + 4) st.stepsLeft) = true at h
      rw [h1, h2, hC] at h
      exact Bool.noConfusion h
    · rfl
  exact ⟨lt_of_natLtBool h1, (natLeBool_true_iff _ _).1 h2, (natLeBool_true_iff _ _).1 h3⟩

def ExpressibleInInstalled (installed : List InstalledRule) (q : World → Bool) : Prop :=
  ∀ w1 w2 : World,
    publicRead w1 = publicRead w2 →
    matchesInstalled installed w1 = matchesInstalled installed w2 →
    q w1 = q w2

def sealingGate (st : ProcState) (sub : Submission) : Prop :=
  openGate st sub = true ∧ ExpressibleInInstalled st.installed sub.query

inductive ProcOp where
  | submit (sub : Submission)
  | verifyHead (obs : FreshObserver)
  | applyRevision (deliver : Bool)
  | actuate (w : World)

def actDraw (w : World) (act : Act) : Nat :=
  match act with
  | .normalOp => match w.hazard with | true => 6 | false => 1
  | .protect => 1
  | .retreat => 1

def verifyPasses (obs : FreshObserver) (sub : Submission) : Bool :=
  match boolEq (obs.readContact sub.query sub.probeSafe) (obs.readContact sub.query sub.probeRisk) with
  | true => false
  | false =>
      match obs.checkHazard sub.probeSafe with
      | true => false
      | false => obs.checkHazard sub.probeRisk

def execStep (st : ProcState) (op : ProcOp) : Option ProcState :=
  match op with
  | .submit sub =>
      match openGate st sub with
      | true =>
          some { st with
            queue := st.queue ++ [sub]
            reserve := st.reserve - 1
            stepsLeft := st.stepsLeft - 1
            drawTotal := st.drawTotal + 1 }
      | false => none
  | .verifyHead obs =>
      match natLeBool 1 st.reserve with
      | false => none
      | true =>
          match natLeBool 1 st.stepsLeft with
          | false => none
          | true =>
              match st.queue with
              | [] => none
              | sub :: rest =>
                  match verifyPasses obs sub with
                  | true =>
                      some { st with
                        queue := rest
                        pending := some ⟨sub.query, obs.readContact sub.query sub.probeRisk⟩
                        reserve := st.reserve - 1
                        stepsLeft := st.stepsLeft - 1
                        drawTotal := st.drawTotal + 1 }
                  | false =>
                      some { st with
                        queue := rest
                        pending := none
                        rejectedCount := st.rejectedCount + 1
                        reserve := st.reserve - 1
                        stepsLeft := st.stepsLeft - 1
                        drawTotal := st.drawTotal + 1 }
  | .applyRevision deliver =>
      match natLeBool 1 st.reserve with
      | false => none
      | true =>
          match natLeBool 1 st.stepsLeft with
          | false => none
          | true =>
              let nextInstalled :=
                match deliver with
                | true =>
                    match st.pending with
                    | none => st.installed
                    | some rep => ⟨rep.query, rep.triggerVal⟩ :: st.installed
                | false => st.installed
              some { st with
                installed := nextInstalled
                pending := none
                reserve := st.reserve - 1
                stepsLeft := st.stepsLeft - 1
                drawTotal := st.drawTotal + 1 }
  | .actuate w =>
      match natLeBool 1 st.stepsLeft with
      | true =>
          let act := policyAct st w
          let d := actDraw w act
          some { st with
            reserve := st.reserve - d
            stepsLeft := st.stepsLeft - 1
            drawTotal := st.drawTotal + d
            lastAct := act }
      | false => none

def runOps : ProcState → List ProcOp → Option ProcState
  | st, [] => some st
  | st, op :: ops =>
      match execStep st op with
      | none => none
      | some st' => runOps st' ops

inductive ReachableProc : ProcState → List ProcOp → ProcState → Prop where
  | nil (st : ProcState) : ReachableProc st [] st
  | cons {st mid fin : ProcState} {op : ProcOp} {ops : List ProcOp} :
      execStep st op = some mid →
      ReachableProc mid ops fin →
      ReachableProc st (op :: ops) fin

theorem runOps_implies_reachable :
    ∀ {ops : List ProcOp} {st fin : ProcState},
      runOps st ops = some fin → ReachableProc st ops fin
  | [], st, fin, h => by
      cases h
      exact .nil st
  | op :: ops, st, fin, h => by
      change (match execStep st op with | none => none | some mid => runOps mid ops) = some fin at h
      cases hStep : execStep st op with
      | none =>
          rw [hStep] at h
          contradiction
      | some mid =>
          rw [hStep] at h
          exact .cons hStep (runOps_implies_reachable h)

theorem reachable_preserves_phase_and_installed_mono :
    ∀ {st fin : ProcState} {ops : List ProcOp},
      ReachableProc st ops fin →
      fin.phase = st.phase ∧
      (∀ w, matchesInstalled st.installed w = true → matchesInstalled fin.installed w = true)
  | st, _, _, .nil _ => ⟨rfl, fun _ h => h⟩
  | st, fin, _, .cons (op := op) (mid := mid) hStep hRest => by
      obtain ⟨hPhaseRest, hMonoRest⟩ := reachable_preserves_phase_and_installed_mono hRest
      cases op with
      | submit sub =>
          change (match openGate st sub with | true => some _ | false => none) = some mid at hStep
          cases hGate : openGate st sub with
          | false => rw [hGate] at hStep; cases hStep
          | true =>
              rw [hGate] at hStep
              cases hStep
              exact ⟨hPhaseRest, hMonoRest⟩
      | verifyHead obs =>
          change (match natLeBool 1 st.reserve with
            | false => none
            | true => match natLeBool 1 st.stepsLeft with
              | false => none
              | true => match st.queue with
                | [] => none
                | sub :: rest => match verifyPasses obs sub with | true => some _ | false => some _) = some mid at hStep
          cases hR : natLeBool 1 st.reserve with
          | false => rw [hR] at hStep; cases hStep
          | true =>
              rw [hR] at hStep
              cases hS : natLeBool 1 st.stepsLeft with
              | false => rw [hS] at hStep; cases hStep
              | true =>
                  rw [hS] at hStep
                  cases hQ : st.queue with
                  | nil => rw [hQ] at hStep; cases hStep
                  | cons sub rest =>
                      rw [hQ] at hStep
                      dsimp only at hStep
                      cases hOk : verifyPasses obs sub with
                      | true => rw [hOk] at hStep; cases hStep; exact ⟨hPhaseRest, hMonoRest⟩
                      | false => rw [hOk] at hStep; cases hStep; exact ⟨hPhaseRest, hMonoRest⟩
      | applyRevision deliver =>
          change (match natLeBool 1 st.reserve with
            | false => none
            | true => match natLeBool 1 st.stepsLeft with | false => none | true => some _) = some mid at hStep
          cases hR : natLeBool 1 st.reserve with
          | false => rw [hR] at hStep; cases hStep
          | true =>
              rw [hR] at hStep
              cases hS : natLeBool 1 st.stepsLeft with
              | false => rw [hS] at hStep; cases hStep
              | true =>
                  rw [hS] at hStep
                  cases hStep
                  refine ⟨hPhaseRest, fun w hw => hMonoRest w ?_⟩
                  cases deliver with
                  | false => exact hw
                  | true =>
                      cases hPend : st.pending with
                      | none => exact hw
                      | some rep =>
                          change (match boolEq (rep.query w) rep.triggerVal with
                            | true => true | false => matchesInstalled st.installed w) = true
                          cases boolEq (rep.query w) rep.triggerVal
                          · exact hw
                          · rfl
      | actuate w =>
          change (match natLeBool 1 st.stepsLeft with | true => some _ | false => none) = some mid at hStep
          cases hSteps : natLeBool 1 st.stepsLeft with
          | false => rw [hSteps] at hStep; cases hStep
          | true =>
              rw [hSteps] at hStep
              cases hStep
              exact ⟨hPhaseRest, hMonoRest⟩

def drainQueueOps (obs : FreshObserver) : Nat → List ProcOp
  | 0 => []
  | k + 1 => ProcOp.verifyHead obs :: ProcOp.applyRevision true :: drainQueueOps obs k

theorem runOps_append :
    ∀ (ops1 ops2 : List ProcOp) (st mid fin : ProcState),
      runOps st ops1 = some mid →
      runOps mid ops2 = some fin →
      runOps st (ops1 ++ ops2) = some fin
  | [], _, _, mid, fin, h1, h2 => by
      cases h1
      exact h2
  | op :: ops1, ops2, st, mid, fin, h1, h2 => by
      change (match execStep st op with | none => none | some next => runOps next ops1) = some mid at h1
      cases hStep : execStep st op with
      | none => rw [hStep] at h1; contradiction
      | some next =>
          rw [hStep] at h1
          change (match execStep st op with | none => none | some s => runOps s (ops1 ++ ops2)) = some fin
          rw [hStep]
          exact runOps_append ops1 ops2 next mid fin h1 h2

theorem two_mul_succ (k : Nat) : 2 * (k + 1) = 2 * k + 1 + 1 := by
  change 2 * k + 2 = 2 * k + 1 + 1
  rfl

theorem drainQueue_reduces_prefix :
    ∀ (prefixQ : List Submission) (tailQ : List Submission)
      (st : ProcState) (obs : FreshObserver) (minRes minSteps : Nat),
      st.queue = prefixQ ++ tailQ →
      minRes + 2 * prefixQ.length ≤ st.reserve →
      minSteps + 2 * prefixQ.length ≤ st.stepsLeft →
      ∃ fin : ProcState,
        runOps st (drainQueueOps obs prefixQ.length) = some fin ∧
        fin.queue = tailQ ∧
        minRes ≤ fin.reserve ∧
        minSteps ≤ fin.stepsLeft
  | [], _, st, _, minRes, minSteps, hQ, hR, hS => by
      have hRes : minRes ≤ st.reserve := Nat.le_trans (Nat.le_add_right minRes _) hR
      have hStp : minSteps ≤ st.stepsLeft := Nat.le_trans (Nat.le_add_right minSteps _) hS
      exact ⟨st, rfl, hQ, hRes, hStp⟩
  | headQ :: restQ, tailQ, st, obs, minRes, minSteps, hQ, hR, hS => by
      have hLen : 2 * (restQ.length + 1) = 2 * restQ.length + 1 + 1 := two_mul_succ restQ.length
      have hR' : (minRes + 2 * restQ.length + 1) + 1 ≤ st.reserve := by
        rw [Nat.add_assoc minRes (2 * restQ.length) 1, Nat.add_assoc minRes _ 1, ← hLen]
        exact hR
      have hS' : (minSteps + 2 * restQ.length + 1) + 1 ≤ st.stepsLeft := by
        rw [Nat.add_assoc minSteps (2 * restQ.length) 1, Nat.add_assoc minSteps _ 1, ← hLen]
        exact hS
      have h1R : 1 ≤ st.reserve := Nat.le_trans (Nat.le_add_left 1 _) hR'
      have h1S : 1 ≤ st.stepsLeft := Nat.le_trans (Nat.le_add_left 1 _) hS'
      have hbR : natLeBool 1 st.reserve = true := (natLeBool_true_iff 1 st.reserve).2 h1R
      have hbS : natLeBool 1 st.stepsLeft = true := (natLeBool_true_iff 1 st.stepsLeft).2 h1S
      have hSubR1 : minRes + 2 * restQ.length + 1 ≤ st.reserve - 1 := nat_le_sub_of_add_le hR'
      have hSubS1 : minSteps + 2 * restQ.length + 1 ≤ st.stepsLeft - 1 := nat_le_sub_of_add_le hS'
      have hQ' : st.queue = headQ :: (restQ ++ tailQ) := hQ
      cases hVerify : execStep st (.verifyHead obs) with
      | none =>
          exfalso
          have hStepDef : execStep st (.verifyHead obs) =
              match natLeBool 1 st.reserve with
              | false => none
              | true => match natLeBool 1 st.stepsLeft with
                | false => none
                | true => match st.queue with
                  | [] => none
                  | sub :: rest => match verifyPasses obs sub with
                      | true => some { st with queue := rest, pending := some ⟨sub.query, obs.readContact sub.query sub.probeRisk⟩, reserve := st.reserve - 1, stepsLeft := st.stepsLeft - 1, drawTotal := st.drawTotal + 1 }
                      | false => some { st with queue := rest, pending := none, rejectedCount := st.rejectedCount + 1, reserve := st.reserve - 1, stepsLeft := st.stepsLeft - 1, drawTotal := st.drawTotal + 1 } := rfl
          rw [hbR, hbS, hQ'] at hStepDef
          dsimp only at hStepDef
          cases hCond : verifyPasses obs headQ with
          | true => rw [hCond] at hStepDef; rw [hStepDef] at hVerify; cases hVerify
          | false => rw [hCond] at hStepDef; rw [hStepDef] at hVerify; cases hVerify
      | some mid1 =>
          have hMid1 : mid1.queue = restQ ++ tailQ ∧ mid1.reserve = st.reserve - 1 ∧ mid1.stepsLeft = st.stepsLeft - 1 := by
            have hStepDef : execStep st (.verifyHead obs) =
                match natLeBool 1 st.reserve with
                | false => none
                | true => match natLeBool 1 st.stepsLeft with
                  | false => none
                  | true => match st.queue with
                    | [] => none
                    | sub :: rest => match verifyPasses obs sub with
                        | true => some { st with queue := rest, pending := some ⟨sub.query, obs.readContact sub.query sub.probeRisk⟩, reserve := st.reserve - 1, stepsLeft := st.stepsLeft - 1, drawTotal := st.drawTotal + 1 }
                        | false => some { st with queue := rest, pending := none, rejectedCount := st.rejectedCount + 1, reserve := st.reserve - 1, stepsLeft := st.stepsLeft - 1, drawTotal := st.drawTotal + 1 } := rfl
            rw [hbR, hbS, hQ'] at hStepDef
            dsimp only at hStepDef
            cases hCond : verifyPasses obs headQ with
            | true =>
                rw [hCond] at hStepDef
                have eq1 := hVerify.symm.trans hStepDef
                cases eq1
                exact ⟨rfl, rfl, rfl⟩
            | false =>
                rw [hCond] at hStepDef
                have eq1 := hVerify.symm.trans hStepDef
                cases eq1
                exact ⟨rfl, rfl, rfl⟩
          have h1R1 : 1 ≤ mid1.reserve := hMid1.2.1 ▸ Nat.le_trans (Nat.le_add_left 1 _) hSubR1
          have h1S1 : 1 ≤ mid1.stepsLeft := hMid1.2.2 ▸ Nat.le_trans (Nat.le_add_left 1 _) hSubS1
          have hbR1 : natLeBool 1 mid1.reserve = true := (natLeBool_true_iff 1 mid1.reserve).2 h1R1
          have hbS1 : natLeBool 1 mid1.stepsLeft = true := (natLeBool_true_iff 1 mid1.stepsLeft).2 h1S1
          have hApply : ∃ mid2 : ProcState,
              execStep mid1 (.applyRevision true) = some mid2 ∧
              mid2.queue = restQ ++ tailQ ∧
              minRes + 2 * restQ.length ≤ mid2.reserve ∧
              minSteps + 2 * restQ.length ≤ mid2.stepsLeft := by
            refine ⟨{ mid1 with
              installed := match mid1.pending with | none => mid1.installed | some rep => ⟨rep.query, rep.triggerVal⟩ :: mid1.installed
              pending := none
              reserve := mid1.reserve - 1
              stepsLeft := mid1.stepsLeft - 1
              drawTotal := mid1.drawTotal + 1 }, ?_, hMid1.1, ?_, ?_⟩
            · change (match natLeBool 1 mid1.reserve with
                | false => none | true => match natLeBool 1 mid1.stepsLeft with | false => none | true => some _) = _
              rw [hbR1, hbS1]
            · exact nat_le_sub_of_add_le (hMid1.2.1 ▸ hSubR1)
            · exact nat_le_sub_of_add_le (hMid1.2.2 ▸ hSubS1)
          obtain ⟨mid2, hStep2, hQ2, hR2, hS2⟩ := hApply
          obtain ⟨fin, hRunTail, hFinQ, hFinR, hFinS⟩ :=
            drainQueue_reduces_prefix restQ tailQ mid2 obs minRes minSteps hQ2 hR2 hS2
          refine ⟨fin, ?_, hFinQ, hFinR, hFinS⟩
          change (match execStep st (.verifyHead obs) with
            | none => none
            | some m1 => match execStep m1 (.applyRevision true) with
              | none => none
              | some m2 => runOps m2 (drainQueueOps obs restQ.length)) = some fin
          rw [hVerify]
          change (match execStep mid1 (.applyRevision true) with
            | none => none
            | some m2 => runOps m2 (drainQueueOps obs restQ.length)) = some fin
          rw [hStep2]
          exact hRunTail

theorem fair_open_entry_after_any_revision
    (r0 s0 : Nat) (hist : List ProcOp) (st : ProcState) (sub : Submission) (obs : FreshObserver)
    (_hReach : ReachableProc (initResolved r0 s0) hist st)
    (hGate : openGate st sub = true)
    (hPub : publicRead sub.probeRisk = true)
    (hSep : obs.readContact sub.query sub.probeSafe ≠ obs.readContact sub.query sub.probeRisk)
    (hSafeClean : obs.checkHazard sub.probeSafe = false)
    (hRiskHaz : obs.checkHazard sub.probeRisk = true)
    (hExact : obs.readContact sub.query sub.probeRisk = sub.query sub.probeRisk) :
    ∃ (ops : List ProcOp) (stRev stAct : ProcState),
      runOps st ops = some stRev ∧
      ReachableProc st ops stRev ∧
      execStep stRev (.actuate sub.probeRisk) = some stAct ∧
      stAct.lastAct = .protect ∧
      reserveFloor ≤ stAct.reserve ∧
      stRev.queue = [] := by
  obtain ⟨_, hRes, hStp⟩ := openGate_components hGate
  let stSub : ProcState := { st with
    queue := st.queue ++ [sub]
    reserve := st.reserve - 1
    stepsLeft := st.stepsLeft - 1
    drawTotal := st.drawTotal + 1 }
  have hStepSub : execStep st (.submit sub) = some stSub := by
    change (match openGate st sub with | true => some stSub | false => none) = some stSub
    rw [hGate]
  have hResAfterSub : (reserveFloor + 3) + 2 * st.queue.length ≤ stSub.reserve := by
    have hAssoc : (reserveFloor + 2 * st.queue.length + 3) + 1 ≤ st.reserve := hRes
    have hLe1 : reserveFloor + 2 * st.queue.length + 3 ≤ st.reserve - 1 := nat_le_sub_of_add_le hAssoc
    have hRearr : (reserveFloor + 3) + 2 * st.queue.length = reserveFloor + 2 * st.queue.length + 3 := by
      rw [Nat.add_assoc reserveFloor 3 (2 * st.queue.length), Nat.add_comm 3 (2 * st.queue.length), ← Nat.add_assoc]
    exact hRearr ▸ hLe1
  have hStpAfterSub : 3 + 2 * st.queue.length ≤ stSub.stepsLeft := by
    have hAssoc : (2 * st.queue.length + 3) + 1 ≤ st.stepsLeft := hStp
    have hLe1 : 2 * st.queue.length + 3 ≤ st.stepsLeft - 1 := nat_le_sub_of_add_le hAssoc
    have hRearr : 3 + 2 * st.queue.length = 2 * st.queue.length + 3 := Nat.add_comm 3 _
    exact hRearr ▸ hLe1
  obtain ⟨stHead, hDrainRun, hHeadQ, hHeadR, hHeadS⟩ :=
    drainQueue_reduces_prefix st.queue [sub] stSub obs (reserveFloor + 3) 3 rfl hResAfterSub hStpAfterSub
  have h1R_h : 1 ≤ stHead.reserve := Nat.le_trans (Nat.le_add_left 1 _) hHeadR
  have h1S_h : 1 ≤ stHead.stepsLeft := Nat.le_trans (Nat.le_add_left 1 _) hHeadS
  have hbR_h : natLeBool 1 stHead.reserve = true := (natLeBool_true_iff 1 _).2 h1R_h
  have hbS_h : natLeBool 1 stHead.stepsLeft = true := (natLeBool_true_iff 1 _).2 h1S_h
  have hVerOk : verifyPasses obs sub = true := by
    change (match boolEq (obs.readContact sub.query sub.probeSafe) (obs.readContact sub.query sub.probeRisk) with
      | true => false
      | false => match obs.checkHazard sub.probeSafe with | true => false | false => obs.checkHazard sub.probeRisk) = true
    rw [boolEq_false_of_ne hSep, hSafeClean, hRiskHaz]
  let stVer : ProcState := { stHead with
    queue := []
    pending := some ⟨sub.query, obs.readContact sub.query sub.probeRisk⟩
    reserve := stHead.reserve - 1
    stepsLeft := stHead.stepsLeft - 1
    drawTotal := stHead.drawTotal + 1 }
  have hStepVer : execStep stHead (.verifyHead obs) = some stVer := by
    change (match natLeBool 1 stHead.reserve with
      | false => none
      | true => match natLeBool 1 stHead.stepsLeft with
        | false => none
        | true => match stHead.queue with
          | [] => none
          | s0 :: r0 => match verifyPasses obs s0 with
              | true => some { stHead with queue := r0, pending := some ⟨s0.query, obs.readContact s0.query s0.probeRisk⟩, reserve := stHead.reserve - 1, stepsLeft := stHead.stepsLeft - 1, drawTotal := stHead.drawTotal + 1 }
              | false => _) = some stVer
    rw [hbR_h, hbS_h, hHeadQ]
    dsimp only
    rw [hVerOk]
  have hResVer : reserveFloor + 2 ≤ stVer.reserve := nat_le_sub_of_add_le hHeadR
  have hStpVer : 2 ≤ stVer.stepsLeft := nat_le_sub_of_add_le hHeadS
  have hbR_v : natLeBool 1 stVer.reserve = true :=
    (natLeBool_true_iff 1 _).2 (Nat.le_trans (Nat.le_add_left 1 _) hResVer)
  have hbS_v : natLeBool 1 stVer.stepsLeft = true :=
    (natLeBool_true_iff 1 _).2 (Nat.le_trans (Nat.le_add_left 1 _) hStpVer)
  let stRev : ProcState := { stVer with
    installed := ⟨sub.query, obs.readContact sub.query sub.probeRisk⟩ :: stVer.installed
    pending := none
    reserve := stVer.reserve - 1
    stepsLeft := stVer.stepsLeft - 1
    drawTotal := stVer.drawTotal + 1 }
  have hStepRev : execStep stVer (.applyRevision true) = some stRev := by
    change (match natLeBool 1 stVer.reserve with
      | false => none | true => match natLeBool 1 stVer.stepsLeft with | false => none | true => some stRev) = some stRev
    rw [hbR_v, hbS_v]
  have hResRev : reserveFloor + 1 ≤ stRev.reserve := nat_le_sub_of_add_le hResVer
  have hStpRev : 1 ≤ stRev.stepsLeft := nat_le_sub_of_add_le hStpVer
  have hbS_r : natLeBool 1 stRev.stepsLeft = true := (natLeBool_true_iff 1 _).2 hStpRev
  have hMatchRev : matchesInstalled stRev.installed sub.probeRisk = true :=
    matchesInstalled_cons_hit ⟨sub.query, obs.readContact sub.query sub.probeRisk⟩ stVer.installed sub.probeRisk hExact.symm
  have hPolRev : policyAct stRev sub.probeRisk = .protect := by
    change (match publicRead sub.probeRisk with
      | true => match matchesInstalled stRev.installed sub.probeRisk with | true => Act.protect | false => Act.normalOp
      | false => Act.retreat) = .protect
    rw [hPub, hMatchRev]
  let stAct : ProcState := { stRev with
    reserve := stRev.reserve - actDraw sub.probeRisk .protect
    stepsLeft := stRev.stepsLeft - 1
    drawTotal := stRev.drawTotal + actDraw sub.probeRisk .protect
    lastAct := .protect }
  have hStepAct : execStep stRev (.actuate sub.probeRisk) = some stAct := by
    change (match natLeBool 1 stRev.stepsLeft with | true => some _ | false => none) = some stAct
    rw [hbS_r, hPolRev]
  have hResAct : reserveFloor ≤ stAct.reserve := nat_le_sub_of_add_le hResRev
  let fullOps : List ProcOp := [.submit sub] ++ drainQueueOps obs st.queue.length ++ [.verifyHead obs, .applyRevision true]
  have hRun1 : runOps st ([.submit sub] ++ drainQueueOps obs st.queue.length) = some stHead := by
    change (match execStep st (.submit sub) with | none => none | some m => runOps m (drainQueueOps obs st.queue.length)) = some stHead
    rw [hStepSub]
    exact hDrainRun
  have hRun2 : runOps stHead [.verifyHead obs, .applyRevision true] = some stRev := by
    change (match execStep stHead (.verifyHead obs) with | none => none | some m => match execStep m (.applyRevision true) with | none => none | some f => some f) = some stRev
    rw [hStepVer]
    change (match execStep stVer (.applyRevision true) with | none => none | some f => some f) = some stRev
    rw [hStepRev]
  have hFullRun : runOps st fullOps = some stRev := runOps_append _ _ st stHead stRev hRun1 hRun2
  exact ⟨fullOps, stRev, stAct, hFullRun, runOps_implies_reachable hFullRun, hStepAct, rfl, hResAct, rfl⟩

/-! ### Concrete Executable Witness & Controls for Clauses 1, 2, and 3 -/

def worldSafeBase : World where
  ownHealthy := true
  hazard := false
  channels _ := false

def worldRisk1 : World where
  ownHealthy := true
  hazard := true
  channels i := match i with | 0 => true | _ + 1 => false

def worldRisk2 : World where
  ownHealthy := true
  hazard := true
  channels i := match i with | 0 => false | 1 => true | _ + 2 => false

def entrant1Sub : Submission where
  entrantTag := 1
  query w := w.channels 0
  probeSafe := worldSafeBase
  probeRisk := worldRisk1

def falseSub : Submission where
  entrantTag := 1
  query _ := false
  probeSafe := worldSafeBase
  probeRisk := worldRisk1

def entrant2Sub : Submission where
  entrantTag := 2
  query w := w.channels 1
  probeSafe := worldSafeBase
  probeRisk := worldRisk2

theorem clause1_acquisition_and_independent_verification :
    let st0 := initResolved 10 10
    publicRead worldSafeBase = publicRead worldRisk1 ∧
    entrant1Sub.query worldSafeBase ≠ entrant1Sub.query worldRisk1 ∧
    openGate st0 entrant1Sub = true ∧
    (∃ stPend : ProcState,
      runOps st0 [.submit entrant1Sub, .verifyHead canonicalObserver] = some stPend ∧
      stPend.rejectedCount = 0 ∧
      match stPend.pending with
      | some rep => rep.query worldSafeBase ≠ rep.query worldRisk1 ∧ rep.triggerVal = true
      | none => False) := by
  refine ⟨rfl, fun h => Bool.noConfusion h, rfl, ?_⟩
  refine ⟨{ initResolved 10 10 with
    queue := []
    pending := some ⟨entrant1Sub.query, true⟩
    reserve := 8
    stepsLeft := 8
    drawTotal := 2 }, rfl, rfl, fun h => Bool.noConfusion h, rfl⟩

theorem clause2a_causal_uptake_vs_masking :
    let st0 := initResolved 10 10
    ∃ delivered masked : ProcState,
      runOps st0 [.submit entrant1Sub, .verifyHead canonicalObserver, .applyRevision true, .actuate worldRisk1] = some delivered ∧
      runOps st0 [.submit entrant1Sub, .verifyHead canonicalObserver, .applyRevision false, .actuate worldRisk1] = some masked ∧
      delivered.stepsLeft = masked.stepsLeft ∧
      delivered.lastAct = .protect ∧
      masked.lastAct = .normalOp ∧
      delivered.lastAct ≠ masked.lastAct ∧
      reserveFloor ≤ delivered.reserve ∧
      masked.reserve < reserveFloor := by
  refine ⟨{ initResolved 10 10 with
    installed := [⟨entrant1Sub.query, true⟩]
    queue := []
    pending := none
    reserve := 6
    stepsLeft := 6
    drawTotal := 4
    lastAct := .protect },
    { initResolved 10 10 with
    installed := []
    queue := []
    pending := none
    reserve := 1
    stepsLeft := 6
    drawTotal := 9
    lastAct := .normalOp },
    rfl, rfl, rfl, rfl, rfl, protect_ne_normalOp, by decide, by decide⟩

theorem clause2b_false_objection_rejected :
    let st0 := initResolved 10 10
    ∃ stReject : ProcState,
      runOps st0 [.submit falseSub, .verifyHead canonicalObserver, .applyRevision true, .actuate worldSafeBase] = some stReject ∧
      stReject.rejectedCount = 1 ∧
      stReject.installed.length = 0 ∧
      stReject.lastAct = .normalOp ∧
      policyAct stReject worldRisk1 = .normalOp := by
  refine ⟨{ initResolved 10 10 with
    installed := []
    queue := []
    pending := none
    rejectedCount := 1
    reserve := 6
    stepsLeft := 6
    drawTotal := 4
    lastAct := .normalOp }, rfl, rfl, rfl, rfl, rfl⟩

theorem sealing_gate_blocks_entrants :
    let st0 := initResolved 13 13
    (¬ sealingGate st0 entrant1Sub) ∧
    (∃ stRev1 : ProcState,
      runOps st0 [.submit entrant1Sub, .verifyHead canonicalObserver, .applyRevision true] = some stRev1 ∧
      ¬ sealingGate stRev1 entrant2Sub) := by
  refine ⟨fun hSeal => ?_, ?_⟩
  · have hEq := hSeal.2 worldSafeBase worldRisk1 rfl rfl
    exact Bool.noConfusion hEq
  · refine ⟨{ initResolved 13 13 with
      installed := [⟨entrant1Sub.query, true⟩]
      queue := []
      pending := none
      reserve := 10
      stepsLeft := 10
      drawTotal := 3 }, rfl, fun hSeal2 => ?_⟩
    have hEq := hSeal2.2 worldSafeBase worldRisk2 rfl rfl
    exact Bool.noConfusion hEq

theorem clause3_second_entrant_after_revision1 :
    let st0 := initResolved 13 13
    ∃ stRev1 stAct2 stMasked2 : ProcState,
      runOps st0 [.submit entrant1Sub, .verifyHead canonicalObserver, .applyRevision true] = some stRev1 ∧
      publicRead worldSafeBase = publicRead worldRisk2 ∧
      matchesInstalled stRev1.installed worldSafeBase = matchesInstalled stRev1.installed worldRisk2 ∧
      policyAct stRev1 worldRisk2 = .normalOp ∧
      openGate stRev1 entrant2Sub = true ∧
      runOps stRev1 [.submit entrant2Sub, .verifyHead canonicalObserver, .applyRevision true, .actuate worldRisk2] = some stAct2 ∧
      runOps stRev1 [.submit entrant2Sub, .verifyHead canonicalObserver, .applyRevision false, .actuate worldRisk2] = some stMasked2 ∧
      stAct2.lastAct = .protect ∧
      stMasked2.lastAct = .normalOp ∧
      stAct2.lastAct ≠ stMasked2.lastAct ∧
      reserveFloor ≤ stAct2.reserve ∧
      stMasked2.reserve < reserveFloor := by
  refine ⟨{ initResolved 13 13 with
    installed := [⟨entrant1Sub.query, true⟩]
    queue := []
    pending := none
    reserve := 10
    stepsLeft := 10
    drawTotal := 3 },
    { initResolved 13 13 with
    installed := [⟨entrant2Sub.query, true⟩, ⟨entrant1Sub.query, true⟩]
    queue := []
    pending := none
    reserve := 6
    stepsLeft := 6
    drawTotal := 7
    lastAct := .protect },
    { initResolved 13 13 with
    installed := [⟨entrant1Sub.query, true⟩]
    queue := []
    pending := none
    reserve := 1
    stepsLeft := 6
    drawTotal := 12
    lastAct := .normalOp },
    rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, protect_ne_normalOp, by decide, by decide⟩

theorem encounter_refines_and_preserves_entry :
    (let st0 := initResolved 10 10
     publicRead worldSafeBase = publicRead worldRisk1 ∧
     entrant1Sub.query worldSafeBase ≠ entrant1Sub.query worldRisk1 ∧
     openGate st0 entrant1Sub = true ∧
     (∃ stPend : ProcState,
       runOps st0 [.submit entrant1Sub, .verifyHead canonicalObserver] = some stPend ∧
       stPend.rejectedCount = 0)) ∧
    (let st0 := initResolved 10 10
     ∃ delivered masked : ProcState,
       runOps st0 [.submit entrant1Sub, .verifyHead canonicalObserver, .applyRevision true, .actuate worldRisk1] = some delivered ∧
       runOps st0 [.submit entrant1Sub, .verifyHead canonicalObserver, .applyRevision false, .actuate worldRisk1] = some masked ∧
       delivered.stepsLeft = masked.stepsLeft ∧
       delivered.lastAct ≠ masked.lastAct ∧
       reserveFloor ≤ delivered.reserve ∧
       masked.reserve < reserveFloor) ∧
    (let st0 := initResolved 10 10
     ∃ stReject : ProcState,
       runOps st0 [.submit falseSub, .verifyHead canonicalObserver, .applyRevision true, .actuate worldSafeBase] = some stReject ∧
       stReject.rejectedCount = 1 ∧
       stReject.installed.length = 0 ∧
       stReject.lastAct = .normalOp) ∧
    (let st0 := initResolved 13 13
     (¬ sealingGate st0 entrant1Sub) ∧
     (∃ stRev1 stAct2 stMasked2 : ProcState,
       runOps st0 [.submit entrant1Sub, .verifyHead canonicalObserver, .applyRevision true] = some stRev1 ∧
       ¬ sealingGate stRev1 entrant2Sub ∧
       openGate stRev1 entrant2Sub = true ∧
       runOps stRev1 [.submit entrant2Sub, .verifyHead canonicalObserver, .applyRevision true, .actuate worldRisk2] = some stAct2 ∧
       runOps stRev1 [.submit entrant2Sub, .verifyHead canonicalObserver, .applyRevision false, .actuate worldRisk2] = some stMasked2 ∧
       stAct2.lastAct ≠ stMasked2.lastAct ∧
       reserveFloor ≤ stAct2.reserve ∧
       stMasked2.reserve < reserveFloor)) ∧
    (∀ (r0 s0 : Nat) (hist : List ProcOp) (st : ProcState) (sub : Submission) (obs : FreshObserver),
      ReachableProc (initResolved r0 s0) hist st →
      openGate st sub = true →
      publicRead sub.probeRisk = true →
      obs.readContact sub.query sub.probeSafe ≠ obs.readContact sub.query sub.probeRisk →
      obs.checkHazard sub.probeSafe = false →
      obs.checkHazard sub.probeRisk = true →
      obs.readContact sub.query sub.probeRisk = sub.query sub.probeRisk →
      ∃ (ops : List ProcOp) (stRev stAct : ProcState),
        runOps st ops = some stRev ∧
        ReachableProc st ops stRev ∧
        execStep stRev (.actuate sub.probeRisk) = some stAct ∧
        stAct.lastAct = .protect ∧
        reserveFloor ≤ stAct.reserve ∧
        stRev.queue = []) := by
  refine ⟨?_, ?_, ?_, ?_, ?_⟩
  · obtain ⟨h1, h2, h3, stPend, hRun, hRej, _⟩ := clause1_acquisition_and_independent_verification
    exact ⟨h1, h2, h3, stPend, hRun, hRej⟩
  · obtain ⟨del, msk, hD, hM, hS, _, _, hNeq, hDf, hMf⟩ := clause2a_causal_uptake_vs_masking
    exact ⟨del, msk, hD, hM, hS, hNeq, hDf, hMf⟩
  · obtain ⟨stR, hR, hC, hL, hA, _⟩ := clause2b_false_objection_rejected
    exact ⟨stR, hR, hC, hL, hA⟩
  · obtain ⟨hS1, stRev1', hRev1', hS2⟩ := sealing_gate_blocks_entrants
    obtain ⟨stRev1, stAct2, stMasked2, hR1, _, _, _, hOpen2, hA2, hM2, _, _, hNeq2, hDf2, hMf2⟩ :=
      clause3_second_entrant_after_revision1
    have hEqRev : stRev1' = stRev1 := by
      have hSame := hRev1'.symm.trans hR1
      exact Option.some.inj hSame
    refine ⟨hS1, stRev1, stAct2, stMasked2, hR1, hEqRev ▸ hS2, hOpen2, hA2, hM2, hNeq2, hDf2, hMf2⟩
  · exact fair_open_entry_after_any_revision

end EncounterEntry
