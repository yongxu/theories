import Becoming.Optimum

/-!
# Coupled drawers: a coupling in each drawer's worth for each step a need is met

Board item CDR, from UE6's third round (26 October 2026), on candidate 4 of UE0's audit: at mutual
best responses over a horizon, with each optimizer given `c` for each step a dependence is met,
every perfect profile keeps the dependence exactly where the couplings cover the renewal forgone at
the joint capacity, and breaks it within a long horizon below that rate. That statement is false
here on both arrangements (`gated_threshold`, `AtOnce.Shores.drain_perfect`); what holds is below.

The module states the candidate on the two arrangements of several drawers over a horizon that
`Becoming.Optimum` already has, drawers in turn (`Optimum.InTurn`) and drawers at once
(`Optimum.AtOnce`). Each drawer's worth over the steps that remain is what it draws there with `c`
for each step at which what all the drawers leave meets the need `m` (`stepCoupling`); nothing is valued
after the horizon. Perfect is the existing notion: at every step from every amount, every drawer's
rule, a function of the step and of what it is given (drawing at once, of its portion), is a best
response among leaving anything from its floor to all of it, over the steps that remain, the
others and its own later rules following the profile. With `c = 0` the coupled notion in turn is
`InTurn.Perfect` (`perfect_uncoupled`); at once it is defined alike, and no equivalence is stated.
The need `m` is positive throughout. Amounts are whole numbers and steps discrete.

* **In turn, below the need, nothing moves** (`drains_below`, `drain_perfect`). With at least two
  drawers and no floor, where `c < m` every perfect profile has every drawer leave nothing at every
  step before the horizon, from every amount, whatever the law of what stands next and the horizon;
  where `c ≤ m` drawing everything is perfect. Where every later step drains or keeps the need, the
  last drawer in a step decides whether the need is met and draws nothing later whatever it leaves,
  so keeping adds `c` to its worth against the `m` it must leave.
* **In turn, above the need, every perfect profile keeps exactly the need** (`kept_above`,
  `keeping_perfect`, `kept_levels`). With at least two drawers and no floor, under the gate (below
  the need what stands next is below it;
  at or above the need what stands next meets it; what stands next from nothing, with the need, is
  at most what stands next from the need), where `m < c` every perfect profile has each drawer
  leave exactly the need of an amount at least the need and nothing of a smaller one, and where
  `m ≤ c` that profile is perfect; from a start at or above the need the need is met at every step.
  On the gated renewal `gatedRenewal m q`, for every `q`, the four statements hold together
  (`gated_threshold`): the threshold is the need itself, not the renewal forgone a step (there
  `0`) and not the joint capacity (there unbounded).
* **One drawer keeps where several in turn do not** (`one_keeps_first`, `one_perfect`,
  `one_keeps_several_drain`): on the gated renewal, with `c < m` and `0 < c + q`, over two steps every
  perfect profile of one drawer leaves at least the need of an amount at least the need at the first
  step, and such a profile exists; every perfect profile of two or more drawers in turn leaves
  nothing at either step. With `c = 0` and `0 < q` this holds with no coupling at all.
* **At once, the drain is perfect exactly where no drawer alone gains more than it leaves**
  (`AtOnce.drain_perfect_iff`, `AtOnce.drain_perfect_iff_reach`): against the others drawing
  everything a drawer meets the need only by leaving all of it itself; where what is left returns
  nothing, the drain is perfect exactly where `c ≤ m` wherever a portion reaches the need.
* **At once, without a pivotal drawer, the drain is perfect at every rate**
  (`AtOnce.unpivotal_drain_perfect`, `AtOnce.Shores.drain_perfect`): where every portion lies below
  the need and no portion returns more than one for one, drawing everything is perfect for every `c`
  and the need is met at no step; with the level left as it is, two shores each reaching `p < m`,
  together reaching `p + p`, have the drain perfect at every coupling rate, the need met at no step.
-/

namespace Becoming

namespace Optimum

namespace Coupled

open InTurn

/-! ## The coupling -/

/-- **The coupling of one step**: `c` where what is left, `b`, meets the need `m`, else nothing. -/
def stepCoupling (c m b : Nat) : Nat := if m ≤ b then c else 0

theorem stepCoupling_of_le {c m b : Nat} (le : m ≤ b) : stepCoupling c m b = c := if_pos le

theorem stepCoupling_of_lt {c m b : Nat} (lt : b < m) : stepCoupling c m b = 0 := if_neg (Nat.not_le_of_gt lt)

theorem stepCoupling_zero (m b : Nat) : stepCoupling 0 m b = 0 :=
  match Nat.lt_or_ge b m with
  | .inl lt => stepCoupling_of_lt lt
  | .inr ge => stepCoupling_of_le ge

/-- **Keeping the need**: leave the need of an amount at least the need, and nothing of a smaller
one. -/
def keep (m a : Nat) : Nat := if m ≤ a then m else 0

theorem keep_of_le {m a : Nat} (le : m ≤ a) : keep m a = m := if_pos le

theorem keep_of_lt {m a : Nat} (lt : a < m) : keep m a = 0 := if_neg (Nat.not_le_of_gt lt)

theorem keep_le (m a : Nat) : keep m a ≤ a :=
  match Nat.lt_or_ge a m with
  | .inl lt => Nat.le_trans (Nat.le_of_eq (keep_of_lt lt)) (Nat.zero_le a)
  | .inr ge => Nat.le_trans (Nat.le_of_eq (keep_of_le ge)) ge

theorem keep_keep (m a : Nat) : keep m (keep m a) = keep m a :=
  match Nat.lt_or_ge a m with
  | .inl lt => by
    rw [keep_of_lt lt]
    match Nat.eq_zero_or_pos m with
    | .inl zero => exact (keep_of_le (Nat.le_of_eq zero)).trans zero
    | .inr pos => exact keep_of_lt pos
  | .inr ge => by
    rw [keep_of_le ge]
    exact keep_of_le (Nat.le_refl m)

/-! ## Drawers in turn, coupled -/

/-- What drawer `d` of `k` draws over `j` steps from step `t` at level `z`, with `c` for each step
at which what all the drawers leave meets `m`. -/
def drawn (G : Nat → Nat → Nat) (rules : Nat → Nat → Nat → Nat) (k d c m : Nat) :
    Nat → Nat → Nat → Nat
  | 0, _, _ => 0
  | j + 1, t, z => (pass rules t 0 d z - rules d t (pass rules t 0 d z)) +
      stepCoupling c m (pass rules t 0 k z) + drawn G rules k d c m j (t + 1) (next G rules k t z)

/-- What drawer `d` gains after leaving `b` at step `t`: the coupling of that step, as the drawers
after it leave, and what it gains over the `j` steps after. -/
def later (G : Nat → Nat → Nat) (rules : Nat → Nat → Nat → Nat) (k d c m j t b : Nat) : Nat :=
  stepCoupling c m (pass rules t (d + 1) (k - (d + 1)) b) +
    drawn G rules k d c m j (t + 1) (G t (pass rules t (d + 1) (k - (d + 1)) b))

/-- **A revision, coupled**: as `InTurn.Revises`, each drawer's worth being what it draws with `c`
for each step at which what all leave meets `m`. -/
def Revises (G : Nat → Nat → Nat) (low rules rules' : Nat → Nat → Nat → Nat) (k c m N : Nat) :
    Prop :=
  (∀ d t a, low d t a ≤ rules' d t a ∧ rules' d t a ≤ a) ∧
  ∀ t j, t + j + 1 = N → ∀ d, d < k → ∀ a b, low d t a ≤ b → b ≤ a →
    a - b + later G rules k d c m j t b ≤ a - rules' d t a + later G rules k d c m j t (rules' d t a)

/-- **Perfect, coupled**: the profile revises itself. -/
def Perfect (G : Nat → Nat → Nat) (low rules : Nat → Nat → Nat → Nat) (k c m N : Nat) : Prop :=
  Revises G low rules rules k c m N

variable {G : Nat → Nat → Nat} {rules : Nat → Nat → Nat → Nat} {k c m N : Nat}

/-- With no coupling, the coupled draws are the draws. -/
theorem drawn_uncoupled (d m : Nat) :
    ∀ j t z, drawn G rules k d 0 m j t z = InTurn.drawn G rules k d j t z
  | 0, _, _ => rfl
  | j + 1, t, z => by
    show _ + stepCoupling 0 m _ + drawn G rules k d 0 m j (t + 1) _ = _ + InTurn.drawn G rules k d j (t + 1) _
    rw [stepCoupling_zero, Nat.add_zero, drawn_uncoupled d m j]

/-- **With no coupling, the coupled notion is the existing one.** -/
theorem perfect_uncoupled {low : Nat → Nat → Nat → Nat} :
    Perfect G low rules k 0 m N ↔ InTurn.Perfect G low rules k N :=
  have same : ∀ d j t b, later G rules k d 0 m j t b = InTurn.later G rules k d j t b :=
    fun d j t b => by
      show stepCoupling 0 m _ + drawn G rules k d 0 m j (t + 1) _ = InTurn.drawn G rules k d j (t + 1) _
      rw [stepCoupling_zero, Nat.zero_add, drawn_uncoupled]
  ⟨fun perfect => ⟨perfect.1, fun t j at_ d dk a b floor le => by
      have h := perfect.2 t j at_ d dk a b floor le
      rw [same, same] at h
      exact h⟩,
   fun perfect => ⟨perfect.1, fun t j at_ d dk a b floor le => by
      rw [same, same]
      exact perfect.2 t j at_ d dk a b floor le⟩⟩

/-! ### Passing through drawers who follow one rule -/

