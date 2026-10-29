#!/usr/bin/env python3
"""WRP2: join the three modules. `Becoming.GrammarLaws` and `Becoming.GrammarTransport` are replaced by the tree's
versions, which only add declarations and change six proofs (the signature audit, signatures.json, at the latest
core receipt, whose sources must be the checkout's); `Becoming.ProcessRepresentation` is a new leaf at L1. Adds it to
the checker's core list (after `Becoming.WorldRepresentation`) and its scope text, with GrammarLaws' and
GrammarTransport's sentences extended; imports it in the root module with an L1 bullet after WorldRepresentation's,
and extends GrammarLaws' and GrammarTransport's bullets; adds its package README rows (EN, ZH) after
WorldRepresentation's and extends GrammarLaws' and GrammarTransport's rows. Every backticked name the texts cite from
the three modules is checked against the scratch build's axiom audits, so a renamed declaration fails here and not
at render. Mirrors WRT2's integrate_wrt2.py; each edit is asserted to apply exactly once.
usage (from the checkout root of the landing worktree, clean): python3 -B <kit>/integrate_wrp2.py"""
import hashlib
import json
import re
import shutil
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
TREE = HERE.parent / 'tree/Becoming'
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
MODULES = ('GrammarLaws', 'GrammarTransport', 'ProcessRepresentation')
NAMES = set()
for m in MODULES:
    audit = HERE.parent / f'tree/.build/Becoming{m}AxiomAudit.lean'
    NAMES |= set(re.findall(r'^#print axioms Becoming\.(\S+)$', audit.read_text(encoding='utf-8'), re.M))


def latest_receipt():
    return sorted(p for p in (PKG / 'becoming-checks').iterdir() if re.fullmatch(r'\d{8}T\d{6}\.\d+Z', p.name))[-1]


def cited(text):
    """Every backticked name of the three modules the texts cite is one of their declarations."""
    found = set(re.findall(r'`([A-Za-z_.]*«[^»]+»[A-Za-z_.]*|[A-Za-z_]+(?:\.[A-Za-z_]+)*)`', text))
    ours = {n for n in found if '历' in n or n in NEW_ENGLISH or n.startswith(('Twist.', 'Flip.', 'NoMoves.',
                                                                               'NoConfigurations.', 'Forgotten.'))
            or n in ('«保之像»', '«延之拉回»', '«延之对应»', '«迭之对应»', '«迭之像»', '«迭内之对应»', '«闭之对应»',
                     '«定后之对应»', '«定前之对应»', '«同行之对应»', '«一一对应».prod')}
    missing = sorted(n for n in ours if n not in NAMES)
    assert not missing, missing
    return text


NEW_ENGLISH = {'moveRel_mk', 'mk_moveRel', 'steps_iff_moveRel', 'steps_one_move', 'steps_edgeProcess',
               'steps_unlabelled', 'steps_lawProcess', 'enabled_iff_neng', 'forall_steps_iff', 'forall_moveRel_iff',
               'class_is_claims', 'step_iff_withMove', 'withMove_image_iff', 'reading_next_move_not_withMove',
               'withMove_of_renaming', 'configurationRenaming', 'moveRenaming', 'renaming_of_withMove',
               'renaming_moveRel', 'renaming_steps', 'renaming_trace', 'renaming_iterate', 'renaming_reach',
               'renaming_returns', 'renaming_invariant', 'renaming_determined', 'renaming_lossless', 'renaming_goAlike',
               'renaming_yan', 'trace_iff_li', 'feasible_iff_li', 'factorsThrough_iff_image', 'run_image',
               'run_iff_image', 'yan_iff_keepsMoving', 'run_yan', 'yan_line_iff_dependentChoice', 'yan_line_of_list'}


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:70], text.count(old))
    path.write_text(text.replace(old, cited(new)), encoding='utf-8')


# the modules: the two landed ones replaced only where the audit compared against these very sources
receipt = latest_receipt()
R = json.loads((receipt / 'verification.json').read_text())
audit = json.loads((HERE.parent / 'signatures.json').read_text(encoding='utf-8'))
assert audit['receipt'] == receipt.name, ('the signature audit is not at the latest receipt', audit['receipt'], receipt.name)
for m in ('GrammarLaws', 'GrammarTransport'):
    target = PKG / f'Becoming/{m}.lean'
    assert hashlib.sha256(target.read_bytes()).hexdigest() == R['source_sha256'][f'Becoming.{m}'], (
        m, 'changed since the receipt: merge the tree onto it and rerun the audit')
    shutil.copyfile(TREE / f'{m}.lean', target)
