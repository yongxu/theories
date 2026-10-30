#!/usr/bin/env python3
"""U3's integration into the package (from the checkout root, in a worktree off main):
- the leaf Becoming.SignificanceStatements and Becoming.Weightings with row 10's interface law, copied from the kit's
  tree; Weightings must be the package's file with exactly one theorem inserted;
- the root module's import and its description of the leaf (L2, beside Becoming.Relevance);
- the checker's core list and its description of the module;
- the package README's L2 row, English and Chinese, after Becoming.Relevance's.
usage: python3 -B integrate_u3.py [--check]   (--check: assert everything applies; writes nothing)"""
import sys
from pathlib import Path

ROOT = Path.cwd()
CHECK = '--check' in sys.argv
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
TREE = ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/u3-significance-on-the-root/tree/Becoming'

LEAF = 'Becoming.SignificanceStatements'
INSERTED = 'theorem grammar_widens_iff_every_positive'

BULLET = (
    "* `Becoming.SignificanceStatements` (L2): the significance rows stated on the root, each proved through its row:\n"
    "  rows 5 and 7 restated on their own carrier, rows 1, 8 and 9 specialized at the own-closure reading of\n"
    "  significance; a restatement, not a derivation, and nothing ethical follows from the root. On a\n"
    "  web's level paths, at that reading, the continuation condition is `«续无外»` at the one of\n"
    "  a relation and holds exactly when living significance does over admission\n"
    "  (`SignificanceStatements.noOutside_iff_paths_livingSignificance`); an extension with every claim counted is the\n"
    "  grammar's `«广»` of what the paths admit (`SignificanceStatements.paths_extension_iff_grammar`); C holds with\n"
    "  \"better\" read as that `«广»`, its being better C's content, supplied\n"
    "  (`SignificanceStatements.paths_comparison_grammar`); under `«续无外»`, `«广»` is retaining and adding what lies\n"
    "  within one's own line (`SignificanceStatements.widens_iff_retains_adds_root`); and these read one predicate,\n"
    "  admission (`SignificanceStatements.paths_one_object_root`). On an acyclic relation the condition forces every\n"
    "  center to coincide. The condition (scope) and C (order) stay premises. Row 10's interface law is in\n"
    "  `Becoming.Weightings` (`Weighting.grammar_widens_iff_every_positive`). A leaf (board item U3).\n")

ROW_EN = (
    "| L2 | [`Becoming.SignificanceStatements`](Becoming/SignificanceStatements.lean) | the significance rows stated on "
    "the root, each proved through its row, rows 5 and 7 on their own carrier and rows 1, 8 and 9 specialized at the "
    "own-closure reading (a restatement, not a derivation; the condition and C stay premises): at that reading the condition is `«续无外»` and holds exactly when living "
    "significance does (`SignificanceStatements.noOutside_iff_paths_livingSignificance`); an extension with every claim "
    "counted is the grammar's `«广»` (`SignificanceStatements.paths_extension_iff_grammar`); C with \"better\" read as "
    "`«广»`, supplied (`SignificanceStatements.paths_comparison_grammar`); the rows read one predicate, admission "
    "(`SignificanceStatements.paths_one_object_root`) |")

ROW_ZH = (
    "| L2 | [`Becoming.SignificanceStatements`](Becoming/SignificanceStatements.lean) | 意义诸行在根上陈述，各经其本行证明，第 5、7 "
    "行在其自身之载体上，第 1、8、9 行于自闭包读法下特化（为重述，非推导；条件与 C 仍为前提）：以意义之自闭包读法，延续条件即「续无外」，恰在生生之意义成立时成立"
    "（`SignificanceStatements.noOutside_iff_paths_livingSignificance`）；计入每个主张之扩展即文法之「广」"
    "（`SignificanceStatements.paths_extension_iff_grammar`）；以“更好”读作「广」时 C 成立，此为所给"
    "（`SignificanceStatements.paths_comparison_grammar`）；诸行读同一谓词，即接纳（`SignificanceStatements.paths_one_object_root`） |")

DESCRIPTION = (
    '    "SignificanceStatements: the significance rows stated on the root, each proved through its row, rows 5 and 7 "\n'
    '    "on their own carrier and rows 1, 8 and 9 specialized at the own-closure reading, a restatement and not a "\n'
    '    "derivation: on the level paths of a web, at that reading, "\n'
    '    "the continuation condition is that nothing lies outside every center\'s line under the one of a relation and "\n'
    '    "holds exactly when living significance does over admission; an extension with every claim counted is the "\n'
    '    "grammar\'s widening of what the paths admit; C holds with better read as that widening, its being better "\n'
    '    "supplied; where nothing lies outside, widening is retaining and adding within one\'s own line; and these read "\n'
    '    "one predicate, admission; on an acyclic relation the condition forces every center to coincide. "\n')


def edit(path, old, new, after=True):
    p = PKG / path
    text = p.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path, old[:60], text.count(old))
    assert new not in text, (path, 'present already')
    text = text.replace(old, old + new if after else new + old, 1)
    if not CHECK:
        p.write_text(text, encoding='utf-8')


# the two sources
leaf = (TREE / 'SignificanceStatements.lean').read_text(encoding='utf-8')
assert not (PKG / 'Becoming/SignificanceStatements.lean').exists()
weight_new = (TREE / 'Weightings.lean').read_text(encoding='utf-8')
weight_old = (PKG / 'Becoming/Weightings.lean').read_text(encoding='utf-8')
start = weight_new.index('/-- **Widening on the root is what every positive weighting ranks higher**')
end = weight_new.index('\n\n', weight_new.index(INSERTED)) + 2
assert weight_new[:start] + weight_new[end:] == weight_old, 'Weightings is not the package file with one theorem'
if not CHECK:
    (PKG / 'Becoming/SignificanceStatements.lean').write_text(leaf, encoding='utf-8')
    (PKG / 'Becoming/Weightings.lean').write_text(weight_new, encoding='utf-8')

# the root module, the checker, the README
edit('Becoming.lean', 'import Becoming.GrammarPath\n', f'import {LEAF}\n')
edit('Becoming.lean', '\n* `Becoming.Lexical` (L1):', '\n' + BULLET, after=False)
edit('check_becoming.py', '"Becoming.GrammarPath", ', f'"{LEAF}", ')
text = (PKG / 'check_becoming.py').read_text(encoding='utf-8')
i = text.index('    "Relevance: on the level paths of a web')
j = text.index('\n    "', text.index('\n', i))
while not text[j + 6:j + 40].split(':')[0].isidentifier() or ':' not in text[j + 6:j + 60]:
    j = text.index('\n    "', j + 1)
assert DESCRIPTION not in text
if not CHECK:
    (PKG / 'check_becoming.py').write_text(text[:j + 1] + DESCRIPTION + text[j + 1:], encoding='utf-8')
for readme, row in (('README.md', ROW_EN), ('README.zh.md', ROW_ZH)):
    t = (PKG / readme).read_text(encoding='utf-8')
    line = next(l for l in t.split('\n') if l.startswith('| L2 | [`Becoming.Relevance`]'))
    edit(readme, line + '\n', row + '\n')
print('checked' if CHECK else 'integrated', LEAF, 'and row 10 in Becoming.Weightings')
