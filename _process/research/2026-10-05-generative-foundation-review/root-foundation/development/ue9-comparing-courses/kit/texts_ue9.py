#!/usr/bin/env python3
"""UE9 texts: the home section of the new record (07 §2: a theorem paragraph and a labelled reading after what keeping
widening needs); eventual widening's reading pointed to the lag's decision; 07's Open item on the second-order
direction narrowed; UE7's passing laws stated with requirements never loosening, a hypothesis beside the World
premises (07 §2's theorem and reading, 07's and 02's Open items), as UE8's first review found; a bullet in 08 §8's known
results beyond the table and 08's receipt and counts read from the receipt; the study section; the UE plan's item 7
and owners; the record's and the module's regions. Mirrors UE7's texts_ue7.py.
usage (from the checkout root of the landing worktree, after the checker): python3 -B <kit>/texts_ue9.py RECEIPT N"""
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
RID = 'comparing-two-courses-on-what-they-admit'
KIT = '../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ue9-comparing-courses/NOTE.md'


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:80], text.count(old))
    path.write_text(text.replace(old, new), encoding='utf-8')


# 07 §2: eventual widening's reading, the lag now decided
edit(CH / '07-SIGNIFICANCE.md',
     "Eventual widening needs no growth, a steady course eventually widening one that collapses, and it is silent where "
     "a course keeps every formation of another one step later.",
     "Eventual widening needs no growth, a steady course eventually widening one that collapses, and it is silent where "
     f"a course keeps every formation of another one step later, which widening with a lag decides ([below](#r-{RID})).")

# 07 §2: the theorem and the reading, after what keeping widening needs
edit(CH / '07-SIGNIFICANCE.md', """
<a id="r-comparison-content-under-regrouping"></a>""", f"""
<a id="r-{RID}"></a>
**Theorem** (World; witnesses). *Comparing two courses on what they admit.* Two rankings crossed by widening close a cycle: a transitive relation containing widening that ranks `l` above `l'` and `k` above `k'`, where `l'` widens `k` and `k'` widens `l`, ranks `l` above itself (`Web.ranks_self_of_crossed`). On a web of formations on two sides, each requiring its own condition, the course admitting at step `t` one side's formations up to `t` keeps widening by name, and the course admitting at every step the first of them and every formation of the other side admits alike, was wider up to the first step and is mixed with it; with their mirrors under exchanging the sides, the static course of each pair widens the keeping course of the other. So on that web no strict partial order containing widening ranks every course keeping widening by name from the first step above every course that admits alike from it, was wider up to it and is mixed with it (`Sides.no_order_ranks_keeping_over_alike`): the mirrored pair is in that class, and no invariance is needed. For the one pair the cycle needs the exchange (`Sides.keeping_over_alike_cycles`, `Sides.exchange_needed`), and only one verdict is forbidden: a strict partial order containing widening and unchanged by the exchange can rank the other course above the growing one (`Sides.reverse_consistent`), as can one counting scale (`Sides.scale_counts`). The cycle needs a static course admitting infinitely many formations: where the static course's admissions are listed, ranking keeping widening by name over admitting alike is a strict partial order containing widening on every web (`Web.ListedOrder.irrefl`, `Web.ListedOrder.trans`, `Web.ListedOrder.ranks`). Infinite width does not suffice: on a web where no static course includes a course keeping widening by name, a static course no list holds is in the class and the ranking is a strict partial order containing widening (`AllOrSegment.unlisted_consistent`). The listed scope needs "by name": with keeping widening read along a continuation carrying every formation into one, listed static courses close the cycle (`AlongMerging.no_order_ranks_along_listed`). A course *includes another with lag* `d` where every formation the other admits at a step it admits `d` steps later (`Web.IncludesLater`), and *widens it with a lag* where it includes it with some lag and the other includes it with none (`Web.WidensWithLag`). A transitive relation joined to the strict part of a transitive relation containing it is transitive (`strictJoin_trans`), so widening or widening with a lag is a strict partial order containing widening, never reversing it (`Web.WidensOrWithLag.irrefl`, `Web.WidensOrWithLag.trans`, `Web.Widens.not_reversed_withLag`), as are the orders of a lag varying with the formation and of a lag for each admission (`Web.widensOrWithFormationLag_order`, `Web.widensOrEachLater_order`). It is unchanged by every renaming constant across steps (`Web.widensOrWithLag_rename`) but compares formations across steps by name: exchanging two names from step one on changes its verdict, where widening is unchanged by every re-identification (`NamesAcrossSteps.lag_reads_names`); along a continuation the lagged order is unchanged by every re-identification carrying it (`Web.widensOrWithLagAlong_reidentify`). It decides the lag that eventual widening leaves mixed (`LagWitness.decided`), as do lags varying with the formation or for each admission (`LagWitness.formationLag_decides`, `LagWitness.eachLag_decides`) and the *tail order*, the strict part of inclusion with a lag from some step on joined to widening or eventual widening, a strict partial order containing both (`Web.tailOrder_order`, `LagWitness.tailOrder_decides`). On the own-condition web one course eventually widens another that widens it with a lag, so no strict partial order there contains both (`TailAndLag.no_order_contains_both`): the tail order ranks a course above one that admitted a formation it never admits (`TailAndLag.tailOrder_loses`), and widening or widening with a lag never ranks so (`Web.WidensOrWithLag.includesEachLater`). A course *keeps what another keeps* where every formation the other admits at every step from some step on it admits at every step from some step on (`Web.KeepsWhatKept`). Widening or widening with a lag, the order of a lag varying with the formation and the tail order rank only so (`Web.WidensOrWithLag.keepsWhatKept`, `Web.WidensOrWithFormationLag.keepsWhatKept`, `Web.TailOrder.keepsWhatKept`), the order of a lag for each admission need not (`EachLagDrops.eachLag_not_keeping`), and under it the two-sided pair is unranked both ways (`Sides.keeping_reading`). Each law is near-definitional; law 1's one-pair form has the shape of a known incomparability argument in infinite ethics, and no order here is adopted by C ([record](../results/records/{RID}.md)).

**Reading** [AI reading, D45]. On a web of formations on two sides, the second-order direction 07 asks for cannot be "a course that keeps widening by name is better than one merely wider now", read on admitted ranges wherever the two are mixed: a growing course and a fixed one, with their mirrors, already close the cycle, which needs a static course wide enough to include a keeping course of another pair. A lag is decided by counting what early steps admit or by reading only tails, and the two readings rank a pair oppositely, so the choice between them is a premise, as calling eventual widening better is; keeping what the other keeps, which neither novelty nor scale can outweigh, is met by both, though not by a lag for each admission. Widening with a lag is closer to nothing lost across time than to a range whose widening keeps widening; what a course keeps reachable and what carries its openings remain the candidates ([study]({KIT})).

<a id="r-comparison-content-under-regrouping"></a>""")

