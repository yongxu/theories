import Becoming.Continuity
import Becoming.GrammarCrossing

/-!
# Balance region by region, and on each closure

`Becoming.Continuity` reads closure by families, tests on the relata: a family the relation closes
is one whose adjacent listed relata lie both in it or both outside it (`Continuity.Closes`). This
module reads that on the grammar's `«不出»` and on its closure, `«所闭»` (`Becoming.GrammarLaws`).

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
* **Each closure decided.** With equality of relata decided, the closure of a relatum, here the
  grammar's `«所闭»` along adjacency among the listed relata, is decided by a test: what is reached
  from it within as many steps of that adjacency as relata are listed (`Continuity.closureListed`,
  `Continuity.closureListed_iff`). Counted by the grammar's `«计»`, the listed relata reached grow
  at each step until a step reaches nothing new, after which none does
  (`Continuity.reachedListed_stays`), and they cannot outnumber the list
  (`Continuity.reachedListed_grows_or_stays`, `Continuity.closureListed_closed`). An unlisted
  relatum's closure holds nothing but itself (`Continuity.closureListed_unlisted`).
* **Balance on each closure.** Conservation on every family the relation closes is conservation on
  each closure (`Continuity.conservedOn_iff_closures`): a closed family holding a listed relatum
  holds its closure (`Continuity.closureListed_inside`), and what it holds beyond that closure the
  relation closes and holds fewer listed relata. So, relata listed without repetition and equality
  decided, transfers along the relation that balance a step exist exactly where the total is
  conserved on the closure of each listed relatum (`Continuity.balancing_iff_closures`), and on a
  web at every step likewise (`Continuity.balancesOn_iff_closures`).
* **At the unit grain, the same closures.** The closure of a symmetric relation is a class, so
  where a test decides it, two lists are paired one to one under it exactly where each closure
  holds equally many entries of both, a case of `«类之对当且仅当类类等数»`
  (`Continuity.pairing_iff_closure_counts`). Symmetry is needed: a region closed one way only does
  not keep the count (`«对而单闭域不守数之例»`). Along adjacency among the listed relata, which is
  symmetric, the closures are those of every relatum, listed or not
  (`Continuity.pairing_iff_closures`).
* **The two grains joined.** Read a level as units on its relata, each listed relatum repeated as
  often as its level, gathered by the grammar's `«聚»` (`unitsOn`); a test counts them
  on its family as the level's total there (`Continuity.count_unitsOn`). So, with equality
  decided, conservation on every family the relation closes is the units before paired one to one
  with the units after under the closure (`Continuity.conservedOn_iff_units_paired`), and, relata
  listed without repetition, transfers along the relation that balance a step exist exactly where
  they are so paired (`Continuity.balancing_iff_units_paired`; on a web,
  `Continuity.balancesOn_iff_units_paired`). This is the closure-local reading of
  `Flow.balances_iff_units`, which pairs a flow's units at one condition under the one, with what
  is given and taken among them: here the closure takes the place of the transfers.

So balance along a relation is kept on each of its closures among the listed relata, at both
grains, and each relatum's closure is the least family the relation closes that holds it, a region,
membership a test, not gone out of (`Continuity.closureListed_closes`,
`Continuity.closureListed_self`, `Continuity.closureListed_inside`). This is the uncapacitated,
undirected case of the feasibility conditions for flows (Gale 1957; Hoffman 1960, through the usual
reduction to a circulation), read on the grammar. Not shown: transfers within capacities, the
capacitated case. Nor do counts kept on each closure give a pairing along one step of the
adjacency: on the path `0 — 1 — 2`, `[0]` and `[2]` keep every closure's count, and no step joins
`0` to `2` (`Continuity.PathOfThree.counts_kept_not_along_step`), as an amount may pass through a
relatum within the step. Every declaration has an empty axiom report.
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

/-! ## Counting the listed relata a test holds -/

/-- A test that holds wherever another does counts at least as much. -/
theorem cond_le_cond : ∀ {b c : Bool}, (b = true → c = true) → cond b 1 0 ≤ cond c 1 0
  | false, _, _ => Nat.zero_le _
  | true, true, _ => Nat.le_refl 1
  | true, false, le => Bool.noConfusion (le rfl)

