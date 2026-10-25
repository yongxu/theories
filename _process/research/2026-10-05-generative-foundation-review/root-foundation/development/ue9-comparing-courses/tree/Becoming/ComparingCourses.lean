import Becoming.EventualWideningInstances

/-!
# Comparing two courses: what a comparison can be on what they admit

07's open item asks for a comparison of a range whose widening keeps widening with one merely
wider now, never reversing widening and counting neither novelty nor scale. UE4's lag
(`LagWitness.lag`) is the case such a comparison should decide and eventual widening cannot.
Read on what courses admit, three laws locate it.

* **Keeping widening over admitting alike closes a cycle.** On a web of formations on two sides, each requiring its
  own condition at need one (`Sides.web`), take a transitive relation on level paths that contains
  widening and is unchanged by exchanging the sides. If it ranks the course admitting, at step
  `t`, the formations of one side up to `t` above the course admitting the first of them and every
  formation of the other side, it ranks the first course above itself
  (`Sides.keeping_over_alike_cycles`). So no strict partial order containing widening and
  unchanged by the exchange ranks every course keeping widening above every course that admits
  alike, is wider at the first step and is mixed with it (`Sides.no_order_ranks_keeping_over_alike`).
  Without the exchange one such ranking is consistent (`Sides.exchange_needed`).
* **Widening with a lag is a strict partial order.** A course includes another with lag `d` when
  every formation the other admits at a step it admits `d` steps later (`Web.IncludesLater`); it
  widens it with a lag when it includes it with some lag and the other includes it with none
  (`Web.WidensWithLag`). Widening or widening with a lag (`Web.WidensOrWithLag`):
  - is irreflexive, transitive and contains widening (`Web.WidensOrWithLag.irrefl`,
    `Web.WidensOrWithLag.trans`, `Web.WidensOrWithLag.of_widens`);
  - is unchanged by exchanging the sides (`Sides.widensOrWithLag_swap`);
  - decides the lag: the lagging course widens the travelling one with a lag
    (`LagWitness.widensWithLag`).
  Widening with a lag alone does not contain widening (`Delayed.widens_not_withLag`), and on the
  two-sided web it is silent between the growing course and the other (`Sides.silent`).
* **Widening with a lag and eventual widening disagree.** One course eventually widens another
  while the other widens it with a lag (`TailAndLag.disagree`), so no strict partial order contains
  both (`TailAndLag.no_order_contains_both`). A comparison that counts what early steps admit and
  one that reads only tails part there.

Each law is a theorem for every web or a witness on a web of whole-number amounts and discrete
steps; no choice enters, and the decisions come from structural recursion.
-/

namespace Becoming

variable {F C : Type}

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

/-- Ranking keeping widening over admitting alike: every course keeping widening by name from the first step is
ranked above every course that admits alike from the first step, is wider up to the first step,
and is mixed with it. -/
def RanksKeepingOverAlike (R : (Nat → C → Nat) → (Nat → C → Nat) → Prop) : Prop :=
  ∀ l l', W.KeepsWidening itself l 0 → W.AdmitsAlikeFrom l' 0 → W.WidensUpTo 0 l' l →
    W.Mixed l l' → R l l'

end Lag

