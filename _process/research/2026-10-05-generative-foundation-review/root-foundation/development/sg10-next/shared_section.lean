
/-! ## Others drawing first

Under a law of what stands, whatever else draws from a base enters only through that law. Where at
each step others first draw from the level a far-sighted optimizer left, and what remains renews,
what stands for the optimizer is what remains with its renewal. Where they draw at least what that
remainder renews, nothing left stands higher at the next step: every order weighting later draws
less, however slightly, has every optimum end the base at once; where they draw more, so does every
order weighting no later step more. Alone, the same optimizer under the same weighting may rebuild
the base. The others' draws are supplied as a rule reading the level; whether that rule is itself
a best response is not derived. -/

namespace Optimum

namespace Next

variable {w : Nat → Nat} {G : Nat → Nat → Nat} {k s n : Nat}

/-- What stands at the step from `t` where, of the level `z` there, others first leave `K t z` and
that renews by `R`. -/
def leftBy (R : Nat → Nat) (K : Nat → Nat → Nat) (t z : Nat) : Nat := K t z + R (K t z)

/-- **Where nothing left stands higher at the next step, every falling weighting ends the base at
once.** Where at each step to the `n`-th what stands at a level is at most the level, and the
weighting falls at every step, over a horizon of at least two steps, with a capacity covering what
stands at the start and what stands at nothing, every optimum of every order on the courses open
from the start that rises with the weighted draw across `n + 1` steps stands at nothing at every
step from the first to the `n`-th. -/
theorem frontier_ends_of_le {better : (Nat → Nat) → (Nat → Nat) → Prop}
    (rising : ∀ a b, weighted w G a (n + 1) < weighted w G b (n + 1) → better b a)
    (atMost : ∀ t, t < n → ∀ z, G (t + 1) z ≤ z) (falls : ∀ t, t < n → w (t + 1) < w t)
    (drawsDown : G 0 s ≤ k) (rests : ∀ t, G t 0 ≤ k) (long : 0 < n) {x : Nat → Nat}
    (front : Frontier (Open G k s) better x) : ∀ t, t < n → x (t + 1) = 0 :=
  Next.frontier_exhausts rising (fun t lt z pos => Nat.lt_of_le_of_lt
      (Nat.mul_le_mul_left (w (t + 1)) (atMost t lt z)) (Holding.mul_lt_of_pos (falls t lt) pos))
    drawsDown rests long front

/-- **Where nothing left stands as high at the next step, every weighting rising at no step ends
the base at once.** Where at each step to the `n`-th what stands at every positive level is less
than the level, and the weighting is positive and rises at no step, over a horizon of at least two
steps, with a capacity covering what stands at the start and what stands at nothing, every optimum
of every order on the courses open from the start that rises with the weighted draw across `n + 1`
steps stands at nothing at every step from the first to the `n`-th. -/
theorem frontier_ends_of_lt {better : (Nat → Nat) → (Nat → Nat) → Prop}
    (rising : ∀ a b, weighted w G a (n + 1) < weighted w G b (n + 1) → better b a)
    (below : ∀ t, t < n → ∀ z, 0 < z → G (t + 1) z < z) (falls : ∀ t, t < n → w (t + 1) ≤ w t)
    (pos : ∀ t, t < n → 0 < w t) (drawsDown : G 0 s ≤ k) (rests : ∀ t, G t 0 ≤ k) (long : 0 < n)
    {x : Nat → Nat} (front : Frontier (Open G k s) better x) : ∀ t, t < n → x (t + 1) = 0 :=
  Next.frontier_exhausts rising (fun t lt z zpos => Nat.lt_of_le_of_lt
      (Nat.mul_le_mul_right (G (t + 1) z) (falls t lt))
      (Nat.lt_of_le_of_lt (Nat.le_of_eq (Nat.mul_comm _ _))
        (Nat.lt_of_lt_of_le (Holding.mul_lt_of_pos (below t lt z zpos) (pos t lt))
          (Nat.le_of_eq (Nat.mul_comm _ _)))))
    drawsDown rests long front

