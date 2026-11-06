import Becoming.Grammar
import Becoming.GrammarMap
import Becoming.Prelude

/-!
# The five shared laws on the grammar (共律)

The shared laws of the method chapter (08 §7) restated on the grammar of `Becoming.Grammar`, for
every carrier and every relation: closure, balance, finite runs (return, being drawn, rest and
steps counted), lumping and order. Each is stated with what it uses: where a global form uses more
(a fixed successor everywhere, merging nothing everywhere, a successor everywhere, a list of the
whole carrier), it is a corollary of a local one stated beside it. This module imports only the grammar,
its map (`Becoming.GrammarMap`, for `«尽»`) and the prelude, so it sits below every model:
`Becoming.Frame` imports it, and the models' laws that are cases of these are proved from them in
their own modules (closure in `Frame`, `GrammarScope`, `Junctures`, `Response` and `SelectionPool`;
finite runs in `Recurrence`, `Attraction`, `Amounts` and `Learning`; lumping bridged in `Laws` and
proved from them in `Mechanism`, `GrammarRegularity`, `IdentificationRuns` and `LearningRuns`; order
in `Admission`, `Regions` and `Weightings`, and the lagged orders of `ComparingCourses` and
`ReachableRanges` from the two relation laws beside widening's). Those two (`strictJoin_trans`,
`strictJoin_irrefl`) are laws of any two relations, stated on `α → α → Prop` rather than `«际» α`:
lemmas the orders use, not statements of the grammar. Balance alone is
represented, not derived: `Flow.Balances`, `Flow.BalancesOn`, `Flow.Balances.over` and
`balance_over_stretch_on` are each read on the grammar both ways (`Flow.balances_iff_units`,
`Flow.balancesOn_iff_units`, `Flow.over_iff_units`, `«程守数当且仅当可对»`), and their proofs and
their consumers' stay arithmetic, since each needs only the count.

| name | gloss |
|---|---|
| `«闭»` | a region closed under a relation: whatever a member bears it to is a member |
| `«所闭»` | lying within a closure: every region closed under the relation that holds `x` holds `y` |
| `«不出»` | nothing in a region goes out of it along a relation: no member bears it to something outside |
| `«对»` | a perfect pairing of the places of two finite lists under a relation, each pair related |
| `«计»` | how many units of a list a test holds of: a region read as a test (`α → Bool`), a modelling choice; a region given as a proposition enters by `decide` |
| `«聚»` | lists gathered along a list of indices, joined |
| `«定后»`, `«定前»` | the successor is fixed (`R˘;R ⊆ 静`); the predecessor is fixed, nothing merged (`R;R˘ ⊆ 静`) |
| `«定后于»` | the successor is fixed at what `x` reaches (`«定后»` within `«所闭» R x`) |
| `«线不并»` | merging nothing at the first `N` places of a line |
| `«入»` | drawn in: a closed region `x` lies outside holds something `x` reaches |
| `«迭»` | `n` steps: the `n`-fold composition of a relation |
| `«历»` | passing through a word's relations in turn: on the empty word no step, then each letter's relation; `«迭»` is its case for one relation repeated |
| `«迭内»`, `«静或缘»` | within `n` steps: some number of steps not more than `n`; staying, or a step of a relation |
| `«承»` | what every condition held: the occurrences whose every condition under a relation lies in a region |
| `«屡»`, `«或屡»` | steps of a relation recur along a line; recur as far as can be refuted, from a place on |
| `«同行»` | `E` goes alike under `R`: `R˘;E;R ⊆ E` |
| `«像»` | the image of a relation along a map |
| `«逾»` | exceeds: relates something the other does not |
| `«广»`, `«齐»`, `«杂»` | widens (includes and exceeds); keeps (each includes the other); mixed (each exceeds the other) |

* **Closure.** `«所闭» R x y` is exactly `x = y ∨ «及» R x y` (`«所闭当且仅当同一或及»`): the least
  closed region holding `x` is `x` itself with what `x` reaches. It is reflexive, transitive, holds
  every step, grows with the relation, is symmetric for a symmetric relation, read under the converse
  is the closure read backward (`«所闭之逆»`), is itself closed, and nothing within it bears the
  relation beyond it (`«所闭之界»`). Nothing in a region goes out of it along a relation (`«不出»`)
  where no member bears the relation to something outside: a closed region is not gone out of
  (`«闭则不出»`), an occurrence's closure among them, the closure law read through not going out
  (`«所闭不出»`). A region is `x`'s closure exactly where it holds `x`, is closed and lies within the
  closure (`«所闭之证»`). A closure through borrowed steps, every step of `R'` a step of `R` or a step
  of `R` from `a` taken at `o`, lies within `o`'s or `a`'s closure under `R`
  (`«借步之所闭在二所闭»`), and the two lie within `o`'s closure under `R'` where `R'` holds `R` and
  `a` lies within `o`'s closure under it (`«二所闭在借步之所闭»`); Response's `WithinClosure.converse` and
  SelectionPool's `WithinClosure.of_reads` and `WithinClosureOf.to_reads` are proved as these. A
  region of the steps of time that every step keeps holds from where it holds on, the closure at the
  successor along a line (`kept_onward`); the models' activity laws that keep a region along the
  steps by their own induction are its cases.
* **Balance.** A perfect pairing (`«对»`) between finite lists under any relation conserves their
  count (`«对之长»`); under the one it is exactly equal count (`«一之对»`), and under an arbitrary
  relation equal count need not give one (`«等长而不对之例»`, under the empty relation). Pairings
  read backward are pairings under the converse (`«对之逆»`), compose under the composite
  (`«对之接»`: `«对» R a b` and `«对» S b c` give `«对» («而» R S) a c`; under a transitive relation,
  under itself, `«对之传»`), and join (`«对之并»`). So lists paired from what comes in (before, given)
  to what goes on (after, taken) have `after + taken = before + given` (`«对则守数»`), and every four
  numbers with that equation are the lengths of lists of units so paired under the one
  (`«守数当且仅当可对»`). Over a finite family, the members' pairings gather into the family's
  (`«对之族»`); over a stretch, pairings at each step under `R` give one, under `R`'s closure, of
  what stands before the stretch with everything given along it with what stands after it with
  everything taken along it (`«对之程»`), and the count law over a stretch is exactly such a
  pairing of units (`«程守数当且仅当可对»`). This is an exact cardinality representation of
  natural-number balance, near-definitional under the one: the pairing is supplied, not derived from
  the unfolding, and it establishes no trajectory of units. Counting a region's units (`«计»`, the
  region read as a test), a pairing keeps the count on every region not gone out of either way, which
  is exactly a region the relation does not cross (`GrammarLaws.uncrossed_iff_notGoingOut`) and a
  region closed under the relation and under its converse (`GrammarLaws.uncrossed_iff_closed`): one
  law, read either way (`«对则不越域守数»`, `«对则双闭域守数»`); closed one way is not enough
  (`«对而单闭域不守数之例»`). Under a class decided
  by a test, a pairing is exactly equal count in every class (`«类之对当且仅当类类等数»`), and the
  class does work: equal count pairs under the one and not under sameness (`«一对而静不对之例»`). So
  a pairing under continuation relative to such a class keeps the count in every class
  (`«续之对则类类等数»`). The census of a step (its own section, after the runs, whose fixed
  successor and predecessor it reads): units listed once before and after a step, under a
  continuation fixing successors and predecessors, pair those before with those arising to those
  after with those ceasing, each pair a continuation or the same unit
  (`«定后定前则前并生对后并亡»`), and where every predecessor of a unit after stands before and every
  successor of a unit before stands after, arising and ceasing are exactly beginning (`«生»`) and
  ending (`«亡»`) (`«前者在前则所列生者生»`, `«后者在后则所列亡者亡»`).
  The listing and the test are supplied.
* **Finite runs: return and being drawn.** For every relation, `x` is drawn exactly where it
  reaches something that does not reach back (`«入当且仅当有不返»`). With the successor fixed at
  what `x` reaches, `x`, reaching itself, is not drawn (`«定后于则返者不入»`, from
  `«定后于环则所及皆返»`); for every relation, an occurrence with a successor that does not reach
  itself is drawn (`«有后不返则入»`); so with the successor fixed there and some successor, drawn is
  exactly not reaching itself (`«定后于有后则入当且仅当不返»`). The global forms (`«定后环则所及皆返»`,
  `«定后则返者不入»`, `«定后有后则入当且仅当不返»`) are corollaries. The fixed successor cannot be
  omitted (`«入而返之例»`), nor can the successor (`«无后者不入亦不返»`), and the global fixed
  successor is more than the law uses (`«非定后返而不入之例»`: no fixed successor, yet a place that
  reaches itself is not drawn). Along a line whose places a list holds, merging nothing at the
  line's places brings the line back to its start within the list's length (`«线有限不并则回»`, by
  pigeonhole with no decidability, and back along the line, `«线不并则可退»`), so its start reaches
  itself (`«线有限不并则返»`); with the successor fixed at what its start reaches, its last place
  reaches itself (`«定后于线有限则末返»`). So where a list holds every occurrence and every
  occurrence has a successor, merging nothing makes every occurrence reach itself
  (`«有限遍后定前则皆返»`). Two occurrences that reach themselves, with the successor fixed at what
  each reaches, share no successor unless they are one (`«定后于二返则不并»`); so under a fixed
  successor every occurrence reaching itself makes the relation merge nothing (`«皆返定后则定前»`),
  and on a listed carrier with a successor everywhere the two are one (`«有限遍后定后则定前当且仅当皆返»`).
  Steps compose and cancel: with the successor fixed at what `x` reaches, `n` steps from `x` lead to
  one place (`«迭之定于»`), and merging nothing, `n` steps to one place come from one (`«迭之定前»`).
* **Finite runs: steps counted.** `n + 1` steps are `n` steps and then the last (`«迭之末步»`). Within
  `m` steps and then within `n` is within `m + n` (`«迭内之接»`), and within `n` steps is `n` steps each of
  which stays or steps (`«迭内即静或缘之迭»`). Let each round of a course of regions hold exactly what
  every condition held at the round before (`«承»`); then round `n` holds exactly where everything
  reaching in exactly `n` steps held at the start (`«承之迭»`): `n` rounds of taking on along a
  relation are one taking on along its `n` steps. With memory, each round also keeping what it held,
  round `n` holds exactly where everything reaching within `n` steps held (`«存承之迭»`), the law
  without memory under staying or a step: keeping is counting oneself among one's conditions.
  Steps split as they compose (`«迭之分»`, the converse of `«迭之接»`), and steps read backward are
  steps of the converse (`«迭之逆»`). Where whatever is reached in fewer than `n` steps has a
  successor as far as can be refuted, `n` steps exist as far as can be refuted (`«或有后则或迭»`); an
  unending line has steps of every length (`«不穷则迭»`), `n` steps leading to the occurrence itself
  or to what it reaches (`«迭则同一或及»`). Passing through a word's relations in turn (`«历»`) holds
  a word of relations where `«迭»` repeats one: `«迭»` is its case for one relation repeated (`«迭即历»`).
  Passing through two words is passing through the first and then the second (`«历之接»`), the last
  letter last (`«历之末步»`), and the reversed word by the converse relations is the word backward
  (`«历之逆»`); where no letter's relation merges, it merges nothing (`«历之定前»`), and where each
  goes alike under `E`, it keeps `E`-alike occurrences alike (`«同行之历»`). Six laws of `«迭»` are
  these laws' cases for one relation (`«迭之接»`, `«迭之分»`, `«迭之末步»`, `«迭之逆»`, `«迭之定前»`
  and `«同行之迭»`). The others keep their proofs, each for its reason: `«迭则及»`, `«及即迭»` and
  `«迭则同一或及»` read one relation's closure, and `«或有后则或迭»` and `«不穷则迭»`
  its successors along one line; `«迭之周»` repeats a loop; `«迭内即静或缘之迭»` relates steps of
  different lengths and `«承之迭»` a course of regions round by round, which no law of `«历»` states;
  and `«迭内之接»`, `«存承之迭»`, `«迭之定»` and `«同行于迭»` follow from laws above with no induction
  of their own. Of the models' step-indexed laws, these are proved from the laws of steps counted:
  `Withholding`'s closed forms from the laws of taking on, a course carrying its bounds
  (`WithinMoves.after_course`) from `«迭内之接»`, an unending line reaching every later step
  (`Web.reaches_onward`) from `«不穷则迭»`, and the lineage laws of `Becoming.Identity`
  (`Web.Lineage.unique`, `origin`, `split`, `through`, `onward`, `back`) from `«迭之定»`,
  `«迭之定前»`, `«迭之分»` and `«或有后则或迭»` with `«迭之逆»`, a lineage read as the steps of the
  continuation within activity (`Web.steps_iff_lineage`).
* **Lines from a list.** The closure is some number of steps (`«所闭当且仅当有迭»`). Where the
  successor is fixed only where two lines could part, `n` steps lead to one occurrence
  (`«分处定后则迭之定于»`; `«迭之定于»` is its case with the successor fixed throughout), so what ends
  lies on no longer line from the same occurrence (`«亡者不在长迭»`) and a line ends at most once
  (`«定后则线至多一亡»`). Hence, on any relation, occurrences listed once that end on lines from a
  list number at most the list (`«线终不过所列»`): endings (`«亡»`) on lines from a list, and at the
  converse beginnings (`«生»`) on lines to it, number at most the list (`«线亡不过所列»`,
  `«线生不过所列»`), with no decision, the reaching only not refuted where it must be
  (`«线亡不过所列之未否»`, `«线生不过所列之未否»`).
* **Finite runs: rest.** A line is at rest where its steps of `F` (a least fall, say) stop
  recurring (`«屡»`, `«或屡»`) while its steps are steps of `Q` (no rise, say). Where every course
  of `Q` steps then an `F` step ends from the line's place (`«尽» («而» («所闭» Q) F) «一»`, the
  grammar's ending), the `F` steps do not recur, as far as can be refuted (`«尽则不或屡»`) and so
  outright (`«尽则不屡»`), with no decision and no choice. `Amounts.rests_unrefuted` and
  `Amounts.rests` are this law at amounts (`Amounts.falls_end`: within fewer than `m` least losses
  the falls end), and `Amounts.FallsStop` is, by definition, the non-recurrence of strict falls
  (`Amounts.fallsStop_iff`). **Rest is not a case of being drawn in**: a fixed point is at rest and
  not drawn (`«止而不入之例»`), and a place can be drawn in while its steps of `F` recur
  (`«入而屡之例»`). The ending of the courses (`«尽»`) gives rest; it is a sufficient condition,
  not what rest is, and no converse is established.
* **The census, counted.** Counted by tests on the listed units, with no decision of identity,
  the census of a step holds by halves: under fixed successors, the units after with those a test
  marks as ceasing are at most the units before with those a test marks as arising
  (`«定后则后并亡不过前并生»`), and its mirror under fixed predecessors (`«定前则前并生不过后并亡»`); under both, the halves meet in the count of
  the paired census, the tests read off its decision (`«定后定前则前并生与后并亡同数»`). Along a run,
  where every predecessor of a unit listed after a step is listed before it, endings recurring give
  beginnings recurring (`«定后前者在前则亡屡者生屡»`). Each is the corollary of a local form that asks
  no split (no merge) only among the listed units (`GrammarLaws.census_le`, `census_le_converse`,
  `census_count`, `census_run`). The listing and the tests are supplied.
* **Ends on lines at stages.** With each step one stage on and the units a region nothing outside
  continues into, the lines traced back to a list covering a stage (所覆: containing every unit of
  the region at that stage) carry the count of ends on lines to the region: with nothing beginning
  in a stretch after the stage, the units ending in it number at most the list
  (`«间无生则间亡不过所覆»`); mirrored, with the region closed forward, nothing merging and nothing
  ending in a stretch, the units beginning in it number at most a list covering its end
  (`«间无亡则间生不过所覆»`). No decision is used. Through them, with lists covering arbitrarily late
  stages, endings recurring leave beginnings never stopping (`«所覆后亡屡则生未否»`,
  `«有覆而亡屡则生不止»`), and with each unit after the list's stage decided to begin or have a
  predecessor, give beginnings recurring (`«所覆后亡屡则有生»`, `«有覆而亡屡则生屡»`); with bounded
  covering lists, beginnings recurring leave endings never stopping (`«有界覆而生屡则亡不止»`), and with
  each unit decided to end or have a successor, give endings recurring (`«有界覆而生屡则亡屡»`). The
  census of a run is a case: its listed units read as occurrences at stages, the list at a stage
  covers it, and the test of beginnings decides a finite search by the count (`«计»`); it asks
  neither that the units after each step be listed once nor a test of endings.
* **Lumping.** `«同行» R E` (`R˘;E;R ⊆ E`) says that `E`-alike occurrences go to `E`-alike
  occurrences (`«同行之逐点»`). Constancy (`«有常»`) gives it where the successor is fixed at the
  occurrences `E` leads to (`«有常局定后则同行»`); it gives constancy where a successor exists at
  each occurrence `E` leads to from one that has a successor (`«同行可续则有常»`), a hypothesis
  constancy itself gives (`«有常则可续»`); so with the successor fixed there, constancy is exactly
  going alike plus that availability (`«局定后则有常当且仅当同行可续»`). The global forms
  (`«有常定后则同行»`, `«同行遍后则有常»`) are corollaries. With a fixed successor the core of a class is a
  class inside it that the step goes alike across (`«定后则类之核同行»`); where every occurrence has a
  successor, every class inside a relation going alike lies in its core (`«遍后则其内同行之类含于核»`), so with
  both the core of a class is the coarsest such class (`«定后遍后则核为其内最粗同行之类»`); off a fixed successor it
  need not go alike (`«后不定则核可不同行»`). The image of a relation along a map has
  a fixed successor exactly where sameness under the map goes alike (`«像定后当且仅当同行»`): a part
  read alone carries a law, possibly partial, exactly where the rest makes no difference to where it
  goes. Going alike keeps lines of every length alike (`«同行之迭»`). A map preserves a relation
  exactly where the image lies within the other (`«保之像»`).
* **Order.** Widening (`«广» R S`: `S ⊆ R` and `R` relates something `S` does not) is irreflexive,
  asymmetric and transitive; it excludes keeping and being mixed, and keeping excludes being mixed.
  Where inclusion or exceeding is decided both ways, one of the four holds (`«四比之周»`); that it is
  decided for every pair of relations on every carrier is exactly excluded middle
  (`«则逾之定当且仅当排中»`). What a path or a course admits is read as a coreflexive relation (a
  partial identity: `Web.admitted`, `Weighting.admittedOn`), so the models' comparisons are these.

What is not shown: that any model's relation is functional, total or listed (the models supply
these); the n-step lines law for lines of different lengths; that a pairing under continuation
(`«对» («续» R E)`) adds anything to equal count beyond what is now stated: the count on every region
it does not cross (`«对则不越域守数»`) and, where `E` is a class decided by a test, the count in every
class (`«续之对则类类等数»`); any converse of the law of
rest, from rest along a line to the ending of the courses: none is established, and one would have
to say which step relations it compares and on what logic. Every statement is pointwise; no equality of
relations is used, and every declaration has an empty axiom report.
-/

namespace Becoming

universe u v

/-! ## Closure (闭) -/

section Closure

variable {α : Type u}

/-- A region closed under a relation (闭): whatever a member bears the relation to is a member. -/
def «闭» (R : «际» α) (P : α → Prop) : Prop := ∀ x y, P x → R x y → P y

/-- Lying within a closure (所闭): every region closed under `R` that holds `x` holds `y`. -/
def «所闭» (R : «际» α) : «际» α := fun x y => ∀ P : α → Prop, «闭» R P → P x → P y

/-- An occurrence lies within its own closure. -/
theorem «所闭之自反» (R : «际» α) (x : α) : «所闭» R x x := fun _ _ holds => holds

/-- A closure is transitive. -/
theorem «所闭之传递» {R : «际» α} {x y z : α} (h₁ : «所闭» R x y) (h₂ : «所闭» R y z) :
    «所闭» R x z :=
  fun P closed holds => h₂ P closed (h₁ P closed holds)

/-- What `x` bears the relation to lies within its closure. -/
theorem «缘在所闭» {R : «际» α} {x y : α} (h : R x y) : «所闭» R x y :=
  fun _ closed holds => closed x y holds h

/-- An occurrence's closure is closed. -/
theorem «所闭之闭» (R : «际» α) (x : α) : «闭» R («所闭» R x) :=
  fun _ _ within related => «所闭之传递» within («缘在所闭» related)

/-- A larger relation has a larger closure. -/
theorem «所闭之单调» {R S : «际» α} (h : «则» R S) : «则» («所闭» R) («所闭» S) :=
  fun _ _ within P closed holds => within P (fun a b inside related => closed a b inside (h a b related)) holds

/-- Under a symmetric relation the closure is symmetric. -/
theorem «所闭之对称» {R : «际» α} (h : «则» R («逆» R)) : «则» («所闭» R) («逆» («所闭» R)) :=
  fun x _ within => within (fun z => «所闭» R z x)
    (fun a b back related => «所闭之传递» («缘在所闭» (h a b related)) back) («所闭之自反» R x)

/-- **The closure under the converse is the converse of the closure.** `y` lies within `x`'s closure
under the converse of `R` exactly where `x` lies within `y`'s closure under `R`. -/
theorem «所闭之逆» {R : «际» α} {x y : α} : «所闭» («逆» R) x y ↔ «所闭» R y x :=
  ⟨fun within => within (fun z => «所闭» R z x)
      (fun _ _ back related => «所闭之传递» («缘在所闭» (R := R) related) back) («所闭之自反» R x),
   fun within => within (fun z => «所闭» («逆» R) z y)
      (fun _ _ back related => «所闭之传递» («缘在所闭» (R := «逆» R) related) back)
      («所闭之自反» («逆» R) y)⟩

/-- Nothing within a closure bears the relation to what lies beyond it. Read through `«不出»`, it is
`«所闭不出»`: an occurrence's closure is not gone out of. -/
theorem «所闭之界» {R : «际» α} {x y z : α} (within : «所闭» R x y) (beyond : ¬ «所闭» R x z) :
    ¬ R y z :=
  fun related => beyond («所闭之传递» within («缘在所闭» related))

/-- Nothing in a region goes out of it along a relation (不出): no member bears the relation to
something outside. -/
def «不出» (R : «际» α) (P : α → Prop) : Prop := ∀ x y, P x → ¬ P y → ¬ R x y

/-- **A closed region is not gone out of.** -/
theorem «闭则不出» {R : «际» α} {P : α → Prop} (closed : «闭» R P) : «不出» R P :=
  fun x y inside outside related => outside (closed x y inside related)

/-- **An occurrence's closure is not gone out of**, as every closed region: nothing within it bears the
relation to what lies beyond it. It is the closure law `«所闭之界»` read through `«不出»`. -/
theorem «所闭不出» (R : «际» α) (x : α) : «不出» R («所闭» R x) :=
  fun _ _ within beyond => «所闭之界» within beyond

/-- A closed region holding `x` holds everything within `x`'s closure. -/
theorem «闭含所闭» {R : «际» α} {P : α → Prop} (closed : «闭» R P) {x y : α} (holds : P x)
    (within : «所闭» R x y) : P y :=
  within P closed holds

/-- **A certificate of a closure.** A region is `x`'s closure exactly where it holds `x`, is closed
under the relation and lies within `x`'s closure. -/
theorem «所闭之证» {R : «际» α} {P : α → Prop} {x : α} :
    (∀ y, P y ↔ «所闭» R x y) ↔ P x ∧ «闭» R P ∧ ∀ y, P y → «所闭» R x y :=
  ⟨fun exact => ⟨(exact x).mpr («所闭之自反» R x),
      fun a b inside related => (exact b).mpr («所闭之传递» ((exact a).mp inside) («缘在所闭» related)),
      fun y inside => (exact y).mp inside⟩,
   fun ⟨holds, closed, reached⟩ y => ⟨reached y, fun within => within P closed holds⟩⟩

/-- Where a closed region holds `x` but not `y`, `y` is not within `x`'s closure. -/
theorem «闭而外则不所闭» {R : «际» α} {P : α → Prop} {x y : α} (closed : «闭» R P) (holds : P x)
    (outside : ¬ P y) : ¬ «所闭» R x y :=
  fun within => outside (within P closed holds)

/-- A closed region holding `x` holds what `x` reaches. -/
theorem «闭之及» {R : «际» α} {P : α → Prop} (closed : «闭» R P) {x y : α} (holds : P x)
    (reach : «及» R x y) : P y := by
  induction reach with
  | one h => exact closed _ _ holds h
  | more h _ ih => exact ih (closed _ _ holds h)

/-- What `x` reaches lies within its closure. -/
theorem «及之所闭» {R : «际» α} : «则» («及» R) («所闭» R) :=
  fun _ _ reach _ closed holds => «闭之及» closed holds reach

