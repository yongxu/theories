import Becoming.HeldPossible

/-!
# Causal sets, and what can be born next against what continues

Causal set theory takes spacetime to be a locally finite partial order, the order read as causal
precedence and local finiteness as discreteness (Bombelli, Lee, Meyer and Sorkin 1987). Its classical
sequential growth (Rideout and Sorkin 2000) grows a causal set one element at a time: each new
element is born maximal, with a down-set of the existing elements as its past. This module reads both
on the root and on processes.

* **Precedence is the reach of links where the order is discrete.** A link of a relation is a pair it
  relates with nothing it relates between (`links`). A link of the root's reach `«及» R` is a step of
  `R` (`link_of_reach`). On a naturally labelled order with decidable precedence, every pair is
  reached by links (`reach_links`): precedence is the reach of its links. A causal set's precedence
  has no cycle (`Causet.Ordered.acyclic`), so the root's reach of it is a strict order
  (`«无环则及为序»`). On `ω + 1` precedence is not the reach of its links:
  `some 0` precedes the top, infinitely many elements lie between, and the links never reach the top
  (`OmegaPlusOne.not_reach_top`). Reading precedence as the reach of conditioning needs the
  discreteness causal set theory assumes.
* **Sequential growth holds the past.** A configuration is a finite labelled causal set (`Causet`);
  a move chooses a stem, a set of elements closed downward (`Stem`), and gives birth to a new element
  preceded exactly by it (`birth`, `process`). Births keep every configuration a causal set
  (`birth_ordered`), keep the precedence below every existing element (`birth_holds`) and make the new
  element maximal (`birth_maximal`): internal temporality, read as holding the past
  (`step_holdsPast`), so the possible with the past held is the whole possible
  (`possibleHeld_iff`). Every stem stays a stem, and after each birth the stem of all elements is
  new, so on every course what can be born next keeps widening (`keepsWidening`).
* **What can be born next is the converse of precedence.** Of two configurations of one size, every
  stem of the first is a stem of the second exactly where the second's precedence is included in the
  first's (`stems_included_iff`). So of two courses from the empty set, one includes the other's
  stems at every offset exactly where its precedence is included in the other's at every offset
  (`rangeIncludes_iff`); it exceeds the other where the other has a pair it lacks
  (`rangeExceeds_of_pair`), and only where some offset's precedence is not included
  (`not_included_of_rangeExceeds`). Widening what can be born next never adds the continuation of any
  class read on precedence (`continuation_of_rangeIncludes`); within the one class continuation is
  precedence itself (`continuation_one_iff`), on links too where precedence is decidable
  (`continuation_links_one_iff`). Two courses compared by both have the same precedence at every offset
  (`alike_of_both`), so no course widens what can be born next and continues at least as much within
  the one class (`not_widens_and_continues`).
* **The extremes.** The course whose births all have the empty past includes the stems of every
  course (`antichain_rangeIncludes`) and widens those of every course with a precedence pair
  (`antichain_rangeWidens`); in it nothing continues in any class, on precedence or on links: every
  element begins and ends (`antichain_begins_ends`). The course whose births are all above every
  element has its stems included in every course's (`rangeIncludes_chain`) and widened by every
  course lacking one of its pairs (`rangeWidens_chain`), and in it every element
  after the first abides in the one class, on links (`chain_abides`).
* **Read on links, a finer class can gain continuation by widening.** On two courses, the first
  widening the second's stems, two elements of one class are linked in the first, and in the second
  an element of another class lies between them, so the class continues from one to the other only in
  the first (`Finer.widens`, `Finer.continues`, `Finer.not_continues`).

**Modelling choices.** Configurations are finite and labelled, elements `0` to `size - 1`, each
preceded only by smaller labels. Precedence is Prop-valued; `reach_links` asks for it to be
decidable. Comparisons are pointwise, with no function extensionality. Infinite causal sets are read
only as courses. Transition probabilities, Bell causality and discrete general covariance are not
read: the laws hold on every course, so every dynamics on the growth has them. Stems are compared by
inclusion, not counted.

Every declaration has an empty axiom report.
-/

namespace Becoming

open Generative

universe u

namespace CausalGrowth

/-! ## Precedence and links -/

section Links

variable {α : Type u}

/-- The links of a relation: the pairs it relates with nothing it relates between. -/
def links (O : «际» α) : «际» α := fun x y => O x y ∧ ∀ z, ¬ (O x z ∧ O z y)

/-- A link is a pair of the relation. -/
theorem links_le (O : «际» α) : «则» (links O) O := fun _ _ link => link.1

