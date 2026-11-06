import Becoming.Locality
import Becoming.Resolution

/-!
# Imbalance: counted as a relatum

Ren, 11 October 2026, on the zero-premise plan's re-founding that counts an imbalance as a
relatum: “please”, to the suggestion that it first be proved as a representation equivalent to the
current one, adoption staying with Ren. This module states the construction and proves the
equivalence, with no premise.

Across a step, a condition's level changes by what the flow gives it and takes from it exactly
where the flow balances there. Wherever it does not, count the difference as the exchange of one
more relatum, `none`: it gives each condition what its level rose beyond the flow's net exchange,
and takes what its level fell beyond it (`Flow.withImbalance`). The web is read with that relatum
inert, never active and requiring nothing, as for the refinement of `Becoming.Resolution`
(`Web.withRefinement`).

* **Balance by construction.** With the imbalance counted, every flow balances at every step and
  condition (`Flow.withImbalance_balances`), so on every family (`Flow.withImbalance_balancesOn`).
* **The condition moves.** The flow balances on a family across a step exactly where the added
  relatum neither gives nor takes on its members there (`Flow.balancesOn_iff_idle`), and balances
  everywhere exactly where it is idle everywhere (`Flow.balances_iff_idle`).
* **The two representations are equivalent, step by step.** At a step and condition, in the
  extended flow only active relata give exactly where only active relata give in the flow and the
  level does not rise beyond the flow's net exchange (`Flow.withImbalance_acting_at_iff`), and only
  active relata take, and only what they draw on, exactly where they do so in the flow and the
  level does not fall beyond it (`Flow.withImbalance_taking_at_iff`). So on a family across a step
  both hold of the extended flow exactly where both hold of the flow and it balances there
  (`Flow.withImbalance_acting_taking_on_iff`, on `Flow.BalancesOn`); the forms over every step
  and condition are corollaries (`Flow.withImbalance_acting_iff`, `Flow.withImbalance_taking_iff`,
  `Flow.withImbalance_acting_taking_iff`). Counting the imbalance turns balance into the activity
  premises at the added relatum: it adds nothing and removes nothing.

**AI reading, adopted by Ren with the re-founding on 14 October 2026.** With the imbalance counted,
balance is a property of the representation, and what it said of a world is said instead by the
inactivity of one relatum. Ren adopted the re-founding on 14 October 2026 (“please, finish all”);
the laws of the core keep balance as a local condition (`Flow.BalancesOn`).
-/

namespace Becoming

variable {F C : Type}

/-- A member of a list mapped into options came from the list. -/
theorem mem_of_some_mem {α : Type} {a : α} : ∀ {l : List α}, some a ∈ l.map some → a ∈ l
  | _ :: _, .head _ => .head _
  | _ :: _, .tail _ member => .tail _ (mem_of_some_mem member)

namespace Flow

/-- The flow with the imbalance counted. One more relatum takes part, `none`: across the step
from `t` it gives each condition what its level rose beyond what the flow gave it net, and takes
what its level fell beyond what the flow took net. The flow's own relata are the others. -/
def withImbalance (L : Flow F C) (W : Web F C) : Flow (Option F) C :=
  ⟨fun t => none :: (L.present t).map some,
   fun t f c => match f with
     | none => W.level t c + L.given t c - (W.level (t + 1) c + L.taken t c)
     | some g => L.take t g c,
   fun t f c => match f with
     | none => W.level (t + 1) c + L.taken t c - (W.level t c + L.given t c)
     | some g => L.give t g c⟩

variable {L : Flow F C} {W : Web F C}

/-- With the imbalance counted, what is taken from a condition is what the added relatum takes
together with what the flow takes. -/
theorem withImbalance_taken (t : Nat) (c : C) :
    (L.withImbalance W).taken t c =
      W.level t c + L.given t c - (W.level (t + 1) c + L.taken t c) + L.taken t c :=
  congrArg (W.level t c + L.given t c - (W.level (t + 1) c + L.taken t c) + ·)
    (total_map_some _ _)

/-- With the imbalance counted, what is given to a condition is what the added relatum gives
together with what the flow gives. -/
theorem withImbalance_given (t : Nat) (c : C) :
    (L.withImbalance W).given t c =
      W.level (t + 1) c + L.taken t c - (W.level t c + L.given t c) + L.given t c :=
  congrArg (W.level (t + 1) c + L.taken t c - (W.level t c + L.given t c) + ·)
    (total_map_some _ _)

