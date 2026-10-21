import Becoming.Regulation
import Becoming.Retaining

/-!
# Reading schedules: one reader, several conditions

`Regulation` reads one condition at a time. Here one reader reads one condition a step (a
schedule `s : Nat → X`, conditions read by their names), and a selection acts on what it reads
only by withdrawing a drawer: it does not raise any level. A drawer on a condition is withdrawn
`ℓ` steps after a step at which the schedule reads that condition, so a stretch of `k` steps left
unread is a draw of `k + 1 + ℓ` steps. The questions are which conditions a reader keeps within
their margins, and how many it can keep.

* **One condition, exactly.** A schedule reads `x` within every `a` steps (`Within`) where every
  stretch of `a` steps reads it; with equality decided, exactly where no stretch of `a` steps
  leaves it unread (`within_iff`). A schedule *keeps* `c` within the margin `m` against draws of
  at most `d` a step (`Keeps`) where, in every balanced flow, a part drawing on `c` alone and
  withdrawn as above retains whatever has significance without it, wherever the levels without it
  exceed the need on `c` by `m`. With `(a + ℓ) d ≤ m < (a + 1 + ℓ) d`, a schedule keeps `c` exactly
  where it reads `c` within every `a` steps (`keeps_iff_within`). One side is the margin law
  (`Flow.Balances.retains_of_read`, several conditions at once, from
  `Flow.Balances.retains_iff_within_margin`); the other is a witness: a stretch of `a` steps left
  unread lets one drawer (`Drawer.flow`, `Drawer.web`) take `(a + 1 + ℓ) d` and lose the formation
  needing `c` (`within_of_keeps`). In a given flow, a stretch left unread loses what lies beyond the
  margin (`Flow.Balances.loses_of_unread`, from `Flow.Balances.loses_iff_beyond_margin`).
* **What one reader can carry, counted.** A schedule reading conditions distinct by their names
  within windows `a c` gives, over every `P` steps, counts `q c` with `q c * a c ≤ P` totalling at
  most `P` (`density`): in rates, `∑ 1 / a c ≤ 1`. A pool naming at most `k` conditions a step
  carries `P k` (`pool_density`); one reader is the pool of one (`Within.pool`). On the base:
  `keeps_density`.
* **Spare capacity is not enough.** No schedule reads three distinct conditions within every 2, 3
  and `M` steps, for any `M` (`no_two_three`): a reading of the third sits between two readings of
  the first, and those three steps hold no reading of the second. For `M ≥ 7` the counts over
  `6 M` steps leave the reader idle a share `1/6 - 1/M` (`two_three_room`). On the base: no
  schedule keeps three conditions whose margins give these windows (`spare_not_enough`).