# 07: the Open item on the second-order direction, narrowed
edit(CH / '07-SIGNIFICANCE.md',
     "Eventual widening, first-order widening read on late tails, does not give it, and is silent on a lag. What one "
     "course keeping widening needs is known ([§2](#r-what-keeping-widening-needs)): gain from beyond a finite family, "
     "renewers without bound under upkeep, and, under the World premises, no keeping widening along passing of support; "
     "none of it compares two courses. The candidates for the comparison are what a course keeps reachable and what "
     "carries its openings.",
     "Eventual widening, first-order widening read on late tails, does not give it. What one course keeping widening "
     "needs is known ([§2](#r-what-keeping-widening-needs)): gain from beyond a finite family, renewers without bound "
     "under upkeep, and, under the World premises with requirements never loosening, no keeping widening along passing "
     f"of support. On admitted ranges ([§2](#r-{RID})), ranking every course that keeps widening by name above every "
     "course that admits alike, was wider at first and is mixed with it is not a strict partial order containing "
     "widening on every web: on a web of formations on two sides, whose static course admits infinitely many "
     "formations, it closes a cycle, and where the static course's admissions are listed it is one on every web. "
     "Eventual widening's lag is decided by widening with a lag and by a tail order containing eventual widening; on "
     "the own-condition web widening with a lag and eventual widening rank a pair oppositely, so the lag does not "
     "choose between counting early steps and reading only tails. The candidates left are what a course keeps "
     "reachable and what carries its openings.")

# UE7's passing laws: requirements never loosening is a hypothesis beside the World premises (UE8's first review)
edit(CH / '07-SIGNIFICANCE.md',
     "Under the World premises, what is supported descends, up to double negation,",
     "Under the World premises and requirements never loosening, what is supported descends, up to double negation,")
edit(CH / '07-SIGNIFICANCE.md',
     "Under the World premises nothing is new along lineage",
     "Under the World premises, requirements never loosening, nothing is new along lineage")
