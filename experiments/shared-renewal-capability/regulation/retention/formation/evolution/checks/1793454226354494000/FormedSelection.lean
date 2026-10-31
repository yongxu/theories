import Std

-- Use ordinary case compilation to avoid an unnecessary propext dependency.
set_option backward.match.sparseCases false

/-!
# Paid formation and localized retention of two response types

One continuing, finite-stock, discrete event law. These theorems do not assign
stochastic rates, infer frequency advantage, or identify molecular chemistry.
-/

namespace FormedSelection

inductive Resident where
  | empty | active | alternative
deriving DecidableEq, Repr

structure State where
  aFree : Nat
  hFree : Nat
  resident : Resident
  intact : Bool
  localFuel : Bool
  fuel : Nat
  source : Nat
deriving DecidableEq, Repr

inductive Event where
  | formA | formH | associateA | associateH | repair | capture
  | localCopyA | localCopyH | bulkCopyA | bulkCopyH
  | wearFreeA | wearFreeH | wearResident | damage | leakCommon | leakLocal
deriving DecidableEq, Repr

def bit : Bool → Nat | false => 0 | true => 1
def occupied : Resident → Nat | .empty => 0 | _ => 1
def activeResident : Resident → Nat | .active => 1 | _ => 0
def alternativeResident : Resident → Nat | .alternative => 1 | _ => 0
def population (s : State) : Nat := s.aFree + s.hFree + occupied s.resident
def aCount (s : State) : Nat := s.aFree + activeResident s.resident
def hCount (s : State) : Nat := s.hFree + alternativeResident s.resident
def precursor (material : Nat) (s : State) : Nat := material - population s
def Valid (material : Nat) (s : State) : Prop := population s ≤ material

def Enabled (material : Nat) (s : State) : Event → Prop
  | .formA | .formH => s.intact = false ∧ population s < material ∧ 0 < s.fuel
  | .associateA => 0 < s.aFree ∧ s.resident = .empty ∧ 0 < s.fuel
  | .associateH => 0 < s.hFree ∧ s.resident = .empty ∧ 0 < s.fuel
  | .repair => s.resident = .active ∧ s.intact = false ∧ 0 < s.fuel
  | .capture => s.intact = true ∧ s.localFuel = false ∧ 0 < s.source
  | .localCopyA => s.resident = .active ∧ s.localFuel = true ∧ population s < material
  | .localCopyH => s.resident = .alternative ∧ s.localFuel = true ∧ population s < material
  | .bulkCopyA => 0 < aCount s ∧ population s < material ∧ 0 < s.fuel
  | .bulkCopyH => 0 < hCount s ∧ population s < material ∧ 0 < s.fuel
  | .wearFreeA => 0 < s.aFree
  | .wearFreeH => 0 < s.hFree
  | .wearResident => s.resident ≠ .empty
  | .damage => s.intact = true
  | .leakCommon => 0 < s.fuel
  | .leakLocal => s.localFuel = true

def advance (s : State) : Event → State
  | .formA => { s with aFree := s.aFree + 1, fuel := s.fuel - 1 }
  | .formH => { s with hFree := s.hFree + 1, fuel := s.fuel - 1 }
  | .associateA => { s with aFree := s.aFree - 1, resident := .active, fuel := s.fuel - 1 }
  | .associateH => { s with hFree := s.hFree - 1, resident := .alternative, fuel := s.fuel - 1 }
  | .repair => { s with intact := true, fuel := s.fuel - 1 }
  | .capture => { s with localFuel := true, source := s.source - 1 }
  | .localCopyA => { s with aFree := s.aFree + 1, localFuel := false }
  | .localCopyH => { s with hFree := s.hFree + 1, localFuel := false }
  | .bulkCopyA => { s with aFree := s.aFree + 1, fuel := s.fuel - 1 }
  | .bulkCopyH => { s with hFree := s.hFree + 1, fuel := s.fuel - 1 }
  | .wearFreeA => { s with aFree := s.aFree - 1 }
  | .wearFreeH => { s with hFree := s.hFree - 1 }
  | .wearResident => { s with resident := .empty }
  | .damage => { s with intact := false }
  | .leakCommon => { s with fuel := s.fuel - 1 }
  | .leakLocal => { s with localFuel := false }

