import FormationSupport

/-!
An extension of FormationSupport, reusing its account laws and trace bridge.
The same states carry common fuel, stored local fuel and
incident source through every segment. Capture is a credit at the usable-fuel
boundary and an equal debit at the source boundary; the closed account has no
credit. Fuel allocated to reactions is distinguished from fuel lost by leakage.
Neither quantity is a success score or a thermodynamic work measurement.
-/

namespace FormedSelection.Accounts

open Generative.Conditional
open FormedSelection.Support (usable captureAmount eventQuantity)

/-- Fuel allocated to formation, association, repair or copying, regardless of
    whether the resulting response is useful. -/
def reactionExpenditure : Event → Nat
  | .formA | .formH | .associateA | .associateH | .repair
  | .localCopyA | .localCopyH | .bulkCopyA | .bulkCopyH => 1
  | _ => 0

def fuelLoss : Event → Nat
  | .leakCommon | .leakLocal => 1
  | _ => 0

inductive Boundary where
  | closed | usable | source | common
deriving DecidableEq

def reserve : Boundary → State → Nat
  | .closed => energy
  | .usable => usable
  | .source => State.source
  | .common => State.fuel

def demandWeight : Boundary → Event → Nat
  | .closed | .usable => expenditure
  | .source => captureAmount
  | .common => commonExpenditure

def creditWeight : Boundary → Event → Nat
  | .usable => captureAmount
  | _ => fun _ => 0

def demand (boundary : Boundary) : State → Event → State → Nat :=
  eventQuantity (demandWeight boundary)

def credit (boundary : Boundary) : State → Event → State → Nat :=
  eventQuantity (creditWeight boundary)

variable {material : Nat} {s m t : State} {a : Event} {as bs : List Event}

theorem spending_split (a : Event) :
    expenditure a = reactionExpenditure a + fuelLoss a := by
  cases a <;> decide

theorem tally_spending_split (as : List Event) :
    tally expenditure as = tally reactionExpenditure as + tally fuelLoss as := by
  induction as with
  | nil => rfl
  | cons a as ih =>
    have edge := spending_split a
    simp only [tally]
    omega

/-- These account premises are derived from the concrete guards and updates. -/
theorem step_account_exact (boundary : Boundary) (h : Step material s a t) :
    reserve boundary t + demand boundary s a t =
      reserve boundary s + credit boundary s a t := by
  cases boundary with
  | closed => exact (step_energy_ledger h).trans (Nat.add_zero _).symm
  | usable => exact Support.step_usable_ledger h
  | source => exact (Support.step_source_ledger h).trans (Nat.add_zero _).symm
  | common => exact (step_common_ledger h).trans (Nat.add_zero _).symm

theorem identified_account_laws (boundary : Boundary) :
    SustainLaw (rootProcess material) (reserve boundary) (demand boundary) (credit boundary) := by
  cases boundary with
  | closed => exact Support.closed_account material
  | usable => exact Support.usable_account material
  | source => exact Support.source_account material
  | common =>
    intro s a t h
    exact Nat.le_of_eq (step_account_exact .common h)

/-- The universal finite-trace result is applied to the identified account. -/
theorem root_account_balance (boundary : Boundary)
    (h : Generative.Trace (rootProcess material) s as t) :
    tally (demandWeight boundary) as + reserve boundary t ≤
      reserve boundary s + tally (creditWeight boundary) as :=
  Support.root_account_bound (reserve boundary) (demandWeight boundary) (creditWeight boundary)
    (identified_account_laws boundary) h

theorem root_account_exact (boundary : Boundary)
    (h : Generative.Trace (rootProcess material) s as t) :
    tally (demandWeight boundary) as + reserve boundary t =
      reserve boundary s + tally (creditWeight boundary) as := by
  induction h with
  | nil => simp [tally]
  | cons hs _ ih =>
    have edge := step_account_exact boundary hs
    simp only [tally, demand, credit, eventQuantity] at *
    omega

/-- Adding the source account to usable fuel cancels every capture credit. -/
theorem root_open_closed_consistency
    (h : Generative.Trace (rootProcess material) s as t) :
    tally expenditure as + usable t = usable s + tally captureAmount as ∧
    tally captureAmount as + t.source = s.source ∧
    tally expenditure as + energy t = energy s := by
  have hu := root_account_exact .usable h
  have hs := root_account_exact .source h
  have hc := root_account_exact .closed h
  simpa only [reserve, demandWeight, creditWeight, Support.tally_zero, Nat.add_zero] using
    And.intro hu (And.intro hs hc)

