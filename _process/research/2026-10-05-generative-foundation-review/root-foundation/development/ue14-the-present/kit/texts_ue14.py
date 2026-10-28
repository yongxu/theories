#!/usr/bin/env python3
"""UE14 texts: the home section of the new record, the-present-on-causal-set-growth, in 01 §1 (a theorem paragraph and
a labelled reading after precedence and its links); 01's open entry on presence in time narrowed to it; the overview's
open list; a bullet in 08 §8's known results beyond the table and 08's receipt and counts read from the receipt; the
study section; the UE plan's item 6, its structural gap, its failure list and its owners; the record's and the
module's regions. Every Presence name the texts cite is checked against the scratch build's axiom audit. Mirrors
UE13's texts_ue13.py; every edit is asserted to apply exactly once.
usage (from the checkout root of the landing worktree, after the checker): python3 -B <kit>/texts_ue14.py RECEIPT N"""
import json
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
RECEIPT, N = sys.argv[1], int(sys.argv[2])
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
CH = ROOT / 'theories/becoming/chapters'
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation'
STUDY = ROOT / RF / 'BECOMING-RENEWAL-READING.md'
REGIONS = ROOT / 'theories/becoming/results/data/regions.json'
RID = 'the-present-on-causal-set-growth'
RIDP = 'precedence-and-its-links'
RIDG = 'what-can-be-born-next'
KIT = f'../../../{RF}/development/ue14-the-present/NOTE.md'
AUDIT = HERE.parent / 'tree/.build/BecomingPresenceAxiomAudit.lean'
NAMES = set(re.findall(r'^#print axioms Becoming\.(\S+)$', AUDIT.read_text(encoding='utf-8'), re.M))


def cited(text):
    """Every backticked name of the module the text cites is a declaration of it."""
    found = set(re.findall(r'`(Presence\.[A-Za-z_.]+)`', text))
    missing = sorted(n for n in found if n not in NAMES)
    assert not missing, missing
    return text


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:80], text.count(old))
    path.write_text(text.replace(old, cited(new)), encoding='utf-8')


