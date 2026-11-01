import Becoming.Continuity
import Becoming.GrammarCrossing

/-!
# Balance region by region: a family a relation closes is a region not gone out of

`Becoming.Continuity` reads closure by families, tests on the relata: a family the relation closes
is one whose adjacent listed relata lie both in it or both outside it (`Continuity.Closes`). This
module reads that on the grammar's `«不出»` (`Becoming.GrammarLaws`).

* **Adjacency among the listed relata is a relation of the grammar** (`Continuity.adjacentListed`):
  both listed, and adjacent under the relation. It is symmetric (`Continuity.adjacentListed_symm`).
* **A family the relation closes is a region closed under that adjacency, and one not gone out of
  along it** (`Continuity.closes_iff_closed`, `Continuity.closes_iff_notGoingOut`). A region closed
  under a symmetric adjacency is closed under its converse too, and one closed both ways the
  adjacency crosses neither way (`GrammarLaws.uncrossed_of_closed`), which is what
  `Continuity.Closes` says; membership is a test, so stable, and there not going out is being
  closed (`«不外者内则不出当且仅当闭»`). Along a symmetric relation nothing goes out exactly where
  nothing comes in (`«对称则不出当且仅当逆不出»`), so the family is also a region not come into
  (`Continuity.closes_iff_notComingIn`).
* **Balance on the regions not gone out of.** Over relata listed without repetition, with equality
  decided, transfers along the relation that balance a step exist exactly where the total is
  conserved on every region nothing goes out of along adjacency among the listed relata
  (`Continuity.balancing_iff_notGoingOut`, `Continuity.balancing_iff` read on `«不出»`), and on a
  web at every step likewise (`Continuity.balancesOn_iff_notGoingOut`).

So balance along a relation is kept region by region, on the regions the relation crosses neither
way among the listed relata. What is not shown: balance from conservation on each closure under
that adjacency (`«所闭»`), the components of network flows. A region not gone out of holds its
members' closures (`«闭含所闭»`, `«所闭之自反»`), so it is their union; missing are each closure
decided as a test among the finitely many listed relata, and a region's total summed over the
closures it holds. Every declaration has an empty axiom report.
-/

namespace Becoming

namespace Continuity

variable {R : Type}

/-- Adjacency among the listed relata, a relation of the grammar: both listed, and adjacent under
`rel`. -/
def adjacentListed (rel : R → R → Bool) (us : List R) : «际» R :=
  fun a b => a ∈ us ∧ b ∈ us ∧ adj rel a b = true

/-- Adjacency among the listed relata is symmetric. -/
theorem adjacentListed_symm (rel : R → R → Bool) (us : List R) :
    «则» (adjacentListed rel us) («逆» (adjacentListed rel us)) :=
  fun a b listed => ⟨listed.2.1, listed.1, (adj_symm rel a b).symm.trans listed.2.2⟩

/-- **A family the relation closes is a region closed under adjacency among the listed relata.**
The adjacency is symmetric, so a region closed under it is closed under its converse, and one
closed both ways the adjacency crosses neither way (`GrammarLaws.uncrossed_of_closed`). -/
theorem closes_iff_closed {rel : R → R → Bool} {us : List R} {p : R → Bool} :
    Closes rel us p ↔ «闭» (adjacentListed rel us) (fun x => p x = true) :=
  ⟨fun closes x y inside listed => (closes x y listed.1 listed.2.1 listed.2.2).symm.trans inside,
   fun closed a b ma mb near =>
    GrammarLaws.uncrossed_of_closed closed
      (fun x y inside back => closed x y inside (adjacentListed_symm rel us y x back))
      a b ⟨ma, mb, near⟩⟩

/-- **A family the relation closes is a region not gone out of along adjacency among the listed
relata.** The adjacency being symmetric and membership a test, so stable, the equivalence is exact:
`Continuity.closes_iff_closed`, and not going out is being closed where membership is stable
(`«不外者内则不出当且仅当闭»`). -/
theorem closes_iff_notGoingOut {rel : R → R → Bool} {us : List R} {p : R → Bool} :
    Closes rel us p ↔ «不出» (adjacentListed rel us) (fun x => p x = true) :=
  closes_iff_closed.trans
    («不外者内则不出当且仅当闭» (R := adjacentListed rel us) (P := fun x => p x = true)
      fun y notOutside =>
        match holds : p y with
        | true => holds
        | false => (notOutside fun inside => Bool.noConfusion (holds.symm.trans inside)).elim).symm

/-- **A family the relation closes is a region not come into along adjacency among the listed
relata.** The adjacency is symmetric, so nothing goes out of a region along it exactly where
nothing comes into it (`«对称则不出当且仅当逆不出»`). -/
theorem closes_iff_notComingIn {rel : R → R → Bool} {us : List R} {p : R → Bool} :
    Closes rel us p ↔ «不出» («逆» (adjacentListed rel us)) (fun x => p x = true) :=
  closes_iff_notGoingOut.trans («对称则不出当且仅当逆不出» (adjacentListed_symm rel us))

/-- **Balancing transfers exist exactly where every region not gone out of conserves the total.**
Over relata listed without repetition, with equality decided, transfers along the relation that
balance a step exist exactly where the total is conserved on every region, read as a test, that
nothing goes out of along adjacency among the listed relata. -/
theorem balancing_iff_notGoingOut [DecidableEq R] {rel : R → R → Bool} {us : List R}
    {prev next : R → Nat} (distinct : Distinct us) :
    (∃ move, Balancing rel us prev next move) ↔
      ∀ p : R → Bool, «不出» (adjacentListed rel us) (fun x => p x = true) →
        total us (within p next) = total us (within p prev) :=
  (balancing_iff distinct).trans
    ⟨fun conserved p none => conserved p (closes_iff_notGoingOut.mpr none),
     fun conserved p closes => conserved p (closes_iff_notGoingOut.mp closes)⟩

/-- **On a web, balancing transfers exist exactly where every region not gone out of conserves the
levels, at every step.** Over relata listed without repetition, with equality decided and the
relation free to change from step to step: transfers between adjacent listed relata at each step,
read as a flow, balancing the levels on the listed relata at every step exist exactly where at
every step the levels are conserved on every region, read as a test, that nothing goes out of along
that step's adjacency among the listed relata. -/
theorem balancesOn_iff_notGoingOut [DecidableEq R] {us : List R} {rel : Nat → R → R → Bool}
    {W : Web R R} (distinct : Distinct us) :
    (∃ move : Nat → R → R → Nat,
        (∀ t a b, 0 < move t a b → adj (rel t) a b = true ∧ a ∈ us ∧ b ∈ us) ∧
          ∀ t, (flow us move).BalancesOn W us t) ↔
      ∀ t (p : R → Bool), «不出» (adjacentListed (rel t) us) (fun x => p x = true) →
        total us (within p (W.level (t + 1))) = total us (within p (W.level t)) :=
  (balancesOn_iff_conserved distinct).trans
    ⟨fun conserved t p none => conserved t p (closes_iff_notGoingOut.mpr none),
     fun conserved t p closes => conserved t p (closes_iff_notGoingOut.mp closes)⟩

end Continuity

end Becoming
