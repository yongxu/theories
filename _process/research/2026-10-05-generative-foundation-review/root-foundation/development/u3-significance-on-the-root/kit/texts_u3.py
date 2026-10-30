#!/usr/bin/env python3
"""U3's texts at landing (from the checkout root, after make_records_u3.py and master_laws.py): the live lines that say
the significance rows wait for the root, or count one instance of the condition on it, and F5's counts. Each edit is a
current passage and its replacement; every current passage must occur exactly once. F5's counts are read from
theories/becoming/results/data/master-laws.json and must be the projected ones (from the report before U3: the three
central declarations U3 restates on their own carrier, resting on order's anchor without reaching it, move from "the
rest" to "stated on its own carrier only"); otherwise the script stops, to be read and the texts redrafted. The receipt
is filled into FU's PROPOSAL. One record's next step changes with 07 §4.5, its home section.
The texts follow the review of the first draft through three lenses (REVIEW-U3-TEXTS.md) and OU's note on what 全四
counts (WHAT-REMAINS): 全四 as F4 defines it, always with F5's figure; the three specializations never called
restatements; the reading named as the live chapters name it, the own-closure reading.
  python3 -B texts_u3.py --check RECEIPT    asserts everything; writes nothing
  python3 -B texts_u3.py --apply RECEIPT"""
import datetime
import json
import sys
from pathlib import Path

ROOT = Path.cwd()
MODE, RECEIPT = sys.argv[1], sys.argv[2]
B = 'theories/becoming/'
DEV = '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/'
U3 = '../../../' + DEV + 'u3-significance-on-the-root/DESIGN.md'
U2 = '../../../' + DEV + 'u2-rows-on-the-root/DESIGN.md'
M7 = '08-METHOD.md#master-laws-and-connectivity'
PROJECTED = {'reaching the grammar': 44, 'stated at a represented model': 16, 'stated on its own carrier only': 7,
             'the rest': 51}
CENTRAL_EN = ("Of significance's five central laws, two are restated in the grammar's terms on their own carrier, one of "
              "them through weights, amounts the grammar has none of, and three are specialized at {reading}, each "
              "stating less than its row; none is derived from the root, and the condition (scope) and C (order) stay "
              "premises ([08 §7]({link})).")
CENTRAL_ZH = ("意义的五条中心之律中，两条在其自身的载体上以文法的词语重新陈述，其中一条经由权重，即文法所无的量；三条在{reading}下特化，"
              "所述少于本条；无一由根推出，延续条件（定范围）与 C（定次序）仍为前提（[08 §7]({link})）。")
LAWS_07 = ("Of significance's central laws, comparison by widening is restated in the grammar's terms on its own carrier, "
           "and what every positive weighting ranks as an interface law whose weights are amounts the grammar has none "
           "of; the laws that read the condition are specialized at its own-closure reading, each stating less than its "
           "row; each is proved through its row and none is derived from the root ([08 §7]({link})).")

