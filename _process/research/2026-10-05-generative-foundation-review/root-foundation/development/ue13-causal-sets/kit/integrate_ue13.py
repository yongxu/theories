#!/usr/bin/env python3
"""UE13: join Becoming.CausalGrowth to the core as a leaf. Copies the new module (no landed module changes); adds it to
the checker's core list (after Becoming.Tasks, UE12's module) and its scope text (after Tasks'); imports it in the root
module with an L1 doc bullet after Tasks' (its import closure holds no L2 module, and it names no ethical predicate);
adds the package README rows (EN, ZH) after Tasks'. Every name the texts cite is checked against the scratch build's
axiom audit, so a renamed declaration fails here and not at render. Mirrors UE12's integrate_ue12.py; each edit is
asserted to apply exactly once.
usage (from the checkout root of the landing worktree, clean): python3 -B <kit>/integrate_ue13.py"""
import re
import shutil
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
TREE = HERE.parent / 'tree/Becoming'
AUDIT = HERE.parent / 'tree/.build/BecomingCausalGrowthAxiomAudit.lean'
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
NAMES = set(re.findall(r'^#print axioms Becoming\.(\S+)$', AUDIT.read_text(encoding='utf-8'), re.M))


def cited(text):
    """Every backticked CausalGrowth name in text is a declaration of the module."""
    names = set(re.findall(r'`(CausalGrowth\.[A-Za-z_.]+)`', text))
    missing = sorted(n for n in names if n not in NAMES)
    assert not missing, missing
    return text


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:70], text.count(old))
    path.write_text(text.replace(old, cited(new)), encoding='utf-8')


# the new module
target = PKG / 'Becoming/CausalGrowth.lean'
assert not target.exists(), target
shutil.copyfile(TREE / 'CausalGrowth.lean', target)

# the checker: core list and scope text
checker = PKG / 'check_becoming.py'
edit(checker, '"Becoming.Tasks", ', '"Becoming.Tasks", "Becoming.CausalGrowth", ')
edit(checker, """    "narrow strictly. "
    "Standpoints: """, """    "narrow strictly. "
    "Causal growth: causal sets read on the root and on processes. A link of the reach of a relation is "
    "a step of it, so every net whose reach is a relation contains its links; on a naturally labelled "
    "relation with decidable precedence every pair is reached by links, and with transitivity "
    "precedence is the reach of its links; deciding what lies between cannot be dropped (excluded "
    "middle), and on omega + 1 the top is preceded and never reached by links. Sequential growth, each "
    "birth a new maximal element whose past is a stem, holds the past, so the possible with the past "
    "held is the whole possible, and on every course from a causal set what can be born next, the "
    "stems, keeps widening. Of two configurations of one size the stems of the first are included in "
    "the second's exactly where the second's precedence is included in the first's, so of two courses "
    "from the empty set one includes the other's stems exactly where its precedence is included in the "
    "other's, and widening adds no continuation of any class read on precedence; finding the pair a "
    "widening loses is excluded middle, and most of these comparisons fail without the empty start. "
    "Read on what continues the inclusion reverses, no strict order contains both widenings, and read "
    "on both, courses differing by a pair are mixed. No configuration renews without end; of the extremes' "
    "limits only the chain's does. Read on links a finer class can gain or lose continuation by "
    "widening, and up to relabelling the kinds of birth do not reverse precedence. "
    "Standpoints: """)

# the root module: import, and the new bullet after Tasks'
root = PKG / 'Becoming.lean'
edit(root, 'import Becoming.Tasks\n', 'import Becoming.Tasks\nimport Becoming.CausalGrowth\n')
edit(root, """  witness. A leaf (board item UE12).
* `Becoming.Growth` (L1):""", """  witness. A leaf (board item UE12).
* `Becoming.CausalGrowth` (L1): causal sets read on the root and on processes. The links of a
  relation, causal set theory's term, are the pairs it relates with nothing it relates between
  (`CausalGrowth.links`); a link of the root's reach `«及» R` is a step of `R`
  (`CausalGrowth.link_of_reach`), so every net whose reach is a relation contains its links
  (`CausalGrowth.links_least`). On a naturally labelled relation with decidable precedence every pair
  is reached by links (`CausalGrowth.reach_links`), and with transitivity precedence is the reach of
  its links (`CausalGrowth.reach_links_iff`); deciding what lies between cannot be dropped
  (`CausalGrowth.reach_links_all_iff_em`), and on `ω + 1` the top is preceded and never reached by
  links (`CausalGrowth.OmegaPlusOne.not_reach_top`). Sequential growth is a process
  (`CausalGrowth.process`): a move chooses a stem, a set of elements closed downward
  (`CausalGrowth.Stem`), and gives birth to a new maximal element preceded exactly by it
  (`CausalGrowth.birth`, `CausalGrowth.birth_maximal`); every move holds the past
  (`CausalGrowth.step_holdsPast`), so the possible with the past held is the whole possible
  (`CausalGrowth.possibleHeld_iff`), and on every course from a causal set what can be born next
  keeps widening (`CausalGrowth.keepsWidening`). Of two configurations of one size every stem of the
  first is a stem of the second exactly where the second's precedence is included in the first's
  (`CausalGrowth.stems_included_iff`), so of two courses from the empty set one includes the other's
  stems at every offset exactly where its precedence is included in the other's
  (`CausalGrowth.rangeIncludes_iff`), finding the pair a widening loses being excluded middle
  (`CausalGrowth.pair_converse_iff_em`), and widening adds no continuation of any class read on
  precedence (`CausalGrowth.continuation_of_rangeIncludes`); most of these comparisons fail without
  the empty start (`CausalGrowth.Starts.strict_needs_starts`). Read on what continues within the one
  class the inclusion reverses (`CausalGrowth.rangeIncludes_continuing_iff`), and no strict order
  contains both widenings (`CausalGrowth.no_order_contains_both`); read on both, courses differing by
  a pair are mixed (`CausalGrowth.mixed_of_pair`). No configuration renews without end
  (`CausalGrowth.ordered_not_renews`), and of the extremes' limits only the chain's does
  (`CausalGrowth.antichainLimit_not_renews`, `CausalGrowth.chainLimit_renews`). Read on links a finer
  class can gain or lose continuation by widening (`CausalGrowth.Finer.continues`,
  `CausalGrowth.Finer.not_continues`, `CausalGrowth.Finer.loses`), and up to relabelling the kinds of
  birth do not reverse precedence (`CausalGrowth.Kinds.not_included_antichain_chain`,
  `CausalGrowth.Kinds.not_included_chain_antichain`). Each law is near-definitional, a witness or a
  calibration. A leaf (board item UE13).
* `Becoming.Growth` (L1):""")


