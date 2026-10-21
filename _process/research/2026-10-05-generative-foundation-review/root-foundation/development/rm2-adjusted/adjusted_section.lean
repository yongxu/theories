/-! ## Giving that adjusts

The step above reads giving off what the draw leaves, alone. A condition can carry what it gave
before: its state is its level and its recent giving, and the giving at a step is a law `A` of what
is left and of the recent giving, which is the next step's recent giving. The regime's step is the
case where `A` reads what is left alone (`orbit_regime`); the frozen rest, which holds the giving
as it was, the case where it reads the recent giving alone. Every law of this section holds over
every such `A` with the properties it names, and the laws of the regime's step below are their
case. -/

namespace Adjusted

/-- One step of a condition whose giving adjusts. At level `p.1` with recent giving `p.2`, the draw
`H` takes first, as much as there is; the giving is `A` of what is left and of the recent giving;
the next level is what is left with that giving, which is the next step's recent giving. -/
def step (A : Nat → Nat → Nat) (H : Nat) (p : Nat × Nat) : Nat × Nat :=
  (p.1 - H + A (p.1 - H) p.2, A (p.1 - H) p.2)

/-- Where the recent giving and the regime's giving both fall short of the draw, so does the
adjusted giving. -/
def StaysShort (A : Nat → Nat → Nat) (g : Nat → Nat) (H : Nat) : Prop :=
  ∀ e r, r < H → g e < H → A e r < H

/-- Where the recent giving and the regime's giving both meet the draw, so does the adjusted
giving. -/
def StaysMet (A : Nat → Nat → Nat) (g : Nat → Nat) (H : Nat) : Prop :=
  ∀ e r, H ≤ r → H ≤ g e → H ≤ A e r

/-- The adjusted giving rests at the draw exactly where the regime gives the draw. -/
def RestsAtDraw (A : Nat → Nat → Nat) (g : Nat → Nat) (H : Nat) : Prop :=
  ∀ e, A e H = H ↔ g e = H

/-- From nothing left the adjusted giving is nothing, whatever was given before. -/
def FromNothing (A : Nat → Nat → Nat) : Prop := ∀ r, A 0 r = 0

/-- The adjusted step keeps every level up to `hi` within `hi` where the recent giving meets the
draw. -/
def Keeps (A : Nat → Nat → Nat) (H hi : Nat) : Prop :=
  ∀ x r, x ≤ hi → H ≤ r → (step A H (x, r)).1 ≤ hi

/-- The adjusted giving lies between the recent giving and the regime's giving. -/
def Between (A : Nat → Nat → Nat) (g : Nat → Nat) : Prop :=
  ∀ e r, (r ≤ A e r ∧ A e r ≤ g e) ∨ (g e ≤ A e r ∧ A e r ≤ r)

/-- The adjusted giving moves wherever it differs from the regime's: it rests only there. -/
def Settles (A : Nat → Nat → Nat) (g : Nat → Nat) : Prop :=
  ∀ e r, A e r = r → r = g e

/-! ### The regime's step and the frozen rest as cases -/

/-- **The regime's step is the case reading what is left alone**: along every run, the level of
the adjusted state whose giving is the regime's is the run of the regime's step. -/
theorem orbit_regime (g : Nat → Nat) (H : Nat) (p : Nat × Nat) :
    ∀ n, (Law.orbit (step (fun e _ => g e) H) p n).1 = Law.orbit (RegimeMargin.step g H) p.1 n
  | 0 => rfl
  | n + 1 => congrArg (RegimeMargin.step g H) (orbit_regime g H p n)

theorem regime_staysShort (g : Nat → Nat) (H : Nat) : StaysShort (fun e _ => g e) g H :=
  fun _ _ _ short => short

theorem regime_staysMet (g : Nat → Nat) (H : Nat) : StaysMet (fun e _ => g e) g H :=
  fun _ _ _ met => met

theorem regime_fromNothing {g : Nat → Nat} (nothing : RegimeMargin.FromNothing g) :
    FromNothing (fun e _ => g e) :=
  fun _ => nothing

