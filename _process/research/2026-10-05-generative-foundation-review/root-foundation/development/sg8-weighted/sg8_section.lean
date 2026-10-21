/-! ## An order weighting later draws less

Above, every step's draw counts alike. Here the draw of the step from `t` is weighted by `w t`, any
weighting, as an order weighting later draws less does. What a course could draw at a step, with
what it drew before, all weighted, changes from one step to the next by what the level it leaves
gains: that level with its renewal weighted at the next step, against it held, weighted at this
one. So against an open course leaving nothing whose level at each step gains the most, every
optimum of every order rising with the weighted draw gains at each step what that course's level
gains and leaves nothing weighted at the end, and that course is an optimum; the course holding a
level of greatest weighted gain at every step is a case. With every weight one the gain of a level
is its renewal, and a level of greatest gain one of greatest renewal (above). Where the weighting
falls faster than every positive level renews, `w (t + 1) (z + R z) < w t z`, nothing is the only
level of greatest gain: every optimum draws its own base to nothing at the first step, breaking
every dependence on it; where some level within reach renews faster than the weighting falls, the
course holding it outdraws every course ending the base at once, and no optimum ends it at the
first step. -/

namespace Optimum

/-- What a course of levels `x` draws across `n` steps where `R` gives at each level, the draw of
the step from `t` weighted by `w t`. -/
def weightedOver (w R : Nat → Nat) (x : Nat → Nat) (n : Nat) : Nat :=
  Amounts.whole.sum (fun t => w t * drawnAt x (fun t => R (x t)) t) 0 n

/-- What a course drew, weighted, before the step from `t`, with all it could draw at that step,
its level there with what is given there, weighted by `w t`. -/
def drawable (w R : Nat → Nat) (x : Nat → Nat) (t : Nat) : Nat :=
  weightedOver w R x t + w t * (x t + R (x t))

variable {w R : Nat → Nat} {k s y m n : Nat}

/-- **The weighted draw to the last step.** Where each step leaves at most the level with what is
given, what a course draws across `n + 1` steps, weighted, with what it leaves weighted at the last
step, is what it could draw at the `n`-th with what it drew before. -/
theorem weighted_add_left {x : Nat → Nat} (within : ∀ t, x (t + 1) ≤ x t + R (x t)) (n : Nat) :
    weightedOver w R x (n + 1) + w n * x (n + 1) = drawable w R x n := by
  show weightedOver w R x n + w (0 + n) * drawnAt x (fun t => R (x t)) (0 + n) + w n * x (n + 1) =
    weightedOver w R x n + w n * (x n + R (x n))
  have back : x (n + 1) + drawnAt x (fun t => R (x t)) n = x n + R (x n) :=
    Naturals.add_sub_of_le (within n)
  rw [Nat.zero_add, Nat.add_assoc, ← Nat.mul_add, Nat.add_comm (drawnAt x (fun t => R (x t)) n),
    back]

/-- **A step of the weighted draw.** What a course could draw at the step from `t + 1`, with what
it drew before and the level it left there weighted by `w t`, is what it could draw at the step
from `t`, with what it drew before, and that level with its renewal weighted by `w (t + 1)`. -/
theorem drawable_step {x : Nat → Nat} (within : ∀ t, x (t + 1) ≤ x t + R (x t)) (t : Nat) :
    drawable w R x (t + 1) + w t * x (t + 1) =
      drawable w R x t + w (t + 1) * (x (t + 1) + R (x (t + 1))) := by
  show weightedOver w R x (t + 1) + w (t + 1) * (x (t + 1) + R (x (t + 1))) + w t * x (t + 1) =
    drawable w R x t + w (t + 1) * (x (t + 1) + R (x (t + 1)))
  rw [Nat.add_right_comm (weightedOver w R x (t + 1)), weighted_add_left within t]

