import Becoming.U4LeverTwo

/-!
# U4, lever 2 (scratch): each witness against the package row itself

From the second read of the audit's §10 (`../REVIEW-U4-L2-SECOND.md`, its `Check.lean`), with its
two missing witnesses filled (row 8's `moved`, row 17's `inactive`), the per-step forms of rows 14
and 17, row 2's offspring dependence cited by name, and the first review's witnesses for rows 5
and 13 (`Ungiven`, `Raised`). Each `example` derives the named hypothesis's negation by applying
the package row (or its on-root form) to the witness's other-hypothesis theorems and
contradicting the witness's failing conclusion. So every other hypothesis is proved at exactly
the row's type, and the failure negates exactly the row's conclusion at that instance. The two the second read found missing are named theorems
(`moved_needed`, `inactive_needed`); the rest are examples.
-/

namespace Becoming.U4LeverTwoCheck

open Becoming Becoming.U4LeverTwo

/-! Rows 1 and 3 (`Flow.selection_within`, `Flow.selected_le`) -/

-- gate part 1 (act = false)
example : ¬ NeedOverLevel.flow.Acting (NeedOverLevel.web false) := fun acting =>
  NeedOverLevel.selection_fails false (Flow.selection_within acting NeedOverLevel.dependent
    (NeedOverLevel.descend false) (NeedOverLevel.depends false) (fun _ => 0))
example : ¬ NeedOverLevel.flow.Acting (NeedOverLevel.web false) := fun acting =>
  NeedOverLevel.selected_fails false (Flow.selected_le acting NeedOverLevel.dependent
    (NeedOverLevel.descend false) (NeedOverLevel.depends false))
-- gate part 2 (act = true)
example : ¬ (NeedOverLevel.web true).Dependent := fun dependent =>
  NeedOverLevel.selection_fails true (Flow.selection_within NeedOverLevel.acting dependent
    (NeedOverLevel.descend true) (NeedOverLevel.depends true) (fun _ => 0))
example : ¬ (NeedOverLevel.web true).Dependent := fun dependent =>
  NeedOverLevel.selected_fails true (Flow.selected_le NeedOverLevel.acting dependent
    (NeedOverLevel.descend true) (NeedOverLevel.depends true))
-- dependence on the condition
example : ¬ ∀ p, p ∈ NeedOverLevel.ps → Undepending.web.requires 0 p 2 := fun depends =>
  Undepending.selection_fails (Flow.selection_within Undepending.acting Undepending.dependent
    Undepending.descend depends (fun _ => 0))
example : ¬ ∀ p, p ∈ NeedOverLevel.ps → Undepending.web.requires 0 p 2 := fun depends =>
  Undepending.selected_fails (Flow.selected_le Undepending.acting Undepending.dependent
    Undepending.descend depends)
-- descent
example : ¬ ∀ p k, p ∈ NeedOverLevel.ps → k ∈ NeedOverLevel.kids p →
    NeedOverLevel.silent.DescendsAt (NeedOverLevel.web false) 0 k p := fun descend =>
  NeedOverLevel.selection_fails false (Flow.selection_within NeedOverLevel.silent_acting
    NeedOverLevel.dependent descend (NeedOverLevel.depends false) (fun _ => 0))
example : ¬ ∀ p k, p ∈ NeedOverLevel.ps → k ∈ NeedOverLevel.kids p →
    NeedOverLevel.silent.DescendsAt (NeedOverLevel.web false) 0 k p := fun descend =>
  NeedOverLevel.selected_fails false (Flow.selected_le NeedOverLevel.silent_acting
    NeedOverLevel.dependent descend (NeedOverLevel.depends false))

/-! Row 2 (`Flow.transmitted_supported`) -/

example : ¬ NeedOverLevel.flow.Acting (NeedOverLevel.web false) := fun acting =>
  NeedOverLevel.transmitted_fails false (Flow.transmitted_supported acting NeedOverLevel.dependent
    (NeedOverLevel.transmits false) (NeedOverLevel.descend false 0 1 (.head _) (.head _))
    (NeedOverLevel.offspring_depends false))
example : ¬ (NeedOverLevel.web true).Dependent := fun dependent =>
  NeedOverLevel.transmitted_fails true (Flow.transmitted_supported NeedOverLevel.acting dependent
    (NeedOverLevel.transmits true) (NeedOverLevel.descend true 0 1 (.head _) (.head _))
    (NeedOverLevel.offspring_depends true))
