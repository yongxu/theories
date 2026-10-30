import Becoming.Grammar
import Becoming.SelectionLevels
import Becoming.GroupEnding

/-!
# U4, lever 2 (scratch): evolution's rows read on the root

Scratch for the audit `../LEVER-2-AUDIT.md`, not package Lean. It checks four readings the
audit leans on.

* **Exact transmission is continuation under the trait's class.** Read one step of descent on
  occurrences (a parent before the step, an offspring after it), with descent as condition (the
  parent is among what the offspring comes from) and the trait as a map to `Nat`. Each offspring
  carries its parent's amount (`SelectionTerm.Exact`) exactly where descent lies within sameness
  under the trait (`exact_iff_within`), so exactly where descent lies within its own continuation
  under that class (`exact_iff_continues`). The two transmission terms of Price's equation in
  counting form both vanish exactly there (`exact_iff_terms_vanish`), and then the offspring's
  total is the parents' amounts weighted by offspring number (`offspring_eq_selected_of_within`).
  Equal totals do not give exactness (`Unexact.totals_alike`, `Unexact.not_exact`): the class
  reading is pointwise.
* **Three strengths, and where lever 1's count law sits.** Exact transmission pairs the parents,
  once for every offspring, with the offspring under continuation relative to the trait's class
  (`exact_pairs`), so, by lever 1's `«续之对则类类等数»`, every class of the trait holds as many
  of the one as of the other. A pairing under the class gives equal totals (`totals_of_paired`),
  and equal totals are exactly the two transmission terms cancelling (`totals_iff_cancel`).
  Neither step reverses: `Swap` is paired under the class and not exact, its terms each one
  (`Swap.paired`, `Swap.not_exact`, `Swap.terms`); `Unexact` has equal totals with offspring at
  none and two against a parent at one.
* **The hypothesis is needed.** Where transmission is not exact, the levels law of
  `SelectionLevels.rises_exact_iff_levels` fails: in `Raised`, one parent and one offspring that
  carries more, the mean rises while the levels' side is false (`Raised.levels_fail`).
* **The gate is an inclusion of relations.** "Only active formations give" (`Flow.Acting`) is
  exactly that giving, at every step, lies within giving from an active formation
  (`acting_iff`), and listed descent lies within giving (`listed_within_gives`). From these two
  inclusions alone a generation whose members are all inactive has no offspring
  (`size_zero_of_within`), which is `GroupEnding.Flow.all_end` read on the root
  (`all_end_on_root`).

Modelling choices, stated: one step of descent at a time, read on `Bool × α`; amounts and traits
are natural numbers; listing is by `List`. Nothing here touches the World's levels, so the rows
that read them wait on lever 1.
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

/-! ## The hypothesis is needed: inexact transmission breaks the levels law -/

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

/-- **Without exact transmission the levels law fails**: the mean rises while the levels' side
is false, so `SelectionLevels.rises_exact_iff_levels` needs its hypothesis. -/
theorem levels_fail :
    ¬ (Raised.Raises 0 ↔
      groups.length * SelectionLevels.discordWithin groups (Raised.offspringNumber 0)
          (Raised.amount 0) +
        SelectionLevels.discordAmong groups (Raised.offspringNumber 0) (Raised.amount 0) <
      groups.length * SelectionLevels.concordWithin groups (Raised.offspringNumber 0)
          (Raised.amount 0) +
        SelectionLevels.concordAmong groups (Raised.offspringNumber 0) (Raised.amount 0)) :=
  fun same => levels_false (same.mp raises)

end Raised

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

end U4LeverTwo

end Becoming
