import Becoming.CausalGrowth
import Becoming.OrderNormal

/-!
# The present on causal-set growth: what of presence is the same on every course

The root leaves open whether a condition must still be there when what it conditions arises: the
grammar has no relation of presence in time, and adding one is a choice of model. Causal-set
growth (`Becoming.CausalGrowth`) is a model in which the question can be asked exactly, since its
labels, the order of births, carry no meaning beyond precedence (discrete general covariance,
Rideout and Sorkin 2000). The growth holds its past, so a condition, once born, stays in every
later configuration; the question is whether it is still in the present, on the frontier of what
has been born, when what it conditions is born. This module asks which relations of presence are
the same on every course growing a configuration.

* **Natural labellings.** A renumbering of a causal set's elements keeping precedence (`Natural`)
  gives a causal set of its kind (`relabel_ordered`, `natural_relabels`), every relabelling onto a
  causal set of the same size is one (`natural_of_relabels`), and every causal set is the
  configuration of a course from the empty set (`courseOf_grows`, `courseOf_isomorphic`). So the
  natural labellings are the orders of birth of the courses growing a configuration's kind.
* **Births of unrelated elements commute, and only they.** From a natural labelling, the
  arrangements reached by exchanging consecutive births of unrelated elements are exactly the
  natural labellings (`rearranges_iff_natural`): Mazurkiewicz's theorem of the core
  (`rearranges_iff`), read on growth with joining as precedence either way.
* **A down-set first.** For a test `p` on the first `n` numbers, the stable partition `front`
  (what passes first, then the rest, each in its order) is a renumbering (`front_reindexes`), by
  counting (`count`, `count_reaches`) with its inverse found by `firstWhere`; where `p` is closed
  downward under precedence it is a natural labelling (`front_natural`).
* **What a course has born** by a stage is a stem (`born_closed`, `born_stem`), and with membership
  decided every stem is what some course has born first (`stem_born_first`): Brightwell and
  others' stems are the covariant content of a stage of growth.
* **Born before.** With precedence decided, `i` is born before `j` on every course exactly where
  `i` precedes `j` (`prec_iff_every`), Szpilrajn's theorem read on growth; so what is born no later
  than an element on every course is its past, itself included (`past_every_iff`), the conclusion of
  Stein's theorem read on growth. On some course exactly where the two differ and `j` does not
  precede `i` (`before_some_iff`): two different unrelated elements are born in either order
  (`either_order`), so there is no global now. Without the decision the first law gives
  double-negation elimination (`every_needs_decision`).
* **The present at a stage** (`OnFrontier`: an element born by then, and nothing it precedes is) is
  where the grammar's ending under the one class holds on what is born by then
  (`onFrontier_iff_ends`, `«亡»` under `«一»` read on `bornBy`). It is an antichain
  (`frontier_unrelated`), and with precedence decided every antichain is the present of some course
  at some stage (`frontier_front`, `antichain_present`). Two elements are present together, on the
  frontier at one stage, on some course exactly where neither precedes the other
  (`together_some_iff`), and on every course exactly where they have the same future
  (`together_every_iff`). Present together is not the root's co-presence, 俱有, mutual reach, which
  no two elements of a causal set have.
* **Presence of a condition when what it conditions is born** (`PresentAt`: `i` precedes `j` and
  nothing `i` precedes is born before `j`, so `i` is on the frontier at `j`'s birth,
  `present_iff_frontier`). With precedence decided, `i` is present at `j`'s birth on some course
  exactly where it conditions `j` directly, a link (`present_some_iff_link`), and on every course
  exactly where everything `i` precedes is `j` or above `j` (`present_every_iff`, `Through`), that
  is, where `j` is the one element `i` is linked to (`through_iff_only_link`,
  `present_every_iff_only_link`). Without the decision the second bound gives double-negation
  elimination (`present_every_needs_decision`).
* **Witnesses.** On three elements, `0` below `1` and `2`, `0` is present at `2`'s birth in one
  natural labelling and not in another (`Vee.present_swap`, `Vee.not_present_identity`), and the
  present after two births is `1` on one course and `2` on another (`Vee.frontiers_differ`). On
  Wüthrich and Callender's four elements, `0` below `1` and `2`, both below `3`, their relation,
  each element with itself and its past and the two middle elements with each other, is reflexive
  and transitive, kept by every automorphism, and neither the past read reflexively nor universal
  (`Diamond.pastOrPair_trans`, `Diamond.pastOrPair_kept`, `Diamond.pastOrPair_pair`), while on some
  course `2` is born after `1` and on another before it (`Diamond.kept_not_agreed`,
  `Diamond.courses_disagree`). Read on the growth, it is the past with the pair present together
  on every course, which have the same future (`Diamond.pastOrPair_iff_together`).

So each relation of presence read on a course, born before, present at a birth, present together,
has two bounds every course keeps, what holds on some course and what holds on every course, and
each bound is a relation of precedence; which presence holds between them is a choice of course.
Invariance under automorphisms admits Wüthrich and Callender's relation beside the past; on the
growth it joins what has been born by a birth with a relation of being present together, and both
are read on precedence.

**Modelling choices.** Finite labelled causal sets, discrete births, natural-number labels;
covariance read only as relabelling; presence read as being on the frontier, the maximal elements
of what has been born. Transition probabilities, Bell causality, the continuum limit and infinite
causal sets are not read. Every declaration has an empty axiom report.
-/

namespace Becoming

namespace Presence

open CausalGrowth (Causet Stem links grown grown_size grown_prec_iff course process empty)

/-! ## Counting what a test passes -/

