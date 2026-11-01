import Becoming.BlanketCouplings
import Becoming.Testing

/-!
# Review probe for the UE28 design (scratch, not for landing)

AI-written by an independent reviewer, 1 November 2026. Checks, in the pure core:
(A) the coupling law's sensory part lags the external part by one step, so with a level as the
internal part, moved by the value of what couples in, its internal course is not the same-step
level history; a law whose sensory part's next state is the value at the external part's next
state gives the same-step history;
(B) the exchange form, pairwise and choice-free: at two steps alike on a condition's level in a
balanced history, the next levels agree exactly where the gross flows cross-sum alike;
(C) a formation fed by what does not couple into it, in a balanced world, whose read run is the
course of a blanketed law;
(D) a formation whose level moves through what couples in and its act but whose act does not:
not consistent part by part;
(E) the drain-only witness (one unit taken at every first phase, nothing given) has no level
history balanced at every step;
(F) a balanced periodic drain, the drainer's phase recorded as its own level: the agent's half
fails at steps 2 and 3, the world's half holds;
(G) a drain that stops when the formation's level is spent: the agent's half holds, the world's
half fails.
-/

namespace Becoming

namespace UE28ReviewProbe

open Blanket BlanketCouplings

/-! ## (A) The coupling law's sensory part lags one step -/

section Lag

variable {C O A X : Type} (own : Nat → O → A → Nat) (policy : Nat → O → A → A)
  (value : Nat → (C → Nat) → O) (lev : Nat → X → C → Nat) (env : O → A → Nat → X → X)

/-- The coupling law with the sensory part's next state the value at the external part's next
state, which it may compute: it reads the sensory and active parts and the external part. -/
def sameStepLaw : Blanketed Nat O A (Nat × X) where
  nextInternal m o a := own m o a
  nextSensory o a e := value (e.1 + 1) (lev (e.1 + 1) (env o a e.1 e.2))
  nextActive m o a := policy m o a
  nextExternal o a e := (e.1 + 1, env o a e.1 e.2)

/-- After the start, its sensory part is the value at the same configuration's external part. -/
theorem sameStep_sensory (x : Parts Nat O A (Nat × X)) (n : Nat) :
    ((sameStepLaw own policy value lev env).course x (n + 1)).sensory =
      value ((sameStepLaw own policy value lev env).course x (n + 1)).external.1
        (lev ((sameStepLaw own policy value lev env).course x (n + 1)).external.1
          ((sameStepLaw own policy value lev env).course x (n + 1)).external.2) :=
  rfl

end Lag

namespace LagWitness

/-- One condition; the value of what couples in is its level. -/
def value : Nat → (Unit → Nat) → Nat := fun _ l => l ()

def lev : Nat → Nat → Unit → Nat := fun _ x _ => x

/-- The condition's level flips between one and nothing. -/
def env : Nat → Unit → Nat → Nat → Nat := fun _ _ _ x => 1 - x

/-- The level adds the value of what couples in. -/
def own : Nat → Nat → Unit → Nat := fun m o _ => m + o

def policy : Nat → Nat → Unit → Unit := fun _ _ a => a

/-- The condition's levels: 1, 0, 1, 0, … -/
def flips : Nat → Nat
  | 0 => 1
  | n + 1 => 1 - flips n

/-- The same-step level history: after each step, the level with the condition's level at that
step added. -/
def sameStep : Nat → Nat
  | 0 => 0
  | n + 1 => sameStep n + flips n

/-- **The lag**: at step 2 the same-step history is 1, the coupling law's internal course 2 (its
sensory part holding the previous step's value), the same-step law's 1. -/
theorem lag :
    sameStep 2 = 1 ∧
      ((couplingLaw own policy value lev env).course (startAt 0 1 () 1) 2).internal = 2 ∧
      ((sameStepLaw own policy value lev env).course ⟨0, 1, (), (0, 1)⟩ 2).internal = 1 :=
  ⟨rfl, rfl, rfl⟩

end LagWitness

/-! ## (B) The exchange form, pairwise -/

section Exchange

variable {F C : Type} {L : Flow F C} {l : Nat → C → Nat}

