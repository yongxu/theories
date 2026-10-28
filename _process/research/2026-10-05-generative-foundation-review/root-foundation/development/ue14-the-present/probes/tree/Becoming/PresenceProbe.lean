import Becoming.Presence
import Becoming.Frontier

/-!
# Probes for the review of UE14 (`Becoming.Presence`)

AI-written probes for an independent review; not a module of the package. Every declaration has
an empty axiom report.

* **Tables.** Every test on the first `n` numbers has a table doubly negated (`table_not_not`), and
  a decided test has one (`table_of`); a table of a test closed downward gives a natural labelling
  (`natural_of_table`).
* **The laws on every course.** With no decision, born before on every course is exactly
  precedence not refuted (`every_iff_not_not`), and present together on every course is exactly
  the same future doubly negated (`together_every_iff_not_not`). Passing from these to precedence
  and to the same future is, on every causal set, exactly excluded middle (`every_iff_em`,
  `together_every_iff_em`), and `past_every_iff` from left to right gives it
  (`past_every_needs_decision`).
* **Presence on every course is the one link, with no decision**
  (`present_every_iff_only_link_undecided`); the decision lies in passing from the one link to
  everything above `i` being `j` or above `j` (`only_link_through_iff_em`,
  `present_through_iff_em`).
* **The laws on some course** hold with precedence only weakly decided, and on every causal set
  are exactly weak excluded middle (`before_some_iff_weakly`, `either_order_iff_weakly`,
  `together_some_iff_weakly`, `antichain_present_iff_weakly`, `present_some_iff_weakly`).
* **The orders of birth** as one theorem (`orders_of_birth`); natural labellings depend only on
  size and precedence (`natural_congr`), and so does what holds on every or on some course
  (`every_congr`, `some_congr`); the past is the largest relation every course respects
  (`past_largest`); the frontier is the core's frontier (`onFrontier_iff_frontier`).
* **Witnesses.** The vee's present after two births, exactly (`present_after_two_identity`,
  `present_after_two_swap`); four elements on which the growth reading of Wüthrich and Callender's
  relation is not transitive (`SameFuture.pastOrTogether_not_trans`).
-/

namespace Becoming

namespace Presence

namespace Probe

open CausalGrowth (Causet links process empty)

/-! ## Tables of a test -/

/-- `f` tabulates `Q` on the numbers below `n`. -/
def Tabulates (f : Nat → Bool) (Q : Nat → Prop) (n : Nat) : Prop :=
  ∀ x, x < n → (f x = true ↔ Q x)

theorem beq_false_of_ne {a b : Nat} (ne : a ≠ b) : Nat.beq a b = false :=
  match h : Nat.beq a b with
  | true => absurd (Nat.eq_of_beq_eq_true h) ne
  | false => rfl

theorem table_yes {Q : Nat → Prop} {n : Nat} {f : Nat → Bool} (spec : Tabulates f Q n) (yes : Q n) :
    Tabulates (fun x => Nat.beq x n || f x) Q (n + 1) :=
  fun x below => match Nat.decEq x n with
  | .isTrue e => by
    subst e
    exact ⟨fun _ => yes, fun _ => bool_or_true.mpr (.inl (beq_self _))⟩
  | .isFalse ne =>
    have lt := lt_of_le_ne (Nat.le_of_lt_succ below) ne
    ⟨fun h => (spec x lt).mp (match bool_or_true.mp h with
        | .inl e => absurd (Nat.eq_of_beq_eq_true e) ne
        | .inr t => t),
     fun q => bool_or_true.mpr (.inr ((spec x lt).mpr q))⟩

theorem table_no {Q : Nat → Prop} {n : Nat} {f : Nat → Bool} (spec : Tabulates f Q n) (no : ¬ Q n) :
    Tabulates (fun x => !(Nat.beq x n) && f x) Q (n + 1) :=
  fun x below => match Nat.decEq x n with
  | .isTrue e => by
    subst e
    exact ⟨fun h => (bool_absurd (beq_self _) (false_of_not_true (bool_and_true.mp h).1)).elim,
      fun q => absurd q no⟩
  | .isFalse ne =>
    have lt := lt_of_le_ne (Nat.le_of_lt_succ below) ne
    ⟨fun h => (spec x lt).mp (bool_and_true.mp h).2,
     fun q => bool_and_true.mpr ⟨not_true_of_false (beq_false_of_ne ne), (spec x lt).mpr q⟩⟩

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
    Natural c (front f c.size) (back f c.size) :=
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

/-! ## The laws on every course: excluded middle, and with no decision doubly negated -/

/-- **Born before on every course, precedence is not refuted**, with no decision. -/
theorem every_not_not {c : Causet} (ordered : c.Ordered) {i j : Nat} (hi : i < c.size)
    (hj : j < c.size) (every : ∀ π σ, Natural c π σ → π i < π j) : ¬ ¬ c.prec i j :=
  fun np => match Nat.decEq i j with
  | .isTrue same =>
    Nat.lt_irrefl i (Eq.subst (motive := fun k => i < k) same.symm (every _ _ (natural_identity c)))
  | .isFalse ne => table_not_not (fun x => c.prec x j ∨ x = j) c.size fun ⟨_, spec⟩ =>
    Nat.lt_asymm (every _ _ (natural_of_table ordered spec (down_closed ordered j)))
      (front_true_lt_false ((spec j hj).mpr (.inr rfl))
        (table_false (spec i hi) fun inside => inside.elim np ne) hj)

