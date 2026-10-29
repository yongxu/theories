#!/usr/bin/env python3
"""UE19: join Becoming.LumpedSeeking to the core as a leaf and ExpectedFreeEnergyReals to the periphery beside
FreeEnergyReals, after UE17. Copies the two modules (no landed module changes); adds the core module to the checker's
core list (after Becoming.Blanket where UE18 has landed, else after Becoming.FreeEnergyGuarantees) and its scope text
(before the standpoints'); imports it in the root module with an L1 doc bullet before Growth's (its import,
ConditionalWeights, is L1, and it names no ethical predicate); adds the package README rows (EN, ZH) after the last
free-energy row; writes the periphery checker check_expected_free_energy_reals.py from check_free_energy_reals.py
with a new target, receipt, run folder, scope, docstring and temporary folder's prefix, everything else identical.
Every name the texts cite is checked against the scratch builds' axiom audits. Mirrors UE18's integrate_ue18.py; each
edit is asserted to apply exactly once.
usage (from the checkout root of the landing worktree, clean, with UE17 landed): python3 -B <kit>/integrate_ue19.py"""
import re
import shutil
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
TREE = HERE.parent / 'tree/Becoming'
AUDIT = HERE.parent / 'tree/.build/BecomingLumpedSeekingAxiomAudit.lean'
PERIPHERY = HERE.parent / 'periphery'
LEANR = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean'
PKG = LEANR / 'becoming'
FE = LEANR / 'free-energy'
NAMES = set(re.findall(r'^#print axioms Becoming\.(\S+)$', AUDIT.read_text(encoding='utf-8'), re.M))
assert len(NAMES) == 27, len(NAMES)


def cited(text):
    """Every backticked LumpedSeeking name in text is a declaration of the module."""
    names = set(re.findall(r'`(LumpedSeeking\.[A-Za-z_.]+)`', text))
    missing = sorted(n for n in names if n not in NAMES)
    assert not missing, missing
    return text


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:70], text.count(old))
    path.write_text(text.replace(old, cited(new)), encoding='utf-8')


# the core module
target = PKG / 'Becoming/LumpedSeeking.lean'
assert not target.exists(), target
shutil.copyfile(TREE / 'LumpedSeeking.lean', target)
checker = PKG / 'check_becoming.py'
after = '"Becoming.Blanket", ' if '"Becoming.Blanket", ' in checker.read_text(encoding='utf-8') \
    else '"Becoming.FreeEnergyGuarantees", '
edit(checker, after, after + '"Becoming.LumpedSeeking", ')
edit(checker, """
    "Standpoints: """, """
    "What seeking cannot separate: two hypotheses a likelihood ties keep their prior order given every record "
    "weighing something under them, the shares standing as the prior weights do; a course of seeking, each "
    "experiment chosen with a weight read from the course so far, weighs alike under a pair every experiment ties, "
    "so no seeking corrects an error every experiment ties, whatever the policy of choice; in a witness of three "
    "coins, seeking keeps the order the experiment reading agreement ties and turns it from the same outcome once an "
    "experiment reading both tosses is chosen. "
    "Standpoints: """)

root = PKG / 'Becoming.lean'
text = root.read_text(encoding='utf-8')
after = 'import Becoming.Blanket\n' if 'import Becoming.Blanket\n' in text else 'import Becoming.FreeEnergyGuarantees\n'
edit(root, after, after + 'import Becoming.LumpedSeeking\n')
edit(root, """* `Becoming.Growth` (L1):""", """* `Becoming.LumpedSeeking` (L1): what seeking cannot separate. Two hypotheses a likelihood ties keep
  their prior order given every record weighing something under them
  (`LumpedSeeking.posterior_le_iff_prior`, `LumpedSeeking.order_kept`); a course of seeking, each
  experiment chosen from the course so far (`LumpedSeeking.seekWeight`), weighs alike under a pair
  every experiment ties (`LumpedSeeking.seek_tied`), so no seeking corrects an error every experiment
  ties, whatever the policy of choice (`LumpedSeeking.seeking_keeps_order`). In a three-coin witness,
  seeking keeps the order the experiment reading agreement ties and turns it once an experiment
  reading both tosses is chosen (`LumpedSeeking.Agree.seeking_keeps_tails`,
  `LumpedSeeking.Agree.seeking_turns_tails`). Expected free energy and its terms, over the reals,
  are the periphery's `ExpectedFreeEnergyReals`. A leaf importing `Becoming.ConditionalWeights`
  (board item UE19).
* `Becoming.Growth` (L1):""")


def readme_row(path, row):
    lines = path.read_text(encoding='utf-8').split('\n')
    for prior in ('| L1 | [`Becoming.Blanket`]', '| L1 | [`Becoming.FreeEnergyGuarantees`]'):
        at = [i for i, line in enumerate(lines) if line.startswith(prior)]
        if at:
            break
    assert len(at) == 1, at
    assert not any('[`Becoming.LumpedSeeking`]' in line for line in lines)
    lines[at[0] + 1:at[0] + 1] = [cited(row)]
    path.write_text('\n'.join(lines), encoding='utf-8')