/-- **Others drawing first at least the renewal of what they leave end the base under every falling
weighting.** Where at each step to the `n`-th others first leave of every level `z` at most what,
with its renewal by `R`, is `z`, and the weighting falls at every step, over a horizon of at least
two steps, with a capacity covering what stands at the start and what stands at nothing, every
optimum of every order rising with the optimizer's weighted draw stands at nothing at every step
from the first to the `n`-th. -/
theorem frontier_ends_drawn_first {R : Nat → Nat} {K : Nat → Nat → Nat}
    {better : (Nat → Nat) → (Nat → Nat) → Prop}
    (rising : ∀ a b, weighted w (leftBy R K) a (n + 1) < weighted w (leftBy R K) b (n + 1) →
      better b a)
    (draws : ∀ t, t < n → ∀ z, K (t + 1) z + R (K (t + 1) z) ≤ z)
    (falls : ∀ t, t < n → w (t + 1) < w t) (drawsDown : leftBy R K 0 s ≤ k)
    (rests : ∀ t, leftBy R K t 0 ≤ k) (long : 0 < n) {x : Nat → Nat}
    (front : Frontier (Open (leftBy R K) k s) better x) : ∀ t, t < n → x (t + 1) = 0 :=
  Next.frontier_ends_of_le rising draws falls drawsDown rests long front

/-- **Others drawing first more than the renewal of what they leave end the base under every
weighting rising at no step.** Where at each step to the `n`-th others first leave of every positive
level `z` less than what, with its renewal by `R`, is `z`, and the weighting is positive and rises
at no step, under the remaining premises of `frontier_ends_drawn_first`, every optimum stands at
nothing at every step from the first to the `n`-th: even an order weighting every step alike. -/
theorem frontier_ends_drawn_more {R : Nat → Nat} {K : Nat → Nat → Nat}
    {better : (Nat → Nat) → (Nat → Nat) → Prop}
    (rising : ∀ a b, weighted w (leftBy R K) a (n + 1) < weighted w (leftBy R K) b (n + 1) →
      better b a)
    (draws : ∀ t, t < n → ∀ z, 0 < z → K (t + 1) z + R (K (t + 1) z) < z)
    (falls : ∀ t, t < n → w (t + 1) ≤ w t) (pos : ∀ t, t < n → 0 < w t)
    (drawsDown : leftBy R K 0 s ≤ k) (rests : ∀ t, leftBy R K t 0 ≤ k) (long : 0 < n)
    {x : Nat → Nat} (front : Frontier (Open (leftBy R K) k s) better x) :
    ∀ t, t < n → x (t + 1) = 0 :=
  Next.frontier_ends_of_lt rising draws falls pos drawsDown rests long front

end Next

end Optimum

namespace Web

namespace Next

open Optimum.Next

variable {W : Web F C} {c : C} {f : F} {w : Nat → Nat} {k s n : Nat}
  {better : (Nat → Nat) → (Nat → Nat) → Prop}

/-- **Others drawing first at least the renewal of what they leave break every dependence on the
condition.** Under the premises of `Optimum.Next.frontier_ends_drawn_first`, every optimum, among
the open courses, of every order rising with the optimizer's weighted draw leaves the condition at
nothing at every step from the first to the `n`-th, and breaks at the first step every dependence on
it with a positive need, met at the start. -/
theorem frontier_ends_drawn_first {R : Nat → Nat} {K : Nat → Nat → Nat}
    (rising : ∀ a b, weighted w (leftBy R K) a (n + 1) < weighted w (leftBy R K) b (n + 1) →
      better b a)
    (draws : ∀ t, t < n → ∀ z, K (t + 1) z + R (K (t + 1) z) ≤ z)
    (falls : ∀ t, t < n → w (t + 1) < w t) (drawsDown : leftBy R K 0 s ≤ k)
    (rests : ∀ t, leftBy R K t 0 ≤ k) (long : 0 < n)
    (front : Frontier (Open (leftBy R K) k s) better fun t => W.level t c)
    (depends : W.requires 0 f c) (met : W.need 0 f c ≤ W.level 0 c) (needs : 0 < W.need 0 f c) :
    W.Broken 0 f c ∧ ∀ t, t < n → W.level (t + 1) c = 0 :=
  have ended := Optimum.Next.frontier_ends_drawn_first rising draws falls drawsDown rests long front
  ⟨⟨depends, met, Nat.lt_of_le_of_lt (Nat.le_of_eq (ended 0 long)) needs⟩, ended⟩

