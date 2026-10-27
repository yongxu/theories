import Becoming.HeldPossible

/-!
# Causal sets, and what can be born next against what continues

Causal set theory takes spacetime to be a locally finite partial order, the order read as causal
precedence and local finiteness as discreteness (Bombelli, Lee, Meyer and Sorkin 1987). Its classical
sequential growth (Rideout and Sorkin 2000) grows a causal set one element at a time: each new
element is born maximal, with a down-set of the existing elements as its past. This module reads both
on the root and on processes.

* **Precedence and its links.** The links of a relation, causal set theory's term, are its covering
  pairs: the pairs it relates with nothing it relates between (`links`). A link of the root's reach
  `«及» R` is a step of `R` (`link_of_reach`), so every net whose reach is a relation contains that
  relation's links (`links_least`). On a naturally labelled relation on the numbers, each element
  preceded only by smaller labels, with decidable precedence, every pair is reached by links
  (`reach_links`), finite or not (`nat_reach_links`); with transitivity, so on a causal set,
  precedence is the reach of its links both ways (`reach_links_iff`, `ordered_reach_links_iff`), and
  the links are the least net whose reach it is. Without transitivity only one inclusion holds
  (`path_not_reach_of_links`). Deciding what lies between two elements suffices
  (`reach_links_of_decided`) and cannot be dropped: that every pair of every causal set is reached by
  links is excluded middle (`reach_links_all_iff_em`), and so is that every pair on every
  configuration of every course from the empty set is (`reach_links_courses_iff_em`), since telling a
  link from a longer chain is deciding whether anything lies between. On `ω + 1` `some 0` precedes
  the top and the links never reach it (`OmegaPlusOne.not_reach_top`): reading precedence as the
  reach of its links can fail where the order is not locally finite. A causal set's precedence has no
  cycle (`Causet.Ordered.acyclic`), so the root's reach of it is a strict order (`«无环则及为序»`).
* **Sequential growth holds the past.** A configuration is a finite labelled causal set (`Causet`);
  a move chooses a stem, a set of elements closed downward (`Stem`), and gives birth to a new element
  preceded exactly by it (`birth`, `process`). Births keep a causal set a causal set
  (`birth_ordered`), keep the precedence below every existing element (`birth_holds`) and make the
  new element maximal (`birth_maximal`): internal temporality, with the parent kept as it was, is
  holding the past (`step_holdsPast`), so the possible with the past held is the whole possible
  (`possibleHeld_iff`). On every course from a causal set every stem stays a stem, and after each
  birth the stem of all elements is new, so what each configuration admits next keeps widening
  (`keepsWidening`), within a whole possible that never grows (`stem_possible_from_start`). The
  start must be a causal set: from a configuration relating every pair nothing keeps widening
  (`Starts.keepsWidening_needs_start`).
* **What can be born next reverses the inclusion of precedence.** Of two causal sets of one size,
  every stem of the first is a stem of the second exactly where the second's precedence is included
  in the first's (`stems_included_iff`). So of two courses from the empty set, one includes the
  other's stems at every offset exactly where its precedence is included in the other's at every
  offset (`rangeIncludes_iff`), and strictly exactly where strictly (`rangeIncludes_strict_iff`). It
  widens them where, besides, the other has a pair it lacks (`rangeWidens_of`), and with precedence
  decided only there (`rangeExceeds_iff_pair`); for every pair of such courses, finding that pair is
  excluded middle (`pair_converse_iff_em`). Widening adds no continuation of any class read on
  precedence (`continuation_of_rangeIncludes`); within the one class continuation is precedence
  (`continuation_one_iff`), on links too where precedence is decidable
  (`continuation_links_one_iff`, `continuation_links_one_of_rangeIncludes`). Compared by both, two
  such courses have the same precedence at every offset (`prec_iff_of_both`), so of two such courses
  neither widens what can be born next while continuing at least as much within the one class
  (`not_widens_and_continues`).
* **The extremes.** Of the courses from the empty set, the course whose births all have the empty
  past includes every such course's stems (`antichain_rangeIncludes`) and widens those of every such
  course with a precedence pair (`antichain_rangeWidens`); in it every element begins and ends in
  every class, on precedence and on links (`antichain_begins_ends`). Every course from the empty set
  includes the stems of the course whose births are all above every element
  (`rangeIncludes_chain`), and every such course lacking one of its pairs widens them
  (`rangeWidens_chain`); the chain has the most continuation of every class read on precedence
  (`continuation_le_chain`), in it every element after the first abides in the one class, on links,
  once the next is born (`chain_abides`), and the last element ends (`chain_last_ends`).
* **Two readings of widening, reversed.** Of two courses from the empty set, read on what continues
  within the one class (`continuing`), one widens the other exactly where its precedence includes
  the other's together with a pair the other lacks (`rangeWidens_continuing_iff`), and it then
  narrows what can be born next (`rangeWidens_stems_of_continuing`); so the chain widens every such
  course lacking one of its pairs (`chain_rangeWidens_continuing`). That narrowing what can be born
  next always widens what continues is again excluded middle (`stems_converse_iff_em`). No strict
  order contains both widenings (`no_order_contains_both`). Read on both together, of two courses
  from the empty set neither widens the other (`not_rangeWidens_formsOrContinues`), and two such
  courses one of which lacks a pair of the other are mixed (`mixed_of_pair`). An order never
  reversing widening what can be born next ranks no course from the empty set with a precedence pair
  above the course of empty pasts (`not_above_antichain`), and the chain above no such course
  lacking one of its pairs (`chain_not_above`).
* **The courses' start.** These comparisons take both courses from the empty set, and most fail
  without it: from one element with every past empty, a course widens the antichain's stems while
  each one's precedence, empty, is included in the other's (`Starts.fromOne_widens`,
  `Starts.strict_needs_starts`), and courses from other configurations refute the rest
  (`Starts.rangeWidens_of_needs_starts`, `Starts.mixed_of_pair_needs_starts`,
  `Starts.prec_iff_of_both_needs_starts` and the other laws of `Starts`).
* **No configuration renews without end.** On every causal set of the growth every element ceases
  (`«息»`) in every class, on precedence and on links (`ordered_ceases`), so the grammar's renewal
  without end (`«生生»`) holds on no configuration (`ordered_not_renews`). In the limits of the
  extremes the two part: on the antichain's nothing renews without end
  (`antichainLimit_not_renews`), on the chain's an element renews without end under the class
  pairing `2m` with `2m + 1` (`chainLimit_renews`).
* **A finer class on links.** On two courses, the first widening the second's stems, two elements of
  one class are linked in the first, while in the second an element of another class lies between
  them, so the class continues from one to the other only in the first (`Finer.widens`,
  `Finer.continues`, `Finer.not_continues`); widening can also remove such continuation
  (`Finer.loses`).
* **Up to relabelling.** The comparisons of courses are labelled, while causal set theory takes
  labels to carry no physical meaning. Wherever the elements of one configuration are carried one to
  one into another's, as by the inverse of a relabelling, the pasts still reverse the inclusion of
  precedence (`Kinds.stems_carried_iff`); the two need not have one size
  (`Kinds.stems_carried_unequal`). The kinds of birth, births up to relabelling, do not: at offset 2
  two stems of the antichain give one kind of birth (`Kinds.antichain_two_stems_one_kind`), and
  neither the antichain's kinds of birth nor the chain's are among the other's
  (`Kinds.not_included_antichain_chain`, `Kinds.not_included_chain_antichain`), while at offset 0
  each is among the other's (`Kinds.included_at_zero`). The order on courses stays labelled: two
  courses growing configurations of one kind at every offset from 2 on each exceed the other's stems
  (`Kinds.wide_swapped_isomorphic`, `Kinds.wide_swapped_mixed`).

**Modelling choices.** Configurations are finite and labelled, elements `0` to `size - 1`, each
preceded only by smaller labels; courses are compared at the same offsets and from the empty set, so
the order on courses is labelled. Precedence is Prop-valued; `reach_links`, `reach_links_iff`,
`ordered_reach_links_iff`, `continuation_links_one_iff`, `continuation_links_one_of_rangeIncludes`,
`pair_of_not_included` and `rangeExceeds_iff_pair` ask for it to be decidable, and
`reach_links_of_decided` only that what lies between be decided. Comparisons are pointwise, with no
function extensionality. Infinite causal sets are read as courses and their limits, and, for the
links, as naturally labelled relations on the numbers. Transition probabilities, Bell causality and
discrete general covariance as a condition on a dynamics are not read: the laws hold on every
course, so every dynamics on the growth has them. Stems are compared by inclusion, not counted.

Every declaration has an empty axiom report.
-/

namespace Becoming

open Generative

universe u

namespace CausalGrowth

/-! ## Precedence and its links -/

section Links

variable {α : Type u}

/-- The links of a relation, causal set theory's term: its covering pairs, the pairs it relates
with nothing it relates between. -/
def links (O : «际» α) : «际» α := fun x y => O x y ∧ ∀ z, ¬ (O x z ∧ O z y)

/-- A link is a pair of the relation. -/
theorem links_le (O : «际» α) : «则» (links O) O := fun _ _ link => link.1

/-- **A link of the reach is a step**: a chain of two or more steps has a point between. -/
theorem link_of_reach {R : «际» α} {x y : α} (link : links («及» R) x y) : R x y :=
  match link with
  | ⟨.one step, _⟩ => step
  | ⟨.more step rest, nothing⟩ => (nothing _ ⟨«及».one step, rest⟩).elim

/-- The reach of the links lies within a transitive relation. -/
theorem reach_links_le {O : «际» α} (trans : ∀ {i j k}, O i j → O j k → O i k) {i j : α}
    (reach : «及» (links O) i j) : O i j := by
  induction reach with
  | one link => exact link.1
  | more link _ ih => exact trans link.1 ih

/-- **Every net whose reach is a relation contains that relation's links**, on any carrier: with
`reach_links_iff`, on a naturally labelled order with decidable precedence the links are the least
net whose reach is the precedence. -/
theorem links_least {O R : «际» α} (generates : ∀ i j, «及» R i j ↔ O i j) {i j : α}
    (link : links O i j) : R i j :=
  link_of_reach ⟨(generates i j).mpr link.1,
    fun z ⟨first, second⟩ => link.2 z ⟨(generates i z).mp first, (generates z j).mp second⟩⟩

/-- Two relations relating the same pairs have the same links. -/
theorem links_of_iff {O O' : «际» α} (same : ∀ i j, O i j ↔ O' i j) {i j : α}
    (link : links O i j) : links O' i j :=
  ⟨(same i j).mp link.1, fun z ⟨first, second⟩ =>
    link.2 z ⟨(same i z).mpr first, (same z j).mpr second⟩⟩

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

/-- Within a gap of `n` labels, a pair of a naturally labelled relation is reached by links. -/
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

/-- **Every pair is reached by links** on a naturally labelled relation with decidable precedence;
with transitivity, precedence is the reach of its links (`reach_links_iff`). -/
theorem reach_links {O : «际» Nat} [∀ i j, Decidable (O i j)] (labelled : ∀ {i j}, O i j → i < j)
    {i j : Nat} (pair : O i j) : «及» (links O) i j :=
  reach_links_within labelled j (Nat.le_add_left j i) pair

/-- **Precedence is the reach of its links**, both inclusions, on a naturally labelled transitive
relation with decidable precedence. -/
theorem reach_links_iff {O : «际» Nat} [∀ i j, Decidable (O i j)]
    (trans : ∀ {i j k}, O i j → O j k → O i k) (labelled : ∀ {i j}, O i j → i < j) {i j : Nat} :
    «及» (links O) i j ↔ O i j :=
  ⟨reach_links_le (O := O) trans, reach_links labelled⟩