# 01 §1: the present on causal-set growth, after precedence and its links
edit(CH / '01-ROOT.md', """
The corpus's own definitions (化, 成坏, 同, 复, 通) are written in this grammar""", f"""
<a id="r-{RID}"></a>
**Theorem** (causal-set growth, and witnesses). *The present on causal-set growth.* The grammar has no relation of presence in time ([Open](#open)); causal-set growth ([07 §2](07-SIGNIFICANCE.md#r-{RIDG})) is a model in which one can be read and the question asked exactly. Its labels, the order of births, are taken to carry no physical meaning (discrete general covariance, Rideout and Sorkin 2000), a premise of the model. The renumberings of a causal set keeping precedence, its natural labellings (`Presence.NaturalLabelling`), are exactly the orders of birth of the courses from the empty set growing a configuration of its kind (`Presence.natural_iff_course`), and births of unrelated elements commute, and only they (`Presence.rearranges_iff_natural`, an instance of the core's theorem of Mazurkiewicz). What a course has born by a stage is a stem, and every stem with decided membership is what some course bears first (`Presence.born_stem`, `Presence.stem_born_first`). With precedence decided, an element is born before another on every course exactly where it precedes it (`Presence.prec_iff_every`), so what is born no later than an element on every course is its past with itself, the largest relation every course respects (`Presence.past_every_iff`, `Presence.past_largest`); with precedence weakly decided, it is born before it on some course exactly where the two differ and the other does not precede it (`Presence.before_some_iff`), so no order of birth of unrelated elements is common to all courses (`Presence.either_order`). Read the present at a stage as the maximal elements of what a course has born, where the grammar's ending holds on what is born (`Presence.MaximalBorn`, `Presence.maximalBorn_iff_ends`). It is an antichain (`Presence.maximalBorn_unrelated`), and with precedence weakly decided every antichain given by a test is one (`Presence.antichain_present`); two elements are present together on some course exactly where neither precedes the other, precedence weakly decided, and on every course exactly where they have the same future, precedence decided (`Presence.together_some_iff`, `Presence.together_every_iff`), which is not co-presence, mutual reach. A condition is present at the birth of what it conditions where nothing it precedes is born before (`Presence.PresentAt`): on some course exactly where it is a link below it, precedence weakly decided (`Presence.present_some_iff_link`), and on every course exactly where that is the one element it is linked to, with no decision (`Presence.present_every_iff_only_link`). Asked of every causal set, each calibrated decision is exactly its principle: excluded middle for the decided forms of born before, present together and the least element above on every course, weak excluded middle for the laws on some course (`Presence.every_iff_em`, `Presence.past_every_iff_em`, `Presence.together_every_iff_em`, `Presence.present_least_iff_em`, `Presence.either_order_iff_weakly`, `Presence.present_some_iff_weakly`). On three elements, `0` below `1` and `2`, `0` is present at `2`'s birth on one course and not on another, and the present after two births is exactly `1` on one course and exactly `2` on another (`Presence.Vee.present_swap`, `Presence.Vee.not_present_identity`, `Presence.Vee.maximal_after_two_identity`, `Presence.Vee.maximal_after_two_swap`). On Wüthrich and Callender's four elements their relation, kept by every automorphism, is not what every course has born by a birth, and on those elements it is the past with the pair present together on every course (`Presence.Diamond.kept_not_agreed`, `Presence.Diamond.pastOrPair_iff_together`); elsewhere that join need not be transitive (`Presence.SameFuture.pastOrTogether_not_trans`). Each main law is also stated on the courses of the growth themselves, the runs of its process from the empty set (`Presence.every_course_iff`, `Presence.prec_iff_every_course`, `Presence.present_some_course`, `Presence.present_every_course_only_link`). Each law is near-definitional, a lemma, a witness or a calibration ([record](../results/records/{RID}.md)).

**Reading** [AI reading, D45]. In this model the open question on presence in time has an answer for each reading of presence. Read as being in the configuration, a condition once born is still there when what it conditions is born, on every course, since the growth holds its past; read as Dowker's present, the birth, or as a maximal antichain of the configuration, it is not, whatever the course. Read as being among the maximal elements of what has been born, the answer varies with the course, between two bounds that do not: present on some course exactly at a link, on every course exactly at the one link. Whatever every course keeps, or some course has, is defined from precedence, since the natural labellings are (`Presence.natural_congr`); a relation of presence read on one course, a foliation, is a choice of course. So, given covariance, a premise of the model, the grammar's condition relation defines every relation of presence the growth keeps, and its lack of a primitive relation of presence in time loses no covariant content here. On the growth the continuation condition's scope ([07 §3](07-SIGNIFICANCE.md#condition)) is the same on every course where a thing's future is read as what it conditions, under any class given on the elements, and a choice of course where it is read as what comes after a present stage, or under a class given on the order of births; this bears on scope, not on order, which stays with calling widening better (C) ([study]({KIT})).

The corpus's own definitions (化, 成坏, 同, 复, 通) are written in this grammar""")

# 01's open entry on presence in time, narrowed to what the growth answers
edit(CH / '01-ROOT.md',
     "- **Presence in time.** Whether a condition must still be there when what it conditions arises is not "
     "expressible: the grammar has no relation of presence in time, and adding one is a choice of model; 俱有 is mutual "
     "reach, not this ([06](06-CLASSICAL-TEXTS.md#r-classical-definitions-in-the-grammar)).",
     "- **Presence in time.** Whether a condition must still be there when what it conditions arises is not "
     "expressible: the grammar has no relation of presence in time, and adding one is a choice of model; 俱有 is mutual "
     "reach, not this ([06](06-CLASSICAL-TEXTS.md#r-classical-definitions-in-the-grammar)). On causal-set growth, the "
     f"present read as the maximal elements of what a course has born, it has an answer ([§1](#r-{RID})): presence at "
     "a birth varies with the course between bounds defined from precedence, a link on some course and the one link on "
     "every course. Open: presence on the theory's other models, first the order of exchanges the World's "
     "interleavings leave; continuous time; the present of a center; growths whose courses are weighted.")

