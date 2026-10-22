import Mathlib.MeasureTheory.Integral.IntervalIntegral.FundThmCalculus
import Mathlib.Analysis.SpecificLimits.Basic
import Mathlib.Analysis.SpecificLimits.Normed
import Mathlib.Data.Fintype.Pi
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Deriv
import Becoming.Frequency


/-!
# Representation: what discrete steps and whole amounts represent

The spine reads every becoming at discrete steps with amounts counted in whole numbers (chapter §0,
block A). This module asks, over Mathlib's reals, whether every becoming can be so represented, and
states the laws that depend on the representation with real amounts and real-valued time.

* **Real-valued time is read at steps exactly for balance.** A course whose levels change at the
  rate given less the rate taken (`Course.Balances`), its rates summable over every stretch,
  balances over every stretch with what was given and taken summed over it (`Course.balance_over`,
  the fundamental theorem of calculus), so read at any instants it balances across each step
  (`Course.sample_balances`), and what a coarser step gives is what the finer steps inside it give,
  summed (`Course.givenOver_coarse`, `Course.takenOver_coarse`): the readings at ever finer instants
  are a tower, as `Becoming.Tower` builds continuous time in the core. What a reading at steps does
  not show is what changes within a step: a balanced course read at the whole instants stands at
  nothing at every step while between them it rises to two and falls back
  (`Oscillation.still_reading`), as `Becoming.Sampling` finds activity read at steps step-relative.
* **Whole amounts are not available for every becoming.** No reading into the whole numbers keeps
  the order of an amount falling at every step (`no_whole_reading`), and real amounts fall so
  (`halving_falls`, `reals_no_whole_reading`); amounts in multiples of a unit are read in whole
  numbers keeping order and sums (`unit_reading`). The core states the same of any amounts with an
  endless fall (`Becoming.Amounts.no_whole_reading`).
* **Rest** needs a least fall over any amounts (`Becoming.Amounts.rests`,
  `Becoming.World.InAmounts.change_stops_iff`), and real amounts have none.
* **Novelty needs gain exactly where it is by a least separation.** A level halving at every step
  is new at every step, never rises and stays within one (`new_without_gain`): the whole-number law
  `Becoming.Web.rises_late_of_new` fails. But finitely many conditions whose configuration differs
  from every earlier one by at least `ε` at some condition cannot stay between nothing and any bound
  (`separated_bounded`, `separated_exceeds`): novelty by a least separation needs gain.
* **Runaway is set by frequency where the difference is held, by strength where it is damped.** A
  loop on one condition keeping the difference with factor `a` and returning it with strength `r` at
  the marked steps (`carried`): held (`a = 1`) it carries `D (1 + r) ^ count` (`held_carried`), the
  core's self-loop at a whole strength being its case (`selfLoop_cast`), and for every positive real
  strength it is bounded by a polynomial exactly where two to the number of steps at which it
  couples is (`held_polynomial_iff`): how often decides, how strong only how large, as in whole
  numbers. Damped, coupling at every step, it stays bounded exactly where `a + r ≤ 1`
  (`every_bounded_iff`) and vanishes below one (`every_vanishes`): there strength decides. Whole
  amounts cannot keep a factor below one, so the core's loop is held.
* **Several conditions.** For the step `M = a I + S` of a web of conditions coupled at every step,
  in any normed ring of such steps, the rate (`rate`, the least `‖M ^ k‖ ^ (1 / k)`, by Gelfand's
  formula the spectral radius) decides: what the web carries vanishes exactly where the rate is
  below one (`vanishes_iff`) and runs away where it is above one (`unbounded_of_one_lt`); at one
  condition the rate is `|a + r|` (`rate_real`, `every_vanishes_iff`). Held and coupling at some
  steps only, a web carries `(1 + S) ^ count` (`webCarried_eq`), and where the rate of `1 + S` is
  above one it is bounded by a polynomial exactly where two to the count is (`web_polynomial_iff`):
  the frequency law for several conditions. Damped, a web coupling at some steps only carries
  `a ^ (t - count) (a + S) ^ count` (`dampedWeb_eq`), and where couplings are rare enough for the
  damping, `a ^ (1 - θ) B ^ θ < 1` with `θ` the share of steps that couple, it vanishes whatever its
  strength (`dampedWeb_vanishes`); where they are frequent enough, `a ^ (1 - θ) ρ ^ θ > 1` with `θ`
  a share of steps that couple at least and `ρ` the rate of `a + S`, it runs away
  (`dampedWeb_unbounded`).

The declarations use Lean's standard axioms through Mathlib; the laws they read are the core's, with
empty axiom reports. That an actual becoming's rates are summable, its amounts real and its loops
of this form are correspondences, not checked. No ethical premise occurs.
-/

open MeasureTheory Filter Topology

namespace Becoming.Representation

/-! ## Real-valued time, read at steps -/

/-- A course in real-valued time over conditions `C`: each condition's level at each instant, and
the rates at which it is given to and taken from. -/
structure Course (C : Type*) where
  level : ℝ → C → ℝ
  given : ℝ → C → ℝ
  taken : ℝ → C → ℝ

namespace Course

variable {C : Type*} (κ : Course C)

