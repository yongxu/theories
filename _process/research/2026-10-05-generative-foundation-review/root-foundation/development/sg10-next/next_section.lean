/-! ## Over every law of what stands

The laws below on an order weighting later draws less, and on rebuilding from below, read what
stands to be drawn at a step as the level with its renewal, `z + R z`. Each uses that amount alone,
step by step, so each holds over any law `G` of what stands: at the step from `t`, a level `z` there
gives `G t z` to be drawn or left. The law may change with the step, give less than the level (a
base that decays, or one from which others draw first) or more. They are stated here over every such
law; below, the renewal law, `G t z = z + R z`, is their case. -/

namespace Optimum

/-- Two steps set side by side. -/
theorem add_steps {P P' H H' a b u v : Nat} (stepP : P' + a = P + u) (stepH : H' + b = H + v) :
    P' + (a + b) = P + (u + b) ∧ H' + (a + b) = H + (v + a) :=
  ⟨by rw [← Nat.add_assoc P' a b, stepP, Nat.add_assoc P u b],
   by rw [Nat.add_comm a b, ← Nat.add_assoc H' b a, stepH, Nat.add_assoc H v a]⟩

/-- What `y` gains at each step, said of the course holding it. -/
theorem holding_gains {s y n : Nat} {P : Nat → Nat → Prop} (at_y : ∀ t, t < n → P t y) :
    ∀ t, t < n → P t (holding s y n (t + 1)) :=
  fun t lt => Eq.subst (motive := P t) (holding_before lt).symm (at_y t lt)

namespace Next

/-- **The courses open under a law of what stands.** From level `s`, where a level `z` at the step
from `t` gives `G t z` to be drawn or left: each step leaves at most what stands, and draws at most
`k`. -/
def Open (G : Nat → Nat → Nat) (k s : Nat) (x : Nat → Nat) : Prop :=
  x 0 = s ∧ ∀ t, x (t + 1) ≤ G t (x t) ∧ G t (x t) - x (t + 1) ≤ k

/-- What a course of levels `x` draws across `n` steps under `G`, the draw of the step from `t`
weighted by `w t`. -/
def weighted (w : Nat → Nat) (G : Nat → Nat → Nat) (x : Nat → Nat) (n : Nat) : Nat :=
  Amounts.whole.sum (fun t => w t * (G t (x t) - x (t + 1))) 0 n

/-- What a course drew under `G`, weighted, before the step from `t`, with all it could draw at that
step, what stands there, weighted by `w t`. -/
def drawable (w : Nat → Nat) (G : Nat → Nat → Nat) (x : Nat → Nat) (t : Nat) : Nat :=
  weighted w G x t + w t * G t (x t)

variable {w : Nat → Nat} {G : Nat → Nat → Nat} {k s y m n : Nat}

/-- **The weighted draw to the last step.** Where each step leaves at most what stands, what a
course draws across `n + 1` steps, weighted, with what it leaves weighted at the last step, is what
it could draw at the `n`-th with what it drew before. -/
theorem weighted_add_left {x : Nat → Nat} (within : ∀ t, x (t + 1) ≤ G t (x t)) (n : Nat) :
    weighted w G x (n + 1) + w n * x (n + 1) = drawable w G x n := by
  show weighted w G x n + w (0 + n) * (G (0 + n) (x (0 + n)) - x (0 + n + 1)) + w n * x (n + 1) =
    weighted w G x n + w n * G n (x n)
  have back : x (n + 1) + (G n (x n) - x (n + 1)) = G n (x n) := Naturals.add_sub_of_le (within n)
  rw [Nat.zero_add, Nat.add_assoc, ← Nat.mul_add, Nat.add_comm (G n (x n) - x (n + 1)), back]

/-- **A step of the weighted draw.** What a course could draw at the step from `t + 1`, with what it
drew before and the level it left there weighted by `w t`, is what it could draw at the step from
`t`, with what it drew before, and what stands at that level weighted by `w (t + 1)`. -/
theorem drawable_step {x : Nat → Nat} (within : ∀ t, x (t + 1) ≤ G t (x t)) (t : Nat) :
    drawable w G x (t + 1) + w t * x (t + 1) =
      drawable w G x t + w (t + 1) * G (t + 1) (x (t + 1)) := by
  show weighted w G x (t + 1) + w (t + 1) * G (t + 1) (x (t + 1)) + w t * x (t + 1) =
    drawable w G x t + w (t + 1) * G (t + 1) (x (t + 1))
  rw [Nat.add_right_comm (weighted w G x (t + 1)), weighted_add_left within t]

/-- **Against a course gaining the most.** Where each step of two courses from one start leaves at
most what stands, and at each step to the `n`-th the level the first leaves gains, weighted, at most
what the level the second leaves gains (`w (t + 1)` on what stands at it, against `w t` on it held),
what the first could draw at each step to the `n`-th, with what it drew before, is at most what the
second could. -/
theorem drawable_le_of_gains {x h : Nat → Nat} (within : ∀ t, x (t + 1) ≤ G t (x t))
    (withinH : ∀ t, h (t + 1) ≤ G t (h t)) (start : x 0 = h 0)
    (gains : ∀ t, t < n → w (t + 1) * G (t + 1) (x (t + 1)) + w t * h (t + 1) ≤
      w (t + 1) * G (t + 1) (h (t + 1)) + w t * x (t + 1)) :
    ∀ t, t ≤ n → drawable w G x t ≤ drawable w G h t
  | 0, _ => by
    show 0 + w 0 * G 0 (x 0) ≤ 0 + w 0 * G 0 (h 0)
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
theorem drawable_lt_of_gains {x h : Nat → Nat} (within : ∀ t, x (t + 1) ≤ G t (x t))
    (withinH : ∀ t, h (t + 1) ≤ G t (h t)) (start : x 0 = h 0)
    (gains : ∀ t, t < n → w (t + 1) * G (t + 1) (x (t + 1)) + w t * h (t + 1) ≤
      w (t + 1) * G (t + 1) (h (t + 1)) + w t * x (t + 1)) {j : Nat} (lt : j < n)
    (short : w (j + 1) * G (j + 1) (x (j + 1)) + w j * h (j + 1) <
      w (j + 1) * G (j + 1) (h (j + 1)) + w j * x (j + 1)) :
    ∀ i, j + 1 + i ≤ n → drawable w G x (j + 1 + i) < drawable w G h (j + 1 + i)
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
theorem weighted_of_ends {h : Nat → Nat} (withinH : ∀ t, h (t + 1) ≤ G t (h t))
    (ends : h (n + 1) = 0) : weighted w G h (n + 1) = drawable w G h n :=
  (Nat.add_zero _).symm.trans ((congrArg (weighted w G h (n + 1) + w n * ·) ends).symm.trans
    (weighted_add_left withinH n))

/-- **No course outdraws, weighted, a course gaining the most and leaving nothing.** Where each step
of two courses from one start leaves at most what stands, the second leaves nothing at the last
step, and at each step to the `n`-th the level the first leaves gains, weighted, at most what the
second's gains, the first draws across `n + 1` steps, weighted, at most what the second does. -/
theorem weighted_le_of_gains {x h : Nat → Nat} (within : ∀ t, x (t + 1) ≤ G t (x t))
    (withinH : ∀ t, h (t + 1) ≤ G t (h t)) (start : x 0 = h 0) (ends : h (n + 1) = 0)
    (gains : ∀ t, t < n → w (t + 1) * G (t + 1) (x (t + 1)) + w t * h (t + 1) ≤
      w (t + 1) * G (t + 1) (h (t + 1)) + w t * x (t + 1)) :
    weighted w G x (n + 1) ≤ weighted w G h (n + 1) :=
  Nat.le_trans (Nat.le_add_right _ (w n * x (n + 1)))
    (Nat.le_trans (Nat.le_of_eq (weighted_add_left within n))
      (Nat.le_trans (drawable_le_of_gains within withinH start gains n (Nat.le_refl n))
        (Nat.le_of_eq (weighted_of_ends withinH ends).symm)))

/-- Where, besides, the level the first course leaves at some step before the `n`-th gains less
than the second's, or the first leaves something weighted at the last step, it draws less. -/
theorem weighted_lt_of_gains {x h : Nat → Nat} (within : ∀ t, x (t + 1) ≤ G t (x t))
    (withinH : ∀ t, h (t + 1) ≤ G t (h t)) (start : x 0 = h 0) (ends : h (n + 1) = 0)
    (gains : ∀ t, t < n → w (t + 1) * G (t + 1) (x (t + 1)) + w t * h (t + 1) ≤
      w (t + 1) * G (t + 1) (h (t + 1)) + w t * x (t + 1))
    (short : (∃ j, j < n ∧ w (j + 1) * G (j + 1) (x (j + 1)) + w j * h (j + 1) <
      w (j + 1) * G (j + 1) (h (j + 1)) + w j * x (j + 1)) ∨ 0 < w n * x (n + 1)) :
    weighted w G x (n + 1) < weighted w G h (n + 1) :=
  match short with
  | .inl ⟨j, lt, less⟩ => match le_dest (show j + 1 ≤ n from lt) with
    | ⟨i, split⟩ =>
      Nat.lt_of_le_of_lt (Nat.le_add_right _ (w n * x (n + 1)))
        (Nat.lt_of_le_of_lt (Nat.le_of_eq (weighted_add_left within n))
          (Nat.lt_of_lt_of_le
            (Eq.subst (motive := fun z => drawable w G x z < drawable w G h z) split.symm
              (drawable_lt_of_gains within withinH start gains lt less i (Nat.le_of_eq split.symm)))
            (Nat.le_of_eq (weighted_of_ends withinH ends).symm)))
  | .inr pos =>
    Nat.lt_of_lt_of_le (Nat.lt_add_of_pos_right pos)
      (Nat.le_trans (Nat.le_of_eq (weighted_add_left within n))
        (Nat.le_trans (drawable_le_of_gains within withinH start gains n (Nat.le_refl n))
          (Nat.le_of_eq (weighted_of_ends withinH ends).symm)))

/-- **A course gaining the most against every open course.** At each step to the `n`-th the level
`h` leaves gains, weighted, at least what the level any course open from `s` leaves there does. -/
def GainsMost (w : Nat → Nat) (G : Nat → Nat → Nat) (k s n : Nat) (h : Nat → Nat) : Prop :=
  ∀ x, Open G k s x → ∀ t, t < n →
    w (t + 1) * G (t + 1) (x (t + 1)) + w t * h (t + 1) ≤
      w (t + 1) * G (t + 1) (h (t + 1)) + w t * x (t + 1)

/-- A course whose level gains at each step to the `n`-th at least what any level does gains the
most against every open course. -/
theorem gainsMost_of_greatest {h : Nat → Nat}
    (greatest : ∀ t, t < n → ∀ z, w (t + 1) * G (t + 1) z + w t * h (t + 1) ≤
      w (t + 1) * G (t + 1) (h (t + 1)) + w t * z) : GainsMost w G k s n h :=
  fun x _ t lt => greatest t lt (x (t + 1))

/-- **A course gaining the most against every open course is an optimum.** Where an open course from
`s` leaves nothing at the last step and gains the most against every open course, it is an optimum,
among the open courses, of the order by the weighted draw across `n + 1` steps. -/
theorem frontier_of_gainsMost {h : Nat → Nat} (opens : Open G k s h) (ends : h (n + 1) = 0)
    (most : GainsMost w G k s n h) :
    Frontier (Open G k s) (fun b a => weighted w G a (n + 1) < weighted w G b (n + 1)) h :=
  ⟨opens, fun b openB more => Nat.not_le_of_gt more
    (weighted_le_of_gains (fun t => (openB.2 t).1) (fun t => (opens.2 t).1)
      (openB.1.trans opens.1.symm) ends (most b openB))⟩

/-- **Every optimum gains what a course gaining the most gains, and leaves nothing weighted.** Under
the premises of `frontier_of_gainsMost`, every optimum of every order on the courses open from the
start that rises with the weighted draw across `n + 1` steps leaves, weighted at the last step,
nothing, and at each step to the `n`-th leaves a level gaining what that course's level gains. -/
theorem frontier_gains_of_most {better : (Nat → Nat) → (Nat → Nat) → Prop}
    (rising : ∀ a b, weighted w G a (n + 1) < weighted w G b (n + 1) → better b a)
    {h : Nat → Nat} (opens : Open G k s h) (ends : h (n + 1) = 0)
    (most : GainsMost w G k s n h) {x : Nat → Nat} (front : Frontier (Open G k s) better x) :
    w n * x (n + 1) = 0 ∧ ∀ t, t < n →
      w (t + 1) * G (t + 1) (x (t + 1)) + w t * h (t + 1) =
        w (t + 1) * G (t + 1) (h (t + 1)) + w t * x (t + 1) :=
  have gains := most x front.1
  have outdrawn : ¬ ((∃ j, j < n ∧ w (j + 1) * G (j + 1) (x (j + 1)) + w j * h (j + 1) <
      w (j + 1) * G (j + 1) (h (j + 1)) + w j * x (j + 1)) ∨ 0 < w n * x (n + 1)) :=
    fun short => front.2 _ opens (rising x _ (weighted_lt_of_gains (fun t => (front.1.2 t).1)
      (fun t => (opens.2 t).1) (front.1.1.trans opens.1.symm) ends gains short))
  ⟨match Nat.eq_zero_or_pos (w n * x (n + 1)) with
    | .inl zero => zero
    | .inr pos => absurd (Or.inr pos) outdrawn,
   fun t lt => match Nat.lt_or_ge (w (t + 1) * G (t + 1) (x (t + 1)) + w t * h (t + 1))
      (w (t + 1) * G (t + 1) (h (t + 1)) + w t * x (t + 1)) with
    | .inl less => absurd (Or.inl ⟨t, lt, less⟩) outdrawn
    | .inr ge => Nat.le_antisymm (gains t lt) ge⟩

/-- **Every optimum stands below a need above every level of greatest weighted gain.** Where an open
course from `s` leaving nothing at the last step gains at each step to the `n`-th at least what any
level does, and every level at or above `m` gains less, every optimum of every order rising with the
weighted draw stands below `m` at every step from the first to the `n`-th. -/
theorem frontier_below {better : (Nat → Nat) → (Nat → Nat) → Prop}
    (rising : ∀ a b, weighted w G a (n + 1) < weighted w G b (n + 1) → better b a)
    {h : Nat → Nat} (opens : Open G k s h) (ends : h (n + 1) = 0)
    (greatest : ∀ t, t < n → ∀ z, w (t + 1) * G (t + 1) z + w t * h (t + 1) ≤
      w (t + 1) * G (t + 1) (h (t + 1)) + w t * z)
    (above : ∀ t, t < n → ∀ z, m ≤ z → w (t + 1) * G (t + 1) z + w t * h (t + 1) <
      w (t + 1) * G (t + 1) (h (t + 1)) + w t * z)
    {x : Nat → Nat} (front : Frontier (Open G k s) better x) :
    ∀ t, t < n → x (t + 1) < m :=
  fun t lt => match Nat.lt_or_ge (x (t + 1)) m with
  | .inl below => below
  | .inr ge => absurd
      ((frontier_gains_of_most rising opens ends (gainsMost_of_greatest greatest) front).2 t lt)
      (Nat.ne_of_lt (above t lt _ ge))

/-- Each step of the holding course leaves at most what stands, where `y` is within what stands at
the start and what stands at `y` is at least `y` at every step. -/
theorem holding_within (reach : y ≤ G 0 s) (keeps : ∀ t, y ≤ G t y) (n : Nat) :
    ∀ t, holding s y n (t + 1) ≤ G t (holding s y n t)
  | 0 => match Nat.lt_or_ge 0 n with
    | .inl lt => Nat.le_trans (Nat.le_of_eq (holding_before lt)) reach
    | .inr ge => Nat.le_trans (Nat.le_of_eq (holding_after ge)) (Nat.zero_le _)
  | j + 1 => match Nat.lt_or_ge (j + 1) n with
    | .inl lt => Nat.le_trans (Nat.le_of_eq (holding_before lt))
        (Eq.subst (motive := fun v => y ≤ G (j + 1) v) (holding_before (Nat.lt_of_succ_lt lt)).symm
          (keeps _))
    | .inr ge => Nat.le_trans (Nat.le_of_eq (holding_after ge)) (Nat.zero_le _)

/-- **The course holding `y` and leaving nothing is open** over a horizon of at least two steps,
where `y` is within what stands at the start and what stands at `y` is at least `y` at every step,
with a capacity covering what the first step draws down to `y`, what stands at `y` and what stands
at nothing at every step. -/
theorem holding_open (reach : y ≤ G 0 s) (drawsDown : G 0 s ≤ y + k) (keeps : ∀ t, y ≤ G t y)
    (holds : ∀ t, G t y ≤ k) (rests : ∀ t, G t 0 ≤ k) (long : 0 < n) :
    Open G k s (holding s y n) :=
  ⟨rfl, fun t => ⟨Next.holding_within reach keeps n t, match t with
    | 0 => Nat.le_trans (Nat.le_of_eq (congrArg (G 0 s - ·) (holding_before long)))
        (Nat.le_trans (sub_le_sub_right_of_le drawsDown y)
          (Nat.le_of_eq (Naturals.add_sub_cancel_left y k)))
    | j + 1 => Nat.le_trans (Nat.sub_le _ _) (match Nat.lt_or_ge j n with
      | .inl lt => Eq.subst (motive := fun v => G (j + 1) v ≤ k) (holding_before lt).symm (holds _)
      | .inr ge => Eq.subst (motive := fun v => G (j + 1) v ≤ k) (holding_after ge).symm
          (rests _))⟩⟩

/-- **The course holding a level of greatest weighted gain is an optimum**, where `y` gains,
weighted, at each step to the `n`-th at least what any level does, under the premises of
`holding_open`. -/
theorem holding_frontier
    (greatest : ∀ t, t < n → ∀ z,
      w (t + 1) * G (t + 1) z + w t * y ≤ w (t + 1) * G (t + 1) y + w t * z)
    (reach : y ≤ G 0 s) (drawsDown : G 0 s ≤ y + k) (keeps : ∀ t, y ≤ G t y)
    (holds : ∀ t, G t y ≤ k) (rests : ∀ t, G t 0 ≤ k) (long : 0 < n) :
    Frontier (Open G k s) (fun b a => weighted w G a (n + 1) < weighted w G b (n + 1))
      (holding s y n) :=
  frontier_of_gainsMost (Next.holding_open reach drawsDown keeps holds rests long)
    (holding_after (Nat.le_refl n))
    (gainsMost_of_greatest (holding_gains (P := fun t v => ∀ z, w (t + 1) * G (t + 1) z + w t * v ≤
      w (t + 1) * G (t + 1) v + w t * z) greatest))

/-- Where the weighting falls at least as fast as what stands at every positive level rises over
it, nothing gains at least what any level does. -/
theorem outpaced_greatest
    (outpaced : ∀ t, t < n → ∀ z, 0 < z → w (t + 1) * G (t + 1) z ≤ w t * z) :
    ∀ t, t < n → ∀ z, w (t + 1) * G (t + 1) z + w t * 0 ≤ w (t + 1) * G (t + 1) 0 + w t * z :=
  fun t lt z => match Nat.eq_zero_or_pos z with
  | .inl zero => by subst zero; exact Nat.le_refl _
  | .inr pos => Nat.le_trans (Nat.le_of_eq (Nat.add_zero _))
      (Nat.le_trans (outpaced t lt z pos) (Nat.le_add_left _ _))

/-- Where the weighting falls faster than what stands at every positive level rises over it, every
positive level gains less than nothing does. -/
theorem outpaced_above
    (strictly : ∀ t, t < n → ∀ z, 0 < z → w (t + 1) * G (t + 1) z < w t * z) :
    ∀ t, t < n → ∀ z, 1 ≤ z → w (t + 1) * G (t + 1) z + w t * 0 < w (t + 1) * G (t + 1) 0 + w t * z :=
  fun t lt z pos => Nat.lt_of_le_of_lt (Nat.le_of_eq (Nat.add_zero _))
    (Nat.lt_of_lt_of_le (strictly t lt z pos) (Nat.le_add_left _ _))

/-- **The course ending the base at once is an optimum** where the weighting falls at least as fast
as what stands at every positive level rises over it, over a horizon of at least two steps, with a
capacity covering what stands at the start and what stands at nothing at every step. -/
theorem exhausting_frontier
    (outpaced : ∀ t, t < n → ∀ z, 0 < z → w (t + 1) * G (t + 1) z ≤ w t * z)
    (drawsDown : G 0 s ≤ k) (rests : ∀ t, G t 0 ≤ k) (long : 0 < n) :
    Frontier (Open G k s) (fun b a => weighted w G a (n + 1) < weighted w G b (n + 1))
      (holding s 0 n) :=
  Next.holding_frontier (outpaced_greatest outpaced) (Nat.zero_le _)
    (Nat.le_trans drawsDown (Nat.le_of_eq (Nat.zero_add k).symm)) (fun _ => Nat.zero_le _) rests
    rests long

/-- **A weighting falling faster than what stands rises ends the base at once.** Where at each step
to the `n`-th the weighting falls faster than what stands at every positive level rises over it,
`w (t + 1)` on what stands at a level less than `w t` on the level held, over a horizon of at least
two steps, with a capacity covering what stands at the start and what stands at nothing at every
step, every optimum of every order on the courses open from the start that rises with the weighted
draw across `n + 1` steps stands at nothing at every step from the first to the `n`-th. -/
theorem frontier_exhausts {better : (Nat → Nat) → (Nat → Nat) → Prop}
    (rising : ∀ a b, weighted w G a (n + 1) < weighted w G b (n + 1) → better b a)
    (strictly : ∀ t, t < n → ∀ z, 0 < z → w (t + 1) * G (t + 1) z < w t * z)
    (drawsDown : G 0 s ≤ k) (rests : ∀ t, G t 0 ≤ k) (long : 0 < n) {x : Nat → Nat}
    (front : Frontier (Open G k s) better x) : ∀ t, t < n → x (t + 1) = 0 :=
  have opens := Next.holding_open (y := 0) (Nat.zero_le _)
    (Nat.le_trans drawsDown (Nat.le_of_eq (Nat.zero_add k).symm)) (fun _ => Nat.zero_le _) rests
    rests long
  fun t lt => Nat.le_antisymm (Nat.le_of_lt_succ (frontier_below (m := 1) rising opens
      (holding_after (Nat.le_refl n))
      (holding_gains (P := fun t v => ∀ z, w (t + 1) * G (t + 1) z + w t * v ≤
        w (t + 1) * G (t + 1) v + w t * z)
        (outpaced_greatest fun t lt z pos => Nat.le_of_lt (strictly t lt z pos)))
      (holding_gains (P := fun t v => ∀ z, 1 ≤ z → w (t + 1) * G (t + 1) z + w t * v <
        w (t + 1) * G (t + 1) v + w t * z) (outpaced_above strictly)) front t lt))
    (Nat.zero_le _)

/-- **Ending the base at once is outdrawn by a level rising faster than the weighting falls.**
Where each step of a course from `s` leaves at most what stands and the course stands at nothing at
every step from the first to the `n`-th, and some `y` within what stands at the start, with what
stands at `y` at least `y` at every step, gains, weighted, more than nothing does at each step to the
`n`-th, over a horizon of at least two steps, the course holding `y` and leaving nothing draws more,
weighted, across `n + 1` steps. -/
theorem ended_outdrawn {x : Nat → Nat} (within : ∀ t, x (t + 1) ≤ G t (x t))
    (start : x 0 = s) (ended : ∀ t, t < n → x (t + 1) = 0) (reach : y ≤ G 0 s)
    (keeps : ∀ t, y ≤ G t y)
    (outgrows : ∀ t, t < n → w (t + 1) * G (t + 1) 0 + w t * y < w (t + 1) * G (t + 1) y)
    (long : 0 < n) :
    weighted w G x (n + 1) < weighted w G (holding s y n) (n + 1) :=
  have gains : ∀ t, t < n → w (t + 1) * G (t + 1) (x (t + 1)) + w t * holding s y n (t + 1) <
      w (t + 1) * G (t + 1) (holding s y n (t + 1)) + w t * x (t + 1) :=
    fun t lt => by
      rw [ended t lt, holding_before lt]
      exact outgrows t lt
  weighted_lt_of_gains within (Next.holding_within reach keeps n) start
    (holding_after (Nat.le_refl n)) (fun t lt => Nat.le_of_lt (gains t lt))
    (.inl ⟨0, long, gains 0 long⟩)

/-- A course leaving at most what stands stays at nothing after reaching it, where nothing stands at
nothing. -/
theorem stays_empty {x : Nat → Nat} (within : ∀ t, x (t + 1) ≤ G t (x t))
    (empty : ∀ t, G t 0 = 0) (ended : x 1 = 0) : ∀ t, x (t + 1) = 0
  | 0 => ended
  | t + 1 => Nat.le_antisymm (Nat.le_trans (within (t + 1))
      (Nat.le_of_eq (by rw [stays_empty within empty ended t, empty]))) (Nat.zero_le _)

/-- **No optimum ends the base at once where a level rises faster than the weighting falls.** Where
nothing stands at nothing and some `y` within what stands at the start, with what stands at `y` at
least `y` at every step, rises faster than the weighting falls at each step to the `n`-th,
`w t y < w (t + 1) (G (t + 1) y)`, over a horizon of at least two steps, with a capacity covering
what the first step draws down to `y` and what stands at `y`, no optimum of any order on the courses
open from the start that rises with the weighted draw across `n + 1` steps stands at nothing after
the first step. -/
theorem frontier_leaves {better : (Nat → Nat) → (Nat → Nat) → Prop}
    (rising : ∀ a b, weighted w G a (n + 1) < weighted w G b (n + 1) → better b a)
    (empty : ∀ t, G t 0 = 0) (outgrows : ∀ t, t < n → w t * y < w (t + 1) * G (t + 1) y)
    (reach : y ≤ G 0 s) (drawsDown : G 0 s ≤ y + k) (keeps : ∀ t, y ≤ G t y)
    (holds : ∀ t, G t y ≤ k) (long : 0 < n)
    {x : Nat → Nat} (front : Frontier (Open G k s) better x) : 0 < x 1 :=
  have nothing : ∀ t, t < n → w (t + 1) * G (t + 1) 0 + w t * y < w (t + 1) * G (t + 1) y :=
    fun t lt => by
      rw [empty]
      exact Nat.lt_of_le_of_lt (Nat.le_of_eq (Nat.zero_add _)) (outgrows t lt)
  match Nat.eq_zero_or_pos (x 1) with
  | .inr pos => pos
  | .inl ended => absurd
      (rising x _ (ended_outdrawn (fun t => (front.1.2 t).1) front.1.1
        (fun t _ => Next.stays_empty (fun t => (front.1.2 t).1) empty ended t) reach keeps nothing
        long))
      (front.2 _ (Next.holding_open reach drawsDown keeps holds
        (fun t => Nat.le_trans (Nat.le_of_eq (empty t)) (Nat.zero_le k)) long))

/-- The level a course from `s` rising as fast as what stands allows, up to `y`, stands at after `t`
steps. -/
def rise (G : Nat → Nat → Nat) (y s : Nat) : Nat → Nat
  | 0 => s
  | t + 1 => if G t (rise G y s t) ≤ y then G t (rise G y s t) else y

/-- From `s`, the course rising as fast as what stands allows up to `y` to the `n`-th step and
standing at nothing after: the course rebuilding toward `y`. -/
def rebuilding (G : Nat → Nat → Nat) (y s n : Nat) : Nat → Nat
  | 0 => s
  | t + 1 => if t < n then rise G y s (t + 1) else 0

/-- One step of the rising course. -/
theorem rise_succ (t : Nat) : rise G y s (t + 1) =
    if G t (rise G y s t) ≤ y then G t (rise G y s t) else y :=
  rfl

/-- After its start the rising course stands at most at `y`. -/
theorem rise_le (t : Nat) : rise G y s (t + 1) ≤ y :=
  match Nat.lt_or_ge y (G t (rise G y s t)) with
  | .inl over => Nat.le_of_eq ((rise_succ t).trans (if_neg (Nat.not_le_of_gt over)))
  | .inr fits => Nat.le_trans (Nat.le_of_eq ((rise_succ t).trans (if_pos fits))) fits

/-- From a start at most `y` the rising course stands at most at `y`. -/
theorem rise_le_top (low : s ≤ y) : ∀ t, rise G y s t ≤ y
  | 0 => low
  | t + 1 => rise_le t

/-- Each step of the rising course leaves at most what stands. -/
theorem rise_within (t : Nat) : rise G y s (t + 1) ≤ G t (rise G y s t) :=
  match Nat.lt_or_ge y (G t (rise G y s t)) with
  | .inl over => Nat.le_trans (Nat.le_of_eq ((rise_succ t).trans (if_neg (Nat.not_le_of_gt over))))
      (Nat.le_of_lt over)
  | .inr fits => Nat.le_of_eq ((rise_succ t).trans (if_pos fits))

/-- Where the rising course stands below `y` after a step, that step drew nothing. -/
theorem rise_of_below {t : Nat} (below : rise G y s (t + 1) < y) :
    rise G y s (t + 1) = G t (rise G y s t) :=
  match Nat.lt_or_ge y (G t (rise G y s t)) with
  | .inl over => absurd (Nat.le_of_eq ((rise_succ t).trans (if_neg (Nat.not_le_of_gt over))).symm)
      (Nat.not_le_of_gt below)
  | .inr fits => (rise_succ t).trans (if_pos fits)

/-- Once at `y`, the rising course stays there, where what stands at `y` is at least `y`. -/
theorem rise_at_top (keeps : ∀ t, y ≤ G t y) {t : Nat} (top : rise G y s t = y) :
    rise G y s (t + 1) = y :=
  Nat.le_antisymm (rise_le t)
    (match Nat.lt_or_ge y (G t (rise G y s t)) with
    | .inl over => Nat.le_of_eq ((rise_succ t).trans (if_neg (Nat.not_le_of_gt over))).symm
    | .inr fits => Nat.le_trans
        (Eq.subst (motive := fun v => y ≤ G t v) top.symm (keeps t))
        (Nat.le_of_eq ((rise_succ t).trans (if_pos fits)).symm))

/-- Where the rising course stands below `y` after two steps, it stood below `y` after one. -/
theorem rise_below_before (keeps : ∀ t, y ≤ G t y) {t : Nat}
    (below : rise G y s (t + 1 + 1) < y) : rise G y s (t + 1) < y :=
  match Nat.lt_or_ge (rise G y s (t + 1)) y with
  | .inl lt => lt
  | .inr ge => absurd (Nat.le_of_eq (rise_at_top keeps (Nat.le_antisymm (rise_le t) ge)).symm)
      (Nat.not_le_of_gt below)

/-- Once at `y`, the rising course stands there at every later step. -/
theorem rise_stays (keeps : ∀ t, y ≤ G t y) {j : Nat} (top : rise G y s j = y) :
    ∀ i, rise G y s (j + i) = y
  | 0 => top
  | i + 1 => rise_at_top keeps (rise_stays keeps top i)

/-- **Nothing open rises faster.** Where what stands rises with the level below `y` and what stands
at `y` is at least `y`, every course from `s` at most `y` whose steps each leave at most what stands
stands, at each step, at or below the rising course, or the rising course stands at `y`. -/
theorem le_rise {x : Nat → Nat} (within : ∀ t, x (t + 1) ≤ G t (x t)) (start : x 0 = s)
    (low : s ≤ y) (grows : ∀ t z z', z ≤ z' → z' ≤ y → G t z ≤ G t z')
    (keeps : ∀ t, y ≤ G t y) :
    ∀ t, x t ≤ rise G y s t ∨ rise G y s t = y
  | 0 => .inl (Nat.le_of_eq start)
  | t + 1 => match le_rise within start low grows keeps t with
    | .inl le => match Nat.lt_or_ge y (G t (rise G y s t)) with
      | .inl over => .inr ((rise_succ t).trans (if_neg (Nat.not_le_of_gt over)))
      | .inr fits => .inl (Nat.le_trans (within t)
          (Nat.le_trans (grows t _ _ le (rise_le_top low t))
            (Nat.le_of_eq ((rise_succ t).trans (if_pos fits)).symm)))
    | .inr top => .inr (rise_at_top keeps top)

/-- The rebuilding course stands at the rising course's level from the first step to the `n`-th. -/
theorem rebuilding_before {t : Nat} (before : t < n) :
    rebuilding G y s n (t + 1) = rise G y s (t + 1) :=
  if_pos before

/-- The rebuilding course stands at nothing after the `n`-th step. -/
theorem rebuilding_after {t : Nat} (after : n ≤ t) : rebuilding G y s n (t + 1) = 0 :=
  if_neg (Nat.not_lt_of_ge after)

/-- To the `n`-th step the rebuilding course stands where the rising course does. -/
theorem rebuilding_at : ∀ {t : Nat}, t ≤ n → rebuilding G y s n t = rise G y s t
  | 0, _ => rfl
  | _ + 1, le => rebuilding_before le

/-- Each step of the rebuilding course leaves at most what stands. -/
theorem rebuilding_within (t : Nat) :
    rebuilding G y s n (t + 1) ≤ G t (rebuilding G y s n t) :=
  match Nat.lt_or_ge t n with
  | .inl lt => Nat.le_trans (Nat.le_of_eq (rebuilding_before lt))
      (Eq.subst (motive := fun v => rise G y s (t + 1) ≤ G t v)
        (rebuilding_at (Nat.le_of_lt lt)).symm (rise_within t))
  | .inr ge => Nat.le_trans (Nat.le_of_eq (rebuilding_after ge)) (Nat.zero_le _)

/-- At each step what stands at the rebuilding course is within a capacity covering what stands at
`y` and what stands at nothing at every step, from a start at most `y`, where what stands rises with
the level below `y`. -/
theorem rebuilding_le_cap (low : s ≤ y) (grows : ∀ t z z', z ≤ z' → z' ≤ y → G t z ≤ G t z')
    (holds : ∀ t, G t y ≤ k) (rests : ∀ t, G t 0 ≤ k) :
    ∀ t, G t (rebuilding G y s n t) ≤ k
  | 0 => Nat.le_trans (grows 0 _ _ low (Nat.le_refl y)) (holds 0)
  | t + 1 => match Nat.lt_or_ge t n with
    | .inl lt => Eq.subst (motive := fun v => G (t + 1) v ≤ k) (rebuilding_before lt).symm
        (Nat.le_trans (grows (t + 1) _ _ (rise_le t) (Nat.le_refl y)) (holds (t + 1)))
    | .inr ge => Eq.subst (motive := fun v => G (t + 1) v ≤ k) (rebuilding_after ge).symm
        (rests (t + 1))

/-- **The rebuilding course is open**, from a start at most `y`, where what stands rises with the
level below `y`, with a capacity covering what stands at `y` and at nothing at every step. -/
theorem rebuilding_open (low : s ≤ y) (grows : ∀ t z z', z ≤ z' → z' ≤ y → G t z ≤ G t z')
    (holds : ∀ t, G t y ≤ k) (rests : ∀ t, G t 0 ≤ k) : Open G k s (rebuilding G y s n) :=
  ⟨rfl, fun t => ⟨rebuilding_within t,
    Nat.le_trans (Nat.sub_le _ _) (rebuilding_le_cap low grows holds rests t)⟩⟩

/-- **The rebuilding course gains the most against every open course**, from a start at most `y`,
where what stands rises with the level below `y`, what stands at `y` is at least `y`, and, at each
step to the `n`-th, the weighted gain rises with the level up to `y` and is greatest at `y`. -/
theorem rebuilding_gainsMost (low : s ≤ y) (grows : ∀ t z z', z ≤ z' → z' ≤ y → G t z ≤ G t z')
    (keeps : ∀ t, y ≤ G t y)
    (rises : ∀ t, t < n → ∀ z z', z ≤ z' → z' ≤ y →
      w (t + 1) * G (t + 1) z + w t * z' ≤ w (t + 1) * G (t + 1) z' + w t * z)
    (top : ∀ t, t < n → ∀ z,
      w (t + 1) * G (t + 1) z + w t * y ≤ w (t + 1) * G (t + 1) y + w t * z) :
    GainsMost w G k s n (rebuilding G y s n) :=
  fun x opens t lt =>
    Eq.subst (motive := fun v => w (t + 1) * G (t + 1) (x (t + 1)) + w t * v ≤
        w (t + 1) * G (t + 1) v + w t * x (t + 1)) (rebuilding_before lt).symm
      (match le_rise (fun t => (opens.2 t).1) opens.1 low grows keeps (t + 1) with
      | .inl le => rises t lt _ _ le (rise_le t)
      | .inr at_top => Eq.subst (motive := fun v => w (t + 1) * G (t + 1) (x (t + 1)) +
          w t * v ≤ w (t + 1) * G (t + 1) v + w t * x (t + 1)) at_top.symm (top t lt (x (t + 1))))

/-- **The rebuilding course is an optimum**, under the premises of `rebuilding_gainsMost`, with a
capacity covering what stands at `y` and at nothing at every step: of the order by the weighted draw
across `n + 1` steps, among the courses open from `s`. -/
theorem rebuilding_frontier (low : s ≤ y) (grows : ∀ t z z', z ≤ z' → z' ≤ y → G t z ≤ G t z')
    (keeps : ∀ t, y ≤ G t y)
    (rises : ∀ t, t < n → ∀ z z', z ≤ z' → z' ≤ y →
      w (t + 1) * G (t + 1) z + w t * z' ≤ w (t + 1) * G (t + 1) z' + w t * z)
    (top : ∀ t, t < n → ∀ z,
      w (t + 1) * G (t + 1) z + w t * y ≤ w (t + 1) * G (t + 1) y + w t * z)
    (holds : ∀ t, G t y ≤ k) (rests : ∀ t, G t 0 ≤ k) :
    Frontier (Open G k s) (fun b a => weighted w G a (n + 1) < weighted w G b (n + 1))
      (rebuilding G y s n) :=
  frontier_of_gainsMost (rebuilding_open low grows holds rests) (rebuilding_after (Nat.le_refl n))
    (rebuilding_gainsMost low grows keeps rises top)

/-- **Every optimum rebuilds.** Under the premises of `rebuilding_frontier`, where the weighted gain
rises strictly with the level below `y`, every optimum of every order on the courses open from `s`
that rises with the weighted draw across `n + 1` steps stands at the rising course's level at every
step from the first to the `n`-th where that level is below `y`, and draws nothing at the step
before: it rebuilds as fast as what stands allows. -/
theorem frontier_rebuilds {better : (Nat → Nat) → (Nat → Nat) → Prop}
    (rising : ∀ a b, weighted w G a (n + 1) < weighted w G b (n + 1) → better b a)
    (low : s ≤ y) (grows : ∀ t z z', z ≤ z' → z' ≤ y → G t z ≤ G t z')
    (keeps : ∀ t, y ≤ G t y)
    (rises : ∀ t, t < n → ∀ z z', z ≤ z' → z' ≤ y →
      w (t + 1) * G (t + 1) z + w t * z' ≤ w (t + 1) * G (t + 1) z' + w t * z)
    (strictly : ∀ t, t < n → ∀ z z', z < z' → z' ≤ y →
      w (t + 1) * G (t + 1) z + w t * z' < w (t + 1) * G (t + 1) z' + w t * z)
    (top : ∀ t, t < n → ∀ z,
      w (t + 1) * G (t + 1) z + w t * y ≤ w (t + 1) * G (t + 1) y + w t * z)
    (holds : ∀ t, G t y ≤ k) (rests : ∀ t, G t 0 ≤ k) {x : Nat → Nat}
    (front : Frontier (Open G k s) better x) :
    ∀ t, t < n → rise G y s (t + 1) < y →
      x (t + 1) = rise G y s (t + 1) ∧ x (t + 1) = G t (x t) :=
  have gains := (frontier_gains_of_most rising (rebuilding_open low grows holds rests)
    (rebuilding_after (Nat.le_refl n)) (rebuilding_gainsMost low grows keeps rises top) front).2
  have stands : ∀ t, t < n → rise G y s (t + 1) < y → x (t + 1) = rise G y s (t + 1) :=
    fun t lt below =>
      have same := Eq.subst (motive := fun v => w (t + 1) * G (t + 1) (x (t + 1)) + w t * v =
        w (t + 1) * G (t + 1) v + w t * x (t + 1)) (rebuilding_before lt) (gains t lt)
      match le_rise (fun t => (front.1.2 t).1) front.1.1 low grows keeps (t + 1) with
      | .inr at_top => absurd (Nat.le_of_eq at_top.symm) (Nat.not_le_of_gt below)
      | .inl le => match Nat.lt_or_ge (x (t + 1)) (rise G y s (t + 1)) with
        | .inl lt' => absurd same (Nat.ne_of_lt (strictly t lt _ _ lt' (rise_le t)))
        | .inr ge => Nat.le_antisymm le ge
  fun t lt below =>
    have before : x t = rise G y s t := match t, lt, below with
      | 0, _, _ => front.1.1
      | j + 1, lt, below => stands j (Nat.lt_of_succ_lt lt) (rise_below_before keeps below)
    ⟨stands t lt below, (stands t lt below).trans ((rise_of_below below).trans
      (congrArg (G t) before.symm))⟩

