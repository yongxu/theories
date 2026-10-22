#!/usr/bin/env python3
"""Build UM2's tree: Optimum's drawers in turn with the drain's premise generalized to two drawers with no floor.
usage: python3 -B build_tree.py   (UM2_ROOT names the checkout to read; UM2_BASE, a git ref of it, reads it at that ref).
Writes tree/Becoming/Optimum.lean."""
import os
import subprocess
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = Path(os.environ['UM2_ROOT']).resolve() if os.environ.get('UM2_ROOT') else HERE.parents[5]
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'


def once(text, old, new):
    assert text.count(old) == 1, ('edit does not match once', old[:90], text.count(old))
    return text.replace(old, new)


def region(text, start, stop, new):
    assert text.count(start) == 1, ('start not once', start[:80], text.count(start))
    i = text.index(start)
    j = text.index(stop, i)
    return text[:i] + new + text[j:]


def read(name):
    if os.environ.get('UM2_BASE'):
        rel = (PKG / 'Becoming' / f'{name}.lean').relative_to(ROOT)
        return subprocess.run(['git', '-C', str(ROOT), 'show', f"{os.environ['UM2_BASE']}:{rel}"], check=True,
                              capture_output=True, text=True).stdout
    return (PKG / 'Becoming' / f'{name}.lean').read_text(encoding='utf-8')


op = read('Optimum')
assert 'theorem pass_through' not in op, 'already built'
text = lambda n: (HERE / n).read_text(encoding='utf-8')
op = region(op, '/-- Of nothing, drawers who leave at most what they are given leave nothing. -/',
            '/-- The first of `0, …, z` at which `f` is greatest among them. -/', text('floors.lean'))
op = region(op, '/-- **Revising toward best responses, drawers in turn come to drawing everything.**', '\nend InTurn\n',
            text('revised.lean'))
# The section's note.
op = once(op, '''to it at least one for one (`kept_returns`). So a drawer leaves its floor wherever what it draws later
does not depend on what it leaves (`at_floor`). With no floor and at least two drawers, backward
from the horizon every drawer after the first draws nothing later, and what the first leaves goes to
the second: revising from any profile comes to drawing everything within twice the horizon, and
every perfect profile draws everything. -/''', '''to it at least one for one (`kept_returns`). So a drawer leaves its floor wherever what it draws later
does not depend on what it leaves (`at_floor`). Where two drawers have no floor, whatever floors the
others have, nothing any drawer keeps comes back to it: what one of the two leaves passes through the
other, and what any other drawer leaves passes through one of them. So revising from any profile
comes to every drawer leaving its floor, and every perfect profile is the floor profile, which is
perfect; with no floor anywhere, that is drawing everything. -/''')
# The web law: any drawer that leaves nothing.
op = once(op, '''/-- **Where the first drawer leaves nothing, every dependence on the base above what stands at nothing
is broken at the first step.** Along a profile of drawers in turn, each leaving at most what it is
given, whose first drawer leaves nothing at every step before a horizon of at least one step, the
base stands from the first step at what stands at nothing: a formation depending on it, whose need,
met at the start, lies above what stands at nothing at the first step, is broken there. Every
perfect profile of two or more drawers (`Optimum.InTurn.perfect_ends`) and every profile revised from
round `2 N` on (`Optimum.InTurn.revised_draw_all`) is such a profile. -/
theorem drained_broken {G : Nat → Nat → Nat} {rules : Nat → Nat → Nat → Nat} {k N s : Nat} (one : 1 ≤ k)
    (leaves : ∀ d t a, rules d t a ≤ a) (first : ∀ t, t < N → ∀ a, rules 0 t a = 0)''',
'''/-- **Where a drawer leaves nothing, every dependence on the base above what stands at nothing is
broken at the first step.** Along a profile of drawers in turn, each leaving at most what it is given,
one of which leaves nothing at every step before a horizon of at least one step, the base stands from
the first step at what stands at nothing: a formation depending on it, whose need, met at the start,
lies above what stands at nothing at the first step, is broken there. Where two drawers have no floor,
every perfect profile (`Optimum.InTurn.perfect_at_floors`) and every profile revised long enough
(`Optimum.InTurn.revised_at_floors`) is such a profile. -/
theorem drained_broken {G : Nat → Nat → Nat} {rules : Nat → Nat → Nat → Nat} {k N s u : Nat} (uk : u < k)
    (leaves : ∀ d t a, rules d t a ≤ a) (zero : ∀ t, t < N → ∀ a, rules u t a = 0)''')
