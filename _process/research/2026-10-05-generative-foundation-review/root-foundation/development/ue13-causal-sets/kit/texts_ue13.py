#!/usr/bin/env python3
"""UE13 texts: the home sections of the two new records, precedence-and-its-links in 01 §1 (a theorem paragraph and a
labelled reading after the paragraph on cycles) and what-can-be-born-next in 07 §2 (a theorem paragraph and a
labelled reading after tasks and what performs them); a sentence in 07's open entry on the second-order direction;
two bullets in 08 §8's known results beyond the table and 08's receipt and counts read from the receipt; the study
section; the UE plan's item 6 and its owners; the records' and the module's regions. Every CausalGrowth name the
texts cite is checked against the scratch build's axiom audit. Mirrors UE12's texts_ue12.py; every edit is asserted
to apply exactly once.
usage (from the checkout root of the landing worktree, after the checker): python3 -B <kit>/texts_ue13.py RECEIPT N"""
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
RIDP = 'precedence-and-its-links'
RIDG = 'what-can-be-born-next'
KIT = f'../../../{RF}/development/ue13-causal-sets/NOTE.md'
AUDIT = HERE.parent / 'tree/.build/BecomingCausalGrowthAxiomAudit.lean'
NAMES = set(re.findall(r'^#print axioms Becoming\.CausalGrowth\.(\S+)$', AUDIT.read_text(encoding='utf-8'), re.M))


def cited(text):
    """Every backticked name of the module the text cites is a declaration of it."""
    found = re.findall(r'`((?:CausalGrowth|OmegaPlusOne|Finer|Kinds|Undecided|Halves|Starts)\.[A-Za-z_.]+)`', text)
    missing = sorted({n for n in found
                      if (n[len('CausalGrowth.'):] if n.startswith('CausalGrowth.') else n) not in NAMES})
    assert not missing, missing
    return text


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:80], text.count(old))
    path.write_text(text.replace(old, cited(new)), encoding='utf-8')


# 01 §1: precedence and its links, after the paragraph on cycles
edit(CH / '01-ROOT.md', """
The corpus's own definitions (化, 成坏, 同, 复, 通) are written in this grammar""", f"""
<a id="r-{RIDP}"></a>
**Theorem** (root; orders on the numbers, and witnesses). *Precedence and its links.* The links of a relation, causal set theory's term, are the pairs it relates with nothing it relates between (`CausalGrowth.links`). A link of the reach `«及» R` is a step of `R`, since a chain of two or more steps has a point between (`CausalGrowth.link_of_reach`), so every net whose reach is a relation contains that relation's links, on any carrier (`CausalGrowth.links_least`). Where each element is preceded only by smaller labels, a natural labelling of the numbers, and precedence is decidable, every pair is reached by links, with no finiteness (`CausalGrowth.reach_links`, `CausalGrowth.nat_reach_links`), and with transitivity precedence is exactly the reach of its links (`CausalGrowth.reach_links_iff`): on the finite orders causal-set growth produces ([07 §2](07-SIGNIFICANCE.md#r-{RIDG}); `CausalGrowth.ordered_reach_links_iff`) the links are the least net whose reach is precedence. Deciding what lies between two elements suffices (`CausalGrowth.reach_links_of_decided`) and cannot be dropped: that every pair of every causal set is reached by its links is excluded middle (`CausalGrowth.reach_links_all_iff_em`). Where an interval is infinite the links can fail: on `ω + 1`, the numbers with a top above them all, `0` precedes the top and no chain of links reaches it (`OmegaPlusOne.not_reach_top`). Each law is near-definitional, a witness or a calibration ([record](../results/records/{RIDP}.md)).

**Reading** [AI reading, D45]. Time as the reach of the condition relation (above) holds with the links as the conditions on naturally labelled orders with decided precedence, the finite orders causal set theory grows among them, and there the links are the least conditions it needs; telling a direct condition from a longer chain is deciding whether anything lies between. Where an interval is infinite, precedence is still the reach of a condition relation, itself, since a transitive relation is its own reach, but it need not be the reach of its links ([study]({KIT})).

The corpus's own definitions (化, 成坏, 同, 复, 通) are written in this grammar""")

