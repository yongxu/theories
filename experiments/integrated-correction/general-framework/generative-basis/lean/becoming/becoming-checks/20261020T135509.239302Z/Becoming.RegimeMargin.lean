import Becoming.Recurrence

/-!
# The margin of a regime: giving read off the level, under a standing draw

`Becoming.Retaining`'s margin law compares the levels with a part and the levels without it while
the rest's exchanges are held as they were (`Flow.WithheldLevels`). On measured data that comparison
holds as an identity; what a measurement can test is the margin with the rest responding. This
module states that margin. Under a standing draw `H`, a condition gives by a law of its level, `g`:
what it gives back from what is left, its equation of state in that regime. The draw takes first at
every step, as much as there is: `step g H x = (x - H) + g (x - H)`. Every law below is stated on
the run `Law.run (step g H) x` of the spine. Where laws compare regimes, each draw has its own giving
law: on real yeast, giving at the same level falls as the standing draw rises (study section 266,
MQ2), so the giving law is the regime's and not the level's alone.

* **Below the point of no return the condition is gone.** Where giving falls short of the draw at
  every level below `y` (`Short g H y`) and nothing gives from nothing (`FromNothing g`), a positive
  level below `H + y` falls at every step (`step_falls`), is nothing after as many steps as it stood
  (`ends_below`) and stays nothing (`stays_ended`).
* **At or above it, the condition holds.** Where giving meets the draw from `y` up to a top `hi`
  (`Meets g H y hi`) and the step keeps every level up to `hi` within it (`Keeps g H hi`), a level
  from `H + y` up to `hi` never falls below where it started (`holds`). The point is exact: from a
  level up to `hi`, the condition ends exactly where the level starts below `H + y`
  (`ends_iff_below`).
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

/-- From nothing the step gives nothing. -/
theorem step_zero {g : Nat → Nat} (H : Nat) (nothing : FromNothing g) : step g H 0 = 0 :=
  (congrArg (fun r => r + g r) (Nat.zero_sub H)).trans ((Nat.zero_add (g 0)).trans nothing)

/-- A level below the draw is taken whole, and nothing gives from nothing. -/
theorem step_of_lt {g : Nat → Nat} {H x : Nat} (nothing : FromNothing g) (lt : x < H) :
    step g H x = 0 :=
  (congrArg (fun r => r + g r) (sub_eq_zero_of_le (Nat.le_of_lt lt))).trans
    ((Nat.zero_add (g 0)).trans nothing)

/-- The draw added back to the step is at least the level. -/
theorem step_ge (g : Nat → Nat) (H x : Nat) : x ≤ step g H x + H :=
  (Nat.lt_or_ge x H).elim
    (fun lt => Nat.le_trans (Nat.le_of_lt lt) (Nat.le_add_left H _))
    (fun ge => calc x = x - H + H := (Naturals.sub_add_cancel ge).symm
      _ ≤ x - H + g (x - H) + H := Nat.add_le_add_right (Nat.le_add_right _ _) H)

/-! ## Below the point of no return -/

/-- Below the point of no return `H + y`, a positive level falls at the step. -/
theorem step_falls {g : Nat → Nat} {H y x : Nat} (short : Short g H y)
    (nothing : FromNothing g) (pos : 0 < x) (below : x < H + y) : step g H x < x :=
  (Nat.lt_or_ge x H).elim
    (fun lt => (step_of_lt nothing lt).symm ▸ pos)
    (fun ge => by
      have back : x - H + H = x := Naturals.sub_add_cancel ge
      have within : H + (x - H) + 1 ≤ H + y := by
        rw [Nat.add_comm H (x - H), back]; exact below
      have r_lt : x - H < y := Naturals.le_of_add_le_add_left within
      have falls : x - H + g (x - H) < x - H + H := Nat.add_lt_add_left (short _ r_lt) _
      exact Nat.lt_of_lt_of_le falls (Nat.le_of_eq back))

/-- Below the point of no return the step stays below it. -/
theorem step_below {g : Nat → Nat} {H y x : Nat} (short : Short g H y)
    (nothing : FromNothing g) (below : x < H + y) : step g H x < H + y :=
  (Nat.eq_zero_or_pos x).elim
    (fun zero => by subst zero; rw [step_zero H nothing]; exact below)
    (fun pos => Nat.lt_trans (step_falls short nothing pos below) below)

/-- Below the point of no return, after `n` steps the level is still below it and has fallen by
at least `n`. -/
theorem orbit_bound {g : Nat → Nat} {H y x : Nat} (short : Short g H y)
    (nothing : FromNothing g) (below : x < H + y) :
    ∀ n, Law.orbit (step g H) x n < H + y ∧ Law.orbit (step g H) x n ≤ x - n
  | 0 => ⟨below, Nat.le_refl x⟩
  | n + 1 => by
    have ⟨inside, le⟩ := orbit_bound short nothing below n
    show step g H (Law.orbit (step g H) x n) < H + y ∧
      step g H (Law.orbit (step g H) x n) ≤ x - (n + 1)
    refine ⟨step_below short nothing inside, ?_⟩
    refine (Nat.eq_zero_or_pos (Law.orbit (step g H) x n)).elim (fun zero => ?_) (fun pos => ?_)
    · rw [zero, step_zero H nothing]; exact Nat.zero_le _
    · have h0 : step g H (Law.orbit (step g H) x n) + 1 ≤ x - n :=
        Nat.le_trans (step_falls short nothing pos inside) le
      have h1 : 1 + step g H (Law.orbit (step g H) x n) ≤ x - n := by
        rw [Nat.add_comm]; exact h0
      rw [← Naturals.sub_sub x n 1]
      exact Naturals.le_sub_of_add_le h1