/-- **Every optimum stands at `y` once the rising course reaches it.** Under the premises of
`rebuilding_frontier`, where `y` gains, weighted, more than every other level at each step to the
`n`-th, every optimum of every order on the courses open from `s` that rises with the weighted draw
across `n + 1` steps stands at `y` at every step from the first to the `n`-th where the rising
course does. -/
theorem frontier_rebuilt {better : (Nat → Nat) → (Nat → Nat) → Prop}
    (rising : ∀ a b, weighted w G a (n + 1) < weighted w G b (n + 1) → better b a)
    (low : s ≤ y) (grows : ∀ t z z', z ≤ z' → z' ≤ y → G t z ≤ G t z')
    (keeps : ∀ t, y ≤ G t y)
    (rises : ∀ t, t < n → ∀ z z', z ≤ z' → z' ≤ y →
      w (t + 1) * G (t + 1) z + w t * z' ≤ w (t + 1) * G (t + 1) z' + w t * z)
    (above : ∀ t, t < n → ∀ z, z ≠ y →
      w (t + 1) * G (t + 1) z + w t * y < w (t + 1) * G (t + 1) y + w t * z)
    (holds : ∀ t, G t y ≤ k) (rests : ∀ t, G t 0 ≤ k) {x : Nat → Nat}
    (front : Frontier (Open G k s) better x) :
    ∀ t, t < n → rise G y s (t + 1) = y → x (t + 1) = y :=
  have top : ∀ t, t < n → ∀ z,
      w (t + 1) * G (t + 1) z + w t * y ≤ w (t + 1) * G (t + 1) y + w t * z :=
    fun t lt z => match Nat.decEq z y with
    | isTrue same => Eq.subst (motive := fun v => w (t + 1) * G (t + 1) v + w t * y ≤
        w (t + 1) * G (t + 1) y + w t * v) same.symm (Nat.le_refl _)
    | isFalse other => Nat.le_of_lt (above t lt z other)
  have gains := (frontier_gains_of_most rising (rebuilding_open low grows holds rests)
    (rebuilding_after (Nat.le_refl n)) (rebuilding_gainsMost low grows keeps rises top) front).2
  fun t lt at_top =>
    have same := Eq.subst (motive := fun v => w (t + 1) * G (t + 1) (x (t + 1)) + w t * v =
      w (t + 1) * G (t + 1) v + w t * x (t + 1)) ((rebuilding_before lt).trans at_top) (gains t lt)
    match Nat.decEq (x (t + 1)) y with
    | isTrue e => e
    | isFalse other => absurd same (Nat.ne_of_lt (above t lt _ other))