/-- A test that holds wherever another does counts at least as many of a list. -/
theorem count_le_count {p q : R → Bool} (le : ∀ x, p x = true → q x = true) :
    ∀ l : List R, «计» p l ≤ «计» q l
  | [] => Nat.le_refl 0
  | x :: l => Nat.add_le_add (cond_le_cond (le x)) (count_le_count le l)

/-- A test that holds wherever another does, and also at a member where the other does not, counts
more of the list. -/
theorem count_lt_count {p q : R → Bool} (le : ∀ x, p x = true → q x = true) {a : R}
    (missing : p a = false) (counted : q a = true) : ∀ {l : List R}, a ∈ l → «计» p l < «计» q l
  | _ :: l, .head _ => by
    show cond (p a) 1 0 + «计» p l < cond (q a) 1 0 + «计» q l
    rw [missing, counted]
    exact Nat.lt_of_le_of_lt (Nat.le_trans (Nat.le_of_eq (Nat.zero_add _)) (count_le_count le l))
      (Nat.lt_of_lt_of_le (Nat.lt_succ_self _) (Nat.le_of_eq (Nat.add_comm _ 1)))
  | x :: _, .tail _ m =>
    Nat.lt_of_le_of_lt (Nat.add_le_add_right (cond_le_cond (le x)) _)
      (Nat.add_lt_add_left (count_lt_count le missing counted m) _)

/-- The test that always holds counts the length. -/
theorem count_true : ∀ l : List R, «计» (fun _ => true) l = l.length
  | [] => rfl
  | _ :: l => (Nat.add_comm 1 _).trans (congrArg (· + 1) (count_true l))

/-- A test counting as many of a list as its length holds at each member. -/
theorem counted_of_count {p : R → Bool} {l : List R} (all : l.length ≤ «计» p l) {x : R}
    (m : x ∈ l) : p x = true :=
  (Bool.eq_false_or_eq_true (p x)).elim id fun h => (Nat.lt_irrefl _ (Nat.lt_of_lt_of_le
    (count_lt_count (q := fun _ => true) (fun _ _ => rfl) h rfl m)
    (Nat.le_trans (Nat.le_of_eq (count_true l)) all))).elim

/-! ## Splitting a family -/

/-- What one family the relation closes holds and another does not, the relation closes. -/
theorem closes_and_not {rel : R → R → Bool} {us : List R} {p q : R → Bool}
    (closesP : Closes rel us p) (closesQ : Closes rel us q) :
    Closes rel us (fun y => p y && !q y) := fun x y mx my near => by
  show (p x && !q x) = (p y && !q y)
  rw [closesP x y mx my near, closesQ x y mx my near]

/-- The part of a quantity on a family is its part on what the family holds outside a subfamily,
with its part on the subfamily. -/
theorem within_split {p q : R → Bool} (le : ∀ x, q x = true → p x = true) (f : R → Nat) (x : R) :
    within p f x = within (fun y => p y && !q y) f x + within q f x :=
  (Bool.eq_false_or_eq_true (q x)).elim
    (fun hq =>
      have hp := le x hq
      have rest : (p x && !q x) = false :=
        (congrArg (fun b => p x && !b) hq).trans (Bool.and_false (p x))
      (within_true f hp).trans ((Nat.zero_add (f x)).symm.trans (Naturals.add_congr
        (within_false (p := fun y => p y && !q y) f rest).symm (within_true f hq).symm)))
    fun hq => (Bool.eq_false_or_eq_true (p x)).elim
      (fun hp =>
        have rest : (p x && !q x) = true :=
          (congrArg (fun b => b && !q x) hp).trans (congrArg (fun b => true && !b) hq)
        (within_true f hp).trans (Naturals.add_congr
          (within_true (p := fun y => p y && !q y) f rest).symm (within_false f hq).symm))
      fun hp =>
        have rest : (p x && !q x) = false := congrArg (fun b => b && !q x) hp
        (within_false f hp).trans (Naturals.add_congr
          (within_false (p := fun y => p y && !q y) f rest).symm (within_false f hq).symm)

