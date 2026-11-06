import Becoming.Amounts

/-!
# Renewal and consumption over configurations

The relational classification of `RelationalRenewal` reads one unfolding through the
levels of conditions of further formation and the formations depending on them or
drawing on them. On the spine these are observables of configurations, so every run
of every process carries the classification: `Conditions.along` (`Becoming.Labelled`) reads a
run as a `RelationalRenewal.Unfolding`, and every theorem of that module applies to it.

One principle bounds continuation without renewal: an observable that never rises
from some step on does not fall at arbitrarily late steps. Three bounds proved separately before
are its cases along a run:
* depletion (`Depletion`): if every step lowers a reserve, no run exists;
* recurrent renewal (`ContinuationRenewal`, natural-number rank): if every step
  that is not a renewal lowers a rank, renewal recurs arbitrarily late;
* unrenewed drawdown (`RelationalRenewal`): a formation lowering an unrenewed
  condition at each active step is not active at arbitrarily late steps.
`ContinuationRenewal` also has a well-founded form, more general than the
natural-number rank used here.

The class belongs to the run, not to a configuration or to the formation's own
activity: in one process, from one configuration, with the focal formation active at
every step of both runs, one run renews and the other consumes.

No ethical predicate, ranking or axiom occurs. Which observables represent an actual
history is an application duty. Every declaration has an empty axiom report.

The readings along a run (`Conditions.along` and the `Renewable` witness runs) are in
`Becoming.Labelled`, so this module states the classification over configurations and does not
import the frame.
-/

namespace Becoming

universe u v

variable {S : Type u} {A : Type v}

/-! ## Conditions as observables of configurations -/

/-- Levels of conditions of further formation at each configuration, the formations
active there, and which conditions each formation's continuation depends on (at what
level) and its activity draws on. -/
structure Conditions (S : Type u) (F C : Type) where
  level : S → C → Nat
  active : S → F → Prop
  requires : F → C → Prop
  need : F → C → Nat
  draws : F → C → Prop

/-! ## Continuation without renewal -/

/-- An observable that never rises from step `T` on does not fall at arbitrarily late steps: the
least-loss law of rest (`Amounts.rests`) at whole-number amounts, a strict fall of a whole number
being a fall by at least one and every whole number lying within its own count of ones plus one. -/
theorem falls_not_recurring (rank : Nat → Nat) (T : Nat)
    (noRise : ∀ n, T ≤ n → rank (n + 1) ≤ rank n) :
    ¬ ∀ N, ∃ n, N ≤ n ∧ rank (n + 1) < rank n :=
  Amounts.rests (M := Amounts.whole) (s := rank) (ε := 1) (P := fun n => rank (n + 1) < rank n)
    (m := rank T + 1) noRise (fun _ _ falls => falls) (Amounts.whole_within (rank T))

/-! ## The class belongs to the run -/

namespace Renewable

inductive Formation where
  | focal
  | sustaining

/-- The sustaining formation depends on the condition at level one; the focal
formation draws on it and is active everywhere. -/
def conditions : Conditions Nat Formation Unit where
  level s _ := s
  active
    | _, .focal => True
    | s, .sustaining => 1 ≤ s
  requires
    | .focal, _ => False
    | .sustaining, _ => True
  need
    | .focal, _ => 0
    | .sustaining, _ => 1
  draws
    | .focal, _ => True
    | .sustaining, _ => False

def beyondRenewalState : Nat → Nat
  | 0 => 1
  | _ + 1 => 0

end Renewable

end Becoming
