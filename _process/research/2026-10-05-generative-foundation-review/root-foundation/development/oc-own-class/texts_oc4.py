#!/usr/bin/env python3
"""OC4: the crux's texts checked a second time ([review](REVIEW-OC4.md)); texts only, no Lean changed.

Always, in the IV3 and OC lines' own texts: P2 in 07 §4.6 (its consequence for a line that takes a step; the effects of
every alike occurrence), step 1 and D64 (need met only vacuously), the conclusion (the regularity's failure need give
nothing; P4 cannot be dropped), which class P2 reads (the same effects; a finer division said plainly), D64's reading in
§4.3 (what comes after every present center is reached, if at all, along a line under a coarser class or by the step of
invariance), P-15's quote of it, P-18's gloss of P2, P-20's P2, its scope sentence and its third question, the records
need-and-feeding-read-with-time and constancy-read-at-a-members-class (each with a history line) and D64 in
DELEGATED-CHOICES.

With `--pf LETTERS`, the PF line owner's answer, letters from a–l: (a)–(d) PF2's record what-leaves-a-class-follows-its-line
(third law, statement, what it does not show, correspondence) with a history line, (e) the package README rows, (f) P3,
(g) the first question and the denial of P2, (h) the second question, (i) the conclusion's end, (j) the reply to the
denial of P4, (k) step 2's last sentence, (l) the denial of P4's consequence; each in 07 and in P-20 or the dossier's
introduction where they quote or restate it. Each edit is asserted to apply once; the study section N is appended.
usage (from the checkout root): python3 -B <kit>/texts_oc4.py N [--pf LETTERS]"""
import json
import sys
import textwrap
from pathlib import Path

ROOT = Path.cwd()
N = int(sys.argv[1])
PF = sys.argv[sys.argv.index('--pf') + 1] if '--pf' in sys.argv else ''
assert set(PF) <= set('abcdefghijkl'), PF
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


# --- 07 §4.6, the IV3 and OC lines' texts ---------------------------------------------------------------------------
# A3, A4: P2's consequence needs a step; the outside division enters through the effects of every alike occurrence
edit(CH7, "It is a regularity of its own, and one's line ends only where the net itself ends "
          "(`«亡而网续则本类不至终有常»`). How the class divides what lies outside oneself enters through what is alike to "
          "an effect one leaves out; which division P2 reads is argued below.",
     "It is a regularity of its own: wherever one's line takes a step, it ends only where the net itself ends "
     "(`«亡而网续则本类不至终有常»`). A self that ends at once, a single moment, meets it trivially; with acting, P4 "
     "excludes that, since whatever one conditions is then alike to oneself and one's line takes a step. How the class "
     "divides what lies outside oneself enters through what is alike to an effect that an occurrence alike to oneself "
     "leaves out; which division P2 reads is argued below.")
# A9: step 1, need is met only vacuously
edit(CH7, "is needed only where nothing lets that continuation go on (`Flow.needs_iff_none_of_inactive`)",
     "is needed only where no such flow lets that continuation draw past the stock, that is, only vacuously "
     "(`Flow.needs_iff_none_of_inactive`)")
# A5: the regularity's failure need give nothing; P4 cannot be dropped at all
edit(CH7, "The regularity does real work: where it fails at one's own class, holding one's effects gives nothing beyond "
          "the first step (`Inconstant.not_constant_at`, `Inconstant.not_all_follow`), and without P4 the regularity "
          "gives nothing beyond the class (`Unclosed`).",
     "The regularity does real work: where it fails at one's own class, holding one's effects need give nothing beyond "
     "the first step (`Inconstant.not_constant_at`, `Inconstant.not_all_follow`). P4 cannot be dropped at all: an "
     "effect not alike to oneself lies on no line under one's class (`«线内同类»`), as `Unclosed` shows for a line that "
     "runs through a condition.")
