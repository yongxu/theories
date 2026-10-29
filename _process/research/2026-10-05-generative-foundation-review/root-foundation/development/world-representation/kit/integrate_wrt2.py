#!/usr/bin/env python3
"""WRT2: join Becoming.GrammarTransport (the grammar layer, lemmas) and Becoming.WorldRepresentation (the World layer) to
the core as leaves. Copies the two new modules (no landed module changes); adds them to the checker's core list (after
Becoming.GrammarLaws and Becoming.ContinuedClasses) and its scope text (after GrammarLaws' and ContinuedClasses'
sentences); imports them in the root module, each with an L1 doc bullet after GrammarLaws' and ContinuedClasses'
bullets (neither names an ethical predicate, and neither's import closure holds an L2 module); adds the package README
rows (EN, ZH) after GrammarLaws' and ContinuedClasses' rows. Every backticked name the texts cite from the two modules
is checked against the scratch build's axiom audits, so a renamed declaration fails here and not at render. Mirrors
UE15's integrate_ue15.py; each edit is asserted to apply exactly once.
usage (from the checkout root of the landing worktree, clean): python3 -B <kit>/integrate_wrt2.py"""
import re
import shutil
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
TREE = HERE.parent / 'tree/Becoming'
AUDITS = [HERE.parent / 'tree/.build/BecomingGrammarTransportAxiomAudit.lean',
          HERE.parent / 'tree/.build/BecomingWorldRepresentationAxiomAudit.lean']
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
NAMES = set()
for audit in AUDITS:
    NAMES |= set(re.findall(r'^#print axioms Becoming\.(\S+)$', audit.read_text(encoding='utf-8'), re.M))
OURS = ('World.', 'Web.sameStep', 'Web.partialIdentity', 'Steps.along_iff_itself', 'Steps.later_iff',
        'Steps.sameOrLater_iff', 'Steps.along_endless', 'Reidentify.atStep', 'Reidentify.onOccurrences',
        'Reidentify.sameStep_carried', 'Reidentify.withinStep_carried', 'Reidentify.partialIdentity_carried',
        'Diagonal.no_injection_of_predicates')


def cited(text):
    """Every backticked name of the two modules the text cites is one of their declarations."""
    found = set(re.findall(r'`((?:World|Web|Steps|Reidentify|Diagonal)\.[A-Za-z_.]+|«[^»]+»)`', text))
    ours = {n for n in found if n.startswith(OURS) or (n.startswith('«') and ('之对应' in n or '之像' in n or n in
            ('«一一对应»', '«尽之拉回»', '«谓之自反»')))}
    missing = sorted(n for n in ours if n not in NAMES and not n.startswith('World.Idle')
                     and n not in ('World.of', 'World.Conserves', 'World.idle'))
    assert not missing, missing
    return text


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:70], text.count(old))
    path.write_text(text.replace(old, cited(new)), encoding='utf-8')


# the new modules
for name in ('GrammarTransport', 'WorldRepresentation'):
    target = PKG / f'Becoming/{name}.lean'
    assert not target.exists(), target
    shutil.copyfile(TREE / f'{name}.lean', target)

# the checker: core list and scope text
checker = PKG / 'check_becoming.py'
edit(checker, '"Becoming.GrammarLaws", "Becoming.World"', '"Becoming.GrammarLaws", "Becoming.GrammarTransport", "Becoming.World"')
edit(checker, '"Becoming.ContinuedClasses", "Becoming.Wholes"',
     '"Becoming.ContinuedClasses", "Becoming.WorldRepresentation", "Becoming.Wholes"')
edit(checker, """    "GrammarPath: a line under a class that must pass through a set holds a member of it alike to its start; \"""",
     """    "GrammarTransport: the grammar's listed terms are kept by a one-to-one correspondence of models carrying the "
    "relations they read, carrying being read through the grammar's image and kept by its operations, a predicate "
    "carried as its partial identity; ending on every branch reflects along any map carrying continuation from a "
    "closed region. "
    "GrammarPath: a line under a class that must pass through a set holds a member of it alike to its start; \"""")
