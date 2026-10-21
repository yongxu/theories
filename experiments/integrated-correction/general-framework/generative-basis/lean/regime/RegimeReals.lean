import Mathlib.Topology.Instances.NNReal.Lemmas
import Mathlib.Topology.Order.MonotoneConvergence
import Mathlib.Analysis.SpecificLimits.Basic
import Becoming.RegimeMargin

/-!
# The regime over the non-negative reals

`Becoming.RegimeMargin` states the regime in whole numbers, where every change moves an amount by at
least one, so that every run of an adjustment rising in both arguments within a band comes to rest
(`Adjusted.comes_to_rest`), and its fates are decided at a fixed step (`Adjusted.falls_iff`). Its
`Drawn` laws read the adjusted step in any linearly ordered amounts with a draw: the step keeps the
order of states, and from the first step on a run's steps climb or sink toward the draw, each kind
followed by its own kind, until the run raises or lowers both at once, after which it does so for
ever (`Drawn.run_shape`). This module reads them over the non-negative reals, with Mathlib.

* **The reals are amounts with a draw** (`Drawn.reals`), the draw taking all but what it takes, or
  everything.
* **Every run within a band converges** (`Drawn.converges`): by the shape of its course each of the
  level and the recent giving is monotone from some step on, and bounded.
* **To a rest, where the adjustment is continuous** (`Drawn.limit_rest`, `Drawn.limit_fates`): the
  limit is the regime's point, the recent giving at the draw, or a state within the draw with level
  and recent giving equal.
* **The fates are ordered as the states are** (`Drawn.limits_below`): limits keep the order of the
  states run from. So a state at or below one whose run converges below the draw converges below it
  too (`Drawn.falls_of_below`), and a larger recent giving at the same level never turns a fall into
  a hold (`Drawn.falls_given`): the states falling below the draw are down-closed, the boundary a
  falling curve in the plane of level and recent giving.
* **A run need not come to rest** (`Relaxation.never_rests`): giving that moves halfway from the
  recent giving to the draw keeps a band up to the draw, and the run from nothing converges toward
  the draw without ever reaching it. What the whole numbers give as a rest within a fixed number of
  steps is, over the reals, convergence.

Discrete steps, the draw taken first, and the state the level and one recent giving are the
representation's commitments. The declarations here use Lean's standard axioms through Mathlib; the
laws they read are the core's, with empty axiom reports. No ethical premise occurs.
-/

open Filter Topology

namespace Becoming.RegimeMargin.Drawn

/-- **The non-negative reals are amounts with a draw.** -/
noncomputable def reals : Drawn NNReal where
  zero := 0
  add := (· + ·)
  le := (· ≤ ·)
  le_refl := le_refl
  le_trans := fun h h' => le_trans h h'
  add_assoc := add_assoc
  add_comm := add_comm
  zero_add := zero_add
  add_le_add_right := fun c h => _root_.add_le_add_left h c
  le_of_add_le_add_right := fun _ h => _root_.le_of_add_le_add_right h
  zero_le := fun _ => _root_.zero_le
  sub := (· - ·)
  add_sub := fun h => add_tsub_cancel_of_le h
  sub_zero := fun h => tsub_eq_zero_of_le h
  total := le_total
  antisymm := fun h h' => le_antisymm h h'

theorem reals_step (A : NNReal → NNReal → NNReal) (H : NNReal) :
    reals.step A H = fun p => (p.1 - H + A (p.1 - H) p.2, A (p.1 - H) p.2) := rfl

/-- A sequence that rises from some step on and is bounded converges. -/
theorem tendsto_of_rising {u : ℕ → NNReal} {m : ℕ} {hi : NNReal} (up : ∀ k, m ≤ k → u k ≤ u (k + 1))
    (bound : ∀ n, u n ≤ hi) : ∃ l, Tendsto u atTop (𝓝 l) := by
  have mono : Monotone fun k => u (k + m) :=
    monotone_nat_of_le_succ fun k => by
      simpa [Nat.add_right_comm] using up (k + m) (Nat.le_add_left m k)
  have bdd : BddAbove (Set.range fun k => u (k + m)) := ⟨hi, by rintro _ ⟨k, rfl⟩; exact bound _⟩
  exact ⟨_, (tendsto_add_atTop_iff_nat m).1 (tendsto_atTop_ciSup mono bdd)⟩

