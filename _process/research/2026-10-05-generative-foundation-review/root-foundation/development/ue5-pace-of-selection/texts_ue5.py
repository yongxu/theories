#!/usr/bin/env python3
"""UE5 texts: the home section of the new record (04 §4: a theorem paragraph, its witnesses and a labelled reading after
what bounds offspring numbers, a link reference, and an item in the chapter's Open list), a bullet at the end of 08 §8's
known results beyond the table, 08's receipt and counts read from the receipt, the study section, and the record's and
the module's regions. Mirrors UE1's texts_ue1.py; every edit asserts that it applies exactly once, and every chapter
edit only adds lines.
usage (from the checkout root of the landing worktree, after the checker): python3 -B <kit>/texts_ue5.py RECEIPT N"""
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
RID = 'pace-of-selection-within-what-flows-in'
MODULE = 'Becoming.SelectionPace'


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:80], text.count(old))
    path.write_text(text.replace(old, new), encoding='utf-8')


assert f'r-{RID}' not in (CH / '04-LIFE.md').read_text(encoding='utf-8')

# 04 §4: the theorem, its witnesses and the reading, after what bounds offspring numbers
edit(CH / '04-LIFE.md', """
<a id="r-additive-part-of-offspring-variance"></a>""", f"""
<a id="r-{RID}"></a>
**Theorem** (World). *The pace of selection, within what flows into the lineages carrying an amount.* Across a step at which the flow balances on the family a lineage occupies, each offspring coming to stand at `m` or more:

- The offspring of some parents listed after some relata, `m` for each, with what those relata stand at after the step, are at most what they stood at before and the list's inflow (`Becoming.SelectionPace.born_within_inflow`). Read on a parent and its offspring, `m` times its offspring number is at most what the parent stood at and what flows into its lineage (`SelectionPace.parent_within_inflow`). A member of the next generation standing at no more than `m` as a parent stands at exactly `m` (`SelectionPace.standing_pinned`), so over a stretch with the parents capped at each step before `T` the generations `1` to `T - 1` are pinned at `m`, and generation `T` only where it is capped too; where activity needs support, the least standing follows from a dependence (`SelectionPace.stands_of_need`).
- With exact transmission and each parent standing at no more than `m`, `m` times the next total of an amount is at most `m` times this one with the carried inflow: what flows into each parent's lineage, summed lineage by lineage and weighted by the amount, so that what passes between carrying lineages counts (`SelectionPace.carriedInflow`, `SelectionPace.total_within_carried`). In a population not shrinking, `m` times the mean's cross-multiplied rise, and so the selection term proper, is at most the size times the carried inflow (`SelectionPace.response_within_carried`, `SelectionPace.selection_within_carried`). With nothing flowing into the carrying lineages, a rise of the mean shrinks the population (`SelectionPace.unfed_rise_shrinks`). Over a stretch the bounds add (`SelectionPace.stretch_within_carried`, `SelectionPace.steps_to_move`), a linear bound.
- For an amount of zero or one, `m` times the carriers' rise, with what the rest of a whole stands at after the step, is within what the rest stood at before and what flows into the whole (`SelectionPace.share_within_rest`): [a rise past the inflow is drawn from beyond](05-COLLECTIVES.md#r-a-rise-past-the-inflow-is-drawn-from-beyond), read on offspring. With no rest it is within the inflow into the carriers' joint lineage, which is at most the carried inflow (`SelectionPace.share_within_joint`, `SelectionPace.joint_within_carried`).
- Where what flows into each parent's lineage, with `m`, is at most `k · m`, each parent leaves at most `k` offspring (`SelectionPace.parent_within_factor`), the total multiplies by at most `k ^ T` over `T` steps, and in a population not shrinking, reaching the whole from `c` carriers among `N` needs `N ≤ k ^ T · c`, so one substitution takes `T ≥ log_k (N / c)` steps (`SelectionPace.total_within_power`, `SelectionPace.whole_within_power`). The premises are asked of every parent.
- Read by offspring number with exact transmission, the next generation standing at no more than `m` and the population not shrinking, `m` times the squared differences of offspring numbers over pairs is at most the size times the inflow into the next generation and its offspring (`SelectionPace.number_spread_within_inflow`); with nothing flowing in, offspring numbers are uniform (`SelectionPace.number_unfed_uniform`). With offspring number itself inherited, the response of any amount, squared, is bounded by the next step's inflow and the amount's spread (`SelectionPace.response_sq_within_inflow`); with the same step's inflow it is not (`SelectionPace.Inherited.same_step_fails`).

**Theorem** (witnesses). In a family closed, balanced and dissipated on, gaining nothing, a carrier's share rises from a half to the whole at constant size two, its lineage drawing on another member and a pool; the response law with what flows into the whole or into the population's own lineage in place of the carried inflow fails (`SelectionPace.Displacement.displacement`, `SelectionPace.Displacement.natural_fails`). Each law is the stock law of the carrying lineages under the per-member bounds. The response, selection, factor, stretch, next-step and offspring-number laws are equalities in the witnesses (`SelectionPace.Displacement`, `SelectionPace.Inherited`, `SelectionPace.Fed`). The carriers' law with the rest of a whole keeps one unit of slack there (`SelectionPace.Displacement.rest_falls`), and two carriers giving to each other's offspring carry an inflow of two while their joint lineage draws nothing (`SelectionPace.Swap.swap`). Without parents standing at no more than `m`, or with the population shrinking, the response law fails (`SelectionPace.Uncapped.uncapped`, `SelectionPace.Shrink.shrink`). [Record](../results/records/{RID}.md); [SelectionPace.lean][selectionpace].

**Reading** [AI reading, D45]. This is Malthus's limit read on the lineages carrying an amount, against Price's and Fisher's identities, which admit every pace. The per-parent form bounds the steps one substitution takes from `p₀` under a cap on each parent: the form behind the reproductive-excess limit of Nei and Felsenstein (1971), in counts, and not the spacing of successive substitutions that limit states. It is not Haldane's cost (1957), which counts selective deaths, and the generations here list only offspring that come to stand. A part of a closed whole gaining by drawing on the rest is the setting of Wallace's soft selection (1975).

<a id="r-additive-part-of-offspring-variance"></a>""")