edit(checker, """    "Identity: re-identifying formations one to one at each step leaves every step's levels, \"""",
     """    "WorldRepresentation: the World as a model of the grammar both ways, and where amounts fail. Every "
    "re-identification is a one-to-one correspondence of the occurrence model's name-free part (the same-step class, "
    "conservation's step, activity, standing and presence as partial identities, five relations within a step), so "
    "each listed term read there is fixed; recurrence is a statement at the model through the names; the relational "
    "part ranges over everything, conservation is exactly a relation of its form, labelled by standings, and what "
    "amounts induce is decided; the model does not determine standings, balance is not determined by the web and the "
    "signs of exchange, conservation is never identity on the predicates of Nat, and a line of falls ends, a "
    "condition of the World's image and not a law of the grammar. "
    "Identity: re-identifying formations one to one at each step leaves every step's levels, \"""")

# the root module: imports, and the new bullets
root = PKG / 'Becoming.lean'
edit(root, 'import Becoming.GrammarLaws\n', 'import Becoming.GrammarLaws\nimport Becoming.GrammarTransport\n')
edit(root, 'import Becoming.ContinuedClasses\n', 'import Becoming.ContinuedClasses\nimport Becoming.WorldRepresentation\n')
edit(root, "* `Becoming.Ideals` (L1):", """* `Becoming.GrammarTransport` (L1): the grammar kept by one-to-one correspondence of models, for
  the terms the World's instance theorems and `Becoming.WorldRepresentation` read. A correspondence
  (`«一一对应»`) carrying the relations a listed term reads carries the term (`«生之对应»`,
  `«相续之对应»`, `«不穷之对应»`, `«核之对应»`, `«全生成之对应»` and the others); carrying is read
  through the grammar's image (`«对应之像»`) and kept by its operations (`«合之像»`, `«而之像»`,
  `«及之像»`), and a predicate is carried as its partial identity (`«部分恒等之像»`). Ending on every
  branch is pulled back along any map carrying continuation from a closed region (`«尽之拉回»`).
  Lemmas of the World's representation, with no record of their own (board item WRT2).
* `Becoming.Ideals` (L1):""")
edit(root, "* `Becoming.Persistence` (L1):", """* `Becoming.WorldRepresentation` (L1): the World as a model of the grammar, both ways, and where
  amounts fail. The occurrence model's name-free part: the same-step class (`Web.sameStep`),
  conservation's step (`World.conservationStep`), activity, standing and presence as partial
  identities (`Web.partialIdentity`), and five relations within a step (`World.withinStep`). Every
  re-identification is a one-to-one correspondence carrying all ten (`Reidentify.onOccurrences`,
  `World.reidentify_carries`), so each listed term of `Becoming.GrammarTransport` read there is fixed
  (`World.sheng_conservation_reidentify`); recurrence is a statement at the model through the names'
  step (`World.arisingRecurs_iff`, `World.ceasingRecurs_iff`). The converse: the relational part ranges
  over everything (`World.ofRelations`, `World.ofModel_model`); conservation is exactly the relations of
  its form (`World.conserves_form`, `World.ofConservationForm_conserves`), labelled by standings
  (`World.conserves_iff_same_level`); what amounts induce is decided (`World.amounts_decided`), and that
  every world decides activity is exactly excluded middle (`World.decides_activity_iff_em`). The
  failure on amounts: the model does not determine standings (`World.standingAt_alike`); balance is not
  determined by the web and the signs of exchange (`World.balance_needs_conservation`); conservation is
  never identity on the predicates of `Nat` (`World.not_conserves_identity`, through
  `Diagonal.no_injection_of_predicates`); a line of falls ends (`World.falls_exhaust`, from
  `Amounts.falls_end`), a condition of the World's image and no law of the grammar
  (`Steps.along_endless`). A leaf (board item WRT2).
* `Becoming.Persistence` (L1):""")


