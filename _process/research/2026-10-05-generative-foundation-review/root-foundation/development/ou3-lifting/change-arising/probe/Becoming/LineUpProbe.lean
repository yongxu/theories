import Becoming.Space

namespace Becoming

/-- Probe: the finite-world law of arising and ceasing, asked of every finite world without
decidability, is equivalent to deciding every position along the steps. -/
theorem World.law_iff_positions :
    (∀ w : World, w.Finite → (w.ArisingRecurs ↔ w.CeasingRecurs)) ↔
      ∀ (p : Nat → Prop) (t : Nat), «生» Steps.next (Steps.alike p) t ∨
        «有前» Steps.next (Steps.alike p) t :=
  World.law_iff_em.trans positions_iff_em.symm

/-- Probe: and to the grammar's own calibration over every carrier and relation. -/
theorem World.law_iff_grammar_positions :
    (∀ w : World, w.Finite → (w.ArisingRecurs ↔ w.CeasingRecurs)) ↔
      ∀ (α : Type) (R E : «际» α) (x : α), «生» R E x ∨ «有前» R E x :=
  World.law_iff_em.trans «四相之定当且仅当排中».symm

end Becoming