/-- Balance by construction. With the imbalance counted, every flow balances. -/
theorem withImbalance_balances : (L.withImbalance W).Balances W.withRefinement := fun t c =>
  calc W.level (t + 1) c + (L.withImbalance W).taken t c
      = W.level (t + 1) c + (W.level t c + L.given t c - (W.level (t + 1) c + L.taken t c)
          + L.taken t c) := congrArg _ (withImbalance_taken t c)
    _ = W.level (t + 1) c + L.taken t c
          + (W.level t c + L.given t c - (W.level (t + 1) c + L.taken t c)) :=
        (congrArg (W.level (t + 1) c + ·) (Nat.add_comm _ _)).trans (Nat.add_assoc _ _ _).symm
    _ = W.level t c + L.given t c
          + (W.level (t + 1) c + L.taken t c - (W.level t c + L.given t c)) := add_sub_turn _ _
    _ = W.level t c + (W.level (t + 1) c + L.taken t c - (W.level t c + L.given t c)
          + L.given t c) :=
        (Nat.add_assoc _ _ _).trans (congrArg (W.level t c + ·) (Nat.add_comm _ _))
    _ = W.level t c + (L.withImbalance W).given t c := congrArg _ (withImbalance_given t c).symm

/-- With the imbalance counted, the flow balances on every family across every step. -/
theorem withImbalance_balancesOn (cs : List C) (t : Nat) :
    (L.withImbalance W).BalancesOn W.withRefinement cs t :=
  withImbalance_balances.on cs t

/-- The condition moves. The flow balances on a family across a step exactly where the added
relatum neither gives nor takes on its members there. -/
theorem balancesOn_iff_idle {cs : List C} {t : Nat} :
    L.BalancesOn W cs t ↔ ∀ c, c ∈ cs →
      (L.withImbalance W).give t none c = 0 ∧ (L.withImbalance W).take t none c = 0 :=
  ⟨fun balances c member => ⟨sub_eq_zero_of_le (Nat.le_of_eq (balances c member)),
     sub_eq_zero_of_le (Nat.le_of_eq (balances c member).symm)⟩,
   fun idle c member => Nat.le_antisymm (le_of_sub_eq_zero (idle c member).1)
     (le_of_sub_eq_zero (idle c member).2)⟩

/-- The flow balances exactly where the added relatum is idle at every step and condition: the
family form at every step. -/
theorem balances_iff_idle :
    L.Balances W ↔ ∀ t c,
      (L.withImbalance W).give t none c = 0 ∧ (L.withImbalance W).take t none c = 0 :=
  ⟨fun balances t c => (balancesOn_iff_idle (cs := [c])).mp (balances.on [c] t) c (.head _),
   fun idle t c => (balancesOn_iff_idle (cs := [c])).mpr (fun c' _ => idle t c') c (.head _)⟩

/-- Locally, at a step and condition: in the extended flow only active relata give to `c` across
the step from `t` exactly where only active relata give to it in the flow and its level does not
rise there beyond the flow's net exchange. -/
theorem withImbalance_acting_at_iff {t : Nat} {c : C} :
    (∀ f, f ∈ (L.withImbalance W).present t → 0 < (L.withImbalance W).give t f c →
        W.withRefinement.active t f) ↔
      (∀ g, g ∈ L.present t → 0 < L.give t g c → W.active t g) ∧
        W.level (t + 1) c + L.taken t c ≤ W.level t c + L.given t c :=
  ⟨fun acting => ⟨fun g member gives => acting (some g) (.tail _ (mem_map_some member)) gives,
     le_of_sub_eq_zero (eq_zero_of_not_pos fun pos => acting none (.head _) pos)⟩,
   fun ⟨acting, within⟩ f member gives => match f, member, gives with
     | none, _, gives => absurd gives (Nat.not_lt_of_le (Nat.le_of_eq (sub_eq_zero_of_le within)))
     | some _, .tail _ member, gives => acting _ (mem_of_some_mem member) gives⟩

/-- Locally, at a step and condition: in the extended flow only active relata take from `c` across
the step from `t`, and only where they draw on it, exactly where they do so in the flow and its
level does not fall there beyond the flow's net exchange. -/
theorem withImbalance_taking_at_iff {t : Nat} {c : C} :
    (∀ f, f ∈ (L.withImbalance W).present t → 0 < (L.withImbalance W).take t f c →
        W.withRefinement.active t f ∧ W.withRefinement.draws t f c) ↔
      (∀ g, g ∈ L.present t → 0 < L.take t g c → W.active t g ∧ W.draws t g c) ∧
        W.level t c + L.given t c ≤ W.level (t + 1) c + L.taken t c :=
  ⟨fun taking => ⟨fun g member takes => taking (some g) (.tail _ (mem_map_some member)) takes,
     le_of_sub_eq_zero (eq_zero_of_not_pos fun pos => (taking none (.head _) pos).1)⟩,
   fun ⟨taking, within⟩ f member takes => match f, member, takes with
     | none, _, takes => absurd takes (Nat.not_lt_of_le (Nat.le_of_eq (sub_eq_zero_of_le within)))
     | some _, .tail _ member, takes => taking _ (mem_of_some_mem member) takes⟩