# 07 §2: what can be born next, after tasks and what performs them
edit(CH / '07-SIGNIFICANCE.md', """
<a id="r-comparison-content-under-regrouping"></a>""", f"""
<a id="r-{RIDG}"></a>
**Theorem** (causal-set growth, and witnesses). *What can be born next against what continues.* Causal set theory takes spacetime to be a locally finite order and grows it one element at a time, each new element born maximal with a set of the existing elements closed downward, a stem, as its past (Rideout and Sorkin 2000); on the orders it grows precedence is the reach of its links ([01 §1](01-ROOT.md#r-{RIDP})). Read as a process every move holds the past (`CausalGrowth.step_holdsPast`), so the possible with the past held is the whole possible (`CausalGrowth.possibleHeld_iff`), and on every course from a causal set what each configuration admits next, its stems, keeps widening (`CausalGrowth.keepsWidening`) inside a whole possible that never grows (`CausalGrowth.stem_possible_from_start`). Of two configurations of one size, every stem of the first is a stem of the second exactly where the second's precedence is included in the first's (`CausalGrowth.stems_included_iff`), and so wherever the elements are carried one to one, as by the inverse of a relabelling (`Kinds.stems_carried_iff`). Of two courses from the empty set, then, one includes the other's stems at every offset exactly where its precedence is included in the other's at every offset, strictly exactly where strictly (`CausalGrowth.rangeIncludes_iff`, `CausalGrowth.rangeIncludes_strict_iff`); it widens them where, besides, the other has a pair it lacks (`CausalGrowth.rangeWidens_of`), and with precedence decided only there (`CausalGrowth.rangeExceeds_iff_pair`), finding that pair for every two courses being excluded middle (`CausalGrowth.pair_converse_iff_em`). Widening adds no continuation of any class read on precedence (`CausalGrowth.continuation_of_rangeIncludes`), and most of these comparisons fail without the empty start (`Starts.strict_needs_starts`). Read on what continues within the one class the inclusion is reversed (`CausalGrowth.rangeIncludes_continuing_iff`), and no strict order contains both widenings (`CausalGrowth.no_order_contains_both`): on what can be born next the course of births with empty pasts is above every course with a pair, and nothing continues in it in any class (`CausalGrowth.antichain_rangeWidens`, `CausalGrowth.antichain_begins_ends`); the chain, every birth above every element, has the most continuation of every class read on precedence (`CausalGrowth.continuation_le_chain`); read on both together neither of two such courses widens the other, and two courses one of which lacks a pair of the other are mixed (`CausalGrowth.not_rangeWidens_formsOrContinues`, `CausalGrowth.mixed_of_pair`). On every configuration every element ceases, so the grammar's renewal without end holds on none (`CausalGrowth.ordered_not_renews`); of the extremes' limits only the chain's renews without end, under a class pairing neighbours (`CausalGrowth.antichainLimit_not_renews`, `CausalGrowth.chainLimit_renews`). Read on links a finer class can gain or lose continuation by widening (`Finer.continues`, `Finer.not_continues`, `Finer.loses`), and up to relabelling the kinds of birth do not reverse the inclusion of precedence: at offset 2 the antichain's births above either element are of one kind, and neither extreme's kinds of birth are among the other's (`Kinds.antichain_two_stems_one_kind`, `Kinds.not_included_antichain_chain`, `Kinds.not_included_chain_antichain`), while the order on courses stays labelled: two courses growing configurations of one kind from offset 2 on each exceed the other's stems (`Kinds.wide_swapped_isomorphic`, `Kinds.wide_swapped_mixed`). Each law is near-definitional, a witness or a calibration ([record](../results/records/{RIDG}.md)).

**Reading** [AI reading, D45]. Causal set theory leaves open which course of its growth is better; what the growth bears on, for the theory's direction, is what calling widening better (C) is read on, a first-order matter. Read on what can be born next, widening loses precedence and ranks highest the course in which nothing conditions anything, where nothing continues; read on what continues, the chain. The continuation condition counts every continuation's losses ([§3](#condition)), and every widening of what can be born next loses continuation, so with the scope it fixes the reading is on both together: there no course widens another, two courses differing by a pair are mixed, and ordering them needs a measure ([above](#r-four-cases-of-a-part)), a premise beyond C and the condition. The second order is not reached: every course keeps widening what can be born next, and a direction never reversing widening, read on stems, ranks nothing above the antichain (`CausalGrowth.not_above_antichain`). In the grammar 生生 names only renewal without end, which holds on no configuration and, of the extremes' limits, only on the chain's; the 生生 meant is generation generating generation ([01 §6](01-ROOT.md#renewal-and-grains)), which asks more than renewal of lines, and it is not the order read on what can be born next, since the widest course transmits no condition. Kauffman's tentative law that a biosphere may, on average, enter its adjacent possible as fast as it can sustain, read on the pasts, has its widest course lose all precedence; read on kinds of birth, closer to his kinds of events and to causal set theory's covariance, the extremes are incomparable at offset 2, and a count to five elements, a computation, finds them with the fewest kinds; counting is scale, which the second-order direction does not count ([study]({KIT})).

<a id="r-comparison-content-under-regrouping"></a>""")