/-- **Through drawers following one settled rule, that rule.** Where drawers `e, …, e + n - 1`,
at least one, all leave `f` of what they are given at step `t`, and `f` of what `f` leaves is what
`f` leaves, they leave `f b` of `b`. -/
theorem pass_all {f : Nat → Nat} (settled : ∀ a, f (f a) = f a) {t : Nat} :
    ∀ n e, 0 < n → (∀ i, e ≤ i → i < e + n → ∀ a, rules i t a = f a) → ∀ b,
      pass rules t e n b = f b
  | 0, _, pos, _, _ => absurd pos (Nat.lt_irrefl 0)
  | 1, e, _, all, b => all e (Nat.le_refl e) (Nat.lt_succ_self e) b
  | n + 2, e, _, all, b => by
    show pass rules t (e + 1) (n + 1) (rules e t b) = f b
    rw [pass_all settled (n + 1) (e + 1) (Nat.succ_pos n) (fun i le lt => all i (Nat.le_of_succ_le le)
      (Nat.lt_of_lt_of_le lt (Nat.le_of_eq (Nat.add_right_comm e 1 (n + 1))))) (rules e t b),
      all e (Nat.le_refl e) (Nat.lt_of_lt_of_le (Nat.lt_succ_self e) (Nat.succ_le_succ (Nat.le_add_right e (n + 1))))]
    exact settled b

/-- At step `t`, every drawer of `k` following `f`. -/
def AllFollow (rules : Nat → Nat → Nat → Nat) (k : Nat) (f : Nat → Nat) (t : Nat) : Prop :=
  ∀ d, d < k → ∀ a, rules d t a = f a

/-- What drawer `d`, at least the first, is given at a step where all follow a settled rule. -/
theorem given_all {f : Nat → Nat} (settled : ∀ a, f (f a) = f a) {t d : Nat} (pos : 0 < d)
    (dk : d < k) (all : AllFollow rules k f t) (z : Nat) : pass rules t 0 d z = f z :=
  pass_all settled d 0 pos (fun i _ lt => all i (Nat.lt_trans (Nat.lt_of_lt_of_le lt
    (Nat.le_of_eq (Nat.zero_add d))) dk)) z

/-- What all the drawers leave at a step where all follow a settled rule. -/
theorem left_all {f : Nat → Nat} (settled : ∀ a, f (f a) = f a) {t : Nat} (pos : 0 < k)
    (all : AllFollow rules k f t) (z : Nat) : pass rules t 0 k z = f z :=
  pass_all settled k 0 pos (fun i _ lt => all i (Nat.lt_of_lt_of_le lt
    (Nat.le_of_eq (Nat.zero_add k)))) z

/-- The drawers after the last leave what they are given. -/
theorem pass_after_last {t d : Nat} (last : d + 1 = k) (b : Nat) :
    pass rules t (d + 1) (k - (d + 1)) b = b := by
  rw [last, Nat.sub_self]
  rfl

/-! ### Best responses against a coupling read at the need -/

/-- Leaving at most all of an amount, and comparing. -/
theorem zero_of_le_sub {a r : Nat} (le : r ≤ a) (h : a ≤ a - r) : r = 0 :=
  Nat.eq_zero_of_le_zero (Naturals.le_of_add_le_add_left (k := a)
    (Nat.le_trans (Nat.le_trans (Nat.add_le_add_right h r) (Nat.le_of_eq (Naturals.sub_add_cancel le)))
      (Nat.le_of_eq (Nat.add_zero a).symm)))

theorem le_of_sub_le_sub {a m r : Nat} (ma : m ≤ a) (ra : r ≤ a) (h : a - m ≤ a - r) : r ≤ m :=
  Naturals.le_of_add_le_add_left (k := a - m) (Nat.le_trans
    (Nat.le_trans (Nat.add_le_add_right h r) (Nat.le_of_eq (Naturals.sub_add_cancel ra)))
    (Nat.le_of_eq (Naturals.sub_add_cancel ma).symm))

/-- **Where a coupling below the need is all that leaving brings, a best response leaves
nothing.** Where what leaving `b` brings later is `W` with the coupling `stepCoupling c m b`, `c < m`, a
best response among `0, …, a` leaves nothing. -/
theorem leaves_nothing {L : Nat → Nat} {a r W : Nat} (below : c < m) (pos : 0 < m)
    (worth : ∀ b, L b = W + stepCoupling c m b) (le : r ≤ a) (best : a - 0 + L 0 ≤ a - r + L r) : r = 0 := by
  rw [worth, worth, stepCoupling_of_lt pos, Nat.add_zero, Nat.sub_zero] at best
  match Nat.lt_or_ge r m with
  | .inl lt =>
    rw [stepCoupling_of_lt lt, Nat.add_zero] at best
    exact zero_of_le_sub le (le_of_add_le_add_right _ best)
  | .inr ge =>
    rw [stepCoupling_of_le ge] at best
    have less : a - r + (W + c) < a + W :=
      calc a - r + (W + c) = a - r + c + W := by
            rw [Nat.add_comm W c, ← Nat.add_assoc]
        _ < a - r + r + W := Nat.add_lt_add_right (Nat.add_lt_add_left
            (Nat.lt_of_lt_of_le below ge) _) W
        _ = a + W := by rw [Naturals.sub_add_cancel le]
    exact absurd best (Nat.not_le_of_gt less)

/-- **Where leaving the need brings more than the need beyond leaving less, a best response leaves
exactly the need, or nothing below it.** Where what leaving `b` brings later is `V` for `b` at
least the need and `W` below it, with `W + m < V`, a best response among `0, …, a` leaves `keep m a`:
the need where `a` meets it, nothing where it does not. -/
theorem leaves_need {L : Nat → Nat} {a r V W : Nat} (pos : 0 < m)
    (above : ∀ b, m ≤ b → L b = V) (below : ∀ b, b < m → L b = W) (more : W + m < V)
    (le : r ≤ a) (best : ∀ b, b ≤ a → a - b + L b ≤ a - r + L r) : r = keep m a :=
  match Nat.lt_or_ge a m with
  | .inl am => by
    rw [keep_of_lt am]
    have h := best 0 (Nat.zero_le a)
    rw [below 0 pos, below r (Nat.lt_of_le_of_lt le am), Nat.sub_zero] at h
    exact zero_of_le_sub le (le_of_add_le_add_right _ h)
  | .inr ma => by
    rw [keep_of_le ma]
    have h := best m ma
    rw [above m (Nat.le_refl m)] at h
    match Nat.lt_or_ge r m with
    | .inl rm =>
      rw [below r rm] at h
      have less : a - r + W < a - m + V :=
        calc a - r + W ≤ a + W := Nat.add_le_add_right (Nat.sub_le a r) W
          _ = a - m + (m + W) := by rw [← Nat.add_assoc, Naturals.sub_add_cancel ma]
          _ < a - m + V := Nat.add_lt_add_left (Nat.lt_of_le_of_lt
              (Nat.le_of_eq (Nat.add_comm m W)) more) _
      exact absurd h (Nat.not_le_of_gt less)
    | .inr mr =>
      rw [above r mr] at h
      exact Nat.le_antisymm (le_of_sub_le_sub ma le (le_of_add_le_add_right _ h)) mr

/-- **Leaving the need is a best response** where leaving it brings at least the need beyond
leaving less: the non-strict converse of `leaves_need`. -/
theorem need_best {L : Nat → Nat} {a V W : Nat} (pos : 0 < m)
    (above : ∀ b, m ≤ b → L b = V) (below : ∀ b, b < m → L b = W) (more : W + m ≤ V) :
    ∀ b, b ≤ a → a - b + L b ≤ a - keep m a + L (keep m a) := fun b ba =>
  match Nat.lt_or_ge a m with
  | .inl am => by
    rw [keep_of_lt am, below 0 pos, below b (Nat.lt_of_le_of_lt ba am), Nat.sub_zero]
    exact Nat.add_le_add_right (Nat.sub_le a b) W
  | .inr ma => by
    rw [keep_of_le ma, above m (Nat.le_refl m)]
    match Nat.lt_or_ge b m with
    | .inl bm =>
      rw [below b bm]
      calc a - b + W ≤ a + W := Nat.add_le_add_right (Nat.sub_le a b) W
        _ = a - m + (m + W) := by rw [← Nat.add_assoc, Naturals.sub_add_cancel ma]
        _ ≤ a - m + V := Nat.add_le_add_left (Nat.le_trans (Nat.le_of_eq (Nat.add_comm m W)) more) _
    | .inr mb =>
      rw [above b mb]
      exact Nat.add_le_add_right (sub_le_sub_left_of_le mb a) V


/-- **Downward over drawers**: what holds of a drawer wherever it holds of every later one holds
of every drawer. -/
theorem down {P : Nat → Prop} {k : Nat} (step : ∀ d, d < k → (∀ e, d < e → e < k → P e) → P d) :
    ∀ n d, k ≤ d + n → d < k → P d
  | 0, _, le, lt => absurd (Nat.lt_of_lt_of_le lt le) (Nat.lt_irrefl _)
  | n + 1, d, le, lt => step d lt fun e de ek => down step n e
      (Nat.le_trans le (Nat.le_trans (Nat.le_of_eq (Nat.add_right_comm d n 1))
        (Nat.add_le_add_right de n))) ek

/-- The last drawer is one past every other. -/
theorem last_drawer (two : 1 < k) : k - 1 + 1 = k :=
  Naturals.sub_add_cancel (Nat.le_of_lt two)

/-- **What the drawers after one leave.** Where the drawers after `d` at step `t` leave `f`,
settled, they leave `b` of `b` where `d` is the last, and `f b` where it is not. -/
theorem pass_after {f : Nat → Nat} (settled : ∀ a, f (f a) = f a) {t d : Nat} (dk : d < k)
    (after : ∀ e, d < e → e < k → ∀ a, rules e t a = f a) (b : Nat) :
    pass rules t (d + 1) (k - (d + 1)) b = b ∨ pass rules t (d + 1) (k - (d + 1)) b = f b :=
  match Nat.lt_or_ge (d + 1) k with
  | .inl lt => .inr (pass_all settled (k - (d + 1)) (d + 1) (SupportGated.sub_pos_of_lt lt)
      (fun i le lt' => after i le (Nat.lt_of_lt_of_le lt'
        (Nat.le_of_eq (Becoming.add_sub_of_le (Nat.le_of_lt lt))))) b)
  | .inr ge => .inl (pass_after_last (Nat.le_antisymm dk ge) b)