def readme_row(path, row):
    lines = path.read_text(encoding='utf-8').split('\n')
    at = [i for i, line in enumerate(lines) if line.startswith('| L1 | [`Becoming.Tasks`]')]
    assert len(at) == 1, at
    assert not any('[`Becoming.CausalGrowth`]' in line for line in lines)
    lines[at[0] + 1:at[0] + 1] = [cited(row)]
    path.write_text('\n'.join(lines), encoding='utf-8')


# the package README rows (EN, ZH), after Tasks'
readme_row(PKG / 'README.md',
    '| L1 | [`Becoming.CausalGrowth`](Becoming/CausalGrowth.lean) | causal sets read on the root and on processes (no '
    'ethical predicate): a link of the reach is a step, so every net whose reach is a relation contains its links '
    '(`CausalGrowth.link_of_reach`, `CausalGrowth.links_least`); precedence is the reach of its links on a naturally '
    'labelled relation with decidable precedence (`CausalGrowth.reach_links_iff`), the decision not droppable '
    '(`CausalGrowth.reach_links_all_iff_em`), not on `ω + 1` (`CausalGrowth.OmegaPlusOne.not_reach_top`); sequential '
    'growth holds the past (`CausalGrowth.step_holdsPast`, `CausalGrowth.possibleHeld_iff`) and on every course from a '
    'causal set what can be born next keeps widening (`CausalGrowth.keepsWidening`); the stems reverse the inclusion of '
    'precedence (`CausalGrowth.stems_included_iff`, `CausalGrowth.rangeIncludes_iff`), so widening adds no continuation '
    'read on precedence (`CausalGrowth.continuation_of_rangeIncludes`), and finding the pair a widening loses is excluded '
    'middle (`CausalGrowth.pair_converse_iff_em`); read on what continues the inclusion reverses and no '
    'strict order contains both (`CausalGrowth.rangeIncludes_continuing_iff`, `CausalGrowth.no_order_contains_both`); '
    'no configuration renews without end (`CausalGrowth.ordered_not_renews`); read on links a finer class can gain or '
    'lose continuation (`CausalGrowth.Finer.continues`, `CausalGrowth.Finer.loses`); up to relabelling the kinds of '
    'birth do not reverse precedence (`CausalGrowth.Kinds.not_included_chain_antichain`); near-definitional |')

readme_row(PKG / 'README.zh.md',
    '| L1 | [`Becoming.CausalGrowth`](Becoming/CausalGrowth.lean) | 因果集读于根与过程之上（无伦理谓词）：及之覆盖即一步，'
    '故凡其及为一关系之网皆含其覆盖（`CausalGrowth.link_of_reach`、`CausalGrowth.links_least`）；自然编号且先后可判定之关系上，'
    '先后即其覆盖之及（`CausalGrowth.reach_links_iff`），此判定不可去（`CausalGrowth.reach_links_all_iff_em`），于 `ω + 1` 则否'
    '（`CausalGrowth.OmegaPlusOne.not_reach_top`）；序贯生长持守过去（`CausalGrowth.step_holdsPast`、`CausalGrowth.possibleHeld_iff`），'
    '自因果集起之每一历程上次可生者不断扩大（`CausalGrowth.keepsWidening`）；茎反转先后之包含（`CausalGrowth.stems_included_iff`、'
    '`CausalGrowth.rangeIncludes_iff`），故扩大不增读于先后之相续（`CausalGrowth.continuation_of_rangeIncludes`），求扩大所失之对即排中律'
    '（`CausalGrowth.pair_converse_iff_em`）；读于相续则包含反转，'
    '无一严格之序兼含二者（`CausalGrowth.rangeIncludes_continuing_iff`、`CausalGrowth.no_order_contains_both`）；无构型生生不息'
    '（`CausalGrowth.ordered_not_renews`）；读于覆盖，较细之类可因扩大而得或失相续（`CausalGrowth.Finer.continues`、'
    '`CausalGrowth.Finer.loses`）；重编号下生之种类不反转先后（`CausalGrowth.Kinds.not_included_chain_antichain`）；近乎定义 |')
print('integrated: Becoming.CausalGrowth joined (root import and L1 bullet, checker core list and scope, README rows EN '
      'and ZH); no landed module changed')
