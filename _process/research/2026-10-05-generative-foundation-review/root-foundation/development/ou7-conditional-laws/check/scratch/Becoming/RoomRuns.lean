import Becoming.RoomNet
import Becoming.RegimeMargin
import Becoming.HeldPossible

/-!
# The rooms' window courses as runs, and their possible with warmth held

Scratch module for board item OU5, part B, joining `Becoming.RoomNet` to the spine. With the window
open, the rooms' rule is `RegimeMargin`'s step, a draw of one and then the heater's giving of what
is left (`next_open`), so the window's branch from the set point is the regime's run from `3`
(`window_line`), and its laws apply as they stand: the unheated room is cold from the third step on
(`Unheated.window_cold`, by `RegimeMargin.stays_ended`), and the room whose heater gives what the
window draws stays at `3` (`Matched.window_held`, by `RegimeMargin.holds`). The thermostat's course
alternates `3, 4` (`Thermostat.alternates`): it returns, so nothing read off it keeps widening
(`Run.not_keepsWidening_of_returns`), and it changes at every step, so every moment is 全生成 at
the level (`Run.generation_of_held_changes`). Read as a process whose act opens the window, a
room's coarse line is its possible with warmth held (`line_iff_held`); a heated room's possible from
a warm occurrence is all possible with warmth held (`heated_possible_held`), and the unheated
room's cold occurrence is possible but not with warmth held (`Unheated.cold_not_held`).

Every declaration has an empty axiom report.
-/

namespace Becoming

open Generative

namespace Rooms

/-! ## The open window is the regime's step -/

/-- **With the window open, the rule is `RegimeMargin`'s step**: a draw of one, then the heater's
giving of what is left. -/
theorem next_open (c x : Nat) : next c 0 x = RegimeMargin.step (heater c) 1 x := by
  cases x with
  | zero => rfl
  | succ _ => rfl

/-- The window's run: the regime's run from the set point. -/
abbrev windowRun (c : Nat) : Run (Law.process (RegimeMargin.step (heater c) 1)) :=
  Law.run (RegimeMargin.step (heater c) 1) 3

/-- The window's branch from the set point, as occurrences: shut at the set point, then open. -/
def windowAt (c : Nat) : Nat → At
  | 0 => s3
  | n + 1 => ⟨true, (windowRun c).state (n + 1)⟩

theorem windowAt_level (c : Nat) : ∀ n, (windowAt c n).level = (windowRun c).state n
  | 0 => rfl
  | _ + 1 => rfl

/-- **The window's branch is a line of the net, step by step the regime's.** -/
theorem window_line (c n : Nat) : net c (windowAt c n) (windowAt c (n + 1)) :=
  Eq.subst (motive := fun k => net c (windowAt c n) ⟨true, k⟩)
    ((next_open c _).trans (congrArg (RegimeMargin.step (heater c) 1) (windowAt_level c n)))
    (opens c (windowAt c n))

/-! ## The regime's laws on the window's branch -/

theorem heater_zero (z : Nat) : heater 0 z = 0 := ite_self 0

/-- **The unheated room is cold from the third step after the window opens**: a draw beyond all
giving ends the condition after as many steps as it stood (`RegimeMargin.stays_ended`). -/
theorem Unheated.window_cold (k : Nat) : (windowAt 0 (3 + k)).level = 0 :=
  (windowAt_level 0 (3 + k)).trans
    (RegimeMargin.stays_ended (g := heater 0) (H := 1) (y := 4) (x := 3)
      (fun z _ => Eq.subst (motive := fun v => v < 1) (heater_zero z).symm Nat.zero_lt_one)
      rfl (by decide) k)

/-- Giving one wherever what is left lies below the set point meets a draw of one up to it. -/
theorem matched_meets : RegimeMargin.Meets (heater 1) 1 0 3 := fun _ _ fits =>
  Eq.subst (motive := fun v => 1 ≤ v) (if_pos fits).symm (Nat.le_refl 1)

/-- ... and keeps every level up to the set point within it. -/
theorem matched_keeps : RegimeMargin.Keeps (heater 1) 1 3 := fun x high =>
  have two : x - 1 ≤ 2 := Nat.sub_le_sub_right high 1
  Eq.subst (motive := fun v => (x - 1) + v ≤ 3) (if_pos (Nat.lt_succ_of_le two)).symm
    (Nat.succ_le_succ two)

/-- **The room whose heater gives what the window draws stays at the set point**
(`RegimeMargin.holds`). -/
theorem Matched.window_held (n : Nat) : (windowAt 1 n).level = 3 :=
  have held := RegimeMargin.holds (x := 3) matched_meets matched_keeps (by decide) (Nat.le_refl 3) n
  (windowAt_level 1 n).trans (Nat.le_antisymm held.2 held.1)

