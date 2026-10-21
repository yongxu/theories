/-! ## The threshold in the plane

RM2's point of no return is exact on the state where the recent giving lies on the level's side of
the draw (`Adjusted.ends_iff_below`), and left the threshold elsewhere in the plane of level and
recent giving open. Where the adjustment rises with what is left and with the recent giving, runs
keep the order of their starts (`Lasting.orbit_mono`), and within a band every run comes to rest
(`Adjusted.comes_to_rest`); so a state at or below one whose run rests below the draw rests below
it too, and whether it does is decided at step `3 hi + 3`. For each recent giving the levels whose
runs rest below the draw are then exactly those below a least level, and that level does not rise as
the recent giving rises: the point of no return is a falling curve in the plane. Under the regime's
step it is RM1's level `H + y` at every recent giving. -/

/-- The length of the run of `true` with which `b` starts, among its first `k` values. -/
def leading (b : Nat → Bool) : Nat → Nat
  | 0 => 0
  | k + 1 => if leading b k = k ∧ b k = true then k + 1 else leading b k

theorem leading_le (b : Nat → Bool) : ∀ k, leading b k ≤ k
  | 0 => Nat.le_refl 0
  | k + 1 => by
    show (if leading b k = k ∧ b k = true then k + 1 else leading b k) ≤ k + 1
    exact if h : leading b k = k ∧ b k = true then by rw [if_pos h]; exact Nat.le_refl _
      else by rw [if_neg h]; exact Nat.le_succ_of_le (leading_le b k)

/-- Every value before the leading run's end is `true`. -/
theorem leading_true (b : Nat → Bool) : ∀ k x, x < leading b k → b x = true
  | 0, _, lt => absurd lt (Nat.not_lt_zero _)
  | k + 1, x, lt => by
    have unfold : leading b (k + 1) = if leading b k = k ∧ b k = true then k + 1 else leading b k := rfl
    exact if h : leading b k = k ∧ b k = true then by
        rw [unfold, if_pos h] at lt
        exact (Nat.lt_or_ge x k).elim
          (fun below => leading_true b k x (Nat.lt_of_lt_of_le below (Nat.le_of_eq h.1.symm)))
          (fun ge => (congrArg b (Nat.le_antisymm (Nat.le_of_lt_succ lt) ge)).trans h.2)
      else by
        rw [unfold, if_neg h] at lt
        exact leading_true b k x lt

/-- Where the leading run ends before `k`, the value there is `false`. -/
theorem leading_false (b : Nat → Bool) : ∀ k, leading b k < k → b (leading b k) = false
  | 0, lt => absurd lt (Nat.lt_irrefl 0)
  | k + 1, lt => by
    have unfold : leading b (k + 1) = if leading b k = k ∧ b k = true then k + 1 else leading b k := rfl
    exact if h : leading b k = k ∧ b k = true then by
        rw [unfold, if_pos h] at lt
        exact absurd lt (Nat.lt_irrefl _)
      else by
        rw [unfold, if_neg h] at lt ⊢
        exact (Nat.lt_or_ge (leading b k) k).elim (leading_false b k) fun ge =>
          have same : leading b k = k := Nat.le_antisymm (leading_le b k) ge
          match hb : b k with
          | true => absurd ⟨same, hb⟩ h
          | false => (congrArg b same).trans hb

namespace Adjusted

/-- The run from a state comes to rest below the draw. -/
def RestsBelow (A : Nat → Nat → Nat) (H : Nat) (p : Nat × Nat) : Prop :=
  ∃ N, LastChange.StillFrom (Law.run (step A H) p) N ∧ ((Law.run (step A H) p).state N).1 < H

/-- Whether the run from level `x` with recent giving `r` is below the draw at step `3 hi + 3`. -/
def falling (A : Nat → Nat → Nat) (H hi r x : Nat) : Bool :=
  decide (((Law.run (step A H) (x, r)).state (hi + hi + hi + 3)).1 < H)