theorem regime_keeps {g : Nat → Nat} {H hi : Nat} (keeps : RegimeMargin.Keeps g H hi) :
    Keeps (fun e _ => g e) H hi :=
  fun x _ high _ => keeps x high

/-- Giving between the recent giving and the regime's stays short of the draw where both are. -/
theorem Between.staysShort {A : Nat → Nat → Nat} {g : Nat → Nat} (between : Between A g)
    (H : Nat) : StaysShort A g H :=
  fun e r rshort gshort => (between e r).elim
    (fun ⟨_, le⟩ => Nat.lt_of_le_of_lt le gshort)
    (fun ⟨_, le⟩ => Nat.lt_of_le_of_lt le rshort)

/-- Giving between the recent giving and the regime's meets the draw where both do. -/
theorem Between.staysMet {A : Nat → Nat → Nat} {g : Nat → Nat} (between : Between A g)
    (H : Nat) : StaysMet A g H :=
  fun e r rmet gmet => (between e r).elim
    (fun ⟨ge, _⟩ => Nat.le_trans rmet ge)
    (fun ⟨ge, _⟩ => Nat.le_trans gmet ge)

/-- Giving between the recent giving and the regime's, moving wherever it differs from the
regime's, rests at the draw exactly where the regime gives the draw. -/
theorem Between.restsAtDraw {A : Nat → Nat → Nat} {g : Nat → Nat} (between : Between A g)
    (settles : Settles A g) (H : Nat) : RestsAtDraw A g H :=
  fun e => ⟨fun rest => (settles e H rest).symm,
    fun gives => (between e H).elim
      (fun ⟨ge, le⟩ => Nat.le_antisymm (Nat.le_trans le (Nat.le_of_eq gives)) ge)
      (fun ⟨ge, le⟩ => Nat.le_antisymm le (Nat.le_trans (Nat.le_of_eq gives.symm) ge))⟩

/-- The frozen rest, which holds the giving as it was, lies between the recent giving and the
regime's. -/
theorem frozen_between (g : Nat → Nat) : Between (fun _ r => r) g :=
  fun e r => (Nat.le_total r (g e)).elim
    (fun le => Or.inl ⟨Nat.le_refl r, le⟩)
    (fun ge => Or.inr ⟨ge, Nat.le_refl r⟩)

/-- **The frozen rest rests everywhere at the draw.** Holding the giving at the draw, every level at
or above the draw is left as it is, whatever the regime gives there. -/
theorem frozen_rests {H x : Nat} (atLeast : H ≤ x) : step (fun _ r => r) H (x, H) = (x, H) :=
  congrArg (fun a => (a, H)) (Naturals.sub_add_cancel atLeast)

/-! ### Where the state rests -/

/-- **At or above the draw, every rest point is the regime's.** Where the adjusted giving rests at
the draw exactly where the regime gives the draw, a level at or above the draw with a recent giving
is left as it is by the step exactly where the recent giving is the draw and the regime's step
leaves the level as it is: wherever a run of such an adjustment comes to rest at or above the draw,
whatever its rate, its memory or its pull toward the draw, it rests at a point the regime's step
leaves as it is. -/
theorem rest_iff {A : Nat → Nat → Nat} {g : Nat → Nat} {H x r : Nat} (rests : RestsAtDraw A g H)
    (atLeast : H ≤ x) : step A H (x, r) = (x, r) ↔ r = H ∧ RegimeMargin.step g H x = x := by
  have back : x - H + H = x := Naturals.sub_add_cancel atLeast
  constructor
  · intro fixed
    have level : x - H + A (x - H) r = x := congrArg Prod.fst fixed
    have giving : A (x - H) r = r := congrArg Prod.snd fixed
    have draw : A (x - H) r = H := Naturals.add_left_cancel (level.trans back.symm)
    have rH : r = H := giving.symm.trans draw
    have atDraw : A (x - H) H = H := Eq.subst (motive := fun v => A (x - H) v = v) rH giving
    refine ⟨rH, ?_⟩
    show x - H + g (x - H) = x
    rw [(rests (x - H)).1 atDraw]
    exact back
  · intro ⟨rH, fixed⟩
    have gives : g (x - H) = H :=
      Naturals.add_left_cancel ((show x - H + g (x - H) = x from fixed).trans back.symm)
    have atDraw : A (x - H) H = H := (rests (x - H)).2 gives
    have ar : A (x - H) r = r := (congrArg (A (x - H)) rH).trans (atDraw.trans rH.symm)
    show (x - H + A (x - H) r, A (x - H) r) = (x, r)
    rw [ar, rH, back]