def readme_row(path, after, row, absent):
    lines = path.read_text(encoding='utf-8').split('\n')
    at = [i for i, line in enumerate(lines) if line.startswith(after)]
    assert len(at) == 1, (after, at)
    assert not any(absent in line for line in lines), absent
    lines[at[0] + 1:at[0] + 1] = [cited(row)]
    path.write_text('\n'.join(lines), encoding='utf-8')


GT_EN = ('| L1 | [`Becoming.GrammarTransport`](Becoming/GrammarTransport.lean) | the grammar kept by one-to-one correspondence '
         '(no premise): a correspondence (`«一一对应»`) carrying what a listed term reads carries the term (`«生之对应»`, '
         '`«核之对应»` and the others), carrying read through the grammar\'s image (`«对应之像»`) and kept by its '
         'operations, a predicate carried as its partial identity (`«部分恒等之像»`); ending on every branch pulled back '
         'along a homomorphism (`«尽之拉回»`); lemmas of the World\'s representation |')
GT_ZH = ('| L1 | [`Becoming.GrammarTransport`](Becoming/GrammarTransport.lean) | 文法为一一对应所保（不加前提）：一一对应（`«一一对应»`）'
         '携一列出之项所读者，则携其项（`«生之对应»`、`«核之对应»` 等）；携以文法之像读之（`«对应之像»`），为其运算所保；谓词以其部分恒等携之'
         '（`«部分恒等之像»`）；处处终尽沿同态拉回（`«尽之拉回»`）；世界之表示之引理 |')
WR_EN = ('| L1 | [`Becoming.WorldRepresentation`](Becoming/WorldRepresentation.lean) | the World as a model of the grammar, '
         'both ways, and where amounts fail (no ethical predicate): every re-identification a correspondence of the '
         'occurrence model\'s name-free part (`World.reidentify_carries`); the relational part ranging over everything '
         '(`World.ofModel_model`); conservation exactly its form (`World.ofConservationForm_conserves`), what amounts '
         'induce decided (`World.amounts_decided`); the model not determining standings (`World.standingAt_alike`), '
         'balance not determined by the web and the signs of exchange (`World.balance_needs_conservation`), conservation '
         'never identity on the predicates of `Nat` (`World.not_conserves_identity`, with '
         '`Diagonal.no_injection_of_predicates`), a line of falls ending (`World.falls_exhaust`); near-definitional, '
         'lemmas and witnesses |')
WR_ZH = ('| L1 | [`Becoming.WorldRepresentation`](Becoming/WorldRepresentation.lean) | 世界作为文法之模型，两向，及数量处之不成'
         '（无伦理谓词）：每一重认为出现模型之无名部分之一一对应（`World.reidentify_carries`）；关系部分遍及一切（`World.ofModel_model`）；'
         '守恒恰为其形（`World.ofConservationForm_conserves`），数量所引者皆可判定（`World.amounts_decided`）；模型不定站位'
         '（`World.standingAt_alike`），网与交换之号不定平衡（`World.balance_needs_conservation`），守恒于 `Nat` 之谓词上永非同一'
         '（`World.not_conserves_identity`，并 `Diagonal.no_injection_of_predicates`），落之线终尽（`World.falls_exhaust`）；'
         '近乎定义、引理与例 |')
readme_row(PKG / 'README.md', '| L0 | [`Becoming.GrammarLaws`]', GT_EN, '[`Becoming.GrammarTransport`]')
readme_row(PKG / 'README.zh.md', '| L0 | [`Becoming.GrammarLaws`]', GT_ZH, '[`Becoming.GrammarTransport`]')
readme_row(PKG / 'README.md', '| L1 | [`Becoming.ContinuedClasses`]', WR_EN, '[`Becoming.WorldRepresentation`]')
# the Chinese table holds no ContinuedClasses row, so the row goes after Persistence's there
readme_row(PKG / 'README.zh.md', '| L1 | [`Becoming.Persistence`]', WR_ZH, '[`Becoming.WorldRepresentation`]')
print('integrated: Becoming.GrammarTransport and Becoming.WorldRepresentation joined (root imports and L1 bullets, '
      'checker core list and scope, README rows EN and ZH); no landed module changed')
