/-! ## Rebuilding from below

Above, an optimum holds a level of greatest gain the start reaches in one step. Where the start lies
further below, a course rises only as fast as what is given allows. Where the next level rises with
the level below `y`, the course rising so up to `y` stands at each step at or above every open
course below `y`: nothing open rises faster. So where the weighted gain rises with the level up to
`y` and is greatest there, that course, leaving nothing at the end, gains the most against every
open course and is an optimum of every order rising with the weighted draw; where the gain rises
strictly below `y`, every optimum stands at its level, drawing nothing, at every step where that
level is below `y`: every optimum rebuilds a depleted base as fast as it renews, and meets again
every dependence on it whose need that level meets. -/

namespace Optimum

/-- The level a course from `s` rising as fast as what is given allows, up to `y`, stands at after
`t` steps. -/
def rise (R : Nat → Nat) (y s : Nat) : Nat → Nat
  | 0 => s
  | t + 1 => if rise R y s t + R (rise R y s t) ≤ y then rise R y s t + R (rise R y s t) else y

/-- From `s`, the course rising as fast as what is given allows up to `y` to the `n`-th step and
standing at nothing after: the course rebuilding toward `y`. -/
def rebuilding (R : Nat → Nat) (y s n : Nat) : Nat → Nat
  | 0 => s
  | t + 1 => if t < n then rise R y s (t + 1) else 0

variable {w R : Nat → Nat} {k s y n : Nat}

/-- One step of the rising course. -/
theorem rise_succ (t : Nat) : rise R y s (t + 1) =
    if rise R y s t + R (rise R y s t) ≤ y then rise R y s t + R (rise R y s t) else y :=
  rfl

/-- After its start the rising course stands at most at `y`. -/
theorem rise_le (t : Nat) : rise R y s (t + 1) ≤ y :=
  match Nat.lt_or_ge y (rise R y s t + R (rise R y s t)) with
  | .inl over => Nat.le_of_eq ((rise_succ t).trans (if_neg (Nat.not_le_of_gt over)))
  | .inr fits => Nat.le_trans (Nat.le_of_eq ((rise_succ t).trans (if_pos fits))) fits

/-- From a start at most `y` the rising course stands at most at `y`. -/
theorem rise_le_top (low : s ≤ y) : ∀ t, rise R y s t ≤ y
  | 0 => low
  | t + 1 => rise_le t

/-- Each step of the rising course leaves at most the level with what is given. -/
theorem rise_within (t : Nat) : rise R y s (t + 1) ≤ rise R y s t + R (rise R y s t) :=
  match Nat.lt_or_ge y (rise R y s t + R (rise R y s t)) with
  | .inl over => Nat.le_trans (Nat.le_of_eq ((rise_succ t).trans (if_neg (Nat.not_le_of_gt over))))
      (Nat.le_of_lt over)
  | .inr fits => Nat.le_of_eq ((rise_succ t).trans (if_pos fits))

/-- Where the rising course stands below `y` after a step, that step drew nothing. -/
theorem rise_of_below {t : Nat} (below : rise R y s (t + 1) < y) :
    rise R y s (t + 1) = rise R y s t + R (rise R y s t) :=
  match Nat.lt_or_ge y (rise R y s t + R (rise R y s t)) with
  | .inl over => absurd (Nat.le_of_eq ((rise_succ t).trans (if_neg (Nat.not_le_of_gt over))).symm)
      (Nat.not_le_of_gt below)
  | .inr fits => (rise_succ t).trans (if_pos fits)

/-- Once at `y`, the rising course stays there. -/
theorem rise_at_top {t : Nat} (top : rise R y s t = y) : rise R y s (t + 1) = y :=
  Nat.le_antisymm (rise_le t)
    (match Nat.lt_or_ge y (rise R y s t + R (rise R y s t)) with
    | .inl over => Nat.le_of_eq ((rise_succ t).trans (if_neg (Nat.not_le_of_gt over))).symm
    | .inr fits => Nat.le_trans (Nat.le_trans (Nat.le_of_eq top.symm) (Nat.le_add_right _ _))
        (Nat.le_of_eq ((rise_succ t).trans (if_pos fits)).symm))

