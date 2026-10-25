#!/usr/bin/env python3
"""OC1 texts, after PF2 has landed. 07 §4.6: P2 read at one's own class; the home section of the new record (a Theorem
block before the Argument); step 4 and the conclusion cite the forms at the member's class; the organism's failure at its
class; which class P2 reads; PF2's Open item, now answered, removed. The philosophers' dossier P-20: its statement of
P2. The study section; the record's region.
usage (from the checkout root of the landing worktree, after the checker): python3 -B <kit>/texts_oc1.py RECEIPT N"""
import json
import sys
from pathlib import Path

ROOT = Path.cwd()
RECEIPT, N = sys.argv[1], int(sys.argv[2])
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
CH7 = ROOT / 'theories/becoming/chapters/07-SIGNIFICANCE.md'
PHIL = ROOT / 'theories/becoming/review/PHILOSOPHY.md'
STUDY = ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'
REGIONS = ROOT / 'theories/becoming/results/data/regions.json'
RID = 'constancy-read-at-a-members-class'


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:90], text.count(old))
    path.write_text(text.replace(old, new), encoding='utf-8')


# P2, read at one's own class
edit(CH7, """- (P2) The self whose continuation is presupposed is a line under a class on the root ([§4.5](#condition-on-the-root)), and that class is constant up to the net's end: a regularity of its own, whose line ends only where the net itself ends.""",
     f"""- (P2) The self whose continuation is presupposed is a line under a class on the root ([§4.5](#condition-on-the-root)), and that class is constant up to the net's end at oneself, asked only of what is alike to oneself ([above](#r-{RID})): a regularity of its own, whose line ends only where the net itself ends.""")

# the home section, after PF2's block and before the Argument
block = f"""<a id="r-{RID}"></a>
**Theorem** (root; any type, and witnesses). *Constancy read at a member's class, and how what lies outside it is divided.*

- **At a member's class.** Constancy up to the net's end asks its condition of every two alike occurrences, so it constrains every block of a class, what lies outside a member's class included. Asked only of the occurrences alike to a member, it is constancy up to the net's end *at the member's class* (`«本类至终有常»`), and constancy up to the net's end is that at every member's class (`«至终有常之逐类»`).
- **The laws need no more.** Each law above that asks constancy up to the net's end uses only occurrences alike to the member, so each holds at the member's class, and the forms above are corollaries (`«本类常闭则所缘同类»`, `«本类常闭则后皆续»`, `«本类常闭则所及皆及»`, `«本类常则闭当且仅当后皆同类»`, `«本类出类随行»`, `«本类出类随线»`, `«出类不随则本类不至终有常»`). A line that ends while it still conditions something fails the condition at its own class (`«亡而网续则本类不至终有常»`), and the organism's class fails it at the first member in both finite witnesses (`FiniteFamilies.member_not_constant_at`, `FiniteSharedCondition.member_not_constant_at`). A family's class, and the class holding the families with their condition, meet it at every member, being constant up to the net's end (`«至终有常之逐类»`, `FiniteFamilies.family_constant_to_end`, `FiniteSharedCondition.held_constant_to_end`).
- **How what lies outside is divided.** It bears on the condition only through "alike to that effect", for an effect that leaves the member's class. Where the class holds the effects of a member that conditions something, every division that gives the member the same class gives the same verdict (`«闭则外分无关»`). Merging what lies outside keeps the condition (`«外合不失本类之常»`), so where a predicate decides the member's class, the split into that class and the rest (`«二分»`) asks least (`«本类之常至二分»`). Under the split the condition at the member's class is exactly this: where an occurrence alike to the member conditions something in the class, every alike occurrence that conditions anything does; and where one conditions something outside, every alike occurrence that conditions anything does (`«二分本类常当且仅当内外皆随»`).
- **Witnesses.**
  - Dividing what lies outside more finely can break the condition. Where a member and an occurrence alike to it each condition something outside, in two different places, the split meets the condition without holding the member's effects, and dividing the two places apart, with the member's class unchanged, does not (`FinerOutside.split_constant_at`, `FinerOutside.not_held`, `FinerOutside.finer_not_constant_at`, `FinerOutside.same_class`).
  - Constancy up to the net's end can fail under the split while the member's class keeps the condition. Where two occurrences alike outside differ in whether they condition something in the member's class, the split meets the condition at the member and holds its effects but is not constant up to the net's end, and a finer division of what lies outside, with the member's class unchanged, is (`UnevenOutside.split_constant_at`, `UnevenOutside.held`, `UnevenOutside.split_not_constant_to_end`, `UnevenOutside.finer_constant_to_end`, `UnevenOutside.same_class`).

([record](../results/records/{RID}.md))

"""
edit(CH7, "**Argument** [AI reading; each step cites its Lean, and the joining of the steps is argued]. Premises:",
     block + "**Argument** [AI reading; each step cites its Lean, and the joining of the steps is argued]. Premises:")

# step 4 and the conclusion: the forms at the member's class
edit(CH7, """on one's own line wherever one's line reaches it (`«至终常闭则后皆续»`, `«至终常闭则所及皆及»`). The witnesses read narrowly:""",
     """on one's own line wherever one's line reaches it (`«本类常闭则后皆续»`, `«本类常闭则所及皆及»`). The witnesses read narrowly:""")
