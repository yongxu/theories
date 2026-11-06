import Becoming.PremiseWitnesses
import Becoming.GrammarPath

/-!
# What would give C's order on a listing: the routes, each stated, with where it stops

Board item CW. C (`Comparison`) orders; the continuation condition fixes scope; neither is asserted,
and on a frame with an extension a statement reading no order entails C only where it fails
(`ReadsNoOrder.not_entails`). This module states the routes to C's order the repository names, on one
listing, and relates them. It does not derive C from anything and gives no reason for it: every route
below takes a premise that reads an order. What it adds is what "weaker" can mean and where each route
rests. Every route ends in an order increasing in admission on a finite listing. That is what C asks
only on a frame reading a course by what it admits on that listing (`listingFrame`), and a course on a
listing need not be what any level path admits.

* **What "weaker" can mean.** C here is a condition an order meets or fails: every extension ranked above
  what it extends. Call a premise on orders strictly weaker than C at a datum where C implies it and some
  order meets it and fails C. Let a further statement, the help, read no order and hold at a datum. A
  premise that with that help gives C at that datum implies C there (`ReadsNoOrder.implies_comparison`),
  so no order meets it and fails C (`ReadsNoOrder.not_strictly_weaker`), and if C also implies it, it is
  C there (`ReadsNoOrder.iff_of_weaker`). So no premise is both strictly weaker than C at a datum and,
  with such help holding there, enough for C at that datum. It can, where it reads the datum as self-concern
  reads a marking, give C at one datum and be strictly weaker at another; or be weaker in scope, giving
  C over less than all of what C compares; or be strictly
  weaker at that datum and not give C with that help. Near-definitional: it sorts the senses of the word.
  Self-concern shows the first of these. On a frame reading a course by what it admits on a listing, with
  the process free and every claim counted as living, so that scope is already total (`listingFrame`), an
  order meets C exactly when it is increasing in admission (`comparison_listingFrame_iff`); there, with
  every listed item marked, an order is self-concerned exactly when it meets C, through the law above
  (`increasingInOwn_iff_comparison`): one premise in two forms, and no reason for either. With an item
  unmarked, some self-concerned order fails it (`exists_increasingInOwn_not_increasing`). Where the help
  itself reads an order, a premise can be strictly weaker at one datum and still give C with it: being
  increasing gives `StepAlike` (`Increasing.stepAlike`), which with transitivity does not give it back
  (`ranksLighter_transitive`, `ranksLighter_alike`, `ranksLighter_reverses`); there the help supplies the
  order the premise lacks.
* **Choosers.** A chooser here is a pair of values, and none is asserted to exist: a valuation `u` of the
  listed items, which may put an item below refusal, and a value of refusing, both fixed across courses.
  From a course it takes one item, so it reaches the highest of refusal and what the course admits
  (`reach`); it is read, not modelled, as choosing later. A course that includes another is never lower for
  any chooser (`reach_le_of_includes`). That is near-definitional: `reach` is a maximum, which builds in
  that what a chooser leaves costs it nothing. Added items a chooser would each leave change nothing for it
  (`reach_eq_of_refused`). `a` widens `b` exactly when no chooser does worse by its own valuation from
  `a` than from `b` and some does better by its own (`widens_iff_noneWorseSomeBetter`), and an order is
  increasing in admission exactly when it ranks above whatever that holds of
  (`increasing_iff_ranks_noneWorseSomeBetter`). Beside `widens_iff_every_positive` this assumes of no
  chooser that it values any item. The range over every possible valuation does that work, and what is
  assumed instead is that a merely possible chooser counts: the one valuing only what a course leaves out,
  with refusal at zero (`outside`), does better from any widening of that course and stops the relation on
  any pair where the first does not include the second. What a range needs is exact: for every widening
  some chooser in it does better, exactly when, for each listed item, some chooser in it puts that item
  above every other listed item and above refusal (`gains_every_widening_iff`). What stays a premise is
  calling better what no chooser does worse from and some does better from. The route stops at witnesses:
  - *Imposed.* Where what is admitted is imposed, an item a net weighting counts below zero can put a
    widening below what it widens, while a chooser who leaves it is unchanged (`Refusing`).
  - *Another's order.* Where the chooser's order is not the order reading the result, the chooser can
    gain and what it takes stand lower in that order (`AnotherReads`).
  - *Several choosers.* Where a choice bears on what the other gets, widening the one menu both choose
    from can lower what each gets by the game's payoffs, which read both acts and not an item alone: in a
    witness, the prisoner's dilemma read as a menu, at the only mutual best response, the pure Nash
    equilibrium of one play (`Restraint`); where no choice bears on another's it cannot
    (`not_lowered_of_no_bearing`).

  All three relate their courses by the same `WidensOn`, so on the frame above every order meeting C ranks
  the wider above the narrower (`Refusing.comparison_ranks_wide`, `AnotherReads.comparison_ranks_wide`,
  `Restraint.comparison_ranks_wide`) while the net weighting falls, what the chooser takes stands lower in the
  reading order, or what each gets falls. That is no inconsistency: C's comparison reads what is admitted, the
  other a net weighting of what is imposed, another's order or what each gets by the payoffs; neither reading
  is shown to be the one that counts. Whether a menu of acts is a course of what can form is not shown here:
  `listingFrame` reads anything listed as a course by construction. The several-chooser witness is a theorem
  on that frame, and there it stands against this route and against reading C as "more options are better",
  and is what C does there; that does not lapse. Its bearing on courses of what can form, and so on C, stands
  until the full account is shown to remove it, by showing that no wider course of what can form has this
  shape: one course widening another while, at the pure Nash equilibrium of one play among those choosing
  within it, what each gets falls. Whether one has it is open; if one has, the witness stands against C there
  too.
* **Standpoints.** Let each standpoint's order be self-concerned (`IncreasingInOwn`) and rank no
  widening below what it widens (`NotBelow`), and read what they share as the Pareto relation among them
  (`ParetoAmong`: some standpoint ranks a course above, none below, and one ranking neither counts as no
  objection, a modelling choice). One course
  is ranked above another by every such profile exactly when it widens the other and adds to some
  standpoint's own (`every_pareto_iff`), so every such profile's relation is increasing in admission
  exactly when every listed item is some standpoint's own (`pareto_increasing_iff_covers`). That asks
  less than the condition held de se, which marks every item from every standpoint (`EachItsOwn`), and a
  standpoint whose marking leaves a listed item need not have an order increasing in admission
  (`exists_selfConcerned_notBelow_not_increasing`). It costs `NotBelow`, asked of every standpoint at every
  item, its own or not: an order ranking below every widening that adds nothing to its own is
  self-concerned, and the relation then does not rank such a widening, whatever the others' orders
  (`notOwnBelow_stops`). On three listed items no positive weighting's order is exactly widening: a total
  leaves a pair unranked only by tying it, so it would tie two mixed pairs and weigh the third item nothing
  (`widening_is_no_weighting`).
