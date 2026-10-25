#!/usr/bin/env python3
"""OC2: rewrite Becoming.GrammarPath (as OC1 landed it) with build_tree_oc2.py, and correct OC1's bullet in the root
module, its scope text in the checker and its rows in the package README (EN, ZH): "a member that conditions
something" and "where a predicate decides the member's class" restored, "goes on" read "conditions anything", the new
laws named. With `--pf`, also PF's and PF2's "goes on" in the same files, on the PF line owner's yes.
usage (from the checkout root of the landing worktree): python3 -B <kit>/integrate_oc2.py [--pf]"""
import subprocess
import sys
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
GP = PKG / 'Becoming/GrammarPath.lean'
PF = '--pf' in sys.argv[1:]


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:70], text.count(old))
    path.write_text(text.replace(old, new), encoding='utf-8')


subprocess.run([sys.executable, '-B', str(HERE / 'build_tree_oc2.py'), str(GP), str(GP)] + (['--pf'] if PF else []),
               check=True)
edit(PKG / 'Becoming.lean', """  corollaries; where the class holds the member's effects, how what lies outside is divided is idle
  (`«闭则外分无关»`), and otherwise the split of the member's class from the rest asks least, exactly that
  what stays and what leaves follow every alike step that goes on (`«二分本类常当且仅当内外皆随»`;
  `FinerOutside`, `UnevenOutside`; board item OC1).
""", """  corollaries, and asks more than that a line end only where the net does (`CleanStep`); how what lies
  outside is divided enters only through what is alike to an effect that leaves the class
  (`«外分唯系出类之同»`), so it is idle where the class holds the effects of a member that conditions
  something (`«闭则外分无关»`); where a predicate decides the member's class, the split of it from the rest
  asks least, exactly that what stays and what leaves follow every alike occurrence that conditions
  anything (`«二分本类常当且仅当内外皆随»`, `«内外皆缘则二分本类常»`; `FinerOutside`, `FinerWake`,
  `UnevenOutside`; board items OC1, OC2).
""")
edit(PKG / 'check_becoming.py', '''    "constancy up to the net's end carries these laws, how what lies outside is divided is idle where the class holds "
    "the member's effects, and the split of the member's class from the rest asks least. "''', '''    "constancy up to the net's end carries these laws and asks more than that a line end only where the net does; how "
    "what lies outside is divided enters only through effects that leave the class and is idle where the class holds "
    "the effects of a member that conditions something, and where a predicate decides the member's class the split of "
    "it from the rest asks least. "''')
edit(PKG / 'README.md',
     "each of these laws holds at a member's class, where how what lies outside is divided is idle if the class holds "
     "the member's effects and the split asks least otherwise (`«本类至终有常»`, `«闭则外分无关»`, "
     "`«二分本类常当且仅当内外皆随»`, `FinerOutside`, `UnevenOutside`);",
     "each of these laws holds at a member's class, where how what lies outside is divided enters only through effects "
     "that leave the class, idle where the class holds the effects of a member that conditions something, and where a "
     "predicate decides the member's class the split asks least (`«本类至终有常»`, `«外分唯系出类之同»`, "
     "`«闭则外分无关»`, `«二分本类常当且仅当内外皆随»`, `«内外皆缘则二分本类常»`, `FinerOutside`, `FinerWake`, "
     "`UnevenOutside`);")
edit(PKG / 'README.zh.md',
     '诸律皆于员之类成立，类持员之所缘时类外之分无关，否则二分所问最少（`«本类至终有常»`、`«闭则外分无关»`、'
     '`«二分本类常当且仅当内外皆随»`、`FinerOutside`、`UnevenOutside`）；',
     '诸律皆于员之类成立，类外之分唯经出类之效而入，类持一有所缘之员之所缘时无关，一谓词判员之类时二分所问最少'
     '（`«本类至终有常»`、`«外分唯系出类之同»`、`«闭则外分无关»`、`«二分本类常当且仅当内外皆随»`、`«内外皆缘则二分本类常»`、'
     '`FinerOutside`、`FinerWake`、`UnevenOutside`）；')
if PF:
    edit(PKG / 'Becoming.lean', "  class at a member follows every alike step that goes on (`«出类随行»`, `«出类随线»`), and a step with",
         "  class at a member follows every alike occurrence that conditions anything (`«出类随行»`, `«出类随线»`), and a step with")
    edit(PKG / 'check_becoming.py', '''"the effects; a relation under which a line ends where the net goes on is not constant up to the net's end; "''',
         '''"the effects; a relation under which a line ends at an occurrence that still conditions something is not constant up to the net's end; "''')
    edit(PKG / 'check_becoming.py', '''"follows every alike step that goes on, and a class can leave a member's effects out; read at a member's class, "''',
         '''"follows every alike occurrence that conditions anything, and a class can leave a member's effects out; read at a member's class, "''')
    edit(PKG / 'README.md', 'a line ending while the net goes on rules out constancy up to the net\'s end',
         'a line ending at an occurrence that still conditions something rules out constancy up to the net\'s end')
print('integrated: GrammarPath fixed; root bullet, checker scope and README rows corrected' + (' (with PF\'s wording)' if PF else ''))
