import Becoming.Closing

/-!
# Frequency: how often couplings act

`Becoming.Loops` (P118) shows that a loop coupling at every step makes the most difference that can
arrive run away, at least geometrically, and `Becoming.Remainder` (P120) that for every schedule of
couplings the loops that matter for a cut are those of the couplings that go on. P120 leaves three
questions open: whether every schedule settles, whether every loop of recurring couplings makes the
most difference that can arrive run away, and how fast a runaway is. This module answers them,
within the theory without axiom and with no premise beyond the strengths each statement names. How fast is fixed by
how often couplings act, not by how strong they are; a loop that recurs need not run away; and that
every schedule settles is a principle of reasoning, exactly.

* **The rate.** A schedule `on : Nat → Bool` marks steps, and `Frequency.count on t` counts the
  marked steps before `t`. With the part giving no gap after the start, starting gaps at most `D`,
  and the strengths into each condition summing to at most `M` at each step and to nothing at the
  unmarked steps, the carried amount at step `t` is at most `D * (1 + M) ^ a`, `a` the number of
  marked steps before `t` (`carried_le_count`). With every condition listed, the steps at which
  anything couples (`Frequency.coupling`) are such a schedule (`carried_le_coupling`). One condition
  returning its level to itself with strength `M` at the steps of any schedule
  (`Frequency.SelfLoop`), coupling exactly there (`Frequency.SelfLoop.couplesAt_iff`), carries
  exactly `D * (1 + M) ^ a` (`Frequency.SelfLoop.carried_eq`): no smaller bound follows from `D`,
  `M` and the steps at which couplings act. By `most_difference_arrives`, the rate bounds every gap
  of every law with the strengths (`gap_le_count`).
* **Runaway needs frequent couplings, not strong ones.** A chain in time order (`ChainInTime`)
  carries what has reached its start to its end (`carried_along_in_time`); a return (`RoundTrip`) is
  such a chain from a condition back to it. Every return at least doubles what had reached the
  condition, which arrives once held and once around the loop (`carried_doubles_roundTrip`).
  Strengths are natural numbers, so a positive strength is at least one; with strengths below one
  the doubling does not follow. After `R` returns in succession it has doubled `R` times
  (`carried_roundTrip`). So where something has reached a condition and returns at steps `T i` with
  `2 ^ i` outgrowing every polynomial in `T i`, the carried amount there, the most difference that
  can arrive, outgrows every polynomial (`runaway_of_roundTrip`). Conversely, where two to the number
  of steps at which anything couples is at most a polynomial in the steps, so is the carried amount,
  whatever the strengths, of degree `n * M` (`carried_le_of_rare`). For a self-loop the two meet: it
  is bounded by a polynomial exactly where two to the number of steps at which it couples is,
  whatever its positive strength (`Frequency.SelfLoop.polynomial_iff`). For a self-loop, how often
  it couples sets whether the growth is polynomial, and how strong only how large.
* **A loop that recurs need not run away.** The sparse schedule (`Frequency.Sparse.on`) marks the
  steps one less than a power of two, `0, 1, 3, 7, …`. It marks steps as late as one likes
  (`Frequency.Sparse.often`), and two to its count before `t` is at most `2 * (t + 1)`
  (`Frequency.Sparse.rare`). The self-loop coupling at its steps recurs (`Frequency.Sparse.recurs`),
  so from a positive start every finite order of it misses something (`Frequency.Sparse.inexact`, by
  `carriedWithin_lt_of_recurring_loop`), and yet the carried amount is at most
  `D * 2 ^ M * (t + 1) ^ M` (`Frequency.Sparse.polynomial`). A loop of recurring couplings leaves
  every finite order inexact; whether it runs away depends on how often it returns.
* **Settling is local.** A coupling stops by step `N` (`StopsBy`) where none of its couplings reads
  a level from `N` on, and one that stops does not recur (`StopsBy.not_recurs`). With every
  condition listed, where each coupling recurs or stops, the schedule has settled by some step
  (`settled_of_each`).
* **Settling for every schedule is a principle of reasoning, exactly.** Whether, at step `m`, a
  coupling reads a level from step `n` on is decided (`Frequency.readsLate`). So each coupling
  recurs or stops wherever every decided two-place family of Booleans has every row `true` somewhere
  or some row `false` throughout (`RecursOrStops`, `recurs_or_stops`), and then every schedule
  settles (`settled_of_recursOrStops`). Conversely, every schedule of one condition coupled into
  itself settles exactly where this dichotomy holds (`settled_iff_recursOrStops`), and so does every
  schedule of every world with its conditions listed (`settled_every_iff`). Even the schedules that
  couple at most once (`Frequency.First.once`), at the first step at which a decided sequence is
  `true`, all settle only where the limited principle of omniscience holds (`lpo_of_settled`), which
  the dichotomy gives (`RecursOrStops.lpo`). The core takes no excluded middle and does not assert
  that every schedule settles; where one has, `finite_order_iff_no_loop_from` applies.
* **Instances.** The self-loop of `Becoming.Loops` couples at every step
  (`Frequency.SelfLoop.always`, `Frequency.SelfLoop.always_carried`). The loop of
  `Becoming.Closing` forming at step `T` couples at the steps from `T` (`Frequency.SelfLoop.onset`),
  so its doubling after `T` is the rate (`Closing.Onset.amount_after`).
* **A coupling saturated by what it has carried.** Strengths may be read off the amount already
  passed through each coupling. `Saturation.passed` is what has passed from `d` into `c` before a
  step, and `Saturation.strengths` gives each reading of `d` into `c` the strength `sat a`, `a` that
  amount. They read the levels before (`Saturation.readsBefore`), so the carrying law with them
  generates a course, and what passes is what the course carries through the coupling
  (`Saturation.course_succ`). Where the strengths are zero once `A` has passed, and `A` has passed
  by step `N`, the coupling stops by `N` (`Saturation.stops`): it does not recur
  (`Saturation.not_recurs`) and nothing more passes (`Saturation.passed_from`), and where every
  coupling has saturated a finite order is exact (`Saturation.exact`). What passes in all is below
  `A + m`, `m` the most one step passes (`Saturation.passed_lt`). A coupling that acts at each step until
  it saturates, from a level that stands, has passed `A` by step `A` and stops there
  (`Saturation.stops_by`; in the formed course, from a level standing at the start,
  `Saturation.course_stops_by`). With strengths `f a` times a
  coupling acting at each step, `f` not rising, the coupling stops by step `A` where `f` is zero at
  `A` (`Saturation.stops_by_zero`), and stops by some step exactly where `f` reaches zero at some
  amount (`Saturation.stops_iff`; in the formed course `Saturation.course_stops_iff`); with `f` at least one it recurs and at least one more passes at
  every step, however far it has weakened (`Saturation.floored`), and coupled into itself it is a
  loop that leaves every finite order inexact (`Saturation.floored_inexact`). In the formed course a
  response `A - a` stops it by step `A` (`Saturation.wearing_stops`).

