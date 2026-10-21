#!/usr/bin/env python3
"""Build SG12's tree: Optimum with an order valuing what is left at the horizon at any worth.
usage: python3 -B build_tree.py   (SG12_ROOT names the checkout to read; SG12_BASE, a git ref of it, reads it at that ref).
Writes tree/Becoming/Optimum.lean."""
import os
import subprocess
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = Path(os.environ['SG12_ROOT']).resolve() if os.environ.get('SG12_ROOT') else HERE.parents[5]
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'


def once(text, old, new):
    assert text.count(old) == 1, ('edit does not match once', old[:90], text.count(old))
    return text.replace(old, new)


def read(name):
    if os.environ.get('SG12_BASE'):
        rel = (PKG / 'Becoming' / f'{name}.lean').relative_to(ROOT)
        return subprocess.run(['git', '-C', str(ROOT), 'show', f"{os.environ['SG12_BASE']}:{rel}"], check=True,
                              capture_output=True, text=True).stdout
    return (PKG / 'Becoming' / f'{name}.lean').read_text(encoding='utf-8')


op = read('Optimum')
assert 'byDrawnLeftAt' not in op, 'already built'

# 1. The steps of a course holding y and ending at any e within y with r: holdingTo_steps is its case (rule 9).
STEPS_OLD = op[op.index('/-- **The steps of the course holding `y` and ending at `e` within the horizon.**'):
               op.index('/-- **The course holding `y` and ending at `e` is open**')]
assert STEPS_OLD.count('theorem holdingTo_steps ') == 1
STEPS_NEW = '''/-- **The steps of the course holding `y` and ending at `e` within the horizon, `e` within `y` with
`r`.** Over a horizon of at least two steps, with a capacity covering what the first step draws down
to `y`, `r`, and `y` with `r` down to `e`, each step to the `n`-th leaves at most the level with what
is given and draws at most `k`: the end may lie above `y`, regrown at the last step. -/
theorem holdingTo_steps_of (greatest : R y = r) (reach : y ≤ s + R s) (rises : e ≤ y + r)
    (drawsDown : s + R s ≤ y + k) (middle : r ≤ k) (holds : y + r ≤ e + k) (long : 0 < n) :
    ∀ t, t ≤ n → holdingTo s y e n (t + 1) ≤ holdingTo s y e n t + R (holdingTo s y e n t) ∧
      drawnAt (holdingTo s y e n) (fun t => R (holdingTo s y e n t)) t ≤ k
  | 0, _ => ⟨Nat.le_trans (Nat.le_of_eq (holdingTo_before long)) reach, drawnAt_le_of
      (Nat.le_trans drawsDown (Nat.le_of_eq (congrArg (· + k) (holdingTo_before long).symm)))⟩
  | t + 1, le =>
    have stands : holdingTo s y e n (t + 1) + R (holdingTo s y e n (t + 1)) = y + r :=
      (congrArg (fun z => z + R z) (holdingTo_before (Nat.lt_of_succ_le le))).trans
        (congrArg (y + ·) greatest)
    match Nat.lt_or_ge (t + 1) n with
    | .inl lt => ⟨Nat.le_trans (Nat.le_of_eq (holdingTo_before lt))
          (Nat.le_trans (Nat.le_add_right y r) (Nat.le_of_eq stands.symm)),
        drawnAt_le_of (Nat.le_trans (Nat.le_of_eq stands) (Nat.le_trans (Nat.add_le_add_left middle y)
          (Nat.le_of_eq (congrArg (· + k) (holdingTo_before lt).symm))))⟩
    | .inr ge => ⟨Nat.le_trans (Nat.le_of_eq (holdingTo_after ge))
          (Nat.le_trans rises (Nat.le_of_eq stands.symm)),
        drawnAt_le_of (Nat.le_trans (Nat.le_of_eq stands)
          (Nat.le_trans holds (Nat.le_of_eq (congrArg (· + k) (holdingTo_after ge).symm))))⟩

/-- **The steps of the course holding `y` and ending at `e` within the horizon.** Over a horizon of
at least two steps, with a capacity covering what the first step draws down to `y` and `y` with `r`
down to `e`, each step to the `n`-th leaves at most the level with what is given and draws at most
`k`: the case of `holdingTo_steps_of` ending at most at `y`. -/
theorem holdingTo_steps (greatest : R y = r) (reach : y ≤ s + R s) (settles : e ≤ y)
    (drawsDown : s + R s ≤ y + k) (holds : y + r ≤ e + k) (long : 0 < n) :
    ∀ t, t ≤ n → holdingTo s y e n (t + 1) ≤ holdingTo s y e n t + R (holdingTo s y e n t) ∧
      drawnAt (holdingTo s y e n) (fun t => R (holdingTo s y e n t)) t ≤ k :=
  holdingTo_steps_of greatest reach (Nat.le_trans settles (Nat.le_add_right y r)) drawsDown
    (Naturals.le_of_add_le_add_left (Nat.le_trans holds (Nat.add_le_add_right settles k))) holds long

'''
op = op.replace(STEPS_OLD, STEPS_NEW)

