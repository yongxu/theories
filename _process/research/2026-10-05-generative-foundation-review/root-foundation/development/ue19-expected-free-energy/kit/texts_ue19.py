#!/usr/bin/env python3
"""UE19 texts: 03's thesis; the homes of the two new records at 03 §6 after UE17's free energy and its reading (before
UE18's existence claim where it has landed, else before the split that makes sense), expected-free-energy-and-its-terms
then what-seeking-cannot-separate, with a labelled reading; a bullet in 08 §8's known results beyond the table, and
08's receipt and counts read from the core receipt; the study section; the UE plan's owners and the plan for the
principle (FEP-INTEGRATION); the records' and the core module's regions. Every LumpedSeeking name the texts cite is
checked against the scratch build's axiom audit and every ExpectedFreeEnergy name against the periphery probe's.
Mirrors UE18's texts_ue18.py; every edit is asserted to apply exactly once. Runs after UE17 has landed.
usage (from the checkout root of the landing worktree, after both checkers):
  python3 -B <kit>/texts_ue19.py CORE_RECEIPT PERIPHERY_RECEIPT N"""
import json
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
RECEIPT, PRECEIPT, N = sys.argv[1], sys.argv[2], int(sys.argv[3])
LEANR = 'experiments/integrated-correction/general-framework/generative-basis/lean'
PKG = f'{LEANR}/becoming'
FE = f'{LEANR}/free-energy'
CH = ROOT / 'theories/becoming/chapters'
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation'
STUDY = ROOT / RF / 'BECOMING-RENEWAL-READING.md'
REGIONS = ROOT / 'theories/becoming/results/data/regions.json'
RIDE = 'expected-free-energy-and-its-terms'
RIDS = 'what-seeking-cannot-separate'
KIT = f'../../../{RF}/development/ue19-expected-free-energy/NOTE.md'
AUDIT = HERE.parent / 'tree/.build/BecomingLumpedSeekingAxiomAudit.lean'
NAMES = set(re.findall(r'^#print axioms Becoming\.(\S+)$', AUDIT.read_text(encoding='utf-8'), re.M))
PROBE = (HERE.parent / 'periphery/probe-3.log').read_text(encoding='utf-8')
PNAMES = set(re.findall(r"^'Becoming\.(ExpectedFreeEnergy\.\S+)' depends on axioms", PROBE, re.M))
assert len(NAMES) == 27 and len(PNAMES) == 21, (len(NAMES), len(PNAMES))


def cited(text):
    """Every backticked name of the two modules the text cites is a declaration of it."""
    found = set(re.findall(r'`(LumpedSeeking\.[A-Za-z_.]+)`', text))
    missing = sorted(n for n in found if n not in NAMES)
    found = set(re.findall(r'`(ExpectedFreeEnergy\.[A-Za-z_.]+)`', text))
    missing += sorted(n for n in found if n not in PNAMES)
    assert not missing, missing
    return text


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:80], text.count(old))
    path.write_text(text.replace(old, cited(new)), encoding='utf-8')


C03 = CH / '03-KNOWING.md'
# 03's thesis
THESIS = "conditioning is restriction, and minimizing variational free energy over the beliefs where it is finite reaches it; "
edit(C03, THESIS, THESIS + "expected free energy reads beliefs only through the lumping its likelihood makes, and seeking "
     "separates only what some experiment it can choose separates; ")

# 03 §6: expected free energy and what seeking cannot separate, after UE17's free energy and its reading
BEFORE = '<a id="r-what-the-existence-claim-forbids"></a>'
if BEFORE not in C03.read_text(encoding='utf-8'):
    BEFORE = '<a id="r-the-split-that-makes-sense"></a>'
