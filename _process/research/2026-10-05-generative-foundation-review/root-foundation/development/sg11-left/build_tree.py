#!/usr/bin/env python3
"""Build SG11's tree: Optimum with an order valuing what is left at the horizon as much as what is drawn.
usage: python3 -B build_tree.py   (SG11_ROOT names the checkout to read; SG11_BASE, a git ref of it, reads it at that ref).
Writes tree/Becoming/Optimum.lean."""
import os
import subprocess
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = Path(os.environ['SG11_ROOT']).resolve() if os.environ.get('SG11_ROOT') else HERE.parents[5]
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'


def once(text, old, new):
    assert text.count(old) == 1, ('edit does not match once', old[:90], text.count(old))
    return text.replace(old, new)


def read(name):
    if os.environ.get('SG11_BASE'):
        rel = (PKG / 'Becoming' / f'{name}.lean').relative_to(ROOT)
        return subprocess.run(['git', '-C', str(ROOT), 'show', f"{os.environ['SG11_BASE']}:{rel}"], check=True,
                              capture_output=True, text=True).stdout
    return (PKG / 'Becoming' / f'{name}.lean').read_text(encoding='utf-8')


op = read('Optimum')
assert 'byDrawnLeft' not in op, 'already built'
HORIZON = '''
/-- **What a course draws and leaves, at most.** Where each step leaves at most the level with what
is given and at most `r` is given at each step, what a course draws across `n + 1` steps with what
stands after them is at most the starting level with what is given at the first step and `r` for each
step after. -/
theorem drawn_add_left_le_most (within : ∀ t, x (t + 1) ≤ x t + g t) (renews : ∀ t, g t ≤ r)
    (n : Nat) :
    Amounts.whole.sum (drawnAt x g) 0 (n + 1) + x (n + 1) ≤ x 0 + g 0 + r * n :=
  Nat.le_trans (Nat.le_add_right _ _) (Nat.le_of_eq (drawn_add_shortfall_after within renews n))

/-- **Exactly which courses draw and leave the most.** Where each step leaves at most the level with
what is given and at most `r` is given at each step, what a course draws across `n + 1` steps with
what stands after them is the starting level with what is given at the first step and `r` for each
step after exactly where `r` is given at every step after the first, whatever stands after the last. -/
theorem most_left_iff (within : ∀ t, x (t + 1) ≤ x t + g t) (renews : ∀ t, g t ≤ r) (n : Nat) :
    Amounts.whole.sum (drawnAt x g) 0 (n + 1) + x (n + 1) = x 0 + g 0 + r * n ↔
      ∀ t, t < n → g (t + 1) = r :=
  have whole := drawn_add_shortfall_after within renews n
  ⟨fun most =>
    have none : Amounts.whole.sum (fun t => r - g (t + 1)) 0 n = 0 :=
      add_left_cancel_of (whole.trans (most.symm.trans (Nat.add_zero _).symm))
    fun t lt => Nat.le_antisymm (renews (t + 1)) (le_of_sub_zero (sum_eq_zero_iff.mp none t lt)),
   fun renewed => by
    have none : Amounts.whole.sum (fun t => r - g (t + 1)) 0 n = 0 :=
      sum_eq_zero_iff.mpr fun t lt => (congrArg (r - ·) (renewed t lt)).trans (Nat.sub_self r)
    rw [none] at whole
    exact whole⟩

end Horizon
'''
op = once(op, '''    rw [left, none] at whole
    exact whole⟩

end Horizon
''', '''    rw [left, none] at whole
    exact whole⟩
''' + HORIZON)
LEFT = '''
/-! ### Valuing what is left at the horizon -/

/-- The order of courses by what they draw across `n + 1` steps with what they leave after them,
valued alike: more is better. -/
def byDrawnLeft (R : Nat → Nat) (n : Nat) (b a : Nat → Nat) : Prop :=
  drawnOver R a (n + 1) + a (n + 1) < drawnOver R b (n + 1) + b (n + 1)

/-- No open course draws and leaves across `n + 1` steps more than the start with what is given there
and `r` for each step after, where `R` gives at most `r`. -/
theorem open_left_le_most (renews : ∀ z, R z ≤ r) {x : Nat → Nat} (opens : OpenCourse R k s x)
    (n : Nat) : drawnOver R x (n + 1) + x (n + 1) ≤ s + R s + r * n :=
  Eq.subst (motive := fun z => drawnOver R x (n + 1) + x (n + 1) ≤ z + R z + r * n) opens.1
    (drawn_add_left_le_most (fun t => (opens.2 t).1) (fun t => renews (x t)) n)

/-- The course holding `y` and leaving it stands at `y` at every step after its start. -/
theorem holdingTo_same (t : Nat) : holdingTo s y y n (t + 1) = y :=
  match Nat.lt_or_ge t n with
  | .inl before => holdingTo_before before
  | .inr after => holdingTo_after after

/-- **A course holding a level of greatest renewal and leaving it draws and leaves the most.** Where
`R` gives at most `r` at every level and `r` at `y`, within the start with what is given there, the
course holding `y` and leaving it draws across `n + 1` steps, with what it leaves after them, the
start with what is given there and `r` for each step after. -/
theorem keeping_left_most (renews : ∀ z, R z ≤ r) (greatest : R y = r) (reach : y ≤ s + R s)
    (n : Nat) :
    drawnOver R (holdingTo s y y n) (n + 1) + holdingTo s y y n (n + 1) = s + R s + r * n :=
  (most_left_iff (x := holdingTo s y y n) (g := fun t => R (holdingTo s y y n t))
    (holdingTo_within reach (Nat.le_refl y)) (fun _ => renews _) n).mpr
    fun t _ => (congrArg R (holdingTo_same t)).trans greatest

/-- **The course holding a level of greatest renewal and leaving it is open**, over any horizon, with
a capacity covering what the first step draws down to it and `r`: after the first step it draws only
what is given. -/
theorem keeping_open (greatest : R y = r) (reach : y ≤ s + R s) (drawsDown : s + R s ≤ y + k)
    (holds : r ≤ k) : OpenCourse R k s (holdingTo s y y n) :=
  ⟨rfl, fun t => ⟨holdingTo_within reach (Nat.le_refl y) t, match t with
    | 0 => drawnAt_le_of (Nat.le_trans drawsDown
        (Nat.le_of_eq (congrArg (· + k) (holdingTo_same 0).symm)))
    | j + 1 => drawnAt_le_of (by
        show holdingTo s y y n (j + 1) + R (holdingTo s y y n (j + 1)) ≤
          holdingTo s y y n (j + 1 + 1) + k
        rw [holdingTo_same j, holdingTo_same (j + 1), greatest]
        exact Nat.add_le_add_left holds y)⟩⟩

/-- **Keeping is an optimum when what is left is valued.** The course holding a level of greatest
renewal and leaving it is an optimum of the order by what is drawn and left alike. -/
theorem keeping_frontier_left (renews : ∀ z, R z ≤ r) (greatest : R y = r) (reach : y ≤ s + R s)
    (drawsDown : s + R s ≤ y + k) (holds : r ≤ k) :
    Frontier (OpenCourse R k s) (byDrawnLeft R n) (holdingTo s y y n) :=
  ⟨keeping_open greatest reach drawsDown holds, fun _ opens more =>
    Nat.not_le_of_gt more (Nat.le_trans (open_left_le_most renews opens n)
      (Nat.le_of_eq (keeping_left_most renews greatest reach n).symm))⟩

/-- **Draining at the end is an optimum too.** The course holding a level of greatest renewal and
leaving nothing is an optimum of the order by what is drawn and left alike: valuing what is left as
much as what is drawn makes the last step's draw indifferent. -/
theorem holding_frontier_left (renews : ∀ z, R z ≤ r) (greatest : R y = r) (reach : y ≤ s + R s)
    (drawsDown : s + R s ≤ y + k) (holds : y + r ≤ k) (long : 0 < n) :
    Frontier (OpenCourse R k s) (byDrawnLeft R n) (holding s y n) :=
  ⟨holding_open renews greatest reach drawsDown holds long, fun _ opens more =>
    Nat.not_le_of_gt more (Nat.le_trans (open_left_le_most renews opens n)
      (Nat.le_of_eq ((congr (congrArg HAdd.hAdd (holding_most renews greatest reach n))
        (holding_after (Nat.le_refl n))).trans (Nat.add_zero _)).symm))⟩

/-- **Without valuing what is left, keeping is no optimum.** Where a level of greatest renewal is
positive, the course holding it and leaving it is not an optimum of the order by what is drawn alone,
whose every optimum leaves nothing (`frontier_holds`). -/
theorem keeping_not_frontier (renews : ∀ z, R z ≤ r) (greatest : R y = r) (reach : y ≤ s + R s)
    (drawsDown : s + R s ≤ y + k) (holds : y + r ≤ k) (long : 0 < n) (positive : 0 < y) :
    ¬ Frontier (OpenCourse R k s) (byDrawn R n) (holdingTo s y y n) := fun front =>
  Nat.lt_irrefl 0 (Eq.subst (motive := fun z => 0 < z)
    ((holdingTo_after (Nat.le_refl n)).symm.trans
      (frontier_holds renews (fun _ _ more => more) greatest reach drawsDown holds long front).1)
    positive)

/-- **Every optimum valuing what is left holds a level of greatest renewal to the horizon.** Where `R`
gives at most `r` at every level and `r` at some `y` within the start with what is given there, over
any horizon, with a capacity covering what the first step draws down to `y` and `r`, every optimum of every order on the courses open from the start that rises with what is
drawn across `n + 1` steps and what is left after them, valued alike, stands at a level of greatest
renewal at every step from the first to the `n`-th; what it leaves is not fixed. -/
theorem frontier_holds_left {better : (Nat → Nat) → (Nat → Nat) → Prop}
    (renews : ∀ z, R z ≤ r)
    (rising : ∀ a b, drawnOver R a (n + 1) + a (n + 1) < drawnOver R b (n + 1) + b (n + 1) →
      better b a)
    (greatest : R y = r) (reach : y ≤ s + R s) (drawsDown : s + R s ≤ y + k)
    (holds : r ≤ k) {x : Nat → Nat}
    (front : Frontier (OpenCourse R k s) better x) : ∀ t, t < n → R (x (t + 1)) = r :=
  have most : drawnOver R x (n + 1) + x (n + 1) = s + R s + r * n :=
    Nat.le_antisymm (open_left_le_most renews front.1 n)
      (match Nat.lt_or_ge (drawnOver R x (n + 1) + x (n + 1)) (s + R s + r * n) with
      | .inl less => absurd (rising x (holdingTo s y y n) (Nat.lt_of_lt_of_le less
          (Nat.le_of_eq (keeping_left_most renews greatest reach n).symm)))
          (front.2 _ (keeping_open greatest reach drawsDown holds))
      | .inr ge => ge)
  (most_left_iff (fun t => (front.1.2 t).1) (fun t => renews (x t)) n).mp
    (Eq.subst (motive := fun z => drawnOver R x (n + 1) + x (n + 1) = z + R z + r * n)
      front.1.1.symm most)

/-- **Exactly the optima valuing what is left.** Under the same conditions, the optima of the order by
what is drawn and left alike are exactly the open courses standing at a level of greatest renewal at
every step from the first to the `n`-th. -/
theorem frontier_left_iff (renews : ∀ z, R z ≤ r) (greatest : R y = r) (reach : y ≤ s + R s)
    (drawsDown : s + R s ≤ y + k) (holds : r ≤ k) {x : Nat → Nat} :
    Frontier (OpenCourse R k s) (byDrawnLeft R n) x ↔
      OpenCourse R k s x ∧ ∀ t, t < n → R (x (t + 1)) = r :=
  ⟨fun front => ⟨front.1,
     frontier_holds_left renews (fun _ _ more => more) greatest reach drawsDown holds front⟩,
   fun ⟨opens, renewed⟩ => ⟨opens, fun _ opens' more => Nat.not_le_of_gt more
     (Nat.le_trans (open_left_le_most renews opens' n) (Nat.le_of_eq
       (Eq.subst (motive := fun z => drawnOver R x (n + 1) + x (n + 1) = z + R z + r * n) opens.1
         ((most_left_iff (fun t => (opens.2 t).1) (fun t => renews (x t)) n).mpr renewed)).symm))⟩⟩
'''
op = once(op, '''  (most_iff (fun t => (front.1.2 t).1) (fun t => renews (x t)) n).mp
    (Eq.subst (motive := fun z => drawnOver R x (n + 1) = z + R z + r * n) front.1.1.symm most)

end Optimum
''', '''  (most_iff (fun t => (front.1.2 t).1) (fun t => renews (x t)) n).mp
    (Eq.subst (motive := fun z => drawnOver R x (n + 1) = z + R z + r * n) front.1.1.symm most)
''' + LEFT + '''
end Optimum
''')
WEB = '''
/-- **Valuing what is left, far-sight keeps a dependence every level of greatest renewal meets through
the horizon.** Where what is given to a condition is a law `R` of its level, at most `r` at every level
and `r` at some `y` within the start `s` with what is given there, with a capacity covering what the
first step draws down to `y` and `r`, over any horizon, and every level where `R` gives `r` meets a
need `m` met at the start: under every optimum, among the courses open from the start, of every order
rising with what is drawn across `n + 1` steps and what is left after them, valued alike, the
condition stands at `m` or above at every step to the `n`-th. The course standing at `y` at every step
after the start is such an optimum (`Optimum.keeping_frontier_left`, `Optimum.holdingTo_same`),
keeping the need met past the horizon, where under the order by what is drawn alone every optimum
leaves nothing at the last step (`frontier_kept`; witness `Optimum.Holding.gated_left`). -/
theorem frontier_kept_left {s : Nat} (renews : ∀ z, R z ≤ r)
    (rising : ∀ a b, drawnOver R a (n + 1) + a (n + 1) < drawnOver R b (n + 1) + b (n + 1) →
      better b a)
    (greatest : R y = r) (reach : y ≤ s + R s) (drawsDown : s + R s ≤ y + k) (holds : r ≤ k)
    (front : Frontier (OpenCourse R k s) better fun t => W.level t c)
    (meets : ∀ z, R z = r → m ≤ z) (start : m ≤ s) :
    ∀ t, t ≤ n → m ≤ W.level t c := fun t le => match t, le with
  | 0, _ => Eq.subst (motive := fun z => m ≤ z) front.1.1.symm start
  | t + 1, le => meets _ (frontier_holds_left renews rising greatest reach drawsDown holds front t
      (Nat.lt_of_succ_le le))

/-- **Valuing what is left does not reach a dependence above every level of greatest renewal.** Where
what is given to a condition is a law `R` of its level, at most `r` at every level and `r` at some `y`
within the start `s` with what is given there, over a horizon of at least two steps, with a capacity
covering what the first step draws down to `y` and `r`, and every level where `R` gives `r` lies below
a formation's need on the condition, met at the start: every optimum, among the courses open from the
start, of every order rising with what is drawn and what is left alike breaks the dependence at the
first step and leaves it unmet to the `n`-th (witness `Optimum.Holding.logistic_left`). -/
theorem frontier_broken_left {s : Nat} (renews : ∀ z, R z ≤ r)
    (rising : ∀ a b, drawnOver R a (n + 1) + a (n + 1) < drawnOver R b (n + 1) + b (n + 1) →
      better b a)
    (greatest : R y = r) (reach : y ≤ s + R s) (drawsDown : s + R s ≤ y + k) (holds : r ≤ k)
    (long : 0 < n) (front : Frontier (OpenCourse R k s) better fun t => W.level t c)
    (above : ∀ z, R z = r → z < m) (depends : W.requires 0 f c) (need : W.need 0 f c = m)
    (start : m ≤ s) :
    W.Broken 0 f c ∧ ∀ t, t < n → W.level (t + 1) c < m :=
  have unmet : ∀ t, t < n → W.level (t + 1) c < m := fun t before =>
    above _ (frontier_holds_left renews rising greatest reach drawsDown holds front t before)
  ⟨⟨depends, Nat.le_trans (Nat.le_of_eq need) (Eq.subst (motive := fun z => m ≤ z) front.1.1.symm start),
    Nat.lt_of_lt_of_le (unmet 0 long) (Nat.le_of_eq need.symm)⟩, unmet⟩
'''
op = once(op, '''  ⟨stands, depends, Nat.le_trans (Nat.le_of_eq need) (stands n (Nat.le_refl n)),
    Nat.lt_of_le_of_lt (Nat.le_of_eq held.1) (Nat.lt_of_lt_of_le needs (Nat.le_of_eq need.symm))⟩
''', '''  ⟨stands, depends, Nat.le_trans (Nat.le_of_eq need) (stands n (Nat.le_refl n)),
    Nat.lt_of_le_of_lt (Nat.le_of_eq held.1) (Nat.lt_of_lt_of_le needs (Nat.le_of_eq need.symm))⟩
''' + WEB)