# A4: which class P2 reads, the same effects
edit(CH7, "Where one does not hold them, the division enters P2 only through what is alike to an effect one leaves out "
          "(`«外分唯系出类之同»`).",
     "Where one does not hold them, the division enters P2 only through what is alike to an effect that an occurrence "
     "alike to oneself leaves out (`«外分唯系出类之同»`).")
# B4: what a finer division adds, said plainly
edit(CH7, "A finer division sorts what one leaves out by kind and asks each kind to recur at every occurrence alike to "
          "oneself that conditions anything (`FinerOutside`). That sorting does not change which effects are alike to "
          "oneself, since P4's predicate (`«所缘同于»`) reads only one's own class; what it asks is that one's effects "
          "recur by kinds drawn in what lies outside oneself, a regularity read off the rest's division, not off oneself. "
          "The split of oneself from the rest draws no kinds there and, where a predicate decides one's class, asks least "
          "(`«本类之常至二分»`); so P2 is read with it.",
     "What a finer division adds is a demand on what one's acts leave outside: every occurrence alike to oneself that "
     "conditions anything must leave something of each kind that any of them leaves (`FinerOutside`), the kinds being "
     "fixed by how what lies outside oneself is divided, not by oneself. It does not change which effects are alike to "
     "oneself, since P4's predicate (`«所缘同于»`) reads only one's own class. The split of oneself from the rest puts "
     "everything outside in one kind, so it adds no demand by kind and, where a predicate decides one's class, asks "
     "least (`«本类之常至二分»`); so P2 is read with it.")
# A8: D64's reading in §4.3
edit(CH7, "What comes after every present center is reached by a line under a class that continues past one's end "
          "([§4.5](#r-reach-past-ones-own-end), [§4.6](#future-path)) or by the step.",
     "What comes after every present center is reached, if at all, not along need but along a line under a class "
     "coarser than the organism, continuing past the organism's end ([§4.5](#r-reach-past-ones-own-end), "
     "[§4.6](#future-path)), or by the step of invariance.")

# --- the dossier, where it quotes or glosses those texts ------------------------------------------------------------
edit(PHIL, Q + '"What comes after every present center is reached by a line under a class that continues past one\'s '
               'end" (P-18), or by the step.',
     Q + '"What comes after every present center is reached, if at all, not along need but along a line under a class '
         'coarser than the organism, continuing past the organism\'s end" (P-18), or by the step of invariance.')
edit(PHIL, "07 §4.6 reads a regularity of one's own as constancy up to the net's end, a class under which a line ends "
           "only where the net itself ends (its P2, an AI reading).",
     "07 §4.6 reads a regularity of one's own as constancy up to the net's end at one's own class (its P2, an AI "
     "reading): whatever an occurrence alike to oneself conditions, every alike occurrence that conditions anything "
     "conditions something alike to it; this asks more than that one's line end only where the net does.")
edit(PHIL, Q + "\"It is a regularity of its own, and one's line ends only where the net itself ends\" "
               "(`«亡而网续则本类不至终有常»`, a root theorem); the condition asks more than that "
               "(`CleanStep.ends_where_net_ends`, `CleanStep.not_constant_at`).",
     Q + "\"It is a regularity of its own: wherever one's line takes a step, it ends only where the net itself ends\" "
         "(`«亡而网续则本类不至终有常»`, a root theorem); the condition asks more than that "
         "(`CleanStep.ends_where_net_ends`, `CleanStep.not_constant_at`), and a single moment meets it trivially, "
         "which P4 excludes for one who acts.")
edit(PHIL, "If either fails, that scope rests on the step.",
     "If P4 fails, that scope is not reached along one's line; if P2 fails, it is reached only where everything "
     "downstream of one's acts happens to be alike to oneself, and otherwise rests on the step.")
edit(PHIL, "so one's line ends only where the net itself ends, though the condition asks more.",
     "so wherever one's line takes a step, it ends only where the net itself ends, though the condition asks more.")

