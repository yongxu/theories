import Becoming.Boundaries

/-!
# Weightings: what every standpoint's weighting ranks, and what the step across standpoints reaches

The ethics of the chapter rests on two premises: the continuation condition fixes scope (whose
losses count) and calling widening better (C) fixes order. `Becoming.Boundaries` decomposed the
condition into the self's presupposition and the step of invariance. This module states what the
step reaches when it is taken across standpoints rather than across drawings of a self, and what
order every standpoint shares when each weighs what can form in its own way.

* **Weighted counts.** Over a finite list of items (steps and formations), a course is the items it
  admits (a Bool-valued family), and a weighting gives each item a natural weight; the weighted
  count adds the weights of the admitted items (`Weighting.weighed`). A weighting is positive when
  it counts every listed item (`Weighting.Positive`).
* **Widening is what every positive weighting ranks higher.** Inclusion never lowers a weighted
  count (`Weighting.weighed_le_of_includes`); every positive weighting ranks a widening strictly
  higher (`Weighting.weighed_lt_of_widens`); where one course admits an item the other does not,
  some positive weighting ranks it higher (`Weighting.outweighs`), so a mixed comparison is decided
  both ways by positive weightings (`Weighting.mixed_either_way`); hence on the listed items one
  course widens another exactly when every positive weighting ranks it higher
  (`Weighting.widens_iff_every_positive`). On a web, where what either level path admits is listed
  and admission is decided, this is `Web.Widens` itself (`Web.widens_iff_every_weighting`).
* **Any order increasing in admission.** An order need not be additive: call it increasing in
  admission when it ranks every widening higher (`Weighting.Increasing`; a positive weighting's
  order is one, `Weighting.increasing_ranks`, and so is priority to the worse off,
  `Weighting.increasing_prior`). For any class of orders from the positive weightings up to all
  orders increasing in admission, one course widens another exactly when every order of the class
  ranks it higher (`Weighting.widens_iff_every_of_class`; all of them,
  `Weighting.widens_iff_every_increasing`; every complete one, as a score,
  `Weighting.widens_iff_every_score`; on a web, `Web.widens_iff_every_of_class`), and within each
  such class a mixed comparison is decided both ways (`Weighting.mixed_either_way_of_class`). The
  shared order does not depend on the representation.
* **A weight of zero ties.** Where every item a course admits beyond another weighs nothing, the
  two weigh the same (`Weighting.weighed_eq_of_unweighted`): a weighting that leaves an item out
  does not rank a widening that adds only that item.
* **The same weight for every item ranks by number.** Under one positive weight for all items, a
  course weighs more exactly when it admits more items (`Weighting.weighed_const`,
  `Weighting.neutral_ranks_by_number`).
* **Closing is never required.** Where the levels `l'` admit a formation at a step and `l` do not,
  `l` neither widens nor keeps `l'` (`Web.not_widens_of_closes`).
* **What the step across standpoints reaches.** Let each standpoint's presupposition about its own
  continuation hold (sub-true along the empty relation) and let significance be
  standpoint-invariant. Then the continuation of every standpoint's center has significance from
  every standpoint (`atCenters_least`), and the significance of the centers' continuation
  (`atCenters`) meets both premises (`atCenters_presupposed`, `atCenters_standpointInvariant`):
  what the two premises force is exactly that the centers count (`forced_iff_center`). It is the
  continuation condition exactly when every formation is some standpoint's center
  (`unrestricted_atCenters_iff`). Retaining under it is admitting every center the other path
  admits (`Web.retains_atCenters_iff`).
* **What a standpoint's own presupposition reaches.** Along a relation, what every significance
  making `p`'s presupposition sub-true at `f`'s closure gives significance to is exactly what lies
  within the closure (`forced_iff_within`).
* **Every relation one at a time, and being related at all.** The presupposition sub-true along
  every relation of a family is significance over the union of the closures
  (`subTrue_every_iff`); drawn along being related by some relation of the family (`Related`) it
  gives each of them (`subTrue_every_of_related`), and can say more: in `Chain` the third formation
  lies within the first's closure along being related at all and within no closure along a single
  relation (`Chain.third_related`, `Chain.third_not_within`, `Chain.every_not_related`).
* **Contents held de se and de dicto.** A content held de se is a property of a self, which each
  standpoint holds of its own center (`selfAscribed`); one held de dicto is one proposition from
  every standpoint (`shared`). Standpoint-invariance is exactly holding one shared content
  (`standpointInvariant_iff_shared`); a content held de se is invariant exactly where its readings
  at the centers agree (`selfAscribed_standpointInvariant_iff`). Held de se, the presupposition
  about the own closure along a relation (`ownClosure`) meets every standpoint's presupposition
  (`ownClosure_presupposed`), is invariant exactly where the centers' closures agree
  (`ownClosure_standpointInvariant_iff`) and is the condition exactly where each is the whole
  (`ownClosure_unrestricted_iff`, `ownClosure_unrestricted_of_whole`). Held de dicto, the step
  across standpoints forces exactly the union of the closures (`withinSome`,
  `forced_iff_within_some`; `forced_iff_center` along the empty relation; on a web, admitting what
  either forces is admitting the centers or the union, `Web.admitsWithin_forced_iff`,
  `Web.admitsWithin_forced_within_some_iff`). The two readings agree
  exactly where whatever lies within one center's closure lies within every center's
  (`selfAscribed_iff_withinSome`); in `Divided` they part.
* **Standing and grades.** A graded significance gives each item a natural grade from each
  standpoint; its standing is whether the grade is positive. Invariant grades have invariant
  standing (`Weighting.standingInvariant_of_gradeInvariant`) and rank alike from every standpoint
  (`Weighting.ranks_alike_of_gradeInvariant`); in `Partial` standing is invariant and the grades
  are not, and two standpoints rank a mixed comparison opposite ways.
* **Levels of continuation, priority and sufficiency.** A formation's level in a course is how
  many of its listed items the course admits (`Weighting.level`). A sum of a strictly increasing
  transform of levels ranks every widening higher (`Weighting.prior_lt_of_widens`). A transform
  strictly concave up to a bound (`Weighting.ConcaveTo`; none is strictly concave on all whole
  numbers) ranks higher a course that moves one step of continuation from a formation at a higher
  level to one at a lower, a comparison C leaves mixed (`Weighting.prior_transfer`; in
  `LevelTransfer` the sum of levels ties the two courses and a convex transform ranks them the
  other way). A transform that rises no further from a threshold weighs alike two courses whose
  levels differ only at or above it (`Weighting.sufficient_ties`).
* **Where the narrower scope and the condition part.** In `Clearing`, with the clearer the only
  standpoint's center, the clearer's part retains what has significance at the centers, while
  under the continuation condition it loses the dweller (`Clearing.centers_retain_yet_loses`).

**Reading (the AI's; the argument is in the chapter
`theories/becoming/chapters/THE-STEP-OF-INVARIANCE.md`).** Read a
positive weighting, or any order increasing in admission, as one standpoint's order, partial in how much it weighs each formation's
possibility but counting all of them, and the order every such standpoint shares as the impartial
order. Then the impartial order is exactly C, the comparisons partiality may decide are exactly the
mixed ones, a weight of zero is a denial of scope, and a weighting the same for every formation
counts numbers. Read the centers as the formations that hold their own continuation significant
(what "wants its continuation"); then the step across standpoints, Gewirth's step, gives
significance to exactly them, and "anything" needs a further premise, that every formation is a
center or lies within some center's closure.

