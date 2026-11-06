import Becoming.Revision
import Becoming.Stock
import Becoming.Contacts

/-!
# Acquired consequences revise the next reference plan

An instance of the shared Process/Trace. Activity, return, retained method,
fresh reference contact, construction and later use are relations in one history.
The method is a finite list of addressed contacts, not a choice between two named
controllers. Acquired mismatch puts an address into the next executable plan.
Each planned contact acquires BOTH Boolean references; installation checks their
separation and uses fuel. No generator reads the channel except through the declared
contact, which uses fuel. A repeated native history, matched frozen-method control,
erasure, exhaustion, failed separation and drift delimit the claim.

The general laws come first, in `Becoming.Stock` and `Becoming.Contacts`; the last section
reads this process through them. The fuel is a stock balanced against what is used and drawn
only from what is held, so every executed course is covered (`covered`). The revision rule
contacts every failed address (`propose_answers`, `revise_registers_failure`); the frozen
rule does not read what failed and leaves some failure unanswered at every retained method
(`frozen_misses`). A reference pair drives the channel to both targets exactly when its
references differ (`checked_pair_iff`), and after drift an installed key fails at every target
(`drift_fails`). The witnesses below are instances and controls of these laws.

The local primitives, faithful return, two-reference binding, Boolean channel
family and revision policy are supplied. This is not their premise-free origin,
unbounded invention, a physical calibration experiment, or an attraction theorem.
-/

namespace Becoming.ReferencePlan

open Generative

def flip (key value : Bool) : Bool := if key then !value else value

theorem flip_twice (key value : Bool) : flip key (flip key value) = value := by
  cases key <;> cases value <;> rfl

structure Sample where
  address : Nat
  low : Bool
  high : Bool
  deriving DecidableEq

def valid : List Sample → Bool
  | [] => true
  | r :: rs => (r.low != r.high) && valid rs

def keyAt : List Sample → Nat → Bool
  | [], _ => false
  | r :: rs, i => if i = r.address then r.low else keyAt rs i

/-- A supplied two-point response law. The channel need not be invertible. -/
structure State where
  channel : Nat → Bool → Bool
  method : List Nat
  mismatch : Option Nat
  pending : List Nat
  fresh : List Sample
  installed : List Sample
  building : Bool
  fuel : Nat
  used : Nat
  response : Bool

inductive Act where
  | perform (address : Nat) (target : Bool)
  | revise
  | probe
  | install
  | frozen
  | erase
  | drift
  deriving DecidableEq

def use : Act → Nat
  | .probe => 2
  | .perform _ _ => 1
  | .revise => 1
  | .install => 1
  | .frozen => 1
  | .erase => 1
  | .drift => 1

/-- A method is revised by acquired content; no current channel is consulted. -/
def propose (method : List Nat) (mismatch : Option Nat) : List Nat :=
  match mismatch with
  | none => method
  | some i => i :: method

/-- An operation apart from its use of fuel. Installation uses only fresh, bound
reference pairs; a failed separation blocks installation, not the contact's use of fuel. -/
def operate (s : State) : Act → Option State
  | .perform i target =>
    if s.building then none else
    let output := s.channel i (flip (keyAt s.installed i) target)
    some { s with response := output, mismatch := if output = target then none else some i }
  | .revise =>
    match s.mismatch with
    | none => none
    | some i =>
      let plan := propose s.method (some i)
      some { s with method := plan, pending := plan, fresh := [], building := true, mismatch := none }
  | .probe =>
    if s.building then
      match s.pending with
      | [] => none
      | i :: tail => some { s with pending := tail, fresh := ⟨i, s.channel i false, s.channel i true⟩ :: s.fresh }
    else none
  | .install =>
    if s.building && s.pending.isEmpty && valid s.fresh then
      some { s with installed := s.fresh, building := false }
    else none
  | .frozen => some { s with pending := s.method, fresh := [], building := true, mismatch := none }
  | .erase => some { s with mismatch := none }
  | .drift => some { s with channel := fun i b => !(s.channel i b) }

/-- For every address, acquired content determines the next executable contact
sequence while leaving the old installed device in place until a checked commit. -/
theorem revision_binds_plan (s : State) (i : Nat) (h : s.mismatch = some i) :
    (operate s .revise).map (fun t => (t.method, t.pending, t.installed)) =
      some (i :: s.method, i :: s.method, s.installed) := by
  unfold operate
  rw [h]
  rfl

