#!/usr/bin/env python3
"""GS4: replace Becoming.GrammarCases in the package with the version extended by the shared-condition witnesses, and
extend its bullet in the root module, its scope text in the checker and its rows in the package README (EN, ZH).
usage (from the checkout root of the landing worktree): python3 -B <kit>/integrate_gs4.py"""
import shutil
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:70], text.count(old))
    path.write_text(text.replace(old, new), encoding='utf-8')


assert (PKG / 'Becoming/GrammarCases.lean').exists()
shutil.copyfile(HERE / 'tree/Becoming/GrammarCases.lean', PKG / 'Becoming/GrammarCases.lean')
edit(PKG / 'Becoming.lean', """  (`TwoLines`). A belief whose rate of spread grows with its number, the rate read in its
""", """  (`TwoLines`). Two lines that share a condition: where the members affect it, one line's future
  reaches the other's through it under the one, not under "a member or not"; where they only feed
  from it, under no relation (`SharedCondition`, board item GS4). A belief whose rate of spread
  grows with its number, the rate read in its
""")
edit(PKG / 'check_becoming.py', """    "a class between a member's and the one whose core goes on through births; a belief whose \"""",
     """    "a class between a member's and the one whose core goes on through births; two lines sharing a "
    "condition, one reaching the other through it under the one where the members affect it and under no relation "
    "where they only feed from it; a belief whose \"""")
for name, old, new in (
        ('README.md', 'two family lines, a core going on through births (`TwoLines`); a belief ',
         'two family lines, a core going on through births (`TwoLines`); one line reaching another through a condition '
         'its members affect (`SharedCondition`); a belief '),
        ('README.zh.md', '二家族之线，其核于出生处续（`TwoLines`）；', '二家族之线，其核于出生处续（`TwoLines`）；经其成员所影响之条件，一线及于他线（`SharedCondition`）；')):
    edit(PKG / name, old, new)
print('integrated: GrammarCases replaced; root bullet, checker scope and README rows extended')