Read a content held de se as Lewis's self-ascribed property and one held de dicto as a
proposition. Then the step across standpoints is exactly the de dicto reading of the self's
presupposition, the de se reading gives each center its own closure, and the two part exactly
where centers' closures differ: drawn along being related at all in a connected unfolding they
agree, so the de se question has force only together with a drawing along a narrower relation.
Read a grade's positivity as standing (whether a formation counts) and the grade as status (how
much): the step, applied to two-valued significance, makes standing invariant and leaves status
to each standpoint; status invariant is a further premise. Read a formation's level as how long
its continuation is admitted: priority to the worse off agrees with C wherever C ranks and
decides transfers C leaves mixed; a threshold of sufficiency is a denial of scope above it.

What is not derived: whether the self's presupposition is held de se; that a standpoint's order is increasing in admission (monotonicity, and that it
counts every item, are supplied; additivity is not needed for the shared order); which weighting a standpoint has; that the impartial order is what every
standpoint shares rather than one privileged weighting; which formations are centers; the step of
invariance itself. The representation commits to finite listings of steps and formations,
two-valued admission and natural-number weights. No ethical predicate or axiom occurs.
-/

namespace Becoming

/-! ## Weighted counts of what a course admits -/

namespace Weighting

variable {X : Type}

/-- The weighted count of the listed items a course admits: each admitted item counts its
weight. -/
def weighed (items : List X) (w : X → Nat) (a : X → Bool) : Nat :=
  total items fun x => cond (a x) (w x) 0

/-- A weighting is positive on the listed items: it counts every one of them. -/
def Positive (items : List X) (w : X → Nat) : Prop :=
  ∀ x, x ∈ items → 0 < w x

/-- On the listed items, `a` admits every item `b` admits. -/
def IncludesOn (items : List X) (a b : X → Bool) : Prop :=
  ∀ x, x ∈ items → b x = true → a x = true

/-- On the listed items, `a` admits an item `b` does not. -/
def ExceedsOn (items : List X) (a b : X → Bool) : Prop :=
  ∃ x, x ∈ items ∧ a x = true ∧ b x = false

/-- On the listed items, `a` widens `b`: it admits every item `b` admits, and one more. -/
def WidensOn (items : List X) (a b : X → Bool) : Prop :=
  IncludesOn items a b ∧ ExceedsOn items a b

/-- On the listed items, `a` and `b` are mixed: each admits an item the other does not. -/
def MixedOn (items : List X) (a b : X → Bool) : Prop :=
  ExceedsOn items a b ∧ ExceedsOn items b a

theorem term_le {w : Nat} : ∀ {a b : Bool}, (b = true → a = true) → cond b w 0 ≤ cond a w 0
  | _, false, _ => Nat.zero_le _
  | true, true, _ => Nat.le_refl w
  | false, true, kept => Bool.noConfusion (kept rfl)

theorem term_lt {w : Nat} (positive : 0 < w) :
    ∀ {a b : Bool}, a = true → b = false → cond b w 0 < cond a w 0
  | _, _, rfl, rfl => positive

theorem total_lt {p q : X → Nat} :
    ∀ {as : List X}, (∀ a, a ∈ as → p a ≤ q a) → (∃ a, a ∈ as ∧ p a < q a) →
      total as p < total as q
  | [], _, ⟨_, mem, _⟩ => nomatch mem
  | a :: as, le, ⟨b, mem, lt⟩ => match mem_cons_cases mem with
    | .inl same =>
      Nat.add_lt_add_of_lt_of_le (Eq.subst (motive := fun y => p y < q y) same lt)
        (total_le as fun c listed => le c (.tail a listed))
    | .inr rest =>
      Nat.add_lt_add_of_le_of_lt (le a (.head as))
        (total_lt (fun c listed => le c (.tail a listed)) ⟨b, rest, lt⟩)

theorem total_congr_on {p q : X → Nat} :
    ∀ {as : List X}, (∀ a, a ∈ as → p a = q a) → total as p = total as q
  | [], _ => rfl
  | a :: as, same =>
    (congrArg (· + total as p) (same a (.head as))).trans
      (congrArg (q a + ·) (total_congr_on fun c listed => same c (.tail a listed)))

/-- **Inclusion never lowers a weighted count**, whatever the weights. -/
theorem weighed_le_of_includes {items : List X} {a b : X → Bool} (w : X → Nat)
    (includes : IncludesOn items a b) : weighed items w b ≤ weighed items w a :=
  total_le items fun x listed => term_le (includes x listed)

/-- **Every positive weighting ranks a widening higher.** -/
theorem weighed_lt_of_widens {items : List X} {a b : X → Bool} {w : X → Nat}
    (positive : Positive items w) (widens : WidensOn items a b) :
    weighed items w b < weighed items w a :=
  match widens.2 with
  | ⟨x, listed, admits, not⟩ =>
    total_lt (fun y member => term_le (widens.1 y member))
      ⟨x, listed, term_lt (positive x listed) admits not⟩

/-- **A weight of zero on what a course adds ties it with the course it includes**: where every
item `a` admits beyond `b` weighs nothing, the weighted counts agree, so a widening that adds
only such items is not ranked. -/
theorem weighed_eq_of_unweighted {items : List X} {a b : X → Bool} {w : X → Nat}
    (includes : IncludesOn items a b)
    (unweighted : ∀ x, x ∈ items → a x = true → b x = false → w x = 0) :
    weighed items w a = weighed items w b :=
  total_congr_on fun x listed => match ha : a x, hb : b x with
    | true, true => rfl
    | true, false => unweighted x listed ha hb
    | false, false => rfl
    | false, true => Bool.noConfusion (ha.symm.trans (includes x listed hb))

/-- Comparing what two courses admit item by item: either `a` admits an item `b` does not, or
`b` admits every item `a` admits. -/
theorem exceeds_or_includes (a b : X → Bool) :
    ∀ items : List X, ExceedsOn items a b ∨ IncludesOn items b a
  | [] => .inr fun _ member => nomatch member
  | x :: rest => match exceeds_or_includes a b rest with
    | .inl ⟨y, listed, admits, not⟩ => .inl ⟨y, .tail x listed, admits, not⟩
    | .inr includes => match ha : a x, hb : b x with
      | true, false => .inl ⟨x, .head rest, ha, hb⟩
      | true, true => .inr fun y member admits => match mem_cons_cases member with
        | .inl same => Eq.subst (motive := fun z => b z = true) same.symm hb
        | .inr listed => includes y listed admits
      | false, _ => .inr fun y member admits => match mem_cons_cases member with
        | .inl same => Bool.noConfusion
            (ha.symm.trans (Eq.subst (motive := fun z => a z = true) same admits))
        | .inr listed => includes y listed admits

/-- The weighting that puts weight `M` on what `b` admits beyond `a` and one on every other
item. -/
def outweighing (M : Nat) (a b : X → Bool) : X → Nat :=
  fun x => cond (b x && !a x) M 1

theorem cond_pos (M : Nat) : ∀ v : Bool, 0 < cond v (M + 1) 1
  | true => Nat.succ_pos M
  | false => Nat.succ_pos 0

theorem outweighing_positive (M : Nat) (a b : X → Bool) (items : List X) :
    Positive items (outweighing (M + 1) a b) :=
  fun x _ => cond_pos M (b x && !a x)