/-- **At two steps alike on a condition's level, the next levels agree exactly where the gross
flows cross-sum alike**, in a balanced history: no subtraction, no choice. -/
theorem next_alike_iff_net_alike (history : L.BalancedHistory l) {g : C} {i j : Nat}
    (same : l i g = l j g) :
    l (i + 1) g = l (j + 1) g ↔ L.given i g + L.taken j g = L.given j g + L.taken i g :=
  ⟨fun next => Naturals.add_left_cancel (k := l i g)
    ((Nat.add_assoc (l i g) (L.given i g) (L.taken j g)).symm.trans
      ((congrArg (· + L.taken j g) (history i g).symm).trans
        ((congrArg (fun v => v + L.taken i g + L.taken j g) next).trans
          ((Nat.add_right_comm (l (j + 1) g) (L.taken i g) (L.taken j g)).trans
            ((congrArg (· + L.taken i g) (history j g)).trans
              ((congrArg (fun v => v + L.given j g + L.taken i g) same.symm).trans
                (Nat.add_assoc (l i g) (L.given j g) (L.taken i g)))))))),
   fun net => Naturals.add_right_cancel (k := L.taken i g + L.taken j g)
    ((Nat.add_assoc (l (i + 1) g) (L.taken i g) (L.taken j g)).symm.trans
      ((congrArg (· + L.taken j g) (history i g)).trans
        ((Nat.add_assoc (l i g) (L.given i g) (L.taken j g)).trans
          ((congrArg (l i g + ·) net).trans
            ((Nat.add_assoc (l i g) (L.given j g) (L.taken i g)).symm.trans
              ((congrArg (fun v => v + L.given j g + L.taken i g) same).trans
                ((congrArg (· + L.taken i g) (history j g)).symm.trans
                  ((Nat.add_assoc (l (j + 1) g) (L.taken j g) (L.taken i g)).trans
                    (congrArg (l (j + 1) g + ·) (Nat.add_comm (L.taken j g) (L.taken i g)))))))))))⟩

end Exchange

/-- Two relata. -/
inductive Two where
  | g
  | h

/-! ## (C) Fed by what does not couple in, and a blanketed course -/

namespace SteadyFeed

def take : Nat → Two → Two → Nat := fun _ _ _ => 0

/-- `h` gives `g` one unit at every step. -/
def give : Nat → Two → Two → Nat
  | _, .h, .g => 1
  | _, .h, .h => 0
  | _, .g, .g => 0
  | _, .g, .h => 0

def flow : Flow Two Two := ⟨fun _ => [Two.h], take, give⟩

def level : Nat → Two → Nat
  | t, .g => t
  | _, .h => 0

/-- Nothing is required, at need nothing; every relatum active; nothing drawn on. -/
def web : Web Two Two :=
  ⟨level, fun _ _ => True, fun _ _ _ => False, fun _ _ _ => 0, fun _ _ _ => False⟩

theorem balances : flow.Balances web := fun _ c => match c with
  | .g => rfl
  | .h => rfl

/-- `h` does not couple into `g`: `g` depends on nothing and observes nothing. -/
theorem h_uncoupled : ¬ web.CoupledInto (fun _ _ => False) Two.g Two.h :=
  fun coupled => match coupled with
    | .inl ⟨_, never⟩ => never
    | .inr never => never

/-- The read run: `g`'s level internal, nothing sensory (it couples in nothing), its exchange with
`h` active, `h`'s level and what `h` gives it external. -/
def run (n : Nat) : Parts Nat Unit (Nat × Nat) (Nat × Nat) :=
  ⟨web.level n .g, (), (flow.take n .g .h, flow.give n .g .h), (web.level n .h, flow.give n .h .g)⟩

def law : Blanketed Nat Unit (Nat × Nat) (Nat × Nat) where
  nextInternal l _ _ := l + 1
  nextSensory s _ _ := s
  nextActive _ _ a := a
  nextExternal _ _ e := e

theorem course_eq : ∀ n, law.course (run 0) n = run n
  | 0 => rfl
  | n + 1 => congrArg law.step (course_eq n)

/-- **Fed by what does not couple into it, its level the internal part of a blanketed law**: the
flow balances, `g`'s level rises by one at every step, and the read run is a blanketed course. -/
theorem fed_blanketed :
    flow.Balances web ∧ (∀ n, web.level (n + 1) .g = web.level n .g + 1) ∧
      ∃ (b : Blanketed Nat Unit (Nat × Nat) (Nat × Nat)) (x : Parts Nat Unit (Nat × Nat) (Nat × Nat)),
        ∀ n, b.course x n = run n :=
  ⟨balances, fun _ => rfl, law, run 0, course_eq⟩