# the overview's open list
edit(ROOT / 'theories/becoming/THE-THEORY-OF-BECOMING.md',
     "presence in time, which the grammar cannot state ([02](chapters/02-MAP.md#open), [03](chapters/03-KNOWING.md#open), "
     "[04](chapters/04-LIFE.md#open), [05](chapters/05-COLLECTIVES.md#open)).",
     "presence in time, which the grammar cannot state ([02](chapters/02-MAP.md#open), [03](chapters/03-KNOWING.md#open), "
     "[04](chapters/04-LIFE.md#open), [05](chapters/05-COLLECTIVES.md#open)); on causal-set growth presence is a choice "
     f"of course between bounds defined from precedence ([01](chapters/01-ROOT.md#r-{RID})).")

# 08 §8: known results beyond the table, after UE13's bullet on what can be born next
edit(CH / '08-METHOD.md', """ What is new is reading these against the theory's direction: what widening is read on decides what it ranks. Each law is near-definitional, a witness or a calibration.

**Assessment**""", f""" What is new is reading these against the theory's direction: what widening is read on decides what it ranks. Each law is near-definitional, a witness or a calibration.
- The present on causal-set growth ([01 §1](01-ROOT.md#r-{RID})) restates order theory on the growth. The natural labellings of a finite order are its linear extensions, connected by exchanging adjacent incomparable elements (Mazurkiewicz's traces, an instance of the core's theorem); a finite order is the intersection of its linear extensions (Szpilrajn 1930; Dushnik and Miller 1941); the prefixes of linear extensions are the down-sets, here the stems with decided membership, Brightwell, Dowker, García, Henson and Sorkin's (2003) characterization of their stem sets, here on finite causal sets; and every antichain is the set of maximal elements of its down-closure. The bounds on presence at a birth, a covering pair and the one upper cover, and on being present together, incomparable and the same future, are elementary consequences, not found stated in these sources, and the calibrations are lemmas. The past is the largest relation every course respects, the relation Stein's theorem (1968, 1991) singles out, here as a maximum and not by uniqueness; Wüthrich and Callender (2017), who find his theorem false for a single causal set, grant this local becoming, and on their four elements their relation is the past joined with being present together on every course, elsewhere not in general. Dowker (2014) reads each birth as the passage of time, births of unrelated elements unordered, as the laws on some course state; her present is a birth, not the maximal elements read here. What is new is reading these as the covariant content of presence: 01's open entry on presence in time has an answer in this model for one reading of presence. Each law is near-definitional, a lemma, a witness or a calibration.

**Assessment**""")

# 08: receipt and counts, every count read from the receipt (as texts_ue13.py)
R = json.loads((ROOT / PKG / 'becoming-checks' / RECEIPT / 'verification.json').read_text())
assert R['status'] == 'passed'
layers = {}
for module in R['modules']:
    count = layers.setdefault(module['layer'], [0, 0])
    count[0] += 1
    count[1] += module['theorems']
assert set(layers) <= {'foundation', 'core', 'instance', 'application'}, set(layers)
modules = sum(v[0] for v in layers.values())
theorems = sum(v[1] for v in layers.values())
assert modules == len(R['core_closure']), (modules, len(R['core_closure']))
ring = layers.get('instance', [0, 0])[0] + layers.get('application', [0, 0])[0]
declarations = sum(len(m['declarations']) for m in R['modules'])
injeq = sum(1 for name, axioms in R['generated_axiom_dependencies'].items()
            if name.endswith('.injEq') and axioms == ['propext'])
assert injeq == len(R['generated_axiom_dependencies']), 'a generated dependency other than injEq on propext'
superseded = len(R['superseded_modules'])
link = f'../../../{PKG}/becoming-checks/{RECEIPT}/verification.json'
counts = (f"At core receipt [`{RECEIPT}`]({link}) (Lean 4.29.1), the closure held {modules} modules "
          f"({layers['foundation'][0]} foundation, {layers['core'][0]} core, {ring} in the instance and application ring) "
          f"and {theorems:,} theorems; the {layers['core'][0]} core modules held {layers['core'][1]:,} of them; "
          f"{declarations:,} declarations were audited; {injeq} generated `injEq` lemmas depend on `propext`; "
          f"{superseded} superseded modules were kept out of the run.")
path = CH / '08-METHOD.md'
s = path.read_text(encoding='utf-8')
s, k = re.subn(r"At core receipt \[`[0-9TZ.]+`\]\([^)]*\) \(Lean 4\.29\.1\), the closure held \d+ modules \(\d+ foundation, "
               r"\d+ core, \d+ in the instance and application ring\) and [\d,]+ theorems; the \d+ core modules held [\d,]+ of "
               r"them; [\d,]+ declarations were audited; \d+ generated `injEq` lemmas depend on `propext`; \d+ superseded "
               r"modules were kept out of the run\.", lambda m: counts, s)