INSTANCES = '''/-- **The gate witness: valuing what is left keeps the dweller past the horizon.** From a source at
two, the level the dweller needs, under a gate renewing one unit at every level from one, with
capacity three: the course holding the source at two through the horizon and after it is an optimum
of the order by what the taker draws across `n + 2` steps and leaves after them, and keeps the
dweller's need met at every step; the course drawing the source to nothing at the last step is an
optimum of that order too; the optima of that order are exactly the open courses standing where the
gate renews at every step to the horizon; and the course keeping the dweller is no optimum of the
order by what is drawn alone (`keeping_not_frontier`), whose every optimum leaves nothing at the last
step (`frontier_holds`). -/
theorem gated_left (n : Nat) :
    Frontier (OpenCourse gate 3 2) (byDrawnLeft gate (n + 1)) (holdingTo 2 2 2 (n + 1)) ∧
      (∀ t, (web (onSource (holdingTo 2 2 2 (n + 1)))).need t .dweller .source ≤
        (web (onSource (holdingTo 2 2 2 (n + 1)))).level t .source) ∧
      Frontier (OpenCourse gate 3 2) (byDrawnLeft gate (n + 1)) (holding 2 2 (n + 1)) ∧
      (∀ x, Frontier (OpenCourse gate 3 2) (byDrawnLeft gate (n + 1)) x ↔
        OpenCourse gate 3 2 x ∧ ∀ t, t < n + 1 → gate (x (t + 1)) = 1) ∧
      ¬ Frontier (OpenCourse gate 3 2) (byDrawn gate (n + 1)) (holdingTo 2 2 2 (n + 1)) :=
  ⟨keeping_frontier_left gate_le rfl (Nat.le_succ 2) (Nat.le_add_left 3 2) (Nat.le_add_left 1 2),
   fun t => match t with
    | 0 => Nat.le_refl 2
    | t + 1 => Nat.le_of_eq (holdingTo_same (s := 2) (y := 2) (n := n + 1) t).symm,
   holding_frontier_left gate_le rfl (Nat.le_succ 2) (Nat.le_add_left 3 2) (Nat.le_refl 3)
     (Nat.succ_pos n),
   fun _ => frontier_left_iff gate_le rfl (Nat.le_succ 2) (Nat.le_add_left 3 2) (Nat.le_add_left 1 2),
   keeping_not_frontier gate_le rfl (Nat.le_succ 2) (Nat.le_add_left 3 2) (Nat.le_refl 3)
     (Nat.succ_pos n) (Nat.succ_pos 1)⟩

/-- **The logistic witness: valuing what is left does not keep the dweller.** From a source at two,
the level the dweller needs, under the logistic law with capacity two, the course holding the source
at one through the horizon and after it is an optimum of the order by what the taker draws across
`n + 2` steps and leaves after them, and every optimum of that order breaks the dweller's dependence
at the first step and leaves it unmet to the horizon (`Web.frontier_broken_left`). -/
theorem logistic_left (n : Nat) :
    Frontier (OpenCourse logistic 2 2) (byDrawnLeft logistic (n + 1)) (holdingTo 2 1 1 (n + 1)) ∧
      ∀ x, Frontier (OpenCourse logistic 2 2) (byDrawnLeft logistic (n + 1)) x →
        (web (onSource x)).Broken 0 .dweller .source ∧
        ∀ t, t < n + 1 → (web (onSource x)).level (t + 1) .source < 2 :=
  ⟨keeping_frontier_left logistic_le rfl (Nat.le_succ 1) (Nat.le_succ 2) (Nat.le_succ 1),
   fun x front => Web.frontier_broken_left (W := web (onSource x)) (c := Place.source)
     (f := Formation.dweller) (y := 1) (s := 2) logistic_le (fun _ _ more => more) rfl
     (Nat.le_succ 1) (Nat.le_succ 2) (Nat.le_succ 1) (Nat.succ_pos n) front logistic_greatest trivial
     rfl (Nat.le_refl 2)⟩

'''
op = once(op, '''/-- **The logistic witness: what keeping the dweller forgoes.**''', INSTANCES + '''/-- **The logistic witness: what keeping the dweller forgoes.**''')
if (HERE / 'optimum_doc.py').exists():
    exec((HERE / 'optimum_doc.py').read_text(encoding='utf-8'))
out = HERE / 'tree' / 'Becoming' / 'Optimum.lean'
out.parent.mkdir(parents=True, exist_ok=True)
out.write_text(op, encoding='utf-8')
print('wrote', out.name, len(op.splitlines()), 'lines')