/-- The two representations are equivalent on a family across a step. With the imbalance counted,
only active relata give to and take from its members there, and only what they draw on, exactly
where in the flow they do and the flow balances on the family there (`Flow.BalancesOn`). -/
theorem withImbalance_acting_taking_on_iff {cs : List C} {t : Nat} :
    (∀ c, c ∈ cs →
      (∀ f, f ∈ (L.withImbalance W).present t → 0 < (L.withImbalance W).give t f c →
        W.withRefinement.active t f) ∧
      (∀ f, f ∈ (L.withImbalance W).present t → 0 < (L.withImbalance W).take t f c →
        W.withRefinement.active t f ∧ W.withRefinement.draws t f c)) ↔
      (∀ c, c ∈ cs →
        (∀ g, g ∈ L.present t → 0 < L.give t g c → W.active t g) ∧
        (∀ g, g ∈ L.present t → 0 < L.take t g c → W.active t g ∧ W.draws t g c)) ∧
      L.BalancesOn W cs t :=
  ⟨fun both => ⟨fun c member => ⟨(withImbalance_acting_at_iff.mp (both c member).1).1,
       (withImbalance_taking_at_iff.mp (both c member).2).1⟩,
     fun c member => Nat.le_antisymm (withImbalance_acting_at_iff.mp (both c member).1).2
       (withImbalance_taking_at_iff.mp (both c member).2).2⟩,
   fun ⟨both, balances⟩ c member =>
     ⟨withImbalance_acting_at_iff.mpr ⟨(both c member).1, Nat.le_of_eq (balances c member)⟩,
      withImbalance_taking_at_iff.mpr ⟨(both c member).2, Nat.le_of_eq (balances c member).symm⟩⟩⟩

/-- In the extended flow only active relata give exactly where only active relata give in the
flow and no level rises beyond the flow's net exchange: the local form at every step and
condition. -/
theorem withImbalance_acting_iff : (L.withImbalance W).Acting W.withRefinement ↔
    L.Acting W ∧ ∀ t c, W.level (t + 1) c + L.taken t c ≤ W.level t c + L.given t c :=
  ⟨fun acting => ⟨fun t g c member gives =>
      (withImbalance_acting_at_iff.mp fun f => acting t f c).1 g member gives,
     fun t c => (withImbalance_acting_at_iff.mp fun f => acting t f c).2⟩,
   fun ⟨acting, within⟩ t f c =>
     withImbalance_acting_at_iff.mpr ⟨fun g => acting t g c, within t c⟩ f⟩

/-- In the extended flow only active relata take, and only what they draw on, exactly where they
do so in the flow and no level falls beyond the flow's net exchange: the local form at every step
and condition. -/
theorem withImbalance_taking_iff : (L.withImbalance W).Taking W.withRefinement ↔
    L.Taking W ∧ ∀ t c, W.level t c + L.given t c ≤ W.level (t + 1) c + L.taken t c :=
  ⟨fun taking => ⟨fun t g c member takes =>
      (withImbalance_taking_at_iff.mp fun f => taking t f c).1 g member takes,
     fun t c => (withImbalance_taking_at_iff.mp fun f => taking t f c).2⟩,
   fun ⟨taking, within⟩ t f c =>
     withImbalance_taking_at_iff.mpr ⟨fun g => taking t g c, within t c⟩ f⟩

/-- The two representations are equivalent. With the imbalance counted, only active relata give
and take, and only what they draw on, exactly where in the flow they do and the flow balances:
the family form at every step. -/
theorem withImbalance_acting_taking_iff :
    ((L.withImbalance W).Acting W.withRefinement ∧ (L.withImbalance W).Taking W.withRefinement) ↔
      (L.Acting W ∧ L.Taking W) ∧ L.Balances W :=
  ⟨fun ⟨acting, taking⟩ =>
    match withImbalance_acting_iff.mp acting, withImbalance_taking_iff.mp taking with
    | ⟨act, rises⟩, ⟨take, falls⟩ =>
      ⟨⟨act, take⟩, fun t c => Nat.le_antisymm (rises t c) (falls t c)⟩,
   fun ⟨⟨act, take⟩, balances⟩ =>
    ⟨withImbalance_acting_iff.mpr ⟨act, fun t c => Nat.le_of_eq (balances t c)⟩,
     withImbalance_taking_iff.mpr ⟨take, fun t c => Nat.le_of_eq (balances t c).symm⟩⟩⟩

end Flow

end Becoming
