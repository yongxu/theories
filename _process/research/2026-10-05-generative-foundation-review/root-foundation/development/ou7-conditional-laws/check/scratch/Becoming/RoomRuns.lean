import Becoming.RoomNet
import Becoming.RegimeMargin
import Becoming.HeldPossible

/-!
# The rooms' window courses as runs, and their possible with warmth held

Scratch module for board item OU5, part B, joining `Becoming.RoomNet` to the spine. With the window
open, the rooms' rule is `RegimeMargin`'s step, a draw of one and then the heater's giving of what
is left (`next_open`), so the window's branch from the set level is the regime's run from it
(`window_line`), and its laws apply as they stand: the unheated room is cold from the step of its
margin on (`Unheated.window_cold`, by `RegimeMargin.stays_ended`), the stage at which warm or not
first tells it from a heated room (`«开窗以温层如其余乃分»`); the matched thermostat stays at its
set level (`Matched.window_held`, by `RegimeMargin.holds`). At a margin of three the overshooting
thermostat's course alternates `3, 4` (`Overshooting.alternates`), `RegimeMargin.Alternation`'s run
shifted by two (`Overshooting.alternation_shifted`): it returns, so nothing read off it keeps
widening (`Run.not_keepsWidening_of_returns`), and it changes at every step, so every moment is
全生成 at the level of the run (`Run.generation_of_held_changes`), a reading on the run's moments
apart from the net's 全生成 in `Becoming.RoomNet`. Read as a process whose act
opens the window, a room's coarse line is its possible with warmth held (`line_iff_held`); a heated
room's possible from a warm occurrence is all possible with warmth held (`heated_possible_held`), and
the unheated room's cold occurrence is possible but not with warmth held (`Unheated.cold_not_held`).

Every declaration has an empty axiom report.
-/

namespace Becoming

open Generative

namespace Rooms

/-! ## The open window is the regime's step -/

/-- **With the window open, the rule is `RegimeMargin`'s step**: a draw of one, then the heater's
giving of what is left. -/
theorem next_open (m c x : Nat) : next m c 0 x = RegimeMargin.step (heater m c) 1 x := by
  cases x with
  | zero => rfl
  | succ _ => rfl

/-- The window's run: the regime's run from the set level. -/
abbrev windowRun (m c : Nat) : Run (Law.process (RegimeMargin.step (heater m c) 1)) :=
  Law.run (RegimeMargin.step (heater m c) 1) m

/-- The window's branch from the set level, as occurrences: shut at the set level, then open. -/
def windowAt (m c : Nat) : Nat → Occurrence
  | 0 => start m
  | n + 1 => ⟨true, (windowRun m c).state (n + 1)⟩

theorem windowAt_level (m c : Nat) : ∀ n, (windowAt m c n).level = (windowRun m c).state n
  | 0 => rfl
  | _ + 1 => rfl

/-- **The window's branch is a line of the net, step by step the regime's.** -/
theorem window_line (m c n : Nat) : net m c (windowAt m c n) (windowAt m c (n + 1)) :=
  Eq.subst (motive := fun k => net m c (windowAt m c n) ⟨true, k⟩)
    ((next_open m c _).trans (congrArg (RegimeMargin.step (heater m c) 1) (windowAt_level m c n)))
    (opens m c (windowAt m c n))

/-! ## The regime's laws on the window's branch -/

/-- **The unheated room is cold from the step of its margin on, once the window opens**: with no
heater, giving falls short of the draw of one below the start (`RegimeMargin.Short`) and nothing
comes from nothing, so the condition is gone after as many steps as it stood
(`RegimeMargin.stays_ended`). -/
theorem Unheated.window_cold (m k : Nat) : (windowAt m 0 (m + k)).level = 0 :=
  (windowAt_level m 0 (m + k)).trans
    (RegimeMargin.stays_ended (g := heater m 0) (H := 1) (y := m) (x := m)
      (fun z _ => Eq.subst (motive := fun v => v < 1) (heater_zero m z).symm Nat.zero_lt_one)
      (heater_zero m 0)
      (Eq.subst (motive := fun v => m < v) (Nat.add_comm m 1) (Nat.lt_succ_self m)) k)

/-- Giving one wherever what is left lies below the set level meets a draw of one up to it. -/
theorem matched_meets (m : Nat) : RegimeMargin.Meets (heater m 1) 1 0 m := fun _ _ fits =>
  Eq.subst (motive := fun v => 1 ≤ v) (if_pos fits).symm (Nat.le_refl 1)

