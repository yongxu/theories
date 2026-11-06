import Becoming.CausalGrowth
import Becoming.OrderNormal

/-!
# The present on causal-set growth: what of presence is the same on every course

The root leaves open whether a condition must still be there when what it conditions arises: the
grammar has no relation of presence in time, and adding one is a choice of model. Causal-set
growth (`Becoming.CausalGrowth`) is a model in which the question can be asked exactly, since its
labels, the order of births, are taken to carry no meaning beyond precedence (discrete general
covariance, Rideout and Sorkin 2000, a premise of the model). Read as being in the configuration, a condition is there when what it
conditions is born, on every course, since the growth holds its past; read as the birth of each
element (Dowker 2014), it is past by then; read as a maximal antichain of the whole configuration,
it is never in one present with what it conditions. None of these varies with the course. This
module reads the present at a stage of a course as the maximal elements of what the course has
born, a reading on which presence does vary with the course, and asks what of it every course
keeps.

* **Natural labellings.** A renumbering of a causal set's elements keeping precedence
  (`NaturalLabelling`) gives a causal set of its kind (`relabel_ordered`, `natural_relabels`),
  every relabelling onto a causal set of the same size is one (`natural_of_relabels`), and every
  causal set is the configuration of a course from the empty set (`courseOf_grows`,
  `courseOf_isomorphic`). So the natural labellings are exactly the orders of birth of the courses
  from the empty set growing a configuration of its kind (`natural_iff_course`). They depend only
  on the size and the precedence (`natural_congr`), and so does whatever holds on every course or
  on some course (`every_congr`, `some_congr`).
* **Births of unrelated elements commute, and only they.** From a natural labelling, the
  arrangements reached by exchanging consecutive births of incomparable elements are exactly the
  natural labellings (`rearranges_iff_natural`): Mazurkiewicz's theorem of the core
  (`rearranges_iff`), read on growth with joining as comparability (`Comparable`).
* **A down-set first.** For a test `p` on the first `n` numbers, the stable partition `front`
  (what passes first, then the rest, each in its order) is a renumbering (`front_reindexes`), by
  counting (`count`, `count_reaches`) with its inverse found by `firstWhere`; where `p` is closed
  downward under precedence it is a natural labelling (`front_natural`). Every test on the first
  `n` numbers has a table doubly negated, and a decided one has a table (`table_not_not`,
  `table_of`); a table of a test closed downward gives a natural labelling (`natural_of_table`).
* **What a course has born** by a stage is a stem (`born_closed`, `born_stem`), and every stem
  with decided membership is what some course bears first, in as many births as it has elements
  (`stem_born_first`): Brightwell and others' characterization of their stem sets.
* **Born before.** With precedence decided, `i` is born before `j` on every course exactly where
  `i` precedes `j` (`prec_iff_every`; Szpilrajn's extension theorem in Dushnik and Miller's
  intersection form, read on growth), so what is born no later than an element on every course is
  its past, itself included (`past_every_iff`), the largest relation every course respects
  (`past_largest`): the relation Stein's theorem singles out, here as a maximum. With no decision,
  being born before on every course is precedence not refuted (`every_iff_not_not`). With
  precedence weakly decided, `i` is born before `j` on some course exactly where the two differ
  and `j` does not precede `i` (`before_some_iff`): two different unrelated elements are born in
  either order (`either_order`), so no order of birth of unrelated elements is common to all
  courses.
* **The present at a stage** (`MaximalBorn`: an element born by then, and nothing it precedes is)
  is where the grammar's ending under the one class holds on what is born by then
  (`maximalBorn_iff_ends`, `«亡»` under `«一»` read on `bornBy`). It is an antichain
  (`maximalBorn_unrelated`), and with precedence weakly decided every antichain given by a Boolean
  test is the present of some course at some stage (`maximalBorn_front`, `antichain_present`).
  With precedence weakly decided, two elements are present together, in the present at one stage,
  on some course exactly where neither precedes the other (`together_some_iff`); with precedence
  decided, on every course exactly where they have the same future (`together_every_iff`), and
  with no decision exactly where the same future holds doubly negated
  (`together_every_iff_not_not`). Present together is not the root's co-presence, 俱有, mutual
  reach, which no two elements of a causal set have.
* **Presence of a condition when what it conditions is born** (`PresentAt`: `i` precedes `j` and
  nothing `i` precedes is born before `j`, so `i` is in the present at `j`'s birth,
  `present_iff_maximalBorn`). A condition present at a birth on some course is a link below what
  is born (`link_of_present`), and with precedence weakly decided every link is
  (`present_some_iff_link`). With no decision, `i` is present at `j`'s birth on every course
  exactly where `j` is the one element `i` is linked to (`present_every_iff_only_link`). With
  precedence decided this is exactly where `j` is the least element above `i`, everything `i`
  precedes being `j` or above `j` (`LeastAbove`, `present_every_iff`, `least_iff_only_link`).
* **On the courses themselves.** What holds in every natural labelling holds on every course of
  the growth from the empty set, read through a relabelling onto its configuration at the causal
  set's size, and what holds in some natural labelling holds on some such course
  (`every_course_iff`, `some_course_iff`); each main law is stated so, with its law's decision
  (`prec_iff_every_course`, `present_some_course`, `present_every_course_only_link` and the
  others).
* **What the decisions are.** Asked of every causal set, the decided forms of the laws on every
  course, for being born before (`every_iff_em`, `past_every_iff_em`), for being present
  together (`together_every_iff_em`) and for passing from presence on every course, or from the
  one link, to the least element above (`present_least_iff_em`, `only_link_least_iff_em`), are each
  exactly excluded middle: agreement across all courses settles a relation only up to double
  negation, and asserting it is deciding. The laws on some course (`either_order_iff_weakly`,
  `before_some_iff_weakly`, `together_some_iff_weakly`, `antichain_present_iff_weakly`,
  `present_some_iff_weakly`) are each exactly weak excluded middle: finding a course that shows two
  elements unordered, or a link present, is deciding only whether a precedence fails.
* **Witnesses.** On three elements, `0` below `1` and `2`, `0` is present at `2`'s birth in one
  natural labelling and not in another (`Vee.present_swap`, `Vee.not_present_identity`), and the
  present after two births is exactly `1` on one course and exactly `2` on another
  (`Vee.maximal_after_two_identity`, `Vee.maximal_after_two_swap`). On Wüthrich and Callender's
  four elements, `0` below `1` and `2`, both below `3`, their relation, each element with itself
  and its past and the two middle elements with each other, is reflexive and transitive, kept by
  every automorphism, and neither the past read reflexively nor universal
  (`Diamond.pastOrPair_trans`, `Diamond.pastOrPair_kept`, `Diamond.pastOrPair_pair`), while on some
  course `2` is born after `1` and on another before it (`Diamond.kept_not_agreed`,
  `Diamond.courses_disagree`). On the diamond it is the past with the pair present together on
  every course, which have the same future (`Diamond.pastOrPair_iff_together`). Off the diamond
  that join need not be their relation: on four elements two can be present together on every course
  with different pasts, and there the join is not transitive
  (`SameFuture.together_different_pasts`, `SameFuture.pastOrTogether_not_trans`).

So each relation of presence read on a course, born before, present at a birth, present together,
has two bounds, what holds on some course and what holds on every course; both are defined from
precedence, as everything read on all courses or on some course is (`every_congr`, `some_congr`),
and which presence holds between them is a choice of course. Invariance under automorphisms admits
Wüthrich and Callender's relation beside the past; on the diamond it is the past joined with being
present together on every course. In general their pairs share the past as well as the future, and
the join need not be transitive.

**Modelling choices.** Finite labelled causal sets, discrete births, natural-number labels;
covariance read only as relabelling; presence read as being among the maximal elements of what has
been born; precedence decided where a law says so (weakly decided suffices for the laws on some
course, and presence on every course read as the one link needs no decision), membership decided
for `stem_born_first`, antichains given by a Boolean test. Transition probabilities, Bell
causality, the continuum limit and infinite causal sets are not read. Every declaration has an
empty axiom report.
-/

namespace Becoming

namespace Presence

open CausalGrowth (Causet Stem links grown grown_size grown_prec_iff course process empty)

/-! ## Counting what a test passes -/

/-- How many of the numbers below `m` pass the test `p`: the numbers `Frequency.count` computes,
written with `cond` and kept here so that the leaf imports only `Becoming.CausalGrowth` and
`Becoming.OrderNormal`. Its laws `count_succ_of_true`, `count_succ_of_false`, `count_le_succ`,
`count_mono` and `count_le` restate Frequency's (`count_succ_on`, `count_succ_off`,
`count_le_succ`, `count_mono`, `count_le`). -/
def count (p : Nat → Bool) : Nat → Nat
  | 0 => 0
  | m + 1 => cond (p m) (count p m + 1) (count p m)

section Counting

variable {p : Nat → Bool}

theorem count_succ_of_true {m : Nat} (h : p m = true) : count p (m + 1) = count p m + 1 :=
  congrArg (fun b => cond b (count p m + 1) (count p m)) h

theorem count_succ_of_false {m : Nat} (h : p m = false) : count p (m + 1) = count p m :=
  congrArg (fun b => cond b (count p m + 1) (count p m)) h

theorem count_le_succ (p : Nat → Bool) (m : Nat) : count p m ≤ count p (m + 1) :=
  match h : p m with
  | true => Nat.le_trans (Nat.le_succ (count p m)) (Nat.le_of_eq (count_succ_of_true h).symm)
  | false => Nat.le_of_eq (count_succ_of_false h).symm

theorem count_le_add (p : Nat → Bool) (m : Nat) : ∀ k, count p m ≤ count p (m + k)
  | 0 => Nat.le_refl _
  | k + 1 => Nat.le_trans (count_le_add p m k) (count_le_succ p (m + k))

theorem count_mono (p : Nat → Bool) {m m' : Nat} (le : m ≤ m') : count p m ≤ count p m' :=
  match le_dest le with
  | ⟨k, e⟩ => Eq.subst (motive := fun x => count p m ≤ count p x) e.symm (count_le_add p m k)

theorem count_le (p : Nat → Bool) : ∀ m, count p m ≤ m
  | 0 => Nat.le_refl 0
  | m + 1 => match h : p m with
    | true => Nat.le_trans (Nat.le_of_eq (count_succ_of_true h)) (Nat.succ_le_succ (count_le p m))
    | false =>
      Nat.le_trans (Nat.le_of_eq (count_succ_of_false h)) (Nat.le_trans (count_le p m) (Nat.le_succ m))

/-- **What passes is counted before what comes later**: where `x` passes and `x < y`, fewer pass
below `x` than below `y`. -/
theorem count_lt_of {x y : Nat} (h : p x = true) (lt : x < y) : count p x < count p y :=
  Nat.lt_of_lt_of_le (Nat.lt_of_lt_of_le (Nat.lt_succ_self _) (Nat.le_of_eq (count_succ_of_true h).symm))
    (count_mono p (Nat.succ_le_of_lt lt))

/-- Two numbers passing the test with as many passing below each are one. -/
theorem count_inj {x y : Nat} (hx : p x = true) (hy : p y = true) (same : count p x = count p y) :
    x = y :=
  match Nat.lt_or_ge x y with
  | .inl lt => absurd same (Nat.ne_of_lt (count_lt_of hx lt))
  | .inr ge => match Nat.eq_or_lt_of_le ge with
    | .inl e => e.symm
    | .inr lt => absurd same.symm (Nat.ne_of_lt (count_lt_of hy lt))

/-- **The count takes every value below it**: below every count of what passes up to `m`, some
number below `m` passes with exactly that many passing below it. -/
theorem count_reaches (p : Nat → Bool) : ∀ m r, r < count p m → ∃ i, i < m ∧ p i = true ∧ count p i = r
  | 0, _, lt => absurd lt (Nat.not_lt_zero _)
  | m + 1, r, lt => match h : p m with
    | true =>
      match Nat.eq_or_lt_of_le (Nat.le_of_lt_succ (Nat.lt_of_lt_of_le lt (Nat.le_of_eq (count_succ_of_true h)))) with
      | .inl e => ⟨m, Nat.lt_succ_self m, h, e.symm⟩
      | .inr lower => match count_reaches p m r lower with
        | ⟨i, below, passes, counted⟩ => ⟨i, Nat.lt_succ_of_lt below, passes, counted⟩
    | false => match count_reaches p m r (Nat.lt_of_lt_of_le lt (Nat.le_of_eq (count_succ_of_false h))) with
      | ⟨i, below, passes, counted⟩ => ⟨i, Nat.lt_succ_of_lt below, passes, counted⟩

/-- **What passes and what fails together are all**: below `m`, the numbers passing and the
numbers failing make `m`. -/
theorem count_add_not (p : Nat → Bool) : ∀ m, count p m + count (fun x => !p x) m = m
  | 0 => rfl
  | m + 1 => match h : p m with
    | true =>
      calc count p (m + 1) + count (fun x => !p x) (m + 1)
          = (count p m + 1) + count (fun x => !p x) m :=
            congr (congrArg HAdd.hAdd (count_succ_of_true h))
              (count_succ_of_false (p := fun x => !p x) (ListTests.not_false_of_true h))
        _ = (count p m + count (fun x => !p x) m) + 1 := Nat.add_right_comm _ _ _
        _ = m + 1 := congrArg (· + 1) (count_add_not p m)
    | false =>
      calc count p (m + 1) + count (fun x => !p x) (m + 1)
          = count p m + (count (fun x => !p x) m + 1) :=
            congr (congrArg HAdd.hAdd (count_succ_of_false h))
              (count_succ_of_true (p := fun x => !p x) (ListTests.not_eq_true_of_false h))
        _ = m + 1 := congrArg (· + 1) (count_add_not p m)

end Counting

/-! ## A down-set first: the stable partition -/

/-- **The stable partition**: what passes `p` first, in its order, then the rest, in its order. -/
def front (p : Nat → Bool) (n i : Nat) : Nat :=
  cond (p i) (count p i) (count p n + count (fun x => !p x) i)

/-- The inverse of the stable partition: the first number below `n` it takes to `r`. -/
def back (p : Nat → Bool) (n r : Nat) : Nat :=
  firstWhere (fun x => Nat.beq (front p n x) r) 0 n

section Front

variable {p : Nat → Bool} {n : Nat}

theorem front_of_true {i : Nat} (h : p i = true) : front p n i = count p i :=
  congrArg (fun b => cond b (count p i) (count p n + count (fun x => !p x) i)) h

theorem front_of_false {i : Nat} (h : p i = false) :
    front p n i = count p n + count (fun x => !p x) i :=
  congrArg (fun b => cond b (count p i) (count p n + count (fun x => !p x) i)) h

theorem front_lt {i : Nat} (below : i < n) : front p n i < n :=
  match h : p i with
  | true =>
    Nat.lt_of_le_of_lt (Nat.le_of_eq (front_of_true h))
      (Nat.lt_of_lt_of_le (count_lt_of h below) (count_le p n))
  | false =>
    Nat.lt_of_le_of_lt (Nat.le_of_eq (front_of_false h))
      (Nat.lt_of_lt_of_le
        (Nat.add_lt_add_left (count_lt_of (p := fun x => !p x) (ListTests.not_eq_true_of_false h) below)
          (count p n))
        (Nat.le_of_eq (count_add_not p n)))

/-- **What passes comes before what fails.** -/
theorem front_true_lt_false {x y : Nat} (hx : p x = true) (hy : p y = false) (below : x < n) :
    front p n x < front p n y :=
  Nat.lt_of_le_of_lt (Nat.le_of_eq (front_of_true hx))
    (Nat.lt_of_lt_of_le (count_lt_of hx below)
      (Nat.le_trans (Nat.le_add_right _ _) (Nat.le_of_eq (front_of_false hy).symm)))

/-- Within the first `n` numbers, those passing are exactly those placed before `count p n`. -/
theorem front_lt_count_iff {x : Nat} (below : x < n) : front p n x < count p n ↔ p x = true :=
  ⟨fun lt => match h : p x with
     | true => rfl
     | false => absurd (Nat.lt_of_lt_of_le lt
         (Nat.le_trans (Nat.le_add_right _ _) (Nat.le_of_eq (front_of_false h).symm))) (Nat.lt_irrefl _),
   fun h => Nat.lt_of_le_of_lt (Nat.le_of_eq (front_of_true h)) (count_lt_of h below)⟩