/-- **Below the point of no return the condition is gone**, after as many steps as it stood. -/
theorem ends_below {g : Nat → Nat} {H y x : Nat} (short : Short g H y)
    (nothing : FromNothing g) (below : x < H + y) : (Law.run (step g H) x).state x = 0 := by
  have bound := (orbit_bound short nothing below x).2
  rw [Nat.sub_self] at bound
  exact Nat.eq_zero_of_le_zero bound

/-- From nothing, the run stays at nothing. -/
theorem orbit_from_zero {g : Nat → Nat} (H : Nat) (nothing : FromNothing g) :
    ∀ k, Law.orbit (step g H) 0 k = 0
  | 0 => rfl
  | k + 1 => (congrArg (step g H) (orbit_from_zero H nothing k)).trans (step_zero H nothing)

/-- Once gone below the point of no return, the condition stays gone. -/
theorem stays_ended {g : Nat → Nat} {H y x : Nat} (short : Short g H y)
    (nothing : FromNothing g) (below : x < H + y) (k : Nat) :
    (Law.run (step g H) x).state (x + k) = 0 :=
  (Law.orbit_add (step g H) x x k).trans
    ((congrArg (fun s => Law.orbit (step g H) s k) (ends_below short nothing below)).trans
      (orbit_from_zero H nothing k))

/-- A draw beyond all giving ends the condition from every level, within as many steps as it
stood. -/
theorem ends_beyond_giving {g : Nat → Nat} {H : Nat} (beyond : ∀ z, g z < H)
    (nothing : FromNothing g) (x : Nat) : (Law.run (step g H) x).state x = 0 :=
  ends_below (y := x + 1) (fun z _ => beyond z) nothing
    (Nat.lt_of_lt_of_le (Nat.lt_succ_self x) (Nat.le_add_left (x + 1) H))

/-! ## At or above the point of no return -/

/-- At or above the point of no return, with giving meeting the draw up to `hi`, the step does not
lower the level. -/
theorem step_holds {g : Nat → Nat} {H y hi x : Nat} (meets : Meets g H y hi) (low : H + y ≤ x)
    (high : x ≤ hi) : x ≤ step g H x := by
  have ge : H ≤ x := Nat.le_trans (Nat.le_add_right H y) low
  have back : x - H + H = x := Naturals.sub_add_cancel ge
  have ylow : y ≤ x - H := Naturals.le_sub_of_add_le low
  have top : x - H + H ≤ hi := by rw [back]; exact high
  have gives : H ≤ g (x - H) := meets _ ylow top
  show x ≤ x - H + g (x - H)
  calc x = x - H + H := back.symm
    _ ≤ x - H + g (x - H) := Nat.add_le_add_left gives _

/-- **At or above the point of no return the condition holds**: from a level between `H + y` and
`hi`, the run never falls below the level it started from and never exceeds `hi`. -/
theorem holds {g : Nat → Nat} {H y hi x : Nat} (meets : Meets g H y hi) (keeps : Keeps g H hi)
    (low : H + y ≤ x) (high : x ≤ hi) :
    ∀ n, x ≤ (Law.run (step g H) x).state n ∧ (Law.run (step g H) x).state n ≤ hi
  | 0 => ⟨Nat.le_refl x, high⟩
  | n + 1 => by
    have ⟨up, top⟩ := holds meets keeps low high n
    show x ≤ step g H (Law.orbit (step g H) x n) ∧ step g H (Law.orbit (step g H) x n) ≤ hi
    exact ⟨Nat.le_trans up (step_holds meets (Nat.le_trans low up) top), keeps _ top⟩

/-- **The point of no return is exact.** From a level up to `hi`, the condition ends exactly where
the level starts below `H + y`. -/
theorem ends_iff_below {g : Nat → Nat} {H y hi x : Nat} (pos : 0 < H + y) (short : Short g H y)
    (nothing : FromNothing g) (meets : Meets g H y hi) (keeps : Keeps g H hi) (high : x ≤ hi) :
    (∃ n, (Law.run (step g H) x).state n = 0) ↔ x < H + y :=
  ⟨fun ⟨n, zero⟩ => (Nat.lt_or_ge x (H + y)).elim id (fun ge => by
      have at_least : H + y ≤ (Law.run (step g H) x).state n :=
        Nat.le_trans ge (holds meets keeps ge high n).1
      rw [zero] at at_least
      exact absurd (Nat.lt_of_lt_of_le pos at_least) (Nat.lt_irrefl 0)),
   fun below => ⟨x, ends_below short nothing below⟩⟩

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

end RegimeMargin

end Becoming
