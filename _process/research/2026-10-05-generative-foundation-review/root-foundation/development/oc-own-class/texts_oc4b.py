#!/usr/bin/env python3
"""OC4, the PF line's places on its owner's answer: the letters (a)–(l) that OC4's landing proposed and left with the PF
line (study section 423), applied here with the same code as `texts_oc4.py`'s PF blocks, copied unchanged, without
OC4's own edits, which landed before. Each edit is asserted to apply once; the study section N is appended.
usage (from the checkout root): python3 -B <kit>/texts_oc4b.py N --pf LETTERS"""
import json
import sys
import textwrap
from pathlib import Path

ROOT = Path.cwd()
N = int(sys.argv[1])
PF = sys.argv[sys.argv.index('--pf') + 1]
assert PF and set(PF) <= set('abcdefghijkl'), PF
RF = ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation'
CH7 = ROOT / 'theories/becoming/chapters/07-SIGNIFICANCE.md'
PHIL = ROOT / 'theories/becoming/review/PHILOSOPHY.md'
DC = RF / 'DELEGATED-CHOICES.md'
STUDY = RF / 'BECOMING-RENEWAL-READING.md'
RECORDS = ROOT / 'theories/becoming/results/records'
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
Q = 'Quote [theories/becoming/chapters/07-SIGNIFICANCE.md]: '


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, text.count(old), old[:90])
    path.write_text(text.replace(old, new), encoding='utf-8')


def record(name, change, history_en, history_zh):
    path = RECORDS / f'{name}.json'
    text = path.read_text(encoding='utf-8')
    data = json.loads(text)
    change(data)
    data['history'].append({'en': history_en, 'zh': history_zh})
    indent = 2 if text.startswith('{\n  "') else 1
    path.write_text(json.dumps(data, ensure_ascii=False, indent=indent) + '\n', encoding='utf-8')


def swap(field, old, new):
    assert field.count(old) == 1, (field[:90], old[:60])
    return field.replace(old, new)


# --- the PF line, on its owner's answer ------------------------------------------------------------------------------
if set(PF) & set('abcd'):
    def what_leaves(data):
        if 'a' in PF:
            law = data['laws'][2]
            assert 'Becoming.FiniteWake.wake_follows' in law['declarations']
            law['en'] = ("In a finite net without cycles, a class holding a member and part of what follows it can be "
                         "constant up to the net's end though not constant, not holding the member's effects, while "
                         "something outside it follows every occurrence on its line that conditions anything; a witness.")
            law['zh'] = '于无环之有限之网中，含一员及其后之一部之类，可至网之终有常而非有常，不持此员之所缘，而其线上每一有所缘者皆有类外者随之；有见证。'
        if 'b' in PF:
            data['statement']['en'] = (
                "Under a class constant up to the net's end, what leaves the class at a member follows every alike "
                "occurrence that conditions anything, and one that conditions something but nothing alike to that effect "
                "breaks the condition; such a class can leave a member's effects out.")
            assert len(data['statement']['en']) <= 300
            data['statement']['zh'] = '于至网之终有常之类下，一员处出类者随每一有所缘之同类者；有所缘而无与该效同类者之同类者破此条件；此类可不持一员之所缘。'
        if 'c' in PF:
            shown = data['does_not_show'][2]
            assert shown['kind'] == 'converse' and 'three-block' in shown['en']
            shown['en'] = ("That the necessary condition suffices for constancy up to the net's end: even with two blocks "
                           "what stays in the class must follow too (a two-block net, checked in OC4's review), and with "
                           "more than two what leaves must follow as something alike to it, not only as something "
                           "outside (a three-block net, checked in the IV3 line's review of PF2).")
            shown['zh'] = '此必要条件足以至网之终有常：即使二块，留于类内者亦须随之（二块之网，见 OC4 之审查）；多于二块时，出类者须以与之同类者随之，非仅以类外者（三块之网，见 IV3 线对 PF2 之审查）。'
        if 'd' in PF:
            corr = data['correspondence']
            corr['en'] = swap(corr['en'], 'it can pass P2, and then is never clean, so',
                              'it can pass P2, and then, leaving some of its effects out, leaves something outside at '
                              'every alike occurrence that conditions anything, so')
            corr['zh'] = swap(corr['zh'], '可过 P2，过则必不净，故', '可过 P2，过则因遗其所缘之一部，每一有所缘之同类者皆有所遗于类外，故')

    places = [p for p, k in (('its third law', 'a'), ('its statement', 'b'), ('what it does not show', 'c'),
                             ('its correspondence', 'd')) if k in PF]
    places_zh = [p for p, k in (('第三律', 'a'), ('陈述', 'b'), ('其所不示', 'c'), ('对应项', 'd')) if k in PF]
    record('what-leaves-a-class-follows-its-line', what_leaves,
           f"27 October 2026: checked a second time (OC4), on its owner's answer: {', '.join(places)} made exact (the "
           "third law states its witness as one; the statement names the condition an alike occurrence breaks; even with "
           "two blocks what stays must follow, and with more what leaves must follow as something alike to it; passing "
           f"P2 said in place of \"never clean\"); content otherwise unchanged; study section {N}.",
           f"2026年10月27日：经第二次审查（OC4），依其主之答：{'、'.join(places_zh)}改精确；内容余皆未变；研究第 {N} 节。")