def Step (material : Nat) (s : State) (a : Event) (t : State) : Prop :=
  Valid material s ∧ Enabled material s a ∧ t = advance s a

instance (material : Nat) (s : State) : Decidable (Valid material s) := by
  unfold Valid
  infer_instance

instance (material : Nat) (s : State) (a : Event) : Decidable (Enabled material s a) := by
  cases a <;> unfold Enabled <;> infer_instance

instance (material : Nat) (s : State) (a : Event) (t : State) :
    Decidable (Step material s a t) := by
  unfold Step
  infer_instance

inductive Trace (material : Nat) : State → List Event → State → Prop where
  | nil (s : State) : Trace material s [] s
  | cons {s u t : State} {a : Event} {as : List Event} :
      Step material s a u → Trace material u as t → Trace material s (a :: as) t

def expenditure : Event → Nat
  | .capture | .wearFreeA | .wearFreeH | .wearResident | .damage => 0
  | _ => 1

def commonExpenditure : Event → Nat
  | .formA | .formH | .associateA | .associateH | .repair
  | .bulkCopyA | .bulkCopyH | .leakCommon => 1
  | _ => 0

def copyIncrement : Event → Nat
  | .localCopyA | .localCopyH | .bulkCopyA | .bulkCopyH => 1
  | _ => 0

def eventIndicator (target : Event) (a : Event) : Nat := if a = target then 1 else 0

def tally (weight : Event → Nat) : List Event → Nat
  | [] => 0
  | a :: as => weight a + tally weight as

def energy (s : State) : Nat := s.fuel + s.source + bit s.localFuel
def rank (s : State) : Nat :=
  4 * s.source + 2 * s.fuel + 2 * bit s.localFuel + bit s.intact + population s

def rankDrop : Event → Nat
  | .associateA | .associateH | .capture | .leakCommon | .leakLocal => 2
  | _ => 1

variable {material : Nat} {s t : State} {a : Event} {as : List Event}

theorem population_type_sum (s : State) : aCount s + hCount s = population s := by
  cases hr : s.resident <;>
    simp [aCount, hCount, population, activeResident, alternativeResident, occupied, hr] <;> omega

theorem step_valid (h : Step material s a t) : Valid material t := by
  rcases h with ⟨hv, he, rfl⟩
  cases a <;> cases hr : s.resident <;>
    simp_all [Valid, Enabled, advance, population, occupied, aCount, hCount,
      activeResident, alternativeResident] <;> omega

theorem trace_valid (hv : Valid material s) (h : Trace material s as t) : Valid material t := by
  induction h with
  | nil => exact hv
  | cons hs _ ih => exact ih (step_valid hs)

theorem material_ledger (hv : Valid material s) :
    aCount s + hCount s + precursor material s = material := by
  have hp := population_type_sum s
  simp only [precursor, Valid] at *
  omega

theorem trace_material_ledger (hv : Valid material s) (h : Trace material s as t) :
    aCount t + hCount t + precursor material t = material :=
  material_ledger (trace_valid hv h)

theorem step_energy_ledger (h : Step material s a t) :
    energy t + expenditure a = energy s := by
  rcases h with ⟨_, he, rfl⟩
  cases a <;> cases hl : s.localFuel <;>
    simp_all [Enabled, advance, energy, expenditure, bit] <;> omega

theorem trace_energy_ledger (h : Trace material s as t) :
    energy t + tally expenditure as = energy s := by
  induction h with
  | nil => simp [tally]
  | cons hs _ ih =>
    have hh := step_energy_ledger hs
    simp only [tally]
    omega