PERIPHERY_LINK = f'../../../{FE}/ExpectedFreeEnergyReals.lean'
edit(C03, BEFORE, f"""<a id="r-{RIDE}"></a>
**Theorem** (periphery: [`ExpectedFreeEnergyReals`]({PERIPHERY_LINK}) on Mathlib's reals, Lean's three standard axioms reported, [`FreeEnergyReals`](#r-free-energy-bounds-surprisal) read unchanged; finite states and outcomes; one step and one policy, its predicted distribution over states given; Mathlib's conventions at zero). *Expected free energy and its terms.* Active inference scores a policy by its expected free energy: its risk, the divergence of the outcomes it predicts from the preferred ones, plus its ambiguity, the expected entropy of the likelihood (Parr and Friston 2019). This is the negative of its epistemic value less its pragmatic value, the expected log preference, with no hypothesis (`ExpectedFreeEnergy.expectedFreeEnergy_eq_neg_epistemic_sub_pragmatic`). The epistemic value is the divergence of the joint weights of states and outcomes from the product of the states' weights and the predicted outcomes, nonnegative where these are distributions (`ExpectedFreeEnergy.epistemic_eq_divergence`, `ExpectedFreeEnergy.epistemic_nonneg`), and the predicted outcomes' average of the divergence of the [posterior](#r-free-energy-bounds-surprisal) given each outcome from the states' weights, the expected information gain (`ExpectedFreeEnergy.epistemic_eq_expected_gain`). It reads the states only through the lumping the likelihood makes: where the likelihood reads a state only through its class, the epistemic value and the expected free energy are the classes', with their total weights (`ExpectedFreeEnergy.epistemic_through`, `ExpectedFreeEnergy.expectedFreeEnergy_through`), so two beliefs alike on the classes have one expected free energy and no choice by it turns on how weight is split within a class (`ExpectedFreeEnergy.expectedFreeEnergy_same_of_coarse`); two states of one likelihood keep their prior ratio in the posterior under every outcome (`ExpectedFreeEnergy.posterior_ratio_of_lumped`). With `log 0 = 0`, risk and pragmatic value are finite where the predicted outcomes weigh an outcome of preference nothing, though infinite as usually defined. The decompositions are the principle's definitions and the gain form is known; the reading through the lumping is near-definitional ([record](../results/records/{RIDE}.md)).

<a id="r-{RIDS}"></a>
**Theorem** (any type; natural weights, listed hypotheses and records, exact posteriors; the tie fixed and pointwise). *What seeking cannot separate.* Two hypotheses a likelihood ties, its weights agreeing on them at every value of the record, keep their prior order given every record weighing something under them: the share of one given the record is at most the other's exactly where its prior weight is (`LumpedSeeking.posterior_le_iff_prior`), the shares standing as the prior weights do (`LumpedSeeking.posterior_ratio_kept`), so where the prior weighs the false one above the true one, every such record leaves it above (`LumpedSeeking.order_kept`). A course of seeking chooses each experiment with a weight read from the course so far (`LumpedSeeking.seekWeight`); the choice weights are the same under every hypothesis, so a pair every experiment ties is tied over every course (`LumpedSeeking.seek_tied`), and no course of seeking corrects an error every experiment ties, whatever the policy of choice (`LumpedSeeking.seeking_keeps_order`). In a witness of three coins, biased toward heads (true), fair and biased toward tails, the prior weighing both false ones above the true one, a model reading only whether two tosses agree turns, given two heads, the wrong order it separates and keeps the one it ties (`LumpedSeeking.Agree.turns_fair`, `LumpedSeeking.Agree.keeps_tails`); seeking draws the same line, keeping the tied order with only that experiment and turning it, from the same outcome, once an experiment reading both tosses is chosen (`LumpedSeeking.Agree.seeking_keeps_tails`, `LumpedSeeking.Agree.seeking_turns_tails`). Known: identification (Rothenberg 1971) in its Bayesian form (Poirier 1998); the posterior laws are corollaries of [conditioning by restriction](#r-conditioning-by-restriction), and new is the seeking form, the choice of experiment read from the course ([record](../results/records/{RIDS}.md)).

**Reading** [AI reading, D45]. Active inference reads the epistemic term as what draws an agent to resolve its uncertainty, as at the cue of the principle's T-maze, where seeking corrects; one proposal reads it as inherent self-verification and self-correction (Wen 2025). Read exactly, seeking corrects within what some experiment the agent has separates, and not beyond: what every experiment ties stays in the prior's order, under every policy. What changes a tie couples in from beyond the model, a new likelihood or a new hypothesis ([selection under registration revision](#r-selection-under-registration-revision)); the principle's own literature adds novelty and structure learning for this reason (Friston, Lin, Frith, Pezzulo, Hobson and Ondobaka 2017; Da Costa and others 2020), both conditioning in a larger model, whose ties the law covers too. So the law forbids the unqualified wording of inherent self-correction, not active inference's account ([study]({KIT})).

""" + BEFORE)