edit(CH7, """reaches everything downstream of what one conditions (`«至终常闭则所及皆及»`): across lines""",
     """reaches everything downstream of what one conditions (`«本类常闭则所及皆及»`): across lines""")
edit(CH7, """Given the regularity of P2, P4 is equivalent to everything downstream of one's acts being alike to oneself (`«至终常类之闭当且仅当后皆同类»`), and what is alike to oneself downstream lies on one's line from there (`«至终常闭则后皆续»`).""",
     """Given the regularity of P2, P4 is equivalent to everything downstream of one's acts being alike to oneself (`«本类常则闭当且仅当后皆同类»`), and what is alike to oneself downstream lies on one's line from there (`«本类常闭则后皆续»`).""")

# the organism, and which class P2 reads
edit(CH7, """  - The organism's class fails P2 wherever its last stage conditions anything (`«亡而网续则不至终有常»`): its line ends while what it conditions goes on, so it is no regularity of its own. Denying P2 is coherent, since one can presuppose the significance of a line that ends.""",
     f"""  - The organism's class fails P2 wherever its last stage conditions anything (`«亡而网续则本类不至终有常»`): its line ends while what it conditions goes on, so it is no regularity of its own. Denying P2 is coherent, since one can presuppose the significance of a line that ends.
  - *Which class P2 reads* [AI reading]. P2 asks constancy up to the net's end only at one's own class. The path uses no more ([above](#r-{RID})). Over the whole class the condition would ask the same of every block of what lies outside one (`«至终有常之逐类»`), which is no regularity of one's own: in `UnevenOutside` the split of oneself from the rest fails it, though one's own class keeps the condition and holds one's effects. So read, P2 is idle to how what one leaves out is divided wherever one acts and holds one's effects (`«闭则外分无关»`), and so for the path's conclusion, which needs P4. Where one does not hold them, the division enters P2 only through what is alike to an effect one leaves out. Finer divisions sort what one leaves out by kind and ask each kind to recur (`FinerOutside`); that sorting bears on which effects are one's own, P4's question, not on whether one's line ends before the net does. Under the split of oneself from the rest, which asks least, P2 asks only this: where any occurrence alike to oneself conditions something in one's class, every alike occurrence that goes on does, and where any conditions something outside, every one that goes on does (`«二分本类常当且仅当内外皆随»`). So it passes a self drawn by what one intends wherever every occurrence alike to that self that goes on both conditions something in its class and leaves something outside.""")

# PF2's Open item is answered here
edit(CH7, """- **How finely a self's class divides what it leaves out** ([§4.6](#future-path)): constancy up to the net's end constrains every block of a class, the outside included, and asks that what is alike to each effect leaving a block follow every alike step that goes on (`«出类随行»`); so the division of what one leaves out fixes how much P2 asks of the agential self. Which class P2 should read, and whether it should constrain only the self's block, is open.
""", "")

# the philosophers' dossier: P-20's statement of P2 (its quotation unchanged)
edit(PHIL, """- (P2) The self whose continuation is presupposed is a line under a class on the root, and that class is constant up to the net's end: Quote""",
     """- (P2) The self whose continuation is presupposed is a line under a class on the root, and that class is constant up to the net's end at oneself, asked only of what is alike to oneself: Quote""")

edit(PHIL, "under P2 and P4, everything downstream of one's acts lies on one's line (`«至终常闭则后皆续»`, `«至终常闭则所及皆及»`, root theorems)",
     "under P2 and P4, everything downstream of one's acts lies on one's line (`«本类常闭则后皆续»`, `«本类常闭则所及皆及»`, root theorems at one's own class)")
edit(PHIL, "being alike to oneself (`«至终常类之闭当且仅当后皆同类»`), and neither premise can be dropped",
     "being alike to oneself (`«本类常则闭当且仅当后皆同类»`), and neither premise can be dropped")

R = json.loads((PKG / 'becoming-checks' / RECEIPT / 'verification.json').read_text())
assert R['status'] == 'passed'
mod = next(m for m in R['modules'] if m['module'] == 'Becoming.GrammarPath')
assert not any(mod['axiom_dependencies'].values())
study = (Path(__file__).resolve().parent / 'study_oc1.txt').read_text(encoding='utf-8')
study = (study.replace('{N}', str(N)).replace('RECEIPT_ID', RECEIPT).replace('THEOREMS', str(mod['theorems']))
         .replace('DECLS', str(len(mod['declarations']))))
assert '{N}' not in study and 'THEOREMS' not in study and 'DECLS' not in study
t = STUDY.read_text(encoding='utf-8')
assert f'\n## {N}. ' not in t and '(OC1)' not in t
STUDY.write_text(t.rstrip('\n') + '\n\n' + study.strip('\n') + '\n', encoding='utf-8')

reg = json.loads(REGIONS.read_text(encoding='utf-8'))
assert RID not in reg['records']
reg['records'][RID] = {'region': 'significance', 'base': 'grammar',
                       'note': "GrammarPath: constancy up to the net's end read at a member's class, and the division of what lies outside"}
reg['records'] = dict(sorted(reg['records'].items()))
REGIONS.write_text(json.dumps(reg, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')
print('texts: 07 §4.6 (P2, block, step 4, conclusion, organism, which class P2 reads, Open item); P-20; study', N, '; region')