/-- A family holding no listed relatum has total nothing, before and after. -/
theorem conserved_of_absent {us : List R} {p : R → Bool} {prev next : R → Nat}
    (absent : ∀ x, x ∈ us → p x = false) : total us (within p next) = total us (within p prev) :=
  (total_eq_zero fun x m => within_false next (absent x m)).trans
    (total_eq_zero fun x m => within_false prev (absent x m)).symm

/-! ## Each closure decided

The closure of a relatum, in this section and the next, is the grammar's `«所闭»` along adjacency
among the listed relata, `«所闭» (adjacentListed rel us)`. Among finitely many listed relata it is
decided by a test. -/

section Closures

variable [DecidableEq R]

/-- The relata reached from `a` within `n` steps of adjacency among the listed relata: `a` itself,
and each listed relatum adjacent to a listed relatum reached within fewer steps. -/
def reachedListed (rel : R → R → Bool) (us : List R) (a : R) : Nat → R → Bool
  | 0, x => decide (a = x)
  | n + 1, x => reachedListed rel us a n x ||
      (us.contains x && us.any fun y => reachedListed rel us a n y && adj rel y x)

/-- **The closure of a relatum as a test**: what is reached from it within as many steps of
adjacency among the listed relata as relata are listed. It decides the relatum's closure, the
grammar's `«所闭»` along `adjacentListed rel us` (`Continuity.closureListed_iff`). It is built to
decide, not to be evaluated: each step re-reads the step before at every listed relatum. -/
def closureListed (rel : R → R → Bool) (us : List R) (a : R) : R → Bool :=
  reachedListed rel us a us.length

/-- What is reached from `a` lies within its closure, the grammar's `«所闭»` along
`adjacentListed rel us`: each step is a step of that adjacency (`«缘在所闭»`, `«所闭之传递»`). -/
theorem reachedListed_within {rel : R → R → Bool} {us : List R} {a : R} :
    ∀ {n : Nat} {x : R}, reachedListed rel us a n x = true → «所闭» (adjacentListed rel us) a x
  | 0, x, reached => by
    cases ListTests.decide_true_iff.mp reached
    exact «所闭之自反» _ _
  | _ + 1, _, reached =>
    (ListTests.or_true_iff.mp reached).elim reachedListed_within fun step =>
      match ListTests.and_true_iff.mp step with
      | ⟨listed, near⟩ =>
        match ListTests.any_true_iff.mp near with
        | ⟨y, my, hy⟩ =>
          match ListTests.and_true_iff.mp hy with
          | ⟨reachedY, adjacent⟩ =>
            «所闭之传递» (reachedListed_within reachedY)
              («缘在所闭» ⟨my, ListTests.contains_true_iff.mp listed, adjacent⟩)

/-- What is reached within `n` steps is reached within `n + k`. -/
theorem reachedListed_add {rel : R → R → Bool} {us : List R} {a : R} {n : Nat} {x : R}
    (reached : reachedListed rel us a n x = true) : ∀ k, reachedListed rel us a (n + k) x = true
  | 0 => reached
  | k + 1 => ListTests.or_true_iff.mpr (.inl (reachedListed_add reached k))

/-- A relatum lies within its own closure test. -/
theorem closureListed_self (rel : R → R → Bool) (us : List R) (a : R) :
    closureListed rel us a a = true := by
  have reached := reachedListed_add (rel := rel) (us := us) (n := 0)
    (ListTests.decide_true_iff.mpr (rfl : a = a)) us.length
  rw [Nat.zero_add] at reached
  exact reached

