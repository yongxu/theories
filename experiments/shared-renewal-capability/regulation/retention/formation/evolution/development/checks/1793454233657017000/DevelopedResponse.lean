import ConsequenceTransmission

/-!
# Developmental reconstruction and consequence-supported reformation

A bounded wrapper of the existing FormedSelection reactions. The available
scaffold/rig recipes, association update and intervention channel are supplied.
There is no moral predicate or rate assigned to good behavior. Both effective
and mistimed descendants are chemically A; functional assay classes must NOT
be confused with the inherited A/H chemical kinds.

The wrapper retains all native support and adds explicitly held H parts. A new
carrier has no operative gate until a held rig is assembled and bound to the
cue paired with an actual capture. Sensing before or after the founder's repair
forms different gates by the same rule. The response command reads only the
acquired gate and fresh reading, not the actual site's condition. Real reaction
guards separately determine whether that command can execute.
-/
namespace DevelopedResponse
set_option maxRecDepth 32768
set_option maxHeartbeats 6000000
open FormedSelection

structure State where
  core : FormedSelection.State
  scaffold : Bool := false
  rigs : Nat := 0
  generation : Nat := 0
  active : Bool := false
  cue : Option Bool := none
  paired : Option Bool := none
  repaired : Bool := false
  pendingCarrier : Bool := false
  pendingRig : Bool := false
  pendingGate : Option Bool := none
  gate : Option Bool := none
  reading : Option Bool := none
  acted : Bool := false
  carriersMade : Nat := 0
  deriving DecidableEq, Repr

inductive Event where
  | formA | formH | assembleScaffold | associateFounder | sample | founderRepair
  | capture | copy | assembleRig | bindRig | handover | damage | associateNext
  | read | act | assistedRepair
  deriving DecidableEq, Repr

def heldParts (s : State) : Nat := bit s.scaffold + s.rigs

def repairCommand (s : State) : Bool :=
  match s.gate, s.reading with
  | some gate, some reading => gate == reading
  | _, _ => false

/-- Native reaction sequence actually performed by the wrapper event. Taking
H out of the free stock during assembly means transferring it to a held part;
that part stays counted in heldParts, instead of becoming reusable precursor. -/
def physicalWord (s : State) : Event → List FormedSelection.Event
  | .formA => [.formA]
  | .formH => [.formH]
  | .assembleScaffold | .assembleRig => [.wearFreeH, .leakCommon]
  | .associateFounder | .associateNext => [.associateA]
  | .sample | .bindRig | .read => [.leakCommon]
  | .founderRepair | .assistedRepair => [.repair]
  | .capture => [.capture]
  | .copy => [.localCopyA]
  | .handover => [.wearResident]
  | .damage => [.damage]
  | .act => if repairCommand s then [.repair] else [.leakCommon]

def coreRun : FormedSelection.State → List FormedSelection.Event → FormedSelection.State
  | s, [] => s
  | s, e :: es => coreRun (FormedSelection.advance s e) es

def nativeRunnable (material : Nat) : FormedSelection.State → List FormedSelection.Event → Prop
  | _, [] => True
  | s, e :: es => FormedSelection.Step material s e (FormedSelection.advance s e) ∧
      nativeRunnable material (FormedSelection.advance s e) es

instance nativeRunnableDecidable (m : Nat) (s : FormedSelection.State) :
    (es : List FormedSelection.Event) → Decidable (nativeRunnable m s es)
  | [] => isTrue True.intro
  | e :: es =>
    letI := nativeRunnableDecidable m (FormedSelection.advance s e) es
    inferInstanceAs (Decidable (FormedSelection.Step m s e (FormedSelection.advance s e) ∧
      nativeRunnable m (FormedSelection.advance s e) es))

