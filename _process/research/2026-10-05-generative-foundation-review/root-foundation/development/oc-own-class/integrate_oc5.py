#!/usr/bin/env python3
"""OC5: Becoming.GrammarPath with the crux's structure as laws (build_tree_oc5.py, then the deferred comment fixes,
deferred_grammarpath.py, unless the tree already has them), and the root module's bullet, the checker's scope and the
package README rows (EN, ZH) naming the new laws.
usage (from the checkout root of the landing worktree): python3 -B <kit>/integrate_oc5.py"""
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


if '«后皆续当且仅当后皆同类»' not in GP.read_text(encoding='utf-8'):
    subprocess.run([sys.executable, '-B', str(HERE / 'build_tree_oc5.py'), str(GP), str(GP)], check=True)
    subprocess.run([sys.executable, '-B', str(HERE / 'deferred_grammarpath.py')], check=True)
edit(PKG / 'Becoming.lean', """  anything (`«二分本类常当且仅当内外皆随»`, `«内外皆缘则二分本类常»`; `FinerOutside`, `FinerWake`,
  `UnevenOutside`; board items OC1, OC2).
""", """  anything (`«二分本类常当且仅当内外皆随»`, `«内外皆缘则二分本类常»`; `FinerOutside`, `FinerWake`,
  `UnevenOutside`; board items OC1, OC2). With no regularity assumed, everything downstream of a member
  lies on its line under a class exactly where everything downstream of it is alike to it, that is,
  where the class holds the effects of the member and of each stage of its line; so this reach asks
  that the class hold the member's effects, excludes a line that ends while its last stage still
  conditions something, and does not need the condition at the member's class
  (`«后皆续当且仅当后皆同类»`, `«后皆续当且仅当自与线皆闭»`, `«后皆续则所缘同于»`, `«亡而网续则后不皆续»`,
  `OtherLeaves`). Where the member conditions something, that condition is that it and each alike
  occurrence follow each other, so how what lies outside is divided bears on it only through what is
  alike to the member's own effects that leave the class (`«本类常当且仅当与己相随»`,
  `«外分唯系己出之同»`; board item OC5).
""")
edit(PKG / 'check_becoming.py', '''    "it from the rest asks least. "''', '''    "it from the rest asks least; with no regularity assumed, everything downstream of a member is on its line "
    "exactly where the class holds the effects of the member and of each stage of its line, which needs the member's "
    "effects held, excludes a line that ends while its last stage still conditions something, and does not need the "
    "condition at the member's class; where the member conditions something, that condition is that it and each "
    "alike occurrence follow each other, so how what lies outside is divided bears on it only through what is alike "
    "to the member's own effects that leave the class. "''')
edit(PKG / 'README.md',
     "`«闭则外分无关»`, `«二分本类常当且仅当内外皆随»`, `«内外皆缘则二分本类常»`, `FinerOutside`, `FinerWake`, "
     "`UnevenOutside`);",
     "`«闭则外分无关»`, `«二分本类常当且仅当内外皆随»`, `«内外皆缘则二分本类常»`, `FinerOutside`, `FinerWake`, "
     "`UnevenOutside`); with no regularity assumed, everything downstream of a member is on its line exactly where the "
     "class holds the effects of the member and of each stage of its line, which needs the member's effects held, "
     "excludes a line that ends while its last stage still conditions something, and does not need the condition at "
     "the member's class (`«后皆续当且仅当后皆同类»`, `«后皆续当且仅当自与线皆闭»`, `«后皆续则所缘同于»`, "
     "`«亡而网续则后不皆续»`, `OtherLeaves`); where the member conditions something, that condition is that it and "
     "each alike occurrence follow each other, so how what lies outside is divided bears on it only through what is "
     "alike to the member's own effects that leave the class (`«本类常当且仅当与己相随»`, `«外分唯系己出之同»`);")
edit(PKG / 'README.zh.md',
     '`«闭则外分无关»`、`«二分本类常当且仅当内外皆随»`、`«内外皆缘则二分本类常»`、`FinerOutside`、`FinerWake`、'
     '`UnevenOutside`）；',
     '`«闭则外分无关»`、`«二分本类常当且仅当内外皆随»`、`«内外皆缘则二分本类常»`、`FinerOutside`、`FinerWake`、'
     '`UnevenOutside`）；不设有常，一员之后皆在其线上，当且仅当类持员及其线上每一阶之所缘，故此须持员之所缘，不容线亡而其末阶'
     '犹有所缘，而不须员之类之至终有常（`«后皆续当且仅当后皆同类»`、`«后皆续当且仅当自与线皆闭»`、`«后皆续则所缘同于»`、'
     '`«亡而网续则后不皆续»`、`OtherLeaves`）；员有所缘时，此条件即员与每一同类者相随，故类外之分唯经与员己出类之效同类者而入'
     '（`«本类常当且仅当与己相随»`、`«外分唯系己出之同»`）；')
print('integrated: GrammarPath with OC5; root bullet, checker scope and README rows name the new laws')
