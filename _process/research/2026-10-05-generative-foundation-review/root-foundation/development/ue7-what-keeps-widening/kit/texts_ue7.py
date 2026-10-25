#!/usr/bin/env python3
"""UE7 texts: the home section of the new record (07 §2: a theorem paragraph and a labelled reading after eventual
widening's); eventual widening's carrier sentence (its first form superseded) and its reading (what carries openings now
has laws); 07's Open item on the second-order direction narrowed; 02's support-passed-on paragraph with the uniform form
and 02's Open item on 生成 and widening narrowed; a bullet in 08 §8's known results beyond the table and 08's receipt and
counts read from the receipt; the study section; the record's and the module's regions. Mirrors UE4's texts_ue4.py.
usage (from the checkout root of the landing worktree, after the checker): python3 -B <kit>/texts_ue7.py RECEIPT N"""
import json
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
RECEIPT, N = sys.argv[1], int(sys.argv[2])
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
CH = ROOT / 'theories/becoming/chapters'
STUDY = ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'
REGIONS = ROOT / 'theories/becoming/results/data/regions.json'
RID = 'what-keeping-widening-needs'
KIT = '../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ue7-what-keeps-widening/NOTE.md'


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:80], text.count(old))
    path.write_text(text.replace(old, new), encoding='utf-8')


# 07 §2: eventual widening's first carrier form superseded, and its reading
edit(CH / '07-SIGNIFICANCE.md',
     "the relay's range opened by the opened (every later gain given by a formation that gained support before) and the "
     "single giver's not (`OpeningChain.carried`; the property `Flow.OpenedByOpened` is provisional); a closed cycle is "
     "opened by the opened with no widening (`ClosedCycle.cycle`), and ranking by it reverses widening "
     "(`Saturated.reverses`).",
     "the relay's range opened by the opened (every gain after a step given by a formation that gained support after "
     "that step) and the single giver's not (`OpeningChain.carried`); a closed cycle is opened by the opened with no "
     "widening (`ClosedCycle.cycle`), and ranking by it reverses widening (`Saturated.reverses`). This first form "
     "(`Flow.OpenedByOpened`) is superseded: the uniform law of support passing on fixes a recency form, of which the "
     f"same three facts hold ([below](#r-{RID})).")
edit(CH / '07-SIGNIFICANCE.md',
     "What a course keeps reachable, and what carries its openings, are where the second order would be read; neither "
     "has a law yet, and a law relating 生成 to widening stays open ([02](02-MAP.md#open)).",
     "What a course keeps reachable, and what carries its openings, are where the second order would be read; what one "
     f"course keeping widening needs, and what carries its openings, now have laws ([below](#r-{RID})), but none "
     "compares two courses, and a law relating 生成 to widening stays open ([02](02-MAP.md#open)).")

