import Becoming.HeldPossible

/-!
# UE11 review probes: a tower witness (question e)

`Copying`: a tower of rules in which the move `k + 1` sets the level `k` to a copy of the level
`k + 1`, the state never moving. Along the course that copies at the level `k` at step `k`, the
possible with the levels from every height `n` up held keeps widening, in 07's form, while from
every configuration of the course every formation is possible. Each level changes once; for
every `n` the levels from `n` up change without end because the change climbs the tower.
Evidence for the review, not proposed for landing as written.
-/

namespace Becoming.ProbeUE11

open Generative

universe u

/-- A case split on a decided condition, read through `ite`. -/
theorem ite_prop {c : Prop} [inst : Decidable c] {α : Sort u} {a b : α} (P : α → Prop)
    (pos : c → P a) (neg : ¬ c → P b) : P (if c then a else b) :=
  match inst with
  | isTrue h => pos h
  | isFalse h => neg h

namespace Copying

/-- Each level set to a copy of the one above; the state stays. -/
def process : Process (Unit × (Nat → Nat)) Nat :=
  RuleTower.process (fun _ z z' => z' = z) (fun _ above _ new => new = above)

/-- A configuration admits `x` where the level `x` stands above `x + 1`, its value at the start. -/
def adm (s : Unit × (Nat → Nat)) (x : Nat) : Prop := x + 1 < s.2 x

/-- The level `m` at step `k` of the course: `m + 2` below `k`, `m + 1` from `k` up. -/
def lv (k m : Nat) : Nat := if m < k then m + 2 else m + 1

theorem lv_below {k m : Nat} (below : m < k) : lv k m = m + 2 := if_pos below

theorem lv_above {k m : Nat} (above : ¬ m < k) : lv k m = m + 1 := if_neg above

/-- The course copying at the level `k` at step `k`. -/
def course : Run process :=
  ⟨fun k => ((), lv k), fun k => k + 1, fun k =>
    ⟨(lv_below (Nat.lt_succ_self k)).trans
        (lv_above (fun lt => Nat.lt_irrefl k (Nat.lt_trans (Nat.lt_succ_self k) lt))).symm,
     rfl,
     fun m ne => match Nat.lt_or_ge m k with
      | .inl lt => (lv_below (Nat.lt_succ_of_lt lt)).trans (lv_below lt).symm
      | .inr ge =>
        have after : k + 1 ≤ m := Nat.lt_of_le_of_ne ge (fun same => ne same.symm)
        (lv_above (Nat.not_lt_of_le after)).trans (lv_above (Nat.not_lt_of_le ge)).symm⟩⟩

/-- Held moves keep the levels from `n` up along any trace. -/
theorem sameFrom_of_trace {n : Nat} :
    ∀ {as : List Nat} {s t : Unit × (Nat → Nat)},
      Trace (keeping process (RuleTower.SameFrom n)) s as t → RuleTower.SameFrom n s t
  | [], _, _, .nil _ => fun _ _ => rfl
  | _ :: _, _, _, .cons kept rest => fun m le => ((sameFrom_of_trace rest) m le).trans (kept.2 m le)

/-- The level `x + 1` at any step of the course stands above `x + 1`. -/
theorem lv_next (k x : Nat) : x + 1 < lv k (x + 1) :=
  ite_prop (fun v => x + 1 < v) (fun _ => Nat.lt_trans (Nat.lt_succ_self (x + 1))
      (Nat.lt_succ_self (x + 1 + 1)))
    (fun _ => Nat.lt_succ_self (x + 1))

/-- The configuration after the move `x + 1` from the course's step `k`. -/
def copied (k x : Nat) : Unit × (Nat → Nat) :=
  ((), fun m => if m = x then lv k (x + 1) else lv k m)

/-- **With the levels from `n` up held, the possible at step `k` is what lies below `n` or below
`k`.** -/
theorem held_iff (n k x : Nat) :
    Reaching.PossibleHeld process (RuleTower.SameFrom n) adm (course.state k) x ↔ x < n ∨ x < k :=
  ⟨fun ⟨t, ⟨_, trace⟩, admitted⟩ => match Nat.decLt x n with
    | isTrue below => .inl below
    | isFalse notBelow =>
      have same : t.2 x = lv k x := sameFrom_of_trace trace x (Nat.ge_of_not_lt notBelow)
      .inr (match Nat.decLt x k with
        | isTrue lt => lt
        | isFalse notLt =>
          absurd (Eq.subst (motive := fun v => x + 1 < v) ((same.trans (lv_above notLt))) admitted)
            (Nat.lt_irrefl (x + 1))),
   fun either => match Nat.decLt x k with
    | isTrue lt => ⟨course.state k, Reach.refl _ _,
        Eq.subst (motive := fun v => x + 1 < v) (lv_below lt).symm (Nat.lt_succ_self (x + 1))⟩
    | isFalse notLt => match either with
      | .inr lt => absurd lt notLt
      | .inl below =>
        have move : process.step (course.state k) (x + 1) (copied k x) :=
          ⟨if_pos rfl, rfl, fun _ ne => if_neg ne⟩
        ⟨copied k x, Reach.of_step (a := x + 1)
            ⟨move, (RuleTower.step_sameFrom (x + 1) move).mono below⟩,
          Eq.subst (motive := fun v => x + 1 < v) (if_pos rfl : (copied k x).2 x = lv k (x + 1)).symm
            (lv_next k x)⟩⟩

/-- **With the levels from any height `n` up held, the possible keeps widening along the
course**, in 07's form. -/
theorem held_keeps_widening (n : Nat) :
    Reaching.KeepsWidening
      (fun k => Reaching.PossibleHeld process (RuleTower.SameFrom n) adm (course.state k)) :=
  ⟨fun k d x held => (held_iff n (k + d) x).mpr (match (held_iff n k x).mp held with
      | .inl below => .inl below
      | .inr lt => .inr (Nat.lt_of_lt_of_le lt (Nat.le_add_right k d))),
   fun k => ⟨n + 1, n + k,
     (held_iff n (k + (n + 1)) (n + k)).mpr
       (.inr (Eq.subst (motive := fun v => n + k < v) (Nat.add_assoc k n 1)
         (Eq.subst (motive := fun v => n + k < v + 1) (Nat.add_comm n k) (Nat.lt_succ_self (n + k))))),
     fun held => match (held_iff n k (n + k)).mp held with
      | .inl below => Nat.not_lt_of_le (Nat.le_add_right n k) below
      | .inr lt => Nat.not_lt_of_le (Nat.le_add_left k n) lt⟩⟩

/-- **From every configuration of the course every formation is possible**: the whole possible is
fixed while the possible held from every height keeps widening. -/
theorem whole_every (k x : Nat) : Reaching.Possible process adm (course.state k) x :=
  Reaching.PossibleHeld.possible ((held_iff (x + 1) k x).mpr (.inl (Nat.lt_succ_self x)))

end Copying

end Becoming.ProbeUE11
