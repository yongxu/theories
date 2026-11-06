import Becoming.EventualWideningInstances

/-!
# Comparing two courses: what a comparison can be on what they admit

07's open item asks for a comparison of a range whose widening keeps widening with one merely
wider now, never reversing widening and counting neither novelty nor scale. UE4's lag
(`LagWitness.lag`) is the case such a comparison should decide and eventual widening cannot.
Read on what courses admit, three laws, and a condition with its checks, locate what it can be
there.

* **On a web of formations on two sides, keeping widening by name over admitting alike closes a
  cycle.** Two rankings crossed by widening close one: a transitive relation containing widening
  that ranks `l` above `l'` and `k` above `k'`, where `l'` widens `k` and `k'` widens `l`, ranks `l`
  above itself (`Web.ranks_self_of_crossed`). On a web of formations on two sides, each requiring
  its own condition at need one (`Sides.web`), take the course admitting at step `t` the
  formations of one side up to `t`, and the course admitting the first of them and every formation
  of the other side. With their mirrors under exchanging the sides they are so crossed: the static
  course of each pair widens the keeping course of the other
  (`Sides.firstAndOther_widens_swapped`, `Sides.swapped_widens_growing`), while neither keeping
  course widens the static course of the other (`Sides.not_growing_widens_swapped`,
  `Sides.not_swapped_growing_widens`).
  - On the two-sided web, no strict partial order containing widening ranks every course keeping
    widening by name from the first step above every course that admits alike from the first
    step, is wider up to the first step and is mixed with it
    (`Sides.no_order_ranks_keeping_over_alike`): the mirrored pair is in that class too, so no
    invariance is needed.
  - For the one pair, a transitive relation containing widening and unchanged by the exchange that
    ranks the growing course above the other ranks it above itself
    (`Sides.keeping_over_alike_cycles`); without the exchange, a strict partial order containing
    widening can rank it so (`Sides.exchange_needed`). The reverse ranking is consistent with every
    premise (`Sides.reverse_consistent`), by scale alone among others (`Sides.scale_counts`).
  - The static course admits infinitely many formations, and the cycle needs that: where a static
    course's admissions are held by a list, ranking keeping widening by name over admitting alike
    is a strict partial order containing widening on every web (`Web.ListedOrder.irrefl`,
    `Web.ListedOrder.trans`, `Web.ListedOrder.ranks`); on the two-sided web it ranks the growing
    course above the first formations of both sides, where widening or eventual widening is silent
    (`Sides.listed_consistent`).
  - Infinite width does not suffice. On a web whose first side needs one condition at one and whose
    second side's formation `m` needs another condition at `m + 1`, a static course admitting the
    whole first side is in the class and no list holds its admissions, yet the ranking is a strict
    partial order containing widening (`AllOrSegment.unlisted_consistent`): there no static course
    includes a course keeping widening by name (`AllOrSegment.not_static_includes`).
  - "By name" is needed. Along the continuation carrying every formation of the own-condition web
    into formation `0`, two courses keep widening, and two listed static courses, each alike from
    the first step, wider up to it and mixed with one of them, widen the keeping course of the
    other; read along it, no strict partial order containing widening ranks every such pair
    (`AlongMerging.no_order_ranks_along_listed`).
* **Widening with a lag is a strict partial order that decides the lag.** A course includes
  another with lag `d` when every formation the other admits at a step it admits `d` steps later
  (`Web.IncludesLater`); it widens it with a lag when it includes it with some lag and the other
  includes it with none (`Web.WidensWithLag`). Widening or widening with a lag
  (`Web.WidensOrWithLag`):
  - is a strict partial order containing widening by one order lemma, a transitive relation joined
    to the strict part of a transitive relation containing it (`strictJoin_trans`, a law of any
    two relations in `Becoming.GrammarLaws`; `Web.strictJoin_order`); so are the orders of a lag varying with the formation and of a lag
    for each admission (`Web.widensOrWithFormationLag_order`, `Web.widensOrEachLater_order`);
  - is unchanged by every renaming constant across steps (`Web.widensOrWithLag_rename`) and by
    exchanging the sides (`Sides.widensOrWithLag_swap`), but compares formations across steps by
    name: a re-identification varying with the step can change its verdict, where widening is
    unchanged by every re-identification (`NamesAcrossSteps.lag_reads_names`,
    `Web.widens_reidentify`). Along a continuation the lagged order is unchanged by every
    re-identification carrying it, and by name it is this order
    (`Web.widensOrWithLagAlong_reidentify`, `Web.widensOrWithLagAlong_itself_iff`);
  - decides the lag (`LagWitness.decided`), as do lags varying with the formation or with each
    admission (`LagWitness.formationLag_decides`, `LagWitness.eachLag_decides`) and the tail
    order, the strict part of inclusion with a lag from some step on joined to widening or
    eventual widening, which contains eventual widening (`Web.tailOrder_order`,
    `LagWitness.tailOrder_decides`);
  - is silent both ways on the two-sided pair, neither including the other at any lag
    (`Sides.silent`).
  Widening with a lag alone does not contain widening (`Delayed.widens_not_withLag`).
* **Widening with a lag and eventual widening disagree.** On the own-condition web one course
  eventually widens another while the other widens it with a lag (`TailAndLag.disagree`), so no
  strict partial order on that web contains both (`TailAndLag.no_order_contains_both`), nor
  eventual widening and a lag varying with the formation or with each admission
  (`TailAndLag.formationLag_conflict`, `TailAndLag.eachLag_conflict`). The tail order, containing
  eventual widening, ranks the course ahead above the early one, which admitted a formation the
  course ahead never admits (`TailAndLag.tailOrder_loses`); widening or widening with a lag never
  ranks so, since what the other admits at a step it admits then or later
  (`Web.WidensOrWithLag.includesEachLater`).
* **Keeping what the other keeps.** Widening or widening with a lag, and the tail order, rank a
  course above another only where it keeps admitting, from some step on, every formation the other
  keeps admitting from some step on (`Web.KeepsWhatKept`, `Web.WidensOrWithLag.keepsWhatKept`,
  `Web.TailOrder.keepsWhatKept`), and so does the order of a lag varying with the formation
  (`Web.WidensOrWithFormationLag.keepsWhatKept`). The order of a lag for each admission does not:
  it ranks a course above one that keeps a formation the first drops
  (`EachLagDrops.eachLag_not_keeping`). Under that condition the two-sided pair is unranked both
  ways and the listed ranking of the growing course above the first formations is excluded
  (`Sides.keeping_reading`).

Each law is a theorem for every web or a witness on a web of whole-number amounts and discrete
steps; no choice enters, and the decisions come from structural recursion.
-/

namespace Becoming

