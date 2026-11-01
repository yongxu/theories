#!/usr/bin/env python3
"""UE28: extend the core leaf Becoming.BlanketCouplings (UE27's module) with a formation's level as the internal part,
along one run. A changed module, not a new one: the checker's core list, the root module's import and the package
README rows exist already. Replaces the package's Becoming/BlanketCouplings.lean with UE28's scratch module, after
asserting that the package file is byte for byte UE27's landed version (29fbe6dee), so a later change to it stops the
landing; appends one sentence to the checker's scope sentence for BlanketCouplings; extends the root module's L1 bullet
by one sentence, "(board item UE27)" becoming "(board items UE27 and UE28)"; adds one clause to each package README
row (EN and ZH); brings regions.json's notes on the module and the record to UE28; copies UE28's study folder (the
design, the reviews present, the scratch-build logs, the probes, the scratch tree and this kit, without build output)
into the landing worktree. Every backticked BlanketCouplings name the texts cite is checked against the scratch-build
axiom audit. Mirrors UE27's integrate_ue27.py; each edit is asserted to apply exactly once.
usage (from the checkout root of the landing worktree, clean): python3 -B <kit>/integrate_ue28.py"""
import json
import re
import shutil
import subprocess
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
STUDY_SRC = HERE.parent
AUDIT = STUDY_SRC / 'tree/.build/BecomingBlanketCouplingsAxiomAudit.lean'
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation'
WORK = ROOT / RF / 'development/ue28-a-formations-level-as-the-internal-part'
RID = 'a-formations-couplings-as-its-blanket'
UE27_LANDED = '29fbe6dee'
NAMES = set(re.findall(r'^#print axioms Becoming\.(\S+)$', AUDIT.read_text(encoding='utf-8'), re.M))
assert len(NAMES) == 140, len(NAMES)


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


# UE28's study folder, as it stands beside this kit (the landing commits it)
if WORK.resolve() != STUDY_SRC.resolve():
    WORK.mkdir(parents=True, exist_ok=True)
    files = ['DESIGN.md'] + sorted(p.name for p in STUDY_SRC.glob('REVIEW-UE28-*.md')) + \
        sorted(p.name for p in STUDY_SRC.glob('scratch-build*.log'))
    assert {'REVIEW-UE28-DESIGN.md', 'REVIEW-UE28-LEAN.md', 'scratch-build-v2.log'} <= set(files), files
    for name in files:
        shutil.copyfile(STUDY_SRC / name, WORK / name)
    for folder in ('review-probes', 'review-lean', 'tree'):
        shutil.copytree(STUDY_SRC / folder, WORK / folder, dirs_exist_ok=True,
                        ignore=shutil.ignore_patterns('.build', '.lake', '__pycache__'))
    shutil.copytree(HERE, WORK / 'kit', dirs_exist_ok=True,
                    ignore=shutil.ignore_patterns('.build', '.lake', '__pycache__', '*.log'))
    # the review's copy of the scratch module is not committed (REVIEW-UE28-LEAN, the probe)
    assert not (WORK / 'review-lean/tree/Becoming/BlanketCouplings.lean').exists()
    assert not (WORK / 'review-probes/tree/Becoming/BlanketCouplings.lean').exists()

# the core module: UE27's landed version replaced by UE28's
target = PKG / 'Becoming/BlanketCouplings.lean'
rel = target.relative_to(ROOT).as_posix()
landed = subprocess.run(['git', 'show', f'{UE27_LANDED}:{rel}'], cwd=ROOT, capture_output=True, check=True).stdout
assert target.read_bytes() == landed, ('the package BlanketCouplings.lean is not UE27\'s landed version: read the '
                                       'change, then bring UE28\'s scratch module onto it')
scratch = (STUDY_SRC / 'tree/Becoming/BlanketCouplings.lean').read_bytes()
assert scratch != landed
shutil.copyfile(STUDY_SRC / 'tree/Becoming/BlanketCouplings.lean', target)

# the checker: the scope sentence (the core list already holds the module)
checker = PKG / 'check_becoming.py'
assert checker.read_text(encoding='utf-8').count('"Becoming.BlanketCouplings"') == 1
edit(checker, '''    "values, is at its first is the course of no blanketed law on its four parts. "
    "What seeking cannot separate:''', '''    "values, is at its first is the course of no blanketed law on its four parts. "
    "A formation's level as the internal part, along one run with the step as the external part: a course is "
    "admitted by some law determined part by part exactly where its agent is consistent, at any two steps alike on "
    "the internal, sensory and active states the next internal and active states agreeing; on a balanced run read "
    "with a formation's own level internal, a value across steps of what couples into it sensory and its act "
    "active, the condition is that, at any two steps alike on its level, its admission, the levels coupled into it "
    "and its act, what is given to it at one step plus what is taken from it at the other is the same with the "
    "steps exchanged and its next acts agree, tested only where these recur; a drain in three phases fails it, a "
    "drain and feed in two phases meets it. "
    "What seeking cannot separate:''')