EDITS = [
    ("08 §7, F5's counts", B + 'chapters/08-METHOD.md',
     "Of those 24, 20 are stated where their terms are the grammar's, each proved through its row and declared on its "
     "row's record as a statement at a model, a representation and not a derivation "
     f"([U2]({U2})); three resist, their terms amounts computed over a family; and one, "
     "`unrestricted_iff_livingSignificance`, waits for the significance rows' statement on the root. So F5's report, "
     "over the 118, counts 44 reaching the grammar, 16 stated at a represented model, 4 stated on their own carrier "
     "only, and 54 the rest.",
     "Of those 24, 20 are stated where their terms are the grammar's, each proved through its row and declared on its "
     "row's record: 16 at a represented model, representations and not derivations, and 4 on their own carrier "
     f"([U2]({U2})); three resist, their terms amounts computed over a family; and one, "
     "`unrestricted_iff_livingSignificance`, is specialized on a web's level paths at the own-closure reading of "
     f"significance ([U3]({U3})). Of the 7 resting on another master law's anchor without reaching it, U3 restates "
     "three in the grammar's terms on their own carrier (C's extension and comparison on a web's level paths, and what "
     "every positive weighting ranks, an interface law whose weights are amounts the grammar has none of) and "
     "specializes two at that reading; the other two, `Direction.extension_iff_widens` on the moves' frame and "
     "`PartForms.goAlike`, keep their reasons. A specialization states less than its row, so F5 takes none of the "
     "three specializations as an item. So F5's report, over the 118, counts 44 reaching the grammar, 16 stated at a "
     "represented model, 7 stated on their own carrier only (U2's 4 and U3's 3), and 51 the rest."),
    ("01, open: the root and the ethics", B + 'chapters/01-ROOT.md',
     "The free significance of 07 §1 is not lifted, and the ethics' other laws are instances not yet stated on the root;",
     "The free significance of 07 §1 is not lifted. " + LAWS_07.format(link=M7).replace("each is proved through its row and none", "none")
     + " The ethics' other laws are instances not yet stated on the root;"),
    ("07, thesis: the open condition on the root", B + 'chapters/07-SIGNIFICANCE.md',
     "and the condition on the root beyond one instance.",
     "and the condition on the root beyond the laws stated there."),
    ("07 §4.5, the instances proved", B + 'chapters/07-SIGNIFICANCE.md',
     "one instance is proved: on every reading where a claim's significance",
     "one instance is proved here: on every reading where a claim's significance"),
    ("07 §4.5, three more instances", B + 'chapters/07-SIGNIFICANCE.md',
     "[record](../results/records/the-continuation-condition-on-the-root.md)). Read so, the condition has no "
     "significance parameter",
     "[record](../results/records/the-continuation-condition-on-the-root.md)). Three more are proved on a web's level "
     "paths, each in its own record: the condition as living significance over admission "
     "([§3.2](#r-continuation-condition-yields-living-significance)), widening as retaining and adding within one's own "
     "line ([§2](#r-significance-retained-within-margin)) and the three readings of one predicate "
     "([§4.4](#r-comparison-by-widening)). Read so, the condition has no significance parameter"),
    ("07, open: the condition on the root beyond the laws stated there", B + 'chapters/07-SIGNIFICANCE.md',
     "- **The condition on the root's grammar, beyond one instance**: held de se along a relation the condition is the "
     "[root's](#r-the-continuation-condition-on-the-root) at the one of that relation; the free significance of §1 is "
     "not lifted, and the chapter's other laws are instances not yet stated on the root.",
     "- **The condition on the root's grammar, beyond the laws stated there**: held de se along a relation the "
     "condition is the [root's](#r-the-continuation-condition-on-the-root) at the one of that relation; the free "
     "significance of §1 is not lifted. " + LAWS_07.format(link=M7) + " The chapter's other laws are instances not yet "
     "stated on the root."),
    ("the one page, the root and the ethics", B + 'ONE-PAGE.md',
     "it holds only with one center ([significance](chapters/07-SIGNIFICANCE.md#r-the-continuation-condition-on-the-root)). "
     "The free significance is not lifted onto the root",
     "it holds only with one center ([significance](chapters/07-SIGNIFICANCE.md#r-the-continuation-condition-on-the-root)). "
     + CENTRAL_EN.format(reading='that de se reading', link='chapters/' + M7) + " The free significance is not lifted "
     "onto the root"),
    ("the one page (Chinese), the root and the ethics", B + 'ONE-PAGE.zh.md',
     "它只在只有一个中心时成立（[意义](chapters/07-SIGNIFICANCE.md#r-the-continuation-condition-on-the-root)）。自由的意义尚未提升到根上",
     "它只在只有一个中心时成立（[意义](chapters/07-SIGNIFICANCE.md#r-the-continuation-condition-on-the-root)）。"
     + CENTRAL_ZH.format(reading='此从己的读法', link='chapters/' + M7) + "自由的意义尚未提升到根上"),
    ("the overview, the root and the ethics", B + 'THE-THEORY-OF-BECOMING.md',
     "The free significance of 07 §1 is not lifted onto the root, the chapter's other laws are instances not yet stated "
     "on it, and which class a center's own line runs under is open ([07](chapters/07-SIGNIFICANCE.md#open)).",
     "The free significance of 07 §1 is not lifted onto the root. "
     + CENTRAL_EN.format(reading='the own-closure reading', link='chapters/' + M7) + " The chapter's other laws are "
     "instances not yet stated on it, and which class a center's own line runs under is open "
     "([07](chapters/07-SIGNIFICANCE.md#open))."),
    ("the overview (Chinese), the root and the ethics", B + 'THE-THEORY-OF-BECOMING.zh.md',
     "07 §1 的自由意义尚未提升到根上，该章的其他律是尚未在根上陈述的实例，一个中心自己的相续在哪个类之下进行，仍属未决"
     "（[07](chapters/07-SIGNIFICANCE.md#open)）。",
     "07 §1 的自由意义尚未提升到根上。" + CENTRAL_ZH.format(reading='自闭包读法', link='chapters/' + M7)
     + "该章的其他律是尚未在根上陈述的实例，一个中心自己的相续在哪个类之下进行，仍属未决（[07](chapters/07-SIGNIFICANCE.md#open)）。"),
    ("the review packet, PHILOSOPHY: the condition on the root", B + 'review/PHILOSOPHY.md',
     "One instance is proved: where every formation lies on every center's line under the one of the relation, then on "
     "every reading where a claim has significance from a standpoint whenever its formation lies within that "
     "standpoint's center's closure, living significance follows (`premises_of_noOutside`).",
     "One instance is proved here: where every formation lies on every center's line under the one of the relation, "
     "then on every reading where a claim has significance from a standpoint whenever its formation lies within that "
     "standpoint's center's closure, living significance follows (`premises_of_noOutside`); three more of the ethics' "
     "central laws are specialized at this reading on a web's level paths, each in its own record (U3)."),
    ("the review packet, BUDDHIST-THOUGHT: the condition on the root", B + 'review/BUDDHIST-THOUGHT.md',
     "伦理诸律中只有一例在此读下证出（生命意义之诸前提，`premises_of_noOutside`），其余尚未在根上陈述。",
     "伦理诸律中在此读下证出者，有生命意义之诸前提（`premises_of_noOutside`），及三条中心之律在网之水平路径上之特化（U3），"
     "其余尚未在根上陈述。"),
    ("FU's PROPOSAL, U3's outcome", DEV + 'fu-full-unification/PROPOSAL.md',
     "C stays a premise, and the free predicate stays the general form. Owner: whoever holds 07's significance results, "
     "with SW's note as the reading.\n",
     "C stays a premise, and the free predicate stays the general form. Owner: whoever holds 07's significance results, "
     "with SW's note as the reading.\n\n"
     "*U3's outcome* ([DESIGN.md](../u3-significance-on-the-root/DESIGN.md), 30 October 2026; the design reviewed before "
     "the Lean, the Lean and the records kit read by two independent readers, the landing texts through three lenses; "
     "core receipt `" + RECEIPT + "`, every axiom report empty).\n"
     "- An extension of level paths with every claim counted is the grammar's `«广»` of what the paths admit, through "
     "OU3b's `Web.widens_iff`; for every reading of `living`, C holds on level paths with \"better\" read as that "
     "`«广»`, its being better C's content, supplied (`Web.paths_extension_iff_widens`, `Web.paths_comparison_widens`).\n"
     "- Weightings meet the root through one interface law: on a finite list with two-valued admission, `«广»` is what "
     "every additive natural-number weighting positive on the listed items ranks higher "
     "(`Weighting.widens_iff_every_positive`). The weights are amounts, the second sort of U1's verdict, not units.\n"
     "- The condition at its own-closure reading is `«续无外»` at the one of the relation (GS2), and "
     "`unrestricted_iff_livingSignificance`, `Web.widens_iff_retains_adds` and `Web.paths_one_object` are specialized "
     "there: each fixes significance at one reading, so F5 takes none as an item.\n"
     "- 全四 for the significance rows is met as F4 defines it: each row has its root form, the condition and C stay "
     "named premises, and the free predicate stays the general form. F5's stricter count takes two of the five "
     "(`Web.paths_comparison_widens`, `Weighting.widens_iff_every_positive`; with `Web.paths_extension_iff_widens`, "
     "capacity's) as stated on their own carrier and keeps the three specializations among the rest "
     "([WHAT-REMAINS](../ou3b-master-laws-on-the-grammar/WHAT-REMAINS.md), \"U3's standing, and what 全四 counts\"). "
     "The free significance is not lifted, and the condition (scope) and C (order) stay premises.\n"),
]