**Readings (the AI's, D43).**
- On 12 October Ren asked of the loops "how how accurate can we do that uh what is the limitation do
  we have losses". The rate says how fast the most difference that can arrive grows: `D` times
  `1 + M` to the number of steps at which couplings act, and this is attained. A runaway is set by
  how often couplings act, not by how strong they are. A loop at least doubles what reaches it at
  every return, so a loop that returns often enough runs away whatever its strength. A loop that
  acts only logarithmically often stays polynomial whatever its strength, which then sets only the
  degree.
- On 16 October Ren called the AI's reading of "only a loop makes a difference run away" right, a
  reading that left couplings at only some steps open. That case now closes in both directions.
  Only a loop of the couplings that go on can make the most difference that can arrive run away
  (`carried_le_polynomial_from`), and such a loop need not (`Frequency.Sparse`): it runs away where
  it returns often enough (`runaway_of_roundTrip`). For a self-loop, how often it couples decides
  exactly.
- That every schedule settles is not something the theory can assert or deny of the unfolding: it
  is equivalent to a principle of reasoning about decided sequences, a dichotomy of the form "every
  row somewhere, or some row nowhere", which gives the limited principle of omniscience. So the
  theorems take a settled schedule as a premise where they need one. Settling is local and finite
  wherever each coupling recurs or stops.

What is not derived: the strengths themselves; how often a world's couplings act, which the
schedule takes as given (a schedule read off the course, as in `Becoming.Closing`, is one case);
whether, beyond the self-loop, the most difference that can arrive meets either bound, `2` to the
number of returns from below or `1 + M` to the number of steps at which anything couples from
above; real amounts, where a positive strength can be below one, each return multiplies by one plus
the product of the strengths around the loop, and strengths shrinking fast enough could keep
frequent returns from running away; the spectral radius of given strengths; laws reading infinitely
many conditions at a step; continuous time. The representation commits to discrete steps and natural
amounts. No ethical predicate, ranking or axiom occurs.

**Classical sources.** The carried amount and its orders are a truncated path-sum (Neumann series)
expansion, as in `Becoming.Loops` and `Becoming.Remainder`; the bound `D * (1 + M) ^ a` is the
geometric bound of that series counted over the marked steps. The limited principle of omniscience
is Bishop's (Bishop 1967; Bridges and Richman 1987), and `settled_iff_recursOrStops` with
`lpo_of_settled` calibrates settling in the manner of constructive reverse mathematics (Ishihara).
`RecursOrStops` is excluded middle at level Σ⁰₂ of the arithmetical hierarchy (Akama, Berardi,
Hayashi and Kohlenbach 2004), strictly stronger than `LPO`: it gives `LPO` here
(`RecursOrStops.lpo`), and the converse is neither stated nor, by that hierarchy, available.
-/

namespace Becoming

variable {F C : Type}

/-! ## Counting the steps a schedule marks -/

namespace Frequency

/-- How many of the steps before `t` a schedule marks. -/
def count (on : Nat → Bool) : Nat → Nat
  | 0 => 0
  | t + 1 => count on t + (bif on t then 1 else 0)

theorem count_succ_on {on : Nat → Bool} {t : Nat} (yes : on t = true) :
    count on (t + 1) = count on t + 1 :=
  congrArg (fun b => count on t + (bif b then 1 else 0)) yes

theorem count_succ_off {on : Nat → Bool} {t : Nat} (no : on t = false) :
    count on (t + 1) = count on t :=
  congrArg (fun b => count on t + (bif b then 1 else 0)) no

theorem bif_le (M : Nat) : ∀ b : Bool, (bif b then M else 0) ≤ M
  | true => Nat.le_refl M
  | false => Nat.zero_le M

theorem count_le_succ (on : Nat → Bool) (t : Nat) : count on t ≤ count on (t + 1) :=
  Nat.le_add_right _ _

theorem count_mono (on : Nat → Bool) {s t : Nat} (le : s ≤ t) : count on s ≤ count on t := by
  induction le with
  | refl => exact Nat.le_refl _
  | step _ ih => exact Nat.le_trans ih (count_le_succ on _)

/-- A schedule marks at most every step. -/
theorem count_le (on : Nat → Bool) : ∀ t, count on t ≤ t
  | 0 => Nat.le_refl 0
  | t + 1 => Nat.add_le_add (count_le on t) (cond_le_one (on t))

/-- **Where the count rises past `N`'s, a step from `N` on is marked.** -/
theorem marked_between (on : Nat → Bool) (N : Nat) :
    ∀ t, count on N < count on t → ∃ u, N ≤ u ∧ u < t ∧ on u = true
  | 0, lt => absurd lt (Nat.not_lt_zero _)
  | t + 1, lt => match hon : on t with
    | true => match Nat.lt_or_ge t N with
      | .inl before =>
        absurd (Nat.lt_of_lt_of_le lt (count_mono on (Nat.succ_le_of_lt before))) (Nat.lt_irrefl _)
      | .inr after => ⟨t, after, Nat.lt_succ_self t, hon⟩
    | false =>
      match marked_between on N t (Nat.lt_of_lt_of_le lt (Nat.le_of_eq (count_succ_off hon))) with
      | ⟨u, le, below, yes⟩ => ⟨u, le, Nat.lt_succ_of_lt below, yes⟩

/-- **A schedule whose count is unbounded marks steps as late as one likes.** -/
theorem recurs_of_unbounded {on : Nat → Bool} (unbounded : ∀ N, ∃ t, count on N < count on t)
    (N : Nat) : ∃ u, N ≤ u ∧ on u = true :=
  match unbounded N with
  | ⟨t, lt⟩ => match marked_between on N t lt with
    | ⟨u, le, _, yes⟩ => ⟨u, le, yes⟩

/-- One step of the rate: `D * (1 + M) ^ a` grows by the factor `1 + M` where the schedule marks the
step, and not otherwise. -/
theorem step_eq (on : Nat → Bool) (M D t : Nat) :
    D * (1 + M) ^ count on t + (bif on t then M else 0) * (D * (1 + M) ^ count on t) =
      D * (1 + M) ^ count on (t + 1) := by
  cases hon : on t with
  | true =>
    exact (Loops.one_add_mul M _).symm.trans
      ((mul_turn (1 + M) D _).trans (congrArg (D * ·)
        ((Nat.mul_comm (1 + M) _).trans
          (congrArg ((1 + M) ^ ·) (count_succ_on hon).symm))))
  | false =>
    exact ((congrArg (_ + ·) (Nat.zero_mul _)).trans (Nat.add_zero _)).trans
      (congrArg (fun n => D * (1 + M) ^ n) (count_succ_off hon).symm)

/-- One plus a number is at most two to its power. -/
theorem succ_le_two_pow (M : Nat) : 1 + M ≤ 2 ^ M :=
  Nat.le_trans (Nat.le_of_eq (Nat.add_comm 1 M)) (Nat.succ_le_of_lt (Loops.lt_two_pow M))

/-- `(1 + M) ^ a` is at most `(2 ^ a) ^ M`. -/
theorem pow_le_two_pow_pow (M a : Nat) : (1 + M) ^ a ≤ (2 ^ a) ^ M :=
  Nat.le_trans (Loops.pow_le_pow_base (succ_le_two_pow M) a)
    (Nat.le_of_eq ((Loops.pow_mul_nat 2 M a).trans
      ((congrArg (2 ^ ·) (Nat.mul_comm M a)).trans (Loops.pow_mul_nat 2 a M).symm)))

end Frequency

/-! ## The rate -/

section Rate

variable {cs : List C} {part : F → Bool}
  {k : Nat → F → C → Nat → C → Nat} {present : Nat → List F} {δ : C → Nat}

/-- The strengths into a condition at a step read only the strengths at that step. -/
theorem inflow_congr_strength {k' : Nat → F → C → Nat → C → Nat} {t : Nat} {c : C}
    (same : ∀ h s d, k' t h c s d = k t h c s d) :
    inflow cs part k' present t c = inflow cs part k present t c :=
  total_congr (fun h => congrArg (fun x => bif part h then 0 else x)
    (total_congr (fun s => total_congr (fun d => same h s d) cs) _)) _

/-- A formation's gift with the part's gaps is its gift with the part giving none, and the part's
gap. -/
theorem carriedGive_with_gaps {σ : Nat → F → C → Nat} (t : Nat) (h : F) (c : C)
    (l : Nat → C → Nat) :
    carriedGive cs part σ k t h c l =
      (bif part h then σ t h c else 0) + carriedGive cs part (fun _ _ _ => 0) k t h c l := by
  cases hp : part h with
  | true =>
    exact (carriedGive_of_part hp).trans ((Nat.add_zero _).symm.trans
      (congrArg (σ t h c + ·) (carriedGive_of_part (σ := fun _ _ _ => 0) hp).symm))
  | false =>
    exact (carriedGive_of_rest hp).trans ((Nat.zero_add _).symm.trans
      (congrArg (0 + ·) (carriedGive_of_rest (σ := fun _ _ _ => 0) hp).symm))

/-- One plus a number to any power is at least one. -/
theorem one_le_pow_add (M : Nat) : ∀ n, 1 ≤ (1 + M) ^ n
  | 0 => Nat.le_refl 1
  | n + 1 => Nat.le_trans (one_le_pow_add M n)
      (Nat.le_trans (Nat.le_of_eq (Nat.mul_one _).symm) (Nat.mul_le_mul_left _ (Nat.le_add_right 1 M)))

/-- A disturbance of `E` at a step the schedule `dis` marks adds `E` to `E` times the count. -/
theorem count_step (dis : Nat → Bool) (D E t : Nat) :
    D + E * Frequency.count dis t + (bif dis t then E else 0) = D + E * Frequency.count dis (t + 1) := by
  cases hd : dis t with
  | true =>
    exact (Nat.add_assoc _ _ _).trans (congrArg (D + ·)
      (congrArg (E * ·) (Frequency.count_succ_on hd).symm))
  | false =>
    exact (Nat.add_zero _).trans (congrArg (fun n => D + E * n) (Frequency.count_succ_off hd).symm)

/-- **Repeated disturbance.** With the part giving gaps at most `E` at the steps a schedule `dis`
marks and none at the others, starting gaps at most `D`, the strengths into each condition summing
to at most `M` at each step and to nothing at the steps `on` leaves unmarked, the carried amount at
step `t` is at most `(D + E * d) * (1 + M) ^ a`, `d` the number of disturbed steps before `t` and
`a` the number of coupling steps: each disturbance adds what the couplings after it multiply. -/
theorem carried_le_disturbed {σ : Nat → F → C → Nat} {M D E : Nat} {on dis : Nat → Bool}
    (start : ∀ c, δ c ≤ D) (into : ∀ t c, inflow cs part k present t c ≤ M)
    (quiet : ∀ t c, on t = false → inflow cs part k present t c = 0)
    (gaps : ∀ t c, total (present t) (fun h => bif part h then σ t h c else 0) ≤
      bif dis t then E else 0) :
    ∀ t c, carried cs part σ k present δ t c ≤
      (D + E * Frequency.count dis t) * (1 + M) ^ Frequency.count on t := by
  intro t
  induction t with
  | zero => intro c; exact Nat.le_trans (start c) (Nat.le_of_eq (Nat.mul_one D).symm)
  | succ t ih =>
    intro c
    have gives := total_give_le_inflow (cs := cs) (part := part) (k := k) (present := present)
      (t := t) (c := c) (l := carried cs part σ k present δ)
      (X := (D + E * Frequency.count dis t) * (1 + M) ^ Frequency.count on t)
      (fun s d le _ => Nat.le_trans (carried_mono_steps le d) (ih d))
    have rate : inflow cs part k present t c ≤ bif on t then M else 0 := by
      cases hon : on t with
      | true => exact into t c
      | false => exact Nat.le_of_eq (quiet t c hon)
    have split :
        (total (present t) fun h => carriedGive cs part σ k t h c (carried cs part σ k present δ)) =
          total (present t) (fun h => bif part h then σ t h c else 0) +
            total (present t) (fun h =>
              carriedGive cs part (fun _ _ _ => 0) k t h c (carried cs part σ k present δ)) :=
      (total_congr (fun h => carriedGive_with_gaps t h c _) _).trans (total_add _ _ _)
    have one := one_le_pow_add M (Frequency.count on (t + 1))
    have fin : ∀ Y e P : Nat, Y * P + e * P = (Y + e) * P := fun Y e P =>
      ((congrArg (· + e * P) (Nat.mul_comm Y P)).trans ((congrArg (P * Y + ·) (Nat.mul_comm e P)).trans
        (Nat.left_distrib P Y e).symm)).trans (Nat.mul_comm P (Y + e))
    exact Nat.le_trans (Nat.le_of_eq (carried_succ t c))
      (Nat.le_trans (Nat.add_le_add (ih c) (Nat.le_trans (Nat.le_of_eq split)
        (Nat.add_le_add (gaps t c) (Nat.le_trans gives (Nat.mul_le_mul_right _ rate)))))
      (Nat.le_trans (Nat.le_of_eq ((congrArg (_ + ·) (Nat.add_comm _ _)).trans
          (Nat.add_assoc _ _ _).symm))
        (Nat.le_trans (Nat.le_of_eq (congrArg (· + _) (Frequency.step_eq on M _ t)))
          (Nat.le_trans (Nat.add_le_add_left (Nat.le_trans (Nat.le_of_eq (Nat.mul_one _).symm)
              (Nat.mul_le_mul_left _ one)) _)
            (Nat.le_of_eq ((fin _ _ _).trans (congrArg (· * _) (count_step dis D E t))))))))

/-- **The rate.** With the part giving no gap after the start, starting gaps at most `D`, the
strengths into each condition summing to at most `M` at each step and to nothing at the steps a
schedule `on` leaves unmarked, the carried amount at step `t` is at most `D * (1 + M) ^ a`, `a` the
number of steps before `t` that `on` marks: the case of `carried_le_disturbed` with no
disturbance. -/
theorem carried_le_count {M D : Nat} {on : Nat → Bool} (start : ∀ c, δ c ≤ D)
    (into : ∀ t c, inflow cs part k present t c ≤ M)
    (quiet : ∀ t c, on t = false → inflow cs part k present t c = 0) :
    ∀ t c, carried cs part (fun _ _ _ => 0) k present δ t c ≤
      D * (1 + M) ^ Frequency.count on t :=
  fun t c => Nat.le_trans
    (carried_le_disturbed (σ := fun _ _ _ => 0) (E := 0) (dis := fun _ => false) start into quiet
      (fun t c => Nat.le_of_eq (total_eq_zero fun h _ => by cases part h <;> rfl)) t c)
    (Nat.le_of_eq (congrArg (· * _) (congrArg (D + ·) (Nat.zero_mul _))))

/-- **Where couplings are rare, nothing runs away.** Where, besides, two to the number of marked
steps is at most `A * (t + 1) ^ n`, the carried amount is at most a polynomial in the steps,
whatever the strengths: of degree `n * M`. -/
theorem carried_le_of_rare {M D A n : Nat} {on : Nat → Bool} (start : ∀ c, δ c ≤ D)
    (into : ∀ t c, inflow cs part k present t c ≤ M)
    (quiet : ∀ t c, on t = false → inflow cs part k present t c = 0)
    (rare : ∀ t, 2 ^ Frequency.count on t ≤ A * (t + 1) ^ n) (t : Nat) (c : C) :
    carried cs part (fun _ _ _ => 0) k present δ t c ≤ D * A ^ M * (t + 1) ^ (n * M) :=
  Nat.le_trans (carried_le_count start into quiet t c)
    (Nat.le_trans (Nat.mul_le_mul_left D (Nat.le_trans (Frequency.pow_le_two_pow_pow M _)
        (Loops.pow_le_pow_base (rare t) M)))
      (Nat.le_of_eq ((congrArg (D * ·) ((Loops.mul_pow_nat A _ M).trans
        (congrArg (A ^ M * ·) (Loops.pow_mul_nat (t + 1) n M)))).trans
        (mul_assoc_nat D _ _).symm)))

/-- **The steps at which anything couples**: those at which the strengths into some listed
condition are positive. -/
def Frequency.coupling (cs : List C) (part : F → Bool) (k : Nat → F → C → Nat → C → Nat)
    (present : Nat → List F) (t : Nat) : Bool :=
  Nat.ble 1 (total cs fun c => inflow cs part k present t c)

/-- With every condition listed, nothing flows into a condition at a step at which nothing
couples. -/
theorem Frequency.quiet_coupling (every : ∀ c, c ∈ cs) (t : Nat) (c : C)
    (no : Frequency.coupling cs part k present t = false) : inflow cs part k present t c = 0 :=
  match Loops.zero_or_pos (inflow cs part k present t c) with
  | .inl zero => zero
  | .inr pos => nomatch no.symm.trans (Nat.ble_eq_true_of_le (Nat.le_trans pos
      (le_total_of_mem (q := fun c => inflow cs part k present t c) (every c))))

/-- **The rate, counted where anything couples.** With every condition listed, the carried amount at
step `t` is at most `D * (1 + M) ^ a`, `a` the number of steps before `t` at which anything
couples. -/
theorem carried_le_coupling (every : ∀ c, c ∈ cs) {M D : Nat} (start : ∀ c, δ c ≤ D)
    (into : ∀ t c, inflow cs part k present t c ≤ M) (t : Nat) (c : C) :
    carried cs part (fun _ _ _ => 0) k present δ t c ≤
      D * (1 + M) ^ Frequency.count (Frequency.coupling cs part k present) t :=
  carried_le_count start into (fun t c no => Frequency.quiet_coupling every t c no) t c

end Rate

/-! ## A self-loop coupling at the steps of a schedule -/

namespace Frequency.SelfLoop

/-- One condition returning its level to itself with strength `M` at the steps a schedule marks,
and not otherwise. -/
def strengths (on : Nat → Bool) (M : Nat) : Nat → Unit → Unit → Nat → Unit → Nat :=
  fun u h c s d => bif on u then Loops.SelfLoop.strengths M u h c s d else 0

theorem strengths_on {on : Nat → Bool} {M u : Nat} (yes : on u = true) (h c : Unit) (s : Nat)
    (d : Unit) : strengths on M u h c s d = Loops.SelfLoop.strengths M u h c s d :=
  congrArg (fun b => bif b then Loops.SelfLoop.strengths M u h c s d else 0) yes

theorem strengths_off {on : Nat → Bool} {M u : Nat} (no : on u = false) (h c : Unit) (s : Nat)
    (d : Unit) : strengths on M u h c s d = Loops.SelfLoop.strengths 0 u h c s d :=
  (congrArg (fun b => bif b then Loops.SelfLoop.strengths M u h c s d else 0) no).trans
    (Propagation.cond_same (Nat.beq s u) 0).symm

/-- What it gives across the step from `t`, read from levels `l`. -/
theorem give (on : Nat → Bool) (M t : Nat) (l : Nat → Unit → Nat) :
    (total [()] fun h =>
        carriedGive [()] (fun _ => false) (fun _ _ _ => 0) (strengths on M) t h () l) =
      (bif on t then M else 0) * l t () := by
  cases hon : on t with
  | true =>
    exact (total_congr (fun h => carriedGive_congr_strength fun s d => strengths_on hon h () s d)
      [()]).trans (Loops.SelfLoop.give M t l)
  | false =>
    exact (total_congr (fun h => carriedGive_congr_strength fun s d => strengths_off hon h () s d)
      [()]).trans (Loops.SelfLoop.give 0 t l)

/-- The strengths into the one condition sum to `M` at the marked steps and to nothing at the
others. -/
theorem inflow_eq (on : Nat → Bool) (M t : Nat) :
    inflow [()] (fun _ => false) (strengths on M) (fun _ => [()]) t () =
      bif on t then M else 0 := by
  cases hon : on t with
  | true =>
    exact (inflow_congr_strength fun h s d => strengths_on hon h () s d).trans
      (Loops.SelfLoop.inflow_eq M t)
  | false =>
    exact (inflow_congr_strength fun h s d => strengths_off hon h () s d).trans
      (Loops.SelfLoop.inflow_eq 0 t)

theorem into (on : Nat → Bool) (M : Nat) (t : Nat) (c : Unit) :
    inflow [()] (fun _ => false) (strengths on M) (fun _ => [()]) t c ≤ M :=
  Nat.le_trans (Nat.le_of_eq (inflow_eq on M t)) (bif_le M (on t))

theorem quiet (on : Nat → Bool) (M : Nat) (t : Nat) (c : Unit) (no : on t = false) :
    inflow [()] (fun _ => false) (strengths on M) (fun _ => [()]) t c = 0 :=
  (inflow_eq on M t).trans (congrArg (fun b => bif b then M else 0) no)

/-- **The rate is attained.** The self-loop coupling with strength `M` at the steps of `on` carries
the starting gap `D` multiplied by `1 + M` at each marked step: exactly `D * (1 + M) ^ a`. -/
theorem carried_eq (on : Nat → Bool) (M D : Nat) : ∀ t,
    carried [()] (fun _ => false) (fun _ _ _ => 0) (strengths on M) (fun _ => [()]) (fun _ => D)
      t () = D * (1 + M) ^ count on t
  | 0 => (Nat.mul_one D).symm
  | t + 1 => (carried_succ t ()).trans ((Naturals.add_congr (carried_eq on M D t)
      ((give on M t _).trans (congrArg (_ * ·) (carried_eq on M D t)))).trans (step_eq on M D t))

/-- **A self-loop runs away exactly where it couples often, whatever its strength.** With strength
`M` and starting gap `D` both positive, the carried amount is bounded by a polynomial in the steps
exactly where two to the number of steps at which it couples is. -/
theorem polynomial_iff (on : Nat → Bool) {M D : Nat} (strong : 1 ≤ M) (pos : 1 ≤ D) :
    (∃ A n, ∀ t, carried [()] (fun _ => false) (fun _ _ _ => 0) (strengths on M) (fun _ => [()])
        (fun _ => D) t () ≤ A * (t + 1) ^ n) ↔
      ∃ A n, ∀ t, 2 ^ count on t ≤ A * (t + 1) ^ n :=
  ⟨fun ⟨A, n, bound⟩ => ⟨A, n, fun t =>
      Nat.le_trans (Nat.le_trans (Nat.le_of_eq (Nat.one_mul _).symm)
          (Nat.mul_le_mul pos (Loops.pow_le_pow_base (Nat.add_le_add_left strong 1) _)))
        (Nat.le_trans (Nat.le_of_eq (carried_eq on M D t).symm) (bound t))⟩,
   fun ⟨A, n, rare⟩ => ⟨D * A ^ M, n * M, fun t =>
      carried_le_of_rare (fun _ => Nat.le_refl D) (into on M) (quiet on M) rare t ()⟩⟩

end Frequency.SelfLoop

/-! ## Returns around a loop in time order -/

section Returns

variable {cs : List C} {part : F → Bool} {σ : Nat → F → C → Nat}
  {k : Nat → F → C → Nat → C → Nat} {present : Nat → List F} {δ : C → Nat}

/-- **One coupling, from any level it reads.** Where at step `u` the level of `d` at step `s` is
coupled into `c`, the carried amount at `c` grows across the step by at least the carried amount at
`d` at step `s`. -/
theorem carried_step_ge_at {u s : Nat} {d c : C} (at_ : CouplesAt cs part k present u s d c) :
    carried cs part σ k present δ u c + carried cs part σ k present δ s d ≤
      carried cs part σ k present δ (u + 1) c :=
  match at_ with
  | ⟨h, mem, out, le, dMem, pos⟩ =>
    Nat.le_trans (Nat.add_le_add_left (
      calc carried cs part σ k present δ s d
          ≤ k u h c s d * carried cs part σ k present δ s d := Loops.le_mul_of_pos pos _
        _ ≤ total cs (fun d' => k u h c s d' * carried cs part σ k present δ s d') :=
          le_total_of_mem (q := fun d' => k u h c s d' * carried cs part σ k present δ s d') dMem
        _ ≤ total (steps 0 (u + 1))
              (fun s' => total cs fun d' => k u h c s' d' * carried cs part σ k present δ s' d') :=
          le_total_of_mem (q := fun s' => total cs fun d' =>
              k u h c s' d' * carried cs part σ k present δ s' d')
            (Propagation.mem_steps_upto le)
        _ = carriedGive cs part σ k u h c (carried cs part σ k present δ) :=
          (carriedGive_of_rest out).symm
        _ ≤ total (present u)
              (fun h => carriedGive cs part σ k u h c (carried cs part σ k present δ)) :=
          le_total_of_mem (q := fun h => carriedGive cs part σ k u h c
            (carried cs part σ k present δ)) mem) _)
      (Nat.le_of_eq (carried_succ u c).symm)

/-- **A chain in time order from a step.** `p` couplings in time order lead from the level of `v 0`
at a step from `T` on to `v p` by step `T'`: the first reads a level of `v 0` at a step from `T` on,
and each later one a level its condition had reached after the coupling before it acted. -/
def ChainInTime (cs : List C) (part : F → Bool) (k : Nat → F → C → Nat → C → Nat)
    (present : Nat → List F) (v : Nat → C) (T : Nat) : Nat → Nat → Prop
  | 0, T' => T ≤ T'
  | p + 1, T' => ∃ u s, u < T' ∧ CouplesAt cs part k present u s (v p) (v (p + 1)) ∧
      ChainInTime cs part k present v T p s

/-- A chain in time order from step `T` ends no earlier than `T`. -/
theorem ChainInTime.start_le {v : Nat → C} {T : Nat} :
    ∀ {p T' : Nat}, ChainInTime cs part k present v T p T' → T ≤ T'
  | 0, _, le => le
  | _ + 1, _, ⟨_, _, lt, ⟨_, _, _, le, _, _⟩, chain⟩ =>
    Nat.le_trans (ChainInTime.start_le chain) (Nat.le_trans le (Nat.le_of_lt lt))

/-- **Along a chain in time order, what has reached its start arrives at its end.** -/
theorem carried_along_in_time {v : Nat → C} {T : Nat} :
    ∀ {p T' : Nat}, ChainInTime cs part k present v T p T' →
      carried cs part σ k present δ T (v 0) ≤ carried cs part σ k present δ T' (v p)
  | 0, _, le => carried_mono_steps le (v 0)
  | _ + 1, _, ⟨_, _, lt, at_, chain⟩ =>
    Nat.le_trans (carried_along_in_time chain)
      (Nat.le_trans (Nat.le_add_left _ _)
        (Nat.le_trans (carried_step_ge_at at_) (carried_mono_steps lt _)))

/-- **A return.** What has reached `e` from step `T` on comes back to `e` by step `T'` around a
loop of couplings in time order. What returns is a carried difference along couplings, not a
configuration (`Law.Returns` of `Becoming.Recurrence`, `Branching.Returns`) and not a dependence
met again (`Web.Restored` of `Becoming.Restoration`). -/
def RoundTrip (cs : List C) (part : F → Bool) (k : Nat → F → C → Nat → C → Nat)
    (present : Nat → List F) (e : C) (T T' : Nat) : Prop :=
  ∃ v p, v 0 = e ∧ v (p + 1) = e ∧ ChainInTime cs part k present v T (p + 1) T'

/-- A condition coupled into itself at step `u`, reading a level from step `T` on, returns what had
reached it by `T` by the next step. -/
theorem RoundTrip.of_couplesAt {u s T : Nat} {e : C} (at_ : CouplesAt cs part k present u s e e)
    (late : T ≤ s) : RoundTrip cs part k present e T (u + 1) :=
  ⟨fun _ => e, 0, rfl, rfl, u, s, Nat.lt_succ_self u, at_, late⟩

/-- **Every return at least doubles.** What has reached `e` by step `T` and returns to it by `T'`
arrives there twice over: once held, once around the loop. -/
theorem carried_doubles_roundTrip {e : C} {T T' : Nat} (back : RoundTrip cs part k present e T T') :
    carried cs part σ k present δ T e + carried cs part σ k present δ T e ≤
      carried cs part σ k present δ T' e :=
  match back with
  | ⟨_, _, start, close, ⟨u, s, lt, at_, chain⟩⟩ =>
    have le_s : T ≤ s := ChainInTime.start_le chain
    have le_u : s ≤ u := match at_ with | ⟨_, _, _, le, _, _⟩ => le
    Nat.le_trans (Nat.add_le_add
        (Nat.le_trans (carried_mono_steps (Nat.le_trans le_s le_u) e)
          (Nat.le_of_eq (congrArg (carried cs part σ k present δ u) close.symm)))
        (Nat.le_trans (Nat.le_of_eq (congrArg (carried cs part σ k present δ T) start.symm))
          (carried_along_in_time chain)))
      (Nat.le_trans (carried_step_ge_at at_)
        (Nat.le_trans (carried_mono_steps lt _)
          (Nat.le_of_eq (congrArg (carried cs part σ k present δ T') close))))

/-- **Each return doubles again.** After `R` returns in succession, at the steps `T i`, what had
reached `e` by `T 0` has at least doubled `R` times. -/
theorem carried_roundTrip {e : C} {T : Nat → Nat} :
    ∀ R, (∀ i, i < R → RoundTrip cs part k present e (T i) (T (i + 1))) →
      2 ^ R * carried cs part σ k present δ (T 0) e ≤ carried cs part σ k present δ (T R) e
  | 0, _ => Nat.le_of_eq (Nat.one_mul _)
  | R + 1, back =>
    Nat.le_trans (Nat.le_of_eq ((congrArg (· * _) (Loops.two_pow_succ R)).trans
        (add_mul_split _ _ _)))
      (Nat.le_trans (Nat.add_le_add
          (carried_roundTrip R fun i lt => back i (Nat.lt_succ_of_lt lt))
          (carried_roundTrip R fun i lt => back i (Nat.lt_succ_of_lt lt)))
        (carried_doubles_roundTrip (back R (Nat.lt_succ_self R))))

/-- **Returns often enough run away.** Where something has reached `e` by step `T 0` and returns to
it in succession by the steps `T i`, with `2 ^ i` outgrowing every polynomial in `T i`, the carried
amount at `e`, the most difference that can arrive there, is bounded by no polynomial in the steps,
whatever the strengths. -/
theorem runaway_of_roundTrip {e : C} {T : Nat → Nat}
    (back : ∀ i, RoundTrip cs part k present e (T i) (T (i + 1)))
    (fed : 0 < carried cs part σ k present δ (T 0) e)
    (often : ∀ A n, ∃ i, A * (T i + 1) ^ n < 2 ^ i) :
    ¬ ∃ A n, ∀ t, carried cs part σ k present δ t e ≤ A * (t + 1) ^ n :=
  fun ⟨A, n, bound⟩ => match often A n with
    | ⟨i, below⟩ => Nat.lt_irrefl _ (Nat.lt_of_lt_of_le below
        (Nat.le_trans (Nat.le_trans (Nat.le_of_eq (Nat.mul_one _).symm)
            (Nat.mul_le_mul_left _ fed))
          (Nat.le_trans (carried_roundTrip i fun j _ => back j) (bound (T i)))))

end Returns

/-! ## A loop that recurs and does not run away -/

namespace Frequency.SelfLoop

/-- At a marked step, with positive strength, the self-loop reads its current level. -/
theorem couplesAt {on : Nat → Bool} {M u : Nat} (yes : on u = true) (strong : 0 < M) :
    CouplesAt [()] (fun _ => false) (strengths on M) (fun _ => [()]) u u () () :=
  ⟨(), .head _, rfl, Nat.le_refl u, .head _, Nat.lt_of_lt_of_le strong (Nat.le_of_eq
    ((congrArg (fun b => bif b then M else 0) (beq_self u)).symm.trans
      (strengths_on yes () () u ()).symm))⟩

/-- Where the schedule marks steps as late as one likes and the strength is positive, the
self-loop's coupling recurs. -/
theorem recurs {on : Nat → Bool} {M : Nat} (strong : 0 < M)
    (often : ∀ N, ∃ u, N ≤ u ∧ on u = true) :
    CouplingRecurs [()] (fun _ => false) (strengths on M) (fun _ => [()]) () () :=
  fun N => match often N with
    | ⟨u, le, yes⟩ => ⟨u, u, le, couplesAt yes strong⟩

/-- Each marked step is a return: what has reached the loop by it is back by the next step. -/
theorem roundTrip {on : Nat → Bool} {M u : Nat} (yes : on u = true) (strong : 0 < M) :
    RoundTrip [()] (fun _ => false) (strengths on M) (fun _ => [()]) () u (u + 1) :=
  RoundTrip.of_couplesAt (couplesAt yes strong) (Nat.le_refl u)

/-- **It couples exactly at the marked steps**, reading its current level, where its strength is
positive. -/
theorem couplesAt_iff {on : Nat → Bool} {M u s : Nat} :
    CouplesAt [()] (fun _ => false) (strengths on M) (fun _ => [()]) u s () () ↔
      on u = true ∧ s = u ∧ 0 < M :=
  ⟨fun ⟨_, _, _, _, _, pos⟩ => match hon : on u, hb : Nat.beq s u with
    | false, _ => absurd (Nat.lt_of_lt_of_le pos (Nat.le_of_eq
        ((strengths_off hon () () s ()).trans (Propagation.cond_same _ 0)))) (Nat.lt_irrefl 0)
    | true, false => absurd (Nat.lt_of_lt_of_le pos (Nat.le_of_eq
        ((strengths_on hon () () s ()).trans (congrArg (fun b => bif b then M else 0) hb))))
        (Nat.lt_irrefl 0)
    | true, true => ⟨rfl, Nat.eq_of_beq_eq_true hb, Nat.lt_of_lt_of_le pos (Nat.le_of_eq
        ((strengths_on hon () () s ()).trans (congrArg (fun b => bif b then M else 0) hb)))⟩,
   fun ⟨yes, same, strong⟩ => Eq.subst
      (motive := fun x =>
        CouplesAt [()] (fun _ => false) (strengths on M) (fun _ => [()]) u x () ())
      same.symm (couplesAt yes strong)⟩

end Frequency.SelfLoop

namespace Frequency.Sparse

/-- How many of the steps before `u` are one less than a power of two. -/
def marks : Nat → Nat
  | 0 => 0
  | u + 1 => marks u + (bif Nat.beq (u + 1) (2 ^ marks u) then 1 else 0)

/-- **The sparse schedule** marks the steps one less than a power of two: `0, 1, 3, 7, 15, …`. -/
def on (u : Nat) : Bool := Nat.beq (u + 1) (2 ^ marks u)

theorem count_eq : ∀ u, count on u = marks u
  | 0 => rfl
  | u + 1 => congrArg (· + (bif on u then 1 else 0)) (count_eq u)

/-- Before the step `u`, between half of `u + 1` and `u + 1` itself in powers of two. -/
theorem bounds : ∀ u, u + 1 ≤ 2 ^ marks u ∧ 2 ^ marks u ≤ u + u + 1
  | 0 => ⟨Nat.le_refl 1, Nat.le_refl 1⟩
  | u + 1 => match hb : Nat.beq (u + 1) (2 ^ marks u) with
    | true =>
      have eq : u + 1 = 2 ^ marks u := Nat.eq_of_beq_eq_true hb
      have up : 2 ^ marks (u + 1) = (u + 1) + (u + 1) :=
        (congrArg (2 ^ ·) (congrArg (fun b => marks u + (bif b then 1 else 0)) hb)).trans
          ((Loops.two_pow_succ (marks u)).trans (Naturals.add_congr eq.symm eq.symm))
      ⟨Nat.le_trans (Nat.add_le_add_left (Nat.succ_le_succ (Nat.zero_le u)) (u + 1))
          (Nat.le_of_eq up.symm),
        Nat.le_trans (Nat.le_of_eq up) (Nat.le_succ _)⟩
    | false =>
      have same : 2 ^ marks (u + 1) = 2 ^ marks u :=
        congrArg (2 ^ ·) (congrArg (fun b => marks u + (bif b then 1 else 0)) hb)
      have ne : u + 1 ≠ 2 ^ marks u := Nat.ne_of_beq_eq_false hb
      ⟨Nat.le_trans (match Nat.eq_or_lt_of_le (bounds u).1 with
          | .inl eq => absurd eq ne
          | .inr lt => lt) (Nat.le_of_eq same.symm),
        Nat.le_trans (Nat.le_of_eq same) (Nat.le_trans (bounds u).2
          (Nat.succ_le_succ (Nat.add_le_add (Nat.le_succ u) (Nat.le_succ u))))⟩

/-- Twice a number is two times its first power. -/
theorem double_eq (x : Nat) : x + x = 2 * x ^ 1 :=
  ((congrArg (· + x) (Nat.mul_one x)).symm.trans (Nat.mul_succ x 1).symm).trans
    ((Nat.mul_comm x 2).trans (congrArg (2 * ·) (Nat.one_mul x).symm))

/-- **The sparse schedule is rare.** Two to the number of its marked steps before `t` is at most
`2 * (t + 1)`. -/
theorem rare (t : Nat) : 2 ^ count on t ≤ 2 * (t + 1) ^ 1 :=
  Nat.le_trans (Nat.le_of_eq (congrArg (2 ^ ·) (count_eq t)))
    (Nat.le_trans (bounds t).2 (Nat.le_trans (Nat.le_of_eq (Nat.add_assoc t t 1))
      (Nat.le_trans (Nat.add_le_add (Nat.le_succ t) (Nat.le_refl (t + 1)))
        (Nat.le_of_eq (double_eq (t + 1))))))

/-- **And it recurs.** Its count rises past every count. -/
theorem unbounded (N : Nat) : ∃ t, count on N < count on t :=
  ⟨2 ^ marks N, match Nat.lt_or_ge (marks N) (marks (2 ^ marks N)) with
    | .inl lt => Nat.lt_of_le_of_lt (Nat.le_of_eq (count_eq N))
        (Nat.lt_of_lt_of_le lt (Nat.le_of_eq (count_eq _).symm))
    | .inr ge => absurd (Nat.le_trans (bounds (2 ^ marks N)).1
        (Loops.pow_le_pow_exp (Nat.succ_pos 1) ge)) (Nat.not_succ_le_self _)⟩

/-- The sparse schedule marks steps as late as one likes. -/
theorem often (N : Nat) : ∃ u, N ≤ u ∧ on u = true :=
  recurs_of_unbounded unbounded N

/-- **A loop that recurs.** The self-loop coupling at the steps of the sparse schedule, with
positive strength, recurs. -/
theorem recurs {M : Nat} (strong : 0 < M) :
    CouplingRecurs [()] (fun _ => false) (SelfLoop.strengths on M) (fun _ => [()]) () () :=
  SelfLoop.recurs strong often

/-- **So no finite order is exact.** From a positive starting gap, every order of it misses
something at some step. -/
theorem inexact {M D : Nat} (strong : 0 < M) (pos : 0 < D) (J : Nat) :
    ∃ t, carriedWithin [()] (fun _ => false) (fun _ _ _ => 0) (SelfLoop.strengths on M)
        (fun _ => [()]) (fun _ => D) J t () <
      carried [()] (fun _ => false) (fun _ _ _ => 0) (SelfLoop.strengths on M) (fun _ => [()])
        (fun _ => D) t () :=
  carriedWithin_lt_of_recurring_loop (s := 0) (.start pos) (v := fun _ => ()) (m := 1)
    (Nat.succ_pos 0) rfl rfl (fun _ _ => recurs strong) (u := fun _ => ()) (q := 0) rfl rfl
    (fun _ lt => absurd lt (Nat.not_lt_zero _)) J

/-- **And yet it does not run away.** The carried amount, `D * (1 + M) ^ a` with `a` the number of
marked steps before `t` (`SelfLoop.carried_eq`), is at most a polynomial in the steps of degree
`M`. -/
theorem polynomial (M D t : Nat) :
    carried [()] (fun _ => false) (fun _ _ _ => 0) (SelfLoop.strengths on M) (fun _ => [()])
      (fun _ => D) t () ≤ D * 2 ^ M * (t + 1) ^ (1 * M) :=
  carried_le_of_rare (fun _ => Nat.le_refl D) (SelfLoop.into on M) (SelfLoop.quiet on M) rare t ()

end Frequency.Sparse

/-! ## Whether a schedule settles -/

section Settling

variable {cs : List C} {part : F → Bool} {k : Nat → F → C → Nat → C → Nat}
  {present : Nat → List F}

/-- **A coupling that stops by a step.** No coupling reads a level of `d` into `c` at a step from
`N` on. -/
def StopsBy (cs : List C) (part : F → Bool) (k : Nat → F → C → Nat → C → Nat)
    (present : Nat → List F) (d c : C) (N : Nat) : Prop :=
  ∀ u s, CouplesAt cs part k present u s d c → s < N

theorem StopsBy.mono {d c : C} {N N' : Nat} (le : N ≤ N')
    (stops : StopsBy cs part k present d c N) : StopsBy cs part k present d c N' :=
  fun u s at_ => Nat.lt_of_lt_of_le (stops u s at_) le

/-- A coupling that stops does not recur. -/
theorem StopsBy.not_recurs {d c : C} {N : Nat} (stops : StopsBy cs part k present d c N) :
    ¬ CouplingRecurs cs part k present d c :=
  fun recurs => match recurs N with
    | ⟨u, s, late, at_⟩ => Nat.lt_irrefl N (Nat.lt_of_le_of_lt late (stops u s at_))

/-- Bounds for each member of a list, kept by every larger bound, combine into one. -/
theorem Frequency.bound_list {α : Type} {Q : α → Nat → Prop}
    (up : ∀ a N N', N ≤ N' → Q a N → Q a N') :
    ∀ as : List α, (∀ a, a ∈ as → ∃ N, Q a N) → ∃ N, ∀ a, a ∈ as → Q a N
  | [], _ => ⟨0, fun _ mem => nomatch mem⟩
  | a :: as, each =>
    match each a (.head _), Frequency.bound_list up as (fun b mem => each b (.tail _ mem)) with
    | ⟨Na, qa⟩, ⟨N, rest⟩ => ⟨Na + N, fun b mem => match mem with
      | .head _ => up _ Na (Na + N) (Nat.le_add_right Na N) qa
      | .tail _ mem' => up b N (Na + N) (Nat.le_add_left N Na) (rest b mem')⟩

/-- **Settling is local.** With every condition listed, where each coupling recurs or stops by
some step, the schedule has settled by some step. -/
theorem settled_of_each (every : ∀ c, c ∈ cs)
    (each : ∀ d c, CouplingRecurs cs part k present d c ∨ ∃ N, StopsBy cs part k present d c N) :
    ∃ N, SettledFrom cs part k present N :=
  match Frequency.bound_list
      (Q := fun d N => ∀ c, c ∈ cs →
        CouplingRecurs cs part k present d c ∨ StopsBy cs part k present d c N)
      (fun _ _ _ le q c mem => match q c mem with
        | .inl recurs => .inl recurs
        | .inr stops => .inr (stops.mono le))
      cs (fun d _ => Frequency.bound_list
        (Q := fun c N => CouplingRecurs cs part k present d c ∨ StopsBy cs part k present d c N)
        (fun _ _ _ le q => match q with
          | .inl recurs => .inl recurs
          | .inr stops => .inr (stops.mono le))
        cs (fun c _ => match each d c with
          | .inl recurs => ⟨0, .inl recurs⟩
          | .inr ⟨N, stops⟩ => ⟨N, .inr stops⟩)) with
  | ⟨N, all⟩ => ⟨N, fun d c from_ => match all d (every d) c (every c) with
    | .inl recurs => recurs
    | .inr stops => match couples_strengthsFrom_iff.mp from_ with
      | ⟨u, s, late, at_⟩ => absurd (Nat.lt_of_le_of_lt late (stops u s at_)) (Nat.lt_irrefl N)⟩

/-- **Whether a late level is read at a step.** At step `m` a formation present, outside the part,
exchanges with `c` with positive strength on a level of `d` at a step from `n` on. -/
def Frequency.readsLate (part : F → Bool) (k : Nat → F → C → Nat → C → Nat)
    (present : Nat → List F) (d c : C) (n m : Nat) : Bool :=
  Nat.ble 1 (total (steps 0 (m + 1)) fun s => bif Nat.ble n s then
    total (present m) (fun h => bif part h then 0 else k m h c s d) else 0)

theorem Frequency.readsLate_of_couplesAt {d c : C} {n m s : Nat} (late : n ≤ s)
    (at_ : CouplesAt cs part k present m s d c) :
    Frequency.readsLate part k present d c n m = true :=
  match at_ with
  | ⟨h, mem, out, le, _, pos⟩ =>
    Nat.ble_eq_true_of_le (total_pos_of_mem
      (q := fun s => bif Nat.ble n s then
        total (present m) (fun h => bif part h then 0 else k m h c s d) else 0)
      (Propagation.mem_steps_upto le)
      (Nat.lt_of_lt_of_le
        (total_pos_of_mem (q := fun h => bif part h then 0 else k m h c s d) mem
          (Nat.lt_of_lt_of_le pos (Nat.le_of_eq
            (congrArg (fun b => bif b then 0 else k m h c s d) out).symm)))
        (Nat.le_of_eq (congrArg (fun b => bif b then
            total (present m) (fun h => bif part h then 0 else k m h c s d) else 0)
          (Nat.ble_eq_true_of_le late)).symm)))

theorem Frequency.couplesAt_of_readsLate (every : ∀ c, c ∈ cs) {d c : C} {n m : Nat}
    (yes : Frequency.readsLate part k present d c n m = true) :
    ∃ s, n ≤ s ∧ CouplesAt cs part k present m s d c :=
  match total_pos _ (Nat.le_of_ble_eq_true yes) with
  | ⟨s, sMem, pos⟩ => match hb : Nat.ble n s with
    | false => absurd (Nat.lt_of_lt_of_le pos (Nat.le_of_eq (congrArg (fun b => bif b then
          total (present m) (fun h => bif part h then 0 else k m h c s d) else 0) hb)))
        (Nat.lt_irrefl 0)
    | true =>
      match total_pos _ (Nat.lt_of_lt_of_le pos (Nat.le_of_eq (congrArg (fun b => bif b then
          total (present m) (fun h => bif part h then 0 else k m h c s d) else 0) hb))) with
      | ⟨h, mem, positive⟩ => match hp : part h with
        | true => absurd (Nat.lt_of_lt_of_le positive (Nat.le_of_eq
            (congrArg (fun b => bif b then 0 else k m h c s d) hp))) (Nat.lt_irrefl 0)
        | false => ⟨s, Nat.le_of_ble_eq_true hb, h, mem, hp,
            Propagation.le_of_mem_steps_upto sMem, every d, Nat.lt_of_lt_of_le positive
              (Nat.le_of_eq (congrArg (fun b => bif b then 0 else k m h c s d) hp))⟩

/-- **Every row holds somewhere, or some row holds nowhere.** The dichotomy for decided two-place
families of Booleans: every row `n` is `true` at some `m`, or some row is `false` throughout.
Excluded middle gives it, and it gives `LPO` (`RecursOrStops.lpo`); it has no constructive proof.
This is excluded middle at level Σ⁰₂ of the arithmetical hierarchy (Akama–Berardi–Hayashi–Kohlenbach
2004), strictly stronger than LPO. -/
def RecursOrStops : Prop :=
  ∀ R : Nat → Nat → Bool, (∀ n, ∃ m, R n m = true) ∨ ∃ n, ∀ m, R n m = false

theorem RecursOrStops.lpo (principle : RecursOrStops) : LPO :=
  fun q => match principle (fun _ m => q m) with
    | .inl rows => .inl (rows 0)
    | .inr ⟨_, nowhere⟩ => .inr nowhere

/-- **Given the dichotomy, a coupling recurs or stops.** With every condition listed, the rows are
the steps from which a coupling of `d` into `c` might read, and the places the steps at which it
might act (`Frequency.readsLate`). -/
theorem recurs_or_stops (every : ∀ c, c ∈ cs) (principle : RecursOrStops) (d c : C) :
    CouplingRecurs cs part k present d c ∨ ∃ N, StopsBy cs part k present d c N :=
  match principle (Frequency.readsLate part k present d c) with
  | .inl rows => .inl fun N => match rows N with
    | ⟨m, yes⟩ => match Frequency.couplesAt_of_readsLate every yes with
      | ⟨s, late, at_⟩ => ⟨m, s, late, at_⟩
  | .inr ⟨n, nowhere⟩ => .inr ⟨n, fun u s at_ => match Nat.lt_or_ge s n with
    | .inl lt => lt
    | .inr ge => nomatch (nowhere u).symm.trans (Frequency.readsLate_of_couplesAt ge at_)⟩

/-- **Given the dichotomy, every schedule settles.** -/
theorem settled_of_recursOrStops (every : ∀ c, c ∈ cs) (principle : RecursOrStops) :
    ∃ N, SettledFrom cs part k present N :=
  settled_of_each every (recurs_or_stops every principle)

end Settling

/-! ## Settling for every schedule is the dichotomy -/

namespace Frequency.First

/-- One condition returning its level to itself with strength one at the first step at which `q` is
`true`, if there is one, and never otherwise. -/
def strengths (q : Nat → Bool) : Nat → Unit → Unit → Nat → Unit → Nat :=
  fun u _ _ s _ => bif Nat.beq s u && (q u && clear q u) then 1 else 0

theorem of_couplesAt {q : Nat → Bool} {u s : Nat}
    (at_ : CouplesAt [()] (fun _ => false) (strengths q) (fun _ => [()]) u s () ()) :
    s = u ∧ q u = true ∧ clear q u = true :=
  match at_ with
  | ⟨_, _, _, _, _, pos⟩ => match hb : (Nat.beq s u && (q u && clear q u)) with
    | false => absurd (Nat.lt_of_lt_of_le pos (Nat.le_of_eq
        (congrArg (fun b => bif b then 1 else 0) hb))) (Nat.lt_irrefl 0)
    | true => ⟨Nat.eq_of_beq_eq_true (ListTests.and_left hb), ListTests.and_left (ListTests.and_right hb),
        ListTests.and_right (ListTests.and_right hb)⟩

theorem couplesAt_first {q : Nat → Bool} {u : Nat} (c : clear q u = true) (yes : q u = true) :
    CouplesAt [()] (fun _ => false) (strengths q) (fun _ => [()]) u u () () :=
  ⟨(), .head _, rfl, Nat.le_refl u, .head _, Nat.lt_of_lt_of_le (Nat.succ_pos 0) (Nat.le_of_eq
    (congrArg (fun b => bif b then 1 else 0)
      (Clear.and_both _ _ (beq_self u) (Clear.and_both _ _ yes c))).symm)⟩

/-- **It couples at most once.** -/
theorem once {q : Nat → Bool} {u s u' s' : Nat}
    (at_ : CouplesAt [()] (fun _ => false) (strengths q) (fun _ => [()]) u s () ())
    (at' : CouplesAt [()] (fun _ => false) (strengths q) (fun _ => [()]) u' s' () ()) :
    u = u' ∧ s = s' :=
  match of_couplesAt at_, of_couplesAt at' with
  | ⟨same, yu, cu⟩, ⟨same', yu', cu'⟩ =>
    have eq : u = u' := Clear.first_unique q cu yu cu' yu'
    ⟨eq, same.trans (eq.trans same'.symm)⟩

/-- So its coupling does not recur. -/
theorem not_recurs (q : Nat → Bool) :
    ¬ CouplingRecurs [()] (fun _ => false) (strengths q) (fun _ => [()]) () () :=
  fun recurs => match recurs 0 with
    | ⟨u, _, _, at_⟩ => match recurs (u + 1) with
      | ⟨_, _, late, at'⟩ => match of_couplesAt at', once at_ at' with
        | ⟨same', _, _⟩, ⟨eq, _⟩ =>
          Nat.lt_irrefl u (Nat.lt_of_lt_of_le (Nat.lt_succ_self u)
            (Nat.le_trans late (Nat.le_of_eq (same'.trans eq.symm))))

/-- **Its settling decides `q`.** Where the schedule has settled by some step, `q` is `true`
somewhere or `false` throughout. -/
theorem decides {q : Nat → Bool}
    (settled : ∃ N, SettledFrom [()] (fun _ => false) (strengths q) (fun _ => [()]) N) :
    (∃ n, q n = true) ∨ ∀ n, q n = false :=
  match settled with
  | ⟨N, settles⟩ => match Clear.or_first q N with
    | .inr ⟨m, _, _, yes⟩ => .inl ⟨m, yes⟩
    | .inl c => .inr fun n => Clear.false_of_not (q n) fun yes =>
      match Clear.first_of_true q yes with
      | ⟨m, cm, ym⟩ => match Nat.lt_or_ge m N with
        | .inl lt => Clear.not_both (Clear.false_before q c lt) ym
        | .inr ge => not_recurs q (settles () ()
            (couples_strengthsFrom_iff.mpr ⟨m, m, ge, couplesAt_first cm ym⟩))

end Frequency.First

/-- **Settling needs omniscience, even for couplings acting once.** If every schedule of one
condition coupled into itself at most once (`Frequency.First.once`) had settled by some step, `LPO`
would hold. -/
theorem lpo_of_settled
    (settles : ∀ q : Nat → Bool,
      ∃ N, SettledFrom [()] (fun _ => false) (Frequency.First.strengths q) (fun _ => [()]) N) :
    LPO :=
  fun q => Frequency.First.decides (settles q)

namespace Frequency.Rows

/-- Some `m ≤ u` at which `f` is `true`. -/
def anyUpTo (f : Nat → Bool) : Nat → Bool
  | 0 => f 0
  | u + 1 => anyUpTo f u || f (u + 1)

/-- Every `n ≤ s` has `g` `true`. -/
def allUpTo (g : Nat → Bool) : Nat → Bool
  | 0 => g 0
  | s + 1 => allUpTo g s && g (s + 1)

theorem anyUpTo_of {f : Nat → Bool} {m : Nat} (yes : f m = true) :
    ∀ {u}, m ≤ u → anyUpTo f u = true
  | 0, le => Eq.subst (motive := fun x => f x = true) (Nat.eq_zero_of_le_zero le) yes
  | _ + 1, le => match le_succ_cases le with
    | .inl le' => ListTests.or_left _ (anyUpTo_of yes le')
    | .inr eq => ListTests.or_right _ (Eq.subst (motive := fun x => f x = true) eq yes)

theorem anyUpTo_true {f : Nat → Bool} : ∀ {u}, anyUpTo f u = true → ∃ m, m ≤ u ∧ f m = true
  | 0, yes => ⟨0, Nat.le_refl 0, yes⟩
  | _ + 1, yes => match ListTests.or_cases yes with
    | .inl before => match anyUpTo_true before with
      | ⟨m, le, ym⟩ => ⟨m, Nat.le_succ_of_le le, ym⟩
    | .inr now => ⟨_, Nat.le_refl _, now⟩

theorem allUpTo_true {g : Nat → Bool} : ∀ {s}, allUpTo g s = true → ∀ n, n ≤ s → g n = true
  | 0, yes, _, le =>
    Eq.subst (motive := fun x => g x = true) (Nat.eq_zero_of_le_zero le).symm yes
  | _ + 1, yes, n, le => match le_succ_cases le with
    | .inl le' => allUpTo_true (ListTests.and_left yes) n le'
    | .inr eq => Eq.subst (motive := fun x => g x = true) eq.symm (ListTests.and_right yes)

theorem allUpTo_of {g : Nat → Bool} : ∀ {s}, (∀ n, n ≤ s → g n = true) → allUpTo g s = true
  | 0, all => all 0 (Nat.le_refl 0)
  | s + 1, all => Clear.and_both _ _ (allUpTo_of fun n le => all n (Nat.le_succ_of_le le))
      (all (s + 1) (Nat.le_refl _))

/-- Every row up to `s` is `true` somewhere up to `u`. -/
def found (R : Nat → Nat → Bool) (s u : Nat) : Bool := allUpTo (fun n => anyUpTo (R n) u) s

/-- One condition returning its level to itself: at step `u` it reads its level at each step
`s ≤ u` by which every row up to `s` has been `true` somewhere up to `u`. -/
def strengths (R : Nat → Nat → Bool) : Nat → Unit → Unit → Nat → Unit → Nat :=
  fun u _ _ s _ => bif Nat.ble s u && found R s u then 1 else 0

theorem found_of_couplesAt {R : Nat → Nat → Bool} {u s : Nat}
    (at_ : CouplesAt [()] (fun _ => false) (strengths R) (fun _ => [()]) u s () ()) :
    found R s u = true :=
  match at_ with
  | ⟨_, _, _, _, _, pos⟩ => match hb : (Nat.ble s u && found R s u) with
    | false => absurd (Nat.lt_of_lt_of_le pos (Nat.le_of_eq
        (congrArg (fun b => bif b then 1 else 0) hb))) (Nat.lt_irrefl 0)
    | true => ListTests.and_right hb

theorem couplesAt_of_found {R : Nat → Nat → Bool} {u s : Nat} (le : s ≤ u)
    (yes : found R s u = true) :
    CouplesAt [()] (fun _ => false) (strengths R) (fun _ => [()]) u s () () :=
  ⟨(), .head _, rfl, le, .head _, Nat.lt_of_lt_of_le (Nat.succ_pos 0) (Nat.le_of_eq
    (congrArg (fun b => bif b then 1 else 0)
      (Clear.and_both _ _ (Nat.ble_eq_true_of_le le) yes)).symm)⟩

/-- Where every row up to `N` is `true` somewhere, one step bounds a place for each. -/
theorem witnessed (R : Nat → Nat → Bool) : ∀ N, (∀ n, n ≤ N → ∃ m, R n m = true) →
    ∃ u, ∀ n, n ≤ N → ∃ m, m ≤ u ∧ R n m = true
  | 0, rows => match rows 0 (Nat.le_refl 0) with
    | ⟨m, ym⟩ => ⟨m, fun _ le => ⟨m, Nat.le_refl m,
        Eq.subst (motive := fun x => R x m = true) (Nat.eq_zero_of_le_zero le).symm ym⟩⟩
  | N + 1, rows =>
    match witnessed R N (fun n le => rows n (Nat.le_succ_of_le le)),
      rows (N + 1) (Nat.le_refl _) with
    | ⟨u, below⟩, ⟨m, ym⟩ => ⟨u + m, fun n le => match le_succ_cases le with
      | .inl le' => match below n le' with
        | ⟨m', mle, ym'⟩ => ⟨m', Nat.le_trans mle (Nat.le_add_right u m), ym'⟩
      | .inr eq =>
        ⟨m, Nat.le_add_left m u, Eq.subst (motive := fun x => R x m = true) eq.symm ym⟩⟩

/-- Where every row up to `N` is `true` somewhere, the self-loop reads its level at `N`. -/
theorem couplesAt_of_rows {R : Nat → Nat → Bool} {N : Nat}
    (below : ∀ n, n ≤ N → ∃ m, R n m = true) :
    ∃ u, CouplesAt [()] (fun _ => false) (strengths R) (fun _ => [()]) u N () () :=
  match witnessed R N below with
  | ⟨u, all⟩ => ⟨N + u, couplesAt_of_found (Nat.le_add_right N u)
      (allUpTo_of fun n le => match all n le with
        | ⟨_, mle, ym⟩ => anyUpTo_of ym (Nat.le_trans mle (Nat.le_add_left u N)))⟩

/-- **Its coupling recurs exactly where every row is `true` somewhere.** -/
theorem recurs_iff (R : Nat → Nat → Bool) :
    CouplingRecurs [()] (fun _ => false) (strengths R) (fun _ => [()]) () () ↔
      ∀ n, ∃ m, R n m = true :=
  ⟨fun recurs n => match recurs n with
    | ⟨_, _, late, at_⟩ => match anyUpTo_true (allUpTo_true (found_of_couplesAt at_) n late) with
      | ⟨m, _, ym⟩ => ⟨m, ym⟩,
   fun rows N => match couplesAt_of_rows (N := N) (fun n _ => rows n) with
    | ⟨u, at_⟩ => ⟨u, N, Nat.le_refl N, at_⟩⟩

/-- Given `LPO`, the rows up to `N` are each `true` somewhere, or some row is `false` throughout. -/
theorem decide_rows (R : Nat → Nat → Bool) (lpo : LPO) : ∀ N,
    (∀ n, n ≤ N → ∃ m, R n m = true) ∨ ∃ n, ∀ m, R n m = false
  | 0 => match lpo (R 0) with
    | .inl yes => .inl fun _ le => Eq.subst (motive := fun x => ∃ m, R x m = true)
        (Nat.eq_zero_of_le_zero le).symm yes
    | .inr nowhere => .inr ⟨0, nowhere⟩
  | N + 1 => match decide_rows R lpo N with
    | .inr row => .inr row
    | .inl below => match lpo (R (N + 1)) with
      | .inl yes => .inl fun n le => match le_succ_cases le with
        | .inl le' => below n le'
        | .inr eq => Eq.subst (motive := fun x => ∃ m, R x m = true) eq.symm yes
      | .inr nowhere => .inr ⟨N + 1, nowhere⟩

end Frequency.Rows

/-- **Every schedule settling is the dichotomy, exactly.** Every schedule of one condition coupled
into itself settles by some step exactly where every decided two-place family of Booleans has every
row `true` somewhere or some row `false` throughout. The core takes no excluded middle, so it does
not assert that every schedule settles. -/
theorem settled_iff_recursOrStops :
    (∀ k : Nat → Unit → Unit → Nat → Unit → Nat,
        ∃ N, SettledFrom [()] (fun _ => false) k (fun _ => [()]) N) ↔ RecursOrStops :=
  ⟨fun settles R =>
    match settles (Frequency.Rows.strengths R) with
    | ⟨N, settled⟩ =>
      match Frequency.Rows.decide_rows R
          (lpo_of_settled fun q => settles (Frequency.First.strengths q)) N with
      | .inr row => .inr row
      | .inl below => match Frequency.Rows.couplesAt_of_rows below with
        | ⟨u, at_⟩ => .inl ((Frequency.Rows.recurs_iff R).mp (settled () ()
            (couples_strengthsFrom_iff.mpr ⟨u, N, Nat.le_refl N, at_⟩))),
   fun principle _ => settled_of_recursOrStops (fun _ => .head _) principle⟩

/-- **Every schedule of every world with its conditions listed settles exactly where the dichotomy
holds.** -/
theorem settled_every_iff :
    (∀ (F' C' : Type) (cs : List C') (part : F' → Bool) (k : Nat → F' → C' → Nat → C' → Nat)
        (present : Nat → List F'), (∀ c, c ∈ cs) → ∃ N, SettledFrom cs part k present N) ↔
      RecursOrStops :=
  ⟨fun settles => settled_iff_recursOrStops.mp fun k =>
      settles Unit Unit [()] (fun _ => false) k (fun _ => [()]) (fun _ => .head _),
   fun principle _ _ _ _ _ _ every => settled_of_recursOrStops every principle⟩

/-! ## The self-loops of `Becoming.Loops` and `Becoming.Closing` as instances -/

namespace Frequency

/-- Marking every step, the count is the number of steps. -/
theorem count_always : ∀ t, count (fun _ => true) t = t
  | 0 => rfl
  | t + 1 => congrArg (· + 1) (count_always t)

/-- Marking the steps from `T`, none is counted up to `T`. -/
theorem count_before (T : Nat) : ∀ t, t ≤ T → count (Nat.ble T) t = 0
  | 0, _ => rfl
  | t + 1, le => (count_succ_off (Naturals.ble_false_of_lt le)).trans
      (count_before T t (Nat.le_of_succ_le le))

/-- Marking the steps from `T`, `r` are counted by `T + r`. -/
theorem count_from (T : Nat) : ∀ r, count (Nat.ble T) (T + r) = r
  | 0 => count_before T T (Nat.le_refl T)
  | r + 1 => (count_succ_on (Nat.ble_eq_true_of_le (Nat.le_add_right T r))).trans
      (congrArg (· + 1) (count_from T r))

/-- **The self-loop of `Becoming.Loops` couples at every step.** -/
theorem SelfLoop.always (M : Nat) :
    SelfLoop.strengths (fun _ => true) M = Loops.SelfLoop.strengths M := rfl

/-- So it carries `D * (1 + M) ^ t` (`Loops.SelfLoop.carried_eq`). -/
theorem SelfLoop.always_carried (M D t : Nat) :
    carried [()] (fun _ => false) (fun _ _ _ => 0) (Loops.SelfLoop.strengths M) (fun _ => [()])
      (fun _ => D) t () = D * (1 + M) ^ t :=
  (SelfLoop.carried_eq (fun _ => true) M D t).trans
    (congrArg (fun n => D * (1 + M) ^ n) (count_always t))

/-- **The loop of `Becoming.Closing` forming at step `T` couples at the steps from `T`.** -/
theorem SelfLoop.onset (T : Nat) :
    SelfLoop.strengths (Nat.ble T) 1 = Closing.Onset.strengths T := rfl

end Frequency

/-! ## For every law -/

section EveryLaw

variable [DecidableEq C] {cs : List C} {part : F → Bool}
  {k : Nat → F → C → Nat → C → Nat} {present : Nat → List F} {δ : C → Nat}

/-- **The rate holds of every law.** For every law of what has stood with the coupling strengths
`k`, and every two balanced flows of it with the part acting alike in both, starting within gaps at
most `D`, the strengths into each condition summing to at most `M` at each step and to nothing at
the steps `on` leaves unmarked: the gap at `c` at step `t` is at most `D * (1 + M) ^ a`, `a` the
number of steps before `t` that `on` marks. -/
theorem gap_le_count (every : ∀ c, c ∈ cs) {M D : Nat} {on : Nat → Bool}
    (bounded : ∀ c, δ c ≤ D) (into : ∀ t c, inflow cs part k present t c ≤ M)
    (quiet : ∀ t c, on t = false → inflow cs part k present t c = 0)
    {law : ExchangeLaw F C} {L L' : Flow F C} {W W' : Web F C} (na : law.Nonanticipating)
    (balances : L.Balances W) (balances' : L'.Balances W')
    (onL : ∀ t, L.present t = present t) (onL' : ∀ t, L'.present t = present t)
    (follows : L.Follows law part W.level) (follows' : L'.Follows law part W'.level)
    (strengths : ∀ t h c s d, part h = false → s ≤ t → law.RespondsWithin t h c s d (k t h c s d))
    (acts : ∀ t h c, part h = true → L.exchangeGap L' t h c ≤ 0)
    (start : ∀ c, gap (W.level 0 c) (W'.level 0 c) ≤ δ c) (t : Nat) (c : C) :
    gap (W.level t c) (W'.level t c) ≤ D * (1 + M) ^ Frequency.count on t :=
  Nat.le_trans
    (gap_le_carried (σ := fun _ _ _ => 0) na every balances balances' onL onL' follows follows'
      strengths acts start t c)
    (carried_le_count bounded into quiet t c)

end EveryLaw

/-! ## A coupling saturated by what it has carried -/

namespace Saturation

/-- What the couplings of `d` into `c` pass at step `t`, with strengths `k` and levels `l`: what
the formations present outside the part give `c` from the levels of `d` up to `t`. -/
def passingAt (part : F → Bool) (k : Nat → F → C → Nat → C → Nat) (present : Nat → List F)
    (l : Nat → C → Nat) (t : Nat) (d c : C) : Nat :=
  total (present t) fun h => bif part h then 0 else
    total (steps 0 (t + 1)) fun s => k t h c s d * l s d

/-- **What has passed through a coupling.** With the strengths of `d` into `c` at each step those of
`sat a`, `a` the amount already passed through the coupling, the amount passed from the levels `l`
of `d` into `c` across the steps before `t`. -/
def passed (part : F → Bool) (sat : Nat → Nat → F → C → Nat → C → Nat) (present : Nat → List F)
    (l : Nat → C → Nat) (d c : C) : Nat → Nat
  | 0 => 0
  | t + 1 => passed part sat present l d c t +
      passingAt part (sat (passed part sat present l d c t)) present l t d c

/-- **Strengths saturated by what has passed.** At each step the strength of each reading of `d`
into `c` is that of `sat` at the amount already passed through that coupling. -/
def strengths (part : F → Bool) (sat : Nat → Nat → F → C → Nat → C → Nat)
    (present : Nat → List F) : (Nat → C → Nat) → Nat → F → C → Nat → C → Nat :=
  fun l t h c s d => sat (passed part sat present l d c t) t h c s d

/-- The strengths of `d` into `c` do not rise as more has passed. -/
def Antitone (sat : Nat → Nat → F → C → Nat → C → Nat) (d c : C) : Prop :=
  ∀ a a', a ≤ a' → ∀ t h s, sat a' t h c s d ≤ sat a t h c s d

/-- The strengths of `d` into `c` are zero once `A` has passed. -/
def ZeroFrom (sat : Nat → Nat → F → C → Nat → C → Nat) (d c : C) (A : Nat) : Prop :=
  ∀ a, A ≤ a → ∀ t h s, sat a t h c s d = 0

/-- Strengths `f a` times the strengths `k`: `f` is how the coupling responds to what has passed. -/
def scaled (f : Nat → Nat) (k : Nat → F → C → Nat → C → Nat) : Nat → Nat → F → C → Nat → C → Nat :=
  fun a t h c s d => f a * k t h c s d

variable {cs : List C} {part : F → Bool} {σ : Nat → F → C → Nat} {present : Nat → List F}
  {sat : Nat → Nat → F → C → Nat → C → Nat} {l : Nat → C → Nat} {d c : C}

/-- Strengths that do not rise as more passes and are zero at `A` are zero from `A` on. -/
theorem Antitone.zeroFrom {A : Nat} (antitone : Antitone sat d c)
    (zero : ∀ t h s, sat A t h c s d = 0) : ZeroFrom sat d c A :=
  fun a le t h s => Nat.eq_zero_of_le_zero
    (Nat.le_trans (antitone A a le t h s) (Nat.le_of_eq (zero t h s)))

/-- What passes at a step reads the levels up to it only. -/
theorem passingAt_congr {k : Nat → F → C → Nat → C → Nat} {l' : Nat → C → Nat} {t : Nat}
    (agree : ∀ s, s ≤ t → l s d = l' s d) :
    passingAt part k present l t d c = passingAt part k present l' t d c :=
  total_congr (fun h => congrArg (cond (part h) 0)
    (total_congr_on fun s mem => congrArg (k t h c s d * ·)
      (agree s (Propagation.le_of_mem_steps_upto mem)))) _

/-- What has passed before `t` reads the levels before `t` only. -/
theorem passed_congr {l' : Nat → C → Nat} : ∀ {t : Nat}, (∀ s, s < t → l s d = l' s d) →
    passed part sat present l d c t = passed part sat present l' d c t
  | 0, _ => rfl
  | t + 1, agree =>
    have before : passed part sat present l d c t = passed part sat present l' d c t :=
      passed_congr fun s lt => agree s (Nat.lt_succ_of_lt lt)
    Naturals.add_congr before
      ((congrArg (fun a => passingAt part (sat a) present l t d c) before).trans
        (passingAt_congr fun s le => agree s (Nat.lt_succ_of_le le)))

/-- **The saturated strengths read the levels before.** What has passed before a step reads the
levels before it, so the strengths at each step read the levels up to it (`ReadsBefore`). -/
theorem readsBefore : ReadsBefore (strengths part sat present) :=
  fun t _ _ agree h c s d =>
    congrArg (fun a => sat a t h c s d) (passed_congr fun s' lt => agree s' (Nat.le_of_lt lt) d)

/-- What has passed never falls. -/
theorem passed_le_succ (t : Nat) :
    passed part sat present l d c t ≤ passed part sat present l d c (t + 1) :=
  Nat.le_add_right _ _

theorem passed_le_add (t : Nat) :
    ∀ k, passed part sat present l d c t ≤ passed part sat present l d c (t + k)
  | 0 => Nat.le_refl _
  | k + 1 => Nat.le_trans (passed_le_add t k) (passed_le_succ (t + k))

theorem passed_mono {t t' : Nat} (le : t ≤ t') :
    passed part sat present l d c t ≤ passed part sat present l d c t' :=
  match Nat.le.dest le with
  | ⟨k, same⟩ =>
    Eq.subst (motive := fun x => passed part sat present l d c t ≤ passed part sat present l d c x)
      same (passed_le_add t k)

/-- Where the strengths at the amount passed are zero, nothing passes. -/
theorem passingAt_zero {a t : Nat} (zero : ∀ h s, sat a t h c s d = 0) :
    passingAt part (sat a) present l t d c = 0 :=
  total_eq_zero fun h _ => by
    cases part h with
    | true => rfl
    | false =>
      exact total_eq_zero fun s _ => (congrArg (· * l s d) (zero h s)).trans (Nat.zero_mul _)

/-- At least one passes where a formation present outside the part reads the level of `d` at the
step itself with positive strength, and that level is positive. -/
theorem one_le_passingAt {k : Nat → F → C → Nat → C → Nat} {t : Nat} {h : F}
    (mem : h ∈ present t) (out : part h = false) (strong : 0 < k t h c t d) (stands : 0 < l t d) :
    1 ≤ passingAt part k present l t d c :=
  total_pos_of_mem (q := fun h => bif part h then 0 else
      total (steps 0 (t + 1)) fun s => k t h c s d * l s d) mem
    (Eq.subst (motive := fun b => 0 < bif b then 0 else
        total (steps 0 (t + 1)) fun s => k t h c s d * l s d) out.symm
      (total_pos_of_mem (Propagation.mem_steps_upto (Nat.le_refl t)) (Nat.mul_pos strong stands)))

/-- **Where the strength reaches zero, the coupling stops.** Where the strengths of `d` into `c` are
zero once `A` has passed, and `A` has passed by step `N`, no coupling of `d` into `c` acts from `N`
on: the coupling stops by `N` (`StopsBy`). -/
theorem stops {A N : Nat} (zero : ZeroFrom sat d c A)
    (reached : A ≤ passed part sat present l d c N) :
    StopsBy cs part (strengths part sat present l) present d c N :=
  fun u s ⟨h, _, _, le, _, pos⟩ => match Nat.lt_or_ge u N with
  | .inl early => Nat.lt_of_le_of_lt le early
  | .inr late => absurd pos (Nat.not_lt_of_le (Nat.le_of_eq
      (zero _ (Nat.le_trans reached (passed_mono late)) u h s)))

/-- So it does not recur (`StopsBy.not_recurs`). -/
theorem not_recurs {A N : Nat} (zero : ZeroFrom sat d c A)
    (reached : A ≤ passed part sat present l d c N) :
    ¬ CouplingRecurs cs part (strengths part sat present l) present d c :=
  (stops zero reached).not_recurs

/-- **Where every coupling has saturated, a finite order is exact.** Where by step `N` every coupling
has passed an amount from which its strengths are zero, order `N` is exact at every condition and
step from every start (`exact_of_reading_before`). -/
theorem exact {N : Nat}
    (all : ∀ d e, ∃ A, ZeroFrom sat d e A ∧ A ≤ passed part sat present l d e N)
    (δ : C → Nat) (t : Nat) (e : C) :
    carriedWithin cs part σ (strengths part sat present l) present δ N t e =
      carried cs part σ (strengths part sat present l) present δ t e :=
  exact_of_reading_before (fun u s d e at_ => match all d e with
    | ⟨_, zero, reached⟩ => stops zero reached u s at_) δ t e

/-- **Once saturated, nothing more passes.** Where the strengths are zero once `A` has passed and `A`
has passed by step `N`, what has passed by `N` is all that ever passes. -/
theorem passed_from {A N : Nat} (zero : ZeroFrom sat d c A)
    (reached : A ≤ passed part sat present l d c N) :
    ∀ k, passed part sat present l d c (N + k) = passed part sat present l d c N
  | 0 => rfl
  | k + 1 =>
    ((congrArg (passed part sat present l d c (N + k) + ·)
        (passingAt_zero fun h s => zero _ (Nat.le_trans reached (passed_le_add N k)) (N + k) h s)).trans
      (Nat.add_zero _)).trans (passed_from zero reached k)

/-- **What passes in all is bounded.** Where the strengths are zero once `A`, positive, has passed,
and no step passes more than `m`, what has passed is below `A + m` at every step. -/
theorem passed_lt {A m : Nat} (zero : ZeroFrom sat d c A) (pos : 0 < A)
    (most : ∀ t, passingAt part (sat (passed part sat present l d c t)) present l t d c ≤ m) :
    ∀ t, passed part sat present l d c t < A + m
  | 0 => Nat.lt_of_lt_of_le pos (Nat.le_add_right A m)
  | t + 1 => match Nat.lt_or_ge (passed part sat present l d c t) A with
    | .inl below => Nat.add_lt_add_of_lt_of_le below (most t)
    | .inr reached => Nat.lt_of_le_of_lt (Nat.le_of_eq
        ((congrArg (passed part sat present l d c t + ·)
          (passingAt_zero fun h s => zero _ reached t h s)).trans (Nat.add_zero _)))
        (passed_lt zero pos most t)

/-- **A coupling that acts until saturated climbs.** Let `P a` say the coupling is saturated once `a`
has passed, decided at every amount and kept as more passes. Where, at every step, a coupling not
yet saturated reads the level of `d` at the step itself through some formation present outside the
part with positive strength, and that level stands, at least one more passes at each step until
the coupling is saturated: by step `t`, `t` has passed or it is saturated. -/
theorem climbs {P : Nat → Prop} (decided : ∀ a, P a ∨ ¬ P a)
    (kept : ∀ a a', a ≤ a' → P a → P a')
    (acts : ∀ t a, ¬ P a → ∃ h, h ∈ present t ∧ part h = false ∧ 0 < sat a t h c t d)
    (stands : ∀ t, 0 < l t d) :
    ∀ t, t ≤ passed part sat present l d c t ∨ P (passed part sat present l d c t)
  | 0 => .inl (Nat.zero_le _)
  | t + 1 => match climbs decided kept acts stands t with
    | .inr saturated => .inr (kept _ _ (passed_le_succ t) saturated)
    | .inl upTo => match decided (passed part sat present l d c t) with
      | .inl saturated => .inr (kept _ _ (passed_le_succ t) saturated)
      | .inr open_ => match acts t _ open_ with
        | ⟨_, mem, out, strong⟩ => .inl (Nat.add_le_add upTo (one_le_passingAt mem out strong (stands t)))

/-- **A coupling that acts while unsaturated stops by its threshold.** Where the strengths of `d` into
`c` are zero once `A` has passed, while less has passed some formation present outside the part
reads the level of `d` at each step with positive strength, and that level stands at every step, `A`
has passed by step `A`, and the coupling stops by step `A`. -/
theorem stops_by {A : Nat} (zero : ZeroFrom sat d c A)
    (acts : ∀ t a, a < A → ∃ h, h ∈ present t ∧ part h = false ∧ 0 < sat a t h c t d)
    (stands : ∀ t, 0 < l t d) :
    A ≤ passed part sat present l d c A ∧
      StopsBy cs part (strengths part sat present l) present d c A :=
  have reached : A ≤ passed part sat present l d c A :=
    match climbs (P := (A ≤ ·)) (fun a => match Nat.lt_or_ge a A with
        | .inl below => .inr (Nat.not_le_of_gt below)
        | .inr reached => .inl reached)
      (fun _ _ le reached => Nat.le_trans reached le)
      (fun t a open_ => acts t a (Nat.gt_of_not_le open_)) stands A with
    | .inl reached => reached
    | .inr reached => reached
  ⟨reached, stops zero reached⟩

variable {f : Nat → Nat} {k : Nat → F → C → Nat → C → Nat}

/-- **Where the response reaches zero, the coupling stops by that amount as a step.** Let the
strengths of `d` into `c` be `f a` times `k`, `a` what has passed and `f` not rising as it grows; let
`k` read the level of `d` into `c` at each step through some formation present outside the part,
and the level of `d` stand at every step. Where `f` is zero at `A`, the coupling stops by step `A`:
by then `A` has passed, or the response is already zero. -/
theorem stops_by_zero {A : Nat} (antitone : ∀ a a', a ≤ a' → f a' ≤ f a)
    (acts : ∀ t, ∃ h, h ∈ present t ∧ part h = false ∧ 0 < k t h c t d)
    (stands : ∀ t, 0 < l t d) (zero : f A = 0) :
    StopsBy cs part (strengths part (scaled f k) present l) present d c A :=
  have climbed := climbs (sat := scaled f k) (P := (f · = 0))
    (fun a => match Nat.eq_zero_or_pos (f a) with
      | .inl zero => .inl zero
      | .inr pos => .inr fun zero => Nat.lt_irrefl 0 (Eq.subst (motive := (0 < ·)) zero pos))
    (fun a a' le zero => Nat.eq_zero_of_le_zero (Nat.le_trans (antitone a a' le) (Nat.le_of_eq zero)))
    (fun t a open_ => match acts t with
      | ⟨h, mem, out, strong⟩ => ⟨h, mem, out, Nat.mul_pos (match Nat.eq_zero_or_pos (f a) with
          | .inl zero => absurd zero open_
          | .inr pos => pos) strong⟩) stands A
  have spent : f (passed part (scaled f k) present l d c A) = 0 := match climbed with
    | .inl reached => Nat.eq_zero_of_le_zero (Nat.le_trans (antitone _ _ reached) (Nat.le_of_eq zero))
    | .inr zero => zero
  stops (A := passed part (scaled f k) present l d c A)
    (Antitone.zeroFrom (fun a a' le t h s => Nat.mul_le_mul_right (k t h c s d) (antitone a a' le))
      fun t h s => (congrArg (· * k t h c s d) spent).trans (Nat.zero_mul _))
    (Nat.le_refl _)

/-- **A coupling stops exactly where its response reaches zero.** With the premises of
`Saturation.stops_by_zero` and `d` listed, the coupling stops by some step exactly where `f` is
zero at some amount: if it stops, the strength at the stopping step is zero. -/
theorem stops_iff (antitone : ∀ a a', a ≤ a' → f a' ≤ f a) (listed : d ∈ cs)
    (acts : ∀ t, ∃ h, h ∈ present t ∧ part h = false ∧ 0 < k t h c t d)
    (stands : ∀ t, 0 < l t d) :
    (∃ N, StopsBy cs part (strengths part (scaled f k) present l) present d c N) ↔
      ∃ A, f A = 0 :=
  ⟨fun ⟨N, stopped⟩ => match Nat.eq_zero_or_pos (f (passed part (scaled f k) present l d c N)) with
    | .inl zero => ⟨_, zero⟩
    | .inr pos => match acts N with
      | ⟨h, mem, out, strong⟩ => absurd (stopped N N ⟨h, mem, out, Nat.le_refl N, listed,
          Nat.mul_pos pos strong⟩) (Nat.lt_irrefl N),
   fun ⟨A, zero⟩ => ⟨A, stops_by_zero antitone acts stands zero⟩⟩

/-- **Saturation that never reaches zero does not stop the coupling.** With the response at least one
at every amount, the coupling of `d` into `c` recurs, and at least one more passes at every step. -/
theorem floored (floor : ∀ a, 0 < f a) (listed : d ∈ cs)
    (acts : ∀ t, ∃ h, h ∈ present t ∧ part h = false ∧ 0 < k t h c t d)
    (stands : ∀ t, 0 < l t d) :
    CouplingRecurs cs part (strengths part (scaled f k) present l) present d c ∧
      ∀ t, t ≤ passed part (scaled f k) present l d c t :=
  ⟨fun N => match acts N with
    | ⟨h, mem, out, strong⟩ =>
      ⟨N, N, Nat.le_refl N, h, mem, out, Nat.le_refl N, listed, Nat.mul_pos (floor _) strong⟩,
   fun t => match climbs (sat := scaled f k) (P := fun _ => False) (fun _ => .inr id)
       (fun _ _ _ no => no)
       (fun t a _ => match acts t with
        | ⟨h, mem, out, strong⟩ => ⟨h, mem, out, Nat.mul_pos (floor a) strong⟩) stands t with
    | .inl climbed => climbed
    | .inr no => no.elim⟩

/-- **A floored self-coupling leaves every finite order inexact.** A condition coupled into itself
with a response at least one at every amount, acting at each step from a level that stands, is a
loop of a recurring coupling: chains in time order of every length end at it, so no finite order is
exact there at every step (`unbounded_of_recurring_loop`). Where the response reaches zero instead,
the coupling stops and a finite order is exact (`Saturation.exact`). -/
theorem floored_inexact (floor : ∀ a, 0 < f a) (listed : c ∈ cs)
    (acts : ∀ t, ∃ h, h ∈ present t ∧ part h = false ∧ 0 < k t h c t c)
    (stands : ∀ t, 0 < l t c) :
    ¬ ∃ J, ∀ t, ¬ CoupledIntoBy cs part (strengths part (scaled f k) present l) present (J + 1) t c :=
  unbounded_of_recurring_loop (v := fun _ => c) (m := 1) (Nat.succ_pos 0) rfl rfl
    (fun _ _ => (floored floor listed acts stands).1) (u := fun _ => c) (q := 0) rfl rfl
    (fun _ lt => absurd lt (Nat.not_lt_zero _))

/-! ### In the formed course -/

/-- A formation's gift splits into the part's gap and what each coupling of a listed condition
passes. -/
theorem carriedGive_split (k : Nat → F → C → Nat → C → Nat) (l : Nat → C → Nat) (t : Nat) (h : F)
    (e : C) :
    carriedGive cs part σ k t h e l = (bif part h then σ t h e else 0) +
      total cs fun d => bif part h then 0 else total (steps 0 (t + 1)) fun s => k t h e s d * l s d := by
  unfold carriedGive
  cases part h with
  | true => exact (Nat.add_zero _).symm.trans (congrArg (σ t h e + ·) (total_zero cs).symm)
  | false =>
    exact (total_swap (fun s d => k t h e s d * l s d) cs (steps 0 (t + 1))).trans
      (Nat.zero_add _).symm

/-- What the formations present give `e` is the part's gaps and what passes through each coupling of
a listed condition into `e`. -/
theorem total_carriedGive (k : Nat → F → C → Nat → C → Nat) (l : Nat → C → Nat) (t : Nat) (e : C) :
    total (present t) (fun h => carriedGive cs part σ k t h e l) =
      total (present t) (fun h => bif part h then σ t h e else 0) +
        total cs fun d => passingAt part k present l t d e :=
  (total_congr (fun h => carriedGive_split k l t h e) (present t)).trans
    ((total_add _ _ (present t)).trans (congrArg (_ + ·)
      (total_swap (fun h d => bif part h then 0 else
        total (steps 0 (t + 1)) fun s => k t h e s d * l s d) cs (present t))))

variable {δ : C → Nat}

/-- **What the formed course gains is what passes.** Under the carrying law with strengths saturated
by what has passed, the course at `e` grows across each step by the part's gaps and what passes
through each coupling of a listed condition into `e`: what has passed is what the course carries
through the coupling. -/
theorem course_succ (t : Nat) (e : C) :
    formedCourse cs part σ (strengths part sat present) present δ (t + 1) e =
      formedCourse cs part σ (strengths part sat present) present δ t e +
        total (present t) (fun h => bif part h then σ t h e else 0) +
        total cs fun d => passingAt part
          (sat (passed part sat present (formedCourse cs part σ (strengths part sat present) present δ)
            d e t)) present (formedCourse cs part σ (strengths part sat present) present δ) t d e :=
  (formedCourse_succ readsBefore t e).trans
    ((congrArg (_ + ·) (total_carriedGive _ _ t e)).trans (Nat.add_assoc _ _ _).symm)

/-- The formed course never falls, so a level standing at the start stands at every step. -/
theorem course_stands (start : 0 < δ d) :
    ∀ t, 0 < formedCourse cs part σ (strengths part sat present) present δ t d
  | 0 => start
  | t + 1 => Nat.lt_of_lt_of_le (course_stands start t)
      (Nat.le_trans (Nat.le_trans (Nat.le_add_right _ _) (Nat.le_add_right _ _))
        (Nat.le_of_eq (course_succ t d).symm))

/-- **In the formed course, a coupling saturated by what it carries stops by its threshold.** Under
the carrying law with strengths saturated by what has passed, where the strengths of `d` into `c`
are zero once `A` has passed, act while less has passed, and `d` stands at the start, the coupling
stops by step `A`, and from then on nothing more passes through it. -/
theorem course_stops_by {A : Nat} (zero : ZeroFrom sat d c A)
    (acts : ∀ t a, a < A → ∃ h, h ∈ present t ∧ part h = false ∧ 0 < sat a t h c t d)
    (start : 0 < δ d) :
    StopsBy cs part (strengths part sat present
        (formedCourse cs part σ (strengths part sat present) present δ)) present d c A ∧
      ¬ CouplingRecurs cs part (strengths part sat present
        (formedCourse cs part σ (strengths part sat present) present δ)) present d c ∧
      ∀ k, passed part sat present (formedCourse cs part σ (strengths part sat present) present δ)
          d c (A + k) =
        passed part sat present (formedCourse cs part σ (strengths part sat present) present δ) d c A :=
  match stops_by zero acts (course_stands start) with
  | ⟨reached, stopped⟩ => ⟨stopped, not_recurs zero reached, passed_from zero reached⟩

/-- **In the formed course, a coupling stops exactly where its response reaches zero.** Under the
carrying law with strengths `f a` times `k`, `a` what has passed and `f` not rising, `k` reading the
level of `d`, listed, into `c` at each step through some formation present outside the part, and `d`
standing at the start, the coupling stops by some step exactly where `f` is zero at some amount
(`Saturation.stops_iff`). -/
theorem course_stops_iff (antitone : ∀ a a', a ≤ a' → f a' ≤ f a) (listed : d ∈ cs)
    (acts : ∀ t, ∃ h, h ∈ present t ∧ part h = false ∧ 0 < k t h c t d) (start : 0 < δ d) :
    (∃ N, StopsBy cs part (strengths part (scaled f k) present
        (formedCourse cs part σ (strengths part (scaled f k) present) present δ)) present d c N) ↔
      ∃ A, f A = 0 :=
  stops_iff antitone listed acts (course_stands start)

/-- **A response wearing down by what passes stops the coupling by its threshold.** In the formed
course with strengths `A - a` times `k`, `a` what has passed, `k` reading the level of `d` into `c`
at each step through some formation present outside the part, and `d` standing at the start, the
coupling stops by step `A` (`Saturation.stops_by_zero`). -/
theorem wearing_stops {A : Nat} {k : Nat → F → C → Nat → C → Nat}
    (acts : ∀ t, ∃ h, h ∈ present t ∧ part h = false ∧ 0 < k t h c t d) (start : 0 < δ d) :
    StopsBy cs part (strengths part (scaled (A - ·) k) present
      (formedCourse cs part σ (strengths part (scaled (A - ·) k) present) present δ)) present d c A :=
  stops_by_zero (fun a _ le => match le_dest le with
      | ⟨j, same⟩ => Eq.subst (motive := fun y => A - y ≤ A - a) same.symm
          (Nat.le_trans (Nat.le_of_eq (Naturals.sub_sub A a j).symm) (Nat.sub_le (A - a) j)))
    acts (course_stands start) (Nat.sub_self A)

end Saturation

end Becoming