/-- **So born before on every course is exactly precedence not refuted**, with no decision. -/
theorem every_iff_not_not {c : Causet} (ordered : c.Ordered) {i j : Nat} (hi : i < c.size)
    (hj : j < c.size) : (∀ π σ, Natural c π σ → π i < π j) ↔ ¬ ¬ c.prec i j :=
  ⟨every_not_not ordered hi hj, fun nn π _ natural => match Nat.lt_or_ge (π i) (π j) with
    | .inl lt => lt
    | .inr ge => (nn fun pair => Nat.not_le_of_lt (natural.before ordered pair) ge).elim⟩

/-- **The law `every_needs_decision` assumes is, on every causal set, exactly excluded middle.** -/
theorem every_iff_em :
    (∀ c : Causet, c.Ordered → ∀ i j, i < c.size → j < c.size →
      (∀ π σ, Natural c π σ → π i < π j) → c.prec i j) ↔ ∀ p : Prop, Decided p :=
  ⟨fun law p => every_needs_decision law _ (not_not_decided p),
   fun em _ ordered _ _ hi hj every => (em _).of_not_not (every_not_not ordered hi hj every)⟩

/-- **`past_every_iff` from left to right, on every causal set, gives excluded middle too**: it
gives the law of `prec_iff_every`. -/
theorem past_every_needs_decision
    (law : ∀ c : Causet, c.Ordered → ∀ x y, x < c.size → y < c.size →
      (∀ π σ, Natural c π σ → π y ≤ π x) → y = x ∨ c.prec y x) :
    ∀ p : Prop, Decided p :=
  every_iff_em.mp fun c ordered i j hi hj every =>
    match law c ordered j i hj hi fun π σ natural => Nat.le_of_lt (every π σ natural) with
    | .inl same => absurd (every _ _ (natural_identity c))
        (Eq.subst (motive := fun k => ¬ k < j) same.symm (Nat.lt_irrefl j))
    | .inr pair => pair

/-- **Present at `j`'s birth on every course, everything `i` precedes is, doubly negated, `j` or
above `j`**, with no decision. -/
theorem through_not_not {c : Causet} (ordered : c.Ordered) {i j : Nat}
    (every : ∀ π σ, Natural c π σ → PresentAt c π i j) {k : Nat} (first : c.prec i k) :
    ¬ ¬ (k = j ∨ c.prec j k) :=
  fun no => table_not_not (fun x => c.prec x k ∨ x = k) c.size fun ⟨_, spec⟩ =>
    Nat.not_le_of_lt
      (front_true_lt_false ((spec k (ordered.within first)).mpr (.inr rfl))
        (table_false (spec j (ordered.within (every _ _ (natural_identity c)).1))
          fun inside => inside.elim (fun p => no (.inr p)) (fun e => no (.inl e.symm)))
        (ordered.within first))
      ((every _ _ (natural_of_table ordered spec (down_closed ordered k))).2 k first)

/-- **The law `present_every_needs_decision` assumes is, on every causal set, exactly excluded
middle.** -/
theorem present_through_iff_em :
    (∀ c : Causet, c.Ordered → ∀ i j, (∀ π σ, Natural c π σ → PresentAt c π i j) → Through c i j) ↔
      ∀ p : Prop, Decided p :=
  ⟨fun law p => present_every_needs_decision law _ (not_not_decided p),
   fun em _ ordered _ _ every _ first => (em _).of_not_not (through_not_not ordered every first)⟩

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

/-- **`together_every_iff` from left to right, on every causal set, removes double negation**:
on `apartIf p`, `0` and `1` are present together on every course wherever `p` is not refuted, and
the law then gives that `1` precedes `2`. -/
theorem together_every_needs_decision
    (law : ∀ c : Causet, c.Ordered → ∀ x y, x < c.size → y < c.size →
      (∀ π σ, Natural c π σ → ∃ t, OnFrontier c π t x ∧ OnFrontier c π t y) →
      ∀ k, c.prec x k → c.prec y k) :
    ∀ p : Prop, ¬ ¬ p → p :=
  fun p nn =>
    have ordered := apartIf_ordered p
    have every : ∀ π σ, Natural (apartIf p) π σ →
        ∃ t, OnFrontier (apartIf p) π t 0 ∧ OnFrontier (apartIf p) π t 1 := fun π σ natural =>
      have a1 := natural.at (i := 1) (show 1 < 3 by decide)
      have a2 := natural.at (i := 2) (show 2 < 3 by decide)
      have l02 : π 0 < π 2 := natural.before ordered (.inl ⟨rfl, rfl⟩)
      have l12 : π 1 < π 2 := match Nat.lt_or_ge (π 1) (π 2) with
        | .inl lt => lt
        | .inr ge => match Nat.eq_or_lt_of_le ge with
          | .inl same => absurd ((a2.2.symm.trans (congrArg σ same)).trans a1.2) (by decide)
          | .inr lt => (nn fun hp => Nat.lt_asymm lt (natural.before ordered (.inr ⟨rfl, rfl, hp⟩))).elim
      have both : ∀ t, π 0 < t → π 1 < t → t ≤ π 2 →
          OnFrontier (apartIf p) π t 0 ∧ OnFrontier (apartIf p) π t 1 := fun t b0 b1 le2 =>
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