/-- **On the run, every rest at or above the draw is the regime's.** Where the adjusted giving rests
at the draw exactly where the regime gives the draw, the run from a level at or above the draw with
a recent giving stays where it started exactly where the recent giving is the draw and the regime's
run from the level stays at the level. -/
theorem rests_iff {A : Nat → Nat → Nat} {g : Nat → Nat} {H x r : Nat} (rests : RestsAtDraw A g H)
    (atLeast : H ≤ x) :
    (∀ n, (Law.run (step A H) (x, r)).state n = (x, r)) ↔
      r = H ∧ ∀ n, (Law.run (RegimeMargin.step g H) x).state n = x :=
  ⟨fun stays =>
    have ⟨rH, fixed⟩ := (rest_iff rests atLeast).1 (stays 1)
    ⟨rH, fun n => (congrArg (Law.orbit (RegimeMargin.step g H) x) (Nat.one_mul n)).symm.trans
      (Law.orbit_mul (next := RegimeMargin.step g H) (s := x) (p := 1) fixed n)⟩,
   fun ⟨rH, stays⟩ =>
    have fixed := (rest_iff rests atLeast).2 ⟨rH, stays 1⟩
    fun n => (congrArg (Law.orbit (step A H) (x, r)) (Nat.one_mul n)).symm.trans
      (Law.orbit_mul (next := step A H) (s := (x, r)) (p := 1) fixed n)⟩

/-- **Every giving between the recent and the regime's that moves wherever it differs from the
regime's rests on the run only at the regime's point**: at or above the draw, its run stays where it
started exactly where the recent giving is the draw and the regime's run stays at the level. -/
theorem Between.rests_iff {A : Nat → Nat → Nat} {g : Nat → Nat} {H x r : Nat}
    (between : Between A g) (settles : Settles A g) (atLeast : H ≤ x) :
    (∀ n, (Law.run (step A H) (x, r)).state n = (x, r)) ↔
      r = H ∧ ∀ n, (Law.run (RegimeMargin.step g H) x).state n = x :=
  Adjusted.rests_iff (between.restsAtDraw settles H) atLeast

/-! ### Below the point of no return -/

/-- The draw is positive where giving falls short of it below `y` and a level lies below `H + y`. -/
theorem draw_pos {g : Nat → Nat} {H y x : Nat} (short : Short g H y) (below : x < H + y) :
    0 < H :=
  (Nat.eq_zero_or_pos H).elim
    (fun zero => by
      subst zero
      have ypos : 0 < y := Nat.lt_of_le_of_lt (Nat.zero_le x)
        (Nat.lt_of_lt_of_le below (Nat.le_of_eq (Nat.zero_add y)))
      exact absurd (short 0 ypos) (Nat.not_lt_zero (g 0)))
    id

/-- What the draw leaves falls by at least one at a step whose giving falls short of the draw,
unless nothing is left. -/
theorem left_falls {d a H : Nat} (gives : a < H) : d + a - H ≤ d - 1 :=
  (Nat.lt_or_ge (d + a) H).elim
    (fun small => by rw [sub_eq_zero_of_le (Nat.le_of_lt small)]; exact Nat.zero_le _)
    (fun big => by
      have sum : d + a - H + H = d + a := Naturals.sub_add_cancel big
      have lt : d + a - H + 1 + H ≤ d + H := by
        rw [Nat.add_right_comm, sum]; exact Nat.add_lt_add_left gives d
      have one : 1 + (d + a - H) ≤ d := by
        rw [Nat.add_comm]; exact Naturals.le_of_add_le_add_right lt
      exact Naturals.le_sub_of_add_le one)