RECORD = B + 'results/records/the-continuation-condition-on-the-root.json'
NEXT_OLD = {'en': "The chapter's other theorems that take the condition stated as instances through the root's;",
            'zh': "本章以条件为前提之其他定理，经根之条件述为其例；"}
NEXT_NEW = {'en': "Beyond the three stated at the own-closure reading on a web's level paths (U3), the chapter's other "
                  "theorems that take the condition stated as instances through the root's;",
            'zh': "除于网之水平路径上、自闭包读下所述之三条（U3）外，本章以条件为前提之其他定理，经根之条件述为其例；"}

counts = json.loads((ROOT / B / 'results/data/master-laws.json').read_text(encoding='utf-8'))['central_reach']['counts']
assert counts == PROJECTED, ('F5 counts differ from the projected ones: read the report and redraft', counts)
for label, path, old, new in EDITS:
    text = (ROOT / path).read_text(encoding='utf-8')
    assert text.count(old) == 1, (label, text.count(old))
    assert new not in text, (label, 'present already')
record = json.loads((ROOT / RECORD).read_text(encoding='utf-8'))
for lang in ('en', 'zh'):
    assert record['next_delta'][lang].startswith(NEXT_OLD[lang]), (lang, record['next_delta'][lang][:80])
if MODE == '--apply':
    for label, path, old, new in EDITS:
        p = ROOT / path
        p.write_text(p.read_text(encoding='utf-8').replace(old, new, 1), encoding='utf-8')
    for lang in ('en', 'zh'):
        record['next_delta'][lang] = NEXT_NEW[lang] + record['next_delta'][lang][len(NEXT_OLD[lang]):]
    record['reviewed_at_utc'] = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
    (ROOT / RECORD).write_text(json.dumps(record, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print(('applied' if MODE == '--apply' else 'checked'), len(EDITS), 'edits and one next step; F5', counts)
