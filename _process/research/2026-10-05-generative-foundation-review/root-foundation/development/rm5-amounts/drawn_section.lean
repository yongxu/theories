/-! ## The regime in any amounts

The laws above read amounts in whole numbers, where every change moves an amount by at least one, so
a run within a band comes to rest. `Drawn` reads them in any amounts with a linear order and a draw
taken first, as much as there is: the non-negative rationals or reals as well as the whole numbers.
There a run need not come to rest, and what holds is the shape of its course: the adjusted step
keeps the order of states; from the first step on, a step that neither raises nor lowers both the
level and the recent giving moves the recent giving strictly toward the draw from the side it
stands on and the level the other way, and the next such step is of the same kind; a step that raises
or lowers both is followed by such steps for ever. So each of the two moves one way, turns at most
once, and then moves one way again. The rests are the regime's point and the states below the draw
with level and recent giving equal. In whole numbers the step is the adjusted step above. -/

/-- **Amounts with a draw.** Amounts linearly ordered, with `sub a b` what is left of `a` once `b`
is taken, as much as there is: all but `b` where `b` is within `a`, and nothing where it is not. -/
structure Drawn (V : Type) extends Amounts V where
  sub : V → V → V
  add_sub : ∀ {a b : V}, le b a → add b (sub a b) = a
  sub_zero : ∀ {a b : V}, le a b → sub a b = zero
  total : ∀ a b, le a b ∨ le b a
  antisymm : ∀ {a b : V}, le a b → le b a → a = b

namespace Drawn

variable {V : Type} (D : Drawn V)

/-- One step of a condition whose giving adjusts, in amounts with a draw: the draw `H` takes first,
as much as there is; the giving is `A` of what is left and of the recent giving; the next level is
what is left with that giving, which is the next step's recent giving. -/
def step (A : V → V → V) (H : V) (p : V × V) : V × V :=
  (D.add (D.sub p.1 H) (A (D.sub p.1 H) p.2), A (D.sub p.1 H) p.2)

/-- The adjusted giving rises with what is left and with the recent giving. -/
def Rises (A : V → V → V) : Prop := ∀ e e' r r', D.le e e' → D.le r r' → D.le (A e r) (A e' r')

/-- One state at or below another, in level and in recent giving. -/
def Below (p q : V × V) : Prop := D.le p.1 q.1 ∧ D.le p.2 q.2

/-- **A climbing step**: the level rises strictly and the recent giving falls strictly, staying
strictly above the draw. -/
def Climbs (H : V) (p q : V × V) : Prop :=
  D.le p.1 q.1 ∧ ¬ D.le q.1 p.1 ∧ D.le q.2 p.2 ∧ ¬ D.le p.2 q.2 ∧ ¬ D.le q.2 H

/-- **A sinking step**: the level falls strictly and the recent giving rises strictly, staying
strictly below the draw. -/
def Sinks (H : V) (p q : V × V) : Prop :=
  D.le q.1 p.1 ∧ ¬ D.le p.1 q.1 ∧ D.le p.2 q.2 ∧ ¬ D.le q.2 p.2 ∧ ¬ D.le H q.2

/-- The adjusted step keeps every state whose level and recent giving are within `hi` at a level
within `hi`. -/
def Band (A : V → V → V) (H hi : V) : Prop :=
  ∀ x r, D.le x hi → D.le r hi → D.le (D.step A H (x, r)).1 hi

variable {D}

theorem add_cancel {a b c : V} (le : D.le (D.add a b) (D.add a c)) : D.le b c :=
  D.le_of_add_le_add_right a (by rw [D.add_comm b a, D.add_comm c a]; exact le)

/-- What is left after the draw rises with the level. -/
theorem sub_mono {x y : V} (H : V) (le : D.le x y) : D.le (D.sub x H) (D.sub y H) :=
  (D.total H x).elim
    (fun high => add_cancel (a := H) (by
      rw [D.add_sub high, D.add_sub (D.le_trans high le)]; exact le))
    (fun low => by rw [D.sub_zero low]; exact D.zero_le _)

