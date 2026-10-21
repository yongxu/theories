#!/usr/bin/env python3
"""EC3: produce tree5/Becoming/{InAmounts,LeastLoss,Space,Premises,Openness}.lean from the package sources.
usage (from the checkout root): python3 -B ec3_transform.py"""
from pathlib import Path
import re
HERE = Path(__file__).resolve().parent
SRC = Path('experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming')
OUT = HERE / 'tree5/Becoming'
rd = lambda m: (SRC / f'{m}.lean').read_text()


def cut(text, start, end):
    """(text without [start, end), the cut part); start and end are exact unique markers, end excluded."""
    i = text.index(start); assert text.count(start) == 1, start[:60]
    j = text.index(end, i)
    return text[:i] + text[j:], text[i:j]


ll, ia, sp, pr, op = rd('LeastLoss'), rd('InAmounts'), rd('Space'), rd('Premises'), rd('Openness')

# LeastLoss: the general falls-stop and finite-reading laws move down.
def cut_section(text, start):
    i = text.index(start); assert text.count(start) == 1, start[:60]
    j = text.index('end Amounts\n', i) + len('end Amounts\n')
    return text[:i] + text[j:].lstrip('\n'), text[i:j]


ll, secA = cut_section(ll, "/-! ## One premise: an amount's strict falls stop -/")
ll, secB = cut_section(ll, "/-! ## Rest from a finite reading: no least loss -/")

# InAmounts: the dyadic and layered worlds move up to LeastLoss.
ia, ex = cut(ia, "/-- **Without a least fall, some world never rests.**", "end Becoming\n")
ll = ll.replace('\nend Becoming\n', '\n/-! ## Worlds in amounts that never rest (moved from `Becoming.InAmounts`, EC3) -/\n\n' + ex + 'end Becoming\n')
ll = ll.replace('import Becoming.Likeness\n', 'import Becoming.Likeness\nimport Becoming.InAmounts\n', 1)

# Space: the world-level definitions and laws the rest theorem reads move down.
names = ['Finite', 'RestsFrom', 'Balanced', 'Dissipative', 'Embodied', 'ArisingEmbodied']
moved_defs = []
for n in names:
    m = re.search(r'\n(/--(?:(?!/--).)*?-/\ndef ' + n + r'\b.*?)(?=\n\n)', sp, re.S)
    assert m, n
    moved_defs.append(m.group(1))
    sp = sp.replace('\n' + m.group(1) + '\n', '\n', 1)
m = re.search(r'\ntheorem Embodied\.arising .*?(?=\n\n)', sp, re.S)
emb_arising = m.group(0).strip(); sp = sp.replace(m.group(0), '', 1)
moved_laws = []
for n in ['rests_unrefuted_iff', 'arising_unrefuted_covering']:
    m = re.search(r'\n(/--(?:(?!/--).)*?-/\ntheorem ' + n + r'\b.*?)(?=\n\n)', sp, re.S)
    assert m, n
    moved_laws.append(m.group(1))
    sp = sp.replace('\n' + m.group(1) + '\n', '\n', 1)
# Space's whole-number rest theorem goes (InAmounts states it as the case of the general law); its covering form is derived.
m = re.search(r'\n/--(?:(?!/--).)*?-/\ntheorem rests_unrefuted \(finite.*?(?=\n\n)', sp, re.S)
assert m; sp = sp.replace(m.group(0), '', 1)
m = re.search(r'\n(/--(?:(?!/--).)*?-/\n)theorem rests_unrefuted_covering .*?(?=\n\n)', sp, re.S)
assert m
cov_doc = m.group(1)
sp = sp.replace(m.group(0), '\n' + cov_doc + '''theorem rests_unrefuted_covering {ds : List w.Relatum} {T : Nat}
    (covers : ∀ t, T ≤ t → ∀ x, w.web.active t x → x ∈ ds)
    (balances : ∀ t, T ≤ t → w.flow.BalancesOn w.web ds t)
    (dissipates : ∀ t, T ≤ t → w.flow.DissipatesOn ds t) (embodied : w.ArisingEmbodied) :
    ¬ ¬ ∃ N, w.RestsFrom N :=
  have balances' : ∀ t, T ≤ t → w.wholeAmounts.BalancesOn Amounts.whole ds t :=
    fun t later => balancesOn_whole (balances t later)
  have dissipates' : ∀ t, T ≤ t → w.wholeAmounts.DissipatesOn Amounts.whole ds t :=
    fun t later => dissipatesOn_whole (dissipates t later)
  InAmounts.rests_unrefuted_of_stops covers balances' dissipates' (arisingEmbodied_whole embodied)
    (Amounts.whole_noEndlessFall _ T fun t later no =>
      no (InAmounts.stock_still (balances' t later) (dissipates' t later)))''', 1)
