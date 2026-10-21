#!/usr/bin/env python3
"""Build ST1's tree: Ranking with the stepwise law of easing (its shared activity lemma, the exact law, a course whose
levels never fall undermining nothing, and ThirdParty read through it) and JointDraw with restraint over any number of
drawers under the stepwise reading.
usage: python3 -B build_tree.py   (ST1_ROOT names the checkout to read; ST1_BASE, a git ref of it, reads it at that ref).
Writes tree/Becoming/Ranking.lean and tree/Becoming/JointDraw.lean."""
import os
import subprocess
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = Path(os.environ['ST1_ROOT']).resolve() if os.environ.get('ST1_ROOT') else HERE.parents[5]
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'


def once(text, old, new):
    assert text.count(old) == 1, ('edit does not match once', old[:90], text.count(old))
    return text.replace(old, new)


def read(name):
    if os.environ.get('ST1_BASE'):
        rel = (PKG / 'Becoming' / f'{name}.lean').relative_to(ROOT)
        return subprocess.run(['git', '-C', str(ROOT), 'show', f"{os.environ['ST1_BASE']}:{rel}"], check=True,
                              capture_output=True, text=True).stdout
    return (PKG / 'Becoming' / f'{name}.lean').read_text(encoding='utf-8')


rk = read('Ranking')
assert 'stepwise_extends_iff_of_eases' not in rk, 'already built'
# 1. The shared activity lemma; the whole-run monotonicity reads it.
rk = once(rk, '''/-- Easing never withdraws an event the whole-run reading includes: from a course where
activity needs support to one where activity follows support and that eases it, every event
the whole-run reading includes stays included. -/
theorem wholeRun_mono {U : W → Web F C} {w w' : W} (dependent : (U w).Dependent)
    (gated : ActiveWhereSupported (U w')) (eases : Eases (U w) (U w')) {e : F × Nat} :
    wholeRun U w e → wholeRun U w' e
  | ⟨active, notConsuming⟩ =>
    ⟨gated e.2 e.1 fun c depends => Nat.le_trans (eases.2.1 e.2 e.1 c)
        (Nat.le_trans (dependent e.2 e.1 active c (eases.1 e.2 e.1 c depends))
          (eases.2.2.1 e.2 c)),
     fun''', '''/-- **Easing keeps activity.** From a course where activity needs support to one where activity
follows support and that eases it, a formation active in the first at a step is active in the
second there: the first's support there is the second's. -/
theorem active_of_eases {U V : Web F C} (dependent : U.Dependent) (gated : ActiveWhereSupported V)
    (eases : Eases U V) {t : Nat} {f : F} (active : U.active t f) : V.active t f :=
  gated t f fun c depends => Nat.le_trans (eases.2.1 t f c)
    (Nat.le_trans (dependent t f active c (eases.1 t f c depends)) (eases.2.2.1 t c))

/-- Easing never withdraws an event the whole-run reading includes: from a course where
activity needs support to one where activity follows support and that eases it, every event
the whole-run reading includes stays included. -/
theorem wholeRun_mono {U : W → Web F C} {w w' : W} (dependent : (U w).Dependent)
    (gated : ActiveWhereSupported (U w')) (eases : Eases (U w) (U w')) {e : F × Nat} :
    wholeRun U w e → wholeRun U w' e
  | ⟨active, notConsuming⟩ =>
    ⟨active_of_eases dependent gated eases active,
     fun''')
