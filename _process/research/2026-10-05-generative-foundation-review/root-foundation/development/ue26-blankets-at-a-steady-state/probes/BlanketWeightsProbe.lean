import Becoming.Blanket

/-!
# Probe for UE26's design: balanced internal moves hold internal and external apart

Scratch only; not the module to land.
-/

namespace Becoming
namespace BlanketWeights

universe u
variable {I B E : Type u}

/-- **The cross form**: a weighting holds the internal and external parts apart given the blanket,
in counts. -/
def CrossForm (w : I → B → E → Nat) : Prop :=
  ∀ i i' b e e', w i b e * w i' b e' = w i b e' * w i' b e

/-- **Internal moves in detailed balance** with the weighting: at each blanket and external state,
the weight of an internal state times the rate of a move from it is the weight of the internal
state moved to times the rate of the move back. -/
def Balanced (w : I → B → E → Nat) (rate : B → E → I → I → Nat) : Prop :=
  ∀ i i' b e, w i b e * rate b e i i' = w i' b e * rate b e i' i

/-- Internal states joined by moves. -/
inductive Joined (adj : I → I → Prop) (i : I) : I → Prop
  | refl : Joined adj i i
  | tail {j k : I} : Joined adj i j → adj j k → Joined adj i k

theorem cross_of_move {a a' c c' r r' s s' : Nat} (hr : 0 < r) (hs : 0 < s')
    (db : a * r = c * r') (db' : a' * s = c' * s') (ratio : r * s' = r' * s) :
    a * c' = a' * c := by
  have h : a * c' * (r * s') = a' * c * (r * s') := by
    calc a * c' * (r * s') = a * r * (c' * s') := Naturals.mul_mul_mul_comm a c' r s'
      _ = c * r' * (a' * s) := by rw [db, ← db']
      _ = c * a' * (r' * s) := Naturals.mul_mul_mul_comm c r' a' s
      _ = a' * c * (r * s') := by rw [Nat.mul_comm c a', ← ratio]
  exact Nat.eq_of_mul_eq_mul_right (Nat.mul_pos hr hs) h

theorem ratio_of_cross {a a' c c' r r' s s' : Nat} (ha : 0 < a') (hc : 0 < c)
    (db : a * r = c * r') (db' : a' * s = c' * s') (cross : a * c' = a' * c) :
    r * s' = r' * s := by
  have h : a' * c * (r * s') = a' * c * (r' * s) := by
    calc a' * c * (r * s') = a * c' * (r * s') := by rw [cross]
      _ = a * r * (c' * s') := Naturals.mul_mul_mul_comm a c' r s'
      _ = c * r' * (a' * s) := by rw [db, ← db']
      _ = c * a' * (r' * s) := Naturals.mul_mul_mul_comm c r' a' s
      _ = a' * c * (r' * s) := by rw [Nat.mul_comm c a']
  exact Nat.eq_of_mul_eq_mul_left (Nat.mul_pos ha hc) h

theorem cross_trans {wi wi' wj wj' wk wk' : Nat} (hj : 0 < wj) (hj' : 0 < wj')
    (ij : wi * wj' = wi' * wj) (jk : wj * wk' = wj' * wk) : wi * wk' = wi' * wk := by
  have h : wi * wk' * (wj * wj') = wi' * wk * (wj * wj') := by
    calc wi * wk' * (wj * wj') = wi * wj * (wk' * wj') := Naturals.mul_mul_mul_comm wi wk' wj wj'
      _ = wi * wj * (wj' * wk') := by rw [Nat.mul_comm wk' wj']
      _ = wi * wj' * (wj * wk') := (Naturals.mul_mul_mul_comm wi wj' wj wk').symm
      _ = wi' * wj * (wj' * wk) := by rw [ij, jk]
      _ = wi' * wk * (wj * wj') := by rw [Naturals.mul_mul_mul_comm wi' wk wj wj', Nat.mul_comm wk wj']
  exact Nat.eq_of_mul_eq_mul_right (Nat.mul_pos hj hj') h

theorem pos_of_mul_eq {a b c d : Nat} (ha : 0 < a) (hb : 0 < b) (h : a * b = c * d) :
    0 < d := by
  cases d with
  | zero => exact absurd (h.trans (Nat.mul_zero c)) (Nat.ne_of_gt (Nat.mul_pos ha hb))
  | succ d => exact Nat.succ_pos d

/-- Along a joining relation, each move positive and its ratio reading no external state, the
cross form holds between the joined internal states. -/
theorem cross_of_joined (w : I → B → E → Nat) (rate : B → E → I → I → Nat)
    (adj : B → I → I → Prop) (pos : ∀ i b e, 0 < w i b e) (balanced : Balanced w rate)
    (moves : ∀ b e i i', adj b i i' → 0 < rate b e i i')
    (ratio : ∀ b e e' i i', adj b i i' →
      rate b e i i' * rate b e' i' i = rate b e i' i * rate b e' i i')
    (b : B) (e e' : E) (i : I) : ∀ {k : I}, Joined (adj b) i k → w i b e * w k b e' = w i b e' * w k b e
  | _, .refl => Nat.mul_comm _ _
  | _, @Joined.tail _ _ _ j k h step =>
    have back : 0 < rate b e' k j :=
      pos_of_mul_eq (pos j b e') (moves b e' j k step) (balanced j k b e')
    have jk : w j b e * w k b e' = w j b e' * w k b e :=
      cross_of_move (moves b e j k step) back (balanced j k b e) (balanced j k b e')
        (ratio b e e' j k step)
    cross_trans (pos j b e) (pos j b e')
      (cross_of_joined w rate adj pos balanced moves ratio b e e' i h) jk

/-- **Balanced internal moves hold internal and external apart.** Where the internal part's moves
are in detailed balance with a positive weighting, join the internal states at each blanket
state with positive rates, and the ratio of each move's rate to its reverse reads no external
state, the weighting holds the internal and external parts apart given the blanket. -/
theorem crossForm_of_balanced (w : I → B → E → Nat) (rate : B → E → I → I → Nat)
    (adj : B → I → I → Prop) (pos : ∀ i b e, 0 < w i b e) (balanced : Balanced w rate)
    (moves : ∀ b e i i', adj b i i' → 0 < rate b e i i')
    (ratio : ∀ b e e' i i', adj b i i' →
      rate b e i i' * rate b e' i' i = rate b e i' i * rate b e' i i')
    (joined : ∀ b i i', Joined (adj b) i i') : CrossForm w :=
  fun i k b e e' => cross_of_joined w rate adj pos balanced moves ratio b e e' i (joined b i k)

/-- Corollary: rates reading no external state. -/
theorem crossForm_of_balanced_unread (w : I → B → E → Nat) (rate : B → I → I → Nat)
    (adj : B → I → I → Prop) (pos : ∀ i b e, 0 < w i b e)
    (balanced : Balanced w (fun b _ => rate b))
    (moves : ∀ b i i', adj b i i' → 0 < rate b i i')
    (joined : ∀ b i i', Joined (adj b) i i') : CrossForm w :=
  crossForm_of_balanced w (fun b _ => rate b) adj pos balanced (fun b _ => moves b)
    (fun _ _ _ _ _ _ => Nat.mul_comm _ _) joined

/-- Conversely, a positive weighting held apart, with internal moves in detailed balance, has
the ratio of each move's rate to its reverse reading no external state. -/
theorem ratio_of_crossForm (w : I → B → E → Nat) (rate : B → E → I → I → Nat)
    (pos : ∀ i b e, 0 < w i b e) (balanced : Balanced w rate) (cross : CrossForm w)
    (b : B) (e e' : E) (i i' : I) :
    rate b e i i' * rate b e' i' i = rate b e i' i * rate b e' i i' :=
  ratio_of_cross (pos i b e') (pos i' b e) (balanced i i' b e) (balanced i i' b e') (cross i i' b e e')

namespace Relay

/-- The noisy relay: internal `μ`, blanket `s`, external `e`, each a bit, each flipping alone. -/
abbrev State := Bool × Bool × Bool

/-- Rate of the internal part's flip: towards the blanket at 3, away at 1, reading no external state. -/
def rate (s : Bool) (μ μ' : Bool) : Nat :=
  if μ' = μ then 0 else if μ = s then 1 else 3

/-- The whole chain's rates: the external part flips at 1, the blanket towards the external
at 3, away at 1, the internal part as `rate`. -/
def fullRate (x y : State) : Nat :=
  match x, y with
  | (μ, s, e), (μ', s', e') =>
    if μ' ≠ μ ∧ s' = s ∧ e' = e then rate s μ μ'
    else if μ' = μ ∧ s' ≠ s ∧ e' = e then (if s = e then 1 else 3)
    else if μ' = μ ∧ s' = s ∧ e' ≠ e then 1 else 0

/-- Its steady weights. -/
def weight : State → Nat
  | (false, false, false) => 31 | (false, false, true) => 15
  | (false, true, false) => 9  | (false, true, true) => 17
  | (true, false, false) => 17 | (true, false, true) => 9
  | (true, true, false) => 15  | (true, true, true) => 31

def w (μ s e : Bool) : Nat := weight (μ, s, e)

def flips (x : State) : List State :=
  match x with
  | (μ, s, e) => [(!μ, s, e), (μ, !s, e), (μ, s, !e)]

def inflow (x : State) : Nat := ((flips x).map fun y => weight y * fullRate y x).foldr (· + ·) 0
def outflow (x : State) : Nat := weight x * ((flips x).map fun y => fullRate x y).foldr (· + ·) 0

theorem steady (μ s e : Bool) : inflow (μ, s, e) = outflow (μ, s, e) := by
  cases μ <;> cases s <;> cases e <;> decide

theorem not_cross : ¬ CrossForm w := fun h => absurd (h false true false false true) (by decide)

theorem circulates : ¬ Balanced w (fun s _ => rate s) := fun bal =>
  not_cross (crossForm_of_balanced_unread w rate (fun _ μ μ' => μ ≠ μ')
    (fun μ s e => by cases μ <;> cases s <;> cases e <;> decide) bal
    (fun s μ μ' ne => by cases s <;> cases μ <;> cases μ' <;> first | exact absurd rfl ne | decide)
    (fun _ μ μ' => match μ, μ' with
      | false, false => .refl | true, true => .refl
      | false, true => .tail .refl (fun h => Bool.noConfusion h)
      | true, false => .tail .refl (fun h => Bool.noConfusion h)))

end Relay

end BlanketWeights
end Becoming