# 2. The laws at any worth, after SG6's optima keeping the need.
VALUED = '''
/-! ### Valuing what is left at any worth -/

/-- The order of courses by what they draw across `n + 1` steps with `v` for each unit they leave
after them: more is better. -/
def byDrawnLeftAt (R : Nat → Nat) (v n : Nat) (b a : Nat → Nat) : Prop :=
  drawnOver R a (n + 1) + v * a (n + 1) < drawnOver R b (n + 1) + v * b (n + 1)

/-- At a worth of at least one, what is drawn with `v` for each unit left is what is drawn with what
is left and `v - 1` for each unit left. -/
theorem valued_eq {d l : Nat} : ∀ {v : Nat}, 0 < v → d + v * l = d + l + (v - 1) * l
  | 0, pos => absurd pos (Nat.lt_irrefl 0)
  | j + 1, _ => by
    show d + (j + 1) * l = d + l + j * l
    rw [Nat.succ_mul, Nat.add_comm (j * l) l, Nat.add_assoc]

/-- Two sums each at most another, the sums equal, are each equal. -/
theorem eq_of_add_eq_of_le {a b c d : Nat} (ab : a ≤ b) (cd : c ≤ d) (same : a + c = b + d) :
    a = b ∧ c = d :=
  have first : a = b := Nat.le_antisymm ab (Naturals.le_of_add_le_add_right
    (Nat.le_trans (Nat.le_of_eq same.symm) (Nat.add_le_add_left cd a)))
  ⟨first, Naturals.add_left_cancel (same.trans (congrArg (· + d) first.symm))⟩

/-- Multiplying by a positive number cancels. -/
theorem mul_left_cancel_of_pos {k : Nat} (pos : 0 < k) : ∀ {a b : Nat}, k * a = k * b → a = b
  | 0, 0, _ => rfl
  | 0, b + 1, same => absurd same (Nat.ne_of_lt (Nat.lt_of_lt_of_le pos (Nat.le_add_left k (k * b))))
  | a + 1, 0, same => absurd same.symm
      (Nat.ne_of_lt (Nat.lt_of_lt_of_le pos (Nat.le_add_left k (k * a))))
  | _ + 1, _ + 1, same => congrArg Nat.succ (mul_left_cancel_of_pos pos (Naturals.add_right_cancel same))

/-- **What a course draws with `v` for each unit it leaves, at most.** Where `R` gives at most `r`,
an open course leaving at most `e` after `n + 1` steps draws across them, with `v` of at least one
for each unit it leaves, at most the start with what is given there, `r` for each step after and
`v - 1` for each unit of `e`. -/
theorem open_valued_le_most (renews : ∀ z, R z ≤ r) {v e : Nat} (pos : 0 < v) {x : Nat → Nat}
    (opens : OpenCourse R k s x) (bounded : x (n + 1) ≤ e) :
    drawnOver R x (n + 1) + v * x (n + 1) ≤ s + R s + r * n + (v - 1) * e :=
  Nat.le_trans (Nat.le_of_eq (valued_eq pos))
    (Nat.add_le_add (open_left_le_most renews opens n) (Nat.mul_le_mul_left (v - 1) bounded))

/-- A course drawing and leaving the most, leaving `e`, draws with `v` for each unit it leaves the
start with what is given there, `r` for each step after and `v - 1` for each unit of `e`. -/
theorem valued_of_most {v e : Nat} (pos : 0 < v) {x : Nat → Nat}
    (most : drawnOver R x (n + 1) + x (n + 1) = s + R s + r * n) (left : x (n + 1) = e) :
    drawnOver R x (n + 1) + v * x (n + 1) = s + R s + r * n + (v - 1) * e :=
  (valued_eq pos).trans (Eq.subst (motive := fun z => drawnOver R x (n + 1) + x (n + 1) +
    (v - 1) * z = s + R s + r * n + (v - 1) * e) left.symm (congrArg (· + (v - 1) * e) most))

/-- **Exactly which courses draw and leave the most at a worth above one.** Where `R` gives at most
`r` and `v` exceeds one, an open course leaving at most `e` after `n + 1` steps draws across them,
with `v` for each unit it leaves, the start with what is given there, `r` for each step after and
`v - 1` for each unit of `e` exactly where it stands at a level of greatest renewal at every step
from the first to the `n`-th and leaves `e`. -/
theorem valued_most_iff (renews : ∀ z, R z ≤ r) {v e : Nat} (more : 1 < v) {x : Nat → Nat}
    (opens : OpenCourse R k s x) (bounded : x (n + 1) ≤ e) :
    drawnOver R x (n + 1) + v * x (n + 1) = s + R s + r * n + (v - 1) * e ↔
      (∀ t, t < n → R (x (t + 1)) = r) ∧ x (n + 1) = e :=
  have pos : 0 < v := Nat.lt_trans (Nat.zero_lt_one) more
  have identity := most_left_iff (x := x) (g := fun t => R (x t)) (fun t => (opens.2 t).1)
    (fun t => renews (x t)) n
  have start : x 0 + R (x 0) + r * n = s + R s + r * n :=
    congrArg (fun z => z + R z + r * n) opens.1
  ⟨fun most =>
    have parts := eq_of_add_eq_of_le (open_left_le_most renews opens n)
      (Nat.mul_le_mul_left (v - 1) bounded) ((valued_eq pos).symm.trans most)
    ⟨identity.mp (parts.1.trans start.symm),
     mul_left_cancel_of_pos (SupportGated.sub_pos_of_lt more) parts.2⟩,
   fun ⟨renewed, left⟩ => valued_of_most pos ((identity.mpr renewed).trans start) left⟩

/-- **The course regrowing at the end draws and leaves the most.** Where `R` gives at most `r` and
`r` at `y`, within the start with what is given there, over a horizon of at least two steps, with a
capacity covering what the first step draws down to `y` and `r`, the course holding `y` to the
`n`-th step, regrowing to `y` with `r` at the last and drawing nothing after it, is open, and draws
across `n + 1` steps, with `v` of at least one for each unit it leaves, the start with what is given
there, `r` for each step after and `v - 1` for each unit of `y` with `r`. -/
theorem regrowing_valued (renews : ∀ z, R z ≤ r) {v : Nat} (pos : 0 < v) (greatest : R y = r)
    (reach : y ≤ s + R s) (drawsDown : s + R s ≤ y + k) (middle : r ≤ k) (long : 0 < n) :
    OpenCourse R k s (continued R (holdingTo s y (y + r) n) n) ∧
      drawnOver R (continued R (holdingTo s y (y + r) n) n) (n + 1) +
        v * continued R (holdingTo s y (y + r) n) n (n + 1) =
          s + R s + r * n + (v - 1) * (y + r) :=
  have opens : OpenCourse R k s (continued R (holdingTo s y (y + r) n) n) :=
    continued_open (x := holdingTo s y (y + r) n) rfl
      (holdingTo_steps_of greatest reach (Nat.le_refl _) drawsDown middle (Nat.le_add_right _ k) long)
  have left : continued R (holdingTo s y (y + r) n) n (n + 1) = y + r :=
    (continued_le (Nat.le_refl _)).trans (holdingTo_after (Nat.le_refl n))
  have most := (most_left_iff (x := continued R (holdingTo s y (y + r) n) n)
    (g := fun t => R (continued R (holdingTo s y (y + r) n) n t)) (fun t => (opens.2 t).1)
    (fun _ => renews _) n).mpr fun _ lt =>
      (congrArg R ((continued_le (Nat.succ_le_succ (Nat.le_of_lt lt))).trans
        (holdingTo_before lt))).trans greatest
  ⟨opens, valued_of_most pos most left⟩

/-- **The course regrowing at the end is an optimum at every worth of at least one.** Under the
conditions of `regrowing_valued`, where no open course leaves after `n + 1` steps more than `y` with
`r`, the course holding `y` and regrowing at the last step is an optimum of the order by what is drawn
with `v` for each unit left. -/
theorem regrowing_frontier (renews : ∀ z, R z ≤ r) {v : Nat} (pos : 0 < v)
    (bounded : ∀ a, OpenCourse R k s a → a (n + 1) ≤ y + r) (greatest : R y = r)
    (reach : y ≤ s + R s) (drawsDown : s + R s ≤ y + k) (middle : r ≤ k) (long : 0 < n) :
    Frontier (OpenCourse R k s) (byDrawnLeftAt R v n) (continued R (holdingTo s y (y + r) n) n) :=
  have witness := regrowing_valued renews pos greatest reach drawsDown middle long
  ⟨witness.1, fun a opens more => Nat.not_le_of_gt more (Nat.le_trans
    (open_valued_le_most renews pos opens (bounded a opens)) (Nat.le_of_eq witness.2.symm))⟩

/-- **At a worth above one, every optimum holds a level of greatest renewal and leaves the most.**
Where `R` gives at most `r` at every level and `r` at some `y` within the start with what is given
there, over a horizon of at least two steps, with a capacity covering what the first step draws down
to `y` and `r`, and no open course leaves after `n + 1` steps more than `y` with `r`: every optimum
of every order on the open courses rising with what is drawn across them with `v` above one for each
unit left stands at a level of greatest renewal at every step from the first to the `n`-th and leaves
`y` with `r`, regrown at the last step. -/
theorem frontier_holds_valued {better : (Nat → Nat) → (Nat → Nat) → Prop}
    (renews : ∀ z, R z ≤ r) {v : Nat} (more : 1 < v)
    (rising : ∀ a b, drawnOver R a (n + 1) + v * a (n + 1) < drawnOver R b (n + 1) + v * b (n + 1) →
      better b a)
    (bounded : ∀ a, OpenCourse R k s a → a (n + 1) ≤ y + r) (greatest : R y = r)
    (reach : y ≤ s + R s) (drawsDown : s + R s ≤ y + k) (middle : r ≤ k) (long : 0 < n)
    {x : Nat → Nat} (front : Frontier (OpenCourse R k s) better x) :
    (∀ t, t < n → R (x (t + 1)) = r) ∧ x (n + 1) = y + r :=
  have pos : 0 < v := Nat.lt_trans (Nat.zero_lt_one) more
  have witness := regrowing_valued renews pos greatest reach drawsDown middle long
  (valued_most_iff renews more front.1 (bounded x front.1)).mp
    (Nat.le_antisymm (open_valued_le_most renews pos front.1 (bounded x front.1))
      (Nat.ge_of_not_lt fun less => front.2 _ witness.1
        (rising x _ (Nat.lt_of_lt_of_le less (Nat.le_of_eq witness.2.symm)))))

/-- **Exactly the optima at a worth above one.** Under the conditions of `frontier_holds_valued`, the
optima of the order by what is drawn with `v` above one for each unit left are exactly the open
courses standing at a level of greatest renewal at every step from the first to the `n`-th and
leaving `y` with `r`. -/
theorem frontier_valued_iff (renews : ∀ z, R z ≤ r) {v : Nat} (more : 1 < v)
    (bounded : ∀ a, OpenCourse R k s a → a (n + 1) ≤ y + r) (greatest : R y = r)
    (reach : y ≤ s + R s) (drawsDown : s + R s ≤ y + k) (middle : r ≤ k) (long : 0 < n)
    {x : Nat → Nat} :
    Frontier (OpenCourse R k s) (byDrawnLeftAt R v n) x ↔
      OpenCourse R k s x ∧ (∀ t, t < n → R (x (t + 1)) = r) ∧ x (n + 1) = y + r :=
  ⟨fun front => ⟨front.1, frontier_holds_valued renews more (fun _ _ less => less) bounded greatest
     reach drawsDown middle long front⟩,
   fun ⟨opens, held⟩ => ⟨opens, fun a opens' less => Nat.not_le_of_gt less (Nat.le_trans
     (open_valued_le_most renews (Nat.lt_trans (Nat.zero_lt_one) more) opens' (bounded a opens'))
     (Nat.le_of_eq ((valued_most_iff renews more opens (bounded x opens)).mpr held).symm))⟩⟩

/-- Comparing a keeping course's worth with the regrowing course's, at any worth. -/
theorem lt_of_valued_below {A D L S w q' r' u : Nat} (coupled : A ≤ D + L + u + w)
    (kept : D + L ≤ S + q') (left : u ≤ u') (below : w + q' < r') : A < S + r' + u' :=
  calc A ≤ D + L + u + w := coupled
    _ ≤ S + q' + u' + w := Nat.add_le_add_right (Nat.add_le_add kept left) w
    _ = S + u' + (w + q') := by
      rw [Nat.add_assoc S q' u', Nat.add_comm q' u', ← Nat.add_assoc, Nat.add_assoc, Nat.add_comm q' w]
    _ < S + u' + r' := Nat.add_lt_add_left below _
    _ = S + r' + u' := Nat.add_right_comm _ _ _

/-- **A value on what is left does not change what keeping forgoes.** Where `R` gives at most `r` at
every level, `r` at some `y` within the start with what is given there and at most `q` at every level
at or above `m`, over a horizon of at least two steps, with a capacity covering what the first step
draws down to `y` and `r`, and no open course leaves after `n + 1` steps more than `y` with `r`:
every optimum, among the open courses, of every order rising with a worth at least what a course
draws with `v` of at least one for each unit it leaves, and at most `w` more for a course keeping its
level at `m` or above, falls below `m` within the horizon, where `w + q n < r n`, whatever `v`: the
value on what is left is had by the course that draws down and regrows at the end. -/
theorem frontier_breaks_valued {better : (Nat → Nat) → (Nat → Nat) → Prop}
    {worth : (Nat → Nat) → Nat} {v w : Nat}
    (rising : ∀ a b, worth a < worth b → better b a) (pos : 0 < v)
    (values : ∀ a, drawnOver R a (n + 1) + v * a (n + 1) ≤ worth a)
    (coupled : ∀ a, OpenCourse R k s a → Keeps m n a →
      worth a ≤ drawnOver R a (n + 1) + v * a (n + 1) + w)
    (renews : ∀ z, R z ≤ r) (above : ∀ z, m ≤ z → R z ≤ q) (below : w + q * n < r * n)
    (bounded : ∀ a, OpenCourse R k s a → a (n + 1) ≤ y + r) (greatest : R y = r)
    (reach : y ≤ s + R s) (drawsDown : s + R s ≤ y + k) (middle : r ≤ k) (long : 0 < n)
    {x : Nat → Nat} (front : Frontier (OpenCourse R k s) better x) : ¬ Keeps m n x := fun keeps =>
  have witness := regrowing_valued renews pos greatest reach drawsDown middle long
  have kept : drawnOver R x (n + 1) + x (n + 1) ≤ s + R s + q * n :=
    Eq.subst (motive := fun z => drawnOver R x (n + 1) + x (n + 1) ≤ z + R z + q * n) front.1.1
      (keeping_le_most above (fun t => (front.1.2 t).1) keeps)
  front.2 _ witness.1 (rising x _ (Nat.lt_of_lt_of_le
    (lt_of_valued_below
      (Nat.le_trans (coupled x front.1 keeps) (Nat.le_of_eq (congrArg (· + w) (valued_eq pos))))
      kept (Nat.mul_le_mul_left (v - 1) (bounded x front.1)) below)
    (Nat.le_trans (Nat.le_of_eq witness.2.symm) (values _))))
'''
op = once(op, '''        (open_le_most renews opens n) most least beyond))⟩

end Optimum
''', '''        (open_le_most renews opens n) most least beyond))⟩
''' + VALUED + '''
end Optimum
''')

