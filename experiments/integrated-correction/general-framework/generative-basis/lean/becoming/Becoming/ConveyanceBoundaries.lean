import Becoming.Boundaries
import Becoming.GrammarCrossing

/-!
# Boundaries along conveyance: the World's cut on the root, and 04 §1's law on 07 §4.1's boundaries

`Flow.Cut` (`Becoming.Standpoints`) is a region of a valuation's events that no formed relation
leaves; a boundary of a self along a relation (`Boundary`, `Becoming.Boundaries`) is a region holding
it and closed under the relation. This module reads the first on the root and joins the two. It adds
no definition and changes none: the cut keeps its definition in `Becoming.Standpoints`, one with
`«不出»` by `Iff.rfl`, and this module, the World's case of the crossing laws, is a leaf.

* **The World's cut is not going out.** A cut is the grammar's `«不出»` at the valuation's relation, by
  definition (`Flow.cut_iff_notGoingOut`). So a region closed under the relation is a cut
  (`Flow.cut_of_closedUnder`), and a cut is closed where membership is stable
  (`Flow.closedUnder_of_cut`), by `«闭则不出»` and `«不外者内则不出当且仅当闭»` (`Becoming.GrammarCrossing`).
  Conveyance's relation is symmetric (`Flow.conveyance_symm`), so along it nothing goes out of a region
  exactly where nothing comes in (`Flow.cut_iff_not_come_into`, by `«对称则不出当且仅当逆不出»`).
* **A continuing family's region is no boundary along conveyance.** Under balance and dissipation,
  read with one kind of relatum, with no repetition, decided equality and enclosure around the family
  from some step on, where something takes from the family at arbitrarily late steps, conveyance
  crosses the family's boundary (04 §1, `Flow.region_not_a_cut`). So the region of the family's events
  is no boundary along conveyance of any event (`Flow.region_no_boundary`), and not every member's
  event has its closure along conveyance, its least boundary, within the family
  (`Flow.closures_not_within_region`).
* **The clearing.** With no such premise, the resource's region is no boundary along conveyance, nor
  along living on (`Clearing.resource_no_boundary`), from 04 §1's witness.

What is not shown: that a continuing family's closure along conveyance reaches every formation; which
relation a self's boundary is drawn along (07 §4.2). Every declaration has an empty axiom report.
-/

namespace Becoming

namespace Flow

section Cuts

variable {Pos Q : Type}

/-- **The World's cut is not going out**, by definition: a region of a valuation's events that no
formed relation leaves is one nothing in it goes out of along the valuation's relation. -/
theorem cut_iff_notGoingOut {V : Valuation Pos Q} {region : Q → Prop} :
    Cut V region ↔ «不出» V.related region :=
  Iff.rfl

/-- A region closed under a valuation's relation is a cut. -/
theorem cut_of_closedUnder {V : Valuation Pos Q} {region : Q → Prop}
    (closed : ClosedUnder V.related region) : Cut V region :=
  cut_iff_notGoingOut.mpr («闭则不出» (closedUnder_iff_closed.mp closed))

/-- A cut is closed under the valuation's relation where membership is stable. -/
theorem closedUnder_of_cut {V : Valuation Pos Q} {region : Q → Prop}
    (stable : ∀ e, ¬ ¬ region e → region e) (cut : Cut V region) : ClosedUnder V.related region :=
  closedUnder_iff_closed.mpr ((«不外者内则不出当且仅当闭» stable).mp (cut_iff_notGoingOut.mp cut))

end Cuts

section Crossing

variable {X Pos : Type} {L : Flow X X} {W : Web X X} {own sig : Pos → X × Nat → Prop}

/-- **Conveyance's relation is symmetric**: two events at a common step are related where something is
conveyed between their relata, whichever way. -/
theorem conveyance_symm :
    «则» (L.conveyance W own sig).related («逆» (L.conveyance W own sig).related) :=
  fun e e' related => show (L.conveyance W own sig).related e' e from
    ⟨related.1.symm, Eq.subst (motive := fun s => L.Conveys s e'.1 e.1 ∨ L.Conveys s e.1 e'.1)
      related.1 related.2.symm⟩

/-- **Along conveyance nothing goes out of a region exactly where nothing comes in.** -/
theorem cut_iff_not_come_into {region : X × Nat → Prop} :
    Cut (L.conveyance W own sig) region ↔ «不出» («逆» (L.conveyance W own sig).related) region :=
  «对称则不出当且仅当逆不出» conveyance_symm

/-- **A continuing family's region is no boundary along conveyance.** Under balance and dissipation,
read with one kind of relatum, with no repetition, decided equality and enclosure around the family
from some step on, where something takes from the family at arbitrarily late steps, the region of the
family's events is not closed under conveyance, so it is a boundary of no event's self along
conveyance (07 §4.1). -/
theorem region_no_boundary [DecidableEq X] (balances : L.Balances W) (dissipative : L.Dissipative)
    {ds : List X} (distinct : Distinct ds) {T₀ : Nat} (around : ∀ t, T₀ ≤ t → L.Around ds t)
    (recurs : ∀ N, ∃ t, N ≤ t ∧ 0 < L.takers ds t) (e : X × Nat) :
    ¬ Boundary (L.conveyance W own sig).related e (fun e => e.1 ∈ ds) :=
  fun boundary => region_not_a_cut (own := own) (sig := sig) balances dissipative distinct around
    recurs (cut_of_closedUnder boundary.1)

/-- **So not every event of the family has its least boundary along conveyance within the family**:
were each member's event's closure under conveyance within the family, the family's region would be
closed under conveyance. -/
theorem closures_not_within_region [DecidableEq X] (balances : L.Balances W)
    (dissipative : L.Dissipative) {ds : List X} (distinct : Distinct ds) {T₀ : Nat}
    (around : ∀ t, T₀ ≤ t → L.Around ds t) (recurs : ∀ N, ∃ t, N ≤ t ∧ 0 < L.takers ds t) :
    ¬ ∀ e, e.1 ∈ ds → ∀ g, WithinClosure (L.conveyance W own sig).related e g → g.1 ∈ ds :=
  fun within => region_not_a_cut (own := own) (sig := sig) balances dissipative distinct around
    recurs (cut_of_closedUnder fun x y inside related => within x inside y («缘在所闭» related))

end Crossing

end Flow

namespace Clearing

/-- **In the clearing the resource's region is no boundary along conveyance, nor along living on**,
read with one kind of relatum: the step's fuel is conveyed to the resource, and the clearer lives on
it (`resource_not_cut`, `resource_not_cut_living_on`). -/
theorem resource_no_boundary {Pos : Type} (own sig : Pos → (Formation ⊕ Place) × Nat → Prop)
    (e : (Formation ⊕ Place) × Nat) :
    ¬ Boundary (Flow.conveyance flow.roles web.roles own sig).related e
        (fun e => e.1 ∈ [Sum.inr Place.resource]) ∧
      ¬ Boundary (web.roles.sustenance own sig).related e
        (fun e => e.1 ∈ [Sum.inr Place.resource]) :=
  ⟨fun boundary => resource_not_cut own sig (Flow.cut_of_closedUnder boundary.1),
   fun boundary => resource_not_cut_living_on own sig (Flow.cut_of_closedUnder boundary.1)⟩

end Clearing

end Becoming