edit(CH / '02-MAP.md',
     "names and passing of support under the World premises, 全生成 and keeping widening do not hold together",
     "names, and passing of support under the World premises with requirements never loosening, 全生成 and keeping "
     "widening do not hold together")

# 08 §8: known results beyond the table, after UE7's bullet
edit(CH / '08-METHOD.md', """ None of the laws compares two courses, and none is a result no neighbouring field states.

**Assessment** (the market model of [05](05-COLLECTIVES.md), read against conventional control).""",
     f""" None of the laws compares two courses, and none is a result no neighbouring field states.
- Comparing two courses on what they admit ([07 §2](07-SIGNIFICANCE.md#r-{RID})) has known shapes. On a web of formations on two sides, ranking a course that keeps widening by name above one admitting alike closes a cycle with their mirrors, as Pareto, transitivity and permutation invariance force incomparability between infinite worlds (Askell 2018); here one verdict only is forbidden, and the exchange is an instance of relative anonymity across formations (Asheim, d'Aspremont and Banerjee 2010). Eventual widening is decided by tails, like a dictatorship of the future (Chichilnisky 1996), while widening with a lag constrains every step [AI reading]; a lag for each admission is the analogue of delayed simulation (Etessami, Wilke and Schuller 2001), a uniform lag of delay games with bounded lookahead (Hosch and Landweber 1972). Each law is near-definitional; reading them on admitted ranges, where 07's question is posed, is the contribution.

**Assessment** (the market model of [05](05-COLLECTIVES.md), read against conventional control).""")

# 08: receipt and counts, every count read from the receipt (as texts_ue7.py)
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
section = (HERE / 'study_ue9.txt').read_text(encoding='utf-8').replace('{N}', str(N)).replace('{RECEIPT}', RECEIPT)
assert '{' not in section, 'a placeholder left in the study text'
t = STUDY.read_text(encoding='utf-8')
assert f'\n## {N}. ' not in t and f'\n## {N - 1}. ' in t, N
STUDY.write_text(t.rstrip('\n') + '\n\n' + section.strip('\n') + '\n', encoding='utf-8')

# the UE plan: item 7 and the owners brought to the landing
PLAN = ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ue-unified-explanation/PLAN.md'
edit(PLAN,
     "(UE4 landed its first step; UE7, what one course keeping widening needs, reviewed and in its fix round; UE9, "
     "comparing two courses on what they admit, drafted: keeping widening over admitting alike closes a cycle under "
     "renaming, widening with a lag decides UE4's lag, and it and eventual widening exclude each other).",
     "(UE4 landed its first step; UE7, what one course keeping widening needs, landed 26 October; UE9, comparing two "
     "courses on what they admit, landed the same day: on a web of formations on two sides, ranking a course that "
     "keeps widening by name over one admitting alike closes a cycle, which needs a static course admitting infinitely "
     "many formations and is not given by one; widening with a lag decides UE4's lag, as does a tail order containing "
     "eventual widening, and on the own-condition web the two rank a pair oppositely, so choosing between counting "
     f"early steps and reading only tails is a premise: [record](../../../../../../theories/becoming/results/records/{RID}.md)). "
     "What a course keeps reachable and what carries its openings remain the candidates for the second order; UE10 "
     "takes up the first.")
edit(PLAN, "UE4 and UE5, and holds UE7, UE8 and UE9.", "UE4, UE5, UE7 and UE9, and holds UE8 and UE10.")

# regions
reg = json.loads(REGIONS.read_text(encoding='utf-8'))
assert RID not in reg['records']
assert 'Becoming.ComparingCourses' not in reg['modules']
reg['records'][RID] = {'region': 'significance', 'base': 'old-base',
                       'note': 'ComparingCourses UE9: comparing two courses on what they admit (the cycle of crossed '
                               'rankings, widening with a lag, the tail order, keeping what the other keeps)'}
reg['records'] = dict(sorted(reg['records'].items()))
reg['modules']['Becoming.ComparingCourses'] = {'region': 'significance', 'base': 'old-base',
                                               'note': 'UE9 comparing two courses on what they admit'}
reg['modules'] = dict(sorted(reg['modules'].items()))
REGIONS.write_text(json.dumps(reg, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')
print('texts: 07 §2 paragraph and reading, eventual widening reading pointed, 07 Open narrowed, UE7 premises in 07 and 02; 08 bullet and counts:',
      counts[:90], '...; study section', N, '; regions')