theorem probe_binds_both_references (s : State) (i : Nat) (tail : List Nat)
    (active : s.building = true) (head : s.pending = i :: tail) :
    (operate s .probe).map (fun t => (t.pending, t.fresh)) =
      some (tail, ⟨i, s.channel i false, s.channel i true⟩ :: s.fresh) := by
  unfold operate
  rw [active, head]
  rfl

theorem install_binds_fresh (s : State) (active : s.building = true)
    (done : s.pending = []) (checked : valid s.fresh = true) :
    (operate s .install).map (fun t => (t.installed, t.building)) = some (s.fresh, false) := by
  unfold operate
  rw [active, done, checked]
  rfl

def execute (s : State) (a : Act) : Option State :=
  if use a ≤ s.fuel then
    match operate s a with
    | none => none
    | some t => some { t with fuel := s.fuel - use a, used := s.used + use a }
  else none

def P : Process State Act := ⟨fun s a t => execute s a = some t⟩

theorem determined {s t u : State} {a : Act}
    (st : P.step s a t) (su : P.step s a u) : t = u :=
  Option.some.inj (st.symm.trans su)

theorem step_conserves {s t : State} {a : Act} (h : P.step s a t) :
    t.fuel + use a = s.fuel ∧ t.used = s.used + use a := by
  change execute s a = some t at h
  unfold execute at h
  split at h
  next enough =>
    cases eq : operate s a with
    | none => rw [eq] at h; contradiction
    | some u =>
      rw [eq] at h
      cases Option.some.inj h
      exact ⟨Naturals.sub_add_cancel enough, rfl⟩
  next => contradiction

/-- A single policy consumes the retained method and mismatch at every revision.
The sequence of ordinary undertakings is supplied separately. -/
def choose (s : State) : Option Act :=
  if s.building then
    if s.pending.isEmpty then some .install else some .probe
  else match s.mismatch with
    | none => none
    | some _ => some .revise

def repair : Nat → State → Option State
  | 0, s => some s
  | n + 1, s =>
    match choose s with
    | none => none
    | some a => (execute s a).bind (repair n)

def run : State → List Act → Option State
  | s, [] => some s
  | s, a :: as => (execute s a).bind (fun t => run t as)

theorem run_trace {s t : State} {as : List Act} (h : run s as = some t) :
    Trace P s as t := by
  induction as generalizing s with
  | nil => exact (Option.some.inj h) ▸ Trace.nil s
  | cons a as ih =>
    cases eq : execute s a with
    | none => simp only [run, eq, Option.bind_none] at h; contradiction
    | some m =>
      simp only [run, eq, Option.bind_some] at h
      exact Trace.cons eq (ih h)

theorem repair_trace {n : Nat} {s t : State} (h : repair n s = some t) :
    ∃ as, Trace P s as t := by
  induction n generalizing s with
  | zero => exact ⟨[], (Option.some.inj h) ▸ Trace.nil s⟩
  | succ n ih =>
    cases chosen : choose s with
    | none => simp only [repair, chosen] at h; contradiction
    | some a =>
      cases executed : execute s a with
      | none => simp only [repair, chosen, executed, Option.bind_none] at h; contradiction
      | some m =>
        simp only [repair, chosen, executed, Option.bind_some] at h
        obtain ⟨as, path⟩ := ih h
        exact ⟨a :: as, Trace.cons executed path⟩

theorem propose_from_mismatch (m : List Nat) (i : Nat) :
    propose m (some i) = i :: m := rfl

theorem propose_without_mismatch (m : List Nat) : propose m none = m := rfl

/-- A two-reference candidate works at both targets precisely under the acquired
separation check. Applying this to later use also requires the channel to persist. -/
theorem checked_pair_correct (c : Bool → Bool) (separate : c false ≠ c true)
    (target : Bool) : c (flip (c false) target) = target := by
  cases lo : c false with
  | false =>
    cases hi : c true with
    | false => exact False.elim (separate (lo.trans hi.symm))
    | true => cases target <;> first | exact lo | exact hi
  | true =>
    cases hi : c true with
    | false => cases target <;> first | exact hi | exact lo
    | true => exact False.elim (separate (lo.trans hi.symm))

/-- The address domain of the lumping on installed contacts. These are alternative
signals at its contacts, not claims that unseen channels were actually sampled. Two signals are
alike where they agree at every planned address: `Learning.Training.AgreeOn` on the plan
(`agreeOn_iff`). This is not `Becoming.Alike` of `Becoming.Unfolding`, which relates two
configurations by a bisimulation. -/
def AgreeOn (plan : List Nat) (x y : Nat → Bool) : Prop :=
  ∀ i, i ∈ plan → x i = y i