/-- **Balance in real-valued time**: each level changes at the rate it is given less the rate it is
taken from. -/
def Balances : Prop :=
  ∀ c t, HasDerivAt (fun s => κ.level s c) (κ.given t c - κ.taken t c) t

/-- The rates can be summed over every stretch. -/
def Summable' : Prop :=
  ∀ c a b, IntervalIntegrable (fun s => κ.given s c) volume a b ∧
    IntervalIntegrable (fun s => κ.taken s c) volume a b

/-- What is given to `c` from `a` to `b`. -/
noncomputable def givenOver (a b : ℝ) (c : C) : ℝ := ∫ s in a..b, κ.given s c

/-- What is taken from `c` from `a` to `b`. -/
noncomputable def takenOver (a b : ℝ) (c : C) : ℝ := ∫ s in a..b, κ.taken s c

variable {κ}

/-- **Balance over every stretch.** In real-valued time, a level at the end of a stretch, with what
was taken from it over the stretch, is its level at the start with what was given to it. -/
theorem balance_over (balances : κ.Balances) (summable : κ.Summable') (a b : ℝ) (c : C) :
    κ.level b c + κ.takenOver a b c = κ.level a c + κ.givenOver a b c := by
  have ftc := intervalIntegral.integral_eq_sub_of_hasDerivAt (f := fun s => κ.level s c)
    (fun x _ => balances c x) (((summable c a b).1).sub (summable c a b).2)
  rw [intervalIntegral.integral_sub (summable c a b).1 (summable c a b).2] at ftc
  simp only [givenOver, takenOver]
  linarith

/-- The course read at the instants `τ`: the levels there, and what is given and taken over each
step between them. -/
noncomputable def sample (κ : Course C) (τ : ℕ → ℝ) : (ℕ → C → ℝ) × (ℕ → C → ℝ) × (ℕ → C → ℝ) :=
  (fun n c => κ.level (τ n) c, fun n c => κ.givenOver (τ n) (τ (n + 1)) c,
    fun n c => κ.takenOver (τ n) (τ (n + 1)) c)

/-- **Every reading at steps balances.** A course balanced in real-valued time, read at any
instants, balances across each step, with the amounts summed over the step. -/
theorem sample_balances (balances : κ.Balances) (summable : κ.Summable') (τ : ℕ → ℝ) (n : ℕ) (c : C) :
    (κ.sample τ).1 (n + 1) c + (κ.sample τ).2.2 n c = (κ.sample τ).1 n c + (κ.sample τ).2.1 n c :=
  balance_over balances summable (τ n) (τ (n + 1)) c

/-- **Readings compose.** Read at a coarser step `σ n` to `σ (n + 1)` of the instants `τ`, what is
given over the coarse step is what is given over the fine steps inside it, summed: the readings at
ever finer instants are a tower (`Becoming.Tower`). -/
theorem givenOver_coarse (summable : κ.Summable') (τ : ℕ → ℝ) (m k : ℕ) (c : C) :
    κ.givenOver (τ m) (τ (m + k)) c =
      ∑ i ∈ Finset.range k, κ.givenOver (τ (m + i)) (τ (m + i + 1)) c := by
  simp only [givenOver]
  exact (intervalIntegral.sum_integral_adjacent_intervals (f := fun s => κ.given s c)
    (a := fun i => τ (m + i)) (n := k) (fun i _ => (summable c _ _).1)).symm

/-- And what is taken. -/
theorem takenOver_coarse (summable : κ.Summable') (τ : ℕ → ℝ) (m k : ℕ) (c : C) :
    κ.takenOver (τ m) (τ (m + k)) c =
      ∑ i ∈ Finset.range k, κ.takenOver (τ (m + i)) (τ (m + i + 1)) c := by
  simp only [takenOver]
  exact (intervalIntegral.sum_integral_adjacent_intervals (f := fun s => κ.taken s c)
    (a := fun i => τ (m + i)) (n := k) (fun i _ => (summable c _ _).2)).symm

end Course

/-! ## What a reading at steps does not show -/

namespace Oscillation

open Real

/-- One condition standing at `1 - cos (2πt)`, given at the rate `2π sin (2πt)` where that is
positive and taken at `2π (-sin (2πt))` where that is. -/
noncomputable def course : Course Unit :=
  ⟨fun t _ => 1 - cos (2 * π * t), fun t _ => 2 * π * max (sin (2 * π * t)) 0,
    fun t _ => 2 * π * max (-sin (2 * π * t)) 0⟩

theorem balances : course.Balances := by
  intro _ t
  have h := (((hasDerivAt_id t).const_mul (2 * π)).cos).const_sub 1
  have e : 2 * π * max (sin (2 * π * t)) 0 - 2 * π * max (-sin (2 * π * t)) 0 =
      -(-sin (2 * π * id t) * (2 * π * 1)) := by
    rcases le_total (sin (2 * π * t)) 0 with neg | pos
    · rw [max_eq_right neg, max_eq_left (by linarith)]; simp; ring
    · rw [max_eq_left pos, max_eq_right (by linarith)]; simp; ring
  simpa [course, e] using h

theorem summable : course.Summable' := fun _ a b =>
  ⟨(by fun_prop : Continuous fun s : ℝ => 2 * π * max (sin (2 * π * s)) 0).intervalIntegrable a b,
   (by fun_prop : Continuous fun s : ℝ => 2 * π * max (-sin (2 * π * s)) 0).intervalIntegrable a b⟩

/-- Read at the whole instants, the condition stands at nothing at every step. -/
theorem still_at_steps (n : ℕ) : (course.sample (fun n => (n : ℝ))).1 n () = 0 := by
  show 1 - cos (2 * π * (n : ℝ)) = 0
  rw [show 2 * π * (n : ℝ) = n * (2 * π) by ring, cos_nat_mul_two_pi]
  ring

/-- Between the whole instants it rises to two and falls back. -/
theorem changes_between (n : ℕ) : course.level ((n : ℝ) + 1 / 2) () = 2 := by
  show 1 - cos (2 * π * ((n : ℝ) + 1 / 2)) = 2
  rw [show 2 * π * ((n : ℝ) + 1 / 2) = π + n * (2 * π) by ring, cos_add_nat_mul_two_pi, cos_pi]
  ring

/-- **A balanced course whose reading at steps is still.** The course balances in real-valued time;
read at the whole instants it stands at nothing at every step, so the reading shows no change, while
between every two instants it rises to two and falls back: what changes within a step is not shown,
as `Becoming.Sampling` finds for activity read at steps (`Strobe.acting_taking_step_relative`). -/
theorem still_reading :
    course.Balances ∧ (∀ n, (course.sample (fun n => (n : ℝ))).1 n () = 0) ∧
      ∀ n : ℕ, course.level ((n : ℝ) + 1 / 2) () = 2 :=
  ⟨balances, still_at_steps, changes_between⟩

end Oscillation

/-! ## Whole amounts -/

/-- **No whole-number reading of an endless fall.** Where amounts fall at every step, no reading of
them into the whole numbers keeps their order: it would fall at every step without end. -/
theorem no_whole_reading {α : Type*} [Preorder α] (s : ℕ → α) (falls : ∀ n, s (n + 1) < s n) :
    ¬ ∃ φ : α → ℕ, StrictMono φ := by
  rintro ⟨φ, mono⟩
  have : ∀ n, φ (s n) + n ≤ φ (s 0) := by
    intro n
    induction n with
    | zero => simp
    | succ n ih => have := mono (falls n); omega
  have := this (φ (s 0) + 1)
  omega

/-- **Real amounts fall without end**: halving. -/
theorem halving_falls (n : ℕ) : ((1 : ℝ) / 2) ^ (n + 1) < (1 / 2) ^ n := by
  rw [pow_succ]
  have : (0 : ℝ) < (1 / 2) ^ n := by positivity
  linarith

/-- So real amounts have no whole-number reading keeping their order. -/
theorem reals_no_whole_reading : ¬ ∃ φ : ℝ → ℕ, StrictMono φ :=
  no_whole_reading _ halving_falls

/-- **Amounts in multiples of a unit are read in whole numbers**, keeping order and sums. -/
theorem unit_reading {ε : ℝ} (pos : 0 < ε) (m n : ℕ) :
    ((m : ℝ) * ε ≤ n * ε ↔ m ≤ n) ∧ (m : ℝ) * ε + n * ε = ((m + n : ℕ) : ℝ) * ε := by
  refine ⟨⟨fun h => by exact_mod_cast le_of_mul_le_mul_right h pos, fun h => by gcongr⟩, ?_⟩
  push_cast; ring

/-! ## Novelty in real amounts -/

/-- **New without gain.** In real amounts a level halving at every step is new at every step and
never rises: the whole-number law that novelty needs gain fails. -/
theorem new_without_gain :
    (∀ m n, m < n → ((1 : ℝ) / 2) ^ n ≠ (1 / 2) ^ m) ∧ (∀ n, ((1 : ℝ) / 2) ^ (n + 1) ≤ (1 / 2) ^ n) ∧
      ∀ n, ((1 : ℝ) / 2) ^ n ≤ 1 := by
  refine ⟨fun m n lt => ne_of_lt (pow_lt_pow_right_of_lt_one₀ (by norm_num) (by norm_num) lt),
    fun n => (halving_falls n).le, fun n => pow_le_one₀ (by norm_num) (by norm_num)⟩

/-- Two amounts at or above nothing in the same cell of width `ε` lie within `ε`. -/
theorem close_of_cell {a b ε : ℝ} (pos : 0 < ε) (ha : 0 ≤ a) (hb : 0 ≤ b)
    (same : ⌊a / ε⌋₊ = ⌊b / ε⌋₊) : |a - b| < ε := by
  have a1 := Nat.floor_le (div_nonneg ha pos.le)
  have a2 := Nat.lt_floor_add_one (a / ε)
  have b1 := Nat.floor_le (div_nonneg hb pos.le)
  have b2 := Nat.lt_floor_add_one (b / ε)
  rw [same] at a1 a2
  have : |a / ε - b / ε| < 1 := abs_sub_lt_iff.mpr ⟨by linarith, by linarith⟩
  have e : a - b = ε * (a / ε - b / ε) := by field_simp
  rw [e, abs_mul, abs_of_pos pos]
  nlinarith [abs_nonneg (a / ε - b / ε)]

/-- **Novelty by a least separation needs gain.** Finitely many conditions whose levels stay
between nothing and `B`, and whose configuration at each step differs from every earlier one by at
least `ε` at some condition: impossible. -/
theorem separated_bounded {C : Type*} [Fintype C] {x : ℕ → C → ℝ} {B ε : ℝ} (pos : 0 < ε)
    (low : ∀ n c, 0 ≤ x n c) (high : ∀ n c, x n c ≤ B)
    (new : ∀ m n, m < n → ∃ c, ε ≤ |x n c - x m c|) : False := by
  let cell : ℕ → C → Fin (⌊B / ε⌋₊ + 1) := fun n c =>
    ⟨⌊x n c / ε⌋₊, Nat.lt_succ_of_le (Nat.floor_le_floor (div_le_div_of_nonneg_right (high n c) pos.le))⟩
  obtain ⟨m, n, ne, same⟩ := Finite.exists_ne_map_eq_of_infinite cell
  have near : ∀ c, |x n c - x m c| < ε := fun c => by
    have h := congrFun same c
    simp only [cell, Fin.mk.injEq] at h
    exact close_of_cell pos (low n c) (low m c) h.symm
  rcases lt_or_gt_of_ne ne with lt | lt
  · obtain ⟨c, far⟩ := new m n lt
    exact absurd (near c) (not_lt.mpr far)
  · obtain ⟨c, far⟩ := new n m lt
    have := near c
    rw [abs_sub_comm] at this
    exact absurd this (not_lt.mpr far)

/-- So a family new by at least `ε` at every step exceeds every bound: it gains without end. -/
theorem separated_exceeds {C : Type*} [Fintype C] {x : ℕ → C → ℝ} {ε : ℝ} (pos : 0 < ε)
    (low : ∀ n c, 0 ≤ x n c) (new : ∀ m n, m < n → ∃ c, ε ≤ |x n c - x m c|) (B : ℝ) :
    ∃ n c, B < x n c := by
  by_contra none
  simp only [not_exists, not_lt] at none
  exact separated_bounded pos low none new

/-! ## Runaway in real strengths -/

/-- What a loop on one condition carries in real amounts: across each step the difference is kept
with factor `a`, and at the steps `on` marks the loop returns it with strength `r`. The core's loop
keeps the difference whole, `a = 1` (`Becoming.Frequency.SelfLoop`). -/
noncomputable def carried (a r D : ℝ) (on : ℕ → Bool) : ℕ → ℝ
  | 0 => D
  | t + 1 => (a + bif on t then r else 0) * carried a r D on t

/-- Bounded by a polynomial in the steps. -/
def Polynomial (f : ℕ → ℝ) : Prop :=
  ∃ K : ℝ, ∃ d : ℕ, ∀ t, f t ≤ K * ((t : ℝ) + 1) ^ d

/-- **A held loop carries `D (1 + r) ^ a`**, `a` the marked steps before `t`, as in whole numbers. -/
theorem held_carried (r D : ℝ) (on : ℕ → Bool) : ∀ t, carried 1 r D on t = D * (1 + r) ^ Frequency.count on t
  | 0 => by simp [carried, Frequency.count]
  | t + 1 => by
    rw [carried, held_carried r D on t, Frequency.count]
    cases on t
    · simp
    · simp [pow_succ]; ring


/-- **The whole-number loop is the held loop at a whole strength.** What the core's self-loop
carries with strength `M` from `D` (`Becoming.Frequency.SelfLoop.carried_eq`), read as a real
amount, is what the held loop carries with strength `M`. -/
theorem selfLoop_cast (on : ℕ → Bool) (M D : ℕ) (t : ℕ) :
    ((Becoming.carried [()] (fun _ => false) (fun _ _ _ => 0) (Frequency.SelfLoop.strengths on M) (fun _ => [()])
        (fun _ => D) t () : ℕ) : ℝ) = Representation.carried 1 M D on t := by
  rw [Frequency.SelfLoop.carried_eq, held_carried]
  push_cast
  ring

/-- **The frequency law in real strengths.** A held loop of any positive real strength is bounded by
a polynomial exactly where two to the number of steps at which it couples is: how often it couples
decides whether it runs away, how strong only how large (`Becoming.Frequency.SelfLoop.polynomial_iff`
in whole numbers, where a positive strength is at least one). -/
theorem held_polynomial_iff {r D : ℝ} (strong : 0 < r) (pos : 0 < D) (on : ℕ → Bool) :
    Polynomial (carried 1 r D on) ↔ Polynomial (fun t => (2 : ℝ) ^ Frequency.count on t) := by
  have hb : (1 : ℝ) < 1 + r := by linarith
  simp only [Polynomial, held_carried]
  constructor
  · rintro ⟨K, d, bound⟩
    obtain ⟨m, hm⟩ := pow_unbounded_of_one_lt (2 : ℝ) hb
    refine ⟨(K / D) ^ m, d * m, fun t => ?_⟩
    have c0 : 0 < (1 + r) ^ Frequency.count on t := by positivity
    have b1 : (1 + r) ^ Frequency.count on t ≤ K / D * ((t : ℝ) + 1) ^ d := by
      rw [div_mul_eq_mul_div, le_div_iff₀ pos]; linarith [bound t]
    calc (2 : ℝ) ^ Frequency.count on t ≤ ((1 + r) ^ m) ^ Frequency.count on t :=
          pow_le_pow_left₀ (by norm_num) hm.le _
      _ = ((1 + r) ^ Frequency.count on t) ^ m := by rw [← pow_mul, ← pow_mul, mul_comm]
      _ ≤ (K / D * ((t : ℝ) + 1) ^ d) ^ m := pow_le_pow_left₀ c0.le b1 _
      _ = (K / D) ^ m * ((t : ℝ) + 1) ^ (d * m) := by rw [mul_pow, ← pow_mul]
  · rintro ⟨K, d, bound⟩
    obtain ⟨m, hm⟩ := pow_unbounded_of_one_lt (1 + r) (by norm_num : (1 : ℝ) < 2)
    refine ⟨D * K ^ m, d * m, fun t => ?_⟩
    have c0 : (0 : ℝ) < 2 ^ Frequency.count on t := by positivity
    calc D * (1 + r) ^ Frequency.count on t ≤ D * ((2 : ℝ) ^ m) ^ Frequency.count on t := by
          gcongr
      _ = D * ((2 : ℝ) ^ Frequency.count on t) ^ m := by rw [← pow_mul, ← pow_mul, mul_comm m]
      _ ≤ D * (K * ((t : ℝ) + 1) ^ d) ^ m := by
          gcongr; exact bound t
      _ = D * K ^ m * ((t : ℝ) + 1) ^ (d * m) := by rw [mul_pow, ← pow_mul, mul_assoc]

/-- A loop coupling at every step carries `D (a + r) ^ t`. -/
theorem every_carried (a r D : ℝ) : ∀ t, carried a r D (fun _ => true) t = D * (a + r) ^ t
  | 0 => by simp [carried]
  | t + 1 => by rw [carried, every_carried a r D t]; simp [pow_succ]; ring

/-- **With damping, strength decides.** Where the difference is kept with a factor `a`, a loop
coupling at every step keeps what it carries bounded exactly where `a + r` is at most one: a held
loop (`a = 1`) runs away at every positive strength, a damped one only where its strength makes up
for the damping. Whole amounts cannot keep a factor below one, so the core's loop is held. -/
theorem every_bounded_iff {a r D : ℝ} (pos : 0 < D) (nonneg : 0 ≤ a + r) :
    (∃ K, ∀ t, carried a r D (fun _ => true) t ≤ K) ↔ a + r ≤ 1 := by
  simp only [every_carried]
  constructor
  · rintro ⟨K, bound⟩
    by_contra above
    obtain ⟨n, hn⟩ := pow_unbounded_of_one_lt (K / D) (not_le.mp above)
    have := bound n
    rw [div_lt_iff₀ pos] at hn
    linarith
  · intro le
    exact ⟨D, fun t => by
      have := pow_le_one₀ nonneg le (n := t)
      nlinarith⟩

/-- Below one, what a damped loop carries vanishes. -/
theorem every_vanishes {a r D : ℝ} (nonneg : 0 ≤ a + r) (below : a + r < 1) :
    Filter.Tendsto (carried a r D (fun _ => true)) Filter.atTop (nhds 0) := by
  have h : carried a r D (fun _ => true) = fun t => D * (a + r) ^ t := funext (every_carried a r D)
  rw [h]
  simpa using (tendsto_pow_atTop_nhds_zero_of_lt_one nonneg below).const_mul D

/-! ## Several conditions with real strengths -/

section Web

variable {A : Type*} [NormedRing A]

/-- **The rate of a web.** For the step `M` of a web of conditions (the difference kept with
factor `a` and returned with strengths `S`, `M = a I + S`, in any normed ring of such steps), the
least `‖M ^ k‖ ^ (1 / k)` over the steps `k ≥ 1`. By Gelfand's formula it is the spectral radius of
`M`; one condition's rate is `|a + r|` (`rate_real`). -/
noncomputable def rate (M : A) : ℝ :=
  ⨅ k : ℕ, ‖M ^ (k + 1)‖ ^ ((1 : ℝ) / (k + 1))

theorem rate_bdd (M : A) : BddBelow (Set.range fun k : ℕ => ‖M ^ (k + 1)‖ ^ ((1 : ℝ) / (k + 1))) :=
  ⟨0, by rintro _ ⟨k, rfl⟩; positivity⟩

theorem rate_le (M : A) (k : ℕ) : rate M ≤ ‖M ^ (k + 1)‖ ^ ((1 : ℝ) / (k + 1)) :=
  ciInf_le (rate_bdd M) k

/-- Each power is at least the rate to that power. -/
theorem pow_rate_le (M : A) (k : ℕ) (pos : 0 ≤ rate M) : rate M ^ (k + 1) ≤ ‖M ^ (k + 1)‖ := by
  have h := pow_le_pow_left₀ pos (rate_le M k) (k + 1)
  rwa [← Real.rpow_natCast (‖M ^ (k + 1)‖ ^ _), ← Real.rpow_mul (norm_nonneg _),
    show (1 : ℝ) / (k + 1) * ((k + 1 : ℕ) : ℝ) = 1 by push_cast; field_simp, Real.rpow_one] at h

/-- **Above one, a web runs away**: what it carries from some start exceeds every bound. -/
theorem unbounded_of_one_lt {M : A} (above : 1 < rate M) (K : ℝ) : ∃ n, K < ‖M ^ n‖ := by
  obtain ⟨k, hk⟩ := pow_unbounded_of_one_lt K above
  exact ⟨k + 1, lt_of_lt_of_le (lt_of_lt_of_le hk (pow_le_pow_right₀ above.le (Nat.le_succ k)))
    (pow_rate_le M k (by linarith))⟩

/-- **A web's carried difference vanishes exactly where its rate is below one.** -/
theorem vanishes_iff [NormOneClass A] (M : A) : Tendsto (fun n => ‖M ^ n‖) atTop (𝓝 0) ↔ rate M < 1 := by
  constructor
  · intro h
    obtain ⟨n, hn⟩ := (h.eventually (gt_mem_nhds (show (0 : ℝ) < 1 by norm_num))).exists_forall_of_atTop
    have small := hn (n + 1) (Nat.le_succ n)
    refine lt_of_le_of_lt (rate_le M n) ?_
    exact Real.rpow_lt_one (norm_nonneg _) small (by positivity)
  · intro below
    obtain ⟨k, hk⟩ := exists_lt_of_ciInf_lt below
    set m := k + 1 with hm
    have q1 : ‖M ^ m‖ < 1 := by
      by_contra not
      exact absurd hk (not_lt.mpr (Real.one_le_rpow (not_lt.mp not) (by positivity)))
    set C := ∑ r ∈ Finset.range m, ‖M ^ r‖
    have bound : ∀ n, ‖M ^ n‖ ≤ C * ‖M ^ m‖ ^ (n / m) := by
      intro n
      have split : M ^ n = (M ^ m) ^ (n / m) * M ^ (n % m) := by
        rw [← pow_mul, ← pow_add, Nat.div_add_mod]
      rw [split]
      calc ‖(M ^ m) ^ (n / m) * M ^ (n % m)‖ ≤ ‖(M ^ m) ^ (n / m)‖ * ‖M ^ (n % m)‖ := norm_mul_le _ _
        _ ≤ ‖M ^ m‖ ^ (n / m) * ‖M ^ (n % m)‖ := by gcongr; exact norm_pow_le _ _
        _ ≤ ‖M ^ m‖ ^ (n / m) * C := by
            gcongr
            exact Finset.single_le_sum (f := fun r => ‖M ^ r‖) (fun _ _ => norm_nonneg _)
              (Finset.mem_range.mpr (Nat.mod_lt n (by omega)))
        _ = C * ‖M ^ m‖ ^ (n / m) := mul_comm _ _
    have lim : Tendsto (fun n => C * ‖M ^ m‖ ^ (n / m)) atTop (𝓝 0) := by
      have t := (tendsto_pow_atTop_nhds_zero_of_lt_one (norm_nonneg _) q1).comp
        (Nat.tendsto_div_const_atTop (show m ≠ 0 by omega))
      simpa using t.const_mul C
    exact squeeze_zero (fun _ => norm_nonneg _) bound lim

/-- **One condition: the rate is `|a + r|`.** -/
theorem rate_real (c : ℝ) : rate c = |c| := by
  have each : ∀ k : ℕ, ‖c ^ (k + 1)‖ ^ ((1 : ℝ) / (k + 1)) = |c| := fun k => by
    rw [norm_pow, Real.norm_eq_abs, ← Real.rpow_natCast, ← Real.rpow_mul (abs_nonneg c)]
    rw [show ((k + 1 : ℕ) : ℝ) * (1 / (k + 1)) = 1 by push_cast; field_simp, Real.rpow_one]
  simp only [rate, each, ciInf_const]


/-- What a held web carries: across each step the difference is kept whole, and at the steps `on`
marks the web returns it with the strengths `S`. -/
def webCarried (S : A) (on : ℕ → Bool) : ℕ → A
  | 0 => 1
  | t + 1 => (bif on t then 1 + S else 1) * webCarried S on t

/-- **A held web carries `(1 + S) ^ count`**: the steps at which it does not couple change nothing,
so only how many steps couple matters, not which. -/
theorem webCarried_eq (S : A) (on : ℕ → Bool) : ∀ t, webCarried S on t = (1 + S) ^ Frequency.count on t
  | 0 => by simp [webCarried, Frequency.count]
  | t + 1 => by
    rw [webCarried, webCarried_eq S on t, Frequency.count]
    cases on t
    · simp
    · simp [pow_succ']

/-- **The frequency law for several conditions.** A held web whose rate of `1 + S` is above one
carries an amount bounded by a polynomial in the steps exactly where two to the number of steps at
which it couples is: how often it couples decides, how strong only how large. -/
theorem web_polynomial_iff [NormOneClass A] {S : A} (above : 1 < rate (1 + S)) (on : ℕ → Bool) :
    Polynomial (fun t => ‖webCarried S on t‖) ↔ Polynomial (fun t => (2 : ℝ) ^ Frequency.count on t) := by
  simp only [Polynomial, webCarried_eq]
  have lower : ∀ c : ℕ, rate (1 + S) ^ c ≤ ‖(1 + S) ^ c‖ := fun c => by
    cases c with
    | zero => simp
    | succ k => exact pow_rate_le _ k (by linarith)
  constructor
  · rintro ⟨K, d, bound⟩
    obtain ⟨m, hm⟩ := pow_unbounded_of_one_lt (2 : ℝ) above
    refine ⟨K ^ m, d * m, fun t => ?_⟩
    have b1 : rate (1 + S) ^ Frequency.count on t ≤ K * ((t : ℝ) + 1) ^ d :=
      (lower _).trans (bound t)
    have r0 : 0 ≤ rate (1 + S) ^ Frequency.count on t := by
      have : (0 : ℝ) ≤ rate (1 + S) := by linarith
      positivity
    calc (2 : ℝ) ^ Frequency.count on t ≤ (rate (1 + S) ^ m) ^ Frequency.count on t :=
          pow_le_pow_left₀ (by norm_num) hm.le _
      _ = (rate (1 + S) ^ Frequency.count on t) ^ m := by rw [← pow_mul, ← pow_mul, mul_comm]
      _ ≤ (K * ((t : ℝ) + 1) ^ d) ^ m := pow_le_pow_left₀ r0 b1 _
      _ = K ^ m * ((t : ℝ) + 1) ^ (d * m) := by rw [mul_pow, ← pow_mul]
  · rintro ⟨K, d, bound⟩
    obtain ⟨m, hm⟩ := pow_unbounded_of_one_lt ‖1 + S‖ (by norm_num : (1 : ℝ) < 2)
    refine ⟨K ^ m, d * m, fun t => ?_⟩
    calc ‖(1 + S) ^ Frequency.count on t‖ ≤ ‖1 + S‖ ^ Frequency.count on t := norm_pow_le _ _
      _ ≤ ((2 : ℝ) ^ m) ^ Frequency.count on t := pow_le_pow_left₀ (norm_nonneg _) hm.le _
      _ = ((2 : ℝ) ^ Frequency.count on t) ^ m := by rw [← pow_mul, ← pow_mul, mul_comm]
      _ ≤ (K * ((t : ℝ) + 1) ^ d) ^ m := pow_le_pow_left₀ (by positivity) (bound t) _
      _ = K ^ m * ((t : ℝ) + 1) ^ (d * m) := by rw [mul_pow, ← pow_mul]

/-- **One condition, as a web.** The damped loop coupling at every step vanishes exactly where
`a + r` is below one: the web law at one condition, whose rate is `a + r`. -/
theorem every_vanishes_iff {a r D : ℝ} (pos : 0 < D) (nonneg : 0 ≤ a + r) :
    Tendsto (carried a r D (fun _ => true)) atTop (𝓝 0) ↔ a + r < 1 := by
  rw [← abs_of_nonneg nonneg, ← rate_real, ← vanishes_iff]
  have h : carried a r D (fun _ => true) = fun t => D * ‖(a + r) ^ t‖ := funext fun t => by
    rw [every_carried, norm_pow, Real.norm_eq_abs, abs_of_nonneg nonneg]
  rw [h]
  constructor
  · intro t
    simpa [pos.ne'] using t.const_mul D⁻¹
  · intro t
    simpa using t.const_mul D

end Web

section Damped

variable {A : Type*} [NormedRing A] [NormedAlgebra ℝ A] [NormOneClass A]

/-- What a damped web carries: across each step the difference is kept with the factor `a`, and at
the steps `on` marks the web also returns it with the strengths `S`. -/
noncomputable def dampedWeb (a : ℝ) (S : A) (on : ℕ → Bool) : ℕ → A
  | 0 => 1
  | t + 1 => (bif on t then algebraMap ℝ A a + S else algebraMap ℝ A a) * dampedWeb a S on t

omit [NormOneClass A] in
/-- **A damped web factors into damping and coupling**: it carries `a ^ (t - count)` times
`(a + S) ^ count`, the damping being a factor that commutes with every step. -/
theorem dampedWeb_eq (a : ℝ) (S : A) (on : ℕ → Bool) : ∀ t,
    dampedWeb a S on t = algebraMap ℝ A a ^ (t - Frequency.count on t) *
      (algebraMap ℝ A a + S) ^ Frequency.count on t
  | 0 => by simp [dampedWeb, Frequency.count]
  | t + 1 => by
    have le := Frequency.count_le on t
    have comm : Commute (algebraMap ℝ A a + S) (algebraMap ℝ A a ^ (t - Frequency.count on t)) :=
      (Algebra.commute_algebraMap_left a (algebraMap ℝ A a + S)).symm.pow_right _
    rw [dampedWeb, dampedWeb_eq a S on t, Frequency.count]
    cases on t
    · simp only [cond_false, add_zero]
      rw [show t + 1 - Frequency.count on t = t - Frequency.count on t + 1 by omega, pow_succ', mul_assoc]
    · simp only [cond_true]
      rw [show t + 1 - (Frequency.count on t + 1) = t - Frequency.count on t by omega, ← mul_assoc,
        comm.eq, mul_assoc, ← pow_succ']

/-- **Rare couplings are absorbed by damping, whatever their strength.** Where the difference is
kept with a factor `0 < a < 1`, the coupled step is at most `B ≥ 1` in norm, and at most a share `θ`
of the steps couple, with `a ^ (1 - θ) * B ^ θ < 1`, what the web carries vanishes. -/
theorem dampedWeb_vanishes {a B θ : ℝ} {S : A} {on : ℕ → Bool} (a0 : 0 < a) (a1 : a < 1) (B1 : 1 ≤ B)
    (bound : ‖algebraMap ℝ A a + S‖ ≤ B)
    (rare : ∀ t, (Frequency.count on t : ℝ) ≤ θ * t) (q1 : a ^ (1 - θ) * B ^ θ < 1) :
    Tendsto (fun t => ‖dampedWeb a S on t‖) atTop (𝓝 0) := by
  have q0 : 0 ≤ a ^ (1 - θ) * B ^ θ := by positivity
  refine squeeze_zero (fun _ => norm_nonneg _) (fun t => ?_)
    (tendsto_pow_atTop_nhds_zero_of_lt_one q0 q1)
  have le := Frequency.count_le on t
  have ct : (Frequency.count on t : ℝ) ≤ t := by exact_mod_cast le
  rw [dampedWeb_eq]
  calc ‖algebraMap ℝ A a ^ (t - Frequency.count on t) * (algebraMap ℝ A a + S) ^ Frequency.count on t‖
      ≤ ‖algebraMap ℝ A a‖ ^ (t - Frequency.count on t) * ‖algebraMap ℝ A a + S‖ ^ Frequency.count on t :=
        (norm_mul_le _ _).trans (mul_le_mul (norm_pow_le _ _) (norm_pow_le _ _) (norm_nonneg _)
          (by positivity))
    _ ≤ a ^ (t - Frequency.count on t) * B ^ Frequency.count on t := by
        rw [norm_algebraMap', Real.norm_eq_abs, abs_of_pos a0]
        gcongr
    _ = a ^ ((t : ℝ) - Frequency.count on t) * B ^ (Frequency.count on t : ℝ) := by
        rw [← Real.rpow_natCast, ← Real.rpow_natCast, Nat.cast_sub le]
    _ ≤ a ^ ((1 - θ) * t) * B ^ (θ * t) :=
        mul_le_mul (Real.rpow_le_rpow_of_exponent_ge a0 a1.le (by linarith [rare t]))
          (Real.rpow_le_rpow_of_exponent_le B1 (rare t)) (by positivity) (by positivity)
    _ = (a ^ (1 - θ) * B ^ θ) ^ t := by
        rw [Real.rpow_mul a0.le, Real.rpow_mul (by linarith), ← Real.mul_rpow (by positivity) (by positivity),
          Real.rpow_natCast]

/-- Every power is at least the rate to that power, the empty power included. -/
theorem rate_pow_le_norm {B : Type*} [NormedRing B] [NormOneClass B] (M : B) (pos : 0 ≤ rate M) (c : ℕ) :
    rate M ^ c ≤ ‖M ^ c‖ := by
  cases c with
  | zero => simp
  | succ k => exact pow_rate_le M k pos

/-- **Frequent couplings run away against damping.** Where the difference is kept with a factor
`0 < a ≤ 1`, the rate of the coupled step `a + S` is at least one, and at least a share `θ` of the
steps couple, with `a ^ (1 - θ) * rate (a + S) ^ θ > 1`, what the web carries exceeds every bound. -/
theorem dampedWeb_unbounded {a θ : ℝ} {S : A} {on : ℕ → Bool} (a0 : 0 < a) (a1 : a ≤ 1)
    (r1 : 1 ≤ rate (algebraMap ℝ A a + S)) (frequent : ∀ t, θ * t ≤ (Frequency.count on t : ℝ))
    (q1 : 1 < a ^ (1 - θ) * rate (algebraMap ℝ A a + S) ^ θ) (K : ℝ) :
    ∃ t, K < ‖dampedWeb a S on t‖ := by
  obtain ⟨t, ht⟩ := pow_unbounded_of_one_lt K q1
  refine ⟨t, lt_of_lt_of_le ht ?_⟩
  set ρ := rate (algebraMap ℝ A a + S)
  have le := Frequency.count_le on t
  have ct : (Frequency.count on t : ℝ) ≤ t := by exact_mod_cast le
  have norm_eq : ‖dampedWeb a S on t‖ =
      a ^ (t - Frequency.count on t) * ‖(algebraMap ℝ A a + S) ^ Frequency.count on t‖ := by
    rw [dampedWeb_eq, ← map_pow, ← Algebra.smul_def, norm_smul, Real.norm_eq_abs,
      abs_of_pos (by positivity)]
  rw [norm_eq]
  calc (a ^ (1 - θ) * ρ ^ θ) ^ t = a ^ ((1 - θ) * t) * ρ ^ (θ * t) := by
        rw [Real.rpow_mul a0.le, Real.rpow_mul (by linarith), ← Real.mul_rpow (by positivity)
          (by positivity), Real.rpow_natCast]
    _ ≤ a ^ ((t : ℝ) - Frequency.count on t) * ρ ^ (Frequency.count on t : ℝ) :=
        mul_le_mul (Real.rpow_le_rpow_of_exponent_ge a0 a1 (by linarith [frequent t]))
          (Real.rpow_le_rpow_of_exponent_le r1 (frequent t)) (by positivity) (by positivity)
    _ = a ^ (t - Frequency.count on t) * ρ ^ Frequency.count on t := by
        rw [← Real.rpow_natCast, ← Real.rpow_natCast, Nat.cast_sub le]
    _ ≤ a ^ (t - Frequency.count on t) * ‖(algebraMap ℝ A a + S) ^ Frequency.count on t‖ := by
        gcongr
        exact rate_pow_le_norm _ (by linarith) _

end Damped

end Becoming.Representation