def conditions (s : State) : Event → Prop
  | .formA | .formH => s.generation = 0 ∧ s.active = false
  | .assembleScaffold => s.scaffold = false
  | .associateFounder => s.generation = 0 ∧ s.active = false
  | .sample => s.scaffold = true ∧ s.active = true ∧ s.generation = 0
  | .founderRepair => s.generation = 0 ∧ s.active = true
  | .capture => s.active = true ∧ s.cue.isSome = true ∧ s.repaired = true
  | .copy => s.active = true ∧ s.paired.isSome = true ∧ s.pendingCarrier = false
  | .assembleRig => s.pendingCarrier = true ∧ s.pendingRig = false
  | .bindRig => s.pendingRig = true ∧ s.paired.isSome = true ∧ s.pendingGate = none
  | .handover => s.active = true ∧ s.pendingCarrier = true ∧ s.pendingGate.isSome = true
  | .damage => s.active = false
  | .associateNext => s.active = false ∧ s.pendingCarrier = true ∧ s.pendingRig = true ∧
      s.pendingGate.isSome = true
  | .read => s.active = true ∧ 0 < s.generation ∧ s.scaffold = true ∧
      s.gate.isSome = true ∧ s.reading = none
  | .act => s.active = true ∧ 0 < s.generation ∧ s.gate.isSome = true ∧
      s.reading.isSome = true ∧ s.acted = false
  | .assistedRepair => s.active = true ∧ 0 < s.generation

instance (s : State) (e : Event) : Decidable (conditions s e) := by
  cases e <;> unfold conditions <;> infer_instance

def Enabled (material : Nat) (s : State) (e : Event) : Prop :=
  heldParts s ≤ material ∧
  nativeRunnable (material - heldParts s) s.core (physicalWord s e) ∧ conditions s e

instance (m : Nat) (s : State) (e : Event) : Decidable (Enabled m s e) := by
  unfold Enabled
  infer_instance

def advance (s : State) (e : Event) : State :=
  let t := { s with core := coreRun s.core (physicalWord s e) }
  match e with
  | .formA | .formH => t
  | .assembleScaffold => { t with scaffold := true }
  | .associateFounder => { t with active := true }
  | .sample => { t with cue := some s.core.intact, paired := none }
  | .founderRepair | .assistedRepair => { t with repaired := true }
  | .capture => { t with paired := s.cue, repaired := false }
  | .copy =>
    { t with
      pendingCarrier := true
      pendingRig := false
      pendingGate := none
      carriersMade := s.carriersMade + 1 }
  | .assembleRig => { t with rigs := s.rigs + 1, pendingRig := true }
  | .bindRig => { t with pendingGate := s.paired }
  | .handover => { t with active := false }
  | .damage => t
  | .associateNext =>
    { t with
      generation := s.generation + 1
      active := true
      gate := s.pendingGate
      pendingCarrier := false
      pendingRig := false
      pendingGate := none
      cue := none
      paired := none
      reading := none
      repaired := false
      acted := false }
  | .read => { t with reading := some s.core.intact, cue := some s.core.intact, paired := none }
  | .act => { t with repaired := repairCommand s, acted := true }

def process (material : Nat) : Generative.Process State Event where
  step s e t := Enabled material s e ∧ t = advance s e

def run : State → List Event → State
  | s, [] => s
  | s, e :: es => run (advance s e) es

def Runnable (material : Nat) : State → List Event → Prop
  | _, [] => True
  | s, e :: es => Enabled material s e ∧ Runnable material (advance s e) es

instance runnableDecidable (m : Nat) (s : State) : (es : List Event) → Decidable (Runnable m s es)
  | [] => isTrue True.intro
  | e :: es =>
    letI := runnableDecidable m (advance s e) es
    inferInstanceAs (Decidable (Enabled m s e ∧ Runnable m (advance s e) es))

theorem runnable_trace {m : Nat} {s : State} {es : List Event} (r : Runnable m s es) :
    Generative.Trace (process m) s es (run s es) := by
  induction es generalizing s with
  | nil => exact .nil s
  | cons e es ih => exact .cons ⟨r.1, rfl⟩ (ih r.2)

theorem native_runnable_trace {m : Nat} {s : FormedSelection.State}
    {es : List FormedSelection.Event} (r : nativeRunnable m s es) :
    FormedSelection.Trace m s es (coreRun s es) := by
  induction es generalizing s with
  | nil => exact .nil s
  | cons e es ih => exact .cons r.1 (ih r.2)

/-- The bookkeeping updates never alter the native transition's physical result. -/
theorem advance_core (s : State) (e : Event) :
    (advance s e).core = coreRun s.core (physicalWord s e) := by
  cases e <;> rfl

def eventCost (s : State) (e : Event) : Nat := tally expenditure (physicalWord s e)

def historyCost : State → List Event → Nat
  | _, [] => 0
  | s, e :: es => eventCost s e + historyCost (advance s e) es