/-- **The closure is what is reached.** `y` lies within `x`'s closure exactly where it is `x` or
`x` reaches it. -/
theorem «所闭当且仅当同一或及» {R : «际» α} {x y : α} : «所闭» R x y ↔ x = y ∨ «及» R x y :=
  ⟨fun within => within (fun z => x = z ∨ «及» R x z)
      (fun a b inside related => match inside with
        | .inl e => .inr (by cases e; exact .one related)
        | .inr reach => .inr («及之传递» reach (.one related)))
      (.inl rfl),
   fun reached => match reached with
    | .inl e => by cases e; exact «所闭之自反» R x
    | .inr reach => «及之所闭» x y reach⟩

/-- Reaching is a first step, then lying within the closure of where it leads. -/
theorem «及当且仅当一步而所闭» {R : «际» α} {x z : α} : «及» R x z ↔ ∃ y, R x y ∧ «所闭» R y z :=
  ⟨fun reach => match reach with
    | .one h => ⟨_, h, «所闭之自反» R _⟩
    | .more h rest => ⟨_, h, «及之所闭» _ _ rest⟩,
   fun ⟨_, h, within⟩ => match «所闭当且仅当同一或及».mp within with
    | .inl e => by cases e; exact .one h
    | .inr rest => .more h rest⟩

