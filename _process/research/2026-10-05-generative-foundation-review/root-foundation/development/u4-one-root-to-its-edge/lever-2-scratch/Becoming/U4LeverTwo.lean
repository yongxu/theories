import Becoming.Grammar
import Becoming.SelectionLevels
import Becoming.GroupEnding
import Becoming.Transmission

/-!
# U4, lever 2 (scratch): evolution's rows read on the root

Scratch for the audit `../LEVER-2-AUDIT.md`, not package Lean, revised after its one independent
review (`../REVIEW-U4-L2.md`). It checks the readings the audit leans on.

* **Exact transmission is descent within the trait's class.** Read one step of descent on
  occurrences (a parent before the step, an offspring after it), with descent built from the
  generations' lists and the trait as a map to `Nat`. Each offspring carries its parent's amount
  (`SelectionTerm.Exact`) exactly where descent lies within sameness under the trait
  (`exact_iff_within`). Read as continuation (`exact_iff_continues`) this is `within_iff_continues`,
  true of every relation and class: a representation of U2's kind, not a derivation. Price's two
  transmission terms both vanish exactly there (`exact_iff_terms_vanish`).
* **Three strengths.** Exact transmission pairs the parents, once for every offspring, with the
  offspring under continuation relative to the class (`exact_pairs`), so under the class
  (`exact_paired_class`). A pairing under the class gives equal totals (`totals_of_paired`), and
  equal totals are the two terms cancelling (`totals_iff_cancel`). Neither step reverses: `Swap` is
  paired and not exact, each term one; `Unexact` has equal totals and no pairing
  (`unexact_not_paired`).
* **Cancellation is what the levels rows use.** `rises_cancel_iff_levels` is
  `SelectionLevels.rises_exact_iff_levels` with exact transmission weakened to the terms
  cancelling. `Raised` shows the hypothesis cannot be dropped (`Raised.levels_fail`,
  `Raised.not_cancel`).
* **The gate is inclusions.** "Only active formations give" is giving within giving from an active
  formation (`acting_iff`), and listed descent lies within giving (`listed_within_gives`). From
  them: `all_end_on_root` (`GroupEnding.Flow.all_end`), and `rises_iff_inactive_on_root`
  (`GroupEnding.Flow.rises_iff_inactive`, with cancellation for exactness). `Ungated` shows the
  gate cannot be dropped from `all_end`.
* **Coming to stand is given to.** `no_new_dependence_of_given` is `Flow.no_new_dependence` with
  balance weakened to that inclusion; balance is one way to meet it
  (`no_new_dependence_from_balance`), and `Ungiven` shows it cannot be dropped.

The modelling choices are listed in the audit's §8.
-/

namespace Becoming

namespace U4LeverTwo

variable {α X : Type}

/-! ## Exact transmission as continuation under a class -/

/-- Occurrences of one step of descent: a parent before the step (`false`) or an offspring
after it (`true`). -/
abbrev Occ (α : Type) := Bool × α

/-- Descent read as condition: the parent, before the step, is among what the offspring, after
it, comes from. -/
def descent (ps : List α) (kids : α → List α) : «际» (Occ α) :=
  fun u v => ∃ p k, u = (false, p) ∧ v = (true, k) ∧ p ∈ ps ∧ k ∈ kids p

/-- The trait read at an occurrence: `a` before the step, `b` after it. -/
def trait (a b : α → Nat) : Occ α → Nat := fun u => cond u.1 (b u.2) (a u.2)

/-- Sameness under a map. -/
def alike (f : Occ α → Nat) : «际» (Occ α) := fun u v => f u = f v

/-- Sameness under a map is a class. -/
theorem alike_class (f : Occ α → Nat) : «类» (alike f) :=
  ⟨fun _ => rfl, fun h => h.symm, fun h₁ h₂ => h₁.trans h₂⟩

/-- A relation lies within a class exactly where it lies within its own continuation under the
class. -/
theorem within_iff_continues {β : Type} {R E : «际» β} : «则» R E ↔ «则» R («续» R E) :=
  ⟨fun h x y r => ⟨r, h x y r⟩, fun h x y r => (h x y r).2⟩

/-- **Exact transmission is descent within the trait's class.** Each offspring carries its
parent's amount exactly where descent lies within sameness under the trait. -/
theorem exact_iff_within (ps : List α) (kids : α → List α) (a b : α → Nat) :
    SelectionTerm.Exact ps kids a b ↔ «则» (descent ps kids) (alike (trait a b)) :=
  ⟨fun exact u v ⟨p, k, hu, hv, mp, mk⟩ => by
      subst hu
      subst hv
      exact (exact p mp k mk).symm,
   fun within p mp k mk => (within (false, p) (true, k) ⟨p, k, rfl, rfl, mp, mk⟩).symm⟩