C08 = CH / '08-METHOD.md'
ASSESS = "\n\n**Assessment** (the market model of [05](05-COLLECTIVES.md), read against conventional control)."
edit(C08, ASSESS, f"""
- Expected free energy and its terms ([03 §6](03-KNOWING.md#r-{RIDE})) states the principle's two decompositions and its information-gain form in the periphery beside free energy, and that expected free energy reads beliefs only through the lumping its likelihood makes. What seeking cannot separate ([03 §6](03-KNOWING.md#r-{RIDS})) is identification (Rothenberg 1971) in its Bayesian form (Poirier 1998), stated for seeking, each experiment chosen from the course: it forbids the unqualified wording of inherent self-correction (Wen 2025), not active inference's account. The decompositions are the principle's definitions and the other laws near-definitional or corollaries; new is the seeking form.""" + ASSESS)

# 08 §8: the containment's third parts in the bullet on UE1's record, UE19's added
edit(C08, "the containment's third parts are [05 §9's](05-COLLECTIVES.md#r-identical-cells-under-a-descent-treating-them-alike) "
          "and [05 §1's](05-COLLECTIVES.md#r-risk-minimization-on-a-shared-renewal).",
     "the containment's third parts are [05 §9's](05-COLLECTIVES.md#r-identical-cells-under-a-descent-treating-them-alike), "
     f"[05 §1's](05-COLLECTIVES.md#r-risk-minimization-on-a-shared-renewal) and [03 §6's](03-KNOWING.md#r-{RIDS}).")

# 08: receipt and counts, every count read from the receipt
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
s = C08.read_text(encoding='utf-8')
s, k = re.subn(r"At core receipt \[`[0-9TZ.]+`\]\([^)]*\) \(Lean 4\.29\.1\), the closure held \d+ modules \(\d+ foundation, "
               r"\d+ core, \d+ in the instance and application ring\) and [\d,]+ theorems; the \d+ core modules held [\d,]+ of "
               r"them; [\d,]+ declarations were audited; \d+ generated `injEq` lemmas depend on `propext`; \d+ superseded "
               r"modules were kept out of the run\.", lambda m: counts, s)
assert k == 1, k
C08.write_text(s, encoding='utf-8')

# the study section, its counts read from the two receipts
mod = next(m for m in R['modules'] if m['module'] == 'Becoming.LumpedSeeking')
P = json.loads((ROOT / FE / 'expected-free-energy-reals-checks' / PRECEIPT / 'verification.json').read_text())
assert P['status'] == 'passed' and P['bridge_module'] == 'ExpectedFreeEnergyReals'
pmod = P['modules'][0]
section = (HERE / 'study_ue19.txt').read_text(encoding='utf-8').replace('{N}', str(N)).replace('{RECEIPT}', RECEIPT)
section = section.replace('{PRECEIPT}', PRECEIPT)
section = section.replace('(COUNTS)', f"({mod['theorems']} theorems in {len(mod['declarations'])} declarations)")
section = section.replace('(PCOUNTS)', f"({pmod['theorems']} theorems in {len(pmod['declarations'])} declarations)")
assert '{' not in section and 'TODO' not in section and 'COUNTS' not in section, 'a placeholder left'
t = STUDY.read_text(encoding='utf-8')
assert f'\n## {N}. ' not in t and f'\n## {N - 1}. ' in t, N
STUDY.write_text(t.rstrip('\n') + '\n\n' + section.strip('\n') + '\n', encoding='utf-8')