end Next

end Optimum

namespace Web

namespace Next

open Optimum.Next

variable {W : Web F C} {c : C} {f : F} {w : Nat → Nat} {G : Nat → Nat → Nat} {k s y m n : Nat}
  {better : (Nat → Nat) → (Nat → Nat) → Prop}

/-- **A dependence above every level of greatest weighted gain is broken at the first step.** Under
the premises of `Optimum.Next.frontier_below`, over a horizon of at least two steps, with a
formation depending on the condition at the start, met there, and needing at least `m`: every
optimum, among the open courses, of every order rising with the weighted draw breaks the dependence
at the first step. -/
theorem frontier_broken
    (rising : ∀ a b, weighted w G a (n + 1) < weighted w G b (n + 1) → better b a)
    {h : Nat → Nat} (opens : Open G k s h) (ends : h (n + 1) = 0)
    (greatest : ∀ t, t < n → ∀ z, w (t + 1) * G (t + 1) z + w t * h (t + 1) ≤
      w (t + 1) * G (t + 1) (h (t + 1)) + w t * z)
    (above : ∀ t, t < n → ∀ z, m ≤ z → w (t + 1) * G (t + 1) z + w t * h (t + 1) <
      w (t + 1) * G (t + 1) (h (t + 1)) + w t * z)
    (long : 0 < n) (front : Frontier (Open G k s) better fun t => W.level t c)
    (depends : W.requires 0 f c) (met : W.need 0 f c ≤ W.level 0 c) (need : m ≤ W.need 0 f c) :
    W.Broken 0 f c :=
  ⟨depends, met, Nat.lt_of_lt_of_le (Optimum.Next.frontier_below rising opens ends greatest
    above front 0 long) need⟩