/-- **Exact transmission is descent within its own continuation** under the trait's class:
every step of descent is a step of continuation. -/
theorem exact_iff_continues (ps : List α) (kids : α → List α) (a b : α → Nat) :
    SelectionTerm.Exact ps kids a b ↔
      «则» (descent ps kids) («续» (descent ps kids) (alike (trait a b))) :=
  (exact_iff_within ps kids a b).trans within_iff_continues

/-- A total of nothing but zeros: each listed term is zero. -/
theorem zero_of_total_zero (f : α → Nat) :
    ∀ hs : List α, total hs f = 0 → ∀ h, h ∈ hs → f h = 0
  | [], _ => fun _ mem => nomatch mem
  | _ :: hs, zero => fun h mem => match mem with
    | .head _ => Nat.eq_zero_of_le_zero (Nat.le_trans (Nat.le_add_right _ _) (Nat.le_of_eq zero))
    | .tail _ mem' => zero_of_total_zero f hs (Nat.eq_zero_of_le_zero
        (Nat.le_trans (Nat.le_add_left _ _) (Nat.le_of_eq zero))) h mem'

/-- No excess: at most. -/
theorem le_of_excess_zero : ∀ {x y : Nat}, excess x y = 0 → x ≤ y
  | 0, _, _ => Nat.zero_le _
  | _ + 1, 0, h =>
    absurd (Eq.subst (motive := fun x => 0 < x) h (excess_pos.mpr (Nat.succ_pos _))) (Nat.lt_irrefl 0)
  | _ + 1, _ + 1, h => Nat.succ_le_succ (le_of_excess_zero h)

/-- **Price's transmission terms vanish exactly under exact transmission.** What transmission
raised and what it lowered are both zero exactly where each offspring carries its parent's
amount. -/
theorem exact_iff_terms_vanish (ps : List α) (kids : α → List α) (a b : α → Nat) :
    SelectionTerm.Exact ps kids a b ↔ raised ps kids a b = 0 ∧ lowered ps kids a b = 0 :=
  ⟨fun exact => ⟨SelectionTerm.raised_exact exact, SelectionTerm.lowered_exact exact⟩,
   fun ⟨r, l⟩ p mp k mk =>
     Nat.le_antisymm
       (le_of_excess_zero
         (zero_of_total_zero _ (kids p) (zero_of_total_zero _ ps r p mp) k mk))
       (le_of_excess_zero
         (zero_of_total_zero _ (kids p) (zero_of_total_zero _ ps l p mp) k mk))⟩

/-- **Within the class, the offspring's total is selection alone.** Where descent lies within
sameness under the trait, the offspring's total is the parents' amounts weighted by their
offspring numbers: Price's equation in counting form with no transmission term. -/
theorem offspring_eq_selected_of_within {ps : List α} {kids : α → List α} {a b : α → Nat}
    (within : «则» (descent ps kids) (alike (trait a b))) :
    offspring ps kids b = selected ps kids a := by
  have exact := (exact_iff_within ps kids a b).mpr within
  have p := price ps kids a b
  rw [SelectionTerm.raised_exact exact, SelectionTerm.lowered_exact exact, Nat.add_zero,
    Nat.add_zero] at p
  exact p

/-! Equal totals without exactness: one parent at one, two offspring at none and two. -/

namespace Unexact

def ps : List Bool := [false]

def kids : Bool → List Bool := fun _ => [false, true]

def a : Bool → Nat := fun _ => 1

def b : Bool → Nat := fun k => cond k 2 0

/-- The offspring's total is the parents' weighted total. -/
theorem totals_alike : offspring ps kids b = selected ps kids a := by decide

/-- Yet transmission is not exact: the totals hide what transmission raised and lowered. -/
theorem not_exact : ¬ SelectionTerm.Exact ps kids a b := fun exact =>
  absurd (exact false (List.Mem.head _) false (List.Mem.head _)) (by decide)

end Unexact

/-! ## The descent pairing, which lever 1's count law reads -/

/-- The parents before the step, each listed once for every offspring. -/
def before (kids : α → List α) : List α → List (Occ α)
  | [] => []
  | p :: ps => (kids p).map (fun _ => (false, p)) ++ before kids ps