/-- **A link of the reach is a step**: a chain of two or more steps has a point between. -/
theorem link_of_reach {R : «际» α} {x y : α} (link : links («及» R) x y) : R x y :=
  match link with
  | ⟨.one step, _⟩ => step
  | ⟨.more step rest, nothing⟩ => (nothing _ ⟨«及».one step, rest⟩).elim

end Links

/-- A bounded search: whether some number below `n` has a decidable property. -/
def searchBelow (p : Nat → Prop) [DecidablePred p] : (n : Nat) → Decidable (∃ z, z < n ∧ p z)
  | 0 => isFalse fun ⟨_, below, _⟩ => Nat.not_lt_zero _ below
  | n + 1 =>
    match searchBelow p n with
    | isTrue found =>
      isTrue (match found with | ⟨z, below, holds⟩ => ⟨z, Nat.lt_succ_of_lt below, holds⟩)
    | isFalse absent =>
      if last : p n then isTrue ⟨n, Nat.lt_succ_self n, last⟩
      else isFalse fun ⟨z, below, holds⟩ =>
        match Nat.lt_or_eq_of_le (Nat.le_of_lt_succ below) with
        | .inl lower => absent ⟨z, lower, holds⟩
        | .inr same => last (same ▸ holds)

/-- Within a gap of `n` labels, a pair of a naturally labelled precedence is reached by links. -/
theorem reach_links_within {O : «际» Nat} [∀ i j, Decidable (O i j)]
    (labelled : ∀ {i j}, O i j → i < j) :
    ∀ n {i j : Nat}, j ≤ i + n → O i j → «及» (links O) i j
  | 0, _, _, gap, pair => absurd (Nat.lt_of_lt_of_le (labelled pair) gap) (Nat.lt_irrefl _)
  | n + 1, i, j, gap, pair =>
    match searchBelow (fun z => O i z ∧ O z j) j with
    | isTrue ⟨z, _, first, second⟩ =>
      «及之传递»
        (reach_links_within labelled n
          (Nat.le_of_lt_succ (Nat.lt_of_lt_of_le (labelled second) gap)) first)
        (reach_links_within labelled n
          (Nat.le_trans gap (by
            show Nat.succ (i + n) ≤ z + n
            rw [← Nat.succ_add]
            exact Nat.add_le_add_right (labelled first) n)) second)
    | isFalse nothing =>
      .one ⟨pair, fun z ⟨first, second⟩ => nothing ⟨z, labelled second, first, second⟩⟩

/-- **Precedence is the reach of its links** on a naturally labelled order with decidable
precedence: every pair is reached by links. -/
theorem reach_links {O : «际» Nat} [∀ i j, Decidable (O i j)] (labelled : ∀ {i j}, O i j → i < j)
    {i j : Nat} (pair : O i j) : «及» (links O) i j :=
  reach_links_within labelled j (Nat.le_add_left j i) pair

/-! ## `ω + 1`: precedence not the reach of links -/

namespace OmegaPlusOne

/-- `ω + 1`: the numbers in their order, and `none` above them all. -/
def prec : Option Nat → Option Nat → Prop
  | some a, some b => a < b
  | some _, none => True
  | none, _ => False

theorem prec_irrefl : ∀ x, ¬ prec x x
  | some a => Nat.lt_irrefl a
  | none => id

theorem prec_trans {x y z : Option Nat} (first : prec x y) (second : prec y z) : prec x z :=
  match x, y, z, first, second with
  | some _, some _, some _, first, second => Nat.lt_trans first second
  | some _, some _, none, _, _ => trivial
  | some _, none, some _, _, second => second.elim
  | some _, none, none, _, second => second.elim
  | none, _, _, first, _ => first.elim

/-- Every number precedes the top, and infinitely many lie between `some 0` and it. -/
theorem between (k : Nat) : prec (some 0) (some (k + 1)) ∧ prec (some (k + 1)) none :=
  ⟨Nat.succ_pos k, trivial⟩

/-- No link ends at the top: above every number another lies below the top. -/
theorem no_link_into_top (x : Option Nat) : ¬ links prec x none :=
  fun link => match x, link with
  | some a, ⟨_, nothing⟩ => nothing (some (a + 1)) ⟨Nat.lt_succ_self a, trivial⟩
  | none, ⟨below, _⟩ => below

theorem link_lands {x z : Option Nat} (link : links prec x z) : ∃ b, z = some b :=
  match z, link with
  | some b, _ => ⟨b, rfl⟩
  | none, link => absurd link (no_link_into_top x)

