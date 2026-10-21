import Becoming.Recurrence
import Becoming.Lasting
import Becoming.LastChange
import Becoming.Optimum

/-!
# The margin of a regime: giving read off the level, under a standing draw

`Becoming.Retaining`'s margin law compares the levels with a part and the levels without it while
the rest's exchanges are held as they were (`Flow.WithheldLevels`). On measured data that comparison
holds as an identity; what a measurement can test is the margin with the rest responding. This
module states that margin. Under a standing draw `H`, a condition gives by a law of its level, `g`:
what it gives back from what is left, its equation of state in that regime. The draw takes first at
every step, as much as there is: `step g H x = (x - H) + g (x - H)`. Every law below is stated on
a run of the spine: `Law.run (step g H) x`, or the run of the adjusted step on the level and the
recent giving. Where laws compare regimes, each draw has its own giving law: on real yeast, giving
at the same level falls as the standing draw rises (study section 266, MQ2), so the giving law is
the regime's and not the level's alone.

* **Below the point of no return the condition is gone.** Where giving falls short of the draw at
  every level below `y` (`Short g H y`) and nothing gives from nothing (`FromNothing g`), a positive
  level below `H + y` falls at every step (`Adjusted.step_below`), is nothing after as many steps
  as it stood (`ends_below`) and stays nothing (`stays_ended`).
* **At or above it, the condition holds.** Where giving meets the draw from `y` up to a top `hi`
  (`Meets g H y hi`) and the step keeps every level up to `hi` within it (`Keeps g H hi`), a level
  from `H + y` up to `hi` never falls below where it started (`holds`). The point is exact: from a
  level up to `hi`, the condition ends exactly where the level starts below `H + y`
  (`ends_iff_below`).
* **Giving that adjusts.** A condition can carry what it gave before: its state is its level and its
  recent giving, and the giving at a step is any law `A` of what is left and of the recent giving
  (`Adjusted.step`). The regime's step is the case where `A` reads what is left alone, and the laws
  above on ending and holding are stated from their general forms (`Adjusted.orbit_regime`); the
  frozen rest, which holds the giving as it was, is the case where `A` reads the recent giving
  alone. Where the adjusted giving rests at the draw exactly where the regime gives the draw
  (`Adjusted.RestsAtDraw`, which every giving between the recent and the regime's has where it moves
  wherever it differs from the regime's, `Adjusted.Between.restsAtDraw`), a level at or above the
  draw with a recent giving is left as it is exactly where the recent giving is the draw and the
  regime's step leaves the level as it is (`Adjusted.rest_iff`), and its run stays where it started
  exactly where the regime's run from the level stays at the level (`Adjusted.rests_iff`,
  `Adjusted.Between.rests_iff`): wherever a run rests at or above the draw, at any rate of
  adjustment, it rests at a level the regime's step leaves as it is. That premise cannot be dropped:
  the frozen rest lies between the recent giving and the regime's, and from four with a recent
  giving at a draw of three its run stays at four, where the regime's step ends the condition
  (`Adjusted.frozen_rests`, `Crossing.frozen_stays`). Where the adjusted giving stays on the draw's
  side where the recent and the regime's giving both are (`Adjusted.StaysShort`,
  `Adjusted.StaysMet`, which every giving between them has), below the point of no return with the
  recent giving short of the draw the condition is gone (`Adjusted.ends_below`; where `y` is
  positive, whatever is given from nothing, the draw takes all there is, `Adjusted.taken_whole`), at
  or above it with the recent giving meeting the draw it holds (`Adjusted.holds`,
  `Adjusted.holds_from`), and the point is exact on the state (`Adjusted.ends_iff_below`,
  `Adjusted.Between.ends_iff_below`). The recent giving's side cannot be dropped: under giving gated
  at two and a draw of three the point is five; the regime's step ends the condition from four and
  holds it from five, while giving moving one unit a step toward the regime's holds it from four
  with a recent giving of six and ends it from five with a recent giving of nothing
  (`Crossing.crosses`).
* **Where a run comes to rest.** A law's run with a quantity that never falls along it, rises at
  every change and is bounded comes to rest within the bound, decided at each step
  (`LastChange.still_within`). Where giving rises with what is left, the regime's step keeps the
  order of levels (`step_mono`), so a run moves one way only, and within a band up to `hi` it is
  still from some step at most `hi` (`rests_within`). Where the adjustment rises with what is left
  and with the recent giving (`Adjusted.Rises`), a run whose first step lowers neither its level nor
  its recent giving never lowers either, and one whose first step raises neither never raises either
  (`Adjusted.run_rises`, `Adjusted.run_falls`); a step that does neither, from a state whose recent
  giving is at most its level, lowers a count that is two more than the recent giving's distance
  from the draw at or above the draw and at most one below it (`Adjusted.unordered`,
  `Adjusted.unordered_falls`), so such steps run out. So, where the step keeps every state
  with level and recent giving up to `hi` at a level up to `hi` (`Adjusted.Band`), every run from
  such a state is still from some step at most `3 hi + 3` (`Adjusted.comes_to_rest`), at rest: at
  the draw with a level the regime's step leaves as it is, or below the draw on that line, the giving
  from nothing left giving it again (`Adjusted.AtRest`, `Adjusted.fixed_iff`). Where nothing gives
  from nothing, that rest below the draw is nothing; otherwise it can be something
  (`Adjusted.rests_short`). Every adjustment rests at the draw exactly where `fun e => A e H` gives
  the draw, so the law holds of every rising adjustment within a band, and the regime only names the
  point. Neither rising giving nor the band can be dropped: giving that is two from nothing and
  nothing from more keeps every state up to two within two under a draw of one, yet the run from one
  moves between one and two at every step (`Alternation.alternates`); under the gated giving, with no
  band, the run from five rises by one at every step (`Crossing.rises_without_rest`).
* **The need is the regime's.** Where giving stops below a need `m` (`Gated g m`), every level at
  which giving meets a positive draw lies at or above the need (`root_above_need`), so the point of
  no return lies at least the draw above the need, and more than the draw above it exactly where
  giving at the need falls short of the draw (`beyond_draw_iff`). A larger draw under which giving is
  no greater has a point of no return higher by at least the difference of the draws
  (`rises_by_draw`). Giving lowered by the regime raises the need beyond what the removal alone
  gives: the least level meeting a draw is no lower under the lowered giving, and higher exactly
  where the lowered giving falls short of the draw at the old least level (`lowered_raises`,
  `lowered_raises_strictly`). A margin, a level's distance above this point, is a quantity of the
  level under the standing draws, not of the level alone.
* **Draws add; harms do not.** Where giving under the joint draw is subadditive above the need
  (`SubadditiveAbove`) and no greater than under either draw alone, the rise of the point of no
  return under two draws together is at least the sum of the rises under each, less one whole unit
  (`harms_superadditive`). `Concave` is a giving law under which it is
  strictly more (`Concave.roots`). `Peaked` has two draws each of which the condition holds alone
  from a band of levels (`Peaked.each_holds`) and which together end it from every level
  (`Peaked.together_ends`), by the law that a draw beyond all giving ends the condition from every
  level (`ends_beyond_giving`).
* **The time to break lies in a band.** The level stays at or above `b` for every `n` with
  `b + H n ≤ x` (`not_before`). Where giving is at most `Y` at every level and `Y ≤ H ≤ b`, the level
  falls below `b` within any `n` with `x < b + (H - Y) n` (`falls_within`).

Two statements carry the whole numbers: `harms_superadditive` loses one unit to rounding, and the
band's ends are whole steps. Harvesting theory states the same structure over the reals
(depensation, the fold of the harvested equilibrium, the cost of joint harvest from a concave
renewal; Clark 1976, May 1977); this module states it on the spine, with an empty axiom report, so
that the margin the theory names is the one a measurement can test.
-/

namespace Becoming

namespace RegimeMargin

/-! ## The step under a standing draw -/

/-- One step of a condition at level `x` under a standing draw `H`: the draw takes first, as much
as there is, and the condition gives `g` of what is left. -/
def step (g : Nat → Nat) (H x : Nat) : Nat := (x - H) + g (x - H)

/-- Nothing gives from nothing. -/
def FromNothing (g : Nat → Nat) : Prop := g 0 = 0

/-- Giving falls short of the draw `H` at every level below `y`. -/
def Short (g : Nat → Nat) (H y : Nat) : Prop := ∀ z, z < y → g z < H

/-- `y` is the least level at which giving meets the draw `H`. -/
def Root (g : Nat → Nat) (H y : Nat) : Prop := H ≤ g y ∧ Short g H y