/-- All reaction allocation and all leakage are charged to the inherited
    stock; beneficial and harmful reactions have the same fuel price. -/
theorem root_reaction_loss_budget
    (h : Generative.Trace (rootProcess material) s as t) :
    tally reactionExpenditure as + tally fuelLoss as + energy t ≤ energy s := by
  simpa only [tally_spending_split] using Support.root_closed_bound h

theorem root_common_budget
    (h : Generative.Trace (rootProcess material) s as t) :
    tally commonExpenditure as + t.fuel ≤ s.fuel := by
  simpa only [reserve, demandWeight, creditWeight, Support.tally_zero, Nat.add_zero] using
    root_account_balance .common h

/-- Absence of both usable fuel and incident stock forbids fuel-spending
    reactions, but does not forbid zero-fuel-cost damage or wear. -/
theorem root_exhausted_accounts (hu : usable s = 0) (he : s.source = 0)
    (h : Generative.Trace (rootProcess material) s as t) :
    tally reactionExpenditure as = 0 ∧ tally fuelLoss as = 0 ∧ usable t = 0 := by
  have hb := root_reaction_loss_budget h
  simp only [energy, usable] at *
  omega

/-- The generic append theorem adds accounts only across the same state m.
    In particular its fuel and unused source cannot be reset between phases. -/
theorem root_append_account (boundary : Boundary)
    (left : Generative.Trace (rootProcess material) s as m)
    (right : Generative.Trace (rootProcess material) m bs t) :
    SupportTrace (rootProcess material) (demand boundary) (credit boundary) s (as ++ bs) t
      (tally (demandWeight boundary) as + tally (demandWeight boundary) bs)
      (tally (creditWeight boundary) as + tally (creditWeight boundary) bs)
      (tally (fun a => arrivalEvent (creditWeight boundary a)) as +
        tally (fun a => arrivalEvent (creditWeight boundary a)) bs) :=
  support_trace_append
    (Support.root_trace_account (demandWeight boundary) (creditWeight boundary) left)
    (Support.root_trace_account (demandWeight boundary) (creditWeight boundary) right)

theorem root_shared_boundary_budget
    (left : Generative.Trace (rootProcess material) s as m)
    (right : Generative.Trace (rootProcess material) m bs t) :
    tally expenditure as + tally expenditure bs + usable t ≤
      usable s + (tally captureAmount as + tally captureAmount bs) :=
  support_trace_bound (reserve .usable) (identified_account_laws .usable)
    (root_append_account .usable left right)

/-- Site damage is a real enabled state change with zero declared fuel demand. -/
theorem zero_fuel_cost_damage :
    Step 3 copied .damage (advance copied .damage) ∧ expenditure .damage = 0 := by
  decide

theorem fuel_demand_is_not_unit :
    ¬ (∀ s a t, (rootProcess 3).step s a t → 1 ≤ demand .closed s a t) := by
  intro unit
  have bad := unit copied .damage (advance copied .damage) zero_fuel_cost_damage.1
  change 1 ≤ 0 at bad
  omega

/-- The mixed history spends four inherited common units and the one captured
    packet. Its single usable credit is exactly one consumed source packet. -/
theorem mixed_witness_account :
    SupportTrace (rootProcess 3) (demand .usable) (credit .usable)
      initial witnessEvents copied 5 1 1 ∧
    SupportTrace (rootProcess 3) (demand .source) (credit .source)
      initial witnessEvents copied 1 0 0 ∧
    SupportTrace (rootProcess 3) (demand .closed) (credit .closed)
      initial witnessEvents copied 5 0 0 := by
  exact ⟨Support.paid_witness_account,
    Support.root_trace_account captureAmount (fun _ => 0) root_formation_to_copy,
    Support.root_trace_account expenditure (fun _ => 0) root_formation_to_copy⟩

#print axioms spending_split
#print axioms tally_spending_split
#print axioms step_account_exact
#print axioms identified_account_laws
#print axioms root_account_balance
#print axioms root_account_exact
#print axioms root_open_closed_consistency
#print axioms root_reaction_loss_budget
#print axioms root_common_budget
#print axioms root_exhausted_accounts
#print axioms root_append_account
#print axioms root_shared_boundary_budget
#print axioms zero_fuel_cost_damage
#print axioms fuel_demand_is_not_unit
#print axioms mixed_witness_account

end FormedSelection.Accounts