/-- Its read run is consistent part by part. -/
theorem fed_consistent :
    BlanketConsistentFamily
      (fun (r : Nat → Parts Nat Unit (Nat × Nat) (Nat × Nat)) (_ : Nat → Unit) => r = run) :=
  (blanketed_courses_consistent law).mono fun _ _ held =>
    ⟨run 0, fun n => (congrArg (fun f : Nat → Parts Nat Unit (Nat × Nat) (Nat × Nat) => f n) held).trans
      (course_eq n).symm⟩

end SteadyFeed

/-! ## (D) The level moves through, the act does not -/

namespace ActUnread

/-- `g` takes one from `h` at step 1 only. -/
def pulse : Nat → Nat
  | 0 => 0
  | 1 => 1
  | _ + 2 => 0

def take : Nat → Two → Two → Nat
  | t, .g, .h => pulse t
  | _, .g, .g => 0
  | _, .h, .g => 0
  | _, .h, .h => 0

def flow : Flow Two Two := ⟨fun _ => [Two.g], take, fun _ _ _ => 0⟩

def hLevel : Nat → Nat
  | 0 => 1
  | 1 => 1
  | _ + 2 => 0

def level : Nat → Two → Nat
  | _, .g => 3
  | t, .h => hLevel t

def web : Web Two Two :=
  ⟨level, fun _ _ => True, fun _ _ _ => False, fun _ _ _ => 0, fun _ _ _ => False⟩

theorem balances : flow.Balances web := fun t c => match c, t with
  | .g, _ => rfl
  | .h, 0 => rfl
  | .h, 1 => rfl
  | .h, _ + 2 => rfl

/-- `g`'s level moves through: nothing moves it. -/
theorem level_moves_through : ∀ t, web.level (t + 1) .g = web.level t .g := fun _ => rfl

def run (n : Nat) : Parts Nat Unit Nat Nat :=
  ⟨web.level n .g, (), flow.take n .g .h, web.level n .h⟩

/-- **Not consistent part by part**: at steps 0 and 2 the level, the value and the act agree, and
the acts after them do not. -/
theorem not_consistent :
    ¬ BlanketConsistentFamily
      (fun (r : Nat → Parts Nat Unit Nat Nat) (_ : Nat → Unit) => r = run) :=
  fun cons => Naturals.succ_ne_zero 0
    (congrArg Prod.snd (cons.1 run (fun _ => ()) run (fun _ => ()) 0 2 rfl rfl rfl rfl))

end ActUnread

/-! ## (E) The drain-only witness is not balanced at every step -/

namespace DrainOnly

def phase : Nat → ReadsExternal.Three := Law.orbit ReadsExternal.next .first

def drawn : ReadsExternal.Three → Nat
  | .first => 1
  | .second => 0
  | .third => 0

/-- `h` takes one unit from `g` at its first phase; nothing is given. -/
def take : Nat → Two → Two → Nat
  | t, .h, .g => drawn (phase t)
  | _, .h, .h => 0
  | _, .g, .g => 0
  | _, .g, .h => 0

def flow : Flow Two Two := ⟨fun _ => [Two.h], take, fun _ _ _ => 0⟩

theorem phase_three : ∀ k, phase (3 * k) = .first
  | 0 => rfl
  | k + 1 =>
    congrArg (fun p => ReadsExternal.next (ReadsExternal.next (ReadsExternal.next p))) (phase_three k)

/-- In a balanced history, `g`'s level at step `3 k` with `k` added is its start. -/
theorem drained (l : Nat → Two → Nat) (history : flow.BalancedHistory l) :
    ∀ k, l (3 * k) .g + k = l 0 .g
  | 0 => rfl
  | k + 1 =>
    have b0 : l (3 * k + 1) .g + 1 = l (3 * k) .g :=
      (congrArg (fun p => l (3 * k + 1) .g + (drawn p + 0)) (phase_three k)).symm.trans
        (history (3 * k) .g)
    have b1 : l (3 * k + 2) .g = l (3 * k + 1) .g :=
      (congrArg (fun p => l (3 * k + 2) .g + (drawn (ReadsExternal.next p) + 0))
        (phase_three k)).symm.trans (history (3 * k + 1) .g)
    have b2 : l (3 * k + 3) .g = l (3 * k + 2) .g :=
      (congrArg
        (fun p => l (3 * k + 3) .g + (drawn (ReadsExternal.next (ReadsExternal.next p)) + 0))
        (phase_three k)).symm.trans (history (3 * k + 2) .g)
    (congrArg (· + (k + 1)) (b2.trans b1)).trans
      ((congrArg (l (3 * k + 1) .g + ·) (Nat.add_comm k 1)).trans
        ((Nat.add_assoc (l (3 * k + 1) .g) 1 k).symm.trans
          ((congrArg (· + k) b0).trans (drained l history k))))

