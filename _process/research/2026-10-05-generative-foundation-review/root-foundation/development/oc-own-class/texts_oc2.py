#!/usr/bin/env python3
"""OC2 texts, after the checker: the fixes the independent review of OC1 found. 07 §4.6: the home section (what lies
outside enters only through effects that leave; the condition asks more than line-ending; Inconstant at the member's
class; the sufficient condition under the split; the witnesses as nets), P2 (the condition, its gloss a consequence),
step 2 and the conclusion (the forms at one's own class, P4 named), the organism, which class P2 reads. The
philosophers' dossier: P-20's P2, step 2, conclusion and third question, and the summary of constancy before it. The
study section (OC2). With `--pf`, also PF's and PF2's "goes on" in 07 §4.6, on the PF line owner's yes.
usage (from the checkout root of the landing worktree, after the checker): python3 -B <kit>/texts_oc2.py RECEIPT N [--pf]"""
import json
import sys
from pathlib import Path

ROOT = Path.cwd()
RECEIPT, N = sys.argv[1], int(sys.argv[2])
PF = '--pf' in sys.argv[3:]
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
CH7 = ROOT / 'theories/becoming/chapters/07-SIGNIFICANCE.md'
PHIL = ROOT / 'theories/becoming/review/PHILOSOPHY.md'
STUDY = ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'
RID = 'constancy-read-at-a-members-class'


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:90], text.count(old))
    path.write_text(text.replace(old, new), encoding='utf-8')


# the home section: the laws need no more
edit(CH7, """and the organism's class fails it at the first member in both finite witnesses (`FiniteFamilies.member_not_constant_at`, `FiniteSharedCondition.member_not_constant_at`). A family's class, and the class holding the families with their condition, meet it at every member, being constant up to the net's end (`«至终有常之逐类»`, `FiniteFamilies.family_constant_to_end`, `FiniteSharedCondition.held_constant_to_end`).""",
     """and the organism's class fails it at the first member in both finite witnesses (`FiniteFamilies.member_not_constant_at`, `FiniteSharedCondition.member_not_constant_at`). The condition asks more than that a line end only where the net does: in `CleanStep` every line from the member ends only where the net does, and the class still fails the condition at the member (`CleanStep.ends_where_net_ends`, `CleanStep.not_constant_at`). A family's class, and the class holding the families with their condition, meet it at every member, being constant up to the net's end (`«至终有常之逐类»`, `FiniteFamilies.family_constant_to_end`, `FiniteSharedCondition.held_constant_to_end`); the class of `Inconstant`, which holds the member's effects, fails it at the member (`Inconstant.not_constant_at`).""")

# the home section: how what lies outside is divided
edit(CH7, """- **How what lies outside is divided.** It bears on the condition only through "alike to that effect", for an effect that leaves the member's class. Where the class holds the effects of a member that conditions something, every division that gives the member the same class gives the same verdict (`«闭则外分无关»`).""",
     """- **How what lies outside is divided.** It bears on the condition only through what is alike to an effect that leaves the member's class: two classes that give the member the same class, and agree on what is alike to each such effect of an occurrence alike to the member, give the same verdict (`«外分唯系出类之同»`). Where the class holds the effects of a member that conditions something, the condition keeps every alike occurrence's effects in the class (`«本类常闭则所缘同类»`), so every division that gives the member the same class gives the same verdict (`«闭则外分无关»`, applied both ways).""")
edit(CH7, """and where one conditions something outside, every alike occurrence that conditions anything does (`«二分本类常当且仅当内外皆随»`).
- **Witnesses.**""", """and where one conditions something outside, every alike occurrence that conditions anything does (`«二分本类常当且仅当内外皆随»`). So it holds where every alike occurrence that conditions anything conditions something in the class and something outside (`«内外皆缘则二分本类常»`).
- **Witnesses.**""")

# the home section: the witnesses as nets
edit(CH7, """  - Dividing what lies outside more finely can break the condition. Where a member and an occurrence alike to it each condition something outside, in two different places, the split meets the condition without holding the member's effects, and dividing the two places apart, with the member's class unchanged, does not (`FinerOutside.split_constant_at`, `FinerOutside.not_held`, `FinerOutside.finer_not_constant_at`, `FinerOutside.same_class`).
  - Constancy up to the net's end can fail under the split while the member's class keeps the condition. Where two occurrences alike outside differ in whether they condition something in the member's class, the split""",
     """  - Dividing what lies outside more finely can break the condition. In a net where a member conditions one thing outside its class, an occurrence alike to it conditions another, and nothing else is conditioned, the split meets the condition at the member without holding its effects, and dividing the two things apart, with the member's class unchanged, does not (`FinerOutside.split_constant_at`, `FinerOutside.not_held`, `FinerOutside.finer_not_constant_at`, `FinerOutside.same_class`). In a net where the member and an occurrence alike to it each condition one thing in their class and one outside, and nothing else is conditioned, the split meets the condition at the member, and dividing the two outside things apart, with the member's class unchanged, does not (`FinerWake.both`, `FinerWake.split_constant_at`, `FinerWake.finer_not_constant_at`, `FinerWake.same_class`).
  - Constancy up to the net's end can fail under the split while the member's class keeps the condition. In a net where the member conditions something alike to it and, of two occurrences alike outside, one conditions the member and the other only something outside, and nothing else is conditioned, the split""")