/-- Below the point of no return, what the draw leaves is below the point's distance above the
draw. -/
theorem left_below {H y x : Nat} (ypos : 0 < y) (below : x < H + y) : x - H < y :=
  (Nat.lt_or_ge x H).elim
    (fun lt => by rw [sub_eq_zero_of_le (Nat.le_of_lt lt)]; exact ypos)
    (fun ge => by
      have back : x - H + H = x := Naturals.sub_add_cancel ge
      have within : H + (x - H) + 1 ≤ H + y := by
        rw [Nat.add_comm H (x - H), back]; exact below
      exact Naturals.le_of_add_le_add_left within)

/-- Below the point of no return, with the recent giving short of the draw, the step keeps the
level below the point and the recent giving short of the draw, and lowers every positive level. -/
theorem step_below {A : Nat → Nat → Nat} {g : Nat → Nat} {H y x r : Nat} (short : Short g H y)
    (stays : StaysShort A g H) (nothing : FromNothing A) (below : x < H + y) (rshort : r < H) :
    (step A H (x, r)).1 < H + y ∧ (step A H (x, r)).2 < H ∧ (0 < x → (step A H (x, r)).1 < x) :=
  (Nat.lt_or_ge x H).elim
    (fun lt => by
      have gone : x - H = 0 := sub_eq_zero_of_le (Nat.le_of_lt lt)
      show x - H + A (x - H) r < H + y ∧ A (x - H) r < H ∧ (0 < x → x - H + A (x - H) r < x)
      rw [gone, nothing r]
      exact ⟨Nat.lt_of_le_of_lt (Nat.zero_le x) below, Nat.lt_of_le_of_lt (Nat.zero_le x) lt, id⟩)
    (fun ge => by
      have back : x - H + H = x := Naturals.sub_add_cancel ge
      have within : H + (x - H) + 1 ≤ H + y := by
        rw [Nat.add_comm H (x - H), back]; exact below
      have left : x - H < y := Naturals.le_of_add_le_add_left within
      have gives : A (x - H) r < H := stays _ _ rshort (short _ left)
      have falls : x - H + A (x - H) r < x :=
        Nat.lt_of_lt_of_le (Nat.add_lt_add_left gives _) (Nat.le_of_eq back)
      show x - H + A (x - H) r < H + y ∧ A (x - H) r < H ∧ (0 < x → x - H + A (x - H) r < x)
      exact ⟨Nat.lt_trans falls below, gives, fun _ => falls⟩)

/-- From nothing, the level stays at nothing, whatever the recent giving, where nothing is given from
nothing. -/
theorem from_zero {A : Nat → Nat → Nat} (H : Nat) (nothing : FromNothing A) {p : Nat × Nat}
    (zero : p.1 = 0) : ∀ k, (Law.orbit (step A H) p k).1 = 0
  | 0 => zero
  | k + 1 => by
    show (Law.orbit (step A H) p k).1 - H +
      A ((Law.orbit (step A H) p k).1 - H) (Law.orbit (step A H) p k).2 = 0
    rw [from_zero H nothing zero k, Nat.zero_sub, nothing, Nat.zero_add]