/-- **The adjusted step keeps the order of states** where the adjustment rises. -/
theorem step_mono {A : V → V → V} (rises : D.Rises A) (H : V) {p q : V × V} (below : D.Below p q) :
    D.Below (D.step A H p) (D.step A H q) :=
  have left := sub_mono H below.1
  have given := rises _ _ _ _ left below.2
  ⟨D.le_trans (D.add_le_add_right _ left) (Amounts.add_le_add_left _ given), given⟩

/-- After a step the recent giving is within the level. -/
theorem given_le_level (A : V → V → V) (H : V) (p : V × V) :
    D.le (D.step A H p).2 (D.step A H p).1 :=
  Amounts.le_add_left _ _

/-- At or above the draw, the level rises over a step exactly where the new giving meets the draw. -/
theorem level_up_iff {A : V → V → V} {H : V} {p : V × V} (high : D.le H p.1) :
    D.le p.1 (D.step A H p).1 ↔ D.le H (D.step A H p).2 :=
  have split : p.1 = D.add (D.sub p.1 H) H := ((D.add_comm _ _).trans (D.add_sub high)).symm
  ⟨fun le => add_cancel (a := D.sub p.1 H) (c := A (D.sub p.1 H) p.2)
      (D.le_trans (Amounts.le_of_eq split.symm) le),
   fun le => D.le_trans (Amounts.le_of_eq split) (Amounts.add_le_add_left _ le)⟩

/-- At or above the draw, the level falls over a step exactly where the new giving is within the
draw. -/
theorem level_down_iff {A : V → V → V} {H : V} {p : V × V} (high : D.le H p.1) :
    D.le (D.step A H p).1 p.1 ↔ D.le (D.step A H p).2 H :=
  have split : p.1 = D.add (D.sub p.1 H) H := ((D.add_comm _ _).trans (D.add_sub high)).symm
  ⟨fun le => add_cancel (a := D.sub p.1 H) (b := A (D.sub p.1 H) p.2)
      (D.le_trans le (Amounts.le_of_eq split)),
   fun le => D.le_trans (Amounts.add_le_add_left _ le) (Amounts.le_of_eq split.symm)⟩

/-- At or below the draw, the draw takes everything and the level after a step is the new giving. -/
theorem level_of_low {A : V → V → V} {H : V} {p : V × V} (low : D.le p.1 H) :
    (D.step A H p).1 = (D.step A H p).2 := by
  show D.add (D.sub p.1 H) (A (D.sub p.1 H) p.2) = A (D.sub p.1 H) p.2
  rw [D.sub_zero low]; exact D.zero_add _

/-- **A step that neither raises nor lowers both climbs or sinks.** From a state whose recent giving
is within its level, a step that leaves the level and the recent giving neither both risen nor both
fallen raises the level strictly while the recent giving falls strictly toward the draw from above,
or lowers it strictly while the recent giving rises strictly toward the draw from below. -/
theorem climbs_or_sinks {A : V → V → V} {H : V} {p : V × V} (within : D.le p.2 p.1)
    (notUp : ¬ D.Below p (D.step A H p)) (notDown : ¬ D.Below (D.step A H p) p) :
    D.Climbs H p (D.step A H p) ∨ D.Sinks H p (D.step A H p) :=
  (D.total H p.1).elim
    (fun high => (D.total p.2 (D.step A H p).2).elim
      (fun up =>
        have notRise : ¬ D.le H (D.step A H p).2 := fun h => notUp ⟨(level_up_iff high).2 h, up⟩
        have fall : D.le (D.step A H p).1 p.1 :=
          (level_down_iff high).2 ((D.total H (D.step A H p).2).elim (fun h => absurd h notRise) id)
        Or.inr ⟨fall, fun h => notRise ((level_up_iff high).1 h), up, fun h => notDown ⟨fall, h⟩,
          notRise⟩)
      (fun down =>
        have notFall : ¬ D.le (D.step A H p).2 H := fun h => notDown ⟨(level_down_iff high).2 h, down⟩
        have rise : D.le p.1 (D.step A H p).1 :=
          (level_up_iff high).2 ((D.total H (D.step A H p).2).elim id (fun h => absurd h notFall))
        Or.inl ⟨rise, fun h => notFall ((level_down_iff high).1 h), down, fun h => notUp ⟨rise, h⟩,
          notFall⟩))
    (fun low =>
      have same := level_of_low (A := A) low
      (D.total p.2 (D.step A H p).2).elim
        (fun up =>
          have notRise : ¬ D.le p.1 (D.step A H p).2 := fun h =>
            notUp ⟨D.le_trans h (Amounts.le_of_eq same.symm), up⟩
          have fall : D.le (D.step A H p).1 p.1 := D.le_trans (Amounts.le_of_eq same)
            ((D.total p.1 (D.step A H p).2).elim (fun h => absurd h notRise) id)
          Or.inr ⟨fall, fun h => notRise (D.le_trans h (Amounts.le_of_eq same)), up,
            fun h => notDown ⟨fall, h⟩, fun h => notRise (D.le_trans low h)⟩)
        (fun down => absurd ⟨D.le_trans (Amounts.le_of_eq same) (D.le_trans down within), down⟩
          notDown))