/-- **Present together on every course, whatever the first precedes the second, doubly negated,
precedes too**, with no decision. -/
theorem together_not_not {c : Causet} (ordered : c.Ordered) {x y : Nat}
    (every : ∀ π σ, Natural c π σ → ∃ t, OnFrontier c π t x ∧ OnFrontier c π t y) {k : Nat}
    (first : c.prec x k) : ¬ ¬ c.prec y k :=
  fun later => match every _ _ (natural_identity c) with
  | ⟨_, fx, fy⟩ =>
    have ne : y ≠ k := fun e =>
      frontier_unrelated fx fy (Eq.subst (motive := fun z => c.prec x z) e.symm first)
    table_not_not (fun z => c.prec z k ∨ z = k) c.size fun ⟨_, spec⟩ =>
      match every _ _ (natural_of_table ordered spec (down_closed ordered k)) with
      | ⟨t, ⟨_, _, after⟩, ⟨_, born, _⟩⟩ =>
        Nat.lt_irrefl t (Nat.lt_of_le_of_lt (after k first)
          (Nat.lt_trans (front_true_lt_false ((spec k (ordered.within first)).mpr (.inr rfl))
            (table_false (spec y fy.1) fun inside => inside.elim later ne) (ordered.within first)) born))

/-- **So present together on every course is exactly the same future doubly negated**, with no
decision. -/
theorem together_every_iff_not_not {c : Causet} (ordered : c.Ordered) {x y : Nat} (hx : x < c.size)
    (hy : y < c.size) :
    (∀ π σ, Natural c π σ → ∃ t, OnFrontier c π t x ∧ OnFrontier c π t y) ↔
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

/-- **`together_every_iff` from left to right, on every causal set, is exactly excluded middle.** -/
theorem together_every_iff_em :
    (∀ c : Causet, c.Ordered → ∀ x y, x < c.size → y < c.size →
      (∀ π σ, Natural c π σ → ∃ t, OnFrontier c π t x ∧ OnFrontier c π t y) →
      ∀ k, c.prec x k → c.prec y k) ↔ ∀ p : Prop, Decided p :=
  ⟨fun law p => together_every_needs_decision law _ (not_not_decided p),
   fun em _ ordered _ _ _ _ every _ first => (em _).of_not_not (together_not_not ordered every first)⟩

/-! ## Presence on every course is the one link, with no decision -/

/-- Where `j` is the one element `i` is linked to, everything `i` precedes is, doubly negated, `j`
or above `j`: by the elements below it. -/
theorem through_of_only_not_not {c : Causet} (ordered : c.Ordered) {i j : Nat}
    (only : ∀ k, links c.prec i k → k = j) :
    ∀ n k, k < n → c.prec i k → ¬ ¬ (k = j ∨ c.prec j k)
  | 0, _, below, _ => absurd below (Nat.not_lt_zero _)
  | n + 1, k, below, first => fun no =>
    not_not_decided (∃ z, c.prec i z ∧ c.prec z k) fun decided => match decided with
    | .inl ⟨z, iz, zk⟩ =>
      through_of_only_not_not ordered only n z
        (Nat.lt_of_lt_of_le (ordered.labelled zk) (Nat.le_of_lt_succ below)) iz fun h => match h with
        | .inl e => no (.inr (Eq.subst (motive := fun w => c.prec w k) e zk))
        | .inr jz => no (.inr (ordered.trans jz zk))
    | .inr direct => no (.inl (only k ⟨first, fun z between => direct ⟨z, between⟩⟩))

theorem present_every_of_only_link {c : Causet} (ordered : c.Ordered) {i j : Nat}
    (link : links c.prec i j) (only : ∀ k, links c.prec i k → k = j) :
    ∀ π σ, Natural c π σ → PresentAt c π i j :=
  fun π _ natural => ⟨link.1, fun k first => match Nat.lt_or_ge (π k) (π j) with
    | .inr ge => ge
    | .inl lt => (through_of_only_not_not ordered only (k + 1) k (Nat.lt_succ_self k) first fun h =>
        match h with
        | .inl e => Nat.lt_irrefl (π j) (Eq.subst (motive := fun z => π z < π j) e lt)
        | .inr later => Nat.lt_asymm lt (natural.before ordered later)).elim⟩

theorem only_link_of_present_every {c : Causet} (ordered : c.Ordered) {i j : Nat}
    (every : ∀ π σ, Natural c π σ → PresentAt c π i j) :
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

