#!/usr/bin/env python3
"""OC1: rewrite Becoming.GrammarPath (as PF2 landed it) with build_tree.py, and extend its bullet in the root module, its
scope text in the checker and its rows in the package README (EN, ZH).
usage (from the checkout root of the landing worktree): python3 -B <kit>/integrate_oc1.py"""
import subprocess
import sys
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
GP = PKG / 'Becoming/GrammarPath.lean'


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:70], text.count(old))
    path.write_text(text.replace(old, new), encoding='utf-8')


assert 'theorem «出类随行»' in GP.read_text(encoding='utf-8'), 'PF2 has not landed'
subprocess.run([sys.executable, '-B', str(HERE / 'build_tree.py'), str(GP), str(GP)], check=True)
edit(PKG / 'Becoming.lean', """  to the net's end can leave a member's effects out (`FiniteWake`; board item PF2).
""", """  to the net's end can leave a member's effects out (`FiniteWake`; board item PF2). Read at a member's
  class (`«本类至终有常»`), constancy up to the net's end carries these laws, the global forms being
  corollaries; where the class holds the member's effects, how what lies outside is divided is idle
  (`«闭则外分无关»`), and otherwise the split of the member's class from the rest asks least, exactly that
  what stays and what leaves follow every alike step that goes on (`«二分本类常当且仅当内外皆随»`;
  `FinerOutside`, `UnevenOutside`; board item OC1).
""")
edit(PKG / 'check_becoming.py', '''    "follows every alike step that goes on, and a class can leave a member's effects out. "''', '''    "follows every alike step that goes on, and a class can leave a member's effects out; read at a member's class, "
    "constancy up to the net's end carries these laws, how what lies outside is divided is idle where the class holds "
    "the member's effects, and the split of the member's class from the rest asks least. "''')
for name, old, new in (
        ('README.md', 'what leaves the class follows every alike step (`«出类随行»`, `«出类不随则不至终有常»`, `CleanStep`, '
                      '`FiniteWake`);',
         'what leaves the class follows every alike step (`«出类随行»`, `«出类不随则不至终有常»`, `CleanStep`, `FiniteWake`); '
         'each of these laws holds at a member\'s class, where how what lies outside is divided is idle if the class holds '
         'the member\'s effects and the split asks least otherwise (`«本类至终有常»`, `«闭则外分无关»`, '
         '`«二分本类常当且仅当内外皆随»`, `FinerOutside`, `UnevenOutside`);'),
        ('README.zh.md', '出类者随每一同类之步（`«出类随行»`、`«出类不随则不至终有常»`、`CleanStep`、`FiniteWake`）；',
         '出类者随每一同类之步（`«出类随行»`、`«出类不随则不至终有常»`、`CleanStep`、`FiniteWake`）；诸律皆于员之类成立，'
         '类持员之所缘时类外之分无关，否则二分所问最少（`«本类至终有常»`、`«闭则外分无关»`、`«二分本类常当且仅当内外皆随»`、'
         '`FinerOutside`、`UnevenOutside`）；')):
    edit(PKG / name, old, new)
print('integrated: GrammarPath rewritten at a member\'s class; root bullet, checker scope and README rows extended')