/-! ### Below the need -/

/-- **Under the drain, a drawer after the first draws nothing and its coupling adds nothing.** Where every
drawer leaves nothing at every step from `t` over `j` steps, drawer `d`, not the first, draws
nothing there and no step meets a positive need. -/
theorem drawn_drained (pos : 0 < m) {d : Nat} (first : 0 < d) (dk : d < k) :
    ∀ j t, (∀ s, t ≤ s → s < t + j → AllFollow rules k (fun _ => 0) s) → ∀ z,
      drawn G rules k d c m j t z = 0
  | 0, _, _, _ => rfl
  | j + 1, t, all, z => by
    have now := all t (Nat.le_refl t) (Nat.lt_of_lt_of_le (Nat.lt_succ_self t)
      (Nat.succ_le_succ (Nat.le_add_right t j)))
    show pass rules t 0 d z - rules d t (pass rules t 0 d z) + stepCoupling c m (pass rules t 0 k z) +
      drawn G rules k d c m j (t + 1) (next G rules k t z) = 0
    rw [given_all (f := fun _ => 0) (fun _ => rfl) first dk now z, now d dk 0,
      left_all (f := fun _ => 0) (fun _ => rfl) (Nat.lt_trans first dk) now z, stepCoupling_of_lt pos,
      drawn_drained pos first dk j (t + 1) (fun s le lt => all s (Nat.le_of_succ_le le)
        (Nat.lt_of_lt_of_le lt (Nat.le_of_eq (Nat.add_right_comm t 1 j)))) _]
    rfl

/-- **Below the need, at one step.** In a coupled perfect profile with at least two drawers and no
floor, where `c < m` and every drawer leaves nothing at every step after `t`, every drawer leaves
nothing at `t`: the last drawer's keeping brings it `c` against the `m` it leaves and nothing
later, and what any other leaves passes through the last. -/
theorem drains_at (two : 1 < k) (pos : 0 < m) (below : c < m)
    (perfect : Perfect G (fun _ _ _ => 0) rules k c m N) {t j : Nat} (here : t + j + 1 = N)
    (after : ∀ s, t + 1 ≤ s → s < N → AllFollow rules k (fun _ => 0) s) :
    AllFollow rules k (fun _ => 0) t :=
  have last := last_drawer two
  have lk : k - 1 < k := Nat.lt_of_lt_of_le (Nat.lt_succ_self (k - 1)) (Nat.le_of_eq last)
  have lpos : 0 < k - 1 := SupportGated.sub_pos_of_lt two
  have leaves : ∀ d t a, rules d t a ≤ a := fun d t a => (perfect.1 d t a).2
  have future : ∀ s, t + 1 ≤ s → s < t + 1 + j → AllFollow rules k (fun _ => 0) s :=
    fun s le lt => after s le (Nat.lt_of_lt_of_le lt
      (Nat.le_of_eq ((Nat.add_right_comm t 1 j).trans here)))
  have lastNone : ∀ a, rules (k - 1) t a = 0 := fun a =>
    leaves_nothing (L := later G rules k (k - 1) c m j t) (W := 0) below pos
      (fun b => by
        show stepCoupling c m (pass rules t (k - 1 + 1) (k - (k - 1 + 1)) b) +
          drawn G rules k (k - 1) c m j (t + 1) (G t (pass rules t (k - 1 + 1) (k - (k - 1 + 1)) b)) = _
        rw [pass_after_last last b, drawn_drained pos lpos lk j (t + 1) future, Nat.add_zero,
          Nat.zero_add])
      (leaves (k - 1) t a)
      (perfect.2 t j here (k - 1) lk a 0 (Nat.le_refl 0) (Nat.zero_le a))
  fun d dk a => match Nat.lt_or_ge d (k - 1) with
  | .inr ge => (congrArg (fun e => rules e t a) (Nat.le_antisymm (Nat.le_of_lt_succ
      (Nat.lt_of_lt_of_le dk (Nat.le_of_eq last.symm))) ge)).trans (lastNone a)
  | .inl lt =>
    have through : ∀ b, pass rules t (d + 1) (k - (d + 1)) b = 0 := fun b =>
      pass_through leaves lastNone (k - (d + 1)) (d + 1) b lt
        (Nat.lt_of_lt_of_le lk (Nat.le_of_eq (Becoming.add_sub_of_le (Nat.succ_le_of_lt dk)).symm))
    leaves_floor (C := later G rules k d c m j t) (Nat.zero_le _) (leaves d t a)
      (perfect.2 t j here d dk a 0 (Nat.le_refl 0) (Nat.zero_le a))
      (by
        show stepCoupling c m (pass rules t (d + 1) (k - (d + 1)) _) +
            drawn G rules k d c m j (t + 1) (G t (pass rules t (d + 1) (k - (d + 1)) _)) =
          stepCoupling c m (pass rules t (d + 1) (k - (d + 1)) 0) +
            drawn G rules k d c m j (t + 1) (G t (pass rules t (d + 1) (k - (d + 1)) 0))
        rw [through, through])

/-- **Below the need, a coupling a step moves nothing.** With at least two drawers in turn and no
floor, where the coupling `c` added to each drawer's worth for each step at which what all leave meets the
need `m` is below the need, every coupled perfect profile over `N` steps has every drawer leave
nothing at every step before the horizon, from every amount, whatever the law `G` of what stands
next: as without the coupling (`InTurn.perfect_at_floors`). -/
theorem drains_below (two : 1 < k) (pos : 0 < m) (below : c < m)
    (perfect : Perfect G (fun _ _ _ => 0) rules k c m N) :
    ∀ t, t < N → AllFollow rules k (fun _ => 0) t :=
  have main : ∀ i t, t + i = N → ∀ s, t ≤ s → s < N → AllFollow rules k (fun _ => 0) s :=
    fun i => Nat.rec (motive := fun i => ∀ t, t + i = N → ∀ s, t ≤ s → s < N →
        AllFollow rules k (fun _ => 0) s)
      (fun _ at_ s le lt => absurd (Nat.lt_of_lt_of_le lt (Nat.le_trans (Nat.le_of_eq at_.symm) le))
        (Nat.lt_irrefl s))
      (fun i ih t at_ s le lt =>
        have later_ := ih (t + 1) ((Nat.add_right_comm t 1 i).trans at_)
        match Nat.lt_or_ge t s with
        | .inl ts => later_ s ts lt
        | .inr st => Nat.le_antisymm st le ▸ drains_at two pos below perfect at_ later_)
      i
  fun t lt => main N 0 (Nat.zero_add N) t (Nat.zero_le t) lt

/-- **At or below the need, drawing everything is perfect.** With at least two drawers in turn and
no floor, where `c ≤ m` and the need is positive, the profile in which every drawer leaves nothing
is coupled perfect over every horizon. -/
theorem drain_perfect (two : 1 < k) (pos : 0 < m) (within : c ≤ m) :
    Perfect G (fun _ _ _ => 0) (fun _ _ _ => 0) k c m N :=
  have last := last_drawer two
  have lk : k - 1 < k := Nat.lt_of_lt_of_le (Nat.lt_succ_self (k - 1)) (Nat.le_of_eq last)
  have lpos : 0 < k - 1 := SupportGated.sub_pos_of_lt two
  ⟨fun _ _ a => ⟨Nat.le_refl 0, Nat.zero_le a⟩, fun t j _ d dk a b _ ba =>
    match Nat.lt_or_ge d (k - 1) with
    | .inl lt => by
      have through : ∀ b', pass (fun _ _ _ => 0) t (d + 1) (k - (d + 1)) b' = 0 := fun b' =>
        pass_through (fun _ _ a => Nat.zero_le a) (u := k - 1) (fun _ => rfl) (k - (d + 1)) (d + 1) b' lt
          (Nat.lt_of_lt_of_le lk (Nat.le_of_eq (Becoming.add_sub_of_le (Nat.succ_le_of_lt dk)).symm))
      show a - b + (stepCoupling c m (pass (fun _ _ _ => 0) t (d + 1) (k - (d + 1)) b) +
          drawn G (fun _ _ _ => 0) k d c m j (t + 1) (G t (pass (fun _ _ _ => 0) t (d + 1) (k - (d + 1)) b))) ≤
        a - 0 + (stepCoupling c m (pass (fun _ _ _ => 0) t (d + 1) (k - (d + 1)) 0) +
          drawn G (fun _ _ _ => 0) k d c m j (t + 1) (G t (pass (fun _ _ _ => 0) t (d + 1) (k - (d + 1)) 0)))
      rw [through, through, Nat.sub_zero]
      exact Nat.add_le_add_right (Nat.sub_le a b) _
    | .inr ge => by
      have isLast : d = k - 1 := Nat.le_antisymm (Nat.le_of_lt_succ
        (Nat.lt_of_lt_of_le dk (Nat.le_of_eq last.symm))) ge
      subst isLast
      show a - b + (stepCoupling c m (pass (fun _ _ _ => 0) t (k - 1 + 1) (k - (k - 1 + 1)) b) +
          drawn G (fun _ _ _ => 0) k (k - 1) c m j (t + 1)
            (G t (pass (fun _ _ _ => 0) t (k - 1 + 1) (k - (k - 1 + 1)) b))) ≤
        a - 0 + (stepCoupling c m (pass (fun _ _ _ => 0) t (k - 1 + 1) (k - (k - 1 + 1)) 0) +
          drawn G (fun _ _ _ => 0) k (k - 1) c m j (t + 1)
            (G t (pass (fun _ _ _ => 0) t (k - 1 + 1) (k - (k - 1 + 1)) 0)))
      rw [pass_after_last last b, pass_after_last last 0,
        drawn_drained pos lpos lk j (t + 1) (fun _ _ _ _ _ _ => rfl),
        drawn_drained pos lpos lk j (t + 1) (fun _ _ _ _ _ _ => rfl), stepCoupling_of_lt pos, Nat.sub_zero,
        Nat.add_zero, Nat.add_zero]
      match Nat.lt_or_ge b m with
      | .inl bm => rw [stepCoupling_of_lt bm, Nat.add_zero]; exact Nat.sub_le a b
      | .inr mb =>
        rw [stepCoupling_of_le mb]
        exact Nat.le_trans (Nat.add_le_add_left (Nat.le_trans within mb) _)
          (Nat.le_of_eq (Naturals.sub_add_cancel ba))⟩


