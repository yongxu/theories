#!/usr/bin/env python3
"""GS5: replace Becoming.GrammarScope and Becoming.GrammarCases in the package with the versions extended by the class
of being joined and its witnesses, and extend their bullets in the root module, their scope text in the checker and their
rows in the package README (EN, ZH).
usage (from the checkout root of the landing worktree): python3 -B <kit>/integrate_gs5.py"""
import shutil
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:70], text.count(old))
    path.write_text(text.replace(old, new), encoding='utf-8')


for name in ('GrammarScope', 'GrammarCases'):
    assert (PKG / f'Becoming/{name}.lean').exists()
    shutil.copyfile(HERE / f'tree/Becoming/{name}.lean', PKG / f'Becoming/{name}.lean')
root = PKG / 'Becoming.lean'
edit(root, """  without end (`«核有续当且仅当有不穷»`); two lines of descent, one endless and one that ends
  (`LineOfDescent`).
""", """  without end (`«核有续当且仅当有不穷»`); two lines of descent, one endless and one that ends
  (`LineOfDescent`). The class of being joined by 缘 read either way has 缘 as its continuation, is
  the finest class that does, and is constant where every occurrence conditions something
  (`«续即缘当且仅当含族»`, `«遍有后则族有常»`; board item GS5).
""")
edit(root, """  from it, under no relation (`SharedCondition`, board item GS4). A belief whose rate of spread
""", """  from it, under no relation (`SharedCondition`, board item GS4). A third thing joined to nothing lies
  outside the class of being joined; one affecting the condition is left out by a finer constant class
  that still reaches; one the condition feeds is taken in by every constant class holding a member
  with the condition (`ThirdThing`, `ThirdAffects`, `ThirdFed`, board item GS5). A belief whose rate of spread
""")
checker = PKG / 'check_becoming.py'
edit(checker, """    "exactly where some line under it goes on without end; two lines of descent, endless and ending. \"""",
     """    "exactly where some line under it goes on without end; two lines of descent, endless and ending; the class "
    "of being joined has 缘 as its continuation, is the finest such class and is constant where every occurrence "
    "conditions something. \"""")
edit(checker, """    "where they only feed from it; a belief whose \"""", """    "where they only feed from it; a third thing joined three ways to two families and their condition; a belief whose \"""")
for name, old, new in (
        ('README.md', 'two lines of descent (`LineOfDescent`) |',
         'two lines of descent (`LineOfDescent`); the class of being joined, the finest with 缘 as its continuation '
         '(`«续即缘当且仅当含族»`) |'),
        ('README.zh.md', '二传承之线（`LineOfDescent`） |', '二传承之线（`LineOfDescent`）；相连之类，以缘为续之最细之类（`«续即缘当且仅当含族»`） |'),
        ('README.md', 'its members affect (`SharedCondition`); a belief ',
         'its members affect (`SharedCondition`); a third thing joined three ways (`ThirdThing`, `ThirdAffects`, `ThirdFed`); a belief '),
        ('README.zh.md', '一线及于他线（`SharedCondition`）；', '一线及于他线（`SharedCondition`）；以三种方式相连之第三物（`ThirdThing`、`ThirdAffects`、`ThirdFed`）；')):
    edit(PKG / name, old, new)
print('integrated: GrammarScope and GrammarCases replaced; root bullets, checker scope and README rows extended')