/-- Once a step reaches nothing new, no later step does. -/
theorem reachedListed_stays {rel : R → R → Bool} {us : List R} {a : R} {k : Nat}
    (stays : ∀ x, reachedListed rel us a (k + 1) x = true → reachedListed rel us a k x = true) :
    ∀ j x, reachedListed rel us a (k + j) x = true → reachedListed rel us a k x = true
  | 0, _, reached => reached
  | j + 1, x, reached =>
    (ListTests.or_true_iff.mp reached).elim (reachedListed_stays stays j x) fun step =>
      match ListTests.and_true_iff.mp step with
      | ⟨listed, near⟩ =>
        match ListTests.any_true_iff.mp near with
        | ⟨y, my, hy⟩ =>
          match ListTests.and_true_iff.mp hy with
          | ⟨reachedY, adjacent⟩ =>
            stays x (ListTests.or_true_iff.mpr (.inr (ListTests.and_true_iff.mpr ⟨listed,
              ListTests.any_true_iff.mpr ⟨y, my, ListTests.and_true_iff.mpr
                ⟨reachedListed_stays stays j y reachedY, adjacent⟩⟩⟩)))

/-- **Either a step reaches nothing new, or the count grows by `k`.** For each `k`: either, for
some `i ≤ k`, the step from `i` to `i + 1` steps reaches nothing new, or at least `k` more listed
relata are reached within `k` steps than at the start. -/
theorem reachedListed_grows_or_stays {rel : R → R → Bool} {us : List R} {a : R} :
    ∀ k, (∃ i j, i + j = k ∧
        ∀ x, reachedListed rel us a (i + 1) x = true → reachedListed rel us a i x = true) ∨
      k + «计» (reachedListed rel us a 0) us ≤ «计» (reachedListed rel us a k) us
  | 0 => .inr (Nat.le_of_eq (Nat.zero_add _))
  | k + 1 =>
    match reachedListed_grows_or_stays k with
    | .inl ⟨i, j, sum, stays⟩ => .inl ⟨i, j + 1, congrArg (· + 1) sum, stays⟩
    | .inr grown =>
      match Nat.lt_or_ge («计» (reachedListed rel us a k) us)
          («计» (reachedListed rel us a (k + 1)) us) with
      | .inl more =>
        .inr (Nat.le_trans (Nat.le_of_eq (Nat.add_right_comm k 1 _))
          (Nat.succ_le_of_lt (Nat.lt_of_le_of_lt grown more)))
      | .inr fewer => .inl ⟨k, 1, rfl, fun x reached =>
          (Bool.eq_false_or_eq_true (reachedListed rel us a k x)).elim id fun h =>
            (ListTests.or_true_iff.mp reached).elim (fun r => Bool.noConfusion (h.symm.trans r))
              fun step => (Nat.lt_irrefl _ (Nat.lt_of_lt_of_le
                (count_lt_count (p := reachedListed rel us a k)
                  (q := reachedListed rel us a (k + 1))
                  (fun _ r => reachedListed_add r 1) h reached
                  (ListTests.contains_true_iff.mp (ListTests.and_true_iff.mp step).1))
                fewer)).elim⟩

/-- **The closure test is closed under adjacency among the listed relata.** The listed relata
reached grow at each step until a step reaches nothing new, and cannot outnumber the list: so
within as many steps as relata are listed, either a step has reached nothing new, and nothing
later does, or every listed relatum is reached. -/
theorem closureListed_closed {rel : R → R → Bool} {us : List R} {a : R} :
    «闭» (adjacentListed rel us) (fun x => closureListed rel us a x = true) :=
  fun y x reached listed =>
    match reachedListed_grows_or_stays (rel := rel) (us := us) (a := a) us.length with
    | .inl ⟨i, j, sum, stays⟩ => by
      have next : reachedListed rel us a (i + (j + 1)) x = true := by
        rw [show i + (j + 1) = us.length + 1 from congrArg (· + 1) sum]
        exact ListTests.or_true_iff.mpr (.inr (ListTests.and_true_iff.mpr
          ⟨ListTests.contains_true_iff.mpr listed.2.1,
            ListTests.any_true_iff.mpr
              ⟨y, listed.1, ListTests.and_true_iff.mpr ⟨reached, listed.2.2⟩⟩⟩))
      have atI := reachedListed_stays stays (j + 1) x next
      show reachedListed rel us a us.length x = true
      rw [← sum]
      exact reachedListed_add atI j
    | .inr grown => counted_of_count (Naturals.le_of_add_le_right grown) listed.2.1

