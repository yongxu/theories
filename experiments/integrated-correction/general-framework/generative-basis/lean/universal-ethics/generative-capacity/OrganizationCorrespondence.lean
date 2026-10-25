import Becoming.Decidedness
import RelationalOrganization

/-!
# Formation required of undominated choices, an instance of `Becoming.Decidedness`

`RelationalOrganization` states that where every eligible continuation lacking an organizational
relation has a strictly better eligible construction, on a finite nonempty menu, the frontier is
not empty and every undominated choice includes the relation. This periphery module reads that
theorem on the core's laws of undominated members of a listed menu.

* On an exact listed menu, the frontier of `PracticalJudgment` is the core's undominated members
  (`frontier_iff_undominated`).
* With Lean's classical decidedness supplying what the core asks, the frontier is not empty by
  `exists_undominated` and every member of it includes the relation by `undominated_has`, so
  `formation_required_of_improvable_absence` follows from the core laws
  (`formation_required_by_core`), and so does the constructed case
  (`coordination_is_required_by_core`).

The core law asks the comparison only to be weakly decided and the relation to be decided; where
these hold with no classical reasoning, the core states the theorem itself
(`Becoming.Requirement.required_of_bettered`, in `Becoming.Frontier`). The comparison, eligibility and the constructed
history keep the periphery's scope. The core does not import this module.
-/

namespace Becoming.OrganizationCorrespondence

open PracticalJudgment

/-- On an exact listed menu, the frontier is the undominated members. -/
theorem frontier_iff_undominated {H : Type} {eligible : H → Prop} {better : H → H → Prop}
    {menu : List H} (exact : ∀ a, eligible a ↔ a ∈ menu) {a : H} :
    Frontier eligible better a ↔ Undominated menu better a :=
  ⟨fun ⟨admitted, unbeaten⟩ =>
    ⟨(exact a).mp admitted, fun b mem => unbeaten b ((exact b).mpr mem)⟩,
   fun ⟨mem, unbeaten⟩ =>
    ⟨(exact a).mpr mem, fun b admitted => unbeaten b ((exact b).mp admitted)⟩⟩

/-- **`formation_required_of_improvable_absence` from the core laws** (`exists_undominated`,
`undominated_has`), with classical decidedness. -/
theorem formation_required_by_core {H : Type}
    (eligible : H → Prop) (better : H → H → Prop) (formed : H → Prop)
    (menu : List H) (nonempty : menu ≠ [])
    (exactMenu : ∀ a, eligible a ↔ a ∈ menu)
    (irreflexive : ∀ a, ¬ better a a)
    (transitive : ∀ {a b c}, better a b → better b c → better a c)
    (construction : ∀ a, eligible a → ¬ formed a → ∃ b, eligible b ∧ better b a) :
    Required (Frontier eligible better) formed :=
  match menu, nonempty, exactMenu with
  | [], nonempty, _ => absurd rfl nonempty
  | x :: rest, _, exactMenu =>
    match exists_undominated x rest (fun _ _ _ _ => Decided.weakly (Classical.em _))
        (fun a _ => irreflexive a) (fun _ _ _ _ _ _ first second => transitive first second) with
    | ⟨a, undominated⟩ =>
      ⟨⟨a, (frontier_iff_undominated exactMenu).mpr undominated⟩,
       fun c frontier => undominated_has (menu := x :: rest) (better := better)
         (fun _ _ => Classical.em _)
         (fun b mem fails => match construction b ((exactMenu b).mpr mem) fails with
           | ⟨d, admitted, beats⟩ => ⟨d, (exactMenu d).mp admitted, beats⟩)
         c ((frontier_iff_undominated exactMenu).mp frontier)⟩

/-- **`coordination_is_required` from the core laws.** -/
theorem coordination_is_required_by_core :
    Required (Frontier RelationalOrganization.eligible RelationalOrganization.better)
      RelationalOrganization.formed := by
  apply formation_required_by_core RelationalOrganization.eligible RelationalOrganization.better
    RelationalOrganization.formed RelationalOrganization.menu
  · simp [RelationalOrganization.menu]
  · intro a
    cases a <;> simp [RelationalOrganization.eligible, RelationalOrganization.spent,
      RelationalOrganization.menu]
  · exact better_irrefl RelationalOrganization.protect RelationalOrganization.freeOccasion
  · exact better_trans RelationalOrganization.protect RelationalOrganization.freeOccasion
  · exact RelationalOrganization.every_unformed_continuation_has_a_better_one

end Becoming.OrganizationCorrespondence