/-- **Others drawing first more than the renewal of what they leave break every dependence on the
condition under every weighting rising at no step.** Under the premises of
`Optimum.Next.frontier_ends_drawn_more`, every optimum, among the open courses, of every order
rising with the optimizer's weighted draw leaves the condition at nothing at every step from the
first to the `n`-th, and breaks at the first step every dependence on it with a positive need, met
at the start. -/
theorem frontier_ends_drawn_more {R : Nat → Nat} {K : Nat → Nat → Nat}
    (rising : ∀ a b, weighted w (leftBy R K) a (n + 1) < weighted w (leftBy R K) b (n + 1) →
      better b a)
    (draws : ∀ t, t < n → ∀ z, 0 < z → K (t + 1) z + R (K (t + 1) z) < z)
    (falls : ∀ t, t < n → w (t + 1) ≤ w t) (pos : ∀ t, t < n → 0 < w t)
    (drawsDown : leftBy R K 0 s ≤ k) (rests : ∀ t, leftBy R K t 0 ≤ k) (long : 0 < n)
    (front : Frontier (Open (leftBy R K) k s) better fun t => W.level t c)
    (depends : W.requires 0 f c) (met : W.need 0 f c ≤ W.level 0 c) (needs : 0 < W.need 0 f c) :
    W.Broken 0 f c ∧ ∀ t, t < n → W.level (t + 1) c = 0 :=
  have ended := Optimum.Next.frontier_ends_drawn_more rising draws falls pos drawsDown rests long
    front
  ⟨⟨depends, met, Nat.lt_of_le_of_lt (Nat.le_of_eq (ended 0 long)) needs⟩, ended⟩

end Next

end Web

namespace Optimum

namespace Holding

open Diversion

/-- Half a level, rounded down. -/
def halved : Nat → Nat
  | 0 => 0
  | 1 => 0
  | z + 2 => halved z + 1

/-- Twice half a level is at most the level. -/
theorem halved_twice : ∀ z, halved z + halved z ≤ z
  | 0 => Nat.le_refl 0
  | 1 => Nat.zero_le 1
  | z + 2 => Nat.succ_le_succ (Nat.le_trans (Nat.le_of_eq (Nat.succ_add (halved z) (halved z)))
      (Nat.succ_le_succ (halved_twice z)))

/-- Half a level with its doubling renewal is at most the level: where others first draw all but
half of a level, rounded down, what is left renews at most to the level. -/
theorem halved_left_le (z : Nat) : halved z + doubling (halved z) ≤ z :=
  match Nat.lt_or_ge 8 (halved z) with
  | .inl over => Nat.le_trans (Nat.le_of_eq (doubling_high over))
      (Nat.le_trans (Nat.le_add_right _ _) (halved_twice z))
  | .inr le => Nat.le_trans (Nat.le_of_eq (doubling_low le)) (halved_twice z)

/-- Half a positive level is less than the level. -/
theorem halved_lt {z : Nat} (pos : 0 < z) : halved z < z :=
  match Nat.eq_zero_or_pos (halved z) with
  | .inl zero => Nat.lt_of_le_of_lt (Nat.le_of_eq zero) pos
  | .inr half => Nat.lt_of_lt_of_le (Nat.lt_add_of_pos_right half) (halved_twice z)

/-- A quarter of a positive level with its doubling renewal is less than the level: where others
first draw all but a quarter of a level, what is left renews to less than the level. -/
theorem quartered_left_lt {z : Nat} (pos : 0 < z) :
    halved (halved z) + doubling (halved (halved z)) < z :=
  Nat.lt_of_le_of_lt (halved_left_le (halved z)) (halved_lt pos)

/-- What stands where others first draw from a doubling source all but half of the level, rounded
down. -/
def halfLeft : Nat → Nat → Nat := Next.leftBy doubling fun _ z => halved z

/-- What stands where others first draw from a doubling source all but a quarter of the level,
rounded down. -/
def quarterLeft : Nat → Nat → Nat := Next.leftBy doubling fun _ z => halved (halved z)

/-- Weights falling by one a step from `n + 4` fall at every step to the `n + 2`-th, by less than
half. -/
theorem linear_falls (n : Nat) :
    ∀ t, t < n + 2 → n + 4 - (t + 1) < n + 4 - t ∧ n + 4 - t < 2 * (n + 4 - (t + 1)) :=
  fun t lt => match le_dest (show t + 1 ≤ n + 2 from lt) with
  | ⟨j, split⟩ =>
    have whole : n + 4 = t + 1 + (j + 2) :=
      (congrArg (· + 2) split).trans (Nat.add_assoc (t + 1) j 2)
    have next : n + 4 - (t + 1) = j + 2 := by
      rw [whole]
      exact Naturals.add_sub_cancel_left (t + 1) (j + 2)
    have here : n + 4 - t = 1 + (j + 2) := by
      rw [whole, Nat.add_assoc t 1 (j + 2)]
      exact Naturals.add_sub_cancel_left t (1 + (j + 2))
    by
      rw [next, here]
      exact ⟨Nat.lt_of_lt_of_le (Nat.lt_succ_self (j + 2)) (Nat.le_of_eq (Nat.add_comm (j + 2) 1)),
        Nat.lt_of_lt_of_le (Nat.add_lt_add_right (Nat.succ_lt_succ (Nat.succ_pos j)) (j + 2))
          (Nat.le_of_eq (Nat.two_mul (j + 2)).symm)⟩