example : ¬ Untransmitted.flow.TransmitsWithin Untransmitted.web 2 0 := fun transmits =>
  Untransmitted.fails (Flow.transmitted_supported Untransmitted.acting Untransmitted.dependent
    transmits Untransmitted.descends Untransmitted.depends)
example : ¬ Undependent.web.requires (0 + 1) 1 2 := fun depends =>
  Undependent.fails (Flow.transmitted_supported Undependent.acting Undependent.dependent
    Undependent.transmits Undependent.descends depends)
example : ¬ NeedOverLevel.silent.DescendsAt (NeedOverLevel.web false) 0 1 0 := fun descends =>
  NeedOverLevel.transmitted_fails false (Flow.transmitted_supported NeedOverLevel.silent_acting
    NeedOverLevel.dependent NeedOverLevel.silent_transmits descends
    (NeedOverLevel.offspring_depends false))

/-! Row 7 (`SelectionTerm.Flow.support_not_lower`) -/

example : ¬ LowGives.flow.Acting (LowGives.web false) := fun acting =>
  LowGives.falls (SelectionTerm.Flow.support_not_lower acting LowGives.dependent
    (LowGives.descended false) (LowGives.top false) LowGives.unlowered)
example : ¬ (LowGives.web true).Dependent := fun dependent =>
  LowGives.falls (SelectionTerm.Flow.support_not_lower LowGives.acting dependent
    (LowGives.descended true) (LowGives.top true) LowGives.unlowered)
example : ¬ SelectionTerm.Flow.Descended LowGives.silent (LowGives.web false) LowGives.gens :=
  fun descended => LowGives.falls (SelectionTerm.Flow.support_not_lower LowGives.silent_acting
    LowGives.dependent descended (LowGives.top false) LowGives.unlowered)
example : ¬ ∀ t p, p ∈ TopMissed.gens.family t → TopMissed.web.Supported t p →
    ∀ q, q ∈ TopMissed.gens.family t → TopMissed.gens.amount t q ≤ TopMissed.gens.amount t p :=
  fun top => TopMissed.falls (SelectionTerm.Flow.support_not_lower TopMissed.acting
    TopMissed.dependent TopMissed.descended top TopMissed.unlowered)
example : ¬ ∀ t, t < 1 → Lowered.gens.loweredAt t = 0 := fun unlowered =>
  Lowered.falls (SelectionTerm.Flow.support_not_lower Lowered.acting Lowered.dependent
    Lowered.descended Lowered.top unlowered)

/-! Row 8 (`SelectionTerm.Flow.support_moved_rises`) -/

example : ¬ LowGives.flow.Acting (LowGives.web false) := fun acting =>
  LowGives.not_rises (SelectionTerm.Flow.support_moved_rises acting LowGives.dependent
    (LowGives.descended false) (LowGives.top false) LowGives.exact LowGives.moved)
example : ¬ (LowGives.web true).Dependent := fun dependent =>
  LowGives.not_rises (SelectionTerm.Flow.support_moved_rises LowGives.acting dependent
    (LowGives.descended true) (LowGives.top true) LowGives.exact LowGives.moved)
example : ¬ SelectionTerm.Flow.Descended LowGives.silent (LowGives.web false) LowGives.gens :=
  fun descended => LowGives.not_rises (SelectionTerm.Flow.support_moved_rises
    LowGives.silent_acting LowGives.dependent descended (LowGives.top false) LowGives.exact
    LowGives.moved)
example : ¬ ∀ t p, p ∈ TopMissed.gens.family t → TopMissed.web.Supported t p →
    ∀ q, q ∈ TopMissed.gens.family t → TopMissed.gens.amount t q ≤ TopMissed.gens.amount t p :=
  fun top => TopMissed.not_rises (SelectionTerm.Flow.support_moved_rises TopMissed.acting
    TopMissed.dependent TopMissed.descended top TopMissed.exact TopMissed.moved)
example : ¬ ∀ t, t < 1 → SelectionTerm.Exact (Lowered.gens.family t) (Lowered.gens.kids t)
    (Lowered.gens.amount t) (Lowered.gens.amount (t + 1)) := fun exact =>
  Lowered.not_rises (SelectionTerm.Flow.support_moved_rises Lowered.acting Lowered.dependent
    Lowered.descended Lowered.top exact Lowered.moved)
