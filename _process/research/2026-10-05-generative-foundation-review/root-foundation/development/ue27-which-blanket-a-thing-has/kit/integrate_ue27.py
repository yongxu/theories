#!/usr/bin/env python3
"""UE27: join Becoming.BlanketCouplings to the core as a leaf importing Becoming.Blanket, Becoming.Histories and
Becoming.IdentificationRuns. Copies the new core module (no landed module changes); adds it to the checker's core list
after Becoming.BlanketWeights, with its scope sentence after the blanket at a steady state's; imports it in the root
module after BlanketWeights, with an L1 bullet after BlanketWeights'; adds the package README rows (EN and ZH, after
BlanketWeights'); adds the record and the core module to regions.json; copies UE27's study folder (the design, its
review, the review of the Lean, the probes, the scratch tree and this kit, without build output) into the landing
worktree. Every backticked BlanketCouplings name the texts cite is checked against the scratch-build axiom audit.
Mirrors UE26's integrate_ue26.py; each edit is asserted to apply exactly once.
usage (from the checkout root of the landing worktree, clean): python3 -B <kit>/integrate_ue27.py"""
import json
import re
import shutil
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
STUDY_SRC = HERE.parent
AUDIT = STUDY_SRC / 'tree/.build/BecomingBlanketCouplingsAxiomAudit.lean'
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation'
WORK = ROOT / RF / 'development/ue27-which-blanket-a-thing-has'
RID = 'a-formations-couplings-as-its-blanket'
NAMES = set(re.findall(r'^#print axioms Becoming\.(\S+)$', AUDIT.read_text(encoding='utf-8'), re.M))
assert len(NAMES) == 76, len(NAMES)


def cited(text):
    """Every backticked BlanketCouplings name in text is a declaration of the module."""
    names = set(re.findall(r'`(BlanketCouplings\.[A-Za-z_.]+)`', text))
    missing = sorted(n for n in names if n not in NAMES)
    assert not missing, missing
    return text


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:70], text.count(old))
    path.write_text(text.replace(old, cited(new)), encoding='utf-8')


# UE27's study folder, as it stands beside this kit (the landing commits it)
if WORK.resolve() != STUDY_SRC.resolve():
    WORK.mkdir(parents=True, exist_ok=True)
    for name in ('DESIGN.md', 'REVIEW-UE27-DESIGN.md', 'REVIEW-UE27-LEAN.md', 'REVIEW-UE27-LANDING.md',
                 'scratch-build.log', 'scratch-build-v2.log', 'scratch-build-v3.log'):
        shutil.copyfile(STUDY_SRC / name, WORK / name)
    for folder in ('review-probes', 'review-lean', 'tree'):
        shutil.copytree(STUDY_SRC / folder, WORK / folder, dirs_exist_ok=True,
                        ignore=shutil.ignore_patterns('.build', '.lake', '__pycache__'))
    shutil.copytree(HERE, WORK / 'kit', dirs_exist_ok=True,
                    ignore=shutil.ignore_patterns('.build', '__pycache__', '*.log'))

# the core module
target = PKG / 'Becoming/BlanketCouplings.lean'
assert not target.exists(), target
shutil.copyfile(STUDY_SRC / 'tree/Becoming/BlanketCouplings.lean', target)

# the checker: core list and scope
checker = PKG / 'check_becoming.py'
edit(checker, '"Becoming.BlanketWeights", "Becoming.LumpedSeeking"',
     '"Becoming.BlanketWeights", "Becoming.BlanketCouplings", "Becoming.LumpedSeeking"')
edit(checker, '''weighting not in cross form, and the cross form on listings not covering the types without it over the types. "
    "What seeking cannot separate:''', '''weighting not in cross form, and the cross form on listings not covering the types without it over the types. "
    "A formation's couplings as its blanket, and when a blanket constrains: where a formation's couplings give the "
    "values of what couples into it, any model fed by them, with any policy and environment, is by construction the "
    "agent of a blanketed law whose sensory course is the formation's own course through its couplings, two of its "
    "courses from one start alike on the blanket before step n + 2 exactly where their level histories are alike "
    "through the couplings up to n, a reading of its internal course in the open loop a selection through them, the "
    "threshold witness's join its case; the law a family shows has a part depending only on a reading exactly where "
    "the family is consistent under the reading and the part, and is determined part by part exactly where the family "
    "is consistent part by part; with parts reading the course every family is the course family of a blanketed law, "
    "the step alone not enough; the constant reading of the configuration gives every family a law determined part "
    "by part, the whole configuration exactly the families whose law is determined, any injective reading only those "
    "and not always; the run whose internal part's next state is whether the external part, cycling through three "
    "values, is at its first is the course of no blanketed law on its four parts. "
    "What seeking cannot separate:''')

