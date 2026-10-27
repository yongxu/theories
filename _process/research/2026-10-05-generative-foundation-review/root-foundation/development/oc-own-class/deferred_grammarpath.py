#!/usr/bin/env python3
"""For the next landing that rebuilds `Becoming.GrammarPath`: the wording fixes left for it. Run it in that landing's
tree before its checker run; each edit is asserted to apply once, so a part already applied or reworded stops the
script and is read by hand.

The four fixes this script held before were applied by OC5's landing (`e5ccbbbb6`, study section 428): OC3's (g),
"continues past"; OC4 A9, `FiniteFamilies.one_not_constant`; OC4 A12, `FinerWake.finer_class`; and the root bullet's
"an alike occurrence that conditions something but nothing alike to that effect breaks it". It now holds findings 8
and 18 of OC5's review (`REVIEW-OC5.md`), on the PF line's wording. The PF line's owner said yes to both, word for
word, on 27 October 2026, and asked that they wait for the next rebuild rather than take a checker run of their own:

- (m) finding 8: "Neither premise can be dropped" becomes "Neither premise can be dropped from these laws" in the
  module doc's bullet and the section heading of `Becoming.GrammarPath`, 07 §4.6's witnesses bullet (the PF line's
  home section), the root module's bullet and the checker's scope, all together. Each premise is needed for the laws
  (`Unclosed`, `Inconstant`); only holding the member's effects is needed for the reach (`«后皆续则所缘同于»`,
  `OtherLeaves`).
- (n) finding 18: "What leaves the class follows each alike step" becomes "... each alike occurrence" in the docstrings
  of `«本类出类随行»` and `«出类随行»`, the glossary's "alike occurrence".

The two wordings recur in three more places: the fourth law of the record what-a-line-holds-and-a-regularity-takes-in
(en and zh), the apart register's reason for `«出类随行»` and that result's note in regions.json. The owner said yes to
these too, word for word, the same day, so that the same wording lands everywhere at once, and asked for a history
line on that record; the script applies all of them and dates the line by the day it runs. No other live text has the
old wordings (the record's page, the generated pages and `becoming-verification.json` follow from the render and the
checker run).

`Becoming.GrammarPath` is pinned by that record among others, and 07 by the record constancy-read-at-a-members-class
(its statement reference), so after this script and the checker run the landing re-points the records research-check
names, each change read first (re-pointing writes no history note; the record's change of wording has the one added
here), and renders the generated pages.
usage (from the checkout root): python3 -B <kit>/deferred_grammarpath.py"""
import json
import sys
from datetime import date
from pathlib import Path

ROOT = Path.cwd()
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
GP = PKG / 'Becoming/GrammarPath.lean'
ROOT_DOC = PKG / 'Becoming.lean'
CHECKER = PKG / 'check_becoming.py'
CH7 = ROOT / 'theories/becoming/chapters/07-SIGNIFICANCE.md'
RF = ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation'
RECORD = ROOT / 'theories/becoming/results/records/what-a-line-holds-and-a-regularity-takes-in.json'
assert not sys.argv[1:], __doc__


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, text.count(old), old[:80])
    path.write_text(text.replace(old, new), encoding='utf-8')


# (m): neither premise can be dropped from these laws
edit(GP, """* **Neither premise can be dropped.** Where a member's line runs through a condition but the member's
  effects leave its class, a constant class holding the member with the condition does not take in
  what the condition feeds (`Unclosed`); and where the class is not constant, even up to the net's
  end at the member's class, a member whose effects it holds need not have what follows them alike to it
  (`Inconstant`).
""", """* **Neither premise can be dropped from these laws.** Where a member's line runs through a condition
  but the member's effects leave its class, a constant class holding the member with the condition
  does not take in what the condition feeds (`Unclosed`); and where the class is not constant, even
  up to the net's end at the member's class, a member whose effects it holds need not have what
  follows them alike to it (`Inconstant`).
""")
edit(GP, "/-! ## Neither premise can be dropped -/", "/-! ## Neither premise can be dropped from these laws -/")
edit(CH7, "- **Witnesses.** Neither premise can be dropped:", "- **Witnesses.** Neither premise can be dropped from these laws:")
edit(ROOT_DOC, """  (`«亡而网续则不至终有常»`). Witnesses that neither premise can be dropped (`Unclosed`, `Inconstant`),
  and a finite net with two families in which the one is not constant while one family's class,
  narrower than the one, is constant up to the net's end and the organism's is not
""", """  (`«亡而网续则不至终有常»`). Witnesses that neither premise can be dropped from these laws
  (`Unclosed`, `Inconstant`), and a finite net with two families in which the one is not constant while
  one family's class, narrower than the one, is constant up to the net's end and the organism's is not
""")
edit(CHECKER, '''    "witnesses that neither premise can be dropped, a finite net with two families, and one with a shared condition "''',
     '''    "witnesses that neither premise can be dropped from these laws, a finite net with two families, and one with a "
    "shared condition "''')

# (n): what leaves the class follows each alike occurrence
edit(GP, """/-- **What leaves the class follows each alike step (出类随行), at the member's class.** Under a class
constant up to the net's end at a member's class, where the member conditions something not alike to it,
whatever is alike to the member and conditions anything conditions something alike to that effect and
not alike to itself. -/""", """/-- **What leaves the class follows each alike occurrence (出类随行), at the member's class.** Under a
class constant up to the net's end at a member's class, where the member conditions something not alike
to it, whatever is alike to the member and conditions anything conditions something alike to that
effect and not alike to itself. -/""")
edit(GP, """/-- **What leaves the class follows each alike step (出类随行).** Under a class constant up to the net's
end, where a member conditions something not alike to it, whatever is alike to the member and
""", """/-- **What leaves the class follows each alike occurrence (出类随行).** Under a class constant up to the
net's end, where a member conditions something not alike to it, whatever is alike to the member and
""")

# both wordings where they recur: the record's fourth law with its history line, the apart register, regions.json
edit(RECORD, '"Neither premise can be dropped: where a member\'s line runs',
     '"Neither premise can be dropped from these laws: where a member\'s line runs')
edit(RECORD, '"二前提皆不可去：一员之线', '"此诸律二前提皆不可去：一员之线')
record = json.loads(RECORD.read_text(encoding='utf-8'))
day = date.today()
record['history'].append({
    'en': f"{day.day} {day:%B} {day.year}: the fourth law scoped to these laws, as OC5's review found; content unchanged.",
    'zh': f'{day.year}年{day.month}月{day.day}日：第 4 条规律限于此诸律，如 OC5 之审查所见；内容未变。'})
RECORD.write_text(json.dumps(record, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
edit(RF / 'THEOREM-CONNECTIVITY-APART.json', '"what leaves the class follows each alike step, under constancy',
     '"what leaves the class follows each alike occurrence, under constancy')
edit(ROOT / 'theories/becoming/results/data/regions.json',
     "what leaves the class follows each alike step\"", "what leaves the class follows each alike occurrence\"")
print('deferred GrammarPath edits applied')