target = PKG / 'Becoming/ProcessRepresentation.lean'
assert not target.exists(), target
shutil.copyfile(TREE / 'ProcessRepresentation.lean', target)

# the checker: core list and scope text
checker = PKG / 'check_becoming.py'
edit(checker, '"Becoming.ContinuedClasses", "Becoming.WorldRepresentation", "Becoming.Wholes"',
     '"Becoming.ContinuedClasses", "Becoming.WorldRepresentation", "Becoming.ProcessRepresentation", "Becoming.Wholes"')
edit(checker, """    "they compose, steps read backward are steps of the converse, and an unending line has steps of every length; \"""",
     """    "they compose, steps read backward are steps of the converse, and an unending line has steps of every length; "
    "passing through a word's relations in turn composes along joined words, reads its last letter last and the "
    "reversed word by the converse relations backward, merges nothing where no letter merges and keeps alike where "
    "each goes alike, n steps being its case for one relation and six laws of n steps its cases; \"""")
edit(checker, """    "carried as its partial identity; ending on every branch reflects along any map carrying continuation from a "
    "closed region. \"""",
     """    "carried as its partial identity; ending on every branch reflects along any map carrying continuation from a "
    "closed region, and going on along some branch along any map lifting continuation; a map preserves a relation "
    "exactly where its image lies within the other; steps, passing through a word, within n steps, closed regions, a "
    "fixed successor and predecessor, going alike and going on along some branch are kept, and correspondences "
    "compose side by side. \"""")
edit(checker, """    "Identity: re-identifying formations one to one at each step leaves every step's levels, \"""",
     """    "ProcessRepresentation: processes in the grammar both ways. A process is exactly its relations, one per move, "
    "by definition, and its steps their union; so a property of relations shared by relations alike pointwise holds "
    "of every process's steps exactly where it holds of every relation. Every relation is a process's steps and every "
    "class a frame's class of claims. The model with the move inside recovers the process on its fixed carrier, its "
    "image exactly the relations leaving the next move open; a renaming relating two processes is a correspondence of "
    "these models carrying the steps and the classes of the same move and the same configuration, and from a "
    "configuration and a move every such correspondence is a renaming relating them, while neither class alone "
    "suffices and with no move or no configuration a point is needed; a renaming keeps traces with the word renamed, n "
    "steps, reach, returning, invariants, determination, merging nothing, going alike and going on. A trace "
    "is passing through the moves' relations along its word; factoring through a map is the image of each move's "
    "relation lying within; a run's configurations carry the line of steps into the steps, exactly so with the move "
    "inside; going on along some branch is lying in a family that keeps moving, a line from it exactly dependent "
    "choice and within finitely many configurations a line with nothing chosen; the steps forget the moves. "
    "Identity: re-identifying formations one to one at each step leaves every step's levels, \"""")

# the root module: the import, the new bullet, and the two extended bullets
root = PKG / 'Becoming.lean'
edit(root, 'import Becoming.GrammarRegularity\n', 'import Becoming.GrammarRegularity\nimport Becoming.ProcessRepresentation\n')
edit(root, """  Lemmas of the World's representation, with no record of their own (board item WRT2).""",
     """  Along maps, a map preserves a relation exactly where its image lies within the other (`«保之像»`),
  and going on along some branch is pulled back along any map lifting continuation (`«延之拉回»`);
  steps, passing through a word, within `n` steps, closed regions, a fixed successor and
  predecessor, going alike and going on are kept (`«迭之对应»`, `«历之对应»`, `«迭内之对应»`,
  `«闭之对应»`, `«定后之对应»`, `«定前之对应»`, `«同行之对应»`, `«延之对应»`), and correspondences
  compose side by side (`«一一对应».prod`). Lemmas of the World's representation and the processes',
  cited in their records (board items WRT2, WRP2).""")