# --- D64 in DELEGATED-CHOICES ----------------------------------------------------------------------------------------
edit(DC, "a formation active at no step of it is needed only where nothing lets the continuation go on "
         "(`Flow.needs_iff_none_of_inactive`)",
     "a formation active at no step of it is needed only where no such flow lets the continuation draw past the stock, "
     "that is, only vacuously (`Flow.needs_iff_none_of_inactive`)")
edit(DC, "What lies after every present center's end is reached by a line under a class that continues past it "
         "(07 §4.5) or by the step (study section 397, IV3k).",
     "What lies after every present center's end is reached, if at all, not along need but along a line under a class "
     "coarser than the organism, continuing past that end (07 §4.5), or by the step of invariance (study section 397, "
     "IV3k).")


# --- the records -----------------------------------------------------------------------------------------------------
def need_and_feeding(data):
    shown, related = data['does_not_show'][0], data['related'][1]
    assert related['id'] == 'reach-past-ones-own-end'
    shown['en'] = swap(shown['en'], 'is reached by a line under a class that continues past it, or by the step',
                       'can be reached along a line under a class coarser than the organism, continuing past that end, '
                       'or by the step')
    shown['zh'] = swap(shown['zh'], '由过其终结而续的一类下之线达到', '可由比个体更粗之类下、过其终结而续之线达到')
    detail = related['detail']
    detail['en'] = swap(detail['en'], 'a line under a class that continues past it.',
                        'a line under a class coarser than the organism, continuing past it.')
    detail['zh'] = swap(detail['zh'], '过其终而续的一类下之线。', '比个体更粗之一类下、过其终而续之线。')


record('need-and-feeding-read-with-time', need_and_feeding,
       '27 October 2026: what it does not show and its related entry say that the line, under a class coarser than the '
       'organism, continues past the end (a line continues, not a class), and that successors can be reached so (OC4); '
       f'content unchanged; study section {N}.',
       f'2026年10月27日：其所不示与相关项言，过终而续者为比个体更粗之类下之线（续者为线，非类），后来者可由此达到（OC4）；内容未变；研究第 {N} 节。')


def constancy_read(data):
    law = data['laws'][2]
    assert 'Becoming.Inconstant.not_constant_at' in law['declarations']
    law['en'] = swap(law['en'], "and the class that holds a member's effects without the regularity fails it at the "
                                "member.",
                     "and in a witness where the class holds a member's effects but what follows them is not alike to "
                     "it, the class fails it at the member.")
    law['zh'] = swap(law['zh'], '持员之所缘而无此理之类，于此员处不成之。', '见证中类持一员之所缘而其后者不与之同类，此类于此员处不成之。')


record('constancy-read-at-a-members-class', constancy_read,
       "27 October 2026: checked a second time (OC4): its third law describes the witness's class instead of calling it "
       "one without the regularity; the history line of 25 October counted 9 imprecisions in OC2's review, which numbers "
       f"10 (findings 5 to 14, 18 findings in all); study section {N}.",
       f'2026年10月27日：经第二次审查（OC4）：其第三律述见证之类，不复称之为无此理者；10月25日之历史条记 OC2 之审查有 9 项不精确，实为 10 项（第 5 至 14 项，共 18 项）；研究第 {N} 节。')

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
LEFT = [k for k in 'abcdefghijkl' if k not in PF]


def pf(letters, done, left):
    """The disposition of a PF-line finding: done where every letter was applied, else left with the owner."""
    if all(k in PF for k in letters):
        return done
    if any(k in PF for k in letters):
        return done + f' ({", ".join(f"({k})" for k in letters if k not in PF)} left with the PF line\'s owner)'
    return left


def fill(text):
    return textwrap.fill(text, width=118, subsequent_indent=' ' * 7, break_on_hyphens=False)


pf_delta = []
if 'f' in PF:
    pf_delta.append('P3 says what stays a correspondence, that the conditions one affects feed other lines')
if 'g' in PF or 'h' in PF:
    pf_delta.append('the two questions say what P2 excludes and that P4 asks it of all one\'s effects'
                    if 'g' in PF and 'h' in PF else
                    ('the first question says what P2 excludes' if 'g' in PF else
                     'the second question asks of all one\'s effects'))
