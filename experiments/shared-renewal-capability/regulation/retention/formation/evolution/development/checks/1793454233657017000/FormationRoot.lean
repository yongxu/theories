import GenerativeCore
import FormedSelection

/-!
Exact integration into the existing relational root. Every resource-bearing
intermediate state remains present; no reset or seed-conditioned handoff is
introduced by the bridge.
-/

namespace FormedSelection

def rootProcess (material : Nat) : Generative.Process State Event := ⟨Step material⟩

theorem trace_to_root {material : Nat} {s t : State} {as : List Event}
    (h : Trace material s as t) : Generative.Trace (rootProcess material) s as t := by
  induction h with
  | nil => exact .nil _
  | cons hs _ ih => exact .cons hs ih

theorem trace_from_root {material : Nat} {s t : State} {as : List Event}
    (h : Generative.Trace (rootProcess material) s as t) : Trace material s as t := by
  induction h with
  | nil => exact .nil _
  | cons hs _ ih => exact .cons hs ih

theorem trace_iff_root {material : Nat} {s t : State} {as : List Event} :
    Trace material s as t ↔ Generative.Trace (rootProcess material) s as t :=
  ⟨trace_to_root, trace_from_root⟩

theorem root_energy_ledger {material : Nat} {s t : State} {as : List Event}
    (h : Generative.Trace (rootProcess material) s as t) :
    energy t + tally expenditure as = energy s :=
  trace_energy_ledger (trace_from_root h)

theorem root_three_unit_bootstrap {material : Nat} {s t : State} {as : List Event}
    (hi : Absent s) (hc : s.intact = false)
    (h : Generative.Trace (rootProcess material) s as t) (ht : t.intact = true) :
    3 ≤ s.fuel :=
  repair_needs_three_initial_common_units hi hc (trace_from_root h) ht

theorem root_four_unit_mixed_bootstrap {material : Nat} {s t : State} {as : List Event}
    (hi : Absent s) (hc : s.intact = false)
    (h : Generative.Trace (rootProcess material) s as t)
    (ht : t.intact = true) (hh : 0 < hCount t) : 4 ≤ s.fuel :=
  restored_site_and_alternative_need_four_initial_common_units hi hc (trace_from_root h) ht hh

theorem root_formation_to_copy :
    Generative.Trace (rootProcess 3) initial witnessEvents copied :=
  trace_to_root paid_formation_to_copy

theorem root_no_h_local_copy_before_resident_wear {as : List Event} {t : State}
    (hn : Event.wearResident ∉ as)
    (h : Generative.Trace (rootProcess 3) initial as t) :
    tally (eventIndicator .localCopyH) as = 0 :=
  no_h_local_copies_from_absence_without_resident_wear hn (trace_from_root h)

theorem root_repaired_site_inheritance :
    Generative.Trace (rootProcess 2) inheritanceInitial inheritanceEvents inheritanceFinal :=
  trace_to_root repaired_site_can_pass_to_alternative

theorem trace_append_iff {material : Nat} {s t : State} {as bs : List Event} :
    Trace material s (as ++ bs) t ↔ ∃ u, Trace material s as u ∧ Trace material u bs t := by
  constructor
  · intro h
    obtain ⟨u, ha, hb⟩ := Generative.trace_append_iff.mp (trace_to_root h)
    exact ⟨u, trace_from_root ha, trace_from_root hb⟩
  · rintro ⟨u, ha, hb⟩
    exact trace_from_root (Generative.trace_append_iff.mpr
      ⟨u, trace_to_root ha, trace_to_root hb⟩)

#print axioms trace_to_root
#print axioms trace_from_root
#print axioms trace_iff_root
#print axioms root_energy_ledger
#print axioms root_three_unit_bootstrap
#print axioms root_four_unit_mixed_bootstrap
#print axioms root_formation_to_copy
#print axioms root_no_h_local_copy_before_resident_wear
#print axioms root_repaired_site_inheritance
#print axioms trace_append_iff

end FormedSelection
