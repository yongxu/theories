#!/usr/bin/env python3
"""Build RL1's tree: Ranking with the relation-level reading (its law of easing, its form where levels never fall and
every relation is kept, the two-part family unranked), Relevance with its identity to Web.relations' living, and
JointDraw with restraint over any number of drawers under it.
usage: python3 -B build_tree.py   (RL1_ROOT names the checkout to read; RL1_BASE, a git ref of it, reads it at that ref).
Writes tree/Becoming/{Ranking,Relevance,JointDraw}.lean."""
import os
import subprocess
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = Path(os.environ['RL1_ROOT']).resolve() if os.environ.get('RL1_ROOT') else HERE.parents[5]
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'


def once(text, old, new):
    assert text.count(old) == 1, ('edit does not match once', old[:90], text.count(old))
    return text.replace(old, new)


def read(name):
    if os.environ.get('RL1_BASE'):
        rel = (PKG / 'Becoming' / f'{name}.lean').relative_to(ROOT)
        return subprocess.run(['git', '-C', str(ROOT), 'show', f"{os.environ['RL1_BASE']}:{rel}"], check=True,
                              capture_output=True, text=True).stdout
    return (PKG / 'Becoming' / f'{name}.lean').read_text(encoding='utf-8')


rk = read('Ranking')
assert 'def relational' not in rk, 'already built'
RELATIONAL = '''
/-! ## The relation-level reading -/

/-- **The relation-level reading** of a family of courses, each a web: a claim is a formation's
relation to a condition at a step, included when the formation is active and takes part in the
condition there and the relation does not undermine. It is the `living` of `Web.relations`
(`Ranking.relational_iff`, in `Becoming.Relevance`). -/
def relational (U : W → Web F C) (w : W) (e : F × C × Nat) : Prop :=
  (U w).active e.2.2 e.1 ∧ (U w).Participates e.2.2 e.1 e.2.1 ∧ ¬ (U w).UnderminingOn e.2.2 e.1 e.2.1

/-- **Under easing the relation-level reading withdraws exactly the relations the easing course no
longer takes part in or undermines.** From a course where activity needs support to one where activity
follows support and that eases it, a relation the reading includes in the first stays included in the
second exactly where the second still takes part in the condition and does not undermine there. -/
theorem relational_kept_iff {U : W → Web F C} {w w' : W} (dependent : (U w).Dependent)
    (gated : ActiveWhereSupported (U w')) (eases : Eases (U w) (U w')) {e : F × C × Nat}
    (included : relational U w e) :
    relational U w' e ↔ (U w').Participates e.2.2 e.1 e.2.1 ∧ ¬ (U w').UnderminingOn e.2.2 e.1 e.2.1 :=
  ⟨fun kept => kept.2,
   fun ⟨joins, keeps⟩ => ⟨active_of_eases dependent gated eases included.1, joins, keeps⟩⟩

/-- **The relation-level law of easing.** Under the conditions of the whole-run law, the easing
course extends the other under the relation-level reading exactly when it still takes part in, and
does not undermine, every relation the other includes, and includes one the other withholds. -/
theorem relational_extends_iff_of_eases {U : W → Web F C} {w w' : W} (dependent : (U w).Dependent)
    (gated : ActiveWhereSupported (U w')) (eases : Eases (U w) (U w')) :
    ExtendsUnder (relational U) w w' ↔
      (∀ e, relational U w e →
        (U w').Participates e.2.2 e.1 e.2.1 ∧ ¬ (U w').UnderminingOn e.2.2 e.1 e.2.1) ∧
      ∃ e, relational U w' e ∧ ¬ relational U w e :=
  ⟨fun ⟨covers, e, _, included, withheld⟩ => ⟨fun e c => (covers e c).2, e, included, withheld⟩,
   fun ⟨keeps, e, included, withheld⟩ =>
    ⟨fun e c => (relational_kept_iff dependent gated eases c).2 (keeps e c), e, trivial, included,
      withheld⟩⟩

/-- **Easing that lets nothing fall and keeps every relation, under the relation-level reading.** Under
the conditions of the whole-run law, where no condition's level falls at any step of the easing course
and the easing course takes part wherever the other does, it extends the other under the relation-level
reading exactly when it includes some relation the other withholds. -/
theorem relational_extends_iff_of_rising {U : W → Web F C} {w w' : W} (dependent : (U w).Dependent)
    (gated : ActiveWhereSupported (U w')) (eases : Eases (U w) (U w'))
    (rises : ∀ t c, (U w').level t c ≤ (U w').level (t + 1) c)
    (joins : ∀ t f c, (U w).Participates t f c → (U w').Participates t f c) :
    ExtendsUnder (relational U) w w' ↔ ∃ e, relational U w' e ∧ ¬ relational U w e :=
  ⟨fun ext => ((relational_extends_iff_of_eases dependent gated eases).1 ext).2,
   fun witness => (relational_extends_iff_of_eases dependent gated eases).2
     ⟨fun e c => ⟨joins _ _ _ c.2.1, fun undermining =>
       not_undermining_of_rising rises e.2.2 e.1 ⟨e.2.1, undermining⟩⟩, witness⟩⟩
'''
rk = once(rk, '''   fun witness => (stepwise_extends_iff_of_eases dependent gated eases).2
     ⟨fun e _ => not_undermining_of_rising rises e.2 e.1, witness⟩⟩
''', '''   fun witness => (stepwise_extends_iff_of_eases dependent gated eases).2
     ⟨fun e _ => not_undermining_of_rising rises e.2 e.1, witness⟩⟩
''' + RELATIONAL)
UNRANKED = '''
/-- **The relation-level reading too leaves absence and occurrence unranked.** Under the stepwise
reading's premises, once the focal formation has an event that reading includes, the relation-level
reading includes its relation to the condition at that step, which the course without it lacks, and
the course with it lacks the sustaining formation's relations after the loss. -/
theorem relational_unranked (L : Law) (positive : 0 < L.needG) (fWithin : L.needF ≤ L.needG)
    (gStart : L.needG ≤ L.start) {T0 : Nat}
    (over : ∀ t, T0 ≤ t → L.renew + L.contrib t < L.draw t) {t : Nat}
    (included : stepwise (course L) .occurs (.focal, t)) :
    ¬ ExtendsUnder (relational (course L)) .occurs .absent ∧
      ¬ ExtendsUnder (relational (course L)) .absent .occurs :=
  match overdraw_consuming L positive fWithin over with
  | ⟨_, T, lost⟩ =>
    ⟨fun extends_ => (extends_.1 (.focal, (), t)
       ⟨included.1, Or.inr ⟨T0, Nat.lt_of_le_of_lt (Nat.zero_le _) (over T0 (Nat.le_refl T0))⟩,
        fun undermining => included.2 ⟨(), undermining⟩⟩).1,
     fun extends_ => lost T (Nat.le_refl T)
      (extends_.1 (.sustaining, (), T) ⟨absent_sustains L gStart T, Or.inl trivial,
        fun ⟨drawn, _⟩ => drawn⟩).1⟩
'''
rk = once(rk, '''
/-- A comparison preferring the course in which the focal formation occurs, alongside
every extension under a reading.''', UNRANKED + '''
/-- A comparison preferring the course in which the focal formation occurs, alongside
every extension under a reading.''')
rk = once(rk, '''  (`stepwise_extends_iff_of_rising`). Easing alone does not suffice (`ThirdParty.stepwise_not_monotone`).''',
'''  (`stepwise_extends_iff_of_rising`). Easing alone does not suffice (`ThirdParty.stepwise_not_monotone`).
* The relation-level reading (`relational`, the `living` of `Web.relations`): a claim is a formation's
  relation to a condition at a step. Under easing it withdraws exactly the relations the easing course
  no longer takes part in or undermines (`relational_kept_iff`, `relational_extends_iff_of_eases`), so
  where no level falls and the easing course takes part wherever the other does its law is the
  whole-run one (`relational_extends_iff_of_rising`); in the two-part family it includes the focal
  formation's relation where the stepwise reading includes its event, and leaves absence and
  occurrence unranked as that reading does (`relational_unranked`).''')

