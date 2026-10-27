import Becoming.HeldPossible

/-!
# UE11 review probes: the held possible read on the root

Evidence for the review, not proposed for landing as written. Index (REVIEW-UE11.md, P9):

* `steps_keeping_iff`, `reach_keeping_iff_line`: the moves keeping a relation are the
  continuations (`«续»`) under it of the process's steps, and what they reach is the start or the
  line (`«相续»`) under it. So `Reaching.PossibleHeld P E adm s` is what the line from `s` under
  `E` admits, and `Reach.keeping_mono` is coarsening (`«粗化»`) read on processes.
* `possibleHeld_iff_line`: the held possible in the root's terms.
* `ji_line_of_chain`: the tower law on the root, for every carrier and relation: on a chain of
  coarsening relations, where every step is a continuation under some member, whatever the
  relation reaches lies on a line under some member.
* `sameFrom_class`, `tower_ji_line`: the levels from `n` up the same is a class, and the tower is
  an instance.
-/

namespace Becoming.ProbeUE11

open Generative

universe u v w

section Root

variable {S : Type u} {A : Type v} {P : Process S A} {Same : S → S → Prop}

/-- The moves keeping a relation, whatever their action, are the continuations under it of the
process's steps. -/
theorem steps_keeping_iff {s t : S} : Steps (keeping P Same) s t ↔ «续» (Steps P) Same s t :=
  ⟨fun ⟨a, step, same⟩ => ⟨⟨a, step⟩, same⟩, fun ⟨⟨a, step⟩, same⟩ => ⟨a, step, same⟩⟩

/-- **What the moves keeping a relation reach is the start or the line under it** (`«相续»`). -/
theorem reach_keeping_iff_line {s t : S} :
    Reach (keeping P Same) s t ↔ s = t ∨ «相续» (Steps P) Same s t :=
  ⟨fun reach => match «所闭当且仅当同一或及».mp (reach_iff_withinClosure.mp reach) with
     | .inl same => .inl same
     | .inr ji => .inr («及之单调» (fun _ _ step => steps_keeping_iff.mp step) _ _ ji),
   fun either => match either with
     | .inl same => Eq.subst (motive := fun t => Reach (keeping P Same) s t) same (Reach.refl _ s)
     | .inr line => reach_iff_withinClosure.mpr («所闭当且仅当同一或及».mpr
         (.inr («及之单调» (fun _ _ c => steps_keeping_iff.mpr c) _ _ line)))⟩

/-- **The possible with a relation held is what the line under it admits**, or the start. -/
theorem possibleHeld_iff_line {X : Type} {adm : S → X → Prop} {s : S} {x : X} :
    Reaching.PossibleHeld P Same adm s x ↔ adm s x ∨ ∃ t, «相续» (Steps P) Same s t ∧ adm t x :=
  ⟨fun ⟨t, reach, admitted⟩ => match reach_keeping_iff_line.mp reach with
     | .inl same => .inl (Eq.subst (motive := fun z => adm z x) same.symm admitted)
     | .inr line => .inr ⟨t, line, admitted⟩,
   fun either => match either with
     | .inl admitted => ⟨s, Reach.refl _ s, admitted⟩
     | .inr ⟨t, line, admitted⟩ => ⟨t, reach_keeping_iff_line.mpr (.inr line), admitted⟩⟩

end Root

/-- **The tower law on the root.** On a chain of coarsening relations, where every step of a
relation is a continuation under some member, whatever the relation reaches lies on a line under
some member. -/
theorem ji_line_of_chain {α : Type u} {R : «际» α} {E : Nat → «际» α}
    (coarsen : ∀ n m, n ≤ m → «则» (E n) (E m)) (each : ∀ x y, R x y → ∃ n, E n x y) :
    ∀ {x y : α}, «及» R x y → ∃ n, «相续» R (E n) x y
  | _, _, .one h => match each _ _ h with
    | ⟨n, e⟩ => ⟨n, .one ⟨h, e⟩⟩
  | _, _, .more h rest => match each _ _ h, ji_line_of_chain coarsen each rest with
    | ⟨k, e⟩, ⟨n, line⟩ => ⟨k + n, .more ⟨h, coarsen k (k + n) (Nat.le_add_right k n) _ _ e⟩
        («及之单调» («粗化» R (coarsen n (k + n) (Nat.le_add_left n k))) _ _ line)⟩

section Tower

variable {Z : Type u} {R : Type v}

/-- The levels from `n` up the same is a class. -/
theorem sameFrom_class (n : Nat) : «类» (RuleTower.SameFrom (Z := Z) (R := R) n) :=
  ⟨fun _ _ _ => rfl, fun same m le => (same m le).symm,
   fun first second m le => (second m le).trans (first m le)⟩

/-- The tower is an instance: whatever its moves reach lies on a line under the class of the
levels from some height up. -/
theorem tower_ji_line {base : R → Z → Z → Prop} {up : Nat → R → R → R → Prop}
    {x y : Z × (Nat → R)} (ji : «及» (Steps (RuleTower.process base up)) x y) :
    ∃ n, «相续» (Steps (RuleTower.process base up)) (RuleTower.SameFrom n) x y :=
  ji_line_of_chain (E := fun n => RuleTower.SameFrom n)
    (fun _ _ le _ _ same => RuleTower.SameFrom.mono same le)
    (fun _ _ ⟨a, step⟩ => ⟨a, RuleTower.step_sameFrom a step⟩) ji

end Tower

end Becoming.ProbeUE11