theorem outweighing_term_le_one {M : Nat} : ∀ (ax bx : Bool),
    cond ax (cond (bx && !ax) M 1) 0 ≤ 1
  | true, true => Nat.le_refl 1
  | true, false => Nat.le_refl 1
  | false, _ => Nat.zero_le 1

theorem outweighing_term_at {M : Nat} : ∀ {ax bx : Bool}, bx = true → ax = false →
    M ≤ cond bx (cond (bx && !ax) M 1) 0
  | _, _, rfl, rfl => Nat.le_refl M

/-- **A course admitting an item the other does not is ranked higher by some positive
weighting.** -/
theorem outweighs {items : List X} {a b : X → Bool} (exceeds : ExceedsOn items b a) :
    ∃ w, Positive items w ∧ weighed items w a < weighed items w b :=
  ⟨outweighing (items.length + 1) a b, outweighing_positive items.length a b items,
   match exceeds with
   | ⟨_, listed, admits, not⟩ =>
     Nat.lt_of_le_of_lt
       (Nat.le_trans (total_le items fun y _ => outweighing_term_le_one (a y) (b y))
         (Nat.le_of_eq (total_ones items)))
       (Nat.lt_of_lt_of_le (Nat.lt_succ_self items.length)
         (Nat.le_trans (outweighing_term_at admits not)
           (le_total_of_mem (q := fun y => cond (b y) (outweighing (items.length + 1) a b y) 0)
             listed)))⟩

/-- **A mixed comparison is decided both ways by positive weightings**: some positive weighting
ranks the one higher, and some the other. -/
theorem mixed_either_way {items : List X} {a b : X → Bool} (mixed : MixedOn items a b) :
    (∃ w, Positive items w ∧ weighed items w b < weighed items w a) ∧
      ∃ w, Positive items w ∧ weighed items w a < weighed items w b :=
  ⟨outweighs mixed.1, outweighs mixed.2⟩

/-- **Widening is what every positive weighting ranks higher.** On the listed items, `a` widens
`b` exactly when every weighting positive on them weighs `a` above `b`. -/
theorem widens_iff_every_positive {items : List X} {a b : X → Bool} :
    WidensOn items a b ↔ ∀ w, Positive items w → weighed items w b < weighed items w a :=
  ⟨fun widens _ positive => weighed_lt_of_widens positive widens,
   fun every =>
    ⟨fun x listed admits => match h : a x with
      | true => rfl
      | false => match outweighs ⟨x, listed, admits, h⟩ with
        | ⟨w, positive, lt⟩ => absurd (every w positive) (Nat.lt_asymm lt),
     match exceeds_or_includes a b items with
     | .inl exceeds => exceeds
     | .inr includes =>
       absurd (every (fun _ => 1) fun _ _ => Nat.succ_pos 0)
         (Nat.not_lt_of_le (weighed_le_of_includes _ includes))⟩⟩

theorem cond_mul (k : Nat) : ∀ v : Bool, cond v k 0 = k * cond v 1 0
  | true => (Nat.mul_one k).symm
  | false => (Nat.mul_zero k).symm

/-- Under one weight `k` for every item, the weighted count is `k` times the number of listed
items admitted. -/
theorem weighed_const (k : Nat) (items : List X) (a : X → Bool) :
    weighed items (fun _ => k) a = k * weighed items (fun _ => 1) a :=
  (total_congr (fun x => cond_mul k (a x)) items).trans
    (total_mul k (fun x => cond (a x) 1 0) items)

theorem mul_lt_mul_pos {k m n : Nat} (positive : 0 < k) (lt : m < n) : k * m < k * n :=
  match k, positive with
  | j + 1, _ =>
    Eq.subst (motive := fun x => x < (j + 1) * n) (Nat.succ_mul j m).symm
      (Eq.subst (motive := fun y => j * m + m < y) (Nat.succ_mul j n).symm
        (Nat.add_lt_add_of_le_of_lt (Nat.mul_le_mul_left j (Nat.le_of_lt lt)) lt))

theorem lt_of_mul_lt {k m n : Nat} (lt : k * m < k * n) : m < n :=
  match Nat.lt_or_ge m n with
  | .inl less => less
  | .inr ge => absurd lt (Nat.not_lt_of_le (Nat.mul_le_mul_left k ge))

/-- **A weighting the same for every item ranks by number.** Under one positive weight for every
item, one course is weighed above another exactly when it admits more of the listed items. -/
theorem neutral_ranks_by_number {k : Nat} (positive : 0 < k) (items : List X) (a b : X → Bool) :
    weighed items (fun _ => k) b < weighed items (fun _ => k) a ↔
      weighed items (fun _ => 1) b < weighed items (fun _ => 1) a :=
  ⟨fun lt => lt_of_mul_lt
      (Eq.subst (motive := fun x => x < k * weighed items (fun _ => 1) a) (weighed_const k items b)
        (Eq.subst (motive := fun y => weighed items (fun _ => k) b < y) (weighed_const k items a)
          lt)),
   fun lt =>
    Eq.subst (motive := fun x => x < weighed items (fun _ => k) a) (weighed_const k items b).symm
      (Eq.subst (motive := fun y => k * weighed items (fun _ => 1) b < y)
        (weighed_const k items a).symm (mul_lt_mul_pos positive lt))⟩

/-! ### Any order increasing in admission -/

/-- An order on courses is increasing in admission on the listed items when it ranks every
widening above what it widens; `R b a` reads "`a` is ranked above `b`". It need not be additive,
complete or transitive. -/
def Increasing (items : List X) (R : (X → Bool) → (X → Bool) → Prop) : Prop :=
  ∀ a b, WidensOn items a b → R b a

/-- The order a weighting gives: `a` is ranked above `b` when it weighs more. -/
def ranks (items : List X) (w : X → Nat) : (X → Bool) → (X → Bool) → Prop :=
  fun b a => weighed items w b < weighed items w a

/-- A positive weighting's order is increasing in admission. -/
theorem increasing_ranks {items : List X} {w : X → Nat} (positive : Positive items w) :
    Increasing items (ranks items w) :=
  fun _ _ widens => weighed_lt_of_widens positive widens

/-- **Widening is what every order of a class shares, for any class from the positive weightings
to the orders increasing in admission.** Where a class of orders contains every positive
weighting's order and holds only orders increasing in admission, `a` widens `b` on the listed
items exactly when every order of the class ranks `a` above `b`. The additive representation is
not needed: the shared order is the same for every such class. -/
theorem widens_iff_every_of_class {items : List X} {a b : X → Bool}
    {K : ((X → Bool) → (X → Bool) → Prop) → Prop}
    (weightings : ∀ w, Positive items w → K (ranks items w))
    (increasing : ∀ R, K R → Increasing items R) :
    WidensOn items a b ↔ ∀ R, K R → R b a :=
  ⟨fun widens R member => increasing R member a b widens,
   fun every => widens_iff_every_positive.mpr fun w positive => every _ (weightings w positive)⟩

/-- **Widening is what every order increasing in admission shares.** -/
theorem widens_iff_every_increasing {items : List X} {a b : X → Bool} :
    WidensOn items a b ↔ ∀ R, Increasing items R → R b a :=
  widens_iff_every_of_class (fun _ positive => increasing_ranks positive) fun _ increasing =>
    increasing

