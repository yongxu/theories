#!/usr/bin/env python3
"""UE4 texts: the home section of the new record (07 §2: a theorem paragraph after widening along a reading, beside the
order of widening, and a labelled reading that the second-order direction of 生生 stays open; an item in the chapter's
Open list), a bullet in 08 §8's known results beyond the table and 08's receipt and counts read from the receipt, the
study section, and the record's and the modules' regions. Mirrors UE1's texts_ue1.py.
usage (from the checkout root of the landing worktree, after the checker): python3 -B <kit>/texts_ue4.py RECEIPT N"""
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
RID = 'eventual-widening'
KIT = '../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ue4-second-order/DESIGN.md'


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:80], text.count(old))
    path.write_text(text.replace(old, new), encoding='utf-8')


# 07 §2: the theorem and the reading, after widening along a reading, beside the order of widening
edit(CH / '07-SIGNIFICANCE.md', """
<a id="r-comparison-content-under-regrouping"></a>""", f"""
<a id="r-{RID}"></a>
**Theorem** (World; witnesses). *Widening on late tails, and what carries a widening.* One level path *eventually widens* another where, from some step on, it widens it on every tail, each read on the web from its first step (`Web.EventuallyWidens`): first-order widening read on late tails, not a comparison of growth. Its order laws are widening's; it never reverses widening, and widening or eventual widening is irreflexive and transitive (`Web.Widens.not_eventually_reversed`, `Web.WidensOrEventually.trans`). Where widening orders a pair, eventual widening agrees where the wider course exceeds at arbitrarily late steps (`Web.WidensWithoutEnd.eventually`) and, classically, is silent otherwise. It reads only tails (`Web.EventuallyWidens.of_agree_left`). Read on the sequences of levels, where some course eventually widens a second, eventually widening it and its complement are both dense, the first course varied and the second fixed, so the verdict is neither verifiable nor refutable and a practice fixed by the record can keep it against every record (`Web.eventually_neither`, `Web.eventually_insulated`; [03 §5](03-KNOWING.md#r-what-a-finite-stretch-verifies)). A course whose admissions a list holds eventually widens nothing (`Web.not_eventually_of_listed`), so the weighting characterization of C is silent on it. A course *keeps widening* along a continuation where nothing admitted is lost and something keeps being opened (`Web.KeepsWidening`): by name over a listed type none does (`Web.KeepsWidening.not_listed`); a course wider at every step can fail to (`OwnCondition.not_monotone`); along a supplied continuation re-formation counts as opening (`MergedWitness.keeps_widening_along_merge`); and a course keeping widening eventually widens a range admitting alike on what it admits at some step (`Web.KeepsWidening.eventually_widens_of_within`). **Theorem** (witnesses): a burst widens a rising course up to step 0, the two are mixed over every step, and the rising course eventually widens the burst and keeps widening (`OwnCondition.disagreement`); a course keeping every formation of another from one step later is mixed with it in every tail (`LagWitness.lag`). What carries a range is invisible to widening: on one web a relay of openings and a single giver balance with every admission the same, the relay's range opened by the opened (every later gain given by a formation that gained support before) and the single giver's not (`OpeningChain.carried`; the property `Flow.OpenedByOpened` is provisional); a closed cycle is opened by the opened with no widening (`ClosedCycle.cycle`), and ranking by it reverses widening (`Saturated.reverses`). The carrier flows give from nothing, so they do not meet the first law. Every law here is near-definitional, and calling eventual widening better is a premise beyond C, not asserted ([record](../results/records/{RID}.md)).

**Reading** [AI reading, D45]. Eventual widening is the long-run form of widening, and it does not give the second-order direction of 生生: a range whose widening keeps widening, compared with one merely wider now, stays open. Eventual widening needs no growth, a steady course eventually widening one that collapses, and it is silent where a course keeps every formation of another one step later. What a course keeps reachable, and what carries its openings, are where the second order would be read; neither has a law yet, and a law relating 生成 to widening stays open ([02](02-MAP.md#open)). Calling eventual widening better would rank every loss confined to a finite stretch below one formation more at arbitrarily late steps: the unlimited continuation priority that the priority of basic conditions rejects, with verdicts insulable against every record ([study]({KIT})).

<a id="r-comparison-content-under-regrouping"></a>""")

# 07: Open list
edit(CH / '07-SIGNIFICANCE.md', """- <a id="r-universal-practical-warrant"></a>**A universal practical warrant**""",
     f"""- **The second-order direction of 生生** ([§2](#r-{RID})): a comparison of a range whose widening keeps widening with one merely wider now, never reversing widening and counting neither novelty nor scale. Eventual widening, first-order widening read on late tails, does not give it, and is silent on a lag. The candidates are what a course keeps reachable and what carries its openings; the first law needed ties one of them to the World's premises, such as a range that keeps widening needing gain from beyond, or its givers to multiply.
- <a id="r-universal-practical-warrant"></a>**A universal practical warrant**""")

# 08 §8: known results beyond the table, at the end of the list
edit(CH / '08-METHOD.md', """

**Assessment** (the market model of [05](05-COLLECTIVES.md), read against conventional control).""",
     f"""
- Eventual widening ([07 §2](07-SIGNIFICANCE.md#r-{RID})) is the inclusion form of a tail criterion, and a criterion reading only tails is a dictatorship of the future (Chichilnisky 1996). That its verdicts are dense both ways is liveness in Alpern and Schneider's sense (1985). That, with finitely many admissions at each step, it entails overtaking (von Weizsäcker 1965; Gale 1967) and not conversely is an argument, not proved in Lean. Every law of the record is near-definitional; what it adds is its coherence with widening and its witnesses, the lag among them.

**Assessment** (the market model of [05](05-COLLECTIVES.md), read against conventional control).""")

# 08: receipt and counts, every count read from the receipt (as texts_ue1.py)
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
section = (HERE / 'study_ue4.txt').read_text(encoding='utf-8').replace('{N}', str(N)).replace('{RECEIPT}', RECEIPT)
t = STUDY.read_text(encoding='utf-8')
assert f'\n## {N}. ' not in t
STUDY.write_text(t.rstrip('\n') + '\n\n' + section.strip('\n') + '\n', encoding='utf-8')

# regions
reg = json.loads(REGIONS.read_text(encoding='utf-8'))
assert RID not in reg['records']
assert 'Becoming.EventualWidening' not in reg['modules'] and 'Becoming.EventualWideningInstances' not in reg['modules']
reg['records'][RID] = {'region': 'significance', 'base': 'old-base',
                       'note': 'EventualWidening UE4: widening read on late tails, keeping widening, carriers invisible to widening'}
reg['records'] = dict(sorted(reg['records'].items()))
reg['modules']['Becoming.EventualWidening'] = {'region': 'significance', 'base': 'old-base',
                                               'note': 'UE4 eventual widening (widening on late tails) and keeping widening'}
reg['modules']['Becoming.EventualWideningInstances'] = {'region': 'significance', 'base': 'old-base',
                                                        'note': "UE4 eventual widening's frame, listing and witnesses; what carries a widening"}
reg['modules'] = dict(sorted(reg['modules'].items()))
REGIONS.write_text(json.dumps(reg, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')
print('texts: 07 §2 paragraph, reading and Open item; 08 bullet and counts:', counts[:90], '...;',
      'study section', N, '; regions')