# 07's open entry on the second-order direction: what causal-set growth adds
edit(CH / '07-SIGNIFICANCE.md', " The candidate left is what carries a course's openings.",
     f" On causal-set growth ([§2](#r-{RIDG})) every course keeps widening what can be born next, so the second order "
     f"is not told apart there; the growth bears on what widening is read on: on what can be born next it ranks "
     f"highest the course in which nothing continues, on what continues the chain, no strict order contains both, and "
     f"with every continuation's losses counted the reading is on both together, where C ranks no two courses. "
     f"The candidate left is what carries a course's openings.")

# 08 §8: known results beyond the table, after UE12's bullet
edit(CH / '08-METHOD.md', """ A delivery adds nothing to the whole possible, and widening follows deliveries in neither direction, ranking a delivered output above its input on one witness and below it on another: what possible tasks carry is the inclusion of the whole possible, not widening. Each law is near-definitional or a witness.

**Assessment**""", f""" A delivery adds nothing to the whole possible, and widening follows deliveries in neither direction, ranking a delivered output above its input on one witness and below it on another: what possible tasks carry is the inclusion of the whole possible, not widening. Each law is near-definitional or a witness.
- Precedence and its links ([01 §1](01-ROOT.md#r-{RIDP})) restates order theory on the root: the links of causal set theory (Bombelli, Lee, Meyer and Sorkin 1987) are the covering pairs, a locally finite order is the transitive closure of its covering relation, and that can fail where an interval is infinite, as on ω + 1. The Lean proves it for naturally labelled orders with decided precedence, with no finiteness, and calibrates the decision as a lemma: reaching every pair of every such order by links is excluded middle. Each law is near-definitional, a witness or a calibration.
- What can be born next ([07 §2](07-SIGNIFICANCE.md#r-{RIDG})) reads Rideout and Sorkin's classical sequential growth (2000) as a process: internal temporality as holding the past, the timid and gregarious children as the chain's and the antichain's births. That stems reverse the inclusion of precedence is the order-reversing correspondence between orders on one set and their down-sets, the specialization order of an Alexandrov topology, with Birkhoff's representation of finite distributive lattices a neighbour; finding the pair a widening loses is excluded middle, a lemma, and most comparisons of two courses need the empty start. Kauffman's adjacent possible (2000) is read for a prestated space, as what can be born next, and his tentative law, as two reviews report it, leads on the pasts to the course in which nothing continues and on kinds of birth to extremes incomparable at offset 2, a count to five elements, a computation, finding configurations mixing precedence and unrelated elements with the most kinds. Discrete general covariance is read only as relabelling; transition probabilities, Bell causality and the continuum limit are not read. What is new is reading these against the theory's direction: what widening is read on decides what it ranks. Each law is near-definitional, a witness or a calibration.

**Assessment**""")

# 08: receipt and counts, every count read from the receipt (as texts_ue12.py)
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
mod = next(m for m in R['modules'] if m['module'] == 'Becoming.CausalGrowth')
section = (HERE / 'study_ue13.txt').read_text(encoding='utf-8').replace('{N}', str(N)).replace('{RECEIPT}', RECEIPT)
section = section.replace('(COUNTS)', f"({mod['theorems']} theorems in {len(mod['declarations'])} declarations)")
assert '{' not in section and 'TODO' not in section and 'PARAGRAPH' not in section, 'a placeholder left'
t = STUDY.read_text(encoding='utf-8')
assert f'\n## {N}. ' not in t and f'\n## {N - 1}. ' in t, N
STUDY.write_text(t.rstrip('\n') + '\n\n' + section.strip('\n') + '\n', encoding='utf-8')