# 2. The stepwise law of easing, after the whole-run law.
rk = once(rk, '''/-- The whole-run law of easing: under its conditions the easing course extends the other
exactly when it includes some event the other withholds. The stepwise reading has no such
law (`ThirdParty.stepwise_not_monotone`). -/''', '''/-- The whole-run law of easing: under its conditions the easing course extends the other
exactly when it includes some event the other withholds. Under the stepwise reading the law
needs a further premise, that the easing course undermine no event the other includes
(`stepwise_extends_iff_of_eases`, `ThirdParty.stepwise_not_monotone`). -/''')
STEPWISE = '''
/-- **Under easing the stepwise reading withdraws exactly what the easing course undermines.** From
a course where activity needs support to one where activity follows support and that eases it, an
event the stepwise reading includes in the first stays included in the second exactly where the
second does not undermine there. -/
theorem stepwise_kept_iff {U : W → Web F C} {w w' : W} (dependent : (U w).Dependent)
    (gated : ActiveWhereSupported (U w')) (eases : Eases (U w) (U w')) {e : F × Nat}
    (included : stepwise U w e) : stepwise U w' e ↔ ¬ (U w').UnderminingAt e.2 e.1 :=
  ⟨fun kept => kept.2, fun keeps => ⟨active_of_eases dependent gated eases included.1, keeps⟩⟩

/-- **The stepwise law of easing.** Under the conditions of the whole-run law, the easing course
extends the other under the stepwise reading exactly when it undermines no event the other
includes and includes some event the other withholds. -/
theorem stepwise_extends_iff_of_eases {U : W → Web F C} {w w' : W} (dependent : (U w).Dependent)
    (gated : ActiveWhereSupported (U w')) (eases : Eases (U w) (U w')) :
    ExtendsUnder (stepwise U) w w' ↔
      (∀ e, stepwise U w e → ¬ (U w').UnderminingAt e.2 e.1) ∧
        ∃ e, stepwise U w' e ∧ ¬ stepwise U w e :=
  ⟨fun ⟨covers, e, _, included, withheld⟩ => ⟨fun e c => (covers e c).2, e, included, withheld⟩,
   fun ⟨keeps, e, included, withheld⟩ =>
    ⟨fun e c => (stepwise_kept_iff dependent gated eases c).2 (keeps e c), e, trivial, included,
      withheld⟩⟩

/-- A condition's level that falls at no step is at least as high at every later step. -/
theorem level_never_falls {V : Web F C} {c : C} (rises : ∀ t, V.level t c ≤ V.level (t + 1) c)
    (s : Nat) : ∀ k, V.level s c ≤ V.level (s + k) c
  | 0 => Nat.le_refl _
  | k + 1 => Nat.le_trans (level_never_falls rises s k) (rises (s + k))

/-- **A course in which no condition's level falls undermines nothing.** An undermining relation needs
a condition to fall, after a draw, below a need of a dependence it met while the dependence held,
and a level that never falls stays at or above every need it once met. -/
theorem not_undermining_of_rising {V : Web F C} (rises : ∀ t c, V.level t c ≤ V.level (t + 1) c)
    (t : Nat) (f : F) : ¬ V.UnderminingAt t f := fun ⟨c, _, _, _, ⟨s, before, _, met, above⟩, _⟩ =>
  Nat.lt_irrefl _ (Nat.lt_of_lt_of_le above (Nat.le_trans met
    (Nat.le_trans (level_never_falls (rises · c) s (t + 1 - s))
      (Nat.le_of_eq (congrArg (V.level · c) (Becoming.add_sub_of_le (Nat.le_succ_of_le before)))))))

/-- **Easing that lets nothing fall, under the stepwise reading.** Under the conditions of the
whole-run law, where no condition's level falls at any step of the easing course, it extends the other
under the stepwise reading exactly when it includes some event the other withholds, as under the
whole-run reading. -/
theorem stepwise_extends_iff_of_rising {U : W → Web F C} {w w' : W} (dependent : (U w).Dependent)
    (gated : ActiveWhereSupported (U w')) (eases : Eases (U w) (U w'))
    (rises : ∀ t c, (U w').level t c ≤ (U w').level (t + 1) c) :
    ExtendsUnder (stepwise U) w w' ↔ ∃ e, stepwise U w' e ∧ ¬ stepwise U w e :=
  ⟨fun ext => ((stepwise_extends_iff_of_eases dependent gated eases).1 ext).2,
   fun witness => (stepwise_extends_iff_of_eases dependent gated eases).2
     ⟨fun e _ => not_undermining_of_rising rises e.2 e.1, witness⟩⟩
'''
rk = once(rk, '''    ⟨fun _ c => wholeRun_mono dependent gated eases c, e, trivial, included, withheld⟩⟩
''', '''    ⟨fun _ c => wholeRun_mono dependent gated eases c, e, trivial, included, withheld⟩⟩
''' + STEPWISE)
# 3. ThirdParty read through the law.
rk = once(rk, '''/-- The stepwise reading has no law of easing: the restrained course eases the overdrawing
one, activity needs support in both and follows support in the restrained one, yet the
stepwise reading includes the focal event at step 3 only in the overdrawing course. The
whole-run reading ranks restraint higher, as `wholeRun_extends_iff_of_eases` gives. -/''', '''/-- Easing alone gives the stepwise reading no law: the restrained course eases the overdrawing
one, activity needs support in both and follows support in the restrained one, yet the
stepwise reading includes the focal event at step 3 only in the overdrawing course, which the
restrained course undermines there (`undermines_included`), the premise
`stepwise_extends_iff_of_eases` adds. The whole-run reading ranks restraint higher, as
`wholeRun_extends_iff_of_eases` gives. -/''')
rk = once(rk, '''
end ThirdParty
''', '''
/-- **Where the stepwise law's premise fails.** The restrained course undermines at step 3 the
focal event the overdrawing course includes: the third formation, met at seven only in the
restrained course, falls below its need after the focal draw. -/
theorem undermines_included :
    stepwise courses .overdraws (.focal, 3) ∧ (courses .stops).UnderminingAt 3 .focal ∧
    ¬ ExtendsUnder (stepwise courses) .overdraws .stops :=
  ⟨focal_three.1,
   ⟨(), trivial, .third, trivial, ⟨3, Nat.le_refl 3, fun _ _ _ => trivial, Nat.le_refl 7, Nat.le_refl _⟩,
    Nat.lt_succ_self 6⟩,
   fun ext => ((stepwise_extends_iff_of_eases (U := courses) (w := .overdraws) (w' := .stops)
     stepwise_not_monotone.1 stepwise_not_monotone.2.1 stepwise_not_monotone.2.2.1).1 ext).1
       (.focal, 3) focal_three.1
       ⟨(), trivial, .third, trivial, ⟨3, Nat.le_refl 3, fun _ _ _ => trivial, Nat.le_refl 7, Nat.le_refl _⟩,
        Nat.lt_succ_self 6⟩⟩

end ThirdParty
''')
jd = read('JointDraw')
assert 'restraint_extends_iff_stepwise' not in jd
jd = once(jd, '''  ranks _ _ ((restraint_extends_iff balances balances' start restrained renewing asks needs
    drawsLess dependent gated).mpr ⟨e, included, withheld⟩)

end Ranking''', '''  ranks _ _ ((restraint_extends_iff balances balances' start restrained renewing asks needs
    drawsLess dependent gated).mpr ⟨e, included, withheld⟩)

/-- **Restraint over any number of drawers, under the stepwise reading.** Under the premises of the
whole-run comparison, where moreover the restrained course's flow takes from no condition more than
it gives at any step, so that no level falls there, the restrained course extends the other under the
stepwise reading exactly when it includes some event the other withholds. -/
theorem restraint_extends_iff_stepwise (balances : L.Balances (U w)) (balances' : L'.Balances (U w'))
    (start : ∀ c, (U w).level 0 c ≤ (U w').level 0 c)
    (restrained : ∀ t c, L'.taken t c ≤ L.taken t c)
    (renewing : ∀ t c, L.given t c ≤ L'.given t c)
    (asks : ∀ t f c, (U w').requires t f c → (U w).requires t f c)
    (needs : ∀ t f c, (U w').need t f c ≤ (U w).need t f c)
    (drawsLess : ∀ t f c, (U w').draws t f c → (U w).draws t f c)
    (dependent : (U w).Dependent) (gated : ActiveWhereSupported (U w'))
    (within : ∀ t c, L'.taken t c ≤ L'.given t c) :
    ExtendsUnder (stepwise U) w w' ↔ ∃ e, stepwise U w' e ∧ ¬ stepwise U w e :=
  stepwise_extends_iff_of_rising dependent gated
    (balances.eases_of_restrained balances' start restrained renewing asks needs drawsLess)
    fun t c => Naturals.le_of_add_le_add_right (Nat.le_trans (Nat.add_le_add_left (within t c) _)
      (Nat.le_of_eq (balances' t c).symm))

/-- Every comparison satisfying C under the stepwise reading then ranks the restrained course higher,
for any number of drawers, as soon as it includes one event the other withholds. -/
theorem restraint_ranks_stepwise (balances : L.Balances (U w)) (balances' : L'.Balances (U w'))
    (start : ∀ c, (U w).level 0 c ≤ (U w').level 0 c)
    (restrained : ∀ t c, L'.taken t c ≤ L.taken t c)
    (renewing : ∀ t c, L.given t c ≤ L'.given t c)
    (asks : ∀ t f c, (U w').requires t f c → (U w).requires t f c)
    (needs : ∀ t f c, (U w').need t f c ≤ (U w).need t f c)
    (drawsLess : ∀ t f c, (U w').draws t f c → (U w).draws t f c)
    (dependent : (U w).Dependent) (gated : ActiveWhereSupported (U w'))
    (within : ∀ t c, L'.taken t c ≤ L'.given t c)
    {e : F × Nat} (included : stepwise U w' e) (withheld : ¬ stepwise U w e)
    {Better : X → X → Prop} (ranks : ComparisonUnder (stepwise U) Better) : Better w w' :=
  ranks _ _ ((restraint_extends_iff_stepwise balances balances' start restrained renewing asks needs
    drawsLess dependent gated within).mpr ⟨e, included, withheld⟩)

end Ranking''')