/-- **A climb is followed by a climb, or by a step raising or lowering both.** -/
theorem climbs_next {A : V → V → V} {H : V} {p : V × V} (climbs : D.Climbs H p (D.step A H p))
    (notUp : ¬ D.Below (D.step A H p) (D.step A H (D.step A H p)))
    (notDown : ¬ D.Below (D.step A H (D.step A H p)) (D.step A H p)) :
    D.Climbs H (D.step A H p) (D.step A H (D.step A H p)) :=
  (climbs_or_sinks (given_le_level A H p) notUp notDown).elim id fun sinks =>
    absurd (D.le_trans ((D.total (D.step A H p).2 H).elim (fun h => absurd h climbs.2.2.2.2) id)
      sinks.2.2.1) sinks.2.2.2.2

/-- **A sink is followed by a sink, or by a step raising or lowering both.** -/
theorem sinks_next {A : V → V → V} {H : V} {p : V × V} (sinks : D.Sinks H p (D.step A H p))
    (notUp : ¬ D.Below (D.step A H p) (D.step A H (D.step A H p)))
    (notDown : ¬ D.Below (D.step A H (D.step A H p)) (D.step A H p)) :
    D.Sinks H (D.step A H p) (D.step A H (D.step A H p)) :=
  (climbs_or_sinks (given_le_level A H p) notUp notDown).elim (fun climbs =>
    absurd (D.le_trans climbs.2.2.1
      ((D.total (D.step A H p).2 H).elim id (fun h => absurd h sinks.2.2.2.2))) climbs.2.2.2.2) id

/-- **The rests in any amounts.** A state the adjusted step leaves as it is lies at or above the draw
with the recent giving at the draw and the adjustment giving the draw from what is left, the regime's
point; or within the draw, with the level and the recent giving equal and the adjustment from nothing
left giving it again. -/
theorem rest_iff {A : V → V → V} {H : V} {p : V × V} :
    D.step A H p = p ↔ (p.2 = H ∧ D.le H p.1 ∧ A (D.sub p.1 H) H = H) ∨
      (D.le p.1 H ∧ p.1 = p.2 ∧ A D.zero p.2 = p.2) :=
  ⟨fun fixed =>
    have level : D.add (D.sub p.1 H) (A (D.sub p.1 H) p.2) = p.1 := congrArg Prod.fst fixed
    have given : A (D.sub p.1 H) p.2 = p.2 := congrArg Prod.snd fixed
    (D.total H p.1).elim
      (fun high =>
        have split : D.add (D.sub p.1 H) H = D.add (D.sub p.1 H) p.2 := by
          rw [D.add_comm (D.sub p.1 H) H, D.add_sub high, ← given, level]
        have same : p.2 = H := D.antisymm (add_cancel (Amounts.le_of_eq split.symm))
          (add_cancel (Amounts.le_of_eq split))
        Or.inl ⟨same, high, by have g := given; rw [same] at g; exact g⟩)
      (fun low =>
        have gone : D.sub p.1 H = D.zero := D.sub_zero low
        Or.inr ⟨low, by rw [gone, D.zero_add] at level; rw [gone] at given; rw [← level, given],
          by rw [gone] at given; exact given⟩),
   fun rest => rest.elim
    (fun ⟨same, high, gives⟩ => by
      show (D.add (D.sub p.1 H) (A (D.sub p.1 H) p.2), A (D.sub p.1 H) p.2) = p
      rw [same, gives, D.add_comm, D.add_sub high, ← same])
    (fun ⟨low, same, gives⟩ => by
      show (D.add (D.sub p.1 H) (A (D.sub p.1 H) p.2), A (D.sub p.1 H) p.2) = p
      rw [D.sub_zero low, gives, D.zero_add]
      exact Prod.ext same.symm rfl)⟩

