#!/usr/bin/env python3
"""OU3f, laws of steps: copy GrammarLaws and MapInstances from the kit tree into the package, after checking that each
package file is still the one the tree was derived from (main at 7c3829c82); then extend the root module's GrammarLaws
entry, the checker's GrammarLaws scope text and the package README rows (EN, ZH).
usage (from the checkout root of the landing worktree): python3 -B <kit>/integrate_laws.py"""
import hashlib
import shutil
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
TREE = HERE.parent / 'tree' / 'Becoming'
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
BASE = {'GrammarLaws': 'c33037600c9b935b6e59f21640822e75632991d2fbfbf1856499aabe71bc1ae0',
        'MapInstances': '5f66a2f3fa4afb314d3f5a6bb5ec13194e81c0c1a234aa10b723aaa74141a932'}


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:70], text.count(old))
    path.write_text(text.replace(old, new), encoding='utf-8')


for module, sha in BASE.items():
    now = hashlib.sha256((PKG / 'Becoming' / f'{module}.lean').read_bytes()).hexdigest()
    assert now == sha, f'{module} changed on main since the kit tree was derived; re-derive it ({now[:12]})'
for module in BASE:
    shutil.copyfile(TREE / f'{module}.lean', PKG / 'Becoming' / f'{module}.lean')

edit(PKG / 'Becoming.lean', """  the start (`«承之迭»`), with memory within `n` steps (`«存承之迭»`).
  `Becoming.Withholding`'s closed forms are proved from them, its chains of waits read as the
  grammar's steps, and so is `WithinMoves.after_course` in `Becoming.Labelled`, a trace read as
  them (board items OU3d, OU3e).""", """  the start (`«承之迭»`), with memory within `n` steps (`«存承之迭»`). Steps split as they compose
  (`«迭之分»`), and steps read backward are steps of the converse (`«迭之逆»`). Where whatever is
  reached in fewer than `n` steps has a successor as far as can be refuted, `n` steps exist as far
  as can be refuted (`«或有后则或迭»`); an unending line has steps of every length (`«不穷则迭»`).
  `Becoming.Withholding`'s closed forms are proved from them, its chains of waits read as the
  grammar's steps; so is `WithinMoves.after_course` in `Becoming.Labelled`, a trace read as them,
  and `Web.reaches_onward` in `Becoming.MapInstances`, an unending line's index advancing with its
  steps (board items OU3d, OU3e, OU3f).""")
edit(PKG / 'check_becoming.py', """    "exactly where everything reaching in n steps held at the start, with memory within n steps; going alike is \"""",
     """    "exactly where everything reaching in n steps held at the start, with memory within n steps; steps split as "
    "they compose, steps read backward are steps of the converse, and an unending line has steps of every length; "
    "going alike is \"""")
edit(PKG / 'README.md', """with memory within `n` (`«承之迭»`, `«存承之迭»`); going alike and constancy""",
     """with memory within `n` (`«承之迭»`, `«存承之迭»`); steps splitting as they compose and an unending line having steps of every length (`«迭之分»`, `«不穷则迭»`); going alike and constancy""")
edit(PKG / 'README.zh.md', """有记忆则 `n` 步以内（`«承之迭»`、`«存承之迭»`）；同行与有常""",
     """有记忆则 `n` 步以内（`«承之迭»`、`«存承之迭»`）；步可分如其可接，不穷之线有任意长之步（`«迭之分»`、`«不穷则迭»`）；同行与有常""")
print('integrated: GrammarLaws and MapInstances copied; root entry, checker scope and README rows extended')