/-- Giving meets the draw `H` at every level from `y` that, with the draw added back, is within
`hi`. -/
def Meets (g : Nat → Nat) (H y hi : Nat) : Prop := ∀ z, y ≤ z → z + H ≤ hi → H ≤ g z

/-- The step keeps every level up to `hi` within `hi`. -/
def Keeps (g : Nat → Nat) (H hi : Nat) : Prop := ∀ x, x ≤ hi → step g H x ≤ hi

/-- Giving stops below the need `m`. -/
def Gated (g : Nat → Nat) (m : Nat) : Prop := ∀ z, z < m → g z = 0

/-- Giving above the need `m` is subadditive. -/
def SubadditiveAbove (g : Nat → Nat) (m : Nat) : Prop :=
  ∀ p q, g (m + (p + q)) ≤ g (m + p) + g (m + q)

/-- Giving is at most `Y` at every level. -/
def AtMost (g : Nat → Nat) (Y : Nat) : Prop := ∀ z, g z ≤ Y

/-- The draw added back to the step is at least the level. -/
theorem step_ge (g : Nat → Nat) (H x : Nat) : x ≤ step g H x + H :=
  (Nat.lt_or_ge x H).elim
    (fun lt => Nat.le_trans (Nat.le_of_lt lt) (Nat.le_add_left H _))
    (fun ge => calc x = x - H + H := (Naturals.sub_add_cancel ge).symm
      _ ≤ x - H + g (x - H) + H := Nat.add_le_add_right (Nat.le_add_right _ _) H)

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

/-! ## Below the point of no return -/

/-- **Below the point of no return the condition is gone**, after as many steps as it stood. -/
theorem ends_below {g : Nat → Nat} {H y x : Nat} (short : Short g H y)
    (nothing : FromNothing g) (below : x < H + y) : (Law.run (step g H) x).state x = 0 :=
  (Adjusted.orbit_regime g H (x, 0) x).symm.trans
    (Adjusted.ends_below short (Adjusted.regime_staysShort g H) (Adjusted.regime_fromNothing nothing)
      below (Adjusted.draw_pos short below))

/-- Once gone below the point of no return, the condition stays gone. -/
theorem stays_ended {g : Nat → Nat} {H y x : Nat} (short : Short g H y)
    (nothing : FromNothing g) (below : x < H + y) (k : Nat) :
    (Law.run (step g H) x).state (x + k) = 0 :=
  (Adjusted.orbit_regime g H (x, 0) (x + k)).symm.trans
    (Adjusted.stays_ended short (Adjusted.regime_staysShort g H) (Adjusted.regime_fromNothing nothing)
      below (Adjusted.draw_pos short below) k)

/-- A draw beyond all giving ends the condition from every level, within as many steps as it
stood. -/
theorem ends_beyond_giving {g : Nat → Nat} {H : Nat} (beyond : ∀ z, g z < H)
    (nothing : FromNothing g) (x : Nat) : (Law.run (step g H) x).state x = 0 :=
  ends_below (y := x + 1) (fun z _ => beyond z) nothing
    (Nat.lt_of_lt_of_le (Nat.lt_succ_self x) (Nat.le_add_left (x + 1) H))

/-! ## At or above the point of no return -/

/-- **At or above the point of no return the condition holds**: from a level between `H + y` and
`hi`, the run never falls below the level it started from and never exceeds `hi`. -/
theorem holds {g : Nat → Nat} {H y hi x : Nat} (meets : Meets g H y hi) (keeps : Keeps g H hi)
    (low : H + y ≤ x) (high : x ≤ hi) :
    ∀ n, x ≤ (Law.run (step g H) x).state n ∧ (Law.run (step g H) x).state n ≤ hi :=
  fun n =>
    have h := Adjusted.holds (r := H) meets (Adjusted.regime_staysMet g H) (Adjusted.regime_keeps keeps)
      low high (Nat.le_refl H) n
    ⟨Nat.le_trans h.1 (Nat.le_of_eq (Adjusted.orbit_regime g H (x, H) n)),
     Nat.le_trans (Nat.le_of_eq (Adjusted.orbit_regime g H (x, H) n).symm) h.2.1⟩

/-- **The point of no return is exact.** From a level up to `hi`, the condition ends exactly where
the level starts below `H + y`. -/
theorem ends_iff_below {g : Nat → Nat} {H y hi x : Nat} (pos : 0 < H + y) (short : Short g H y)
    (nothing : FromNothing g) (meets : Meets g H y hi) (keeps : Keeps g H hi) (high : x ≤ hi) :
    (∃ n, (Law.run (step g H) x).state n = 0) ↔ x < H + y :=
  have transfer : ∀ r, (∃ n, ((Law.run (Adjusted.step (fun e _ => g e) H) (x, r)).state n).1 = 0) ↔
      ∃ n, (Law.run (step g H) x).state n = 0 := fun r =>
    ⟨fun ⟨n, zero⟩ => ⟨n, (Adjusted.orbit_regime g H (x, r) n).symm.trans zero⟩,
     fun ⟨n, zero⟩ => ⟨n, (Adjusted.orbit_regime g H (x, r) n).trans zero⟩⟩
  (Nat.lt_or_ge x (H + y)).elim
    (fun below => (transfer 0).symm.trans
      (Adjusted.ends_iff_below pos short (Adjusted.regime_staysShort g H)
        (Adjusted.regime_fromNothing nothing) meets (Adjusted.regime_staysMet g H)
        (Adjusted.regime_keeps keeps) high ⟨fun _ => below, fun _ => Adjusted.draw_pos short below⟩))
    (fun ge => (transfer H).symm.trans
      (Adjusted.ends_iff_below pos short (Adjusted.regime_staysShort g H)
        (Adjusted.regime_fromNothing nothing) meets (Adjusted.regime_staysMet g H)
        (Adjusted.regime_keeps keeps) high
        ⟨fun lt => absurd lt (Nat.lt_irrefl H),
         fun lt => absurd (Nat.lt_of_lt_of_le lt ge) (Nat.lt_irrefl x)⟩))

/-! ## The need is the regime's -/

/-- Where giving stops below the need, every level at which giving meets a positive draw lies at or
above the need. -/
theorem root_above_need {g : Nat → Nat} {m H y : Nat} (gated : Gated g m) (pos : 0 < H)
    (meets : H ≤ g y) : m ≤ y :=
  (Nat.lt_or_ge y m).elim
    (fun lt => absurd (Nat.lt_of_lt_of_le pos (Nat.le_trans meets (Nat.le_of_eq (gated y lt))))
      (Nat.lt_irrefl 0))
    id

/-- **The point of no return lies more than the draw above the need exactly where giving at the
need falls short of the draw.** -/
theorem beyond_draw_iff {g : Nat → Nat} {m H y : Nat} (gated : Gated g m) (pos : 0 < H)
    (root : Root g H y) : m < y ↔ g m < H :=
  ⟨fun lt => root.2 m lt,
   fun short_at => Nat.lt_of_le_of_ne (root_above_need gated pos root.1)
     (fun same => Nat.lt_irrefl H (Nat.lt_of_le_of_lt (same ▸ root.1) short_at))⟩