theorem reach_lands {x z : Option Nat} (reach : «及» (links prec) x z) : ∃ b, z = some b := by
  induction reach with
  | one link => exact link_lands link
  | more _ _ ih => exact ih

/-- **On `ω + 1` precedence is not the reach of its links**: `some 0` precedes the top, and the
links never reach it. -/
theorem not_reach_top : prec (some 0) none ∧ ¬ «及» (links prec) (some 0) none :=
  ⟨trivial, fun reach => match reach_lands reach with | ⟨_, landed⟩ => nomatch landed⟩

end OmegaPlusOne

/-! ## Sequential growth -/

/-- A labelled finite causal set: `size` elements, `0` to `size - 1`, and their precedence. -/
structure Causet where
  size : Nat
  prec : Nat → Nat → Prop

/-- A causal set of the growth: precedence transitive, each element preceded only by smaller labels,
and on the elements. -/
structure Causet.Ordered (c : Causet) : Prop where
  trans : ∀ {i j k}, c.prec i j → c.prec j k → c.prec i k
  labelled : ∀ {i j}, c.prec i j → i < j
  within : ∀ {i j}, c.prec i j → j < c.size

/-- A stem: elements closed downward under precedence, the past a new element can be born with. -/
structure Stem (c : Causet) (D : Nat → Prop) : Prop where
  within : ∀ {i}, D i → i < c.size
  closed : ∀ {i j}, D j → c.prec i j → D i

/-- A birth: the element `c.size` added, preceded exactly by `D`. -/
def birth (c : Causet) (D : Nat → Prop) : Causet :=
  ⟨c.size + 1, fun i j => c.prec i j ∨ (j = c.size ∧ D i)⟩

/-- **Sequential growth**: a move chooses a stem and gives birth with it as the new element's past. -/
def process : Process Causet (Nat → Prop) := ⟨fun c D c' => Stem c D ∧ c' = birth c D⟩

/-- The empty causal set. -/
def empty : Causet := ⟨0, fun _ _ => False⟩

section Growth

variable {c : Causet} {D : Nat → Prop}

theorem Causet.Ordered.irrefl (ordered : c.Ordered) (i : Nat) : ¬ c.prec i i :=
  fun pair => Nat.lt_irrefl i (ordered.labelled pair)

/-- Reach along a naturally labelled relation raises the label. -/
theorem labelled_of_reach {O : «际» Nat} (labelled : ∀ {i j}, O i j → i < j) {i j : Nat}
    (reach : «及» O i j) : i < j := by
  induction reach with
  | one step => exact labelled step
  | more step _ ih => exact Nat.lt_trans (labelled step) ih

/-- **A causal set's precedence has no cycle** (`«无环»`), so its reach is a strict order
(`«无环则及为序»`). -/
theorem Causet.Ordered.acyclic (ordered : c.Ordered) : «无环» c.prec :=
  fun i reach => Nat.lt_irrefl i (labelled_of_reach ordered.labelled reach)

theorem empty_ordered : empty.Ordered := ⟨fun pair => pair.elim, fun pair => pair.elim, fun pair => pair.elim⟩

/-- A birth keeps a causal set a causal set. -/
theorem birth_ordered (ordered : c.Ordered) (stem : Stem c D) : (birth c D).Ordered where
  trans := fun first second => match first, second with
    | .inl p, .inl q => .inl (ordered.trans p q)
    | .inl p, .inr ⟨top, d⟩ => .inr ⟨top, stem.closed d p⟩
    | .inr ⟨top, _⟩, .inl q =>
      absurd top (Nat.ne_of_lt (Nat.lt_trans (ordered.labelled q) (ordered.within q)))
    | .inr ⟨top, _⟩, .inr ⟨_, d⟩ => absurd top (Nat.ne_of_lt (stem.within d))
  labelled := fun pair => match pair with
    | .inl p => ordered.labelled p
    | .inr ⟨top, d⟩ => top ▸ stem.within d
  within := fun pair => match pair with
    | .inl p => Nat.lt_succ_of_lt (ordered.within p)
    | .inr ⟨top, _⟩ => top ▸ Nat.lt_succ_self c.size

/-- **A birth holds the past**: below every existing element the precedence is as it was. -/
theorem birth_holds {i j : Nat} (old : j < c.size) : (birth c D).prec i j ↔ c.prec i j :=
  ⟨fun pair => match pair with
     | .inl p => p
     | .inr ⟨top, _⟩ => absurd top (Nat.ne_of_lt old),
   .inl⟩