/-- **No level history is balanced with the drain-only flow at every step**, from any start. -/
theorem no_balanced_history (l : Nat → Two → Nat) (history : flow.BalancedHistory l) : False :=
  Nat.not_succ_le_self (l 0 .g)
    (Nat.le_trans (Nat.le_add_left (l 0 .g + 1) (l (3 * (l 0 .g + 1)) .g))
      (Nat.le_of_eq (drained l history (l 0 .g + 1))))

end DrainOnly

/-! ## (F) A balanced periodic drain: the agent's half fails, the world's holds -/

namespace PhasedDrain

def phase : Nat → ReadsExternal.Three := Law.orbit ReadsExternal.next .first

/-- `g`'s level by phase: one, nothing after the draw, one after it is given back. -/
def gLevel : ReadsExternal.Three → Nat
  | .first => 1
  | .second => 0
  | .third => 1

/-- `h`'s level is its phase, kept by giving to and taking from itself. -/
def hLevel : ReadsExternal.Three → Nat
  | .first => 0
  | .second => 1
  | .third => 2

def hTakesG : ReadsExternal.Three → Nat
  | .first => 1
  | .second => 0
  | .third => 0

def hGivesG : ReadsExternal.Three → Nat
  | .first => 0
  | .second => 1
  | .third => 0

def hTakesH : ReadsExternal.Three → Nat
  | .first => 0
  | .second => 0
  | .third => 2

def hGivesH : ReadsExternal.Three → Nat
  | .first => 1
  | .second => 1
  | .third => 0

def take : Nat → Two → Two → Nat
  | t, .h, .g => hTakesG (phase t)
  | t, .h, .h => hTakesH (phase t)
  | _, .g, .g => 0
  | _, .g, .h => 0

def give : Nat → Two → Two → Nat
  | t, .h, .g => hGivesG (phase t)
  | t, .h, .h => hGivesH (phase t)
  | _, .g, .g => 0
  | _, .g, .h => 0

def flow : Flow Two Two := ⟨fun _ => [Two.h], take, give⟩

def level : Nat → Two → Nat
  | t, .g => gLevel (phase t)
  | t, .h => hLevel (phase t)

def web : Web Two Two :=
  ⟨level, fun _ _ => True, fun _ _ _ => False, fun _ _ _ => 0, fun _ _ _ => False⟩

theorem balance_g :
    ∀ p, gLevel (ReadsExternal.next p) + (hTakesG p + 0) = gLevel p + (hGivesG p + 0)
  | .first => rfl
  | .second => rfl
  | .third => rfl

theorem balance_h :
    ∀ p, hLevel (ReadsExternal.next p) + (hTakesH p + 0) = hLevel p + (hGivesH p + 0)
  | .first => rfl
  | .second => rfl
  | .third => rfl

theorem balances : flow.Balances web := fun t c => match c with
  | .g => balance_g (phase t)
  | .h => balance_h (phase t)

def run (n : Nat) : Parts Nat Unit (Nat × Nat) (Nat × (Nat × Nat)) :=
  ⟨web.level n .g, (), (flow.take n .g .h, flow.give n .g .h),
   (web.level n .h, (flow.take n .h .g, flow.give n .h .g))⟩

/-- **The agent's half fails**: at steps 2 and 3 `g`'s level, its value and its act agree, and
its next levels are 1 and 0. -/
theorem not_consistent :
    ¬ BlanketConsistentFamily
      (fun (r : Nat → Parts Nat Unit (Nat × Nat) (Nat × (Nat × Nat))) (_ : Nat → Unit) => r = run) :=
  fun cons => Naturals.succ_ne_zero 0
    (congrArg Prod.fst (cons.1 run (fun _ => ()) run (fun _ => ()) 2 3 rfl rfl rfl rfl))

def readNext (p : ReadsExternal.Three) : Unit × (Nat × (Nat × Nat)) :=
  ((), (hLevel (ReadsExternal.next p),
    (hTakesG (ReadsExternal.next p), hGivesG (ReadsExternal.next p))))