* **One item at a time.** Given a widening by one item, a transitive order is increasing in admission
  exactly when every such widening gets one verdict (`StepAlike`) and the given one is ranked above what it
  widens (`increasing_iff_one_step`). Near logic, and what it shows is what each part does. Without
  transitivity, ranking every one-item widening does not give every widening (`byOne_not_increasing`). An
  order ranking the course of lower total weight above, on positive weights, meets all of it but the given
  comparison, every one-item widening's one verdict being "not ranked above" (`ranksLighter_alike`,
  `ranksLighter_reverses`), as the order relating nothing does too; so, given transitivity and one verdict,
  whether every widening is ranked above what it widens rests on that one comparison. That the verdict is
  one is where it was set aside which item is added and to what, a premise of neutrality across items
  and across what they are added to: an order counting one item and not another has the given comparison
  and not one verdict (`ZeroWeight`, a
  boundary of scope), as does an order ranking only something above nothing (`AboveNothing`, read as
  enough); and an order ranking only widenings by more than one item has a widening ranked and no one-item
  widening (`ranksOnlyMany_alike`, `OnlyMany`), read as what is too small to tell apart.
* **What lies downstream.** Where the class of one's line holds everything downstream of oneself, on a
  listing of what lies downstream of one's acts, an order increasing in its own continuation is
  increasing in admission (`increasing_on_downstream`; the converse holds on every listing,
  `increasingInOwn_of_increasing`). §4.6's P2, that one's class is constant up to the net's end at oneself,
  and P4, that it holds one's effects, give that the class holds it, and so the same law
  (`increasing_on_downstream_of_regularity`). So P2 and P4, which rank nothing, with self-concern, which
  does, give an order increasing in admission on that listing and say nothing beyond it. With the marking
  reading only what the line reaches, a listed item it does not reach parts the two
  (`exists_increasingInOwn_not_increasing_of_outside`). P1 presupposes significance and ranks nothing, so
  self-concern is a further premise and not obtained from it; P3 is not used. Whether P2 and P4 hold is
  the crux.

**Standing.** Every law here is short, and none is new as mathematics. Choosers: Foster's effective
freedom (1993; 2011) with every preference admitted, set inclusion, on a list, with refusal an item in
every menu; `reach` is one state's term in Kreps's (1979) representation of a preference for flexibility,
which aggregates what this intersects; the range's law is Nehring and Puppe's (1999) condition for an
element to add strictly, at every listed item. `AnotherReads` has the shape of Strotz's inconsistency
(1955–56), one person's order differing at two dates, there through a discount that shifts with the date
rather than tastes changing unexpectedly, and of temptation without self-control (Gul and Pesendorfer
2001); the witness has no time and does not say the two orders are one person's. That a chooser can gain
by having fewer options is older than Schelling: Strotz has it against one's later self, by precluding
future options; Schelling (1960) has it toward another, by binding oneself in a threat or a promise. That
removing an option from both can leave each better off is the prisoner's dilemma's, and `Restraint` is
that game read as a menu, the shape also of Braess's paradox (1968). Standpoints: the Pareto relation over
self-concerned orders, which is not the unanimity of positive weightings. One item at a time: an order's
verdict made uniform; that an order need not tell small steps apart is the idea of Luce's semiorders
(1956). `ranksOnlyMany`, read on inclusion, is a semiorder on at most three listed items, `OnlyMany`'s two
among them, and not from four, where {0} below {0,2,3} and {1} below {1,2,3} are two chains with no
comparison between them, which a semiorder forbids: a mixed pair stays unranked however large its
difference (by enumeration, not proved here). Modelling choices: natural-number values; two-valued
admission; one refusal value for all items; a finite listing; a chooser who takes one item; its values,
its refusal and its being there at all fixed across courses; "later" a reading, with no time in `reach`
and no chooser asserted to exist; `ParetoAmong` counting a silent standpoint as no objection; `MutualBest`
as a pure Nash equilibrium, in one play with no binding agreement, not a claim about what actual choosers
do; `listingFrame` reading a course by what it admits, with every claim counted and the process free.

**What this does not show.** It gives no reason for C. That what no chooser does worse from should be
called better, that an order is self-concerned, that standpoints' orders rank no widening below, that an
order gives every one-item widening one verdict: each is a premise reading an order. No route here gives C
on all of a web's level paths. Whether a premise weaker at other data is any easier to warrant is not a Lean
question. Nothing here derives C from the condition. A leaf: it edits no module it imports.
-/

namespace Becoming

open Generative

/-! ## What "weaker" can mean -/

section Strength

variable {S A C D : Type}

/-- **Beside help that reads no order and holds at a datum, a premise that gives C implies C there.**
Let `help` read no order and hold at the datum `d`, at any order. If a premise with `help` entails C,
then the premise alone implies C there. -/
theorem ReadsNoOrder.implies_comparison {help : D → (S → S → Prop) → Prop}
    (reads : ReadsNoOrder help) {frame : Frame S A C} {living : C → Prop}
    {premise : (S → S → Prop) → Prop} {d : D}
    (entails : ∀ better, premise better → help d better → Comparison frame living better)
    {order : S → S → Prop} (holds : help d order) {better : S → S → Prop} (given : premise better) :
    Comparison frame living better :=
  entails better given (reads d order better holds)

/-- **So no order meets such a premise and fails C.** A premise met by some order that fails C at a
datum does not entail C there with help that reads no order and holds there. -/
theorem ReadsNoOrder.not_strictly_weaker {help : D → (S → S → Prop) → Prop}
    (reads : ReadsNoOrder help) {frame : Frame S A C} {living : C → Prop}
    {premise : (S → S → Prop) → Prop} {d : D}
    (entails : ∀ better, premise better → help d better → Comparison frame living better)
    {order : S → S → Prop} (holds : help d order) :
    ¬ ∃ better, premise better ∧ ¬ Comparison frame living better :=
  fun ⟨_, given, fails⟩ => fails (ReadsNoOrder.implies_comparison reads entails holds given)

/-- **Such a premise that C also implies is C at that datum**, with help that reads no order and holds
there. -/
theorem ReadsNoOrder.iff_of_weaker {help : D → (S → S → Prop) → Prop}
    (reads : ReadsNoOrder help) {frame : Frame S A C} {living : C → Prop}
    {premise : (S → S → Prop) → Prop} {d : D}
    (entails : ∀ better, premise better → help d better → Comparison frame living better)
    {order : S → S → Prop} (holds : help d order)
    (weaker : ∀ better, Comparison frame living better → premise better) (better : S → S → Prop) :
    premise better ↔ Comparison frame living better :=
  ⟨ReadsNoOrder.implies_comparison reads entails holds, weaker better⟩

end Strength

namespace Weighting

variable {X : Type}

/-! ## C on a listing -/

/-- A frame reading a course by what it admits on a listing. The process is free: C does not read it. -/
def listingFrame {A : Type} (P : Process (X → Bool) A) (items : List X) : Frame (X → Bool) A X :=
  ⟨P, fun s c => c ∈ items ∧ s c = true⟩

/-- **On that frame, with every claim counted, an extension is a widening on the listing.** -/
theorem extension_listingFrame_iff {A : Type} {P : Process (X → Bool) A} {items : List X}
    {s t : X → Bool} :
    Extension (listingFrame P items) (fun _ => True) s t ↔ WidensOn items t s :=
  ⟨fun ⟨keeps, c, _, atT, notS⟩ =>
    ⟨fun y listed held => (keeps y ⟨listed, held⟩).2,
     c, atT.1, atT.2, match h : s c with
      | false => rfl
      | true => absurd ⟨atT.1, h⟩ notS⟩,
   fun ⟨includes, x, listed, admits, not⟩ =>
    ⟨fun c held => ⟨held.1, includes c held.1 held.2⟩,
     x, trivial, ⟨listed, admits⟩, fun held => Bool.noConfusion (not.symm.trans held.2)⟩⟩