/-- ... and keeps every level up to a positive set level within it. -/
theorem matched_keeps {m : Nat} (hm : 1 ≤ m) : RegimeMargin.Keeps (heater m 1) 1 m := fun x high =>
  have lt : x - 1 < m :=
    Nat.lt_of_le_of_lt (Nat.sub_le_sub_right high 1) (Nat.sub_lt hm Nat.zero_lt_one)
  Eq.subst (motive := fun v => (x - 1) + v ≤ m) (if_pos lt).symm (Nat.succ_le_of_lt lt)

/-- **The matched thermostat stays at its set level once the window opens**
(`RegimeMargin.holds`). -/
theorem Matched.window_held {m : Nat} (hm : 1 ≤ m) (n : Nat) : (windowAt m 1 n).level = m :=
  have held := RegimeMargin.holds (x := m) (matched_meets m) (matched_keeps hm) hm (Nat.le_refl m) n
  (windowAt_level m 1 n).trans (Nat.le_antisymm held.2 held.1)

/-- **At a margin of three the overshooting thermostat's window course alternates `3` and `4`.** -/
theorem Overshooting.alternates : ∀ n,
    ((windowRun 3 2).state n = 3 ∧ (windowRun 3 2).state (n + 1) = 4) ∨
      ((windowRun 3 2).state n = 4 ∧ (windowRun 3 2).state (n + 1) = 3)
  | 0 => .inl ⟨rfl, rfl⟩
  | n + 1 => match Overshooting.alternates n with
    | .inl ⟨_, h⟩ => .inr ⟨h, congrArg (RegimeMargin.step (heater 3 2) 1) h⟩
    | .inr ⟨_, h⟩ => .inl ⟨h, congrArg (RegimeMargin.step (heater 3 2) 1) h⟩

/-- **Nothing read off the overshooting thermostat's window course keeps widening**: it returns to
`3` at
arbitrarily late steps (`Run.not_keepsWidening_of_returns`). -/
theorem Overshooting.not_widening {X : Type} (F : Nat → X → Prop) :
    ¬ Reaching.KeepsWidening (fun n => F ((windowRun 3 2).state n)) :=
  Run.not_keepsWidening_of_returns (windowRun 3 2) F (N := 0) fun d =>
    match Overshooting.alternates d with
    | .inl ⟨h, _⟩ => ⟨d, Nat.le_of_eq (Nat.zero_add d), h⟩
    | .inr ⟨_, h⟩ => ⟨d + 1, Nat.le_succ_of_le (Nat.le_of_eq (Nat.zero_add d)), h⟩

/-- **Every moment of the overshooting thermostat's window course is 全生成 at the level**, read on
the run's moments: the level changes at every step (`Run.generation_of_held_changes`). Generation
without widening. -/
theorem Overshooting.generation_at_moments (N : Nat) :
    «全生成» Steps.next «一» (fun n m => (windowRun 3 2).state n = (windowRun 3 2).state m) N :=
  Run.generation_of_held_changes (Same := fun a b => a = b) (windowRun 3 2)
    (fun n same => match Overshooting.alternates n with
      | .inl ⟨h, h'⟩ => absurd (h.symm.trans (same.trans h')) (by decide)
      | .inr ⟨h, h'⟩ => absurd (h.symm.trans (same.trans h')) (by decide))
    N

/-- **`RegimeMargin.holds` does not apply to the overshooting thermostat, yet its conclusion
holds**: no band
holding the set level has giving meet the draw throughout (the heater gives nothing at `3`) and keep
within its top (from `3` the level goes to `4`); still the course never leaves `[3, 4]`. -/
theorem Overshooting.holds_one_way :
    (∀ y hi, 1 + y ≤ 3 → 3 ≤ hi →
      ¬ (RegimeMargin.Meets (heater 3 2) 1 y hi ∧ RegimeMargin.Keeps (heater 3 2) 1 hi)) ∧
      ∀ n, 3 ≤ (windowRun 3 2).state n ∧ (windowRun 3 2).state n ≤ 4 :=
  ⟨fun y hi low high ⟨meets, keeps⟩ => match Nat.lt_or_ge 3 hi with
     | .inl above => absurd (meets 3 (Nat.le_trans (Nat.le_add_left y 1) low) above) (by decide)
     | .inr below => absurd (Eq.subst (motive := fun h => RegimeMargin.Keeps (heater 3 2) 1 h)
         (Nat.le_antisymm below high) keeps 3 (Nat.le_refl 3)) (by decide),
   fun n => match Overshooting.alternates n with
     | .inl ⟨h, _⟩ => ⟨Nat.le_of_eq h.symm, Eq.subst (motive := fun v => v ≤ 4) h.symm (by decide)⟩
     | .inr ⟨h, _⟩ => ⟨Eq.subst (motive := fun v => 3 ≤ v) h.symm (by decide), Nat.le_of_eq h⟩⟩

