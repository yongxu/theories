
/-- Under the gate, two drawers who both leave everything keep the source at two or above. -/
theorem gated_restraint_keeps :
    ∀ t, 2 ≤ InTurn.levels (fun _ z => z + gate z) (fun _ z => z) (fun _ a => a) 2 t
  | 0 => Nat.le_refl 2
  | t + 1 => Nat.le_trans (gated_restraint_keeps t) (Nat.le_add_right _ _)

/-- **The gate witness: restraint revised away.** From a source at two, the level the dweller needs,
under a gate, two drawers in turn who both start by leaving everything keep the dweller; revising
toward best responses, from round `2 (n + 2)` on every profile breaks it at the first step
(`InTurn.revised_draw_all`, `Web.revised_broken`). -/
theorem gated_revised (n : Nat) {m : Nat} (enough : 2 * (n + 2) ≤ m) :
    (∀ t, 2 ≤ InTurn.levels (fun _ z => z + gate z) (fun _ z => z) (fun _ a => a) 2 t) ∧
    (web (onSource (InTurn.levels (fun _ z => z + gate z)
      (InTurn.revised (fun _ z => z + gate z) (n + 2) (fun _ z => z) (fun _ a => a) m).1
      (InTurn.revised (fun _ z => z + gate z) (n + 2) (fun _ z => z) (fun _ a => a) m).2 2))).Broken 0
        .dweller .source :=
  ⟨gated_restraint_keeps,
   Web.revised_broken (W := web (onSource (InTurn.levels (fun _ z => z + gate z)
      (InTurn.revised (fun _ z => z + gate z) (n + 2) (fun _ z => z) (fun _ a => a) m).1
      (InTurn.revised (fun _ z => z + gate z) (n + 2) (fun _ z => z) (fun _ a => a) m).2 2)))
     (c := Place.source) (f := Formation.dweller) enough (fun _ _ => rfl) (Nat.succ_pos (n + 1)) trivial
     (Nat.succ_pos 1) (Nat.le_refl 2)⟩