theorem enabled_energy_balance {m : Nat} {s : State} {e : Event} (enabled : Enabled m s e) :
    energy (advance s e).core + eventCost s e = energy s.core := by
  rw [advance_core]
  exact trace_energy_ledger (native_runnable_trace enabled.2.1)

/-- Every admitted finite wrapper history keeps the native source/usable-support
account. Assembly, sampling, binding and unsuccessful action remain included. -/
theorem runnable_energy_balance {m : Nat} {s : State} {es : List Event}
    (r : Runnable m s es) : energy (run s es).core + historyCost s es = energy s.core := by
  induction es generalizing s with
  | nil => exact Nat.add_zero _
  | cons e es ih =>
    have stepBalance := enabled_energy_balance r.1
    have tailBalance := ih r.2
    change energy (run (advance s e) es).core +
      (eventCost s e + historyCost (advance s e) es) = energy s.core
    omega

/-- Selection of the response cannot inspect the present site except through
its acquired reading. Executability still depends on the real reaction guard. -/
theorem command_uses_gate_and_reading {s t : State}
    (gate : s.gate = t.gate) (reading : s.reading = t.reading) :
    repairCommand s = repairCommand t := by
  unfold repairCommand
  rw [gate, reading]

/-- Finite words below start with no A/H variants or formed apparatus. All
support and materials are present from this common initial state. -/
def initial : State := { core := ⟨0, 0, .empty, false, false, 20, 2⟩ }

def preparation : List Event :=
  [.formA, .formH, .formH, .formH, .assembleScaffold, .associateFounder]

def timelyPrefix : List Event := preparation ++ [.sample, .founderRepair, .capture, .copy]
def mistimedPrefix : List Event := preparation ++ [.founderRepair, .sample, .capture, .copy]
def development : List Event := [.assembleRig, .bindRig, .handover, .damage, .associateNext]
def assay : List Event := [.read, .act]
def redevelopment : List Event :=
  [.capture, .copy, .assembleRig, .bindRig, .handover, .damage, .associateNext, .read, .act]

def timelyCarrier := run initial timelyPrefix
def mistimedCarrier := run initial mistimedPrefix
def timelyChild := run timelyCarrier development
def mistimedChild := run mistimedCarrier development
def timelyAssayed := run timelyChild assay
def mistimedAssayed := run mistimedChild assay
def grandchildAssayed := run timelyAssayed redevelopment
def rescuedGrandchild := run mistimedAssayed (.assistedRepair :: redevelopment)

/-- This newly copied carrier has no developed gate and no assembled child rig.
Both histories have identical native physical state and equal support. -/
theorem same_carrier_different_developmental_record :
    Generative.Trace (process 6) initial timelyPrefix timelyCarrier ∧
    Generative.Trace (process 6) initial mistimedPrefix mistimedCarrier ∧
    timelyCarrier.core = mistimedCarrier.core ∧
    timelyCarrier.pendingCarrier = true ∧ mistimedCarrier.pendingCarrier = true ∧
    timelyCarrier.pendingRig = false ∧ mistimedCarrier.pendingRig = false ∧
    timelyCarrier.pendingGate = none ∧ mistimedCarrier.pendingGate = none ∧
    timelyCarrier.paired = some false ∧ mistimedCarrier.paired = some true := by
  exact ⟨runnable_trace (by decide), runnable_trace (by decide), by decide⟩

/-- The same assembly/binding procedure uses two actual development records;
neither route is supplied as a finished label on the copied A carrier. -/
theorem equal_cost_development_reconstructs_different_gates :
    Generative.Trace (process 6) timelyCarrier development timelyChild ∧
    Generative.Trace (process 6) mistimedCarrier development mistimedChild ∧
    timelyChild.core = mistimedChild.core ∧
    timelyChild.core.fuel = 9 ∧ timelyChild.rigs = 1 ∧ mistimedChild.rigs = 1 ∧
    timelyChild.gate = some false ∧ mistimedChild.gate = some true ∧
    timelyChild.reading = none ∧ mistimedChild.reading = none ∧
    timelyChild.generation = 1 ∧ mistimedChild.generation = 1 := by
  exact ⟨runnable_trace (by decide), runnable_trace (by decide), by decide⟩