# 07 §2: the theorem and the reading, after eventual widening's
edit(CH / '07-SIGNIFICANCE.md', """
<a id="r-comparison-content-under-regrouping"></a>""", f"""
<a id="r-{RID}"></a>
**Theorem** (World; witnesses). *What keeping widening needs, and what carries it.* Take a course keeping widening by name on the actual levels, what every formation supported from a step on requires fixed within a finite family of conditions. The family's stock passes every bound and rises at arbitrarily late steps (`Web.KeepsWidening.passes_every_bound`, `Web.KeepsWidening.rises_late`); under the first law, the family without repetition, at arbitrarily late steps the rest gives it net or it is not closed (`Web.KeepsWidening.from_rest_or_open`); and a finite balanced world under the first law has no such course (`Flow.whole_not_keepsWidening`). Passing every bound uses natural-number amounts, a finite family having finitely many configurations within a bound; in a dense order needs approaching a limit could support ever more formations at a bounded stock (argued, not proved in Lean). Under upkeep, every supported formation taking at least a unit a step from a family, the course has ever more takers (`Web.KeepsWidening.more`); with the family balanced on from a step, its replenishment, and with bounded giving per entry its renewers, are bounded from no step on (`Web.KeepsWidening.renewers_unbounded`), entries of the present list counted with repetition. The uniform law of support passing on ([02](02-MAP.md#r-support-passed-on)) fixes the form of *opened by the opened*: every gain from step `K` on given, up to double negation, by a supported formation that gained support within the `K` steps before (`Flow.OpenedByOpenedWithin`). Brief supports give it (`Flow.openedByOpenedWithin_of_brief`), it is monotone in the bound, and it is a change of class from the first form at a fixed origin, the two independent: a late single giver is opened by the opened in the first form only, a lagged relay in the recency form only (`OpeningChain.forms_independent`). Read on the map, nothing lost along a continuation is exactly an endless line of the admitted pattern from every admitted occurrence (`Web.includesAcrossFrom_iff_endless`); along carrying on or passing support, a carrying renewal from a supported occurrence is exactly a passing of support (`Flow.passesSupport_carries_iff`), and where no support lasts `K + 1` steps every supported endless line is 全生成 (`Flow.generation_of_brief`), hence 生成 (`«全生成则生成»`), the generation of the supported pattern. Under the World premises, what is supported descends, up to double negation, along carrying on or passing support from what was supported at every earlier step (`Flow.descends_along_passings`), so along every continuation containing passing of support nothing keeps opening or keeps widening (`Flow.not_keepsWidening_along_passings`); on both readings used, names and passing of support, 全生成 and keeping widening do not hold together. **Theorem** (witnesses): the premises hold together (`Ladder.frontier_witness`, `Ladder.upkept_witness`), and each is needed: nothing lost (`ClosedCycle.bounded_while_opening`), a finite family (`OpeningChain.fixed_but_unbounded`), fixed needs (`Loosening.bounded_while_widening`), the first law (`Source.from_nothing`), upkeep, capacity and balance (`Ladder.upkeep_needed`, `Ladder.capacity_needed`, `Ladder.balance_needed`), brevity (`OpeningChain.brevity_needed`). The first two laws restate open-systems thermodynamics and maintenance scaling, the others are near-definitional, and none compares two courses ([record](../results/records/{RID}.md)).

**Reading** [AI reading, D45]. Keeping widening is a throughput phenomenon: a finite family whose kept widening goes on is fed from beyond, by the rest or across its boundary, and under upkeep its renewers multiply. Under the World premises nothing is new along lineage, which is the theory's form of "every cell from a cell"; a course keeps widening by name only because names leave lineage out. What one course needs does not give the second-order direction of 生生, a comparison of two courses; it says that such a comparison, read along lineage, would have to count as new what lineage does not ([study]({KIT})).

<a id="r-comparison-content-under-regrouping"></a>""")

# 07: the Open item on the second-order direction, narrowed
edit(CH / '07-SIGNIFICANCE.md',
     "Eventual widening, first-order widening read on late tails, does not give it, and is silent on a lag. The "
     "candidates are what a course keeps reachable and what carries its openings; the first law needed ties one of them "
     "to the World's premises, such as a range that keeps widening needing gain from beyond, or its givers to multiply.",
     "Eventual widening, first-order widening read on late tails, does not give it, and is silent on a lag. What one "
     f"course keeping widening needs is known ([§2](#r-{RID})): gain from beyond a finite family, renewers without "
     "bound under upkeep, and, under the World premises, no keeping widening along passing of support; none of it "
     "compares two courses. The candidates for the comparison are what a course keeps reachable and what carries its "
     "openings.")

# 02: support passed on, its uniform form
edit(CH / '02-MAP.md',
     "support runs as a chain of gains, each giver a newer gainer ([record](../results/records/support-passed-on.md)).",
     "support runs as a chain of gains, each giver a newer gainer. Its uniform form fixes the window: a gain across the "
     "step from `S + K` is, up to double negation, given by a supported formation that gained support within the `K` "
     "steps before (`Flow.gain_given_by_recent_gainer_at`, `Flow.gain_given_by_recent_gainer`), and the law above "
     "follows from it with no subtraction; with support decided and the gainer's requirements listed, the giver and "
     f"its step are found ([07 §2](07-SIGNIFICANCE.md#r-{RID})). ([record](../results/records/support-passed-on.md))")

