#!/usr/bin/env python3
"""Build SG13's tree: Optimum with a coupling for every step a need is met, wherever those steps fall.
usage: python3 -B build_tree.py   (SG13_ROOT names the checkout to read; SG13_BASE, a git ref of it, reads it at that ref).
Writes tree/Becoming/Optimum.lean."""
import os
import subprocess
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = Path(os.environ['SG13_ROOT']).resolve() if os.environ.get('SG13_ROOT') else HERE.parents[5]
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'


def once(text, old, new):
    assert text.count(old) == 1, ('edit does not match once', old[:90], text.count(old))
    return text.replace(old, new)


def read(name):
    if os.environ.get('SG13_BASE'):
        rel = (PKG / 'Becoming' / f'{name}.lean').relative_to(ROOT)
        return subprocess.run(['git', '-C', str(ROOT), 'show', f"{os.environ['SG13_BASE']}:{rel}"], check=True,
                              capture_output=True, text=True).stdout
    return (PKG / 'Becoming' / f'{name}.lean').read_text(encoding='utf-8')


op = read('Optimum')
assert 'metCount' not in op, 'already built'
HEADER = '/-! ## A coupling added for each step a dependence is kept'
H = op.index(HEADER)

# 1. The shortfall over any counted steps; the prefix law its case (rule 9).
a = op.index('/-- **What met steps forgo.**', H)
b = op.index('/-- **What a course met through `j` steps draws.**', H)
SHORT = '''/-- The steps among the first `n` at which `p` holds, counted. -/
def countUpTo (p : Nat → Bool) : Nat → Nat
  | 0 => 0
  | n + 1 => countUpTo p n + if p n then 1 else 0

/-- At most one is counted at a step. -/
theorem counted_le_one (b : Bool) : (if b then 1 else 0) ≤ 1 := by
  cases b <;> decide

/-- At most every step is counted. -/
theorem countUpTo_le (p : Nat → Bool) : ∀ n, countUpTo p n ≤ n
  | 0 => Nat.le_refl 0
  | n + 1 => Nat.add_le_add (countUpTo_le p n) (counted_le_one (p n))

/-- Every step is counted where `p` holds at every step. -/
theorem countUpTo_all {p : Nat → Bool} :
    ∀ {n : Nat}, (∀ t, t < n → p t = true) → countUpTo p n = n
  | 0, _ => rfl
  | n + 1, all => by
    show countUpTo p n + (if p n = true then 1 else 0) = n + 1
    rw [countUpTo_all fun t lt => all t (Nat.lt_succ_of_lt lt), if_pos (all n (Nat.lt_succ_self n))]

/-- A step at which `p` fails leaves the count below the steps. -/
theorem countUpTo_lt {p : Nat → Bool} {t : Nat} (fails : p t = false) :
    ∀ {n : Nat}, t < n → countUpTo p n < n
  | 0, lt => absurd lt (Nat.not_lt_zero t)
  | n + 1, lt => match Nat.lt_or_ge t n with
    | .inl before => Nat.lt_of_le_of_lt (Nat.le_trans (Nat.add_le_add_left (counted_le_one _) _)
        (countUpTo_lt fails before)) (Nat.lt_succ_self n)
    | .inr after =>
      have none : (if p n = true then 1 else 0) = 0 := if_neg fun holds => Bool.noConfusion
        ((Eq.subst (motive := fun z => p z = false)
          (Nat.le_antisymm (Nat.le_of_lt_succ lt) after) fails).symm.trans holds)
      Nat.lt_of_le_of_lt (Nat.le_trans (Nat.le_of_eq (congrArg (countUpTo p n + ·) none))
        (countUpTo_le p n)) (Nat.lt_succ_self n)

/-- The steps before `j` among the first `n`, `j ≤ n`, number `j`. -/
theorem countUpTo_below {j : Nat} : ∀ {n : Nat}, j ≤ n → countUpTo (fun t => decide (t < j)) n = j
  | 0, le => (Nat.le_antisymm le (Nat.zero_le j)).symm
  | n + 1, le => match le_or_eq_succ le with
    | .inl earlier => by
      show countUpTo (fun t => decide (t < j)) n + (if decide (n < j) = true then 1 else 0) = j
      rw [countUpTo_below earlier, if_neg fun holds =>
        Nat.lt_irrefl n (Nat.lt_of_lt_of_le (of_decide_eq_true holds) earlier)]
      exact Nat.add_zero j
    | .inr last => by
      show countUpTo (fun t => decide (t < j)) n + (if decide (n < j) = true then 1 else 0) = j
      rw [countUpTo_all fun t lt => decide_eq_true
          (Nat.lt_of_lt_of_le lt (Nat.le_trans (Nat.le_succ n) (Nat.le_of_eq last.symm))),
        if_pos (decide_eq_true (Nat.lt_of_lt_of_le (Nat.lt_succ_self n) (Nat.le_of_eq last.symm)))]
      exact last.symm

/-- One more step, counted where `b` holds: what is forgone there with `q` covers `r`. -/
theorem counted_step (b : Bool) {J S δ : Nat} (earlier : J * r ≤ S + J * q)
    (met : b = true → r ≤ δ + q) :
    (J + if b then 1 else 0) * r ≤ S + δ + (J + if b then 1 else 0) * q :=
  match b, met with
  | true, met => Nat.le_trans (Nat.le_of_eq (Nat.succ_mul J r))
      (Nat.le_trans (Nat.add_le_add earlier (met rfl))
        (Nat.le_of_eq ((add_four S (J * q) δ q).trans
          (congrArg (S + δ + ·) (Nat.succ_mul J q).symm))))
  | false, _ => Nat.le_trans earlier (Nat.add_le_add_right (Nat.le_add_right S δ) _)

/-- **What counted steps forgo.** Where what is given at each counted step among the first `n` is at
most `q`, `r` for each counted step is at most everything given falls short of `r` across the `n`
steps, with `q` for each counted step: the steps may fall anywhere. -/
theorem shortfall_count_ge {g : Nat → Nat} (p : Nat → Bool) :
    ∀ {n : Nat}, (∀ t, t < n → p t = true → g t ≤ q) →
      countUpTo p n * r ≤ Amounts.whole.sum (fun t => r - g t) 0 n + countUpTo p n * q
  | 0, _ => Nat.le_of_eq ((Nat.zero_mul r).trans
      ((Nat.zero_add 0).symm.trans (congrArg (0 + ·) (Nat.zero_mul q).symm)))
  | n + 1, met => counted_step (p n) (S := Amounts.whole.sum (fun t => r - g t) 0 n)
      (δ := r - g (0 + n)) (shortfall_count_ge p fun t lt => met t (Nat.lt_succ_of_lt lt))
      fun holds => Eq.subst (motive := fun z => r ≤ r - g z + q) (Nat.zero_add n).symm
        (le_sub_add_of_le (met n (Nat.lt_succ_self n) holds))

/-- **What met steps forgo.** Where what is given at each of the first `j` of `n` steps is at most
`q`, `r` for each of those steps is at most everything given falls short of `r` across the `n`
steps, with `q` for each of those steps: the case of `shortfall_count_ge` counting the steps before
`j`. -/
theorem shortfall_ge {g : Nat → Nat} {n j : Nat} (le : j ≤ n) (met : ∀ t, t < j → g t ≤ q) :
    j * r ≤ Amounts.whole.sum (fun t => r - g t) 0 n + j * q :=
  Eq.subst (motive := fun z => z * r ≤ Amounts.whole.sum (fun t => r - g t) 0 n + z * q)
    (countUpTo_below le)
    (shortfall_count_ge (fun t => decide (t < j)) fun t _ holds => met t (of_decide_eq_true holds))

'''
op = op[:a] + SHORT + op[b:]