# 04: the module's link reference, after Reproduction's
edit(CH / '04-LIFE.md', f"""
[reproduction]: ../../../{PKG}/Becoming/Reproduction.lean
""", f"""
[reproduction]: ../../../{PKG}/Becoming/Reproduction.lean
[selectionpace]: ../../../{PKG}/Becoming/SelectionPace.lean
""")

# 04: Open list
edit(CH / '04-LIFE.md', """- Lifting these laws onto the grammar ([08](08-METHOD.md)).""",
     """- For the pace of selection within what flows in (§4): the carriers' joint law for an amount above one, in layers; the cap laws asked of the carriers alone; the least standing tied to need beyond one lemma; how long exact transmission of offspring number with growth can last within a bounded inflow; a frozen test of the whole-level form.
- Lifting these laws onto the grammar ([08](08-METHOD.md)).""")

# 08 §8: known results beyond the table, at the end of the list
edit(CH / '08-METHOD.md', """

**Assessment** (the market model of [05](05-COLLECTIVES.md), read against conventional control).""", f"""
- The pace of selection within what flows in ([04 §4](04-LIFE.md#r-{RID})) is the Malthusian limit read on the lineages carrying an amount, joined to Price's and Fisher's identities, which admit every pace. Its per-parent form bounds the steps one substitution takes from p₀ under a cap on each parent, the form behind the reproductive-excess limit of Nei (1971) and Felsenstein (1971), and not the spacing of successive substitutions that limit states. It is not Haldane's cost (1957), which counts selective deaths the model does not have. The variance bound is density regulation of heritable variance in fitness, under exact transmission of offspring number, and the squared-response law (`response_sq_within_inflow`) is the bound of the selection differential by the opportunity for selection (Crow 1958; Arnold and Wade 1984), with the opportunity bounded by the inflow. Each law is the stock law of the carrying lineages under per-member bounds, and the response, selection, factor, stretch, next-step and offspring-number laws are equalities in its witnesses, so the third part against Price and Fisher is yes and weak, carried by its premises. The natural statement, a pace bounded by what flows into the whole, is false: a part of a closed whole rises by drawing on the rest.

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
section = (HERE / 'study_ue5.txt').read_text(encoding='utf-8').replace('{N}', str(N)).replace('{RECEIPT}', RECEIPT)
assert '{N}' not in section and '{RECEIPT}' not in section
t = STUDY.read_text(encoding='utf-8')
assert f'\n## {N}. ' not in t
STUDY.write_text(t.rstrip('\n') + '\n\n' + section.strip('\n') + '\n', encoding='utf-8')

# regions
reg = json.loads(REGIONS.read_text(encoding='utf-8'))
assert RID not in reg['records'] and MODULE not in reg['modules']
reg['records'][RID] = {'region': 'life', 'base': 'old-base',
                       'note': 'SelectionPace UE5: the pace of selection within what flows into the carrying lineages'}
reg['records'] = dict(sorted(reg['records'].items()))
reg['modules'][MODULE] = {'region': 'life', 'base': 'old-base',
                          'note': 'UE5 the pace of selection within what flows in: Reproduction joined to Entropy'}
reg['modules'] = dict(sorted(reg['modules'].items()))
REGIONS.write_text(json.dumps(reg, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')
print('texts: 04 §4 paragraph, witnesses, reading, link and Open item; 08 bullet and counts:', counts[:90], '...;',
      'study section', N, '; regions')