/-- Alike under a plan is agreeing on the planned addresses, by definition. -/
theorem agreeOn_iff (plan : List Nat) (x y : Nat → Bool) :
    AgreeOn plan x y ↔ Learning.Training.AgreeOn (fun i => i ∈ plan) x y :=
  Iff.rfl

/-- Adding an address keeps every earlier selection: an instance of `Contacts.keeps_iff_retains`. -/
theorem added_keeps (m : List Nat) (i : Nat) :
    Registration.Keeps AgreeOn m (i :: m) :=
  (Contacts.keeps_iff_retains (fun p : List Nat => p) m (i :: m)).mpr fun _ h => List.Mem.tail i h

/-- Direct reuse of `Learning.Training.keeps_through_iff`, not a second definition of selection through a
lumping. -/
theorem old_selections_remain (m : List Nat) (i : Nat) :
    ∀ select, Learning.Training.Through (AgreeOn m) select →
      Learning.Training.Through (AgreeOn (i :: m)) select :=
  (Learning.Training.keeps_through_iff
    (fun _ _ _ => rfl) (fun _ _ h j hj => (h j hj).symm)
    (fun _ _ _ h k j hj => (h j hj).trans (k j hj))).mpr (added_keeps m i)

theorem choice_at_contact {m : List Nat} {i : Nat} (mem : i ∈ m) :
    Learning.Training.Through (AgreeOn m) (fun x => x i = true) :=
  fun _ _ h => ⟨fun hx => (h i mem).symm.trans hx, fun hy => (h i mem).trans hy⟩

/-- A new contact gains a choice: an instance of `Contacts.retired_loses`. -/
theorem new_contact_choice (m : List Nat) (i : Nat) (absent : i ∉ m) :
    Learning.Training.Through (AgreeOn (i :: m)) (fun x => x i = true) ∧
      ¬ Learning.Training.Through (AgreeOn m) (fun x => x i = true) :=
  Contacts.retired_loses (List.Mem.head m) absent

/-! The native history has two repairs, no resource reset and no external
calibration labels. Both rounds use exactly `choose`. -/

def initial : State :=
  ⟨fun _ b => !b, [], none, [], [], [], false, 30, 0, false⟩

def failedFirst : State := { initial with fuel := 29, used := 1, mismatch := some 0 }

def repairedFirst : State := { failedFirst with method := [0], mismatch := none, pending := [], fresh := [⟨0, true, false⟩], installed := [⟨0, true, false⟩], building := false, fuel := 25, used := 5 }

def failedSecond : State := { repairedFirst with mismatch := some 1, fuel := 23, used := 7 }

def repairedSecond : State := { failedSecond with method := [1, 0], mismatch := none, fresh := [⟨0, true, false⟩, ⟨1, true, false⟩], installed := [⟨0, true, false⟩, ⟨1, true, false⟩], fuel := 17, used := 13 }

def finished : State := { repairedSecond with response := true, fuel := 15, used := 15 }

theorem first_mismatch_acquired : execute initial (.perform 0 true) = some failedFirst := rfl

theorem first_policy_repair : repair 3 failedFirst = some repairedFirst := rfl

theorem first_repair_used_then_second_mismatch :
    run repairedFirst [.perform 0 true, .perform 1 true] = some failedSecond := rfl

theorem second_policy_repair : repair 4 failedSecond = some repairedSecond := rfl

theorem both_revised_contacts_used :
    run repairedSecond [.perform 1 true, .perform 0 true] = some finished := rfl

/-- The drift itself is an admitted event that uses fuel, not an analyst replacing the
initial configuration of a failed test. The finite history starts after a checked repair. -/
theorem drift_has_actual_history :
    ∃ t, Trace P repairedFirst [.drift, .perform 0 true] t ∧ t.response = false ∧ t.mismatch = some 0 :=
  ⟨{ repairedFirst with channel := fun i b => !(repairedFirst.channel i b), response := false, mismatch := some 0, fuel := 23, used := 7 }, run_trace rfl, rfl, rfl⟩

def actualWord : List Act :=
  [.perform 0 true, .revise, .probe, .install, .perform 0 true,
   .perform 1 true, .revise, .probe, .probe, .install,
   .perform 1 true, .perform 0 true]

theorem complete_history : Trace P initial actualWord finished := run_trace rfl

theorem fuel_used_without_reset : finished.fuel = 15 ∧ finished.used = 15 := ⟨rfl, rfl⟩

theorem methods_change_twice :
    initial.method = [] ∧ repairedFirst.method = [0] ∧ repairedSecond.method = [1, 0] :=
  ⟨rfl, rfl, rfl⟩