# P2: the condition, its gloss a consequence
edit(CH7, f"""and that class is constant up to the net's end at oneself, asked only of what is alike to oneself ([above](#r-{RID})): a regularity of its own, whose line ends only where the net itself ends.""",
     f"""and that class is constant up to the net's end at oneself ([above](#r-{RID})): whatever an occurrence alike to oneself conditions, every occurrence alike to oneself that conditions anything conditions something alike to it. It is a regularity of its own, and one's line ends only where the net itself ends (`«亡而网续则本类不至终有常»`). How the class divides what lies outside oneself enters through what is alike to an effect one leaves out; which division P2 reads is argued below.""")

# step 2: the organism at its own class
edit(CH7, """a family's class is still constant up to the net's end and the organism's is not (`FiniteFamilies`, above).""",
     """a family's class is still constant up to the net's end, and the organism's is not, even at its own class (`FiniteFamilies.family_constant_to_end`, `FiniteFamilies.member_not_constant_at`).""")

# the conclusion: P4 named where it is used; Inconstant at the member's class
edit(CH7, """and what is alike to oneself downstream lies on one's line from there (`«本类常闭则后皆续»`). So the reach rests on one premise, holding one's effects, carried on by the regularity. The regularity does real work: without it, holding one's effects gives nothing beyond the first step (`Inconstant`), and without P4""",
     """and, given P4 as well, everything downstream of one's acts lies on one's line (`«本类常闭则后皆续»`). So the reach rests on one premise, holding one's effects, carried on by the regularity. The regularity does real work: where it fails at one's own class, holding one's effects gives nothing beyond the first step (`Inconstant.not_constant_at`, `Inconstant.not_all_follow`), and without P4""")

# the organism
edit(CH7, """its line ends while what it conditions goes on, so it is no regularity of its own.""",
     """its line ends while its last stage still conditions something, so it is no regularity of its own.""")

# which class P2 reads
edit(CH7, """So read, P2 is idle to how what one leaves out is divided wherever one acts and holds one's effects (`«闭则外分无关»`), and so for the path's conclusion, which needs P4. Where one does not hold them, the division enters P2 only through what is alike to an effect one leaves out. Finer divisions sort what one leaves out by kind and ask each kind to recur (`FinerOutside`); that sorting bears on which effects are one's own, P4's question, not on whether one's line ends before the net does. Under the split of oneself from the rest, which asks least, P2 asks only this: where any occurrence alike to oneself conditions something in one's class, every alike occurrence that goes on does, and where any conditions something outside, every one that goes on does (`«二分本类常当且仅当内外皆随»`). So it passes a self drawn by what one intends wherever every occurrence alike to that self that goes on both conditions something in its class and leaves something outside.""",
     f"""So read, P2 is idle to how what one leaves out is divided wherever one acts and holds one's effects (`«闭则外分无关»`), and so for the path's conclusion, which needs P4. Where one does not hold them, the division enters P2 only through what is alike to an effect one leaves out (`«外分唯系出类之同»`). A finer division sorts what one leaves out by kind and asks each kind to recur at every occurrence alike to oneself that conditions anything (`FinerOutside`). That sorting does not change which effects are alike to oneself, since P4's predicate (`«所缘同于»`) reads only one's own class; what it asks is that one's effects recur by kinds drawn in what lies outside oneself, a regularity read off the rest's division, not off oneself. The split of oneself from the rest draws no kinds there and, where a predicate decides one's class, asks least (`«本类之常至二分»`); so P2 is read with it. Even so it asks more than that one's line end only where the net does (`CleanStep.ends_where_net_ends`, `CleanStep.not_constant_at`): where any occurrence alike to oneself conditions something in one's class, every alike occurrence that conditions anything does, and where any conditions something outside, every one that conditions anything does (`«二分本类常当且仅当内外皆随»`). That is a regularity of one's own acts, of whether they stay or leave. So read, P2 passes a self drawn by what one intends wherever every occurrence alike to that self that conditions anything both conditions something in its class and leaves something outside (`«内外皆缘则二分本类常»`); under a finer division of what it leaves out it can fail even there (`FinerWake`). That P2 is read so is argued here, not proved, and whether actual agents meet it is a correspondence ([record](../results/records/{RID}.md)).""")

if PF:
    edit(CH7, """its line ending at old age while the net goes on (`FiniteFamilies.member_not_constant_to_end`).""",
         """its line ending at old age while that stage still conditions something (`FiniteFamilies.member_not_constant_to_end`).""")
    edit(CH7, """while something outside it follows every step of its line that goes on (`FiniteWake.constant_to_end`""",
         """while something outside it follows every occurrence on its line that conditions anything (`FiniteWake.constant_to_end`""")
    edit(CH7, """has something outside it follow every alike step that goes on ([above](#r-what-leaves-a-class-follows-its-line))""",
         """has something outside it follow every alike occurrence that conditions anything ([above](#r-what-leaves-a-class-follows-its-line))""")