/-- **The doubling witness: alone every optimum rebuilds; with others drawing first, every optimum
ends it.** A source doubling up to eight, from two, with capacity sixteen, and the order by what the
taker draws over `n + 3` steps, the draw of the step from `t` weighted by `w t`. Where the weight
rises at no step and falls by less than half, `w (t + 1) ≤ w t < 2 w (t + 1)` (equal positive
weights among them): alone, every optimum draws nothing at the first step, standing at four, and stands at
eight at every later step to the horizon's last (`frontier_rebuilds`, `frontier_rebuilt`); with
others first drawing all but a quarter of what the taker leaves, every optimum of the same order
stands at nothing at every step and breaks the dweller, which needs two, at the first step
(`Web.Next.frontier_ends_drawn_more`). Where the weight falls at every step, however slightly, with
others first drawing all but half, every optimum ends it and breaks the dweller
(`Web.Next.frontier_ends_drawn_first`); weights falling by one a step from `n + 4` fall at every
step and by less than half (`linear_falls`), so the same order rebuilds the source alone. Where the weights are equal, with others first
drawing all but half, the course ending the source at once and the course holding it at two are both
optima: the strict fall in `Next.frontier_ends_of_le` cannot be dropped. -/
theorem doubling_drawn_first (n : Nat) (w : Nat → Nat) :
    ((∀ t, t < n + 2 → w (t + 1) ≤ w t ∧ w t < 2 * w (t + 1)) →
      (∀ x, Frontier (OpenCourse doubling 16 2)
          (fun b a => weightedOver w doubling a (n + 2 + 1) < weightedOver w doubling b (n + 2 + 1))
          x →
        x 1 = 4 ∧ x 1 = x 0 + doubling (x 0) ∧ ∀ t, 1 ≤ t → t < n + 2 → x (t + 1) = 8) ∧
      ∀ x, Frontier (Next.Open quarterLeft 16 2)
          (fun b a => Next.weighted w quarterLeft a (n + 2 + 1) <
            Next.weighted w quarterLeft b (n + 2 + 1)) x →
        (web (onSource x)).Broken 0 .dweller .source ∧ ∀ t, t < n + 2 → x (t + 1) = 0) ∧
    ((∀ t, t < n + 2 → w (t + 1) < w t) →
      ∀ x, Frontier (Next.Open halfLeft 16 2)
          (fun b a => Next.weighted w halfLeft a (n + 2 + 1) <
            Next.weighted w halfLeft b (n + 2 + 1)) x →
        (web (onSource x)).Broken 0 .dweller .source ∧ ∀ t, t < n + 2 → x (t + 1) = 0) ∧
    ((∀ t, t < n + 2 → w (t + 1) = w t) →
      Frontier (Next.Open halfLeft 16 2)
          (fun b a => Next.weighted w halfLeft a (n + 2 + 1) <
            Next.weighted w halfLeft b (n + 2 + 1)) (holding 2 0 (n + 2)) ∧
      Frontier (Next.Open halfLeft 16 2)
          (fun b a => Next.weighted w halfLeft a (n + 2 + 1) <
            Next.weighted w halfLeft b (n + 2 + 1)) (holding 2 2 (n + 2))) :=
  ⟨fun gentle =>
    have rises := fun t lt => doubling_rises (Nat.le_of_lt (gentle t lt).2)
    ⟨fun x front =>
      have first := frontier_rebuilds (fun _ _ less => less) (Nat.succ_le_succ (Nat.succ_le_succ
        (Nat.zero_le 6))) doubling_grows rises (fun t lt => doubling_rises_strictly (gentle t lt).2)
        (fun t lt => doubling_top (gentle t lt).1 (Nat.le_of_lt (gentle t lt).2))
        (Nat.le_refl 16) (Nat.zero_le 16) front 0 (Nat.succ_pos (n + 1)) (show 4 < 8 from by decide)
      have rebuilt := frontier_rebuilt (fun _ _ less => less) (Nat.succ_le_succ (Nat.succ_le_succ
        (Nat.zero_le 6))) doubling_grows rises
        (fun t lt => doubling_above (gentle t lt).1 (gentle t lt).2)
        (Nat.le_refl 16) (Nat.zero_le 16) front
      ⟨first.1, first.2, fun t one lt => match le_dest one with
        | ⟨i, split⟩ => rebuilt t lt (by
          rw [split, Nat.add_right_comm]
          exact rise_stays (j := 2) rfl i)⟩,
     fun x front => Web.Next.frontier_ends_drawn_more (W := web (onSource x)) (c := Place.source)
      (f := Formation.dweller) (w := w) (k := 16) (s := 2) (n := n + 2) (R := doubling)
      (K := fun _ z => halved (halved z)) (fun _ _ less => less)
      (fun _ _ _ pos => quartered_left_lt pos) (fun t lt => (gentle t lt).1)
      (fun t lt => Nat.lt_of_lt_of_le (pos_of_lt_two_mul (gentle t lt).2) (gentle t lt).1)
      (by decide) (fun _ => Nat.zero_le 16) (Nat.succ_pos (n + 1)) front trivial
      (Nat.le_of_eq front.1.1.symm) (Nat.succ_pos 1)⟩,
   fun falls x front => Web.Next.frontier_ends_drawn_first (W := web (onSource x))
    (c := Place.source) (f := Formation.dweller) (w := w) (k := 16) (s := 2) (n := n + 2)
    (R := doubling) (K := fun _ z => halved z) (fun _ _ less => less)
    (fun _ _ z => halved_left_le z) falls (by decide)
    (fun _ => Nat.zero_le 16) (Nat.succ_pos (n + 1)) front trivial (Nat.le_of_eq front.1.1.symm)
    (Nat.succ_pos 1),
   fun same =>
    ⟨Next.exhausting_frontier (G := halfLeft)
      (fun t lt z _ => Nat.le_trans (Nat.mul_le_mul_left (w (t + 1)) (halved_left_le z))
        (Nat.le_of_eq (congrArg (· * z) (same t lt))))
      (by decide) (fun _ => Nat.zero_le 16) (Nat.succ_pos (n + 1)),
     Next.holding_frontier (G := halfLeft) (y := 2)
      (fun t lt z => by
        rw [same t lt]
        exact Nat.le_trans (Nat.add_le_add_right (Nat.mul_le_mul_left (w t) (halved_left_le z)) _)
          (Nat.le_of_eq (Nat.add_comm _ _)))
      (Nat.le_refl 2) (by decide) (fun _ => Nat.le_refl 2) (fun _ => (by decide : 2 ≤ 16))
      (fun _ => Nat.zero_le 16) (Nat.succ_pos (n + 1))⟩⟩