theorem step_common_ledger (h : Step material s a t) :
    t.fuel + commonExpenditure a = s.fuel := by
  rcases h with ⟨_, he, rfl⟩
  cases a <;> simp_all [Enabled, advance, commonExpenditure] <;> omega

theorem trace_common_ledger (h : Trace material s as t) :
    t.fuel + tally commonExpenditure as = s.fuel := by
  induction h with
  | nil => simp [tally]
  | cons hs _ ih =>
    have hh := step_common_ledger hs
    simp only [tally]
    omega

theorem copy_increment_le_spent (a : Event) : copyIncrement a ≤ expenditure a := by
  cases a <;> decide

theorem copy_tally_le_spent (as : List Event) :
    tally copyIncrement as ≤ tally expenditure as := by
  induction as with
  | nil => simp [tally]
  | cons a as ih =>
    have hh := copy_increment_le_spent a
    simp only [tally]
    omega

theorem trace_copy_budget (h : Trace material s as t) : tally copyIncrement as ≤ energy s := by
  have hh := trace_energy_ledger h
  have hc := copy_tally_le_spent as
  omega

theorem exact_step_rank_drop (h : Step material s a t) : rank t + rankDrop a = rank s := by
  rcases h with ⟨_, he, rfl⟩
  cases a <;> cases hr : s.resident <;> cases hc : s.intact <;> cases hl : s.localFuel <;>
    simp_all [Enabled, advance, rank, rankDrop, bit, population, occupied,
      aCount, hCount, activeResident, alternativeResident] <;> omega

theorem step_strict_rank (h : Step material s a t) : rank t < rank s := by
  have hh := exact_step_rank_drop h
  have hp : 0 < rankDrop a := by cases a <;> decide
  omega

theorem trace_event_bound (h : Trace material s as t) : as.length + rank t ≤ rank s := by
  induction h with
  | nil => simp
  | cons hs _ ih =>
    have hh := step_strict_rank hs
    simp only [List.length_cons]
    omega

theorem no_infinite_event_path (states : Nat → State) (events : Nat → Event)
    (h : ∀ n, Step material (states n) (events n) (states (n + 1))) : False := by
  have hh : ∀ n, n + rank (states n) ≤ rank (states 0) := by
    intro n
    induction n with
    | zero => omega
    | succ n ih =>
      have hs := step_strict_rank (h n)
      omega
  have exceeded := hh (rank (states 0) + 1)
  omega

/-- Formation, association and repair have three separately paid stages. -/
def phase (s : State) : Nat :=
  if s.intact then 3 else
    match s.resident with
    | .empty => min 1 (s.aFree + s.hFree)
    | _ => 2

theorem step_paid_phase (h : Step material s a t) :
    t.fuel + phase t ≤ s.fuel + phase s := by
  rcases h with ⟨_, he, rfl⟩
  cases a <;> cases hr : s.resident <;> cases hc : s.intact <;>
    simp_all [Enabled, advance, phase, population, occupied, aCount, hCount,
      activeResident, alternativeResident] <;> omega

theorem trace_paid_phase (h : Trace material s as t) :
    t.fuel + phase t ≤ s.fuel + phase s := by
  induction h with
  | nil => omega
  | cons hs _ ih =>
    have hh := step_paid_phase hs
    omega

def Absent (s : State) : Prop :=
  s.aFree = 0 ∧ s.hFree = 0 ∧ s.resident = .empty

theorem repair_needs_three_initial_common_units
    (hi : Absent s) (hc : s.intact = false) (h : Trace material s as t)
    (ht : t.intact = true) : 3 ≤ s.fuel := by
  have hh := trace_paid_phase h
  simp_all [Absent, phase]
  omega

theorem low_fuel_cannot_restore_site
    (hi : Absent s) (hc : s.intact = false) (hf : s.fuel < 3)
    (h : Trace material s as t) : t.intact = false := by
  cases ht : t.intact with
  | false => rfl
  | true =>
    have hh := repair_needs_three_initial_common_units hi hc h ht
    omega