/-- A sequence that falls from some step on converges. -/
theorem tendsto_of_falling {u : ℕ → NNReal} {m : ℕ} (down : ∀ k, m ≤ k → u (k + 1) ≤ u k) :
    ∃ l, Tendsto u atTop (𝓝 l) := by
  have anti : Antitone fun k => u (k + m) :=
    antitone_nat_of_succ_le fun k => by
      simpa [Nat.add_right_comm] using down (k + m) (Nat.le_add_left m k)
  exact ⟨_, (tendsto_add_atTop_iff_nat m).1 (tendsto_atTop_ciInf anti (OrderBot.bddBelow _))⟩

variable {A : NNReal → NNReal → NNReal} {H hi : NNReal}

/-- **Every run within a band converges.** Where the adjustment rises with what is left and with the
recent giving and keeps a band up to `hi`, the run from a level and a recent giving up to `hi`
converges: by the shape of its course the level and the recent giving are each monotone from some
step on. -/
theorem converges (rises : reals.Rises A) (band : reals.Band A H hi) {s : NNReal × NNReal}
    (high : s.1 ≤ hi) (given : s.2 ≤ hi) :
    ∃ L, Tendsto (fun n => (Law.run (reals.step A H) s).state n) atTop (𝓝 L) := by
  have within := run_within (D := reals) (s := s) band high given
  have pair : ∀ {u : ℕ → NNReal × NNReal}, (∃ l, Tendsto (fun n => (u n).1) atTop (𝓝 l)) →
      (∃ l, Tendsto (fun n => (u n).2) atTop (𝓝 l)) → ∃ L, Tendsto u atTop (𝓝 L) :=
    fun ⟨l1, h1⟩ ⟨l2, h2⟩ => ⟨(l1, l2), h1.prodMk_nhds h2⟩
  by_cases ordered : ∃ n, reals.Below ((Law.run (reals.step A H) s).state (n + 1))
      ((Law.run (reals.step A H) s).state (n + 2)) ∨
      reals.Below ((Law.run (reals.step A H) s).state (n + 2)) ((Law.run (reals.step A H) s).state (n + 1))
  · obtain ⟨n, up | down⟩ := ordered
    · have all := (run_shape rises H s (n + 1)).2.2.2.1 up
      have step : ∀ k, n + 1 ≤ k → reals.Below ((Law.run (reals.step A H) s).state k)
          ((Law.run (reals.step A H) s).state (k + 1)) := fun k le => by
        obtain ⟨j, rfl⟩ := Nat.exists_eq_add_of_le le
        exact all j
      exact pair (tendsto_of_rising (fun k le => (step k le).1) fun i => (within i).1)
        (tendsto_of_rising (fun k le => (step k le).2) fun i => (within i).2)
    · have all := (run_shape rises H s (n + 1)).2.2.2.2 down
      have step : ∀ k, n + 1 ≤ k → reals.Below ((Law.run (reals.step A H) s).state (k + 1))
          ((Law.run (reals.step A H) s).state k) := fun k le => by
        obtain ⟨j, rfl⟩ := Nat.exists_eq_add_of_le le
        exact all j
      exact pair (tendsto_of_falling fun k le => (step k le).1)
        (tendsto_of_falling fun k le => (step k le).2)
  · simp only [not_exists, not_or] at ordered
    rcases (run_shape rises H s 0).1 (ordered 0).1 (ordered 0).2 with climb | sink
    · have all : ∀ k, reals.Climbs H ((Law.run (reals.step A H) s).state (k + 1))
          ((Law.run (reals.step A H) s).state (k + 2)) := by
        intro k
        induction k with
        | zero => exact climb
        | succ k ih => exact (run_shape rises H s (k + 1)).2.1 ih (ordered (k + 1)).1 (ordered (k + 1)).2
      have step : ∀ k, 1 ≤ k → reals.Climbs H ((Law.run (reals.step A H) s).state k)
          ((Law.run (reals.step A H) s).state (k + 1)) := fun k le => by
        obtain ⟨j, rfl⟩ := Nat.exists_eq_add_of_le le
        rw [Nat.add_comm 1 j]
        exact all j
      exact pair (tendsto_of_rising (fun k le => (step k le).1) fun i => (within i).1)
        (tendsto_of_falling fun k le => (step k le).2.2.1)
    · have all : ∀ k, reals.Sinks H ((Law.run (reals.step A H) s).state (k + 1))
          ((Law.run (reals.step A H) s).state (k + 2)) := by
        intro k
        induction k with
        | zero => exact sink
        | succ k ih => exact (run_shape rises H s (k + 1)).2.2.1 ih (ordered (k + 1)).1 (ordered (k + 1)).2
      have step : ∀ k, 1 ≤ k → reals.Sinks H ((Law.run (reals.step A H) s).state k)
          ((Law.run (reals.step A H) s).state (k + 1)) := fun k le => by
        obtain ⟨j, rfl⟩ := Nat.exists_eq_add_of_le le
        rw [Nat.add_comm 1 j]
        exact all j
      exact pair (tendsto_of_falling fun k le => (step k le).1)
        (tendsto_of_rising (fun k le => (step k le).2.2.1) fun i => (within i).2)

