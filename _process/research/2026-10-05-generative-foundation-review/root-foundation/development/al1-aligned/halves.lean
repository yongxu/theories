
namespace Optimum

namespace Holding

open Diversion

/-- Half, rounded down. -/
def half : Nat → Nat
  | 0 => 0
  | 1 => 0
  | n + 2 => half n + 1

theorem half_le_succ : ∀ n, half n ≤ half (n + 1)
  | 0 => Nat.le_refl 0
  | 1 => Nat.zero_le _
  | n + 2 => Nat.succ_le_succ (half_le_succ n)

theorem half_mono {m : Nat} : ∀ j, half m ≤ half (m + j)
  | 0 => Nat.le_refl _
  | j + 1 => Nat.le_trans (half_mono j) (half_le_succ (m + j))

theorem half_double : ∀ b, half (b + b) = b
  | 0 => rfl
  | b + 1 => (congrArg half (congrArg Nat.succ (Nat.succ_add b b))).trans (congrArg (· + 1) (half_double b))

/-- What stands next from `x` left: `x` and half of it. -/
def halfMore (_ x : Nat) : Nat := x + half x

/-- Two drawers' portions of the level: the first the larger half, the second the smaller. -/
def halves : Nat → Nat → Nat → Nat
  | 0, _, z => z - half z
  | _ + 1, _, z => half z

/-- Each drawer leaves all of its portion but one unit. -/
def leavesAllButOne (_ _ a : Nat) : Nat := a - 1

theorem half_le (n : Nat) : half n ≤ n :=
  Nat.le_trans (half_mono (m := n) n) (Nat.le_of_eq (half_double n))

/-- Under `halfMore`, neither half returns more than one for one on what its drawer alone leaves. -/
theorem halves_return {N : Nat} : ∀ d, d < 2 → ∀ t, t + 1 < N → ∀ z b, b ≤ halves d t z →
    halves d (t + 1) (halfMore t b) ≤ halves d (t + 1) (halfMore t 0) + b
  | 0, _, _, _, _, b, _ => Nat.le_trans (Nat.le_trans
      (Nat.sub_le_sub_right (Nat.add_le_add_left (half_mono (m := b) (half b)) b) (half (b + half b)))
      (Nat.le_of_eq (Naturals.add_sub_cancel b _))) (Nat.le_of_eq (Nat.zero_add b).symm)
  | _ + 1, _, _, _, _, b, _ =>
    match le_dest (Nat.add_le_add_left (half_le b) b) with
    | ⟨j, same⟩ => Nat.le_trans (Nat.le_trans (half_mono (m := b + half b) j)
        (Nat.le_of_eq ((congrArg half same.symm).trans (half_double b)))) (Nat.le_of_eq (Nat.zero_add b).symm)

/-- Leaving all but one unit of each half holds the level at six. -/
theorem halves_hold (t : Nat) : AtOnce.next halfMore halves leavesAllButOne 2 t 6 = 6 := rfl

theorem halves_held : ∀ t, AtOnce.levels halfMore halves leavesAllButOne 2 6 t = 6
  | 0 => rfl
  | t + 1 => (congrArg (AtOnce.next halfMore halves leavesAllButOne 2 t) (halves_held t)).trans (halves_hold t)

/-- **The two halves.** Two drawers draw at once from a level, the first given the larger half and the
second the smaller, and what both leave, `x`, stands next as `x` and half of it, so the whole returns
more than one for one from two units left. Neither half returns more than one for one on what its
drawer alone leaves, so over every horizon drawing everything is perfect, and it breaks the dweller at
the first step from a source at six. Leaving all of each half but one unit holds the source at six,
keeping the dweller at every step, and over `n + 1` steps with `4 ≤ n` it draws each drawer more than
drawing everything does; it is not perfect, since at the last step each draws everything. A single
drawer given all that stands finds drawing everything imperfect over every horizon of two steps or
more. -/
theorem halves_race {n : Nat} (four : 4 ≤ n) :
    (AtOnce.Perfect halfMore halves (fun _ _ _ => 0) (fun _ _ _ => 0) 2 (n + 1) ∧
      (web (onSource (AtOnce.levels halfMore halves (fun _ _ _ => 0) 2 6))).Broken 0 .dweller .source) ∧
      (∀ t, 2 ≤ (web (onSource (AtOnce.levels halfMore halves leavesAllButOne 2 6))).level t .source) ∧
      (∀ d, d < 2 → AtOnce.drawn halfMore halves (fun _ _ _ => 0) 2 d (n + 1) 0 6 <
        AtOnce.drawn halfMore halves leavesAllButOne 2 d (n + 1) 0 6) ∧
      ¬ AtOnce.Perfect halfMore halves (fun _ _ _ => 0) leavesAllButOne 2 (n + 1) ∧
      ¬ AtOnce.Perfect halfMore (fun _ _ z => z) (fun _ _ _ => 0) (fun _ _ _ => 0) 1 (n + 1) :=
  have more : ∀ d, d < 2 → ∀ t, halves d (t + 1) (halfMore t 0) <
      halves d (t + 1) 6 - leavesAllButOne d (t + 1) (halves d (t + 1) 6) := fun d _ _ =>
    match d with
    | 0 => Nat.zero_lt_one
    | _ + 1 => Nat.zero_lt_one
  have three : ∀ d, halves d 0 6 < n := fun d =>
    match d with
    | 0 => Nat.lt_of_lt_of_le (Nat.lt_succ_self 3) four
    | _ + 1 => Nat.lt_of_lt_of_le (Nat.lt_succ_self 3) four
  ⟨Web.drain_perfect_broken (fun d dk t lt z b le => halves_return d dk t lt z b le) (fun _ _ => rfl)
     (Nat.succ_pos n) trivial (Nat.succ_pos 1) (Nat.le_add_left 2 4),
   fun t => Nat.le_trans (Nat.le_add_left 2 4) (Nat.le_of_eq (halves_held t).symm),
   fun d dk => AtOnce.holding_draws_more dk halves_hold (more d dk) (three d),
   fun perfect => (fun two : 2 = 0 => nomatch two) (AtOnce.last_draws perfect (t := n) rfl (d := 0) (Nat.zero_lt_succ 1) 6),
   AtOnce.whole_not_drained (d := 0) (t := 0) (z := 2) (b := 2) Nat.zero_lt_one
     (Nat.succ_lt_succ (Nat.lt_of_lt_of_le (Nat.succ_pos 3) four))
     (fun _ => rfl) (Nat.le_refl 2) (Nat.lt_succ_self 2)⟩

end Holding

end Optimum
