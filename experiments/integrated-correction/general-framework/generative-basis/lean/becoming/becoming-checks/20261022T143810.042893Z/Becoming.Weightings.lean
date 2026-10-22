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
  higher (`Weighting.weighed_lt_of_widens`, the case of net weightings below with nothing against);
  where one course admits an item the other does not, some positive weighting ranks it higher
  (`Weighting.outweighs`, a case of weights within a ratio below), so a mixed comparison is decided
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
  shared order does not depend on the representation. Lexical priority, the basic items first, is
  increasing in admission (`Weighting.lexical`, `Weighting.increasing_lexical`), so it lies within
  such a class and decides only what the shared order leaves mixed.
* **A weight of zero ties.** Where every item a course admits beyond another weighs nothing, the
  two weigh the same (`Weighting.weighed_eq_of_unweighted`): a weighting that leaves an item out
  does not rank a widening that adds only that item.
* **The same weight for every item ranks by number.** Under one positive weight for all items, a
  course weighs more exactly when it admits more items (`Weighting.weighed_const`,
  `Weighting.neutral_ranks_by_number`): the ratio one of weights within a ratio below.
* **What each course admits beyond the other.** Under any weights two courses compare as what each
  admits beyond the other (`Weighting.beyond`, `Weighting.weighed_split`,
  `Weighting.weighed_lt_iff_beyond`): what they share weighs the same in both.
* **Net weightings: an item can weigh below zero.** A net weighting counts each listed item for a
  course that admits it (`pos`) and against it (`neg`) (`Weighting.ranksNet`). It ranks two courses
  by what each admits beyond the other (`Weighting.ranksNet_iff_beyond`) and a widening higher where
  every item the widening adds weighs above zero (`Weighting.ranksNet_lt_of_widens`). A widening by
  one item alone (`Weighting.WidensBy`) it ranks as that item weighs, whatever else either course
  keeps: above where the item weighs above zero, below where it weighs below zero, and neither where
  it weighs zero (`Weighting.ranksNet_widensBy`, `Weighting.ranksNet_ties`); so the sign of its
  increment at an item (`Weighting.IncrementIs`) is the same in every context
  (`Weighting.ranksNet_increment_alike`), and it increases at every item weighing above zero
  (`Weighting.IncreasingAt`, `Weighting.ranksNet_increasingAt`).
* **Rankings of presentations: the exception.** A presentation is a plan with its wording and the
  order in which it is told; a ranking of presentations reads the sets on a pair where it ranks the
  two, each way, as an order on courses ranks what they keep (`Weighting.ReadsSetsOn`; on every
  pair, `Weighting.ReadsSets`). Read right, an order increasing at the item a wider plan alone adds
  ranks the wider above and never the narrower (`Weighting.reads_increasingAt`). Under a net
  weighting a narrowing ranked above its widening by one item is a pair not read right or an item
  weighing at zero or below (`Weighting.narrower_above_net`); read right, the narrowing is ranked
  above exactly where the item weighs below zero (`Weighting.reads_ranksNet`); read right on every
  pair with every item above zero, no widening by any number of items is ranked below
  (`Weighting.reads_ranksNet_widens`). A framing alone, the item weighing above zero, ranks a
  narrowing above its widening (`Framed.framing_alone`).
* **A sign measured apart.** Read right, the sign of the order's increment from the narrower course
  to the wider fixes the verdict exactly (`Weighting.reads_increment`): a sign measured with no
  plan shown predicts the ranking of a pair exactly where it is that increment's sign in the pair's
  context. Under a net weighting that holds in every context once it holds in one; in `Interacting`
  adding an item raises a course keeping nothing and lowers one keeping the other item, and no net
  weighting gives that order (`Interacting.increment_differs`, `Interacting.not_net`).
* **Weights within a ratio.** Where every two listed weights stand within `n / d` of each other
  (`Weighting.RatioWithin`), what each course alone admits bounds what it weighs
  (`Weighting.beyond_within`). Every positive weighting within `n / d` ranks `a` above `b` exactly
  where `n` times the number of items `b` alone admits is less than `d` times the number `a` alone
  admits (`Weighting.ranks_past_ratio`, `Weighting.every_within_iff`); the weighting tilted toward
  `b` (`Weighting.tilted`) decides the boundary and ties on it (`Weighting.tilted_lt_iff`,
  `Weighting.tilted_ties`). Some weighting within the ratio ranks `b` higher exactly short of it
  (`Weighting.some_within_reverses_iff`), so two rank a pair opposite ways exactly where `n / d`
  exceeds both what each side alone admits over what the other alone admits
  (`Weighting.opposite_within_iff`). Equal weights are the ratio one
  (`Weighting.const_lt_iff_beyond`).
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

Read a presentation as a plan as it is told and a ranking of presentations as a valuer's
judgment. Then T5's exception is `narrower_above_net` and `reads_increasingAt`: a valuer that reads
the case right ranks a narrowing above its widening only where the added formation weighs at zero
or below for it, zero giving a tie; otherwise the case was misread or framed. A sign measured apart
predicts the judgment exactly where it is the sign of the joint increment (`reads_increment`), which
an additive valuation carries from one context to every other and an interacting one need not:
where the two part, separate and joint evaluation part (Hsee). Read the ratio within which a
valuer's weights stand as how nearly alike it weighs everything at stake: valuers whose weights
stand within `r` of each other all rank the larger side of a mixed comparison higher where what it
alone keeps exceeds `r` times what the other alone keeps. Their disagreement needs weights
dispersed past that ratio, and it is easiest where the two sides alone keep alike in number.

Read a grade's positivity as standing (whether a formation counts) and the grade as status (how
much): the step, applied to two-valued significance, makes standing invariant and leaves status
to each standpoint; status invariant is a further premise. Read a formation's level as how long
its continuation is admitted: priority to the worse off agrees with C wherever C ranks and
decides transfers C leaves mixed; a threshold of sufficiency is a denial of scope above it.

What is not derived: whether the self's presupposition is held de se; that a standpoint's order
is increasing in admission (monotonicity, and that it counts every item, are supplied; additivity
is not needed for the shared order); which weighting a standpoint has; whether a valuer reads the
sets of a case, whether its sign measured apart is the sign of the joint increment, and how
dispersed its weights are, each measurable and none derived; that the impartial order is what
every standpoint shares rather than one privileged weighting; which formations are centers; the
step of invariance itself. The representation commits to finite listings of steps and formations,
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

theorem term_le_of {m n : Nat} : ∀ {v : Bool}, (v = true → m ≤ n) → cond v m 0 ≤ cond v n 0
  | true, le => le rfl
  | false, _ => Nat.le_refl 0

theorem term_lt_of {m n : Nat} : ∀ {v : Bool}, v = true → m < n → cond v m 0 < cond v n 0
  | _, rfl, lt => lt

