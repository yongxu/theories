#!/usr/bin/env python3
"""UE1b texts: the home section of the new record in 05 §7 (a theorem paragraph and a paragraph on what protects at the
set point, after the optimum law, before `r-others-drawing-first-end-the-base`), a labelled reading after them, an item
in 05's Open list, a bullet at the end of 08 §8's known results beyond the table (satisficing and mild optimization as
neighbours), 08's receipt and counts read from the receipt, the study section, and the record's and the modules' regions.
Mirrors UE1's texts_ue1.py; every edit asserts that it applies exactly once.

usage (from the checkout root of the landing worktree, after the checker): python3 -B <kit>/texts_ue1b.py RECEIPT N"""
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
RID = 'what-a-set-point-optimum-does-beyond'


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:80], text.count(old))
    path.write_text(text.replace(old, new), encoding='utf-8')


# 05 §7: the theorem, what protects at the set point, and the reading, after the optimum law
edit(CH / '05-COLLECTIVES.md', """
<a id="r-others-drawing-first-end-the-base"></a>""", f"""
<a id="r-{RID}"></a>
**Theorem** (any set of outcomes; the draw on the World, balance with the whole gaining nothing; the joint ending with activity needing support and only active giving, the gate local). *An order with a set point.* One outcome is *nearer* a set point of the family than another where at each condition of the family it lies between the set point and the other (`Regulation.Between`) and at one is strictly nearer, whatever either holds beyond; an order is *nearing* where it ranks above every nearer outcome (`Optimum.Nearing`): strictly single-peaked at the set point condition by condition, each peak not depending on the others, its sides weighed as they may be (an order costlier above than below is one, `Skew.nearing`). Where the family holds a condition, no asymmetric nearing order is rising (`Optimum.Nearing.not_rising`). Below the set point it rises: among outcomes up to the set point its optima stand at the least level beyond exactly where room holds there (`Optimum.least_below_iff`), and among the outcomes open to a part every optimum standing below its set point takes the part's whole capacity beyond, where every rising optimum stands (`Optimum.nearing_beyond`, `Optimum.nearing_as_rising`, from `Optimum.beyond_of_ranked`). Where an eligible outcome reaches the set point every optimum stands at it, whatever the room (`Optimum.atSetPoint_of_reach`), and an outcome is an optimum of some nearing order exactly where it is eligible and at the set point (`Optimum.optima_iff`, near-definitional): the class asks nothing of what lies beyond. In a balanced step in which the whole gains nothing, the beyond then falls by the family's shortfall from its set point with what the step loses (`Flow.Balances.atSetPoint_draws`); with one condition beyond, its dependence breaks exactly where that exceeds its slack (`Flow.Balances.atSetPoint_broken_iff`), and with several some dependence breaks where it exceeds their total slack (`Flow.Balances.atSetPoint_breaks`). Several nearing optimizers draw their joint shortfall, as one with their joint set point, and break a dependence beyond where it exceeds the slack, whatever each one's own (`Flow.Balances.mutual_atSetPoint_breaks`). A formation alone with its family, holding the family's stock, takes at least its loss from a condition (`Flow.held_draws`), so formations so holding, their losses together above what the rest gives a gated condition, end it however small each one's loss (`Flow.held_excess_ends`, from `Flow.joint_excess_ends`); no order or choice enters that law.

What protects what lies beyond at the set point is the choice among equal optima, which no law here models. Where a step can lose what it takes, the order by distance has the draining step among its optima beside the keeping one (`Topped.nearing_either`). A term on what lies beyond counted after the set point leaves it, in total, at the most any way of reaching the set point leaves (`Optimum.counted_after_most`, near-definitional); with one condition beyond it keeps a need exactly where some way keeps it (`Optimum.counted_after_keeps_iff`), and with several it can empty one (`Spread.counted_after_empties`); counting less, it drains (`Topped.counted_less_drains`). Counted after an aspiration level it keeps as well (`Drain.satisficingThen_keeps`), and counted after a rising order with room it changes nothing (`Optimum.Rising.mono`, `Optimum.least_of_room`): the plateau decides, not the set point. Among the splits of three units every optimum of every order nearing a store of `k` meets the dweller's need exactly where `k` is within the slack (`Drain.kept_iff`), a set point no open outcome reaches drains as a rising order does (`Topped.out_of_reach`), and two formations holding stores, each within the renewal, end it (`HeldPair.held_end`). It does not show which optimum is taken, that any agent's preferences form a nearing order, or anything over a horizon or under noise ([record](../results/records/{RID}.md)).

**Reading** [AI reading, D45]. Active inference casts preferences as prior beliefs over outcomes, highest at the characteristic states (Friston and others 2016); strictly single-peaked at each observed condition, each peak not depending on the others, they form a nearing order, and the drive of homeostatic reinforcement learning, a norm of the deviations from set points (Keramati and Gutkin 2014), is one. A tolerance band around the set point is not: it is a two-sided aspiration level, and the plateau's results apply to it. Such a chooser escapes the optimizer's drive at its set point, not the drain below it, nor joint excess. At its set point the class is undriven, and whether what lies beyond is kept depends on how the chooser picks among equal optima, the point of mild optimization (Taylor 2016), whose bound for a choice drawn from a base distribution is a reading, not proved here. Formations holding a level drain a commons wherever their losses together exceed what renews it, whatever they choose.

<a id="r-others-drawing-first-end-the-base"></a>""")