theorem first_candidate_unavailable_before :
    keyAt initial.installed 0 = false ∧ keyAt repairedFirst.installed 0 = true ∧
    (0 ∉ initial.method) ∧ (0 ∈ repairedFirst.method) :=
  ⟨rfl, rfl, List.not_mem_nil, List.mem_cons_self⟩

theorem second_candidate_unavailable_before :
    keyAt repairedFirst.installed 1 = false ∧ keyAt repairedSecond.installed 1 = true ∧
    (1 ∉ repairedFirst.method) ∧ (1 ∈ repairedSecond.method) := by
  refine ⟨rfl, rfl, ?_, List.mem_cons_self⟩
  intro h
  cases h with
  | tail _ h => cases h

theorem first_new_selection :
    Learning.Training.Through (AgreeOn repairedFirst.method) (fun x => x 0 = true) ∧
      ¬ Learning.Training.Through (AgreeOn initial.method) (fun x => x 0 = true) :=
  new_contact_choice [] 0 (List.not_mem_nil)

theorem second_new_selection :
    Learning.Training.Through (AgreeOn repairedSecond.method) (fun x => x 1 = true) ∧
      ¬ Learning.Training.Through (AgreeOn repairedFirst.method) (fun x => x 1 = true) :=
  new_contact_choice [0] 1 second_candidate_unavailable_before.2.2.1

/-- Only constructed and installed contacts participate in this lumping. -/
def alikeOnInstalled (s : State) : (Nat → Bool) → (Nat → Bool) → Prop :=
  AgreeOn (s.installed.map Sample.address)

theorem second_installed_choice :
    Learning.Training.Through (alikeOnInstalled repairedSecond) (fun x => x 1 = true) ∧
      ¬ Learning.Training.Through (alikeOnInstalled repairedFirst) (fun x => x 1 = true) :=
  ⟨choice_at_contact (List.Mem.tail 0 (List.Mem.head [])), second_new_selection.2⟩

theorem installed_response_correct (target : Bool) :
    repairedFirst.channel 0 (flip (keyAt repairedFirst.installed 0) target) = target ∧
    repairedSecond.channel 0 (flip (keyAt repairedSecond.installed 0) target) = target ∧
    repairedSecond.channel 1 (flip (keyAt repairedSecond.installed 1) target) = target := by
  cases target <;> exact ⟨rfl, rfl, rfl⟩

theorem first_use_succeeds :
    (execute repairedFirst (.perform 0 true)).map (fun s => s.response) = some true := rfl

theorem second_use_succeeds :
    (execute repairedSecond (.perform 1 true)).map (fun s => s.response) = some true := rfl

/-! Controls keep genuine failures rather than declaring every revision successful. -/

def frozenEnd : State := { failedFirst with mismatch := some 0, fuel := 26, used := 4 }

theorem frozen_method_still_fails :
    run failedFirst [.frozen, .install, .perform 0 true] = some frozenEnd ∧
      frozenEnd.response = false ∧ frozenEnd.installed = [] := ⟨rfl, rfl, rfl⟩

def frozenSecondEnd : State := { failedSecond with fresh := [⟨0, true, false⟩], fuel := 18, used := 12 }

/-- The frozen method really executes its old contact and retains the first
repair. It has MORE remaining support yet still misses the second address. -/
theorem frozen_second_method_still_fails :
    run failedSecond [.frozen, .probe, .install, .perform 1 true] = some frozenSecondEnd ∧
      frozenSecondEnd.response = false ∧ keyAt frozenSecondEnd.installed 0 = true ∧
      keyAt frozenSecondEnd.installed 1 = false := ⟨rfl, rfl, rfl, rfl⟩

theorem erased_mismatch_cannot_activate :
    (execute failedFirst .erase).bind (repair 1) = none := rfl

theorem support_too_small_to_build :
    repair 3 { failedFirst with fuel := 3 } = none := rfl

theorem references_use_fuel_before_exhaustion :
    (repair 2 { failedFirst with fuel := 3 }).map (fun s => (s.fuel, s.used, s.installed)) =
      some (0, 4, []) := rfl

theorem no_action_after_exhaustion :
    execute { repairedFirst with fuel := 0 } (.perform 0 true) = none := rfl

theorem constant_channel_rejected :
    repair 3 { failedFirst with channel := fun _ _ => false } = none := rfl

theorem constant_channel_contacts_use_fuel :
    (repair 2 { failedFirst with channel := fun _ _ => false }).map
      (fun s => (s.fuel, s.used, valid s.fresh, s.installed)) =
      some (26, 4, false, []) := rfl