# the UE plan: item 6 and the owners brought to the landing
PLAN = ROOT / RF / 'development/ue-unified-explanation/PLAN.md'
edit(PLAN,
     "The containment would state the root's laws on causal sets and ask what continuation relative to a class adds "
     "to an order: patterns that last, on spacetime read as order.",
     "The containment would state the root's laws on causal sets and ask what continuation relative to a class adds "
     "to an order: patterns that last, on spacetime read as order. UE13 landed on "
     f"{sys.argv[3] if len(sys.argv) > 3 else '28 October'} with two records. Precedence and its links: on naturally "
     "labelled orders with decided precedence, the finite causal sets among them, precedence is the reach of its "
     "links, the least net whose reach it is; the decision cannot be dropped, and on ω + 1 the links fail "
     f"([record](../../../../../../theories/becoming/results/records/{RIDP}.md)). What can be born next against what "
     "continues: sequential growth is a process holding the past, on whose every course from a causal set what can be "
     "born next keeps widening; its stems reverse the inclusion of precedence, labelled or up to relabelling, so "
     "widening adds no continuation; finding the pair a widening loses is excluded middle; read on what continues the "
     "order reverses, no strict order contains both, and read on both, courses differing by a pair are mixed; most "
     "comparisons need the empty start; no configuration renews without end; a finer class on "
     "links can gain or lose continuation; and the kinds of birth do not reverse precedence "
     f"([record](../../../../../../theories/becoming/results/records/{RIDG}.md)).")
edit(PLAN, " The second-order direction of 生生, a range whose widening keeps widening, is the theory's least formalized "
     "part",
     " UE13 (item 6) read the adjacent possible on causal-set growth as what can be born next: what widening ranks there "
     "depends on what it is read on, the course in which nothing continues on what can be born next and the chain on "
     "what continues; with every continuation's losses counted the reading is on both together, where C ranks no two "
     "courses and ordering them needs a measure beyond C and the condition; and the second order is not "
     f"told apart, every course keeping widening ([record](../../../../../../theories/becoming/results/records/{RIDG}.md)). "
     "The second-order direction of 生生, a range whose widening keeps widening, is the theory's least formalized part")
edit(PLAN, "UE0, UE1, UE2, UE1b, UE4, UE5, UE7, UE9, UE10, UE11 and UE12, and holds UE8.",
     "UE0, UE1, UE2, UE1b, UE4, UE5, UE7, UE9, UE10, UE11, UE12 and UE13, and holds UE8.")
edit(PLAN, "Items 6 and 8 are unclaimed; claim them on the board.",
     "Item 8 is unclaimed; claim it on the board.")

# regions
reg = json.loads(REGIONS.read_text(encoding='utf-8'))
assert RIDP not in reg['records'] and RIDG not in reg['records']
assert 'Becoming.CausalGrowth' not in reg['modules']
reg['records'][RIDP] = {'region': 'root', 'base': 'grammar',
                        'note': 'CausalGrowth UE13: precedence the reach of its links on naturally labelled orders with '
                                'decided precedence, the links the least such net; deciding what lies between not '
                                'droppable (excluded middle); not on omega + 1'}
reg['records'][RIDG] = {'region': 'significance', 'base': 'frame',
                        'note': 'CausalGrowth UE13: sequential growth holding the past, what can be born next keeping '
                                'widening; the stems reverse the inclusion of precedence, labelled or up to '
                                'relabelling, so widening adds no continuation; finding the lost pair excluded '
                                'middle; read on what continues the order reverses, no strict order holds both; no '
                                'configuration renews without end; a finer class on links; kinds of birth not so '
                                'ordered'}
reg['records'] = dict(sorted(reg['records'].items()))
reg['modules']['Becoming.CausalGrowth'] = {'region': 'significance', 'base': 'frame',
                                           'note': 'UE13 causal sets: precedence and its links (01 §1), and what can '
                                                   'be born next against what continues (07 §2)'}
reg['modules'] = dict(sorted(reg['modules'].items()))
REGIONS.write_text(json.dumps(reg, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')
print('texts: 01 §1 paragraph and reading; 07 §2 paragraph and reading, open entry; 08 bullets and counts:',
      counts[:90], '...; study section', N, '; UE plan; regions')
