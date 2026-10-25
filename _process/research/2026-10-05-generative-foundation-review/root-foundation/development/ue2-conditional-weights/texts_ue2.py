#!/usr/bin/env python3
"""UE2 texts. Edits, each asserted to apply exactly once:
- 03 §6: Typicality's home section (r-typicality-by-counting) gains the bound at every step.
- 03 §6: record (a)'s home section beside it (r-conditioning-by-restriction, with a labelled reading), before
  r-the-split-that-makes-sense.
- 02 §5: record (b)'s home section after the margin of a regime (r-exit-from-a-margin, with a labelled reading), before
  r-threshold-in-the-state-plane.
- 03 §10: a pointer for T6's seen half, before the chapter's "What this chapter does not show".
- 08 §8 (known results beyond the table): two bullets after UE1's, and 08's receipt and counts read from the receipt.
- The study section from study_ue2.txt, and the records' and the module's regions.
Mirrors UE1's texts_ue1.py.
usage (from the checkout root of the landing worktree, after the checker): python3 -B <kit>/texts_ue2.py RECEIPT N"""
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
RA = 'conditioning-by-restriction'
RB = 'exit-from-a-margin'


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:80], text.count(old))
    path.write_text(text.replace(old, new), encoding='utf-8')


def insert_after_line(path, start, block):
    """Insert `block` after the one line that starts with `start`."""
    lines = path.read_text(encoding='utf-8').split('\n')
    at = [i for i, line in enumerate(lines) if line.startswith(start)]
    assert len(at) == 1, (path.name, start, at)
    lines[at[0] + 1:at[0] + 1] = block.split('\n')
    path.write_text('\n'.join(lines), encoding='utf-8')


# The arguments, checked before any write: the receipt passed, the study section is free, the regions are free.
R = json.loads((ROOT / PKG / 'becoming-checks' / RECEIPT / 'verification.json').read_text())
assert R['status'] == 'passed'
section = (HERE / 'study_ue2.txt').read_text(encoding='utf-8').replace('{N}', str(N)).replace('{RECEIPT}', RECEIPT)
assert '{N}' not in section and '{RECEIPT}' not in section
assert f'\n## {N}. ' not in STUDY.read_text(encoding='utf-8'), f'study section {N} exists'
reg = json.loads(REGIONS.read_text(encoding='utf-8'))
assert RA not in reg['records'] and RB not in reg['records'] and 'Becoming.ConditionalWeights' not in reg['modules']

# 03 §6: Typicality's home section gains the bound at every step
edit(CH / '03-KNOWING.md', """So the courses whose squared deviation is at least d weigh, times d, at most n·p·q·(p + q)ⁿ (`Typicality.typical`);""",
     """So the courses whose squared deviation is at least d weigh, times d, at most n·p·q·(p + q)ⁿ (`Typicality.typical`), and so do those whose squared deviation reaches d at some step, the bound at every step of which this is the last step (`Typicality.typical_throughout`, Kolmogorov's maximal inequality): the counts stay near their means throughout, and the frequencies show the weights at the horizon;""")
edit(CH / '03-KNOWING.md', """Lean: `Typicality.spread`, `Typicality.concentrated`, `TypicalRuns.records_typical`;""",
     """Lean: `Typicality.spread`, `Typicality.typical_throughout`, `Typicality.concentrated`, `TypicalRuns.records_typical`;""")

# 03 §6: record (a)'s home section, beside Typicality's
edit(CH / '03-KNOWING.md', """
<a id="r-the-split-that-makes-sense"></a>""", f"""
<a id="r-{RA}"></a>
**Theorem** (any type; natural weightings of listed courses; near-definitional). *Conditioning by restriction.* The weighting restricted to a record keeps the weight of each course agreeing with it and gives every other course nothing. Under it an event weighs what the courses meeting the event and the record weigh, its whole is the record's weight, a record raises no weight, and two records in turn are their conjunction in either order (`ConditionalWeights.mass_restrict`, `ConditionalWeights.whole_restrict`, `ConditionalWeights.mass_split`, `ConditionalWeights.restrict_comm`). Shares are parts of wholes compared by cross-multiplication, a preorder on shares with a positive whole; `⟨0, 0⟩`, the share of an event whose whole is nothing, compares either way with every share, so the laws given a record say nothing where it weighs nothing (`ConditionalWeights.Share.zero_whole`). Bayes's rule holds as a ratio identity (`ConditionalWeights.restrict_two_ways`). In a generative model, each listed hypothesis with each listed record and a course weighing the hypothesis's prior weight times the record's weight under it, a hypothesis listed once has, given the record, that product over their sum as its share, and two hypotheses compare after the record as prior weights times likelihood weights (`ConditionalWeights.posterior_single`, `ConditionalWeights.posterior_le_iff_single`); a prior weight is the prior share where every hypothesis's likelihood weights have one total, and in general not otherwise (`ConditionalWeights.prior_share`, `ConditionalWeights.Witness.prior_not_share`). Over independent parts and over courses of independent steps, shares multiply, and a record of one part leaves the other's share the same ratio (`ConditionalWeights.share_product`, `ConditionalWeights.share_meetsEach`, `ConditionalWeights.restrict_independent`). These are identities of counting ([record](../results/records/{RA}.md)).

**Reading** [AI reading, D45]. Read as probabilities, a chance being a number of situations of a kind ([01](01-ROOT.md#r-weights-count-situations)), restriction is conditioning, `restrict_two_ways` is Bayes's theorem and `posterior_single` a generative model's posterior; the prior and likelihood readings need one likelihood total. The reciprocal share, the whole over the part, orders as pointwise surprisal does and multiplies where surprisal adds (`ConditionalWeights.Share.le_iff_reciprocal`). Averages of logarithms, entropy and free energy among them, have no counting form here.

<a id="r-the-split-that-makes-sense"></a>""")