if 'e' in PF:
    edit(PKG / 'README.md', 'what leaves the class follows every alike step (`«出类随行»`',
         'what leaves the class follows every alike occurrence that conditions anything (`«出类随行»`')
    edit(PKG / 'README.zh.md', '出类者随每一同类之步（`«出类随行»`', '出类者随每一有所缘之同类者（`«出类随行»`')
if 'f' in PF:
    edit(CH7, "- (P3) One's line runs through the conditions one affects.", "- (P3) The conditions one affects feed other lines.")
    edit(PHIL, Q + "\"(P3) One's line runs through the conditions one affects.\"",
         Q + '"(P3) The conditions one affects feed other lines."')
if 'g' in PF:
    OLD_Q1 = "in acting, does one presuppose the significance of a line that ends, or of the regularity one's acts keep going?"
    NEW_Q1 = ("in acting, does one presuppose the significance of a line that ends while its last stage still conditions "
              "something, or of a regularity of one's own, under which one's line, once it takes a step, ends only where "
              "the net does?")
    edit(CH7, f'*{OLD_Q1}*', f'*{NEW_Q1}*')
    edit(CH7, "Denying P2 is coherent, since one can presuppose the significance of a line that ends.",
         "Denying P2 is coherent, since one can presuppose the significance of a line that ends while its last stage "
         "still conditions something.")
    edit(PHIL, f'{Q}"{OLD_Q1}"', f'{Q}"{NEW_Q1}"')
    edit(PHIL, "1. In acting, does one presuppose the significance of a line that ends, or of the regularity one's acts "
               "keep going?",
         "1. In acting, does one presuppose the significance of a line that ends while its last stage still conditions "
         "something, or of a regularity of one's own, under which one's line, once it takes a step, ends only where the "
         "net does?")
    edit(PHIL, f'{Q}"Denying P2 is coherent, since one can presuppose the significance of a line that ends."',
         f'{Q}"Denying P2 is coherent, since one can presuppose the significance of a line that ends while its last '
         'stage still conditions something."')
    edit(PHIL, "### P-20 The open question, sharpened: a line that ends, or the regularity one's acts keep going",
         "### P-20 The open question, sharpened: a line that ends while it still conditions something, or a regularity "
         "of one's own")
    edit(PHIL, "which the chapter's newest section (07 §4.6) puts as two questions: in acting, does one presuppose the "
               "significance of a line that ends, or of the regularity one's acts keep going?",
         "which the chapter's newest section (07 §4.6) puts as two questions: in acting, does one presuppose the "
         "significance of a line that ends while its last stage still conditions something, or of a regularity of one's "
         "own, under which one's line, once it takes a step, ends only where the net does?")
if 'h' in PF:
    OLD_Q2 = "are one's effects one's own, in the sense of whose losses count, not of what one answers for?"
    NEW_Q2 = "are all of one's effects one's own, in the sense of whose losses count, not of what one answers for?"
    edit(CH7, f'*{OLD_Q2}*', f'*{NEW_Q2}*')
    edit(PHIL, f'{Q}"{OLD_Q2}"', f'{Q}"{NEW_Q2}"')
    edit(PHIL, "2. Are one's effects one's own, in the sense of whose losses count,",
         "2. Are all of one's effects one's own, in the sense of whose losses count,")
    edit(PHIL, "And are one's effects one's own, in the sense of whose losses count, not of what one answers for?",
         "And are all of one's effects one's own, in the sense of whose losses count, not of what one answers for?")
if 'i' in PF:
    edit(CH7, "across lines where the conditions one affects feed them, and past one's own end.",
         "across lines where the conditions one affects feed them, and past the end of one's organism.")
    edit(PHIL, "across lines and past one's own end;", "across lines and past the end of one's organism;")