/-- **The closure of a relatum, decided.** The closure test holds exactly within the relatum's
closure, the grammar's `«所闭»` along `adjacentListed rel us`, for every relatum, listed or not. -/
theorem closureListed_iff {rel : R → R → Bool} {us : List R} {a x : R} :
    closureListed rel us a x = true ↔ «所闭» (adjacentListed rel us) a x :=
  ⟨reachedListed_within, fun within => within _ closureListed_closed (closureListed_self rel us a)⟩

/-- Each closure, along `adjacentListed rel us`, is a family the relation closes. -/
theorem closureListed_closes {rel : R → R → Bool} {us : List R} {a : R} :
    Closes rel us (closureListed rel us a) :=
  closes_iff_closed.mpr closureListed_closed

/-- An unlisted relatum's closure, along `adjacentListed rel us`, holds nothing but itself:
adjacency among the listed relata never leaves it. -/
theorem closureListed_unlisted {rel : R → R → Bool} {us : List R} {z x : R} (unlisted : ¬ z ∈ us)
    (inClosure : closureListed rel us z x = true) : x = z :=
  closureListed_iff.mp inClosure (fun y => y = z)
    (fun _ _ (same : _ = z) adjacent => (unlisted (same ▸ adjacent.1)).elim) rfl

/-! ## Balance on each closure -/

/-- A family the relation closes holds the closure, along `adjacentListed rel us`, of each relatum
it holds (`«闭含所闭»`). -/
theorem closureListed_inside {rel : R → R → Bool} {us : List R} {p : R → Bool}
    (closes : Closes rel us p) {a : R} (holds : p a = true) {x : R}
    (within : closureListed rel us a x = true) : p x = true :=
  «闭含所闭» (closes_iff_closed.mp closes) holds (closureListed_iff.mp within)

/-- One step of the decomposition. A family the relation closes is conserved where each closure,
along `adjacentListed rel us`, is, and so is every family the relation closes holding fewer listed
relata: a family holding no listed relatum has total nothing; one holding a listed relatum holds its
closure, and what it holds beyond that closure the relation closes and holds fewer listed relata. -/
theorem conserved_of_fewer {rel : R → R → Bool} {us : List R} {prev next : R → Nat}
    (each : ∀ a, a ∈ us → total us (within (closureListed rel us a) next) =
      total us (within (closureListed rel us a) prev))
    {p : R → Bool} (closes : Closes rel us p)
    (smaller : ∀ q : R → Bool, «计» q us < «计» p us → Closes rel us q →
      total us (within q next) = total us (within q prev)) :
    total us (within p next) = total us (within p prev) :=
  match hany : us.any p with
  | false => conserved_of_absent fun x m => (Bool.eq_false_or_eq_true (p x)).elim
      (fun hx => Bool.noConfusion (hany.symm.trans (ListTests.any_true_iff.mpr ⟨x, m, hx⟩))) id
  | true =>
    match ListTests.any_true_iff.mp hany with
    | ⟨a, ma, pa⟩ =>
      have split : ∀ f : R → Nat, total us (within p f) =
          total us (within (fun y => p y && !closureListed rel us a y) f) +
            total us (within (closureListed rel us a) f) := fun f =>
        (total_congr (within_split (fun _ h => closureListed_inside closes pa h) f) us).trans
          (total_add _ _ us)
      have fewer : «计» (fun y => p y && !closureListed rel us a y) us < «计» p us :=
        count_lt_count (p := fun y => p y && !closureListed rel us a y) (q := p)
          (fun _ h => (ListTests.and_true_iff.mp h).1)
          ((congrArg (fun b => p a && !b) (closureListed_self rel us a)).trans
            (Bool.and_false (p a)))
          pa ma
      (split next).trans ((Naturals.add_congr
        (smaller (fun y => p y && !closureListed rel us a y) fewer
          (closes_and_not closes closureListed_closes))
        (each a ma)).trans (split prev).symm)