/-- **On that frame, C is being increasing in admission.** -/
theorem comparison_listingFrame_iff {A : Type} {P : Process (X → Bool) A} {items : List X}
    {O : (X → Bool) → (X → Bool) → Prop} :
    Comparison (listingFrame P items) (fun _ => True) O ↔ Increasing items O :=
  ⟨fun meets a b widens => meets b a (extension_listingFrame_iff.mpr widens),
   fun increasing s t extension => increasing t s (extension_listingFrame_iff.mp extension)⟩

/-- **Where every listed item is marked, an order is self-concerned exactly when it meets C on that
frame**: the law above, with help that reads no order, that the marking marks every listed item. One
premise in two forms, and no reason for either. -/
theorem increasingInOwn_iff_comparison {A : Type} (P : Process (X → Bool) A) {items : List X}
    {own : X → Bool} (marks : ∀ x, x ∈ items → own x = true)
    (O : (X → Bool) → (X → Bool) → Prop) :
    IncreasingInOwn items own O ↔ Comparison (listingFrame P items) (fun _ => True) O :=
  ReadsNoOrder.iff_of_weaker
    (help := fun (m : X → Bool) (_ : (X → Bool) → (X → Bool) → Prop) => ∀ x, x ∈ items → m x = true)
    (premise := IncreasingInOwn items own) (d := own) (order := O)
    (fun _ _ _ holds => holds)
    (fun _ given holds => comparison_listingFrame_iff.mpr ((increasingInOwn_iff_increasing holds).mp given))
    marks
    (fun _ meets => increasingInOwn_of_increasing (comparison_listingFrame_iff.mp meets))
    O

/-! ## Choosers -/

/-- The higher of two values. -/
def higher (m n : Nat) : Nat := cond (decide (m < n)) n m

theorem le_higher_left (m n : Nat) : m ≤ higher m n := by
  unfold higher
  cases h : decide (m < n) with
  | true => exact Nat.le_of_lt (of_decide_eq_true h)
  | false => exact Nat.le_refl m

theorem le_higher_right (m n : Nat) : n ≤ higher m n := by
  unfold higher
  cases h : decide (m < n) with
  | true => exact Nat.le_refl n
  | false => exact Nat.le_of_not_lt (of_decide_eq_false h)

theorem higher_cases (m n : Nat) : higher m n = m ∨ higher m n = n := by
  unfold higher
  cases decide (m < n) with
  | true => exact .inr rfl
  | false => exact .inl rfl

/-- What a chooser reaches from a course: the highest of `refusal` and the values `u` gives the listed
items the course admits. `u` is any valuation: an item may stand below refusal, and then the chooser
leaves it, at no cost. A chooser is a pair of values, read as choosing later; nothing here says one
exists, and there is no time in this. -/
def reach : List X → (X → Nat) → Nat → (X → Bool) → Nat
  | [], _, refusal, _ => refusal
  | x :: rest, u, refusal, a =>
    cond (a x) (higher (u x) (reach rest u refusal a)) (reach rest u refusal a)

/-- A chooser can always refuse. -/
theorem refusal_le_reach (items : List X) (u : X → Nat) (refusal : Nat) (a : X → Bool) :
    refusal ≤ reach items u refusal a := by
  induction items with
  | nil => exact Nat.le_refl refusal
  | cons x rest ih =>
    show refusal ≤ cond (a x) (higher (u x) (reach rest u refusal a)) (reach rest u refusal a)
    cases a x with
    | true => exact Nat.le_trans ih (le_higher_right _ _)
    | false => exact ih

/-- A chooser can take whatever the course admits. -/
theorem le_reach {items : List X} {u : X → Nat} {refusal : Nat} {a : X → Bool} {x : X}
    (listed : x ∈ items) (admits : a x = true) : u x ≤ reach items u refusal a := by
  induction items with
  | nil => cases listed
  | cons y rest ih =>
    show u x ≤ cond (a y) (higher (u y) (reach rest u refusal a)) (reach rest u refusal a)
    cases listed with
    | head =>
      rw [admits]
      exact le_higher_left _ _
    | tail _ inRest =>
      cases a y with
      | true => exact Nat.le_trans (ih inRest) (le_higher_right _ _)
      | false => exact ih inRest

/-- What a chooser reaches is refusal, or the value of an item the course admits. -/
theorem reach_attained (items : List X) (u : X → Nat) (refusal : Nat) (a : X → Bool) :
    reach items u refusal a = refusal ∨
      ∃ x, x ∈ items ∧ a x = true ∧ reach items u refusal a = u x := by
  induction items with
  | nil => exact .inl rfl
  | cons y rest ih =>
    show cond (a y) (higher (u y) (reach rest u refusal a)) (reach rest u refusal a) = refusal ∨
      ∃ x, x ∈ y :: rest ∧ a x = true ∧
        cond (a y) (higher (u y) (reach rest u refusal a)) (reach rest u refusal a) = u x
    cases h : a y with
    | false =>
      exact match ih with
        | .inl same => .inl same
        | .inr ⟨x, listed, admits, value⟩ => .inr ⟨x, .tail y listed, admits, value⟩
    | true =>
      exact match higher_cases (u y) (reach rest u refusal a) with
        | .inl atItem => .inr ⟨y, .head rest, h, atItem⟩
        | .inr atRest => match ih with
          | .inl same => .inl (atRest.trans same)
          | .inr ⟨x, listed, admits, value⟩ => .inr ⟨x, .tail y listed, admits, atRest.trans value⟩

theorem reach_le {items : List X} {u : X → Nat} {refusal : Nat} {a : X → Bool} {k : Nat}
    (low : refusal ≤ k) (bound : ∀ x, x ∈ items → a x = true → u x ≤ k) :
    reach items u refusal a ≤ k :=
  match reach_attained items u refusal a with
  | .inl same => Nat.le_trans (Nat.le_of_eq same) low
  | .inr ⟨x, listed, admits, value⟩ => Nat.le_trans (Nat.le_of_eq value) (bound x listed admits)

/-- **A course that includes another is never lower for a chooser, whatever it values.** Near-definitional:
`reach` is a maximum, which builds in that what a chooser leaves costs it nothing. -/
theorem reach_le_of_includes {items : List X} {a b : X → Bool} (includes : IncludesOn items a b)
    (u : X → Nat) (refusal : Nat) : reach items u refusal b ≤ reach items u refusal a :=
  reach_le (refusal_le_reach _ _ _ _) fun _ listed admits => le_reach listed (includes _ listed admits)

/-- **Added items a chooser would each leave change nothing for it.** Where every item `a` admits beyond
`b` stands at most at what the chooser reaches from `b`, it reaches the same from both, however far below
refusal those items stand. -/
theorem reach_eq_of_refused {items : List X} {a b : X → Bool} {u : X → Nat} {refusal : Nat}
    (includes : IncludesOn items a b)
    (refused : ∀ x, x ∈ items → a x = true → b x = false → u x ≤ reach items u refusal b) :
    reach items u refusal a = reach items u refusal b :=
  Nat.le_antisymm
    (reach_le (refusal_le_reach _ _ _ _) fun x listed admits => match h : b x with
      | true => le_reach listed h
      | false => refused x listed admits h)
    (reach_le_of_includes includes u refusal)