/-- Where the rising course stands below `y` after two steps, it stood below `y` after one. -/
theorem rise_below_before {t : Nat} (below : rise R y s (t + 1 + 1) < y) : rise R y s (t + 1) < y :=
  match Nat.lt_or_ge (rise R y s (t + 1)) y with
  | .inl lt => lt
  | .inr ge => absurd (Nat.le_of_eq (rise_at_top (Nat.le_antisymm (rise_le t) ge)).symm)
      (Nat.not_le_of_gt below)

/-- Once at `y`, the rising course stands there at every later step. -/
theorem rise_stays {j : Nat} (top : rise R y s j = y) : ∀ i, rise R y s (j + i) = y
  | 0 => top
  | i + 1 => rise_at_top (rise_stays top i)

/-- **Nothing open rises faster.** Where the next level rises with the level below `y`, every course
from `s` at most `y` whose steps each leave at most the level with what is given stands, at each
step, at or below the rising course, or the rising course stands at `y`. -/
theorem le_rise {x : Nat → Nat} (within : ∀ t, x (t + 1) ≤ x t + R (x t)) (start : x 0 = s)
    (low : s ≤ y) (grows : ∀ z z', z ≤ z' → z' ≤ y → z + R z ≤ z' + R z') :
    ∀ t, x t ≤ rise R y s t ∨ rise R y s t = y
  | 0 => .inl (Nat.le_of_eq start)
  | t + 1 => match le_rise within start low grows t with
    | .inl le => match Nat.lt_or_ge y (rise R y s t + R (rise R y s t)) with
      | .inl over => .inr ((rise_succ t).trans (if_neg (Nat.not_le_of_gt over)))
      | .inr fits => .inl (Nat.le_trans (within t) (Nat.le_trans (grows _ _ le (rise_le_top low t))
          (Nat.le_of_eq ((rise_succ t).trans (if_pos fits)).symm)))
    | .inr top => .inr (rise_at_top top)

/-- The rebuilding course stands at the rising course's level from the first step to the `n`-th. -/
theorem rebuilding_before {t : Nat} (before : t < n) :
    rebuilding R y s n (t + 1) = rise R y s (t + 1) :=
  if_pos before

/-- The rebuilding course stands at nothing after the `n`-th step. -/
theorem rebuilding_after {t : Nat} (after : n ≤ t) : rebuilding R y s n (t + 1) = 0 :=
  if_neg (Nat.not_lt_of_ge after)

/-- To the `n`-th step the rebuilding course stands where the rising course does. -/
theorem rebuilding_at : ∀ {t : Nat}, t ≤ n → rebuilding R y s n t = rise R y s t
  | 0, _ => rfl
  | _ + 1, le => rebuilding_before le

/-- Each step of the rebuilding course leaves at most the level with what is given. -/
theorem rebuilding_within (t : Nat) :
    rebuilding R y s n (t + 1) ≤ rebuilding R y s n t + R (rebuilding R y s n t) :=
  match Nat.lt_or_ge t n with
  | .inl lt => Nat.le_trans (Nat.le_of_eq (rebuilding_before lt))
      (Eq.subst (motive := fun v => rise R y s (t + 1) ≤ v + R v)
        (rebuilding_at (Nat.le_of_lt lt)).symm (rise_within t))
  | .inr ge => Nat.le_trans (Nat.le_of_eq (rebuilding_after ge)) (Nat.zero_le _)

/-- At each step the rebuilding course with what is given is within a capacity covering `y` with
what is given there and what is given at nothing, from a start at most `y`, where the next level
rises with the level below `y`. -/
theorem rebuilding_le_cap (low : s ≤ y) (grows : ∀ z z', z ≤ z' → z' ≤ y → z + R z ≤ z' + R z')
    (holds : y + R y ≤ k) (rests : R 0 ≤ k) :
    ∀ t, rebuilding R y s n t + R (rebuilding R y s n t) ≤ k
  | 0 => Nat.le_trans (grows _ _ low (Nat.le_refl y)) holds
  | t + 1 => match Nat.lt_or_ge t n with
    | .inl lt => Eq.subst (motive := fun v => v + R v ≤ k) (rebuilding_before lt).symm
        (Nat.le_trans (grows _ _ (rise_le t) (Nat.le_refl y)) holds)
    | .inr ge => Eq.subst (motive := fun v => v + R v ≤ k) (rebuilding_after ge).symm
        (Nat.le_trans (Nat.le_of_eq (Nat.zero_add _)) rests)

/-- **The rebuilding course is open**, from a start at most `y`, where the next level rises with the
level below `y`, with a capacity covering `y` with what is given there and what is given at
nothing. -/
theorem rebuilding_open (low : s ≤ y) (grows : ∀ z z', z ≤ z' → z' ≤ y → z + R z ≤ z' + R z')
    (holds : y + R y ≤ k) (rests : R 0 ≤ k) : OpenCourse R k s (rebuilding R y s n) :=
  ⟨rfl, fun t => ⟨rebuilding_within t,
    Nat.le_trans (Nat.sub_le _ _) (rebuilding_le_cap low grows holds rests t)⟩⟩

/-- **The rebuilding course gains the most against every open course**, from a start at most `y`,
where the next level rises with the level below `y` and, at each step to the `n`-th, the weighted
gain rises with the level up to `y` and is greatest at `y`. -/
theorem rebuilding_gainsMost (low : s ≤ y) (grows : ∀ z z', z ≤ z' → z' ≤ y → z + R z ≤ z' + R z')
    (rises : ∀ t, t < n → ∀ z z', z ≤ z' → z' ≤ y →
      w (t + 1) * (z + R z) + w t * z' ≤ w (t + 1) * (z' + R z') + w t * z)
    (top : ∀ t, t < n → ∀ z, w (t + 1) * (z + R z) + w t * y ≤ w (t + 1) * (y + R y) + w t * z) :
    GainsMost w R k s n (rebuilding R y s n) :=
  fun x opens t lt =>
    Eq.subst (motive := fun v => w (t + 1) * (x (t + 1) + R (x (t + 1))) + w t * v ≤
        w (t + 1) * (v + R v) + w t * x (t + 1)) (rebuilding_before lt).symm
      (match le_rise (fun t => (opens.2 t).1) opens.1 low grows (t + 1) with
      | .inl le => rises t lt _ _ le (rise_le t)
      | .inr at_top => Eq.subst (motive := fun v => w (t + 1) * (x (t + 1) + R (x (t + 1))) +
          w t * v ≤ w (t + 1) * (v + R v) + w t * x (t + 1)) at_top.symm (top t lt (x (t + 1))))

/-- **The rebuilding course is an optimum**, under the premises of `rebuilding_gainsMost`, with a
capacity covering `y` with what is given there and what is given at nothing: of the order by the
weighted draw across `n + 1` steps, among the courses open from `s`. -/
theorem rebuilding_frontier (low : s ≤ y) (grows : ∀ z z', z ≤ z' → z' ≤ y → z + R z ≤ z' + R z')
    (rises : ∀ t, t < n → ∀ z z', z ≤ z' → z' ≤ y →
      w (t + 1) * (z + R z) + w t * z' ≤ w (t + 1) * (z' + R z') + w t * z)
    (top : ∀ t, t < n → ∀ z, w (t + 1) * (z + R z) + w t * y ≤ w (t + 1) * (y + R y) + w t * z)
    (holds : y + R y ≤ k) (rests : R 0 ≤ k) :
    Frontier (OpenCourse R k s)
      (fun b a => weightedOver w R a (n + 1) < weightedOver w R b (n + 1)) (rebuilding R y s n) :=
  frontier_of_gainsMost (rebuilding_open low grows holds rests) (rebuilding_after (Nat.le_refl n))
    (rebuilding_gainsMost low grows rises top)

/-- **Every optimum rebuilds.** Under the premises of `rebuilding_frontier`, where the weighted gain
rises strictly with the level below `y`, every optimum of every order on the courses open from `s`
that rises with the weighted draw across `n + 1` steps stands at the rising course's level at every
step from the first to the `n`-th where that level is below `y`, and draws nothing at the step
before: it rebuilds as fast as what is given allows. -/
theorem frontier_rebuilds {better : (Nat → Nat) → (Nat → Nat) → Prop}
    (rising : ∀ a b, weightedOver w R a (n + 1) < weightedOver w R b (n + 1) → better b a)
    (low : s ≤ y) (grows : ∀ z z', z ≤ z' → z' ≤ y → z + R z ≤ z' + R z')
    (rises : ∀ t, t < n → ∀ z z', z ≤ z' → z' ≤ y →
      w (t + 1) * (z + R z) + w t * z' ≤ w (t + 1) * (z' + R z') + w t * z)
    (strictly : ∀ t, t < n → ∀ z z', z < z' → z' ≤ y →
      w (t + 1) * (z + R z) + w t * z' < w (t + 1) * (z' + R z') + w t * z)
    (top : ∀ t, t < n → ∀ z, w (t + 1) * (z + R z) + w t * y ≤ w (t + 1) * (y + R y) + w t * z)
    (holds : y + R y ≤ k) (rests : R 0 ≤ k) {x : Nat → Nat}
    (front : Frontier (OpenCourse R k s) better x) :
    ∀ t, t < n → rise R y s (t + 1) < y →
      x (t + 1) = rise R y s (t + 1) ∧ x (t + 1) = x t + R (x t) :=
  have gains := (frontier_gains_of_most rising (rebuilding_open low grows holds rests)
    (rebuilding_after (Nat.le_refl n)) (rebuilding_gainsMost low grows rises top) front).2
  have stands : ∀ t, t < n → rise R y s (t + 1) < y → x (t + 1) = rise R y s (t + 1) :=
    fun t lt below =>
      have same := Eq.subst (motive := fun v => w (t + 1) * (x (t + 1) + R (x (t + 1))) + w t * v =
        w (t + 1) * (v + R v) + w t * x (t + 1)) (rebuilding_before lt) (gains t lt)
      match le_rise (fun t => (front.1.2 t).1) front.1.1 low grows (t + 1) with
      | .inr at_top => absurd (Nat.le_of_eq at_top.symm) (Nat.not_le_of_gt below)
      | .inl le => match Nat.lt_or_ge (x (t + 1)) (rise R y s (t + 1)) with
        | .inl lt' => absurd same (Nat.ne_of_lt (strictly t lt _ _ lt' (rise_le t)))
        | .inr ge => Nat.le_antisymm le ge
  fun t lt below =>
    have before : x t = rise R y s t := match t, lt, below with
      | 0, _, _ => front.1.1
      | j + 1, lt, below => stands j (Nat.lt_of_succ_lt lt) (rise_below_before below)
    ⟨stands t lt below, (stands t lt below).trans ((rise_of_below below).trans
      (congrArg (fun v => v + R v) before.symm))⟩

/-- **Every optimum stands at `y` once the rising course reaches it.** Under the premises of
`rebuilding_frontier`, where `y` gains, weighted, more than every other level at each step to the
`n`-th, every optimum of every order on the courses open from `s` that rises with the weighted
draw across `n + 1` steps stands at `y` at every step from the first to the `n`-th where the rising
course does. -/
theorem frontier_rebuilt {better : (Nat → Nat) → (Nat → Nat) → Prop}
    (rising : ∀ a b, weightedOver w R a (n + 1) < weightedOver w R b (n + 1) → better b a)
    (low : s ≤ y) (grows : ∀ z z', z ≤ z' → z' ≤ y → z + R z ≤ z' + R z')
    (rises : ∀ t, t < n → ∀ z z', z ≤ z' → z' ≤ y →
      w (t + 1) * (z + R z) + w t * z' ≤ w (t + 1) * (z' + R z') + w t * z)
    (above : ∀ t, t < n → ∀ z, z ≠ y →
      w (t + 1) * (z + R z) + w t * y < w (t + 1) * (y + R y) + w t * z)
    (holds : y + R y ≤ k) (rests : R 0 ≤ k) {x : Nat → Nat}
    (front : Frontier (OpenCourse R k s) better x) :
    ∀ t, t < n → rise R y s (t + 1) = y → x (t + 1) = y :=
  have top : ∀ t, t < n → ∀ z, w (t + 1) * (z + R z) + w t * y ≤ w (t + 1) * (y + R y) + w t * z :=
    fun t lt z => match Nat.decEq z y with
    | isTrue same => Eq.subst (motive := fun v => w (t + 1) * (v + R v) + w t * y ≤
        w (t + 1) * (y + R y) + w t * v) same.symm (Nat.le_refl _)
    | isFalse other => Nat.le_of_lt (above t lt z other)
  have gains := (frontier_gains_of_most rising (rebuilding_open low grows holds rests)
    (rebuilding_after (Nat.le_refl n)) (rebuilding_gainsMost low grows rises top) front).2
  fun t lt at_top =>
    have same := Eq.subst (motive := fun v => w (t + 1) * (x (t + 1) + R (x (t + 1))) + w t * v =
      w (t + 1) * (v + R v) + w t * x (t + 1)) ((rebuilding_before lt).trans at_top) (gains t lt)
    match Nat.decEq (x (t + 1)) y with
    | isTrue e => e
    | isFalse other => absurd same (Nat.ne_of_lt (above t lt _ other))

end Optimum

namespace Web

open Optimum

variable {W : Web F C} {c : C} {w R : Nat → Nat} {k s y n : Nat}
  {better : (Nat → Nat) → (Nat → Nat) → Prop}

/-- **Every optimum rebuilds the condition and restores what that level meets.** Under the premises
of `Optimum.frontier_rebuilds`, every optimum, among the open courses, of every order rising with
the weighted draw leaves the condition at the rising course's level, drawing nothing before it, at
every step from the first to the `n`-th where that level is below `y`; and every dependence on the
condition, as it stands at the start, whose need that level meets by the `j + 1`-th step is
restored within `j + 1` steps. -/
theorem frontier_rebuilds
    (rising : ∀ a b, weightedOver w R a (n + 1) < weightedOver w R b (n + 1) → better b a)
    (low : s ≤ y) (grows : ∀ z z', z ≤ z' → z' ≤ y → z + R z ≤ z' + R z')
    (rises : ∀ t, t < n → ∀ z z', z ≤ z' → z' ≤ y →
      w (t + 1) * (z + R z) + w t * z' ≤ w (t + 1) * (z' + R z') + w t * z)
    (strictly : ∀ t, t < n → ∀ z z', z < z' → z' ≤ y →
      w (t + 1) * (z + R z) + w t * z' < w (t + 1) * (z' + R z') + w t * z)
    (top : ∀ t, t < n → ∀ z, w (t + 1) * (z + R z) + w t * y ≤ w (t + 1) * (y + R y) + w t * z)
    (holds : y + R y ≤ k) (rests : R 0 ≤ k)
    (front : Frontier (OpenCourse R k s) better fun t => W.level t c) :
    (∀ t, t < n → Optimum.rise R y s (t + 1) < y →
      W.level (t + 1) c = Optimum.rise R y s (t + 1) ∧
        W.level (t + 1) c = W.level t c + R (W.level t c)) ∧
    ∀ f j, j < n → Optimum.rise R y s (j + 1) < y → W.need 0 f c ≤ Optimum.rise R y s (j + 1) →
      W.RestoredWithin (j + 1) 0 f c :=
  have stands := Optimum.frontier_rebuilds rising low grows rises strictly top holds rests front
  ⟨stands, fun _ j lt below meets => ⟨j + 1, Nat.succ_pos j, Nat.le_refl _,
    Nat.le_trans meets (Nat.le_of_eq ((stands j lt below).1.symm.trans
      (congrArg (W.level · c) (Nat.zero_add (j + 1)).symm)))⟩⟩

end Web

namespace Optimum

namespace Holding

open Diversion

/-- A level of at most eight renews itself, doubling; above eight nothing is given. -/
def doubling (z : Nat) : Nat := if z ≤ 8 then z else 0

/-- Twice `b`, `d` times, is `b` on `d` twice. -/
theorem twice_mul (b d : Nat) : 2 * b * d = b * (d + d) := by
  rw [mul_assoc_nat, Nat.two_mul, Nat.mul_add]

/-- Where `a` is at most twice `b`, a level doubling gains, weighted by `b` at the next step against
`a` held, no less at a higher level. -/
theorem doubling_gain_le {a b z z' : Nat} (gentle : a ≤ 2 * b) (le : z ≤ z') :
    b * (z + z) + a * z' ≤ b * (z' + z') + a * z :=
  match le_dest le with
  | ⟨d, split⟩ => by
    rw [split, add_four, Nat.mul_add b (z + z) (d + d), Nat.mul_add a z d, Nat.add_assoc,
      Nat.add_comm (b * (d + d)) (a * z)]
    exact Nat.add_le_add_left (Nat.add_le_add_left (Nat.le_trans (Nat.mul_le_mul_right d gentle)
      (Nat.le_of_eq (twice_mul b d))) (a * z)) (b * (z + z))

/-- Where `a` is less than twice `b`, a level doubling gains, weighted, more at a higher level. -/
theorem doubling_gain_lt {a b z z' : Nat} (gentle : a < 2 * b) (lt : z < z') :
    b * (z + z) + a * z' < b * (z' + z') + a * z :=
  match le_dest (show z + 1 ≤ z' from lt) with
  | ⟨e, split⟩ => by
    have scaled : a * (e + 1) < 2 * b * (e + 1) := by
      rw [Nat.mul_succ, Nat.mul_succ]
      exact Nat.add_lt_add_of_le_of_lt (Nat.mul_le_mul_right e (Nat.le_of_lt gentle)) gentle
    rw [split, Nat.add_assoc z 1 e, Nat.add_comm 1 e, add_four, Nat.mul_add b (z + z),
      Nat.mul_add a z, Nat.add_assoc, Nat.add_comm (b * ((e + 1) + (e + 1))) (a * z)]
    exact Nat.add_lt_add_left (Nat.add_lt_add_left (Nat.lt_of_lt_of_le scaled
      (Nat.le_of_eq (twice_mul b (e + 1)))) (a * z)) (b * (z + z))

/-- At most eight, a level with what is given is twice the level. -/
theorem doubling_low {z : Nat} (le : z ≤ 8) : z + doubling z = z + z :=
  congrArg (z + ·) (if_pos le)

/-- Above eight, a level with what is given is the level. -/
theorem doubling_high {z : Nat} (lt : 8 < z) : z + doubling z = z :=
  (congrArg (z + ·) (if_neg (Nat.not_le_of_gt lt))).trans (Nat.add_zero z)

/-- Under the doubling law, the next level rises with the level up to eight. -/
theorem doubling_grows : ∀ z z', z ≤ z' → z' ≤ 8 → z + doubling z ≤ z' + doubling z' :=
  fun _ _ le top => Nat.le_trans (Nat.le_of_eq (doubling_low (Nat.le_trans le top)))
    (Nat.le_trans (Nat.add_le_add le le) (Nat.le_of_eq (doubling_low top).symm))

/-- Under the doubling law, where `a` is at most twice `b`, the weighted gain rises with the level
up to eight. -/
theorem doubling_rises {a b : Nat} (gentle : a ≤ 2 * b) :
    ∀ z z', z ≤ z' → z' ≤ 8 → b * (z + doubling z) + a * z' ≤ b * (z' + doubling z') + a * z :=
  fun _ _ le top => by
    rw [doubling_low (Nat.le_trans le top), doubling_low top]
    exact doubling_gain_le gentle le

/-- Under the doubling law, where `a` is less than twice `b`, the weighted gain rises strictly with
the level up to eight. -/
theorem doubling_rises_strictly {a b : Nat} (gentle : a < 2 * b) :
    ∀ z z', z < z' → z' ≤ 8 → b * (z + doubling z) + a * z' < b * (z' + doubling z') + a * z :=
  fun _ _ lt top => by
    rw [doubling_low (Nat.le_trans (Nat.le_of_lt lt) top), doubling_low top]
    exact doubling_gain_lt gentle lt

/-- Under the doubling law, where `a` is at least `b` and at most twice it, eight gains, weighted,
the most. -/
theorem doubling_top {a b : Nat} (falls : b ≤ a) (gentle : a ≤ 2 * b) :
    ∀ z, b * (z + doubling z) + a * 8 ≤ b * (8 + doubling 8) + a * z :=
  fun z => match Nat.lt_or_ge 8 z with
  | .inl over => by
    rw [doubling_high over, doubling_low (Nat.le_refl 8), Nat.add_comm (b * (8 + 8))]
    exact Nat.add_le_add (Nat.mul_le_mul_right z falls)
      (Nat.le_trans (Nat.mul_le_mul_right 8 gentle) (Nat.le_of_eq (twice_mul b 8)))
  | .inr le => doubling_rises gentle z 8 le (Nat.le_refl 8)

/-- Under the doubling law, where `a` is more than twice `b`, every positive level gains, weighted
by `b` at the next step, less than it does held, weighted by `a`. -/
theorem doubling_outpaced {a b : Nat} (steep : 2 * b < a) :
    ∀ z, 0 < z → b * (z + doubling z) < a * z :=
  fun z pos => match le_dest (show 1 ≤ z from pos) with
  | ⟨i, split⟩ =>
    have scaled : 2 * b * z < a * z := by
      rw [split, Nat.add_comm 1 i, Nat.mul_succ, Nat.mul_succ]
      exact Nat.add_lt_add_of_le_of_lt (Nat.mul_le_mul_right i (Nat.le_of_lt steep)) steep
    match Nat.lt_or_ge 8 z with
    | .inl over => Nat.lt_of_le_of_lt (Nat.le_trans (Nat.le_of_eq (congrArg (b * ·)
        (doubling_high over))) (Nat.le_trans (Nat.mul_le_mul_right z (Nat.le_add_left b b))
          (Nat.le_of_eq (congrArg (· * z) (Nat.two_mul b).symm)))) scaled
    | .inr le => Nat.lt_of_le_of_lt (Nat.le_of_eq ((congrArg (b * ·) (doubling_low le)).trans
        (twice_mul b z).symm)) scaled

/-- Under the doubling law, where `a` is twice `b`, every positive level gains, weighted by `b` at
the next step, at most what it does held, weighted by `a`. -/
theorem doubling_outpaced_le {a b : Nat} (tie : a = 2 * b) :
    ∀ z, 0 < z → b * (z + doubling z) ≤ a * z :=
  fun z _ => match Nat.lt_or_ge 8 z with
  | .inl over => Nat.le_trans (Nat.le_of_eq (congrArg (b * ·) (doubling_high over)))
      (Nat.le_trans (Nat.mul_le_mul_right z (Nat.le_trans (Nat.le_add_left b b)
        (Nat.le_of_eq ((Nat.two_mul b).symm.trans tie.symm)))) (Nat.le_refl _))
  | .inr le => Nat.le_of_eq ((congrArg (b * ·) (doubling_low le)).trans
      ((twice_mul b z).symm.trans (congrArg (· * z) tie.symm)))

/-- A product keeps a strict order under a positive factor. -/
theorem mul_lt_of_pos {a c d : Nat} (lt : a < c) (pos : 0 < d) : a * d < c * d :=
  match le_dest (show 1 ≤ d from pos) with
  | ⟨i, split⟩ => by
    rw [split, Nat.add_comm 1 i, Nat.mul_succ, Nat.mul_succ]
    exact Nat.add_lt_add_of_le_of_lt (Nat.mul_le_mul_right i (Nat.le_of_lt lt)) lt

/-- Under the doubling law, where `a` is at least `b` and less than twice it, eight gains, weighted,
more than every other level. -/
theorem doubling_above {a b : Nat} (falls : b ≤ a) (gentle : a < 2 * b) :
    ∀ z, z ≠ 8 → b * (z + doubling z) + a * 8 < b * (8 + doubling 8) + a * z :=
  fun z other => match Nat.lt_or_ge 8 z with
  | .inl over => by
    rw [doubling_high over, doubling_low (Nat.le_refl 8), Nat.add_comm (b * (8 + 8))]
    exact Nat.add_lt_add_of_le_of_lt (Nat.mul_le_mul_right z falls)
      (Nat.lt_of_lt_of_le (mul_lt_of_pos gentle (Nat.succ_pos 7)) (Nat.le_of_eq (twice_mul b 8)))
  | .inr le => match Nat.lt_or_ge z 8 with
    | .inl lt => doubling_rises_strictly gentle z 8 lt (Nat.le_refl 8)
    | .inr ge => absurd (Nat.le_antisymm le ge) other

/-- **The doubling witness: rebuilding from below.** A source doubling up to eight, from one, with
capacity sixteen, and the order by what the taker draws over `n + 3` steps, the draw of the step
from `t` weighted by `w t`. Two rebuilding steps lie below eight: one reaches two, the next four.
Where the weight falls at every step by less than half, `w (t + 1) ≤ w t < 2 w (t + 1)`, the course
rebuilding the source to eight is an optimum, and every optimum draws nothing at the first two
steps, standing at two and then four, stands at eight at every later step to the horizon's last,
and restores the dweller, which needs two, at the first step (`rebuilding_frontier`,
`frontier_rebuilds`, `frontier_rebuilt`, `Web.frontier_rebuilds`): every optimum stands where the
rebuilding course does at every step to the horizon's last. Where it falls exactly twofold, the
rebuilding course and the course ending the source at once are both optima: the strict premise
cannot be dropped. Where it falls more than twofold, every optimum ends the source at once
(`frontier_exhausts`). -/
theorem doubling_rebuilds (n : Nat) (w : Nat → Nat) :
    ((∀ t, t < n + 2 → w (t + 1) ≤ w t ∧ w t < 2 * w (t + 1)) →
      Frontier (OpenCourse doubling 16 1)
        (fun b a => weightedOver w doubling a (n + 2 + 1) < weightedOver w doubling b (n + 2 + 1))
        (rebuilding doubling 8 1 (n + 2)) ∧
      ∀ x, Frontier (OpenCourse doubling 16 1)
        (fun b a => weightedOver w doubling a (n + 2 + 1) < weightedOver w doubling b (n + 2 + 1))
        x →
      x 1 = 2 ∧ x 2 = 4 ∧ (∀ t, 2 ≤ t → t < n + 2 → x (t + 1) = 8) ∧
        x 1 = x 0 + doubling (x 0) ∧ x 2 = x 1 + doubling (x 1) ∧
        (web (onSource x)).RestoredWithin 1 0 .dweller .source) ∧
    ((∀ t, t < n + 2 → w t = 2 * w (t + 1)) →
      Frontier (OpenCourse doubling 16 1)
        (fun b a => weightedOver w doubling a (n + 2 + 1) < weightedOver w doubling b (n + 2 + 1))
        (rebuilding doubling 8 1 (n + 2)) ∧
      Frontier (OpenCourse doubling 16 1)
        (fun b a => weightedOver w doubling a (n + 2 + 1) < weightedOver w doubling b (n + 2 + 1))
        (holding 1 0 (n + 2))) ∧
    ((∀ t, t < n + 2 → 2 * w (t + 1) < w t) →
      ∀ x, Frontier (OpenCourse doubling 16 1)
        (fun b a => weightedOver w doubling a (n + 2 + 1) < weightedOver w doubling b (n + 2 + 1))
        x →
      ∀ t, t < n + 2 → x (t + 1) = 0) :=
  ⟨fun gentle =>
    have rises := fun t lt => doubling_rises (Nat.le_of_lt (gentle t lt).2)
    have strictly := fun t lt => doubling_rises_strictly (gentle t lt).2
    have top := fun t lt => doubling_top (gentle t lt).1 (Nat.le_of_lt (gentle t lt).2)
    ⟨rebuilding_frontier (Nat.succ_le_succ (Nat.zero_le 7)) doubling_grows rises top
      (Nat.le_refl 16) (Nat.zero_le 16),
     fun x front =>
      have both := Web.frontier_rebuilds (W := web (onSource x)) (c := Place.source)
        (fun _ _ less => less) (Nat.succ_le_succ (Nat.zero_le 7)) doubling_grows rises strictly top
        (Nat.le_refl 16) (Nat.zero_le 16) front
      have first := both.1 0 (Nat.succ_pos (n + 1)) (show 2 < 8 from by decide)
      have second := both.1 1 (Nat.succ_lt_succ (Nat.succ_pos n)) (show 4 < 8 from by decide)
      have rebuilt := frontier_rebuilt (fun _ _ less => less) (Nat.succ_le_succ (Nat.zero_le 7))
        doubling_grows rises (fun t lt => doubling_above (gentle t lt).1 (gentle t lt).2)
        (Nat.le_refl 16) (Nat.zero_le 16) front
      ⟨first.1, second.1, fun t two lt => match le_dest two with
        | ⟨i, split⟩ => rebuilt t lt (by
          rw [split, Nat.add_right_comm]
          exact rise_stays (j := 3) rfl i),
       first.2, second.2,
       both.2 .dweller 0 (Nat.succ_pos (n + 1)) (show 2 < 8 from by decide) (Nat.le_refl 2)⟩⟩,
   fun tie =>
    have gentle : ∀ t, t < n + 2 → w t ≤ 2 * w (t + 1) := fun t lt => Nat.le_of_eq (tie t lt)
    have falls : ∀ t, t < n + 2 → w (t + 1) ≤ w t := fun t lt =>
      Nat.le_trans (Nat.le_add_right _ _)
        (Nat.le_of_eq ((Nat.two_mul _).symm.trans (tie t lt).symm))
    ⟨rebuilding_frontier (Nat.succ_le_succ (Nat.zero_le 7)) doubling_grows
      (fun t lt => doubling_rises (gentle t lt))
      (fun t lt => doubling_top (falls t lt) (gentle t lt))
      (Nat.le_refl 16) (Nat.zero_le 16),
     exhausting_frontier (fun t lt => doubling_outpaced_le (tie t lt)) (by decide) (Nat.zero_le 16)
      (Nat.succ_pos (n + 1))⟩,
   fun steep x front => Optimum.frontier_exhausts (fun _ _ less => less)
    (fun t lt => doubling_outpaced (steep t lt)) (by decide) (Nat.zero_le 16) (Nat.succ_pos (n + 1))
    front⟩

end Holding

end Optimum