/-! ### Along a run -/

/-- A run whose step at `n` raises both raises both at every later step. -/
theorem rising_on {A : V → V → V} (rises : D.Rises A) (H : V) (s : V × V) {n : Nat}
    (up : D.Below ((Law.run (D.step A H) s).state n) ((Law.run (D.step A H) s).state (n + 1))) :
    ∀ k, D.Below ((Law.run (D.step A H) s).state (n + k))
      ((Law.run (D.step A H) s).state (n + k + 1)) := fun k => by
  show D.Below (Law.orbit (D.step A H) s (n + k)) (Law.orbit (D.step A H) s (n + k + 1))
  rw [Law.orbit_add _ s n k, Nat.add_right_comm, Law.orbit_add _ s (n + 1) k]
  exact Lasting.orbit_mono (rel := D.Below) (fun _ _ b => step_mono rises H b) up k

/-- A run whose step at `n` lowers both lowers both at every later step. -/
theorem falling_on {A : V → V → V} (rises : D.Rises A) (H : V) (s : V × V) {n : Nat}
    (down : D.Below ((Law.run (D.step A H) s).state (n + 1)) ((Law.run (D.step A H) s).state n)) :
    ∀ k, D.Below ((Law.run (D.step A H) s).state (n + k + 1))
      ((Law.run (D.step A H) s).state (n + k)) := fun k => by
  show D.Below (Law.orbit (D.step A H) s (n + k + 1)) (Law.orbit (D.step A H) s (n + k))
  rw [Law.orbit_add _ s n k, Nat.add_right_comm, Law.orbit_add _ s (n + 1) k]
  exact Lasting.orbit_mono (rel := D.Below) (fun _ _ b => step_mono rises H b) down k

/-- A run from a state within a band stays within it, in level and in recent giving. -/
theorem run_within {A : V → V → V} {H hi : V} (band : D.Band A H hi) {s : V × V}
    (high : D.le s.1 hi) (given : D.le s.2 hi) :
    ∀ n, D.le ((Law.run (D.step A H) s).state n).1 hi ∧ D.le ((Law.run (D.step A H) s).state n).2 hi
  | 0 => ⟨high, given⟩
  | n + 1 =>
    have ih := run_within band high given n
    have top := band _ _ ih.1 ih.2
    ⟨top, D.le_trans (given_le_level A H _) top⟩

/-- **The shape of a run in any amounts.** From the first step on, a step of the run that neither
raises nor lowers both the level and the recent giving climbs or sinks, and the step after a climb
(a sink) that neither raises nor lowers both climbs (sinks) too; a step that raises (lowers) both is
followed by such steps for ever. -/
theorem run_shape {A : V → V → V} (rises : D.Rises A) (H : V) (s : V × V) (n : Nat) :
    (¬ D.Below ((Law.run (D.step A H) s).state (n + 1)) ((Law.run (D.step A H) s).state (n + 2)) →
      ¬ D.Below ((Law.run (D.step A H) s).state (n + 2)) ((Law.run (D.step A H) s).state (n + 1)) →
      D.Climbs H ((Law.run (D.step A H) s).state (n + 1)) ((Law.run (D.step A H) s).state (n + 2)) ∨
      D.Sinks H ((Law.run (D.step A H) s).state (n + 1)) ((Law.run (D.step A H) s).state (n + 2))) ∧
    (D.Climbs H ((Law.run (D.step A H) s).state n) ((Law.run (D.step A H) s).state (n + 1)) →
      ¬ D.Below ((Law.run (D.step A H) s).state (n + 1)) ((Law.run (D.step A H) s).state (n + 2)) →
      ¬ D.Below ((Law.run (D.step A H) s).state (n + 2)) ((Law.run (D.step A H) s).state (n + 1)) →
      D.Climbs H ((Law.run (D.step A H) s).state (n + 1)) ((Law.run (D.step A H) s).state (n + 2))) ∧
    (D.Sinks H ((Law.run (D.step A H) s).state n) ((Law.run (D.step A H) s).state (n + 1)) →
      ¬ D.Below ((Law.run (D.step A H) s).state (n + 1)) ((Law.run (D.step A H) s).state (n + 2)) →
      ¬ D.Below ((Law.run (D.step A H) s).state (n + 2)) ((Law.run (D.step A H) s).state (n + 1)) →
      D.Sinks H ((Law.run (D.step A H) s).state (n + 1)) ((Law.run (D.step A H) s).state (n + 2))) ∧
    (D.Below ((Law.run (D.step A H) s).state n) ((Law.run (D.step A H) s).state (n + 1)) →
      ∀ k, D.Below ((Law.run (D.step A H) s).state (n + k))
        ((Law.run (D.step A H) s).state (n + k + 1))) ∧
    (D.Below ((Law.run (D.step A H) s).state (n + 1)) ((Law.run (D.step A H) s).state n) →
      ∀ k, D.Below ((Law.run (D.step A H) s).state (n + k + 1))
        ((Law.run (D.step A H) s).state (n + k))) :=
  ⟨climbs_or_sinks (p := Law.orbit (D.step A H) s (n + 1)) (given_le_level A H (Law.orbit (D.step A H) s n)),
   climbs_next (p := Law.orbit (D.step A H) s n), sinks_next (p := Law.orbit (D.step A H) s n),
   rising_on rises H s, falling_on rises H s⟩