/-- `reach_links` needs no finiteness: on all the numbers in their order, an infinite naturally
labelled order and the limit of the chain, every pair is reached by links. -/
theorem nat_reach_links {i j : Nat} (lt : i < j) : «及» (links (fun a b : Nat => a < b)) i j :=
  @reach_links (fun a b : Nat => a < b) (fun a b => Nat.decLt a b) (fun h => h) i j lt

/-- The path `0 → 1 → 2`, naturally labelled and not transitive. -/
def path (i j : Nat) : Prop := (i = 0 ∧ j = 1) ∨ (i = 1 ∧ j = 2)

instance (i j : Nat) : Decidable (path i j) := instDecidableOr

/-- **Without transitivity only one inclusion holds**: the links of the path reach `(0, 2)`, which
it does not relate. -/
theorem path_not_reach_of_links : «及» (links path) 0 2 ∧ ¬ path 0 2 :=
  ⟨«及».more ⟨.inl ⟨rfl, rfl⟩, fun _ ⟨first, second⟩ => match first, second with
      | .inl ⟨_, one⟩, .inl ⟨zero, _⟩ => absurd (one.symm.trans zero) (by decide)
      | .inl ⟨_, _⟩, .inr ⟨_, two⟩ => absurd two (by decide)
      | .inr ⟨zero, _⟩, _ => absurd zero (by decide)⟩
    («及».one ⟨.inr ⟨rfl, rfl⟩, fun _ ⟨first, second⟩ => match first, second with
      | .inl ⟨one, _⟩, _ => absurd one (by decide)
      | .inr ⟨_, two⟩, .inl ⟨zero, _⟩ => absurd (two.symm.trans zero) (by decide)
      | .inr ⟨_, two⟩, .inr ⟨one, _⟩ => absurd (two.symm.trans one) (by decide)⟩),
   fun pair => match pair with
     | .inl ⟨_, one⟩ => absurd one (by decide)
     | .inr ⟨zero, _⟩ => absurd zero (by decide)⟩

/-- A bounded search with each case decided, in `Prop`. -/
theorem searchBelow_or (p : Nat → Prop) (decided : ∀ z, p z ∨ ¬ p z) :
    ∀ n, (∃ z, z < n ∧ p z) ∨ ¬ ∃ z, z < n ∧ p z
  | 0 => .inr fun ⟨_, below, _⟩ => Nat.not_lt_zero _ below
  | n + 1 => match searchBelow_or p decided n with
    | .inl ⟨z, below, holds⟩ => .inl ⟨z, Nat.lt_succ_of_lt below, holds⟩
    | .inr absent => match decided n with
      | .inl last => .inl ⟨n, Nat.lt_succ_self n, last⟩
      | .inr last => .inr fun ⟨z, below, holds⟩ =>
        match Nat.lt_or_eq_of_le (Nat.le_of_lt_succ below) with
        | .inl lower => absent ⟨z, lower, holds⟩
        | .inr same => last (same ▸ holds)

/-- `reach_links_within` with only what lies between decided. -/
theorem reach_links_within_of_decided {O : «际» Nat}
    (decided : ∀ i z j, (O i z ∧ O z j) ∨ ¬ (O i z ∧ O z j))
    (labelled : ∀ {i j}, O i j → i < j) :
    ∀ n {i j : Nat}, j ≤ i + n → O i j → «及» (links O) i j
  | 0, _, _, gap, pair => absurd (Nat.lt_of_lt_of_le (labelled pair) gap) (Nat.lt_irrefl _)
  | n + 1, i, j, gap, pair =>
    match searchBelow_or (fun z => O i z ∧ O z j) (fun z => decided i z j) j with
    | .inl ⟨z, _, first, second⟩ =>
      «及之传递»
        (reach_links_within_of_decided decided labelled n
          (Nat.le_of_lt_succ (Nat.lt_of_lt_of_le (labelled second) gap)) first)
        (reach_links_within_of_decided decided labelled n
          (Nat.le_trans gap (by
            show Nat.succ (i + n) ≤ z + n
            rw [← Nat.succ_add]
            exact Nat.add_le_add_right (labelled first) n)) second)
    | .inr nothing =>
      .one ⟨pair, fun z ⟨first, second⟩ => nothing ⟨z, labelled second, first, second⟩⟩

/-- **Every pair is reached by links where what lies between is decided**, with no `Decidable`
instance. -/
theorem reach_links_of_decided {O : «际» Nat}
    (decided : ∀ i z j, (O i z ∧ O z j) ∨ ¬ (O i z ∧ O z j))
    (labelled : ∀ {i j}, O i j → i < j) {i j : Nat} (pair : O i j) : «及» (links O) i j :=
  reach_links_within_of_decided decided labelled j (Nat.le_add_left j i) pair

/-! ## `ω + 1`: precedence not the reach of its links -/

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

/-- Every positive number lies between `some 0` and the top, so infinitely many do. -/
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

/-- **On a causal set with decidable precedence, precedence is the reach of its links.** -/
theorem ordered_reach_links_iff (ordered : c.Ordered) [∀ i j, Decidable (c.prec i j)] {i j : Nat} :
    «及» (links c.prec) i j ↔ c.prec i j :=
  reach_links_iff (O := c.prec) ordered.trans ordered.labelled

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

/-- Holding the past: internal temporality, no new element born below an old one, with the parent
kept as it was. The second configuration has the first's elements, with the precedence below each of
them as it was. -/
def HoldsPast (c c' : Causet) : Prop :=
  c.size ≤ c'.size ∧ ∀ i j, j < c.size → (c'.prec i j ↔ c.prec i j)

/-- **Every move of the growth holds the past.** -/
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

