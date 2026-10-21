#!/usr/bin/env python3
"""Build J1S's tree: Ranking importing Lexical, with the two-part family read in two tiers (the sustaining formation's
events basic, the focal formation's gains) and J1's ranking of absence above malignant growth under the stepwise and
relation-level readings.
usage: python3 -B build_tree.py   (J1S_ROOT names the checkout to read; J1S_BASE, a git ref of it, reads it at that ref).
Writes tree/Becoming/Ranking.lean."""
import os
import subprocess
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = Path(os.environ['J1S_ROOT']).resolve() if os.environ.get('J1S_ROOT') else HERE.parents[5]
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'


def once(text, old, new):
    assert text.count(old) == 1, ('edit does not match once', old[:90], text.count(old))
    return text.replace(old, new)


def read(name):
    if os.environ.get('J1S_BASE'):
        rel = (PKG / 'Becoming' / f'{name}.lean').relative_to(ROOT)
        return subprocess.run(['git', '-C', str(ROOT), 'show', f"{os.environ['J1S_BASE']}:{rel}"], check=True,
                              capture_output=True, text=True).stdout
    return (PKG / 'Becoming' / f'{name}.lean').read_text(encoding='utf-8')


rk = read('Ranking')
assert 'basicTier' not in rk, 'already built'
rk = once(rk, 'import Becoming.Frame\nimport Becoming.Extension\nimport Becoming.Witnesses\n',
          'import Becoming.Frame\nimport Becoming.Extension\nimport Becoming.Witnesses\nimport Becoming.Lexical\n')
SECTION = '''
/-! ## The priority of basic conditions, step by step -/

/-- The basic tier of a reading in the two-part family: the included events or relations of the
sustaining formation, whose activity is the condition meeting its need. -/
def basicTier {E : Type} (part : E → Part) (reading : Course → E → Prop) (w : Course) (e : E) : Prop :=
  part e = .sustaining ∧ reading w e

/-- The gain tier: the included events or relations of the focal formation. -/
def gainTier {E : Type} (part : E → Part) (reading : Course → E → Prop) (w : Course) (e : E) : Prop :=
  part e = .focal ∧ reading w e

/-- **The priority of basic conditions ranks absence above malignant growth, step by step.** Under the
stepwise reading's premises in the two-part family, read in two tiers, the sustaining formation's
included events basic and the focal formation's gains, the course without the focal formation is
lexically above the course with it: it keeps every basic event, the sustaining formation being active
and drawing nothing at every step of it, and holds one the other loses after the loss. Where C alone
leaves the two unranked (`stepwise_unranked`), every comparison meeting J1 ranks absence higher. -/
theorem basic_first_stepwise (L : Law) (positive : 0 < L.needG) (fWithin : L.needF ≤ L.needG)
    (gStart : L.needG ≤ L.start) {T0 : Nat}
    (over : ∀ t, T0 ≤ t → L.renew + L.contrib t < L.draw t) :
    Lexical.Above (basicTier Prod.fst (stepwise (course L))) (gainTier Prod.fst (stepwise (course L)))
      .absent .occurs :=
  match overdraw_consuming L positive fWithin over with
  | ⟨_, T, lost⟩ =>
    Lexical.Above.anchor
      (fun e ⟨isBasic, _⟩ => ⟨isBasic, by
        obtain ⟨p, t⟩ := e
        cases isBasic
        exact ⟨absent_sustains L gStart t, fun ⟨_, drawn, _⟩ => drawn⟩⟩)
      (.sustaining, T) ⟨rfl, absent_sustains L gStart T, fun ⟨_, drawn, _⟩ => drawn⟩
      (fun ⟨_, included⟩ => lost T (Nat.le_refl T) included.1)

/-- **The same under the relation-level reading.** Read in the same two tiers, relation by relation, the
course without the focal formation is lexically above the course with it. -/
theorem basic_first_relational (L : Law) (positive : 0 < L.needG) (fWithin : L.needF ≤ L.needG)
    (gStart : L.needG ≤ L.start) {T0 : Nat}
    (over : ∀ t, T0 ≤ t → L.renew + L.contrib t < L.draw t) :
    Lexical.Above (basicTier Prod.fst (relational (course L))) (gainTier Prod.fst (relational (course L)))
      .absent .occurs :=
  match overdraw_consuming L positive fWithin over with
  | ⟨_, T, lost⟩ =>
    Lexical.Above.anchor
      (fun e ⟨isBasic, _⟩ => ⟨isBasic, by
        obtain ⟨p, c, t⟩ := e
        cases isBasic
        exact ⟨absent_sustains L gStart t, Or.inl trivial, fun ⟨drawn, _⟩ => drawn⟩⟩)
      (.sustaining, (), T) ⟨rfl, absent_sustains L gStart T, Or.inl trivial, fun ⟨drawn, _⟩ => drawn⟩
      (fun ⟨_, included⟩ => lost T (Nat.le_refl T) included.1)

/-- **Every comparison meeting J1 ranks absence above malignant growth, under either reading.** -/
theorem basic_first_ranks (L : Law) (positive : 0 < L.needG) (fWithin : L.needF ≤ L.needG)
    (gStart : L.needG ≤ L.start) {T0 : Nat}
    (over : ∀ t, T0 ≤ t → L.renew + L.contrib t < L.draw t) {better better' : Course → Course → Prop}
    (priority : Lexical.BasicPriority (basicTier Prod.fst (stepwise (course L)))
      (gainTier Prod.fst (stepwise (course L))) better)
    (priority' : Lexical.BasicPriority (basicTier Prod.fst (relational (course L)))
      (gainTier Prod.fst (relational (course L))) better') :
    better .absent .occurs ∧ better' .absent .occurs :=
  ⟨(priority.iff _ _).2 (basic_first_stepwise L positive fWithin gStart over),
   (priority'.iff _ _).2 (basic_first_relational L positive fWithin gStart over)⟩
'''
rk = once(rk, '''
/-- A comparison preferring the course in which the focal formation occurs, alongside
every extension under a reading.''', SECTION + '''
/-- A comparison preferring the course in which the focal formation occurs, alongside
every extension under a reading.''')
rk = once(rk, '''  occurrence unranked as that reading does (`relational_unranked`).''', '''  occurrence unranked as that reading does (`relational_unranked`).
* The priority of basic conditions step by step (J1, `Becoming.Lexical`): read in two tiers, the
  sustaining formation's included events basic and the focal formation's gains, the course without
  the focal formation is lexically above the course with it under the stepwise and the
  relation-level readings (`basic_first_stepwise`, `basic_first_relational`), so every comparison
  meeting J1 ranks absence above malignant growth where C alone leaves them unranked
  (`basic_first_ranks`).''')
out = HERE / 'tree' / 'Becoming' / 'Ranking.lean'
out.parent.mkdir(parents=True, exist_ok=True)
out.write_text(rk, encoding='utf-8')
print('wrote', out.name, len(rk.splitlines()), 'lines')