/-- The valuation that gives one to what a course does not admit and nothing to what it does. -/
def outside (c : X → Bool) : X → Nat := fun y => cond (c y) 0 1

theorem reach_outside (items : List X) (c : X → Bool) : reach items (outside c) 0 c = 0 :=
  Nat.eq_zero_of_le_zero (reach_le (Nat.le_refl 0) fun x _ admits => by
    show cond (c x) 0 1 ≤ 0
    rw [admits]
    exact Nat.le_refl 0)

theorem outside_of_not {c : X → Bool} {x : X} (not : c x = false) : outside c x = 1 := by
  show cond (c x) 0 1 = 1
  rw [not]
  rfl

/-- Where `a` admits an item `b` does not, some chooser reaches more from `a`. -/
theorem lt_reach_of_exceeds {items : List X} {a b : X → Bool} (exceeds : ExceedsOn items a b) :
    reach items (outside b) 0 b < reach items (outside b) 0 a :=
  match exceeds with
  | ⟨x, listed, admits, not⟩ => by
    rw [reach_outside]
    exact Nat.lt_of_lt_of_le Nat.zero_lt_one
      (Nat.le_trans (Nat.le_of_eq (outside_of_not not).symm) (le_reach listed admits))

/-- No chooser does worse by its own valuation from `a` than from `b`, and some does better by its own. -/
def NoneWorseSomeBetter (items : List X) (a b : X → Bool) : Prop :=
  (∀ u refusal, reach items u refusal b ≤ reach items u refusal a) ∧
    ∃ u refusal, reach items u refusal b < reach items u refusal a

/-- **Widening is exactly what no chooser does worse from and some does better from, over every
valuation.** No chooser is assumed to value any item; the range over every valuation gives some chooser
doing better, and through `outside` the converse. -/
theorem widens_iff_noneWorseSomeBetter {items : List X} {a b : X → Bool} :
    WidensOn items a b ↔ NoneWorseSomeBetter items a b :=
  ⟨fun ⟨includes, exceeds⟩ => ⟨reach_le_of_includes includes, outside b, 0, lt_reach_of_exceeds exceeds⟩,
   fun ⟨never, u, refusal, lt⟩ =>
    ⟨fun y listed admits => match h : a y with
      | true => rfl
      | false => absurd
          (Nat.le_trans
            (Nat.le_trans (Nat.le_of_eq (outside_of_not h).symm) (le_reach listed admits))
            (Nat.le_trans (never (outside a) 0) (Nat.le_of_eq (reach_outside items a))))
          (Nat.not_succ_le_zero 0),
     match reach_attained items u refusal a with
      | .inl same => absurd
          (Nat.lt_of_le_of_lt (refusal_le_reach items u refusal b)
            (Nat.lt_of_lt_of_le lt (Nat.le_of_eq same)))
          (Nat.lt_irrefl refusal)
      | .inr ⟨x, listed, admits, value⟩ => ⟨x, listed, admits, match h : b x with
          | false => rfl
          | true => absurd
              (Nat.lt_of_le_of_lt (le_reach listed h) (Nat.lt_of_lt_of_le lt (Nat.le_of_eq value)))
              (Nat.lt_irrefl (u x))⟩⟩⟩

/-- **An order is increasing in admission exactly when it ranks above whatever no chooser does worse from
and some does better from.** It may rank more. -/
theorem increasing_iff_ranks_noneWorseSomeBetter {items : List X}
    {O : (X → Bool) → (X → Bool) → Prop} :
    Increasing items O ↔ ∀ a b, NoneWorseSomeBetter items a b → O b a :=
  ⟨fun increasing a b holds => increasing a b (widens_iff_noneWorseSomeBetter.mpr holds),
   fun ranks a b widens => ranks a b (widens_iff_noneWorseSomeBetter.mp widens)⟩

/-- **What a range of choosers has to hold.** For every widening some chooser in a range does better,
exactly when, for each listed item, some chooser in it puts that item above every other listed item and
above refusal. With equality of items decided, a modelling assumption. -/
theorem gains_every_widening_iff [DecidableEq X] {items : List X} (range : (X → Nat) → Nat → Prop) :
    (∀ a b, WidensOn items a b →
        ∃ u refusal, range u refusal ∧ reach items u refusal b < reach items u refusal a) ↔
      ∀ x, x ∈ items → ∃ u refusal, range u refusal ∧ refusal < u x ∧
        ∀ y, y ∈ items → y ≠ x → u y < u x :=
  ⟨fun gains x listed =>
    have widens : WidensOn items (fun _ => true) (fun y => decide (y ≠ x)) :=
      ⟨fun _ _ _ => rfl, x, listed, rfl, decide_eq_false fun ne => ne rfl⟩
    match gains _ _ widens with
    | ⟨u, refusal, inRange, lt⟩ =>
      match reach_attained items u refusal (fun _ => true) with
      | .inl same => absurd
          (Nat.lt_of_le_of_lt (refusal_le_reach items u refusal _)
            (Nat.lt_of_lt_of_le lt (Nat.le_of_eq same)))
          (Nat.lt_irrefl refusal)
      | .inr ⟨z, zListed, _, value⟩ =>
        have atTop : z = x := match decEq z x with
          | isTrue same => same
          | isFalse ne => absurd
              (Nat.lt_of_le_of_lt (le_reach zListed (decide_eq_true ne))
                (Nat.lt_of_lt_of_le lt (Nat.le_of_eq value)))
              (Nat.lt_irrefl (u z))
        have below : reach items u refusal (fun y => decide (y ≠ x)) < u x :=
          Nat.lt_of_lt_of_le lt (Nat.le_of_eq (value.trans (congrArg u atTop)))
        ⟨u, refusal, inRange, Nat.lt_of_le_of_lt (refusal_le_reach items u refusal _) below,
         fun _ yListed ne => Nat.lt_of_le_of_lt (le_reach yListed (decide_eq_true ne)) below⟩,
   fun tops _ b widens => match widens with
    | ⟨_, x, listed, admits, not⟩ => match tops x listed with
      | ⟨u, refusal, inRange, above, top⟩ => ⟨u, refusal, inRange,
          Nat.lt_of_lt_of_le
            (match reach_attained items u refusal b with
             | .inl same => Nat.lt_of_le_of_lt (Nat.le_of_eq same) above
             | .inr ⟨z, zListed, zAdmits, value⟩ =>
               Nat.lt_of_le_of_lt (Nat.le_of_eq value)
                 (top z zListed fun same =>
                   Bool.noConfusion (not.symm.trans ((congrArg b same).symm.trans zAdmits))))
            (le_reach listed admits)⟩⟩

/-- **On a mixed pair each course is better for some chooser.** -/
theorem choosers_mixed {items : List X} {a b : X → Bool} (mixed : MixedOn items a b) :
    (∃ u refusal, reach items u refusal b < reach items u refusal a) ∧
      ∃ u refusal, reach items u refusal a < reach items u refusal b :=
  ⟨⟨outside b, 0, lt_reach_of_exceeds mixed.1⟩, ⟨outside a, 0, lt_reach_of_exceeds mixed.2⟩⟩

/-! **Imposed: a witness.** One item, weighing below zero. Imposed, as a net weighting counts what is
admitted, it puts the course admitting it below the course admitting nothing; a chooser who values it
below refusal reaches the same from both. -/
namespace Refusing