/-- **A weighting falling faster than what stands rises ends the condition at once.** Under the
premises of `Optimum.Next.frontier_exhausts`, every optimum, among the open courses, of every order
rising with the weighted draw leaves the condition at nothing at every step from the first to the
`n`-th, and breaks at the first step every dependence on it with a positive need, met at the
start. -/
theorem frontier_exhausts
    (rising : ∀ a b, weighted w G a (n + 1) < weighted w G b (n + 1) → better b a)
    (strictly : ∀ t, t < n → ∀ z, 0 < z → w (t + 1) * G (t + 1) z < w t * z)
    (drawsDown : G 0 s ≤ k) (rests : ∀ t, G t 0 ≤ k) (long : 0 < n)
    (front : Frontier (Open G k s) better fun t => W.level t c)
    (depends : W.requires 0 f c) (met : W.need 0 f c ≤ W.level 0 c) (needs : 0 < W.need 0 f c) :
    W.Broken 0 f c ∧ ∀ t, t < n → W.level (t + 1) c = 0 :=
  have ended := Optimum.Next.frontier_exhausts rising strictly drawsDown rests long front
  ⟨⟨depends, met, Nat.lt_of_le_of_lt (Nat.le_of_eq (ended 0 long)) needs⟩, ended⟩

/-- **Where a level rises faster than the weighting falls, no optimum ends the condition at once.**
Under the premises of `Optimum.Next.frontier_leaves`, every optimum, among the open courses, of
every order rising with the weighted draw leaves the condition above nothing after the first
step. -/
theorem frontier_leaves
    (rising : ∀ a b, weighted w G a (n + 1) < weighted w G b (n + 1) → better b a)
    (empty : ∀ t, G t 0 = 0) (outgrows : ∀ t, t < n → w t * y < w (t + 1) * G (t + 1) y)
    (reach : y ≤ G 0 s) (drawsDown : G 0 s ≤ y + k) (keeps : ∀ t, y ≤ G t y)
    (holds : ∀ t, G t y ≤ k) (long : 0 < n)
    (front : Frontier (Open G k s) better fun t => W.level t c) : 0 < W.level 1 c :=
  Optimum.Next.frontier_leaves rising empty outgrows reach drawsDown keeps holds long front