/-- Conservation on each closure, along `adjacentListed rel us`, gives conservation on every family
the relation closes holding at most `n` listed relata, by `Continuity.conserved_of_fewer` and
induction on `n`. -/
theorem conserved_of_closures {rel : R → R → Bool} {us : List R} {prev next : R → Nat}
    (each : ∀ a, a ∈ us → total us (within (closureListed rel us a) next) =
      total us (within (closureListed rel us a) prev)) :
    ∀ n (p : R → Bool), «计» p us ≤ n → Closes rel us p →
      total us (within p next) = total us (within p prev)
  | 0, _, bound, closes => conserved_of_fewer each closes fun _ fewer _ =>
      (Nat.not_lt_zero _ (Nat.lt_of_lt_of_le fewer bound)).elim
  | n + 1, _, bound, closes => conserved_of_fewer each closes fun q fewer closesQ =>
      conserved_of_closures each n q (Nat.le_of_lt_succ (Nat.lt_of_lt_of_le fewer bound)) closesQ

/-- **Conservation on every family the relation closes is conservation on each closure.** The
closures are along adjacency among the listed relata (`«所闭» (adjacentListed rel us)`), one for
each listed relatum. -/
theorem conservedOn_iff_closures {rel : R → R → Bool} {us : List R} {prev next : R → Nat} :
    ConservedOn rel us prev next ↔
      ∀ a, a ∈ us → total us (within (closureListed rel us a) next) =
        total us (within (closureListed rel us a) prev) :=
  ⟨fun conserved _ _ => conserved _ closureListed_closes,
   fun each p closes => conserved_of_closures each _ p (Nat.le_refl _) closes⟩

/-- **Balancing transfers exist exactly where each closure conserves the total.** Over relata
listed without repetition, with equality decided, transfers along the relation that balance a step
exist exactly where the total is conserved on the closure of each listed relatum, the grammar's
`«所闭»` along adjacency among the listed relata. This is `Continuity.balancing_iff` read on
`«所闭»`: each relatum's closure is the least family the relation closes that holds it. -/
theorem balancing_iff_closures {rel : R → R → Bool} {us : List R} {prev next : R → Nat}
    (distinct : Distinct us) :
    (∃ move, Balancing rel us prev next move) ↔
      ∀ a, a ∈ us → total us (within (closureListed rel us a) next) =
        total us (within (closureListed rel us a) prev) :=
  (balancing_iff distinct).trans conservedOn_iff_closures

/-- **On a web, balancing transfers exist exactly where each closure conserves the levels, at every
step.** Over relata listed without repetition, with equality decided and the relation free to
change from step to step, the closures at each step are taken along that step's adjacency among
the listed relata (`«所闭» (adjacentListed (rel t) us)`). -/
theorem balancesOn_iff_closures {us : List R} {rel : Nat → R → R → Bool} {W : Web R R}
    (distinct : Distinct us) :
    (∃ move : Nat → R → R → Nat,
        (∀ t a b, 0 < move t a b → adj (rel t) a b = true ∧ a ∈ us ∧ b ∈ us) ∧
          ∀ t, (flow us move).BalancesOn W us t) ↔
      ∀ t a, a ∈ us → total us (within (closureListed (rel t) us a) (W.level (t + 1))) =
        total us (within (closureListed (rel t) us a) (W.level t)) :=
  (balancesOn_iff_conserved distinct).trans
    ⟨fun conserved t => conservedOn_iff_closures.mp (conserved t),
     fun each t => conservedOn_iff_closures.mpr (each t)⟩

end Closures

/-! ## At the unit grain, the same closures -/

/-- **A pairing under the closure of a symmetric relation is the count kept on each closure.** The
closure (`«所闭»`) of a symmetric relation is a class: reflexive (`«所闭之自反»`), symmetric
(`«所闭之对称»`) and transitive (`«所闭之传递»`). So where a test decides it, two lists are paired
one to one under it exactly where each closure holds as many entries of the one as of the other:
a case of the count law of a class, `«类之对当且仅当类类等数»`. -/
theorem pairing_iff_closure_counts {α : Type} {S : «际» α} {e : α → α → Bool}
    (symm : «则» S («逆» S)) (dec : ∀ x y, «所闭» S x y ↔ e x y = true) {a b : List α} :
    «对» («所闭» S) a b ↔ ∀ z, «计» (e z) a = «计» (e z) b :=
  «类之对当且仅当类类等数» ⟨«所闭之自反» S, fun h => «所闭之对称» symm _ _ h, «所闭之传递»⟩ dec