/-- **Widening is what every complete order increasing in admission shares.** A score ranks every
two courses; `a` widens `b` exactly when every score ranking each widening higher ranks `a` above
`b`. -/
theorem widens_iff_every_score {items : List X} {a b : X → Bool} :
    WidensOn items a b ↔
      ∀ s : (X → Bool) → Nat, Increasing items (fun c d => s c < s d) → s b < s a :=
  ⟨fun widens _ increasing => increasing a b widens,
   fun every => widens_iff_every_positive.mpr fun w positive =>
     every (weighed items w) (increasing_ranks positive)⟩

/-- **Within every such class a mixed comparison is decided both ways.** -/
theorem mixed_either_way_of_class {items : List X} {a b : X → Bool}
    {K : ((X → Bool) → (X → Bool) → Prop) → Prop}
    (weightings : ∀ w, Positive items w → K (ranks items w)) (mixed : MixedOn items a b) :
    (∃ R, K R ∧ R b a) ∧ ∃ R, K R ∧ R a b :=
  match mixed_either_way mixed with
  | ⟨⟨w, positive, lt⟩, ⟨w', positive', lt'⟩⟩ =>
    ⟨⟨ranks items w, weightings w positive, lt⟩, ⟨ranks items w', weightings w' positive', lt'⟩⟩

end Weighting

/-! ## Weightings of what a web's levels admit -/

namespace Web

variable {F C : Type} {W : Web F C}

/-- A decision of admission at listed steps and formations: `admitted l (t, f)` is true exactly
when the levels `l` admit `f` at `t`. -/
def DecidesAdmission (W : Web F C) (admitted : (Nat → C → Nat) → Nat × F → Bool) : Prop :=
  ∀ l i, admitted l i = true ↔ W.Admits (l i.1) i.1 i.2

/-- Every step and formation the level path admits is listed. -/
def ListsAdmitted (W : Web F C) (items : List (Nat × F)) (l : Nat → C → Nat) : Prop :=
  ∀ t f, W.Admits (l t) t f → (t, f) ∈ items