if set(PF) & set('ijkl'):
    pf_delta.append('the conclusion, step 2 and the denial of P4 said exactly' if set('ijkl') <= set(PF) else
                    'parts of the conclusion, step 2 and the denial of P4 said exactly')
if set(PF) & set('abcd'):
    pf_delta.append('PF2\'s record what-leaves-a-class-follows-its-line made exact')
if 'e' in PF:
    pf_delta.append('the package README rows say every alike occurrence that conditions anything')
delta = fill(
    "Delta: P2 states its consequence for a line that takes a step, and says that a single moment meets it trivially "
    "and that P4, with acting, excludes that; the outside division is said to enter through the effects of every "
    "occurrence alike to oneself, as «外分唯系出类之同» asks; the conclusion says that where the regularity fails holding "
    "one's effects need give nothing beyond the first step, and that P4 cannot be dropped at all («线内同类»); what a "
    "finer division adds is said plainly; step 1 and D64 say need is met there only vacuously; D64's reading says what "
    "comes after every present center is reached, if at all, along a line under a class coarser than the organism, "
    "continuing past its end, or by the step of invariance; the third law of constancy-read-at-a-members-class "
    "describes its witness" + ''.join(f'; {x}' for x in pf_delta) + "; P-15, P-18 and P-20 follow. No law's statement "
    "changed.")
output = fill(
    "Output → input: 07 §4.3 and §4.6; PHILOSOPHY.md P-15, P-18 and P-20" + (" and its introduction" if set(PF) & set('gh')
                                                                             else "")
    + ("; the records constancy-read-at-a-members-class, need-and-feeding-read-with-time and "
       "what-leaves-a-class-follows-its-line" if set(PF) & set('abcd') else
       "; the records constancy-read-at-a-members-class and need-and-feeding-read-with-time")
    + "; D64 in DELEGATED-CHOICES" + ("; the package README rows" if 'e' in PF else "") + ".")