/-- The second type's origin is an additional paid obligation, not a free contest seed. -/
def mixedPhase (s : State) : Nat :=
  (if s.intact then 3 else
    match s.resident with
    | .active => 2
    | _ => min 1 (aCount s)) + min 1 (hCount s)

theorem step_paid_mixed_phase (h : Step material s a t) :
    t.fuel + mixedPhase t ≤ s.fuel + mixedPhase s := by
  rcases h with ⟨_, he, rfl⟩
  cases a <;> cases hr : s.resident <;> cases hc : s.intact <;>
    simp_all [Enabled, advance, mixedPhase, population, occupied, aCount, hCount,
      activeResident, alternativeResident] <;> omega

theorem trace_paid_mixed_phase (h : Trace material s as t) :
    t.fuel + mixedPhase t ≤ s.fuel + mixedPhase s := by
  induction h with
  | nil => omega
  | cons hs _ ih =>
    have hh := step_paid_mixed_phase hs
    omega

theorem restored_site_and_alternative_need_four_initial_common_units
    (hi : Absent s) (hc : s.intact = false) (h : Trace material s as t)
    (ht : t.intact = true) (hh : 0 < hCount t) : 4 ≤ s.fuel := by
  have hb := trace_paid_mixed_phase h
  have hstart : mixedPhase s = 0 := by
    rcases hi with ⟨ha, hh0, hr⟩
    simp [mixedPhase, hc, hr, aCount, hCount, activeResident, alternativeResident, ha, hh0]
  have hend : mixedPhase t = 3 + min 1 (hCount t) := by
    simp [mixedPhase, ht]
  rw [hstart, hend] at hb
  omega

theorem a_absence_step (hi : aCount s = 0) (hn : a ≠ .formA)
    (h : Step material s a t) : aCount t = 0 := by
  rcases h with ⟨_, he, rfl⟩
  cases a <;> cases hr : s.resident <;>
    simp_all [Enabled, advance, aCount, hCount, activeResident, alternativeResident] <;> omega

theorem h_absence_step (hi : hCount s = 0) (hn : a ≠ .formH)
    (h : Step material s a t) : hCount t = 0 := by
  rcases h with ⟨_, he, rfl⟩
  cases a <;> cases hr : s.resident <;>
    simp_all [Enabled, advance, aCount, hCount, activeResident, alternativeResident] <;> omega

theorem a_absence_trace (hi : aCount s = 0) (hn : Event.formA ∉ as)
    (h : Trace material s as t) : aCount t = 0 := by
  induction h with
  | nil => exact hi
  | cons hs _ ih =>
    simp only [List.mem_cons, not_or] at hn
    exact ih (a_absence_step hi (Ne.symm hn.1) hs) hn.2

theorem h_absence_trace (hi : hCount s = 0) (hn : Event.formH ∉ as)
    (h : Trace material s as t) : hCount t = 0 := by
  induction h with
  | nil => exact hi
  | cons hs _ ih =>
    simp only [List.mem_cons, not_or] at hn
    exact ih (h_absence_step hi (Ne.symm hn.1) hs) hn.2

theorem a_appearance_requires_formation (hi : aCount s = 0)
    (h : Trace material s as t) (ht : 0 < aCount t) : Event.formA ∈ as := by
  by_cases hn : Event.formA ∈ as
  · exact hn
  · have hh := a_absence_trace hi hn h
    omega

theorem h_appearance_requires_formation (hi : hCount s = 0)
    (h : Trace material s as t) (ht : 0 < hCount t) : Event.formH ∈ as := by
  by_cases hn : Event.formH ∈ as
  · exact hn
  · have hh := h_absence_trace hi hn h
    omega

theorem a_copy_has_template (ha : a = .localCopyA ∨ a = .bulkCopyA)
    (h : Step material s a t) :
    0 < aCount s ∧ aCount t = aCount s + 1 ∧ hCount t = hCount s := by
  rcases h with ⟨_, he, rfl⟩
  cases a <;> cases hr : s.resident <;>
    simp_all [Enabled, advance, aCount, hCount, activeResident, alternativeResident] <;> omega