# the philosophers' dossier
edit(PHIL, """- (P2) The self whose continuation is presupposed is a line under a class on the root, and that class is constant up to the net's end at oneself, asked only of what is alike to oneself: Quote [theories/becoming/chapters/07-SIGNIFICANCE.md]: "a regularity of its own, whose line ends only where the net itself ends.\"""",
     """- (P2) The self whose continuation is presupposed is a line under a class on the root, and that class is constant up to the net's end at oneself: whatever an occurrence alike to oneself conditions, every occurrence alike to oneself that conditions anything conditions something alike to it. Quote [theories/becoming/chapters/07-SIGNIFICANCE.md]: "It is a regularity of its own, and one's line ends only where the net itself ends" (`«亡而网续则本类不至终有常»`, a root theorem); the condition asks more than that (`CleanStep.not_constant_at`).""")
edit(PHIL, """a family's class is still constant up to the net's end and the organism's is not (`FiniteFamilies.family_constant_to_end`, `FiniteFamilies.member_not_constant_to_end`). Quote""",
     """a family's class is still constant up to the net's end, and the organism's is not, even at its own class (`FiniteFamilies.family_constant_to_end`, `FiniteFamilies.member_not_constant_at`). Quote""")
edit(PHIL, """neither premise can be dropped (`Unclosed.not_taken_in`, `Inconstant.not_all_follow`).""",
     """neither premise can be dropped (`Unclosed.not_taken_in`, `Inconstant.not_all_follow`, `Inconstant.not_constant_at`).""")
edit(PHIL, """Chapter 7 answers with a weaker regularity, constancy up to the net's end, which in a finite net a family's class meets and the organism's does not (`FiniteFamilies.family_constant_to_end`, `FiniteFamilies.member_not_constant_to_end`; P-20).""",
     """Chapter 7 answers with a weaker regularity, constancy up to the net's end read at one's own class, which in a finite net a family's class meets and the organism's does not, even at its own class (`FiniteFamilies.family_constant_to_end`, `FiniteFamilies.member_not_constant_at`; P-20).""")
edit(PHIL, """3. Is constancy up to the net's end (a line under the class ends only where the net itself ends) a fair reading of a regularity of one's own?""",
     """3. Is constancy up to the net's end at one's own class a fair reading of a regularity of one's own? It asks that whatever an occurrence alike to oneself conditions, every alike occurrence that conditions anything condition something alike to it; so one's line ends only where the net itself ends, though the condition asks more. And should it read the split of oneself from the rest, as the chapter's labelled reading argues, rather than a finer division of what one leaves out?""")

# the study section
R = json.loads((PKG / 'becoming-checks' / RECEIPT / 'verification.json').read_text())
assert R['status'] == 'passed'
mod = next(m for m in R['modules'] if m['module'] == 'Becoming.GrammarPath')
assert not any(mod['axiom_dependencies'].values())
PF_PARAGRAPH = ("""**PF's and PF2's wording.** The same use of "goes on" in PF's and PF2's texts (the module doc, the witness docstrings, 07 §4.6's home sections of PF and PF2 and its denial of P4, the root bullet, the checker scope and the README row) was replaced in this landing on the PF line owner's yes; no statement changed.""" if PF else
                """**Left with the PF line's owner.** PF's and PF2's texts use "goes on" in the same sense: the module doc on `FiniteFamilies` and `FiniteWake`; the docstrings of `FiniteFamilies.step`, `FiniteSharedCondition` and its `step`, `CleanStep` and `FiniteWake`; 07 §4.6's home sections of PF and PF2 and its denial of P4; the root bullet's sentence on what leaves the class; the checker scope; the README row. Their owner was asked on 25 October; they are unchanged here.""")
study = (Path(__file__).resolve().parent / 'study_oc2.txt').read_text(encoding='utf-8')
study = (study.replace('{N}', str(N)).replace('RECEIPT_ID', RECEIPT).replace('THEOREMS', str(mod['theorems']))
         .replace('DECLS', str(len(mod['declarations']))).replace('{PF_PARAGRAPH}', PF_PARAGRAPH))
assert '{N}' not in study and 'THEOREMS' not in study and 'DECLS' not in study and '{PF' not in study
t = STUDY.read_text(encoding='utf-8')
assert f'\n## {N}. ' not in t and f'\n## {N - 1}. ' in t and '(OC2)' not in t
STUDY.write_text(t.rstrip('\n') + '\n\n' + study.strip('\n') + '\n', encoding='utf-8')
print('texts: 07 §4.6 (home section, P2, step 2, conclusion, organism, which class P2 reads' + (', PF\'s wording' if PF else '')
      + '); P-20 and the summary before it; study', N)