/-- **Widening is what every positive weighting ranks higher.** Where what either level path
admits is listed, `l` widens `l'` exactly when every weighting positive on the listed steps and
formations weighs what `l` admits above what `l'` admits. -/
theorem widens_iff_every_weighting {admitted : (Nat → C → Nat) → Nat × F → Bool}
    (decides : DecidesAdmission W admitted) {items : List (Nat × F)} {l l' : Nat → C → Nat}
    (listed : ListsAdmitted W items l) (listed' : ListsAdmitted W items l') :
    W.Widens l l' ↔ ∀ w, Weighting.Positive items w →
      Weighting.weighed items w (admitted l') < Weighting.weighed items w (admitted l) :=
  Iff.trans
    ⟨fun widens =>
      ⟨fun x _ admits => (decides l x).mpr (widens.1 x.1 x.2 ((decides l' x).mp admits)),
       match widens.2 with
       | ⟨t, f, admits, not⟩ => ⟨(t, f), listed t f admits, (decides l (t, f)).mpr admits,
           match h : admitted l' (t, f) with
           | true => absurd ((decides l' (t, f)).mp h) not
           | false => rfl⟩⟩,
     fun widens =>
      ⟨fun t f admits => (decides l (t, f)).mp
         (widens.1 (t, f) (listed' t f admits) ((decides l' (t, f)).mpr admits)),
       match widens.2 with
       | ⟨x, _, admits, not⟩ => ⟨x.1, x.2, (decides l x).mp admits,
           fun admits' => Bool.noConfusion (not.symm.trans ((decides l' x).mpr admits'))⟩⟩⟩
    Weighting.widens_iff_every_positive

/-- **Widening is what every order increasing in admission shares, on a web.** Where what either
level path admits is listed and admission is decided, `l` widens `l'` exactly when every order of
a class ranks what `l` admits above what `l'` admits, for any class from the positive weightings
to the orders increasing in admission. -/
theorem widens_iff_every_of_class {admitted : (Nat → C → Nat) → Nat × F → Bool}
    (decides : DecidesAdmission W admitted) {items : List (Nat × F)} {l l' : Nat → C → Nat}
    (listed : ListsAdmitted W items l) (listed' : ListsAdmitted W items l')
    {K : ((Nat × F → Bool) → (Nat × F → Bool) → Prop) → Prop}
    (weightings : ∀ w, Weighting.Positive items w → K (Weighting.ranks items w))
    (increasing : ∀ R, K R → Weighting.Increasing items R) :
    W.Widens l l' ↔ ∀ R, K R → R (admitted l') (admitted l) :=
  (widens_iff_every_weighting decides listed listed').trans
    (Weighting.widens_iff_every_positive.symm.trans
      (Weighting.widens_iff_every_of_class weightings increasing))

/-- **Closing is never required.** Where the levels `l'` admit a formation at a step and the
levels `l` do not, `l` neither widens `l'` nor keeps it the same: a comparison by widening never
ranks the course in which something is closed above the course in which it is not. -/
theorem not_widens_of_closes {l l' : Nat → C → Nat} {t : Nat} {f : F}
    (admits : W.Admits (l' t) t f) (closed : ¬ W.Admits (l t) t f) :
    ¬ W.Widens l l' ∧ ¬ W.Keeps l l' :=
  ⟨fun widens => closed (widens.1 t f admits), fun keeps => closed (keeps.1 t f admits)⟩

end Web

/-! ## What the step across standpoints reaches -/

variable {F Pos : Type}

/-- The significance of the continuation of what is some standpoint's center, from every
standpoint. -/
def atCenters (center : Pos → F) : Pos → Nat → F → Prop :=
  fun _ _ g => ∃ q, center q = g

/-- It is standpoint-invariant. -/
theorem atCenters_standpointInvariant (center : Pos → F) :
    StandpointInvariant (atCenters center) :=
  fun _ _ _ _ held => held

/-- It makes each standpoint's presupposition about its own continuation, along the empty
relation, sub-true. -/
theorem atCenters_presupposed (center : Pos → F) (p : Pos) :
    SubTrue (Boundary (fun _ _ => False) (center p)) (SignificantWithin (atCenters center) p) :=
  subTrue_empty_iff.mpr fun _ => ⟨p, rfl⟩

/-- **The least significance the step across standpoints gives.** Every significance under which
each standpoint's own continuation has significance from it, and which is standpoint-invariant,
gives significance from every standpoint to the continuation of every center. -/
theorem atCenters_least {center : Pos → F} {sig : Pos → Nat → F → Prop}
    (own : ∀ p, SubTrue (Boundary (fun _ _ => False) (center p)) (SignificantWithin sig p))
    (invariant : StandpointInvariant sig) : ∀ p t g, atCenters center p t g → sig p t g :=
  fun p t _ ⟨q, same⟩ =>
    Eq.subst (motive := fun g => sig p t g) same
      (invariant q p t (center q) (subTrue_empty_iff.mp (own q) t))

/-- **The step across standpoints reaches exactly the centers.** The continuation of `g` has
significance from `p` under every significance that gives each standpoint's own continuation
significance from it and is standpoint-invariant exactly when `g` is some standpoint's center. -/
theorem forced_iff_center (center : Pos → F) (p : Pos) (t : Nat) (g : F) :
    (∀ sig : Pos → Nat → F → Prop,
        (∀ q, SubTrue (Boundary (fun _ _ => False) (center q)) (SignificantWithin sig q)) →
          StandpointInvariant sig → sig p t g) ↔
      ∃ q, center q = g :=
  ⟨fun forced => forced (atCenters center) (atCenters_presupposed center)
      (atCenters_standpointInvariant center),
   fun centered _ own invariant => atCenters_least own invariant p t g centered⟩

/-- **The step across standpoints gives the continuation condition only where everything is a
center.** With some standpoint, the significance of the centers' continuation is unrestricted
exactly when every formation is some standpoint's center. -/
theorem unrestricted_atCenters_iff {center : Pos → F} (some : Pos) :
    Unrestricted (atCenters center) ↔ ∀ g, ∃ q, center q = g :=
  ⟨fun unrestricted g => unrestricted (some, 0, g), fun every i => every i.2.2⟩

/-- **What a standpoint's own presupposition reaches.** Along a relation, the continuation of `g`
has significance from `p` under every significance that makes `p`'s presupposition sub-true,
drawn at the closure of `f`, exactly when `g` lies within that closure. -/
theorem forced_iff_within (rel : F → F → Prop) (f : F) (p : Pos) (t : Nat) (g : F) :
    (∀ sig : Pos → Nat → F → Prop, SubTrue (Boundary rel f) (SignificantWithin sig p) →
        sig p t g) ↔ WithinClosure rel f g :=
  ⟨fun forced => forced (fun _ _ h => WithinClosure rel f h)
      (subTrue_significantWithin_iff.mpr fun _ _ within => within),
   fun within _ sub => subTrue_significantWithin_iff.mp sub t g within⟩

/-- Retaining what has significance at the centers is admitting, at every step, every center
the other path admits. -/
theorem Web.retains_atCenters_iff {C : Type} {W : Web F C} {center : Pos → F} {p : Pos}
    {l l' : Nat → C → Nat} :
    W.Retains (atCenters center) p l l' ↔
      ∀ t, W.AdmitsWithin (fun g => ∃ q, center q = g) (l t) (l' t) t :=
  Web.retains_bounded_iff

/-- **On a web, admitting what the step across standpoints forces is admitting every center.**
At a step, levels admit every formation the other levels admit whose continuation has
significance from `p` under every significance that meets each standpoint's presupposition
about its own continuation and is standpoint-invariant, exactly when they admit every center the
other levels admit (`forced_iff_center` read on a web). -/
theorem Web.admitsWithin_forced_iff {C : Type} {W : Web F C} {center : Pos → F} {p : Pos}
    {s t : Nat} {l l' : C → Nat} :
    W.AdmitsWithin (fun g => ∀ sig : Pos → Nat → F → Prop,
        (∀ q, SubTrue (Boundary (fun _ _ => False) (center q)) (SignificantWithin sig q)) →
          StandpointInvariant sig → sig p s g) l l' t ↔
      W.AdmitsWithin (fun g => ∃ q, center q = g) l l' t :=
  ⟨fun within g centered admits => within g ((forced_iff_center center p s g).mpr centered) admits,
   fun within g forced admits => within g ((forced_iff_center center p s g).mp forced) admits⟩

/-! ## The self drawn along every relation, and along being related at all -/

section Relations

variable {ι : Type}

/-- Being related by some relation of a family. -/
def Related (rel : ι → F → F → Prop) : F → F → Prop :=
  fun g h => ∃ i, rel i g h

/-- **The presupposition along every relation of a family** is significance over the union of
the closures: from `p`, the continuation of whatever lies within `f`'s closure along some
relation of the family has significance. -/
theorem subTrue_every_iff {rel : ι → F → F → Prop} {f : F} {sig : Pos → Nat → F → Prop}
    {p : Pos} :
    (∀ i, SubTrue (Boundary (rel i) f) (SignificantWithin sig p)) ↔
      ∀ t g, (∃ i, WithinClosure (rel i) f g) → sig p t g :=
  ⟨fun every t g ⟨i, within⟩ => subTrue_significantWithin_iff.mp (every i) t g within,
   fun union i => subTrue_significantWithin_iff.mpr fun t g within => union t g ⟨i, within⟩⟩

/-- Drawn along being related at all, the presupposition gives it along every relation of the
family. -/
theorem subTrue_every_of_related {rel : ι → F → F → Prop} {f : F} {sig : Pos → Nat → F → Prop}
    {p : Pos} (related : SubTrue (Boundary (Related rel) f) (SignificantWithin sig p)) :
    ∀ i, SubTrue (Boundary (rel i) f) (SignificantWithin sig p) :=
  fun i => subTrue_of_larger (fun _ _ holds => ⟨i, holds⟩) related

end Relations

/-! ## Witnesses -/

namespace Chain

/-- Three formations: the first bears one relation to the second, the second another to the
third. -/
inductive Formation where
  | first
  | second
  | third

/-- Relation `false` takes the first to the second, relation `true` the second to the third. -/
inductive rel : Bool → Formation → Formation → Prop where
  | one : rel false .first .second
  | two : rel true .second .third

/-- Along being related at all, the third lies within the first's closure. -/
theorem third_related : WithinClosure (Related rel) .first .third :=
  (WithinClosure.of_rel (rel := Related rel) ⟨false, .one⟩).trans
    (WithinClosure.of_rel (rel := Related rel) ⟨true, .two⟩)

/-- The first alone is closed under relation `true`. -/
def onlyFirst : Formation → Prop
  | .first => True
  | .second => False
  | .third => False

/-- The first and the second are closed under relation `false`. -/
def notThird : Formation → Prop
  | .first => True
  | .second => True
  | .third => False

/-- Along each relation alone, the third does not lie within the first's closure. -/
theorem third_not_within : ∀ i, ¬ WithinClosure (rel i) .first .third
  | false, within => within notThird (fun _ _ _ related => match related with
      | .one => trivial) trivial
  | true, within => within onlyFirst (fun _ _ inside related => match related, inside with
      | .two, no => no) trivial

/-- **Along every relation one at a time the self is smaller than along being related at all.**
Significance over the union of the first's closures makes its presupposition sub-true along
each relation, and not along being related at all. -/
theorem every_not_related :
    (∀ i, SubTrue (Boundary (rel i) .first)
        (SignificantWithin (fun (_ : Unit) _ g => ∃ i, WithinClosure (rel i) .first g) ())) ∧
      ¬ SubTrue (Boundary (Related rel) .first)
        (SignificantWithin (fun (_ : Unit) _ g => ∃ i, WithinClosure (rel i) .first g) ()) :=
  ⟨subTrue_every_iff.mpr fun _ _ union => union,
   fun related => match subTrue_significantWithin_iff.mp related 0 .third third_related with
     | ⟨i, within⟩ => third_not_within i within⟩

end Chain

namespace Clearing

/-- **Where only the clearer holds a standpoint, its part retains what has significance at the
centers, and under the continuation condition it loses the dweller.** The narrower scope and the
condition part exactly at a formation that is no standpoint's center. -/
theorem centers_retain_yet_loses {l : Nat → Place → Nat}
    (without : flow.WithheldLevels clearerPart web l)
    {sig : Unit → Nat → Formation → Prop} (unrestricted : Unrestricted sig) :
    web.Retains (atCenters fun (_ : Unit) => Formation.clearer) () web.level l ∧
      ¬ web.Retains sig () web.level l :=
  ⟨Web.retains_atCenters_iff.mpr fun t => ((loses_beyond without).1 t).2.2.narrow
      fun g ⟨_, same⟩ => match g, same with
        | .clearer, _ => trivial,
   (clearer_loses_dweller without unrestricted ()).2.1⟩

end Clearing

/-! ## Contents held de se and de dicto -/

/-- A content held *de se*: a property of a self, which each standpoint holds of its own center.
From `p` it gives significance to what the property says at `p`'s center. -/
def selfAscribed (content : F → Nat → F → Prop) (center : Pos → F) : Pos → Nat → F → Prop :=
  fun p t g => content (center p) t g

/-- A content held *de dicto*: one proposition, the same from every standpoint. -/
def shared (content : Nat → F → Prop) : Pos → Nat → F → Prop :=
  fun _ t g => content t g

/-- A shared content is standpoint-invariant. -/
theorem shared_standpointInvariant (content : Nat → F → Prop) :
    StandpointInvariant (shared (Pos := Pos) content) :=
  fun _ _ _ _ holds => holds

/-- **Standpoint-invariance is holding one shared content.** A significance is
standpoint-invariant exactly when it is, from every standpoint, one proposition held de dicto. -/
theorem standpointInvariant_iff_shared {sig : Pos → Nat → F → Prop} :
    StandpointInvariant sig ↔ ∃ content : Nat → F → Prop, ∀ p t g, sig p t g ↔ content t g :=
  ⟨fun invariant => ⟨fun t g => ∃ q, sig q t g, fun p t g =>
      ⟨fun holds => ⟨p, holds⟩, fun ⟨q, holds⟩ => invariant q p t g holds⟩⟩,
   fun ⟨_, same⟩ p q t g holds => (same q t g).mpr ((same p t g).mp holds)⟩

/-- **A content held de se is standpoint-invariant exactly where its readings at the centers
agree.** Every standpoint holds the same property; what it gives significance to changes with
the center it is read at. -/
theorem selfAscribed_standpointInvariant_iff {content : F → Nat → F → Prop} {center : Pos → F} :
    StandpointInvariant (selfAscribed content center) ↔
      ∀ p q t g, content (center p) t g → content (center q) t g :=
  Iff.rfl

/-- The self's presupposition as a property of a self: the continuation of what lies within the
self's own closure along a relation. -/
def ownClosure (rel : F → F → Prop) : F → Nat → F → Prop :=
  fun c _ g => WithinClosure rel c g

/-- Held de se, the own-closure content meets each standpoint's presupposition. -/
theorem ownClosure_presupposed (rel : F → F → Prop) (center : Pos → F) (p : Pos) :
    SubTrue (Boundary rel (center p)) (SignificantWithin (selfAscribed (ownClosure rel) center) p) :=
  subTrue_significantWithin_iff.mpr fun _ _ within => within

/-- **Held de se, the presupposition is standpoint-invariant exactly where the centers' closures
agree.** -/
theorem ownClosure_standpointInvariant_iff {rel : F → F → Prop} {center : Pos → F} :
    StandpointInvariant (selfAscribed (ownClosure rel) center) ↔
      ∀ p q g, WithinClosure rel (center p) g → WithinClosure rel (center q) g :=
  ⟨fun invariant p q g within => invariant p q 0 g within,
   fun agree p q _ g within => agree p q g within⟩

/-- **Held de se, the presupposition is the continuation condition exactly where every center's
closure is the whole.** -/
theorem ownClosure_unrestricted_iff {rel : F → F → Prop} {center : Pos → F} :
    Unrestricted (selfAscribed (ownClosure rel) center) ↔ ∀ p g, WithinClosure rel (center p) g :=
  ⟨fun unrestricted p g => unrestricted (p, 0, g), fun whole i => whole i.1 i.2.2⟩

/-- The de dicto reading of the presupposition: from every standpoint, the continuation of what
lies within some center's closure. -/
def withinSome (rel : F → F → Prop) (center : Pos → F) : Pos → Nat → F → Prop :=
  shared fun _ g => ∃ q, WithinClosure rel (center q) g

/-- **What the step across standpoints forces along a relation.** Under every significance that
makes each standpoint's presupposition sub-true at its center's closure and is
standpoint-invariant, the continuation of `g` has significance from `p` exactly when `g` lies
within some center's closure: the union of the closures, held de dicto. Along the empty relation
this is `forced_iff_center`. -/
theorem forced_iff_within_some (rel : F → F → Prop) (center : Pos → F) (p : Pos) (t : Nat)
    (g : F) :
    (∀ sig : Pos → Nat → F → Prop,
        (∀ q, SubTrue (Boundary rel (center q)) (SignificantWithin sig q)) →
          StandpointInvariant sig → sig p t g) ↔
      ∃ q, WithinClosure rel (center q) g :=
  ⟨fun forced => forced (withinSome rel center)
      (fun q => subTrue_significantWithin_iff.mpr fun _ _ within => ⟨q, within⟩)
      (shared_standpointInvariant _),
   fun ⟨q, within⟩ _ own invariant =>
     invariant q p t g (subTrue_significantWithin_iff.mp (own q) t g within)⟩

/-- **On a web, admitting what the step forces along a relation is admitting whatever lies
within some center's closure** (`forced_iff_within_some` read on a web). -/
theorem Web.admitsWithin_forced_within_some_iff {C : Type} {W : Web F C} {rel : F → F → Prop}
    {center : Pos → F} {p : Pos} {s t : Nat} {l l' : C → Nat} :
    W.AdmitsWithin (fun g => ∀ sig : Pos → Nat → F → Prop,
        (∀ q, SubTrue (Boundary rel (center q)) (SignificantWithin sig q)) →
          StandpointInvariant sig → sig p s g) l l' t ↔
      W.AdmitsWithin (fun g => ∃ q, WithinClosure rel (center q) g) l l' t :=
  ⟨fun within g some admits =>
     within g ((forced_iff_within_some rel center p s g).mpr some) admits,
   fun within g forced admits =>
     within g ((forced_iff_within_some rel center p s g).mp forced) admits⟩

/-- **Where the de se and the de dicto readings part.** The own closure held de se and the union
of closures held de dicto give significance alike from every standpoint exactly where whatever
lies within one center's closure lies within every center's. -/
theorem selfAscribed_iff_withinSome {rel : F → F → Prop} {center : Pos → F} :
    (∀ p t g, selfAscribed (ownClosure rel) center p t g ↔ withinSome rel center p t g) ↔
      ∀ p q g, WithinClosure rel (center q) g → WithinClosure rel (center p) g :=
  ⟨fun same p q g within => (same p 0 g).mpr ⟨q, within⟩,
   fun agree p _ g => ⟨fun within => ⟨p, within⟩, fun ⟨q, within⟩ => agree p q g within⟩⟩

/-- **Drawn along a relation under which every center's closure is the whole, the presupposition
held de se is the continuation condition**, with no step of invariance: along being related at
all in a connected unfolding, the de se question decides nothing. -/
theorem ownClosure_unrestricted_of_whole {rel : F → F → Prop} {center : Pos → F}
    (whole : ∀ p g, WithinClosure rel (center p) g) :
    Unrestricted (selfAscribed (ownClosure rel) center) :=
  ownClosure_unrestricted_iff.mpr whole

namespace Divided

/-- Two standpoints, each its own center, along the empty relation. -/
theorem not_within : ¬ WithinClosure (fun (_ _ : Bool) => False) false true :=
  fun within => Bool.noConfusion (within (fun g => g = false) (fun _ _ _ no => no.elim) rfl)

/-- Held de se, each standpoint's own continuation alone has significance from it, and the
significance is not standpoint-invariant. -/
theorem selfAscribed_not_invariant :
    ¬ StandpointInvariant (selfAscribed (ownClosure (fun (_ _ : Bool) => False)) (fun p : Bool => p)) :=
  fun invariant => not_within (ownClosure_standpointInvariant_iff.mp invariant true false true
    (WithinClosure.refl true))

/-- Held de dicto, both continuations have significance from both standpoints. -/
theorem withinSome_both (p : Bool) (t : Nat) (g : Bool) :
    withinSome (fun (_ _ : Bool) => False) (fun p : Bool => p) p t g :=
  ⟨g, WithinClosure.refl g⟩

end Divided

/-! ## Grades: standing and status -/

namespace Weighting

variable {X : Type}

/-- A graded significance is invariant when every standpoint gives every item the same grade. -/
def GradeInvariant (grade : Pos → X → Nat) : Prop :=
  ∀ p q x, grade p x = grade q x

/-- Its standing is invariant when an item counts at all from one standpoint exactly when it does
from another: the two-valued significance of a grade, standpoint-invariant. -/
def StandingInvariant (grade : Pos → X → Nat) : Prop :=
  ∀ p q x, 0 < grade p x → 0 < grade q x

/-- Invariant grades have invariant standing. -/
theorem standingInvariant_of_gradeInvariant {grade : Pos → X → Nat}
    (invariant : GradeInvariant grade) : StandingInvariant grade :=
  fun p q x positive => Eq.subst (motive := fun n => 0 < n) (invariant p q x) positive

/-- **Invariant grades rank alike from every standpoint.** -/
theorem weighed_eq_of_gradeInvariant {grade : Pos → X → Nat} (invariant : GradeInvariant grade)
    (items : List X) (a : X → Bool) (p q : Pos) :
    weighed items (grade p) a = weighed items (grade q) a :=
  total_congr (fun x => congrArg (fun n => cond (a x) n 0) (invariant p q x)) items

theorem ranks_alike_of_gradeInvariant {grade : Pos → X → Nat} (invariant : GradeInvariant grade)
    (items : List X) (a b : X → Bool) (p q : Pos) :
    weighed items (grade p) b < weighed items (grade p) a ↔
      weighed items (grade q) b < weighed items (grade q) a :=
  Eq.subst (motive := fun n => weighed items (grade p) b < weighed items (grade p) a ↔
      n < weighed items (grade q) a) (weighed_eq_of_gradeInvariant invariant items b p q)
    (Eq.subst (motive := fun n => weighed items (grade p) b < weighed items (grade p) a ↔
      weighed items (grade p) b < n) (weighed_eq_of_gradeInvariant invariant items a p q) Iff.rfl)

/-! ### Levels of continuation, priority and sufficiency -/

/-- A formation's level in a course: how many of its listed items (`of`) the course admits, the
steps at which its continuation is admitted. -/
def level (items : List X) (of : X → Bool) (a : X → Bool) : Nat :=
  weighed items (fun x => cond (of x) 1 0) a

/-- Inclusion never lowers a level. -/
theorem level_le_of_includes {items : List X} {a b : X → Bool} (of : X → Bool)
    (includes : IncludesOn items a b) : level items of b ≤ level items of a :=
  weighed_le_of_includes _ includes

theorem cond_one_pos : ∀ {v : Bool}, v = true → 0 < cond v 1 0
  | _, rfl => Nat.succ_pos 0

/-- A course including another and admitting one more item of a formation raises its level. -/
theorem level_lt_of_includes_at {items : List X} {a b : X → Bool} {of : X → Bool}
    (includes : IncludesOn items a b) {x : X} (listed : x ∈ items) (admits : a x = true)
    (not : b x = false) (own : of x = true) : level items of b < level items of a :=
  total_lt (fun y member => term_le (includes y member))
    ⟨x, listed, term_lt (cond_one_pos own) admits not⟩

/-- The sum over listed formations of a transform of their levels: utilitarian for the identity,
prioritarian for a strictly increasing, strictly concave transform. -/
def prior (gs : List F) (owner : F → X → Bool) (items : List X) (f : Nat → Nat) (a : X → Bool) :
    Nat :=
  total gs fun g => f (level items (owner g) a)

theorem le_of_strict {f : Nat → Nat} (increasing : ∀ m n, m < n → f m < f n) {m n : Nat}
    (le : m ≤ n) : f m ≤ f n :=
  match Nat.eq_or_lt_of_le le with
  | .inl same => Nat.le_of_eq (congrArg f same)
  | .inr less => Nat.le_of_lt (increasing m n less)

/-- **Every strictly increasing transform of levels ranks a widening higher**, where every
listed item belongs to some listed formation. Priority to the worse off, and the utilitarian
sum, agree with C wherever C ranks. -/
theorem prior_lt_of_widens {gs : List F} {owner : F → X → Bool} {items : List X} {f : Nat → Nat}
    (increasing : ∀ m n, m < n → f m < f n) (covers : ∀ x, x ∈ items → ∃ g, g ∈ gs ∧ owner g x = true)
    {a b : X → Bool} (widens : WidensOn items a b) :
    prior gs owner items f b < prior gs owner items f a :=
  match widens.2 with
  | ⟨x, listed, admits, not⟩ => match covers x listed with
    | ⟨g, member, own⟩ =>
      total_lt (fun h _ => le_of_strict increasing (level_le_of_includes (owner h) widens.1))
        ⟨g, member, increasing _ _ (level_lt_of_includes_at widens.1 listed admits not own)⟩

/-- **Priority to the worse off is increasing in admission**, so a class holding the positive
weightings and the prioritarian orders shares exactly widening (`widens_iff_every_of_class`). -/
theorem increasing_prior {gs : List F} {owner : F → X → Bool} {items : List X} {f : Nat → Nat}
    (increasing : ∀ m n, m < n → f m < f n)
    (covers : ∀ x, x ∈ items → ∃ g, g ∈ gs ∧ owner g x = true) :
    Increasing items (fun b a => prior gs owner items f b < prior gs owner items f a) :=
  fun _ _ widens => prior_lt_of_widens increasing covers widens

/-- A transform is strictly concave up to `n`: up to `n`, each increment is smaller than the one
before. (No transform of whole numbers into whole numbers is strictly concave everywhere: its
increments would fall without end; levels are bounded by the listed steps.) -/
def ConcaveTo (n : Nat) (f : Nat → Nat) : Prop :=
  ∀ k, k + 2 ≤ n → f k + f (k + 2) < f (k + 1) + f (k + 1)

theorem perm4 (A B C D : Nat) : (A + B) + (C + D) = (A + D) + (C + B) := by
  rw [Nat.add_comm C D, Nat.add_add_add_comm A B D C, Nat.add_comm B C]

theorem concave_gap {n : Nat} {f : Nat → Nat} (concave : ConcaveTo n f) (a : Nat) :
    ∀ d, a + d + 2 ≤ n → f a + f (a + d + 2) < f (a + 1) + f (a + d + 1)
  | 0, bound => concave a bound
  | d + 1, bound => by
    show f a + f (a + d + 3) < f (a + 1) + f (a + d + 2)
    have step : f (a + d + 1) + f (a + d + 3) < f (a + d + 2) + f (a + d + 2) :=
      concave (a + d + 1) bound
    have sum := Nat.add_lt_add (concave_gap concave a d (Nat.le_of_succ_le bound)) step
    rw [perm4 (f a) (f (a + d + 2)) (f (a + d + 1)) (f (a + d + 3)),
      Nat.add_add_add_comm (f (a + 1)) (f (a + d + 1)) (f (a + d + 2)) (f (a + d + 2))] at sum
    exact Nat.lt_of_add_lt_add_right sum

/-- **Priority decides a transfer that C leaves mixed.** Where one course gives a formation at
level `a` one step more and another at level `a + d + 2` one step less than another course, every
other listed formation's level the same, a strictly concave transform ranks the first higher. -/
theorem prior_transfer {n : Nat} {f : Nat → Nat} (concave : ConcaveTo n f) {g h : F}
    {rest : List F} {L L' : F → Nat} (a d : Nat) (bound : a + d + 2 ≤ n) (atG : L g = a + 1)
    (atH : L h = a + d + 1) (atG' : L' g = a) (atH' : L' h = a + d + 2)
    (same : ∀ k, k ∈ rest → L k = L' k) :
    total (g :: h :: rest) (fun k => f (L' k)) < total (g :: h :: rest) (fun k => f (L k)) :=
  have pair : f (L' g) + f (L' h) < f (L g) + f (L h) :=
    Eq.subst (motive := fun n => f (L' g) + f (L' h) < f n + f (L h)) atG.symm
      (Eq.subst (motive := fun n => f (L' g) + f (L' h) < f (a + 1) + f n) atH.symm
        (Eq.subst (motive := fun n => f n + f (L' h) < f (a + 1) + f (a + d + 1)) atG'.symm
          (Eq.subst (motive := fun n => f a + f n < f (a + 1) + f (a + d + 1)) atH'.symm
            (concave_gap concave a d bound))))
  have others : total rest (fun k => f (L' k)) = total rest (fun k => f (L k)) :=
    total_congr_on fun k member => congrArg f (same k member).symm
  Eq.subst (motive := fun n => f (L' g) + (f (L' h) + n) < f (L g) + (f (L h) + total rest fun k => f (L k)))
    others.symm
    (Eq.subst (motive := fun n => n < f (L g) + (f (L h) + total rest fun k => f (L k)))
      (Nat.add_assoc (f (L' g)) (f (L' h)) (total rest fun k => f (L k)))
      (Eq.subst (motive := fun n => f (L' g) + f (L' h) + total rest (fun k => f (L k)) < n)
        (Nat.add_assoc (f (L g)) (f (L h)) (total rest fun k => f (L k)))
        (Nat.add_lt_add_right pair _)))

/-- A transform is sufficient at `θ` when it rises no further from `θ` on. -/
def SufficientAt (θ : Nat) (f : Nat → Nat) : Prop :=
  ∀ k, θ ≤ k → f k = f θ

/-- **A threshold of sufficiency denies scope above it.** Where every listed formation's level is
the same in two courses or at least `θ` in both, a transform sufficient at `θ` weighs them alike:
continuation beyond enough is not counted. -/
theorem sufficient_ties {θ : Nat} {f : Nat → Nat} (sufficient : SufficientAt θ f) {gs : List F}
    {L L' : F → Nat} (above : ∀ k, k ∈ gs → L k = L' k ∨ (θ ≤ L k ∧ θ ≤ L' k)) :
    total gs (fun k => f (L k)) = total gs (fun k => f (L' k)) :=
  total_congr_on fun k member => match above k member with
    | .inl same => congrArg f same
    | .inr ⟨high, high'⟩ => (sufficient _ high).trans (sufficient _ high').symm

end Weighting

namespace Partial

/-- Two standpoints and two formations at one step; each standpoint grades its own formation two
and the other one. -/
def grade (p : Bool) (x : Bool) : Nat :=
  cond (x == p) 2 1

/-- Standing is invariant: every formation counts from every standpoint. -/
theorem cond_pos : ∀ v : Bool, 0 < cond v 2 1
  | true => Nat.succ_pos 1
  | false => Nat.succ_pos 0

theorem standing : Weighting.StandingInvariant grade :=
  fun _ q x _ => cond_pos (x == q)

/-- Grades are not invariant. -/
theorem not_gradeInvariant : ¬ Weighting.GradeInvariant grade :=
  fun invariant => absurd (invariant true false true) (by decide)

/-- From the first standpoint the course keeping its own formation ranks higher, from the second
the other course: invariant standing leaves the mixed comparison to each standpoint's grades. -/
theorem ranks_differ :
    Weighting.weighed [true, false] (grade true) (fun x => !x) <
        Weighting.weighed [true, false] (grade true) (fun x => x) ∧
      Weighting.weighed [true, false] (grade false) (fun x => x) <
        Weighting.weighed [true, false] (grade false) (fun x => !x) :=
  ⟨by decide, by decide⟩

end Partial

namespace LevelTransfer

/-- Two formations over three steps; an item is a step and a formation. -/
def items : List (Nat × Bool) :=
  [(0, true), (1, true), (2, true), (0, false), (1, false), (2, false)]

/-- The formation an item belongs to. -/
def owner (g : Bool) (x : Nat × Bool) : Bool :=
  x.2 == g

/-- The first formation continues for three steps and the second for one. -/
def uneven (x : Nat × Bool) : Bool :=
  cond x.2 (x.1 < 3) (x.1 < 1)

/-- Both formations continue for two steps. -/
def even (x : Nat × Bool) : Bool :=
  x.1 < 2

/-- The comparison is mixed. -/
theorem mixed : Weighting.MixedOn items even uneven :=
  ⟨⟨(1, false), .tail _ (.tail _ (.tail _ (.tail _ (.head _)))), rfl, rfl⟩,
   ⟨(2, true), .tail _ (.tail _ (.head _)), rfl, rfl⟩⟩

/-- A strictly concave transform: increments 6, 4, 2. -/
def concave (k : Nat) : Nat :=
  k * (7 - k)

theorem concave_to : Weighting.ConcaveTo 3 concave
  | 0, _ => by decide
  | 1, _ => by decide
  | k + 2, bound => absurd (Nat.le_trans (Nat.le_add_left 4 k) bound) (by decide)

/-- **The general law decides the witness**: with the formation that continues for one step
listed first, `prior_transfer` ranks the even course higher. -/
theorem by_law :
    Weighting.prior [false, true] owner items concave uneven <
      Weighting.prior [false, true] owner items concave even :=
  Weighting.prior_transfer concave_to (rest := []) 1 0 (Nat.le_refl 3) (by decide) (by decide)
    (by decide) (by decide) (fun _ member => nomatch member)

/-- Priority ranks the even course higher, the sum of levels ties them, and a convex transform
ranks the uneven course higher. -/
theorem decided :
    Weighting.prior [true, false] owner items concave uneven <
        Weighting.prior [true, false] owner items concave even ∧
      Weighting.prior [true, false] owner items (fun k => k) uneven =
        Weighting.prior [true, false] owner items (fun k => k) even ∧
      Weighting.prior [true, false] owner items (fun k => k * k) even <
        Weighting.prior [true, false] owner items (fun k => k * k) uneven :=
  ⟨by decide, by decide, by decide⟩

end LevelTransfer

end Becoming