/-- **The limit is a rest where the adjustment is continuous.** -/
theorem limit_rest (cont : Continuous fun q : NNReal × NNReal => A q.1 q.2) {s L : NNReal × NNReal}
    (lim : Tendsto (fun n => (Law.run (reals.step A H) s).state n) atTop (𝓝 L)) :
    reals.step A H L = L := by
  have left : Continuous fun p : NNReal × NNReal => p.1 - H := continuous_fst.sub continuous_const
  have giving : Continuous fun p : NNReal × NNReal => A (p.1 - H) p.2 :=
    cont.comp (left.prodMk continuous_snd)
  have stepCont : Continuous (reals.step A H) := by
    rw [reals_step]
    exact (left.add giving).prodMk giving
  have next : Tendsto (fun n => reals.step A H ((Law.run (reals.step A H) s).state n)) atTop (𝓝 L) :=
    (tendsto_add_atTop_iff_nat 1).2 lim
  exact tendsto_nhds_unique ((stepCont.tendsto L).comp lim) next

/-- **Every run within a band converges to a rest**, where the adjustment is continuous: to the
regime's point, with the recent giving at the draw and the adjustment giving the draw from what is
left, or within the draw with level and recent giving equal and the adjustment from nothing left
giving it again. -/
theorem limit_fates (rises : reals.Rises A) (band : reals.Band A H hi)
    (cont : Continuous fun q : NNReal × NNReal => A q.1 q.2) {s : NNReal × NNReal}
    (high : s.1 ≤ hi) (given : s.2 ≤ hi) :
    ∃ L, Tendsto (fun n => (Law.run (reals.step A H) s).state n) atTop (𝓝 L) ∧
      ((L.2 = H ∧ H ≤ L.1 ∧ A (L.1 - H) H = H) ∨ (L.1 ≤ H ∧ L.1 = L.2 ∧ A 0 L.2 = L.2)) :=
  have ⟨L, lim⟩ := converges rises band high given
  ⟨L, lim, rest_iff.1 (limit_rest cont lim)⟩

/-- **Limits keep the order of the states run from.** -/
theorem limits_below (rises : reals.Rises A) {p q Lp Lq : NNReal × NNReal} (below : reals.Below p q)
    (limp : Tendsto (fun n => (Law.run (reals.step A H) p).state n) atTop (𝓝 Lp))
    (limq : Tendsto (fun n => (Law.run (reals.step A H) q).state n) atTop (𝓝 Lq)) :
    Lp.1 ≤ Lq.1 ∧ Lp.2 ≤ Lq.2 :=
  have order := Lasting.orbit_mono (rel := reals.Below) (fun _ _ b => step_mono rises H b) below
  ⟨le_of_tendsto_of_tendsto' ((continuous_fst.tendsto Lp).comp limp)
      ((continuous_fst.tendsto Lq).comp limq) fun n => (order n).1,
    le_of_tendsto_of_tendsto' ((continuous_snd.tendsto Lp).comp limp)
      ((continuous_snd.tendsto Lq).comp limq) fun n => (order n).2⟩

/-- The run from a state converges below the draw. -/
def Falls (A : NNReal → NNReal → NNReal) (H : NNReal) (p : NNReal × NNReal) : Prop :=
  ∃ L, Tendsto (fun n => (Law.run (reals.step A H) p).state n) atTop (𝓝 L) ∧ L.1 < H

/-- **Below a state whose run converges below the draw, every run does**, within a band. -/
theorem falls_of_below (rises : reals.Rises A) (band : reals.Band A H hi) {p q : NNReal × NNReal}
    (below : reals.Below p q) (high : q.1 ≤ hi) (given : q.2 ≤ hi) (falls : Falls A H q) :
    Falls A H p :=
  have ⟨_, limq, low⟩ := falls
  have ⟨Lp, limp⟩ := converges rises band (le_trans below.1 high) (le_trans below.2 given)
  ⟨Lp, limp, lt_of_le_of_lt (limits_below rises below limp limq).1 low⟩