edit(root, """  as can be refuted (`«或有后则或迭»`); an unending line has steps of every length (`«不穷则迭»`).
  `Becoming.Withholding`'s closed forms""",
     """  as can be refuted (`«或有后则或迭»`); an unending line has steps of every length (`«不穷则迭»`).
  Passing through a word's relations in turn (`«历»`) has `«迭»` as its case for one relation repeated
  (`«迭即历»`);
  it composes along joined words (`«历之接»`), reads its last letter last (`«历之末步»`) and the
  reversed word by the converse relations backward (`«历之逆»`), merges nothing where no letter
  merges (`«历之定前»`) and keeps alike where each goes alike (`«同行之历»`), and six laws of `«迭»`
  are these laws' cases for one relation (board item WRP2).
  `Becoming.Withholding`'s closed forms""")
n = root.read_text(encoding='utf-8').index('* `Becoming.WorldRepresentation` (L1):')
edit(root, '* `Becoming.Persistence` (L1):', """* `Becoming.ProcessRepresentation` (L1): processes in the grammar both ways. A process is exactly
  its relations, one per move, by definition (`moveRel_mk`, `mk_moveRel`), and its steps their
  union (`steps_iff_moveRel`); a property of relations shared by relations alike pointwise holds of
  every process's steps exactly where it holds of every relation (`forall_steps_iff`). Every
  relation is a process's steps (`steps_edgeProcess`) and every class a frame's class of claims
  (`class_is_claims`). The model with the move inside (`withMove`) has as image exactly the
  relations leaving the next move open (`withMove_image_iff`); a renaming relating two processes is
  a correspondence of these models carrying the steps and the classes of the same move and the same
  configuration (`withMove_of_renaming`), and from a configuration and a move every such
  correspondence is a renaming relating them (`renaming_of_withMove`), while neither class alone
  suffices (`Twist.not_renamed`, `Flip.not_renamed`) and with no move or no configuration a point is
  needed (`NoMoves.not_renamed`, `NoConfigurations.not_renamed`). A renaming keeps traces with the
  word renamed (`renaming_trace`), `n` steps, reach, returning, invariants, determination, merging
  nothing, going alike and going on (`renaming_iterate`, `renaming_reach`, `renaming_determined`,
  `renaming_goAlike`, `renaming_yan` and the others). A trace is passing through the
  moves' relations along its word (`trace_iff_li`); factoring through a map is the image of each
  move's relation lying within (`factorsThrough_iff_image`); a run's configurations carry the line of
  steps into the steps, exactly so with the move inside (`run_iff_image`); going on along some
  branch is lying in a family that keeps moving (`yan_iff_keepsMoving`), a line from it exactly
  dependent choice (`yan_line_iff_dependentChoice`) and within finitely many configurations one with
  nothing chosen (`yan_line_of_list`); the steps forget the moves (`Forgotten.moves_forgotten`). A
  leaf (board item WRP2).
* `Becoming.Persistence` (L1):""")
assert root.read_text(encoding='utf-8').index('* `Becoming.ProcessRepresentation` (L1):') > n, 'bullet order'


def row(path, after, line, absent):
    lines = path.read_text(encoding='utf-8').split('\n')
    at = [i for i, x in enumerate(lines) if x.startswith(after)]
    assert len(at) == 1, (after, at)
    assert not any(absent in x for x in lines), absent
    lines[at[0] + 1:at[0] + 1] = [cited(line)]
    path.write_text('\n'.join(lines), encoding='utf-8')


PR_EN = ('| L1 | [`Becoming.ProcessRepresentation`](Becoming/ProcessRepresentation.lean) | processes in the grammar both '
         'ways (no ethical predicate): a process exactly its relations, one per move, by definition (`moveRel_mk`), a '
         'property of relations shared by relations alike pointwise holding of every process\'s steps exactly where '
         'of every relation (`forall_steps_iff`); every relation a process\'s steps, every class a frame\'s class of '
         'claims (`class_is_claims`); the model with the move inside, its image the relations leaving the next move '
         'open (`withMove_image_iff`), a correspondence carrying its steps and the classes of the same move and the '
         'same configuration a renaming from a point (`renaming_of_withMove`), neither class alone enough '
         '(`Twist.not_renamed`, `Flip.not_renamed`), a renaming keeping the bridged notions (`renaming_trace`, '
         '`renaming_determined` and the others); a trace passing through the moves\' relations along its word '
         '(`trace_iff_li`), runs and factoring as images lying within (`run_iff_image`, `factorsThrough_iff_image`), '
         'going on along some branch a family keeping moving (`yan_iff_keepsMoving`), a line from it dependent '
         'choice (`yan_line_iff_dependentChoice`); the steps forgetting the moves (`Forgotten.moves_forgotten`); '
         'near-definitional, lemmas and witnesses |')