if 'j' in PF:
    edit(CH7, "But the effects that are one's own later stages are themselves conditioned through what one takes in, so "
              "such a partial holding draws its line by the identity in question [AI reading].",
         "One's later stages are effects too, conditioned through what one takes in; so a holding of only some effects "
         "must decide which effects are one's own by the very identity in question [AI reading].")
    edit(PHIL, f'{Q}"so such a partial holding draws its line by the identity in question".',
         f'{Q}"so a holding of only some effects must decide which effects are one\'s own by the very identity in '
         'question".')
if 'k' in PF:
    OLD_K = 'In time, self-concern alone is kin-shaped.'
    NEW_K = ('So, read with time and where lines share no condition, self-concern without the step reaches only one\'s '
             'own line of descent.')
    edit(CH7, f'(`FiniteFamilies.family_constant_to_end`, `FiniteFamilies.member_not_constant_at`). {OLD_K}',
         f'(`FiniteFamilies.family_constant_to_end`, `FiniteFamilies.member_not_constant_at`). {NEW_K}')
    edit(PHIL, f'{Q}"{OLD_K}"', f'{Q}"{NEW_K}"')
    edit(PHIL, "5. In time, self-concern alone is kin-shaped until lines share conditions one affects.",
         "5. Read with time, self-concern without the step reaches only one's own line of descent until lines share "
         "conditions one affects.")
if 'l' in PF:
    edit(CH7, "such a class, constant up to the net's end, has something outside it follow every alike occurrence that "
              "conditions anything ([above](#r-what-leaves-a-class-follows-its-line))",
         "such a class, meeting P2, has something outside it follow every alike occurrence that conditions anything "
         "(`«本类出类随行»`, [above](#r-what-leaves-a-class-follows-its-line))")

# --- the study section ------------------------------------------------------------------------------------------------
def fill(text):
    return textwrap.fill(text, width=118, subsequent_indent=' ' * 7, break_on_hyphens=False)


LETTERS = ', '.join(f'({k})' for k in PF)
LEFT = [k for k in 'abcdefghijkl' if k not in PF]
delta = fill(
    "Delta: PF2's record what-leaves-a-class-follows-its-line: its third law states its witness as one, its statement "
    "names the condition an alike occurrence breaks, what it does not show says that even with two blocks what stays "
    "must follow too and with more what leaves must follow as something alike to it, and its correspondence says what "
    "passing P2 asks; the package README rows say \"every alike occurrence that conditions anything\"; in 07 §4.6, P3 "
    "states what stays a correspondence (the conditions one affects feed other lines), the first question asks of a "
    "line that ends while its last stage still conditions something or of a regularity of one's own, under which one's "
    "line, once it takes a step, ends only where the net does, the second asks of all of one's effects, the conclusion "
    "passes the end of one's organism, the reply to the denial of P4 and step 2's last sentence are said exactly, and the "
    "denial of P4 cites «本类出类随行» for a class meeting P2; P-20, its title and the dossier's introduction follow. No "
    "law's statement changed." if not LEFT else
    f"Delta: the PF line's places {LETTERS} as OC4's landing proposed them (study section 423); P-20 and the dossier "
    "follow. No law's statement changed.")
study = f"""## {N}. The PF line's places after the second check (OC4, on its owner's answer)

OC4's review found twelve places in the PF line's texts; its landing proposed them to the line's owner as (a) to (l) and left them with it (§423). The owner answered yes to {'all twelve' if not LEFT else LETTERS}, word for word, after checking them against the texts and the Lean: `TwoBlocks` by hand for (c), that P3 follows from P4 in one step for (f), and that `«本类出类随行»` needs only the condition at one's own class for (l). They are applied here, so the findings of §423 that waited on them (A1, A6, A7, A12, B1, B2, B3, B5 and B6) are done as §423 describes. Where §423's last paragraph says the owner's answer "is on OC4's board row", this section records it.

```text
Result(s): none new; texts corrected.
{{delta}}
Supplied premises / correspondence: none.
Evidence: as in §423, with the owner's checks named above.
Boundary: the root module's bullet on what leaves the class waits, with OC3's deferral, for the next landing that
       rebuilds Becoming.GrammarPath, as the owner chose (development/oc-own-class/deferred_grammarpath.py applies both).
Output → input: 07 §4.6; PHILOSOPHY.md P-20 and its introduction; the record what-leaves-a-class-follows-its-line; the
       package README rows.
```
""".replace('{delta}', delta)
t = STUDY.read_text(encoding='utf-8')
assert f'\n## {N}. ' not in t and f'\n## {N - 1}. ' in t and "(OC4, on its owner's answer)" not in t
STUDY.write_text(t.rstrip('\n') + '\n\n' + study.strip('\n') + '\n', encoding='utf-8')
print(f"OC4's PF places: {LETTERS}; study {N}")