/-- **More recent giving never turns a fall into a hold**: at one level, a run from a larger recent
giving that converges below the draw has one from a smaller recent giving that does too. -/
theorem falls_given (rises : reals.Rises A) (band : reals.Band A H hi) {x r r' : NNReal}
    (le : r ≤ r') (high : x ≤ hi) (given : r' ≤ hi) (falls : Falls A H (x, r')) : Falls A H (x, r) :=
  falls_of_below (p := (x, r)) (q := (x, r')) rises band ⟨le_refl x, le⟩ high given falls

namespace Relaxation

/-- Giving that moves halfway from the recent giving to a draw of one. -/
noncomputable def giving (_ r : NNReal) : NNReal := (r + 1) / 2

theorem rises : reals.Rises giving := fun _ _ r r' _ le => by
  show (r + 1) / 2 ≤ (r' + 1) / 2
  gcongr
  exact le

/-- At or below the draw of one, the step takes everything and gives half of the recent giving and
one. -/
theorem step_low {x r : NNReal} (low : x ≤ 1) : reals.step giving 1 (x, r) = ((r + 1) / 2, (r + 1) / 2) := by
  show (x - 1 + (r + 1) / 2, (r + 1) / 2) = _
  rw [tsub_eq_zero_of_le low, zero_add]

theorem band : reals.Band giving 1 1 := fun x r high given => by
  rw [step_low high]
  show (r + 1) / 2 ≤ 1
  rw [div_le_one (by norm_num : (0 : NNReal) < 2)]
  calc r + 1 ≤ 1 + 1 := _root_.add_le_add_left given 1
    _ = 2 := one_add_one_eq_two

/-- From nothing, the run's level and recent giving are equal, and they fall short of one by
`(1/2)^n`. -/
theorem course : ∀ n, ((Law.run (reals.step giving 1) (0, 0)).state n).1 =
      ((Law.run (reals.step giving 1) (0, 0)).state n).2 ∧
    ((Law.run (reals.step giving 1) (0, 0)).state n).2 + (1 / 2) ^ n = 1
  | 0 => ⟨rfl, by show (0 : NNReal) + (1 / 2) ^ 0 = 1; simp⟩
  | n + 1 => by
    obtain ⟨same, short⟩ := course n
    have low : ((Law.run (reals.step giving 1) (0, 0)).state n).1 ≤ 1 := by
      rw [same]; exact (le_self_add : _ ≤ _ + (1 / 2 : NNReal) ^ n).trans_eq short
    have next : (Law.run (reals.step giving 1) (0, 0)).state (n + 1) =
        ((((Law.run (reals.step giving 1) (0, 0)).state n).2 + 1) / 2,
          (((Law.run (reals.step giving 1) (0, 0)).state n).2 + 1) / 2) :=
      step_low low
    rw [next]
    refine ⟨rfl, ?_⟩
    show (((Law.run (reals.step giving 1) (0, 0)).state n).2 + 1) / 2 + (1 / 2) ^ (n + 1) = 1
    rw [pow_succ, mul_one_div, ← add_div, add_right_comm, short, one_add_one_eq_two,
      div_self two_ne_zero]

/-- **A run that converges and never rests.** Giving that moves halfway from the recent giving to a
draw of one rises in both arguments and keeps a band up to one; the run from nothing converges, yet
at no step is it still from then on. -/
theorem never_rests :
    reals.Rises giving ∧ reals.Band giving 1 1 ∧
    (∃ L, Tendsto (fun n => (Law.run (reals.step giving 1) (0, 0)).state n) atTop (𝓝 L)) ∧
    ∀ T, ¬ LastChange.StillFrom (Law.run (reals.step giving 1) (0, 0)) T :=
  ⟨rises, band, converges rises band zero_le_one zero_le_one, fun T still => by
    have same : ((Law.run (reals.step giving 1) (0, 0)).state (T + 1)).2 =
        ((Law.run (reals.step giving 1) (0, 0)).state T).2 := congrArg Prod.snd (still 0)
    have now := (course T).2
    have next := (course (T + 1)).2
    rw [same] at next
    have eq : (1 / 2 : NNReal) ^ (T + 1) = (1 / 2) ^ T := add_left_cancel (next.trans now.symm)
    have lt : (1 / 2 : NNReal) ^ (T + 1) < (1 / 2) ^ T :=
      pow_lt_pow_right_of_lt_one₀ (by norm_num) (by norm_num) (Nat.lt_succ_self T)
    exact absurd eq (ne_of_lt lt)⟩

end Relaxation

end Becoming.RegimeMargin.Drawn