# 02: the Open item on 生成 and widening, narrowed
edit(CH / '02-MAP.md',
     "- Whether a capture loop (§9) is 生成 at some pair of classes, and a law relating the map's 生成 to widening what "
     "can form.",
     "- Whether a capture loop (§9) is 生成 at some pair of classes, and a law relating the map's 生成 to widening what "
     "can form. On the two readings so far, names and passing of support under the World premises, 全生成 and keeping "
     f"widening do not hold together ([07 §2](07-SIGNIFICANCE.md#r-{RID})); open are 生成 on the World where 全生成 "
     "fails, a law on keeping opening or on the widening order beyond that exclusion, and a reading on which the two "
     "hold together.")

# 08 §8: known results beyond the table, at the end of the list
edit(CH / '08-METHOD.md', """ The natural statement, a pace bounded by what flows into the whole, is false: a part of a closed whole rises by drawing on the rest.

**Assessment** (the market model of [05](05-COLLECTIVES.md), read against conventional control).""",
     f""" The natural statement, a pace bounded by what flows into the whole, is false: a part of a closed whole rises by drawing on the rest.
- What keeping widening needs ([07 §2](07-SIGNIFICANCE.md#r-{RID})) restates open-systems thermodynamics and finite recurrence: a finite family whose kept widening goes on is fed from beyond, and a finite, closed, balanced world has none, as open-ended evolution measures unbounded evolution against an isolated system's recurrence (Bedau and others 2000; Adams and others 2017). The TAP equation and assembly theory leave conservation out as stated, and their own variants and remarks supply it (Cortês and others; Sharma and others 2023), so the law is no third part against them. Renewers multiplying under upkeep is maintenance scaling, as in break-even investment (Solow 1956) and the maintenance coefficient (Pirt 1965), which semi-endogenous growth (Jones 1995) leaves out as stated; autocatalytic sets are food-generated (Hordijk and Steel 2012). The exclusion along passing of support is near-definitional, the theory's "every cell from a cell". None of the laws compares two courses, and none is a result no neighbouring field states.

**Assessment** (the market model of [05](05-COLLECTIVES.md), read against conventional control).""")

# 08: receipt and counts, every count read from the receipt (as texts_ue4.py)
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
section = (HERE / 'study_ue7.txt').read_text(encoding='utf-8').replace('{N}', str(N)).replace('{RECEIPT}', RECEIPT)
t = STUDY.read_text(encoding='utf-8')
assert f'\n## {N}. ' not in t and f'\n## {N - 1}. ' in t, N
STUDY.write_text(t.rstrip('\n') + '\n\n' + section.strip('\n') + '\n', encoding='utf-8')

# regions
reg = json.loads(REGIONS.read_text(encoding='utf-8'))
assert RID not in reg['records']
assert 'Becoming.KeepingWidening' not in reg['modules']
reg['records'][RID] = {'region': 'significance', 'base': 'old-base',
                       'note': 'KeepingWidening UE7: what keeping widening needs (gain from beyond, renewers), the '
                               'recency form of opened by the opened, the map law, the exclusion along passing'}
reg['records'] = dict(sorted(reg['records'].items()))
reg['modules']['Becoming.KeepingWidening'] = {'region': 'significance', 'base': 'old-base',
                                              'note': 'UE7 what keeping widening needs, and what carries it'}
reg['modules'] = dict(sorted(reg['modules'].items()))
REGIONS.write_text(json.dumps(reg, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')
print('texts: 07 §2 paragraph and reading, eventual widening revised, 07 Open narrowed; 02 support passed on and Open; '
      '08 bullet and counts:', counts[:90], '...; study section', N, '; regions')