* **Half a reader suffices, constructively.** Two schedules interleaved (`weave`) read what each
  reads at half the speed (`weave_left`, `weave_right`). A binary code (`Code`) reads a condition
  at depth `k` within every `2 ^ k` steps (`Code.At.reads`). Items with depths at most `D` whose
  weights `2 ^ (D - k)` total at most `2 ^ D` (Kraft's inequality) are placed by pairing codes from
  the deepest level up (`pair`, `build`, `build_length`, `build_holds`), so one code reads every
  item within its depth's window (`kraft_reads`). Rounding each window down to a power of two at
  most doubles its rate (`lg`, `lg_spec`), so windows with `∑ 1 / a c ≤ 1/2`, stated with whole
  weights `2 ^ (D + 1) ≤ q c * a c` totalling at most `2 ^ D`, are read by one schedule
  (`half_suffices`). On the base: one schedule keeps every condition whose margin gives such a
  window (`keeps_of_half`).

What these laws are. This is pinwheel scheduling (Holte, Mok, Rosier, Tulchinsky and Varvel, 1989:
a ground station reading satellites, each within its window) read as a selection that only
withdraws. The counting bound, the instance `2, 3, M` and the half-density construction by powers
of two are known there; the exact density threshold, every instance with `∑ 1 / a ≤ 5/6`
schedulable, was conjectured by Chan and Chin (1993) and proved by Kawamura (2024), with a
computer search over finitely many cases; it is cited, not proved here. What the module adds is the
correspondence on the spine: the windows come from the margin law, the draw a step and the
lateness, `a` the largest with `(a + ℓ) d ≤ m`, so each step of lateness shortens every window by
one; and keeping is exactly reading within the window, in every balanced flow.

Modelling choices: discrete steps, whole-number amounts, a reader that reads one condition a step
(a pool, `k`), a drawer withdrawn a fixed `ℓ` steps after a reading, and a draw bounded by `d` a
step. Rounding windows to powers of two loses up to half the reader; between one half and five
sixths this module proves nothing. Every declaration has an empty axiom report. No ethical
predicate, ranking or axiom occurs.
-/

namespace Becoming

namespace ReadingSchedule

open Regulation

variable {X : Type}

/-- Shifting the last of three summands: `T + j + ℓ` is one short of `T + (j + 1 + ℓ)`. -/
theorem shift_lt {T j ℓ u : Nat} (le : T + (j + 1 + ℓ) ≤ u) : T + j + ℓ < u :=
  Nat.lt_of_lt_of_le (Nat.lt_succ_self _) (Nat.le_trans (Nat.le_of_eq (by
    rw [Nat.add_assoc T j ℓ, Nat.add_right_comm j 1 ℓ]; rfl)) le)

/-- `T + (j + 1 + ℓ)` is one past `T + j + ℓ`. -/
theorem shift_le {T j ℓ u : Nat} (lt : T + j + ℓ < u) : T + (j + 1 + ℓ) ≤ u :=
  Nat.le_trans (Nat.le_of_eq (by rw [Nat.add_assoc T j ℓ, Nat.add_right_comm j 1 ℓ]; rfl)) lt

/-- What is `d` where a test holds and nothing elsewhere is at most `d`. -/
theorem ite_le (p : Prop) [Decidable p] (d : Nat) : (if p then d else 0) ≤ d :=
  if h : p then Nat.le_of_eq (if_pos h) else Nat.le_trans (Nat.le_of_eq (if_neg h)) (Nat.zero_le d)

/-! ## Reading within a window -/

/-- The schedule `s` reads `x` within every `a` steps: every stretch of `a` steps reads it. -/
def Within (s : Nat → X) (x : X) (a : Nat) : Prop :=
  ∀ T, ∃ j, j < a ∧ s (T + j) = x

/-- The schedule `s` leaves `x` unread for the `k` steps from `T`. -/
def Unread (s : Nat → X) (x : X) (T k : Nat) : Prop :=
  ∀ j, j < k → s (T + j) ≠ x

/-- Reading within a window is reading within every longer one. -/
theorem Within.mono {s : Nat → X} {x : X} {a b : Nat} (within : Within s x a) (le : a ≤ b) :
    Within s x b :=
  fun T => match within T with
    | ⟨j, lt, read⟩ => ⟨j, Nat.lt_of_lt_of_le lt le, read⟩

/-- A stretch left unread is shorter than every window the schedule reads within. -/
theorem Within.unread_lt {s : Nat → X} {x : X} {a : Nat} (within : Within s x a) {T k : Nat}
    (unread : Unread s x T k) : k < a :=
  match within T with
  | ⟨j, lt, read⟩ => match Nat.lt_or_ge j k with
    | .inl inside => absurd read (unread j inside)
    | .inr past => Nat.lt_of_le_of_lt past lt

/-- With equality decided, a stretch either reads `x` or leaves it unread. -/
theorem read_or_unread [DecidableEq X] (s : Nat → X) (x : X) (T : Nat) :
    ∀ k, (∃ j, j < k ∧ s (T + j) = x) ∨ Unread s x T k
  | 0 => .inr fun _ lt => absurd lt (Nat.not_lt_zero _)
  | k + 1 => match read_or_unread s x T k with
    | .inl ⟨j, lt, read⟩ => .inl ⟨j, Nat.lt_succ_of_lt lt, read⟩
    | .inr unread => if read : s (T + k) = x then .inl ⟨k, Nat.lt_succ_self k, read⟩ else
        .inr fun j lt => match Nat.lt_or_ge j k with
          | .inl before => unread j before
          | .inr after => fun same =>
              read ((Nat.le_antisymm (Nat.le_of_lt_succ lt) after) ▸ same)

/-- With equality decided, reading within `a` steps is leaving no stretch of `a` steps unread. -/
theorem within_iff [DecidableEq X] {s : Nat → X} {x : X} {a : Nat} :
    Within s x a ↔ ∀ T, ¬ Unread s x T a :=
  ⟨fun within _ unread => Nat.lt_irrefl a (within.unread_lt unread),
   fun never T => match read_or_unread s x T a with
     | .inl read => read
     | .inr unread => absurd unread (never T)⟩

/-! ## Totals over stretches of steps -/

/-- A quantity that is nothing before `T` and from `T + n` on, and at most `d` a step, totals at
most `n * d` over every stretch from the start. -/
theorem total_of_stretch {q : Nat → Nat} {T n d : Nat}
    (before : ∀ u, u < T → q u = 0) (after : ∀ u, T + n ≤ u → q u = 0) (le : ∀ u, q u ≤ d) :
    ∀ t, total (steps 0 t) q ≤ n * d := by
  intro t
  have head : total (steps 0 T) q = 0 :=
    (total_steps_congr (q := fun _ => 0) fun u _ lt =>
      before u (Nat.lt_of_lt_of_le lt (Nat.le_of_eq (Nat.zero_add T)))).trans
      ((total_steps_const 0 0 T).trans (Nat.mul_zero T))
  have tail : total (steps (0 + (T + n)) t) q = 0 :=
    (total_steps_congr (q := fun _ => 0) fun u ge _ =>
      after u (Nat.le_trans (Nat.le_of_eq (Nat.zero_add (T + n)).symm) ge)).trans
      ((total_steps_const 0 _ t).trans (Nat.mul_zero t))
  have middle : total (steps (0 + T) n) q ≤ n * d := total_steps_le fun u _ _ => le u
  have whole : total (steps 0 (T + n + t)) q ≤ n * d := by
    rw [total_steps_add q 0 (T + n) t, total_steps_add q 0 T n, head, tail, Nat.zero_add,
      Nat.add_zero]
    exact middle
  have first : total (steps 0 t) q ≤ total (steps 0 (T + n + t)) q := by
    rw [Nat.add_comm (T + n) t, total_steps_add q 0 t (T + n)]
    exact Nat.le_add_right _ _
  exact Nat.le_trans first whole

/-- A quantity at least `d` at each of the `n` steps from `T` totals at least `n * d` over them. -/
theorem total_steps_ge {q : Nat → Nat} {d : Nat} : ∀ {T n : Nat},
    (∀ u, T ≤ u → u < T + n → d ≤ q u) → n * d ≤ total (steps T n) q
  | _, 0, _ => Nat.le_of_eq (Nat.zero_mul d)
  | T, n + 1, ge =>
    have here := ge T (Nat.le_refl T) (Nat.lt_of_lt_of_le (Nat.lt_succ_self T)
      (Nat.succ_le_succ (Nat.le_add_right T n)))
    have rest := total_steps_ge (T := T + 1) (n := n) fun u after before =>
      ge u (Nat.le_of_succ_le after)
        (Nat.lt_of_lt_of_le before (Nat.le_of_eq (Nat.add_right_comm T 1 n)))
    Nat.le_trans (Nat.le_of_eq ((Nat.succ_mul n d).trans (Nat.add_comm (n * d) d)))
      (Nat.add_le_add here rest)

/-- A stretch inside the steps before `t` totals at most what those steps total. -/
theorem total_le_of_inside (q : Nat → Nat) {T n t : Nat} (inside : T + n ≤ t) :
    total (steps T n) q ≤ total (steps 0 t) q :=
  match le_dest inside with
  | ⟨r, same⟩ => by
    rw [same, total_steps_add q 0 (T + n) r, total_steps_add q 0 T n, Nat.zero_add]
    exact Nat.le_trans (Nat.le_add_left _ _) (Nat.le_add_right _ _)

/-- A prefix of the steps totals at most a longer prefix. -/
theorem total_prefix_le (q : Nat → Nat) {n P : Nat} (le : n ≤ P) :
    total (steps 0 n) q ≤ total (steps 0 P) q :=
  total_le_of_inside q (T := 0) (Nat.le_trans (Nat.le_of_eq (Nat.zero_add n)) le)

/-! ## What a reader can carry: counting -/

/-- A pool of readers, reading the list `r t` at step `t`, reads `x` within every `a` steps. -/
def PoolWithin (r : Nat → List X) (x : X) (a : Nat) : Prop :=
  ∀ T, ∃ j, j < a ∧ x ∈ r (T + j)

/-- One reader is a pool reading one condition a step. -/
theorem Within.pool {s : Nat → X} {x : X} {a : Nat} (within : Within s x a) :
    PoolWithin (fun t => [s t]) x a :=
  fun T => match within T with
    | ⟨j, lt, read⟩ => ⟨j, lt, read ▸ .head []⟩

/-- How many times the list `r` names `x`. -/
def times [DecidableEq X] (r : List X) (x : X) : Nat :=
  total r fun y => if y = x then 1 else 0

/-- A list naming `x` names it at least once. -/
theorem one_le_times [DecidableEq X] {r : List X} {x : X} (mem : x ∈ r) : 1 ≤ times r x :=
  Nat.le_trans (Nat.le_of_eq (if_pos rfl).symm)
    (le_total_of_mem (q := fun y => if y = x then 1 else 0) mem)

/-- Each condition is one of a list of distinct conditions at most once. -/
theorem total_is_le_one [DecidableEq X] (y : X) : ∀ {cs : List X}, Distinct cs →
    total cs (fun c => if y = c then 1 else 0) ≤ 1
  | [], _ => Nat.zero_le 1
  | c :: cs, ⟨fresh, distinct⟩ =>
    if same : y = c then
      have rest : total cs (fun c => if y = c then 1 else 0) = 0 :=
        total_eq_zero fun c' mem => if_neg fun other : y = c' =>
          fresh (Eq.subst (motive := fun z => z ∈ cs) (other.symm.trans same) mem)
      Nat.le_of_eq ((congrArg (· + _) (if_pos same)).trans (congrArg (1 + ·) rest))
    else Nat.le_trans (Nat.le_of_eq ((congrArg (· + _) (if_neg same)).trans (Nat.zero_add _)))
      (total_is_le_one y distinct)

/-- A total over a stretch with a positive term at one of its steps is at least one. -/
theorem one_le_total_steps {q : Nat → Nat} : ∀ {S a j : Nat}, j < a → 1 ≤ q (S + j) →
    1 ≤ total (steps S a) q
  | _, 0, _, lt, _ => absurd lt (Nat.not_lt_zero _)
  | _, _ + 1, 0, _, one => Nat.le_trans one (Nat.le_add_right _ _)
  | S, a + 1, j + 1, lt, one => Nat.le_trans
      (one_le_total_steps (S := S + 1) (a := a) (j := j) (Nat.lt_of_succ_lt_succ lt)
        (by rw [Nat.succ_add]; exact one))
      (Nat.le_add_left _ _)

/-- A pool reading `x` within every `a` steps names it at least `n` times over `n a` steps. -/
theorem PoolWithin.count [DecidableEq X] {r : Nat → List X} {x : X} {a : Nat}
    (within : PoolWithin r x a) (T : Nat) :
    ∀ n, n ≤ total (steps T (n * a)) (fun t => times (r t) x)
  | 0 => Nat.zero_le _
  | n + 1 => by
    rw [Nat.succ_mul, total_steps_add]
    exact Nat.add_le_add (PoolWithin.count within T n) (match within (T + n * a) with
      | ⟨j, lt, read⟩ => one_le_total_steps lt (one_le_times read))

/-- **What a pool can carry.** Readers naming at most `k` conditions a step read each of a list of
conditions `c`, distinct by their names `name c`, within its window `a c`. Then any counts `q c`
with `q c * a c ≤ P` total at most `P k`: over `P` steps the windows ask at least `⌊P / a c⌋`
readings of `c`, and the pool gives at most `P k`. In rates, the windows' reciprocals sum to at
most `k`. -/
theorem pool_density [DecidableEq X] {ι : Type} {r : Nat → List X} {k : Nat}
    (capacity : ∀ t, (r t).length ≤ k) {cs : List ι} {name : ι → X}
    (distinct : Distinct (cs.map name)) {a q : ι → Nat} {P : Nat}
    (reads : ∀ c, c ∈ cs → PoolWithin r (name c) (a c)) (fits : ∀ c, c ∈ cs → q c * a c ≤ P) :
    total cs q ≤ P * k :=
  calc total cs q
      ≤ total cs (fun c => total (steps 0 P) (fun t => times (r t) (name c))) :=
        total_le cs fun c mem => Nat.le_trans ((reads c mem).count 0 (q c))
          (total_prefix_le _ (fits c mem))
    _ = total (steps 0 P) (fun t => total cs (fun c => times (r t) (name c))) :=
        total_swap (fun c t => times (r t) (name c)) (steps 0 P) cs
    _ = total (steps 0 P)
          (fun t => total (r t) (fun y => total cs (fun c => if y = name c then 1 else 0))) :=
        total_congr (fun t => total_swap (fun c y => if y = name c then 1 else 0) (r t) cs) _
    _ ≤ total (steps 0 P) (fun t => (r t).length) :=
        total_le _ fun t _ => Nat.le_trans
          (total_le (r t) fun y _ => Nat.le_trans
            (Nat.le_of_eq (total_map name (fun z => if y = z then 1 else 0) cs).symm)
            (total_is_le_one y distinct))
          (Nat.le_of_eq (total_ones (r t)))
    _ ≤ P * k := total_steps_le fun t _ _ => capacity t

/-- **What one reader can carry.** A schedule reading each of a list of conditions `c`, distinct
by their names, within its window `a c`: counts `q c` with `q c * a c ≤ P` total at most `P`. In
rates, the windows' reciprocals sum to at most one. The case of `pool_density` for one reader. -/
theorem density [DecidableEq X] {ι : Type} {s : Nat → X} {cs : List ι} {name : ι → X}
    (distinct : Distinct (cs.map name)) {a q : ι → Nat} {P : Nat}
    (reads : ∀ c, c ∈ cs → Within s (name c) (a c)) (fits : ∀ c, c ∈ cs → q c * a c ≤ P) :
    total cs q ≤ P :=
  Nat.le_trans (pool_density (r := fun t => [s t]) (k := 1) (fun _ => Nat.le_refl 1) distinct
    (fun c mem => (reads c mem).pool) fits) (Nat.le_of_eq (Nat.mul_one P))

/-! ## Spare capacity is not enough -/

/-- **Windows 2, 3 and any `M` are never read together.** No schedule reads three distinct
conditions within every 2, 3 and `M` steps, whatever `M`: a reading of the third at a step after
the first sits between two readings of the first, and the three steps hold no reading of the
second. -/
theorem no_two_three {s : Nat → X} {x y z : X} (xy : x ≠ y) (zy : z ≠ y) (xz : x ≠ z) (M : Nat) :
    ¬ (Within s x 2 ∧ Within s y 3 ∧ Within s z M) := fun ⟨two, three, many⟩ =>
  match many 1 with
  | ⟨j, _, third⟩ =>
    have mid : s (j + 1) = z := (Nat.add_comm 1 j) ▸ third
    have before : s j = x := match two j with
      | ⟨0, _, read⟩ => read
      | ⟨1, _, read⟩ => absurd (read.symm.trans mid) xz
      | ⟨_ + 2, lt, _⟩ => absurd lt (Nat.not_lt_zero _ ∘ Nat.lt_of_succ_lt_succ ∘ Nat.lt_of_succ_lt_succ)
    have after : s (j + 2) = x := match two (j + 1) with
      | ⟨0, _, read⟩ => absurd (read.symm.trans mid) xz
      | ⟨1, _, read⟩ => read
      | ⟨_ + 2, lt, _⟩ => absurd lt (Nat.not_lt_zero _ ∘ Nat.lt_of_succ_lt_succ ∘ Nat.lt_of_succ_lt_succ)
    match three j with
    | ⟨0, _, read⟩ => xy (before.symm.trans read)
    | ⟨1, _, read⟩ => zy (mid.symm.trans read)
    | ⟨2, _, read⟩ => xy (after.symm.trans read)
    | ⟨_ + 3, lt, _⟩ => absurd lt
        (Nat.not_lt_zero _ ∘ Nat.lt_of_succ_lt_succ ∘ Nat.lt_of_succ_lt_succ ∘ Nat.lt_of_succ_lt_succ)

/-- **The counts leave room.** For `M ≥ 7`, over `6 M` steps the windows 2, 3 and `M` ask
`3 M`, `2 M` and `6` readings, `5 M + 6` in all, fewer than `6 M`: the reader would be idle at
least `M - 6` of every `6 M` steps (a share `1/6 - 1/M`), and still no schedule reads the three
(`no_two_three`). Counting is necessary (`density`) and not sufficient. -/
theorem two_three_room {M : Nat} (large : 7 ≤ M) :
    3 * M * 2 = 6 * M ∧ 2 * M * 3 = 6 * M ∧ 6 * M = 6 * M ∧ 3 * M + 2 * M + 6 < 6 * M :=
  ⟨(Naturals.mul_right_comm 3 M 2).trans rfl, (Naturals.mul_right_comm 2 M 3).trans rfl, rfl,
   Nat.lt_of_lt_of_le
     (Nat.lt_of_le_of_lt (Nat.le_of_eq (congrArg (· + 6) (add_mul_split 3 2 M).symm))
       (Nat.add_lt_add_left large (5 * M)))
     (Nat.le_of_eq (Nat.succ_mul 5 M).symm)⟩

/-! ## Two readers as one, at half speed -/

/-- Two schedules interleaved: the first at even steps, the second at odd ones. -/
def weave (s₀ s₁ : Nat → X) : Nat → X
  | 0 => s₀ 0
  | 1 => s₁ 0
  | t + 2 => weave (fun u => s₀ (u + 1)) (fun u => s₁ (u + 1)) t

theorem weave_even : ∀ (s₀ s₁ : Nat → X) (u : Nat), weave s₀ s₁ (2 * u) = s₀ u
  | _, _, 0 => rfl
  | s₀, s₁, u + 1 => weave_even (fun u => s₀ (u + 1)) (fun u => s₁ (u + 1)) u

theorem weave_odd : ∀ (s₀ s₁ : Nat → X) (u : Nat), weave s₀ s₁ (2 * u + 1) = s₁ u
  | _, _, 0 => rfl
  | s₀, s₁, u + 1 => weave_odd (fun u => s₀ (u + 1)) (fun u => s₁ (u + 1)) u

/-- Every step is even or odd. -/
theorem halves : ∀ T : Nat, ∃ v, T = 2 * v ∨ T = 2 * v + 1
  | 0 => ⟨0, .inl rfl⟩
  | T + 1 => match halves T with
    | ⟨v, .inl even⟩ => ⟨v, .inr (congrArg (· + 1) even)⟩
    | ⟨v, .inr odd⟩ => ⟨v + 1, .inl (congrArg (· + 1) odd)⟩

theorem double_lt {j a : Nat} (lt : j < a) : 2 * j + 1 < 2 * a :=
  Nat.lt_of_lt_of_le (Nat.lt_succ_self _) (Nat.mul_le_mul_left 2 lt)

theorem even_add (v j : Nat) : 2 * v + 2 * j = 2 * (v + j) := (Nat.mul_add 2 v j).symm

theorem odd_add (v j : Nat) : 2 * v + 1 + 2 * j = 2 * (v + j) + 1 :=
  (Nat.add_right_comm (2 * v) 1 (2 * j)).trans (congrArg (· + 1) (even_add v j))

theorem odd_add_odd (v j : Nat) : 2 * v + 1 + (2 * j + 1) = 2 * (v + 1 + j) :=
  (congrArg (· + 1) (odd_add v j)).trans (congrArg (2 * ·) (Nat.add_right_comm v j 1))

/-- **Interleaving halves the speed.** What the first schedule reads within `a` steps, the
interleaving reads within `2 a`. -/
theorem weave_left {s₀ s₁ : Nat → X} {x : X} {a : Nat} (within : Within s₀ x a) :
    Within (weave s₀ s₁) x (2 * a) := fun T => match halves T with
  | ⟨v, .inl even⟩ => match within v with
    | ⟨j, lt, read⟩ => ⟨2 * j, Nat.lt_of_le_of_lt (Nat.le_succ _) (double_lt lt), by
        rw [even, even_add, weave_even]; exact read⟩
  | ⟨v, .inr odd⟩ => match within (v + 1) with
    | ⟨j, lt, read⟩ => ⟨2 * j + 1, double_lt lt, by
        rw [odd, odd_add_odd, weave_even]; exact read⟩

/-- What the second schedule reads within `a` steps, the interleaving reads within `2 a`. -/
theorem weave_right {s₀ s₁ : Nat → X} {x : X} {a : Nat} (within : Within s₁ x a) :
    Within (weave s₀ s₁) x (2 * a) := fun T => match halves T with
  | ⟨v, .inl even⟩ => match within v with
    | ⟨j, lt, read⟩ => ⟨2 * j + 1, double_lt lt, by
        rw [even, ← Nat.add_assoc, even_add, weave_odd]; exact read⟩
  | ⟨v, .inr odd⟩ => match within v with
    | ⟨j, lt, read⟩ => ⟨2 * j, Nat.lt_of_le_of_lt (Nat.le_succ _) (double_lt lt), by
        rw [odd, odd_add, weave_odd]; exact read⟩

/-! ## Dyadic codes -/

/-- A binary code of conditions: a reading tree. A leaf reads its condition at every step it is
given, a node gives its two branches alternate steps, and an idle branch reads nothing. -/
inductive Code (X : Type) : Type where
  | idle : Code X
  | leaf : X → Code X
  | node : Code X → Code X → Code X

namespace Code

/-- What a code reads at each step. -/
def reader : Code X → Nat → Option X
  | idle => fun _ => none
  | leaf x => fun _ => some x
  | node l r => weave l.reader r.reader

/-- The code holds `x` at depth `k`. -/
inductive At : Code X → X → Nat → Prop
  | here (x : X) : At (leaf x) x 0
  | left {l : Code X} (r : Code X) {x : X} {k : Nat} : At l x k → At (node l r) x (k + 1)
  | right (l : Code X) {r : Code X} {x : X} {k : Nat} : At r x k → At (node l r) x (k + 1)

/-- **A condition at depth `k` is read within every `2 ^ k` steps.** -/
theorem At.reads {K : Code X} {x : X} {k : Nat} (held : K.At x k) :
    Within K.reader (some x) (2 ^ k) := by
  induction held with
  | here x => exact fun _ => ⟨0, Nat.zero_lt_one, rfl⟩
  | left r _ ih => exact Within.mono (weave_left ih) (Nat.le_of_eq (Nat.mul_comm 2 _))
  | right l _ ih => exact Within.mono (weave_right ih) (Nat.le_of_eq (Nat.mul_comm 2 _))

end Code

open Code

/-- Codes paired as branches of one node each, the last with an idle branch where the count is
odd. -/
def pair : List (Code X) → List (Code X)
  | [] => []
  | [t] => [node t idle]
  | t :: u :: rest => node t u :: pair rest

/-- Each paired code lies one level down in a code of the pairing. -/
theorem pair_lift : ∀ {L : List (Code X)} {t : Code X}, t ∈ L →
    ∃ u, u ∈ pair L ∧ ∀ x k, t.At x k → u.At x (k + 1)
  | [], _, mem => nomatch mem
  | [t], _, .head _ => ⟨node t idle, .head _, fun _ _ held => .left idle held⟩
  | [_], _, .tail _ mem => nomatch mem
  | _ :: u :: _, _, .head _ => ⟨_, .head _, fun _ _ held => .left u held⟩
  | t :: _ :: _, _, .tail _ (.head _) => ⟨_, .head _, fun _ _ held => .right t held⟩
  | _ :: _ :: _, _, .tail _ (.tail _ mem) => match pair_lift mem with
    | ⟨w, inside, lift⟩ => ⟨w, .tail _ inside, lift⟩

/-- Pairing halves a count, rounding up. -/
theorem pair_length : ∀ L : List (Code X), 2 * (pair L).length ≤ L.length + 1
  | [] => Nat.zero_le 1
  | [_] => Nat.le_refl 2
  | _ :: _ :: rest => Nat.add_le_add_right (pair_length rest) 2

/-- The items of depth zero, as leaves. -/
def leaves : List (X × Nat) → List (Code X)
  | [] => []
  | (x, 0) :: rest => leaf x :: leaves rest
  | (_, _ + 1) :: rest => leaves rest

/-- The items of positive depth, one level up. -/
def deeper : List (X × Nat) → List (X × Nat)
  | [] => []
  | (_, 0) :: rest => deeper rest
  | (x, k + 1) :: rest => (x, k) :: deeper rest

/-- Codes for items, built from the deepest level up: the leaves of depth zero, and the codes
for the deeper items paired one level down. -/
def build : List (X × Nat) → Nat → List (Code X)
  | items, 0 => leaves items
  | items, D + 1 => leaves items ++ pair (build (deeper items) D)

theorem leaves_mem {x : X} : ∀ {items : List (X × Nat)}, (x, 0) ∈ items → leaf x ∈ leaves items
  | _ :: _, .head _ => .head _
  | (_, 0) :: _, .tail _ mem => .tail _ (leaves_mem mem)
  | (_, _ + 1) :: _, .tail _ mem => have held := leaves_mem mem; held

theorem deeper_mem {x : X} {k : Nat} : ∀ {items : List (X × Nat)}, (x, k + 1) ∈ items →
    (x, k) ∈ deeper items
  | _ :: _, .head _ => .head _
  | (_, 0) :: _, .tail _ mem => have held := deeper_mem mem; held
  | (_, _ + 1) :: _, .tail _ mem => .tail _ (deeper_mem mem)

theorem leaves_length : ∀ items : List (X × Nat), (leaves items).length ≤ items.length
  | [] => Nat.le_refl 0
  | (_, 0) :: rest => Nat.succ_le_succ (leaves_length rest)
  | (_, _ + 1) :: rest => Nat.le_succ_of_le (leaves_length rest)

/-- The weight of items at depth budget `D + 1` is that of the leaves and of the deeper items at
budget `D`. -/
theorem weight_split (D : Nat) : ∀ items : List (X × Nat),
    total items (fun i => 2 ^ (D + 1 - i.2)) =
      (leaves items).length * 2 ^ (D + 1) + total (deeper items) (fun i => 2 ^ (D - i.2))
  | [] => (Nat.zero_mul _).symm
  | (_, 0) :: rest => by
    show 2 ^ (D + 1) + total rest _ = ((leaves rest).length + 1) * 2 ^ (D + 1) + _
    rw [weight_split D rest, Nat.succ_mul, Nat.add_right_comm _ (2 ^ (D + 1)), Nat.add_comm]; rfl
  | (_, k + 1) :: rest => by
    show 2 ^ (D + 1 - (k + 1)) + total rest _ = (leaves rest).length * 2 ^ (D + 1) +
      (2 ^ (D - k) + total (deeper rest) _)
    rw [weight_split D rest, Naturals.succ_sub_succ, Nat.add_left_comm]

/-- At depth budget zero every item weighs one. -/
theorem weight_zero : ∀ items : List (X × Nat), total items (fun i => 2 ^ (0 - i.2)) = items.length
  | [] => rfl
  | (_, k) :: rest => by
    show 2 ^ (0 - k) + total rest _ = rest.length + 1
    rw [Nat.zero_sub, weight_zero rest, Nat.add_comm]

theorem two_pow_pos : ∀ n : Nat, 0 < 2 ^ n
  | 0 => Nat.zero_lt_one
  | n + 1 => Nat.lt_of_lt_of_le (two_pow_pos n) (Nat.le_trans (Nat.le_of_eq (Nat.mul_one _).symm)
      (Nat.mul_le_mul_left _ (Nat.le_succ 1)))

theorem two_pow_le {k' k : Nat} (le : k' ≤ k) : 2 ^ k' ≤ 2 ^ k := by
  induction le with
  | refl => exact Nat.le_refl _
  | step _ ih => exact Nat.le_trans ih (Nat.le_trans (Nat.le_of_eq (Nat.mul_one _).symm)
      (Nat.mul_le_mul_left _ (Nat.le_succ 1)))

/-- **The built codes fit the weight.** Their count, times `2 ^ D`, falls short of the items'
weight at budget `D` by less than `2 ^ D`. -/
theorem build_length : ∀ (D : Nat) (items : List (X × Nat)),
    (build items D).length * 2 ^ D < total items (fun i => 2 ^ (D - i.2)) + 2 ^ D
  | 0, items => by
    show (leaves items).length * 1 < total items (fun i => 2 ^ (0 - i.2)) + 1
    rw [weight_zero, Nat.mul_one]
    exact Nat.lt_succ_of_le (leaves_length items)
  | D + 1, items =>
    have inner := build_length D (deeper items)
    have halved : (pair (build (deeper items) D)).length * 2 ^ (D + 1) <
        total (deeper items) (fun i => 2 ^ (D - i.2)) + 2 ^ (D + 1) :=
      calc (pair (build (deeper items) D)).length * 2 ^ (D + 1)
          = 2 * (pair (build (deeper items) D)).length * 2 ^ D := by
            exact (congrArg (_ * ·) (Nat.mul_comm (2 ^ D) 2)).trans
              ((mul_assoc_nat _ 2 _).symm.trans (congrArg (· * 2 ^ D) (Nat.mul_comm _ 2)))
        _ ≤ ((build (deeper items) D).length + 1) * 2 ^ D :=
            Nat.mul_le_mul_right _ (pair_length _)
        _ = (build (deeper items) D).length * 2 ^ D + 2 ^ D := Nat.succ_mul _ _
        _ < total (deeper items) (fun i => 2 ^ (D - i.2)) + 2 ^ D + 2 ^ D :=
            Nat.add_lt_add_right inner _
        _ = total (deeper items) (fun i => 2 ^ (D - i.2)) + 2 ^ (D + 1) := by
            rw [Nat.add_assoc, ← Nat.mul_two, Nat.pow_succ]
    by
      show (leaves items ++ pair (build (deeper items) D)).length * 2 ^ (D + 1) <
        total items (fun i => 2 ^ (D + 1 - i.2)) + 2 ^ (D + 1)
      rw [ListTests.length_append, add_mul_split, weight_split, Nat.add_assoc]
      exact Nat.add_lt_add_left halved _

/-- **Every item lies in a built code, no deeper than its depth.** -/
theorem build_holds : ∀ (D : Nat) {items : List (X × Nat)} {x : X} {k : Nat}, (x, k) ∈ items →
    k ≤ D → ∃ t, t ∈ build items D ∧ ∃ k', k' ≤ k ∧ t.At x k'
  | 0, _, _, 0, mem, _ => ⟨_, leaves_mem mem, 0, Nat.le_refl 0, .here _⟩
  | 0, _, _, _ + 1, _, le => absurd le (Nat.not_succ_le_zero _)
  | _ + 1, _, _, 0, mem, _ =>
    ⟨_, mem_append_of_left _ (leaves_mem mem), 0, Nat.le_refl 0, .here _⟩
  | D + 1, _, x, _ + 1, mem, le =>
    match build_holds D (deeper_mem mem) (Nat.le_of_succ_le_succ le) with
    | ⟨_, inside, k', below, held⟩ => match pair_lift inside with
      | ⟨u, paired, lift⟩ => ⟨u, mem_append_of_right _ paired, k' + 1, Nat.succ_le_succ below,
          lift x k' held⟩

/-- The first of a list of codes, or an idle code. -/
def first : List (Code X) → Code X
  | [] => idle
  | t :: _ => t

theorem first_of_short : ∀ {L : List (Code X)}, L.length < 2 → ∀ {t : Code X}, t ∈ L → first L = t
  | [_], _, _, .head _ => rfl
  | [_], _, _, .tail _ mem => nomatch mem
  | _ :: _ :: _, short, _, _ => absurd short
      (Nat.not_lt_of_le (Nat.succ_le_succ (Nat.succ_le_succ (Nat.zero_le _))))

/-- The code for items at depth budget `D`. -/
def ofItems (items : List (X × Nat)) (D : Nat) : Code X := first (build items D)

/-- As `Nat.lt_of_mul_lt_mul_right`, with an empty axiom report. -/
theorem lt_of_mul_lt_mul {a b c : Nat} (lt : a * c < b * c) : a < b :=
  match Nat.lt_or_ge a b with
  | .inl less => less
  | .inr ge => absurd (Nat.lt_of_lt_of_le lt (Nat.mul_le_mul_right c ge)) (Nat.lt_irrefl _)

/-- **Kraft's inequality as a reading schedule.** For items of depth at most `D` whose weights
`2 ^ (D - k)` total at most `2 ^ D` (in rates, `∑ 2 ^ (-k) ≤ 1`), one code reads each item's
condition within every `2 ^ k` steps, its depth's window. -/
theorem kraft_reads {items : List (X × Nat)} {D : Nat} (deep : ∀ i, i ∈ items → i.2 ≤ D)
    (kraft : total items (fun i => 2 ^ (D - i.2)) ≤ 2 ^ D) :
    ∀ x k, (x, k) ∈ items → Within (ofItems items D).reader (some x) (2 ^ k) := fun _ _ mem =>
  have short : (build items D).length < 2 := lt_of_mul_lt_mul (c := 2 ^ D)
    (Nat.lt_of_lt_of_le (build_length D items)
      (Nat.le_trans (Nat.add_le_add_right kraft _) (Nat.le_of_eq (Nat.two_mul _).symm)))
  match build_holds D mem (deep _ mem) with
  | ⟨_, inside, _, below, held⟩ =>
    ((first_of_short short inside).symm ▸ held).reads.mono (two_pow_le below)

/-! ## Half a reader suffices -/

/-- Climbing from `k`, at most `f` times, while the next power of two stays within `a`. -/
def climb (a : Nat) : Nat → Nat → Nat
  | 0, k => k
  | f + 1, k => if 2 ^ (k + 1) ≤ a then climb a f (k + 1) else k

/-- The largest `k` with `2 ^ k ≤ a`, for positive `a`. -/
def lg (a : Nat) : Nat := climb a a 0

theorem climb_spec (a : Nat) : ∀ f k, 2 ^ k ≤ a → a < 2 ^ (k + f + 1) →
    2 ^ climb a f k ≤ a ∧ a < 2 ^ (climb a f k + 1)
  | 0, _, low, high => ⟨low, high⟩
  | f + 1, k, low, high => by
    show 2 ^ (if 2 ^ (k + 1) ≤ a then climb a f (k + 1) else k) ≤ a ∧
      a < 2 ^ ((if 2 ^ (k + 1) ≤ a then climb a f (k + 1) else k) + 1)
    by_cases up : 2 ^ (k + 1) ≤ a
    · rw [if_pos up]
      exact climb_spec a f (k + 1) up (by rw [Nat.add_right_comm k 1 f]; exact high)
    · rw [if_neg up]
      exact ⟨low, Nat.lt_of_not_le up⟩

theorem lt_two_pow : ∀ n : Nat, n < 2 ^ n
  | 0 => Nat.zero_lt_one
  | n + 1 => Nat.lt_of_lt_of_le (Nat.add_lt_add_of_lt_of_le (lt_two_pow n) (two_pow_pos n))
      (Nat.le_of_eq (Nat.mul_two _).symm)

theorem lg_spec {a : Nat} (pos : 0 < a) : 2 ^ lg a ≤ a ∧ a < 2 ^ (lg a + 1) :=
  climb_spec a a 0 pos (by
    rw [Nat.zero_add]
    exact Nat.lt_trans (lt_two_pow a) (Nat.lt_of_lt_of_le
      (Nat.lt_add_of_pos_right (two_pow_pos a)) (Nat.le_of_eq (Nat.mul_two _).symm)))

/-- `L`, kept at most `D`. -/
def cap (D L : Nat) : Nat := if L ≤ D then L else D

theorem cap_le (D L : Nat) : cap D L ≤ D ∧ cap D L ≤ L := by
  by_cases h : L ≤ D
  · rw [cap, if_pos h]; exact ⟨h, Nat.le_refl L⟩
  · rw [cap, if_neg h]; exact ⟨Nat.le_refl D, Nat.le_of_lt (Nat.lt_of_not_le h)⟩

theorem mul_lt_mul_left' {m n : Nat} (lt : m < n) : ∀ {k : Nat}, 0 < k → k * m < k * n
  | 0, pos => absurd pos (Nat.lt_irrefl 0)
  | k + 1, _ => by
    rw [Nat.succ_mul, Nat.succ_mul]
    exact Nat.add_lt_add_of_le_of_lt (Nat.mul_le_mul_left k (Nat.le_of_lt lt)) lt

/-- A weight at least `2 N / a` covers the dyadic weight of the window `a` at budget `D`. -/
theorem weight_le {a q D : Nat} (pos : 0 < a) (weight : 2 ^ (D + 1) ≤ q * a) :
    2 ^ (D - cap D (lg a)) ≤ q := by
  by_cases h : lg a ≤ D
  · rw [cap, if_pos h]
    apply Nat.le_of_lt
    apply lt_of_mul_lt_mul (c := a)
    refine Nat.lt_of_lt_of_le ?_ weight
    refine Nat.lt_of_lt_of_le (mul_lt_mul_left' (lg_spec pos).2 (two_pow_pos _)) (Nat.le_of_eq ?_)
    rw [← Naturals.pow_add, ← Nat.add_assoc, Naturals.sub_add_cancel h]
  · rw [cap, if_neg h, Nat.sub_self]
    match q, weight with
    | 0, w => exact absurd (Nat.lt_of_lt_of_le (two_pow_pos _) (Nat.le_trans w
        (Nat.le_of_eq (Nat.zero_mul a)))) (Nat.lt_irrefl 0)
    | _ + 1, _ => exact Nat.succ_le_succ (Nat.zero_le _)

/-- **Half a reader suffices.** Let weights `q c` with `2 N ≤ q c * a c`, for `N = 2 ^ D`, total
at most `N`: in rates, `∑ 1 / a c ≤ 1/2`. Then one schedule reads every condition `c` within its
window `a c`. Each window is rounded down to a power of two (at most doubling its rate) and the
dyadic code of `kraft_reads` reads the rounded windows. -/
theorem half_suffices {cs : List X} {a q : X → Nat} {D : Nat}
    (positive : ∀ c, c ∈ cs → 0 < a c)
    (weights : ∀ c, c ∈ cs → 2 ^ (D + 1) ≤ q c * a c) (half : total cs q ≤ 2 ^ D) :
    ∃ s : Nat → Option X, ∀ c, c ∈ cs → Within s (some c) (a c) :=
  ⟨(ofItems (cs.map fun c => (c, cap D (lg (a c)))) D).reader, fun c mem =>
    have deep : ∀ i, i ∈ cs.map (fun c => (c, cap D (lg (a c)))) → i.2 ≤ D := fun _ listed =>
      match preimage_of_mem_map listed with
      | ⟨c', _, same⟩ => same ▸ (cap_le D (lg (a c'))).1
    have kraft : total (cs.map fun c => (c, cap D (lg (a c)))) (fun i => 2 ^ (D - i.2)) ≤ 2 ^ D :=
      Nat.le_trans (Nat.le_of_eq (total_map _ _ cs))
        (Nat.le_trans (total_le cs fun c listed =>
          weight_le (positive c listed) (weights c listed)) half)
    (kraft_reads deep kraft c _ (ListTests.mem_map_of mem)).mono
      (Nat.le_trans (two_pow_le (cap_le D (lg (a c))).2) (lg_spec (positive c mem)).1)⟩