/-- **Along adjacency among the listed relata, a pairing under the closure is the count kept on each
closure.** The adjacency is symmetric (`Continuity.adjacentListed_symm`) and its closure decided
(`Continuity.closureListed_iff`), so this is `Continuity.pairing_iff_closure_counts` for it: two
lists of relata are paired one to one within the closures, the grammar's `«所闭»` along
`adjacentListed rel us`, exactly where the closure of each relatum, listed or not, holds equally
many entries of both. An unlisted relatum's closure holds nothing but itself
(`Continuity.closureListed_unlisted`). -/
theorem pairing_iff_closures [DecidableEq R] {rel : R → R → Bool} {us : List R} {a b : List R} :
    «对» («所闭» (adjacentListed rel us)) a b ↔
      ∀ z, «计» (closureListed rel us z) a = «计» (closureListed rel us z) b :=
  pairing_iff_closure_counts (adjacentListed_symm rel us) fun _ _ => closureListed_iff.symm

/-! ## The two grains joined -/

/-- A test counts a quantity's units on a list of relata as the quantity's total there on its
family. -/
theorem count_unitsOn (p : R → Bool) (q : R → Nat) :
    ∀ l : List R, «计» p (unitsOn q l) = total l (within p q)
  | [] => rfl
  | x :: l => (GrammarLaws.count_append p (unitsOn q l) (List.replicate (q x) x)).trans (Naturals.add_congr
      ((Bool.eq_false_or_eq_true (p x)).elim
        (fun holds => (GrammarLaws.count_replicate_true holds (q x)).trans (within_true q holds).symm)
        (fun fails => (GrammarLaws.count_replicate_false fails (q x)).trans (within_false q fails).symm))
      (count_unitsOn p q l))

/-- Conservation on the closure of each listed relatum, along `adjacentListed rel us`, is the
units before and after counted alike on the closure of every relatum: on a listed relatum's closure
the counts are the totals, and an unlisted relatum's closure holds no listed relatum, so no unit. -/
theorem closures_iff_unit_counts [DecidableEq R] {rel : R → R → Bool} {us : List R}
    {prev next : R → Nat} :
    (∀ a, a ∈ us → total us (within (closureListed rel us a) next) =
        total us (within (closureListed rel us a) prev)) ↔
      ∀ z, «计» (closureListed rel us z) (unitsOn prev us) =
        «计» (closureListed rel us z) (unitsOn next us) :=
  ⟨fun each z => (Bool.eq_false_or_eq_true (us.contains z)).elim
      (fun listed => (count_unitsOn (closureListed rel us z) prev us).trans
        ((each z (ListTests.contains_true_iff.mp listed)).symm.trans
          (count_unitsOn (closureListed rel us z) next us).symm))
      (fun unlisted => (count_unitsOn (closureListed rel us z) prev us).trans
        ((conserved_of_absent fun x m =>
            (Bool.eq_false_or_eq_true (closureListed rel us z x)).elim
              (fun inClosure => (ListTests.contains_false_iff.mp unlisted
                ((closureListed_unlisted (ListTests.contains_false_iff.mp unlisted) inClosure) ▸
                  m)).elim)
              id).symm.trans
          (count_unitsOn (closureListed rel us z) next us).symm)),
   fun counts a _ => (count_unitsOn (closureListed rel us a) next us).symm.trans
      ((counts a).symm.trans (count_unitsOn (closureListed rel us a) prev us))⟩

/-- **Conservation on every family the relation closes is the units paired under the closure.**
With equality decided, the units before (`unitsOn`) are paired one to one with the
units after under the closure, the grammar's `«所闭»` along adjacency among the listed relata,
exactly where the total is conserved on every family the relation closes. -/
theorem conservedOn_iff_units_paired [DecidableEq R] {rel : R → R → Bool} {us : List R}
    {prev next : R → Nat} :
    ConservedOn rel us prev next ↔
      «对» («所闭» (adjacentListed rel us)) (unitsOn prev us) (unitsOn next us) :=
  conservedOn_iff_closures.trans (closures_iff_unit_counts.trans pairing_iff_closures.symm)