/-- **The new element is maximal**: it precedes nothing. -/
theorem birth_maximal (ordered : c.Ordered) (stem : Stem c D) (j : Nat) :
    ¬ (birth c D).prec c.size j :=
  fun pair => match pair with
  | .inl p => Nat.lt_irrefl _ (Nat.lt_trans (ordered.labelled p) (ordered.within p))
  | .inr ⟨_, d⟩ => Nat.lt_irrefl _ (stem.within d)

/-- Holding the past: the second configuration has the first's elements, with the precedence below
each of them as it was. -/
def HoldsPast (c c' : Causet) : Prop :=
  c.size ≤ c'.size ∧ ∀ i j, j < c.size → (c'.prec i j ↔ c.prec i j)

/-- **Internal temporality is holding the past**: every move of the growth holds it. -/
theorem step_holdsPast {c c' : Causet} {D : Nat → Prop} (step : process.step c D c') :
    HoldsPast c c' :=
  match step with
  | ⟨_, born⟩ => by subst born; exact ⟨Nat.le_succ c.size, fun _ _ old => birth_holds old⟩

/-- **The possible with the past held is the whole possible.** -/
theorem possibleHeld_iff {X : Type} {adm : Causet → X → Prop} {s : Causet} {x : X} :
    Reaching.PossibleHeld process HoldsPast adm s x ↔ Reaching.Possible process adm s x :=
  ⟨Reaching.PossibleHeld.possible, fun ⟨t, reach, admitted⟩ =>
    ⟨t, Reach.map (P := process) (Q := Reaching.heldMoves process HoldsPast) (f := id)
      (fun _ _ _ step => ⟨step, step_holdsPast step⟩) reach, admitted⟩⟩

/-- A stem stays a stem across a birth. -/
theorem Stem.after {D' : Nat → Prop} (stem : Stem c D) : Stem (birth c D') D :=
  ⟨fun d => Nat.lt_succ_of_lt (stem.within d), fun d pair => match pair with
    | .inl p => stem.closed d p
    | .inr ⟨top, _⟩ => absurd top (Nat.ne_of_lt (stem.within d))⟩

/-- All the elements. -/
def all (c : Causet) : Nat → Prop := fun i => i < c.size

theorem stem_all (ordered : c.Ordered) : Stem c (all c) :=
  ⟨id, fun inside pair => Nat.lt_trans (ordered.labelled pair) inside⟩

/-- After a birth, all the elements are a stem that was not one before. -/
theorem not_stem_all_birth : ¬ Stem c (all (birth c D)) :=
  fun stem => Nat.lt_irrefl _ (stem.within (Nat.lt_succ_self c.size))

/-- Along a course from a causal set, every configuration is a causal set. -/
theorem ordered_of_run {r : Run process} (start : (r.state 0).Ordered) : ∀ t, (r.state t).Ordered
  | 0 => start
  | t + 1 => match r.step t with
    | ⟨stem, born⟩ => born ▸ birth_ordered (ordered_of_run start t) stem

