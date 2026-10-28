#!/usr/bin/env python3
"""OU3c: copy the five changed modules from the kit tree into the package, after checking that each package file is
still the one the tree was derived from (main at c2dd2c875); then extend the root module's GrammarLaws and
ComparingCourses bullets, the checker's GrammarLaws scope text and the package README rows (EN, ZH).
usage (from the checkout root of the landing worktree): python3 -B <kit>/integrate_ou3c.py"""
import hashlib
import shutil
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
TREE = HERE.parent / 'tree' / 'Becoming'
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
BASE = {
    'GrammarLaws': '8ea6d1471e1b5bc1334fc16344d02c5430890387aac3a057f8174317739a3964',
    'ComparingCourses': 'e5d2cb98205f84165d0cefda8f65540d21379b3a3d34dcee65f987c3af632ee6',
    'ReachableRanges': 'e3f529f6899b77eb1691c2fd60acc38e228a697e1628345b928a17e9a32a2e83',
    'LearningRuns': 'e903e39c879952c764c92f844355766dcc9641f6decbd3964c24bb75df274c44',
    'Junctures': '2fafdb411e7b0b9236636f0d11b73eb291cd2c7ebdc5179cf8377c4d71dca544',
}


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:70], text.count(old))
    path.write_text(text.replace(old, new), encoding='utf-8')


for module, sha in BASE.items():
    target = PKG / 'Becoming' / f'{module}.lean'
    now = hashlib.sha256(target.read_bytes()).hexdigest()
    assert now == sha, f'{module} changed on main since the kit tree was derived; re-derive it ({now[:12]})'
for module in BASE:
    shutil.copyfile(TREE / f'{module}.lean', PKG / 'Becoming' / f'{module}.lean')

root = PKG / 'Becoming.lean'
edit(root, """  transitive relation containing it is transitive (`strictJoin_trans`), so widening or widening""",
     """  transitive relation containing it is transitive (`strictJoin_trans`, a law of any two relations
  in `Becoming.GrammarLaws`), so widening or widening""")
edit(root, """  excludes keeping and being mixed (`«广不可逆»`, `«广之传递»`). It imports the grammar, its map""",
     """  excludes keeping and being mixed (`«广不可逆»`, `«广之传递»`); a transitive relation joined to the
  strict part of a transitive relation containing it is transitive, and irreflexive where the first
  is (`strictJoin_trans`, `strictJoin_irrefl`). It imports the grammar, its map""")
edit(root, """  proved from it in `Becoming.Frame` and `Becoming.GrammarScope`; finite runs in""",
     """  proved from it in `Becoming.Frame` and `Becoming.GrammarScope`, and so is the step back of a
  returning configuration in `Becoming.Junctures`; finite runs in""")
edit(root, """  `Becoming.Laws`, in `Becoming.Mechanism`, `Becoming.GrammarRegularity` and
  `Becoming.IdentificationRuns`; order in `Becoming.Admission`, `Becoming.Regions` and
  `Becoming.Weightings`.""", """  `Becoming.Laws`, in `Becoming.Mechanism`, `Becoming.GrammarRegularity`,
  `Becoming.IdentificationRuns` and `Becoming.LearningRuns`; order in `Becoming.Admission`,
  `Becoming.Regions` and `Becoming.Weightings`, and the lagged orders of `Becoming.ComparingCourses`
  and `Becoming.ReachableRanges` by `strictJoin_trans` (board item OU3c).""")

checker = PKG / 'check_becoming.py'
edit(checker, """    "under the map goes alike; widening of relations is a strict order excluding keeping and being mixed. Frame's \"""",
     """    "under the map goes alike; widening of relations is a strict order excluding keeping and being mixed, and a "
    "transitive relation joined to the strict part of a transitive relation containing it is transitive, and "
    "irreflexive where the first is. Frame's \"""")

edit(PKG / 'README.md', """widening a strict order of relations (`«广不可逆»`, `«广之传递»`). Frame imports it""",
     """widening a strict order of relations (`«广不可逆»`, `«广之传递»`), and a transitive relation joined to the strict part of a transitive relation containing it transitive (`strictJoin_trans`). Frame imports it""")
edit(PKG / 'README.zh.md', """扩大为关系之严格序（`«广不可逆»`、`«广之传递»`）。Frame 导入之""",
     """扩大为关系之严格序（`«广不可逆»`、`«广之传递»`），传递关系并入含之之传递关系之严格部分仍传递（`strictJoin_trans`）。Frame 导入之""")
edit(PKG / 'README.md', """(`Web.WidensOrWithLag.trans`, from `strictJoin_trans`)""",
     """(`Web.WidensOrWithLag.trans`, from `strictJoin_trans` in `Becoming.GrammarLaws`)""")
edit(PKG / 'README.zh.md', """（`Web.WidensOrWithLag.trans`，出自 `strictJoin_trans`）""",
     """（`Web.WidensOrWithLag.trans`，出自 `Becoming.GrammarLaws` 之 `strictJoin_trans`）""")
print('integrated: five modules copied; root bullets, checker scope and README rows extended')