/-- Below the point of no return, with the recent giving short of the draw, after `n` steps the
level is still below the point, the recent giving still short of the draw, and the level has
fallen by at least `n`. -/
theorem orbit_bound {A : Nat → Nat → Nat} {g : Nat → Nat} {H y x r : Nat} (short : Short g H y)
    (stays : StaysShort A g H) (nothing : FromNothing A) (below : x < H + y) (rshort : r < H) :
    ∀ n, (Law.orbit (step A H) (x, r) n).1 < H + y ∧ (Law.orbit (step A H) (x, r) n).2 < H ∧
      (Law.orbit (step A H) (x, r) n).1 ≤ x - n
  | 0 => ⟨below, rshort, Nat.le_refl x⟩
  | n + 1 => by
    have ⟨inside, still, le⟩ := orbit_bound short stays nothing below rshort n
    have next := step_below (x := (Law.orbit (step A H) (x, r) n).1)
      (r := (Law.orbit (step A H) (x, r) n).2) short stays nothing inside still
    show (step A H (Law.orbit (step A H) (x, r) n)).1 < H + y ∧
      (step A H (Law.orbit (step A H) (x, r) n)).2 < H ∧
      (step A H (Law.orbit (step A H) (x, r) n)).1 ≤ x - (n + 1)
    refine ⟨next.1, next.2.1, ?_⟩
    refine (Nat.eq_zero_or_pos (Law.orbit (step A H) (x, r) n).1).elim
      (fun zero => ?_) (fun pos => ?_)
    · have z : (step A H (Law.orbit (step A H) (x, r) n)).1 = 0 := from_zero H nothing zero 1
      rw [z]; exact Nat.zero_le _
    · have h0 : (step A H (Law.orbit (step A H) (x, r) n)).1 + 1 ≤ x - n :=
        Nat.le_trans (next.2.2 pos) le
      have h1 : 1 + (step A H (Law.orbit (step A H) (x, r) n)).1 ≤ x - n := by
        rw [Nat.add_comm]; exact h0
      rw [← Naturals.sub_sub x n 1]
      exact Naturals.le_sub_of_add_le h1

/-- **Below the point of no return, with the recent giving short of the draw, the condition is
gone**, after as many steps as it stood, at every adjustment keeping giving short where the recent
and the regime's giving are and giving nothing from nothing. -/
theorem ends_below {A : Nat → Nat → Nat} {g : Nat → Nat} {H y x r : Nat} (short : Short g H y)
    (stays : StaysShort A g H) (nothing : FromNothing A) (below : x < H + y) (rshort : r < H) :
    ((Law.run (step A H) (x, r)).state x).1 = 0 := by
  have bound := (orbit_bound short stays nothing below rshort x).2.2
  rw [Nat.sub_self] at bound
  exact Nat.eq_zero_of_le_zero bound

/-- Once gone below the point of no return, the condition stays gone. -/
theorem stays_ended {A : Nat → Nat → Nat} {g : Nat → Nat} {H y x r : Nat} (short : Short g H y)
    (stays : StaysShort A g H) (nothing : FromNothing A) (below : x < H + y) (rshort : r < H)
    (k : Nat) : ((Law.run (step A H) (x, r)).state (x + k)).1 = 0 :=
  (congrArg Prod.fst (Law.orbit_add (step A H) (x, r) x k)).trans
    (from_zero H nothing (ends_below short stays nothing below rshort) k)

/-- Below the point of no return, with the recent giving short of the draw, at every adjustment
keeping giving short where the recent and the regime's giving are, whatever it gives from nothing:
after `n` steps the level is below the point, the recent giving short of the draw, and what the
draw leaves has fallen by at least `n`. -/
theorem left_bound {A : Nat → Nat → Nat} {g : Nat → Nat} {H y x r : Nat} (short : Short g H y)
    (stays : StaysShort A g H) (ypos : 0 < y) (below : x < H + y) (rshort : r < H) :
    ∀ n, (Law.orbit (step A H) (x, r) n).1 < H + y ∧ (Law.orbit (step A H) (x, r) n).2 < H ∧
      (Law.orbit (step A H) (x, r) n).1 - H ≤ x - H - n
  | 0 => ⟨below, rshort, Nat.le_refl _⟩
  | n + 1 => by
    have ⟨inside, still, le⟩ := left_bound short stays ypos below rshort n
    have left := left_below ypos inside
    have gives := stays _ _ still (short _ left)
    show (Law.orbit (step A H) (x, r) n).1 - H +
        A ((Law.orbit (step A H) (x, r) n).1 - H) (Law.orbit (step A H) (x, r) n).2 < H + y ∧
      A ((Law.orbit (step A H) (x, r) n).1 - H) (Law.orbit (step A H) (x, r) n).2 < H ∧
      (Law.orbit (step A H) (x, r) n).1 - H +
        A ((Law.orbit (step A H) (x, r) n).1 - H) (Law.orbit (step A H) (x, r) n).2 - H ≤
          x - H - (n + 1)
    refine ⟨?_, gives, ?_⟩
    · rw [Nat.add_comm H y]; exact Nat.add_lt_add left gives
    · rw [← Naturals.sub_sub (x - H) n 1]
      exact Nat.le_trans (left_falls gives) (Nat.pred_le_pred le)