/-- **The threshold in the plane.** For a recent giving `r`, the least level up to `hi + 1` whose run,
within the band up to `hi`, is not below the draw at step `3 hi + 3`. -/
def threshold (A : Nat → Nat → Nat) (H hi r : Nat) : Nat := leading (falling A H hi r) (hi + 1)

theorem threshold_le (A : Nat → Nat → Nat) (H hi r : Nat) : threshold A H hi r ≤ hi + 1 :=
  leading_le _ _

/-- **Below a state whose run rests below the draw, every run does.** Where the adjustment rises with
what is left and with the recent giving and keeps a band, a state at or below one within the band
whose run comes to rest below the draw comes to rest below it too. -/
theorem falls_of_below {A : Nat → Nat → Nat} {H hi : Nat} {p q : Nat × Nat} (rises : Rises A)
    (band : Band A H hi) (below : Below p q) (high : q.1 ≤ hi) (given : q.2 ≤ hi)
    (falls : RestsBelow A H q) : RestsBelow A H p :=
  have ⟨N, still, low⟩ := falls
  have ⟨N', _, still', _⟩ := comes_to_rest (g := fun e => A e H) (x := p.1) (r := p.2) rises
    (fun _ => Iff.rfl) band (Nat.le_trans below.1 high) (Nat.le_trans below.2 given)
  have order := Lasting.orbit_mono (rel := Below) (fun _ _ b => step_mono rises H b) below (N' + N)
  ⟨N', still', Nat.lt_of_le_of_lt
    (Nat.le_trans (Nat.le_of_eq (congrArg Prod.fst (LastChange.still_stays still' N).symm))
      (Nat.le_trans order.1 (Nat.le_of_eq (congrArg Prod.fst
        ((congrArg (Law.orbit (step A H) q) (Nat.add_comm N' N)).trans
          (LastChange.still_stays still N'))))))
    low⟩

/-- Within a band, whether the run of a rising adjustment comes to rest below the draw is decided at
step `3 hi + 3`. -/
theorem falls_iff {A : Nat → Nat → Nat} {H hi x r : Nat} (rises : Rises A) (band : Band A H hi)
    (high : x ≤ hi) (given : r ≤ hi) :
    RestsBelow A H (x, r) ↔ ((Law.run (step A H) (x, r)).state (hi + hi + hi + 3)).1 < H :=
  have ⟨N0, le, still0, _⟩ := comes_to_rest (g := fun e => A e H) rises (fun _ => Iff.rfl) band high given
  have atM : (Law.run (step A H) (x, r)).state (hi + hi + hi + 3) =
      (Law.run (step A H) (x, r)).state N0 :=
    (congrArg (fun n => (Law.run (step A H) (x, r)).state n) (Naturals.add_sub_of_le le).symm).trans
      (LastChange.still_stays still0 _)
  ⟨fun ⟨_, still, low⟩ => Nat.lt_of_le_of_lt (Nat.le_of_eq (congrArg Prod.fst
      (atM.trans (LastChange.still_same still0 still)))) low,
   fun low => ⟨N0, still0, Nat.lt_of_le_of_lt (Nat.le_of_eq (congrArg Prod.fst atM.symm)) low⟩⟩

/-- **The threshold is exact.** Where the adjustment rises with what is left and with the recent
giving and keeps a band up to `hi`, the run from a level and a recent giving up to `hi` comes to rest
below the draw exactly where the level is below the threshold for that recent giving. -/
theorem falls_iff_below {A : Nat → Nat → Nat} {H hi x r : Nat} (rises : Rises A)
    (band : Band A H hi) (high : x ≤ hi) (given : r ≤ hi) :
    RestsBelow A H (x, r) ↔ x < threshold A H hi r :=
  ⟨fun falls => (Nat.lt_or_ge x (threshold A H hi r)).elim id fun ge =>
      have short : threshold A H hi r < hi + 1 := Nat.lt_of_le_of_lt ge (Nat.lt_succ_of_le high)
      have notFalls : ¬ RestsBelow A H (threshold A H hi r, r) := fun f =>
        absurd ((falls_iff rises band (Nat.le_of_lt_succ short) given).1 f)
          (of_decide_eq_false (leading_false (falling A H hi r) (hi + 1) short))
      absurd (falls_of_below rises band ⟨ge, Nat.le_refl r⟩ high given falls) notFalls,
   fun lt => (falls_iff rises band high given).2
      (of_decide_eq_true (leading_true (falling A H hi r) (hi + 1) x lt))⟩

/-- **The threshold falls as the recent giving rises.** Where the adjustment rises with what is left
and with the recent giving and keeps a band up to `hi`, a larger recent giving up to `hi` has a
threshold no higher. -/
theorem threshold_falls {A : Nat → Nat → Nat} {H hi r r' : Nat} (rises : Rises A)
    (band : Band A H hi) (le : r ≤ r') (given : r' ≤ hi) :
    threshold A H hi r' ≤ threshold A H hi r :=
  (Nat.lt_or_ge (threshold A H hi r) (threshold A H hi r')).elim
    (fun lt =>
      have high : threshold A H hi r ≤ hi :=
        Nat.le_of_lt_succ (Nat.lt_of_lt_of_le lt (threshold_le A H hi r'))
      have falls := falls_of_below (p := (threshold A H hi r, r)) (q := (threshold A H hi r, r')) rises
        band ⟨Nat.le_refl _, le⟩ high given ((falls_iff_below rises band high given).2 lt)
      absurd ((falls_iff_below rises band high (Nat.le_trans le given)).1 falls) (Nat.lt_irrefl _))
    id

/-- **Every state in the band has its fate by the threshold.** Where the adjustment rises with what
is left and with the recent giving, rests at the draw exactly where the regime gives the draw, and
keeps a band up to `hi`, the run from a level and a recent giving up to `hi` is still from some step
at most `3 hi + 3`: below the threshold, at a rest below the draw with level and recent giving equal
(nothing, where nothing gives from nothing); from the threshold on, at the draw with a level the
regime's step leaves as it is. -/
theorem fates {A : Nat → Nat → Nat} {g : Nat → Nat} {H hi x r : Nat} (rises : Rises A)
    (restsAt : RestsAtDraw A g H) (band : Band A H hi) (high : x ≤ hi) (given : r ≤ hi) :
    ∃ N, N ≤ hi + hi + hi + 3 ∧ LastChange.StillFrom (Law.run (step A H) (x, r)) N ∧
      (x < threshold A H hi r → ((Law.run (step A H) (x, r)).state N).1 < H ∧
        ((Law.run (step A H) (x, r)).state N).1 = ((Law.run (step A H) (x, r)).state N).2 ∧
        A 0 ((Law.run (step A H) (x, r)).state N).2 = ((Law.run (step A H) (x, r)).state N).2) ∧
      (threshold A H hi r ≤ x → ((Law.run (step A H) (x, r)).state N).2 = H ∧
        H ≤ ((Law.run (step A H) (x, r)).state N).1 ∧
        RegimeMargin.step g H ((Law.run (step A H) (x, r)).state N).1 =
          ((Law.run (step A H) (x, r)).state N).1) :=
  have ⟨N, le, still, rest⟩ := comes_to_rest rises restsAt band high given
  ⟨N, le, still,
   fun lt => rest.elim
    (fun ⟨_, up, _⟩ =>
      have ⟨_, still', low'⟩ := (falls_iff_below rises band high given).2 lt
      absurd (Nat.lt_of_le_of_lt (Nat.le_of_eq (congrArg Prod.fst (LastChange.still_same still still')))
        low') fun l => Nat.lt_irrefl _ (Nat.lt_of_lt_of_le l up))
    id,
   fun ge => rest.elim id fun ⟨low, _, _⟩ =>
    absurd ((falls_iff_below rises band high given).1 ⟨N, still, low⟩)
      fun l => Nat.lt_irrefl _ (Nat.lt_of_lt_of_le l ge)⟩

end Adjusted

/-- **Under the regime's step the threshold is the point of no return.** Where giving rises with what
is left, falls short of the draw below `y`, meets it from `y` up to the band's top, gives nothing from
nothing, and the step keeps the band up to `hi`, which reaches the point, the threshold is `H + y` at
every recent giving up to `hi`. -/
theorem threshold_regime {g : Nat → Nat} {H y hi r : Nat} (grows : ∀ a b, a ≤ b → g a ≤ g b)
    (short : Short g H y) (nothing : FromNothing g) (meets : Meets g H y hi)
    (keeps : Keeps g H hi) (given : r ≤ hi) (reach : H + y ≤ hi + 1) :
    Adjusted.threshold (fun e _ => g e) H hi r = H + y := by
  have rises : Adjusted.Rises (fun e _ => g e) := fun e e' _ _ le _ => grows e e' le
  have band : Adjusted.Band (fun e _ => g e) H hi := fun x _ high _ => keeps x high
  have regime : ∀ x, x ≤ hi → (Adjusted.RestsBelow (fun e _ => g e) H (x, r) ↔ x < H + y) :=
    fun x high => ⟨fun ⟨N, _, low⟩ => (Nat.lt_or_ge x (H + y)).elim id fun ge =>
        have up : x ≤ (Law.run (step g H) x).state N := (holds meets keeps ge high N).1
        absurd low fun l => Nat.lt_irrefl _ (Nat.lt_of_lt_of_le l (Nat.le_trans
          (Nat.le_trans (Nat.le_add_right H y) ge)
          (Nat.le_trans up (Nat.le_of_eq (Adjusted.orbit_regime g H (x, r) N).symm)))),
      fun below =>
        have gone : (Law.orbit (Adjusted.step (fun e _ => g e) H) (x, r) x).1 = 0 :=
          (Adjusted.orbit_regime g H (x, r) x).trans (ends_below short nothing below)
        have next : Law.orbit (Adjusted.step (fun e _ => g e) H) (x, r) (x + 1) = (0, 0) := by
          show (_ - H + g (_ - H), g (_ - H)) = (0, 0)
          rw [gone, Nat.zero_sub, nothing]
        have stays : ∀ k, Law.orbit (Adjusted.step (fun e _ => g e) H) (x, r) (x + 1 + k) = (0, 0) :=
          fun k => (Law.orbit_add _ (x, r) (x + 1) k).trans (by
            rw [next, ← Nat.one_mul k]
            exact Law.orbit_mul (next := Adjusted.step (fun e _ => g e) H) (s := (0, 0)) (p := 1)
              (show (0 - H + g (0 - H), g (0 - H)) = (0, 0) by rw [Nat.zero_sub, nothing]) k)
        ⟨x + 1, fun k => (stays (k + 1)).trans (stays k).symm,
          Nat.lt_of_le_of_lt (Nat.le_of_eq (congrArg Prod.fst next)) (Adjusted.draw_pos short below)⟩⟩
  have same : ∀ x, x ≤ hi → (x < Adjusted.threshold (fun e _ => g e) H hi r ↔ x < H + y) :=
    fun x high => (Adjusted.falls_iff_below rises band high given).symm.trans (regime x high)
  have top := Adjusted.threshold_le (fun e _ => g e) H hi r
  exact Nat.le_antisymm
    ((Nat.lt_or_ge (H + y) (Adjusted.threshold (fun e _ => g e) H hi r)).elim
      (fun lt => absurd ((same (H + y) (Nat.le_of_lt_succ (Nat.lt_of_lt_of_le lt top))).1 lt)
        (Nat.lt_irrefl _))
      id)
    ((Nat.lt_or_ge (Adjusted.threshold (fun e _ => g e) H hi r) (H + y)).elim
      (fun lt => absurd ((same _ (Nat.le_of_lt_succ (Nat.lt_of_lt_of_le lt reach))).2 lt)
        (Nat.lt_irrefl _))
      id)

namespace Notch

/-- Giving that is two from one and nothing from any other level. -/
def giving (z : Nat) : Nat := if z = 1 then 2 else 0

/-- Under a draw of two the regime's step keeps every level up to four within four. -/
theorem keeps : Keeps giving 2 4
  | 0, _ => by decide
  | 1, _ => by decide
  | 2, _ => by decide
  | 3, _ => by decide
  | 4, _ => by decide
  | n + 5, high =>
    absurd (Nat.lt_of_lt_of_le (Nat.lt_of_lt_of_le (Nat.lt_succ_self 4) (Nat.le_add_left 5 n)) high)
      (Nat.lt_irrefl 4)

/-- From three with a recent giving of nothing, the run is at three with a recent giving of two from
the first step on. -/
theorem stays_three :
    ∀ n, Law.orbit (Adjusted.step (fun e _ => giving e) 2) (3, 0) (n + 1) = (3, 2) := fun n =>
  (Law.orbit_shift _ (3, 0) n).trans
    ((congrArg (Law.orbit (Adjusted.step (fun e _ => giving e) 2) (3, 2)) (Nat.one_mul n)).symm.trans
      (Law.orbit_mul (next := Adjusted.step (fun e _ => giving e) 2) (s := (3, 2)) (p := 1) rfl n))

/-- From four with a recent giving of nothing, the run is at nothing from the second step on. -/
theorem ends_four :
    ∀ k, Law.orbit (Adjusted.step (fun e _ => giving e) 2) (4, 0) (2 + k) = (0, 0) := fun k =>
  (Law.orbit_add _ (4, 0) 2 k).trans
    ((congrArg (Law.orbit (Adjusted.step (fun e _ => giving e) 2) (0, 0)) (Nat.one_mul k)).symm.trans
      (Law.orbit_mul (next := Adjusted.step (fun e _ => giving e) 2) (s := (0, 0)) (p := 1) rfl k))

/-- **Without giving rising with what is left, there is no threshold.** Giving that is two from one
and nothing from more does not rise with what is left; under a draw of two its step keeps every state
up to four at a level up to four. Yet from four the run comes to rest below the draw, at nothing, and
from three, below four, it rests at three: no least level separates the runs that rest below the
draw from the rest. -/
theorem no_threshold :
    ¬ (∀ a b, a ≤ b → giving a ≤ giving b) ∧ Adjusted.Band (fun e _ => giving e) 2 4 ∧
    Adjusted.RestsBelow (fun e _ => giving e) 2 (4, 0) ∧
    ¬ Adjusted.RestsBelow (fun e _ => giving e) 2 (3, 0) ∧
    ∀ t, ¬ ∀ x, x ≤ 4 → (Adjusted.RestsBelow (fun e _ => giving e) 2 (x, 0) ↔ x < t) :=
  have four : Adjusted.RestsBelow (fun e _ => giving e) 2 (4, 0) :=
    ⟨2, fun k => (ends_four (k + 1)).trans (ends_four k).symm, Nat.zero_lt_succ 1⟩
  have three : ¬ Adjusted.RestsBelow (fun e _ => giving e) 2 (3, 0) := fun ⟨N, _, low⟩ =>
    have big : 3 ≤ ((Law.run (Adjusted.step (fun e _ => giving e) 2) (3, 0)).state N).1 :=
      match N with
      | 0 => Nat.le_refl 3
      | n + 1 => Nat.le_of_eq (congrArg Prod.fst (stays_three n)).symm
    Nat.lt_irrefl 2 (Nat.lt_trans (Nat.lt_succ_self 2) (Nat.lt_of_le_of_lt big low))
  ⟨fun grows => absurd (grows 1 2 (Nat.le_succ 1)) (by decide), fun x _ high _ => keeps x high,
   four, three,
   fun t all => three ((all 3 (Nat.le_succ 3)).2
     (Nat.lt_trans (Nat.lt_succ_self 3) ((all 4 (Nat.le_refl 4)).1 four)))⟩

end Notch
