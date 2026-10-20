import Becoming.Countdown
import ReservedShutdown

/-!
# Correction and shutdown protocols as instances of the core's countdown laws (periphery)

The protocol machines of `MediatedControl`, `RecoverableControl` and `ReservedShutdown` are
defined with library instances and proved with `simp`, so their instances of the pure core's laws
are stated here rather than in the pure bridge. The core does not import this module.

* **Kept along admitted histories.** Each protocol's `History` is reachability under the steps
  its law takes where its source law admits the event (`mediated_history_iff`,
  `recoverable_history_iff`, the core's `Countdown.admitted`). So coverage is kept along every
  history of lawful reads and committed programs, and safety along every interrupted history,
  exactly because each admitted step keeps it (`coverage_along`, `safety_along`, from
  `Countdown.admitted_invariant_iff`); the original history theorems are these instances
  (`mediated_history_instance`, `interrupted_history_instance`).
* **Supported completion.** A pending recovery is counted work: each tick does one remaining write
  (or the publication) for one unit of reserve and one unit of time, publishes when no write
  remains, and stalls without reserve or time (`counts`). So `n` remaining writes and the
  publication complete in `n + 1` resumed steps exactly when the reserve covers `n + 1` units and
  the deadline `n + 1` more steps (`publishes_iff`); no shorter resumption publishes
  (`pending_until_published`). `funded_suffix_publishes` is the sufficient half; the exhaustion
  cases are instances of the necessary half.
* **A reserved stop.** The shutdown supervisor is a reserved exit: every admissible cycle from a
  valid supervisor stays valid and either stops or lowers the margin above the three reserved
  units by one, and a stopped supervisor stays stopped (`reserved`). So every admissible schedule
  runs and stays valid (`schedule_valid`), and every admissible schedule longer than the margin
  stops (`schedule_stops`); `every_supported_schedule_finishes` is an instance
  (`supported_schedule_instance`).

Declarations may depend on `propext`, `Quot.sound` and `Classical.choice` only, through the
machines' definitions. Correspondence of these machines to actual devices, authorities or
recoveries is not checked.
-/

namespace Becoming.ProtocolInstances

open Becoming Becoming.Countdown Becoming.Assurance

/-! ## Histories as reachability under admitted steps -/

section Mediated

/-- The admitted steps of the mediated machine. -/
def mediated : Generative.Process MediatedControl.Machine MediatedControl.Event :=
  admitted (fun m e => MediatedControl.step e m) (fun m e => MediatedControl.SourceLaw e m)

theorem mediated_history_cons {s m t : MediatedControl.Machine} (step : mediated.step s e m)
    (rest : MediatedControl.History m t) : MediatedControl.History s t := by
  induction rest with
  | nil => exact .step (.nil s) e step.1 step.2
  | step _ e' source done ih => exact .step ih e' source done

/-- **A mediated history is reachability under admitted steps.** -/
theorem mediated_history_iff {s t : MediatedControl.Machine} :
    MediatedControl.History s t ↔ Reach mediated s t := by
  constructor
  · intro history
    induction history with
    | nil => exact Reach.refl _ _
    | step _ e source done ih => exact Reach.trans ih (Reach.of_step ⟨source, done⟩)
  · rintro ⟨plan, path⟩
    induction path with
    | nil m => exact .nil m
    | cons step _ ih => exact mediated_history_cons step ih

/-- **Coverage is kept along every admitted course**, because every admitted step keeps it. -/
theorem coverage_along :
    ∀ s t, Reach mediated s t → TemporalInspection.Known s.tracked → TemporalInspection.Known t.tracked :=
  admitted_invariant_iff.mp fun s e t source done known =>
    MediatedControl.mediated_step_preserves_coverage e s t known source done

/-- `mediated_history_preserves_coverage` is an instance. -/
theorem mediated_history_instance {s t : MediatedControl.Machine} (history : MediatedControl.History s t)
    (known : TemporalInspection.Known s.tracked) : TemporalInspection.Known t.tracked :=
  coverage_along s t (mediated_history_iff.mp history) known

end Mediated

section Recoverable

/-- The admitted steps of the recoverable device: preparation, ticks, crashes and uses. -/
def recoverable : Generative.Process RecoverableControl.Device RecoverableControl.Event :=
  admitted (fun d e => RecoverableControl.step e d) (fun d e => RecoverableControl.SourceLaw e d)

theorem recoverable_history_cons {s m t : RecoverableControl.Device}
    (step : recoverable.step s e m) (rest : RecoverableControl.History m t) :
    RecoverableControl.History s t := by
  induction rest with
  | nil => exact .next (.nil s) e step.1 step.2
  | next _ e' source done ih => exact .next ih e' source done

/-- **An interrupted history is reachability under admitted steps**, crashes included. -/
theorem recoverable_history_iff {s t : RecoverableControl.Device} :
    RecoverableControl.History s t ↔ Reach recoverable s t := by
  constructor
  · intro history
    induction history with
    | nil => exact Reach.refl _ _
    | next _ e source done ih => exact Reach.trans ih (Reach.of_step ⟨source, done⟩)
  · rintro ⟨plan, path⟩
    induction path with
    | nil d => exact .nil d
    | cons step _ ih => exact recoverable_history_cons step ih

/-- **Safety is kept along every admitted course, interruptions included**, because every
admitted step keeps it. -/
theorem safety_along :
    ∀ s t, Reach recoverable s t → RecoverableControl.Safe s → RecoverableControl.Safe t :=
  admitted_invariant_iff.mp fun s e t source done safe =>
    RecoverableControl.step_preserves_safety e s t safe source done

/-- `interrupted_history_preserves_safety` is an instance. -/
theorem interrupted_history_instance {s t : RecoverableControl.Device}
    (history : RecoverableControl.History s t) (safe : RecoverableControl.Safe s) :
    RecoverableControl.Safe t :=
  safety_along s t (recoverable_history_iff.mp history) safe

/-! ## Supported completion -/

open RecoverableControl in
/-- Pending: the device holds a pending description. -/
def busy (d : Device) : Prop := ∃ r, d = .busy r

open RecoverableControl in
/-- Published: the device is ready again. -/
def done (d : Device) : Prop := ∃ m, d = .ready m

open RecoverableControl in
/-- The remaining writes of a pending description. -/
def work : Device → Nat
  | .busy r => r.todo.length
  | .ready _ => 0

open RecoverableControl in
/-- The units a pending description can still draw: reserve and time to the deadline. -/
def fuel : Device → Nat
  | .busy r => min r.target.tracked.installation.state.reserve
      (r.target.tracked.installation.state.deadline - r.target.tracked.installation.state.time)
  | .ready _ => 0

/-- The state after one unit is drawn. -/
def unitState (s : EffectiveCommand.State) : EffectiveCommand.State :=
  {s with reserve := s.reserve - 1, spent := s.spent + 1, time := s.time + 1}

open RecoverableControl in
/-- The pending description after one unit is drawn. -/
def afterUnit (r : Pending) : Pending :=
  {r with target := accounting r.target (unitState r.target.tracked.installation.state)}

open RecoverableControl in
/-- The pending description after one write with its unit drawn. -/
def advanced (r : Pending) (op : MediatedControl.Write) (rest : List MediatedControl.Write) :
    Pending :=
  let moved := afterUnit r
  {moved with actual := MediatedControl.oneWrite op moved.actual, todo := rest}

open RecoverableControl in
theorem unit_drawn (r : Pending) (reserve : 1 ≤ r.target.tracked.installation.state.reserve)
    (time : r.target.tracked.installation.state.time + 1 ≤ r.target.tracked.installation.state.deadline) :
    charge r = some (afterUnit r) := by
  simp [charge, afterUnit, unitState, EffectiveCommand.spend, reserve, time]

open RecoverableControl in
theorem stalls_unsupported (r : Pending)
    (short : min r.target.tracked.installation.state.reserve
      (r.target.tracked.installation.state.deadline - r.target.tracked.installation.state.time) = 0) :
    charge r = none := by
  have : ¬ (1 ≤ r.target.tracked.installation.state.reserve ∧
      r.target.tracked.installation.state.time + 1 ≤ r.target.tracked.installation.state.deadline) := by
    intro h
    have := Nat.le_min.mpr ⟨h.1, (show 1 ≤ r.target.tracked.installation.state.deadline -
      r.target.tracked.installation.state.time by omega)⟩
    omega
  simp [charge, EffectiveCommand.spend, this]

/-- **A pending recovery is counted work**: one tick does one remaining write, or the
publication, for one unit of reserve and time; without either it stalls. -/
theorem counts : CountedWork RecoverableControl.tick busy done work fuel := by
  refine ⟨?_, ?_, ?_⟩
  · rintro s ⟨r, rfl⟩ positive worked
    have reserve : 1 ≤ r.target.tracked.installation.state.reserve :=
      Nat.le_trans positive (Nat.min_le_left _ _)
    have time : r.target.tracked.installation.state.time + 1 ≤
        r.target.tracked.installation.state.deadline := by
      have := Nat.le_trans positive (Nat.min_le_right _ _)
      omega
    cases hodo : r.todo with
    | nil => simp [work, hodo] at worked
    | cons op rest =>
      refine ⟨.busy (advanced r op rest), ?_, ⟨_, rfl⟩, ?_, ?_⟩
      · have todo' : (afterUnit r).todo = op :: rest := hodo
        simp [RecoverableControl.tick, unit_drawn r reserve time, todo', advanced]
      · simp [work, advanced, hodo]
      · simp only [fuel, advanced, afterUnit, unitState, RecoverableControl.accounting]
        omega
  · rintro s ⟨r, rfl⟩ positive finished
    have reserve : 1 ≤ r.target.tracked.installation.state.reserve :=
      Nat.le_trans positive (Nat.min_le_left _ _)
    have time : r.target.tracked.installation.state.time + 1 ≤
        r.target.tracked.installation.state.deadline := by
      have := Nat.le_trans positive (Nat.min_le_right _ _)
      omega
    have hodo : (afterUnit r).todo = [] := List.eq_nil_of_length_eq_zero finished
    exact ⟨.ready {(afterUnit r).target with tracked := {(afterUnit r).target.tracked with
        actual := (afterUnit r).actual}},
      by simp [RecoverableControl.tick, unit_drawn r reserve time, hodo], ⟨_, rfl⟩⟩
  · rintro s ⟨r, rfl⟩ empty
    simp [RecoverableControl.tick, stalls_unsupported r empty]

/-- The device's resumption is the core's run of ticks. -/
theorem resumeSteps_eq : ∀ (n : Nat) (d : RecoverableControl.Device),
    RecoverableControl.resumeSteps n d = ticks RecoverableControl.tick n d
  | 0, _ => rfl
  | n + 1, d => by
    show (RecoverableControl.tick d).bind (RecoverableControl.resumeSteps n) =
      (RecoverableControl.tick d).bind (ticks RecoverableControl.tick n)
    cases RecoverableControl.tick d with
    | none => rfl
    | some e => exact resumeSteps_eq n e

/-- **`n` remaining writes and the publication complete in `n + 1` resumed steps exactly when
the reserve covers `n + 1` units and the deadline `n + 1` more steps.** -/
theorem publishes_iff (r : RecoverableControl.Pending) :
    (∃ m, RecoverableControl.resumeSteps (r.todo.length + 1) (.busy r) = some (.ready m)) ↔
      r.todo.length + 1 ≤ r.target.tracked.installation.state.reserve ∧
        r.target.tracked.installation.state.time + r.todo.length + 1 ≤
          r.target.tracked.installation.state.deadline := by
  have law := completes_iff counts (s := .busy r) ⟨r, rfl⟩
  simp only [work, fuel, ← resumeSteps_eq] at law
  constructor
  · rintro ⟨m, ran⟩
    have := Nat.le_min.mp (law.mp ⟨_, ran, ⟨m, rfl⟩⟩)
    omega
  · rintro ⟨reserve, time⟩
    obtain ⟨t, ran, m, rfl⟩ := law.mpr (Nat.le_min.mpr ⟨reserve, by omega⟩)
    exact ⟨m, ran⟩

/-- **No shorter resumption publishes**: within the remaining writes, every resumed run leaves a
pending description, with the writes lowered by the steps taken. -/
theorem pending_until_published (r : RecoverableControl.Pending) {k : Nat} {d : RecoverableControl.Device}
    (within : k ≤ r.todo.length) (ran : RecoverableControl.resumeSteps k (.busy r) = some d) :
    busy d ∧ work d + k = r.todo.length :=
  pending_before counts ⟨r, rfl⟩ within ((resumeSteps_eq k _).symm.trans ran)

end Recoverable

/-! ## A reserved stop -/

section Reserved

open ReservedShutdown

/-- A supervisor for the grant `g` and bound `bound`, armed while active and safely stopped once
stopped. -/
def valid (g : Grant) (bound : Nat) : Supervisor → Prop
  | .active g' b d => g' = g ∧ b = bound ∧ Armed g d
  | .stopped d => RecoverableControl.Safe d ∧ Stopped d

/-- The supervisor has stopped. -/
def exit (s : Supervisor) : Prop := stopped s = true

/-- The units above the three reserved for stopping. -/
def margin : Supervisor → Nat
  | .active _ _ d => (state d).reserve - 3
  | .stopped _ => 0

/-- **The shutdown supervisor is a reserved exit.** -/
theorem reserved (g : Grant) (bound : Nat) :
    Reserved (fun s a => cycle a s) (admissible bound) (valid g bound) exit margin := by
  refine ⟨?_, ?_⟩
  · intro s a held allowed
    cases s with
    | stopped d => exact ⟨.stopped d, rfl, held, .inl rfl⟩
    | active g' b d =>
      obtain ⟨rfl, rfl, armed⟩ := held
      obtain ⟨out, ran, holds, next⟩ := cycle_keeps_access_or_stops a g' b d armed allowed
      refine ⟨out, ran, ?_, ?_⟩
      · cases out with
        | stopped e => exact holds
        | active g'' b' e =>
          rcases next with halt | ⟨e', same, _⟩
          · cases halt
          · cases same
            exact ⟨rfl, rfl, holds⟩
      · rcases next with halt | ⟨e, rfl, lowered⟩
        · exact .inl halt
        · refine .inr ?_
          have three : 3 ≤ (state e).reserve := holds.2.2.1
          simp only [margin]
          omega
  · intro s a t out ran
    cases s with
    | active _ _ _ => cases out
    | stopped d =>
      simp only [cycle, Option.some.injEq] at ran
      subst ran
      rfl

/-- The supervisor's run of a schedule is the core's run of the partial law. -/
theorem run_eq : ∀ (events : List Attempt) (s : Supervisor),
    ReservedShutdown.run events s = runPartial (fun s a => cycle a s) s events
  | [], _ => rfl
  | a :: rest, s => by
    show (cycle a s).bind (ReservedShutdown.run rest) =
      (cycle a s).bind fun t => runPartial (fun s a => cycle a s) t rest
    cases cycle a s with
    | none => rfl
    | some t => exact run_eq rest t

/-- **Every admissible schedule from an armed supervisor runs and stays valid.** -/
theorem schedule_valid (g : Grant) (bound : Nat) (d : RecoverableControl.Device) (armed : Armed g d)
    (events : List Attempt) (allowed : ∀ a, a ∈ events → admissible bound a) :
    ∃ s, ReservedShutdown.run events (.active g bound d) = some s ∧ valid g bound s := by
  obtain ⟨s, ran, held⟩ := runs_valid (reserved g bound) events (.active g bound d)
    ⟨rfl, rfl, armed⟩ allowed
  exact ⟨s, (run_eq events _).trans ran, held⟩

/-- **Every admissible schedule longer than the margin above the reserved three units stops**,
safely. -/
theorem schedule_stops (g : Grant) (bound : Nat) (d : RecoverableControl.Device) (armed : Armed g d)
    (events : List Attempt) (allowed : ∀ a, a ∈ events → admissible bound a)
    (long : (state d).reserve - 3 < events.length) :
    ∃ out, ReservedShutdown.run events (.active g bound d) = some (.stopped out) ∧
      RecoverableControl.Safe out ∧ Stopped out := by
  obtain ⟨s, ran, held, out⟩ := exits (reserved g bound) events (.active g bound d)
    ⟨rfl, rfl, armed⟩ allowed long
  cases s with
  | active _ _ _ => cases out
  | stopped e => exact ⟨e, (run_eq events _).trans ran, held⟩

/-- `every_supported_schedule_finishes` is an instance. -/
theorem supported_schedule_instance (events : List Attempt) (g : Grant) (bound : Nat)
    (d : RecoverableControl.Device) (armed : Armed g d) (allowed : ∀ a, a ∈ events → admissible bound a)
    (enough : (state d).reserve ≤ events.length + 2) :
    ∃ out, ReservedShutdown.run events (.active g bound d) = some (.stopped out) ∧
      RecoverableControl.Safe out ∧ Stopped out :=
  schedule_stops g bound d armed events allowed (by have := armed.2.2.1; omega)

end Reserved

end Becoming.ProtocolInstances