findings = [
    "*A1, error.* PF2's record stated its third law, a witness, as a law: `CleanStep` is finite and without cycles, its "
    "class holds the member and part of what follows it, and it is not constant up to the net's end. "
    + pf('a', 'The law now says \"can be\" and calls itself a witness.', 'Left with the PF line\'s owner.'),
    "*A2, error.* P-18 glossed P2 by its consequence and for the whole class; §411 (finding 8) had corrected that gloss "
    "in 07 and P-20 only. It now states the condition at one's own class and says the condition asks more.",
    "*A3, imprecise.* P2's consequence, that one's line ends only where the net does, holds for a line that takes a "
    "step: `«亡而网续则本类不至终有常»` needs one, and a single moment meets P2 trivially (the review's `moment_at` and "
    "`ZeroStep`). P2 now says so and that P4, with acting, excludes it (the review's `acting_held_continues`); P-20 follows.",
    "*A4, imprecise.* \"An effect one leaves out\" said more than `«外分唯系出类之同»`, whose hypothesis covers the effects "
    "of every occurrence alike to the member; the stronger form holds where one acts (the review's `ownOutside`), and "
    "no landed Lean states it. Both places now say \"an effect that an occurrence alike to oneself leaves out\".",
    "*A5, imprecise.* The conclusion read two witnesses as laws (\"gives nothing\"), and said that without P4 the "
    "regularity gives nothing beyond the class, which holds with P4 too, since no line leaves its class "
    "(`«线内同类»`). It now says \"need give nothing\" and that P4 cannot be dropped at all. P-20's \"If either fails, "
    "that scope rests on the step\" was too strong for P2: the reach is exactly everything downstream of one's acts "
    "being alike to oneself (the review's `reach_iff_downstream_alike`), so P4 is necessary and P2 is not (`NoP2`). It "
    "now says what each failure leaves.",
    "*A6, imprecise.* P3, \"one's line runs through the conditions one affects\", follows from P4 (the review's "
    "`p3_of_p4`) and does no work in steps 3 and 4. "
    + pf('f', 'P3 now states what stays a correspondence, that the conditions one affects feed other lines.',
         'Left with the PF line\'s owner.'),
    "*A7, imprecise.* PF2's record: its statement named constancy where the law breaks constancy up to the net's end, "
    "and \"step\" stood for an alike occurrence; what it does not show implied that two blocks suffice, which they do "
    "not where what stays fails to follow (the review's `TwoBlocks`), while the three-block net refutes only \"something "
    "outside follows\" (the lander's verification, section 6 of the report); \"never clean\" was undefined. "
    + pf('bcde', 'Each made exact, and the package README rows say \"every alike occurrence that conditions anything\".',
         'Left with the PF line\'s owner.')
    + " The root module's bullet keeps \"a step with nothing outside the class breaks it\" until the next landing that "
    "rebuilds the module.",
    "*A8, imprecise.* D64's reading said that what comes after every present center \"is reached by a line under a "
    "class that continues past one's end\": §4.6 reaches it only under its premises, a line continues, not a class, and "
    "\"the step\" stood among time steps. It now says \"is reached, if at all, not along need but along a line under a "
    "class coarser than the organism, continuing past the organism's end, or by the step of invariance\", in 07, P-15, "
    "the record need-and-feeding-read-with-time and D64. The review's \"can be reached only\" was not taken: no Lean "
    "shows that no third route exists.",
    "*A9, imprecise.* Step 1 said need is met \"only where nothing lets that continuation go on\"; the law speaks of "
    "flows that let it draw past the stock, and \"go on\" is 延. It now says \"only where no such flow lets that "
    "continuation draw past the stock, that is, only vacuously\", in 07 and in D64, which had the same words. The module "
    "doc names `FiniteDescent`, which is no declaration; `FiniteFamilies.one_not_constant` is meant.",
    "*A10, imprecise.* §411 and §413; corrected below.",
    "*A11, clarity.* The third law of constancy-read-at-a-members-class was circular (\"without the regularity fails "
    "it\"). It now describes its witness: the class holds the member's effects, and what follows them is not alike to it.",
    "*A12, clarity.* The denial of P4 said \"constant up to the net's end\" where P2 asks the condition only at one's own "
    "class. " + pf('l', 'It now says \"meeting P2\" and cites `«本类出类随行»`.', 'Left with the PF line\'s owner.')
    + " `FinerWake` has no lemma that its finer division is a class, as `FinerOutside.finer_class` is.",
    "*B1.* The first question asked of \"a line that ends\", though in a finite net without cycles every line ends, "
    "P2's included; what P2 excludes is a line that ends while its last stage still conditions something, and \"one's "
    "acts keep going\" built in P4. "
    + pf('g', 'The question, the denial of P2, P-20\'s title and question and the dossier\'s introduction now say so.',
         'Left with the PF line\'s owner.'),
    "*B2.* Under P2 one's own line ends only where the net does, so the conclusion's \"past one's own end\" is the "
    "organism's end. " + pf('i', 'It now says so, in 07 and P-20.', 'Left with the PF line\'s owner.'),
    "*B3.* P4 asks the second question of all one's effects, and holding only some is the denial the text offers. "
    + pf('h', 'The question now says \"all\".', 'Left with the PF line\'s owner.'),
    "*B4.* The sentence on finer divisions could not be followed. It now says what a finer division adds: every "
    "occurrence alike to oneself that conditions anything must leave something of each kind that any of them leaves, "
    "the kinds fixed by how what lies outside oneself is divided.",
    "*B5.* The reply to the denial of P4 said \"draws its line by the identity in question\". "
    + pf('j', 'It now says that one\'s later stages are effects too, so a holding of only some effects must decide which '
              'are one\'s own by that identity.', 'Left with the PF line\'s owner.'),
    "*B6.* \"Kin-shaped\" was a metaphor resting on `TwoLines`, where lines share nothing. "
    + pf('k', 'Step 2 now says that, read with time and where lines share no condition, self-concern without the step '
              'reaches only one\'s own line of descent.', 'Left with the PF line\'s owner.'),
]
left_items = ''
if LEFT:
    left_items = (f"The PF line's places ({', '.join(f'({k})' for k in LEFT)}) wait for its owner, whose answer is on OC4's "
                  "board row. ")