/-- **Present at `j`'s birth on every course exactly where `j` is the one element `i` is linked
to, with precedence undecided**: `present_every_iff_only_link` with no instance. -/
theorem present_every_iff_only_link_undecided {c : Causet} (ordered : c.Ordered) {i j : Nat} :
    (∀ π σ, Natural c π σ → PresentAt c π i j) ↔ links c.prec i j ∧ ∀ k, links c.prec i k → k = j :=
  ⟨only_link_of_present_every ordered,
   fun ⟨link, only⟩ => present_every_of_only_link ordered link only⟩

/-- **The decision lies in passing from the one link to `Through`**: that, on every causal set,
the one link gives that everything `i` precedes is `j` or above `j` (the converse of
`through_iff_only_link`) is exactly excluded middle. -/
theorem only_link_through_iff_em :
    (∀ c : Causet, c.Ordered → ∀ i j, links c.prec i j → (∀ k, links c.prec i k → k = j) →
      Through c i j) ↔ ∀ p : Prop, Decided p :=
  ⟨fun law => present_through_iff_em.mp fun c ordered i j every =>
     match only_link_of_present_every ordered every with
     | ⟨link, only⟩ => law c ordered i j link only,
   fun em _ ordered _ _ _ only k first =>
     (em _).of_not_not (through_of_only_not_not ordered only (k + 1) k (Nat.lt_succ_self k) first)⟩

/-! ## The laws on some course: weak excluded middle -/

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

/-- **`either_order`, on every causal set, gives De Morgan's law**: on `middleIf p q`, with `p ∧ q`
refuted, `2` and `0` are unrelated, and a course bearing `2` before `0` refutes `p` or `q` by
where it bears `1`. -/
theorem either_order_deMorgan
    (law : ∀ c : Causet, c.Ordered → ∀ x y, x < c.size → y < c.size → ¬ c.prec x y → ¬ c.prec y x →
      x ≠ y → (∃ π σ, Natural c π σ ∧ π x < π y) ∧ (∃ π σ, Natural c π σ ∧ π y < π x)) :
    ∀ p q : Prop, ¬ (p ∧ q) → ¬ p ∨ ¬ q :=
  fun p q neither =>
    have ordered := middleIf_ordered p q
    match (law (middleIf p q) ordered 2 0 (show 2 < 3 by decide) (show 0 < 3 by decide)
        (middleIf_not_two_zero p q) (middleIf_not_zero_two neither) (by decide)).1 with
    | ⟨π, _, natural, lt⟩ => match Nat.lt_or_ge (π 1) (π 0) with
      | .inl lt' => .inl fun hp => Nat.lt_asymm lt' (natural.before ordered (.inl ⟨rfl, rfl, hp⟩))
      | .inr ge => .inr fun hq =>
        Nat.lt_asymm (Nat.lt_of_lt_of_le lt ge) (natural.before ordered (.inr (.inl ⟨rfl, rfl, hq⟩)))

/-- **With precedence weakly decided, an element is born before another on some course wherever
they differ and the other does not precede it**: bearing first everything not refuted to lie at
or above the other. -/
theorem before_of_weakly {c : Causet} (weakly : ∀ a b, WeaklyDecided (c.prec a b))
    (ordered : c.Ordered) {x y : Nat} (hx : x < c.size) (hy : y < c.size) (ne : x ≠ y)
    (np : ¬ c.prec y x) : ∃ π σ, Natural c π σ ∧ π x < π y :=
  match table_of (Q := fun z => ¬ (z = y ∨ c.prec y z)) (fun z => match Nat.decEq z y with
      | .isTrue e => .inr fun outside => outside (.inl e)
      | .isFalse ne' => match weakly y z with
        | .inl fails => .inl fun inside => inside.elim ne' fails
        | .inr not_not => .inr fun outside => not_not fun holds => outside (.inr holds)) c.size with
  | ⟨_, spec⟩ =>
    ⟨_, _, natural_of_table ordered spec fun {_ b} pair outside inside => outside (match inside with
        | .inl e => .inr (Eq.subst (motive := fun w => c.prec w b) e pair)
        | .inr p => .inr (ordered.trans p pair)),
     front_true_lt_false ((spec x hx).mpr fun inside => inside.elim ne np)
       (table_false (spec y hy) fun outside => outside (.inl rfl)) hx⟩

theorem either_order_of_weakly {c : Causet} (weakly : ∀ a b, WeaklyDecided (c.prec a b))
    (ordered : c.Ordered) {x y : Nat} (hx : x < c.size) (hy : y < c.size) (nxy : ¬ c.prec x y)
    (nyx : ¬ c.prec y x) (ne : x ≠ y) :
    (∃ π σ, Natural c π σ ∧ π x < π y) ∧ (∃ π σ, Natural c π σ ∧ π y < π x) :=
  ⟨before_of_weakly weakly ordered hx hy ne nyx,
   before_of_weakly weakly ordered hy hx (fun e => ne e.symm) nxy⟩