variable {W : Web F C} {l l' l'' : Nat → C → Nat}

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
theorem WidensOrWithLag.irrefl : ¬ W.WidensOrWithLag l l
  | .inl widens => widens.not_reverse widens
  | .inr widens => WidensWithLag.irrefl widens

/-- **Widening or widening with a lag is transitive**: with `irrefl` and `of_widens`, a strict
partial order containing widening. -/
theorem WidensOrWithLag.trans (first : W.WidensOrWithLag l l')
    (second : W.WidensOrWithLag l' l'') : W.WidensOrWithLag l l'' :=
  match first, second with
  | .inl first, .inl second => .inl (first.trans second)
  | .inl first, .inr second => .inr (first.trans_withLag second)
  | .inr first, .inl second => .inr (first.trans_widens second)
  | .inr first, .inr second => .inr (first.trans second)

/-- It never reverses widening. -/
theorem Widens.not_reversed_withLag (widens : W.Widens l l') : ¬ W.WidensOrWithLag l' l :=
  fun back => WidensOrWithLag.irrefl ((WidensOrWithLag.of_widens widens).trans back)

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

/-- **Keeping widening over admitting alike closes a cycle.** A transitive relation on level paths of the two-sided
web that contains widening and is unchanged by exchanging the sides, and ranks the growing course
above the other, ranks the growing course above itself. -/
theorem keeping_over_alike_cycles
    {R : (Nat → Bool × Nat → Nat) → (Nat → Bool × Nat → Nat) → Prop}
    (trans : ∀ {a b c}, R a b → R b c → R a c) (widening : ∀ {a b}, web.Widens a b → R a b)
    (exchanged : ∀ {a b}, R a b → R (swap a) (swap b)) (ranks : R growing firstAndOther) :
    R growing growing :=
  trans ranks (trans (widening firstAndOther_widens_swapped)
    (trans (exchanged ranks) (widening swapped_widens_growing)))

/-- **No strict partial order containing widening and unchanged by exchanging the sides ranks
keeping widening over admitting alike.** -/
theorem no_order_ranks_keeping_over_alike
    {R : (Nat → Bool × Nat → Nat) → (Nat → Bool × Nat → Nat) → Prop}
    (irrefl : ∀ a, ¬ R a a) (trans : ∀ {a b c}, R a b → R b c → R a c)
    (widening : ∀ {a b}, web.Widens a b → R a b)
    (exchanged : ∀ {a b}, R a b → R (swap a) (swap b)) : ¬ web.RanksKeepingOverAlike R :=
  fun ranks => irrefl growing (keeping_over_alike_cycles trans widening exchanged
    (ranks growing firstAndOther growing_keepsWidening firstAndOther_alike
      firstAndOther_wider_first growing_mixed))

/-- Widening, or including the growing course while included in the other: widening with the one
pair added and closed. -/
def onePair (a b : Nat → Bool × Nat → Nat) : Prop :=
  web.Widens a b ∨ (web.Includes a growing ∧ web.Includes firstAndOther b)

/-- The other course does not include the growing one. -/
theorem not_firstAndOther_includes : ¬ web.Includes firstAndOther growing :=
  fun includes => Nat.not_succ_le_zero 0
    (firstAndOther_true.mp (includes 1 (true, 1) (growing_true.mpr (Nat.le_refl 1))))

/-- **The exchange is needed**: without it, a strict partial order containing widening ranks the
growing course above the other. -/
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

theorem not_not_bool : ∀ b : Bool, (!!b) = b
  | true => rfl
  | false => rfl

theorem swap_admits {l : Nat → Bool × Nat → Nat} {t : Nat} {f : Bool × Nat} :
    web.Admits (swap l t) t f ↔ web.Admits (l t) t (!f.1, f.2) :=
  ⟨fun admitted => (admits_iff (m := l t)).mpr ((admits_iff (m := swap l t)).mp admitted),
   fun admitted => (admits_iff (m := swap l t)).mpr ((admits_iff (m := l t)).mp admitted)⟩

theorem swap_admits_back {l : Nat → Bool × Nat → Nat} {t : Nat} {f : Bool × Nat} :
    web.Admits (swap l t) t (!f.1, f.2) ↔ web.Admits (l t) t f :=
  match f with
  | (b, n) => Eq.subst (motive := fun x => web.Admits (swap l t) t (!b, n) ↔ web.Admits (l t) t (x, n))
      (not_not_bool b) swap_admits

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

/-- **Widening or widening with a lag is silent here**: neither the growing
course nor the other is ranked above the other. -/
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

end Sides

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

end LagWitness

/-! ## Widening with a lag alone does not contain widening -/

namespace Delayed

open OwnCondition

theorem rising_iff {t n : Nat} : OwnCondition.web.Admits (rising t) t n ↔ n ≤ t :=
  ⟨fun admitted => le_of_rung_pos ((admits_iff (m := rising t)).mp admitted),
   fun le => (admits_iff (m := rising t)).mpr (rung_pos le)⟩

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

/-- **No strict partial order contains both eventual widening and widening with a lag.** -/
theorem no_order_contains_both {R : (Nat → Nat → Nat) → (Nat → Nat → Nat) → Prop}
    (irrefl : ∀ a, ¬ R a a) (trans : ∀ {a b c}, R a b → R b c → R a c)
    (eventual : ∀ {a b}, OwnCondition.web.EventuallyWidens a b → R a b)
    (lagged : ∀ {a b}, OwnCondition.web.WidensWithLag a b → R a b) : False :=
  irrefl ahead (trans (eventual disagree.1) (lagged disagree.2))

end TailAndLag

end Becoming