/-- Above two the overshooting heater is `RegimeMargin.Alternation`'s giving shifted by two. -/
theorem Overshooting.heater_shifted : ∀ z, heater 3 2 (z + 2) = RegimeMargin.Alternation.giving z
  | 0 => rfl
  | z + 1 =>
    have above : ¬ (z + 1 + 2 < 3) := fun h => Nat.not_succ_le_zero z
      (Nat.le_of_succ_le_succ (Nat.le_of_succ_le_succ (Nat.le_of_succ_le_succ h)))
    (if_neg above).trans (if_neg (fun h => Nat.noConfusion h : z + 1 ≠ 0)).symm

/-- The overshooting thermostat's window course and `RegimeMargin.Alternation`'s run from one move
in phase. -/
theorem Overshooting.in_phase : ∀ n,
    ((windowRun 3 2).state n = 3 ∧
        (Law.run (RegimeMargin.step RegimeMargin.Alternation.giving 1) 1).state n = 1) ∨
      ((windowRun 3 2).state n = 4 ∧
        (Law.run (RegimeMargin.step RegimeMargin.Alternation.giving 1) 1).state n = 2)
  | 0 => .inl ⟨rfl, rfl⟩
  | n + 1 => match Overshooting.in_phase n with
    | .inl ⟨h, h'⟩ => .inr ⟨congrArg (RegimeMargin.step (heater 3 2) 1) h,
        congrArg (RegimeMargin.step RegimeMargin.Alternation.giving 1) h'⟩
    | .inr ⟨h, h'⟩ => .inl ⟨congrArg (RegimeMargin.step (heater 3 2) 1) h,
        congrArg (RegimeMargin.step RegimeMargin.Alternation.giving 1) h'⟩

/-- **The overshooting thermostat's window course is `RegimeMargin.Alternation`'s run shifted by
two**, so `Overshooting.alternates` and `Overshooting.holds_one_way` are that witness's
(`RegimeMargin.Alternation.alternates`: overcompensating giving cycles for ever). -/
theorem Overshooting.alternation_shifted (n : Nat) :
    (windowRun 3 2).state n =
      (Law.run (RegimeMargin.step RegimeMargin.Alternation.giving 1) 1).state n + 2 :=
  match Overshooting.in_phase n with
  | .inl ⟨h, h'⟩ => h.trans (congrArg (· + 2) h').symm
  | .inr ⟨h, h'⟩ => h.trans (congrArg (· + 2) h').symm

/-- Nor does anything read off the unheated room's: it stays at `0` from the step of its margin. -/
theorem Unheated.not_widening (m : Nat) {X : Type} (F : Nat → X → Prop) :
    ¬ Reaching.KeepsWidening (fun n => F ((windowRun m 0).state n)) :=
  Run.not_keepsWidening_of_returns (windowRun m 0) F (N := m) fun d =>
    ⟨m + d, Nat.le_refl _,
     ((windowAt_level m 0 (m + d)).symm.trans (Unheated.window_cold m d)).trans
       ((windowAt_level m 0 (m + 0)).symm.trans (Unheated.window_cold m 0)).symm⟩

/-- Nor off the matched thermostat's: it stays at its set level. -/
theorem Matched.not_widening {m : Nat} (hm : 1 ≤ m) {X : Type} (F : Nat → X → Prop) :
    ¬ Reaching.KeepsWidening (fun n => F ((windowRun m 1).state n)) :=
  Run.not_keepsWidening_of_returns (windowRun m 1) F (N := 0) fun d =>
    ⟨d, Nat.le_of_eq (Nat.zero_add d),
     ((windowAt_level m 1 d).symm.trans (Matched.window_held hm d)).trans
       ((windowAt_level m 1 0).symm.trans (Matched.window_held hm 0)).symm⟩

/-! ## The possible with warmth held -/

/-- A room as a process: the act says whether the window opens now. -/
def process (m c : Nat) : Process Occurrence Bool :=
  ⟨fun s a t => t = ⟨s.opened || a, next m c (surroundings m (s.opened || a)) s.level⟩⟩

