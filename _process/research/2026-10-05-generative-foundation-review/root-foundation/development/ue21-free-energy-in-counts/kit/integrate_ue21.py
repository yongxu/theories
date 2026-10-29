#!/usr/bin/env python3
"""UE21: join Becoming.FreeEnergyCounting to the core as a leaf, after UE19. Copies the new module (no landed module
changes); adds it to the checker's core list (after Becoming.LumpedSeeking) and its scope text (before the
standpoints'); imports it in the root module with an L1 doc bullet before Growth's (its import, ConditionalWeights, is
L1, and it names no ethical predicate); adds the package README rows (EN, ZH) after LumpedSeeking's. Every name the
texts cite is checked against the scratch build's axiom audit. Mirrors UE19's integrate_ue19.py; each edit is asserted
to apply exactly once.
usage (from the checkout root of the landing worktree, clean): python3 -B <kit>/integrate_ue21.py"""
import re
import shutil
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
TREE = HERE.parent / 'tree/Becoming'
AUDIT = HERE.parent / 'tree/.build/BecomingFreeEnergyCountingAxiomAudit.lean'
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
NAMES = set(re.findall(r'^#print axioms Becoming\.(\S+)$', AUDIT.read_text(encoding='utf-8'), re.M))


def cited(text):
    """Every backticked FreeEnergyCounting name in text is a declaration of the module."""
    names = set(re.findall(r'`(FreeEnergyCounting\.[A-Za-z_.]+)`', text))
    missing = sorted(n for n in names if n not in NAMES)
    assert not missing, missing
    return text


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:70], text.count(old))
    path.write_text(text.replace(old, cited(new)), encoding='utf-8')


target = PKG / 'Becoming/FreeEnergyCounting.lean'
assert not target.exists(), target
shutil.copyfile(TREE / 'FreeEnergyCounting.lean', target)
checker = PKG / 'check_becoming.py'
edit(checker, '"Becoming.LumpedSeeking", ', '"Becoming.LumpedSeeking", "Becoming.FreeEnergyCounting", ')
edit(checker, """
    "Standpoints: """, """
    "The free-energy bound in counts: for natural counts and natural weights over any listed hypotheses, the total "
    "count to its own power times the product of each weight to its count is at most the total weight to the total "
    "count times the product of each count to itself, from the arithmetic-geometric mean inequality in counts proved "
    "from a Bernoulli-type inequality, with equality exactly where the counts are proportional to the weights; in a "
    "generative model the total weight is the record's, the count beliefs at the bound are exactly those in "
    "proportion to the joint weights, and, with the hypotheses listed once, those at the shares given the record. "
    "Standpoints: """)

root = PKG / 'Becoming.lean'
edit(root, 'import Becoming.LumpedSeeking\n', 'import Becoming.LumpedSeeking\nimport Becoming.FreeEnergyCounting\n')
edit(root, """* `Becoming.Growth` (L1):""", """* `Becoming.FreeEnergyCounting` (L1): the free-energy bound in counting form. For natural counts
  `n` and weights `a` over any listed hypotheses, `N ^ N * ∏ a ^ n ≤ A ^ N * ∏ n ^ n`, the bound
  exponentiated for a positive total (`FreeEnergyCounting.bound`), from the arithmetic–geometric mean inequality in
  counts (`FreeEnergyCounting.mean_two`) proved from a Bernoulli-type inequality
  (`FreeEnergyCounting.bernoulli`); equal exactly where the counts are proportional to the weights
  (`FreeEnergyCounting.bound_eq_iff`). In a generative model the total weight is the record's, and
  the count beliefs at the bound are exactly those in proportion to the joint weights
  (`FreeEnergyCounting.given_record_eq_iff`), with the hypotheses listed once those at the shares
  given the record (`FreeEnergyCounting.given_record_eq_iff_share`). Its real form, agreeing with it
  on the support, is the periphery's `FreeEnergyReals`.
  A leaf importing `Becoming.ConditionalWeights` (board item UE21).
* `Becoming.Growth` (L1):""")


def readme_row(path, row):
    lines = path.read_text(encoding='utf-8').split('\n')
    at = [i for i, line in enumerate(lines) if line.startswith('| L1 | [`Becoming.LumpedSeeking`]')]
    assert len(at) == 1, at
    assert not any('[`Becoming.FreeEnergyCounting`]' in line for line in lines)
    lines[at[0] + 1:at[0] + 1] = [cited(row)]
    path.write_text('\n'.join(lines), encoding='utf-8')


readme_row(PKG / 'README.md',
    '| L1 | [`Becoming.FreeEnergyCounting`](Becoming/FreeEnergyCounting.lean) | the free-energy bound in counting form (no '
    'ethical predicate): `N ^ N * ∏ a ^ n ≤ A ^ N * ∏ n ^ n` (`FreeEnergyCounting.bound`), equal exactly in proportion '
    '(`FreeEnergyCounting.bound_eq_iff`); in a generative model, hypotheses listed once, the count beliefs at the bound '
    'are those at the shares given the record (`FreeEnergyCounting.given_record_eq_iff_share`) |')
readme_row(PKG / 'README.zh.md',
    '| L1 | [`Becoming.FreeEnergyCounting`](Becoming/FreeEnergyCounting.lean) | 计数形式之自由能界（无伦理谓词）：'
    '`N ^ N * ∏ a ^ n ≤ A ^ N * ∏ n ^ n`（`FreeEnergyCounting.bound`），恰于成比例处取等（`FreeEnergyCounting.bound_eq_iff`）；'
    '于生成模型，假设列而不重时，达界之计数信念即记录下份额之信念（`FreeEnergyCounting.given_record_eq_iff_share`） |')
print('integrated: Becoming.FreeEnergyCounting joined (root import and L1 bullet, checker core list and scope, README '
      'rows EN and ZH); no landed module changed')