/-- How many of the numbers below `m` pass the test `p`. -/
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

/-- Some number below `n` passes exactly where the count up to `n` is positive. -/
theorem count_pos_iff (p : Nat → Bool) (n : Nat) : 0 < count p n ↔ ∃ y, y < n ∧ p y = true :=
  ⟨fun pos => match count_reaches p n 0 pos with
     | ⟨y, below, passes, _⟩ => ⟨y, below, passes⟩,
   fun ⟨_, below, passes⟩ => Nat.lt_of_le_of_lt (Nat.zero_le _) (count_lt_of passes below)⟩

theorem not_true_of_false {b : Bool} (h : b = false) : (!b) = true :=
  congrArg (fun c => !c) h

theorem not_false_of_true {b : Bool} (h : b = true) : (!b) = false :=
  congrArg (fun c => !c) h

theorem false_of_not_true : ∀ {b : Bool}, (!b) = true → b = false
  | false, _ => rfl

theorem bool_absurd {b : Bool} (h : b = true) (h' : b = false) : False :=
  absurd (h.symm.trans h') (by decide)

theorem bool_or_true : ∀ {a b : Bool}, (a || b) = true ↔ a = true ∨ b = true
  | true, _ => ⟨fun _ => .inl rfl, fun _ => rfl⟩
  | false, _ => ⟨fun h => .inr h, fun h => h.elim (fun e => absurd e (by decide)) id⟩

theorem bool_and_true : ∀ {a b : Bool}, (a && b) = true ↔ a = true ∧ b = true
  | true, _ => ⟨fun h => ⟨rfl, h⟩, fun h => h.2⟩
  | false, _ => ⟨fun h => absurd (show false = true from h) (by decide), fun h => absurd h.1 (by decide)⟩

/-- **What passes and what fails together are all**: below `m`, the numbers passing and the
numbers failing make `m`. -/
theorem count_add_not (p : Nat → Bool) : ∀ m, count p m + count (fun x => !p x) m = m
  | 0 => rfl
  | m + 1 => match h : p m with
    | true =>
      calc count p (m + 1) + count (fun x => !p x) (m + 1)
          = (count p m + 1) + count (fun x => !p x) m :=
            congr (congrArg HAdd.hAdd (count_succ_of_true h))
              (count_succ_of_false (p := fun x => !p x) (not_false_of_true h))
        _ = (count p m + count (fun x => !p x) m) + 1 := Nat.add_right_comm _ _ _
        _ = m + 1 := congrArg (· + 1) (count_add_not p m)
    | false =>
      calc count p (m + 1) + count (fun x => !p x) (m + 1)
          = count p m + (count (fun x => !p x) m + 1) :=
            congr (congrArg HAdd.hAdd (count_succ_of_false h))
              (count_succ_of_true (p := fun x => !p x) (not_true_of_false h))
        _ = m + 1 := congrArg (· + 1) (count_add_not p m)

end Counting

/-! ## A down-set first: the stable partition -/

/-- **The stable partition**: what passes `p` first, in its order, then the rest, in its order. -/
def front (p : Nat → Bool) (n i : Nat) : Nat :=
  cond (p i) (count p i) (count p n + count (fun x => !p x) i)

/-- The element the stable partition takes to `r`: the first below `n` it takes there. -/
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
        (Nat.add_lt_add_left (count_lt_of (p := fun x => !p x) (not_true_of_false h) below) (count p n))
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
    count_inj (p := fun x => !p x) (not_true_of_false h) (not_true_of_false h')
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
      ⟨i, hi, (front_of_false (false_of_not_true fails)).trans
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
            (Nat.add_lt_add_left (count_lt_of (p := fun x => !p x) (not_true_of_false hi) lt) (count p n))
            (Nat.le_of_eq (front_of_false hj).symm))

end Front

/-! ## Natural labellings -/

/-- A **natural labelling** of `c`: a renumbering of its elements keeping precedence, the order of
births of a course growing a configuration of its kind (`natural_relabels`, `courseOf_grows`). -/
def Natural (c : Causet) (π σ : Nat → Nat) : Prop :=
  Reindexes 0 c.size π σ ∧ KeepsOrder c.prec 0 c.size π

section Natural

variable {c : Causet} {π σ : Nat → Nat}

theorem Natural.at (natural : Natural c π σ) {i : Nat} (below : i < c.size) :
    π i < c.size ∧ σ (π i) = i :=
  match natural.1 i (Nat.zero_le i) (lt_zero_add below) with
  | ⟨⟨_, lt, back⟩, _⟩ => ⟨of_lt_zero_add lt, back⟩

theorem Natural.back (natural : Natural c π σ) {j : Nat} (below : j < c.size) :
    σ j < c.size ∧ π (σ j) = j :=
  match natural.1 j (Nat.zero_le j) (lt_zero_add below) with
  | ⟨_, ⟨_, lt, back⟩⟩ => ⟨of_lt_zero_add lt, back⟩

/-- A natural labelling births everything after what precedes it. -/
theorem Natural.before (ordered : c.Ordered) (natural : Natural c π σ) {i j : Nat} (pair : c.prec i j) :
    π i < π j :=
  natural.2 i j (Nat.zero_le i) (lt_zero_add (ordered.within pair)) (ordered.labelled pair) pair

/-- **The labels as they are** are a natural labelling. -/
theorem natural_identity (c : Causet) : Natural c (fun i => i) (fun i => i) :=
  ⟨Reindexes.identity 0 c.size, fun _ _ _ _ lt _ => lt⟩

/-- The configuration of `c` read through `σ`: the label `a` stands for the element `σ a`. -/
def relabel (c : Causet) (σ : Nat → Nat) : Causet :=
  ⟨c.size, fun a b => a < c.size ∧ b < c.size ∧ c.prec (σ a) (σ b)⟩

/-- **A natural labelling gives a causal set.** -/
theorem relabel_ordered (ordered : c.Ordered) (natural : Natural c π σ) : (relabel c σ).Ordered where
  trans := fun first second => match first, second with
    | ⟨ha, _, p⟩, ⟨_, hc, q⟩ => ⟨ha, hc, ordered.trans p q⟩
  labelled := fun {a b} pair => match pair with
    | ⟨ha, hb, p⟩ =>
      Eq.subst (motive := fun k => k < b) (natural.back ha).2
        (Eq.subst (motive := fun k => π (σ a) < k) (natural.back hb).2 (natural.before ordered p))
  within := fun pair => match pair with
    | ⟨_, hb, _⟩ => hb

/-- **Of its kind**: a natural labelling carries `c` onto the causal set it gives. -/
theorem natural_relabels (natural : Natural c π σ) : CausalGrowth.Kinds.Relabels c (relabel c σ) π σ :=
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
    (relabels : CausalGrowth.Kinds.Relabels c c' π σ) : Natural c π σ :=
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

/-- So every causal set, and through a natural labelling every order of its births, is a course's
configuration up to kind. -/
theorem courseOf_isomorphic (ordered : c.Ordered) :
    CausalGrowth.Kinds.Isomorphic c ((courseOf c ordered).state c.size) :=
  ⟨fun i => i, fun i => i,
   fun _ below => ⟨Nat.lt_of_lt_of_le below (Nat.le_of_eq (courseOf_grows ordered).2.1.symm), rfl⟩,
   fun _ below => ⟨Nat.lt_of_lt_of_le below (Nat.le_of_eq (courseOf_grows ordered).2.1), rfl⟩,
   fun i j _ _ => ((courseOf_grows ordered).2.2 i j).symm⟩

end Natural

/-! ## Births of unrelated elements commute, and only they -/

/-- Two elements related either way. -/
def Related (c : Causet) (a b : Nat) : Prop := c.prec a b ∨ c.prec b a

theorem related_symm {c : Causet} (a b : Nat) : Related c a b → Related c b a := Or.symm

/-- **Natural labellings orient every related pair alike.** -/
theorem natural_orients {c : Causet} (ordered : c.Ordered) {π σ π' σ' : Nat → Nat}
    (natural : Natural c π σ) (natural' : Natural c π' σ') : Orients (Related c) 0 c.size π π' :=
  fun _ _ _ _ _ _ rel lt => match rel with
    | .inl p => natural'.before ordered p
    | .inr p => absurd lt (Nat.lt_asymm (natural.before ordered p))

/-- **Births of unrelated elements commute, and only they**: from a natural labelling, the
arrangements reached by exchanging consecutive births of unrelated elements are exactly the
natural labellings. Mazurkiewicz's theorem of the core (`rearranges_iff`), read on growth. -/
theorem rearranges_iff_natural {c : Causet} (ordered : c.Ordered) {π σ π' σ' : Nat → Nat}
    (natural : Natural c π σ) (reindex' : Reindexes 0 c.size π' σ') :
    Rearranges (Related c) 0 c.size π σ π' ↔ Natural c π' σ' :=
  ⟨fun reached => ⟨reindex', fun i j _ below lt pair =>
      Rearranges.orients natural.1 reached i j (Nat.zero_le i) (Nat.lt_trans lt below) (Nat.zero_le j)
        below (.inl pair) (natural.2 i j (Nat.zero_le i) below lt pair)⟩,
   fun natural' => (rearranges_iff related_symm natural.1 reindex').mpr
     (natural_orients ordered natural natural')⟩

/-! ## A down-set first, and what a course has born -/

section Born

variable {c : Causet}

/-- **A down-set first is a natural labelling.** -/
theorem front_natural {p : Nat → Bool} (closed : ∀ {x y}, c.prec x y → p y = true → p x = true) :
    Natural c (front p c.size) (back p c.size) :=
  ⟨front_reindexes, front_keeps closed⟩

/-- **What a course has born is closed downward**: where `y` is born among the first `t` births,
so is everything preceding it. -/
theorem born_closed (ordered : c.Ordered) {π σ : Nat → Nat} (natural : Natural c π σ) {x y t : Nat}
    (pair : c.prec x y) (born : π y < t) : π x < t :=
  Nat.lt_trans (natural.before ordered pair) born

/-- **What a course has born by a stage is a stem**, a past a next element can be born with. -/
theorem born_stem (ordered : c.Ordered) {π σ : Nat → Nat} (natural : Natural c π σ) (t : Nat) :
    Stem c (fun x => x < c.size ∧ π x < t) :=
  ⟨fun born => born.1, fun born pair =>
     ⟨Nat.lt_trans (ordered.labelled pair) (ordered.within pair), born_closed ordered natural pair born.2⟩⟩

/-- **Every stem is what some course has born first** (Brightwell and others' stems): with
membership decided, the down-set first is a natural labelling whose first births, as many as the
stem has elements, are exactly the stem's. -/
theorem stem_born_first {D : Nat → Prop} [∀ x, Decidable (D x)] (stem : Stem c D) :
    Natural c (front (fun x => decide (D x)) c.size) (back (fun x => decide (D x)) c.size) ∧
      ∀ x, x < c.size →
        (front (fun x => decide (D x)) c.size x < count (fun x => decide (D x)) c.size ↔ D x) :=
  ⟨front_natural fun pair inside => decide_eq_true (stem.closed (of_decide_eq_true inside) pair),
   fun _ below => ⟨fun lt => of_decide_eq_true ((front_lt_count_iff below).mp lt),
     fun d => (front_lt_count_iff below).mpr (decide_eq_true d)⟩⟩

end Born

/-! ## Precedence is the order of birth every course agrees on -/

section Every

variable {c : Causet}

/-- The elements preceding `j`, with `j`. -/
def downTo (c : Causet) [∀ a b, Decidable (c.prec a b)] (j : Nat) (x : Nat) : Bool :=
  decide (c.prec x j ∨ x = j)

theorem downTo_closed [∀ a b, Decidable (c.prec a b)] (ordered : c.Ordered) (j : Nat) {x y : Nat}
    (pair : c.prec x y) (inside : downTo c j y = true) : downTo c j x = true :=
  decide_eq_true (match of_decide_eq_true inside with
    | .inl p => .inl (ordered.trans pair p)
    | .inr e => .inl (Eq.subst (motive := fun k => c.prec x k) e pair))

theorem downTo_self [∀ a b, Decidable (c.prec a b)] (j : Nat) : downTo c j j = true :=
  decide_eq_true (.inr rfl)

theorem downTo_other [∀ a b, Decidable (c.prec a b)] {j x : Nat} (np : ¬ c.prec x j) (ne : x ≠ j) :
    downTo c j x = false :=
  decide_eq_false fun inside => inside.elim np ne

/-- **The down-set of `j` first births `j` before everything not preceding it.** -/
theorem downTo_before [∀ a b, Decidable (c.prec a b)] (ordered : c.Ordered) {j x : Nat}
    (hj : j < c.size) (np : ¬ c.prec x j) (ne : x ≠ j) :
    Natural c (front (downTo c j) c.size) (back (downTo c j) c.size) ∧
      front (downTo c j) c.size j < front (downTo c j) c.size x :=
  ⟨front_natural (downTo_closed ordered j), front_true_lt_false (downTo_self j) (downTo_other np ne) hj⟩

/-- **Precedence is the order of birth every course agrees on** (Szpilrajn's theorem read on
growth, the counterpart there of Stein's theorem): with precedence decided, `i` precedes `j`
exactly where `i` is born before `j` in every natural labelling. -/
theorem prec_iff_every [∀ a b, Decidable (c.prec a b)] (ordered : c.Ordered) {i j : Nat}
    (hj : j < c.size) : c.prec i j ↔ ∀ π σ, Natural c π σ → π i < π j :=
  ⟨fun pair _ _ natural => natural.before ordered pair,
   fun every => if pair : c.prec i j then pair else
     match Nat.decEq i j with
     | .isTrue same =>
       absurd (every _ _ (natural_identity c)) (Eq.subst (motive := fun k => ¬ i < k) same (Nat.lt_irrefl i))
     | .isFalse ne =>
       match downTo_before ordered hj pair ne with
       | ⟨natural, lt⟩ => absurd (every _ _ natural) (Nat.lt_asymm lt)⟩

/-- **What is born no later than an element on every course is its past, itself included**
(Stein's conclusion read on growth): with precedence decided, `y` is born no later than `x` in every
natural labelling exactly where `y` is `x` or precedes it. -/
theorem past_every_iff [∀ a b, Decidable (c.prec a b)] (ordered : c.Ordered) {x y : Nat}
    (hx : x < c.size) (hy : y < c.size) :
    (∀ π σ, Natural c π σ → π y ≤ π x) ↔ y = x ∨ c.prec y x :=
  ⟨fun every => match Nat.decEq y x with
     | .isTrue same => .inl same
     | .isFalse ne => .inr ((prec_iff_every ordered hx).mpr fun π σ natural =>
         match Nat.eq_or_lt_of_le (every π σ natural) with
         | .inl same => absurd (((natural.at hy).2.symm.trans (congrArg σ same)).trans (natural.at hx).2) ne
         | .inr lt => lt),
   fun h π _ natural => match h with
     | .inl same => Nat.le_of_eq (congrArg π same)
     | .inr pair => Nat.le_of_lt (natural.before ordered pair)⟩

/-- **No global now**: with precedence decided, two different elements neither of which precedes
the other are born in either order, each on some course. -/
theorem either_order [∀ a b, Decidable (c.prec a b)] (ordered : c.Ordered) {x y : Nat}
    (hx : x < c.size) (hy : y < c.size) (nxy : ¬ c.prec x y) (nyx : ¬ c.prec y x) (ne : x ≠ y) :
    (∃ π σ, Natural c π σ ∧ π x < π y) ∧ (∃ π σ, Natural c π σ ∧ π y < π x) :=
  ⟨match downTo_before ordered hx nyx (fun e => ne e.symm) with
   | ⟨natural, lt⟩ => ⟨_, _, natural, lt⟩,
   match downTo_before ordered hy nxy ne with
   | ⟨natural, lt⟩ => ⟨_, _, natural, lt⟩⟩

/-- **Born before on some course**: with precedence decided, `i` is born before `j` on some course
exactly where they differ and `j` does not precede `i`. -/
theorem before_some_iff [∀ a b, Decidable (c.prec a b)] (ordered : c.Ordered) {i j : Nat}
    (hi : i < c.size) (hj : j < c.size) :
    (∃ π σ, Natural c π σ ∧ π i < π j) ↔ i ≠ j ∧ ¬ c.prec j i :=
  ⟨fun ⟨π, _, natural, lt⟩ =>
     ⟨fun same => Nat.lt_irrefl _ (Eq.subst (motive := fun k => π i < π k) same.symm lt),
      fun pair => Nat.lt_asymm lt (natural.before ordered pair)⟩,
   fun ⟨ne, np⟩ => if pair : c.prec i j then ⟨_, _, natural_identity c, ordered.labelled pair⟩
     else (either_order ordered hi hj pair np ne).1⟩

/-- Two elements, the first preceding the second exactly where `P`. -/
def onlyIf (P : Prop) : Causet := ⟨2, fun a b => a = 0 ∧ b = 1 ∧ P⟩

theorem onlyIf_ordered (P : Prop) : (onlyIf P).Ordered where
  trans := fun first second => match first, second with
    | ⟨_, b1, _⟩, ⟨b0, _, _⟩ => absurd (b1.symm.trans b0) (by decide)
  labelled := fun pair => match pair with
    | ⟨a0, b1, _⟩ => by subst a0; subst b1; decide
  within := fun pair => match pair with
    | ⟨_, b1, _⟩ => by subst b1; exact (show 1 < 2 by decide)

/-- **Without the decision, the law removes double negation**: if, on every causal set, being born
first on every course gave precedence, every proposition not refuted would hold. Agreement across
courses rules out that two births are unrelated; asserting that one conditions the other needs
the decision. -/
theorem every_needs_decision
    (law : ∀ c : Causet, c.Ordered → ∀ i j, i < c.size → j < c.size →
      (∀ π σ, Natural c π σ → π i < π j) → c.prec i j) :
    ∀ P : Prop, ¬ ¬ P → P :=
  fun P nn =>
    have every : ∀ π σ, Natural (onlyIf P) π σ → π 0 < π 1 := fun π σ natural =>
      match Nat.lt_or_ge (π 0) (π 1) with
      | .inl lt => lt
      | .inr ge =>
        have a0 := natural.at (i := 0) (show 0 < 2 by decide)
        have a1 := natural.at (i := 1) (show 1 < 2 by decide)
        match Nat.eq_or_lt_of_le ge with
        | .inl same =>
          absurd ((a1.2.symm.trans (congrArg σ same)).trans a0.2) (by decide)
        | .inr lt => (nn fun p => Nat.lt_asymm lt (natural.before (onlyIf_ordered P) ⟨rfl, rfl, p⟩)).elim
    match law (onlyIf P) (onlyIf_ordered P) 0 1 (show 0 < 2 by decide) (show 1 < 2 by decide) every with
    | ⟨_, _, p⟩ => p

end Every

/-! ## The frontier at a stage -/

/-- What a labelling has born by stage `t`, with the precedence among it: the configuration a
course has grown after `t` births. -/
def bornBy (c : Causet) (π : Nat → Nat) (t : Nat) : «际» Nat := fun x y => c.prec x y ∧ π y < t

/-- `x` is **on the frontier at stage `t`** of the labelling `π`: an element born by then, and
nothing it precedes is. -/
def OnFrontier (c : Causet) (π : Nat → Nat) (t x : Nat) : Prop :=
  x < c.size ∧ π x < t ∧ ∀ k, c.prec x k → t ≤ π k

/-- **The frontier is where the grammar's ending holds on what is born**: `x` is on the frontier at
stage `t` exactly where it is born by then and, read on what is born by then, ends under the one
class (`«亡»` under `«一»`). -/
theorem onFrontier_iff_ends (c : Causet) (π : Nat → Nat) (t x : Nat) :
    OnFrontier c π t x ↔ x < c.size ∧ π x < t ∧ «亡» (bornBy c π t) «一» x :=
  ⟨fun ⟨hx, born, after⟩ => ⟨hx, born, fun ⟨y, ⟨pair, lt⟩, _⟩ =>
      Nat.lt_irrefl _ (Nat.lt_of_le_of_lt (after y pair) lt)⟩,
   fun ⟨hx, born, ends⟩ => ⟨hx, born, fun k pair => match Nat.lt_or_ge (π k) t with
      | .inl lt => (ends ⟨k, ⟨pair, lt⟩, trivial⟩).elim
      | .inr ge => ge⟩⟩

/-- **The present at a stage is an antichain**: of two elements on the frontier at one stage,
neither precedes the other. -/
theorem frontier_unrelated {c : Causet} {π : Nat → Nat} {t x y : Nat} (fx : OnFrontier c π t x)
    (fy : OnFrontier c π t y) : ¬ c.prec x y :=
  fun pair => Nat.lt_irrefl _ (Nat.lt_of_lt_of_le fy.2.1 (fx.2.2 y pair))

/-- **The present of a stem**: on the course bearing first what a test passes, after as many births
as pass, the frontier is exactly the passing elements that precede nothing passing. -/
theorem frontier_front {c : Causet} (ordered : c.Ordered) (d : Nat → Bool) {x : Nat} :
    OnFrontier c (front d c.size) (count d c.size) x ↔
      x < c.size ∧ d x = true ∧ ∀ k, c.prec x k → d k = false :=
  ⟨fun ⟨hx, born, after⟩ => ⟨hx, (front_lt_count_iff hx).mp born, fun k pair =>
      match h : d k with
      | true =>
        absurd ((front_lt_count_iff (ordered.within pair)).mpr h) (Nat.not_lt_of_le (after k pair))
      | false => rfl⟩,
   fun ⟨hx, passes, top⟩ => ⟨hx, (front_lt_count_iff hx).mpr passes, fun k pair =>
      match Nat.lt_or_ge (front d c.size k) (count d c.size) with
      | .inl lt => (bool_absurd ((front_lt_count_iff (ordered.within pair)).mp lt) (top k pair)).elim
      | .inr ge => ge⟩⟩

section Antichains

variable {c : Causet} [∀ a b, Decidable (c.prec a b)]

/-- What a test passes, with everything preceding it. -/
def downOf (c : Causet) [∀ a b, Decidable (c.prec a b)] (q : Nat → Bool) (x : Nat) : Bool :=
  q x || decide (0 < count (fun y => q y && decide (c.prec x y)) c.size)

theorem downOf_iff (q : Nat → Bool) (x : Nat) :
    downOf c q x = true ↔ q x = true ∨ ∃ y, y < c.size ∧ q y = true ∧ c.prec x y :=
  ⟨fun h => match bool_or_true.mp h with
     | .inl passes => .inl passes
     | .inr found => match (count_pos_iff _ c.size).mp (of_decide_eq_true found) with
       | ⟨y, below, both⟩ => match bool_and_true.mp both with
         | ⟨passes, pair⟩ => .inr ⟨y, below, passes, of_decide_eq_true pair⟩,
   fun h => bool_or_true.mpr (match h with
     | .inl passes => .inl passes
     | .inr ⟨y, below, passes, pair⟩ =>
       .inr (decide_eq_true ((count_pos_iff _ c.size).mpr
         ⟨y, below, bool_and_true.mpr ⟨passes, decide_eq_true pair⟩⟩)))⟩

/-- **Every antichain is a present**: with precedence decided, the elements a test passes, none
preceding another, are exactly the frontier of some course at some stage, the course bearing first
them and what precedes them. -/
theorem antichain_present (ordered : c.Ordered) (q : Nat → Bool)
    (inside : ∀ {x}, q x = true → x < c.size)
    (apart : ∀ {x y}, q x = true → q y = true → ¬ c.prec x y) :
    ∃ π σ t, Natural c π σ ∧ ∀ x, OnFrontier c π t x ↔ q x = true :=
  ⟨_, _, _, front_natural fun pair below => (downOf_iff q _).mpr (match (downOf_iff q _).mp below with
      | .inl passes => .inr ⟨_, ordered.within pair, passes, pair⟩
      | .inr ⟨z, hz, passes, second⟩ => .inr ⟨z, hz, passes, ordered.trans pair second⟩),
   fun x => ⟨fun present => match (frontier_front ordered (downOf c q)).mp present with
      | ⟨_, down, top⟩ => match (downOf_iff q x).mp down with
        | .inl passes => passes
        | .inr ⟨y, _, passes, pair⟩ => (bool_absurd ((downOf_iff q y).mpr (.inl passes)) (top y pair)).elim,
    fun passes => (frontier_front ordered (downOf c q)).mpr
      ⟨inside passes, (downOf_iff q x).mpr (.inl passes), fun k pair => match h : downOf c q k with
        | true => (match (downOf_iff q k).mp h with
          | .inl passes' => apart passes passes' pair
          | .inr ⟨_, _, passes', second⟩ => apart passes passes' (ordered.trans pair second)).elim
        | false => rfl⟩⟩⟩

/-- **Present together on some course exactly where unrelated**: with precedence decided, two
elements are on the frontier together at some stage of some course exactly where neither precedes
the other. -/
theorem together_some_iff (ordered : c.Ordered) {x y : Nat} :
    (∃ π σ t, Natural c π σ ∧ OnFrontier c π t x ∧ OnFrontier c π t y) ↔
      x < c.size ∧ y < c.size ∧ ¬ c.prec x y ∧ ¬ c.prec y x :=
  ⟨fun ⟨_, _, _, _, fx, fy⟩ => ⟨fx.1, fy.1, frontier_unrelated fx fy, frontier_unrelated fy fx⟩,
   fun ⟨hx, hy, nxy, nyx⟩ =>
     have member : ∀ {z}, (Nat.beq z x || Nat.beq z y) = true → z = x ∨ z = y := fun h =>
       match bool_or_true.mp h with
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
     match antichain_present ordered (fun z => Nat.beq z x || Nat.beq z y) inside apart with
     | ⟨π, σ, t, natural, present⟩ =>
       ⟨π, σ, t, natural, (present x).mpr (bool_or_true.mpr (.inl (beq_self x))),
        (present y).mpr (bool_or_true.mpr (.inr (beq_self y)))⟩⟩

/-- What two elements present together on every course share: whatever the first precedes, the
second does. -/
theorem future_of_together_every (ordered : c.Ordered) {x y : Nat}
    (every : ∀ π σ, Natural c π σ → ∃ t, OnFrontier c π t x ∧ OnFrontier c π t y) {k : Nat}
    (first : c.prec x k) : c.prec y k :=
  if later : c.prec y k then later else
    match every _ _ (natural_identity c) with
    | ⟨_, fx, fy⟩ =>
      have ne : y ≠ k := fun e =>
        frontier_unrelated fx fy (Eq.subst (motive := fun z => c.prec x z) e.symm first)
      match downTo_before ordered (ordered.within first) later ne with
      | ⟨natural, lt⟩ => match every _ _ natural with
        | ⟨t, ⟨_, _, after⟩, ⟨_, born, _⟩⟩ =>
          absurd (Nat.lt_of_le_of_lt (after k first) (Nat.lt_trans lt born)) (Nat.lt_irrefl t)

/-- **Present together on every course exactly where they have the same future**: with precedence
decided, two elements are on the frontier together at some stage of every course exactly where
each precedes what the other does. -/
theorem together_every_iff (ordered : c.Ordered) {x y : Nat} (hx : x < c.size) (hy : y < c.size) :
    (∀ π σ, Natural c π σ → ∃ t, OnFrontier c π t x ∧ OnFrontier c π t y) ↔
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

end Antichains

/-! ## Presence of a condition when what it conditions is born -/

/-- `i` is **present at `j`'s birth** in the labelling `π`: `i` precedes `j`, and nothing `i`
precedes is born before `j`, so `i` is on the frontier when `j` is born. -/
def PresentAt (c : Causet) (π : Nat → Nat) (i j : Nat) : Prop :=
  c.prec i j ∧ ∀ k, c.prec i k → π j ≤ π k

/-- Everything `i` precedes is `j` or above `j`: every line from `i` passes through `j`. -/
def Through (c : Causet) (i j : Nat) : Prop :=
  ∀ k, c.prec i k → k = j ∨ c.prec j k

section Present

variable {c : Causet}

/-- **A condition every line from which passes through what it conditions conditions it
directly.** -/
theorem link_of_through (ordered : c.Ordered) {i j : Nat} (pair : c.prec i j) (through : Through c i j) :
    links c.prec i j :=
  ⟨pair, fun z ⟨first, second⟩ => match through z first with
    | .inl e => ordered.irrefl j (Eq.subst (motive := fun k => c.prec k j) e second)
    | .inr p => ordered.irrefl j (ordered.trans p second)⟩

/-- **Presence is being on the frontier when what one conditions is born**: in a natural labelling,
`i` is present at `j`'s birth exactly where `i` precedes `j` and is on the frontier at `j`'s stage. -/
theorem present_iff_frontier (ordered : c.Ordered) {π σ : Nat → Nat} (natural : Natural c π σ)
    {i j : Nat} : PresentAt c π i j ↔ c.prec i j ∧ OnFrontier c π (π j) i :=
  ⟨fun ⟨pair, after⟩ =>
     ⟨pair, Nat.lt_trans (ordered.labelled pair) (ordered.within pair), natural.before ordered pair, after⟩,
   fun ⟨pair, _, _, after⟩ => ⟨pair, after⟩⟩

/-- **A condition can be present when what it conditions is born exactly where it conditions it
directly**: with precedence decided, `i` is present at `j`'s birth in some natural labelling
exactly where `i` is a link below `j`. -/
theorem present_some_iff_link [∀ a b, Decidable (c.prec a b)] (ordered : c.Ordered) {i j : Nat}
    (hj : j < c.size) :
    (∃ π σ, Natural c π σ ∧ PresentAt c π i j) ↔ links c.prec i j :=
  ⟨fun ⟨_, _, natural, pair, after⟩ => ⟨pair, fun z ⟨first, second⟩ =>
      Nat.lt_irrefl _ (Nat.lt_of_le_of_lt (after z first) (natural.before ordered second))⟩,
   fun ⟨pair, direct⟩ => ⟨_, _, front_natural (downTo_closed ordered j), pair, fun k first =>
      match hk : downTo c j k with
      | true => match of_decide_eq_true hk with
        | .inl second => (direct k ⟨first, second⟩).elim
        | .inr e => Nat.le_of_eq (congrArg (front (downTo c j) c.size) e.symm)
      | false => Nat.le_of_lt (front_true_lt_false (downTo_self j) hk hj)⟩⟩

/-- **A condition must be present when what it conditions is born exactly where every line from
it passes through what it conditions**: with precedence decided, `i` is present at `j`'s birth in
every natural labelling exactly where `i` precedes `j` and everything `i` precedes is `j` or above
`j`. -/
theorem present_every_iff [∀ a b, Decidable (c.prec a b)] (ordered : c.Ordered) {i j : Nat} :
    (∀ π σ, Natural c π σ → PresentAt c π i j) ↔ c.prec i j ∧ Through c i j :=
  ⟨fun every => ⟨(every _ _ (natural_identity c)).1, fun k first =>
      match Nat.decEq k j with
      | .isTrue e => .inl e
      | .isFalse ne => if later : c.prec j k then .inr later else
        match downTo_before ordered (ordered.within first) later (fun e => ne e.symm) with
        | ⟨natural, lt⟩ => absurd ((every _ _ natural).2 k first) (Nat.not_le_of_lt lt)⟩,
   fun ⟨pair, through⟩ π _ natural => ⟨pair, fun k first => match through k first with
      | .inl e => Nat.le_of_eq (congrArg π e.symm)
      | .inr later => Nat.le_of_lt (natural.before ordered later)⟩⟩

/-- **Every line from `i` passes through `j` exactly where `j` is the one element `i` is linked
to**: with precedence decided, the necessary bound read on links. -/
theorem through_iff_only_link [∀ a b, Decidable (c.prec a b)] (ordered : c.Ordered) {i j : Nat} :
    (c.prec i j ∧ Through c i j) ↔ links c.prec i j ∧ ∀ k, links c.prec i k → k = j :=
  ⟨fun ⟨pair, through⟩ => ⟨link_of_through ordered pair through, fun k link =>
      match through k link.1 with
      | .inl e => e
      | .inr later => (link.2 j ⟨pair, later⟩).elim⟩,
   fun ⟨link, only⟩ => ⟨link.1, fun k first =>
      match (CausalGrowth.ordered_reach_links_iff ordered).mpr first with
      | .one step => .inl (only k step)
      | .more step rest =>
        .inr (Eq.subst (motive := fun z => c.prec z k) (only _ step)
          (CausalGrowth.reach_links_le (O := c.prec) ordered.trans rest))⟩⟩

/-- So **a condition is present at the birth of what it conditions on every course exactly where
that is the one element it is linked to.** -/
theorem present_every_iff_only_link [∀ a b, Decidable (c.prec a b)] (ordered : c.Ordered) {i j : Nat} :
    (∀ π σ, Natural c π σ → PresentAt c π i j) ↔ links c.prec i j ∧ ∀ k, links c.prec i k → k = j :=
  (present_every_iff ordered).trans (through_iff_only_link ordered)

end Present

/-- Three elements: `0` below `1` and `2`, and `1` below `2` exactly where `P`. -/
def throughIf (P : Prop) : Causet :=
  ⟨3, fun a b => (a = 0 ∧ (b = 1 ∨ b = 2)) ∨ (a = 1 ∧ b = 2 ∧ P)⟩

theorem throughIf_ordered (P : Prop) : (throughIf P).Ordered where
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

/-- **Without the decision, the necessary bound removes double negation**: if, on every causal
set, a condition present at the birth of what it conditions on every course had every line from it
pass through that, every proposition not refuted would hold. Presence on every course rules out
that a line from the condition avoids what it conditions; asserting that the line passes through
needs the decision. -/
theorem present_every_needs_decision
    (law : ∀ c : Causet, c.Ordered → ∀ i j, (∀ π σ, Natural c π σ → PresentAt c π i j) → Through c i j) :
    ∀ P : Prop, ¬ ¬ P → P :=
  fun P nn =>
    have every : ∀ π σ, Natural (throughIf P) π σ → PresentAt (throughIf P) π 0 1 := fun π σ natural =>
      have a1 := natural.at (i := 1) (show 1 < 3 by decide)
      have a2 := natural.at (i := 2) (show 2 < 3 by decide)
      have le : π 1 ≤ π 2 := match Nat.lt_or_ge (π 1) (π 2) with
        | .inl lt => Nat.le_of_lt lt
        | .inr ge => match Nat.eq_or_lt_of_le ge with
          | .inl same => absurd ((a2.2.symm.trans (congrArg σ same)).trans a1.2) (by decide)
          | .inr lt =>
            (nn fun p => Nat.lt_asymm lt (natural.before (throughIf_ordered P) (.inr ⟨rfl, rfl, p⟩))).elim
      ⟨.inl ⟨rfl, .inl rfl⟩, fun k pair => match pair with
        | .inl ⟨_, .inl k1⟩ => Nat.le_of_eq (congrArg π k1.symm)
        | .inl ⟨_, .inr k2⟩ => Eq.subst (motive := fun z => π 1 ≤ π z) k2.symm le
        | .inr ⟨h, _, _⟩ => absurd h (by decide)⟩
    match law (throughIf P) (throughIf_ordered P) 0 1 every 2 (.inl ⟨rfl, .inr rfl⟩) with
    | .inl e => absurd e (by decide)
    | .inr pair => match pair with
      | .inl ⟨h, _⟩ => absurd h (by decide)
      | .inr ⟨_, _, p⟩ => p

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
theorem natural_swap : Natural vee swap12 swap12 :=
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

/-- So `0` is a link below `2` (`present_some_iff_link`) ... -/
theorem link : links vee.prec 0 2 :=
  (present_some_iff_link ordered (j := 2) (by decide)).mp ⟨_, _, natural_swap, present_swap⟩

/-- ... and not every line from `0` passes through `2` (`present_every_iff`). -/
theorem not_through : ¬ Through vee 0 2 :=
  fun through => not_present_identity
    ((present_every_iff ordered).mpr ⟨⟨rfl, .inr rfl⟩, through⟩ _ _ (natural_identity vee))

/-- **The present after two births is a choice of course**: on the labels as they are it is `1`;
exchanging the births of `1` and `2`, it is `2`. -/
theorem frontiers_differ :
    OnFrontier vee (fun i => i) 2 1 ∧ ¬ OnFrontier vee (fun i => i) 2 2 ∧
      OnFrontier vee swap12 2 2 ∧ ¬ OnFrontier vee swap12 2 1 :=
  ⟨⟨by decide, by decide, fun _ pair => absurd pair.1 (by decide)⟩,
   fun ⟨_, born, _⟩ => absurd born (by decide),
   ⟨by decide, by decide, fun _ pair => absurd pair.1 (by decide)⟩,
   fun ⟨_, born, _⟩ => absurd born (by decide)⟩

end Vee

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

/-- **Read on the growth, Wüthrich and Callender's relation is the past with the pairs present
together on every course**: on the diamond's elements it holds exactly where the second precedes
the first or the two are on the frontier together at some stage of every course
(`together_every_iff`: the same future). -/
theorem pastOrPair_iff_together {a b : Nat} (ha : a < 4) (hb : b < 4) :
    PastOrPair a b ↔ diamond.prec b a ∨
      ∀ π σ, Natural diamond π σ → ∃ t, OnFrontier diamond π t a ∧ OnFrontier diamond π t b := by
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

/-- **Yet the courses disagree on the order of births of that pair**: exchanging the births of `1`
and `2` is a natural labelling. -/
theorem courses_disagree : Natural diamond swap12 swap12 ∧ swap12 2 < swap12 1 :=
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
    PastOrPair 1 2 ∧ ¬ (∀ π σ, Natural diamond π σ → π 2 ≤ π 1) :=
  ⟨fun _ _ auto _ _ ha hb => pastOrPair_kept auto ha hb, pastOrPair_pair.1,
   fun every => absurd (every _ _ (natural_identity diamond)) (by decide)⟩

end Diamond

end Presence

end Becoming