/-- **A closure through borrowed steps lies within two closures.** Where every step of `R'` is a step
of `R`, or a step of `R` from `a` taken at `o`, what lies within `o`'s closure under `R'` lies within
`o`'s or `a`'s closure under `R`. -/
theorem «借步之所闭在二所闭» {R R' : «际» α} {o a g : α}
    (split : ∀ x y, R' x y → R x y ∨ (x = o ∧ R a y)) (within : «所闭» R' o g) :
    «所闭» R o g ∨ «所闭» R a g :=
  within (fun z => «所闭» R o z ∨ «所闭» R a z)
    (fun x y inside related => match split x y related with
      | .inl step => match inside with
        | .inl w => .inl («所闭之传递» w («缘在所闭» step))
        | .inr w => .inr («所闭之传递» w («缘在所闭» step))
      | .inr ⟨_, step⟩ => .inr («缘在所闭» step))
    (.inl («所闭之自反» R o))

/-- **Two closures lie within the closure through borrowed steps.** Where `R` lies within `R'` and
`a` lies within `o`'s closure under `R'`, what lies within `o`'s or `a`'s closure under `R` lies
within `o`'s under `R'`. It is the converse of `«借步之所闭在二所闭»` and holds for any `R'` containing
`R`, borrowed steps being the case it is for. -/
theorem «二所闭在借步之所闭» {R R' : «际» α} {o a g : α} (larger : «则» R R')
    (reaches : «所闭» R' o a) (within : «所闭» R o g ∨ «所闭» R a g) : «所闭» R' o g :=
  match within with
  | .inl w => «所闭之单调» larger o g w
  | .inr w => «所闭之传递» reaches («所闭之单调» larger a g w)

end Closure

/-! ## Lists (helpers, stated without `simp` so that no axiom enters)

Lemmas on numbers and lists, not statements of the grammar: pigeonhole (`revisits_within`), the
list surgery that pairings need, the filters and searches the census of a step needs (`keep`,
`any_split`, `distinct_removed`), and the words that `«迭»` reads as cases of `«历»` (copies joined,
`replicate_add_append`; a word read backward, `reverse_cons_append`, proved here by induction because
the core's `List.reverse_cons` reports `propext`). `le_dest`, `ListTests.length_append`,
`ListTests.append_assoc` and `Naturals.add_congr` are the prelude's (`Becoming.Prelude`), used here,
not restated. -/

namespace GrammarLaws

variable {α : Type u}

theorem length_insert : ∀ (b₁ : List α) (y : α) (b₂ : List α),
    (b₁ ++ y :: b₂).length = (b₁ ++ b₂).length + 1
  | [], _, _ => rfl
  | _ :: b₁, y, b₂ => congrArg Nat.succ (length_insert b₁ y b₂)

theorem length_replicate (x : α) : ∀ n, (List.replicate n x).length = n
  | 0 => rfl
  | n + 1 => congrArg Nat.succ (length_replicate x n)

/-- Where two joined lists are one list with `z` at some place, `z` lies in the first or the second. -/
theorem split_append : ∀ (d₁ : List α) {d₂ e₁ e₂ : List α} {z : α},
    d₁ ++ d₂ = e₁ ++ z :: e₂ →
      (∃ f, d₁ = e₁ ++ z :: f ∧ e₂ = f ++ d₂) ∨ (∃ f, e₁ = d₁ ++ f ∧ d₂ = f ++ z :: e₂)
  | [], _, e₁, _, _, h => .inr ⟨e₁, rfl, h⟩
  | a :: d₁, d₂, [], e₂, z, h => by
    injection h with h₁ h₂
    subst h₁
    exact .inl ⟨d₁, rfl, h₂.symm⟩
  | a :: d₁, d₂, b :: e₁, e₂, z, h => by
    injection h with h₁ h₂
    subst h₁
    match split_append d₁ h₂ with
    | .inl ⟨f, hd, he⟩ => exact .inl ⟨f, congrArg (List.cons _) hd, he⟩
    | .inr ⟨f, he, hd⟩ => exact .inr ⟨f, congrArg (List.cons _) he, hd⟩

/-- A sequence that begins at `x` and goes on with `h`. -/
def prepend (x : α) (h : Nat → α) : Nat → α
  | 0 => x
  | i + 1 => h i

/-- `b + a` copies are `a` copies and then `b`. -/
theorem replicate_add_append (c : α) : ∀ (a b : Nat),
    List.replicate (b + a) c = List.replicate a c ++ List.replicate b c
  | 0, _ => rfl
  | a + 1, b => congrArg (c :: ·) (replicate_add_append c a b)

/-- `n + 1` copies are `n` copies and then one. -/
theorem replicate_succ_append (c : α) : ∀ n, List.replicate (n + 1) c = List.replicate n c ++ [c]
  | 0 => rfl
  | n + 1 => congrArg (c :: ·) (replicate_succ_append c n)

/-- Reading a list backward onto a joined list joins the second part after. -/
theorem reverseAux_append : ∀ (as r s : List α),
    List.reverseAux as (r ++ s) = List.reverseAux as r ++ s
  | [], _, _ => rfl
  | b :: as, r, s => reverseAux_append as (b :: r) s

/-- `a :: as` read backward is `as` read backward and then `a`. -/
theorem reverse_cons_append (a : α) (as : List α) : (a :: as).reverse = as.reverse ++ [a] :=
  reverseAux_append as [] [a]

/-- Copies read backward are the same copies. -/
theorem reverse_replicate (c : α) : ∀ n, (List.replicate n c).reverse = List.replicate n c
  | 0 => rfl
  | n + 1 => (reverse_cons_append c (List.replicate n c)).trans
      ((congrArg (· ++ [c]) (reverse_replicate c n)).trans (replicate_succ_append c n).symm)

/-- The units a test keeps, in order. -/
def keep (p : α → Bool) : List α → List α
  | [] => []
  | x :: l => cond (p x) (x :: keep p l) (keep p l)

theorem keep_append (p : α → Bool) : ∀ a b : List α,
    keep p (a ++ b) = keep p a ++ keep p b
  | [], _ => rfl
  | x :: a, b => by
    show cond (p x) (x :: keep p (a ++ b)) (keep p (a ++ b)) =
      cond (p x) (x :: keep p a) (keep p a) ++ keep p b
    rw [keep_append p a b]
    cases p x <;> rfl

theorem keep_congr {p q : α → Bool} : ∀ l : List α, (∀ x, x ∈ l → p x = q x) →
    keep p l = keep q l
  | [], _ => rfl
  | x :: l, same => by
    show cond (p x) (x :: keep p l) (keep p l) =
      cond (q x) (x :: keep q l) (keep q l)
    rw [same x (.head l), keep_congr l (fun y m => same y (.tail x m))]

theorem keep_all {p : α → Bool} : ∀ l : List α, (∀ x, x ∈ l → p x = true) →
    keep p l = l
  | [], _ => rfl
  | x :: l, all => by
    show cond (p x) (x :: keep p l) (keep p l) = x :: l
    rw [all x (.head l), keep_all l (fun y m => all y (.tail x m))]
    rfl

theorem mem_keep {p : α → Bool} {x : α} : ∀ {l : List α},
    x ∈ keep p l ↔ x ∈ l ∧ p x = true
  | [] => ⟨fun h => (nomatch h), fun h => (nomatch h.1)⟩
  | y :: l => by
    show x ∈ cond (p y) (y :: keep p l) (keep p l) ↔ _
    cases hy : p y with
    | true =>
      show x ∈ y :: keep p l ↔ _
      constructor
      · intro m
        cases m with
        | head => exact ⟨.head _, hy⟩
        | tail _ m' => exact ⟨.tail _ (mem_keep.mp m').1, (mem_keep.mp m').2⟩
      · intro ⟨m, px⟩
        cases m with
        | head => exact .head _
        | tail _ m' => exact .tail _ (mem_keep.mpr ⟨m', px⟩)
    | false =>
      show x ∈ keep p l ↔ _
      constructor
      · intro m
        exact ⟨.tail _ (mem_keep.mp m).1, (mem_keep.mp m).2⟩
      · intro ⟨m, px⟩
        cases m with
        | head => exact nomatch hy.symm.trans px
        | tail _ m' => exact mem_keep.mpr ⟨m', px⟩

theorem any_false_mem {p : α → Bool} : ∀ {l : List α} {x : α}, l.any p = false →
    x ∈ l → p x = false
  | h :: t, _, hn, .head _ => by
    cases hp : p h with
    | false => rfl
    | true => exact Bool.noConfusion ((congrArg (· || t.any p) hp).symm.trans hn)
  | h :: t, _, hn, .tail _ m => by
    cases hp : p h with
    | false => exact any_false_mem (l := t) ((congrArg (· || t.any p) hp).symm.trans hn) m
    | true => exact Bool.noConfusion ((congrArg (· || t.any p) hp).symm.trans hn)

theorem any_split {p : α → Bool} : ∀ {l : List α}, l.any p = true →
    ∃ a₁ y a₂, l = a₁ ++ y :: a₂ ∧ p y = true
  | [], hn => Bool.noConfusion hn
  | h :: t, hs => by
    cases hp : p h with
    | true => exact ⟨[], h, t, rfl, hp⟩
    | false =>
      match any_split (l := t) ((congrArg (· || t.any p) hp).symm.trans hs) with
      | ⟨a₁, y, a₂, e, hy⟩ => exact ⟨h :: a₁, y, a₂, e ▸ rfl, hy⟩

theorem any_remove {p : α → Bool} {f : α} (off : p f = false) (a₂ : List α) :
    ∀ a₁ : List α, (a₁ ++ f :: a₂).any p = (a₁ ++ a₂).any p
  | [] => by
    show (p f || a₂.any p) = a₂.any p
    rw [off]; rfl
  | h :: a₁ => congrArg (p h || ·) (any_remove off a₂ a₁)

theorem any_true_of_mem {p : α → Bool} : ∀ {l : List α} {x : α}, x ∈ l → p x = true →
    l.any p = true
  | h :: t, _, .head _, px => by
    show (p h || t.any p) = true
    rw [px]; rfl
  | h :: t, _, .tail _ m, px => by
    show (p h || t.any p) = true
    rw [any_true_of_mem m px]
    cases p h <;> rfl

theorem any_false_of {p : α → Bool} : ∀ l : List α, (∀ x, x ∈ l → p x = false) →
    l.any p = false
  | [], _ => rfl
  | h :: t, all => by
    show (p h || t.any p) = false
    rw [all h (.head t), any_false_of t (fun x m => all x (.tail h m))]
    rfl

theorem mem_middle (y : α) (a₂ : List α) : ∀ a₁ : List α, y ∈ a₁ ++ y :: a₂
  | [] => .head a₂
  | h :: a₁ => .tail h (mem_middle y a₂ a₁)

theorem mem_of_removed {x y : α} {a₂ : List α} : ∀ {a₁ : List α}, x ∈ a₁ ++ a₂ →
    x ∈ a₁ ++ y :: a₂
  | [], m => .tail y m
  | h :: a₁, m => by
    cases m with
    | head => exact .head _
    | tail _ m => exact .tail h (mem_of_removed m)

theorem distinct_removed {y : α} {a₂ : List α} : ∀ {a₁ : List α},
    Distinct (a₁ ++ y :: a₂) → Distinct (a₁ ++ a₂) ∧ ¬ y ∈ a₁ ++ a₂
  | [], d => ⟨d.2, d.1⟩
  | h :: a₁, d =>
    have rest := distinct_removed (a₁ := a₁) d.2
    ⟨⟨fun m => d.1 (mem_of_removed m), rest.1⟩, fun m => by
      cases m with
      | head => exact d.1 (mem_middle _ a₂ a₁)
      | tail _ m => exact rest.2 m⟩

end GrammarLaws

/-! ## Balance (对): a one-to-one pairing conserves count -/

section Balance

variable {α : Type u}

/-- A perfect pairing of the places of two finite lists under `R` (对): the head of the first is
paired with some place of the second, related to it by `R`, and the rest are so paired. It is a
matching under any relation, not continuation (`«续»`): `R` may be any relation of the grammar, and
under the one (`«一»`) a pairing is equal count. -/
inductive «对» (R : «际» α) : List α → List α → Prop
  | nil : «对» R [] []
  | cons {x y : α} {a b₁ b₂ : List α} : R x y → «对» R a (b₁ ++ b₂) → «对» R (x :: a) (b₁ ++ y :: b₂)

/-- **A one-to-one pairing conserves count.** -/
theorem «对之长» {R : «际» α} {a b : List α} (h : «对» R a b) : a.length = b.length := by
  induction h with
  | nil => rfl
  | @cons _ y _ b₁ b₂ _ _ ih => exact (congrArg Nat.succ ih).trans (GrammarLaws.length_insert b₁ y b₂).symm

/-- A list paired one to one with a single entry is a single entry related to it. -/
theorem GrammarLaws.paired_single {S : «际» α} {x : α} {a b : List α} (paired : «对» S a b)
    (single : a = [x]) : ∃ y, S x y ∧ b = [y] := by
  cases paired with
  | nil => exact nomatch single
  | @cons _ y _ b₁ b₂ related rest =>
    cases single
    cases b₁ with
    | nil =>
      cases b₂ with
      | nil => exact ⟨y, related, rfl⟩
      | cons _ _ => exact Nat.noConfusion («对之长» rest)
    | cons _ _ => exact Nat.noConfusion («对之长» rest)

/-- Lists of equal length are paired one to one under the one. -/
theorem «等长则一对» : ∀ (a b : List α), a.length = b.length → «对» «一» a b
  | [], [], _ => .nil
  | [], _ :: _, e => Nat.noConfusion e
  | _ :: _, [], e => Nat.noConfusion e
  | _ :: a, _ :: b, e => .cons (b₁ := []) trivial («等长则一对» a b (Nat.succ.inj e))

/-- **Under the one, a one-to-one pairing is exactly equal count.** -/
theorem «一之对» {a b : List α} : «对» «一» a b ↔ a.length = b.length :=
  ⟨«对之长», «等长则一对» a b⟩

/-- A larger relation pairs whatever a smaller one pairs. -/
theorem «对之单调» {R S : «际» α} (h : «则» R S) {a b : List α} (m : «对» R a b) : «对» S a b := by
  induction m with
  | nil => exact .nil
  | cons r _ ih => exact .cons (h _ _ r) ih

/-- Under a reflexive relation every list is paired with itself. -/
theorem «对之自反» {R : «际» α} (refl : ∀ x, R x x) : ∀ a : List α, «对» R a a
  | [] => .nil
  | x :: a => .cons (b₁ := []) (refl x) («对之自反» refl a)

/-- A pair can be put at any place of the first list. -/
theorem «对之左插» {S : «际» α} {y x : α} (r : S y x) :
    ∀ (l₁ : List α) {l₂ m : List α}, «对» S (l₁ ++ l₂) m → «对» S (l₁ ++ y :: l₂) (x :: m)
  | [], _, _, h => .cons (b₁ := []) r h
  | _ :: l₁, _, _, h => match h with
    | .cons (b₁ := m₁) rz rest => .cons (b₁ := x :: m₁) rz («对之左插» r l₁ rest)

/-- **A one-to-one pairing read backward is one** under the converse. -/
theorem «对之逆» {R : «际» α} {a b : List α} (h : «对» R a b) : «对» («逆» R) b a := by
  induction h with
  | nil => exact .nil
  | @cons x y _ b₁ _ r _ ih => exact «对之左插» (S := «逆» R) (y := y) (x := x) r b₁ ih

/-- **The balance reading.** What comes in (before, given), paired one to one with what goes on
(after, taken), has as many after and taken as before and given. -/
theorem «对则守数» {R : «际» α} {before given after taken : List α}
    (h : «对» R (before ++ given) (after ++ taken)) :
    after.length + taken.length = before.length + given.length :=
  (ListTests.length_append after taken).symm.trans
    ((«对之长» h).symm.trans (ListTests.length_append before given))

/-- **And every four numbers with that equation are realized**: four lists of units with those
lengths, the first two paired one to one, under the one, with the last two. -/
theorem «守数当且仅当可对» {p q r s : Nat} :
    r + s = p + q ↔ ∃ before given after taken : List Unit,
      before.length = p ∧ given.length = q ∧ after.length = r ∧ taken.length = s ∧
        «对» «一» (before ++ given) (after ++ taken) :=
  ⟨fun e => ⟨List.replicate p (), List.replicate q (), List.replicate r (), List.replicate s (),
      GrammarLaws.length_replicate () p, GrammarLaws.length_replicate () q,
      GrammarLaws.length_replicate () r, GrammarLaws.length_replicate () s,
      «一之对».mpr ((ListTests.length_append _ _).trans
        ((Naturals.add_congr (GrammarLaws.length_replicate () p) (GrammarLaws.length_replicate () q)).trans
          (e.symm.trans ((Naturals.add_congr (GrammarLaws.length_replicate () r)
            (GrammarLaws.length_replicate () s)).symm.trans (ListTests.length_append _ _).symm))))⟩,
   fun ⟨_, _, _, _, hb, hg, ha, ht, h⟩ => by
     have conserved := «对则守数» h
     subst hb hg ha ht
     exact conserved⟩

/-- **Equal count without a pairing**: under the empty relation two one-place lists have one length
and no pairing. So for an arbitrary relation a pairing gives equal count and not conversely. -/
theorem «等长而不对之例» : ∃ (R : «际» Unit) (a b : List Unit), a.length = b.length ∧ ¬ «对» R a b :=
  have empty : ∀ {a b : List Unit}, «对» (fun _ _ => False) a b → a = [] := fun h => by
    induction h with
    | nil => rfl
    | cons r _ _ => exact r.elim
  ⟨fun _ _ => False, [()], [()], rfl, fun h => nomatch empty h⟩

/-- A pairing with `y` at some place of the first list pairs `y` with some place of the second, and
the rest with the rest. -/
theorem «对之取» {S : «际» α} {l c : List α} (h : «对» S l c) :
    ∀ (b₁ : List α) {y : α} {b₂ : List α}, l = b₁ ++ y :: b₂ →
      ∃ c₁ z c₂, c = c₁ ++ z :: c₂ ∧ S y z ∧ «对» S (b₁ ++ b₂) (c₁ ++ c₂) := by
  induction h with
  | nil =>
    intro b₁ y b₂ e
    cases b₁ with
    | nil => cases e
    | cons _ _ => cases e
  | @cons x v a d₁ d₂ r rest ih =>
    intro b₁ y b₂ e
    cases b₁ with
    | nil =>
      injection e with e₁ e₂
      subst e₁
      subst e₂
      exact ⟨d₁, v, d₂, rfl, r, rest⟩
    | cons w b₁' =>
      injection e with e₁ e₂
      subst e₁
      obtain ⟨e₁', z, e₂', same, s, m⟩ := ih b₁' e₂
      cases GrammarLaws.split_append d₁ same with
      | inl hf =>
        obtain ⟨f, hd, he⟩ := hf
        subst hd
        subst he
        refine ⟨e₁', z, f ++ v :: d₂, ListTests.append_assoc e₁' (z :: f) (v :: d₂), s, ?_⟩
        have m' : «对» S (b₁' ++ b₂) ((e₁' ++ f) ++ d₂) :=
          Eq.subst (motive := fun l => «对» S (b₁' ++ b₂) l) (ListTests.append_assoc e₁' f d₂).symm m
        exact Eq.subst (motive := fun l => «对» S (x :: (b₁' ++ b₂)) l)
          (ListTests.append_assoc e₁' f (v :: d₂)) («对».cons (b₁ := e₁' ++ f) (b₂ := d₂) r m')
      | inr hf =>
        obtain ⟨f, he, hd⟩ := hf
        subst he
        subst hd
        refine ⟨d₁ ++ v :: f, z, e₂', (ListTests.append_assoc d₁ (v :: f) (z :: e₂')).symm, s, ?_⟩
        have m' : «对» S (b₁' ++ b₂) (d₁ ++ (f ++ e₂')) :=
          Eq.subst (motive := fun l => «对» S (b₁' ++ b₂) l) (ListTests.append_assoc d₁ f e₂') m
        exact Eq.subst (motive := fun l => «对» S (x :: (b₁' ++ b₂)) l)
          (ListTests.append_assoc d₁ (v :: f) e₂').symm («对».cons (b₁ := d₁) (b₂ := f ++ e₂') r m')

/-- **One-to-one pairings compose**: a pairing of `a` with `b` under `R` and of `b` with `c` under
`S` give one of `a` with `c` under `R` then `S` (`«而» R S`). -/
theorem «对之接» {R S : «际» α} {a b : List α} (h : «对» R a b) :
    ∀ {c : List α}, «对» S b c → «对» («而» R S) a c := by
  induction h with
  | nil =>
    intro c h'
    cases h'
    exact .nil
  | @cons x y a b₁ b₂ r rest ih =>
    intro c h'
    obtain ⟨c₁, z, c₂, e, s, m⟩ := «对之取» h' b₁ rfl
    subst e
    exact .cons ⟨y, r, s⟩ (ih m)

/-- Under a transitive relation, pairings compose under the relation itself. -/
theorem «对之传» {T : «际» α} (trans : ∀ x y z, T x y → T y z → T x z) {a b c : List α}
    (h : «对» T a b) (h' : «对» T b c) : «对» T a c :=
  «对之单调» (fun _ _ ⟨_, first, second⟩ => trans _ _ _ first second) («对之接» h h')

/-- **One-to-one pairings join**: pairings of `a₁` with `b₁` and of `a₂` with `b₂` give one of the
joined lists. -/
theorem «对之并» {R : «际» α} {a₁ b₁ : List α} (h₁ : «对» R a₁ b₁) :
    ∀ {a₂ b₂ : List α}, «对» R a₂ b₂ → «对» R (a₁ ++ a₂) (b₁ ++ b₂) := by
  induction h₁ with
  | nil => intro a₂ b₂ h₂; exact h₂
  | @cons x y a c₁ c₂ r rest ih =>
    intro a₂ b₂ h₂
    have m : «对» R (a ++ a₂) (c₁ ++ (c₂ ++ b₂)) :=
      Eq.subst (motive := fun l => «对» R (a ++ a₂) l) (ListTests.append_assoc c₁ c₂ b₂) (ih h₂)
    exact Eq.subst (motive := fun l => «对» R (x :: (a ++ a₂)) l)
      (ListTests.append_assoc c₁ (y :: c₂) b₂).symm («对».cons (b₁ := c₁) (b₂ := c₂ ++ b₂) r m)

/-- Under a reflexive relation, two joined lists are paired with the same lists joined the other way
round. -/
theorem «对之换» {R : «际» α} (refl : ∀ x, R x x) : ∀ (a b : List α), «对» R (a ++ b) (b ++ a)
  | [], b => Eq.subst (motive := fun l => «对» R b l) (ListTests.append_nil b).symm («对之自反» refl b)
  | x :: a, b => «对».cons (b₁ := b) (b₂ := a) (refl x) («对之换» refl a b)

/-- Lists gathered along a list of indices (聚): the list of each index in turn, joined. -/
def «聚» {ι : Type v} (f : ι → List α) : List ι → List α
  | [] => []
  | i :: is => f i ++ «聚» f is

/-- The units of a quantity on a list, gathered by `«聚»`: each listed item repeated as often as the
quantity there, in order. -/
def unitsOn (q : α → Nat) : List α → List α :=
  «聚» fun x => List.replicate (q x) x

/-- **Balance over a family**: pairings at every listed index give one of the gathered lists. -/
theorem «对之族» {ι : Type v} {R : «际» α} {a b : ι → List α} :
    ∀ (is : List ι), (∀ i, i ∈ is → «对» R (a i) (b i)) → «对» R («聚» a is) («聚» b is)
  | [], _ => .nil
  | i :: is, each => «对之并» (each i (.head is)) («对之族» is fun j mem => each j (.tail i mem))

/-- **Balance over a stretch**: where, at each step of a stretch, what stands before with what is
given is paired under `R` with what stands after with what is taken, what stands before the
stretch with everything given along it is paired, under the closure of `R` (`«所闭» R`), with what
stands after it with everything taken along it. A unit that stays several steps is paired through
several steps of `R`, so the stretch's relation is the closure. -/
theorem «对之程» {R : «际» α} {L G K : Nat → List α} :
    ∀ (S n : Nat), (∀ t, S ≤ t → t < S + n → «对» R (L t ++ G t) (L (t + 1) ++ K t)) →
      «对» («所闭» R) (L S ++ «聚» G (steps S n)) (L (S + n) ++ «聚» K (steps S n))
  | S, 0, _ => «对之自反» («所闭之自反» R) _
  | S, n + 1, across => by
    have refl : ∀ x, «所闭» R x x := «所闭之自反» R
    have trans : ∀ x y z, «所闭» R x y → «所闭» R y z → «所闭» R x z := fun _ _ _ h h' => «所闭之传递» h h'
    have first : «对» («所闭» R) (L S ++ G S) (L (S + 1) ++ K S) :=
      «对之单调» (fun _ _ r => «缘在所闭» r)
        (across S (Nat.le_refl S) (Nat.lt_add_of_pos_right (Nat.succ_pos n)))
    have rest : «对» («所闭» R) (L (S + 1) ++ «聚» G (steps (S + 1) n))
        (L (S + 1 + n) ++ «聚» K (steps (S + 1) n)) :=
      «对之程» (S + 1) n fun t from_ below => across t (Nat.le_of_succ_le from_)
        (Nat.lt_of_lt_of_le below (Nat.le_of_eq (Nat.add_right_comm S 1 n)))
    have a : «对» («所闭» R) (L S ++ (G S ++ «聚» G (steps (S + 1) n)))
        (L (S + 1) ++ (K S ++ «聚» G (steps (S + 1) n))) := by
      rw [← ListTests.append_assoc, ← ListTests.append_assoc]
      exact «对之并» first («对之自反» refl _)
    have b : «对» («所闭» R) (L (S + 1) ++ (K S ++ «聚» G (steps (S + 1) n)))
        ((L (S + 1) ++ «聚» G (steps (S + 1) n)) ++ K S) := by
      rw [ListTests.append_assoc]
      exact «对之并» («对之自反» refl _) («对之换» refl _ _)
    have c : «对» («所闭» R) ((L (S + 1) ++ «聚» G (steps (S + 1) n)) ++ K S)
        (L (S + 1 + n) ++ (K S ++ «聚» K (steps (S + 1) n))) := by
      have d := «对之并» rest («对之自反» refl (K S))
      have d' : «对» («所闭» R) ((L (S + 1) ++ «聚» G (steps (S + 1) n)) ++ K S)
          (L (S + 1 + n) ++ («聚» K (steps (S + 1) n) ++ K S)) :=
        Eq.subst (motive := fun l => «对» («所闭» R) ((L (S + 1) ++ «聚» G (steps (S + 1) n)) ++ K S) l)
          (ListTests.append_assoc _ _ _) d
      exact «对之传» trans d' («对之并» («对之自反» refl _) («对之换» refl _ _))
    have e : S + 1 + n = S + (n + 1) := Nat.add_right_comm S 1 n
    rw [e] at c
    exact «对之传» trans a («对之传» trans b c)

/-- The length of gathered lists is the total of their lengths. -/
theorem «聚之长» {ι : Type} (f : ι → List α) : ∀ is : List ι,
    («聚» f is).length = total is fun i => (f i).length
  | [] => rfl
  | i :: is => (ListTests.length_append _ _).trans (congrArg ((f i).length + ·) («聚之长» f is))

/-- **The count law over a stretch is pairing over the stretch**, both ways: a count that, at the
end of a stretch with everything lost along it, is the count at its start with everything gained
(`balance_over_stretch_on`'s conclusion) is exactly one whose units, before with those gained,
are paired under the one with its units after with those lost. An exact cardinality
representation: the pairing is built from the numbers. -/
theorem «程守数当且仅当可对» {q x y : Nat → Nat} {S n : Nat} :
    q (S + n) + total (steps S n) x = q S + total (steps S n) y ↔
      ∃ (level lost gained : Nat → List Unit),
        (∀ t, (level t).length = q t) ∧ (∀ t, (lost t).length = x t) ∧
          (∀ t, (gained t).length = y t) ∧
            «对» «一» (level S ++ «聚» gained (steps S n)) (level (S + n) ++ «聚» lost (steps S n)) :=
  have lengths : ∀ (level lost gained : Nat → List Unit), (∀ t, (level t).length = q t) →
      (∀ t, (lost t).length = x t) → (∀ t, (gained t).length = y t) →
        (level S ++ «聚» gained (steps S n)).length = q S + total (steps S n) y ∧
          (level (S + n) ++ «聚» lost (steps S n)).length = q (S + n) + total (steps S n) x :=
    fun _ lost gained hl hx hy =>
      ⟨(ListTests.length_append _ _).trans (Naturals.add_congr (hl S)
          ((«聚之长» gained _).trans (total_congr hy _))),
       (ListTests.length_append _ _).trans (Naturals.add_congr (hl (S + n))
          ((«聚之长» lost _).trans (total_congr hx _)))⟩
  ⟨fun e => ⟨fun t => List.replicate (q t) (), fun t => List.replicate (x t) (),
      fun t => List.replicate (y t) (), fun _ => GrammarLaws.length_replicate () _,
      fun _ => GrammarLaws.length_replicate () _, fun _ => GrammarLaws.length_replicate () _,
      «一之对».mpr (match lengths _ _ _ (fun _ => GrammarLaws.length_replicate () _)
        (fun _ => GrammarLaws.length_replicate () _) (fun _ => GrammarLaws.length_replicate () _) with
        | ⟨before, after⟩ => before.trans (e.symm.trans after.symm))⟩,
   fun ⟨level, lost, gained, hl, hx, hy, h⟩ => match lengths level lost gained hl hx hy with
    | ⟨before, after⟩ => after.symm.trans ((«对之长» h).symm.trans before)⟩

/-! ### Counting (计): the count on a region, and the count law of a class

A region is read here as a test, `α → Bool`, so that a count is a function of the list. That is a
modelling choice: a region given as a proposition enters by `decide` where it is decidable. `«计»` is
the structural twin of Lean's `List.countP` (`GrammarLaws.count_eq_countP`); Init's own lemmas on
`List.countP` (`countP_cons`, `countP_append`) report `propext`, so the grammar keeps its own. -/

/-- How many units of a list a test holds of (计). A region enters as a test (`α → Bool`), a
modelling choice; a region given as a proposition enters by `decide`. -/
def «计» (p : α → Bool) : List α → Nat
  | [] => 0
  | x :: a => cond (p x) 1 0 + «计» p a

/-- A test counts two lists joined as the sum of its counts of each. -/
theorem GrammarLaws.count_append (p : α → Bool) (l₂ : List α) :
    ∀ l₁ : List α, «计» p (l₁ ++ l₂) = «计» p l₁ + «计» p l₂
  | [] => (Nat.zero_add _).symm
  | x :: l₁ => (congrArg (cond (p x) 1 0 + ·) (GrammarLaws.count_append p l₂ l₁)).trans
      (Nat.add_assoc _ _ _).symm

/-- A test holding at a unit counts each entry of it repeated. -/
theorem GrammarLaws.count_replicate_true {p : α → Bool} {x : α} (holds : p x = true) :
    ∀ n, «计» p (List.replicate n x) = n
  | 0 => rfl
  | n + 1 => (congrArg (cond (p x) 1 0 + ·) (GrammarLaws.count_replicate_true holds n)).trans
      ((congrArg (fun b => cond b 1 0 + n) holds).trans (Nat.add_comm 1 n))

/-- A test failing at a unit counts no entry of it repeated. -/
theorem GrammarLaws.count_replicate_false {p : α → Bool} {x : α} (fails : p x = false) :
    ∀ n, «计» p (List.replicate n x) = 0
  | 0 => rfl
  | n + 1 => (congrArg (cond (p x) 1 0 + ·) (GrammarLaws.count_replicate_false fails n)).trans
      ((congrArg (fun b => cond b 1 0 + 0) fails).trans (Nat.add_zero 0))

theorem GrammarLaws.count_insert (p : α → Bool) (y : α) : ∀ b₁ b₂ : List α,
    «计» p (b₁ ++ y :: b₂) = cond (p y) 1 0 + «计» p (b₁ ++ b₂)
  | [], _ => rfl
  | z :: b₁, b₂ => by
    show cond (p z) 1 0 + «计» p (b₁ ++ y :: b₂) = cond (p y) 1 0 + (cond (p z) 1 0 + «计» p (b₁ ++ b₂))
    rw [GrammarLaws.count_insert p y b₁ b₂, Nat.add_left_comm]

/-- Where a test holds of some unit, the list splits at one it holds of. -/
theorem GrammarLaws.split_of_count_pos {p : α → Bool} : ∀ {b : List α}, 0 < «计» p b →
    ∃ b₁ y b₂, b = b₁ ++ y :: b₂ ∧ p y = true
  | [], pos => absurd pos (Nat.lt_irrefl 0)
  | y :: b, pos => by
    cases hy : p y with
    | true => exact ⟨[], y, b, rfl, hy⟩
    | false =>
      have rest : 0 < «计» p b := by
        have e : «计» p (y :: b) = «计» p b := by
          show cond (p y) 1 0 + «计» p b = «计» p b
          rw [hy]; exact Nat.zero_add _
        exact e ▸ pos
      match GrammarLaws.split_of_count_pos rest with
      | ⟨b₁, z, b₂, e, hz⟩ => exact ⟨y :: b₁, z, b₂, e ▸ rfl, hz⟩

theorem GrammarLaws.count_go (p : α → Bool) : ∀ (l : List α) (acc : Nat),
    List.countP.go p l acc = acc + «计» p l
  | [], _ => rfl
  | x :: l, acc => by
    show (bif p x then List.countP.go p l (acc + 1) else List.countP.go p l acc) =
      acc + (cond (p x) 1 0 + «计» p l)
    cases p x with
    | true =>
      show List.countP.go p l (acc + 1) = acc + (1 + «计» p l)
      rw [GrammarLaws.count_go p l (acc + 1), Nat.add_assoc]
    | false =>
      show List.countP.go p l acc = acc + (0 + «计» p l)
      rw [GrammarLaws.count_go p l acc, Nat.zero_add]

/-- **`«计»` is Lean's `List.countP`.** A structural twin, proved equal with no axiom. -/
theorem GrammarLaws.count_eq_countP (p : α → Bool) (l : List α) : «计» p l = l.countP p := by
  show «计» p l = List.countP.go p l 0
  rw [GrammarLaws.count_go p l 0, Nat.zero_add]

/-- A region read as a test, closed under a relation and its converse, is one the relation never
crosses: related units lie both in it or both outside it. -/
theorem GrammarLaws.uncrossed_of_closed {R : «际» α} {p : α → Bool}
    (forward : «闭» R (fun x => p x = true)) (backward : «闭» («逆» R) (fun x => p x = true)) :
    ∀ x y, R x y → p x = p y := fun x y r => by
  cases hx : p x <;> cases hy : p y
  · rfl
  · exact Bool.noConfusion (hx.symm.trans (backward y x hy r))
  · exact Bool.noConfusion (hy.symm.trans (forward x y hx r))
  · rfl

/-- **A region the relation does not cross is one not gone out of either way.** Related units lie
both in a region read as a test or both outside it exactly where nothing in it bears the relation to
something outside it and nothing outside it bears the relation to something in it. -/
theorem GrammarLaws.uncrossed_iff_notGoingOut {R : «际» α} {p : α → Bool} :
    (∀ x y, R x y → p x = p y) ↔
      «不出» R (fun x => p x = true) ∧ «不出» («逆» R) (fun x => p x = true) :=
  ⟨fun uncrossed =>
    ⟨fun x y inside outside related => outside ((uncrossed x y related).symm.trans inside),
     fun x y inside outside related => outside ((uncrossed y x related).trans inside)⟩,
   fun ⟨forward, backward⟩ x y related => by
    cases hx : p x <;> cases hy : p y
    · rfl
    · exact (backward y x hy (fun inside => Bool.noConfusion (hx.symm.trans inside)) related).elim
    · exact (forward x y hx (fun inside => Bool.noConfusion (hy.symm.trans inside)) related).elim
    · rfl⟩

/-- **A region the relation does not cross is one closed under it and under its converse.** The
converse of `GrammarLaws.uncrossed_of_closed`. -/
theorem GrammarLaws.uncrossed_iff_closed {R : «际» α} {p : α → Bool} :
    (∀ x y, R x y → p x = p y) ↔
      «闭» R (fun x => p x = true) ∧ «闭» («逆» R) (fun x => p x = true) :=
  ⟨fun uncrossed =>
    ⟨fun x y inside related => (uncrossed x y related).symm.trans inside,
     fun x y inside related => (uncrossed y x related).trans inside⟩,
   fun ⟨forward, backward⟩ => GrammarLaws.uncrossed_of_closed forward backward⟩

/-- **A pairing keeps the count on every region the relation does not cross.** Each pair lies both
in the region or both outside it. A region not crossed is one not gone out of either way
(`GrammarLaws.uncrossed_iff_notGoingOut`) and one closed both ways (`GrammarLaws.uncrossed_iff_closed`),
so this law and `«对则双闭域守数»` read as one law on regions not gone out of either way. -/
theorem «对则不越域守数» {R : «际» α} {p : α → Bool} (uncrossed : ∀ x y, R x y → p x = p y)
    {a b : List α} (h : «对» R a b) : «计» p a = «计» p b := by
  induction h with
  | nil => rfl
  | @cons x y a b₁ b₂ r _ ih =>
    show cond (p x) 1 0 + «计» p a = «计» p (b₁ ++ y :: b₂)
    rw [GrammarLaws.count_insert, uncrossed x y r, ih]

/-- **A pairing keeps the count on every region closed both ways**: closed under the relation and
under its converse, which is not being crossed by it (`GrammarLaws.uncrossed_iff_closed`), so this law
and `«对则不越域守数»` read as one law on regions not gone out of either way. Closed one way is not
enough (`«对而单闭域不守数之例»`). -/
theorem «对则双闭域守数» {R : «际» α} {p : α → Bool}
    (forward : «闭» R (fun x => p x = true)) (backward : «闭» («逆» R) (fun x => p x = true))
    {a b : List α} (h : «对» R a b) : «计» p a = «计» p b :=
  «对则不越域守数» (GrammarLaws.uncrossed_of_closed forward backward) h

/-- **A region closed one way, and the count not kept**, the scope of `«对则双闭域守数»`. Under one
step from `0` to `1`, the region holding `1` alone is closed (nothing it holds bears the step
beyond it), and the pairing of `[0]` with `[1]` counts none of it before and one after. -/
theorem «对而单闭域不守数之例» :
    «闭» (fun x y : Nat => x = 0 ∧ y = 1) (fun x => Nat.beq 1 x = true) ∧
    «对» (fun x y : Nat => x = 0 ∧ y = 1) [0] [1] ∧
    «计» (Nat.beq 1) [0] ≠ «计» (Nat.beq 1) [1] :=
  ⟨fun _ _ _ step => (congrArg (Nat.beq 1) step.2).trans rfl, .cons (b₁ := []) ⟨rfl, rfl⟩ .nil, fun h => Nat.noConfusion h⟩

section CountOfClass

variable {E : «际» α} {e : α → α → Bool}

/-- Related units are counted alike by every class's test. -/
theorem GrammarLaws.class_test_congr (cls : «类» E) (dec : ∀ x y, E x y ↔ e x y = true) {x y : α}
    (r : E x y) (z : α) : e z x = e z y := by
  cases hx : e z x <;> cases hy : e z y
  · rfl
  · exact Bool.noConfusion (hx.symm.trans ((dec z x).mp (cls.trans ((dec z y).mpr hy) (cls.symm r))))
  · exact Bool.noConfusion (hy.symm.trans ((dec z y).mp (cls.trans ((dec z x).mpr hx) r)))
  · rfl

/-- Equal count in every class gives a pairing under the class. -/
theorem GrammarLaws.pair_of_class_counts (cls : «类» E) (dec : ∀ x y, E x y ↔ e x y = true) :
    ∀ (a b : List α), (∀ z, «计» (e z) a = «计» (e z) b) → «对» E a b
  | [], [], _ => .nil
  | [], y :: b, counts => by
    have hy : «计» (e y) (y :: b) = 1 + «计» (e y) b :=
      congrArg (fun v => cond v 1 0 + «计» (e y) b) ((dec y y).mp (cls.refl y))
    have zero : «计» (e y) (y :: b) = 0 := (counts y).symm
    exact Nat.noConfusion ((zero.symm.trans hy).trans (Nat.add_comm 1 _))
  | x :: a, b, counts => by
    have pos : 0 < «计» (e x) b := by
      have hx : «计» (e x) (x :: a) = 1 + «计» (e x) a :=
        congrArg (fun v => cond v 1 0 + «计» (e x) a) ((dec x x).mp (cls.refl x))
      have more : «计» (e x) b = «计» (e x) a + 1 :=
        (counts x).symm.trans (hx.trans (Nat.add_comm 1 _))
      rw [more]
      exact Nat.succ_pos _
    match GrammarLaws.split_of_count_pos pos with
    | ⟨b₁, y, b₂, e₁, hy⟩ =>
      cases e₁
      have r : E x y := (dec x y).mpr hy
      refine .cons r (GrammarLaws.pair_of_class_counts cls dec a (b₁ ++ b₂) fun z => ?_)
      have h : cond (e z x) 1 0 + «计» (e z) a = cond (e z y) 1 0 + «计» (e z) (b₁ ++ b₂) :=
        (counts z).trans (GrammarLaws.count_insert (e z) y b₁ b₂)
      rw [GrammarLaws.class_test_congr cls dec r z] at h
      exact Naturals.add_left_cancel h

/-- **The count law of a class.** Under a class decided by a test, two lists are paired one to one
exactly where every class holds as many units of the one as of the other. The class does work:
two lists of one unit each, at different places, are paired under the whole relation `«一»` (one
class) and not under sameness `«静»` (a class for each place), `«一对而静不对之例»`. -/
theorem «类之对当且仅当类类等数» (cls : «类» E) (dec : ∀ x y, E x y ↔ e x y = true)
    {a b : List α} : «对» E a b ↔ ∀ z, «计» (e z) a = «计» (e z) b :=
  ⟨fun h z => «对则不越域守数» (p := e z) (fun _ _ r => GrammarLaws.class_test_congr cls dec r z) h,
   GrammarLaws.pair_of_class_counts cls dec a b⟩

end CountOfClass

/-- **What a pairing under continuation adds to equal count.** Where `E` is a class decided by the
test `e`, continuation relative to it lies within it, so a pairing under continuation keeps the
count by `e` in every class. -/
theorem «续之对则类类等数» {R E : «际» α} {e : α → α → Bool} (cls : «类» E)
    (dec : ∀ x y, E x y ↔ e x y = true) {a b : List α} (h : «对» («续» R E) a b) (z : α) :
    «计» (e z) a = «计» (e z) b :=
  («类之对当且仅当类类等数» cls dec).mp («对之单调» (fun _ _ (both : R _ _ ∧ E _ _) => both.2) h) z

/-- **Equal count, and no pairing under sameness**, the scope of `«类之对当且仅当类类等数»`: which
class does work. A unit at one place before and at another after is paired under the one, since
the counts are equal, and not under sameness, since the first place holds one unit before and
none after. -/
theorem «一对而静不对之例» : «对» «一» [0] [1] ∧ ¬ «对» («静» : «际» Nat) [0] [1] :=
  ⟨«等长则一对» [0] [1] rfl, fun h =>
    Nat.noConfusion («对则不越域守数» (p := Nat.beq 0) (fun x y (same : x = y) => congrArg (Nat.beq 0) same) h)⟩

end Balance

/-! ## Finite runs (入) -/

section Runs

variable {α : Type u}

/-- The successor is fixed (定后): `R˘;R ⊆ 静`. -/
def «定后» (R : «际» α) : Prop := «则» («而» («逆» R) R) «静»

/-- The predecessor is fixed (定前), nothing merged: `R;R˘ ⊆ 静`. -/
def «定前» (R : «际» α) : Prop := «则» («而» R («逆» R)) «静»

theorem «定后之逐点» {R : «际» α} : «定后» R ↔ ∀ x y z, R x y → R x z → y = z :=
  ⟨fun h x y z r r' => h y z ⟨x, r, r'⟩, fun h y z ⟨x, r, r'⟩ => h x y z r r'⟩

theorem «定前之逐点» {R : «际» α} : «定前» R ↔ ∀ x y z, R x z → R y z → x = y :=
  ⟨fun h x y z r r' => h x y ⟨z, r, r'⟩, fun h x y ⟨z, r, r'⟩ => h x y z r r'⟩

/-- Nothing merged is a fixed successor read backward. -/
theorem «定前即逆之定后» {R : «际» α} : «定前» R ↔ «定后» («逆» R) :=
  ⟨fun h y z ⟨x, r, r'⟩ => h y z ⟨x, r, r'⟩, fun h x y ⟨z, r, r'⟩ => h x y ⟨z, r, r'⟩⟩

/-- **Passing through a word's relations in turn (历); `«迭»` is its case for one relation repeated**
(`«迭即历»`).
On the empty word it is no step (`«静»`); on `a :: as` it is the relation of `a` and then passing
through `as` (`«而»`). -/
def «历» {A : Type v} (F : A → «际» α) : List A → «际» α
  | [] => «静»
  | a :: as => «而» (F a) («历» F as)

/-- **Passing through two words is passing through the first and then the second (历之接).** -/
theorem «历之接» {A : Type v} (F : A → «际» α) : ∀ (as bs : List A) {x z : α},
    «历» F (as ++ bs) x z ↔ «而» («历» F as) («历» F bs) x z
  | [], bs, x, z => ⟨fun h => ⟨x, rfl, h⟩,
      fun ⟨_, e, h⟩ => Eq.subst (motive := fun w => «历» F bs w z) e.symm h⟩
  | _ :: as, bs, _, _ => ⟨fun ⟨m, r, rest⟩ => match («历之接» F as bs).mp rest with
      | ⟨y, first, second⟩ => ⟨y, ⟨m, r, first⟩, second⟩,
    fun ⟨y, ⟨m, r, first⟩, second⟩ => ⟨m, r, («历之接» F as bs).mpr ⟨y, first, second⟩⟩⟩

/-- **The last letter is passed through last (历之末步).** -/
theorem «历之末步» {A : Type v} (F : A → «际» α) (as : List A) (a : A) {x z : α} :
    «历» F (as ++ [a]) x z ↔ ∃ y, «历» F as x y ∧ F a y z :=
  («历之接» F as [a]).trans
    ⟨fun ⟨y, first, ⟨_, r, e⟩⟩ => ⟨y, first, Eq.subst (motive := fun v => F a y v) e r⟩,
     fun ⟨y, first, r⟩ => ⟨y, first, ⟨z, r, rfl⟩⟩⟩

/-- **Passing through the reversed word by the converse relations is passing through the word
backward (历之逆).** -/
theorem «历之逆» {A : Type v} (F : A → «际» α) : ∀ (as : List A) {x y : α},
    «历» (fun a => «逆» (F a)) as.reverse x y ↔ «历» F as y x
  | [], _, _ => ⟨Eq.symm, Eq.symm⟩
  | a :: as, x, y =>
    (Iff.of_eq (congrArg (fun l => «历» (fun a => «逆» (F a)) l x y)
        (GrammarLaws.reverse_cons_append a as))).trans
      ((«历之末步» _ as.reverse a).trans
        ⟨fun ⟨m, first, r⟩ => ⟨m, r, («历之逆» F as).mp first⟩,
         fun ⟨m, r, rest⟩ => ⟨m, («历之逆» F as).mpr rest, r⟩⟩)

/-- **Where no letter's relation merges, passing through the word merges nothing (历之定前).** -/
theorem «历之定前» {A : Type v} {F : A → «际» α} (merges : ∀ a, «定前» (F a)) :
    ∀ (as : List A) {x y z : α}, «历» F as x z → «历» F as y z → x = y
  | [], _, _, _, e₁, e₂ => e₁.trans e₂.symm
  | a :: as, x, y, _, ⟨w, r, first⟩, ⟨w', r', second⟩ => by
    have e : w = w' := «历之定前» merges as first second
    subst e
    exact merges a x y ⟨w, r, r'⟩

/-- `n` steps (迭): the `n`-fold composition of `R`, the first step first. -/
def «迭» (R : «际» α) : Nat → «际» α
  | 0 => «静»
  | n + 1 => «而» R («迭» R n)

/-- **`n` steps are passing through a word of `n` letters, each read as `R` (迭即历)**: `«迭»` is
`«历»`'s case for one relation repeated. -/
theorem «迭即历» (R : «际» α) : ∀ n, «谓» («历» (fun (_ : Unit) => R) (List.replicate n ())) («迭» R n)
  | 0 => fun _ _ => Iff.rfl
  | n + 1 => fun _ _ => ⟨fun ⟨w, r, rest⟩ => ⟨w, r, («迭即历» R n _ _).mp rest⟩,
      fun ⟨w, r, rest⟩ => ⟨w, r, («迭即历» R n _ _).mpr rest⟩⟩

/-- `n + 1` steps reach. -/
theorem «迭则及» {R : «际» α} : ∀ (n : Nat) {x y : α}, «迭» R (n + 1) x y → «及» R x y
  | 0, _, _, ⟨_, r, e⟩ => by cases e; exact .one r
  | n + 1, _, _, ⟨_, r, rest⟩ => .more r («迭则及» n rest)

/-- **Reaching is some positive number of steps.** -/
theorem «及即迭» {R : «际» α} {x y : α} : «及» R x y ↔ ∃ n, «迭» R (n + 1) x y :=
  ⟨fun reach => by
    induction reach with
    | one r => exact ⟨0, _, r, rfl⟩
    | more r _ ih => exact match ih with
      | ⟨n, rest⟩ => ⟨n + 1, _, r, rest⟩,
   fun ⟨n, steps⟩ => «迭则及» n steps⟩

/-- Steps compose: `a` steps, then `b` steps, are `b + a` steps, the case of `«历之接»` for one
relation. -/
theorem «迭之接» {R : «际» α} : ∀ (a b : Nat) {x y z : α}, «迭» R a x y → «迭» R b y z → «迭» R (b + a) x z
  | a, b, x, y, z, first, second =>
    («迭即历» R (b + a) x z).mp
      (Eq.subst (motive := fun l => «历» (fun (_ : Unit) => R) l x z)
        (GrammarLaws.replicate_add_append () a b).symm
        ((«历之接» (fun (_ : Unit) => R) (List.replicate a ()) (List.replicate b ())).mpr
          ⟨y, («迭即历» R a x y).mpr first, («迭即历» R b y z).mpr second⟩))

/-- A loop of `p` steps is a loop of every multiple of `p` steps. -/
theorem «迭之周» {R : «际» α} {p : Nat} {x : α} (loop : «迭» R p x x) : ∀ k, «迭» R (p * k) x x
  | 0 => rfl
  | k + 1 => «迭之接» p (p * k) loop («迭之周» loop k)

/-- `n + 1` steps are `n` steps and then the last (迭之末步): `«迭»` takes the first step first, and
this reads its last step last, as `«相续之末步»` reads the last step of a line; the case of
`«历之末步»` for one relation. -/
theorem «迭之末步» {R : «际» α} : ∀ (n : Nat) {x z : α}, «迭» R (n + 1) x z ↔ ∃ y, «迭» R n x y ∧ R y z
  | n, x, z => («迭即历» R (n + 1) x z).symm.trans
      ((Iff.of_eq (congrArg (fun l => «历» (fun (_ : Unit) => R) l x z)
          (GrammarLaws.replicate_succ_append () n))).trans
        ((«历之末步» (fun (_ : Unit) => R) (List.replicate n ()) ()).trans
          ⟨fun ⟨y, steps, r⟩ => ⟨y, («迭即历» R n x y).mp steps, r⟩,
           fun ⟨y, steps, r⟩ => ⟨y, («迭即历» R n x y).mpr steps, r⟩⟩))

/-- Within `n` steps (迭内): some number of steps not more than `n`. -/
def «迭内» (R : «际» α) (n : Nat) : «际» α := fun x y => ∃ k, k ≤ n ∧ «迭» R k x y

/-- **Within `m` steps and then within `n` is within `m + n`**, from `«迭之接»`. -/
theorem «迭内之接» {R : «际» α} {m n : Nat} {x y z : α} :
    «迭内» R m x y → «迭内» R n y z → «迭内» R (m + n) x z
  | ⟨k, le, first⟩, ⟨j, le', second⟩ =>
    ⟨j + k, Nat.le_trans (Nat.add_le_add le' le) (Nat.le_of_eq (Nat.add_comm n m)), «迭之接» k j first second⟩

/-- Staying, or a step (静或缘): `R` with the identity beside it. -/
def «静或缘» (R : «际» α) : «际» α := fun x y => x = y ∨ R x y

/-- **Within `n` steps is `n` steps each of which stays or steps.** -/
theorem «迭内即静或缘之迭» {R : «际» α} : ∀ (n : Nat) {x y : α}, «迭内» R n x y ↔ «迭» («静或缘» R) n x y
  | 0, _, _ => ⟨fun within => match within with
      | ⟨0, _, e⟩ => e
      | ⟨_ + 1, le, _⟩ => absurd le (Nat.not_succ_le_zero _),
    fun e => ⟨0, Nat.le_refl 0, e⟩⟩
  | n + 1, x, _ => ⟨fun within => match within with
      | ⟨0, _, e⟩ => ⟨x, .inl rfl, («迭内即静或缘之迭» n).mp ⟨0, Nat.zero_le n, e⟩⟩
      | ⟨k + 1, le, ⟨w, r, rest⟩⟩ =>
        ⟨w, .inr r, («迭内即静或缘之迭» n).mp ⟨k, Nat.le_of_succ_le_succ le, rest⟩⟩,
    fun ⟨w, step, rest⟩ => match step, («迭内即静或缘之迭» n).mpr rest with
      | .inl same, ⟨k, le, steps⟩ =>
        ⟨k, Nat.le_succ_of_le le, Eq.subst (motive := fun v => «迭» R k v _) same.symm steps⟩
      | .inr r, ⟨k, le, steps⟩ => ⟨k + 1, Nat.succ_le_succ le, ⟨w, r, steps⟩⟩⟩

/-- What every condition held (承): the occurrences whose every condition under `R` lies in `P`. In
the main reading, an occurrence takes `P` on from all its conditions; one with no condition lies in
it for every region. -/
def «承» (R : «际» α) (P : α → Prop) : α → Prop := fun a => ∀ b, R b a → P b

/-- **Taking on, over `n` steps (承之迭).** Let each round of a course of regions hold exactly what
every condition held at the round before. Then round `n` holds exactly where everything reaching
in exactly `n` steps held at the start: `n` rounds of taking on along `R` are one taking on along
`n` steps of `R`. -/
theorem «承之迭» {R : «际» α} {S : Nat → α → Prop} (round : ∀ n a, S (n + 1) a ↔ «承» R (S n) a) :
    ∀ n a, S n a ↔ «承» («迭» R n) (S 0) a
  | 0, a => ⟨fun held _ e => Eq.subst (motive := S 0) e.symm held, fun all => all a rfl⟩
  | n + 1, a => (round n a).trans
    ⟨fun taken b steps => match («迭之末步» n).mp steps with
      | ⟨c, first, r⟩ => («承之迭» round n c).mp (taken c r) b first,
     fun all c r => («承之迭» round n c).mpr fun b first => all b ((«迭之末步» n).mpr ⟨c, first, r⟩)⟩

/-- **With memory, within `n` steps (存承之迭).** Let each round of a course keep what it held and take
on what every condition held. Then round `n` holds exactly where everything reaching within `n`
steps held at the start. It is the law without memory under staying or a step (`«承之迭»` at
`«静或缘» R`, read back by `«迭内即静或缘之迭»`): keeping is counting oneself among one's
conditions. -/
theorem «存承之迭» {R : «际» α} {S : Nat → α → Prop}
    (round : ∀ n a, S (n + 1) a ↔ S n a ∧ «承» R (S n) a) :
    ∀ n a, S n a ↔ «承» («迭内» R n) (S 0) a :=
  fun n a =>
    («承之迭» (R := «静或缘» R) (fun k c => (round k c).trans
      ⟨fun ⟨kept, taken⟩ b step => match step with
        | .inl same => Eq.subst (motive := S k) same.symm kept
        | .inr r => taken b r,
       fun all => ⟨all c (.inl rfl), fun b r => all b (.inr r)⟩⟩) n a).trans
    ⟨fun all b within => all b ((«迭内即静或缘之迭» n).mp within),
     fun all b steps => all b ((«迭内即静或缘之迭» n).mpr steps)⟩

/-- **Steps split as they compose (迭之分).** `b + a` steps are `a` steps and then `b`: the converse of
`«迭之接»`, read in its order; the case of `«历之接»` for one relation. -/
theorem «迭之分» {R : «际» α} : ∀ (a : Nat) {b : Nat} {x z : α},
    «迭» R (b + a) x z → ∃ y, «迭» R a x y ∧ «迭» R b y z
  | a, b, x, z, steps =>
    match («历之接» (fun (_ : Unit) => R) (List.replicate a ()) (List.replicate b ())).mp
        (Eq.subst (motive := fun l => «历» (fun (_ : Unit) => R) l x z)
          (GrammarLaws.replicate_add_append () a b) ((«迭即历» R (b + a) x z).mpr steps)) with
    | ⟨y, first, second⟩ => ⟨y, («迭即历» R a x y).mp first, («迭即历» R b y z).mp second⟩

/-- **Steps read backward are steps of the converse (迭之逆)**, the case of `«历之逆»` for one
relation, whose word of copies read backward is itself. -/
theorem «迭之逆» {R : «际» α} : ∀ (n : Nat) {x y : α}, «迭» («逆» R) n x y ↔ «迭» R n y x
  | n, x, y => («迭即历» («逆» R) n x y).symm.trans
      ((Iff.of_eq (congrArg (fun l => «历» (fun (_ : Unit) => «逆» R) l x y)
          (GrammarLaws.reverse_replicate () n))).symm.trans
        ((«历之逆» (fun (_ : Unit) => R) (List.replicate n ())).trans («迭即历» R n y x)))

/-- **Where there is a successor as far as can be refuted, there are steps as far as can be refuted
(或有后则或迭).** If whatever `x` reaches in fewer than `n` steps has a successor, as far as can be
refuted, then `n` steps from `x` exist, as far as can be refuted: the conclusion is a double negation
because each successor is given only as far as can be refuted. -/
theorem «或有后则或迭» {R : «际» α} {x : α} : ∀ (n : Nat),
    (∀ k y, k < n → «迭» R k x y → ¬¬ ∃ z, R y z) → ¬¬ ∃ y, «迭» R n x y
  | 0, _ => fun none => none ⟨x, rfl⟩
  | n + 1, more => fun none =>
    «或有后则或迭» n (fun k y below steps => more k y (Nat.lt_succ_of_lt below) steps)
      fun ⟨y, steps⟩ => more n y (Nat.lt_succ_self n) steps
        fun ⟨z, r⟩ => none ⟨z, («迭之末步» n).mpr ⟨y, steps, r⟩⟩

/-- `n` steps lead to the occurrence itself or to what it reaches (迭则同一或及); for a line's
continuation, this is lying within the line's reach (`«所及»`, by definition). -/
theorem «迭则同一或及» {R : «际» α} : ∀ (n : Nat) {x y : α}, «迭» R n x y → x = y ∨ «及» R x y
  | 0, _, _, e => .inl e
  | n + 1, _, _, steps => .inr («迭则及» n steps)

/-- **An unending line has steps of every length (不穷则迭).** Where every occurrence on the line from
`x` has a successor, `n` steps of the line's continuation lead from `x`, for every `n`. -/
theorem «不穷则迭» {R E : «际» α} {x : α} (endless : «不穷» R E x) :
    ∀ n, ∃ y, «迭» («续» R E) n x y
  | 0 => ⟨x, rfl⟩
  | n + 1 => match «不穷则迭» endless n with
    | ⟨y, steps⟩ => match endless y («迭则同一或及» n steps) with
      | ⟨z, c⟩ => ⟨z, («迭之末步» n).mpr ⟨y, steps, c⟩⟩

/-- The successor is fixed at what `x` reaches (定后于): two successors of one occurrence within
`x`'s closure are one. It is `«定后»` read within `«所闭» R x` only, and the laws of return below
use a fixed successor only there. -/
def «定后于» (R : «际» α) (x : α) : Prop := ∀ a, «所闭» R x a → ∀ b c, R a b → R a c → b = c

/-- A fixed successor is fixed at what every occurrence reaches. -/
theorem «定后则定后于» {R : «际» α} (fixed : «定后» R) (x : α) : «定后于» R x :=
  fun _ _ b c r r' => fixed b c ⟨_, r, r'⟩

/-- Fixed at what `x` reaches, the successor is fixed at what anything within `x`'s closure reaches. -/
theorem «定后于之后» {R : «际» α} {x y : α} (fixed : «定后于» R x) (within : «所闭» R x y) :
    «定后于» R y :=
  fun a reach => fixed a («所闭之传递» within reach)

/-! #### Lines from a list

A line is the steps from an occurrence. Under a successor fixed where it matters, a line ends at most
once, so occurrences that end on lines from a list number at most the list. No decision is used. -/

/-- **The closure is some number of steps (所闭当且仅当有迭).** -/
theorem «所闭当且仅当有迭» {R : «际» α} {x y : α} : «所闭» R x y ↔ ∃ n, «迭» R n x y :=
  ⟨fun within => match «所闭当且仅当同一或及».mp within with
    | .inl same => ⟨0, same⟩
    | .inr reach => match «及即迭».mp reach with
      | ⟨n, steps⟩ => ⟨n + 1, steps⟩,
   fun ⟨n, steps⟩ => «所闭当且仅当同一或及».mpr («迭则同一或及» n steps)⟩

/-- **Fixed where the lines part, `n` steps lead to one occurrence (分处定后则迭之定于).** Where two
successors of an occurrence `a` reaches, each leading to `y` or to `z`, are one, `n` steps from `a`
lead to one occurrence: the successor is asked to be fixed only where the two lines could part. -/
theorem «分处定后则迭之定于» {R : «际» α} : ∀ (n : Nat) {a y z : α},
    (∀ v b b', «所闭» R a v → («所闭» R b y ∨ «所闭» R b z) → («所闭» R b' y ∨ «所闭» R b' z) →
      R v b → R v b' → b = b') →
    «迭» R n a y → «迭» R n a z → y = z
  | 0, _, _, _, _, e₁, e₂ => Eq.trans (Eq.symm e₁) e₂
  | n + 1, a, _, z, fixed, ⟨w, r, rest⟩, ⟨w', r', rest'⟩ =>
    have same : w = w' := fixed a w w' («所闭之自反» R a)
      (.inl («所闭当且仅当有迭».mpr ⟨n, rest⟩)) (.inr («所闭当且仅当有迭».mpr ⟨n, rest'⟩)) r r'
    «分处定后则迭之定于» n
      (fun v b b' within => fixed v b b' («所闭之传递» («缘在所闭» r) within)) rest
      (Eq.subst (motive := fun u => «迭» R n u z) same.symm rest')

theorem GrammarLaws.reorder (k d : Nat) : k + 1 + d = d + 1 + k :=
  (Nat.add_comm (k + 1) d).trans
    ((congrArg (d + ·) (Nat.add_comm 1 k)).symm.trans (Nat.add_assoc d 1 k).symm)

/-- **What ends lies on no longer line from the same occurrence (亡者不在长迭)**, the successor fixed
as in `«分处定后则迭之定于»`. -/
theorem «亡者不在长迭» {R : «际» α} {k k' : Nat} {m x x' : α} (below : k < k')
    (fixed : ∀ v b b', «所闭» R m v → («所闭» R b x ∨ «所闭» R b x') →
      («所闭» R b' x ∨ «所闭» R b' x') → R v b → R v b' → b = b')
    (steps : «迭» R k m x) (steps' : «迭» R k' m x') (ends : ¬ ∃ w, R x w) : False :=
  match le_dest below with
  | ⟨d, more⟩ =>
    match «迭之分» k (b := d + 1)
        (Eq.subst (motive := fun j => «迭» R j m x') (more.trans (GrammarLaws.reorder k d)) steps') with
    | ⟨y, first, second⟩ =>
      have toX' : «所闭» R y x' := «所闭当且仅当有迭».mpr ⟨_, second⟩
      have same : x = y := «分处定后则迭之定于» k
        (fun v b b' within before before' => fixed v b b' within
          (match before with
            | .inl toX => .inl toX
            | .inr toY => .inr («所闭之传递» toY toX'))
          (match before' with
            | .inl toX => .inl toX
            | .inr toY => .inr («所闭之传递» toY toX')))
        steps first
      match second with
      | ⟨w, r, _⟩ => ends ⟨w, Eq.subst (motive := fun v => R v w) same.symm r⟩

/-- **A line under a fixed successor ends at most once (定后则线至多一亡).** Two occurrences that `m`
reaches and that end are one, where two successors of an occurrence `m` reaches, each leading to
either, are one. -/
theorem «定后则线至多一亡» {R : «际» α} {m x x' : α}
    (fixed : ∀ v b b', «所闭» R m v → («所闭» R b x ∨ «所闭» R b x') →
      («所闭» R b' x ∨ «所闭» R b' x') → R v b → R v b' → b = b')
    (reach : «所闭» R m x) (reach' : «所闭» R m x')
    (ends : ¬ ∃ w, R x w) (ends' : ¬ ∃ w, R x' w) : x = x' :=
  match «所闭当且仅当有迭».mp reach, «所闭当且仅当有迭».mp reach' with
  | ⟨k, steps⟩, ⟨k', steps'⟩ =>
    match Nat.lt_or_ge k k' with
    | .inl below => («亡者不在长迭» below fixed steps steps' ends).elim
    | .inr above => match Nat.eq_or_lt_of_le above with
      | .inl same => «分处定后则迭之定于» k fixed steps
          (Eq.subst (motive := fun j => «迭» R j m x') same steps')
      | .inr beyond => («亡者不在长迭» beyond
          (fun v b b' within before before' => fixed v b b' within before.symm before'.symm)
          steps' steps ends').elim

/-- **Ends on lines from a list number at most the list (线终不过所列)**, on any relation.
Occurrences listed once, each without a successor and each within the closure of a member of a list,
where two successors of an occurrence a member reaches, each leading to a listed occurrence, are one:
no more of them than members. -/
theorem «线终不过所列» {R : «际» α} {L D : List α} (dD : Distinct D)
    (fixed : ∀ v b b', (∃ m, m ∈ L ∧ «所闭» R m v) →
      (∃ x, x ∈ D ∧ «所闭» R b x) → (∃ x, x ∈ D ∧ «所闭» R b' x) → R v b → R v b' → b = b')
    (reached : ∀ x, x ∈ D → ∃ m, m ∈ L ∧ «所闭» R m x)
    (ends : ∀ x, x ∈ D → ¬ ∃ w, R x w) : D.length ≤ L.length :=
  length_le_of_matched (S := fun x m => m ∈ L ∧ «所闭» R m x) dD
    (fun x mx => match reached x mx with
      | ⟨m, mm, r⟩ => ⟨m, mm, mm, r⟩)
    fun x x' m mx mx' ⟨mm, r⟩ ⟨_, r'⟩ =>
      «定后则线至多一亡» (fun v b b' within before before' => fixed v b b' ⟨m, mm, within⟩
          (match before with
            | .inl toX => ⟨x, mx, toX⟩
            | .inr toX' => ⟨x', mx', toX'⟩)
          (match before' with
            | .inl toX => ⟨x, mx, toX⟩
            | .inr toX' => ⟨x', mx', toX'⟩))
        r r' (ends x mx) (ends x' mx')

/-- The count where each listed occurrence's being reached from the list is only not refuted: the
count's comparison is decidable, so the double negation lifts. -/
theorem GrammarLaws.line_ends_unrefuted {R : «际» α} {L D : List α} (dD : Distinct D)
    (fixed : ∀ v b b', (∃ m, m ∈ L ∧ «所闭» R m v) →
      (∃ x, x ∈ D ∧ «所闭» R b x) → (∃ x, x ∈ D ∧ «所闭» R b' x) → R v b → R v b' → b = b')
    (reached : ∀ x, x ∈ D → ¬¬ ∃ m, m ∈ L ∧ «所闭» R m x)
    (ends : ∀ x, x ∈ D → ¬ ∃ w, R x w) : D.length ≤ L.length :=
  match Nat.decLe D.length L.length with
  | isTrue within => within
  | isFalse beyond => absurd (fun all => beyond («线终不过所列» dD fixed all ends))
      (not_not_all reached)

/-- **Endings on lines from a list number at most the list (线亡不过所列).** Units listed once, each
ending (`«亡»`) and each on the line of the continuation from a member of a list, where two
successors of a unit a member reaches, each leading to a listed unit, are one: no more of them than
members. -/
theorem «线亡不过所列» {R E : «际» α} {L D : List α} (dD : Distinct D)
    (fixed : ∀ v b b', (∃ m, m ∈ L ∧ «所闭» («续» R E) m v) →
      (∃ x, x ∈ D ∧ «所闭» («续» R E) b x) → (∃ x, x ∈ D ∧ «所闭» («续» R E) b' x) →
      «续» R E v b → «续» R E v b' → b = b')
    (reached : ∀ x, x ∈ D → ∃ m, m ∈ L ∧ «所闭» («续» R E) m x)
    (ends : ∀ x, x ∈ D → «亡» R E x) : D.length ≤ L.length :=
  «线终不过所列» dD fixed reached ends

/-- The count of endings where each one's being reached from the list is only not refuted
(线亡不过所列之未否). -/
theorem «线亡不过所列之未否» {R E : «际» α} {L D : List α} (dD : Distinct D)
    (fixed : ∀ v b b', (∃ m, m ∈ L ∧ «所闭» («续» R E) m v) →
      (∃ x, x ∈ D ∧ «所闭» («续» R E) b x) → (∃ x, x ∈ D ∧ «所闭» («续» R E) b' x) →
      «续» R E v b → «续» R E v b' → b = b')
    (reached : ∀ x, x ∈ D → ¬¬ ∃ m, m ∈ L ∧ «所闭» («续» R E) m x)
    (ends : ∀ x, x ∈ D → «亡» R E x) : D.length ≤ L.length :=
  GrammarLaws.line_ends_unrefuted dD fixed reached ends

/-- **Its mirror: beginnings on lines to a list number at most the list (线生不过所列)**, the count
at the converse (`«逆»`), two units continuing as one occurrence only where it does not matter. -/
theorem «线生不过所列» {R E : «际» α} {L D : List α} (dD : Distinct D)
    (merges : ∀ v a a', (∃ m, m ∈ L ∧ «所闭» («续» R E) v m) →
      (∃ x, x ∈ D ∧ «所闭» («续» R E) x a) → (∃ x, x ∈ D ∧ «所闭» («续» R E) x a') →
      «续» R E a v → «续» R E a' v → a = a')
    (reaching : ∀ x, x ∈ D → ∃ m, m ∈ L ∧ «所闭» («续» R E) x m)
    (begins : ∀ x, x ∈ D → «生» R E x) : D.length ≤ L.length :=
  «线终不过所列» (R := «逆» («续» R E)) dD
    (fun v a a' ⟨m, mm, within⟩ ⟨x, mx, toX⟩ ⟨x', mx', toX'⟩ => merges v a a'
      ⟨m, mm, «所闭之逆».mp within⟩ ⟨x, mx, «所闭之逆».mp toX⟩ ⟨x', mx', «所闭之逆».mp toX'⟩)
    (fun x mx => match reaching x mx with
      | ⟨m, mm, r⟩ => ⟨m, mm, «所闭之逆».mpr r⟩)
    begins

/-- The mirror where each beginning's reaching the list is only not refuted (线生不过所列之未否). -/
theorem «线生不过所列之未否» {R E : «际» α} {L D : List α} (dD : Distinct D)
    (merges : ∀ v a a', (∃ m, m ∈ L ∧ «所闭» («续» R E) v m) →
      (∃ x, x ∈ D ∧ «所闭» («续» R E) x a) → (∃ x, x ∈ D ∧ «所闭» («续» R E) x a') →
      «续» R E a v → «续» R E a' v → a = a')
    (reaching : ∀ x, x ∈ D → ¬¬ ∃ m, m ∈ L ∧ «所闭» («续» R E) x m)
    (begins : ∀ x, x ∈ D → «生» R E x) : D.length ≤ L.length :=
  GrammarLaws.line_ends_unrefuted (R := «逆» («续» R E)) dD
    (fun v a a' ⟨m, mm, within⟩ ⟨x, mx, toX⟩ ⟨x', mx', toX'⟩ => merges v a a'
      ⟨m, mm, «所闭之逆».mp within⟩ ⟨x, mx, «所闭之逆».mp toX⟩ ⟨x', mx', «所闭之逆».mp toX'⟩)
    (fun x mx no => reaching x mx fun ⟨m, mm, r⟩ => no ⟨m, mm, «所闭之逆».mpr r⟩)
    begins

/-- With the successor fixed at what `x` reaches, `n` steps from `x` lead to one occurrence, the case
of `«分处定后则迭之定于»` where the successor is fixed throughout what `x` reaches. -/
theorem «迭之定于» {R : «际» α} : ∀ (n : Nat) {x y z : α}, «定后于» R x →
    «迭» R n x y → «迭» R n x z → y = z :=
  fun n _ _ _ fixed first second =>
    «分处定后则迭之定于» n (fun v b b' within _ _ r r' => fixed v within b b' r r') first second

/-- With a fixed successor, `n` steps lead to one occurrence. -/
theorem «迭之定» {R : «际» α} (fixed : «定后» R) : ∀ (n : Nat) {x y z : α},
    «迭» R n x y → «迭» R n x z → y = z
  | n, x, _, _, first, second => «迭之定于» n («定后则定后于» fixed x) first second

/-- **Merging nothing, `n` steps to one occurrence come from one occurrence**, the case of
`«历之定前»` for one relation. -/
theorem «迭之定前» {R : «际» α} (merges : «定前» R) : ∀ (n : Nat) {x y z : α},
    «迭» R n x z → «迭» R n y z → x = y
  | n, x, y, z, first, second =>
    «历之定前» (F := fun (_ : Unit) => R) (fun _ => merges) (List.replicate n ())
      ((«迭即历» R n x z).mpr first) ((«迭即历» R n y z).mpr second)

/-- Drawn in (入): some region closed under `R` that `x` lies outside holds something `x` reaches. -/
def «入» (R : «际» α) (x : α) : Prop := ∃ P : α → Prop, «闭» R P ∧ ¬ P x ∧ ∃ y, «及» R x y ∧ P y

/-- **Drawn in is reaching something that does not reach back**, for every relation. -/
theorem «入当且仅当有不返» {R : «际» α} {x : α} : «入» R x ↔ ∃ y, «及» R x y ∧ ¬ «及» R y x :=
  ⟨fun ⟨_, closed, outside, y, reach, holds⟩ => ⟨y, reach, fun back => outside («闭之及» closed holds back)⟩,
   fun ⟨y, reach, never⟩ => ⟨fun z => y = z ∨ «及» R y z,
     fun a b inside related => match inside with
       | .inl e => .inr (by cases e; exact .one related)
       | .inr l => .inr («及之传递» l (.one related)),
     fun inside => match inside with
       | .inl e => never (by cases e; exact reach)
       | .inr back => never back,
     y, reach, .inl rfl⟩⟩

/-- **With the successor fixed at what `x` reaches, what `x` reaches, where `x` reaches itself,
reaches `x` back.** The occurrences within `x`'s closure that reach `x` form a closed region: the
one successor of such an occurrence is the next place on its way back. -/
theorem «定后于环则所及皆返» {R : «际» α} {x : α} (fixed : «定后于» R x) (loop : «及» R x x) {y : α}
    (reach : «及» R x y) : «及» R y x :=
  («闭之及» (P := fun z => «所闭» R x z ∧ «及» R z x)
    (fun a b inside related => ⟨«所闭之传递» inside.1 («缘在所闭» related),
      match inside.2 with
      | .one r => by
        have e : b = x := fixed a inside.1 b x related r
        cases e; exact loop
      | .more r rest => by
        have e : b = _ := fixed a inside.1 b _ related r
        cases e; exact rest⟩)
    ⟨«所闭之自反» R x, loop⟩ reach).2

/-- With a fixed successor, what an occurrence that reaches itself reaches reaches it back: the
global form of `«定后于环则所及皆返»`. -/
theorem «定后环则所及皆返» {R : «际» α} (fixed : «定后» R) {x : α} (loop : «及» R x x) {y : α}
    (reach : «及» R x y) : «及» R y x :=
  «定后于环则所及皆返» («定后则定后于» fixed x) loop reach

/-- **With the successor fixed at what `x` reaches, `x`, reaching itself, is not drawn.** -/
theorem «定后于则返者不入» {R : «际» α} {x : α} (fixed : «定后于» R x) (loop : «及» R x x) :
    ¬ «入» R x :=
  fun drawn => match «入当且仅当有不返».mp drawn with
    | ⟨_, reach, never⟩ => never («定后于环则所及皆返» fixed loop reach)

/-- **With a fixed successor, an occurrence that reaches itself is not drawn**: the global form. -/
theorem «定后则返者不入» {R : «际» α} (fixed : «定后» R) {x : α} (loop : «及» R x x) : ¬ «入» R x :=
  «定后于则返者不入» («定后则定后于» fixed x) loop

/-- **An occurrence with a successor that does not reach itself is drawn**, for every relation. -/
theorem «有后不返则入» {R : «际» α} {x y : α} (next : R x y) (never : ¬ «及» R x x) : «入» R x :=
  «入当且仅当有不返».mpr ⟨y, .one next, fun back => never (.more next back)⟩

/-- **With the successor fixed at what `x` reaches and some successor, `x` is drawn exactly where it
does not reach itself.** -/
theorem «定后于有后则入当且仅当不返» {R : «际» α} {x : α} (fixed : «定后于» R x)
    (next : ∃ y, R x y) : «入» R x ↔ ¬ «及» R x x :=
  ⟨fun drawn loop => «定后于则返者不入» fixed loop drawn,
   fun never => match next with
    | ⟨_, r⟩ => «有后不返则入» r never⟩

/-- **With a fixed successor and some successor, drawn is not reaching itself**: the global form. -/
theorem «定后有后则入当且仅当不返» {R : «际» α} (fixed : «定后» R) {x : α} (next : ∃ y, R x y) :
    «入» R x ↔ ¬ «及» R x x :=
  «定后于有后则入当且仅当不返» («定后则定后于» fixed x) next

/-- Without a successor an occurrence is neither drawn nor reaches itself: the successor hypothesis
of `«定后有后则入当且仅当不返»` cannot be omitted, since without it the reverse direction fails. -/
theorem «无后者不入亦不返» {R : «际» α} {x : α} (nothing : ∀ y, ¬ R x y) : ¬ «入» R x ∧ ¬ «及» R x x :=
  have first : ∀ {y}, ¬ «及» R x y := fun reach => match reach with
    | .one r => nothing _ r
    | .more r _ => nothing _ r
  ⟨fun ⟨_, _, _, _, reach, _⟩ => first reach, first⟩

/-- **An occurrence both drawn and reaching itself**, under a relation whose successor is not fixed
at what it reaches: `false` conditions itself and `true`, which conditions nothing. So the fixed
successor of `«定后于则返者不入»` cannot be omitted. -/
theorem «入而返之例» : ∃ (R : «际» Bool) (x : Bool), «入» R x ∧ «及» R x x :=
  ⟨fun a _ => a = false, false,
   ⟨fun z => z = true, fun a _ inside related => by cases inside; exact Bool.noConfusion related,
    fun inside => Bool.noConfusion inside, true, .one rfl, rfl⟩,
   .one rfl⟩

/-- **Reaching itself and not drawn, with no fixed successor**: `none` conditions only itself and
`some true` conditions everything, so the successor is not fixed, yet it is fixed at what `none`
reaches, and `none` reaches itself and is not drawn. So a relation with no fixed successor need not
draw what reaches itself, and the global fixed successor of `«定后则返者不入»` is more than the law
uses. -/
theorem «非定后返而不入之例» :
    ∃ (R : «际» (Option Bool)), ¬ «定后» R ∧ «及» R none none ∧ ¬ «入» R none :=
  have stays : ∀ a b : Option Bool, a = none → ((a = none ∧ b = none) ∨ a = some true) → b = none :=
    fun _ _ e r => match r with
      | .inl ⟨_, e'⟩ => e'
      | .inr e' => nomatch e.symm.trans e'
  have only : ∀ a, «所闭» (fun a b : Option Bool => (a = none ∧ b = none) ∨ a = some true) none a →
      a = none :=
    fun _ within => within (fun z => z = none) (fun a b inside r => stays a b inside r) rfl
  ⟨fun a b => (a = none ∧ b = none) ∨ a = some true,
   fun fixed => (nomatch fixed (some false) (some true) ⟨some true, .inr rfl, .inr rfl⟩),
   .one (.inl ⟨rfl, rfl⟩),
   «定后于则返者不入» (fun a within b c r r' =>
      (stays a b (only a within) r).trans (stays a c (only a within) r').symm) (.one (.inl ⟨rfl, rfl⟩))⟩

open GrammarLaws in
/-- Where every occurrence has a successor, a line of every length goes on from every occurrence. -/
theorem «遍后则有线» {R : «际» α} (total : ∀ x, ∃ y, R x y) :
    ∀ (n : Nat) (x : α), ∃ g : Nat → α, g 0 = x ∧ ∀ i, i < n → R (g i) (g (i + 1))
  | 0, x => ⟨fun _ => x, rfl, fun _ lt => absurd lt (Nat.not_lt_zero _)⟩
  | n + 1, x => match total x with
    | ⟨y, r⟩ => match «遍后则有线» total n y with
      | ⟨h, h0, steps⟩ => ⟨prepend x h, rfl, fun i lt => match i, lt with
        | 0, _ => Eq.subst (motive := fun w => R x w) h0.symm r
        | i + 1, lt => steps i (Nat.lt_of_succ_lt_succ lt)⟩

/-- Merging nothing at the line's places (线不并): two of the first `N` places of the line `g` with a
common successor hold one occurrence. It is `«定前»` read at those places only. -/
def «线不并» (R : «际» α) (g : Nat → α) (N : Nat) : Prop :=
  ∀ i j z, i < N → j < N → R (g i) z → R (g j) z → g i = g j

/-- A relation that merges nothing merges nothing at the places of every line. -/
theorem «定前则线不并» {R : «际» α} (merges : «定前» R) (g : Nat → α) (N : Nat) : «线不并» R g N :=
  fun _ _ z _ _ r r' => merges _ _ ⟨z, r, r'⟩

/-- **Merging nothing at the line's places, where two places of a line hold one occurrence, so do
the places as many before them, back to the first.** -/
theorem «线不并则可退» {R : «际» α} {g : Nat → α} {N : Nat} (merges : «线不并» R g N)
    (steps : ∀ i, i < N → R (g i) (g (i + 1))) : ∀ i d, i + d ≤ N → g i = g (i + d) → g 0 = g d
  | 0, d, _, same => same.trans (congrArg g (Nat.zero_add d))
  | i + 1, d, le, same =>
    have shift : i + 1 + d = i + d + 1 := Nat.succ_add i d
    have le' : i + d + 1 ≤ N := Eq.subst (motive := fun k => k ≤ N) shift le
    have back : g (i + d + 1) = g (i + 1) := (congrArg g shift).symm.trans same.symm
    have r' : R (g (i + d)) (g (i + 1)) :=
      Eq.subst (motive := fun w => R (g (i + d)) w) back (steps (i + d) le')
    have lt : i < N := Nat.lt_of_lt_of_le (Nat.lt_succ_of_le (Nat.le_add_right i d)) le'
    «线不并则可退» merges steps i d (Nat.le_of_lt le') (merges i (i + d) _ lt le' (steps i lt) r')

/-- Merging nothing, where two places of a line hold one occurrence, so do the places as many before
them, back to the first: the global form of `«线不并则可退»`. -/
theorem «定前则线可退» {R : «际» α} (merges : «定前» R) {g : Nat → α} {N : Nat}
    (steps : ∀ i, i < N → R (g i) (g (i + 1))) : ∀ i d, i + d ≤ N → g i = g (i + d) → g 0 = g d :=
  «线不并则可退» («定前则线不并» merges g N) steps

/-- A line of `k + 1` steps from place `m` reaches. -/
theorem «线则及» {R : «际» α} {g : Nat → α} {N : Nat} (steps : ∀ i, i < N → R (g i) (g (i + 1))) :
    ∀ k m, m + (k + 1) ≤ N → «及» R (g m) (g (m + (k + 1)))
  | 0, m, le => .one (steps m le)
  | k + 1, m, le => «及之传递» («线则及» steps k m (Nat.le_trans (Nat.le_succ _) le))
      (.one (steps (m + (k + 1)) le))

/-- Every place of a line up to its length lies within the closure from its first place. -/
theorem «线则所闭» {R : «际» α} {g : Nat → α} {N : Nat} (steps : ∀ i, i < N → R (g i) (g (i + 1))) :
    ∀ m, m ≤ N → «所闭» R (g 0) (g m)
  | 0, _ => «所闭之自反» R (g 0)
  | m + 1, le => «所闭之传递» («线则所闭» steps m (Nat.le_of_succ_le le)) («缘在所闭» (steps m le))

/-- **A region every step keeps holds from where it holds on.** A region of the steps of time
that every step keeps, holding at step `a`, holds at every later step `b`: the steps from `a` to
`b` are a line under the successor (`«线则所闭»`), and a closed region holds what lies within the
closure from where it holds (`«闭含所闭»`). It is the grammar's closure at the successor relation;
no process and no run is needed. -/
theorem kept_onward {I : Nat → Prop} (keeps : ∀ n, I n → I (n + 1)) {a b : Nat} (holds : I a)
    (later : a ≤ b) : I b :=
  match le_dest later with
  | ⟨k, at_⟩ => Eq.subst (motive := I) at_.symm
      («闭含所闭» (R := fun x y => y = x + 1)
        (fun x _ held stepped => Eq.subst (motive := I) stepped.symm (keeps x held)) holds
        («线则所闭» (g := fun i => a + i) (N := k) (fun _ _ => rfl) k (Nat.le_refl k)))

open GrammarLaws in
/-- **Along a line held by a list, merging nothing at its places, the line comes back to its start**
within as many steps as the list is long: pigeonhole along the line, with no decidability, then back
along it to its first place. Only the line and the list are used: the list need not hold every
occurrence, nothing beyond the line needs a successor, and the relation need merge nothing only at
the line's places. -/
theorem «线有限不并则回» {R : «际» α} {l : List α} {g : Nat → α} (merges : «线不并» R g l.length)
    (steps : ∀ i, i < l.length → R (g i) (g (i + 1))) (held : ∀ n, n ≤ l.length → g n ∈ l) :
    ∃ d, 0 < d ∧ d ≤ l.length ∧ g d = g 0 :=
  match revisits_within l g held with
  | ⟨i, _, lt, le, same⟩ => match gap_of_lt lt with
    | ⟨d, gap⟩ =>
      have le' : i + (d + 1) ≤ l.length := Eq.subst (motive := fun k => k ≤ l.length) gap le
      ⟨d + 1, Nat.succ_pos d, Nat.le_trans (Nat.le_add_left (d + 1) i) le',
        («线不并则可退» merges steps i (d + 1) le' (same.trans (congrArg g gap))).symm⟩

/-- **Along a line held by a list, merging nothing at its places, the line's start reaches
itself.** -/
theorem «线有限不并则返» {R : «际» α} {l : List α} {g : Nat → α} (merges : «线不并» R g l.length)
    (steps : ∀ i, i < l.length → R (g i) (g (i + 1))) (held : ∀ n, n ≤ l.length → g n ∈ l) :
    «及» R (g 0) (g 0) :=
  match «线有限不并则回» merges steps held with
  | ⟨0, pos, _, _⟩ => absurd pos (Nat.lt_irrefl 0)
  | ⟨d + 1, _, le, back⟩ =>
    Eq.subst (motive := fun w => «及» R (g 0) w) ((congrArg g (Nat.zero_add (d + 1))).trans back)
      («线则及» steps d 0 (Nat.le_trans (Nat.le_of_eq (Nat.zero_add (d + 1))) le))

/-- **Along a line held by a list, merging nothing, the line's start reaches itself**: the global
form of `«线有限不并则返»`. -/
theorem «线有限定前则返» {R : «际» α} {l : List α} (merges : «定前» R) {g : Nat → α}
    (steps : ∀ i, i < l.length → R (g i) (g (i + 1))) (held : ∀ n, n ≤ l.length → g n ∈ l) :
    «及» R (g 0) (g 0) :=
  «线有限不并则返» («定前则线不并» merges g l.length) steps held

open GrammarLaws in
/-- **Along a line held by a list, with the successor fixed at what its start reaches, the line's
last place reaches itself.** Pigeonhole gives a place the line comes back to; it reaches itself, the
last place lies on its way, and with the successor fixed there what it reaches reaches it back.
Nothing need be unmerged. -/
theorem «定后于线有限则末返» {R : «际» α} {l : List α} {g : Nat → α} (fixed : «定后于» R (g 0))
    (steps : ∀ i, i < l.length → R (g i) (g (i + 1))) (held : ∀ n, n ≤ l.length → g n ∈ l) :
    «及» R (g l.length) (g l.length) :=
  match revisits_within l g held with
  | ⟨i, _, lt, le, same⟩ => match gap_of_lt lt with
    | ⟨d, gap⟩ =>
      have le' : i + (d + 1) ≤ l.length := Eq.subst (motive := fun k => k ≤ l.length) gap le
      have loop : «及» R (g i) (g i) :=
        Eq.subst (motive := fun w => «及» R (g i) w) ((congrArg g gap).symm.trans same.symm)
          («线则及» steps d i le')
      have fixed_i : «定后于» R (g i) :=
        «定后于之后» fixed («线则所闭» steps i (Nat.le_trans (Nat.le_add_right i (d + 1)) le'))
      match le_dest (Nat.le_trans (Nat.le_add_right i (d + 1)) le') with
      | ⟨0, rest⟩ => Eq.subst (motive := fun w => «及» R w w) (congrArg g rest).symm loop
      | ⟨e + 1, rest⟩ =>
        have reach : «及» R (g i) (g (i + (e + 1))) := «线则及» steps e i (Nat.le_of_eq rest.symm)
        Eq.subst (motive := fun w => «及» R w w) (congrArg g rest).symm
          («及之传递» («定后于环则所及皆返» fixed_i loop reach) reach)

/-- **Within finitely many occurrences, each with a successor, merging nothing, every occurrence
reaches itself.** Where a list holds every occurrence and every occurrence has a successor, a
relation that merges nothing has every occurrence reaching itself: the line law at a line of the
list's length from each occurrence. -/
theorem «有限遍后定前则皆返» {R : «际» α} {all : List α} (every : ∀ x, x ∈ all)
    (total : ∀ x, ∃ y, R x y) (merges : «定前» R) (x : α) : «及» R x x :=
  match «遍后则有线» total all.length x with
  | ⟨_, g0, steps⟩ =>
    Eq.subst (motive := fun w => «及» R w w) g0 («线有限定前则返» merges steps (fun _ _ => every _))

/-- **Two occurrences that reach themselves, with the successor fixed at what each reaches, have no
common successor unless they are one.** Two loops through one successor have a common multiple of
their lengths, and the steps after the first lead from that successor to each. -/
theorem «定后于二返则不并» {R : «际» α} {x y z : α} (fx : «定后于» R x) (fy : «定后于» R y)
    (loopx : «及» R x x) (loopy : «及» R y y) (rx : R x z) (ry : R y z) : x = y :=
  match «及即迭».mp loopx, «及即迭».mp loopy with
  | ⟨p, hx⟩, ⟨q, hy⟩ =>
    have lx : «迭» R ((p + 1) * q + p + 1) x x := «迭之周» hx (q + 1)
    have ly : «迭» R ((q + 1) * p + q + 1) y y := «迭之周» hy (p + 1)
    have e : (p + 1) * q + p = (q + 1) * p + q := Nat.succ.inj (Nat.mul_comm (p + 1) (q + 1))
    match lx, ly with
    | ⟨w, rxw, restx⟩, ⟨w', ryw, resty⟩ =>
      have tox : «迭» R ((p + 1) * q + p) z x :=
        Eq.subst (motive := fun v => «迭» R _ v x) (fx x («所闭之自反» R x) w z rxw rx) restx
      have toy : «迭» R ((p + 1) * q + p) z y :=
        Eq.subst (motive := fun k => «迭» R k z y) e.symm
          (Eq.subst (motive := fun v => «迭» R _ v y) (fy y («所闭之自反» R y) w' z ryw ry) resty)
      «迭之定于» _ («定后于之后» fx («缘在所闭» rx)) tox toy

/-- **With a fixed successor, every occurrence reaching itself, nothing is merged**: the global form
of `«定后于二返则不并»`. -/
theorem «皆返定后则定前» {R : «际» α} (fixed : «定后» R) (loops : ∀ x, «及» R x x) : «定前» R :=
  fun x y ⟨_, rx, ry⟩ =>
    «定后于二返则不并» («定后则定后于» fixed x) («定后则定后于» fixed y) (loops x) (loops y) rx ry

/-- **Within finitely many occurrences, each with a successor, under a fixed successor, merging
nothing is every occurrence reaching itself.** -/
theorem «有限遍后定后则定前当且仅当皆返» {R : «际» α} {all : List α} (every : ∀ x, x ∈ all)
    (total : ∀ x, ∃ y, R x y) (fixed : «定后» R) : «定前» R ↔ ∀ x, «及» R x x :=
  ⟨fun merges => «有限遍后定前则皆返» every total merges, «皆返定后则定前» fixed⟩

/-! ### Rest (止): falls that end

A line `g` whose steps from `T` on are steps of `Q` (no rise, say) is at rest where its steps of `F`
(a least fall, say) do not recur. The ending of the courses (`«尽»`) gives rest: where every course
of `Q` steps then an `F` step ends from the line's place at `T`, the `F` steps along the line do
not recur. That is a sufficient condition, not what rest is; no converse is established. It is not a case of being drawn in
(`«入»`): a place at rest need not be drawn, and a place drawn in need not come to rest. -/

/-- Steps of `F` recur along the line `g` (屡): after every place, a later step of `g` is one of `F`. -/
def «屡» (F : «际» α) (g : Nat → α) : Prop := ∀ N, ∃ t, N ≤ t ∧ F (g t) (g (t + 1))

/-- Steps of `F` recur along `g` from `T` on, as far as can be refuted (或屡): after every place from
`T` on, a later step of `F` is not refuted. -/
def «或屡» (F : «际» α) (g : Nat → α) (T : Nat) : Prop :=
  ∀ N, T ≤ N → ¬¬ ∃ t, N ≤ t ∧ F (g t) (g (t + 1))

/-- What recurs recurs as far as can be refuted. -/
theorem «屡则或屡» {F : «际» α} {g : Nat → α} (recurs : «屡» F g) (T : Nat) : «或屡» F g T :=
  fun N _ no => no (recurs N)

/-- Where the steps of a line from `T` on are, as far as can be refuted, steps of `Q`, each later
place lies, as far as can be refuted, within `Q`'s closure from the place at `T`. -/
theorem «线或在所闭» {Q : «际» α} {g : Nat → α} {T : Nat}
    (still : ∀ t, T ≤ t → ¬¬ Q (g t) (g (t + 1))) : ∀ k, ¬¬ «所闭» Q (g T) (g (T + k))
  | 0, no => no («所闭之自反» Q (g T))
  | k + 1, no => «线或在所闭» still k fun within =>
      still (T + k) (Nat.le_add_right T k) fun step => no («所闭之传递» within («缘在所闭» step))

/-- **Falls that end do not recur** (尽则不或屡). Where the steps of a line from `T` on are steps of
`Q`, each as far as can be refuted, and every course of `Q` steps then an `F` step ends from the
line's place at `T` (`«尽» («而» («所闭» Q) F) «一»`), it is not the case that the line's `F` steps
stay unrefuted after every place from `T` on. No decision and no choice is used: the ending is
inductive, and each `F` step found is one step further along a course that ends. -/
theorem «尽则不或屡» {Q F : «际» α} {g : Nat → α} {T : Nat}
    (still : ∀ t, T ≤ t → ¬¬ Q (g t) (g (t + 1))) (ends : «尽» («而» («所闭» Q) F) «一» (g T)) :
    ¬ «或屡» F g T :=
  have key : ∀ {x : α}, «尽» («而» («所闭» Q) F) «一» x → ∀ T, g T = x →
      (∀ t, T ≤ t → ¬¬ Q (g t) (g (t + 1))) → ¬ «或屡» F g T := by
    intro x ends
    induction ends with
    | mk _ ih =>
      intro T at_x still recurs
      exact recurs T (Nat.le_refl T) fun ⟨t, later, fall⟩ =>
        match le_dest later with
        | ⟨k, gap⟩ => «线或在所闭» still k fun within =>
          ih (g (t + 1)) ⟨⟨g t, Eq.subst (motive := fun w => «所闭» Q w (g t)) at_x
              (Eq.subst (motive := fun u => «所闭» Q (g T) (g u)) gap.symm within), fall⟩, trivial⟩
            (t + 1) rfl (fun u from_ => still u (Nat.le_trans later (Nat.le_of_succ_le from_)))
            (fun N from_ => recurs N (Nat.le_trans later (Nat.le_of_succ_le from_)))
  key ends T rfl still

/-- **Falls that end, outright, do not recur.** -/
theorem «尽则不屡» {Q F : «际» α} {g : Nat → α} {T : Nat}
    (still : ∀ t, T ≤ t → Q (g t) (g (t + 1))) (ends : «尽» («而» («所闭» Q) F) «一» (g T)) :
    ¬ «屡» F g :=
  fun recurs => «尽则不或屡» (fun t later no => no (still t later)) ends («屡则或屡» recurs T)

/-- **At rest and not drawn in**: on two occurrences, a line falls once and then stays at a fixed
point. Its falls end and do not recur, and the place it rests at is not drawn in, since that place
reaches itself. A fixed point is at rest without being drawn, so rest is not a case of `«入»`. -/
theorem «止而不入之例» : ∃ (Q F : «际» Bool) (g : Nat → Bool),
    (∀ t, Q (g t) (g (t + 1))) ∧ (∃ t, F (g t) (g (t + 1))) ∧
      «尽» («而» («所闭» Q) F) «一» (g 0) ∧ ¬ «屡» F g ∧ ¬ «入» Q (g 1) := by
  let Q : «际» Bool := fun _ b => b = true
  let F : «际» Bool := fun a b => a = false ∧ b = true
  let g : Nat → Bool := fun t => match t with
    | 0 => false
    | _ + 1 => true
  have toTrue : ∀ {b : Bool}, «所闭» Q true b → b = true :=
    fun h => h (fun z => z = true) (fun _ _ _ e => e) rfl
  have trueEnds : «尽» («而» («所闭» Q) F) «一» true :=
    .mk fun _ ⟨⟨_, closed, fall⟩, _⟩ =>
      absurd (toTrue closed) (fun e => Bool.noConfusion (fall.1.symm.trans e))
  have ends : «尽» («而» («所闭» Q) F) «一» false :=
    .mk fun y ⟨⟨_, _, fall⟩, _⟩ =>
      Eq.subst (motive := fun z => «尽» («而» («所闭» Q) F) «一» z) fall.2.symm trueEnds
  exact ⟨Q, F, g, fun _ => rfl, ⟨0, rfl, rfl⟩, ends,
    «尽则不屡» (T := 0) (fun _ _ => rfl) ends,
    «定后则返者不入» (fun _ _ ⟨_, e₁, e₂⟩ => e₁.trans e₂.symm) (.one rfl)⟩

/-- **Drawn in and not at rest**: along the successor on the whole numbers every step is an `F`
step, so the `F` steps recur, and `0` is drawn in, since what it reaches never reaches back. Being
drawn does not bring rest. -/
theorem «入而屡之例» : ∃ (Q F : «际» Nat) (g : Nat → Nat),
    (∀ t, Q (g t) (g (t + 1))) ∧ «屡» F g ∧ «入» Q (g 0) :=
  have up : ∀ {a b : Nat}, «及» (fun a b : Nat => b = a + 1) a b → a < b := fun reach => by
    induction reach with
    | one e => cases e; exact Nat.lt_succ_self _
    | more e _ ih => cases e; exact Nat.lt_trans (Nat.lt_succ_self _) ih
  ⟨fun a b => b = a + 1, fun a b => b = a + 1, fun t => t, fun _ => rfl,
   fun N => ⟨N, Nat.le_refl N, rfl⟩,
   «有后不返则入» (y := 1) rfl fun loop => Nat.lt_irrefl 0 (up loop)⟩

end Runs

/-! ## The census of a step (生, 亡): arising and ceasing paired

Units listed once before and after a step, under a continuation decided by a test: those before
that no unit after continues cease, and those after that continue no unit before arise. Where the
continuation fixes successors and predecessors, the census pairs them one to one; where every
predecessor of a unit after stands before and every successor of a unit before stands after,
arising and ceasing are the grammar's beginning (`«生»`) and ending (`«亡»`).
The listing and the test are supplied, as the pairing is in `section Balance`. -/

section Census

variable {α : Type u}

/-- The units before a step that no unit after continues, under a continuation decided by `k`: they
cease across the step. -/
def GrammarLaws.ceasing (k : α → α → Bool) (before after : List α) : List α :=
  GrammarLaws.keep (fun g => !(after.any (k g))) before

/-- The units after a step that continue no unit before, under a continuation decided by `k`: they
arise across the step. -/
def GrammarLaws.arising (k : α → α → Bool) (before after : List α) : List α :=
  GrammarLaws.keep (fun f => !(before.any (fun g => k g f))) after

/-- The census as a pairing, under a continuation decided by a test. Where units listed once at the
two ends of a step continue one to one (no unit continues as two, no two continue as one), the units
before with those arising are paired one to one with the units after with those ceasing, each pair
a continuation or the same unit. -/
theorem GrammarLaws.census_pairs (k : α → α → Bool) : ∀ (before after : List α),
    Distinct before → Distinct after →
    (∀ g f f', g ∈ before → f ∈ after → f' ∈ after → k g f = true → k g f' = true → f = f') →
    (∀ g g' f, g ∈ before → g' ∈ before → f ∈ after → k g f = true → k g' f = true → g = g') →
    «对» (fun x y => k x y = true ∨ x = y) (before ++ GrammarLaws.arising k before after)
      (after ++ GrammarLaws.ceasing k before after)
  | [], after, _, _, _, _ => by
    show «对» _ (GrammarLaws.keep (fun f => !(([] : List α).any (fun g => k g f))) after) (after ++ [])
    rw [ListTests.append_nil,
      GrammarLaws.keep_all (p := fun f => !(([] : List α).any fun g => k g f)) after (fun _ _ => rfl)]
    exact «对之自反» (R := fun x y => k x y = true ∨ x = y) (fun _ => Or.inr rfl) after
  | g :: before, after, ⟨gNot, dB⟩, dA, noSplit, noMerge => by
    cases hg : after.any (k g) with
    | false =>
      have cz : GrammarLaws.ceasing k (g :: before) after = g :: GrammarLaws.ceasing k before after := by
        show cond (!(after.any (k g))) (g :: GrammarLaws.ceasing k before after)
          (GrammarLaws.ceasing k before after) = _
        rw [hg]; rfl
      have az : GrammarLaws.arising k (g :: before) after = GrammarLaws.arising k before after :=
        GrammarLaws.keep_congr after fun f m => by
          show (!(k g f || before.any (fun g => k g f))) = !(before.any (fun g => k g f))
          rw [GrammarLaws.any_false_mem hg m]; rfl
      show «对» _ (g :: (before ++ GrammarLaws.arising k (g :: before) after))
        (after ++ GrammarLaws.ceasing k (g :: before) after)
      rw [az, cz]
      exact .cons (b₁ := after) (Or.inr rfl) (GrammarLaws.census_pairs k before after dB dA
        (fun g f f' mg => noSplit g f f' (.tail _ mg))
        (fun g g' f mg mg' => noMerge g g' f (.tail _ mg) (.tail _ mg')))
    | true =>
      match GrammarLaws.any_split hg with
      | ⟨a₁, f, a₂, e, kf⟩ =>
        cases e
        have dA' := GrammarLaws.distinct_removed dA
        have cz : GrammarLaws.ceasing k (g :: before) (a₁ ++ f :: a₂) =
            GrammarLaws.ceasing k before (a₁ ++ a₂) := by
          show cond (!((a₁ ++ f :: a₂).any (k g))) _ (GrammarLaws.ceasing k before (a₁ ++ f :: a₂)) = _
          rw [hg]
          exact GrammarLaws.keep_congr before fun g' m => by
            have off : k g' f = false := by
              cases h : k g' f with
              | false => rfl
              | true =>
                cases noMerge g g' f (.head _) (.tail _ m) (GrammarLaws.mem_middle f a₂ a₁) kf h
                exact absurd m gNot
            rw [GrammarLaws.any_remove off]
        have az : GrammarLaws.arising k (g :: before) (a₁ ++ f :: a₂) =
            GrammarLaws.arising k before (a₁ ++ a₂) := by
          show GrammarLaws.keep _ (a₁ ++ f :: a₂) = GrammarLaws.keep _ (a₁ ++ a₂)
          rw [GrammarLaws.keep_append, GrammarLaws.keep_append]
          show _ ++ cond (!(k g f || before.any (fun g => k g f))) _ _ = _
          rw [kf]
          show GrammarLaws.keep _ a₁ ++ GrammarLaws.keep _ a₂ = _
          rw [← GrammarLaws.keep_append, ← GrammarLaws.keep_append]
          exact GrammarLaws.keep_congr (a₁ ++ a₂) fun x m => by
            have off : k g x = false := by
              cases h : k g x with
              | false => rfl
              | true =>
                cases noSplit g x f (.head _) (GrammarLaws.mem_of_removed m)
                  (GrammarLaws.mem_middle f a₂ a₁) h kf
                exact absurd m dA'.2
            show (!(k g x || before.any (fun g => k g x))) = !(before.any (fun g => k g x))
            rw [off]; rfl
        show «对» _ (g :: (before ++ GrammarLaws.arising k (g :: before) (a₁ ++ f :: a₂)))
          ((a₁ ++ f :: a₂) ++ GrammarLaws.ceasing k (g :: before) (a₁ ++ f :: a₂))
        rw [az, cz, ListTests.append_assoc]
        have IH := GrammarLaws.census_pairs k before (a₁ ++ a₂) dB dA'.1
          (fun g x x' mg mx mx' => noSplit g x x' (.tail _ mg) (GrammarLaws.mem_of_removed mx)
            (GrammarLaws.mem_of_removed mx'))
          (fun g g' x mg mg' mx => noMerge g g' x (.tail _ mg) (.tail _ mg')
            (GrammarLaws.mem_of_removed mx))
        rw [ListTests.append_assoc] at IH
        exact .cons (b₁ := a₁) (b₂ := a₂ ++ GrammarLaws.ceasing k before (a₁ ++ a₂)) (Or.inl kf) IH

variable {R E : «际» α} {k : α → α → Bool}

/-- **The census on continuation.** Units listed once before and after a step, under a continuation
(`«续» R E`, decided by `k`) that fixes successors and predecessors: the units before with those
arising are paired one to one with the units after with those ceasing, each pair a continuation or
the same unit. -/
theorem «定后定前则前并生对后并亡» (dec : ∀ x y, «续» R E x y ↔ k x y = true)
    (before after : List α) (dB : Distinct before) (dA : Distinct after)
    (fixedAfter : «定后» («续» R E)) (fixedBefore : «定前» («续» R E)) :
    «对» (fun x y => «续» R E x y ∨ x = y) (before ++ GrammarLaws.arising k before after)
      (after ++ GrammarLaws.ceasing k before after) :=
  «对之单调» (fun x y r => match r with
      | .inl c => .inl ((dec x y).mpr c)
      | .inr e => .inr e)
    (GrammarLaws.census_pairs k before after dB dA
      (fun g f f' _ _ _ r r' => «定后之逐点».mp fixedAfter g f f' ((dec g f).mpr r) ((dec g f').mpr r'))
      (fun g g' f _ _ _ r r' => «定前之逐点».mp fixedBefore g g' f ((dec g f).mpr r) ((dec g' f).mpr r')))

/-- **Arising is beginning, where the predecessors stand before.** Where every predecessor of a unit
after the step stands before it, the units the census lists as arising are exactly the units after
that begin (`«生»`). -/
theorem «前者在前则所列生者生» (dec : ∀ x y, «续» R E x y ↔ k x y = true) {before after : List α}
    (predecessorsBefore : ∀ x f, f ∈ after → «续» R E x f → x ∈ before) {f : α} :
    f ∈ GrammarLaws.arising k before after ↔ f ∈ after ∧ «生» R E f := by
  constructor
  · intro m
    have h := GrammarLaws.mem_keep.mp m
    refine ⟨h.1, fun ⟨x, c⟩ => ?_⟩
    have off := ListTests.not_true_iff.mp h.2
    have on : before.any (fun g => k g f) = true :=
      GrammarLaws.any_true_of_mem (p := fun g => k g f) (predecessorsBefore x f h.1 c) ((dec x f).mp c)
    exact nomatch off.symm.trans on
  · intro ⟨mf, begins⟩
    refine GrammarLaws.mem_keep.mpr ⟨mf, ListTests.not_true_iff.mpr
      (GrammarLaws.any_false_of (p := fun g => k g f) before fun g _ => ?_)⟩
    cases h : k g f with
    | false => exact h
    | true => exact absurd ⟨g, (dec g f).mpr h⟩ begins

/-- **Ceasing is ending, where the successors stand after.** Where every successor of a unit before
the step stands after it, the units the census lists as ceasing are exactly the units before that
end (`«亡»`). -/
theorem «后者在后则所列亡者亡» (dec : ∀ x y, «续» R E x y ↔ k x y = true) {before after : List α}
    (successorsAfter : ∀ g y, g ∈ before → «续» R E g y → y ∈ after) {g : α} :
    g ∈ GrammarLaws.ceasing k before after ↔ g ∈ before ∧ «亡» R E g := by
  constructor
  · intro m
    have h := GrammarLaws.mem_keep.mp m
    refine ⟨h.1, fun ⟨y, c⟩ => ?_⟩
    have off := ListTests.not_true_iff.mp h.2
    have on : after.any (k g) = true :=
      GrammarLaws.any_true_of_mem (p := k g) (successorsAfter g y h.1 c) ((dec g y).mp c)
    exact nomatch off.symm.trans on
  · intro ⟨mg, ends⟩
    refine GrammarLaws.mem_keep.mpr ⟨mg, ListTests.not_true_iff.mpr
      (GrammarLaws.any_false_of (p := k g) after fun f _ => ?_)⟩
    cases h : k g f with
    | false => rfl
    | true => exact absurd ⟨f, (dec g f).mpr h⟩ ends

/-- A list keeps as many units as a test holds of. -/
theorem GrammarLaws.length_keep (p : α → Bool) : ∀ l : List α,
    (GrammarLaws.keep p l).length = «计» p l
  | [] => rfl
  | x :: l => by
    show (cond (p x) (x :: GrammarLaws.keep p l) (GrammarLaws.keep p l)).length =
      cond (p x) 1 0 + «计» p l
    cases p x with
    | true => exact (congrArg (· + 1) (length_keep p l)).trans (Nat.add_comm _ _)
    | false => exact (length_keep p l).trans (Nat.zero_add _).symm

/-- A list is the units a test holds of with those it fails of. -/
theorem GrammarLaws.count_add_not (p : α → Bool) : ∀ l : List α,
    «计» p l + «计» (fun x => !p x) l = l.length
  | [] => rfl
  | x :: l => by
    show (cond (p x) 1 0 + «计» p l) + (cond (!p x) 1 0 + «计» (fun x => !p x) l) = l.length + 1
    cases p x with
    | true =>
      show (1 + «计» p l) + (0 + «计» (fun x => !p x) l) = l.length + 1
      rw [Nat.zero_add, Nat.add_assoc, count_add_not p l, Nat.add_comm]
    | false =>
      show (0 + «计» p l) + (1 + «计» (fun x => !p x) l) = l.length + 1
      rw [Nat.zero_add, Nat.add_left_comm, count_add_not p l, Nat.add_comm]

/-- Keeping the units a test holds of keeps a list without repetition. -/
theorem GrammarLaws.distinct_keep (p : α → Bool) : ∀ {l : List α}, Distinct l →
    Distinct (GrammarLaws.keep p l)
  | [], _ => trivial
  | x :: l, ⟨fresh, once⟩ => by
    show Distinct (cond (p x) (x :: GrammarLaws.keep p l) (GrammarLaws.keep p l))
    cases p x with
    | true => exact ⟨fun mem => fresh (GrammarLaws.mem_keep.mp mem).1, distinct_keep p once⟩
    | false => exact distinct_keep p once

/-- A unit a test holds of makes its count positive. -/
theorem GrammarLaws.count_pos_of_mem {p : α → Bool} {x : α} {l : List α} (mem : x ∈ l)
    (holds : p x = true) : 0 < «计» p l :=
  match List.append_of_mem mem with
  | ⟨b₁, b₂, split⟩ => by
    rw [split, GrammarLaws.count_insert, holds]
    exact Nat.lt_of_lt_of_le Nat.zero_lt_one (Nat.le_add_right _ _)

/-- A test whose negation fails holds. -/
theorem GrammarLaws.eq_true_of_not_false : ∀ {c : Bool}, (!c) = false → c = true
  | true, _ => rfl
  | false, h => Bool.noConfusion h

/-- **The census of a step, counted, one side**, asking only what its proof uses. Units listed before
and after a step under a continuation (`«续» R E`), those after listed once, no unit before
continuing as two units listed after: where a test `b` fails only of units after with a predecessor
among the units before, as far as can be refuted, and a test `e` holds only of units before that no
unit after continues, the units after with those `e` holds of are at most the units before with
those `b` holds of. No decision of identity is used: a predecessor is found under a double negation,
the conclusion being a decided comparison of numbers. -/
theorem GrammarLaws.census_le {b e : α → Bool} {before after : List α} (dA : Distinct after)
    (noSplit : ∀ x y y', x ∈ before → y ∈ after → y' ∈ after → «续» R E x y → «续» R E x y' → y = y')
    (arising : ∀ y, y ∈ after → b y = false → ¬¬ ∃ x, x ∈ before ∧ «续» R E x y)
    (ceasing : ∀ x, x ∈ before → e x = true → ∀ y, y ∈ after → ¬ «续» R E x y) :
    after.length + «计» e before ≤ before.length + «计» b after :=
  have fewer : (GrammarLaws.keep (fun y => !b y) after).length ≤
      (GrammarLaws.keep (fun x => !e x) before).length :=
    Decidable.of_not_not fun more =>
      not_not_all (P := fun y => ∃ x, x ∈ GrammarLaws.keep (fun x => !e x) before ∧ «续» R E x y)
        (fun y my none =>
          have h := GrammarLaws.mem_keep.mp my
          arising y h.1 (ListTests.not_true_iff.mp h.2) fun ⟨x, mx, c⟩ =>
            none ⟨x, GrammarLaws.mem_keep.mpr ⟨mx, ListTests.not_true_iff.mpr
              (match he : e x with
               | false => rfl
               | true => absurd c (ceasing x mx he y h.1))⟩, c⟩)
        fun all => more (length_le_of_matched
          (S := fun y x => x ∈ GrammarLaws.keep (fun x => !e x) before ∧ «续» R E x y)
          (GrammarLaws.distinct_keep _ dA)
          (fun y my => match all y my with | ⟨x, mx, c⟩ => ⟨x, mx, mx, c⟩)
          fun y y' x my my' h h' => noSplit x y y' (GrammarLaws.mem_keep.mp h.1).1
            (GrammarLaws.mem_keep.mp my).1 (GrammarLaws.mem_keep.mp my').1 h.2 h'.2)
  calc after.length + «计» e before
      = («计» b after + (GrammarLaws.keep (fun y => !b y) after).length) + «计» e before := by
        rw [GrammarLaws.length_keep, GrammarLaws.count_add_not]
    _ ≤ («计» b after + (GrammarLaws.keep (fun x => !e x) before).length) + «计» e before :=
        Nat.add_le_add_right (Nat.add_le_add_left fewer _) _
    _ = before.length + «计» b after := by
        rw [GrammarLaws.length_keep, Nat.add_assoc, Nat.add_comm («计» (fun x => !e x) before),
          GrammarLaws.count_add_not, Nat.add_comm]

/-- **The census of a step, counted, one side**, under a continuation that fixes successors
(`GrammarLaws.census_le`, the fixed successor read at the listed units). `«定后»` is more than the
proof uses, which is no split among the units listed. -/
theorem «定后则后并亡不过前并生» {b e : α → Bool} {before after : List α}
    (dA : Distinct after) (fixedAfter : «定后» («续» R E))
    (arising : ∀ y, y ∈ after → b y = false → ¬¬ ∃ x, x ∈ before ∧ «续» R E x y)
    (ceasing : ∀ x, x ∈ before → e x = true → ∀ y, y ∈ after → ¬ «续» R E x y) :
    after.length + «计» e before ≤ before.length + «计» b after :=
  GrammarLaws.census_le dA (fun x y y' _ _ _ c c' => «定后之逐点».mp fixedAfter x y y' c c')
    arising ceasing

/-- **Its mirror**, the same law at the converse, asking only what its proof uses. The units before
listed once, no two units listed before continuing as one unit after: where `e` fails only of units
before with a successor among the units after, as far as can be refuted, and `b` holds only of units
after that no unit before continues, the units before with those `b` holds of are at most the units
after with those `e` holds of. -/
theorem GrammarLaws.census_le_converse {b e : α → Bool} {before after : List α}
    (dB : Distinct before)
    (noMerge : ∀ x x' y, x ∈ before → x' ∈ before → y ∈ after → «续» R E x y → «续» R E x' y → x = x')
    (ceasing : ∀ x, x ∈ before → e x = false → ¬¬ ∃ y, y ∈ after ∧ «续» R E x y)
    (arising : ∀ y, y ∈ after → b y = true → ∀ x, x ∈ before → ¬ «续» R E x y) :
    before.length + «计» b after ≤ after.length + «计» e before :=
  GrammarLaws.census_le (R := «逆» R) (E := «逆» E) (b := e) (e := b)
    (before := after) (after := before) dB
    (fun y x x' my mx mx' c c' => noMerge x x' y mx mx' my c c')
    ceasing arising

/-- **Its mirror** under a continuation that fixes predecessors (`GrammarLaws.census_le_converse`,
merging nothing read at the listed units). -/
theorem «定前则前并生不过后并亡» {b e : α → Bool} {before after : List α}
    (dB : Distinct before) (fixedBefore : «定前» («续» R E))
    (ceasing : ∀ x, x ∈ before → e x = false → ¬¬ ∃ y, y ∈ after ∧ «续» R E x y)
    (arising : ∀ y, y ∈ after → b y = true → ∀ x, x ∈ before → ¬ «续» R E x y) :
    before.length + «计» b after ≤ after.length + «计» e before :=
  GrammarLaws.census_le_converse dB
    (fun x x' y _ _ _ c c' => «定前之逐点».mp fixedBefore x x' y c c') ceasing arising

/-- **The two halves meet in the paired census's count**, asking only what the proof uses: the
hypotheses of the paired census (`GrammarLaws.census_pairs`), read on the continuation decided by
`k`. The units after with those ceasing are as many as the units before with those arising. The
pairing says more than the count; the count asks neither `k` nor the predecessors' or successors'
lists, only the tests. -/
theorem GrammarLaws.census_count (dec : ∀ x y, «续» R E x y ↔ k x y = true)
    (before after : List α) (dB : Distinct before) (dA : Distinct after)
    (noSplit : ∀ x y y', x ∈ before → y ∈ after → y' ∈ after → «续» R E x y → «续» R E x y' → y = y')
    (noMerge : ∀ x x' y, x ∈ before → x' ∈ before → y ∈ after → «续» R E x y → «续» R E x' y → x = x') :
    after.length + (GrammarLaws.ceasing k before after).length =
      before.length + (GrammarLaws.arising k before after).length :=
  have one := GrammarLaws.census_le (b := fun y => !(before.any fun g => k g y))
    (e := fun x => !(after.any (k x))) dA noSplit
    (fun y _ off none => match GrammarLaws.any_split (GrammarLaws.eq_true_of_not_false off) with
      | ⟨a₁, x, a₂, split, kx⟩ =>
        none ⟨x, split ▸ GrammarLaws.mem_middle x a₂ a₁, (dec x y).mpr kx⟩)
    (fun x _ on y my c => Bool.noConfusion ((GrammarLaws.any_false_mem
        (ListTests.not_true_iff.mp on) my).symm.trans ((dec x y).mp c)))
  have other := GrammarLaws.census_le_converse (b := fun y => !(before.any fun g => k g y))
    (e := fun x => !(after.any (k x))) dB noMerge
    (fun x _ off none => match GrammarLaws.any_split (GrammarLaws.eq_true_of_not_false off) with
      | ⟨a₁, y, a₂, split, ky⟩ =>
        none ⟨y, split ▸ GrammarLaws.mem_middle y a₂ a₁, (dec x y).mpr ky⟩)
    (fun y _ on x mx c => Bool.noConfusion ((GrammarLaws.any_false_mem (p := fun g => k g y)
        (ListTests.not_true_iff.mp on) mx).symm.trans ((dec x y).mp c)))
  by
    show after.length + (GrammarLaws.keep _ before).length =
      before.length + (GrammarLaws.keep _ after).length
    rw [GrammarLaws.length_keep, GrammarLaws.length_keep]
    exact Nat.le_antisymm one other

/-- **The two halves meet in the paired census's count**, under the paired census
(`«定后定前则前并生对后并亡»`), the tests read off `k` (`GrammarLaws.census_count`). -/
theorem «定后定前则前并生与后并亡同数» (dec : ∀ x y, «续» R E x y ↔ k x y = true)
    (before after : List α) (dB : Distinct before) (dA : Distinct after)
    (fixedAfter : «定后» («续» R E)) (fixedBefore : «定前» («续» R E)) :
    after.length + (GrammarLaws.ceasing k before after).length =
      before.length + (GrammarLaws.arising k before after).length :=
  GrammarLaws.census_count dec before after dB dA
    (fun x y y' _ _ _ c c' => «定后之逐点».mp fixedAfter x y y' c c')
    (fun x x' y _ _ _ c c' => «定前之逐点».mp fixedBefore x x' y c c')

/-! #### Ends on lines at stages

The units are occurrences at stages: a region `P`, each step of the continuation one stage on
(`τ y = τ x + 1`). A list covers the units at a stage (所覆) where it contains every unit of the
region at that stage. Traced back from a list covering a stage, the lines of the region's units
carry the count of ends on lines (`«线亡不过所列»`) to the region: with nothing beginning in a
stretch after the list's stage, the units ending in it number at most the list. Its mirror traces
on to a list covering a later stage. No decision is used in either; the decided and run forms decide
beginnings (endings) only after (from) the list's stage. -/

section Stages

variable {τ : α → Nat} {P : α → Prop}

/-- The stage grows by the number of steps. -/
theorem GrammarLaws.stage_steps (stage : ∀ x y, «续» R E x y → τ y = τ x + 1) :
    ∀ (n : Nat) {x y : α}, «迭» («续» R E) n x y → τ y = τ x + n
  | 0, _, _, same => Eq.symm (congrArg τ same)
  | n + 1, x, _, ⟨w, c, rest⟩ =>
    (GrammarLaws.stage_steps stage n rest).trans
      ((congrArg (· + n) (stage x w c)).trans (Nat.succ_add (τ x) n))

/-- In a region nothing outside continues into, no unit continuing as two units of the region fixes
successors on the lines to listed units. -/
theorem GrammarLaws.fixed_of_noSplit (back : «闭» («逆» («续» R E)) P)
    (noSplit : ∀ v b b', P b → P b' → «续» R E v b → «续» R E v b' → b = b')
    {L D : List α} (inD : ∀ x, x ∈ D → P x) :
    ∀ v b b', (∃ m, m ∈ L ∧ «所闭» («续» R E) m v) →
      (∃ x, x ∈ D ∧ «所闭» («续» R E) b x) → (∃ x, x ∈ D ∧ «所闭» («续» R E) b' x) →
      «续» R E v b → «续» R E v b' → b = b' :=
  fun v b b' _ ⟨x, mx, toX⟩ ⟨x', mx', toX'⟩ =>
    noSplit v b b' («闭含所闭» back (inD x mx) («所闭之逆».mpr toX))
      («闭含所闭» back (inD x' mx') («所闭之逆».mpr toX'))

/-- Any number of marked units at distinct stages from `M`, all before some stage. -/
theorem GrammarLaws.found_cons {marks : α → Prop} {M U : Nat} {x : α} {D : List α}
    (from_ : M ≤ U) (later : U ≤ τ x) (mx : marks x) (dD : Distinct D)
    (all : ∀ y, y ∈ D → M ≤ τ y ∧ τ y < U ∧ marks y) :
    Distinct (x :: D) ∧ M ≤ τ x + 1 ∧ ∀ y, y ∈ x :: D → M ≤ τ y ∧ τ y < τ x + 1 ∧ marks y :=
  ⟨⟨fun mem => Nat.lt_irrefl (τ x) (Nat.lt_of_lt_of_le (all x mem).2.1 later), dD⟩,
   Nat.le_trans from_ (Nat.le_trans later (Nat.le_succ _)),
   fun y mem => match ListTests.mem_cons_iff.mp mem with
    | .inl same => Eq.subst (motive := fun v => M ≤ τ v ∧ τ v < τ x + 1 ∧ marks v) same.symm
        ⟨Nat.le_trans from_ later, Nat.lt_succ_self _, mx⟩
    | .inr mem => ⟨(all y mem).1,
        Nat.lt_of_lt_of_le (all y mem).2.1 (Nat.le_trans later (Nat.le_succ _)), (all y mem).2.2⟩⟩

/-- Units marked at arbitrarily late stages give any number of them at distinct stages from any
stage, all before some stage. -/
theorem GrammarLaws.found {marks : α → Prop} (each : ∀ M, ∃ x, M ≤ τ x ∧ marks x) :
    ∀ n M, ∃ D : List α, ∃ U, Distinct D ∧ D.length = n ∧ M ≤ U ∧
      ∀ x, x ∈ D → M ≤ τ x ∧ τ x < U ∧ marks x
  | 0, M => ⟨[], M, trivial, rfl, Nat.le_refl M, fun _ mem => nomatch mem⟩
  | n + 1, M => match GrammarLaws.found each n M with
    | ⟨D, U, dD, len, from_, all⟩ => match each U with
      | ⟨x, later, mx⟩ => match GrammarLaws.found_cons from_ later mx dD all with
        | ⟨dD', from_', all'⟩ => ⟨x :: D, τ x + 1, dD', congrArg Nat.succ len, from_', all'⟩

/-- The same where after every stage a later marked unit is only not refuted. -/
theorem GrammarLaws.found_unrefuted {marks : α → Prop} (each : ∀ M, ¬¬ ∃ x, M ≤ τ x ∧ marks x) :
    ∀ n M, ¬¬ ∃ D : List α, ∃ U, Distinct D ∧ D.length = n ∧ M ≤ U ∧
      ∀ x, x ∈ D → M ≤ τ x ∧ τ x < U ∧ marks x
  | 0, M => fun no => no ⟨[], M, trivial, rfl, Nat.le_refl M, fun _ mem => nomatch mem⟩
  | n + 1, M => fun no => GrammarLaws.found_unrefuted each n M fun ⟨D, U, dD, len, from_, all⟩ =>
    each U fun ⟨x, later, mx⟩ => match GrammarLaws.found_cons from_ later mx dD all with
      | ⟨dD', from_', all'⟩ => no ⟨x :: D, τ x + 1, dD', congrArg Nat.succ len, from_', all'⟩

/-- Found once, or found for every member of a list. -/
theorem GrammarLaws.found_or_all {A : Prop} {B : α → Prop} :
    ∀ {D : List α}, (∀ x, x ∈ D → A ∨ B x) → A ∨ ∀ x, x ∈ D → B x
  | [], _ => .inr fun _ mem => nomatch mem
  | x :: D, each => match each x (.head D) with
    | .inl a => .inl a
    | .inr bx => match GrammarLaws.found_or_all (D := D) (fun y mem => each y (.tail x mem)) with
      | .inl a => .inl a
      | .inr all => .inr fun y mem => match ListTests.mem_cons_iff.mp mem with
        | .inl same => Eq.subst (motive := B) same.symm bx
        | .inr mem => all y mem

/-- Tracing back, decided: a unit `k` stages after `N`, beginning or predecessor decided after `N`,
gives a beginning after `N` or the line from a member of a list covering the units at `N`. -/
theorem GrammarLaws.trace (stage : ∀ x y, «续» R E x y → τ y = τ x + 1)
    (back : «闭» («逆» («续» R E)) P)
    {N : Nat} {L : List α} (covers : ∀ x, P x → τ x = N → x ∈ L)
    (decided : ∀ y, P y → N < τ y → «生» R E y ∨ «有前» R E y) :
    ∀ k y, P y → τ y = N + k →
      (∃ z, N < τ z ∧ P z ∧ «生» R E z) ∨ ∃ m, m ∈ L ∧ «所闭» («续» R E) m y
  | 0, y, h, at_ => .inr ⟨y, covers y h at_, «所闭之自反» _ y⟩
  | k + 1, y, h, at_ =>
    have late : N < τ y := Eq.subst (motive := (N < ·)) at_.symm
      (Nat.lt_succ_of_le (Nat.le_add_right N k))
    match decided y h late with
    | .inl b => .inl ⟨y, late, h, b⟩
    | .inr ⟨x, c⟩ =>
      match GrammarLaws.trace stage back covers decided k x (back y x h c)
          (Nat.succ.inj ((stage x y c).symm.trans at_)) with
      | .inl found => .inl found
      | .inr ⟨m, mm, r⟩ => .inr ⟨m, mm, «所闭之传递» r («缘在所闭» c)⟩

/-- Tracing back, undecided: where nothing begins after `N` up to its stage, a unit's line from a
member of a list covering the units at `N` is not refuted. -/
theorem GrammarLaws.trace_unrefuted (stage : ∀ x y, «续» R E x y → τ y = τ x + 1)
    (back : «闭» («逆» («续» R E)) P)
    {N : Nat} {L : List α} (covers : ∀ x, P x → τ x = N → x ∈ L) :
    ∀ k y, P y → τ y = N + k →
      (∀ z, P z → N < τ z → τ z ≤ N + k → ¬ «生» R E z) →
      ¬¬ ∃ m, m ∈ L ∧ «所闭» («续» R E) m y
  | 0, y, h, at_, _ => fun no => no ⟨y, covers y h at_, «所闭之自反» _ y⟩
  | k + 1, y, h, at_, quiet => fun no =>
    quiet y h (Eq.subst (motive := (N < ·)) at_.symm (Nat.lt_succ_of_le (Nat.le_add_right N k)))
      (Nat.le_of_eq at_) fun ⟨x, c⟩ =>
      GrammarLaws.trace_unrefuted stage back covers k x (back y x h c)
        (Nat.succ.inj ((stage x y c).symm.trans at_))
        (fun z hz late upto => quiet z hz late (Nat.le_succ_of_le upto))
        fun ⟨m, mm, r⟩ => no ⟨m, mm, «所闭之传递» r («缘在所闭» c)⟩

/-- **With nothing beginning in a stretch, what ends in it is at most what covers its start
(间无生则间亡不过所覆).** In a region nothing outside continues into, each step one stage on, no
unit continuing as two units of the region, with a list covering the units at stage `N` (所覆) and
no unit beginning at a stage in `(N, U)`: distinct units ending at stages in `[N, U)` number at most
the list. No decision is used. -/
theorem «间无生则间亡不过所覆» (stage : ∀ x y, «续» R E x y → τ y = τ x + 1)
    (back : «闭» («逆» («续» R E)) P)
    (noSplit : ∀ v b b', P b → P b' → «续» R E v b → «续» R E v b' → b = b')
    {N U : Nat} {L : List α} (covers : ∀ x, P x → τ x = N → x ∈ L)
    (quiet : ∀ z, P z → N < τ z → τ z < U → ¬ «生» R E z)
    {D : List α} (dD : Distinct D)
    (ends : ∀ x, x ∈ D → N ≤ τ x ∧ τ x < U ∧ P x ∧ «亡» R E x) : D.length ≤ L.length :=
  «线亡不过所列之未否» dD (GrammarLaws.fixed_of_noSplit back noSplit fun x mx => (ends x mx).2.2.1)
    (fun x mx => match le_dest (ends x mx).1 with
      | ⟨k, at_⟩ => GrammarLaws.trace_unrefuted stage back covers k x (ends x mx).2.2.1 at_
          fun z hz late upto => quiet z hz late
            (Nat.lt_of_le_of_lt upto (Eq.subst (motive := (· < U)) at_ (ends x mx).2.1)))
    fun x mx => (ends x mx).2.2.2

/-- **Endings recurring after a covered stage give a beginning after it (所覆后亡屡则有生).** In the
frame of `«间无生则间亡不过所覆»`, with beginning or predecessor decided after `N`: where endings
recur, something begins after `N`. -/
theorem «所覆后亡屡则有生» (stage : ∀ x y, «续» R E x y → τ y = τ x + 1)
    (back : «闭» («逆» («续» R E)) P)
    (noSplit : ∀ v b b', P b → P b' → «续» R E v b → «续» R E v b' → b = b')
    {N : Nat} {L : List α} (covers : ∀ x, P x → τ x = N → x ∈ L)
    (decided : ∀ y, P y → N < τ y → «生» R E y ∨ «有前» R E y)
    (ending : ∀ M, ∃ x, M ≤ τ x ∧ P x ∧ «亡» R E x) :
    ∃ y, N < τ y ∧ P y ∧ «生» R E y :=
  match GrammarLaws.found (marks := fun x => P x ∧ «亡» R E x) ending (L.length + 1) N with
  | ⟨_, _, dD, len, _, all⟩ =>
    match GrammarLaws.found_or_all (A := ∃ z, N < τ z ∧ P z ∧ «生» R E z)
        (B := fun x => ∃ m, m ∈ L ∧ «所闭» («续» R E) m x)
        (fun x mx => match le_dest (all x mx).1 with
          | ⟨k, at_⟩ => GrammarLaws.trace stage back covers decided k x (all x mx).2.2.1 at_) with
    | .inl found => found
    | .inr reached => (Nat.not_succ_le_self L.length (Nat.le_trans (Nat.le_of_eq len.symm)
        («线亡不过所列» dD (GrammarLaws.fixed_of_noSplit back noSplit fun x mx => (all x mx).2.2.1)
          reached fun x mx => (all x mx).2.2.2))).elim

/-- **With covered stages arbitrarily late, endings recurring give beginnings recurring
(有覆而亡屡则生屡).** Lists covering the units at arbitrarily late stages, beginning or predecessor
decided after `T`. -/
theorem «有覆而亡屡则生屡» (stage : ∀ x y, «续» R E x y → τ y = τ x + 1)
    (back : «闭» («逆» («续» R E)) P)
    (noSplit : ∀ v b b', P b → P b' → «续» R E v b → «续» R E v b' → b = b')
    (covered : ∀ M, ∃ N, ∃ L : List α, M ≤ N ∧ ∀ x, P x → τ x = N → x ∈ L)
    {T : Nat} (decided : ∀ y, P y → T < τ y → «生» R E y ∨ «有前» R E y)
    (ending : ∀ M, ∃ x, M ≤ τ x ∧ P x ∧ «亡» R E x) :
    ∀ M, ∃ y, M < τ y ∧ P y ∧ «生» R E y :=
  fun M => match covered (M + T) with
  | ⟨_, _, later, covers⟩ => match «所覆后亡屡则有生» stage back noSplit covers
      (fun y h late => decided y h
        (Nat.lt_of_le_of_lt (Nat.le_trans (Nat.le_add_left T M) later) late)) ending with
    | ⟨z, late, h, b⟩ =>
      ⟨z, Nat.lt_of_le_of_lt (Nat.le_trans (Nat.le_add_right M T) later) late, h, b⟩

/-- **Endings recurring after a covered stage leave a beginning after it unrefuted
(所覆后亡屡则生未否).** With a list covering the units at `N` and endings at arbitrarily late
stages each not refuted, a beginning after `N` is not refuted: `«间无生则间亡不过所覆»`, endings
found at distinct stages. No decision is used. -/
theorem «所覆后亡屡则生未否» (stage : ∀ x y, «续» R E x y → τ y = τ x + 1)
    (back : «闭» («逆» («续» R E)) P)
    (noSplit : ∀ v b b', P b → P b' → «续» R E v b → «续» R E v b' → b = b')
    {N : Nat} {L : List α} (covers : ∀ x, P x → τ x = N → x ∈ L)
    (ending : ∀ M, ¬¬ ∃ x, M ≤ τ x ∧ P x ∧ «亡» R E x) :
    ¬¬ ∃ y, N < τ y ∧ P y ∧ «生» R E y :=
  fun none => GrammarLaws.found_unrefuted (marks := fun x => P x ∧ «亡» R E x) ending
    (L.length + 1) N fun ⟨_, _, dD, len, _, all⟩ =>
    Nat.not_succ_le_self L.length (Nat.le_trans (Nat.le_of_eq len.symm)
      («间无生则间亡不过所覆» stage back noSplit covers (fun z hz late _ b => none ⟨z, late, hz, b⟩)
        dD all))

/-- **With covered stages arbitrarily late, endings recurring do not let beginnings stop
(有覆而亡屡则生不止)**, endings recurring as far as can be refuted. No decision is used. -/
theorem «有覆而亡屡则生不止» (stage : ∀ x y, «续» R E x y → τ y = τ x + 1)
    (back : «闭» («逆» («续» R E)) P)
    (noSplit : ∀ v b b', P b → P b' → «续» R E v b → «续» R E v b' → b = b')
    (covered : ∀ M, ∃ N, ∃ L : List α, M ≤ N ∧ ∀ x, P x → τ x = N → x ∈ L)
    (ending : ∀ M, ¬¬ ∃ x, M ≤ τ x ∧ P x ∧ «亡» R E x) :
    ¬ ∃ M, ∀ y, M < τ y → P y → ¬ «生» R E y :=
  fun ⟨M, quiet⟩ => match covered M with
  | ⟨_, _, later, covers⟩ => «所覆后亡屡则生未否» stage back noSplit covers ending
      fun ⟨y, late, h, b⟩ => quiet y (Nat.lt_of_le_of_lt later late) h b

/-- Tracing on, undecided: in a region nothing in it continues out of, with nothing ending at a
stage in `[N, U)`, a unit at a stage from `N` has `k` steps after it wherever its stage with `k` is
at most `U`, as far as can be refuted. -/
theorem GrammarLaws.onward_within (stage : ∀ x y, «续» R E x y → τ y = τ x + 1)
    (on : «闭» («续» R E) P)
    {N U : Nat} (quiet : ∀ z, P z → N ≤ τ z → τ z < U → ¬ «亡» R E z)
    {x : α} (from_ : N ≤ τ x) (h : P x) : ∀ k, τ x + k ≤ U → ¬¬ ∃ y, «迭» («续» R E) k x y :=
  fun k upto => «或有后则或迭» k fun j y below steps =>
    have at_ : τ y = τ x + j := GrammarLaws.stage_steps stage j steps
    quiet y («闭含所闭» on h («所闭当且仅当有迭».mpr ⟨j, steps⟩))
      (Nat.le_trans from_ (Eq.subst (motive := (τ x ≤ ·)) at_.symm (Nat.le_add_right _ _)))
      (Eq.subst (motive := (· < U)) at_.symm
        (Nat.lt_of_lt_of_le (Nat.add_lt_add_left below _) upto))

/-- **Its mirror: with nothing ending in a stretch, what begins in it is at most what covers its
end (间无亡则间生不过所覆).** In a region nothing in it continues out of, each step one stage on, no
two units of the region continuing as one, with a list covering the units at stage `U` and no unit
ending at a stage in `[N, U)`: distinct units beginning at stages in `[N, U]` number at most the
list. No decision is used. -/
theorem «间无亡则间生不过所覆» (stage : ∀ x y, «续» R E x y → τ y = τ x + 1)
    (on : «闭» («续» R E) P)
    (noMerge : ∀ v a a', P a → P a' → «续» R E a v → «续» R E a' v → a = a')
    {N U : Nat} {L : List α} (covers : ∀ x, P x → τ x = U → x ∈ L)
    (quiet : ∀ z, P z → N ≤ τ z → τ z < U → ¬ «亡» R E z)
    {D : List α} (dD : Distinct D)
    (begins : ∀ x, x ∈ D → N ≤ τ x ∧ τ x ≤ U ∧ P x ∧ «生» R E x) : D.length ≤ L.length :=
  «线生不过所列之未否» dD
    (fun v a a' _ ⟨x, mx, toA⟩ ⟨x', mx', toA'⟩ => noMerge v a a'
      («闭含所闭» on (begins x mx).2.2.1 toA) («闭含所闭» on (begins x' mx').2.2.1 toA'))
    (fun x mx no => match le_dest (begins x mx).2.1 with
      | ⟨k, at_⟩ => GrammarLaws.onward_within stage on quiet (begins x mx).1 (begins x mx).2.2.1 k
          (Nat.le_of_eq at_.symm) fun ⟨y, steps⟩ => no ⟨y, covers y
            («闭含所闭» on (begins x mx).2.2.1 («所闭当且仅当有迭».mpr ⟨k, steps⟩))
            ((GrammarLaws.stage_steps stage k steps).trans at_.symm),
            «所闭当且仅当有迭».mpr ⟨k, steps⟩⟩)
    fun x mx => (begins x mx).2.2.2

/-- **With bounded covers, beginnings recurring do not let endings stop (有界覆而生屡则亡不止).**
Lists of at most `K` covering the units at every stage from `T`, beginnings at arbitrarily late
stages: `«间无亡则间生不过所覆»`, beginnings found at distinct stages. No decision is used. -/
theorem «有界覆而生屡则亡不止» (stage : ∀ x y, «续» R E x y → τ y = τ x + 1)
    (on : «闭» («续» R E) P)
    (noMerge : ∀ v a a', P a → P a' → «续» R E a v → «续» R E a' v → a = a')
    {K T : Nat}
    (bounded : ∀ S, T ≤ S → ∃ L : List α, L.length ≤ K ∧ ∀ x, P x → τ x = S → x ∈ L)
    (beginning : ∀ M, ∃ x, M ≤ τ x ∧ P x ∧ «生» R E x) :
    ¬ ∃ N, ∀ x, N ≤ τ x → P x → ¬ «亡» R E x :=
  fun ⟨N, quiet⟩ =>
    match GrammarLaws.found (marks := fun x => P x ∧ «生» R E x) beginning (K + 1) (N + T) with
    | ⟨_, U, dD, len, from_, all⟩ => match bounded U (Nat.le_trans (Nat.le_add_left T N) from_) with
      | ⟨_, short, covers⟩ => Nat.not_succ_le_self K (Nat.le_trans (Nat.le_of_eq len.symm)
          (Nat.le_trans («间无亡则间生不过所覆» (N := N + T) stage on noMerge covers
            (fun z hz late _ => quiet z (Nat.le_trans (Nat.le_add_right N T) late) hz) dD
            fun x mx => ⟨(all x mx).1, Nat.le_of_lt (all x mx).2.1, (all x mx).2.2⟩) short))

/-- Tracing on, decided: from a unit at a stage from `N`, ending or successor decided from `N`, an
ending from `N` on, or `k` steps. -/
theorem GrammarLaws.trace_on (stage : ∀ x y, «续» R E x y → τ y = τ x + 1)
    (on : «闭» («续» R E) P)
    {N : Nat} (decided : ∀ x, P x → N ≤ τ x → «亡» R E x ∨ «有后» R E x) :
    ∀ k x, P x → N ≤ τ x →
      (∃ z, N ≤ τ z ∧ P z ∧ «亡» R E z) ∨ ∃ y, «迭» («续» R E) k x y
  | 0, x, _, _ => .inr ⟨x, rfl⟩
  | k + 1, x, h, from_ => match decided x h from_ with
    | .inl en => .inl ⟨x, from_, h, en⟩
    | .inr ⟨w, c⟩ =>
      match GrammarLaws.trace_on stage on decided k w (on x w h c)
          (Nat.le_trans from_ (Nat.le_of_lt (Eq.subst (motive := (τ x < ·)) (stage x w c).symm
            (Nat.lt_succ_self _)))) with
      | .inl found => .inl found
      | .inr ⟨y, steps⟩ => .inr ⟨y, w, c, steps⟩

/-- **With bounded covers, beginnings recurring give endings recurring (有界覆而生屡则亡屡)**, ending
or successor decided from `T`. -/
theorem «有界覆而生屡则亡屡» (stage : ∀ x y, «续» R E x y → τ y = τ x + 1)
    (on : «闭» («续» R E) P)
    (noMerge : ∀ v a a', P a → P a' → «续» R E a v → «续» R E a' v → a = a')
    {K T : Nat}
    (bounded : ∀ S, T ≤ S → ∃ L : List α, L.length ≤ K ∧ ∀ x, P x → τ x = S → x ∈ L)
    (decided : ∀ x, P x → T ≤ τ x → «亡» R E x ∨ «有后» R E x)
    (beginning : ∀ M, ∃ x, M ≤ τ x ∧ P x ∧ «生» R E x) :
    ∀ N, ∃ x, N ≤ τ x ∧ P x ∧ «亡» R E x :=
  fun N =>
    match GrammarLaws.found (marks := fun x => P x ∧ «生» R E x) beginning (K + 1) (N + T) with
    | ⟨D, U, dD, len, from_, all⟩ => match bounded U (Nat.le_trans (Nat.le_add_left T N) from_) with
      | ⟨L, short, covers⟩ =>
        match GrammarLaws.found_or_all (A := ∃ z, N + T ≤ τ z ∧ P z ∧ «亡» R E z)
            (B := fun x => ∃ m, m ∈ L ∧ «所闭» («续» R E) x m) (D := D)
            (fun x mx => match le_dest (Nat.le_of_lt (all x mx).2.1) with
              | ⟨k, at_⟩ => match GrammarLaws.trace_on (N := N + T) stage on
                  (fun x h from_ => decided x h (Nat.le_trans (Nat.le_add_left T N) from_))
                  k x (all x mx).2.2.1 (all x mx).1 with
                | .inl found => .inl found
                | .inr ⟨y, steps⟩ => .inr ⟨y, covers y
                    («闭含所闭» on (all x mx).2.2.1 («所闭当且仅当有迭».mpr ⟨k, steps⟩))
                    ((GrammarLaws.stage_steps stage k steps).trans at_.symm),
                    «所闭当且仅当有迭».mpr ⟨k, steps⟩⟩) with
        | .inl ⟨z, from_, h, en⟩ => ⟨z, Nat.le_trans (Nat.le_add_right N T) from_, h, en⟩
        | .inr reaching => (Nat.not_succ_le_self K (Nat.le_trans (Nat.le_of_eq len.symm)
            (Nat.le_trans («线生不过所列» dD
              (fun v a a' _ ⟨x, mx, toA⟩ ⟨x', mx', toA'⟩ => noMerge v a a'
                («闭含所闭» on (all x mx).2.2.1 toA) («闭含所闭» on (all x' mx').2.2.1 toA'))
              reaching fun x mx => (all x mx).2.2.2) short))).elim

end Stages

theorem GrammarLaws.pair_eq {β : Type u} : ∀ {x y : Nat × β}, x.1 = y.1 → x.2 = y.2 → x = y
  | (_, _), (_, _), rfl, rfl => rfl

/-- A test over the units listed after each stage of a stretch: some unit passes after some stage,
or none after any. The count (`«计»`) decides each stage. -/
theorem GrammarLaws.stage_search (b : α → Bool) (u : Nat → List α) (M : Nat) : ∀ n,
    (∃ t, M ≤ t ∧ t < M + n ∧ ∃ y, y ∈ u (t + 1) ∧ b y = true) ∨
      ∀ t, M ≤ t → t < M + n → ∀ y, y ∈ u (t + 1) → b y ≠ true
  | 0 => .inr fun t lo hi _ _ _ => Nat.lt_irrefl t (Nat.lt_of_lt_of_le hi lo)
  | n + 1 => match GrammarLaws.stage_search b u M n with
    | .inl ⟨t, lo, hi, found⟩ => .inl ⟨t, lo, Nat.lt_succ_of_lt hi, found⟩
    | .inr nothing => match h : «计» b (u (M + n + 1)) with
      | 0 => .inr fun t lo hi y my passes => match Nat.lt_or_ge t (M + n) with
        | .inl below => nothing t lo below y my passes
        | .inr above => Nat.lt_irrefl 0 (Eq.subst (motive := fun c => 0 < c) h
            (GrammarLaws.count_pos_of_mem (Eq.subst (motive := fun s => y ∈ u (s + 1))
              (Nat.le_antisymm (Nat.le_of_lt_succ hi) above) my) passes))
      | k + 1 => match GrammarLaws.split_of_count_pos
          (Eq.subst (motive := fun c => 0 < c) h.symm (Nat.zero_lt_succ k)) with
        | ⟨b₁, y, b₂, split, passes⟩ => .inl ⟨M + n, Nat.le_add_right M n, Nat.lt_succ_self _, y,
            split ▸ GrammarLaws.mem_middle y b₂ b₁, passes⟩

/-- **The census of a run**, asking only what its proof uses. Units listed at each step of a run
under a continuation, from step `T` on: no unit listed before a step continuing as two units listed
after it, every predecessor of a unit listed after a step listed before it, and the root's beginnings
(`«生»`) decided on the units listed after a step by a test. Where endings recur among the listed
units (`«屡»`), beginnings recur among the units listed after a step. The units read as occurrences
`(t, x)` at stages, each step one stage on; the list at a stage covers it, so
`«间无生则间亡不过所覆»` applies, and the test decides a finite search (`GrammarLaws.stage_search`). -/
theorem GrammarLaws.census_run {b : α → Bool} {u : Nat → List α} {T : Nat}
    (noSplit : ∀ t, T ≤ t → ∀ x y y', x ∈ u t → y ∈ u (t + 1) → y' ∈ u (t + 1) →
      «续» R E x y → «续» R E x y' → y = y')
    (predecessorsBefore : ∀ t, T ≤ t → ∀ x y, y ∈ u (t + 1) → «续» R E x y → x ∈ u t)
    (begins : ∀ t, T ≤ t → ∀ y, y ∈ u (t + 1) → (b y = true ↔ «生» R E y))
    (ending : «屡» (fun before _ => ∃ x, x ∈ before ∧ «亡» R E x) u) :
    «屡» (fun _ after => ∃ y, y ∈ after ∧ «生» R E y) u :=
  fun N =>
  let R' : «际» (Nat × α) := fun x y => y.1 = x.1 + 1 ∧ «续» R E x.2 y.2
  let E' : «际» (Nat × α) := fun x y => T ≤ x.1 ∧ x.2 ∈ u x.1 ∧ y.2 ∈ u y.1
  let P' : Nat × α → Prop := fun x => T ≤ x.1 ∧ x.2 ∈ u x.1
  let N' := N + T
  let L := (u N').map (fun x => (N', x))
  have stage : ∀ x y, «续» R' E' x y → y.1 = x.1 + 1 := fun _ _ c => c.1.1
  have back : «闭» («逆» («续» R' E')) P' := fun _ _ _ c => ⟨c.2.1, c.2.2.1⟩
  have split : ∀ v b b', P' b → P' b' → «续» R' E' v b → «续» R' E' v b' → b = b' :=
    fun v b b' _ _ c c' => GrammarLaws.pair_eq (c.1.1.trans c'.1.1.symm)
      (noSplit v.1 c.2.1 v.2 b.2 b'.2 c.2.2.1
        (Eq.subst (motive := fun s => b.2 ∈ u s) c.1.1 c.2.2.2)
        (Eq.subst (motive := fun s => b'.2 ∈ u s) c'.1.1 c'.2.2.2) c.1.2 c'.1.2)
  have covers : ∀ x : Nat × α, P' x → x.1 = N' → x ∈ L :=
    fun x h at_ => Eq.subst (motive := (· ∈ L))
      (GrammarLaws.pair_eq (x := (N', x.2)) (y := x) at_.symm rfl)
      (ListTests.mem_map_of (f := fun x => (N', x)) (Eq.subst (motive := fun s => x.2 ∈ u s) at_ h.2))
  have endings : ∀ M, ∃ x : Nat × α, M ≤ x.1 ∧ (P' x ∧ «亡» R' E' x) :=
    fun M => match ending (M + T) with
    | ⟨t, later, x, mx, en⟩ => ⟨(t, x), Nat.le_trans (Nat.le_add_right M T) later,
        ⟨Nat.le_trans (Nat.le_add_left T M) later, mx⟩, fun ⟨y, c⟩ => en ⟨y.2, c.1.2⟩⟩
  match GrammarLaws.found (τ := Prod.fst) (marks := fun x => P' x ∧ «亡» R' E' x) endings
      (L.length + 1) N' with
  | ⟨_, _, dD, len, from_, all⟩ =>
    match le_dest from_ with
    | ⟨n, atU⟩ =>
      match GrammarLaws.stage_search b u N' n with
      | .inl ⟨t, lo, _, y, my, passes⟩ =>
        ⟨t, Nat.le_trans (Nat.le_add_right N T) lo, y, my,
          (begins t (Nat.le_trans (Nat.le_add_left T N) lo) y my).mp passes⟩
      | .inr nothing => (Nat.not_succ_le_self L.length (Nat.le_trans (Nat.le_of_eq len.symm)
          («间无生则间亡不过所覆» (τ := Prod.fst) (P := P') stage back split covers
            (fun z hz late below beg => match z, hz, late, below, beg with
              | (0, _), _, late, _, _ => Nat.not_lt_zero _ late
              | (t + 1, y), hz, late, below, beg =>
                have from_t : N' ≤ t := Nat.le_of_lt_succ late
                have fromT : T ≤ t := Nat.le_trans (Nat.le_add_left T N) from_t
                nothing t from_t (Nat.lt_of_lt_of_le (Nat.lt_succ_self t)
                    (Nat.le_of_lt (Eq.subst (motive := (t + 1 < ·)) atU below))) y hz.2
                  ((begins t fromT y hz.2).mpr fun ⟨x, c⟩ =>
                    beg ⟨(t, x), ⟨rfl, c⟩, fromT, predecessorsBefore t fromT x y hz.2 c, hz.2⟩))
            dD all))).elim

/-- **The census of a run** under a continuation that fixes successors (`GrammarLaws.census_run`,
the fixed successor read at the listed units). -/
theorem «定后前者在前则亡屡者生屡» {b : α → Bool} {u : Nat → List α} {T : Nat}
    (predecessorsBefore : ∀ t, T ≤ t → ∀ x y, y ∈ u (t + 1) → «续» R E x y → x ∈ u t)
    (fixedAfter : «定后» («续» R E))
    (begins : ∀ t, T ≤ t → ∀ y, y ∈ u (t + 1) → (b y = true ↔ «生» R E y))
    (ending : «屡» (fun before _ => ∃ x, x ∈ before ∧ «亡» R E x) u) :
    «屡» (fun _ after => ∃ y, y ∈ after ∧ «生» R E y) u :=
  GrammarLaws.census_run
    (fun _ _ x y y' _ _ _ c c' => «定后之逐点».mp fixedAfter x y y' c c')
    predecessorsBefore begins ending

end Census

/-! ## Lumping (同行) -/

section Lumping

variable {α : Type u}

/-- `E` goes alike under `R` (同行): `R˘;E;R ⊆ E`. -/
def «同行» (R E : «际» α) : Prop := «则» («而» («而» («逆» R) E) R) E

/-- The pointwise form: what `E` relates goes, by `R`, to what `E` relates. -/
theorem «同行之逐点» {R E : «际» α} :
    «同行» R E ↔ ∀ x x', E x x' → ∀ y y', R x y → R x' y' → E y y' :=
  ⟨fun h x x' e y y' r r' => h y y' ⟨x', ⟨x, r, e⟩, r'⟩,
   fun h y y' ⟨x', ⟨x, r, e⟩, r'⟩ => h x x' e y y' r r'⟩

/-- **Constancy, its successor fixed where `E` leads, is going alike.** The successor need be fixed
only at the occurrences `E` relates something to. -/
theorem «有常局定后则同行» {R E : «际» α} (constant : «有常» R E)
    (fixed : ∀ x x', E x x' → ∀ v w, R x' v → R x' w → v = w) : «同行» R E :=
  «同行之逐点».mpr fun x x' e y y' r r' =>
    match («有常之逐点» R E).mp constant x x' e y r with
    | ⟨v, rv, ev⟩ => by
      have same : v = y' := fixed x x' e v y' rv r'
      subst same
      exact ev

/-- **With a fixed successor, constancy is going alike.** -/
theorem «有常定后则同行» {R E : «际» α} (constant : «有常» R E) (fixed : «定后» R) : «同行» R E :=
  «有常局定后则同行» constant fun _ x' _ v w rv rw => fixed v w ⟨x', rv, rw⟩

/-- **Constancy gives a successor where `E` leads from one that has one.** -/
theorem «有常则可续» {R E : «际» α} (constant : «有常» R E) :
    ∀ u u' v, E u u' → R u v → ∃ v', R u' v' :=
  fun u u' v e r => match («有常之逐点» R E).mp constant u u' e v r with
    | ⟨v', r', _⟩ => ⟨v', r'⟩

/-- **Going alike, with a successor where `E` leads from one that has one, is constancy.** The
successor is needed only there; the hypothesis is necessary, since constancy gives it
(`«有常则可续»`). -/
theorem «同行可续则有常» {R E : «际» α} (alike : «同行» R E)
    (onward : ∀ u u' v, E u u' → R u v → ∃ v', R u' v') : «有常» R E :=
  («有常之逐点» R E).mpr fun u u' e v r =>
    match onward u u' v e r with
    | ⟨v', r'⟩ => ⟨v', r', «同行之逐点».mp alike u u' e v v' r r'⟩

/-- **Where every occurrence has a successor, going alike is constancy.** -/
theorem «同行遍后则有常» {R E : «际» α} (alike : «同行» R E) (total : ∀ x, ∃ y, R x y) : «有常» R E :=
  «同行可续则有常» alike fun _ u' _ _ _ => total u'

/-- **With the successor fixed where `E` leads, constancy is going alike with a successor where `E`
leads from one that has one.** The exact gap between the two: availability. -/
theorem «局定后则有常当且仅当同行可续» {R E : «际» α}
    (fixed : ∀ x x', E x x' → ∀ v w, R x' v → R x' w → v = w) :
    «有常» R E ↔ «同行» R E ∧ ∀ u u' v, E u u' → R u v → ∃ v', R u' v' :=
  ⟨fun constant => ⟨«有常局定后则同行» constant fixed, «有常则可续» constant⟩,
   fun ⟨alike, onward⟩ => «同行可续则有常» alike onward⟩

/-- With a fixed successor that every occurrence has, going alike and constancy are one. -/
theorem «同行当且仅当有常» {R E : «际» α} (fixed : «定后» R) (total : ∀ x, ∃ y, R x y) :
    «同行» R E ↔ «有常» R E :=
  ⟨fun alike => «同行遍后则有常» alike total, fun constant => «有常定后则同行» constant fixed⟩

/-- For a class going alike under a relation every occurrence of which has a successor, the class
lies inside its own core. -/
theorem «类同行遍后则含于核» {R E : «际» α} (hE : «类» E) (alike : «同行» R E) (total : ∀ x, ∃ y, R x y) :
    «则» E («核» R E) :=
  («类有常当且仅当含于核» R hE).mp («同行遍后则有常» alike total)

/-- **With a fixed successor, the core of a class goes alike.** Where the step's successor is fixed, the
core of a class `E` is a class inside `E` that the step goes alike across. -/
theorem «定后则类之核同行» {R E : «际» α} (hE : «类» E) (fixed : «定后» R) :
    «类» («核» R E) ∧ «则» («核» R E) E ∧ «同行» R («核» R E) :=
  ⟨«核为类» R hE, («根» R E).1, «有常定后则同行» («根» R E).2.1 fixed⟩

/-- **Where every occurrence has a successor, a class inside `E` going alike lies in the core of `E`.**
Neither a fixed successor nor `E` a class is needed. -/
theorem «遍后则其内同行之类含于核» {R E : «际» α} (total : ∀ x, ∃ y, R x y) :
    ∀ S, «类» S → «则» S E → «同行» R S → «则» S («核» R E) :=
  fun S hS hSE alike => («根» R E).2.2.2 S hSE (fun _ _ h => hS.symm h) («同行遍后则有常» alike total)

/-- **With a fixed successor that every occurrence has, the core of a class is the coarsest class inside it
that the step goes alike across.** -/
theorem «定后遍后则核为其内最粗同行之类» {R E : «际» α} (hE : «类» E) (fixed : «定后» R)
    (total : ∀ x, ∃ y, R x y) :
    («类» («核» R E) ∧ «则» («核» R E) E ∧ «同行» R («核» R E)) ∧
      ∀ S, «类» S → «则» S E → «同行» R S → «则» S («核» R E) :=
  ⟨«定后则类之核同行» hE fixed, «遍后则其内同行之类含于核» total⟩

/-- **Off a fixed successor the core of a class need not go alike (witness).** Where `0` steps to `1` and to
`2` and `E` is the identity, `E` is a class, the successor is not fixed, the core relates `0` to itself and
not `1` to `2`, and the step does not go alike across it. -/
theorem «后不定则核可不同行» : ∃ (R E : «际» Nat),
    R 0 1 ∧ R 0 2 ∧ (∀ x y, E x y ↔ x = y) ∧
      «类» E ∧ ¬ «定后» R ∧ «核» R E 0 0 ∧ ¬ «核» R E 1 2 ∧ ¬ «同行» R («核» R E) := by
  refine ⟨fun x y => x = 0 ∧ (y = 1 ∨ y = 2), «静», ?_⟩
  have hid : «核» (fun x y : Nat => x = 0 ∧ (y = 1 ∨ y = 2)) «静» 0 0 :=
    ⟨«静», fun _ _ h => h, fun _ _ h => h.symm, «静有常» _, rfl⟩
  have apart : ¬ «核» (fun x y : Nat => x = 0 ∧ (y = 1 ∨ y = 2)) «静» 1 2 := fun ⟨_, hS, _, _, h12⟩ => by
    have same : (1 : Nat) = 2 := hS 1 2 h12
    exact absurd same (by decide)
  refine ⟨⟨rfl, Or.inl rfl⟩, ⟨rfl, Or.inr rfl⟩, fun _ _ => Iff.rfl, ⟨fun _ => rfl, Eq.symm, Eq.trans⟩,
    fun fixed => ?_, hid, apart, fun h => ?_⟩
  · have same : (1 : Nat) = 2 := fixed 1 2 ⟨0, ⟨rfl, Or.inl rfl⟩, ⟨rfl, Or.inr rfl⟩⟩
    exact absurd same (by decide)
  · exact apart (h 1 2 ⟨0, ⟨0, ⟨rfl, Or.inl rfl⟩, hid⟩, ⟨rfl, Or.inr rfl⟩⟩)

/-- **Where every letter's relation goes alike under `E`, passing through the word keeps `E`-alike
occurrences alike (同行之历).** -/
theorem «同行之历» {A : Type v} {F : A → «际» α} {E : «际» α} (alike : ∀ a, «同行» (F a) E) :
    ∀ (as : List A) {x x' y y' : α}, E x x' → «历» F as x y → «历» F as x' y' → E y y'
  | [], _, _, _, _, e, e₁, e₂ => by cases e₁; cases e₂; exact e
  | a :: as, x, x', _, _, e, ⟨w, r, first⟩, ⟨w', r', second⟩ =>
    «同行之历» alike as («同行之逐点».mp (alike a) x x' e w w' r r') first second

/-- **Going alike keeps lines of every length alike**: `E`-alike occurrences go, by `n` steps, to
`E`-alike occurrences; the case of `«同行之历»` for one relation. -/
theorem «同行之迭» {R E : «际» α} (alike : «同行» R E) :
    ∀ (n : Nat) {x x' y y' : α}, E x x' → «迭» R n x y → «迭» R n x' y' → E y y'
  | n, x, x', y, y', e, first, second =>
    «同行之历» (F := fun (_ : Unit) => R) (fun _ => alike) (List.replicate n ()) e
      ((«迭即历» R n x y).mpr first) ((«迭即历» R n x' y').mpr second)

/-- So `E` goes alike under every number of steps. -/
theorem «同行于迭» {R E : «际» α} (alike : «同行» R E) (n : Nat) : «同行» («迭» R n) E :=
  «同行之逐点».mpr fun _ _ e _ _ first second => «同行之迭» alike n e first second

variable {κ : Type v}

/-- The image of a relation along a map (像): `k` conditions `k'` where something read as `k`
conditions something read as `k'`. -/
def «像» (π : α → κ) (R : «际» α) : «际» κ := fun k k' => ∃ s u, π s = k ∧ R s u ∧ π u = k'