theorem front_inj {i j : Nat} (hi : i < n) (hj : j < n) (same : front p n i = front p n j) : i = j :=
  match h : p i, h' : p j with
  | true, true => count_inj h h' ((front_of_true h).symm.trans (same.trans (front_of_true h')))
  | false, false =>
    count_inj (p := fun x => !p x) (ListTests.not_eq_true_of_false h) (ListTests.not_eq_true_of_false h')
      (Naturals.add_left_cancel ((front_of_false h).symm.trans (same.trans (front_of_false h'))))
  | true, false => absurd same (Nat.ne_of_lt (front_true_lt_false h h' hi))
  | false, true => absurd same.symm (Nat.ne_of_lt (front_true_lt_false h' h hj))

/-- **Every place is taken.** -/
theorem front_onto {r : Nat} (below : r < n) : ∃ i, i < n ∧ front p n i = r :=
  match Nat.lt_or_ge r (count p n) with
  | .inl lt => match count_reaches p n r lt with
    | ⟨i, hi, passes, counted⟩ => ⟨i, hi, (front_of_true passes).trans counted⟩
  | .inr ge =>
    have sum : count p n + (r - count p n) = r := add_sub_of_le ge
    have bound : count p n + (r - count p n) < count p n + count (fun x => !p x) n :=
      Nat.lt_of_le_of_lt (Nat.le_of_eq sum) (Nat.lt_of_lt_of_le below (Nat.le_of_eq (count_add_not p n).symm))
    have bound' : count p n + ((r - count p n) + 1) ≤ count p n + count (fun x => !p x) n := bound
    have rest : r - count p n < count (fun x => !p x) n := Naturals.le_of_add_le_add_left bound'
    match count_reaches (fun x => !p x) n (r - count p n) rest with
    | ⟨i, hi, fails, counted⟩ =>
      ⟨i, hi, (front_of_false (ListTests.false_of_not fails)).trans
        ((congrArg (fun k => count p n + k) counted).trans sum)⟩

theorem lt_zero_add {i n : Nat} (below : i < n) : i < 0 + n :=
  Nat.lt_of_lt_of_le below (Nat.le_of_eq (Nat.zero_add n).symm)

theorem of_lt_zero_add {i n : Nat} (below : i < 0 + n) : i < n :=
  Nat.lt_of_lt_of_le below (Nat.le_of_eq (Nat.zero_add n))

/-- **The stable partition is a renumbering** of the first `n` numbers, `back` undoing it. -/
theorem front_reindexes : Reindexes 0 n (front p n) (back p n) :=
  fun i _ below' =>
    have below := of_lt_zero_add below'
    have placed : back p n (front p n i) = i :=
      match firstWhere_found (fun x => Nat.beq (front p n x) (front p n i)) 0 n i (Nat.zero_le i) below'
          (beq_self (front p n i)) with
      | ⟨le, found⟩ =>
        front_inj (Nat.lt_of_le_of_lt le below) below (Nat.eq_of_beq_eq_true found)
    have taken : back p n i < n ∧ front p n (back p n i) = i :=
      match front_onto (p := p) below with
      | ⟨k, hk, e⟩ =>
        match firstWhere_found (fun x => Nat.beq (front p n x) i) 0 n k (Nat.zero_le k) (lt_zero_add hk)
            (Eq.subst (motive := fun v => Nat.beq (front p n k) v = true) e (beq_self (front p n k))) with
        | ⟨le, found⟩ => ⟨Nat.lt_of_le_of_lt le hk, Nat.eq_of_beq_eq_true found⟩
    ⟨⟨Nat.zero_le _, lt_zero_add (front_lt below), placed⟩,
     ⟨Nat.zero_le _, lt_zero_add taken.1, taken.2⟩⟩

/-- **A down-set first keeps the order**: where what precedes something passing passes too, the
stable partition keeps every order, the passing part placed first. -/
theorem front_keeps {J : Nat → Nat → Prop} (closed : ∀ {x y}, J x y → p y = true → p x = true) :
    KeepsOrder J 0 n (front p n) :=
  fun i j _ below' lt joined =>
    have below := of_lt_zero_add below'
    match hj : p j with
    | true =>
      have hi := closed joined hj
      Nat.lt_of_le_of_lt (Nat.le_of_eq (front_of_true hi))
        (Nat.lt_of_lt_of_le (count_lt_of hi lt) (Nat.le_of_eq (front_of_true hj).symm))
    | false => match hi : p i with
      | true => front_true_lt_false hi hj (Nat.lt_trans lt below)
      | false =>
        Nat.lt_of_le_of_lt (Nat.le_of_eq (front_of_false hi))
          (Nat.lt_of_lt_of_le
            (Nat.add_lt_add_left (count_lt_of (p := fun x => !p x) (ListTests.not_eq_true_of_false hi) lt)
              (count p n))
            (Nat.le_of_eq (front_of_false hj).symm))

end Front

/-! ## Natural labellings -/

/-- A **natural labelling** of `c`: a renumbering of its elements keeping precedence, the order of
births of a course growing a configuration of its kind (`natural_iff_course`). -/
def NaturalLabelling (c : Causet) (π σ : Nat → Nat) : Prop :=
  Reindexes 0 c.size π σ ∧ KeepsOrder c.prec 0 c.size π

section Natural

variable {c : Causet} {π σ : Nat → Nat}

theorem NaturalLabelling.at (natural : NaturalLabelling c π σ) {i : Nat} (below : i < c.size) :
    π i < c.size ∧ σ (π i) = i :=
  match natural.1 i (Nat.zero_le i) (lt_zero_add below) with
  | ⟨⟨_, lt, back⟩, _⟩ => ⟨of_lt_zero_add lt, back⟩

theorem NaturalLabelling.back (natural : NaturalLabelling c π σ) {j : Nat} (below : j < c.size) :
    σ j < c.size ∧ π (σ j) = j :=
  match natural.1 j (Nat.zero_le j) (lt_zero_add below) with
  | ⟨_, ⟨_, lt, back⟩⟩ => ⟨of_lt_zero_add lt, back⟩

/-- A natural labelling bears everything after what precedes it. -/
theorem NaturalLabelling.before (ordered : c.Ordered) (natural : NaturalLabelling c π σ) {i j : Nat}
    (pair : c.prec i j) : π i < π j :=
  natural.2 i j (Nat.zero_le i) (lt_zero_add (ordered.within pair)) (ordered.labelled pair) pair

/-- **The labels as they are** are a natural labelling. -/
theorem natural_identity (c : Causet) : NaturalLabelling c (fun i => i) (fun i => i) :=
  ⟨Reindexes.identity 0 c.size, fun _ _ _ _ lt _ => lt⟩

/-- The configuration of `c` read through `σ`: the label `a` stands for the element `σ a`. -/
def relabel (c : Causet) (σ : Nat → Nat) : Causet :=
  ⟨c.size, fun a b => a < c.size ∧ b < c.size ∧ c.prec (σ a) (σ b)⟩

/-- **A natural labelling gives a causal set.** -/
theorem relabel_ordered (ordered : c.Ordered) (natural : NaturalLabelling c π σ) :
    (relabel c σ).Ordered where
  trans := fun first second => match first, second with
    | ⟨ha, _, p⟩, ⟨_, hc, q⟩ => ⟨ha, hc, ordered.trans p q⟩
  labelled := fun {a b} pair => match pair with
    | ⟨ha, hb, p⟩ =>
      Eq.subst (motive := fun k => k < b) (natural.back ha).2
        (Eq.subst (motive := fun k => π (σ a) < k) (natural.back hb).2 (natural.before ordered p))
  within := fun pair => match pair with
    | ⟨_, hb, _⟩ => hb

/-- **Of its kind**: a natural labelling carries `c` onto the causal set it gives. -/
theorem natural_relabels (natural : NaturalLabelling c π σ) :
    CausalGrowth.Kinds.Relabels c (relabel c σ) π σ :=
  ⟨fun _ below => natural.at below,
   fun _ below => natural.back below,
   fun i j hi hj =>
     have ai := natural.at hi
     have aj := natural.at hj
     ⟨fun pair => show π i < c.size ∧ π j < c.size ∧ c.prec (σ (π i)) (σ (π j)) from
        ⟨ai.1, aj.1, Eq.subst (motive := fun k => c.prec k (σ (π j))) ai.2.symm
          (Eq.subst (motive := fun k => c.prec i k) aj.2.symm pair)⟩,
      fun pair => match pair with
        | ⟨_, _, p⟩ => Eq.subst (motive := fun k => c.prec i k) aj.2
            (Eq.subst (motive := fun k => c.prec k (σ (π j))) ai.2 p)⟩⟩

/-- **And every relabelling onto a causal set of the same size is a natural labelling**: numbering
`c`'s elements by their places in a configuration of its kind keeps precedence. -/
theorem natural_of_relabels {c' : Causet} (ordered' : c'.Ordered) (same : c'.size = c.size)
    (relabels : CausalGrowth.Kinds.Relabels c c' π σ) : NaturalLabelling c π σ :=
  ⟨fun i _ below' =>
     have below := of_lt_zero_add below'
     have there := relabels.1 i below
     have back := relabels.2.1 i (Nat.lt_of_lt_of_le below (Nat.le_of_eq same.symm))
     ⟨⟨Nat.zero_le _, lt_zero_add (Nat.lt_of_lt_of_le there.1 (Nat.le_of_eq same)), there.2⟩,
      ⟨Nat.zero_le _, lt_zero_add back.1, back.2⟩⟩,
   fun i j _ below' lt pair =>
     have hj := of_lt_zero_add below'
     ordered'.labelled ((relabels.2.2 i j (Nat.lt_trans lt hj) hj).mp pair)⟩

/-- Each element born with its past in `c`, every later one with the empty past. -/
def pastIn (c : Causet) (t i : Nat) : Prop := t < c.size ∧ c.prec i t

theorem pastIn_stem (ordered : c.Ordered) (t : Nat) : Stem (grown (pastIn c) t) (pastIn c t) :=
  ⟨fun d => match d with
     | ⟨_, p⟩ => Nat.lt_of_lt_of_le (ordered.labelled p) (Nat.le_of_eq (grown_size (pastIn c) t).symm),
   fun d pair => match d, (grown_prec_iff (pastIn c) t).mp pair with
     | ⟨below, p⟩, ⟨_, _, q⟩ => ⟨below, ordered.trans q p⟩⟩

/-- The course from the empty set growing `c`, each element born at the offset of its label. -/
def courseOf (c : Causet) (ordered : c.Ordered) : Run process :=
  course (pastIn c) (pastIn_stem ordered)

/-- **Every causal set is grown from the empty set**: at `c`'s size the course's configuration
has `c`'s elements and precedence. -/
theorem courseOf_grows (ordered : c.Ordered) :
    (courseOf c ordered).state 0 = empty ∧ ((courseOf c ordered).state c.size).size = c.size ∧
      ∀ i j, ((courseOf c ordered).state c.size).prec i j ↔ c.prec i j :=
  ⟨rfl, grown_size (pastIn c) c.size,
   fun _ _ => ⟨fun pair => match (grown_prec_iff (pastIn c) c.size).mp pair with
      | ⟨_, _, p⟩ => p,
    fun p => (grown_prec_iff (pastIn c) c.size).mpr ⟨ordered.within p, ordered.within p, p⟩⟩⟩

/-- So every causal set is a course's configuration up to kind. -/
theorem courseOf_isomorphic (ordered : c.Ordered) :
    CausalGrowth.Kinds.Isomorphic c ((courseOf c ordered).state c.size) :=
  ⟨fun i => i, fun i => i,
   fun _ below => ⟨Nat.lt_of_lt_of_le below (Nat.le_of_eq (courseOf_grows ordered).2.1.symm), rfl⟩,
   fun _ below => ⟨Nat.lt_of_lt_of_le below (Nat.le_of_eq (courseOf_grows ordered).2.1), rfl⟩,
   fun i j _ _ => ((courseOf_grows ordered).2.2 i j).symm⟩

/-- **The orders of birth.** The natural labellings of `c` are exactly the numberings of its
elements by a course from the empty set whose configuration at `c`'s size is of `c`'s kind: on such
a course `c`'s element `i` is the one born at offset `π i`. -/
theorem natural_iff_course (ordered : c.Ordered) :
    NaturalLabelling c π σ ↔ ∃ r : Run process, r.state 0 = empty ∧
      CausalGrowth.Kinds.Relabels c (r.state c.size) π σ :=
  ⟨fun natural =>
    have grows := courseOf_grows (relabel_ordered ordered natural)
    have kind := natural_relabels natural
    ⟨courseOf (relabel c σ) (relabel_ordered ordered natural), grows.1,
     fun i below => ⟨Nat.lt_of_lt_of_le (kind.1 i below).1 (Nat.le_of_eq grows.2.1.symm),
       (kind.1 i below).2⟩,
     fun j below => kind.2.1 j (Nat.lt_of_lt_of_le below (Nat.le_of_eq grows.2.1)),
     fun i j hi hj => (kind.2.2 i j hi hj).trans (grows.2.2 (π i) (π j)).symm⟩,
   fun ⟨_, start, relabels⟩ =>
    natural_of_relabels (CausalGrowth.ordered_of_empty start c.size)
      (CausalGrowth.size_of_run start c.size) relabels⟩

end Natural

/-- **The natural labellings depend only on the size and the precedence.** -/
theorem natural_congr {c c' : Causet} (size : c'.size = c.size)
    (same : ∀ a b, c.prec a b ↔ c'.prec a b) {π σ : Nat → Nat} (natural : NaturalLabelling c π σ) :
    NaturalLabelling c' π σ :=
  ⟨Eq.subst (motive := fun n => Reindexes 0 n π σ) size.symm natural.1,
   fun i j hi hj lt pair =>
     natural.2 i j hi (Eq.subst (motive := fun n => j < 0 + n) size hj) lt ((same i j).mpr pair)⟩

/-- **So whatever holds on every course depends only on the size and the precedence**: a bound on
every course of what is read on a course is defined from precedence, by construction. -/
theorem every_congr {c c' : Causet} (size : c'.size = c.size) (same : ∀ a b, c.prec a b ↔ c'.prec a b)
    (Φ : (Nat → Nat) → Prop) :
    (∀ π σ, NaturalLabelling c π σ → Φ π) ↔ (∀ π σ, NaturalLabelling c' π σ → Φ π) :=
  ⟨fun every π σ natural => every π σ (natural_congr size.symm (fun a b => (same a b).symm) natural),
   fun every π σ natural => every π σ (natural_congr size same natural)⟩

/-- **And so does whatever holds on some course.** -/
theorem some_congr {c c' : Causet} (size : c'.size = c.size) (same : ∀ a b, c.prec a b ↔ c'.prec a b)
    (Φ : (Nat → Nat) → Prop) :
    (∃ π σ, NaturalLabelling c π σ ∧ Φ π) ↔ (∃ π σ, NaturalLabelling c' π σ ∧ Φ π) :=
  ⟨fun ⟨π, σ, natural, holds⟩ => ⟨π, σ, natural_congr size same natural, holds⟩,
   fun ⟨π, σ, natural, holds⟩ =>
     ⟨π, σ, natural_congr size.symm (fun a b => (same a b).symm) natural, holds⟩⟩

/-! ## Births of unrelated elements commute, and only they -/

/-- Two elements are **comparable**: one precedes the other. -/
def Comparable (c : Causet) (a b : Nat) : Prop := c.prec a b ∨ c.prec b a

theorem comparable_symm {c : Causet} (a b : Nat) : Comparable c a b → Comparable c b a := Or.symm

/-- **Natural labellings orient every comparable pair alike.** -/
theorem natural_orients {c : Causet} (ordered : c.Ordered) {π σ π' σ' : Nat → Nat}
    (natural : NaturalLabelling c π σ) (natural' : NaturalLabelling c π' σ') :
    Orients (Comparable c) 0 c.size π π' :=
  fun _ _ _ _ _ _ rel lt => match rel with
    | .inl p => natural'.before ordered p
    | .inr p => absurd lt (Nat.lt_asymm (natural.before ordered p))

/-- **Births of unrelated elements commute, and only they**: from a natural labelling, the
arrangements reached by exchanging consecutive births of incomparable elements are exactly the
natural labellings. Mazurkiewicz's theorem of the core (`rearranges_iff`), read on growth. -/
theorem rearranges_iff_natural {c : Causet} (ordered : c.Ordered) {π σ π' σ' : Nat → Nat}
    (natural : NaturalLabelling c π σ) (reindex' : Reindexes 0 c.size π' σ') :
    Rearranges (Comparable c) 0 c.size π σ π' ↔ NaturalLabelling c π' σ' :=
  ⟨fun reached => ⟨reindex', fun i j _ below lt pair =>
      Rearranges.orients natural.1 reached i j (Nat.zero_le i) (Nat.lt_trans lt below) (Nat.zero_le j)
        below (.inl pair) (natural.2 i j (Nat.zero_le i) below lt pair)⟩,
   fun natural' => (rearranges_iff comparable_symm natural.1 reindex').mpr
     (natural_orients ordered natural natural')⟩

/-! ## A down-set first, and what a course has born -/

section Born

variable {c : Causet}

/-- **A down-set first is a natural labelling.** -/
theorem front_natural {p : Nat → Bool} (closed : ∀ {x y}, c.prec x y → p y = true → p x = true) :
    NaturalLabelling c (front p c.size) (back p c.size) :=
  ⟨front_reindexes, front_keeps closed⟩

/-- **What a course has born is closed downward**: where `y` is born among the first `t` births,
so is everything preceding it. -/
theorem born_closed (ordered : c.Ordered) {π σ : Nat → Nat} (natural : NaturalLabelling c π σ)
    {x y t : Nat} (pair : c.prec x y) (born : π y < t) : π x < t :=
  Nat.lt_trans (natural.before ordered pair) born

/-- **What a course has born by a stage is a stem**, a past a next element can be born with. -/
theorem born_stem (ordered : c.Ordered) {π σ : Nat → Nat} (natural : NaturalLabelling c π σ) (t : Nat) :
    Stem c (fun x => x < c.size ∧ π x < t) :=
  ⟨fun born => born.1, fun born pair =>
     ⟨Nat.lt_trans (ordered.labelled pair) (ordered.within pair), born_closed ordered natural pair born.2⟩⟩

/-- **Every stem with decided membership is what some course bears first** (Brightwell and
others' characterization of their stem sets): the down-set first is a natural labelling whose
first births, as many as the stem has elements, are exactly the stem's. -/
theorem stem_born_first {D : Nat → Prop} [∀ x, Decidable (D x)] (stem : Stem c D) :
    NaturalLabelling c (front (fun x => decide (D x)) c.size) (back (fun x => decide (D x)) c.size) ∧
      ∀ x, x < c.size →
        (front (fun x => decide (D x)) c.size x < count (fun x => decide (D x)) c.size ↔ D x) :=
  ⟨front_natural fun pair inside => decide_eq_true (stem.closed (of_decide_eq_true inside) pair),
   fun _ below => ⟨fun lt => of_decide_eq_true ((front_lt_count_iff below).mp lt),
     fun d => (front_lt_count_iff below).mpr (decide_eq_true d)⟩⟩

end Born

/-! ## Tables of a test

A test given as a proposition on the first `n` numbers has a Boolean table where each value is
decided, and with no decision its having one cannot be refuted. A table of a test closed downward
under precedence, borne first, is a natural labelling; this is how the laws below go without a
decision, or with a weak one. -/

/-- `f` tabulates `Q` on the numbers below `n`. -/
def Tabulates (f : Nat → Bool) (Q : Nat → Prop) (n : Nat) : Prop :=
  ∀ x, x < n → (f x = true ↔ Q x)

theorem table_yes {Q : Nat → Prop} {n : Nat} {f : Nat → Bool} (spec : Tabulates f Q n) (yes : Q n) :
    Tabulates (fun x => Nat.beq x n || f x) Q (n + 1) :=
  fun x below => match Nat.decEq x n with
  | .isTrue e => by
    subst e
    exact ⟨fun _ => yes, fun _ => ListTests.or_true_iff.mpr (.inl (beq_self _))⟩
  | .isFalse ne =>
    have lt := lt_of_le_ne (Nat.le_of_lt_succ below) ne
    ⟨fun h => (spec x lt).mp (match ListTests.or_true_iff.mp h with
        | .inl e => absurd (Nat.eq_of_beq_eq_true e) ne
        | .inr t => t),
     fun q => ListTests.or_true_iff.mpr (.inr ((spec x lt).mpr q))⟩

theorem table_no {Q : Nat → Prop} {n : Nat} {f : Nat → Bool} (spec : Tabulates f Q n) (no : ¬ Q n) :
    Tabulates (fun x => !(Nat.beq x n) && f x) Q (n + 1) :=
  fun x below => match Nat.decEq x n with
  | .isTrue e => by
    subst e
    exact ⟨fun h => (ListTests.bool_absurd (beq_self _)
        (ListTests.false_of_not (ListTests.and_true_iff.mp h).1)).elim,
      fun q => absurd q no⟩
  | .isFalse ne =>
    have lt := lt_of_le_ne (Nat.le_of_lt_succ below) ne
    ⟨fun h => (spec x lt).mp (ListTests.and_true_iff.mp h).2,
     fun q => ListTests.and_true_iff.mpr
       ⟨ListTests.not_eq_true_of_false (ListTests.beq_false_of_ne ne), (spec x lt).mpr q⟩⟩

/-- **Every test has a table, doubly negated.** -/
theorem table_not_not (Q : Nat → Prop) : ∀ n, ¬ ¬ ∃ f, Tabulates f Q n
  | 0 => fun no => no ⟨fun _ => false, fun _ below => absurd below (Nat.not_lt_zero _)⟩
  | n + 1 => fun no => table_not_not Q n fun ⟨_, spec⟩ =>
      not_not_decided (Q n) fun decided => match decided with
        | .inl yes => no ⟨_, table_yes spec yes⟩
        | .inr fails => no ⟨_, table_no spec fails⟩

/-- **A decided test has a table.** -/
theorem table_of {Q : Nat → Prop} (decided : ∀ x, Decided (Q x)) : ∀ n, ∃ f, Tabulates f Q n
  | 0 => ⟨fun _ => false, fun _ below => absurd below (Nat.not_lt_zero _)⟩
  | n + 1 => match table_of decided n, decided n with
    | ⟨_, spec⟩, .inl yes => ⟨_, table_yes spec yes⟩
    | ⟨_, spec⟩, .inr fails => ⟨_, table_no spec fails⟩

/-- **A table of a test closed downward gives a natural labelling**, the test's elements first. -/
theorem natural_of_table {c : Causet} (ordered : c.Ordered) {Q : Nat → Prop} {f : Nat → Bool}
    (spec : Tabulates f Q c.size) (closed : ∀ {x y}, c.prec x y → Q y → Q x) :
    NaturalLabelling c (front f c.size) (back f c.size) :=
  front_natural fun pair inside =>
    (spec _ (Nat.lt_trans (ordered.labelled pair) (ordered.within pair))).mpr
      (closed pair ((spec _ (ordered.within pair)).mp inside))

theorem table_false {b : Bool} {P : Prop} (iff : b = true ↔ P) (fails : ¬ P) : b = false :=
  match b, iff with
  | true, iff => absurd (iff.mp rfl) fails
  | false, _ => rfl

/-- The elements preceding `j`, with `j`, are closed downward. -/
theorem down_closed {c : Causet} (ordered : c.Ordered) (j : Nat) {x y : Nat} (pair : c.prec x y)
    (inside : c.prec y j ∨ y = j) : c.prec x j ∨ x = j :=
  match inside with
  | .inl p => .inl (ordered.trans pair p)
  | .inr e => .inl (Eq.subst (motive := fun k => c.prec x k) e pair)

/-- **Whether some number below `U` has `P` is weakly decided** where it is for each. -/
theorem weakly_exists_below {P : Nat → Prop} :
    ∀ {U : Nat}, (∀ t, t < U → WeaklyDecided (P t)) → WeaklyDecided (∃ t, t < U ∧ P t)
  | 0, _ => .inl fun ⟨_, below, _⟩ => absurd below (Nat.not_lt_zero _)
  | U + 1, weakly =>
    match weakly_exists_below (U := U) (fun t below => weakly t (Nat.lt_succ_of_lt below)),
        weakly U (Nat.lt_succ_self U) with
    | .inr refuted, _ => .inr fun absent => refuted fun ⟨t, below, holds⟩ =>
        absent ⟨t, Nat.lt_succ_of_lt below, holds⟩
    | _, .inr refuted => .inr fun absent => refuted fun holds => absent ⟨U, Nat.lt_succ_self U, holds⟩
    | .inl absent, .inl fails => .inl fun ⟨t, below, holds⟩ =>
        match Nat.eq_or_lt_of_le (Nat.le_of_lt_succ below) with
        | .inl e => fails (Eq.subst (motive := P) e holds)
        | .inr lt => absent ⟨t, lt, holds⟩

/-! ## Precedence is the order of birth every course agrees on -/

section Every

variable {c : Causet}

/-- The elements preceding `j`, with `j`. -/
def downTo (c : Causet) [∀ a b, Decidable (c.prec a b)] (j : Nat) (x : Nat) : Bool :=
  decide (c.prec x j ∨ x = j)

theorem downTo_closed [∀ a b, Decidable (c.prec a b)] (ordered : c.Ordered) (j : Nat) {x y : Nat}
    (pair : c.prec x y) (inside : downTo c j y = true) : downTo c j x = true :=
  decide_eq_true (down_closed ordered j pair (of_decide_eq_true inside))

theorem downTo_self [∀ a b, Decidable (c.prec a b)] (j : Nat) : downTo c j j = true :=
  decide_eq_true (.inr rfl)

theorem downTo_other [∀ a b, Decidable (c.prec a b)] {j x : Nat} (np : ¬ c.prec x j) (ne : x ≠ j) :
    downTo c j x = false :=
  decide_eq_false fun inside => inside.elim np ne

/-- **The down-set of `j` first bears `j` before everything not preceding it.** -/
theorem downTo_before [∀ a b, Decidable (c.prec a b)] (ordered : c.Ordered) {j x : Nat}
    (hj : j < c.size) (np : ¬ c.prec x j) (ne : x ≠ j) :
    NaturalLabelling c (front (downTo c j) c.size) (back (downTo c j) c.size) ∧
      front (downTo c j) c.size j < front (downTo c j) c.size x :=
  ⟨front_natural (downTo_closed ordered j), front_true_lt_false (downTo_self j) (downTo_other np ne) hj⟩

/-- **Precedence is the order of birth every course agrees on** (Szpilrajn's extension theorem in
Dushnik and Miller's intersection form, read on growth): with precedence decided, `i` precedes `j`
exactly where `i` is born before `j` in every natural labelling. -/
theorem prec_iff_every [∀ a b, Decidable (c.prec a b)] (ordered : c.Ordered) {i j : Nat}
    (hj : j < c.size) : c.prec i j ↔ ∀ π σ, NaturalLabelling c π σ → π i < π j :=
  ⟨fun pair _ _ natural => natural.before ordered pair,
   fun every => if pair : c.prec i j then pair else
     match Nat.decEq i j with
     | .isTrue same =>
       absurd (every _ _ (natural_identity c)) (Eq.subst (motive := fun k => ¬ i < k) same (Nat.lt_irrefl i))
     | .isFalse ne =>
       match downTo_before ordered hj pair ne with
       | ⟨natural, lt⟩ => absurd (every _ _ natural) (Nat.lt_asymm lt)⟩

/-- **What is born no later than an element on every course is its past, itself included**: with
precedence decided, `y` is born no later than `x` in every natural labelling exactly where `y` is
`x` or precedes it. -/
theorem past_every_iff [∀ a b, Decidable (c.prec a b)] (ordered : c.Ordered) {x y : Nat}
    (hx : x < c.size) (hy : y < c.size) :
    (∀ π σ, NaturalLabelling c π σ → π y ≤ π x) ↔ y = x ∨ c.prec y x :=
  ⟨fun every => match Nat.decEq y x with
     | .isTrue same => .inl same
     | .isFalse ne => .inr ((prec_iff_every ordered hx).mpr fun π σ natural =>
         match Nat.eq_or_lt_of_le (every π σ natural) with
         | .inl same => absurd (((natural.at hy).2.symm.trans (congrArg σ same)).trans (natural.at hx).2) ne
         | .inr lt => lt),
   fun h π _ natural => match h with
     | .inl same => Nat.le_of_eq (congrArg π same)
     | .inr pair => Nat.le_of_lt (natural.before ordered pair)⟩

/-- **The past is the largest relation every course respects** (the relation Stein's theorem
singles out, here as a maximum and not by uniqueness under invariance): with precedence decided, a
relation each of whose pairs every natural labelling bears with the second born no later than the
first relates an element only to itself and to what precedes it, and the past is such a relation
(`past_every_iff`). -/
theorem past_largest [∀ a b, Decidable (c.prec a b)] (ordered : c.Ordered) (R : Nat → Nat → Prop)
    (respected : ∀ x y, R x y → ∀ π σ, NaturalLabelling c π σ → π y ≤ π x) {x y : Nat}
    (hx : x < c.size) (hy : y < c.size) (pair : R x y) : y = x ∨ c.prec y x :=
  (past_every_iff ordered hx hy).mp (respected x y pair)

/-- **Born before on every course, precedence is not refuted**, with no decision: bearing first a
table of the elements at or below `j`, doubly negated. -/
theorem every_not_not (ordered : c.Ordered) {i j : Nat} (hi : i < c.size) (hj : j < c.size)
    (every : ∀ π σ, NaturalLabelling c π σ → π i < π j) : ¬ ¬ c.prec i j :=
  fun np => match Nat.decEq i j with
  | .isTrue same =>
    Nat.lt_irrefl i (Eq.subst (motive := fun k => i < k) same.symm (every _ _ (natural_identity c)))
  | .isFalse ne => table_not_not (fun x => c.prec x j ∨ x = j) c.size fun ⟨_, spec⟩ =>
    Nat.lt_asymm (every _ _ (natural_of_table ordered spec (down_closed ordered j)))
      (front_true_lt_false ((spec j hj).mpr (.inr rfl))
        (table_false (spec i hi) fun inside => inside.elim np ne) hj)

/-- **So born before on every course is exactly precedence not refuted**, with no decision. -/
theorem every_iff_not_not (ordered : c.Ordered) {i j : Nat} (hi : i < c.size) (hj : j < c.size) :
    (∀ π σ, NaturalLabelling c π σ → π i < π j) ↔ ¬ ¬ c.prec i j :=
  ⟨every_not_not ordered hi hj, fun nn π _ natural => match Nat.lt_or_ge (π i) (π j) with
    | .inl lt => lt
    | .inr ge => (nn fun pair => Nat.not_le_of_lt (natural.before ordered pair) ge).elim⟩

/-- With precedence weakly decided, an element is born before another on some course wherever they
differ and the other does not precede it: bearing first everything not refuted to lie at or above
the other. -/
theorem before_of_weakly (weakly : ∀ a b, WeaklyDecided (c.prec a b)) (ordered : c.Ordered)
    {x y : Nat} (hx : x < c.size) (hy : y < c.size) (ne : x ≠ y) (np : ¬ c.prec y x) :
    ∃ π σ, NaturalLabelling c π σ ∧ π x < π y :=
  match table_of (Q := fun z => ¬ (z = y ∨ c.prec y z)) (fun z => match Nat.decEq z y with
      | .isTrue e => .inr fun outside => outside (.inl e)
      | .isFalse ne' => match weakly y z with
        | .inl fails => .inl fun inside => inside.elim ne' fails
        | .inr unrefuted => .inr fun outside => unrefuted fun holds => outside (.inr holds)) c.size with
  | ⟨_, spec⟩ =>
    ⟨_, _, natural_of_table ordered spec fun {_ b} pair outside inside => outside (match inside with
        | .inl e => .inr (Eq.subst (motive := fun w => c.prec w b) e pair)
        | .inr p => .inr (ordered.trans p pair)),
     front_true_lt_false ((spec x hx).mpr fun inside => inside.elim ne np)
       (table_false (spec y hy) fun outside => outside (.inl rfl)) hx⟩

/-- **Born before on some course**: with precedence weakly decided, `i` is born before `j` on some
course exactly where they differ and `j` does not precede `i`. -/
theorem before_some_iff (weakly : ∀ a b, WeaklyDecided (c.prec a b)) (ordered : c.Ordered)
    {i j : Nat} (hi : i < c.size) (hj : j < c.size) :
    (∃ π σ, NaturalLabelling c π σ ∧ π i < π j) ↔ i ≠ j ∧ ¬ c.prec j i :=
  ⟨fun ⟨π, _, natural, lt⟩ =>
     ⟨fun same => Nat.lt_irrefl _ (Eq.subst (motive := fun k => π i < π k) same.symm lt),
      fun pair => Nat.lt_asymm lt (natural.before ordered pair)⟩,
   fun ⟨ne, np⟩ => before_of_weakly weakly ordered hi hj ne np⟩

/-- **No order of birth of unrelated elements is common to all courses**: with precedence weakly
decided, two different elements neither of which precedes the other are born in either order, each
on some course. -/
theorem either_order (weakly : ∀ a b, WeaklyDecided (c.prec a b)) (ordered : c.Ordered) {x y : Nat}
    (hx : x < c.size) (hy : y < c.size) (nxy : ¬ c.prec x y) (nyx : ¬ c.prec y x) (ne : x ≠ y) :
    (∃ π σ, NaturalLabelling c π σ ∧ π x < π y) ∧ (∃ π σ, NaturalLabelling c π σ ∧ π y < π x) :=
  ⟨before_of_weakly weakly ordered hx hy ne nyx,
   before_of_weakly weakly ordered hy hx (fun e => ne e.symm) nxy⟩

/-- Two elements, the first preceding the second exactly where `P`. -/
def pairIf (P : Prop) : Causet := ⟨2, fun a b => a = 0 ∧ b = 1 ∧ P⟩

theorem pairIf_ordered (P : Prop) : (pairIf P).Ordered where
  trans := fun first second => match first, second with
    | ⟨_, b1, _⟩, ⟨b0, _, _⟩ => absurd (b1.symm.trans b0) (by decide)
  labelled := fun pair => match pair with
    | ⟨a0, b1, _⟩ => by subst a0; subst b1; decide
  within := fun pair => match pair with
    | ⟨_, b1, _⟩ => by subst b1; exact (show 1 < 2 by decide)

/-- **Without the decision, the law removes double negation**: if, on every causal set, being born
first on every course gave precedence, every proposition not refuted would hold, already on two
elements whose one precedence is a proposition. -/
theorem every_needs_decision
    (law : ∀ c : Causet, c.Ordered → ∀ i j, i < c.size → j < c.size →
      (∀ π σ, NaturalLabelling c π σ → π i < π j) → c.prec i j) :
    ∀ P : Prop, ¬ ¬ P → P :=
  fun P nn =>
    have every : ∀ π σ, NaturalLabelling (pairIf P) π σ → π 0 < π 1 := fun π σ natural =>
      match Nat.lt_or_ge (π 0) (π 1) with
      | .inl lt => lt
      | .inr ge =>
        have a0 := natural.at (i := 0) (show 0 < 2 by decide)
        have a1 := natural.at (i := 1) (show 1 < 2 by decide)
        match Nat.eq_or_lt_of_le ge with
        | .inl same =>
          absurd ((a1.2.symm.trans (congrArg σ same)).trans a0.2) (by decide)
        | .inr lt => (nn fun p => Nat.lt_asymm lt (natural.before (pairIf_ordered P) ⟨rfl, rfl, p⟩)).elim
    match law (pairIf P) (pairIf_ordered P) 0 1 (show 0 < 2 by decide) (show 1 < 2 by decide) every with
    | ⟨_, _, p⟩ => p

/-- **Asked of every causal set, born before on every course gives precedence exactly under
excluded middle.** For the unfolding: agreement across all courses settles that one element
conditions another only up to double negation (`every_iff_not_not`); asserting that it does is
deciding whether it does. -/
theorem every_iff_em :
    (∀ c : Causet, c.Ordered → ∀ i j, i < c.size → j < c.size →
      (∀ π σ, NaturalLabelling c π σ → π i < π j) → c.prec i j) ↔ ∀ p : Prop, Decided p :=
  ⟨fun law p => every_needs_decision law _ (not_not_decided p),
   fun em _ ordered _ _ hi hj every => (em _).of_not_not (every_not_not ordered hi hj every)⟩

/-- **`past_every_iff` from left to right, asked of every causal set, gives excluded middle too**:
it gives the law of `prec_iff_every`. -/
theorem past_every_needs_decision
    (law : ∀ c : Causet, c.Ordered → ∀ x y, x < c.size → y < c.size →
      (∀ π σ, NaturalLabelling c π σ → π y ≤ π x) → y = x ∨ c.prec y x) :
    ∀ p : Prop, Decided p :=
  every_iff_em.mp fun c ordered i j hi hj every =>
    match law c ordered j i hj hi fun π σ natural => Nat.le_of_lt (every π σ natural) with
    | .inl same => absurd (every _ _ (natural_identity c))
        (Eq.subst (motive := fun k => ¬ k < j) same.symm (Nat.lt_irrefl j))
    | .inr pair => pair

/-- **`past_every_iff` from left to right, asked of every causal set, is exactly excluded
middle.** -/
theorem past_every_iff_em :
    (∀ c : Causet, c.Ordered → ∀ x y, x < c.size → y < c.size →
      (∀ π σ, NaturalLabelling c π σ → π y ≤ π x) → y = x ∨ c.prec y x) ↔ ∀ p : Prop, Decided p :=
  ⟨past_every_needs_decision,
   fun em c ordered x y hx hy every => match Nat.decEq y x with
   | .isTrue same => .inl same
   | .isFalse ne => .inr (every_iff_em.mpr em c ordered y x hy hx fun π σ natural =>
       match Nat.eq_or_lt_of_le (every π σ natural) with
       | .inl same =>
         absurd (((natural.at hy).2.symm.trans (congrArg σ same)).trans (natural.at hx).2) ne
       | .inr lt => lt)⟩

/-- **De Morgan's law for a conjunction gives weak excluded middle.** -/
theorem weakly_of_deMorgan (deMorgan : ∀ p q : Prop, ¬ (p ∧ q) → ¬ p ∨ ¬ q) :
    ∀ p : Prop, WeaklyDecided p :=
  fun p => deMorgan p (¬ p) fun ⟨holds, fails⟩ => fails holds

/-- Three elements: `0` below `1` exactly where `p`, `1` below `2` exactly where `q`, and `0`
below `2` exactly where both. -/
def middleIf (p q : Prop) : Causet :=
  ⟨3, fun a b => (a = 0 ∧ b = 1 ∧ p) ∨ (a = 1 ∧ b = 2 ∧ q) ∨ (a = 0 ∧ b = 2 ∧ p ∧ q)⟩

theorem middleIf_ordered (p q : Prop) : (middleIf p q).Ordered where
  trans := fun first second => match first, second with
    | .inl ⟨a0, _, hp⟩, .inr (.inl ⟨_, c2, hq⟩) => .inr (.inr ⟨a0, c2, hp, hq⟩)
    | .inl ⟨_, b1, _⟩, .inl ⟨b0, _⟩ => absurd (b1.symm.trans b0) (by decide)
    | .inl ⟨_, b1, _⟩, .inr (.inr ⟨b0, _⟩) => absurd (b1.symm.trans b0) (by decide)
    | .inr (.inl ⟨_, b2, _⟩), .inl ⟨b0, _⟩ => absurd (b2.symm.trans b0) (by decide)
    | .inr (.inl ⟨_, b2, _⟩), .inr (.inl ⟨b1, _⟩) => absurd (b2.symm.trans b1) (by decide)
    | .inr (.inl ⟨_, b2, _⟩), .inr (.inr ⟨b0, _⟩) => absurd (b2.symm.trans b0) (by decide)
    | .inr (.inr ⟨_, b2, _⟩), .inl ⟨b0, _⟩ => absurd (b2.symm.trans b0) (by decide)
    | .inr (.inr ⟨_, b2, _⟩), .inr (.inl ⟨b1, _⟩) => absurd (b2.symm.trans b1) (by decide)
    | .inr (.inr ⟨_, b2, _⟩), .inr (.inr ⟨b0, _⟩) => absurd (b2.symm.trans b0) (by decide)
  labelled := fun pair => match pair with
    | .inl ⟨a0, b1, _⟩ => by subst a0; subst b1; decide
    | .inr (.inl ⟨a1, b2, _⟩) => by subst a1; subst b2; decide
    | .inr (.inr ⟨a0, b2, _⟩) => by subst a0; subst b2; decide
  within := fun pair => match pair with
    | .inl ⟨_, b1, _⟩ => by subst b1; exact (show 1 < 3 by decide)
    | .inr (.inl ⟨_, b2, _⟩) => by subst b2; exact (show 2 < 3 by decide)
    | .inr (.inr ⟨_, b2, _⟩) => by subst b2; exact (show 2 < 3 by decide)

theorem middleIf_not_two_zero (p q : Prop) : ¬ (middleIf p q).prec 2 0 :=
  fun pair => match pair with
  | .inl ⟨h, _⟩ => absurd h (by decide)
  | .inr (.inl ⟨h, _⟩) => absurd h (by decide)
  | .inr (.inr ⟨h, _⟩) => absurd h (by decide)

theorem middleIf_not_zero_two {p q : Prop} (neither : ¬ (p ∧ q)) : ¬ (middleIf p q).prec 0 2 :=
  fun pair => match pair with
  | .inl ⟨_, h, _⟩ => absurd h (by decide)
  | .inr (.inl ⟨h, _⟩) => absurd h (by decide)
  | .inr (.inr ⟨_, _, both⟩) => neither both

/-- **`either_order`, asked of every causal set, gives De Morgan's law**: on `middleIf p q`, with
`p ∧ q` refuted, `2` and `0` are unrelated, and a course bearing `2` before `0` refutes `p` or `q`
by where it bears `1`. -/
theorem either_order_deMorgan
    (law : ∀ c : Causet, c.Ordered → ∀ x y, x < c.size → y < c.size → ¬ c.prec x y → ¬ c.prec y x →
      x ≠ y → (∃ π σ, NaturalLabelling c π σ ∧ π x < π y) ∧
        (∃ π σ, NaturalLabelling c π σ ∧ π y < π x)) :
    ∀ p q : Prop, ¬ (p ∧ q) → ¬ p ∨ ¬ q :=
  fun p q neither =>
    have ordered := middleIf_ordered p q
    match (law (middleIf p q) ordered 2 0 (show 2 < 3 by decide) (show 0 < 3 by decide)
        (middleIf_not_two_zero p q) (middleIf_not_zero_two neither) (by decide)).1 with
    | ⟨π, _, natural, lt⟩ => match Nat.lt_or_ge (π 1) (π 0) with
      | .inl lt' => .inl fun hp => Nat.lt_asymm lt' (natural.before ordered (.inl ⟨rfl, rfl, hp⟩))
      | .inr ge => .inr fun hq =>
        Nat.lt_asymm (Nat.lt_of_lt_of_le lt ge) (natural.before ordered (.inr (.inl ⟨rfl, rfl, hq⟩)))

/-- **`either_order`, asked of every causal set, is exactly weak excluded middle.** For the
unfolding: finding courses that bear two unrelated elements in either order is deciding, for each
pair, only whether its precedence fails. -/
theorem either_order_iff_weakly :
    (∀ c : Causet, c.Ordered → ∀ x y, x < c.size → y < c.size → ¬ c.prec x y → ¬ c.prec y x →
      x ≠ y → (∃ π σ, NaturalLabelling c π σ ∧ π x < π y) ∧
        (∃ π σ, NaturalLabelling c π σ ∧ π y < π x)) ↔
    ∀ p : Prop, WeaklyDecided p :=
  ⟨fun law => weakly_of_deMorgan (either_order_deMorgan law),
   fun weakly _ ordered _ _ hx hy nxy nyx ne => either_order (fun _ _ => weakly _) ordered hx hy nxy nyx ne⟩

/-- **`before_some_iff` from right to left, asked of every causal set, is exactly weak excluded
middle.** -/
theorem before_some_iff_weakly :
    (∀ c : Causet, c.Ordered → ∀ i j, i < c.size → j < c.size → i ≠ j → ¬ c.prec j i →
      ∃ π σ, NaturalLabelling c π σ ∧ π i < π j) ↔ ∀ p : Prop, WeaklyDecided p :=
  ⟨fun law => either_order_iff_weakly.mp fun c ordered x y hx hy nxy nyx ne =>
     ⟨law c ordered x y hx hy ne nyx, law c ordered y x hy hx (fun e => ne e.symm) nxy⟩,
   fun weakly _ ordered _ _ hi hj ne np => before_of_weakly (fun _ _ => weakly _) ordered hi hj ne np⟩

end Every

/-! ## The present at a stage -/

/-- What a labelling has born by stage `t`, with the precedence among it: the configuration a
course has grown after `t` births. -/
def bornBy (c : Causet) (π : Nat → Nat) (t : Nat) : «际» Nat := fun x y => c.prec x y ∧ π y < t

/-- `x` is **maximal among what `π` has born by stage `t`**: an element born by then, and nothing
it precedes is. Read as `x` being in the present at that stage. -/
def MaximalBorn (c : Causet) (π : Nat → Nat) (t x : Nat) : Prop :=
  x < c.size ∧ π x < t ∧ ∀ k, c.prec x k → t ≤ π k

/-- **The present is where the grammar's ending holds on what is born**: `x` is maximal among what
is born by stage `t` exactly where it is born by then and, read on what is born by then, ends under
the one class (`«亡»` under `«一»`). -/
theorem maximalBorn_iff_ends (c : Causet) (π : Nat → Nat) (t x : Nat) :
    MaximalBorn c π t x ↔ x < c.size ∧ π x < t ∧ «亡» (bornBy c π t) «一» x :=
  ⟨fun ⟨hx, born, after⟩ => ⟨hx, born, fun ⟨y, ⟨pair, lt⟩, _⟩ =>
      Nat.lt_irrefl _ (Nat.lt_of_le_of_lt (after y pair) lt)⟩,
   fun ⟨hx, born, ends⟩ => ⟨hx, born, fun k pair => match Nat.lt_or_ge (π k) t with
      | .inl lt => (ends ⟨k, ⟨pair, lt⟩, trivial⟩).elim
      | .inr ge => ge⟩⟩

/-- **The present at a stage is an antichain**: of two elements maximal among what is born by one
stage, neither precedes the other. -/
theorem maximalBorn_unrelated {c : Causet} {π : Nat → Nat} {t x y : Nat} (fx : MaximalBorn c π t x)
    (fy : MaximalBorn c π t y) : ¬ c.prec x y :=
  fun pair => Nat.lt_irrefl _ (Nat.lt_of_lt_of_le fy.2.1 (fx.2.2 y pair))

/-- **The present of a stem**: on the course bearing first what a test passes, after as many births
as pass, the present is exactly the passing elements that precede nothing passing. -/
theorem maximalBorn_front {c : Causet} (ordered : c.Ordered) (d : Nat → Bool) {x : Nat} :
    MaximalBorn c (front d c.size) (count d c.size) x ↔
      x < c.size ∧ d x = true ∧ ∀ k, c.prec x k → d k = false :=
  ⟨fun ⟨hx, born, after⟩ => ⟨hx, (front_lt_count_iff hx).mp born, fun k pair =>
      match h : d k with
      | true =>
        absurd ((front_lt_count_iff (ordered.within pair)).mpr h) (Nat.not_lt_of_le (after k pair))
      | false => rfl⟩,
   fun ⟨hx, passes, top⟩ => ⟨hx, (front_lt_count_iff hx).mpr passes, fun k pair =>
      match Nat.lt_or_ge (front d c.size k) (count d c.size) with
      | .inl lt => (ListTests.bool_absurd ((front_lt_count_iff (ordered.within pair)).mp lt) (top k pair)).elim
      | .inr ge => ge⟩⟩

section Antichains

variable {c : Causet}

/-- With precedence weakly decided and what a test passes inside the causal set, whether something
passing lies at or above `z` is weakly decided. -/
theorem weakly_above (weakly : ∀ a b, WeaklyDecided (c.prec a b)) (q : Nat → Bool)
    (inside : ∀ {x}, q x = true → x < c.size) (z : Nat) :
    WeaklyDecided (∃ y, q y = true ∧ (z = y ∨ c.prec z y)) :=
  have each : ∀ y, y < c.size → WeaklyDecided (q y = true ∧ (z = y ∨ c.prec z y)) := fun y _ =>
    match LLPO.decided_true (q y), Nat.decEq z y, weakly z y with
    | .inr fails, _, _ => .inl fun both => fails both.1
    | .inl passes, .isTrue e, _ => .inr fun absent => absent ⟨passes, .inl e⟩
    | .inl _, .isFalse ne, .inl fails => .inl fun both => both.2.elim ne fails
    | .inl passes, .isFalse _, .inr unrefuted =>
      .inr fun absent => unrefuted fun holds => absent ⟨passes, .inr holds⟩
  match weakly_exists_below (P := fun y => q y = true ∧ (z = y ∨ c.prec z y)) each with
  | .inl absent => .inl fun ⟨y, passes, at_or_above⟩ => absent ⟨y, inside passes, passes, at_or_above⟩
  | .inr unrefuted =>
    .inr fun absent => unrefuted fun ⟨y, _, passes, at_or_above⟩ => absent ⟨y, passes, at_or_above⟩

/-- **Every antichain is a present**: with precedence weakly decided, the elements a test passes,
none preceding another, are exactly the present of some course at some stage, the course bearing
first the elements not refuted to lie at or below them. -/
theorem antichain_present (weakly : ∀ a b, WeaklyDecided (c.prec a b)) (ordered : c.Ordered)
    (q : Nat → Bool) (inside : ∀ {x}, q x = true → x < c.size)
    (apart : ∀ {x y}, q x = true → q y = true → ¬ c.prec x y) :
    ∃ π σ t, NaturalLabelling c π σ ∧ ∀ x, MaximalBorn c π t x ↔ q x = true :=
  match table_of (Q := fun z => ¬ ¬ ∃ y, q y = true ∧ (z = y ∨ c.prec z y))
      (fun z => match weakly_above weakly q inside z with
        | .inl absent => .inr fun unrefuted => unrefuted absent
        | .inr unrefuted => .inl unrefuted) c.size with
  | ⟨f, spec⟩ =>
    ⟨_, _, _, natural_of_table ordered spec fun {a _} pair unrefuted no => unrefuted fun ⟨y, qy, hb⟩ =>
        no ⟨y, qy, .inr (match hb with
          | .inl e => Eq.subst (motive := fun w => c.prec a w) e pair
          | .inr p => ordered.trans pair p)⟩,
     fun x => ⟨fun present => match (maximalBorn_front ordered f).mp present with
        | ⟨hx, fx, top⟩ => match h : q x with
          | true => rfl
          | false => (((spec x hx).mp fx) fun ⟨y, qy, hxy⟩ => match hxy with
            | .inl e => ListTests.bool_absurd (Eq.subst (motive := fun w => q w = true) e.symm qy) h
            | .inr p => ListTests.bool_absurd ((spec y (ordered.within p)).mpr fun no => no ⟨y, qy, .inl rfl⟩)
                (top y p)).elim,
      fun qx => (maximalBorn_front ordered f).mpr
        ⟨inside qx, (spec x (inside qx)).mpr fun no => no ⟨x, qx, .inl rfl⟩,
         fun k pair => table_false (spec k (ordered.within pair)) fun unrefuted =>
           unrefuted fun ⟨_, qy, hky⟩ => match hky with
             | .inl e => apart qx qy (Eq.subst (motive := fun w => c.prec x w) e pair)
             | .inr p => apart qx qy (ordered.trans pair p)⟩⟩⟩

/-- **Present together on some course exactly where unrelated**: with precedence weakly decided,
two elements are in the present at some stage of some course exactly where neither precedes the
other; the course bears first everything not refuted to lie above either. -/
theorem together_some_iff (weakly : ∀ a b, WeaklyDecided (c.prec a b)) (ordered : c.Ordered)
    {x y : Nat} :
    (∃ π σ t, NaturalLabelling c π σ ∧ MaximalBorn c π t x ∧ MaximalBorn c π t y) ↔
      x < c.size ∧ y < c.size ∧ ¬ c.prec x y ∧ ¬ c.prec y x :=
  ⟨fun ⟨_, _, _, _, fx, fy⟩ =>
     ⟨fx.1, fy.1, maximalBorn_unrelated fx fy, maximalBorn_unrelated fy fx⟩,
   fun ⟨hx, hy, nxy, nyx⟩ =>
     match table_of (Q := fun z => ¬ (c.prec x z ∨ c.prec y z)) (fun z => match weakly x z, weakly y z with
         | .inl nx, .inl ny => .inl fun inside => inside.elim nx ny
         | .inr unrefuted, _ => .inr fun outside => unrefuted fun holds => outside (.inl holds)
         | _, .inr unrefuted => .inr fun outside => unrefuted fun holds => outside (.inr holds)) c.size with
     | ⟨f, spec⟩ =>
       have passes : ∀ {z}, z < c.size → ¬ c.prec x z → ¬ c.prec y z → f z = true :=
         fun hz nx ny => (spec _ hz).mpr fun inside => inside.elim nx ny
       ⟨_, _, _, natural_of_table ordered spec fun pair outside inside => outside (match inside with
           | .inl p => .inl (ordered.trans p pair)
           | .inr p => .inr (ordered.trans p pair)),
        (maximalBorn_front ordered f).mpr ⟨hx, passes hx (ordered.irrefl x) nyx, fun k pair =>
          table_false (spec k (ordered.within pair)) fun outside => outside (.inl pair)⟩,
        (maximalBorn_front ordered f).mpr ⟨hy, passes hy nxy (ordered.irrefl y), fun k pair =>
          table_false (spec k (ordered.within pair)) fun outside => outside (.inr pair)⟩⟩⟩

/-- What two elements present together on every course share: with precedence decided, whatever
the first precedes, the second does. -/
theorem future_of_together_every [∀ a b, Decidable (c.prec a b)] (ordered : c.Ordered) {x y : Nat}
    (every : ∀ π σ, NaturalLabelling c π σ → ∃ t, MaximalBorn c π t x ∧ MaximalBorn c π t y)
    {k : Nat} (first : c.prec x k) : c.prec y k :=
  if later : c.prec y k then later else
    match every _ _ (natural_identity c) with
    | ⟨_, fx, fy⟩ =>
      have ne : y ≠ k := fun e =>
        maximalBorn_unrelated fx fy (Eq.subst (motive := fun z => c.prec x z) e.symm first)
      match downTo_before ordered (ordered.within first) later ne with
      | ⟨natural, lt⟩ => match every _ _ natural with
        | ⟨t, ⟨_, _, after⟩, ⟨_, born, _⟩⟩ =>
          absurd (Nat.lt_of_le_of_lt (after k first) (Nat.lt_trans lt born)) (Nat.lt_irrefl t)

/-- **Present together on every course exactly where they have the same future**: with precedence
decided, two elements are in the present at some stage of every course exactly where each precedes
what the other does. -/
theorem together_every_iff [∀ a b, Decidable (c.prec a b)] (ordered : c.Ordered) {x y : Nat}
    (hx : x < c.size) (hy : y < c.size) :
    (∀ π σ, NaturalLabelling c π σ → ∃ t, MaximalBorn c π t x ∧ MaximalBorn c π t y) ↔
      ∀ k, c.prec x k ↔ c.prec y k :=
  ⟨fun every _ => ⟨future_of_together_every ordered every,
     future_of_together_every ordered fun π σ natural => match every π σ natural with
       | ⟨t, fx, fy⟩ => ⟨t, fy, fx⟩⟩,
   fun same π _ natural => match Nat.lt_or_ge (π x) (π y) with
     | .inl lt => ⟨π y + 1,
         ⟨hx, Nat.lt_succ_of_lt lt, fun k pair => Nat.succ_le_of_lt (natural.before ordered ((same k).mp pair))⟩,
         ⟨hy, Nat.lt_succ_self _, fun _ pair => Nat.succ_le_of_lt (natural.before ordered pair)⟩⟩
     | .inr ge => ⟨π x + 1,
         ⟨hx, Nat.lt_succ_self _, fun _ pair => Nat.succ_le_of_lt (natural.before ordered pair)⟩,
         ⟨hy, Nat.lt_succ_of_le ge, fun k pair => Nat.succ_le_of_lt (natural.before ordered ((same k).mpr pair))⟩⟩⟩

/-- With no decision, of two elements present together on every course, whatever the first
precedes the second precedes too, doubly negated. -/
theorem together_not_not (ordered : c.Ordered) {x y : Nat}
    (every : ∀ π σ, NaturalLabelling c π σ → ∃ t, MaximalBorn c π t x ∧ MaximalBorn c π t y)
    {k : Nat} (first : c.prec x k) : ¬ ¬ c.prec y k :=
  fun later => match every _ _ (natural_identity c) with
  | ⟨_, fx, fy⟩ =>
    have ne : y ≠ k := fun e =>
      maximalBorn_unrelated fx fy (Eq.subst (motive := fun z => c.prec x z) e.symm first)
    table_not_not (fun z => c.prec z k ∨ z = k) c.size fun ⟨_, spec⟩ =>
      match every _ _ (natural_of_table ordered spec (down_closed ordered k)) with
      | ⟨t, ⟨_, _, after⟩, ⟨_, born, _⟩⟩ =>
        Nat.lt_irrefl t (Nat.lt_of_le_of_lt (after k first)
          (Nat.lt_trans (front_true_lt_false ((spec k (ordered.within first)).mpr (.inr rfl))
            (table_false (spec y fy.1) fun inside => inside.elim later ne) (ordered.within first)) born))

/-- **So present together on every course is exactly the same future doubly negated**, with no
decision. -/
theorem together_every_iff_not_not (ordered : c.Ordered) {x y : Nat} (hx : x < c.size)
    (hy : y < c.size) :
    (∀ π σ, NaturalLabelling c π σ → ∃ t, MaximalBorn c π t x ∧ MaximalBorn c π t y) ↔
      ∀ k, (c.prec x k → ¬ ¬ c.prec y k) ∧ (c.prec y k → ¬ ¬ c.prec x k) :=
  ⟨fun every _ => ⟨together_not_not ordered every,
     together_not_not ordered fun π σ natural => match every π σ natural with
       | ⟨t, fx, fy⟩ => ⟨t, fy, fx⟩⟩,
   fun same π _ natural =>
     have after : ∀ {a b k}, (c.prec a k → ¬ ¬ c.prec b k) → c.prec a k → π b < π k :=
       fun {_ b k} imp pair => match Nat.lt_or_ge (π b) (π k) with
         | .inl lt => lt
         | .inr ge => (imp pair fun later => Nat.not_le_of_lt (natural.before ordered later) ge).elim
     match Nat.lt_or_ge (π x) (π y) with
     | .inl lt => ⟨π y + 1,
         ⟨hx, Nat.lt_succ_of_lt lt, fun k pair => Nat.succ_le_of_lt (after (same k).1 pair)⟩,
         ⟨hy, Nat.lt_succ_self _, fun _ pair => Nat.succ_le_of_lt (natural.before ordered pair)⟩⟩
     | .inr ge => ⟨π x + 1,
         ⟨hx, Nat.lt_succ_self _, fun _ pair => Nat.succ_le_of_lt (natural.before ordered pair)⟩,
         ⟨hy, Nat.lt_succ_of_le ge, fun k pair => Nat.succ_le_of_lt (after (same k).2 pair)⟩⟩⟩

end Antichains

/-- Three elements: `0` below `2`, and `1` below `2` exactly where `p`. -/
def apartIf (p : Prop) : Causet := ⟨3, fun a b => (a = 0 ∧ b = 2) ∨ (a = 1 ∧ b = 2 ∧ p)⟩

theorem apartIf_ordered (p : Prop) : (apartIf p).Ordered where
  trans := fun first second => match first, second with
    | .inl ⟨_, b2⟩, .inl ⟨b0, _⟩ => absurd (b2.symm.trans b0) (by decide)
    | .inl ⟨_, b2⟩, .inr ⟨b1, _, _⟩ => absurd (b2.symm.trans b1) (by decide)
    | .inr ⟨_, b2, _⟩, .inl ⟨b0, _⟩ => absurd (b2.symm.trans b0) (by decide)
    | .inr ⟨_, b2, _⟩, .inr ⟨b1, _, _⟩ => absurd (b2.symm.trans b1) (by decide)
  labelled := fun pair => match pair with
    | .inl ⟨a0, b2⟩ => by subst a0; subst b2; decide
    | .inr ⟨a1, b2, _⟩ => by subst a1; subst b2; decide
  within := fun pair => match pair with
    | .inl ⟨_, b2⟩ => by subst b2; exact (show 2 < 3 by decide)
    | .inr ⟨_, b2, _⟩ => by subst b2; exact (show 2 < 3 by decide)

/-- **`together_every_iff` from left to right, asked of every causal set, removes double
negation**: on `apartIf p`, `0` and `1` are present together on every course wherever `p` is not
refuted, and the law then gives that `1` precedes `2`. -/
theorem together_every_needs_decision
    (law : ∀ c : Causet, c.Ordered → ∀ x y, x < c.size → y < c.size →
      (∀ π σ, NaturalLabelling c π σ → ∃ t, MaximalBorn c π t x ∧ MaximalBorn c π t y) →
      ∀ k, c.prec x k → c.prec y k) :
    ∀ p : Prop, ¬ ¬ p → p :=
  fun p nn =>
    have ordered := apartIf_ordered p
    have every : ∀ π σ, NaturalLabelling (apartIf p) π σ →
        ∃ t, MaximalBorn (apartIf p) π t 0 ∧ MaximalBorn (apartIf p) π t 1 := fun π σ natural =>
      have a1 := natural.at (i := 1) (show 1 < 3 by decide)
      have a2 := natural.at (i := 2) (show 2 < 3 by decide)
      have l02 : π 0 < π 2 := natural.before ordered (.inl ⟨rfl, rfl⟩)
      have l12 : π 1 < π 2 := match Nat.lt_or_ge (π 1) (π 2) with
        | .inl lt => lt
        | .inr ge => match Nat.eq_or_lt_of_le ge with
          | .inl same => absurd ((a2.2.symm.trans (congrArg σ same)).trans a1.2) (by decide)
          | .inr lt => (nn fun hp => Nat.lt_asymm lt (natural.before ordered (.inr ⟨rfl, rfl, hp⟩))).elim
      have both : ∀ t, π 0 < t → π 1 < t → t ≤ π 2 →
          MaximalBorn (apartIf p) π t 0 ∧ MaximalBorn (apartIf p) π t 1 := fun t b0 b1 le2 =>
        ⟨⟨show 0 < 3 by decide, b0, fun k pair => match pair with
            | .inl ⟨_, k2⟩ => Eq.subst (motive := fun z => t ≤ π z) k2.symm le2
            | .inr ⟨h, _, _⟩ => absurd h (by decide)⟩,
         ⟨show 1 < 3 by decide, b1, fun k pair => match pair with
            | .inl ⟨h, _⟩ => absurd h (by decide)
            | .inr ⟨_, k2, _⟩ => Eq.subst (motive := fun z => t ≤ π z) k2.symm le2⟩⟩
      match Nat.lt_or_ge (π 0) (π 1) with
      | .inl lt => ⟨π 1 + 1, both _ (Nat.lt_succ_of_lt lt) (Nat.lt_succ_self _) (Nat.succ_le_of_lt l12)⟩
      | .inr ge => ⟨π 0 + 1, both _ (Nat.lt_succ_self _) (Nat.lt_succ_of_le ge) (Nat.succ_le_of_lt l02)⟩
    match law (apartIf p) ordered 0 1 (show 0 < 3 by decide) (show 1 < 3 by decide) every 2
        (.inl ⟨rfl, rfl⟩) with
    | .inl ⟨h, _⟩ => absurd h (by decide)
    | .inr ⟨_, _, hp⟩ => hp

/-- **`together_every_iff` from left to right, asked of every causal set, is exactly excluded
middle.** For the unfolding: that two elements are present together on every course settles their
having the same future only up to double negation (`together_every_iff_not_not`); asserting it is
deciding. -/
theorem together_every_iff_em :
    (∀ c : Causet, c.Ordered → ∀ x y, x < c.size → y < c.size →
      (∀ π σ, NaturalLabelling c π σ → ∃ t, MaximalBorn c π t x ∧ MaximalBorn c π t y) →
      ∀ k, c.prec x k → c.prec y k) ↔ ∀ p : Prop, Decided p :=
  ⟨fun law p => together_every_needs_decision law _ (not_not_decided p),
   fun em _ ordered _ _ _ _ every _ first => (em _).of_not_not (together_not_not ordered every first)⟩

/-- **`together_some_iff` from right to left, asked of every causal set, gives De Morgan's law**: on
`middleIf p q`, a stage with `0` and `2` both in the present refutes `p` or `q` by whether `1` is
born by then. -/
theorem together_some_deMorgan
    (law : ∀ c : Causet, c.Ordered → ∀ x y, x < c.size → y < c.size → ¬ c.prec x y → ¬ c.prec y x →
      ∃ π σ t, NaturalLabelling c π σ ∧ MaximalBorn c π t x ∧ MaximalBorn c π t y) :
    ∀ p q : Prop, ¬ (p ∧ q) → ¬ p ∨ ¬ q :=
  fun p q neither =>
    have ordered := middleIf_ordered p q
    match law (middleIf p q) ordered 0 2 (show 0 < 3 by decide) (show 2 < 3 by decide)
        (middleIf_not_zero_two neither) (middleIf_not_two_zero p q) with
    | ⟨π, _, t, natural, f0, f2⟩ => match Nat.lt_or_ge (π 1) t with
      | .inl lt => .inl fun hp => Nat.not_le_of_lt lt (f0.2.2 1 (.inl ⟨rfl, rfl, hp⟩))
      | .inr ge => .inr fun hq =>
        Nat.not_le_of_lt (Nat.lt_trans (natural.before ordered (.inr (.inl ⟨rfl, rfl, hq⟩))) f2.2.1) ge

/-- **`together_some_iff` from right to left, asked of every causal set, is exactly weak excluded
middle.** -/
theorem together_some_iff_weakly :
    (∀ c : Causet, c.Ordered → ∀ x y, x < c.size → y < c.size → ¬ c.prec x y → ¬ c.prec y x →
      ∃ π σ t, NaturalLabelling c π σ ∧ MaximalBorn c π t x ∧ MaximalBorn c π t y) ↔
    ∀ p : Prop, WeaklyDecided p :=
  ⟨fun law => weakly_of_deMorgan (together_some_deMorgan law),
   fun weakly _ ordered _ _ hx hy nxy nyx =>
     (together_some_iff (fun _ _ => weakly _) ordered).mpr ⟨hx, hy, nxy, nyx⟩⟩

/-- `antichain_present`, asked of every causal set, gives `together_some_iff` from right to left,
with no decision: two unrelated elements are an antichain. -/
theorem together_of_antichain
    (law : ∀ c : Causet, c.Ordered → ∀ q : Nat → Bool, (∀ {x}, q x = true → x < c.size) →
      (∀ {x y}, q x = true → q y = true → ¬ c.prec x y) →
      ∃ π σ t, NaturalLabelling c π σ ∧ ∀ x, MaximalBorn c π t x ↔ q x = true)
    {c : Causet} (ordered : c.Ordered) {x y : Nat} (hx : x < c.size) (hy : y < c.size)
    (nxy : ¬ c.prec x y) (nyx : ¬ c.prec y x) :
    ∃ π σ t, NaturalLabelling c π σ ∧ MaximalBorn c π t x ∧ MaximalBorn c π t y :=
  have member : ∀ {z}, (Nat.beq z x || Nat.beq z y) = true → z = x ∨ z = y := fun h =>
    match ListTests.or_true_iff.mp h with
    | .inl e => .inl (Nat.eq_of_beq_eq_true e)
    | .inr e => .inr (Nat.eq_of_beq_eq_true e)
  have inside : ∀ {z}, (Nat.beq z x || Nat.beq z y) = true → z < c.size := fun h =>
    match member h with
    | .inl e => Eq.subst (motive := fun k => k < c.size) e.symm hx
    | .inr e => Eq.subst (motive := fun k => k < c.size) e.symm hy
  have apart : ∀ {u v}, (Nat.beq u x || Nat.beq u y) = true → (Nat.beq v x || Nat.beq v y) = true →
      ¬ c.prec u v := fun hu hv pair => by
    rcases member hu with rfl | rfl <;> rcases member hv with rfl | rfl <;>
      first | exact ordered.irrefl _ pair | exact nxy pair | exact nyx pair
  match law c ordered (fun z => Nat.beq z x || Nat.beq z y) inside apart with
  | ⟨π, σ, t, natural, present⟩ =>
    ⟨π, σ, t, natural, (present x).mpr (ListTests.or_true_iff.mpr (.inl (beq_self x))),
     (present y).mpr (ListTests.or_true_iff.mpr (.inr (beq_self y)))⟩

/-- **`antichain_present`, asked of every causal set, is exactly weak excluded middle.** -/
theorem antichain_present_iff_weakly :
    (∀ c : Causet, c.Ordered → ∀ q : Nat → Bool, (∀ {x}, q x = true → x < c.size) →
      (∀ {x y}, q x = true → q y = true → ¬ c.prec x y) →
      ∃ π σ t, NaturalLabelling c π σ ∧ ∀ x, MaximalBorn c π t x ↔ q x = true) ↔
    ∀ p : Prop, WeaklyDecided p :=
  ⟨fun law => together_some_iff_weakly.mp fun _ ordered _ _ hx hy nxy nyx =>
     together_of_antichain law ordered hx hy nxy nyx,
   fun weakly _ ordered q inside apart => antichain_present (fun _ _ => weakly _) ordered q inside apart⟩

/-! ## Presence of a condition when what it conditions is born -/

/-- `i` is **present at `j`'s birth** in the labelling `π`: `i` precedes `j`, and nothing `i`
precedes is born before `j`, so `i` is in the present when `j` is born. -/
def PresentAt (c : Causet) (π : Nat → Nat) (i j : Nat) : Prop :=
  c.prec i j ∧ ∀ k, c.prec i k → π j ≤ π k

/-- `j` is the **least element above `i`**: `i` precedes `j`, and everything `i` precedes is `j` or
above `j`. -/
def LeastAbove (c : Causet) (i j : Nat) : Prop :=
  c.prec i j ∧ ∀ k, c.prec i k → k = j ∨ c.prec j k

section Present

variable {c : Causet}

/-- **The least element above a condition is a link below it**: it conditions it directly. -/
theorem link_of_least (ordered : c.Ordered) {i j : Nat} (least : LeastAbove c i j) :
    links c.prec i j :=
  ⟨least.1, fun z ⟨first, second⟩ => match least.2 z first with
    | .inl e => ordered.irrefl j (Eq.subst (motive := fun k => c.prec k j) e second)
    | .inr p => ordered.irrefl j (ordered.trans p second)⟩

/-- **Presence is being in the present when what one conditions is born**: in a natural labelling,
`i` is present at `j`'s birth exactly where `i` precedes `j` and is maximal among what is born by
`j`'s stage. -/
theorem present_iff_maximalBorn (ordered : c.Ordered) {π σ : Nat → Nat}
    (natural : NaturalLabelling c π σ) {i j : Nat} :
    PresentAt c π i j ↔ c.prec i j ∧ MaximalBorn c π (π j) i :=
  ⟨fun ⟨pair, after⟩ =>
     ⟨pair, Nat.lt_trans (ordered.labelled pair) (ordered.within pair), natural.before ordered pair, after⟩,
   fun ⟨pair, _, _, after⟩ => ⟨pair, after⟩⟩

/-- **A condition present when what it conditions is born, on some course, conditions it
directly**: it is a link below it. No decision is used. -/
theorem link_of_present (ordered : c.Ordered) {π σ : Nat → Nat} (natural : NaturalLabelling c π σ)
    {i j : Nat} (present : PresentAt c π i j) : links c.prec i j :=
  ⟨present.1, fun z ⟨first, second⟩ =>
    Nat.lt_irrefl _ (Nat.lt_of_le_of_lt (present.2 z first) (natural.before ordered second))⟩

/-- **A condition can be present when what it conditions is born exactly where it conditions it
directly**: with precedence weakly decided, `i` is present at `j`'s birth in some natural labelling
exactly where `i` is a link below `j`; the course bears first the elements not refuted to lie at or
below `j`. -/
theorem present_some_iff_link (weakly : ∀ a b, WeaklyDecided (c.prec a b)) (ordered : c.Ordered)
    {i j : Nat} (hj : j < c.size) :
    (∃ π σ, NaturalLabelling c π σ ∧ PresentAt c π i j) ↔ links c.prec i j :=
  ⟨fun ⟨_, _, natural, present⟩ => link_of_present ordered natural present,
   fun link =>
     match table_of (Q := fun z => ¬ ¬ (z = j ∨ c.prec z j)) (fun z => match Nat.decEq z j with
         | .isTrue e => .inl fun no => no (.inl e)
         | .isFalse ne => match weakly z j with
           | .inl fails => .inr fun unrefuted => unrefuted fun inside => inside.elim ne fails
           | .inr unrefuted => .inl fun no => unrefuted fun holds => no (.inr holds)) c.size with
     | ⟨f, spec⟩ =>
       have fj : f j = true := (spec j hj).mpr fun no => no (.inl rfl)
       ⟨front f c.size, back f c.size,
        natural_of_table ordered spec fun {a _} pair unrefuted no =>
          unrefuted fun inside => no (.inr (match inside with
            | .inl e => Eq.subst (motive := fun w => c.prec a w) e pair
            | .inr p => ordered.trans pair p)),
        link.1, fun k first => match h : f k with
         | true => match Nat.decEq k j with
           | .isTrue e => Nat.le_of_eq (congrArg (front f c.size) e.symm)
           | .isFalse ne => (((spec k (ordered.within first)).mp h) fun inside => match inside with
             | .inl e => ne e
             | .inr p => link.2 k ⟨first, p⟩).elim
         | false => Nat.le_of_lt (front_true_lt_false fj h hj)⟩⟩

/-- **A condition must be present when what it conditions is born exactly where that is the least
element above it**: with precedence decided, `i` is present at `j`'s birth in every natural
labelling exactly where `i` precedes `j` and everything `i` precedes is `j` or above `j`. -/
theorem present_every_iff [∀ a b, Decidable (c.prec a b)] (ordered : c.Ordered) {i j : Nat} :
    (∀ π σ, NaturalLabelling c π σ → PresentAt c π i j) ↔ LeastAbove c i j :=
  ⟨fun every => ⟨(every _ _ (natural_identity c)).1, fun k first =>
      match Nat.decEq k j with
      | .isTrue e => .inl e
      | .isFalse ne => if later : c.prec j k then .inr later else
        match downTo_before ordered (ordered.within first) later (fun e => ne e.symm) with
        | ⟨natural, lt⟩ => absurd ((every _ _ natural).2 k first) (Nat.not_le_of_lt lt)⟩,
   fun ⟨pair, above⟩ π _ natural => ⟨pair, fun k first => match above k first with
      | .inl e => Nat.le_of_eq (congrArg π e.symm)
      | .inr later => Nat.le_of_lt (natural.before ordered later)⟩⟩

/-- **The least element above `i` is the one element `i` is linked to**: with precedence decided,
the bound on every course read on links (UE13's `ordered_reach_links_iff`). -/
theorem least_iff_only_link [∀ a b, Decidable (c.prec a b)] (ordered : c.Ordered) {i j : Nat} :
    LeastAbove c i j ↔ links c.prec i j ∧ ∀ k, links c.prec i k → k = j :=
  ⟨fun least => ⟨link_of_least ordered least, fun k link =>
      match least.2 k link.1 with
      | .inl e => e
      | .inr later => (link.2 j ⟨least.1, later⟩).elim⟩,
   fun ⟨link, only⟩ => ⟨link.1, fun k first =>
      match (CausalGrowth.ordered_reach_links_iff ordered).mpr first with
      | .one step => .inl (only k step)
      | .more step rest =>
        .inr (Eq.subst (motive := fun z => c.prec z k) (only _ step)
          (CausalGrowth.reach_links_le (O := c.prec) ordered.trans rest))⟩⟩

/-- With no decision, where `j` is the one element `i` is linked to, everything `i` precedes is,
doubly negated, `j` or above `j`: by the elements below it. -/
theorem above_of_only_not_not (ordered : c.Ordered) {i j : Nat}
    (only : ∀ k, links c.prec i k → k = j) :
    ∀ n k, k < n → c.prec i k → ¬ ¬ (k = j ∨ c.prec j k)
  | 0, _, below, _ => absurd below (Nat.not_lt_zero _)
  | n + 1, k, below, first => fun no =>
    not_not_decided (∃ z, c.prec i z ∧ c.prec z k) fun decided => match decided with
    | .inl ⟨z, iz, zk⟩ =>
      above_of_only_not_not ordered only n z
        (Nat.lt_of_lt_of_le (ordered.labelled zk) (Nat.le_of_lt_succ below)) iz fun h => match h with
        | .inl e => no (.inr (Eq.subst (motive := fun w => c.prec w k) e zk))
        | .inr jz => no (.inr (ordered.trans jz zk))
    | .inr direct => no (.inl (only k ⟨first, fun z between => direct ⟨z, between⟩⟩))

/-- With no decision, the one link is present on every course. -/
theorem present_every_of_only_link (ordered : c.Ordered) {i j : Nat} (link : links c.prec i j)
    (only : ∀ k, links c.prec i k → k = j) :
    ∀ π σ, NaturalLabelling c π σ → PresentAt c π i j :=
  fun π _ natural => ⟨link.1, fun k first => match Nat.lt_or_ge (π k) (π j) with
    | .inr ge => ge
    | .inl lt => (above_of_only_not_not ordered only (k + 1) k (Nat.lt_succ_self k) first fun h =>
        match h with
        | .inl e => Nat.lt_irrefl (π j) (Eq.subst (motive := fun z => π z < π j) e lt)
        | .inr later => Nat.lt_asymm lt (natural.before ordered later)).elim⟩

/-- With no decision, what is present on every course at a birth is the one link below it: a
second link would be born before it on a course bearing a table of the elements at or below the
second first. -/
theorem only_link_of_present_every (ordered : c.Ordered) {i j : Nat}
    (every : ∀ π σ, NaturalLabelling c π σ → PresentAt c π i j) :
    links c.prec i j ∧ ∀ k, links c.prec i k → k = j :=
  match every _ _ (natural_identity c) with
  | ⟨pair, after⟩ =>
    ⟨⟨pair, fun z between => Nat.lt_irrefl j
        (Nat.lt_of_le_of_lt (after z between.1) (ordered.labelled between.2))⟩,
     fun k link => match Nat.decEq k j with
      | .isTrue e => e
      | .isFalse ne => (table_not_not (fun x => c.prec x k ∨ x = k) c.size fun ⟨_, spec⟩ =>
          Nat.not_le_of_lt
            (front_true_lt_false ((spec k (ordered.within link.1)).mpr (.inr rfl))
              (table_false (spec j (ordered.within pair))
                fun inside => inside.elim (fun jk => link.2 j ⟨pair, jk⟩) (fun e => ne e.symm))
              (ordered.within link.1))
            ((every _ _ (natural_of_table ordered spec (down_closed ordered k))).2 k link.1)).elim⟩

/-- So **a condition is present at the birth of what it conditions on every course exactly where
that is the one element it is linked to**, with no decision. -/
theorem present_every_iff_only_link (ordered : c.Ordered) {i j : Nat} :
    (∀ π σ, NaturalLabelling c π σ → PresentAt c π i j) ↔ links c.prec i j ∧ ∀ k, links c.prec i k → k = j :=
  ⟨only_link_of_present_every ordered,
   fun ⟨link, only⟩ => present_every_of_only_link ordered link only⟩

/-- With no decision, where a condition is present at the birth of what it conditions on every
course, everything it precedes is, doubly negated, that or above it. -/
theorem above_of_every_not_not (ordered : c.Ordered) {i j : Nat}
    (every : ∀ π σ, NaturalLabelling c π σ → PresentAt c π i j) {k : Nat} (first : c.prec i k) :
    ¬ ¬ (k = j ∨ c.prec j k) :=
  fun no => table_not_not (fun x => c.prec x k ∨ x = k) c.size fun ⟨_, spec⟩ =>
    Nat.not_le_of_lt
      (front_true_lt_false ((spec k (ordered.within first)).mpr (.inr rfl))
        (table_false (spec j (ordered.within (every _ _ (natural_identity c)).1))
          fun inside => inside.elim (fun p => no (.inr p)) (fun e => no (.inl e.symm)))
        (ordered.within first))
      ((every _ _ (natural_of_table ordered spec (down_closed ordered k))).2 k first)

end Present

/-- Three elements: `0` below `1` and `2`, and `1` below `2` exactly where `P`. -/
def leastIf (P : Prop) : Causet :=
  ⟨3, fun a b => (a = 0 ∧ (b = 1 ∨ b = 2)) ∨ (a = 1 ∧ b = 2 ∧ P)⟩

theorem leastIf_ordered (P : Prop) : (leastIf P).Ordered where
  trans := fun first second => match first, second with
    | .inl ⟨a0, .inl _⟩, .inr ⟨_, c2, _⟩ => .inl ⟨a0, .inr c2⟩
    | .inl ⟨_, .inl b1⟩, .inl ⟨b0, _⟩ => absurd (b1.symm.trans b0) (by decide)
    | .inl ⟨_, .inr b2⟩, .inl ⟨b0, _⟩ => absurd (b2.symm.trans b0) (by decide)
    | .inl ⟨_, .inr b2⟩, .inr ⟨b1, _, _⟩ => absurd (b2.symm.trans b1) (by decide)
    | .inr ⟨_, b2, _⟩, .inl ⟨b0, _⟩ => absurd (b2.symm.trans b0) (by decide)
    | .inr ⟨_, b2, _⟩, .inr ⟨b1, _, _⟩ => absurd (b2.symm.trans b1) (by decide)
  labelled := fun pair => match pair with
    | .inl ⟨a0, .inl b1⟩ => by subst a0; subst b1; decide
    | .inl ⟨a0, .inr b2⟩ => by subst a0; subst b2; decide
    | .inr ⟨a1, b2, _⟩ => by subst a1; subst b2; decide
  within := fun pair => match pair with
    | .inl ⟨_, .inl b1⟩ => by subst b1; exact (show 1 < 3 by decide)
    | .inl ⟨_, .inr b2⟩ => by subst b2; exact (show 2 < 3 by decide)
    | .inr ⟨_, b2, _⟩ => by subst b2; exact (show 2 < 3 by decide)

/-- **Without the decision, passing from presence on every course to the least element above
removes double negation**: on `leastIf P`, wherever `P` is not refuted, `0` is present at `1`'s
birth on every course, and `1` being the least element above `0` gives `P`. -/
theorem present_every_needs_decision
    (law : ∀ c : Causet, c.Ordered → ∀ i j, (∀ π σ, NaturalLabelling c π σ → PresentAt c π i j) →
      LeastAbove c i j) :
    ∀ P : Prop, ¬ ¬ P → P :=
  fun P nn =>
    have every : ∀ π σ, NaturalLabelling (leastIf P) π σ → PresentAt (leastIf P) π 0 1 := fun π σ natural =>
      have a1 := natural.at (i := 1) (show 1 < 3 by decide)
      have a2 := natural.at (i := 2) (show 2 < 3 by decide)
      have le : π 1 ≤ π 2 := match Nat.lt_or_ge (π 1) (π 2) with
        | .inl lt => Nat.le_of_lt lt
        | .inr ge => match Nat.eq_or_lt_of_le ge with
          | .inl same => absurd ((a2.2.symm.trans (congrArg σ same)).trans a1.2) (by decide)
          | .inr lt =>
            (nn fun p => Nat.lt_asymm lt (natural.before (leastIf_ordered P) (.inr ⟨rfl, rfl, p⟩))).elim
      ⟨.inl ⟨rfl, .inl rfl⟩, fun k pair => match pair with
        | .inl ⟨_, .inl k1⟩ => Nat.le_of_eq (congrArg π k1.symm)
        | .inl ⟨_, .inr k2⟩ => Eq.subst (motive := fun z => π 1 ≤ π z) k2.symm le
        | .inr ⟨h, _, _⟩ => absurd h (by decide)⟩
    match (law (leastIf P) (leastIf_ordered P) 0 1 every).2 2 (.inl ⟨rfl, .inr rfl⟩) with
    | .inl e => absurd e (by decide)
    | .inr pair => match pair with
      | .inl ⟨h, _⟩ => absurd h (by decide)
      | .inr ⟨_, _, p⟩ => p

/-- **Passing from presence on every course to the least element above, asked of every causal
set, is exactly excluded middle.** For the unfolding: that a condition is present at a birth on
every course settles that everything it conditions is at or above what is born only up to double
negation (`above_of_every_not_not`); asserting it is deciding. -/
theorem present_least_iff_em :
    (∀ c : Causet, c.Ordered → ∀ i j, (∀ π σ, NaturalLabelling c π σ → PresentAt c π i j) →
      LeastAbove c i j) ↔ ∀ p : Prop, Decided p :=
  ⟨fun law p => present_every_needs_decision law _ (not_not_decided p),
   fun em c ordered _ _ every => ⟨(every _ _ (natural_identity c)).1, fun _ first =>
     (em _).of_not_not (above_of_every_not_not ordered every first)⟩⟩

/-- **So the decision lies in passing from the one link to the least element above**: that, on
every causal set, the one link is the least element above (the converse of `least_iff_only_link`'s
first direction) is exactly excluded middle. -/
theorem only_link_least_iff_em :
    (∀ c : Causet, c.Ordered → ∀ i j, links c.prec i j → (∀ k, links c.prec i k → k = j) →
      LeastAbove c i j) ↔ ∀ p : Prop, Decided p :=
  ⟨fun law => present_least_iff_em.mp fun c ordered i j every =>
     match only_link_of_present_every ordered every with
     | ⟨link, only⟩ => law c ordered i j link only,
   fun em _ ordered _ _ link only => ⟨link.1, fun k first =>
     (em _).of_not_not (above_of_only_not_not ordered only (k + 1) k (Nat.lt_succ_self k) first)⟩⟩

/-- Three elements: `0` below `2`, `0` below `1` exactly where `p`, and `1` below `2` exactly
where `q`. -/
def linkIf (p q : Prop) : Causet :=
  ⟨3, fun a b => (a = 0 ∧ b = 2) ∨ (a = 0 ∧ b = 1 ∧ p) ∨ (a = 1 ∧ b = 2 ∧ q)⟩

theorem linkIf_ordered (p q : Prop) : (linkIf p q).Ordered where
  trans := fun first second => match first, second with
    | .inl ⟨_, b2⟩, .inl ⟨b0, _⟩ => absurd (b2.symm.trans b0) (by decide)
    | .inl ⟨_, b2⟩, .inr (.inl ⟨b0, _⟩) => absurd (b2.symm.trans b0) (by decide)
    | .inl ⟨_, b2⟩, .inr (.inr ⟨b1, _⟩) => absurd (b2.symm.trans b1) (by decide)
    | .inr (.inl ⟨_, b1, _⟩), .inl ⟨b0, _⟩ => absurd (b1.symm.trans b0) (by decide)
    | .inr (.inl ⟨_, b1, _⟩), .inr (.inl ⟨b0, _⟩) => absurd (b1.symm.trans b0) (by decide)
    | .inr (.inl ⟨a0, _, _⟩), .inr (.inr ⟨_, c2, _⟩) => .inl ⟨a0, c2⟩
    | .inr (.inr ⟨_, b2, _⟩), .inl ⟨b0, _⟩ => absurd (b2.symm.trans b0) (by decide)
    | .inr (.inr ⟨_, b2, _⟩), .inr (.inl ⟨b0, _⟩) => absurd (b2.symm.trans b0) (by decide)
    | .inr (.inr ⟨_, b2, _⟩), .inr (.inr ⟨b1, _⟩) => absurd (b2.symm.trans b1) (by decide)
  labelled := fun pair => match pair with
    | .inl ⟨a0, b2⟩ => by subst a0; subst b2; decide
    | .inr (.inl ⟨a0, b1, _⟩) => by subst a0; subst b1; decide
    | .inr (.inr ⟨a1, b2, _⟩) => by subst a1; subst b2; decide
  within := fun pair => match pair with
    | .inl ⟨_, b2⟩ => by subst b2; exact (show 2 < 3 by decide)
    | .inr (.inl ⟨_, b1, _⟩) => by subst b1; exact (show 1 < 3 by decide)
    | .inr (.inr ⟨_, b2, _⟩) => by subst b2; exact (show 2 < 3 by decide)

/-- **`present_some_iff_link` from right to left, asked of every causal set, gives De Morgan's
law**: on `linkIf p q`, `0` is a link below `2` exactly where `p ∧ q` is refuted, and a course with
`0` present at `2`'s birth refutes `p` or `q` by where it bears `1`. -/
theorem present_some_deMorgan
    (law : ∀ c : Causet, c.Ordered → ∀ i j, j < c.size → links c.prec i j →
      ∃ π σ, NaturalLabelling c π σ ∧ PresentAt c π i j) :
    ∀ p q : Prop, ¬ (p ∧ q) → ¬ p ∨ ¬ q :=
  fun p q neither =>
    have ordered := linkIf_ordered p q
    match law (linkIf p q) ordered 0 2 (show 2 < 3 by decide)
        ⟨.inl ⟨rfl, rfl⟩, fun z between => match between.1 with
          | .inl ⟨_, z2⟩ => Nat.lt_irrefl 2
              (Eq.subst (motive := fun w => w < 2) z2 (ordered.labelled between.2))
          | .inr (.inl ⟨_, z1, hp⟩) => match between.2 with
            | .inl ⟨h, _⟩ => absurd (z1.symm.trans h) (by decide)
            | .inr (.inl ⟨h, _⟩) => absurd (z1.symm.trans h) (by decide)
            | .inr (.inr ⟨_, _, hq⟩) => neither ⟨hp, hq⟩
          | .inr (.inr ⟨h, _⟩) => absurd h (by decide)⟩ with
    | ⟨π, _, natural, _, after⟩ => match Nat.lt_or_ge (π 1) (π 2) with
      | .inl lt => .inl fun hp => Nat.not_le_of_lt lt (after 1 (.inr (.inl ⟨rfl, rfl, hp⟩)))
      | .inr ge => .inr fun hq =>
        Nat.not_le_of_lt (natural.before ordered (.inr (.inr ⟨rfl, rfl, hq⟩))) ge

/-- **`present_some_iff_link` from right to left, asked of every causal set, is exactly weak
excluded middle.** For the unfolding: finding a course on which a link is present at the birth of
what it conditions is deciding, for each element, only whether its precedence fails. -/
theorem present_some_iff_weakly :
    (∀ c : Causet, c.Ordered → ∀ i j, j < c.size → links c.prec i j →
      ∃ π σ, NaturalLabelling c π σ ∧ PresentAt c π i j) ↔ ∀ p : Prop, WeaklyDecided p :=
  ⟨fun law => weakly_of_deMorgan (present_some_deMorgan law),
   fun weakly _ ordered _ _ hj link => (present_some_iff_link (fun _ _ => weakly _) ordered hj).mpr link⟩

/-! ## On the courses of the growth

By `natural_iff_course`, what holds in every natural labelling of `c` holds on every course of the
growth from the empty set, read through a relabelling of `c` onto the course's configuration at
`c`'s size, and what holds in some natural labelling holds on some such course. The main laws are
stated here on the courses themselves. -/

section Courses

variable {c : Causet}

/-- **What holds in every natural labelling holds on every course**: on every course of the growth
from the empty set, read through every relabelling of `c` onto its configuration at `c`'s size. -/
theorem every_course_iff (ordered : c.Ordered) (Φ : (Nat → Nat) → Prop) :
    (∀ π σ, NaturalLabelling c π σ → Φ π) ↔
      ∀ (r : Run process) π σ, r.state 0 = empty →
        CausalGrowth.Kinds.Relabels c (r.state c.size) π σ → Φ π :=
  ⟨fun every _ π σ start relabels => every π σ ((natural_iff_course ordered).mpr ⟨_, start, relabels⟩),
   fun every π σ natural => match (natural_iff_course ordered).mp natural with
     | ⟨r, start, relabels⟩ => every r π σ start relabels⟩

/-- **What holds in some natural labelling holds on some course.** -/
theorem some_course_iff (ordered : c.Ordered) (Φ : (Nat → Nat) → Prop) :
    (∃ π σ, NaturalLabelling c π σ ∧ Φ π) ↔
      ∃ r : Run process, ∃ π σ, r.state 0 = empty ∧
        CausalGrowth.Kinds.Relabels c (r.state c.size) π σ ∧ Φ π :=
  ⟨fun ⟨π, σ, natural, holds⟩ => match (natural_iff_course ordered).mp natural with
     | ⟨r, start, relabels⟩ => ⟨r, π, σ, start, relabels, holds⟩,
   fun ⟨_, π, σ, start, relabels, holds⟩ =>
     ⟨π, σ, (natural_iff_course ordered).mpr ⟨_, start, relabels⟩, holds⟩⟩

/-- **Births of unrelated elements commute, and only they, on the courses** (`rearranges_iff_natural`):
from the numbering of `c`'s elements by a course, a renumbering is reached by exchanging consecutive
births of incomparable elements exactly where it is the numbering by some course. -/
theorem rearranges_iff_course (ordered : c.Ordered) {r : Run process} {π σ π' σ' : Nat → Nat}
    (start : r.state 0 = empty) (relabels : CausalGrowth.Kinds.Relabels c (r.state c.size) π σ)
    (reindex' : Reindexes 0 c.size π' σ') :
    Rearranges (Comparable c) 0 c.size π σ π' ↔
      ∃ r' : Run process, r'.state 0 = empty ∧ CausalGrowth.Kinds.Relabels c (r'.state c.size) π' σ' :=
  (rearranges_iff_natural ordered ((natural_iff_course ordered).mpr ⟨r, start, relabels⟩) reindex').trans
    (natural_iff_course ordered)

/-- **Every stem with decided membership is what some course bears first, on the courses**
(`stem_born_first`). -/
theorem stem_born_first_course {D : Nat → Prop} [∀ x, Decidable (D x)] (ordered : c.Ordered)
    (stem : Stem c D) :
    ∃ r : Run process, ∃ π σ, r.state 0 = empty ∧ CausalGrowth.Kinds.Relabels c (r.state c.size) π σ ∧
      ∀ x, x < c.size → (π x < count (fun x => decide (D x)) c.size ↔ D x) :=
  match (natural_iff_course ordered).mp (stem_born_first stem).1 with
  | ⟨r, start, relabels⟩ => ⟨r, _, _, start, relabels, (stem_born_first stem).2⟩

/-- **Born before on every course is precedence, on the courses** (`prec_iff_every`). -/
theorem prec_iff_every_course [∀ a b, Decidable (c.prec a b)] (ordered : c.Ordered) {i j : Nat}
    (hj : j < c.size) :
    c.prec i j ↔ ∀ (r : Run process) π σ, r.state 0 = empty →
      CausalGrowth.Kinds.Relabels c (r.state c.size) π σ → π i < π j :=
  (prec_iff_every ordered hj).trans (every_course_iff ordered fun π => π i < π j)

/-- **What is born no later than an element on every course is its past, on the courses**
(`past_every_iff`). -/
theorem past_every_course [∀ a b, Decidable (c.prec a b)] (ordered : c.Ordered) {x y : Nat}
    (hx : x < c.size) (hy : y < c.size) :
    (∀ (r : Run process) π σ, r.state 0 = empty →
      CausalGrowth.Kinds.Relabels c (r.state c.size) π σ → π y ≤ π x) ↔ y = x ∨ c.prec y x :=
  (every_course_iff ordered fun π => π y ≤ π x).symm.trans (past_every_iff ordered hx hy)

/-- **The past is the largest relation every course respects, on the courses** (`past_largest`). -/
theorem past_largest_course [∀ a b, Decidable (c.prec a b)] (ordered : c.Ordered)
    (R : Nat → Nat → Prop)
    (respected : ∀ x y, R x y → ∀ (r : Run process) π σ, r.state 0 = empty →
      CausalGrowth.Kinds.Relabels c (r.state c.size) π σ → π y ≤ π x)
    {x y : Nat} (hx : x < c.size) (hy : y < c.size) (pair : R x y) : y = x ∨ c.prec y x :=
  past_largest ordered R
    (fun x y holds => (every_course_iff ordered fun π => π y ≤ π x).mpr (respected x y holds)) hx hy pair

/-- **With no decision, born before on every course is precedence not refuted, on the courses**
(`every_iff_not_not`). -/
theorem every_course_not_not (ordered : c.Ordered) {i j : Nat} (hi : i < c.size) (hj : j < c.size) :
    (∀ (r : Run process) π σ, r.state 0 = empty →
      CausalGrowth.Kinds.Relabels c (r.state c.size) π σ → π i < π j) ↔ ¬ ¬ c.prec i j :=
  (every_course_iff ordered fun π => π i < π j).symm.trans (every_iff_not_not ordered hi hj)

/-- **Born before on some course, on the courses** (`before_some_iff`). -/
theorem before_some_course (weakly : ∀ a b, WeaklyDecided (c.prec a b)) (ordered : c.Ordered)
    {i j : Nat} (hi : i < c.size) (hj : j < c.size) :
    (∃ r : Run process, ∃ π σ, r.state 0 = empty ∧
      CausalGrowth.Kinds.Relabels c (r.state c.size) π σ ∧ π i < π j) ↔ i ≠ j ∧ ¬ c.prec j i :=
  (some_course_iff ordered fun π => π i < π j).symm.trans (before_some_iff weakly ordered hi hj)

/-- **Two different unrelated elements are born in either order, on the courses** (`either_order`). -/
theorem either_order_course (weakly : ∀ a b, WeaklyDecided (c.prec a b)) (ordered : c.Ordered)
    {x y : Nat} (hx : x < c.size) (hy : y < c.size) (nxy : ¬ c.prec x y) (nyx : ¬ c.prec y x)
    (ne : x ≠ y) :
    (∃ r : Run process, ∃ π σ, r.state 0 = empty ∧
      CausalGrowth.Kinds.Relabels c (r.state c.size) π σ ∧ π x < π y) ∧
    (∃ r : Run process, ∃ π σ, r.state 0 = empty ∧
      CausalGrowth.Kinds.Relabels c (r.state c.size) π σ ∧ π y < π x) :=
  match either_order weakly ordered hx hy nxy nyx ne with
  | ⟨first, second⟩ => ⟨(some_course_iff ordered fun π => π x < π y).mp first,
                        (some_course_iff ordered fun π => π y < π x).mp second⟩

/-- **Every antichain given by a test is the present of some course at some stage, on the courses**
(`antichain_present`). -/
theorem antichain_present_course (weakly : ∀ a b, WeaklyDecided (c.prec a b)) (ordered : c.Ordered)
    (q : Nat → Bool) (inside : ∀ {x}, q x = true → x < c.size)
    (apart : ∀ {x y}, q x = true → q y = true → ¬ c.prec x y) :
    ∃ r : Run process, ∃ π σ t, r.state 0 = empty ∧
      CausalGrowth.Kinds.Relabels c (r.state c.size) π σ ∧ ∀ x, MaximalBorn c π t x ↔ q x = true :=
  match antichain_present weakly ordered q inside apart with
  | ⟨π, σ, t, natural, present⟩ => match (natural_iff_course ordered).mp natural with
    | ⟨r, start, relabels⟩ => ⟨r, π, σ, t, start, relabels, present⟩

/-- **Present together on some course, on the courses** (`together_some_iff`). -/
theorem together_some_course (weakly : ∀ a b, WeaklyDecided (c.prec a b)) (ordered : c.Ordered)
    {x y : Nat} :
    (∃ r : Run process, ∃ π σ t, r.state 0 = empty ∧
      CausalGrowth.Kinds.Relabels c (r.state c.size) π σ ∧ MaximalBorn c π t x ∧ MaximalBorn c π t y) ↔
      x < c.size ∧ y < c.size ∧ ¬ c.prec x y ∧ ¬ c.prec y x :=
  ⟨fun ⟨_, π, σ, t, start, relabels, fx, fy⟩ => (together_some_iff weakly ordered).mp
     ⟨π, σ, t, (natural_iff_course ordered).mpr ⟨_, start, relabels⟩, fx, fy⟩,
   fun apart => match (together_some_iff weakly ordered).mpr apart with
     | ⟨π, σ, t, natural, fx, fy⟩ => match (natural_iff_course ordered).mp natural with
       | ⟨r, start, relabels⟩ => ⟨r, π, σ, t, start, relabels, fx, fy⟩⟩

/-- **Present together on every course, on the courses** (`together_every_iff`). -/
theorem together_every_course [∀ a b, Decidable (c.prec a b)] (ordered : c.Ordered) {x y : Nat}
    (hx : x < c.size) (hy : y < c.size) :
    (∀ (r : Run process) π σ, r.state 0 = empty →
      CausalGrowth.Kinds.Relabels c (r.state c.size) π σ →
        ∃ t, MaximalBorn c π t x ∧ MaximalBorn c π t y) ↔ ∀ k, c.prec x k ↔ c.prec y k :=
  (every_course_iff ordered fun π => ∃ t, MaximalBorn c π t x ∧ MaximalBorn c π t y).symm.trans
    (together_every_iff ordered hx hy)

/-- **With no decision, present together on every course, on the courses**
(`together_every_iff_not_not`). -/
theorem together_every_course_not_not (ordered : c.Ordered) {x y : Nat} (hx : x < c.size)
    (hy : y < c.size) :
    (∀ (r : Run process) π σ, r.state 0 = empty →
      CausalGrowth.Kinds.Relabels c (r.state c.size) π σ →
        ∃ t, MaximalBorn c π t x ∧ MaximalBorn c π t y) ↔
      ∀ k, (c.prec x k → ¬ ¬ c.prec y k) ∧ (c.prec y k → ¬ ¬ c.prec x k) :=
  (every_course_iff ordered fun π => ∃ t, MaximalBorn c π t x ∧ MaximalBorn c π t y).symm.trans
    (together_every_iff_not_not ordered hx hy)

/-- **Presence at a birth on some course is a link, on the courses** (`present_some_iff_link`). -/
theorem present_some_course (weakly : ∀ a b, WeaklyDecided (c.prec a b)) (ordered : c.Ordered)
    {i j : Nat} (hj : j < c.size) :
    (∃ r : Run process, ∃ π σ, r.state 0 = empty ∧
      CausalGrowth.Kinds.Relabels c (r.state c.size) π σ ∧ PresentAt c π i j) ↔ links c.prec i j :=
  (some_course_iff ordered fun π => PresentAt c π i j).symm.trans (present_some_iff_link weakly ordered hj)

/-- **Presence at a birth on every course is the one link, with no decision, on the courses**
(`present_every_iff_only_link`). -/
theorem present_every_course_only_link (ordered : c.Ordered) {i j : Nat} :
    (∀ (r : Run process) π σ, r.state 0 = empty →
      CausalGrowth.Kinds.Relabels c (r.state c.size) π σ → PresentAt c π i j) ↔
      links c.prec i j ∧ ∀ k, links c.prec i k → k = j :=
  (every_course_iff ordered fun π => PresentAt c π i j).symm.trans (present_every_iff_only_link ordered)

end Courses

/-! ## Witnesses -/

theorem below_three : ∀ {i : Nat}, i < 3 → i = 0 ∨ i = 1 ∨ i = 2
  | 0, _ => .inl rfl
  | 1, _ => .inr (.inl rfl)
  | 2, _ => .inr (.inr rfl)
  | _ + 3, h => absurd h (Nat.not_lt_of_le (Nat.le_add_left 3 _))

theorem below_four : ∀ {i : Nat}, i < 4 → i = 0 ∨ i = 1 ∨ i = 2 ∨ i = 3
  | 0, _ => .inl rfl
  | 1, _ => .inr (.inl rfl)
  | 2, _ => .inr (.inr (.inl rfl))
  | 3, _ => .inr (.inr (.inr rfl))
  | _ + 4, h => absurd h (Nat.not_lt_of_le (Nat.le_add_left 4 _))

/-- Exchanging `1` and `2`. -/
def swap12 (i : Nat) : Nat := if i = 1 then 2 else if i = 2 then 1 else i

theorem swap12_three : Reindexes 0 3 swap12 swap12 := by
  intro i _ below
  rcases below_three below with rfl | rfl | rfl <;> decide

theorem swap12_four : Reindexes 0 4 swap12 swap12 := by
  intro i _ below
  rcases below_four below with rfl | rfl | rfl | rfl <;> decide

namespace Vee

/-- Three elements: `0` below `1` and `2`. -/
def vee : Causet := ⟨3, fun a b => a = 0 ∧ (b = 1 ∨ b = 2)⟩

instance (a b : Nat) : Decidable (vee.prec a b) :=
  inferInstanceAs (Decidable (a = 0 ∧ (b = 1 ∨ b = 2)))

theorem ordered : vee.Ordered where
  trans := by
    intro a b c first second
    rcases first with ⟨_, rfl | rfl⟩ <;> rcases second with ⟨h, _⟩ <;> exact absurd h (by decide)
  labelled := by
    intro a b pair
    rcases pair with ⟨rfl, rfl | rfl⟩ <;> decide
  within := by
    intro a b pair
    rcases pair with ⟨_, rfl | rfl⟩ <;> decide

/-- Exchanging the births of `1` and `2` is a natural labelling. -/
theorem natural_swap : NaturalLabelling vee swap12 swap12 :=
  ⟨swap12_three, by
    intro i j _ _ _ pair
    rcases pair with ⟨rfl, rfl | rfl⟩ <;> decide⟩

/-- **On the labels as they are, `0` is not present at `2`'s birth**: `1`, which `0` precedes, is
born before `2`. -/
theorem not_present_identity : ¬ PresentAt vee (fun i => i) 0 2 :=
  fun ⟨_, after⟩ => absurd (after 1 ⟨rfl, .inl rfl⟩) (by decide)

/-- **Exchanging the births of `1` and `2`, it is.** -/
theorem present_swap : PresentAt vee swap12 0 2 :=
  ⟨⟨rfl, .inr rfl⟩, by
    intro k pair
    rcases pair with ⟨_, rfl | rfl⟩ <;> decide⟩

/-- So `0` is a link below `2` (`link_of_present`) ... -/
theorem link : links vee.prec 0 2 :=
  link_of_present ordered natural_swap present_swap

/-- ... and `2` is not the least element above `0` (`present_every_iff`). -/
theorem not_least : ¬ LeastAbove vee 0 2 :=
  fun least => not_present_identity ((present_every_iff ordered).mpr least _ _ (natural_identity vee))

/-- **The present after two births is a choice of course**: on the labels as they are it is
exactly `1` ... -/
theorem maximal_after_two_identity (x : Nat) : MaximalBorn vee (fun i => i) 2 x ↔ x = 1 :=
  ⟨fun ⟨hx, born, after⟩ => match below_three hx with
    | .inl e => absurd (after 1 (Eq.subst (motive := fun z => vee.prec z 1) e.symm ⟨rfl, .inl rfl⟩))
        (by decide)
    | .inr (.inl e) => e
    | .inr (.inr e) => absurd (Eq.subst (motive := fun z => z < 2) e born) (by decide),
   fun e => Eq.subst (motive := fun z => MaximalBorn vee (fun i => i) 2 z) e.symm
     ⟨by decide, by decide, fun _ pair => absurd pair.1 (by decide)⟩⟩

/-- ... **and exchanging the births of `1` and `2`, it is exactly `2`.** -/
theorem maximal_after_two_swap (x : Nat) : MaximalBorn vee swap12 2 x ↔ x = 2 :=
  ⟨fun ⟨hx, born, after⟩ => match below_three hx with
    | .inl e => absurd (after 2 (Eq.subst (motive := fun z => vee.prec z 2) e.symm ⟨rfl, .inr rfl⟩))
        (by decide)
    | .inr (.inl e) => absurd (Eq.subst (motive := fun z => swap12 z < 2) e born) (by decide)
    | .inr (.inr e) => e,
   fun e => Eq.subst (motive := fun z => MaximalBorn vee swap12 2 z) e.symm
     ⟨by decide, by decide, fun _ pair => absurd pair.1 (by decide)⟩⟩

end Vee

/-- The past joined with being present together on every course: `b` precedes `a`, or the two are
in the present at some stage of every course. -/
def PastOrTogether (c : Causet) (a b : Nat) : Prop :=
  c.prec b a ∨ ∀ π σ, NaturalLabelling c π σ → ∃ t, MaximalBorn c π t a ∧ MaximalBorn c π t b

namespace Diamond

/-- Four elements: `0` below `1` and `2`, both below `3` (Wüthrich and Callender's example). -/
def diamond : Causet :=
  ⟨4, fun a b => (a = 0 ∧ (b = 1 ∨ b = 2 ∨ b = 3)) ∨ ((a = 1 ∨ a = 2) ∧ b = 3)⟩

instance (a b : Nat) : Decidable (diamond.prec a b) :=
  inferInstanceAs (Decidable ((a = 0 ∧ (b = 1 ∨ b = 2 ∨ b = 3)) ∨ ((a = 1 ∨ a = 2) ∧ b = 3)))

theorem prec_below {a b : Nat} (pair : diamond.prec a b) : a < 4 ∧ b < 4 := by
  rcases pair with ⟨rfl, rfl | rfl | rfl⟩ | ⟨rfl | rfl, rfl⟩ <;> decide

theorem ordered : diamond.Ordered where
  trans := by
    intro a b c first second
    have ha := (prec_below first).1
    have hb := (prec_below first).2
    have hc := (prec_below second).2
    revert first second
    rcases below_four ha with rfl | rfl | rfl | rfl <;>
    rcases below_four hb with rfl | rfl | rfl | rfl <;>
    rcases below_four hc with rfl | rfl | rfl | rfl <;> decide
  labelled := by
    intro a b pair
    rcases pair with ⟨rfl, rfl | rfl | rfl⟩ | ⟨rfl | rfl, rfl⟩ <;> decide
  within := fun pair => (prec_below pair).2

/-- **Wüthrich and Callender's relation**, which they read as `b` being definite as of `a`: each
element with itself and with what precedes it, and the two middle elements, `1` and `2`, with each
other. -/
def PastOrPair (a b : Nat) : Prop :=
  a = b ∨ diamond.prec b a ∨ (a = 1 ∧ b = 2) ∨ (a = 2 ∧ b = 1)

instance (a b : Nat) : Decidable (PastOrPair a b) :=
  inferInstanceAs (Decidable (a = b ∨ diamond.prec b a ∨ (a = 1 ∧ b = 2) ∨ (a = 2 ∧ b = 1)))

theorem pastOrPair_refl (a : Nat) : PastOrPair a a := .inl rfl

theorem pastOrPair_below {a b : Nat} (pair : PastOrPair a b) (ne : a ≠ b) : a < 4 ∧ b < 4 :=
  match pair with
  | .inl e => absurd e ne
  | .inr (.inl p) => ⟨(prec_below p).2, (prec_below p).1⟩
  | .inr (.inr (.inl ⟨a1, b2⟩)) => by subst a1; subst b2; decide
  | .inr (.inr (.inr ⟨a2, b1⟩)) => by subst a2; subst b1; decide

/-- **Wüthrich and Callender's relation is transitive.** -/
theorem pastOrPair_trans {a b c : Nat} (first : PastOrPair a b) (second : PastOrPair b c) : PastOrPair a c :=
  match Nat.decEq a b, Nat.decEq b c with
  | .isTrue e, _ => Eq.subst (motive := fun k => PastOrPair k c) e.symm second
  | _, .isTrue e => Eq.subst (motive := fun k => PastOrPair a k) e first
  | .isFalse ab, .isFalse bc => by
    have ha := (pastOrPair_below first ab).1
    have hb := (pastOrPair_below first ab).2
    have hc := (pastOrPair_below second bc).2
    revert first second
    rcases below_four ha with rfl | rfl | rfl | rfl <;>
    rcases below_four hb with rfl | rfl | rfl | rfl <;>
    rcases below_four hc with rfl | rfl | rfl | rfl <;> decide

/-- The two middle elements: each preceded by something and preceding something. -/
def Middle (a : Nat) : Prop := ∃ y z, diamond.prec y a ∧ diamond.prec a z

theorem middle_iff (a : Nat) : Middle a ↔ a = 1 ∨ a = 2 :=
  ⟨fun ⟨_, _, below, above⟩ => by
     rcases below with ⟨_, rfl | rfl | rfl⟩ | ⟨_, rfl⟩
     · exact .inl rfl
     · exact .inr rfl
     · rcases above with ⟨h, _⟩ | ⟨h, _⟩ <;> exact absurd h (by decide)
     · rcases above with ⟨h, _⟩ | ⟨h, _⟩ <;> exact absurd h (by decide),
   fun h => match h with
     | .inl e => ⟨0, 3, .inl ⟨rfl, .inl e⟩, .inr ⟨.inl e, rfl⟩⟩
     | .inr e => ⟨0, 3, .inl ⟨rfl, .inr (.inl e)⟩, .inr ⟨.inr e, rfl⟩⟩⟩

theorem pair_of_middle {a b : Nat} (ma : Middle a) (mb : Middle b) (ne : a ≠ b) :
    (a = 1 ∧ b = 2) ∨ (a = 2 ∧ b = 1) := by
  rcases (middle_iff a).mp ma with rfl | rfl <;> rcases (middle_iff b).mp mb with rfl | rfl
  · exact absurd rfl ne
  · exact .inl ⟨rfl, rfl⟩
  · exact .inr ⟨rfl, rfl⟩
  · exact absurd rfl ne

theorem middle_of_pair {a b : Nat} (pair : (a = 1 ∧ b = 2) ∨ (a = 2 ∧ b = 1)) :
    Middle a ∧ Middle b ∧ a ≠ b :=
  match pair with
  | .inl ⟨a1, b2⟩ => ⟨(middle_iff a).mpr (.inl a1), (middle_iff b).mpr (.inr b2), by subst a1; subst b2; decide⟩
  | .inr ⟨a2, b1⟩ => ⟨(middle_iff a).mpr (.inr a2), (middle_iff b).mpr (.inl b1), by subst a2; subst b1; decide⟩

section Automorphisms

variable {σ τ : Nat → Nat} (auto : CausalGrowth.Kinds.Relabels diamond diamond σ τ)
include auto

theorem auto_middle {a : Nat} (middle : Middle a) : Middle (σ a) :=
  match middle with
  | ⟨y, z, below, above⟩ =>
    have hy := (prec_below below).1
    have ha := (prec_below below).2
    have hz := (prec_below above).2
    ⟨σ y, σ z, (auto.2.2 y a hy ha).mp below, (auto.2.2 a z ha hz).mp above⟩

theorem auto_middle_back {a : Nat} (ha : a < 4) (middle : Middle (σ a)) : Middle a :=
  match middle with
  | ⟨y, z, below, above⟩ =>
    have hy := auto.2.1 y (prec_below below).1
    have hz := auto.2.1 z (prec_below above).2
    ⟨τ y, τ z,
     (auto.2.2 (τ y) a hy.1 ha).mpr (Eq.subst (motive := fun k => diamond.prec k (σ a)) hy.2.symm below),
     (auto.2.2 a (τ z) ha hz.1).mpr (Eq.subst (motive := fun k => diamond.prec (σ a) k) hz.2.symm above)⟩

theorem auto_inj {a b : Nat} (ha : a < 4) (hb : b < 4) (same : σ a = σ b) : a = b :=
  ((auto.1 a ha).2.symm.trans (congrArg τ same)).trans (auto.1 b hb).2

/-- **Every automorphism keeps Wüthrich and Callender's relation.** -/
theorem pastOrPair_kept {a b : Nat} (ha : a < 4) (hb : b < 4) : PastOrPair a b ↔ PastOrPair (σ a) (σ b) :=
  ⟨fun pair => match pair with
     | .inl e => .inl (congrArg σ e)
     | .inr (.inl p) => .inr (.inl ((auto.2.2 b a hb ha).mp p))
     | .inr (.inr m) =>
       have ⟨ma, mb, ne⟩ := middle_of_pair m
       .inr (.inr (pair_of_middle (auto_middle auto ma) (auto_middle auto mb)
         (fun same => ne (auto_inj auto ha hb same)))),
   fun pair => match pair with
     | .inl e => .inl (auto_inj auto ha hb e)
     | .inr (.inl p) => .inr (.inl ((auto.2.2 b a hb ha).mpr p))
     | .inr (.inr m) =>
       have ⟨ma, mb, ne⟩ := middle_of_pair m
       .inr (.inr (pair_of_middle (auto_middle_back auto ha ma) (auto_middle_back auto hb mb)
         (fun same => ne (congrArg σ same))))⟩

end Automorphisms

/-- **The relation is neither the past read reflexively nor universal**: it holds of the two
unrelated middle elements, and `3` is not definite as of `1`. -/
theorem pastOrPair_pair :
    PastOrPair 1 2 ∧ ¬ diamond.prec 1 2 ∧ ¬ diamond.prec 2 1 ∧ ¬ PastOrPair 1 3 := by
  decide

/-- `1` and `2` have the same future: each precedes `3` only. -/
theorem future_one_two (k : Nat) : diamond.prec 1 k ↔ diamond.prec 2 k :=
  ⟨fun pair => match pair with
     | .inl ⟨h, _⟩ => absurd h (by decide)
     | .inr ⟨_, e⟩ => .inr ⟨.inr rfl, e⟩,
   fun pair => match pair with
     | .inl ⟨h, _⟩ => absurd h (by decide)
     | .inr ⟨_, e⟩ => .inr ⟨.inl rfl, e⟩⟩

/-- **On the diamond, Wüthrich and Callender's relation is the past with the pair present together
on every course**: on the diamond's elements it holds exactly where the second precedes the first
or the two are in the present at some stage of every course (`together_every_iff`: the same
future). Off the diamond that join need not be their relation (`SameFuture.pastOrTogether_not_trans`). -/
theorem pastOrPair_iff_together {a b : Nat} (ha : a < 4) (hb : b < 4) :
    PastOrPair a b ↔ diamond.prec b a ∨
      ∀ π σ, NaturalLabelling diamond π σ → ∃ t, MaximalBorn diamond π t a ∧ MaximalBorn diamond π t b := by
  constructor
  · intro pair
    rcases pair with e | p | ⟨rfl, rfl⟩ | ⟨rfl, rfl⟩
    · exact .inr ((together_every_iff ordered ha hb).mpr fun k =>
        Eq.subst (motive := fun z => diamond.prec a k ↔ diamond.prec z k) e Iff.rfl)
    · exact .inl p
    · exact .inr ((together_every_iff ordered ha hb).mpr future_one_two)
    · exact .inr ((together_every_iff ordered ha hb).mpr fun k => (future_one_two k).symm)
  · intro h
    rcases h with p | every
    · exact .inr (.inl p)
    · have same := (together_every_iff ordered ha hb).mp every
      have f0 := same 0
      have f1 := same 1
      have f2 := same 2
      have f3 := same 3
      revert f0 f1 f2 f3
      rcases below_four ha with rfl | rfl | rfl | rfl <;>
      rcases below_four hb with rfl | rfl | rfl | rfl <;> decide

/-- So on the diamond's elements the past joined with being present together on every course is
their relation. -/
theorem pastOrTogether_iff {a b : Nat} (ha : a < 4) (hb : b < 4) :
    PastOrTogether diamond a b ↔ PastOrPair a b :=
  (pastOrPair_iff_together ha hb).symm

/-- **Yet the courses disagree on the order of births of that pair**: exchanging the births of `1`
and `2` is a natural labelling. -/
theorem courses_disagree : NaturalLabelling diamond swap12 swap12 ∧ swap12 2 < swap12 1 :=
  ⟨⟨swap12_four, by
     intro i j _ _ _ pair
     rcases pair with ⟨rfl, rfl | rfl | rfl⟩ | ⟨rfl | rfl, rfl⟩ <;> decide⟩, by decide⟩

/-- **Invariance under automorphisms admits a relation that is not what every course has born by
a birth**: Wüthrich and Callender's relation is kept by every automorphism and has `2` definite as
of `1`, while on the labels as they are `2` is born after `1`; what is born no later than an
element on every course is its past, itself included (`past_every_iff`). -/
theorem kept_not_agreed :
    (∀ σ τ, CausalGrowth.Kinds.Relabels diamond diamond σ τ →
      ∀ a b, a < 4 → b < 4 → (PastOrPair a b ↔ PastOrPair (σ a) (σ b))) ∧
    PastOrPair 1 2 ∧ ¬ (∀ π σ, NaturalLabelling diamond π σ → π 2 ≤ π 1) :=
  ⟨fun _ _ auto _ _ ha hb => pastOrPair_kept auto ha hb, pastOrPair_pair.1,
   fun every => absurd (every _ _ (natural_identity diamond)) (by decide)⟩

end Diamond

namespace SameFuture

/-- Four elements: `0` below `1` and `3`, and `1` and `2` below `3`. `1` and `2` have the same
future and different pasts. -/
def sameFuture : Causet := ⟨4, fun a b => (a = 0 ∧ (b = 1 ∨ b = 3)) ∨ ((a = 1 ∨ a = 2) ∧ b = 3)⟩

instance (a b : Nat) : Decidable (sameFuture.prec a b) :=
  inferInstanceAs (Decidable ((a = 0 ∧ (b = 1 ∨ b = 3)) ∨ ((a = 1 ∨ a = 2) ∧ b = 3)))

theorem prec_below {a b : Nat} (pair : sameFuture.prec a b) : a < 4 ∧ b < 4 := by
  rcases pair with ⟨rfl, rfl | rfl⟩ | ⟨rfl | rfl, rfl⟩ <;> decide

theorem ordered : sameFuture.Ordered where
  trans := by
    intro a b c first second
    have ha := (prec_below first).1
    have hb := (prec_below first).2
    have hc := (prec_below second).2
    revert first second
    rcases below_four ha with rfl | rfl | rfl | rfl <;>
    rcases below_four hb with rfl | rfl | rfl | rfl <;>
    rcases below_four hc with rfl | rfl | rfl | rfl <;> decide
  labelled := by
    intro a b pair
    rcases pair with ⟨rfl, rfl | rfl⟩ | ⟨rfl | rfl, rfl⟩ <;> decide
  within := fun pair => (prec_below pair).2

/-- `1` and `2` have the same future: each precedes `3` only. -/
theorem future_one_two (k : Nat) : sameFuture.prec 1 k ↔ sameFuture.prec 2 k :=
  ⟨fun pair => match pair with
     | .inl ⟨h, _⟩ => absurd h (by decide)
     | .inr ⟨_, e⟩ => .inr ⟨.inr rfl, e⟩,
   fun pair => match pair with
     | .inl ⟨h, _⟩ => absurd h (by decide)
     | .inr ⟨_, e⟩ => .inr ⟨.inl rfl, e⟩⟩

/-- **Present together on every course, with different pasts**: `1` and `2` are in the present at
some stage of every course, while `0` precedes `1` and not `2`. So they are not a pair with the same
past and the same future, Wüthrich and Callender's non-Hegelian pair. -/
theorem together_different_pasts :
    (∀ π σ, NaturalLabelling sameFuture π σ →
      ∃ t, MaximalBorn sameFuture π t 1 ∧ MaximalBorn sameFuture π t 2) ∧
      sameFuture.prec 0 1 ∧ ¬ sameFuture.prec 0 2 :=
  ⟨(together_every_iff ordered (show 1 < 4 by decide) (show 2 < 4 by decide)).mpr future_one_two,
   by decide, by decide⟩

/-- **The past joined with being present together on every course is not transitive here**: `2`
is present together with `1` on every course and `0` precedes `1`, while `0` neither precedes `2`
nor is present together with it on every course. -/
theorem pastOrTogether_not_trans :
    PastOrTogether sameFuture 2 1 ∧ PastOrTogether sameFuture 1 0 ∧ ¬ PastOrTogether sameFuture 2 0 :=
  ⟨.inr ((together_every_iff ordered (show 2 < 4 by decide) (show 1 < 4 by decide)).mpr
      fun k => (future_one_two k).symm),
   .inl (by decide),
   fun h => match h with
     | .inl p => absurd p (by decide)
     | .inr every => absurd
         (((together_every_iff ordered (show 2 < 4 by decide) (show 0 < 4 by decide)).mp every 1).mpr
           (by decide))
         (by decide)⟩

end SameFuture

end Presence

end Becoming