/-- **A run rests exactly at a rest.** The run is still from step `T` exactly where its state there
is the regime's point or a state within the draw with level and recent giving equal that the
adjustment from nothing left gives again. -/
theorem still_iff {A : V → V → V} {H : V} {s : V × V} {T : Nat} :
    LastChange.StillFrom (Law.run (D.step A H) s) T ↔
      (((Law.run (D.step A H) s).state T).2 = H ∧ D.le H ((Law.run (D.step A H) s).state T).1 ∧
        A (D.sub ((Law.run (D.step A H) s).state T).1 H) H = H) ∨
      (D.le ((Law.run (D.step A H) s).state T).1 H ∧
        ((Law.run (D.step A H) s).state T).1 = ((Law.run (D.step A H) s).state T).2 ∧
        A D.zero ((Law.run (D.step A H) s).state T).2 = ((Law.run (D.step A H) s).state T).2) :=
  ⟨fun still => rest_iff.1 (still 0 : D.step A H (Law.orbit (D.step A H) s T) = _),
   fun rest k => by
    have fixed : D.step A H (Law.orbit (D.step A H) s T) = Law.orbit (D.step A H) s T := rest_iff.2 rest
    have stays : Law.orbit (D.step A H) (Law.orbit (D.step A H) s T) k = Law.orbit (D.step A H) s T :=
      (congrArg (Law.orbit (D.step A H) (Law.orbit (D.step A H) s T)) (Nat.one_mul k)).symm.trans
        (Law.orbit_mul (next := D.step A H) (s := Law.orbit (D.step A H) s T) (p := 1) fixed k)
    show D.step A H (Law.orbit (D.step A H) s (T + k)) = Law.orbit (D.step A H) s (T + k)
    rw [Law.orbit_add _ s T k, stays]
    exact fixed⟩

/-- **Whole numbers are an instance**, with the draw taking all but what it takes where it is within
the level, and everything where it is not. -/
def whole : Drawn Nat where
  toAmounts := Amounts.whole
  sub := (· - ·)
  add_sub := fun le => Becoming.add_sub_of_le le
  sub_zero := fun le => sub_eq_zero_of_le le
  total := Nat.le_total
  antisymm := Nat.le_antisymm

/-- In whole numbers the run of the adjusted step in amounts with a draw is the run of the adjusted
step, and its order and its rising adjustments are theirs. -/
theorem whole_run (A : Nat → Nat → Nat) (H : Nat) (s : Nat × Nat) :
    Law.run (whole.step A H) s = Law.run (Adjusted.step A H) s ∧
      (whole.Rises A ↔ Adjusted.Rises A) ∧ (∀ p q, whole.Below p q ↔ Adjusted.Below p q) :=
  ⟨rfl, Iff.rfl, fun _ _ => Iff.rfl⟩

end Drawn