/-- **Preserving, read through the image (保之像).** A map takes every pair `R` relates to a pair `R'`
relates exactly where the image of `R` along it lies within `R'`: a map preserving a relation, not a
relation kept (守) nor two kept each within the other (齐). -/
theorem «保之像» {α : Type u} {κ : Type v} (φ : α → κ) (R : «际» α) (R' : «际» κ) :
    «则» («像» φ R) R' ↔ ∀ x y, R x y → R' (φ x) (φ y) :=
  ⟨fun within x y r => within _ _ ⟨x, y, rfl, r, rfl⟩,
   fun keeps _ _ ⟨x, y, hx, r, hy⟩ => Eq.subst (motive := fun b => R' _ b) hy
     (Eq.subst (motive := fun a => R' a (φ y)) hx (keeps x y r))⟩

/-- **The image along a map has a fixed successor exactly where sameness under the map goes
alike.** The read-alone part carries a law, possibly partial (nothing is said about a successor
existing), exactly where what the map leaves out makes no difference to where it goes. -/
theorem «像定后当且仅当同行» {π : α → κ} {R : «际» α} :
    «定后» («像» π R) ↔ «同行» R (fun s s' => π s = π s') :=
  ⟨fun fixed => «同行之逐点».mpr fun s s' e u u' r r' =>
      fixed (π u) (π u') ⟨π s, ⟨s, u, rfl, r, rfl⟩, ⟨s', u', e.symm, r', rfl⟩⟩,
   fun alike _ _ ⟨_, ⟨s, u, at_k, r, to⟩, ⟨s', u', at_k', r', to'⟩⟩ =>
    to.symm.trans ((«同行之逐点».mp alike s s' (at_k.trans at_k'.symm) u u' r r').trans to')⟩

end Lumping

/-! ## Order (广) -/

section Order

variable {α : Type u}

/-- `R` exceeds `S` (逾): it relates something `S` does not. -/
def «逾» (R S : «际» α) : Prop := ∃ x y, R x y ∧ ¬ S x y

/-- `R` widens `S` (广): it relates whatever `S` relates and exceeds it. -/
def «广» (R S : «际» α) : Prop := «则» S R ∧ «逾» R S

/-- `R` and `S` keep the same (齐): each relates whatever the other relates. -/
def «齐» (R S : «际» α) : Prop := «则» R S ∧ «则» S R

/-- `R` and `S` are mixed (杂): each exceeds the other. -/
def «杂» (R S : «际» α) : Prop := «逾» R S ∧ «逾» S R

/-- What exceeds is not included. -/
theorem «逾则不则» {R S : «际» α} (h : «逾» R S) : ¬ «则» R S :=
  fun inside => match h with
    | ⟨x, y, r, not⟩ => not (inside x y r)

/-- Widening includes and is not included: the inclusion-only form follows. -/
theorem «广则不则» {R S : «际» α} (h : «广» R S) : «则» S R ∧ ¬ «则» R S :=
  ⟨h.1, «逾则不则» h.2⟩

/-- **Nothing widens itself.** -/
theorem «广非自» (R : «际» α) : ¬ «广» R R :=
  fun h => «逾则不则» h.2 («则之自反» R)

/-- **Widening goes one way.** -/
theorem «广不可逆» {R S : «际» α} (h : «广» R S) : ¬ «广» S R :=
  fun back => «逾则不则» back.2 h.1

/-- **Widening is transitive.** -/
theorem «广之传递» {R S T : «际» α} (h₁ : «广» R S) (h₂ : «广» S T) : «广» R T :=
  ⟨«则之传递» h₂.1 h₁.1, match h₁.2 with
    | ⟨x, y, r, not⟩ => ⟨x, y, r, fun t => not (h₂.1 x y t)⟩⟩

/-- Keeping the same is pointwise equivalence. -/
theorem «齐即谓» {R S : «际» α} : «齐» R S ↔ «谓» R S :=
  ⟨fun ⟨h₁, h₂⟩ x y => ⟨h₁ x y, h₂ x y⟩, fun h => ⟨fun x y => (h x y).mp, fun x y => (h x y).mpr⟩⟩

theorem «齐之对称» {R S : «际» α} (h : «齐» R S) : «齐» S R := ⟨h.2, h.1⟩

theorem «杂之对称» {R S : «际» α} (h : «杂» R S) : «杂» S R := ⟨h.2, h.1⟩

/-- Widening is not keeping the same. -/
theorem «广则非齐» {R S : «际» α} (h : «广» R S) : ¬ «齐» R S :=
  fun keeps => «逾则不则» h.2 keeps.1

/-- Widening is not mixed. -/
theorem «广则非杂» {R S : «际» α} (h : «广» R S) : ¬ «杂» R S :=
  fun mixed => «逾则不则» mixed.2 h.1

/-- Keeping the same is not mixed. -/
theorem «齐则非杂» {R S : «际» α} (h : «齐» R S) : ¬ «杂» R S :=
  fun mixed => «逾则不则» mixed.1 h.1

/-- **The four cases.** Where inclusion or exceeding is decided both ways, `R` widens `S`, `S`
widens `R`, they keep the same, or they are mixed; by the theorems above, exactly one. -/
theorem «四比之周» {R S : «际» α} (one : «则» R S ∨ «逾» R S) (other : «则» S R ∨ «逾» S R) :
    «广» R S ∨ «广» S R ∨ «齐» R S ∨ «杂» R S :=
  match one, other with
  | .inl rs, .inl sr => .inr (.inr (.inl ⟨rs, sr⟩))
  | .inl rs, .inr sr => .inr (.inl ⟨rs, sr⟩)
  | .inr rs, .inl sr => .inl ⟨sr, rs⟩
  | .inr rs, .inr sr => .inr (.inr (.inr ⟨rs, sr⟩))

/-- **A transitive relation joined to the strict part of a transitive relation containing it is
transitive.** A law of any two relations on any carrier, read on the ordering of courses
(`ComparingCourses`: widening or widening with a lag) and of what can be reached
(`ReachableRanges`: the lagged order). -/
theorem strictJoin_trans {α : Type u} {S P : α → α → Prop}
    (sTrans : ∀ {a b c}, S a b → S b c → S a c) (pTrans : ∀ {a b c}, P a b → P b c → P a c)
    (within : ∀ {a b}, S a b → P a b) {a b c : α} :
    (S a b ∨ (P a b ∧ ¬ P b a)) → (S b c ∨ (P b c ∧ ¬ P c b)) → (S a c ∨ (P a c ∧ ¬ P c a))
  | .inl first, .inl second => .inl (sTrans first second)
  | .inl first, .inr ⟨p, np⟩ =>
      .inr ⟨pTrans (within first) p, fun back => np (pTrans back (within first))⟩
  | .inr ⟨p, np⟩, .inl second =>
      .inr ⟨pTrans p (within second), fun back => np (pTrans (within second) back)⟩
  | .inr ⟨p, np⟩, .inr ⟨q, _⟩ => .inr ⟨pTrans p q, fun back => np (pTrans q back)⟩

/-- The strict part of a relation, joined to an irreflexive one, is irreflexive. -/
theorem strictJoin_irrefl {α : Type u} {S P : α → α → Prop} {a : α} (irrefl : ¬ S a a) :
    ¬ (S a a ∨ (P a a ∧ ¬ P a a))
  | .inl same => irrefl same
  | .inr ⟨p, np⟩ => np p

/-- **Deciding inclusion against exceeding for every pair of relations is exactly excluded
middle.** -/
theorem «则逾之定当且仅当排中» :
    (∀ (α : Type) (R S : «际» α), «则» R S ∨ «逾» R S) ↔ ∀ P : Prop, P ∨ ¬ P := by
  constructor
  · intro h P
    match h Unit «一» (fun _ _ => P) with
    | .inl inside => exact .inl (inside () () trivial)
    | .inr ⟨_, _, _, not⟩ => exact .inr not
  · intro em α R S
    match em («逾» R S) with
    | .inl exceeds => exact .inr exceeds
    | .inr nothing => exact .inl fun x y r => match em (S x y) with
      | .inl s => s
      | .inr not => absurd ⟨x, y, r, not⟩ nothing

end Order

end Becoming