# 2. The laws for steps met anywhere, before the end of the section's Optimum part.
MET = '''
/-! ### Steps met again after a fall -/

/-- The steps from the first to the `n`-th at which a course stands at `m` or above, counted,
wherever they fall. -/
def metCount (m : Nat) (x : Nat → Nat) (n : Nat) : Nat :=
  countUpTo (fun t => decide (m ≤ x (t + 1))) n

/-- A course standing at `m` or above at every step from the first to the `n`-th is met at each. -/
theorem metCount_of_met {x : Nat → Nat} {n : Nat} (met : ∀ t, 0 < t → t ≤ n → m ≤ x t) :
    metCount m x n = n :=
  countUpTo_all fun t lt => decide_eq_true (met (t + 1) (Nat.succ_pos t) lt)

/-- **What a course met at any steps draws and leaves.** Where each step leaves at most the level with
what is given, `R` gives at most `r` at every level and at most `q` at every level at or above `m`:
what a course draws across `n + 1` steps, with what it leaves and `r` for each step from the first
to the `n`-th at which it stands at `m` or above, is at most its start with what is given there,
`r` for each step after the first and `q` for each of those steps, wherever they fall. -/
theorem met_count_drawn_le (renews : ∀ z, R z ≤ r) (above : ∀ z, m ≤ z → R z ≤ q) {x : Nat → Nat}
    (within : ∀ t, x (t + 1) ≤ x t + R (x t)) (n : Nat) :
    drawnOver R x (n + 1) + x (n + 1) + metCount m x n * r ≤
      x 0 + R (x 0) + r * n + metCount m x n * q :=
  have whole : drawnOver R x (n + 1) + x (n + 1) +
      Amounts.whole.sum (fun t => r - R (x (t + 1))) 0 n = x 0 + R (x 0) + r * n :=
    drawn_add_shortfall_after (x := x) (g := fun t => R (x t)) within (fun t => renews (x t)) n
  have short : metCount m x n * r ≤
      Amounts.whole.sum (fun t => r - R (x (t + 1))) 0 n + metCount m x n * q :=
    shortfall_count_ge (g := fun t => R (x (t + 1))) (fun t => decide (m ≤ x (t + 1)))
      fun _ _ holds => above _ (of_decide_eq_true holds)
  Nat.le_trans (Nat.add_le_add_left short _) (Nat.le_of_eq
    ((Nat.add_assoc _ _ _).symm.trans (congrArg (· + metCount m x n * q) whole)))

/-- Comparing a course met at counted steps with a keeping course, under a coupling for every step
met: `J` steps met to the `n`-th, `M` after the last, leaving at least `l`. -/
theorem le_of_met_count {A D Da Wa S e J u M l d : Nat} (split : n = J + u)
    (coupledAt : A ≤ D + c * (J + M)) (drawn : D + l + J * r ≤ S + r * n + J * q)
    (most : Da + e = S + q * n) (coupled : Da + c * (n + 1) ≤ Wa)
    (key : r * u + (c * M + (d + e)) ≤ q * u + (c * u + c) + l) : A + d ≤ Wa := by
  subst split
  rw [Nat.mul_add c J M] at coupledAt
  rw [Nat.mul_add r J u, Nat.mul_comm J r, Nat.mul_comm J q] at drawn
  rw [Nat.mul_add q J u] at most
  rw [Nat.mul_add c (J + u) 1, Nat.mul_add c J u, Nat.mul_one] at coupled
  have short : D + l ≤ S + r * u + q * J := by
    rw [Nat.add_comm (r * J) (r * u), ← Nat.add_assoc S (r * u) (r * J),
      Nat.add_right_comm (S + r * u) (r * J) (q * J)] at drawn
    exact Naturals.le_of_add_le_add_right drawn
  have kept : Da + (c * J + c * u + c) + (l + e) =
      S + q * J + c * J + (q * u + (c * u + c) + l) :=
    calc Da + (c * J + c * u + c) + (l + e) = Da + e + (c * J + c * u + c) + l := by
          rw [Nat.add_comm l e, ← Nat.add_assoc (Da + (c * J + c * u + c)) e l,
            Nat.add_right_comm Da (c * J + c * u + c) e]
      _ = S + (q * J + q * u) + (c * J + c * u + c) + l := by rw [most]
      _ = S + q * J + c * J + (q * u + (c * u + c) + l) := by
          rw [← Nat.add_assoc S (q * J) (q * u), Nat.add_assoc (c * J) (c * u) c,
            add_four (S + q * J) (q * u) (c * J) (c * u + c),
            Nat.add_assoc (S + q * J + c * J) (q * u + (c * u + c)) l]
  apply Naturals.le_of_add_le_add_right (k := l + e)
  calc A + d + (l + e) ≤ D + (c * J + c * M) + d + (l + e) :=
        Nat.add_le_add_right (Nat.add_le_add_right coupledAt d) _
    _ = D + l + (c * J + c * M + (d + e)) := by
        rw [add_four (D + (c * J + c * M)) d l e, Nat.add_right_comm D (c * J + c * M) l,
          Nat.add_assoc (D + l) (c * J + c * M) (d + e)]
    _ ≤ S + r * u + q * J + (c * J + c * M + (d + e)) := Nat.add_le_add_right short _
    _ = S + q * J + c * J + (r * u + (c * M + (d + e))) := by
        rw [Nat.add_right_comm S (r * u) (q * J), Nat.add_assoc (c * J) (c * M) (d + e),
          add_four (S + q * J) (r * u) (c * J) (c * M + (d + e))]
    _ ≤ S + q * J + c * J + (q * u + (c * u + c) + l) := Nat.add_le_add_left key _
    _ = Da + (c * J + c * u + c) + (l + e) := kept.symm
    _ ≤ Wa + (l + e) := Nat.add_le_add_right coupled _

/-- What `r` gives over `v` steps is at most what `q` and `c` give, where `r ≤ q + c`. -/
theorem mul_le_of_rate (rate : r ≤ q + c) (v : Nat) : r * v ≤ q * v + c * v :=
  Nat.le_trans (Nat.le_of_eq (Nat.mul_comm r v)) (Nat.le_trans (Nat.mul_le_mul_left v rate)
    (Nat.le_of_eq ((Nat.mul_add v q c).trans (by rw [Nat.mul_comm v q, Nat.mul_comm v c]))))

/-- The renewal forgone at steps met short of the horizon, against a fall that is met again at its
end. -/
theorem met_key_end {v e d : Nat} (rate : r ≤ q + c) (atEnd : r + e + d ≤ q + c + m) :
    r * (v + 1) + (c * 1 + (d + e)) ≤ q * (v + 1) + (c * (v + 1) + c) + m :=
  have hv : r * v ≤ q * v + c * v := mul_le_of_rate rate v
  calc r * (v + 1) + (c * 1 + (d + e)) = r * v + (r + e + d) + c := by
        rw [Nat.mul_add r v 1, Nat.mul_one r, Nat.mul_one c, Nat.add_assoc (r * v) r (c + (d + e)),
          Nat.add_assoc (r * v) (r + e + d) c, Nat.add_comm d e, Nat.add_comm c (e + d),
          ← Nat.add_assoc r (e + d) c, ← Nat.add_assoc r e d]
    _ ≤ q * v + c * v + (q + c + m) + c := Nat.add_le_add_right (Nat.add_le_add hv atEnd) c
    _ = q * (v + 1) + (c * (v + 1) + c) + m := by
        rw [Nat.mul_add q v 1, Nat.mul_one q, Nat.mul_add c v 1, Nat.mul_one c,
          Nat.add_assoc (q * v + c * v) (q + c + m) c, Nat.add_right_comm (q + c) m c,
          Nat.add_assoc q c c, Nat.add_assoc (c * v) c c, add_four (q * v) q (c * v) (c + c),
          Nat.add_assoc (q * v + c * v) (q + (c + c)) m]

/-- The renewal forgone at steps met short of the horizon, against a course below the need at its
end. -/
theorem met_key_drop {u e d : Nat} (rate : r ≤ q + c) (drop : e + d ≤ c) :
    r * u + (c * 0 + (d + e)) ≤ q * u + (c * u + c) + 0 :=
  have hu : r * u ≤ q * u + c * u := mul_le_of_rate rate u
  calc r * u + (c * 0 + (d + e)) = r * u + (e + d) := by
        rw [Nat.mul_zero, Nat.zero_add, Nat.add_comm d e]
    _ ≤ q * u + c * u + c := Nat.add_le_add hu drop
    _ = q * u + (c * u + c) + 0 := by rw [Nat.add_zero, Nat.add_assoc]

/-- **A course falling below the need is worth no more than one keeping it, wherever it is met
again.** Where `R` gives at most `r` at every level and at most `q` at every level at or above `m`,
for a worth at most what a course draws with `c` for each step from the first to the horizon's last
at which it stands at `m` or above, and a keeping course drawing with what it leaves `e` the start
with what is given there and `q` for each step after, worth at least what it draws with `c` for each
step: an open course below `m` at some step from the first to the last is worth at most the keeping
course, less `d`, where `r ≤ q + c`, `r + e + d ≤ q + c + m` and `e + d ≤ c`. -/
theorem falls_met_le {worth : (Nat → Nat) → Nat} {e d : Nat} {x K : Nat → Nat}
    (renews : ∀ z, R z ≤ r) (above : ∀ z, m ≤ z → R z ≤ q) (opens : OpenCourse R k s x)
    (counted : worth x ≤ drawnOver R x (n + 1) + c * metCount m x (n + 1))
    (most : drawnOver R K (n + 1) + e = s + R s + q * n)
    (coupled : drawnOver R K (n + 1) + c * (n + 1) ≤ worth K)
    (rate : r ≤ q + c) (atEnd : r + e + d ≤ q + c + m) (drop : e + d ≤ c)
    {t : Nat} (le : t ≤ n) (below : x (t + 1) < m) : worth x + d ≤ worth K := by
  have drawn : drawnOver R x (n + 1) + x (n + 1) + metCount m x n * r ≤
      s + R s + r * n + metCount m x n * q :=
    Eq.subst (motive := fun z => drawnOver R x (n + 1) + x (n + 1) + metCount m x n * r ≤
      z + R z + r * n + metCount m x n * q) opens.1
      (met_count_drawn_le renews above (fun t => (opens.2 t).1) n)
  have unmet : decide (m ≤ x (t + 1)) = false := decide_eq_false (Nat.not_le_of_gt below)
  cases holds : decide (m ≤ x (n + 1)) with
  | true =>
    have met : m ≤ x (n + 1) := of_decide_eq_true holds
    have count : metCount m x (n + 1) = metCount m x n + 1 := by
      show countUpTo (fun t => decide (m ≤ x (t + 1))) n +
        (if decide (m ≤ x (n + 1)) = true then 1 else 0) = _
      rw [holds]
      rfl
    have short : t < n := match Nat.lt_or_ge t n with
      | .inl lt => lt
      | .inr ge => absurd met (Nat.not_le_of_gt (Eq.subst (motive := fun z => x (z + 1) < m)
          (Nat.le_antisymm le ge) below))
    match le_dest (countUpTo_lt (p := fun t => decide (m ≤ x (t + 1))) unmet short) with
    | ⟨v, split⟩ =>
      exact le_of_met_count (J := metCount m x n) (u := v + 1) (M := 1) (l := m)
        (split.trans ((Nat.add_right_comm _ 1 v).trans (Nat.add_assoc _ v 1)))
        (Nat.le_trans counted (Nat.le_of_eq
          (congrArg (fun z => drawnOver R x (n + 1) + c * z) count)))
        (Nat.le_trans (Nat.add_le_add_right (Nat.add_le_add_left met _) _) drawn) most coupled
        (met_key_end rate atEnd)
  | false =>
    have count : metCount m x (n + 1) = metCount m x n + 0 := by
      show countUpTo (fun t => decide (m ≤ x (t + 1))) n +
        (if decide (m ≤ x (n + 1)) = true then 1 else 0) = _
      rw [holds]
      rfl
    match le_dest (countUpTo_le (fun t => decide (m ≤ x (t + 1))) n) with
    | ⟨u, split⟩ =>
      exact le_of_met_count (J := metCount m x n) (u := u) (M := 0) (l := 0) split
        (Nat.le_trans counted (Nat.le_of_eq
          (congrArg (fun z => drawnOver R x (n + 1) + c * z) count)))
        (Nat.le_trans (Nat.add_le_add_right (Nat.add_le_add_left (Nat.zero_le _) _) _) drawn) most
        coupled (met_key_drop rate drop)

/-- **A coupling for every step met keeps the need, wherever those steps fall.** Where `R` gives at
most `r` at every level, at most `q` at every level at or above `m`, and `q` at some `y` within the
start with what is given there, from a start meeting `m`, over a horizon of at least two steps, with
a capacity covering what the first step draws down to `y` and `y` with `q` down to some `e` between
`m` and `y`; for a worth adding at least `c` for each step to what a keeping course draws, and at
most `c` for each step at which a course stands at `m` or above, wherever: where
`r + e < q + c + m` and `e < c`, every optimum, among the open courses, of every order rising with
the worth keeps its level at `m` or above through the horizon. A fall met again forgoes `c` for each
step below and gains at most the renewal forgone there and the end's excess over the need, so the
threshold is above the one counting from the start, `r ≤ q + c` (`frontier_keeps_stepwise`). -/
theorem frontier_keeps_met {better : (Nat → Nat) → (Nat → Nat) → Prop}
    {worth : (Nat → Nat) → Nat} {e : Nat}
    (rising : ∀ a b, worth a < worth b → better b a)
    (coupled : ∀ a, OpenCourse R k s a → Keeps m n a → drawnOver R a (n + 1) + c * (n + 1) ≤ worth a)
    (counted : ∀ a, OpenCourse R k s a →
      worth a ≤ drawnOver R a (n + 1) + c * metCount m a (n + 1))
    (renews : ∀ z, R z ≤ r) (above : ∀ z, m ≤ z → R z ≤ q) (atEnd : r + e < q + c + m)
    (exceeds : e < c) (greatest : R y = q) (meets : m ≤ s) (ends : m ≤ e) (reach : y ≤ s + R s)
    (settles : e ≤ y) (drawsDown : s + R s ≤ y + k) (holds : y + q ≤ e + k) (long : 0 < n)
    {x : Nat → Nat} (front : Frontier (OpenCourse R k s) better x) : Keeps m n x :=
  match keeps_or_falls (Eq.subst (motive := fun z => m ≤ z) front.1.1.symm meets) n with
  | .inl keeps => keeps
  | .inr ⟨_, le, _, below⟩ =>
    have opens : OpenCourse R k s (continued R (holdingTo s y e n) n) :=
      continued_open (x := holdingTo s y e n) rfl
        (holdingTo_steps greatest reach settles drawsDown holds long)
    have most : drawnOver R (continued R (holdingTo s y e n) n) (n + 1) + e = s + R s + q * n :=
      (congrArg (· + e) continued_drawn).trans (holdingTo_most greatest reach settles n)
    have rate : r ≤ q + c := Nat.le_of_lt (Naturals.le_of_add_le_add_right (k := m)
      (Nat.le_trans (Nat.le_of_eq (Nat.add_right_comm r 1 m))
        (Nat.lt_of_le_of_lt (Nat.add_le_add_left ends r) atEnd)))
    absurd (rising x _ (falls_met_le (d := 1) renews above front.1 (counted x front.1) most
      (coupled _ opens (continued_keeps (holdingTo_keeps meets (Nat.le_trans ends settles) ends)))
      rate atEnd exceeds le below)) (front.2 _ opens)

/-- **The optimum keeping the need under a coupling for every step met.** Under the premises of
`frontier_keeps_met` with the keeping course ending at `m`, for a worth adding exactly `c` for each
step to what a keeping course draws, where `r ≤ q + c` and `m ≤ c`: the course holding `y` to the
`n`-th step, at `m` after the last and drawing nothing after it, is an optimum, among the open
courses, of the order by the worth. -/
theorem continued_met_frontier {worth : (Nat → Nat) → Nat}
    (coupled : ∀ a, OpenCourse R k s a → Keeps m n a → drawnOver R a (n + 1) + c * (n + 1) ≤ worth a)
    (bounded : ∀ a, OpenCourse R k s a → Keeps m n a → worth a ≤ drawnOver R a (n + 1) + c * (n + 1))
    (counted : ∀ a, OpenCourse R k s a →
      worth a ≤ drawnOver R a (n + 1) + c * metCount m a (n + 1))
    (renews : ∀ z, R z ≤ r) (above : ∀ z, m ≤ z → R z ≤ q) (rate : r ≤ q + c) (exceeds : m ≤ c)
    (greatest : R y = q) (needs : m ≤ y) (meets : m ≤ s) (reach : y ≤ s + R s)
    (drawsDown : s + R s ≤ y + k) (holds : y + q ≤ m + k) (long : 0 < n) :
    Frontier (OpenCourse R k s) (fun b a => worth a < worth b)
      (continued R (holdingTo s y m n) n) :=
  have optimum := continued_keeping_frontier above greatest needs meets reach drawsDown holds long
  have most : drawnOver R (continued R (holdingTo s y m n) n) (n + 1) + m = s + R s + q * n :=
    (congrArg (· + m) continued_drawn).trans (holdingTo_most greatest reach needs n)
  have least := coupled _ optimum.1.1 optimum.1.2
  have atEnd : r + m + 0 ≤ q + c + m := Nat.add_le_add_right rate m
  ⟨optimum.1.1, fun b opens more => Nat.not_le_of_gt more
    (match keeps_or_falls (Eq.subst (motive := fun z => m ≤ z) opens.1.symm meets) n with
    | .inl keeps => Nat.le_trans (bounded b opens keeps) (Nat.le_trans (Nat.add_le_add_right
        (Nat.ge_of_not_lt (optimum.2 b ⟨opens, keeps⟩)) _) least)
    | .inr ⟨_, le, _, below⟩ => falls_met_le (d := 0) renews above opens (counted b opens) most least
        rate atEnd exceeds le below)⟩
'''
E = op.index('\nend Optimum\n', H)
op = op[:E] + '\n' + MET + op[E:]