/-- **On every course from a causal set, what can be born next keeps widening**: every stem stays
one, and after each birth the stem of all elements is new (UE10's `KeepsWidening`). -/
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

/-- **Every stem a course ever admits is possible from its start** (UE10's
`Run.possible_from_start`): what can be born next keeps widening inside a whole possible that never
grows. -/
theorem stem_possible_from_start (r : Run process) (n : Nat) {D : Nat → Prop}
    (stem : Stem (r.state n) D) : Reaching.Possible process Stem (r.state 0) D :=
  Run.possible_from_start r n ⟨r.state n, Reach.refl _ _, stem⟩

end Growth

/-! ## Deciding what lies between -/

namespace Undecided

/-- Three elements: `0` before `2`, and `0` before `1` before `2` exactly where `P`. -/
def third (P : Prop) : Causet :=
  ⟨3, fun i j => (i = 0 ∧ j = 2) ∨ (i = 0 ∧ j = 1 ∧ P) ∨ (i = 1 ∧ j = 2 ∧ P)⟩

theorem third_ordered (P : Prop) : (third P).Ordered where
  trans := fun first second => match first, second with
    | .inl ⟨_, two⟩, .inl ⟨zero, _⟩ => absurd (two.symm.trans zero) (by decide)
    | .inl ⟨_, two⟩, .inr (.inl ⟨zero, _, _⟩) => absurd (two.symm.trans zero) (by decide)
    | .inl ⟨_, two⟩, .inr (.inr ⟨one, _, _⟩) => absurd (two.symm.trans one) (by decide)
    | .inr (.inl ⟨_, one, _⟩), .inl ⟨zero, _⟩ => absurd (one.symm.trans zero) (by decide)
    | .inr (.inl ⟨_, one, _⟩), .inr (.inl ⟨zero, _, _⟩) => absurd (one.symm.trans zero) (by decide)
    | .inr (.inl ⟨zero, _, _⟩), .inr (.inr ⟨_, two, _⟩) => .inl ⟨zero, two⟩
    | .inr (.inr ⟨_, two, _⟩), .inl ⟨zero, _⟩ => absurd (two.symm.trans zero) (by decide)
    | .inr (.inr ⟨_, two, _⟩), .inr (.inl ⟨zero, _, _⟩) => absurd (two.symm.trans zero) (by decide)
    | .inr (.inr ⟨_, two, _⟩), .inr (.inr ⟨one, _, _⟩) => absurd (two.symm.trans one) (by decide)
  labelled := fun pair => match pair with
    | .inl ⟨zero, two⟩ => by subst zero; subst two; exact (by decide : (0 : Nat) < 2)
    | .inr (.inl ⟨zero, one, _⟩) => by subst zero; subst one; exact (by decide : (0 : Nat) < 1)
    | .inr (.inr ⟨one, two, _⟩) => by subst one; subst two; exact (by decide : (1 : Nat) < 2)
  within := fun pair => match pair with
    | .inl ⟨_, two⟩ => by subst two; exact (by decide : (2 : Nat) < 3)
    | .inr (.inl ⟨_, one, _⟩) => by subst one; exact (by decide : (1 : Nat) < 3)
    | .inr (.inr ⟨_, two, _⟩) => by subst two; exact (by decide : (2 : Nat) < 3)

theorem third_not_from_two {P : Prop} {y : Nat} : ¬ (third P).prec 2 y :=
  fun pair => match pair with
  | .inl ⟨zero, _⟩ => absurd zero (by decide)
  | .inr (.inl ⟨zero, _, _⟩) => absurd zero (by decide)
  | .inr (.inr ⟨one, _, _⟩) => absurd one (by decide)

theorem third_no_reach_from_two {P : Prop} {y : Nat} : ¬ «及» (links (third P).prec) 2 y :=
  fun reach => match reach with
  | .one link => third_not_from_two link.1
  | .more link _ => third_not_from_two link.1

/-- Where `0` reaches `2` by links, `P` is decided. -/
theorem em_of_reach_third {P : Prop} (reach : «及» (links (third P).prec) 0 2) : P ∨ ¬ P :=
  match reach with
  | .one link => .inr fun p => link.2 1 ⟨.inr (.inl ⟨rfl, rfl, p⟩), .inr (.inr ⟨rfl, rfl, p⟩)⟩
  | .more link rest => match link.1 with
    | .inl ⟨_, two⟩ =>
      absurd (Eq.subst (motive := fun x => «及» (links (third P).prec) x 2) two rest)
        third_no_reach_from_two
    | .inr (.inl ⟨_, _, p⟩) => .inl p
    | .inr (.inr ⟨zero, _, _⟩) => absurd zero (by decide)

end Undecided

/-- **That every pair of every causal set is reached by links is excluded middle**: telling a link,
a direct condition, from a longer chain is deciding whether anything lies between. -/
theorem reach_links_all_iff_em :
    (∀ c : Causet, c.Ordered → ∀ i j, c.prec i j → «及» (links c.prec) i j) ↔
      ∀ P : Prop, P ∨ ¬ P :=
  ⟨fun every P => Undecided.em_of_reach_third
     (every (Undecided.third P) (Undecided.third_ordered P) 0 2 (.inl ⟨rfl, rfl⟩)),
   fun em _ ordered _ _ pair => reach_links_of_decided (fun _ _ _ => em _) ordered.labelled pair⟩

/-! ## What can be born next reverses the inclusion of precedence -/

section Reversal

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

/-- **The stems reverse the inclusion of precedence**: of two causal sets of one size, every stem
of the first is a stem of the second exactly where the second's precedence is included in the
first's. -/
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

/-- **Of two courses from the empty set, the strict part of stem inclusion is the strict part of
precedence inclusion, reversed**, at every offset, with no decision. -/
theorem rangeIncludes_strict_iff (start : r.state 0 = empty) (start' : r'.state 0 = empty) :
    (r.RangeIncludes Stem r' ∧ ¬ r'.RangeIncludes Stem r) ↔
      ((∀ t i j, (r.state t).prec i j → (r'.state t).prec i j) ∧
        ¬ ∀ t i j, (r'.state t).prec i j → (r.state t).prec i j) :=
  ⟨fun ⟨inc, notBack⟩ => ⟨(rangeIncludes_iff start start').mp inc,
     fun back => notBack ((rangeIncludes_iff start' start).mpr back)⟩,
   fun ⟨inside, notBack⟩ => ⟨(rangeIncludes_iff start start').mpr inside,
     fun back => notBack ((rangeIncludes_iff start' start).mp back)⟩⟩

/-- Of two courses from the empty set, one exceeds the other's stems where the other has a
precedence pair it lacks. -/
theorem rangeExceeds_of_pair (start : r.state 0 = empty) (start' : r'.state 0 = empty) {t i j : Nat}
    (pair' : (r'.state t).prec i j) (lacks : ¬ (r.state t).prec i j) : r.RangeExceeds Stem r' :=
  ⟨t, principal (r.state t) j,
   stem_principal (ordered_of_empty start t)
     (by rw [size_of_run start t, ← size_of_run start' t]; exact (ordered_of_empty start' t).within pair'),
   fun stem => match stem.closed (.inl rfl) pair' with
     | .inl same => by subst same; exact (ordered_of_empty start' t).irrefl _ pair'
     | .inr p => lacks p⟩

/-- Of two courses from the empty set, one exceeds the other's stems only where, at some offset, the
other's precedence is not included in its own. -/
theorem not_included_of_rangeExceeds (start : r.state 0 = empty) (start' : r'.state 0 = empty)
    (exceeds : r.RangeExceeds Stem r') :
    ∃ t, ¬ ∀ i j, (r'.state t).prec i j → (r.state t).prec i j :=
  match exceeds with
  | ⟨t, _, stem, not⟩ => ⟨t, fun inside =>
      not ((stems_included_iff (ordered_of_empty start t) (ordered_of_empty start' t)
        ((size_of_run start t).trans (size_of_run start' t).symm)).mpr inside _ stem)⟩

/-- **Losing a pair widens what can be born next**: of two courses from the empty set, one widens the
other's stems where its precedence is included in the other's at every offset and the other has a
pair it lacks. -/
theorem rangeWidens_of (start : r.state 0 = empty) (start' : r'.state 0 = empty)
    (inside : ∀ t i j, (r.state t).prec i j → (r'.state t).prec i j) {t i j : Nat}
    (pair' : (r'.state t).prec i j) (lacks : ¬ (r.state t).prec i j) : r.RangeWidens Stem r' :=
  ⟨(rangeIncludes_iff start start').mpr inside, rangeExceeds_of_pair start start' pair' lacks⟩

/-- Of two courses from the empty set, one widening the other's stems has its precedence included in
the other's at every offset, and not conversely. -/
theorem rangeWidens_strict (start : r.state 0 = empty) (start' : r'.state 0 = empty)
    (widens : r.RangeWidens Stem r') :
    (∀ t i j, (r.state t).prec i j → (r'.state t).prec i j) ∧
      ¬ ∀ t i j, (r'.state t).prec i j → (r.state t).prec i j :=
  (rangeIncludes_strict_iff start start').mp ⟨widens.1, widens.2.not_included⟩

/-- With precedence decidable at an offset, a failed inclusion there gives an explicit pair the
first course lacks (a bounded search over pairs). -/
theorem pair_of_not_included (start' : r'.state 0 = empty) {t : Nat}
    [∀ i j, Decidable ((r.state t).prec i j)] [∀ i j, Decidable ((r'.state t).prec i j)]
    (not : ¬ ∀ i j, (r'.state t).prec i j → (r.state t).prec i j) :
    ∃ i j, (r'.state t).prec i j ∧ ¬ (r.state t).prec i j :=
  match @searchBelow (fun j => ∃ i, i < j ∧ ((r'.state t).prec i j ∧ ¬ (r.state t).prec i j))
      (fun j => searchBelow (fun i => (r'.state t).prec i j ∧ ¬ (r.state t).prec i j) j) t with
  | isTrue ⟨j, _, i, _, pair', lacks⟩ => ⟨i, j, pair', lacks⟩
  | isFalse absent => absurd (fun i j pair' =>
      match (inferInstance : Decidable ((r.state t).prec i j)) with
      | isTrue pair => pair
      | isFalse lacks => absurd ⟨j,
          Nat.lt_of_lt_of_le ((ordered_of_empty start' t).within pair')
            (Nat.le_of_eq (size_of_run start' t)),
          i, (ordered_of_empty start' t).labelled pair', pair', lacks⟩ absent) not

/-- **With precedence decidable, of two courses from the empty set one exceeds the other's stems
exactly where the other has a pair it lacks.** -/
theorem rangeExceeds_iff_pair (start : r.state 0 = empty) (start' : r'.state 0 = empty)
    [∀ t i j, Decidable ((r.state t).prec i j)] [∀ t i j, Decidable ((r'.state t).prec i j)] :
    r.RangeExceeds Stem r' ↔ ∃ t i j, (r'.state t).prec i j ∧ ¬ (r.state t).prec i j :=
  ⟨fun exceeds => match not_included_of_rangeExceeds start start' exceeds with
     | ⟨t, not⟩ => match pair_of_not_included start' not with
       | ⟨i, j, pair', lacks⟩ => ⟨t, i, j, pair', lacks⟩,
   fun ⟨_, _, _, pair', lacks⟩ => rangeExceeds_of_pair start start' pair' lacks⟩

/-- **Widening what can be born next never adds continuation** of any class read on precedence, of
two courses from the empty set. -/
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

/-- **Of two courses from the empty set, with precedence decidable, including the other's stems adds
no continuation along links within the one class.** -/
theorem continuation_links_one_of_rangeIncludes (start : r.state 0 = empty)
    (start' : r'.state 0 = empty)
    [∀ t i j, Decidable ((r.state t).prec i j)] [∀ t i j, Decidable ((r'.state t).prec i j)]
    (included : r.RangeIncludes Stem r') (t : Nat) :
    «则» («相续» (links (r.state t).prec) «一») («相续» (links (r'.state t).prec) «一») :=
  fun _ _ line => (continuation_links_one_iff (ordered_of_empty start' t)).mpr
    ((rangeIncludes_iff start start').mp included t _ _
      ((continuation_links_one_iff (ordered_of_empty start t)).mp line))

/-- **Compared by both, two courses from the empty set have the same precedence**: where one
includes the other's stems and continues at least as much within the one class, at every offset, the
two have the same precedence at every offset. -/
theorem prec_iff_of_both (start : r.state 0 = empty) (start' : r'.state 0 = empty)
    (included : r.RangeIncludes Stem r')
    (continues : ∀ t, «则» («相续» (r'.state t).prec «一») («相续» (r.state t).prec «一»)) :
    ∀ t i j, (r.state t).prec i j ↔ (r'.state t).prec i j :=
  fun t i j =>
    ⟨(rangeIncludes_iff start start').mp included t i j, fun pair' =>
      (continuation_one_iff (ordered_of_empty start t)).mp
        (continues t i j ((continuation_one_iff (ordered_of_empty start' t)).mpr pair'))⟩

/-- **Of two courses from the empty set, neither widens the other's stems while continuing at least
as much** within the one class. -/
theorem not_widens_and_continues (start : r.state 0 = empty) (start' : r'.state 0 = empty)
    (widens : r.RangeWidens Stem r') :
    ¬ ∀ t, «则» («相续» (r'.state t).prec «一») («相续» (r.state t).prec «一») :=
  fun continues => match not_included_of_rangeExceeds start start' widens.2 with
  | ⟨t, not⟩ => not fun i j => (prec_iff_of_both start start' widens.1 continues t i j).mpr

end Reversal

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

/-- **The course of births with empty pasts includes the stems of every course from the empty
set.** -/
theorem antichain_rangeIncludes (start : r.state 0 = empty) : antichain.RangeIncludes Stem r :=
  (rangeIncludes_iff rfl start).mpr fun t i j pair => absurd pair (antichain_prec t i j)

/-- **It widens the stems of every course from the empty set with a precedence pair.** -/
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

/-- **Every course from the empty set includes the stems of the course of births above every
element.** -/
theorem rangeIncludes_chain (start : r.state 0 = empty) : r.RangeIncludes Stem chain :=
  (rangeIncludes_iff start rfl).mpr fun t _ _ pair =>
    (chain_prec_iff t).mpr
      ⟨Nat.lt_of_lt_of_le ((ordered_of_empty start t).within pair) (Nat.le_of_eq (size_of_run start t)),
       (ordered_of_empty start t).labelled pair⟩

/-- **Every course from the empty set lacking a pair of the chain widens the chain's stems.** -/
theorem rangeWidens_chain (start : r.state 0 = empty) {t i j : Nat} (later : j < t) (earlier : i < j)
    (lacks : ¬ (r.state t).prec i j) : r.RangeWidens Stem chain :=
  ⟨rangeIncludes_chain start, rangeExceeds_of_pair start rfl ((chain_prec_iff t).mpr ⟨later, earlier⟩) lacks⟩

/-- **The chain has the most continuation** of every class read on precedence, among the courses
from the empty set. -/
theorem continuation_le_chain (start : r.state 0 = empty) (E : «际» Nat) (t : Nat) :
    «则» («相续» (r.state t).prec E) («相续» (chain.state t).prec E) :=
  continuation_of_rangeIncludes start rfl (rangeIncludes_chain start) E t

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

/-- **At every offset with an element, the chain's last element ends** in the one class, on
precedence and on links. -/
theorem chain_last_ends (t : Nat) :
    «亡» (chain.state (t + 1)).prec «一» t ∧ «亡» (links (chain.state (t + 1)).prec) «一» t :=
  ⟨fun ⟨_, step, _⟩ => match (chain_prec_iff (t + 1)).mp step with
     | ⟨later, earlier⟩ => Nat.lt_irrefl _ (Nat.lt_of_lt_of_le earlier (Nat.le_of_lt_succ later)),
   fun ⟨_, link, _⟩ => match (chain_prec_iff (t + 1)).mp link.1 with
     | ⟨later, earlier⟩ => Nat.lt_irrefl _ (Nat.lt_of_lt_of_le earlier (Nat.le_of_lt_succ later))⟩

/-- Pasts chosen only at offset `2`, below `2`, are stems when chosen. -/
theorem stems_of_two {past : Nat → Nat → Prop} (two : ∀ {t i}, past t i → t = 2 ∧ i < 2)
    (t : Nat) : Stem (grown past t) (past t) :=
  ⟨fun d => by
     have h := two d
     rw [grown_size, h.1]
     exact h.2,
   fun d pair => by
     have later := ((grown_prec_iff past t).mp pair).1
     have born := two ((grown_prec_iff past t).mp pair).2
     have at2 := (two d).1
     rw [born.1, at2] at later
     exact absurd later (Nat.lt_irrefl 2)⟩

end Courses

/-! ## On the courses, reaching by links and finding the pair a widening loses need deciding -/

namespace Undecided

/-- The births growing `third P`: `1` above `0` where `P`; `2` above `0`, and above `1` where `P`. -/
def thirdPast (P : Prop) (t i : Nat) : Prop := (t = 1 ∧ i = 0 ∧ P) ∨ (t = 2 ∧ (i = 0 ∨ (i = 1 ∧ P)))

theorem thirdPast_stems (P : Prop) (t : Nat) : Stem (grown (thirdPast P) t) (thirdPast P t) :=
  ⟨fun d => match d with
     | .inl ⟨at1, zero, _⟩ => by rw [grown_size, at1, zero]; decide
     | .inr ⟨at2, .inl zero⟩ => by rw [grown_size, at2, zero]; decide
     | .inr ⟨at2, .inr ⟨isOne, _⟩⟩ => by rw [grown_size, at2, isOne]; decide,
   fun d pair => match d, (grown_prec_iff (thirdPast P) t).mp pair with
     | .inl ⟨_, zero, _⟩, ⟨_, .inl ⟨isOne, _, _⟩⟩ => absurd (zero.symm.trans isOne) (by decide)
     | .inl ⟨_, zero, _⟩, ⟨_, .inr ⟨two, _⟩⟩ => absurd (zero.symm.trans two) (by decide)
     | .inr ⟨at2, _⟩, ⟨_, .inl ⟨_, zero, _⟩⟩ => .inr ⟨at2, .inl zero⟩
     | .inr ⟨at2, _⟩, ⟨later, .inr ⟨two, _⟩⟩ =>
       absurd (Eq.subst (motive := fun x => x < 2) two (Nat.lt_of_lt_of_le later (Nat.le_of_eq at2)))
         (Nat.lt_irrefl 2)⟩

/-- The course growing `third P`. -/
def thirdCourse (P : Prop) : Run process := course (thirdPast P) (thirdPast_stems P)

/-- At offset `3` the course has grown `third P`. -/
theorem thirdCourse_prec_iff (P : Prop) {i j : Nat} :
    ((thirdCourse P).state 3).prec i j ↔ (third P).prec i j :=
  (grown_prec_iff (thirdPast P) 3).trans
    ⟨fun ⟨_, d⟩ => match d with
       | .inl ⟨at1, zero, p⟩ => .inr (.inl ⟨zero, at1, p⟩)
       | .inr ⟨at2, .inl zero⟩ => .inl ⟨zero, at2⟩
       | .inr ⟨at2, .inr ⟨isOne, p⟩⟩ => .inr (.inr ⟨isOne, at2, p⟩),
     fun pair => match pair with
       | .inl ⟨zero, at2⟩ => ⟨by rw [at2]; decide, .inr ⟨at2, .inl zero⟩⟩
       | .inr (.inl ⟨zero, at1, p⟩) => ⟨by rw [at1]; decide, .inl ⟨at1, zero, p⟩⟩
       | .inr (.inr ⟨isOne, at2, p⟩) => ⟨by rw [at2]; decide, .inr ⟨at2, .inr ⟨isOne, p⟩⟩⟩⟩

/-- `2` born above `0` exactly where `P`, every other birth with the empty past. -/
def onlyIfPast (P : Prop) (t i : Nat) : Prop := t = 2 ∧ i = 0 ∧ P

theorem onlyIf_two {P : Prop} {t i : Nat} (d : onlyIfPast P t i) : t = 2 ∧ i < 2 :=
  ⟨d.1, by rw [d.2.1]; decide⟩

/-- The course bearing `2` above `0` exactly where `P`. -/
def onlyIf (P : Prop) : Run process := course (onlyIfPast P) (stems_of_two onlyIf_two)

/-- A pair of `onlyIf P` gives `P`. -/
theorem onlyIf_prec {P : Prop} {t i j : Nat} (pair : ((onlyIf P).state t).prec i j) : P :=
  ((grown_prec_iff (onlyIfPast P) t).mp pair).2.2.2

/-- Where `P` is not refuted, the antichain exceeds the stems of `onlyIf P`: at offset `3`, `{2}` is
a stem of the antichain's configuration, and a stem of that of `onlyIf P` only where `P` fails. -/
theorem antichain_exceeds_onlyIf {P : Prop} (notNot : ¬¬P) :
    antichain.RangeExceeds Stem (onlyIf P) :=
  ⟨3, (· = 2),
   ⟨fun d => by subst d; decide, fun _ pair => absurd pair (antichain_prec 3 _ _)⟩,
   fun stem => notNot fun p =>
     absurd (stem.closed (rfl : (2 : Nat) = 2)
       ((grown_prec_iff (onlyIfPast P) 3).mpr ⟨by decide, rfl, rfl, p⟩) : (0 : Nat) = 2) (by decide)⟩

/-- Excluded middle is never refuted. -/
theorem notNot_em (P : Prop) : ¬¬(P ∨ ¬ P) := fun no => no (.inr fun p => no (.inl p))

end Undecided

/-- **That every pair on every configuration of every course from the empty set is reached by links
is excluded middle**: the growth reaches `Undecided.third P` at offset `3`. -/
theorem reach_links_courses_iff_em :
    (∀ r : Run process, r.state 0 = empty → ∀ t i j, (r.state t).prec i j →
      «及» (links (r.state t).prec) i j) ↔ ∀ P : Prop, P ∨ ¬ P :=
  ⟨fun every P => Undecided.em_of_reach_third
     («及之单调» (fun _ _ link => links_of_iff (fun _ _ => Undecided.thirdCourse_prec_iff P) link)
       0 2 (every (Undecided.thirdCourse P) rfl 3 0 2
         ((Undecided.thirdCourse_prec_iff P).mpr (.inl ⟨rfl, rfl⟩)))),
   fun em _ start t _ _ pair =>
     reach_links_of_decided (fun _ _ _ => em _) (ordered_of_empty start t).labelled pair⟩

/-- Finding the pair from exceeding, for every pair of courses from the empty set, gives excluded
middle: the antichain exceeds the stems of `onlyIf (P ∨ ¬ P)`, and the pair found decides `P`. -/
theorem em_of_pair_converse
    (converse : ∀ r r' : Run process, r.state 0 = empty → r'.state 0 = empty →
      r.RangeExceeds Stem r' → ∃ t i j, (r'.state t).prec i j ∧ ¬ (r.state t).prec i j)
    (P : Prop) : P ∨ ¬ P :=
  match converse antichain (Undecided.onlyIf (P ∨ ¬ P)) rfl rfl
      (Undecided.antichain_exceeds_onlyIf (Undecided.notNot_em P)) with
  | ⟨_, _, _, pair', _⟩ => Undecided.onlyIf_prec pair'

/-- The same from finding the pair a widening loses. -/
theorem em_of_widening_pair_converse
    (converse : ∀ r r' : Run process, r.state 0 = empty → r'.state 0 = empty →
      r.RangeWidens Stem r' → ∃ t i j, (r'.state t).prec i j ∧ ¬ (r.state t).prec i j)
    (P : Prop) : P ∨ ¬ P :=
  match converse antichain (Undecided.onlyIf (P ∨ ¬ P)) rfl rfl
      ⟨antichain_rangeIncludes rfl, Undecided.antichain_exceeds_onlyIf (Undecided.notNot_em P)⟩ with
  | ⟨_, _, _, pair', _⟩ => Undecided.onlyIf_prec pair'

/-- Excluded middle gives the pair from exceeding back, with no `Decidable` instance. -/
theorem pair_converse_of_em (em : ∀ P : Prop, P ∨ ¬ P) :
    ∀ r r' : Run process, r.state 0 = empty → r'.state 0 = empty →
      r.RangeExceeds Stem r' → ∃ t i j, (r'.state t).prec i j ∧ ¬ (r.state t).prec i j :=
  fun r r' start start' exceeds =>
    match em (∃ t i j, (r'.state t).prec i j ∧ ¬ (r.state t).prec i j) with
    | .inl found => found
    | .inr absent =>
      match not_included_of_rangeExceeds start start' exceeds with
      | ⟨t, not⟩ => absurd (fun i j pair' => match em ((r.state t).prec i j) with
          | .inl pair => pair
          | .inr lacks => absurd ⟨t, i, j, pair', lacks⟩ absent) not

/-- **Finding the pair from exceeding, for every pair of courses from the empty set, is excluded
middle**: a course can hold a pair exactly where a proposition holds, and exceeding knows that pair
only doubly negated, so which pair a widening loses is found by deciding. -/
theorem pair_converse_iff_em :
    (∀ r r' : Run process, r.state 0 = empty → r'.state 0 = empty →
      r.RangeExceeds Stem r' → ∃ t i j, (r'.state t).prec i j ∧ ¬ (r.state t).prec i j) ↔
      ∀ P : Prop, P ∨ ¬ P :=
  ⟨em_of_pair_converse, pair_converse_of_em⟩

/-! ## Two readings of widening, reversed -/

section TwoReadings

variable {r r' : Run process}

/-- What continues within the one class, read as what a configuration admits. -/
def continuing (c : Causet) (p : Nat × Nat) : Prop := «相续» c.prec «一» p.1 p.2

/-- **Of two courses from the empty set, including what continues is being included in what can be
born next.** -/
theorem rangeIncludes_continuing_iff (start : r.state 0 = empty) (start' : r'.state 0 = empty) :
    r.RangeIncludes continuing r' ↔ r'.RangeIncludes Stem r :=
  ⟨fun inc => (rangeIncludes_iff start' start).mpr fun t i j pair =>
      (continuation_one_iff (ordered_of_empty start t)).mp
        (inc t (i, j) ((continuation_one_iff (ordered_of_empty start' t)).mpr pair)),
   fun inc t p line => (continuation_one_iff (ordered_of_empty start t)).mpr
      ((rangeIncludes_iff start' start).mp inc t p.1 p.2
        ((continuation_one_iff (ordered_of_empty start' t)).mp line))⟩

/-- **Of two courses from the empty set, widening what continues is exactly inclusion of precedence
with a pair the other lacks**, with no decision. -/
theorem rangeWidens_continuing_iff (start : r.state 0 = empty) (start' : r'.state 0 = empty) :
    r.RangeWidens continuing r' ↔
      (∀ t i j, (r'.state t).prec i j → (r.state t).prec i j) ∧
        ∃ t i j, (r.state t).prec i j ∧ ¬ (r'.state t).prec i j :=
  ⟨fun ⟨inc, t, p, line, notLine⟩ =>
     ⟨(rangeIncludes_iff start' start).mp ((rangeIncludes_continuing_iff start start').mp inc),
      t, p.1, p.2, (continuation_one_iff (ordered_of_empty start t)).mp line,
      fun pair' => notLine ((continuation_one_iff (ordered_of_empty start' t)).mpr pair')⟩,
   fun ⟨inside, t, i, j, pair, lacks⟩ =>
     ⟨(rangeIncludes_continuing_iff start start').mpr ((rangeIncludes_iff start' start).mpr inside),
      t, (i, j), (continuation_one_iff (ordered_of_empty start t)).mpr pair,
      fun line => lacks ((continuation_one_iff (ordered_of_empty start' t)).mp line)⟩⟩

/-- **Of two courses from the empty set, widening what continues narrows what can be born next.** -/
theorem rangeWidens_stems_of_continuing (start : r.state 0 = empty) (start' : r'.state 0 = empty)
    (widens : r.RangeWidens continuing r') : r'.RangeWidens Stem r :=
  match (rangeWidens_continuing_iff start start').mp widens with
  | ⟨inside, _, _, _, pair, lacks⟩ => rangeWidens_of start' start inside pair lacks

/-- **Read on what continues, the chain widens every course from the empty set lacking one of its
pairs.** -/
theorem chain_rangeWidens_continuing (start : r.state 0 = empty) {t i j : Nat}
    (later : j < t) (earlier : i < j) (lacks : ¬ (r.state t).prec i j) :
    chain.RangeWidens continuing r :=
  (rangeWidens_continuing_iff (r := chain) (r' := r) rfl start).mpr
    ⟨(rangeIncludes_iff start rfl).mp (rangeIncludes_chain start),
     t, i, j, (chain_prec_iff t).mpr ⟨later, earlier⟩, lacks⟩

/-- That narrowing what can be born next always widens what continues, for the courses from the
empty set, gives excluded middle. -/
theorem em_of_stems_converse
    (converse : ∀ r r' : Run process, r.state 0 = empty → r'.state 0 = empty →
      r.RangeWidens Stem r' → r'.RangeWidens continuing r)
    (P : Prop) : P ∨ ¬ P :=
  match (rangeWidens_continuing_iff (r := Undecided.onlyIf (P ∨ ¬ P)) (r' := antichain) rfl rfl).mp
      (converse antichain (Undecided.onlyIf (P ∨ ¬ P)) rfl rfl
        ⟨antichain_rangeIncludes rfl,
         Undecided.antichain_exceeds_onlyIf (Undecided.notNot_em P)⟩) with
  | ⟨_, _, _, _, pair, _⟩ => Undecided.onlyIf_prec pair

/-- Excluded middle gives it back. -/
theorem stems_converse_of_em (em : ∀ P : Prop, P ∨ ¬ P) :
    ∀ r r' : Run process, r.state 0 = empty → r'.state 0 = empty →
      r.RangeWidens Stem r' → r'.RangeWidens continuing r :=
  fun r r' start start' widens =>
    (rangeWidens_continuing_iff start' start).mpr
      ⟨(rangeIncludes_iff start start').mp widens.1,
       pair_converse_of_em em r r' start start' widens.2⟩

/-- **That narrowing what can be born next always widens what continues, for the courses from the
empty set, is excluded middle.** -/
theorem stems_converse_iff_em :
    (∀ r r' : Run process, r.state 0 = empty → r'.state 0 = empty →
      r.RangeWidens Stem r' → r'.RangeWidens continuing r) ↔ ∀ P : Prop, P ∨ ¬ P :=
  ⟨em_of_stems_converse, stems_converse_of_em⟩

/-- **No strict order contains both widenings**: widening what can be born next ranks the antichain
above the chain, widening what continues the chain above the antichain. -/
theorem no_order_contains_both :
    ¬ ∃ above : Run process → Run process → Prop,
      (∀ r, ¬ above r r) ∧ (∀ {r r' r''}, above r r' → above r' r'' → above r r'') ∧
      (∀ r r', r.RangeWidens Stem r' → above r r') ∧
      (∀ r r', r.RangeWidens continuing r' → above r r') :=
  fun ⟨above, irrefl, trans, stems, lines⟩ =>
    irrefl antichain (trans
      (stems antichain chain
        (antichain_rangeWidens (r := chain) rfl
          ((chain_prec_iff 2 (i := 0) (j := 1)).mpr ⟨by decide, by decide⟩)))
      (lines chain antichain ((rangeWidens_continuing_iff (r := chain) (r' := antichain) rfl rfl).mpr
        ⟨fun t i j pair => absurd pair (antichain_prec t i j),
         2, 0, 1, (chain_prec_iff 2 (i := 0) (j := 1)).mpr ⟨by decide, by decide⟩,
         antichain_prec 2 0 1⟩)))

/-- **An order never reversing widening what can be born next ranks nothing above the antichain**
among the courses from the empty set with a precedence pair: 07's requirement, read on stems. -/
theorem not_above_antichain (above : Run process → Run process → Prop)
    (never : ∀ r r', r.RangeWidens Stem r' → ¬ above r' r)
    (start : r.state 0 = empty) {t i j : Nat} (pair : (r.state t).prec i j) : ¬ above r antichain :=
  never antichain r (antichain_rangeWidens start pair)

/-- **Such an order ranks the chain above no course from the empty set lacking one of its pairs**:
each such course widens the chain's stems. -/
theorem chain_not_above (above : Run process → Run process → Prop)
    (never : ∀ r r', r.RangeWidens Stem r' → ¬ above r' r)
    (start : r.state 0 = empty) {t i j : Nat} (later : j < t) (earlier : i < j)
    (lacks : ¬ (r.state t).prec i j) : ¬ above chain r :=
  never r chain (rangeWidens_chain start later earlier lacks)

/-- What can be born next and what continues within the one class, read together. -/
def formsOrContinues (c : Causet) : (Nat → Prop) ⊕ (Nat × Nat) → Prop
  | .inl D => Stem c D
  | .inr p => continuing c p

/-- **Read on what can be born next and what continues together, of two courses from the empty set
neither widens the other**: the two inclusions together force the same precedence at every offset. -/
theorem not_rangeWidens_formsOrContinues (start : r.state 0 = empty)
    (start' : r'.state 0 = empty) : ¬ r.RangeWidens formsOrContinues r' :=
  fun ⟨inc, t, x, yes, no⟩ =>
    have stems : r.RangeIncludes Stem r' := fun t D stem => inc t (.inl D) stem
    have lines : r.RangeIncludes continuing r' := fun t p line => inc t (.inr p) line
    have back : r'.RangeIncludes Stem r := (rangeIncludes_continuing_iff start start').mp lines
    have backLines : r'.RangeIncludes continuing r :=
      (rangeIncludes_continuing_iff start' start).mpr stems
    match x, yes, no with
    | .inl D, yes, no => no (back t D yes)
    | .inr p, yes, no => no (backLines t p yes)

/-- **Of two courses from the empty set, given a pair one has and the other lacks, the two are
mixed** on the joint reading: the one lacking it exceeds in what can be born next, the other in what
continues. -/
theorem mixed_of_pair (start : r.state 0 = empty) (start' : r'.state 0 = empty) {t i j : Nat}
    (pair' : (r'.state t).prec i j) (lacks : ¬ (r.state t).prec i j) :
    r.RangeExceeds formsOrContinues r' ∧ r'.RangeExceeds formsOrContinues r :=
  ⟨match rangeExceeds_of_pair start start' pair' lacks with
   | ⟨t, D, yes, no⟩ => ⟨t, .inl D, yes, no⟩,
   ⟨t, .inr (i, j), «及».one ⟨pair', trivial⟩,
    fun line => lacks ((continuation_one_iff (ordered_of_empty start t)).mp line)⟩⟩

end TwoReadings

/-! ## The courses' start

The comparisons of two courses above take both from the empty set. Most fail without it: from one
element with every past empty a course widens the antichain's stems with the same, empty,
precedence, and courses from other configurations refute the others. -/

namespace Starts

/-- One element, related to nothing. -/
def one : Causet := ⟨1, fun _ _ => False⟩

/-- Two elements, `0` before `1`. -/
def twoChain : Causet := ⟨2, fun i j => i = 0 ∧ j = 1⟩

/-- From a configuration, the births with given pasts. -/
def grownFrom (c : Causet) (past : Nat → Nat → Prop) : Nat → Causet
  | 0 => c
  | t + 1 => birth (grownFrom c past t) (past t)

theorem grownFrom_size (c : Causet) (past : Nat → Nat → Prop) :
    ∀ t, (grownFrom c past t).size = c.size + t
  | 0 => rfl
  | t + 1 => congrArg Nat.succ (grownFrom_size c past t)

/-- The precedence after births from `c`: `c`'s, and `c.size + k` above its past `k`. -/
theorem grownFrom_prec_iff (c : Causet) (past : Nat → Nat → Prop) :
    ∀ t {i j : Nat}, (grownFrom c past t).prec i j ↔
      c.prec i j ∨ ∃ k, k < t ∧ j = c.size + k ∧ past k i
  | 0, _, _ => ⟨.inl, fun h => match h with
      | .inl p => p
      | .inr ⟨k, below, _⟩ => absurd below (Nat.not_lt_zero k)⟩
  | t + 1, i, j =>
    ⟨fun pair => match pair with
       | .inl p => match (grownFrom_prec_iff c past t).mp p with
         | .inl q => .inl q
         | .inr ⟨k, below, at_k, d⟩ => .inr ⟨k, Nat.lt_succ_of_lt below, at_k, d⟩
       | .inr ⟨top, d⟩ => .inr ⟨t, Nat.lt_succ_self t, top.trans (grownFrom_size c past t), d⟩,
     fun h => match h with
       | .inl q => .inl ((grownFrom_prec_iff c past t).mpr (.inl q))
       | .inr ⟨k, below, at_k, d⟩ =>
         match Nat.lt_or_eq_of_le (Nat.le_of_lt_succ below) with
         | .inl lower => .inl ((grownFrom_prec_iff c past t).mpr (.inr ⟨k, lower, at_k, d⟩))
         | .inr same => .inr ⟨at_k.trans (by rw [same]; exact (grownFrom_size c past t).symm),
             by subst same; exact d⟩⟩

/-- With every past empty, the precedence stays the start's. -/
theorem grownFrom_empty_prec (c : Causet) :
    ∀ t {i j : Nat}, (grownFrom c (fun _ _ => False) t).prec i j ↔ c.prec i j
  | 0, _, _ => Iff.rfl
  | t + 1, _, _ => ⟨fun pair => match pair with
      | .inl p => (grownFrom_empty_prec c t).mp p
      | .inr ⟨_, d⟩ => (d : False).elim,
    fun p => .inl ((grownFrom_empty_prec c t).mpr p)⟩

/-- A course from `c`, every birth with the empty past. -/
def fromEmptyPasts (c : Causet) : Run process :=
  ⟨grownFrom c (fun _ _ => False), fun _ _ => False, fun _ => ⟨⟨False.elim, fun d _ => d⟩, rfl⟩⟩

/-- From one element, every birth with the empty past. -/
def fromOne : Run process := fromEmptyPasts one

theorem fromOne_prec (t : Nat) {i j : Nat} : ¬ (fromOne.state t).prec i j :=
  fun pair => (grownFrom_empty_prec one t).mp pair

theorem fromOne_size (t : Nat) : (fromOne.state t).size = 1 + t := grownFrom_size one _ t

theorem fromOne_stem_of_antichain {t : Nat} {D : Nat → Prop} (stem : Stem (antichain.state t) D) :
    Stem (fromOne.state t) D :=
  ⟨fun d => Nat.lt_of_lt_of_le
     (Nat.lt_of_lt_of_le (stem.within d) (Nat.le_of_eq (size_of_run (r := antichain) rfl t)))
     (Nat.le_trans (Nat.le_add_left t 1) (Nat.le_of_eq (fromOne_size t).symm)),
   fun _ pair => absurd pair (fromOne_prec t)⟩

theorem fromOne_stem_zero : Stem (fromOne.state 0) (· = 0) :=
  ⟨fun d => by subst d; decide, fun _ pair => absurd pair (fromOne_prec 0)⟩

theorem not_stem_antichain_zero : ¬ Stem (antichain.state 0) (· = 0) :=
  fun stem => Nat.not_lt_zero 0 (stem.within rfl)

/-- **From one element, a course widens the antichain's stems.** -/
theorem fromOne_widens : fromOne.RangeWidens Stem antichain :=
  ⟨fun _ _ stem => fromOne_stem_of_antichain stem,
   ⟨0, (· = 0), fromOne_stem_zero, not_stem_antichain_zero⟩⟩

/-- Nothing continues in the antichain. -/
theorem antichain_not_continuing (t : Nat) (p : Nat × Nat) : ¬ continuing (antichain.state t) p :=
  fun line => match (line : «及» («续» (antichain.state t).prec «一») p.1 p.2) with
  | .one step => antichain_prec t _ _ step.1
  | .more step _ => antichain_prec t _ _ step.1

/-- `fromOne` widens the antichain read on what can be born next and what continues together. -/
theorem fromOne_widens_formsOrContinues : fromOne.RangeWidens formsOrContinues antichain :=
  ⟨fun t x admitted => match x, admitted with
     | .inl _, stem => fromOne_stem_of_antichain stem
     | .inr p, line => absurd line (antichain_not_continuing t p),
   ⟨0, .inl (· = 0), fromOne_stem_zero, not_stem_antichain_zero⟩⟩

/-- **`not_rangeWidens_formsOrContinues` needs its starts.** -/
theorem not_rangeWidens_formsOrContinues_needs_starts :
    ¬ ∀ r r' : Run process, ¬ r.RangeWidens formsOrContinues r' :=
  fun noWidening => noWidening fromOne antichain fromOne_widens_formsOrContinues

/-- **`rangeIncludes_continuing_iff` needs its starts**: `fromOne` includes what continues in the
antichain, and the antichain does not include `fromOne`'s stems. -/
theorem rangeIncludes_continuing_iff_needs_starts :
    fromOne.RangeIncludes continuing antichain ∧ ¬ antichain.RangeIncludes Stem fromOne :=
  ⟨fun t p line => absurd line (antichain_not_continuing t p),
   fun included => not_stem_antichain_zero (included 0 (· = 0) fromOne_stem_zero)⟩

/-- **`not_widens_and_continues` needs its starts**: `fromOne` widens the antichain's stems and
continues at least as much within the one class. -/
theorem not_widens_and_continues_needs_starts :
    fromOne.RangeWidens Stem antichain ∧
      ∀ t, «则» («相续» (antichain.state t).prec «一») («相续» (fromOne.state t).prec «一») :=
  ⟨fromOne_widens, fun t x y line => absurd line (antichain_not_continuing t (x, y))⟩

/-- From the two-chain, every birth with the empty past. -/
def fromTwo : Run process := fromEmptyPasts twoChain

theorem fromTwo_prec_iff (t : Nat) {i j : Nat} : (fromTwo.state t).prec i j ↔ i = 0 ∧ j = 1 :=
  grownFrom_empty_prec twoChain t

/-- `1` born above `0`, every other birth with the empty past. -/
def onePast (t i : Nat) : Prop := t = 1 ∧ i = 0

theorem onePast_stems (t : Nat) : Stem (grown onePast t) (onePast t) :=
  ⟨fun ⟨at1, zero⟩ => by rw [grown_size, at1, zero]; decide,
   fun ⟨_, zero⟩ pair => absurd (zero.symm.trans ((grown_prec_iff onePast t).mp pair).2.1) (by decide)⟩

def oneAbove : Run process := course onePast onePast_stems

theorem oneAbove_prec {t i j : Nat} (pair : (oneAbove.state t).prec i j) : i = 0 ∧ j = 1 :=
  match (grown_prec_iff onePast t).mp pair with
  | ⟨_, at1, zero⟩ => ⟨zero, at1⟩

/-- **`mixed_of_pair` needs its starts**: `fromTwo` has the pair `(0, 1)` at offset `0`, which
`oneAbove` lacks there, and `oneAbove` exceeds `fromTwo` neither in what can be born next nor in what
continues. -/
theorem mixed_of_pair_needs_starts :
    (fromTwo.state 0).prec 0 1 ∧ ¬ (oneAbove.state 0).prec 0 1 ∧
      ¬ oneAbove.RangeExceeds formsOrContinues fromTwo :=
  ⟨⟨rfl, rfl⟩, fun pair => pair, fun ⟨t, x, yes, no⟩ => match x, yes, no with
    | .inl D, yes, no => no (show Stem (fromTwo.state t) D from
        ⟨fun d => Nat.lt_of_lt_of_le
           (Nat.lt_of_lt_of_le ((yes : Stem (oneAbove.state t) D).within d)
             (Nat.le_of_eq (size_of_run (r := oneAbove) rfl t)))
           (Nat.le_trans (Nat.le_add_left t 2) (Nat.le_of_eq (grownFrom_size twoChain _ t).symm)),
         fun d pair => match (fromTwo_prec_iff t).mp pair with
           | ⟨zero, at1⟩ => by
             subst zero; subst at1
             exact (yes : Stem (oneAbove.state t) D).closed d ((grown_prec_iff onePast t).mpr
               ⟨Nat.lt_of_lt_of_le ((yes : Stem (oneAbove.state t) D).within d)
                 (Nat.le_of_eq (size_of_run (r := oneAbove) rfl t)), rfl, rfl⟩)⟩)
    | .inr p, yes, no => no («及之单调» (R := «续» (oneAbove.state t).prec «一»)
        (S := «续» (fromTwo.state t).prec «一»)
        (fun _ _ step => ⟨(fromTwo_prec_iff t).mpr (oneAbove_prec step.1), step.2⟩) p.1 p.2 yes)⟩

theorem fromTwo_stem_all : Stem (fromTwo.state 0) (· < 2) :=
  ⟨fun d => d, fun _ pair => match (fromTwo_prec_iff 0).mp pair with
    | ⟨zero, _⟩ => Nat.lt_of_le_of_lt (Nat.le_of_eq zero) (by decide)⟩

theorem not_stem_antichain_all : ¬ Stem (antichain.state 0) (· < 2) :=
  fun stem => Nat.not_lt_zero 0 (stem.within (by decide : (0 : Nat) < 2))

/-- **`not_above_antichain` needs its start**: an order never reversing widening what can be born
next ranks `fromTwo`, which has a precedence pair, above the antichain. -/
theorem not_above_antichain_needs_start :
    ∃ above : Run process → Run process → Prop,
      (∀ r r', r.RangeWidens Stem r' → ¬ above r' r) ∧ (fromTwo.state 0).prec 0 1 ∧
        above fromTwo antichain :=
  ⟨fun r r' => r = fromTwo ∧ r' = antichain,
   fun r r' widens ⟨same', same⟩ => by
     subst same'; subst same
     exact not_stem_antichain_all (widens.1 0 _ fromTwo_stem_all),
   ⟨rfl, rfl⟩, ⟨rfl, rfl⟩⟩

/-- From one element, every birth above every element. -/
def chainFromOnePast (t i : Nat) : Prop := i < 1 + t

theorem chainFromOne_prec_iff (t : Nat) {i j : Nat} :
    (grownFrom one chainFromOnePast t).prec i j ↔ ∃ k, k < t ∧ j = 1 + k ∧ i < 1 + k :=
  (grownFrom_prec_iff one chainFromOnePast t).trans
    ⟨fun h => match h with
       | .inl f => f.elim
       | .inr found => found,
     .inr⟩

theorem chainFromOne_labelled {t i j : Nat} (pair : (grownFrom one chainFromOnePast t).prec i j) :
    i < j :=
  match (chainFromOne_prec_iff t).mp pair with
  | ⟨_, _, at_k, below⟩ => Eq.subst (motive := fun x => i < x) at_k.symm below

def chainFromOne : Run process :=
  ⟨grownFrom one chainFromOnePast, chainFromOnePast, fun t =>
    ⟨⟨fun d => Nat.lt_of_lt_of_le d (Nat.le_of_eq (grownFrom_size one _ t).symm),
      fun d pair => Nat.lt_trans (chainFromOne_labelled pair) d⟩, rfl⟩⟩

theorem not_continuing_chain_one : ¬ continuing (chain.state 1) (0, 1) :=
  fun line => match (line : «及» («续» (chain.state 1).prec «一») 0 1) with
  | .one step => absurd ((chain_prec_iff 1).mp step.1).1 (by decide)
  | .more step _ => match (chain_prec_iff 1).mp step.1 with
    | ⟨later, earlier⟩ => absurd (Nat.lt_of_lt_of_le earlier (Nat.le_of_lt_succ later)) (by decide)

/-- **`rangeWidens_stems_of_continuing` needs its starts**: the chain from one element widens what
continues in the chain from the empty set, and the chain does not include its stems. -/
theorem rangeWidens_stems_of_continuing_needs_starts :
    chainFromOne.RangeWidens continuing chain ∧ ¬ chain.RangeIncludes Stem chainFromOne :=
  ⟨⟨fun t _ line => «及之单调» (R := «续» (chain.state t).prec «一»)
       (S := «续» (chainFromOne.state t).prec «一») (fun x y step => ⟨(chainFromOne_prec_iff t).mpr
       (match y, (chain_prec_iff t).mp step.1 with
        | 0, ⟨_, earlier⟩ => absurd earlier (Nat.not_lt_zero x)
        | k + 1, ⟨later, earlier⟩ =>
          ⟨k, Nat.lt_of_succ_lt later, Nat.add_comm k 1, Nat.lt_of_lt_of_le earlier
            (Nat.le_of_eq (Nat.add_comm k 1))⟩), trivial⟩) _ _ line,
    ⟨1, (0, 1), «及».one ⟨(chainFromOne_prec_iff 1).mpr ⟨0, by decide, rfl, by decide⟩, trivial⟩,
     not_continuing_chain_one⟩⟩,
   fun included => Nat.not_lt_zero 0 ((included 0 (· = 0)
     ⟨fun d => by subst d; decide, fun _ pair =>
       absurd pair (fun p => match (chainFromOne_prec_iff 0).mp p with
         | ⟨_, below, _, _⟩ => Nat.not_lt_zero _ below)⟩).within rfl)⟩

/-- **`prec_iff_of_both` needs its starts**: the chain from one element includes the chain's stems
and continues at least as much within the one class, and at offset `1` it has a pair the chain
lacks. -/
theorem prec_iff_of_both_needs_starts :
    chainFromOne.RangeIncludes Stem chain ∧
      (∀ t, «则» («相续» (chain.state t).prec «一») («相续» (chainFromOne.state t).prec «一»)) ∧
      (chainFromOne.state 1).prec 0 1 ∧ ¬ (chain.state 1).prec 0 1 :=
  ⟨fun t D stem =>
     ⟨fun d => Nat.lt_of_lt_of_le
        (Nat.lt_of_lt_of_le (stem.within d) (Nat.le_of_eq (size_of_run (r := chain) rfl t)))
        (Nat.le_trans (Nat.le_add_left t 1) (Nat.le_of_eq (grownFrom_size one _ t).symm)),
      fun d pair => stem.closed d ((chain_prec_iff t).mpr
        ⟨Nat.lt_of_lt_of_le (stem.within d) (Nat.le_of_eq (size_of_run (r := chain) rfl t)),
         chainFromOne_labelled pair⟩)⟩,
   fun t => «及之单调» (R := «续» (chain.state t).prec «一»)
       (S := «续» (chainFromOne.state t).prec «一») (fun x y step => ⟨(chainFromOne_prec_iff t).mpr
       (match y, (chain_prec_iff t).mp step.1 with
        | 0, ⟨_, earlier⟩ => absurd earlier (Nat.not_lt_zero x)
        | k + 1, ⟨later, earlier⟩ =>
          ⟨k, Nat.lt_of_succ_lt later, Nat.add_comm k 1, Nat.lt_of_lt_of_le earlier
            (Nat.le_of_eq (Nat.add_comm k 1))⟩), trivial⟩),
   (chainFromOne_prec_iff 1).mpr ⟨0, by decide, rfl, by decide⟩,
   fun pair => absurd ((chain_prec_iff 1).mp pair).1 (by decide)⟩

/-- **`rangeIncludes_strict_iff`, `rangeWidens_strict`, `not_included_of_rangeExceeds` and
`rangeExceeds_iff_pair` need their starts**: `fromOne` includes the antichain's stems strictly and
exceeds them, while each course's precedence, empty, is included in the other's. -/
theorem strict_needs_starts :
    (fromOne.RangeIncludes Stem antichain ∧ ¬ antichain.RangeIncludes Stem fromOne) ∧
      fromOne.RangeExceeds Stem antichain ∧
      (∀ t i j, (antichain.state t).prec i j → (fromOne.state t).prec i j) ∧
      (∀ t i j, (fromOne.state t).prec i j → (antichain.state t).prec i j) :=
  ⟨⟨fromOne_widens.1, rangeIncludes_continuing_iff_needs_starts.2⟩,
   fromOne_widens.2,
   fun t i j pair => absurd pair (antichain_prec t i j),
   fun t _ _ pair => absurd pair (fromOne_prec t)⟩

/-- **`rangeExceeds_of_pair` and `rangeWidens_of` need their starts**: `oneAbove`'s precedence is
included in `fromTwo`'s at every offset, `fromTwo` has a pair `oneAbove` lacks, and `oneAbove` does
not exceed `fromTwo`'s stems. -/
theorem rangeWidens_of_needs_starts :
    (∀ t i j, (oneAbove.state t).prec i j → (fromTwo.state t).prec i j) ∧
      (fromTwo.state 0).prec 0 1 ∧ ¬ (oneAbove.state 0).prec 0 1 ∧
      ¬ oneAbove.RangeExceeds Stem fromTwo :=
  ⟨fun t _ _ pair => (fromTwo_prec_iff t).mpr (oneAbove_prec pair),
   ⟨rfl, rfl⟩, fun pair => pair,
   fun ⟨t, D, yes, no⟩ => mixed_of_pair_needs_starts.2.2 ⟨t, .inl D, yes, no⟩⟩

/-- **`continuation_of_rangeIncludes` needs its starts**: the chain from one element includes the
chain's stems and, at offset `1`, continues from `0` to `1` within the one class where the chain does
not. -/
theorem continuation_of_rangeIncludes_needs_starts :
    chainFromOne.RangeIncludes Stem chain ∧ «相续» (chainFromOne.state 1).prec «一» 0 1 ∧
      ¬ «相续» (chain.state 1).prec «一» 0 1 :=
  ⟨prec_iff_of_both_needs_starts.1,
   «及».one ⟨prec_iff_of_both_needs_starts.2.2.1, trivial⟩,
   not_continuing_chain_one⟩

/-- No elements, and a precedence relating every pair. -/
def full : Causet := ⟨0, fun _ _ => True⟩

theorem full_stem_empty {t : Nat} {D : Nat → Prop} (stem : Stem ((fromEmptyPasts full).state t) D)
    {i : Nat} (held : D i) : False :=
  Nat.lt_irrefl _ (stem.within (stem.closed (i := ((fromEmptyPasts full).state t).size) held
    ((grownFrom_empty_prec full t).mpr trivial)))

/-- **`keepsWidening` needs a causal set at the start**: from `full`, every past empty, no stem holds
an element, and nothing keeps widening. -/
theorem keepsWidening_needs_start :
    ¬ Reaching.KeepsWidening (fun t => Stem ((fromEmptyPasts full).state t)) :=
  fun keeps => match keeps.2 0 with
  | ⟨_, _, stem, notNow⟩ =>
    notNow ⟨fun held => (full_stem_empty stem held).elim,
      fun held _ => (full_stem_empty stem held).elim⟩

end Starts

/-! ## No configuration renews without end; the limits of the extremes part -/

/-- **Where a relation raises the label and relates only below `n`, every element ceases**
(`«息»`) under every class. -/
theorem ceases_of_bounded {O : «际» Nat} (E : «际» Nat) (labelled : ∀ {i j}, O i j → i < j)
    {n : Nat} (bound : ∀ {i j}, O i j → j < n) : ∀ k x, n ≤ x + k → «息» O E x
  | 0, x, top => .mk fun _ ⟨_, step, _, _⟩ =>
      absurd (Nat.lt_of_lt_of_le (Nat.lt_trans (labelled step) (bound step)) top) (Nat.lt_irrefl x)
  | k + 1, x, top => .mk fun w ⟨_, step, _, line⟩ =>
      ceases_of_bounded E labelled bound k w (Nat.le_trans top (by
        show Nat.succ (x + k) ≤ w + k
        rw [← Nat.succ_add]
        exact Nat.add_le_add_right
          (Nat.lt_trans (labelled step) (labelled_of_reach (fun c => labelled c.1) line)) k))

/-- **On every causal set of the growth every element ceases, in every class, on precedence and
on links.** -/
theorem ordered_ceases {c : Causet} (ordered : c.Ordered) (E : «际» Nat) (x : Nat) :
    «息» c.prec E x ∧ «息» (links c.prec) E x :=
  ⟨ceases_of_bounded E ordered.labelled ordered.within c.size x (Nat.le_add_left _ _),
   ceases_of_bounded E (fun link => ordered.labelled link.1) (fun link => ordered.within link.1)
     c.size x (Nat.le_add_left _ _)⟩

/-- **So no configuration of the growth renews without end** (`«生生»`), in any class. -/
theorem ordered_not_renews {c : Causet} (ordered : c.Ordered) (E : «际» Nat) (x : Nat) :
    ¬ «生生» c.prec E x ∧ ¬ «生生» (links c.prec) E x :=
  ⟨fun renews => «生生不息» renews (ordered_ceases ordered E x).1,
   fun renews => «生生不息» renews (ordered_ceases ordered E x).2⟩

/-- The chain's limit: `i` before `j` at some offset. -/
def chainLimit (i j : Nat) : Prop := ∃ t, (chain.state t).prec i j

theorem chainLimit_iff {i j : Nat} : chainLimit i j ↔ i < j :=
  ⟨fun ⟨t, pair⟩ => ((chain_prec_iff t).mp pair).2,
   fun earlier => ⟨j + 1, (chain_prec_iff (j + 1)).mpr ⟨Nat.lt_succ_self j, earlier⟩⟩⟩

/-- The antichain's limit. -/
def antichainLimit (i j : Nat) : Prop := ∃ t, (antichain.state t).prec i j

/-- **On the antichain's limit nothing renews without end, in any class.** -/
theorem antichainLimit_not_renews (E : «际» Nat) (x : Nat) : ¬ «生生» antichainLimit E x :=
  fun renews => match «生生之展» renews with
  | ⟨_, _, ⟨t, pair⟩, _⟩ => antichain_prec t _ _ pair

namespace Halves

def half : Nat → Nat
  | 0 => 0
  | 1 => 0
  | n + 2 => half n + 1

/-- The class pairing `2m` with `2m + 1`. -/
def pairs (i j : Nat) : Prop := half i = half j

theorem pairs_class : «类» pairs := ⟨fun _ => rfl, fun same => same.symm, fun a b => a.trans b⟩

theorem double_succ (m : Nat) : (m + 1) + (m + 1) = m + m + 2 :=
  show Nat.succ ((m + 1) + m) = Nat.succ (Nat.succ (m + m)) from congrArg Nat.succ (Nat.succ_add m m)

theorem half_double : ∀ m, half (m + m) = m
  | 0 => rfl
  | m + 1 => by rw [double_succ]; exact congrArg (· + 1) (half_double m)

theorem half_double_succ : ∀ m, half (m + m + 1) = m
  | 0 => rfl
  | m + 1 => by rw [double_succ]; exact congrArg (· + 1) (half_double_succ m)

theorem half_lt : ∀ x m, x < m + m → half x < m
  | _, 0, below => absurd below (Nat.not_lt_zero _)
  | 0, m + 1, _ => Nat.succ_pos m
  | 1, m + 1, _ => Nat.succ_pos m
  | n + 2, m + 1, below => Nat.succ_lt_succ (half_lt n m (by
      rw [double_succ] at below
      exact Nat.lt_of_succ_lt_succ (Nat.lt_of_succ_lt_succ below)))

/-- The odd numbers. -/
def odd (z : Nat) : Prop := ∃ m, z = m + m + 1

end Halves

/-- **On the chain's limit, under the class pairing `2m` with `2m + 1`, `1` renews without end**
(`«生生»`): each odd element conditions the next even one, which begins its pair, and the pair's
line goes on to the next odd element. -/
theorem chainLimit_renews : «生生» chainLimit Halves.pairs 1 :=
  ⟨Halves.odd, fun z ⟨m, oddZ⟩ => ⟨(m + 1) + (m + 1), (m + 1) + (m + 1) + 1,
     chainLimit_iff.mpr (by rw [oddZ, Halves.double_succ]; exact Nat.lt_succ_self _),
     fun ⟨x, before, same⟩ => by
       have h := Halves.half_lt x (m + 1) (chainLimit_iff.mp before)
       have same' : Halves.half x = Halves.half ((m + 1) + (m + 1)) := same
       rw [same', Halves.half_double] at h
       exact Nat.lt_irrefl _ h,
     «及».one ⟨chainLimit_iff.mpr (Nat.lt_succ_self _),
       show Halves.half ((m + 1) + (m + 1)) = Halves.half ((m + 1) + (m + 1) + 1) by
         rw [Halves.half_double, Halves.half_double_succ]⟩,
     ⟨m + 1, rfl⟩⟩,
   ⟨0, rfl⟩⟩

/-! ## Read on links, a finer class can gain or lose continuation by widening -/

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

/-- **Widening can also remove such continuation**: the antichain widens the wider course's stems,
and the class continues from `0` to `2` on links in the wider course and not in the antichain. -/
theorem loses : antichain.RangeWidens Stem wide ∧
    «相续» (links (wide.state 3).prec) classOf 0 2 ∧
    ¬ «相续» (links (antichain.state 3).prec) classOf 0 2 :=
  ⟨antichain_rangeWidens (r := wide) (t := 3) (i := 0) (j := 2) rfl
     ((grown_prec_iff widePast 3).mpr ⟨by decide, rfl, rfl⟩),
   continues,
   fun line => match line with
     | .one step => antichain_prec 3 0 2 step.1.1
     | .more step _ => antichain_prec 3 0 _ step.1.1⟩

end Finer

/-! ## What can be born next up to relabelling -/

namespace Kinds

/-- A relabelling carrying `c` onto `c'`: `σ` and `τ` inverse between their elements, with the
precedence read through `σ`. -/
def Relabels (c c' : Causet) (σ τ : Nat → Nat) : Prop :=
  (∀ i, i < c.size → σ i < c'.size ∧ τ (σ i) = i) ∧
    (∀ j, j < c'.size → τ j < c.size ∧ σ (τ j) = j) ∧
    ∀ i j, i < c.size → j < c.size → (c.prec i j ↔ c'.prec (σ i) (σ j))

/-- Two configurations of one kind: a relabelling carries one onto the other. -/
def Isomorphic (c c' : Causet) : Prop := ∃ σ τ, Relabels c c' σ τ

/-- Every kind of birth from `c` is a kind of birth from `c'`: each birth from a stem of `c` is
isomorphic to a birth from a stem of `c'`. -/
def Included (c c' : Causet) : Prop :=
  ∀ D, Stem c D → ∃ D', Stem c' D' ∧ Isomorphic (birth c D) (birth c' D')

/-- **Up to relabelling, the pasts still reverse the inclusion of precedence**: where `τ` carries
the elements of `c` one to one into those of `c'`, `σ` undoing it, as the inverse of a relabelling of
`c'` onto `c` does, every stem of `c'`, carried over by `τ`, is a stem of `c` exactly where the
precedence of `c`, carried back, is included in that of `c'`. The two need not have one size. -/
theorem stems_carried_iff {c c' : Causet} (ordered : c.Ordered) (ordered' : c'.Ordered)
    {σ τ : Nat → Nat} (back : ∀ j, j < c.size → τ j < c'.size ∧ σ (τ j) = j) :
    (∀ D, Stem c' D → Stem c (fun j => j < c.size ∧ D (τ j))) ↔
      ∀ i j, c.prec i j → c'.prec (τ i) (τ j) :=
  ⟨fun carried i j pair =>
     match (carried _ (stem_principal ordered' (back j (ordered.within pair)).1)).closed
         ⟨ordered.within pair, .inl rfl⟩ pair with
     | ⟨_, .inl same⟩ =>
       absurd pair (by
         rw [← (back i (Nat.lt_trans (ordered.labelled pair) (ordered.within pair))).2, same,
           (back j (ordered.within pair)).2]
         exact ordered.irrefl j)
     | ⟨_, .inr p⟩ => p,
   fun inside D stem =>
     ⟨fun d => d.1, fun d pair =>
       ⟨Nat.lt_trans (ordered.labelled pair) d.1, stem.closed d.2 (inside _ _ pair)⟩⟩⟩

/-- **The carrying needs no relabelling, nor one size**: `stems_carried_iff` applies from the
antichain's configuration of one element into its configuration of two, by `j ↦ j + 1`, with
`j ↦ j - 1` undoing it. -/
theorem stems_carried_unequal :
    ∀ D, Stem (antichain.state 2) D →
      Stem (antichain.state 1) (fun j => j < (antichain.state 1).size ∧ D (j + 1)) :=
  (stems_carried_iff (c := antichain.state 1) (c' := antichain.state 2)
    (ordered_of_empty (r := antichain) rfl 1) (ordered_of_empty (r := antichain) rfl 2)
    (σ := fun j => j - 1) (τ := fun j => j + 1)
    (fun _ below => ⟨Nat.succ_lt_succ below, rfl⟩)).mpr
    (fun i j pair => absurd pair (antichain_prec 1 i j))

/-- Exchanging `0` and `1`. -/
def swap (i : Nat) : Nat := if i = 0 then 1 else if i = 1 then 0 else i

/-- The exchange fixes every other element. -/
theorem swap_fixed {i : Nat} (h0 : ¬ i = 0) (h1 : ¬ i = 1) : swap i = i := by
  unfold swap; rw [if_neg h0, if_neg h1]

theorem swap_swap (i : Nat) : swap (swap i) = i :=
  if h0 : i = 0 then by subst h0; decide
  else if h1 : i = 1 then by subst h1; decide
  else by rw [swap_fixed h0 h1, swap_fixed h0 h1]

/-- The exchange keeps every element below a bound of at least `2` below it. -/
theorem swap_below {n : Nat} (two : 2 ≤ n) {i : Nat} (below : i < n) : swap i < n :=
  if h0 : i = 0 then by subst h0; exact Nat.lt_of_lt_of_le (by decide : swap 0 < 2) two
  else if h1 : i = 1 then by subst h1; exact Nat.lt_of_lt_of_le (by decide : swap 1 < 2) two
  else Eq.subst (motive := fun x => x < n) (swap_fixed h0 h1).symm below

theorem swap_eq_two_iff (j : Nat) : swap j = 2 ↔ j = 2 :=
  if h0 : j = 0 then by subst h0; decide
  else if h1 : j = 1 then by subst h1; decide
  else ⟨fun e => (swap_fixed h0 h1).symm.trans e, fun e => (swap_fixed h0 h1).trans e⟩

theorem swap_eq_one_iff (i : Nat) : swap i = 1 ↔ i = 0 :=
  if h0 : i = 0 then by subst h0; decide
  else if h1 : i = 1 then by subst h1; decide
  else ⟨fun e => absurd ((swap_fixed h0 h1).symm.trans e) h1, fun e => absurd e h0⟩

/-- **Two stems, one kind**: at offset 2 the antichain's births above `0` and above `1` are
isomorphic, by exchanging `0` and `1`. -/
theorem antichain_two_stems_one_kind :
    Stem (antichain.state 2) (· = 0) ∧ Stem (antichain.state 2) (· = 1) ∧
      Isomorphic (birth (antichain.state 2) (· = 0)) (birth (antichain.state 2) (· = 1)) :=
  ⟨⟨fun d => by subst d; decide, fun _ pair => absurd pair (antichain_prec 2 _ _)⟩,
   ⟨fun d => by subst d; decide, fun _ pair => absurd pair (antichain_prec 2 _ _)⟩,
   swap, swap,
   fun i below => ⟨swap_below (n := 3) (by decide) below, swap_swap i⟩,
   fun j below => ⟨swap_below (n := 3) (by decide) below, swap_swap j⟩,
   fun i j _ _ =>
     ⟨fun pair => match pair with
       | .inl p => absurd p (antichain_prec 2 _ _)
       | .inr ⟨top, d⟩ => .inr ⟨by rw [top]; decide, by rw [d]; decide⟩,
      fun pair => match pair with
       | .inl p => absurd p (antichain_prec 2 _ _)
       | .inr ⟨top, d⟩ =>
         .inr ⟨(swap_swap j).symm.trans ((congrArg swap top).trans (by decide)),
               (swap_swap i).symm.trans ((congrArg swap d).trans (by decide))⟩⟩⟩

/-- **The antichain's kinds of birth are not among the chain's**: at offset 2 the birth with the
empty past has no precedence, and every birth from the chain has `0` before `1`. -/
theorem not_included_antichain_chain : ¬ Included (antichain.state 2) (chain.state 2) :=
  fun included =>
    match included (fun _ => False) ⟨False.elim, fun d _ => d⟩ with
    | ⟨D', _, σ, τ, _, back, keeps⟩ =>
      match back 0 (by show 0 < 3; decide), back 1 (by show 1 < 3; decide) with
      | ⟨in0, at0⟩, ⟨in1, at1⟩ =>
        have pair : (birth (chain.state 2) D').prec (σ (τ 0)) (σ (τ 1)) := by
          rw [at0, at1]; exact .inl ((chain_prec_iff 2).mpr ⟨by decide, by decide⟩)
        match (keeps _ _ in0 in1).mpr pair with
        | .inl p => antichain_prec 2 _ _ p
        | .inr ⟨_, d⟩ => d

/-- **The chain's kinds of birth are not among the antichain's**: the chain's birth above `0` has
`0` before two elements, and in every birth from the antichain each pair ends at the new element. -/
theorem not_included_chain_antichain : ¬ Included (chain.state 2) (antichain.state 2) :=
  fun included =>
    match included (· = 0)
        ⟨fun d => by subst d; decide,
         fun d pair => by subst d; exact absurd ((chain_prec_iff 2).mp pair).2 (Nat.not_lt_zero _)⟩ with
    | ⟨_, _, σ, τ, forth, _, keeps⟩ =>
      match (keeps 0 1 (by decide) (by decide)).mp (.inl ((chain_prec_iff 2).mpr ⟨by decide, by decide⟩)),
          (keeps 0 2 (by decide) (by decide)).mp (.inr ⟨(grown_size _ 2).symm, rfl⟩) with
      | .inl p, _ => antichain_prec 2 _ _ p
      | _, .inl p => antichain_prec 2 _ _ p
      | .inr ⟨top1, _⟩, .inr ⟨top2, _⟩ =>
        absurd ((forth 1 (by decide)).2.symm.trans
            ((congrArg τ (top1.trans top2.symm)).trans (forth 2 (by decide)).2)) (by decide)

/-- **At offset `0` each extreme's kinds of birth are among the other's**: the two laws above are
about offset `2`. -/
theorem included_at_zero :
    Included (antichain.state 0) (chain.state 0) ∧ Included (chain.state 0) (antichain.state 0) :=
  ⟨fun D stem => ⟨D, stem, id, id, fun _ below => ⟨below, rfl⟩, fun _ below => ⟨below, rfl⟩,
     fun _ _ _ _ => Iff.rfl⟩,
   fun D stem => ⟨D, stem, id, id, fun _ below => ⟨below, rfl⟩, fun _ below => ⟨below, rfl⟩,
     fun _ _ _ _ => Iff.rfl⟩⟩

/-- `2` born above `1`, every other birth with the empty past: `Finer.wide`, which bears `2` above
`0`, with `0` and `1` exchanged. -/
def swappedPast (t i : Nat) : Prop := t = 2 ∧ i = 1

theorem swapped_two {t i : Nat} (d : swappedPast t i) : t = 2 ∧ i < 2 := ⟨d.1, by rw [d.2]; decide⟩

/-- The swapped course. -/
def swapped : Run process := course swappedPast (stems_of_two swapped_two)

/-- `Finer.wide`'s precedence is the swapped course's, read through the exchange. -/
theorem wide_prec_iff_swapped (t : Nat) {i j : Nat} :
    (Finer.wide.state t).prec i j ↔ (swapped.state t).prec (swap i) (swap j) :=
  (grown_prec_iff Finer.widePast t).trans (Iff.trans
    (show (j < t ∧ (j = 2 ∧ i = 0)) ↔ (swap j < t ∧ (swap j = 2 ∧ swap i = 1)) from
      ⟨fun ⟨below, two, zero⟩ =>
         ⟨Eq.subst (motive := fun x => x < t)
            (((swap_eq_two_iff j).mpr two).trans two.symm).symm below,
          (swap_eq_two_iff j).mpr two, (swap_eq_one_iff i).mpr zero⟩,
       fun ⟨below, two, isOne⟩ =>
         ⟨Eq.subst (motive := fun x => x < t) (two.trans ((swap_eq_two_iff j).mp two).symm) below,
          (swap_eq_two_iff j).mp two, (swap_eq_one_iff i).mp isOne⟩⟩)
    (grown_prec_iff swappedPast t).symm)

/-- **From offset `2` on, `Finer.wide` and the swapped course grow configurations of one kind**, by
exchanging `0` and `1`. -/
theorem wide_swapped_isomorphic (k : Nat) :
    Isomorphic (Finer.wide.state (k + 2)) (swapped.state (k + 2)) :=
  ⟨swap, swap,
   fun i below => ⟨Nat.lt_of_lt_of_le
       (swap_below (Nat.le_add_left 2 k)
         (Nat.lt_of_lt_of_le below (Nat.le_of_eq (size_of_run (r := Finer.wide) rfl (k + 2)))))
       (Nat.le_of_eq (size_of_run (r := swapped) rfl (k + 2)).symm),
     swap_swap i⟩,
   fun j below => ⟨Nat.lt_of_lt_of_le
       (swap_below (Nat.le_add_left 2 k)
         (Nat.lt_of_lt_of_le below (Nat.le_of_eq (size_of_run (r := swapped) rfl (k + 2)))))
       (Nat.le_of_eq (size_of_run (r := Finer.wide) rfl (k + 2)).symm),
     swap_swap j⟩,
   fun _ _ _ _ => wide_prec_iff_swapped (k + 2)⟩

/-- **Yet each exceeds the other's stems**: the order on courses is labelled, and leaves two courses
growing configurations of one kind mixed. -/
theorem wide_swapped_mixed :
    Finer.wide.RangeExceeds Stem swapped ∧ swapped.RangeExceeds Stem Finer.wide :=
  ⟨rangeExceeds_of_pair (r := Finer.wide) (r' := swapped) rfl rfl (t := 3) (i := 1) (j := 2)
     ((grown_prec_iff swappedPast 3).mpr ⟨by decide, rfl, rfl⟩)
     (fun pair => absurd ((grown_prec_iff Finer.widePast 3).mp pair).2.2 (by decide)),
   rangeExceeds_of_pair (r := swapped) (r' := Finer.wide) rfl rfl (t := 3) (i := 0) (j := 2)
     ((grown_prec_iff Finer.widePast 3).mpr ⟨by decide, rfl, rfl⟩)
     (fun pair => absurd ((grown_prec_iff swappedPast 3).mp pair).2.2 (by decide))⟩

end Kinds

end CausalGrowth

end Becoming