/-! ### Above the need, under the gate

The gate: below the need what stands next is below it (`gate`); at or above the need what stands
next meets it (`holds`); what stands next from nothing, with the need, is at most what stands next
from the need (`regrows`). -/

section Gate

variable (gate : ∀ t x, x < m → G t x < m) (holds : ∀ t x, m ≤ x → m ≤ G t x)
  (regrows : ∀ t, G t 0 + m ≤ G t m)

include gate holds in
/-- **Where all keep the need, a drawer after the first has `c` added for each step and draws nothing.**
Under the gate, where every drawer leaves `keep m` at every step from `t` over `j` steps, drawer `d`,
not the first, gains there `c` for each step from a level at or above the need, and nothing from a
level below it. -/
theorem drawn_kept_late (pos : 0 < m) {d : Nat} (first : 0 < d) (dk : d < k) :
    ∀ j t, (∀ s, t ≤ s → s < t + j → AllFollow rules k (keep m) s) → ∀ z,
      drawn G rules k d c m j t z = stepCoupling (c * j) m z
  | 0, _, _, z => match Nat.lt_or_ge z m with
    | .inl lt => (stepCoupling_of_lt lt).symm
    | .inr ge => (stepCoupling_of_le ge).symm
  | j + 1, t, all, z => by
    have now := all t (Nat.le_refl t) (Nat.lt_of_lt_of_le (Nat.lt_succ_self t)
      (Nat.succ_le_succ (Nat.le_add_right t j)))
    show pass rules t 0 d z - rules d t (pass rules t 0 d z) + stepCoupling c m (pass rules t 0 k z) +
      drawn G rules k d c m j (t + 1) (G t (pass rules t 0 k z)) = stepCoupling (c * (j + 1)) m z
    rw [given_all (keep_keep m) first dk now z, now d dk (keep m z), keep_keep, Nat.sub_self,
      Nat.zero_add, left_all (keep_keep m) (Nat.lt_trans first dk) now z,
      drawn_kept_late pos first dk j (t + 1) (fun s le lt => all s (Nat.le_of_succ_le le)
        (Nat.lt_of_lt_of_le lt (Nat.le_of_eq (Nat.add_right_comm t 1 j)))) _]
    match Nat.lt_or_ge z m with
    | .inl lt =>
      rw [keep_of_lt lt, stepCoupling_of_lt pos, stepCoupling_of_lt (gate t 0 pos), stepCoupling_of_lt lt]
    | .inr ge =>
      rw [keep_of_le ge, stepCoupling_of_le (Nat.le_refl m), stepCoupling_of_le (holds t m (Nat.le_refl m)),
        stepCoupling_of_le ge, Nat.mul_succ, Nat.add_comm c (c * j)]

