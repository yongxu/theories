import Becoming.RegimeMargin

/-!
# The draws before: one draw, two levels (CY's hysteresis)

`Becoming.RegimeMargin` reads a condition under a standing draw `H`: the draw takes first, as much as
there is, and giving `g` comes back from what is left, `step g H x = (x - H) + g (x - H)` in natural
subtraction. Its adjusted giving already allows giving from nothing and rests below the draw
(`RegimeMargin.Adjusted.fixed_iff`, `RegimeMargin.Adjusted.rests_short`). This module reads the
regime's step with giving from nothing, the inflow `g 0`, under draws that change from step to step
(`underDraws`), and compares histories.

* **The inflow rest is the convention's.** A level the draw takes whole is the inflow at the next
  step (`to_inflow`): the draw clears all there is and giving from nothing refills it. Where the draw
  is at least the inflow, the inflow is a rest (`inflow_rests`). Under any schedule of draws a level
  at the inflow stays there while every draw is at least the inflow (`inflow_kept`), and a level at
  the inflow that is later elsewhere had a draw below the inflow in between
  (`leaving_needs_a_lower_draw`). Leaving can be downward too; it is not shown to be recovery.
* **A draw above every giving is enough for collapse.** Where the draw exceeds the giving at every
  amount up to `hi`, a level up to `hi` is at most the draw from `x - H` steps on, the regime's case
  of `RegimeMargin.Adjusted.taken_whole`, and the inflow from the step after (`collapses`).
* **A held level and an inflow rest under one draw, and the draws before.** Where the draw `H` is at least the inflow,
  giving meets it at every amount left `z` with `y ≤ z` and `z + H ≤ hi` (`RegimeMargin.Meets`) and
  the step keeps every level up to `hi`, a level `x` with `H + y ≤ x ≤ hi` never falls below `x`
  (`RegimeMargin.holds`) while the inflow rests (`two_levels`). Raised to a draw above every giving
  for `x - H' + 1` steps or more and brought back to `H`, the level from `x` is the inflow from then
  on (`history_decides`); where the inflow is below `x`, the two histories differ at every step from
  then on (`histories_differ`). So a draw above every giving bounds collapse from above, and the
  inflow bounds from above every draw under which a level can leave it: separated bounds, not the
  least draw that breaks the band nor a draw that brings recovery.
* **A witness.** Giving one from nothing, three from one to five, two from six and nothing from more,
  on levels up to eight (`Loop`). Under a draw of two, starts from three to eight never fall below
  their start, and a start at most two is one after one step; under two all along the level from
  eight stays eight, and raised to four for nine steps and brought back to two it is one from step
  nine on (`Loop.two_paths`). Under no draw, the level from one is seven after two steps; under three,
  starts from four to eight never fall below their start; a draw of four suffices for collapse
  (`Loop.bounds`).

These are laws of scalar steps on whole-number levels, with the draw taken first; they rank no
courses. Where the held starting level is above the inflow, the raised-and-returned and the
constant-draw histories have distinct later levels; that a state depends on its history in this way
is known as hysteresis. Nothing here is new as mathematics.
-/

namespace Becoming

namespace DrawHistory

/-- The level under a schedule of draws: at step `t` the regime's step under the draw `Hs t`. -/
def underDraws (g : Nat → Nat) (Hs : Nat → Nat) (x : Nat) : Nat → Nat
  | 0 => x
  | t + 1 => RegimeMargin.step g (Hs t) (underDraws g Hs x t)

/-- A level the draw takes whole is the inflow at the next step. -/
theorem to_inflow {g : Nat → Nat} {H x : Nat} (whole : x ≤ H) : RegimeMargin.step g H x = g 0 :=
  have none : x - H = 0 := sub_eq_zero_of_le whole
  show (x - H) + g (x - H) = g 0 from
    Eq.subst (motive := fun v => v + g v = g 0) none.symm (Nat.zero_add (g 0))

/-- Where the draw is at least the inflow, the inflow is a rest. -/
theorem inflow_rests {g : Nat → Nat} {H : Nat} (atLeast : g 0 ≤ H) :
    RegimeMargin.step g H (g 0) = g 0 :=
  to_inflow atLeast

/-- Where the draw is at least the inflow, the run from the inflow is the inflow at every step. -/
theorem inflow_stays {g : Nat → Nat} {H : Nat} (atLeast : g 0 ≤ H) :
    ∀ n, Law.orbit (RegimeMargin.step g H) (g 0) n = g 0
  | 0 => rfl
  | n + 1 => (congrArg (RegimeMargin.step g H) (inflow_stays atLeast n)).trans (inflow_rests atLeast)