# the UE plan and the plan for the principle
UE = ROOT / RF / 'development/ue-unified-explanation'
REC = '../../../../../../theories/becoming/results/records/'
plan = (UE / 'PLAN.md').read_text(encoding='utf-8')
owners = re.search(r'(UE16[^.]*?) and (UE1[78]), and holds UE8\.', plan)
assert owners and 'UE19' not in owners.group(0), 'the owners line'
(UE / 'PLAN.md').write_text(plan.replace(owners.group(0), f'{owners.group(1)}, {owners.group(2)} and UE19, and holds UE8.'),
                            encoding='utf-8')
edit(UE / 'FEP-INTEGRATION.md',
     "4. **UE19. Expected free energy within a lumping.** Risk and ambiguity, or the epistemic and pragmatic terms, for a "
     "finite model (periphery where logarithms are needed, counting form in the core where they are not). The epistemic "
     "term cannot separate what the model lumps: an agent seeking information under a lumping blind to a distinction "
     "never comes to tell it apart through its own seeking (candidate 7).",
     f"4. **UE19. Expected free energy within a lumping** (landed as `ExpectedFreeEnergyReals` with its checker and "
     f"`Becoming.LumpedSeeking`, with two records, [expected free energy and its terms]({REC}{RIDE}.md) and [what seeking "
     f"cannot separate]({REC}{RIDS}.md) at 03 §6, study section {N}). Risk and ambiguity, or the epistemic and pragmatic "
     f"terms, for a finite model (periphery where logarithms are needed, counting form in the core where they are not). "
     f"Expected free energy reads beliefs only through the lumping its likelihood makes, and no seeking separates what "
     f"every experiment the agent can choose ties, while it can correct what some experiment separates, as at the cue of "
     f"the T-maze (candidate 7).")
edit(UE / 'FEP-INTEGRATION.md', "), expected free energy, the Markov blanket",
     f"), expected free energy (until UE19, [record]({REC}{RIDE}.md)), the Markov blanket")

# regions
reg = json.loads(REGIONS.read_text(encoding='utf-8'))
assert RIDE not in reg['records'] and RIDS not in reg['records'] and 'Becoming.LumpedSeeking' not in reg['modules']
reg['records'][RIDE] = {'region': 'knowing', 'base': 'periphery',
                        'note': 'ExpectedFreeEnergyReals UE19: expected free energy as risk plus ambiguity and as the '
                                'negative of epistemic less pragmatic value, the epistemic value an expected '
                                'information gain, read only through the lumping the likelihood makes (periphery)'}
reg['records'][RIDS] = {'region': 'knowing', 'base': 'general',
                        'note': 'LumpedSeeking UE19: a pair every experiment ties keeps its prior order under every '
                                'course of seeking, whatever the policy of choice; seeking turns it once an experiment '
                                'separating it is chosen'}
reg['records'] = dict(sorted(reg['records'].items()))
reg['modules']['Becoming.LumpedSeeking'] = {'region': 'knowing', 'base': 'general',
                                            'note': 'UE19 what seeking cannot separate (03 §6)'}
reg['modules'] = dict(sorted(reg['modules'].items()))
REGIONS.write_text(json.dumps(reg, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')
print('texts: 03 thesis and §6 theorems and reading; 08 bullet and counts:', counts[:90], '...; study section', N,
      '; UE plan and FEP-INTEGRATION; regions')