/-- **Below the point of no return, with the recent giving short of the draw, the draw takes all
there is** from as many steps on as the level stood above the draw, at every adjustment keeping
giving short where the recent and the regime's giving are, whatever it gives from nothing: from
then on the level is at most the draw. -/
theorem taken_whole {A : Nat → Nat → Nat} {g : Nat → Nat} {H y x r : Nat} (short : Short g H y)
    (stays : StaysShort A g H) (ypos : 0 < y) (below : x < H + y) (rshort : r < H) (n : Nat)
    (late : x - H ≤ n) : ((Law.run (step A H) (x, r)).state n).1 ≤ H := by
  have left : (Law.orbit (step A H) (x, r) n).1 - H = 0 :=
    Nat.eq_zero_of_le_zero (Nat.le_trans (left_bound short stays ypos below rshort n).2.2
      (Nat.le_of_eq (sub_eq_zero_of_le late)))
  show (Law.orbit (step A H) (x, r) n).1 ≤ H
  exact (Nat.lt_or_ge (Law.orbit (step A H) (x, r) n).1 H).elim Nat.le_of_lt
    (fun ge => Nat.le_of_eq ((Naturals.sub_add_cancel ge).symm.trans
      ((congrArg (· + H) left).trans (Nat.zero_add H))))

/-! ### At or above the point of no return -/

/-- At or above the point of no return, with giving meeting the draw up to `hi` and the recent
giving meeting the draw, the step does not lower the level and keeps the recent giving at or above
the draw. -/
theorem step_holds {A : Nat → Nat → Nat} {g : Nat → Nat} {H y hi x r : Nat}
    (meets : Meets g H y hi) (stays : StaysMet A g H) (low : H + y ≤ x) (high : x ≤ hi)
    (met : H ≤ r) : x ≤ (step A H (x, r)).1 ∧ H ≤ (step A H (x, r)).2 := by
  have ge : H ≤ x := Nat.le_trans (Nat.le_add_right H y) low
  have back : x - H + H = x := Naturals.sub_add_cancel ge
  have ylow : y ≤ x - H := Naturals.le_sub_of_add_le low
  have top : x - H + H ≤ hi := by rw [back]; exact high
  have gives : H ≤ A (x - H) r := stays _ _ met (meets _ ylow top)
  show x ≤ x - H + A (x - H) r ∧ H ≤ A (x - H) r
  exact ⟨Nat.le_trans (Nat.le_of_eq back.symm) (Nat.add_le_add_left gives _), gives⟩

/-- **At or above the point of no return, with the recent giving meeting the draw, the condition
holds**: from a level between `H + y` and `hi`, the run never falls below the level it started
from and never exceeds `hi`, at every adjustment keeping giving at the draw where the recent and
the regime's giving are and keeping the band. -/
theorem holds {A : Nat → Nat → Nat} {g : Nat → Nat} {H y hi x r : Nat} (meets : Meets g H y hi)
    (stays : StaysMet A g H) (keeps : Keeps A H hi) (low : H + y ≤ x) (high : x ≤ hi)
    (met : H ≤ r) :
    ∀ n, x ≤ ((Law.run (step A H) (x, r)).state n).1 ∧ ((Law.run (step A H) (x, r)).state n).1 ≤ hi ∧
      H ≤ ((Law.run (step A H) (x, r)).state n).2
  | 0 => ⟨Nat.le_refl x, high, met⟩
  | n + 1 => by
    have ⟨up, top, still⟩ := holds meets stays keeps low high met n
    have next := step_holds (r := (Law.orbit (step A H) (x, r) n).2) meets stays
      (Nat.le_trans low up) top still
    show x ≤ (step A H (Law.orbit (step A H) (x, r) n)).1 ∧
      (step A H (Law.orbit (step A H) (x, r) n)).1 ≤ hi ∧ H ≤ (step A H (Law.orbit (step A H) (x, r) n)).2
    exact ⟨Nat.le_trans up next.1, keeps _ _ top still, next.2⟩