end ReadingSchedule

/-! ## The reader and the margin law -/

namespace Flow

open ReadingSchedule Regulation

variable {X F C Pos : Type} {L : Flow F C} {part : F → Bool} {W : Web F C}

/-- What a part withdrawn after a reading takes in all: drawing at most `d` from `c` a step,
nothing before `T`, and nothing more than `ℓ` steps after a step at or after `T` at which the
schedule reads `c`'s name, the part takes at most `(a + ℓ) d` from `c` up to any step, where the
schedule reads it within every `a` steps. -/
theorem taken_of_read {s : Nat → X} {name : C → X} {c : C} {a d T ℓ : Nat}
    (within : Within s (name c) a) (draw : ∀ u, L.partTaken part u c ≤ d)
    (start : ∀ u, u < T → L.partTaken part u c = 0)
    (withdrawn : ∀ u R, T ≤ R → s R = name c → R + ℓ < u → L.partTaken part u c = 0) (t : Nat) :
    total (steps 0 t) (fun u => L.partTaken part u c) ≤ (a + ℓ) * d :=
  match within T with
  | ⟨j, lt, read⟩ => Nat.le_trans
      (total_of_stretch (T := T) (n := j + 1 + ℓ) start
        (fun u after => withdrawn u (T + j) (Nat.le_add_right _ _) read (shift_lt after)) draw t)
      (Nat.mul_le_mul_right _ (Nat.add_le_add_right lt ℓ))