/-- The net's steps are the process's. -/
theorem steps_of_net {m c : Nat} : ∀ {s t : Occurrence}, net m c s t → Steps (process m c) s t
  | ⟨false, _⟩, ⟨false, _⟩, ⟨_, e⟩ => ⟨false, congrArg (Occurrence.mk false) e⟩
  | ⟨false, _⟩, ⟨true, _⟩, ⟨_, e⟩ => ⟨true, congrArg (Occurrence.mk true) e⟩
  | ⟨true, _⟩, ⟨true, _⟩, ⟨_, e⟩ => ⟨true, congrArg (Occurrence.mk true) e⟩
  | ⟨true, _⟩, ⟨false, _⟩, ⟨.inl h, _⟩ => Bool.noConfusion h
  | ⟨true, _⟩, ⟨false, _⟩, ⟨.inr h, _⟩ => Bool.noConfusion h

/-- The process's steps are the net's. -/
theorem net_of_steps {m c : Nat} : ∀ {s t : Occurrence}, Steps (process m c) s t → net m c s t
  | ⟨false, l⟩, _, ⟨_, e⟩ => Eq.subst (motive := net m c ⟨false, l⟩) e.symm ⟨.inl rfl, rfl⟩
  | ⟨true, l⟩, _, ⟨_, e⟩ => Eq.subst (motive := net m c ⟨true, l⟩) e.symm ⟨.inr rfl, rfl⟩

/-- **A coarse line is the possible with warmth held**: what warmth's line reaches from `x` is what
the moves holding warmth reach (`Reaching.reach_heldMoves_iff`). -/
theorem line_iff_held {m c : Nat} {x y : Occurrence} :
    «所及» (net m c) alike x y ↔ Reach (Reaching.heldMoves (process m c) alike) x y :=
  have to : «则» («续» (Steps (process m c)) alike) («续» (net m c) alike) :=
    fun _ _ ⟨s, a⟩ => ⟨net_of_steps s, a⟩
  have fro : «则» («续» (net m c) alike) («续» (Steps (process m c)) alike) :=
    fun _ _ ⟨s, a⟩ => ⟨steps_of_net s, a⟩
  ⟨fun h => Reaching.reach_heldMoves_iff.mpr (match h with
     | .inl e => .inl e
     | .inr l => .inr («及之单调» fro _ _ l)),
   fun h => match Reaching.reach_heldMoves_iff.mp h with
     | .inl e => .inl e
     | .inr l => .inr («及之单调» to _ _ l)⟩

/-- **At a margin of three the unheated room's cold occurrence is possible, but not with warmth
held.** -/
theorem Unheated.cold_not_held :
    Reaching.Possible (process 3 0) (fun s x => s = x) (start 3) Unheated.b0 ∧
      ¬ Reaching.PossibleHeld (process 3 0) alike (fun s x => s = x) (start 3) Unheated.b0 :=
  ⟨⟨Unheated.b0,
    Reach.trans (Reach.of_step (P := process 3 0) (s := start 3) (t := Unheated.b2) (a := true) rfl)
      (Reach.trans
        (Reach.of_step (P := process 3 0) (s := Unheated.b2) (t := Unheated.b1) (a := true) rfl)
        (Reach.of_step (P := process 3 0) (s := Unheated.b1) (t := Unheated.b0) (a := true) rfl)),
    rfl⟩,
   fun held => match Reaching.possibleHeld_iff_line.mp held with
     | .inl e => Bool.noConfusion (congrArg Occurrence.opened e)
     | .inr ⟨_, l, e⟩ =>
       Bool.noConfusion (Eq.subst (motive := fun z => alike (start 3) z) e («线内同类» alike_class l))⟩

/-- In a heated room with a positive set level, a trace from a warm occurrence is made of moves
holding warmth. -/
theorem heated_held {m c : Nat} (hm : 1 ≤ m) (hc : 1 ≤ c) : ∀ {x t : Occurrence} {as : List Bool},
    warm x = true → Trace (process m c) x as t → Reach (Reaching.heldMoves (process m c) alike) x t
  | _, _, _, _, .nil _ => Reach.refl _ _
  | _, _, _, wx, .cons step rest =>
    have wm := heated_warm hm hc (net_of_steps ⟨_, step⟩)
    Reach.trans (Reach.of_step ⟨step, wx.trans wm.symm⟩) (heated_held hm hc wm rest)

/-- **A heated room's possible from a warm occurrence is all possible with warmth held.** -/
theorem heated_possible_held {m c : Nat} (hm : 1 ≤ m) (hc : 1 ≤ c) {X : Type}
    {adm : Occurrence → X → Prop} {x : Occurrence} (wx : warm x = true) {y : X}
    (possible : Reaching.Possible (process m c) adm x y) :
    Reaching.PossibleHeld (process m c) alike adm x y :=
  match possible with
  | ⟨t, ⟨_, trace⟩, admitted⟩ => ⟨t, heated_held hm hc wx trace, admitted⟩

end Rooms

end Becoming