/-- Row 8's `moved` cannot be dropped (`Kept`, over one step of exact descent). -/
theorem moved_needed : ¬ Kept.gens.size 0 * Kept.gens.sum 1 ≠ Kept.gens.size 1 * Kept.gens.sum 0 := fun moved =>
  Kept.not_rises (SelectionTerm.Flow.support_moved_rises Lowered.acting Lowered.dependent
    Kept.descended Kept.top Kept.exact moved)

/-! Row 14, package form (`GroupEnding.Flow.rises_iff_inactive`) -/

example : ¬ EndsAmong.flow.Acting (EndsAmong.web false) := fun acting =>
  EndsAmong.fails (GroupEnding.Flow.rises_iff_inactive acting (EndsAmong.descended false)
    EndsAmong.groups EndsAmong.listed EndsAmong.equal EndsAmong.exact EndsAmong.inactive)
example : ¬ (∀ g h, g ∈ EndsAmong.groups → h ∈ EndsAmong.groups →
    total h (EndsAmong.gens.amount 0) < total g (EndsAmong.gens.amount 0) →
      ∀ p, p ∈ h → ¬ (EndsAmong.web true).active 0 p) := fun inactive =>
  EndsAmong.fails (GroupEnding.Flow.rises_iff_inactive EndsAmong.acting (EndsAmong.descended true)
    EndsAmong.groups EndsAmong.listed EndsAmong.equal EndsAmong.exact inactive)
example : ¬ SelectionTerm.Flow.Descended EndsAmong.silent (EndsAmong.web false) EndsAmong.gens :=
  fun descended => EndsAmong.fails (GroupEnding.Flow.rises_iff_inactive EndsAmong.silent_acting
    descended EndsAmong.groups EndsAmong.listed EndsAmong.equal EndsAmong.exact EndsAmong.inactive)
example : ¬ SelectionTerm.Exact (Lifted.gens.family 0) (Lifted.gens.kids 0) (Lifted.gens.amount 0)
    (Lifted.gens.amount 1) := fun exact =>
  Lifted.fails (GroupEnding.Flow.rises_iff_inactive Lifted.acting Lifted.descended Lifted.groups
    Lifted.listed Lifted.equal exact Lifted.inactive)

/-! Row 14 on the root (`rises_iff_inactive_on_root`, per-step inclusions, cancellation) -/

example : ¬ «则» (gives EndsAmong.flow 0) («而» (activeAt (EndsAmong.web false) 0)
    (gives EndsAmong.flow 0)) := fun acting =>
  EndsAmong.fails (rises_iff_inactive_on_root acting
    (listed_within_gives (EndsAmong.descended false) 0) EndsAmong.groups EndsAmong.listed
    EndsAmong.equal (cancel_of_exact EndsAmong.exact) EndsAmong.inactive)
example : ¬ «则» (gives EndsAmong.flow 0) («而» (activeAt (EndsAmong.web false) 0)
    (gives EndsAmong.flow 0)) := EndsAmong.not_acting_at
example : ¬ «则» (listed EndsAmong.gens 0) (gives EndsAmong.silent 0) := EndsAmong.not_descended_at
example : ¬ «则» (listed EndsAmong.gens 0) (gives EndsAmong.silent 0) := fun descended =>
  EndsAmong.fails (rises_iff_inactive_on_root (acting_iff.mp EndsAmong.silent_acting 0) descended
    EndsAmong.groups EndsAmong.listed EndsAmong.equal (cancel_of_exact EndsAmong.exact)
    EndsAmong.inactive)
example : ¬ (∀ g h, g ∈ EndsAmong.groups → h ∈ EndsAmong.groups →
    total h (EndsAmong.gens.amount 0) < total g (EndsAmong.gens.amount 0) →
      ∀ p, p ∈ h → ¬ (EndsAmong.web true).active 0 p) := fun inactive =>
  EndsAmong.fails (rises_iff_inactive_on_root (acting_iff.mp EndsAmong.acting 0)
    (listed_within_gives (EndsAmong.descended true) 0) EndsAmong.groups EndsAmong.listed
    EndsAmong.equal (cancel_of_exact EndsAmong.exact) inactive)
example : ¬ Lifted.gens.raisedAt 0 = Lifted.gens.loweredAt 0 := fun cancel =>
  Lifted.fails (rises_iff_inactive_on_root (acting_iff.mp Lifted.acting 0)
    (listed_within_gives Lifted.descended 0) Lifted.groups Lifted.listed Lifted.equal cancel
    Lifted.inactive)