theorem drift_after_check_can_fail :
    (run repairedFirst [.drift, .perform 0 true]).map
      (fun s => (s.response, s.mismatch, s.fuel, s.used)) = some (false, some 0, 23, 7) := rfl

/-! ## Through the general laws of stock and contacts -/

/-- The fuel is a stock: each step uses what it uses and replenishes nothing. -/
theorem balanced : Stock.Balanced P State.fuel use (fun _ => 0) :=
  fun _ _ _ h => (step_conserves h).1

/-- What has been used is the complementary stock: each step adds what it uses. -/
theorem used_balanced : Stock.Balanced P State.used (fun _ => 0) use :=
  fun _ _ _ h => (step_conserves h).2

/-- A step uses only fuel already held. -/
theorem draws_held : Stock.DrawsHeld P State.fuel use := by
  intro s a t h
  change execute s a = some t at h
  unfold execute at h
  split at h
  next enough => exact enough
  next => contradiction

/-- Fuel and what has been used, added, are conserved along every course: a corollary of
`Stock.trace_balance`. -/
theorem trace_conserves {s t : State} {as : List Act} (h : Trace P s as t) :
    t.fuel + t.used = s.fuel + s.used :=
  have fuel : t.fuel + total as use = s.fuel :=
    (Stock.trace_balance balanced h).trans (congrArg (s.fuel + ·) (total_zero as))
  have used : t.used = s.used + total as use :=
    (congrArg (t.used + ·) (total_zero as)).symm.trans (Stock.trace_balance used_balanced h)
  calc t.fuel + t.used = t.fuel + (s.used + total as use) := congrArg (t.fuel + ·) used
    _ = (t.fuel + total as use) + s.used :=
        (congrArg (t.fuel + ·) (Nat.add_comm _ _)).trans (Nat.add_assoc _ _ _).symm
    _ = s.fuel + s.used := congrArg (· + s.used) fuel

/-- **Instance of `Stock.covered_of_trace`.** Every executed course is covered by the fuel it
starts from; `support_too_small_to_build` and `no_action_after_exhaustion` are cases. -/
theorem covered {s t : State} {as : List Act} (h : Trace P s as t) :
    Stock.Covered use (fun _ => 0) s.fuel as :=
  Stock.covered_of_trace balanced draws_held h

/-- The revision rule reads the mismatch and answers every failure. -/
theorem propose_answers : Contacts.Answers propose := fun _ _ => List.Mem.head _

theorem revise_registers_failure (m : List Nat) (i : Nat) :
    Learning.Training.Through (AgreeOn (propose m (some i))) (fun x => x i = true) :=
  (Contacts.answers_iff propose).mpr propose_answers m i

/-- The frozen operation re-runs the retained method whatever the mismatch. -/
def frozenRule : List Nat → Option Nat → List Nat := fun m _ => m

theorem frozen_reads_method (s : State) :
    (operate s .frozen).map State.pending = some (frozenRule s.method s.mismatch) := rfl

theorem frozen_blind : Contacts.Blind frozenRule := fun _ _ => rfl

/-- **Instance of `Contacts.blind_misses`.** At every retained method, some failure is left
unanswered by the frozen rule; `frozen_method_still_fails` is one control of this law. -/
theorem frozen_misses (m : List Nat) :
    ∃ i, ¬ Learning.Training.Through (AgreeOn (frozenRule m (some i))) (fun x => x i = true) :=
  Contacts.blind_misses frozen_blind Contacts.nat_unlisted m

theorem flip_is_pick (c : Bool → Bool) (b : Bool) :
    flip (c false) b = References.pick c false true b := by
  show flip (c false) b = (if c false = b then false else true)
  cases c false <;> cases b <;> rfl

/-- **Instance of `References.drives_iff`:** `checked_pair_correct` and its converse. -/
theorem checked_pair_iff (c : Bool → Bool) :
    (∀ target, c (flip (c false) target) = target) ↔ c false ≠ c true :=
  ⟨fun h => (References.drives_iff c false true).mp fun b =>
      (congrArg c (flip_is_pick c b)).symm.trans (h b),
   fun apart b => (congrArg c (flip_is_pick c b)).trans
      ((References.drives_iff c false true).mpr apart b)⟩

/-- **Instance of `References.inverted_fails`:** after drift a checked key fails at every
target; `drift_after_check_can_fail` is one control of this law. -/
theorem drift_fails (c : Bool → Bool) (apart : c false ≠ c true) (b : Bool) :
    (fun x => !(c x)) (flip (c false) b) ≠ b :=
  References.inverted_fails (e := fun b => flip (c false) b) ((checked_pair_iff c).mpr apart) b

end Becoming.ReferencePlan