include gate holds regrows in
/-- **Where all keep the need, the first drawer draws more from the need than from below it.**
Under the gate, where every drawer leaves `keep m` at every step from `t` over `j` steps, the first
drawer gains from a level `z` at or above the need at least what it gains from a level below the
need that, with the need, is at most `z`. -/
theorem drawn_kept_first (pos : 0 < m) (one : 0 < k) :
    ∀ j t, (∀ s, t ≤ s → s < t + j → AllFollow rules k (keep m) s) → ∀ z z', m ≤ z → z' < m →
      z' + m ≤ z → drawn G rules k 0 c m j t z' ≤ drawn G rules k 0 c m j t z
  | 0, _, _, _, _, _, _, _ => Nat.le_refl 0
  | j + 1, t, all, z, z', mz, zm, within => by
    have now := all t (Nat.le_refl t) (Nat.lt_of_lt_of_le (Nat.lt_succ_self t)
      (Nat.succ_le_succ (Nat.le_add_right t j)))
    show z' - rules 0 t z' + stepCoupling c m (pass rules t 0 k z') +
        drawn G rules k 0 c m j (t + 1) (G t (pass rules t 0 k z')) ≤
      z - rules 0 t z + stepCoupling c m (pass rules t 0 k z) +
        drawn G rules k 0 c m j (t + 1) (G t (pass rules t 0 k z))
    rw [now 0 one z', now 0 one z, left_all (keep_keep m) one now z',
      left_all (keep_keep m) one now z, keep_of_lt zm, keep_of_le mz, stepCoupling_of_lt pos,
      stepCoupling_of_le (Nat.le_refl m), Nat.sub_zero, Nat.add_zero]
    exact Nat.add_le_add
      (Nat.le_trans (Naturals.le_sub_of_add_le (Nat.le_trans (Nat.le_of_eq (Nat.add_comm m z')) within))
        (Nat.le_add_right _ c))
      (drawn_kept_first pos one j (t + 1) (fun s le lt => all s (Nat.le_of_succ_le le)
        (Nat.lt_of_lt_of_le lt (Nat.le_of_eq (Nat.add_right_comm t 1 j)))) _ _
        (holds t m (Nat.le_refl m)) (gate t 0 pos) (regrows t))

include gate holds in
/-- **What a drawer after the first gains by leaving, where the rest keep the need.** Under the
gate, where the drawers after `d` keep the need at step `t` and every drawer keeps it at every step
after `t` over `j` steps, what drawer `d`, not the first, gains later by leaving `b` is
`c (j + 1)` where `b` meets the need and nothing where it does not. -/
theorem later_kept_late (pos : 0 < m) {t j d : Nat} (first : 0 < d) (dk : d < k)
    (after : ∀ e, d < e → e < k → ∀ a, rules e t a = keep m a)
    (future : ∀ s, t + 1 ≤ s → s < t + 1 + j → AllFollow rules k (keep m) s) (b : Nat) :
    later G rules k d c m j t b = stepCoupling (c + c * j) m b := by
  show stepCoupling c m (pass rules t (d + 1) (k - (d + 1)) b) +
    drawn G rules k d c m j (t + 1) (G t (pass rules t (d + 1) (k - (d + 1)) b)) = _
  rw [drawn_kept_late gate holds pos first dk j (t + 1) future]
  have fits : (m ≤ b → m ≤ pass rules t (d + 1) (k - (d + 1)) b) ∧
      (b < m → pass rules t (d + 1) (k - (d + 1)) b < m) :=
    match pass_after (keep_keep m) dk after b with
    | .inl same => ⟨fun le => Nat.le_trans le (Nat.le_of_eq same.symm),
        fun lt => Nat.lt_of_le_of_lt (Nat.le_of_eq same) lt⟩
    | .inr kept => ⟨fun le => Nat.le_trans (Nat.le_of_eq (keep_of_le le).symm) (Nat.le_of_eq kept.symm),
        fun lt => Nat.lt_of_le_of_lt (Nat.le_of_eq (kept.trans (keep_of_lt lt))) pos⟩
  match Nat.lt_or_ge b m with
  | .inl lt => rw [stepCoupling_of_lt (fits.2 lt), stepCoupling_of_lt (gate t _ (fits.2 lt)), stepCoupling_of_lt lt]
  | .inr ge => rw [stepCoupling_of_le (fits.1 ge), stepCoupling_of_le (holds t _ (fits.1 ge)), stepCoupling_of_le ge]

/-- **What the first drawer gains by leaving, where the rest keep the need.** With at least two
drawers, where the drawers after the first keep the need at step `t` and every drawer keeps it at
every step after `t` over `j` steps, what the first drawer gains later by leaving `b` at least the
need is `c` with what it gains from the level standing next from the need, and by leaving less,
what it gains from the level standing next from nothing. -/
theorem later_kept_first (two : 1 < k) {t j : Nat}
    (after : ∀ e, 0 < e → e < k → ∀ a, rules e t a = keep m a) (b : Nat) :
    later G rules k 0 c m j t b = (if m ≤ b then c + drawn G rules k 0 c m j (t + 1) (G t m)
      else drawn G rules k 0 c m j (t + 1) (G t 0)) := by
  have kept : pass rules t 1 (k - 1) b = keep m b :=
    pass_all (keep_keep m) (k - 1) 1 (SupportGated.sub_pos_of_lt two)
      (fun i le lt => after i le (Nat.lt_of_lt_of_le lt
        (Nat.le_of_eq (Becoming.add_sub_of_le (Nat.le_of_lt two))))) b
  show stepCoupling c m (pass rules t (0 + 1) (k - (0 + 1)) b) +
    drawn G rules k 0 c m j (t + 1) (G t (pass rules t (0 + 1) (k - (0 + 1)) b)) = _
  rw [Nat.zero_add, kept]
  match Nat.lt_or_ge b m with
  | .inl lt =>
    rw [keep_of_lt lt, if_neg (Nat.not_le_of_gt lt)]
    match Nat.eq_zero_or_pos m with
    | .inl zero => exact absurd (Nat.lt_of_lt_of_le lt (Nat.le_of_eq zero)) (Nat.not_lt_zero b)
    | .inr pos => rw [stepCoupling_of_lt pos, Nat.zero_add]
  | .inr ge => rw [keep_of_le ge, if_pos ge, stepCoupling_of_le (Nat.le_refl m)]

include gate holds regrows in
/-- **Above the need, at one step.** Under the gate, in a coupled perfect profile with at least two
drawers and no floor, where `m < c` and every drawer keeps the need at every step after `t`, every
drawer keeps the need at `t`: it leaves exactly the need of an amount at least the need, and
nothing of a smaller one. -/
theorem kept_at (two : 1 < k) (pos : 0 < m) (above : m < c)
    (perfect : Perfect G (fun _ _ _ => 0) rules k c m N) {t j : Nat} (here : t + j + 1 = N)
    (after : ∀ s, t + 1 ≤ s → s < N → AllFollow rules k (keep m) s) :
    AllFollow rules k (keep m) t :=
  have one : 0 < k := Nat.lt_trans Nat.zero_lt_one two
  have future : ∀ s, t + 1 ≤ s → s < t + 1 + j → AllFollow rules k (keep m) s :=
    fun s le lt => after s le (Nat.lt_of_lt_of_le lt
      (Nat.le_of_eq ((Nat.add_right_comm t 1 j).trans here)))
  have best : ∀ d, d < k → ∀ a b, b ≤ a →
      a - b + later G rules k d c m j t b ≤ a - rules d t a + later G rules k d c m j t (rules d t a) :=
    fun d dk a b ba => perfect.2 t j here d dk a b (Nat.zero_le b) ba
  have step : ∀ d, d < k → (∀ e, d < e → e < k → ∀ a, rules e t a = keep m a) →
      ∀ a, rules d t a = keep m a := fun d dk after' a =>
    match Nat.eq_zero_or_pos d with
    | .inr first =>
      leaves_need (L := later G rules k d c m j t) (V := c + c * j) (W := 0) pos
        (fun b le => (later_kept_late gate holds pos first dk after' future b).trans (stepCoupling_of_le le))
        (fun b lt => (later_kept_late gate holds pos first dk after' future b).trans (stepCoupling_of_lt lt))
        (Nat.lt_of_le_of_lt (Nat.le_of_eq (Nat.zero_add m))
          (Nat.lt_of_lt_of_le above (Nat.le_add_right c _)))
        ((perfect.1 d t a).2) (best d dk a)
    | .inl zero => by
      subst zero
      exact leaves_need (L := later G rules k 0 c m j t)
        (V := c + drawn G rules k 0 c m j (t + 1) (G t m))
        (W := drawn G rules k 0 c m j (t + 1) (G t 0)) pos
        (fun b le => (later_kept_first two after' b).trans (if_pos le))
        (fun b lt => (later_kept_first two after' b).trans (if_neg (Nat.not_le_of_gt lt)))
        (Nat.lt_of_lt_of_le (Nat.add_lt_add_left above _) (Nat.le_trans (Nat.le_of_eq (Nat.add_comm _ _))
          (Nat.add_le_add_left (drawn_kept_first gate holds regrows pos one j (t + 1) future _ _
            (holds t m (Nat.le_refl m)) (gate t 0 pos) (regrows t)) c)))
        ((perfect.1 0 t a).2) (best 0 one a)
  fun d dk a => down (P := fun d => ∀ a, rules d t a = keep m a) (k := k) step k d
    (Nat.le_add_left k d) dk a

include gate holds regrows in
/-- **Above the need, every perfect profile keeps exactly the need.** Under the gate, with at least
two drawers in turn and no floor, where the coupling `c` added to each drawer's worth for each step at which
what all leave meets the need `m` exceeds the need, every coupled perfect profile over `N` steps has
every drawer, at every step before the horizon, leave exactly the need of an amount at least the
need and nothing of a smaller one, whatever the renewal above the need and the horizon. -/
theorem kept_above (two : 1 < k) (pos : 0 < m) (above : m < c)
    (perfect : Perfect G (fun _ _ _ => 0) rules k c m N) :
    ∀ t, t < N → AllFollow rules k (keep m) t :=
  have main : ∀ i t, t + i = N → ∀ s, t ≤ s → s < N → AllFollow rules k (keep m) s :=
    fun i => Nat.rec (motive := fun i => ∀ t, t + i = N → ∀ s, t ≤ s → s < N →
        AllFollow rules k (keep m) s)
      (fun _ at_ s le lt => absurd (Nat.lt_of_lt_of_le lt (Nat.le_trans (Nat.le_of_eq at_.symm) le))
        (Nat.lt_irrefl s))
      (fun i ih t at_ s le lt =>
        have later_ := ih (t + 1) ((Nat.add_right_comm t 1 i).trans at_)
        match Nat.lt_or_ge t s with
        | .inl ts => later_ s ts lt
        | .inr st => Nat.le_antisymm st le ▸
            kept_at gate holds regrows two pos above perfect at_ later_)
      i
  fun t lt => main N 0 (Nat.zero_add N) t (Nat.zero_le t) lt

include gate holds regrows in
/-- **At or above the need, keeping it is perfect.** Under the gate, with at least two drawers in
turn and no floor, where `m ≤ c` and the need is positive, the profile in which every drawer leaves
`keep m` of what it is given is coupled perfect over every horizon. -/
theorem keeping_perfect (two : 1 < k) (pos : 0 < m) (within : m ≤ c) :
    Perfect G (fun _ _ _ => 0) (fun _ _ a => keep m a) k c m N :=
  have one : 0 < k := Nat.lt_trans Nat.zero_lt_one two
  ⟨fun _ _ a => ⟨Nat.zero_le _, keep_le m a⟩, fun t j _ d dk a b _ ba =>
    have future : ∀ s, t + 1 ≤ s → s < t + 1 + j →
        AllFollow (fun _ _ a => keep m a) k (keep m) s := fun _ _ _ _ _ _ => rfl
    have after' : ∀ e, d < e → e < k → ∀ a, keep m a = keep m a := fun _ _ _ _ => rfl
    match Nat.eq_zero_or_pos d with
    | .inr first =>
      need_best (L := later G (fun _ _ a => keep m a) k d c m j t) (V := c + c * j) (W := 0) pos
        (fun b le => (later_kept_late (rules := fun _ _ a => keep m a) (t := t) (j := j) gate holds pos first dk
          after' future b).trans (stepCoupling_of_le le))
        (fun b lt => (later_kept_late (rules := fun _ _ a => keep m a) (t := t) (j := j) gate holds pos first dk
          after' future b).trans (stepCoupling_of_lt lt))
        (Nat.le_trans (Nat.le_of_eq (Nat.zero_add m)) (Nat.le_trans within (Nat.le_add_right c _)))
        b ba
    | .inl zero => by
      subst zero
      exact need_best (L := later G (fun _ _ a => keep m a) k 0 c m j t)
        (V := c + drawn G (fun _ _ a => keep m a) k 0 c m j (t + 1) (G t m))
        (W := drawn G (fun _ _ a => keep m a) k 0 c m j (t + 1) (G t 0)) pos
        (fun b le => (later_kept_first (rules := fun _ _ a => keep m a) (t := t) (j := j) two
          (fun _ _ _ _ => rfl) b).trans (if_pos le))
        (fun b lt => (later_kept_first (rules := fun _ _ a => keep m a) (t := t) (j := j) two
          (fun _ _ _ _ => rfl) b).trans (if_neg (Nat.not_le_of_gt lt)))
        (Nat.le_trans (Nat.add_le_add_left within _) (Nat.le_trans (Nat.le_of_eq (Nat.add_comm _ _))
          (Nat.add_le_add_left (drawn_kept_first (rules := fun _ _ a => keep m a) gate holds regrows pos one
            j (t + 1) future _ _ (holds t m (Nat.le_refl m)) (gate t 0 pos) (regrows t)) c)))
        b ba⟩

include holds in
/-- **Kept from a start at or above the need.** Where there is at least one drawer, every drawer
follows `keep m` at every step before the horizon and at or above the need what stands next meets
it, from a start meeting the need
the level meets it at every step to the horizon, and what the drawers leave at each step before it
is exactly the need. -/
theorem kept_levels (one : 0 < k) {s : Nat} (start : m ≤ s)
    (all : ∀ t, t < N → AllFollow rules k (keep m) t) :
    ∀ t, t ≤ N → m ≤ levels G rules k s t ∧ (t < N → pass rules t 0 k (levels G rules k s t) = m)
  | 0, _ => ⟨start, fun lt => (left_all (keep_keep m) one (all 0 lt) s).trans (keep_of_le start)⟩
  | t + 1, le =>
    have before := (kept_levels one start all t (Nat.le_of_succ_le le)).2 (Nat.lt_of_succ_le le)
    have meets : m ≤ levels G rules k s (t + 1) :=
      Nat.le_trans (holds t m (Nat.le_refl m)) (Nat.le_of_eq (congrArg (G t) before).symm)
    ⟨meets, fun lt => (left_all (keep_keep m) one (all (t + 1) lt) _).trans (keep_of_le meets)⟩

end Gate


/-! ### One drawer keeps where several in turn do not -/

/-- **A gated renewal**: below the need what is left stands as it is; at or above the need it
renews by `q`. -/
def gatedRenewal (m q : Nat) (_ x : Nat) : Nat := if m ≤ x then x + q else x

/-- **One drawer keeps the need at the first of two steps.** On a gated renewal, with one drawer,
where `c < m` and `0 < c + q`, every coupled perfect profile over two steps leaves nothing at the
last step and, of an amount at least the need, at least the need at the first: keeping it there
brings the coupling and the renewal, which the drawer itself draws at the last step. -/
theorem one_keeps_first {q : Nat} (pos : 0 < m) (below : c < m) (keepingGains : 0 < c + q)
    (perfect : Perfect (gatedRenewal m q) (fun _ _ _ => 0) rules 1 c m 2) :
    (∀ a, rules 0 1 a = 0) ∧ ∀ a, m ≤ a → m ≤ rules 0 0 a :=
  have last : ∀ a, rules 0 1 a = 0 := fun a =>
    leaves_nothing (L := later (gatedRenewal m q) rules 1 0 c m 0 1) (W := 0) below pos
      (fun b => by
        show stepCoupling c m b + 0 = 0 + stepCoupling c m b
        rw [Nat.add_zero, Nat.zero_add])
      ((perfect.1 0 1 a).2) (perfect.2 1 0 rfl 0 Nat.zero_lt_one a 0 (Nat.le_refl 0) (Nat.zero_le a))
  have worth : ∀ b, later (gatedRenewal m q) rules 1 0 c m 1 0 b = stepCoupling c m b + gatedRenewal m q 0 b :=
    fun b => by
      show stepCoupling c m b + (gatedRenewal m q 0 b - rules 0 1 (gatedRenewal m q 0 b) +
        stepCoupling c m (rules 0 1 (gatedRenewal m q 0 b)) + 0) = _
      rw [last, Nat.sub_zero, stepCoupling_of_lt pos, Nat.add_zero]
  ⟨last, fun a ma =>
    have best := perfect.2 0 1 rfl 0 Nat.zero_lt_one a m (Nat.zero_le m) ma
    match Nat.lt_or_ge (rules 0 0 a) m with
    | .inr ge => ge
    | .inl lt => by
      rw [worth, worth, stepCoupling_of_le (Nat.le_refl m), stepCoupling_of_lt lt,
        show gatedRenewal m q 0 m = m + q from if_pos (Nat.le_refl m),
        show gatedRenewal m q 0 (rules 0 0 a) = rules 0 0 a from if_neg (Nat.not_le_of_gt lt),
        Nat.zero_add, Naturals.sub_add_cancel ((perfect.1 0 0 a).2), Nat.add_left_comm c m q,
        ← Nat.add_assoc, Naturals.sub_add_cancel ma] at best
      exact absurd best (Nat.not_le_of_gt (Nat.lt_add_of_pos_right keepingGains))⟩

/-- **One keeps, several in turn drain, at the same coupling.** On a gated renewal, where
`c < m` and `0 < c + q`, over two steps: every coupled perfect profile of one drawer leaves at
least the need of an amount at least the need at the first step, and every coupled perfect profile
of two or more drawers in turn, without floors, leaves nothing at every step. -/
theorem one_keeps_several_drain {q : Nat} (pos : 0 < m) (below : c < m) (keepingGains : 0 < c + q) :
    (∀ rules : Nat → Nat → Nat → Nat, Perfect (gatedRenewal m q) (fun _ _ _ => 0) rules 1 c m 2 →
      ∀ a, m ≤ a → m ≤ rules 0 0 a) ∧
    (∀ (k' : Nat) (rules : Nat → Nat → Nat → Nat), 1 < k' →
      Perfect (gatedRenewal m q) (fun _ _ _ => 0) rules k' c m 2 →
      ∀ t, t < 2 → ∀ d, d < k' → ∀ a, rules d t a = 0) :=
  ⟨fun _ perfect => (one_keeps_first pos below keepingGains perfect).2,
   fun _ _ two perfect => drains_below two pos below perfect⟩

/-- What one drawer gains at the first of two steps on a gated renewal, drawing everything at the
last: leaving `b` of `a` brings `a` with `c + q` where `b` meets the need. -/
theorem one_first_worth {q a b : Nat} (ba : b ≤ a) :
    a - b + (stepCoupling c m b + gatedRenewal m q 0 b) = a + stepCoupling (c + q) m b :=
  match Nat.lt_or_ge b m with
  | .inl lt => by
    rw [stepCoupling_of_lt lt, stepCoupling_of_lt lt, show gatedRenewal m q 0 b = b from if_neg (Nat.not_le_of_gt lt),
      Nat.zero_add, Naturals.sub_add_cancel ba, Nat.add_zero]
  | .inr ge => by
    rw [stepCoupling_of_le ge, stepCoupling_of_le ge, show gatedRenewal m q 0 b = b + q from if_pos ge,
      Nat.add_left_comm c b q, ← Nat.add_assoc, Naturals.sub_add_cancel ba]

/-- **The one drawer's profile is perfect.** On a gated renewal, with one drawer, where `c ≤ m`,
keeping the need at the first of two steps and drawing everything at the last is coupled perfect:
`one_keeps_first` holds of a profile that exists. -/
theorem one_perfect {q : Nat} (pos : 0 < m) (within : c ≤ m) :
    Perfect (gatedRenewal m q) (fun _ _ _ => 0) (fun _ t a => if t = 0 then keep m a else 0) 1 c m 2 :=
  ⟨fun _ t a => match Nat.decEq t 0 with
    | .isTrue zero => ⟨Nat.zero_le _, Nat.le_trans (Nat.le_of_eq (if_pos zero)) (keep_le m a)⟩
    | .isFalse other => ⟨Nat.zero_le _, Nat.le_trans (Nat.le_of_eq (if_neg other)) (Nat.zero_le a)⟩,
   fun t j at_ d dk a b _ ba => by
    have isZero : d = 0 := Nat.le_antisymm (Nat.le_of_lt_succ dk) (Nat.zero_le d)
    subst isZero
    match j, at_ with
    | 0, at_ =>
      have one : t = 1 := add_right_cancel (1) at_
      subst one
      show a - b + (stepCoupling c m b + 0) ≤ a - 0 + (stepCoupling c m 0 + 0)
      rw [Nat.add_zero, Nat.add_zero, stepCoupling_of_lt pos, Nat.sub_zero, Nat.add_zero]
      match Nat.lt_or_ge b m with
      | .inl bm => rw [stepCoupling_of_lt bm, Nat.add_zero]; exact Nat.sub_le a b
      | .inr mb =>
        rw [stepCoupling_of_le mb]
        exact Nat.le_trans (Nat.add_le_add_left (Nat.le_trans within mb) _)
          (Nat.le_of_eq (Naturals.sub_add_cancel ba))
    | 1, at_ =>
      have zero : t = 0 := add_right_cancel (2) at_
      subst zero
      have worth : ∀ b', later (gatedRenewal m q) (fun _ t a => if t = 0 then keep m a else 0) 1 0 c m 1 0 b' =
          stepCoupling c m b' + gatedRenewal m q 0 b' := fun b' => by
        show stepCoupling c m b' + (gatedRenewal m q 0 b' - 0 + stepCoupling c m 0 + 0) = _
        rw [Nat.sub_zero, stepCoupling_of_lt pos, Nat.add_zero]
      show a - b + later (gatedRenewal m q) (fun _ t a => if t = 0 then keep m a else 0) 1 0 c m 1 0 b ≤
        a - keep m a + later (gatedRenewal m q) (fun _ t a => if t = 0 then keep m a else 0) 1 0 c m 1 0 (keep m a)
      rw [worth, worth, one_first_worth ba, one_first_worth (keep_le m a)]
      apply Nat.add_le_add_left
      match Nat.lt_or_ge b m with
      | .inl bm => rw [stepCoupling_of_lt bm]; exact Nat.zero_le _
      | .inr mb =>
        rw [stepCoupling_of_le mb, keep_of_le (Nat.le_trans mb ba), stepCoupling_of_le (Nat.le_refl m)]
        exact Nat.le_refl _
    | j + 2, at_ =>
      exact absurd (Nat.le_trans (Nat.le_add_left (j + 2 + 1) t) (Nat.le_of_eq at_))
        (Nat.not_le_of_gt (Nat.succ_lt_succ (Nat.succ_lt_succ (Nat.succ_pos j))))⟩

/-- **The gate holds of the gated renewal.** -/
theorem gatedRenewal_gate {q : Nat} : ∀ t x, x < m → gatedRenewal m q t x < m := fun _ _ lt =>
  Nat.lt_of_le_of_lt (Nat.le_of_eq (if_neg (Nat.not_le_of_gt lt))) lt

theorem gatedRenewal_holds {q : Nat} : ∀ t x, m ≤ x → m ≤ gatedRenewal m q t x := fun _ x le =>
  Nat.le_trans (Nat.le_trans le (Nat.le_add_right x q)) (Nat.le_of_eq (if_pos le).symm)

theorem gatedRenewal_regrows {q : Nat} (pos : 0 < m) : ∀ t, gatedRenewal m q t 0 + m ≤ gatedRenewal m q t m :=
  fun t => by
    rw [show gatedRenewal m q t 0 = 0 from if_neg (Nat.not_le_of_gt pos),
      show gatedRenewal m q t m = m + q from if_pos (Nat.le_refl m), Nat.zero_add]
    exact Nat.le_add_right m q

/-- **The threshold is the need, whatever the renewal.** On the gated renewal with any `q`, with at
least two drawers in turn and no floor, over every horizon: where `c < m` every coupled perfect
profile draws everything at every step; where `c ≤ m` drawing everything is perfect; where `m ≤ c`
keeping the need is perfect; where `m < c` every coupled perfect profile keeps exactly the need, and
from a start at or above the need the need is met at every step. At `c = m` both are perfect. -/
theorem gated_threshold {q : Nat} (two : 1 < k) (pos : 0 < m) :
    (c < m → ∀ rules, Perfect (gatedRenewal m q) (fun _ _ _ => 0) rules k c m N →
      ∀ t, t < N → AllFollow rules k (fun _ => 0) t) ∧
    (c ≤ m → Perfect (gatedRenewal m q) (fun _ _ _ => 0) (fun _ _ _ => 0) k c m N) ∧
    (m ≤ c → Perfect (gatedRenewal m q) (fun _ _ _ => 0) (fun _ _ a => keep m a) k c m N) ∧
    (m < c → ∀ rules, Perfect (gatedRenewal m q) (fun _ _ _ => 0) rules k c m N →
      (∀ t, t < N → AllFollow rules k (keep m) t) ∧
      ∀ s, m ≤ s → ∀ t, t < N → pass rules t 0 k (levels (gatedRenewal m q) rules k s t) = m) :=
  ⟨fun below _ perfect => drains_below two pos below perfect,
   fun within => drain_perfect two pos within,
   fun within => keeping_perfect gatedRenewal_gate gatedRenewal_holds (gatedRenewal_regrows pos) two pos within,
   fun above _ perfect =>
    have all := kept_above gatedRenewal_gate gatedRenewal_holds (gatedRenewal_regrows pos) two pos above perfect
    ⟨all, fun _ start t lt => (kept_levels gatedRenewal_holds (Nat.lt_trans Nat.zero_lt_one two) start all t
      (Nat.le_of_lt lt)).2 lt⟩⟩

/-! ## Drawers at once, coupled -/

namespace AtOnce

/-- What all leave at step `t` from `z`, drawer `d` leaving `b` of its portion and the others as
`rules` says. -/
def leftWith (portion rules : Nat → Nat → Nat → Nat) (k d t z b : Nat) : Nat :=
  Optimum.AtOnce.sumTo (fun e => if e = d then b else rules e t (portion e t z)) k

/-- What drawer `d` draws over `j` steps from `t` at `z`, drawing at once, with `c` for each step
at which what all leave meets `m`. -/
def drawn (G : Nat → Nat → Nat) (portion rules : Nat → Nat → Nat → Nat) (k d c m : Nat) :
    Nat → Nat → Nat → Nat
  | 0, _, _ => 0
  | j + 1, t, z => (portion d t z - rules d t (portion d t z)) +
      stepCoupling c m (Optimum.AtOnce.pool portion rules k t z) +
      drawn G portion rules k d c m j (t + 1) (Optimum.AtOnce.next G portion rules k t z)

/-- What drawer `d` gains after leaving `b` of its portion at `t`: that step's coupling and what it
gains over the `j` steps after. -/
def later (G : Nat → Nat → Nat) (portion rules : Nat → Nat → Nat → Nat) (k d c m j t z b : Nat) :
    Nat :=
  stepCoupling c m (leftWith portion rules k d t z b) +
    drawn G portion rules k d c m j (t + 1) (G t (leftWith portion rules k d t z b))

/-- **A revision drawing at once, coupled**: as `Optimum.AtOnce.Revises`, with the coupling. -/
def Revises (G : Nat → Nat → Nat) (portion low rules rules' : Nat → Nat → Nat → Nat) (k c m N : Nat) :
    Prop :=
  (∀ d t a, low d t a ≤ rules' d t a ∧ rules' d t a ≤ a) ∧
  ∀ t j, t + j + 1 = N → ∀ d, d < k → ∀ z b, low d t (portion d t z) ≤ b → b ≤ portion d t z →
    portion d t z - b + later G portion rules k d c m j t z b ≤
      portion d t z - rules' d t (portion d t z) +
        later G portion rules k d c m j t z (rules' d t (portion d t z))

/-- **Perfect drawing at once, coupled.** -/
def Perfect (G : Nat → Nat → Nat) (portion low rules : Nat → Nat → Nat → Nat) (k c m N : Nat) : Prop :=
  Revises G portion low rules rules k c m N

variable {G : Nat → Nat → Nat} {portion : Nat → Nat → Nat → Nat} {k c m N : Nat}

/-- Under the drain, what all leave with drawer `d` leaving `b` is `b`. -/
theorem leftWith_drained {d t z b : Nat} (dk : d < k) :
    leftWith portion (fun _ _ _ => 0) k d t z b = b :=
  (Optimum.AtOnce.sumTo_set (f := fun _ => 0) dk).trans
    ((congrArg (· + b) (Optimum.AtOnce.sumTo_zero fun _ _ => ite_self 0)).trans (Nat.zero_add b))

/-- Under the drain, what all leave is nothing. -/
theorem pool_drained (t z : Nat) : Optimum.AtOnce.pool portion (fun _ _ _ => 0) k t z = 0 :=
  Optimum.AtOnce.sumTo_zeros k

/-- Under the drain, a step's draw is the portion, and no positive need is met. -/
theorem drawn_drained_step (pos : 0 < m) {d : Nat} (j t z : Nat) :
    drawn G portion (fun _ _ _ => 0) k d c m (j + 1) t z =
      portion d t z + drawn G portion (fun _ _ _ => 0) k d c m j (t + 1) (G t 0) := by
  show portion d t z - 0 + stepCoupling c m (Optimum.AtOnce.pool portion (fun _ _ _ => 0) k t z) +
    drawn G portion (fun _ _ _ => 0) k d c m j (t + 1) (G t (Optimum.AtOnce.pool portion (fun _ _ _ => 0) k t z)) = _
  rw [pool_drained, stepCoupling_of_lt pos, Nat.sub_zero, Nat.add_zero]

/-- **Without a pivotal drawer, drawing everything is perfect at every coupling rate.** Drawing at
once, where every portion lies below the need, so that no drawer alone can leave the need whatever
the others leave it, and no portion returns more than one for one on what its drawer alone leaves
(the premise of `Optimum.AtOnce.drain_perfect_iff`), the profile in which every drawer draws all of
its portion is coupled perfect over every horizon, for every `c`. -/
theorem unpivotal_drain_perfect (pos : 0 < m) (small : ∀ d, d < k → ∀ t z, portion d t z < m)
    (returns : ∀ d, d < k → ∀ t, t + 1 < N → ∀ z b, b ≤ portion d t z →
      portion d (t + 1) (G t b) ≤ portion d (t + 1) (G t 0) + b) :
    Perfect G portion (fun _ _ _ => 0) (fun _ _ _ => 0) k c m N :=
  ⟨fun _ _ a => ⟨Nat.le_refl 0, Nat.zero_le a⟩, fun t j at_ d dk z b _ le => by
    have unmet : ∀ b', b' ≤ portion d t z → stepCoupling c m b' = 0 := fun b' le' =>
      stepCoupling_of_lt (Nat.lt_of_le_of_lt le' (small d dk t z))
    show portion d t z - b + (stepCoupling c m (leftWith portion (fun _ _ _ => 0) k d t z b) +
        drawn G portion (fun _ _ _ => 0) k d c m j (t + 1) (G t (leftWith portion (fun _ _ _ => 0) k d t z b))) ≤
      portion d t z - 0 + (stepCoupling c m (leftWith portion (fun _ _ _ => 0) k d t z 0) +
        drawn G portion (fun _ _ _ => 0) k d c m j (t + 1) (G t (leftWith portion (fun _ _ _ => 0) k d t z 0)))
    rw [leftWith_drained dk, leftWith_drained dk, unmet b le, unmet 0 (Nat.zero_le _), Nat.zero_add,
      Nat.zero_add, Nat.sub_zero]
    match j, at_ with
    | 0, _ => exact Nat.add_le_add_right (Nat.sub_le _ b) 0
    | i + 1, at_ =>
      have lt : t + 1 < N := Nat.lt_of_lt_of_le
        (Nat.add_lt_add_left (Nat.succ_lt_succ (Nat.succ_pos i)) t) (Nat.le_of_eq at_)
      rw [drawn_drained_step pos, drawn_drained_step pos, ← Nat.add_assoc, ← Nat.add_assoc]
      exact Nat.add_le_add_right (Nat.le_trans
        (Nat.add_le_add_left (returns d dk t lt z b le) _)
        (Nat.le_of_eq (by rw [Nat.add_comm _ b, ← Nat.add_assoc, Naturals.sub_add_cancel le]))) _⟩

/-- Leaving `b` of `P` and gaining `x`, against leaving nothing and gaining `y`. -/
theorem cancel_left_sub {P b x y : Nat} (le : b ≤ P) (h : P - b + x ≤ P + y) : x ≤ y + b :=
  Naturals.le_of_add_le_add_left (k := P)
    (calc P + x = P - b + b + x := by rw [Naturals.sub_add_cancel le]
      _ = P - b + x + b := Nat.add_right_comm _ _ _
      _ ≤ P + y + b := Nat.add_le_add_right h b
      _ = P + (y + b) := Nat.add_assoc _ _ _)

theorem uncancel {P b x y : Nat} (le : b ≤ P) (h : x ≤ y + b) : P - b + x ≤ P + y :=
  Nat.le_trans (Nat.add_le_add_left h _) (Nat.le_of_eq (by
    rw [Nat.add_comm y b, ← Nat.add_assoc, Naturals.sub_add_cancel le]))

/-- **Drawing everything is perfect exactly where no drawer alone gains more than it leaves.**
Drawing at once, with a positive need, the profile in which every drawer draws all of its portion is
coupled perfect over `N` steps exactly where, for every drawer and every amount `b` of its portion
it alone might leave, the others drawing everything: at the last step, the coupling `b` brings is at
most `b`; at every earlier step, the coupling with its portion of what stands next from `b` is at
most its portion of what stands next from nothing, and `b`. With others drawing everything, a drawer
meets the need only by leaving all of it itself: the coupled form of `Optimum.AtOnce.drain_perfect_iff`. -/
theorem drain_perfect_iff (pos : 0 < m) :
    Perfect G portion (fun _ _ _ => 0) (fun _ _ _ => 0) k c m N ↔
      (∀ d, d < k → ∀ t, t + 1 = N → ∀ z b, b ≤ portion d t z → stepCoupling c m b ≤ b) ∧
      (∀ d, d < k → ∀ t, t + 1 < N → ∀ z b, b ≤ portion d t z →
        stepCoupling c m b + portion d (t + 1) (G t b) ≤ portion d (t + 1) (G t 0) + b) :=
  have unfold_ : ∀ d, d < k → ∀ t j z b,
      portion d t z - b + later G portion (fun _ _ _ => 0) k d c m j t z b =
        portion d t z - b + (stepCoupling c m b + drawn G portion (fun _ _ _ => 0) k d c m j (t + 1) (G t b)) :=
    fun d dk t j z b => by
      show portion d t z - b + (stepCoupling c m (leftWith portion (fun _ _ _ => 0) k d t z b) +
        drawn G portion (fun _ _ _ => 0) k d c m j (t + 1) (G t (leftWith portion (fun _ _ _ => 0) k d t z b))) = _
      rw [leftWith_drained dk]
  have best : Perfect G portion (fun _ _ _ => 0) (fun _ _ _ => 0) k c m N → ∀ t j, t + j + 1 = N →
      ∀ d, d < k → ∀ z b, b ≤ portion d t z →
        portion d t z - b + later G portion (fun _ _ _ => 0) k d c m j t z b ≤
          portion d t z - 0 + later G portion (fun _ _ _ => 0) k d c m j t z 0 :=
    fun perfect t j at_ d dk z b le => perfect.2 t j at_ d dk z b (Nat.zero_le b) le
  ⟨fun perfect =>
    ⟨fun d dk t at_ z b le => by
      have h := best perfect t 0 at_ d dk z b le
      rw [unfold_ d dk, unfold_ d dk] at h
      have h' : portion d t z - b + (stepCoupling c m b + 0) ≤ portion d t z - 0 + (stepCoupling c m 0 + 0) := h
      rw [stepCoupling_of_lt pos, Nat.sub_zero, Nat.add_zero (stepCoupling c m b)] at h'
      exact Nat.le_trans (cancel_left_sub le h') (Nat.le_of_eq (by rw [Nat.add_zero, Nat.zero_add])),
     fun d dk t lt z b le => by
      match AtOnce.steps_after lt with
      | ⟨i, at_⟩ =>
        have h := best perfect t (i + 1) at_ d dk z b le
        rw [unfold_ d dk, unfold_ d dk, drawn_drained_step pos, drawn_drained_step pos, stepCoupling_of_lt pos,
          Nat.sub_zero, Nat.zero_add, ← Nat.add_assoc (stepCoupling c m b), ← Nat.add_assoc (portion d t z - b),
          ← Nat.add_assoc (portion d t z)] at h
        exact cancel_left_sub le (le_of_add_le_add_right _ h)⟩,
   fun ⟨atLast, earlier⟩ => ⟨fun _ _ a => ⟨Nat.le_refl 0, Nat.zero_le a⟩, fun t j at_ d dk z b _ le => by
    show portion d t z - b + later G portion (fun _ _ _ => 0) k d c m j t z b ≤
      portion d t z - 0 + later G portion (fun _ _ _ => 0) k d c m j t z 0
    rw [unfold_ d dk, unfold_ d dk, stepCoupling_of_lt pos, Nat.sub_zero, Nat.zero_add]
    match j, at_ with
    | 0, at_ =>
      show portion d t z - b + (stepCoupling c m b + 0) ≤ portion d t z + 0
      rw [Nat.add_zero, Nat.add_zero]
      exact Nat.le_trans (uncancel (y := 0) le (Nat.le_trans (atLast d dk t at_ z b le)
        (Nat.le_of_eq (Nat.zero_add b).symm))) (Nat.le_of_eq (Nat.add_zero _))
    | i + 1, at_ =>
      have lt : t + 1 < N := Nat.lt_of_lt_of_le
        (Nat.add_lt_add_left (Nat.succ_lt_succ (Nat.succ_pos i)) t) (Nat.le_of_eq at_)
      rw [drawn_drained_step pos, drawn_drained_step pos, ← Nat.add_assoc (stepCoupling c m b),
        ← Nat.add_assoc (portion d t z - b), ← Nat.add_assoc (portion d t z)]
      exact Nat.add_le_add_right (uncancel le (earlier d dk t lt z b le)) _⟩⟩

/-- **Where what is left returns nothing, drawing everything is perfect exactly where the coupling is
at most the need or no portion reaches it.** Drawing at once, where no drawer's portion of what stands
next depends on what is left, the drain is coupled perfect over `N` steps exactly where, wherever a
drawer's portion at a step before the horizon reaches the need, `c ≤ m`. -/
theorem drain_perfect_iff_reach (pos : 0 < m)
    (none : ∀ d, d < k → ∀ t, t + 1 < N → ∀ b, portion d (t + 1) (G t b) = portion d (t + 1) (G t 0)) :
    Perfect G portion (fun _ _ _ => 0) (fun _ _ _ => 0) k c m N ↔
      ∀ d, d < k → ∀ t, t < N → ∀ z, m ≤ portion d t z → c ≤ m :=
  have metWithin : ∀ {b : Nat}, stepCoupling c m b ≤ b ↔ (m ≤ b → c ≤ b) := fun {b} =>
    match Nat.lt_or_ge b m with
    | .inl lt => ⟨fun _ le => absurd le (Nat.not_le_of_gt lt), fun _ =>
        Nat.le_trans (Nat.le_of_eq (stepCoupling_of_lt lt)) (Nat.zero_le b)⟩
    | .inr ge => ⟨fun h _ => Nat.le_trans (Nat.le_of_eq (stepCoupling_of_le ge).symm) h,
        fun h => Nat.le_trans (Nat.le_of_eq (stepCoupling_of_le ge)) (h ge)⟩
  have reduce : ∀ d, d < k → ∀ t, t + 1 < N → ∀ b,
      (stepCoupling c m b + portion d (t + 1) (G t b) ≤ portion d (t + 1) (G t 0) + b ↔ stepCoupling c m b ≤ b) :=
    fun d dk t lt b => by
      rw [none d dk t lt b, Nat.add_comm (stepCoupling c m b)]
      exact ⟨fun h => Naturals.le_of_add_le_add_left h, fun h => Nat.add_le_add_left h _⟩
  (drain_perfect_iff pos).trans
    ⟨fun ⟨atLast, earlier⟩ d dk t lt z reach =>
      have step : stepCoupling c m m ≤ m := match Nat.lt_or_ge (t + 1) N with
        | .inl lt' => (reduce d dk t lt' m).1 (earlier d dk t lt' z m reach)
        | .inr ge => atLast d dk t (Nat.le_antisymm (Nat.succ_le_of_lt lt) ge) z m reach
      Nat.le_trans (Nat.le_of_eq (stepCoupling_of_le (Nat.le_refl m)).symm) step,
     fun reach =>
      have each : ∀ d, d < k → ∀ t, t < N → ∀ z b, b ≤ portion d t z → stepCoupling c m b ≤ b :=
        fun d dk t lt z b le => metWithin.2 fun mb =>
          Nat.le_trans (reach d dk t lt z (Nat.le_trans mb le)) mb
      ⟨fun d dk t at_ z b le => each d dk t (Nat.lt_of_lt_of_le (Nat.lt_succ_self t) (Nat.le_of_eq at_)) z b le,
       fun d dk t lt z b le => (reduce d dk t lt b).2
         (each d dk t (Nat.lt_trans (Nat.lt_succ_self t) lt) z b le)⟩⟩

/-- **And the need is met at no step.** Under the drain no positive need is met. -/
theorem drained_unmet (pos : 0 < m) (t z : Nat) :
    stepCoupling c m (Optimum.AtOnce.pool portion (fun _ _ _ => 0) k t z) = 0 :=
  (congrArg (stepCoupling c m) (pool_drained t z)).trans (stepCoupling_of_lt pos)

/-! ### Two shores -/

namespace Shores

/-- At most `p` of `z`. -/
def upTo (p z : Nat) : Nat := if z ≤ p then z else p

theorem upTo_le (p z : Nat) : upTo p z ≤ p :=
  match Nat.lt_or_ge p z with
  | .inl lt => Nat.le_of_eq (if_neg (Nat.not_le_of_gt lt))
  | .inr ge => Nat.le_trans (Nat.le_of_eq (if_pos ge)) ge

theorem upTo_le_self (p z : Nat) : upTo p z ≤ z :=
  match Nat.lt_or_ge p z with
  | .inl lt => Nat.le_trans (Nat.le_of_eq (if_neg (Nat.not_le_of_gt lt))) (Nat.le_of_lt lt)
  | .inr ge => Nat.le_of_eq (if_pos ge)

theorem upTo_zero (p : Nat) : upTo p 0 = 0 := if_pos (Nat.zero_le p)

/-- **Two shores**: the first drawer reaches at most `p` of the level, the second at most `p` of
the rest. -/
def shore (p : Nat) (d _ z : Nat) : Nat := if d = 0 then upTo p z else upTo p (z - upTo p z)

theorem shore_le (p d t z : Nat) : shore p d t z ≤ p :=
  match Nat.decEq d 0 with
  | .isTrue zero => Nat.le_trans (Nat.le_of_eq (if_pos zero)) (upTo_le p z)
  | .isFalse other => Nat.le_trans (Nat.le_of_eq (if_neg other)) (upTo_le p _)

theorem shore_le_self (p d t z : Nat) : shore p d t z ≤ z :=
  match Nat.decEq d 0 with
  | .isTrue zero => Nat.le_trans (Nat.le_of_eq (if_pos zero)) (upTo_le_self p z)
  | .isFalse other => Nat.le_trans (Nat.le_of_eq (if_neg other))
      (Nat.le_trans (upTo_le_self p _) (Nat.sub_le z _))

theorem shore_zero (p d t : Nat) : shore p d t 0 = 0 :=
  match Nat.decEq d 0 with
  | .isTrue zero => (if_pos zero).trans (upTo_zero p)
  | .isFalse other => (if_neg other).trans
      ((congrArg (fun x => upTo p (0 - x)) (upTo_zero p)).trans (upTo_zero p))

/-- **Each shore below the need, the two together reaching it**: with `p < m`, and the level left
as it is, drawing everything is coupled perfect at every rate `c` and over every horizon, and the
need is met at no step; yet where both leave all they reach of `p + p`, what is left is `p + p`,
at least the need where `m ≤ p + p`. -/
theorem drain_perfect {p m : Nat} (pos : 0 < m) (below : p < m) (c N : Nat) :
    Perfect (fun _ x => x) (shore p) (fun _ _ _ => 0) (fun _ _ _ => 0) 2 c m N ∧
    (∀ t z, stepCoupling c m (Optimum.AtOnce.pool (shore p) (fun _ _ _ => 0) 2 t z) = 0) ∧
    ∀ t, Optimum.AtOnce.pool (shore p) (fun _ _ a => a) 2 t (p + p) = p + p :=
  ⟨unpivotal_drain_perfect pos (fun d _ t z => Nat.lt_of_le_of_lt (shore_le p d t z) below)
      (fun d _ t _ _ b _ => by
        show shore p d (t + 1) b ≤ shore p d (t + 1) 0 + b
        rw [shore_zero, Nat.zero_add]
        exact shore_le_self p d (t + 1) b),
   fun t z => drained_unmet pos t z,
   fun t => by
    have first : upTo p (p + p) = p :=
      match Nat.lt_or_ge p (p + p) with
      | .inl lt => if_neg (Nat.not_le_of_gt lt)
      | .inr ge => (if_pos ge).trans (Nat.le_antisymm ge (Nat.le_add_right p p))
    show 0 + shore p 0 t (p + p) + shore p 1 t (p + p) = p + p
    rw [Nat.zero_add, show shore p 0 t (p + p) = upTo p (p + p) from if_pos rfl,
      show shore p 1 t (p + p) = upTo p (p + p - upTo p (p + p)) from if_neg (by decide), first,
      Naturals.add_sub_cancel, show upTo p p = p from if_pos (Nat.le_refl p)]⟩

end Shores

end AtOnce

end Coupled

end Optimum

end Becoming
