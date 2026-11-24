import Init

/-!
# BecomingSpec Extensions: Adaptive Inquiry, Branching & Open Second Entry

AI-written (Track S1/Wave 2, 2026-11-24). `import Init` ONLY, 0 axioms, 0 `.injEq`.
Freezes §7.3 adaptive branching vs fixed schedules, labeled path-count vs post-branch choice,
and `encounter_refines_and_preserves_entry` (acquisition, masking control, false rejection,
open second entry vs sealing gate).
-/

set_option genInjectivity false

namespace BecomingSpec.Extensions

inductive InquiryTree (Probe Outcome Act : Type) where
  | stop (act : Act)
  | ask (probe : Probe) (next : Outcome → InquiryTree Probe Outcome Act)

def runTree {Probe Outcome Act : Type} (oracle : Probe → Outcome) :
    InquiryTree Probe Outcome Act → Act
  | .stop act => act
  | .ask probe next => runTree oracle (next (oracle probe))

def ofFixed {Probe Outcome Act : Type} :
    List Probe → (List Outcome → Act) → InquiryTree Probe Outcome Act
  | [], dec => .stop (dec [])
  | p :: ps, dec => .ask p (fun o => ofFixed ps (fun os => dec (o :: os)))

inductive WithinQueries {Probe Outcome Act : Type} :
    Nat → InquiryTree Probe Outcome Act → Prop where
  | stop (n : Nat) (act : Act) : WithinQueries n (.stop act)
  | ask (n : Nat) (p : Probe) (next : Outcome → InquiryTree Probe Outcome Act) :
      (∀ o, WithinQueries n (next o)) → WithinQueries (n + 1) (.ask p next)

inductive SlotProbe where | probeWhere | readL | readR

def slotOracle (s : Bool × Bool) : SlotProbe → Bool
  | .probeWhere => s.1
  | .readL => match s.1 with | true => false | false => s.2
  | .readR => match s.1 with | true => s.2 | false => false

def adaptiveBeatsFixedTarget : Prop :=
  (∃ t : InquiryTree SlotProbe Bool (Bool × Bool),
    WithinQueries 2 t ∧ ∀ s : Bool × Bool, runTree (slotOracle s) t = s) ∧
  (∀ (p₁ p₂ : SlotProbe) (dec : List Bool → Bool × Bool),
    (∃ s₁ s₂ : Bool × Bool, s₁ ≠ s₂ ∧
      runTree (slotOracle s₁) (ofFixed [p₁, p₂] dec) =
        runTree (slotOracle s₂) (ofFixed [p₁, p₂] dec)) ∧
    (∃ s : Bool × Bool, runTree (slotOracle s) (ofFixed [p₁, p₂] dec) ≠ s)) ∧
  (∃ dec : List Bool → Bool,
    ∀ s : Bool × Bool, runTree (slotOracle s) (ofFixed [.readL, .readR] dec) = s.2)

inductive BranchState where | entry | leftMid | rightMid | exitDone
inductive BranchLabel where | stepX | reqA | reqB
inductive PostReq where | reqA | reqB

def branchStateEq : BranchState → BranchState → Bool
  | .entry, .entry => true | .leftMid, .leftMid => true
  | .rightMid, .rightMid => true | .exitDone, .exitDone => true
  | .entry, .leftMid => false | .entry, .rightMid => false | .entry, .exitDone => false
  | .leftMid, .entry => false | .leftMid, .rightMid => false | .leftMid, .exitDone => false
  | .rightMid, .entry => false | .rightMid, .leftMid => false | .rightMid, .exitDone => false
  | .exitDone, .entry => false | .exitDone, .leftMid => false | .exitDone, .rightMid => false

def postLabel : PostReq → BranchLabel | .reqA => .reqA | .reqB => .reqB
def sumNatList : List Nat → Nat | [] => 0 | n :: ns => n + sumNatList ns

def pathsFrom (edges : BranchState → BranchLabel → List BranchState) :
    BranchState → List BranchLabel → BranchState → Nat
  | s, [], tgt => if branchStateEq s tgt then 1 else 0
  | s, l :: ls, tgt => sumNatList ((edges s l).map (fun s' => pathsFrom edges s' ls tgt))

def CompletesPostBranch (edges : BranchState → BranchLabel → List BranchState) : Prop :=
  ∀ mid, mid ∈ edges .entry .stepX →
    ∀ r : PostReq, ∃ tgt, tgt ∈ edges mid (postLabel r) ∧ tgt = .exitDone

def branchingVsPathCountTarget : Prop :=
  ∃ eA eB : BranchState → BranchLabel → List BranchState,
    pathsFrom eA .entry [.stepX, .reqA] .exitDone = 2 ∧
    pathsFrom eA .entry [.stepX, .reqB] .exitDone = 2 ∧
    (∀ w, pathsFrom eA .entry w .exitDone = pathsFrom eB .entry w .exitDone) ∧
    CompletesPostBranch eA ∧ ¬ CompletesPostBranch eB