/-- The offspring after the step, listed parent by parent. -/
def after (kids : α → List α) : List α → List (Occ α)
  | [] => []
  | p :: ps => (kids p).map (fun k => (true, k)) ++ after kids ps

theorem append_assoc' {β : Type} : ∀ (b₁ b₂ d : List β), (b₁ ++ b₂) ++ d = b₁ ++ (b₂ ++ d)
  | [], _, _ => rfl
  | x :: b₁, b₂, d => congrArg (x :: ·) (append_assoc' b₁ b₂ d)

/-- Pairings side by side are one pairing. -/
theorem pair_append {β : Type} {R : «际» β} {a b c d : List β} (h : «对» R a b)
    (h' : «对» R c d) : «对» R (a ++ c) (b ++ d) := by
  induction h with
  | nil => exact h'
  | @cons x y a' b₁ b₂ r _ ih =>
    rw [append_assoc' b₁ (y :: b₂) d]
    exact .cons r (append_assoc' b₁ b₂ d ▸ ih)

/-- One parent's copies are paired with its offspring, in order. -/
theorem pairs_one {R : «际» (Occ α)} (p : α) :
    ∀ ks : List α, (∀ k, k ∈ ks → R (false, p) (true, k)) →
      «对» R (ks.map (fun _ => (false, p))) (ks.map (fun k => (true, k)))
  | [], _ => .nil
  | k :: ks, step => .cons (b₁ := []) (b₂ := ks.map (fun k => (true, k)))
      (step k (List.Mem.head _)) (pairs_one p ks fun k' mk' => step k' (List.Mem.tail _ mk'))

/-- Where each parent is related to each of its offspring, the parents, once for every
offspring, are paired with the offspring. -/
theorem pairs_all {R : «际» (Occ α)} (kids : α → List α) :
    ∀ ps : List α, (∀ p, p ∈ ps → ∀ k, k ∈ kids p → R (false, p) (true, k)) →
      «对» R (before kids ps) (after kids ps)
  | [], _ => .nil
  | p :: ps, step => pair_append
      (pairs_one p (kids p) fun k mk => step p (List.Mem.head _) k mk)
      (pairs_all kids ps fun q mq k mk => step q (List.Mem.tail _ mq) k mk)

/-- **Exact transmission gives the descent pairing under continuation.** Where transmission is
exact, the parents, once for every offspring, are paired with the offspring under continuation of
descent relative to the trait's class. Lever 1's `«续之对则类类等数»` reads equal count in every
class of the trait from this pairing. -/
theorem exact_pairs {ps : List α} {kids : α → List α} {a b : α → Nat}
    (exact : SelectionTerm.Exact ps kids a b) :
    «对» («续» (descent ps kids) (alike (trait a b))) (before kids ps) (after kids ps) :=
  pairs_all kids ps fun p mp k mk =>
    (exact_iff_continues ps kids a b).mp exact (false, p) (true, k) ⟨p, k, rfl, rfl, mp, mk⟩

/-- **Exact transmission gives a pairing under the class**: `«对之单调»` drops continuation to
the class, so the first strength gives the second without lever 1's tree. -/
theorem exact_paired_class {ps : List α} {kids : α → List α} {a b : α → Nat}
    (exact : SelectionTerm.Exact ps kids a b) :
    «对» (alike (trait a b)) (before kids ps) (after kids ps) :=
  «对之单调» (fun _ _ r => r.2) (exact_pairs exact)

/-! ### From a pairing under the class to the totals -/

theorem total_app {β : Type} (f : β → Nat) : ∀ xs ys : List β, total (xs ++ ys) f = total xs f + total ys f
  | [], _ => (Nat.zero_add _).symm
  | x :: xs, ys => (congrArg (f x + ·) (total_app f xs ys)).trans (Nat.add_assoc _ _ _).symm

theorem total_insert {β : Type} (f : β → Nat) (y : β) (b₂ : List β) :
    ∀ b₁ : List β, total (b₁ ++ y :: b₂) f = f y + total (b₁ ++ b₂) f
  | [] => rfl
  | z :: b₁ => (congrArg (f z + ·) (total_insert f y b₂ b₁)).trans (Nat.add_left_comm _ _ _)

/-- **A pairing under sameness of a reading keeps its total.** -/
theorem total_of_paired {β : Type} (f : β → Nat) {a b : List β} (h : «对» (fun u v => f u = f v) a b) :
    total a f = total b f := by
  induction h with
  | nil => rfl
  | @cons x y a' b₁ b₂ r _ ih =>
    exact (congrArg (· + total a' f) r).trans
      ((congrArg (f y + ·) ih).trans (total_insert f y b₂ b₁).symm)

theorem total_before (a b : α → Nat) (p : α) :
    ∀ ks : List α, total (ks.map (fun _ => (false, p))) (trait a b) = ks.length * a p
  | [] => (Nat.zero_mul _).symm
  | _ :: ks => (congrArg (a p + ·) (total_before a b p ks)).trans
      ((Nat.add_comm _ _).trans (Nat.succ_mul _ _).symm)

theorem total_after (a b : α → Nat) :
    ∀ ks : List α, total (ks.map (fun k => (true, k))) (trait a b) = total ks b
  | [] => rfl
  | k :: ks => congrArg (b k + ·) (total_after a b ks)

theorem add_congr {a b c d : Nat} (h₁ : a = b) (h₂ : c = d) : a + c = b + d := h₁ ▸ h₂ ▸ rfl

theorem selected_eq (kids : α → List α) (a b : α → Nat) :
    ∀ ps : List α, total (before kids ps) (trait a b) = selected ps kids a
  | [] => rfl
  | p :: ps => (total_app _ _ _).trans
      (add_congr (total_before a b p (kids p)) (selected_eq kids a b ps))

theorem offspring_eq (kids : α → List α) (a b : α → Nat) :
    ∀ ps : List α, total (after kids ps) (trait a b) = offspring ps kids b
  | [] => rfl
  | p :: ps => (total_app _ _ _).trans
      (add_congr (total_after a b (kids p)) (offspring_eq kids a b ps))

/-- **Equal count in every class gives equal totals.** Where the parents, once for every
offspring, are paired with the offspring under sameness of the trait, the offspring's total is
the parents' amounts weighted by offspring number. -/
theorem totals_of_paired {ps : List α} {kids : α → List α} {a b : α → Nat}
    (paired : «对» (alike (trait a b)) (before kids ps) (after kids ps)) :
    offspring ps kids b = selected ps kids a :=
  (offspring_eq kids a b ps).symm.trans
    ((total_of_paired (trait a b) paired).symm.trans (selected_eq kids a b ps))

/-- **Equal totals are the two transmission terms cancelling.** By Price's equation in counting
form, the offspring's total is the weighted total exactly where what transmission raised equals
what it lowered: the terms cancel, which is not that they vanish. -/
theorem totals_iff_cancel (ps : List α) (kids : α → List α) (a b : α → Nat) :
    offspring ps kids b = selected ps kids a ↔ raised ps kids a b = lowered ps kids a b :=
  ⟨fun same => by
     have p := price ps kids a b
     rw [same] at p
     exact (Naturals.add_left_cancel p).symm,
   fun cancel => by
     have p := price ps kids a b
     rw [cancel] at p
     exact Naturals.add_right_cancel p⟩

theorem beq_self : ∀ n : Nat, Nat.beq n n = true
  | 0 => rfl
  | n + 1 => beq_self n

theorem eq_of_beq : ∀ {m n : Nat}, Nat.beq m n = true → m = n
  | 0, 0, _ => rfl
  | 0, _ + 1, h => Bool.noConfusion (h : false = true)
  | _ + 1, 0, h => Bool.noConfusion (h : false = true)
  | _ + 1, _ + 1, h => congrArg Nat.succ (eq_of_beq h)

/-- The trait's class is decided by a test, as lever 1's count law asks. (`Nat.beq_refl` and
`Nat.eq_of_beq_eq_true` report `propext`, so the two directions are proved here.) -/
theorem alike_decided (f : Occ α → Nat) (u v : Occ α) :
    alike f u v ↔ Nat.beq (f u) (f v) = true :=
  ⟨fun same => same ▸ beq_self (f u), eq_of_beq⟩

/-! Equal count in every class without exactness: two parents whose offspring swap amounts. -/

namespace Swap

def ps : List Bool := [false, true]

def kids : Bool → List Bool := fun p => [p]

def a : Bool → Nat := fun p => cond p 2 1

def b : Bool → Nat := fun k => cond k 1 2

/-- The parents, once for every offspring, are paired with the offspring under sameness of the
trait: by lever 1's count law, every class holds as many of the one as of the other. -/
theorem paired : «对» (alike (trait a b)) (before kids ps) (after kids ps) :=
  show «对» (alike (trait a b)) [(false, false), (false, true)] [(true, false), (true, true)] from
    .cons (b₁ := [(true, false)]) (b₂ := []) rfl (.cons (b₁ := []) (b₂ := []) rfl .nil)

/-- Yet transmission is not exact: the amounts change places. -/
theorem not_exact : ¬ SelectionTerm.Exact ps kids a b := fun exact =>
  absurd (exact false (List.Mem.head _) false (List.Mem.head _)) (by decide)

/-- The transmission terms cancel without vanishing: each is one. -/
theorem terms : raised ps kids a b = 1 ∧ lowered ps kids a b = 1 := ⟨by decide, by decide⟩

end Swap

namespace Unexact

/-- One for an occurrence whose trait is one, none otherwise. -/
def atOne : Occ Bool → Nat := fun u => cond (Nat.beq (trait a b u) 1) 1 0

end Unexact

/-- **`Unexact` has equal totals and no pairing under the class**: the class of trait one holds
the parent twice before the step and nothing after it, while a pairing under the class keeps the
total of every reading constant on its classes (`total_of_paired`). -/
theorem unexact_not_paired :
    ¬ «对» (alike (trait Unexact.a Unexact.b)) (before Unexact.kids Unexact.ps)
      (after Unexact.kids Unexact.ps) := fun paired =>
  absurd (total_of_paired Unexact.atOne («对之单调»
      (fun u v (same : trait Unexact.a Unexact.b u = trait Unexact.a Unexact.b v) =>
        congrArg (fun n => cond (Nat.beq n 1) 1 0) same) paired)) (by decide)

/-! ## The hypothesis cannot be dropped: without it the levels law fails -/

/-- One parent with none of the amount and one offspring carrying one: transmission raised. -/
def Raised : SelectionTerm.Generations Bool where
  first := [false]
  kids _ p := cond p [] [true]
  amount _ p := cond p 1 0

namespace Raised

/-- One group of one. -/
def groups : List (List Bool) := [[false]]

theorem listed : SelectionLevels.whole groups = Raised.family 0 := rfl

theorem equal : ∀ g, g ∈ groups → g.length = 1 := fun g (mem : g ∈ [[false]]) =>
  match g, mem with
  | _, .head _ => rfl
  | _, .tail _ rest => nomatch rest

theorem not_exact :
    ¬ SelectionTerm.Exact (Raised.family 0) (Raised.kids 0) (Raised.amount 0) (Raised.amount 1) :=
  fun exact => absurd (exact false (List.Mem.head _) true (List.Mem.head _)) (by decide)

/-- The mean rises across the step. -/
theorem raises : Raised.Raises 0 := by decide

/-- The levels' side is false: one group of one has no concordance or discordance. -/
theorem levels_false :
    ¬ (groups.length * SelectionLevels.discordWithin groups (Raised.offspringNumber 0)
          (Raised.amount 0) +
        SelectionLevels.discordAmong groups (Raised.offspringNumber 0) (Raised.amount 0) <
      groups.length * SelectionLevels.concordWithin groups (Raised.offspringNumber 0)
          (Raised.amount 0) +
        SelectionLevels.concordAmong groups (Raised.offspringNumber 0) (Raised.amount 0)) := by
  decide

/-- **Without its hypothesis the levels law fails**: the mean rises while the levels' side is
false, so `SelectionLevels.rises_exact_iff_levels` cannot drop its hypothesis. The weakest
hypothesis it needs is the terms cancelling (`rises_cancel_iff_levels`), which fails here too
(`not_cancel`). -/
theorem levels_fail :
    ¬ (Raised.Raises 0 ↔
      groups.length * SelectionLevels.discordWithin groups (Raised.offspringNumber 0)
          (Raised.amount 0) +
        SelectionLevels.discordAmong groups (Raised.offspringNumber 0) (Raised.amount 0) <
      groups.length * SelectionLevels.concordWithin groups (Raised.offspringNumber 0)
          (Raised.amount 0) +
        SelectionLevels.concordAmong groups (Raised.offspringNumber 0) (Raised.amount 0)) :=
  fun same => levels_false (same.mp raises)

/-- Nor do the transmission terms cancel here: transmission raised one and lowered nothing. -/
theorem not_cancel : Raised.raisedAt 0 ≠ Raised.loweredAt 0 := by decide

end Raised

/-! ## Cancellation is all the levels law uses -/

theorem lt_iff_add_lt {n m : Nat} (k : Nat) : n + k < m + k ↔ n < m :=
  ⟨fun h => Naturals.le_of_add_le_add_right (Nat.le_trans (Nat.le_of_eq (Nat.succ_add n k)) h),
   fun h => Nat.le_trans (Nat.le_of_eq (Nat.succ_add n k).symm) (Nat.add_le_add_right h k)⟩

/-- **Where the transmission terms cancel, the mean rises exactly where concordance exceeds
discordance.** `SelectionTerm.Generations.raises_exact_iff` uses exact transmission only for
this. -/
theorem rises_cancel_iff (G : SelectionTerm.Generations α) {t : Nat}
    (cancel : G.raisedAt t = G.loweredAt t) : G.Raises t ↔ G.discordAt t < G.concordAt t := by
  show G.size t * G.loweredAt t + G.discordAt t < G.concordAt t + G.size t * G.raisedAt t ↔ _
  rw [cancel, Nat.add_comm (G.size t * G.loweredAt t)]
  exact lt_iff_add_lt _

/-- Exact transmission makes the terms cancel, both being zero. -/
theorem cancel_of_exact {G : SelectionTerm.Generations α} {t : Nat}
    (exact : SelectionTerm.Exact (G.family t) (G.kids t) (G.amount t) (G.amount (t + 1))) :
    G.raisedAt t = G.loweredAt t :=
  (SelectionTerm.raised_exact exact).trans (SelectionTerm.lowered_exact exact).symm

/-- **Row 13 at its weakest hypothesis**: `SelectionLevels.rises_exact_iff_levels` with exact
transmission weakened to the terms cancelling, equivalently equal totals (`totals_iff_cancel`). -/
theorem rises_cancel_iff_levels (G : SelectionTerm.Generations α) {t m : Nat}
    (gs : List (List α)) (listing : SelectionLevels.whole gs = G.family t)
    (equal : ∀ g, g ∈ gs → g.length = m) (cancel : G.raisedAt t = G.loweredAt t) :
    G.Raises t ↔
      gs.length * SelectionLevels.discordWithin gs (G.offspringNumber t) (G.amount t) +
          SelectionLevels.discordAmong gs (G.offspringNumber t) (G.amount t) <
        gs.length * SelectionLevels.concordWithin gs (G.offspringNumber t) (G.amount t) +
          SelectionLevels.concordAmong gs (G.offspringNumber t) (G.amount t) :=
  (rises_cancel_iff G cancel).trans (by
    unfold SelectionTerm.Generations.concordAt SelectionTerm.Generations.discordAt
    rw [← listing]
    exact SelectionLevels.rises_iff gs _ _ equal)

/-! ## The gate as an inclusion of relations -/

/-- Giving at a step, read by its sign: `g` takes part and gives to `x`. -/
def gives (L : Flow X X) (t : Nat) : «际» X := fun g x => g ∈ L.present t ∧ 0 < L.give t g x

/-- Activity at a step as a partial identity. -/
def activeAt (W : Web X X) (t : Nat) : «际» X := fun x y => x = y ∧ W.active t x

/-- Listed descent at a step: `p` is listed and `k` is among its listed offspring. -/
def listed (G : SelectionTerm.Generations X) (t : Nat) : «际» X :=
  fun p k => p ∈ G.family t ∧ k ∈ G.kids t p

/-- **"Only active formations give" is an inclusion**: at every step, giving lies within giving
from an active formation. -/
theorem acting_iff {L : Flow X X} {W : Web X X} :
    L.Acting W ↔ ∀ t, «则» (gives L t) («而» (activeAt W t) (gives L t)) :=
  ⟨fun acting t g x gx => ⟨g, ⟨rfl, acting t g x gx.1 gx.2⟩, gx⟩,
   fun incl t f c present pos => match incl t f c ⟨present, pos⟩ with
     | ⟨_, ⟨rfl, act⟩, _⟩ => act⟩

/-- Listed descent lies within giving, where the generations are generations of descent. -/
theorem listed_within_gives {L : Flow X X} {W : Web X X} {G : SelectionTerm.Generations X}
    (descended : SelectionTerm.Flow.Descended L W G) (t : Nat) :
    «则» (listed G t) (gives L t) :=
  fun p k ⟨mp, mk⟩ => ⟨(descended t p k mp mk).1, (descended t p k mp mk).2.1⟩

/-- A list with no member is empty. -/
theorem length_zero_of_none : ∀ {ks : List α}, (∀ k, ¬ k ∈ ks) → ks.length = 0
  | [], _ => rfl
  | k :: _, empty => absurd (List.Mem.head _) (empty k)

/-- **From two inclusions, no offspring of the inactive**: where listed descent lies within
giving and giving within giving from an active formation, a generation whose members are all
inactive has no offspring. -/
theorem size_zero_of_within {L : Flow X X} {W : Web X X} {G : SelectionTerm.Generations X}
    {t : Nat} (acting : «则» (gives L t) («而» (activeAt W t) (gives L t)))
    (descended : «则» (listed G t) (gives L t))
    (inactive : ∀ p, p ∈ G.family t → ¬ W.active t p) : G.size (t + 1) = 0 :=
  (G.born_eq t).symm.trans (SelectionTerm.total_zero_of fun p mp =>
    length_zero_of_none fun k mk => match acting p k (descended p k ⟨mp, mk⟩) with
      | ⟨_, ⟨rfl, act⟩, _⟩ => inactive p mp act)

/-- `GroupEnding.Flow.all_end`, read on the root: its hypotheses enter only as the two
inclusions. -/
theorem all_end_on_root {L : Flow X X} {W : Web X X} (acting : L.Acting W)
    {G : SelectionTerm.Generations X} (descended : SelectionTerm.Flow.Descended L W G) {t : Nat}
    (inactive : ∀ p, p ∈ G.family t → ¬ W.active t p) : G.size (t + 1) = 0 :=
  size_zero_of_within (acting_iff.mp acting t) (listed_within_gives descended t) inactive

/-! **The gate cannot be dropped from row 17**: a formation not active gives, its offspring come
to stand, and the generation after an inactive one is not empty. -/
namespace Ungated

def web : Web Bool Bool where
  level t _ := t
  active _ _ := False
  requires _ _ _ := False
  need _ _ _ := 0
  draws _ _ _ := False

def flow : Flow Bool Bool where
  present _ := [false, true]
  take _ _ _ := 0
  give _ _ _ := 1

def gens : SelectionTerm.Generations Bool where
  first := [false]
  kids t _ := match t with
    | 0 => [true]
    | _ + 1 => []
  amount _ _ := 0

theorem present_all : ∀ p : Bool, p ∈ ([false, true] : List Bool)
  | false => .head _
  | true => .tail _ (.head _)

theorem descended : SelectionTerm.Flow.Descended flow web gens := fun t p k _ mk =>
  match t, mk with
  | 0, _ => ⟨present_all p, Nat.zero_lt_one, Nat.lt_irrefl 0, Nat.zero_lt_one⟩
  | _ + 1, m => nomatch (m : k ∈ ([] : List Bool))

theorem inactive : ∀ p, p ∈ gens.family 0 → ¬ web.active 0 p := fun _ _ act => act

theorem not_ended : gens.size 1 = 1 := rfl

theorem not_acting : ¬ flow.Acting web := fun acting =>
  acting 0 false true (.head _) Nat.zero_lt_one

/-- Every hypothesis of `GroupEnding.Flow.all_end` but the gate holds, and its conclusion fails. -/
theorem gate_needed : SelectionTerm.Flow.Descended flow web gens ∧
    (∀ p, p ∈ gens.family 0 → ¬ web.active 0 p) ∧ gens.size 1 ≠ 0 ∧ ¬ flow.Acting web :=
  ⟨descended, inactive, fun zero => Nat.noConfusion (not_ended.symm.trans zero), not_acting⟩

end Ungated

/-- Over generations, a member not active has no offspring, from the two inclusions alone
(`GroupEnding.Flow.offspring_zero`'s content). -/
theorem offspring_zero_within {L : Flow X X} {W : Web X X} {G : SelectionTerm.Generations X}
    {t : Nat} (acting : «则» (gives L t) («而» (activeAt W t) (gives L t)))
    (descended : «则» (listed G t) (gives L t)) {p : X} (mp : p ∈ G.family t)
    (inactive : ¬ W.active t p) : G.offspringNumber t p = 0 :=
  length_zero_of_none fun k mk => match acting p k (descended p k ⟨mp, mk⟩) with
    | ⟨_, ⟨rfl, act⟩, _⟩ => inactive act

/-- Where the groups with less of the amount are not active, they leave nothing, from the two
inclusions (`GroupEnding.Flow.ended_of_inactive`'s content). -/
theorem ended_within {L : Flow X X} {W : Web X X} {G : SelectionTerm.Generations X} {t : Nat}
    (acting : «则» (gives L t) («而» (activeAt W t) (gives L t)))
    (descended : «则» (listed G t) (gives L t)) {gs : List (List X)}
    (listing : SelectionLevels.whole gs = G.family t) {a : X → Nat}
    (inactive : ∀ g h, g ∈ gs → h ∈ gs → total h a < total g a → ∀ p, p ∈ h → ¬ W.active t p) :
    GroupEnding.Ended gs (G.offspringNumber t) a :=
  fun g h mg mh less => SelectionTerm.total_zero_of fun p mp =>
    offspring_zero_within acting descended (listing ▸ GroupEnding.mem_whole mh mp)
      (inactive g h mg mh less p mp)

/-- **Row 14 on the root**: `GroupEnding.Flow.rises_iff_inactive` with the gate and descent as
the two inclusions and exact transmission weakened to the terms cancelling. Its `inactive`
hypothesis compares sums of the trait, so it is not an inclusion. -/
theorem rises_iff_inactive_on_root {L : Flow X X} {W : Web X X}
    {G : SelectionTerm.Generations X} {t m : Nat}
    (acting : «则» (gives L t) («而» (activeAt W t) (gives L t)))
    (descended : «则» (listed G t) (gives L t)) (gs : List (List X))
    (listing : SelectionLevels.whole gs = G.family t) (equal : ∀ g, g ∈ gs → g.length = m)
    (cancel : G.raisedAt t = G.loweredAt t)
    (inactive : ∀ g h, g ∈ gs → h ∈ gs → total h (G.amount t) < total g (G.amount t) →
      ∀ p, p ∈ h → ¬ W.active t p) :
    G.Raises t ↔
      gs.length * SelectionLevels.discordWithin gs (G.offspringNumber t) (G.amount t) <
        gs.length * SelectionLevels.concordWithin gs (G.offspringNumber t) (G.amount t) +
          SelectionLevels.concordAmong gs (G.offspringNumber t) (G.amount t) := by
  have h := rises_cancel_iff_levels G gs listing equal cancel
  rw [GroupEnding.among_not_against (ended_within acting descended listing inactive),
    Nat.add_zero] at h
  exact h

/-! ## Row 5: what comes to stand is given to -/

/-- **Row 5 under an inclusion**: where coming to stand lies within being given to by something
taking part, with inheritance at the descents and nothing taking part depending on `c`, nothing
coming to stand depends on `c` after the step. -/
theorem no_new_dependence_of_given {L : Flow X X} {W : Web X X} {t : Nat} {x c : X}
    (given : W.ComesToStand t x → ∃ g, L.DescendsAt W t x g)
    (inherits : ∀ g, L.DescendsAt W t x g → W.InheritsAt t x g c)
    (none : ∀ g, g ∈ L.present t → ¬ W.requires t g c) (comes : W.ComesToStand t x) :
    ¬ W.requires (t + 1) x c :=
  fun depends => match given comes with
    | ⟨g, descends⟩ => none g descends.1 (inherits g descends depends)

/-- Balance at the relatum is one way to meet the inclusion (`Flow.descends_of_comes`), and it
gives `Flow.no_new_dependence` back. -/
theorem no_new_dependence_from_balance {L : Flow X X} {W : Web X X} {t : Nat} {x c : X}
    (balances : W.level (t + 1) x + L.taken t x = W.level t x + L.given t x)
    (inherits : ∀ g, L.DescendsAt W t x g → W.InheritsAt t x g c)
    (none : ∀ g, g ∈ L.present t → ¬ W.requires t g c) (comes : W.ComesToStand t x) :
    ¬ W.requires (t + 1) x c :=
  no_new_dependence_of_given (Flow.descends_of_comes balances) inherits none comes

/-! **The inclusion cannot be dropped from row 5**: something comes to stand with nothing taking
part, and depends on a condition after the step that nothing held before it. -/
namespace Ungiven

def web : Web Bool Bool where
  level t _ := t
  active _ _ := False
  requires t f _ := t = 1 ∧ f = true
  need _ _ _ := 0
  draws _ _ _ := False

def flow : Flow Bool Bool where
  present _ := []
  take _ _ _ := 0
  give _ _ _ := 0

theorem comes : web.ComesToStand 0 true := ⟨Nat.lt_irrefl 0, Nat.zero_lt_one⟩

theorem inherits : ∀ g, flow.DescendsAt web 0 true g → web.InheritsAt 0 true g false :=
  fun g descends => nomatch (descends.1 : g ∈ ([] : List Bool))

theorem none : ∀ g, g ∈ flow.present 0 → ¬ web.requires 0 g false :=
  fun g mem => nomatch (mem : g ∈ ([] : List Bool))

theorem depends : web.requires 1 true false := ⟨rfl, rfl⟩

theorem not_given : ¬ (web.ComesToStand 0 true → ∃ g, flow.DescendsAt web 0 true g) :=
  fun given => match given comes with
    | ⟨g, descends⟩ => nomatch (descends.1 : g ∈ ([] : List Bool))

end Ungiven

end U4LeverTwo

end Becoming