/-- **One reader keeps what the levels without the drawer admit.** In a balanced flow, let a
schedule `s` read the name of each condition the part draws on (`0 < d c`) within every `a c`
steps. The part takes at most `d c` from `c` a step, nothing before its start `T c`, and nothing
more than `ℓ` steps after a step at or after `T c` at which `c`'s name is read. Where the levels
without the part exceed each need by `(a c + ℓ) d c` at every condition the formations admitted
without it require, the levels with the part retain what has significance without it. -/
theorem Balances.retains_of_read (balances : L.Balances W) {l : Nat → C → Nat}
    (without : L.WithheldLevels part W l) {sig : Pos → Nat → F → Prop} {p : Pos}
    {s : Nat → X} {name : C → X} {a d T : C → Nat} {ℓ : Nat}
    (reads : ∀ c, 0 < d c → Within s (name c) (a c))
    (draw : ∀ u c, L.partTaken part u c ≤ d c)
    (start : ∀ u c, u < T c → L.partTaken part u c = 0)
    (withdrawn : ∀ u c R, T c ≤ R → s R = name c → R + ℓ < u → L.partTaken part u c = 0)
    (margin : ∀ t f, sig p t f → W.Admits (l t) t f → ∀ c, W.requires t f c →
      W.need t f c + (a c + ℓ) * d c ≤ l t c) :
    W.Retains sig p W.level l :=
  (balances.retains_iff_within_margin without).mpr fun t f significant admits c requires =>
    have taken : total (steps 0 t) (fun u => L.partTaken part u c) ≤ (a c + ℓ) * d c :=
      match h : d c with
      | 0 => Nat.le_trans
          (total_steps_le (k := 0) fun u _ _ => Nat.le_trans (draw u c) (Nat.le_of_eq h))
          (Nat.le_of_eq ((Nat.mul_zero t).trans (Nat.mul_zero _).symm))
      | e + 1 => taken_of_read (reads c (h ▸ Nat.succ_pos e))
          (fun u => Nat.le_trans (draw u c) (Nat.le_of_eq h)) (fun u => start u c)
          (fun u R => withdrawn u c R) t
    Nat.le_trans (Nat.add_le_add_left taken _)
      (Nat.le_trans (margin t f significant admits c requires) (Nat.le_add_right _ _))