def nextOfLevel : Nat → Unit × (Nat × (Nat × Nat))
  | 0 => readNext .first
  | 1 => readNext .second
  | _ + 2 => readNext .third

theorem readNext_of_level : ∀ p, readNext p = nextOfLevel (hLevel p)
  | .first => rfl
  | .second => rfl
  | .third => rfl

/-- **The world's half holds**: `h`'s level, its phase, fixes the world's next parts. -/
theorem world_consistent :
    PartConsistentFamily
      (fun (r : Nat → Parts Nat Unit (Nat × Nat) (Nat × (Nat × Nat))) (_ : Nat → Unit) => r = run)
      worldReads worldParts :=
  fun r _ r' _ i j (held : r = run) (held' : r' = run) same _ =>
    match r, r', held, held', same with
    | _, _, rfl, rfl, same =>
      (readNext_of_level (phase i)).trans
        ((congrArg nextOfLevel
            (congrArg (fun v : Unit × (Nat × Nat) × (Nat × (Nat × Nat)) => v.2.2.1) same)).trans
          (readNext_of_level (phase j)).symm)

end PhasedDrain

/-! ## (G) A drain that stops when the level is spent: the agent's half holds, the world's fails -/

namespace SpentDrain

/-- `g`'s level: 2, 1, then nothing. -/
def gLevel : Nat → Nat
  | 0 => 2
  | 1 => 1
  | _ + 2 => 0

/-- `h` takes one unit from `g` at steps 0 and 1. -/
def drawn : Nat → Nat
  | 0 => 1
  | 1 => 1
  | _ + 2 => 0

def take : Nat → Two → Two → Nat
  | t, .h, .g => drawn t
  | _, .h, .h => 0
  | _, .g, .g => 0
  | _, .g, .h => 0

def flow : Flow Two Two := ⟨fun _ => [Two.h], take, fun _ _ _ => 0⟩

def level : Nat → Two → Nat
  | t, .g => gLevel t
  | _, .h => 0

def web : Web Two Two :=
  ⟨level, fun _ _ => True, fun _ _ _ => False, fun _ _ _ => 0, fun _ _ _ => False⟩

theorem balances : flow.Balances web := fun t c => match c, t with
  | .g, 0 => rfl
  | .g, 1 => rfl
  | .g, _ + 2 => rfl
  | .h, _ => rfl

/-- One less, down to nothing. -/
def own : Nat → Nat
  | 0 => 0
  | n + 1 => n

/-- `g`'s next level is read off its level. -/
theorem moves : ∀ t, gLevel (t + 1) = own (gLevel t)
  | 0 => rfl
  | 1 => rfl
  | _ + 2 => rfl

def run (n : Nat) : Parts Nat Unit (Nat × Nat) (Nat × Nat) :=
  ⟨web.level n .g, (), (flow.take n .g .h, flow.give n .g .h), (web.level n .h, flow.take n .h .g)⟩

/-- **The agent's half holds.** -/
theorem agent_consistent :
    PartConsistentFamily
      (fun (r : Nat → Parts Nat Unit (Nat × Nat) (Nat × Nat)) (_ : Nat → Unit) => r = run)
      agentReads agentParts :=
  fun r _ r' _ i j (held : r = run) (held' : r' = run) same _ =>
    match r, r', held, held', same with
    | _, _, rfl, rfl, same =>
      show (gLevel (i + 1), ((0 : Nat), (0 : Nat))) = (gLevel (j + 1), ((0 : Nat), (0 : Nat))) from
        BlanketCouplings.pair_eq ((moves i).trans ((congrArg own (congrArg Prod.fst same)).trans (moves j).symm)) rfl

/-- **The world's half fails**: at steps 0 and 1 what the world reads agrees, and what `h` takes
next differs. -/
theorem world_not_consistent :
    ¬ PartConsistentFamily
      (fun (r : Nat → Parts Nat Unit (Nat × Nat) (Nat × Nat)) (_ : Nat → Unit) => r = run)
      worldReads worldParts :=
  fun cons => Naturals.succ_ne_zero 0
    (congrArg (fun v : Unit × (Nat × Nat) => v.2.2)
      (cons run (fun _ => ()) run (fun _ => ()) 0 1 rfl rfl rfl rfl))

end SpentDrain

end UE28ReviewProbe

end Becoming
