#!/usr/bin/env python3
"""PF2: replace Becoming.GrammarPath with the version extended by what leaves a class (tree2), and extend its bullet in
the root module, its scope text in the checker and its rows in the package README (EN, ZH).
usage (from the checkout root of the landing worktree): python3 -B <kit>/round2/integrate_pf2.py"""
import shutil
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent.parent
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:70], text.count(old))
    path.write_text(text.replace(old, new), encoding='utf-8')


assert (PKG / 'Becoming/GrammarPath.lean').exists()
shutil.copyfile(HERE / 'tree2/Becoming/GrammarPath.lean', PKG / 'Becoming/GrammarPath.lean')
edit(PKG / 'Becoming.lean', """  member's end (`FiniteSharedCondition`).
""", """  member's end (`FiniteSharedCondition`). Under a class constant up to the net's end, what leaves the
  class at a member follows every alike step that goes on (`«出类随行»`, `«出类随线»`), and a step with
  nothing outside the class breaks it (`«出类不随则不至终有常»`, `CleanStep`); a finite class constant up
  to the net's end can leave a member's effects out (`FiniteWake`; board item PF2).
""")
edit(PKG / 'check_becoming.py', '''    "witnesses that neither premise can be dropped, a finite net with two families, and one with a shared condition "
    "where every premise holds at once. "''', '''    "witnesses that neither premise can be dropped, a finite net with two families, and one with a shared condition "
    "where every premise holds at once; under constancy up to the net's end what leaves the class at a member "
    "follows every alike step that goes on, and a class can leave a member's effects out. "''')
for name, old, new in (
        ('README.md', 'witnesses (`Unclosed`, `Inconstant`, `FiniteFamilies`, `FiniteSharedCondition`) |',
         'witnesses (`Unclosed`, `Inconstant`, `FiniteFamilies`, `FiniteSharedCondition`); what leaves the class follows '
         'every alike step (`«出类随行»`, `«出类不随则不至终有常»`, `CleanStep`, `FiniteWake`) |'),
        ('README.zh.md', '见证（`Unclosed`、`Inconstant`、`FiniteFamilies`、`FiniteSharedCondition`） |',
         '见证（`Unclosed`、`Inconstant`、`FiniteFamilies`、`FiniteSharedCondition`）；出类者随每一同类之步'
         '（`«出类随行»`、`«出类不随则不至终有常»`、`CleanStep`、`FiniteWake`） |')):
    edit(PKG / name, old, new)
print('integrated: GrammarPath replaced; root bullet, checker scope and README rows extended')
