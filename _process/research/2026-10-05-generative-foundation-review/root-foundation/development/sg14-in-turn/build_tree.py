#!/usr/bin/env python3
"""Build SG14's tree: Optimum with two drawers in turn, each ranking courses.
usage: python3 -B build_tree.py   (SG14_ROOT names the checkout to read; SG14_BASE, a git ref of it, reads it at that ref).
Writes tree/Becoming/Optimum.lean."""
import os
import subprocess
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = Path(os.environ['SG14_ROOT']).resolve() if os.environ.get('SG14_ROOT') else HERE.parents[5]
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'


def once(text, old, new):
    assert text.count(old) == 1, ('edit does not match once', old[:90], text.count(old))
    return text.replace(old, new)


def read(name):
    if os.environ.get('SG14_BASE'):
        rel = (PKG / 'Becoming' / f'{name}.lean').relative_to(ROOT)
        return subprocess.run(['git', '-C', str(ROOT), 'show', f"{os.environ['SG14_BASE']}:{rel}"], check=True,
                              capture_output=True, text=True).stdout
    return (PKG / 'Becoming' / f'{name}.lean').read_text(encoding='utf-8')


op = read('Optimum')
assert 'namespace InTurn' not in op, 'already built'
SECTION = '''
/-! ## Drawers in turn, each ranking courses

Above, others drawing first were supplied as a rule reading the level. Here two drawers both rank
courses. At each step the first leaves `first t z` of the level `z`, the second leaves `second t a`
of what the first left, and what the second leaves stands at the next step as `G t` of it. Each
ranks what it draws over the steps that remain. A profile is perfect over a horizon where each
leaves at most what it is given and the two are at a mutual best response at every step from every
level, over the steps that remain. Every perfect profile has both leave nothing at every step:
whatever one leaves, the other draws at its next move, so the base stands from the first step at
what stands at nothing, and where nothing stands at nothing it ends at once; drawing everything is
such a profile. No capacity limits a draw. -/

namespace Optimum

namespace InTurn

variable {G : Nat → Nat → Nat} {first second : Nat → Nat → Nat}

/-- What stands at the step after `t` from the level `z`: what the second leaves of what the first
leaves, as it stands. -/
def next (G : Nat → Nat → Nat) (first second : Nat → Nat → Nat) (t z : Nat) : Nat :=
  G t (second t (first t z))

/-- What the first drawer draws over `j` steps from step `t` at level `z`. -/
def firstDrawn (G : Nat → Nat → Nat) (first second : Nat → Nat → Nat) : Nat → Nat → Nat → Nat
  | 0, _, _ => 0
  | j + 1, t, z => (z - first t z) + firstDrawn G first second j (t + 1) (next G first second t z)

/-- What the second drawer draws over `j` steps from step `t` at level `z`. -/
def secondDrawn (G : Nat → Nat → Nat) (first second : Nat → Nat → Nat) : Nat → Nat → Nat → Nat
  | 0, _, _ => 0
  | j + 1, t, z => (first t z - second t (first t z)) +
      secondDrawn G first second j (t + 1) (next G first second t z)

/-- **A mutual best response at a step, over the steps that remain.** With `j` steps after step `t`:
of whatever the first leaves, the second leaves what draws it the most over the rest, and from every
level the first leaves what draws it the most, the second responding by its rule. -/
def BestAt (G : Nat → Nat → Nat) (first second : Nat → Nat → Nat) (j t : Nat) : Prop :=
  (∀ a b, b ≤ a → a - b + secondDrawn G first second j (t + 1) (G t b) ≤
      a - second t a + secondDrawn G first second j (t + 1) (G t (second t a))) ∧
  ∀ z a, a ≤ z → z - a + firstDrawn G first second j (t + 1) (G t (second t a)) ≤
      firstDrawn G first second (j + 1) t z

/-- **Perfect over a horizon.** Each leaves at most what it is given, and over a horizon of `N`
steps the two are at a mutual best response at every step, from every level. -/
def Perfect (G : Nat → Nat → Nat) (first second : Nat → Nat → Nat) (N : Nat) : Prop :=
  (∀ t z, first t z ≤ z) ∧ (∀ t a, second t a ≤ a) ∧
    ∀ t j, t + j + 1 = N → BestAt G first second j t

/-- The levels along a profile from `s`. -/
def levels (G : Nat → Nat → Nat) (first second : Nat → Nat → Nat) (s : Nat) : Nat → Nat
  | 0 => s
  | t + 1 => next G first second t (levels G first second s t)

/-- What leaves no less than the whole when taken from it is nothing. -/
theorem zero_of_le_sub {z f : Nat} (le : f ≤ z) (ge : z ≤ z - f) : f = 0 :=
  match f, le, ge with
  | 0, _, _ => rfl
  | f + 1, le, ge => absurd (Nat.le_trans (Nat.add_le_add_right ge (f + 1))
      (Nat.le_of_eq (Naturals.sub_add_cancel le))) (Nat.not_le_of_gt
        (Nat.lt_of_lt_of_le (Nat.lt_succ_self z) (Nat.add_le_add_left (Nat.succ_le_succ (Nat.zero_le f)) z)))

/-- **One step back from the horizon.** Where each leaves at most what it is given and the second
draws nothing over the `j` steps after step `t` from any level, a mutual best response at `t` has
both leave nothing there, and the second draws nothing over the `j + 1` steps from `t`: whatever the
first leaves the second draws, and whatever the second leaves the first draws at its next move. -/
theorem step_ends (leaves₁ : ∀ t z, first t z ≤ z) (leaves₂ : ∀ t a, second t a ≤ a) {j t : Nat}
    (none : ∀ w, secondDrawn G first second j (t + 1) w = 0) (best : BestAt G first second j t) :
    (∀ z, first t z = 0) ∧ (∀ a, second t a = 0) ∧ ∀ z, secondDrawn G first second (j + 1) t z = 0 :=
  have sec : ∀ a, second t a = 0 := fun a =>
    have lhs : a - 0 + secondDrawn G first second j (t + 1) (G t 0) = a := by
      rw [none, Nat.sub_zero, Nat.add_zero]
    have rhs : a - second t a + secondDrawn G first second j (t + 1) (G t (second t a)) =
        a - second t a := by rw [none, Nat.add_zero]
    zero_of_le_sub (leaves₂ t a) (Nat.le_trans (Nat.le_of_eq lhs.symm)
      (Nat.le_trans (best.1 a 0 (Nat.zero_le a)) (Nat.le_of_eq rhs)))
  have fst : ∀ z, first t z = 0 := fun z =>
    have same : firstDrawn G first second (j + 1) t z =
        z - first t z + firstDrawn G first second j (t + 1) (G t (second t 0)) := by
      show z - first t z + firstDrawn G first second j (t + 1) (G t (second t (first t z))) = _
      rw [sec (first t z), sec 0]
    zero_of_le_sub (leaves₁ t z) (Naturals.le_of_add_le_add_right
      (Nat.le_trans (Nat.le_of_eq (congrArg (· + _) (Nat.sub_zero z).symm))
        (Nat.le_trans (best.2 z 0 (Nat.zero_le z)) (Nat.le_of_eq same))))
  ⟨fst, sec, fun z => by
    show first t z - second t (first t z) +
      secondDrawn G first second j (t + 1) (next G first second t z) = 0
    rw [fst z, sec 0, none]⟩

/-- **Backward from the horizon, both leave nothing.** Along a profile perfect over `N` steps, at
every step with `j` steps after it both leave nothing from every level, and the second draws nothing
over the `j + 1` steps. -/
theorem ends_at {N : Nat} (perfect : Perfect G first second N) :
    ∀ j t, t + j + 1 = N → (∀ z, first t z = 0) ∧ (∀ a, second t a = 0) ∧
      ∀ z, secondDrawn G first second (j + 1) t z = 0
  | 0, t, at_ => step_ends perfect.1 perfect.2.1 (fun _ => rfl) (perfect.2.2 t 0 at_)
  | j + 1, t, at_ =>
    have later := ends_at perfect j (t + 1)
      ((congrArg (· + 1) ((Nat.add_assoc t 1 j).trans (congrArg (t + ·) (Nat.add_comm 1 j)))).trans at_)
    step_ends perfect.1 perfect.2.1 later.2.2 (perfect.2.2 t (j + 1) at_)

/-- **Every perfect profile draws everything.** Along every profile perfect over `N` steps both
drawers leave nothing at every step before the horizon, from every level, whatever stands at
nothing. -/
theorem perfect_ends {N : Nat} (perfect : Perfect G first second N) {t : Nat} (before : t < N) :
    (∀ z, first t z = 0) ∧ ∀ a, second t a = 0 :=
  match le_dest before with
  | ⟨j, split⟩ =>
    have at_ := ends_at perfect j t ((Nat.add_right_comm t j 1).trans split.symm)
    ⟨at_.1, at_.2.1⟩

/-- **The base stands at what stands at nothing.** Along every profile perfect over `N` steps, at
every step from the first to the `N`-th the base stands at what stands at nothing; where nothing
stands at nothing, the base ends at once. -/
theorem perfect_levels {N : Nat} (perfect : Perfect G first second N) (s : Nat) {t : Nat}
    (before : t < N) : levels G first second s (t + 1) = G t 0 :=
  have zeros := perfect_ends perfect before
  congrArg (G t) ((congrArg (second t) (zeros.1 _)).trans (zeros.2 0))

/-- Where each draws everything, the second draws nothing. -/
theorem zero_secondDrawn : ∀ j t z,
    secondDrawn G (fun _ _ => 0) (fun _ _ => 0) j t z = 0
  | 0, _, _ => rfl
  | j + 1, t, _ => show 0 - 0 + secondDrawn G (fun _ _ => 0) (fun _ _ => 0) j (t + 1) (G t 0) = 0 by
      rw [zero_secondDrawn j]

/-- **Drawing everything is perfect.** The profile in which each draws everything it is given is
perfect over every horizon. -/
theorem perfect_of_zero (N : Nat) : Perfect G (fun _ _ => 0) (fun _ _ => 0) N :=
  ⟨fun _ _ => Nat.zero_le _, fun _ _ => Nat.zero_le _, fun t j _ =>
    ⟨fun a b _ => by
      show a - b + secondDrawn G (fun _ _ => 0) (fun _ _ => 0) j (t + 1) (G t b) ≤
        a - 0 + secondDrawn G (fun _ _ => 0) (fun _ _ => 0) j (t + 1) (G t 0)
      rw [zero_secondDrawn, zero_secondDrawn, Nat.add_zero, Nat.add_zero, Nat.sub_zero]
      exact Nat.sub_le a b,
     fun z a _ => by
      show z - a + firstDrawn G (fun _ _ => 0) (fun _ _ => 0) j (t + 1) (G t 0) ≤
        z - 0 + firstDrawn G (fun _ _ => 0) (fun _ _ => 0) j (t + 1) (G t 0)
      exact Nat.add_le_add_right (Nat.le_trans (Nat.sub_le z a) (Nat.le_of_eq (Nat.sub_zero z).symm))
        _⟩⟩

end InTurn

end Optimum

namespace Web

variable {W : Web F C} {c : C} {f : F}

/-- **Drawers in turn break at the first step every dependence on the base above what stands at
nothing.** Along every profile of two drawers in turn perfect over a horizon of at least one step the
base stands at what stands at nothing from the first step on: a formation depending on it, whose
need, met at the start, lies above what stands at nothing at the first step, is broken there. -/
theorem perfect_broken {G first second : Nat → Nat → Nat} {N s : Nat}
    (perfect : Optimum.InTurn.Perfect G first second N)
    (follows : ∀ t, t ≤ N → W.level t c = Optimum.InTurn.levels G first second s t)
    (long : 0 < N) (depends : W.requires 0 f c) (low : G 0 0 < W.need 0 f c)
    (start : W.need 0 f c ≤ W.level 0 c) :
    W.Broken 0 f c ∧ ∀ t, t < N → W.level (t + 1) c = G t 0 :=
  have stands : ∀ t, t < N → W.level (t + 1) c = G t 0 := fun t before =>
    (follows (t + 1) before).trans (Optimum.InTurn.perfect_levels perfect s before)
  ⟨⟨depends, start, Nat.lt_of_le_of_lt (Nat.le_of_eq (stands 0 long)) low⟩, stands⟩

end Web

namespace Optimum

namespace Holding

open Diversion

/-- **The gate witness: alone a drawer may keep the dweller; in turn every perfect profile breaks
it.** From a source at two, the level the dweller needs, under a gate renewing one unit at every
level from one: alone, the course holding the source at two is an optimum of the order by what the
taker draws across `n + 2` steps with capacity three, keeping the dweller met through the horizon
(`gated_alike`); with two drawers in turn, each ranking what it draws over the steps that remain,
drawing everything is perfect over every horizon (`InTurn.perfect_of_zero`), and along every perfect
profile the dweller is broken at the first step (`Web.perfect_broken`). -/
theorem gated_in_turn (n : Nat) :
    Frontier (OpenCourse gate 3 2) (byDrawn gate (n + 1)) (holding 2 2 (n + 1)) ∧
      (∀ t, t ≤ n + 1 → 2 ≤ (web (level gate 2 2 (n + 1))).level t .source) ∧
      InTurn.Perfect (fun _ z => z + gate z) (fun _ _ => 0) (fun _ _ => 0) (n + 2) ∧
      ∀ first second, InTurn.Perfect (fun _ z => z + gate z) first second (n + 2) →
        (web (onSource (InTurn.levels (fun _ z => z + gate z) first second 2))).Broken 0
          .dweller .source :=
  have alone := gated_alike n
  ⟨alone.1, alone.2.2.2.1, InTurn.perfect_of_zero (n + 2), fun first second perfect =>
    (Web.perfect_broken (W := web (onSource (InTurn.levels (fun _ z => z + gate z) first second 2)))
      (c := Place.source) (f := Formation.dweller) perfect (fun _ _ => rfl) (Nat.succ_pos (n + 1))
      trivial (Nat.succ_pos 1) (Nat.le_refl 2)).1⟩

end Holding

end Optimum
'''
op = once(op, '''end Holding

end Optimum


end Becoming
''', '''end Holding

end Optimum
''' + SECTION + '''

end Becoming
''')
if (HERE / 'optimum_doc.py').exists():
    exec((HERE / 'optimum_doc.py').read_text(encoding='utf-8'))
out = HERE / 'tree' / 'Becoming' / 'Optimum.lean'
out.parent.mkdir(parents=True, exist_ok=True)
out.write_text(op, encoding='utf-8')
print('wrote', out.name, len(op.splitlines()), 'lines')