rv = read('Relevance')
assert 'relational_iff' not in rv
rv = once(rv, '''/-- The stepwise reading is the `living` of `Web.valuation`. -/
theorem stepwise_iff {Pos : Type} (U : W → Web F C) (w : W) (own sig : Pos → F × Nat → Prop)
    (e : F × Nat) : stepwise U w e ↔ ((U w).valuation own sig).living e :=
  Iff.rfl
''', '''/-- The stepwise reading is the `living` of `Web.valuation`. -/
theorem stepwise_iff {Pos : Type} (U : W → Web F C) (w : W) (own sig : Pos → F × Nat → Prop)
    (e : F × Nat) : stepwise U w e ↔ ((U w).valuation own sig).living e :=
  Iff.rfl

/-- The relation-level reading is the `living` of `Web.relations`. -/
theorem relational_iff {Pos : Type} (U : W → Web F C) (w : W) (own sig : Pos → F × C × Nat → Prop)
    (e : F × C × Nat) : relational U w e ↔ ((U w).relations own sig).living e :=
  Iff.rfl
''')

jd = read('JointDraw')
assert 'restraint_extends_iff_relational' not in jd
jd = once(jd, '''  ranks _ _ ((restraint_extends_iff_stepwise balances balances' start restrained renewing asks needs
    drawsLess dependent gated within).mpr ⟨e, included, withheld⟩)
''', '''  ranks _ _ ((restraint_extends_iff_stepwise balances balances' start restrained renewing asks needs
    drawsLess dependent gated within).mpr ⟨e, included, withheld⟩)

/-- **Restraint over any number of drawers, under the relation-level reading.** Under the premises of
the stepwise comparison, where moreover the restrained course takes part in every condition wherever
the other does (it asks and draws less, not nothing), the restrained course extends the other under the
relation-level reading exactly when it includes some relation the other withholds. -/
theorem restraint_extends_iff_relational (balances : L.Balances (U w)) (balances' : L'.Balances (U w'))
    (start : ∀ c, (U w).level 0 c ≤ (U w').level 0 c)
    (restrained : ∀ t c, L'.taken t c ≤ L.taken t c)
    (renewing : ∀ t c, L.given t c ≤ L'.given t c)
    (asks : ∀ t f c, (U w').requires t f c → (U w).requires t f c)
    (needs : ∀ t f c, (U w').need t f c ≤ (U w).need t f c)
    (drawsLess : ∀ t f c, (U w').draws t f c → (U w).draws t f c)
    (dependent : (U w).Dependent) (gated : ActiveWhereSupported (U w'))
    (within : ∀ t c, L'.taken t c ≤ L'.given t c)
    (joins : ∀ t f c, (U w).Participates t f c → (U w').Participates t f c) :
    ExtendsUnder (relational U) w w' ↔ ∃ e, relational U w' e ∧ ¬ relational U w e :=
  relational_extends_iff_of_rising dependent gated
    (balances.eases_of_restrained balances' start restrained renewing asks needs drawsLess)
    (fun t c => Naturals.le_of_add_le_add_right (Nat.le_trans (Nat.add_le_add_left (within t c) _)
      (Nat.le_of_eq (balances' t c).symm))) joins
''')
jd = once(jd, '''  (`Ranking.restraint_extends_iff_stepwise`, `Ranking.restraint_ranks_stepwise`); taking no more alone
  does not suffice (`Ranking.ThirdParty.stepwise_not_monotone`).''', '''  (`Ranking.restraint_extends_iff_stepwise`, `Ranking.restraint_ranks_stepwise`); taking no more alone
  does not suffice (`Ranking.ThirdParty.stepwise_not_monotone`). Under the relation-level reading the
  same holds where the restrained course also takes part in every condition wherever the other does,
  drawing less rather than nothing (`Ranking.restraint_extends_iff_relational`).''')
for name, text in [('Ranking', rk), ('Relevance', rv), ('JointDraw', jd)]:
    out = HERE / 'tree' / 'Becoming' / f'{name}.lean'
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text(text, encoding='utf-8')
    print('wrote', out.name, len(text.splitlines()), 'lines')