/-- Giving under one regime is nowhere greater than under another. -/
def Lowered (g' g : Nat → Nat) : Prop := ∀ z, g' z ≤ g z

/-- The least level meeting a draw does not fall as the draw grows and giving does not rise. -/
theorem root_mono {g g' : Nat → Nat} {H H' y y' : Nat} (root : Root g H y) (root' : Root g' H' y')
    (le : H ≤ H') (lowered : Lowered g' g) : y ≤ y' :=
  (Nat.lt_or_ge y' y).elim
    (fun lt => absurd (Nat.lt_of_lt_of_le
        (Nat.lt_of_lt_of_le (Nat.lt_of_le_of_lt (lowered y') (root.2 y' lt)) le) root'.1)
      (Nat.lt_irrefl _))
    id

/-- **A larger draw, giving no more, has a point of no return higher by at least the difference of
the draws.** -/
theorem rises_by_draw {g g' : Nat → Nat} {H H' y y' : Nat} (root : Root g H y)
    (root' : Root g' H' y') (le : H ≤ H') (lowered : Lowered g' g) : H + y + (H' - H) ≤ H' + y' :=
  calc H + y + (H' - H) = y + (H + (H' - H)) := by rw [Nat.add_comm H y, Nat.add_assoc]
    _ = y + H' := by rw [add_sub_of_le le]
    _ = H' + y := Nat.add_comm y H'
    _ ≤ H' + y' := Nat.add_le_add_left (root_mono root root' le lowered) H'

/-- **Giving lowered by the regime raises the need**: under the same draw, the least level meeting
it under lowered giving is no lower. -/
theorem lowered_raises {g g' : Nat → Nat} {H y y' : Nat} (root : Root g H y) (root' : Root g' H y')
    (lowered : Lowered g' g) : y ≤ y' :=
  root_mono root root' (Nat.le_refl H) lowered

/-- The need is raised strictly exactly where the lowered giving falls short of the draw at the old
least level. -/
theorem lowered_raises_strictly {g g' : Nat → Nat} {H y y' : Nat} (root : Root g H y)
    (root' : Root g' H y') (lowered : Lowered g' g) : y < y' ↔ g' y < H :=
  ⟨fun lt => root'.2 y lt,
   fun short_at => Nat.lt_of_le_of_ne (lowered_raises root root' lowered)
     (fun same => Nat.lt_irrefl H (Nat.lt_of_le_of_lt (same ▸ root'.1) short_at))⟩

/-! ## Draws add; harms do not -/

/-- **Harms are super-additive up to one unit.** Under the draws `H₁`, `H₂` and `H₁ + H₂` the
condition gives by `g₁`, `g₂` and `g`, with `g` subadditive above the need `m` and no greater than
`g₁` or `g₂`. Where the least levels meeting the three draws lie `a`, `b` and `c` above the need,
`a + b ≤ c + 1`: the point of no return under the joint draw rises above the need by at least the
sum of the rises under each, `(H₁ + a) + (H₂ + b)`, less one. With one giving law for all three,
`g₁ = g₂ = g`. -/
theorem harms_superadditive {g₁ g₂ g : Nat → Nat} {m H₁ H₂ a b c : Nat}
    (sub : SubadditiveAbove g m) (low₁ : Lowered g g₁) (low₂ : Lowered g g₂)
    (r₁ : Root g₁ H₁ (m + a)) (r₂ : Root g₂ H₂ (m + b))
    (r : Root g (H₁ + H₂) (m + c)) : a + b ≤ c + 1 := by
  cases a with
  | zero =>
    have hb : b ≤ c :=
      Naturals.le_of_add_le_add_left (root_mono r₂ r (Nat.le_add_left H₂ H₁) low₂)
    rw [Nat.zero_add]
    exact Nat.le_trans hb (Nat.le_succ c)
  | succ a' =>
    cases b with
    | zero =>
      exact Nat.le_trans
        (Naturals.le_of_add_le_add_left (root_mono r₁ r (Nat.le_add_right H₁ H₂) low₁))
        (Nat.le_succ c)
    | succ b' =>
      refine (Nat.lt_or_ge (c + 1) (a' + 1 + (b' + 1))).elim (fun lt => ?_) id
      exfalso
      have h1 : c + 1 ≤ a' + 1 + b' := Nat.le_of_succ_le_succ lt
      have h2 : c + 1 ≤ a' + b' + 1 := by rw [← Nat.add_right_comm a' 1 b']; exact h1
      have cle : c ≤ a' + b' := Nat.le_of_succ_le_succ h2
      refine (Nat.lt_or_ge a' c).elim (fun ac => ?_) (fun ca => ?_)
      · obtain ⟨d, hd⟩ := le_dest (Nat.le_of_lt ac)
        have dle : d ≤ b' := by
          apply Naturals.le_of_add_le_add_left (k := a')
          rw [← hd]; exact cle
        have g1 : g₁ (m + a') < H₁ := r₁.2 _ (Nat.add_lt_add_left (Nat.lt_succ_self a') m)
        have g2 : g₂ (m + d) < H₂ := r₂.2 _ (Nat.add_lt_add_left (Nat.lt_succ_of_le dle) m)
        have gc : g (m + c) ≤ g₁ (m + a') + g₂ (m + d) := by
          rw [hd]; exact Nat.le_trans (sub a' d) (Nat.add_le_add (low₁ _) (low₂ _))
        exact Nat.lt_irrefl _
          (Nat.lt_of_le_of_lt r.1 (Nat.lt_of_le_of_lt gc (Nat.add_lt_add g1 g2)))
      · have g1 : g₁ (m + c) < H₁ := r₁.2 _ (Nat.add_lt_add_left (Nat.lt_succ_of_le ca) m)
        exact Nat.lt_irrefl _ (Nat.lt_of_le_of_lt r.1
          (Nat.lt_of_le_of_lt (low₁ _) (Nat.lt_of_lt_of_le g1 (Nat.le_add_right H₁ H₂))))

/-! ## The time to break -/

/-- The run falls by at most the draw at each step: after `n` steps, the level with `H n` added
back is at least where it started. -/
theorem orbit_ge (g : Nat → Nat) (H x : Nat) : ∀ n, x ≤ (Law.run (step g H) x).state n + H * n
  | 0 => Nat.le_refl x
  | n + 1 => by
    show x ≤ step g H (Law.orbit (step g H) x n) + (H * n + H)
    have ih := orbit_ge g H x n
    calc x ≤ Law.orbit (step g H) x n + H * n := ih
      _ ≤ step g H (Law.orbit (step g H) x n) + H + H * n :=
          Nat.add_le_add_right (step_ge g H _) _
      _ = step g H (Law.orbit (step g H) x n) + (H * n + H) := by
          rw [Nat.add_assoc, Nat.add_comm H (H * n)]

/-- **Not before**: the level stays at or above `b` at every step `n` with `b + H n ≤ x`. -/
theorem not_before (g : Nat → Nat) {H x b n : Nat} (early : b + H * n ≤ x) :
    b ≤ (Law.run (step g H) x).state n :=
  le_of_add_le_add_right (H * n) (Nat.le_trans early (orbit_ge g H x n))

/-- Where giving is at most `Y ≤ H`, a level at or above the draw falls by at least `H - Y`. -/
theorem step_falls_by {g : Nat → Nat} {H Y x : Nat} (most : AtMost g Y) (yle : Y ≤ H)
    (ge : H ≤ x) : step g H x + (H - Y) ≤ x :=
  calc step g H x + (H - Y) ≤ x - H + Y + (H - Y) :=
        Nat.add_le_add_right (Nat.add_le_add_left (most _) _) _
    _ = x - H + (Y + (H - Y)) := Nat.add_assoc _ _ _
    _ = x - H + H := by rw [add_sub_of_le yle]
    _ = x := Naturals.sub_add_cancel ge

/-- Either the level has fallen below `b` by step `n`, or it has stayed at or above `b` and fallen
by at least `(H - Y) n`. -/
theorem falls_or_bound {g : Nat → Nat} {H Y b x : Nat} (most : AtMost g Y) (yle : Y ≤ H)
    (hb : H ≤ b) : ∀ n, (∃ k, k ≤ n ∧ (Law.run (step g H) x).state k < b) ∨
      ((Law.run (step g H) x).state n + (H - Y) * n ≤ x ∧ b ≤ (Law.run (step g H) x).state n)
  | 0 => (Nat.lt_or_ge x b).elim (fun lt => .inl ⟨0, Nat.le_refl 0, lt⟩)
      (fun ge => .inr ⟨Nat.le_refl x, ge⟩)
  | n + 1 => (falls_or_bound most yle hb n).elim
      (fun ⟨k, kle, lt⟩ => .inl ⟨k, Nat.le_succ_of_le kle, lt⟩)
      (fun ⟨bound, above⟩ => by
        have falls := step_falls_by most yle (Nat.le_trans hb above)
        refine (Nat.lt_or_ge (step g H (Law.orbit (step g H) x n)) b).elim
          (fun lt => .inl ⟨n + 1, Nat.le_refl _, lt⟩) (fun ge => .inr ⟨?_, ge⟩)
        show step g H (Law.orbit (step g H) x n) + ((H - Y) * n + (H - Y)) ≤ x
        calc step g H (Law.orbit (step g H) x n) + ((H - Y) * n + (H - Y))
            = step g H (Law.orbit (step g H) x n) + (H - Y) + (H - Y) * n := by
              rw [Nat.add_comm ((H - Y) * n) (H - Y), Nat.add_assoc]
          _ ≤ Law.orbit (step g H) x n + (H - Y) * n := Nat.add_le_add_right falls _
          _ ≤ x := bound)

/-- **Falls within**: where giving is at most `Y ≤ H ≤ b`, the level falls below `b` within any
`n` steps with `x < b + (H - Y) n`. -/
theorem falls_within {g : Nat → Nat} {H Y b x n : Nat} (most : AtMost g Y) (yle : Y ≤ H)
    (hb : H ≤ b) (late : x < b + (H - Y) * n) :
    ∃ k, k ≤ n ∧ (Law.run (step g H) x).state k < b :=
  (falls_or_bound most yle hb n).elim id (fun ⟨bound, above⟩ =>
    absurd (Nat.lt_of_le_of_lt (Nat.le_trans (Nat.add_le_add_right above _) bound) late)
      (Nat.lt_irrefl _))

/-! ## Witnesses -/

/-- The levels below `n` all pass the check `f`. -/
def below (f : Nat → Bool) : Nat → Bool
  | 0 => true
  | n + 1 => f n && below f n

theorem below_spec {f : Nat → Bool} : ∀ {n}, below f n = true → ∀ z, z < n → f z = true
  | 0, _, _, lt => absurd lt (Nat.not_lt_zero _)
  | n + 1, h, z, lt => (Nat.lt_or_ge z n).elim
      (fun zn => below_spec (ListTests.and_right h) z zn)
      (fun nz => (Nat.le_antisymm (Nat.le_of_lt_succ lt) nz) ▸ ListTests.and_left h)

theorem short_of_below {g : Nat → Nat} {H y : Nat}
    (check : below (fun z => decide (g z < H)) y = true) : Short g H y :=
  fun z lt => of_decide_eq_true (below_spec check z lt)

theorem meets_of_below {g : Nat → Nat} {H y hi : Nat}
    (check : below (fun z => !(decide (y ≤ z) && decide (z + H ≤ hi)) || decide (H ≤ g z))
      (hi + 1) = true) : Meets g H y hi := fun z yz top => by
  have pass := below_spec check z (Nat.lt_succ_of_le (Nat.le_trans (Nat.le_add_right z H) top))
  rw [decide_eq_true yz, decide_eq_true top] at pass
  exact of_decide_eq_true pass

theorem keeps_of_below {g : Nat → Nat} {H hi : Nat}
    (check : below (fun x => decide (step g H x ≤ hi)) (hi + 1) = true) : Keeps g H hi :=
  fun x le => of_decide_eq_true (below_spec check x (Nat.lt_succ_of_le le))

namespace Concave

/-- Giving that doubles the level up to two and then adds two: its increments are `2, 2, 1, 1, …`. -/
def giving (z : Nat) : Nat := min (2 * z) (z + 2)

/-- The least level meeting the draw `4` is `2`, and the least meeting the draw `8` is `6`: the
point of no return rises from the need `0` by `4 + 2` under either draw of `4` alone, and by
`8 + 6`, more than the sum `12`, under the two together. -/
theorem roots : Root giving 4 2 ∧ Root giving 8 6 :=
  ⟨⟨by decide, short_of_below rfl⟩, ⟨by decide, short_of_below rfl⟩⟩

end Concave

namespace Peaked

/-- Giving that rises with the level to a peak of `4` at level `4` and falls to nothing at `8`. -/
def giving (z : Nat) : Nat := min z (8 - z)

theorem fromNothing : FromNothing giving := rfl

/-- As `Nat.min_le_left`, with an empty axiom report. -/
theorem min_le_left' (a b : Nat) : min a b ≤ a := by
  show (if a ≤ b then a else b) ≤ a
  cases Nat.decLe a b with
  | isTrue _ => exact Nat.le_refl a
  | isFalse h => exact Nat.le_of_lt (Nat.gt_of_not_le h)

/-- As `Nat.min_le_right`, with an empty axiom report. -/
theorem min_le_right' (a b : Nat) : min a b ≤ b := by
  show (if a ≤ b then a else b) ≤ b
  cases Nat.decLe a b with
  | isTrue h => exact h
  | isFalse _ => exact Nat.le_refl b

/-- Giving never exceeds `4`. -/
theorem atMost : AtMost giving 4 := fun z =>
  (Nat.lt_or_ge z 5).elim
    (fun lt => Nat.le_trans (min_le_left' _ _) (Nat.le_of_lt_succ lt))
    (fun ge => by
      obtain ⟨k, hk⟩ := le_dest ge
      have fall : 8 - z ≤ 3 := by
        rw [hk, ← Naturals.sub_sub 8 5 k]; exact Nat.sub_le 3 k
      exact Nat.le_trans (min_le_right' _ _) (Nat.le_trans fall (Nat.le_succ 3)))

/-- **Each draw holds alone**: under a standing draw of `3`, every level from `6` to `8` holds. -/
theorem each_holds {x : Nat} (low : 6 ≤ x) (high : x ≤ 8) (n : Nat) :
    x ≤ (Law.run (step giving 3) x).state n :=
  (holds (y := 3) (meets_of_below rfl) (keeps_of_below rfl) low high n).1

/-- **Together they end it**: under the two draws together, `6`, beyond all giving, the condition
ends from every level. -/
theorem together_ends (x : Nat) : (Law.run (step giving (3 + 3)) x).state x = 0 :=
  ends_beyond_giving (fun z => Nat.lt_of_le_of_lt (atMost z) (by decide)) fromNothing x

end Peaked

namespace Crossing

/-- Giving gated at two: nothing below two, four from two on. Under a draw of three the least level
meeting the draw is two, so the point of no return is five. -/
def giving (z : Nat) : Nat := if z < 2 then 0 else 4

/-- Giving that moves one unit a step toward the regime's, and rests there. -/
def toward (e r : Nat) : Nat :=
  if r < giving e then r + 1 else if giving e < r then r - 1 else r

theorem fromNothing : FromNothing giving := rfl

theorem root : Root giving 3 2 :=
  ⟨Nat.le_succ 3, fun _ lt => Nat.lt_of_le_of_lt (Nat.le_of_eq (if_pos lt)) (Nat.zero_lt_succ 2)⟩

theorem meets_from : ∀ z, 2 ≤ z → 3 ≤ giving z :=
  fun z le => Nat.le_trans (Nat.le_succ 3)
    (Nat.le_of_eq (if_neg (fun lt : z < 2 => Nat.lt_irrefl 2 (Nat.lt_of_le_of_lt le lt))).symm)

/-- Moving one unit toward the regime's giving lies between the recent giving and the regime's. -/
theorem toward_between : Adjusted.Between toward giving :=
  fun e r => (Nat.lt_or_ge r (giving e)).elim
    (fun lt => have up : toward e r = r + 1 := if_pos lt
      Or.inl ⟨Nat.le_trans (Nat.le_succ r) (Nat.le_of_eq up.symm),
        Nat.le_trans (Nat.le_of_eq up) lt⟩)
    (fun ge => (Nat.lt_or_ge (giving e) r).elim
      (fun lt =>
        have down : toward e r = r - 1 :=
          (if_neg (fun l : r < giving e => Nat.lt_irrefl r (Nat.lt_of_lt_of_le l ge))).trans
            (if_pos lt)
        have one : 1 + giving e ≤ r := Nat.le_trans (Nat.le_of_eq (Nat.add_comm 1 (giving e))) lt
        Or.inr ⟨Nat.le_trans (Naturals.le_sub_of_add_le one) (Nat.le_of_eq down.symm),
          Nat.le_trans (Nat.le_of_eq down) (Nat.sub_le r 1)⟩)
      (fun le =>
        have same : toward e r = r :=
          (if_neg (fun l : r < giving e => Nat.lt_irrefl r (Nat.lt_of_lt_of_le l ge))).trans
            (if_neg (fun l : giving e < r => Nat.lt_irrefl r (Nat.lt_of_le_of_lt le l)))
        Or.inl ⟨Nat.le_of_eq same.symm, Nat.le_trans (Nat.le_of_eq same) le⟩))

/-- Moving one unit toward the regime's giving rests only there: a positive rate. -/
theorem toward_settles : Adjusted.Settles toward giving :=
  fun e r rest => (Nat.lt_or_ge r (giving e)).elim
    (fun lt => absurd ((if_pos lt : toward e r = r + 1).symm.trans rest) (Naturals.succ_ne_self r))
    (fun ge => (Nat.lt_or_ge (giving e) r).elim
      (fun lt => by
        have down : toward e r = r - 1 :=
          (if_neg (fun l : r < giving e => Nat.lt_irrefl r (Nat.lt_of_lt_of_le l ge))).trans
            (if_pos lt)
        have pos : 1 ≤ r := Nat.lt_of_le_of_lt (Nat.zero_le _) lt
        have back : r - 1 + 1 = r := Naturals.sub_add_cancel pos
        have same : r - 1 = r := down.symm.trans rest
        exact absurd (back.symm.trans (congrArg (· + 1) same)) (Naturals.succ_ne_self r).symm)
      (fun le => Nat.le_antisymm le ge))

/-- **Recent giving on the other side of the draw crosses the point of no return, both ways.**
Under the gated giving and a draw of three the point of no return is five. The regime's step ends
the condition from four and holds it from five. Giving moving one unit a step toward the regime's
(between the recent giving and the regime's, and resting only there) holds it at or above seven
from the second step on where it starts at four with a recent giving of six, above the draw, and
has it at nothing from the second step on where it starts at five with a recent giving of
nothing. -/
theorem crosses :
    Root giving 3 2 ∧ Adjusted.Between toward giving ∧ Adjusted.Settles toward giving ∧
    (Law.run (step giving 3) 4).state 4 = 0 ∧ (∀ n, 5 ≤ (Law.run (step giving 3) 5).state n) ∧
    (∀ n, 7 ≤ ((Law.run (Adjusted.step toward 3) (4, 6)).state (n + 2)).1) ∧
    (∀ n, ((Law.run (Adjusted.step toward 3) (5, 0)).state (n + 2)).1 = 0) := by
  refine ⟨root, toward_between, toward_settles,
    ends_below root.2 fromNothing (Nat.lt_succ_self 4), fun n => ?_, fun n => ?_, fun n => ?_⟩
  · exact Nat.le_trans (Adjusted.holds_from (A := fun e _ => giving e) (r := 3) meets_from
      (Adjusted.regime_staysMet giving 3) (Nat.le_refl 5) (Nat.le_refl 3) n).1
      (Nat.le_of_eq (Adjusted.orbit_regime giving 3 (5, 3) n))
  · have two : Law.orbit (Adjusted.step toward 3) (4, 6) 2 = (7, 4) := rfl
    show 7 ≤ (Law.orbit (Adjusted.step toward 3) (4, 6) (n + 2)).1
    rw [Nat.add_comm n 2, Law.orbit_add, two]
    exact (Adjusted.holds_from (x := 7) (r := 4) meets_from (toward_between.staysMet 3)
      (Nat.le_succ_of_le (Nat.le_succ 5)) (Nat.le_succ 3) n).1
  · have two : Law.orbit (Adjusted.step toward 3) (5, 0) 2 = (0, 0) := rfl
    show (Law.orbit (Adjusted.step toward 3) (5, 0) (n + 2)).1 = 0
    rw [Nat.add_comm n 2, Law.orbit_add, two, ← Nat.one_mul n,
      Law.orbit_mul (next := Adjusted.step toward 3) (s := (0, 0)) (p := 1) rfl n]

/-- **Moving wherever it differs from the regime's cannot be dropped.** The frozen rest lies between
the recent giving and the regime's, yet from four with a recent giving at the draw of three its run
stays at four at every step, where the regime's step ends the condition from four. -/
theorem frozen_stays :
    Adjusted.Between (fun _ r => r) giving ∧
    (∀ n, (Law.run (Adjusted.step (fun _ r => r) 3) (4, 3)).state n = (4, 3)) ∧
    (Law.run (step giving 3) 4).state 4 = 0 :=
  ⟨Adjusted.frozen_between giving,
   fun n => (congrArg (Law.orbit (Adjusted.step (fun _ r => r) 3) (4, 3)) (Nat.one_mul n)).symm.trans
     (Law.orbit_mul (next := Adjusted.step (fun _ r => r) 3) (s := (4, 3)) (p := 1)
       (Adjusted.frozen_rests (Nat.le_succ 3)) n),
   ends_below root.2 fromNothing (Nat.lt_succ_self 4)⟩

end Crossing

/-! ## Where a run comes to rest

`Adjusted.rests_iff` says where a run of an adjusting giving can rest, not that it comes to rest; in
general, settling needs the limited principle of omniscience (`LastChange.lpo_iff_settles`). A run of
a law with a quantity that never falls along it, rises at every change and is bounded comes to rest
within the bound, decided at each step (`LastChange.still_within`). Where giving rises with what is
left, the regime's step moves a level one way only (`Lasting.orbit_mono`), so its level, or its
distance below the start, is such a quantity, and within a band the run comes to rest. Where the
adjustment rises with what is left and with the recent giving, a step that neither raises nor lowers
both the level and the recent giving moves the recent giving strictly toward the draw, so such steps
run out, and from the first step that raises or lowers both, the run moves one way only: every run
within a band comes to rest, at the regime's point or at a rest below the draw. -/

/-- The regime's step does not lower a higher level below a lower one's, where giving rises with
what is left. -/
theorem step_mono {g : Nat → Nat} (grows : ∀ a b, a ≤ b → g a ≤ g b) (H : Nat) {a b : Nat}
    (le : a ≤ b) : step g H a ≤ step g H b :=
  Nat.add_le_add (Nat.sub_le_sub_right le H) (grows _ _ (Nat.sub_le_sub_right le H))

/-- **Every run of the regime's step comes to rest.** Where giving rises with what is left and the
step keeps every level up to `hi` within it, the run from a level up to `hi` is still from some step
at most `hi`, at a level the regime's step leaves as it is: within `hi - x` steps where its first
step raises the level, within `x` where it lowers it. -/
theorem rests_within {g : Nat → Nat} {H hi x : Nat} (grows : ∀ a b, a ≤ b → g a ≤ g b)
    (keeps : Keeps g H hi) (high : x ≤ hi) :
    ∃ N, N ≤ hi ∧ LastChange.StillFrom (Law.run (step g H) x) N :=
  have mono : ∀ a b, a ≤ b → step g H a ≤ step g H b := fun _ _ le => step_mono grows H le
  (Nat.le_total x (step g H x)).elim
    (fun first =>
      have up : ∀ n, Law.orbit (step g H) x n ≤ Law.orbit (step g H) x (n + 1) := fun n =>
        Eq.subst (motive := fun v => Law.orbit (step g H) x n ≤ v)
          (Law.orbit_shift (step g H) x n).symm
          (Lasting.orbit_mono (rel := fun a b => a ≤ b) mono first n)
      have top : ∀ n, Law.orbit (step g H) x n ≤ hi := fun n => by
        induction n with
        | zero => exact high
        | succ n ih => exact keeps _ ih
      have ⟨N, le, still⟩ := LastChange.still_within (q := fun v => v) (B := hi) (hi - x) x
        (Nat.le_of_eq (Naturals.sub_add_cancel high).symm) (fun n => ⟨up n, fun apart => Nat.lt_of_le_of_ne (up n) fun same =>
          apart same.symm⟩) top
      ⟨N, Nat.le_trans le (Nat.sub_le hi x), still⟩)
    (fun first =>
      have down : ∀ n, Law.orbit (step g H) x (n + 1) ≤ Law.orbit (step g H) x n := fun n =>
        Eq.subst (motive := fun v => v ≤ Law.orbit (step g H) x n)
          (Law.orbit_shift (step g H) x n).symm
          (Lasting.orbit_mono (rel := fun a b => a ≤ b) mono first n)
      have below : ∀ n, Law.orbit (step g H) x n ≤ x := fun n => by
        induction n with
        | zero => exact Nat.le_refl x
        | succ n ih => exact Nat.le_trans (down n) ih
      have ⟨N, le, still⟩ := LastChange.still_within (q := fun v => x - v) (B := x) x x
        (Nat.le_add_right x _) (fun n => ⟨Optimum.sub_le_sub_left_of_le (down n) x, fun apart =>
          Requirement.Formation.sub_lt_sub_of_lt (Nat.lt_of_le_of_ne (down n) apart) (below n)⟩) (fun n => Nat.sub_le x _)
      ⟨N, Nat.le_trans le high, still⟩)

namespace Adjusted

/-- The adjusted giving rises with what is left and with the recent giving. -/
def Rises (A : Nat → Nat → Nat) : Prop := ∀ e e' r r', e ≤ e' → r ≤ r' → A e r ≤ A e' r'

/-- One state at or below another, in level and in recent giving. -/
def Below (p q : Nat × Nat) : Prop := p.1 ≤ q.1 ∧ p.2 ≤ q.2

/-- The adjusted step keeps every state whose level and recent giving are at most `hi` at a level at
most `hi`. -/
def Band (A : Nat → Nat → Nat) (H hi : Nat) : Prop :=
  ∀ x r, x ≤ hi → r ≤ hi → (step A H (x, r)).1 ≤ hi

/-- A state the adjusted step leaves as it is: at or above the draw, with the recent giving at the
draw and a level the regime's step leaves as it is; or below the draw, with the level and the recent
giving equal and the adjusted giving from nothing left giving it again. -/
def AtRest (A : Nat → Nat → Nat) (g : Nat → Nat) (H : Nat) (p : Nat × Nat) : Prop :=
  (p.2 = H ∧ H ≤ p.1 ∧ RegimeMargin.step g H p.1 = p.1) ∨ (p.1 < H ∧ p.1 = p.2 ∧ A 0 p.2 = p.2)

/-- A bound on how many more steps can leave the level and the recent giving neither both risen nor
both fallen: at or above the draw, two more than the recent giving's distance from the draw; below
it, one off the line where the level and the recent giving are equal, and none on it. -/
def unordered (H : Nat) (p : Nat × Nat) : Nat :=
  if H ≤ p.1 then p.2 - H + (H - p.2) + 2 else if p.1 = p.2 then 0 else 1

/-- The adjusted step keeps the order of states where the adjustment rises. -/
theorem step_mono {A : Nat → Nat → Nat} (rises : Rises A) (H : Nat) {p q : Nat × Nat}
    (below : Below p q) : Below (step A H p) (step A H q) :=
  have left : p.1 - H ≤ q.1 - H := Nat.sub_le_sub_right below.1 H
  have gives : A (p.1 - H) p.2 ≤ A (q.1 - H) q.2 := rises _ _ _ _ left below.2
  ⟨Nat.add_le_add left gives, gives⟩

/-- A state at or below another and apart from it has less level and recent giving together. -/
theorem sum_lt_of_below : ∀ {p q : Nat × Nat}, Below p q → q ≠ p → p.1 + p.2 < q.1 + q.2
  | (a, b), (c, d), below, apart => (Nat.lt_or_ge a c).elim
      (fun lt => Nat.add_lt_add_of_lt_of_le lt below.2)
      (fun ge => (Nat.lt_or_ge b d).elim (fun lt => Nat.add_lt_add_of_le_of_lt below.1 lt)
        (fun ge' => absurd (congr (congrArg Prod.mk (Nat.le_antisymm ge below.1))
          (Nat.le_antisymm ge' below.2)) apart))

/-- After a step the recent giving is at most the level. -/
theorem given_le_level (A : Nat → Nat → Nat) (H : Nat) (p : Nat × Nat) :
    (step A H p).2 ≤ (step A H p).1 :=
  Nat.le_add_left _ _

/-- A run from a state within a band stays within it. -/
theorem in_band {A : Nat → Nat → Nat} {H hi : Nat} (band : Band A H hi) {p : Nat × Nat}
    (high : p.1 ≤ hi) (given : p.2 ≤ hi) :
    ∀ n, (Law.orbit (step A H) p n).1 ≤ hi ∧ (Law.orbit (step A H) p n).2 ≤ hi
  | 0 => ⟨high, given⟩
  | n + 1 =>
    have top : (step A H (Law.orbit (step A H) p n)).1 ≤ hi :=
      band _ _ (in_band band high given n).1 (in_band band high given n).2
    ⟨top, Nat.le_trans (given_le_level A H _) top⟩

/-- A run whose first step lowers neither its level nor its recent giving never lowers either. -/
theorem run_rises {A : Nat → Nat → Nat} (rises : Rises A) {H : Nat} {p : Nat × Nat}
    (first : Below p (step A H p)) :
    ∀ n, Below (Law.orbit (step A H) p n) (Law.orbit (step A H) p (n + 1)) := fun n =>
  Eq.subst (motive := fun v => Below (Law.orbit (step A H) p n) v)
    (Law.orbit_shift (step A H) p n).symm
    (Lasting.orbit_mono (rel := Below) (fun _ _ below => step_mono rises H below) first n)

/-- A run whose first step raises neither its level nor its recent giving never raises either. -/
theorem run_falls {A : Nat → Nat → Nat} (rises : Rises A) {H : Nat} {p : Nat × Nat}
    (first : Below (step A H p) p) :
    ∀ n, Below (Law.orbit (step A H) p (n + 1)) (Law.orbit (step A H) p n) := fun n =>
  Eq.subst (motive := fun v => Below v (Law.orbit (step A H) p n))
    (Law.orbit_shift (step A H) p n).symm
    (Lasting.orbit_mono (rel := Below) (fun _ _ below => step_mono rises H below) first n)

/-- A run within a band whose first step lowers neither its level nor its recent giving is still
from some step at most `2 hi - (x + r)`. -/
theorem rests_rising {A : Nat → Nat → Nat} {H hi : Nat} {p : Nat × Nat} (rises : Rises A)
    (band : Band A H hi) (high : p.1 ≤ hi) (given : p.2 ≤ hi) (first : Below p (step A H p)) :
    ∃ N, N ≤ hi + hi - (p.1 + p.2) ∧ LastChange.StillFrom (Law.run (step A H) p) N :=
  have up := run_rises rises first
  have inside := in_band band high given
  LastChange.still_within (q := fun v : Nat × Nat => v.1 + v.2) (B := hi + hi) (hi + hi - (p.1 + p.2)) p
    (Nat.le_of_eq (Naturals.sub_add_cancel (Nat.add_le_add high given)).symm)
    (fun n => ⟨Nat.add_le_add (up n).1 (up n).2, sum_lt_of_below (up n)⟩)
    (fun n => Nat.add_le_add (inside n).1 (inside n).2)

/-- A run whose first step raises neither its level nor its recent giving is still from some step at
most `x + r`. -/
theorem rests_falling {A : Nat → Nat → Nat} {H : Nat} {p : Nat × Nat} (rises : Rises A)
    (first : Below (step A H p) p) :
    ∃ N, N ≤ p.1 + p.2 ∧ LastChange.StillFrom (Law.run (step A H) p) N := by
  have down := run_falls rises first
  have to_start : ∀ n, Below (Law.orbit (step A H) p n) p := fun n => by
    induction n with
    | zero => exact ⟨Nat.le_refl _, Nat.le_refl _⟩
    | succ n ih => exact ⟨Nat.le_trans (down n).1 ih.1, Nat.le_trans (down n).2 ih.2⟩
  exact LastChange.still_within (q := fun v : Nat × Nat => p.1 + p.2 - (v.1 + v.2)) (B := p.1 + p.2)
    (p.1 + p.2) p (Nat.le_add_right _ _)
    (fun n => ⟨Optimum.sub_le_sub_left_of_le (Nat.add_le_add (down n).1 (down n).2) _,
      fun apart => Requirement.Formation.sub_lt_sub_of_lt
        (sum_lt_of_below (down n) fun same => apart same.symm)
        (Nat.add_le_add (to_start n).1 (to_start n).2)⟩)
    (fun n => Nat.sub_le _ _)

/-- Below the draw, `unordered` is at most one. -/
theorem unordered_below {H : Nat} {p : Nat × Nat} (low : ¬ H ≤ p.1) : unordered H p ≤ 1 := by
  show (if H ≤ p.1 then p.2 - H + (H - p.2) + 2 else if p.1 = p.2 then 0 else 1) ≤ 1
  rw [if_neg low]
  exact if same : p.1 = p.2 then by rw [if_pos same]; exact Nat.zero_le 1
    else by rw [if_neg same]; exact Nat.le_refl 1

/-- `unordered` is at most two more than a bound on the level, where the recent giving is at most
the level. -/
theorem unordered_le {H hi : Nat} {p : Nat × Nat} (le : p.2 ≤ p.1) (high : p.1 ≤ hi) :
    unordered H p ≤ hi + 2 :=
  if at_least : H ≤ p.1 then by
    show (if H ≤ p.1 then p.2 - H + (H - p.2) + 2 else if p.1 = p.2 then 0 else 1) ≤ hi + 2
    rw [if_pos at_least]
    refine Nat.add_le_add_right ?_ 2
    exact (Nat.le_total p.2 H).elim
      (fun short => by
        rw [sub_eq_zero_of_le short, Nat.zero_add]
        exact Nat.le_trans (Nat.sub_le H p.2) (Nat.le_trans at_least high))
      (fun met => by
        rw [sub_eq_zero_of_le met, Nat.add_zero]
        exact Nat.le_trans (Nat.sub_le p.2 H) (Nat.le_trans le high))
  else Nat.le_trans (unordered_below at_least) (Nat.le_add_left 1 (hi + 1))

/-- **A step that neither raises nor lowers both moves toward the draw.** From a state whose recent
giving is at most its level, a step after which the level and the recent giving neither both rise
nor both fall lowers `unordered`: at or above the draw the new recent giving lies strictly between
the old and the draw; below it the new state lies on the line where level and recent giving are
equal. No property of the giving is needed. -/
theorem unordered_falls {H x r a : Nat} (le : r ≤ x) (notUp : ¬ (x ≤ x - H + a ∧ r ≤ a))
    (notDown : ¬ (x - H + a ≤ x ∧ a ≤ r)) : unordered H (x - H + a, a) < unordered H (x, r) := by
  show (if H ≤ x - H + a then a - H + (H - a) + 2 else if x - H + a = a then 0 else 1) <
    (if H ≤ x then r - H + (H - r) + 2 else if x = r then 0 else 1)
  exact if at_least : H ≤ x then by
    have back : x - H + H = x := Naturals.sub_add_cancel at_least
    rw [if_pos at_least]
    exact (Nat.lt_or_ge a H).elim
      (fun short => by
        have lowered : x - H + a ≤ x :=
          Nat.le_trans (Nat.add_le_add_left (Nat.le_of_lt short) _) (Nat.le_of_eq back)
        have rose : r < a := (Nat.lt_or_ge r a).elim id fun ge => absurd ⟨lowered, ge⟩ notDown
        have closer : H - a < H - r :=
          Requirement.Formation.sub_lt_sub_of_lt rose (Nat.le_of_lt short)
        exact if up : H ≤ x - H + a then by
          rw [if_pos up, sub_eq_zero_of_le (Nat.le_of_lt short),
            sub_eq_zero_of_le (Nat.le_of_lt (Nat.lt_trans rose short)), Nat.zero_add, Nat.zero_add]
          exact Nat.add_lt_add_right closer 2
        else Nat.lt_of_le_of_lt (unordered_below (p := (x - H + a, a)) up)
          (Nat.lt_of_lt_of_le (Nat.lt_succ_self 1) (Nat.le_add_left 2 _)))
      (fun met => by
        have raised : x ≤ x - H + a :=
          Nat.le_trans (Nat.le_of_eq back.symm) (Nat.add_le_add_left met _)
        have fell : a < r := (Nat.lt_or_ge a r).elim id fun ge => absurd ⟨raised, ge⟩ notUp
        have above : H < a := (Nat.lt_or_ge H a).elim id fun le' =>
          absurd ⟨Nat.le_trans (Nat.add_le_add_left le' _) (Nat.le_of_eq back), Nat.le_of_lt fell⟩
            notDown
        have closer : a - H < r - H := by
          have shifted : a - H + 1 + H ≤ r - H + H := by
            rw [Nat.add_right_comm, Naturals.sub_add_cancel met,
              Naturals.sub_add_cancel (Nat.le_trans met (Nat.le_of_lt fell))]
            exact fell
          exact Naturals.le_of_add_le_add_right shifted
        rw [if_pos (Nat.le_trans at_least raised), sub_eq_zero_of_le met,
          sub_eq_zero_of_le (Nat.le_trans met (Nat.le_of_lt fell)), Nat.add_zero, Nat.add_zero]
        exact Nat.add_lt_add_right closer 2)
  else by
    have gone : x - H = 0 := sub_eq_zero_of_le (Nat.le_of_lt (Nat.lt_of_not_le at_least))
    rw [if_neg at_least]
    rw [gone, Nat.zero_add] at notUp notDown ⊢
    have fell : a < x := (Nat.lt_or_ge a x).elim id fun ge => absurd ⟨ge, Nat.le_trans le ge⟩ notUp
    have rose : r < a := (Nat.lt_or_ge r a).elim id fun ge => absurd ⟨Nat.le_of_lt fell, ge⟩ notDown
    rw [if_neg (fun up : H ≤ a => at_least (Nat.le_trans up (Nat.le_of_lt fell))), if_pos rfl,
      if_neg (fun same : x = r => Nat.lt_irrefl r (Nat.lt_trans rose (same ▸ fell)))]
    exact Nat.lt_succ_self 0

/-- **Every rest of the state is the regime's or below the draw.** Where the adjusted giving rests at
the draw exactly where the regime gives the draw, the adjusted step leaves a state as it is exactly
where the state is at rest: at or above the draw with the recent giving at the draw and a level the
regime's step leaves as it is, or below the draw on the line where level and recent giving are equal,
the giving from nothing left giving it again. -/
theorem fixed_iff {A : Nat → Nat → Nat} {g : Nat → Nat} {H : Nat} {p : Nat × Nat}
    (restsAt : RestsAtDraw A g H) : step A H p = p ↔ AtRest A g H p :=
  if at_least : H ≤ p.1 then
    ⟨fun fixed => have ⟨rH, regime⟩ := (rest_iff (x := p.1) (r := p.2) restsAt at_least).1 fixed
      Or.inl ⟨rH, at_least, regime⟩,
     fun rest => rest.elim (fun ⟨rH, _, regime⟩ => (rest_iff (x := p.1) (r := p.2) restsAt at_least).2
        ⟨rH, regime⟩)
      (fun ⟨low, _, _⟩ => absurd at_least fun up => Nat.lt_irrefl _ (Nat.lt_of_lt_of_le low up))⟩
  else
    have low : p.1 < H := Nat.lt_of_not_le at_least
    have gone : p.1 - H = 0 := sub_eq_zero_of_le (Nat.le_of_lt low)
    ⟨fun fixed => by
      have level : p.1 - H + A (p.1 - H) p.2 = p.1 := congrArg Prod.fst fixed
      have giving : A (p.1 - H) p.2 = p.2 := congrArg Prod.snd fixed
      rw [gone] at level giving
      rw [giving, Nat.zero_add] at level
      exact Or.inr ⟨low, level.symm, giving⟩,
     fun rest => rest.elim (fun ⟨_, up, _⟩ => absurd up at_least) fun ⟨_, same, again⟩ => by
      show (p.1 - H + A (p.1 - H) p.2, A (p.1 - H) p.2) = p
      rw [gone, again, Nat.zero_add]
      exact congrArg (fun v => (v, p.2)) same.symm⟩

/-- Within a band, a run from a state whose recent giving is at most its level, with `unordered` at
most `d`, is still from some step at most `d + 2 hi`. -/
theorem rests_from {A : Nat → Nat → Nat} {H hi : Nat} (rises : Rises A) (band : Band A H hi) :
    ∀ (d : Nat) (p : Nat × Nat), unordered H p ≤ d → p.2 ≤ p.1 → p.1 ≤ hi →
      ∃ N, N ≤ d + (hi + hi) ∧ LastChange.StillFrom (Law.run (step A H) p) N := by
  intro d
  induction d with
  | zero =>
    intro p bound le high
    exact if up : p.1 ≤ (step A H p).1 ∧ p.2 ≤ (step A H p).2 then
      have ⟨N, n_le, still⟩ := rests_rising rises band high (Nat.le_trans le high) up
      ⟨N, Nat.le_trans n_le (Nat.le_trans (Nat.sub_le _ _) (Nat.le_add_left _ 0)), still⟩
    else if down : (step A H p).1 ≤ p.1 ∧ (step A H p).2 ≤ p.2 then
      have ⟨N, n_le, still⟩ := rests_falling rises down
      ⟨N, Nat.le_trans n_le (Nat.le_trans (Nat.add_le_add high (Nat.le_trans le high))
        (Nat.le_add_left _ 0)), still⟩
    else absurd (Nat.lt_of_lt_of_le (unordered_falls (a := A (p.1 - H) p.2) le up down) bound)
      (Nat.not_lt_zero _)
  | succ d ih =>
    intro p bound le high
    exact if up : p.1 ≤ (step A H p).1 ∧ p.2 ≤ (step A H p).2 then
      have ⟨N, n_le, still⟩ := rests_rising rises band high (Nat.le_trans le high) up
      ⟨N, Nat.le_trans n_le (Nat.le_trans (Nat.sub_le _ _) (Nat.le_add_left _ (d + 1))), still⟩
    else if down : (step A H p).1 ≤ p.1 ∧ (step A H p).2 ≤ p.2 then
      have ⟨N, n_le, still⟩ := rests_falling rises down
      ⟨N, Nat.le_trans n_le (Nat.le_trans (Nat.add_le_add high (Nat.le_trans le high))
        (Nat.le_add_left _ (d + 1))), still⟩
    else
      have fewer : unordered H (step A H p) ≤ d := Nat.le_of_lt_succ
        (Nat.lt_of_lt_of_le (unordered_falls (a := A (p.1 - H) p.2) le up down) bound)
      have ⟨N, n_le, still⟩ :=
        ih (step A H p) fewer (given_le_level A H p) (band _ _ high (Nat.le_trans le high))
      ⟨N + 1, Nat.le_trans (Nat.succ_le_succ n_le) (Nat.le_of_eq (Nat.add_right_comm d (hi + hi) 1)),
        LastChange.still_succ still⟩

/-- **Every run of a rising adjustment within a band comes to rest.** Where the adjustment rises with
what is left and with the recent giving, rests at the draw exactly where the regime gives the draw,
and the step keeps every state with level and recent giving up to `hi` at a level up to `hi`, the
run from a level and a recent giving up to `hi` is still from some step at most `3 hi + 3`, at rest:
at the draw with a level the regime's step leaves as it is, or below the draw on the line where level
and recent giving are equal (at nothing, where nothing gives from nothing). Whether it changes again
is decided at each step; no omniscience is needed. -/
theorem comes_to_rest {A : Nat → Nat → Nat} {g : Nat → Nat} {H hi x r : Nat} (rises : Rises A)
    (restsAt : RestsAtDraw A g H) (band : Band A H hi) (high : x ≤ hi) (given : r ≤ hi) :
    ∃ N, N ≤ hi + hi + hi + 3 ∧ LastChange.StillFrom (Law.run (step A H) (x, r)) N ∧
      AtRest A g H ((Law.run (step A H) (x, r)).state N) := by
  have le := given_le_level A H (x, r)
  have top : (step A H (x, r)).1 ≤ hi := band x r high given
  have ⟨N, n_le, still⟩ := rests_from rises band (hi + 2) (step A H (x, r)) (unordered_le le top) le top
  have still' := LastChange.still_succ (next := step A H) (s := (x, r)) still
  have fixed : step A H ((Law.run (step A H) (x, r)).state (N + 1)) =
      (Law.run (step A H) (x, r)).state (N + 1) := still' 0
  refine ⟨N + 1, ?_, still', (fixed_iff restsAt).1 fixed⟩
  exact Nat.le_trans (Nat.succ_le_succ n_le) (Nat.le_of_eq (by
    show hi + 2 + (hi + hi) + 1 = hi + hi + hi + 3
    rw [Nat.add_comm hi 2, Nat.add_assoc 2 hi (hi + hi), Nat.add_comm 2 (hi + (hi + hi)),
      Nat.add_assoc (hi + (hi + hi)) 2 1, ← Nat.add_assoc hi hi hi]))

/-- **A rest below the draw.** Giving one whatever is left and whatever was given before rises, and
rests at a draw of two exactly where the regime's constant giving of one does (nowhere), and the step
keeps every state up to one at a level up to one; from a level of one with a recent giving of one the
run stays there at every step, below the draw, with its recent giving short of it. -/
theorem rests_short :
    Rises (fun _ _ => 1) ∧ RestsAtDraw (fun _ _ => 1) (fun _ => 1) 2 ∧ Band (fun _ _ => 1) 2 1 ∧
    ∀ n, (Law.run (step (fun _ _ => 1) 2) (1, 1)).state n = (1, 1) :=
  ⟨fun _ _ _ _ _ _ => Nat.le_refl 1, fun _ => Iff.rfl,
   fun x _ high _ => by
    show x - 2 + 1 ≤ 1
    rw [sub_eq_zero_of_le (Nat.le_trans high (Nat.le_succ 1)), Nat.zero_add]
    exact Nat.le_refl 1,
   fun n => (congrArg (Law.orbit (step (fun _ _ => 1) 2) (1, 1)) (Nat.one_mul n)).symm.trans
      (Law.orbit_mul (next := step (fun _ _ => 1) 2) (s := (1, 1)) (p := 1) rfl n)⟩

end Adjusted

namespace Crossing

/-- Giving gated at two rises with what is left. -/
theorem giving_rises : ∀ a b, a ≤ b → giving a ≤ giving b := fun a b le =>
  (Nat.lt_or_ge a 2).elim
    (fun lt => Nat.le_trans (Nat.le_of_eq (if_pos lt)) (Nat.zero_le _))
    (fun ge =>
      have atA : giving a = 4 := if_neg fun lt => Nat.lt_irrefl 2 (Nat.lt_of_le_of_lt ge lt)
      have atB : giving b = 4 := if_neg fun lt =>
        Nat.lt_irrefl 2 (Nat.lt_of_le_of_lt (Nat.le_trans ge le) lt)
      Nat.le_of_eq (atA.trans atB.symm))

/-- From five, the regime's step under the gated giving and a draw of three raises the level by one
at every step. -/
theorem climbs : ∀ n, Law.orbit (step giving 3) 5 n = n + 5
  | 0 => rfl
  | n + 1 => by
    show step giving 3 (Law.orbit (step giving 3) 5 n) = n + 1 + 5
    rw [climbs n]
    show n + 5 - 3 + giving (n + 5 - 3) = n + 1 + 5
    rw [show n + 5 - 3 = n + 2 from Naturals.add_sub_cancel (n + 2) 3,
      show giving (n + 2) = 4 from if_neg fun lt =>
        Nat.lt_irrefl 2 (Nat.lt_of_le_of_lt (Nat.le_add_left 2 n) lt)]

/-- **Without a band, a rising run need not rest.** Giving gated at two rises with what is left, so
the adjustment reading what is left alone rises, and it rests at a draw of three exactly where the
regime does; yet from five the regime's step raises the level by one at every step, so neither the
regime's run from five nor the adjusted run from five with a recent giving of three is ever still. -/
theorem rises_without_rest :
    Adjusted.Rises (fun e _ => giving e) ∧ Adjusted.RestsAtDraw (fun e _ => giving e) giving 3 ∧
    (∀ n, (Law.run (step giving 3) 5).state n = n + 5) ∧
    (∀ N, ¬ LastChange.StillFrom (Law.run (step giving 3) 5) N) ∧
    ∀ N, ¬ LastChange.StillFrom (Law.run (Adjusted.step (fun e _ => giving e) 3) (5, 3)) N :=
  have never : ∀ N, ¬ LastChange.StillFrom (Law.run (step giving 3) 5) N := fun N still =>
    Naturals.succ_ne_self (N + 5) ((climbs (N + 0 + 1)).symm.trans ((still 0).trans (climbs (N + 0))))
  ⟨fun e e' _ _ le _ => giving_rises e e' le, fun _ => Iff.rfl, climbs, never,
   fun N still => never N fun k =>
    (Adjusted.orbit_regime giving 3 (5, 3) (N + k + 1)).symm.trans
      ((congrArg Prod.fst (still k)).trans (Adjusted.orbit_regime giving 3 (5, 3) (N + k)))⟩

end Crossing

namespace Alternation

/-- Giving that falls as what is left rises: two from nothing, nothing from anything more. -/
def giving (z : Nat) : Nat := if z = 0 then 2 else 0

/-- The regime's step under a draw of one keeps every level up to two within two. -/
theorem keeps : Keeps giving 1 2
  | 0, _ => Nat.le_refl 2
  | 1, _ => Nat.le_refl 2
  | 2, _ => Nat.le_succ 1
  | n + 3, high =>
    absurd (Nat.lt_of_lt_of_le (Nat.lt_of_lt_of_le (Nat.lt_succ_self 2) (Nat.le_add_left 3 n)) high)
      (Nat.lt_irrefl 2)

/-- From one, the regime's step under a draw of one returns to one every second step. -/
theorem returns : ∀ k, Law.orbit (step giving 1) 1 (k + k) = 1 := fun k =>
  (congrArg (Law.orbit (step giving 1) 1) (Naturals.two_mul k)).symm.trans
    (Law.orbit_mul (next := step giving 1) (s := 1) (p := 2) rfl k)

/-- **Without giving rising with what is left, a run within a band need not rest.** Giving that is
two from nothing and nothing from more does not rise with what is left. Under a draw of one the
regime's step keeps every level up to two within two, and the adjustment reading what is left alone
rests at the draw exactly where the regime does and keeps the band; from one with a recent giving of
two its first step raises both, so no ordering of the start is enough either. Yet the regime's run from one moves between one and two at every
step, and so does the level of the adjusted run, so neither is ever still. -/
theorem alternates :
    ¬ (∀ a b, a ≤ b → giving a ≤ giving b) ∧ Keeps giving 1 2 ∧
    Adjusted.RestsAtDraw (fun e _ => giving e) giving 1 ∧ Adjusted.Band (fun e _ => giving e) 1 2 ∧
    Adjusted.Below (1, 2) (Adjusted.step (fun e _ => giving e) 1 (1, 2)) ∧
    (∀ N, ¬ LastChange.StillFrom (Law.run (step giving 1) 1) N) ∧
    ∀ N, ¬ LastChange.StillFrom (Law.run (Adjusted.step (fun e _ => giving e) 1) (1, 2)) N :=
  have never : ∀ N, ¬ LastChange.StillFrom (Law.run (step giving 1) 1) N := fun N still =>
    absurd ((congrArg (step giving 1) (returns N)).symm.trans ((still N).trans (returns N)))
      (Naturals.succ_ne_self 1)
  ⟨fun grows => Nat.not_succ_le_zero 1 (grows 0 1 (Nat.zero_le 1)), keeps, fun _ => Iff.rfl,
   fun x _ high _ => keeps x high, ⟨Nat.le_succ 1, Nat.le_refl 2⟩, never,
   fun N still => never N fun k =>
    (Adjusted.orbit_regime giving 1 (1, 2) (N + k + 1)).symm.trans
      ((congrArg Prod.fst (still k)).trans (Adjusted.orbit_regime giving 1 (1, 2) (N + k)))⟩

end Alternation

end RegimeMargin

end Becoming