def items : List Unit := [()]
def admitted : Unit → Bool := fun _ => true
def nothing : Unit → Bool := fun _ => false

theorem widens : WidensOn items admitted nothing :=
  ⟨fun _ _ held => Bool.noConfusion held, (), .head [], rfl, rfl⟩

theorem imposed_below : ranksNet items (fun _ => 0) (fun _ => 1) admitted nothing :=
  (by decide : 0 < 1)

theorem refused_unchanged :
    reach items (fun _ => 0) 1 admitted = reach items (fun _ => 0) 1 nothing := rfl

/-- **Read on the frame of what a course admits, every order meeting C ranks the course admitting the item
above the course admitting nothing**, the other way from `imposed_below`. Nothing in a course's admitting a
formation makes the formation chosen, so whether what a course adds is left or imposed is not shown here. -/
theorem comparison_ranks_wide {A : Type} (P : Process (Unit → Bool) A)
    {O : (Unit → Bool) → (Unit → Bool) → Prop}
    (meets : Comparison (listingFrame P items) (fun _ => True) O) : O nothing admitted :=
  comparison_listingFrame_iff.mp meets admitted nothing widens

end Refusing

/-! **Another's order: a witness.** A chooser takes from a course what its own order puts highest. Here
it prefers `true`, and the order reading the result prefers `false`: the wider course lets the chooser
do better by its order, and what it takes stands lower in the other. -/
namespace AnotherReads

def items : List Bool := [false, true]
def narrow : Bool → Bool := fun x => !x
def wide : Bool → Bool := fun _ => true
def later : Bool → Nat := fun x => cond x 1 0
def present : Bool → Nat := fun x => cond x 0 1

/-- What a chooser with order `v` takes from a course. -/
def Takes (v : Bool → Nat) (c : Bool → Bool) (x : Bool) : Prop :=
  c x = true ∧ ∀ y, c y = true → v y ≤ v x

theorem widens : WidensOn items wide narrow :=
  ⟨fun _ _ _ => rfl, true, .tail _ (.head _), rfl, rfl⟩

theorem takes_narrow : Takes later narrow false :=
  ⟨rfl, fun y admits => match y, admits with
    | false, _ => Nat.le_refl _
    | true, held => Bool.noConfusion held⟩

theorem takes_wide : Takes later wide true :=
  ⟨rfl, fun y _ => match y with
    | false => Nat.zero_le _
    | true => Nat.le_refl _⟩

theorem chooser_gains : later false < later true := by decide

theorem reading_falls : present true < present false := by decide

/-- **Read on the frame of what a course admits, every order meeting C ranks the wider course above the
narrower**, while what the chooser takes from it stands lower in the order reading the result. -/
theorem comparison_ranks_wide {A : Type} (P : Process (Bool → Bool) A)
    {O : (Bool → Bool) → (Bool → Bool) → Prop}
    (meets : Comparison (listingFrame P items) (fun _ => True) O) : O narrow wide :=
  comparison_listingFrame_iff.mp meets wide narrow widens

end AnotherReads

/-! ## Several choosers -/

section Several

variable {Act : Type}