# 3. The web law, before the end of the section's Web part.
WEBLAW = '''
/-- **A coupling for every step met keeps the dependence, wherever those steps fall.** Under the
premises of `Optimum.frontier_keeps_met`, with a formation's need on the condition `m` at every step:
every optimum, among the open courses, of every order rising with a worth adding at least `w` for each
step to what a course keeping the condition at `m` or above draws, and at most `w` for each step at
which a course stands at `m` or above, wherever, meets the need at every step through the horizon,
where `r + e < q + w + m` and `e < w`. -/
theorem frontier_met_kept
    (rising : ∀ a b, worth a < worth b → better b a)
    (coupled : ∀ a, OpenCourse R k s a → Optimum.Keeps m n a →
      drawnOver R a (n + 1) + w * (n + 1) ≤ worth a)
    (counted : ∀ a, OpenCourse R k s a →
      worth a ≤ drawnOver R a (n + 1) + w * Optimum.metCount m a (n + 1))
    (renews : ∀ z, R z ≤ r) (above : ∀ z, m ≤ z → R z ≤ q) (atEnd : r + e < q + w + m)
    (exceeds : e < w) (greatest : R y = q) (meets : m ≤ s) (ends : m ≤ e) (reach : y ≤ s + R s)
    (settles : e ≤ y) (drawsDown : s + R s ≤ y + k) (holds : y + q ≤ e + k) (long : 0 < n)
    (front : Frontier (OpenCourse R k s) better fun t => W.level t c)
    (need : ∀ t, W.need t f c = m) :
    ∀ t, t ≤ n + 1 → W.need t f c ≤ W.level t c :=
  fun t le => Nat.le_trans (Nat.le_of_eq (need t))
    (Optimum.frontier_keeps_met rising coupled counted renews above atEnd exceeds greatest meets ends
      reach settles drawsDown holds long front t le)
'''
EW = op.index('\nend Web\n', H)
op = op[:EW] + '\n' + WEBLAW + op[EW:]