# the root module: import and L1 bullet
root = PKG / 'Becoming.lean'
edit(root, 'import Becoming.BlanketWeights\n', 'import Becoming.BlanketWeights\nimport Becoming.BlanketCouplings\n')
BULLET = """* `Becoming.BlanketCouplings` (L1): which blanket a thing has, and a formation's couplings as its
  blanket. Where a formation's couplings give the values of what couples into it, any model fed by them,
  with any policy and any environment, is the agent of a blanketed law whose sensory course is the
  formation's own course through its couplings (`BlanketCouplings.sensory_course`), two of its courses
  from one start alike on the blanket before step n + 2 exactly where their level histories are alike
  through the couplings up to n (`BlanketCouplings.blanket_iff_through`), and in the open loop every
  reading of its internal course a selection through them (`BlanketCouplings.internal_selectsThrough`);
  a construction, not a test, the threshold witness's join its case
  (`BlanketCouplings.ThresholdCase.threshold_case`). The law a family shows is determined part by part
  exactly where the family is consistent part by part (`BlanketCouplings.shownBy_blanketDetermined_iff`).
  When a blanket's existence constrains, at three levels: with parts reading the course every family of
  courses is the course family of a blanketed law (`BlanketCouplings.clocked_course`,
  `BlanketCouplings.future_course`), the step alone not enough (`BlanketCouplings.clock_only_fails`); a
  degenerate reading of the configuration gives every family, or exactly the families whose law is
  determined, a law determined part by part (`BlanketCouplings.const_consistent`,
  `BlanketCouplings.whole_iff`), any injective reading only those and not always
  (`BlanketCouplings.injective_converse_fails`); a sparse partition fixed apart from the family, on a law
  the same at every step, can be refuted by one run (`BlanketCouplings.ReadsExternal.not_blanketed`). A
  leaf importing `Becoming.Blanket`, `Becoming.Histories` and `Becoming.IdentificationRuns` (board item
  UE27).
"""
lines = root.read_text(encoding='utf-8').split('\n')
at = [i for i, line in enumerate(lines)
      if line.startswith('* `Becoming.LumpedSeeking` (L') and 'board item UE26' in lines[i - 1]]
assert len(at) == 1, at
lines[at[0]:at[0]] = cited(BULLET).rstrip('\n').split('\n')
root.write_text('\n'.join(lines), encoding='utf-8')


def readme_row(path, after, row):
    rows = path.read_text(encoding='utf-8').split('\n')
    at = [i for i, line in enumerate(rows) if line.startswith(f'| L1 | [`{after}`]')]
    assert len(at) == 1, at
    assert not any('[`Becoming.BlanketCouplings`]' in line for line in rows)
    rows[at[0] + 1:at[0] + 1] = [cited(row)]
    path.write_text('\n'.join(rows), encoding='utf-8')


readme_row(PKG / 'README.md', 'Becoming.BlanketWeights',
           '| L1 | [`Becoming.BlanketCouplings`](Becoming/BlanketCouplings.lean) | which blanket a thing has (no ethical '
           'predicate): where a formation\'s couplings give the values of what couples into it, any model fed by them is, '
           'by construction, the agent of a blanketed law whose sensory course is the formation\'s own course through its '
           'couplings, alike on the blanket exactly where alike through them (`BlanketCouplings.blanket_iff_through`); '
           'with parts reading the course every family of courses is the course family of a blanketed law '
           '(`BlanketCouplings.clocked_course`), a degenerate reading of the configuration gives every family, or every '
           'family whose law is determined, a law determined part by part (`BlanketCouplings.whole_iff`), and a sparse '
           'partition fixed apart from the family can be refuted by one run '
           '(`BlanketCouplings.ReadsExternal.not_blanketed`) |')
readme_row(PKG / 'README.zh.md', 'Becoming.BlanketWeights',
           '| L1 | [`Becoming.BlanketCouplings`](Becoming/BlanketCouplings.lean) | 物有何毯（无伦理谓词）：一形成之耦合予耦合入者之值，则以之为食之任一模型，依构造为一毯化之律之主体，'
           '其感官历程即该形成经其耦合之自身历程，于毯上相同恰当经其耦合相同（`BlanketCouplings.blanket_iff_through`）；诸部分读历程，则每一历程之族皆为一毯化之律之历程族'
           '（`BlanketCouplings.clocked_course`），构型之退化之读予每一族或其律确定之每一族以逐部分确定之律（`BlanketCouplings.whole_iff`），独立于族而定之稀疏之分可为一运行所驳'
           '（`BlanketCouplings.ReadsExternal.not_blanketed`） |')

# regions: the record and the core module
regions = ROOT / 'theories/becoming/results/data/regions.json'
data = json.loads(regions.read_text(encoding='utf-8'))
assert RID not in data['records']
assert 'Becoming.BlanketCouplings' not in data['modules']
data['records'][RID] = {'region': 'knowing', 'base': 'general', 'note': (
    'BlanketCouplings UE27: where a formation\'s couplings give the values of what couples in, any model fed by them '
    'is by construction the agent of a blanketed law whose sensory course is the formation\'s own course; for a '
    'family whose law is determined, a blanket\'s existence constrains under a sparse partition fixed apart from the '
    'family, refuted by one run in a witness')}
data['modules']['Becoming.BlanketCouplings'] = {'region': 'knowing', 'base': 'general',
                                                'note': 'UE27 which blanket a thing has (03 §1)'}
data['records'] = dict(sorted(data['records'].items()))
data['modules'] = dict(sorted(data['modules'].items()))
text = regions.read_text(encoding='utf-8')
regions.write_text(json.dumps(data, ensure_ascii=False, indent=1) + ('\n' if text.endswith('\n') else ''),
                   encoding='utf-8')
print('integrated: Becoming.BlanketCouplings joined (root import and L1 bullet, checker core list and scope, README '
      'rows EN and ZH); regions; UE27\'s folder copied; no landed module changed')