/-- A mutual best response from one menu both choose from: a pure Nash equilibrium, in one play with no
binding agreement, labelled as that field's, and no claim about what actual choosers do. `pays x y` is
what one gets by `x` where the other chooses `y`, reading both acts. -/
def MutualBest (pays : Act → Act → Nat) (menu : Act → Bool) (x y : Act) : Prop :=
  menu x = true ∧ menu y = true ∧ (∀ x', menu x' = true → pays x' y ≤ pays x y) ∧
    ∀ y', menu y' = true → pays y' x ≤ pays y x

/-- **Where no choice bears on what the other gets, a wider menu lowers nothing.** At mutual best
responses of a menu and of one that includes it, the first chooser gets at least as much from the
wider. -/
theorem not_lowered_of_no_bearing {pays : Act → Act → Nat}
    (noBearing : ∀ x y y', pays x y = pays x y') {narrow wide : Act → Bool}
    (includes : ∀ x, narrow x = true → wide x = true) {x y x' y' : Act}
    (atNarrow : MutualBest pays narrow x y) (atWide : MutualBest pays wide x' y') :
    pays x y ≤ pays x' y' :=
  Nat.le_trans (Nat.le_of_eq (noBearing x y y')) (atWide.2.2.1 x (includes x atNarrow.1))

end Several

/-! **Several choosers: a witness.** Each can restrain (`false`) or take (`true`). Where both can only
restrain, each gets 2. Where the menu is widened by taking, the only mutual best response is that both
take, and each gets 1. The menu both choose from widens, by the `WidensOn` that `Increasing` reads, and at
the pure Nash equilibrium of one play what each gets falls. This is the prisoner's dilemma read as a menu. -/
namespace Restraint

def pays : Bool → Bool → Nat
  | false, false => 2
  | true, false => 3
  | false, true => 0
  | true, true => 1

def items : List Bool := [false, true]
def narrow : Bool → Bool := fun x => !x
def wide : Bool → Bool := fun _ => true

theorem widens : WidensOn items wide narrow :=
  ⟨fun _ _ _ => rfl, true, .tail _ (.head _), rfl, rfl⟩

theorem narrow_best : MutualBest pays narrow false false :=
  ⟨rfl, rfl,
   fun x' admits => match x', admits with
    | false, _ => Nat.le_refl _
    | true, held => Bool.noConfusion held,
   fun y' admits => match y', admits with
    | false, _ => Nat.le_refl _
    | true, held => Bool.noConfusion held⟩

theorem wide_best_iff (x y : Bool) : MutualBest pays wide x y ↔ x = true ∧ y = true :=
  ⟨fun ⟨_, _, first, other⟩ => match x, y, first, other with
    | true, true, _, _ => ⟨rfl, rfl⟩
    | false, false, first, _ => absurd (first true rfl) (by decide)
    | false, true, first, _ => absurd (first true rfl) (by decide)
    | true, false, _, other => absurd (other true rfl) (by decide),
   fun ⟨hx, hy⟩ => by
    subst hx
    subst hy
    exact ⟨rfl, rfl,
      fun x' _ => match x' with
        | false => by decide
        | true => by decide,
      fun y' _ => match y' with
        | false => by decide
        | true => by decide⟩⟩

theorem each_falls : pays true true < pays false false := by decide

/-- **Read on the frame of what a course admits, every order meeting C ranks the wider menu above the
narrower.** With `each_falls`, that is the witness as it stands. `listingFrame` reads anything listed as a
course by construction; whether a menu of acts is a course of what can form is not shown here. -/
theorem comparison_ranks_wide {A : Type} (P : Process (Bool → Bool) A)
    {O : (Bool → Bool) → (Bool → Bool) → Prop}
    (meets : Comparison (listingFrame P items) (fun _ => True) O) : O narrow wide :=
  comparison_listingFrame_iff.mp meets wide narrow widens

end Restraint

/-! ## Standpoints -/

section Standpoints

variable {P : Type}

/-- The Pareto relation among standpoints' orders: some ranks `a` above `b`, and none ranks `b` above `a`.
A standpoint ranking neither counts as no objection, so this is not unanimity. `R p b a` reads "`a` is
ranked above `b`". -/
def ParetoAmong (R : P → (X → Bool) → (X → Bool) → Prop) : (X → Bool) → (X → Bool) → Prop :=
  fun b a => (∃ p, R p b a) ∧ ∀ q, ¬ R q a b

/-- An order ranks no widening below what it widens. It need not rank it above. -/
def NotBelow (items : List X) (O : (X → Bool) → (X → Bool) → Prop) : Prop :=
  ∀ a b, WidensOn items a b → ¬ O a b

/-- **What every profile of self-concerned orders ranks.** One course is ranked above another by the Pareto
relation of every profile in which each standpoint's order is increasing in its own continuation and ranks
no widening below what it widens, exactly when it widens the other and adds to some standpoint's own. -/
theorem every_pareto_iff {items : List X} {own : P → X → Bool} {a b : X → Bool} :
    (∀ R : P → (X → Bool) → (X → Bool) → Prop, (∀ p, IncreasingInOwn items (own p) (R p)) →
        (∀ p, NotBelow items (R p)) → ParetoAmong R b a) ↔
      WidensOn items a b ∧ ∃ p, AddsOwn items (own p) a b :=
  ⟨fun every => match (every (fun p b a => WidensOn items a b ∧ AddsOwn items (own p) a b)
      (fun _ _ _ widens adds => ⟨widens, adds⟩)
      (fun _ _ _ widens above => widens.not_reverse above.1)).1 with
    | ⟨p, widens, adds⟩ => ⟨widens, p, adds⟩,
   fun ⟨widens, p, adds⟩ _ selfConcerned notBelow =>
    ⟨⟨p, selfConcerned p a b widens adds⟩, fun q => notBelow q a b widens⟩⟩

/-- **That relation is increasing in admission exactly where every listed item is someone's own.** For
every such profile, the Pareto relation ranks every widening exactly when each listed item is marked by
some standpoint. With equality of items decided, a modelling assumption, as in
`Weighting.widensOn_iff_reach`. -/
theorem pareto_increasing_iff_covers [DecidableEq X] {items : List X} {own : P → X → Bool} :
    (∀ R : P → (X → Bool) → (X → Bool) → Prop, (∀ p, IncreasingInOwn items (own p) (R p)) →
        (∀ p, NotBelow items (R p)) → Increasing items (ParetoAmong R)) ↔
      ∀ x, x ∈ items → ∃ p, own p x = true :=
  ⟨fun all x listed =>
    have widens : WidensOn items (fun y => decide (y = x)) (fun _ => false) :=
      ⟨fun _ _ held => Bool.noConfusion held, x, listed, decide_eq_true rfl, rfl⟩
    match (every_pareto_iff.mp fun R selfConcerned notBelow =>
        all R selfConcerned notBelow _ _ widens).2 with
    | ⟨p, y, _, marked, admits, _⟩ => by
      have same : y = x := of_decide_eq_true admits
      subst same
      exact ⟨p, marked⟩,
   fun covers R selfConcerned notBelow a b widens => match widens.2 with
    | ⟨x, listed, admits, not⟩ => match covers x listed with
      | ⟨p, marked⟩ => every_pareto_iff.mpr ⟨widens, p, x, listed, marked, admits, not⟩
          R selfConcerned notBelow⟩

/-- The course admitting exactly what a marking leaves widens the course admitting nothing, at an unmarked
listed item. -/
theorem widens_unmarked {items : List X} {own : X → Bool} {x : X} (listed : x ∈ items)
    (unmarked : own x = false) : WidensOn items (fun y => !own y) (fun _ => false) :=
  ⟨fun _ _ held => Bool.noConfusion held, x, listed, congrArg (fun v => !v) unmarked, rfl⟩

/-- That widening adds nothing to what the marking marks. -/
theorem not_adds_unmarked {items : List X} {own : X → Bool} :
    ¬ AddsOwn items own (fun y => !own y) (fun _ => false) :=
  fun ⟨_, _, marked, admits, _⟩ =>
    Bool.noConfusion ((congrArg (fun v => !v) marked).symm.trans admits)

/-- **A standpoint whose marking leaves a listed item need not have an order increasing in admission.** At a
listed item the marking leaves, some order is increasing in its own continuation, ranks no widening below what it widens, and is not increasing
in admission. -/
theorem exists_selfConcerned_notBelow_not_increasing {items : List X} {own : X → Bool} {x : X}
    (listed : x ∈ items) (unmarked : own x = false) :
    ∃ O, IncreasingInOwn items own O ∧ NotBelow items O ∧ ¬ Increasing items O :=
  ⟨fun b a => WidensOn items a b ∧ AddsOwn items own a b,
   fun _ _ widens adds => ⟨widens, adds⟩,
   fun _ _ widens above => widens.not_reverse above.1,
   fun increasing => not_adds_unmarked (increasing _ _ (widens_unmarked listed unmarked)).2⟩

/-- An order that ranks below every widening adding nothing to its own: it ranks a widening that adds to
its own above what it widens, and what it widens above a widening that adds nothing to its own. Read as
positional concern, the added item may be another's or no one's. -/
def RanksNotOwnBelow (items : List X) (own : X → Bool) : (X → Bool) → (X → Bool) → Prop :=
  fun b a => (WidensOn items a b ∧ AddsOwn items own a b) ∨ (WidensOn items b a ∧ ¬ AddsOwn items own b a)

theorem ranksNotOwnBelow_selfConcerned {items : List X} {own : X → Bool} :
    IncreasingInOwn items own (RanksNotOwnBelow items own) :=
  fun _ _ widens adds => .inl ⟨widens, adds⟩

/-- **Such an order stops the Pareto relation.** Let `x` be listed and not in `q`'s own. Some widening at
`x` adds nothing to `q`'s own; where `q`'s order ranks such widenings below, the Pareto relation does not
rank that widening, whatever the others' orders. -/
theorem notOwnBelow_stops {items : List X} {own : P → X → Bool} {q : P} {x : X} (listed : x ∈ items)
    (unmarked : own q x = false) :
    ∃ a b, WidensOn items a b ∧ ¬ AddsOwn items (own q) a b ∧
      ∀ R : P → (X → Bool) → (X → Bool) → Prop, R q = RanksNotOwnBelow items (own q) →
        ¬ ParetoAmong R b a :=
  have widens := widens_unmarked listed unmarked
  have adds : ¬ AddsOwn items (own q) (fun y => !own q y) (fun _ => false) := not_adds_unmarked
  ⟨_, _, widens, adds, fun R atQ shared => shared.2 q (by rw [atQ]; exact .inr ⟨widens, adds⟩)⟩

end Standpoints

/-! **Less than the condition held de se: a witness.** Two standpoints, each with one item its own: every
listed item is someone's own, though neither's own marks both, so the condition held de se fails, and a
standpoint's self-concerned order ranking no widening below need not be increasing in admission. -/
namespace EachItsOwn

def own : Bool → Bool → Bool := fun p x => p == x

theorem covers : ∀ x, x ∈ [false, true] → ∃ p, own p x = true :=
  fun x _ => ⟨x, by cases x <;> rfl⟩

theorem not_total : ¬ ∀ p x, own p x = true :=
  fun all => Bool.noConfusion (all false true)

theorem not_increasing (p : Bool) :
    ∃ O, IncreasingInOwn [false, true] (own p) O ∧ NotBelow [false, true] O ∧
      ¬ Increasing [false, true] O :=
  match p with
  | false => exists_selfConcerned_notBelow_not_increasing (x := true) (.tail _ (.head _)) rfl
  | true => exists_selfConcerned_notBelow_not_increasing (x := false) (.head _) rfl

end EachItsOwn

/-- **On three listed items no positive weighting's order is exactly widening.** Widening leaves each of
`{0}` and `{1, 2}`, and `{1}` and `{0, 2}`, unranked; a total leaves a pair unranked only by tying it, so a
weighting would tie each, and then the third item would weigh nothing. -/
theorem widening_is_no_weighting (w : Nat → Nat) (positive : Positive [0, 1, 2] w) :
    ¬ ∀ a b, ranks [0, 1, 2] w b a ↔ WidensOn [0, 1, 2] a b := fun same =>
  have tie : ∀ a b : Nat → Bool, ¬ IncludesOn [0, 1, 2] a b → ¬ IncludesOn [0, 1, 2] b a →
      weighed [0, 1, 2] w a = weighed [0, 1, 2] w b := fun a b ab ba =>
    Nat.le_antisymm
      (Nat.le_of_not_lt fun lt => ab ((same a b).mp lt).1)
      (Nat.le_of_not_lt fun lt => ba ((same b a).mp lt).1)
  have zero_tie : w 0 + (0 + (0 + 0)) = 0 + (w 1 + (w 2 + 0)) :=
    tie (fun n => n == 0) (fun n => n == 1 || n == 2)
      (fun includes => absurd (includes 1 (.tail _ (.head _)) rfl) (by decide))
      (fun includes => absurd (includes 0 (.head _) rfl) (by decide))
  have one_tie : 0 + (w 1 + (0 + 0)) = w 0 + (0 + (w 2 + 0)) :=
    tie (fun n => n == 1) (fun n => n == 0 || n == 2)
      (fun includes => absurd (includes 0 (.head _) rfl) (by decide))
      (fun includes => absurd (includes 1 (.tail _ (.head _)) rfl) (by decide))
  have zero_is : w 0 = w 1 + w 2 := zero_tie.trans (Nat.zero_add _)
  have one_is : w 1 = w 0 + w 2 :=
    (Nat.zero_add _).symm.trans (one_tie.trans (congrArg (w 0 + ·) (Nat.zero_add _)))
  have grows : w 0 < w 0 + w 2 + w 2 :=
    Nat.lt_of_lt_of_le (Nat.lt_add_of_pos_right (positive 2 (.tail _ (.tail _ (.head _)))))
      (Nat.le_add_right _ _)
  Nat.ne_of_lt grows (zero_is.trans (congrArg (· + w 2) one_is))

/-! ## One item at a time -/

/-- Every widening by one item gets one verdict from an order: which item, and what it is added to, make
no difference. It reads only whether the widening is ranked above, so an order ranking none meets it. -/
def StepAlike (items : List X) (O : (X → Bool) → (X → Bool) → Prop) : Prop :=
  ∀ x a b y c d, WidensBy items x a b → WidensBy items y c d → (O b a ↔ O d c)

/-- **Being increasing in admission gives every one-item widening one verdict**: ranked above. -/
theorem Increasing.stepAlike {items : List X} {O : (X → Bool) → (X → Bool) → Prop}
    (increasing : Increasing items O) : StepAlike items O :=
  fun _ _ _ _ _ _ first second =>
    ⟨fun _ => increasing _ _ (widensOn_of_widensBy second),
     fun _ => increasing _ _ (widensOn_of_widensBy first)⟩

/-- **Given a widening by one item, a transitive order is increasing in admission exactly when every such
widening gets one verdict and the given one is ranked.** -/
theorem increasing_iff_one_step [DecidableEq X] {items : List X}
    {O : (X → Bool) → (X → Bool) → Prop} (transitive : ∀ {a b c}, O a b → O b c → O a c)
    {x : X} {a b : X → Bool} (by_ : WidensBy items x a b) :
    Increasing items O ↔ StepAlike items O ∧ O b a :=
  ⟨fun increasing => ⟨increasing.stepAlike, increasing _ _ (widensOn_of_widensBy by_)⟩,
   fun ⟨alike, ranked⟩ =>
    (increasing_iff_by_one (items := items) (O := O) transitive).mpr
      fun y c d by' => (alike x a b y c d by_ by').mp ranked⟩

/-- The order that ranks a course above another where its total weight is lower. -/
def ranksLighter (items : List X) (w : X → Nat) : (X → Bool) → (X → Bool) → Prop :=
  fun b a => weighed items w a < weighed items w b

theorem ranksLighter_transitive {items : List X} {w : X → Nat} {a b c : X → Bool}
    (first : ranksLighter items w a b) (second : ranksLighter items w b c) : ranksLighter items w a c :=
  Nat.lt_trans second first

/-- **That order gives every one-item widening one verdict**: not ranked above. -/
theorem ranksLighter_alike {items : List X} {w : X → Nat} (positive : Positive items w) :
    StepAlike items (ranksLighter items w) :=
  fun _ _ _ _ _ _ by_ by' =>
    ⟨fun ranked => absurd ranked (Nat.lt_asymm (weighed_lt_of_widens positive (widensOn_of_widensBy by_))),
     fun ranked => absurd ranked (Nat.lt_asymm (weighed_lt_of_widens positive (widensOn_of_widensBy by')))⟩

/-- **That order reverses every widening**: whether a widening is ranked above what it widens rests on the
given comparison. -/
theorem ranksLighter_reverses {items : List X} {w : X → Nat} (positive : Positive items w) {a b : X → Bool}
    (widens : WidensOn items a b) : ranksLighter items w a b ∧ ¬ ranksLighter items w b a :=
  ⟨weighed_lt_of_widens positive widens, Nat.lt_asymm (weighed_lt_of_widens positive widens)⟩

/-- A widening by more than one item, ranked; no one-item widening is. -/
def ranksOnlyMany (items : List X) : (X → Bool) → (X → Bool) → Prop :=
  fun b a => WidensOn items a b ∧ ¬ ∃ x, WidensBy items x a b

theorem ranksOnlyMany_alike {items : List X} : StepAlike items (ranksOnlyMany items) :=
  fun x _ _ y _ _ by_ by' =>
    ⟨fun ranked => absurd ⟨x, by_⟩ ranked.2, fun ranked => absurd ⟨y, by'⟩ ranked.2⟩

theorem ranksOnlyMany_transitive {items : List X} {a b c : X → Bool}
    (first : ranksOnlyMany items a b) (second : ranksOnlyMany items b c) : ranksOnlyMany items a c :=
  ⟨⟨fun z listed admits => second.1.1 z listed (first.1.1 z listed admits),
    match second.1.2 with
    | ⟨z, listed, admits, not⟩ => ⟨z, listed, admits, match h : a z with
        | false => rfl
        | true => Bool.noConfusion (not.symm.trans (first.1.1 z listed h))⟩⟩,
   fun ⟨x, by_⟩ => match first.1.2, second.1.2 with
    | ⟨y, listedY, admitsY, notY⟩, ⟨z, listedZ, admitsZ, notZ⟩ =>
      have atY : y = x := by_.2.2.2.2 y listedY (second.1.1 y listedY admitsY) notY
      have notZA : a z = false := match h : a z with
        | false => rfl
        | true => Bool.noConfusion (notZ.symm.trans (first.1.1 z listedZ h))
      have atZ : z = x := by_.2.2.2.2 z listedZ admitsZ notZA
      Bool.noConfusion (notZ.symm.trans ((congrArg b (atZ.trans atY.symm)).trans admitsY))⟩

namespace OnlyMany

def items : List Bool := [false, true]
def nothing : Bool → Bool := fun _ => false
def wide : Bool → Bool := fun _ => true

/-- **A widening ranked does not give a one-item widening ranked.** -/
theorem ranked : ranksOnlyMany items nothing wide :=
  ⟨⟨fun _ _ _ => rfl, true, .tail _ (.head _), rfl, rfl⟩,
   fun ⟨_, by_⟩ =>
    have atFalse := by_.2.2.2.2 false (.head _) rfl rfl
    have atTrue := by_.2.2.2.2 true (.tail _ (.head _)) rfl rfl
    Bool.noConfusion (atFalse.trans atTrue.symm)⟩

/-- Nor does it rank every widening. -/
theorem not_increasing : ¬ Increasing items (ranksOnlyMany items) :=
  fun increasing => (increasing (fun x => x) nothing
    ⟨fun _ _ held => Bool.noConfusion held, true, .tail _ (.head _), rfl, rfl⟩).2
    ⟨true, fun _ _ held => Bool.noConfusion held, .tail _ (.head _), rfl, rfl, fun _ _ admits _ => admits⟩

end OnlyMany

/-! **A zero weight: one item counted and one not.** The order has a one-item widening ranked, is transitive, and
gives one-item widenings two verdicts, so it is not increasing: a boundary of scope
(`weighed_eq_of_unweighted`). -/
namespace ZeroWeight

def items : List Bool := [false, true]
def w : Bool → Nat := fun x => cond x 1 0
def nothing : Bool → Bool := fun _ => false

theorem counted_step : WidensBy items true (fun x => x) nothing :=
  ⟨fun _ _ held => Bool.noConfusion held, .tail _ (.head _), rfl, rfl, fun _ _ admits _ => admits⟩

theorem uncounted_step : WidensBy items false (fun x => !x) nothing :=
  ⟨fun _ _ held => Bool.noConfusion held, .head _, rfl, rfl,
   fun y _ admits _ => match y, admits with
    | false, _ => rfl
    | true, held => Bool.noConfusion held⟩

theorem ranks_counted : ranks items w nothing (fun x => x) := (by decide : 0 < 1)

theorem not_ranks_uncounted : ¬ ranks items w nothing (fun x => !x) := Nat.lt_irrefl 0

theorem not_alike : ¬ StepAlike items (ranks items w) :=
  fun alike => not_ranks_uncounted
    ((alike _ _ _ _ _ _ counted_step uncounted_step).mp ranks_counted)

theorem not_increasing : ¬ Increasing items (ranks items w) :=
  fun increasing => not_ranks_uncounted (increasing _ _ (widensOn_of_widensBy uncounted_step))

end ZeroWeight

/-! **Above nothing: read as enough.** An order ranking any course that admits something above the
course admitting nothing, and nothing else, is transitive, has a one-item widening ranked, is blind to the item, and
gives a further one another verdict, so it is not increasing. -/
namespace AboveNothing

def items : List Bool := [false, true]
def one : Bool → Nat := fun _ => 1

def order : (Bool → Bool) → (Bool → Bool) → Prop :=
  fun b a => weighed items one b = 0 ∧ 0 < weighed items one a

theorem transitive {a b c : Bool → Bool} (first : order a b) (second : order b c) : order a c :=
  absurd (Nat.lt_of_lt_of_le first.2 (Nat.le_of_eq second.1)) (Nat.lt_irrefl 0)

def nothing : Bool → Bool := fun _ => false
def wide : Bool → Bool := fun _ => true

theorem first_step : WidensBy items true (fun x => x) nothing :=
  ⟨fun _ _ held => Bool.noConfusion held, .tail _ (.head _), rfl, rfl, fun _ _ admits _ => admits⟩

theorem further_step : WidensBy items false wide (fun x => x) :=
  ⟨fun _ _ _ => rfl, .head _, rfl, rfl, fun _ _ _ not => not⟩

theorem ranks_first : order nothing (fun x => x) := ⟨by decide, by decide⟩

theorem not_ranks_further : ¬ order (fun x => x) wide := fun above =>
  absurd above.1 (by decide)

theorem not_alike : ¬ StepAlike items order :=
  fun alike => not_ranks_further ((alike _ _ _ _ _ _ first_step further_step).mp ranks_first)

theorem not_increasing : ¬ Increasing items order :=
  fun increasing => not_ranks_further (increasing _ _ (widensOn_of_widensBy further_step))

end AboveNothing

/-! ## An order ranking every one-item widening, not transitive -/

/-- **Ranking every one-item widening does not give every widening without transitivity**: the order that ranks
exactly the widenings by one item is not increasing on two listed items. -/
theorem byOne_not_increasing :
    ¬ Increasing [false, true] (fun b a => WidensByOne [false, true] a b) :=
  fun increasing => match increasing (fun _ => true) (fun _ => false)
      ⟨fun _ _ _ => rfl, true, .tail _ (.head _), rfl, rfl⟩ with
    | ⟨_, by_⟩ =>
      have atFalse := by_.2.2.2.2 false (.head _) rfl rfl
      have atTrue := by_.2.2.2.2 true (.tail _ (.head _)) rfl rfl
      Bool.noConfusion (atFalse.trans atTrue.symm)

/-! ## What lies downstream -/

section Downstream

variable {α : Type} {R E : «际» α}

/-- **On what lies downstream, where the class holds it, self-concern gives increasing in admission.**
Let everything downstream of `m` be alike to it under a class, and let `own` mark what the line under the
class from `m` reaches. On a listing of what lies downstream of `m`, an order increasing in its own
continuation is increasing in admission. -/
theorem increasing_on_downstream (hE : «类» E) {m : α} (alike : ∀ t, «及» R m t → E m t)
    {own : α → Bool} (reads : ∀ t, «所及» R E m t → own t = true) {items : List α}
    (down : ∀ t, t ∈ items → «及» R m t) {O : (α → Bool) → (α → Bool) → Prop}
    (selfConcerned : IncreasingInOwn items own O) : Increasing items O :=
  (increasingInOwn_iff_increasing fun t listed =>
    reads t ((«后皆续当且仅当后皆同类» hE).mpr alike t (down t listed))).mp selfConcerned

/-- **§4.6's P2 and P4 give that the class holds it.** Under a class constant up to the net's end at `m`'s
class (P2), where the class holds `m`'s effects (P4), on a listing of what lies downstream of `m`, an order
increasing in its own continuation is increasing in admission. -/
theorem increasing_on_downstream_of_regularity (hE : «类» E) {m : α} (atClass : «本类至终有常» R E m)
    (held : «所缘同于» R E m) {own : α → Bool}
    (reads : ∀ t, «所及» R E m t → own t = true) {items : List α}
    (down : ∀ t, t ∈ items → «及» R m t) {O : (α → Bool) → (α → Bool) → Prop}
    (selfConcerned : IncreasingInOwn items own O) : Increasing items O :=
  increasing_on_downstream hE
    (fun _ d => hE.symm («本类常闭则后皆续» hE atClass
      (match d with
       | .one s => ⟨_, s⟩
       | .more s _ => ⟨_, s⟩) held (hE.refl m) d).1) reads down selfConcerned

end Downstream

end Weighting

end Becoming