/-- **Balancing transfers exist exactly where the units pair under the closure.** Over relata
listed without repetition, with equality decided, transfers along the relation that balance a step
exist exactly where the units before, each listed relatum repeated as often as its level, are
paired one to one with the units after under the closure along adjacency among the listed relata:
balance along the relation read at the grain of units, local to each closure, as
`Flow.balances_iff_units` reads a flow's balance at one condition under the one, with what is
given and taken among the units; here the closure takes the place of the transfers. -/
theorem balancing_iff_units_paired [DecidableEq R] {rel : R → R → Bool} {us : List R}
    {prev next : R → Nat} (distinct : Distinct us) :
    (∃ move, Balancing rel us prev next move) ↔
      «对» («所闭» (adjacentListed rel us)) (unitsOn prev us) (unitsOn next us) :=
  (balancing_iff distinct).trans conservedOn_iff_units_paired

/-- **On a web, balancing transfers exist exactly where the units pair under the closure, at every
step.** Over relata listed without repetition, with equality decided; the closures at each step
are taken along that step's adjacency among the listed relata. -/
theorem balancesOn_iff_units_paired [DecidableEq R] {us : List R} {rel : Nat → R → R → Bool}
    {W : Web R R} (distinct : Distinct us) :
    (∃ move : Nat → R → R → Nat,
        (∀ t a b, 0 < move t a b → adj (rel t) a b = true ∧ a ∈ us ∧ b ∈ us) ∧
          ∀ t, (flow us move).BalancesOn W us t) ↔
      ∀ t, «对» («所闭» (adjacentListed (rel t) us)) (unitsOn (W.level t) us)
        (unitsOn (W.level (t + 1)) us) :=
  (balancesOn_iff_conserved distinct).trans
    ⟨fun conserved t => conservedOn_iff_units_paired.mp (conserved t),
     fun paired t => conservedOn_iff_units_paired.mpr (paired t)⟩

/-! ## A pairing within a closure need not be along one step -/

namespace PathOfThree

/-- Each natural related to the next: listed as `[0, 1, 2]`, the path `0 — 1 — 2`. -/
def rel (x y : Nat) : Bool := Nat.beq (x + 1) y

/-- `[0]` and `[2]` are paired one to one under the closure along adjacency among `[0, 1, 2]`. -/
theorem paired_within : «对» («所闭» (adjacentListed rel [0, 1, 2])) [0] [2] :=
  «对».cons (b₁ := []) (b₂ := [])
    («所闭之传递» («缘在所闭» ⟨.head _, .tail _ (.head _), rfl⟩)
      («缘在所闭» ⟨.tail _ (.head _), .tail _ (.tail _ (.head _)), rfl⟩))
    «对».nil

/-- `0` and `2` are not adjacent, so no pairing along one step of the adjacency joins `[0]` with
`[2]`. -/
theorem not_paired_along_step : ¬ «对» (adjacentListed rel [0, 1, 2]) [0] [2] := by
  intro paired
  obtain ⟨_, adjacent, single⟩ := GrammarLaws.paired_single paired rfl
  cases single
  exact Bool.noConfusion adjacent.2.2

/-- **Counts kept on each closure do not give a pairing along one step.** On the path
`0 — 1 — 2`, each closure along adjacency among the listed relata holds as many entries of `[0]` as
of `[2]` (`Continuity.pairing_iff_closures`), and no pairing along one step of that adjacency joins
them. -/
theorem counts_kept_not_along_step :
    (∀ z, «计» (closureListed rel [0, 1, 2] z) [0] = «计» (closureListed rel [0, 1, 2] z) [2]) ∧
      ¬ «对» (adjacentListed rel [0, 1, 2]) [0] [2] :=
  ⟨pairing_iff_closures.mp paired_within, not_paired_along_step⟩

end PathOfThree

end Continuity

end Becoming
