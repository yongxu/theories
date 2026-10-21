import Becoming.Frame

/-!
# The seed–edge closure

A seed and a relation of edges give a one-label process whose steps are the edges
(`edgeProcess`); what that process reaches from a seed is the seed–edge closure (`Closure`). It
holds the seeds, is closed under the edges, and lies within every property holding at the seeds
and carried along the edges (`Closure.base`, `Closure.step`, `Closure.induction`).

The core's closure under a relation (`WithinClosure`, `Becoming.Frame`), what lies in every
region closed under it that holds a formation, is the seed–edge closure from that formation alone
(`withinClosure_iff_closure`), since a process's reach is the closure of its steps
(`reach_iff_withinClosure`, `Becoming.Frame`). `Becoming.Bridge` proves that the periphery's closures of seeds
under edges are this closure (`reached_iff_closure`, `cutReach_iff_closure`), and
`Becoming.SeedReachProcesses` states their laws for any process whose moves are the edges. Every
declaration has an empty axiom report.
-/

namespace Becoming

open Generative

universe u

/-- A one-label process whose steps are the given edges. -/
def edgeProcess {X : Type u} (edge : X → X → Prop) : Process X Unit :=
  ⟨fun x _ y => edge x y⟩

/-- Everything reached from a seed along edges. -/
def Closure {X : Type u} (seed : X → Prop) (edge : X → X → Prop) (x : X) : Prop :=
  ∃ p, seed p ∧ Reach (edgeProcess edge) p x

namespace Closure

variable {X : Type u} {seed : X → Prop} {edge : X → X → Prop}

theorem base {x : X} (held : seed x) : Closure seed edge x :=
  ⟨x, held, Reach.refl _ _⟩

theorem step {x y : X} : Closure seed edge x → edge x y → Closure seed edge y
  | ⟨p, held, path⟩, e => ⟨p, held, path.trans (Reach.of_step (a := ()) e)⟩

/-- Any property holding at seeds and preserved along edges holds on the closure. -/
theorem induction {motive : X → Prop} (start : ∀ x, seed x → motive x)
    (carry : ∀ x y, motive x → edge x y → motive y) {x : X} :
    Closure seed edge x → motive x
  | ⟨p, held, path⟩ =>
    Invariant.reach (P := edgeProcess edge) (fun x _ y e m => carry x y m e) path (start p held)

end Closure

/-- The core's closure under a relation, what lies in every region closed under it that holds a
formation (`Becoming.Frame`), is the seed–edge closure from that formation alone: the edge
process's reach, which is the closure of its steps (`reach_iff_withinClosure`), and its steps are
the edges. -/
theorem withinClosure_iff_closure {X : Type} {rel : X → X → Prop} {f g : X} :
    WithinClosure rel f g ↔ Closure (fun x => x = f) rel g :=
  ⟨fun within => ⟨f, rfl, reach_iff_withinClosure.mpr
      (WithinClosure.mono (fun _ _ e => ⟨(), e⟩) within)⟩,
   fun ⟨_, same, path⟩ => same ▸
      WithinClosure.mono (fun _ _ ⟨_, e⟩ => e) (reach_iff_withinClosure.mp path)⟩

end Becoming