theorem h_copy_has_template (ha : a = .localCopyH ∨ a = .bulkCopyH)
    (h : Step material s a t) :
    0 < hCount s ∧ hCount t = hCount s + 1 ∧ aCount t = aCount s := by
  rcases h with ⟨_, he, rfl⟩
  cases a <;> cases hr : s.resident <;>
    simp_all [Enabled, advance, aCount, hCount, activeResident, alternativeResident] <;> omega

/-- If the active resident cannot leave, its repaired site cannot be inherited by H. -/
def SupportOwned (s : State) : Prop :=
  s.resident ≠ .active → s.intact = false ∧ s.localFuel = false

theorem owned_support_step (hi : SupportOwned s) (hn : a ≠ .wearResident)
    (h : Step material s a t) : SupportOwned t := by
  rcases h with ⟨_, he, rfl⟩
  cases a <;> cases hr : s.resident <;>
    simp_all [SupportOwned, Enabled, advance]

theorem owned_support_trace (hi : SupportOwned s) (hn : Event.wearResident ∉ as)
    (h : Trace material s as t) : SupportOwned t := by
  induction h with
  | nil => exact hi
  | cons hs _ ih =>
    simp only [List.mem_cons, not_or] at hn
    exact ih (owned_support_step hi (Ne.symm hn.1) hs) hn.2

theorem owned_support_forbids_h_local_copy (hi : SupportOwned s)
    (h : Step material s a t) : a ≠ .localCopyH := by
  rcases h with ⟨_, he, _⟩
  cases a <;> cases hr : s.resident <;> simp_all [SupportOwned, Enabled]

theorem no_h_local_copies_without_resident_wear
    (hi : SupportOwned s) (hn : Event.wearResident ∉ as)
    (h : Trace material s as t) : tally (eventIndicator .localCopyH) as = 0 := by
  induction h with
  | nil => simp [tally]
  | cons hs _ ih =>
    simp only [List.mem_cons, not_or] at hn
    have hf := owned_support_forbids_h_local_copy hi hs
    have ht := ih (owned_support_step hi (Ne.symm hn.1) hs) hn.2
    simp [tally, eventIndicator, hf, ht]

def initial : State := ⟨0, 0, .empty, false, false, 4, 1⟩
def formedH : State := ⟨0, 1, .empty, false, false, 3, 1⟩
def formed : State := ⟨1, 1, .empty, false, false, 2, 1⟩
def associated : State := ⟨0, 1, .active, false, false, 1, 1⟩
def repaired : State := ⟨0, 1, .active, true, false, 0, 1⟩
def captured : State := ⟨0, 1, .active, true, true, 0, 0⟩
def copied : State := ⟨1, 1, .active, true, false, 0, 0⟩
def witnessEvents : List Event := [.formH, .formA, .associateA, .repair, .capture, .localCopyA]

theorem paid_formation_to_copy : Trace 3 initial witnessEvents copied := by
  apply Trace.cons (u := formedH) (by decide)
  apply Trace.cons (u := formed) (by decide)
  apply Trace.cons (u := associated) (by decide)
  apply Trace.cons (u := repaired) (by decide)
  apply Trace.cons (u := captured) (by decide)
  apply Trace.cons (u := copied) (by decide)
  exact Trace.nil _

theorem witness_accounting :
    Absent initial ∧ aCount copied = 2 ∧ hCount copied = 1 ∧
    tally expenditure witnessEvents = 5 ∧
    tally commonExpenditure witnessEvents = 4 ∧
    tally (eventIndicator .localCopyA) witnessEvents = 1 ∧
    energy copied = 0 := by unfold Absent; decide

theorem repair_enables_capture :
    ¬ Enabled 3 associated .capture ∧ Enabled 3 repaired .capture := by decide