# 02 §5: record (b)'s home section, after the margin of a regime
edit(CH / '02-MAP.md', """
<a id="r-threshold-in-the-state-plane"></a>""", f"""
<a id="r-{RB}"></a>
**Theorem** (two values, natural weights p and q, independent steps). *The exit from a margin.* Read a level standing m above a need on the courses of `Typicality`, raised q by each one and lowered p by each zero, so that its rises and falls balance under the weights. The courses of n steps in which it reaches the need or falls below it at some step weigh, times m·m, at most n·p·q·(p + q)ⁿ, so they take at most n·p·q/m² of the weight: Kolmogorov's maximal inequality restated in counting form (`ConditionalWeights.fallsWithin_bound`, `ConditionalWeights.fallsWithin_share`, from `Typicality.typical_throughout`). At the horizon, deviations either way obey Chebyshev's bound read at the margin (`ConditionalWeights.deviates_bound`). Standing at the need is not a break, since a need within the level is supported; a break, the level below the need, is reaching it from m + 1, on at most n·p·q/(m + 1)² of the weight (`ConditionalWeights.fallsTo_succ`). A course can fall and recover, so the count at some step can exceed the count at the horizon (`ConditionalWeights.Witness.within_exceeds_end`). Given a record of the earliest steps that leaves the level m′ above the need without having reached it, the share of the courses reaching the need within the n steps left is the share from m′, at most n·p·q/m′² (`ConditionalWeights.record_share`, `ConditionalWeights.record_bound`): given the weighting, a record bears on the exit only through the margin it shows and the steps it leaves ([record](../results/records/{RB}.md)).

**Reading** [AI reading, D45]. The bound is the unregulated case a reading of persisting, the free-energy principle's among them, is measured against: it is void from n = m·m/(p·q), and persisting longer needs a giving that reads the level. It is not the regime's point of no return above, where giving reads the level; and it gives the principle's containment no third part.

<a id="r-threshold-in-the-state-plane"></a>""")

# 03 §10: a pointer for T6's seen half
edit(CH / '03-KNOWING.md', """
<a id="does-not-show"></a>
## What this chapter does not show""", f"""
In counting form, where a record holds the level and the need, the share of the courses that reach the need within the steps left reads off the margin the record shows, the steps it leaves and the spread of the weighting, which the record does not show; the weighting is the independently warranted model T6 allows, and given it nothing else in the record matters, the steps being independent ([02 §5](02-MAP.md#r-{RB})).

<a id="does-not-show"></a>
## What this chapter does not show""")

# 08 §8: known results beyond the table, after UE1's bullet
insert_after_line(CH / '08-METHOD.md', '- A rule read from the count of its choices (', f"""- Restriction to a record on natural weightings is conditioning ([03](03-KNOWING.md#r-{RA})): Bayes's theorem in counting form (Bayes 1763; Laplace 1774) holds as a ratio identity, near-definitional, and a prior weight is the prior share only where the likelihood totals agree.
- The exit from a margin ([02 §5](02-MAP.md#r-{RB})) rests on Kolmogorov's maximal inequality (1928), restated in counting form in `Typicality` with Chebyshev's bound its last step. The exit bound is the unregulated case, not the free-energy principle's quantity, and gives that principle's containment no third part.""")

# 08: receipt and counts, every count read from the receipt (as texts_ue1.py)
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

# the study section (checked above)
t = STUDY.read_text(encoding='utf-8')
STUDY.write_text(t.rstrip('\n') + '\n\n' + section.strip('\n') + '\n', encoding='utf-8')

# regions (read and checked above; no edit above touches them)
reg['records'][RA] = {'region': 'knowing', 'base': 'general',
                      'note': 'ConditionalWeights UE2: conditioning by restriction, shares, a generative model\'s posterior'}
reg['records'][RB] = {'region': 'map', 'base': 'general',
                      'note': 'ConditionalWeights UE2: the exit from a margin and what a record of the course says of it'}
reg['records'] = dict(sorted(reg['records'].items()))
reg['modules']['Becoming.ConditionalWeights'] = {'region': 'knowing', 'base': 'general',
                                                 'note': 'UE2 conditional weights and the exit from a margin on the counting layer'}
reg['modules'] = dict(sorted(reg['modules'].items()))
REGIONS.write_text(json.dumps(reg, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')
print('texts: 03 Typicality section, record (a) home and T6 pointer; 02 record (b) home; 08 bullets and counts:',
      counts[:90], '...;', 'study section', N, '; regions')