theorem term_eq_at {m n : Nat} : ∀ {v : Bool}, (v = true → m = n) → cond v m 0 = cond v n 0
  | true, same => same rfl
  | false, _ => rfl

theorem cond_one_pos : ∀ {v : Bool}, v = true → 0 < cond v 1 0
  | _, rfl => Nat.succ_pos 0

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

/-! ### What each course admits beyond the other -/

/-- What `a` admits beyond `b`: the items `a` admits and `b` does not. -/
def beyond (a b : X → Bool) : X → Bool :=
  fun x => a x && !b x

/-- The number of listed items a course admits. -/
def size (items : List X) (a : X → Bool) : Nat :=
  weighed items (fun _ => 1) a

theorem term_split (v : Nat) : ∀ p q : Bool, cond p v 0 = cond (p && q) v 0 + cond (p && !q) v 0
  | true, true => rfl
  | true, false => (Nat.zero_add v).symm
  | false, _ => rfl

theorem and_parts : ∀ {p q : Bool}, (p && q) = true → p = true ∧ q = true
  | true, true, _ => ⟨rfl, rfl⟩
  | true, false, no => Bool.noConfusion no
  | false, _, no => Bool.noConfusion no

theorem and_of_parts : ∀ {p q : Bool}, p = true → q = true → (p && q) = true
  | _, _, rfl, rfl => rfl

theorem and_swap : ∀ p q : Bool, (p && q) = (q && p)
  | true, true => rfl
  | true, false => rfl
  | false, true => rfl
  | false, false => rfl

/-- **A weighted count is what a course shares with another and what it admits beyond it.** -/
theorem weighed_split (items : List X) (w : X → Nat) (a b : X → Bool) :
    weighed items w a = weighed items w (fun x => a x && b x) + weighed items w (beyond a b) :=
  (total_congr (fun x => term_split (w x) (a x) (b x)) items).trans (total_add _ _ items)

theorem weighed_shared (items : List X) (w : X → Nat) (a b : X → Bool) :
    weighed items w (fun x => a x && b x) = weighed items w (fun x => b x && a x) :=
  total_congr (fun x => congrArg (fun v => cond v (w x) 0) (and_swap (a x) (b x))) items

theorem weighed_split_right (items : List X) (w : X → Nat) (a b : X → Bool) :
    weighed items w b = weighed items w (fun x => a x && b x) + weighed items w (beyond b a) :=
  (weighed_split items w b a).trans
    (congrArg (· + weighed items w (beyond b a)) (weighed_shared items w b a))

theorem add_lt_add_iff {k m n : Nat} : k + m < k + n ↔ m < n :=
  ⟨Nat.lt_of_add_lt_add_left, fun lt => Nat.add_lt_add_left lt k⟩

theorem add_le_add_iff {k m n : Nat} : k + m ≤ k + n ↔ m ≤ n :=
  ⟨fun le => Nat.le_of_lt_succ (Nat.lt_of_add_lt_add_left (Nat.lt_succ_of_le le)),
   fun le => Nat.add_le_add_left le k⟩

/-- **Two courses compare as what each admits beyond the other**, whatever the weights: what they
share weighs the same in both. -/
theorem weighed_lt_iff_beyond (items : List X) (w : X → Nat) (a b : X → Bool) :
    weighed items w b < weighed items w a ↔
      weighed items w (beyond b a) < weighed items w (beyond a b) := by
  rw [weighed_split_right items w a b, weighed_split items w a b]
  exact add_lt_add_iff

theorem weighed_le_iff_beyond (items : List X) (w : X → Nat) (a b : X → Bool) :
    weighed items w b ≤ weighed items w a ↔
      weighed items w (beyond b a) ≤ weighed items w (beyond a b) := by
  rw [weighed_split_right items w a b, weighed_split items w a b]
  exact add_le_add_iff

theorem beyond_term_zero (v : Nat) : ∀ {p q : Bool}, (q = true → p = true) → cond (q && !p) v 0 = 0
  | _, false, _ => rfl
  | true, true, _ => rfl
  | false, true, kept => Bool.noConfusion (kept rfl)

/-- Nothing a course admits beyond one that includes it weighs anything. -/
theorem weighed_beyond_of_includes {items : List X} {a b : X → Bool} (w : X → Nat)
    (includes : IncludesOn items a b) : weighed items w (beyond b a) = 0 :=
  (total_congr_on fun x listed => beyond_term_zero (w x) (includes x listed)).trans (total_zero items)

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

theorem mul_lt_mul_iff {k m n : Nat} (positive : 0 < k) : m * k < n * k ↔ m < n :=
  ⟨fun lt => lt_of_mul_lt (k := k)
      (Eq.subst (motive := fun x => x < k * n) (Nat.mul_comm m k)
        (Eq.subst (motive := fun y => m * k < y) (Nat.mul_comm n k) lt)),
   fun lt => Eq.subst (motive := fun x => x < n * k) (Nat.mul_comm k m)
      (Eq.subst (motive := fun y => k * m < y) (Nat.mul_comm k n) (mul_lt_mul_pos positive lt))⟩

/-! ### Net weightings: items that weigh below zero -/

/-- The order of a net weighting: each listed item counts `pos` for a course that admits it and
`neg` against it, so it weighs above zero where `neg x < pos x`, at zero where they are equal and
below zero where `pos x < neg x`. `a` is ranked above `b` where what `a` gains less what it loses
exceeds `b`'s, compared without subtraction. A weighting is the net weighting with nothing
against. -/
def ranksNet (items : List X) (pos neg : X → Nat) : (X → Bool) → (X → Bool) → Prop :=
  fun b a => weighed items pos b + weighed items neg a < weighed items pos a + weighed items neg b

/-- **A net weighting ranks two courses by what each admits beyond the other**: what they share
gains and loses the same in both. -/
theorem ranksNet_iff_beyond (items : List X) (pos neg : X → Nat) (a b : X → Bool) :
    ranksNet items pos neg b a ↔
      weighed items pos (beyond b a) + weighed items neg (beyond a b) <
        weighed items pos (beyond a b) + weighed items neg (beyond b a) := by
  show weighed items pos b + weighed items neg a < weighed items pos a + weighed items neg b ↔ _
  rw [weighed_split_right items pos a b, weighed_split items neg a b, weighed_split items pos a b,
    weighed_split_right items neg a b,
    Nat.add_add_add_comm (weighed items pos fun x => a x && b x) (weighed items pos (beyond b a)),
    Nat.add_add_add_comm (weighed items pos fun x => a x && b x) (weighed items pos (beyond a b))]
  exact add_lt_add_iff

theorem not_of_neg : ∀ {v : Bool}, (!v) = true → v = false
  | false, _ => rfl
  | true, no => Bool.noConfusion no