# the root module: the L1 bullet (the import is already there)
root = PKG / 'Becoming.lean'
assert root.read_text(encoding='utf-8').count('import Becoming.BlanketCouplings\n') == 1
edit(root, """  the same at every step, can be refuted by one run (`BlanketCouplings.ReadsExternal.not_blanketed`). A
  leaf importing `Becoming.Blanket`, `Becoming.Histories` and `Becoming.IdentificationRuns` (board item
  UE27).
""", """  the same at every step, can be refuted by one run (`BlanketCouplings.ReadsExternal.not_blanketed`).
  Along one balanced run with the step as the external part, a formation's own level, read with a
  value across steps of what couples into it (`BlanketCouplings.ValuesAcross`) and its act, is the
  internal part of a law determined part by part exactly where, at any two steps alike on its level,
  its admission, the levels coupled into it and its act, what is given to it at one step plus what is
  taken from it at the other is the same with the steps exchanged and its next acts agree
  (`BlanketCouplings.levelParts_admitted_iff`), tested only where these recur; a drain in three phases fails it (`BlanketCouplings.PhasedDrain.not_admitted`), a drain and
  feed in two phases meets it (`BlanketCouplings.Alternating.admitted`). A leaf importing
  `Becoming.Blanket`, `Becoming.Histories` and `Becoming.IdentificationRuns` (board items UE27 and
  UE28).
""")


def readme_row(path, old_end, new_end):
    rows = path.read_text(encoding='utf-8').split('\n')
    at = [i for i, line in enumerate(rows) if line.startswith('| L1 | [`Becoming.BlanketCouplings`]')]
    assert len(at) == 1, at
    assert rows[at[0]].endswith(old_end) and rows[at[0]].count(old_end) == 1, rows[at[0]][-120:]
    rows[at[0]] = rows[at[0]][:-len(old_end)] + cited(new_end)
    path.write_text('\n'.join(rows), encoding='utf-8')


readme_row(PKG / 'README.md', '(`BlanketCouplings.ReadsExternal.not_blanketed`) |',
           '(`BlanketCouplings.ReadsExternal.not_blanketed`); along one balanced run with the step as the external '
           'part, a formation\'s own level is the internal part of a law determined part by part exactly where its '
           'next level and act agree wherever its level, a value across steps of what couples into it and its act '
           'agree, tested only where these recur (`BlanketCouplings.levelParts_admitted_iff`), which a drain in three '
           'phases fails |')
readme_row(PKG / 'README.zh.md', '（`BlanketCouplings.ReadsExternal.not_blanketed`） |',
           '（`BlanketCouplings.ReadsExternal.not_blanketed`）；沿一平衡之运行、步为外部部分，一形成之自身层级为某逐部分确定之律之内部部分，'
           '恰当其层级、耦合入者跨步之值与其作为相合之处，其次层级与次作为皆相合，唯于诸态复现处受检（`BlanketCouplings.levelParts_admitted_iff`），'
           '三相之耗不满足之 |')

# regions: the record's and the module's notes
regions = ROOT / 'theories/becoming/results/data/regions.json'
data = json.loads(regions.read_text(encoding='utf-8'))
OLD_RECORD_NOTE = (
    'BlanketCouplings UE27: where a formation\'s couplings give the values of what couples in, any model fed by them '
    'is by construction the agent of a blanketed law whose sensory course is the formation\'s own course; for a '
    'family whose law is determined, a blanket\'s existence constrains under a sparse partition fixed apart from the '
    'family, refuted by one run in a witness')
OLD_MODULE_NOTE = 'UE27 which blanket a thing has (03 §1)'
assert data['records'][RID] == {'region': 'knowing', 'base': 'general', 'note': OLD_RECORD_NOTE}, data['records'][RID]
assert data['modules']['Becoming.BlanketCouplings'] == {'region': 'knowing', 'base': 'general',
                                                        'note': OLD_MODULE_NOTE}
data['records'][RID]['note'] = OLD_RECORD_NOTE + (
    '; UE28: along one balanced run with the step external, a formation\'s own level is the internal part of a law '
    'determined part by part exactly where its next level and act agree wherever its level, a value across steps of '
    'what couples in and its act agree, tested only where these recur, which a drain in three phases fails')
data['modules']['Becoming.BlanketCouplings']['note'] = ('UE27 which blanket a thing has; UE28 a formation\'s level as '
                                                        'the internal part, along one run (03 §1)')
text = regions.read_text(encoding='utf-8')
regions.write_text(json.dumps(data, ensure_ascii=False, indent=1) + ('\n' if text.endswith('\n') else ''),
                   encoding='utf-8')
print('integrated: Becoming.BlanketCouplings replaced by UE28\'s (UE27\'s landed bytes checked); checker scope, root '
      'L1 bullet, README rows EN and ZH extended; regions notes; UE28\'s folder copied; no other module changed')