variable {F F' C : Type}

namespace Web

section Lag

variable (W : Web F C)

/-- `l` includes `l'` with lag `d`: every formation `l'` admits at a step, `l` admits `d` steps
later. With lag `0` it is inclusion. -/
def IncludesLater (d : Nat) (l l' : Nat → C → Nat) : Prop :=
  ∀ t f, W.Admits (l' t) t f → W.Admits (l (t + d)) (t + d) f

/-- `l` includes `l'` with some lag. -/
def IncludesWithLag (l l' : Nat → C → Nat) : Prop :=
  ∃ d, W.IncludesLater d l l'

/-- **Widening with a lag**: `l` includes `l'` with some lag, and `l'` includes `l` with none. -/
def WidensWithLag (l l' : Nat → C → Nat) : Prop :=
  W.IncludesWithLag l l' ∧ ¬ W.IncludesWithLag l' l

/-- Widening, or widening with a lag. -/
def WidensOrWithLag (l l' : Nat → C → Nat) : Prop :=
  W.Widens l l' ∨ W.WidensWithLag l l'

/-- Ranking keeping widening over admitting alike: every course keeping widening by name from the
first step is ranked above every course that admits alike from the first step, is wider up to the
first step, and is mixed with it. -/
def RanksKeepingOverAlike (R : (Nat → C → Nat) → (Nat → C → Nat) → Prop) : Prop :=
  ∀ l l', W.KeepsWidening itself l 0 → W.AdmitsAlikeFrom l' 0 → W.WidensUpTo 0 l' l →
    W.Mixed l l' → R l l'

end Lag

variable {W : Web F C} {l l' l'' : Nat → C → Nat}

/-- **Widening joined to the strict part of a transitive relation containing inclusion is a
strict partial order containing widening.** -/
theorem strictJoin_order {P : (Nat → C → Nat) → (Nat → C → Nat) → Prop}
    (trans : ∀ {a b c}, P a b → P b c → P a c) (includes : ∀ {a b}, W.Includes a b → P a b) :
    (∀ a, ¬ (W.Widens a a ∨ (P a a ∧ ¬ P a a))) ∧
      (∀ {a b c}, (W.Widens a b ∨ (P a b ∧ ¬ P b a)) → (W.Widens b c ∨ (P b c ∧ ¬ P c b)) →
        (W.Widens a c ∨ (P a c ∧ ¬ P c a))) ∧
      (∀ {a b}, W.Widens a b → W.Widens a b ∨ (P a b ∧ ¬ P b a)) :=
  ⟨fun _ => strictJoin_irrefl (S := W.Widens) (P := P) (fun widens => widens.not_reverse widens),
   strictJoin_trans (S := W.Widens) (P := P) Widens.trans trans (fun widens => includes widens.1),
   fun widens => .inl widens⟩

/-- **Two rankings crossed by widening close a cycle.** A transitive relation containing widening
that ranks `l` above `l'` and `k` above `k'`, where `l'` widens `k` and `k'` widens `l`, ranks `l`
above itself. -/
theorem ranks_self_of_crossed {R : (Nat → C → Nat) → (Nat → C → Nat) → Prop}
    (trans : ∀ {a b c}, R a b → R b c → R a c) (widening : ∀ {a b}, W.Widens a b → R a b)
    {k k' : Nat → C → Nat} (first : W.Widens l' k) (second : W.Widens k' l) (ranks : R l l')
    (crossed : R k k') : R l l :=
  trans ranks (trans (widening first) (trans crossed (widening second)))

/-- Inclusion is inclusion with lag `0`. -/
theorem IncludesLater.of_includes (includes : W.Includes l l') : W.IncludesLater 0 l l' :=
  fun t f admitted => includes t f admitted

/-- Lags add. -/
theorem IncludesLater.trans {d e : Nat} (first : W.IncludesLater d l l')
    (second : W.IncludesLater e l' l'') : W.IncludesLater (e + d) l l'' :=
  fun t f admitted =>
    Eq.subst (motive := fun x => W.Admits (l x) x f) (Nat.add_assoc t e d)
      (first (t + e) f (second t f admitted))

/-- Every course includes itself with lag `0`. -/
theorem IncludesWithLag.refl (l : Nat → C → Nat) : W.IncludesWithLag l l :=
  ⟨0, fun _ _ admitted => admitted⟩

/-- Inclusion with some lag is transitive. -/
theorem IncludesWithLag.trans (first : W.IncludesWithLag l l')
    (second : W.IncludesWithLag l' l'') : W.IncludesWithLag l l'' :=
  match first, second with
  | ⟨_, first⟩, ⟨_, second⟩ => ⟨_, first.trans second⟩

/-- Inclusion is inclusion with some lag. -/
theorem IncludesWithLag.of_includes (includes : W.Includes l l') : W.IncludesWithLag l l' :=
  ⟨0, IncludesLater.of_includes includes⟩

/-- Widening with a lag is irreflexive. -/
theorem WidensWithLag.irrefl : ¬ W.WidensWithLag l l :=
  fun widens => widens.2 widens.1

/-- Widening with a lag is transitive. -/
theorem WidensWithLag.trans (first : W.WidensWithLag l l') (second : W.WidensWithLag l' l'') :
    W.WidensWithLag l l'' :=
  ⟨first.1.trans second.1, fun back => first.2 (second.1.trans back)⟩

/-- Widening, then widening with a lag, is widening with a lag. -/
theorem Widens.trans_withLag (first : W.Widens l l') (second : W.WidensWithLag l' l'') :
    W.WidensWithLag l l'' :=
  ⟨(IncludesWithLag.of_includes first.1).trans second.1,
   fun back => second.2 (back.trans (IncludesWithLag.of_includes first.1))⟩

/-- Widening with a lag, then widening, is widening with a lag. -/
theorem WidensWithLag.trans_widens (first : W.WidensWithLag l l') (second : W.Widens l' l'') :
    W.WidensWithLag l l'' :=
  ⟨first.1.trans (IncludesWithLag.of_includes second.1),
   fun back => first.2 ((IncludesWithLag.of_includes second.1).trans back)⟩

/-- Widening or widening with a lag contains widening. -/
theorem WidensOrWithLag.of_widens (widens : W.Widens l l') : W.WidensOrWithLag l l' :=
  .inl widens

/-- Widening or widening with a lag is irreflexive. -/
theorem WidensOrWithLag.irrefl : ¬ W.WidensOrWithLag l l :=
  strictJoin_irrefl (S := W.Widens) (P := W.IncludesWithLag) (fun widens => widens.not_reverse widens)

/-- **Widening or widening with a lag is transitive** (`strictJoin_trans`): with `irrefl` and
`of_widens`, a strict partial order containing widening. -/
theorem WidensOrWithLag.trans (first : W.WidensOrWithLag l l')
    (second : W.WidensOrWithLag l' l'') : W.WidensOrWithLag l l'' :=
  strictJoin_trans (S := W.Widens) (P := W.IncludesWithLag) Widens.trans IncludesWithLag.trans
    (fun widens => IncludesWithLag.of_includes widens.1) first second

/-- It never reverses widening. -/
theorem Widens.not_reversed_withLag (widens : W.Widens l l') : ¬ W.WidensOrWithLag l' l :=
  fun back => WidensOrWithLag.irrefl ((WidensOrWithLag.of_widens widens).trans back)

/-! ### Listed static courses -/

/-- The class of `RanksKeepingOverAlike`, the static course's admissions held by a list. -/
def KeepingOverListedAlike (W : Web F C) (k s : Nat → C → Nat) : Prop :=
  W.KeepsWidening itself k 0 ∧ W.AdmitsAlikeFrom s 0 ∧ W.WidensUpTo 0 s k ∧ W.Mixed k s ∧
    ∃ xs : List F, ∀ f, W.Admits (s 0) 0 f → f ∈ xs

/-- A static course whose admissions a list holds includes no course keeping widening by name. -/
theorem not_listed_includes_keeping {k s : Nat → C → Nat} (keeps : W.KeepsWidening itself k 0)
    (alike : W.AdmitsAlikeFrom s 0) (listed : ∃ xs : List F, ∀ f, W.Admits (s 0) 0 f → f ∈ xs)
    (includes : W.Includes s k) : False :=
  match listed with
  | ⟨xs, within⟩ => match keeps.gathers (xs.length + 1) with
    | ⟨_, S, _, length, distinct, all⟩ =>
      Nat.not_succ_le_self xs.length
        (Eq.subst (motive := fun n => n ≤ xs.length) length
          (length_le_of_sub distinct fun f mem =>
            within f ((alike S f (Nat.zero_le S)).mp (includes S f (all f mem)))))

/-- Widening, with every course including a course that keeps widening by name put above every
course included in a listed static course of the class. -/
def ListedOrder (W : Web F C) (a b : Nat → C → Nat) : Prop :=
  W.Widens a b ∨ ∃ k s, W.Includes a k ∧ KeepingOverListedAlike W k s ∧ W.Includes s b

theorem ListedOrder.irrefl {a : Nat → C → Nat} : ¬ ListedOrder W a a
  | .inl widens => widens.not_reverse widens
  | .inr ⟨_, _, ak, ⟨keeps, alike, _, _, listed⟩, sa⟩ =>
      not_listed_includes_keeping keeps alike listed (sa.trans ak)

theorem ListedOrder.trans {a b c : Nat → C → Nat} :
    ListedOrder W a b → ListedOrder W b c → ListedOrder W a c
  | .inl first, .inl second => .inl (first.trans second)
  | .inl first, .inr ⟨k, s, bk, pair, sc⟩ => .inr ⟨k, s, first.1.trans bk, pair, sc⟩
  | .inr ⟨k, s, ak, pair, sb⟩, .inl second => .inr ⟨k, s, ak, pair, sb.trans second.1⟩
  | .inr ⟨_, _, _, ⟨_, alike, _, _, listed⟩, sb⟩, .inr ⟨_, _, bk, ⟨keeps, _, _, _, _⟩, _⟩ =>
      (not_listed_includes_keeping keeps alike listed (sb.trans bk)).elim

theorem ListedOrder.ranks {k s : Nat → C → Nat} (pair : KeepingOverListedAlike W k s) :
    ListedOrder W k s :=
  .inr ⟨k, s, Includes.refl k, pair, Includes.refl s⟩

/-! ### Other lags -/

/-- `l` includes `l'` with a lag that varies with the formation. -/
def IncludesLaterBy (W : Web F C) (d : F → Nat) (l l' : Nat → C → Nat) : Prop :=
  ∀ t f, W.Admits (l' t) t f → W.Admits (l (t + d f)) (t + d f) f

/-- `l` includes `l'` with some lag varying with the formation. -/
def IncludesWithFormationLag (W : Web F C) (l l' : Nat → C → Nat) : Prop :=
  ∃ d : F → Nat, W.IncludesLaterBy d l l'

theorem IncludesWithFormationLag.trans :
    W.IncludesWithFormationLag l l' → W.IncludesWithFormationLag l' l'' →
      W.IncludesWithFormationLag l l''
  | ⟨d, first⟩, ⟨e, second⟩ => ⟨fun f => e f + d f, fun t f admitted =>
      Eq.subst (motive := fun x => W.Admits (l x) x f) (Nat.add_assoc t (e f) (d f))
        (first (t + e f) f (second t f admitted))⟩

theorem IncludesWithFormationLag.of_includes (includes : W.Includes l l') :
    W.IncludesWithFormationLag l l' :=
  ⟨fun _ => 0, fun t f admitted => includes t f admitted⟩

/-- `l` includes `l'` with a lag for each admission: what `l'` admits at a step, `l` admits at that
step or a later one. -/
def IncludesEachLater (W : Web F C) (l l' : Nat → C → Nat) : Prop :=
  ∀ t f, W.Admits (l' t) t f → ∃ d, W.Admits (l (t + d)) (t + d) f

theorem IncludesEachLater.trans (first : W.IncludesEachLater l l')
    (second : W.IncludesEachLater l' l'') : W.IncludesEachLater l l'' :=
  fun t f admitted => match second t f admitted with
    | ⟨e, mid⟩ => match first (t + e) f mid with
      | ⟨d, last⟩ =>
        ⟨e + d, Eq.subst (motive := fun x => W.Admits (l x) x f) (Nat.add_assoc t e d) last⟩

theorem IncludesEachLater.of_includes (includes : W.Includes l l') : W.IncludesEachLater l l' :=
  fun t f admitted => ⟨0, includes t f admitted⟩

/-- Widening, or the strict part of inclusion with a lag varying with the formation. -/
def WidensOrWithFormationLag (W : Web F C) (l l' : Nat → C → Nat) : Prop :=
  W.Widens l l' ∨ (W.IncludesWithFormationLag l l' ∧ ¬ W.IncludesWithFormationLag l' l)

/-- Widening, or the strict part of inclusion with a lag for each admission. -/
def WidensOrEachLater (W : Web F C) (l l' : Nat → C → Nat) : Prop :=
  W.Widens l l' ∨ (W.IncludesEachLater l l' ∧ ¬ W.IncludesEachLater l' l)

/-- **With a lag varying with the formation, a strict partial order containing widening**
(`strictJoin_order`). -/
theorem widensOrWithFormationLag_order :
    (∀ a, ¬ W.WidensOrWithFormationLag a a) ∧
      (∀ {a b c}, W.WidensOrWithFormationLag a b → W.WidensOrWithFormationLag b c →
        W.WidensOrWithFormationLag a c) ∧
      (∀ {a b}, W.Widens a b → W.WidensOrWithFormationLag a b) :=
  strictJoin_order (W := W) (P := W.IncludesWithFormationLag) IncludesWithFormationLag.trans
    IncludesWithFormationLag.of_includes

/-- **With a lag for each admission, a strict partial order containing widening**
(`strictJoin_order`). -/
theorem widensOrEachLater_order :
    (∀ a, ¬ W.WidensOrEachLater a a) ∧
      (∀ {a b c}, W.WidensOrEachLater a b → W.WidensOrEachLater b c → W.WidensOrEachLater a c) ∧
      (∀ {a b}, W.Widens a b → W.WidensOrEachLater a b) :=
  strictJoin_order (W := W) (P := W.IncludesEachLater) IncludesEachLater.trans
    IncludesEachLater.of_includes

/-- **Widening or widening with a lag loses nothing for good**: what the other admits at a step,
the course admits at that step or a later one. -/
theorem WidensOrWithLag.includesEachLater : W.WidensOrWithLag l l' → W.IncludesEachLater l l'
  | .inl widens => IncludesEachLater.of_includes widens.1
  | .inr ⟨⟨d, includes⟩, _⟩ => fun t f admitted => ⟨d, includes t f admitted⟩

/-! ### Re-identification across steps -/

theorem includes_reidentify (σ : Reidentify F F') :
    (W.reidentify σ).Includes l l' ↔ W.Includes l l' :=
  ⟨fun includes t f admitted =>
     Eq.subst (motive := fun g => W.Admits (l t) t g) (σ.old_new t f)
       (includes t (σ.new t f)
         (Eq.subst (motive := fun g => W.Admits (l' t) t g) (σ.old_new t f).symm admitted)),
   fun includes t x admitted => includes t (σ.old t x) admitted⟩

theorem exceeds_reidentify (σ : Reidentify F F') :
    (W.reidentify σ).Exceeds l l' ↔ W.Exceeds l l' :=
  ⟨fun ⟨t, x, admitted, apart⟩ => ⟨t, σ.old t x, admitted, apart⟩,
   fun ⟨t, f, admitted, apart⟩ => ⟨t, σ.new t f,
     Eq.subst (motive := fun g => W.Admits (l t) t g) (σ.old_new t f).symm admitted,
     fun back => apart (Eq.subst (motive := fun g => W.Admits (l' t) t g) (σ.old_new t f) back)⟩⟩

/-- **Widening is unchanged by every re-identification across steps.** -/
theorem widens_reidentify (σ : Reidentify F F') :
    (W.reidentify σ).Widens l l' ↔ W.Widens l l' :=
  ⟨fun widens => ⟨(includes_reidentify σ).mp widens.1, (exceeds_reidentify σ).mp widens.2⟩,
   fun widens => ⟨(includes_reidentify σ).mpr widens.1, (exceeds_reidentify σ).mpr widens.2⟩⟩

/-- Inclusion with a lag is unchanged by a renaming constant across steps. -/
theorem includesLater_rename {old : F' → F} {new : F → F'} {old_new : ∀ f, old (new f) = f}
    {new_old : ∀ x, new (old x) = x} {d : Nat} :
    (W.reidentify (Reidentify.rename old new old_new new_old)).IncludesLater d l l' ↔
      W.IncludesLater d l l' :=
  ⟨fun includes t f admitted =>
     Eq.subst (motive := fun g => W.Admits (l (t + d)) (t + d) g) (old_new f)
       (includes t (new f)
         (Eq.subst (motive := fun g => W.Admits (l' t) t g) (old_new f).symm admitted)),
   fun includes t x admitted => includes t (old x) admitted⟩

/-- **Widening or widening with a lag is unchanged by every renaming constant across steps**, on
every web. -/
theorem widensOrWithLag_rename {old : F' → F} {new : F → F'} {old_new : ∀ f, old (new f) = f}
    {new_old : ∀ x, new (old x) = x} :
    (W.reidentify (Reidentify.rename old new old_new new_old)).WidensOrWithLag l l' ↔
      W.WidensOrWithLag l l' :=
  ⟨fun
    | .inl widens => .inl ((widens_reidentify _).mp widens)
    | .inr ⟨⟨d, inc⟩, apart⟩ => .inr ⟨⟨d, includesLater_rename.mp inc⟩,
        fun ⟨e, back⟩ => apart ⟨e, includesLater_rename.mpr back⟩⟩,
   fun
    | .inl widens => .inl ((widens_reidentify _).mpr widens)
    | .inr ⟨⟨d, inc⟩, apart⟩ => .inr ⟨⟨d, includesLater_rename.mpr inc⟩,
        fun ⟨e, back⟩ => apart ⟨e, includesLater_rename.mp back⟩⟩⟩

/-! ### The lag along a continuation -/

/-- Links compose. -/
theorem Linked.append {R : Nat → F → F → Prop} : ∀ {t : Nat} {g : F} {u : Nat} {h : F} {v : Nat}
    {k : F}, Linked R t g u h → Linked R u h v k → Linked R t g v k
  | _, _, _, _, _, _, .here _ _, rest => rest
  | _, _, _, _, _, _, .next step first, rest => .next step (Linked.append first rest)

/-- `l` includes `l'` with lag `d` along the continuation `R`: every formation `l'` admits at a
step is linked, `d` steps later, to one `l` admits. -/
def IncludesLaterAlong (W : Web F C) (R : Nat → F → F → Prop) (d : Nat) (l l' : Nat → C → Nat) :
    Prop :=
  ∀ t f, W.Admits (l' t) t f → ∃ g, Linked R t f (t + d) g ∧ W.Admits (l (t + d)) (t + d) g

theorem IncludesLaterAlong.of_includes {R : Nat → F → F → Prop} (includes : W.Includes l l') :
    W.IncludesLaterAlong R 0 l l' :=
  fun t f admitted => ⟨f, .here t f, includes t f admitted⟩

theorem IncludesLaterAlong.trans {R : Nat → F → F → Prop} {d e : Nat}
    (first : W.IncludesLaterAlong R d l l') (second : W.IncludesLaterAlong R e l' l'') :
    W.IncludesLaterAlong R (e + d) l l'' :=
  fun t f admitted => match second t f admitted with
    | ⟨g, linked, mid⟩ => match first (t + e) g mid with
      | ⟨h, linked', last⟩ =>
        ⟨h, Eq.subst (motive := fun x => Linked R t f x h) (Nat.add_assoc t e d)
              (Linked.append linked linked'),
         Eq.subst (motive := fun x => W.Admits (l x) x h) (Nat.add_assoc t e d) last⟩

/-- By name, it is inclusion with a lag. -/
theorem includesLaterAlong_itself_iff {d : Nat} :
    W.IncludesLaterAlong itself d l l' ↔ W.IncludesLater d l l' :=
  ⟨fun includes t f admitted => match includes t f admitted with
     | ⟨_, linked, admitted'⟩ =>
       Eq.subst (motive := fun x => W.Admits (l (t + d)) (t + d) x)
         (Linked.itself_same linked).2.symm admitted',
   fun includes t f admitted =>
     ⟨f, Linked.itself_of_le (Nat.le_add_right t d), includes t f admitted⟩⟩

/-- **Along a continuation, inclusion with a lag is unchanged by every re-identification carrying
the continuation.** -/
theorem includesLaterAlong_reidentify {R : Nat → F → F → Prop} (σ : Reidentify F F') {d : Nat} :
    (W.reidentify σ).IncludesLaterAlong (σ.carry R) d l l' ↔ W.IncludesLaterAlong R d l l' :=
  ⟨fun includes t f admitted =>
     match includes t (σ.new t f)
         (Eq.subst (motive := fun g => W.Admits (l' t) t g) (σ.old_new t f).symm admitted) with
     | ⟨y, linked, admitted'⟩ =>
       ⟨σ.old (t + d) y,
        Eq.subst (motive := fun g => Linked R t g (t + d) (σ.old (t + d) y)) (σ.old_new t f)
          (Linked.of_carry linked),
        admitted'⟩,
   fun includes t x admitted => match includes t (σ.old t x) admitted with
     | ⟨g, linked, admitted'⟩ =>
       ⟨σ.new (t + d) g,
        Eq.subst (motive := fun y => Linked (σ.carry R) t y (t + d) (σ.new (t + d) g))
          (σ.new_old t x) (Linked.to_carry linked),
        (Eq.subst (motive := fun h => W.Admits (l (t + d)) (t + d) h) (σ.old_new (t + d) g).symm
          admitted' : W.Admits (l (t + d)) (t + d) (σ.old (t + d) (σ.new (t + d) g)))⟩⟩

/-- Widening, or the strict part of inclusion with some lag along `R`. -/
def WidensOrWithLagAlong (W : Web F C) (R : Nat → F → F → Prop) (l l' : Nat → C → Nat) : Prop :=
  W.Widens l l' ∨ ((∃ d, W.IncludesLaterAlong R d l l') ∧ ¬ ∃ d, W.IncludesLaterAlong R d l' l)

/-- **Along any continuation, a strict partial order containing widening.** -/
theorem widensOrWithLagAlong_order {R : Nat → F → F → Prop} :
    (∀ a, ¬ W.WidensOrWithLagAlong R a a) ∧
      (∀ {a b c}, W.WidensOrWithLagAlong R a b → W.WidensOrWithLagAlong R b c →
        W.WidensOrWithLagAlong R a c) ∧
      (∀ {a b}, W.Widens a b → W.WidensOrWithLagAlong R a b) :=
  strictJoin_order (P := fun a b => ∃ d, W.IncludesLaterAlong R d a b)
    (fun first second => match first, second with
      | ⟨_, first⟩, ⟨_, second⟩ => ⟨_, first.trans second⟩)
    (fun includes => ⟨0, IncludesLaterAlong.of_includes includes⟩)

/-- By name, it is widening or widening with a lag. -/
theorem widensOrWithLagAlong_itself_iff :
    W.WidensOrWithLagAlong itself l l' ↔ W.WidensOrWithLag l l' :=
  ⟨fun
    | .inl widens => .inl widens
    | .inr ⟨⟨d, inc⟩, apart⟩ => .inr ⟨⟨d, includesLaterAlong_itself_iff.mp inc⟩,
        fun ⟨e, back⟩ => apart ⟨e, includesLaterAlong_itself_iff.mpr back⟩⟩,
   fun
    | .inl widens => .inl widens
    | .inr ⟨⟨d, inc⟩, apart⟩ => .inr ⟨⟨d, includesLaterAlong_itself_iff.mpr inc⟩,
        fun ⟨e, back⟩ => apart ⟨e, includesLaterAlong_itself_iff.mp back⟩⟩⟩

/-- **Along a continuation, the lagged order is unchanged by every re-identification carrying
it.** -/
theorem widensOrWithLagAlong_reidentify {R : Nat → F → F → Prop} (σ : Reidentify F F') :
    (W.reidentify σ).WidensOrWithLagAlong (σ.carry R) l l' ↔ W.WidensOrWithLagAlong R l l' :=
  ⟨fun
    | .inl widens => .inl ((widens_reidentify σ).mp widens)
    | .inr ⟨⟨d, inc⟩, apart⟩ => .inr ⟨⟨d, (includesLaterAlong_reidentify σ).mp inc⟩,
        fun ⟨e, back⟩ => apart ⟨e, (includesLaterAlong_reidentify σ).mpr back⟩⟩,
   fun
    | .inl widens => .inl ((widens_reidentify σ).mpr widens)
    | .inr ⟨⟨d, inc⟩, apart⟩ => .inr ⟨⟨d, (includesLaterAlong_reidentify σ).mpr inc⟩,
        fun ⟨e, back⟩ => apart ⟨e, (includesLaterAlong_reidentify σ).mp back⟩⟩⟩

/-! ### The tail order -/

/-- From step `T` on, every formation `l'` admits, `l` admits `d` steps later. -/
def IncludesLaterFrom (W : Web F C) (T d : Nat) (l l' : Nat → C → Nat) : Prop :=
  ∀ t f, T ≤ t → W.Admits (l' t) t f → W.Admits (l (t + d)) (t + d) f

/-- Inclusion with a lag from some step on. -/
def TailLag (W : Web F C) (l l' : Nat → C → Nat) : Prop :=
  ∃ T d, W.IncludesLaterFrom T d l l'

theorem TailLag.trans : W.TailLag l l' → W.TailLag l' l'' → W.TailLag l l''
  | ⟨T, d, first⟩, ⟨T', e, second⟩ => ⟨T + T', e + d, fun t f from_ admitted =>
      Eq.subst (motive := fun x => W.Admits (l x) x f) (Nat.add_assoc t e d)
        (first (t + e) f
          (Nat.le_trans (Nat.le_add_right T T') (Nat.le_trans from_ (Nat.le_add_right t e)))
          (second t f (Nat.le_trans (Nat.le_add_left T' T) from_) admitted))⟩

theorem TailLag.of_widensOrEventually : W.WidensOrEventually l l' → W.TailLag l l'
  | .inl widens => ⟨0, 0, fun t f _ admitted => widens.1 t f admitted⟩
  | .inr eventually => match (eventuallyWidens_iff.mp eventually).1 with
    | ⟨T, inc⟩ => ⟨T, 0, inc⟩

/-- Widening or eventual widening, or the strict part of inclusion with a lag from some step on. -/
def TailOrder (W : Web F C) (l l' : Nat → C → Nat) : Prop :=
  W.WidensOrEventually l l' ∨ (W.TailLag l l' ∧ ¬ W.TailLag l' l)

theorem TailOrder.irrefl : ¬ W.TailOrder l l :=
  strictJoin_irrefl (S := W.WidensOrEventually) (P := W.TailLag) WidensOrEventually.irrefl

theorem TailOrder.trans (first : W.TailOrder l l') (second : W.TailOrder l' l'') :
    W.TailOrder l l'' :=
  strictJoin_trans (S := W.WidensOrEventually) (P := W.TailLag) WidensOrEventually.trans
    TailLag.trans TailLag.of_widensOrEventually first second

/-- **The tail order is a strict partial order containing widening and eventual widening**, on
every web. -/
theorem tailOrder_order :
    (∀ a, ¬ W.TailOrder a a) ∧ (∀ {a b c}, W.TailOrder a b → W.TailOrder b c → W.TailOrder a c) ∧
      (∀ {a b}, W.Widens a b → W.TailOrder a b) ∧
      (∀ {a b}, W.EventuallyWidens a b → W.TailOrder a b) :=
  ⟨fun _ => TailOrder.irrefl, TailOrder.trans, fun widens => .inl (.inl widens),
   fun eventually => .inl (.inr eventually)⟩

/-! ### Keeping what the other keeps -/

/-- `l` keeps what `l'` keeps: every formation `l'` admits at every step from some step on, `l`
admits at every step from some step on. -/
def KeepsWhatKept (W : Web F C) (l l' : Nat → C → Nat) : Prop :=
  ∀ f, (∃ T, ∀ t, T ≤ t → W.Admits (l' t) t f) → ∃ T, ∀ t, T ≤ t → W.Admits (l t) t f

theorem KeepsWhatKept.of_includesFrom {T₀ : Nat} (includes : W.IncludesFrom T₀ l l') :
    W.KeepsWhatKept l l' :=
  fun f ⟨T, kept⟩ => ⟨T + T₀, fun t le =>
    includes t f (Nat.le_trans (Nat.le_add_left T₀ T) le)
      (kept t (Nat.le_trans (Nat.le_add_right T T₀) le))⟩

theorem KeepsWhatKept.of_includesLaterFrom {T₀ d : Nat}
    (includes : W.IncludesLaterFrom T₀ d l l') : W.KeepsWhatKept l l' :=
  fun f ⟨T, kept⟩ => ⟨T + T₀ + d, fun _ le => match le_dest le with
    | ⟨k, same⟩ =>
      have shifted : W.Admits (l (T + T₀ + k + d)) (T + T₀ + k + d) f :=
        includes (T + T₀ + k) f
          (Nat.le_trans (Nat.le_add_left T₀ T) (Nat.le_add_right (T + T₀) k))
          (kept (T + T₀ + k) (Nat.le_trans (Nat.le_add_right T T₀) (Nat.le_add_right (T + T₀) k)))
      Eq.subst (motive := fun x => W.Admits (l x) x f)
        ((Nat.add_right_comm (T + T₀) k d).trans same.symm) shifted⟩

/-- The tail order keeps what the other keeps. -/
theorem TailOrder.keepsWhatKept : W.TailOrder l l' → W.KeepsWhatKept l l'
  | .inl (.inl widens) =>
      KeepsWhatKept.of_includesFrom (T₀ := 0) (fun t f _ admitted => widens.1 t f admitted)
  | .inl (.inr eventually) => match (eventuallyWidens_iff.mp eventually).1 with
    | ⟨_, includes⟩ => KeepsWhatKept.of_includesFrom includes
  | .inr ⟨⟨_, _, includes⟩, _⟩ => KeepsWhatKept.of_includesLaterFrom includes

/-- Widening or widening with a lag keeps what the other keeps. -/
theorem WidensOrWithLag.keepsWhatKept : W.WidensOrWithLag l l' → W.KeepsWhatKept l l'
  | .inl widens =>
      KeepsWhatKept.of_includesFrom (T₀ := 0) (fun t f _ admitted => widens.1 t f admitted)
  | .inr ⟨⟨d, includes⟩, _⟩ =>
      KeepsWhatKept.of_includesLaterFrom (T₀ := 0) (d := d)
        (fun t f _ admitted => includes t f admitted)

/-- A lag varying with the formation keeps what the other keeps. -/
theorem IncludesWithFormationLag.keepsWhatKept (lagged : W.IncludesWithFormationLag l l') :
    W.KeepsWhatKept l l' :=
  match lagged with
  | ⟨d, includes⟩ => fun f ⟨T, kept⟩ => ⟨T + d f, fun _ le => match le_dest le with
    | ⟨k, same⟩ =>
      have shifted : W.Admits (l (T + k + d f)) (T + k + d f) f :=
        includes (T + k) f (kept (T + k) (Nat.le_add_right T k))
      Eq.subst (motive := fun x => W.Admits (l x) x f)
        ((Nat.add_right_comm T k (d f)).trans same.symm) shifted⟩

/-- So does widening or the strict part of inclusion with a lag varying with the formation. -/
theorem WidensOrWithFormationLag.keepsWhatKept :
    W.WidensOrWithFormationLag l l' → W.KeepsWhatKept l l'
  | .inl widens =>
      KeepsWhatKept.of_includesFrom (T₀ := 0) (fun t f _ admitted => widens.1 t f admitted)
  | .inr ⟨lagged, _⟩ => lagged.keepsWhatKept

end Web

open Web

/-! ## Keeping widening over admitting alike closes a cycle -/

namespace Sides

/-- Formations on two sides, each requiring only its own condition, at need one. -/
def web : Web (Bool × Nat) (Bool × Nat) :=
  ⟨fun _ _ => 0, fun _ _ => True, fun _ f c => c = f, fun _ _ _ => 1, fun _ _ _ => False⟩

theorem admits_iff {m : Bool × Nat → Nat} {t : Nat} {f : Bool × Nat} :
    web.Admits m t f ↔ 0 < m f :=
  ⟨fun admitted => admitted f rfl,
   fun pos _ same => Eq.subst (motive := fun x => 0 < m x) same.symm pos⟩

/-- The sides exchanged: the condition `(b, n)` reads what `(!b, n)` read. -/
def swap (l : Nat → Bool × Nat → Nat) : Nat → Bool × Nat → Nat :=
  fun t c => l t (!c.1, c.2)

/-- At step `t` the formations of the first side up to `t` are admitted: one more a step. -/
def growing (t : Nat) : Bool × Nat → Nat
  | (true, n) => OwnCondition.rung n t
  | (false, _) => 0

/-- At every step the first formation of the first side and every formation of the other side. -/
def firstAndOther (_ : Nat) : Bool × Nat → Nat
  | (true, n) => OwnCondition.rung n 0
  | (false, _) => 1

theorem growing_true {t n : Nat} : web.Admits (growing t) t (true, n) ↔ n ≤ t :=
  ⟨fun admitted => OwnCondition.le_of_rung_pos (admits_iff.mp admitted),
   fun le => admits_iff.mpr (OwnCondition.rung_pos le)⟩

theorem not_growing_false {t n : Nat} : ¬ web.Admits (growing t) t (false, n) :=
  fun admitted => Nat.lt_irrefl 0 (admits_iff.mp admitted)

theorem firstAndOther_true {t n : Nat} : web.Admits (firstAndOther t) t (true, n) ↔ n ≤ 0 :=
  ⟨fun admitted => OwnCondition.le_of_rung_pos (admits_iff.mp admitted),
   fun le => admits_iff.mpr (OwnCondition.rung_pos le)⟩

theorem firstAndOther_false {t n : Nat} : web.Admits (firstAndOther t) t (false, n) :=
  admits_iff.mpr Nat.zero_lt_one

/-- The growing course keeps widening by name from the first step. -/
theorem growing_keepsWidening : web.KeepsWidening itself growing 0 :=
  ⟨fun _ _ _ later => (includesAcross_itself_iff later).mpr fun f admitted => match f with
      | (true, _) => growing_true.mpr (Nat.le_trans (growing_true.mp admitted) later)
      | (false, _) => absurd admitted not_growing_false,
   fun S _ => ⟨S + 1, Nat.le_succ S, (exceedsAcross_itself_iff (Nat.le_succ S)).mpr
      ⟨(true, S + 1), growing_true.mpr (Nat.le_refl (S + 1)),
       fun admitted => Nat.not_succ_le_self S (growing_true.mp admitted)⟩⟩⟩

/-- The other course admits alike at every step. -/
theorem firstAndOther_alike : web.AdmitsAlikeFrom firstAndOther 0 :=
  fun _ _ _ => Iff.rfl

/-- It is wider than the growing course up to the first step. -/
theorem firstAndOther_wider_first : web.WidensUpTo 0 firstAndOther growing :=
  ⟨fun _ f within admitted => match f with
     | (true, _) => firstAndOther_true.mpr
         (Nat.le_trans (growing_true.mp admitted) within)
     | (false, _) => absurd admitted not_growing_false,
   ⟨0, (false, 0), Nat.le_refl 0, firstAndOther_false, not_growing_false⟩⟩

/-- The two are mixed. -/
theorem growing_mixed : web.Mixed growing firstAndOther :=
  ⟨⟨1, (true, 1), growing_true.mpr (Nat.le_refl 1),
    fun admitted => Nat.not_succ_le_zero 0 (firstAndOther_true.mp admitted)⟩,
   ⟨0, (false, 0), firstAndOther_false, not_growing_false⟩⟩

/-- The other course widens the growing course with its sides exchanged. -/
theorem firstAndOther_widens_swapped : web.Widens firstAndOther (swap growing) :=
  ⟨fun _ f admitted => match f with
     | (true, _) => absurd (admits_iff.mp admitted) (Nat.lt_irrefl 0)
     | (false, _) => firstAndOther_false,
   ⟨0, (true, 0), firstAndOther_true.mpr (Nat.le_refl 0),
    fun admitted => Nat.lt_irrefl 0 (admits_iff.mp admitted)⟩⟩

/-- The other course with its sides exchanged widens the growing course. -/
theorem swapped_widens_growing : web.Widens (swap firstAndOther) growing :=
  ⟨fun _ f admitted => match f with
     | (true, _) => admits_iff.mpr Nat.zero_lt_one
     | (false, _) => absurd admitted not_growing_false,
   ⟨0, (false, 0), admits_iff.mpr (OwnCondition.rung_pos (Nat.le_refl 0)), not_growing_false⟩⟩

theorem swap_admits {l : Nat → Bool × Nat → Nat} {t : Nat} {f : Bool × Nat} :
    web.Admits (swap l t) t f ↔ web.Admits (l t) t (!f.1, f.2) :=
  ⟨fun admitted => (admits_iff (m := l t)).mpr ((admits_iff (m := swap l t)).mp admitted),
   fun admitted => (admits_iff (m := swap l t)).mpr ((admits_iff (m := l t)).mp admitted)⟩

theorem swap_admits_back {l : Nat → Bool × Nat → Nat} {t : Nat} {f : Bool × Nat} :
    web.Admits (swap l t) t (!f.1, f.2) ↔ web.Admits (l t) t f :=
  match f with
  | (b, n) => Eq.subst (motive := fun x => web.Admits (swap l t) t (!b, n) ↔ web.Admits (l t) t (x, n))
      (Bool.not_not b) swap_admits

theorem swap_false {l : Nat → Bool × Nat → Nat} {t n : Nat} :
    web.Admits (swap l t) t (false, n) ↔ web.Admits (l t) t (true, n) :=
  swap_admits

theorem swap_true {l : Nat → Bool × Nat → Nat} {t n : Nat} :
    web.Admits (swap l t) t (true, n) ↔ web.Admits (l t) t (false, n) :=
  swap_admits

theorem swap_growing_false {t n : Nat} : web.Admits (swap growing t) t (false, n) ↔ n ≤ t :=
  ⟨fun admitted => growing_true.mp (swap_false.mp admitted),
   fun le => swap_false.mpr (growing_true.mpr le)⟩

theorem not_swap_growing_true {t n : Nat} : ¬ web.Admits (swap growing t) t (true, n) :=
  fun admitted => not_growing_false (swap_true.mp admitted)

theorem swap_firstAndOther_true {t n : Nat} : web.Admits (swap firstAndOther t) t (true, n) :=
  swap_true.mpr firstAndOther_false

theorem swap_firstAndOther_false {t n : Nat} :
    web.Admits (swap firstAndOther t) t (false, n) ↔ n ≤ 0 :=
  ⟨fun admitted => firstAndOther_true.mp (swap_false.mp admitted),
   fun le => swap_false.mpr (firstAndOther_true.mpr le)⟩

/-- The growing course does not widen the mirror of the other course. -/
theorem not_growing_widens_swapped : ¬ web.Widens growing (swap firstAndOther) :=
  fun widens =>
    Nat.not_succ_le_zero 4 (growing_true.mp (widens.1 0 (true, 5) swap_firstAndOther_true))

/-- The mirror of the growing course does not widen the other course. -/
theorem not_swapped_growing_widens : ¬ web.Widens (swap growing) firstAndOther :=
  fun widens =>
    not_swap_growing_true (widens.1 0 (true, 0) (firstAndOther_true.mpr (Nat.le_refl 0)))

/-- The mirror of the growing course keeps widening by name from the first step. -/
theorem swap_growing_keepsWidening : web.KeepsWidening itself (swap growing) 0 :=
  ⟨fun _ _ _ later => (includesAcross_itself_iff later).mpr fun f admitted => match f with
      | (false, _) => swap_growing_false.mpr (Nat.le_trans (swap_growing_false.mp admitted) later)
      | (true, _) => absurd admitted not_swap_growing_true,
   fun S _ => ⟨S + 1, Nat.le_succ S, (exceedsAcross_itself_iff (Nat.le_succ S)).mpr
      ⟨(false, S + 1), swap_growing_false.mpr (Nat.le_refl (S + 1)),
       fun admitted => Nat.not_succ_le_self S (swap_growing_false.mp admitted)⟩⟩⟩

/-- The mirror of the other course admits alike at every step. -/
theorem swap_firstAndOther_alike : web.AdmitsAlikeFrom (swap firstAndOther) 0 :=
  fun _ _ _ => Iff.rfl

/-- It is wider than the mirror of the growing course up to the first step. -/
theorem swap_wider_first : web.WidensUpTo 0 (swap firstAndOther) (swap growing) :=
  ⟨fun _ f within admitted => match f with
     | (false, _) => swap_firstAndOther_false.mpr
         (Nat.le_trans (swap_growing_false.mp admitted) within)
     | (true, _) => absurd admitted not_swap_growing_true,
   ⟨0, (true, 0), Nat.le_refl 0, swap_firstAndOther_true, not_swap_growing_true⟩⟩

/-- The two mirrors are mixed. -/
theorem swap_mixed : web.Mixed (swap growing) (swap firstAndOther) :=
  ⟨⟨1, (false, 1), swap_growing_false.mpr (Nat.le_refl 1),
    fun admitted => Nat.not_succ_le_zero 0 (swap_firstAndOther_false.mp admitted)⟩,
   ⟨0, (true, 0), swap_firstAndOther_true, not_swap_growing_true⟩⟩

/-- **On the two-sided web, no strict partial order containing widening ranks keeping widening by
name over admitting alike.** The mirrored pair is in the class too, and the static course of each
pair widens the keeping course of the other, so no invariance is needed. -/
theorem no_order_ranks_keeping_over_alike
    {R : (Nat → Bool × Nat → Nat) → (Nat → Bool × Nat → Nat) → Prop}
    (irrefl : ∀ a, ¬ R a a) (trans : ∀ {a b c}, R a b → R b c → R a c)
    (widening : ∀ {a b}, web.Widens a b → R a b) : ¬ web.RanksKeepingOverAlike R :=
  fun ranks => irrefl growing (ranks_self_of_crossed trans widening firstAndOther_widens_swapped
    swapped_widens_growing
    (ranks growing firstAndOther growing_keepsWidening firstAndOther_alike
      firstAndOther_wider_first growing_mixed)
    (ranks (swap growing) (swap firstAndOther) swap_growing_keepsWidening swap_firstAndOther_alike
      swap_wider_first swap_mixed))

/-- **For one pair, keeping widening over admitting alike closes a cycle under the exchange.** A
transitive relation on level paths of the two-sided web that contains widening, is unchanged by
exchanging the sides and ranks the growing course above the other, ranks the growing course above
itself. -/
theorem keeping_over_alike_cycles
    {R : (Nat → Bool × Nat → Nat) → (Nat → Bool × Nat → Nat) → Prop}
    (trans : ∀ {a b c}, R a b → R b c → R a c) (widening : ∀ {a b}, web.Widens a b → R a b)
    (exchanged : ∀ {a b}, R a b → R (swap a) (swap b)) (ranks : R growing firstAndOther) :
    R growing growing :=
  ranks_self_of_crossed trans widening firstAndOther_widens_swapped swapped_widens_growing ranks
    (exchanged ranks)

/-- Widening, or including the growing course while included in the other: widening with the one
pair added and closed. -/
def onePair (a b : Nat → Bool × Nat → Nat) : Prop :=
  web.Widens a b ∨ (web.Includes a growing ∧ web.Includes firstAndOther b)

/-- The other course does not include the growing one. -/
theorem not_firstAndOther_includes : ¬ web.Includes firstAndOther growing :=
  fun includes => Nat.not_succ_le_zero 0
    (firstAndOther_true.mp (includes 1 (true, 1) (growing_true.mpr (Nat.le_refl 1))))

/-- **For one pair the exchange is needed**: without it, a strict partial order containing
widening can rank the growing course above the other, as this one does. -/
theorem exchange_needed :
    (∀ a, ¬ onePair a a) ∧ (∀ {a b c}, onePair a b → onePair b c → onePair a c) ∧
      (∀ {a b}, web.Widens a b → onePair a b) ∧ onePair growing firstAndOther :=
  ⟨fun _ same => match same with
     | .inl widens => widens.not_reverse widens
     | .inr ⟨above, below⟩ => not_firstAndOther_includes (below.trans above),
   fun first second => match first, second with
     | .inl first, .inl second => .inl (first.trans second)
     | .inl first, .inr ⟨above, below⟩ => .inr ⟨first.1.trans above, below⟩
     | .inr ⟨above, below⟩, .inl second => .inr ⟨above, below.trans second.1⟩
     | .inr ⟨above, _⟩, .inr ⟨_, below⟩ => .inr ⟨above, below⟩,
   fun widens => .inl widens,
   .inr ⟨Includes.refl growing, Includes.refl firstAndOther⟩⟩

theorem includesLater_swap {d : Nat} {l l' : Nat → Bool × Nat → Nat}
    (includes : web.IncludesLater d l l') : web.IncludesLater d (swap l) (swap l') :=
  fun t _ admitted => swap_admits.mpr (includes t _ (swap_admits.mp admitted))

theorem includesLater_of_swap {d : Nat} {l l' : Nat → Bool × Nat → Nat}
    (includes : web.IncludesLater d (swap l) (swap l')) : web.IncludesLater d l l' :=
  fun t f admitted => swap_admits_back.mp (includes t (!f.1, f.2) (swap_admits_back.mpr admitted))

theorem includes_swap {l l' : Nat → Bool × Nat → Nat} (includes : web.Includes l l') :
    web.Includes (swap l) (swap l') :=
  fun t _ admitted => swap_admits.mpr (includes t _ (swap_admits.mp admitted))

theorem exceeds_swap {l l' : Nat → Bool × Nat → Nat} (exceeds : web.Exceeds l l') :
    web.Exceeds (swap l) (swap l') :=
  match exceeds with
  | ⟨t, f, admitted, apart⟩ =>
    ⟨t, (!f.1, f.2), swap_admits_back.mpr admitted, fun back => apart (swap_admits_back.mp back)⟩

/-- **Widening or widening with a lag is unchanged by exchanging the sides.** -/
theorem widensOrWithLag_swap {l l' : Nat → Bool × Nat → Nat} (widens : web.WidensOrWithLag l l') :
    web.WidensOrWithLag (swap l) (swap l') :=
  match widens with
  | .inl widens => .inl ⟨includes_swap widens.1, exceeds_swap widens.2⟩
  | .inr ⟨⟨d, includes⟩, apart⟩ =>
    .inr ⟨⟨d, includesLater_swap includes⟩,
      fun ⟨e, back⟩ => apart ⟨e, includesLater_of_swap back⟩⟩

/-- **Widening or widening with a lag is silent both ways here**: the growing course never admits
`(false, 0)`, which the other admits at step `0`, and the other never admits `(true, 1)`, which the
growing course admits at step `1`, so neither includes the other at any lag. -/
theorem silent :
    ¬ web.WidensOrWithLag growing firstAndOther ∧ ¬ web.WidensOrWithLag firstAndOther growing :=
  ⟨fun ranks => match ranks with
     | .inl widens => not_growing_false (widens.1 0 (false, 0) firstAndOther_false)
     | .inr ⟨⟨_, includes⟩, _⟩ => not_growing_false (includes 0 (false, 0) firstAndOther_false),
   fun ranks => match ranks with
     | .inl widens => Nat.not_succ_le_zero 0
         (firstAndOther_true.mp (widens.1 1 (true, 1) (growing_true.mpr (Nat.le_refl 1))))
     | .inr ⟨⟨_, includes⟩, _⟩ => Nat.not_succ_le_zero 0
         (firstAndOther_true.mp (includes 1 (true, 1) (growing_true.mpr (Nat.le_refl 1))))⟩

/-! ### The cycle forbids one verdict only -/

theorem swap_swap_includes (l : Nat → Bool × Nat → Nat) : web.Includes (swap (swap l)) l :=
  fun _ _ admitted => swap_admits.mpr (swap_admits_back.mpr admitted)

theorem includes_swap_swap (l : Nat → Bool × Nat → Nat) : web.Includes l (swap (swap l)) :=
  fun _ _ admitted => swap_admits_back.mp (swap_admits.mp admitted)

/-- At least the other course or its mirror. -/
def Above (a : Nat → Bool × Nat → Nat) : Prop :=
  web.Includes a firstAndOther ∨ web.Includes a (swap firstAndOther)

/-- At most the growing course or its mirror. -/
def Below (b : Nat → Bool × Nat → Nat) : Prop :=
  web.Includes growing b ∨ web.Includes (swap growing) b

/-- Widening, with every course above the other course (or its mirror) put over every course below
the growing course (or its mirror). -/
def reverseOrder (a b : Nat → Bool × Nat → Nat) : Prop :=
  web.Widens a b ∨ (Above a ∧ Below b)

theorem not_below_above {a : Nat → Bool × Nat → Nat} (above : Above a) (below : Below a) : False :=
  match above, below with
  | .inl ab, .inl be => not_growing_false ((be.trans ab) 0 (false, 0) firstAndOther_false)
  | .inl ab, .inr be => not_growing_false
      (swap_true.mp ((be.trans ab) 0 (true, 0) (firstAndOther_true.mpr (Nat.le_refl 0))))
  | .inr ab, .inl be => Nat.not_succ_le_zero 0
      (growing_true.mp ((be.trans ab) 0 (true, 1) swap_firstAndOther_true))
  | .inr ab, .inr be => not_growing_false
      (swap_true.mp ((be.trans ab) 0 (true, 0) swap_firstAndOther_true))

theorem reverseOrder_irrefl (a : Nat → Bool × Nat → Nat) : ¬ reverseOrder a a
  | .inl widens => widens.not_reverse widens
  | .inr ⟨above, below⟩ => not_below_above above below

theorem Above.of_includes {a b : Nat → Bool × Nat → Nat} (includes : web.Includes a b) :
    Above b → Above a
  | .inl inc => .inl (includes.trans inc)
  | .inr inc => .inr (includes.trans inc)

theorem Below.of_includes {a b : Nat → Bool × Nat → Nat} (includes : web.Includes a b) :
    Below a → Below b
  | .inl inc => .inl (inc.trans includes)
  | .inr inc => .inr (inc.trans includes)

theorem reverseOrder_trans {a b c : Nat → Bool × Nat → Nat} :
    reverseOrder a b → reverseOrder b c → reverseOrder a c
  | .inl first, .inl second => .inl (first.trans second)
  | .inl first, .inr ⟨above, below⟩ => .inr ⟨Above.of_includes first.1 above, below⟩
  | .inr ⟨above, below⟩, .inl second => .inr ⟨above, Below.of_includes second.1 below⟩
  | .inr ⟨above, _⟩, .inr ⟨_, below⟩ => .inr ⟨above, below⟩

theorem Above.mirror {a : Nat → Bool × Nat → Nat} : Above a → Above (swap a)
  | .inl inc => .inr (includes_swap inc)
  | .inr inc => .inl ((includes_swap inc).trans (swap_swap_includes firstAndOther))

theorem Below.mirror {b : Nat → Bool × Nat → Nat} : Below b → Below (swap b)
  | .inl inc => .inr (includes_swap inc)
  | .inr inc => .inl ((includes_swap_swap growing).trans (includes_swap inc))

theorem reverseOrder_exchanged {a b : Nat → Bool × Nat → Nat} :
    reverseOrder a b → reverseOrder (swap a) (swap b)
  | .inl widens => .inl ⟨includes_swap widens.1, exceeds_swap widens.2⟩
  | .inr ⟨above, below⟩ => .inr ⟨Above.mirror above, Below.mirror below⟩

/-- **The cycle forbids one verdict only.** A strict partial order containing widening and
unchanged by the exchange can rank the other course above the growing one, as this one does. -/
theorem reverse_consistent :
    (∀ a, ¬ reverseOrder a a) ∧
      (∀ {a b c}, reverseOrder a b → reverseOrder b c → reverseOrder a c) ∧
      (∀ {a b}, web.Widens a b → reverseOrder a b) ∧
      (∀ {a b}, reverseOrder a b → reverseOrder (swap a) (swap b)) ∧
      reverseOrder firstAndOther growing :=
  ⟨reverseOrder_irrefl, reverseOrder_trans, fun widens => .inl widens, reverseOrder_exchanged,
   .inr ⟨.inl (Includes.refl firstAndOther), .inl (Includes.refl growing)⟩⟩

/-! ### With a listed static course the ranking is consistent -/

/-- At every step the first formation of each side. -/
def firsts (_ : Nat) : Bool × Nat → Nat
  | (_, 0) => 1
  | (_, _ + 1) => 0

theorem firsts_zero {t : Nat} {b : Bool} : web.Admits (firsts t) t (b, 0) :=
  admits_iff.mpr Nat.zero_lt_one

theorem not_firsts_succ {t n : Nat} {b : Bool} : ¬ web.Admits (firsts t) t (b, n + 1) :=
  fun admitted => Nat.lt_irrefl 0 (admits_iff.mp admitted)

/-- The growing course and the first formations of both sides meet the class, with a list. -/
theorem growing_over_firsts : KeepingOverListedAlike web growing firsts :=
  ⟨growing_keepsWidening, fun _ _ _ => Iff.rfl,
   ⟨fun _ f within admitted => match f with
      | (true, 0) => firsts_zero
      | (true, n + 1) => absurd (Nat.le_trans (growing_true.mp admitted) within)
          (Nat.not_succ_le_zero n)
      | (false, _) => absurd admitted not_growing_false,
    ⟨0, (false, 0), Nat.le_refl 0, firsts_zero, not_growing_false⟩⟩,
   ⟨⟨1, (true, 1), growing_true.mpr (Nat.le_refl 1), not_firsts_succ⟩,
    ⟨0, (false, 0), firsts_zero, not_growing_false⟩⟩,
   ⟨[(true, 0), (false, 0)], fun f admitted => match f with
      | (true, 0) => .head _
      | (false, 0) => .tail _ (.head _)
      | (_, _ + 1) => absurd admitted not_firsts_succ⟩⟩

/-- **With listed static courses the ranking is consistent.** Ranking keeping widening by name over
admitting alike, restricted to static courses whose admissions a list holds, is a strict partial
order containing widening on every web (`Web.ListedOrder.irrefl`, `Web.ListedOrder.trans`,
`Web.ListedOrder.ranks`); here, on the two-sided web, it ranks the growing course above the first
formations of both sides, where widening or eventual widening is silent both ways. -/
theorem listed_consistent :
    (∀ a, ¬ ListedOrder web a a) ∧
      (∀ {a b c}, ListedOrder web a b → ListedOrder web b c → ListedOrder web a c) ∧
      (∀ {a b}, web.Widens a b → ListedOrder web a b) ∧
      (∀ {k s}, KeepingOverListedAlike web k s → ListedOrder web k s) ∧
      ListedOrder web growing firsts ∧ ¬ web.WidensOrEventually growing firsts ∧
      ¬ web.WidensOrEventually firsts growing :=
  ⟨fun _ => ListedOrder.irrefl, ListedOrder.trans, fun widens => .inl widens, ListedOrder.ranks,
   ListedOrder.ranks growing_over_firsts,
   fun ranks => match ranks with
     | .inl widens => not_growing_false (widens.1 0 (false, 0) firsts_zero)
     | .inr eventually => match (eventuallyWidens_iff.mp eventually).1 with
       | ⟨T, inc⟩ => not_growing_false (inc T (false, 0) (Nat.le_refl T) firsts_zero),
   fun ranks => match ranks with
     | .inl widens => not_firsts_succ (widens.1 1 (true, 1) (growing_true.mpr (Nat.le_refl 1)))
     | .inr eventually => match (eventuallyWidens_iff.mp eventually).1 with
       | ⟨T, inc⟩ => not_firsts_succ
           (inc (T + 1) (true, T + 1) (Nat.le_succ T) (growing_true.mpr (Nat.le_refl (T + 1))))⟩

/-! ### Keeping what the other keeps -/

theorem not_keepsWhatKept_growing : ¬ web.KeepsWhatKept growing firstAndOther :=
  fun keeps => match keeps (false, 0) ⟨0, fun _ _ => firstAndOther_false⟩ with
    | ⟨T, kept⟩ => not_growing_false (kept T (Nat.le_refl T))

theorem not_keepsWhatKept_firstAndOther : ¬ web.KeepsWhatKept firstAndOther growing :=
  fun keeps => match keeps (true, 1) ⟨1, fun _ le => growing_true.mpr le⟩ with
    | ⟨T, kept⟩ => Nat.not_succ_le_zero 0 (firstAndOther_true.mp (kept T (Nat.le_refl T)))

theorem not_keepsWhatKept_firsts : ¬ web.KeepsWhatKept growing firsts :=
  fun keeps => match keeps (false, 0) ⟨0, fun _ _ => firsts_zero⟩ with
    | ⟨T, kept⟩ => not_growing_false (kept T (Nat.le_refl T))

/-- **Under "rank only what keeps what the other keeps"** the two-sided pair is unranked both ways
with no exchange, and the listed ranking of the growing course above the first formations is
excluded. -/
theorem keeping_reading :
    ¬ web.KeepsWhatKept growing firstAndOther ∧ ¬ web.KeepsWhatKept firstAndOther growing ∧
      ¬ web.KeepsWhatKept growing firsts :=
  ⟨not_keepsWhatKept_growing, not_keepsWhatKept_firstAndOther, not_keepsWhatKept_firsts⟩

/-! ### The exchange does not exclude counting scale -/

/-- The sides exchanged on a formation. -/
def flip (f : Bool × Nat) : Bool × Nat := (!f.1, f.2)

theorem flip_flip : ∀ f : Bool × Nat, flip (flip f) = f
  | (true, _) => rfl
  | (false, _) => rfl

/-- At every step a map, one to one on what `b` admits, carries what `b` admits into what `a`
admits: `a` admits at least as many formations at every step. -/
def ScaleAtLeast (a b : Nat → Bool × Nat → Nat) : Prop :=
  ∀ t, ∃ φ : Bool × Nat → Bool × Nat,
    (∀ f g, web.Admits (b t) t f → web.Admits (b t) t g → φ f = φ g → f = g) ∧
      ∀ f, web.Admits (b t) t f → web.Admits (a t) t (φ f)

theorem ScaleAtLeast.of_includes {a b : Nat → Bool × Nat → Nat} (includes : web.Includes a b) :
    ScaleAtLeast a b :=
  fun t => ⟨fun f => f, fun _ _ _ _ same => same, fun f admitted => includes t f admitted⟩

theorem ScaleAtLeast.trans {a b c : Nat → Bool × Nat → Nat} (first : ScaleAtLeast a b)
    (second : ScaleAtLeast b c) : ScaleAtLeast a c :=
  fun t => match first t, second t with
    | ⟨φ, φinj, φmaps⟩, ⟨ψ, ψinj, ψmaps⟩ =>
      ⟨fun f => φ (ψ f),
       fun f g fa ga same => ψinj f g fa ga (φinj (ψ f) (ψ g) (ψmaps f fa) (ψmaps g ga) same),
       fun f admitted => φmaps (ψ f) (ψmaps f admitted)⟩

theorem ScaleAtLeast.exchanged {a b : Nat → Bool × Nat → Nat} (scale : ScaleAtLeast a b) :
    ScaleAtLeast (swap a) (swap b) :=
  fun t => match scale t with
    | ⟨φ, inj, maps⟩ =>
      ⟨fun f => flip (φ (flip f)),
       fun f g fa ga same =>
         have once : φ (flip f) = φ (flip g) :=
           (flip_flip (φ (flip f))).symm.trans ((congrArg flip same).trans (flip_flip (φ (flip g))))
         have twice : flip f = flip g :=
           inj (flip f) (flip g) (swap_admits.mp fa) (swap_admits.mp ga) once
         (flip_flip f).symm.trans ((congrArg flip twice).trans (flip_flip g)),
       fun f admitted => swap_admits.mpr
         (Eq.subst (motive := fun x => web.Admits (a t) t x) (flip_flip (φ (flip f))).symm
           (maps (flip f) (swap_admits.mp admitted)))⟩

/-- Widening, or admitting strictly more formations in the sense of `ScaleAtLeast`. -/
def scaleOrder (a b : Nat → Bool × Nat → Nat) : Prop :=
  web.Widens a b ∨ (ScaleAtLeast a b ∧ ¬ ScaleAtLeast b a)

theorem growing_zero_eq : ∀ {f : Bool × Nat}, web.Admits (growing 0) 0 f → f = (true, 0)
  | (true, 0), _ => rfl
  | (true, n + 1), admitted => absurd (growing_true.mp admitted) (Nat.not_succ_le_zero n)
  | (false, _), admitted => absurd admitted not_growing_false

theorem scale_firstAndOther_growing : ScaleAtLeast firstAndOther growing :=
  fun _ => ⟨fun f => (false, f.2),
    fun f g fa ga same => match f, g, fa, ga with
      | (true, _), (true, _), _, _ => congrArg (Prod.mk true) (congrArg Prod.snd same)
      | (false, _), _, fa, _ => absurd fa not_growing_false
      | (true, _), (false, _), _, ga => absurd ga not_growing_false,
    fun _ _ => firstAndOther_false⟩

theorem not_scale_growing_firstAndOther : ¬ ScaleAtLeast growing firstAndOther :=
  fun scale => match scale 0 with
    | ⟨φ, inj, maps⟩ =>
      have zero : φ (false, 0) = (true, 0) := growing_zero_eq (maps (false, 0) firstAndOther_false)
      have one : φ (false, 1) = (true, 0) := growing_zero_eq (maps (false, 1) firstAndOther_false)
      have same : ((false, 0) : Bool × Nat) = (false, 1) :=
        inj (false, 0) (false, 1) firstAndOther_false firstAndOther_false (zero.trans one.symm)
      Nat.noConfusion (congrArg Prod.snd same)

/-- **The exchange admits counting scale.** Widening joined to the strict part of "at least as
many formations at every step" is a strict partial order containing widening and unchanged by the
exchange; it ranks the other course above the growing one. -/
theorem scale_counts :
    (∀ a, ¬ scaleOrder a a) ∧
      (∀ {a b c}, scaleOrder a b → scaleOrder b c → scaleOrder a c) ∧
      (∀ {a b}, web.Widens a b → scaleOrder a b) ∧
      (∀ {a b}, scaleOrder a b → scaleOrder (swap a) (swap b)) ∧
      scaleOrder firstAndOther growing :=
  ⟨(strictJoin_order (W := web) (P := ScaleAtLeast) ScaleAtLeast.trans ScaleAtLeast.of_includes).1,
   (strictJoin_order (W := web) (P := ScaleAtLeast) ScaleAtLeast.trans ScaleAtLeast.of_includes).2.1,
   fun widens => .inl widens,
   fun ranks => match ranks with
     | .inl widens => .inl ⟨includes_swap widens.1, exceeds_swap widens.2⟩
     | .inr ⟨scale, apart⟩ => .inr ⟨scale.exchanged, fun back =>
         apart ((ScaleAtLeast.of_includes (includes_swap_swap _)).trans
           (back.exchanged.trans (ScaleAtLeast.of_includes (swap_swap_includes _))))⟩,
   .inr ⟨scale_firstAndOther_growing, not_scale_growing_firstAndOther⟩⟩

end Sides

/-! ## Infinite width does not suffice

Here the first side is all or nothing and the second side an initial segment: a static course can
admit every formation of the first side, which no list holds, but no static course includes a
course keeping widening by name, so ranking keeping widening over admitting alike is a strict
partial order containing widening. -/

namespace AllOrSegment

/-- The first side's formations need condition `true` at one; formation `(false, m)` needs
condition `false` at `m + 1`. -/
def needOf : Bool × Nat → Nat
  | (true, _) => 1
  | (false, m) => m + 1

/-- Formations on two sides, each side requiring its own condition. -/
def web : Web (Bool × Nat) Bool :=
  ⟨fun _ _ => 0, fun _ _ => True, fun _ f c => c = f.1, fun _ f _ => needOf f, fun _ _ _ => False⟩

theorem admits_iff {m : Bool → Nat} {t : Nat} {f : Bool × Nat} :
    web.Admits m t f ↔ needOf f ≤ m f.1 :=
  ⟨fun admitted => admitted f.1 rfl,
   fun le _ same => Eq.subst (motive := fun x => needOf f ≤ m x) same.symm le⟩

/-- Admitting one formation of the first side admits them all. -/
theorem firstSide_all {m : Bool → Nat} {t n n' : Nat} (admitted : web.Admits m t (true, n)) :
    web.Admits m t (true, n') :=
  (admits_iff (t := t) (f := (true, n'))).mpr ((admits_iff (t := t) (f := (true, n))).mp admitted)

/-- After every step, a course keeping widening by name opens on the second side. -/
theorem secondSide_opening {k : Nat → Bool → Nat} (keeps : web.KeepsWidening itself k 0)
    (S : Nat) :
    ∃ U, S ≤ U ∧ ∃ m, web.Admits (k U) U (false, m) ∧ ¬ web.Admits (k S) S (false, m) :=
  match keeps.2 S (Nat.zero_le S) with
  | ⟨U, le, exceeds⟩ => match (exceedsAcross_itself_iff le).mp exceeds with
    | ⟨(false, m), admitted, before⟩ => ⟨U, le, m, admitted, before⟩
    | ⟨(true, _), admitted, _⟩ => match keeps.2 U (Nat.zero_le U) with
      | ⟨U', le', exceeds'⟩ => match (exceedsAcross_itself_iff le').mp exceeds' with
        | ⟨(true, _), _, before'⟩ => absurd (firstSide_all admitted) before'
        | ⟨(false, m), admitted', before'⟩ =>
          ⟨U', Nat.le_trans le le', m, admitted', fun earlier =>
            before' ((includesAcross_itself_iff le).mp (keeps.1 S U (Nat.zero_le S) le) _ earlier)⟩

/-- A course keeping widening by name admits every formation of the second side at some step. -/
theorem reaches_secondSide {k : Nat → Bool → Nat} (keeps : web.KeepsWidening itself k 0) :
    ∀ n, ∃ S, web.Admits (k S) S (false, n)
  | 0 => match secondSide_opening keeps 0 with
    | ⟨U, _, m, admitted, _⟩ =>
      ⟨U, admits_iff.mpr (Nat.le_trans (Nat.succ_le_succ (Nat.zero_le m)) (admits_iff.mp admitted))⟩
  | n + 1 => match reaches_secondSide keeps n with
    | ⟨S, at_S⟩ => match secondSide_opening keeps S with
      | ⟨U, _, m, admitted, before⟩ =>
        have below : k S false < m + 1 :=
          Nat.gt_of_not_le fun le => before (admits_iff.mpr le)
        have lt : n + 1 < m + 1 := Nat.lt_of_le_of_lt (admits_iff.mp at_S) below
        ⟨U, admits_iff.mpr (Nat.le_trans lt (admits_iff.mp admitted))⟩

/-- No static course includes a course keeping widening by name. -/
theorem not_static_includes {k s : Nat → Bool → Nat} (keeps : web.KeepsWidening itself k 0)
    (alike : web.AdmitsAlikeFrom s 0) (includes : web.Includes s k) : False :=
  match reaches_secondSide keeps (s 0 false) with
  | ⟨S, admitted⟩ =>
    Nat.not_succ_le_self (s 0 false)
      (admits_iff.mp ((alike S (false, s 0 false) (Nat.zero_le S)).mp (includes S _ admitted)))

/-- The class of `Web.RanksKeepingOverAlike`. -/
def KeepingOverAlike (k s : Nat → Bool → Nat) : Prop :=
  web.KeepsWidening itself k 0 ∧ web.AdmitsAlikeFrom s 0 ∧ web.WidensUpTo 0 s k ∧ web.Mixed k s

/-- Widening, with every course including a keeping course put above every course its static
course includes. -/
def ClassOrder (a b : Nat → Bool → Nat) : Prop :=
  web.Widens a b ∨ ∃ k s, web.Includes a k ∧ KeepingOverAlike k s ∧ web.Includes s b

theorem ClassOrder.irrefl (a : Nat → Bool → Nat) : ¬ ClassOrder a a
  | .inl widens => widens.not_reverse widens
  | .inr ⟨_, _, ak, ⟨keeps, alike, _, _⟩, sa⟩ => not_static_includes keeps alike (sa.trans ak)

theorem ClassOrder.trans {a b c : Nat → Bool → Nat} :
    ClassOrder a b → ClassOrder b c → ClassOrder a c
  | .inl first, .inl second => .inl (first.trans second)
  | .inl first, .inr ⟨k, s, bk, pair, sc⟩ => .inr ⟨k, s, first.1.trans bk, pair, sc⟩
  | .inr ⟨k, s, ak, pair, sb⟩, .inl second => .inr ⟨k, s, ak, pair, sb.trans second.1⟩
  | .inr ⟨_, _, _, ⟨_, alike, _, _⟩, sb⟩, .inr ⟨_, _, bk, ⟨keeps, _, _, _⟩, _⟩ =>
      (not_static_includes keeps alike (sb.trans bk)).elim

/-- The second side rising: `(false, m)` admitted at step `t` for `m ≤ t`. -/
def rising (t : Nat) : Bool → Nat
  | true => 0
  | false => t + 1

/-- Every formation of the first side, and `(false, 0)`, at every step. -/
def wide (_ : Nat) : Bool → Nat
  | true => 1
  | false => 1

theorem rising_keeps : web.KeepsWidening itself rising 0 :=
  ⟨fun _ _ _ le => (includesAcross_itself_iff le).mpr fun f admitted => match f with
      | (true, _) => absurd (admits_iff.mp admitted) (Nat.not_succ_le_zero 0)
      | (false, _) => admits_iff.mpr (Nat.le_trans (admits_iff.mp admitted) (Nat.succ_le_succ le)),
   fun S _ => ⟨S + 1, Nat.le_succ S, (exceedsAcross_itself_iff (Nat.le_succ S)).mpr
      ⟨(false, S + 1), admits_iff.mpr (Nat.le_refl _),
       fun admitted => Nat.not_succ_le_self (S + 1) (admits_iff.mp admitted)⟩⟩⟩

/-- The rising course and the wide one are in the class. -/
theorem rising_over_wide : KeepingOverAlike rising wide :=
  ⟨rising_keeps, fun _ _ _ => Iff.rfl,
   ⟨fun _ f le admitted => match f with
      | (true, _) => absurd (admits_iff.mp admitted) (Nat.not_succ_le_zero 0)
      | (false, _) => admits_iff.mpr (Nat.le_trans (admits_iff.mp admitted) (Nat.succ_le_succ le)),
    ⟨0, (true, 0), Nat.le_refl 0, admits_iff.mpr (Nat.le_refl 1),
     fun admitted => Nat.not_succ_le_zero 0 (admits_iff.mp admitted)⟩⟩,
   ⟨⟨1, (false, 1), admits_iff.mpr (Nat.le_refl 2),
     fun admitted => Nat.not_succ_le_self 1 (admits_iff.mp admitted)⟩,
    ⟨0, (true, 0), admits_iff.mpr (Nat.le_refl 1),
     fun admitted => Nat.not_succ_le_zero 0 (admits_iff.mp admitted)⟩⟩⟩

/-- The first side's formations below `n`. -/
def firstSide : Nat → List (Bool × Nat)
  | 0 => []
  | n + 1 => (true, n) :: firstSide n

theorem firstSide_below : ∀ {n : Nat} {f : Bool × Nat}, f ∈ firstSide n → f.2 < n
  | 0, _, mem => nomatch mem
  | n + 1, _, mem => match mem_cons_cases mem with
    | .inl same => Eq.subst (motive := fun x => Prod.snd x < n + 1) same.symm (Nat.lt_succ_self n)
    | .inr rest => Nat.lt_trans (firstSide_below rest) (Nat.lt_succ_self n)

theorem firstSide_distinct : ∀ n, Distinct (firstSide n)
  | 0 => trivial
  | n + 1 => ⟨fun mem => Nat.lt_irrefl n (firstSide_below mem), firstSide_distinct n⟩

theorem firstSide_length : ∀ n, (firstSide n).length = n
  | 0 => rfl
  | n + 1 => congrArg Nat.succ (firstSide_length n)

theorem firstSide_fst : ∀ {n : Nat} {f : Bool × Nat}, f ∈ firstSide n → f.1 = true
  | 0, _, mem => nomatch mem
  | _ + 1, _, mem => match mem_cons_cases mem with
    | .inl same => congrArg Prod.fst same
    | .inr rest => firstSide_fst rest

/-- The wide course admits every formation of the first side: no list holds its admissions. -/
theorem wide_not_listed : ¬ ∃ xs : List (Bool × Nat), ∀ f, web.Admits (wide 0) 0 f → f ∈ xs :=
  fun ⟨xs, within⟩ =>
    Nat.not_succ_le_self xs.length
      (Eq.subst (motive := fun n => n ≤ xs.length) (firstSide_length (xs.length + 1))
        (length_le_of_sub (firstSide_distinct (xs.length + 1)) fun f mem =>
          match f, firstSide_fst mem with
          | (true, _), _ => within _ (admits_iff.mpr (Nat.le_refl 1))
          | (false, _), same => Bool.noConfusion same))

/-- **Infinite width does not suffice.** On this web a pair of the class has a static course no
list holds, and yet a strict partial order containing widening ranks every pair of the class. -/
theorem unlisted_consistent :
    KeepingOverAlike rising wide ∧
      (¬ ∃ xs : List (Bool × Nat), ∀ f, web.Admits (wide 0) 0 f → f ∈ xs) ∧
      (∀ a, ¬ ClassOrder a a) ∧ (∀ {a b c}, ClassOrder a b → ClassOrder b c → ClassOrder a c) ∧
      (∀ {a b}, web.Widens a b → ClassOrder a b) ∧ web.RanksKeepingOverAlike ClassOrder :=
  ⟨rising_over_wide, wide_not_listed, ClassOrder.irrefl, ClassOrder.trans,
   fun widens => .inl widens,
   fun l l' keeps alike wider mixed => .inr ⟨l, l', Includes.refl l, ⟨keeps, alike, wider, mixed⟩,
     Includes.refl l'⟩⟩

end AllOrSegment

/-! ## By name: along a merging continuation, listed static courses close the cycle

07 §2 reads keeping widening along a continuation (`Web.KeepsWidening R`). Along the continuation
carrying every formation into formation `0`, four courses on the own-condition web cross, the
static ones alike from the first step and listed, so the listed scope of the ranking needs keeping
widening by name. -/

namespace AlongMerging

open OwnCondition

/-- Every formation continues into formation `0`. -/
def intoZero : Nat → Nat → Nat → Prop := fun _ _ f => f = 0

/-- A chain along `intoZero` stays put or ends at `0`. -/
theorem linked_cases : ∀ {s g u h : Nat},
    Linked intoZero s g u h → (s = u ∧ g = h) ∨ (s < u ∧ h = 0)
  | _, _, _, _, .here _ _ => .inl ⟨rfl, rfl⟩
  | s, _, _, _, .next step rest => match linked_cases rest with
    | .inl ⟨same, same'⟩ =>
      .inr ⟨Eq.subst (motive := fun x => s < x) same (Nat.lt_succ_self s), same'.symm.trans step⟩
    | .inr ⟨lt, zero⟩ => .inr ⟨Nat.lt_trans (Nat.lt_succ_self s) lt, zero⟩

/-- Every formation is linked to `0` at every later step. -/
theorem linked_to_zero (s g : Nat) : ∀ k, Linked intoZero s g (s + (k + 1)) 0
  | 0 => .next rfl (.here (s + 1) 0)
  | k + 1 => Linked.append (linked_to_zero s g k) (.next rfl (.here (s + (k + 1) + 1) 0))

/-- A formation other than `0` one step on is linked to nothing. -/
theorem not_linked_succ {s f g : Nat} (linked : Linked intoZero s f (s + 1) (g + 1)) : False :=
  match linked_cases linked with
  | .inl ⟨same, _⟩ =>
    Nat.lt_irrefl s (Eq.subst (motive := fun x => s < x) same.symm (Nat.lt_succ_self s))
  | .inr ⟨_, zero⟩ => Nat.noConfusion zero

/-- A course admitting formation `0` at every step includes along `intoZero` across every
stretch. -/
theorem includesAcross_of_zero {l : Nat → Nat → Nat} (zero : ∀ t, 0 < l t 0) :
    web.IncludesAcrossFrom intoZero l 0 :=
  fun S U _ le f admitted => match le_dest le with
    | ⟨0, same⟩ => ⟨f, Eq.subst (motive := fun x => Linked intoZero S f x f) same.symm (.here S f),
        Eq.subst (motive := fun x => web.Admits (l x) x f) same.symm admitted⟩
    | ⟨k + 1, same⟩ =>
      ⟨0, Eq.subst (motive := fun x => Linked intoZero S f x 0) same.symm (linked_to_zero S f k),
       admits_iff.mpr (zero U)⟩

theorem not_admits_of_zero {m : Nat → Nat} {t f : Nat} (zero : m f = 0) : ¬ web.Admits m t f :=
  fun admitted =>
    Nat.lt_irrefl 0 (Eq.subst (motive := fun x => 0 < x) zero (admits_iff.mp admitted))

theorem admits_of_one {m : Nat → Nat} {t f : Nat} (one : m f = 1) : web.Admits m t f :=
  admits_iff.mpr (Eq.subst (motive := fun x => 0 < x) one.symm Nat.zero_lt_one)

/-- Formations `0` and `1` at step `0`, `0` and `2` after. -/
def keepingA (t : Nat) : Nat → Nat
  | 0 => 1
  | 1 => rung t 0
  | 2 => rung 1 t
  | _ + 3 => 0

/-- Formations `0` and `3` at step `0`, `0` and `4` after. -/
def keepingB (t : Nat) : Nat → Nat
  | 0 => 1
  | 1 => 0
  | 2 => 0
  | 3 => rung t 0
  | 4 => rung 1 t
  | _ + 5 => 0

/-- Formations `0`, `1`, `3`, `4` at every step. -/
def staticA (_ : Nat) : Nat → Nat
  | 0 => 1
  | 1 => 1
  | 2 => 0
  | 3 => 1
  | 4 => 1
  | _ + 5 => 0

/-- Formations `0`, `1`, `2`, `3` at every step. -/
def staticB (_ : Nat) : Nat → Nat
  | 0 => 1
  | 1 => 1
  | 2 => 1
  | 3 => 1
  | _ + 4 => 0

theorem keepingA_keeps : web.KeepsWidening intoZero keepingA 0 :=
  ⟨includesAcross_of_zero fun _ => Nat.zero_lt_one,
   fun S _ => ⟨S + 1, Nat.le_succ S,
     ⟨2, admits_of_one rfl, fun _ linked _ => not_linked_succ linked⟩⟩⟩

theorem keepingB_keeps : web.KeepsWidening intoZero keepingB 0 :=
  ⟨includesAcross_of_zero fun _ => Nat.zero_lt_one,
   fun S _ => ⟨S + 1, Nat.le_succ S,
     ⟨4, admits_of_one rfl, fun _ linked _ => not_linked_succ linked⟩⟩⟩

theorem staticA_wider_first : web.WidensUpTo 0 staticA keepingA :=
  ⟨fun t f le admitted => match t, f, le, admitted with
     | 0, 0, _, _ => admits_of_one rfl
     | 0, 1, _, _ => admits_of_one rfl
     | 0, 2, _, admitted => absurd admitted (not_admits_of_zero rfl)
     | 0, 3, _, _ => admits_of_one rfl
     | 0, _ + 4, _, admitted => absurd admitted (not_admits_of_zero rfl)
     | t + 1, _, le, _ => absurd le (Nat.not_succ_le_zero t),
   ⟨0, 3, Nat.le_refl 0, admits_of_one rfl, not_admits_of_zero rfl⟩⟩

theorem staticB_wider_first : web.WidensUpTo 0 staticB keepingB :=
  ⟨fun t f le admitted => match t, f, le, admitted with
     | 0, 0, _, _ => admits_of_one rfl
     | 0, 1, _, _ => admits_of_one rfl
     | 0, 2, _, _ => admits_of_one rfl
     | 0, 3, _, _ => admits_of_one rfl
     | 0, 4, _, admitted => absurd admitted (not_admits_of_zero rfl)
     | 0, _ + 5, _, admitted => absurd admitted (not_admits_of_zero rfl)
     | t + 1, _, le, _ => absurd le (Nat.not_succ_le_zero t),
   ⟨0, 1, Nat.le_refl 0, admits_of_one rfl, not_admits_of_zero rfl⟩⟩

theorem mixedA : web.Mixed keepingA staticA :=
  ⟨⟨1, 2, admits_of_one rfl, not_admits_of_zero rfl⟩,
   ⟨0, 3, admits_of_one rfl, not_admits_of_zero rfl⟩⟩

theorem mixedB : web.Mixed keepingB staticB :=
  ⟨⟨1, 4, admits_of_one rfl, not_admits_of_zero rfl⟩,
   ⟨0, 1, admits_of_one rfl, not_admits_of_zero rfl⟩⟩

theorem listedA : ∃ xs : List Nat, ∀ f, web.Admits (staticA 0) 0 f → f ∈ xs :=
  ⟨[0, 1, 3, 4], fun f admitted => match f with
    | 0 => .head _
    | 1 => .tail _ (.head _)
    | 2 => absurd admitted (not_admits_of_zero rfl)
    | 3 => .tail _ (.tail _ (.head _))
    | 4 => .tail _ (.tail _ (.tail _ (.head _)))
    | _ + 5 => absurd admitted (not_admits_of_zero rfl)⟩

theorem listedB : ∃ xs : List Nat, ∀ f, web.Admits (staticB 0) 0 f → f ∈ xs :=
  ⟨[0, 1, 2, 3], fun f admitted => match f with
    | 0 => .head _
    | 1 => .tail _ (.head _)
    | 2 => .tail _ (.tail _ (.head _))
    | 3 => .tail _ (.tail _ (.tail _ (.head _)))
    | _ + 4 => absurd admitted (not_admits_of_zero rfl)⟩

/-- The static course of the first pair widens the keeping course of the second. -/
theorem staticA_widens_keepingB : web.Widens staticA keepingB :=
  ⟨fun _ f admitted => match f with
     | 0 => admits_of_one rfl
     | 1 => absurd admitted (not_admits_of_zero rfl)
     | 2 => absurd admitted (not_admits_of_zero rfl)
     | 3 => admits_of_one rfl
     | 4 => admits_of_one rfl
     | _ + 5 => absurd admitted (not_admits_of_zero rfl),
   ⟨0, 1, admits_of_one rfl, not_admits_of_zero rfl⟩⟩

/-- The static course of the second pair widens the keeping course of the first. -/
theorem staticB_widens_keepingA : web.Widens staticB keepingA :=
  ⟨fun _ f admitted => match f with
     | 0 => admits_of_one rfl
     | 1 => admits_of_one rfl
     | 2 => admits_of_one rfl
     | _ + 3 => absurd admitted (not_admits_of_zero rfl),
   ⟨0, 3, admits_of_one rfl, not_admits_of_zero rfl⟩⟩

/-- The class with keeping widening read along `intoZero` and the static course listed. -/
def KeepingAlongOverListedAlike (k s : Nat → Nat → Nat) : Prop :=
  web.KeepsWidening intoZero k 0 ∧ web.AdmitsAlikeFrom s 0 ∧ web.WidensUpTo 0 s k ∧
    web.Mixed k s ∧ ∃ xs : List Nat, ∀ f, web.Admits (s 0) 0 f → f ∈ xs

theorem pairA : KeepingAlongOverListedAlike keepingA staticA :=
  ⟨keepingA_keeps, fun _ _ _ => Iff.rfl, staticA_wider_first, mixedA, listedA⟩

theorem pairB : KeepingAlongOverListedAlike keepingB staticB :=
  ⟨keepingB_keeps, fun _ _ _ => Iff.rfl, staticB_wider_first, mixedB, listedB⟩

/-- **With keeping widening read along a continuation, listing does not save the ranking.** No
strict partial order containing widening ranks every course keeping widening along `intoZero` above
every listed static course that admits alike from the first step, was wider up to it and is mixed
with it. -/
theorem no_order_ranks_along_listed {R : (Nat → Nat → Nat) → (Nat → Nat → Nat) → Prop}
    (irrefl : ∀ a, ¬ R a a) (trans : ∀ {a b c}, R a b → R b c → R a c)
    (widening : ∀ {a b}, web.Widens a b → R a b)
    (ranks : ∀ k s, KeepingAlongOverListedAlike k s → R k s) : False :=
  irrefl keepingA (ranks_self_of_crossed trans widening staticA_widens_keepingB
    staticB_widens_keepingA (ranks keepingA staticA pairA) (ranks keepingB staticB pairB))

end AlongMerging

/-! ## Widening with a lag decides the lag -/

namespace LagWitness

/-- The lagging course includes the travelling one with lag one. -/
theorem includesLater_one : OwnCondition.web.IncludesLater 1 lagging travelling :=
  fun t _ admitted => kept_later admitted (Nat.lt_succ_self t)

/-- The travelling course includes the lagging one with no lag. -/
theorem not_travelling_includes : ¬ OwnCondition.web.IncludesWithLag travelling lagging :=
  fun ⟨d, includes⟩ =>
    have same : 0 = 1 + d := travelling_iff.mp (includes 1 0 (lagging_iff.mpr Nat.zero_lt_one))
    match d, same with
    | 0, same => Nat.noConfusion same
    | _ + 1, same => Nat.noConfusion same

/-- **Widening with a lag decides the lag**: the lagging course widens the travelling one with a
lag, where neither eventually widens the other. -/
theorem widensWithLag : OwnCondition.web.WidensWithLag lagging travelling :=
  ⟨⟨1, includesLater_one⟩, not_travelling_includes⟩

/-- The lag, and its decision. -/
theorem decided :
    OwnCondition.web.WidensOrWithLag lagging travelling ∧
      ¬ OwnCondition.web.EventuallyWidens lagging travelling ∧
      ¬ OwnCondition.web.EventuallyWidens travelling lagging :=
  ⟨.inr widensWithLag, not_eventually_lagging, not_eventually_travelling⟩

/-- A lag varying with the formation decides it too. -/
theorem formationLag_decides :
    OwnCondition.web.IncludesWithFormationLag lagging travelling ∧
      ¬ OwnCondition.web.IncludesWithFormationLag travelling lagging :=
  ⟨⟨fun _ => 1, fun t _ admitted => kept_later admitted (Nat.lt_succ_self t)⟩,
   fun ⟨d, includes⟩ =>
     have same : 0 = 1 + d 0 := travelling_iff.mp (includes 1 0 (lagging_iff.mpr Nat.zero_lt_one))
     match d 0, same with
     | 0, same => Nat.noConfusion same
     | _ + 1, same => Nat.noConfusion same⟩

/-- So does a lag for each admission. -/
theorem eachLag_decides :
    OwnCondition.web.IncludesEachLater lagging travelling ∧
      ¬ OwnCondition.web.IncludesEachLater travelling lagging :=
  ⟨fun t _ admitted => ⟨1, kept_later admitted (Nat.lt_succ_self t)⟩,
   fun includes => match includes 1 0 (lagging_iff.mpr Nat.zero_lt_one) with
     | ⟨d, admitted⟩ =>
       have same : 0 = 1 + d := travelling_iff.mp admitted
       match d, same with
       | 0, same => Nat.noConfusion same
       | _ + 1, same => Nat.noConfusion same⟩

/-- **The tail order decides the lag**, though eventual widening, which it contains, does not. -/
theorem tailOrder_decides :
    OwnCondition.web.TailOrder lagging travelling ∧
      ¬ OwnCondition.web.EventuallyWidens lagging travelling ∧
      ¬ OwnCondition.web.EventuallyWidens travelling lagging :=
  ⟨.inr ⟨⟨0, 1, fun t _ _ admitted => kept_later admitted (Nat.lt_succ_self t)⟩,
     fun ⟨T, d, includes⟩ =>
       have same : 0 = T + 1 + d :=
         travelling_iff.mp (includes (T + 1) 0 (Nat.le_succ T) (lagging_iff.mpr (Nat.zero_lt_succ T)))
       match d, same with
       | 0, same => Nat.noConfusion same
       | _ + 1, same => Nat.noConfusion same⟩,
   not_eventually_lagging, not_eventually_travelling⟩

end LagWitness

/-! ## Widening with a lag alone does not contain widening -/

namespace Delayed

open OwnCondition

/-- The rising course widens the lagging one, which is the rising course one step late. -/
theorem rising_widens : OwnCondition.web.Widens rising LagWitness.lagging :=
  ⟨fun _ _ admitted => rising_iff.mpr (Nat.le_of_lt (LagWitness.lagging_iff.mp admitted)),
   ⟨0, 0, rising_iff.mpr (Nat.le_refl 0),
    fun admitted => Nat.lt_irrefl 0 (LagWitness.lagging_iff.mp admitted)⟩⟩

/-- The lagging course includes the rising one with lag one. -/
theorem lagging_includes : OwnCondition.web.IncludesLater 1 LagWitness.lagging rising :=
  fun _ _ admitted => LagWitness.lagging_iff.mpr (Nat.lt_succ_of_le (rising_iff.mp admitted))

/-- **Widening with a lag alone does not contain widening**: the rising course widens the lagging
one and does not widen it with a lag. -/
theorem widens_not_withLag :
    OwnCondition.web.Widens rising LagWitness.lagging ∧
      ¬ OwnCondition.web.WidensWithLag rising LagWitness.lagging :=
  ⟨rising_widens, fun widens => widens.2 ⟨1, lagging_includes⟩⟩

end Delayed

/-! ## A lag for each admission can drop what the other keeps

On the own-condition web `steady` admits formation `0` at every step; `alternate` admits it at even
steps only, and formation `1` at step `0`. The order of a lag for each admission ranks `alternate`
above `steady`, though `alternate` does not keep what `steady` keeps; a uniform lag or a lag varying
with the formation never ranks so. -/

namespace EachLagDrops

open OwnCondition

/-- One at even steps, zero at odd ones. -/
def evenLevel : Nat → Nat
  | 0 => 1
  | 1 => 0
  | n + 2 => evenLevel n

theorem even_or_next : ∀ t, 0 < evenLevel t ∨ 0 < evenLevel (t + 1)
  | 0 => .inl Nat.zero_lt_one
  | 1 => .inr Nat.zero_lt_one
  | n + 2 => even_or_next n

theorem odd_or_next : ∀ t, evenLevel t = 0 ∨ evenLevel (t + 1) = 0
  | 0 => .inr rfl
  | 1 => .inl rfl
  | n + 2 => odd_or_next n

/-- Formation `0` at every step. -/
def steady (_ : Nat) : Nat → Nat
  | 0 => 1
  | _ + 1 => 0

/-- Formation `0` at even steps, and formation `1` at step `0`. -/
def alternate (t : Nat) : Nat → Nat
  | 0 => evenLevel t
  | 1 => rung t 0
  | _ + 2 => 0

theorem steady_zero {t : Nat} : web.Admits (steady t) t 0 :=
  admits_iff.mpr Nat.zero_lt_one

theorem steady_only {t f : Nat} (admitted : web.Admits (steady t) t f) : f = 0 :=
  match f, admitted with
  | 0, _ => rfl
  | _ + 1, admitted => absurd (admits_iff.mp admitted) (Nat.lt_irrefl 0)

theorem not_steady_one {t : Nat} : ¬ web.Admits (steady t) t 1 :=
  fun admitted => Nat.lt_irrefl 0 (admits_iff.mp admitted)

theorem alternate_one : web.Admits (alternate 0) 0 1 :=
  admits_iff.mpr Nat.zero_lt_one

/-- Each admission of `steady` is answered by `alternate` at the same step or the next. -/
theorem alternate_includesEachLater : web.IncludesEachLater alternate steady :=
  fun t _ admitted =>
    Eq.subst (motive := fun g => ∃ d, web.Admits (alternate (t + d)) (t + d) g)
      (steady_only admitted).symm
      (match even_or_next t with
       | .inl pos => ⟨0, admits_iff.mpr pos⟩
       | .inr pos => ⟨1, admits_iff.mpr pos⟩)

/-- `steady` never answers `alternate`'s admission of formation `1`. -/
theorem not_steady_includesEachLater : ¬ web.IncludesEachLater steady alternate :=
  fun includes => match includes 0 1 alternate_one with
    | ⟨_, admitted⟩ => not_steady_one admitted

/-- `alternate` does not keep what `steady` keeps. -/
theorem not_keeps : ¬ web.KeepsWhatKept alternate steady :=
  fun keeps => match keeps 0 ⟨0, fun _ _ => steady_zero⟩ with
    | ⟨T, kept⟩ => match odd_or_next T with
      | .inl zero => Nat.lt_irrefl 0 (Eq.subst (motive := fun x => 0 < x) zero
          ((admits_iff (m := alternate T)).mp (kept T (Nat.le_refl T))))
      | .inr zero => Nat.lt_irrefl 0 (Eq.subst (motive := fun x => 0 < x) zero
          ((admits_iff (m := alternate (T + 1))).mp (kept (T + 1) (Nat.le_succ T))))

/-- **A lag for each admission can drop what the other keeps.** Its order ranks `alternate` above
`steady`, which keeps a formation `alternate` does not keep; widening or widening with a lag, and
the order of a lag varying with the formation, do not rank them so. -/
theorem eachLag_not_keeping :
    web.WidensOrEachLater alternate steady ∧ ¬ web.KeepsWhatKept alternate steady ∧
      ¬ web.WidensOrWithLag alternate steady ∧ ¬ web.WidensOrWithFormationLag alternate steady :=
  ⟨.inr ⟨alternate_includesEachLater, not_steady_includesEachLater⟩, not_keeps,
   fun ranks => not_keeps ranks.keepsWhatKept, fun ranks => not_keeps ranks.keepsWhatKept⟩

end EachLagDrops

/-! ## Widening with a lag and eventual widening disagree -/

namespace TailAndLag

open OwnCondition

/-- At step `t` the formations from `1` to `t + 1` are admitted, never formation `0`. -/
def ahead (t : Nat) : Nat → Nat
  | 0 => 0
  | c + 1 => rung c t

/-- At step `0` formation `0` alone; at step `t + 1` the formations from `1` to `t + 1`. -/
def early : Nat → Nat → Nat
  | 0, 0 => 1
  | _ + 1, 0 => 0
  | 0, _ + 1 => 0
  | t + 1, c + 1 => rung c t

theorem not_ahead_zero {t : Nat} : ¬ OwnCondition.web.Admits (ahead t) t 0 :=
  fun admitted => Nat.lt_irrefl 0 (admits_iff.mp admitted)

theorem ahead_succ {t c : Nat} : OwnCondition.web.Admits (ahead t) t (c + 1) ↔ c ≤ t :=
  ⟨fun admitted => le_of_rung_pos ((admits_iff (m := ahead t)).mp admitted),
   fun le => (admits_iff (m := ahead t)).mpr (rung_pos le)⟩

theorem early_zero : OwnCondition.web.Admits (early 0) 0 0 :=
  admits_iff.mpr Nat.zero_lt_one

theorem early_succ {t c : Nat} :
    OwnCondition.web.Admits (early (t + 1)) (t + 1) (c + 1) ↔ c ≤ t :=
  ⟨fun admitted => le_of_rung_pos ((admits_iff (m := early (t + 1))).mp admitted),
   fun le => (admits_iff (m := early (t + 1))).mpr (rung_pos le)⟩

theorem not_early_zero_succ {c : Nat} : ¬ OwnCondition.web.Admits (early 0) 0 (c + 1) :=
  fun admitted => Nat.lt_irrefl 0 (admits_iff.mp admitted)

theorem not_early_succ_zero {t : Nat} : ¬ OwnCondition.web.Admits (early (t + 1)) (t + 1) 0 :=
  fun admitted => Nat.lt_irrefl 0 (admits_iff.mp admitted)

/-- From step one, the course ahead includes the early one. -/
theorem includesFrom : OwnCondition.web.IncludesFrom 1 ahead early :=
  fun t f from_ admitted => match t, f, from_, admitted with
    | 0, _, from_, _ => absurd from_ (Nat.not_succ_le_zero 0)
    | _ + 1, 0, _, admitted => absurd admitted not_early_succ_zero
    | _ + 1, _ + 1, _, admitted => ahead_succ.mpr (Nat.le_succ_of_le (early_succ.mp admitted))

/-- The course ahead exceeds the early one at every step. -/
theorem exceedsLate : OwnCondition.web.ExceedsLate ahead early :=
  fun S => ⟨S, S + 1, Nat.le_refl S, ahead_succ.mpr (Nat.le_refl S), fun admitted => match S with
    | 0 => not_early_zero_succ admitted
    | s + 1 => Nat.not_succ_le_self s (early_succ.mp admitted)⟩

/-- The course ahead eventually widens the early one. -/
theorem eventually : OwnCondition.web.EventuallyWidens ahead early :=
  eventuallyWidens_iff.mpr ⟨⟨1, includesFrom⟩, exceedsLate⟩

/-- The early course includes the course ahead with lag one. -/
theorem early_includes : OwnCondition.web.IncludesLater 1 early ahead :=
  fun _ f admitted => match f with
    | 0 => absurd admitted not_ahead_zero
    | _ + 1 => early_succ.mpr (ahead_succ.mp admitted)

/-- The course ahead includes the early one with no lag: it never admits formation `0`. -/
theorem not_ahead_includes : ¬ OwnCondition.web.IncludesWithLag ahead early :=
  fun ⟨_, includes⟩ => not_ahead_zero (includes 0 0 early_zero)

/-- **They disagree**: the course ahead eventually widens the early one, and the early one widens
it with a lag. -/
theorem disagree :
    OwnCondition.web.EventuallyWidens ahead early ∧ OwnCondition.web.WidensWithLag early ahead :=
  ⟨eventually, ⟨⟨1, early_includes⟩, not_ahead_includes⟩⟩

/-- **On the own-condition web, no strict partial order contains both eventual widening and
widening with a lag.** -/
theorem no_order_contains_both {R : (Nat → Nat → Nat) → (Nat → Nat → Nat) → Prop}
    (irrefl : ∀ a, ¬ R a a) (trans : ∀ {a b c}, R a b → R b c → R a c)
    (eventual : ∀ {a b}, OwnCondition.web.EventuallyWidens a b → R a b)
    (lagged : ∀ {a b}, OwnCondition.web.WidensWithLag a b → R a b) : False :=
  irrefl ahead (trans (eventual disagree.1) (lagged disagree.2))

/-- **The tail order ranks a course above one that admitted what it never admits**: the course
ahead is above the early one in the tail order and never admits formation `0`, which the early one
admits at step `0`; widening or widening with a lag does not rank it so
(`Web.WidensOrWithLag.includesEachLater`). -/
theorem tailOrder_loses :
    OwnCondition.web.TailOrder ahead early ∧ OwnCondition.web.Admits (early 0) 0 0 ∧
      (∀ t, ¬ OwnCondition.web.Admits (ahead t) t 0) ∧
      ¬ OwnCondition.web.WidensOrWithLag ahead early :=
  ⟨.inl (.inr eventually), early_zero, fun _ => not_ahead_zero,
   fun ranks => match ranks.includesEachLater 0 0 early_zero with
     | ⟨_, admitted⟩ => not_ahead_zero admitted⟩

/-- **The conflict survives a lag varying with the formation**: the course ahead never admits
formation `0`, so no lag of any kind catches it up. -/
theorem formationLag_conflict {R : (Nat → Nat → Nat) → (Nat → Nat → Nat) → Prop}
    (irrefl : ∀ a, ¬ R a a) (trans : ∀ {a b c}, R a b → R b c → R a c)
    (eventual : ∀ {a b}, OwnCondition.web.EventuallyWidens a b → R a b)
    (lagged : ∀ {a b}, OwnCondition.web.IncludesWithFormationLag a b →
      ¬ OwnCondition.web.IncludesWithFormationLag b a → R a b) : False :=
  irrefl ahead (trans (eventual eventually)
    (lagged ⟨fun _ => 1, early_includes⟩
      fun ⟨_, includes⟩ => not_ahead_zero (includes 0 0 early_zero)))

/-- **And a lag for each admission.** -/
theorem eachLag_conflict {R : (Nat → Nat → Nat) → (Nat → Nat → Nat) → Prop}
    (irrefl : ∀ a, ¬ R a a) (trans : ∀ {a b c}, R a b → R b c → R a c)
    (eventual : ∀ {a b}, OwnCondition.web.EventuallyWidens a b → R a b)
    (lagged : ∀ {a b}, OwnCondition.web.IncludesEachLater a b →
      ¬ OwnCondition.web.IncludesEachLater b a → R a b) : False :=
  irrefl ahead (trans (eventual eventually)
    (lagged (fun t _ admitted => ⟨1, early_includes t _ admitted⟩)
      fun includes => match includes 0 0 early_zero with
        | ⟨_, admitted⟩ => not_ahead_zero admitted))

end TailAndLag

/-! ## Widening with a lag reads names across steps -/

namespace NamesAcrossSteps

/-- Two formations, each requiring its own condition at need one. -/
def web : Web Bool Bool :=
  ⟨fun _ _ => 0, fun _ _ => True, fun _ f c => c = f, fun _ _ _ => 1, fun _ _ _ => False⟩

/-- From step one on, the two names exchanged. -/
def flip : Nat → Bool → Bool
  | 0, b => b
  | _ + 1, b => !b

theorem flip_flip : ∀ t b, flip t (flip t b) = b
  | 0, _ => rfl
  | _ + 1, true => rfl
  | _ + 1, false => rfl

/-- From step one on, the two formations exchange names. -/
def exchange : Reidentify Bool Bool := ⟨flip, flip, flip_flip, flip_flip⟩

/-- `true` at step 0 only. -/
def once : Nat → Bool → Nat
  | 0, true => 1
  | 0, false => 0
  | _ + 1, _ => 0

/-- `true` at every step from one on. -/
def later : Nat → Bool → Nat
  | 0, _ => 0
  | _ + 1, true => 1
  | _ + 1, false => 0

theorem admits_iff {m : Bool → Nat} {t : Nat} {f : Bool} : web.Admits m t f ↔ 0 < m f :=
  ⟨fun admitted => admitted f rfl,
   fun pos _ same => Eq.subst (motive := fun x => 0 < m x) same.symm pos⟩

theorem re_admits_iff {m : Bool → Nat} {t : Nat} {x : Bool} :
    (web.reidentify exchange).Admits m t x ↔ 0 < m (flip t x) :=
  ⟨fun admitted => admitted (flip t x) rfl,
   fun pos _ same => Eq.subst (motive := fun y => 0 < m y) same.symm pos⟩

theorem later_withLag : web.WidensWithLag later once :=
  ⟨⟨1, fun t f admitted => match t, f, admitted with
      | 0, true, _ => admits_iff.mpr Nat.zero_lt_one
      | 0, false, admitted => absurd (admits_iff.mp admitted) (Nat.lt_irrefl 0)
      | _ + 1, true, admitted => absurd (admits_iff.mp admitted) (Nat.lt_irrefl 0)
      | _ + 1, false, admitted => absurd (admits_iff.mp admitted) (Nat.lt_irrefl 0)⟩,
   fun ⟨d, includes⟩ => match d, includes 1 true (admits_iff.mpr Nat.zero_lt_one) with
     | 0, admitted => Nat.lt_irrefl 0 (admits_iff.mp admitted)
     | _ + 1, admitted => Nat.lt_irrefl 0 (admits_iff.mp admitted)⟩

theorem not_later_withLag_renamed : ¬ (web.reidentify exchange).IncludesWithLag later once :=
  fun ⟨d, includes⟩ => match d, includes 0 true (re_admits_iff.mpr Nat.zero_lt_one) with
    | 0, admitted => Nat.lt_irrefl 0 (re_admits_iff.mp admitted)
    | _ + 1, admitted => Nat.lt_irrefl 0 (re_admits_iff.mp admitted)

/-- **Widening with a lag reads names across steps.** On this web `later` widens `once` with a lag;
after the re-identification that exchanges the two names from step one on, it does not, while
widening is unchanged by every re-identification. -/
theorem lag_reads_names :
    web.WidensWithLag later once ∧
      ¬ (web.reidentify exchange).WidensWithLag later once ∧
      ((web.reidentify exchange).Widens later once ↔ web.Widens later once) :=
  ⟨later_withLag, fun widens => not_later_withLag_renamed widens.1, widens_reidentify exchange⟩

/-- **Along the continuation the re-identification carries, the verdict comes back.** -/
theorem along_restores :
    (web.reidentify exchange).WidensOrWithLagAlong (exchange.carry itself) later once :=
  (widensOrWithLagAlong_reidentify exchange).mpr
    (widensOrWithLagAlong_itself_iff.mpr (.inr later_withLag))

end NamesAcrossSteps

end Becoming
