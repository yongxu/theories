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