study = f"""## {N}. The crux's texts checked a second time (OC4)

One independent reviewer, a separate AI agent working read-only, checked 07 §4.6 again after OC2 and OC3 (§411, §413): its home sections and argument, D64's reading in §4.3, the philosophers' dossier where it quotes or glosses them (P-15, P-18, P-20), the records constancy-read-at-a-members-class and what-leaves-a-class-follows-its-line, and §411 and §413. It read them against `Becoming.GrammarPath` and as a philosopher would ([report](development/oc-own-class/REVIEW-OC4.md)), and tested each doubt in scratch Lean, 14 checks with every axiom report empty. No proof was wrong. It found 2 errors, 8 imprecisions and 2 clarity points against the Lean, and 6 places where a philosopher could not follow the text. Each was verified against the Lean before it was fixed, and each holds; two suggested wordings were narrowed (A7's three-block clause and A8's "only"; the report's section 6). The purpose is the dossier: P-20 is its centre, and it should say what the Lean shows before the packet is frozen.

```text
Result(s): none new; texts corrected.
{delta}
Supplied premises / correspondence: none.
Evidence: Becoming.GrammarPath unchanged (core receipt 20261025T160649.851818Z); the review's scratch Lean
       (development/oc-own-class/review-oc4/OC4Doubts.lean; Lean 4.29.1, Init only, every axiom report empty).
Boundary: the scratch checks are evidence for the wording, not results, and no text cites them as results; P2's
       reading at one's own class, with the split, stays argued [AI reading], and P4 stays the crux.
{output}
```

**The findings, and what was done.**
""" + '\n'.join(f'- {f}' for f in findings) + f"""

**Corrections to §411.**
- It counted "4 errors, 9 imprecisions and 4 clarity points"; the review it reports numbers 10 imprecisions (findings 5 to 14), 18 findings in all. The same count stands in that review's own summary, in the history line of 25 October of constancy-read-at-a-members-class (a line of 27 October now corrects it) and on OC2's board row.
- Its Delta's "a finer division breaks it even where every alike occurrence both stays and leaves (FinerWake)" means every alike occurrence that conditions anything: in `FinerWake` two alike occurrences condition nothing.
- In "What it says", the claim that what P2 asks of a self that acts and holds its effects does not depend on how what it leaves out is divided holds, but its reason, "since nothing leaves", holds only where P2 holds. Where P2 fails, it fails under every such division too, since by `«闭则外分无关»` it would otherwise hold under the first.

**Correction to §413.** "In a finite net it still ends, later" holds in a finite net without cycles; on a cycle a line goes on (延) (the review's `FiniteCycle`).

**Left.** {left_items}For the next landing that rebuilds `Becoming.GrammarPath`, which applies them: the module doc's first sentence (OC3's deferral), its `FiniteDescent`, the root module's bullet on what leaves the class, and a class lemma for `FinerWake`'s finer division. The review's scratch laws (`ownOutside`, `reach_iff_downstream_alike`, `p4_of_reach`) would let the texts say more where they now say less: that the outside division enters only through one's own leaving effects where one acts, and that P2 is sufficient with P4 for the reach but not necessary. Landing them is a choice for that landing.
"""
t = STUDY.read_text(encoding='utf-8')
assert f'\n## {N}. ' not in t and f'\n## {N - 1}. ' in t and '(OC4)' not in t
STUDY.write_text(t.rstrip('\n') + '\n\n' + study.strip('\n') + '\n', encoding='utf-8')
print(f'OC4 texts: own edits; PF letters {PF or "none"}; study {N}')
