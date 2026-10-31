import Becoming.Continuity
import Becoming.GrammarCrossing

/-!
# Balance region by region: a family a relation closes is a region not gone out of

`Becoming.Continuity` reads closure by families, tests on the relata: a family the relation closes
is one whose adjacent listed relata lie both in it or both outside it (`Continuity.Closes`). This
module reads that on the grammar's `«不出»` (`Becoming.GrammarCrossing`).

* **Adjacency among the listed relata is a relation of the grammar** (`Continuity.adjacentListed`):
  both listed, and adjacent under the relation. It is symmetric (`Continuity.adjacentListed_symm`).
* **A family the relation closes is a region not gone out of along it**
  (`Continuity.closes_iff_notGoingOut`), and a region closed under it
  (`Continuity.closes_iff_closed`). Membership is a test, so both are exact. Along a symmetric
  relation nothing goes out exactly where nothing comes in (`«对称则不出当且仅当逆不出»`), so such a
  region is neither gone out of nor come into.
* **Balance along a relation is conservation on every region not gone out of.** Over relata listed
  without repetition, equality decided, transfers along the relation that balance a step exist
  exactly where the total is conserved on every region nothing goes out of along adjacency among the
  listed relata (`Continuity.balancing_iff_notGoingOut`, `Continuity.balancing_iff` read on `«不出»`),
  and on a web at every step likewise (`Continuity.balancesOn_iff_notGoingOut`).

So balance along a relation is kept region by region, on the regions the relation does not cross.
What is not shown: that conservation on each closure under the symmetric adjacency (the `«所闭»` form)
is enough, each region not gone out of being a union of such closures among finitely many relata.
Every declaration has an empty axiom report.
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

/-- **A family the relation closes is a region not gone out of along adjacency among the listed
relata.** Membership is a test, so the equivalence is exact. -/
theorem closes_iff_notGoingOut {rel : R → R → Bool} {us : List R} {p : R → Bool} :
    Closes rel us p ↔ «不出» (adjacentListed rel us) (fun x => p x = true) :=
  ⟨fun closes x y inside outside listed =>
    outside ((closes x y listed.1 listed.2.1 listed.2.2).symm.trans inside),
   fun none a b ma mb near => by
    cases ha : p a <;> cases hb : p b
    · rfl
    · exact (none b a hb (fun inside => Bool.noConfusion (ha.symm.trans inside))
        (adjacentListed_symm rel us a b ⟨ma, mb, near⟩)).elim
    · exact (none a b ha (fun inside => Bool.noConfusion (hb.symm.trans inside))
        ⟨ma, mb, near⟩).elim
    · rfl⟩

/-- **A family the relation closes is a region closed under adjacency among the listed relata.** -/
theorem closes_iff_closed {rel : R → R → Bool} {us : List R} {p : R → Bool} :
    Closes rel us p ↔ «闭» (adjacentListed rel us) (fun x => p x = true) :=
  ⟨fun closes x y inside listed => (closes x y listed.1 listed.2.1 listed.2.2).symm.trans inside,
   fun closed => closes_iff_notGoingOut.mpr («闭则不出» closed)⟩

/-- **Balance along a relation is conservation on every region not gone out of.** Over relata
listed without repetition, transfers along the relation that balance a step exist exactly where the
total is conserved on every region, read as a test, that nothing goes out of along adjacency among
the listed relata. -/
theorem balancing_iff_notGoingOut [DecidableEq R] {rel : R → R → Bool} {us : List R}
    {prev next : R → Nat} (distinct : Distinct us) :
    (∃ move, Balancing rel us prev next move) ↔
      ∀ p : R → Bool, «不出» (adjacentListed rel us) (fun x => p x = true) →
        total us (within p next) = total us (within p prev) :=
  (balancing_iff distinct).trans
    ⟨fun conserved p none => conserved p (closes_iff_notGoingOut.mpr none),
     fun conserved p closes => conserved p (closes_iff_notGoingOut.mp closes)⟩

/-- **On a web, balance along a relation is conservation on every region not gone out of, at every
step.** Over relata listed without repetition, with the relation free to change from step to step:
where the levels are conserved at every step on every region nothing goes out of along that step's
adjacency among the listed relata, the routed transfers balance them; and every flow of transfers
along the relation balancing them conserves them so. -/
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