# 3. The web laws, after SG6's.
WEB = '''
/-- **At a worth above one, far-sight draws a dependence above every level of greatest renewal down at
the first step and rebuilds only at the end.** Under the conditions of
`Optimum.frontier_holds_valued`, where every level where `R` gives `r` lies below a formation's need
on the condition, met at the start: every optimum, among the open courses, of every order rising
with what is drawn across `n + 1` steps with `v` above one for each unit left breaks the dependence at
the first step, leaves it unmet at every step to the `n`-th and stands at `y` with `r` after the last,
regrown there. -/
theorem frontier_rebuilt_valued (renews : ∀ z, R z ≤ r) {v : Nat} (more : 1 < v)
    (rising : ∀ a b, drawnOver R a (n + 1) + v * a (n + 1) < drawnOver R b (n + 1) + v * b (n + 1) →
      better b a)
    (bounded : ∀ a, OpenCourse R k s a → a (n + 1) ≤ y + r) (greatest : R y = r)
    (reach : y ≤ s + R s) (drawsDown : s + R s ≤ y + k) (middle : r ≤ k) (long : 0 < n)
    (front : Frontier (OpenCourse R k s) better fun t => W.level t c)
    (above : ∀ z, R z = r → z < m) (depends : W.requires 0 f c) (need : W.need 0 f c = m)
    (start : m ≤ s) :
    W.Broken 0 f c ∧ (∀ t, t < n → W.level (t + 1) c < m) ∧ W.level (n + 1) c = y + r :=
  have held := Optimum.frontier_holds_valued renews more rising bounded greatest reach drawsDown
    middle long front
  have unmet : ∀ t, t < n → W.level (t + 1) c < m := fun t before => above _ (held.1 t before)
  ⟨⟨depends, Nat.le_trans (Nat.le_of_eq need) (Eq.subst (motive := fun z => m ≤ z) front.1.1.symm start),
    Nat.lt_of_lt_of_le (unmet 0 long) (Nat.le_of_eq need.symm)⟩, unmet, held.2⟩

/-- **A value on what is left breaks the dependence within the horizon as without it.** Under the
premises of `Optimum.frontier_breaks_valued`, with a formation depending on the condition at the need
`m` at every step, met at the start: every optimum, among the open courses, of every order rising
with a worth at least what a course draws with `v` of at least one for each unit left and at most `w`
more for a course keeping the condition at `m` or above breaks the dependence at some step to the
`n`-th, where `w + q n < r n`, whatever `v`. -/
theorem frontier_breaks_valued {v : Nat}
    (rising : ∀ a b, worth a < worth b → better b a) (pos : 0 < v)
    (values : ∀ a, drawnOver R a (n + 1) + v * a (n + 1) ≤ worth a)
    (coupled : ∀ a, OpenCourse R k s a → Optimum.Keeps m n a →
      worth a ≤ drawnOver R a (n + 1) + v * a (n + 1) + w)
    (renews : ∀ z, R z ≤ r) (above : ∀ z, m ≤ z → R z ≤ q) (below : w + q * n < r * n)
    (bounded : ∀ a, OpenCourse R k s a → a (n + 1) ≤ y + r) (greatest : R y = r)
    (reach : y ≤ s + R s) (drawsDown : s + R s ≤ y + k) (middle : r ≤ k) (long : 0 < n)
    (front : Frontier (OpenCourse R k s) better fun t => W.level t c)
    (depends : ∀ t, W.requires t f c) (need : ∀ t, W.need t f c = m) (start : m ≤ s) :
    ∃ t, t ≤ n ∧ W.Broken t f c :=
  match drops_of_not_keeps (Eq.subst (motive := fun z => m ≤ z) front.1.1.symm start)
      (Optimum.frontier_breaks_valued rising pos values coupled renews above below bounded greatest
        reach drawsDown middle long front) with
  | ⟨t, le, met, lt⟩ => ⟨t, le, depends t, Nat.le_trans (Nat.le_of_eq (need t)) met,
      Nat.lt_of_lt_of_le lt (Nat.le_of_eq (need t).symm)⟩
'''
op = once(op, '''    (Optimum.frontier_keeps_above rising coupled uncoupled renews beyond greatest meets ends reach
      settles drawsDown holds long front t le)
''', '''    (Optimum.frontier_keeps_above rising coupled uncoupled renews beyond greatest meets ends reach
      settles drawsDown holds long front t le)
''' + WEB)