/-- **`either_order`, on every causal set, is exactly weak excluded middle.** -/
theorem either_order_iff_weakly :
    (∀ c : Causet, c.Ordered → ∀ x y, x < c.size → y < c.size → ¬ c.prec x y → ¬ c.prec y x →
      x ≠ y → (∃ π σ, Natural c π σ ∧ π x < π y) ∧ (∃ π σ, Natural c π σ ∧ π y < π x)) ↔
    ∀ p : Prop, WeaklyDecided p :=
  ⟨fun law => weakly_of_deMorgan (either_order_deMorgan law),
   fun weakly _ ordered _ _ hx hy nxy nyx ne =>
     either_order_of_weakly (fun _ _ => weakly _) ordered hx hy nxy nyx ne⟩

/-- **`before_some_iff` from right to left, on every causal set, is exactly weak excluded
middle.** -/
theorem before_some_iff_weakly :
    (∀ c : Causet, c.Ordered → ∀ i j, i < c.size → j < c.size → i ≠ j → ¬ c.prec j i →
      ∃ π σ, Natural c π σ ∧ π i < π j) ↔ ∀ p : Prop, WeaklyDecided p :=
  ⟨fun law => either_order_iff_weakly.mp fun c ordered x y hx hy nxy nyx ne =>
     ⟨law c ordered x y hx hy ne nyx, law c ordered y x hy hx (fun e => ne e.symm) nxy⟩,
   fun weakly _ ordered _ _ hi hj ne np => before_of_weakly (fun _ _ => weakly _) ordered hi hj ne np⟩

/-- **`together_some_iff` from right to left, on every causal set, gives De Morgan's law**: on
`middleIf p q`, a stage with `0` and `2` both on the frontier refutes `p` or `q` by whether `1` is
born by then. -/
theorem together_some_deMorgan
    (law : ∀ c : Causet, c.Ordered → ∀ x y, x < c.size → y < c.size → ¬ c.prec x y → ¬ c.prec y x →
      ∃ π σ t, Natural c π σ ∧ OnFrontier c π t x ∧ OnFrontier c π t y) :
    ∀ p q : Prop, ¬ (p ∧ q) → ¬ p ∨ ¬ q :=
  fun p q neither =>
    have ordered := middleIf_ordered p q
    match law (middleIf p q) ordered 0 2 (show 0 < 3 by decide) (show 2 < 3 by decide)
        (middleIf_not_zero_two neither) (middleIf_not_two_zero p q) with
    | ⟨π, _, t, natural, f0, f2⟩ => match Nat.lt_or_ge (π 1) t with
      | .inl lt => .inl fun hp => Nat.not_le_of_lt lt (f0.2.2 1 (.inl ⟨rfl, rfl, hp⟩))
      | .inr ge => .inr fun hq =>
        Nat.not_le_of_lt (Nat.lt_trans (natural.before ordered (.inr (.inl ⟨rfl, rfl, hq⟩))) f2.2.1) ge

/-- **With precedence weakly decided, two unrelated elements are present together on some
course**: bearing first everything not refuted to lie above neither. -/
theorem together_some_of_weakly {c : Causet} (weakly : ∀ a b, WeaklyDecided (c.prec a b))
    (ordered : c.Ordered) {x y : Nat} (hx : x < c.size) (hy : y < c.size) (nxy : ¬ c.prec x y)
    (nyx : ¬ c.prec y x) : ∃ π σ t, Natural c π σ ∧ OnFrontier c π t x ∧ OnFrontier c π t y :=
  match table_of (Q := fun z => ¬ (c.prec x z ∨ c.prec y z)) (fun z => match weakly x z, weakly y z with
      | .inl nx, .inl ny => .inl fun inside => inside.elim nx ny
      | .inr nn, _ => .inr fun outside => nn fun holds => outside (.inl holds)
      | _, .inr nn => .inr fun outside => nn fun holds => outside (.inr holds)) c.size with
  | ⟨f, spec⟩ =>
    have passes : ∀ {z}, z < c.size → ¬ c.prec x z → ¬ c.prec y z → f z = true :=
      fun hz nx ny => (spec _ hz).mpr fun inside => inside.elim nx ny
    ⟨_, _, _, natural_of_table ordered spec fun pair outside inside => outside (match inside with
        | .inl p => .inl (ordered.trans p pair)
        | .inr p => .inr (ordered.trans p pair)),
     (frontier_front ordered f).mpr ⟨hx, passes hx (ordered.irrefl x) nyx, fun k pair =>
       table_false (spec k (ordered.within pair)) fun outside => outside (.inl pair)⟩,
     (frontier_front ordered f).mpr ⟨hy, passes hy nxy (ordered.irrefl y), fun k pair =>
       table_false (spec k (ordered.within pair)) fun outside => outside (.inr pair)⟩⟩

/-- **`together_some_iff` from right to left, on every causal set, is exactly weak excluded
middle.** -/
theorem together_some_iff_weakly :
    (∀ c : Causet, c.Ordered → ∀ x y, x < c.size → y < c.size → ¬ c.prec x y → ¬ c.prec y x →
      ∃ π σ t, Natural c π σ ∧ OnFrontier c π t x ∧ OnFrontier c π t y) ↔
    ∀ p : Prop, WeaklyDecided p :=
  ⟨fun law => weakly_of_deMorgan (together_some_deMorgan law),
   fun weakly _ ordered _ _ hx hy nxy nyx =>
     together_some_of_weakly (fun _ _ => weakly _) ordered hx hy nxy nyx⟩