/-- **No draw at least the inflow lifts a condition from it.** Under any schedule of draws, a level at
the inflow at step `T`, with every draw from `T` on at least the inflow, is the inflow at every later
step. -/
theorem inflow_kept {g : Nat → Nat} {Hs : Nat → Nat} {x T : Nat}
    (atLeast : ∀ t, T ≤ t → g 0 ≤ Hs t) (atInflow : underDraws g Hs x T = g 0) :
    ∀ k, underDraws g Hs x (T + k) = g 0
  | 0 => atInflow
  | k + 1 =>
    (congrArg (RegimeMargin.step g (Hs (T + k))) (inflow_kept atLeast atInflow k)).trans
      (inflow_rests (atLeast (T + k) (Nat.le_add_right T k)))

/-- **Leaving the inflow needs a draw below it.** A level at the inflow at step `T` that is not the
inflow at step `T + k` had, at some step from `T` to before `T + k`, a draw below the inflow: found by
going back from `T + k`, with draws compared at each step. -/
theorem leaving_needs_a_lower_draw {g : Nat → Nat} {Hs : Nat → Nat} {x T : Nat}
    (atInflow : underDraws g Hs x T = g 0) :
    ∀ k, underDraws g Hs x (T + k) ≠ g 0 → ∃ j, j < k ∧ Hs (T + j) < g 0
  | 0, left => absurd atInflow left
  | k + 1, left =>
    match Nat.decLt (Hs (T + k)) (g 0) with
    | isTrue lower => ⟨k, Nat.lt_succ_self k, lower⟩
    | isFalse notLower =>
      have prev : underDraws g Hs x (T + k) ≠ g 0 := fun same =>
        left ((congrArg (RegimeMargin.step g (Hs (T + k))) same).trans
          (inflow_rests (Nat.ge_of_not_lt notLower)))
      match leaving_needs_a_lower_draw atInflow k prev with
      | ⟨j, lt, lower⟩ => ⟨j, Nat.lt_succ_of_lt lt, lower⟩

/-- A run at or below the draw at step `m`, the draw at least the inflow, is the inflow from step
`m + 1` on. -/
theorem inflow_from {g : Nat → Nat} {H x m : Nat} (inflowBelow : g 0 ≤ H)
    (low : Law.orbit (RegimeMargin.step g H) x m ≤ H) :
    ∀ k, Law.orbit (RegimeMargin.step g H) x (m + 1 + k) = g 0
  | 0 => to_inflow low
  | k + 1 => (congrArg (RegimeMargin.step g H) (inflow_from inflowBelow low k)).trans (inflow_rests inflowBelow)