PR_ZH = ('| L1 | [`Becoming.ProcessRepresentation`](Becoming/ProcessRepresentation.lean) | 过程于文法中两向（无伦理谓词）：'
         '过程恰为其诸关系，每一着一关系，依定义（`moveRel_mk`）；逐点相同之关系所共之性质，于每一过程之步成立恰当于每一关系成立'
         '（`forall_steps_iff`）；每一关系为某过程之步，每一类为某框架之断言之类（`class_is_claims`）；着在其内之模型，其像恰为'
         '留下一着未定之关系（`withMove_image_iff`），携其步与同着、同构形二类之一一对应，自一点起为重名（`renaming_of_withMove`），'
         '任一类单独不足（`Twist.not_renamed`、`Flip.not_renamed`），重名保诸已桥之概念（`renaming_trace`、`renaming_determined` 等）；迹为沿其字依次历诸着之关系（`trace_iff_li`），运行与分解为'
         '像之所含（`run_iff_image`、`factorsThrough_iff_image`），沿某支而延为一族之常动（`yan_iff_keepsMoving`），自之得线恰为'
         '依赖选择（`yan_line_iff_dependentChoice`）；步忘其着（`Forgotten.moves_forgotten`）；近乎定义、引理与例 |')
row(PKG / 'README.md', '| L1 | [`Becoming.WorldRepresentation`]', PR_EN, '[`Becoming.ProcessRepresentation`]')
row(PKG / 'README.zh.md', '| L1 | [`Becoming.WorldRepresentation`]', PR_ZH, '[`Becoming.ProcessRepresentation`]')
edit(PKG / 'README.md', "ending on every branch pulled back along a homomorphism (`«尽之拉回»`); lemmas of the World's "
                        "representation |",
     "ending on every branch pulled back along a homomorphism (`«尽之拉回»`), going on along some branch along a map "
     "lifting continuation (`«延之拉回»`); preserving an image lying within (`«保之像»`); steps, words, closed regions, "
     "determination and going alike kept (`«迭之对应»`, `«历之对应»`, `«同行之对应»` and the others), correspondences "
     "side by side (`«一一对应».prod`); lemmas of the World's representation and the processes' |")
edit(PKG / 'README.zh.md', '处处终尽沿同态拉回（`«尽之拉回»`）；世界之表示之引理 |',
     '处处终尽沿同态拉回（`«尽之拉回»`），沿某支而延沿提升续之映射拉回（`«延之拉回»`）；保即像之所含（`«保之像»`）；迭、历、闭、'
     '定后定前与同行为对应所保（`«迭之对应»`、`«历之对应»`、`«同行之对应»` 等），一一对应并置（`«一一对应».prod`）；世界与过程之表示之引理 |')
edit(PKG / 'README.md', "steps splitting as they compose and an unending line having steps of every length (`«迭之分»`, "
                        "`«不穷则迭»`);",
     "steps splitting as they compose and an unending line having steps of every length (`«迭之分»`, `«不穷则迭»`); "
     "passing through a word's relations in turn (`«历»`), `«迭»` its case for one relation repeated (`«迭即历»`), six "
     "laws of `«迭»` "
     "the cases of its laws (`«历之接»`, `«历之逆»`, `«同行之历»` and the others);")
edit(PKG / 'README.zh.md', '步可分如其可接，不穷之线有任意长之步（`«迭之分»`、`«不穷则迭»`）；',
     '步可分如其可接，不穷之线有任意长之步（`«迭之分»`、`«不穷则迭»`）；依次历一字之诸关系（`«历»`），`«迭»` 为其一关系重复之例'
     '（`«迭即历»`），`«迭»` 之六律为其律之例（`«历之接»`、`«历之逆»`、`«同行之历»` 等）；')
print('integrated: GrammarLaws and GrammarTransport replaced (additions and six changed proofs), '
      'Becoming.ProcessRepresentation joined (root import and L1 bullet, checker core list and scope, README rows EN '
      'and ZH); GrammarLaws\' and GrammarTransport\'s bullets, scope sentences and rows extended')
