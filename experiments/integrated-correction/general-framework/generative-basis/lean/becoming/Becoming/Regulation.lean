import Becoming.Continuation
import Becoming.Propagation
import Becoming.Change
import Becoming.Witnesses

/-!
# Regulation: a level held from both sides, and a level read late

A level at one condition is regulated towards `m` where the joint exchange at the condition opposes
its departure from `m` on both sides: it takes more than it gives above `m` and gives more than it
takes below (`Flow.Opposes`). The law of restoration (`Flow.restores`) has one side: where the
exchange gives more than it takes below `m`, the level reaches at least `m`. This module proves what
holds when both sides are regulated, what a bound on the exchange adds, what follows without the
bound, and what reading the level late does.

* **The bound is exactly no overshoot.** With balance across a step, the joint exchange departs
  from evenness by at most the level's gap to `m`, on each side (`Flow.WithinGap`), exactly where
  the next level lies between `m` and the present one (`Flow.withinGap_iff_between`, from
  `Regulation.within_iff_between`).
* **Two-sided regulation.** Within the gap and opposing, the gap to `m` does not rise
  (`Flow.gap_le_of_within`) and falls by at least one at every step where it is positive
  (`Flow.gap_falls`); over `n` steps it falls by `n` (`Flow.regulates_at`, `Flow.regulates`), and
  the level is `m` at every step from the one where its gap is used up (`Flow.settles_at`,
  `Flow.settles_from`, `Flow.settles`). Within the gap alone, the level never crosses `m`
  (`Flow.stays_between_at`). From below, with the bound, restoration reaches `m` exactly and stays
  there (`Flow.restores_exactly`).
* **Without the bound, regulation overshoots.** An opposing exchange is within the gap exactly
  where the next level does not cross `m` (`Flow.withinGap_iff_of_above`,
  `Flow.withinGap_iff_of_below`, `Flow.withinGap_iff_of_at`); beyond it the level crosses
  (`Flow.crosses_of_above`, `Flow.crosses_of_below`). A witness (`Regulation.Overshooting`)
  balances, opposes the departure on both sides at every step and exceeds the gap at every step;
  its level oscillates about `m` and is never `m` (`Overshooting.oscillates`,
  `Overshooting.never_at`). Another (`Regulation.OneSided`) satisfies the premise of the law of
  restoration from every step and the bound at every step, does not oppose the departure above
  `m`, and stays above `m` (`OneSided.restores_premise`, `OneSided.above`): one side is not
  regulation.
* **The least band of a late reading is `2 (ℓ + 1) d`, exactly.** A rule reads `ℓ` steps late
  (`Regulation.ReadsLate`) where what it gives and takes at a step is fixed by what the rest
  exchanged up to `ℓ + 1` steps before; it may keep anything it has read, its own exchanges
  included. Two rests that agree up to a step and differ over the `ℓ + 1` steps after it are not
  told apart, and the levels they reach differ by what they exchange differently
  (`Regulation.late_spread`). So no rule reading `ℓ` late keeps the level within a band narrower
  than `2 (ℓ + 1) d` under every rest moving it by at most `d` a step (`Regulation.late_band`,
  `Regulation.no_narrower_band`). The late return (`Regulation.lateReturn`), moving back at each
  step what the rest exchanged `ℓ + 1` steps before, reads `ℓ` late, needing only the level read
  `ℓ` steps late and its own exchanges (`Regulation.lateReturn_reads_levels`), and keeps every
  course within `(ℓ + 1) d` of its start (`Regulation.lateReturn_keeps`,
  `Regulation.lateReturn_band`): the bound is attained.
* **A late relay overshoots by lateness times step.** The relay (`Regulation.relay`) gives a step
  `M` for a reading below `a`, takes `M` for a reading above `b`, and neither within `[a, b]`; a
  flow relays `ℓ` steps late (`Flow.RelaysLate`) where it does so for the level `ℓ` steps before.
  Readings below drive pushes, readings above pulls, and readings within hold the level
  (`Regulation.push_ramp`, `Regulation.pull_ramp`, `Regulation.rest_ramp`); a level entering the
  band goes on by `ℓ M` (`Regulation.overshoot`, `Regulation.undershoot`), and the regulator's own
  rise or fall, read late, feeds itself (`Regulation.rise_run`, `Regulation.fall_run`). From a start
  held below the band for its first `ℓ + 1` steps the level rises by `M` a step
  (`Regulation.held_rise`); it settles in the band where its entry carried `ℓ M` further is within
  `b` (`Regulation.held_settles`) and goes past `b` otherwise (`Regulation.held_leaves`).
* **Past the threshold, the level leaves both ends without end.** An upward crossing
  (`Web.UpCrossing`: an entry from below within one step of `a` that passes `b` when carried `ℓ M`
  further) is followed by a downward one (`Web.DownCrossing`, its mirror), and that by an upward
  one (`Regulation.upCrossing_next`, `Regulation.downCrossing_next`): each entry is within one step
  of the end it enters at, so each overshoot passes the other end. After every step the level is
  somewhere above `b` and somewhere below `a` (`Regulation.crossing_oscillates`). A start held at
  `a - 1` crosses where `b + 2 ≤ a + (ℓ + 1) M` (`Regulation.held_crosses`,
  `Regulation.held_oscillates`), and every start held below `a` settles otherwise
  (`Regulation.held_below_settles`). The relay runs: its window law (`Regulation.relayWindow`, with
  `Law.orbit`) gives, for every start, a run that relays `ℓ` late and balances at every step where
  `(ℓ + 1) M ≤ b + 1` (`Regulation.relay_runs`). So the threshold is exact: every start held below
  the band settles exactly where `a + (ℓ + 1) M ≤ b + 1` (`Regulation.relay_threshold`). The least
  band the relay keeps grows with lateness times step.

What is not derived: that a given system regulates, how late it reads, or the size of its step
(each a named premise of the laws that use it). The modelling choices are the spine's: discrete
steps, whole-number amounts, and one condition read at a time; the rest's record is a pair of
amounts a step. The relay is the simplest regulation by thresholds, and its threshold is stated
for it alone; the band a late reading needs (`Regulation.no_narrower_band`) holds for every rule.
Every declaration has an empty axiom report. No ethical predicate, ranking or axiom occurs.
-/

namespace Becoming

variable {F C : Type}

open Propagation

namespace Regulation

/-! ## The two sides of a level -/

/-- Where `m ≤ x`, the gap of `x` from `m` is what `x` has beyond `m`. -/
theorem gap_of_le {x m : Nat} (le : m ≤ x) : gap x m = x - m :=
  (congrArg ((x - m) + ·) (sub_eq_zero_of_le le)).trans (Nat.add_zero _)

/-- Where `x ≤ m`, the gap of `x` from `m` is what `x` lacks of `m`. -/
theorem gap_of_ge {x m : Nat} (le : x ≤ m) : gap x m = m - x :=
  (congrArg (· + (m - x)) (sub_eq_zero_of_le le)).trans (Nat.zero_add _)

/-- `y` lies between `m` and `x`: on the side of `m` where `x` is, and no farther from `m` than
`x`. At `x = m`, `y` is `m`. -/
def Between (m x y : Nat) : Prop :=
  (m ≤ x → m ≤ y ∧ y ≤ x) ∧ (x ≤ m → x ≤ y ∧ y ≤ m)

/-- Between `m` and `m` lies only `m`. -/
theorem Between.at_level {m y : Nat} (between : Between m m y) : y = m :=
  match between.1 (Nat.le_refl m) with
  | ⟨my, ym⟩ => Nat.le_antisymm ym my

/-- Between `m` and a level at `m` lies only `m`. -/
theorem Between.stays {m x y : Nat} (between : Between m x y) (atLevel : x = m) : y = m :=
  (atLevel ▸ between : Between m m y).at_level

/-- What lies between `m` and something between `m` and `x` lies between `m` and `x`. -/
theorem Between.trans {m x y z : Nat} (xy : Between m x y) (yz : Between m y z) :
    Between m x z :=
  ⟨fun mx => match xy.1 mx with
    | ⟨my, yx⟩ => match yz.1 my with
      | ⟨mz, zy⟩ => ⟨mz, Nat.le_trans zy yx⟩,
   fun xm => match xy.2 xm with
    | ⟨xy', ym⟩ => match yz.2 ym with
      | ⟨yz', zm⟩ => ⟨Nat.le_trans xy' yz', zm⟩⟩

/-- Every amount lies between `m` and itself. -/
theorem Between.refl (m x : Nat) : Between m x x :=
  ⟨fun mx => ⟨mx, Nat.le_refl x⟩, fun xm => ⟨Nat.le_refl x, xm⟩⟩