/-- **A draw above every giving is enough for collapse.** Where the draw exceeds the giving at every
amount up to `hi`, the run from a level up to `hi` is the inflow at every step from `x - H + 1` on:
from `x - H` steps on the draw takes all there is (`RegimeMargin.Adjusted.taken_whole`, read at the
regime's step through `RegimeMargin.Adjusted.orbit_regime`), and a level the draw takes whole goes to
the inflow, which rests. -/
theorem collapses {g : Nat → Nat} {H hi x : Nat} (above : ∀ z, z ≤ hi → g z < H) (high : x ≤ hi) :
    ∀ n, x - H + 1 ≤ n → Law.orbit (RegimeMargin.step g H) x n = g 0 :=
  have inflowBelow : g 0 < H := above 0 (Nat.zero_le hi)
  have short : RegimeMargin.Short g H (hi + 1) := fun z lt => above z (Nat.le_of_lt_succ lt)
  have below : x < H + (hi + 1) :=
    Nat.lt_of_lt_of_le (Nat.lt_succ_of_le high) (Nat.le_add_left (hi + 1) H)
  have taken : Law.orbit (RegimeMargin.step g H) x (x - H) ≤ H :=
    Eq.subst (motive := fun v => v ≤ H) (RegimeMargin.Adjusted.orbit_regime g H (x, 0) (x - H))
      (RegimeMargin.Adjusted.taken_whole short (RegimeMargin.Adjusted.regime_staysShort g H)
        (Nat.succ_pos hi) below (Nat.lt_of_le_of_lt (Nat.zero_le _) inflowBelow) (x - H) (Nat.le_refl _))
  fun _ late => match le_dest late with
    | ⟨k, at_n⟩ => Eq.subst (motive := fun j => Law.orbit (RegimeMargin.step g H) x j = g 0) at_n.symm
        (inflow_from (Nat.le_of_lt inflowBelow) taken k)

/-- **A held level and an inflow rest under one draw.** Where the draw is at least the inflow, giving meets it at every amount
left `z` with `y ≤ z` and `z + H ≤ hi`, and the step keeps every level up to `hi`, a level `x` with
`H + y ≤ x ≤ hi` never falls below `x`, and the inflow rests, under the same draw. -/
theorem two_levels {g : Nat → Nat} {H y hi x : Nat} (meets : RegimeMargin.Meets g H y hi)
    (keeps : RegimeMargin.Keeps g H hi) (atLeast : g 0 ≤ H) (low : H + y ≤ x) (high : x ≤ hi) :
    (∀ n, x ≤ Law.orbit (RegimeMargin.step g H) x n) ∧
      ∀ n, Law.orbit (RegimeMargin.step g H) (g 0) n = g 0 :=
  ⟨fun n => (RegimeMargin.holds meets keeps low high n).1, inflow_stays atLeast⟩

/-- The level under a schedule that keeps one draw up to a step is the run under that draw. -/
theorem underDraws_constant {g : Nat → Nat} {Hs : Nat → Nat} {H x T : Nat}
    (same : ∀ t, t < T → Hs t = H) :
    ∀ n, n ≤ T → underDraws g Hs x n = Law.orbit (RegimeMargin.step g H) x n
  | 0, _ => rfl
  | n + 1, le =>
    (congrArg (fun h => RegimeMargin.step g h (underDraws g Hs x n)) (same n le)).trans
      (congrArg (RegimeMargin.step g H) (underDraws_constant same n (Nat.le_of_succ_le le)))

/-- **The draws before decide the level under a draw.** A level `x` up to `hi`: raise the draw to `H'`,
above every giving up to `hi`, for `T ≥ x - H' + 1` steps, then bring it back to `H`, at least the
inflow, and the level is the inflow at every step from `T` on. Under `H` all along, with giving meeting
`H` at every amount left `z` with `y ≤ z` and `z + H ≤ hi`, the step keeping every level up to `hi`
and `H + y ≤ x`, the level never falls below `x`. -/
theorem history_decides {g : Nat → Nat} {Hs : Nat → Nat} {H H' y hi x T : Nat}
    (above : ∀ z, z ≤ hi → g z < H') (atLeast : g 0 ≤ H) (long : x - H' + 1 ≤ T) (high : x ≤ hi)
    (raised : ∀ t, t < T → Hs t = H') (back : ∀ t, T ≤ t → Hs t = H)
    (meets : RegimeMargin.Meets g H y hi) (keeps : RegimeMargin.Keeps g H hi) (low : H + y ≤ x) :
    (∀ k, underDraws g Hs x (T + k) = g 0) ∧ ∀ n, x ≤ Law.orbit (RegimeMargin.step g H) x n :=
  have atT : underDraws g Hs x T = g 0 :=
    (underDraws_constant raised T (Nat.le_refl T)).trans (collapses above high T long)
  ⟨inflow_kept (fun t late => Eq.subst (motive := fun h => g 0 ≤ h) (back t late).symm atLeast) atT,
   (two_levels meets keeps atLeast low high).1⟩

/-- **Where the inflow is below `x`, the two histories differ.** Under the premises of
`history_decides`, with the inflow below `x`, the level under the raised and returned draws is below
the level under `H` all along at every step from `T` on. -/
theorem histories_differ {g : Nat → Nat} {Hs : Nat → Nat} {H H' y hi x T : Nat}
    (above : ∀ z, z ≤ hi → g z < H') (atLeast : g 0 ≤ H) (long : x - H' + 1 ≤ T) (high : x ≤ hi)
    (raised : ∀ t, t < T → Hs t = H') (back : ∀ t, T ≤ t → Hs t = H)
    (meets : RegimeMargin.Meets g H y hi) (keeps : RegimeMargin.Keeps g H hi) (low : H + y ≤ x)
    (separate : g 0 < x) :
    ∀ k, underDraws g Hs x (T + k) < Law.orbit (RegimeMargin.step g H) x (T + k) :=
  have hd := history_decides above atLeast long high raised back meets keeps low
  fun k => Eq.subst (motive := fun v => v < Law.orbit (RegimeMargin.step g H) x (T + k)) (hd.1 k).symm
    (Nat.lt_of_lt_of_le separate (hd.2 (T + k)))

/-! ## A witness -/

namespace Loop

/-- Giving one from nothing, three from one to five, two from six, nothing from more. -/
def giving (z : Nat) : Nat := if z = 0 then 1 else if z ≤ 5 then 3 else if z = 6 then 2 else 0

/-- Up to eight, giving is below four. -/
theorem below_four : ∀ z, z ≤ 8 → giving z < 4
  | 0, _ => by decide
  | 1, _ => by decide
  | 2, _ => by decide
  | 3, _ => by decide
  | 4, _ => by decide
  | 5, _ => by decide
  | 6, _ => by decide
  | 7, _ => by decide
  | 8, _ => by decide
  | n + 9, high => absurd high (Nat.not_le_of_gt (Nat.lt_of_lt_of_le (by decide) (Nat.le_add_left 9 n)))

/-- Under a draw of two, giving meets it at every amount left from one to six. -/
theorem meets_two : RegimeMargin.Meets giving 2 1 8
  | 0, lo, _ => absurd lo (by decide)
  | 1, _, _ => by decide
  | 2, _, _ => by decide
  | 3, _, _ => by decide
  | 4, _, _ => by decide
  | 5, _, _ => by decide
  | 6, _, _ => by decide
  | n + 7, _, top => absurd top (Nat.not_le_of_gt (Nat.lt_of_lt_of_le (by decide : 8 < 7 + 2)
      (Nat.add_le_add_right (Nat.le_add_left 7 n) 2)))

/-- Under a draw of three, giving meets it at every amount left from one to five. -/
theorem meets_three : RegimeMargin.Meets giving 3 1 8
  | 0, lo, _ => absurd lo (by decide)
  | 1, _, _ => by decide
  | 2, _, _ => by decide
  | 3, _, _ => by decide
  | 4, _, _ => by decide
  | 5, _, _ => by decide
  | n + 6, _, top => absurd top (Nat.not_le_of_gt (Nat.lt_of_lt_of_le (by decide : 8 < 6 + 3)
      (Nat.add_le_add_right (Nat.le_add_left 6 n) 3)))

/-- Under a draw of two, the step keeps every level up to eight within eight. -/
theorem keeps_two : RegimeMargin.Keeps giving 2 8
  | 0, _ => by decide
  | 1, _ => by decide
  | 2, _ => by decide
  | 3, _ => by decide
  | 4, _ => by decide
  | 5, _ => by decide
  | 6, _ => by decide
  | 7, _ => by decide
  | 8, _ => by decide
  | n + 9, high => absurd high (Nat.not_le_of_gt (Nat.lt_of_lt_of_le (by decide) (Nat.le_add_left 9 n)))

/-- Under a draw of three, the step keeps every level up to eight within eight. -/
theorem keeps_three : RegimeMargin.Keeps giving 3 8
  | 0, _ => by decide
  | 1, _ => by decide
  | 2, _ => by decide
  | 3, _ => by decide
  | 4, _ => by decide
  | 5, _ => by decide
  | 6, _ => by decide
  | 7, _ => by decide
  | 8, _ => by decide
  | n + 9, high => absurd high (Nat.not_le_of_gt (Nat.lt_of_lt_of_le (by decide) (Nat.le_add_left 9 n)))

/-- The draws: four for nine steps, then two. -/
def draws (t : Nat) : Nat := if t < 9 then 4 else 2

/-- **One draw, two outcomes, decided by the draws before.** Under a draw of two all along, the level
from eight never falls below eight; raised to four for nine steps and brought back to two, the level
from eight is one at every step from nine on; and under two the inflow, one, rests. -/
theorem two_paths :
    (∀ n, 8 ≤ Law.orbit (RegimeMargin.step giving 2) 8 n) ∧
      (∀ k, underDraws giving draws 8 (9 + k) = 1) ∧
      ∀ n, Law.orbit (RegimeMargin.step giving 2) 1 n = 1 :=
  have hd := history_decides (g := giving) (Hs := draws) (H := 2) (H' := 4) (y := 1) (hi := 8) (x := 8)
    (T := 9) below_four (by decide) (by decide) (by decide) (fun _ lt => if_pos lt)
    (fun _ late => if_neg (Nat.not_lt_of_le late)) meets_two keeps_two (by decide)
  ⟨hd.2, hd.1, inflow_stays (g := giving) (H := 2) (by decide)⟩

/-- **The bounds in the witness.** Under no draw, the level from one is seven after two steps; under a
draw of three, starts from four to eight never fall below their start; under a draw of four, above
every giving up to eight, every level up to eight is one from step nine on. -/
theorem bounds :
    Law.orbit (RegimeMargin.step giving 0) 1 2 = 7 ∧
      (∀ x n, 3 + 1 ≤ x → x ≤ 8 → x ≤ Law.orbit (RegimeMargin.step giving 3) x n) ∧
      ∀ x n, x ≤ 8 → 9 ≤ n → Law.orbit (RegimeMargin.step giving 4) x n = 1 :=
  ⟨by decide,
   fun _ n low high => (RegimeMargin.holds meets_three keeps_three low high n).1,
   fun x n high late => collapses below_four high n
     (Nat.le_trans (Nat.succ_le_succ (Nat.le_trans (Nat.sub_le x 4) high)) late)⟩

end Loop

end DrawHistory

end Becoming