readme_row(PKG / 'README.md',
    '| L1 | [`Becoming.LumpedSeeking`](Becoming/LumpedSeeking.lean) | what seeking cannot separate (no ethical predicate): '
    'a tied pair keeps its prior order given every record (`LumpedSeeking.order_kept`); a pair every experiment ties is '
    'tied over every course of seeking, whatever the policy of choice (`LumpedSeeking.seeking_keeps_order`); seeking '
    'turns the order once an experiment separating it is chosen (`LumpedSeeking.Agree.seeking_turns_tails`) |')
readme_row(PKG / 'README.zh.md',
    '| L1 | [`Becoming.LumpedSeeking`](Becoming/LumpedSeeking.lean) | 探求所不能分者（无伦理谓词）：受同一似然所并之二假设，于每一记录下保其先验之序'
    '（`LumpedSeeking.order_kept`）；每一实验皆不分之二假设，于每一探求历程下仍不分，无论择取之策略（`LumpedSeeking.seeking_keeps_order`）；'
    '一旦择取能分之实验，探求即转其序（`LumpedSeeking.Agree.seeking_turns_tails`） |')

# the periphery module and its checker
fe_target = FE / 'ExpectedFreeEnergyReals.lean'
assert not fe_target.exists(), fe_target
shutil.copyfile(PERIPHERY / 'ExpectedFreeEnergyReals.lean', fe_target)
source = (FE / 'check_free_energy_reals.py').read_text(encoding='utf-8')
scope_start = source.index('SCOPE = (\n')
scope_end = source.index('\n)\n', scope_start) + 3
SCOPE = '''SCOPE = (
    "On FreeEnergyReals, over Mathlib's reals, finite states and outcomes, and one policy with its predicted "
    "distribution over states given: expected free energy, risk (the divergence of the predicted outcomes from the "
    "preferred ones) plus ambiguity (the expected entropy of the likelihood), is the negative of the epistemic value "
    "less the pragmatic value (the expected log preference), with no hypothesis. The epistemic value is the "
    "divergence of the joint weights of states and outcomes from the product of the states' weights and the predicted "
    "outcomes, nonnegative where these are distributions, and the predicted outcomes' average of the divergence of "
    "FreeEnergyReals' posterior given each outcome from the states' weights. Where the likelihood reads a state only "
    "through its class, the epistemic value and the expected free energy are the classes', with their total weights, "
    "so two beliefs alike on the classes have one expected free energy; one likelihood for every state the policy may "
    "reach gives epistemic value nothing, and two states of one likelihood keep their prior ratio in the posterior "
    "under every outcome. Mathlib's conventions log 0 = 0 and x / 0 = 0 hold: where the predicted outcomes weigh an "
    "outcome of preference nothing, risk and pragmatic value are finite here though infinite as usually defined. That "
    "the weights are probabilities and the likelihood an agent's generative model are correspondences, not checked."
)
'''
new = source[:scope_start] + SCOPE + source[scope_end:]
for old, repl in [
    ('"""Check the periphery module on variational free energy over the reals.',
     '"""Check the periphery module on expected free energy over the reals.'),
    ("`FreeEnergyReals` imports the core's `Becoming.ConditionalWeights` and Mathlib's real logarithm\n"
     "and finite sums, so it is compiled with Lean 4.30.0-rc2 against the installed Mathlib\n"
     "(`SYSTEMS_MATHLIB_PROJECT`, default `~/repos/生生不息`); the core's closure is compiled\n"
     "with the same toolchain. Module resolution, declaration scanning and passed-receipt\n"
     "matching are those of the core checker. Every other module in the closure must\n"
     "match a passed receipt.",
     "`ExpectedFreeEnergyReals` imports the periphery module `FreeEnergyReals`, and through it the\n"
     "core's `Becoming.ConditionalWeights` and Mathlib's real logarithm and finite sums, so it is\n"
     "compiled with Lean 4.30.0-rc2 against the installed Mathlib (`SYSTEMS_MATHLIB_PROJECT`,\n"
     "default `~/repos/生生不息`); the core's closure and `FreeEnergyReals` are compiled with the\n"
     "same toolchain. Module resolution, declaration scanning and passed-receipt matching are\n"
     "those of the core checker. Every other module in the closure, `FreeEnergyReals` among them,\n"
     "must match a passed receipt."),
    ('TARGET = "FreeEnergyReals"', 'TARGET = "ExpectedFreeEnergyReals"'),
    ('RECEIPT = HERE / "free-energy-reals-verification.json"',
     'RECEIPT = HERE / "expected-free-energy-reals-verification.json"'),
    ('RETAINED = HERE / "free-energy-reals-checks"', 'RETAINED = HERE / "expected-free-energy-reals-checks"'),
    ('prefix="free-energy-reals-"', 'prefix="expected-free-energy-reals-"'),
]:
    assert new.count(old) == 1, old[:60]
    new = new.replace(old, repl)
fe_checker = FE / 'check_expected_free_energy_reals.py'
assert not fe_checker.exists(), fe_checker
fe_checker.write_text(new, encoding='utf-8')
fe_checker.chmod(0o755)
print('integrated: Becoming.LumpedSeeking joined (root import and L1 bullet, checker core list and scope, README rows EN '
      'and ZH); ExpectedFreeEnergyReals and check_expected_free_energy_reals.py in lean/free-energy; no landed module '
      'changed')