# 4. The logistic witness, after logistic_coupled.
INST = '''
/-- Under the logistic law a level at most two with what is given there is at most two. -/
theorem logistic_within : ∀ z, z ≤ 2 → z + logistic z ≤ 2
  | 0, _ => Nat.zero_le 2
  | 1, _ => Nat.le_refl 2
  | 2, _ => Nat.le_refl 2
  | z + 3, le => absurd le (Nat.not_le_of_gt (Nat.lt_of_lt_of_le (Nat.lt_succ_self 2)
      (Nat.le_add_left 3 z)))

/-- Every course open from two under the logistic law stands at two or below. -/
theorem logistic_open_le {k : Nat} {x : Nat → Nat} (opens : OpenCourse logistic k 2 x) :
    ∀ t, x t ≤ 2
  | 0 => Nat.le_of_eq opens.1
  | t + 1 => Nat.le_trans (opens.2 t).1 (logistic_within _ (logistic_open_le opens t))

/-- **The logistic witness at any worth: drawn down, and regrown at the end.** From a source at two,
the level the dweller needs, under the logistic law with capacity two: at every worth `v` of at least
one for each unit the source is left with after `n + 2` steps, the course holding the source at one
through the horizon and regrowing it to two at the last step, drawing nothing after, is an optimum of
the order by what the taker draws with `v` for each unit left (`regrowing_frontier`); at every worth
above one, the optima of that order are exactly the open courses standing at one through the horizon
and at two after it (`frontier_valued_iff`), and every optimum of that order breaks the dweller at the first step, leaves it unmet through
the horizon and stands at two, the dweller's need, after its last step
(`Web.frontier_rebuilt_valued`); and with a coupling `w` of the dweller below `n + 1`, every optimum
of the order by what the taker draws with `w` where the dweller stays met and `v` for each unit left
breaks the dweller within the horizon, whatever `v` (`Web.frontier_breaks_valued`). -/
theorem logistic_valued (n v w : Nat) (pos : 0 < v) :
    Frontier (OpenCourse logistic 2 2) (byDrawnLeftAt logistic v (n + 1))
        (continued logistic (holdingTo 2 1 2 (n + 1)) (n + 1)) ∧
      (1 < v → ∀ x, (Frontier (OpenCourse logistic 2 2) (byDrawnLeftAt logistic v (n + 1)) x ↔
        OpenCourse logistic 2 2 x ∧ (∀ t, t < n + 1 → logistic (x (t + 1)) = 1) ∧
          x (n + 1 + 1) = 1 + 1)) ∧
      (1 < v → ∀ x, Frontier (OpenCourse logistic 2 2) (byDrawnLeftAt logistic v (n + 1)) x →
        (web (onSource x)).Broken 0 .dweller .source ∧
        (∀ t, t < n + 1 → (web (onSource x)).level (t + 1) .source < 2) ∧
        (web (onSource x)).level (n + 1 + 1) .source = 2) ∧
      (w < n + 1 → ∀ x, Frontier (OpenCourse logistic 2 2)
        (fun b a => coupledDraw logistic 2 w (n + 1) a + v * a (n + 1 + 1) <
          coupledDraw logistic 2 w (n + 1) b + v * b (n + 1 + 1)) x →
        ∃ t, t ≤ n + 1 ∧ (web (onSource x)).Broken t .dweller .source) :=
  have bounded : ∀ a, OpenCourse logistic 2 2 a → a (n + 1 + 1) ≤ 1 + 1 :=
    fun _ opens => logistic_open_le opens _
  ⟨regrowing_frontier (R := logistic) (k := 2) (s := 2) (y := 1) (r := 1) (n := n + 1) logistic_le
      pos bounded rfl (Nat.le_succ 1) (Nat.le_succ 2) (Nat.le_succ 1) (Nat.succ_pos n),
   fun more _ => frontier_valued_iff (R := logistic) (k := 2) (s := 2) (y := 1) (r := 1) (n := n + 1)
     logistic_le more bounded rfl (Nat.le_succ 1) (Nat.le_succ 2) (Nat.le_succ 1) (Nat.succ_pos n),
   fun more x front => Web.frontier_rebuilt_valued (W := web (onSource x)) (c := Place.source)
     (f := Formation.dweller) (R := logistic) (k := 2) (s := 2) (y := 1) (r := 1) (m := 2)
     (n := n + 1) logistic_le more (fun _ _ less => less) bounded rfl (Nat.le_succ 1)
     (Nat.le_succ 2) (Nat.le_succ 1) (Nat.succ_pos n) front logistic_greatest trivial rfl
     (Nat.le_refl 2),
   fun short x front =>
    have below : w + 0 * (n + 1) < 1 * (n + 1) := by
      rw [Nat.zero_mul, Nat.one_mul, Nat.add_zero]; exact short
    Web.frontier_breaks_valued (W := web (onSource x)) (c := Place.source)
      (f := Formation.dweller) (R := logistic) (k := 2) (s := 2) (y := 1) (r := 1) (q := 0)
      (m := 2) (n := n + 1) (w := w)
      (worth := fun a => coupledDraw logistic 2 w (n + 1) a + v * a (n + 1 + 1))
      (fun _ _ less => less) pos
      (fun _ => Nat.add_le_add_right (Nat.le_add_right _ _) _)
      (fun _ _ keeps => Nat.le_of_eq (by
        show coupledDraw logistic 2 w (n + 1) _ + _ = _
        rw [coupledDraw_of_keeps keeps, Nat.add_right_comm]))
      logistic_le logistic_above below bounded rfl (Nat.le_succ 1) (Nat.le_succ 2) (Nat.le_succ 1)
      (Nat.succ_pos n) front (fun _ => trivial) (fun _ => rfl) (Nat.le_refl 2)⟩
'''
op = once(op, '''        (Nat.le_add_right 2 2) (Nat.succ_pos n) front (fun _ => rfl)⟩⟩

end Holding
''', '''        (Nat.le_add_right 2 2) (Nat.succ_pos n) front (fun _ => rfl)⟩⟩
''' + INST + '''
end Holding
''')
if (HERE / 'optimum_doc.py').exists():
    exec((HERE / 'optimum_doc.py').read_text(encoding='utf-8'))
out = HERE / 'tree' / 'Becoming' / 'Optimum.lean'
out.parent.mkdir(parents=True, exist_ok=True)
out.write_text(op, encoding='utf-8')
print('wrote', out.name, len(op.splitlines()), 'lines')