theorem beyond_lt {items : List X} {pos neg : X → Nat} {a b : X → Bool}
    (above : ∀ x, x ∈ items → a x = true → b x = false → neg x < pos x)
    (exceeds : ExceedsOn items a b) :
    weighed items neg (beyond a b) < weighed items pos (beyond a b) :=
  match exceeds with
  | ⟨x, listed, admits, not⟩ =>
    total_lt (fun y member => term_le_of fun held => match and_parts held with
        | ⟨admits', not'⟩ => Nat.le_of_lt (above y member admits' (not_of_neg not')))
      ⟨x, listed, term_lt_of (and_of_parts admits (congrArg (!·) not)) (above x listed admits not)⟩

/-- **Every net weighting under which each item a widening adds weighs above zero ranks the
widening higher.** -/
theorem ranksNet_lt_of_widens {items : List X} {pos neg : X → Nat} {a b : X → Bool}
    (above : ∀ x, x ∈ items → a x = true → b x = false → neg x < pos x)
    (widens : WidensOn items a b) : ranksNet items pos neg b a := by
  apply (ranksNet_iff_beyond items pos neg a b).mpr
  rw [weighed_beyond_of_includes pos widens.1, weighed_beyond_of_includes neg widens.1,
    Nat.zero_add, Nat.add_zero]
  exact beyond_lt above widens.2

theorem cond_zero : ∀ v : Bool, cond v 0 0 = 0
  | true => rfl
  | false => rfl

theorem weighed_zero (items : List X) (a : X → Bool) : weighed items (fun _ => 0) a = 0 :=
  (total_congr (fun x => cond_zero (a x)) items).trans (total_zero items)

/-- **Every positive weighting ranks a widening higher**: the net weighting with nothing
against. -/
theorem weighed_lt_of_widens {items : List X} {a b : X → Bool} {w : X → Nat}
    (positive : Positive items w) (widens : WidensOn items a b) :
    weighed items w b < weighed items w a := by
  have net := ranksNet_lt_of_widens (neg := fun _ => 0) (fun x listed _ _ => positive x listed) widens
  rw [ranksNet, weighed_zero, weighed_zero] at net
  exact net

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

/-- On the listed items `a` widens `b` by `x` alone: it admits every item `b` admits and `x`,
which is listed and which `b` does not admit, and nothing else beyond `b`. -/
def WidensBy (items : List X) (x : X) (a b : X → Bool) : Prop :=
  IncludesOn items a b ∧ x ∈ items ∧ a x = true ∧ b x = false ∧
    ∀ y, y ∈ items → a y = true → b y = false → y = x

theorem widensOn_of_widensBy {items : List X} {x : X} {a b : X → Bool}
    (by_ : WidensBy items x a b) : WidensOn items a b :=
  ⟨by_.1, x, by_.2.1, by_.2.2.1, by_.2.2.2.1⟩

/-- Under a widening by one item, what is admitted beyond weighs that item's weight once for
each time it is listed. -/
theorem weighed_widensBy {items : List X} {x : X} {a b : X → Bool} (w : X → Nat)
    (by_ : WidensBy items x a b) :
    weighed items w (beyond a b) = w x * size items (beyond a b) :=
  (total_congr_on fun y listed => term_eq_at fun held => match and_parts held with
    | ⟨admits, not⟩ => congrArg w (by_.2.2.2.2 y listed admits (not_of_neg not))).trans
    (weighed_const (w x) items (beyond a b))

theorem size_widensBy_pos {items : List X} {x : X} {a b : X → Bool}
    (by_ : WidensBy items x a b) : 0 < size items (beyond a b) :=
  total_pos_of_mem by_.2.1 (cond_one_pos (and_of_parts by_.2.2.1 (congrArg (!·) by_.2.2.2.1)))

/-- **A net weighting ranks a widening by one item as that item weighs**, whatever else either
course keeps: the widening above exactly where the item weighs above zero, below exactly where it
weighs below zero. -/
theorem ranksNet_widensBy {items : List X} {pos neg : X → Nat} {x : X} {a b : X → Bool}
    (by_ : WidensBy items x a b) :
    (ranksNet items pos neg b a ↔ neg x < pos x) ∧ (ranksNet items pos neg a b ↔ pos x < neg x) := by
  have m := size_widensBy_pos by_
  have up : weighed items pos (beyond b a) + weighed items neg (beyond a b) <
      weighed items pos (beyond a b) + weighed items neg (beyond b a) ↔ neg x < pos x := by
    rw [weighed_beyond_of_includes pos by_.1, weighed_beyond_of_includes neg by_.1, Nat.zero_add,
      Nat.add_zero, weighed_widensBy pos by_, weighed_widensBy neg by_]
    exact mul_lt_mul_iff m
  have down : weighed items pos (beyond a b) + weighed items neg (beyond b a) <
      weighed items pos (beyond b a) + weighed items neg (beyond a b) ↔ pos x < neg x := by
    rw [weighed_beyond_of_includes pos by_.1, weighed_beyond_of_includes neg by_.1, Nat.zero_add,
      Nat.add_zero, weighed_widensBy pos by_, weighed_widensBy neg by_]
    exact mul_lt_mul_iff m
  exact ⟨(ranksNet_iff_beyond items pos neg a b).trans up,
    (ranksNet_iff_beyond items pos neg b a).trans down⟩

/-- **An item weighing zero ties.** Under a net weighting, a widening by one item weighing zero is
ranked neither above nor below what it widens. -/
theorem ranksNet_ties {items : List X} {pos neg : X → Nat} {x : X} {a b : X → Bool}
    (by_ : WidensBy items x a b) (zero : pos x = neg x) :
    ¬ ranksNet items pos neg b a ∧ ¬ ranksNet items pos neg a b :=
  ⟨fun ranked => Nat.lt_irrefl (neg x)
      (Eq.subst (motive := fun n => neg x < n) zero ((ranksNet_widensBy by_).1.mp ranked)),
   fun ranked => Nat.lt_irrefl (neg x)
      (Eq.subst (motive := fun n => n < neg x) zero ((ranksNet_widensBy by_).2.mp ranked))⟩

/-- An order on courses increases at `x`: it ranks every course that `x` alone widens strictly
above what it widens, and never below it. -/
def IncreasingAt (items : List X) (O : (X → Bool) → (X → Bool) → Prop) (x : X) : Prop :=
  ∀ a b, WidensBy items x a b → O b a ∧ ¬ O a b

/-- A net weighting increases at every listed item that weighs above zero. -/
theorem ranksNet_increasingAt {items : List X} {pos neg : X → Nat} {x : X}
    (above : neg x < pos x) : IncreasingAt items (ranksNet items pos neg) x :=
  fun _ _ by_ => ⟨(ranksNet_widensBy by_).1.mpr above,
    fun ranked => Nat.lt_asymm above ((ranksNet_widensBy by_).2.mp ranked)⟩