/-- Identical read/act events at the same actual damaged site enact different
responses because the developed gates differ. Neither protocol prescribes the
final repair/withhold branch from outside the gate. -/
theorem same_assay_enacts_developed_difference :
    Generative.Trace (process 6) timelyChild assay timelyAssayed ∧
    Generative.Trace (process 6) mistimedChild assay mistimedAssayed ∧
    timelyAssayed.reading = some false ∧ mistimedAssayed.reading = some false ∧
    timelyAssayed.core.fuel = mistimedAssayed.core.fuel ∧ timelyAssayed.core.fuel = 7 ∧
    timelyAssayed.core.intact = true ∧ mistimedAssayed.core.intact = false ∧
    Enabled 6 timelyAssayed .capture ∧ ¬ Enabled 6 mistimedAssayed .capture ∧
    ¬ Enabled 6 mistimedAssayed .copy := by
  exact ⟨runnable_trace (by decide), runnable_trace (by decide), by decide⟩

/-- The effect supplies actual capture and carrier formation, but the theorem
continues through assembly, binding and the next generation's own fresh assay.
It does not stop at counting an undeveloped carrier as a functional descendant. -/
theorem consequence_reformation_reaches_operating_grandchild :
    Generative.Trace (process 6) timelyAssayed redevelopment grandchildAssayed ∧
    grandchildAssayed.generation = 2 ∧ grandchildAssayed.rigs = 2 ∧
    grandchildAssayed.gate = some false ∧ grandchildAssayed.reading = some false ∧
    grandchildAssayed.acted = true ∧ grandchildAssayed.core.intact = true ∧
    grandchildAssayed.carriersMade = 2 ∧ grandchildAssayed.core.fuel = 2 ∧
    grandchildAssayed.core.source = 0 := by
  exact ⟨runnable_trace (by decide), by decide⟩

/-- Misbinding blocks this unassisted suffix, not all repair or future renewal.
The explicit alternative repair channel retains its extra support consumption. -/
theorem supplied_assistance_can_rescue_development :
    ¬ Runnable 6 mistimedAssayed redevelopment ∧
    Generative.Trace (process 6) mistimedAssayed (.assistedRepair :: redevelopment) rescuedGrandchild ∧
    rescuedGrandchild.generation = 2 ∧ rescuedGrandchild.gate = some false ∧
    rescuedGrandchild.reading = some false ∧ rescuedGrandchild.core.intact = true ∧
    rescuedGrandchild.core.fuel = 1 ∧ rescuedGrandchild.core.source = 0 := by
  exact ⟨by decide, runnable_trace (by decide), by decide⟩

/-- Once copied, lack of actual assembly prevents binding this model's operative
route even when the shared developmental record is present. -/
theorem carrier_is_not_already_a_developed_response :
    timelyCarrier.paired = some false ∧ ¬ Enabled 6 timelyCarrier .bindRig ∧
    ¬ Enabled 6 timelyCarrier .associateNext ∧
    Enabled 6 timelyCarrier .assembleRig := by decide

/-- Lack of remaining provision can block reformation even with a correctly
rebuilt and demonstrably operative response. No favorable endless cycle is
smuggled into the finite construction. -/
theorem operational_response_without_next_capture :
    grandchildAssayed.core.intact = true ∧ grandchildAssayed.gate = some false ∧
    ¬ Enabled 6 grandchildAssayed .capture ∧ ¬ Enabled 6 grandchildAssayed .copy := by decide

/-- The two native A carriers are classified only after an actual acquired-gate
assay at a declared damaged site. This functional readout is not moral worth,
not chemical A/H identity, and not a classification at birth. -/
def effectiveDamagedResponse (s : State) : Bool :=
  s.acted && s.reading == some false && s.core.intact

/-- A derived finite transmission table over two equally weighted development
histories. Row A means the founder has actually enacted restoration; columns
are the two post-development functional assay classes, not native A/H. Equal
history weights are declared sampling, not evolved reproductive probabilities. -/
def developedTable : ConsequenceTransmission.Transmission :=
  ⟨if effectiveDamagedResponse timelyAssayed then 1 else 0,
   if effectiveDamagedResponse mistimedAssayed then 0 else 1, 0, 0, 0⟩