# 4. The witness, after logistic_stepwise.
INST = '''
/-- A burst: four units renewed at one, nothing at any other level. -/
def burst : Nat → Nat
  | 1 => 4
  | _ => 0

/-- The burst gives at most four. -/
theorem burst_le : ∀ z, burst z ≤ 4
  | 0 => Nat.zero_le 4
  | 1 => Nat.le_refl 4
  | _ + 2 => Nat.zero_le 4

/-- The burst gives nothing at two or above. -/
theorem burst_above : ∀ z, 2 ≤ z → burst z ≤ 0
  | 0, le => absurd le (by decide)
  | 1, le => absurd le (by decide)
  | _ + 2, _ => Nat.le_refl 0

/-- From two, the course falling to one at the first step and regrown to two at the next, standing
there after. -/
def fallOnce : Nat → Nat
  | 1 => 1
  | _ => 2

/-- The course falling once is open from two under the burst with capacity three. -/
theorem fallOnce_open : OpenCourse burst 3 2 fallOnce :=
  ⟨rfl, fun t => match t with
    | 0 => ⟨by decide, by decide⟩
    | 1 => ⟨by decide, by decide⟩
    | _ + 2 => ⟨Nat.le_refl 2, Nat.zero_le 3⟩⟩

/-- The course falling once draws four across every horizon of at least two steps. -/
theorem fallOnce_drawn : ∀ n, drawnOver burst fallOnce (n + 2) = 4
  | 0 => rfl
  | n + 1 => show drawnOver burst fallOnce (n + 2) + drawnAt fallOnce (fun t => burst (fallOnce t))
      (0 + (n + 2)) = 4 by rw [fallOnce_drawn n, Nat.zero_add]; rfl

/-- The course falling once is met at every step from the second on. -/
theorem fallOnce_met : ∀ n, metCount 2 fallOnce (n + 2) = n + 1
  | 0 => rfl
  | n + 1 => show metCount 2 fallOnce (n + 2) + (if decide (2 ≤ fallOnce (n + 2 + 1)) = true then 1
      else 0) = n + 2 by rw [fallOnce_met n]; rfl

/-- What a course draws across `n + 1` steps under `R`, with `c` for each step from the first to the
last at which it stands at `m` or above, wherever. -/
def metDraw (R : Nat → Nat) (m c n : Nat) (x : Nat → Nat) : Nat :=
  drawnOver R x (n + 1) + c * metCount m x (n + 1)

/-- A course keeping `m` through the horizon adds `c` for each of its steps. -/
theorem metDraw_of_keeps {R : Nat → Nat} {m c n : Nat} {x : Nat → Nat} (keeps : Keeps m n x) :
    metDraw R m c n x = drawnOver R x (n + 1) + c * (n + 1) :=
  congrArg (fun z => drawnOver R x (n + 1) + c * z)
    (metCount_of_met fun t _ le => keeps t le)

/-- **The burst witness: steps met again after a fall.** From a source at two, the level the dweller
needs, under a burst renewing four units at one and nothing elsewhere, with capacity three, and a
coupling of four a step, the renewal forgone a step at the need: under the order by what the taker
draws with four for each step the source stays at two or above from the start, every optimum keeps
the dweller met through the horizon of `n + 2` steps (`Web.frontier_keeps_stepwise`); under the order
adding four for every step the source stands at two or above, wherever, the course staying at two is
an optimum (`continued_met_frontier`) and so is the course falling to one at the first step and
regrown to two at the next, which breaks the dweller and meets it again; with five a step every
optimum of that order keeps the dweller met (`Web.frontier_met_kept`). -/
theorem burst_met (n : Nat) :
    (∀ x, Frontier (OpenCourse burst 3 2)
        (fun b a => stepwiseDraw burst 2 4 (n + 1) a < stepwiseDraw burst 2 4 (n + 1) b) x →
      ∀ t, t ≤ n + 2 → (web (onSource x)).need t .dweller .source ≤
        (web (onSource x)).level t .source) ∧
    Frontier (OpenCourse burst 3 2)
        (fun b a => metDraw burst 2 4 (n + 1) a < metDraw burst 2 4 (n + 1) b)
        (continued burst (holdingTo 2 2 2 (n + 1)) (n + 1)) ∧
    Frontier (OpenCourse burst 3 2)
        (fun b a => metDraw burst 2 4 (n + 1) a < metDraw burst 2 4 (n + 1) b) fallOnce ∧
    (web (onSource fallOnce)).Broken 0 .dweller .source ∧
    (web (onSource fallOnce)).need 2 .dweller .source ≤ (web (onSource fallOnce)).level 2 .source ∧
    (∀ x, Frontier (OpenCourse burst 3 2)
        (fun b a => metDraw burst 2 5 (n + 1) a < metDraw burst 2 5 (n + 1) b) x →
      ∀ t, t ≤ n + 2 → (web (onSource x)).need t .dweller .source ≤
        (web (onSource x)).level t .source) :=
  have keepK : Keeps 2 (n + 1) (continued burst (holdingTo 2 2 2 (n + 1)) (n + 1)) :=
    continued_keeps (holdingTo_keeps (Nat.le_refl 2) (Nat.le_refl 2) (Nat.le_refl 2))
  have optimum : Frontier (OpenCourse burst 3 2)
      (fun b a => metDraw burst 2 4 (n + 1) a < metDraw burst 2 4 (n + 1) b)
      (continued burst (holdingTo 2 2 2 (n + 1)) (n + 1)) :=
    continued_met_frontier (R := burst) (k := 3) (s := 2) (m := 2) (n := n + 1) (y := 2) (q := 0)
      (r := 4) (c := 4) (fun _ _ keeps => Nat.le_of_eq (metDraw_of_keeps keeps).symm)
      (fun _ _ keeps => Nat.le_of_eq (metDraw_of_keeps keeps)) (fun _ _ => Nat.le_refl _) burst_le
      burst_above (Nat.le_refl 4) (by decide) rfl (Nat.le_refl 2) (Nat.le_refl 2) (Nat.le_refl 2)
      (Nat.le_add_right 2 3) (Nat.le_add_right 2 3) (Nat.succ_pos n)
  have twice : drawnOver burst (continued burst (holdingTo 2 2 2 (n + 1)) (n + 1)) (n + 1 + 1) + 2 =
      0 + 2 :=
    (congrArg (· + 2) continued_drawn).trans
      ((holdingTo_most (R := burst) (r := 0) (s := 2) (y := 2) rfl (Nat.le_refl 2) (Nat.le_refl 2)
        (n + 1)).trans (congrArg (2 + burst 2 + ·) (Nat.zero_mul (n + 1))))
  have drawnK : drawnOver burst (continued burst (holdingTo 2 2 2 (n + 1)) (n + 1)) (n + 1 + 1) = 0 :=
    Naturals.add_right_cancel twice
  have alike : metDraw burst 2 4 (n + 1) (continued burst (holdingTo 2 2 2 (n + 1)) (n + 1)) =
      metDraw burst 2 4 (n + 1) fallOnce :=
    (metDraw_of_keeps keepK).trans (by
      show _ = drawnOver burst fallOnce (n + 2) + 4 * metCount 2 fallOnce (n + 2)
      rw [drawnK, fallOnce_drawn, fallOnce_met, Nat.zero_add, Nat.mul_succ 4 (n + 1), Nat.add_comm])
  have coupledS : ∀ a, OpenCourse burst 3 2 a → Keeps 2 (n + 1) a →
      drawnOver burst a (n + 1 + 1) + 4 * (n + 1 + 1) ≤ stepwiseDraw burst 2 4 (n + 1) a :=
    fun _ _ keeps => Nat.le_of_eq (stepwiseDraw_of_keeps keeps).symm
  have coupledAt : ∀ a j, OpenCourse burst 3 2 a → (∀ t, t ≤ j → 2 ≤ a t) → a (j + 1) < 2 →
      j ≤ n + 1 → stepwiseDraw burst 2 4 (n + 1) a ≤ drawnOver burst a (n + 1 + 1) + 4 * j :=
    fun _ _ _ met below le => Nat.le_of_eq (stepwiseDraw_of_falls met below le)
  ⟨fun x front =>
    Web.frontier_keeps_stepwise (W := web (onSource x)) (c := Place.source)
      (f := Formation.dweller) (R := burst) (k := 3) (s := 2) (m := 2) (n := n + 1) (w := 4)
      (worth := stepwiseDraw burst 2 4 (n + 1)) (y := 2) (q := 0) (r := 4) (e := 2)
      (fun _ _ less => less) coupledS coupledAt burst_le burst_above (Nat.le_refl 4) (by decide) rfl
      (Nat.le_refl 2) (Nat.le_refl 2) (Nat.le_refl 2) (Nat.le_refl 2) (Nat.le_add_right 2 3)
      (Nat.le_add_right 2 3) (Nat.succ_pos n) front (fun _ => rfl),
   optimum,
   ⟨fallOnce_open, fun b opens more => optimum.2 b opens (Nat.lt_of_le_of_lt (Nat.le_of_eq alike) more)⟩,
   ⟨trivial, Nat.le_refl 2, by decide⟩,
   Nat.le_refl 2,
   fun x front =>
    Web.frontier_met_kept (W := web (onSource x)) (c := Place.source)
      (f := Formation.dweller) (R := burst) (k := 3) (s := 2) (m := 2) (n := n + 1) (w := 5)
      (worth := metDraw burst 2 5 (n + 1)) (y := 2) (q := 0) (r := 4) (e := 2)
      (fun _ _ less => less) (fun _ _ keeps => Nat.le_of_eq (metDraw_of_keeps keeps).symm)
      (fun _ _ => Nat.le_refl _) burst_le burst_above (by decide) (by decide) rfl (Nat.le_refl 2)
      (Nat.le_refl 2) (Nat.le_refl 2) (Nat.le_refl 2) (Nat.le_add_right 2 3) (Nat.le_add_right 2 3)
      (Nat.succ_pos n) front (fun _ => rfl)⟩
'''
L = op.index('theorem logistic_stepwise', H)
EH = op.index('\nend Holding\n', L)
op = op[:EH] + '\n' + INST + op[EH:]
if (HERE / 'optimum_doc.py').exists():
    exec((HERE / 'optimum_doc.py').read_text(encoding='utf-8'))
out = HERE / 'tree' / 'Becoming' / 'Optimum.lean'
out.parent.mkdir(parents=True, exist_ok=True)
out.write_text(op, encoding='utf-8')
print('wrote', out.name, len(op.splitlines()), 'lines')