op = once(op, '(follows (t + 1) before).trans (Optimum.InTurn.levels_of_first one leaves first s before)',
          '(follows (t + 1) before).trans (Optimum.InTurn.levels_through leaves uk zero s before)')
# The gate witness.
op = once(op, '''  have revised := InTurn.revised_draw_all (G := fun _ z => z + gate z) (N := n + 2) two
    (start := fun _ _ a => a) (fun _ _ a => Nat.le_refl a) enough
  ⟨alone.1, alone.2.2.2.1, restraint_keeps k, InTurn.perfect_of_zero two (n + 2), fun rules perfect =>
    (Web.drained_broken (W := web (onSource (InTurn.levels (fun _ z => z + gate z) rules k 2)))
      (c := Place.source) (f := Formation.dweller) one (fun d t a => (perfect.1 d t a).2)
      (fun _ lt => InTurn.perfect_ends two perfect lt 0 firstPos) (fun _ _ => rfl) (Nat.succ_pos (n + 1))''',
'''  have second : 1 < k := Nat.lt_of_lt_of_le (Nat.lt_succ_self 1) two
  have revised := InTurn.revised_at_floors (G := fun _ z => z + gate z) (N := n + 2) (u := 0) (v := 1) (p := 2)
    Nat.zero_lt_one second (fun _ _ _ => Nat.zero_le _) (fun _ _ => rfl) (fun _ _ => rfl) (Nat.le_refl 2) (.inl rfl)
    (start := fun _ _ a => a) (fun _ _ a => Nat.le_refl a) enough
  ⟨alone.1, alone.2.2.2.1, restraint_keeps k,
   InTurn.floors_perfect Nat.zero_lt_one second (fun _ _ _ => Nat.zero_le _) (fun _ _ => rfl) (fun _ _ => rfl) (n + 2),
   fun rules perfect =>
    (Web.drained_broken (W := web (onSource (InTurn.levels (fun _ z => z + gate z) rules k 2)))
      (c := Place.source) (f := Formation.dweller) firstPos (fun d t a => (perfect.1 d t a).2)
      (fun _ lt => InTurn.perfect_at_floors Nat.zero_lt_one second (fun _ _ => rfl) (fun _ _ => rfl) perfect lt 0 firstPos)
      (fun _ _ => rfl) (Nat.succ_pos (n + 1))''')
op = once(op, '''      (rules := InTurn.revised (fun _ z => z + gate z) (fun _ _ _ => 0) k (n + 2) (fun _ _ a => a) m) one''',
          '''      (rules := InTurn.revised (fun _ z => z + gate z) (fun _ _ _ => 0) k (n + 2) (fun _ _ a => a) m) firstPos''')
op = once(op, '''  have one : 1 ≤ k := Nat.le_trans (Nat.le_succ 1) two
''', '')
# The doubling witness's unlimited part.
op = once(op, '''      (c := Place.source) (f := Formation.dweller) (Nat.le_succ 1) (fun d t a => (perfect.1 d t a).2)
      (fun _ lt => InTurn.perfect_ends (Nat.le_refl 2) perfect lt 0 (Nat.zero_lt_succ 1)) (fun _ _ => rfl)''',
'''      (c := Place.source) (f := Formation.dweller) (Nat.zero_lt_succ 1) (fun d t a => (perfect.1 d t a).2)
      (fun _ lt => InTurn.perfect_at_floors Nat.zero_lt_one (Nat.lt_succ_self 1) (fun _ _ => rfl) (fun _ _ => rfl)
        perfect lt 0 (Nat.zero_lt_succ 1)) (fun _ _ => rfl)''')
exec(text('optimum_doc.py'))
out = HERE / 'tree' / 'Becoming' / 'Optimum.lean'
out.parent.mkdir(parents=True, exist_ok=True)
out.write_text(op, encoding='utf-8')
print('wrote', out.name, len(op.splitlines()), 'lines')