/-- `antichain_present`, on every causal set, gives `together_some_iff` from right to left, as
the module's proof does, here with no decision. -/
theorem together_of_antichain
    (law : ∀ c : Causet, c.Ordered → ∀ q : Nat → Bool, (∀ {x}, q x = true → x < c.size) →
      (∀ {x y}, q x = true → q y = true → ¬ c.prec x y) →
      ∃ π σ t, Natural c π σ ∧ ∀ x, OnFrontier c π t x ↔ q x = true)
    {c : Causet} (ordered : c.Ordered) {x y : Nat} (hx : x < c.size) (hy : y < c.size)
    (nxy : ¬ c.prec x y) (nyx : ¬ c.prec y x) :
    ∃ π σ t, Natural c π σ ∧ OnFrontier c π t x ∧ OnFrontier c π t y :=
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
  match law c ordered (fun z => Nat.beq z x || Nat.beq z y) inside apart with
  | ⟨π, σ, t, natural, present⟩ =>
    ⟨π, σ, t, natural, (present x).mpr (bool_or_true.mpr (.inl (beq_self x))),
     (present y).mpr (bool_or_true.mpr (.inr (beq_self y)))⟩

/-- **With weak excluded middle, every antichain given by a test is a present**: bearing first the
elements not refuted to lie at or below it. -/
theorem antichain_present_of_weakly (weakly : ∀ p : Prop, WeaklyDecided p) {c : Causet}
    (ordered : c.Ordered) (q : Nat → Bool) (inside : ∀ {x}, q x = true → x < c.size)
    (apart : ∀ {x y}, q x = true → q y = true → ¬ c.prec x y) :
    ∃ π σ t, Natural c π σ ∧ ∀ x, OnFrontier c π t x ↔ q x = true :=
  match table_of (Q := fun z => ¬ ¬ ∃ y, q y = true ∧ (z = y ∨ c.prec z y))
      (fun z => weakly (¬ ∃ y, q y = true ∧ (z = y ∨ c.prec z y))) c.size with
  | ⟨f, spec⟩ =>
    ⟨_, _, _, natural_of_table ordered spec fun {a _} pair nn no => nn fun ⟨y, qy, hb⟩ =>
        no ⟨y, qy, .inr (match hb with
          | .inl e => Eq.subst (motive := fun w => c.prec a w) e pair
          | .inr p => ordered.trans pair p)⟩,
     fun x => ⟨fun present => match (frontier_front ordered f).mp present with
        | ⟨hx, fx, top⟩ => match h : q x with
          | true => rfl
          | false => (((spec x hx).mp fx) fun ⟨y, qy, hxy⟩ => match hxy with
            | .inl e => bool_absurd (Eq.subst (motive := fun w => q w = true) e.symm qy) h
            | .inr p => bool_absurd ((spec y (ordered.within p)).mpr fun no => no ⟨y, qy, .inl rfl⟩)
                (top y p)).elim,
      fun qx => (frontier_front ordered f).mpr
        ⟨inside qx, (spec x (inside qx)).mpr fun no => no ⟨x, qx, .inl rfl⟩,
         fun k pair => table_false (spec k (ordered.within pair)) fun nn => nn fun ⟨_, qy, hky⟩ =>
           match hky with
           | .inl e => apart qx qy (Eq.subst (motive := fun w => c.prec x w) e pair)
           | .inr p => apart qx qy (ordered.trans pair p)⟩⟩⟩

/-- **`antichain_present`, on every causal set, is exactly weak excluded middle.** -/
theorem antichain_present_iff_weakly :
    (∀ c : Causet, c.Ordered → ∀ q : Nat → Bool, (∀ {x}, q x = true → x < c.size) →
      (∀ {x y}, q x = true → q y = true → ¬ c.prec x y) →
      ∃ π σ t, Natural c π σ ∧ ∀ x, OnFrontier c π t x ↔ q x = true) ↔
    ∀ p : Prop, WeaklyDecided p :=
  ⟨fun law => together_some_iff_weakly.mp fun _ ordered _ _ hx hy nxy nyx =>
     together_of_antichain law ordered hx hy nxy nyx,
   fun weakly _ ordered q inside apart => antichain_present_of_weakly weakly ordered q inside apart⟩

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

/-- **`present_some_iff_link` from right to left, on every causal set, gives De Morgan's law**: on
`linkIf p q`, `0` is a link below `2` exactly where `p ∧ q` is refuted, and a course with `0`
present at `2`'s birth refutes `p` or `q` by where it bears `1`. -/
theorem present_some_deMorgan
    (law : ∀ c : Causet, c.Ordered → ∀ i j, j < c.size → links c.prec i j →
      ∃ π σ, Natural c π σ ∧ PresentAt c π i j) :
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