theorem developed_table_comes_from_operating_assays :
    Generative.Trace (process 6) timelyChild assay timelyAssayed ∧
    Generative.Trace (process 6) mistimedChild assay mistimedAssayed ∧
    effectiveDamagedResponse timelyAssayed = true ∧
    effectiveDamagedResponse mistimedAssayed = false ∧
    developedTable.aa = 1 ∧ developedTable.ah = 1 ∧
    developedTable.ha = 0 ∧ developedTable.hh = 0 ∧
    aCount timelyChild.core = 1 ∧ aCount mistimedChild.core = 1 ∧
    hCount timelyChild.core = 1 ∧ hCount mistimedChild.core = 1 := by
  exact ⟨same_assay_enacts_developed_difference.1,
    same_assay_enacts_developed_difference.2.1, by decide⟩

/-- Formal reuse of the preceding transmission theorem with a new, explicit
functional correspondence. The base counts here are hypothetical assay-class
counts, not the native molecular population of either individual witness. -/
theorem transmission_formula_applies_to_developed_table (a h : Nat) :
    ConsequenceTransmission.beforeNumerator a h
        (ConsequenceTransmission.transmittedWeights developedTable) <
      ConsequenceTransmission.afterNumerator a h
        (ConsequenceTransmission.transmittedWeights developedTable) ↔
      a < h := by
  have criterion := ConsequenceTransmission.transmitted_structure_increase_iff a h developedTable
  change (ConsequenceTransmission.beforeNumerator a h
      (ConsequenceTransmission.transmittedWeights developedTable) <
    ConsequenceTransmission.afterNumerator a h
      (ConsequenceTransmission.transmittedWeights developedTable) ↔ 1 * a < 1 * h) at criterion
  rw [Nat.one_mul, Nat.one_mul] at criterion
  exact criterion

/-- Material includes held scaffold/rig parts at EVERY prefix. Assembly does not
release those H parts for reuse in subsequent native formation. -/
def MaterialAccounted (material : Nat) : State → List Event → Prop
  | s, [] => population s.core + heldParts s ≤ material
  | s, e :: es => population s.core + heldParts s ≤ material ∧
      MaterialAccounted material (advance s e) es

instance materialAccountedDecidable (m : Nat) (s : State) :
    (es : List Event) → Decidable (MaterialAccounted m s es)
  | [] => inferInstanceAs (Decidable (_ ≤ _))
  | e :: es =>
    letI := materialAccountedDecidable m (advance s e) es
    inferInstanceAs (Decidable (population s.core + heldParts s ≤ m ∧
      MaterialAccounted m (advance s e) es))

def fullTimely := timelyPrefix ++ development ++ assay ++ redevelopment
def fullRescued := mistimedPrefix ++ development ++ assay ++ (.assistedRepair :: redevelopment)

theorem whole_timely_history_with_material_and_energy :
    Generative.Trace (process 6) initial fullTimely grandchildAssayed ∧
    MaterialAccounted 6 initial fullTimely ∧
    energy initial.core = 22 ∧ historyCost initial fullTimely = 20 ∧
    energy grandchildAssayed.core = 2 := by
  exact ⟨runnable_trace (by decide), by decide⟩

theorem whole_rescued_history_with_material_and_energy :
    Generative.Trace (process 6) initial fullRescued rescuedGrandchild ∧
    MaterialAccounted 6 initial fullRescued ∧
    historyCost initial fullRescued = 21 ∧ energy rescuedGrandchild.core = 1 := by
  exact ⟨runnable_trace (by decide), by decide⟩


end DevelopedResponse

#print axioms DevelopedResponse.runnable_trace
#print axioms DevelopedResponse.native_runnable_trace
#print axioms DevelopedResponse.command_uses_gate_and_reading
#print axioms DevelopedResponse.same_carrier_different_developmental_record
#print axioms DevelopedResponse.equal_cost_development_reconstructs_different_gates
#print axioms DevelopedResponse.same_assay_enacts_developed_difference
#print axioms DevelopedResponse.consequence_reformation_reaches_operating_grandchild
#print axioms DevelopedResponse.supplied_assistance_can_rescue_development
#print axioms DevelopedResponse.carrier_is_not_already_a_developed_response
#print axioms DevelopedResponse.operational_response_without_next_capture
#print axioms DevelopedResponse.developed_table_comes_from_operating_assays
#print axioms DevelopedResponse.transmission_formula_applies_to_developed_table

#print axioms DevelopedResponse.advance_core
#print axioms DevelopedResponse.enabled_energy_balance
#print axioms DevelopedResponse.runnable_energy_balance
#print axioms DevelopedResponse.whole_timely_history_with_material_and_energy
#print axioms DevelopedResponse.whole_rescued_history_with_material_and_energy