/-- **The thermostat's window course alternates `3` and `4`.** -/
theorem Thermostat.alternates : ∀ n,
    ((windowRun 2).state n = 3 ∧ (windowRun 2).state (n + 1) = 4) ∨
      ((windowRun 2).state n = 4 ∧ (windowRun 2).state (n + 1) = 3)
  | 0 => .inl ⟨rfl, rfl⟩
  | n + 1 => match Thermostat.alternates n with
    | .inl ⟨_, h⟩ => .inr ⟨h, congrArg (RegimeMargin.step (heater 2) 1) h⟩
    | .inr ⟨_, h⟩ => .inl ⟨h, congrArg (RegimeMargin.step (heater 2) 1) h⟩

/-- **Nothing read off the thermostat's window course keeps widening**: it returns to `3` at
arbitrarily late steps (`Run.not_keepsWidening_of_returns`). -/
theorem Thermostat.not_widening {X : Type} (F : Nat → X → Prop) :
    ¬ Reaching.KeepsWidening (fun n => F ((windowRun 2).state n)) :=
  Run.not_keepsWidening_of_returns (windowRun 2) F (N := 0) fun d =>
    match Thermostat.alternates d with
    | .inl ⟨h, _⟩ => ⟨d, Nat.le_of_eq (Nat.zero_add d), h⟩
    | .inr ⟨_, h⟩ => ⟨d + 1, Nat.le_succ_of_le (Nat.le_of_eq (Nat.zero_add d)), h⟩

/-- **Every moment of the thermostat's window course is 全生成 at the level**: the level changes at
every step (`Run.generation_of_held_changes`). Generation without widening. -/
theorem Thermostat.generation_at_moments (N : Nat) :
    «全生成» Steps.next «一» (fun n m => (windowRun 2).state n = (windowRun 2).state m) N :=
  Run.generation_of_held_changes (Same := fun a b => a = b) (windowRun 2)
    (fun n same => match Thermostat.alternates n with
      | .inl ⟨h, h'⟩ => absurd (h.symm.trans (same.trans h')) (by decide)
      | .inr ⟨h, h'⟩ => absurd (h.symm.trans (same.trans h')) (by decide))
    N

/-- **`RegimeMargin.holds` does not apply to the thermostat, yet its conclusion holds**: no band
holding the set point has giving meet the draw throughout (the heater gives nothing at `3`) and keep
within its top (from `3` the level goes to `4`); still the course never leaves `[3, 4]`. -/
theorem Thermostat.holds_one_way :
    (∀ y hi, 1 + y ≤ 3 → 3 ≤ hi →
      ¬ (RegimeMargin.Meets (heater 2) 1 y hi ∧ RegimeMargin.Keeps (heater 2) 1 hi)) ∧
      ∀ n, 3 ≤ (windowRun 2).state n ∧ (windowRun 2).state n ≤ 4 :=
  ⟨fun y hi low high ⟨meets, keeps⟩ => match Nat.lt_or_ge 3 hi with
     | .inl above => absurd (meets 3 (Nat.le_trans (Nat.le_add_left y 1) low) above) (by decide)
     | .inr below => absurd (Eq.subst (motive := fun h => RegimeMargin.Keeps (heater 2) 1 h)
         (Nat.le_antisymm below high) keeps 3 (Nat.le_refl 3)) (by decide),
   fun n => match Thermostat.alternates n with
     | .inl ⟨h, _⟩ => ⟨Nat.le_of_eq h.symm, Eq.subst (motive := fun v => v ≤ 4) h.symm (by decide)⟩
     | .inr ⟨h, _⟩ => ⟨Eq.subst (motive := fun v => 3 ≤ v) h.symm (by decide), Nat.le_of_eq h⟩⟩

/-- Nor does anything read off the unheated room's: it stays at `0` from the third step. -/
theorem Unheated.not_widening {X : Type} (F : Nat → X → Prop) :
    ¬ Reaching.KeepsWidening (fun n => F ((windowRun 0).state n)) :=
  Run.not_keepsWidening_of_returns (windowRun 0) F (N := 3) fun d =>
    ⟨3 + d, Nat.le_refl _,
     ((windowAt_level 0 (3 + d)).symm.trans (Unheated.window_cold d)).trans
       ((windowAt_level 0 (3 + 0)).symm.trans (Unheated.window_cold 0)).symm⟩

/-- Nor off the matched room's: it stays at `3`. -/
theorem Matched.not_widening {X : Type} (F : Nat → X → Prop) :
    ¬ Reaching.KeepsWidening (fun n => F ((windowRun 1).state n)) :=
  Run.not_keepsWidening_of_returns (windowRun 1) F (N := 0) fun d =>
    ⟨d, Nat.le_of_eq (Nat.zero_add d),
     ((windowAt_level 1 d).symm.trans (Matched.window_held d)).trans
       ((windowAt_level 1 0).symm.trans (Matched.window_held 0)).symm⟩

/-! ## The possible with warmth held -/