/-- **With precedence weakly decided, a link is present at the birth of what it conditions on
some course**: bearing first the elements not refuted to lie at or below it. -/
theorem present_some_of_weakly {c : Causet} (weakly : ∀ a b, WeaklyDecided (c.prec a b))
    (ordered : c.Ordered) {i j : Nat} (hj : j < c.size) (link : links c.prec i j) :
    ∃ π σ, Natural c π σ ∧ PresentAt c π i j :=
  match table_of (Q := fun z => ¬ ¬ (z = j ∨ c.prec z j)) (fun z => match Nat.decEq z j with
      | .isTrue e => .inl fun no => no (.inl e)
      | .isFalse ne => match weakly z j with
        | .inl fails => .inr fun nn => nn fun inside => inside.elim ne fails
        | .inr nn => .inl fun no => nn fun holds => no (.inr holds)) c.size with
  | ⟨f, spec⟩ =>
    have fj : f j = true := (spec j hj).mpr fun no => no (.inl rfl)
    ⟨front f c.size, back f c.size,
     natural_of_table ordered spec fun {a _} pair nn no => nn fun inside => no (.inr (match inside with
        | .inl e => Eq.subst (motive := fun w => c.prec a w) e pair
        | .inr p => ordered.trans pair p)),
     link.1, fun k first => match h : f k with
      | true => match Nat.decEq k j with
        | .isTrue e => Nat.le_of_eq (congrArg (front f c.size) e.symm)
        | .isFalse ne => (((spec k (ordered.within first)).mp h) fun inside => match inside with
          | .inl e => ne e
          | .inr p => link.2 k ⟨first, p⟩).elim
      | false => Nat.le_of_lt (front_true_lt_false fj h hj)⟩

/-- **`present_some_iff_link` from right to left, on every causal set, is exactly weak excluded
middle.** -/
theorem present_some_iff_weakly :
    (∀ c : Causet, c.Ordered → ∀ i j, j < c.size → links c.prec i j →
      ∃ π σ, Natural c π σ ∧ PresentAt c π i j) ↔ ∀ p : Prop, WeaklyDecided p :=
  ⟨fun law => weakly_of_deMorgan (present_some_deMorgan law),
   fun weakly _ ordered _ _ hj link => present_some_of_weakly (fun _ _ => weakly _) ordered hj link⟩

/-! ## The orders of birth, and what depends only on precedence -/

/-- **The natural labellings of a causal set are exactly the orders of birth of the courses from
the empty set growing a configuration of its kind**: the composition the note reads from three
laws, as one theorem. -/
theorem orders_of_birth {c : Causet} (ordered : c.Ordered) {π σ : Nat → Nat} :
    Natural c π σ ↔ ∃ r : Run process, r.state 0 = empty ∧
      CausalGrowth.Kinds.Relabels c (r.state c.size) π σ :=
  ⟨fun natural =>
     have grows := courseOf_grows (relabel_ordered ordered natural)
     have relabels := natural_relabels natural
     ⟨courseOf (relabel c σ) (relabel_ordered ordered natural), grows.1,
      ⟨fun _ hi => ⟨Nat.lt_of_lt_of_le (natural.at hi).1 (Nat.le_of_eq grows.2.1.symm), (natural.at hi).2⟩,
       fun _ hj => natural.back (Nat.lt_of_lt_of_le hj (Nat.le_of_eq grows.2.1)),
       fun i j hi hj => (relabels.2.2 i j hi hj).trans (grows.2.2 (π i) (π j)).symm⟩⟩,
   fun ⟨_, start, relabels⟩ =>
     natural_of_relabels (CausalGrowth.ordered_of_empty start c.size)
       (CausalGrowth.size_of_run start c.size) relabels⟩