/-- **A stretch left unread loses what lies beyond the margin.** In a balanced flow, let the part
give nothing to `c` and take at least `d` from it at each step from `T` until `ℓ` steps after
the first step at or after `T` at which `c`'s name is read. Where the schedule leaves it unread
for the `k` steps from `T`, the part draws `(k + 1 + ℓ) d` from `c`, and a formation with
significance admitted without the part at a later step `t`, requiring `c` with the level without
it short of its need with that draw, is lost: the levels without the part add it. -/
theorem Balances.loses_of_unread (balances : L.Balances W) {l : Nat → C → Nat}
    (without : L.WithheldLevels part W l) {sig : Pos → Nat → F → Prop} {p : Pos}
    {s : Nat → X} {name : C → X} {c : C} {T k ℓ d t : Nat} {f : F}
    (unread : Unread s (name c) T k)
    (drawing : ∀ u, T ≤ u → (∀ R, T ≤ R → s R = name c → u ≤ R + ℓ) →
      d ≤ L.partTaken part u c)
    (gives : ∀ u, L.partGiven part u c = 0)
    (late : T + (k + 1 + ℓ) ≤ t)
    (significant : sig p t f) (admitted : W.Admits (l t) t f) (requires : W.requires t f c)
    (beyond : l t c < W.need t f c + (k + 1 + ℓ) * d) :
    W.Adds sig p l W.level :=
  (balances.loses_iff_beyond_margin without).mpr ⟨t, f, significant, admitted, fun within =>
    have drawn : (k + 1 + ℓ) * d ≤ total (steps 0 t) (fun u => L.partTaken part u c) :=
      Nat.le_trans
        (total_steps_ge fun u after before => drawing u after fun R later read =>
          match le_dest later with
          | ⟨j, same⟩ => match Nat.lt_or_ge j k with
            | .inl inside => absurd (same ▸ read) (unread j inside)
            | .inr past => Nat.le_trans
                (Nat.le_of_lt_succ (Nat.lt_of_lt_of_le before (Nat.le_of_eq (by
                  rw [Nat.add_assoc T k ℓ, Nat.add_right_comm k 1 ℓ]; rfl))))
                (same ▸ Nat.add_le_add_right (Nat.add_le_add_left past T) ℓ))
        (total_le_of_inside _ late)
    have given : total (steps 0 t) (fun u => L.partGiven part u c) = 0 :=
      (total_steps_congr (q := fun _ => 0) fun u _ _ => gives u).trans
        ((total_steps_const 0 0 t).trans (Nat.mul_zero t))
    Nat.lt_irrefl _ (Nat.lt_of_lt_of_le beyond (Nat.le_trans (Nat.add_le_add_left drawn _)
      (Nat.le_trans (within c requires) (Nat.le_of_eq (by rw [given, Nat.add_zero])))))⟩