/-- The sign of an order's increment from `b` to `a`: `.gt` where it ranks `a` strictly above
`b`, `.lt` where strictly below, `.eq` where neither above the other. -/
def IncrementIs (O : (X → Bool) → (X → Bool) → Prop) (b a : X → Bool) : Ordering → Prop
  | .gt => O b a ∧ ¬ O a b
  | .eq => ¬ O b a ∧ ¬ O a b
  | .lt => O a b ∧ ¬ O b a

/-- Two orders that rank two pairs alike, each way, give their increments the same sign. -/
theorem increment_transfer {O O' : (X → Bool) → (X → Bool) → Prop} {a b a' b' : X → Bool}
    (up : O b a ↔ O' b' a') (down : O a b ↔ O' a' b') :
    ∀ {o : Ordering}, IncrementIs O b a o → IncrementIs O' b' a' o
  | .gt, ⟨above, not⟩ => ⟨up.mp above, fun r => not (down.mpr r)⟩
  | .eq, ⟨not, not'⟩ => ⟨fun r => not (up.mpr r), fun r => not' (down.mpr r)⟩
  | .lt, ⟨below, not⟩ => ⟨down.mp below, fun r => not (up.mpr r)⟩

/-- **A net weighting's increment at an item is the same in every context**: whatever else two
pairs of courses keep, where each widens by the same item alone, the sign of the increment is
the same. -/
theorem ranksNet_increment_alike {items : List X} {pos neg : X → Nat} {x : X}
    {a b a' b' : X → Bool} (by_ : WidensBy items x a b) (by' : WidensBy items x a' b')
    {o : Ordering} (increment : IncrementIs (ranksNet items pos neg) b a o) :
    IncrementIs (ranksNet items pos neg) b' a' o :=
  increment_transfer ((ranksNet_widensBy by_).1.trans (ranksNet_widensBy by').1.symm)
    ((ranksNet_widensBy by_).2.trans (ranksNet_widensBy by').2.symm) increment

/-! ### Rankings of presentations -/

variable {P : Type}

/-- A ranking of presentations reads the sets on the pair `a`, `b`: it ranks them, each way, as
the order `O` ranks the courses they keep. A presentation is a plan with its wording and the
order in which it is told; `kept` gives the course it keeps; `R b a` reads "`a` is ranked above
`b`". -/
def ReadsSetsOn (kept : P → X → Bool) (R : P → P → Prop) (O : (X → Bool) → (X → Bool) → Prop)
    (a b : P) : Prop :=
  (R b a ↔ O (kept b) (kept a)) ∧ (R a b ↔ O (kept a) (kept b))

/-- A ranking of presentations reads the sets: on every pair it ranks as `O` ranks the courses
kept, so it depends on the courses alone, not on how they are told. -/
def ReadsSets (kept : P → X → Bool) (R : P → P → Prop) (O : (X → Bool) → (X → Bool) → Prop) :
    Prop :=
  ∀ a b, R b a ↔ O (kept b) (kept a)

/-- **Read right, an order increasing at the added item never ranks the narrowing above.** Where a
ranking of presentations reads the sets on a pair that one item alone separates, and its order on
courses increases at that item, it ranks the wider plan above the narrower and never the narrower
above. So a ranking that puts a narrowing above its widening by one item either ranks that pair
otherwise than its order ranks the courses (a misread or a framing), or has an order that does not
increase at the added item. -/
theorem reads_increasingAt {kept : P → X → Bool} {R : P → P → Prop}
    {O : (X → Bool) → (X → Bool) → Prop} {items : List X} {x : X} {n w : P}
    (by_ : WidensBy items x (kept w) (kept n)) (reads : ReadsSetsOn kept R O w n)
    (increasing : IncreasingAt items O x) : R n w ∧ ¬ R w n :=
  match increasing _ _ by_ with
  | ⟨above, not⟩ => ⟨reads.1.mpr above, fun r => not (reads.2.mp r)⟩

/-- **A narrowing above its widening, under a net weighting.** Where a ranking of presentations
puts the narrower of two plans that one item alone separates above the wider, it does not read
the sets on that pair as the net weighting ranks them, or the added item weighs at zero or
below. -/
theorem narrower_above_net {kept : P → X → Bool} {R : P → P → Prop} {items : List X}
    {pos neg : X → Nat} {x : X} {n w : P} (by_ : WidensBy items x (kept w) (kept n))
    (violates : R w n) :
    ¬ ReadsSetsOn kept R (ranksNet items pos neg) w n ∨ pos x ≤ neg x :=
  match Nat.lt_or_ge (neg x) (pos x) with
  | .inl above => .inl fun reads =>
      (reads_increasingAt by_ reads (ranksNet_increasingAt above)).2 violates
  | .inr below => .inr below

/-- **Read right, a net weighting's verdict is the added item's sign.** Where a ranking reads the
sets on a pair that one item alone separates as a net weighting ranks them, it puts the narrower
plan above exactly where that item weighs below zero and the wider above exactly where it weighs
above zero; at zero it puts neither above (`ranksNet_ties`). -/
theorem reads_ranksNet {kept : P → X → Bool} {R : P → P → Prop} {items : List X}
    {pos neg : X → Nat} {x : X} {n w : P} (by_ : WidensBy items x (kept w) (kept n))
    (reads : ReadsSetsOn kept R (ranksNet items pos neg) w n) :
    (R w n ↔ pos x < neg x) ∧ (R n w ↔ neg x < pos x) :=
  ⟨reads.2.trans (ranksNet_widensBy by_).2, reads.1.trans (ranksNet_widensBy by_).1⟩

/-- **A ranking that reads the sets, under a net weighting in which every listed item weighs above
zero, never puts a narrowing above its widening**, by one item or by many. -/
theorem reads_ranksNet_widens {kept : P → X → Bool} {R : P → P → Prop} {items : List X}
    {pos neg : X → Nat} {n w : P} (reads : ReadsSets kept R (ranksNet items pos neg))
    (above : ∀ x, x ∈ items → neg x < pos x) (widens : WidensOn items (kept w) (kept n)) :
    R n w ∧ ¬ R w n :=
  have ranked := ranksNet_lt_of_widens (fun x listed _ _ => above x listed) widens
  ⟨(reads w n).mpr ranked, fun v => Nat.lt_asymm ranked ((reads n w).mp v)⟩

theorem reads_increment_of {kept : P → X → Bool} {R : P → P → Prop}
    {O : (X → Bool) → (X → Bool) → Prop} {n w : P} (reads : ReadsSetsOn kept R O w n) :
    ∀ {o : Ordering}, IncrementIs O (kept n) (kept w) o →
      (R w n ↔ o = .lt) ∧ (R n w ↔ o = .gt) ∧ ((¬ R w n ∧ ¬ R n w) ↔ o = .eq)
  | .gt, ⟨above, not⟩ =>
    ⟨⟨fun r => absurd (reads.2.mp r) not, fun e => Ordering.noConfusion e⟩,
     ⟨fun _ => rfl, fun _ => reads.1.mpr above⟩,
     ⟨fun ⟨_, nw⟩ => absurd (reads.1.mpr above) nw, fun e => Ordering.noConfusion e⟩⟩
  | .eq, ⟨not, not'⟩ =>
    ⟨⟨fun r => absurd (reads.2.mp r) not', fun e => Ordering.noConfusion e⟩,
     ⟨fun r => absurd (reads.1.mp r) not, fun e => Ordering.noConfusion e⟩,
     ⟨fun _ => rfl, fun _ => ⟨fun r => not' (reads.2.mp r), fun r => not (reads.1.mp r)⟩⟩⟩
  | .lt, ⟨below, not⟩ =>
    ⟨⟨fun _ => rfl, fun _ => reads.2.mpr below⟩,
     ⟨fun r => absurd (reads.1.mp r) not, fun e => Ordering.noConfusion e⟩,
     ⟨fun ⟨wn, _⟩ => absurd (reads.2.mpr below) wn, fun e => Ordering.noConfusion e⟩⟩

/-- **A sign measured apart fixes the verdict exactly where it is the sign of the increment in the
pair's context.** Let `apart x` be a valuer's sign for `x` measured with no plan shown: `.gt` where
the ending of `x` is a loss to it, `.eq` where nothing, `.lt` where a gain. Where a ranking reads
the sets on a pair that `x` separates, and that sign is the sign of the order's increment from the
narrower course to the wider (the premise that links the separate evaluation to the joint one), the
narrower plan is ranked above exactly where the sign is a gain, the wider exactly where it is a
loss, and neither exactly where it is nothing. Under a net weighting the premise holds in every
context once it holds in one (`ranksNet_increment_alike`); in `Interacting` it holds alone and
fails jointly. -/
theorem reads_increment {kept : P → X → Bool} {R : P → P → Prop}
    {O : (X → Bool) → (X → Bool) → Prop} {apart : X → Ordering} {x : X} {n w : P}
    (reads : ReadsSetsOn kept R O w n) (link : IncrementIs O (kept n) (kept w) (apart x)) :
    (R w n ↔ apart x = .lt) ∧ (R n w ↔ apart x = .gt) ∧
      ((¬ R w n ∧ ¬ R n w) ↔ apart x = .eq) :=
  reads_increment_of reads link

/-! ### Weights within a ratio: where valuers who weigh nearly alike agree -/

/-- Every two listed weights stand within the ratio `n / d`: `d` times either is at most `n`
times the other. Equal weights stand within `1 / 1`. -/
def RatioWithin (items : List X) (n d : Nat) (w : X → Nat) : Prop :=
  ∀ x y, x ∈ items → y ∈ items → d * w x ≤ n * w y

theorem cond_scale (k : Nat) : ∀ (v : Bool) (u : Nat), cond v (k * u) 0 = k * cond v u 0
  | true, _ => rfl
  | false, _ => (Nat.mul_zero k).symm

theorem weighed_scale (k : Nat) (items : List X) (w : X → Nat) (a : X → Bool) :
    weighed items (fun x => k * w x) a = k * weighed items w a :=
  (total_congr (fun x => cond_scale k (a x) (w x)) items).trans (total_mul k _ items)

theorem mul_swap_right (n u q : Nat) : n * u * q = n * q * u :=
  (mul_assoc_nat n u q).trans ((congrArg (n * ·) (Nat.mul_comm u q)).trans (mul_assoc_nat n q u).symm)

/-- **Weights within a ratio bound what each side weighs beyond the other.** Where every two
listed weights stand within `n / d`, `d` times what `b` alone admits weighs, taken once for each
item `a` alone admits, is at most `n` times the number of items `b` alone admits, times what `a`
alone admits weighs. -/
theorem beyond_within {items : List X} {n d : Nat} {w : X → Nat} {a b : X → Bool}
    (within : RatioWithin items n d w) :
    d * weighed items w (beyond b a) * size items (beyond a b) ≤
      n * size items (beyond b a) * weighed items w (beyond a b) :=
  have each : ∀ x, x ∈ items →
      d * weighed items w (beyond b a) ≤ n * w x * size items (beyond b a) := fun x listed =>
    Nat.le_trans (Nat.le_of_eq (weighed_scale d items w (beyond b a)).symm)
      (Nat.le_trans (total_le items fun y member => term_le_of fun _ => within y x member listed)
        (Nat.le_of_eq (weighed_const (n * w x) items (beyond b a))))
  Nat.le_trans (Nat.le_of_eq (weighed_const _ items (beyond a b)).symm)
    (Nat.le_trans (total_le items fun x listed => term_le_of fun _ => each x listed)
      (Nat.le_of_eq ((total_congr (fun x => congrArg (fun m => cond (beyond a b x) m 0)
          (mul_swap_right n (w x) (size items (beyond b a)))) items).trans
        (weighed_scale _ items w (beyond a b)))))

theorem pos_of_lt_mul {m d p : Nat} (lt : m < d * p) : 0 < p :=
  match p, lt with
  | _ + 1, _ => Nat.succ_pos _

theorem cond_pos_of {m : Nat} (positive : 0 < m) : ∀ {v : Bool}, 0 < cond v 1 0 → 0 < cond v m 0
  | true, _ => positive
  | false, zero => absurd zero (Nat.lt_irrefl 0)

/-- A course admitting some listed item weighs something under a positive weighting. -/
theorem weighed_pos_of_size {items : List X} {w : X → Nat} {a : X → Bool}
    (positive : Positive items w) (some : 0 < size items a) : 0 < weighed items w a :=
  match total_pos items some with
  | ⟨x, listed, one⟩ => total_pos_of_mem listed (cond_pos_of (positive x listed) one)

/-- A course admitting no listed item weighs nothing. -/
theorem weighed_zero_of_size {w : X → Nat} {a : X → Bool} :
    ∀ {items : List X}, size items a = 0 → weighed items w a = 0
  | [], _ => rfl
  | x :: rest, empty => match h : a x with
    | false =>
      have rest_none : size rest a = 0 := (Nat.zero_add _).symm.trans
        ((congrArg (fun v => cond v 1 0 + size rest a) h).symm.trans empty)
      (congrArg (fun v => cond v (w x) 0 + weighed rest w a) h).trans
        ((Nat.zero_add _).trans (weighed_zero_of_size rest_none))
    | true => Nat.noConfusion ((Nat.succ_add 0 (size rest a)).symm.trans
        ((congrArg (fun v => cond v 1 0 + size rest a) h).symm.trans empty))

/-- **Weights within a ratio rank by number past it.** Every positive weighting whose weights
stand within `n / d` of each other ranks `a` above `b` where `n` times the number of items `b`
alone admits is less than `d` times the number `a` alone admits. -/
theorem ranks_past_ratio {items : List X} {n d : Nat} {w : X → Nat} {a b : X → Bool}
    (positive : Positive items w) (within : RatioWithin items n d w)
    (gap : n * size items (beyond b a) < d * size items (beyond a b)) :
    weighed items w b < weighed items w a :=
  (weighed_lt_iff_beyond items w a b).mpr
    (match Nat.lt_or_ge (weighed items w (beyond b a)) (weighed items w (beyond a b)) with
    | .inl lt => lt
    | .inr ge =>
      have weighs := weighed_pos_of_size positive (pos_of_lt_mul gap)
      absurd (Nat.lt_of_le_of_lt
        (Nat.le_trans (Nat.mul_le_mul_left (d * size items (beyond a b)) ge)
          (Nat.le_trans (Nat.le_of_eq (mul_swap_right d _ _)) (beyond_within within)))
        (mul_lt_mul_iff weighs |>.mpr gap)) (Nat.lt_irrefl _))

/-- Where `n` times the number of items `b` alone admits is at most `d` times the number `a` alone
admits, every positive weighting within `n / d` weighs `a` at least as much as `b`. -/
theorem ranks_le_past_ratio {items : List X} {n d : Nat} {w : X → Nat} {a b : X → Bool}
    (positive_n : 0 < n) (within : RatioWithin items n d w)
    (gap : n * size items (beyond b a) ≤ d * size items (beyond a b)) :
    weighed items w b ≤ weighed items w a :=
  (weighed_le_iff_beyond items w a b).mpr
    (match Nat.lt_or_ge (weighed items w (beyond a b)) (weighed items w (beyond b a)) with
    | .inr ge => ge
    | .inl lt => match h : size items (beyond b a) with
      | 0 => absurd (Eq.subst (motive := fun v => weighed items w (beyond a b) < v)
          (weighed_zero_of_size h) lt) (Nat.not_lt_zero _)
      | q + 1 =>
        have dp : 0 < d * size items (beyond a b) :=
          Nat.lt_of_lt_of_le (Nat.mul_pos positive_n (Nat.succ_pos q))
            (Eq.subst (motive := fun v => n * v ≤ d * size items (beyond a b)) h gap)
        absurd (Nat.lt_of_lt_of_le (mul_lt_mul_pos dp lt)
          (Nat.le_trans (Nat.le_of_eq (mul_swap_right d _ _))
            (Nat.le_trans (beyond_within within) (Nat.mul_le_mul_right _ gap))))
          (Nat.lt_irrefl _))

/-- The weighting tilted toward `b`: weight `n` on what `b` admits beyond `a`, `d` on every
other item. -/
def tilted (n d : Nat) (a b : X → Bool) : X → Nat :=
  fun x => cond (beyond b a x) n d

theorem cond_between {n d : Nat} (le : d ≤ n) : ∀ v : Bool, d ≤ cond v n d ∧ cond v n d ≤ n
  | true => ⟨le, Nat.le_refl n⟩
  | false => ⟨Nat.le_refl d, le⟩

theorem tilted_positive {n d : Nat} (positive : 0 < d) (le : d ≤ n) (items : List X)
    (a b : X → Bool) : Positive items (tilted n d a b) :=
  fun x _ => Nat.lt_of_lt_of_le positive (cond_between le (beyond b a x)).1

theorem tilted_within {n d : Nat} (le : d ≤ n) (items : List X) (a b : X → Bool) :
    RatioWithin items n d (tilted n d a b) :=
  fun x y _ _ => Nat.le_trans (Nat.mul_le_mul_left d (cond_between le (beyond b a x)).2)
    (Nat.le_trans (Nat.le_of_eq (Nat.mul_comm d n))
      (Nat.mul_le_mul_left n (cond_between le (beyond b a y)).1))

theorem tilt_beyond (n d : Nat) : ∀ p q : Bool, cond (p && !q) (cond (q && !p) n d) 0 = cond (p && !q) d 0
  | true, true => rfl
  | true, false => rfl
  | false, _ => rfl

theorem tilt_toward (n d : Nat) : ∀ v : Bool, cond v (cond v n d) 0 = cond v n 0
  | true => rfl
  | false => rfl

theorem weighed_tilted_beyond (n d : Nat) (items : List X) (a b : X → Bool) :
    weighed items (tilted n d a b) (beyond a b) = d * size items (beyond a b) :=
  (total_congr (fun x => tilt_beyond n d (a x) (b x)) items).trans (weighed_const d items (beyond a b))

theorem weighed_tilted_toward (n d : Nat) (items : List X) (a b : X → Bool) :
    weighed items (tilted n d a b) (beyond b a) = n * size items (beyond b a) :=
  (total_congr (fun x => tilt_toward n d (beyond b a x)) items).trans
    (weighed_const n items (beyond b a))

/-- The tilted weighting ranks `a` above `b` exactly where `n` times what `b` alone admits is
less than `d` times what `a` alone admits. -/
theorem tilted_lt_iff (n d : Nat) (items : List X) (a b : X → Bool) :
    weighed items (tilted n d a b) b < weighed items (tilted n d a b) a ↔
      n * size items (beyond b a) < d * size items (beyond a b) :=
  (weighed_lt_iff_beyond items _ a b).trans (by rw [weighed_tilted_beyond, weighed_tilted_toward])

theorem tilted_gt_iff (n d : Nat) (items : List X) (a b : X → Bool) :
    weighed items (tilted n d a b) a < weighed items (tilted n d a b) b ↔
      d * size items (beyond a b) < n * size items (beyond b a) :=
  (weighed_lt_iff_beyond items _ b a).trans (by rw [weighed_tilted_beyond, weighed_tilted_toward])

/-- **At the boundary the tilted weighting ties.** Where `n` times what `b` alone admits is `d`
times what `a` alone admits, the tilted weighting weighs the two courses alike. -/
theorem tilted_ties {n d : Nat} {items : List X} {a b : X → Bool}
    (boundary : n * size items (beyond b a) = d * size items (beyond a b)) :
    weighed items (tilted n d a b) a = weighed items (tilted n d a b) b := by
  rw [weighed_split items _ a b, weighed_split_right items _ a b, weighed_tilted_beyond,
    weighed_tilted_toward, boundary]

/-- **Where weights stand within a ratio, the side admitting more wins exactly past it.** Every
positive weighting whose weights stand within `n / d` of each other (`0 < d ≤ n`) ranks `a` above
`b` exactly where `n` times the number of items `b` alone admits is less than `d` times the number
`a` alone admits; the tilted weighting decides the boundary. -/
theorem every_within_iff {items : List X} {n d : Nat} {a b : X → Bool} (positive : 0 < d)
    (le : d ≤ n) :
    (∀ w, Positive items w → RatioWithin items n d w → weighed items w b < weighed items w a) ↔
      n * size items (beyond b a) < d * size items (beyond a b) :=
  ⟨fun every => (tilted_lt_iff n d items a b).mp
      (every _ (tilted_positive positive le items a b) (tilted_within le items a b)),
   fun gap _ positive' within => ranks_past_ratio positive' within gap⟩

/-- **Some weighting within the ratio ranks the other side higher exactly short of it.** -/
theorem some_within_reverses_iff {items : List X} {n d : Nat} {a b : X → Bool}
    (positive : 0 < d) (le : d ≤ n) :
    (∃ w, Positive items w ∧ RatioWithin items n d w ∧ weighed items w a < weighed items w b) ↔
      d * size items (beyond a b) < n * size items (beyond b a) :=
  ⟨fun ⟨_, _, within, lt⟩ =>
    match Nat.lt_or_ge (d * size items (beyond a b)) (n * size items (beyond b a)) with
    | .inl short => short
    | .inr past => absurd lt (Nat.not_lt_of_le
        (ranks_le_past_ratio (Nat.lt_of_lt_of_le positive le) within past)),
   fun short => ⟨tilted n d a b, tilted_positive positive le items a b, tilted_within le items a b,
     (tilted_gt_iff n d items a b).mpr short⟩⟩

/-- **Valuers whose weights stand within a ratio rank a pair opposite ways exactly where the ratio
exceeds what each side alone admits over what the other alone admits.** Two positive weightings
within `n / d` rank `a` and `b` opposite ways exactly where `d` times the number of items each
alone admits is less than `n` times the number the other alone admits. Equal weights (`n = d`)
never do; a widening, where `b` admits nothing beyond `a`, never is. -/
theorem opposite_within_iff {items : List X} {n d : Nat} {a b : X → Bool} (positive : 0 < d)
    (le : d ≤ n) :
    ((∃ w, Positive items w ∧ RatioWithin items n d w ∧ weighed items w b < weighed items w a) ∧
      ∃ w, Positive items w ∧ RatioWithin items n d w ∧ weighed items w a < weighed items w b) ↔
      d * size items (beyond b a) < n * size items (beyond a b) ∧
        d * size items (beyond a b) < n * size items (beyond b a) :=
  ⟨fun ⟨up, down⟩ => ⟨(some_within_reverses_iff (a := b) (b := a) positive le).mp up,
      (some_within_reverses_iff positive le).mp down⟩,
   fun ⟨up, down⟩ => ⟨(some_within_reverses_iff (a := b) (b := a) positive le).mpr up,
      (some_within_reverses_iff positive le).mpr down⟩⟩

/-- Under one positive weight for every item, a course weighs more exactly where it admits more
beyond the other than the other admits beyond it: weights within `1 / 1`. -/
theorem const_lt_iff_beyond {k : Nat} (positive : 0 < k) (items : List X) (a b : X → Bool) :
    weighed items (fun _ => k) b < weighed items (fun _ => k) a ↔
      size items (beyond b a) < size items (beyond a b) :=
  have within : RatioWithin items 1 1 (fun _ => k) := fun _ _ _ _ => Nat.le_refl _
  have positive' : Positive items (fun _ => k) := fun _ _ => positive
  ⟨fun lt => match Nat.lt_or_ge (size items (beyond b a)) (size items (beyond a b)) with
    | .inl less => less
    | .inr ge => absurd lt (Nat.not_lt_of_le (ranks_le_past_ratio (a := b) (b := a)
        (Nat.succ_pos 0) within (Eq.subst (motive := fun v => v ≤ 1 * size items (beyond b a))
          (Nat.one_mul _).symm (Eq.subst (motive := fun v => size items (beyond a b) ≤ v)
            (Nat.one_mul _).symm ge)))),
   fun less => ranks_past_ratio positive' within
     (Eq.subst (motive := fun v => v < 1 * size items (beyond a b)) (Nat.one_mul _).symm
       (Eq.subst (motive := fun v => size items (beyond b a) < v) (Nat.one_mul _).symm less))⟩

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

theorem size_le_length (items : List X) (a : X → Bool) : size items a ≤ items.length :=
  Nat.le_trans (total_le items fun x _ => cond_le_one (a x)) (Nat.le_of_eq (total_ones items))

theorem size_pos_of_exceeds {items : List X} {a b : X → Bool} (exceeds : ExceedsOn items a b) :
    0 < size items (beyond a b) :=
  match exceeds with
  | ⟨_, listed, admits, not⟩ => total_pos_of_mem listed (cond_one_pos (and_of_parts admits (congrArg (!·) not)))

/-- **A course admitting an item the other does not is ranked higher by some positive
weighting**: the weighting tilted toward it, with weight one more than the number of listed items
on what it alone admits and one elsewhere, stands past the ratio. -/
theorem outweighs {items : List X} {a b : X → Bool} (exceeds : ExceedsOn items b a) :
    ∃ w, Positive items w ∧ weighed items w a < weighed items w b :=
  match (some_within_reverses_iff (items := items) (n := items.length + 1) (d := 1) (a := a) (b := b)
      (Nat.succ_pos 0) (Nat.succ_le_succ (Nat.zero_le _))).mpr
      (Nat.lt_of_le_of_lt (Nat.le_of_eq (Nat.one_mul _)) (Nat.lt_of_lt_of_le
        (Nat.lt_succ_of_le (size_le_length items (beyond a b)))
        (Nat.le_trans (Nat.le_of_eq (Nat.mul_one _).symm)
          (Nat.mul_le_mul_left _ (size_pos_of_exceeds exceeds))))) with
  | ⟨w, positive, _, lt⟩ => ⟨w, positive, lt⟩

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

/-- **A weighting the same for every item ranks by number.** Under one positive weight for every
item, one course is weighed above another exactly when it admits more of the listed items: the
case `1 / 1` of weights within a ratio. -/
theorem neutral_ranks_by_number {k : Nat} (positive : 0 < k) (items : List X) (a b : X → Bool) :
    weighed items (fun _ => k) b < weighed items (fun _ => k) a ↔
      weighed items (fun _ => 1) b < weighed items (fun _ => 1) a :=
  (const_lt_iff_beyond positive items a b).trans (weighed_lt_iff_beyond items _ a b).symm

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

/-! ### Lexical priority -/

/-- A course restricted to the items `p` marks. -/
def restrict (p a : X → Bool) : X → Bool :=
  fun x => p x && a x

/-- Inclusion passes to the items `p` marks. -/
theorem includes_restrict (p : X → Bool) {items : List X} {a b : X → Bool}
    (includes : IncludesOn items a b) : IncludesOn items (restrict p a) (restrict p b) :=
  fun x listed held => match and_parts held with
    | ⟨marked, admits⟩ => and_of_parts marked (includes x listed admits)

/-- Lexical priority on the listed items, the basic ones (`basic`) first: `a` is ranked above `b`
when it widens `b` on the basic items, or admits exactly `b`'s basic items and widens `b` on the
others. -/
def lexical (items : List X) (basic : X → Bool) : (X → Bool) → (X → Bool) → Prop :=
  fun b a => WidensOn items (restrict basic a) (restrict basic b) ∨
    (IncludesOn items (restrict basic a) (restrict basic b) ∧
      IncludesOn items (restrict basic b) (restrict basic a) ∧
      WidensOn items (restrict (fun x => !basic x) a) (restrict (fun x => !basic x) b))

theorem gain_at : ∀ {bx ax bbx : Bool}, ax = true → bbx = false →
    ((bx && ax) = true → (bx && bbx) = true) → (!bx && ax) = true ∧ (!bx && bbx) = false
  | false, _, _, rfl, rfl, _ => ⟨rfl, rfl⟩
  | true, _, _, rfl, rfl, back => Bool.noConfusion (back rfl)

/-- **Lexical priority is increasing in admission.** It ranks every widening higher, so it lies
within the classes whose shared order is exactly widening (`widens_iff_every_of_class`), and it
decides only comparisons that order leaves mixed. -/
theorem increasing_lexical (items : List X) (basic : X → Bool) :
    Increasing items (lexical items basic) :=
  fun a b widens => match widens.2 with
  | ⟨x, listed, admits, not⟩ =>
    match exceeds_or_includes (restrict basic a) (restrict basic b) items with
    | .inl exceeds => .inl ⟨includes_restrict basic widens.1, exceeds⟩
    | .inr back => .inr ⟨includes_restrict basic widens.1, back,
        includes_restrict (fun y => !basic y) widens.1,
        ⟨x, listed, (gain_at admits not (back x listed)).1, (gain_at admits not (back x listed)).2⟩⟩

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

namespace Framed

/-- One item; a presentation keeps it or not (`.1`) and is framed or not (`.2`). -/
def kept (p : Bool × Bool) : Unit → Bool :=
  fun _ => p.1

/-- A ranking that puts a framed presentation above an unframed one, and otherwise the one that
keeps the item above the one that does not: it depends on the wording, not only on the sets. -/
def ranks (b a : Bool × Bool) : Prop :=
  (a.2 = true ∧ b.2 = false) ∨ (a.2 = b.2 ∧ a.1 = true ∧ b.1 = false)

/-- The item weighs one for and nothing against: the order on courses increases at it. -/
theorem increasing :
    Weighting.IncreasingAt [()] (Weighting.ranksNet [()] (fun _ => 1) (fun _ => 0)) () :=
  Weighting.ranksNet_increasingAt (Nat.succ_pos 0)

theorem widensBy : Weighting.WidensBy [()] () (kept (true, false)) (kept (false, true)) :=
  ⟨fun _ _ _ => rfl, .head _, rfl, rfl, fun _ _ _ _ => rfl⟩

/-- **A framing alone puts a narrowing above its widening**: the framed plan that keeps nothing is
ranked above the unframed plan that keeps the item, though the item weighs above zero; so the
ranking does not read the sets on that pair. -/
theorem framing_alone :
    ranks (true, false) (false, true) ∧
      ¬ Weighting.ReadsSetsOn kept ranks (Weighting.ranksNet [()] (fun _ => 1) (fun _ => 0))
        (true, false) (false, true) :=
  ⟨.inl ⟨rfl, rfl⟩, fun reads => (Weighting.reads_increasingAt widensBy reads increasing).2 (.inl ⟨rfl, rfl⟩)⟩

end Framed

namespace Interacting

/-- Two items, `true` and `false`. A course is scored by how it keeps them together: `true` kept
scores one with or without `false`, `false` kept alone scores two, neither nothing. Adding
`true` raises a course that keeps nothing and lowers one that keeps `false`. -/
def score (c : Bool → Bool) : Nat :=
  cond (c true) 1 (cond (c false) 2 0)

/-- The order of the score. -/
def order (b a : Bool → Bool) : Prop :=
  score b < score a

def items : List Bool := [true, false]

def neither : Bool → Bool := fun _ => false
def onlyTrue : Bool → Bool := fun z => z
def onlyFalse : Bool → Bool := fun z => !z
def both : Bool → Bool := fun _ => true

theorem eq_true_of_not_false : ∀ {v : Bool}, (!v) = false → v = true
  | true, _ => rfl
  | false, no => Bool.noConfusion no

theorem alone : Weighting.WidensBy items true onlyTrue neither :=
  ⟨fun _ _ no => Bool.noConfusion no, .head _, rfl, rfl, fun _ _ admits _ => admits⟩

theorem jointly : Weighting.WidensBy items true both onlyFalse :=
  ⟨fun _ _ _ => rfl, .head _, rfl, rfl, fun _ _ _ not => eq_true_of_not_false not⟩

/-- **The increment at an item can depend on what else is kept.** Adding `true` to a course that
keeps nothing is ranked a gain of it (its ending, measured apart, a loss), and adding it to the
course that keeps `false` is ranked below: the sign measured alone is not the sign in the joint
context, so a ranking that reads the sets exactly puts the narrowing that keeps `false` above
its widening by `true`. -/
theorem increment_differs :
    Weighting.IncrementIs order neither onlyTrue .gt ∧
      Weighting.IncrementIs order onlyFalse both .lt :=
  ⟨⟨(by decide : score neither < score onlyTrue), (by decide : ¬ score onlyTrue < score neither)⟩,
   ⟨(by decide : score both < score onlyFalse), (by decide : ¬ score onlyFalse < score both)⟩⟩

/-- **No net weighting gives this order**: a net weighting's increment at an item is the same in
every context (`Weighting.ranksNet_increment_alike`). -/
theorem not_net :
    ¬ ∃ pos neg : Bool → Nat, ∀ b a, order b a ↔ Weighting.ranksNet items pos neg b a :=
  fun ⟨_, _, same⟩ =>
    match Weighting.ranksNet_increment_alike alone jointly
      (Weighting.increment_transfer (same neither onlyTrue) (same onlyTrue neither)
        increment_differs.1) with
    | ⟨_, not⟩ => not ((same both onlyFalse).mp increment_differs.2.1)

end Interacting

end Becoming