/-- **The natural labellings depend only on the size and the precedence.** -/
theorem natural_congr {c c' : Causet} (size : c'.size = c.size)
    (same : ∀ a b, c.prec a b ↔ c'.prec a b) {π σ : Nat → Nat} (natural : Natural c π σ) :
    Natural c' π σ :=
  ⟨Eq.subst (motive := fun n => Reindexes 0 n π σ) size.symm natural.1,
   fun i j hi hj lt pair =>
     natural.2 i j hi (Eq.subst (motive := fun n => j < 0 + n) size hj) lt ((same i j).mpr pair)⟩

/-- **So what holds on every course of a causal set depends only on its size and precedence**,
whatever is read on a course: a bound on every course of a reading made on a course is a relation
of precedence by construction. -/
theorem every_congr {c c' : Causet} (size : c'.size = c.size) (same : ∀ a b, c.prec a b ↔ c'.prec a b)
    (Φ : (Nat → Nat) → Prop) : (∀ π σ, Natural c π σ → Φ π) ↔ (∀ π σ, Natural c' π σ → Φ π) :=
  ⟨fun every π σ natural => every π σ (natural_congr size.symm (fun a b => (same a b).symm) natural),
   fun every π σ natural => every π σ (natural_congr size same natural)⟩

/-- **And so does what holds on some course.** -/
theorem some_congr {c c' : Causet} (size : c'.size = c.size) (same : ∀ a b, c.prec a b ↔ c'.prec a b)
    (Φ : (Nat → Nat) → Prop) : (∃ π σ, Natural c π σ ∧ Φ π) ↔ (∃ π σ, Natural c' π σ ∧ Φ π) :=
  ⟨fun ⟨π, σ, natural, holds⟩ => ⟨π, σ, natural_congr size same natural, holds⟩,
   fun ⟨π, σ, natural, holds⟩ =>
     ⟨π, σ, natural_congr size.symm (fun a b => (same a b).symm) natural, holds⟩⟩

/-- **The past is the largest relation every course respects**: with precedence decided, a
relation each of whose pairs every natural labelling bears with the second born no later than the
first relates an element only to itself and to what precedes it. By `past_every_iff` from right to
left, the past, itself included, is such a relation. A maximum, not Stein's uniqueness. -/
theorem past_largest {c : Causet} [∀ a b, Decidable (c.prec a b)] (ordered : c.Ordered)
    (R : Nat → Nat → Prop) (respected : ∀ x y, R x y → ∀ π σ, Natural c π σ → π y ≤ π x)
    {x y : Nat} (hx : x < c.size) (hy : y < c.size) (pair : R x y) : y = x ∨ c.prec y x :=
  (past_every_iff ordered hx hy).mp (respected x y pair)

/-- **The frontier at a stage is the core's frontier** (`Requirement.Frontier`) of what has been
born, with `b` bettering `a` read as `a` preceding `b`. -/
theorem onFrontier_iff_frontier {c : Causet} (ordered : c.Ordered) {π : Nat → Nat} {t x : Nat} :
    OnFrontier c π t x ↔
      Requirement.Frontier (fun a => a < c.size ∧ π a < t) (fun b a => c.prec a b) x :=
  ⟨fun ⟨hx, born, after⟩ => ⟨⟨hx, born⟩, fun b ⟨_, bornB⟩ pair =>
      Nat.lt_irrefl t (Nat.lt_of_le_of_lt (after b pair) bornB)⟩,
   fun ⟨⟨hx, born⟩, unbettered⟩ => ⟨hx, born, fun k pair => match Nat.lt_or_ge (π k) t with
      | .inl lt => (unbettered k ⟨ordered.within pair, lt⟩ pair).elim
      | .inr ge => ge⟩⟩

/-! ## Witnesses -/

/-- **On the labels as they are, the vee's present after two births is exactly `1`.** -/
theorem present_after_two_identity (x : Nat) : OnFrontier Vee.vee (fun i => i) 2 x ↔ x = 1 :=
  ⟨fun ⟨hx, born, after⟩ => match below_three hx with
    | .inl e => absurd (after 1 (Eq.subst (motive := fun z => Vee.vee.prec z 1) e.symm ⟨rfl, .inl rfl⟩))
        (by decide)
    | .inr (.inl e) => e
    | .inr (.inr e) => absurd (Eq.subst (motive := fun z => z < 2) e born) (by decide),
   fun e => Eq.subst (motive := fun z => OnFrontier Vee.vee (fun i => i) 2 z) e.symm
     ⟨by decide, by decide, fun _ pair => absurd pair.1 (by decide)⟩⟩

/-- **Exchanging the births of `1` and `2`, it is exactly `2`.** -/
theorem present_after_two_swap (x : Nat) : OnFrontier Vee.vee swap12 2 x ↔ x = 2 :=
  ⟨fun ⟨hx, born, after⟩ => match below_three hx with
    | .inl e => absurd (after 2 (Eq.subst (motive := fun z => Vee.vee.prec z 2) e.symm ⟨rfl, .inr rfl⟩))
        (by decide)
    | .inr (.inl e) => absurd (Eq.subst (motive := fun z => swap12 z < 2) e born) (by decide)
    | .inr (.inr e) => e,
   fun e => Eq.subst (motive := fun z => OnFrontier Vee.vee swap12 2 z) e.symm
     ⟨by decide, by decide, fun _ pair => absurd pair.1 (by decide)⟩⟩

/-- The right side of `Diamond.pastOrPair_iff_together` on any causal set: `b` precedes `a`, or the
two are present together on every course. -/
def PastOrTogether (c : Causet) (a b : Nat) : Prop :=
  c.prec b a ∨ ∀ π σ, Natural c π σ → ∃ t, OnFrontier c π t a ∧ OnFrontier c π t b

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

/-- **Present together on every course, with different pasts**: `1` and `2` are on the frontier
together at some stage of every course, while `0` precedes `1` and not `2`. So they are not a
pair with the same past and the same future, Wüthrich and Callender's non-Hegelian pair. -/
theorem together_different_pasts :
    (∀ π σ, Natural sameFuture π σ → ∃ t, OnFrontier sameFuture π t 1 ∧ OnFrontier sameFuture π t 2) ∧
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

/-- On the diamond's elements `PastOrTogether` is Wüthrich and Callender's relation. -/
theorem pastOrTogether_diamond {a b : Nat} (ha : a < 4) (hb : b < 4) :
    PastOrTogether Diamond.diamond a b ↔ Diamond.PastOrPair a b :=
  (Diamond.pastOrPair_iff_together ha hb).symm

end Probe

end Presence

end Becoming