structure OpenEntryInterface (World State Act Sub Obs Op : Type) where
  initResolved : Nat → Nat → State
  pubRead : World → Bool
  subQuery : Sub → World → Bool
  subSafe : Sub → World
  subRisk : Sub → World
  obsRead : Obs → (World → Bool) → World → Bool
  obsHazard : Obs → World → Bool
  openGate : State → Sub → Prop
  sealingGate : State → Sub → Prop
  execStep : State → Op → Option State
  runOps : State → List Op → Option State
  reachable : State → List Op → State → Prop
  submitOp : Sub → Op
  verifyOp : Obs → Op
  applyOp : Bool → Op
  actuateOp : World → Op
  reserve : State → Nat
  stepsLeft : State → Nat
  rejectedCount : State → Nat
  installedCount : State → Nat
  lastAct : State → Act
  protectAct : Act
  normalAct : Act
  queueEmpty : State → Prop

def openSecondEntryTarget : Prop :=
  ∃ (World State Act Sub Obs Op : Type) (I : OpenEntryInterface World State Act Sub Obs Op)
    (floor : Nat) (obs : Obs) (wSafe wRisk₁ wRisk₂ : World) (sub₁ sub₂ subFalse : Sub),
    I.protectAct ≠ I.normalAct ∧
    I.pubRead wSafe = I.pubRead wRisk₁ ∧ I.subQuery sub₁ wSafe ≠ I.subQuery sub₁ wRisk₁ ∧
    I.openGate (I.initResolved 10 10) sub₁ ∧ ¬ I.sealingGate (I.initResolved 10 10) sub₁ ∧
    (∃ stPend, I.runOps (I.initResolved 10 10) [I.submitOp sub₁, I.verifyOp obs] = some stPend ∧
      I.rejectedCount stPend = 0) ∧
    (∃ del msk,
      I.runOps (I.initResolved 10 10) [I.submitOp sub₁, I.verifyOp obs, I.applyOp true, I.actuateOp wRisk₁] = some del ∧
      I.runOps (I.initResolved 10 10) [I.submitOp sub₁, I.verifyOp obs, I.applyOp false, I.actuateOp wRisk₁] = some msk ∧
      I.stepsLeft del = I.stepsLeft msk ∧ I.lastAct del ≠ I.lastAct msk ∧
      floor ≤ I.reserve del ∧ I.reserve msk < floor) ∧
    (∃ stRej,
      I.runOps (I.initResolved 10 10) [I.submitOp subFalse, I.verifyOp obs, I.applyOp true, I.actuateOp wSafe] = some stRej ∧
      I.rejectedCount stRej = 1 ∧ I.installedCount stRej = 0 ∧ I.lastAct stRej = I.normalAct) ∧
    (∃ stRev₁ stAct₂ stMsk₂,
      I.runOps (I.initResolved 13 13) [I.submitOp sub₁, I.verifyOp obs, I.applyOp true] = some stRev₁ ∧
      ¬ I.sealingGate stRev₁ sub₂ ∧ I.openGate stRev₁ sub₂ ∧
      I.runOps stRev₁ [I.submitOp sub₂, I.verifyOp obs, I.applyOp true, I.actuateOp wRisk₂] = some stAct₂ ∧
      I.runOps stRev₁ [I.submitOp sub₂, I.verifyOp obs, I.applyOp false, I.actuateOp wRisk₂] = some stMsk₂ ∧
      I.lastAct stAct₂ ≠ I.lastAct stMsk₂ ∧ floor ≤ I.reserve stAct₂ ∧ I.reserve stMsk₂ < floor) ∧
    (∀ r₀ s₀ hist st sub obs',
      I.reachable (I.initResolved r₀ s₀) hist st → I.openGate st sub → I.pubRead (I.subRisk sub) = true →
      I.obsRead obs' (I.subQuery sub) (I.subSafe sub) ≠ I.obsRead obs' (I.subQuery sub) (I.subRisk sub) →
      I.obsHazard obs' (I.subSafe sub) = false → I.obsHazard obs' (I.subRisk sub) = true →
      I.obsRead obs' (I.subQuery sub) (I.subRisk sub) = I.subQuery sub (I.subRisk sub) →
      ∃ ops stRev stAct,
        I.runOps st ops = some stRev ∧ I.reachable st ops stRev ∧
        I.execStep stRev (I.actuateOp (I.subRisk sub)) = some stAct ∧
        I.lastAct stAct = I.protectAct ∧ floor ≤ I.reserve stAct ∧ I.queueEmpty stRev)

end BecomingSpec.Extensions