/-- **The same order, alone and with others drawing first: the linear case.** With weights falling
by one a step from `n + 4`, alone every optimum of the taker's weighted order rebuilds the doubling
source to four and then eight; where others first draw all but half of what the taker leaves, every
optimum of the same order ends it at once and breaks the dweller (`doubling_drawn_first`,
`linear_falls`). -/
theorem doubling_drawn_first_linear (n : Nat) :
    (∀ x, Frontier (OpenCourse doubling 16 2)
        (fun b a => weightedOver (fun t => n + 4 - t) doubling a (n + 2 + 1) <
          weightedOver (fun t => n + 4 - t) doubling b (n + 2 + 1)) x →
      x 1 = 4 ∧ ∀ t, 1 ≤ t → t < n + 2 → x (t + 1) = 8) ∧
    ∀ x, Frontier (Next.Open halfLeft 16 2)
        (fun b a => Next.weighted (fun t => n + 4 - t) halfLeft a (n + 2 + 1) <
          Next.weighted (fun t => n + 4 - t) halfLeft b (n + 2 + 1)) x →
      (web (onSource x)).Broken 0 .dweller .source ∧ ∀ t, t < n + 2 → x (t + 1) = 0 :=
  have falls := linear_falls n
  ⟨fun x front =>
    have alone := ((doubling_drawn_first n (fun t => n + 4 - t)).1
      (fun t lt => ⟨Nat.le_of_lt (falls t lt).1, (falls t lt).2⟩)).1 x front
    ⟨alone.1, alone.2.2⟩,
   (doubling_drawn_first n (fun t => n + 4 - t)).2.1 fun t lt => (falls t lt).1⟩

end Holding

end Optimum