assert k == 1, k
path.write_text(s, encoding='utf-8')

# the study section
mod = next(m for m in R['modules'] if m['module'] == 'Becoming.Presence')
section = (HERE / 'study_ue14.txt').read_text(encoding='utf-8').replace('{N}', str(N)).replace('{RECEIPT}', RECEIPT)
section = section.replace('(COUNTS)', f"({mod['theorems']} theorems in {len(mod['declarations'])} declarations)")
assert '{' not in section and 'TODO' not in section and 'PARAGRAPH' not in section, 'a placeholder left'
assert not re.search(r'RECHECK(?!-UE14)', section), 'the re-check placeholder left'
t = STUDY.read_text(encoding='utf-8')
assert f'\n## {N}. ' not in t and f'\n## {N - 1}. ' in t, N
STUDY.write_text(t.rstrip('\n') + '\n\n' + section.strip('\n') + '\n', encoding='utf-8')

# the UE plan: item 6, the structural gap, the failure list and the owners brought to the landing
PLAN = ROOT / RF / 'development/ue-unified-explanation/PLAN.md'
REC = f'../../../../../../theories/becoming/results/records/{RID}.md'
edit(PLAN,
     " a finer class on links can gain or lose continuation; and the kinds of birth do not reverse precedence "
     f"([record](../../../../../../theories/becoming/results/records/{RIDG}.md)).",
     " a finer class on links can gain or lose continuation; and the kinds of birth do not reverse precedence "
     f"([record](../../../../../../theories/becoming/results/records/{RIDG}.md)). UE14 read the present on the same "
     "growth (§5).")
edit(PLAN,
     "a change with no fixed scheme, a space of rules not given with the carrier, and the present remain.",
     "a change with no fixed scheme and a space of rules not given with the carrier remain. UE14 states the present on "
     "causal-set growth, read as the maximal elements of what a course has born: natural labellings are exactly the "
     "orders of birth, and what every course keeps of presence, or some course has, is defined from precedence, a "
     "condition present at the birth of what it conditions on some course exactly where it is a link (precedence weakly "
     "decided) and on every course exactly where it is the one link (no decision), so between these bounds presence is "
     "a choice of course "
     f"([record]({REC})). The present on the theory's other models, first the World's interleavings, and the present "
     "of a center remain.")
edit(PLAN,
     "Self-changing conditions and presence in time are the known candidates.",
     "Self-changing conditions with no fixed scheme, and presence in time on models other than causal-set growth, are "
     "the known candidates.")
edit(PLAN, "UE0, UE1, UE2, UE1b, UE4, UE5, UE7, UE9, UE10, UE11, UE12 and UE13, and holds UE8.",
     "UE0, UE1, UE2, UE1b, UE4, UE5, UE7, UE9, UE10, UE11, UE12, UE13 and UE14, and holds UE8.")

# regions
reg = json.loads(REGIONS.read_text(encoding='utf-8'))
assert RID not in reg['records'] and 'Becoming.Presence' not in reg['modules']
reg['records'][RID] = {'region': 'root', 'base': 'frame',
                       'note': 'Presence UE14: natural labellings exactly the orders of birth; born before on every '
                               'course precedence, the past the largest relation every course respects; presents '
                               'antichains, every antichain given by a test a present; present together on every course '
                               'the same future; a condition present at a birth on some course a link, on every course '
                               'the one link with no decision; each calibrated decision exact; each main law also on the '
                               'courses; Wuthrich and Callender on the diamond and off it'}
reg['records'] = dict(sorted(reg['records'].items()))
reg['modules']['Becoming.Presence'] = {'region': 'root', 'base': 'frame',
                                       'note': 'UE14 the present on causal-set growth (01 §1)'}
reg['modules'] = dict(sorted(reg['modules'].items()))
REGIONS.write_text(json.dumps(reg, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')
print('texts: 01 §1 paragraph and reading, open entry; overview; 08 bullet and counts:', counts[:90],
      '...; study section', N, '; UE plan; regions')
