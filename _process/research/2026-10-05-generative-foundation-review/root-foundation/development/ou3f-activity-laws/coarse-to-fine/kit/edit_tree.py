#!/usr/bin/env python3
"""OU3f's coarse-to-fine pair: edit the tree's copy of Persistence. wang_state_of_change and sheng_state_of_change are
proved from «亡于粗则亡于细» and «生于粗则生于细»: ending and beginning under activity, which the state class is finer
than, replace the destructuring of the state class's pair. Statements and names unchanged.
Run on a copy matching tree/BASE.sha256 (main's bytes); each replacement must match exactly once."""
from pathlib import Path
import hashlib
import sys

HERE = Path(__file__).resolve().parent.parent
TREE = HERE / 'tree' / 'Becoming'
base = {line.split()[1]: line.split()[0] for line in (HERE / 'tree' / 'BASE.sha256').read_text().splitlines()}
for name, digest in base.items():
    if hashlib.sha256((HERE / 'tree' / name).read_bytes()).hexdigest() != digest:
        sys.exit(f'{name} is not the base copy; refusing to edit')
path = TREE / 'Persistence.lean'
text = path.read_text(encoding='utf-8')


def replace(old, new):
    global text
    if text.count(old) != 1:
        sys.exit(f'expected one match, found {text.count(old)}: {old[:80]!r}')
    text = text.replace(old, new)


replace("""  its dual `«生于粗则生于细»` (`Web.ceases_of_persisting_ceases`, `Web.arises_of_persisting_arises`).""",
        """  its dual `«生于粗则生于细»` (`Web.ceases_of_persisting_ceases`, `Web.arises_of_persisting_arises`).
  So do ending and beginning under the state class where activity changes, read from ending and
  beginning under activity (`Web.wang_state_of_change`, `Web.sheng_state_of_change`).
* **By closure.** A name kept over a held stretch (`Web.steady_held`) keeps a region along the
  steps, so it is a case of the grammar's closure at the successor (`kept_onward`).""")
replace("""Not connected: the laws of re-identification (`Web.steady_held`, `Web.renewingIn_held` and the
classes fixed under conservation) concern namings""", """Not connected: the other laws of re-identification (`Web.renewingIn_held` and the classes fixed
under conservation) concern namings""")
replace("""/-- Where activity changes across the step from `t`, the occurrence before it ends (亡) under the
state class. -/
theorem wang_state_of_change {t : Nat} {f : F} (change : ¬ (W.active t f ↔ W.active (t + 1) f)) :
    «亡» (continuationStep fun _ g f => g = f) (W.stateClass h) (t, f) :=
  fun ⟨y, ⟨next, same⟩, ⟨alike, _⟩⟩ => change
    (Eq.subst (motive := fun s => W.active t f ↔ W.active s f) next
      (Eq.subst (motive := fun g => W.active t f ↔ W.active y.1 g) same.symm alike))

/-- and the occurrence after it begins (生) under the state class. -/
theorem sheng_state_of_change {t : Nat} {f : F} (change : ¬ (W.active t f ↔ W.active (t + 1) f)) :
    «生» (continuationStep fun _ g f => g = f) (W.stateClass h) (t + 1, f) :=
  fun ⟨x, ⟨next, same⟩, ⟨alike, _⟩⟩ => change
    (Eq.subst (motive := fun s => W.active s f ↔ W.active (t + 1) f) (Nat.succ.inj next).symm
      (Eq.subst (motive := fun g => W.active x.1 g ↔ W.active (t + 1) f) same alike))""",
        """/-- Where activity changes across the step from `t`, the occurrence before it ends (亡) under the
state class: it ends under activity, which the state class is finer than (`«亡于粗则亡于细»`). -/
theorem wang_state_of_change {t : Nat} {f : F} (change : ¬ (W.active t f ↔ W.active (t + 1) f)) :
    «亡» (continuationStep fun _ g f => g = f) (W.stateClass h) (t, f) :=
  «亡于粗则亡于细» _ (E' := W.activityClass) (fun _ _ same => same.1) fun ⟨y, ⟨next, same⟩, alike⟩ =>
    change (Eq.subst (motive := fun s => W.active t f ↔ W.active s f) next
      (Eq.subst (motive := fun g => W.active t f ↔ W.active y.1 g) same.symm alike))

/-- and the occurrence after it begins (生) under the state class: it begins under activity
(`«生于粗则生于细»`). -/
theorem sheng_state_of_change {t : Nat} {f : F} (change : ¬ (W.active t f ↔ W.active (t + 1) f)) :
    «生» (continuationStep fun _ g f => g = f) (W.stateClass h) (t + 1, f) :=
  «生于粗则生于细» _ (E' := W.activityClass) (fun _ _ same => same.1) fun ⟨x, ⟨next, same⟩, alike⟩ =>
    change (Eq.subst (motive := fun s => W.active s f ↔ W.active (t + 1) f) (Nat.succ.inj next).symm
      (Eq.subst (motive := fun g => W.active x.1 g ↔ W.active (t + 1) f) same alike))""")
path.write_text(text, encoding='utf-8')
print('edited')