# Module docs.
rk = once(rk, """  an event the first withholds. The stepwise reading has no such law (`ThirdParty.stepwise_not_monotone`).""",
"""  an event the first withholds. Under the stepwise reading easing withdraws exactly the events the
  easing course undermines (`stepwise_kept_iff`), so the second extends the first exactly when it
  undermines no event the first includes and includes one the first withholds
  (`stepwise_extends_iff_of_eases`); a course in which no condition's level falls undermines nothing
  (`not_undermining_of_rising`), so there the stepwise law is the whole-run one
  (`stepwise_extends_iff_of_rising`). Easing alone does not suffice (`ThirdParty.stepwise_not_monotone`).""")
rk = once(rk, """  dependence, and neither course extends the other (`ThirdParty`). Under the whole-run
  reading restraint still extends overdraw there, by the law of easing.""",
"""  dependence, and neither course extends the other (`ThirdParty`): the restrained course
  undermines an event the overdrawing one includes, the premise the stepwise law of easing adds
  (`ThirdParty.undermines_included`). Under the whole-run reading restraint still extends overdraw
  there, by the law of easing.""")
jd = once(jd, """  formations enters. The stepwise reading has no such law (`Ranking.ThirdParty.stepwise_not_monotone`).""",
"""  formations enters. Under the stepwise reading the same holds where moreover the restrained flow
  takes from no condition more than it gives, so that no level falls in the restrained course
  (`Ranking.restraint_extends_iff_stepwise`, `Ranking.restraint_ranks_stepwise`); taking no more alone
  does not suffice (`Ranking.ThirdParty.stepwise_not_monotone`).""")
jd = once(jd, """for any number of drawers. That this ranking needs the whole-run reading, and not the stepwise
one, is `Ranking.ThirdParty`: a higher level kept can be undermined later, an event the stepwise
reading counts against the restrained course.""",
"""for any number of drawers. Under the stepwise reading it needs more, that the restrained course let
no level fall: `Ranking.ThirdParty` shows a higher level kept can be undermined later, an event the
stepwise reading counts against the restrained course, and a course whose levels never fall
undermines nothing.""")
for name, text in [('Ranking', rk), ('JointDraw', jd)]:
    out = HERE / 'tree' / 'Becoming' / f'{name}.lean'
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text(text, encoding='utf-8')
    print('wrote', out.name, len(text.splitlines()), 'lines')