/-- Two steps set side by side. -/
theorem add_steps {P P' H H' a b u v : Nat} (stepP : P' + a = P + u) (stepH : H' + b = H + v) :
    P' + (a + b) = P + (u + b) ∧ H' + (a + b) = H + (v + a) :=
  ⟨by rw [← Nat.add_assoc P' a b, stepP, Nat.add_assoc P u b],
   by rw [Nat.add_comm a b, ← Nat.add_assoc H' b a, stepH, Nat.add_assoc H v a]⟩

/-- **Against a course gaining the most.** Where each step of two courses from one start leaves
at most the level with what is given, and at each step to the `n`-th the level the first leaves
gains, weighted, at most what the level the second leaves gains (`w (t + 1)` on it with its renewal,
against `w t` on it held), what the first could draw at each step to the `n`-th, with what it drew
before, is at most what the second could. -/
theorem drawable_le_of_gains {x h : Nat → Nat} (within : ∀ t, x (t + 1) ≤ x t + R (x t))
    (withinH : ∀ t, h (t + 1) ≤ h t + R (h t)) (start : x 0 = h 0)
    (gains : ∀ t, t < n → w (t + 1) * (x (t + 1) + R (x (t + 1))) + w t * h (t + 1) ≤
      w (t + 1) * (h (t + 1) + R (h (t + 1))) + w t * x (t + 1)) :
    ∀ t, t ≤ n → drawable w R x t ≤ drawable w R h t
  | 0, _ => by
    show 0 + w 0 * (x 0 + R (x 0)) ≤ 0 + w 0 * (h 0 + R (h 0))
    rw [start]
    exact Nat.le_refl _
  | t + 1, le =>
    have sum := add_steps (drawable_step (w := w) within t) (drawable_step (w := w) withinH t)
    Naturals.le_of_add_le_add_right (k := w t * x (t + 1) + w t * h (t + 1))
      (Nat.le_trans (Nat.le_of_eq sum.1) (Nat.le_trans (Nat.add_le_add
        (drawable_le_of_gains within withinH start gains t (Nat.le_of_succ_le le))
        (gains t (Nat.lt_of_succ_le le))) (Nat.le_of_eq sum.2.symm)))

/-- Where, besides, the level the first course leaves at some step before the `n`-th gains less
than the second's, the first could draw less at every later step to the `n`-th. -/
theorem drawable_lt_of_gains {x h : Nat → Nat} (within : ∀ t, x (t + 1) ≤ x t + R (x t))
    (withinH : ∀ t, h (t + 1) ≤ h t + R (h t)) (start : x 0 = h 0)
    (gains : ∀ t, t < n → w (t + 1) * (x (t + 1) + R (x (t + 1))) + w t * h (t + 1) ≤
      w (t + 1) * (h (t + 1) + R (h (t + 1))) + w t * x (t + 1)) {j : Nat} (lt : j < n)
    (short : w (j + 1) * (x (j + 1) + R (x (j + 1))) + w j * h (j + 1) <
      w (j + 1) * (h (j + 1) + R (h (j + 1))) + w j * x (j + 1)) :
    ∀ i, j + 1 + i ≤ n → drawable w R x (j + 1 + i) < drawable w R h (j + 1 + i)
  | 0, _ =>
    have sum := add_steps (drawable_step (w := w) within j) (drawable_step (w := w) withinH j)
    Nat.lt_of_add_lt_add_right (Nat.lt_of_le_of_lt (Nat.le_of_eq sum.1)
      (Nat.lt_of_lt_of_le (Nat.add_lt_add_of_le_of_lt
        (drawable_le_of_gains within withinH start gains j (Nat.le_of_lt lt)) short)
        (Nat.le_of_eq sum.2.symm)))
  | i + 1, le =>
    have before : j + 1 + i < n := le
    have sum := add_steps (drawable_step (w := w) within (j + 1 + i))
      (drawable_step (w := w) withinH (j + 1 + i))
    Nat.lt_of_add_lt_add_right (Nat.lt_of_le_of_lt (Nat.le_of_eq sum.1)
      (Nat.lt_of_lt_of_le (Nat.add_lt_add_of_lt_of_le
        (drawable_lt_of_gains within withinH start gains lt short i (Nat.le_of_lt before))
        (gains _ before)) (Nat.le_of_eq sum.2.symm)))

/-- What a course leaving nothing at the last step draws, weighted, across `n + 1` steps is what it
could draw at the `n`-th with what it drew before. -/
theorem weighted_of_ends {h : Nat → Nat} (withinH : ∀ t, h (t + 1) ≤ h t + R (h t))
    (ends : h (n + 1) = 0) : weightedOver w R h (n + 1) = drawable w R h n :=
  (Nat.add_zero _).symm.trans ((congrArg (weightedOver w R h (n + 1) + w n * ·) ends).symm.trans
    (weighted_add_left withinH n))

/-- **No course outdraws, weighted, a course gaining the most and leaving nothing.** Where each
step of two courses from one start leaves at most the level with what is given, the second leaves
nothing at the last step, and at each step to the `n`-th the level the first leaves gains,
weighted, at most what the second's gains, the first draws across `n + 1` steps, weighted, at most
what the second does. -/
theorem weighted_le_of_gains {x h : Nat → Nat} (within : ∀ t, x (t + 1) ≤ x t + R (x t))
    (withinH : ∀ t, h (t + 1) ≤ h t + R (h t)) (start : x 0 = h 0) (ends : h (n + 1) = 0)
    (gains : ∀ t, t < n → w (t + 1) * (x (t + 1) + R (x (t + 1))) + w t * h (t + 1) ≤
      w (t + 1) * (h (t + 1) + R (h (t + 1))) + w t * x (t + 1)) :
    weightedOver w R x (n + 1) ≤ weightedOver w R h (n + 1) :=
  Nat.le_trans (Nat.le_add_right _ (w n * x (n + 1)))
    (Nat.le_trans (Nat.le_of_eq (weighted_add_left within n))
      (Nat.le_trans (drawable_le_of_gains within withinH start gains n (Nat.le_refl n))
        (Nat.le_of_eq (weighted_of_ends withinH ends).symm)))

/-- Where, besides, the level the first course leaves at some step before the `n`-th gains less
than the second's, or the first leaves something weighted at the last step, it draws less. -/
theorem weighted_lt_of_gains {x h : Nat → Nat} (within : ∀ t, x (t + 1) ≤ x t + R (x t))
    (withinH : ∀ t, h (t + 1) ≤ h t + R (h t)) (start : x 0 = h 0) (ends : h (n + 1) = 0)
    (gains : ∀ t, t < n → w (t + 1) * (x (t + 1) + R (x (t + 1))) + w t * h (t + 1) ≤
      w (t + 1) * (h (t + 1) + R (h (t + 1))) + w t * x (t + 1))
    (short : (∃ j, j < n ∧ w (j + 1) * (x (j + 1) + R (x (j + 1))) + w j * h (j + 1) <
      w (j + 1) * (h (j + 1) + R (h (j + 1))) + w j * x (j + 1)) ∨ 0 < w n * x (n + 1)) :
    weightedOver w R x (n + 1) < weightedOver w R h (n + 1) :=
  match short with
  | .inl ⟨j, lt, less⟩ => match le_dest (show j + 1 ≤ n from lt) with
    | ⟨i, split⟩ =>
      Nat.lt_of_le_of_lt (Nat.le_add_right _ (w n * x (n + 1)))
        (Nat.lt_of_le_of_lt (Nat.le_of_eq (weighted_add_left within n))
          (Nat.lt_of_lt_of_le
            (Eq.subst (motive := fun z => drawable w R x z < drawable w R h z) split.symm
              (drawable_lt_of_gains within withinH start gains lt less i (Nat.le_of_eq split.symm)))
            (Nat.le_of_eq (weighted_of_ends withinH ends).symm)))
  | .inr pos =>
    Nat.lt_of_lt_of_le (Nat.lt_add_of_pos_right pos)
      (Nat.le_trans (Nat.le_of_eq (weighted_add_left within n))
        (Nat.le_trans (drawable_le_of_gains within withinH start gains n (Nat.le_refl n))
          (Nat.le_of_eq (weighted_of_ends withinH ends).symm)))

/-- **A course of greatest weighted gain is an optimum.** Where an open course from `s` leaves
nothing at the last step and the level it leaves at each step to the `n`-th gains, weighted, at
least what any level does, it is an optimum, among the open courses, of the order by the weighted
draw across `n + 1` steps. -/
theorem weighted_frontier {h : Nat → Nat} (opens : OpenCourse R k s h) (ends : h (n + 1) = 0)
    (greatest : ∀ t, t < n → ∀ z, w (t + 1) * (z + R z) + w t * h (t + 1) ≤
      w (t + 1) * (h (t + 1) + R (h (t + 1))) + w t * z) :
    Frontier (OpenCourse R k s)
      (fun b a => weightedOver w R a (n + 1) < weightedOver w R b (n + 1)) h :=
  ⟨opens, fun b openB more => Nat.not_le_of_gt more
    (weighted_le_of_gains (fun t => (openB.2 t).1) (fun t => (opens.2 t).1)
      (openB.1.trans opens.1.symm) ends fun t lt => greatest t lt (b (t + 1)))⟩

/-- **Every optimum gains, at each step, what a course of greatest weighted gain gains, and leaves
nothing weighted.** Under the premises of `weighted_frontier`, every optimum of every order on the
courses open from the start that rises with the weighted draw across `n + 1` steps leaves, weighted
at the last step, nothing, and at each step to the `n`-th leaves a level gaining what the course of
greatest gain's level gains. -/
theorem frontier_gains_weighted {better : (Nat → Nat) → (Nat → Nat) → Prop}
    (rising : ∀ a b, weightedOver w R a (n + 1) < weightedOver w R b (n + 1) → better b a)
    {h : Nat → Nat} (opens : OpenCourse R k s h) (ends : h (n + 1) = 0)
    (greatest : ∀ t, t < n → ∀ z, w (t + 1) * (z + R z) + w t * h (t + 1) ≤
      w (t + 1) * (h (t + 1) + R (h (t + 1))) + w t * z)
    {x : Nat → Nat} (front : Frontier (OpenCourse R k s) better x) :
    w n * x (n + 1) = 0 ∧ ∀ t, t < n →
      w (t + 1) * (x (t + 1) + R (x (t + 1))) + w t * h (t + 1) =
        w (t + 1) * (h (t + 1) + R (h (t + 1))) + w t * x (t + 1) :=
  have gains : ∀ t, t < n → w (t + 1) * (x (t + 1) + R (x (t + 1))) + w t * h (t + 1) ≤
      w (t + 1) * (h (t + 1) + R (h (t + 1))) + w t * x (t + 1) :=
    fun t lt => greatest t lt (x (t + 1))
  have outdrawn : ¬ ((∃ j, j < n ∧ w (j + 1) * (x (j + 1) + R (x (j + 1))) + w j * h (j + 1) <
      w (j + 1) * (h (j + 1) + R (h (j + 1))) + w j * x (j + 1)) ∨ 0 < w n * x (n + 1)) :=
    fun short => front.2 _ opens (rising x _ (weighted_lt_of_gains (fun t => (front.1.2 t).1)
      (fun t => (opens.2 t).1) (front.1.1.trans opens.1.symm) ends gains short))
  ⟨match Nat.eq_zero_or_pos (w n * x (n + 1)) with
    | .inl zero => zero
    | .inr pos => absurd (Or.inr pos) outdrawn,
   fun t lt => match Nat.lt_or_ge (w (t + 1) * (x (t + 1) + R (x (t + 1))) + w t * h (t + 1))
      (w (t + 1) * (h (t + 1) + R (h (t + 1))) + w t * x (t + 1)) with
    | .inl less => absurd (Or.inl ⟨t, lt, less⟩) outdrawn
    | .inr ge => Nat.le_antisymm (gains t lt) ge⟩

/-- **Every optimum stands below a need above every level of greatest weighted gain.** Under the
premises of `weighted_frontier`, where every level at or above `m` gains, weighted, less than the
course of greatest gain's level at each step to the `n`-th, every optimum of every order rising
with the weighted draw stands below `m` at every step from the first to the `n`-th. -/
theorem frontier_below_weighted {better : (Nat → Nat) → (Nat → Nat) → Prop}
    (rising : ∀ a b, weightedOver w R a (n + 1) < weightedOver w R b (n + 1) → better b a)
    {h : Nat → Nat} (opens : OpenCourse R k s h) (ends : h (n + 1) = 0)
    (greatest : ∀ t, t < n → ∀ z, w (t + 1) * (z + R z) + w t * h (t + 1) ≤
      w (t + 1) * (h (t + 1) + R (h (t + 1))) + w t * z)
    (above : ∀ t, t < n → ∀ z, m ≤ z → w (t + 1) * (z + R z) + w t * h (t + 1) <
      w (t + 1) * (h (t + 1) + R (h (t + 1))) + w t * z)
    {x : Nat → Nat} (front : Frontier (OpenCourse R k s) better x) :
    ∀ t, t < n → x (t + 1) < m :=
  fun t lt => match Nat.lt_or_ge (x (t + 1)) m with
  | .inl below => below
  | .inr ge => absurd ((frontier_gains_weighted rising opens ends greatest front).2 t lt)
      (Nat.ne_of_lt (above t lt _ ge))

/-- The course holding `y` and leaving nothing is open over a horizon of at least two steps, with a
capacity covering what the first step draws down to `y`, `y` with its renewal, and what is given at
nothing. -/
theorem holding_open_at (reach : y ≤ s + R s) (drawsDown : s + R s ≤ y + k) (holds : y + R y ≤ k)
    (rests : R 0 ≤ k) (long : 0 < n) : OpenCourse R k s (holding s y n) :=
  holdingTo_open rfl reach (Nat.zero_le y) drawsDown
    (Nat.le_trans holds (Nat.le_of_eq (Nat.zero_add k).symm)) rests long

/-- What `y` gains at each step, said of the course holding it. -/
theorem holding_gains {P : Nat → Nat → Prop} (at_y : ∀ t, t < n → P t y) :
    ∀ t, t < n → P t (holding s y n (t + 1)) :=
  fun t lt => Eq.subst (motive := P t) (holding_before lt).symm (at_y t lt)

/-- **The course holding a level of greatest weighted gain is an optimum**, where `y` is within the
start with what is given there and gains, weighted, at each step to the `n`-th at least what any
level does, over a horizon of at least two steps, with a capacity covering what the first step
draws down to `y`, `y` with its renewal, and what is given at nothing: the case of
`weighted_frontier`. -/
theorem weighted_holding_frontier
    (greatest : ∀ t, t < n → ∀ z, w (t + 1) * (z + R z) + w t * y ≤ w (t + 1) * (y + R y) + w t * z)
    (reach : y ≤ s + R s) (drawsDown : s + R s ≤ y + k) (holds : y + R y ≤ k) (rests : R 0 ≤ k)
    (long : 0 < n) :
    Frontier (OpenCourse R k s)
      (fun b a => weightedOver w R a (n + 1) < weightedOver w R b (n + 1)) (holding s y n) :=
  weighted_frontier (holding_open_at reach drawsDown holds rests long)
    (holding_after (Nat.le_refl n))
    (holding_gains (P := fun t v => ∀ z, w (t + 1) * (z + R z) + w t * v ≤
      w (t + 1) * (v + R v) + w t * z) greatest)

/-- Where the weighting falls at least as fast as every positive level renews, nothing gains at
least what any level does. -/
theorem outpaced_greatest (outpaced : ∀ t, t < n → ∀ z, 0 < z → w (t + 1) * (z + R z) ≤ w t * z) :
    ∀ t, t < n → ∀ z, w (t + 1) * (z + R z) + w t * 0 ≤ w (t + 1) * (0 + R 0) + w t * z :=
  fun t lt z => match Nat.eq_zero_or_pos z with
  | .inl zero => by subst zero; exact Nat.le_refl _
  | .inr pos => Nat.le_trans (Nat.le_of_eq (Nat.add_zero _))
      (Nat.le_trans (outpaced t lt z pos) (Nat.le_add_left _ _))

/-- Where the weighting falls faster than every positive level renews, every positive level gains
less than nothing does. -/
theorem outpaced_above (strictly : ∀ t, t < n → ∀ z, 0 < z → w (t + 1) * (z + R z) < w t * z) :
    ∀ t, t < n → ∀ z, 1 ≤ z → w (t + 1) * (z + R z) + w t * 0 < w (t + 1) * (0 + R 0) + w t * z :=
  fun t lt z pos => Nat.lt_of_le_of_lt (Nat.le_of_eq (Nat.add_zero _))
    (Nat.lt_of_lt_of_le (strictly t lt z pos) (Nat.le_add_left _ _))

/-- **The course ending the base at once is an optimum** where the weighting falls at least as fast
as every positive level renews, over a horizon of at least two steps, with a capacity covering the
start with what is given there and what is given at nothing. -/
theorem exhausting_frontier
    (outpaced : ∀ t, t < n → ∀ z, 0 < z → w (t + 1) * (z + R z) ≤ w t * z)
    (drawsDown : s + R s ≤ k) (rests : R 0 ≤ k) (long : 0 < n) :
    Frontier (OpenCourse R k s)
      (fun b a => weightedOver w R a (n + 1) < weightedOver w R b (n + 1)) (holding s 0 n) :=
  weighted_holding_frontier (outpaced_greatest outpaced) (Nat.zero_le _)
    (Nat.le_trans drawsDown (Nat.le_of_eq (Nat.zero_add k).symm))
    (Nat.le_trans (Nat.le_of_eq (Nat.zero_add _)) rests) rests long

/-- **A weighting falling faster than every level renews ends the base at once.** Where the
weighting falls faster than every positive level renews at each step to the `n`-th, `w (t + 1)`
on a level with its renewal less than `w t` on it held, over a horizon of at least two steps, with
a capacity covering the start with what is given there and what is given at nothing, every optimum
of every order on the courses open from the start that rises with the weighted draw across `n + 1`
steps stands at nothing at every step from the first to the `n`-th. -/
theorem frontier_exhausts {better : (Nat → Nat) → (Nat → Nat) → Prop}
    (rising : ∀ a b, weightedOver w R a (n + 1) < weightedOver w R b (n + 1) → better b a)
    (strictly : ∀ t, t < n → ∀ z, 0 < z → w (t + 1) * (z + R z) < w t * z)
    (drawsDown : s + R s ≤ k) (rests : R 0 ≤ k) (long : 0 < n) {x : Nat → Nat}
    (front : Frontier (OpenCourse R k s) better x) : ∀ t, t < n → x (t + 1) = 0 :=
  fun t lt => Nat.le_antisymm (Nat.le_of_lt_succ (frontier_below_weighted (m := 1) rising
      (holding_open_at (Nat.zero_le _) (Nat.le_trans drawsDown (Nat.le_of_eq (Nat.zero_add k).symm))
        (Nat.le_trans (Nat.le_of_eq (Nat.zero_add _)) rests) rests long)
      (holding_after (Nat.le_refl n))
      (holding_gains (P := fun t v => ∀ z, w (t + 1) * (z + R z) + w t * v ≤
        w (t + 1) * (v + R v) + w t * z)
        (outpaced_greatest fun t lt z pos => Nat.le_of_lt (strictly t lt z pos)))
      (holding_gains (P := fun t v => ∀ z, 1 ≤ z → w (t + 1) * (z + R z) + w t * v <
        w (t + 1) * (v + R v) + w t * z) (outpaced_above strictly)) front t lt))
    (Nat.zero_le _)

/-- **Ending the base at once is outdrawn by a level renewing faster than the weighting falls.**
Where each step of a course from `s` leaves at most the level with what is given and the course
stands at nothing at every step from the first to the `n`-th, and some `y` within the start with
what is given there gains, weighted, more than nothing does at each step to the `n`-th, over a
horizon of at least two steps, the course holding `y` and leaving nothing draws more, weighted,
across `n + 1` steps. -/
theorem ended_outdrawn {x : Nat → Nat} (within : ∀ t, x (t + 1) ≤ x t + R (x t))
    (start : x 0 = s) (ended : ∀ t, t < n → x (t + 1) = 0) (reach : y ≤ s + R s)
    (outgrows : ∀ t, t < n → w (t + 1) * (0 + R 0) + w t * y < w (t + 1) * (y + R y))
    (long : 0 < n) :
    weightedOver w R x (n + 1) < weightedOver w R (holding s y n) (n + 1) :=
  have gains : ∀ t, t < n → w (t + 1) * (x (t + 1) + R (x (t + 1))) + w t * holding s y n (t + 1) <
      w (t + 1) * (holding s y n (t + 1) + R (holding s y n (t + 1))) + w t * x (t + 1) :=
    fun t lt => by
      rw [ended t lt, holding_before lt]
      exact outgrows t lt
  weighted_lt_of_gains within (holding_within reach n) start (holding_after (Nat.le_refl n))
    (fun t lt => Nat.le_of_lt (gains t lt)) (.inl ⟨0, long, gains 0 long⟩)

/-- A course leaving at most the level with what is given stays at nothing after reaching it, where
nothing is given at nothing. -/
theorem stays_empty {x : Nat → Nat} (within : ∀ t, x (t + 1) ≤ x t + R (x t)) (empty : R 0 = 0)
    (ended : x 1 = 0) : ∀ t, x (t + 1) = 0
  | 0 => ended
  | t + 1 => Nat.le_antisymm (Nat.le_trans (within (t + 1))
      (Nat.le_of_eq (by rw [stays_empty within empty ended t, empty]))) (Nat.zero_le _)

/-- **No optimum ends the base at once where a level renews faster than the weighting falls.**
Where nothing is given at nothing and some `y` within the start with what is given there renews
faster than the weighting falls at each step to the `n`-th, `w t y < w (t + 1) (y + R y)`, over a
horizon of at least two steps, with a capacity covering what the first step draws down to `y` and
`y` with its renewal, no optimum of any order on the courses open from the start that rises with
the weighted draw across `n + 1` steps stands at nothing after the first step. -/
theorem frontier_leaves {better : (Nat → Nat) → (Nat → Nat) → Prop}
    (rising : ∀ a b, weightedOver w R a (n + 1) < weightedOver w R b (n + 1) → better b a)
    (empty : R 0 = 0) (outgrows : ∀ t, t < n → w t * y < w (t + 1) * (y + R y))
    (reach : y ≤ s + R s) (drawsDown : s + R s ≤ y + k) (holds : y + R y ≤ k) (long : 0 < n)
    {x : Nat → Nat} (front : Frontier (OpenCourse R k s) better x) : 0 < x 1 :=
  have nothing : ∀ t, t < n → w (t + 1) * (0 + R 0) + w t * y < w (t + 1) * (y + R y) :=
    fun t lt => by
      rw [empty]
      exact Nat.lt_of_le_of_lt (Nat.le_of_eq (Nat.zero_add _)) (outgrows t lt)
  match Nat.eq_zero_or_pos (x 1) with
  | .inr pos => pos
  | .inl ended => absurd
      (rising x _ (ended_outdrawn (fun t => (front.1.2 t).1) front.1.1
        (fun t _ => stays_empty (fun t => (front.1.2 t).1) empty ended t) reach nothing long))
      (front.2 _ (holding_open_at reach drawsDown holds
        (Nat.le_trans (Nat.le_of_eq empty) (Nat.zero_le k)) long))

end Optimum

namespace Web

open Optimum

variable {W : Web F C} {c : C} {f : F} {w R : Nat → Nat} {k s y m n : Nat}
  {better : (Nat → Nat) → (Nat → Nat) → Prop}

/-- **A dependence above every level of greatest weighted gain is broken at the first step.**
Under the premises of `Optimum.frontier_below_weighted`, over a horizon of at least two steps, with
a formation depending on the condition at the start, met there, and needing at least `m`: every
optimum, among the open courses, of every order rising with the weighted draw breaks the dependence
at the first step. -/
theorem frontier_broken_weighted
    (rising : ∀ a b, weightedOver w R a (n + 1) < weightedOver w R b (n + 1) → better b a)
    {h : Nat → Nat} (opens : OpenCourse R k s h) (ends : h (n + 1) = 0)
    (greatest : ∀ t, t < n → ∀ z, w (t + 1) * (z + R z) + w t * h (t + 1) ≤
      w (t + 1) * (h (t + 1) + R (h (t + 1))) + w t * z)
    (above : ∀ t, t < n → ∀ z, m ≤ z → w (t + 1) * (z + R z) + w t * h (t + 1) <
      w (t + 1) * (h (t + 1) + R (h (t + 1))) + w t * z)
    (long : 0 < n) (front : Frontier (OpenCourse R k s) better fun t => W.level t c)
    (depends : W.requires 0 f c) (met : W.need 0 f c ≤ W.level 0 c) (need : m ≤ W.need 0 f c) :
    W.Broken 0 f c :=
  ⟨depends, met, Nat.lt_of_lt_of_le (Optimum.frontier_below_weighted rising opens ends greatest
    above front 0 long) need⟩

/-- **A weighting falling faster than every level renews ends the condition at once.** Under the
premises of `Optimum.frontier_exhausts`, every optimum, among the open courses, of every order
rising with the weighted draw leaves the condition at nothing at every step from the first to the
`n`-th, and breaks at the first step every dependence on it with a positive need, met at the
start. -/
theorem frontier_exhausts
    (rising : ∀ a b, weightedOver w R a (n + 1) < weightedOver w R b (n + 1) → better b a)
    (strictly : ∀ t, t < n → ∀ z, 0 < z → w (t + 1) * (z + R z) < w t * z)
    (drawsDown : s + R s ≤ k) (rests : R 0 ≤ k) (long : 0 < n)
    (front : Frontier (OpenCourse R k s) better fun t => W.level t c)
    (depends : W.requires 0 f c) (met : W.need 0 f c ≤ W.level 0 c) (needs : 0 < W.need 0 f c) :
    W.Broken 0 f c ∧ ∀ t, t < n → W.level (t + 1) c = 0 :=
  have ended := Optimum.frontier_exhausts rising strictly drawsDown rests long front
  ⟨⟨depends, met, Nat.lt_of_le_of_lt (Nat.le_of_eq (ended 0 long)) needs⟩, ended⟩

/-- **Where a level renews faster than the weighting falls, no optimum ends the condition at
once.** Under the premises of `Optimum.frontier_leaves`, every optimum, among the open courses, of
every order rising with the weighted draw leaves the condition above nothing after the first
step. -/
theorem frontier_leaves
    (rising : ∀ a b, weightedOver w R a (n + 1) < weightedOver w R b (n + 1) → better b a)
    (empty : R 0 = 0) (outgrows : ∀ t, t < n → w t * y < w (t + 1) * (y + R y))
    (reach : y ≤ s + R s) (drawsDown : s + R s ≤ y + k) (holds : y + R y ≤ k) (long : 0 < n)
    (front : Frontier (OpenCourse R k s) better fun t => W.level t c) : 0 < W.level 1 c :=
  Optimum.frontier_leaves rising empty outgrows reach drawsDown holds long front

end Web

namespace Optimum

namespace Holding

open Diversion

/-- Under the logistic law a level renews at most itself. -/
theorem logistic_le_self : ∀ z, logistic z ≤ z
  | 0 => Nat.le_refl 0
  | 1 => Nat.le_refl 1
  | z + 2 => Nat.le_trans (Nat.le_of_eq (logistic_beyond z)) (Nat.zero_le _)

/-- Under the logistic law, where a weight `a` is at least twice `b`, a positive level gains,
weighted by `b` at the next step, at most what it does held, weighted by `a`. -/
theorem logistic_outpaced_le {a b : Nat} (steep : 2 * b ≤ a) :
    ∀ z, 0 < z → b * (z + logistic z) ≤ a * z :=
  fun z _ => calc b * (z + logistic z) ≤ b * (z + z) :=
        Nat.mul_le_mul_left b (Nat.add_le_add_left (logistic_le_self z) z)
    _ = 2 * b * z := by rw [Nat.mul_add, ← Nat.two_mul, mul_assoc_nat]
    _ ≤ a * z := Nat.mul_le_mul_right z steep

/-- Under the logistic law, where a weight `a` is more than twice `b`, a positive level gains,
weighted by `b` at the next step, less than what it does held, weighted by `a`. -/
theorem logistic_outpaced {a b : Nat} (steep : 2 * b < a) :
    ∀ z, 0 < z → b * (z + logistic z) < a * z :=
  fun z pos => Nat.lt_of_le_of_lt (logistic_outpaced_le (Nat.le_refl _) z pos)
    (match le_dest (show 1 ≤ z from pos) with
    | ⟨i, split⟩ => by
      rw [split, Nat.add_comm 1 i, Nat.mul_succ, Nat.mul_succ]
      exact Nat.add_lt_add_of_le_of_lt (Nat.mul_le_mul_right i (Nat.le_of_lt steep)) steep)

/-- Under the logistic law, with a weight `a` at a step at least `b` at the next, a level of two or
more gains, weighted, with `a` to spare, at most what one gains. -/
theorem logistic_beyond_gain {a b : Nat} (falls : b ≤ a) (z : Nat) :
    b * (z + 2 + logistic (z + 2)) + a * 1 + a ≤ b * (1 + logistic 1) + a * (z + 2) := by
  rw [logistic_beyond z, Nat.add_zero, Nat.mul_one]
  show b * (z + 2) + a + a ≤ b * 2 + a * (z + 2)
  rw [Nat.mul_add b z 2, Nat.mul_add a z 2, Nat.mul_two a, Nat.add_assoc (b * z + b * 2) a a,
    Nat.add_comm (b * z) (b * 2), Nat.add_assoc (b * 2) (b * z) (a + a)]
  exact Nat.add_le_add_left (Nat.add_le_add_right (Nat.mul_le_mul_right z falls) (a + a)) (b * 2)

/-- **One gains the most under the logistic law** where the weight falls by at most half a step:
with `b ≤ a ≤ 2 b`, no level gains, weighted, more than one does. -/
theorem logistic_gain_le {a b : Nat} (falls : b ≤ a) (gentle : a ≤ 2 * b) :
    ∀ z, b * (z + logistic z) + a * 1 ≤ b * (1 + logistic 1) + a * z
  | 0 => by
    show b * 0 + a * 1 ≤ b * 2 + a * 0
    rw [Nat.mul_zero b, Nat.mul_zero a, Nat.zero_add, Nat.add_zero, Nat.mul_one, Nat.mul_comm b 2]
    exact gentle
  | 1 => Nat.le_refl _
  | z + 2 => Nat.le_trans (Nat.le_add_right _ a) (logistic_beyond_gain falls z)

/-- Under the logistic law, with a positive weight `b` at most `a`, every level of two or more
gains less than one does. -/
theorem logistic_gain_lt {a b : Nat} (falls : b ≤ a) (pos : 0 < b) :
    ∀ z, 2 ≤ z → b * (z + logistic z) + a * 1 < b * (1 + logistic 1) + a * z
  | 0, le => absurd le (Nat.not_succ_le_zero 1)
  | 1, le => absurd le (Nat.not_succ_le_self 1)
  | z + 2, _ => Nat.lt_of_lt_of_le (Nat.lt_add_of_pos_right (Nat.lt_of_lt_of_le pos falls))
      (logistic_beyond_gain falls z)

/-- Under the logistic law, where the weight falls by less than half a step, nothing gains less
than one does. -/
theorem logistic_gain_zero {a b : Nat} (gentle : a < 2 * b) :
    b * (0 + logistic 0) + a * 1 < b * (1 + logistic 1) + a * 0 := by
  show b * 0 + a * 1 < b * 2 + a * 0
  rw [Nat.mul_zero b, Nat.mul_zero a, Nat.zero_add, Nat.add_zero, Nat.mul_one, Nat.mul_comm b 2]
  exact gentle

/-- A weight less than twice another leaves the other positive. -/
theorem pos_of_lt_two_mul {a b : Nat} (lt : a < 2 * b) : 0 < b :=
  match Nat.eq_zero_or_pos b with
  | .inl zero => absurd (Eq.subst (motive := fun z => a < 2 * z) zero lt) (Nat.not_lt_zero a)
  | .inr pos => pos

/-- **The logistic witness: a weighting falling faster or slower than the source renews.** From a
source at two under the logistic law with capacity two, the order by what the taker draws over
`n + 2` steps, the draw of the step from `t` weighted by `w t`. One, the level of greatest renewal,
returns two for one. Where the weight falls more than twofold at every step, `2 w (t + 1) < w t`,
the course drawing the source to nothing at the first step is an optimum, and every optimum draws
the source to nothing there and breaks the dweller, which needs two (`exhausting_frontier`,
`Web.frontier_exhausts`). Where it falls exactly twofold, the course ending the source at once and
the course holding it at one are both optima: neither strict premise can be dropped. Where it falls
at a step by less than half, `w (t + 1) ≤ w t < 2 w (t + 1)`, the course holding the source at one
is an optimum, and every optimum holds it at one at every step to the last and breaks the dweller
at the first step (`weighted_holding_frontier`, `frontier_gains_weighted`,
`Web.frontier_broken_weighted`). -/
theorem logistic_weighted (n : Nat) (w : Nat → Nat) :
    ((∀ t, t < n + 1 → 2 * w (t + 1) < w t) →
      Frontier (OpenCourse logistic 2 2)
        (fun b a => weightedOver w logistic a (n + 1 + 1) < weightedOver w logistic b (n + 1 + 1))
        (holding 2 0 (n + 1)) ∧
      ∀ x, Frontier (OpenCourse logistic 2 2)
        (fun b a => weightedOver w logistic a (n + 1 + 1) < weightedOver w logistic b (n + 1 + 1))
        x →
      (web (onSource x)).Broken 0 .dweller .source ∧
        ∀ t, t < n + 1 → (web (onSource x)).level (t + 1) .source = 0) ∧
    ((∀ t, t < n + 1 → w t = 2 * w (t + 1)) →
      Frontier (OpenCourse logistic 2 2)
        (fun b a => weightedOver w logistic a (n + 1 + 1) < weightedOver w logistic b (n + 1 + 1))
        (holding 2 0 (n + 1)) ∧
      Frontier (OpenCourse logistic 2 2)
        (fun b a => weightedOver w logistic a (n + 1 + 1) < weightedOver w logistic b (n + 1 + 1))
        (holding 2 1 (n + 1))) ∧
    ((∀ t, t < n + 1 → w (t + 1) ≤ w t ∧ w t < 2 * w (t + 1)) →
      Frontier (OpenCourse logistic 2 2)
        (fun b a => weightedOver w logistic a (n + 1 + 1) < weightedOver w logistic b (n + 1 + 1))
        (holding 2 1 (n + 1)) ∧
      ∀ x, Frontier (OpenCourse logistic 2 2)
        (fun b a => weightedOver w logistic a (n + 1 + 1) < weightedOver w logistic b (n + 1 + 1))
        x →
      (web (onSource x)).Broken 0 .dweller .source ∧
        ∀ t, t < n + 1 → (web (onSource x)).level (t + 1) .source = 1) :=
  ⟨fun steep =>
    have strictly : ∀ t, t < n + 1 → ∀ z, 0 < z →
        w (t + 1) * (z + logistic z) < w t * z := fun t lt => logistic_outpaced (steep t lt)
    ⟨exhausting_frontier (fun t lt z pos => Nat.le_of_lt (strictly t lt z pos)) (Nat.le_refl 2)
      (Nat.zero_le 2) (Nat.succ_pos n),
     fun x front =>
      Web.frontier_exhausts (W := web (onSource x)) (c := Place.source) (f := Formation.dweller)
        (fun _ _ less => less) strictly (Nat.le_refl 2) (Nat.zero_le 2) (Nat.succ_pos n) front
        trivial (Nat.le_of_eq front.1.1.symm) (Nat.succ_pos 1)⟩,
   fun tie =>
    ⟨exhausting_frontier (fun t lt => logistic_outpaced_le (Nat.le_of_eq (tie t lt).symm))
      (Nat.le_refl 2) (Nat.zero_le 2) (Nat.succ_pos n),
     weighted_holding_frontier (fun t lt => logistic_gain_le
        (Nat.le_trans (Nat.le_add_right _ _)
          (Nat.le_of_eq ((Nat.two_mul _).symm.trans (tie t lt).symm)))
        (Nat.le_of_eq (tie t lt)))
      (Nat.le_succ 1) (Nat.le_succ 2) (Nat.le_refl 2) (Nat.zero_le 2) (Nat.succ_pos n)⟩,
   fun gentle =>
    have greatest : ∀ t, t < n + 1 → ∀ z, w (t + 1) * (z + logistic z) + w t * 1 ≤
        w (t + 1) * (1 + logistic 1) + w t * z :=
      fun t lt => logistic_gain_le (gentle t lt).1 (Nat.le_of_lt (gentle t lt).2)
    have above : ∀ t, t < n + 1 → ∀ z, 2 ≤ z → w (t + 1) * (z + logistic z) + w t * 1 <
        w (t + 1) * (1 + logistic 1) + w t * z :=
      fun t lt => logistic_gain_lt (gentle t lt).1 (pos_of_lt_two_mul (gentle t lt).2)
    ⟨weighted_holding_frontier greatest (Nat.le_succ 1) (Nat.le_succ 2) (Nat.le_refl 2)
      (Nat.zero_le 2) (Nat.succ_pos n),
     fun x front =>
      have opens := holding_open_at (s := 2) (k := 2) (n := n + 1) (R := logistic) (y := 1)
        (Nat.le_succ 1) (Nat.le_succ 2) (Nat.le_refl 2) (Nat.zero_le 2) (Nat.succ_pos n)
      have ends := holding_after (s := 2) (y := 1) (Nat.le_refl (n + 1))
      have greatestH := holding_gains (s := 2) (P := fun t v => ∀ z, w (t + 1) * (z + logistic z) +
        w t * v ≤ w (t + 1) * (v + logistic v) + w t * z) greatest
      have aboveH := holding_gains (s := 2) (P := fun t v => ∀ z, 2 ≤ z →
        w (t + 1) * (z + logistic z) + w t * v < w (t + 1) * (v + logistic v) + w t * z) above
      have below := frontier_below_weighted (m := 2) (fun _ _ less => less) opens ends greatestH
        aboveH front
      have gains := (frontier_gains_weighted (fun _ _ less => less) opens ends greatestH front).2
      ⟨Web.frontier_broken_weighted (W := web (onSource x)) (c := Place.source)
          (f := Formation.dweller) (m := 2) (fun _ _ less => less) opens ends greatestH aboveH
          (Nat.succ_pos n) front trivial (Nat.le_of_eq front.1.1.symm) (Nat.le_refl 2),
       fun t lt => match Nat.eq_zero_or_pos (x (t + 1)) with
        | .inl zero => by
          have same := gains t lt
          rw [zero, holding_before lt] at same
          exact absurd same (Nat.ne_of_lt (logistic_gain_zero (gentle t lt).2))
        | .inr pos => Nat.le_antisymm (Nat.le_of_lt_succ (below t lt)) pos⟩⟩⟩

end Holding

end Optimum