/-- **Every optimum rebuilds the condition and restores what that level meets.** Under the premises
of `Optimum.Next.frontier_rebuilds`, every optimum, among the open courses, of every order rising
with the weighted draw leaves the condition at the rising course's level, drawing nothing before it,
at every step from the first to the `n`-th where that level is below `y`; and every dependence on
the condition, as it stands at the start, whose need that level meets by the `j + 1`-th step is
restored within `j + 1` steps. -/
theorem frontier_rebuilds
    (rising : ∀ a b, weighted w G a (n + 1) < weighted w G b (n + 1) → better b a)
    (low : s ≤ y) (grows : ∀ t z z', z ≤ z' → z' ≤ y → G t z ≤ G t z')
    (keeps : ∀ t, y ≤ G t y)
    (rises : ∀ t, t < n → ∀ z z', z ≤ z' → z' ≤ y →
      w (t + 1) * G (t + 1) z + w t * z' ≤ w (t + 1) * G (t + 1) z' + w t * z)
    (strictly : ∀ t, t < n → ∀ z z', z < z' → z' ≤ y →
      w (t + 1) * G (t + 1) z + w t * z' < w (t + 1) * G (t + 1) z' + w t * z)
    (top : ∀ t, t < n → ∀ z,
      w (t + 1) * G (t + 1) z + w t * y ≤ w (t + 1) * G (t + 1) y + w t * z)
    (holds : ∀ t, G t y ≤ k) (rests : ∀ t, G t 0 ≤ k)
    (front : Frontier (Open G k s) better fun t => W.level t c) :
    (∀ t, t < n → Optimum.Next.rise G y s (t + 1) < y →
      W.level (t + 1) c = Optimum.Next.rise G y s (t + 1) ∧
        W.level (t + 1) c = G t (W.level t c)) ∧
    ∀ f j, j < n → Optimum.Next.rise G y s (j + 1) < y →
      W.need 0 f c ≤ Optimum.Next.rise G y s (j + 1) → W.RestoredWithin (j + 1) 0 f c :=
  have stands := Optimum.Next.frontier_rebuilds rising low grows keeps rises strictly top holds
    rests front
  ⟨stands, fun _ j lt below meets => ⟨j + 1, Nat.succ_pos j, Nat.le_refl _,
    Nat.le_trans meets (Nat.le_of_eq ((stands j lt below).1.symm.trans
      (congrArg (W.level · c) (Nat.zero_add (j + 1)).symm)))⟩⟩

end Next

end Web

