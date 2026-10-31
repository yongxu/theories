import Becoming.CountedCodes

/-! Recheck probes for UE25 round 2 (`Becoming.CountedCodes`). Scratch only. Each probe tests a
sentence of the texts against the hypotheses of the theorems it cites. -/

namespace Becoming

namespace Recheck25

open CountedCodes FreeEnergyCounting

/-! ### Q1. "A meaning the renaming moves" is not enough: the renaming must move every word.
Three words, the renaming swapping `a` and `b` and fixing `c`; a start related to itself under the
exchange of two agents with that renaming; one step of adding the speaker's counts gives both agents
`3, 3, 10`, a shared uniquely greatest word `c`. -/

inductive W | a | b | c
  deriving DecidableEq

def swapAB : W → W
  | .a => .b
  | .b => .a
  | .c => .c

def start : Bool → Unit → W → Nat
  | false, _, .a => 1
  | false, _, .b => 2
  | true, _, .a => 2
  | true, _, .b => 1
  | _, _, .c => 5

theorem q1_symmetric : Renamed (fun i => !i) (fun (_ : Unit) => swapAB) start start
  | false, _, .a => rfl
  | false, _, .b => rfl
  | false, _, .c => rfl
  | true, _, .a => rfl
  | true, _, .b => rfl
  | true, _, .c => rfl

theorem q1_moves_some : swapAB .a ≠ .a := fun h => W.noConfusion h

theorem q1_shared (i : Bool) :
    UniqueGreatest ((Law.run (hear (fun i => !i) addSpeaker) start).state 1 i ()) W.c :=
  match i with
  | false => fun w ne => match w, ne with
    | .a, _ => by decide
    | .b, _ => by decide
    | .c, ne => absurd rfl ne
  | true => fun w ne => match w, ne with
    | .a, _ => by decide
    | .b, _ => by decide
    | .c, ne => absurd rfl ne

/-! ### Q2. "Under a deterministic law" / "learning from what is heard", without the renaming
kept, is not enough: the module's own `CountedCodes.Witness.first` is a deterministic rule of learning from what
is heard, the speaker map the exchange, reading count by count, from a start related to itself
(`CountedCodes.Witness.zero_symmetric`), and it brings a shared uniquely greatest word. -/

theorem q2_first_reads : ReadsCountByCount (addHeard CountedCodes.Witness.first) :=
  fun _ _ _ d d' same same' w =>
    show _ + CountedCodes.Witness.first () d w = _ + CountedCodes.Witness.first () d' w from
      (congrArg (· + CountedCodes.Witness.first () d w) (same w)).trans
        (congrArg (fun x => _ + x)
          (show CountedCodes.Witness.first () d w = CountedCodes.Witness.first () d' w by
            unfold CountedCodes.Witness.first; rw [same' false, same' true]))

theorem q2_deterministic_shares :
    Renamed (fun i => !i) (fun (_ : Unit) y => !y) CountedCodes.Witness.zero CountedCodes.Witness.zero ∧
      ReadsCountByCount (addHeard CountedCodes.Witness.first) ∧
      (∀ i, UniqueGreatest
        ((Law.run (hear (fun i => !i) (addHeard CountedCodes.Witness.first)) CountedCodes.Witness.zero).state 1 i ()) false) :=
  ⟨CountedCodes.Witness.zero_symmetric, q2_first_reads, CountedCodes.Witness.first_shared⟩

/-! ### Q3. "A belief at the bound under symmetric weights names no word" needs a listing of every
word: over the listing `[false]`, weights `1, 1` (fixed by the swap, positive total) are reached by
the belief `0, 5`, whose word `true` is uniquely greatest. -/

theorem q3_listing_needed :
    (total [false] (fun w => bif w then 5 else 0) ^ total [false] (fun w => bif w then 5 else 0) *
        powerProduct (fun _ => 1) (fun w => bif w then 5 else 0) [false] =
      total [false] (fun _ => 1) ^ total [false] (fun w => bif w then 5 else 0) *
        powerProduct (fun w => bif w then 5 else 0) (fun w => bif w then 5 else 0) [false]) ∧
      0 < total [false] (fun (_ : Bool) => 1) ∧
      UniqueGreatest (fun w : Bool => bif w then 5 else 0) true :=
  ⟨rfl, Nat.zero_lt_one, fun w ne => match w, ne with
    | false, _ => by decide
    | true, ne => absurd rfl ne⟩

/-! ### Q4. ... and a positive total: over every word, weights `0, 0` (fixed by the swap) are
reached by the belief `1, 0`, whose word `false` is uniquely greatest. -/

theorem q4_positive_needed :
    (total [false, true] (fun w => bif w then 0 else 1) ^ total [false, true] (fun w => bif w then 0 else 1) *
        powerProduct (fun _ => 0) (fun w => bif w then 0 else 1) [false, true] =
      total [false, true] (fun _ => 0) ^ total [false, true] (fun w => bif w then 0 else 1) *
        powerProduct (fun w => bif w then 0 else 1) (fun w => bif w then 0 else 1) [false, true]) ∧
      UniqueGreatest (fun w : Bool => bif w then 0 else 1) false :=
  ⟨rfl, fun w ne => match w, ne with
    | true, _ => by decide
    | false, ne => absurd rfl ne⟩

/-! ### Q5. A gated law reading the agent's whole model is not of `hear`'s form, yet keeps the
relation where the gate is unchanged by the renaming: the paper's gating by expected free energy
belongs under `never_shared`'s hypothesis (`Law.KeepsRelation`), not under `hear_keeps`'s class. -/

def gated {I M F : Type} (π : I → I) (G : (M → F → Nat) → Bool) (X : I → M → F → Nat) :
    I → M → F → Nat :=
  fun i m w => bif G (X i) then X i m w + X (π i) m w else X i m w

theorem q5_gated_keeps {I M F : Type} {π : I → I} {σ : M → F → F} (G : (M → F → Nat) → Bool)
    (invariant : ∀ c d : M → F → Nat, (∀ m w, d m w = c m (σ m w)) → G d = G c) :
    Law.KeepsRelation (gated π G) (Renamed π σ) :=
  fun X Y related i m w =>
    have gate : G (Y i) = G (X (π i)) := invariant _ _ (related i)
    show (bif G (Y i) then Y i m w + Y (π i) m w else Y i m w) =
      (bif G (X (π i)) then X (π i) m (σ m w) + X (π (π i)) m (σ m w) else X (π i) m (σ m w)) by
      rw [gate, related i m w, related (π i) m w]

end Recheck25

end Becoming
