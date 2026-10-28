#!/usr/bin/env python3
"""OU3d: copy GrammarLaws from the kit tree into the package, after checking that the package file is still the one
the tree was derived from (main at c509211df); then extend the root module's GrammarLaws entry, the checker's
GrammarLaws scope text and the package README rows (EN, ZH) with the laws of steps counted.
usage (from the checkout root of the landing worktree): python3 -B <kit>/integrate_ou3d.py"""
import hashlib
import shutil
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
TREE = HERE.parent / 'tree' / 'Becoming'
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
BASE = {'GrammarLaws': 'af3ac5562c213f36fe6e2c286583c611e10c4734f3ca1290bc02583829a9f6ed'}


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
edit(root, """  drawn either way (`«止而不入之例»`, `«入而屡之例»`). Lumping: with the successor fixed where `E`""",
     """  drawn either way (`«止而不入之例»`, `«入而屡之例»`). Steps counted: within `m` steps and then within
  `n` is within `m + n` (`«迭内之接»`), and a course of regions each of whose rounds holds what every
  condition held (`«承»`) holds at round `n` exactly where everything reaching in `n` steps held at
  the start (`«承之迭»`), with memory within `n` steps (`«存承之迭»`).
  `Becoming.Withholding`'s closed forms have these shapes for its chains; their bridges are a
  second step (board item OU3d).
  Lumping: with the successor fixed where `E`""")

checker = PKG / 'check_becoming.py'
edit(checker, """    "not rise do not recur, rest being no case of being drawn either way; going alike is constancy where the \"""",
     """    "not rise do not recur, rest being no case of being drawn either way; within m steps and then within n is "
    "within m + n, and a course of regions each of whose rounds holds what every condition held holds at round n "
    "exactly where everything reaching in n steps held at the start, with memory within n steps; going alike is "
    "constancy where the \"""")

edit(PKG / 'README.md', """rest no case of being drawn (`«止而不入之例»`, `«入而屡之例»`); going alike and constancy""",
     """rest no case of being drawn (`«止而不入之例»`, `«入而屡之例»`); within `n` steps composing (`«迭内之接»`), and a course each of whose rounds holds what every condition held holding at round `n` where everything reaching in `n` steps held at the start, with memory within `n` (`«承之迭»`, `«存承之迭»`); going alike and constancy""")
edit(PKG / 'README.zh.md', """止非入之一例（`«止而不入之例»`、`«入而屡之例»`）；同行与有常""",
     """止非入之一例（`«止而不入之例»`、`«入而屡之例»`）；`n` 步以内可接（`«迭内之接»`），每轮持其诸缘皆持者之区域之程，第 `n` 轮恰持于凡 `n` 步及之者始皆持之处，有记忆则 `n` 步以内（`«承之迭»`、`«存承之迭»`）；同行与有常""")
print('integrated: GrammarLaws copied; root entry, checker scope and README rows (EN, ZH) extended')