/-! Row 17 (`GroupEnding.Flow.all_end`, and `size_zero_of_within` on the root) -/

example : ¬ Ungated.flow.Acting Ungated.web := fun acting =>
  Ungated.gate_needed.2.2.1 (GroupEnding.Flow.all_end acting Ungated.descended Ungated.inactive)
example : ¬ SelectionTerm.Flow.Descended Ungated.silent Ungated.web Ungated.gens := fun descended =>
  Ungated.gate_needed.2.2.1 (GroupEnding.Flow.all_end Ungated.silent_acting descended
    Ungated.inactive)
example : ¬ «则» (gives Ungated.flow 0) («而» (activeAt Ungated.web 0) (gives Ungated.flow 0)) :=
  fun acting => Ungated.gate_needed.2.2.1
    (size_zero_of_within acting (listed_within_gives Ungated.descended 0) Ungated.inactive)
/-- Row 17's `inactive` cannot be dropped (`Lifted`); below, on the root as well. -/
theorem inactive_needed : ¬ ∀ p, p ∈ Lifted.gens.family 0 → ¬ Lifted.web.active 0 p := fun inactive =>
  Lifted.inactive_needed.2.2.2 (GroupEnding.Flow.all_end Lifted.acting Lifted.descended inactive)
example : ¬ ∀ p, p ∈ Lifted.gens.family 0 → ¬ Lifted.web.active 0 p := fun inactive =>
  Lifted.inactive_needed.2.2.2 (size_zero_of_within (acting_iff.mp Lifted.acting 0)
    (listed_within_gives Lifted.descended 0) inactive)
-- the gate and descent at the one step `size_zero_of_within` takes:
example : ¬ «则» (gives Ungated.flow 0) («而» (activeAt Ungated.web 0) (gives Ungated.flow 0)) :=
  Ungated.not_acting_at
example : ¬ «则» (listed Ungated.gens 0) (gives Ungated.silent 0) := fun descended =>
  Ungated.gate_needed.2.2.1 (size_zero_of_within (acting_iff.mp Ungated.silent_acting 0) descended
    Ungated.inactive)
example : ¬ «则» (listed Ungated.gens 0) (gives Ungated.silent 0) := Ungated.not_descended_at

/-! Row 13 (`SelectionLevels.rises_exact_iff_levels`, and with cancellation) -/

example : ¬ SelectionTerm.Exact (Raised.family 0) (Raised.kids 0) (Raised.amount 0)
    (Raised.amount 1) := fun exact =>
  Raised.levels_fail (SelectionLevels.rises_exact_iff_levels Raised Raised.groups Raised.listed
    Raised.equal exact)
example : ¬ Raised.raisedAt 0 = Raised.loweredAt 0 := fun cancel =>
  Raised.levels_fail (rises_cancel_iff_levels Raised Raised.groups Raised.listed Raised.equal cancel)

/-! Row 5 on the root (`no_new_dependence_of_given`) -/

example : ¬ (Ungiven.web.ComesToStand 0 true → ∃ g, Ungiven.flow.DescendsAt Ungiven.web 0 true g) :=
  fun given => no_new_dependence_of_given given Ungiven.inherits Ungiven.none Ungiven.comes
    Ungiven.depends

example : ¬ ∀ g, Uninherited.flow.DescendsAt Uninherited.web 0 1 g →
    Uninherited.web.InheritsAt 0 1 g 5 := fun inherits =>
  no_new_dependence_of_given Uninherited.given inherits Uninherited.none Uninherited.comes
    Uninherited.depends
example : ¬ ∀ g, g ∈ Uninherited.flow.present 0 → ¬ Held.web.requires 0 g 5 := fun none =>
  no_new_dependence_of_given Held.given Held.inherits none Held.comes Held.depends
example : ¬ Standing.web.ComesToStand 0 1 := fun comes =>
  no_new_dependence_of_given Standing.given Standing.inherits Standing.none comes Standing.depends

/-! The inclusion forms (their axiom reports are in the scratch build's audit) -/


-- `rising` is an order, not a class:
example {α : Type} (f : Occ α → Nat) : (∀ u, rising f u u) ∧
    (∀ u v w, rising f u v → rising f v w → rising f u w) :=
  ⟨rising_refl f, fun _ _ _ => rising_trans f⟩
example : ¬ «类» (rising (fun u : Occ Bool => cond u.1 1 0)) := rising_not_class

end Becoming.U4LeverTwoCheck