/-- A room as a process: the act says whether the window opens now. -/
def process (c : Nat) : Process At Bool :=
  ⟨fun s a t => t = ⟨s.opened || a, next c (outside (s.opened || a)) s.level⟩⟩

/-- The net's steps are the process's. -/
theorem steps_of_net {c : Nat} : ∀ {s t : At}, net c s t → Steps (process c) s t
  | ⟨false, _⟩, ⟨false, _⟩, ⟨_, e⟩ => ⟨false, congrArg (At.mk false) e⟩
  | ⟨false, _⟩, ⟨true, _⟩, ⟨_, e⟩ => ⟨true, congrArg (At.mk true) e⟩
  | ⟨true, _⟩, ⟨true, _⟩, ⟨_, e⟩ => ⟨true, congrArg (At.mk true) e⟩
  | ⟨true, _⟩, ⟨false, _⟩, ⟨.inl h, _⟩ => Bool.noConfusion h
  | ⟨true, _⟩, ⟨false, _⟩, ⟨.inr h, _⟩ => Bool.noConfusion h

/-- The process's steps are the net's. -/
theorem net_of_steps {c : Nat} : ∀ {s t : At}, Steps (process c) s t → net c s t
  | ⟨false, l⟩, _, ⟨_, e⟩ => Eq.subst (motive := net c ⟨false, l⟩) e.symm ⟨.inl rfl, rfl⟩
  | ⟨true, l⟩, _, ⟨_, e⟩ => Eq.subst (motive := net c ⟨true, l⟩) e.symm ⟨.inr rfl, rfl⟩

/-- **A coarse line is the possible with warmth held**: what warmth's line reaches from `x` is what
the moves holding warmth reach (`Reaching.reach_heldMoves_iff`). -/
theorem line_iff_held {c : Nat} {x y : At} :
    «所及» (net c) alike x y ↔ Reach (Reaching.heldMoves (process c) alike) x y :=
  have to : «则» («续» (Steps (process c)) alike) («续» (net c) alike) :=
    fun _ _ ⟨s, a⟩ => ⟨net_of_steps s, a⟩
  have fro : «则» («续» (net c) alike) («续» (Steps (process c)) alike) :=
    fun _ _ ⟨s, a⟩ => ⟨steps_of_net s, a⟩
  ⟨fun h => Reaching.reach_heldMoves_iff.mpr (match h with
     | .inl e => .inl e
     | .inr l => .inr («及之单调» fro _ _ l)),
   fun h => match Reaching.reach_heldMoves_iff.mp h with
     | .inl e => .inl e
     | .inr l => .inr («及之单调» to _ _ l)⟩

/-- **The unheated room's cold occurrence is possible, but not with warmth held.** -/
theorem Unheated.cold_not_held :
    Reaching.Possible (process 0) (fun s x => s = x) s3 Unheated.b0 ∧
      ¬ Reaching.PossibleHeld (process 0) alike (fun s x => s = x) s3 Unheated.b0 :=
  ⟨⟨Unheated.b0,
    Reach.trans (Reach.of_step (P := process 0) (s := s3) (t := Unheated.b2) (a := true) rfl)
      (Reach.trans (Reach.of_step (P := process 0) (s := Unheated.b2) (t := Unheated.b1) (a := true) rfl)
        (Reach.of_step (P := process 0) (s := Unheated.b1) (t := Unheated.b0) (a := true) rfl)),
    rfl⟩,
   fun held => match Reaching.possibleHeld_iff_line.mp held with
     | .inl e => Bool.noConfusion (congrArg At.opened e)
     | .inr ⟨_, l, e⟩ =>
       Bool.noConfusion (Eq.subst (motive := fun z => alike s3 z) e («线内同类» alike_class l))⟩

/-- In a heated room, a trace from a warm occurrence is made of moves holding warmth. -/
theorem heated_held {c : Nat} (hc : 1 ≤ c) : ∀ {x t : At} {as : List Bool}, warm x = true →
    Trace (process c) x as t → Reach (Reaching.heldMoves (process c) alike) x t
  | _, _, _, _, .nil _ => Reach.refl _ _
  | _, _, _, wx, .cons step rest =>
    have wm := heated_warm hc (net_of_steps ⟨_, step⟩)
    Reach.trans (Reach.of_step ⟨step, wx.trans wm.symm⟩) (heated_held hc wm rest)

/-- **A heated room's possible from a warm occurrence is all possible with warmth held.** -/
theorem heated_possible_held {c : Nat} (hc : 1 ≤ c) {X : Type} {adm : At → X → Prop} {x : At}
    (wx : warm x = true) {y : X} (possible : Reaching.Possible (process c) adm x y) :
    Reaching.PossibleHeld (process c) alike adm x y :=
  match possible with
  | ⟨t, ⟨_, trace⟩, admitted⟩ => ⟨t, heated_held hc wx trace, admitted⟩

end Rooms

end Becoming