end Flow

namespace ReadingSchedule

open Regulation

variable {X C : Type}

/-- **A schedule keeps a condition.** The schedule `s`, reading conditions by their names, keeps
`c` within the margin `m` against draws of at most `d` a step withdrawn `ℓ` steps after a reading:
in every balanced flow, a part drawing on `c` alone, at most `d` a step, from a start `T` until
`ℓ` steps after a step at or after `T` at which `c`'s name is read, retains whatever has
significance without it wherever the levels without it exceed the need on `c` by `m`. -/
def Keeps (s : Nat → X) (name : C → X) (c : C) (ℓ d m : Nat) : Prop :=
  ∀ {F Pos : Type} (L : Flow F C) (W : Web F C) (part : F → Bool) (l : Nat → C → Nat) (T : Nat)
    (sig : Pos → Nat → F → Prop) (p : Pos),
    L.Balances W → L.WithheldLevels part W l →
    (∀ u c', c' ≠ c → L.partTaken part u c' = 0) →
    (∀ u, L.partTaken part u c ≤ d) →
    (∀ u, u < T → L.partTaken part u c = 0) →
    (∀ u R, T ≤ R → s R = name c → R + ℓ < u → L.partTaken part u c = 0) →
    (∀ t f, sig p t f → W.Admits (l t) t f → W.requires t f c → W.need t f c + m ≤ l t c) →
    W.Retains sig p W.level l

/-- A schedule reading `c` within every `a` steps keeps it within a margin of `(a + ℓ) d`. -/
theorem keeps_of_within [DecidableEq C] {s : Nat → X} {name : C → X} {c : C} {a ℓ d m : Nat}
    (within : Within s (name c) a) (fits : (a + ℓ) * d ≤ m) : Keeps s name c ℓ d m := by
  intro F Pos L W part l T sig p balances without only draw start withdrawn margin
  refine balances.retains_of_read without (s := s) (name := name) (a := fun _ => a)
    (d := fun c' => if c' = c then d else 0) (T := fun _ => T) (ℓ := ℓ) ?_ ?_ ?_ ?_ ?_
  · intro c' pos
    dsimp only at pos
    by_cases h : c' = c
    · subst h; exact within
    · rw [if_neg h] at pos; exact absurd pos (Nat.lt_irrefl 0)
  · intro u c'
    dsimp only
    by_cases h : c' = c
    · subst h; rw [if_pos rfl]; exact draw u
    · rw [only u c' h]; exact Nat.zero_le _
  · intro u c' before
    by_cases h : c' = c
    · subst h; exact start u before
    · exact only u c' h
  · intro u c' R after read late
    by_cases h : c' = c
    · subst h; exact withdrawn u R after read late
    · exact only u c' h
  · intro t f significant admits c' requires
    dsimp only
    by_cases h : c' = c
    · subst h
      rw [if_pos rfl]
      exact Nat.le_trans (Nat.add_le_add_left fits _) (margin t f significant admits requires)
    · rw [if_neg h, Nat.mul_zero, Nat.add_zero]
      exact admits c' requires

/-! ### The witness of a stretch left unread -/

namespace Drawer

variable [DecidableEq C]

/-- One formation, `true`, takes `d` from `c` at each of the `n` steps from `T`, and gives
nothing. -/
def flow (c : C) (T n d : Nat) : Flow Bool C :=
  ⟨fun _ => [true], fun u f c' => if f = true ∧ c' = c ∧ T ≤ u ∧ u < T + n then d else 0,
   fun _ _ _ => 0⟩

/-- Every condition starts at `n d + m` and falls by what the drawer takes from it; the formation
`false` requires `c` at need `n d`. -/
def web (c : C) (T n d m : Nat) : Web Bool C :=
  ⟨fun t c' => n * d + m - total (steps 0 t) (fun u => (flow c T n d).take u true c'),
   fun _ _ => True, fun _ f c' => f = false ∧ c' = c, fun _ _ _ => n * d, fun _ _ _ => False⟩

theorem partTaken_eq (c : C) (T n d u : Nat) (c' : C) :
    (flow c T n d).partTaken (fun f => f) u c' = (flow c T n d).take u true c' :=
  Nat.add_zero _

theorem take_le (c : C) (T n d u : Nat) (c' : C) : (flow c T n d).take u true c' ≤ d :=
  ite_le _ d

theorem take_total (c : C) (T n d : Nat) (c' : C) (t : Nat) :
    total (steps 0 t) (fun u => (flow c T n d).take u true c') ≤ n * d :=
  total_of_stretch (T := T) (n := n)
    (fun _ before => if_neg fun h => Nat.lt_irrefl _ (Nat.lt_of_lt_of_le before h.2.2.1))
    (fun _ after => if_neg fun h => Nat.lt_irrefl _ (Nat.lt_of_lt_of_le h.2.2.2 after))
    (fun u => take_le c T n d u c') t

theorem take_total_end (c : C) (T n d : Nat) :
    total (steps 0 (T + n)) (fun u => (flow c T n d).take u true c) = n * d := by
  rw [total_steps_add _ 0 T n, Nat.zero_add]
  have head : total (steps 0 T) (fun u => (flow c T n d).take u true c) = 0 :=
    (total_steps_congr (q := fun _ => 0) fun u _ lt =>
      if_neg fun h => Nat.lt_irrefl _ (Nat.lt_of_lt_of_le
        (Nat.lt_of_lt_of_le lt (Nat.le_of_eq (Nat.zero_add T))) h.2.2.1)).trans
      ((total_steps_const 0 0 T).trans (Nat.mul_zero T))
  have body : total (steps T n) (fun u => (flow c T n d).take u true c) = n * d :=
    (total_steps_congr (q := fun _ => d) fun _ after before => if_pos ⟨rfl, rfl, after, before⟩).trans
      (total_steps_const d T n)
  rw [head, body, Nat.zero_add]

theorem sub_add_of_le {B y x : Nat} (le : y + x ≤ B) : B - (y + x) + x = B - y :=
  match le_dest le with
  | ⟨r, same⟩ => by
    rw [same, Naturals.add_sub_cancel_left, Nat.add_assoc, Naturals.add_sub_cancel_left,
      Nat.add_comm]

theorem balances (c : C) (T n d m : Nat) : (flow c T n d).Balances (web c T n d m) := fun t c' =>
  have le : total (steps 0 t) (fun u => (flow c T n d).take u true c') +
      (flow c T n d).take t true c' ≤ n * d + m :=
    Nat.le_trans (Nat.le_of_eq (by rw [total_steps_add _ 0 t 1, Nat.zero_add]; rfl))
      (Nat.le_trans (take_total c T n d c' (t + 1)) (Nat.le_add_right _ _))
  show n * d + m - total (steps 0 (t + 1)) (fun u => (flow c T n d).take u true c') +
      ((flow c T n d).take t true c' + 0) =
    n * d + m - total (steps 0 t) (fun u => (flow c T n d).take u true c') + (0 + 0) by
  rw [total_steps_add _ 0 t 1, Nat.zero_add, Nat.add_zero]
  exact sub_add_of_le le

theorem withheld (c : C) (T n d m : Nat) :
    (flow c T n d).WithheldLevels (fun f => f) (web c T n d m) (fun _ _ => n * d + m) :=
  ⟨fun _ _ => rfl, fun _ => rfl⟩

end Drawer

/-- **A schedule keeping `c` reads it within its window.** Where `m < (a + 1 + ℓ) d`, a schedule
keeping `c` within the margin `m` reads it within every `a` steps: a stretch of `a` steps left
unread lets the witness drawer (`Drawer.flow`) take `(a + 1 + ℓ) d`, beyond the margin, and lose
the formation needing `c`. -/
theorem within_of_keeps [DecidableEq X] [DecidableEq C] {s : Nat → X} {name : C → X} {c : C}
    {a ℓ d m : Nat} (keeps : Keeps s name c ℓ d m) (exceeds : m < (a + 1 + ℓ) * d) :
    Within s (name c) a :=
  within_iff.mpr fun T unread =>
    have retains := keeps (Pos := Unit) (Drawer.flow c T (a + 1 + ℓ) d)
      (Drawer.web c T (a + 1 + ℓ) d m) (fun f => f) (fun _ _ => (a + 1 + ℓ) * d + m) T
      (fun _ _ _ => True) () (Drawer.balances c T _ d m) (Drawer.withheld c T _ d m)
      (fun u c' other => (Drawer.partTaken_eq c T _ d u c').trans (if_neg fun h => other h.2.1))
      (fun u => Nat.le_trans (Nat.le_of_eq (Drawer.partTaken_eq c T _ d u c))
        (Drawer.take_le c T _ d u c))
      (fun u before => (Drawer.partTaken_eq c T _ d u c).trans
        (if_neg fun h => Nat.lt_irrefl _ (Nat.lt_of_lt_of_le before h.2.2.1)))
      (fun u R after read late => (Drawer.partTaken_eq c T _ d u c).trans
        (if_neg fun h => match le_dest after with
          | ⟨j, same⟩ => match Nat.lt_or_ge j a with
            | .inl inside => unread j inside (same ▸ read)
            | .inr past => Nat.lt_irrefl _ (Nat.lt_of_lt_of_le h.2.2.2
                (shift_le (Nat.lt_of_le_of_lt
                  (same ▸ Nat.add_le_add_right (Nat.add_le_add_left past T) ℓ) late)))))
      (fun _ _ _ _ _ => Nat.le_refl _)
    have admitted := retains (T + (a + 1 + ℓ)) false trivial
      (fun c' requires => Nat.le_add_right _ _) c ⟨rfl, rfl⟩
    have level : (Drawer.web c T (a + 1 + ℓ) d m).level (T + (a + 1 + ℓ)) c = m := by
      show (a + 1 + ℓ) * d + m - total (steps 0 (T + (a + 1 + ℓ))) _ = m
      rw [Drawer.take_total_end, Naturals.add_sub_cancel_left]
    Nat.lt_irrefl m (Nat.lt_of_lt_of_le exceeds (Nat.le_trans admitted (Nat.le_of_eq level)))

/-- **One reader keeps a condition exactly where it reads it within its window.** With
`(a + ℓ) d ≤ m < (a + 1 + ℓ) d`, a schedule keeps `c` within the margin `m`, against every
balanced flow's draws of at most `d` a step withdrawn `ℓ` steps after a reading, exactly where
it reads `c` within every `a` steps. -/
theorem keeps_iff_within [DecidableEq X] [DecidableEq C] {s : Nat → X} {name : C → X} {c : C}
    {a ℓ d m : Nat} (fits : (a + ℓ) * d ≤ m) (exceeds : m < (a + 1 + ℓ) * d) :
    Keeps s name c ℓ d m ↔ Within s (name c) a :=
  ⟨fun keeps => within_of_keeps keeps exceeds, fun within => keeps_of_within within fits⟩

/-- **What one reader can keep, counted.** A schedule keeping each of a list of conditions,
distinct by their names, within margins `m c` with `m c < (a c + 1 + ℓ) d c`: counts `q c` with
`q c * a c ≤ P` total at most `P`. In rates, `∑ 1 / a c ≤ 1`. -/
theorem keeps_density [DecidableEq X] [DecidableEq C] {s : Nat → X} {name : C → X}
    {cs : List C} (distinct : Distinct (cs.map name)) {ℓ P : Nat} {a d m q : C → Nat}
    (keeps : ∀ c, c ∈ cs → Keeps s name c ℓ (d c) (m c))
    (exceeds : ∀ c, c ∈ cs → m c < (a c + 1 + ℓ) * d c)
    (fits : ∀ c, c ∈ cs → q c * a c ≤ P) : total cs q ≤ P :=
  density distinct (fun c mem => within_of_keeps (keeps c mem) (exceeds c mem)) fits

/-- **Spare capacity does not keep.** Three conditions, distinct by their names, whose margins
give windows 2, 3 and `M` (`m < (a + 1 + ℓ) d` for each): for `M ≥ 7` their counts over `6 M`
steps, `3 M`, `2 M` and `6`, fit with room (the reader idle a share `1/6 - 1/M` of its steps),
and still no schedule keeps all three. -/
theorem spare_not_enough [DecidableEq X] [DecidableEq C] {s : Nat → X} {name : C → X}
    {x y z : C} (xy : name x ≠ name y) (zy : name z ≠ name y) (xz : name x ≠ name z)
    {ℓ M : Nat} {d m : C → Nat} (large : 7 ≤ M)
    (twice : m x < (2 + 1 + ℓ) * d x) (thrice : m y < (3 + 1 + ℓ) * d y)
    (rarely : m z < (M + 1 + ℓ) * d z) :
    (3 * M * 2 = 6 * M ∧ 2 * M * 3 = 6 * M ∧ 6 * M = 6 * M ∧ 3 * M + 2 * M + 6 < 6 * M) ∧
      ¬ (Keeps s name x ℓ (d x) (m x) ∧ Keeps s name y ℓ (d y) (m y) ∧
        Keeps s name z ℓ (d z) (m z)) :=
  ⟨two_three_room large, fun ⟨kx, ky, kz⟩ => no_two_three xy zy xz M
    ⟨within_of_keeps kx twice, within_of_keeps ky thrice, within_of_keeps kz rarely⟩⟩

/-- **Half a reader keeps.** Conditions whose margins give windows `a c` (`(a c + ℓ) d c ≤ m c`)
with weights `q c`, `2 N ≤ q c * a c` for `N = 2 ^ D`, totalling at most `N` (in rates,
`∑ 1 / a c ≤ 1/2`): one schedule keeps them all. -/
theorem keeps_of_half [DecidableEq C] {cs : List C} {ℓ D : Nat} {a d m q : C → Nat}
    (positive : ∀ c, c ∈ cs → 0 < a c) (fits : ∀ c, c ∈ cs → (a c + ℓ) * d c ≤ m c)
    (weights : ∀ c, c ∈ cs → 2 ^ (D + 1) ≤ q c * a c) (half : total cs q ≤ 2 ^ D) :
    ∃ s : Nat → Option C, ∀ c, c ∈ cs → Keeps s some c ℓ (d c) (m c) :=
  match half_suffices positive weights half with
  | ⟨s, reads⟩ => ⟨s, fun c mem => keeps_of_within (reads c mem) (fits c mem)⟩

end ReadingSchedule

end Becoming