sp = sp.replace('import Becoming.Witnesses\n', 'import Becoming.Witnesses\nimport Becoming.InAmounts\n', 1)

# Premises: the census premise moves down.
m = re.search(r'\n/--(?:(?!/--).)*?-/\ndef Counted : Prop :=\n  ∃ alive, w\.web\.Census alive\n', pr, re.S)
assert m; counted = m.group(0).strip(); pr = pr.replace(m.group(0), '\n', 1)

# Openness: its enclosed rest theorem goes (InAmounts states it as the case of the general law).
m = re.search(r'\n/--(?:(?!/--).)*?-/\ntheorem rests_unrefuted_enclosed \(counted.*?(?=\n\n)', op, re.S)
assert m; op = op.replace(m.group(0), '', 1)

# InAmounts: imports below Space, the moved parts first, the whole-number cases under their names.
ia = ia.replace('import Becoming.LeastLoss\nimport Becoming.Space\n',
                'import Becoming.Amounts\nimport Becoming.Recurrence\nimport Becoming.Roles\n', 1)
world = ('/-! ## The world-level notions the rest theorem reads (moved from `Becoming.Space` and '
         '`Becoming.Premises`, EC3) -/\n\nnamespace World\n\nvariable (w : World)\n\n'
         + '\n\n'.join(moved_defs) + '\n\n' + counted + '\n\nvariable {w}\n\n' + emb_arising + '\n\n'
         + '\n\n'.join(moved_laws) + '\n\nend World\n\n')
anchor = 'namespace Becoming\n'
i = ia.index(anchor) + len(anchor)
ia = ia[:i] + '\n' + secA.rstrip() + '\n\n' + secB.rstrip() + '\n\n' + world + ia[i:].lstrip('\n')
ia = ia.replace('theorem rests_unrefuted_whole (finite', 'theorem rests_unrefuted (finite', 1)
ia = ia.replace('theorem rests_unrefuted_enclosed_whole (counted', 'theorem rests_unrefuted_enclosed (counted', 1)
# Bridges for one family at one step; the global ones go through them.
old = '''/-- A world's dissipation is its dissipation in whole-number amounts: what gives back all it takes
takes nothing, since a whole number that takes something loses at least one. -/
theorem dissipative_whole (dissipative : w.Dissipative) :
    w.wholeAmounts.Dissipative Amounts.whole := fun ds t distinct closed f mem =>
  have closedAt : w.flow.ClosedAt ds t := fun f mem c outside =>
    ⟨Nat.le_antisymm (closed f mem c outside).1 (Nat.zero_le _),
     Nat.le_antisymm (closed f mem c outside).2 (Nat.zero_le _)⟩
  have within := dissipative ds t distinct closedAt f mem
'''
assert ia.count(old) == 1
new = '''/-- A family's balance across a step is its balance in whole-number amounts. -/
theorem balancesOn_whole {ds : List w.Relatum} {t : Nat} (balances : w.flow.BalancesOn w.web ds t) :
    w.wholeAmounts.BalancesOn Amounts.whole ds t :=
  fun c member => Nat.le_of_eq ((congrArg (w.web.level (t + 1) c + ·) (Amounts.totalOf_whole _)).trans
    ((balances c member).trans (congrArg (w.web.level t c + ·) (Amounts.totalOf_whole _)).symm))

/-- A family dissipated on across a step is dissipated on in whole-number amounts: what gives back
all it takes takes nothing, since a whole number that takes something loses at least one. -/
theorem dissipatesOn_whole {ds : List w.Relatum} {t : Nat} (dissipates : w.flow.DissipatesOn ds t) :
    w.wholeAmounts.DissipatesOn Amounts.whole ds t := fun f mem =>
  have within := dissipates f mem
'''
ia = ia.replace(old, new, 1)
# the rest of the old dissipative_whole body now ends dissipatesOn_whole; add dissipative_whole after it
m = re.search(r'(theorem dissipatesOn_whole .*?)(?=\n\n)', ia, re.S)
ia = ia.replace(m.group(1), m.group(1) + '''

/-- A world's dissipation is its dissipation in whole-number amounts. -/
theorem dissipative_whole (dissipative : w.Dissipative) :
    w.wholeAmounts.Dissipative Amounts.whole := fun ds t distinct closed =>
  dissipatesOn_whole (dissipative ds t distinct fun f mem c outside =>
    ⟨Nat.le_antisymm (closed f mem c outside).1 (Nat.zero_le _),
     Nat.le_antisymm (closed f mem c outside).2 (Nat.zero_le _)⟩)''', 1)
for name, text in (('InAmounts', ia), ('LeastLoss', ll), ('Space', sp), ('Premises', pr), ('Openness', op)):
    (OUT / f'{name}.lean').write_text(text)
    print('wrote', name, len(text.splitlines()))