/-- **What can be born next keeps widening on every course**: every stem stays one, and after each
birth the stem of all elements is new (UE10's `KeepsWidening`). -/
theorem keepsWidening (r : Run process) (start : (r.state 0).Ordered) :
    Reaching.KeepsWidening (fun t => Stem (r.state t)) :=
  ⟨fun n d D stem => kept n d D stem, fun n =>
    ⟨1, all (r.state (n + 1)), stem_all (ordered_of_run start (n + 1)), fun stem =>
      match r.step n with
      | ⟨_, born⟩ => Nat.lt_irrefl _ (stem.within (by rw [born]; exact Nat.lt_succ_self _))⟩⟩
where
  kept (n : Nat) : ∀ d D, Stem (r.state n) D → Stem (r.state (n + d)) D
    | 0, _, stem => stem
    | d + 1, D, stem => by
      show Stem (r.state (n + d + 1)) D
      match r.step (n + d) with
      | ⟨_, born⟩ => rw [born]; exact (kept n d D stem).after

end Growth

/-! ## What can be born next against precedence -/

section Converse

/-- The principal stem at `j`: `j` and what precedes it. -/
def principal (c : Causet) (j : Nat) : Nat → Prop := fun i => i = j ∨ c.prec i j

theorem stem_principal {c : Causet} (ordered : c.Ordered) {j : Nat} (inside : j < c.size) :
    Stem c (principal c j) :=
  ⟨fun d => match d with
     | .inl same => same ▸ inside
     | .inr p => Nat.lt_trans (ordered.labelled p) inside,
   fun d pair => match d with
     | .inl same => .inr (same ▸ pair)
     | .inr p => .inr (ordered.trans pair p)⟩

/-- **The stems are the converse of the precedence**: of two causal sets of one size, every stem of
the first is a stem of the second exactly where the second's precedence is included in the first's. -/
theorem stems_included_iff {c c' : Causet} (ordered : c.Ordered) (ordered' : c'.Ordered)
    (size : c.size = c'.size) :
    (∀ D, Stem c D → Stem c' D) ↔ ∀ i j, c'.prec i j → c.prec i j :=
  ⟨fun included i j pair =>
     match (included _ (stem_principal ordered (size ▸ ordered'.within pair))).closed (.inl rfl) pair with
     | .inl same => by subst same; exact absurd pair (ordered'.irrefl _)
     | .inr p => p,
   fun inside _ stem => ⟨fun d => size ▸ stem.within d, fun d pair => stem.closed d (inside _ _ pair)⟩⟩

/-- Along a course from the empty set, the configuration at offset `t` has `t` elements. -/
theorem size_of_run {r : Run process} (start : r.state 0 = empty) : ∀ t, (r.state t).size = t
  | 0 => by rw [start]; rfl
  | t + 1 => match r.step t with
    | ⟨_, born⟩ => by rw [born]; exact congrArg Nat.succ (size_of_run start t)

theorem ordered_of_empty {r : Run process} (start : r.state 0 = empty) (t : Nat) :
    (r.state t).Ordered :=
  ordered_of_run (by rw [start]; exact empty_ordered) t

variable {r r' : Run process}

/-- **Of two courses from the empty set, one includes the other's stems exactly where its
precedence is included**, at every offset. -/
theorem rangeIncludes_iff (start : r.state 0 = empty) (start' : r'.state 0 = empty) :
    r.RangeIncludes Stem r' ↔ ∀ t i j, (r.state t).prec i j → (r'.state t).prec i j :=
  ⟨fun included t => (stems_included_iff (ordered_of_empty start' t) (ordered_of_empty start t)
      ((size_of_run start' t).trans (size_of_run start t).symm)).mp (included t),
   fun inside t => (stems_included_iff (ordered_of_empty start' t) (ordered_of_empty start t)
      ((size_of_run start' t).trans (size_of_run start t).symm)).mpr (inside t)⟩

/-- A course exceeds another's stems where the other has a precedence pair it lacks. -/
theorem rangeExceeds_of_pair (start : r.state 0 = empty) (start' : r'.state 0 = empty) {t i j : Nat}
    (pair' : (r'.state t).prec i j) (lacks : ¬ (r.state t).prec i j) : r.RangeExceeds Stem r' :=
  ⟨t, principal (r.state t) j,
   stem_principal (ordered_of_empty start t)
     (by rw [size_of_run start t, ← size_of_run start' t]; exact (ordered_of_empty start' t).within pair'),
   fun stem => match stem.closed (.inl rfl) pair' with
     | .inl same => by subst same; exact (ordered_of_empty start' t).irrefl _ pair'
     | .inr p => lacks p⟩

/-- A course exceeds another's stems only where, at some offset, the other's precedence is not
included in its own. -/
theorem not_included_of_rangeExceeds (start : r.state 0 = empty) (start' : r'.state 0 = empty)
    (exceeds : r.RangeExceeds Stem r') :
    ∃ t, ¬ ∀ i j, (r'.state t).prec i j → (r.state t).prec i j :=
  match exceeds with
  | ⟨t, _, stem, not⟩ => ⟨t, fun inside =>
      not ((stems_included_iff (ordered_of_empty start t) (ordered_of_empty start' t)
        ((size_of_run start t).trans (size_of_run start' t).symm)).mpr inside _ stem)⟩

/-- **Widening what can be born next is losing precedence**: a course widens another's stems where
its precedence is included in the other's at every offset and the other has a pair it lacks. -/
theorem rangeWidens_of (start : r.state 0 = empty) (start' : r'.state 0 = empty)
    (inside : ∀ t i j, (r.state t).prec i j → (r'.state t).prec i j) {t i j : Nat}
    (pair' : (r'.state t).prec i j) (lacks : ¬ (r.state t).prec i j) : r.RangeWidens Stem r' :=
  ⟨(rangeIncludes_iff start start').mpr inside, rangeExceeds_of_pair start start' pair' lacks⟩

/-- **Widening what can be born next never adds continuation** of any class read on precedence. -/
theorem continuation_of_rangeIncludes (start : r.state 0 = empty) (start' : r'.state 0 = empty)
    (included : r.RangeIncludes Stem r') (E : «际» Nat) (t : Nat) :
    «则» («相续» (r.state t).prec E) («相续» (r'.state t).prec E) :=
  «及之单调» fun x y ⟨pair, alike⟩ => ⟨(rangeIncludes_iff start start').mp included t x y pair, alike⟩

/-- Within the one class, continuation is precedence. -/
theorem continuation_one_iff {c : Causet} (ordered : c.Ordered) {i j : Nat} :
    «相续» c.prec «一» i j ↔ c.prec i j :=
  ⟨fun line => by
     change «及» («续» c.prec «一») i j at line
     induction line with
     | one step => exact step.1
     | more step _ ih => exact ordered.trans step.1 ih,
   fun pair => «及».one ⟨pair, trivial⟩⟩

/-- **Within the one class, continuation along the links is precedence**, where precedence is
decidable: the links' reach (`reach_links`). -/
theorem continuation_links_one_iff {c : Causet} (ordered : c.Ordered) [∀ i j, Decidable (c.prec i j)]
    {i j : Nat} : «相续» (links c.prec) «一» i j ↔ c.prec i j :=
  ⟨fun line => by
     change «及» («续» (links c.prec) «一») i j at line
     induction line with
     | one step => exact step.1.1
     | more step _ ih => exact ordered.trans step.1.1 ih,
   fun pair => «及之单调» (fun _ _ link => ⟨link, trivial⟩) i j (reach_links ordered.labelled pair)⟩

/-- **Two courses compared by both are alike**: where one includes the other's stems and continues
at least as much within the one class, at every offset, the two have the same precedence. -/
theorem alike_of_both (start : r.state 0 = empty) (start' : r'.state 0 = empty)
    (included : r.RangeIncludes Stem r')
    (continues : ∀ t, «则» («相续» (r'.state t).prec «一») («相续» (r.state t).prec «一»)) :
    ∀ t i j, (r.state t).prec i j ↔ (r'.state t).prec i j :=
  fun t i j =>
    ⟨(rangeIncludes_iff start start').mp included t i j, fun pair' =>
      (continuation_one_iff (ordered_of_empty start t)).mp
        (continues t i j ((continuation_one_iff (ordered_of_empty start' t)).mpr pair'))⟩

/-- **No course widens what can be born next and continues at least as much** within the one class. -/
theorem not_widens_and_continues (start : r.state 0 = empty) (start' : r'.state 0 = empty)
    (widens : r.RangeWidens Stem r') :
    ¬ ∀ t, «则» («相续» (r'.state t).prec «一») («相续» (r.state t).prec «一») :=
  fun continues => match not_included_of_rangeExceeds start start' widens.2 with
  | ⟨t, not⟩ => not fun i j => (alike_of_both start start' widens.1 continues t i j).mpr

end Converse

/-! ## Courses given by their pasts -/

section Courses

/-- The configuration after the births with pasts `past 0, past 1, …`. -/
def grown (past : Nat → Nat → Prop) : Nat → Causet
  | 0 => empty
  | t + 1 => birth (grown past t) (past t)

theorem grown_size (past : Nat → Nat → Prop) : ∀ t, (grown past t).size = t
  | 0 => rfl
  | t + 1 => congrArg Nat.succ (grown_size past t)

/-- **The precedence of a grown configuration**: `i` precedes `j` exactly where `j` is born by then
with `i` in its past. -/
theorem grown_prec_iff (past : Nat → Nat → Prop) :
    ∀ t {i j : Nat}, (grown past t).prec i j ↔ j < t ∧ past j i
  | 0, _, _ => ⟨False.elim, fun ⟨below, _⟩ => absurd below (Nat.not_lt_zero _)⟩
  | t + 1, i, j =>
    ⟨fun pair => match pair with
       | .inl p => match (grown_prec_iff past t).mp p with
         | ⟨below, d⟩ => ⟨Nat.lt_succ_of_lt below, d⟩
       | .inr ⟨top, d⟩ => by
         rw [grown_size] at top
         subst top
         exact ⟨Nat.lt_succ_self _, d⟩,
     fun ⟨below, d⟩ => match Nat.lt_or_eq_of_le (Nat.le_of_lt_succ below) with
       | .inl lower => .inl ((grown_prec_iff past t).mpr ⟨lower, d⟩)
       | .inr same => .inr ⟨same.trans (grown_size past t).symm, by subst same; exact d⟩⟩

/-- A course of births, given that each past is a stem when it is chosen. -/
def course (past : Nat → Nat → Prop) (stems : ∀ t, Stem (grown past t) (past t)) : Run process :=
  ⟨grown past, past, fun _ => ⟨stems _, rfl⟩⟩

theorem course_start (past : Nat → Nat → Prop) (stems : ∀ t, Stem (grown past t) (past t)) :
    (course past stems).state 0 = empty := rfl

/-- Every birth with the empty past. -/
def antichain : Run process :=
  course (fun _ _ => False) fun _ => ⟨False.elim, fun d _ => d⟩

/-- Every birth above every element. -/
def chain : Run process :=
  course (fun t i => i < t) fun t => ⟨fun d => by rw [grown_size]; exact d, fun d pair =>
    match (grown_prec_iff (fun t i => i < t) t).mp pair with
    | ⟨_, earlier⟩ => Nat.lt_trans earlier d⟩

theorem antichain_prec (t i j : Nat) : ¬ (antichain.state t).prec i j :=
  fun pair => ((grown_prec_iff _ t).mp pair).2

theorem chain_prec_iff (t : Nat) {i j : Nat} : (chain.state t).prec i j ↔ j < t ∧ i < j :=
  grown_prec_iff _ t

variable {r : Run process}

/-- **The course of births with empty pasts includes the stems of every course.** -/
theorem antichain_rangeIncludes (start : r.state 0 = empty) : antichain.RangeIncludes Stem r :=
  (rangeIncludes_iff rfl start).mpr fun t i j pair => absurd pair (antichain_prec t i j)

/-- **It widens the stems of every course with a precedence pair.** -/
theorem antichain_rangeWidens (start : r.state 0 = empty) {t i j : Nat}
    (pair : (r.state t).prec i j) : antichain.RangeWidens Stem r :=
  rangeWidens_of rfl start (fun t i j pair => absurd pair (antichain_prec t i j)) pair
    (antichain_prec t i j)

/-- **In it nothing continues in any class**, on precedence or on links: every element begins and
ends. -/
theorem antichain_begins_ends (E : «际» Nat) (t x : Nat) :
    «生» (antichain.state t).prec E x ∧ «亡» (antichain.state t).prec E x ∧
      «生» (links (antichain.state t).prec) E x ∧ «亡» (links (antichain.state t).prec) E x :=
  ⟨fun ⟨w, pair, _⟩ => antichain_prec t w x pair, fun ⟨y, pair, _⟩ => antichain_prec t x y pair,
   fun ⟨w, link, _⟩ => antichain_prec t w x link.1, fun ⟨y, link, _⟩ => antichain_prec t x y link.1⟩

/-- **The course of births above every element has its stems included in every course's.** -/
theorem rangeIncludes_chain (start : r.state 0 = empty) : r.RangeIncludes Stem chain :=
  (rangeIncludes_iff start rfl).mpr fun t _ _ pair =>
    (chain_prec_iff t).mpr
      ⟨Nat.lt_of_lt_of_le ((ordered_of_empty start t).within pair) (Nat.le_of_eq (size_of_run start t)),
       (ordered_of_empty start t).labelled pair⟩

/-- **Every course lacking a pair of the chain widens the chain's stems.** -/
theorem rangeWidens_chain (start : r.state 0 = empty) {t i j : Nat} (later : j < t) (earlier : i < j)
    (lacks : ¬ (r.state t).prec i j) : r.RangeWidens Stem chain :=
  ⟨rangeIncludes_chain start, rangeExceeds_of_pair start rfl ((chain_prec_iff t).mpr ⟨later, earlier⟩) lacks⟩

/-- On the chain, each element is linked to the next. -/
theorem chain_link {t k : Nat} (born : k + 1 < t) : links (chain.state t).prec k (k + 1) :=
  ⟨(chain_prec_iff t).mpr ⟨born, Nat.lt_succ_self k⟩, fun _ ⟨first, second⟩ =>
    Nat.lt_irrefl _ (Nat.lt_of_lt_of_le ((chain_prec_iff t).mp first).2
      (Nat.le_of_lt_succ ((chain_prec_iff t).mp second).2))⟩

/-- **On the chain every element after the first abides** in the one class, on links, once the
next is born. -/
theorem chain_abides {t k : Nat} (born : k + 2 < t) :
    «住» (links (chain.state t).prec) «一» (k + 1) :=
  ⟨⟨k, chain_link (Nat.lt_trans (Nat.lt_succ_self _) born), trivial⟩,
   ⟨k + 2, chain_link born, trivial⟩⟩

end Courses

/-! ## Read on links, a finer class can gain continuation by widening -/

namespace Finer

/-- The wider course's pasts: element `2` is born above `0`; every other with the empty past. -/
def widePast (t i : Nat) : Prop := t = 2 ∧ i = 0

/-- The narrower course's pasts: `1` above `0`, `2` above `0` and `1`, every other with the empty
past. -/
def narrowPast (t i : Nat) : Prop := (t = 1 ∧ i = 0) ∨ (t = 2 ∧ i < 2)

/-- The class: `1` alone, and every other element. -/
def classOf (i j : Nat) : Prop := (i = 1 ↔ j = 1)

theorem classOf_class : «类» classOf :=
  ⟨fun _ => Iff.rfl, fun same => same.symm, fun first second => first.trans second⟩

theorem wide_stems (t : Nat) : Stem (grown widePast t) (widePast t) :=
  ⟨fun ⟨two, zero⟩ => by rw [grown_size, two, zero]; decide,
   fun ⟨_, zero⟩ pair => absurd (zero.symm.trans ((grown_prec_iff widePast t).mp pair).2.1) (by decide)⟩

theorem narrow_stems (t : Nat) : Stem (grown narrowPast t) (narrowPast t) :=
  ⟨fun d => match d with
     | .inl ⟨one, zero⟩ => by rw [grown_size, one, zero]; decide
     | .inr ⟨two, below⟩ => by rw [grown_size, two]; exact below,
   fun d pair => match d, ((grown_prec_iff narrowPast t).mp pair).2 with
     | .inl ⟨_, zero⟩, .inl ⟨one, _⟩ => absurd (zero.symm.trans one) (by decide)
     | .inl ⟨_, zero⟩, .inr ⟨two, _⟩ => absurd (zero.symm.trans two) (by decide)
     | .inr ⟨two, _⟩, .inl ⟨_, zero⟩ => .inr ⟨two, by rw [zero]; decide⟩
     | .inr ⟨_, below⟩, .inr ⟨two, _⟩ => (Nat.ne_of_lt below two).elim⟩

def wide : Run process := course widePast wide_stems

def narrow : Run process := course narrowPast narrow_stems

/-- **The wider course widens the narrower's stems.** -/
theorem widens : wide.RangeWidens Stem narrow :=
  rangeWidens_of (t := 2) (i := 0) (j := 1) rfl rfl
    (fun t _ _ pair => match (grown_prec_iff widePast t).mp pair with
      | ⟨below, two, zero⟩ => (grown_prec_iff narrowPast t).mpr ⟨below, .inr ⟨two, by rw [zero]; decide⟩⟩)
    ((grown_prec_iff narrowPast 2).mpr ⟨by decide, .inl ⟨rfl, rfl⟩⟩)
    (fun pair => absurd ((grown_prec_iff widePast 2).mp pair).2.1 (by decide))

/-- **In the wider course, `0` and `2` are linked**, and the class continues from one to the other. -/
theorem continues : «相续» (links (wide.state 3).prec) classOf 0 2 :=
  «及».one ⟨⟨(grown_prec_iff widePast 3).mpr ⟨by decide, rfl, rfl⟩, fun z ⟨first, second⟩ =>
    match (grown_prec_iff widePast 3).mp first, (grown_prec_iff widePast 3).mp second with
    | ⟨_, two, _⟩, ⟨_, _, zero⟩ => absurd (two.symm.trans zero) (by decide)⟩,
   ⟨fun e => absurd e (by decide), fun e => absurd e (by decide)⟩⟩

/-- **In the narrower course, `1` lies between**, of another class, and the class does not continue
from `0` to `2`. -/
theorem not_continues : ¬ «相续» (links (narrow.state 3).prec) classOf 0 2 :=
  fun line => first_step (match line with
    | «及».one step => ⟨2, step⟩
    | «及».more step _ => ⟨_, step⟩)
where
  first_step : (∃ y, «续» (links (narrow.state 3).prec) classOf 0 y) → False
    | ⟨y, ⟨pair, nothing⟩, same⟩ =>
      match (grown_prec_iff narrowPast 3).mp pair with
      | ⟨_, .inl ⟨one, _⟩⟩ => absurd (same.mpr one) (by decide)
      | ⟨_, .inr ⟨two, _⟩⟩ => nothing 1
          ⟨(grown_prec_iff narrowPast 3).mpr ⟨by decide, .inl ⟨rfl, rfl⟩⟩,
           by rw [two]; exact (grown_prec_iff narrowPast 3).mpr ⟨by decide, .inr ⟨rfl, by decide⟩⟩⟩

end Finer

end CausalGrowth

end Becoming