/-- **The bound is exactly no overshoot.** Where `y + k = x + g` (a level `x` becomes `y` with
`k` taken and `g` given), the taking exceeds the giving by at most the excess of `x` over `m`,
and the giving exceeds the taking by at most the deficit of `x` below `m`, exactly where `y` lies
between `m` and `x`. -/
theorem within_iff_between {x y k g m : Nat} (balance : y + k = x + g) :
    (k ≤ g + (x - m) ∧ g ≤ k + (m - x)) ↔ Between m x y :=
  ⟨fun ⟨taking, giving⟩ =>
    ⟨fun mx =>
      have giving' : g ≤ k :=
        Nat.le_trans giving (Nat.le_of_eq ((congrArg (k + ·) (sub_eq_zero_of_le mx)).trans
          (Nat.add_zero k)))
      ⟨le_of_add_le_add_right k
        (calc m + k ≤ m + (g + (x - m)) := Nat.add_le_add_left taking m
          _ = g + (m + (x - m)) := Nat.add_left_comm m g (x - m)
          _ = g + x := congrArg (g + ·) (add_sub_of_le mx)
          _ = x + g := Nat.add_comm g x
          _ = y + k := balance.symm),
       le_of_add_le_add_right k
        (Nat.le_trans (Nat.le_of_eq balance) (Nat.add_le_add_left giving' x))⟩,
     fun xm =>
      have taking' : k ≤ g :=
        Nat.le_trans taking (Nat.le_of_eq ((congrArg (g + ·) (sub_eq_zero_of_le xm)).trans
          (Nat.add_zero g)))
      ⟨le_of_add_le_add_right g
        (Nat.le_trans (Nat.le_of_eq balance.symm) (Nat.add_le_add_left taking' y)),
       le_of_add_le_add_right k
        (calc y + k = x + g := balance
          _ ≤ x + (k + (m - x)) := Nat.add_le_add_left giving x
          _ = k + (x + (m - x)) := Nat.add_left_comm x k (m - x)
          _ = k + m := congrArg (k + ·) (add_sub_of_le xm)
          _ = m + k := Nat.add_comm k m)⟩⟩,
   fun between => match Nat.le_total m x with
    | .inl mx => match between.1 mx with
      | ⟨my, yx⟩ =>
        ⟨le_of_add_le_add_right m
          (calc k + m ≤ k + y := Nat.add_le_add_left my k
            _ = y + k := Nat.add_comm k y
            _ = x + g := balance
            _ = (m + (x - m)) + g := congrArg (· + g) (add_sub_of_le mx).symm
            _ = g + (x - m) + m := by rw [Nat.add_comm m (x - m), Nat.add_right_comm, Nat.add_comm (x - m) g]),
         Nat.le_trans
          (le_of_add_le_add_right y
            (calc g + y ≤ g + x := Nat.add_le_add_left yx g
              _ = x + g := Nat.add_comm g x
              _ = y + k := balance.symm
              _ = k + y := Nat.add_comm y k))
          (Nat.le_add_right k (m - x))⟩
    | .inr xm => match between.2 xm with
      | ⟨xy, ym⟩ =>
        ⟨Nat.le_trans
          (le_of_add_le_add_right x
            (calc k + x ≤ k + y := Nat.add_le_add_left xy k
              _ = y + k := Nat.add_comm k y
              _ = x + g := balance
              _ = g + x := Nat.add_comm x g))
          (Nat.le_add_right g (x - m)),
         le_of_add_le_add_right x
          (calc g + x = x + g := Nat.add_comm g x
            _ = y + k := balance.symm
            _ ≤ m + k := Nat.add_le_add_right ym k
            _ = (x + (m - x)) + k := congrArg (· + k) (add_sub_of_le xm).symm
            _ = k + (m - x) + x := by rw [Nat.add_comm x (m - x), Nat.add_right_comm, Nat.add_comm (m - x) k])⟩⟩

/-- Between `m` and `x`, the gap from `m` is at most the gap of `x`. -/
theorem Between.gap_le {m x y : Nat} (between : Between m x y) : gap y m ≤ gap x m :=
  match Nat.le_total m x with
  | .inl mx => match between.1 mx with
    | ⟨my, yx⟩ => gap_le_of (Nat.le_trans yx (le_add_gap x m))
        (Nat.le_trans my (Nat.le_add_right y _))
  | .inr xm => match between.2 xm with
    | ⟨xy, ym⟩ => gap_le_of (Nat.le_trans ym (Nat.le_add_right m _))
        (Nat.le_trans (le_add_gap m x)
          (Nat.add_le_add xy (Nat.le_of_eq (gap_comm m x))))

/-- `y - m + 1 ≤ x - m` where `m ≤ y < x`. -/
theorem sub_succ_le_of_lt {m y x : Nat} (my : m ≤ y) (yx : y < x) : y - m + 1 ≤ x - m :=
  le_of_add_le_add_right m
    (calc y - m + 1 + m = m + (y - m) + 1 := by rw [Nat.add_right_comm, Nat.add_comm (y - m) m]
      _ = y + 1 := congrArg (· + 1) (add_sub_of_le my)
      _ ≤ x := yx
      _ = m + (x - m) := (add_sub_of_le (Nat.le_trans my (Nat.le_of_lt yx))).symm
      _ = x - m + m := Nat.add_comm m (x - m))

/-- `m - y + 1 ≤ m - x` where `x < y ≤ m`. -/
theorem sub_succ_le_of_gt {m y x : Nat} (ym : y ≤ m) (xy : x < y) : m - y + 1 ≤ m - x :=
  le_of_add_le_add_right x
    (calc m - y + 1 + x = m - y + (x + 1) :=
          (Nat.add_assoc _ _ _).trans (congrArg (m - y + ·) (Nat.add_comm 1 x))
      _ ≤ m - y + y := Nat.add_le_add_left xy _
      _ = y + (m - y) := Nat.add_comm _ _
      _ = m := add_sub_of_le ym
      _ = x + (m - x) := (add_sub_of_le (Nat.le_trans (Nat.le_of_lt xy) ym)).symm
      _ = m - x + x := Nat.add_comm x (m - x))

/-- Between `m` and `x`, moving strictly towards `m` from either side, the gap falls by at least
one where `x` is not `m`. -/
theorem Between.gap_falls {m x y : Nat} (between : Between m x y)
    (lowers : m < x → y < x) (raises : x < m → x < y) (off : x ≠ m) :
    gap y m + 1 ≤ gap x m :=
  match Nat.lt_or_ge x m with
  | .inl xm => match between.2 (Nat.le_of_lt xm) with
    | ⟨_, ym⟩ =>
      Nat.le_trans (Nat.le_of_eq (congrArg (· + 1) (gap_of_ge ym)))
        (Nat.le_trans (sub_succ_le_of_gt ym (raises xm)) (Nat.le_of_eq (gap_of_ge (Nat.le_of_lt xm)).symm))
  | .inr mx =>
    have mx' : m < x := Nat.lt_of_le_of_ne mx (fun same => off same.symm)
    match between.1 mx with
    | ⟨my, _⟩ =>
      Nat.le_trans (Nat.le_of_eq (congrArg (· + 1) (gap_of_le my)))
        (Nat.le_trans (sub_succ_le_of_lt my (lowers mx')) (Nat.le_of_eq (gap_of_le mx).symm))

end Regulation

open Regulation

namespace Flow

/-- Across the step from `t`, the joint exchange at `c` departs from evenness by at most the gap
of the level from `m`, on each side: the taking exceeds the giving by at most the level's excess
over `m`, and the giving exceeds the taking by at most its deficit below `m`. At `m` the two are
equal. -/
def WithinGap (L : Flow F C) (W : Web F C) (m t : Nat) (c : C) : Prop :=
  L.taken t c ≤ L.given t c + (W.level t c - m) ∧ L.given t c ≤ L.taken t c + (m - W.level t c)

/-- Across the step from `t`, the joint exchange at `c` opposes the level's departure from `m`
on both sides: it takes more than it gives above `m` and gives more than it takes below. -/
def Opposes (L : Flow F C) (W : Web F C) (m t : Nat) (c : C) : Prop :=
  (m < W.level t c → L.given t c < L.taken t c) ∧ (W.level t c < m → L.taken t c < L.given t c)

variable {L : Flow F C} {W : Web F C}

/-- **The bound is exactly no overshoot.** With balance at the condition across the step, the
joint exchange is within the gap to `m` exactly where the next level lies between `m` and the
level. -/
theorem withinGap_iff_between {m t : Nat} {c : C} (balances : L.BalancesOn W [c] t) :
    L.WithinGap W m t c ↔ Between m (W.level t c) (W.level (t + 1) c) :=
  within_iff_between (balances c (.head []))

/-- **Beyond the gap, no rest at `m`.** With balance at the condition across the step, a joint
exchange exceeding the gap to `m` on some side leaves the next level off `m`: at `m` it would lie
between `m` and any level. -/
theorem not_at_of_beyond {m t : Nat} {c : C} (balances : L.BalancesOn W [c] t)
    (beyond : ¬ L.WithinGap W m t c) : W.level (t + 1) c ≠ m :=
  fun atLevel => beyond ((withinGap_iff_between balances).mpr
    (Eq.subst (motive := fun y => Between m (W.level t c) y) atLevel.symm
      ⟨fun mx => ⟨Nat.le_refl m, mx⟩, fun xm => ⟨xm, Nat.le_refl m⟩⟩))

/-- **Overcorrecting at every step never comes to rest at `m`.** With balance at the condition
and the joint exchange beyond the gap to `m` at each step from `T`, the level is off `m` at every
step after `T`. -/
theorem never_at_of_beyond {m T : Nat} {c : C} (balances : ∀ t, T ≤ t → L.BalancesOn W [c] t)
    (beyond : ∀ t, T ≤ t → ¬ L.WithinGap W m t c) : ∀ t, T < t → W.level t c ≠ m
  | 0, late => absurd late (Nat.not_lt_zero T)
  | t + 1, late => not_at_of_beyond (balances t (Nat.le_of_lt_succ late))
      (beyond t (Nat.le_of_lt_succ late))

/-- Within the gap, the gap to `m` does not rise across the step. -/
theorem gap_le_of_within {m t : Nat} {c : C} (balances : L.BalancesOn W [c] t)
    (within : L.WithinGap W m t c) : gap (W.level (t + 1) c) m ≤ gap (W.level t c) m :=
  ((withinGap_iff_between balances).mp within).gap_le

/-- Within the gap and opposing, the gap to `m` falls by at least one across the step where the
level is not `m`. -/
theorem gap_falls {m t : Nat} {c : C} (balances : L.BalancesOn W [c] t)
    (within : L.WithinGap W m t c) (opposes : L.Opposes W m t c) (off : W.level t c ≠ m) :
    gap (W.level (t + 1) c) m + 1 ≤ gap (W.level t c) m :=
  ((withinGap_iff_between balances).mp within).gap_falls
    (fun above => excess_lowers_at balances (opposes.1 above))
    (fun below => net_give_raises_at balances (opposes.2 below)) off

/-- **Two-sided regulation.** With balance at the condition, and the joint exchange within the
gap to `m` and opposing at each of `n` steps from `T`, the gap at `T + n` is at most the gap at
`T` less `n`. -/
theorem regulates_at {m T : Nat} {c : C} : ∀ n,
    (∀ k, k < n → L.BalancesOn W [c] (T + k)) →
    (∀ k, k < n → L.WithinGap W m (T + k) c) →
    (∀ k, k < n → L.Opposes W m (T + k) c) →
    gap (W.level (T + n) c) m ≤ gap (W.level T c) m - n
  | 0, _, _, _ => Nat.le_refl _
  | n + 1, balances, within, opposes =>
    have before := regulates_at n (fun k lt => balances k (Nat.lt_succ_of_lt lt))
      (fun k lt => within k (Nat.lt_succ_of_lt lt)) (fun k lt => opposes k (Nat.lt_succ_of_lt lt))
    match Nat.decEq (W.level (T + n) c) m with
    | .isTrue atLevel =>
      Nat.le_trans
        (Nat.le_of_eq ((congrArg (gap · m)
          ((((withinGap_iff_between (balances n (Nat.lt_succ_self n))).mp
            (within n (Nat.lt_succ_self n)))).stays atLevel)).trans (gap_self m)))
        (Nat.zero_le _)
    | .isFalse off =>
      Nat.pred_le_pred (Nat.le_trans
        (gap_falls (balances n (Nat.lt_succ_self n)) (within n (Nat.lt_succ_self n))
          (opposes n (Nat.lt_succ_self n)) off) before)


/-- **The level settles at `m`.** With balance at the condition, and the joint exchange within the
gap to `m` and opposing at every step from `T`, the level is `m` at every step from `T` plus its
gap at `T` on. -/
theorem settles_at {m T : Nat} {c : C} (balances : ∀ k, L.BalancesOn W [c] (T + k))
    (within : ∀ k, L.WithinGap W m (T + k) c) (opposes : ∀ k, L.Opposes W m (T + k) c) :
    ∀ j, W.level (T + gap (W.level T c) m + j) c = m
  | 0 => gap_eq_zero_iff.mp (Nat.eq_zero_of_le_zero (Nat.le_trans
      (regulates_at (gap (W.level T c) m) (fun k _ => balances k) (fun k _ => within k)
        (fun k _ => opposes k))
      (Nat.le_of_eq (Nat.sub_self _))))
  | j + 1 => by
    have b := balances (gap (W.level T c) m + j)
    have w := within (gap (W.level T c) m + j)
    rw [← Nat.add_assoc] at b w
    exact ((withinGap_iff_between b).mp w).stays (settles_at balances within opposes j)

/-- The level settles at `m` at every step from `T` plus its gap at `T` on, stated by steps. -/
theorem settles_from {m T : Nat} {c : C} (balances : ∀ k, L.BalancesOn W [c] (T + k))
    (within : ∀ k, L.WithinGap W m (T + k) c) (opposes : ∀ k, L.Opposes W m (T + k) c)
    {t : Nat} (late : T + gap (W.level T c) m ≤ t) : W.level t c = m :=
  match Nat.le.dest late with
  | ⟨j, same⟩ => same ▸ settles_at balances within opposes j

/-- **Within the gap, the level never crosses `m`.** With balance at the condition and the joint
exchange within the gap to `m` at each of `n` steps from `T`, the level at `T + n` lies between
`m` and the level at `T`: on the same side of `m`, and no farther from it. -/
theorem stays_between_at {m T : Nat} {c : C} : ∀ n,
    (∀ k, k < n → L.BalancesOn W [c] (T + k)) →
    (∀ k, k < n → L.WithinGap W m (T + k) c) →
    Between m (W.level T c) (W.level (T + n) c)
  | 0, _, _ => Between.refl m _
  | n + 1, balances, within =>
    (stays_between_at n (fun k lt => balances k (Nat.lt_succ_of_lt lt))
      (fun k lt => within k (Nat.lt_succ_of_lt lt))).trans
      ((withinGap_iff_between (balances n (Nat.lt_succ_self n))).mp
        (within n (Nat.lt_succ_self n)))

/-- **Two-sided regulation under balance.** -/
theorem regulates (balances : L.Balances W) {m T : Nat} {c : C} (n : Nat)
    (within : ∀ k, k < n → L.WithinGap W m (T + k) c)
    (opposes : ∀ k, k < n → L.Opposes W m (T + k) c) :
    gap (W.level (T + n) c) m ≤ gap (W.level T c) m - n :=
  regulates_at n (fun k _ => balances.on [c] (T + k)) within opposes

/-- **The level settles at `m` under balance.** -/
theorem settles (balances : L.Balances W) {m T : Nat} {c : C}
    (within : ∀ k, L.WithinGap W m (T + k) c) (opposes : ∀ k, L.Opposes W m (T + k) c)
    {t : Nat} (late : T + gap (W.level T c) m ≤ t) : W.level t c = m :=
  settles_from (fun k => balances.on [c] (T + k)) within opposes late

/-- **Restoration without overshoot.** From below `m`, within the gap and opposing at every step,
the level is `m` at every step from `T + (m - W.level T c)` on: the law of restoration
(`restores`) reaches at least `m`; with the bound it reaches `m` exactly and stays. -/
theorem restores_exactly (balances : L.Balances W) {m T : Nat} {c : C}
    (below : W.level T c ≤ m)
    (within : ∀ k, L.WithinGap W m (T + k) c) (opposes : ∀ k, L.Opposes W m (T + k) c)
    {t : Nat} (late : T + (m - W.level T c) ≤ t) : W.level t c = m :=
  settles balances within opposes ((gap_of_ge below).symm ▸ late)

/-! ### Where the bound fails -/

/-- **Overshoot is crossing, from above.** With balance at the condition and an exchange
opposing a level above `m`, the exchange is within the gap exactly where the next level is not
below `m`. -/
theorem withinGap_iff_of_above {m t : Nat} {c : C} (balances : L.BalancesOn W [c] t)
    (opposes : L.Opposes W m t c) (above : m < W.level t c) :
    L.WithinGap W m t c ↔ m ≤ W.level (t + 1) c :=
  ⟨fun within => (((withinGap_iff_between balances).mp within).1 (Nat.le_of_lt above)).1,
   fun my => (withinGap_iff_between balances).mpr
    ⟨fun _ => ⟨my, Nat.le_trans (Nat.le_succ _) (excess_lowers_at balances (opposes.1 above))⟩,
     fun xm => absurd above (Nat.not_lt_of_le xm)⟩⟩

/-- **Overshoot is crossing, from below.** With balance at the condition and an exchange
opposing a level below `m`, the exchange is within the gap exactly where the next level is not
above `m`. -/
theorem withinGap_iff_of_below {m t : Nat} {c : C} (balances : L.BalancesOn W [c] t)
    (opposes : L.Opposes W m t c) (below : W.level t c < m) :
    L.WithinGap W m t c ↔ W.level (t + 1) c ≤ m :=
  ⟨fun within => (((withinGap_iff_between balances).mp within).2 (Nat.le_of_lt below)).2,
   fun ym => (withinGap_iff_between balances).mpr
    ⟨fun mx => absurd below (Nat.not_lt_of_le mx),
     fun _ => ⟨Nat.le_trans (Nat.le_succ _) (net_give_raises_at balances (opposes.2 below)), ym⟩⟩⟩

/-- At `m`, the exchange is within the gap exactly where the level stays at `m`. -/
theorem withinGap_iff_of_at {m t : Nat} {c : C} (balances : L.BalancesOn W [c] t)
    (atLevel : W.level t c = m) :
    L.WithinGap W m t c ↔ W.level (t + 1) c = m :=
  ⟨fun within => ((withinGap_iff_between balances).mp within).stays atLevel,
   fun stays => (withinGap_iff_between balances).mpr (by
    rw [atLevel, stays]
    exact Between.refl m m)⟩

/-- An exchange opposing a level above `m` and beyond the gap takes the level below `m`. -/
theorem crosses_of_above {m t : Nat} {c : C} (balances : L.BalancesOn W [c] t)
    (opposes : L.Opposes W m t c) (above : m < W.level t c) (beyond : ¬ L.WithinGap W m t c) :
    W.level (t + 1) c < m :=
  Nat.lt_of_not_le fun my => beyond ((withinGap_iff_of_above balances opposes above).mpr my)

/-- An exchange opposing a level below `m` and beyond the gap takes the level above `m`. -/
theorem crosses_of_below {m t : Nat} {c : C} (balances : L.BalancesOn W [c] t)
    (opposes : L.Opposes W m t c) (below : W.level t c < m) (beyond : ¬ L.WithinGap W m t c) :
    m < W.level (t + 1) c :=
  Nat.lt_of_not_le fun ym => beyond ((withinGap_iff_of_below balances opposes below).mpr ym)

/-! ### One side, and local regulation -/

/-- One member strictly below and none above make the total strictly below. -/
theorem total_lt_of_le_of_mem {α : Type} {f g : α → Nat} {a : α} :
    ∀ {as : List α}, a ∈ as → f a < g a → (∀ b, b ∈ as → f b ≤ g b) → total as f < total as g
  | _ :: bs, .head _, lt, le => Nat.lt_of_lt_of_le (Nat.add_lt_add_right lt _)
      (Nat.add_le_add_left (total_le bs fun b mem => le b (.tail _ mem)) _)
  | b :: _, .tail _ mem, lt, le => Nat.lt_of_le_of_lt (Nat.add_le_add_right (le b (.head _)) _)
      (Nat.add_lt_add_left (total_lt_of_le_of_mem mem lt fun c mem' => le c (.tail b mem')) _)

/-- **Each formation opposing makes the joint exchange oppose.** Where every formation taking part
gives no more than it takes from the condition above `m` and takes no more than it gives below,
and on each side some formation does so strictly, the joint exchange opposes the level's departure
from `m`. Each formation reads only the level of the condition it exchanges with. -/
theorem opposes_of_each {m t : Nat} {c : C}
    (each : ∀ f, f ∈ L.present t → (m < W.level t c → L.give t f c ≤ L.take t f c) ∧
      (W.level t c < m → L.take t f c ≤ L.give t f c))
    (strictly : (m < W.level t c → ∃ f, f ∈ L.present t ∧ L.give t f c < L.take t f c) ∧
      (W.level t c < m → ∃ f, f ∈ L.present t ∧ L.take t f c < L.give t f c)) :
    L.Opposes W m t c :=
  ⟨fun above => match strictly.1 above with
    | ⟨_, mem, lt⟩ => total_lt_of_le_of_mem mem lt fun f inside => (each f inside).1 above,
   fun below => match strictly.2 below with
    | ⟨_, mem, lt⟩ => total_lt_of_le_of_mem mem lt fun f inside => (each f inside).2 below⟩

/-- **Shares of the gap make the joint exchange within it.** Where each formation taking part
departs from evenness by at most its shares of the gap above and below `m`, and the shares total
at most the gap on each side, the joint exchange is within the gap to `m`. -/
theorem withinGap_of_shares {m t : Nat} {c : C} {up down : F → Nat}
    (each : ∀ f, f ∈ L.present t → L.take t f c ≤ L.give t f c + up f ∧
      L.give t f c ≤ L.take t f c + down f)
    (upTotal : total (L.present t) up ≤ W.level t c - m)
    (downTotal : total (L.present t) down ≤ m - W.level t c) : L.WithinGap W m t c :=
  ⟨Nat.le_trans (total_le _ fun f mem => (each f mem).1)
     (Nat.le_trans (Nat.le_of_eq (total_add _ _ _)) (Nat.add_le_add_left upTotal _)),
   Nat.le_trans (total_le _ fun f mem => (each f mem).2)
     (Nat.le_trans (Nat.le_of_eq (total_add _ _ _)) (Nat.add_le_add_left downTotal _))⟩

/-- **The whole settles where each part is regulated locally.** Under balance, where at each
condition of a family the joint exchange is within the gap to its own level `m c` and opposes
departure from it at every step from `T`, the family's stock is the total of those levels from the
step by which every condition has settled on. No formation need read the stock: each premise is
about one condition. -/
theorem stock_settles (balances : L.Balances W) {ds : List C} {m : C → Nat} {T : Nat}
    (within : ∀ c, c ∈ ds → ∀ k, L.WithinGap W (m c) (T + k) c)
    (opposes : ∀ c, c ∈ ds → ∀ k, L.Opposes W (m c) (T + k) c) {t : Nat}
    (late : ∀ c, c ∈ ds → T + gap (W.level T c) (m c) ≤ t) : W.stock ds t = total ds m :=
  total_congr_on fun c mem => settles balances (within c mem) (opposes c mem) (late c mem)

end Flow

namespace Regulation

/-! ## Two witnesses: overshoot and one side -/

/-! ### Overshoot oscillates

One formation at one condition: at a level of two it takes two, at nothing it gives two. Against
`m = 1` the exchange opposes the departure on both sides at every step and exceeds the gap at
every step: the level is two at every even step and nothing at every odd one. -/

namespace Overshooting

/-- Whether the level is high: at the start, and at every other step. -/
def high : Nat → Bool
  | 0 => true
  | n + 1 => !high n

/-- Two where high, nothing where low. -/
def amount : Bool → Nat
  | true => 2
  | false => 0

/-- What is given back: nothing where high, two where low. -/
def back : Bool → Nat
  | true => 0
  | false => 2

/-- The flow: one formation takes the level where it is high and gives two where it is low. -/
def flow : Flow Unit Unit :=
  ⟨fun _ => [()], fun t _ _ => amount (high t), fun t _ _ => back (high t)⟩

/-- The web: the level, with nothing else recorded. -/
def web : Web Unit Unit :=
  ⟨fun t _ => amount (high t), fun _ _ => True, fun _ _ _ => False, fun _ _ _ => 0,
   fun _ _ _ => False⟩

theorem taken_eq (t : Nat) : flow.taken t () = amount (high t) := Nat.add_zero _

theorem given_eq (t : Nat) : flow.given t () = back (high t) := Nat.add_zero _

/-- The flow balances the web. -/
theorem balances : flow.Balances web := by
  intro t c
  cases c
  show amount (high (t + 1)) + flow.taken t () = amount (high t) + flow.given t ()
  rw [taken_eq, given_eq]
  show amount (!high t) + amount (high t) = amount (high t) + back (high t)
  cases high t <;> rfl

/-- Against `m = 1`, the exchange opposes the departure on both sides at every step. -/
theorem opposes (t : Nat) : flow.Opposes web 1 t () := by
  show (1 < amount (high t) → flow.given t () < flow.taken t ()) ∧
    (amount (high t) < 1 → flow.taken t () < flow.given t ())
  rw [taken_eq, given_eq]
  cases high t <;> decide

/-- The exchange exceeds the gap at every step. -/
theorem beyond (t : Nat) : ¬ flow.WithinGap web 1 t () := by
  show ¬ (flow.taken t () ≤ flow.given t () + (amount (high t) - 1) ∧
    flow.given t () ≤ flow.taken t () + (1 - amount (high t)))
  rw [taken_eq, given_eq]
  cases high t <;> decide

theorem high_even : ∀ n, high (2 * n) = true ∧ high (2 * n + 1) = false
  | 0 => ⟨rfl, rfl⟩
  | n + 1 => match high_even n with
    | ⟨_, odd⟩ => ⟨congrArg (fun b => !b) odd, congrArg (fun b => !(!b)) odd⟩

/-- **It oscillates:** above `m` at every even step and below it at every odd step. -/
theorem oscillates (n : Nat) : 1 < web.level (2 * n) () ∧ web.level (2 * n + 1) () < 1 := by
  show 1 < amount (high (2 * n)) ∧ amount (high (2 * n + 1)) < 1
  rw [(high_even n).1, (high_even n).2]
  decide

/-- The level is never `m`. -/
theorem never_at (t : Nat) : web.level t () ≠ 1 := by
  show amount (high t) ≠ 1
  cases high t <;> decide

end Overshooting

/-! ### One side is not regulation

Nothing is exchanged and the level stays at two. Against `m = 1` the exchange is within the gap at
every step and opposes every departure below `m` (there is none), so the premise of the law of
restoration (`Flow.restores`) holds from every step, and the level is above `m` at every step. -/

namespace OneSided

/-- The flow in which nothing takes part. -/
def flow : Flow Unit Unit := Witnesses.emptyFlow Unit Unit

/-- The web whose level is two at every step. -/
def web : Web Unit Unit := Witnesses.unrequired (fun _ _ => 2) (fun _ _ => True)

/-- The flow balances the web. -/
theorem balances : flow.Balances web := fun _ _ => rfl

/-- Within the gap at every step. -/
theorem within (t : Nat) : flow.WithinGap web 1 t () := ⟨Nat.zero_le _, Nat.zero_le _⟩

/-- Opposing every departure below `m` at every step. -/
theorem opposes_below (t : Nat) : web.level t () < 1 → flow.taken t () < flow.given t () :=
  fun below => absurd (below : 2 < 1) (by decide : ¬ (2 < 1))

/-- The premise of the law of restoration holds from every step. -/
theorem restores_premise (T : Nat) : ∀ k, k < 1 - web.level T () →
    web.level T () ≤ web.level (T + k) () → flow.taken (T + k) () < flow.given (T + k) () :=
  fun _ lt => absurd lt (Nat.not_lt_zero _)

/-- The exchange does not oppose the departure above `m`. -/
theorem not_opposes (t : Nat) : ¬ flow.Opposes web 1 t () :=
  fun opposes => Nat.lt_irrefl 0 (opposes.1 (by decide : 1 < 2))

/-- The level is above `m` at every step. -/
theorem above (t : Nat) : 1 < web.level t () := (by decide : 1 < 2)

end OneSided

end Regulation


/-! ## Reading the level late -/

namespace Regulation

/-! ### Sums over stretches of steps -/

/-- Two amounts that agree on a stretch have the same total over it. -/
theorem total_steps_congr {p q : Nat → Nat} : ∀ {T n : Nat},
    (∀ s, T ≤ s → s < T + n → p s = q s) → total (steps T n) p = total (steps T n) q
  | _, 0, _ => rfl
  | T, n + 1, same =>
    have here := same T (Nat.le_refl T) (Nat.lt_of_lt_of_le (Nat.lt_succ_self T)
      (Nat.succ_le_succ (Nat.le_add_right T n)))
    have rest := total_steps_congr (T := T + 1) (n := n) fun s after before =>
      same s (Nat.le_of_succ_le after)
        (Nat.lt_of_lt_of_le before (Nat.le_of_eq (Nat.add_right_comm T 1 n)))
    (congrArg (· + total (steps (T + 1) n) p) here).trans (congrArg (q T + ·) rest)

/-- An amount that is at most `k` on a stretch of `n` steps totals at most `n * k` over it. -/
theorem total_steps_le {p : Nat → Nat} {k : Nat} : ∀ {T n : Nat},
    (∀ s, T ≤ s → s < T + n → p s ≤ k) → total (steps T n) p ≤ n * k
  | _, 0, _ => Nat.le_of_eq (Nat.zero_mul k).symm
  | T, n + 1, le =>
    have here := le T (Nat.le_refl T) (Nat.lt_of_lt_of_le (Nat.lt_succ_self T)
      (Nat.succ_le_succ (Nat.le_add_right T n)))
    have rest := total_steps_le (T := T + 1) (n := n) fun s after before =>
      le s (Nat.le_of_succ_le after)
        (Nat.lt_of_lt_of_le before (Nat.le_of_eq (Nat.add_right_comm T 1 n)))
    Nat.le_trans (Nat.add_le_add here rest)
      (Nat.le_of_eq ((Nat.add_comm k (n * k)).trans (Nat.succ_mul n k).symm))

/-- An amount that is `k` at every step totals `n * k` over a stretch of `n` steps. -/
theorem total_steps_const (k : Nat) : ∀ T n, total (steps T n) (fun _ => k) = n * k
  | _, 0 => (Nat.zero_mul k).symm
  | T, n + 1 => (congrArg (k + ·) (total_steps_const k (T + 1) n)).trans
      ((Nat.add_comm k (n * k)).trans (Nat.succ_mul n k).symm)

/-- Where `x + p = z + q`, the gap of `x` from `z` is the gap of `q` from `p`, at most. -/
theorem gap_le_of_add_eq {x z p q : Nat} (same : x + p = z + q) : gap x z ≤ gap p q :=
  gap_le_of
    (le_of_add_le_add_right p
      (calc x + p = z + q := same
        _ ≤ z + (p + gap q p) := Nat.add_le_add_left (le_add_gap q p) z
        _ = z + gap p q + p := by rw [gap_comm q p, Nat.add_comm p, Nat.add_assoc]))
    (le_of_add_le_add_right q
      (calc z + q = x + p := same.symm
        _ ≤ x + (q + gap p q) := Nat.add_le_add_left (le_add_gap p q) x
        _ = x + gap p q + q := by rw [Nat.add_comm q, Nat.add_assoc]))

/-- Where `y + q = x + p`, what `x` has beyond `y` is what `q` has beyond `p`. -/
theorem sub_eq_of_add_eq {x y p q : Nat} (same : y + q = x + p) : x - y = q - p :=
  match Nat.le_total p q with
  | .inl pq =>
    have y_eq : y + (q - p) = x := add_right_cancel p
      (calc y + (q - p) + p = y + (p + (q - p)) := by rw [Nat.add_assoc, Nat.add_comm (q - p) p]
        _ = y + q := congrArg (y + ·) (add_sub_of_le pq)
        _ = x + p := same)
    (congrArg (· - y) y_eq.symm).trans (Naturals.add_sub_cancel_left y (q - p))
  | .inr qp =>
    have x_eq : x + (p - q) = y := add_right_cancel q
      (calc x + (p - q) + q = x + (q + (p - q)) := by rw [Nat.add_assoc, Nat.add_comm (p - q) q]
        _ = x + p := congrArg (x + ·) (add_sub_of_le qp)
        _ = y + q := same.symm)
    (sub_eq_zero_of_le (Nat.le_trans (Nat.le_add_right x (p - q)) (Nat.le_of_eq x_eq))).trans
      (sub_eq_zero_of_le qp).symm

/-! ### Rules that read late -/

/-- What the rest gives to and takes from the condition at each step. -/
abbrev Record := Nat → Nat × Nat

/-- A rule of regulation at one condition: from the rest's record, what the regulator gives and
takes at each step. A rule sees the whole record; reading late is a property of the rule. -/
abbrev Rule := Record → Nat → Nat × Nat

/-- **The rule reads `ℓ` steps late.** What it gives and takes at step `t` is the same for two
records of the rest that agree at every step `s` with `s + ℓ < t`: the steps whose effect on the
level shows by the level at `t - ℓ`. Whatever the rule keeps of what it has read, including its own
exchanges, it reads nothing later. -/
def ReadsLate (ℓ : Nat) (ρ : Rule) : Prop :=
  ∀ δ δ' t, (∀ s, s + ℓ < t → δ s = δ' s) → ρ δ t = ρ δ' t

/-- The rest moves the level by at most `d` a step, either way. -/
def NetWithin (d : Nat) (δ : Record) : Prop :=
  ∀ s, gap (δ s).1 (δ s).2 ≤ d

/-- A rule reading `ℓ` late answers alike, at every step up to `T + ℓ`, two records that agree
before `T`. -/
theorem ReadsLate.alike {ℓ : Nat} {ρ : Rule} (late : ReadsLate ℓ ρ) {δ δ' : Record} {T : Nat}
    (agree : ∀ s, s < T → δ s = δ' s) {t : Nat} (le : t ≤ T + ℓ) : ρ δ t = ρ δ' t :=
  late δ δ' t fun s before =>
    agree s (Nat.lt_of_add_lt_add_right (Nat.lt_of_lt_of_le before le))

end Regulation

namespace Flow

/-- **The flow follows the rule** at `c`, with the rest's record `δ`: what the formations taking
part give to and take from `c` at each step is the rule's answer to `δ` with the rest's own
exchange. -/
def FollowsRule (L : Flow F C) (c : C) (ρ : Regulation.Rule) (δ : Regulation.Record) : Prop :=
  ∀ t, L.given t c = (ρ δ t).1 + (δ t).1 ∧ L.taken t c = (ρ δ t).2 + (δ t).2

variable {L : Flow F C} {W : Web F C}

/-- **The balance over a stretch, at one condition.** With balance at `c` at each of `N` steps from
`T`, the level at `T + N` with everything taken over the stretch is the level at `T` with
everything given. -/
theorem accumulates_at {c : C} {T : Nat} : ∀ N, (∀ k, k < N → L.BalancesOn W [c] (T + k)) →
    W.level (T + N) c + total (steps T N) (fun s => L.taken s c) =
      W.level T c + total (steps T N) (fun s => L.given s c) :=
  fun N balances => balance_over_stretch_on (q := fun s => W.level s c) T N fun t from_ below =>
    have back : T + (t - T) = t := Naturals.add_sub_of_le from_
    Eq.subst (motive := fun s => W.level (s + 1) c + L.taken s c = W.level s c + L.given s c) back
      (balances (t - T) (Nat.lt_of_add_lt_add_left
        (Eq.subst (motive := fun s => s < T + N) back.symm below)) c (.head []))

end Flow

namespace Regulation

/-- Two balances `x + (r₂ + d₂) = z + (r₁ + d₁)` and `y + (r₂ + e₂) = z + (r₁ + e₁)`, with the
regulator's parts `r₁`, `r₂` alike, give `x + (d₂ + e₁) = y + (d₁ + e₂)`. -/
theorem cross_cancel {x y z r₁ r₂ d₁ d₂ e₁ e₂ : Nat} (first : x + (r₂ + d₂) = z + (r₁ + d₁))
    (second : y + (r₂ + e₂) = z + (r₁ + e₁)) : x + (d₂ + e₁) = y + (d₁ + e₂) :=
  add_right_cancel r₂
    (calc x + (d₂ + e₁) + r₂ = x + (r₂ + d₂) + e₁ :=
          (Nat.add_assoc x (d₂ + e₁) r₂).trans ((congrArg (x + ·) ((Nat.add_comm (d₂ + e₁) r₂).trans
            (Nat.add_assoc r₂ d₂ e₁).symm)).trans (Nat.add_assoc x (r₂ + d₂) e₁).symm)
      _ = z + (r₁ + d₁) + e₁ := congrArg (· + e₁) first
      _ = z + (r₁ + e₁) + d₁ :=
          (Nat.add_assoc z (r₁ + d₁) e₁).trans ((congrArg (z + ·) (Nat.add_right_comm r₁ d₁ e₁)).trans
            (Nat.add_assoc z (r₁ + e₁) d₁).symm)
      _ = y + (r₂ + e₂) + d₁ := congrArg (· + d₁) second.symm
      _ = y + (d₁ + e₂) + r₂ :=
          (Nat.add_assoc y (r₂ + e₂) d₁).trans ((congrArg (y + ·) ((Nat.add_comm (r₂ + e₂) d₁).trans
            ((congrArg (d₁ + ·) (Nat.add_comm r₂ e₂)).trans (Nat.add_assoc d₁ e₂ r₂).symm))).trans
            (Nat.add_assoc y (d₁ + e₂) r₂).symm))

variable {F' C' : Type} {L : Flow F C} {W : Web F C} {L' : Flow F' C'} {W' : Web F' C'}

/-- Under one rule reading `ℓ` late, two balanced flows from one level whose rests agree before
`T` have one level at every step up to `T`. -/
theorem levels_alike {ℓ : Nat} {ρ : Rule} (late : ReadsLate ℓ ρ) {c : C} {c' : C'}
    {δ δ' : Record} (follows : L.FollowsRule c ρ δ) (follows' : L'.FollowsRule c' ρ δ')
    {T : Nat} (balances : ∀ t, t < T → L.BalancesOn W [c] t)
    (balances' : ∀ t, t < T → L'.BalancesOn W' [c'] t)
    (start : W.level 0 c = W'.level 0 c') (agree : ∀ s, s < T → δ s = δ' s) :
    ∀ t, t ≤ T → W.level t c = W'.level t c'
  | 0, _ => start
  | t + 1, le =>
    have lt : t < T := le
    have rule := late.alike agree (Nat.le_trans (Nat.le_of_lt lt) (Nat.le_add_right T ℓ))
    have rest := agree t lt
    have taken : L.taken t c = L'.taken t c' :=
      (follows t).2.trans ((congrArg (·.2 + (δ t).2) rule).trans
        ((congrArg ((ρ δ' t).2 + ·.2) rest).trans (follows' t).2.symm))
    have given : L.given t c = L'.given t c' :=
      (follows t).1.trans ((congrArg (·.1 + (δ t).1) rule).trans
        ((congrArg ((ρ δ' t).1 + ·.1) rest).trans (follows' t).1.symm))
    add_right_cancel (L.taken t c)
      (calc W.level (t + 1) c + L.taken t c = W.level t c + L.given t c :=
            balances t lt c (.head [])
        _ = W'.level t c' + L'.given t c' := by
            rw [levels_alike late follows follows' balances balances' start agree t
              (Nat.le_of_lt lt), given]
        _ = W'.level (t + 1) c' + L'.taken t c' := (balances' t lt c' (.head [])).symm
        _ = W'.level (t + 1) c' + L.taken t c := by rw [taken])

/-- **What a late reading cannot tell apart.** Under one rule reading `ℓ` steps late, two flows
balanced at their conditions from one level, whose rests agree before `T`, reach levels at
`T + (ℓ + 1)` that differ by exactly the difference of what the two rests exchange over the
`ℓ + 1` steps from `T`: the first level with what the first rest takes and the second gives equals
the second level with what the first rest gives and the second takes. -/
theorem late_spread {ℓ : Nat} {ρ : Rule} (late : ReadsLate ℓ ρ) {c : C} {c' : C'}
    {δ δ' : Record} (follows : L.FollowsRule c ρ δ) (follows' : L'.FollowsRule c' ρ δ')
    {T : Nat} (balances : ∀ t, t < T + (ℓ + 1) → L.BalancesOn W [c] t)
    (balances' : ∀ t, t < T + (ℓ + 1) → L'.BalancesOn W' [c'] t)
    (start : W.level 0 c = W'.level 0 c') (agree : ∀ s, s < T → δ s = δ' s) :
    W.level (T + (ℓ + 1)) c + total (steps T (ℓ + 1)) (fun s => (δ s).2 + (δ' s).1) =
      W'.level (T + (ℓ + 1)) c' + total (steps T (ℓ + 1)) (fun s => (δ s).1 + (δ' s).2) :=
  have atT := levels_alike late follows follows'
    (fun t lt => balances t (Nat.lt_of_lt_of_le lt (Nat.le_add_right T _)))
    (fun t lt => balances' t (Nat.lt_of_lt_of_le lt (Nat.le_add_right T _))) start agree T
    (Nat.le_refl T)
  have window : ∀ s, T ≤ s → s < T + (ℓ + 1) → ρ δ s = ρ δ' s :=
    fun _ _ before => late.alike agree (Nat.le_of_lt_succ before)
  have first := Flow.accumulates_at (L := L) (W := W) (c := c) (T := T) (ℓ + 1)
    fun k lt => balances (T + k) (Nat.add_lt_add_left lt T)
  have second := Flow.accumulates_at (L := L') (W := W') (c := c') (T := T) (ℓ + 1)
    fun k lt => balances' (T + k) (Nat.add_lt_add_left lt T)
  have taken : total (steps T (ℓ + 1)) (fun s => L.taken s c) =
      total (steps T (ℓ + 1)) (fun s => (ρ δ s).2) + total (steps T (ℓ + 1)) (fun s => (δ s).2) :=
    (total_steps_congr fun s _ _ => (follows s).2).trans (total_add _ _ _)
  have given : total (steps T (ℓ + 1)) (fun s => L.given s c) =
      total (steps T (ℓ + 1)) (fun s => (ρ δ s).1) + total (steps T (ℓ + 1)) (fun s => (δ s).1) :=
    (total_steps_congr fun s _ _ => (follows s).1).trans (total_add _ _ _)
  have taken' : total (steps T (ℓ + 1)) (fun s => L'.taken s c') =
      total (steps T (ℓ + 1)) (fun s => (ρ δ s).2) + total (steps T (ℓ + 1)) (fun s => (δ' s).2) :=
    (total_steps_congr fun s after before =>
      (follows' s).2.trans (congrArg (·.2 + (δ' s).2) (window s after before).symm)).trans
      (total_add _ _ _)
  have given' : total (steps T (ℓ + 1)) (fun s => L'.given s c') =
      total (steps T (ℓ + 1)) (fun s => (ρ δ s).1) + total (steps T (ℓ + 1)) (fun s => (δ' s).1) :=
    (total_steps_congr fun s after before =>
      (follows' s).1.trans (congrArg (·.1 + (δ' s).1) (window s after before).symm)).trans
      (total_add _ _ _)
  (congrArg (_ + ·) (total_add _ _ _)).trans
    ((cross_cancel (taken ▸ given ▸ first) (atT ▸ taken' ▸ given' ▸ second)).trans
      (congrArg (_ + ·) (total_add _ _ _).symm))




/-- **No late reading keeps a band narrower than `2 (ℓ + 1) d`, given two courses.** Under one rule
reading `ℓ` late, from one level, let the first rest give `d` and the second take `d` at each of the
`ℓ + 1` steps from `T`, the two agreeing before `T`. The first level at `T + (ℓ + 1)` is the second
with `(ℓ + 1) (d + d)` added; so if both lie in `[a, b]`, then `a + (ℓ + 1) (d + d) ≤ b`. -/
theorem late_band {ℓ d a b : Nat} {ρ : Rule} (late : ReadsLate ℓ ρ) {c : C} {c' : C'}
    {δ δ' : Record} (follows : L.FollowsRule c ρ δ) (follows' : L'.FollowsRule c' ρ δ')
    {T : Nat} (balances : ∀ t, t < T + (ℓ + 1) → L.BalancesOn W [c] t)
    (balances' : ∀ t, t < T + (ℓ + 1) → L'.BalancesOn W' [c'] t)
    (start : W.level 0 c = W'.level 0 c') (agree : ∀ s, s < T → δ s = δ' s)
    (up : ∀ s, T ≤ s → s < T + (ℓ + 1) → δ s = (d, 0))
    (down : ∀ s, T ≤ s → s < T + (ℓ + 1) → δ' s = (0, d))
    (low : a ≤ W'.level (T + (ℓ + 1)) c') (high : W.level (T + (ℓ + 1)) c ≤ b) :
    a + (ℓ + 1) * (d + d) ≤ b :=
  have spread := late_spread late follows follows' balances balances' start agree
  have none : total (steps T (ℓ + 1)) (fun s => (δ s).2 + (δ' s).1) = 0 :=
    (total_steps_congr (q := fun _ => 0) fun s after before =>
      (congrArg (fun e => e.2 + (δ' s).1) (up s after before)).trans
        (congrArg (fun e => 0 + e.1) (down s after before))).trans
      ((total_steps_const 0 T (ℓ + 1)).trans (Nat.mul_zero _))
  have both : total (steps T (ℓ + 1)) (fun s => (δ s).1 + (δ' s).2) = (ℓ + 1) * (d + d) :=
    (total_steps_congr (q := fun _ => d + d) fun s after before =>
      (congrArg (fun e => e.1 + (δ' s).2) (up s after before)).trans
        (congrArg (fun e => d + e.2) (down s after before))).trans
      (total_steps_const (d + d) T (ℓ + 1))
  Nat.le_trans (Nat.add_le_add_right low _)
    (Nat.le_trans (Nat.le_of_eq ((congrArg (_ + ·) both.symm).trans
      (spread.symm.trans ((congrArg (_ + ·) none).trans (Nat.add_zero _))))) high)

/-! ### Courses at one condition -/

/-- The level at one condition under a rule, the rest's record and a start: what the step gives is
added and what it takes is removed, down to nothing at the least. -/
def course (ρ : Rule) (δ : Record) (x₀ : Nat) : Nat → Nat
  | 0 => x₀
  | t + 1 => course ρ δ x₀ t + ((ρ δ t).1 + (δ t).1) - ((ρ δ t).2 + (δ t).2)

/-- The flow of the course: one formation at one condition gives and takes what the rule and the
rest give and take. -/
def courseFlow (ρ : Rule) (δ : Record) : Flow Unit Unit :=
  ⟨fun _ => [()], fun t _ _ => (ρ δ t).2 + (δ t).2, fun t _ _ => (ρ δ t).1 + (δ t).1⟩

/-- The web of the course: its level, with nothing else recorded. -/
def courseWeb (ρ : Rule) (δ : Record) (x₀ : Nat) : Web Unit Unit :=
  ⟨fun t _ => course ρ δ x₀ t, fun _ _ => True, fun _ _ _ => False, fun _ _ _ => 0,
   fun _ _ _ => False⟩

/-- The course's flow follows the rule. -/
theorem courseFlow_follows (ρ : Rule) (δ : Record) : (courseFlow ρ δ).FollowsRule () ρ δ :=
  fun _ => ⟨Nat.add_zero _, Nat.add_zero _⟩

/-- The course is balanced at a step where what the step takes is within the level with what it
gives. -/
theorem course_balances {ρ : Rule} {δ : Record} {x₀ t : Nat}
    (room : (ρ δ t).2 + (δ t).2 ≤ course ρ δ x₀ t + ((ρ δ t).1 + (δ t).1)) :
    (courseFlow ρ δ).BalancesOn (courseWeb ρ δ x₀) [()] t :=
  fun c _ => match c with
  | () => (congrArg (course ρ δ x₀ (t + 1) + ·) (Nat.add_zero _)).trans
      ((Nat.add_comm _ _).trans ((add_sub_of_le room).trans
        (congrArg (course ρ δ x₀ t + ·) (Nat.add_zero _).symm)))

/-- A course that is positive after a step is balanced at it: nothing was cut off at nothing. -/
theorem course_balances_of_pos {ρ : Rule} {δ : Record} {x₀ t : Nat}
    (pos : 0 < course ρ δ x₀ (t + 1)) :
    (courseFlow ρ δ).BalancesOn (courseWeb ρ δ x₀) [()] t :=
  course_balances (match Nat.le_total ((ρ δ t).2 + (δ t).2)
      (course ρ δ x₀ t + ((ρ δ t).1 + (δ t).1)) with
    | .inl room => room
    | .inr over => absurd ((sub_eq_zero_of_le over ▸ pos : 0 < 0)) (Nat.lt_irrefl 0))

/-- **No rule reading `ℓ` steps late keeps a band narrower than `2 (ℓ + 1) d`.** For every rule
reading `ℓ` late and every start, if the course stays within `[a, b]` at every step under every
rest moving the level by at most `d` a step, with `0 < a`, then `a + (ℓ + 1) (d + d) ≤ b`. The
least band a late reading can keep grows with its lateness. -/
theorem no_narrower_band {ℓ d a b : Nat} {ρ : Rule} (late : ReadsLate ℓ ρ) (x₀ : Nat)
    (pos : 0 < a)
    (keeps : ∀ δ, NetWithin d δ → ∀ t, a ≤ course ρ δ x₀ t ∧ course ρ δ x₀ t ≤ b) :
    a + (ℓ + 1) * (d + d) ≤ b :=
  have upKeeps := keeps (fun _ => (d, 0)) (fun _ => Nat.le_of_eq (gap_zero d))
  have downKeeps := keeps (fun _ => (0, d))
    (fun _ => Nat.le_of_eq ((gap_comm 0 d).trans (gap_zero d)))
  late_band (T := 0) late (courseFlow_follows ρ _) (courseFlow_follows ρ _)
    (fun t _ => course_balances_of_pos (Nat.lt_of_lt_of_le pos (upKeeps (t + 1)).1))
    (fun t _ => course_balances_of_pos (Nat.lt_of_lt_of_le pos (downKeeps (t + 1)).1))
    rfl (fun _ lt => absurd lt (Nat.not_lt_zero _)) (fun _ _ _ => rfl) (fun _ _ _ => rfl)
    ((downKeeps _).1) ((upKeeps _).2)

/-! ### The late return -/

/-- Moving an exchange back: give what it took beyond what it gave, take what it gave beyond what it
took. -/
def reversal (e : Nat × Nat) : Nat × Nat := (e.2 - e.1, e.1 - e.2)

/-- An exchange and its reversal together give what they take. -/
theorem reversal_evens (e : Nat × Nat) : (reversal e).1 + e.1 = (reversal e).2 + e.2 :=
  match Nat.le_total e.1 e.2 with
  | .inl le => (Nat.add_comm _ _).trans ((add_sub_of_le le).trans
      ((Nat.zero_add e.2).symm.trans (congrArg (· + e.2) (sub_eq_zero_of_le le).symm)))
  | .inr le => (congrArg (· + e.1) (sub_eq_zero_of_le le)).trans ((Nat.zero_add e.1).trans
      ((add_sub_of_le le).symm.trans (Nat.add_comm _ _)))

/-- **The late return.** At each step after the first `ℓ + 1`, move back what the rest exchanged
`ℓ + 1` steps before; nothing before that. -/
def lateReturn (ℓ : Nat) : Rule := fun δ t =>
  if ℓ < t then reversal (δ (t - (ℓ + 1))) else (0, 0)

theorem lateReturn_early {ℓ t : Nat} (δ : Record) (early : t ≤ ℓ) : lateReturn ℓ δ t = (0, 0) :=
  if_neg (Nat.not_lt_of_le early)

theorem lateReturn_late (ℓ n : Nat) (δ : Record) :
    lateReturn ℓ δ (n + (ℓ + 1)) = reversal (δ n) :=
  (if_pos (Nat.lt_of_lt_of_le (Nat.lt_succ_self ℓ) (Nat.le_add_left (ℓ + 1) n))).trans
    (congrArg (fun s => reversal (δ s))
      ((congrArg (· - (ℓ + 1)) (Nat.add_comm n (ℓ + 1))).trans (Naturals.add_sub_cancel_left (ℓ + 1) n)))

/-- The late return reads `ℓ` steps late. -/
theorem lateReturn_readsLate (ℓ : Nat) : ReadsLate ℓ (lateReturn ℓ) := fun δ δ' t agree =>
  match Nat.lt_or_ge ℓ t with
  | .inl lt =>
    have back : t - (ℓ + 1) + (ℓ + 1) = t :=
      (Nat.add_comm _ _).trans (add_sub_of_le lt)
    (if_pos lt).trans ((congrArg reversal (agree (t - (ℓ + 1))
      (Nat.lt_of_lt_of_le (Nat.lt_succ_self _) (Nat.le_of_eq back)))).trans (if_pos lt).symm)
  | .inr ge => (lateReturn_early δ ge).trans (lateReturn_early δ' ge).symm

/-- What the late return gives and takes at a step after the first `ℓ + 1` is computed from the
levels and its own exchange `ℓ + 1` steps before: where `y + (r₂ + δ₂) = x + (r₁ + δ₁)` (the level
`x` became `y` with the rule giving `r₁`, taking `r₂` and the rest giving `δ₁`, taking `δ₂`), the
reversal of the rest's exchange is `((x + r₁) - (y + r₂), (y + r₂) - (x + r₁))`. So the late return
reads only the level `ℓ` steps late and what it did itself. -/
theorem reversal_of_levels {x y r₁ r₂ : Nat} {e : Nat × Nat}
    (balance : y + (r₂ + e.2) = x + (r₁ + e.1)) :
    reversal e = ((x + r₁) - (y + r₂), (y + r₂) - (x + r₁)) :=
  have one : (y + r₂) + e.2 = (x + r₁) + e.1 :=
    (Nat.add_assoc y r₂ e.2).trans (balance.trans (Nat.add_assoc x r₁ e.1).symm)
  have two : (x + r₁) + e.1 = (y + r₂) + e.2 := one.symm
  Prod.ext (sub_eq_of_add_eq one).symm (sub_eq_of_add_eq two).symm

/-- **The late return reads the level late.** For a flow following the late return at `c`, balanced
there at step `s`, what the late return gives and takes `ℓ + 1` steps after `s` is computed from
the levels at `s` and `s + 1` and from what it gave and took itself at `s`: it needs nothing of the
rest's record beyond what the level shows, `ℓ` steps late. -/
theorem lateReturn_reads_levels {ℓ : Nat} {δ : Record} {c : C}
    (follows : L.FollowsRule c (lateReturn ℓ) δ) {s : Nat} (balances : L.BalancesOn W [c] s) :
    lateReturn ℓ δ (s + (ℓ + 1)) =
      ((W.level s c + (lateReturn ℓ δ s).1) - (W.level (s + 1) c + (lateReturn ℓ δ s).2),
       (W.level (s + 1) c + (lateReturn ℓ δ s).2) - (W.level s c + (lateReturn ℓ δ s).1)) :=
  (lateReturn_late ℓ s δ).trans (reversal_of_levels
    (((congrArg (W.level (s + 1) c + ·) (follows s).2).symm.trans (balances c (.head []))).trans
      (congrArg (W.level s c + ·) (follows s).1)))

/-- One step of the late return's window: from `X + (a₂ + A₂) = Z + (a₁ + A₁)`, a step
`Y + (r₂ + f) = X + (r₁ + e)` whose rule part is the reversal of `a` (`r₁ + a₁ = r₂ + a₂`) gives
`Y + (A₂ + f) = Z + (A₁ + e)`. -/
theorem window_step {X Y Z A₁ A₂ a₁ a₂ r₁ r₂ e f : Nat} (before : X + (a₂ + A₂) = Z + (a₁ + A₁))
    (step : Y + (r₂ + f) = X + (r₁ + e)) (evens : r₁ + a₁ = r₂ + a₂) :
    Y + (A₂ + f) = Z + (A₁ + e) :=
  add_right_cancel (r₂ + a₂)
    (calc Y + (A₂ + f) + (r₂ + a₂) = (Y + (r₂ + f)) + (a₂ + A₂) := by
            conv => lhs; simp only [Nat.add_comm, Nat.add_left_comm, Nat.add_assoc]
            conv => rhs; simp only [Nat.add_comm, Nat.add_left_comm, Nat.add_assoc]
      _ = (X + (r₁ + e)) + (a₂ + A₂) := by rw [step]
      _ = (X + (a₂ + A₂)) + (r₁ + e) := by
            conv => lhs; simp only [Nat.add_comm, Nat.add_left_comm, Nat.add_assoc]
            conv => rhs; simp only [Nat.add_comm, Nat.add_left_comm, Nat.add_assoc]
      _ = (Z + (a₁ + A₁)) + (r₁ + e) := by rw [before]
      _ = Z + (A₁ + e) + (r₁ + a₁) := by
            conv => lhs; simp only [Nat.add_comm, Nat.add_left_comm, Nat.add_assoc]
            conv => rhs; simp only [Nat.add_comm, Nat.add_left_comm, Nat.add_assoc]
      _ = Z + (A₁ + e) + (r₂ + a₂) := by rw [evens])

variable {L : Flow F C} {W : Web F C}

/-- Before the late return acts, over the first `t ≤ ℓ + 1` steps, the level with what the rest took
is the start with what the rest gave. -/
theorem lateReturn_early_sum {ℓ : Nat} {δ : Record} {c : C}
    (follows : L.FollowsRule c (lateReturn ℓ) δ) {t : Nat} (early : t ≤ ℓ + 1)
    (balances : ∀ k, k < t → L.BalancesOn W [c] k) :
    W.level t c + total (steps 0 t) (fun s => (δ s).2) =
      W.level 0 c + total (steps 0 t) (fun s => (δ s).1) := by
  have sum := Flow.accumulates_at (L := L) (W := W) (c := c) (T := 0) t
    (fun k lt => (Nat.zero_add k).symm ▸ balances k lt)
  rw [Nat.zero_add] at sum
  have quiet : ∀ s, 0 ≤ s → s < 0 + t → lateReturn ℓ δ s = (0, 0) := fun s _ lt =>
    lateReturn_early δ (Nat.le_of_lt_succ (Nat.lt_of_lt_of_le lt
      (Nat.le_trans (Nat.le_of_eq (Nat.zero_add t)) early)))
  have taken : total (steps 0 t) (fun s => L.taken s c) = total (steps 0 t) (fun s => (δ s).2) :=
    total_steps_congr fun s zero lt => (follows s).2.trans
      ((congrArg (·.2 + (δ s).2) (quiet s zero lt)).trans (Nat.zero_add _))
  have given : total (steps 0 t) (fun s => L.given s c) = total (steps 0 t) (fun s => (δ s).1) :=
    total_steps_congr fun s zero lt => (follows s).1.trans
      ((congrArg (·.1 + (δ s).1) (quiet s zero lt)).trans (Nat.zero_add _))
  rw [taken, given] at sum
  exact sum

/-- **The late return's window.** After the first `ℓ + 1` steps, the level at `n + (ℓ + 1)` with
what the rest took over the `ℓ + 1` steps from `n` is the start with what the rest gave over them:
each exchange of the rest before the window has been moved back. -/
theorem lateReturn_window {ℓ : Nat} {δ : Record} {c : C}
    (follows : L.FollowsRule c (lateReturn ℓ) δ) : ∀ n,
    (∀ k, k < n + (ℓ + 1) → L.BalancesOn W [c] k) →
    W.level (n + (ℓ + 1)) c + total (steps n (ℓ + 1)) (fun s => (δ s).2) =
      W.level 0 c + total (steps n (ℓ + 1)) (fun s => (δ s).1)
  | 0, balances => by
    have early := lateReturn_early_sum (W := W) follows (Nat.le_refl (ℓ + 1))
      (fun k lt => balances k ((Nat.zero_add (ℓ + 1)).symm ▸ lt))
    rw [Nat.zero_add]
    exact early
  | n + 1, balances => by
    have before := lateReturn_window follows n
      (fun k lt => balances k (Nat.lt_of_lt_of_le lt (Nat.add_le_add_right (Nat.le_succ n) _)))
    have step := balances (n + (ℓ + 1))
      (Nat.add_lt_add_right (Nat.lt_succ_self n) (ℓ + 1)) c (.head [])
    have rule := lateReturn_late ℓ n δ
    rw [(follows (n + (ℓ + 1))).1, (follows (n + (ℓ + 1))).2, rule] at step
    have index : n + 1 + (ℓ + 1) = n + (ℓ + 1) + 1 := Nat.add_right_comm n 1 (ℓ + 1)
    have last : n + 1 + ℓ = n + (ℓ + 1) := Nat.add_right_comm n 1 ℓ
    show W.level (n + 1 + (ℓ + 1)) c + total (steps (n + 1) (ℓ + 1)) (fun s => (δ s).2) =
      W.level 0 c + total (steps (n + 1) (ℓ + 1)) (fun s => (δ s).1)
    rw [index, steps_last, steps_last, last]
    exact window_step before step (reversal_evens (δ n))

/-- **The late return keeps the level within `(ℓ + 1) d` of its start.** For a flow balanced at `c`
and following the late return, with a rest that moves the level by at most `d` a step, the gap of
the level from its start is at most `(ℓ + 1) d` at every step. -/
theorem lateReturn_keeps {ℓ d : Nat} {δ : Record} {c : C}
    (follows : L.FollowsRule c (lateReturn ℓ) δ) (within : NetWithin d δ)
    (balances : ∀ k, L.BalancesOn W [c] k) (t : Nat) :
    gap (W.level t c) (W.level 0 c) ≤ (ℓ + 1) * d :=
  match Nat.lt_or_ge t (ℓ + 1) with
  | .inl early =>
    Nat.le_trans
      (gap_le_of_add_eq (lateReturn_early_sum follows (Nat.le_of_lt early) fun k _ => balances k))
      (Nat.le_trans (gap_total _ _ _)
        (Nat.le_trans (total_steps_le (k := d) fun s _ _ => Nat.le_trans (Nat.le_of_eq (gap_comm _ _)) (within s))
          (Nat.mul_le_mul_right d (Nat.le_of_lt early))))
  | .inr late =>
    match Nat.le.dest late with
    | ⟨n, same⟩ =>
      have index : n + (ℓ + 1) = t := (Nat.add_comm n (ℓ + 1)).trans same
      index ▸ Nat.le_trans
        (gap_le_of_add_eq (lateReturn_window follows n fun k _ => balances k))
        (Nat.le_trans (gap_total _ _ _) (total_steps_le (k := d) fun s _ _ => Nat.le_trans (Nat.le_of_eq (gap_comm _ _)) (within s)))

/-- The late return's course from a start of at least `(ℓ + 1) d` is balanced at every step, for
every rest moving the level by at most `d` a step: what a step takes never exceeds the level with
what it gives. -/
theorem lateReturn_course_balances {ℓ d x₀ : Nat} {δ : Record} (within : NetWithin d δ)
    (room : (ℓ + 1) * d ≤ x₀) :
    ∀ t, (courseFlow (lateReturn ℓ) δ).BalancesOn (courseWeb (lateReturn ℓ) δ x₀) [()] t := by
  intro t
  induction t using Nat.strongRecOn with
  | _ t earlier =>
    apply course_balances
    have follows := courseFlow_follows (lateReturn ℓ) δ
    -- the sums over the window ending at `t + 1`: the rest takes at most what it gives and `(ℓ + 1) d`
    match Nat.lt_or_ge t (ℓ + 1) with
    | .inl early =>
      have sum := lateReturn_early_sum (W := courseWeb (lateReturn ℓ) δ x₀) follows
        (Nat.le_of_lt early) earlier
      have rule := lateReturn_early δ (Nat.le_of_lt_succ early)
      rw [rule]
      show 0 + (δ t).2 ≤ course (lateReturn ℓ) δ x₀ t + (0 + (δ t).1)
      have bound : total (steps 0 (t + 1)) (fun s => (δ s).2) ≤
          x₀ + total (steps 0 (t + 1)) (fun s => (δ s).1) :=
        Nat.le_trans (Nat.le_trans (le_add_gap _ _)
          (Nat.add_le_add_left (Nat.le_trans (Nat.le_of_eq (gap_comm _ _))
            (Nat.le_trans (gap_total _ _ _) (total_steps_le (k := d) fun s _ _ => within s))) _))
          (Nat.le_trans (Nat.add_le_add_left (Nat.le_trans
            (Nat.mul_le_mul_right d (Nat.succ_le_of_lt early)) room) _)
            (Nat.le_of_eq (Nat.add_comm _ _)))
      rw [steps_last, steps_last, Nat.zero_add] at bound
      have shifted : (δ t).2 + total (steps 0 t) (fun s => (δ s).2) ≤
          course (lateReturn ℓ) δ x₀ t + (δ t).1 + total (steps 0 t) (fun s => (δ s).2) := by
        have eq : course (lateReturn ℓ) δ x₀ t + (δ t).1 + total (steps 0 t) (fun s => (δ s).2) =
            x₀ + (total (steps 0 t) (fun s => (δ s).1) + (δ t).1) := by
          have sum' : course (lateReturn ℓ) δ x₀ t + total (steps 0 t) (fun s => (δ s).2) =
              x₀ + total (steps 0 t) (fun s => (δ s).1) := sum
          calc course (lateReturn ℓ) δ x₀ t + (δ t).1 + total (steps 0 t) (fun s => (δ s).2)
              = (course (lateReturn ℓ) δ x₀ t + total (steps 0 t) (fun s => (δ s).2)) + (δ t).1 := by
                conv => lhs; simp only [Nat.add_comm, Nat.add_left_comm, Nat.add_assoc]
                conv => rhs; simp only [Nat.add_comm, Nat.add_left_comm, Nat.add_assoc]
            _ = (x₀ + total (steps 0 t) (fun s => (δ s).1)) + (δ t).1 := by rw [sum']
            _ = x₀ + (total (steps 0 t) (fun s => (δ s).1) + (δ t).1) := Nat.add_assoc _ _ _
        rw [eq, Nat.add_comm (δ t).2]
        exact bound
      have plain := le_of_add_le_add_right _ shifted
      rw [Nat.zero_add, Nat.zero_add]
      exact plain
    | .inr late =>
      match Nat.le.dest late with
      | ⟨n, same⟩ =>
        have index : n + (ℓ + 1) = t := (Nat.add_comm n (ℓ + 1)).trans same
        subst index
        have window := lateReturn_window (W := courseWeb (lateReturn ℓ) δ x₀) follows n earlier
        rw [lateReturn_late]
        show (reversal (δ n)).2 + (δ (n + (ℓ + 1))).2 ≤
          course (lateReturn ℓ) δ x₀ (n + (ℓ + 1)) + ((reversal (δ n)).1 + (δ (n + (ℓ + 1))).1)
        have window' : course (lateReturn ℓ) δ x₀ (n + (ℓ + 1)) +
            ((δ n).2 + total (steps (n + 1) ℓ) (fun s => (δ s).2)) =
            x₀ + ((δ n).1 + total (steps (n + 1) ℓ) (fun s => (δ s).1)) := window
        -- the window ending at `n + (ℓ + 1) + 1` takes at most what it gives and `(ℓ + 1) d`
        have bound : total (steps (n + 1) (ℓ + 1)) (fun s => (δ s).2) ≤
            x₀ + total (steps (n + 1) (ℓ + 1)) (fun s => (δ s).1) :=
          Nat.le_trans (Nat.le_trans (le_add_gap _ _)
            (Nat.add_le_add_left (Nat.le_trans (Nat.le_of_eq (gap_comm _ _))
              (Nat.le_trans (gap_total _ _ _) (total_steps_le (k := d) fun s _ _ => within s))) _))
            (Nat.le_trans (Nat.add_le_add_left room _) (Nat.le_of_eq (Nat.add_comm _ _)))
        rw [steps_last, steps_last, Nat.add_right_comm n 1 ℓ] at bound
        have evens := reversal_evens (δ n)
        apply le_of_add_le_add_right ((δ n).2 + total (steps (n + 1) ℓ) (fun s => (δ s).2))
        calc (reversal (δ n)).2 + (δ (n + (ℓ + 1))).2 +
              ((δ n).2 + total (steps (n + 1) ℓ) (fun s => (δ s).2))
            = ((reversal (δ n)).2 + (δ n).2) +
              (total (steps (n + 1) ℓ) (fun s => (δ s).2) + (δ (n + (ℓ + 1))).2) := by
              conv => lhs; simp only [Nat.add_comm, Nat.add_left_comm, Nat.add_assoc]
              conv => rhs; simp only [Nat.add_comm, Nat.add_left_comm, Nat.add_assoc]
          _ ≤ ((reversal (δ n)).2 + (δ n).2) +
              (x₀ + (total (steps (n + 1) ℓ) (fun s => (δ s).1) + (δ (n + (ℓ + 1))).1)) :=
              Nat.add_le_add_left bound _
          _ = ((reversal (δ n)).1 + (δ n).1) +
              (x₀ + (total (steps (n + 1) ℓ) (fun s => (δ s).1) + (δ (n + (ℓ + 1))).1)) := by
              rw [evens]
          _ = (x₀ + ((δ n).1 + total (steps (n + 1) ℓ) (fun s => (δ s).1))) +
              ((reversal (δ n)).1 + (δ (n + (ℓ + 1))).1) := by
              conv => lhs; simp only [Nat.add_comm, Nat.add_left_comm, Nat.add_assoc]
              conv => rhs; simp only [Nat.add_comm, Nat.add_left_comm, Nat.add_assoc]
          _ = (course (lateReturn ℓ) δ x₀ (n + (ℓ + 1)) +
              ((δ n).2 + total (steps (n + 1) ℓ) (fun s => (δ s).2))) +
              ((reversal (δ n)).1 + (δ (n + (ℓ + 1))).1) := by rw [window']
          _ = course (lateReturn ℓ) δ x₀ (n + (ℓ + 1)) +
              ((reversal (δ n)).1 + (δ (n + (ℓ + 1))).1) +
              ((δ n).2 + total (steps (n + 1) ℓ) (fun s => (δ s).2)) := by
              conv => lhs; simp only [Nat.add_comm, Nat.add_left_comm, Nat.add_assoc]
              conv => rhs; simp only [Nat.add_comm, Nat.add_left_comm, Nat.add_assoc]

/-- **The least band a late reading keeps is `2 (ℓ + 1) d`, exactly.** The late return reads `ℓ`
steps late, and from every start of at least `(ℓ + 1) d`, under every rest moving the level by at
most `d` a step, its course is balanced and stays within `(ℓ + 1) d` of the start: a band of width
`2 (ℓ + 1) d` is kept. No rule reading `ℓ` steps late keeps a narrower one (`no_narrower_band`). -/
theorem lateReturn_band {ℓ d x₀ : Nat} (room : (ℓ + 1) * d ≤ x₀) :
    ReadsLate ℓ (lateReturn ℓ) ∧
      ∀ δ, NetWithin d δ → ∀ t,
        x₀ ≤ course (lateReturn ℓ) δ x₀ t + (ℓ + 1) * d ∧
          course (lateReturn ℓ) δ x₀ t ≤ x₀ + (ℓ + 1) * d :=
  ⟨lateReturn_readsLate ℓ, fun δ within t =>
    match gap_le_iff.mp (lateReturn_keeps (W := courseWeb (lateReturn ℓ) δ x₀)
      (courseFlow_follows (lateReturn ℓ) δ) within (lateReturn_course_balances within room) t) with
    | ⟨above, below⟩ => ⟨below, above⟩⟩


/-! ## The late relay -/

/-- **The relay's answer** to a reading `r` of the level: give `M` where `r` is below `a`, take `M`
where it is above `b`, and nothing between. -/
def relay (a b M r : Nat) : Nat × Nat := (if r < a then M else 0, if b < r then M else 0)

theorem relay_below {a b M r : Nat} (band : a ≤ b) (below : r < a) : relay a b M r = (M, 0) :=
  Prod.ext (if_pos below) (if_neg (Nat.not_lt_of_le (Nat.le_trans (Nat.le_of_lt below) band)))

theorem relay_above {a b M r : Nat} (band : a ≤ b) (above : b < r) : relay a b M r = (0, M) :=
  Prod.ext (if_neg (Nat.not_lt_of_le (Nat.le_trans band (Nat.le_of_lt above)))) (if_pos above)

theorem relay_inside {a b M r : Nat} (low : a ≤ r) (high : r ≤ b) : relay a b M r = (0, 0) :=
  Prod.ext (if_neg (Nat.not_lt_of_le low)) (if_neg (Nat.not_lt_of_le high))

end Regulation

namespace Flow

/-- **The flow relays the level `ℓ` steps late** at `c`: from step `ℓ` on, what the formations
taking part give to and take from `c` at step `t + ℓ` is the relay's answer to the level at `t`.
Nothing else exchanges with `c` there: the relay is the whole of the exchange. -/
def RelaysLate (L : Flow F C) (W : Web F C) (c : C) (ℓ a b M : Nat) : Prop :=
  ∀ t, L.given (t + ℓ) c = (Regulation.relay a b M (W.level t c)).1 ∧
    L.taken (t + ℓ) c = (Regulation.relay a b M (W.level t c)).2

end Flow

namespace Regulation

variable {L : Flow F C} {W : Web F C} {c : C} {ℓ a b M : Nat}

/-- A step of the late relay: with balance at `c` at step `t + ℓ`, the level after it, with what
the relay takes, is the level before it with what the relay gives, both read off the level at
`t`. -/
theorem relay_step (relays : L.RelaysLate W c ℓ a b M) (balances : ∀ t, L.BalancesOn W [c] t)
    (t : Nat) :
    W.level (t + ℓ + 1) c + (relay a b M (W.level t c)).2 =
      W.level (t + ℓ) c + (relay a b M (W.level t c)).1 :=
  ((congrArg (W.level (t + ℓ + 1) c + ·) (relays t).2).symm.trans
    (balances (t + ℓ) c (.head []))).trans (congrArg (W.level (t + ℓ) c + ·) (relays t).1)

/-- Read below `a`, the relay adds `M`. -/
theorem step_below (relays : L.RelaysLate W c ℓ a b M) (balances : ∀ t, L.BalancesOn W [c] t)
    (band : a ≤ b) {t : Nat} (below : W.level t c < a) :
    W.level (t + ℓ + 1) c = W.level (t + ℓ) c + M :=
  have step := relay_step relays balances t
  (congrArg (W.level (t + ℓ + 1) c + ·.2) (relay_below band below)).symm.trans
    (step.trans (congrArg (W.level (t + ℓ) c + ·.1) (relay_below band below)))

/-- Read above `b`, the relay removes `M`. -/
theorem step_above (relays : L.RelaysLate W c ℓ a b M) (balances : ∀ t, L.BalancesOn W [c] t)
    (band : a ≤ b) {t : Nat} (above : b < W.level t c) :
    W.level (t + ℓ + 1) c + M = W.level (t + ℓ) c :=
  have step := relay_step relays balances t
  (congrArg (W.level (t + ℓ + 1) c + ·.2) (relay_above band above)).symm.trans
    (step.trans ((congrArg (W.level (t + ℓ) c + ·.1) (relay_above band above)).trans
      (Nat.add_zero _)))

/-- Read within the band, the relay rests. -/
theorem step_inside (relays : L.RelaysLate W c ℓ a b M) (balances : ∀ t, L.BalancesOn W [c] t)
    {t : Nat} (low : a ≤ W.level t c) (high : W.level t c ≤ b) :
    W.level (t + ℓ + 1) c = W.level (t + ℓ) c :=
  have step := relay_step relays balances t
  (congrArg (W.level (t + ℓ + 1) c + ·.2) (relay_inside low high)).symm.trans
    (step.trans (congrArg (W.level (t + ℓ) c + ·.1) (relay_inside low high)))

/-- **Readings below drive pushes, `ℓ` steps later.** Where the levels at `ρ, …, ρ + n - 1` are
below `a`, the level rises by `M` at each of the `n` steps from `ρ + ℓ`. -/
theorem push_ramp (relays : L.RelaysLate W c ℓ a b M) (balances : ∀ t, L.BalancesOn W [c] t)
    (band : a ≤ b) {ρ n : Nat} (below : ∀ i, i < n → W.level (ρ + i) c < a) :
    ∀ i, i ≤ n → W.level (ρ + ℓ + i) c = W.level (ρ + ℓ) c + i * M
  | 0, _ => (Nat.add_zero _).symm.trans (congrArg (W.level (ρ + ℓ) c + ·) (Nat.zero_mul M).symm)
  | i + 1, le =>
    have step := step_below relays balances band (below i le)
    have index : ρ + i + ℓ = ρ + ℓ + i := Nat.add_right_comm ρ i ℓ
    calc W.level (ρ + ℓ + (i + 1)) c = W.level (ρ + i + ℓ + 1) c := by rw [index]; rfl
      _ = W.level (ρ + i + ℓ) c + M := step
      _ = W.level (ρ + ℓ) c + i * M + M := by rw [index, push_ramp relays balances band below i (Nat.le_of_succ_le le)]
      _ = W.level (ρ + ℓ) c + (i + 1) * M := by rw [Nat.succ_mul, Nat.add_assoc]

/-- **Readings above drive pulls, `ℓ` steps later.** Where the levels at `ρ, …, ρ + n - 1` are
above `b`, the level falls by `M` at each of the `n` steps from `ρ + ℓ`. -/
theorem pull_ramp (relays : L.RelaysLate W c ℓ a b M) (balances : ∀ t, L.BalancesOn W [c] t)
    (band : a ≤ b) {ρ n : Nat} (above : ∀ i, i < n → b < W.level (ρ + i) c) :
    ∀ i, i ≤ n → W.level (ρ + ℓ + i) c + i * M = W.level (ρ + ℓ) c
  | 0, _ => (congrArg (W.level (ρ + ℓ + 0) c + ·) (Nat.zero_mul M)).trans (Nat.add_zero _)
  | i + 1, le =>
    have step := step_above relays balances band (above i le)
    have index : ρ + i + ℓ = ρ + ℓ + i := Nat.add_right_comm ρ i ℓ
    calc W.level (ρ + ℓ + (i + 1)) c + (i + 1) * M
        = (W.level (ρ + i + ℓ + 1) c + M) + i * M := by
          rw [index, Nat.succ_mul]
          conv => lhs; simp only [Nat.add_comm, Nat.add_left_comm, Nat.add_assoc]
          conv => rhs; simp only [Nat.add_comm, Nat.add_left_comm, Nat.add_assoc]
      _ = W.level (ρ + i + ℓ) c + i * M := by rw [step]
      _ = W.level (ρ + ℓ) c := by
          rw [index]; exact pull_ramp relays balances band above i (Nat.le_of_succ_le le)

/-- **Readings within the band hold the level, `ℓ` steps later.** -/
theorem rest_ramp (relays : L.RelaysLate W c ℓ a b M) (balances : ∀ t, L.BalancesOn W [c] t)
    {ρ n : Nat} (inside : ∀ i, i < n → a ≤ W.level (ρ + i) c ∧ W.level (ρ + i) c ≤ b) :
    ∀ i, i ≤ n → W.level (ρ + ℓ + i) c = W.level (ρ + ℓ) c
  | 0, _ => rfl
  | i + 1, le =>
    have step := step_inside relays balances (inside i le).1 (inside i le).2
    have index : ρ + i + ℓ = ρ + ℓ + i := Nat.add_right_comm ρ i ℓ
    calc W.level (ρ + ℓ + (i + 1)) c = W.level (ρ + i + ℓ + 1) c := by rw [index]; rfl
      _ = W.level (ρ + i + ℓ) c := step
      _ = W.level (ρ + ℓ) c := by
          rw [index]; exact rest_ramp relays balances inside i (Nat.le_of_succ_le le)

/-- **The overshoot of a late reading.** Where the `ℓ` levels read before step `σ + ℓ` are below
`a`, the level goes on rising by `M` for `ℓ` more steps, whatever it is at `σ + ℓ`: it reaches
the level at `σ + ℓ` with `ℓ M` added. A level that has entered the band at `σ + ℓ` goes `ℓ M`
beyond its entry. -/
theorem overshoot (relays : L.RelaysLate W c ℓ a b M) (balances : ∀ t, L.BalancesOn W [c] t)
    (band : a ≤ b) {σ : Nat} (below : ∀ i, i < ℓ → W.level (σ + i) c < a) :
    W.level (σ + ℓ + ℓ) c = W.level (σ + ℓ) c + ℓ * M :=
  push_ramp relays balances band below ℓ (Nat.le_refl ℓ)

/-- The mirror: where the `ℓ` levels read before step `σ + ℓ` are above `b`, the level goes on
falling by `M` for `ℓ` more steps. -/
theorem undershoot (relays : L.RelaysLate W c ℓ a b M) (balances : ∀ t, L.BalancesOn W [c] t)
    (band : a ≤ b) {σ : Nat} (above : ∀ i, i < ℓ → b < W.level (σ + i) c) :
    W.level (σ + ℓ + ℓ) c + ℓ * M = W.level (σ + ℓ) c :=
  pull_ramp relays balances band above ℓ (Nat.le_refl ℓ)

/-! ### Arithmetic for the relay -/

/-- Up to `n`, a decidable property holds nowhere, or there is a first place where it holds. -/
theorem first_or_nowhere {P : Nat → Prop} [DecidablePred P] :
    ∀ n, (∀ i, i < n → ¬ P i) ∨ ∃ r, r < n ∧ P r ∧ ∀ i, i < r → ¬ P i
  | 0 => .inl fun _ lt => absurd lt (Nat.not_lt_zero _)
  | n + 1 => match first_or_nowhere (P := P) n with
    | .inr ⟨r, lt, holds, before⟩ => .inr ⟨r, Nat.lt_succ_of_lt lt, holds, before⟩
    | .inl nowhere => if here : P n then .inr ⟨n, Nat.lt_succ_self n, here, nowhere⟩ else
      .inl fun i lt => match Nat.lt_or_ge i n with
        | .inl before => nowhere i before
        | .inr after => (Nat.le_antisymm (Nat.le_of_lt_succ lt) after).symm ▸ here

/-- **The first place.** A decidable property holding at `n` holds first at some `r ≤ n`. -/
theorem first_index {P : Nat → Prop} [DecidablePred P] {n : Nat} (holds : P n) :
    ∃ r, r ≤ n ∧ P r ∧ ∀ i, i < r → ¬ P i :=
  match first_or_nowhere (P := P) (n + 1) with
  | .inl nowhere => absurd holds (nowhere n (Nat.lt_succ_self n))
  | .inr ⟨r, lt, here, before⟩ => ⟨r, Nat.le_of_lt_succ lt, here, before⟩

variable {L : Flow F C} {W : Web F C} {c : C} {ℓ a b M : Nat}

/-! ### From a held start -/

/-- **The rise from a held start.** With the level held at `x₀` below `a` at steps `0, …, ℓ`, and
`x₀ + i M < a` for every `i < k`, the level at `ℓ + i` is `x₀ + i M` for every `i ≤ ℓ + k`: the
regulator pushes for every reading below `a`, the held ones and those of its own rise. -/
theorem held_rise (relays : L.RelaysLate W c ℓ a b M) (balances : ∀ t, L.BalancesOn W [c] t)
    (band : a ≤ b) {x₀ k : Nat} (held : ∀ i, i ≤ ℓ → W.level i c = x₀) (low : x₀ < a)
    (ramp : ∀ i, i < k → x₀ + i * M < a) :
    ∀ i, i ≤ ℓ + k → W.level (ℓ + i) c = x₀ + i * M := by
  have all : ∀ n, n ≤ ℓ + k → ∀ i, i ≤ n → W.level (ℓ + i) c = x₀ + i * M := by
    intro n
    induction n with
    | zero =>
      intro _ i le
      have zero : i = 0 := Nat.le_antisymm le (Nat.zero_le i)
      subst zero
      exact ((held ℓ (Nat.le_refl ℓ)).trans (Nat.add_zero x₀).symm).trans
        (congrArg (x₀ + ·) (Nat.zero_mul M).symm)
    | succ n ih =>
      intro le i ile
      cases Nat.lt_or_ge i (n + 1) with
      | inl lt => exact ih (Nat.le_of_succ_le le) i (Nat.le_of_lt_succ lt)
      | inr ge =>
        have same : i = n + 1 := Nat.le_antisymm ile ge
        subst same
        have reading : W.level n c < a := by
          cases Nat.le_total n ℓ with
          | inl early => exact Nat.lt_of_le_of_lt (Nat.le_of_eq (held n early)) low
          | inr later =>
            obtain ⟨j, jn⟩ := Nat.le.dest later
            have value : W.level (ℓ + j) c = x₀ + j * M :=
              ih (Nat.le_of_succ_le le) j (Nat.le_trans (Nat.le_add_left j ℓ) (Nat.le_of_eq jn))
            have jk : j < k := Nat.lt_of_add_lt_add_left (Nat.lt_of_lt_of_le
              (Nat.lt_of_lt_of_le (Nat.lt_succ_self (ℓ + j))
                (Nat.le_of_eq (congrArg Nat.succ jn))) le)
            exact Nat.lt_of_le_of_lt
              (Nat.le_of_eq ((congrArg (W.level · c) jn).symm.trans value)) (ramp j jk)
        have step := step_below relays balances band reading
        exact calc W.level (ℓ + (n + 1)) c = W.level (n + ℓ + 1) c :=
              congrArg (fun t => W.level (t + 1) c) (Nat.add_comm ℓ n)
          _ = W.level (n + ℓ) c + M := step
          _ = x₀ + n * M + M := congrArg (· + M)
              ((congrArg (W.level · c) (Nat.add_comm n ℓ)).trans
                (ih (Nat.le_of_succ_le le) n (Nat.le_refl n)))
          _ = x₀ + (n + 1) * M := (Nat.add_assoc x₀ (n * M) M).trans
              (congrArg (x₀ + ·) (Nat.succ_mul n M).symm)
  exact fun i le => all (ℓ + k) (Nat.le_refl _) i le

/-- **Settling from a held start.** With the level held at `x₀` below `a`, entering the band at
`x₀ + k M` (below `a` before, `a ≤ x₀ + k M`), and the entry carried `ℓ M` further still within
`b`, the level is `x₀ + (ℓ + k) M`, within the band, at every step from `ℓ + (ℓ + k)` on. -/
theorem held_settles (relays : L.RelaysLate W c ℓ a b M) (balances : ∀ t, L.BalancesOn W [c] t)
    (band : a ≤ b) {x₀ k : Nat} (held : ∀ i, i ≤ ℓ → W.level i c = x₀) (low : x₀ < a)
    (ramp : ∀ i, i < k → x₀ + i * M < a) (enters : a ≤ x₀ + k * M)
    (within : x₀ + (ℓ + k) * M ≤ b) :
    ∀ j, W.level (ℓ + (ℓ + k) + j) c = x₀ + (ℓ + k) * M := by
  have rise := held_rise relays balances band held low ramp
  have peakIn : a ≤ x₀ + (ℓ + k) * M := Nat.le_trans enters
    (Nat.add_le_add_left (Nat.mul_le_mul_right M (Nat.le_add_left k ℓ)) x₀)
  have all : ∀ n, ∀ j, j ≤ n → W.level (ℓ + (ℓ + k) + j) c = x₀ + (ℓ + k) * M := by
    intro n
    induction n with
    | zero =>
      intro j le
      have zero : j = 0 := Nat.le_antisymm le (Nat.zero_le j)
      subst zero
      exact rise (ℓ + k) (Nat.le_refl _)
    | succ n ih =>
      intro j le
      cases Nat.lt_or_ge j (n + 1) with
      | inl lt => exact ih j (Nat.le_of_lt_succ lt)
      | inr ge =>
        have same : j = n + 1 := Nat.le_antisymm le ge
        subst same
        -- the reading for the step from `ℓ + k + n + ℓ` is the level at `ℓ + k + n`
        have reading : a ≤ W.level (ℓ + k + n) c ∧ W.level (ℓ + k + n) c ≤ b := by
          cases Nat.le_total n ℓ with
          | inl early =>
            have value := rise (k + n) (Nat.le_trans (Nat.le_of_eq (Nat.add_comm k n))
              (Nat.add_le_add_right early k))
            have index : ℓ + (k + n) = ℓ + k + n := (Nat.add_assoc ℓ k n).symm
            rw [index] at value
            rw [value]
            exact ⟨Nat.le_trans enters (Nat.add_le_add_left (Nat.mul_le_mul_right M
                (Nat.le_add_right k n)) x₀),
              Nat.le_trans (Nat.add_le_add_left (Nat.mul_le_mul_right M
                (Nat.le_trans (Nat.le_of_eq (Nat.add_comm k n)) (Nat.add_le_add_right early k)))
                x₀) within⟩
          | inr later =>
            obtain ⟨j', jn⟩ := Nat.le.dest later
            have value := ih j' (Nat.le_trans (Nat.le_add_left j' ℓ) (Nat.le_of_eq jn))
            have index : ℓ + (ℓ + k) + j' = ℓ + k + n := by
              rw [← jn]
              conv => lhs; simp only [Nat.add_comm, Nat.add_left_comm, Nat.add_assoc]
              conv => rhs; simp only [Nat.add_comm, Nat.add_left_comm, Nat.add_assoc]
            rw [index] at value
            rw [value]
            exact ⟨peakIn, within⟩
        have step := step_inside relays balances reading.1 reading.2
        have index : ℓ + k + n + ℓ = ℓ + (ℓ + k) + n := by
          conv => lhs; simp only [Nat.add_comm, Nat.add_left_comm, Nat.add_assoc]
          conv => rhs; simp only [Nat.add_comm, Nat.add_left_comm, Nat.add_assoc]
        exact calc W.level (ℓ + (ℓ + k) + (n + 1)) c = W.level (ℓ + k + n + ℓ + 1) c :=
              (congrArg (fun t => W.level (t + 1) c) index).symm
          _ = W.level (ℓ + k + n + ℓ) c := step
          _ = x₀ + (ℓ + k) * M := (congrArg (W.level · c) index).trans (ih n (Nat.le_refl n))
  exact fun j => all j j (Nat.le_refl j)

/-- **Leaving from a held start.** If the entry carried `ℓ M` further passes `b`, the level at
`ℓ + (ℓ + k)` is above the band. -/
theorem held_leaves (relays : L.RelaysLate W c ℓ a b M) (balances : ∀ t, L.BalancesOn W [c] t)
    (band : a ≤ b) {x₀ k : Nat} (held : ∀ i, i ≤ ℓ → W.level i c = x₀) (low : x₀ < a)
    (ramp : ∀ i, i < k → x₀ + i * M < a) (beyond : b < x₀ + (ℓ + k) * M) :
    b < W.level (ℓ + (ℓ + k)) c :=
  Nat.lt_of_lt_of_le beyond
    (Nat.le_of_eq (held_rise relays balances band held low ramp (ℓ + k) (Nat.le_refl _)).symm)

/-- `M ≤ (k + 1) M`. -/
theorem le_succ_mul (k M : Nat) : M ≤ (k + 1) * M :=
  Nat.le_trans (Nat.le_add_left M (k * M)) (Nat.le_of_eq (Nat.succ_mul k M).symm)

/-! ### Runs of pushes and pulls that feed themselves -/

/-- **A rise that feeds itself.** Where the `ℓ` levels read before step `ρ + ℓ` are below `a`, and
the level at `ρ + ℓ` with `j M` added is still below `a` for every `j < k`, every level read from
`ρ` for `ℓ + k` steps is below `a`, and the level rises by `M` at each of the `ℓ + k` steps from
`ρ + ℓ`: the regulator's own rise is read late and drives more rise. -/
theorem rise_run (relays : L.RelaysLate W c ℓ a b M) (balances : ∀ t, L.BalancesOn W [c] t)
    (band : a ≤ b) {ρ k : Nat} (below : ∀ i, i < ℓ → W.level (ρ + i) c < a)
    (stays : ∀ j, j < k → W.level (ρ + ℓ) c + j * M < a) :
    (∀ i, i < ℓ + k → W.level (ρ + i) c < a) ∧
      ∀ i, i ≤ ℓ + k → W.level (ρ + ℓ + i) c = W.level (ρ + ℓ) c + i * M := by
  have readings : ∀ n, n ≤ ℓ + k → ∀ i, i < n → W.level (ρ + i) c < a := by
    intro n
    induction n with
    | zero => exact fun _ i lt => absurd lt (Nat.not_lt_zero i)
    | succ n ih =>
      intro le i lt
      cases Nat.lt_or_ge i n with
      | inl before => exact ih (Nat.le_of_succ_le le) i before
      | inr after =>
        rw [Nat.le_antisymm (Nat.le_of_lt_succ lt) after]
        cases Nat.lt_or_ge n ℓ with
        | inl early => exact below n early
        | inr later =>
          obtain ⟨j, jn⟩ := Nat.le.dest later
          have ramp := push_ramp relays balances band (ih (Nat.le_of_succ_le le)) j
            (Nat.le_trans (Nat.le_add_left j ℓ) (Nat.le_of_eq jn))
          have jk : j < k := Nat.lt_of_add_lt_add_left (Nat.lt_of_lt_of_le
            (Nat.lt_of_lt_of_le (Nat.lt_succ_self (ℓ + j)) (Nat.le_of_eq (congrArg Nat.succ jn)))
            le)
          have index : ρ + ℓ + j = ρ + n := (Nat.add_assoc ρ ℓ j).trans (congrArg (ρ + ·) jn)
          exact Nat.lt_of_le_of_lt
            (Nat.le_of_eq ((congrArg (W.level · c) index).symm.trans ramp)) (stays j jk)
  have all := readings (ℓ + k) (Nat.le_refl _)
  exact ⟨all, push_ramp relays balances band all⟩

/-- **A fall that feeds itself.** The mirror of `rise_run`: where the `ℓ` levels read before step
`ρ + ℓ` are above `b`, and the level at `ρ + ℓ` with `j M` removed is still above `b` for every
`j < k`, the level falls by `M` at each of the `ℓ + k` steps from `ρ + ℓ`. -/
theorem fall_run (relays : L.RelaysLate W c ℓ a b M) (balances : ∀ t, L.BalancesOn W [c] t)
    (band : a ≤ b) {ρ k : Nat} (above : ∀ i, i < ℓ → b < W.level (ρ + i) c)
    (stays : ∀ j, j < k → b + j * M < W.level (ρ + ℓ) c) :
    (∀ i, i < ℓ + k → b < W.level (ρ + i) c) ∧
      ∀ i, i ≤ ℓ + k → W.level (ρ + ℓ + i) c + i * M = W.level (ρ + ℓ) c := by
  have readings : ∀ n, n ≤ ℓ + k → ∀ i, i < n → b < W.level (ρ + i) c := by
    intro n
    induction n with
    | zero => exact fun _ i lt => absurd lt (Nat.not_lt_zero i)
    | succ n ih =>
      intro le i lt
      cases Nat.lt_or_ge i n with
      | inl before => exact ih (Nat.le_of_succ_le le) i before
      | inr after =>
        rw [Nat.le_antisymm (Nat.le_of_lt_succ lt) after]
        cases Nat.lt_or_ge n ℓ with
        | inl early => exact above n early
        | inr later =>
          obtain ⟨j, jn⟩ := Nat.le.dest later
          have ramp := pull_ramp relays balances band (ih (Nat.le_of_succ_le le)) j
            (Nat.le_trans (Nat.le_add_left j ℓ) (Nat.le_of_eq jn))
          have jk : j < k := Nat.lt_of_add_lt_add_left (Nat.lt_of_lt_of_le
            (Nat.lt_of_lt_of_le (Nat.lt_succ_self (ℓ + j)) (Nat.le_of_eq (congrArg Nat.succ jn)))
            le)
          have index : ρ + ℓ + j = ρ + n := (Nat.add_assoc ρ ℓ j).trans (congrArg (ρ + ·) jn)
          exact Nat.lt_of_lt_of_le
            (Nat.lt_of_add_lt_add_right (Nat.lt_of_lt_of_le (stays j jk) (Nat.le_of_eq ramp.symm)))
            (Nat.le_of_eq (congrArg (W.level · c) index))
  have all := readings (ℓ + k) (Nat.le_refl _)
  exact ⟨all, pull_ramp relays balances band all⟩

end Regulation

namespace Web

/-- **The level crosses the band upward at `σ + ℓ`.** The `ℓ` levels read before step `σ + ℓ` are
below `a`; the level at `σ + ℓ` has entered the band within one step `M` of `a`; and carried `ℓ M`
further it passes `b`. -/
structure UpCrossing (W : Web F C) (c : C) (ℓ a b M σ : Nat) : Prop where
  below : ∀ i, i < ℓ → W.level (σ + i) c < a
  enters : a ≤ W.level (σ + ℓ) c
  near : W.level (σ + ℓ) c < a + M
  beyond : b < W.level (σ + ℓ) c + ℓ * M

/-- **The level crosses the band downward at `σ + ℓ`.** The mirror: the `ℓ` levels read before
step `σ + ℓ` are above `b`; the level at `σ + ℓ` has entered the band within one step `M` of `b`;
and with `ℓ M` removed it is below `a`. -/
structure DownCrossing (W : Web F C) (c : C) (ℓ a b M σ : Nat) : Prop where
  above : ∀ i, i < ℓ → b < W.level (σ + i) c
  enters : W.level (σ + ℓ) c ≤ b
  near : b < W.level (σ + ℓ) c + M
  beyond : W.level (σ + ℓ) c < a + ℓ * M

end Web

namespace Regulation

variable {L : Flow F C} {W : Web F C} {c : C} {ℓ a b M : Nat}

/-! ### Crossing without end -/

/-- **An upward crossing is followed by a downward one.** The level is above `b` at `σ + ℓ + ℓ`,
held there while the readings of its rise are within the band, then falls, readings above `b`
feeding the fall; it enters the band from above within one step of `b`, and with `ℓ M` removed it
is below `a`, since its entry from below was within one step of `a`. -/
theorem upCrossing_next (relays : L.RelaysLate W c ℓ a b M)
    (balances : ∀ t, L.BalancesOn W [c] t) (band : a ≤ b) {σ : Nat}
    (up : W.UpCrossing c ℓ a b M σ) :
    b < W.level (σ + ℓ + ℓ) c ∧ ∃ σ', σ < σ' ∧ W.DownCrossing c ℓ a b M σ' := by
  have rise := push_ramp relays balances band up.below
  have peak : W.level (σ + ℓ + ℓ) c = W.level (σ + ℓ) c + ℓ * M := rise ℓ (Nat.le_refl ℓ)
  have over : b < W.level (σ + ℓ + ℓ) c := Nat.lt_of_lt_of_le up.beyond (Nat.le_of_eq peak.symm)
  refine ⟨over, ?_⟩
  obtain ⟨r, rℓ, rOver, rBefore⟩ :=
    first_index (P := fun i => b < W.level (σ + ℓ) c + i * M) up.beyond
  have rest := rest_ramp relays balances (ρ := σ + ℓ) (n := r) fun i lt =>
    have value := rise i (Nat.le_trans (Nat.le_of_lt lt) rℓ)
    ⟨Nat.le_trans up.enters (Nat.le_trans (Nat.le_add_right _ _) (Nat.le_of_eq value.symm)),
     Nat.le_trans (Nat.le_of_eq value) (Nat.le_of_not_lt (rBefore i lt))⟩
  have heldPeak : W.level (σ + ℓ + r + ℓ) c = W.level (σ + ℓ + ℓ) c :=
    (congrArg (W.level · c) (Nat.add_right_comm (σ + ℓ) r ℓ)).trans (rest r (Nat.le_refl r))
  have high : ∀ i, i < ℓ → b < W.level (σ + ℓ + r + i) c := by
    intro i lt
    cases Nat.le_total (r + i) ℓ with
    | inl within =>
      have value := rise (r + i) within
      have index : σ + ℓ + r + i = σ + ℓ + (r + i) := Nat.add_assoc _ _ _
      rw [index, value]
      exact Nat.lt_of_lt_of_le rOver
        (Nat.add_le_add_left (Nat.mul_le_mul_right M (Nat.le_add_right r i)) _)
    | inr past =>
      obtain ⟨j, jn⟩ := Nat.le.dest past
      have jr : j < r := Nat.lt_of_add_lt_add_left (Nat.lt_of_le_of_lt (Nat.le_of_eq jn)
        (Nat.lt_of_lt_of_le (Nat.add_lt_add_left lt r) (Nat.le_of_eq (Nat.add_comm r ℓ))))
      have index : σ + ℓ + r + i = σ + ℓ + ℓ + j :=
        (Nat.add_assoc _ _ _).trans ((congrArg (σ + ℓ + ·) jn.symm).trans (Nat.add_assoc _ _ _).symm)
      rw [index, rest j (Nat.le_of_lt jr)]
      exact over
  have reach : W.level (σ + ℓ + ℓ) c ≤ b + (ℓ + 1) * M := by
    have sm : (ℓ + 1) * M = ℓ * M + M := Nat.succ_mul ℓ M
    have entry : W.level (σ + ℓ) c ≤ b + M :=
      Nat.le_of_lt (Nat.lt_of_lt_of_le up.near (Nat.add_le_add_right band M))
    rw [peak, sm]
    exact Nat.le_trans (Nat.add_le_add_right entry _)
      (Nat.le_of_eq ((Nat.add_right_comm b M (ℓ * M)).trans (Nat.add_assoc b (ℓ * M) M)))
  obtain ⟨k, _, kReach, kBefore⟩ :=
    first_index (P := fun j => W.level (σ + ℓ + ℓ) c ≤ b + j * M) reach
  cases k with
  | zero =>
    exact absurd (Nat.lt_of_lt_of_le over
      (Nat.le_trans kReach (Nat.le_of_eq (congrArg (b + ·) (Nat.zero_mul M))))) (Nat.lt_irrefl b)
  | succ k =>
    have stays : ∀ j, j < k + 1 → b + j * M < W.level (σ + ℓ + r + ℓ) c := fun j lt =>
      Nat.lt_of_lt_of_le (Nat.lt_of_not_le (kBefore j lt)) (Nat.le_of_eq heldPeak.symm)
    obtain ⟨readings, ramp⟩ := fall_run relays balances band high stays
    have down : W.level (σ + ℓ + r + ℓ + (k + 1)) c + (k + 1) * M = W.level (σ + ℓ + ℓ) c :=
      (ramp (k + 1) (Nat.le_add_left _ ℓ)).trans heldPeak
    have index : σ + ℓ + r + (k + 1) + ℓ = σ + ℓ + r + ℓ + (k + 1) := Nat.add_right_comm _ _ _
    refine ⟨σ + ℓ + r + (k + 1), Nat.lt_succ_of_le ?_, ⟨fun i lt => ?_, ?_, ?_, ?_⟩⟩
    · exact Nat.le_trans (Nat.le_add_right σ ℓ)
        (Nat.le_trans (Nat.le_add_right _ r) (Nat.le_add_right _ k))
    · have index' : σ + ℓ + r + (k + 1) + i = σ + ℓ + r + (k + 1 + i) := Nat.add_assoc _ _ _
      rw [index']
      exact readings (k + 1 + i) (Nat.lt_of_lt_of_le (Nat.add_lt_add_left lt (k + 1))
        (Nat.le_of_eq (Nat.add_comm (k + 1) ℓ)))
    · rw [index]
      exact le_of_add_le_add_right ((k + 1) * M) (Nat.le_trans (Nat.le_of_eq down) kReach)
    · rw [index]
      have before : b + k * M < W.level (σ + ℓ + ℓ) c :=
        Nat.lt_of_not_le (kBefore k (Nat.lt_succ_self k))
      have sum : W.level (σ + ℓ + r + ℓ + (k + 1)) c + (k + 1) * M =
          W.level (σ + ℓ + r + ℓ + (k + 1)) c + M + k * M :=
        (congrArg (_ + ·) ((Nat.succ_mul k M).trans (Nat.add_comm (k * M) M))).trans
          (Nat.add_assoc _ _ _).symm
      exact Nat.lt_of_add_lt_add_right
        (Nat.lt_of_lt_of_le before (Nat.le_of_eq (down.symm.trans sum)))
    · rw [index]
      apply Nat.lt_of_not_le
      intro h
      have chain : a + M + ℓ * M ≤ W.level (σ + ℓ) c + ℓ * M :=
        calc a + M + ℓ * M = a + ℓ * M + M := Nat.add_right_comm _ _ _
          _ ≤ a + ℓ * M + (k + 1) * M := Nat.add_le_add_left (le_succ_mul k M) _
          _ ≤ W.level (σ + ℓ + r + ℓ + (k + 1)) c + (k + 1) * M := Nat.add_le_add_right h _
          _ = W.level (σ + ℓ + ℓ) c := down
          _ = W.level (σ + ℓ) c + ℓ * M := peak
      exact Nat.lt_irrefl _ (Nat.lt_of_lt_of_le up.near (le_of_add_le_add_right (ℓ * M) chain))

/-- **A downward crossing is followed by an upward one.** The mirror of `upCrossing_next`: the level
is below `a` at `σ + ℓ + ℓ`, held there, then rises, and crosses upward at a later step, its entry
from below within one step of `a` and carried `ℓ M` further past `b`, since its entry from above
was within one step of `b`. -/
theorem downCrossing_next (relays : L.RelaysLate W c ℓ a b M)
    (balances : ∀ t, L.BalancesOn W [c] t) (band : a ≤ b) {σ : Nat}
    (down : W.DownCrossing c ℓ a b M σ) :
    W.level (σ + ℓ + ℓ) c < a ∧ ∃ σ', σ < σ' ∧ W.UpCrossing c ℓ a b M σ' := by
  have fall := pull_ramp relays balances band down.above
  have trough : W.level (σ + ℓ + ℓ) c + ℓ * M = W.level (σ + ℓ) c := fall ℓ (Nat.le_refl ℓ)
  have under : W.level (σ + ℓ + ℓ) c < a :=
    Nat.lt_of_add_lt_add_right (Nat.lt_of_le_of_lt (Nat.le_of_eq trough) down.beyond)
  refine ⟨under, ?_⟩
  obtain ⟨r, rℓ, rUnder, rBefore⟩ :=
    first_index (P := fun i => W.level (σ + ℓ) c < a + i * M) down.beyond
  have rest := rest_ramp relays balances (ρ := σ + ℓ) (n := r) fun i lt =>
    have value := fall i (Nat.le_trans (Nat.le_of_lt lt) rℓ)
    ⟨le_of_add_le_add_right (i * M)
        (Nat.le_trans (Nat.le_of_not_lt (rBefore i lt)) (Nat.le_of_eq value.symm)),
     Nat.le_trans (Nat.le_trans (Nat.le_add_right _ (i * M)) (Nat.le_of_eq value)) down.enters⟩
  have heldTrough : W.level (σ + ℓ + r + ℓ) c = W.level (σ + ℓ + ℓ) c :=
    (congrArg (W.level · c) (Nat.add_right_comm (σ + ℓ) r ℓ)).trans (rest r (Nat.le_refl r))
  have low : ∀ i, i < ℓ → W.level (σ + ℓ + r + i) c < a := by
    intro i lt
    cases Nat.le_total (r + i) ℓ with
    | inl within =>
      have value := fall (r + i) within
      have index : σ + ℓ + r + i = σ + ℓ + (r + i) := Nat.add_assoc _ _ _
      rw [index]
      exact Nat.lt_of_add_lt_add_right (Nat.lt_of_le_of_lt (Nat.le_of_eq value)
        (Nat.lt_of_lt_of_le rUnder
          (Nat.add_le_add_left (Nat.mul_le_mul_right M (Nat.le_add_right r i)) a)))
    | inr past =>
      obtain ⟨j, jn⟩ := Nat.le.dest past
      have jr : j < r := Nat.lt_of_add_lt_add_left (Nat.lt_of_le_of_lt (Nat.le_of_eq jn)
        (Nat.lt_of_lt_of_le (Nat.add_lt_add_left lt r) (Nat.le_of_eq (Nat.add_comm r ℓ))))
      have index : σ + ℓ + r + i = σ + ℓ + ℓ + j :=
        (Nat.add_assoc _ _ _).trans ((congrArg (σ + ℓ + ·) jn.symm).trans (Nat.add_assoc _ _ _).symm)
      rw [index, rest j (Nat.le_of_lt jr)]
      exact under
  have reach : a ≤ W.level (σ + ℓ + ℓ) c + (ℓ + 1) * M := by
    have sm : (ℓ + 1) * M = ℓ * M + M := Nat.succ_mul ℓ M
    rw [sm, ← Nat.add_assoc (W.level (σ + ℓ + ℓ) c), trough]
    exact Nat.le_of_lt (Nat.lt_of_le_of_lt band down.near)
  obtain ⟨k, _, kReach, kBefore⟩ :=
    first_index (P := fun j => a ≤ W.level (σ + ℓ + ℓ) c + j * M) reach
  cases k with
  | zero =>
    exact absurd (Nat.lt_of_lt_of_le under
      (Nat.le_trans kReach (Nat.le_of_eq (congrArg (_ + ·) (Nat.zero_mul M))))) (Nat.lt_irrefl _)
  | succ k =>
    have stays : ∀ j, j < k + 1 → W.level (σ + ℓ + r + ℓ) c + j * M < a := fun j lt =>
      Nat.lt_of_le_of_lt (Nat.le_of_eq (congrArg (· + j * M) heldTrough))
        (Nat.lt_of_not_le (kBefore j lt))
    obtain ⟨readings, ramp⟩ := rise_run relays balances band low stays
    have up : W.level (σ + ℓ + r + ℓ + (k + 1)) c = W.level (σ + ℓ + ℓ) c + (k + 1) * M :=
      (ramp (k + 1) (Nat.le_add_left _ ℓ)).trans (congrArg (· + (k + 1) * M) heldTrough)
    have index : σ + ℓ + r + (k + 1) + ℓ = σ + ℓ + r + ℓ + (k + 1) := Nat.add_right_comm _ _ _
    refine ⟨σ + ℓ + r + (k + 1), Nat.lt_succ_of_le ?_, ⟨fun i lt => ?_, ?_, ?_, ?_⟩⟩
    · exact Nat.le_trans (Nat.le_add_right σ ℓ)
        (Nat.le_trans (Nat.le_add_right _ r) (Nat.le_add_right _ k))
    · have index' : σ + ℓ + r + (k + 1) + i = σ + ℓ + r + (k + 1 + i) := Nat.add_assoc _ _ _
      rw [index']
      exact readings (k + 1 + i) (Nat.lt_of_lt_of_le (Nat.add_lt_add_left lt (k + 1))
        (Nat.le_of_eq (Nat.add_comm (k + 1) ℓ)))
    · rw [index, up]
      exact kReach
    · rw [index, up]
      exact Nat.lt_of_le_of_lt
        (Nat.le_of_eq ((congrArg (_ + ·) (Nat.succ_mul k M)).trans (Nat.add_assoc _ _ _).symm))
        (Nat.add_lt_add_right (Nat.lt_of_not_le (kBefore k (Nat.lt_succ_self k))) M)
    · rw [index, up]
      exact Nat.lt_of_lt_of_le down.near (Nat.le_trans (Nat.add_le_add_left (le_succ_mul k M) _)
        (Nat.le_of_eq ((congrArg (· + (k + 1) * M) trough.symm).trans (Nat.add_right_comm _ _ _))))

/-- Upward crossings recur: from one at `σ`, there is one at or after `σ + n` for every `n`. -/
theorem upCrossing_later (relays : L.RelaysLate W c ℓ a b M)
    (balances : ∀ t, L.BalancesOn W [c] t) (band : a ≤ b) {σ : Nat}
    (up : W.UpCrossing c ℓ a b M σ) : ∀ n, ∃ σ', σ + n ≤ σ' ∧ W.UpCrossing c ℓ a b M σ' := by
  intro n
  induction n with
  | zero => exact ⟨σ, Nat.le_refl σ, up⟩
  | succ n ih =>
    obtain ⟨σ₁, ge₁, up₁⟩ := ih
    obtain ⟨_, σ₂, lt₂, down₂⟩ := upCrossing_next relays balances band up₁
    obtain ⟨_, σ₃, lt₃, up₃⟩ := downCrossing_next relays balances band down₂
    exact ⟨σ₃, Nat.le_trans (Nat.succ_le_succ ge₁)
      (Nat.le_trans (Nat.succ_le_of_lt lt₂) (Nat.le_of_lt lt₃)), up₃⟩

/-- **A late relay that crosses once crosses without end.** From an upward crossing, after every
step the level is somewhere above `b` and somewhere below `a`. -/
theorem crossing_oscillates (relays : L.RelaysLate W c ℓ a b M)
    (balances : ∀ t, L.BalancesOn W [c] t) (band : a ≤ b) {σ : Nat}
    (up : W.UpCrossing c ℓ a b M σ) (N : Nat) :
    (∃ t, N ≤ t ∧ b < W.level t c) ∧ ∃ t, N ≤ t ∧ W.level t c < a := by
  obtain ⟨σ₁, ge₁, up₁⟩ := upCrossing_later relays balances band up N
  obtain ⟨high, σ₂, lt₂, down₂⟩ := upCrossing_next relays balances band up₁
  obtain ⟨low, _⟩ := downCrossing_next relays balances band down₂
  have N₁ : N ≤ σ₁ := Nat.le_trans (Nat.le_add_left N σ) ge₁
  exact ⟨⟨σ₁ + ℓ + ℓ, Nat.le_trans N₁
      (Nat.le_trans (Nat.le_add_right σ₁ ℓ) (Nat.le_add_right _ ℓ)), high⟩,
    ⟨σ₂ + ℓ + ℓ, Nat.le_trans N₁ (Nat.le_trans (Nat.le_of_lt lt₂)
      (Nat.le_trans (Nat.le_add_right σ₂ ℓ) (Nat.le_add_right _ ℓ))), low⟩⟩

/-- **From a held start, the relay crosses where its entry carried `ℓ M` further passes `b`.** -/
theorem held_crosses (relays : L.RelaysLate W c ℓ a b M) (balances : ∀ t, L.BalancesOn W [c] t)
    (band : a ≤ b) {x₀ k : Nat} (held : ∀ i, i ≤ ℓ → W.level i c = x₀) (low : x₀ < a)
    (ramp : ∀ i, i < k → x₀ + i * M < a) (enters : a ≤ x₀ + k * M)
    (beyond : b < x₀ + (ℓ + k) * M) : W.UpCrossing c ℓ a b M k := by
  have rise := held_rise relays balances band held low ramp
  have entry : W.level (k + ℓ) c = x₀ + k * M :=
    (congrArg (W.level · c) (Nat.add_comm k ℓ)).trans (rise k (Nat.le_add_left k ℓ))
  cases k with
  | zero =>
    exact absurd (Nat.lt_of_lt_of_le low (Nat.le_trans enters
      (Nat.le_of_eq (congrArg (x₀ + ·) (Nat.zero_mul M))))) (Nat.lt_irrefl _)
  | succ k =>
    refine ⟨fun i lt => ?_, Nat.le_trans enters (Nat.le_of_eq entry.symm), ?_, ?_⟩
    · cases Nat.le_total (k + 1 + i) ℓ with
      | inl early => exact Nat.lt_of_le_of_lt (Nat.le_of_eq (held _ early)) low
      | inr later =>
        obtain ⟨j, jn⟩ := Nat.le.dest later
        have jk : j < k + 1 := Nat.lt_of_add_lt_add_left (Nat.lt_of_le_of_lt (Nat.le_of_eq jn)
          (Nat.lt_of_lt_of_le (Nat.add_lt_add_left lt (k + 1))
            (Nat.le_of_eq (Nat.add_comm (k + 1) ℓ))))
        exact Nat.lt_of_le_of_lt (Nat.le_of_eq ((congrArg (W.level · c) jn).symm.trans
          (rise j (Nat.le_trans (Nat.le_of_lt jk) (Nat.le_add_left _ ℓ))))) (ramp j jk)
    · rw [entry]
      exact Nat.lt_of_le_of_lt
        (Nat.le_of_eq ((congrArg (x₀ + ·) (Nat.succ_mul k M)).trans (Nat.add_assoc _ _ _).symm))
        (Nat.add_lt_add_right (ramp k (Nat.lt_succ_self k)) M)
    · rw [entry]
      exact Nat.lt_of_lt_of_le beyond (Nat.le_of_eq
        ((congrArg (x₀ + ·) ((add_mul_split ℓ (k + 1) M).trans (Nat.add_comm _ _))).trans
          (Nat.add_assoc _ _ _).symm))

/-- **Past the threshold, a start held just below the band crosses without end.** With the level
held at `x₀ = a - 1` for the first `ℓ + 1` steps and `b + 2 ≤ a + (ℓ + 1) M`, after every step the
level is somewhere above `b` and somewhere below `a`. -/
theorem held_oscillates (relays : L.RelaysLate W c ℓ a b M)
    (balances : ∀ t, L.BalancesOn W [c] t) (band : a ≤ b) {x₀ : Nat}
    (held : ∀ i, i ≤ ℓ → W.level i c = x₀) (just : x₀ + 1 = a)
    (room : b + 2 ≤ a + (ℓ + 1) * M) (N : Nat) :
    (∃ t, N ≤ t ∧ b < W.level t c) ∧ ∃ t, N ≤ t ∧ W.level t c < a := by
  have low : x₀ < a := Nat.lt_of_lt_of_le (Nat.lt_succ_self x₀) (Nat.le_of_eq just)
  have pos : 1 ≤ M := by
    cases Nat.lt_or_ge 0 M with
    | inl p => exact p
    | inr z =>
      have zero : M = 0 := Nat.le_antisymm z (Nat.zero_le M)
      rw [zero] at room
      exact absurd (Nat.le_trans room
          (Nat.le_of_eq ((congrArg (a + ·) (Nat.mul_zero (ℓ + 1))).trans (Nat.add_zero a))))
        (Nat.not_le_of_lt (Nat.lt_of_le_of_lt band
          (Nat.lt_of_lt_of_le (Nat.lt_succ_self b) (Nat.le_succ _))))
  have ramp : ∀ i, i < 1 → x₀ + i * M < a := fun i lt =>
    have zero : i = 0 := Nat.le_antisymm (Nat.le_of_lt_succ lt) (Nat.zero_le i)
    Nat.lt_of_le_of_lt (Nat.le_of_eq ((congrArg (x₀ + · * M) zero).trans
      (congrArg (x₀ + ·) (Nat.zero_mul M)))) low
  have enters : a ≤ x₀ + 1 * M :=
    Nat.le_trans (Nat.le_of_eq just.symm)
      (Nat.add_le_add_left (Nat.le_trans pos (Nat.le_of_eq (Nat.one_mul M).symm)) x₀)
  have beyond : b < x₀ + (ℓ + 1) * M :=
    Nat.lt_of_succ_le (le_of_add_le_add_right 1 (Nat.le_trans room (Nat.le_of_eq
      ((congrArg (· + (ℓ + 1) * M) just.symm).trans (Nat.add_right_comm _ _ _)))))
  exact crossing_oscillates relays balances band
    (held_crosses relays balances band held low ramp enters beyond) N

/-- **Within the threshold, every start held below the band settles in it.** With a step `M > 0`
and `a + (ℓ + 1) M ≤ b + 1`, a level held below `a` for the first `ℓ + 1` steps is, from some step
on, constant within `[a, b]`. -/
theorem held_below_settles (relays : L.RelaysLate W c ℓ a b M)
    (balances : ∀ t, L.BalancesOn W [c] t) (band : a ≤ b) (pos : 0 < M) {x₀ : Nat}
    (held : ∀ i, i ≤ ℓ → W.level i c = x₀) (low : x₀ < a) (narrow : a + (ℓ + 1) * M ≤ b + 1) :
    ∃ T, ∀ j, a ≤ W.level (T + j) c ∧ W.level (T + j) c ≤ b := by
  have reach : a ≤ x₀ + a * M := Nat.le_trans
    (Nat.le_trans (Nat.le_of_eq (Nat.mul_one a).symm) (Nat.mul_le_mul_left a pos))
    (Nat.le_add_left _ x₀)
  obtain ⟨k, _, enters, before⟩ := first_index (P := fun k => a ≤ x₀ + k * M) reach
  have ramp : ∀ i, i < k → x₀ + i * M < a := fun i lt => Nat.lt_of_not_le (before i lt)
  cases k with
  | zero =>
    exact absurd (Nat.lt_of_lt_of_le low (Nat.le_trans enters
      (Nat.le_of_eq (congrArg (x₀ + ·) (Nat.zero_mul M))))) (Nat.lt_irrefl _)
  | succ k =>
    have within : x₀ + (ℓ + (k + 1)) * M ≤ b := by
      have sum : x₀ + (ℓ + (k + 1)) * M = x₀ + k * M + (ℓ * M + M) := by
        rw [add_mul_split, Nat.succ_mul]
        conv => lhs; simp only [Nat.add_comm, Nat.add_left_comm, Nat.add_assoc]
        conv => rhs; simp only [Nat.add_comm, Nat.add_left_comm, Nat.add_assoc]
      have sm : a + (ℓ * M + M) = a + (ℓ + 1) * M := congrArg (a + ·) (Nat.succ_mul ℓ M).symm
      rw [sum]
      exact Nat.le_of_lt_succ (Nat.lt_of_lt_of_le
        (Nat.add_lt_add_right (ramp k (Nat.lt_succ_self k)) _)
        (Nat.le_trans (Nat.le_of_eq sm) narrow))
    have settles := held_settles relays balances band held low ramp enters within
    exact ⟨ℓ + (ℓ + (k + 1)), fun j =>
      ⟨Nat.le_trans (Nat.le_trans enters (Nat.add_le_add_left
          (Nat.mul_le_mul_right M (Nat.le_add_left (k + 1) ℓ)) x₀)) (Nat.le_of_eq (settles j).symm),
       Nat.le_trans (Nat.le_of_eq (settles j)) within⟩⟩

/-! ### Runs of the late relay -/

/-- **The window of the late relay.** The window holds the levels at the `ℓ + 1` steps from the
present one. A step drops the oldest and adds a newest: the present newest with what the relay gives
for the oldest added, and what it takes removed. -/
def relayWindow (ℓ a b M : Nat) (w : Nat → Nat) : Nat → Nat := fun i =>
  if i < ℓ then w (i + 1) else w ℓ + (relay a b M (w 0)).1 - (relay a b M (w 0)).2

/-- The level of the late relay held at `x₀` for its first `ℓ + 1` steps: the oldest place of its
window along the window's orbit. -/
def relayLevel (ℓ a b M x₀ t : Nat) : Nat :=
  Law.orbit (relayWindow ℓ a b M) (fun _ => x₀) t 0

theorem relayWindow_shift (ℓ a b M x₀ t : Nat) : ∀ j i, i + j ≤ ℓ →
    Law.orbit (relayWindow ℓ a b M) (fun _ => x₀) (t + j) i =
      Law.orbit (relayWindow ℓ a b M) (fun _ => x₀) t (i + j)
  | 0, _, _ => rfl
  | j + 1, i, le => by
    have lt : i < ℓ := Nat.lt_of_lt_of_le (Nat.lt_of_lt_of_le (Nat.lt_succ_self i)
      (Nat.add_le_add_left (Nat.succ_le_succ (Nat.zero_le j)) i)) le
    have le' : i + 1 + j ≤ ℓ := Nat.le_trans (Nat.le_of_eq (Nat.add_right_comm i 1 j)) le
    show relayWindow ℓ a b M (Law.orbit (relayWindow ℓ a b M) (fun _ => x₀) (t + j)) i = _
    exact (if_pos lt).trans ((relayWindow_shift ℓ a b M x₀ t j (i + 1) le').trans
      (congrArg (Law.orbit (relayWindow ℓ a b M) (fun _ => x₀) t) (Nat.add_right_comm i 1 j)))

/-- The relay's level is held at `x₀` for the first `ℓ + 1` steps. -/
theorem relayLevel_held (ℓ a b M x₀ : Nat) {t : Nat} (early : t ≤ ℓ) :
    relayLevel ℓ a b M x₀ t = x₀ :=
  (congrArg (fun s => Law.orbit (relayWindow ℓ a b M) (fun _ => x₀) s 0) (Nat.zero_add t).symm).trans
    (relayWindow_shift ℓ a b M x₀ 0 t 0 (Nat.le_trans (Nat.le_of_eq (Nat.zero_add t)) early))

/-- **The relay's step.** The level `ℓ + 1` steps on is the level `ℓ` steps on, with what the relay
gives for the present level added and what it takes removed. -/
theorem relayLevel_step (ℓ a b M x₀ t : Nat) :
    relayLevel ℓ a b M x₀ (t + ℓ + 1) = relayLevel ℓ a b M x₀ (t + ℓ) +
      (relay a b M (relayLevel ℓ a b M x₀ t)).1 - (relay a b M (relayLevel ℓ a b M x₀ t)).2 := by
  have index : t + ℓ + 1 = t + 1 + ℓ := Nat.add_right_comm t ℓ 1
  have shifted := relayWindow_shift ℓ a b M x₀ (t + 1) ℓ 0 (Nat.le_of_eq (Nat.zero_add ℓ))
  have now := relayWindow_shift ℓ a b M x₀ t ℓ 0 (Nat.le_of_eq (Nat.zero_add ℓ))
  unfold relayLevel
  rw [index, shifted, now, Nat.zero_add]
  show relayWindow ℓ a b M (Law.orbit (relayWindow ℓ a b M) (fun _ => x₀) t) ℓ = _
  exact if_neg (Nat.lt_irrefl ℓ)

/-- What the relay takes is at most one step `M`. -/
theorem relay_take_le (a b M r : Nat) : (relay a b M r).2 ≤ M := by
  show (if b < r then M else 0) ≤ M
  split
  · exact Nat.le_refl M
  · exact Nat.zero_le M

/-- What the relay takes is nothing unless it reads above `b`. -/
theorem relay_take_of_le {a b M r : Nat} (le : r ≤ b) : (relay a b M r).2 = 0 :=
  if_neg (Nat.not_lt_of_le le)

/-- `n ≤ n - q + q`. -/
theorem le_sub_add (n q : Nat) : n ≤ n - q + q :=
  match Nat.le_total q n with
  | .inl le => Nat.le_of_eq ((add_sub_of_le le).symm.trans (Nat.add_comm _ _))
  | .inr le => Nat.le_trans le (Nat.le_add_left q _)

/-- The relay's level falls by at most one step `M` a step. -/
theorem relayLevel_drop (ℓ a b M x₀ s : Nat) :
    relayLevel ℓ a b M x₀ s ≤ relayLevel ℓ a b M x₀ (s + 1) + M := by
  cases Nat.lt_or_ge s ℓ with
  | inl early =>
    rw [relayLevel_held ℓ a b M x₀ early, relayLevel_held ℓ a b M x₀ (Nat.le_of_lt early)]
    exact Nat.le_add_right x₀ M
  | inr later =>
    obtain ⟨t, ts⟩ := Nat.le.dest later
    subst ts
    rw [Nat.add_comm ℓ t, relayLevel_step]
    exact Nat.le_trans (Nat.le_add_right _ _)
      (Nat.le_trans (le_sub_add _ _) (Nat.add_le_add_left (relay_take_le a b M _) _))

/-- Over `i` steps the relay's level falls by at most `i M`. -/
theorem relayLevel_drops (ℓ a b M x₀ t : Nat) : ∀ i,
    relayLevel ℓ a b M x₀ t ≤ relayLevel ℓ a b M x₀ (t + i) + i * M
  | 0 => Nat.le_trans (Nat.le_add_right _ _)
      (Nat.le_of_eq (congrArg (relayLevel ℓ a b M x₀ t + ·) (Nat.zero_mul M).symm))
  | i + 1 => Nat.le_trans (relayLevel_drops ℓ a b M x₀ t i) (Nat.le_trans
      (Nat.add_le_add_right (relayLevel_drop ℓ a b M x₀ (t + i)) _)
      (Nat.le_of_eq ((Nat.add_assoc _ _ _).trans (congrArg (relayLevel ℓ a b M x₀ (t + i + 1) + ·)
        ((Nat.add_comm M (i * M)).trans (Nat.succ_mul i M).symm)))))

/-- **The relay never takes more than is there,** where one step more than lateness times step is
within `b + 1`: a reading above `b` comes at least `(ℓ + 1) M` above nothing, and at most `ℓ` steps
of `M` have been taken since. -/
theorem relay_room {ℓ a b M : Nat} (floor : (ℓ + 1) * M ≤ b + 1) (x₀ t : Nat) :
    (relay a b M (relayLevel ℓ a b M x₀ t)).2 ≤
      relayLevel ℓ a b M x₀ (t + ℓ) + (relay a b M (relayLevel ℓ a b M x₀ t)).1 := by
  cases Nat.lt_or_ge b (relayLevel ℓ a b M x₀ t) with
  | inl above =>
    have takes : (relay a b M (relayLevel ℓ a b M x₀ t)).2 = M := if_pos above
    rw [takes]
    have drops := relayLevel_drops ℓ a b M x₀ t ℓ
    have chain : ℓ * M + M ≤ relayLevel ℓ a b M x₀ (t + ℓ) + ℓ * M :=
      Nat.le_trans (Nat.le_of_eq (Nat.succ_mul ℓ M).symm)
        (Nat.le_trans floor (Nat.le_trans (Nat.succ_le_of_lt above) drops))
    exact Nat.le_trans (le_of_add_le_add_right (ℓ * M)
      (Nat.le_trans (Nat.le_of_eq (Nat.add_comm M (ℓ * M))) chain)) (Nat.le_add_right _ _)
  | inr within =>
    rw [relay_take_of_le within]
    exact Nat.zero_le _

/-- The flow of the late relay at one condition: from step `ℓ` on, what the relay gives and takes
for the level `ℓ` steps before. -/
def relayFlow (ℓ a b M x₀ : Nat) : Flow Unit Unit :=
  ⟨fun _ => [()],
   fun s _ _ => if ℓ ≤ s then (relay a b M (relayLevel ℓ a b M x₀ (s - ℓ))).2 else 0,
   fun s _ _ => if ℓ ≤ s then (relay a b M (relayLevel ℓ a b M x₀ (s - ℓ))).1 else 0⟩

/-- The web of the late relay: its level, with nothing else recorded. -/
def relayWeb (ℓ a b M x₀ : Nat) : Web Unit Unit :=
  ⟨fun t _ => relayLevel ℓ a b M x₀ t, fun _ _ => True, fun _ _ _ => False, fun _ _ _ => 0,
   fun _ _ _ => False⟩

theorem relayFlow_late (ℓ a b M x₀ t : Nat) :
    (relayFlow ℓ a b M x₀).given (t + ℓ) () = (relay a b M (relayLevel ℓ a b M x₀ t)).1 ∧
      (relayFlow ℓ a b M x₀).taken (t + ℓ) () = (relay a b M (relayLevel ℓ a b M x₀ t)).2 := by
  have back : t + ℓ - ℓ = t :=
    (congrArg (· - ℓ) (Nat.add_comm t ℓ)).trans (Naturals.add_sub_cancel_left ℓ t)
  constructor
  · show (if ℓ ≤ t + ℓ then (relay a b M (relayLevel ℓ a b M x₀ (t + ℓ - ℓ))).1 else 0) + 0 = _
    rw [if_pos (Nat.le_add_left ℓ t), back]
    rfl
  · show (if ℓ ≤ t + ℓ then (relay a b M (relayLevel ℓ a b M x₀ (t + ℓ - ℓ))).2 else 0) + 0 = _
    rw [if_pos (Nat.le_add_left ℓ t), back]
    rfl

/-- The late relay's run is balanced at every step, where `(ℓ + 1) M ≤ b + 1`. -/
theorem relay_balances {ℓ a b M : Nat} (floor : (ℓ + 1) * M ≤ b + 1) (x₀ s : Nat) :
    (relayFlow ℓ a b M x₀).BalancesOn (relayWeb ℓ a b M x₀) [()] s := by
  intro c _
  cases c
  cases Nat.lt_or_ge s ℓ with
  | inl early =>
    show relayLevel ℓ a b M x₀ (s + 1) +
        ((if ℓ ≤ s then (relay a b M (relayLevel ℓ a b M x₀ (s - ℓ))).2 else 0) + 0) =
      relayLevel ℓ a b M x₀ s +
        ((if ℓ ≤ s then (relay a b M (relayLevel ℓ a b M x₀ (s - ℓ))).1 else 0) + 0)
    rw [if_neg (Nat.not_le_of_lt early), if_neg (Nat.not_le_of_lt early),
      relayLevel_held ℓ a b M x₀ early, relayLevel_held ℓ a b M x₀ (Nat.le_of_lt early)]
  | inr later =>
    obtain ⟨t, ts⟩ := Nat.le.dest later
    have index : ℓ + t = t + ℓ := Nat.add_comm ℓ t
    rw [← ts, index]
    have late := relayFlow_late ℓ a b M x₀ t
    show relayLevel ℓ a b M x₀ (t + ℓ + 1) + (relayFlow ℓ a b M x₀).taken (t + ℓ) () =
      relayLevel ℓ a b M x₀ (t + ℓ) + (relayFlow ℓ a b M x₀).given (t + ℓ) ()
    rw [late.1, late.2, relayLevel_step]
    exact (Nat.add_comm _ _).trans (add_sub_of_le (relay_room floor x₀ t))

/-- **The late relay runs.** For every lateness `ℓ`, band `[a, b]`, step `M` with
`(ℓ + 1) M ≤ b + 1` and start `x₀`, there is a run at one condition that relays `ℓ` steps late,
balances at every step, and holds the level at `x₀` for the first `ℓ + 1` steps. -/
theorem relay_runs {ℓ a b M : Nat} (floor : (ℓ + 1) * M ≤ b + 1) (x₀ : Nat) :
    (relayFlow ℓ a b M x₀).RelaysLate (relayWeb ℓ a b M x₀) () ℓ a b M ∧
      (∀ t, (relayFlow ℓ a b M x₀).BalancesOn (relayWeb ℓ a b M x₀) [()] t) ∧
      ∀ i, i ≤ ℓ → (relayWeb ℓ a b M x₀).level i () = x₀ :=
  ⟨relayFlow_late ℓ a b M x₀, relay_balances floor x₀,
   fun _ early => relayLevel_held ℓ a b M x₀ early⟩

/-- **The threshold of the late relay.** For a band `[a, b]` with `0 < a`, a step `M > 0` with
`(ℓ + 1) M ≤ b + 1`, every run of the relay reading `ℓ` steps late, from every start held below `a`
for its first `ℓ + 1` steps, settles in the band exactly where `a + (ℓ + 1) M ≤ b + 1`. Past the
threshold the start held at `a - 1` crosses both ends without end (`held_oscillates`): the least
band the relay keeps grows with lateness times step. -/
theorem relay_threshold {ℓ a b M : Nat} (band : a ≤ b) (pos : 0 < a) (step : 0 < M)
    (floor : (ℓ + 1) * M ≤ b + 1) :
    (∀ x₀, x₀ < a → ∀ {F' C' : Type} (L' : Flow F' C') (W' : Web F' C') (c' : C'),
        L'.RelaysLate W' c' ℓ a b M → (∀ t, L'.BalancesOn W' [c'] t) →
        (∀ i, i ≤ ℓ → W'.level i c' = x₀) →
        ∃ T, ∀ j, a ≤ W'.level (T + j) c' ∧ W'.level (T + j) c' ≤ b) ↔
      a + (ℓ + 1) * M ≤ b + 1 := by
  constructor
  · intro settles
    cases Nat.lt_or_ge (b + 1) (a + (ℓ + 1) * M) with
    | inr narrow => exact narrow
    | inl room =>
      obtain ⟨x₀, just⟩ := Nat.le.dest pos
      have just' : x₀ + 1 = a := (Nat.add_comm x₀ 1).trans just
      obtain ⟨relays, balances, held⟩ := relay_runs (a := a) floor x₀
      obtain ⟨T, within⟩ := settles x₀
        (Nat.lt_of_lt_of_le (Nat.lt_succ_self x₀) (Nat.le_of_eq just')) _ _ () relays balances held
      obtain ⟨⟨t, Tt, high⟩, _⟩ := held_oscillates relays balances band held just' room T
      obtain ⟨j, jt⟩ := Nat.le.dest Tt
      exact absurd (Nat.lt_of_lt_of_le high (Nat.le_trans
        (Nat.le_of_eq (congrArg (fun s => (relayWeb ℓ a b M x₀).level s ()) jt.symm))
        (within j).2)) (Nat.lt_irrefl b)
  · intro narrow x₀ low F' C' L' W' c' relays balances held
    exact held_below_settles relays balances band step held low narrow

end Regulation

end Becoming