/-- Where giving meets the draw at every level from `y`, the condition holds from every level at
or above `H + y` with the recent giving meeting the draw, with no top. -/
theorem holds_from {A : Nat → Nat → Nat} {g : Nat → Nat} {H y x r : Nat}
    (meets : ∀ z, y ≤ z → H ≤ g z) (stays : StaysMet A g H) (low : H + y ≤ x) (met : H ≤ r) :
    ∀ n, x ≤ ((Law.run (step A H) (x, r)).state n).1 ∧ H ≤ ((Law.run (step A H) (x, r)).state n).2
  | 0 => ⟨Nat.le_refl x, met⟩
  | n + 1 => by
    have ⟨up, still⟩ := holds_from meets stays low met n
    have next := step_holds (hi := (Law.orbit (step A H) (x, r) n).1)
      (r := (Law.orbit (step A H) (x, r) n).2) (fun z ylow _ => meets z ylow) stays
      (Nat.le_trans low up) (Nat.le_refl _) still
    exact ⟨Nat.le_trans up next.1, next.2⟩

/-- **The point of no return is exact on the state.** From a level up to `hi` whose recent giving
falls short of the draw exactly where the level is below `H + y`, the condition ends exactly where
the level starts below `H + y`, at every adjustment keeping giving on the side of the draw where the
recent and the regime's giving are, giving nothing from nothing and keeping the band. -/
theorem ends_iff_below {A : Nat → Nat → Nat} {g : Nat → Nat} {H y hi x r : Nat} (pos : 0 < H + y)
    (short : Short g H y) (staysShort : StaysShort A g H) (nothing : FromNothing A)
    (meets : Meets g H y hi) (staysMet : StaysMet A g H) (keeps : Keeps A H hi) (high : x ≤ hi)
    (side : r < H ↔ x < H + y) :
    (∃ n, ((Law.run (step A H) (x, r)).state n).1 = 0) ↔ x < H + y :=
  ⟨fun ⟨n, zero⟩ => (Nat.lt_or_ge x (H + y)).elim id (fun ge => by
      have met : H ≤ r := (Nat.lt_or_ge r H).elim
        (fun lt => absurd (Nat.lt_of_lt_of_le (side.1 lt) ge) (Nat.lt_irrefl x)) id
      have at_least : H + y ≤ ((Law.run (step A H) (x, r)).state n).1 :=
        Nat.le_trans ge (holds meets staysMet keeps ge high met n).1
      rw [zero] at at_least
      exact absurd (Nat.lt_of_lt_of_le pos at_least) (Nat.lt_irrefl 0)),
   fun below => ⟨x, ends_below short staysShort nothing below (side.2 below)⟩⟩

/-- **For every giving between the recent and the regime's, the point of no return is exact on the
state**: from a level up to `hi` whose recent giving falls short of the draw exactly where the level
is below `H + y`, the condition ends exactly where the level starts below `H + y`, where nothing is
given from nothing and the step keeps the band. -/
theorem Between.ends_iff_below {A : Nat → Nat → Nat} {g : Nat → Nat} {H y hi x r : Nat}
    (between : Between A g) (pos : 0 < H + y) (short : Short g H y) (nothing : FromNothing A)
    (meets : Meets g H y hi) (keeps : Keeps A H hi) (high : x ≤ hi) (side : r < H ↔ x < H + y) :
    (∃ n, ((Law.run (step A H) (x, r)).state n).1 = 0) ↔ x < H + y :=
  Adjusted.ends_iff_below pos short (between.staysShort H) nothing meets (between.staysMet H) keeps high side

end Adjusted