# 05: the Open list
edit(CH / '05-COLLECTIVES.md', """- Whether the drain in actual trained systems lies where room lies (T3's clause on trained systems).
""", f"""- Whether the drain in actual trained systems lies where room lies (T3's clause on trained systems).
- For orders with a set point ([§7](#r-{RID})): which optimum is taken where several reach the set point, which decides keeping wherever a step can lose what it takes; conflicting set points on a shared condition; a weighted term traded against the set point; several nearing optimizers read off an exchange; and, over a horizon under noise, whether a set point on later states makes reserves worth holding, so that a rising drive on stores returns.
""")

# 08 §8: known results beyond the table, at the end of the list (as texts_ue4.py)
edit(CH / '08-METHOD.md', """

**Assessment** (the market model of [05](05-COLLECTIVES.md), read against conventional control).""", f"""
- Orders with a set point ([05 §7](05-COLLECTIVES.md#r-{RID})) have a plateau where the set point is reached, as an aspiration level has (satisficing; Simon 1955), and a term counted after either decides within the plateau; that what protects at the set point is the choice among equal optima is mild optimization's point (quantilizers; Taylor 2016), its bound a reading not proved here. The drive of homeostatic reinforcement learning, a norm of the deviations from set points (Keramati and Gutkin 2014), is a nearing order. Neighbours, not containments: the laws restate them for one step, exactly, with the drain below the set point and the draw at it.

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
section = (HERE / 'study_ue1b.txt').read_text(encoding='utf-8').replace('{N}', str(N)).replace('{RECEIPT}', RECEIPT)
assert '{N}' not in section and '{RECEIPT}' not in section
t = STUDY.read_text(encoding='utf-8')
assert f'\n## {N}. ' not in t
STUDY.write_text(t.rstrip('\n') + '\n\n' + section.strip('\n') + '\n', encoding='utf-8')

# regions
reg = json.loads(REGIONS.read_text(encoding='utf-8'))
assert RID not in reg['records'] and 'Becoming.SetPointOptimum' not in reg['modules']
reg['records'][RID] = {'region': 'collective', 'base': 'old-base',
                       'note': 'SetPointOptimum UE1b: what an order with a set point does beyond what couples in'}
reg['records'] = dict(sorted(reg['records'].items()))
reg['modules']['Becoming.SetPointOptimum'] = {
    'region': 'collective', 'base': 'old-base',
    'note': 'UE1b set-point orders: the drain below the set point, the draw at it, joint excess for holders'}
old_note = 'SG1-SG17 optima at least level beyond; 503 thms'
assert reg['modules']['Becoming.Optimum']['note'] == old_note, reg['modules']['Becoming.Optimum']['note']
reg['modules']['Becoming.Optimum']['note'] = 'SG1-SG17 optima at least level beyond; 506 thms (UE1b: one law of the exchange)'
reg['modules'] = dict(sorted(reg['modules'].items()))
REGIONS.write_text(json.dumps(reg, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')
print('texts: 05 §7 theorem, protection paragraph and reading; 05 Open item; 08 bullet and counts:', counts[:90], '...;',
      'study section', N, '; regions')