theorem capture_enables_copy :
    ¬ Enabled 3 repaired .localCopyA ∧ Enabled 3 captured .localCopyA := by decide

theorem initial_owned_support : SupportOwned initial := by
  simp [SupportOwned, initial]

theorem no_h_local_copies_from_absence_without_resident_wear
    (hn : Event.wearResident ∉ as) (h : Trace 3 initial as t) :
    tally (eventIndicator .localCopyH) as = 0 :=
  no_h_local_copies_without_resident_wear initial_owned_support hn h

/-- The same repertoire lets an alternative inherit the repaired site after wear. -/
def inheritanceInitial : State := ⟨0, 0, .empty, false, false, 5, 1⟩
def inheritanceFinal : State := ⟨0, 1, .alternative, true, false, 0, 0⟩
def inheritanceEvents : List Event :=
  [.formA, .formH, .associateA, .repair, .wearResident, .associateH, .capture, .localCopyH]

theorem repaired_site_can_pass_to_alternative :
    Trace 2 inheritanceInitial inheritanceEvents inheritanceFinal := by
  apply Trace.cons (u := ⟨1, 0, .empty, false, false, 4, 1⟩) (by decide)
  apply Trace.cons (u := ⟨1, 1, .empty, false, false, 3, 1⟩) (by decide)
  apply Trace.cons (u := ⟨0, 1, .active, false, false, 2, 1⟩) (by decide)
  apply Trace.cons (u := ⟨0, 1, .active, true, false, 1, 1⟩) (by decide)
  apply Trace.cons (u := ⟨0, 1, .empty, true, false, 1, 1⟩) (by decide)
  apply Trace.cons (u := ⟨0, 0, .alternative, true, false, 0, 1⟩) (by decide)
  apply Trace.cons (u := ⟨0, 0, .alternative, true, true, 0, 0⟩) (by decide)
  apply Trace.cons (u := inheritanceFinal) (by decide)
  exact Trace.nil _

theorem inheritance_accounting :
    Absent inheritanceInitial ∧ aCount inheritanceFinal = 0 ∧
    hCount inheritanceFinal = 2 ∧
    tally (eventIndicator .localCopyH) inheritanceEvents = 1 ∧
    tally commonExpenditure inheritanceEvents = 5 ∧
    tally expenditure inheritanceEvents = 6 := by unfold Absent; decide

#print axioms population_type_sum
#print axioms step_valid
#print axioms trace_valid
#print axioms material_ledger
#print axioms trace_material_ledger
#print axioms step_energy_ledger
#print axioms trace_energy_ledger
#print axioms step_common_ledger
#print axioms trace_common_ledger
#print axioms copy_increment_le_spent
#print axioms copy_tally_le_spent
#print axioms trace_copy_budget
#print axioms exact_step_rank_drop
#print axioms step_strict_rank
#print axioms trace_event_bound
#print axioms no_infinite_event_path
#print axioms step_paid_phase
#print axioms trace_paid_phase
#print axioms repair_needs_three_initial_common_units
#print axioms low_fuel_cannot_restore_site
#print axioms step_paid_mixed_phase
#print axioms trace_paid_mixed_phase
#print axioms restored_site_and_alternative_need_four_initial_common_units
#print axioms a_absence_step
#print axioms h_absence_step
#print axioms a_absence_trace
#print axioms h_absence_trace
#print axioms a_appearance_requires_formation
#print axioms h_appearance_requires_formation
#print axioms a_copy_has_template
#print axioms h_copy_has_template
#print axioms owned_support_step
#print axioms owned_support_trace
#print axioms owned_support_forbids_h_local_copy
#print axioms no_h_local_copies_without_resident_wear
#print axioms paid_formation_to_copy
#print axioms witness_accounting
#print axioms repair_enables_capture
#print axioms capture_enables_copy
#print axioms initial_owned_support
#print axioms no_h_local_copies_from_absence_without_resident_wear
#print axioms repaired_site_can_pass_to_alternative
#print axioms inheritance_accounting

end FormedSelection
